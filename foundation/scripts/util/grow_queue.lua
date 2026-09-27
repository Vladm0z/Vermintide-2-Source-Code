-- chunkname: @foundation/scripts/util/grow_queue.lua

GrowQueue = class(GrowQueue)

GrowQueue.init = function (self)
	-- function 1
	self.queue = {}
	self.first = 1
	self.last = 0
end

GrowQueue.push_back = function (self, arg_2_1)
	-- function 2
	self.last = self.last + 1
	self.queue[self.last] = arg_2_1
end

GrowQueue.pop_first = function (self)
	-- function 3
	if self.first > self.last then
		return
	end

	local var_3_0 = self.queue[self.first]

	self.queue[self.first] = nil

	if self.first == self.last then
		self.first = 0
		self.last = 0
	end

	self.first = self.first + 1

	return var_3_0
end

GrowQueue.contains = function (self, arg_4_1)
	-- function 4
	local first = self.first
	local last = self.last
	local queue = self.queue

	for i = first, last do
		if arg_4_1 == queue[i] then
			return true
		end
	end

	return false
end

GrowQueue.size = function (self)
	-- function 5
	return self.last - self.first + 1
end

GrowQueue.get_first = function (self)
	-- function 6
	return self.queue[self.first]
end

GrowQueue.get_last = function (self)
	-- function 7
	return self.queue[self._last]
end

GrowQueue.print_items = function (self, arg_8_1)
	-- function 8
	local str = (arg_8_1 or "") .. " queue: [" .. self.first .. "->" .. self.last .. "] --> "

	for i = self.first, self.last do
		str = str .. tostring(self.queue[i]) .. ","
	end

	print(str)
end
