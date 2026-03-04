-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_inn.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/game_mode/spawning_components/adventure_spawning")
require("scripts/managers/game_mode/adventure_profile_rules")

local var_0_0 = false
local var_0_1 = false

GameModeInn = class(GameModeInn, GameModeBase)

GameModeInn.init = function (arg_1_0, arg_1_1, arg_1_2, ...)
	GameModeInn.super.init(arg_1_0, arg_1_1, arg_1_2, ...)

	arg_1_0._adventure_profile_rules = AdventureProfileRules:new(arg_1_0._profile_synchronizer, arg_1_0._network_server)

	local var_1_0 = Managers.state.side:get_side_from_name("heroes")

	arg_1_0._adventure_spawning = AdventureSpawning:new(arg_1_0._profile_synchronizer, var_1_0, arg_1_0._is_server, arg_1_0._network_server)

	arg_1_0:_register_player_spawner(arg_1_0._adventure_spawning)

	arg_1_0._objective_units = nil
	arg_1_0._state = "_state_none"
	arg_1_0._matchmaking_manager = Managers.matchmaking
	arg_1_0._objective_markers = {}
	arg_1_0._current_objective_id = nil
	arg_1_0._current_waystone_type = 1
	arg_1_0._show_tutorial = true
	arg_1_0._waystone_is_active = false
	arg_1_0._waystone_type = 0
	arg_1_0._player_manager = Managers.player
	arg_1_0._statistics_db = arg_1_0._player_manager:statistics_db()

	Managers.state.event:register(arg_1_0, "level_start_local_player_spawned", "event_local_player_spawned")

	arg_1_0._local_player_spawned = false
end

GameModeInn.destroy = function (arg_2_0)
	local var_2_0 = Managers.state.event

	if var_2_0 then
		var_2_0:unregister("level_start_local_player_spawned", arg_2_0)
	end
end

GameModeInn.register_rpcs = function (arg_3_0, arg_3_1, arg_3_2)
	GameModeInn.super.register_rpcs(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._adventure_spawning:register_rpcs(arg_3_1, arg_3_2)

	arg_3_0._network_event_delegate = arg_3_1

	arg_3_0._network_event_delegate:register(arg_3_0, "rpc_waystone_active")
end

GameModeInn.unregister_rpcs = function (arg_4_0)
	arg_4_0._adventure_spawning:unregister_rpcs()
	arg_4_0._network_event_delegate:unregister(arg_4_0)

	arg_4_0._network_event_delegate = nil

	GameModeInn.super.unregister_rpcs(arg_4_0)
end

GameModeInn.update = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_update_objectives()
	arg_5_0._adventure_spawning:update(arg_5_1, arg_5_2)
end

GameModeInn.server_update = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._adventure_spawning:server_update(arg_6_1, arg_6_2)
end

GameModeInn.evaluate_end_conditions = function (arg_7_0, arg_7_1)
	if var_0_0 then
		var_0_0 = false

		return true, "won"
	end

	if arg_7_0:_is_time_up() then
		return true, "reload"
	end

	if var_0_1 then
		var_0_1 = false

		return true, "lost"
	end

	if arg_7_0:update_end_level_areas() then
		return true, "start_game"
	elseif arg_7_0._level_completed then
		return true, "start_game"
	else
		return false
	end
end

GameModeInn.event_local_player_spawned = function (arg_8_0, arg_8_1)
	arg_8_0._local_player_spawned = true
	arg_8_0._is_initial_spawn = arg_8_1
end

GameModeInn.COMPLETE_LEVEL = function (arg_9_0)
	var_0_0 = true
end

GameModeInn.FAIL_LEVEL = function (arg_10_0)
	var_0_1 = true
end

GameModeInn.player_entered_game_session = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	GameModeInn.super.player_entered_game_session(arg_11_0, arg_11_1, arg_11_2, arg_11_3)

	if Managers.party:get_player_status(arg_11_1, arg_11_2).party_id ~= 1 then
		local var_11_0 = 1

		Managers.party:assign_peer_to_party(arg_11_1, arg_11_2, var_11_0)
	end

	arg_11_0._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_11_1, arg_11_2)
end

GameModeInn.flow_callback_add_spawn_point = function (arg_12_0, arg_12_1)
	arg_12_0._adventure_spawning:add_spawn_point(arg_12_1)
end

GameModeInn.respawn_unit_spawned = function (arg_13_0, arg_13_1)
	arg_13_0._adventure_spawning:respawn_unit_spawned(arg_13_1)
