-- chunkname: @scripts/managers/game_mode/mechanisms/adventure_mechanism.lua

AdventureMechanism = class(AdventureMechanism)
AdventureMechanism.name = "Adventure"

local var_0_0 = require("scripts/settings/live_events_packages")
local var_0_1 = "inn_level"
local var_0_2 = "inn"
local var_0_3 = "inn"
local var_0_4 = "adventure"
local var_0_5 = "ingame"
local var_0_6 = "tutorial"
local var_0_7 = "tutorial"
local var_0_8 = "weave"
local var_0_9 = "weave"

local function var_0_10(arg_1_0)
	local var_1_0 = arg_1_0.mission_id
	local var_1_1 = arg_1_0.difficulty
	local var_1_2 = arg_1_0.quick_game
	local var_1_3 = arg_1_0.private_game
	local var_1_4 = arg_1_0.always_host
	local var_1_5 = arg_1_0.strict_matchmaking
	local var_1_6 = arg_1_0.matchmaking_type
	local var_1_7 = arg_1_0.twitch_enabled

	print("............................................................................................................")
	print("............................................................................................................")
	printf("GAME START SETTINGS -> Level: %s | Difficulty: %s | Private: %s | Always Host: %s | Strict Matchmaking: %s | Quick Game: %s | Matchmaking Type: %s | Twitch: %s", var_1_0 and var_1_0 or "Not specified", var_1_1, var_1_3 and "yes" or "no", var_1_4 and "yes" or "no", var_1_5 and "yes" or "no", var_1_2 and "yes" or "no", var_1_6 or "Not specified", var_1_7 and "Yes" or "No")
	print("............................................................................................................")
	print("............................................................................................................")
end

local var_0_11 = {
	default = function(arg_2_0)
		var_0_10(arg_2_0)

		local var_2_0 = {
			mission_id = arg_2_0.mission_id,
			difficulty = arg_2_0.difficulty,
			quick_game = arg_2_0.quick_game,
			private_game = arg_2_0.private_game,
			always_host = arg_2_0.always_host,
			strict_matchmaking = arg_2_0.strict_matchmaking,
			excluded_level_keys = arg_2_0.excluded_level_keys,
			matchmaking_type = arg_2_0.matchmaking_type,
			mechanism = arg_2_0.mechanism,
			vote_type = arg_2_0.request_type
		}
		local var_2_1 = "game_settings_vote"

		Managers.state.voting:request_vote(var_2_1, var_2_0, Network.peer_id())
	end,
	deed = function(arg_3_0)
		var_0_10(arg_3_0)

		local var_3_0 = Managers.backend:get_interface("items"):get_item_from_id(arg_3_0.deed_backend_id)
		local var_3_1 = var_3_0.data
		local var_3_2 = var_3_0.difficulty
		local var_3_3 = var_3_0.level_key
		local var_3_4 = {
			item_name = var_3_1.name,
			mission_id = var_3_3,
			difficulty = var_3_2,
			excluded_level_keys = arg_3_0.excluded_level_keys,
			matchmaking_type = arg_3_0.matchmaking_type,
			mechanism = arg_3_0.mechanism,
			vote_type = arg_3_0.request_type
		}

		Managers.state.voting:request_vote("game_settings_deed_vote", var_3_4, Network.peer_id())
	end,
	event = function(arg_4_0)
		var_0_10(arg_4_0)

		local var_4_0 = {
			mission_id = arg_4_0.mission_id,
			difficulty = arg_4_0.difficulty,
			quick_game = arg_4_0.quick_game,
			private_game = arg_4_0.private_game,
			always_host = arg_4_0.always_host,
			strict_matchmaking = arg_4_0.strict_matchmaking,
			event_data = arg_4_0.event_data,
			excluded_level_keys = arg_4_0.excluded_level_keys,
			matchmaking_type = arg_4_0.matchmaking_type,
			mechanism = arg_4_0.mechanism,
			vote_type = arg_4_0.request_type
		}

		Managers.state.voting:request_vote("game_settings_event_vote", var_4_0, Network.peer_id())
	end,
	weave_quick_play = function(arg_5_0)
		var_0_10(arg_5_0)

		local var_5_0 = {
			quick_game = true,
			difficulty = arg_5_0.difficulty,
			private_game = arg_5_0.private_game,
			always_host = arg_5_0.always_host,
			matchmaking_type = arg_5_0.matchmaking_type,
			mechanism = arg_5_0.mechanism,
			vote_type = arg_5_0.request_type
		}

		Managers.state.voting:request_vote("game_settings_weave_quick_play_vote", var_5_0, Network.peer_id())
	end,
	weave = function(arg_6_0)
		var_0_10(arg_6_0)

		local var_6_0 = {
			quick_game = false,
			mission_id = arg_6_0.mission_id,
			difficulty = arg_6_0.difficulty,
			objective_index = arg_6_0.objective_index,
			private_game = arg_6_0.private_game,
			always_host = arg_6_0.always_host,
			matchmaking_type = arg_6_0.matchmaking_type,
			mechanism = arg_6_0.mechanism,
			vote_type = arg_6_0.request_type
		}

		Managers.state.voting:request_vote("game_settings_weave_vote", var_6_0, Network.peer_id())
	end
}
local var_0_12 = {
	"rpc_sync_adventure_data_to_peer"
}

