-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_nil_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTNilAction = class(BTNilAction, BTNode)

BTNilAction.init = function (arg_1_0, ...)
	BTNilAction.super.init(arg_1_0, ...)
end

BTNilAction.name = "BTNilAction"

BTNilAction.enter = function (arg_2_0)
	return
end

BTNilAction.leave = function (arg_3_0)
	return
end

BTNilAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	return "running"
end
