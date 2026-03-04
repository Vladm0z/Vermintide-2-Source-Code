-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_prepare_jump_slam_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = POSITION_LOOKUP

BTPrepareJumpSlamAction = class(BTPrepareJumpSlamAction, BTNode)

BTPrepareJumpSlamAction.init = function (arg_1_0, ...)
	BTPrepareJumpSlamAction.super.init(arg_1_0, ...)
end

BTPrepareJumpSlamAction.name = "BTPrepareJumpSlamAction"

BTPrepareJumpSlamAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.jump_slam_data = {
		state = "start",
		num_jump_tries = 1,
		segment_list = {}
	}
end

BTPrepareJumpSlamAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_4 == "aborted" then
		arg_3_2.jump_slam_data = nil
		arg_3_2.anim_cb_attack_jump_start_finished = nil

		arg_3_2.navigation_extension:set_enabled(true)
	end
end

BTPrepareJumpSlamAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.jump_slam_data

	if var_4_0.state == "take_off" then
		if arg_4_2.anim_cb_attack_jump_start_finished then
			arg_4_2.anim_cb_attack_jump_start_finished = nil
			arg_4_2.chasing_timer = 0
			arg_4_2.unreachable_timer = 0

			return "done"
		end
	elseif var_4_0.num_jump_tries > 0 then
		local var_4_1, var_4_2 = BTPrepareJumpSlamAction.prepare_jump_new(arg_4_2, arg_4_1, var_4_0, arg_4_3)

		if var_4_1 then
			var_4_0.initial_velociy_boxed = Vector3Box(var_4_2)

			BTPrepareJumpSlamAction.start_jump_animation(arg_4_2, arg_4_1)

			var_4_0.num_jump_tries = 0
			var_4_0.state = "take_off"

			return "running"
		end

		var_4_0.num_jump_tries = var_4_0.num_jump_tries - 1

		if var_4_0.num_jump_tries == 0 then
			arg_4_2.chasing_timer = 1

			return "failed"
		end
	else
		arg_4_2.jump_slam_data = nil
		arg_4_2.anim_cb_attack_jump_start_finished = nil
		arg_4_2.chasing_timer = 1

		return "failed"
	end

	LocomotionUtils.follow_target_ogre(arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	return "running"
end

BTPrepareJumpSlamAction.start_jump_animation = function (arg_5_0, arg_5_1)
	arg_5_0.move_state = "attacking"

	arg_5_0.navigation_extension:set_enabled(false)
	arg_5_0.locomotion_extension:set_wanted_velocity_flat(Vector3.zero())
	Managers.state.network:anim_event(arg_5_1, "attack_jump")
	LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, false)
end

BTPrepareJumpSlamAction.try_position = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0
	local var_6_1 = 0

	for iter_6_0 = 1, 4 do
		local var_6_2 = arg_6_1 - Quaternion.rotate(Quaternion(Vector3.up(), var_6_1), arg_6_2)
		local var_6_3, var_6_4 = GwNavQueries.triangle_from_position(arg_6_0, var_6_2, 0.5, 0.5)

		if var_6_3 then
			var_6_0 = Vector3(var_6_2.x, var_6_2.y, var_6_4)

			break
		end

		var_6_1 = var_6_1 + math.pi * 0.5
	end

	return var_6_0
end

BTPrepareJumpSlamAction.prepare_jump_new = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = var_0_0[arg_7_1]
	local var_7_1
	local var_7_2 = var_0_0[arg_7_0.target_unit]
	local var_7_3 = var_7_2 - var_7_0
	local var_7_4 = Vector3.length(var_7_3)
	local var_7_5 = Vector3.normalize(Vector3.flat(var_7_3))
	local var_7_6 = var_7_2
	local var_7_7, var_7_8, var_7_9, var_7_10 = BTPrepareJumpSlamAction.test_trajectory_new(arg_7_0, var_7_0, var_7_2, arg_7_2.segment_list, var_7_5, true)

	if var_7_7 then
		local var_7_11 = LocomotionUtils.look_at_position_flat(arg_7_1, var_7_10)

		arg_7_2.attack_rotation = QuaternionBox(var_7_11)
		arg_7_2.target_pos = Vector3Box(var_7_10)
		arg_7_2.time_of_flight = var_7_9
	end

	return var_7_7, var_7_8
end

BTPrepareJumpSlamAction.test_trajectory_new = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = World.physics_world(arg_8_0.world)
	local var_8_1 = -arg_8_0.breed.jump_slam_gravity
	local var_8_2
	local var_8_3 = math.pi / 4
	local var_8_4 = Vector3(0, 0, 0.05)
	local var_8_5
	local var_8_6
	local var_8_7
	local var_8_8 = ScriptUnit.extension(arg_8_0.target_unit, "locomotion_system"):current_velocity()

	if Vector3.length_squared(var_8_8) < 0.2 then
		arg_8_2 = arg_8_2 - arg_8_4 * 2
	end

	local var_8_9
	local var_8_10 = 0.6

	if var_8_2 then
		var_8_3, var_8_9 = WeaponHelper.angle_to_hit_moving_target(arg_8_1 + var_8_4, arg_8_2 + var_8_4, var_8_2, var_8_8, -var_8_1, var_8_10)
	else
		var_8_2, var_8_9 = WeaponHelper.speed_to_hit_moving_target(arg_8_1 + var_8_4, arg_8_2 + var_8_4, var_8_3, var_8_8, -var_8_1, var_8_10)
	end

	if not var_8_9 then
		return
	end

	if script_data.debug_ai_movement then
		QuickDrawerStay:sphere(var_8_9, 0.3, Color(255, 255, 0))
	end

	local var_8_11, var_8_12 = GwNavQueries.triangle_from_position(arg_8_0.nav_world, var_8_9, 0.5, 0.5)

	if var_8_11 then
		Vector3.set_z(var_8_9, var_8_12)
	else
		var_8_9 = BTPrepareJumpSlamAction.try_position(arg_8_0.nav_world, var_8_9, arg_8_4)
	end

	if not var_8_9 then
		return
	end

	if script_data.debug_ai_movement then
		QuickDrawerStay:sphere(var_8_9, 0.5, Color(128, 255, 255))
	end

	if var_8_3 and var_8_2 then
		var_8_5, var_8_6, var_8_7 = WeaponHelper.test_angled_trajectory(var_8_0, arg_8_1 + var_8_4, var_8_9 + var_8_4, var_8_1, var_8_2, var_8_3, arg_8_3)

		if arg_8_5 then
			if not var_8_5 then
				return
			end

			var_8_5 = WeaponHelper.ray_segmented_test(var_8_0, arg_8_3, Vector3(0, 0, 3))

			if not var_8_5 then
				return
			end

			local var_8_13 = Vector3.cross(Vector3.normalize(arg_8_2 - arg_8_1), Vector3.up()) * 1

			var_8_5 = WeaponHelper.ray_segmented_test(var_8_0, arg_8_3, Vector3(0, 0, 1.5) + var_8_13)

			if not var_8_5 then
				return
			end

			var_8_5 = WeaponHelper.ray_segmented_test(var_8_0, arg_8_3, Vector3(0, 0, 1.5) - var_8_13)

			if not var_8_5 then
				return
			end
		end
	end

	return var_8_5, var_8_6, var_8_7, var_8_9
end
