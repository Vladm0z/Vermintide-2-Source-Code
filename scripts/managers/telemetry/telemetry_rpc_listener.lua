-- chunkname: @scripts/managers/telemetry/telemetry_rpc_listener.lua

local tbl = {
	"rpc_to_client_sync_session_id"
}

TelemetryRPCListener = class(TelemetryRPCListener)

TelemetryRPCListener.init = function (self, arg_1_1)
	-- function 1
	self._events = arg_1_1
end

TelemetryRPCListener.register = function (arg_2_0, arg_2_1)
	-- function 2
	arg_2_1:register(arg_2_0, unpack(tbl))
end

TelemetryRPCListener.unregister = function (arg_3_0, arg_3_1)
	-- function 3
	arg_3_1:unregister(arg_3_0)
end

TelemetryRPCListener.rpc_to_client_sync_session_id = function (self, arg_4_1, arg_4_2)
	-- function 4
	print("[TelemetryRPCListener] Receiving session id from server", arg_4_2)
	self._events:server_session_id(arg_4_2)
end
