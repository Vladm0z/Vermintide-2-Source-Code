-- chunkname: @scripts/network/game_server/game_server.lua

require("scripts/network/game_server/game_server_aux")
require("scripts/network/lobby_members")

local game_server_testify = script_data.testify

GameServer = class(GameServer)

local function dprintf(string, ...)
	-- function 1
	local s = string.format(string, ...)

	printf("[GameServer]: %s", s)
end

GameServer.init = function (self, network_options, server_name)
	-- function 2
	dprintf("Initializing game server...")

	local config_file_name = network_options.config_file_name
	local project_hash = network_options.project_hash

	self._network_hash = GameServerAux.create_network_hash(config_file_name, project_hash)

	assert(network_options.max_members, "Has to pass max_members to GameServer")

	self._max_members = network_options.max_members
	self._game_server = GameServerInternal.init_server(network_options, server_name)
	self._data_table = {}
	self._server_name = server_name
	self._network_initialized = false
	self.is_host = true
end

GameServer.kick_all_except = function (self, ignored_peers)
	-- function 3
	if GameServerInternal.remove_member then
		ignored_peers = ignored_peers or {}

		local my_peer_id = self._data_table.host

		for _, peer_id in ipairs(self._members) do
			if peer_id ~= my_peer_id and not ignored_peers[peer_id] then
				GameServerInternal.remove_member(self._game_server, peer_id)
			end
		end
	end
end

GameServer.destroy = function (self)
	-- function 4
	dprintf("Shutting down game server")

	self._members = nil
	self._data_table = nil

	GameServerInternal.shutdown_server(self._game_server)

	self._game_server = nil

	GarbageLeakDetector.register_object(self, "Game Server")
end

GameServer.update = function (self, dt, t)
	-- function 5
	local game_server = self._game_server
	local new_state = game_server:state()
	local old_state = self._state

	if new_state ~= old_state then
		dprintf("Changing state from %s to %s", old_state, new_state)

		self._state = new_state

		if new_state == "connected" then
			local data_table = self._data_table

			data_table.network_hash = self._network_hash

			for key, value in pairs(data_table) do
				game_server:set_data(key, value)
			end

			self._members = self._members

			if not GameServer._peer_id_property_set then
				GameServer._peer_id_property_set = true

				Crashify.print_property("peer_id", Network.peer_id())
			end
		end

		if old_state == "connected" and self._members then
			self._members:clear()
		end
	end

	local members = self._members

	if members then
		members:update()
	end

	GameServerInternal.run_callbacks(self._game_server, self)

	if script_data.testify then
		Testify:poll_requests_through_handler(game_server_testify, self)
	end

	return self._state
end

GameServer.ping_by_peer = function (self, peer_id)
	-- function 6
	return GameServerInternal.ping(peer_id)
end

GameServer.remove_peer = function (self, peer_id)
	-- function 7
	self._game_server:remove_member(peer_id)
end

GameServer.close_channel = function (self, channel_id)
	-- function 8
	GameServerInternal.close_channel(self._game_server, channel_id)
end

GameServer.set_level_name = function (self, name)
	-- function 9
	GameServerInternal.set_level_name(self._game_server, name)
end

GameServer.set_lobby_data = function (self, data)
	-- function 10
	print("Set lobby begin:")

	local internal_data_table = self._data_table
	local game_server = self._game_server

	for key, value in pairs(data) do
		print(string.format("  Lobby data %s = %s", key, tostring(value)))

		internal_data_table[key] = value

		game_server:set_data(key, value)
	end

	print("Set lobby end.")
end

GameServer.get_stored_lobby_data = function (self)
	-- function 11
	return self._data_table
end

GameServer.attempting_reconnect = function (self)
	-- function 12
	return false
end

GameServer.is_dedicated_server = function (self)
	-- function 13
	return true
end

GameServer.lobby_data = function (self, key)
	-- function 14
	return self._game_server:data(key)
end

GameServer.lobby_host = function (self)
	-- function 15
	return Network.peer_id()
end

GameServer.state = function (self)
	-- function 16
	return self._state
end

GameServer.members = function (self)
	-- function 17
	return self._members
end

GameServer.user_name = function (self, peer_id)
	-- function 18
	return GameServerInternal.user_name(self._game_server, peer_id)
end

GameServer.get_max_members = function (self)
	-- function 19
	return self._max_members
end

GameServer.set_max_members = function (self, new_max_members)
	-- function 20
	self._max_members = new_max_members

	GameServerInternal.set_max_members(self._game_server, new_max_members)
end

GameServer.is_joined = function (self)
	-- function 21
	return self._state == "connected"
end

GameServer.id = function (self)
	-- function 22
	return GameServerInternal.server_id and GameServerInternal.server_id(self._game_server) or not GameServerInternal.server_id and "no_id"
end

GameServer.server_name = function (self)
	-- function 23
	return self._server_name
end

GameServer.set_server_name = function (self, server_name)
	-- function 24
	self._server_name = server_name
end

GameServer.set_network_initialized = function (self, initialized)
	-- function 25
	self._network_initialized = initialized
end

GameServer.network_initialized = function (self)
	-- function 26
	return self._network_initialized
end

GameServer.failed = function (self)
	-- function 27
	return self._state == "disconnected"
end

GameServer.server_member_added = function (self, peer_id)
	-- function 28
	printf("Member %s was added", peer_id)
end

GameServer.server_slot_allocation_request = function (self, reserver, peers, invitee)
	-- function 29
	if Managers.mechanism:try_reserve_game_server_slots(reserver, peers, invitee) then
		printf("Request by %s to allocate %d slots was approved", reserver, #peers)

		return true
	else
		printf("Request by %s to allocate %d slots was disapproved", reserver, #peers)

		return false
	end
end

GameServer.server_slot_expired = function (self, peer_id)
	-- function 30
	Managers.mechanism:game_server_slot_reservation_expired(peer_id)
	printf("Server slot %s was deallocated", peer_id)
end

GameServer.lost_connection_to_lobby = function (self)
	-- function 31
	return false
end
