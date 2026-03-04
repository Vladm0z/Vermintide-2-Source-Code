-- chunkname: @scripts/utils/function_command_queue.lua

FunctionCommandQueue = class(FunctionCommandQueue)

FunctionCommandQueue.init = function (arg_1_0, arg_1_1)
	arg_1_0._command_queue = {}
	arg_1_0._next_command_index = 1
	arg_1_0._command_stride = arg_1_1 + 1
end

FunctionCommandQueue.run_commands = function (arg_2_0)
	local var_2_0 = arg_2_0._command_queue
	local var_2_1 = arg_2_0._command_stride

	for iter_2_0 = 1, arg_2_0._next_command_index - 1 do
		local var_2_2 = math.stride_index(iter_2_0, var_2_1)

		var_2_0[var_2_2](unpack_index[var_2_1 - 1](var_2_0, var_2_2 + 1))

		for iter_2_1 = 1, var_2_1 do
			var_2_0[math.stride_index(iter_2_0, var_2_1, iter_2_1)] = nil
		end
	end

	arg_2_0._next_command_index = 1
end

FunctionCommandQueue.cleanup_destroyed_unit = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._command_queue
	local var_3_1 = arg_3_0._command_stride
	local var_3_2 = Unit.animation_event
	local var_3_3 = arg_3_0._next_command_index - 1
	local var_3_4 = 1

	while var_3_4 <= var_3_3 do
		local var_3_5 = math.stride_index(var_3_4, var_3_1)

		if var_3_0[var_3_5] == var_3_2 then
			if var_3_0[var_3_5 + 1] == arg_3_1 then
				for iter_3_0 = 1, var_3_1 do
					local var_3_6 = math.stride_index(var_3_3, var_3_1, iter_3_0)

					var_3_0[math.stride_index(var_3_4, var_3_1, iter_3_0)] = var_3_0[var_3_6]
					var_3_0[var_3_6] = nil
				end

				var_3_3 = var_3_3 - 1
			else
				var_3_4 = var_3_4 + 1
			end
		else
			var_3_4 = var_3_4 + 1
		end
	end

	arg_3_0._next_command_index = var_3_3 + 1
end

FunctionCommandQueue.queue_function_command = function (arg_4_0, arg_4_1, ...)
	local var_4_0 = arg_4_0._next_command_index
	local var_4_1 = arg_4_0._command_queue

	var_4_1[math.stride_index(var_4_0, arg_4_0._command_stride)] = arg_4_1

	local var_4_2 = select
	local var_4_3 = var_4_2("#", ...)

	for iter_4_0 = 1, var_4_3 do
		var_4_1[math.stride_index(var_4_0, arg_4_0._command_stride, iter_4_0 + 1)] = var_4_2(iter_4_0, ...)
	end

	arg_4_0._next_command_index = var_4_0 + 1
end
