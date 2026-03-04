-- chunkname: @scripts/managers/backend/data_server_queue.lua

BEQueueItem = class(BEQueueItem)

BEQueueItem.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, ...)
	fassert(arg_1_1 and arg_1_1 == "DataServerQueue", "Only poll BEQueueItem from DataServerQueue")

	arg_1_0._queue_id = arg_1_2
	arg_1_0._script_name = arg_1_3
	arg_1_0._data = {
		...
	}
end

BEQueueItem.disable_registered_commands = function (arg_2_0)
	arg_2_0._disable_registered_commands = true
end

BEQueueItem.submit_request = function (arg_3_0, arg_3_1)
	fassert(arg_3_1 and arg_3_1 == "DataServerQueue", "Only poll BEQueueItem from DataServerQueue")
	BackendSession.item_server_script(arg_3_0._script_name, "queue_id", arg_3_0._queue_id, unpack(arg_3_0._data))
end

BEQueueItem.poll_backend = function (arg_4_0, arg_4_1)
	fassert(arg_4_1 and arg_4_1 == "DataServerQueue", "Only poll BEQueueItem from DataServerQueue")

	local var_4_0, var_4_1, var_4_2 = BackendSession.poll_item_server()

	if var_4_0 then
		if var_4_2 or var_4_1.queue_id ~= arg_4_0._queue_id then
			local var_4_3 = ((((("Backend data server error" .. "\n script: " .. arg_4_0._script_name) .. "\n error_message.details : " .. tostring(var_4_2.details)) .. "\n error_message.reason : " .. tostring(var_4_2.reason)) .. "\n queue_id: " .. tostring(arg_4_0._queue_id) .. " (expected)") .. "\n queue_id: " .. tostring(var_4_1.queue_id) .. " (actual)") .. "\n parameters:"
			local var_4_4 = #arg_4_0._data

			if var_4_4 > 0 then
				for iter_4_0 = 1, 2, var_4_4 do
					local var_4_5 = arg_4_0._data[iter_4_0]
					local var_4_6 = arg_4_0._data[iter_4_0 + 1]

					var_4_3 = var_4_3 .. "\n  " .. tostring(var_4_5) .. ": " .. tostring(var_4_6)
				end
			end

			Crashify.print_exception("DataServerQueue", var_4_3)
		end

		arg_4_0._is_done = true
		arg_4_0._items = var_4_0
		arg_4_0._parameters = var_4_1
		arg_4_0._error_message = var_4_2

		for iter_4_1, iter_4_2 in pairs(var_4_0) do
			ItemHelper.mark_backend_id_as_new(iter_4_1)
		end

		Managers.backend:get_interface("items"):__dirtify()
	end
end

BEQueueItem.items = function (arg_5_0)
	fassert(arg_5_0._is_done, "Request hasn't completed yet")

	return arg_5_0._items
end

BEQueueItem.parameters = function (arg_6_0)
	fassert(arg_6_0._is_done, "Request hasn't completed yet")

	return arg_6_0._parameters
end

BEQueueItem.error_message = function (arg_7_0)
	fassert(arg_7_0._is_done, "Request hasn't completed yet")

	return arg_7_0._error_message
end

BEQueueItem.use_registered_commands = function (arg_8_0)
	return not arg_8_0._disable_registered_commands
end

BEQueueItem.is_done = function (arg_9_0)
	return arg_9_0._is_done
end

BECommands = class(BECommands)

BECommands.init = function (arg_10_0)
	arg_10_0._executors = {}

	arg_10_0:register_executor("command_group", callback(arg_10_0, "_command_group_executor"))
end

BECommands.register_executor = function (arg_11_0, arg_11_1, arg_11_2)
	arg_11_0._executors[arg_11_1] = arg_11_2
end

BECommands.unregister_executor = function (arg_12_0, arg_12_1)
	arg_12_0._executors[arg_12_1] = nil
end

BECommands.execute = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1:parameters()

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		if iter_13_0 ~= "queue_id" then
			local var_13_1 = cjson.decode(iter_13_1)

			arg_13_0:_execute(iter_13_0, var_13_1)
		end
	end
end

BECommands._execute = function (arg_14_0, arg_14_1, arg_14_2)
	arg_14_0._executors[arg_14_1](arg_14_2)
end

BECommands._command_group_executor = function (arg_15_0, arg_15_1)
	for iter_15_0, iter_15_1 in pairs(arg_15_1) do
		arg_15_0:_execute(iter_15_0, iter_15_1)
	end
end

DataServerQueue = class(DataServerQueue)

DataServerQueue.init = function (arg_16_0)
	arg_16_0._queue_id = 0
	arg_16_0._queue = {}
	arg_16_0._error_items = {}
	arg_16_0._command_executors = BECommands:new()
end

DataServerQueue._next_queue_id = function (arg_17_0)
	arg_17_0._queue_id = arg_17_0._queue_id + 1

	return tostring(arg_17_0._queue_id)
end

DataServerQueue.add_item = function (arg_18_0, arg_18_1, ...)
	local var_18_0 = arg_18_0:_next_queue_id()
	local var_18_1 = BEQueueItem:new("DataServerQueue", var_18_0, arg_18_1, ...)

	if #arg_18_0._queue == 0 then
		var_18_1:submit_request("DataServerQueue")
	end

	table.insert(arg_18_0._queue, var_18_1)

	return var_18_1
end

DataServerQueue.register_executor = function (arg_19_0, arg_19_1, arg_19_2)
	arg_19_0._command_executors:register_executor(arg_19_1, arg_19_2)
end

DataServerQueue.unregister_executor = function (arg_20_0, arg_20_1)
	arg_20_0._command_executors:unregister_executor(arg_20_1)
end

DataServerQueue.clear = function (arg_21_0)
	arg_21_0._queue = {}
end

DataServerQueue.update = function (arg_22_0)
	local var_22_0 = arg_22_0._queue[1]

	if var_22_0 then
		var_22_0:poll_backend("DataServerQueue")

		if var_22_0:is_done() then
			if var_22_0:error_message() then
				table.insert(arg_22_0._error_items, var_22_0)
			elseif var_22_0:use_registered_commands() then
				arg_22_0._command_executors:execute(var_22_0)
			end

			table.remove(arg_22_0._queue, 1)

			local var_22_1 = arg_22_0._queue[1]

			if var_22_1 then
				var_22_1:submit_request("DataServerQueue")
			end
		end
	end
end

DataServerQueue.check_for_errors = function (arg_23_0)
	if #arg_23_0._error_items > 0 then
		local var_23_0 = table.remove(arg_23_0._error_items, 1):error_message()

		return {
			reason = "data_server_error",
			details = var_23_0.details
		}
	end
end

DataServerQueue.num_current_requests = function (arg_24_0)
	return #arg_24_0._queue
end
