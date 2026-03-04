-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_sequence.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSequence = class(BTSequence, BTNode)

function BTSequence.init(arg_1_0, ...)
	BTSequence.super.init(arg_1_0, ...)

	arg_1_0._children = {}
end

BTSequence.name = "BTSequence"

function BTSequence.leave(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_0:set_running_child(arg_2_1, arg_2_2, arg_2_3, nil, "aborted")

	arg_2_2.node_data[arg_2_0._identifier] = nil
end

function BTSequence.run(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_2.node_data[arg_3_0._identifier] or 1
	local var_3_1 = #arg_3_0._children

	for iter_3_0 = var_3_0, var_3_1 do
		local var_3_2 = arg_3_0._children[iter_3_0]

		if not var_3_2:condition(arg_3_2) then
			arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, "failed")

			return "failed"
		end

		arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, var_3_2, "aborted")

		local var_3_3 = var_3_2:run(arg_3_1, arg_3_2, arg_3_3, arg_3_4)

		if var_3_3 == "running" then
			arg_3_2.node_data[arg_3_0._identifier] = iter_3_0

			return var_3_3
		else
			arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, var_3_3)

			if var_3_3 == "failed" then
				return "failed"
			end
		end
	end

	assert(arg_3_0:current_running_child(arg_3_2) == nil)

	return "done"
end

function BTSequence.add_child(arg_4_0, arg_4_1)
	arg_4_0._children[#arg_4_0._children + 1] = arg_4_1
end
