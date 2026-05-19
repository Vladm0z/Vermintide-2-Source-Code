-- chunkname: @scripts/managers/voting/vote_templates.lua

VoteTemplates = {
	retry_level = {
		priority = 100,
		client_start_vote_rpc = "rpc_server_request_start_vote_peer_id",
		text = "vote_retry_level_title",
		minimum_voter_percent = 1,
		server_start_vote_rpc = "rpc_client_start_vote_peer_id",
		duration = 20,
		vote_options = {
			{
				text = "vote_retry_level_yes",
				vote = 1
			},
			{
				text = "vote_retry_level_no",
				vote = 2
			}
		},
		on_complete = function(arg_1_0, arg_1_1)
			local var_1_0 = Managers.level_transition_handler

			if arg_1_0 == 1 then
				local var_1_1 = Managers.mechanism:generate_level_seed()

				var_1_0:reload_level(nil, var_1_1)
				Managers.level_transition_handler:promote_next_level_data()
			else
				local var_1_2 = Managers.mechanism:game_mechanism():get_hub_level_key()
				local var_1_3 = LevelHelper:get_environment_variation_id(var_1_2)

				var_1_0:set_next_level(var_1_2, var_1_3)
				var_1_0:promote_next_level_data()
			end
		end,
		pack_sync_data = function(arg_2_0)
			return {}
		end,
		extract_sync_data = function(arg_3_0)
			return {}
		end
	},
	return_to_inn = {
		priority = 1000,
		client_start_vote_rpc = "rpc_server_request_start_vote_peer_id",
		text = "n/a",
		minimum_voter_percent = 1,
		server_start_vote_rpc = "rpc_client_start_vote_peer_id",
		duration = 90,
		vote_options = {
			{
				text = "n/a",
				vote = 1
			}
		},
		on_complete = function(arg_4_0, arg_4_1)
			local var_4_0 = Managers.mechanism:game_mechanism():get_hub_level_key()

			Managers.state.game_mode:start_specific_level(var_4_0, 0)
		end,
		pack_sync_data = function(arg_5_0)
			return {}
		end,
		extract_sync_data = function(arg_6_0)
			return {}
		end
	},
	continue_level = {
		priority = 100,
		client_start_vote_rpc = "rpc_server_request_start_vote_peer_id",
		text = "vote_retry_level_title",
		minimum_voter_percent = 1,
		server_start_vote_rpc = "rpc_client_start_vote_peer_id",
		duration = 20,
		vote_options = {
			{
				text = "vote_retry_level_continue",
				vote = 1
			},
			{
				text = "vote_retry_level_restart",
				vote = 2
			},
			{
				text = "vote_retry_level_cancel",
				vote = 3
			}
		},
		on_complete = function(arg_7_0, arg_7_1)
			local var_7_0 = Managers.level_transition_handler
			local var_7_1 = Managers.mechanism:generate_level_seed()

			if arg_7_0 == 1 then
				local var_7_2 = Managers.state.spawn:checkpoint_data()

				var_7_0:reload_level(var_7_2, var_7_1)
				Managers.level_transition_handler:promote_next_level_data()
			elseif arg_7_0 == 2 then
				var_7_0:reload_level(nil, var_7_1)
				Managers.level_transition_handler:promote_next_level_data()
			else
				Managers.state.event:trigger("checkpoint_vote_cancelled")
			end
		end,
		pack_sync_data = function(arg_8_0)
			return {}
		end,
		extract_sync_data = function(arg_9_0)
			return {}
		end
	},
	kick_player = {
		client_start_vote_rpc = "rpc_server_request_start_vote_peer_id",
		priority = 10,
		ingame_vote = true,
		min_required_voters = 3,
		text = "input_description_vote_kick_player",
		minimum_voter_percent = 1,
		success_percent = 0.51,
		server_start_vote_rpc = "rpc_client_start_vote_peer_id",
		duration = 30,
		vote_options = {
			{
				text = "vote_kick_player_option_yes",
				vote = 1,
				input_hold_time = 1,
				gamepad_input = "ingame_vote_yes",
				input = "ingame_vote_yes"
			},
			{
				text = "vote_kick_player_option_no",
				input_hold_time = 1,
				vote = 2,
				input = "ingame_vote_no"
			}
		},
		on_complete = function(arg_10_0, arg_10_1, arg_10_2)
			if arg_10_0 == 1 then
				arg_10_1.network_server:kick_peer(arg_10_2.kick_peer_id)
			end
		end,
		pack_sync_data = function(arg_11_0)
			return {
				arg_11_0.voter_peer_id,
				arg_11_0.kick_peer_id
			}
		end,
		extract_sync_data = function(arg_12_0)
			local var_12_0 = arg_12_0[1]
			local var_12_1 = arg_12_0[2]

			return {
				voter_peer_id = var_12_0,
				kick_peer_id = var_12_1
			}
		end,
		modify_title_text = function(arg_13_0, arg_13_1)
			local var_13_0 = Managers.player:player_from_peer_id(arg_13_1.kick_peer_id)
			local var_13_1 = var_13_0 and var_13_0:name() or "n/a"

			return sprintf("%s\n%s", arg_13_0, tostring(var_13_1))
		end,
		initial_vote_func = function(arg_14_0)
			return {
				[arg_14_0.voter_peer_id] = 1,
				[arg_14_0.kick_peer_id] = 2
			}
		end,
		can_start_vote = function(arg_15_0)
			if arg_15_0 and Managers.player:player_from_peer_id(arg_15_0.kick_peer_id) then
				return true
			end

			return false
		end
	},
	afk_kick = {
		client_start_vote_rpc = "rpc_server_request_start_vote_peer_id",
		priority = 10,
		ingame_vote = true,
		min_required_voters = 2,
		text = "afk_vote_kick_player",
		minimum_voter_percent = 1,
		success_percent = 0.51,
		server_start_vote_rpc = "rpc_client_start_vote_peer_id",
		duration = 30,
		vote_options = {
			{
				text = "vote_kick_player_yes",
				vote = 1,
				input = "ingame_vote_yes"
			},
			{
				text = "vote_kick_player_no",
				vote = 2,
				input = "ingame_vote_no"
			}
		},
		on_complete = function(arg_16_0, arg_16_1, arg_16_2)
			if arg_16_0 == 1 then
				arg_16_1.network_server:kick_peer(arg_16_2.kick_peer_id)
			end
		end,
		pack_sync_data = function(arg_17_0)
			return {
				arg_17_0.voter_peer_id,
				arg_17_0.kick_peer_id
			}
		end,
		extract_sync_data = function(arg_18_0)
			local var_18_0 = arg_18_0[1]
			local var_18_1 = arg_18_0[2]

			return {
				voter_peer_id = var_18_0,
				kick_peer_id = var_18_1
			}
		end,
		modify_title_text = function(arg_19_0, arg_19_1)
			local var_19_0 = Managers.player:player_from_peer_id(arg_19_1.kick_peer_id):name()

			return sprintf("%s\n%s", arg_19_0, tostring(var_19_0))
		end
	},
	vote_for_level = {
		client_start_vote_rpc = "rpc_server_request_start_vote_peer_id",
		priority = 110,
		ingame_vote = false,
		min_required_voters = 1,
		text = "vote_for_next_level",
		minimum_voter_percent = 1,
		success_percent = 1,
		server_start_vote_rpc = "rpc_client_start_vote_peer_id",
		duration = 300,
		start_sound_event = "hud_dice_game_reward_sound",
		vote_options = {
			{
				text = "popup_choice_accept",
				vote = 1,
				input = "ingame_vote_yes"
			},
			{
				text = "dlc1_3_1_decline",
				vote = 2,
				input = "ingame_vote_no"
			}
		},
		on_complete = function(arg_20_0, arg_20_1, arg_20_2)
			if arg_20_0 == 1 then
				local var_20_0 = arg_20_2.level_key

				Managers.state.game_mode:start_specific_level(var_20_0)
			end
		end,
		pack_sync_data = function(arg_21_0)
			return {
				arg_21_0.voter_peer_id,
				NetworkLookup.mission_ids[arg_21_0.level_key]
			}
		end,
		extract_sync_data = function(arg_22_0)
			local var_22_0 = arg_22_0[1]
			local var_22_1 = NetworkLookup.mission_ids[tonumber(arg_22_0[2])]

			return {
				voter_peer_id = var_22_0,
				level_key = var_22_1
			}
		end
	},
	game_settings_vote = {
		client_start_vote_rpc = "rpc_server_request_start_vote_lookup",
		ingame_vote = false,
		mission_vote = true,
		gamepad_support = true,
		text = "game_settings_vote",
		minimum_voter_percent = 1,
		success_percent = 1,
		server_start_vote_rpc = "rpc_client_start_vote_lookup",
		duration = 30,
		priority = 110,
		min_required_voters = 1,
		gamepad_input_desc = "default_voting",
		timeout_vote_option = 2,
		requirement_failed_message_func = function(arg_23_0)
			local var_23_0 = Localize("vote_requirement_failed")
			local var_23_1 = Managers.player

			for iter_23_0, iter_23_1 in pairs(arg_23_0.results) do
				if not iter_23_1 then
					local var_23_2 = var_23_1:player_from_peer_id(iter_23_0):name()

					var_23_0 = var_23_0 .. var_23_2 .. "\n"
				end
			end

			return var_23_0
		end,
		vote_options = {
			{
				text = "popup_choice_accept",
				gamepad_input = "confirm",
				vote = 1,
				input = "ingame_vote_yes"
			},
			{
				text = "dlc1_3_1_decline",
				gamepad_input = "back",
				vote = 2,
				input = "ingame_vote_no"
			}
		},
		on_start = function(arg_24_0, arg_24_1)
			Managers.matchmaking:cancel_matchmaking()
		end,
		on_complete = function(arg_25_0, arg_25_1, arg_25_2)
			if arg_25_0 == 1 then
				local var_25_0 = arg_25_2.mission_id
				local var_25_1 = arg_25_2.difficulty
				local var_25_2 = arg_25_2.quick_game
				local var_25_3 = arg_25_2.private_game
				local var_25_4 = arg_25_2.always_host
				local var_25_5 = arg_25_2.strict_matchmaking
				local var_25_6 = arg_25_2.matchmaking_type
				local var_25_7 = arg_25_2.excluded_level_keys
				local var_25_8 = arg_25_2.mechanism
				local var_25_9 = arg_25_2.vote_type
				local var_25_10 = {
					dedicated_server = false,
					join_method = "solo",
					mission_id = var_25_0,
					difficulty = var_25_1,
					quick_game = var_25_2,
					private_game = var_25_3,
					always_host = var_25_4,
					strict_matchmaking = var_25_5,
					matchmaking_type = var_25_6,
					excluded_level_keys = var_25_7,
					mechanism = var_25_8
				}

				if (Managers.twitch:is_connecting() or Managers.twitch:is_connected()) and not Managers.twitch:game_mode_supported(var_25_9, var_25_1) then
					Managers.twitch:disconnect()
				end

				Managers.mechanism:reset_choose_next_state()
				Managers.matchmaking:find_game(var_25_10)
			end
		end,
		pack_sync_data = function(arg_26_0)
			local var_26_0 = arg_26_0.mission_id or "n/a"
			local var_26_1 = arg_26_0.act_key or "n/a"
			local var_26_2 = arg_26_0.difficulty
			local var_26_3 = arg_26_0.quick_game
			local var_26_4 = arg_26_0.private_game
			local var_26_5 = arg_26_0.always_host
			local var_26_6 = arg_26_0.strict_matchmaking
			local var_26_7 = arg_26_0.matchmaking_type
			local var_26_8 = Managers.twitch and Managers.twitch:is_connected()
			local var_26_9 = arg_26_0.mechanism

			return {
				NetworkLookup.mission_ids[var_26_0],
				NetworkLookup.act_keys[var_26_1],
				NetworkLookup.difficulties[var_26_2],
				var_26_3 and 1 or 2,
				var_26_4 and 1 or 2,
				var_26_5 and 1 or 2,
				var_26_6 and 1 or 2,
				NetworkLookup.matchmaking_types[var_26_7],
				var_26_8 and 1 or 2,
				NetworkLookup.mechanisms[var_26_9]
			}
		end,
		extract_sync_data = function(arg_27_0)
			local var_27_0 = arg_27_0[1]
			local var_27_1 = arg_27_0[2]
			local var_27_2 = arg_27_0[3]
			local var_27_3 = arg_27_0[4]
			local var_27_4 = arg_27_0[5]
			local var_27_5 = arg_27_0[6]
			local var_27_6 = arg_27_0[7]
			local var_27_7 = arg_27_0[8]
			local var_27_8 = arg_27_0[9]
			local var_27_9 = arg_27_0[10]
			local var_27_10 = NetworkLookup.mission_ids[var_27_0]

			if var_27_10 == "n/a" then
				var_27_10 = nil
			end

			local var_27_11 = NetworkLookup.act_keys[var_27_1]

			if var_27_11 == "n/a" then
				var_27_11 = nil
			end

			local var_27_12 = NetworkLookup.difficulties[var_27_2]
			local var_27_13 = NetworkLookup.matchmaking_types[var_27_7]
			local var_27_14 = NetworkLookup.mechanisms[var_27_9]

			return {
				mission_id = var_27_10,
				act_key = var_27_11,
				difficulty = var_27_12,
				quick_game = var_27_3 == 1 and true or false,
				private_game = var_27_4 == 1 and true or false,
				always_host = var_27_5 == 1 and true or false,
				strict_matchmaking = var_27_6 == 1 and true or false,
				matchmaking_type = var_27_13,
				twitch_enabled = var_27_8 == 1 and true or false,
				mechanism = var_27_14
			}
		end,
		initial_vote_func = function(arg_28_0)
			return {
				[arg_28_0.voter_peer_id] = 1
			}
		end
	},
	game_settings_deed_vote = {
		client_start_vote_rpc = "rpc_server_request_start_vote_deed",
		ingame_vote = false,
		mission_vote = true,
		gamepad_support = true,
		text = "game_settings_deed_vote",
		minimum_voter_percent = 1,
		success_percent = 1,
		server_start_vote_rpc = "rpc_client_start_vote_deed",
		duration = 30,
		priority = 110,
		min_required_voters = 1,
		gamepad_input_desc = "default_voting",
		timeout_vote_option = 2,
		requirement_failed_message_func = function(arg_29_0)
			local var_29_0 = Localize("vote_requirement_failed")
			local var_29_1 = Managers.player

			for iter_29_0, iter_29_1 in pairs(arg_29_0.results) do
				if not iter_29_1 then
					local var_29_2 = var_29_1:player_from_peer_id(iter_29_0):name()

					var_29_0 = var_29_0 .. var_29_2 .. "\n"
				end
			end

			return var_29_0
		end,
		vote_options = {
			{
				text = "popup_choice_accept",
				gamepad_input = "confirm",
				vote = 1,
				input = "ingame_vote_yes"
			},
			{
				text = "dlc1_3_1_decline",
				gamepad_input = "back",
				vote = 2,
				input = "ingame_vote_no"
			}
		},
		on_start = function(arg_30_0, arg_30_1)
			Managers.matchmaking:cancel_matchmaking()
		end,
		on_complete = function(arg_31_0, arg_31_1, arg_31_2)
			if arg_31_0 == 1 then
				local var_31_0 = arg_31_2.mission_id
				local var_31_1 = arg_31_2.difficulty
				local var_31_2 = true
				local var_31_3 = false
				local var_31_4 = "deed"
				local var_31_5 = arg_31_2.mechanism
				local var_31_6 = arg_31_2.vote_type
				local var_31_7 = {
					dedicated_server = false,
					join_method = "solo",
					mission_id = var_31_0,
					difficulty = var_31_1,
					private_game = var_31_2,
					quick_game = var_31_3,
					matchmaking_type = var_31_4,
					mechanism = var_31_5
				}

				if (Managers.twitch:is_connecting() or Managers.twitch:is_connected()) and not Managers.twitch:game_mode_supported(var_31_6, var_31_1) then
					Managers.twitch:disconnect()
				end

				Managers.mechanism:reset_choose_next_state()
				Managers.matchmaking:find_game(var_31_7)
			else
				Managers.deed:reset()
			end
		end,
		pack_sync_data = function(arg_32_0)
			local var_32_0 = arg_32_0.item_name
			local var_32_1 = arg_32_0.mission_id
			local var_32_2 = arg_32_0.difficulty
			local var_32_3 = Managers.twitch and Managers.twitch:is_connected()
			local var_32_4 = arg_32_0.mechanism

			return {
				NetworkLookup.item_names[var_32_0],
				NetworkLookup.mission_ids[var_32_1],
				NetworkLookup.difficulties[var_32_2],
				var_32_3 and 1 or 2,
				NetworkLookup.mechanisms[var_32_4]
			}
		end,
		extract_sync_data = function(arg_33_0)
			local var_33_0 = arg_33_0[1]
			local var_33_1 = arg_33_0[2]
			local var_33_2 = arg_33_0[3]
			local var_33_3 = arg_33_0[4]
			local var_33_4 = arg_33_0[5]
			local var_33_5 = NetworkLookup.item_names[var_33_0]
			local var_33_6 = NetworkLookup.mission_ids[var_33_1]

			if var_33_6 == "n/a" then
				var_33_6 = nil
			end

			local var_33_7 = NetworkLookup.difficulties[var_33_2]

			return {
				matchmaking_type = "deed",
				item_name = var_33_5,
				mission_id = var_33_6,
				difficulty = var_33_7,
				twitch_enabled = var_33_3 == 1 and true or false,
				mechanism = NetworkLookup.mechanisms[var_33_4]
			}
		end,
		initial_vote_func = function(arg_34_0)
			return {
				[arg_34_0.voter_peer_id] = 1
			}
		end
	},
	game_settings_event_vote = {
		client_start_vote_rpc = "rpc_server_request_start_vote_lookup",
		ingame_vote = false,
		mission_vote = true,
		gamepad_support = true,
		text = "game_settings_event_vote",
		minimum_voter_percent = 1,
		success_percent = 1,
		server_start_vote_rpc = "rpc_client_start_vote_lookup",
		duration = 30,
		priority = 110,
		min_required_voters = 1,
		gamepad_input_desc = "default_voting",
		timeout_vote_option = 2,
		requirement_failed_message_func = function(arg_35_0)
			local var_35_0 = Localize("vote_requirement_failed")
			local var_35_1 = Managers.player

			for iter_35_0, iter_35_1 in pairs(arg_35_0.results) do
				if not iter_35_1 then
					local var_35_2 = var_35_1:player_from_peer_id(iter_35_0):name()

					var_35_0 = var_35_0 .. var_35_2 .. "\n"
				end
			end

			return var_35_0
		end,
		vote_options = {
			{
				text = "popup_choice_accept",
				gamepad_input = "confirm",
				vote = 1,
				input = "ingame_vote_yes"
			},
			{
				text = "dlc1_3_1_decline",
				gamepad_input = "back",
				vote = 2,
				input = "ingame_vote_no"
			}
		},
		on_start = function(arg_36_0, arg_36_1)
			Managers.matchmaking:cancel_matchmaking()
		end,
		on_complete = function(arg_37_0, arg_37_1, arg_37_2)
			if arg_37_0 == 1 then
				local var_37_0 = arg_37_2.mission_id
				local var_37_1 = arg_37_2.difficulty
				local var_37_2 = false
				local var_37_3 = false
				local var_37_4 = "event"
				local var_37_5 = arg_37_2.mechanism
				local var_37_6 = arg_37_2.vote_type
				local var_37_7 = {
					dedicated_server = false,
					join_method = "solo",
					mission_id = var_37_0,
					difficulty = var_37_1,
					quick_game = var_37_3,
					private_game = var_37_2,
					matchmaking_type = var_37_4,
					mechanism = var_37_5
				}

				if (Managers.twitch:is_connecting() or Managers.twitch:is_connected()) and not Managers.twitch:game_mode_supported(var_37_6, var_37_1) then
					Managers.twitch:disconnect()
				end

				Managers.mechanism:reset_choose_next_state()

				local var_37_8 = arg_37_2.event_data
				local var_37_9 = Managers.matchmaking

				var_37_9:find_game(var_37_7)
				var_37_9:set_game_mode_event_data(var_37_8)
			end
		end,
		pack_sync_data = function(arg_38_0)
			local var_38_0 = arg_38_0.mission_id or "n/a"
			local var_38_1 = arg_38_0.difficulty
			local var_38_2 = arg_38_0.event_data.mutators
			local var_38_3 = Managers.twitch and Managers.twitch:is_connected()
			local var_38_4 = arg_38_0.mechanism
			local var_38_5 = {
				NetworkLookup.mission_ids[var_38_0],
				NetworkLookup.difficulties[var_38_1],
				var_38_3 and 1 or 2,
				NetworkLookup.mechanisms[var_38_4]
			}

			for iter_38_0 = 1, #var_38_2 do
				local var_38_6 = var_38_2[iter_38_0]
				local var_38_7 = NetworkLookup.mutator_templates[var_38_6]

				var_38_5[#var_38_5 + 1] = var_38_7
			end

			return var_38_5
		end,
		extract_sync_data = function(arg_39_0)
			local var_39_0 = arg_39_0[1]
			local var_39_1 = arg_39_0[2]
			local var_39_2 = arg_39_0[3]
			local var_39_3 = arg_39_0[4]
			local var_39_4 = {}

			for iter_39_0 = 5, #arg_39_0 do
				local var_39_5 = arg_39_0[iter_39_0]

				var_39_4[#var_39_4 + 1] = NetworkLookup.mutator_templates[var_39_5]
			end

			local var_39_6 = NetworkLookup.mission_ids[var_39_0]

			if var_39_6 == "n/a" then
				var_39_6 = nil
			end

			local var_39_7 = NetworkLookup.difficulties[var_39_1]
			local var_39_8 = NetworkLookup.mechanisms[var_39_3]

			return {
				matchmaking_type = "event",
				mission_id = var_39_6,
				difficulty = var_39_7,
				event_data = {
					mutators = var_39_4
				},
				twitch_enabled = var_39_2 == 1 and true or false,
				mechanism = var_39_8
			}
		end,
		initial_vote_func = function(arg_40_0)
			return {
				[arg_40_0.voter_peer_id] = 1
			}
		end
	},
	game_settings_weave_vote = {
		client_start_vote_rpc = "rpc_server_request_start_vote_lookup",
		ingame_vote = false,
		mission_vote = true,
		gamepad_support = true,
		text = "game_settings_weave_vote",
		minimum_voter_percent = 1,
		success_percent = 1,
		server_start_vote_rpc = "rpc_client_start_vote_lookup",
		duration = 30,
		priority = 110,
		min_required_voters = 1,
		gamepad_input_desc = "default_voting",
		timeout_vote_option = 2,
		requirement_failed_message_func = function(arg_41_0)
			local var_41_0 = Localize("vote_weave_requirement_failed")
			local var_41_1 = Managers.player

			for iter_41_0, iter_41_1 in pairs(arg_41_0.results) do
				if not iter_41_1 then
					local var_41_2 = var_41_1:player_from_peer_id(iter_41_0):name()

					var_41_0 = var_41_0 .. var_41_2 .. "\n"
				end
			end

			return var_41_0
		end,
		vote_options = {
			{
				text = "popup_choice_accept",
				gamepad_input = "confirm",
				vote = 1,
				input = "ingame_vote_yes"
			},
			{
				text = "dlc1_3_1_decline",
				gamepad_input = "back",
				vote = 2,
				input = "ingame_vote_no"
			}
		},
		can_start_vote = function(arg_42_0)
			if not Managers.player.is_server then
				return true
			end

			local var_42_0 = ""
			local var_42_1 = MechanismSettings.weave
			local var_42_2 = Managers.player:human_players()
			local var_42_3 = Managers.player:statistics_db()

			for iter_42_0, iter_42_1 in pairs(var_42_2) do
				local var_42_4 = iter_42_1:stats_id()

				if not var_42_1.extra_requirements_function(var_42_3, var_42_4) then
					var_42_0 = var_42_0 .. iter_42_1:name() .. "\n"
				end
			end

			if #var_42_0 > 0 then
				local var_42_5 = Localize("vote_game_mode_requirement_failed")
				local var_42_6 = string.format(var_42_5, var_42_0)

				return false, var_42_6
			else
				return true
			end
		end,
		on_start = function(arg_43_0, arg_43_1)
			Managers.matchmaking:cancel_matchmaking()
		end,
		on_complete = function(arg_44_0, arg_44_1, arg_44_2)
			if arg_44_0 == 1 then
				local var_44_0 = arg_44_2.mission_id
				local var_44_1 = arg_44_2.objective_index
				local var_44_2 = WeaveSettings.templates[var_44_0].difficulty_key
				local var_44_3 = arg_44_2.private_game
				local var_44_4 = arg_44_2.always_host
				local var_44_5 = false
				local var_44_6 = arg_44_2.matchmaking_type
				local var_44_7 = arg_44_2.mechanism
				local var_44_8 = {
					dedicated_server = false,
					mission_id = var_44_0,
					difficulty = var_44_2,
					private_game = var_44_3,
					always_host = var_44_4,
					quick_game = var_44_5,
					matchmaking_type = var_44_6,
					mechanism = var_44_7
				}

				Managers.mechanism:choose_next_state("weave")
				Managers.weave:set_next_weave(var_44_0)
				Managers.weave:set_next_objective(var_44_1)
				Managers.matchmaking:find_game(var_44_8)
			end
		end,
		pack_sync_data = function(arg_45_0)
			local var_45_0 = arg_45_0.mission_id
			local var_45_1 = arg_45_0.objective_index
			local var_45_2 = arg_45_0.private_game
			local var_45_3 = arg_45_0.mechanism
			local var_45_4 = arg_45_0.matchmaking_type

			return {
				NetworkLookup.mission_ids[var_45_0],
				var_45_1,
				var_45_2 and 1 or 2,
				NetworkLookup.mechanisms[var_45_3],
				NetworkLookup.matchmaking_types[var_45_4]
			}
		end,
		extract_sync_data = function(arg_46_0)
			local var_46_0 = arg_46_0[1]
			local var_46_1 = NetworkLookup.mission_ids[var_46_0]
			local var_46_2 = arg_46_0[2]
			local var_46_3 = WeaveSettings.templates[var_46_1].difficulty_key
			local var_46_4 = arg_46_0[3] == 1 and true or false
			local var_46_5 = arg_46_0[4]
			local var_46_6 = NetworkLookup.mechanisms[var_46_5]
			local var_46_7 = arg_46_0[5]
			local var_46_8 = NetworkLookup.matchmaking_types[var_46_7]

			return {
				mission_id = var_46_1,
				difficulty = var_46_3,
				objective_index = var_46_2,
				matchmaking_type = var_46_8,
				private_game = var_46_4,
				mechanism = var_46_6
			}
		end,
		initial_vote_func = function(arg_47_0)
			return {
				[arg_47_0.voter_peer_id] = 1
			}
		end
	},
	game_settings_join_weave_vote = {
		client_start_vote_rpc = "rpc_server_request_start_vote_lookup",
		ingame_vote = false,
		mission_vote = true,
		gamepad_support = true,
		text = "game_settings_join_weave_vote",
		minimum_voter_percent = 1,
		success_percent = 1,
		server_start_vote_rpc = "rpc_client_start_vote_lookup",
		duration = 30,
		priority = 110,
		min_required_voters = 1,
		gamepad_input_desc = "default_voting",
		timeout_vote_option = 2,
		vote_options = {
			{
				text = "popup_choice_accept",
				gamepad_input = "confirm",
				vote = 1,
				input = "ingame_vote_yes"
			},
			{
				text = "matchmaking_suffix_continue_searching",
				gamepad_input = "back",
				vote = 2,
				input = "ingame_vote_no"
			}
		},
		on_start = function(arg_48_0, arg_48_1)
			return
		end,
		on_complete = function(arg_49_0, arg_49_1, arg_49_2)
			if arg_49_0 == 1 then
				local var_49_0 = arg_49_2.mission_id
				local var_49_1 = arg_49_2.objective_index
				local var_49_2 = WeaveSettings.templates[var_49_0].difficulty_key
				local var_49_3 = false
				local var_49_4 = false
				local var_49_5 = "custom"
				local var_49_6 = arg_49_2.mechanism
				local var_49_7 = {
					dedicated_server = false,
					mission_id = var_49_0,
					difficulty = var_49_2,
					private_game = var_49_3,
					quick_game = var_49_4,
					matchmaking_type = var_49_5,
					mechanism = mechanism
				}

				Managers.matchmaking:weave_vote_result(true)
			else
				Managers.matchmaking:weave_vote_result(false)
			end
		end,
		pack_sync_data = function(arg_50_0)
			local var_50_0 = arg_50_0.mission_id
			local var_50_1 = arg_50_0.objective_index
			local var_50_2 = arg_50_0.mechanism

			return {
				NetworkLookup.weave_names[var_50_0],
				var_50_1,
				NetworkLookup.mechanisms[var_50_2]
			}
		end,
		extract_sync_data = function(arg_51_0)
			local var_51_0 = arg_51_0[1]
			local var_51_1 = NetworkLookup.weave_names[var_51_0]
			local var_51_2 = arg_51_0[2]
			local var_51_3 = WeaveSettings.templates[var_51_1].difficulty_key
			local var_51_4 = arg_51_0[3]
			local var_51_5 = NetworkLookup.mechanisms[var_51_4]

			return {
				matchmaking_type = "custom",
				mission_id = var_51_1,
				difficulty = var_51_3,
				objective_index = var_51_2,
				mechanism = var_51_5
			}
		end,
		initial_vote_func = function(arg_52_0)
			return {}
		end
	},
	game_settings_weave_quick_play_vote = {
		client_start_vote_rpc = "rpc_server_request_start_vote_lookup",
		ingame_vote = false,
		mission_vote = true,
		gamepad_support = true,
		text = "game_settings_weave_vote",
		minimum_voter_percent = 1,
		success_percent = 1,
		server_start_vote_rpc = "rpc_client_start_vote_lookup",
		duration = 30,
		priority = 110,
		min_required_voters = 1,
		gamepad_input_desc = "default_voting",
		timeout_vote_option = 2,
		requirement_failed_message_func = function(arg_53_0)
			local var_53_0 = Localize("vote_weave_requirement_failed")
			local var_53_1 = Managers.player

			for iter_53_0, iter_53_1 in pairs(arg_53_0.results) do
				if not iter_53_1 then
					local var_53_2 = var_53_1:player_from_peer_id(iter_53_0):name()

					var_53_0 = var_53_0 .. var_53_2 .. "\n"
				end
			end

			return var_53_0
		end,
		vote_options = {
			{
				text = "popup_choice_accept",
				gamepad_input = "confirm",
				vote = 1,
				input = "ingame_vote_yes"
			},
			{
				text = "dlc1_3_1_decline",
				gamepad_input = "back",
				vote = 2,
				input = "ingame_vote_no"
			}
		},
		can_start_vote = function(arg_54_0)
			if not Managers.player.is_server then
				return true
			end

			local var_54_0 = ""
			local var_54_1 = MechanismSettings.weave
			local var_54_2 = Managers.player:human_players()
			local var_54_3 = Managers.player:statistics_db()

			for iter_54_0, iter_54_1 in pairs(var_54_2) do
				local var_54_4 = iter_54_1:stats_id()

				if not var_54_1.extra_requirements_function(var_54_3, var_54_4) then
					var_54_0 = var_54_0 .. iter_54_1:name() .. "\n"
				end
			end

			if #var_54_0 > 0 then
				local var_54_5 = Localize("vote_game_mode_requirement_failed")
				local var_54_6 = string.format(var_54_5, var_54_0)

				return false, var_54_6
			else
				return true
			end
		end,
		on_start = function(arg_55_0, arg_55_1)
			Managers.matchmaking:cancel_matchmaking()
		end,
		on_complete = function(arg_56_0, arg_56_1, arg_56_2)
			if arg_56_0 == 1 then
				local var_56_0 = arg_56_2.difficulty
				local var_56_1 = arg_56_2.always_host
				local var_56_2 = arg_56_2.private_game
				local var_56_3 = arg_56_2.mechanism
				local var_56_4 = arg_56_2.matchmaking_type
				local var_56_5 = {
					any_level = true,
					quick_game = true,
					dedicated_server = false,
					difficulty = var_56_0,
					always_host = var_56_1,
					matchmaking_type = var_56_4,
					private_game = var_56_2,
					mechanism = var_56_3
				}

				Managers.mechanism:choose_next_state("weave")
				Managers.matchmaking:find_game(var_56_5)
			end
		end,
		pack_sync_data = function(arg_57_0)
			local var_57_0 = arg_57_0.difficulty
			local var_57_1 = arg_57_0.mechanism
			local var_57_2 = arg_57_0.matchmaking_type

			return {
				NetworkLookup.difficulties[var_57_0],
				NetworkLookup.mechanisms[var_57_1],
				NetworkLookup.matchmaking_types[var_57_2]
			}
		end,
		extract_sync_data = function(arg_58_0)
			local var_58_0 = arg_58_0[1]
			local var_58_1 = NetworkLookup.difficulties[var_58_0]
			local var_58_2 = arg_58_0[2]
			local var_58_3 = NetworkLookup.mechanisms[var_58_2]
			local var_58_4 = arg_58_0[3]
			local var_58_5 = NetworkLookup.matchmaking_types[var_58_4]

			return {
				private_game = false,
				dedicated_server = false,
				quick_game = true,
				always_host = false,
				difficulty = var_58_1,
				matchmaking_type = var_58_5,
				mechanism = var_58_3
			}
		end,
		initial_vote_func = function(arg_59_0)
			return {
				[arg_59_0.voter_peer_id] = 1
			}
		end
	},
	game_settings_vote_switch_mechanism = {
		mission_vote = true,
		cancel_disabled = true,
		ingame_vote = false,
		client_start_vote_rpc = "rpc_server_request_start_vote_lookup",
		gamepad_support = true,
		text = "vote_switch_mechanism",
		minimum_voter_percent = 1,
		success_percent = 1,
		server_start_vote_rpc = "rpc_client_start_vote_lookup",
		duration = 30,
		priority = 110,
		min_required_voters = 1,
		gamepad_input_desc = "default_voting",
		timeout_vote_option = 2,
		requirement_failed_message_func = function(arg_60_0)
			local var_60_0 = Localize("vote_requirement_failed")
			local var_60_1 = Managers.player

			for iter_60_0, iter_60_1 in pairs(arg_60_0.results) do
				if not iter_60_1 then
					local var_60_2 = var_60_1:player_from_peer_id(iter_60_0):name()

					var_60_0 = var_60_0 .. var_60_2 .. "\n"
				end
			end

			return var_60_0
		end,
		vote_options = {
			{
				text = "popup_choice_accept",
				gamepad_input = "confirm",
				vote = 1,
				input = "ingame_vote_yes"
			},
			{
				text = "dlc1_3_1_decline",
				gamepad_input = "back",
				vote = 2,
				input = "ingame_vote_no"
			}
		},
		can_start_vote = function(arg_61_0)
			local var_61_0 = true

			if Managers.player.is_server then
				var_61_0 = Managers.state.network.network_server:are_all_peers_ingame(nil, true)
			end

			if not var_61_0 then
				local var_61_1 = 1
				local var_61_2 = ""
				local var_61_3 = true
				local var_61_4 = false
				local var_61_5 = "map_confirm_button_disabled_tooltip_players_joining"

				Managers.chat:send_system_chat_message(1, var_61_5, var_61_2, var_61_4, var_61_3)
			end

			return var_61_0
		end,
		on_start = function(arg_62_0, arg_62_1)
			Managers.matchmaking:cancel_matchmaking()
		end,
		on_complete = function(arg_63_0, arg_63_1, arg_63_2)
			if arg_63_0 == 1 then
				local var_63_0 = arg_63_2.level_key
				local var_63_1 = Managers.level_transition_handler

				var_63_1:set_next_level(var_63_0)
				var_63_1:promote_next_level_data()
			end
		end,
		pack_sync_data = function(arg_64_0)
			local var_64_0 = arg_64_0.level_key
			local var_64_1 = arg_64_0.mechanism

			return {
				NetworkLookup.mission_ids[var_64_0],
				NetworkLookup.mechanism_keys[var_64_1]
			}
		end,
		extract_sync_data = function(arg_65_0)
			local var_65_0 = arg_65_0[1]
			local var_65_1 = arg_65_0[2]

			return {
				switch_mechanism = true,
				level_key = NetworkLookup.mission_ids[var_65_0],
				mechanism = NetworkLookup.mechanism_keys[var_65_1]
			}
		end,
		initial_vote_func = function(arg_66_0)
			return {
				[arg_66_0.voter_peer_id] = 1
			}
		end
	}
}

DLCUtils.require_list("vote_template_filenames")

for iter_0_0, iter_0_1 in pairs(VoteTemplates) do
	iter_0_1.name = iter_0_0
end
