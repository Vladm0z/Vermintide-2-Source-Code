-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_utility_node.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTUtilityNode = class(BTUtilityNode, BTNode)

BTUtilityNode.init = function (arg_1_0, ...)
	BTUtilityNode.super.init(arg_1_0, ...)

	arg_1_0._children = {}
	arg_1_0.fail_cooldown_name = arg_1_0._identifier .. "_fail_cooldown"
end

BTUtilityNode.name = "BTUtilityNode"

BTUtilityNode.ready = function (arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in pairs(arg_2_0._children) do
		arg_2_0._action_list = arg_2_0._action_list or {}
		arg_2_0._action_list[#arg_2_0._action_list + 1] = iter_2_1._tree_node.action_data
	end
end

BTUtilityNode.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	return
end

BTUtilityNode.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.running_attack_action = nil

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, arg_4_4)
end

local function var_0_0(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0[arg_5_2], arg_5_0[arg_5_1] = arg_5_0[arg_5_1], arg_5_0[arg_5_2]
end

local function var_0_1(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = #arg_6_1
	local var_6_1 = 0

	for iter_6_0 = 1, var_6_0 do
		local var_6_2 = arg_6_1[iter_6_0]
		local var_6_3 = var_6_2.name
		local var_6_4 = arg_6_4[var_6_3]
		local var_6_5 = 0

		if var_6_4:condition(arg_6_2) then
			var_6_5 = Utility.get_action_utility(var_6_2, var_6_3, arg_6_2, arg_6_3)
		end

		arg_6_1[iter_6_0].utility_score = var_6_5
		var_6_1 = var_6_1 + var_6_5
	end

	for iter_6_1 = 1, var_6_0 do
		local var_6_6
		local var_6_7 = math.random() * var_6_1

		for iter_6_2 = iter_6_1, var_6_0 do
			local var_6_8 = arg_6_1[iter_6_2].utility_score

			if var_6_7 < var_6_8 then
				var_6_6 = iter_6_2

				break
			end

			var_6_7 = var_6_7 - var_6_8
		end

		if not var_6_6 then
			var_6_0 = iter_6_1 - 1

			return var_6_0
		end

		var_6_1 = var_6_1 - arg_6_1[var_6_6].utility_score

		if var_6_6 ~= iter_6_1 then
			var_0_0(arg_6_1, var_6_6, iter_6_1)
		end
	end

	return var_6_0
end

BTUtilityNode.run = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = arg_7_0._tree_node.action_data
	local var_7_1 = arg_7_2[arg_7_0.fail_cooldown_name]

	if var_7_1 then
		if arg_7_3 < var_7_1 then
			return "failed"
		end

		arg_7_2[arg_7_0.fail_cooldown_name] = nil
	end

	local var_7_2 = arg_7_0:current_running_child(arg_7_2)
	local var_7_3 = "failed"
	local var_7_4

	if var_7_2 and not arg_7_2.evaluate then
		local var_7_5 = var_7_2._identifier
		local var_7_6

		var_7_3, var_7_6 = var_7_2:evaluate(arg_7_1, arg_7_2, arg_7_3, arg_7_4)

		if var_7_3 == "done" then
			arg_7_2.utility_actions[var_7_5].last_done_time = arg_7_3
		end

		if var_7_3 ~= "failed" then
			arg_7_2.evaluate = var_7_6

			return var_7_3
		end
	end

	local var_7_7 = arg_7_0._action_list
	local var_7_8 = var_0_1(arg_7_1, var_7_7, arg_7_2, arg_7_3, arg_7_0._children)

	for iter_7_0 = 1, var_7_8 do
		local var_7_9 = var_7_7[iter_7_0].name
		local var_7_10 = arg_7_0._children[var_7_9]

		if var_7_10 ~= var_7_2 then
			arg_7_0:set_running_child(arg_7_1, arg_7_2, arg_7_3, var_7_10, "aborted")

			var_7_2 = var_7_10
		end

		local var_7_11 = arg_7_2.utility_actions[var_7_9]

		var_7_11.last_time = arg_7_3

		local var_7_12 = var_7_10._identifier
		local var_7_13

		var_7_3, var_7_13 = var_7_10:evaluate(arg_7_1, arg_7_2, arg_7_3, arg_7_4)

		if var_7_3 ~= "running" then
			if var_7_3 == "done" then
				var_7_11.last_done_time = arg_7_3
			end

			arg_7_0:set_running_child(arg_7_1, arg_7_2, arg_7_3, nil, var_7_3)

			var_7_2 = nil
		end

		if var_7_3 ~= "failed" then
			arg_7_2.evaluate = var_7_13

			break
		end
	end

	if var_7_3 == "running" or var_7_3 == "done" then
		return var_7_3
	end

	local var_7_14 = var_7_0 and var_7_0.fail_cooldown_blackboard_identifier
	local var_7_15 = var_7_14 and arg_7_2[var_7_14]

	if var_7_15 == nil then
		var_7_15 = arg_7_3 + (var_7_0 and var_7_0.fail_cooldown or 0.5)
	end

	arg_7_2[arg_7_0.fail_cooldown_name] = var_7_15

	return var_7_3
end

BTUtilityNode.add_child = function (arg_8_0, arg_8_1)
	arg_8_0._children[arg_8_1._identifier] = arg_8_1
end
