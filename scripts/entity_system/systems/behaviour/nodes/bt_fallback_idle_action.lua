-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_fallback_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTFallbackIdleAction = class(BTFallbackIdleAction, BTNode)

function BTFallbackIdleAction.init(arg_1_0, ...)
	BTFallbackIdleAction.super.init(arg_1_0, ...)
end

BTFallbackIdleAction.name = "BTFallbackIdleAction"

function BTFallbackIdleAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.spawn_to_running = nil

	local var_2_1 = "idle"

	if var_2_0 and var_2_0.idle_animation then
		var_2_1 = var_2_0.idle_animation
	elseif var_2_0 and var_2_0.combat_animations then
		local var_2_2 = var_2_0.combat_animations
		local var_2_3 = var_2_0.anim_cycle_index % #var_2_2 + 1

		var_2_1 = var_2_2[var_2_3]
		var_2_0.anim_cycle_index = var_2_3
	end

	if arg_2_2.move_state ~= "idle" or var_2_0 and var_2_0.force_idle_animation then
		Managers.state.network:anim_event(arg_2_1, var_2_1)

		arg_2_2.move_state = "idle"
	end
end

function BTFallbackIdleAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	return
end

local var_0_0 = Unit.alive

function BTFallbackIdleAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.target_unit

	if var_0_0(var_4_0) then
		local var_4_1 = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, var_4_0)

		arg_4_2.locomotion_extension:set_wanted_rotation(var_4_1)
	elseif arg_4_2.fallback_rotation then
		arg_4_2.locomotion_extension:set_wanted_rotation(arg_4_2.fallback_rotation:unbox())
	end

	return "running"
end
