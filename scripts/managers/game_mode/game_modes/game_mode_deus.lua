-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_deus.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/game_mode/spawning_components/deus_spawning")
require("scripts/settings/dlcs/morris/deus_soft_currency_settings")
require("scripts/utils/hash_utils")

local var_0_0 = 1
local var_0_1 = "ferry_lady"
local var_0_2 = "volume_intro_vo"

local function var_0_3(arg_1_0, arg_1_1)
	local var_1_0 = ScriptUnit.extension_input(arg_1_0, "dialogue_system")
	local var_1_1 = FrameTable.alloc_table()

	if arg_1_1 then
		var_1_0:trigger_dialogue_event("curse_intro", var_1_1)
	else
		var_1_0:trigger_dialogue_event("no_curse_intro", var_1_1)
	end
end

GameModeDeus = class(GameModeDeus, GameModeBase)

GameModeDeus.init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	GameModeDeus.super.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	fassert(arg_2_8, "game mode settings can not be nil")
	fassert(arg_2_8.deus_run_controller, "game mode settings must provide a deus run controller")

	arg_2_0._lost_condition_timer = nil
	arg_2_0._adventure_profile_rules = AdventureProfileRules:new(arg_2_0._profile_synchronizer, arg_2_0._network_server)

	local var_2_0 = Managers.state.side:get_side_from_name("heroes")

	arg_2_0._mutators = arg_2_8.mutators
	arg_2_0._deus_run_controller = arg_2_8.deus_run_controller
	arg_2_0._deus_spawning = DeusSpawning:new(arg_2_0._profile_synchronizer, var_2_0, arg_2_0._is_server, arg_2_0._network_server, arg_2_0._deus_run_controller)

	arg_2_0:_register_player_spawner(arg_2_0._deus_spawning)

	arg_2_0._bot_players = {}

	arg_2_0:_setup_bot_spawn_priority_lookup()

	arg_2_0._available_profiles = table.clone(PROFILES_BY_AFFILIATION.heroes)

	local var_2_1 = Managers.state.event

	var_2_1:register(arg_2_0, "level_start_local_player_spawned", "event_local_player_spawned")
	var_2_1:register(arg_2_0, "statistics_database_unregister_player", "event_statistics_database_unregister_player")

	arg_2_0._local_player_spawned = false
end

GameModeDeus.on_round_end = function (arg_3_0)
	local var_3_0 = Managers.state.entity:system("volume_system")
	local var_3_1 = LevelHelper:current_level(arg_3_0._world)
	local var_3_2 = Level.has_volume(var_3_1, var_0_2)

	if var_3_0 and var_3_2 then
		var_3_0:unregister_volume(var_0_2)
	end
end

GameModeDeus.destroy = function (arg_4_0)
	local var_4_0 = Managers.state.event

	if var_4_0 then
		var_4_0:unregister("level_start_local_player_spawned", arg_4_0)
		var_4_0:unregister("statistics_database_unregister_player", arg_4_0)
	end
end

GameModeDeus.cleanup_game_mode_units = function (arg_5_0)
	local var_5_0 = false

	arg_5_0:_clear_bots(var_5_0)
end

