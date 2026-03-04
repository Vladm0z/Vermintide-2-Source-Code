-- chunkname: @scripts/managers/game_mode/mechanisms/deus_mechanism.lua

require("scripts/managers/game_mode/mechanisms/deus_run_controller")
require("scripts/settings/dlcs/morris/deus_default_graph_settings")
require("scripts/settings/dlcs/morris/deus_node_settings")
require("scripts/settings/dlcs/morris/deus_theme_settings")

DeusMechanism = class(DeusMechanism)
DeusMechanism.name = "Deus"

local var_0_0 = {
	"rpc_deus_setup_run"
}
local var_0_1 = {}
local var_0_2 = {}

for iter_0_0, iter_0_1 in ipairs(SPProfiles) do
	if iter_0_1.affiliation == "heroes" then
		local var_0_3 = iter_0_1.careers

		for iter_0_2, iter_0_3 in ipairs(var_0_3) do
			var_0_1[#var_0_1 + 1] = iter_0_3.name
		end
	end
end

local var_0_4 = 1
local var_0_5 = "morris_hub"
local var_0_6 = "inn_deus"
local var_0_7 = "inn_deus"
local var_0_8 = "dlc_morris_map"
local var_0_9 = "map_deus"
local var_0_10 = "map_deus"
local var_0_11 = "deus"
local var_0_12 = "ingame_deus"

local function var_0_13(arg_1_0)
	return DeusNodeSettings[arg_1_0].mechanism_state
end

local function var_0_14(arg_2_0)
	return DeusNodeSettings[arg_2_0].game_mode_key
end

local function var_0_15(arg_3_0)
	if arg_3_0 == var_0_8 then
		return "map"
	end

	if arg_3_0 == var_0_5 then
		return "inn"
	end

	return "ingame"
end

local function var_0_16(arg_4_0)
	local var_4_0 = arg_4_0.mission_id
	local var_4_1 = arg_4_0.difficulty
	local var_4_2 = arg_4_0.quick_game
	local var_4_3 = arg_4_0.private_game
	local var_4_4 = arg_4_0.always_host
	local var_4_5 = arg_4_0.strict_matchmaking
	local var_4_6 = arg_4_0.matchmaking_type
	local var_4_7 = arg_4_0.twitch_enabled

	print("............................................................................................................")
	print("............................................................................................................")
	printf("GAME START SETTINGS -> Level: %s | Difficulty: %s | Private: %s | Always Host: %s | Strict Matchmaking: %s | Quick Game: %s | Matchmaking Type: %s | Twitch: %s", var_4_0 and var_4_0 or "Not specified", var_4_1, var_4_3 and "yes" or "no", var_4_4 and "yes" or "no", var_4_5 and "yes" or "no", var_4_2 and "yes" or "no", var_4_6 or "Not specified", var_4_7 and "Yes" or "No")
	print("............................................................................................................")
	print("............................................................................................................")
end

local var_0_17 = {
	deus_quickplay = function(arg_5_0, arg_5_1)
		local var_5_0 = {
			mechanism = "deus",
			difficulty = arg_5_1.difficulty,
			quick_game = arg_5_1.quick_game,
			private_game = arg_5_1.private_game,
			always_host = arg_5_1.always_host,
			strict_matchmaking = arg_5_1.strict_matchmaking,
			matchmaking_type = arg_5_1.matchmaking_type,
			vote_type = arg_5_1.request_type
		}

		Managers.state.voting:request_vote("deus_settings_vote", var_5_0, Network.peer_id())
	end,
	deus_custom = function(arg_6_0, arg_6_1)
		local var_6_0 = {
			mechanism = "deus",
			mission_id = arg_6_1.mission_id,
			difficulty = arg_6_1.difficulty,
			quick_game = arg_6_1.quick_game,
			private_game = arg_6_1.private_game,
			always_host = arg_6_1.always_host,
			strict_matchmaking = arg_6_1.strict_matchmaking,
			dominant_god = arg_6_1.dominant_god,
			matchmaking_type = arg_6_1.matchmaking_type,
			vote_type = arg_6_1.request_type
		}

		Managers.state.voting:request_vote("deus_settings_vote", var_6_0, Network.peer_id())
	end,
	deus_twitch = function(arg_7_0, arg_7_1)
		local var_7_0 = {
			mechanism = "deus",
			mission_id = arg_7_1.mission_id,
			difficulty = arg_7_1.difficulty,
			quick_game = arg_7_1.quick_game,
			private_game = arg_7_1.private_game,
			always_host = arg_7_1.always_host,
			strict_matchmaking = arg_7_1.strict_matchmaking,
			dominant_god = arg_7_1.dominant_god,
			matchmaking_type = arg_7_1.matchmaking_type,
			vote_type = arg_7_1.request_type
		}

		Managers.state.voting:request_vote("deus_settings_vote", var_7_0, Network.peer_id())
	end,
	deus_weekly = function(arg_8_0, arg_8_1)
		local var_8_0 = {
			mechanism = "deus",
			mission_id = arg_8_1.mission_id,
			event_data = arg_8_1.event_data,
			difficulty = arg_8_1.difficulty,
			quick_game = arg_8_1.quick_game,
			private_game = arg_8_1.private_game,
			always_host = arg_8_1.always_host,
			strict_matchmaking = arg_8_1.strict_matchmaking,
			dominant_god = arg_8_1.dominant_god,
			matchmaking_type = arg_8_1.matchmaking_type,
			vote_type = arg_8_1.request_type
		}

		Managers.state.voting:request_vote("deus_settings_vote", var_8_0, Network.peer_id())
	end
}

local function var_0_18(arg_9_0)
	return math.round(math.lerp(-DifficultyTweak.range, DifficultyTweak.range, arg_9_0))
end

local function var_0_19(arg_10_0, arg_10_1)
	local var_10_0
	local var_10_1
	local var_10_2
	local var_10_3 = "deus"
	local var_10_4
	local var_10_5
	local var_10_6
	local var_10_7
	local var_10_8
	local var_10_9 = {}

	if not arg_10_0 or arg_10_0:get_run_ended() then
		var_10_0 = var_0_5
	elseif arg_10_1 then
		var_10_0 = var_0_8
	else
		local var_10_10 = arg_10_0:get_current_node()
		local var_10_11 = var_10_10.node_type

		var_10_0 = var_10_10.level
		var_10_2 = var_10_10.level_seed
		var_10_1 = LevelHelper:get_random_variation_id(var_10_0)
		var_10_4 = var_0_14(var_10_11)
		var_10_7 = arg_10_0:get_run_difficulty()

		local var_10_12 = var_10_10.run_progress

		var_10_8 = var_0_18(var_10_12)
		var_10_5 = var_10_10.conflict_settings
		var_10_6 = nil

		local var_10_13 = var_10_10.curse

		if var_10_13 then
			local var_10_14 = MutatorTemplates[var_10_13].packages

			if var_10_14 then
				table.append(var_10_9, var_10_14)
			end
		end
	end

	return var_10_0, var_10_1, var_10_2, var_10_3, var_10_4, var_10_5, var_10_6, var_10_7, var_10_8, var_10_9
end

function DeusMechanism.init(arg_11_0, arg_11_1)
	arg_11_0._is_server = true
	arg_11_0._hero_profiles = table.clone(PROFILES_BY_AFFILIATION.heroes)
	arg_11_0._state = var_0_7
end

function DeusMechanism._reset(arg_12_0, arg_12_1)
	if arg_12_0._deus_run_controller then
		arg_12_0._deus_run_controller:destroy()

		arg_12_0._deus_run_controller = nil
	end

	arg_12_0._run_id = nil
	arg_12_0._run_seed = nil
	arg_12_0._final_round = false

	if arg_12_0._is_server then
		arg_12_0:_update_current_state(true)
	end
end

function DeusMechanism.network_context_created(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	arg_13_0._is_server = arg_13_4

	if arg_13_0._deus_run_controller then
		Managers.mechanism:manual_end_venture()

		local var_13_0 = Managers.level_transition_handler:get_current_level_key()
		local var_13_1 = LevelSettings[var_13_0]

		if arg_13_4 and not arg_13_0._deus_run_controller:get_run_ended() and not var_13_1.hub_level then
			arg_13_0._deus_run_controller:network_context_created(arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
		else
			arg_13_0._deus_run_controller:destroy()

			arg_13_0._deus_run_controller = nil
		end
	end

	if arg_13_4 then
		arg_13_0:_update_current_state()
	end
end

function DeusMechanism.network_context_destroyed(arg_14_0)
	return
end

function DeusMechanism.handle_ingame_enter(arg_15_0, arg_15_1)
	if arg_15_0._deus_run_controller then
		arg_15_0._deus_run_controller:full_sync()
		arg_15_0:_update_own_avatar_info()
		arg_15_0._deus_run_controller:handle_level_start()

		if arg_15_1 == var_0_11 and arg_15_0._deus_run_controller:is_server() then
			arg_15_0:_send_level_started_tracking_data()
		end
	end

	if Development.parameter("deus-auto-host") and arg_15_1 == var_0_6 then
		Managers.state.game_mode:complete_level()
	end
end

function DeusMechanism.handle_ingame_exit(arg_16_0, arg_16_1)
	if arg_16_1 == "join_lobby_failed" or arg_16_1 == "left_game" or arg_16_1 == "lobby_state_failed" or arg_16_1 == "kicked_by_server" or arg_16_1 == "afk_kick" or arg_16_1 == "quit_game" or arg_16_1 == "return_to_pc_menu" or arg_16_1 == "backend_disconnected" then
		arg_16_0:_reset()
	end
end

function DeusMechanism.create_host_migration_info(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = Managers.mechanism:network_handler()
	local var_17_1 = arg_17_0._deus_run_controller
	local var_17_2 = var_17_0.host_to_migrate_to

	if var_17_1 and var_17_2 then
		local var_17_3 = var_17_2.peer_id

		if (var_17_1:get_player_profile(var_17_3, var_0_4) ~= 0 and var_17_1:get_player_health_state(var_17_3, var_0_4)) ~= "alive" then
			var_17_1 = nil
		end
	end

	if var_17_1 and var_17_1:get_run_ended() then
		var_17_1 = nil
	end

	if var_17_1 and not var_17_2 then
		var_17_1 = nil
	end

	local var_17_4 = arg_17_0._state == var_0_10
	local var_17_5 = var_17_0:get_network_state():get_game_mode_event_data()
	local var_17_6 = {
		host_to_migrate_to = var_17_2,
		game_mode_event_data = not table.is_empty(var_17_5) and var_17_5 or nil
	}
	local var_17_7, var_17_8, var_17_9, var_17_10, var_17_11, var_17_12, var_17_13, var_17_14, var_17_15, var_17_16 = var_0_19(var_17_1, var_17_4)

	var_17_6.level_data = {
		level_key = var_17_7,
		environment_variation_id = var_17_8,
		level_seed = var_17_9,
		mechanism = var_17_10,
		game_mode_key = var_17_11,
		conflict_settings = var_17_12,
		locked_director_functions = var_17_13,
		difficulty = var_17_14,
		difficulty_tweak = var_17_15,
		extra_packages = var_17_16
	}

	local var_17_17 = var_17_0.lobby_client:lobby_data("is_private")
	local var_17_18

	if IS_PS4 then
		var_17_18 = "n/a"
	elseif var_17_1 then
		var_17_18 = NetworkLookup.matchmaking_types["n/a"]
	else
		var_17_18 = var_17_0.lobby_client:lobby_data("matchmaking_type") or NetworkLookup.matchmaking_types["n/a"]
	end

	var_17_6.lobby_data = {
		is_private = var_17_17,
		difficulty = var_17_14,
		difficulty_tweak = var_17_15,
		selected_mission_id = var_17_7,
		mission_id = var_17_7,
		matchmaking_type = var_17_18,
		mechanism = var_17_10
	}

	return var_17_6
end

function DeusMechanism.register_rpcs(arg_18_0, arg_18_1)
	arg_18_0:unregister_rpcs()

	arg_18_0._network_event_delegate = arg_18_1

	arg_18_1:register(arg_18_0, unpack(var_0_0))

	if arg_18_0._deus_run_controller then
		arg_18_0._deus_run_controller:register_rpcs(arg_18_0._network_event_delegate)
	end
end

function DeusMechanism.unregister_rpcs(arg_19_0)
	if arg_19_0._network_event_delegate then
		arg_19_0._network_event_delegate:unregister(arg_19_0)

		arg_19_0._network_event_delegate = nil
	end

	if arg_19_0._deus_run_controller then
		arg_19_0._deus_run_controller:unregister_rpcs()
	end
end

function DeusMechanism.can_resync_loadout(arg_20_0)
	if Managers.level_transition_handler:get_current_game_mode() == "deus" then
		return arg_20_0._deus_run_controller ~= nil
	else
		return true
	end
end

function DeusMechanism.update_loadout(arg_21_0)
	local var_21_0 = arg_21_0._deus_run_controller

	if var_21_0 and not var_21_0:get_run_ended() then
		local var_21_1 = var_21_0:get_own_peer_id()
		local var_21_2, var_21_3 = var_21_0:get_player_profile(var_21_1, var_0_4)

		if var_21_2 ~= 0 then
			local var_21_4 = SPProfiles[var_21_2].careers[var_21_3].name

			arg_21_0:_update_career_loadout(var_0_4, var_21_4)
		end
	end
end

function DeusMechanism._update_career_loadout(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	local var_22_0 = arg_22_0._deus_run_controller

	if not var_22_0 or var_22_0:get_run_ended() then
		return
	end

	local var_22_1 = var_22_0:get_own_peer_id()
	local var_22_2 = Managers.backend:get_interface("deus")
	local var_22_3 = CareerSettings[arg_22_2]
	local var_22_4 = var_22_3.profile_name
	local var_22_5 = FindProfileIndex(var_22_3.profile_name)
	local var_22_6 = SPProfiles[var_22_5].careers
	local var_22_7 = table.index_of(var_22_6, var_22_3)
	local var_22_8 = var_22_3.talent_tree_index
	local var_22_9, var_22_10 = var_22_0:get_loadout(var_22_1, arg_22_1, var_22_5, var_22_7)

	if var_22_9 then
		var_22_2:grant_deus_weapon(var_22_9)
		var_22_2:set_loadout_item(var_22_9.backend_id, arg_22_2, "slot_melee")
	end

	if var_22_10 then
		var_22_2:grant_deus_weapon(var_22_10)
		var_22_2:set_loadout_item(var_22_10.backend_id, arg_22_2, "slot_ranged")
	end

	local var_22_11 = var_22_0:get_power_ups(var_22_1, arg_22_1, var_22_5, var_22_7, arg_22_3)
	local var_22_12 = {}

	for iter_22_0, iter_22_1 in ipairs(var_22_11) do
		local var_22_13 = DeusPowerUps[iter_22_1.rarity][iter_22_1.name]

		if var_22_13.talent then
			local var_22_14 = var_22_13.talent_index
			local var_22_15 = var_22_13.talent_tier
			local var_22_16 = TalentTrees[var_22_4][var_22_8][var_22_15][var_22_14]
			local var_22_17 = TalentIDLookup[var_22_16].talent_id

			var_22_12[#var_22_12 + 1] = var_22_17
		end
	end

	var_22_2:set_deus_talent_ids(arg_22_2, var_22_12, arg_22_3)
	var_22_2:refresh_deus_weapons_in_items_backend()
end

function DeusMechanism.choose_next_state(arg_23_0, arg_23_1)
	arg_23_0._next_state = arg_23_1
end

function DeusMechanism.reset_choose_next_state(arg_24_0)
	arg_24_0._next_state = nil
end

function DeusMechanism.progress_state(arg_25_0)
	arg_25_0._prior_state = arg_25_0._state

	if arg_25_0._next_state then
		arg_25_0._state = arg_25_0._next_state
		arg_25_0._next_state = nil
	else
		arg_25_0._state = var_0_7
	end

	return arg_25_0._state
end

function DeusMechanism.get_prior_state(arg_26_0)
	local var_26_0 = arg_26_0._prior_state

	if var_26_0 == var_0_10 or var_26_0 == var_0_12 then
		return "deus"
	end

	return var_26_0
end

function DeusMechanism.set_current_state(arg_27_0, arg_27_1)
	arg_27_0._prior_state = arg_27_0._state
	arg_27_0._state = arg_27_1
end

function DeusMechanism.get_hub_level_key(arg_28_0)
	return var_0_5
end

function DeusMechanism.get_end_of_level_rewards_arguments(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
	local var_29_0 = arg_29_0._deus_run_controller:get_end_of_level_rewards_arguments(arg_29_1, arg_29_2)
	local var_29_1 = false
	local var_29_2 = LevelUnlockUtils.current_weave(arg_29_3, arg_29_4, var_29_1)
	local var_29_3 = WeaveSettings.templates[var_29_2]
	local var_29_4 = WeaveSettings.templates_ordered

	var_29_0.current_weave_index = table.find(var_29_4, var_29_3)
	var_29_0.kill_count = arg_29_3:get_stat(arg_29_4, "kills_total")

	return var_29_0
end

function DeusMechanism.get_end_of_level_extra_mission_results(arg_30_0)
	return arg_30_0._deus_run_controller:get_mission_results()
end

function DeusMechanism.get_players_session_score(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	return arg_31_0._deus_run_controller and arg_31_0._deus_run_controller:get_scoreboard()
end

function DeusMechanism.on_final_round_won(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = Managers.player:local_player()
	local var_32_1 = arg_32_0._deus_run_controller:get_journey_name()
	local var_32_2 = arg_32_0._deus_run_controller:get_run_difficulty()
	local var_32_3 = arg_32_0._deus_run_controller:get_dominant_god()

	StatisticsUtil.register_journey_complete(arg_32_1, var_32_0, var_32_1, var_32_3, var_32_2)
end

function DeusMechanism.request_vote(arg_33_0, arg_33_1)
	var_0_16(arg_33_1)

	local var_33_0 = {
		mission_id = arg_33_1.mission_id,
		event_data = arg_33_1.event_data,
		difficulty = arg_33_1.difficulty,
		quick_game = arg_33_1.quick_game,
		private_game = arg_33_1.private_game,
		always_host = arg_33_1.always_host,
		strict_matchmaking = arg_33_1.strict_matchmaking,
		dominant_god = arg_33_1.dominant_god,
		matchmaking_type = arg_33_1.matchmaking_type,
		mechanism = arg_33_1.mechanism,
		vote_type = arg_33_1.request_type
	}

	Managers.state.voting:request_vote("deus_settings_vote", var_33_0, Network.peer_id())
end

function DeusMechanism.get_deus_run_controller(arg_34_0)
	return arg_34_0._deus_run_controller
end

function DeusMechanism.is_final_round(arg_35_0)
	return arg_35_0._final_round
end

function DeusMechanism.is_venture_over(arg_36_0)
	local var_36_0 = arg_36_0._game_round_ended_reason

	return (var_36_0 == "won" or var_36_0 == "lost") and (var_36_0 == "lost" or arg_36_0._final_round)
end

function DeusMechanism.game_round_ended(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	fassert(arg_37_3 == "reload" or arg_37_3 == "won" or arg_37_3 == "lost" or arg_37_3 == "start_game", "unsupported reason for game end")

	arg_37_0._game_round_ended_reason = arg_37_3

	local var_37_0

	if arg_37_3 == "reload" then
		Managers.level_transition_handler:reload_level()
		Managers.level_transition_handler:promote_next_level_data()

		arg_37_0._next_state = arg_37_0._state
	elseif arg_37_3 == "start_game" then
		local var_37_1
		local var_37_2
		local var_37_3
		local var_37_4 = var_0_2
		local var_37_5 = var_0_2

		if arg_37_0._vote_data then
			var_37_1 = arg_37_0._vote_data.difficulty
			var_37_2 = arg_37_0._vote_data.mission_id
			var_37_3 = arg_37_0._vote_data.dominant_god

			local var_37_6 = arg_37_0._vote_data.event_data or var_0_2

			var_37_4 = var_37_6.mutators or var_0_2
			var_37_5 = var_37_6.boons or var_0_2
		else
			var_37_1 = "normal"
			var_37_2 = AvailableJourneyOrder[1]
			var_37_3 = DeusJourneyCycleGods[1]
		end

		local var_37_7 = string.sub(tostring(math.random_seed()), 0, 8)
		local var_37_8

		if script_data.deus_seed then
			var_37_8 = script_data.deus_seed
		elseif DEUS_MAP_SEED_WHITELIST.use_full_gen_whitelist then
			local var_37_9 = DEUS_MAP_SEED_WHITELIST.full_gen_whitelist[var_37_2] or DEUS_MAP_SEED_WHITELIST.full_gen_whitelist.default
			local var_37_10, var_37_11 = Math.next_random(math.random_seed(), 1, #var_37_9)

			var_37_8 = var_37_9[var_37_11]
		else
			var_37_8 = tostring(math.random_seed())
		end

		var_37_2 = script_data.deus_journey or var_37_2
		var_37_3 = script_data.deus_dominant_god or var_37_3

		local var_37_12 = false
		local var_37_13 = Managers.backend:get_interface("deus")

		if var_37_13 then
			var_37_13:get_belakor_cycle()

			var_37_12 = var_37_13:deus_journey_with_belakor(var_37_2)
		end

		arg_37_0:_setup_run(var_37_7, var_37_8, true, Network.peer_id(), var_37_1, var_37_2, var_37_3, var_37_12, var_37_4, var_37_5)

		local var_37_14 = NetworkLookup.difficulties[var_37_1]
		local var_37_15 = NetworkLookup.deus_journeys[var_37_2]
		local var_37_16 = NetworkLookup.deus_themes[var_37_3]
		local var_37_17 = {}

		for iter_37_0 = 1, #var_37_4 do
			local var_37_18 = var_37_4[iter_37_0]
			local var_37_19 = NetworkLookup.mutator_templates[var_37_18]

			var_37_17[#var_37_17 + 1] = var_37_19
		end

		local var_37_20 = {}

		for iter_37_1 = 1, #var_37_5 do
			local var_37_21 = var_37_5[iter_37_1]
			local var_37_22 = DeusPowerUpsLookup[var_37_21]

			var_37_20[#var_37_20 + 1] = var_37_22.lookup_id
		end

		Managers.mechanism:send_rpc_clients("rpc_deus_setup_run", var_37_7, var_37_8, var_37_14, var_37_15, var_37_16, var_37_12, var_37_17, var_37_20)

		var_37_0 = arg_37_0:_transition_next_node("start")
	else
		local var_37_23 = arg_37_0._state

		if var_37_23 == var_0_12 or var_37_23 == var_0_10 then
			local var_37_24 = arg_37_3 == "won"

			if var_37_23 == var_0_12 then
				arg_37_0:_send_level_ended_tracking_data(var_37_24)
			end

			if arg_37_3 == "lost" then
				arg_37_0:_send_run_tracking_data(var_37_24)
				arg_37_0._deus_run_controller:handle_run_ended()

				var_37_0 = arg_37_0:_transition_to_inn()
			elseif var_37_24 then
				if var_37_23 == var_0_12 then
					arg_37_0._deus_run_controller:handle_level_won()
				end

				if #arg_37_0._deus_run_controller:get_current_node().next > 0 then
					if var_37_23 == var_0_10 then
						local var_37_25 = arg_37_4

						if var_37_25 == nil then
							var_37_25 = arg_37_0._deus_run_controller:get_current_node().next[1]
						end

						var_37_0 = arg_37_0:_transition_next_node(var_37_25)
					else
						var_37_0 = arg_37_0:_transition_map()
					end
				else
					arg_37_0:_send_run_tracking_data(var_37_24)
					arg_37_0._deus_run_controller:handle_run_ended()

					var_37_0 = arg_37_0:_transition_to_inn()
				end
			end
		end
	end

	if var_37_0 then
		arg_37_0._next_state = var_37_0
	end
end

function DeusMechanism._transition_next_node(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._deus_run_controller
	local var_38_1 = Managers.level_transition_handler

	var_38_0:set_current_node_key(arg_38_1)

	local var_38_2 = var_38_0:get_current_node().node_type
	local var_38_3 = false
	local var_38_4, var_38_5, var_38_6, var_38_7, var_38_8, var_38_9, var_38_10, var_38_11, var_38_12, var_38_13 = var_0_19(var_38_0, var_38_3)

	var_38_1:set_next_level(var_38_4, var_38_5, var_38_6, var_38_7, var_38_8, var_38_9, var_38_10, var_38_11, var_38_12, var_38_13)
	var_38_1:promote_next_level_data()

	return (var_0_13(var_38_2))
end

function DeusMechanism._transition_map(arg_39_0)
	local var_39_0 = arg_39_0._deus_run_controller
	local var_39_1 = Managers.level_transition_handler
	local var_39_2 = true
	local var_39_3, var_39_4, var_39_5, var_39_6, var_39_7, var_39_8, var_39_9, var_39_10, var_39_11, var_39_12 = var_0_19(var_39_0, var_39_2)

	var_39_1:set_next_level(var_39_3, var_39_4, var_39_5, var_39_6, var_39_7, var_39_8, var_39_9, var_39_10, var_39_11, var_39_12)

	return var_0_10
end

function DeusMechanism._transition_to_inn(arg_40_0)
	local var_40_0 = Managers.level_transition_handler
	local var_40_1 = false
	local var_40_2
	local var_40_3, var_40_4, var_40_5, var_40_6, var_40_7, var_40_8, var_40_9, var_40_10, var_40_11, var_40_12 = var_0_19(var_40_2, var_40_1)

	var_40_0:set_next_level(var_40_3, var_40_4, var_40_5, var_40_6, var_40_7, var_40_8, var_40_9, var_40_10, var_40_11, var_40_12)

	arg_40_0._post_match = true

	return var_0_7
end

function DeusMechanism.should_run_tutorial(arg_41_0)
	return true, "tutorial"
end

function DeusMechanism.get_level_end_view(arg_42_0)
	return "LevelEndViewDeus"
end

function DeusMechanism.get_level_end_view_packages(arg_43_0)
	return {
		"resource_packages/levels/ui_end_screen"
	}
end

function DeusMechanism._get_next_game_mode_key(arg_44_0)
	local var_44_0
	local var_44_1 = arg_44_0._state

	if var_44_1 == var_0_7 then
		var_44_0 = var_0_6
	elseif var_44_1 == var_0_12 then
		local var_44_2 = arg_44_0._deus_run_controller:get_current_node()

		var_44_0 = var_0_14(var_44_2.node_type)
	elseif var_44_1 == var_0_10 then
		var_44_0 = var_0_9
	end

	return var_44_0
end

function DeusMechanism.start_next_round(arg_45_0)
	local var_45_0 = arg_45_0._deus_run_controller

	arg_45_0._game_round_ended_reason = nil
	arg_45_0._final_round = false

	local var_45_1 = arg_45_0._state
	local var_45_2 = arg_45_0:_build_side_compositions(var_45_1)
	local var_45_3 = arg_45_0:_get_next_game_mode_key()
	local var_45_4 = script_data.debug_activated_blessings or var_45_0 and var_45_0:get_blessings() or {}
	local var_45_5 = {}

	for iter_45_0, iter_45_1 in ipairs(var_45_4) do
		local var_45_6 = DeusBlessingSettings[iter_45_1]

		if var_45_6.mutators then
			for iter_45_2, iter_45_3 in ipairs(var_45_6.mutators) do
				var_45_5[#var_45_5 + 1] = iter_45_3
			end
		end
	end

	if var_45_1 == var_0_7 then
		if var_45_0 then
			var_45_0:destroy()

			arg_45_0._deus_run_controller = nil
		end
	elseif var_45_1 == var_0_12 then
		local var_45_7 = var_45_0:get_current_node()

		arg_45_0._final_round = not (var_45_7.next and #var_45_7.next > 0)

		local var_45_8 = var_45_7.curse

		if var_45_8 then
			var_45_5[#var_45_5 + 1] = var_45_8
		end

		local var_45_9 = var_45_7.minor_modifier_group

		if var_45_9 then
			for iter_45_4, iter_45_5 in ipairs(var_45_9) do
				var_45_5[#var_45_5 + 1] = iter_45_5
			end
		end

		local var_45_10 = var_45_7.theme
		local var_45_11 = DeusThemeSettings[var_45_10].mutators

		if var_45_11 then
			for iter_45_6, iter_45_7 in ipairs(var_45_11) do
				var_45_5[#var_45_5 + 1] = iter_45_7
			end
		end

		if var_45_7.mutators then
			for iter_45_8, iter_45_9 in ipairs(var_45_7.mutators) do
				var_45_5[#var_45_5 + 1] = iter_45_9
			end
		end

		var_45_0:handle_start_next_round()
	end

	local var_45_12 = {
		mutators = var_45_5,
		deus_run_controller = var_45_0
	}

	return var_45_3, var_45_2, var_45_12
end

function DeusMechanism._build_side_compositions(arg_46_0, arg_46_1)
	local var_46_0 = arg_46_0._hero_profiles
	local var_46_1 = Managers.party

	return {
		{
			name = "heroes",
			relations = {
				enemy = {
					"dark_pact"
				}
			},
			party = var_46_1:get_party(1),
			add_these_settings = {
				using_grims_and_tomes = true,
				show_damage_feedback = false,
				using_enemy_recycler = true,
				available_profiles = var_46_0
			}
		},
		{
			name = "dark_pact",
			relations = {
				enemy = {
					"heroes"
				}
			}
		},
		{
			name = "neutral",
			relations = {
				enemy = {}
			}
		}
	}
end

function DeusMechanism.get_state(arg_47_0)
	return arg_47_0._state
end

function DeusMechanism.generate_level_seed(arg_48_0)
	local var_48_0 = arg_48_0._deus_run_controller
	local var_48_1 = var_48_0 and var_48_0:get_current_node()

	return var_48_1 and var_48_1.level_seed or 0
end

function DeusMechanism.get_current_node_curse(arg_49_0)
	local var_49_0 = arg_49_0._deus_run_controller
	local var_49_1 = var_49_0 and var_49_0:get_current_node()

	return var_49_1 and var_49_1.curse or nil
end

function DeusMechanism.get_current_node_theme(arg_50_0)
	local var_50_0 = arg_50_0._deus_run_controller
	local var_50_1 = var_50_0 and var_50_0:get_current_node()

	return var_50_1 and var_50_1.theme or nil
end

function DeusMechanism.get_level_seed(arg_51_0, arg_51_1, arg_51_2)
	local var_51_0 = arg_51_0._deus_run_controller
	local var_51_1 = var_51_0 and var_51_0:get_current_node()

	if arg_51_2 then
		return var_51_1 and var_51_1.system_seeds[arg_51_2] or 0
	end

	return var_51_1 and var_51_1.level_seed or 0
end

function DeusMechanism.can_spawn_pickup(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0

	if Pickups.deus_potions[arg_52_2] then
		var_52_0 = Unit.get_data(arg_52_1, "deus_potion")
	end

	if arg_52_2 == "deus_02" then
		var_52_0 = Unit.get_data(arg_52_1, "deus_cursed_chest") or Unit.get_data(arg_52_1, "deus_02")
	end

	return var_52_0
end

function DeusMechanism.uses_random_directors(arg_53_0)
	return false
end

function DeusMechanism.profile_changed(arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
	if arg_54_0._deus_run_controller and not arg_54_0._deus_run_controller:get_run_ended() then
		arg_54_0._deus_run_controller:profile_changed(arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)

		if arg_54_1 == arg_54_0._deus_run_controller:get_own_peer_id() and arg_54_2 == var_0_4 then
			arg_54_0:_update_own_avatar_info()
		end

		local var_54_0 = SPProfiles[arg_54_3].careers[arg_54_4].name

		arg_54_0:_update_career_loadout(arg_54_2, var_54_0, arg_54_5)
	end
end

function DeusMechanism.sync_mechanism_data(arg_55_0, arg_55_1, arg_55_2)
	if not arg_55_2 then
		return
	end

	local var_55_0 = arg_55_0._deus_run_controller

	if var_55_0 and not var_55_0:get_run_ended() then
		local var_55_1 = NetworkLookup.difficulties[var_55_0:get_run_difficulty()]
		local var_55_2 = NetworkLookup.deus_journeys[var_55_0:get_journey_name()]
		local var_55_3 = NetworkLookup.deus_themes[var_55_0:get_dominant_god()]
		local var_55_4 = var_55_0:get_belakor_enabled()
		local var_55_5 = var_55_0:get_event_mutators()
		local var_55_6 = var_55_0:get_event_boons()
		local var_55_7 = {}

		for iter_55_0 = 1, #var_55_5 do
			local var_55_8 = var_55_5[iter_55_0]
			local var_55_9 = NetworkLookup.mutator_templates[var_55_8]

			var_55_7[#var_55_7 + 1] = var_55_9
		end

		local var_55_10 = {}

		for iter_55_1 = 1, #var_55_6 do
			local var_55_11 = var_55_6[iter_55_1].name
			local var_55_12 = DeusPowerUpsLookup[var_55_11]

			var_55_10[#var_55_10 + 1] = var_55_12.lookup_id
		end

		local var_55_13 = PEER_ID_TO_CHANNEL[arg_55_1]

		RPC.rpc_deus_setup_run(var_55_13, arg_55_0._run_id, arg_55_0._run_seed, var_55_1, var_55_2, var_55_3, not not var_55_4, var_55_7, var_55_10)
	end
end

function DeusMechanism._send_level_started_tracking_data(arg_56_0)
	local var_56_0 = Managers.player:statistics_db()
	local var_56_1 = #Managers.player:bots()
	local var_56_2 = arg_56_0._deus_run_controller:get_level_started_tracking_data(var_56_0, var_56_1)

	Managers.telemetry_events:deus_level_started(var_56_2)
end

function DeusMechanism._send_level_ended_tracking_data(arg_57_0, arg_57_1)
	local var_57_0 = Managers.player:statistics_db()
	local var_57_1 = #Managers.player:bots()
	local var_57_2 = arg_57_0._deus_run_controller:get_level_ended_tracking_data(var_57_0, arg_57_1, var_57_1)

	Managers.telemetry_events:deus_level_ended(var_57_2)
end

function DeusMechanism._send_run_tracking_data(arg_58_0, arg_58_1)
	local var_58_0 = arg_58_0._deus_run_controller:get_run_tracking_data(arg_58_1)

	Managers.telemetry_events:deus_run_ended(var_58_0)
end

function DeusMechanism.debug_load_shrine_node(arg_59_0)
	local var_59_0 = "DEBUG_SHRINE_NODE"

	arg_59_0:_debug_load_seed(var_59_0, script_data.current_difficulty_setting or "normal")
end

function DeusMechanism.debug_load_map(arg_60_0)
	arg_60_0:_debug_load_seed(script_data.deus_seed or tostring(math.random_seed()), script_data.current_difficulty_setting or "normal")
end

function DeusMechanism.debug_load_level(arg_61_0, arg_61_1)
	local var_61_0 = LevelSettings[arg_61_1]

	if var_61_0 and var_61_0.hub_level then
		local var_61_1 = Managers.level_transition_handler

		var_61_1:set_next_level(arg_61_1)
		var_61_1:promote_next_level_data()
	else
		local var_61_2 = "DEBUG_SPECIFIC_NODE" .. (script_data.deus_force_load_run_progress or 0) .. "_" .. arg_61_1 .. "SEED" .. 0 .. "SEED_END"

		arg_61_0:_debug_load_seed(var_61_2, script_data.current_difficulty_setting or "normal")
	end
end

function DeusMechanism.debug_load_deus_level(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5)
	local var_62_0 = "DEBUG_SPECIFIC_NODE" .. math.floor(arg_62_3 * 1000) .. "_" .. arg_62_1 .. "SEED" .. arg_62_4 .. "SEED_END"

	arg_62_0:_debug_load_seed(var_62_0, arg_62_2, arg_62_5)
end

function DeusMechanism._debug_load_seed(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	local var_63_0 = string.sub(tostring(math.random_seed()), 0, 8)
	local var_63_1 = script_data.deus_journey or AvailableJourneyOrder[1]
	local var_63_2 = script_data.deus_dominant_god or DeusJourneyCycleGods[1]
	local var_63_3 = {}
	local var_63_4 = {}

	arg_63_0:_setup_run(var_63_0, arg_63_1, true, Network.peer_id(), arg_63_2, var_63_1, var_63_2, not not arg_63_3, var_63_3, var_63_4)

	local var_63_5 = NetworkLookup.difficulties[arg_63_2]
	local var_63_6 = NetworkLookup.deus_journeys[var_63_1]
	local var_63_7 = NetworkLookup.deus_themes[var_63_2]
	local var_63_8 = {}
	local var_63_9 = {}

	Managers.mechanism:send_rpc_clients("rpc_deus_setup_run", var_63_0, arg_63_1, var_63_5, var_63_6, var_63_7, not not arg_63_3, var_63_8, var_63_9)

	if string.starts_with(arg_63_1, "DEBUG_SHRINE_NODE") then
		arg_63_0._deus_run_controller:debug_shrine_setup()
	end

	local var_63_10 = false
	local var_63_11 = arg_63_0._deus_run_controller
	local var_63_12, var_63_13, var_63_14, var_63_15, var_63_16, var_63_17, var_63_18, var_63_19, var_63_20, var_63_21 = var_0_19(var_63_11, var_63_10)
	local var_63_22 = Managers.level_transition_handler

	var_63_22:set_next_level(var_63_12, var_63_13, var_63_14, var_63_15, var_63_16, var_63_17, var_63_18, var_63_19, var_63_20, var_63_21)
	arg_63_0:_update_current_state()
	var_63_22:promote_next_level_data()
end

function DeusMechanism._setup_run(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6, arg_64_7, arg_64_8, arg_64_9, arg_64_10)
	local var_64_0 = Managers.backend:get_interface("deus")
	local var_64_1 = Network.peer_id()

	arg_64_0._run_id = arg_64_1
	arg_64_0._run_seed = arg_64_2

	if arg_64_0._deus_run_controller then
		arg_64_0._deus_run_controller:destroy()
	end

	arg_64_9 = arg_64_9 or var_0_2
	arg_64_10 = arg_64_10 or var_0_2

	local var_64_2 = Managers.backend:get_interface("items")
	local var_64_3 = Managers.backend:get_interface("talents")
	local var_64_4 = var_64_2:get_bot_loadout()
	local var_64_5 = {}
	local var_64_6 = {}

	for iter_64_0, iter_64_1 in ipairs(var_0_1) do
		var_64_6[iter_64_1] = var_64_3:get_bot_talents(iter_64_1)

		local var_64_7 = var_64_4[iter_64_1]
		local var_64_8 = {}

		var_64_5[iter_64_1] = var_64_8

		for iter_64_2, iter_64_3 in pairs(var_64_7) do
			if iter_64_2 == "slot_melee" or iter_64_2 == "slot_ranged" then
				local var_64_9 = var_64_2:get_item_from_id(iter_64_3)
				local var_64_10 = var_64_9 and var_64_9.key
				local var_64_11 = DeusStartingWeaponTypeMapping[var_64_10]

				if not var_64_11 then
					fassert(DeusDefaultLoadout[iter_64_1], "career %s is not properly configured for Morris.", iter_64_1)

					var_64_11 = DeusDefaultLoadout[iter_64_1][iter_64_2]

					Application.warning("Unknown weapon " .. (var_64_10 or "unknown") .. " in slot " .. iter_64_2 .. ", can't convert to deus weapon. Using " .. var_64_11)
				end

				local var_64_12 = DeusWeaponGeneration.generate_item_from_item_key(var_64_11, arg_64_5, 0, "plentiful", 0)

				var_64_12.power_level = DeusStarterWeaponPowerLevels[arg_64_5] or DeusStarterWeaponPowerLevels.default
				var_64_8[iter_64_2] = var_64_12
			end
		end
	end

	local var_64_13 = var_64_2:get_loadout()
	local var_64_14 = {}
	local var_64_15 = {}

	for iter_64_4, iter_64_5 in ipairs(var_0_1) do
		var_64_15[iter_64_5] = var_64_3:get_talents(iter_64_5)

		local var_64_16 = var_64_13[iter_64_5]
		local var_64_17 = {}

		var_64_14[iter_64_5] = var_64_17

		for iter_64_6, iter_64_7 in pairs(var_64_16) do
			if iter_64_6 == "slot_melee" or iter_64_6 == "slot_ranged" then
				local var_64_18 = var_64_2:get_item_from_id(iter_64_7)
				local var_64_19 = var_64_18 and var_64_18.key
				local var_64_20 = DeusStartingWeaponTypeMapping[var_64_19]

				if not var_64_20 then
					fassert(DeusDefaultLoadout[iter_64_5], "career %s is not properly configured for Morris.", iter_64_5)

					var_64_20 = DeusDefaultLoadout[iter_64_5][iter_64_6]

					Application.warning("Unknown weapon " .. (var_64_19 or "unknown") .. " in slot " .. iter_64_6 .. ", can't convert to deus weapon. Using " .. var_64_20)
				end

				local var_64_21 = DeusWeaponGeneration.generate_item_from_item_key(var_64_20, arg_64_5, 0, "plentiful", 0)

				var_64_21.power_level = DeusStarterWeaponPowerLevels[arg_64_5] or DeusStarterWeaponPowerLevels.default
				var_64_17[iter_64_6] = var_64_21
				var_64_5[iter_64_5][iter_64_6] = var_64_5[iter_64_5][iter_64_6] or var_64_21
			end
		end
	end

	var_64_0:reset_deus_inventory()

	local var_64_22 = {}

	for iter_64_8, iter_64_9 in pairs(var_64_14) do
		local var_64_23 = {}

		var_64_22[iter_64_8] = var_64_23

		for iter_64_10, iter_64_11 in pairs(iter_64_9) do
			var_64_23[iter_64_10] = var_64_0:grant_deus_weapon(iter_64_11)
		end
	end

	local var_64_24 = {}

	for iter_64_12, iter_64_13 in pairs(var_64_5) do
		local var_64_25 = {}

		var_64_24[iter_64_12] = var_64_25

		for iter_64_14, iter_64_15 in pairs(iter_64_13) do
			var_64_25[iter_64_14] = var_64_0:grant_deus_weapon(iter_64_15)
		end
	end

	var_64_0:refresh_deus_weapons_in_items_backend()
	var_64_0:set_deus_loadout(var_64_22)
	var_64_0:set_deus_bot_loadout(var_64_24)

	local var_64_26 = Managers.mechanism:network_handler()

	Managers.backend:set_loadout_interface_override(nil)

	local var_64_27 = {}

	for iter_64_16, iter_64_17 in pairs(DeusWeaponGroups) do
		if var_64_2:has_item(iter_64_16) then
			var_64_27[iter_64_16] = true
		end
	end

	arg_64_0._deus_run_controller = DeusRunController:new(arg_64_1, arg_64_3, var_64_26, arg_64_4, var_64_1, var_64_14, var_64_15, var_64_5, var_64_6, var_64_27)

	arg_64_0._deus_run_controller:register_rpcs(arg_64_0._network_event_delegate)

	local var_64_28 = var_64_0:get_rolled_over_soft_currency()
	local var_64_29 = Managers.backend:player_id() or ""

	arg_64_0._deus_run_controller:setup_run(arg_64_2, arg_64_5, arg_64_6, arg_64_7, var_64_28, var_64_29, arg_64_8, arg_64_9, arg_64_10)
	arg_64_0._deus_run_controller:full_sync()
	arg_64_0:_update_own_avatar_info()

	local var_64_30, var_64_31 = arg_64_0._deus_run_controller:get_player_profile(var_64_1, var_0_4)

	if var_64_30 ~= 0 then
		local var_64_32 = SPProfiles[var_64_30].careers[var_64_31].name

		arg_64_0:_update_career_loadout(var_0_4, var_64_32)
	end

	var_64_0:deus_run_started()
end

function DeusMechanism._update_own_avatar_info(arg_65_0)
	local var_65_0 = arg_65_0._deus_run_controller:get_own_peer_id()
	local var_65_1, var_65_2 = arg_65_0._deus_run_controller:get_player_profile(var_65_0, var_0_4)
	local var_65_3 = Managers.player:local_player()

	if var_65_1 == 0 or not var_65_3 then
		return
	end

	local var_65_4 = SPProfiles[var_65_1]
	local var_65_5 = var_65_4.careers[var_65_2]
	local var_65_6 = var_65_4.display_name
	local var_65_7 = var_65_5.name
	local var_65_8 = ExperienceSettings.get_experience(var_65_6)
	local var_65_9 = ExperienceSettings.get_level(var_65_8)
	local var_65_10 = Application.user_setting("toggle_versus_level_in_all_game_modes") and ExperienceSettings.get_versus_level() or 0
	local var_65_11 = BackendUtils.get_loadout_item(var_65_7, "slot_frame")
	local var_65_12 = var_65_11 and var_65_11.data.name or "default"
	local var_65_13 = var_65_3:name() or ""

	arg_65_0._deus_run_controller:set_own_player_avatar_info(var_65_9, var_65_13, var_65_12, var_65_10)
end

function DeusMechanism.rpc_deus_setup_run(arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6, arg_66_7, arg_66_8, arg_66_9)
	local var_66_0 = NetworkLookup.difficulties[arg_66_4]
	local var_66_1 = NetworkLookup.deus_journeys[arg_66_5]
	local var_66_2 = NetworkLookup.deus_themes[arg_66_6]
	local var_66_3 = CHANNEL_TO_PEER_ID[arg_66_1]
	local var_66_4 = {}

	for iter_66_0 = 1, #arg_66_8 do
		local var_66_5 = arg_66_8[iter_66_0]

		var_66_4[#var_66_4 + 1] = NetworkLookup.mutator_templates[var_66_5]
	end

	local var_66_6 = {}

	for iter_66_1 = 1, #arg_66_9 do
		local var_66_7 = arg_66_9[iter_66_1]
		local var_66_8 = DeusPowerUpsLookup[var_66_7]

		var_66_6[#var_66_6 + 1] = var_66_8.name
	end

	arg_66_0:_setup_run(arg_66_2, arg_66_3, false, var_66_3, var_66_0, var_66_1, var_66_2, arg_66_7, var_66_4, var_66_6)
end

function DeusMechanism.should_play_level_introduction(arg_67_0)
	return false
end

function DeusMechanism.set_vote_data(arg_68_0, arg_68_1)
	arg_68_0._vote_data = arg_68_1
end

function DeusMechanism._get_vote_data(arg_69_0)
	return arg_69_0._vote_data
end

function DeusMechanism.get_loading_tip(arg_70_0)
	local var_70_0 = DLCSettings.morris.loading_tips_file
	local var_70_1 = local_require(var_70_0)
	local var_70_2 = var_70_1[arg_70_0:get_current_node_theme()] or var_70_1.general

	if arg_70_0._state == var_0_10 then
		var_70_2 = var_70_1.general
	end

	return var_70_2[math.random(1, #var_70_2)]
end

function DeusMechanism.post_match(arg_71_0)
	return arg_71_0._post_match
end

function DeusMechanism.get_level_dialogue_context(arg_72_0)
	local var_72_0 = 0
	local var_72_1 = 0
	local var_72_2 = 0
	local var_72_3
	local var_72_4 = false
	local var_72_5 = arg_72_0._deus_run_controller

	if var_72_5 then
		var_72_0 = #var_72_5:get_traversed_nodes() + 1

		local var_72_6 = var_72_5:get_visited_nodes()

		for iter_72_0, iter_72_1 in ipairs(var_72_6) do
			local var_72_7 = var_72_5:get_node(iter_72_1)

			if var_72_7.node_type == "shop" then
				var_72_2 = var_72_2 + 1
			end

			for iter_72_2, iter_72_3 in ipairs(var_72_7.next) do
				if var_72_5:get_node(iter_72_3).node_type == "shop" then
					var_72_1 = var_72_1 + 1

					break
				end
			end
		end

		local var_72_8 = var_72_5:get_current_node().level

		var_72_3 = LevelSettings[var_72_8].theme

		local var_72_9 = var_72_5:get_journey_name()

		var_72_4 = Managers.backend:get_interface("deus"):deus_journey_with_belakor(var_72_9)
	end

	return {
		times_map_visited = var_72_0,
		times_shrine_was_in_range = var_72_1,
		current_theme = var_72_3,
		times_shrine_visited = var_72_2,
		deus_current_curse = arg_72_0:get_current_node_curse(),
		is_final_round = arg_72_0:is_final_round(),
		map_has_belakor = var_72_4
	}
end

function DeusMechanism.is_packages_loaded(arg_73_0)
	if not arg_73_0._deus_run_controller then
		return true
	end

	return arg_73_0._deus_run_controller:is_weekly_event_packages_loaded()
end

function DeusMechanism._update_current_state(arg_74_0, arg_74_1)
	local var_74_0

	if not arg_74_0._deus_run_controller or arg_74_0._deus_run_controller:get_run_ended() then
		var_74_0 = var_0_7
	elseif arg_74_0._deus_run_controller:has_completed_current_node() then
		var_74_0 = var_0_10
	elseif arg_74_0._deus_run_controller:get_current_node().level_type == "SHOP" then
		var_74_0 = var_0_10
	else
		var_74_0 = var_0_12
	end

	Managers.mechanism:choose_next_state(var_74_0)
	Managers.mechanism:progress_state(arg_74_1)
end

function DeusMechanism.get_player_level_fallback(arg_75_0, arg_75_1)
	if arg_75_0._deus_run_controller and arg_75_1 then
		local var_75_0 = arg_75_1.peer_id

		return arg_75_0._deus_run_controller:get_player_level(var_75_0)
	end
end

function DeusMechanism.get_starting_level()
	return var_0_5
end

function DeusMechanism.reserved_party_id_by_peer(arg_77_0, arg_77_1)
	return 1
end

function DeusMechanism.try_reserve_profile_for_peer_by_mechanism(arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4, arg_78_5)
	local var_78_0 = arg_78_0:reserved_party_id_by_peer(arg_78_2)

	return arg_78_1:try_reserve_profile_for_peer(var_78_0, arg_78_2, arg_78_3, arg_78_4)
end

function DeusMechanism.entered_mechanism_due_to_switch(arg_79_0)
	Managers.chat:set_chat_enabled(true)
end
