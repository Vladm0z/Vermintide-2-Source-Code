-- chunkname: @scripts/managers/backend_playfab/backend_interface_item_playfab.lua

BackendInterfaceItemPlayfab = class(BackendInterfaceItemPlayfab)

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceItemPlayfab.init = function (self, arg_1_1)
	-- function 1
	self._loadouts = {}
	self._items = {}
	self._game_mode_specific_items = {}
	self._backend_mirror = arg_1_1
	self._career_loadouts = {}
	self._default_loadouts = {}
	self._default_loadout_overrides = {}
	self._selected_career_custom_loadouts = {}
	self._bot_loadouts = {}
	self._dirty_weapon_pose_skins = {}
	self._last_id = 0
	self._delete_deeds_request = {}
	self._is_deleting_deeds = false

	self:_refresh()
end

local tbl = {
	"slot_ranged",
	"slot_melee",
	"slot_skin",
	"slot_hat",
	"slot_necklace",
	"slot_ring",
	"slot_trinket_1",
	"slot_frame",
	"slot_pose"
}

BackendInterfaceItemPlayfab._refresh = function (self)
	-- function 2
	if not DEDICATED_SERVER then
		self:_refresh_career_loadouts()
		self:_refresh_default_loadouts()
		self:_setup_default_overrides()
	end

	self:_refresh_items()
	self:_refresh_loadouts()

	if not DEDICATED_SERVER then
		self:refresh_bot_loadouts()
	end

	self._dirty = false

	self:_unmark_favorites()
end

BackendInterfaceItemPlayfab._refresh_items = function (self)
	-- function 3
	local _backend_mirror = self._backend_mirror
	local get_all_inventory_items = _backend_mirror:get_all_inventory_items()
	local get_unlocked_weapon_skins = _backend_mirror:get_unlocked_weapon_skins()
	local get_unlocked_cosmetics = _backend_mirror:get_unlocked_cosmetics()

	for k, v in pairs(get_all_inventory_items) do
		if not ((v.bypass_skin_ownership_check or not v.skin) and get_unlocked_weapon_skins[v.skin]) then
			v.skin = nil
		end
	end

	if not self._active_game_mode_specific_items then
		self._items = table.clone(get_all_inventory_items)

		for k_2, v_2 in pairs(self._active_game_mode_specific_items) do
			self._items[k_2] = v_2
		end
	else
		self._items = get_all_inventory_items
	end

	self._fake_items = _backend_mirror:get_all_fake_inventory_items()

	local get_new_backend_ids = ItemHelper.get_new_backend_ids()

	if not get_new_backend_ids then
		for k_3, v_3 in pairs(get_new_backend_ids) do
			if not get_all_inventory_items[k_3] then
				ItemHelper.unmark_backend_id_as_new(k_3, true)
			end
		end

		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

BackendInterfaceItemPlayfab._unmark_favorites = function (self)
	-- function 4
	local get_favorite_backend_ids = ItemHelper.get_favorite_backend_ids()

	if not get_favorite_backend_ids then
		local _items = self._items

		for k, v in pairs(get_favorite_backend_ids) do
			if not (_items[k] or self:get_backend_id_from_cosmetic_item(k)) then
				ItemHelper.unmark_backend_id_as_favorite(k)
			end
		end
	end
end

BackendInterfaceItemPlayfab._refresh_loadouts = function (self)
	-- function 5
	local _loadouts = self._loadouts
	local _backend_mirror = self._backend_mirror

	for k, v in pairs(CareerSettings) do
		if not v.playfab_name then
			for k_2 = 1, #tbl do
				local var_5_2 = tbl[k_2]
				local get_character_data = _backend_mirror:get_character_data(k, var_5_2)
				local var_5_4 = _loadouts[k]

				var_5_4 = var_5_4 or {}
				_loadouts[k] = var_5_4
				_loadouts[k][var_5_2] = get_character_data
			end
		end
	end
end

local tbl_2 = {}

