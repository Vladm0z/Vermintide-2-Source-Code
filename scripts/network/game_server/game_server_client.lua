-- chunkname: @scripts/network/game_server/game_server_client.lua

require("scripts/network/game_server/game_server_aux")

GameServerLobbyClient = class(GameServerLobbyClient)

local function fn(self, ...)
	-- function 1
	local format = self.format(self, ...)

	printf("[GameServerLobbyClient]: %s", format)
end

GameServerLobbyClient.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	fn("Joining lobby on address %s", arg_2_2.server_info.ip_port)

	self._game_server_info = arg_2_2.server_info
	self.peer_id = Network.peer_id()

	if not arg_2_4 then
		self._game_server_lobby = GameServerInternal.reserve_server(self._game_server_info, arg_2_3, arg_2_4)
	else
		self._game_server_lobby = GameServerInternal.join_server(self._game_server_info, arg_2_3)
	end

	self._game_server_lobby_data = arg_2_2

	local config_file_name = arg_2_1.config_file_name
	local project_hash = arg_2_1.project_hash

	self._network_hash = GameServerAux.create_network_hash(config_file_name, project_hash)
	self.lobby = self._game_server_lobby
	self.network_hash = self._network_hash
	self._is_party_host = not Managers.state.network and Managers.state.network.is_server
	self._advertising_playing = true
	self.is_host = false
end

GameServerLobbyClient.lobby_host = function (self)
	-- function 3
	return GameServerInternal.lobby_host(self._game_server_lobby)
end

GameServerLobbyClient.destroy = function (self)
	-- function 4
	fn("Destroying Game Server Client, leaving server...")

	local lobby_host = GameServerInternal.lobby_host(self._game_server_lobby)
	local var_4_1 = PEER_ID_TO_CHANNEL[lobby_host]

	printf("closing channel %s", tostring(var_4_1))

	if not var_4_1 then
		GameServerInternal.close_channel(self._game_server_lobby, var_4_1)

		PEER_ID_TO_CHANNEL[lobby_host] = nil
		CHANNEL_TO_PEER_ID[var_4_1] = nil

		if Managers.mechanism:dedicated_server_peer_id() == lobby_host then
			Managers.mechanism:reset_dedicated_server_peer_id()
		end
	end

	self:stop_advertise_playing()
	GameServerInternal.leave_server(self._game_server_lobby)

	self._members = nil
	self._game_server_lobby = nil
	self._game_server_lobby_data = nil

	GarbageLeakDetector.register_object(self, "Game Server Client")
end

GameServerLobbyClient.update = function (self, arg_5_1)
	-- function 5
	local _game_server_lobby = self._game_server_lobby
	local state = _game_server_lobby:state()
	local _state = self._state

	if state ~= _state then
		fn("Changing state from %s to %s", _state, state)

		self._state = state

		if state == "failed" then
			local backend = Managers.backend

			backend = not backend and Managers.backend:get_interface("versus")

			if not backend then
				local get_matchmaking_session_id = backend:get_matchmaking_session_id()

				if not get_matchmaking_session_id then
					local ip_port = self._game_server_info.ip_port

					ip_port = ip_port or "MISSING"

					Crashify.print_exception("GameServerLobbyClient", "State changed from %s to %s for flexmatch server. matchmaking_session_id: %s | ip_port: %s", _state, state, get_matchmaking_session_id or "MISSING", ip_port)
				end
			end
		elseif state == "reserved" then
			local lobby_host = GameServerInternal.lobby_host(_game_server_lobby)
			local open_channel = GameServerInternal.open_channel(_game_server_lobby, lobby_host)

			print("[GameServerLobbyClient] Party host open channel to server", lobby_host)

			PEER_ID_TO_CHANNEL[lobby_host] = open_channel
			CHANNEL_TO_PEER_ID[open_channel] = lobby_host
		elseif state == "joined" then
			local lobby_host_2 = GameServerInternal.lobby_host(_game_server_lobby)

			if not PEER_ID_TO_CHANNEL[lobby_host_2] then
				if not self._is_party_host then
					print("[GameServerLobbyClient] Party host open channel to server without reserving", lobby_host_2)
				else
					print("[GameServerLobbyClient] Party client open channel to server", lobby_host_2)
				end

				local open_channel_2 = GameServerInternal.open_channel(_game_server_lobby, lobby_host_2)

				PEER_ID_TO_CHANNEL[lobby_host_2] = open_channel_2
				CHANNEL_TO_PEER_ID[open_channel_2] = lobby_host_2
			end

			local _members = self._members

			_members = _members or LobbyMembers:new(_game_server_lobby)
			self._members = _members
		end

		if _state ~= "joined" or not self._members then
			self._members:clear()
		end
	end

	if not self._members then
		self._members:update()
	end
end

GameServerLobbyClient.claim_reserved = function (self)
	-- function 6
	GameServerInternal.claim_reserved(self._game_server_lobby)
end

GameServerLobbyClient.advertise_playing = function (self)
	-- function 7
	Presence.advertise_playing(self._game_server_info.ip_port)

	self._advertising_playing = true
end

GameServerLobbyClient.stop_advertise_playing = function (self, arg_8_1)
	-- function 8
	if not self._advertising_playing then
		return
	end

	Presence.stop_advertise_playing()

	self._advertising_playing = false
end

GameServerLobbyClient.state = function (self)
	-- function 9
	return self._state
end

GameServerLobbyClient.members = function (self)
	-- function 10
	return self._members
end

GameServerLobbyClient.invite_target = function (self)
	-- function 11
	return self._game_server_info.ip_port
end

GameServerLobbyClient.is_dedicated_server = function (arg_12_0)
	-- function 12
	return true
end

GameServerLobbyClient.lobby_host = function (self)
	-- function 13
	return GameServerInternal.lobby_host(self._game_server_lobby)
end

GameServerLobbyClient.lobby_data = function (self, arg_14_1)
	-- function 14
	return self._game_server_lobby:data(arg_14_1)
end

GameServerLobbyClient.get_stored_lobby_data = function (self)
	-- function 15
	return self._game_server_lobby_data
end

GameServerLobbyClient.ip_address = function (self)
	-- function 16
	return self._game_server_info.ip_port
end

GameServerLobbyClient.is_joined = function (self)
	-- function 17
	return self._state == "joined"
end

GameServerLobbyClient.failed = function (self)
	-- function 18
	return self._state == "failed"
end

GameServerLobbyClient.id = function (self)
	-- function 19
	local lobby_id

	if not GameServerInternal.lobby_id then
		lobby_id = GameServerInternal.lobby_id(self._game_server_lobby)

		if not lobby_id then
			-- Nothing
		end
	end

	lobby_id = "no_id"

	::label_19_0::

	return lobby_id
end

GameServerLobbyClient.request_data = function (self)
	-- function 20
	self._game_server_lobby:request_data()
end

GameServerLobbyClient.attempting_reconnect = function (arg_21_0)
	-- function 21
	return false
end

GameServerLobbyClient.lost_connection_to_lobby = function (arg_22_0)
	-- function 22
	return false
end
