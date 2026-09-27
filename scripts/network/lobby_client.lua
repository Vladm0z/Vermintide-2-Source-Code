-- chunkname: @scripts/network/lobby_client.lua

require("scripts/network/lobby_aux")

LobbyClient = class(LobbyClient)

LobbyClient.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.lobby = arg_1_3 or LobbyInternal.join_lobby(arg_1_2)
	self.stored_lobby_data = arg_1_2

	local config_file_name = arg_1_1.config_file_name
	local project_hash = arg_1_1.project_hash

	self.network_hash = LobbyAux.create_network_hash(config_file_name, project_hash)
	self.peer_id = Network.peer_id()
	self._host_peer_id = nil
	self._host_channel_id = nil
	self.is_host = false

	if not HAS_STEAM then
		self:set_steam_lobby_reconnectable(true)
	end

	mm_printf("LobbyClient Created")
end

LobbyClient.destroy = function (self)
	-- function 2
	local _host_peer_id = self._host_peer_id
	local _host_channel_id = self._host_channel_id

	if not _host_channel_id then
		printf("LobbyClient close server channel %s to %s", tostring(_host_channel_id), _host_peer_id)
		LobbyInternal.close_channel(self.lobby, _host_channel_id)

		PEER_ID_TO_CHANNEL[_host_peer_id] = nil
		CHANNEL_TO_PEER_ID[_host_channel_id] = nil
	end

	mm_printf("LobbyClient Destroyed")

	self._host_peer_id = nil
	self._host_channel_id = nil

	LobbyInternal.leave_lobby(self.lobby)

	self.lobby_members = nil
	self.lobby = nil
	self.has_sent_join = false

	GarbageLeakDetector.register_object(self, "Lobby Client")
end

LobbyClient.update = function (self, arg_3_1)
	-- function 3
	local lobby = self.lobby
	local lobby_host = lobby:lobby_host()
	local state = lobby.state(lobby)
	local state_2 = self.state

	if state ~= state_2 then
		printf("[LobbyClient] Changed state from %s to %s", tostring(state_2), state)

		self.state = state

		if state == LobbyState.JOINED then
			local lobby_members = self.lobby_members

			lobby_members = lobby_members or LobbyMembers:new(lobby, self.client)
			self.lobby_members = lobby_members

			Managers.party:set_leader(lobby_host)

			self._look_for_host = true
			self._reconnecting_to_lobby = nil
			self._try_reconnecting = nil
			self._reconnect_times = nil

			Managers.account:update_presence()
			print("[LobbyClient] connected to lobby, id:", self.stored_lobby_data.id)
		end

		if state_2 == LobbyState.JOINED then
			Managers.party:set_leader(nil)

			if not self.lobby_members then
				self.lobby_members:clear()

				self.has_sent_join = false
			end
		end

		if not (not self._reconnecting_to_lobby and state ~= LobbyState.FAILED) then
			self._reconnecting_to_lobby = false
			self._try_reconnecting = not self._reconnect_times and self._reconnect_times < 10
		end
	end

	if not self._look_for_host then
		local lobby_host_2 = lobby:lobby_host()

		printf("====== Looking for host: %s", tostring(lobby_host_2))

		if lobby_host_2 ~= nil then
			local open_channel = LobbyInternal.open_channel(lobby, lobby_host_2)

			self._host_peer_id = lobby_host_2
			self._host_channel_id = open_channel
			PEER_ID_TO_CHANNEL[lobby_host_2] = open_channel
			CHANNEL_TO_PEER_ID[open_channel] = lobby_host_2

			printf("Connected to host: %s, using channel: %d", lobby_host_2, open_channel)

			self._look_for_host = nil
		end
	end

	if not self.lobby_members then
		self.lobby_members:update()

		local peer_id = self.peer_id
		local get_members_left = self.lobby_members:get_members_left()

		for i = 1, #get_members_left do
			local var_3_9 = get_members_left[i]

			if var_3_9 == peer_id then
				self._lost_connection_to_lobby = true
				self._try_reconnecting = var_3_9 == peer_id

				print("[LobbyClient] Lost connection to the lobby")
			end
		end
	end

	if not HAS_STEAM and not self._lobby_reconnectable_on_disconnect and not self:lost_connection_to_lobby() and self._reconnecting_to_lobby or not self._try_reconnecting then
		local print = print
		local str = "[LobbyClient] Attempting to rejoin lobby"
		local id = self.stored_lobby_data.id
		local str_2 = "Retries:"
		local _reconnect_times = self._reconnect_times

		_reconnect_times = _reconnect_times or 0

		print(str, id, str_2, _reconnect_times)

		local _host_peer_id = self._host_peer_id
		local _host_channel_id = self._host_channel_id

		if not _host_channel_id then
			printf("LobbyClient close server channel %s to %s", tostring(_host_channel_id), _host_peer_id)
			LobbyInternal.close_channel(self.lobby, _host_channel_id)

			PEER_ID_TO_CHANNEL[_host_peer_id] = nil
			CHANNEL_TO_PEER_ID[_host_channel_id] = nil
		end

		LobbyInternal.leave_lobby(self.lobby)

		self.lobby = LobbyInternal.join_lobby(self.stored_lobby_data)
		self.state = nil

		if not self.lobby_members then
			self.lobby_members:clear()

			self.has_sent_join = false
		end

		local _reconnect_times_2 = self._reconnect_times

		_reconnect_times_2 = _reconnect_times_2 or 0
		self._reconnect_times = _reconnect_times_2 + 1
		self._reconnecting_to_lobby = true
		self._try_reconnecting = false
	end
