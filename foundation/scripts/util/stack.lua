-- chunkname: @foundation/scripts/util/stack.lua

Stack = class(Stack)

Stack.init = function (self)
	-- function 1
	self._stack = {}
end

Stack.push = function (self, node)
	-- function 2
	table.insert(self._stack, node)
end

Stack.pop = function (self)
	-- function 3
	return table.remove(self._stack)
end

Stack.top = function (self)
	-- function 4
	return self._stack[#self._stack]
end

Stack.size = function (self)
	-- function 5
	return #self._stack
end

Stack.clear = function (self)
	-- function 6
	self._stack = {}
end
