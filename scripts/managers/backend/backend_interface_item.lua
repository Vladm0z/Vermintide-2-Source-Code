-- chunkname: @scripts/managers/backend/backend_interface_item.lua

local var_0_0 = class(Items)

var_0_0.init = function (self)
	-- function 1
	self._dirty = true
	self._debug_end_of_round_timeout = false
end

local tbl = {
	slot_trinket_2 = true,
	slot_trinket_3 = true,
	slot_trinket_1 = true
}
local tbl_2 = {
	slot_hat = true,
	slot_skin = true,
	slot_frame = true,
	slot_melee = true,
	slot_ranged = true
}
local tbl_3 = {
	frame = true,
	skin = true,
	hat = true
}
local tbl_4 = {
	dr_shield_axe_0001 = true,
	dr_crossbow_0001 = true,
	we_shortbow_0001 = true,
	dr_helmet_0001 = true,
	bw_skullstaff_fireball_0001 = true,
	es_blunderbuss_0001 = true,
	ww_hood_0001 = true,
	bw_gate_0001 = true,
	bw_sword_0001 = true,
	we_dual_wield_daggers_0001 = true,
	es_2h_hammer_0001 = true,
	es_hat_0001 = true,
	wh_hat_0001 = true,
	wh_brace_of_pistols_0001 = true,
	wh_fencing_sword_0001 = true
}

