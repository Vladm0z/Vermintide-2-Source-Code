-- chunkname: @scripts/utils/fps_reporter.lua

FPSReporter = class(FPSReporter)
FPSReporter.NAME = "FPSReporter"

local var_0_0 = 10

function FPSReporter.init(arg_1_0)
	arg_1_0._avg_fps = 0
	arg_1_0._histogram = {}
	arg_1_0._num_frames = 1

	for iter_1_0 = 1, var_0_0 + 1 do
		arg_1_0._histogram[iter_1_0] = 0
	end
end

function FPSReporter.update(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = 1 / math.max(arg_2_1, 0.001)

	arg_2_0:_update_average_fps(var_2_0)
	arg_2_0:_update_histogram(var_2_0)

	arg_2_0._num_frames = arg_2_0._num_frames + 1
end

function FPSReporter._update_average_fps(arg_3_0, arg_3_1)
	arg_3_0._avg_fps = (arg_3_1 + arg_3_0._avg_fps * (arg_3_0._num_frames - 1)) / arg_3_0._num_frames
end

function FPSReporter._update_histogram(arg_4_0, arg_4_1)
	local var_4_0 = math.clamp(math.ceil(arg_4_1 / var_0_0), 1, var_0_0 + 1)

	arg_4_0._histogram[var_4_0] = arg_4_0._histogram[var_4_0] + 1
end

function FPSReporter.report(arg_5_0)
	arg_5_0:_normalize_histogram()
	Managers.telemetry_events:fps(arg_5_0._avg_fps, arg_5_0._histogram)
end

function FPSReporter.avg_fps(arg_6_0)
	return arg_6_0._avg_fps
end

function FPSReporter._normalize_histogram(arg_7_0)
	local var_7_0 = 0

	for iter_7_0, iter_7_1 in pairs(arg_7_0._histogram) do
		var_7_0 = var_7_0 + iter_7_1
	end

	local var_7_1 = math.max(var_7_0, 1)

	for iter_7_2, iter_7_3 in pairs(arg_7_0._histogram) do
		arg_7_0._histogram[iter_7_2] = arg_7_0._histogram[iter_7_2] / var_7_1
	end
end
