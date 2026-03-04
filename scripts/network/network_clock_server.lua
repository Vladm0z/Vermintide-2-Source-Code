-- chunkname: @scripts/network/network_clock_server.lua

NetworkClockServer = class(NetworkClockServer)

local var_0_0 = {
	"rpc_network_clock_sync_request",
	"rpc_network_current_server_time_request"
}

NetworkClockServer.init = function (arg_1_0)
	arg_1_0._clock = 0
end

NetworkClockServer.register_rpcs = function (arg_2_0, arg_2_1)
	arg_2_1:register(arg_2_0, unpack(var_0_0))

	arg_2_0._network_event_delegate = arg_2_1
end

NetworkClockServer.unregister_rpcs = function (arg_3_0)
	arg_3_0._network_event_delegate:unregister(arg_3_0)

	arg_3_0._network_event_delegate = nil
end

NetworkClockServer.synchronized = function (arg_4_0)
	return true
end

NetworkClockServer.time = function (arg_5_0)
	return arg_5_0._clock
end

NetworkClockServer.update = function (arg_6_0, arg_6_1)
	arg_6_0:_update_clock(arg_6_1)

	if Development.parameter("network_clock_debug") then
		arg_6_0:_debug_stuff(arg_6_1)
	end
end

NetworkClockServer._update_clock = function (arg_7_0, arg_7_1)
	arg_7_0._clock = arg_7_0._clock + arg_7_1
end

NetworkClockServer.destroy = function (arg_8_0)
	return
end

NetworkClockServer._debug_stuff = function (arg_9_0, arg_9_1)
	local var_9_0 = Managers.state.debug_text

	if var_9_0 then
		local var_9_1 = string.format("%.3f", arg_9_0._clock)

		var_9_0:output_screen_text(var_9_1, 22, 0.1)
	end
end

NetworkClockServer.rpc_network_clock_sync_request = function (arg_10_0, arg_10_1, arg_10_2)
	RPC.rpc_network_time_sync_response(arg_10_1, arg_10_2, arg_10_0._clock)
end

NetworkClockServer.rpc_network_current_server_time_request = function (arg_11_0, arg_11_1, arg_11_2)
	RPC.rpc_network_current_server_time_response(arg_11_1, arg_11_2, arg_11_0._clock)
end
