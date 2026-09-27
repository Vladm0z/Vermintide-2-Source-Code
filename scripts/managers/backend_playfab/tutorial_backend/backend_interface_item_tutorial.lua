-- chunkname: @scripts/managers/backend_playfab/tutorial_backend/backend_interface_item_tutorial.lua

BackendInterfaceItemTutorial = class(BackendInterfaceItemTutorial)

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceItemTutorial.init = function (self, arg_1_1)
	-- function 1
	self._loadouts = {}
	self._items = {}
	self._backend_mirror = arg_1_1

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
	"slot_frame"
}

BackendInterfaceItemTutorial._refresh = function (self)
	-- function 2
	self:_refresh_items()
	self:_refresh_loadouts()

	self._dirty = false
end

BackendInterfaceItemTutorial._refresh_items = function (self)
	-- function 3
	self._items = {
		{
			key = "es_longbow_tutorial",
			rarity = "default",
			power_level = 10,
			backend_id = 1,
			data = ItemMasterList.es_longbow_tutorial
		},
		{
			key = "es_2h_hammer_tutorial",
			rarity = "default",
			power_level = 10,
			backend_id = 2,
			data = ItemMasterList.es_2h_hammer_tutorial
		},
		{
			key = "skin_es_knight",
			backend_id = 3,
			rarity = "default",
			data = ItemMasterList.skin_es_knight
		},
		{
			key = "knight_hat_0000",
			backend_id = 4,
			rarity = "default",
			data = ItemMasterList.knight_hat_0000
		},
		{
			key = "dr_crossbow",
			rarity = "default",
			power_level = 10,
			backend_id = 5,
			data = ItemMasterList.dr_crossbow
		},
		{
			key = "dr_1h_axe",
			rarity = "default",
			power_level = 10,
			backend_id = 6,
			data = ItemMasterList.dr_1h_axe
		},
		{
			key = "skin_dr_ranger",
			backend_id = 7,
			rarity = "default",
			data = ItemMasterList.skin_dr_ranger
		},
		{
			key = "ranger_hat_0000",
			backend_id = 8,
			rarity = "default",
			data = ItemMasterList.ranger_hat_0000
		},
		{
			key = "we_longbow",
			rarity = "default",
			power_level = 10,
			backend_id = 9,
			data = ItemMasterList.we_longbow
		},
		{
			key = "we_dual_wield_daggers",
			rarity = "default",
			power_level = 10,
			backend_id = 10,
			data = ItemMasterList.we_dual_wield_daggers
		},
		{
			key = "skin_ww_waywatcher",
			backend_id = 11,
			rarity = "default",
			data = ItemMasterList.skin_ww_waywatcher
		},
		{
			key = "waywatcher_hat_0000",
			backend_id = 12,
			rarity = "default",
			data = ItemMasterList.waywatcher_hat_0000
		},
		{
			key = "bw_skullstaff_fireball",
			rarity = "default",
			power_level = 10,
			backend_id = 13,
			data = ItemMasterList.bw_skullstaff_fireball
		},
		{
			key = "bw_1h_mace",
			rarity = "default",
			power_level = 10,
			backend_id = 14,
			data = ItemMasterList.bw_1h_mace
		},
		{
			key = "skin_bw_adept",
			backend_id = 15,
			rarity = "default",
			data = ItemMasterList.skin_bw_adept
		},
		{
			key = "adept_hat_0000",
			backend_id = 16,
			rarity = "default",
			data = ItemMasterList.adept_hat_0000
		}
	}
end

BackendInterfaceItemTutorial._refresh_loadouts = function (self)
	-- function 4
	self._loadouts = {
		empire_soldier_tutorial = {
			slot_skin = 3,
			slot_melee = 2,
			slot_hat = 4,
			slot_ranged = 1
		},
		dr_ranger = {
			slot_skin = 7,
			slot_melee = 6,
			slot_hat = 8,
			slot_ranged = 5
		},
		we_waywatcher = {
			slot_skin = 11,
			slot_melee = 10,
			slot_hat = 12,
			slot_ranged = 9
		},
		bw_adept = {
			slot_skin = 15,
			slot_melee = 14,
			slot_hat = 16,
			slot_ranged = 13
		}
	}
