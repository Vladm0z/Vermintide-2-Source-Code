-- chunkname: @scripts/network/network_clock_server.lua

NetworkClockServer = class(NetworkClockServer)

local tbl = {
	"rpc_network_clock_sync_request",
	"rpc_network_current_server_time_request"
}

NetworkClockServer.init = function (self)
	-- function 1
	self._clock = 0
end

NetworkClockServer.register_rpcs = function (self, arg_2_1)
	-- function 2
	arg_2_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_2_1
end

NetworkClockServer.unregister_rpcs = function (self)
	-- function 3
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

NetworkClockServer.synchronized = function (arg_4_0)
	-- function 4
	return true
end

NetworkClockServer.time = function (self)
	-- function 5
	return self._clock
end

NetworkClockServer.update = function (self, arg_6_1)
	-- function 6
	self:_update_clock(arg_6_1)

	if not Development.parameter("network_clock_debug") then
		self:_debug_stuff(arg_6_1)
	end
end

NetworkClockServer._update_clock = function (self, arg_7_1)
	-- function 7
	self._clock = self._clock + arg_7_1
end

NetworkClockServer.destroy = function (arg_8_0)
	-- function 8
	return
end

NetworkClockServer._debug_stuff = function (self, arg_9_1)
	-- function 9
	local debug_text = Managers.state.debug_text

	if not debug_text then
		local format = string.format("%.3f", self._clock)

		debug_text:output_screen_text(format, 22, 0.1)
	end
end

NetworkClockServer.rpc_network_clock_sync_request = function (self, arg_10_1, arg_10_2)
	-- function 10
	RPC.rpc_network_time_sync_response(arg_10_1, arg_10_2, self._clock)
end

NetworkClockServer.rpc_network_current_server_time_request = function (self, arg_11_1, arg_11_2)
	-- function 11
	RPC.rpc_network_current_server_time_response(arg_11_1, arg_11_2, self._clock)
end
