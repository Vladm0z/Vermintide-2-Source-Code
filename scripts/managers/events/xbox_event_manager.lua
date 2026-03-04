-- chunkname: @scripts/managers/events/xbox_event_manager.lua

XboxEventManager = class(XboxEventManager)

local var_0_0 = 2

XboxEventManager.init = function (arg_1_0)
	arg_1_0._events_to_write_queue = {}
	arg_1_0._priority_events_queue = {}
	arg_1_0._immediate_queue = {}
	arg_1_0._timer = var_0_0
end

XboxEventManager.write = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	Application.warning("[XboxEventManager:write] No Stats are implemented yet")

	do return end

	Application.error(string.format("Adding%sEvent: %s", arg_2_5 and " prioritized " or " ", arg_2_1))

	if arg_2_6 then
		arg_2_0._immediate_queue[#arg_2_0._immediate_queue + 1] = {
			event = arg_2_1,
			event_data = arg_2_2,
			debug_string = string.format("Skipping wait time for event: %s", arg_2_1),
			debug_print_func = Application.warning
		}
	elseif arg_2_5 then
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

XboxEventManager.update = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._priority_events_queue[1]

	if not var_3_0 and arg_3_0._timer > 0 then
		arg_3_0:_handle_immediate_event()
	elseif arg_3_0._timer <= 0 then
		if var_3_0 then
			arg_3_0:_handle_priority_event(var_3_0)
		else
			arg_3_0:_handle_event()
		end

		arg_3_0._timer = var_0_0
	end

	arg_3_0._timer = arg_3_0._timer - arg_3_1
end

XboxEventManager._handle_priority_event = function (arg_4_0, arg_4_1)
	Application.error(string.format("Writing Prioritized Event: %s", arg_4_1.event))
	Events.write(arg_4_1.event, arg_4_1.event_data)

	if arg_4_1.debug_string then
		(arg_4_1.debug_print_func or print)(arg_4_1.debug_string)
	end

	table.remove(arg_4_0._priority_events_queue, 1)
end

XboxEventManager._handle_event = function (arg_5_0)
	local var_5_0 = arg_5_0._events_to_write_queue[1]

	if var_5_0 then
		Application.error(string.format("Writing Event: %s", var_5_0.event))
		Events.write(var_5_0.event, var_5_0.event_data)

		if var_5_0.debug_string then
			(var_5_0.debug_print_func or print)(var_5_0.debug_string)
		end

		table.remove(arg_5_0._events_to_write_queue, 1)
	end
end

XboxEventManager._handle_immediate_event = function (arg_6_0)
	local var_6_0 = arg_6_0._immediate_queue[1]

	if var_6_0 then
		Application.error(string.format("Writing Event: %s", var_6_0.event))
		Events.write(var_6_0.event, var_6_0.event_data)

		if var_6_0.debug_string then
			(var_6_0.debug_print_func or print)(var_6_0.debug_string)
		end

		table.remove(arg_6_0._immediate_queue, 1)
	end
end

XboxEventManager.flush = function (arg_7_0)
	Application.warning("[XboxEventManager:flush] No Stats are implemented yet")

	do return end

	for iter_7_0, iter_7_1 in pairs(arg_7_0._priority_events_queue) do
		Application.error(string.format("Writing Event: %s", iter_7_1.event))
		Events.write(iter_7_1.event, iter_7_1.event_data)

		if iter_7_1.debug_string then
			(iter_7_1.debug_print_func or print)(iter_7_1.debug_string)
		end
	end

	for iter_7_2, iter_7_3 in pairs(arg_7_0._events_to_write_queue) do
		Application.error(string.format("Writing Event: %s", iter_7_3.event))
		Events.write(iter_7_3.event, iter_7_3.event_data)

		if iter_7_3.debug_string then
			(iter_7_3.debug_print_func or print)(iter_7_3.debug_string)
		end
	end

	for iter_7_4, iter_7_5 in pairs(arg_7_0._immediate_queue) do
		Application.error(string.format("Writing Event: %s", iter_7_5.event))
		Events.write(iter_7_5.event, iter_7_5.event_data)

		if iter_7_5.debug_string then
			(iter_7_5.debug_print_func or print)(iter_7_5.debug_string)
		end
	end

	table.clear(arg_7_0._events_to_write_queue)
	table.clear(arg_7_0._priority_events_queue)
	table.clear(arg_7_0._immediate_queue)
end

XboxEventManager.destroy = function (arg_8_0)
	return
end
