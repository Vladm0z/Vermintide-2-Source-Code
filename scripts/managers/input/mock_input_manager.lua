-- chunkname: @scripts/managers/input/mock_input_manager.lua

MockInputService = class(MockInputService)

MockInputService.init = function (arg_1_0)
	arg_1_0._cursor_position = {
		-100000,
		-100000,
		-100000
	}
end

local var_0_0 = {
	left_hold = true,
	left_press = true
}

MockInputService.get = function (arg_2_0, arg_2_1)
	if arg_2_1 == "debug_pixeldistance" then
		return false
	elseif arg_2_1 == "cursor" then
		return arg_2_0._cursor_position
	elseif var_0_0[arg_2_1] then
		return false
	end

	error(string.format("Wrong parameter %q", tostring(arg_2_1)))
end

MockInputService.is_blocked = function (arg_3_0)
	return true
end

MockInputManager = class(MockInputManager)

MockInputManager.init = function (arg_4_0)
	arg_4_0._mock_input_service = MockInputService:new()
end

MockInputManager.get_service = function (arg_5_0)
	return arg_5_0._mock_input_service
end
