-- chunkname: @foundation/scripts/util/visual_state_machine.lua

VisualStateMachine = class(VisualStateMachine)
VisualStateMachine.DEBUG = false

local function var_0_0(arg_1_0, ...)
	if VisualStateMachine.DEBUG then
		printf("[VisualStateMachine] " .. arg_1_0, ...)
	end
end

VisualStateMachine.init = function (arg_2_0, arg_2_1, arg_2_2, ...)
	assert(type(arg_2_1) == "string", "state machine name must be specified and be a string")

	arg_2_0._name = arg_2_1
	arg_2_0._global_args = {
		...
	}
	arg_2_0._events = {}
	arg_2_0._pending_event = nil
	arg_2_0._pending_args = nil

	if arg_2_2 then
		arg_2_0._root_state_machine = arg_2_2._root_state_machine
	else
		arg_2_0._root_state_machine = arg_2_0
	end

	if arg_2_2 ~= nil then
		local var_2_0 = arg_2_2._root_state_machine._state_machine_stack

		assert(var_2_0[#var_2_0] == arg_2_2, "the parent must be last in the stack")

		arg_2_0._state_machine_stack = var_2_0
		var_2_0[#var_2_0 + 1] = arg_2_0
	else
		arg_2_0._state_machine_stack = {
			arg_2_0
		}
	end

	arg_2_0._current_state = nil
	arg_2_0._transitions = {}

	Managers.state_machine:_register_state_machine(arg_2_0)
end

VisualStateMachine.destroy = function (arg_3_0)
	local var_3_0 = arg_3_0._current_state

	arg_3_0._current_state = nil

	if var_3_0 ~= nil then
		if var_3_0.leave ~= nil then
			var_3_0:leave()
		end

		if var_3_0.destroy ~= nil then
			var_3_0:destroy()
		end
	end

	local var_3_1 = arg_3_0._state_machine_stack

	assert(var_3_1[#var_3_1] == arg_3_0, "state machines must be destroyed in reversed creation order")
	table.remove(var_3_1, #var_3_1)

	arg_3_0._root_state_machine = nil
	arg_3_0._state_machine_stack = nil

	Managers.state_machine:_unregister_state_machine(arg_3_0)
end

VisualStateMachine.add_transition = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0._transitions

	if var_4_0[arg_4_1] == nil then
		var_4_0[arg_4_1] = {}
	end

	local var_4_1 = var_4_0[arg_4_1]

	assert(var_4_1[arg_4_2] == nil, "the event " .. arg_4_2 .. " already has a transition to " .. tostring(var_4_1[arg_4_2]))

	var_4_1[arg_4_2] = arg_4_3
end

VisualStateMachine.remove_transition = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._transitions[arg_5_1]

	if var_5_0 == nil then
		return
	end

	var_5_0[arg_5_2] = nil
end

VisualStateMachine.set_transitions = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._transitions[arg_6_1] = arg_6_2
end

VisualStateMachine.set_initial_state = function (arg_7_0, arg_7_1, ...)
	assert(arg_7_0._current_state == nil, "it is not allowed to set initial state twice")

	arg_7_0._current_state = arg_7_0:_enter_state(arg_7_1, {
		...
	})
end

VisualStateMachine.update = function (arg_8_0, arg_8_1, arg_8_2)
	if arg_8_0._root_state_machine ~= arg_8_0 then
		return
	end

	local var_8_0 = arg_8_0._state_machine_stack
	local var_8_1 = #arg_8_0._state_machine_stack

	for iter_8_0, iter_8_1 in ipairs(arg_8_0._state_machine_stack) do
		local var_8_2 = iter_8_1._current_state
		local var_8_3

		if iter_8_0 == var_8_1 then
			if var_8_2 ~= nil and var_8_2.update ~= nil then
				var_8_3 = var_8_2.update
			end
		elseif var_8_2 ~= nil and var_8_2.parent_update ~= nil then
			var_8_3 = var_8_2.parent_update
		end

		if var_8_3 ~= nil then
			local var_8_4 = {
				var_8_3(var_8_2, arg_8_1, arg_8_2)
			}
			local var_8_5 = var_8_4[1]

			table.remove(var_8_4, 1)

			local var_8_6 = arg_8_0._root_state_machine

			if var_8_6._pending_event ~= nil then
				var_8_5 = var_8_6._pending_event
				var_8_4 = var_8_6._pending_args
				var_8_6._pending_event = nil
				var_8_6._pending_args = nil
			end

			if var_8_5 ~= nil and iter_8_0 >= arg_8_0:_received_event(var_8_5, var_8_4) then
				break
			end
		end
	end
end

VisualStateMachine.event = function (arg_9_0, arg_9_1, ...)
	local var_9_0 = arg_9_0._root_state_machine

	var_9_0._pending_event = arg_9_1
	var_9_0._pending_args = {
		...
	}
end

VisualStateMachine.state_report = function (arg_10_0)
	local var_10_0 = ""
	local var_10_1 = arg_10_0._state_machine_stack
	local var_10_2 = arg_10_0.find_in_table(var_10_1, arg_10_0)

	assert(var_10_2 ~= nil, "to make a state report the state machine itself must be on the stack")

	for iter_10_0 = var_10_2, #var_10_1 do
		local var_10_3 = var_10_1[iter_10_0]

		var_10_0 = var_10_0 .. string.format("State %q waits for:\n", arg_10_0._current_state_name(var_10_3))

		local var_10_4 = var_10_3:_transitions_from_state()
		local var_10_5 = false

		for iter_10_1, iter_10_2 in pairs(var_10_4) do
			var_10_5 = true
			var_10_0 = var_10_0 .. string.format("  %q => %s\n", iter_10_1, iter_10_2.NAME)
		end

		if not var_10_5 then
			var_10_0 = var_10_0 .. "  <nothing>\n"
		end
	end

	return var_10_0
end

VisualStateMachine._transitions_from_state = function (arg_11_0)
	if arg_11_0._current_state == nil then
		return {}
	end

	local var_11_0 = arg_11_0._transitions[arg_11_0._current_state.NAME]

	if var_11_0 == nil then
		return {}
	end

	return var_11_0
end

VisualStateMachine._current_state_name = function (arg_12_0)
	local var_12_0 = arg_12_0._name
	local var_12_1 = "<no state>"

	if arg_12_0._current_state ~= nil then
		var_12_1 = arg_12_0._current_state.NAME

		if arg_12_0._current_state.name ~= nil then
			var_12_1 = var_12_1 .. ":" .. arg_12_0._current_state.name
		end
	end

	return var_12_0 .. ":" .. var_12_1
end

VisualStateMachine._handle_event = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._current_state

	if var_13_0 ~= nil then
		local var_13_1 = arg_13_0._transitions[var_13_0.NAME]

		if var_13_1 ~= nil then
			local var_13_2 = var_13_1[arg_13_1]

			if var_13_2 ~= nil then
				arg_13_0:_leave_state()
				arg_13_0:_enter_state(var_13_2, arg_13_2)

				return true
			end
		end
	end

	return false
end

VisualStateMachine._received_event = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._state_machine_stack

	for iter_14_0 = #var_14_0, 1, -1 do
		if var_14_0[iter_14_0]:_handle_event(arg_14_1, arg_14_2) then
			return iter_14_0
		end
	end

	local var_14_1 = {}

	for iter_14_1, iter_14_2 in ipairs(arg_14_0._state_machine_stack) do
		var_14_1[#var_14_1 + 1] = arg_14_0._current_state_name(iter_14_2)
	end

	local var_14_2 = string.format("none of the active states (%s) handled the event %q\n", table.concat(var_14_1, ", "), arg_14_1) .. arg_14_0._root_state_machine:state_report()

	assert(false, var_14_2)
end

VisualStateMachine.find_in_table = function (arg_15_0, arg_15_1)
	for iter_15_0, iter_15_1 in ipairs(arg_15_0) do
		if iter_15_1 == arg_15_1 then
			return iter_15_0
		end
	end
end

VisualStateMachine._leave_state = function (arg_16_0)
	local var_16_0 = arg_16_0._state_machine_stack
	local var_16_1 = arg_16_0.find_in_table(var_16_0, arg_16_0)

	assert(var_16_1 ~= nil, "leaving a state requires the state machine to be in the state machine stack")

	for iter_16_0 = #var_16_0, var_16_1, -1 do
		local var_16_2 = var_16_0[iter_16_0]
		local var_16_3 = var_16_2._current_state

		if var_16_3.leave then
			var_16_3:leave()
		end

		var_16_2._current_state = nil

		if var_16_3.destroy ~= nil then
			var_16_3:destroy()
		end
	end
end

VisualStateMachine._enter_state = function (arg_17_0, arg_17_1, arg_17_2)
	assert(arg_17_0._current_state == nil, "entering a state twice is not allowed")
	assert(type(arg_17_1.NAME) == "string", "States must have a class variable NAME set to a string value")

	local var_17_0 = arg_17_1:new(arg_17_0, unpack(arg_17_0._global_args))

	arg_17_0._current_state = var_17_0

	if var_17_0.enter then
		var_17_0:enter(unpack(arg_17_2))
	end

	return var_17_0
end
