-- chunkname: @scripts/managers/telemetry/reporters/heartbeat_reporter.lua

HeartbeatReporter = class(HeartbeatReporter)
HeartbeatReporter.NAME = "HeartbeatReporter"

local var_0_0 = 300

function HeartbeatReporter.init(arg_1_0)
	arg_1_0._last_sample_time = 0

	Managers.telemetry_events:heartbeat()
end

function HeartbeatReporter.destroy(arg_2_0)
	return
end

function HeartbeatReporter.update(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_2 - arg_3_0._last_sample_time > var_0_0 then
		Managers.telemetry_events:heartbeat()

		arg_3_0._last_sample_time = math.floor(arg_3_2)
	end
end

function HeartbeatReporter.report(arg_4_0)
	return
end
