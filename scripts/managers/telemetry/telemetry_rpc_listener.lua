-- chunkname: @scripts/managers/telemetry/telemetry_rpc_listener.lua

local var_0_0 = {
	"rpc_to_client_sync_session_id"
}

TelemetryRPCListener = class(TelemetryRPCListener)

function TelemetryRPCListener.init(arg_1_0, arg_1_1)
	arg_1_0._events = arg_1_1
end

function TelemetryRPCListener.register(arg_2_0, arg_2_1)
	arg_2_1:register(arg_2_0, unpack(var_0_0))
end

function TelemetryRPCListener.unregister(arg_3_0, arg_3_1)
	arg_3_1:unregister(arg_3_0)
end

function TelemetryRPCListener.rpc_to_client_sync_session_id(arg_4_0, arg_4_1, arg_4_2)
	print("[TelemetryRPCListener] Receiving session id from server", arg_4_2)
	arg_4_0._events:server_session_id(arg_4_2)
end
