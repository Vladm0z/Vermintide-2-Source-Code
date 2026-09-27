-- chunkname: @scripts/managers/telemetry/reporters/heartbeat_reporter.lua

HeartbeatReporter = class(HeartbeatReporter)
HeartbeatReporter.NAME = "HeartbeatReporter"

local num = 300

HeartbeatReporter.init = function (self)
	-- function 1
	self._last_sample_time = 0

	Managers.telemetry_events:heartbeat()
end

HeartbeatReporter.destroy = function (arg_2_0)
	-- function 2
	return
end

HeartbeatReporter.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	if arg_3_2 - self._last_sample_time > num then
		Managers.telemetry_events:heartbeat()

		self._last_sample_time = math.floor(arg_3_2)
	end
end

HeartbeatReporter.report = function (arg_4_0)
	-- function 4
	return
end
