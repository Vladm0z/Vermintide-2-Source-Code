-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_prepare_for_crazy_jump_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPrepareForCrazyJumpAction = class(BTPrepareForCrazyJumpAction, BTNode)
BTPrepareForCrazyJumpAction.name = "BTPrepareForCrazyJumpAction"

local var_0_0 = POSITION_LOOKUP
local var_0_1 = AiUtils
local var_0_2 = Unit.alive

BTPrepareForCrazyJumpAction.init = function (arg_1_0, ...)
	BTPrepareForCrazyJumpAction.super.init(arg_1_0, ...)
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2)
	if script_data.debug_ai_movement then
		Debug.world_sticky_text(var_0_0[arg_2_0], arg_2_1, arg_2_2)
	end
end

BTPrepareForCrazyJumpAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	aiprint("ENTER BTPrepareForCrazyJumpAction")

	local var_3_0 = arg_3_0._tree_node.action_data

	arg_3_2.action = var_3_0

	LocomotionUtils.set_animation_driven_movement(arg_3_1, false)

	local var_3_1 = Managers.state.network

	var_3_1:anim_event(arg_3_1, "move_fwd")

	arg_3_2.jump_data = {
		crouching = false,
		ready_crouch_time = false,
		segment_list = {}
	}
	arg_3_2.remembered_threat_pos = nil

	local var_3_2 = var_3_0 and var_3_0.tutorial_message_template

	if var_3_2 then
		local var_3_3 = NetworkLookup.tutorials[var_3_2]
		local var_3_4 = NetworkLookup.tutorials[arg_3_2.breed.name]

		var_3_1.network_transmit:send_rpc_all("rpc_tutorial_message", var_3_3, var_3_4)
	end
end

BTPrepareForCrazyJumpAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	aiprint("LEAVE BTPrepareForCrazyJumpAction")

	arg_4_2.jump_data.jump_at_target_outside_mesh = nil

	local var_4_0 = var_0_1.get_default_breed_move_speed(arg_4_1, arg_4_2)

	arg_4_2.navigation_extension:set_max_speed(var_4_0)

	if arg_4_4 ~= "done" then
		Managers.state.network:anim_event(arg_4_1, "to_upright")

		arg_4_2.jump_data = nil
	end
end

BTPrepareForCrazyJumpAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = ScriptUnit.extension(arg_5_1, "locomotion_system")
	local var_5_1 = arg_5_2.breed

	if arg_5_2.target_dist > var_5_1.jump_range then
		return "failed"
	end

	local var_5_2 = arg_5_2.target_unit

	if not HEALTH_ALIVE[var_5_2] then
		return "failed"
	end

	local var_5_3 = ScriptUnit.has_extension(var_5_2, "status_system")

	if not var_5_3 then
		return "failed"
	end

	if var_5_3:is_pounced_down() then
		return "failed"
	end

	if arg_5_2.move_closer_to_target then
		LocomotionUtils.follow_target(arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		var_5_0:set_wanted_rotation(nil)

		if arg_5_3 > arg_5_2.move_closer_to_target_timer then
			local var_5_4 = arg_5_2.jump_data
			local var_5_5, var_5_6, var_5_7 = BTPrepareForCrazyJumpAction.ready_to_jump(arg_5_1, arg_5_2, var_5_4, false)

			if var_5_5 then
				BTPrepareForCrazyJumpAction.start_crawling(arg_5_1, arg_5_2, arg_5_3, var_5_4)

				arg_5_2.move_closer_to_target = false
			else
				if arg_5_2.target_dist < 2 and GwNavQueries.raycango(arg_5_2.nav_world, POSITION_LOOKUP[arg_5_1], POSITION_LOOKUP[var_5_2]) then
					BTPrepareForCrazyJumpAction.start_crawling(arg_5_1, arg_5_2, arg_5_3, var_5_4)

					arg_5_2.move_closer_to_target = false
				else
					return "failed"
				end

				arg_5_2.move_closer_to_target_timer = arg_5_3 + 1
			end
		end
	else
		local var_5_8 = POSITION_LOOKUP[var_5_2]
		local var_5_9 = LocomotionUtils.look_at_position_flat(arg_5_1, var_5_8)

		var_5_0:set_wanted_rotation(var_5_9)

		local var_5_10 = arg_5_2.jump_data

		if var_5_10.crouching then
			LocomotionUtils.follow_target(arg_5_1, arg_5_2, arg_5_3, arg_5_4)

			if arg_5_2.target_outside_navmesh then
				if not var_5_10.jump_at_target_outside_mesh then
					Managers.state.network:anim_event(arg_5_1, "idle")
					arg_5_2.navigation_extension:move_to(var_0_0[arg_5_1])

					var_5_10.jump_at_target_outside_mesh = true
				end
			else
				var_5_0:set_wanted_rotation(nil)
			end

			if arg_5_3 > var_5_10.ready_crouch_time then
				local var_5_11, var_5_12, var_5_13 = BTPrepareForCrazyJumpAction.ready_to_jump(arg_5_1, arg_5_2, var_5_10, true)

				if var_5_11 then
					return "done"
				end

				var_5_10.crouching = false
				arg_5_2.move_closer_to_target = true

				Managers.state.network:anim_event(arg_5_1, "to_upright")
				arg_5_2.navigation_extension:set_max_speed(arg_5_2.breed.run_speed)

				arg_5_2.move_closer_to_target_timer = arg_5_3 + 1
				arg_5_2.remembered_threat_pos = nil
				var_5_10.ready_crouch_time = nil

				return "running"
			end
		else
			BTPrepareForCrazyJumpAction.start_crawling(arg_5_1, arg_5_2, arg_5_3, var_5_10)
		end
	end

	return "running"
end

BTPrepareForCrazyJumpAction.start_crawling = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_1.action

	arg_6_1.navigation_extension:set_max_speed(arg_6_1.breed.walk_speed)
	Managers.state.network:anim_event(arg_6_0, "to_crouch")

	local var_6_1 = var_6_0.difficulty_prepare_jump_time[Managers.state.difficulty:get_difficulty_rank()] or var_6_0.difficulty_prepare_jump_time[2]

	arg_6_3.crouching = true
	arg_6_3.ready_crouch_time = arg_6_2 + (var_6_1 or 0.5)
end

BTPrepareForCrazyJumpAction.ready_to_jump = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = Unit.node(arg_7_1.target_unit, "j_neck")
	local var_7_1 = var_0_0[arg_7_0]
	local var_7_2 = Unit.world_position(arg_7_1.target_unit, 0) + Vector3(0, 0, 0.2)
	local var_7_3 = var_7_1 + Vector3.normalize(var_7_2 - var_7_1) * 0.3
	local var_7_4 = Vector3.distance(var_7_3, var_7_2)
	local var_7_5
	local var_7_6
	local var_7_7

	if var_7_4 < 2.5 then
		if LocomotionUtils.target_in_los(arg_7_0, arg_7_1) then
			local var_7_8 = arg_7_1.breed.jump_speed

			var_7_6 = BTPrepareForCrazyJumpAction.test_simple_jump(var_7_2 - var_7_3, var_7_8)

			if var_7_6 then
				var_7_5 = true
			end
		end
	else
		local var_7_9 = Vector3(0, 0, 0.05)

		var_7_5, var_7_6, var_7_7 = BTPrepareForCrazyJumpAction.test_trajectory(arg_7_1, var_7_3 + var_7_9, var_7_2 + var_7_9, arg_7_2.segment_list, true)
	end

	if var_7_5 and arg_7_3 then
		arg_7_2.jump_target_pos = Vector3Box(var_7_2)
		arg_7_2.jump_velocity_boxed = Vector3Box(var_7_6)
		arg_7_2.total_distance = var_7_4
		arg_7_2.enemy_spine_node = var_7_0
	end

	return var_7_5, var_7_6, var_7_7
end

BTPrepareForCrazyJumpAction.test_trajectory = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = World.get_data(arg_8_0.world, "physics_world")
	local var_8_1 = arg_8_0.breed.jump_gravity
	local var_8_2
	local var_8_3 = arg_8_0.breed.jump_speed
	local var_8_4 = Vector3(0, 0, 0.05)
	local var_8_5 = 1
	local var_8_6 = ScriptUnit.extension(arg_8_0.target_unit, "locomotion_system").velocity_current:unbox()
	local var_8_7 = Vector3.normalize(arg_8_2 - arg_8_1)
	local var_8_8 = Vector3.dot(var_8_7, Vector3(0, 0, 1))
	local var_8_9
	local var_8_10 = arg_8_1.z - arg_8_2.z

	if var_8_8 < -0.5 and var_8_10 > 2 and var_8_10 < 6 then
		var_8_9 = true
		var_8_3 = 5
	end

	if var_8_9 then
		var_8_2 = WeaponHelper.angle_to_hit_moving_target(arg_8_1, arg_8_2, var_8_3, var_8_6, var_8_1, var_8_5, var_8_9)
	else
		var_8_2 = WeaponHelper.angle_to_hit_moving_target(arg_8_1, arg_8_2, var_8_3, var_8_6, var_8_1, var_8_5)
	end

	if not var_8_2 and not var_8_3 then
		return
	end

	local var_8_11, var_8_12, var_8_13 = WeaponHelper.test_angled_trajectory(var_8_0, arg_8_1 + var_8_4, arg_8_2 + var_8_4, -var_8_1, var_8_3, var_8_2, arg_8_3)

	if var_8_12 and var_8_3 then
		var_8_12 = Vector3.normalize(var_8_12) * var_8_3
	end

	if arg_8_4 then
		if not var_8_11 then
			return
		end

		var_8_11 = WeaponHelper.ray_segmented_test(var_8_0, arg_8_3, Vector3(0, 0, 1.6))

		if not var_8_11 then
			return
		end

		local var_8_14 = Vector3.cross(Vector3.normalize(arg_8_2 - arg_8_1), Vector3.up()) * 0.4

		var_8_11 = WeaponHelper.ray_segmented_test(var_8_0, arg_8_3, Vector3(0, 0, 0.7) + var_8_14)

		if not var_8_11 then
			return
		end

		var_8_11 = WeaponHelper.ray_segmented_test(var_8_0, arg_8_3, Vector3(0, 0, 0.7) - var_8_14)

		if not var_8_11 then
			return
		end
	end

	return var_8_11, var_8_12, var_8_13
end

BTPrepareForCrazyJumpAction.test_simple_jump = function (arg_9_0, arg_9_1)
	local var_9_0 = WeaponHelper:wanted_projectile_angle(arg_9_0, 9.82, arg_9_1)

	if var_9_0 then
		Vector3.set_z(arg_9_0, 0)

		local var_9_1 = Vector3.normalize(arg_9_0)

		return Quaternion.rotate(Quaternion.axis_angle(Vector3.cross(var_9_1, Vector3.up()), var_9_0), var_9_1) * arg_9_1
	end
end
