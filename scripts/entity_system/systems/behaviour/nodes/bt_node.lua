-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_node.lua

BTNode = class(BTNode)

require("scripts/entity_system/systems/behaviour/nodes/bt_conditions")
require("scripts/entity_system/systems/behaviour/nodes/bt_leave_hooks")
require("scripts/entity_system/systems/behaviour/nodes/bt_enter_hooks")

local BTConditions = BTConditions
local BTEnterHooks = BTEnterHooks
local BTLeaveHooks = BTLeaveHooks

BTNode.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	-- function 1
	self._parent = arg_1_2
	self._identifier = arg_1_1
	self._tree_node = arg_1_6

	local var_1_0 = BTConditions[arg_1_3]

	fassert(var_1_0, "No condition called %q", arg_1_3)

	self._condition_name = arg_1_3

	if not arg_1_4 then
		local var_1_1 = BTEnterHooks[arg_1_4]

		if not var_1_1 then
			self.old_enter = self.enter

			self.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				var_1_1(arg_2_1, arg_2_2, arg_2_3)
				self.old_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
			end
		else
			error("No behaviour tree enter hook called %q", arg_1_4)
		end
	end

	if not arg_1_5 then
		local var_1_2 = BTLeaveHooks[arg_1_5]

		if not var_1_2 then
			self.old_leave = self.leave

			self.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				var_1_2(arg_3_1, arg_3_2, arg_3_3)
				self.old_leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			end
		else
			ferror("No behaviour tree leave hook called %q", arg_1_5)
		end
	end
end

BTNode.condition = function (self, arg_4_1)
	-- function 4
	return BTConditions[self._condition_name](arg_4_1, self._tree_node.condition_args, self._tree_node.action_data)
end

BTNode.id = function (self)
	-- function 5
	return self._identifier
end

BTNode.evaluate = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if not self:condition(arg_6_2) then
		return "failed"
	end

	return self:run(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
end

BTNode.enter = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	return
end

BTNode.leave = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	return
end

BTNode.parent = function (self)
	-- function 9
	return self._parent
end

BTNode.run = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	error(false, "Implement in inherited class: " .. self:name())
end

BTNode.set_running_child = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	-- function 11
	local _identifier = self._identifier
	local var_11_1 = arg_11_2.running_nodes[_identifier]

	if var_11_1 == arg_11_4 then
		return
	end

	arg_11_2.running_nodes[_identifier] = arg_11_4

	if not var_11_1 then
		var_11_1:set_running_child(arg_11_1, arg_11_2, arg_11_3, nil, arg_11_5, arg_11_6)
		var_11_1:leave(arg_11_1, arg_11_2, arg_11_3, arg_11_5, arg_11_6)
	elseif not (self._parent == nil or arg_11_4 == nil) then
		self._parent:set_running_child(arg_11_1, arg_11_2, arg_11_3, self, "aborted", arg_11_6)
	end

	if not arg_11_4 then
		arg_11_4:enter(arg_11_1, arg_11_2, arg_11_3)
	end
end

BTNode.current_running_child = function (self, arg_12_1)
	-- function 12
	return arg_12_1.running_nodes[self._identifier]
end
