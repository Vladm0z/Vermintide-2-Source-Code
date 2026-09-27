-- chunkname: @scripts/managers/backend/backend_interface_quests.lua

require("scripts/managers/backend/data_server_queue")

local function fn(...)
	-- function 1
	print("[BackendInterfaceQuests]", ...)
end

BackendInterfaceQuests = class(BackendInterfaceQuests)

BackendInterfaceQuests.init = function (self)
	-- function 2
	self._tokens = {}
	self._initiated = false
	self._active_quest = nil
	self._available_quests = {}
	self._active_contracts = {}
	self._available_contracts = {}
	self._expire_times = nil
	self._reward_queue = {}
end

BackendInterfaceQuests.setup = function (self, arg_3_1)
	-- function 3
	self:_register_executors(arg_3_1)

	self._queue = arg_3_1

	local tbl = {
		reset_contracts = true,
		reset_quests = true
	}

	self._queue:add_item("qnc_get_state_1")
end

BackendInterfaceQuests.initiated = function (self)
	-- function 4
	return self._initiated
end

BackendInterfaceQuests._register_executors = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_1:register_executor("quests", callback(arg_5_0, "_command_quests"))
	arg_5_1:register_executor("contracts", callback(arg_5_0, "_command_contracts"))
	arg_5_1:register_executor("contract_update", callback(arg_5_0, "_command_contract_update"))
	arg_5_1:register_executor("contract_delete", callback(arg_5_0, "_command_contract_delete"))
	arg_5_1:register_executor("quest_update", callback(arg_5_0, "_command_quest_update"))
	arg_5_1:register_executor("quest_delete", callback(arg_5_0, "_command_quest_delete"))
	arg_5_1:register_executor("rewarded", callback(arg_5_0, "_command_rewarded"))
	arg_5_1:register_executor("expire_times", callback(arg_5_0, "_command_expire_times"))
	arg_5_1:register_executor("status", callback(arg_5_0, "_command_status"))
end

BackendInterfaceQuests._command_quests = function (self, arg_6_1)
	-- function 6
	fn("_command_quests")

	self._initiated = true
	self._quests = arg_6_1
	self._quests_dirty = true

	table.clear(self._available_quests)

	for k, v in pairs(arg_6_1) do
		if not v.active then
			self._active_quest = v
		else
			self._available_quests[k] = v
		end
	end
end

BackendInterfaceQuests._command_contracts = function (self, arg_7_1)
	-- function 7
	fn("_command_contracts")

	self._contracts = arg_7_1
	self._contracts_dirty = true

	table.clear(self._active_contracts)
	table.clear(self._available_contracts)

	for k, v in pairs(arg_7_1) do
		if not v.active then
			self._active_contracts[k] = v
		else
			self._available_contracts[k] = v
		end

		local difficulty = v.requirements.difficulty

		v.requirements.difficulty = Difficulties[difficulty]
	end
end

BackendInterfaceQuests._command_contract_update = function (self, arg_8_1)
	-- function 8
	fn("_command_contract_update")

	self._contracts_dirty = true

	local id = arg_8_1.id
	local var_8_1 = self._contracts[id]
	local data = arg_8_1.data

	for k, v in pairs(data) do
		var_8_1[k] = v

		if k == "active" then
			if not v then
				self._available_contracts[id] = nil
				self._active_contracts[id] = var_8_1
			else
				self._available_contracts[id] = var_8_1
				self._active_contracts[id] = nil
			end
		elseif k == "requirements" then
			local difficulty = v.difficulty

			var_8_1.requirements.difficulty = Difficulties[difficulty]
		end
	end
end

BackendInterfaceQuests._command_contract_delete = function (self, arg_9_1)
	-- function 9
	fn("_command_contract_delete")

	self._contracts_dirty = true

	local id = arg_9_1.id

	self._contracts[id] = nil

	local _active_contracts = self._active_contracts

	if not _active_contracts[id] then
		_active_contracts[id] = nil
	end
end

BackendInterfaceQuests._command_quest_update = function (self, arg_10_1)
	-- function 10
	fn("_command_quest_update")

	self._quests_dirty = true

	local id = arg_10_1.id
	local var_10_1 = self._quests[id]
	local data = arg_10_1.data

	for k, v in pairs(data) do
		var_10_1[k] = v

		if k == "active" then
			if not v then
				self._available_quests[id] = nil
				self._active_quest = var_10_1
			else
				self._available_quests[id] = var_10_1
				self._active_quest = nil
			end
		end
	end
end

BackendInterfaceQuests._command_quest_delete = function (self, arg_11_1)
	-- function 11
	fn("_command_quest_delete")

	self._quests_dirty = true

	local id = arg_11_1.id

	self._quests[id] = nil

	local _active_quest = self._active_quest

	if not (not _active_quest and _active_quest.id ~= id) then
		self._active_quest = nil
	end
end

BackendInterfaceQuests._command_rewarded = function (self, arg_12_1)
	-- function 12
	fn("_command_rewarded")

	for i, v in ipairs(arg_12_1) do
		if v.type == "item" then
			({})[1] = v.data

			table.insert(self._reward_queue, v)
		elseif v.type == "token" then
			local tbl = {
				type = v.token_type,
				amount = v.amount
			}

			table.insert(self._reward_queue, v)
		end
	end
end

BackendInterfaceQuests._command_expire_times = function (self, arg_13_1)
	-- function 13
	fn("_command_expire_times")

	self._expire_times_dirty = true
	self._expire_times = arg_13_1
