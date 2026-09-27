-- chunkname: @scripts/utils/navigation_path.lua

NavigationPath = class(NavigationPath)

NavigationPath.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._path = {}
	self._current_index = 1
	self._callback = arg_1_2

	for i = 1, #arg_1_1 do
		self._path[i] = Vector3Box(arg_1_1[i])
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

NavigationPath.draw = function (self, arg_10_1, arg_10_2)
	-- function 10
	local drawer = Managers.state.debug:drawer({
		mode = "immediate",
		name = "nav_path"
	})
	local flag = arg_10_2 or Vector3(0, 0, 0)
	local var_10_2

	for i, v in ipairs(self._path) do
		drawer:sphere(v:unbox() + Vector3.up() * 0.05 + flag, 0.05, arg_10_1)
	end
end