end

LobbyClient.set_steam_lobby_reconnectable = function (self, arg_4_1)
	-- function 4
	local print = print
	local flag

	flag = not arg_4_1 and "Enabled" and "Disabled"

	print(flag, "live steam lobby reconnecting")

	self._lobby_reconnectable_on_disconnect = arg_4_1
end

LobbyClient.get_stored_lobby_data = function (self)
	-- function 5
	return self.stored_lobby_data
end

LobbyClient.update_user_names = function (self)
	-- function 6
	if not IS_PS4 then
		self.lobby:update_user_names()
	end
end

LobbyClient.members = function (self)
	-- function 7
	return self.lobby_members
end

LobbyClient.invite_target = function (self)
	-- function 8
	return self.lobby
end

LobbyClient.is_dedicated_server = function (arg_9_0)
	-- function 9
	return false
end

LobbyClient.lobby_host = function (self)
	-- function 10
	return self._host_peer_id
end

LobbyClient.lobby_data = function (self, arg_11_1)
	-- function 11
	return self.lobby:data(arg_11_1)
end

LobbyClient.has_user_name = function (self, arg_12_1)
	-- function 12
	return self.lobby:user_name(arg_12_1) ~= nil
end

LobbyClient.user_name = function (self, arg_13_1)
	-- function 13
	if not HAS_STEAM then
		return string.gsub(Steam.user_name(), "%c", "")
	elseif not IS_PS4 then
		return string.gsub(self.lobby:user_name(arg_13_1), "%c", "")
	else
		return arg_13_1
	end
end

LobbyClient.is_joined = function (self)
	-- function 14
	return self.state == LobbyState.JOINED
end

LobbyClient.failed = function (self)
	-- function 15
	return self.state == LobbyState.FAILED
end

LobbyClient.id = function (self)
	-- function 16
	local lobby_id

	if not LobbyInternal.lobby_id then
		lobby_id = LobbyInternal.lobby_id(self.lobby)

		if not lobby_id then
			-- Nothing
		end
	end

	lobby_id = "no_id"

	::label_16_0::

	return lobby_id
end

LobbyClient.attempting_reconnect = function (self)
	-- function 17
	local _reconnecting_to_lobby = self._reconnecting_to_lobby

	_reconnecting_to_lobby = _reconnecting_to_lobby or self._try_reconnecting

	return _reconnecting_to_lobby
end

LobbyClient._free_lobby = function (self)
	-- function 18
	if self.lobby ~= nil then
		LobbyInternal.leave_lobby(self.lobby)

		self.lobby = nil
	end
end

LobbyClient.lost_connection_to_lobby = function (self)
	-- function 19
	local is_orphaned = LobbyInternal.is_orphaned(self.lobby)

	is_orphaned = is_orphaned or self._lost_connection_to_lobby

	return is_orphaned
end

LobbyClient.game_session_host = function (self)
	-- function 20
	return LobbyInternal.game_session_host(self.lobby)
end
