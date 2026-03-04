-- chunkname: @scripts/unit_extensions/generic/generic_state_machine.lua

script_data.debug_state_machines = script_data.debug_state_machines or Development.parameter("debug_state_machines")

local var_0_0 = {
	__index = function(arg_1_0, arg_1_1)
		return nil
	end,
	__newindex = function(arg_2_0, arg_2_1, arg_2_2)
		error("FAIL : tried to set [" .. arg_2_1 .. "] to [" .. tostring(arg_2_2) .. "]")
	end
}

GenericStateMachine = class(GenericStateMachine)

function GenericStateMachine.init(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0.unit = arg_3_2
	arg_3_0.debugging = false
end

function GenericStateMachine.post_init(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.states = arg_4_1
	arg_4_0.dummy_params = setmetatable({}, var_0_0)
	arg_4_0.dummy_state = setmetatable({
		name = "dummy",
		update = function()
			return
		end,
		on_exit = function()
			return
		end
	}, var_0_0)
	arg_4_0.state_current = arg_4_0.dummy_state
	arg_4_0.state_next = arg_4_2
	arg_4_0.state_next_params = {}
end

function GenericStateMachine.update(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	if arg_7_0.state_current ~= nil then
		arg_7_0.state_current:update(arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	end

	if script_data.debug_state_machines then
		if arg_7_0.state_next ~= nil then
			printf("Changing state from %s to %s on unit %s", arg_7_0.state_current.name, arg_7_0.state_next, arg_7_0.unit)
			Debug.text("State: %s -> %s", arg_7_0.state_current.name, arg_7_0.state_next)
		else
			Debug.text("State: %s", arg_7_0.state_current.name)
		end
	end

	if arg_7_0.state_next ~= nil then
		local var_7_0 = false

		arg_7_0.state_current:on_exit(arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_0.state_next, var_7_0)

		local var_7_1 = arg_7_0.states[arg_7_0.state_next]

		var_7_1:on_enter(arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_0.state_current.name, arg_7_0.state_next_params or arg_7_0.dummy_params)

		arg_7_0.state_current = var_7_1
		arg_7_0.state_next = nil
		arg_7_0.state_next_params = nil
	end

	if arg_7_0.debugging ~= script_data.debug_state_machines then
		arg_7_0.debugging = not not script_data.debug_state_machines
	end
end

function GenericStateMachine.change_state(arg_8_0, arg_8_1, arg_8_2)
	assert(arg_8_0.state_next == nil, "next state is already set ")

	arg_8_0.state_next = arg_8_1
	arg_8_0.state_next_params = arg_8_2
end

function GenericStateMachine.exit_current_state(arg_9_0, arg_9_1)
	if arg_9_0.state_current then
		local var_9_0 = Managers.time:time("game")
		local var_9_1
		local var_9_2
		local var_9_3
		local var_9_4

		arg_9_0.state_current:on_exit(arg_9_0.unit, var_9_1, var_9_4, var_9_2, var_9_0, var_9_3, arg_9_1)

		arg_9_0.state_current = nil
	end
end

function GenericStateMachine.current_state(arg_10_0)
	return arg_10_0.state_current and arg_10_0.state_current.name or "none"
end
