-- chunkname: @scripts/managers/network/lobby_manager.lua

LobbyManager = class(LobbyManager)

LobbyManager.init = function (self)
	-- function 1
	self._lobbies = {}
	self._tags = {}
end

LobbyManager.make_lobby = function (self, arg_2_1, arg_2_2, arg_2_3, ...)
	-- function 2
	fassert(not self._lobbies[arg_2_2], "[LobbyManager] Overwriting existing lobby with handle %s. Tag: %s", arg_2_2, self._tags[arg_2_2])

	local var_2_0 = arg_2_1:new(...)

	self._lobbies[arg_2_2] = var_2_0
	self._tags[arg_2_2] = arg_2_3

	return var_2_0
end

LobbyManager.register_existing_lobby = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	fassert(not self._lobbies[arg_3_2], "[LobbyManager] Overwriting existing lobby with handle %s. Tag: %s", arg_3_2, self._tags[arg_3_2])

	self._lobbies[arg_3_2] = arg_3_1
	self._tags[arg_3_2] = arg_3_3
end

LobbyManager.move_lobby = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	fassert(not self._lobbies[arg_4_2], "[LobbyManager] Overwriting existing lobby with handle %s. Existing tag: %s", arg_4_2, self._tags[arg_4_1])

	self._lobbies[arg_4_2] = self._lobbies[arg_4_1]
	self._tags[arg_4_2] = self._tags[arg_4_1] .. " -> " .. arg_4_3
	self._lobbies[arg_4_1] = nil
	self._tags[arg_4_1] = nil

	print("[LobbyManager] Renaming lobby %s to %s", arg_4_1, arg_4_2)
end

LobbyManager.query_lobby = function (self, arg_5_1)
	-- function 5
	return self._lobbies[arg_5_1]
end

LobbyManager.get_lobby = function (self, arg_6_1)
	-- function 6
	local var_6_0 = self._lobbies[arg_6_1]

	if not var_6_0 then
		ferror("[LobbyManager] Expected lobby with handle %s but found none. Existing lobbies:", arg_6_1, table.tostring(table.map_to_array(self._lobbies, function (arg_7_0)
			-- function 7
			return arg_7_0 .. ": " .. self._tags[arg_7_0]
		end)))
	end

	return var_6_0
end

LobbyManager.destroy_lobby = function (self, arg_8_1)
	-- function 8
	self:free_lobby(arg_8_1):destroy()
end

LobbyManager.free_lobby = function (self, arg_9_1)
	-- function 9
	local var_9_0 = self._lobbies[arg_9_1]

	self._lobbies[arg_9_1] = nil

	return var_9_0
end
