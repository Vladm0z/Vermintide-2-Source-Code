-- chunkname: @scripts/network/network_clock_server.lua

NetworkClockServer = class(NetworkClockServer)

local RPCS = {
	"rpc_network_clock_sync_request",
	"rpc_network_current_server_time_request"
}

NetworkClockServer.init = function (self)
	-- function 1
	self._clock = 0
end

NetworkClockServer.register_rpcs = function (self, network_event_delegate)
	-- function 2
	network_event_delegate:register(self, unpack(RPCS))

	self._network_event_delegate = network_event_delegate
end

NetworkClockServer.unregister_rpcs = function (self)
	-- function 3
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

NetworkClockServer.synchronized = function (self)
	-- function 4
	return true
end

NetworkClockServer.time = function (self)
	-- function 5
	return self._clock
end

NetworkClockServer.update = function (self, dt)
	-- function 6
	self:_update_clock(dt)

	if Development.parameter("network_clock_debug") then
		self:_debug_stuff(dt)
	end
end

NetworkClockServer._update_clock = function (self, delta)
	-- function 7
	self._clock = self._clock + delta
end

NetworkClockServer.destroy = function (self)
	-- function 8
	return
end

NetworkClockServer._debug_stuff = function (self, dt)
	-- function 9
	local debug_text_manager = Managers.state.debug_text

	if debug_text_manager then
		local text = string.format("%.3f", self._clock)

		debug_text_manager:output_screen_text(text, 22, 0.1)
	end
end

NetworkClockServer.rpc_network_clock_sync_request = function (self, channel_id, client_time)
	-- function 10
	RPC.rpc_network_time_sync_response(channel_id, client_time, self._clock)
end

NetworkClockServer.rpc_network_current_server_time_request = function (self, channel_id, client_time)
	-- function 11
	RPC.rpc_network_current_server_time_response(channel_id, client_time, self._clock)
end
