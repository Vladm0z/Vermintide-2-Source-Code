-- chunkname: @scripts/managers/account/smartmatch_cleaner.lua

local var_0_0 = true

local function var_0_1(...)
	if var_0_0 then
		print("[SmartMatchCleaner]", string.format(...))
	end
end

SmartMatchCleaner = class(SmartMatchCleaner)

function SmartMatchCleaner.init(arg_2_0)
	arg_2_0:reset()
end

function SmartMatchCleaner.reset(arg_3_0)
	arg_3_0._sessions_to_clean = {}
end

function SmartMatchCleaner.ready(arg_4_0)
	return #arg_4_0._sessions_to_clean == 0
end

function SmartMatchCleaner.add_session(arg_5_0, arg_5_1)
	arg_5_0._sessions_to_clean[#arg_5_0._sessions_to_clean + 1] = arg_5_1
end

local var_0_2 = ENTRIES_TO_REMOVE or {}

function SmartMatchCleaner.update(arg_6_0, arg_6_1)
	arg_6_0:_update_cleanup(arg_6_1)
	arg_6_0:_update_remove(arg_6_1)
end

function SmartMatchCleaner._update_cleanup(arg_7_0, arg_7_1)
	for iter_7_0 = 1, #arg_7_0._sessions_to_clean do
		local var_7_0 = arg_7_0._sessions_to_clean[iter_7_0]

		arg_7_0[var_7_0.state](arg_7_0, arg_7_1, iter_7_0, var_7_0)
	end
end

function SmartMatchCleaner._update_remove(arg_8_0, arg_8_1)
	for iter_8_0, iter_8_1 in ipairs(arg_8_0._sessions_to_clean) do
		if iter_8_1.state == "_do_remove" then
			local var_8_0 = iter_8_1.session_id
			local var_8_1 = iter_8_1.session_name

			var_0_1("REMOVED session entry --> session_id: %s - session_name: %s", var_8_0, var_8_1)

			var_0_2[#var_0_2 + 1] = iter_8_0
		end
	end

	for iter_8_2 = #var_0_2, 1, -1 do
		table.remove(arg_8_0._sessions_to_clean, iter_8_2)
	end

	table.clear(var_0_2)
end

function SmartMatchCleaner._change_state(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_2 and arg_9_0[arg_9_2] then
		var_0_1("Changed state from: %s to: %s", arg_9_1.state, arg_9_2)

		arg_9_1.state = arg_9_2
	else
		fassert("[SmartMatchCleaner:_change_state] There is no state called %s", arg_9_2)
	end
end

function SmartMatchCleaner._cleanup_ticket(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_3.session_id
	local var_10_1 = arg_10_3.session_name
	local var_10_2 = arg_10_3.hopper_name
	local var_10_3 = arg_10_3.destroy_session
	local var_10_4 = arg_10_3.ticket_id
	local var_10_5 = arg_10_3.user_id
	local var_10_6 = MultiplayerSession.status(var_10_0)

	if var_10_6 == MultiplayerSession.WORKING then
		return
	end

	local var_10_7 = MultiplayerSession.start_smartmatch_result(var_10_0)

	if var_10_6 == MultiplayerSession.BROKEN or var_10_6 == MultiplayerSession.SHUTDOWN then
		var_0_1("Cannot cleanup ticket since the session is either broken or shutdown. Ticket params: - session_id: %s - session_name: %s - hopper_name: %s - ticket_id: %s", var_10_0, var_10_1, var_10_2, var_10_4)
	elseif not Managers.account:user_exists(var_10_5) then
		var_0_1("Couldn't delete smartmatch ticket since the user didn't exist in cache - session_id: %s - session_name: %s - hopper_name: %s - ticket_id: %s - user_id: %s", var_10_0, var_10_1, var_10_2, var_10_4, var_10_5)
	elseif var_10_4 then
		var_0_1("Deleting PROVIDED ticket with params - session_id: %s - session_name: %s - hopper_name: %s - ticket_id: %s", var_10_0, var_10_1, var_10_2, var_10_4)
		MultiplayerSession.delete_smartmatch_ticket(var_10_0, var_10_2, var_10_4)
	elseif var_10_7 ~= "" then
		var_0_1("Found ticket for session --> session_id: %s - session_name: %s - ticket_id: %s", var_10_0, var_10_1, var_10_7)
		var_0_1("Deleting ticket with params - session_id: %s - session_name: %s - hopper_name: %s - ticket_id: %s", var_10_0, var_10_1, var_10_2, var_10_7)
		MultiplayerSession.delete_smartmatch_ticket(var_10_0, var_10_2, var_10_7)
	else
		var_0_1("Had no ticket for session --> session_id: %s - session_name: %s", var_10_0, var_10_1)
	end

	if var_10_3 then
		arg_10_0:_change_state(arg_10_3, "_cleanup_session")
	else
		var_0_1("KEEP SESSION ALIVE --> session_id: %s - session_name: %s", var_10_0, var_10_1)
		arg_10_0:_change_state(arg_10_3, "_do_remove")
	end
end

function SmartMatchCleaner._cleanup_session(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_3.session_id
	local var_11_1 = arg_11_3.session_name
	local var_11_2 = arg_11_3.session_name
	local var_11_3 = arg_11_3.hopper_name
	local var_11_4 = MultiplayerSession.status(var_11_0)

	if var_11_4 == MultiplayerSession.READY or var_11_4 == MultiplayerSession.BROKEN then
		var_0_1("Leaving session --> session_id: %s - session_name: %s", var_11_0, var_11_2)
		MultiplayerSession.leave(var_11_0)
		arg_11_0:_change_state(arg_11_3, "_free_session")
	elseif var_11_4 == MultiplayerSession.SHUTDOWN then
		arg_11_0:_change_state(arg_11_3, "_free_session")
	end
end

function SmartMatchCleaner._free_session(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_3.session_id
	local var_12_1 = arg_12_3.session_name

	if MultiplayerSession.status(var_12_0) == MultiplayerSession.SHUTDOWN then
		var_0_1("Freeing session --> session_id: %s - session_name: %s", var_12_0, var_12_1)
		Network.free_multiplayer_session(var_12_0)
		arg_12_0:_change_state(arg_12_3, "_do_remove")
	end
end

function SmartMatchCleaner._do_remove(arg_13_0)
	return
end
