-- chunkname: @scripts/settings/dlcs/carousel/carousel_vote_templates.lua

VoteTemplates.carousel_settings_vote = {
	client_start_vote_rpc = "rpc_server_request_start_vote_lookup",
	ingame_vote = false,
	mission_vote = true,
	gamepad_support = true,
	text = "carousel_settings_vote",
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
			text = "dlc1_3_1_decline",
			gamepad_input = "back",
			vote = 2,
			input = "ingame_vote_no"
		}
	},
	on_start = function(arg_1_0, arg_1_1)
		Managers.matchmaking:cancel_matchmaking()
	end,
	on_complete = function(arg_2_0, arg_2_1, arg_2_2)
		if arg_2_0 == 1 then
			local var_2_0 = arg_2_2.vote_type

			if Managers.twitch and (Managers.twitch:is_connecting() or Managers.twitch:is_connected()) and not Managers.twitch:game_mode_supported(var_2_0, difficulty) then
				Managers.twitch:disconnect()
			end

			local var_2_1 = Managers.state.network:lobby()
			local var_2_2 = arg_2_2.use_dedicated_win_servers or arg_2_2.use_dedicated_aws_servers
			local var_2_3 = {
				wait_for_join_message = true,
				mission_id = arg_2_2.mission_id,
				preferred_level_keys = arg_2_2.preferred_level_keys,
				difficulty = arg_2_2.difficulty,
				quick_game = arg_2_2.quick_game or false,
				join_method = arg_2_2.join_method,
				private_game = arg_2_2.private_game or false,
				party_lobby_host = var_2_2 and var_2_1,
				max_num_players = GameModeSettings.versus.max_num_players,
				player_hosted = arg_2_2.player_hosted,
				dedicated_server = var_2_2,
				aws = arg_2_2.use_dedicated_aws_servers,
				linux = arg_2_2.use_dedicated_aws_servers,
				mechanism = arg_2_2.mechanism,
				matchmaking_type = arg_2_2.matchmaking_type
			}

			Managers.matchmaking:find_game(var_2_3)
		end
	end,
	pack_sync_data = function(arg_3_0)
		local var_3_0 = arg_3_0.mission_id or "n/a"
		local var_3_1 = arg_3_0.difficulty or "n/a"
		local var_3_2 = arg_3_0.player_hosted
		local var_3_3 = arg_3_0.use_dedicated_win_servers
		local var_3_4 = arg_3_0.use_dedicated_aws_servers
		local var_3_5 = arg_3_0.matchmaking_type
		local var_3_6 = arg_3_0.mechanism
		local var_3_7 = arg_3_0.quick_game

		return {
			NetworkLookup.mission_ids[var_3_0],
			NetworkLookup.difficulties[var_3_1],
			NetworkLookup.join_methods[arg_3_0.join_method],
			var_3_2 and 1 or 2,
			var_3_3 and 1 or 2,
			var_3_4 and 1 or 2,
			NetworkLookup.matchmaking_types[var_3_5],
			NetworkLookup.mechanisms[var_3_6],
			var_3_7 and 1 or 2
		}
	end,
	extract_sync_data = function(arg_4_0)
		local var_4_0 = arg_4_0[1]
		local var_4_1 = arg_4_0[2]
		local var_4_2 = arg_4_0[3]
		local var_4_3 = arg_4_0[4]
		local var_4_4 = arg_4_0[5]
		local var_4_5 = arg_4_0[6]
		local var_4_6 = arg_4_0[7]
		local var_4_7 = arg_4_0[8]
		local var_4_8 = arg_4_0[9]
		local var_4_9 = NetworkLookup.mission_ids[var_4_0]

		if var_4_9 == "n/a" then
			var_4_9 = nil
		end

		local var_4_10 = NetworkLookup.difficulties[var_4_1]
		local var_4_11 = NetworkLookup.join_methods[var_4_2]
		local var_4_12 = NetworkLookup.matchmaking_types[var_4_6]
		local var_4_13 = NetworkLookup.mechanisms[var_4_7]

		return {
			mission_id = var_4_9,
			difficulty = var_4_10,
			join_method = var_4_11,
			player_hosted = var_4_3 == 1,
			use_dedicated_win_servers = var_4_4 == 1,
			use_dedicated_aws_servers = var_4_5 == 1,
			matchmaking_type = var_4_12,
			mechanism = var_4_13,
			quick_game = var_4_8 == 1
		}
	end,
	initial_vote_func = function(arg_5_0)
		return {
			[arg_5_0.voter_peer_id] = 1
		}
	end
}
VoteTemplates.carousel_player_hosted_settings_vote = {
	client_start_vote_rpc = "rpc_server_request_start_vote_lookup",
	ingame_vote = false,
	mission_vote = true,
	gamepad_support = true,
	text = "carousel_player_host_settings_vote",
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
			text = "dlc1_3_1_decline",
			gamepad_input = "back",
			vote = 2,
			input = "ingame_vote_no"
		}
	},
	on_start = function(arg_6_0, arg_6_1)
		Managers.matchmaking:cancel_matchmaking()
	end,
	on_complete = function(arg_7_0, arg_7_1, arg_7_2)
		if arg_7_0 == 1 then
			local var_7_0 = arg_7_2.vote_type

			if Managers.twitch and (Managers.twitch:is_connecting() or Managers.twitch:is_connected()) and not Managers.twitch:game_mode_supported(var_7_0, difficulty) then
				Managers.twitch:disconnect()
			end

			local var_7_1 = Managers.state.network:lobby()

			if not arg_7_2.use_dedicated_win_servers then
				local var_7_2 = arg_7_2.use_dedicated_aws_servers
			end

			local var_7_3 = {
				player_hosted = true,
				matchmaking_start_state = "MatchmakingStatePlayerHostedGame",
				dedicated_server = false,
				quick_game = false,
				mission_id = arg_7_2.mission_id,
				any_level = arg_7_2.any_level,
				difficulty = arg_7_2.difficulty,
				private_game = arg_7_2.private_game or false,
				party_lobby_host = var_7_1,
				max_num_players = GameModeSettings.versus.max_num_players,
				mechanism = arg_7_2.mechanism,
				matchmaking_type = arg_7_2.matchmaking_type
			}

			Managers.matchmaking:find_game(var_7_3)
		end
	end,
	pack_sync_data = function(arg_8_0)
		local var_8_0 = arg_8_0.mission_id or "n/a"
		local var_8_1 = arg_8_0.difficulty or "n/a"
		local var_8_2 = arg_8_0.player_hosted
		local var_8_3 = arg_8_0.matchmaking_type
		local var_8_4 = arg_8_0.mechanism

		return {
			NetworkLookup.mission_ids[var_8_0],
			NetworkLookup.difficulties[var_8_1],
			var_8_2 and 1 or 2,
			NetworkLookup.matchmaking_types[var_8_3],
			NetworkLookup.mechanisms[var_8_4]
		}
	end,
	extract_sync_data = function(arg_9_0)
		local var_9_0 = arg_9_0[1]
		local var_9_1 = arg_9_0[2]
		local var_9_2 = arg_9_0[3]
		local var_9_3 = arg_9_0[4]
		local var_9_4 = arg_9_0[5]
		local var_9_5 = NetworkLookup.mission_ids[var_9_0]

		if var_9_5 == "n/a" then
			var_9_5 = nil
		end

		local var_9_6 = NetworkLookup.difficulties[var_9_1]
		local var_9_7 = NetworkLookup.matchmaking_types[var_9_3]
		local var_9_8 = NetworkLookup.mechanisms[var_9_4]

		return {
			mission_id = var_9_5,
			difficulty = var_9_6,
			player_hosted = var_9_2 == 1,
			matchmaking_type = var_9_7,
			mechanism = var_9_8
		}
	end,
	initial_vote_func = function(arg_10_0)
		return {
			[arg_10_0.voter_peer_id] = 1
		}
	end
}
