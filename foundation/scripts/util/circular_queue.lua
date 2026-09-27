-- chunkname: @foundation/scripts/util/circular_queue.lua

CircularQueue = class(CircularQueue)

CircularQueue.init = function (self, arg_1_1)
	-- function 1
	self.queue = {}
	self.capacity = arg_1_1
	self.first = 1
	self.last = arg_1_1
	self.num_items = 0
end

CircularQueue.push_back = function (self, arg_2_1)
	-- function 2
	fassert(arg_2_1 ~= nil, "Queue can't contain nil item!")

	self.last = self.last % self.capacity + 1

	fassert(self.num_items < self.capacity, "Can't push to full queue (%d).", self.capacity)

	self.num_items = self.num_items + 1
	self.queue[self.last] = arg_2_1
end

CircularQueue.write_at = function (self, arg_3_1, arg_3_2)
	-- function 3
	ferror("Disabled this for now, should probably assert that index is within first->last")
	fassert(arg_3_1 ~= nil, "Queue can't contain nil item!")
	fassert(not (arg_3_2 > 0) or arg_3_2 <= self.capacity, "Wrong index!")
end

CircularQueue.pop_first = function (self)
	-- function 4
	fassert(self.num_items > 0, "Can't pop empty queue.")

	local var_4_0 = self.queue[self.first]

	self.queue[self.first] = nil
	self.num_items = self.num_items - 1
	self.first = self.first % self.capacity + 1

	fassert(self.num_items == 0 or self.queue[self.first] ~= nil, "Queue contained nil item!")

	return var_4_0
end

CircularQueue.reset = function (self)
	-- function 5
	self.first = 1
	self.last = self.capacity
	self.num_items = 0
end

CircularQueue.contains = function (self, arg_6_1)
	-- function 6
	local first = self.first
	local queue = self.queue

	for i = 1, self.num_items do
		if arg_6_1 == queue[first] then
			return true
		end

		first = first % self.capacity + 1
	end

	return false
end

CircularQueue.size = function (self)
	-- function 7
	return self.num_items
end

CircularQueue.available = function (self)
	-- function 8
	return self.capacity - self.num_items
end

CircularQueue.is_full = function (self)
	-- function 9
	return self.num_items == self.capacity
end

CircularQueue.is_empty = function (self)
	-- function 10
	return self.num_items == 0
end

CircularQueue.get_first = function (self)
	-- function 11
	return self.queue[self.first]
end

CircularQueue.get_last = function (self)
	-- function 12
	return self.queue[self.last]
end

CircularQueue.foreach = function (self, arg_13_1, arg_13_2, ...)
	-- function 13
	local first = self.first
	local queue = self.queue
	local capacity = self.capacity

	for i = 1, self.num_items do
		local var_13_3 = queue[first]

		if not arg_13_1 then
			arg_13_2(arg_13_1, var_13_3, ...)
		else
			arg_13_2(var_13_3, ...)
		end

		first = first % capacity + 1
	end
end

CircularQueue.index_before = function (self, arg_14_1)
	-- function 14
	return (arg_14_1 - 2) % self.capacity + 1
end

CircularQueue.index_after = function (self, arg_15_1)
	-- function 15
	return arg_15_1 % self.capacity + 1
end

CircularQueue.tostring = function (self, arg_16_1, arg_16_2)
	-- function 16
	arg_16_1 = arg_16_1 or tostring
	arg_16_2 = arg_16_2 or self.num_items

	local format = string.format("{[%d->%d][%d/%d] ", self.first, self.last, self.num_items, self.capacity)
	local first = self.first
	local queue = self.queue

	for i = 1, math.min(arg_16_2, self.num_items) do
		format = format .. arg_16_1(queue[first]) .. ","
		first = first % self.capacity + 1
	end

	if arg_16_2 < self.num_items then
		format = format .. "... "
	end

	return format .. "}"
end

CircularQueue.tostring2 = function (self, arg_17_1, arg_17_2)
	-- function 17
	arg_17_1 = arg_17_1 or tostring
	arg_17_2 = arg_17_2 or self.num_items

	local format = string.format("{[%d->%d][%d/%d] ", self.first, self.last, self.num_items, self.capacity)
	local queue = self.queue

	for i = 1, math.min(arg_17_2, self.capacity) do
		local var_17_2 = format
		local var_17_3

		if not queue[i] then
			var_17_3 = arg_17_1(queue[i])

			if not var_17_3 then
				-- Nothing
			end
		end

		var_17_3 = "_"

		::label_17_0::

		format = var_17_2 .. var_17_3 .. ","
	end

	if arg_17_2 < self.num_items then
		format = format .. "... "
	end

	return format .. "}"
end

CircularQueue.print_items = function (self, arg_18_1)
	-- function 18
	local str = (arg_18_1 or "") .. " queue: [" .. self.first .. "->" .. self.last .. "] --> "
	local first = self.first
	local queue = self.queue

	for i = 1, self.num_items do
		str = str .. tostring(queue[first]) .. ","
		first = first % self.capacity + 1
	end

	print(str)
end
