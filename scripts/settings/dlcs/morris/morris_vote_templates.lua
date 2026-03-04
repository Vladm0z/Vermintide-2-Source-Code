-- chunkname: @scripts/settings/dlcs/morris/morris_vote_templates.lua

VoteTemplates.deus_settings_vote = {
	client_start_vote_rpc = "rpc_server_request_start_vote_lookup",
	ingame_vote = false,
	mission_vote = true,
	gamepad_support = true,
	text = "deus_settings_vote",
	minimum_voter_percent = 1,
	success_percent = 1,
	server_start_vote_rpc = "rpc_client_start_vote_lookup",
	duration = 30,
	priority = 110,
	min_required_voters = 1,
	gamepad_input_desc = "default_voting",
	timeout_vote_option = 2,
	requirement_failed_message_func = function(arg_1_0)
		local var_1_0 = Localize("vote_requirement_failed")
		local var_1_1 = Managers.player

		for iter_1_0, iter_1_1 in pairs(arg_1_0.results) do
			if not iter_1_1 then
				local var_1_2 = var_1_1:player_from_peer_id(iter_1_0):name()

				var_1_0 = var_1_0 .. var_1_2 .. "\n"
			end
		end

		return var_1_0
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
	on_start = function(arg_2_0, arg_2_1)
		Managers.matchmaking:cancel_matchmaking()
	end,
	on_complete = function(arg_3_0, arg_3_1, arg_3_2)
		if arg_3_0 == 1 then
			local var_3_0 = arg_3_2.mission_id
			local var_3_1 = arg_3_2.difficulty
			local var_3_2 = arg_3_2.quick_game
			local var_3_3 = arg_3_2.private_game
			local var_3_4 = arg_3_2.always_host
			local var_3_5 = arg_3_2.strict_matchmaking
			local var_3_6 = arg_3_2.matchmaking_type
			local var_3_7 = arg_3_2.excluded_level_keys
			local var_3_8 = arg_3_2.vote_type
			local var_3_9 = {
				any_level = true,
				dedicated_servers = false,
				dedicated_server = false,
				mechanism = "deus",
				join_method = "solo",
				mission_id = var_3_0,
				difficulty = var_3_1,
				quick_game = var_3_2,
				private_game = var_3_3,
				always_host = var_3_4,
				strict_matchmaking = var_3_5,
				matchmaking_type = var_3_6,
				excluded_level_keys = var_3_7
			}

			if Managers.twitch and (Managers.twitch:is_connecting() or Managers.twitch:is_connected()) and not Managers.twitch:game_mode_supported(var_3_8, var_3_1) then
				Managers.twitch:disconnect()
			end

			Managers.mechanism:set_vote_data(arg_3_2)
			Managers.mechanism:reset_choose_next_state()

			local var_3_10 = Managers.matchmaking

			var_3_10:find_game(var_3_9)

			if var_3_6 == "event" then
				local var_3_11 = arg_3_2.event_data

				var_3_10:set_game_mode_event_data(var_3_11)
			end
		end
	end,
	pack_sync_data = function(arg_4_0)
		local var_4_0 = arg_4_0.mission_id or "n/a"
		local var_4_1 = arg_4_0.act_key or "n/a"
		local var_4_2 = arg_4_0.difficulty
		local var_4_3 = arg_4_0.quick_game
		local var_4_4 = arg_4_0.private_game
		local var_4_5 = arg_4_0.always_host
		local var_4_6 = arg_4_0.strict_matchmaking
		local var_4_7 = arg_4_0.matchmaking_type
		local var_4_8 = Managers.twitch and Managers.twitch:is_connected()
		local var_4_9 = arg_4_0.dominant_god
		local var_4_10 = arg_4_0.mechanism

		if not arg_4_0.mission_id then
			var_4_0 = "n/a"
			var_4_9 = nil
		end

		local var_4_11 = {
			NetworkLookup.mission_ids[var_4_0],
			NetworkLookup.act_keys[var_4_1],
			NetworkLookup.difficulties[var_4_2],
			var_4_3 and 1 or 2,
			var_4_4 and 1 or 2,
			var_4_5 and 1 or 2,
			var_4_6 and 1 or 2,
			NetworkLookup.matchmaking_types[var_4_7],
			var_4_8 and 1 or 2,
			NetworkLookup.mechanisms[var_4_10],
			var_4_9 and NetworkLookup.deus_themes[var_4_9]
		}

		if var_4_7 == "event" then
			local var_4_12 = arg_4_0.event_data
			local var_4_13 = var_4_12.mutators or {}

			var_4_11[#var_4_11 + 1] = #var_4_13

			for iter_4_0 = 1, #var_4_13 do
				local var_4_14 = var_4_13[iter_4_0]
				local var_4_15 = NetworkLookup.mutator_templates[var_4_14]

				var_4_11[#var_4_11 + 1] = var_4_15
			end

			local var_4_16 = var_4_12.boons or {}

			var_4_11[#var_4_11 + 1] = #var_4_16

			for iter_4_1 = 1, #var_4_16 do
				local var_4_17 = var_4_16[iter_4_1]
				local var_4_18 = DeusPowerUpsLookup[var_4_17]

				var_4_11[#var_4_11 + 1] = var_4_18.lookup_id
			end
		end

		return var_4_11
	end,
	extract_sync_data = function(arg_5_0)
		local var_5_0 = arg_5_0[1]
		local var_5_1 = arg_5_0[2]
		local var_5_2 = arg_5_0[3]
		local var_5_3 = arg_5_0[4]
		local var_5_4 = arg_5_0[5]
		local var_5_5 = arg_5_0[6]
		local var_5_6 = arg_5_0[7]
		local var_5_7 = arg_5_0[8]
		local var_5_8 = arg_5_0[9]
		local var_5_9 = arg_5_0[10]
		local var_5_10 = arg_5_0[11]
		local var_5_11 = NetworkLookup.mission_ids[var_5_0]

		if var_5_11 == "n/a" then
			var_5_11 = nil
		end

		local var_5_12 = NetworkLookup.act_keys[var_5_1]

		if var_5_12 == "n/a" then
			var_5_12 = nil
		end

		local var_5_13 = NetworkLookup.difficulties[var_5_2]
		local var_5_14 = NetworkLookup.matchmaking_types[var_5_7]
		local var_5_15 = var_5_10 and NetworkLookup.deus_themes[var_5_10]
		local var_5_16 = NetworkLookup.mechanisms[var_5_9]
		local var_5_17
		local var_5_18

		if var_5_14 == "event" then
			var_5_17 = {}

			local var_5_19 = 12
			local var_5_20 = var_5_19 + 1
			local var_5_21 = arg_5_0[var_5_19]

			for iter_5_0 = var_5_20, var_5_20 + var_5_21 - 1 do
				local var_5_22 = arg_5_0[iter_5_0]

				var_5_17[#var_5_17 + 1] = NetworkLookup.mutator_templates[var_5_22]
			end

			var_5_18 = {}

			local var_5_23 = var_5_20 + var_5_21
			local var_5_24 = var_5_23 + 1
			local var_5_25 = arg_5_0[var_5_23]

			for iter_5_1 = var_5_24, var_5_24 + var_5_25 - 1 do
				local var_5_26 = arg_5_0[iter_5_1]
				local var_5_27 = DeusPowerUpsLookup[var_5_26]

				var_5_18[#var_5_18 + 1] = var_5_27.name
			end
		end

		return {
			mission_id = var_5_11,
			act_key = var_5_12,
			difficulty = var_5_13,
			event_data = (var_5_17 or var_5_18) and {
				mutators = var_5_17,
				boons = var_5_18
			},
			dominant_god = var_5_15,
			quick_game = var_5_3 == 1,
			private_game = var_5_4 == 1,
			always_host = var_5_5 == 1,
			strict_matchmaking = var_5_6 == 1,
			matchmaking_type = var_5_14,
			twitch_enabled = var_5_8 == 1,
			mechanism = var_5_16
		}
	end,
	initial_vote_func = function(arg_6_0)
		return {
			[arg_6_0.voter_peer_id] = 1
		}
	end
}
