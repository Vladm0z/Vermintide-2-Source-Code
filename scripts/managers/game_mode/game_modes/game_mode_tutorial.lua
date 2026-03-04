-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_tutorial.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")

script_data.disable_gamemode_end = script_data.disable_gamemode_end or Development.parameter("disable_gamemode_end")
GameModeTutorial = class(GameModeTutorial, GameModeBase)

local var_0_0 = false
local var_0_1 = false

function GameModeTutorial.init(arg_1_0, arg_1_1, arg_1_2, ...)
	GameModeTutorial.super.init(arg_1_0, arg_1_1, arg_1_2, ...)

	local var_1_0 = Managers.state.side:get_side_from_name("heroes")

	arg_1_0._adventure_spawning = AdventureSpawning:new(arg_1_0._profile_synchronizer, var_1_0, arg_1_0._is_server, arg_1_0._network_server)

	arg_1_0:_register_player_spawner(arg_1_0._adventure_spawning)
	arg_1_0:_switch_profile_to_tutorial()
	Managers.state.event:register(arg_1_0, "level_start_local_player_spawned", "event_local_player_spawned")

	arg_1_0._hud_disabled = false
	arg_1_0._bot_players = {}
end

function GameModeTutorial._switch_profile_to_tutorial(arg_2_0)
	local var_2_0 = Network.peer_id()
	local var_2_1 = 1
	local var_2_2, var_2_3 = arg_2_0._profile_synchronizer:profile_by_peer(var_2_0, var_2_1)

	if var_2_2 and var_2_3 then
		arg_2_0._previous_profile_index = var_2_2
		arg_2_0._previous_career_index = var_2_3
	end

	local var_2_4 = PROFILES_BY_AFFILIATION.tutorial[1]

	arg_2_0._tutorial_profile_index = FindProfileIndex(var_2_4)
	arg_2_0._tutorial_career_index = 1
	arg_2_0._local_player_spawned = false

	local var_2_5 = false

	arg_2_0._profile_synchronizer:assign_full_profile(var_2_0, var_2_1, arg_2_0._tutorial_profile_index, arg_2_0._tutorial_career_index, var_2_5)
end

function GameModeTutorial._switch_back_to_previous_profile(arg_3_0)
	local var_3_0 = Network.peer_id()
	local var_3_1 = 1
	local var_3_2 = arg_3_0._previous_profile_index
	local var_3_3 = arg_3_0._previous_career_index

	if var_3_2 and var_3_3 then
		local var_3_4 = false

		arg_3_0._profile_synchronizer:assign_full_profile(var_3_0, var_3_1, var_3_2, var_3_3, var_3_4)
	else
		arg_3_0._profile_synchronizer:unassign_profiles_of_peer(var_3_0, var_3_1)
	end
end

