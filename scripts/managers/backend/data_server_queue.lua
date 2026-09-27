-- chunkname: @scripts/managers/backend/data_server_queue.lua

BEQueueItem = class(BEQueueItem)

BEQueueItem.init = function (self, arg_1_1, arg_1_2, arg_1_3, ...)
	-- function 1
	fassert(not arg_1_1 and arg_1_1 == "DataServerQueue", "Only poll BEQueueItem from DataServerQueue")

	self._queue_id = arg_1_2
	self._script_name = arg_1_3
	self._data = {
		...
	}
end

BEQueueItem.disable_registered_commands = function (self)
	-- function 2
	self._disable_registered_commands = true
end

BEQueueItem.submit_request = function (self, arg_3_1)
	-- function 3
	fassert(not arg_3_1 and arg_3_1 == "DataServerQueue", "Only poll BEQueueItem from DataServerQueue")
	BackendSession.item_server_script(self._script_name, "queue_id", self._queue_id, unpack(self._data))
end

BEQueueItem.poll_backend = function (self, arg_4_1)
	-- function 4
	fassert(not arg_4_1 and arg_4_1 == "DataServerQueue", "Only poll BEQueueItem from DataServerQueue")

	local poll_item_server, var_4_1, var_4_2 = BackendSession.poll_item_server()

	if not poll_item_server then
		if not (var_4_2 or var_4_1.queue_id == self._queue_id) then
			local str = ((((("Backend data server error" .. "\n script: " .. self._script_name) .. "\n error_message.details : " .. tostring(var_4_2.details)) .. "\n error_message.reason : " .. tostring(var_4_2.reason)) .. "\n queue_id: " .. tostring(self._queue_id) .. " (expected)") .. "\n queue_id: " .. tostring(var_4_1.queue_id) .. " (actual)") .. "\n parameters:"
			local count = #self._data

			if count > 0 then
				for i = 1, 2, count do
					local var_4_5 = self._data[i]
					local var_4_6 = self._data[i + 1]

					str = str .. "\n  " .. tostring(var_4_5) .. ": " .. tostring(var_4_6)
				end
			end

			Crashify.print_exception("DataServerQueue", str)
		end

		self._is_done = true
		self._items = poll_item_server
		self._parameters = var_4_1
		self._error_message = var_4_2

		for k, v in pairs(poll_item_server) do
			ItemHelper.mark_backend_id_as_new(k)
		end

		Managers.backend:get_interface("items"):__dirtify()
	end
end

BEQueueItem.items = function (self)
	-- function 5
	fassert(self._is_done, "Request hasn't completed yet")

	return self._items
end

BEQueueItem.parameters = function (self)
	-- function 6
	fassert(self._is_done, "Request hasn't completed yet")

	return self._parameters
end

BEQueueItem.error_message = function (self)
	-- function 7
	fassert(self._is_done, "Request hasn't completed yet")

	return self._error_message
end

BEQueueItem.use_registered_commands = function (self)
	-- function 8
	return not self._disable_registered_commands
end

BEQueueItem.is_done = function (self)
	-- function 9
	return self._is_done
end

BECommands = class(BECommands)

BECommands.init = function (self)
	-- function 10
	self._executors = {}

	self:register_executor("command_group", callback(self, "_command_group_executor"))
end

BECommands.register_executor = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	arg_11_0._executors[arg_11_1] = arg_11_2
end

BECommands.unregister_executor = function (arg_12_0, arg_12_1)
	-- function 12
	arg_12_0._executors[arg_12_1] = nil
end

BECommands.execute = function (self, arg_13_1)
	-- function 13
	local parameters = arg_13_1:parameters()

	for k, v in pairs(parameters) do
		if k ~= "queue_id" then
			local decode = cjson.decode(v)

			self:_execute(k, decode)
		end
	end
end

BECommands._execute = function (self, arg_14_1, arg_14_2)
	-- function 14
	self._executors[arg_14_1](arg_14_2)
end

BECommands._command_group_executor = function (self, arg_15_1)
	-- function 15
	for k, v in pairs(arg_15_1) do
		self:_execute(k, v)
	end
end

DataServerQueue = class(DataServerQueue)

DataServerQueue.init = function (self)
	-- function 16
	self._queue_id = 0
	self._queue = {}
	self._error_items = {}
	self._command_executors = BECommands:new()
end

DataServerQueue._next_queue_id = function (self)
	-- function 17
	self._queue_id = self._queue_id + 1

	return tostring(self._queue_id)
end

DataServerQueue.add_item = function (self, arg_18_1, ...)
	-- function 18
	local _next_queue_id = self:_next_queue_id()
	local var_18_1 = BEQueueItem:new("DataServerQueue", _next_queue_id, arg_18_1, ...)

	if #self._queue == 0 then
		var_18_1:submit_request("DataServerQueue")
	end

	table.insert(self._queue, var_18_1)

	return var_18_1
end

DataServerQueue.register_executor = function (self, arg_19_1, arg_19_2)
	-- function 19
	self._command_executors:register_executor(arg_19_1, arg_19_2)
end

DataServerQueue.unregister_executor = function (self, arg_20_1)
	-- function 20
	self._command_executors:unregister_executor(arg_20_1)
end

DataServerQueue.clear = function (self)
	-- function 21
	self._queue = {}
end

DataServerQueue.update = function (self)
	-- function 22
	local var_22_0 = self._queue[1]

	if not var_22_0 then
		var_22_0:poll_backend("DataServerQueue")

		if not var_22_0:is_done() then
			if not var_22_0:error_message() then
				table.insert(self._error_items, var_22_0)
			elseif not var_22_0:use_registered_commands() then
				self._command_executors:execute(var_22_0)
			end

			table.remove(self._queue, 1)

			local var_22_1 = self._queue[1]

			if not var_22_1 then
				var_22_1:submit_request("DataServerQueue")
			end
		end
	end
end

DataServerQueue.check_for_errors = function (self)
	-- function 23
	if #self._error_items > 0 then
		local error_message = table.remove(self._error_items, 1):error_message()

		return {
			reason = "data_server_error",
			details = error_message.details
		}
	end
end

DataServerQueue.num_current_requests = function (self)
	-- function 24
	return #self._queue
end
