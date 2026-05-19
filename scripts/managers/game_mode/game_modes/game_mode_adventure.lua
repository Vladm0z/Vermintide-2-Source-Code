-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_adventure.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/game_mode/spawning_components/adventure_spawning")
require("scripts/managers/game_mode/adventure_profile_rules")

script_data.disable_gamemode_end = script_data.disable_gamemode_end or Development.parameter("disable_gamemode_end")
GameModeAdventure = class(GameModeAdventure, GameModeBase)

function GameModeAdventure.init(arg_1_0, arg_1_1, arg_1_2, ...)
	GameModeAdventure.super.init(arg_1_0, arg_1_1, arg_1_2, ...)

	arg_1_0._lost_condition_timer = nil
	arg_1_0._adventure_profile_rules = AdventureProfileRules:new(arg_1_0._profile_synchronizer, arg_1_0._network_server)

	local var_1_0 = Managers.state.side:get_side_from_name("heroes")

	arg_1_0._adventure_spawning = AdventureSpawning:new(arg_1_0._profile_synchronizer, var_1_0, arg_1_0._is_server, arg_1_0._network_server)

	arg_1_0:_register_player_spawner(arg_1_0._adventure_spawning)

	arg_1_0._bot_players = {}

	arg_1_0:_setup_bot_spawn_priority_lookup()

	arg_1_0._available_profiles = table.clone(PROFILES_BY_AFFILIATION.heroes)

	Managers.state.event:register(arg_1_0, "level_start_local_player_spawned", "event_local_player_spawned")

	if LAUNCH_MODE == "attract_benchmark" then
		local var_1_1 = Network.peer_id()
		local var_1_2 = 1
		local var_1_3 = PROFILES_BY_AFFILIATION.tutorial[1]
		local var_1_4 = FindProfileIndex(var_1_3)
		local var_1_5 = 1
		local var_1_6 = false
		local var_1_7 = Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(var_1_1, var_1_4, var_1_5, false)

		fassert(var_1_7, "this should never happen in this particular situation")

		local var_1_8 = Managers.mechanism:reserved_party_id_by_peer(var_1_1)

		arg_1_0._profile_synchronizer:assign_full_profile(var_1_1, var_1_2, var_1_4, var_1_5, var_1_6)
		Managers.party:request_join_party(var_1_1, var_1_2, var_1_8)
	end

	arg_1_0._local_player_spawned = false
end

function GameModeAdventure.destroy(arg_2_0)
	return
end

function GameModeAdventure.cleanup_game_mode_units(arg_3_0)
	local var_3_0 = false

	arg_3_0:_clear_bots(var_3_0)
end

