-- chunkname: @foundation/scripts/util/state_machine.lua

local var_0_0 = {}

local function var_0_1(arg_1_0, arg_1_1)
	assert(arg_1_0, "State without name not allowed.")

	local var_1_0 = var_0_0[arg_1_0]

	if var_1_0 == nil then
		var_1_0 = {
			create = arg_1_0 .. ":new",
			enter = arg_1_0 .. ":on_enter",
			exit = arg_1_0 .. ":on_exit"
		}
		var_0_0[arg_1_0] = var_1_0
	end

	local var_1_1 = var_1_0[arg_1_1]

	assert(var_1_1)

	return var_1_1
end

StateMachine = class(StateMachine)

local function var_0_2(arg_2_0, ...)
	cprintf("[StateMachine] " .. arg_2_0, ...)
end

function StateMachine.init(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0._parent = arg_3_1
	arg_3_0._params = arg_3_3
	arg_3_0._profiling_debugging_enabled = arg_3_4

	arg_3_0:_change_state(arg_3_2, arg_3_3)
end

function StateMachine._change_state(arg_4_0, arg_4_1, arg_4_2)
	if arg_4_0._state then
		if arg_4_0._state.on_exit and arg_4_0._profiling_debugging_enabled then
			local var_4_0 = var_0_1(arg_4_0._state.NAME, "exit")

			arg_4_0._state:on_exit()
		elseif arg_4_0._state.on_exit then
			arg_4_0._state:on_exit()
		end
	end

	if arg_4_0._profiling_debugging_enabled then
		local var_4_1 = var_0_1(arg_4_1.NAME, "create")

		arg_4_0._state = arg_4_1:new()
	else
		arg_4_0._state = arg_4_1:new()
	end

	arg_4_0._state.parent = arg_4_0._parent

	if arg_4_0._state.on_enter and arg_4_0._profiling_debugging_enabled then
		local var_4_2 = var_0_1(arg_4_0._state.NAME, "enter")

		arg_4_0._state:on_enter(arg_4_2)
	elseif arg_4_0._state.on_enter then
		arg_4_0._state:on_enter(arg_4_2)
	end
end

function StateMachine.state(arg_5_0)
	return arg_5_0._state
end

function StateMachine.update(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._state:update(arg_6_1, arg_6_2)

	if var_6_0 then
		arg_6_0:_change_state(var_6_0, arg_6_0._params)
	end
end

function StateMachine.destroy(arg_7_0, ...)
	if arg_7_0._state and arg_7_0._state.on_exit then
		arg_7_0._state:on_exit(...)
	end
end

function StateMachine.on_close(arg_8_0)
	if arg_8_0._state and arg_8_0._state.on_close then
		return arg_8_0._state:on_close()
	end

	return true
end
