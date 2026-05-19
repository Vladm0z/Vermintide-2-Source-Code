-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_ethereal_skull_take_off_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTEtherealSkullTakeOffAction = class(BTEtherealSkullTakeOffAction, BTNode)

function BTEtherealSkullTakeOffAction.init(arg_1_0, ...)
	BTEtherealSkullTakeOffAction.super.init(arg_1_0, ...)
end

BTEtherealSkullTakeOffAction.name = "BTEtherealSkullTakeOffAction"

function BTEtherealSkullTakeOffAction.enter(arg_2_0)
	arg_2_0._duration = 2
end

function BTEtherealSkullTakeOffAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

function BTEtherealSkullTakeOffAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if not arg_4_2.take_off_duration then
		arg_4_2.take_off_duration = arg_4_3 + 2
	end

	if arg_4_3 < arg_4_2.take_off_duration then
		return "done"
	end

	return "running"
end
