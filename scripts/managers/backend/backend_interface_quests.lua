-- chunkname: @scripts/managers/backend/backend_interface_quests.lua

require("scripts/managers/backend/data_server_queue")

local function var_0_0(...)
	print("[BackendInterfaceQuests]", ...)
end

BackendInterfaceQuests = class(BackendInterfaceQuests)

function BackendInterfaceQuests.init(arg_2_0)
	arg_2_0._tokens = {}
	arg_2_0._initiated = false
	arg_2_0._active_quest = nil
	arg_2_0._available_quests = {}
	arg_2_0._active_contracts = {}
	arg_2_0._available_contracts = {}
	arg_2_0._expire_times = nil
	arg_2_0._reward_queue = {}
end

function BackendInterfaceQuests.setup(arg_3_0, arg_3_1)
	arg_3_0:_register_executors(arg_3_1)

	arg_3_0._queue = arg_3_1

	local var_3_0 = {
		reset_contracts = true,
		reset_quests = true
	}

	arg_3_0._queue:add_item("qnc_get_state_1")
end

function BackendInterfaceQuests.initiated(arg_4_0)
	return arg_4_0._initiated
end

function BackendInterfaceQuests._register_executors(arg_5_0, arg_5_1)
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

function BackendInterfaceQuests._command_quests(arg_6_0, arg_6_1)
	var_0_0("_command_quests")

	arg_6_0._initiated = true
	arg_6_0._quests = arg_6_1
	arg_6_0._quests_dirty = true

	table.clear(arg_6_0._available_quests)

	for iter_6_0, iter_6_1 in pairs(arg_6_1) do
		if iter_6_1.active then
			arg_6_0._active_quest = iter_6_1
		else
			arg_6_0._available_quests[iter_6_0] = iter_6_1
		end
	end
end

function BackendInterfaceQuests._command_contracts(arg_7_0, arg_7_1)
	var_0_0("_command_contracts")

	arg_7_0._contracts = arg_7_1
	arg_7_0._contracts_dirty = true

	table.clear(arg_7_0._active_contracts)
	table.clear(arg_7_0._available_contracts)

	for iter_7_0, iter_7_1 in pairs(arg_7_1) do
		if iter_7_1.active then
			arg_7_0._active_contracts[iter_7_0] = iter_7_1
		else
			arg_7_0._available_contracts[iter_7_0] = iter_7_1
		end

		local var_7_0 = iter_7_1.requirements.difficulty

		iter_7_1.requirements.difficulty = Difficulties[var_7_0]
	end
end

function BackendInterfaceQuests._command_contract_update(arg_8_0, arg_8_1)
	var_0_0("_command_contract_update")

	arg_8_0._contracts_dirty = true

	local var_8_0 = arg_8_1.id
	local var_8_1 = arg_8_0._contracts[var_8_0]
	local var_8_2 = arg_8_1.data

	for iter_8_0, iter_8_1 in pairs(var_8_2) do
		var_8_1[iter_8_0] = iter_8_1

		if iter_8_0 == "active" then
			if iter_8_1 then
				arg_8_0._available_contracts[var_8_0] = nil
				arg_8_0._active_contracts[var_8_0] = var_8_1
			else
				arg_8_0._available_contracts[var_8_0] = var_8_1
				arg_8_0._active_contracts[var_8_0] = nil
			end
		elseif iter_8_0 == "requirements" then
			local var_8_3 = iter_8_1.difficulty

			var_8_1.requirements.difficulty = Difficulties[var_8_3]
		end
	end
end

function BackendInterfaceQuests._command_contract_delete(arg_9_0, arg_9_1)
	var_0_0("_command_contract_delete")

	arg_9_0._contracts_dirty = true

	local var_9_0 = arg_9_1.id

	arg_9_0._contracts[var_9_0] = nil

	local var_9_1 = arg_9_0._active_contracts

	if var_9_1[var_9_0] then
		var_9_1[var_9_0] = nil
	end
