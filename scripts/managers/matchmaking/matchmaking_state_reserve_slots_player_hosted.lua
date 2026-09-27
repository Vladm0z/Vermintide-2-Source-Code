-- chunkname: @scripts/managers/matchmaking/matchmaking_state_reserve_slots_player_hosted.lua

MatchmakingStateReserveSlotsPlayerHosted = class(MatchmakingStateReserveSlotsPlayerHosted)
MatchmakingStateReserveSlotsPlayerHosted.NAME = "MatchmakingStateReserveSlotsPlayerHosted"

MatchmakingStateReserveSlotsPlayerHosted.init = function (self, arg_1_1)
	-- function 1
	self._lobby = arg_1_1.lobby
	self._network_options = arg_1_1.network_options
	self._matchmaking_manager = arg_1_1.matchmaking_manager
	self._network_transmit = arg_1_1.network_transmit
	self._is_server = arg_1_1.is_server
	self._state = "waiting_to_join_lobby"
end

MatchmakingStateReserveSlotsPlayerHosted.destroy = function (self)
	-- function 2
	if self._password_request ~= nil then
		self._password_request:destroy()

		self._password_request = nil
	end
end

MatchmakingStateReserveSlotsPlayerHosted.on_enter = function (self, arg_3_1)
	-- function 3
	self._state_context = arg_3_1
	self._search_config = arg_3_1.search_config
	self._reservation_reply = nil
	self._connected_to_server = false
	self._connect_timeout = nil
	self._current_lobby = Managers.state.network:lobby()
	self._joined_peers = {}

	local join_lobby_data = arg_3_1.join_lobby_data

	if not Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:make_lobby(LobbyClient, "matchmaking_join_lobby", "MatchmakingStateReserveSlotsPlayerHosted (on_enter)", self._network_options, join_lobby_data)
	end

	self._matchmaking_manager.debug.text = "Joining lobby"

	local debug = self._matchmaking_manager.debug
	local str = "hosted by: "
	local host = join_lobby_data.host

	host = host or "<no_host_name>"
	debug.state = str .. host

	self._matchmaking_manager:send_system_chat_message("matchmaking_status_starting_handshake")
end

MatchmakingStateReserveSlotsPlayerHosted.on_exit = function (arg_4_0)
	-- function 4
	return
end

MatchmakingStateReserveSlotsPlayerHosted.terminate = function (arg_5_0)
	-- function 5
	if not Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end
end

MatchmakingStateReserveSlotsPlayerHosted.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_update_states(arg_6_1, arg_6_2)

	return self._new_state, self._state_context
end

MatchmakingStateReserveSlotsPlayerHosted._update_states = function (self, arg_7_1, arg_7_2)
	-- function 7
	local query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if not query_lobby then
		return self:_join_game_failed("failure_start_join_server")
	else
		query_lobby:update(arg_7_1)

		if not query_lobby:failed() then
			return self:_join_game_failed("failure_start_join_server")
		end
	end

	local lobby_host = query_lobby:lobby_host()
	local id = query_lobby:id()
	local _state = self._state

	if _state == "waiting_to_join_lobby" then
		if not (not query_lobby:is_joined() and lobby_host == "0") then
			self._matchmaking_manager.debug.text = "Connecting to host"

			mm_printf("Joined lobby, checking network hash...")

			self._check_network_hash_timeout = arg_7_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
			self._state = "verify_not_blocked"
		end
	elseif _state == "verify_not_blocked" then
		local lobby_host_2 = query_lobby:lobby_host()
		local relationship = Friends.relationship(lobby_host_2)

		if not (relationship == Friends.IGNORED or relationship ~= Friends.IGNORED_FRIEND) then
			return self:_join_game_failed("user_blocked")
		end

		self._state = "waiting_to_connect"
		self._connect_timeout = arg_7_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
	elseif _state == "waiting_to_connect" then
		if not self._connected_to_server then
			if not self._is_server then
				self._state = "waiting_for_peers_to_join"
				self._waiting_for_peers_to_join_timout = arg_7_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME

				return self:_join_game_success(arg_7_2)
			else
				self._waiting_for_confirmation_timout = arg_7_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
				self._state = "waiting_for_confirmation"

				return self:_join_game_success(arg_7_2)
			end
		elseif arg_7_2 > self._connect_timeout then
			local user_name

			if not LobbyInternal.user_name then
				user_name = LobbyInternal.user_name(lobby_host)

				if not user_name then
					-- Nothing
				end
			end

			user_name = "-"

			::label_7_0::

			mm_printf_force("Failed to connect to host due to timeout. lobby_id=%s, host_id:%s", id, user_name)

			return self:_join_game_failed("connection_timeout")
		end
	elseif _state == "waiting_for_peers_to_join" then
		if not self:_all_players_joined() then
			self._state = "request_reservation"
		elseif arg_7_2 > self._waiting_for_peers_to_join_timout then
			return self:_join_game_failed("join_timeout")
		end
	elseif _state == "request_reservation" then
		self._matchmaking_manager.debug.text = "Requesting reservation"

		mm_printf("Connected, request reservation...")

		local get_members = self._lobby:members():get_members()

		self._network_transmit:send_rpc("rpc_matchmaking_request_reserve_slots", lobby_host, id, get_members)

		self._reservation_timeout = arg_7_2 + MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME
		self._state = "asking_for_reservation"
	elseif _state == "asking_for_reservation" then
		local num = MatchmakingSettings.REQUEST_JOIN_LOBBY_REPLY_TIME - (self._reservation_timeout - arg_7_2)

		self._matchmaking_manager.debug.text = string.format("Requesting to reserve slots %s [%.0f]", query_lobby:id(), num)

		local user_name_2

		if not LobbyInternal.user_name then
			user_name_2 = LobbyInternal.user_name(lobby_host)

			if not user_name_2 then
				-- Nothing
			end
		end

		user_name_2 = "-"

		::label_7_1::

		local _reservation_reply = self._reservation_reply

		if arg_7_2 > self._reservation_timeout then
			mm_printf_force("Failed to reserve slots due to timeout. lobby_id=%s, host_id:%s", id, user_name_2)

			return self:_join_game_failed("connection_timeout")
		elseif _reservation_reply ~= nil then
			if _reservation_reply == "lobby_ok" then
				mm_printf("Successfully reserved slots after %.2f seconds: lobby_id=%s host_id:%s", num, id, user_name_2)

				return self:_reservation_success(true)
			else
				mm_printf_force("Failed to reserve slots  due to host responding '%s'. lobby_id=%s, host_id:%s", _reservation_reply, id, user_name_2)

				return self:_reservation_success(false)
			end
		end
	elseif _state == "waiting_for_confirmation" then
		-- Nothing
	end
