-- chunkname: @scripts/network/lobby_host.lua

require("scripts/network/lobby_aux")

local flag = true

local function fn(arg_1_0, ...)
	-- function 1
	if not flag then
		printf(arg_1_0, ...)
	end
end

LobbyHost = class(LobbyHost)

LobbyHost.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	print("[LobbyHost] Creating")

	local config_file_name = arg_2_1.config_file_name
	local project_hash = arg_2_1.project_hash

	self.network_hash = LobbyAux.create_network_hash(config_file_name, project_hash)

	if IS_WINDOWS or not IS_LINUX then
		fassert(arg_2_1.max_members, "Must provide max members to LobbyHost")
	end

	local IS_LINUX

	if not IS_WINDOWS then
		IS_LINUX = IS_LINUX

		if not IS_LINUX then
			-- Nothing
		end
	end

	IS_LINUX = arg_2_1.max_members

	::label_2_0::

	self.max_members = IS_LINUX
	self.lobby = arg_2_2 or LobbyInternal.create_lobby(arg_2_1)
	self.peer_id = Network.peer_id()
	self._network_initialized = false
	self.platform = PLATFORM
	self.is_host = true
end

LobbyHost.kick_all_except = function (self, arg_3_1)
	-- function 3
	if self.lobby == nil or not self.lobby.kick then
		arg_3_1 = arg_3_1 or {}

		local peer_id = self.peer_id

		for i, v in ipairs(self.lobby:members()) do
			if not (v == peer_id or arg_3_1[v]) then
				self.lobby:kick(v)
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

LobbyHost.update = function (self, arg_5_1)
	-- function 5
	local lobby = self.lobby
	local state = lobby:state()
	local state_2 = self.state

	state_2 = state_2 or 0

	if state ~= state_2 then
		printf("[LobbyHost] Changed state from %s to %s", state_2, state)

		self.state = state

		if state == LobbyState.JOINED then
			if not IS_PS4 then
				local lobby_data_table = self.lobby_data_table

				lobby_data_table = lobby_data_table or {}
				lobby_data_table.network_hash = self.network_hash

				lobby:set_data_table(lobby_data_table)
			else
				local lobby_data_table_2 = self.lobby_data_table

				lobby_data_table_2.network_hash = self.network_hash

				if not lobby_data_table_2 then
					for k, v in pairs(lobby_data_table_2) do
						lobby:set_data(k, v)
					end
				end
			end

			local lobby_members = self.lobby_members

			lobby_members = lobby_members or LobbyMembers:new(lobby)
			self.lobby_members = lobby_members

			Managers.party:set_leader(lobby:lobby_host())
			Managers.account:update_presence()
		elseif state_2 == LobbyState.JOINED then
			Managers.party:set_leader(nil)

			if not self.lobby_members then
				self.lobby_members:clear()
			end
		end
	end

	if not self.lobby_members then
		self.lobby_members:update()
	end
end

LobbyHost.ping_by_peer = function (arg_6_0, arg_6_1)
	-- function 6
	return LobbyInternal.ping(arg_6_1)
end

LobbyHost._update_debug = function (self)
	-- function 7
	local peer_id = self.peer_id
	local members = self.lobby:members()
	local count = #members

	if count > 0 then
		Debug.text("Reliable Send Buffer Left (peer : bytes):")

		for i = 1, count do
			local var_7_3 = members[i]

			if var_7_3 ~= peer_id then
				local _min_remaining_buffer = self._min_remaining_buffer

				_min_remaining_buffer = _min_remaining_buffer or {}
				self._min_remaining_buffer = _min_remaining_buffer

				local reliable_send_buffer_left = Network.reliable_send_buffer_left(var_7_3)
				local var_7_6 = self._min_remaining_buffer[var_7_3]

				if not (not var_7_6 and reliable_send_buffer_left < var_7_6 or var_7_6 ~= nil or not (reliable_send_buffer_left > 0)) then
					var_7_6 = reliable_send_buffer_left
					self._min_remaining_buffer[var_7_3] = var_7_6
				end

				local text = Debug.text
				local str = "    %s : %d %s"
				local var_7_9 = var_7_3
				local var_7_10 = reliable_send_buffer_left
				local format

				if not var_7_6 then
					format = string.format("(min: %d)", var_7_6)

					if not format then
						-- Nothing
					end
				end

				format = ""

				::label_7_0::

				text(str, var_7_9, var_7_10, format)
			end
		end
	end
end

LobbyHost.set_lobby_data = function (self, arg_8_1)
	-- function 8
	fassert(arg_8_1.Host == nil, "Tell Staffan about this!!")
	fn("Set lobby begin:")

	self.lobby_data_table = arg_8_1

	if self.state == LobbyState.JOINED then
		local lobby = self.lobby

		if not IS_PS4 then
			lobby:set_data_table(arg_8_1)
		else
			for k, v in pairs(arg_8_1) do
				fn("\tLobby data %s = %s", k, tostring(v))
				lobby:set_data(k, v)
			end
		end
	end

	fn("Set lobby end.")
end

LobbyHost.set_network_initialized = function (self, arg_9_1)
	-- function 9
	self._network_initialized = arg_9_1
end

LobbyHost.network_initialized = function (self)
	-- function 10
	return self._network_initialized
end

LobbyHost.get_stored_lobby_data = function (self)
	-- function 11
	return self.lobby_data_table
end

LobbyHost.attempting_reconnect = function (arg_12_0)
	-- function 12
	return false
end

LobbyHost.members = function (self)
	-- function 13
	return self.lobby_members
end

LobbyHost.lobby_data = function (self, arg_14_1)
	-- function 14
	return self.lobby:data(arg_14_1)
end

LobbyHost.invite_target = function (self)
	-- function 15
	return self.lobby
end

LobbyHost.is_dedicated_server = function (arg_16_0)
	-- function 16
	return false
end

LobbyHost.lobby_host = function (self)
	-- function 17
	return self.lobby:lobby_host()
end

LobbyHost.user_name = function (self, arg_18_1)
	-- function 18
	if not HAS_STEAM then
		return string.gsub(Steam.user_name(), "%c", "")
	elseif not IS_PS4 then
		return string.gsub(self.lobby:user_name(arg_18_1), "%c", "")
	else
		return arg_18_1
	end
end

LobbyHost.id = function (self)
	-- function 19
	local lobby_id

	if not LobbyInternal.lobby_id then
		lobby_id = LobbyInternal.lobby_id(self.lobby)

		if not lobby_id then
			-- Nothing
		end
	end

	lobby_id = "no_id"

	::label_19_0::

	return lobby_id
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

LobbyHost.set_max_members = function (self, arg_23_1)
	-- function 23
	self.max_members = arg_23_1

	LobbyInternal.set_max_members(self.lobby, arg_23_1)
end

LobbyHost.set_lobby = function (self, arg_24_1)
	-- function 24
	print("leaving old lobby")
	self:_free_lobby()

	self.lobby = arg_24_1

	local lobby_data_table = self.lobby_data_table

	lobby_data_table = lobby_data_table or {}

	self:set_lobby_data(lobby_data_table)

	self.lobby_members = LobbyMembers:new(arg_24_1)
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

LobbyHost.close_channel = function (self, arg_29_1)
	-- function 29
	LobbyInternal.close_channel(self.lobby, arg_29_1)
end
