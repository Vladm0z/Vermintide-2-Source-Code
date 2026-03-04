-- chunkname: @scripts/managers/telemetry/reporters/heartbeat_reporter.lua

HeartbeatReporter = class(HeartbeatReporter)
HeartbeatReporter.NAME = "HeartbeatReporter"

local var_0_0 = 300

HeartbeatReporter.init = function (arg_1_0)
	arg_1_0._last_sample_time = 0

	Managers.telemetry_events:heartbeat()
end

HeartbeatReporter.destroy = function (arg_2_0)
	return
end

HeartbeatReporter.update = function (arg_3_0, arg_3_1, arg_3_2)
	if arg_3_2 - arg_3_0._last_sample_time > var_0_0 then
		Managers.telemetry_events:heartbeat()

		arg_3_0._last_sample_time = math.floor(arg_3_2)
	end
end

HeartbeatReporter.report = function (arg_4_0)
	return
end
