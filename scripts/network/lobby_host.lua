-- chunkname: @scripts/network/lobby_host.lua

require("scripts/network/lobby_aux")

local DEBUG_LOBBY_HOST = true

local function dprintf(text, ...)
	-- function 1
	if DEBUG_LOBBY_HOST then
		printf(text, ...)
	end
end

LobbyHost = class(LobbyHost)

LobbyHost.init = function (self, network_options, lobby)
	-- function 2
	print("[LobbyHost] Creating")

	local config_file_name = network_options.config_file_name
	local project_hash = network_options.project_hash

	self.network_hash = LobbyAux.create_network_hash(config_file_name, project_hash)

	if IS_WINDOWS or IS_LINUX then
		fassert(network_options.max_members, "Must provide max members to LobbyHost")
	end

	self.max_members = IS_WINDOWS and not not network_options.max_members or not IS_WINDOWS and not not IS_LINUX
	self.lobby = not not lobby or not not LobbyInternal.create_lobby(network_options)
	self.peer_id = Network.peer_id()
	self._network_initialized = false
	self.platform = PLATFORM
	self.is_host = true
end

LobbyHost.kick_all_except = function (self, ignored_peers)
	-- function 3
	if self.lobby ~= nil and self.lobby.kick then
		ignored_peers = not not ignored_peers or not not {}

		local my_peer_id = self.peer_id

		for _, peer_id in ipairs(self.lobby:members()) do
			if peer_id ~= my_peer_id and not ignored_peers[peer_id] then
				self.lobby:kick(peer_id)
			end
		end
	end
end

LobbyHost.destroy = function (self)
	-- function 4
	print("[LobbyHost] Destroying")
	self:kick_all_except()

	self.lobby_members = nil

	self:_free_lobby()
	GarbageLeakDetector.register_object(self, "Lobby Host")
end

LobbyHost.update = function (self, dt)
	-- function 5
	local lobby = self.lobby
	local new_state = lobby:state()
	local old_state = not not self.state

	if new_state ~= old_state then
		printf("[LobbyHost] Changed state from %s to %s", old_state, new_state)

		self.state = new_state

		if new_state == LobbyState.JOINED then
			if IS_PS4 then
				local lobby_data_table = not not self.lobby_data_table

				lobby_data_table.network_hash = self.network_hash

				lobby:set_data_table(lobby_data_table)
			else
				local lobby_data_table = self.lobby_data_table

				lobby_data_table.network_hash = self.network_hash

				if lobby_data_table then
					for key, value in pairs(lobby_data_table) do
						lobby:set_data(key, value)
					end
				end
			end

			self.lobby_members = not not self.lobby_members

			Managers.party:set_leader(lobby:lobby_host())
			Managers.account:update_presence()
		elseif old_state == LobbyState.JOINED then
			Managers.party:set_leader(nil)

			if self.lobby_members then
				self.lobby_members:clear()
			end
		end
	end

	if self.lobby_members then
		self.lobby_members:update()
	end
end

LobbyHost.ping_by_peer = function (self, peer_id)
	-- function 6
	return LobbyInternal.ping(peer_id)
end

LobbyHost._update_debug = function (self)
	-- function 7
	local my_peer_id = self.peer_id
	local lobby = self.lobby
	local members = lobby:members()
	local num_members = #members

	if num_members > 0 then
		Debug.text("Reliable Send Buffer Left (peer : bytes):")

		for i = 1, num_members do
			local peer_id = members[i]

			if peer_id ~= my_peer_id then
				self._min_remaining_buffer = not not self._min_remaining_buffer

				local remaining_buffer_size = Network.reliable_send_buffer_left(peer_id)
				local min_buffer = self._min_remaining_buffer[peer_id]

				if min_buffer == nil and remaining_buffer_size > 0 then
					min_buffer = remaining_buffer_size
					self._min_remaining_buffer[peer_id] = min_buffer
				end

				Debug.text("    %s : %d %s", peer_id, remaining_buffer_size, min_buffer and not not string.format("(min: %d)", min_buffer) or not min_buffer and not not "")
			end
		end
	end
end

LobbyHost.set_lobby_data = function (self, lobby_data_table)
	-- function 8
	fassert(lobby_data_table.Host == nil, "Tell Staffan about this!!")
	dprintf("Set lobby begin:")

	self.lobby_data_table = lobby_data_table

	if self.state == LobbyState.JOINED then
		local lobby = self.lobby

		if IS_PS4 then
			lobby:set_data_table(lobby_data_table)
		else
			for key, value in pairs(lobby_data_table) do
				dprintf("\tLobby data %s = %s", key, tostring(value))
				lobby:set_data(key, value)
			end
		end
	end

	dprintf("Set lobby end.")
end

LobbyHost.set_network_initialized = function (self, initialized)
	-- function 9
	self._network_initialized = initialized
end

LobbyHost.network_initialized = function (self)
	-- function 10
	return self._network_initialized
end

LobbyHost.get_stored_lobby_data = function (self)
	-- function 11
	return self.lobby_data_table
end

LobbyHost.attempting_reconnect = function (self)
	-- function 12
	return false
end

LobbyHost.members = function (self)
	-- function 13
	return self.lobby_members
end

LobbyHost.lobby_data = function (self, key)
	-- function 14
	return self.lobby:data(key)
end

LobbyHost.invite_target = function (self)
	-- function 15
	return self.lobby
end

LobbyHost.is_dedicated_server = function (self)
	-- function 16
	return false
end

LobbyHost.lobby_host = function (self)
	-- function 17
	return self.lobby:lobby_host()
end

LobbyHost.user_name = function (self, peer_id)
	-- function 18
	if HAS_STEAM then
		return string.gsub(Steam.user_name(), "%c", "")
	elseif IS_PS4 then
		return string.gsub(self.lobby:user_name(peer_id), "%c", "")
	else
		return peer_id
	end
end

LobbyHost.id = function (self)
	-- function 19
	return LobbyInternal.lobby_id and not not LobbyInternal.lobby_id(self.lobby) or not LobbyInternal.lobby_id and not not "no_id"
end

LobbyHost.is_joined = function (self)
	-- function 20
	return self.state == LobbyState.JOINED
end

LobbyHost.get_network_hash = function (self)
	-- function 21
	return self.network_hash
end

LobbyHost.get_max_members = function (self)
	-- function 22
	return self.max_members
end

LobbyHost.set_max_members = function (self, max_members)
	-- function 23
	self.max_members = max_members

	LobbyInternal.set_max_members(self.lobby, max_members)
end

LobbyHost.set_lobby = function (self, lobby)
	-- function 24
	print("leaving old lobby")
	self:_free_lobby()

	self.lobby = lobby

	local lobby_data_table = not not self.lobby_data_table

	self:set_lobby_data(lobby_data_table)

	self.lobby_members = LobbyMembers:new(lobby)
end

LobbyHost.steal_lobby = function (self)
	-- function 25
	local lobby = self.lobby

	self.lobby = nil

	return lobby
end

LobbyHost.failed = function (self)
	-- function 26
	return self.state == LobbyState.FAILED
end

LobbyHost._free_lobby = function (self)
	-- function 27
	if self.lobby ~= nil then
		LobbyInternal.leave_lobby(self.lobby)

		self.lobby = nil
	end
end

LobbyHost.lost_connection_to_lobby = function (self)
	-- function 28
	return LobbyInternal.is_orphaned(self.lobby)
end

LobbyHost.close_channel = function (self, channel_id)
	-- function 29
	LobbyInternal.close_channel(self.lobby, channel_id)
end
