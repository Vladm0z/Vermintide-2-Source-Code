-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_heal_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotHealAction = class(BTBotHealAction, BTNode)

BTBotHealAction.init = function (arg_1_0, ...)
	BTBotHealAction.super.init(arg_1_0, ...)
end

BTBotHealAction.name = "BTBotHealAction"

BTBotHealAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.starting_health_percent = arg_2_2.health_extension:current_health_percent()
	arg_2_2.is_healing_self = true
end

BTBotHealAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.force_use_health_pickup = nil
	arg_3_2.starting_health_percent = nil
	arg_3_2.is_healing_self = false
end

BTBotHealAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_2.force_use_health_pickup and arg_4_2.health_extension:current_health_percent() > arg_4_2.starting_health_percent then
		return "done"
	end

	arg_4_2.input_extension:hold_attack()

	return "running"
end
