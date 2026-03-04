-- chunkname: @scripts/managers/input/mock_input_manager.lua

MockInputService = class(MockInputService)

function MockInputService.init(arg_1_0)
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

function MockInputService.get(arg_2_0, arg_2_1)
	if arg_2_1 == "debug_pixeldistance" then
		return false
	elseif arg_2_1 == "cursor" then
		return arg_2_0._cursor_position
	elseif var_0_0[arg_2_1] then
		return false
	end

	error(string.format("Wrong parameter %q", tostring(arg_2_1)))
end

function MockInputService.is_blocked(arg_3_0)
	return true
end

MockInputManager = class(MockInputManager)

function MockInputManager.init(arg_4_0)
	arg_4_0._mock_input_service = MockInputService:new()
end

function MockInputManager.get_service(arg_5_0)
	return arg_5_0._mock_input_service
end