function GameModeAdventure.register_rpcs(arg_4_0, arg_4_1, arg_4_2)
	GameModeAdventure.super.register_rpcs(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._adventure_spawning:register_rpcs(arg_4_1, arg_4_2)
end

function GameModeAdventure.unregister_rpcs(arg_5_0)
	arg_5_0._adventure_spawning:unregister_rpcs()
	GameModeAdventure.super.unregister_rpcs(arg_5_0)
end

function GameModeAdventure.event_local_player_spawned(arg_6_0, arg_6_1)
	arg_6_0._local_player_spawned = true
	arg_6_0._is_initial_spawn = arg_6_1
end

function GameModeAdventure.update(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0._adventure_spawning:update(arg_7_1, arg_7_2)
end

function GameModeAdventure.server_update(arg_8_0, arg_8_1, arg_8_2)
	GameModeAdventure.super.server_update(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:_handle_bots(arg_8_1, arg_8_2)
	arg_8_0._adventure_spawning:server_update(arg_8_1, arg_8_2)
end

function GameModeAdventure.evaluate_end_conditions(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	if script_data.disable_gamemode_end then
		return false
	end

	local var_9_0 = true
	local var_9_1 = GameModeHelper.side_is_dead("heroes", var_9_0)
	local var_9_2 = GameModeHelper.side_is_disabled("heroes") and not GameModeHelper.side_delaying_loss("heroes")
	local var_9_3, var_9_4 = arg_9_4:evaluate_lose_conditions()
	local var_9_5 = not arg_9_0._lose_condition_disabled and arg_9_0._local_player_spawned and (var_9_3 or var_9_1 or var_9_2 or arg_9_0._level_failed or arg_9_0:_is_time_up())

	if arg_9_0:is_about_to_end_game_early() then
		if var_9_5 then
			if arg_9_3 > arg_9_0._lost_condition_timer then
				return true, "lost"
			else
				return false
			end
		else
			arg_9_0:set_about_to_end_game_early(false)

			arg_9_0._lost_condition_timer = nil
		end
	end

	if var_9_5 then
		arg_9_0:set_about_to_end_game_early(true)

		if var_9_3 and var_9_4 then
			arg_9_0._lost_condition_timer = arg_9_3 + var_9_4
		elseif var_9_1 then
			arg_9_0._lost_condition_timer = arg_9_3 + GameModeSettings.adventure.lose_condition_time_dead
		else
			arg_9_0._lost_condition_timer = arg_9_3 + GameModeSettings.adventure.lose_condition_time
		end
	elseif arg_9_0:update_end_level_areas() then
		return true, "won"
	elseif arg_9_0._level_completed then
		if Managers.deed:has_deed() and Managers.deed:is_session_faulty() then
			return true, "lost"
		else
			return true, "won"
		end
	else
		return false
	end
end

function GameModeAdventure.player_entered_game_session(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	GameModeAdventure.super.player_entered_game_session(arg_10_0, arg_10_1, arg_10_2, arg_10_3)

	if LAUNCH_MODE ~= "attract_benchmark" then
		arg_10_0._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_10_1, arg_10_2)
	end

	if Network.peer_id() == arg_10_1 then
		local var_10_0 = 1

		arg_10_0:remove_bot(var_10_0, arg_10_1, arg_10_2)

		if Managers.party:get_player_status(arg_10_1, arg_10_2).party_id ~= var_10_0 then
			Managers.party:request_join_party(arg_10_1, arg_10_2, var_10_0)
		end
	else
		arg_10_0._adventure_spawning:add_delayed_client(arg_10_1, arg_10_2)
	end
end

function GameModeAdventure.player_left_game_session(arg_11_0, arg_11_1, arg_11_2)
	GameModeAdventure.super.player_left_game_session(arg_11_0, arg_11_1, arg_11_2)
	arg_11_0._adventure_spawning:remove_delayed_client(arg_11_1, arg_11_2)
end

function GameModeAdventure.remove_bot(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	if #arg_12_0._bot_players > 0 then
		local var_12_0 = arg_12_0._profile_synchronizer:profile_by_peer(arg_12_2, arg_12_3)
		local var_12_1, var_12_2 = arg_12_0:_remove_bot_by_profile(var_12_0, arg_12_4)

		if not var_12_1 then
			arg_12_4 = arg_12_4 or false
			var_12_2 = arg_12_0._bot_players[#arg_12_0._bot_players]

			arg_12_0:_remove_bot(var_12_2, arg_12_4)
		end

		return var_12_2
	end
end

function GameModeAdventure.get_end_screen_config(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0
	local var_13_1 = {}

	if arg_13_1 then
		var_13_0 = "victory"

		local var_13_2 = arg_13_3:stats_id()
		local var_13_3 = arg_13_0._statistics_db
		local var_13_4 = arg_13_0._level_key
		local var_13_5 = LevelUnlockUtils.completed_level_difficulty_index(var_13_3, var_13_2, var_13_4) or 0

		var_13_1 = {
			show_act_presentation = true,
			level_key = var_13_4,
			previous_completed_difficulty_index = var_13_5
		}
	else
		var_13_0 = "defeat"
	end

	return var_13_0, var_13_1
end

function GameModeAdventure.ended(arg_14_0, arg_14_1)
	if not arg_14_0._network_server:are_all_peers_ingame() then
		arg_14_0._network_server:disconnect_joining_peers()
	end
end

function GameModeAdventure.local_player_ready_to_start(arg_15_0, arg_15_1)
	if not arg_15_0._local_player_spawned then
		return false
	end

	return true
end

function GameModeAdventure.local_player_game_starts(arg_16_0, arg_16_1, arg_16_2)
	if arg_16_0._is_initial_spawn then
		LevelHelper:flow_event(arg_16_0._world, "local_player_spawned")

		if Development.parameter("attract_mode") then
			LevelHelper:flow_event(arg_16_0._world, "start_benchmark")
		else
			LevelHelper:flow_event(arg_16_0._world, "level_start_local_player_spawned")
		end
	end
end

function GameModeAdventure.disable_player_spawning(arg_17_0)
	arg_17_0._adventure_spawning:set_spawning_disabled(true)
end

function GameModeAdventure.enable_player_spawning(arg_18_0, arg_18_1, arg_18_2)
	arg_18_0._adventure_spawning:set_spawning_disabled(false)
	arg_18_0._adventure_spawning:force_update_spawn_positions(arg_18_1, arg_18_2)
end

function GameModeAdventure.teleport_despawned_players(arg_19_0, arg_19_1)
	arg_19_0._adventure_spawning:teleport_despawned_players(arg_19_1)
end

function GameModeAdventure.flow_callback_add_spawn_point(arg_20_0, arg_20_1)
	arg_20_0._adventure_spawning:add_spawn_point(arg_20_1)
end

function GameModeAdventure.set_override_respawn_group(arg_21_0, arg_21_1, arg_21_2)
	arg_21_0._adventure_spawning:set_override_respawn_group(arg_21_1, arg_21_2)
end

function GameModeAdventure.set_respawn_group_enabled(arg_22_0, arg_22_1, arg_22_2)
	arg_22_0._adventure_spawning:set_respawn_group_enabled(arg_22_1, arg_22_2)
end

function GameModeAdventure.set_respawn_gate_enabled(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0._adventure_spawning:set_respawn_gate_enabled(arg_23_1, arg_23_2)
end

function GameModeAdventure.respawn_unit_spawned(arg_24_0, arg_24_1)
	arg_24_0._adventure_spawning:respawn_unit_spawned(arg_24_1)
end

function GameModeAdventure.respawn_gate_unit_spawned(arg_25_0, arg_25_1)
	arg_25_0._adventure_spawning:respawn_gate_unit_spawned(arg_25_1)
end

function GameModeAdventure.get_respawn_handler(arg_26_0)
	return arg_26_0._adventure_spawning:get_respawn_handler()
end

function GameModeAdventure.set_respawning_enabled(arg_27_0, arg_27_1)
	arg_27_0._adventure_spawning:set_respawning_enabled(arg_27_1)
end

function GameModeAdventure.remove_respawn_units_due_to_crossroads(arg_28_0, arg_28_1, arg_28_2)
	arg_28_0._adventure_spawning:remove_respawn_units_due_to_crossroads(arg_28_1, arg_28_2)
end

function GameModeAdventure.recalc_respawner_dist_due_to_crossroads(arg_29_0)
	arg_29_0._adventure_spawning:recalc_respawner_dist_due_to_crossroads()
end

function GameModeAdventure.force_respawn(arg_30_0, arg_30_1, arg_30_2)
	if Managers.party:get_player_status(arg_30_1, arg_30_2).party_id == 0 then
		local var_30_0 = 1

		Managers.party:assign_peer_to_party(arg_30_1, arg_30_2, var_30_0)
	end

	arg_30_0._adventure_spawning:force_respawn(arg_30_1, arg_30_2)
end

function GameModeAdventure.force_respawn_dead_players(arg_31_0)
	arg_31_0._adventure_spawning:force_respawn_dead_players()
end

function GameModeAdventure._get_first_available_bot_profile(arg_32_0)
	local var_32_0 = arg_32_0._available_profiles
	local var_32_1 = arg_32_0._profile_synchronizer
	local var_32_2 = {}

	for iter_32_0 = 1, #var_32_0 do
		local var_32_3 = var_32_0[iter_32_0]
		local var_32_4 = FindProfileIndex(var_32_3)

		if not var_32_1:is_profile_in_use(var_32_4) then
			var_32_2[#var_32_2 + 1] = var_32_4
		end
	end

	local var_32_5 = arg_32_0._bot_profile_id_to_priority_id

	table.sort(var_32_2, function(arg_33_0, arg_33_1)
		return (var_32_5[arg_33_0] or math.huge) < (var_32_5[arg_33_1] or math.huge)
	end)

	local var_32_6 = var_32_2[1]
	local var_32_7 = SPProfiles[var_32_6]
	local var_32_8 = var_32_7.display_name
	local var_32_9 = Managers.backend:get_interface("hero_attributes")
	local var_32_10 = var_32_9:get(var_32_8, "career")
	local var_32_11 = var_32_9:get(var_32_8, "bot_career") or var_32_10 or 1
	local var_32_12 = var_32_7.careers[var_32_11]
	local var_32_13 = var_32_9:get(var_32_8, "experience") or 0
	local var_32_14 = ExperienceSettings.get_level(var_32_13)

	if not var_32_12 and not var_32_12:is_unlocked_function(var_32_8, var_32_14) then
		local var_32_15 = 1

		var_32_11 = 1

		local var_32_16 = var_32_7.careers[var_32_15]

		var_32_9:set(var_32_8, "career", var_32_15)
		var_32_9:set(var_32_8, "bot_career", var_32_11)
	end

	return var_32_6, var_32_11
end

function GameModeAdventure._setup_bot_spawn_priority_lookup(arg_34_0)
	local var_34_0 = PlayerData.bot_spawn_priority
	local var_34_1 = #var_34_0

	if LAUNCH_MODE == "game" then
		if var_34_1 > 0 then
			arg_34_0._bot_profile_id_to_priority_id = {}

			for iter_34_0 = 1, var_34_1 do
				local var_34_2 = var_34_0[iter_34_0]

				arg_34_0._bot_profile_id_to_priority_id[var_34_2] = iter_34_0
			end
		else
			arg_34_0._bot_profile_id_to_priority_id = ProfileIndexToPriorityIndex
		end
	elseif LAUNCH_MODE == "attract_benchmark" then
		arg_34_0._bot_profile_id_to_priority_id = ProfileIndexToPriorityIndex
	else
		arg_34_0._bot_profile_id_to_priority_id = ProfileIndexToPriorityIndex
	end
end

function GameModeAdventure._handle_bots(arg_35_0, arg_35_1, arg_35_2)
	if not (Managers.state.network ~= nil and not Managers.state.network.game_session_shutdown) then
		return
	end

	if script_data.ai_bots_disabled then
		if #arg_35_0._bot_players > 0 then
			local var_35_0 = true

			arg_35_0:_clear_bots(var_35_0)
		end

		return
	end

	local var_35_1 = Managers.party:get_party(1)
	local var_35_2 = var_35_1.num_slots
	local var_35_3 = var_35_2

	if script_data.cap_num_bots then
		var_35_3 = math.min(var_35_3, script_data.cap_num_bots)
	end

	local var_35_4 = arg_35_0._bot_players
	local var_35_5 = var_35_3 - #var_35_4

	if var_35_5 > 0 then
		local var_35_6 = var_35_2 - var_35_1.num_used_slots
		local var_35_7 = math.min(var_35_5, var_35_6)

		for iter_35_0 = 1, var_35_7 do
			arg_35_0:_add_bot()
		end
	elseif var_35_5 < 0 then
		local var_35_8 = math.abs(var_35_5)

		for iter_35_1 = 1, var_35_8 do
			local var_35_9 = true

			arg_35_0:_remove_bot(var_35_4[#var_35_4], var_35_9)
		end
	end
end

function GameModeAdventure._add_bot(arg_36_0)
	local var_36_0 = arg_36_0._bot_players
	local var_36_1 = 1
	local var_36_2 = Managers.party:get_party(var_36_1)
	local var_36_3, var_36_4 = arg_36_0:_get_first_available_bot_profile(var_36_2)

	if LAUNCH_MODE == "attract_benchmark" then
		var_36_4 = 1
	end

	local var_36_5 = arg_36_0:_add_bot_to_party(var_36_1, var_36_3, var_36_4)

	var_36_0[#var_36_0 + 1] = var_36_5
end

function GameModeAdventure._remove_bot(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_0._bot_players
	local var_37_1 = table.index_of(arg_37_0._bot_players, arg_37_1)

	if arg_37_2 then
		arg_37_0:_remove_bot_update_safe(arg_37_1)
	else
		arg_37_0:_remove_bot_instant(arg_37_1)
	end

	local var_37_2 = #var_37_0

	var_37_0[var_37_1] = var_37_0[var_37_2]
	var_37_0[var_37_2] = nil
end

function GameModeAdventure._remove_bot_by_profile(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0._bot_players
	local var_38_1
	local var_38_2 = #var_38_0

	for iter_38_0 = 1, var_38_2 do
		if var_38_0[iter_38_0]:profile_index() == arg_38_1 then
			var_38_1 = iter_38_0

			break
		end
	end

	local var_38_3
	local var_38_4 = false

	if var_38_1 then
		var_38_3 = var_38_0[var_38_1]
		arg_38_2 = arg_38_2 or false

		arg_38_0:_remove_bot(var_38_3, arg_38_2)

		var_38_4 = true
	end

	return var_38_4, var_38_3
end

function GameModeAdventure._clear_bots(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0._bot_players

	for iter_39_0 = #var_39_0, 1, -1 do
		arg_39_0:_remove_bot(var_39_0[iter_39_0], arg_39_1)
	end
end

function GameModeAdventure.get_active_respawn_units(arg_40_0)
	return arg_40_0._adventure_spawning:get_active_respawn_units()
end

function GameModeAdventure.get_available_and_active_respawn_units(arg_41_0)
	return arg_41_0._adventure_spawning:get_available_and_active_respawn_units()
end

function GameModeAdventure.get_player_wounds(arg_42_0, arg_42_1)
	if Managers.state.game_mode:has_activated_mutator("instant_death") then
		return 1
	end

	return Managers.state.difficulty:get_difficulty_settings().wounds
end
