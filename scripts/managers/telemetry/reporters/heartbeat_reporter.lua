-- chunkname: @scripts/managers/telemetry/reporters/heartbeat_reporter.lua

HeartbeatReporter = class(HeartbeatReporter)
HeartbeatReporter.NAME = "HeartbeatReporter"

local SAMPLE_INTERVAL = 300

HeartbeatReporter.init = function (self)
	-- function 1
	self._last_sample_time = 0

	Managers.telemetry_events:heartbeat()
end

HeartbeatReporter.destroy = function (self)
	-- function 2
	return
end

HeartbeatReporter.update = function (self, dt, t)
	-- function 3
	if t - self._last_sample_time > SAMPLE_INTERVAL then
		Managers.telemetry_events:heartbeat()

		self._last_sample_time = math.floor(t)
	end
end

HeartbeatReporter.report = function (self)
	-- function 4
	return
end
