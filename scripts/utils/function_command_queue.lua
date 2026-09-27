-- chunkname: @scripts/utils/function_command_queue.lua

FunctionCommandQueue = class(FunctionCommandQueue)

FunctionCommandQueue.init = function (self, arg_1_1)
	-- function 1
	self._command_queue = {}
	self._next_command_index = 1
	self._command_stride = arg_1_1 + 1
end

FunctionCommandQueue.run_commands = function (self)
	-- function 2
	local _command_queue = self._command_queue
	local _command_stride = self._command_stride

	for i = 1, self._next_command_index - 1 do
		local stride_index = math.stride_index(i, _command_stride)

		_command_queue[stride_index](unpack_index[_command_stride - 1](_command_queue, stride_index + 1))

		for j = 1, _command_stride do
			_command_queue[math.stride_index(i, _command_stride, j)] = nil
		end
	end

	self._next_command_index = 1
end

FunctionCommandQueue.cleanup_destroyed_unit = function (self, arg_3_1)
	-- function 3
	local _command_queue = self._command_queue
	local _command_stride = self._command_stride
	local animation_event = Unit.animation_event
	local num = self._next_command_index - 1
	local num_2 = 1

	while num_2 <= num do
		local stride_index = math.stride_index(num_2, _command_stride)

		if _command_queue[stride_index] == animation_event then
			if _command_queue[stride_index + 1] == arg_3_1 then
				for i = 1, _command_stride do
					local stride_index_2 = math.stride_index(num, _command_stride, i)

					_command_queue[math.stride_index(num_2, _command_stride, i)] = _command_queue[stride_index_2]
					_command_queue[stride_index_2] = nil
				end

				num = num - 1
			else
				num_2 = num_2 + 1
			end
		else
			num_2 = num_2 + 1
		end
	end

	self._next_command_index = num + 1
end

FunctionCommandQueue.queue_function_command = function (self, arg_4_1, ...)
	-- function 4
	local _next_command_index = self._next_command_index
	local _command_queue = self._command_queue

	_command_queue[math.stride_index(_next_command_index, self._command_stride)] = arg_4_1

	local select = select
	local var_4_3 = select("#", ...)

	for i = 1, var_4_3 do
		_command_queue[math.stride_index(_next_command_index, self._command_stride, i + 1)] = select(i, ...)
	end

	self._next_command_index = _next_command_index + 1
end
