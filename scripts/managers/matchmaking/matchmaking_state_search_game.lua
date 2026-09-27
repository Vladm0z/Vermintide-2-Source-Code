-- chunkname: @scripts/managers/matchmaking/matchmaking_state_search_game.lua

MatchmakingStateSearchGame = class(MatchmakingStateSearchGame)
MatchmakingStateSearchGame.NAME = "MatchmakingStateSearchGame"

MatchmakingStateSearchGame.init = function (self, arg_1_1)
	-- function 1
	self._lobby_finder = arg_1_1.lobby_finder
	self._peer_id = Network.peer_id()
	self._matchmaking_manager = arg_1_1.matchmaking_manager
	self._network_server = arg_1_1.network_server
	self._statistics_db = arg_1_1.statistics_db
	Managers.matchmaking.countdown_has_finished = false
end

MatchmakingStateSearchGame.destroy = function (arg_2_0)
	-- function 2
	return
end

MatchmakingStateSearchGame.on_enter = function (self, arg_3_1)
	-- function 3
	self.state_context = arg_3_1
	self.search_config = arg_3_1.search_config

	self:_start_searching_for_games()
end

MatchmakingStateSearchGame._start_searching_for_games = function (self)
	-- function 4
	local search_config = self.search_config
	local tbl = {
		difficulty = {
			comparison = "equal",
			value = search_config.difficulty
		}
	}

	if not search_config.quick_game then
		local mission_id = search_config.mission_id

		if not mission_id then
			tbl.selected_mission_id = {
				comparison = "equal",
				value = mission_id
			}
		end

		local act_key = search_config.act_key

		if not act_key then
			tbl.act_key = {
				comparison = "equal",
				value = act_key
			}
		end
	end

	local matchmaking_type = search_config.matchmaking_type

	if not matchmaking_type then
		if matchmaking_type == "standard" then
			local str = "custom"
			local var_4_6 = NetworkLookup.matchmaking_types[str]

			tbl.matchmaking_type = {
				comparison = "less_or_equal",
				value = var_4_6
			}
		else
			local var_4_7 = NetworkLookup.matchmaking_types[matchmaking_type]

			tbl.matchmaking_type = {
				comparison = "equal",
				value = var_4_7
			}
		end
	end

	local is_trusted = Managers.eac:is_trusted()
	local tbl_2 = {
		comparison = "equal"
	}
	local flag

	flag = not is_trusted and "true" and "false"
	tbl_2.value = flag
	tbl.eac_authorized = tbl_2
	tbl.mechanism = {
		comparison = "equal",
		value = self.search_config.mechanism
	}
	self._current_filters = tbl
	self._current_distance_filter = "close"

	local get_average_power_level = self._matchmaking_manager:get_average_power_level()

	self._current_near_filters = {
		{
			key = "power_level",
			value = get_average_power_level
		}
	}

	self._matchmaking_manager:setup_filter_requirements(1, self._current_distance_filter, self._current_filters, self._current_near_filters)

	local get_lobby = Managers.lobby:get_lobby("matchmaking_session_lobby")
	local get_stored_lobby_data = get_lobby:get_stored_lobby_data()

	get_stored_lobby_data.matchmaking = "searching"
	get_stored_lobby_data.time_of_search = tostring(os.time())

	get_lobby:set_lobby_data(get_stored_lobby_data)
	Managers.level_transition_handler:clear_next_level()
	self._lobby_finder:refresh()
	self._matchmaking_manager:send_system_chat_message("matchmaking_status_start_search")

	if not search_config.act_key then
		self._matchmaking_manager:send_system_chat_message(search_config.act_key)
	end

	if not search_config.mission_id then
		if search_config.mechanism == "weave" then
			local display_name = WeaveSettings.templates[search_config.mission_id].display_name

			self._matchmaking_manager:send_system_chat_message(display_name)
		else
			local display_name_2 = LevelSettings[search_config.mission_id].display_name

			self._matchmaking_manager:send_system_chat_message(display_name_2)
		end
	end

	local display_name_3 = DifficultySettings[search_config.difficulty].display_name

	self._matchmaking_manager:send_system_chat_message(display_name_3)

	local local_player = Managers.player:local_player()

	Managers.telemetry_events:matchmaking_search(local_player, self.search_config)
end

MatchmakingStateSearchGame.on_exit = function (arg_5_0)
	-- function 5
	return
end

