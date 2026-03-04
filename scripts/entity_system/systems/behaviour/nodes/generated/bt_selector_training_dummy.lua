-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_training_dummy.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = Unit.alive
local var_0_1 = Profiler

local function var_0_2()
	return
end

BTSelector_training_dummy = class(BTSelector_training_dummy, BTNode)
BTSelector_training_dummy.name = "BTSelector_training_dummy"

BTSelector_training_dummy.init = function (arg_2_0, ...)
	BTSelector_training_dummy.super.init(arg_2_0, ...)

	arg_2_0._children = {}
end

BTSelector_training_dummy.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

BTSelector_training_dummy.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = var_0_1.start
	local var_4_1 = var_0_1.stop
	local var_4_2 = arg_4_0:current_running_child(arg_4_2)
	local var_4_3 = arg_4_0._children
	local var_4_4 = var_4_3[1]
	local var_4_5

	if arg_4_2.stagger then
		if arg_4_2.stagger_prohibited then
			arg_4_2.stagger = false
		else
			var_4_5 = true
		end
	end

	if var_4_5 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_4, "aborted")

		local var_4_6, var_4_7 = var_4_4:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_6 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_6)
		end

		if var_4_6 ~= "failed" then
			return var_4_6, var_4_7
		end
	elseif var_4_4 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end

	local var_4_8 = var_4_3[2]

	arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_8, "aborted")

	local var_4_9, var_4_10 = var_4_8:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	if var_4_9 ~= "running" then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_9)
	end

	if var_4_9 ~= "failed" then
		return var_4_9, var_4_10
	end
end

BTSelector_training_dummy.add_child = function (arg_5_0, arg_5_1)
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