end

function BackendInterfaceQuests._command_quest_update(arg_10_0, arg_10_1)
	var_0_0("_command_quest_update")

	arg_10_0._quests_dirty = true

	local var_10_0 = arg_10_1.id
	local var_10_1 = arg_10_0._quests[var_10_0]
	local var_10_2 = arg_10_1.data

	for iter_10_0, iter_10_1 in pairs(var_10_2) do
		var_10_1[iter_10_0] = iter_10_1

		if iter_10_0 == "active" then
			if iter_10_1 then
				arg_10_0._available_quests[var_10_0] = nil
				arg_10_0._active_quest = var_10_1
			else
				arg_10_0._available_quests[var_10_0] = var_10_1
				arg_10_0._active_quest = nil
			end
		end
	end
end

function BackendInterfaceQuests._command_quest_delete(arg_11_0, arg_11_1)
	var_0_0("_command_quest_delete")

	arg_11_0._quests_dirty = true

	local var_11_0 = arg_11_1.id

	arg_11_0._quests[var_11_0] = nil

	local var_11_1 = arg_11_0._active_quest

	if var_11_1 and var_11_1.id == var_11_0 then
		arg_11_0._active_quest = nil
	end
end

function BackendInterfaceQuests._command_rewarded(arg_12_0, arg_12_1)
	var_0_0("_command_rewarded")

	for iter_12_0, iter_12_1 in ipairs(arg_12_1) do
		if iter_12_1.type == "item" then
			({})[1] = iter_12_1.data

			table.insert(arg_12_0._reward_queue, iter_12_1)
		elseif iter_12_1.type == "token" then
			local var_12_0 = {
				type = iter_12_1.token_type,
				amount = iter_12_1.amount
			}

			table.insert(arg_12_0._reward_queue, iter_12_1)
		end
	end
end

function BackendInterfaceQuests._command_expire_times(arg_13_0, arg_13_1)
	var_0_0("_command_expire_times")

	arg_13_0._expire_times_dirty = true
	arg_13_0._expire_times = arg_13_1
end

function BackendInterfaceQuests._command_status(arg_14_0, arg_14_1)
	var_0_0("_command_status", arg_14_1)

	arg_14_0._status_dirty = true
	arg_14_0._status = arg_14_1
end

function BackendInterfaceQuests.are_quests_dirty(arg_15_0)
	local var_15_0 = arg_15_0._quests_dirty

	arg_15_0._quests_dirty = false

	return var_15_0
end

function BackendInterfaceQuests.get_quests(arg_16_0)
	return arg_16_0._quests
end

function BackendInterfaceQuests.get_available_quests(arg_17_0)
	return arg_17_0._available_quests
end

function BackendInterfaceQuests.get_active_quest(arg_18_0)
	return arg_18_0._active_quest
end