GameModeDeus.register_rpcs = function (arg_6_0, arg_6_1, arg_6_2)
	GameModeDeus.super.register_rpcs(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._deus_spawning:register_rpcs(arg_6_1, arg_6_2)
end

GameModeDeus.unregister_rpcs = function (arg_7_0)
	arg_7_0._deus_spawning:unregister_rpcs()
	GameModeDeus.super.unregister_rpcs(arg_7_0)
end

GameModeDeus.event_local_player_spawned = function (arg_8_0, arg_8_1)
	arg_8_0._local_player_spawned = true
	arg_8_0._is_initial_spawn = arg_8_1
end

GameModeDeus.update = function (arg_9_0, arg_9_1, arg_9_2)
	arg_9_0._deus_spawning:update(arg_9_1, arg_9_2)
end

GameModeDeus.server_update = function (arg_10_0, arg_10_1, arg_10_2)
	GameModeDeus.super.server_update(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0:_handle_bots(arg_10_1, arg_10_2)
	arg_10_0._deus_spawning:server_update(arg_10_1, arg_10_2)
	arg_10_0:_update_morris_music_intensity()
end

GameModeDeus.evaluate_end_conditions = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	if script_data.disable_gamemode_end then
		return false
	end

	if arg_11_0._won then
		return true, "won"
	end

	local var_11_0 = Managers.state.side:get_party_from_side_name("heroes")
	local var_11_1 = false
	local var_11_2 = var_11_0.occupied_slots

	for iter_11_0 = 1, #var_11_2 do
		var_11_1 = var_11_1 or not var_11_2[iter_11_0].is_bot
	end

	if not var_11_1 then
		return false
	end

	local var_11_3 = true
	local var_11_4 = GameModeHelper.side_is_dead("heroes", var_11_3)
	local var_11_5 = GameModeHelper.side_is_disabled("heroes") and not GameModeHelper.side_delaying_loss("heroes")
	local var_11_6, var_11_7 = arg_11_4:evaluate_lose_conditions()
	local var_11_8 = not arg_11_0._lose_condition_disabled and (var_11_6 or var_11_4 or var_11_5 or arg_11_0._level_failed or arg_11_0:_is_time_up())

	if arg_11_0:is_about_to_end_game_early() then
		if var_11_8 then
			if arg_11_3 > arg_11_0._lost_condition_timer then
				return true, "lost"
			else
				return false
			end
		else
			arg_11_0:set_about_to_end_game_early(false)

			arg_11_0._lost_condition_timer = nil
		end
	end

	local var_11_9 = false

	if var_11_8 then
		arg_11_0:set_about_to_end_game_early(true)

		if var_11_6 and var_11_7 then
			arg_11_0._lost_condition_timer = arg_11_3 + var_11_7
		elseif var_11_4 then
			arg_11_0._lost_condition_timer = arg_11_3 + GameModeSettings.adventure.lose_condition_time_dead
		else
			arg_11_0._lost_condition_timer = arg_11_3 + GameModeSettings.adventure.lose_condition_time
		end

		return false
	elseif arg_11_0:update_end_level_areas() then
		var_11_9 = true
	elseif arg_11_0._level_completed then
		if Managers.deed:has_deed() and Managers.deed:is_session_faulty() then
			return true, "lost"
		else
			var_11_9 = true
		end
	end

	if var_11_9 then
		return true, "won"
	end

	return false
end

GameModeDeus.gm_event_end_conditions_met = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_0._deus_run_controller
	local var_12_1 = Managers.player

	for iter_12_0, iter_12_1 in pairs(var_12_1:players()) do
		local var_12_2 = arg_12_0._statistics_db
		local var_12_3 = iter_12_1:network_id()
		local var_12_4 = iter_12_1:local_player_id()

		var_12_0:save_persisted_score(var_12_2, PlayerUtils.unique_player_id(var_12_3, var_12_4))
	end

	local var_12_5 = ScoreboardHelper.get_grouped_topic_statistics(arg_12_0._statistics_db, arg_12_0._profile_synchronizer, {})

	var_12_0:save_scoreboard(var_12_5)

	if var_12_0:get_current_node().level_type ~= "ARENA" then
		local var_12_6 = Managers.world:wwise_world(arg_12_0._world)

		WwiseWorld.trigger_event(var_12_6, "Play_morris_run_level_complete")
	end
end

GameModeDeus.player_entered_game_session = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	GameModeDeus.super.player_entered_game_session(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	arg_13_0._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_13_1, arg_13_2)
	arg_13_0._deus_spawning:add_delayed_client(arg_13_1, arg_13_2)
	arg_13_0._deus_run_controller:restore_persisted_score(arg_13_0._statistics_db, arg_13_1, arg_13_2)
end

GameModeDeus.player_left_game_session = function (arg_14_0, arg_14_1, arg_14_2)
	GameModeDeus.super.player_left_game_session(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0._deus_spawning:remove_delayed_client(arg_14_1, arg_14_2)
end

GameModeDeus.event_statistics_database_unregister_player = function (arg_15_0, arg_15_1)
	if arg_15_0._is_server then
		arg_15_0._deus_run_controller:save_persisted_score(arg_15_0._statistics_db, arg_15_1)
	end
end

GameModeDeus.remove_bot = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	arg_16_4 = arg_16_4 or false

	if #arg_16_0._bot_players > 0 then
		local var_16_0 = arg_16_0._profile_synchronizer:profile_by_peer(arg_16_2, arg_16_3)
		local var_16_1, var_16_2 = arg_16_0:_remove_bot_by_profile(var_16_0, arg_16_4)

		if not var_16_1 then
			var_16_2 = arg_16_0._bot_players[#arg_16_0._bot_players]

			arg_16_0:_remove_bot(var_16_2, arg_16_4)
		end

		return var_16_2
	end
end

GameModeDeus.get_end_screen_config = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	if Managers.mechanism:is_final_round() or arg_17_2 then
		local var_17_0 = arg_17_0._statistics_db
		local var_17_1 = arg_17_0._deus_run_controller:get_journey_name()
		local var_17_2 = arg_17_0._deus_run_controller:get_own_peer_id()
		local var_17_3, var_17_4 = arg_17_0._deus_run_controller:get_player_profile(var_17_2, var_0_0)
		local var_17_5 = Managers.player:local_player():stats_id()
		local var_17_6 = LevelUnlockUtils.completed_journey_difficulty_index(var_17_0, var_17_5, var_17_1)

		return arg_17_1 and "deus_victory" or "defeat", {
			journey_name = var_17_1,
			profile_index = var_17_3,
			previous_completed_difficulty_index = var_17_6
		}
	else
		local var_17_7 = {}
		local var_17_8 = arg_17_0._deus_run_controller:try_grant_end_of_level_deus_power_ups()

		if var_17_8 then
			for iter_17_0 = 1, #var_17_8 do
				local var_17_9 = var_17_8[iter_17_0]
				local var_17_10 = {
					type = "deus_power_up_end_of_level",
					sounds = {
						"hud_morris_weapon_chest_unlock",
						"morris_reliquarys_get_boon"
					},
					power_up = var_17_9
				}

				var_17_7[#var_17_7 + 1] = var_17_10
			end
		end

		return "none", {}, {
			rewards = var_17_7
		}
	end
end

GameModeDeus.ended = function (arg_18_0, arg_18_1)
	if not arg_18_0._network_server:are_all_peers_ingame() then
		arg_18_0._network_server:disconnect_joining_peers()
	end
end

GameModeDeus.local_player_ready_to_start = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1.peer_id
	local var_19_1 = arg_19_1:local_player_id()
	local var_19_2, var_19_3 = arg_19_0._deus_run_controller:get_player_profile(var_19_0, var_0_0)

	if var_19_2 == 0 or var_19_3 == 0 then
		return false
	end

	local var_19_4 = arg_19_0._deus_run_controller:get_player_health_state(var_19_0, var_19_1)

	if arg_19_0._local_player_spawned or var_19_4 == "dead" or var_19_4 == "respawn" then
		return true
	end

	return false
end

GameModeDeus.local_player_game_starts = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0._deus_run_controller
	local var_20_1 = arg_20_0._world
	local var_20_2 = LevelHelper:current_level(var_20_1)
	local var_20_3 = var_20_0:get_current_node()
	local var_20_4 = var_20_3.theme

	if arg_20_0._is_initial_spawn then
		LevelHelper:flow_event(var_20_1, "local_player_spawned")
		LevelHelper:flow_event(var_20_1, "level_start_local_player_spawned")
	end

	local var_20_5 = Level.has_volume(var_20_2, var_0_2)

	if arg_20_0._is_server and var_20_5 and var_20_4 == DEUS_THEME_TYPES.BELAKOR then
		Managers.state.entity:system("volume_system"):register_volume(var_0_2, "trigger_volume", {
			sub_type = "players_inside",
			on_triggered = function ()
				if arg_20_0._enter_vo_has_triggered then
					return
				end

				local var_21_0 = LevelHelper:find_dialogue_unit(arg_20_0._world, var_0_1)

				if var_21_0 and ScriptUnit.has_extension(var_21_0, "dialogue_system") then
					arg_20_0._enter_vo_has_triggered = true

					var_0_3(var_21_0, var_20_3.curse)
				else
					print("GameModeDeus:local_player_game_starts - No unit for curse intro vo")
				end
			end
		})
	end

	if not arg_20_1.player_unit then
		Managers.state.entity:system("camera_system"):external_state_change(arg_20_1, "observer", {})
	end

	if var_20_3.level_type == "ARENA" then
		Managers.state.entity:system("dialogue_system"):freeze_story_trigger()
	end

	local var_20_6 = DeusThemeSettings[var_20_4].light_probe_tint
	local var_20_7 = Vector3(var_20_6[1], var_20_6[2], var_20_6[3])
	local var_20_8 = Level.units(var_20_2)
	local var_20_9 = #var_20_8

	for iter_20_0 = 1, var_20_9 do
		local var_20_10 = var_20_8[iter_20_0]

		if Unit.is_a(var_20_10, "core/stingray_renderer/helper_units/reflection_probe/reflection_probe") then
			local var_20_11 = Unit.num_lights(var_20_10)

			if var_20_11 then
				for iter_20_1 = 1, var_20_11 do
					local var_20_12 = Unit.light(var_20_10, iter_20_1 - 1)

					Light.set_color(var_20_12, var_20_7)
				end
			end
		end
	end

	Managers.state.event:trigger("local_player_game_starts")
end

GameModeDeus.disable_player_spawning = function (arg_22_0)
	arg_22_0._deus_spawning:set_spawning_disabled(true)
end

GameModeDeus.enable_player_spawning = function (arg_23_0, arg_23_1, arg_23_2)
	arg_23_0._deus_spawning:set_spawning_disabled(false)
	arg_23_0._deus_spawning:force_update_spawn_positions(arg_23_1, arg_23_2)
end

GameModeDeus.teleport_despawned_players = function (arg_24_0, arg_24_1)
	arg_24_0._deus_spawning:teleport_despawned_players(arg_24_1)
end

GameModeDeus.flow_callback_add_spawn_point = function (arg_25_0, arg_25_1)
	arg_25_0._deus_spawning:add_spawn_point(arg_25_1)
end

GameModeDeus.set_override_respawn_group = function (arg_26_0, arg_26_1, arg_26_2)
	arg_26_0._deus_spawning:set_override_respawn_group(arg_26_1, arg_26_2)
end

GameModeDeus.set_respawn_group_enabled = function (arg_27_0, arg_27_1, arg_27_2)
	arg_27_0._deus_spawning:set_respawn_group_enabled(arg_27_1, arg_27_2)
end

GameModeDeus.set_respawn_gate_enabled = function (arg_28_0, arg_28_1, arg_28_2)
	arg_28_0._deus_spawning:set_respawn_gate_enabled(arg_28_1, arg_28_2)
end

GameModeDeus.respawn_unit_spawned = function (arg_29_0, arg_29_1)
	arg_29_0._deus_spawning:respawn_unit_spawned(arg_29_1)
end

GameModeDeus.get_respawn_handler = function (arg_30_0)
	return arg_30_0._deus_spawning:get_respawn_handler()
end

GameModeDeus.respawn_gate_unit_spawned = function (arg_31_0, arg_31_1)
	arg_31_0._deus_spawning:respawn_gate_unit_spawned(arg_31_1)
end

GameModeDeus.set_respawning_enabled = function (arg_32_0, arg_32_1)
	arg_32_0._deus_spawning:set_respawning_enabled(arg_32_1)
end

GameModeDeus.remove_respawn_units_due_to_crossroads = function (arg_33_0, arg_33_1, arg_33_2)
	arg_33_0._deus_spawning:remove_respawn_units_due_to_crossroads(arg_33_1, arg_33_2)
end

GameModeDeus.recalc_respawner_dist_due_to_crossroads = function (arg_34_0)
	arg_34_0._deus_spawning:recalc_respawner_dist_due_to_crossroads()
end

GameModeDeus.profile_changed = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	arg_35_0._deus_spawning:profile_changed(arg_35_1, arg_35_2, arg_35_3, arg_35_4)
end

GameModeDeus.force_respawn = function (arg_36_0, arg_36_1, arg_36_2)
	if Managers.party:get_player_status(arg_36_1, arg_36_2).party_id == 0 then
		local var_36_0 = 1

		Managers.party:assign_peer_to_party(arg_36_1, arg_36_2, var_36_0)
	end

	arg_36_0._deus_spawning:force_respawn(arg_36_1, arg_36_2)
end

GameModeDeus.force_respawn_dead_players = function (arg_37_0)
	arg_37_0._deus_spawning:force_respawn_dead_players()
end

GameModeDeus._get_first_available_bot_profile = function (arg_38_0)
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

	table.sort(var_38_2, function (arg_39_0, arg_39_1)
		return (var_38_5[arg_39_0] or math.huge) < (var_38_5[arg_39_1] or math.huge)
	end)

	local var_38_6 = var_38_2[1]
	local var_38_7 = SPProfiles[var_38_6]
	local var_38_8 = var_38_7.display_name
	local var_38_9 = Managers.backend:get_interface("hero_attributes")
	local var_38_10 = var_38_9:get(var_38_8, "career")
	local var_38_11 = var_38_9:get(var_38_8, "bot_career") or var_38_10 or 1
	local var_38_12 = var_38_7.careers[var_38_11]
	local var_38_13 = var_38_9:get(var_38_8, "experience") or 0
	local var_38_14 = ExperienceSettings.get_level(var_38_13)

	if not var_38_12 or not var_38_12:is_unlocked_function(var_38_8, var_38_14) then
		local var_38_15 = 1

		var_38_11 = 1

		var_38_9:set(var_38_8, "career", var_38_15)
		var_38_9:set(var_38_8, "bot_career", var_38_11)
	end

	return var_38_6, var_38_11
end

GameModeDeus._setup_bot_spawn_priority_lookup = function (arg_40_0)
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

GameModeDeus._handle_bots = function (arg_41_0, arg_41_1, arg_41_2)
	if not (Managers.state.network ~= nil and not Managers.state.network.game_session_shutdown) then
		return
	end

	if script_data.ai_bots_disabled then
		if #arg_41_0._bot_players > 0 then
			local var_41_0 = true

			arg_41_0:_clear_bots(var_41_0)
		end

		return
	end

	local var_41_1 = Managers.party:get_party(1)
	local var_41_2 = var_41_1.num_slots
	local var_41_3 = var_41_2

	if script_data.cap_num_bots then
		var_41_3 = math.min(var_41_3, script_data.cap_num_bots)
	end

	local var_41_4 = arg_41_0._bot_players
	local var_41_5 = var_41_3 - #var_41_4

	if var_41_5 > 0 then
		local var_41_6 = var_41_2 - var_41_1.num_used_slots
		local var_41_7 = math.min(var_41_5, var_41_6)

		for iter_41_0 = 1, var_41_7 do
			arg_41_0:_add_bot()
		end
	elseif var_41_5 < 0 then
		local var_41_8 = math.abs(var_41_5)

		for iter_41_1 = 1, var_41_8 do
			local var_41_9 = true

			arg_41_0:_remove_bot(var_41_4[#var_41_4], var_41_9)
		end
	end
end

GameModeDeus._add_bot = function (arg_42_0)
	local var_42_0 = arg_42_0._bot_players
	local var_42_1 = 1
	local var_42_2 = Managers.party:get_party(var_42_1)
	local var_42_3, var_42_4 = arg_42_0:_get_first_available_bot_profile(var_42_2)

	if LAUNCH_MODE == "attract_benchmark" then
		var_42_4 = 1
	end

	local var_42_5 = arg_42_0:_add_bot_to_party(var_42_1, var_42_3, var_42_4)

	var_42_0[#var_42_0 + 1] = var_42_5

	local var_42_6 = var_42_5:network_id()
	local var_42_7 = var_42_5:local_player_id()

	arg_42_0._deus_run_controller:restore_persisted_score(arg_42_0._statistics_db, var_42_6, var_42_7)
end

GameModeDeus._remove_bot = function (arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_1:network_id()
	local var_43_1 = arg_43_1:local_player_id()

	arg_43_0._deus_run_controller:save_persisted_score(arg_43_0._statistics_db, PlayerUtils.unique_player_id(var_43_0, var_43_1))

	local var_43_2 = arg_43_0._bot_players
	local var_43_3 = table.index_of(var_43_2, arg_43_1)

	if arg_43_2 then
		arg_43_0:_remove_bot_update_safe(arg_43_1)
	else
		arg_43_0:_remove_bot_instant(arg_43_1)
	end

	local var_43_4 = #var_43_2

	var_43_2[var_43_3] = var_43_2[var_43_4]
	var_43_2[var_43_4] = nil
end

GameModeDeus._remove_bot_by_profile = function (arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_0._bot_players
	local var_44_1
	local var_44_2 = #var_44_0

	for iter_44_0 = 1, var_44_2 do
		if var_44_0[iter_44_0]:profile_index() == arg_44_1 then
			var_44_1 = iter_44_0

			break
		end
	end

	local var_44_3
	local var_44_4 = false

	if var_44_1 then
		var_44_3 = var_44_0[var_44_1]

		arg_44_0:_remove_bot(var_44_3, arg_44_2 or false)

		var_44_4 = true
	end

	return var_44_4, var_44_3
end

GameModeDeus._clear_bots = function (arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0._bot_players

	for iter_45_0 = #var_45_0, 1, -1 do
		arg_45_0:_remove_bot(var_45_0[iter_45_0], arg_45_1)
	end
end

GameModeDeus.get_active_respawn_units = function (arg_46_0)
	return arg_46_0._deus_spawning:get_active_respawn_units()
end

GameModeDeus.get_available_and_active_respawn_units = function (arg_47_0)
	return arg_47_0._deus_spawning:get_available_and_active_respawn_units()
end

GameModeDeus.get_player_wounds = function (arg_48_0, arg_48_1)
	if Managers.state.game_mode:has_activated_mutator("instant_death") then
		return 1
	end

	return Managers.state.difficulty:get_difficulty_settings().wounds
end

GameModeDeus.mutators = function (arg_49_0)
	local var_49_0 = table.shallow_copy(arg_49_0._mutators)

	arg_49_0:append_live_event_mutators(var_49_0)

	local var_49_1 = arg_49_0._deus_run_controller:get_event_mutators()

	if var_49_1 then
		local var_49_2 = table.set(var_49_0)

		for iter_49_0 = 1, #var_49_1 do
			local var_49_3 = var_49_1[iter_49_0]

			if not var_49_2[var_49_3] then
				var_49_0[#var_49_0 + 1] = var_49_3
			end
		end
	end

	return var_49_0
end

GameModeDeus.on_picked_up_soft_currency = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	local var_50_0 = arg_50_0._deus_run_controller
	local var_50_1
	local var_50_2

	if arg_50_3 then
		var_50_1, var_50_2 = arg_50_3, arg_50_4 or DeusSoftCurrencySettings.types.GROUND
	else
		var_50_1, var_50_2 = arg_50_0:_get_coins_amount_and_type(arg_50_1)
	end

	local var_50_3 = Managers.player:unit_owner(arg_50_2)

	if var_50_3.bot_player or var_50_3.remote then
		Managers.state.entity:system("audio_system"):play_2d_audio_event("hud_morris_currency_added")
	else
		local var_50_4 = Managers.world:wwise_world(arg_50_0._world)

		WwiseWorld.trigger_event(var_50_4, "hud_morris_pickup_chest")
	end

	local var_50_5 = Managers.player:local_player()
	local var_50_6 = var_50_5 and var_50_5.player_unit
	local var_50_7 = var_50_6 and ScriptUnit.has_extension(var_50_6, "buff_system")

	if var_50_7 then
		var_50_1 = var_50_7:apply_buffs_to_value(var_50_1, "deus_coins_greed")
		var_50_1 = math.floor(var_50_1)
	end

	var_50_0:on_soft_currency_picked_up(var_50_1, var_50_2)

	if UISettings.deus.show_coin_pickup_in_chat then
		local var_50_8

		if var_50_3:is_player_controlled() then
			var_50_8 = var_50_0:get_player_name(var_50_3.peer_id)
		else
			var_50_8 = var_50_3:name()
		end

		local var_50_9 = true
		local var_50_10

		if not var_50_3.bot_player and not var_50_3.remote then
			var_50_10 = string.format(Localize("system_chat_local_player_picked_up_deus_currency"), var_50_1)
		else
			var_50_10 = string.format(Localize("system_chat_other_player_picked_up_deus_currency"), var_50_8, var_50_1)
		end

		Managers.chat:add_local_system_message(1, var_50_10, var_50_9)
	end
end

GameModeDeus.get_boss_loot_pickup = function (arg_51_0)
	return "deus_soft_currency"
end

GameModeDeus._get_coins_amount_and_type = function (arg_52_0, arg_52_1)
	local var_52_0 = ScriptUnit.has_extension(arg_52_1, "pickup_system")

	if not var_52_0 then
		return 0
	end

	local var_52_1 = arg_52_0._deus_run_controller
	local var_52_2 = var_52_1:get_current_node().system_seeds.pickups or 0
	local var_52_3 = HashUtils.fnv32_hash(Managers.state.unit_storage:go_id(arg_52_1) .. "_" .. var_52_2)
	local var_52_4, var_52_5 = Math.next_random(var_52_3)
	local var_52_6 = #var_52_1:get_peers()
	local var_52_7 = var_52_0:get_dropped_by_breed()
	local var_52_8 = DeusSoftCurrencySettings.loot_amount[var_52_7]
	local var_52_9 = var_52_8[var_52_6] or var_52_8[#var_52_8]
	local var_52_10 = var_52_9.min
	local var_52_11 = var_52_9.max
	local var_52_12 = math.lerp(var_52_10, var_52_11, var_52_5)
	local var_52_13

	if not var_52_7 or var_52_7 == "n/a" then
		var_52_13 = DeusSoftCurrencySettings.types.GROUND
	else
		var_52_13 = DeusSoftCurrencySettings.types.MONSTER
	end

	return math.round(var_52_12), var_52_13
end

GameModeDeus.players_left_safe_zone = function (arg_53_0)
	local var_53_0 = Managers.mechanism:game_mechanism()

	if (var_53_0 and var_53_0:get_current_node_theme()) == DEUS_THEME_TYPES.BELAKOR then
		return
	end

	local var_53_1 = LevelHelper:find_dialogue_unit(arg_53_0._world, var_0_1)

	if var_53_1 and ScriptUnit.has_extension(var_53_1, "dialogue_system") then
		local var_53_2 = arg_53_0._deus_run_controller:get_current_node().curse

		var_0_3(var_53_1, var_53_2)
	else
		print("GameModeDeus:players_left_safe_zone - no unit for curse intro vo")
	end
end

GameModeDeus._update_morris_music_intensity = function (arg_54_0)
	local var_54_0 = Managers.state.conflict.pacing.total_intensity
	local var_54_1 = Managers.state.entity:system("audio_system")
	local var_54_2 = NetworkLookup.global_parameter_names.morris_music_intensity
	local var_54_3 = math.round(math.clamp(var_54_0, 0, 100))

	if arg_54_0._sent_intensity and arg_54_0._sent_intensity == var_54_3 then
		return
	end

	var_54_1:set_global_parameter_with_lerp("morris_music_intensity", var_54_3)

	if arg_54_0._network_transmit then
		arg_54_0._network_transmit:send_rpc_clients("rpc_client_audio_set_global_parameter_with_lerp", var_54_2, var_54_3 / 100)
	end

	arg_54_0._sent_intensity = var_54_3
end
