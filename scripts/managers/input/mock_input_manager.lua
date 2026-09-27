-- chunkname: @scripts/managers/input/mock_input_manager.lua

MockInputService = class(MockInputService)

MockInputService.init = function (self)
	-- function 1
	self._cursor_position = {
		-100000,
		-100000,
		-100000
	}
end

local tbl = {
	left_hold = true,
	left_press = true
}

MockInputService.get = function (self, arg_2_1)
	-- function 2
	if arg_2_1 == "debug_pixeldistance" then
		return false
	elseif arg_2_1 == "cursor" then
		return self._cursor_position
	elseif not tbl[arg_2_1] then
		return false
	end

	error(string.format("Wrong parameter %q", tostring(arg_2_1)))
end

MockInputService.is_blocked = function (arg_3_0)
	-- function 3
	return true
end

MockInputManager = class(MockInputManager)

MockInputManager.init = function (self)
	-- function 4
	self._mock_input_service = MockInputService:new()
end

MockInputManager.get_service = function (self)
	-- function 5
	return self._mock_input_service
end
