-- chunkname: @scripts/managers/telemetry/telemetry_reporters.lua

require("scripts/managers/telemetry/reporters/heartbeat_reporter")

TelemetryReporters = class(TelemetryReporters)
TelemetryReporters.NAME = "TelemetryReporters"

local tbl = {
	heartbeat = HeartbeatReporter
}

TelemetryReporters.init = function (self)
	-- function 1
	self._reporters = {}

	self:start_reporter("heartbeat")
end

TelemetryReporters.start_reporter = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0 = tbl[arg_2_1]

	arg_2_0._reporters[arg_2_1] = var_2_0:new(arg_2_2)
end

TelemetryReporters.stop_reporter = function (self, arg_3_1)
	-- function 3
	self._reporters[arg_3_1]:report()
	self._reporters[arg_3_1]:destroy()

	self._reporters[arg_3_1] = nil
end

TelemetryReporters.reporter = function (self, arg_4_1)
	-- function 4
	return self._reporters[arg_4_1]
end

TelemetryReporters.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	for k, v in pairs(self._reporters) do
		v:update(arg_5_1, arg_5_2)
	end
end

TelemetryReporters.destroy = function (self)
	-- function 6
	for k, v in pairs(self._reporters) do
		v:destroy()
	end
end

return TelemetryReporters
