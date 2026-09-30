-- chunkname: @scripts/network/game_server/game_server_client.lua

require("scripts/network/game_server/game_server_aux")

GameServerLobbyClient = class(GameServerLobbyClient)

local function dprintf(string, ...)
	-- function 1
	local s = string.format(string, ...)

	printf("[GameServerLobbyClient]: %s", s)
end

GameServerLobbyClient.init = function (self, network_options, game_server_data, password, reserve_peers)
	-- function 2
	dprintf("Joining lobby on address %s", game_server_data.server_info.ip_port)

	self._game_server_info = game_server_data.server_info
	self.peer_id = Network.peer_id()

	if reserve_peers then
		self._game_server_lobby = GameServerInternal.reserve_server(self._game_server_info, password, reserve_peers)
	else
		self._game_server_lobby = GameServerInternal.join_server(self._game_server_info, password)
	end

	self._game_server_lobby_data = game_server_data

	local config_file_name = network_options.config_file_name
	local project_hash = network_options.project_hash

	self._network_hash = GameServerAux.create_network_hash(config_file_name, project_hash)
	self.lobby = self._game_server_lobby
	self.network_hash = self._network_hash
	self._is_party_host = not Managers.state.network or Managers.state.network.is_server
	self._advertising_playing = true
	self.is_host = false
end

GameServerLobbyClient.lobby_host = function (self)
	-- function 3
	return GameServerInternal.lobby_host(self._game_server_lobby)
end

GameServerLobbyClient.destroy = function (self)
	-- function 4
	dprintf("Destroying Game Server Client, leaving server...")

	local host = GameServerInternal.lobby_host(self._game_server_lobby)
	local channel_id = PEER_ID_TO_CHANNEL[host]

	printf("closing channel %s", tostring(channel_id))

	if channel_id then
		GameServerInternal.close_channel(self._game_server_lobby, channel_id)

		PEER_ID_TO_CHANNEL[host] = nil
		CHANNEL_TO_PEER_ID[channel_id] = nil

		if Managers.mechanism:dedicated_server_peer_id() == host then
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

GameServerLobbyClient.update = function (self, dt)
	-- function 5
	local engine_lobby = self._game_server_lobby
	local new_state = engine_lobby:state()
	local old_state = self._state

	if new_state ~= old_state then
		dprintf("Changing state from %s to %s", old_state, new_state)

		self._state = new_state

		if new_state == "failed" then
			local versus_interface = Managers.backend

			if versus_interface then
				local matchmaking_session_id = versus_interface:get_matchmaking_session_id()

				if matchmaking_session_id then
					local ip_port = self._game_server_info.ip_port

					Crashify.print_exception("GameServerLobbyClient", "State changed from %s to %s for flexmatch server. matchmaking_session_id: %s | ip_port: %s", old_state, new_state, matchmaking_session_id or "MISSING", ip_port)
				end
			end
		elseif new_state == "reserved" then
			local game_server_peer_id = GameServerInternal.lobby_host(engine_lobby)
			local channel_id = GameServerInternal.open_channel(engine_lobby, game_server_peer_id)

			print("[GameServerLobbyClient] Party host open channel to server", game_server_peer_id)

			PEER_ID_TO_CHANNEL[game_server_peer_id] = channel_id
			CHANNEL_TO_PEER_ID[channel_id] = game_server_peer_id
		elseif new_state == "joined" then
			local game_server_peer_id = GameServerInternal.lobby_host(engine_lobby)

			if not PEER_ID_TO_CHANNEL[game_server_peer_id] then
				if self._is_party_host then
					print("[GameServerLobbyClient] Party host open channel to server without reserving", game_server_peer_id)
				else
					print("[GameServerLobbyClient] Party client open channel to server", game_server_peer_id)
				end

				local channel_id = GameServerInternal.open_channel(engine_lobby, game_server_peer_id)

				PEER_ID_TO_CHANNEL[game_server_peer_id] = channel_id
				CHANNEL_TO_PEER_ID[channel_id] = game_server_peer_id
			end

			self._members = self._members
		end

		if old_state == "joined" and self._members then
			self._members:clear()
		end
	end

	if self._members then
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

GameServerLobbyClient.stop_advertise_playing = function (self, force)
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

GameServerLobbyClient.is_dedicated_server = function (self)
	-- function 12
	return true
end

GameServerLobbyClient.lobby_host = function (self)
	-- function 13
	return GameServerInternal.lobby_host(self._game_server_lobby)
end

GameServerLobbyClient.lobby_data = function (self, key)
	-- function 14
	return self._game_server_lobby:data(key)
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
	return GameServerInternal.lobby_id and GameServerInternal.lobby_id(self._game_server_lobby) or not GameServerInternal.lobby_id and "no_id"
end

GameServerLobbyClient.request_data = function (self)
	-- function 20
	self._game_server_lobby:request_data()
end

GameServerLobbyClient.attempting_reconnect = function (self)
	-- function 21
	return false
end

GameServerLobbyClient.lost_connection_to_lobby = function (self)
	-- function 22
	return false
end
