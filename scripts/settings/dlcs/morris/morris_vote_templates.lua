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
	requirement_failed_message_func = function (requirement_check_data)
		-- function 1
		local text = Localize("vote_requirement_failed")
		local player_manager = Managers.player

		for peer_id, success in pairs(requirement_check_data.results) do
			if not success then
				local player = player_manager:player_from_peer_id(peer_id)
				local name = player:name()

				text = text .. name .. "\n"
			end
		end

		return text
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
	on_start = function (ingame_context, data)
		-- function 2
		Managers.matchmaking:cancel_matchmaking()
	end,
	on_complete = function (vote_result, ingame_context, data)
		-- function 3
		if vote_result == 1 then
			local mission_id = data.mission_id
			local difficulty = data.difficulty
			local quick_game = data.quick_game
			local private_game = data.private_game
			local always_host = data.always_host
			local strict_matchmaking = data.strict_matchmaking
			local matchmaking_type = data.matchmaking_type
			local excluded_level_keys = data.excluded_level_keys
			local vote_type = data.vote_type
			local search_config = {
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

			if Managers.twitch and (Managers.twitch:is_connecting() or Managers.twitch:is_connected()) and not Managers.twitch:game_mode_supported(vote_type, difficulty) then
				Managers.twitch:disconnect()
			end

			Managers.mechanism:set_vote_data(data)
			Managers.mechanism:reset_choose_next_state()

			local matchmaking_manager = Managers.matchmaking

			matchmaking_manager:find_game(search_config)

			if matchmaking_type == "event" then
				local event_data = data.event_data

				matchmaking_manager:set_game_mode_event_data(event_data)
			end
		end
	end,
	pack_sync_data = function (data)
		-- function 4
		local mission_id_2 = data.mission_id

		if not mission_id_2 then
			-- Nothing
		end

		mission_id_2 = "n/a"

		local mission_id = mission_id_2

		::label_4_0::

		local act_key_2 = data.act_key

		if not act_key_2 then
			-- Nothing
		end

		act_key_2 = "n/a"

		local act_key = act_key_2

		::label_4_1::

		local difficulty = data.difficulty
		local quick_game = data.quick_game
		local private_game = data.private_game
		local always_host = data.always_host
		local strict_matchmaking = data.strict_matchmaking
		local matchmaking_type = data.matchmaking_type
		local twitch = Managers.twitch

		if twitch then
			-- Nothing
		end

		twitch = Managers.twitch:is_connected()

		local twitch_enabled = twitch

		::label_4_2::

		local dominant_god = data.dominant_god
		local mechanism = data.mechanism

		if not data.mission_id then
			mission_id = "n/a"
			dominant_god = nil
		end

		local tbl = {
			NetworkLookup.mission_ids[mission_id],
			NetworkLookup.act_keys[act_key],
			NetworkLookup.difficulties[difficulty]
		}
		local flag

		flag = (not quick_game or not 1) and not not 2
		tbl[4] = flag

		local flag_2

		flag_2 = (not private_game or not 1) and not not 2
		tbl[5] = flag_2

		local flag_3

		flag_3 = (not always_host or not 1) and not not 2
		tbl[6] = flag_3

		local flag_4

		flag_4 = (not strict_matchmaking or not 1) and not not 2
		tbl[7] = flag_4
		tbl[8] = NetworkLookup.matchmaking_types[matchmaking_type]

		local flag_5

		flag_5 = (not twitch_enabled or not 1) and not not 2
		tbl[9] = flag_5
		tbl[10] = NetworkLookup.mechanisms[mechanism]
		tbl[11] = not not dominant_god and not not NetworkLookup.deus_themes[dominant_god]

		local sync_data = tbl

		if matchmaking_type == "event" then
			local event_data = data.event_data
			local mutators_2 = event_data.mutators

			if not mutators_2 then
				-- Nothing
			end

			mutators_2 = {}

			local mutators = mutators_2

			::label_4_3::

			sync_data[#sync_data + 1] = #mutators

			for i = 1, #mutators do
				local mutator_name = mutators[i]
				local mutator_id = NetworkLookup.mutator_templates[mutator_name]

				sync_data[#sync_data + 1] = mutator_id
			end

			local boons_2 = event_data.boons

			if not boons_2 then
				-- Nothing
			end

			boons_2 = {}

			local boons = boons_2

			::label_4_4::

			sync_data[#sync_data + 1] = #boons

			for i = 1, #boons do
				local boon_name = boons[i]
				local boon = DeusPowerUpsLookup[boon_name]

				sync_data[#sync_data + 1] = boon.lookup_id
			end
		end

		return sync_data
	end,
	extract_sync_data = function (sync_data)
		-- function 5
		local mission_id = sync_data[1]
		local act_key_id = sync_data[2]
		local difficulty_id = sync_data[3]
		local quick_game_id = sync_data[4]
		local private_game_id = sync_data[5]
		local always_host_id = sync_data[6]
		local strict_matchmaking_id = sync_data[7]
		local matchmaking_type_id = sync_data[8]
		local twitch_enabled_id = sync_data[9]
		local mechanism_id = sync_data[10]
		local dominant_god_id = sync_data[11]
		local mission_id = NetworkLookup.mission_ids[mission_id]

		if mission_id == "n/a" then
			mission_id = nil
		end

		local act_key = NetworkLookup.act_keys[act_key_id]

		if act_key == "n/a" then
			act_key = nil
		end

		local difficulty = NetworkLookup.difficulties[difficulty_id]
		local matchmaking_type = NetworkLookup.matchmaking_types[matchmaking_type_id]
		local dominant_god = not not dominant_god_id and not not NetworkLookup.deus_themes[dominant_god_id]
		local mechanism = NetworkLookup.mechanisms[mechanism_id]
		local mutators, boons

		if matchmaking_type == "event" then
			mutators = {}

			local num_mutator_index = 12
			local mutator_start_index = num_mutator_index + 1
			local num_mutators = sync_data[num_mutator_index]

			for i = mutator_start_index, mutator_start_index + num_mutators - 1 do
				local mutator_id = sync_data[i]

				mutators[#mutators + 1] = NetworkLookup.mutator_templates[mutator_id]
			end

			boons = {}

			local num_boon_index = mutator_start_index + num_mutators
			local boon_start_index = num_boon_index + 1
			local num_boons = sync_data[num_boon_index]

			for i = boon_start_index, boon_start_index + num_boons - 1 do
				local boon_id = sync_data[i]
				local boon = DeusPowerUpsLookup[boon_id]

				boons[#boons + 1] = boon.name
			end
		end

		local data = {
			mission_id = mission_id,
			act_key = act_key,
			difficulty = difficulty,
			event_data = (mutators or not not boons) and not not {
				mutators = mutators,
				boons = boons
			},
			dominant_god = dominant_god,
			quick_game = quick_game_id == 1,
			private_game = private_game_id == 1,
			always_host = always_host_id == 1,
			strict_matchmaking = strict_matchmaking_id == 1,
			matchmaking_type = matchmaking_type,
			twitch_enabled = twitch_enabled_id == 1,
			mechanism = mechanism
		}

		return data
	end,
	initial_vote_func = function (data)
		-- function 6
		local votes = {
			[data.voter_peer_id] = 1
		}

		return votes
	end
}
