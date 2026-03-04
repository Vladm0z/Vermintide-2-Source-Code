-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_target_rage_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTargetRageAction = class(BTTargetRageAction, BTNode)

function BTTargetRageAction.init(arg_1_0, ...)
	BTTargetRageAction.super.init(arg_1_0, ...)
end

local var_0_0 = POSITION_LOOKUP

local function var_0_1(arg_2_0, arg_2_1, arg_2_2)
	if script_data.debug_ai_movement then
		Debug.world_sticky_text(var_0_0[arg_2_0] + Vector3.up(), arg_2_1, arg_2_2)
	end
end

BTTargetRageAction.name = "BTTargetRageAction"

function BTTargetRageAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0
	arg_3_2.active_node = arg_3_0

	local var_3_1

	if var_3_0.close_anims_name and arg_3_2.target_dist < var_3_0.close_anims_dist then
		arg_3_2.anim_locked = arg_3_3 + var_3_0.close_rage_time
		var_3_1 = var_3_0.close_anims_name
	else
		arg_3_2.anim_locked = arg_3_3 + var_3_0.rage_time
		var_3_1 = var_3_0.start_anims_name
	end

	local var_3_2 = var_0_0[arg_3_2.target_unit]
	local var_3_3 = var_3_0.rage_anim or AiAnimUtils.get_start_move_animation(arg_3_1, var_3_2, var_3_1)

	if var_3_3 == nil then
		arg_3_2.anim_locked = 0

		return
	end

	local var_3_4 = false

	if var_3_1 then
		var_3_4 = var_3_3 ~= var_3_1.fwd
		arg_3_2.attack_anim_driven = var_3_4
	end

	local var_3_5 = arg_3_2.locomotion_extension

	var_3_5:use_lerp_rotation(not var_3_4)

	if var_3_0.rotation_speed then
		var_3_5:set_rotation_speed(var_3_0.rotation_speed)
	end

	LocomotionUtils.set_animation_driven_movement(arg_3_1, var_3_4, false, false)

	if var_3_4 then
		arg_3_2.move_animation_name = var_3_3
	elseif var_3_0.change_target_fwd_close_anims and arg_3_2.target_dist < var_3_0.change_target_fwd_close_dist then
		var_3_3 = AiAnimUtils.cycle_anims(arg_3_2, var_3_0.change_target_fwd_close_anims, "cycle_rage_anim_index")
	end

	arg_3_2.navigation_extension:stop()

	arg_3_2.move_state = "attacking"

	Managers.state.network:anim_event(arg_3_1, var_3_3)

	if arg_3_2.target_dist > 7 then
		arg_3_2.chasing_timer = 25
	end
end

function BTTargetRageAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.action = nil
	arg_4_2.active_node = nil
	arg_4_2.anim_cb_move = nil
	arg_4_2.anim_locked = nil
	arg_4_2.target_changed = nil
	arg_4_2.move_animation_name = nil

	if not arg_4_5 then
		arg_4_2.locomotion_extension:use_lerp_rotation(true)
		arg_4_2.locomotion_extension:set_rotation_speed(nil)
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)
	end
end

function BTTargetRageAction.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_3 < arg_5_2.anim_locked then
		if arg_5_2.attack_anim_driven then
			if arg_5_2.anim_cb_rotation_start then
				local var_5_0 = var_0_0[arg_5_2.target_unit]
				local var_5_1 = AiAnimUtils.get_animation_rotation_scale(arg_5_1, var_5_0, arg_5_2.move_animation_name, arg_5_2.action.start_anims_data)

				LocomotionUtils.set_animation_rotation_scale(arg_5_1, var_5_1)

				arg_5_2.anim_cb_rotation_start = nil
			end
		else
			local var_5_2 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.target_unit)

			arg_5_2.locomotion_extension:set_wanted_rotation(var_5_2)
		end

		return "running"
	end

	return "done"
end

function BTTargetRageAction.anim_cb_move(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_2.move_state = "moving"
end
