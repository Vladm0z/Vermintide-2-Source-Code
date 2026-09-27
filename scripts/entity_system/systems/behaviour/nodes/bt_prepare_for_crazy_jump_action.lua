-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_prepare_for_crazy_jump_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPrepareForCrazyJumpAction = class(BTPrepareForCrazyJumpAction, BTNode)
BTPrepareForCrazyJumpAction.name = "BTPrepareForCrazyJumpAction"

local POSITION_LOOKUP = POSITION_LOOKUP
local AiUtils = AiUtils
local alive = Unit.alive

BTPrepareForCrazyJumpAction.init = function (arg_1_0, ...)
	-- function 1
	BTPrepareForCrazyJumpAction.super.init(arg_1_0, ...)
end

local function fn(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	if not script_data.debug_ai_movement then
		Debug.world_sticky_text(POSITION_LOOKUP[arg_2_0], arg_2_1, arg_2_2)
	end
end

BTPrepareForCrazyJumpAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	aiprint("ENTER BTPrepareForCrazyJumpAction")

	local action_data = self._tree_node.action_data

	arg_3_2.action = action_data

	LocomotionUtils.set_animation_driven_movement(arg_3_1, false)

	local network = Managers.state.network

	network:anim_event(arg_3_1, "move_fwd")

	arg_3_2.jump_data = {
		crouching = false,
		ready_crouch_time = false,
		segment_list = {}
	}
	arg_3_2.remembered_threat_pos = nil

	local flag = not action_data and action_data.tutorial_message_template

	if not flag then
		local var_3_3 = NetworkLookup.tutorials[flag]
		local var_3_4 = NetworkLookup.tutorials[arg_3_2.breed.name]

		network.network_transmit:send_rpc_all("rpc_tutorial_message", var_3_3, var_3_4)
	end
end

BTPrepareForCrazyJumpAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	aiprint("LEAVE BTPrepareForCrazyJumpAction")

	arg_4_2.jump_data.jump_at_target_outside_mesh = nil

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	arg_4_2.navigation_extension:set_max_speed(get_default_breed_move_speed)

	if arg_4_4 ~= "done" then
		Managers.state.network:anim_event(arg_4_1, "to_upright")

		arg_4_2.jump_data = nil
	end
end

BTPrepareForCrazyJumpAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local extension = ScriptUnit.extension(arg_5_1, "locomotion_system")
	local breed = arg_5_2.breed

	if arg_5_2.target_dist > breed.jump_range then
		return "failed"
	end

	local target_unit = arg_5_2.target_unit

	if not HEALTH_ALIVE[target_unit] then
		return "failed"
	end

	local has_extension = ScriptUnit.has_extension(target_unit, "status_system")

	if not has_extension then
		return "failed"
	end

	if not has_extension:is_pounced_down() then
		return "failed"
	end

	if not arg_5_2.move_closer_to_target then
		LocomotionUtils.follow_target(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		extension:set_wanted_rotation(nil)

		if arg_5_3 > arg_5_2.move_closer_to_target_timer then
			local jump_data = arg_5_2.jump_data
			local ready_to_jump, var_5_6, var_5_7 = BTPrepareForCrazyJumpAction.ready_to_jump(arg_5_1, arg_5_2, jump_data, false)

			if not ready_to_jump then
				BTPrepareForCrazyJumpAction.start_crawling(arg_5_1, arg_5_2, arg_5_3, jump_data)

				arg_5_2.move_closer_to_target = false
			else
				if not (arg_5_2.target_dist < 2) or not GwNavQueries.raycango(arg_5_2.nav_world, POSITION_LOOKUP[arg_5_1], POSITION_LOOKUP[target_unit]) then
					BTPrepareForCrazyJumpAction.start_crawling(arg_5_1, arg_5_2, arg_5_3, jump_data)

					arg_5_2.move_closer_to_target = false
				else
					return "failed"
				end

				arg_5_2.move_closer_to_target_timer = arg_5_3 + 1
			end
		end
	else
		local var_5_8 = POSITION_LOOKUP[target_unit]
		local look_at_position_flat = LocomotionUtils.look_at_position_flat(arg_5_1, var_5_8)

		extension:set_wanted_rotation(look_at_position_flat)

		local jump_data_2 = arg_5_2.jump_data

		if not jump_data_2.crouching then
			LocomotionUtils.follow_target(arg_5_1, arg_5_2, arg_5_3, arg_5_4)

			if not arg_5_2.target_outside_navmesh then
				if not jump_data_2.jump_at_target_outside_mesh then
					Managers.state.network:anim_event(arg_5_1, "idle")
					arg_5_2.navigation_extension:move_to(POSITION_LOOKUP[arg_5_1])

					jump_data_2.jump_at_target_outside_mesh = true
				end
			else
				extension:set_wanted_rotation(nil)
			end

			if arg_5_3 > jump_data_2.ready_crouch_time then
				local ready_to_jump_2, var_5_12, var_5_13 = BTPrepareForCrazyJumpAction.ready_to_jump(arg_5_1, arg_5_2, jump_data_2, true)

				if not ready_to_jump_2 then
					return "done"
				end

				jump_data_2.crouching = false
				arg_5_2.move_closer_to_target = true

				Managers.state.network:anim_event(arg_5_1, "to_upright")
				arg_5_2.navigation_extension:set_max_speed(arg_5_2.breed.run_speed)

				arg_5_2.move_closer_to_target_timer = arg_5_3 + 1
				arg_5_2.remembered_threat_pos = nil
				jump_data_2.ready_crouch_time = nil

				return "running"
			end
		else
			BTPrepareForCrazyJumpAction.start_crawling(arg_5_1, arg_5_2, arg_5_3, jump_data_2)
		end
	end

	return "running"
end

BTPrepareForCrazyJumpAction.start_crawling = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local action = arg_6_1.action

	arg_6_1.navigation_extension:set_max_speed(arg_6_1.breed.walk_speed)
	Managers.state.network:anim_event(arg_6_0, "to_crouch")

	local var_6_1 = action.difficulty_prepare_jump_time[Managers.state.difficulty:get_difficulty_rank()]

	var_6_1 = var_6_1 or action.difficulty_prepare_jump_time[2]
	arg_6_3.crouching = true
	arg_6_3.ready_crouch_time = arg_6_2 + (var_6_1 or 0.5)
end

BTPrepareForCrazyJumpAction.ready_to_jump = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local node = Unit.node(arg_7_1.target_unit, "j_neck")
	local var_7_1 = POSITION_LOOKUP[arg_7_0]
	local num = Unit.world_position(arg_7_1.target_unit, 0) + Vector3(0, 0, 0.2)
	local num_2 = var_7_1 + Vector3.normalize(num - var_7_1) * 0.3
	local distance = Vector3.distance(num_2, num)
	local var_7_5
	local var_7_6
	local var_7_7

	if distance < 2.5 then
		if not LocomotionUtils.target_in_los(arg_7_0, arg_7_1) then
			local jump_speed = arg_7_1.breed.jump_speed

			var_7_6 = BTPrepareForCrazyJumpAction.test_simple_jump(num - num_2, jump_speed)

			if not var_7_6 then
				var_7_5 = true
			end
		end
	else
		local var_7_9 = Vector3(0, 0, 0.05)

		var_7_5, var_7_6, var_7_7 = BTPrepareForCrazyJumpAction.test_trajectory(arg_7_1, num_2 + var_7_9, num + var_7_9, arg_7_2.segment_list, true)
	end

	if not var_7_5 and not arg_7_3 then
		arg_7_2.jump_target_pos = Vector3Box(num)
		arg_7_2.jump_velocity_boxed = Vector3Box(var_7_6)
		arg_7_2.total_distance = distance
		arg_7_2.enemy_spine_node = node
	end

	return var_7_5, var_7_6, var_7_7
end

BTPrepareForCrazyJumpAction.test_trajectory = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	local get_data = World.get_data(self.world, "physics_world")
	local jump_gravity = self.breed.jump_gravity
	local var_8_2
	local jump_speed = self.breed.jump_speed
	local var_8_4 = Vector3(0, 0, 0.05)
	local num = 1
	local unbox = ScriptUnit.extension(self.target_unit, "locomotion_system").velocity_current:unbox()
	local normalize = Vector3.normalize(arg_8_2 - arg_8_1)
	local dot = Vector3.dot(normalize, Vector3(0, 0, 1))
	local var_8_9
	local num_2 = arg_8_1.z - arg_8_2.z

	if not (not (dot < -0.5) or not (num_2 > 2) or not (num_2 < 6)) then
		var_8_9 = true
		jump_speed = 5
	end

	if not var_8_9 then
		var_8_2 = WeaponHelper.angle_to_hit_moving_target(arg_8_1, arg_8_2, jump_speed, unbox, jump_gravity, num, var_8_9)
	else
		var_8_2 = WeaponHelper.angle_to_hit_moving_target(arg_8_1, arg_8_2, jump_speed, unbox, jump_gravity, num)
	end

	if not (var_8_2 or jump_speed) then
		return
	end

	local test_angled_trajectory, var_8_12, var_8_13 = WeaponHelper.test_angled_trajectory(get_data, arg_8_1 + var_8_4, arg_8_2 + var_8_4, -jump_gravity, jump_speed, var_8_2, arg_8_3)

	if not var_8_12 and not jump_speed then
		var_8_12 = Vector3.normalize(var_8_12) * jump_speed
	end

	if not arg_8_4 then
		if not test_angled_trajectory then
			return
		end

		test_angled_trajectory = WeaponHelper.ray_segmented_test(get_data, arg_8_3, Vector3(0, 0, 1.6))

		if not test_angled_trajectory then
			return
		end

		local num_3 = Vector3.cross(Vector3.normalize(arg_8_2 - arg_8_1), Vector3.up()) * 0.4

		test_angled_trajectory = WeaponHelper.ray_segmented_test(get_data, arg_8_3, Vector3(0, 0, 0.7) + num_3)

		if not test_angled_trajectory then
			return
		end

		test_angled_trajectory = WeaponHelper.ray_segmented_test(get_data, arg_8_3, Vector3(0, 0, 0.7) - num_3)

		if not test_angled_trajectory then
			return
		end
	end

	return test_angled_trajectory, var_8_12, var_8_13
end

BTPrepareForCrazyJumpAction.test_simple_jump = function (arg_9_0, arg_9_1)
	-- function 9
	local wanted_projectile_angle = WeaponHelper:wanted_projectile_angle(arg_9_0, 9.82, arg_9_1)

	if not wanted_projectile_angle then
		Vector3.set_z(arg_9_0, 0)

		local normalize = Vector3.normalize(arg_9_0)

		return Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(normalize, Vector3.up()), wanted_projectile_angle), normalize) * arg_9_1
	end
end
