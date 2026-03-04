-- chunkname: @scripts/managers/debug/debug_event_manager_rpc.lua

DebugEventManagerRPC = class(DebugEventManagerRPC)

DebugEventManagerRPC.init = function (arg_1_0, arg_1_1)
	arg_1_0._event_delegate = arg_1_1

	arg_1_0._event_delegate:register(arg_1_0, "rpc_event_manager_event")
end

DebugEventManagerRPC.rpc_event_manager_event = function (arg_2_0, arg_2_1, ...)
	local var_2_0 = Managers.state.event

	if var_2_0 then
		var_2_0:trigger(...)
	end
end

DebugEventManagerRPC.destroy = function (arg_3_0)
	arg_3_0._event_delegate:unregister(arg_3_0)
end
