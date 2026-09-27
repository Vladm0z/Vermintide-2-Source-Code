-- chunkname: @scripts/managers/matchmaking/matchmaking_state_search_player_hosted_lobby.lua

MatchmakingStateSearchPlayerHostedLobby = class(MatchmakingStateSearchPlayerHostedLobby)
MatchmakingStateSearchPlayerHostedLobby.NAME = "MatchmakingStateSearchPlayerHostedLobby"

MatchmakingStateSearchPlayerHostedLobby.init = function (self, arg_1_1)
	-- function 1
	self._lobby = arg_1_1.lobby
	self._lobby_finder = arg_1_1.lobby_finder
	self._peer_id = Network.peer_id()
	self._matchmaking_manager = arg_1_1.matchmaking_manager
	self._network_server = arg_1_1.network_server
	self._statistics_db = arg_1_1.statistics_db
	Managers.matchmaking.countdown_has_finished = false
end

MatchmakingStateSearchPlayerHostedLobby.destroy = function (arg_2_0)
	-- function 2
	return
end

MatchmakingStateSearchPlayerHostedLobby.on_enter = function (self, arg_3_1)
	-- function 3
	self._state_context = arg_3_1
	self._search_config = arg_3_1.search_config

	self:_initialize_search()
end

MatchmakingStateSearchPlayerHostedLobby._initialize_search = function (self)
	-- function 4
	local _search_config = self._search_config
	local tbl = {}

	if not _search_config.quick_game then
		local mission_id = _search_config.mission_id

		if not mission_id then
			tbl.selected_mission_id = {
				comparison = "equal",
				value = mission_id
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
		value = _search_config.mechanism
	}
	self._current_filters = tbl
	self._current_distance_filter = "close"
	self._current_near_filters = {}

	self._matchmaking_manager:setup_filter_requirements(1, self._current_distance_filter, self._current_filters, self._current_near_filters)

	local get_stored_lobby_data = self._lobby:get_stored_lobby_data()

	get_stored_lobby_data.matchmaking = "searching"

	self._lobby:set_lobby_data(get_stored_lobby_data)
	Managers.level_transition_handler:clear_next_level()
	self._lobby_finder:refresh()

	local local_player = Managers.player:local_player()

	Managers.telemetry_events:matchmaking_search(local_player, self._search_config)
	self._matchmaking_manager:send_system_chat_message("matchmaking_status_start_search")
end

MatchmakingStateSearchPlayerHostedLobby.on_exit = function (arg_5_0)
	-- function 5
	return
end

MatchmakingStateSearchPlayerHostedLobby.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self._lobby_finder:update(arg_6_1)

	if not self._lobby_finder:is_refreshing() then
		return
	end

	local _search_for_game = self:_search_for_game(arg_6_1)

	if not _search_for_game then
		self._matchmaking_manager:send_system_chat_message("matchmaking_status_found_game")

		self._state_context.join_lobby_data = _search_for_game

		return MatchmakingStateReserveSlotsPlayerHosted, self._state_context
	else
		local _current_distance_filter = self._current_distance_filter
		local get_next_lobby_distance_filter = LobbyAux.get_next_lobby_distance_filter(_current_distance_filter, MatchmakingSettings.max_distance_filter)

		if get_next_lobby_distance_filter ~= nil then
			mm_printf("Changing distance filter from %s to %s", _current_distance_filter, get_next_lobby_distance_filter)
			self._matchmaking_manager:setup_filter_requirements(1, get_next_lobby_distance_filter, self._current_filters, self._current_near_filters)

			self._current_distance_filter = get_next_lobby_distance_filter

			self._matchmaking_manager:send_system_chat_message("matchmaking_status_increased_search_range")
		end

		self._lobby_finder:refresh()
	end
end

local tbl = {}