end

BackendInterfaceQuests._command_status = function (self, arg_14_1)
	-- function 14
	fn("_command_status", arg_14_1)

	self._status_dirty = true
	self._status = arg_14_1
end

BackendInterfaceQuests.are_quests_dirty = function (self)
	-- function 15
	local _quests_dirty = self._quests_dirty

	self._quests_dirty = false

	return _quests_dirty
end

BackendInterfaceQuests.get_quests = function (self)
	-- function 16
	return self._quests
end

BackendInterfaceQuests.get_available_quests = function (self)
	-- function 17
	return self._available_quests
end

BackendInterfaceQuests.get_active_quest = function (self)
	-- function 18
	return self._active_quest
end

BackendInterfaceQuests.set_active_quest = function (self, arg_19_1, arg_19_2)
	-- function 19
	local add_item = self._queue:add_item("qnc_set_quest_active_1", "quest_id", cjson.encode(arg_19_1), "active", cjson.encode(arg_19_2))

	self._tokens[#self._tokens + 1] = add_item
end

BackendInterfaceQuests.complete_quest = function (self, arg_20_1)
	-- function 20
	local add_item = self._queue:add_item("qnc_turn_in_quest_1", "quest_id", cjson.encode(arg_20_1))

	self._tokens[#self._tokens + 1] = add_item
end

BackendInterfaceQuests.are_contracts_dirty = function (self)
	-- function 21
	local _contracts_dirty = self._contracts_dirty

	self._contracts_dirty = false

	return _contracts_dirty
end

BackendInterfaceQuests.get_contracts = function (self)
	-- function 22
	return self._contracts
end

BackendInterfaceQuests.get_available_contracts = function (self)
	-- function 23
	return self._available_contracts
end

BackendInterfaceQuests.get_active_contracts = function (self)
	-- function 24
	return self._active_contracts
end

BackendInterfaceQuests.set_contract_active = function (self, arg_25_1, arg_25_2)
	-- function 25
	local add_item = self._queue:add_item("qnc_set_contract_active_1", "contract_id", cjson.encode(arg_25_1), "active", cjson.encode(arg_25_2))

	self._tokens[#self._tokens + 1] = add_item
end

BackendInterfaceQuests.add_contract_progress = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	local add_item = self._queue:add_item("qnc_add_contract_progress_1", "contract_id", cjson.encode(arg_26_1), "level", cjson.encode(arg_26_2), "task_amount", cjson.encode(arg_26_3))

	self._tokens[#self._tokens + 1] = add_item
end

BackendInterfaceQuests.add_all_contract_progress = function (self, arg_27_1)
	-- function 27
	local add_item = self._queue:add_item("qnc_add_all_contract_progress_1", "contract_id", cjson.encode(arg_27_1))

	self._tokens[#self._tokens + 1] = add_item
end

BackendInterfaceQuests.poll_reward = function (self)
	-- function 28
	if not table.is_empty(self._reward_queue) then
		return (table.remove(self._reward_queue, 1))
	end
end

BackendInterfaceQuests.complete_contract = function (self, arg_29_1)
	-- function 29
	local add_item = self._queue:add_item("qnc_turn_in_contract_1", "contract_id", cjson.encode(arg_29_1))

	self._tokens[#self._tokens + 1] = add_item
end

BackendInterfaceQuests.reset_quests_and_contracts = function (self, arg_30_1, arg_30_2)
	-- function 30
	local encode = cjson.encode({
		reset_quests = arg_30_1,
		reset_contracts = arg_30_2
	})
	local add_item = self._queue:add_item("qnc_reset_1", "param_config", encode)

	self._tokens[#self._tokens + 1] = add_item

	local add_item_2 = self._queue:add_item("qnc_get_state_1")

	self._tokens[#self._tokens + 1] = add_item_2
end

local num = 0

BackendInterfaceQuests.reset_quests_and_contracts_with_time_offset = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local encode = cjson.encode({
		reset_quests = arg_31_1,
		reset_contracts = arg_31_2
	})
	local add_item = self._queue:add_item("qnc_reset_1", "param_config", encode)

	self._tokens[#self._tokens + 1] = add_item

	if not arg_31_3 then
		num = num + arg_31_3
	else
		num = 0
	end

	local num_2 = os.time() + num
	local add_item_2 = self._queue:add_item("get_quest_state_debug_1", "debug_time", num_2)

	self._tokens[#self._tokens + 1] = add_item_2
end

BackendInterfaceQuests.query_quests_and_contracts = function (self)
	-- function 32
	local add_item = self._queue:add_item("qnc_get_state_1")

	self._tokens[#self._tokens + 1] = add_item
end

BackendInterfaceQuests.query_expire_times = function (self)
	-- function 33
	fn("query_expire_times")

	local add_item = self._queue:add_item("qnc_get_expire_times_1")

	self._tokens[#self._tokens + 1] = add_item
end

BackendInterfaceQuests.are_expire_times_dirty = function (self)
	-- function 34
	local _expire_times_dirty = self._expire_times_dirty

	self._expire_times_dirty = false

	return _expire_times_dirty
end

BackendInterfaceQuests.get_expire_times = function (self)
	-- function 35
	return self._expire_times
end

BackendInterfaceQuests.are_status_dirty = function (self)
	-- function 36
	local _status_dirty = self._status_dirty

	self._status_dirty = false

	return _status_dirty
end

BackendInterfaceQuests.get_status = function (self)
	-- function 37
	return self._status
end
