-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_weave.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/game_mode/spawning_components/weave_spawning")

script_data.disable_gamemode_end = script_data.disable_gamemode_end or Development.parameter("disable_gamemode_end")
GameModeWeave = class(GameModeWeave, GameModeBase)

local var_0_0 = false
local var_0_1 = false

function GameModeWeave.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	GameModeWeave.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	arg_1_0._lost_condition_timer = nil
	arg_1_0.about_to_win = false
	arg_1_0.win_condition_timer = nil
	arg_1_0._adventure_profile_rules = AdventureProfileRules:new(arg_1_0._profile_synchronizer, arg_1_0._network_server)

	local var_1_0 = Managers.state.side:get_side_from_name("heroes")

	arg_1_0._weave_spawning = WeaveSpawning:new(arg_1_0._profile_synchronizer, var_1_0, arg_1_0._is_server, arg_1_0._network_server, arg_1_8 and arg_1_8.game_mode_data)

	arg_1_0:_register_player_spawner(arg_1_0._weave_spawning)

	arg_1_0._available_profiles = table.clone(PROFILES_BY_AFFILIATION.heroes)
	arg_1_0._bot_players = {}

	arg_1_0:_setup_bot_spawn_priority_lookup()

	arg_1_0._local_player_spawned = false
	arg_1_0._has_locked_party_size = Managers.matchmaking:is_game_private()

	local var_1_1 = Managers.state.event

	var_1_1:register(arg_1_0, "level_start_local_player_spawned", "event_local_player_spawned")
	var_1_1:register(arg_1_0, "on_ai_unit_destroyed", "on_ai_unit_destroyed")
end