function AdventureMechanism.init(arg_7_0, arg_7_1)
	arg_7_0:_reset(arg_7_1)
end

function AdventureMechanism.register_rpcs(arg_8_0, arg_8_1)
	arg_8_0:unregister_rpcs()

	arg_8_0._network_event_delegate = arg_8_1

	arg_8_1:register(arg_8_0, unpack(var_0_12))
end

function AdventureMechanism.unregister_rpcs(arg_9_0)
	if arg_9_0._network_event_delegate then
		arg_9_0._network_event_delegate:unregister(arg_9_0)

		arg_9_0._network_event_delegate = nil
	end
end

function AdventureMechanism.on_venture_start(arg_10_0)
	return
end

function AdventureMechanism.on_venture_end(arg_11_0)
	if arg_11_0._state ~= var_0_9 then
		Managers.weave:clear_weave_name()
		Managers.backend:set_talents_interface_override()
	end
end

function AdventureMechanism.is_venture_over(arg_12_0)
	local var_12_0 = arg_12_0._game_round_ended_reason
	local var_12_1 = var_12_0 == "won" or var_12_0 == "lost"

	if arg_12_0._state == var_0_9 then
		local var_12_2 = not Managers.weave:calculate_next_objective_index()

		return var_12_1 and (var_12_0 == "lost" or var_12_2)
	else
		return var_12_1
	end
end

function AdventureMechanism.handle_ingame_exit(arg_13_0, arg_13_1)
	if arg_13_1 == "join_lobby_failed" or arg_13_1 == "left_game" or arg_13_1 == "lobby_state_failed" or arg_13_1 == "kicked_by_server" or arg_13_1 == "afk_kick" or arg_13_1 == "quit_game" or arg_13_1 == "return_to_pc_menu" then
		arg_13_0:_reset()
	end
end

