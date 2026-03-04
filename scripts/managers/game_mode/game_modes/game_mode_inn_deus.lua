-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_inn_deus.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/game_mode/spawning_components/adventure_spawning")
require("scripts/managers/game_mode/adventure_profile_rules")

local var_0_0 = false
local var_0_1 = false

GameModeInnDeus = class(GameModeInnDeus, GameModeBase)

function GameModeInnDeus.init(arg_1_0, arg_1_1, arg_1_2, ...)
	GameModeInnDeus.super.init(arg_1_0, arg_1_1, arg_1_2, ...)

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
	arg_1_0._waystone_is_active = false
	arg_1_0._waystone_type = 0
	arg_1_0._player_manager = Managers.player
	arg_1_0._statistics_db = arg_1_0._player_manager:statistics_db()

	Managers.state.event:register(arg_1_0, "level_start_local_player_spawned", "event_local_player_spawned")

	arg_1_0._local_player_spawned = false
end

function GameModeInnDeus.register_rpcs(arg_2_0, arg_2_1, arg_2_2)
	GameModeInnDeus.super.register_rpcs(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._adventure_spawning:register_rpcs(arg_2_1, arg_2_2)

	arg_2_0._network_event_delegate = arg_2_1

	arg_2_0._network_event_delegate:register(arg_2_0, "rpc_waystone_active")
end

function GameModeInnDeus.unregister_rpcs(arg_3_0)
	arg_3_0._adventure_spawning:unregister_rpcs()
	arg_3_0._network_event_delegate:unregister(arg_3_0)

	arg_3_0._network_event_delegate = nil

	GameModeInnDeus.super.unregister_rpcs(arg_3_0)
end

function GameModeInnDeus.update(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0:_update_objectives()
	arg_4_0._adventure_spawning:update(arg_4_1, arg_4_2)
end

function GameModeInnDeus.server_update(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._adventure_spawning:server_update(arg_5_1, arg_5_2)
end

function GameModeInnDeus.evaluate_end_conditions(arg_6_0, arg_6_1)
	if var_0_0 then
		var_0_0 = false

		return true, "won"
	end

	if arg_6_0:_is_time_up() then
		return true, "reload"
	end

	if var_0_1 then
		var_0_1 = false

		return true, "lost"
	end

	if arg_6_0:update_end_level_areas() then
		return true, "start_game"
	elseif arg_6_0._level_completed then
		return true, "start_game"
	else
		return false
	end
end

function GameModeInnDeus.event_local_player_spawned(arg_7_0, arg_7_1)
	arg_7_0._local_player_spawned = true
	arg_7_0._is_initial_spawn = arg_7_1
end

function GameModeInnDeus.COMPLETE_LEVEL(arg_8_0)
	var_0_0 = true
end

function GameModeInnDeus.FAIL_LEVEL(arg_9_0)
	var_0_1 = true
end

function GameModeInnDeus.player_entered_game_session(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	GameModeInnDeus.super.player_entered_game_session(arg_10_0, arg_10_1, arg_10_2, arg_10_3)

	if Managers.party:get_player_status(arg_10_1, arg_10_2).party_id ~= 1 then
		local var_10_0 = 1

		Managers.party:assign_peer_to_party(arg_10_1, arg_10_2, var_10_0)
	end

	arg_10_0._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_10_1, arg_10_2)
end

function GameModeInnDeus.flow_callback_add_spawn_point(arg_11_0, arg_11_1)
	arg_11_0._adventure_spawning:add_spawn_point(arg_11_1)
end

function GameModeInnDeus.respawn_unit_spawned(arg_12_0, arg_12_1)
	arg_12_0._adventure_spawning:respawn_unit_spawned(arg_12_1)
end

function GameModeInnDeus.get_respawn_handler(arg_13_0)
	return arg_13_0._adventure_spawning:get_respawn_handler()
end

function GameModeInnDeus.respawn_gate_unit_spawned(arg_14_0, arg_14_1)
	arg_14_0._adventure_spawning:respawn_gate_unit_spawned(arg_14_1)
end

function GameModeInnDeus.force_respawn(arg_15_0, arg_15_1, arg_15_2)
	if Managers.party:get_player_status(arg_15_1, arg_15_2).party_id == 0 then
		local var_15_0 = 1

		Managers.party:assign_peer_to_party(arg_15_1, arg_15_2, var_15_0)
	end

	arg_15_0._adventure_spawning:force_respawn(arg_15_1, arg_15_2)
end

function GameModeInnDeus._update_objectives(arg_16_0)
	if not arg_16_0._objective_units then
		arg_16_0._objective_units = Managers.state.entity:get_entities("ObjectiveUnitExtension")

		for iter_16_0, iter_16_1 in pairs(arg_16_0._objective_units) do
			local var_16_0 = Unit.get_data(iter_16_0, "objective_id")

			if var_16_0 then
				arg_16_0._objective_markers[var_16_0] = iter_16_0
			end

			arg_16_0:_deactivate_objective_marker(iter_16_0)
		end
	else
		arg_16_0:_update_objective_marker()
	end
end

function GameModeInnDeus._update_objective_marker(arg_17_0)
	if arg_17_0._matchmaking_manager:is_game_matchmaking() then
		arg_17_0:_state_game_is_matchmaking()
	else
		arg_17_0:_state_choose_map()
	end
end

local var_0_2 = {
	"waystone",
	"waystone",
	"waystone_weave"
}

function GameModeInnDeus._state_game_is_matchmaking(arg_18_0)
	if arg_18_0._is_server then
		local var_18_0, var_18_1 = arg_18_0._matchmaking_manager:waystone_is_active()

		if arg_18_0._waystone_is_active ~= var_18_0 then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_waystone_active", var_18_1, var_18_0, arg_18_0._current_waystone_type)

			arg_18_0._waystone_is_active = var_18_0
			arg_18_0._waystone_type = var_18_1
		end
	end

	local var_18_2 = arg_18_0._current_objective_id

	if arg_18_0._waystone_is_active then
		arg_18_0._current_waystone_type = arg_18_0._waystone_type

		local var_18_3 = var_0_2[arg_18_0._waystone_type]

		if var_18_3 ~= var_18_2 then
			arg_18_0:_deactivate_objective_marker(var_18_2)
			arg_18_0:_activate_objective_marker(var_18_3)
		end
	elseif var_18_2 then
		arg_18_0:_deactivate_objective_marker(var_18_2)
	end
end

local var_0_3 = {
	"map",
	"map"
}

function GameModeInnDeus._state_choose_map(arg_19_0)
	local var_19_0 = arg_19_0._current_objective_id
	local var_19_1 = var_0_3[arg_19_0._current_waystone_type]

	if arg_19_0._is_server and arg_19_0._waystone_is_active then
		Managers.state.network.network_transmit:send_rpc_clients("rpc_waystone_active", arg_19_0._waystone_type, false, arg_19_0._current_waystone_type)

		arg_19_0._waystone_is_active = false
	end

	if var_19_1 ~= var_19_0 then
		arg_19_0:_deactivate_objective_marker(var_19_0)
		arg_19_0:_activate_objective_marker(var_19_1)
	end
end

function GameModeInnDeus._activate_objective_marker(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._objective_markers[arg_20_1]

	if var_20_0 then
		arg_20_0._current_objective_id = arg_20_1

		ScriptUnit.extension(var_20_0, "tutorial_system"):set_active(true)
	end
end

function GameModeInnDeus._deactivate_objective_marker(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._objective_markers[arg_21_1]

	if var_21_0 then
		ScriptUnit.extension(var_21_0, "tutorial_system"):set_active(false)
	end

	arg_21_0._current_objective_id = nil
end

function GameModeInnDeus.rpc_waystone_active(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
	arg_22_0._waystone_is_active = arg_22_3
	arg_22_0._waystone_type = arg_22_2
	arg_22_0._current_waystone_type = arg_22_4
end

function GameModeInnDeus.hot_join_sync(arg_23_0, arg_23_1)
	arg_23_0._waystone_is_active = false
	arg_23_0._waystone_type = 0

	local var_23_0 = PEER_ID_TO_CHANNEL[arg_23_1]

	RPC.rpc_waystone_active(var_23_0, arg_23_0._waystone_type, arg_23_0._waystone_is_active, arg_23_0._current_waystone_type)
end

function GameModeInnDeus.local_player_ready_to_start(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_0._local_player_spawned then
		return false
	end

	return true
end

function GameModeInnDeus.local_player_game_starts(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_2.show_profile_on_startup

	arg_25_2.show_profile_on_startup = nil

	if var_25_0 and not LEVEL_EDITOR_TEST and not Development.parameter("skip-start-menu") then
		local var_25_1 = PLATFORM

		if IS_CONSOLE then
			Managers.ui:handle_transition("initial_character_selection_force", {
				menu_state_name = "character",
				on_exit_callback = callback(arg_25_0, "_cb_start_menu_closed")
			})
		elseif GameSettingsDevelopment.skip_start_screen or Development.parameter("skip_start_screen") then
			local var_25_2 = SaveData.first_hero_selection_made
			local var_25_3 = not Managers.backend:is_waiting_for_user_input() and not var_25_2

			Managers.ui:handle_transition("initial_start_menu_view_force", {
				menu_state_name = var_25_3 and "character" or "overview",
				on_exit_callback = callback(arg_25_0, "_cb_start_menu_closed")
			})
		else
			Managers.ui:handle_transition("initial_character_selection_force", {
				menu_state_name = "character",
				on_exit_callback = callback(arg_25_0, "_cb_start_menu_closed")
			})
		end
	else
		Managers.state.event:trigger("tutorial_trigger", "keep_menu_left")
	end

	if arg_25_0._is_initial_spawn then
		LevelHelper:flow_event(arg_25_0._world, "local_player_spawned")

		if Development.parameter("attract_mode") then
			LevelHelper:flow_event(arg_25_0._world, "start_benchmark")
		else
			LevelHelper:flow_event(arg_25_0._world, "level_start_local_player_spawned")
		end
	end
end

function GameModeInnDeus._cb_start_menu_closed(arg_26_0)
	Managers.state.event:trigger("tutorial_trigger", "keep_menu_left")
end
