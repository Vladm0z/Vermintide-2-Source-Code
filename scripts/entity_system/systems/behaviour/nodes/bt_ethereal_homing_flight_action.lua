-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_ethereal_homing_flight_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTEtherealHomingFlightAction = class(BTEtherealHomingFlightAction, BTNode)

BTEtherealHomingFlightAction.init = function (arg_1_0, ...)
	BTEtherealHomingFlightAction.super.init(arg_1_0, ...)
end

BTEtherealHomingFlightAction.name = "BTEtherealHomingFlightAction"

BTEtherealHomingFlightAction.enter = function (arg_2_0)
	arg_2_0._ai_bot_group_system = Managers.state.entity:system("ai_bot_group_system")
end

BTEtherealHomingFlightAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_2.homing_target_unit

	if var_3_0 then
		arg_3_0._ai_bot_group_system:ranged_attack_ended(arg_3_1, var_3_0, "shadow_skull")

		arg_3_2.homing_target_unit = nil
	end
end

BTEtherealHomingFlightAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if not arg_4_2.bot_target_delay then
		arg_4_2.bot_target_delay = arg_4_3 + 6
	elseif arg_4_3 > arg_4_2.bot_target_delay and not arg_4_2.is_target then
		arg_4_2.is_target = true
	end

	local var_4_0 = arg_4_2.homing_target_unit
	local var_4_1 = arg_4_2.target_unit

	if var_4_1 ~= var_4_0 then
		local var_4_2 = arg_4_0._ai_bot_group_system

		if var_4_0 then
			var_4_2:ranged_attack_ended(arg_4_1, var_4_0, "shadow_skull")
		end

		if var_4_1 and arg_4_2.is_target then
			var_4_2:ranged_attack_started(arg_4_1, var_4_1, "shadow_skull")

			arg_4_2.homing_target_unit = var_4_1
		end
	end

	return "running"
end
