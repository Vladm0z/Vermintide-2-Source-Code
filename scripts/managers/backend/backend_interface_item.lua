-- chunkname: @scripts/managers/backend/backend_interface_item.lua

local var_0_0 = class(Items)

var_0_0.init = function (arg_1_0)
	arg_1_0._dirty = true
	arg_1_0._debug_end_of_round_timeout = false
end

local var_0_1 = {
	slot_trinket_2 = true,
	slot_trinket_3 = true,
	slot_trinket_1 = true
}
local var_0_2 = {
	slot_hat = true,
	slot_skin = true,
	slot_frame = true,
	slot_melee = true,
	slot_ranged = true
}
local var_0_3 = {
	frame = true,
	skin = true,
	hat = true
}
local var_0_4 = {
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

local function var_0_5(arg_2_0, arg_2_1, arg_2_2)
	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		local var_2_0 = ItemMasterList[iter_2_1.key]
		local var_2_1 = var_2_0.can_wield

		for iter_2_2, iter_2_3 in ipairs(var_2_1) do
			if iter_2_3 == arg_2_1 and var_2_0.slot_type == InventorySettings.slots_by_name[arg_2_2].type then
				return iter_2_0
			end
		end
	end
end

local function var_0_6(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_2 then
		local var_3_0 = {}

		for iter_3_0, iter_3_1 in pairs(arg_3_0) do
			if not arg_3_2[iter_3_1.key] then
				var_3_0[iter_3_0] = iter_3_1.key
			end
		end

		for iter_3_2, iter_3_3 in pairs(var_3_0) do
			print(string.format("[BackendInterfaceItem] Item %q not found in white list, removing it.", iter_3_3))

			arg_3_0[iter_3_2] = nil
		end
	end

	local var_3_1

	for iter_3_4, iter_3_5 in pairs(arg_3_0) do
		if not rawget(ItemMasterList, iter_3_5.key) then
			var_3_1 = var_3_1 or {}
			var_3_1[iter_3_4] = iter_3_5.key
		end
	end

	local var_3_2 = {}

	for iter_3_6, iter_3_7 in pairs(arg_3_1) do
		for iter_3_8, iter_3_9 in pairs(iter_3_7) do
			if iter_3_8 == "backend_id" then
				-- Nothing
			elseif not arg_3_0[iter_3_9] then
				Crashify.print_exception("BackendInterfaceItem", "Tried to equip item not found in items list, clearing slot. Profile: %q, Backend id: %d, Slot: %q", iter_3_6, iter_3_9, iter_3_8)
				BackendItem.set_loadout_item(nil, arg_3_1[iter_3_6].backend_id, iter_3_8)

				iter_3_7[iter_3_8] = nil

				if var_0_2[iter_3_8] then
					var_3_2[#var_3_2 + 1] = {
						slot = iter_3_8,
						profile_name = iter_3_6
					}
				end
			elseif var_3_1 and var_3_1[iter_3_9] then
				Crashify.print_exception("BackendInterfaceItem", "Tried to equip item not found in ItemMasterList, clearing slot. Profile: %q, Item: %q, Backend id: %d, Slot: %q", iter_3_6, var_3_1[iter_3_9], iter_3_9, iter_3_8)
				BackendItem.set_loadout_item(nil, arg_3_1[iter_3_6].backend_id, iter_3_8)

				iter_3_7[iter_3_8] = nil

				if var_0_2[iter_3_8] then
					var_3_2[#var_3_2 + 1] = {
						slot = iter_3_8,
						profile_name = iter_3_6
					}
				end
			end
		end
	end

	if var_3_1 then
		for iter_3_10, iter_3_11 in pairs(var_3_1) do
			Crashify.print_exception("BackendInterfaceItem", "Missing item %q in backend, removing it. Backend id: %q", iter_3_11, iter_3_10)

			arg_3_0[iter_3_10] = nil
		end
	end

	for iter_3_12, iter_3_13 in ipairs(var_3_2) do
		local var_3_3 = iter_3_13.profile_name
		local var_3_4 = iter_3_13.slot
		local var_3_5 = var_0_5(arg_3_0, var_3_3, var_3_4)

		if var_3_5 then
			Crashify.print_exception("BackendInterfaceItem", "Slot %q was empty, putting item %d in it", var_3_4, var_3_5)
			BackendItem.set_loadout_item(var_3_5, arg_3_1[var_3_3].backend_id, var_3_4)

			var_3_2[iter_3_12] = nil
			arg_3_1[var_3_3][var_3_4] = var_3_5
		end
	end

	fassert(table.is_empty(var_3_2), "[BackendInterfaceItem] Your backend save is broken, ask for help resetting it")
end

var_0_0.set_item_whitelist = function (arg_4_0, arg_4_1)
	local var_4_0 = {}

	for iter_4_0 = 1, #arg_4_1 do
		var_4_0[arg_4_1[iter_4_0]] = true
	end

	arg_4_0._item_whitelist = var_4_0
	arg_4_0._dirty = true
end

var_0_0._refresh_entities_if_needed = function (arg_5_0)
	if arg_5_0._dirty then
		local var_5_0, var_5_1 = BackendItem.get_items()

		var_0_6(var_5_0, var_5_1, arg_5_0._item_whitelist)

		arg_5_0._items = var_5_0
		arg_5_0._loadout = var_5_1
		arg_5_0._profile_cache = {}
		arg_5_0._dirty = false
	end
end

var_0_0.get_all_backend_items = function (arg_6_0)
	arg_6_0:_refresh_entities_if_needed()

	return arg_6_0._items
end

local var_0_7 = {}

var_0_0.get_filtered_items = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0:get_all_backend_items()

	return (Managers.backend:get_interface("common"):filter_items(var_7_0, arg_7_1, arg_7_2 or var_0_7))
end

var_0_0.set_error = function (arg_8_0, arg_8_1)
	arg_8_0._error_data = arg_8_1
end

var_0_0.check_for_errors = function (arg_9_0)
	local var_9_0 = arg_9_0._error_data

	arg_9_0._error_data = nil

	return var_9_0
end

var_0_0.update = function (arg_10_0, arg_10_1)
	if arg_10_0._dice_game_data then
		local var_10_0 = Managers.backend:get_interface("session")
		local var_10_1 = not arg_10_0._debug_end_of_round_timeout and var_10_0:get_state() == "END_OF_ROUND"
		local var_10_2 = not GameSettingsDevelopment.backend_settings.enable_sessions

		if var_10_1 or var_10_2 then
			local var_10_3 = arg_10_0._dice_game_data.parameters
			local var_10_4 = GameSettingsDevelopment.backend_settings.dice_script

			print("Generating backend loot with:", unpack(var_10_3))

			arg_10_0._dice_item = arg_10_0._queue:add_item(var_10_4, unpack(var_10_3))

			arg_10_0._dice_item:disable_registered_commands()

			arg_10_0._dice_game_data = nil
		elseif Managers.time:time("main") > arg_10_0._dice_game_data.time_out then
			arg_10_0._dice_game_data = nil

			arg_10_0:set_error({
				reason = BACKEND_LUA_ERRORS.ERR_DICE_TIMEOUT1
			})
		end
	elseif arg_10_0._upgrades_failed_game_data then
		local var_10_5 = Managers.backend:get_interface("session")
		local var_10_6 = not arg_10_0._debug_end_of_round_timeout and var_10_5:get_state() == "END_OF_ROUND"
		local var_10_7 = not GameSettingsDevelopment.backend_settings.enable_sessions

		if var_10_6 or var_10_7 then
			local var_10_8 = arg_10_0._upgrades_failed_game_data.start_level
			local var_10_9 = arg_10_0._upgrades_failed_game_data.end_level
			local var_10_10 = GameSettingsDevelopment.backend_settings.upgrades_failed_script

			print("Generating upgrades for failed game:", var_10_10, "param_start_level", var_10_8, "param_end_level", var_10_9)

			arg_10_0._upgrades_item = arg_10_0._queue:add_item(var_10_10, "param_start_level", var_10_8, "param_end_level", var_10_9)

			arg_10_0._upgrades_item:disable_registered_commands()

			arg_10_0._upgrades_failed_game_data = nil
		elseif Managers.time:time("main") > arg_10_0._upgrades_failed_game_data.time_out then
			arg_10_0._upgrades_failed_game_data = nil

			arg_10_0:set_error({
				reason = BACKEND_LUA_ERRORS.ERR_UPGRADES_TIMEOUT
			})
		end
	end
end

var_0_0.reset_dice_game_item = function (arg_11_0)
	arg_11_0._dice_item = nil
end

var_0_0.dice_game_item = function (arg_12_0)
	return arg_12_0._dice_item
end

var_0_0.poll_upgrades = function (arg_13_0)
	local var_13_0 = arg_13_0._upgrades_item

	if var_13_0 and var_13_0:is_done() then
		arg_13_0._upgrades_item = nil

		return var_13_0:items()
	end
end

var_0_0.get_loadout = function (arg_14_0)
	arg_14_0:_refresh_entities_if_needed()

	return arg_14_0._loadout
end

var_0_0.generate_item_server_loot = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
	fassert(not arg_15_0._dice_game_data and not arg_15_0._upgrades_failed_game_data, "Trying to do two item server scripts at once. DiceGame: %s, UpgradesFailedGame: %s", arg_15_0._dice_game_data and "true", arg_15_0._upgrades_failed_game_data and "true")

	local var_15_0 = Managers.time:time("main") + 20
	local var_15_1 = {
		"param_dice",
		tostring(arg_15_1),
		"param_difficulty",
		arg_15_2,
		"param_start_level",
		arg_15_3,
		"param_end_level",
		arg_15_4
	}

	if arg_15_5 then
		var_15_1[#var_15_1 + 1] = "param_hero_name"
		var_15_1[#var_15_1 + 1] = arg_15_5
	end

	if arg_15_6 then
		var_15_1[#var_15_1 + 1] = "param_dlc_name"
		var_15_1[#var_15_1 + 1] = arg_15_6
	end

	arg_15_0._dice_game_data = {
		time_out = var_15_0,
		parameters = var_15_1
	}
end

var_0_0.upgrades_failed_game = function (arg_16_0, arg_16_1, arg_16_2)
	fassert(not arg_16_0._dice_game_data and not arg_16_0._upgrades_failed_game_data, "Trying to do two item server scripts at once. DiceGame: %s, UpgradesFailedGame: %s", arg_16_0._dice_game_data and "true", arg_16_0._upgrades_failed_game_data and "true")

	local var_16_0 = Managers.time:time("main") + 20

	arg_16_0._upgrades_failed_game_data = {
		time_out = var_16_0,
		start_level = arg_16_1,
		end_level = arg_16_2
	}
end

var_0_0.num_current_item_server_requests = function (arg_17_0)
	return arg_17_0._queue:num_current_requests()
end

var_0_0.make_dirty = function (arg_18_0)
	arg_18_0._dirty = true
end

var_0_0.set_data_server_queue = function (arg_19_0, arg_19_1)
	arg_19_0._queue = arg_19_1
end

var_0_0.data_server_queue = function (arg_20_0)
	return arg_20_0._queue
end

BackendInterfaceItem = class(BackendInterfaceItem)

BackendInterfaceItem.init = function (arg_21_0)
	arg_21_0._backend_items = var_0_0:new()
end

BackendInterfaceItem.type = function (arg_22_0)
	return "backend"
end

BackendInterfaceItem.update = function (arg_23_0)
	arg_23_0._backend_items:update()
end

BackendInterfaceItem.refresh_entities = function (arg_24_0)
	arg_24_0._backend_items:make_dirty()
	arg_24_0._backend_items:_refresh_entities_if_needed()
end

BackendInterfaceItem.check_for_errors = function (arg_25_0)
	return arg_25_0._backend_items:check_for_errors()
end

BackendInterfaceItem.num_current_item_server_requests = function (arg_26_0)
	return arg_26_0._backend_items:num_current_item_server_requests()
end

BackendInterfaceItem.set_properties_serialized = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = BackendItem.set_traits(arg_27_1, arg_27_2)
end

BackendInterfaceItem.get_traits = function (arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0:get_item_from_id(arg_28_1)

	if var_28_0 then
		return var_28_0.traits
	end

	return nil
end

BackendInterfaceItem.set_runes = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = Managers.backend:get_interface("runes")

	for iter_29_0, iter_29_1 in pairs(arg_29_2) do
		var_29_0:set(arg_29_1, iter_29_1)
	end
end

BackendInterfaceItem.get_runes = function (arg_30_0, arg_30_1)
	return (Managers.backend:get_interface("runes"):get(arg_30_1))
end

BackendInterfaceItem.get_key = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._backend_items:get_all_backend_items()[arg_31_1]

	if var_31_0 then
		return var_31_0.key
	end
end

BackendInterfaceItem.get_item_from_id = function (arg_32_0, arg_32_1)
	if arg_32_1 == 0 then
		Crashify.print_exception("BackendInterfaceItem", "Tried to get item from backend_id 0")
	end

	return arg_32_0._backend_items:get_all_backend_items()[arg_32_1]
end

BackendInterfaceItem.get_all_backend_items = function (arg_33_0)
	return arg_33_0._backend_items:get_all_backend_items()
end

BackendInterfaceItem.get_loadout = function (arg_34_0)
	return arg_34_0._backend_items:get_loadout()
end

BackendInterfaceItem.get_loadout_item_id = function (arg_35_0, arg_35_1, arg_35_2)
	return arg_35_0._backend_items:get_loadout()[arg_35_1][arg_35_2]
end

BackendInterfaceItem.get_filtered_items = function (arg_36_0, arg_36_1)
	return (arg_36_0._backend_items:get_filtered_items(arg_36_1))
end

BackendInterfaceItem.set_loadout_item = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	local var_37_0 = arg_37_0._backend_items:get_all_backend_items()

	if arg_37_1 then
		fassert(var_37_0[arg_37_1], "Trying to equip item that doesn't exist %d", arg_37_1 or "nil")
	end

	local var_37_1 = arg_37_0._backend_items:get_loadout()[arg_37_2].backend_id

	if BackendItem.set_loadout_item(arg_37_1, var_37_1, arg_37_3) then
		arg_37_0._backend_items:make_dirty()
	end
end

BackendInterfaceItem.remove_item = function (arg_38_0, arg_38_1, arg_38_2)
	if not arg_38_2 then
		local var_38_0 = arg_38_0._backend_items:get_loadout()

		for iter_38_0, iter_38_1 in pairs(var_38_0) do
			for iter_38_2, iter_38_3 in pairs(iter_38_1) do
				if var_0_2[iter_38_2] then
					fassert(arg_38_1 ~= iter_38_3, "Trying to destroy equipped item: %s:%s:%d", iter_38_0, iter_38_2, arg_38_1)
				end
			end
		end
	end

	local var_38_1 = BackendItem.destroy_entity(arg_38_1)

	arg_38_0._backend_items:make_dirty()

	return var_38_1
end

BackendInterfaceItem.award_item = function (arg_39_0, arg_39_1)
	BackendItem.award_item(arg_39_1)
	arg_39_0._backend_items:make_dirty()
end

BackendInterfaceItem.data_server_script = function (arg_40_0, arg_40_1, ...)
	return (arg_40_0._backend_items:data_server_queue():add_item(arg_40_1, ...))
end

BackendInterfaceItem.upgrades_failed_game = function (arg_41_0, arg_41_1, arg_41_2)
	arg_41_0._backend_items:upgrades_failed_game(arg_41_1, arg_41_2)
end

BackendInterfaceItem.generate_item_server_loot = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
	local var_42_0 = ""

	for iter_42_0, iter_42_1 in pairs(arg_42_1) do
		var_42_0 = var_42_0 .. iter_42_0 .. "," .. tostring(iter_42_1) .. ";"
	end

	arg_42_0._backend_items:generate_item_server_loot(var_42_0, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
end

BackendInterfaceItem.check_for_loot = function (arg_43_0)
	local var_43_0 = arg_43_0._backend_items:dice_game_item()

	if var_43_0 and var_43_0:is_done() then
		local var_43_1 = var_43_0:error_message()

		if var_43_1 then
			arg_43_0._backend_items:set_error(var_43_1)
		elseif var_43_0:items() then
			local var_43_2 = var_43_0:parameters()
			local var_43_3 = var_43_0:items()
			local var_43_4 = {}
			local var_43_5 = 1
			local var_43_6 = var_43_2.successes

			for iter_43_0, iter_43_1 in string.gmatch(var_43_6, "([%w_]+),(%w+);") do
				var_43_4[iter_43_0] = tonumber(iter_43_1)
				var_43_5 = var_43_5 + iter_43_1
			end

			local var_43_7 = var_43_2.win_list
			local var_43_8 = {}

			for iter_43_2 in string.gmatch(var_43_7, "([%w_]+),") do
				var_43_8[#var_43_8 + 1] = iter_43_2
			end

			local var_43_9 = var_43_8[var_43_5]
			local var_43_10
			local var_43_11 = {}

			for iter_43_3, iter_43_4 in pairs(var_43_3) do
				if var_43_9 == iter_43_4 then
					var_43_10 = iter_43_3
				else
					var_43_11[iter_43_3] = iter_43_4
				end
			end

			fassert(var_43_10, "Broken dice game winnings")
			Managers.backend:get_interface("session"):received_dice_game_loot()
			arg_43_0._backend_items:reset_dice_game_item()
			arg_43_0._backend_items:make_dirty()

			return var_43_4, var_43_8, var_43_10, var_43_11
		end
	end
end

BackendInterfaceItem.equipped_by = function (arg_44_0, arg_44_1)
	local var_44_0 = {}
	local var_44_1 = arg_44_0._backend_items:get_loadout()

	for iter_44_0, iter_44_1 in pairs(var_44_1) do
		for iter_44_2, iter_44_3 in pairs(iter_44_1) do
			if arg_44_1 == iter_44_3 then
				table.insert(var_44_0, iter_44_0)
			end
		end
	end

	return var_44_0
end

BackendInterfaceItem.is_equipped = function (arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0._backend_items:get_loadout()

	for iter_45_0, iter_45_1 in pairs(var_45_0) do
		if not arg_45_2 or iter_45_0 == arg_45_2 then
			for iter_45_2, iter_45_3 in pairs(iter_45_1) do
				if (var_0_2[iter_45_2] or var_0_1[iter_45_2]) and arg_45_1 == iter_45_3 then
					return true
				end
			end
		end
	end

	return false
end

local var_0_8 = {
	ranged = true,
	melee = true,
	hat = true,
	trinket = true
}
local var_0_9 = {
	common = true,
	plentiful = true,
	exotic = true,
	rare = true,
	unique = true
}

BackendInterfaceItem.is_salvageable = function (arg_46_0, arg_46_1)
	local var_46_0 = not arg_46_0:is_equipped(arg_46_1)
	local var_46_1 = arg_46_0._backend_items:get_all_backend_items()[arg_46_1]
	local var_46_2 = ItemMasterList[var_46_1.key]
	local var_46_3 = var_0_8[var_46_2.slot_type]
	local var_46_4 = var_0_9[var_46_2.rarity]

	return var_46_0 and var_46_3 and var_46_4
end

local var_0_10 = {
	melee = true,
	ranged = true
}
local var_0_11 = {
	common = true,
	plentiful = true,
	rare = true
}

BackendInterfaceItem.is_fuseable = function (arg_47_0, arg_47_1)
	local var_47_0 = not arg_47_0:is_equipped(arg_47_1)
	local var_47_1 = arg_47_0._backend_items:get_all_backend_items()[arg_47_1]
	local var_47_2 = ItemMasterList[var_47_1.key]
	local var_47_3 = var_0_10[var_47_2.slot_type]
	local var_47_4 = var_0_11[var_47_2.rarity]

	return var_47_0 and var_47_3 and var_47_4
end

BackendInterfaceItem.set_data_server_queue = function (arg_48_0, arg_48_1)
	arg_48_0._backend_items:set_data_server_queue(arg_48_1)

	local var_48_0 = GameSettingsDevelopment.backend_settings.item_whitelist

	if var_48_0 then
		arg_48_1:register_executor("item_whitelist", callback(arg_48_0, "_command_item_whitelist"))
		arg_48_1:add_item(var_48_0)
	end
end

BackendInterfaceItem.__dirtify = function (arg_49_0)
	arg_49_0._backend_items:make_dirty()
end

BackendInterfaceItem.has_item = function (arg_50_0, arg_50_1)
	local var_50_0, var_50_1 = BackendItem.get_items()

	for iter_50_0, iter_50_1 in pairs(var_50_0) do
		if iter_50_1.key == arg_50_1 then
			return true
		end
	end

	return false
end

BackendInterfaceItem.clean_inventory_for_prestige = function (arg_51_0, arg_51_1, arg_51_2)
	local var_51_0, var_51_1 = BackendItem.get_items()
	local var_51_2
	local var_51_3 = {}

	for iter_51_0, iter_51_1 in pairs(var_51_0) do
		local var_51_4 = ItemMasterList[iter_51_1.key]
		local var_51_5 = false

		for iter_51_2, iter_51_3 in pairs(var_51_4.can_wield) do
			if FindProfileIndex(iter_51_3) == arg_51_1 then
				var_51_5 = true
			end
		end

		if var_51_5 and not var_0_3[var_51_4.item_type] and not var_0_4[var_51_4.name] then
			var_51_0[iter_51_0] = nil
			var_51_3[#var_51_3 + 1] = iter_51_0
		end
	end

	local var_51_6 = {}

	for iter_51_4, iter_51_5 in pairs(var_51_1) do
		for iter_51_6, iter_51_7 in pairs(iter_51_5) do
			if iter_51_6 == "backend_id" then
				-- Nothing
			elseif not var_51_0[iter_51_7] then
				BackendItem.set_loadout_item(nil, var_51_1[iter_51_4].backend_id, iter_51_6)

				iter_51_5[iter_51_6] = nil

				if var_0_2[iter_51_6] then
					var_51_6[#var_51_6 + 1] = {
						slot = iter_51_6,
						profile_name = iter_51_4
					}
				end
			elseif var_51_2 and var_51_2[iter_51_7] then
				BackendItem.set_loadout_item(nil, var_51_1[iter_51_4].backend_id, iter_51_6)

				iter_51_5[iter_51_6] = nil

				if var_0_2[iter_51_6] then
					var_51_6[#var_51_6 + 1] = {
						slot = iter_51_6,
						profile_name = iter_51_4
					}
				end
			end
		end
	end

	local var_51_7 = ScriptUnit.extension(arg_51_2, "inventory_system")

	for iter_51_8, iter_51_9 in ipairs(var_51_6) do
		local var_51_8 = iter_51_9.profile_name
		local var_51_9 = iter_51_9.slot
		local var_51_10 = var_0_5(var_51_0, var_51_8, var_51_9)

		if var_51_10 then
			local var_51_11 = InventorySettings.slots_by_name[var_51_9].type

			if var_51_11 == "melee" or var_51_11 == "ranged" then
				local var_51_12 = var_51_11 == "melee" and "slot_melee" or "slot_ranged"

				var_51_7:create_equipment_in_slot(var_51_12, var_51_10)
				var_51_7:wield(var_51_12)
			elseif var_51_11 == "hat" then
				ScriptUnit.extension(arg_51_2, "attachment_system"):create_attachment_in_slot(var_51_9, var_51_10)
			elseif var_51_11 == "trinket" then
				ScriptUnit.extension(arg_51_2, "attachment_system"):create_attachment_in_slot(var_51_9, var_51_10)
			end

			Crashify.print_exception("BackendInterfaceItem", "Slot %q was empty, putting item %d in it", var_51_9, var_51_10)
			BackendItem.set_loadout_item(var_51_10, var_51_1[var_51_8].backend_id, var_51_9)

			var_51_6[iter_51_8] = nil
			var_51_1[var_51_8][var_51_9] = var_51_10
		end
	end

	fassert(table.is_empty(var_51_6), "[BackendInterfaceItem] Your backend save is broken, ask for help resetting it")

	arg_51_0._items = var_51_0
	arg_51_0._loadout = var_51_1
	arg_51_0._profile_cache = {}

	arg_51_0._backend_items:make_dirty()

	arg_51_0._dirty = true

	for iter_51_10, iter_51_11 in ipairs(var_51_3) do
		arg_51_0:remove_item(iter_51_11)
	end
end

BackendInterfaceItem.get_runes = function (arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0:get_item_from_id(arg_52_1)

	if var_52_0 then
		return var_52_0.runes
	end

	return nil
end

BackendInterfaceItem._slot_item_rune = function (arg_53_0, arg_53_1, arg_53_2)
	return
end

BackendInterfaceItem.get_item_template = function (arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_1.temporary_template or arg_54_1.template
	local var_54_1 = WeaponUtils.get_weapon_template(var_54_0)

	if var_54_1 then
		return var_54_1
	end

	local var_54_2 = Attachments[var_54_0]

	if var_54_2 then
		return var_54_2
	end

	local var_54_3 = Cosmetics[var_54_0]

	if var_54_3 then
		return var_54_3
	end

	fassert(false, "no item_template for item: " .. arg_54_1.key .. ", template name = " .. var_54_0)
end

BackendInterfaceItem._command_item_whitelist = function (arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0._backend_items

	if arg_55_1.enabled then
		var_55_0:set_item_whitelist(arg_55_1.items)
	end

	var_55_0:data_server_queue():unregister_executor("item_whitelist")
end
