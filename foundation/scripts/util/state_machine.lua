-- chunkname: @foundation/scripts/util/state_machine.lua

local profiler_names = {}

local function profiler_scope(state_name, scope_type)
	-- function 1
	assert(state_name, "State without name not allowed.")

	local scope = profiler_names[state_name]

	if scope == nil then
		scope = {
			create = state_name .. ":new",
			enter = state_name .. ":on_enter",
			exit = state_name .. ":on_exit"
		}
		profiler_names[state_name] = scope
	end

	local scope_name = scope[scope_type]

	assert(scope_name)

	return scope_name
end

StateMachine = class(StateMachine)

local function debug_print(format, ...)
	-- function 2
	cprintf("[StateMachine] " .. format, ...)
end

StateMachine.init = function (self, parent, start_state, params, profiling_debugging_enabled)
	-- function 3
	self._parent = parent
	self._params = params
	self._profiling_debugging_enabled = profiling_debugging_enabled

	self:_change_state(start_state, params)
end

StateMachine._change_state = function (self, new_state, params)
	-- function 4
	if self._state then
		if self._state.on_exit and self._profiling_debugging_enabled then
			local scope_name = profiler_scope(self._state.NAME, "exit")

			self._state:on_exit()
		elseif self._state.on_exit then
			self._state:on_exit()
		end
	end

	if self._profiling_debugging_enabled then
		local scope_name = profiler_scope(new_state.NAME, "create")

		self._state = new_state:new()
	else
		self._state = new_state:new()
	end

	self._state.parent = self._parent

	if self._state.on_enter and self._profiling_debugging_enabled then
		local scope_name = profiler_scope(self._state.NAME, "enter")

		self._state:on_enter(params)
	elseif self._state.on_enter then
		self._state:on_enter(params)
	end
end

StateMachine.state = function (self)
	-- function 5
	return self._state
end

StateMachine.update = function (self, dt, t)
	-- function 6
	local new_state = self._state:update(dt, t)

	if new_state then
		self:_change_state(new_state, self._params)
	end
end

StateMachine.destroy = function (self, ...)
	-- function 7
	if self._state and self._state.on_exit then
		self._state:on_exit(...)
	end
end

StateMachine.on_close = function (self)
	-- function 8
	if self._state and self._state.on_close then
		return self._state:on_close()
	end

	return true
end
