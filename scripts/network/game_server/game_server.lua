-- chunkname: @scripts/network/game_server/game_server.lua

require("scripts/network/game_server/game_server_aux")
require("scripts/network/lobby_members")

local testify = script_data.testify

testify = not testify and require("scripts/network/game_server/testify/game_server_testify")
GameServer = class(GameServer)

local function fn(self, ...)
	-- function 1
	local format = self.format(self, ...)

	printf("[GameServer]: %s", format)
end

GameServer.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	fn("Initializing game server...")

	local config_file_name = arg_2_1.config_file_name
	local project_hash = arg_2_1.project_hash

	self._network_hash = GameServerAux.create_network_hash(config_file_name, project_hash)

	assert(arg_2_1.max_members, "Has to pass max_members to GameServer")

	self._max_members = arg_2_1.max_members
	self._game_server = GameServerInternal.init_server(arg_2_1, arg_2_2)
	self._data_table = {}
	self._server_name = arg_2_2
	self._network_initialized = false
	self.is_host = true
end

GameServer.kick_all_except = function (self, arg_3_1)
	-- function 3
	if not GameServerInternal.remove_member then
		arg_3_1 = arg_3_1 or {}

		local host = self._data_table.host

		for i, v in ipairs(self._members) do
			if not (v == host or arg_3_1[v]) then
				GameServerInternal.remove_member(self._game_server, v)
			end
		end
	end
end

GameServer.destroy = function (self)
	-- function 4
	fn("Shutting down game server")

	self._members = nil
	self._data_table = nil

	GameServerInternal.shutdown_server(self._game_server)

	self._game_server = nil

	GarbageLeakDetector.register_object(self, "Game Server")
end

GameServer.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _game_server = self._game_server
	local state = _game_server:state()
	local _state = self._state

	if state ~= _state then
		fn("Changing state from %s to %s", _state, state)

		self._state = state

		if state == "connected" then
			local _data_table = self._data_table

			_data_table.network_hash = self._network_hash

			for k, v in pairs(_data_table) do
				_game_server:set_data(k, v)
			end

			local _members = self._members

			_members = _members or LobbyMembers:new(_game_server)
			self._members = _members

			if not GameServer._peer_id_property_set then
				GameServer._peer_id_property_set = true

				Crashify.print_property("peer_id", Network.peer_id())
			end
		end

		if _state ~= "connected" or not self._members then
			self._members:clear()
		end
	end

	local _members_2 = self._members

	if not _members_2 then
		_members_2:update()
	end

	GameServerInternal.run_callbacks(self._game_server, self)

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end

	return self._state
end

GameServer.ping_by_peer = function (arg_6_0, arg_6_1)
	-- function 6
	return GameServerInternal.ping(arg_6_1)
end

GameServer.remove_peer = function (self, arg_7_1)
	-- function 7
	self._game_server:remove_member(arg_7_1)
end

GameServer.close_channel = function (self, arg_8_1)
	-- function 8
	GameServerInternal.close_channel(self._game_server, arg_8_1)
end

GameServer.set_level_name = function (self, arg_9_1)
	-- function 9
	GameServerInternal.set_level_name(self._game_server, arg_9_1)
end

GameServer.set_lobby_data = function (self, arg_10_1)
	-- function 10
	print("Set lobby begin:")

	local _data_table = self._data_table
	local _game_server = self._game_server

	for k, v in pairs(arg_10_1) do
		print(string.format("  Lobby data %s = %s", k, tostring(v)))

		_data_table[k] = v

		_game_server:set_data(k, v)
	end

	print("Set lobby end.")
end

GameServer.get_stored_lobby_data = function (self)
	-- function 11
	return self._data_table
end

GameServer.attempting_reconnect = function (arg_12_0)
	-- function 12
	return false
end

GameServer.is_dedicated_server = function (arg_13_0)
	-- function 13
	return true
end

GameServer.lobby_data = function (self, arg_14_1)
	-- function 14
	return self._game_server:data(arg_14_1)
end

GameServer.lobby_host = function (arg_15_0)
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

GameServer.user_name = function (self, arg_18_1)
	-- function 18
	return GameServerInternal.user_name(self._game_server, arg_18_1)
end

GameServer.get_max_members = function (self)
	-- function 19
	return self._max_members
end

GameServer.set_max_members = function (self, arg_20_1)
	-- function 20
	self._max_members = arg_20_1

	GameServerInternal.set_max_members(self._game_server, arg_20_1)
end

GameServer.is_joined = function (self)
	-- function 21
	return self._state == "connected"
end

GameServer.id = function (self)
	-- function 22
	local server_id

	if not GameServerInternal.server_id then
		server_id = GameServerInternal.server_id(self._game_server)

		if not server_id then
			-- Nothing
		end
	end

	server_id = "no_id"

	::label_22_0::

	return server_id
end

GameServer.server_name = function (self)
	-- function 23
	return self._server_name
end

GameServer.set_server_name = function (self, arg_24_1)
	-- function 24
	self._server_name = arg_24_1
end

GameServer.set_network_initialized = function (self, arg_25_1)
	-- function 25
	self._network_initialized = arg_25_1
end

GameServer.network_initialized = function (self)
	-- function 26
	return self._network_initialized
end

GameServer.failed = function (self)
	-- function 27
	return self._state == "disconnected"
end

GameServer.server_member_added = function (arg_28_0, arg_28_1)
	-- function 28
	printf("Member %s was added", arg_28_1)
end

GameServer.server_slot_allocation_request = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	if not Managers.mechanism:try_reserve_game_server_slots(arg_29_1, arg_29_2, arg_29_3) then
		printf("Request by %s to allocate %d slots was approved", arg_29_1, #arg_29_2)

		return true
	else
		printf("Request by %s to allocate %d slots was disapproved", arg_29_1, #arg_29_2)

		return false
	end
end

GameServer.server_slot_expired = function (arg_30_0, arg_30_1)
	-- function 30
	Managers.mechanism:game_server_slot_reservation_expired(arg_30_1)
	printf("Server slot %s was deallocated", arg_30_1)
end

GameServer.lost_connection_to_lobby = function (arg_31_0)
	-- function 31
	return false
end
