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
	on_start = function (ingame_context, data)
		-- function 1
		Managers.matchmaking:cancel_matchmaking()
	end,
	on_complete = function (vote_result, ingame_context, data)
		-- function 2
		if vote_result == 1 then
			local vote_type = data.vote_type

			if Managers.twitch and (Managers.twitch:is_connecting() or Managers.twitch:is_connected()) and not Managers.twitch:game_mode_supported(vote_type, difficulty) then
				Managers.twitch:disconnect()
			end

			local lobby = Managers.state.network:lobby()
			local use_dedicated_win_servers = data.use_dedicated_win_servers

			if not use_dedicated_win_servers then
				-- Nothing
			end

			use_dedicated_win_servers = data.use_dedicated_aws_servers

			local use_dedicated_servers = use_dedicated_win_servers

			::label_2_0::

			local tbl = {
				wait_for_join_message = true,
				mission_id = data.mission_id,
				preferred_level_keys = data.preferred_level_keys,
				difficulty = data.difficulty
			}
			local quick_game = data.quick_game

			quick_game = not not quick_game or not not false
			tbl.quick_game = quick_game
			tbl.join_method = data.join_method

			local private_game = data.private_game

			private_game = not not private_game or not not false
			tbl.private_game = private_game
			tbl.party_lobby_host = not not use_dedicated_servers and not not lobby
			tbl.max_num_players = GameModeSettings.versus.max_num_players
			tbl.player_hosted = data.player_hosted
			tbl.dedicated_server = use_dedicated_servers
			tbl.aws = data.use_dedicated_aws_servers
			tbl.linux = data.use_dedicated_aws_servers
			tbl.mechanism = data.mechanism
			tbl.matchmaking_type = data.matchmaking_type

			local search_config = tbl

			Managers.matchmaking:find_game(search_config)
		end
	end,
	pack_sync_data = function (data)
		-- function 3
		local mission_id_2 = data.mission_id

		if not mission_id_2 then
			-- Nothing
		end

		mission_id_2 = "n/a"

		local mission_id = mission_id_2

		::label_3_0::

		local difficulty_2 = data.difficulty

		if not difficulty_2 then
			-- Nothing
		end

		difficulty_2 = "n/a"

		local difficulty = difficulty_2

		::label_3_1::

		local player_hosted = data.player_hosted
		local use_dedicated_win_servers = data.use_dedicated_win_servers
		local use_dedicated_aws_servers = data.use_dedicated_aws_servers
		local matchmaking_type = data.matchmaking_type
		local mechanism = data.mechanism
		local quick_game = data.quick_game
		local tbl = {
			NetworkLookup.mission_ids[mission_id],
			NetworkLookup.difficulties[difficulty],
			NetworkLookup.join_methods[data.join_method]
		}
		local flag

		flag = (not player_hosted or not 1) and not not 2
		tbl[4] = flag

		local flag_2

		flag_2 = (not use_dedicated_win_servers or not 1) and not not 2
		tbl[5] = flag_2

		local flag_3

		flag_3 = (not use_dedicated_aws_servers or not 1) and not not 2
		tbl[6] = flag_3
		tbl[7] = NetworkLookup.matchmaking_types[matchmaking_type]
		tbl[8] = NetworkLookup.mechanisms[mechanism]

		local flag_4

		flag_4 = (not quick_game or not 1) and not not 2
		tbl[9] = flag_4

		local sync_data = tbl

		return sync_data
	end,
	extract_sync_data = function (sync_data)
		-- function 4
		local mission_id = sync_data[1]
		local difficulty_id = sync_data[2]
		local join_method_id = sync_data[3]
		local player_hosted = sync_data[4]
		local use_dedicated_win_servers = sync_data[5]
		local use_dedicated_aws_servers = sync_data[6]
		local matchmaking_type_id = sync_data[7]
		local mechanism_id = sync_data[8]
		local quick_game = sync_data[9]

		mission_id = NetworkLookup.mission_ids[mission_id]

		if mission_id == "n/a" then
			mission_id = nil
		end

		local difficulty = NetworkLookup.difficulties[difficulty_id]
		local join_method = NetworkLookup.join_methods[join_method_id]
		local matchmaking_type = NetworkLookup.matchmaking_types[matchmaking_type_id]
		local mechanism = NetworkLookup.mechanisms[mechanism_id]
		local data = {
			mission_id = mission_id,
			difficulty = difficulty,
			join_method = join_method,
			player_hosted = player_hosted == 1,
			use_dedicated_win_servers = use_dedicated_win_servers == 1,
			use_dedicated_aws_servers = use_dedicated_aws_servers == 1,
			matchmaking_type = matchmaking_type,
			mechanism = mechanism,
			quick_game = quick_game == 1
		}

		return data
	end,
	initial_vote_func = function (data)
		-- function 5
		local votes = {
			[data.voter_peer_id] = 1
		}

		return votes
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
	on_start = function (ingame_context, data)
		-- function 6
		Managers.matchmaking:cancel_matchmaking()
	end,
	on_complete = function (vote_result, ingame_context, data)
		-- function 7
		if vote_result == 1 then
			local vote_type = data.vote_type

			if Managers.twitch and (Managers.twitch:is_connecting() or Managers.twitch:is_connected()) and not Managers.twitch:game_mode_supported(vote_type, difficulty) then
				Managers.twitch:disconnect()
			end

			local lobby = Managers.state.network:lobby()
			local use_dedicated_win_servers = data.use_dedicated_win_servers

			if not use_dedicated_win_servers then
				-- Nothing
			end

			use_dedicated_win_servers = data.use_dedicated_aws_servers

			local use_dedicated_servers = use_dedicated_win_servers

			::label_7_0::

			local tbl = {
				player_hosted = true,
				matchmaking_start_state = "MatchmakingStatePlayerHostedGame",
				dedicated_server = false,
				quick_game = false,
				mission_id = data.mission_id,
				any_level = data.any_level,
				difficulty = data.difficulty
			}
			local private_game = data.private_game

			private_game = not not private_game or not not false
			tbl.private_game = private_game
			tbl.party_lobby_host = lobby
			tbl.max_num_players = GameModeSettings.versus.max_num_players
			tbl.mechanism = data.mechanism
			tbl.matchmaking_type = data.matchmaking_type

			local search_config = tbl

			Managers.matchmaking:find_game(search_config)
		end
	end,
	pack_sync_data = function (data)
		-- function 8
		local mission_id_2 = data.mission_id

		if not mission_id_2 then
			-- Nothing
		end

		mission_id_2 = "n/a"

		local mission_id = mission_id_2

		::label_8_0::

		local difficulty_2 = data.difficulty

		if not difficulty_2 then
			-- Nothing
		end

		difficulty_2 = "n/a"

		local difficulty = difficulty_2

		::label_8_1::

		local player_hosted = data.player_hosted
		local matchmaking_type = data.matchmaking_type
		local mechanism = data.mechanism
		local tbl = {
			NetworkLookup.mission_ids[mission_id],
			NetworkLookup.difficulties[difficulty]
		}
		local flag

		flag = (not player_hosted or not 1) and not not 2
		tbl[3] = flag
		tbl[4] = NetworkLookup.matchmaking_types[matchmaking_type]
		tbl[5] = NetworkLookup.mechanisms[mechanism]

		local sync_data = tbl

		return sync_data
	end,
	extract_sync_data = function (sync_data)
		-- function 9
		local mission_id = sync_data[1]
		local difficulty_id = sync_data[2]
		local player_hosted = sync_data[3]
		local matchmaking_type_id = sync_data[4]
		local mechanism_id = sync_data[5]
		local mission_id = NetworkLookup.mission_ids[mission_id]

		if mission_id == "n/a" then
			mission_id = nil
		end

		local difficulty = NetworkLookup.difficulties[difficulty_id]
		local matchmaking_type = NetworkLookup.matchmaking_types[matchmaking_type_id]
		local mechanism = NetworkLookup.mechanisms[mechanism_id]
		local data = {
			mission_id = mission_id,
			difficulty = difficulty,
			player_hosted = player_hosted == 1,
			matchmaking_type = matchmaking_type,
			mechanism = mechanism
		}

		return data
	end,
	initial_vote_func = function (data)
		-- function 10
		local votes = {
			[data.voter_peer_id] = 1
		}

		return votes
	end
}
