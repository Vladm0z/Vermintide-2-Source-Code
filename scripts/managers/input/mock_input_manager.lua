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

local KEYS = {
	left_hold = true,
	left_press = true
}

MockInputService.get = function (self, key)
	-- function 2
	if key == "debug_pixeldistance" then
		return false
	elseif key == "cursor" then
		return self._cursor_position
	elseif KEYS[key] then
		return false
	end

	error(string.format("Wrong parameter %q", tostring(key)))
end

MockInputService.is_blocked = function (self)
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