BackendInterfaceItemPlayfab.refresh_bot_loadouts = function (self)
	-- function 6
	self._bot_loadouts = table.clone(self._loadouts)

	local _bot_loadouts = self._bot_loadouts
	local _backend_mirror = self._backend_mirror
	local loadout_selection = PlayerData.loadout_selection

	loadout_selection = loadout_selection or tbl_2

	local bot_equipment = loadout_selection.bot_equipment

	bot_equipment = bot_equipment or tbl_2

	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local var_6_5 = InventorySettings.bot_loadout_allowed_mechanisms[current_mechanism_name]

	for k, v in pairs(CareerSettings) do
		if not v.playfab_name then
			local flag = not var_6_5 and bot_equipment[k]

			if not flag then
				if not _backend_mirror:has_loadout(k, flag) then
					bot_equipment[k] = nil
					flag = nil
				end

				for k_2 = 1, #tbl do
					local var_6_7 = tbl[k_2]
					local get_character_data = _backend_mirror:get_character_data(k, var_6_7, flag)
					local var_6_9 = _bot_loadouts[k]

					var_6_9 = var_6_9 or {}
					_bot_loadouts[k] = var_6_9
					_bot_loadouts[k][var_6_7] = get_character_data
				end
			end
		end
	end

	print("[BackendInterfaceItemPlayfab] Refreshing bot loadout")
end

BackendInterfaceItemPlayfab._refresh_career_loadouts = function (self)
	-- function 7
	local _career_loadouts = self._career_loadouts
	local _backend_mirror = self._backend_mirror

	table.clear(_career_loadouts)

	for k, v in pairs(CareerSettings) do
		if not v.playfab_name then
			local var_7_2 = _career_loadouts[k]

			var_7_2 = var_7_2 or {}
			_career_loadouts[k] = var_7_2

			local var_7_3 = _career_loadouts[k]
			local get_career_loadouts, var_7_5 = _backend_mirror:get_career_loadouts(k)

			self._selected_career_custom_loadouts[k] = get_career_loadouts

			if not var_7_5 then
				for k_2 = 1, #var_7_5 do
					local var_7_6 = var_7_3[k_2]

					var_7_6 = var_7_6 or {}
					var_7_3[k_2] = var_7_6

					local var_7_7 = var_7_3[k_2]
					local var_7_8 = var_7_5[k_2]

					for l = 1, #tbl do
						local var_7_9 = tbl[l]

						var_7_7[var_7_9] = var_7_8[var_7_9]
					end
				end
			end
		end
	end
end

BackendInterfaceItemPlayfab._refresh_default_loadouts = function (self)
	-- function 8
	local _default_loadouts = self._default_loadouts
	local _backend_mirror = self._backend_mirror

	table.clear(_default_loadouts)

	for k, v in pairs(CareerSettings) do
		if not v.playfab_name then
			local var_8_2 = _default_loadouts[k]

			var_8_2 = var_8_2 or {}
			_default_loadouts[k] = var_8_2

			local var_8_3 = _default_loadouts[k]
			local get_default_loadouts = _backend_mirror:get_default_loadouts(k)

			if not get_default_loadouts then
				for k_2 = 1, #get_default_loadouts do
					local var_8_5 = var_8_3[k_2]

					var_8_5 = var_8_5 or {}
					var_8_3[k_2] = var_8_5

					local var_8_6 = var_8_3[k_2]
					local var_8_7 = get_default_loadouts[k_2]

					for l = 1, #tbl do
						local var_8_8 = tbl[l]

						var_8_6[var_8_8] = var_8_7[var_8_8]
					end
				end
			end
		end
	end
end

BackendInterfaceItemPlayfab._setup_default_overrides = function (self)
	-- function 9
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local var_9_1

	if not PlayerData.loadout_selection then
		var_9_1 = PlayerData.loadout_selection[current_mechanism_name]

		if not var_9_1 then
			-- Nothing
		end
	end

	var_9_1 = {}

	::label_9_0::

	table.clear(self._default_loadout_overrides)

	if not var_9_1 then
		return
	end

	local game_mode = Managers.state.game_mode

	game_mode = not game_mode and Managers.state.game_mode:game_mode_key()

	if not (not game_mode and InventorySettings.default_loadout_allowed_game_modes[game_mode]) then
		return
	end

	for k, v in pairs(CareerSettings) do
		local var_9_3 = var_9_1[k]

		var_9_3 = var_9_3 or 1

		if not (not var_9_3 and InventorySettings.loadouts[var_9_3].loadout_type ~= "default") then
			self:set_default_override(k, var_9_3)
		end
	end
