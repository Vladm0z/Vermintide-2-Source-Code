-- chunkname: @foundation/scripts/util/state_machine.lua

local tbl = {}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	assert(arg_1_0, "State without name not allowed.")

	local var_1_0 = tbl[arg_1_0]

	if var_1_0 == nil then
		var_1_0 = {
			create = arg_1_0 .. ":new",
			enter = arg_1_0 .. ":on_enter",
			exit = arg_1_0 .. ":on_exit"
		}
		tbl[arg_1_0] = var_1_0
	end

	local var_1_1 = var_1_0[arg_1_1]

	assert(var_1_1)

	return var_1_1
end

StateMachine = class(StateMachine)

local function fn_2(arg_2_0, ...)
	-- function 2
	cprintf("[StateMachine] " .. arg_2_0, ...)
end

StateMachine.init = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	self._parent = arg_3_1
	self._params = arg_3_3
	self._profiling_debugging_enabled = arg_3_4

	self:_change_state(arg_3_2, arg_3_3)
end

StateMachine._change_state = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not self._state then
		if not self._state.on_exit and not self._profiling_debugging_enabled then
			local var_4_0 = fn(self._state.NAME, "exit")

			self._state:on_exit()
		elseif not self._state.on_exit then
			self._state:on_exit()
		end
	end

	if not self._profiling_debugging_enabled then
		local var_4_1 = fn(arg_4_1.NAME, "create")

		self._state = arg_4_1:new()
	else
		self._state = arg_4_1:new()
	end

	self._state.parent = self._parent

	if not self._state.on_enter and not self._profiling_debugging_enabled then
		local var_4_2 = fn(self._state.NAME, "enter")

		self._state:on_enter(arg_4_2)
	elseif not self._state.on_enter then
		self._state:on_enter(arg_4_2)
	end
end

StateMachine.state = function (self)
	-- function 5
	return self._state
end

StateMachine.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	local update = self._state:update(arg_6_1, arg_6_2)

	if not update then
		self:_change_state(update, self._params)
	end
end

StateMachine.destroy = function (self, ...)
	-- function 7
	if not self._state and not self._state.on_exit then
		self._state:on_exit(...)
	end
end

StateMachine.on_close = function (self)
	-- function 8
	if not self._state and not self._state.on_close then
		return self._state:on_close()
	end

	return true
end
