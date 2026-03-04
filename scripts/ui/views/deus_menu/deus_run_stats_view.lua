-- chunkname: @scripts/ui/views/deus_menu/deus_run_stats_view.lua

require("scripts/ui/views/deus_menu/deus_run_stats_ui")

DeusRunStatsView = class(DeusRunStatsView)

local var_0_0 = 1

DeusRunStatsView.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._ingame_hud = arg_1_1
	arg_1_0._is_server = arg_1_2.is_server
	arg_1_0._deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()

	local var_1_0 = "deus_run_stats_view"
	local var_1_1 = arg_1_2.input_manager

	arg_1_0._input_manager = var_1_1
	arg_1_0._input_service_name = var_1_0

	var_1_1:create_input_service(var_1_0, "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_1:map_device_to_service(var_1_0, "keyboard")
	var_1_1:map_device_to_service(var_1_0, "gamepad")
	var_1_1:map_device_to_service(var_1_0, "mouse")

	arg_1_0._ui = DeusRunStatsUi:new(arg_1_2, arg_1_0)
end

DeusRunStatsView.on_enter = function (arg_2_0)
	arg_2_0._input_manager:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, arg_2_0._input_service_name, "DeusRunStatsView")
end

DeusRunStatsView.on_exit = function (arg_3_0)
	arg_3_0._input_manager:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, arg_3_0._input_service_name, "DeusRunStatsView")
end

DeusRunStatsView.update = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._ui:update(arg_4_1, arg_4_2)
	arg_4_0:_handle_input(arg_4_1, arg_4_2)
end

DeusRunStatsView.input_service = function (arg_5_0)
	return arg_5_0._input_manager:get_service(arg_5_0._input_service_name)
end

DeusRunStatsView.is_ui_active = function (arg_6_0)
	return arg_6_0._ui:active()
end

DeusRunStatsView._handle_input = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._input_manager:get_service(arg_7_0._input_service_name)
	local var_7_1 = var_7_0:get("hotkey_deus_inventory", false)
	local var_7_2 = Managers.input:is_device_active("gamepad")
	local var_7_3 = arg_7_0._ui:active()

	if var_7_3 then
		if var_7_0:get("right_press") then
			arg_7_0._ui:lock(true)
		end

		if arg_7_0._ui:force_update_power_ups() then
			arg_7_0:_update_dynamic_values()
		end
	elseif var_7_3 ~= var_7_1 and var_7_1 == true then
		arg_7_0:_update_dynamic_values()
		arg_7_0:_update_inventory()

		local var_7_4 = Managers.player:local_player().player_unit == nil

		if var_7_4 or var_7_2 then
			arg_7_0._ui:lock(true, var_7_4)
		end
	end

	local var_7_5 = arg_7_0._ui:locked() and not Managers.ui:end_screen_active() and not arg_7_0:_is_in_deus_map_view()

	arg_7_0._ui:set_active(var_7_5 or var_7_1)
end

DeusRunStatsView.destroy = function (arg_8_0)
	arg_8_0._ui:destroy()
end

DeusRunStatsView._update_dynamic_values = function (arg_9_0)
	local var_9_0 = arg_9_0._deus_run_controller
	local var_9_1 = var_9_0:get_blessings()
	local var_9_2 = table.keys(DeusBlessingSettings)
	local var_9_3 = var_9_0:get_own_peer_id()
	local var_9_4 = var_9_0:get_player_power_ups(var_9_3, var_0_0)
	local var_9_5 = var_9_0:get_party_power_ups()
	local var_9_6, var_9_7 = var_9_0:get_player_profile(var_9_3, var_0_0)
	local var_9_8 = {
		blessings = var_9_1,
		power_ups = var_9_4,
		party_power_ups = var_9_5,
		profile_index = var_9_6,
		career_index = var_9_7
	}

	arg_9_0._ui:update_dynamic_values(var_9_8)
end

DeusRunStatsView._update_inventory = function (arg_10_0)
	local var_10_0 = arg_10_0._deus_run_controller
	local var_10_1, var_10_2 = var_10_0:get_own_loadout()
	local var_10_3 = var_10_0:get_own_peer_id()
	local var_10_4 = var_10_0:get_player_consumable_healthkit_slot(var_10_3, var_0_0)
	local var_10_5 = var_10_0:get_player_consumable_potion_slot(var_10_3, var_0_0)
	local var_10_6 = rawget(ItemMasterList, var_10_5)

	if not var_10_6 or var_10_6.hide_in_frame_ui then
		local var_10_7 = var_10_0:get_player_additional_items(var_10_3, var_0_0)
		local var_10_8 = var_10_7.slot_potion and var_10_7.slot_potion.items

		if var_10_8 then
			for iter_10_0 = 1, #var_10_8 do
				local var_10_9 = var_10_8[iter_10_0]

				if not var_10_9.hide_in_frame_ui then
					var_10_5 = var_10_9.key

					break
				end
			end
		end
	end

	local var_10_10 = var_10_0:get_player_consumable_grenade_slot(var_10_3, var_0_0)

	if arg_10_0._melee ~= var_10_1 or arg_10_0._ranged ~= var_10_2 or arg_10_0._potion_slot ~= var_10_5 or arg_10_0._grenade_slot ~= var_10_10 or arg_10_0._healing_slot ~= var_10_4 then
		arg_10_0._ui:set_loadout(var_10_1, var_10_2, var_10_4, var_10_5, var_10_10)

		arg_10_0._melee = var_10_1
		arg_10_0._ranged = var_10_2
		arg_10_0._potion_slot = var_10_5
		arg_10_0._grenade_slot = var_10_10
		arg_10_0._healing_slot = var_10_4
	end
end

DeusRunStatsView._is_in_deus_map_view = function (arg_11_0)
	if Managers.mechanism:current_mechanism_name() ~= "deus" then
		return false
	end

	return Managers.mechanism:get_state() == "map_deus"
end
