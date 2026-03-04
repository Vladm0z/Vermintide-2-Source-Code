-- chunkname: @scripts/managers/matchmaking/matchmaking_state_search_game.lua

MatchmakingStateSearchGame = class(MatchmakingStateSearchGame)
MatchmakingStateSearchGame.NAME = "MatchmakingStateSearchGame"

function MatchmakingStateSearchGame.init(arg_1_0, arg_1_1)
	arg_1_0._lobby_finder = arg_1_1.lobby_finder
	arg_1_0._peer_id = Network.peer_id()
	arg_1_0._matchmaking_manager = arg_1_1.matchmaking_manager
	arg_1_0._network_server = arg_1_1.network_server
	arg_1_0._statistics_db = arg_1_1.statistics_db
	Managers.matchmaking.countdown_has_finished = false
end

function MatchmakingStateSearchGame.destroy(arg_2_0)
	return
end

function MatchmakingStateSearchGame.on_enter(arg_3_0, arg_3_1)
	arg_3_0.state_context = arg_3_1
	arg_3_0.search_config = arg_3_1.search_config

	arg_3_0:_start_searching_for_games()
end

function MatchmakingStateSearchGame._start_searching_for_games(arg_4_0)
	local var_4_0 = arg_4_0.search_config
	local var_4_1 = {
		difficulty = {
			comparison = "equal",
			value = var_4_0.difficulty
		}
	}

	if not var_4_0.quick_game then
		local var_4_2 = var_4_0.mission_id

		if var_4_2 then
			var_4_1.selected_mission_id = {
				comparison = "equal",
				value = var_4_2
			}
		end

		local var_4_3 = var_4_0.act_key

		if var_4_3 then
			var_4_1.act_key = {
				comparison = "equal",
				value = var_4_3
			}
		end
	end

	local var_4_4 = var_4_0.matchmaking_type

	if var_4_4 then
		if var_4_4 == "standard" then
			local var_4_5 = "custom"
			local var_4_6 = NetworkLookup.matchmaking_types[var_4_5]

			var_4_1.matchmaking_type = {
				comparison = "less_or_equal",
				value = var_4_6
			}
		else
			local var_4_7 = NetworkLookup.matchmaking_types[var_4_4]

			var_4_1.matchmaking_type = {
				comparison = "equal",
				value = var_4_7
			}
		end
	end

	local var_4_8 = Managers.eac:is_trusted()

	var_4_1.eac_authorized = {
		comparison = "equal",
		value = var_4_8 and "true" or "false"
	}
	var_4_1.mechanism = {
		comparison = "equal",
		value = arg_4_0.search_config.mechanism
	}
	arg_4_0._current_filters = var_4_1
	arg_4_0._current_distance_filter = "close"

	local var_4_9 = arg_4_0._matchmaking_manager:get_average_power_level()

	arg_4_0._current_near_filters = {
		{
			key = "power_level",
			value = var_4_9
		}
	}

	arg_4_0._matchmaking_manager:setup_filter_requirements(1, arg_4_0._current_distance_filter, arg_4_0._current_filters, arg_4_0._current_near_filters)

	local var_4_10 = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local var_4_11 = var_4_10:get_stored_lobby_data()

	var_4_11.matchmaking = "searching"
	var_4_11.time_of_search = tostring(os.time())

	var_4_10:set_lobby_data(var_4_11)
	Managers.level_transition_handler:clear_next_level()
	arg_4_0._lobby_finder:refresh()
	arg_4_0._matchmaking_manager:send_system_chat_message("matchmaking_status_start_search")

	if var_4_0.act_key then
		arg_4_0._matchmaking_manager:send_system_chat_message(var_4_0.act_key)
	end

	if var_4_0.mission_id then
		if var_4_0.mechanism == "weave" then
			local var_4_12 = WeaveSettings.templates[var_4_0.mission_id].display_name

			arg_4_0._matchmaking_manager:send_system_chat_message(var_4_12)
		else
			local var_4_13 = LevelSettings[var_4_0.mission_id].display_name

			arg_4_0._matchmaking_manager:send_system_chat_message(var_4_13)
		end
	end

	local var_4_14 = DifficultySettings[var_4_0.difficulty].display_name

	arg_4_0._matchmaking_manager:send_system_chat_message(var_4_14)

	local var_4_15 = Managers.player:local_player()

	Managers.telemetry_events:matchmaking_search(var_4_15, arg_4_0.search_config)
end

function MatchmakingStateSearchGame.on_exit(arg_5_0)
	return
end