function BackendInterfaceQuests.set_active_quest(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0._queue:add_item("qnc_set_quest_active_1", "quest_id", cjson.encode(arg_19_1), "active", cjson.encode(arg_19_2))

	arg_19_0._tokens[#arg_19_0._tokens + 1] = var_19_0
end

function BackendInterfaceQuests.complete_quest(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0._queue:add_item("qnc_turn_in_quest_1", "quest_id", cjson.encode(arg_20_1))

	arg_20_0._tokens[#arg_20_0._tokens + 1] = var_20_0
end

function BackendInterfaceQuests.are_contracts_dirty(arg_21_0)
	local var_21_0 = arg_21_0._contracts_dirty

	arg_21_0._contracts_dirty = false

	return var_21_0
end

function BackendInterfaceQuests.get_contracts(arg_22_0)
	return arg_22_0._contracts
end

function BackendInterfaceQuests.get_available_contracts(arg_23_0)
	return arg_23_0._available_contracts
end

function BackendInterfaceQuests.get_active_contracts(arg_24_0)
	return arg_24_0._active_contracts
end

function BackendInterfaceQuests.set_contract_active(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_0._queue:add_item("qnc_set_contract_active_1", "contract_id", cjson.encode(arg_25_1), "active", cjson.encode(arg_25_2))

	arg_25_0._tokens[#arg_25_0._tokens + 1] = var_25_0
end

function BackendInterfaceQuests.add_contract_progress(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	local var_26_0 = arg_26_0._queue:add_item("qnc_add_contract_progress_1", "contract_id", cjson.encode(arg_26_1), "level", cjson.encode(arg_26_2), "task_amount", cjson.encode(arg_26_3))

	arg_26_0._tokens[#arg_26_0._tokens + 1] = var_26_0
end

function BackendInterfaceQuests.add_all_contract_progress(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0._queue:add_item("qnc_add_all_contract_progress_1", "contract_id", cjson.encode(arg_27_1))

	arg_27_0._tokens[#arg_27_0._tokens + 1] = var_27_0
end

function BackendInterfaceQuests.poll_reward(arg_28_0)
	if not table.is_empty(arg_28_0._reward_queue) then
		return (table.remove(arg_28_0._reward_queue, 1))
	end
end

function BackendInterfaceQuests.complete_contract(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0._queue:add_item("qnc_turn_in_contract_1", "contract_id", cjson.encode(arg_29_1))

	arg_29_0._tokens[#arg_29_0._tokens + 1] = var_29_0
end

function BackendInterfaceQuests.reset_quests_and_contracts(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = cjson.encode({
		reset_quests = arg_30_1,
		reset_contracts = arg_30_2
	})
	local var_30_1 = arg_30_0._queue:add_item("qnc_reset_1", "param_config", var_30_0)

	arg_30_0._tokens[#arg_30_0._tokens + 1] = var_30_1

	local var_30_2 = arg_30_0._queue:add_item("qnc_get_state_1")

	arg_30_0._tokens[#arg_30_0._tokens + 1] = var_30_2
end

local var_0_1 = 0

function BackendInterfaceQuests.reset_quests_and_contracts_with_time_offset(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0 = cjson.encode({
		reset_quests = arg_31_1,
		reset_contracts = arg_31_2
	})
	local var_31_1 = arg_31_0._queue:add_item("qnc_reset_1", "param_config", var_31_0)

	arg_31_0._tokens[#arg_31_0._tokens + 1] = var_31_1

	if arg_31_3 then
		var_0_1 = var_0_1 + arg_31_3
	else
		var_0_1 = 0
	end

	local var_31_2 = os.time() + var_0_1
	local var_31_3 = arg_31_0._queue:add_item("get_quest_state_debug_1", "debug_time", var_31_2)

	arg_31_0._tokens[#arg_31_0._tokens + 1] = var_31_3
end

function BackendInterfaceQuests.query_quests_and_contracts(arg_32_0)
	local var_32_0 = arg_32_0._queue:add_item("qnc_get_state_1")

	arg_32_0._tokens[#arg_32_0._tokens + 1] = var_32_0
end

function BackendInterfaceQuests.query_expire_times(arg_33_0)
	var_0_0("query_expire_times")

	local var_33_0 = arg_33_0._queue:add_item("qnc_get_expire_times_1")

	arg_33_0._tokens[#arg_33_0._tokens + 1] = var_33_0
end

function BackendInterfaceQuests.are_expire_times_dirty(arg_34_0)
	local var_34_0 = arg_34_0._expire_times_dirty

	arg_34_0._expire_times_dirty = false

	return var_34_0
end

function BackendInterfaceQuests.get_expire_times(arg_35_0)
	return arg_35_0._expire_times
end

function BackendInterfaceQuests.are_status_dirty(arg_36_0)
	local var_36_0 = arg_36_0._status_dirty

	arg_36_0._status_dirty = false

	return var_36_0
end

function BackendInterfaceQuests.get_status(arg_37_0)
	return arg_37_0._status
end
