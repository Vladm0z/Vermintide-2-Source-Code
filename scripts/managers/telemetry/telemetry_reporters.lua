-- chunkname: @scripts/managers/telemetry/telemetry_reporters.lua

require("scripts/managers/telemetry/reporters/heartbeat_reporter")

TelemetryReporters = class(TelemetryReporters)
TelemetryReporters.NAME = "TelemetryReporters"

local var_0_0 = {
	heartbeat = HeartbeatReporter
}

function TelemetryReporters.init(arg_1_0)
	arg_1_0._reporters = {}

	arg_1_0:start_reporter("heartbeat")
end

function TelemetryReporters.start_reporter(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = var_0_0[arg_2_1]

	arg_2_0._reporters[arg_2_1] = var_2_0:new(arg_2_2)
end

function TelemetryReporters.stop_reporter(arg_3_0, arg_3_1)
	arg_3_0._reporters[arg_3_1]:report()
	arg_3_0._reporters[arg_3_1]:destroy()

	arg_3_0._reporters[arg_3_1] = nil
end

function TelemetryReporters.reporter(arg_4_0, arg_4_1)
	return arg_4_0._reporters[arg_4_1]
end

function TelemetryReporters.update(arg_5_0, arg_5_1, arg_5_2)
	for iter_5_0, iter_5_1 in pairs(arg_5_0._reporters) do
		iter_5_1:update(arg_5_1, arg_5_2)
	end
end

function TelemetryReporters.destroy(arg_6_0)
	for iter_6_0, iter_6_1 in pairs(arg_6_0._reporters) do
		iter_6_1:destroy()
	end
end

return TelemetryReporters
