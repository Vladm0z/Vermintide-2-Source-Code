-- chunkname: @scripts/managers/debug/debug_event_manager_rpc.lua

DebugEventManagerRPC = class(DebugEventManagerRPC)

DebugEventManagerRPC.init = function (self, arg_1_1)
	-- function 1
	self._event_delegate = arg_1_1

	self._event_delegate:register(self, "rpc_event_manager_event")
end

DebugEventManagerRPC.rpc_event_manager_event = function (arg_2_0, arg_2_1, ...)
	-- function 2
	local event = Managers.state.event

	if not event then
		event:trigger(...)
	end
end

DebugEventManagerRPC.destroy = function (self)
	-- function 3
	self._event_delegate:unregister(self)
end
