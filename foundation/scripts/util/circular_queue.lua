-- chunkname: @foundation/scripts/util/circular_queue.lua

CircularQueue = class(CircularQueue)

function CircularQueue.init(arg_1_0, arg_1_1)
	arg_1_0.queue = {}
	arg_1_0.capacity = arg_1_1
	arg_1_0.first = 1
	arg_1_0.last = arg_1_1
	arg_1_0.num_items = 0
end

function CircularQueue.push_back(arg_2_0, arg_2_1)
	fassert(arg_2_1 ~= nil, "Queue can't contain nil item!")

	arg_2_0.last = arg_2_0.last % arg_2_0.capacity + 1

	fassert(arg_2_0.num_items < arg_2_0.capacity, "Can't push to full queue (%d).", arg_2_0.capacity)

	arg_2_0.num_items = arg_2_0.num_items + 1
	arg_2_0.queue[arg_2_0.last] = arg_2_1
end

function CircularQueue.write_at(arg_3_0, arg_3_1, arg_3_2)
	ferror("Disabled this for now, should probably assert that index is within first->last")
	fassert(arg_3_1 ~= nil, "Queue can't contain nil item!")
	fassert(arg_3_2 > 0 and arg_3_2 <= arg_3_0.capacity, "Wrong index!")
end

function CircularQueue.pop_first(arg_4_0)
	fassert(arg_4_0.num_items > 0, "Can't pop empty queue.")

	local var_4_0 = arg_4_0.queue[arg_4_0.first]

	arg_4_0.queue[arg_4_0.first] = nil
	arg_4_0.num_items = arg_4_0.num_items - 1
	arg_4_0.first = arg_4_0.first % arg_4_0.capacity + 1

	fassert(arg_4_0.num_items == 0 or arg_4_0.queue[arg_4_0.first] ~= nil, "Queue contained nil item!")

	return var_4_0
end

function CircularQueue.reset(arg_5_0)
	arg_5_0.first = 1
	arg_5_0.last = arg_5_0.capacity
	arg_5_0.num_items = 0
end

function CircularQueue.contains(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.first
	local var_6_1 = arg_6_0.queue

	for iter_6_0 = 1, arg_6_0.num_items do
		if arg_6_1 == var_6_1[var_6_0] then
			return true
		end

		var_6_0 = var_6_0 % arg_6_0.capacity + 1
	end

	return false
end

function CircularQueue.size(arg_7_0)
	return arg_7_0.num_items
end

function CircularQueue.available(arg_8_0)
	return arg_8_0.capacity - arg_8_0.num_items
end

function CircularQueue.is_full(arg_9_0)
	return arg_9_0.num_items == arg_9_0.capacity
end

function CircularQueue.is_empty(arg_10_0)
	return arg_10_0.num_items == 0
end

function CircularQueue.get_first(arg_11_0)
	return arg_11_0.queue[arg_11_0.first]
end

function CircularQueue.get_last(arg_12_0)
	return arg_12_0.queue[arg_12_0.last]
end

function CircularQueue.foreach(arg_13_0, arg_13_1, arg_13_2, ...)
	local var_13_0 = arg_13_0.first
	local var_13_1 = arg_13_0.queue
	local var_13_2 = arg_13_0.capacity

	for iter_13_0 = 1, arg_13_0.num_items do
		local var_13_3 = var_13_1[var_13_0]

		if arg_13_1 then
			arg_13_2(arg_13_1, var_13_3, ...)
		else
			arg_13_2(var_13_3, ...)
		end

		var_13_0 = var_13_0 % var_13_2 + 1
	end
end

function CircularQueue.index_before(arg_14_0, arg_14_1)
	return (arg_14_1 - 2) % arg_14_0.capacity + 1
end

function CircularQueue.index_after(arg_15_0, arg_15_1)
	return arg_15_1 % arg_15_0.capacity + 1
end

function CircularQueue.tostring(arg_16_0, arg_16_1, arg_16_2)
	arg_16_1 = arg_16_1 or tostring
	arg_16_2 = arg_16_2 or arg_16_0.num_items

	local var_16_0 = string.format("{[%d->%d][%d/%d] ", arg_16_0.first, arg_16_0.last, arg_16_0.num_items, arg_16_0.capacity)
	local var_16_1 = arg_16_0.first
	local var_16_2 = arg_16_0.queue

	for iter_16_0 = 1, math.min(arg_16_2, arg_16_0.num_items) do
		var_16_0 = var_16_0 .. arg_16_1(var_16_2[var_16_1]) .. ","
		var_16_1 = var_16_1 % arg_16_0.capacity + 1
	end

	if arg_16_2 < arg_16_0.num_items then
		var_16_0 = var_16_0 .. "... "
	end

	return var_16_0 .. "}"
end

function CircularQueue.tostring2(arg_17_0, arg_17_1, arg_17_2)
	arg_17_1 = arg_17_1 or tostring
	arg_17_2 = arg_17_2 or arg_17_0.num_items

	local var_17_0 = string.format("{[%d->%d][%d/%d] ", arg_17_0.first, arg_17_0.last, arg_17_0.num_items, arg_17_0.capacity)
	local var_17_1 = arg_17_0.queue

	for iter_17_0 = 1, math.min(arg_17_2, arg_17_0.capacity) do
		var_17_0 = var_17_0 .. (var_17_1[iter_17_0] and arg_17_1(var_17_1[iter_17_0]) or "_") .. ","
	end

	if arg_17_2 < arg_17_0.num_items then
		var_17_0 = var_17_0 .. "... "
	end

	return var_17_0 .. "}"
end

function CircularQueue.print_items(arg_18_0, arg_18_1)
	local var_18_0 = (arg_18_1 or "") .. " queue: [" .. arg_18_0.first .. "->" .. arg_18_0.last .. "] --> "
	local var_18_1 = arg_18_0.first
	local var_18_2 = arg_18_0.queue

	for iter_18_0 = 1, arg_18_0.num_items do
		var_18_0 = var_18_0 .. tostring(var_18_2[var_18_1]) .. ","
		var_18_1 = var_18_1 % arg_18_0.capacity + 1
	end

	print(var_18_0)
end
