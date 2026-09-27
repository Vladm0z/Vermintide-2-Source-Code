-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_target_rage_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTargetRageAction = class(BTTargetRageAction, BTNode)

BTTargetRageAction.init = function (arg_1_0, ...)
	-- function 1
	BTTargetRageAction.super.init(arg_1_0, ...)
end

local POSITION_LOOKUP = POSITION_LOOKUP

local function fn(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	if not script_data.debug_ai_movement then
		Debug.world_sticky_text(POSITION_LOOKUP[arg_2_0] + Vector3.up(), arg_2_1, arg_2_2)
	end
end

BTTargetRageAction.name = "BTTargetRageAction"

BTTargetRageAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data
	arg_3_2.active_node = self

	local var_3_1
	local close_anims_name = action_data.close_anims_name

	close_anims_name = not close_anims_name and arg_3_2.target_dist < action_data.close_anims_dist

	if not close_anims_name then
		arg_3_2.anim_locked = arg_3_3 + action_data.close_rage_time
		var_3_1 = action_data.close_anims_name
	else
		arg_3_2.anim_locked = arg_3_3 + action_data.rage_time
		var_3_1 = action_data.start_anims_name
	end

	local var_3_3 = POSITION_LOOKUP[arg_3_2.target_unit]
	local rage_anim = action_data.rage_anim

	rage_anim = rage_anim or AiAnimUtils.get_start_move_animation(arg_3_1, var_3_3, var_3_1)

	if rage_anim == nil then
		arg_3_2.anim_locked = 0

		return
	end

	local flag = false

	if not var_3_1 then
		flag = rage_anim ~= var_3_1.fwd
		arg_3_2.attack_anim_driven = flag
	end

	local locomotion_extension = arg_3_2.locomotion_extension

	locomotion_extension:use_lerp_rotation(not flag)

	if not action_data.rotation_speed then
		locomotion_extension:set_rotation_speed(action_data.rotation_speed)
	end

	LocomotionUtils.set_animation_driven_movement(arg_3_1, flag, false, false)

	if not flag then
		arg_3_2.move_animation_name = rage_anim
	elseif not (not action_data.change_target_fwd_close_anims and not (arg_3_2.target_dist < action_data.change_target_fwd_close_dist)) then
		rage_anim = AiAnimUtils.cycle_anims(arg_3_2, action_data.change_target_fwd_close_anims, "cycle_rage_anim_index")
	end

	arg_3_2.navigation_extension:stop()

	arg_3_2.move_state = "attacking"

	Managers.state.network:anim_event(arg_3_1, rage_anim)

	if arg_3_2.target_dist > 7 then
		arg_3_2.chasing_timer = 25
	end
end

BTTargetRageAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
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

BTTargetRageAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if arg_5_3 < arg_5_2.anim_locked then
		if not arg_5_2.attack_anim_driven then
			if not arg_5_2.anim_cb_rotation_start then
				local var_5_0 = POSITION_LOOKUP[arg_5_2.target_unit]
				local get_animation_rotation_scale = AiAnimUtils.get_animation_rotation_scale(arg_5_1, var_5_0, arg_5_2.move_animation_name, arg_5_2.action.start_anims_data)

				LocomotionUtils.set_animation_rotation_scale(arg_5_1, get_animation_rotation_scale)

				arg_5_2.anim_cb_rotation_start = nil
			end
		else
			local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.target_unit)

			arg_5_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
		end

		return "running"
	end

	return "done"
end

BTTargetRageAction.anim_cb_move = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	arg_6_2.move_state = "moving"
end
