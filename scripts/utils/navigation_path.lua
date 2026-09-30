-- chunkname: @scripts/utils/navigation_path.lua

NavigationPath = class(NavigationPath)

NavigationPath.init = function (self, path, callback)
	-- function 1
	self._path = {}
	self._current_index = 1
	self._callback = callback

	for i = 1, #path do
		self._path[i] = Vector3Box(path[i])
	end
end

NavigationPath.current = function (self)
	-- function 2
	return self._path[self._current_index]:unbox()
end

NavigationPath.last = function (self)
	-- function 3
	return self._path[#self._path]:unbox()
end

NavigationPath.advance = function (self)
	-- function 4
	self._current_index = self._current_index + 1
end

NavigationPath.is_last = function (self)
	-- function 5
	return self._current_index == #self._path
end

NavigationPath.reset = function (self)
	-- function 6
	self._current_index = 1
end

NavigationPath.reverse = function (self)
	-- function 7
	table.reverse(self._path)
end

NavigationPath.callback = function (self)
	-- function 8
	return self._callback
end

NavigationPath.path = function (self)
	-- function 9
	return self._path
end

NavigationPath.draw = function (self, color, offset)
	-- function 10
	local drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "nav_path"
	})
	local offset = offset or Vector3(0, 0, 0)
	local previous_node

	for _, node in ipairs(self._path) do
		drawer:sphere(node:unbox() + Vector3.up() * 0.05 + offset, 0.05, color)
	end
end
