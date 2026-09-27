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
	requirement_failed_message_func = function (self)
		-- function 1
		local var_1_0 = Localize("vote_requirement_failed")
		local player = Managers.player

		for k, v in pairs(self.results) do
			if not v then
				local name = player:player_from_peer_id(k):name()

				var_1_0 = var_1_0 .. name .. "\n"
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
	on_start = function (arg_2_0, arg_2_1)
		-- function 2
		Managers.matchmaking:cancel_matchmaking()
	end,
	on_complete = function (arg_3_0, arg_3_1, arg_3_2)
		-- function 3
		if arg_3_0 == 1 then
			local mission_id = arg_3_2.mission_id
			local difficulty = arg_3_2.difficulty
			local quick_game = arg_3_2.quick_game
			local private_game = arg_3_2.private_game
			local always_host = arg_3_2.always_host
			local strict_matchmaking = arg_3_2.strict_matchmaking
			local matchmaking_type = arg_3_2.matchmaking_type
			local excluded_level_keys = arg_3_2.excluded_level_keys
			local vote_type = arg_3_2.vote_type
			local tbl = {
				any_level = true,
				dedicated_servers = false,
				dedicated_server = false,
				mechanism = "deus",
				join_method = "solo",
				mission_id = mission_id,
				difficulty = difficulty,
				quick_game = quick_game,
				private_game = private_game,
				always_host = always_host,
				strict_matchmaking = strict_matchmaking,
				matchmaking_type = matchmaking_type,
				excluded_level_keys = excluded_level_keys
			}

			if not (not Managers.twitch and Managers.twitch:is_connecting() and not Managers.twitch:is_connected() and Managers.twitch:game_mode_supported(vote_type, difficulty)) then
				Managers.twitch:disconnect()
			end

			Managers.mechanism:set_vote_data(arg_3_2)
			Managers.mechanism:reset_choose_next_state()

			local matchmaking = Managers.matchmaking

			matchmaking:find_game(tbl)

			if matchmaking_type == "event" then
				local event_data = arg_3_2.event_data

				matchmaking:set_game_mode_event_data(event_data)
			end
		end
	end,
	pack_sync_data = function (self)
		-- function 4
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

		local dominant_god = self.dominant_god
		local mechanism = self.mechanism

		if not self.mission_id then
			mission_id = "n/a"
			dominant_god = nil
		end

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
		tbl[11] = not dominant_god and NetworkLookup.deus_themes[dominant_god]

		if matchmaking_type == "event" then
			local event_data = self.event_data
			local mutators = event_data.mutators

			mutators = mutators or {}
			tbl[#tbl + 1] = #mutators

			for i = 1, #mutators do
				local var_4_19 = mutators[i]
				local var_4_20 = NetworkLookup.mutator_templates[var_4_19]

				tbl[#tbl + 1] = var_4_20
			end

			local boons = event_data.boons

			boons = boons or {}
			tbl[#tbl + 1] = #boons

			for j = 1, #boons do
				local var_4_22 = boons[j]
				local var_4_23 = DeusPowerUpsLookup[var_4_22]

				tbl[#tbl + 1] = var_4_23.lookup_id
			end
		end

		return tbl
	end,
	extract_sync_data = function (self)
		-- function 5
		local var_5_0 = self[1]
		local var_5_1 = self[2]
		local var_5_2 = self[3]
		local var_5_3 = self[4]
		local var_5_4 = self[5]
		local var_5_5 = self[6]
		local var_5_6 = self[7]
		local var_5_7 = self[8]
		local var_5_8 = self[9]
		local var_5_9 = self[10]
		local var_5_10 = self[11]
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
		local flag = not var_5_10 and NetworkLookup.deus_themes[var_5_10]
		local var_5_16 = NetworkLookup.mechanisms[var_5_9]
		local var_5_17
		local var_5_18

		if var_5_14 == "event" then
			var_5_17 = {}

			local num = 12
			local num_2 = num + 1
			local var_5_21 = self[num]

			for i = num_2, num_2 + var_5_21 - 1 do
				local var_5_22 = self[i]

				var_5_17[#var_5_17 + 1] = NetworkLookup.mutator_templates[var_5_22]
			end

			var_5_18 = {}

			local num_3 = num_2 + var_5_21
			local num_4 = num_3 + 1
			local var_5_25 = self[num_3]

			for j = num_4, num_4 + var_5_25 - 1 do
				local var_5_26 = self[j]
				local var_5_27 = DeusPowerUpsLookup[var_5_26]

				var_5_18[#var_5_18 + 1] = var_5_27.name
			end
		end

		return {
			mission_id = var_5_11,
			act_key = var_5_12,
			difficulty = var_5_13,
			event_data = var_5_17 or not var_5_18 or {
				mutators = var_5_17,
				boons = var_5_18
			},
			dominant_god = flag,
			quick_game = var_5_3 == 1,
			private_game = var_5_4 == 1,
			always_host = var_5_5 == 1,
			strict_matchmaking = var_5_6 == 1,
			matchmaking_type = var_5_14,
			twitch_enabled = var_5_8 == 1,
			mechanism = var_5_16
		}
	end,
	initial_vote_func = function (self)
		-- function 6
		return {
			[self.voter_peer_id] = 1
		}
	end
}
