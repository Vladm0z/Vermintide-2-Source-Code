-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_globadier_suicide_stagger_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTGlobadierSuicideStaggerAction = class(BTGlobadierSuicideStaggerAction, BTNode)
BTGlobadierSuicideStaggerAction.name = "BTGlobadierSuicideStaggerAction"

function BTGlobadierSuicideStaggerAction.init(arg_1_0, ...)
	BTGlobadierSuicideStaggerAction.super.init(arg_1_0, ...)
end

function BTGlobadierSuicideStaggerAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = "kinetic"
	local var_2_1 = Vector3(0, 0, -1)

	AiUtils.kill_unit(arg_2_1, nil, nil, var_2_0, var_2_1)
end

function BTGlobadierSuicideStaggerAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

function BTGlobadierSuicideStaggerAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	return "done"
end