local function fn(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	for k, v in pairs(arg_2_0) do
		local var_2_0 = ItemMasterList[v.key]
		local can_wield = var_2_0.can_wield

		for i, v_2 in ipairs(can_wield) do
			if not (v_2 ~= arg_2_1 or var_2_0.slot_type ~= InventorySettings.slots_by_name[arg_2_2].type) then
				return k
			end
		end
	end
end

local function fn_2(self, arg_3_1, arg_3_2)
	-- function 3
	if not arg_3_2 then
		local tbl = {}

		for k, v in pairs(self) do
			if not arg_3_2[v.key] then
				tbl[k] = v.key
			end
		end

		for k_2, v_2 in pairs(tbl) do
			print(string.format("[BackendInterfaceItem] Item %q not found in white list, removing it.", v_2))

			self[k_2] = nil
		end
	end

	local var_3_1

	for k_3, v_3 in pairs(self) do
		if not rawget(ItemMasterList, v_3.key) then
			var_3_1 = var_3_1 or {}
			var_3_1[k_3] = v_3.key
		end
	end

	local tbl_3 = {}

	for k_4, v_4 in pairs(arg_3_1) do
		for k_5, v_5 in pairs(v_4) do
			if k_5 == "backend_id" then
				-- Nothing
			elseif not self[v_5] then
				Crashify.print_exception("BackendInterfaceItem", "Tried to equip item not found in items list, clearing slot. Profile: %q, Backend id: %d, Slot: %q", k_4, v_5, k_5)
				BackendItem.set_loadout_item(nil, arg_3_1[k_4].backend_id, k_5)

				v_4[k_5] = nil

				if not tbl_2[k_5] then
					tbl_3[#tbl_3 + 1] = {
						slot = k_5,
						profile_name = k_4
					}
				end
			elseif not var_3_1 and not var_3_1[v_5] then
				Crashify.print_exception("BackendInterfaceItem", "Tried to equip item not found in ItemMasterList, clearing slot. Profile: %q, Item: %q, Backend id: %d, Slot: %q", k_4, var_3_1[v_5], v_5, k_5)
				BackendItem.set_loadout_item(nil, arg_3_1[k_4].backend_id, k_5)

				v_4[k_5] = nil

				if not tbl_2[k_5] then
					tbl_3[#tbl_3 + 1] = {
						slot = k_5,
						profile_name = k_4
					}
				end
			end
		end
	end

	if not var_3_1 then
		for k_6, v_6 in pairs(var_3_1) do
			Crashify.print_exception("BackendInterfaceItem", "Missing item %q in backend, removing it. Backend id: %q", v_6, k_6)

			self[k_6] = nil
		end
	end

	for i, v_7 in ipairs(tbl_3) do
		local profile_name = v_7.profile_name
		local slot = v_7.slot
		local var_3_5 = fn(self, profile_name, slot)

		if not var_3_5 then
			Crashify.print_exception("BackendInterfaceItem", "Slot %q was empty, putting item %d in it", slot, var_3_5)
			BackendItem.set_loadout_item(var_3_5, arg_3_1[profile_name].backend_id, slot)

			tbl_3[i] = nil
			arg_3_1[profile_name][slot] = var_3_5
		end
	end

	fassert(table.is_empty(tbl_3), "[BackendInterfaceItem] Your backend save is broken, ask for help resetting it")
end

var_0_0.set_item_whitelist = function (self, arg_4_1)
	-- function 4
	local tbl = {}

	for i = 1, #arg_4_1 do
		tbl[arg_4_1[i]] = true
	end

	self._item_whitelist = tbl
	self._dirty = true
end

var_0_0._refresh_entities_if_needed = function (self)
	-- function 5
	if not self._dirty then
		local get_items, var_5_1 = BackendItem.get_items()

		fn_2(get_items, var_5_1, self._item_whitelist)

		self._items = get_items
		self._loadout = var_5_1
		self._profile_cache = {}
		self._dirty = false
	end
end

var_0_0.get_all_backend_items = function (self)
	-- function 6
	self:_refresh_entities_if_needed()

	return self._items
end

local tbl_5 = {}

var_0_0.get_filtered_items = function (self, arg_7_1, arg_7_2)
	-- function 7
	local get_all_backend_items = self:get_all_backend_items()

	return (Managers.backend:get_interface("common"):filter_items(get_all_backend_items, arg_7_1, arg_7_2 or tbl_5))
end

var_0_0.set_error = function (self, arg_8_1)
	-- function 8
	self._error_data = arg_8_1
end

var_0_0.check_for_errors = function (self)
	-- function 9
	local _error_data = self._error_data

	self._error_data = nil

	return _error_data
end

var_0_0.update = function (self, arg_10_1)
	-- function 10
	if not self._dice_game_data then
		local get_interface = Managers.backend:get_interface("session")
		local flag = not not self._debug_end_of_round_timeout or get_interface:get_state() == "END_OF_ROUND"
		local flag_2 = not GameSettingsDevelopment.backend_settings.enable_sessions

		if flag or not flag_2 then
			local parameters = self._dice_game_data.parameters
			local dice_script = GameSettingsDevelopment.backend_settings.dice_script

			print("Generating backend loot with:", unpack(parameters))

			self._dice_item = self._queue:add_item(dice_script, unpack(parameters))

			self._dice_item:disable_registered_commands()

			self._dice_game_data = nil
		elseif Managers.time:time("main") > self._dice_game_data.time_out then
			self._dice_game_data = nil

			self:set_error({
				reason = BACKEND_LUA_ERRORS.ERR_DICE_TIMEOUT1
			})
		end
	elseif not self._upgrades_failed_game_data then
		local get_interface_2 = Managers.backend:get_interface("session")
		local flag_3 = not not self._debug_end_of_round_timeout or get_interface_2:get_state() == "END_OF_ROUND"
		local flag_4 = not GameSettingsDevelopment.backend_settings.enable_sessions

		if flag_3 or not flag_4 then
			local start_level = self._upgrades_failed_game_data.start_level
			local end_level = self._upgrades_failed_game_data.end_level
			local upgrades_failed_script = GameSettingsDevelopment.backend_settings.upgrades_failed_script

			print("Generating upgrades for failed game:", upgrades_failed_script, "param_start_level", start_level, "param_end_level", end_level)

			self._upgrades_item = self._queue:add_item(upgrades_failed_script, "param_start_level", start_level, "param_end_level", end_level)

			self._upgrades_item:disable_registered_commands()

			self._upgrades_failed_game_data = nil
		elseif Managers.time:time("main") > self._upgrades_failed_game_data.time_out then
			self._upgrades_failed_game_data = nil

			self:set_error({
				reason = BACKEND_LUA_ERRORS.ERR_UPGRADES_TIMEOUT
			})
		end
	end
end

var_0_0.reset_dice_game_item = function (self)
	-- function 11
	self._dice_item = nil
end

var_0_0.dice_game_item = function (self)
	-- function 12
	return self._dice_item
end

var_0_0.poll_upgrades = function (self)
	-- function 13
	local _upgrades_item = self._upgrades_item

	if not _upgrades_item and not _upgrades_item:is_done() then
		self._upgrades_item = nil

		return _upgrades_item:items()
	end
end

var_0_0.get_loadout = function (self)
	-- function 14
	self:_refresh_entities_if_needed()

	return self._loadout
end

var_0_0.generate_item_server_loot = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
	-- function 15
	local fassert = fassert
	local flag = not not self._dice_game_data or not self._upgrades_failed_game_data
	local str = "Trying to do two item server scripts at once. DiceGame: %s, UpgradesFailedGame: %s"
	local _dice_game_data = self._dice_game_data

	_dice_game_data = not _dice_game_data and "true"

	local _upgrades_failed_game_data = self._upgrades_failed_game_data

	_upgrades_failed_game_data = not _upgrades_failed_game_data and "true"

	fassert(flag, str, _dice_game_data, _upgrades_failed_game_data)

	local num = Managers.time:time("main") + 20
	local tbl = {
		"param_dice",
		tostring(arg_15_1),
		"param_difficulty",
		arg_15_2,
		"param_start_level",
		arg_15_3,
		"param_end_level",
		arg_15_4
	}

	if not arg_15_5 then
		tbl[#tbl + 1] = "param_hero_name"
		tbl[#tbl + 1] = arg_15_5
	end

	if not arg_15_6 then
		tbl[#tbl + 1] = "param_dlc_name"
		tbl[#tbl + 1] = arg_15_6
	end

	self._dice_game_data = {
		time_out = num,
		parameters = tbl
	}
end

var_0_0.upgrades_failed_game = function (self, arg_16_1, arg_16_2)
	-- function 16
	local fassert = fassert
	local flag = not not self._dice_game_data or not self._upgrades_failed_game_data
	local str = "Trying to do two item server scripts at once. DiceGame: %s, UpgradesFailedGame: %s"
	local _dice_game_data = self._dice_game_data

	_dice_game_data = not _dice_game_data and "true"

	local _upgrades_failed_game_data = self._upgrades_failed_game_data

	_upgrades_failed_game_data = not _upgrades_failed_game_data and "true"

	fassert(flag, str, _dice_game_data, _upgrades_failed_game_data)

	local num = Managers.time:time("main") + 20

	self._upgrades_failed_game_data = {
		time_out = num,
		start_level = arg_16_1,
		end_level = arg_16_2
	}
end

var_0_0.num_current_item_server_requests = function (self)
	-- function 17
	return self._queue:num_current_requests()
end

var_0_0.make_dirty = function (self)
	-- function 18
	self._dirty = true
end

var_0_0.set_data_server_queue = function (self, arg_19_1)
	-- function 19
	self._queue = arg_19_1
end

var_0_0.data_server_queue = function (self)
	-- function 20
	return self._queue
end

BackendInterfaceItem = class(BackendInterfaceItem)

BackendInterfaceItem.init = function (self)
	-- function 21
	self._backend_items = var_0_0:new()
end

BackendInterfaceItem.type = function (arg_22_0)
	-- function 22
	return "backend"
end

BackendInterfaceItem.update = function (self)
	-- function 23
	self._backend_items:update()
end

BackendInterfaceItem.refresh_entities = function (self)
	-- function 24
	self._backend_items:make_dirty()
	self._backend_items:_refresh_entities_if_needed()
end

BackendInterfaceItem.check_for_errors = function (self)
	-- function 25
	return self._backend_items:check_for_errors()
end

BackendInterfaceItem.num_current_item_server_requests = function (self)
	-- function 26
	return self._backend_items:num_current_item_server_requests()
end

BackendInterfaceItem.set_properties_serialized = function (arg_27_0, arg_27_1, arg_27_2)
	-- function 27
	local set_traits = BackendItem.set_traits(arg_27_1, arg_27_2)
end

BackendInterfaceItem.get_traits = function (self, arg_28_1)
	-- function 28
	local get_item_from_id = self:get_item_from_id(arg_28_1)

	if not get_item_from_id then
		return get_item_from_id.traits
	end

	return nil
end

BackendInterfaceItem.set_runes = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	local get_interface = Managers.backend:get_interface("runes")

	for k, v in pairs(arg_29_2) do
		get_interface:set(arg_29_1, v)
	end
end

BackendInterfaceItem.get_runes = function (arg_30_0, arg_30_1)
	-- function 30
	return (Managers.backend:get_interface("runes"):get(arg_30_1))
end

BackendInterfaceItem.get_key = function (self, arg_31_1)
	-- function 31
	local var_31_0 = self._backend_items:get_all_backend_items()[arg_31_1]

	if not var_31_0 then
		return var_31_0.key
	end
end

BackendInterfaceItem.get_item_from_id = function (self, arg_32_1)
	-- function 32
	if arg_32_1 == 0 then
		Crashify.print_exception("BackendInterfaceItem", "Tried to get item from backend_id 0")
	end

	return self._backend_items:get_all_backend_items()[arg_32_1]
end

BackendInterfaceItem.get_all_backend_items = function (self)
	-- function 33
	return self._backend_items:get_all_backend_items()
end

BackendInterfaceItem.get_loadout = function (self)
	-- function 34
	return self._backend_items:get_loadout()
end

BackendInterfaceItem.get_loadout_item_id = function (self, arg_35_1, arg_35_2)
	-- function 35
	return self._backend_items:get_loadout()[arg_35_1][arg_35_2]
end

BackendInterfaceItem.get_filtered_items = function (self, arg_36_1)
	-- function 36
	return (self._backend_items:get_filtered_items(arg_36_1))
end

BackendInterfaceItem.set_loadout_item = function (self, arg_37_1, arg_37_2, arg_37_3)
	-- function 37
	local get_all_backend_items = self._backend_items:get_all_backend_items()

	if not arg_37_1 then
		fassert(get_all_backend_items[arg_37_1], "Trying to equip item that doesn't exist %d", arg_37_1 or "nil")
	end

	local backend_id = self._backend_items:get_loadout()[arg_37_2].backend_id

	if not BackendItem.set_loadout_item(arg_37_1, backend_id, arg_37_3) then
		self._backend_items:make_dirty()
	end
end

BackendInterfaceItem.remove_item = function (self, arg_38_1, arg_38_2)
	-- function 38
	if not arg_38_2 then
		local get_loadout = self._backend_items:get_loadout()

		for k, v in pairs(get_loadout) do
			for k_2, v_2 in pairs(v) do
				if not tbl_2[k_2] then
					fassert(arg_38_1 ~= v_2, "Trying to destroy equipped item: %s:%s:%d", k, k_2, arg_38_1)
				end
			end
		end
	end

	local destroy_entity = BackendItem.destroy_entity(arg_38_1)

	self._backend_items:make_dirty()

	return destroy_entity
end

BackendInterfaceItem.award_item = function (self, arg_39_1)
	-- function 39
	BackendItem.award_item(arg_39_1)
	self._backend_items:make_dirty()
end

BackendInterfaceItem.data_server_script = function (self, arg_40_1, ...)
	-- function 40
	return (self._backend_items:data_server_queue():add_item(arg_40_1, ...))
end

BackendInterfaceItem.upgrades_failed_game = function (self, arg_41_1, arg_41_2)
	-- function 41
	self._backend_items:upgrades_failed_game(arg_41_1, arg_41_2)
end

BackendInterfaceItem.generate_item_server_loot = function (self, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
	-- function 42
	local str = ""

	for k, v in pairs(arg_42_1) do
		str = str .. k .. "," .. tostring(v) .. ";"
	end

	self._backend_items:generate_item_server_loot(str, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
end

BackendInterfaceItem.check_for_loot = function (self)
	-- function 43
	local dice_game_item = self._backend_items:dice_game_item()

	if not dice_game_item and not dice_game_item:is_done() then
		local error_message = dice_game_item:error_message()

		if not error_message then
			self._backend_items:set_error(error_message)
		elseif not dice_game_item:items() then
			local parameters = dice_game_item:parameters()
			local items = dice_game_item:items()
			local tbl = {}
			local num = 1
			local successes = parameters.successes

			for iter_43_0, iter_43_1 in string.gmatch(successes, "([%w_]+),(%w+);") do
				tbl[iter_43_0] = tonumber(iter_43_1)
				num = num + iter_43_1
			end

			local win_list = parameters.win_list
			local tbl_2 = {}

			for iter_43_2 in string.gmatch(win_list, "([%w_]+),") do
				tbl_2[#tbl_2 + 1] = iter_43_2
			end

			local var_43_9 = tbl_2[num]
			local var_43_10
			local tbl_3 = {}

			for k, v in pairs(items) do
				if var_43_9 == v then
					var_43_10 = k
				else
					tbl_3[k] = v
				end
			end

			fassert(var_43_10, "Broken dice game winnings")
			Managers.backend:get_interface("session"):received_dice_game_loot()
			self._backend_items:reset_dice_game_item()
			self._backend_items:make_dirty()

			return tbl, tbl_2, var_43_10, tbl_3
		end
	end
end

BackendInterfaceItem.equipped_by = function (self, arg_44_1)
	-- function 44
	local tbl = {}
	local get_loadout = self._backend_items:get_loadout()

	for k, v in pairs(get_loadout) do
		for k_2, v_2 in pairs(v) do
			if arg_44_1 == v_2 then
				table.insert(tbl, k)
			end
		end
	end

	return tbl
end

BackendInterfaceItem.is_equipped = function (self, arg_45_1, arg_45_2)
	-- function 45
	local get_loadout = self._backend_items:get_loadout()

	for k, v in pairs(get_loadout) do
		if not (not arg_45_2 and k ~= arg_45_2) then
			for k_2, v_2 in pairs(v) do
				if not ((tbl_2[k_2] or not tbl[k_2]) and arg_45_1 ~= v_2) then
					return true
				end
			end
		end
	end

	return false
end

local tbl_6 = {
	ranged = true,
	melee = true,
	hat = true,
	trinket = true
}
local tbl_7 = {
	common = true,
	plentiful = true,
	exotic = true,
	rare = true,
	unique = true
}

BackendInterfaceItem.is_salvageable = function (self, arg_46_1)
	-- function 46
	local flag = not self:is_equipped(arg_46_1)
	local var_46_1 = self._backend_items:get_all_backend_items()[arg_46_1]
	local var_46_2 = ItemMasterList[var_46_1.key]
	local var_46_3 = tbl_6[var_46_2.slot_type]
	local var_46_4 = tbl_7[var_46_2.rarity]

	return not flag and not var_46_3 and var_46_4
end

local tbl_8 = {
	melee = true,
	ranged = true
}
local tbl_9 = {
	common = true,
	plentiful = true,
	rare = true
}

BackendInterfaceItem.is_fuseable = function (self, arg_47_1)
	-- function 47
	local flag = not self:is_equipped(arg_47_1)
	local var_47_1 = self._backend_items:get_all_backend_items()[arg_47_1]
	local var_47_2 = ItemMasterList[var_47_1.key]
	local var_47_3 = tbl_8[var_47_2.slot_type]
	local var_47_4 = tbl_9[var_47_2.rarity]

	return not flag and not var_47_3 and var_47_4
end

BackendInterfaceItem.set_data_server_queue = function (self, arg_48_1)
	-- function 48
	self._backend_items:set_data_server_queue(arg_48_1)

	local item_whitelist = GameSettingsDevelopment.backend_settings.item_whitelist

	if not item_whitelist then
		arg_48_1:register_executor("item_whitelist", callback(self, "_command_item_whitelist"))
		arg_48_1:add_item(item_whitelist)
	end
end

BackendInterfaceItem.__dirtify = function (self)
	-- function 49
	self._backend_items:make_dirty()
end

BackendInterfaceItem.has_item = function (arg_50_0, arg_50_1)
	-- function 50
	local get_items, var_50_1 = BackendItem.get_items()

	for k, v in pairs(get_items) do
		if v.key == arg_50_1 then
			return true
		end
	end

	return false
end

BackendInterfaceItem.clean_inventory_for_prestige = function (self, arg_51_1, arg_51_2)
	-- function 51
	local get_items, var_51_1 = BackendItem.get_items()
	local var_51_2
	local tbl = {}

	for k, v in pairs(get_items) do
		local var_51_4 = ItemMasterList[v.key]
		local flag = false

		for k_2, v_2 in pairs(var_51_4.can_wield) do
			if not (FindProfileIndex(v_2) == arg_51_1) then
				flag = true
			end
		end

		if not (not flag and tbl_3[var_51_4.item_type] or tbl_4[var_51_4.name]) then
			get_items[k] = nil
			tbl[#tbl + 1] = k
		end
	end

	local tbl_5 = {}

	for k_3, v_3 in pairs(var_51_1) do
		for k_4, v_4 in pairs(v_3) do
			if k_4 == "backend_id" then
				-- Nothing
			elseif not get_items[v_4] then
				BackendItem.set_loadout_item(nil, var_51_1[k_3].backend_id, k_4)

				v_3[k_4] = nil

				if not tbl_2[k_4] then
					tbl_5[#tbl_5 + 1] = {
						slot = k_4,
						profile_name = k_3
					}
				end
			elseif not var_51_2 and not var_51_2[v_4] then
				BackendItem.set_loadout_item(nil, var_51_1[k_3].backend_id, k_4)

				v_3[k_4] = nil

				if not tbl_2[k_4] then
					tbl_5[#tbl_5 + 1] = {
						slot = k_4,
						profile_name = k_3
					}
				end
			end
		end
	end

	local extension = ScriptUnit.extension(arg_51_2, "inventory_system")

	for i, v_5 in ipairs(tbl_5) do
		local profile_name = v_5.profile_name
		local slot = v_5.slot
		local var_51_10 = fn(get_items, profile_name, slot)

		if not var_51_10 then
			local type = InventorySettings.slots_by_name[slot].type

			if not (type == "melee" or type ~= "ranged") then
				local flag_2

				flag_2 = type ~= "melee" or not "slot_melee" or "slot_ranged"

				extension:create_equipment_in_slot(flag_2, var_51_10)
				extension:wield(flag_2)
			elseif type == "hat" then
				ScriptUnit.extension(arg_51_2, "attachment_system"):create_attachment_in_slot(slot, var_51_10)
			elseif type == "trinket" then
				ScriptUnit.extension(arg_51_2, "attachment_system"):create_attachment_in_slot(slot, var_51_10)
			end

			Crashify.print_exception("BackendInterfaceItem", "Slot %q was empty, putting item %d in it", slot, var_51_10)
			BackendItem.set_loadout_item(var_51_10, var_51_1[profile_name].backend_id, slot)

			tbl_5[i] = nil
			var_51_1[profile_name][slot] = var_51_10
		end
	end

	fassert(table.is_empty(tbl_5), "[BackendInterfaceItem] Your backend save is broken, ask for help resetting it")

	self._items = get_items
	self._loadout = var_51_1
	self._profile_cache = {}

	self._backend_items:make_dirty()

	self._dirty = true

	for i_2, v_6 in ipairs(tbl) do
		self:remove_item(v_6)
	end
end

BackendInterfaceItem.get_runes = function (self, arg_52_1)
	-- function 52
	local get_item_from_id = self:get_item_from_id(arg_52_1)

	if not get_item_from_id then
		return get_item_from_id.runes
	end

	return nil
end

BackendInterfaceItem._slot_item_rune = function (arg_53_0, arg_53_1, arg_53_2)
	-- function 53
	return
end

BackendInterfaceItem.get_item_template = function (arg_54_0, arg_54_1, arg_54_2)
	-- function 54
	local temporary_template = arg_54_1.temporary_template

	temporary_template = temporary_template or arg_54_1.template

	local get_weapon_template = WeaponUtils.get_weapon_template(temporary_template)

	if not get_weapon_template then
		return get_weapon_template
	end

	local var_54_2 = Attachments[temporary_template]

	if not var_54_2 then
		return var_54_2
	end

	local var_54_3 = Cosmetics[temporary_template]

	if not var_54_3 then
		return var_54_3
	end

	fassert(false, "no item_template for item: " .. arg_54_1.key .. ", template name = " .. temporary_template)
end

BackendInterfaceItem._command_item_whitelist = function (self, arg_55_1)
	-- function 55
	local _backend_items = self._backend_items

	if not arg_55_1.enabled then
		_backend_items:set_item_whitelist(arg_55_1.items)
	end

	_backend_items:data_server_queue():unregister_executor("item_whitelist")
end