function MatchmakingStateSearchGame.update(arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0._network_server:num_active_peers() > 1 then
		mm_printf("Leaving MatchmakingStateSearchGame and becoming host due to having connections, probably a friend joining.")

		return MatchmakingStateHostGame, arg_6_0.state_context
	end

	if arg_6_0.state_context.join_lobby_data then
		arg_6_0._matchmaking_manager:send_system_chat_message("matchmaking_status_found_game")

		return MatchmakingStateRequestJoinGame, arg_6_0.state_context
	end

	arg_6_0._lobby_finder:update(arg_6_1)

	if arg_6_0._lobby_finder:is_refreshing() then
		return
	end

	local var_6_0 = arg_6_0:_search_for_game(arg_6_1)
	local var_6_1 = var_6_0 ~= nil
	local var_6_2 = false

	if not var_6_1 then
		local var_6_3 = arg_6_0._current_distance_filter
		local var_6_4 = LobbyAux.get_next_lobby_distance_filter(var_6_3, MatchmakingSettings.max_distance_filter)

		if var_6_4 ~= nil then
			mm_printf("Changing distance filter from %s to %s", var_6_3, var_6_4)
			arg_6_0._matchmaking_manager:setup_filter_requirements(1, var_6_4, arg_6_0._current_filters, arg_6_0._current_near_filters)

			arg_6_0._current_distance_filter = var_6_4
			var_6_2 = true

			arg_6_0._matchmaking_manager:send_system_chat_message("matchmaking_status_increased_search_range")
		end

		if arg_6_0.search_config.host_games then
			var_6_2 = arg_6_0.search_config.host_games == "never"
		elseif MatchmakingSettings.host_games == "never" then
			var_6_2 = true
		end

		if var_6_2 then
			arg_6_0._lobby_finder:refresh()
		end
	end

	if var_6_0 then
		arg_6_0.state_context.join_lobby_data = var_6_0
	elseif not var_6_2 then
		arg_6_0._matchmaking_manager:send_system_chat_message("matchmaking_status_cannot_find_game")

		local var_6_5 = Managers.player:local_player(1)
		local var_6_6 = "search_game_timeout"
		local var_6_7 = arg_6_0.state_context.started_matchmaking_t
		local var_6_8 = Managers.time:time("main") - var_6_7
		local var_6_9 = arg_6_0.search_config.strict_matchmaking

		Managers.telemetry_events:matchmaking_search_timeout(var_6_5, var_6_8, arg_6_0.search_config)

		return MatchmakingStateHostGame, arg_6_0.state_context
	end

	return nil
end

function MatchmakingStateSearchGame._search_for_game(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0:_get_server_lobbies()
	local var_7_1
	local var_7_2
	local var_7_3 = Managers.player:player_from_peer_id(arg_7_0._peer_id):profile_index()
	local var_7_4 = arg_7_0.search_config
	local var_7_5 = arg_7_0._matchmaking_manager
	local var_7_6
	local var_7_7 = {}
	local var_7_8 = var_7_4.matchmaking_type
	local var_7_9 = var_7_4.mission_id
	local var_7_10 = var_7_4.preferred_level_keys

	if var_7_4.any_level then
		var_7_7 = {
			"any"
		}
	elseif var_7_9 then
		var_7_7 = {
			var_7_9
		}
	elseif var_7_10 then
		var_7_7 = table.clone(var_7_10)

		if var_7_4.include_hub_level then
			local var_7_11 = Managers.mechanism:game_mechanism():get_hub_level_key()

			var_7_7[#var_7_7 + 1] = var_7_11
		end
	else
		local var_7_12

		var_7_12, var_7_7 = var_7_5:get_weighed_random_unlocked_level(false, not var_7_4.quick_game)
	end

	return (arg_7_0:_find_suitable_lobby(var_7_0, var_7_4, var_7_3, var_7_7))
end

local var_0_0 = {}

function MatchmakingStateSearchGame._get_server_lobbies(arg_8_0)
	local var_8_0 = arg_8_0:_get_lobbies()

	table.clear(var_0_0)
	table.merge(var_0_0, var_8_0)

	return var_0_0
end

function MatchmakingStateSearchGame._get_lobbies(arg_9_0)
	return arg_9_0._lobby_finder:lobbies()
end

function MatchmakingStateSearchGame._get_servers(arg_10_0)
	return arg_10_0._game_server_finder:servers()
end

function MatchmakingStateSearchGame._times_party_completed_level(arg_11_0, arg_11_1)
	local var_11_0 = 0
	local var_11_1 = arg_11_0._statistics_db
	local var_11_2 = Managers.player:human_players()

	for iter_11_0, iter_11_1 in pairs(var_11_2) do
		var_11_0 = var_11_0 + var_11_1:get_persistent_stat(iter_11_1:stats_id(), "completed_levels", arg_11_1)
	end

	return var_11_0
end

function MatchmakingStateSearchGame._compare_first_prio_lobbies(arg_12_0, arg_12_1, arg_12_2)
	if arg_12_1 == nil then
		return arg_12_2
	end

	local var_12_0 = arg_12_0.search_config
	local var_12_1 = var_12_0.quick_game
	local var_12_2 = var_12_0.matchmaking_type
	local var_12_3 = var_12_0.mechanism

	if var_12_3 == "deus" or var_12_3 == "weave" then
		return arg_12_1
	end

	local var_12_4 = arg_12_1.selected_mission_id
	local var_12_5 = arg_12_2.selected_mission_id
	local var_12_6 = var_12_4 and LevelSettings[var_12_4]
	local var_12_7 = var_12_5 and LevelSettings[var_12_5]

	if var_12_1 and var_12_6 and not var_12_6.hub_level and var_12_7 and not var_12_7.hub_level and arg_12_0:_times_party_completed_level(var_12_4) > arg_12_0:_times_party_completed_level(var_12_5) then
		return arg_12_2
	end

	return arg_12_1
end

function MatchmakingStateSearchGame._compare_secondary_prio_lobbies(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_1 == nil then
		return arg_13_2
	end

	local var_13_0 = arg_13_0.search_config
	local var_13_1 = var_13_0.quick_game
	local var_13_2 = var_13_0.matchmaking_type
	local var_13_3 = var_13_0.mechanism

	if var_13_3 == "deus" or var_13_3 == "weave" then
		return arg_13_1
	end

	local var_13_4 = arg_13_1.selected_mission_id
	local var_13_5 = arg_13_2.selected_mission_id
	local var_13_6 = var_13_4 and LevelSettings[var_13_4]
	local var_13_7 = var_13_5 and LevelSettings[var_13_5]

	if var_13_1 and var_13_6 and not var_13_6.hub_level and var_13_7 and not var_13_7.hub_level and arg_13_0:_times_party_completed_level(var_13_4) > arg_13_0:_times_party_completed_level(var_13_5) then
		return arg_13_2
	end

	return arg_13_1
end

function MatchmakingStateSearchGame._find_suitable_lobby(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = arg_14_2.mission_id
	local var_14_1 = arg_14_2.difficulty
	local var_14_2 = arg_14_2.matchmaking_type
	local var_14_3 = arg_14_2.mechanism == "weave" and var_14_0 or "false"
	local var_14_4 = arg_14_2.act_key
	local var_14_5 = arg_14_2.mechanism
	local var_14_6 = arg_14_2.strict_matchmaking
	local var_14_7 = arg_14_2.max_distance_filter or MatchmakingSettings.max_distance_filter
	local var_14_8 = arg_14_0._current_distance_filter == var_14_7

	mm_printf("max_quick_play_search_range: %s", var_14_7)

	local var_14_9 = Application.user_setting("allow_occupied_hero_lobbies")
	local var_14_10
	local var_14_11
	local var_14_12 = arg_14_0._matchmaking_manager

	table.dump(arg_14_4, "preferred levels", 2)

	for iter_14_0, iter_14_1 in pairs(arg_14_4) do
		if var_14_10 then
			break
		end

		for iter_14_2, iter_14_3 in ipairs(arg_14_1) do
			local var_14_13 = iter_14_3.unique_server_name or iter_14_3.host
			local var_14_14, var_14_15 = var_14_12:lobby_match(iter_14_3, var_14_4, iter_14_1, var_14_1, var_14_2, arg_14_0._peer_id, var_14_3, var_14_5)

			if var_14_14 then
				local var_14_16 = false
				local var_14_17
				local var_14_18 = false
				local var_14_19 = iter_14_3.selected_mission_id or iter_14_3.mission_id
				local var_14_20 = arg_14_2.quick_game
				local var_14_21 = arg_14_2.matchmaking_type == "event"

				if var_14_5 ~= "weave" and not var_14_0 and not var_14_16 and not var_14_12:party_has_level_unlocked(var_14_19, var_14_20, nil, var_14_21) then
					var_14_16 = true
					var_14_17 = string.format("Mission(%s) is not unlocked by party", var_14_19)
				end

				if not var_14_16 and not var_14_12:hero_available_in_lobby_data(arg_14_3, iter_14_3) then
					local var_14_22 = false

					for iter_14_4 = 1, 5 do
						if MatchmakingSettings.hero_search_filter[iter_14_4] == true and var_14_12:hero_available_in_lobby_data(iter_14_4, iter_14_3) then
							var_14_22 = true

							break
						end
					end

					if var_14_22 and var_14_9 then
						var_14_18 = true
					else
						var_14_16 = true
						var_14_17 = "hero is unavailable"
					end
				end

				local var_14_23 = LevelSettings[iter_14_3.mission_id]

				if not var_14_16 and not var_14_23.hub_level then
					if var_14_6 then
						var_14_16 = true
						var_14_17 = "strict matchmaking"
					else
						var_14_18 = true
					end
				end

				if not var_14_16 and var_14_6 and iter_14_3.selected_mission_id ~= var_14_0 then
					var_14_16 = true
					var_14_17 = "strict matchmaking"
				end

				if not var_14_16 and iter_14_3.host_afk == "true" then
					var_14_18 = true
				end

				if not var_14_16 and var_14_18 and not var_14_8 then
					var_14_16 = true
					var_14_17 = "secondary lobby before reaching max distance"
				end

				if not var_14_16 then
					if not var_14_18 then
						var_14_10 = arg_14_0:_compare_first_prio_lobbies(var_14_10, iter_14_3)
					else
						var_14_11 = arg_14_0:_compare_secondary_prio_lobbies(var_14_11, iter_14_3)
					end
				else
					mm_printf("Lobby hosted by %s discarded due to '%s'", var_14_13, var_14_17 or "unknown")
				end
			else
				mm_printf("Lobby hosted by %s failed lobby match due to '%s'", var_14_13, var_14_15 or "unknown")
			end
		end
	end

	return var_14_10 or var_14_11
end
