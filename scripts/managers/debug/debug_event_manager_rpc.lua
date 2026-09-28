-- chunkname: @scripts/managers/debug/debug_event_manager_rpc.lua

DebugEventManagerRPC = class(DebugEventManagerRPC)

DebugEventManagerRPC.init = function (self, network_event_delegate)
	-- function 1
	self._event_delegate = network_event_delegate

	self._event_delegate:register(self, "rpc_event_manager_event")
end

DebugEventManagerRPC.rpc_event_manager_event = function (self, channel_id, ...)
	-- function 2
	local event_manager = Managers.state.event

	if event_manager then
		event_manager:trigger(...)
	end
end

DebugEventManagerRPC.destroy = function (self)
	-- function 3
	self._event_delegate:unregister(self)
end
