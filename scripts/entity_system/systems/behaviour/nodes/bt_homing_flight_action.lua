-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_homing_flight_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTHomingFlightAction = class(BTHomingFlightAction, BTNode)

BTHomingFlightAction.init = function (arg_1_0, ...)
	-- function 1
	BTHomingFlightAction.super.init(arg_1_0, ...)
end

BTHomingFlightAction.name = "BTHomingFlightAction"

BTHomingFlightAction.enter = function (self)
	-- function 2
	self._ai_bot_group_system = Managers.state.entity:system("ai_bot_group_system")
end

BTHomingFlightAction.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local homing_target_unit = arg_3_2.homing_target_unit

	if not homing_target_unit then
		self._ai_bot_group_system:ranged_attack_ended(arg_3_1, homing_target_unit, "shadow_skull")

		arg_3_2.homing_target_unit = nil
	end
end

BTHomingFlightAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local homing_target_unit = arg_4_2.homing_target_unit
	local target_unit = arg_4_2.target_unit

	if target_unit ~= homing_target_unit then
		local _ai_bot_group_system = self._ai_bot_group_system

		if not homing_target_unit then
			_ai_bot_group_system:ranged_attack_ended(arg_4_1, homing_target_unit, "shadow_skull")
		end

		if not target_unit then
			_ai_bot_group_system:ranged_attack_started(arg_4_1, target_unit, "shadow_skull")
		end

		arg_4_2.homing_target_unit = target_unit
	end

	return "running"
end
