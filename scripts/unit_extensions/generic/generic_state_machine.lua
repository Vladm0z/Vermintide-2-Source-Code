-- chunkname: @scripts/unit_extensions/generic/generic_state_machine.lua

local script_data = script_data
local debug_state_machines = script_data.debug_state_machines

debug_state_machines = debug_state_machines or Development.parameter("debug_state_machines")
script_data.debug_state_machines = debug_state_machines

local tbl = {
	__index = function (arg_1_0, arg_1_1)
		-- function 1
		return nil
	end,
	__newindex = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		error("FAIL : tried to set [" .. arg_2_1 .. "] to [" .. tostring(arg_2_2) .. "]")
	end
}

GenericStateMachine = class(GenericStateMachine)

GenericStateMachine.init = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self.unit = arg_3_2
	self.debugging = false
end

GenericStateMachine.post_init = function (self, arg_4_1, arg_4_2)
	-- function 4
	self.states = arg_4_1
	self.dummy_params = setmetatable({}, tbl)
	self.dummy_state = setmetatable({
		name = "dummy",
		update = function ()
			-- function 5
			return
		end,
		on_exit = function ()
			-- function 6
			return
		end
	}, tbl)
	self.state_current = self.dummy_state
	self.state_next = arg_4_2
	self.state_next_params = {}
end

GenericStateMachine.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	if self.state_current ~= nil then
		self.state_current:update(arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	end

	if not script_data.debug_state_machines then
		if self.state_next ~= nil then
			printf("Changing state from %s to %s on unit %s", self.state_current.name, self.state_next, self.unit)
			Debug.text("State: %s -> %s", self.state_current.name, self.state_next)
		else
			Debug.text("State: %s", self.state_current.name)
		end
	end

	if self.state_next ~= nil then
		local flag = false

		self.state_current:on_exit(arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, self.state_next, flag)

		local var_7_1 = self.states[self.state_next]
		local var_7_2 = var_7_1
		local on_enter = var_7_1.on_enter
		local var_7_4 = arg_7_1
		local var_7_5 = arg_7_2
		local var_7_6 = arg_7_3
		local var_7_7 = arg_7_4
		local var_7_8 = arg_7_5
		local name = self.state_current.name
		local state_next_params = self.state_next_params

		state_next_params = state_next_params or self.dummy_params

		on_enter(var_7_2, var_7_4, var_7_5, var_7_6, var_7_7, var_7_8, name, state_next_params)

		self.state_current = var_7_1
		self.state_next = nil
		self.state_next_params = nil
	end

	if self.debugging ~= script_data.debug_state_machines then
		self.debugging = not not script_data.debug_state_machines
	end
end

GenericStateMachine.change_state = function (self, arg_8_1, arg_8_2)
	-- function 8
	assert(self.state_next == nil, "next state is already set ")

	self.state_next = arg_8_1
	self.state_next_params = arg_8_2
end

GenericStateMachine.exit_current_state = function (self, arg_9_1)
	-- function 9
	if not self.state_current then
		local time = Managers.time:time("game")
		local var_9_1
		local var_9_2
		local var_9_3
		local var_9_4

		self.state_current:on_exit(self.unit, var_9_1, var_9_4, var_9_2, time, var_9_3, arg_9_1)

		self.state_current = nil
	end
end

GenericStateMachine.current_state = function (self)
	-- function 10
	local name

	if not self.state_current then
		name = self.state_current.name

		if not name then
			-- Nothing
		end
	end

	name = "none"

	::label_10_0::

	return name
end
