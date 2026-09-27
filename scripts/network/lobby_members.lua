-- chunkname: @scripts/network/lobby_members.lua

LobbyMembers = class(LobbyMembers)

LobbyMembers.init = function (self, arg_1_1)
	-- function 1
	self.lobby = arg_1_1
	self.members_joined = {}
	self.members_left = {}

	local members, var_1_1 = arg_1_1:members()

	var_1_1 = var_1_1 or #members
	self._member_buffer = members
	self.member_count = var_1_1

	local tbl = {}

	for i = 1, var_1_1 do
		local var_1_3 = members[i]

		tbl[var_1_3] = true
		self.members_joined[i] = var_1_3
	end

	self.members = tbl
	self._members_changed = true

	if not (not IS_CONSOLE and Managers.account:offline_mode()) then
		self.lobby:update_user_names()
	end
end

LobbyMembers.clear = function (arg_2_0)
	-- function 2
	return
end

LobbyMembers.update = function (self)
	-- function 3
	local members_joined = self.members_joined
	local members_left = self.members_left

	table.clear(members_joined)
	table.clear(members_left)

	local _member_buffer = self._member_buffer

	table.clear(_member_buffer)

	local members, var_3_4 = self.lobby:members(_member_buffer)

	if not var_3_4 then
		self._member_buffer = members
		var_3_4 = #members
	end

	self.member_count = var_3_4

	local members_2 = self.members

	for i = 1, var_3_4 do
		local var_3_6 = members[i]

		if members_2[var_3_6] == nil then
			members_joined[#members_joined + 1] = var_3_6

			printf("[LobbyMembers] Member joined %s", tostring(var_3_6))

			if not IS_CONSOLE then
				local account = Managers.account

				if not IS_XB1 then
					account:query_bandwidth()

					self._members_changed = true
				end

				if not account:offline_mode() then
					self.lobby:update_user_names()
				end
			end
		end

		members_2[var_3_6] = false
	end

	for k, v in pairs(members_2) do
		if v == false then
			members_2[k] = true
		else
			printf("[LobbyMembers] Member left %s", tostring(k))

			members_left[#members_left + 1] = k
			members_2[k] = nil

			if not IS_XB1 then
				if table.size(members_2) <= 1 then
					Managers.account:reset_bandwidth_query()
				end

				self._members_changed = true
			end
		end
	end
end

LobbyMembers.get_members_left = function (self)
	-- function 4
	return self.members_left
end

LobbyMembers.get_members_joined = function (self)
	-- function 5
	return self.members_joined
end

LobbyMembers.get_members = function (self)
	-- function 6
	return self._member_buffer
end

LobbyMembers.get_member_count = function (self)
	-- function 7
	return self.member_count
end

LobbyMembers.members_map = function (self)
	-- function 8
	return self.members
end

if not IS_XB1 then
	LobbyMembers.check_members_changed = function (self)
		-- function 9
		local _members_changed = self._members_changed

		self._members_changed = nil

		return _members_changed
	end
end
