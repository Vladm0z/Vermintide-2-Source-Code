-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_jump_slam_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = POSITION_LOOKUP

BTJumpSlamAction = class(BTJumpSlamAction, BTNode)

function BTJumpSlamAction.init(arg_1_0, ...)
	BTJumpSlamAction.super.init(arg_1_0, ...)
end

BTJumpSlamAction.name = "BTJumpSlamAction"

function BTJumpSlamAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.jump_slam_data

	var_2_0.anim_jump_rot_var = Unit.animation_find_variable(arg_2_1, "jump_rotation")
	var_2_0.start_jump_time = arg_2_3
	var_2_0.landing_time = arg_2_3 + var_2_0.time_of_flight
	arg_2_2.keep_target = true

	Managers.state.entity:system("animation_system"):start_anim_variable_update_by_time(arg_2_1, var_2_0.anim_jump_rot_var, var_2_0.time_of_flight, 2)
	BTJumpSlamAction.progress_to_in_flight(arg_2_2, arg_2_1, var_2_0.initial_velociy_boxed:unbox())
	Managers.state.conflict:freeze_intensity_decay(15)

	local var_2_1 = arg_2_0._tree_node.action_data
	local var_2_2 = var_2_1.bot_threats

	if var_2_2 then
		local var_2_3 = 1
		local var_2_4 = var_2_2[var_2_3].start_time_before_landing
		local var_2_5 = var_2_0.landing_time

		arg_2_2.create_bot_threat_at_t = math.max(var_2_5 - var_2_4, 0)
		arg_2_2.current_bot_threat_index = var_2_3
		arg_2_2.bot_threats_data = var_2_2
	end

	arg_2_2.action = var_2_1

	local var_2_6 = arg_2_2.target_unit

	AiUtils.add_attack_intensity(var_2_6, var_2_1, arg_2_2)
end

function BTJumpSlamAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	Managers.state.entity:system("animation_system"):set_update_anim_variable_done(arg_3_1)

	arg_3_2.jump_slam_data.updating_jump_rot = false

	arg_3_2.navigation_extension:set_enabled(true)

	if arg_3_2.jump_slam_data.constrained then
		LocomotionUtils.constrain_on_clients(arg_3_1, false)
	end

	if arg_3_4 == "aborted" then
		LocomotionUtils.set_animation_driven_movement(arg_3_1, false, true)

		arg_3_2.keep_target = nil
		arg_3_2.jump_slam_data = nil
	end

	arg_3_2.action = nil
	arg_3_2.create_bot_threat_at_t = nil
	arg_3_2.current_bot_threat_index = nil
	arg_3_2.bot_threats_data = nil
end

function BTJumpSlamAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.jump_slam_data

	if arg_4_2.locomotion_extension:current_velocity().z < 0 and not var_4_0.constrained then
		var_4_0.constrained = true

		local var_4_1 = POSITION_LOOKUP[arg_4_1] + Vector3.up() * 2
		local var_4_2 = var_4_0.target_pos:unbox()

		LocomotionUtils.constrain_on_clients(arg_4_1, true, var_4_2, var_4_1)
	end

	local var_4_3 = arg_4_2.create_bot_threat_at_t

	if var_4_3 and var_4_3 < arg_4_3 then
		local var_4_4 = arg_4_2.action
		local var_4_5 = arg_4_2.bot_threats_data
		local var_4_6 = var_4_0.attack_rotation:unbox()
		local var_4_7 = arg_4_2.current_bot_threat_index
		local var_4_8 = var_4_5[var_4_7]

		arg_4_0:_create_bot_aoe_threat(var_4_0, var_4_6, var_4_4, var_4_8)

		local var_4_9 = var_4_7 + 1
		local var_4_10 = var_4_5[var_4_9]

		if var_4_10 then
			arg_4_2.create_bot_threat_at_t = var_4_0.landing_time - var_4_10.start_time_before_landing
			arg_4_2.current_bot_threat_index = var_4_9
		else
			arg_4_2.create_bot_threat_at_t = nil
			arg_4_2.current_bot_threat_index = nil
		end
	end

	if arg_4_3 + arg_4_4 >= var_4_0.landing_time then
		BTJumpSlamAction.progress_to_landing(arg_4_2, arg_4_1, var_4_0)

		return "done"
	end

	return "running"
end

function BTJumpSlamAction._calculate_sphere_collision(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.radius or arg_5_1.radius
	local var_5_1 = arg_5_2.offset_forward or arg_5_1.forward_offset

	return arg_5_3 + Quaternion.forward(arg_5_4) * var_5_1, var_5_0
end

function BTJumpSlamAction._create_bot_aoe_threat(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_4.duration
	local var_6_1 = arg_6_1.target_pos:unbox()
	local var_6_2, var_6_3 = arg_6_0:_calculate_sphere_collision(arg_6_3, arg_6_4, var_6_1, arg_6_2)

	Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_6_2, "sphere", var_6_3, nil, var_6_0, "Jump Slam")
end

function BTJumpSlamAction.progress_to_landing(arg_7_0, arg_7_1, arg_7_2)
	LocomotionUtils.set_animation_driven_movement(arg_7_1, true, false, false)
	Managers.state.network:anim_event(arg_7_1, "attack_jump_land")

	local var_7_0 = arg_7_0.locomotion_extension

	var_7_0:set_movement_type("snap_to_navmesh")
	var_7_0:set_wanted_velocity(Vector3.zero())
	var_7_0:set_gravity(nil)
end

function BTJumpSlamAction.progress_to_in_flight(arg_8_0, arg_8_1, arg_8_2)
	LocomotionUtils.set_animation_driven_movement(arg_8_1, false, true)

	local var_8_0 = arg_8_0.locomotion_extension

	var_8_0:set_movement_type("script_driven")
	var_8_0:set_gravity(arg_8_0.breed.jump_slam_gravity)
	var_8_0:set_wanted_velocity(arg_8_2)
end