end

GameModeInn.get_respawn_handler = function (arg_14_0)
	return arg_14_0._adventure_spawning:get_respawn_handler()
end

GameModeInn.respawn_gate_unit_spawned = function (arg_15_0, arg_15_1)
	arg_15_0._adventure_spawning:respawn_gate_unit_spawned(arg_15_1)
end

GameModeInn.force_respawn = function (arg_16_0, arg_16_1, arg_16_2)
	if Managers.party:get_player_status(arg_16_1, arg_16_2).party_id == 0 then
		local var_16_0 = 1

		Managers.party:assign_peer_to_party(arg_16_1, arg_16_2, var_16_0)
	end

	arg_16_0._adventure_spawning:force_respawn(arg_16_1, arg_16_2)
end

GameModeInn._update_objectives = function (arg_17_0)
	if not arg_17_0._objective_units then
		arg_17_0._objective_units = Managers.state.entity:get_entities("ObjectiveUnitExtension")

		for iter_17_0, iter_17_1 in pairs(arg_17_0._objective_units) do
			local var_17_0 = Unit.get_data(iter_17_0, "objective_id")

			if var_17_0 then
				arg_17_0._objective_markers[var_17_0] = iter_17_0
			end

			arg_17_0:_deactivate_objective_marker(iter_17_0)
		end
	else
		arg_17_0:_update_objective_marker()
	end
end

GameModeInn._update_objective_marker = function (arg_18_0)
	local var_18_0 = arg_18_0._matchmaking_manager:is_game_matchmaking()

	if arg_18_0._show_tutorial and not var_18_0 then
		local var_18_1, var_18_2 = arg_18_0:_should_show_tutorial()

		if var_18_1 then
			arg_18_0:_state_tutorial(var_18_2)
		end

		arg_18_0._show_tutorial = var_18_1
	end

	if var_18_0 then
		arg_18_0:_state_game_is_matchmaking()
	elseif not var_18_0 and not arg_18_0._show_tutorial then
		arg_18_0:_state_choose_map()
	end
end

local var_0_2 = {
	"waystone",
	"waystone",
	"waystone_weave"
}

GameModeInn._state_game_is_matchmaking = function (arg_19_0)
	if arg_19_0._is_server then
		local var_19_0, var_19_1 = arg_19_0._matchmaking_manager:waystone_is_active()

		if arg_19_0._waystone_is_active ~= var_19_0 then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_waystone_active", var_19_1, var_19_0, arg_19_0._current_waystone_type)

			arg_19_0._waystone_is_active = var_19_0
			arg_19_0._waystone_type = var_19_1
		end
	end

	local var_19_2 = arg_19_0._current_objective_id

	if arg_19_0._waystone_is_active then
		arg_19_0._current_waystone_type = arg_19_0._waystone_type

		local var_19_3 = var_0_2[arg_19_0._waystone_type]

		if var_19_3 ~= var_19_2 then
			arg_19_0:_deactivate_objective_marker(var_19_2)
			arg_19_0:_activate_objective_marker(var_19_3)
		end
	elseif var_19_2 then
		arg_19_0:_deactivate_objective_marker(var_19_2)
	end
end

local var_0_3 = {
	"map",
	"map",
	"wom_tutorial_weave_select"
}

GameModeInn._state_choose_map = function (arg_20_0)
	local var_20_0 = arg_20_0._current_objective_id
	local var_20_1 = var_0_3[arg_20_0._current_waystone_type]

	if arg_20_0._is_server and arg_20_0._waystone_is_active then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_waystone_active", arg_20_0._waystone_type, false, arg_20_0._current_waystone_type)

		arg_20_0._waystone_is_active = false
	end

	if var_20_1 ~= var_20_0 then
		arg_20_0:_deactivate_objective_marker(var_20_0)
		arg_20_0:_activate_objective_marker(var_20_1)
	end
end

GameModeInn._should_show_tutorial = function (arg_21_0)
	local var_21_0 = arg_21_0._player_manager:local_player(1)

	if var_21_0 then
		local var_21_1 = var_21_0:stats_id()
		local var_21_2 = arg_21_0._statistics_db:get_persistent_stat(var_21_1, "scorpion_onboarding_step")

		return var_21_2 > 0 and var_21_2 < 10, var_21_2
	end

	return false
end

