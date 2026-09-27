-- chunkname: @foundation/scripts/util/visual_state_machine.lua

VisualStateMachine = class(VisualStateMachine)
VisualStateMachine.DEBUG = false

local function fn(arg_1_0, ...)
	-- function 1
	if not VisualStateMachine.DEBUG then
		printf("[VisualStateMachine] " .. arg_1_0, ...)
	end
end

VisualStateMachine.init = function (self, arg_2_1, arg_2_2, ...)
	-- function 2
	assert(type(arg_2_1) == "string", "state machine name must be specified and be a string")

	self._name = arg_2_1
	self._global_args = {
		...
	}
	self._events = {}
	self._pending_event = nil
	self._pending_args = nil

	if not arg_2_2 then
		self._root_state_machine = arg_2_2._root_state_machine
	else
		self._root_state_machine = self
	end

	if arg_2_2 ~= nil then
		local _state_machine_stack = arg_2_2._root_state_machine._state_machine_stack

		assert(_state_machine_stack[#_state_machine_stack] == arg_2_2, "the parent must be last in the stack")

		self._state_machine_stack = _state_machine_stack
		_state_machine_stack[#_state_machine_stack + 1] = self
	else
		self._state_machine_stack = {
			self
		}
	end

	self._current_state = nil
	self._transitions = {}

	Managers.state_machine:_register_state_machine(self)
end

VisualStateMachine.destroy = function (self)
	-- function 3
	local _current_state = self._current_state

	self._current_state = nil

	if _current_state ~= nil then
		if _current_state.leave ~= nil then
			_current_state:leave()
		end

		if _current_state.destroy ~= nil then
			_current_state:destroy()
		end
	end

	local _state_machine_stack = self._state_machine_stack

	assert(_state_machine_stack[#_state_machine_stack] == self, "state machines must be destroyed in reversed creation order")
	table.remove(_state_machine_stack, #_state_machine_stack)

	self._root_state_machine = nil
	self._state_machine_stack = nil

	Managers.state_machine:_unregister_state_machine(self)
end

VisualStateMachine.add_transition = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local _transitions = self._transitions

	if _transitions[arg_4_1] == nil then
		_transitions[arg_4_1] = {}
	end

	local var_4_1 = _transitions[arg_4_1]

	assert(var_4_1[arg_4_2] == nil, "the event " .. arg_4_2 .. " already has a transition to " .. tostring(var_4_1[arg_4_2]))

	var_4_1[arg_4_2] = arg_4_3
end

VisualStateMachine.remove_transition = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = self._transitions[arg_5_1]

	if var_5_0 == nil then
		return
	end

	var_5_0[arg_5_2] = nil
end

VisualStateMachine.set_transitions = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	arg_6_0._transitions[arg_6_1] = arg_6_2
end

VisualStateMachine.set_initial_state = function (self, arg_7_1, ...)
	-- function 7
	assert(self._current_state == nil, "it is not allowed to set initial state twice")

	self._current_state = self:_enter_state(arg_7_1, {
		...
	})
end

VisualStateMachine.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	if self._root_state_machine ~= self then
		return
	end

	local _state_machine_stack = self._state_machine_stack
	local count = #self._state_machine_stack

	for i, v in ipairs(self._state_machine_stack) do
		local _current_state = v._current_state
		local var_8_3

		if i == count then
			if not (_current_state == nil or _current_state.update == nil) then
				var_8_3 = _current_state.update
			end
		elseif not (_current_state == nil or _current_state.parent_update == nil) then
			var_8_3 = _current_state.parent_update
		end

		if var_8_3 ~= nil then
			local tbl = {
				var_8_3(_current_state, arg_8_1, arg_8_2)
			}
			local var_8_5 = tbl[1]

			table.remove(tbl, 1)

			local _root_state_machine = self._root_state_machine

			if _root_state_machine._pending_event ~= nil then
				var_8_5 = _root_state_machine._pending_event
				tbl = _root_state_machine._pending_args
				_root_state_machine._pending_event = nil
				_root_state_machine._pending_args = nil
			end

			if not (var_8_5 == nil or not (i >= self:_received_event(var_8_5, tbl))) then
				break
			end
		end
	end
end

VisualStateMachine.event = function (self, arg_9_1, ...)
	-- function 9
	local _root_state_machine = self._root_state_machine

	_root_state_machine._pending_event = arg_9_1
	_root_state_machine._pending_args = {
		...
	}
end

VisualStateMachine.state_report = function (self)
	-- function 10
	local str = ""
	local _state_machine_stack = self._state_machine_stack
	local find_in_table = self.find_in_table(_state_machine_stack, self)

	assert(find_in_table ~= nil, "to make a state report the state machine itself must be on the stack")

	for i = find_in_table, #_state_machine_stack do
		local var_10_3 = _state_machine_stack[i]

		str = str .. string.format("State %q waits for:\n", self._current_state_name(var_10_3))

		local _transitions_from_state = var_10_3:_transitions_from_state()
		local flag = false

		for k, v in pairs(_transitions_from_state) do
			flag = true
			str = str .. string.format("  %q => %s\n", k, v.NAME)
		end

		if not flag then
			str = str .. "  <nothing>\n"
		end
	end

	return str
end

VisualStateMachine._transitions_from_state = function (self)
	-- function 11
	if self._current_state == nil then
		return {}
	end

	local var_11_0 = self._transitions[self._current_state.NAME]

	if var_11_0 == nil then
		return {}
	end

	return var_11_0
end

VisualStateMachine._current_state_name = function (self)
	-- function 12
	local _name = self._name
	local str = "<no state>"

	if self._current_state ~= nil then
		str = self._current_state.NAME

		if self._current_state.name ~= nil then
			str = str .. ":" .. self._current_state.name
		end
	end

	return _name .. ":" .. str
end

VisualStateMachine._handle_event = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _current_state = self._current_state

	if _current_state ~= nil then
		local var_13_1 = self._transitions[_current_state.NAME]

		if var_13_1 ~= nil then
			local var_13_2 = var_13_1[arg_13_1]

			if var_13_2 ~= nil then
				self:_leave_state()
				self:_enter_state(var_13_2, arg_13_2)

				return true
			end
		end
	end

	return false
end

VisualStateMachine._received_event = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _state_machine_stack = self._state_machine_stack

	for i = #_state_machine_stack, 1, -1 do
		if not _state_machine_stack[i]:_handle_event(arg_14_1, arg_14_2) then
			return i
		end
	end

	local tbl = {}

	for i_2, v in ipairs(self._state_machine_stack) do
		tbl[#tbl + 1] = self._current_state_name(v)
	end

	local str = string.format("none of the active states (%s) handled the event %q\n", table.concat(tbl, ", "), arg_14_1) .. self._root_state_machine:state_report()

	assert(false, str)
end

VisualStateMachine.find_in_table = function (arg_15_0, arg_15_1)
	-- function 15
	for i, v in ipairs(arg_15_0) do
		if v == arg_15_1 then
			return i
		end
	end
end

VisualStateMachine._leave_state = function (self)
	-- function 16
	local _state_machine_stack = self._state_machine_stack
	local find_in_table = self.find_in_table(_state_machine_stack, self)

	assert(find_in_table ~= nil, "leaving a state requires the state machine to be in the state machine stack")

	for i = #_state_machine_stack, find_in_table, -1 do
		local var_16_2 = _state_machine_stack[i]
		local _current_state = var_16_2._current_state

		if not _current_state.leave then
			_current_state:leave()
		end

		var_16_2._current_state = nil

		if _current_state.destroy ~= nil then
			_current_state:destroy()
		end
	end
end

VisualStateMachine._enter_state = function (self, arg_17_1, arg_17_2)
	-- function 17
	assert(self._current_state == nil, "entering a state twice is not allowed")
	assert(type(arg_17_1.NAME) == "string", "States must have a class variable NAME set to a string value")

	local var_17_0 = arg_17_1:new(self, unpack(self._global_args))

	self._current_state = var_17_0

	if not var_17_0.enter then
		var_17_0:enter(unpack(arg_17_2))
	end

	return var_17_0
end
