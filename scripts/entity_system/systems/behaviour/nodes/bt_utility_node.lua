-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_utility_node.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTUtilityNode = class(BTUtilityNode, BTNode)

BTUtilityNode.init = function (self, ...)
	-- function 1
	BTUtilityNode.super.init(self, ...)

	self._children = {}
	self.fail_cooldown_name = self._identifier .. "_fail_cooldown"
end

BTUtilityNode.name = "BTUtilityNode"

BTUtilityNode.ready = function (self, arg_2_1)
	-- function 2
	for k, v in pairs(self._children) do
		local _action_list = self._action_list

		_action_list = _action_list or {}
		self._action_list = _action_list
		self._action_list[#self._action_list + 1] = v._tree_node.action_data
	end
end

BTUtilityNode.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	return
end

BTUtilityNode.leave = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.running_attack_action = nil

	self:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, arg_4_4)
end

local function fn(self, arg_5_1, arg_5_2)
	-- function 5
	self[arg_5_2], self[arg_5_1] = self[arg_5_1], self[arg_5_2]
end

local function fn_2(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local count = #arg_6_1
	local num = 0

	for i = 1, count do
		local var_6_2 = arg_6_1[i]
		local name = var_6_2.name
		local var_6_4 = arg_6_4[name]
		local num_2 = 0

		if not var_6_4:condition(arg_6_2) then
			num_2 = Utility.get_action_utility(var_6_2, name, arg_6_2, arg_6_3)
		end

		arg_6_1[i].utility_score = num_2
		num = num + num_2
	end

	for j = 1, count do
		local var_6_6
		local num_3 = math.random() * num

		for k = j, count do
			local utility_score = arg_6_1[k].utility_score

			if num_3 < utility_score then
				var_6_6 = k

				break
			end

			num_3 = num_3 - utility_score
		end

		if not var_6_6 then
			count = j - 1

			return count
		end

		num = num - arg_6_1[var_6_6].utility_score

		if var_6_6 ~= j then
			fn(arg_6_1, var_6_6, j)
		end
	end

	return count
end

BTUtilityNode.run = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local action_data = self._tree_node.action_data
	local var_7_1 = arg_7_2[self.fail_cooldown_name]

	if not var_7_1 then
		if arg_7_3 < var_7_1 then
			return "failed"
		end

		arg_7_2[self.fail_cooldown_name] = nil
	end

	local current_running_child = self:current_running_child(arg_7_2)
	local str = "failed"
	local var_7_4

	if not (not current_running_child and arg_7_2.evaluate) then
		local _identifier = current_running_child._identifier
		local var_7_6

		str, var_7_6 = current_running_child:evaluate(arg_7_1, arg_7_2, arg_7_3, arg_7_4)

		if str == "done" then
			arg_7_2.utility_actions[_identifier].last_done_time = arg_7_3
		end

		if str ~= "failed" then
			arg_7_2.evaluate = var_7_6

			return str
		end
	end

	local _action_list = self._action_list
	local var_7_8 = fn_2(arg_7_1, _action_list, arg_7_2, arg_7_3, self._children)

	for i = 1, var_7_8 do
		local name = _action_list[i].name
		local var_7_10 = self._children[name]

		if var_7_10 ~= current_running_child then
			self:set_running_child(arg_7_1, arg_7_2, arg_7_3, var_7_10, "aborted")

			current_running_child = var_7_10
		end

		local var_7_11 = arg_7_2.utility_actions[name]

		var_7_11.last_time = arg_7_3

		local _identifier_2 = var_7_10._identifier
		local var_7_13

		str, var_7_13 = var_7_10:evaluate(arg_7_1, arg_7_2, arg_7_3, arg_7_4)

		if str ~= "running" then
			if str == "done" then
				var_7_11.last_done_time = arg_7_3
			end

			self:set_running_child(arg_7_1, arg_7_2, arg_7_3, nil, str)

			current_running_child = nil
		end

		if str ~= "failed" then
			arg_7_2.evaluate = var_7_13

			break
		end
	end

	if not (str == "running" or str ~= "done") then
		return str
	end

	local flag = not action_data and action_data.fail_cooldown_blackboard_identifier
	local flag_2 = not flag and arg_7_2[flag]

	if flag_2 == nil then
		local fail_cooldown

		if not action_data then
			fail_cooldown = action_data.fail_cooldown

			if not fail_cooldown then
				-- Nothing
			end
		end

		fail_cooldown = 0.5

		::label_7_0::

		flag_2 = arg_7_3 + fail_cooldown
	end

	arg_7_2[self.fail_cooldown_name] = flag_2

	return str
end

BTUtilityNode.add_child = function (arg_8_0, arg_8_1)
	-- function 8
	arg_8_0._children[arg_8_1._identifier] = arg_8_1
end
