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
	on_start = function (arg_1_0, arg_1_1)
		-- function 1
		Managers.matchmaking:cancel_matchmaking()
	end,
	on_complete = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		if arg_2_0 == 1 then
			local vote_type = arg_2_2.vote_type

			if not (not Managers.twitch and Managers.twitch:is_connecting() and not Managers.twitch:is_connected() and Managers.twitch:game_mode_supported(vote_type, difficulty)) then
				Managers.twitch:disconnect()
			end

			local lobby = Managers.state.network:lobby()
			local use_dedicated_win_servers = arg_2_2.use_dedicated_win_servers

			use_dedicated_win_servers = use_dedicated_win_servers or arg_2_2.use_dedicated_aws_servers

			local tbl = {
				wait_for_join_message = true,
				mission_id = arg_2_2.mission_id,
				preferred_level_keys = arg_2_2.preferred_level_keys,
				difficulty = arg_2_2.difficulty
			}
			local quick_game = arg_2_2.quick_game

			quick_game = quick_game or false
			tbl.quick_game = quick_game
			tbl.join_method = arg_2_2.join_method

			local private_game = arg_2_2.private_game

			private_game = private_game or false
			tbl.private_game = private_game
			tbl.party_lobby_host = not use_dedicated_win_servers and lobby
			tbl.max_num_players = GameModeSettings.versus.max_num_players
			tbl.player_hosted = arg_2_2.player_hosted
			tbl.dedicated_server = use_dedicated_win_servers
			tbl.aws = arg_2_2.use_dedicated_aws_servers
			tbl.linux = arg_2_2.use_dedicated_aws_servers
			tbl.mechanism = arg_2_2.mechanism
			tbl.matchmaking_type = arg_2_2.matchmaking_type

			Managers.matchmaking:find_game(tbl)
		end
	end,
	pack_sync_data = function (self)
		-- function 3
		local mission_id = self.mission_id

		mission_id = mission_id or "n/a"

		local difficulty = self.difficulty

		difficulty = difficulty or "n/a"

		local player_hosted = self.player_hosted
		local use_dedicated_win_servers = self.use_dedicated_win_servers
		local use_dedicated_aws_servers = self.use_dedicated_aws_servers
		local matchmaking_type = self.matchmaking_type
		local mechanism = self.mechanism
		local quick_game = self.quick_game
		local tbl = {
			NetworkLookup.mission_ids[mission_id],
			NetworkLookup.difficulties[difficulty],
			NetworkLookup.join_methods[self.join_method]
		}
		local flag

		flag = not player_hosted and 1 and 2
		tbl[4] = flag

		local flag_2

		flag_2 = not use_dedicated_win_servers and 1 and 2
		tbl[5] = flag_2

		local flag_3

		flag_3 = not use_dedicated_aws_servers and 1 and 2
		tbl[6] = flag_3
		tbl[7] = NetworkLookup.matchmaking_types[matchmaking_type]
		tbl[8] = NetworkLookup.mechanisms[mechanism]

		local flag_4

		flag_4 = not quick_game and 1 and 2
		tbl[9] = flag_4

		return tbl
	end,
	extract_sync_data = function (self)
		-- function 4
		local var_4_0 = self[1]
		local var_4_1 = self[2]
		local var_4_2 = self[3]
		local var_4_3 = self[4]
		local var_4_4 = self[5]
		local var_4_5 = self[6]
		local var_4_6 = self[7]
		local var_4_7 = self[8]
		local var_4_8 = self[9]
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
	initial_vote_func = function (self)
		-- function 5
		return {
			[self.voter_peer_id] = 1
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
	on_start = function (arg_6_0, arg_6_1)
		-- function 6
		Managers.matchmaking:cancel_matchmaking()
	end,
	on_complete = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		if arg_7_0 == 1 then
			local vote_type = arg_7_2.vote_type

			if not (not Managers.twitch and Managers.twitch:is_connecting() and not Managers.twitch:is_connected() and Managers.twitch:game_mode_supported(vote_type, difficulty)) then
				Managers.twitch:disconnect()
			end

			local lobby = Managers.state.network:lobby()

			if not arg_7_2.use_dedicated_win_servers then
				local use_dedicated_aws_servers = arg_7_2.use_dedicated_aws_servers
			end

			local tbl = {
				player_hosted = true,
				matchmaking_start_state = "MatchmakingStatePlayerHostedGame",
				dedicated_server = false,
				quick_game = false,
				mission_id = arg_7_2.mission_id,
				any_level = arg_7_2.any_level,
				difficulty = arg_7_2.difficulty
			}
			local private_game = arg_7_2.private_game

			private_game = private_game or false
			tbl.private_game = private_game
			tbl.party_lobby_host = lobby
			tbl.max_num_players = GameModeSettings.versus.max_num_players
			tbl.mechanism = arg_7_2.mechanism
			tbl.matchmaking_type = arg_7_2.matchmaking_type

			Managers.matchmaking:find_game(tbl)
		end
	end,
	pack_sync_data = function (self)
		-- function 8
		local mission_id = self.mission_id

		mission_id = mission_id or "n/a"

		local difficulty = self.difficulty

		difficulty = difficulty or "n/a"

		local player_hosted = self.player_hosted
		local matchmaking_type = self.matchmaking_type
		local mechanism = self.mechanism
		local tbl = {
			NetworkLookup.mission_ids[mission_id],
			NetworkLookup.difficulties[difficulty]
		}
		local flag

		flag = not player_hosted and 1 and 2
		tbl[3] = flag
		tbl[4] = NetworkLookup.matchmaking_types[matchmaking_type]
		tbl[5] = NetworkLookup.mechanisms[mechanism]

		return tbl
	end,
	extract_sync_data = function (self)
		-- function 9
		local var_9_0 = self[1]
		local var_9_1 = self[2]
		local var_9_2 = self[3]
		local var_9_3 = self[4]
		local var_9_4 = self[5]
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
	initial_vote_func = function (self)
		-- function 10
		return {
			[self.voter_peer_id] = 1
		}
	end
}