end

BackendInterfaceItemTutorial.ready = function (self)
	-- function 5
	if not self._items then
		return true
	end

	return false
end

BackendInterfaceItemTutorial.type = function (arg_6_0)
	-- function 6
	return "backend"
end

BackendInterfaceItemTutorial.update = function (arg_7_0)
	-- function 7
	return
end

BackendInterfaceItemTutorial.refresh_entities = function (arg_8_0)
	-- function 8
	return
end

BackendInterfaceItemTutorial.check_for_errors = function (arg_9_0)
	-- function 9
	return
end

BackendInterfaceItemTutorial.num_current_item_server_requests = function (arg_10_0)
	-- function 10
	return 0
end

BackendInterfaceItemTutorial.set_properties_serialized = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	return
end

BackendInterfaceItemTutorial.get_traits = function (self, arg_12_1)
	-- function 12
	local get_item_from_id = self:get_item_from_id(arg_12_1)

	if not get_item_from_id then
		return get_item_from_id.traits
	end

	return nil
end

BackendInterfaceItemTutorial.set_runes = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	return
end

BackendInterfaceItemTutorial.get_runes = function (arg_14_0, arg_14_1)
	-- function 14
	return
end

BackendInterfaceItemTutorial.socket_rune = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	return
end

BackendInterfaceItemTutorial.get_skin = function (arg_16_0)
	-- function 16
	return nil
end

BackendInterfaceItemTutorial.get_item_masterlist_data = function (self, arg_17_1)
	-- function 17
	local get_item_from_id = self:get_item_from_id(arg_17_1)

	if not get_item_from_id then
		return get_item_from_id.data
	end
end

BackendInterfaceItemTutorial.get_item_amount = function (self, arg_18_1)
	-- function 18
	local RemainingUses = self:get_item_from_id(arg_18_1).RemainingUses

	RemainingUses = RemainingUses or 1

	return RemainingUses
end

BackendInterfaceItemTutorial.get_item_power_level = function (self, arg_19_1)
	-- function 19
	return self:get_item_from_id(arg_19_1).power_level
end

BackendInterfaceItemTutorial.get_item_rarity = function (self, arg_20_1)
	-- function 20
	return self:get_item_from_id(arg_20_1).rarity
end

BackendInterfaceItemTutorial.get_key = function (self, arg_21_1)
	-- function 21
	return self:get_item_from_id(arg_21_1).key
end

BackendInterfaceItemTutorial.get_item_from_id = function (self, arg_22_1)
	-- function 22
	return self:get_all_backend_items()[arg_22_1]
end

BackendInterfaceItemTutorial.get_item_from_key = function (self, arg_23_1)
	-- function 23
	local get_all_backend_items = self:get_all_backend_items()

	for k, v in pairs(get_all_backend_items) do
		if v.key == arg_23_1 then
			return v
		end
	end
end

BackendInterfaceItemTutorial.get_all_backend_items = function (self)
	-- function 24
	if not self._dirty then
		self:_refresh()
	end

	return self._items
end

BackendInterfaceItemTutorial.get_loadout = function (self)
	-- function 25
	if not self._dirty then
		self:_refresh()
	end

	return self._loadouts
end

BackendInterfaceItemTutorial.get_loadout_by_career_name = function (self, arg_26_1)
	-- function 26
	if not self._dirty then
		self:_refresh()
	end

	return self._loadouts[arg_26_1]
end

BackendInterfaceItemTutorial.get_loadout_item_id = function (self, arg_27_1, arg_27_2)
	-- function 27
	return self:get_loadout()[arg_27_1][arg_27_2]
end

local tbl_2 = {}

BackendInterfaceItemTutorial.get_filtered_items = function (self, arg_28_1, arg_28_2)
	-- function 28
	local get_all_backend_items = self:get_all_backend_items()

	return (Managers.backend:get_interface("common"):filter_items(get_all_backend_items, arg_28_1, arg_28_2 or tbl_2))
end

