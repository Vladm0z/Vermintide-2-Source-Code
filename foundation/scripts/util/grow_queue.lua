-- chunkname: @foundation/scripts/util/grow_queue.lua

GrowQueue = class(GrowQueue)

GrowQueue.init = function (arg_1_0)
	arg_1_0.queue = {}
	arg_1_0.first = 1
	arg_1_0.last = 0
end

GrowQueue.push_back = function (arg_2_0, arg_2_1)
	arg_2_0.last = arg_2_0.last + 1
	arg_2_0.queue[arg_2_0.last] = arg_2_1
end

GrowQueue.pop_first = function (arg_3_0)
	if arg_3_0.first > arg_3_0.last then
		return
	end

	local var_3_0 = arg_3_0.queue[arg_3_0.first]

	arg_3_0.queue[arg_3_0.first] = nil

	if arg_3_0.first == arg_3_0.last then
		arg_3_0.first = 0
		arg_3_0.last = 0
	end

	arg_3_0.first = arg_3_0.first + 1

	return var_3_0
end

GrowQueue.contains = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.first
	local var_4_1 = arg_4_0.last
	local var_4_2 = arg_4_0.queue

	for iter_4_0 = var_4_0, var_4_1 do
		if arg_4_1 == var_4_2[iter_4_0] then
			return true
		end
	end

	return false
end

GrowQueue.size = function (arg_5_0)
	return arg_5_0.last - arg_5_0.first + 1
end

GrowQueue.get_first = function (arg_6_0)
	return arg_6_0.queue[arg_6_0.first]
end

GrowQueue.get_last = function (arg_7_0)
	return arg_7_0.queue[arg_7_0._last]
end

GrowQueue.print_items = function (arg_8_0, arg_8_1)
	local var_8_0 = (arg_8_1 or "") .. " queue: [" .. arg_8_0.first .. "->" .. arg_8_0.last .. "] --> "

	for iter_8_0 = arg_8_0.first, arg_8_0.last do
		var_8_0 = var_8_0 .. tostring(arg_8_0.queue[iter_8_0]) .. ","
	end

	print(var_8_0)
end