end

BackendInterfaceItemPlayfab.set_loadout_index = function (self, arg_10_1, arg_10_2)
	-- function 10
	self._backend_mirror:set_loadout_index(arg_10_1, arg_10_2)
	Managers.telemetry_events:loadout_equipped()
end

BackendInterfaceItemPlayfab.add_loadout = function (self, arg_11_1)
	-- function 11
	self._backend_mirror:add_loadout(arg_11_1)

	local get_career_loadouts = self:get_career_loadouts(arg_11_1)

	Managers.telemetry_events:loadout_created(#get_career_loadouts, InventorySettings.MAX_NUM_CUSTOM_LOADOUTS)
end

BackendInterfaceItemPlayfab.delete_loadout = function (self, arg_12_1, arg_12_2)
	-- function 12
	self._backend_mirror:delete_loadout(arg_12_1, arg_12_2)

	local get_career_loadouts = self:get_career_loadouts(arg_12_1)

	Managers.telemetry_events:loadout_deleted(#get_career_loadouts, InventorySettings.MAX_NUM_CUSTOM_LOADOUTS)
end

BackendInterfaceItemPlayfab.set_default_override = function (self, arg_13_1, arg_13_2)
	-- function 13
	local var_13_0 = self._default_loadouts[arg_13_1]

	self._default_loadout_overrides[arg_13_1] = not var_13_0 and var_13_0[arg_13_2]
end

BackendInterfaceItemPlayfab.get_default_override = function (self, arg_14_1)
	-- function 14
	return self._default_loadout_overrides[arg_14_1]
end

BackendInterfaceItemPlayfab.ready = function (self)
	-- function 15
	if not self._items then
		return true
	end

	return false
end

BackendInterfaceItemPlayfab.type = function (arg_16_0)
	-- function 16
	return "backend"
end

BackendInterfaceItemPlayfab.update = function (arg_17_0)
	-- function 17
	return
end

BackendInterfaceItemPlayfab.refresh_entities = function (arg_18_0)
	-- function 18
	return
end

BackendInterfaceItemPlayfab.check_for_errors = function (arg_19_0)
	-- function 19
	return
end

BackendInterfaceItemPlayfab.num_current_item_server_requests = function (arg_20_0)
	-- function 20
	return 0
end

BackendInterfaceItemPlayfab.set_properties_serialized = function (arg_21_0, arg_21_1, arg_21_2)
	-- function 21
	return
end

BackendInterfaceItemPlayfab.get_traits = function (self, arg_22_1)
	-- function 22
	local get_item_from_id = self:get_item_from_id(arg_22_1)

	if not get_item_from_id then
		return get_item_from_id.traits
	end

	return nil
end

BackendInterfaceItemPlayfab.set_runes = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	return
end

BackendInterfaceItemPlayfab.get_runes = function (arg_24_0, arg_24_1)
	-- function 24
	return
end

BackendInterfaceItemPlayfab.socket_rune = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	return
end

BackendInterfaceItemPlayfab.get_skin = function (self, arg_26_1)
	-- function 26
	return self:get_item_from_id(arg_26_1).skin
end

BackendInterfaceItemPlayfab.get_item_masterlist_data = function (self, arg_27_1)
	-- function 27
	local get_item_from_id = self:get_item_from_id(arg_27_1)

	if not get_item_from_id then
		return get_item_from_id.data
	end
end

BackendInterfaceItemPlayfab.get_item_amount = function (self, arg_28_1)
	-- function 28
	local RemainingUses = self:get_item_from_id(arg_28_1).RemainingUses

	RemainingUses = RemainingUses or 1

	return RemainingUses
end

BackendInterfaceItemPlayfab.get_item_power_level = function (self, arg_29_1)
	-- function 29
	return self:get_item_from_id(arg_29_1).power_level
end

BackendInterfaceItemPlayfab.get_item_rarity = function (self, arg_30_1)
	-- function 30
	return self:get_item_from_id(arg_30_1).rarity
end

BackendInterfaceItemPlayfab.get_key = function (self, arg_31_1)
	-- function 31
	return self:get_item_from_id(arg_31_1).key
end

BackendInterfaceItemPlayfab.get_item_from_id = function (self, arg_32_1)
	-- function 32
	return self:get_all_backend_items()[arg_32_1]
end

BackendInterfaceItemPlayfab.get_backend_id_from_cosmetic_item = function (self, arg_33_1)
	-- function 33
	return self._backend_mirror:get_unlocked_cosmetics()[arg_33_1]
end

BackendInterfaceItemPlayfab.get_item_from_key = function (self, arg_34_1)
	-- function 34
	local get_all_backend_items = self:get_all_backend_items()

	for k, v in pairs(get_all_backend_items) do
		if v.key == arg_34_1 then
			return v
		end
	end
end

BackendInterfaceItemPlayfab.get_weapon_skin_from_skin_key = function (self, arg_35_1)
	-- function 35
	local get_all_fake_backend_items = self:get_all_fake_backend_items()

	for k, v in pairs(get_all_fake_backend_items) do
		if v.skin == arg_35_1 then
			return k, v
		end
	end
end

BackendInterfaceItemPlayfab.free_inventory_slots = function (self)
	-- function 36
	local get_all_backend_items = self:get_all_backend_items()
	local num = 0
	local is_fake_item = ItemHelper.is_fake_item

	for k, v in pairs(get_all_backend_items) do
		if not is_fake_item(v.data.item_type) then
			num = num + 1
		end
	end

	return UISettings.max_inventory_items - num
end

BackendInterfaceItemPlayfab.get_all_backend_items = function (self)
	-- function 37
	if not self._dirty then
		self:_refresh()
	end

	return self._items
end

BackendInterfaceItemPlayfab.get_all_fake_backend_items = function (self)
	-- function 38
	if not self._dirty then
		self:_refresh()
	end

	return self._fake_items
end

BackendInterfaceItemPlayfab.get_loadout = function (self)
	-- function 39
	if not self._dirty then
		self:_refresh()
	end

	local clone = table.clone(self._loadouts)

	for k, v in pairs(self._default_loadout_overrides) do
		clone[k] = v
	end

	return clone
end

BackendInterfaceItemPlayfab.get_bot_loadout = function (self)
	-- function 40
	if not self._dirty then
		self:_refresh()
	end

	return self._bot_loadouts
end

BackendInterfaceItemPlayfab.get_career_loadouts = function (self, arg_41_1)
	-- function 41
	if not self._dirty then
		self:_refresh()
	end

	return self._career_loadouts[arg_41_1]
end

BackendInterfaceItemPlayfab.get_selected_career_loadout = function (self, arg_42_1)
	-- function 42
	if not self._dirty then
		self:_refresh()
	end

	return self._selected_career_custom_loadouts[arg_42_1]
end

BackendInterfaceItemPlayfab.get_default_loadouts = function (self, arg_43_1)
	-- function 43
	if not self._dirty then
		self:_refresh()
	end

	return self._default_loadouts[arg_43_1]
end

BackendInterfaceItemPlayfab.get_loadout_by_career_name = function (self, arg_44_1, arg_44_2)
	-- function 44
	if not self._dirty then
		self:_refresh()
	end

	local game_mode = Managers.state.game_mode

	game_mode = not game_mode and Managers.state.game_mode:game_mode_key()

	local var_44_1 = InventorySettings.bot_loadout_allowed_game_modes[game_mode]
	local var_44_2 = InventorySettings.default_loadout_allowed_game_modes[game_mode]
	local flag = not var_44_1 and self:get_bot_loadout()
	local flag_2 = not var_44_1 and flag[arg_44_1]
	local flag_3 = not var_44_2 and self:get_default_loadouts(arg_44_1)
	local flag_4 = not var_44_2 and not flag_3 and flag_3[1]
	local var_44_7 = self:get_loadout()[arg_44_1]

	return not var_44_1 and not arg_44_2 and flag_2 and not arg_44_2 or not var_44_2 and flag_4 and var_44_7
end

BackendInterfaceItemPlayfab.get_loadout_item_id = function (self, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	local game_mode = Managers.state.game_mode

	game_mode = not game_mode and Managers.state.game_mode:game_mode_key()

	local var_45_1 = InventorySettings.bot_loadout_allowed_game_modes[game_mode]
	local var_45_2 = InventorySettings.default_loadout_allowed_game_modes[game_mode]
	local flag = not var_45_1 and self:get_bot_loadout()
	local flag_2 = not var_45_1 and flag[arg_45_1]
	local flag_3 = not var_45_2 and self:get_default_loadouts(arg_45_1)
	local flag_4 = not var_45_2 and not flag_3 and flag_3[1]
	local var_45_7 = self:get_loadout()[arg_45_1]
	local flag_5 = not var_45_1 and not arg_45_3 and not table.is_empty(flag_2) and flag_2 and not arg_45_3 or not var_45_2 and flag_4 and var_45_7
	local flag_6 = not flag_5 and flag_5[arg_45_2]

	if not CosmeticUtils.is_cosmetic_slot(arg_45_2) and not flag_6 then
		return self._backend_mirror:get_unlocked_cosmetics()[flag_6]
	elseif arg_45_2 ~= "slot_pose" or not flag_6 then
		local parent = ItemMasterList[flag_6].parent
		local get_unlocked_weapon_poses = self:get_unlocked_weapon_poses()
		local var_45_12 = get_unlocked_weapon_poses[parent]

		var_45_12 = not var_45_12 and get_unlocked_weapon_poses[parent][flag_6]

		return var_45_12
	end

	return not flag_5 and flag_5[arg_45_2]
end

BackendInterfaceItemPlayfab.get_unlocked_weapon_poses = function (self)
	-- function 46
	return self._backend_mirror:get_unlocked_weapon_poses()
end

BackendInterfaceItemPlayfab.get_dirty_weapon_pose_data = function (self)
	-- function 47
	return {
		equipped_weapon_pose_skin = self._dirty_weapon_pose_skins
	}
end

BackendInterfaceItemPlayfab.clear_dirty_weapon_pose_data = function (self)
	-- function 48
	table.clear(self._dirty_weapon_pose_skins)
end

BackendInterfaceItemPlayfab.get_equipped_weapon_pose_skins = function (self)
	-- function 49
	return self._backend_mirror:get_equipped_weapon_pose_skins()
end

BackendInterfaceItemPlayfab.get_equipped_weapon_pose_skin = function (self, arg_50_1)
	-- function 50
	return self._backend_mirror:get_equipped_weapon_pose_skin(arg_50_1)
end

BackendInterfaceItemPlayfab.get_weapon_pose_from_pose_key = function (self, arg_51_1)
	-- function 51
	local get_all_fake_backend_items = self:get_all_fake_backend_items()

	for k, v in pairs(get_all_fake_backend_items) do
		if v.item_type == "weapon_pose" then
			return k, v
		end
	end
end

BackendInterfaceItemPlayfab.get_backend_id_from_unlocked_weapon_poses = function (self, arg_52_1)
	-- function 52
	local parent = ItemMasterList[arg_52_1].parent
	local var_52_1 = self:get_unlocked_weapon_poses()[parent]

	return not var_52_1 and var_52_1[arg_52_1]
end

BackendInterfaceItemPlayfab.set_weapon_pose_skin = function (self, arg_53_1, arg_53_2, arg_53_3)
	-- function 53
	if not arg_53_2 then
		local var_53_0 = self._backend_mirror:get_equipped_weapon_pose_skins()[arg_53_1]

		if self:get_weapon_skin_from_skin_key(var_53_0) ~= arg_53_2 then
			local skin = self:get_item_from_id(arg_53_2).skin

			self._dirty_weapon_pose_skins[arg_53_1] = skin

			self._backend_mirror:set_weapon_pose_skin(arg_53_1, skin)
		end
	end
end

BackendInterfaceItemPlayfab.get_cosmetic_loadout = function (self, arg_54_1, arg_54_2)
	-- function 54
	local game_mode = Managers.state.game_mode

	game_mode = not game_mode and Managers.state.game_mode:game_mode_key()

	local var_54_1 = InventorySettings.bot_loadout_allowed_game_modes[game_mode]
	local var_54_2 = InventorySettings.default_loadout_allowed_game_modes[game_mode]
	local flag = not var_54_1 and self:get_bot_loadout()
	local flag_2 = not var_54_1 and flag[arg_54_1]
	local flag_3 = not var_54_2 and self:get_default_loadouts(arg_54_1)
	local flag_4 = not var_54_2 and not flag_3 and flag_3[1]
	local var_54_7 = self:get_loadout()[arg_54_1]
	local flag_5 = not var_54_1 and not arg_54_2 and flag_2 and not arg_54_2 or not var_54_2 and flag_4 and var_54_7

	return flag_5.slot_hat, flag_5.slot_skin, flag_5.slot_frame
end

BackendInterfaceItemPlayfab.get_item_name = function (self, arg_55_1)
	-- function 55
	return self:get_all_backend_items()[arg_55_1].key
end

local tbl_3 = {}

BackendInterfaceItemPlayfab.get_filtered_items = function (self, arg_56_1, arg_56_2)
	-- function 56
	local get_all_backend_items = self:get_all_backend_items()

	return (Managers.backend:get_interface("common"):filter_items(get_all_backend_items, arg_56_1, arg_56_2 or tbl_3))
end

BackendInterfaceItemPlayfab.set_loadout_item = function (self, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
	-- function 57
	local get_all_backend_items = self:get_all_backend_items()
	local var_57_1

	if not arg_57_1 then
		var_57_1 = get_all_backend_items[arg_57_1]

		fassert(var_57_1, "Trying to equip item that doesn't exist %d", arg_57_1 or "nil")
	end

	if not var_57_1 then
		print("[BackendInterfaceItemPlayfab] Attempted to equip weapon that doesn't exist:", arg_57_1, arg_57_2, arg_57_3)

		return false
	end

	if var_57_1.rarity == "magic" then
		print("[BackendInterfaceItemPlayfab] Attempted to equip magic weapon in adventure:", arg_57_1, arg_57_2, arg_57_3)

		return false
	end

	if not CosmeticUtils.is_cosmetic_slot(arg_57_3) then
		arg_57_1 = var_57_1.override_id or var_57_1.ItemId
	end

	if arg_57_3 == "slot_pose" then
		arg_57_1 = var_57_1.override_id or var_57_1.ItemId
	end

	self._backend_mirror:set_character_data(arg_57_2, arg_57_3, arg_57_1, nil, arg_57_4)

	self._dirty = true

	return true
end

BackendInterfaceItemPlayfab.add_steam_items = function (self, arg_58_1)
	-- function 58
	self._backend_mirror:add_steam_items(arg_58_1)
	self:_refresh_items()
end

local tbl_4 = {
	weapon_pose = true,
	weapon_skin = true,
	item = true,
	loot_chest = true,
	keep_decoration_painting = true
}

BackendInterfaceItemPlayfab.get_unseen_item_rewards = function (self)
	-- function 59
	local get_user_data = self._backend_mirror:get_user_data("unseen_rewards")

	if not get_user_data then
		return nil
	end

	local decode = cjson.decode(get_user_data)
	local var_59_2
	local num = 1

	while num <= #decode do
		local var_59_4 = decode[num]
		local reward_type = var_59_4.reward_type

		if tbl_4[reward_type] or not CosmeticUtils.is_cosmetic_item(reward_type) then
			var_59_2 = var_59_2 or {}
			var_59_2[#var_59_2 + 1] = var_59_4

			table.remove(decode, num)
		else
			num = num + 1
		end
	end

	if not var_59_2 then
		self._backend_mirror:set_user_data("unseen_rewards", cjson.encode(decode))
	end

	return var_59_2
end

BackendInterfaceItemPlayfab.remove_item = function (arg_60_0, arg_60_1, arg_60_2)
	-- function 60
	return
end

BackendInterfaceItemPlayfab.award_item = function (arg_61_0, arg_61_1)
	-- function 61
	return
end

BackendInterfaceItemPlayfab.data_server_script = function (arg_62_0, arg_62_1, ...)
	-- function 62
	return
end

BackendInterfaceItemPlayfab.upgrades_failed_game = function (arg_63_0, arg_63_1, arg_63_2)
	-- function 63
	return
end

BackendInterfaceItemPlayfab.poll_upgrades_failed_game = function (arg_64_0)
	-- function 64
	return
end

BackendInterfaceItemPlayfab.generate_item_server_loot = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6)
	-- function 65
	return
end

BackendInterfaceItemPlayfab.check_for_loot = function (arg_66_0)
	-- function 66
	return
end

BackendInterfaceItemPlayfab.equipped_by = function (self, arg_67_1)
	-- function 67
	local get_loadout = self:get_loadout()
	local tbl = {}

	for k, v in pairs(get_loadout) do
		for k_2, v_2 in pairs(v) do
			if arg_67_1 == v_2 then
				table.insert(tbl, k)
			end
		end
	end

	return tbl
end

local tbl_5 = {}

BackendInterfaceItemPlayfab.equipped_by_loadout = function (self, arg_68_1)
	-- function 68
	local _career_loadouts = self._career_loadouts

	table.clear(tbl_5)

	for k, v in pairs(_career_loadouts) do
		for i, v_2 in ipairs(v) do
			for k_2, v_3 in pairs(v_2) do
				if arg_68_1 == v_3 then
					local var_68_1 = tbl_5
					local var_68_2 = tbl_5[k]

					var_68_2 = var_68_2 or {}
					var_68_1[k] = var_68_2
					tbl_5[k][#tbl_5[k] + 1] = i
				end
			end
		end

		if not tbl_5[k] then
			tbl_5[k].num_loadouts = #v
		end
	end

	return tbl_5
end

BackendInterfaceItemPlayfab.is_equipped_by_any_loadout = function (self, arg_69_1)
	-- function 69
	local _career_loadouts = self._career_loadouts
	local tbl = {}

	for k, v in pairs(_career_loadouts) do
		for i, v_2 in ipairs(v) do
			for k_2, v_3 in pairs(v_2) do
				if arg_69_1 == v_3 then
					table.insert(tbl, k .. "_" .. i)
				end
			end
		end
	end

	return tbl
end

BackendInterfaceItemPlayfab.is_equipped = function (arg_70_0, arg_70_1, arg_70_2)
	-- function 70
	return
end

BackendInterfaceItemPlayfab.set_data_server_queue = function (arg_71_0, arg_71_1)
	-- function 71
	return
end

BackendInterfaceItemPlayfab.make_dirty = function (self)
	-- function 72
	self._dirty = true
end

BackendInterfaceItemPlayfab.has_item = function (self, arg_73_1)
	-- function 73
	local get_all_backend_items = self:get_all_backend_items()

	for k, v in pairs(get_all_backend_items) do
		if arg_73_1 == v.key then
			return true
		end
	end

	return false
end

BackendInterfaceItemPlayfab.has_weapon_illusion = function (self, arg_74_1)
	-- function 74
	local get_all_fake_backend_items = self:get_all_fake_backend_items()

	for k, v in pairs(get_all_fake_backend_items) do
		if arg_74_1 == v.skin then
			return true
		end
	end

	return false
end

BackendInterfaceItemPlayfab.has_bundle_contents = function (self, arg_75_1)
	-- function 75
	if not arg_75_1 then
		return false, false, nil
	end

	local flag = true
	local flag_2 = false
	local tbl = {}

	for i = 1, #arg_75_1 do
		local var_75_3 = arg_75_1[i]
		local var_75_4 = SteamitemdefidToMasterList[var_75_3]
		local required_dlc = ItemMasterList[var_75_4].required_dlc

		if not (not required_dlc and Managers.unlock:is_dlc_unlocked(required_dlc) or table.find(tbl, required_dlc)) then
			tbl[#tbl + 1] = required_dlc
		end

		if self:has_item(var_75_4) or not self:has_weapon_illusion(var_75_4) then
			flag_2 = true
		else
			flag = false
		end
	end

	return flag, flag_2, tbl
end

BackendInterfaceItemPlayfab.get_item_template = function (arg_76_0, arg_76_1, arg_76_2)
	-- function 76
	local temporary_template = arg_76_1.temporary_template

	temporary_template = temporary_template or arg_76_1.template

	local get_weapon_template = WeaponUtils.get_weapon_template(temporary_template)

	if not get_weapon_template then
		return get_weapon_template
	end

	local var_76_2 = Attachments[temporary_template]

	if not var_76_2 then
		return var_76_2
	end

	local var_76_3 = Cosmetics[temporary_template]

	if not var_76_3 then
		return var_76_3
	end

	fassert(false, "no item_template for item: " .. arg_76_1.key .. ", template name = " .. temporary_template)
end

BackendInterfaceItemPlayfab.sum_best_power_levels = function (self)
	-- function 77
	local sum_of_best_power_levels_override = script_data.sum_of_best_power_levels_override

	if not sum_of_best_power_levels_override then
		return sum_of_best_power_levels_override
	else
		return self._backend_mirror.sum_best_power_levels
	end
end

BackendInterfaceItemPlayfab.configure_game_mode_specific_items = function (arg_78_0, arg_78_1, arg_78_2)
	-- function 78
	arg_78_0._game_mode_specific_items[arg_78_1] = arg_78_2
end

BackendInterfaceItemPlayfab.set_game_mode_specific_items = function (self, arg_79_1)
	-- function 79
	self._active_game_mode_specific_items = self._game_mode_specific_items[arg_79_1]

	self:make_dirty()
end

BackendInterfaceItemPlayfab.refresh_game_mode_specific_items = function (self)
	-- function 80
	self:make_dirty()
end

local num = 300

BackendInterfaceItemPlayfab.delete_marked_deeds = function (self, arg_81_1, arg_81_2, arg_81_3)
	-- function 81
	self._is_deleting_deeds = true
	arg_81_2 = arg_81_2 or 1
	arg_81_3 = arg_81_3 or num

	local _new_id = self:_new_id()
	local var_81_1
	local count = #arg_81_1

	if arg_81_2 > 1 then
		var_81_1 = table.slice(arg_81_1, arg_81_2, count)
	else
		var_81_1 = arg_81_1
	end

	local map = table.map(var_81_1, function (self)
		-- function 82
		return {
			ItemInstanceId = self.ItemInstanceId
		}
	end)

	if arg_81_3 < count then
		for i = num + 1, count do
			map[i] = nil
		end
	end

	local tbl = {
		FunctionName = "deleteMarkedDeeds",
		FunctionParameter = {
			marked_deeds_list = map
		}
	}
	local tbl_2 = {
		marked_deeds_list = map,
		id = _new_id
	}
	local var_81_6 = callback(self, "delete_marked_deeds_request_cb", tbl_2, arg_81_3, arg_81_2, arg_81_1)

	self._backend_mirror:request_queue():enqueue(tbl, var_81_6, true)
end

BackendInterfaceItemPlayfab.delete_marked_deeds_request_cb = function (self, arg_83_1, arg_83_2, arg_83_3, arg_83_4, arg_83_5)
	-- function 83
	local FunctionResult = arg_83_5.FunctionResult
	local item_revokes = FunctionResult.item_revokes
	local _backend_mirror = self._backend_mirror

	if not FunctionResult then
		Managers.backend:playfab_api_error(arg_83_5)

		return
	elseif FunctionResult.error_message == "no_items_received" then
		Managers.backend:playfab_error(BACKEND_PLAYFAB_ERRORS.ERR_REMOVE_DEEDS_NO_ITEMS_RECEIVED)

		return
	end

	if not item_revokes then
		for i = 1, #item_revokes do
			local ItemInstanceId = item_revokes[i].ItemInstanceId

			_backend_mirror:remove_item(ItemInstanceId)
		end
	end

	if arg_83_2 < #arg_83_4 then
		local num_2 = arg_83_3 + num
		local num_3 = arg_83_2 + num

		self:delete_marked_deeds(arg_83_4, num_2, num_3)
	else
		self._is_deleting_deeds = false

		Managers.backend:dirtify_interfaces()
	end
end

BackendInterfaceItemPlayfab.is_deleting_deeds = function (self)
	-- function 84
	return self._is_deleting_deeds
end

BackendInterfaceItemPlayfab._new_id = function (self)
	-- function 85
	self._last_id = self._last_id + 1

	return self._last_id
end

BackendInterfaceItemPlayfab.can_delete_deeds = function (arg_86_0, arg_86_1, arg_86_2)
	-- function 86
	if #arg_86_1 == #arg_86_2 then
		return true, arg_86_1, arg_86_2
	end

	local tbl = {}
	local tbl_2 = {}
	local var_86_2 = arg_86_1

	for i, v in ipairs(arg_86_2) do
		local index_of = table.index_of(var_86_2, v)

		if index_of ~= -1 then
			table.insert(tbl_2, v)
			table.swap_delete(var_86_2, index_of)
		end
	end

	if not table.is_empty(tbl_2) then
		return false, var_86_2, nil
	end

	return true, var_86_2, tbl_2
end
