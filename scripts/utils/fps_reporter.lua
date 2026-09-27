-- chunkname: @scripts/utils/fps_reporter.lua

FPSReporter = class(FPSReporter)
FPSReporter.NAME = "FPSReporter"

local num = 10

FPSReporter.init = function (self)
	-- function 1
	self._avg_fps = 0
	self._histogram = {}
	self._num_frames = 1

	for i = 1, num + 1 do
		self._histogram[i] = 0
	end
end

FPSReporter.update = function (self, arg_2_1, arg_2_2)
	-- function 2
	local num = 1 / math.max(arg_2_1, 0.001)

	self:_update_average_fps(num)
	self:_update_histogram(num)

	self._num_frames = self._num_frames + 1
end

FPSReporter._update_average_fps = function (self, arg_3_1)
	-- function 3
	self._avg_fps = (arg_3_1 + self._avg_fps * (self._num_frames - 1)) / self._num_frames
end

FPSReporter._update_histogram = function (self, arg_4_1)
	-- function 4
	local clamp = math.clamp(math.ceil(arg_4_1 / num), 1, num + 1)

	self._histogram[clamp] = self._histogram[clamp] + 1
end

FPSReporter.report = function (self)
	-- function 5
	self:_normalize_histogram()
	Managers.telemetry_events:fps(self._avg_fps, self._histogram)
end

FPSReporter.avg_fps = function (self)
	-- function 6
	return self._avg_fps
end

FPSReporter._normalize_histogram = function (self)
	-- function 7
	local num = 0

	for k, v in pairs(self._histogram) do
		num = num + v
	end

	local max = math.max(num, 1)

	for k_2, v_2 in pairs(self._histogram) do
		self._histogram[k_2] = self._histogram[k_2] / max
	end
end
