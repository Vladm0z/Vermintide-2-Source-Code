-- chunkname: @scripts/entity_system/systems/behaviour/nodes/generated/bt_selector_shadow_skull.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = Unit.alive
local var_0_1 = Profiler

local function var_0_2()
	return
end

BTSelector_shadow_skull = class(BTSelector_shadow_skull, BTNode)
BTSelector_shadow_skull.name = "BTSelector_shadow_skull"

function BTSelector_shadow_skull.init(arg_2_0, ...)
	BTSelector_shadow_skull.super.init(arg_2_0, ...)

	arg_2_0._children = {}
end

function BTSelector_shadow_skull.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_0:set_running_child(arg_3_1, arg_3_2, arg_3_3, nil, arg_3_4)
end

function BTSelector_shadow_skull.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = var_0_1.start
	local var_4_1 = var_0_1.stop
	local var_4_2 = arg_4_0:current_running_child(arg_4_2)
	local var_4_3 = arg_4_0._children[1]

	if var_0_0(arg_4_2.target_unit) then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, var_4_3, "aborted")

		local var_4_4, var_4_5 = var_4_3:run(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

		if var_4_4 ~= "running" then
			arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, var_4_4)
		end

		if var_4_4 ~= "failed" then
			return var_4_4, var_4_5
		end
	elseif var_4_3 == var_4_2 then
		arg_4_0:set_running_child(arg_4_1, arg_4_2, arg_4_3, nil, "failed")
	end
end

function BTSelector_shadow_skull.add_child(arg_5_0, arg_5_1)
	arg_5_0._children[#arg_5_0._children + 1] = arg_5_1
end
