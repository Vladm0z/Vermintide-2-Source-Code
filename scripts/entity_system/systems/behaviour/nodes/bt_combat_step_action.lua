-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_combat_step_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCombatStepAction = class(BTCombatStepAction, BTNode)

BTCombatStepAction.init = function (arg_1_0, ...)
	BTCombatStepAction.super.init(arg_1_0, ...)
end

BTCombatStepAction.name = "BTCombatStepAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

BTCombatStepAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_2.action = arg_3_0._tree_node.action_data
	arg_3_2.active_node = BTCombatStepAction
	arg_3_2.start_finished = nil
	arg_3_2.start_started_since = arg_3_3

	local var_3_0 = arg_3_2.navigation_extension
	local var_3_1 = arg_3_2.target_unit
	local var_3_2 = LocomotionUtils.rotation_towards_unit_flat(arg_3_1, var_3_1)
	local var_3_3 = Unit.local_rotation(arg_3_1, 0)
	local var_3_4 = Quaternion.forward(var_3_3)
	local var_3_5 = arg_3_2.action
	local var_3_6 = var_3_5.force_combat_step_animation or arg_3_0:_get_animation(var_3_2, var_3_4)
	local var_3_7 = var_3_5.move_speed

	if var_3_7 then
		var_3_0:set_max_speed(var_3_7)
	end

	local var_3_8 = var_0_0(var_3_6)

	Managers.state.network:anim_event(arg_3_1, var_3_8)

	arg_3_2.move_state = "moving"

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)

	local var_3_9 = arg_3_2.nav_world
	local var_3_10 = LocomotionUtils.ray_can_go_on_mesh(var_3_9, POSITION_LOOKUP[arg_3_1], POSITION_LOOKUP[var_3_1], nil, 1, 1)

	if var_3_6 ~= "combat_step_fwd" and var_3_10 then
		arg_3_2.locomotion_extension:use_lerp_rotation(false)
		LocomotionUtils.set_animation_driven_movement(arg_3_1, true, true, false)

		local var_3_11 = POSITION_LOOKUP[var_3_1]
		local var_3_12 = AiAnimUtils.get_animation_rotation_scale(arg_3_1, var_3_11, var_3_6, var_3_5.start_anims_data)

		LocomotionUtils.set_animation_rotation_scale(arg_3_1, var_3_12)

		arg_3_2.is_not_forward_combat_step = true
	else
		local var_3_13 = arg_3_2.locomotion_extension
		local var_3_14 = LocomotionUtils.rotation_towards_unit_flat(arg_3_1, var_3_1)

		var_3_13:set_wanted_rotation(var_3_14)
	end
end

BTCombatStepAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.start_finished = nil
	arg_4_2.start_started_since = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)

	arg_4_2.active_node = nil

	local var_4_0 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	arg_4_2.navigation_extension:set_max_speed(var_4_0)

	if arg_4_2.is_not_forward_combat_step then
		local var_4_1 = arg_4_2.locomotion_extension

		var_4_1:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)
		LocomotionUtils.set_animation_rotation_scale(arg_4_1, 1)

		arg_4_2.is_not_forward_combat_step = nil

		var_4_1:set_rotation_speed(10)
		var_4_1:set_wanted_rotation(nil)
		var_4_1:set_movement_type("snap_to_navmesh")
	end
end

BTCombatStepAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_2.start_finished or arg_5_3 - arg_5_2.start_started_since > 10 then
		return "done"
	end

	return "running"
end

BTCombatStepAction.anim_cb_combat_step_stop = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.navigation_extension

	if var_6_0:is_following_path() then
		var_6_0:stop()
	end

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_6_1, false)
end

BTCombatStepAction._get_animation = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = Quaternion.right(arg_7_1)
	local var_7_1 = Vector3.dot(var_7_0, arg_7_2)
	local var_7_2 = math.abs(var_7_1)
	local var_7_3 = Quaternion.forward(arg_7_1)
	local var_7_4 = Vector3.dot(var_7_3, arg_7_2)
	local var_7_5 = math.abs(var_7_4)
	local var_7_6

	return var_7_5 < var_7_2 and var_7_1 > 0 and "combat_step_left" or var_7_5 < var_7_2 and "combat_step_right" or var_7_4 >= 0 and "combat_step_fwd" or "combat_step_bwd"
end
