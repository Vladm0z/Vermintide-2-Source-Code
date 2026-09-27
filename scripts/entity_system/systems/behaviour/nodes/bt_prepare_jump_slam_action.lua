-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_prepare_jump_slam_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local POSITION_LOOKUP = POSITION_LOOKUP

BTPrepareJumpSlamAction = class(BTPrepareJumpSlamAction, BTNode)

BTPrepareJumpSlamAction.init = function (arg_1_0, ...)
	-- function 1
	BTPrepareJumpSlamAction.super.init(arg_1_0, ...)
end

BTPrepareJumpSlamAction.name = "BTPrepareJumpSlamAction"

BTPrepareJumpSlamAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.jump_slam_data = {
		state = "start",
		num_jump_tries = 1,
		segment_list = {}
	}
end

BTPrepareJumpSlamAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if arg_3_4 == "aborted" then
		arg_3_2.jump_slam_data = nil
		arg_3_2.anim_cb_attack_jump_start_finished = nil

		arg_3_2.navigation_extension:set_enabled(true)
	end
end

BTPrepareJumpSlamAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local jump_slam_data = arg_4_2.jump_slam_data

	if jump_slam_data.state == "take_off" then
		if not arg_4_2.anim_cb_attack_jump_start_finished then
			arg_4_2.anim_cb_attack_jump_start_finished = nil
			arg_4_2.chasing_timer = 0
			arg_4_2.unreachable_timer = 0

			return "done"
		end
	elseif jump_slam_data.num_jump_tries > 0 then
		local prepare_jump_new, var_4_2 = BTPrepareJumpSlamAction.prepare_jump_new(arg_4_2, arg_4_1, jump_slam_data, arg_4_3)

		if not prepare_jump_new then
			jump_slam_data.initial_velociy_boxed = Vector3Box(var_4_2)

			BTPrepareJumpSlamAction.start_jump_animation(arg_4_2, arg_4_1)

			jump_slam_data.num_jump_tries = 0
			jump_slam_data.state = "take_off"

			return "running"
		end

		jump_slam_data.num_jump_tries = jump_slam_data.num_jump_tries - 1

		if jump_slam_data.num_jump_tries == 0 then
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

BTPrepareJumpSlamAction.start_jump_animation = function (self, arg_5_1)
	-- function 5
	self.move_state = "attacking"

	self.navigation_extension:set_enabled(false)
	self.locomotion_extension:set_wanted_velocity_flat(Vector3.zero())
	Managers.state.network:anim_event(arg_5_1, "attack_jump")
	LocomotionUtils.set_animation_driven_movement(arg_5_1, true, false, false)
end

BTPrepareJumpSlamAction.try_position = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0
	local num = 0

	for i = 1, 4 do
		local num_2 = arg_6_1 - Quaternion.rotate(Quaternion(Vector3.up(), num), arg_6_2)
		local triangle_from_position, var_6_4 = GwNavQueries.triangle_from_position(arg_6_0, num_2, 0.5, 0.5)

		if not triangle_from_position then
			var_6_0 = Vector3(num_2.x, num_2.y, var_6_4)

			break
		end

		num = num + math.pi * 0.5
	end

	return var_6_0
end

BTPrepareJumpSlamAction.prepare_jump_new = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local var_7_0 = POSITION_LOOKUP[arg_7_1]
	local var_7_1
	local var_7_2 = POSITION_LOOKUP[self.target_unit]
	local num = var_7_2 - var_7_0
	local length = Vector3.length(num)
	local normalize = Vector3.normalize(Vector3.flat(num))
	local var_7_6 = var_7_2
	local test_trajectory_new, var_7_8, var_7_9, var_7_10 = BTPrepareJumpSlamAction.test_trajectory_new(self, var_7_0, var_7_2, arg_7_2.segment_list, normalize, true)

	if not test_trajectory_new then
		local look_at_position_flat = LocomotionUtils.look_at_position_flat(arg_7_1, var_7_10)

		arg_7_2.attack_rotation = QuaternionBox(look_at_position_flat)
		arg_7_2.target_pos = Vector3Box(var_7_10)
		arg_7_2.time_of_flight = var_7_9
	end

	return test_trajectory_new, var_7_8
end

BTPrepareJumpSlamAction.test_trajectory_new = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local physics_world = World.physics_world(self.world)
	local num = -self.breed.jump_slam_gravity
	local var_8_2
	local num_2 = math.pi / 4
	local var_8_4 = Vector3(0, 0, 0.05)
	local var_8_5
	local var_8_6
	local var_8_7
	local current_velocity = ScriptUnit.extension(self.target_unit, "locomotion_system"):current_velocity()

	if Vector3.length_squared(current_velocity) < 0.2 then
		arg_8_2 = arg_8_2 - arg_8_4 * 2
	end

	local var_8_9
	local num_3 = 0.6

	if not var_8_2 then
		num_2, var_8_9 = WeaponHelper.angle_to_hit_moving_target(arg_8_1 + var_8_4, arg_8_2 + var_8_4, var_8_2, current_velocity, -num, num_3)
	else
		var_8_2, var_8_9 = WeaponHelper.speed_to_hit_moving_target(arg_8_1 + var_8_4, arg_8_2 + var_8_4, num_2, current_velocity, -num, num_3)
	end

	if not var_8_9 then
		return
	end

	if not script_data.debug_ai_movement then
		QuickDrawerStay:sphere(var_8_9, 0.3, Color(255, 255, 0))
	end

	local triangle_from_position, var_8_12 = GwNavQueries.triangle_from_position(self.nav_world, var_8_9, 0.5, 0.5)

	if not triangle_from_position then
		Vector3.set_z(var_8_9, var_8_12)
	else
		var_8_9 = BTPrepareJumpSlamAction.try_position(self.nav_world, var_8_9, arg_8_4)
	end

	if not var_8_9 then
		return
	end

	if not script_data.debug_ai_movement then
		QuickDrawerStay:sphere(var_8_9, 0.5, Color(128, 255, 255))
	end

	if not num_2 and not var_8_2 then
		var_8_5, var_8_6, var_8_7 = WeaponHelper.test_angled_trajectory(physics_world, arg_8_1 + var_8_4, var_8_9 + var_8_4, num, var_8_2, num_2, arg_8_3)

		if not arg_8_5 then
			if not var_8_5 then
				return
			end

			var_8_5 = WeaponHelper.ray_segmented_test(physics_world, arg_8_3, Vector3(0, 0, 3))

			if not var_8_5 then
				return
			end

			local num_4 = Vector3.cross(Vector3.normalize(arg_8_2 - arg_8_1), Vector3.up()) * 1

			var_8_5 = WeaponHelper.ray_segmented_test(physics_world, arg_8_3, Vector3(0, 0, 1.5) + num_4)

			if not var_8_5 then
				return
			end

			var_8_5 = WeaponHelper.ray_segmented_test(physics_world, arg_8_3, Vector3(0, 0, 1.5) - num_4)

			if not var_8_5 then
				return
			end
		end
	end

	return var_8_5, var_8_6, var_8_7, var_8_9
end
