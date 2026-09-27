-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_ethereal_homing_flight_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTEtherealHomingFlightAction = class(BTEtherealHomingFlightAction, BTNode)

BTEtherealHomingFlightAction.init = function (arg_1_0, ...)
	-- function 1
	BTEtherealHomingFlightAction.super.init(arg_1_0, ...)
end

BTEtherealHomingFlightAction.name = "BTEtherealHomingFlightAction"

BTEtherealHomingFlightAction.enter = function (self)
	-- function 2
	self._ai_bot_group_system = Managers.state.entity:system("ai_bot_group_system")
end

BTEtherealHomingFlightAction.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local homing_target_unit = arg_3_2.homing_target_unit

	if not homing_target_unit then
		self._ai_bot_group_system:ranged_attack_ended(arg_3_1, homing_target_unit, "shadow_skull")

		arg_3_2.homing_target_unit = nil
	end
end

BTEtherealHomingFlightAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if not arg_4_2.bot_target_delay then
		arg_4_2.bot_target_delay = arg_4_3 + 6
	elseif not (not (arg_4_3 > arg_4_2.bot_target_delay) or arg_4_2.is_target) then
		arg_4_2.is_target = true
	end

	local homing_target_unit = arg_4_2.homing_target_unit
	local target_unit = arg_4_2.target_unit

	if target_unit ~= homing_target_unit then
		local _ai_bot_group_system = self._ai_bot_group_system

		if not homing_target_unit then
			_ai_bot_group_system:ranged_attack_ended(arg_4_1, homing_target_unit, "shadow_skull")
		end

		if not target_unit and not arg_4_2.is_target then
			_ai_bot_group_system:ranged_attack_started(arg_4_1, target_unit, "shadow_skull")

			arg_4_2.homing_target_unit = target_unit
		end
	end

	return "running"
end