MatchmakingStateSearchGame.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if self._network_server:num_active_peers() > 1 then
		mm_printf("Leaving MatchmakingStateSearchGame and becoming host due to having connections, probably a friend joining.")

		return MatchmakingStateHostGame, self.state_context
	end

	if not self.state_context.join_lobby_data then
		self._matchmaking_manager:send_system_chat_message("matchmaking_status_found_game")

		return MatchmakingStateRequestJoinGame, self.state_context
	end

	self._lobby_finder:update(arg_6_1)

	if not self._lobby_finder:is_refreshing() then
		return
	end

	local _search_for_game = self:_search_for_game(arg_6_1)
	local flag = _search_for_game ~= nil
	local flag_2 = false

	if not flag then
		local _current_distance_filter = self._current_distance_filter
		local get_next_lobby_distance_filter = LobbyAux.get_next_lobby_distance_filter(_current_distance_filter, MatchmakingSettings.max_distance_filter)

		if get_next_lobby_distance_filter ~= nil then
			mm_printf("Changing distance filter from %s to %s", _current_distance_filter, get_next_lobby_distance_filter)
			self._matchmaking_manager:setup_filter_requirements(1, get_next_lobby_distance_filter, self._current_filters, self._current_near_filters)

			self._current_distance_filter = get_next_lobby_distance_filter
			flag_2 = true

			self._matchmaking_manager:send_system_chat_message("matchmaking_status_increased_search_range")
		end

		if not self.search_config.host_games then
			flag_2 = self.search_config.host_games == "never"
		elseif MatchmakingSettings.host_games == "never" then
			flag_2 = true
		end

		if not flag_2 then
			self._lobby_finder:refresh()
		end
	end

	if not _search_for_game then
		self.state_context.join_lobby_data = _search_for_game
	elseif not flag_2 then
		self._matchmaking_manager:send_system_chat_message("matchmaking_status_cannot_find_game")

		local local_player = Managers.player:local_player(1)
		local str = "search_game_timeout"
		local started_matchmaking_t = self.state_context.started_matchmaking_t
		local num = Managers.time:time("main") - started_matchmaking_t
		local strict_matchmaking = self.search_config.strict_matchmaking

		Managers.telemetry_events:matchmaking_search_timeout(local_player, num, self.search_config)

		return MatchmakingStateHostGame, self.state_context
	end

	return nil
end