function AdventureMechanism._reset(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0:get_hub_level_key()
	local var_14_1 = LevelSettings[var_14_0]

	arg_14_0._prior_state = arg_14_2 or arg_14_0._state

	if var_14_1.hub_level then
		arg_14_0._state = var_0_3
	else
		arg_14_0._state = var_0_5
	end

	arg_14_0._next_state = nil
	arg_14_0._saved_game_mode_data = nil
	arg_14_0._hero_profiles = table.clone(PROFILES_BY_AFFILIATION.heroes)
	arg_14_0._tutorial_profiles = table.clone(PROFILES_BY_AFFILIATION.tutorial)
end

function AdventureMechanism.network_context_destroyed(arg_15_0)
	arg_15_0:_reset()
end

function AdventureMechanism.choose_next_state(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._state

	if var_16_0 == var_0_3 or var_16_0 == var_0_7 then
		local var_16_1 = {
			weave = true,
			ingame = true,
			tutorial = true
		}

		fassert(var_16_1[arg_16_1], "State (%s) is not an acceptable transition from current state (%s)", arg_16_1, var_16_0)
	elseif Development.parameter("weave_name") and var_16_0 == "ingame" then
		-- block empty
	else
		ferror("Not allowed to choose next state in current state (%s)", var_16_0)
	end

	arg_16_0._next_state = arg_16_1
end

function AdventureMechanism.reset_choose_next_state(arg_17_0)
	arg_17_0._next_state = nil
end

function AdventureMechanism.progress_state(arg_18_0)
	if arg_18_0._next_state then
		arg_18_0._prior_state = arg_18_0._state
		arg_18_0._state = arg_18_0._next_state
		arg_18_0._next_state = nil
	else
		local var_18_0 = arg_18_0._state

		arg_18_0._prior_state = var_18_0

		if var_18_0 == var_0_3 then
			arg_18_0._state = var_0_5
		elseif var_18_0 == var_0_5 or var_18_0 == var_0_7 then
			arg_18_0._state = var_0_3
		elseif var_18_0 == var_0_9 then
			if not Managers.weave:calculate_next_objective_index() then
				arg_18_0._state = var_0_3
			end
		else
			ferror("AdventureMechanism: unknown state %s", var_18_0)
		end
	end

	return arg_18_0._state
end

function AdventureMechanism.get_prior_state(arg_19_0)
	return arg_19_0._prior_state
end

function AdventureMechanism.set_current_state(arg_20_0, arg_20_1)
	arg_20_0._prior_state = arg_20_0._state
	arg_20_0._state = arg_20_1
end

function AdventureMechanism.get_hub_level_key(arg_21_0)
	return arg_21_0._debug_hub_level_key or AdventureMechanism.get_starting_level()
end

function AdventureMechanism.get_level_seed(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = Managers.weave

	if var_22_0 and var_22_0:get_active_weave() then
		local var_22_1 = var_22_0:get_active_objective_template()

		arg_22_1 = arg_22_2 and var_22_1.system_seeds and var_22_1.system_seeds[arg_22_2] or var_22_1.level_seed or arg_22_1
	end

	return arg_22_1
end

function AdventureMechanism.get_end_of_level_rewards_arguments(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
	local var_23_0 = arg_23_0._current_game_mode == var_0_8
	local var_23_1 = arg_23_3:get_stat(arg_23_4, "kills_total")
	local var_23_2
	local var_23_3
	local var_23_4 = false

	if var_23_0 then
		local var_23_5 = Managers.weave

		var_23_2 = var_23_5:get_weave_tier()
		var_23_3 = var_23_5:current_bar_score()
	elseif arg_23_1 then
		var_23_4 = arg_23_3:get_persistent_stat(arg_23_4, "completed_levels_" .. arg_23_6, arg_23_5) == 1
	end

	local var_23_6 = false
	local var_23_7 = LevelUnlockUtils.current_weave(arg_23_3, arg_23_4, var_23_6)
	local var_23_8 = WeaveSettings.templates[var_23_7]
	local var_23_9 = WeaveSettings.templates_ordered
	local var_23_10 = table.find(var_23_9, var_23_8)
	local var_23_11 = Managers.state.entity:system("mission_system")
	local var_23_12 = var_23_11:get_level_end_mission_data("tome_bonus_mission")
	local var_23_13 = var_23_11:get_level_end_mission_data("grimoire_hidden_mission")
	local var_23_14 = var_23_11:get_level_end_mission_data("bonus_dice_hidden_mission")
	local var_23_15 = var_23_11:get_level_end_mission_data("painting_scrap_hidden_mission")
	local var_23_16 = {
		tome = var_23_12 and var_23_12.current_amount or 0,
		grimoire = var_23_13 and var_23_13.current_amount or 0,
		loot_dice = var_23_14 and var_23_14.current_amount or 0,
		painting_scraps = var_23_15 and var_23_15.current_amount or 0,
		quickplay = arg_23_2,
		game_won = arg_23_1
	}

	return {
		current_weave_index = var_23_10,
		weave_tier = var_23_2,
		weave_progress = var_23_3,
		kill_count = var_23_1,
		chest_upgrade_data = var_23_16,
		first_time_completion = var_23_4
	}
end

function AdventureMechanism.get_end_of_level_extra_mission_results(arg_24_0)
	Managers.state.entity:system("mission_system"):start_mission("players_alive_mission")

	return {}
end

function AdventureMechanism.is_final_round(arg_25_0)
	if arg_25_0._current_game_mode == var_0_8 then
		return not Managers.weave:calculate_next_objective_index()
	end

	return true
end

function AdventureMechanism.get_level_end_view(arg_26_0)
	local var_26_0 = Managers.state.network:lobby():lobby_data("weave_quick_game") == "true"

	if arg_26_0._current_game_mode == var_0_8 and not var_26_0 then
		return "LevelEndViewWeave"
	end

	return "LevelEndView"
end

function AdventureMechanism.get_level_end_view_packages(arg_27_0)
	local var_27_0 = Managers.state.network:lobby():lobby_data("weave_quick_game") == "true"

	if arg_27_0._current_game_mode == var_0_8 and not var_27_0 then
		return {
			"resource_packages/levels/ui_end_screen_victory"
		}
	end

	return {
		"resource_packages/levels/ui_end_screen"
	}
end

function AdventureMechanism.game_round_ended(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	arg_28_0._game_round_ended_reason = arg_28_3

	local var_28_0
	local var_28_1 = arg_28_0._state
	local var_28_2
	local var_28_3
	local var_28_4
	local var_28_5
	local var_28_6
	local var_28_7

	if var_28_1 == var_0_3 then
		var_28_2 = Managers.level_transition_handler:get_next_level_key()
	elseif var_28_1 == var_0_7 then
		var_28_2 = arg_28_0._debug_hub_level_key or AdventureMechanism.get_starting_level()
	elseif var_28_1 == var_0_9 then
		local var_28_8 = Managers.weave
		local var_28_9 = var_28_8:calculate_next_objective_index()

		if var_28_9 and arg_28_3 == "won" then
			local var_28_10 = var_28_8:get_active_weave()
			local var_28_11 = WeaveSettings.templates[var_28_10].objectives[var_28_9]

			var_28_8:set_next_weave(var_28_10)
			var_28_8:set_next_objective(var_28_9)

			var_28_0 = Managers.state.game_mode:get_saved_game_mode_data()

			if var_28_0 then
				for iter_28_0, iter_28_1 in pairs(var_28_0) do
					iter_28_1.spawn_state = nil
					iter_28_1.position = nil
					iter_28_1.rotation = nil
				end
			end

			var_28_2 = var_28_11.level_id
			var_28_3 = var_28_11.conflict_settings
			var_28_4 = Managers.mechanism:generate_level_seed()

			local var_28_12 = Managers.level_transition_handler

			var_28_6 = var_28_12:get_current_difficulty()
			var_28_7 = var_28_12:get_current_difficulty_tweak()
			var_28_5 = var_28_12:get_current_locked_director_functions()
		else
			var_28_2 = AdventureMechanism.debug_hub_level_key or AdventureMechanism.get_starting_level()
			arg_28_0._next_state = var_0_3
		end
	else
		var_28_2 = AdventureMechanism.debug_hub_level_key or AdventureMechanism.get_starting_level()
	end

	if arg_28_3 == "start_game" then
		Managers.level_transition_handler:promote_next_level_data()
	elseif arg_28_3 == "won" or arg_28_3 == "lost" then
		arg_28_0._saved_game_mode_data = var_28_0

		local var_28_13 = LevelHelper:get_environment_variation_id(var_28_2)

		Managers.level_transition_handler:set_next_level(var_28_2, var_28_13, var_28_4, nil, nil, var_28_3, var_28_5, var_28_6, var_28_7)
	elseif arg_28_3 == "reload" then
		local var_28_14 = Managers.mechanism:generate_level_seed()

		Managers.level_transition_handler:reload_level(nil, var_28_14)
		Managers.level_transition_handler:promote_next_level_data()
	else
		fassert(false, "Invalid end reason %q.", tostring(arg_28_3))
	end
end

function AdventureMechanism.should_run_tutorial(arg_29_0)
	return true, var_0_7
end

function AdventureMechanism._get_next_game_mode_key(arg_30_0)
	local var_30_0
	local var_30_1 = arg_30_0._state

	if var_30_1 == var_0_3 then
		local var_30_2 = Managers.level_transition_handler:get_current_level_keys()

		if LevelSettings[var_30_2].hub_level then
			var_30_0 = var_0_2
		else
			var_30_0 = var_0_4
		end
	elseif var_30_1 == var_0_7 then
		var_30_0 = var_0_6
	elseif var_30_1 == var_0_9 then
		var_30_0 = var_0_8
	else
		var_30_0 = var_0_4
	end

	return var_30_0
end

function AdventureMechanism.start_next_round(arg_31_0)
	arg_31_0._game_round_ended_reason = nil

	local var_31_0 = arg_31_0._state

	if var_31_0 == var_0_3 then
		local var_31_1
		local var_31_2 = arg_31_0._prior_state

		arg_31_0:_reset(var_31_1, var_31_2)
	end

	local var_31_3 = arg_31_0:_build_side_compositions(var_31_0)
	local var_31_4 = arg_31_0:_get_next_game_mode_key()

	arg_31_0._current_game_mode = var_31_4

	local var_31_5

	if arg_31_0._saved_game_mode_data then
		var_31_5 = table.clone(arg_31_0._saved_game_mode_data)
	end

	local var_31_6 = {
		game_mode_data = var_31_5
	}

	return var_31_4, var_31_3, var_31_6
end

function AdventureMechanism._build_side_compositions(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0._hero_profiles

	if arg_32_1 == var_0_7 then
		var_32_0 = arg_32_0._tutorial_profiles
	end

	local var_32_1 = Managers.party

	return {
		{
			name = "heroes",
			relations = {
				enemy = {
					"dark_pact"
				}
			},
			party = var_32_1:get_party(1),
			add_these_settings = {
				using_grims_and_tomes = true,
				show_damage_feedback = false,
				using_enemy_recycler = true,
				available_profiles = var_32_0
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

function AdventureMechanism.get_state(arg_33_0)
	return arg_33_0._state
end

function AdventureMechanism.sync_mechanism_data(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = Managers.weave

	if var_34_0 then
		local var_34_1 = var_34_0:get_next_weave()
		local var_34_2 = var_34_0:get_next_objective()
		local var_34_3 = var_34_0:get_active_weave()
		local var_34_4 = var_34_0:get_active_objective()
		local var_34_5 = var_34_1 or var_34_3 or "n/a"
		local var_34_6 = var_34_2 or var_34_4 or 1
		local var_34_7 = NetworkLookup.weave_names[var_34_5]
		local var_34_8 = PEER_ID_TO_CHANNEL[arg_34_1]

		RPC.rpc_sync_adventure_data_to_peer(var_34_8, var_34_7, var_34_6)
	end
end

function AdventureMechanism.rpc_sync_adventure_data_to_peer(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = NetworkLookup.weave_names[arg_35_2]
	local var_35_1 = Managers.weave

	if var_35_0 ~= "n/a" then
		var_35_1:set_next_weave(var_35_0)
		var_35_1:set_next_objective(arg_35_3)
	end
end

function AdventureMechanism.should_play_level_introduction(arg_36_0)
	return true
end

function AdventureMechanism.uses_random_directors(arg_37_0)
	local var_37_0 = Managers.weave:get_next_weave() or Development.parameter("weave_name")

	return not WeaveSettings.templates[var_37_0]
end

function AdventureMechanism.debug_load_level(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = LevelSettings[arg_38_1]
	local var_38_1 = Managers.level_transition_handler

	var_38_1:set_next_level(arg_38_1, arg_38_2)
	var_38_1:promote_next_level_data()

	if var_38_0 and var_38_0.hub_level then
		arg_38_0._next_state = var_0_3
	else
		arg_38_0._next_state = var_0_5
	end

	Managers.mechanism:progress_state()
end

function AdventureMechanism.request_vote(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_1.deed_backend_id

	if var_39_0 then
		Managers.deed:select_deed(var_39_0, Network.peer_id())
	end

	local var_39_1 = var_0_11[arg_39_1.request_type] or var_0_11.default

	if var_39_1 then
		var_39_1(arg_39_1)
	end
end

function AdventureMechanism.override_hub_level(arg_40_0, arg_40_1)
	arg_40_0._debug_hub_level_key = arg_40_1
end

function AdventureMechanism.get_starting_level()
	local var_41_0 = Development.parameter("weave_name")

	if var_41_0 and var_41_0 ~= "false" then
		return WeaveSettings.templates[var_41_0].objectives[1].level_id
	end

	return Managers.backend:get_level_variation_data().hub_level or var_0_1
end

function AdventureMechanism.reserved_party_id_by_peer(arg_42_0, arg_42_1)
	return 1
end

function AdventureMechanism.try_reserve_profile_for_peer_by_mechanism(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	local var_43_0 = arg_43_0:reserved_party_id_by_peer(arg_43_2)

	return arg_43_1:try_reserve_profile_for_peer(var_43_0, arg_43_2, arg_43_3, arg_43_4)
end

function AdventureMechanism.entered_mechanism_due_to_switch(arg_44_0)
	Managers.chat:set_chat_enabled(true)
end
