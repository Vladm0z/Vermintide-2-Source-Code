-- chunkname: @scripts/managers/account/smartmatch_cleaner.lua

local flag = true

local function fn(...)
	-- function 1
	if not flag then
		print("[SmartMatchCleaner]", string.format(...))
	end
end

SmartMatchCleaner = class(SmartMatchCleaner)

SmartMatchCleaner.init = function (self)
	-- function 2
	self:reset()
end

SmartMatchCleaner.reset = function (self)
	-- function 3
	self._sessions_to_clean = {}
end

SmartMatchCleaner.ready = function (self)
	-- function 4
	return #self._sessions_to_clean == 0
end

SmartMatchCleaner.add_session = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._sessions_to_clean[#arg_5_0._sessions_to_clean + 1] = arg_5_1
end

local ENTRIES_TO_REMOVE = ENTRIES_TO_REMOVE

ENTRIES_TO_REMOVE = ENTRIES_TO_REMOVE or {}

SmartMatchCleaner.update = function (self, arg_6_1)
	-- function 6
	self:_update_cleanup(arg_6_1)
	self:_update_remove(arg_6_1)
end

SmartMatchCleaner._update_cleanup = function (self, arg_7_1)
	-- function 7
	for i = 1, #self._sessions_to_clean do
		local var_7_0 = self._sessions_to_clean[i]

		self[var_7_0.state](self, arg_7_1, i, var_7_0)
	end
end

SmartMatchCleaner._update_remove = function (self, arg_8_1)
	-- function 8
	for i, v in ipairs(self._sessions_to_clean) do
		if v.state == "_do_remove" then
			local session_id = v.session_id
			local session_name = v.session_name

			fn("REMOVED session entry --> session_id: %s - session_name: %s", session_id, session_name)

			ENTRIES_TO_REMOVE[#ENTRIES_TO_REMOVE + 1] = i
		end
	end

	for k = #ENTRIES_TO_REMOVE, 1, -1 do
		table.remove(self._sessions_to_clean, k)
	end

	table.clear(ENTRIES_TO_REMOVE)
end

SmartMatchCleaner._change_state = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not arg_9_2 and not self[arg_9_2] then
		fn("Changed state from: %s to: %s", arg_9_1.state, arg_9_2)

		arg_9_1.state = arg_9_2
	else
		fassert("[SmartMatchCleaner:_change_state] There is no state called %s", arg_9_2)
	end
end

SmartMatchCleaner._cleanup_ticket = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local session_id = arg_10_3.session_id
	local session_name = arg_10_3.session_name
	local hopper_name = arg_10_3.hopper_name
	local destroy_session = arg_10_3.destroy_session
	local ticket_id = arg_10_3.ticket_id
	local user_id = arg_10_3.user_id
	local status = MultiplayerSession.status(session_id)

	if status == MultiplayerSession.WORKING then
		return
	end

	local start_smartmatch_result = MultiplayerSession.start_smartmatch_result(session_id)

	if not (status == MultiplayerSession.BROKEN or status ~= MultiplayerSession.SHUTDOWN) then
		fn("Cannot cleanup ticket since the session is either broken or shutdown. Ticket params: - session_id: %s - session_name: %s - hopper_name: %s - ticket_id: %s", session_id, session_name, hopper_name, ticket_id)
	elseif not Managers.account:user_exists(user_id) then
		fn("Couldn't delete smartmatch ticket since the user didn't exist in cache - session_id: %s - session_name: %s - hopper_name: %s - ticket_id: %s - user_id: %s", session_id, session_name, hopper_name, ticket_id, user_id)
	elseif not ticket_id then
		fn("Deleting PROVIDED ticket with params - session_id: %s - session_name: %s - hopper_name: %s - ticket_id: %s", session_id, session_name, hopper_name, ticket_id)
		MultiplayerSession.delete_smartmatch_ticket(session_id, hopper_name, ticket_id)
	elseif start_smartmatch_result ~= "" then
		fn("Found ticket for session --> session_id: %s - session_name: %s - ticket_id: %s", session_id, session_name, start_smartmatch_result)
		fn("Deleting ticket with params - session_id: %s - session_name: %s - hopper_name: %s - ticket_id: %s", session_id, session_name, hopper_name, start_smartmatch_result)
		MultiplayerSession.delete_smartmatch_ticket(session_id, hopper_name, start_smartmatch_result)
	else
		fn("Had no ticket for session --> session_id: %s - session_name: %s", session_id, session_name)
	end

	if not destroy_session then
		self:_change_state(arg_10_3, "_cleanup_session")
	else
		fn("KEEP SESSION ALIVE --> session_id: %s - session_name: %s", session_id, session_name)
		self:_change_state(arg_10_3, "_do_remove")
	end
end

SmartMatchCleaner._cleanup_session = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local session_id = arg_11_3.session_id
	local session_name = arg_11_3.session_name
	local session_name_2 = arg_11_3.session_name
	local hopper_name = arg_11_3.hopper_name
	local status = MultiplayerSession.status(session_id)

	if not (status == MultiplayerSession.READY or status ~= MultiplayerSession.BROKEN) then
		fn("Leaving session --> session_id: %s - session_name: %s", session_id, session_name_2)
		MultiplayerSession.leave(session_id)
		self:_change_state(arg_11_3, "_free_session")
	elseif status == MultiplayerSession.SHUTDOWN then
		self:_change_state(arg_11_3, "_free_session")
	end
end

SmartMatchCleaner._free_session = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local session_id = arg_12_3.session_id
	local session_name = arg_12_3.session_name

	if MultiplayerSession.status(session_id) == MultiplayerSession.SHUTDOWN then
		fn("Freeing session --> session_id: %s - session_name: %s", session_id, session_name)
		Network.free_multiplayer_session(session_id)
		self:_change_state(arg_12_3, "_do_remove")
	end
end

SmartMatchCleaner._do_remove = function (arg_13_0)
	-- function 13
	return
end
