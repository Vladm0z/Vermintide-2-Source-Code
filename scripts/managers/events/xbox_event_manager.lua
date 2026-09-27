-- chunkname: @scripts/managers/events/xbox_event_manager.lua

XboxEventManager = class(XboxEventManager)

local num = 2

XboxEventManager.init = function (self)
	-- function 1
	self._events_to_write_queue = {}
	self._priority_events_queue = {}
	self._immediate_queue = {}
	self._timer = num
end

XboxEventManager.write = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	Application.warning("[XboxEventManager:write] No Stats are implemented yet")

	do return end

	local error = Application.error
	local format = string.format
	local str = "Adding%sEvent: %s"
	local flag

	flag = not arg_2_5 and " prioritized " and " "

	error(format(str, flag, arg_2_1))

	if not arg_2_6 then
		arg_2_0._immediate_queue[#arg_2_0._immediate_queue + 1] = {
			event = arg_2_1,
			event_data = arg_2_2,
			debug_string = string.format("Skipping wait time for event: %s", arg_2_1),
			debug_print_func = Application.warning
		}
	elseif not arg_2_5 then
		arg_2_0._priority_events_queue[#arg_2_0._priority_events_queue + 1] = {
			event = arg_2_1,
			event_data = arg_2_2,
			debug_string = arg_2_3,
			debug_print_func = arg_2_4
		}
	else
		arg_2_0._events_to_write_queue[#arg_2_0._events_to_write_queue + 1] = {
			event = arg_2_1,
			event_data = arg_2_2,
			debug_string = arg_2_3,
			debug_print_func = arg_2_4
		}
	end
end

XboxEventManager.update = function (self, arg_3_1)
	-- function 3
	local var_3_0 = self._priority_events_queue[1]

	if not (var_3_0 or not (self._timer > 0)) then
		self:_handle_immediate_event()
	elseif self._timer <= 0 then
		if not var_3_0 then
			self:_handle_priority_event(var_3_0)
		else
			self:_handle_event()
		end

		self._timer = num
	end

	self._timer = self._timer - arg_3_1
end

XboxEventManager._handle_priority_event = function (self, arg_4_1)
	-- function 4
	Application.error(string.format("Writing Prioritized Event: %s", arg_4_1.event))
	Events.write(arg_4_1.event, arg_4_1.event_data)

	if not arg_4_1.debug_string then
		local debug_print_func = arg_4_1.debug_print_func

		debug_print_func = debug_print_func or print

		debug_print_func(arg_4_1.debug_string)
	end

	table.remove(self._priority_events_queue, 1)
end

XboxEventManager._handle_event = function (self)
	-- function 5
	local var_5_0 = self._events_to_write_queue[1]

	if not var_5_0 then
		Application.error(string.format("Writing Event: %s", var_5_0.event))
		Events.write(var_5_0.event, var_5_0.event_data)

		if not var_5_0.debug_string then
			local debug_print_func = var_5_0.debug_print_func

			debug_print_func = debug_print_func or print

			debug_print_func(var_5_0.debug_string)
		end

		table.remove(self._events_to_write_queue, 1)
	end
end

XboxEventManager._handle_immediate_event = function (self)
	-- function 6
	local var_6_0 = self._immediate_queue[1]

	if not var_6_0 then
		Application.error(string.format("Writing Event: %s", var_6_0.event))
		Events.write(var_6_0.event, var_6_0.event_data)

		if not var_6_0.debug_string then
			local debug_print_func = var_6_0.debug_print_func

			debug_print_func = debug_print_func or print

			debug_print_func(var_6_0.debug_string)
		end

		table.remove(self._immediate_queue, 1)
	end
end

XboxEventManager.flush = function (self)
	-- function 7
	Application.warning("[XboxEventManager:flush] No Stats are implemented yet")

	do return end

	for k, v in pairs(self._priority_events_queue) do
		Application.error(string.format("Writing Event: %s", v.event))
		Events.write(v.event, v.event_data)

		if not v.debug_string then
			local debug_print_func = v.debug_print_func

			debug_print_func = debug_print_func or print

			debug_print_func(v.debug_string)
		end
	end

	for k_2, v_2 in pairs(self._events_to_write_queue) do
		Application.error(string.format("Writing Event: %s", v_2.event))
		Events.write(v_2.event, v_2.event_data)

		if not v_2.debug_string then
			local debug_print_func_2 = v_2.debug_print_func

			debug_print_func_2 = debug_print_func_2 or print

			debug_print_func_2(v_2.debug_string)
		end
	end

	for k_3, v_3 in pairs(self._immediate_queue) do
		Application.error(string.format("Writing Event: %s", v_3.event))
		Events.write(v_3.event, v_3.event_data)

		if not v_3.debug_string then
			local debug_print_func_3 = v_3.debug_print_func

			debug_print_func_3 = debug_print_func_3 or print

			debug_print_func_3(v_3.debug_string)
		end
	end

	table.clear(self._events_to_write_queue)
	table.clear(self._priority_events_queue)
	table.clear(self._immediate_queue)
end

XboxEventManager.destroy = function (arg_8_0)
	-- function 8
	return
end