MatchmakingStateSearchGame._search_for_game = function (self, arg_7_1)
	-- function 7
	local _get_server_lobbies = self:_get_server_lobbies()
	local var_7_1
	local var_7_2
	local profile_index = Managers.player:player_from_peer_id(self._peer_id):profile_index()
	local search_config = self.search_config
	local _matchmaking_manager = self._matchmaking_manager
	local var_7_6
	local tbl = {}
	local matchmaking_type = search_config.matchmaking_type
	local mission_id = search_config.mission_id
	local preferred_level_keys = search_config.preferred_level_keys

	if not search_config.any_level then
		tbl = {
			"any"
		}
	elseif not mission_id then
		tbl = {
			mission_id
		}
	elseif not preferred_level_keys then
		tbl = table.clone(preferred_level_keys)

		if not search_config.include_hub_level then
			local get_hub_level_key = Managers.mechanism:game_mechanism():get_hub_level_key()

			tbl[#tbl + 1] = get_hub_level_key
		end
	else
		local get_weighed_random_unlocked_level

		get_weighed_random_unlocked_level, tbl = _matchmaking_manager:get_weighed_random_unlocked_level(false, not search_config.quick_game)
	end

	return (self:_find_suitable_lobby(_get_server_lobbies, search_config, profile_index, tbl))
end

local tbl = {}

MatchmakingStateSearchGame._get_server_lobbies = function (self)
	-- function 8
	local _get_lobbies = self:_get_lobbies()

	table.clear(tbl)
	table.merge(tbl, _get_lobbies)

	return tbl
end

MatchmakingStateSearchGame._get_lobbies = function (self)
	-- function 9
	return self._lobby_finder:lobbies()
end

MatchmakingStateSearchGame._get_servers = function (self)
	-- function 10
	return self._game_server_finder:servers()
end

MatchmakingStateSearchGame._times_party_completed_level = function (self, arg_11_1)
	-- function 11
	local num = 0
	local _statistics_db = self._statistics_db
	local human_players = Managers.player:human_players()

	for k, v in pairs(human_players) do
		num = num + _statistics_db:get_persistent_stat(v:stats_id(), "completed_levels", arg_11_1)
	end

	return num
end

MatchmakingStateSearchGame._compare_first_prio_lobbies = function (self, arg_12_1, arg_12_2)
	-- function 12
	if arg_12_1 == nil then
		return arg_12_2
	end

	local search_config = self.search_config
	local quick_game = search_config.quick_game
	local matchmaking_type = search_config.matchmaking_type
	local mechanism = search_config.mechanism

	if not (mechanism == "deus" or mechanism ~= "weave") then
		return arg_12_1
	end

	local selected_mission_id = arg_12_1.selected_mission_id
	local selected_mission_id_2 = arg_12_2.selected_mission_id
	local flag = not selected_mission_id and LevelSettings[selected_mission_id]
	local flag_2 = not selected_mission_id_2 and LevelSettings[selected_mission_id_2]

	if not (not quick_game and not flag and flag.hub_level and not flag_2 and flag_2.hub_level and not (self:_times_party_completed_level(selected_mission_id) > self:_times_party_completed_level(selected_mission_id_2))) then
		return arg_12_2
	end

	return arg_12_1
end

MatchmakingStateSearchGame._compare_secondary_prio_lobbies = function (self, arg_13_1, arg_13_2)
	-- function 13
	if arg_13_1 == nil then
		return arg_13_2
	end

	local search_config = self.search_config
	local quick_game = search_config.quick_game
	local matchmaking_type = search_config.matchmaking_type
	local mechanism = search_config.mechanism

	if not (mechanism == "deus" or mechanism ~= "weave") then
		return arg_13_1
	end

	local selected_mission_id = arg_13_1.selected_mission_id
	local selected_mission_id_2 = arg_13_2.selected_mission_id
	local flag = not selected_mission_id and LevelSettings[selected_mission_id]
	local flag_2 = not selected_mission_id_2 and LevelSettings[selected_mission_id_2]

	if not (not quick_game and not flag and flag.hub_level and not flag_2 and flag_2.hub_level and not (self:_times_party_completed_level(selected_mission_id) > self:_times_party_completed_level(selected_mission_id_2))) then
		return arg_13_2
	end

	return arg_13_1
end

MatchmakingStateSearchGame._find_suitable_lobby = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local mission_id = arg_14_2.mission_id
	local difficulty = arg_14_2.difficulty
	local matchmaking_type = arg_14_2.matchmaking_type
	local flag = arg_14_2.mechanism ~= "weave" or not mission_id or "false"
	local act_key = arg_14_2.act_key
	local mechanism = arg_14_2.mechanism
	local strict_matchmaking = arg_14_2.strict_matchmaking
	local max_distance_filter = arg_14_2.max_distance_filter

	max_distance_filter = max_distance_filter or MatchmakingSettings.max_distance_filter

	local flag_2 = self._current_distance_filter == max_distance_filter

	mm_printf("max_quick_play_search_range: %s", max_distance_filter)

	local user_setting = Application.user_setting("allow_occupied_hero_lobbies")
	local var_14_10
	local var_14_11
	local _matchmaking_manager = self._matchmaking_manager

	table.dump(arg_14_4, "preferred levels", 2)

	for k, v in pairs(arg_14_4) do
		if not var_14_10 then
			break
		end

		for i, v_2 in ipairs(arg_14_1) do
			local unique_server_name = v_2.unique_server_name

			unique_server_name = unique_server_name or v_2.host

			local lobby_match, var_14_15 = _matchmaking_manager:lobby_match(v_2, act_key, v, difficulty, matchmaking_type, self._peer_id, flag, mechanism)

			if not lobby_match then
				local flag_3 = false
				local var_14_17
				local flag_4 = false
				local selected_mission_id = v_2.selected_mission_id

				selected_mission_id = selected_mission_id or v_2.mission_id

				local quick_game = arg_14_2.quick_game
				local flag_5 = arg_14_2.matchmaking_type == "event"

				if not (mechanism == "weave" or mission_id or flag_3 or _matchmaking_manager:party_has_level_unlocked(selected_mission_id, quick_game, nil, flag_5)) then
					flag_3 = true
					var_14_17 = string.format("Mission(%s) is not unlocked by party", selected_mission_id)
				end

				if not (flag_3 or _matchmaking_manager:hero_available_in_lobby_data(arg_14_3, v_2)) then
					local flag_6 = false

					for i4 = 1, 5 do
						if MatchmakingSettings.hero_search_filter[i4] ~= true or not _matchmaking_manager:hero_available_in_lobby_data(i4, v_2) then
							flag_6 = true

							break
						end
					end

					if not flag_6 and not user_setting then
						flag_4 = true
					else
						flag_3 = true
						var_14_17 = "hero is unavailable"
					end
				end

				local var_14_23 = LevelSettings[v_2.mission_id]

				if not (flag_3 or var_14_23.hub_level) then
					if not strict_matchmaking then
						flag_3 = true
						var_14_17 = "strict matchmaking"
					else
						flag_4 = true
					end
				end

				if not ((flag_3 or not strict_matchmaking) and v_2.selected_mission_id == mission_id) then
					flag_3 = true
					var_14_17 = "strict matchmaking"
				end

				if not (flag_3 or v_2.host_afk ~= "true") then
					flag_4 = true
				end

				if not ((flag_3 or not flag_4) and flag_2) then
					flag_3 = true
					var_14_17 = "secondary lobby before reaching max distance"
				end

				if not flag_3 then
					if not flag_4 then
						var_14_10 = self:_compare_first_prio_lobbies(var_14_10, v_2)
					else
						var_14_11 = self:_compare_secondary_prio_lobbies(var_14_11, v_2)
					end
				else
					mm_printf("Lobby hosted by %s discarded due to '%s'", unique_server_name, var_14_17 or "unknown")
				end
			else
				mm_printf("Lobby hosted by %s failed lobby match due to '%s'", unique_server_name, var_14_15 or "unknown")
			end
		end
	end

	return var_14_10 or var_14_11
end