GameModeInn._state_tutorial = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._current_objective_id
	local var_22_1

	if arg_22_1 == 1 then
		var_22_1 = "wom_tutorial_mission_select"
	elseif arg_22_1 == 3 then
		var_22_1 = "wom_tutorial_weave_area"
	elseif arg_22_1 == 4 then
		var_22_1 = "wom_tutorial_athanor"
	elseif arg_22_1 == 5 then
		var_22_1 = "wom_tutorial_weave_select"
	elseif arg_22_1 == 6 then
		var_22_1 = "wom_tutorial_weave_select"
	elseif arg_22_1 == 7 then
		var_22_1 = "wom_tutorial_athanor"
	elseif arg_22_1 == 8 then
		var_22_1 = "wom_tutorial_weave_select"
	elseif arg_22_1 == 9 then
		var_22_1 = "wom_tutorial_athanor"
	end

	if var_22_1 ~= var_22_0 then
		arg_22_0:_deactivate_objective_marker(var_22_0)
		arg_22_0:_activate_objective_marker(var_22_1)
	end
end

GameModeInn._activate_objective_marker = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._objective_markers[arg_23_1]

	if var_23_0 then
		arg_23_0._current_objective_id = arg_23_1

		ScriptUnit.extension(var_23_0, "tutorial_system"):set_active(true)
	end
end

GameModeInn._deactivate_objective_marker = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0._objective_markers[arg_24_1]

	if var_24_0 then
		ScriptUnit.extension(var_24_0, "tutorial_system"):set_active(false)
	end

	arg_24_0._current_objective_id = nil
end

GameModeInn.rpc_waystone_active = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	arg_25_0._waystone_is_active = arg_25_3
	arg_25_0._waystone_type = arg_25_2
	arg_25_0._current_waystone_type = arg_25_4
end

GameModeInn.hot_join_sync = function (arg_26_0, arg_26_1)
	arg_26_0._waystone_is_active = false
	arg_26_0._waystone_type = 0

	local var_26_0 = PEER_ID_TO_CHANNEL[arg_26_1]

	RPC.rpc_waystone_active(var_26_0, arg_26_0._waystone_type, arg_26_0._waystone_is_active, arg_26_0._current_waystone_type)
end

GameModeInn.local_player_ready_to_start = function (arg_27_0, arg_27_1, arg_27_2)
	if not arg_27_0._local_player_spawned then
		return false
	end

	return true
end

GameModeInn.local_player_game_starts = function (arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_2.show_profile_on_startup

	arg_28_2.show_profile_on_startup = nil

	if var_28_0 and not LEVEL_EDITOR_TEST and not Development.parameter("skip-start-menu") then
		local var_28_1 = PLATFORM
		local var_28_2
		local var_28_3

		if IS_CONSOLE then
			var_28_2 = "initial_character_selection_force"
			var_28_3 = "character"
		elseif GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen") then
			local var_28_4 = not SaveData.first_hero_selection_made and not Managers.backend:is_waiting_for_user_input()

			var_28_2 = "initial_start_menu_view_force"
			var_28_3 = var_28_4 and "character" or "overview"
		else
			var_28_2 = "initial_character_selection_force"
			var_28_3 = "character"
		end

		Managers.ui:handle_transition(var_28_2, {
			menu_state_name = var_28_3,
			on_exit_callback = callback(arg_28_0, "_cb_start_menu_closed")
		})
	else
		arg_28_0:_cb_start_menu_closed()
	end

	if arg_28_0._is_initial_spawn then
		LevelHelper:flow_event(arg_28_0._world, "local_player_spawned")

		if Development.parameter("attract_mode") then
			LevelHelper:flow_event(arg_28_0._world, "start_benchmark")
		else
			LevelHelper:flow_event(arg_28_0._world, "level_start_local_player_spawned")
		end
	end

	print("[GameModeInn] Start menu opened")
end

GameModeInn._cb_start_menu_closed = function (arg_29_0)
	print("[GameModeInn] Start menu closed")

	local var_29_0 = arg_29_0._world
	local var_29_1 = false

	if not PlayerData.first_time_store_release then
		LevelHelper:flow_event(var_29_0, "first_time_store_release")

		PlayerData.first_time_store_release = true
		var_29_1 = true
	end

	if PlayerData.store_new_items and GameSettingsDevelopment.store_nags then
		LevelHelper:flow_event(var_29_0, "shop_new_items")

		PlayerData.store_new_items = false
		var_29_1 = true
	end

	if var_29_1 then
		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end

	Managers.ui:ingame_ui().has_left_menu = true

	Managers.state.event:trigger("tutorial_trigger", "keep_menu_left")
end
