-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_fallback_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTFallbackIdleAction = class(BTFallbackIdleAction, BTNode)

BTFallbackIdleAction.init = function (arg_1_0, ...)
	-- function 1
	BTFallbackIdleAction.super.init(arg_1_0, ...)
end

BTFallbackIdleAction.name = "BTFallbackIdleAction"

BTFallbackIdleAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.spawn_to_running = nil

	local str = "idle"

	if not action_data and not action_data.idle_animation then
		str = action_data.idle_animation
	elseif not action_data and not action_data.combat_animations then
		local combat_animations = action_data.combat_animations
		local num = action_data.anim_cycle_index % #combat_animations + 1

		str = combat_animations[num]
		action_data.anim_cycle_index = num
	end

	if arg_2_2.move_state ~= "idle" or not action_data or not action_data.force_idle_animation then
		Managers.state.network:anim_event(arg_2_1, str)

		arg_2_2.move_state = "idle"
	end
end

BTFallbackIdleAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	return
end

local alive = Unit.alive

BTFallbackIdleAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local target_unit = arg_4_2.target_unit

	if not alive(target_unit) then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, target_unit)

		arg_4_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
	elseif not arg_4_2.fallback_rotation then
		arg_4_2.locomotion_extension:set_wanted_rotation(arg_4_2.fallback_rotation:unbox())
	end

	return "running"
end
