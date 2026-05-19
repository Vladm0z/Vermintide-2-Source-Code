-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_node.lua

BTNode = class(BTNode)

require("scripts/entity_system/systems/behaviour/nodes/bt_conditions")
require("scripts/entity_system/systems/behaviour/nodes/bt_leave_hooks")
require("scripts/entity_system/systems/behaviour/nodes/bt_enter_hooks")

local var_0_0 = BTConditions
local var_0_1 = BTEnterHooks
local var_0_2 = BTLeaveHooks

function BTNode.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	arg_1_0._parent = arg_1_2
	arg_1_0._identifier = arg_1_1
	arg_1_0._tree_node = arg_1_6

	local var_1_0 = var_0_0[arg_1_3]

	fassert(var_1_0, "No condition called %q", arg_1_3)

	arg_1_0._condition_name = arg_1_3

	if arg_1_4 then
		local var_1_1 = var_0_1[arg_1_4]

		if var_1_1 then
			arg_1_0.old_enter = arg_1_0.enter

			function arg_1_0.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				var_1_1(arg_2_1, arg_2_2, arg_2_3)
				arg_1_0.old_enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
			end
		else
			error("No behaviour tree enter hook called %q", arg_1_4)
		end
	end

	if arg_1_5 then
		local var_1_2 = var_0_2[arg_1_5]

		if var_1_2 then
			arg_1_0.old_leave = arg_1_0.leave

			function arg_1_0.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				var_1_2(arg_3_1, arg_3_2, arg_3_3)
				arg_1_0.old_leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			end
		else
			ferror("No behaviour tree leave hook called %q", arg_1_5)
		end
	end
end

function BTNode.condition(arg_4_0, arg_4_1)
	return var_0_0[arg_4_0._condition_name](arg_4_1, arg_4_0._tree_node.condition_args, arg_4_0._tree_node.action_data)
end

function BTNode.id(arg_5_0)
	return arg_5_0._identifier
end

function BTNode.evaluate(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if not arg_6_0:condition(arg_6_2) then
		return "failed"
	end

	return arg_6_0:run(arg_6_1, arg_6_2, arg_6_3, arg_6_4)
end

function BTNode.enter(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	return
end

function BTNode.leave(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	return
end

function BTNode.parent(arg_9_0)
	return arg_9_0._parent
end

function BTNode.run(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	error(false, "Implement in inherited class: " .. arg_10_0:name())
end

function BTNode.set_running_child(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	local var_11_0 = arg_11_0._identifier
	local var_11_1 = arg_11_2.running_nodes[var_11_0]

	if var_11_1 == arg_11_4 then
		return
	end

	arg_11_2.running_nodes[var_11_0] = arg_11_4

	if var_11_1 then
		var_11_1:set_running_child(arg_11_1, arg_11_2, arg_11_3, nil, arg_11_5, arg_11_6)
		var_11_1:leave(arg_11_1, arg_11_2, arg_11_3, arg_11_5, arg_11_6)
	elseif arg_11_0._parent ~= nil and arg_11_4 ~= nil then
		arg_11_0._parent:set_running_child(arg_11_1, arg_11_2, arg_11_3, arg_11_0, "aborted", arg_11_6)
	end

	if arg_11_4 then
		arg_11_4:enter(arg_11_1, arg_11_2, arg_11_3)
	end
end

function BTNode.current_running_child(arg_12_0, arg_12_1)
	return arg_12_1.running_nodes[arg_12_0._identifier]
end