end

MatchmakingStateReserveSlotsPlayerHosted._join_game_success = function (self, arg_8_1)
	-- function 8
	local flag = true

	if not self._is_server then
		self._joined_peers[Network.peer_id()] = flag

		local join_lobby_data = self._state_context.join_lobby_data

		self._network_transmit:send_rpc_clients("rpc_matchmaking_client_join_player_hosted", join_lobby_data.id)
	else
		local lobby_host = self._current_lobby:lobby_host()

		self._network_transmit:send_rpc("rpc_matchmaking_client_joined_player_hosted", lobby_host, flag)
	end
end

MatchmakingStateReserveSlotsPlayerHosted._join_game_failed = function (self, arg_9_1)
	-- function 9
	print("[MatchmakingStateReserveSlotsPlayerHosted] FAILED: " .. arg_9_1)

	local flag = false

	if not self._is_server then
		self._joined_peers[Network.peer_id()] = false

		self._network_transmit:send_rpc_clients("rpc_matchmaking_reservation_success", flag)
	else
		local lobby_host = self._current_lobby:lobby_host()

		self._network_transmit:send_rpc("rpc_matchmaking_client_joined_player_hosted", lobby_host, flag)
	end

	self:_cancel_join()
end

MatchmakingStateReserveSlotsPlayerHosted._reservation_success = function (self, arg_10_1)
	-- function 10
	if not self._is_server then
		self._network_transmit:send_rpc_clients("rpc_matchmaking_reservation_success", arg_10_1)
	end

	if not arg_10_1 then
		self._state = "done"
		self._new_state = MatchmakingStateWaitJoinPlayerHosted
	else
		self:_cancel_join()
	end
end

MatchmakingStateReserveSlotsPlayerHosted._cancel_join = function (self)
	-- function 11
	if not Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end

	self._matchmaking_manager:reset_joining()

	self._state_context.join_lobby_data = nil

	local join_by_lobby_browser = self._state_context.join_by_lobby_browser
	local friend_join = self._state_context.friend_join

	if not (not self._is_server and join_by_lobby_browser or friend_join) then
		if not self._search_config.dedicated_server then
			self._new_state = MatchmakingStateReserveLobby
		else
			self._new_state = MatchmakingStateSearchPlayerHostedLobby
		end
	else
		Managers.matchmaking:cancel_matchmaking()
	end
end

MatchmakingStateReserveSlotsPlayerHosted._all_players_joined = function (self)
	-- function 12
	local get_members = self._lobby:members():get_members()
	local flag = true

	for k, v in pairs(get_members) do
		if not self._joined_peers[v] then
			flag = false

			break
		end
	end

	return flag
end

MatchmakingStateReserveSlotsPlayerHosted.rpc_matchmaking_client_joined_player_hosted = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not self._is_server then
		fassert(false, "[MatchmakingStateReserveSlotsPlayerHosted] Server Only function")
	end

	local var_13_0 = CHANNEL_TO_PEER_ID[arg_13_1]

	self._joined_peers[var_13_0] = arg_13_2

	if not arg_13_2 then
		self:_join_game_failed("peer_failed_to_join")
	end
end

MatchmakingStateReserveSlotsPlayerHosted.rpc_matchmaking_request_reserve_slots_reply = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	self._reservation_reply = NetworkLookup.game_ping_reply[arg_14_2]
	self._reservation_reply_variable = arg_14_3
end

MatchmakingStateReserveSlotsPlayerHosted.rpc_matchmaking_reservation_success = function (self, arg_15_1, arg_15_2)
	-- function 15
	if not self._is_server then
		fassert(false, "[MatchmakingStateReserveSlotsPlayerHosted] The lobby host should never receive this")
	end

	if not arg_15_2 then
		self._new_state = MatchmakingStateWaitJoinPlayerHosted
	else
		self:_cancel_join()
	end
end

MatchmakingStateReserveSlotsPlayerHosted.rpc_notify_connected = function (self, arg_16_1)
	-- function 16
	self._connected_to_server = true
end