function GameModeTutorial.register_rpcs(arg_4_0, arg_4_1, arg_4_2)
	GameModeTutorial.super.register_rpcs(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._adventure_spawning:register_rpcs(arg_4_1, arg_4_2)
end

function GameModeTutorial.unregister_rpcs(arg_5_0)
	arg_5_0._adventure_spawning:unregister_rpcs()
	GameModeTutorial.super.unregister_rpcs(arg_5_0)
end

function GameModeTutorial.player_entered_game_session(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	GameModeTutorial.super.player_entered_game_session(arg_6_0, arg_6_1, arg_6_2, arg_6_3)

	local var_6_0, var_6_1 = Managers.party:get_party_from_player_id(arg_6_1, arg_6_2)

	if var_6_1 ~= 1 then
		local var_6_2 = 1

		Managers.party:request_join_party(arg_6_1, arg_6_2, var_6_2)
	end
end

function GameModeTutorial.event_local_player_spawned(arg_7_0, arg_7_1)
	arg_7_0._local_player_spawned = true
	arg_7_0._is_initial_spawn = arg_7_1
end

function GameModeTutorial.destroy(arg_8_0)
	arg_8_0:_switch_back_to_previous_profile()
end

function GameModeTutorial.cleanup_game_mode_units(arg_9_0)
	arg_9_0:_clear_bots()
end

function GameModeTutorial._clear_bots(arg_10_0)
	local var_10_0 = arg_10_0._bot_players

	for iter_10_0 = #var_10_0, 1, -1 do
		arg_10_0:_remove_bot(var_10_0[iter_10_0])
	end
end

function GameModeTutorial.add_bot(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._bot_players
	local var_11_1 = 1
	local var_11_2 = arg_11_0:_add_bot_to_party(var_11_1, arg_11_1, arg_11_2)

	var_11_0[#var_11_0 + 1] = var_11_2
end

function GameModeTutorial._remove_bot(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._bot_players
	local var_12_1 = table.index_of(var_12_0, arg_12_1)

	arg_12_0:_remove_bot_instant(arg_12_1)

	local var_12_2 = #var_12_0

	var_12_0[var_12_1] = var_12_0[var_12_2]
	var_12_0[var_12_2] = nil
end

function GameModeTutorial.update(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0._adventure_spawning:update(arg_13_1, arg_13_2)
end

function GameModeTutorial.server_update(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0._adventure_spawning:server_update(arg_14_1, arg_14_2)
end

function GameModeTutorial.evaluate_end_conditions(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if var_0_0 then
		arg_15_0:complete_level()

		var_0_0 = false
	end
end

function GameModeTutorial.mutators(arg_16_0)
	return
end

function GameModeTutorial.complete_level(arg_17_0)
	StatisticsUtil.register_complete_tutorial(Managers.state.game_mode.statistics_db)

	local var_17_0 = Managers.backend

	var_17_0:get_interface("statistics"):save()
	var_17_0:commit(true)

	arg_17_0._transition = "finish_tutorial"
end

function GameModeTutorial.wanted_transition(arg_18_0)
	return arg_18_0._transition
end

function GameModeTutorial.COMPLETE_LEVEL(arg_19_0)
	var_0_0 = true
end

function GameModeTutorial.game_mode_hud_disabled(arg_20_0)
	return arg_20_0._hud_disabled
end

function GameModeTutorial.disable_hud(arg_21_0, arg_21_1)
	arg_21_0._hud_disabled = arg_21_1
end

function GameModeTutorial.FAIL_LEVEL(arg_22_0)
	var_0_1 = true
end

function GameModeTutorial.disable_player_spawning(arg_23_0)
	arg_23_0._adventure_spawning:set_spawning_disabled(true)
end

function GameModeTutorial.enable_player_spawning(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0._adventure_spawning:set_spawning_disabled(false)
	arg_24_0._adventure_spawning:force_update_spawn_positions(arg_24_1, arg_24_2)
end

function GameModeTutorial.teleport_despawned_players(arg_25_0, arg_25_1)
	arg_25_0._adventure_spawning:teleport_despawned_players(arg_25_1)
end

function GameModeTutorial.flow_callback_add_spawn_point(arg_26_0, arg_26_1)
	arg_26_0._adventure_spawning:add_spawn_point(arg_26_1)
end

function GameModeTutorial.set_override_respawn_group(arg_27_0, arg_27_1, arg_27_2)
	arg_27_0._adventure_spawning:set_override_respawn_group(arg_27_1, arg_27_2)
end

function GameModeTutorial.set_respawn_group_enabled(arg_28_0, arg_28_1, arg_28_2)
	arg_28_0._adventure_spawning:set_respawn_group_enabled(arg_28_1, arg_28_2)
end

function GameModeTutorial.set_respawn_gate_enabled(arg_29_0, arg_29_1, arg_29_2)
	arg_29_0._adventure_spawning:set_respawn_gate_enabled(arg_29_1, arg_29_2)
end

function GameModeTutorial.respawn_unit_spawned(arg_30_0, arg_30_1)
	arg_30_0._adventure_spawning:respawn_unit_spawned(arg_30_1)
end

function GameModeTutorial.get_respawn_handler(arg_31_0)
	return arg_31_0._adventure_spawning:get_respawn_handler()
end

function GameModeTutorial.respawn_gate_unit_spawned(arg_32_0, arg_32_1)
	arg_32_0._adventure_spawning:respawn_gate_unit_spawned(arg_32_1)
end

function GameModeTutorial.set_respawning_enabled(arg_33_0, arg_33_1)
	arg_33_0._adventure_spawning:set_respawning_enabled(arg_33_1)
end

function GameModeTutorial.remove_respawn_units_due_to_crossroads(arg_34_0, arg_34_1, arg_34_2)
	arg_34_0._adventure_spawning:remove_respawn_units_due_to_crossroads(arg_34_1, arg_34_2)
end

function GameModeTutorial.recalc_respawner_dist_due_to_crossroads(arg_35_0)
	arg_35_0._adventure_spawning:recalc_respawner_dist_due_to_crossroads()
end

function GameModeTutorial.force_respawn_dead_players(arg_36_0)
	arg_36_0._adventure_spawning:force_respawn_dead_players()
end

function GameModeTutorial.get_active_respawn_units(arg_37_0)
	return arg_37_0._adventure_spawning:get_active_respawn_units()
end

function GameModeTutorial.get_available_and_active_respawn_units(arg_38_0)
	return arg_38_0._adventure_spawning:get_available_and_active_respawn_units()
end

function GameModeTutorial.get_end_screen_config(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0
	local var_39_1 = {}

	if arg_39_1 then
		var_39_0 = "victory"

		local var_39_2 = arg_39_3:stats_id()
		local var_39_3 = arg_39_0._statistics_db
		local var_39_4 = arg_39_0._level_key
		local var_39_5 = LevelUnlockUtils.completed_level_difficulty_index(var_39_3, var_39_2, var_39_4) or 0

		var_39_1 = {
			level_key = var_39_4,
			previous_completed_difficulty_index = var_39_5
		}
	else
		var_39_0 = "defeat"
	end

	return var_39_0, var_39_1
end

function GameModeTutorial.ended(arg_40_0, arg_40_1)
	if not arg_40_0._network_server:are_all_peers_ingame() then
		arg_40_0._network_server:disconnect_joining_peers()
	end
end

function GameModeTutorial.local_player_ready_to_start(arg_41_0, arg_41_1)
	if not arg_41_0._local_player_spawned then
		return false
	end

	return true
end

function GameModeTutorial.local_player_game_starts(arg_42_0, arg_42_1, arg_42_2)
	if arg_42_0._is_initial_spawn then
		LevelHelper:flow_event(arg_42_0._world, "local_player_spawned")

		if Development.parameter("attract_mode") then
			LevelHelper:flow_event(arg_42_0._world, "start_benchmark")
		else
			LevelHelper:flow_event(arg_42_0._world, "level_start_local_player_spawned")
		end
	end
end