function GameModeWeave.register_rpcs(arg_2_0, arg_2_1, arg_2_2)
	GameModeWeave.super.register_rpcs(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._weave_spawning:register_rpcs(arg_2_1, arg_2_2)
end

function GameModeWeave.unregister_rpcs(arg_3_0)
	arg_3_0._weave_spawning:unregister_rpcs()
	GameModeWeave.super.unregister_rpcs(arg_3_0)
end

function GameModeWeave.event_local_player_spawned(arg_4_0, arg_4_1)
	arg_4_0._local_player_spawned = true
	arg_4_0._is_initial_spawn = arg_4_1
end

function GameModeWeave.update(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._weave_spawning:update(arg_5_1, arg_5_2)
end

function GameModeWeave.server_update(arg_6_0, arg_6_1, arg_6_2)
	GameModeWeave.super.server_update(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_handle_bots(arg_6_1, arg_6_2)
	arg_6_0._weave_spawning:server_update(arg_6_1, arg_6_2)
end

function GameModeWeave.evaluate_end_conditions(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if script_data.disable_gamemode_end then
		return false
	end

	local var_7_0 = true
	local var_7_1 = GameModeHelper.side_is_dead("heroes", var_7_0)
	local var_7_2 = GameModeHelper.side_is_disabled("heroes") and not GameModeHelper.side_delaying_loss("heroes")
	local var_7_3 = arg_7_4:evaluate_lose_conditions()
	local var_7_4 = arg_7_0:_is_time_up(arg_7_3)
	local var_7_5 = not arg_7_0._lose_condition_disabled and (var_7_3 or var_7_1 or var_7_2 or arg_7_0._level_failed)

	if arg_7_0._about_to_win then
		if arg_7_3 > arg_7_0.win_condition_timer then
			return true, "won"
		elseif var_7_4 then
			return true, "lost"
		else
			return false
		end
	end

	if arg_7_0:is_about_to_end_game_early() then
		if var_7_5 then
			if arg_7_3 > arg_7_0._lost_condition_timer then
				return true, "lost"
			else
				return false
			end
		else
			arg_7_0:set_about_to_end_game_early(false)

			arg_7_0._lost_condition_timer = nil
		end
	end

	if var_7_5 then
		arg_7_0:set_about_to_end_game_early(true)

		if var_7_1 then
			arg_7_0._lost_condition_timer = arg_7_3 + GameModeSettings.weave.lose_condition_time_dead
		else
			arg_7_0._lost_condition_timer = arg_7_3 + GameModeSettings.weave.lose_condition_time
		end
	elseif arg_7_0._level_completed and not arg_7_0._about_to_win then
		if Managers.weave:calculate_next_objective_index() then
			if var_7_4 then
				return true, "won"
			else
				return true, "won"
			end
		else
			arg_7_0._about_to_win = true
			arg_7_0.win_condition_timer = arg_7_3 + 6
		end
	else
		return false
	end
end

function GameModeWeave.get_saved_game_mode_data(arg_8_0)
	local var_8_0 = arg_8_0._weave_spawning:get_saved_game_mode_data()

	return table.clone(var_8_0)
end

function GameModeWeave.mutators(arg_9_0)
	return (Managers.weave:mutators())
end

function GameModeWeave.ai_killed(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	Managers.weave:ai_killed(arg_10_1, arg_10_2, arg_10_3, arg_10_4)
end

function GameModeWeave.on_ai_unit_destroyed(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if arg_11_3 == "far_away" and arg_11_2 then
		local var_11_0 = Unit.get_data(arg_11_1, "spawn_type") or "unknown"
		local var_11_1 = Managers.state.conflict.enemy_recycler
		local var_11_2 = arg_11_2.breed
		local var_11_3 = {
			despawned = true,
			breed = var_11_2
		}
		local var_11_4 = Vector3Box(POSITION_LOOKUP[arg_11_1])
		local var_11_5 = QuaternionBox(Unit.local_rotation(arg_11_1, 0))
		local var_11_6 = {
			spawn_type = var_11_0
		}

		var_11_1:add_breed(var_11_2.name, var_11_4, var_11_5, var_11_6)
		Managers.state.entity:system("objective_system"):on_ai_killed(arg_11_1, nil, var_11_3)
	end
end

function GameModeWeave._is_time_up(arg_12_0)
	if LEVEL_EDITOR_TEST then
		return false
	end

	local var_12_0 = Managers.weave:get_time_left()

	if var_12_0 then
		return var_12_0 <= 0
	end

	return Managers.state.network:network_time() / NetworkConstants.clock_time.max > 0.9
end

function GameModeWeave.player_entered_game_session(arg_13_0, arg_13_1, arg_13_2)
	GameModeWeave.super.player_entered_game_session(arg_13_0, arg_13_1, arg_13_2)

	if LAUNCH_MODE ~= "attract_benchmark" then
		arg_13_0._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_13_1, arg_13_2)
	end

	if Managers.party:get_player_status(arg_13_1, arg_13_2).party_id ~= 1 then
		local var_13_0 = 1

		if #arg_13_0._bot_players > 0 then
			local var_13_1 = arg_13_0._profile_synchronizer:profile_by_peer(arg_13_1, arg_13_2)

			if not arg_13_0:_remove_bot_by_profile(var_13_1) then
				local var_13_2 = false

				arg_13_0:_remove_bot(arg_13_0._bot_players[#arg_13_0._bot_players], var_13_2)
			end
		end

		Managers.party:request_join_party(arg_13_1, arg_13_2, var_13_0)
	end
end

function GameModeWeave.players_left_safe_zone(arg_14_0)
	Managers.weave:weave_spawner():players_left_safe_zone()
end

function GameModeWeave.disable_player_spawning(arg_15_0)
	arg_15_0._weave_spawning:set_spawning_disabled(true)
end

function GameModeWeave.enable_player_spawning(arg_16_0, arg_16_1, arg_16_2)
	arg_16_0._weave_spawning:set_spawning_disabled(false)
	arg_16_0._weave_spawning:force_update_spawn_positions(arg_16_1, arg_16_2)
end

function GameModeWeave.teleport_despawned_players(arg_17_0, arg_17_1)
	arg_17_0._weave_spawning:teleport_despawned_players(arg_17_1)
end

function GameModeWeave.flow_callback_add_spawn_point(arg_18_0, arg_18_1)
	arg_18_0._weave_spawning:add_spawn_point(arg_18_1)
end

function GameModeWeave.set_override_respawn_group(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0._weave_spawning:set_override_respawn_group(arg_19_1, arg_19_2)
end

function GameModeWeave.set_respawn_group_enabled(arg_20_0, arg_20_1, arg_20_2)
	arg_20_0._weave_spawning:set_respawn_group_enabled(arg_20_1, arg_20_2)
end

function GameModeWeave.set_respawn_gate_enabled(arg_21_0, arg_21_1, arg_21_2)
	arg_21_0._weave_spawning:set_respawn_gate_enabled(arg_21_1, arg_21_2)
end

function GameModeWeave.respawn_unit_spawned(arg_22_0, arg_22_1)
	arg_22_0._weave_spawning:respawn_unit_spawned(arg_22_1)
end

function GameModeWeave.get_respawn_handler(arg_23_0)
	return arg_23_0._weave_spawning:get_respawn_handler()
end

function GameModeWeave.respawn_gate_unit_spawned(arg_24_0, arg_24_1)
	arg_24_0._weave_spawning:respawn_gate_unit_spawned(arg_24_1)
end

function GameModeWeave.set_respawning_enabled(arg_25_0, arg_25_1)
	arg_25_0._weave_spawning:set_respawning_enabled(arg_25_1)
end

function GameModeWeave.remove_respawn_units_due_to_crossroads(arg_26_0, arg_26_1, arg_26_2)
	arg_26_0._weave_spawning:remove_respawn_units_due_to_crossroads(arg_26_1, arg_26_2)
end

function GameModeWeave.recalc_respawner_dist_due_to_crossroads(arg_27_0)
	arg_27_0._weave_spawning:recalc_respawner_dist_due_to_crossroads()
end

function GameModeWeave.force_respawn(arg_28_0, arg_28_1, arg_28_2)
	if Managers.party:get_player_status(arg_28_1, arg_28_2).party_id == 0 then
		local var_28_0 = 1

		Managers.party:assign_peer_to_party(arg_28_1, arg_28_2, var_28_0)
	end

	arg_28_0._weave_spawning:force_respawn(arg_28_1, arg_28_2)
end

function GameModeWeave.force_respawn_dead_players(arg_29_0)
	arg_29_0._weave_spawning:force_respawn_dead_players()
end

function GameModeWeave.get_active_respawn_units(arg_30_0)
	return arg_30_0._weave_spawning:get_active_respawn_units()
end

function GameModeWeave.get_available_and_active_respawn_units(arg_31_0)
	return arg_31_0._weave_spawning:get_available_and_active_respawn_units()
end

function GameModeWeave.get_player_wounds(arg_32_0, arg_32_1)
	if Managers.state.game_mode:has_activated_mutator("instant_death") then
		return 1
	end

	return Managers.state.difficulty:get_difficulty_settings().wounds
end

function GameModeWeave.get_boss_loot_pickup(arg_33_0)
	return nil
end

function GameModeWeave.ended(arg_34_0, arg_34_1)
	if not arg_34_0._network_server:are_all_peers_ingame() then
		arg_34_0._network_server:disconnect_joining_peers()
	end

	local var_34_0 = Managers.weave
	local var_34_1 = var_34_0:calculate_next_objective_index()
	local var_34_2 = var_34_0:get_active_weave_phase()

	var_34_0:set_active_weave_phase(var_34_2 + 1)

	if arg_34_1 == "won" and not var_34_1 then
		var_34_0:sync_end_of_weave_data()
	end
end

function GameModeWeave.get_end_screen_config(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = "none"
	local var_35_1 = {}

	if arg_35_1 then
		if not Managers.weave:calculate_next_objective_index() then
			var_35_0 = "victory"
			var_35_1 = {
				show_act_presentation = false
			}
		end
	elseif not Managers.weave:calculate_next_objective_index() then
		var_35_0 = "defeat"
	end

	return var_35_0, var_35_1
end

function GameModeWeave.local_player_ready_to_start(arg_36_0, arg_36_1)
	if not arg_36_0._local_player_spawned then
		return false
	end

	return true
end

function GameModeWeave.local_player_game_starts(arg_37_0, arg_37_1, arg_37_2)
	if arg_37_0._is_initial_spawn then
		LevelHelper:flow_event(arg_37_0._world, "local_player_spawned")

		if Development.parameter("attract_mode") then
			LevelHelper:flow_event(arg_37_0._world, "start_benchmark")
		else
			LevelHelper:flow_event(arg_37_0._world, "level_start_local_player_spawned")
		end
	end

	local var_37_0 = Managers.weave

	if arg_37_0._is_server then
		var_37_0:store_player_ids()
		var_37_0:start_objective()
		var_37_0:reset_statistics_for_challenges()
		var_37_0:start_timer()
	end
end

function GameModeWeave._get_first_available_bot_profile(arg_38_0)
	local var_38_0 = arg_38_0._available_profiles
	local var_38_1 = arg_38_0._profile_synchronizer
	local var_38_2 = {}

	for iter_38_0 = 1, #var_38_0 do
		local var_38_3 = var_38_0[iter_38_0]
		local var_38_4 = FindProfileIndex(var_38_3)

		if not var_38_1:is_profile_in_use(var_38_4) then
			var_38_2[#var_38_2 + 1] = var_38_4
		end
	end

	local var_38_5 = arg_38_0._bot_profile_id_to_priority_id

	table.sort(var_38_2, function(arg_39_0, arg_39_1)
		return (var_38_5[arg_39_0] or math.huge) < (var_38_5[arg_39_1] or math.huge)
	end)

	local var_38_6 = var_38_2[1]

	if script_data.wanted_bot_profile then
		local var_38_7 = FindProfileIndex(script_data.wanted_bot_profile)

		if script_data.allow_same_bots or not var_38_1:is_profile_in_use(var_38_7) then
			var_38_6 = var_38_7
		end
	end

	local var_38_8 = SPProfiles[var_38_6].display_name
	local var_38_9 = Managers.backend:get_interface("hero_attributes")
	local var_38_10 = var_38_9:get(var_38_8, "career")
	local var_38_11 = var_38_9:get(var_38_8, "bot_career") or var_38_10 or 1

	if script_data.wanted_bot_career_index then
		var_38_11 = script_data.wanted_bot_career_index
	end

	return var_38_6, var_38_11
end

function GameModeWeave._setup_bot_spawn_priority_lookup(arg_40_0)
	local var_40_0 = PlayerData.bot_spawn_priority
	local var_40_1 = #var_40_0

	if LAUNCH_MODE == "game" then
		if var_40_1 > 0 then
			arg_40_0._bot_profile_id_to_priority_id = {}

			for iter_40_0 = 1, var_40_1 do
				local var_40_2 = var_40_0[iter_40_0]

				arg_40_0._bot_profile_id_to_priority_id[var_40_2] = iter_40_0
			end
		else
			arg_40_0._bot_profile_id_to_priority_id = ProfileIndexToPriorityIndex
		end
	elseif LAUNCH_MODE == "attract_benchmark" then
		arg_40_0._bot_profile_id_to_priority_id = ProfileIndexToPriorityIndex
	else
		arg_40_0._bot_profile_id_to_priority_id = ProfileIndexToPriorityIndex
	end
end

function GameModeWeave._handle_bots(arg_41_0, arg_41_1, arg_41_2)
	if not (Managers.state.network ~= nil and not Managers.state.network.game_session_shutdown) then
		return
	end

	local var_41_0 = Development.parameter("enable_bots_in_weaves") or not arg_41_0._has_locked_party_size

	if script_data.ai_bots_disabled or not var_41_0 then
		if #arg_41_0._bot_players > 0 then
			local var_41_1 = true

			arg_41_0:_clear_bots(var_41_1)
		end

		return
	end

	local var_41_2 = Managers.party:get_party(1)
	local var_41_3 = var_41_2.num_slots
	local var_41_4 = var_41_3

	if script_data.cap_num_bots then
		var_41_4 = math.min(var_41_4, script_data.cap_num_bots)
	end

	local var_41_5 = arg_41_0._bot_players
	local var_41_6 = var_41_4 - #var_41_5

	if var_41_6 > 0 then
		local var_41_7 = var_41_3 - var_41_2.num_used_slots
		local var_41_8 = math.min(var_41_6, var_41_7)

		for iter_41_0 = 1, var_41_8 do
			arg_41_0:_add_bot()
		end
	elseif var_41_6 < 0 then
		local var_41_9 = math.abs(var_41_6)

		for iter_41_1 = 1, var_41_9 do
			local var_41_10 = true

			arg_41_0:_remove_bot(var_41_5[#var_41_5], var_41_10)
		end
	end
end

function GameModeWeave._add_bot(arg_42_0)
	local var_42_0 = arg_42_0._bot_players
	local var_42_1 = 1
	local var_42_2 = Managers.party:get_party(var_42_1)
	local var_42_3, var_42_4 = arg_42_0:_get_first_available_bot_profile(var_42_2)

	if LAUNCH_MODE == "attract_benchmark" then
		var_42_4 = 1
	end

	local var_42_5 = arg_42_0:_add_bot_to_party(var_42_1, var_42_3, var_42_4)

	var_42_0[#var_42_0 + 1] = var_42_5
end

function GameModeWeave._remove_bot(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_0._bot_players
	local var_43_1 = table.index_of(var_43_0, arg_43_1)

	if arg_43_2 then
		arg_43_0:_remove_bot_update_safe(arg_43_1)
	else
		arg_43_0:_remove_bot_instant(arg_43_1)
	end

	local var_43_2 = #var_43_0

	var_43_0[var_43_1] = var_43_0[var_43_2]
	var_43_0[var_43_2] = nil
end

function GameModeWeave._remove_bot_by_profile(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0._bot_players
	local var_44_1
	local var_44_2 = #var_44_0

	for iter_44_0 = 1, var_44_2 do
		if var_44_0[iter_44_0]:profile_index() == arg_44_1 then
			var_44_1 = iter_44_0

			break
		end
	end

	local var_44_3 = false

	if var_44_1 then
		local var_44_4 = false

		arg_44_0:_remove_bot(var_44_0[var_44_1], var_44_4)

		var_44_3 = true
	end

	return var_44_3
end

function GameModeWeave._clear_bots(arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0._bot_players

	for iter_45_0 = #var_45_0, 1, -1 do
		arg_45_0:_remove_bot(var_45_0[iter_45_0], arg_45_1)
	end
end

function GameModeWeave.cleanup_game_mode_units(arg_46_0)
	local var_46_0 = false

	arg_46_0:_clear_bots(var_46_0)
end