MatchmakingStateSearchPlayerHostedLobby._search_for_game = function (self, arg_7_1)
	-- function 7
	local lobbies = self._lobby_finder:lobbies()
	local _search_config = self._search_config
	local _matchmaking_manager = self._matchmaking_manager
	local var_7_3
	local mission_id = _search_config.mission_id

	if not mission_id then
		var_7_3 = {
			mission_id
		}
	else
		var_7_3 = table.clone(Managers.mechanism:mechanism_setting_for_title("map_pool"))
		var_7_3[#var_7_3 + 1] = "any"
	end

	return self:_find_suitable_lobby(lobbies, _search_config, var_7_3)
end

MatchmakingStateSearchPlayerHostedLobby._find_suitable_lobby = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local mission_id = arg_8_2.mission_id
	local difficulty = arg_8_2.difficulty
	local matchmaking_type = arg_8_2.matchmaking_type
	local mechanism = arg_8_2.mechanism
	local max_distance_filter = MatchmakingSettings.max_distance_filter
	local flag = self._current_distance_filter == max_distance_filter
	local var_8_6
	local var_8_7
	local _matchmaking_manager = self._matchmaking_manager

	for k, v in pairs(arg_8_3) do
		for i, v_2 in ipairs(arg_8_1) do
			local _lobby_match, var_8_10 = self:_lobby_match(v_2, v, difficulty, matchmaking_type, self._peer_id)

			if not _lobby_match then
				local flag_2 = false
				local var_8_12
				local flag_3 = false

				if not LevelSettings[v_2.mission_id].hub_level then
					flag_3 = true
				end

				if v_2.host_afk == "true" then
					flag_3 = true
				end

				if not (not flag_3 and flag) then
					flag_2 = true
					var_8_12 = "secondary lobby before reaching max distance"
				end

				if not flag_2 then
					if not flag_3 then
						var_8_6 = self:_compare_first_prio_lobbies(var_8_6, v_2)
					else
						var_8_7 = self:_compare_secondary_prio_lobbies(var_8_7, v_2)
					end
				else
					local unique_server_name = v_2.unique_server_name

					unique_server_name = unique_server_name or v_2.host

					print("[MatchmakingStateSearchPlayerHostedLobby] Lobby hosted by %s discarded due to '%s'", unique_server_name, var_8_12 or "unknown")
				end
			else
				local unique_server_name_2 = v_2.unique_server_name

				unique_server_name_2 = unique_server_name_2 or v_2.host

				print("[MatchmakingStateSearchPlayerHostedLobby] Lobby hosted by %s failed lobby match due to '%s'", unique_server_name_2, var_8_10 or "unknown")
			end
		end

		if not var_8_6 then
			break
		end
	end

	return var_8_6 or var_8_7
end

MatchmakingStateSearchPlayerHostedLobby._lobby_match = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local search_config = self._state_context.search_config
	local _matchmaking_manager = self._matchmaking_manager
	local id = arg_9_1.id

	if not _matchmaking_manager:lobby_listed_as_broken(id) then
		return false, "lobby listed as broken"
	end

	if arg_9_1.host == arg_9_5 then
		return false, "players own lobby"
	end

	if not IS_WINDOWS then
		local deserialize_lobby_reservation_data = LobbyAux.deserialize_lobby_reservation_data(arg_9_1)

		for i = 1, #deserialize_lobby_reservation_data do
			local var_9_4 = deserialize_lobby_reservation_data[i]

			for j = 1, #var_9_4 do
				local peer_id = var_9_4[j].peer_id
				local relationship = Friends.relationship(peer_id)

				if not (relationship == 5 or relationship == 6) then
					return false, "user blocked"
				end
			end
		end
	end

	if arg_9_1.twitch_enabled == "true" then
		return false, "twitch_mode"
	end

	if not (arg_9_1.matchmaking == "false" or arg_9_1.valid) then
		return false, "lobby is not valid"
	end

	if not arg_9_2 then
		local flag = false
		local str = "<no lobby level>"

		if not arg_9_1.selected_mission_id then
			flag = arg_9_1.selected_mission_id == arg_9_2
			str = string.format("(%s ~= %s)", arg_9_2, arg_9_1.selected_mission_id)
		elseif not arg_9_1.mission_id then
			flag = arg_9_1.mission_id == arg_9_2
			str = string.format("(%s ~= %s)", arg_9_2, arg_9_1.mission_id)
		end

		if not flag then
			return false, "wrong mission " .. str
		end
	end

	if not (not arg_9_3 and arg_9_1.difficulty == arg_9_3) then
		return false, "wrong difficulty"
	end

	local party_lobby_host = search_config.party_lobby_host
	local flag_2 = not party_lobby_host and party_lobby_host:members()
	local flag_3 = not flag_2 and flag_2:get_members()
	local get_matchmaking_settings_for_mechanism = Managers.matchmaking.get_matchmaking_settings_for_mechanism(arg_9_1.mechanism)
	local count

	if not flag_3 then
		count = #flag_3

		if not count then
			-- Nothing
		end
	end

	count = 1

	::label_9_0::

	local num_players = arg_9_1.num_players

	num_players = not num_players and tonumber(arg_9_1.num_players)

	local max_number_of_players = search_config.max_number_of_players

	max_number_of_players = max_number_of_players or get_matchmaking_settings_for_mechanism.MAX_NUMBER_OF_PLAYERS

	if not (not num_players and max_number_of_players >= num_players + count) then
		return false, "not enough empty slots"
	end

	return true
end

MatchmakingStateSearchPlayerHostedLobby._compare_first_prio_lobbies = function (self, arg_10_1, arg_10_2)
	-- function 10
	if arg_10_1 == nil then
		return arg_10_2
	end

	local _search_config = self._search_config

	return arg_10_1
end

MatchmakingStateSearchPlayerHostedLobby._compare_secondary_prio_lobbies = function (self, arg_11_1, arg_11_2)
	-- function 11
	if arg_11_1 == nil then
		return arg_11_2
	end

	local _search_config = self._search_config

	return arg_11_1
end
