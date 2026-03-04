-- chunkname: @foundation/scripts/managers/event/event_manager.lua

EventManager = class(EventManager)

function EventManager.init(arg_1_0, arg_1_1)
	arg_1_0._events = {}
	arg_1_0._referenced_events = {}
	arg_1_0._passthrough = arg_1_1
end

function EventManager.register(arg_2_0, arg_2_1, ...)
	for iter_2_0 = 1, select("#", ...), 2 do
		local var_2_0 = select(iter_2_0, ...)
		local var_2_1 = select(iter_2_0 + 1, ...)

		fassert(type(arg_2_1) == "table" and type(arg_2_1[var_2_1]) == "function", "No function found with name %q on supplied object", var_2_1)

		arg_2_0._events[var_2_0] = arg_2_0._events[var_2_0] or setmetatable({}, {
			__mode = "v"
		})
		arg_2_0._events[var_2_0][arg_2_1] = var_2_1
	end
end

function EventManager.unregister(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0._events[arg_3_1]

	if var_3_0 then
		var_3_0[arg_3_2] = nil

		if table.is_empty(var_3_0) then
			arg_3_0._events[arg_3_1] = nil
		end
	end
end

function EventManager.trigger(arg_4_0, arg_4_1, ...)
	if arg_4_0._events[arg_4_1] then
		for iter_4_0, iter_4_1 in pairs(arg_4_0._events[arg_4_1]) do
			iter_4_0[iter_4_1](iter_4_0, ...)
		end
	end

	if arg_4_0._passthrough then
		arg_4_0._passthrough:trigger(arg_4_1, ...)
	end
end

function EventManager.register_referenced(arg_5_0, arg_5_1, arg_5_2, ...)
	local var_5_0 = arg_5_0._referenced_events
	local var_5_1 = var_5_0[arg_5_1] or {}

	var_5_0[arg_5_1] = var_5_1

	for iter_5_0 = 1, select("#", ...), 2 do
		local var_5_2 = select(iter_5_0, ...)
		local var_5_3 = select(iter_5_0 + 1, ...)

		var_5_1[var_5_2] = var_5_1[var_5_2] or setmetatable({}, {
			__mode = "v"
		})
		var_5_1[var_5_2][arg_5_2] = var_5_3
	end
end

function EventManager.unregister_referenced(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0._referenced_events[arg_6_2]

	if not var_6_0 then
		return
	end

	local var_6_1 = var_6_0[arg_6_1]

	if not var_6_1 then
		return
	end

	var_6_1[arg_6_3] = nil

	if table.is_empty(var_6_1) then
		var_6_0[arg_6_1] = nil
	end

	if table.is_empty(var_6_0) then
		arg_6_0._referenced_events[arg_6_2] = nil
	end
end

function EventManager.unregister_referenced_all(arg_7_0, arg_7_1)
	arg_7_0._referenced_events[arg_7_1] = nil
end

function EventManager.trigger_referenced(arg_8_0, arg_8_1, arg_8_2, ...)
	local var_8_0 = arg_8_0._referenced_events[arg_8_1]
	local var_8_1 = var_8_0 and var_8_0[arg_8_2]

	if var_8_1 then
		for iter_8_0, iter_8_1 in pairs(var_8_1) do
			iter_8_0[iter_8_1](iter_8_0, arg_8_1, ...)
		end
	end

	if arg_8_0._passthrough then
		arg_8_0._passthrough:trigger_referenced(arg_8_1, arg_8_2, ...)
	end
end