BackendInterfaceItemTutorial.set_loadout_item = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local get_all_backend_items = self:get_all_backend_items()

	if not arg_29_1 then
		fassert(get_all_backend_items[arg_29_1], "Trying to equip item that doesn't exist %d", arg_29_1 or "nil")
	end

	self._backend_mirror:set_character_data(arg_29_2, arg_29_3, arg_29_1)

	self._dirty = true
end

BackendInterfaceItemTutorial.remove_item = function (arg_30_0, arg_30_1, arg_30_2)
	-- function 30
	return
end

BackendInterfaceItemTutorial.award_item = function (arg_31_0, arg_31_1)
	-- function 31
	return
end

BackendInterfaceItemTutorial.data_server_script = function (arg_32_0, arg_32_1, ...)
	-- function 32
	return
end

BackendInterfaceItemTutorial.upgrades_failed_game = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	return
end

BackendInterfaceItemTutorial.poll_upgrades_failed_game = function (arg_34_0)
	-- function 34
	return
end

BackendInterfaceItemTutorial.generate_item_server_loot = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6)
	-- function 35
	return
end

BackendInterfaceItemTutorial.check_for_loot = function (arg_36_0)
	-- function 36
	return
end

BackendInterfaceItemTutorial.equipped_by = function (self, arg_37_1)
	-- function 37
	local _loadouts = self._loadouts
	local tbl = {}

	for k, v in pairs(_loadouts) do
		for k_2, v_2 in pairs(v) do
			if arg_37_1 == v_2 then
				table.insert(tbl, k)
			end
		end
	end

	return tbl
end

BackendInterfaceItemTutorial.is_equipped = function (arg_38_0, arg_38_1, arg_38_2)
	-- function 38
	return
end

BackendInterfaceItemTutorial.set_data_server_queue = function (arg_39_0, arg_39_1)
	-- function 39
	return
end

BackendInterfaceItemTutorial.make_dirty = function (self)
	-- function 40
	self._dirty = true
end

BackendInterfaceItemTutorial.has_item = function (self, arg_41_1)
	-- function 41
	local get_all_backend_items = self:get_all_backend_items()

	for k, v in pairs(get_all_backend_items) do
		if arg_41_1 == v.key then
			return true
		end
	end

	return false
end

BackendInterfaceItemTutorial.get_item_template = function (arg_42_0, arg_42_1, arg_42_2)
	-- function 42
	local temporary_template = arg_42_1.temporary_template

	temporary_template = temporary_template or arg_42_1.template

	local get_weapon_template = WeaponUtils.get_weapon_template(temporary_template)

	if not get_weapon_template then
		return get_weapon_template
	end

	local var_42_2 = Attachments[temporary_template]

	if not var_42_2 then
		return var_42_2
	end

	local var_42_3 = Cosmetics[temporary_template]

	if not var_42_3 then
		return var_42_3
	end

	fassert(false, "no item_template for item: " .. arg_42_1.key .. ", template name = " .. temporary_template)
end

BackendInterfaceItemTutorial.sum_best_power_levels = function (arg_43_0)
	-- function 43
	return 10
end

BackendInterfaceItemTutorial.configure_game_mode_specific_items = function (arg_44_0, arg_44_1, arg_44_2)
	-- function 44
	return
end

BackendInterfaceItemTutorial.set_game_mode_specific_items = function (arg_45_0, arg_45_1)
	-- function 45
	return
end

local tbl_3 = {
	equipped_weapon_pose_skin = {}
}

BackendInterfaceItemTutorial.get_dirty_weapon_pose_data = function (arg_46_0)
	-- function 46
	return tbl_3
end

local tbl_4 = {}

BackendInterfaceItemTutorial.get_unlocked_weapon_poses = function (arg_47_0)
	-- function 47
	return tbl_4
end

local tbl_5 = {}

BackendInterfaceItemTutorial.get_equipped_weapon_pose_skins = function (arg_48_0)
	-- function 48
	return tbl_5
end

BackendInterfaceItemTutorial.get_equipped_weapon_pose_skin = function (arg_49_0, arg_49_1)
	-- function 49
	return nil
end
