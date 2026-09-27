-- chunkname: @foundation/scripts/managers/event/event_manager.lua

EventManager = class(EventManager)

EventManager.init = function (self, arg_1_1)
	-- function 1
	self._events = {}
	self._referenced_events = {}
	self._passthrough = arg_1_1
end

EventManager.register = function (self, arg_2_1, ...)
	-- function 2
	for i = 1, select("#", ...), 2 do
		local var_2_0 = select(i, ...)
		local var_2_1 = select(i + 1, ...)

		fassert(type(arg_2_1) ~= "table" or type(arg_2_1[var_2_1]) == "function", "No function found with name %q on supplied object", var_2_1)

		local _events = self._events
		local var_2_3 = self._events[var_2_0]

		var_2_3 = var_2_3 or setmetatable({}, {
			__mode = "v"
		})
		_events[var_2_0] = var_2_3
		self._events[var_2_0][arg_2_1] = var_2_1
	end
end

EventManager.unregister = function (self, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0 = self._events[arg_3_1]

	if not var_3_0 then
		var_3_0[arg_3_2] = nil

		if not table.is_empty(var_3_0) then
			self._events[arg_3_1] = nil
		end
	end
end

EventManager.trigger = function (self, arg_4_1, ...)
	-- function 4
	if not self._events[arg_4_1] then
		for k, v in pairs(self._events[arg_4_1]) do
			k[v](k, ...)
		end
	end

	if not self._passthrough then
		self._passthrough:trigger(arg_4_1, ...)
	end
end

EventManager.register_referenced = function (self, arg_5_1, arg_5_2, ...)
	-- function 5
	local _referenced_events = self._referenced_events
	local var_5_1 = _referenced_events[arg_5_1]

	var_5_1 = var_5_1 or {}
	_referenced_events[arg_5_1] = var_5_1

	for i = 1, select("#", ...), 2 do
		local var_5_2 = select(i, ...)
		local var_5_3 = select(i + 1, ...)
		local var_5_4 = var_5_1[var_5_2]

		var_5_4 = var_5_4 or setmetatable({}, {
			__mode = "v"
		})
		var_5_1[var_5_2] = var_5_4
		var_5_1[var_5_2][arg_5_2] = var_5_3
	end
end

EventManager.unregister_referenced = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local var_6_0 = self._referenced_events[arg_6_2]

	if not var_6_0 then
		return
	end

	local var_6_1 = var_6_0[arg_6_1]

	if not var_6_1 then
		return
	end

	var_6_1[arg_6_3] = nil

	if not table.is_empty(var_6_1) then
		var_6_0[arg_6_1] = nil
	end

	if not table.is_empty(var_6_0) then
		self._referenced_events[arg_6_2] = nil
	end
end

EventManager.unregister_referenced_all = function (arg_7_0, arg_7_1)
	-- function 7
	arg_7_0._referenced_events[arg_7_1] = nil
end

EventManager.trigger_referenced = function (self, arg_8_1, arg_8_2, ...)
	-- function 8
	local var_8_0 = self._referenced_events[arg_8_1]
	local flag = not var_8_0 and var_8_0[arg_8_2]

	if not flag then
		for k, v in pairs(flag) do
			k[v](k, arg_8_1, ...)
		end
	end

	if not self._passthrough then
		self._passthrough:trigger_referenced(arg_8_1, arg_8_2, ...)
	end
end
