-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_selector.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSelector = class(BTSelector, BTNode)

function BTSelector.init(arg_1_0, ...)
	BTSelector.super.init(arg_1_0, ...)

	arg_1_0._children = {}
end

BTSelector.name = "BTSelector"

function BTSelector.leave(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_0:set_running_child(arg_2_1, arg_2_2, arg_2_3, nil, arg_2_4)
end

function BTSelector.run(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0:current_running_child(arg_3_2)

	for iter_3_0, iter_3_1 in ipairs(arg_3_0._children) do
		if iter_3_1:condition(arg_3_2) then
			arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, iter_3_1, "aborted")

			local var_3_1, var_3_2 = iter_3_1:run(arg_3_1, arg_3_2, arg_3_3, arg_3_4)

			if var_3_1 ~= "running" then
				arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, var_3_1)
			end

			if var_3_1 ~= "failed" then
				return var_3_1, var_3_2
			end
		elseif iter_3_1 == var_3_0 then
			arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, "failed")
		end
	end

	if script_data.debug_behaviour_trees and script_data.debug_unit == arg_3_1 then
		print("BTSelector fail: ", arg_3_0:id())
	end

	fassert(arg_3_0:current_running_child(arg_3_2) == nil)

	return "failed"
end

function BTSelector.add_child(arg_4_0, arg_4_1)
	arg_4_0._children[#arg_4_0._children + 1] = arg_4_1
end
