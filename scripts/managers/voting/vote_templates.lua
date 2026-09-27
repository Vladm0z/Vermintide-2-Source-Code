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
		on_complete = function (arg_1_0, arg_1_1)
			-- function 1
			local level_transition_handler = Managers.level_transition_handler

			if arg_1_0 == 1 then
				local generate_level_seed = Managers.mechanism:generate_level_seed()

				level_transition_handler:reload_level(nil, generate_level_seed)
				Managers.level_transition_handler:promote_next_level_data()
			else
				local get_hub_level_key = Managers.mechanism:game_mechanism():get_hub_level_key()
				local get_environment_variation_id = LevelHelper:get_environment_variation_id(get_hub_level_key)

				level_transition_handler:set_next_level(get_hub_level_key, get_environment_variation_id)
				level_transition_handler:promote_next_level_data()
			end
		end,
		pack_sync_data = function (arg_2_0)
			-- function 2
			return {}
		end,
		extract_sync_data = function (arg_3_0)
			-- function 3
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
		on_complete = function (arg_4_0, arg_4_1)
			-- function 4
			local get_hub_level_key = Managers.mechanism:game_mechanism():get_hub_level_key()

			Managers.state.game_mode:start_specific_level(get_hub_level_key, 0)
		end,
		pack_sync_data = function (arg_5_0)
			-- function 5
			return {}
		end,
		extract_sync_data = function (arg_6_0)
			-- function 6
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
		on_complete = function (arg_7_0, arg_7_1)
			-- function 7
			local level_transition_handler = Managers.level_transition_handler
			local generate_level_seed = Managers.mechanism:generate_level_seed()

			if arg_7_0 == 1 then
				local checkpoint_data = Managers.state.spawn:checkpoint_data()

				level_transition_handler:reload_level(checkpoint_data, generate_level_seed)
				Managers.level_transition_handler:promote_next_level_data()
			elseif arg_7_0 == 2 then
				level_transition_handler:reload_level(nil, generate_level_seed)
				Managers.level_transition_handler:promote_next_level_data()
			else
				Managers.state.event:trigger("checkpoint_vote_cancelled")
			end
		end,
		pack_sync_data = function (arg_8_0)
			-- function 8
			return {}
		end,
		extract_sync_data = function (arg_9_0)
			-- function 9
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
		on_complete = function (arg_10_0, arg_10_1, arg_10_2)
			-- function 10
			if arg_10_0 == 1 then
				arg_10_1.network_server:kick_peer(arg_10_2.kick_peer_id)
			end
		end,
		pack_sync_data = function (self)
			-- function 11
			return {
				self.voter_peer_id,
				self.kick_peer_id
			}
		end,
		extract_sync_data = function (self)
			-- function 12
			local var_12_0 = self[1]
			local var_12_1 = self[2]

			return {
				voter_peer_id = var_12_0,
				kick_peer_id = var_12_1
			}
		end,
		modify_title_text = function (arg_13_0, arg_13_1)
			-- function 13
			local player_from_peer_id = Managers.player:player_from_peer_id(arg_13_1.kick_peer_id)
			local name

			if not player_from_peer_id then
				name = player_from_peer_id:name()

				if not name then
					-- Nothing
				end
			end

			name = "n/a"

			::label_13_0::

			return sprintf("%s\n%s", arg_13_0, tostring(name))
		end,
		initial_vote_func = function (self)
			-- function 14
			return {
				[self.voter_peer_id] = 1,
				[self.kick_peer_id] = 2
			}
		end,
		can_start_vote = function (self)
			-- function 15
			if not self and not Managers.player:player_from_peer_id(self.kick_peer_id) then
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
		on_complete = function (arg_16_0, arg_16_1, arg_16_2)
			-- function 16
			if arg_16_0 == 1 then
				arg_16_1.network_server:kick_peer(arg_16_2.kick_peer_id)
			end
		end,
		pack_sync_data = function (self)
			-- function 17
			return {
				self.voter_peer_id,
				self.kick_peer_id
			}
		end,
		extract_sync_data = function (self)
			-- function 18
			local var_18_0 = self[1]
			local var_18_1 = self[2]

			return {
				voter_peer_id = var_18_0,
				kick_peer_id = var_18_1
			}
		end,
		modify_title_text = function (arg_19_0, arg_19_1)
			-- function 19
			local name = Managers.player:player_from_peer_id(arg_19_1.kick_peer_id):name()

			return sprintf("%s\n%s", arg_19_0, tostring(name))
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
		on_complete = function (arg_20_0, arg_20_1, arg_20_2)
			-- function 20
			if arg_20_0 == 1 then
				local level_key = arg_20_2.level_key

				Managers.state.game_mode:start_specific_level(level_key)
			end
		end,
		pack_sync_data = function (self)
			-- function 21
			return {
				self.voter_peer_id,
				NetworkLookup.mission_ids[self.level_key]
			}
		end,
		extract_sync_data = function (self)
			-- function 22
			local var_22_0 = self[1]
			local var_22_1 = NetworkLookup.mission_ids[tonumber(self[2])]

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
		requirement_failed_message_func = function (self)
			-- function 23
			local var_23_0 = Localize("vote_requirement_failed")
			local player = Managers.player

			for k, v in pairs(self.results) do
				if not v then
					local name = player:player_from_peer_id(k):name()

					var_23_0 = var_23_0 .. name .. "\n"
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
		on_start = function (arg_24_0, arg_24_1)
			-- function 24
			Managers.matchmaking:cancel_matchmaking()
		end,
		on_complete = function (arg_25_0, arg_25_1, arg_25_2)
			-- function 25
			if arg_25_0 == 1 then
				local mission_id = arg_25_2.mission_id
				local difficulty = arg_25_2.difficulty
				local quick_game = arg_25_2.quick_game
				local private_game = arg_25_2.private_game
				local always_host = arg_25_2.always_host
				local strict_matchmaking = arg_25_2.strict_matchmaking
				local matchmaking_type = arg_25_2.matchmaking_type
				local excluded_level_keys = arg_25_2.excluded_level_keys
				local mechanism = arg_25_2.mechanism
				local vote_type = arg_25_2.vote_type
				local tbl = {
					dedicated_server = false,
					join_method = "solo",
					mission_id = mission_id,
					difficulty = difficulty,
					quick_game = quick_game,
					private_game = private_game,
					always_host = always_host,
					strict_matchmaking = strict_matchmaking,
					matchmaking_type = matchmaking_type,
					excluded_level_keys = excluded_level_keys,
					mechanism = mechanism
				}

				if not ((Managers.twitch:is_connecting() or not Managers.twitch:is_connected()) and Managers.twitch:game_mode_supported(vote_type, difficulty)) then
					Managers.twitch:disconnect()
				end

				Managers.mechanism:reset_choose_next_state()
				Managers.matchmaking:find_game(tbl)
			end
		end,
		pack_sync_data = function (self)
			-- function 26
			local mission_id = self.mission_id

			mission_id = mission_id or "n/a"

			local act_key = self.act_key

			act_key = act_key or "n/a"

			local difficulty = self.difficulty
			local quick_game = self.quick_game
			local private_game = self.private_game
			local always_host = self.always_host
			local strict_matchmaking = self.strict_matchmaking
			local matchmaking_type = self.matchmaking_type
			local twitch = Managers.twitch

			twitch = not twitch and Managers.twitch:is_connected()

			local mechanism = self.mechanism
			local tbl = {
				NetworkLookup.mission_ids[mission_id],
				NetworkLookup.act_keys[act_key],
				NetworkLookup.difficulties[difficulty]
			}
			local flag

			flag = not quick_game and 1 and 2
			tbl[4] = flag

			local flag_2

			flag_2 = not private_game and 1 and 2
			tbl[5] = flag_2

			local flag_3

			flag_3 = not always_host and 1 and 2
			tbl[6] = flag_3

			local flag_4

			flag_4 = not strict_matchmaking and 1 and 2
			tbl[7] = flag_4
			tbl[8] = NetworkLookup.matchmaking_types[matchmaking_type]

			local flag_5

			flag_5 = not twitch and 1 and 2
			tbl[9] = flag_5
			tbl[10] = NetworkLookup.mechanisms[mechanism]

			return tbl
		end,
		extract_sync_data = function (self)
			-- function 27
			local var_27_0 = self[1]
			local var_27_1 = self[2]
			local var_27_2 = self[3]
			local var_27_3 = self[4]
			local var_27_4 = self[5]
			local var_27_5 = self[6]
			local var_27_6 = self[7]
			local var_27_7 = self[8]
			local var_27_8 = self[9]
			local var_27_9 = self[10]
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
			local tbl = {
				mission_id = var_27_10,
				act_key = var_27_11,
				difficulty = var_27_12
			}
			local flag

			flag = var_27_3 ~= 1 or not true or false
			tbl.quick_game = flag

			local flag_2

			flag_2 = var_27_4 ~= 1 or not true or false
			tbl.private_game = flag_2

			local flag_3

			flag_3 = var_27_5 ~= 1 or not true or false
			tbl.always_host = flag_3

			local flag_4

			flag_4 = var_27_6 ~= 1 or not true or false
			tbl.strict_matchmaking = flag_4
			tbl.matchmaking_type = var_27_13

			local flag_5

			flag_5 = var_27_8 ~= 1 or not true or false
			tbl.twitch_enabled = flag_5
			tbl.mechanism = var_27_14

			return tbl
		end,
		initial_vote_func = function (self)
			-- function 28
			return {
				[self.voter_peer_id] = 1
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
		requirement_failed_message_func = function (self)
			-- function 29
			local var_29_0 = Localize("vote_requirement_failed")
			local player = Managers.player

			for k, v in pairs(self.results) do
				if not v then
					local name = player:player_from_peer_id(k):name()

					var_29_0 = var_29_0 .. name .. "\n"
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
		on_start = function (arg_30_0, arg_30_1)
			-- function 30
			Managers.matchmaking:cancel_matchmaking()
		end,
		on_complete = function (arg_31_0, arg_31_1, arg_31_2)
			-- function 31
			if arg_31_0 == 1 then
				local mission_id = arg_31_2.mission_id
				local difficulty = arg_31_2.difficulty
				local flag = true
				local flag_2 = false
				local str = "deed"
				local mechanism = arg_31_2.mechanism
				local vote_type = arg_31_2.vote_type
				local tbl = {
					dedicated_server = false,
					join_method = "solo",
					mission_id = mission_id,
					difficulty = difficulty,
					private_game = flag,
					quick_game = flag_2,
					matchmaking_type = str,
					mechanism = mechanism
				}

				if not ((Managers.twitch:is_connecting() or not Managers.twitch:is_connected()) and Managers.twitch:game_mode_supported(vote_type, difficulty)) then
					Managers.twitch:disconnect()
				end

				Managers.mechanism:reset_choose_next_state()
				Managers.matchmaking:find_game(tbl)
			else
				Managers.deed:reset()
			end
		end,
		pack_sync_data = function (self)
			-- function 32
			local item_name = self.item_name
			local mission_id = self.mission_id
			local difficulty = self.difficulty
			local twitch = Managers.twitch

			twitch = not twitch and Managers.twitch:is_connected()

			local mechanism = self.mechanism
			local tbl = {
				NetworkLookup.item_names[item_name],
				NetworkLookup.mission_ids[mission_id],
				NetworkLookup.difficulties[difficulty]
			}
			local flag

			flag = not twitch and 1 and 2
			tbl[4] = flag
			tbl[5] = NetworkLookup.mechanisms[mechanism]

			return tbl
		end,
		extract_sync_data = function (self)
			-- function 33
			local var_33_0 = self[1]
			local var_33_1 = self[2]
			local var_33_2 = self[3]
			local var_33_3 = self[4]
			local var_33_4 = self[5]
			local var_33_5 = NetworkLookup.item_names[var_33_0]
			local var_33_6 = NetworkLookup.mission_ids[var_33_1]

			if var_33_6 == "n/a" then
				var_33_6 = nil
			end

			local var_33_7 = NetworkLookup.difficulties[var_33_2]
			local tbl = {
				matchmaking_type = "deed",
				item_name = var_33_5,
				mission_id = var_33_6,
				difficulty = var_33_7
			}
			local flag

			flag = var_33_3 ~= 1 or not true or false
			tbl.twitch_enabled = flag
			tbl.mechanism = NetworkLookup.mechanisms[var_33_4]

			return tbl
		end,
		initial_vote_func = function (self)
			-- function 34
			return {
				[self.voter_peer_id] = 1
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
		requirement_failed_message_func = function (self)
			-- function 35
			local var_35_0 = Localize("vote_requirement_failed")
			local player = Managers.player

			for k, v in pairs(self.results) do
				if not v then
					local name = player:player_from_peer_id(k):name()

					var_35_0 = var_35_0 .. name .. "\n"
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
		on_start = function (arg_36_0, arg_36_1)
			-- function 36
			Managers.matchmaking:cancel_matchmaking()
		end,
		on_complete = function (arg_37_0, arg_37_1, arg_37_2)
			-- function 37
			if arg_37_0 == 1 then
				local mission_id = arg_37_2.mission_id
				local difficulty = arg_37_2.difficulty
				local flag = false
				local flag_2 = false
				local str = "event"
				local mechanism = arg_37_2.mechanism
				local vote_type = arg_37_2.vote_type
				local tbl = {
					dedicated_server = false,
					join_method = "solo",
					mission_id = mission_id,
					difficulty = difficulty,
					quick_game = flag_2,
					private_game = flag,
					matchmaking_type = str,
					mechanism = mechanism
				}

				if not ((Managers.twitch:is_connecting() or not Managers.twitch:is_connected()) and Managers.twitch:game_mode_supported(vote_type, difficulty)) then
					Managers.twitch:disconnect()
				end

				Managers.mechanism:reset_choose_next_state()

				local event_data = arg_37_2.event_data
				local matchmaking = Managers.matchmaking

				matchmaking:find_game(tbl)
				matchmaking:set_game_mode_event_data(event_data)
			end
		end,
		pack_sync_data = function (self)
			-- function 38
			local mission_id = self.mission_id

			mission_id = mission_id or "n/a"

			local difficulty = self.difficulty
			local mutators = self.event_data.mutators
			local twitch = Managers.twitch

			twitch = not twitch and Managers.twitch:is_connected()

			local mechanism = self.mechanism
			local tbl = {
				NetworkLookup.mission_ids[mission_id],
				NetworkLookup.difficulties[difficulty]
			}
			local flag

			flag = not twitch and 1 and 2
			tbl[3] = flag
			tbl[4] = NetworkLookup.mechanisms[mechanism]

			for i = 1, #mutators do
				local var_38_7 = mutators[i]
				local var_38_8 = NetworkLookup.mutator_templates[var_38_7]

				tbl[#tbl + 1] = var_38_8
			end

			return tbl
		end,
		extract_sync_data = function (self)
			-- function 39
			local var_39_0 = self[1]
			local var_39_1 = self[2]
			local var_39_2 = self[3]
			local var_39_3 = self[4]
			local tbl = {}

			for i = 5, #self do
				local var_39_5 = self[i]

				tbl[#tbl + 1] = NetworkLookup.mutator_templates[var_39_5]
			end

			local var_39_6 = NetworkLookup.mission_ids[var_39_0]

			if var_39_6 == "n/a" then
				var_39_6 = nil
			end

			local var_39_7 = NetworkLookup.difficulties[var_39_1]
			local var_39_8 = NetworkLookup.mechanisms[var_39_3]
			local tbl_2 = {
				matchmaking_type = "event",
				mission_id = var_39_6,
				difficulty = var_39_7,
				event_data = {
					mutators = tbl
				}
			}
			local flag

			flag = var_39_2 ~= 1 or not true or false
			tbl_2.twitch_enabled = flag
			tbl_2.mechanism = var_39_8

			return tbl_2
		end,
		initial_vote_func = function (self)
			-- function 40
			return {
				[self.voter_peer_id] = 1
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
		requirement_failed_message_func = function (self)
			-- function 41
			local var_41_0 = Localize("vote_weave_requirement_failed")
			local player = Managers.player

			for k, v in pairs(self.results) do
				if not v then
					local name = player:player_from_peer_id(k):name()

					var_41_0 = var_41_0 .. name .. "\n"
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
		can_start_vote = function (arg_42_0)
			-- function 42
			if not Managers.player.is_server then
				return true
			end

			local str = ""
			local weave = MechanismSettings.weave
			local human_players = Managers.player:human_players()
			local statistics_db = Managers.player:statistics_db()

			for k, v in pairs(human_players) do
				local stats_id = v:stats_id()

				if not weave.extra_requirements_function(statistics_db, stats_id) then
					str = str .. v:name() .. "\n"
				end
			end

			if #str > 0 then
				local var_42_5 = Localize("vote_game_mode_requirement_failed")
				local format = string.format(var_42_5, str)

				return false, format
			else
				return true
			end
		end,
		on_start = function (arg_43_0, arg_43_1)
			-- function 43
			Managers.matchmaking:cancel_matchmaking()
		end,
		on_complete = function (arg_44_0, arg_44_1, arg_44_2)
			-- function 44
			if arg_44_0 == 1 then
				local mission_id = arg_44_2.mission_id
				local objective_index = arg_44_2.objective_index
				local difficulty_key = WeaveSettings.templates[mission_id].difficulty_key
				local private_game = arg_44_2.private_game
				local always_host = arg_44_2.always_host
				local flag = false
				local matchmaking_type = arg_44_2.matchmaking_type
				local mechanism = arg_44_2.mechanism
				local tbl = {
					dedicated_server = false,
					mission_id = mission_id,
					difficulty = difficulty_key,
					private_game = private_game,
					always_host = always_host,
					quick_game = flag,
					matchmaking_type = matchmaking_type,
					mechanism = mechanism
				}

				Managers.mechanism:choose_next_state("weave")
				Managers.weave:set_next_weave(mission_id)
				Managers.weave:set_next_objective(objective_index)
				Managers.matchmaking:find_game(tbl)
			end
		end,
		pack_sync_data = function (self)
			-- function 45
			local mission_id = self.mission_id
			local objective_index = self.objective_index
			local private_game = self.private_game
			local mechanism = self.mechanism
			local matchmaking_type = self.matchmaking_type
			local tbl = {
				NetworkLookup.mission_ids[mission_id],
				objective_index
			}
			local flag

			flag = not private_game and 1 and 2
			tbl[3] = flag
			tbl[4] = NetworkLookup.mechanisms[mechanism]
			tbl[5] = NetworkLookup.matchmaking_types[matchmaking_type]

			return tbl
		end,
		extract_sync_data = function (self)
			-- function 46
			local var_46_0 = self[1]
			local var_46_1 = NetworkLookup.mission_ids[var_46_0]
			local var_46_2 = self[2]
			local difficulty_key = WeaveSettings.templates[var_46_1].difficulty_key
			local flag

			flag = self[3] ~= 1 or not true or false

			local var_46_5 = self[4]
			local var_46_6 = NetworkLookup.mechanisms[var_46_5]
			local var_46_7 = self[5]
			local var_46_8 = NetworkLookup.matchmaking_types[var_46_7]

			return {
				mission_id = var_46_1,
				difficulty = difficulty_key,
				objective_index = var_46_2,
				matchmaking_type = var_46_8,
				private_game = flag,
				mechanism = var_46_6
			}
		end,
		initial_vote_func = function (self)
			-- function 47
			return {
				[self.voter_peer_id] = 1
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
		on_start = function (arg_48_0, arg_48_1)
			-- function 48
			return
		end,
		on_complete = function (arg_49_0, arg_49_1, arg_49_2)
			-- function 49
			if arg_49_0 == 1 then
				local mission_id = arg_49_2.mission_id
				local objective_index = arg_49_2.objective_index
				local difficulty_key = WeaveSettings.templates[mission_id].difficulty_key
				local flag = false
				local flag_2 = false
				local str = "custom"
				local mechanism = arg_49_2.mechanism
				local tbl = {
					dedicated_server = false,
					mission_id = mission_id,
					difficulty = difficulty_key,
					private_game = flag,
					quick_game = flag_2,
					matchmaking_type = str,
					mechanism = mechanism
				}

				Managers.matchmaking:weave_vote_result(true)
			else
				Managers.matchmaking:weave_vote_result(false)
			end
		end,
		pack_sync_data = function (self)
			-- function 50
			local mission_id = self.mission_id
			local objective_index = self.objective_index
			local mechanism = self.mechanism

			return {
				NetworkLookup.weave_names[mission_id],
				objective_index,
				NetworkLookup.mechanisms[mechanism]
			}
		end,
		extract_sync_data = function (self)
			-- function 51
			local var_51_0 = self[1]
			local var_51_1 = NetworkLookup.weave_names[var_51_0]
			local var_51_2 = self[2]
			local difficulty_key = WeaveSettings.templates[var_51_1].difficulty_key
			local var_51_4 = self[3]
			local var_51_5 = NetworkLookup.mechanisms[var_51_4]

			return {
				matchmaking_type = "custom",
				mission_id = var_51_1,
				difficulty = difficulty_key,
				objective_index = var_51_2,
				mechanism = var_51_5
			}
		end,
		initial_vote_func = function (arg_52_0)
			-- function 52
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
		requirement_failed_message_func = function (self)
			-- function 53
			local var_53_0 = Localize("vote_weave_requirement_failed")
			local player = Managers.player

			for k, v in pairs(self.results) do
				if not v then
					local name = player:player_from_peer_id(k):name()

					var_53_0 = var_53_0 .. name .. "\n"
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
		can_start_vote = function (arg_54_0)
			-- function 54
			if not Managers.player.is_server then
				return true
			end

			local str = ""
			local weave = MechanismSettings.weave
			local human_players = Managers.player:human_players()
			local statistics_db = Managers.player:statistics_db()

			for k, v in pairs(human_players) do
				local stats_id = v:stats_id()

				if not weave.extra_requirements_function(statistics_db, stats_id) then
					str = str .. v:name() .. "\n"
				end
			end

			if #str > 0 then
				local var_54_5 = Localize("vote_game_mode_requirement_failed")
				local format = string.format(var_54_5, str)

				return false, format
			else
				return true
			end
		end,
		on_start = function (arg_55_0, arg_55_1)
			-- function 55
			Managers.matchmaking:cancel_matchmaking()
		end,
		on_complete = function (arg_56_0, arg_56_1, arg_56_2)
			-- function 56
			if arg_56_0 == 1 then
				local difficulty = arg_56_2.difficulty
				local always_host = arg_56_2.always_host
				local private_game = arg_56_2.private_game
				local mechanism = arg_56_2.mechanism
				local matchmaking_type = arg_56_2.matchmaking_type
				local tbl = {
					any_level = true,
					quick_game = true,
					dedicated_server = false,
					difficulty = difficulty,
					always_host = always_host,
					matchmaking_type = matchmaking_type,
					private_game = private_game,
					mechanism = mechanism
				}

				Managers.mechanism:choose_next_state("weave")
				Managers.matchmaking:find_game(tbl)
			end
		end,
		pack_sync_data = function (self)
			-- function 57
			local difficulty = self.difficulty
			local mechanism = self.mechanism
			local matchmaking_type = self.matchmaking_type

			return {
				NetworkLookup.difficulties[difficulty],
				NetworkLookup.mechanisms[mechanism],
				NetworkLookup.matchmaking_types[matchmaking_type]
			}
		end,
		extract_sync_data = function (self)
			-- function 58
			local var_58_0 = self[1]
			local var_58_1 = NetworkLookup.difficulties[var_58_0]
			local var_58_2 = self[2]
			local var_58_3 = NetworkLookup.mechanisms[var_58_2]
			local var_58_4 = self[3]
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
		initial_vote_func = function (self)
			-- function 59
			return {
				[self.voter_peer_id] = 1
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
		requirement_failed_message_func = function (self)
			-- function 60
			local var_60_0 = Localize("vote_requirement_failed")
			local player = Managers.player

			for k, v in pairs(self.results) do
				if not v then
					local name = player:player_from_peer_id(k):name()

					var_60_0 = var_60_0 .. name .. "\n"
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
		can_start_vote = function (arg_61_0)
			-- function 61
			local flag = true

			if not Managers.player.is_server then
				flag = Managers.state.network.network_server:are_all_peers_ingame(nil, true)
			end

			if not flag then
				local num = 1
				local str = ""
				local flag_2 = true
				local flag_3 = false
				local str_2 = "map_confirm_button_disabled_tooltip_players_joining"

				Managers.chat:send_system_chat_message(1, str_2, str, flag_3, flag_2)
			end

			return flag
		end,
		on_start = function (arg_62_0, arg_62_1)
			-- function 62
			Managers.matchmaking:cancel_matchmaking()
		end,
		on_complete = function (arg_63_0, arg_63_1, arg_63_2)
			-- function 63
			if arg_63_0 == 1 then
				local level_key = arg_63_2.level_key
				local level_transition_handler = Managers.level_transition_handler

				level_transition_handler:set_next_level(level_key)
				level_transition_handler:promote_next_level_data()
			end
		end,
		pack_sync_data = function (self)
			-- function 64
			local level_key = self.level_key
			local mechanism = self.mechanism

			return {
				NetworkLookup.mission_ids[level_key],
				NetworkLookup.mechanism_keys[mechanism]
			}
		end,
		extract_sync_data = function (self)
			-- function 65
			local var_65_0 = self[1]
			local var_65_1 = self[2]

			return {
				switch_mechanism = true,
				level_key = NetworkLookup.mission_ids[var_65_0],
				mechanism = NetworkLookup.mechanism_keys[var_65_1]
			}
		end,
		initial_vote_func = function (self)
			-- function 66
			return {
				[self.voter_peer_id] = 1
			}
		end
	}
}

DLCUtils.require_list("vote_template_filenames")

for k, v in pairs(VoteTemplates) do
	v.name = k
end
