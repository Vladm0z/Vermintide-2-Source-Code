-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_spawn/bt_erratic_follow_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTErraticFollowAction = class(BTErraticFollowAction, BTNode)

BTErraticFollowAction.init = function (arg_1_0, ...)
	BTErraticFollowAction.super.init(arg_1_0, ...)
end

BTErraticFollowAction.name = "BTErraticFollowAction"

local var_0_0 = false

BTErraticFollowAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.remembered_threat_pos = nil
	arg_2_2.chasing_timer = arg_2_2.unreachable_timer or 0
	arg_2_2.active_node = arg_2_0

	local var_2_1 = arg_2_2.move_state
	local var_2_2 = POSITION_LOOKUP[arg_2_2.target_unit]
	local var_2_3 = AiAnimUtils.get_start_move_animation(arg_2_1, var_2_2, var_2_0.start_anims_name)

	if arg_2_2.move_state ~= "moving" then
		arg_2_0:_go_moving(arg_2_1, arg_2_2, var_2_3)
	end

	local var_2_4 = var_2_0.tutorial_message_template

	if var_2_4 then
		local var_2_5 = NetworkLookup.tutorials[var_2_4]
		local var_2_6 = NetworkLookup.tutorials[arg_2_2.breed.name]

		Managers.state.network.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_5, var_2_6)
	end

	if not arg_2_2.random_dirs then
		arg_2_2.random_dirs = {
			var_2_0.move_jump_fwd_anims,
			var_2_0.move_jump_right_anims,
			var_2_0.move_jump_fwd_anims
		}
	end

	arg_2_2.next_jump_time = arg_2_3 + 1
	arg_2_2.boss_follow_next_line_of_sight_check_t = arg_2_3
end

BTErraticFollowAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(var_3_0)

	if arg_3_2.is_turning and not arg_3_5 then
		LocomotionUtils.reset_turning(arg_3_1, arg_3_2)

		arg_3_2.is_turning = nil
	end

	arg_3_2.move_animation_name = nil
	arg_3_2.animation_rotation_lock = nil
	arg_3_2.rotate_towards_position = nil
	arg_3_2.next_turn_at = nil
	arg_3_2.wanted_destination = nil
	arg_3_2.anim_cb_rotation_start = nil
	arg_3_2.anim_cb_move = nil
	arg_3_2.animation_lean = nil
	arg_3_2.active_node = nil
	arg_3_2.boss_follow_next_line_of_sight_check_t = nil
	arg_3_2.has_los_to_any_player = nil

	if arg_3_2.move_state == "jumping" and not arg_3_5 then
		local var_3_1 = arg_3_2.locomotion_extension

		var_3_1:set_animation_driven(false, true, false)
		var_3_1:use_lerp_rotation(true)
		var_3_1:set_movement_type("snap_to_navmesh")
		Managers.state.network:anim_event(arg_3_1, "move_fwd")

		arg_3_2.move_state = "moving"
	end
end

BTErraticFollowAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.locomotion_extension

	if arg_4_2.move_state == "jumping" then
		-- Nothing
	else
		arg_4_0:follow(arg_4_1, arg_4_3, arg_4_4, arg_4_2, var_4_0)
	end

	arg_4_2.chasing_timer = arg_4_2.chasing_timer + arg_4_4

	return "running", "evaluate"
end

BTErraticFollowAction._go_idle = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_2.move_state = "idle"

	Managers.state.network:anim_event(arg_5_1, "idle")

	local var_5_0 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.target_unit)

	arg_5_3:set_wanted_rotation(var_5_0)
end

BTErraticFollowAction._go_moving = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_2.move_state = "moving"

	Managers.state.network:anim_event(arg_6_1, arg_6_3)
end

BTErraticFollowAction._go_walking = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_2.move_state = "walking"

	Managers.state.network:anim_event(arg_7_1, arg_7_3)
end

BTErraticFollowAction.follow = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0 = arg_8_4.navigation_extension

	if var_8_0:number_failed_move_attempts() > 1 then
		arg_8_4.remembered_threat_pos = false

		if arg_8_4.move_state ~= "idle" then
			arg_8_0:_go_idle(arg_8_1, arg_8_4, arg_8_5)
		end
	end

	local var_8_1 = POSITION_LOOKUP[arg_8_1]

	if arg_8_4.target_dist > 10 and (arg_8_4.consecutive_jump or arg_8_2 > arg_8_4.next_jump_time) then
		arg_8_4.consecutive_jump = false

		if arg_8_0:investigate_jump(arg_8_1, arg_8_2, arg_8_4, var_8_1, arg_8_5) then
			arg_8_4.next_jump_time = arg_8_2 + math.random() * 4

			return
		else
			arg_8_4.next_jump_time = arg_8_2 + 2
		end
	end

	if arg_8_4.breed.use_big_boy_turning and arg_8_4.move_state == "moving" then
		local var_8_2 = arg_8_4.is_turning
		local var_8_3 = var_8_2 and "true" or "false"

		Debug.text("move_state:%s turning:%s", arg_8_4.move_state, var_8_3)

		if var_8_2 then
			LocomotionUtils.update_turning(arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		else
			LocomotionUtils.check_start_turning(arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		end
	end

	local var_8_4 = arg_8_4.action
	local var_8_5 = var_8_0:is_following_path()
	local var_8_6 = LocomotionUtils.follow_target_ogre(arg_8_1, arg_8_4, arg_8_2, arg_8_3)

	if var_8_6 then
		local var_8_7 = Vector3.flat(var_8_6 - POSITION_LOOKUP[arg_8_1])
		local var_8_8 = Vector3.length_squared(var_8_7)

		arg_8_4.wanted_destination = Vector3Box(var_8_6)
		arg_8_4.walking_allowed = not var_8_5 and var_8_8 <= var_8_4.enter_walk_dist_sq
	end

	if arg_8_2 > arg_8_4.boss_follow_next_line_of_sight_check_t then
		arg_8_4.has_los_to_any_player = PerceptionUtils.has_line_of_sight_to_any_player(arg_8_1)
		arg_8_4.boss_follow_next_line_of_sight_check_t = arg_8_2 + 2.5
	end

	local var_8_9 = arg_8_4.walking_allowed
	local var_8_10 = Vector3.flat(var_8_0:destination() - POSITION_LOOKUP[arg_8_1])
	local var_8_11 = Vector3.length_squared(var_8_10)
	local var_8_12

	if var_8_4.override_move_speed then
		var_8_0:set_max_speed(var_8_4.override_move_speed)
	else
		local var_8_13 = arg_8_4.breed

		if var_8_11 <= var_8_4.enter_walk_dist_sq and var_8_9 then
			var_8_0:set_max_speed(var_8_13.walk_speed)

			var_8_12 = var_8_4.walk_anim
		elseif var_8_13.catch_up_speed and var_8_11 > var_8_4.enter_catch_up_dist_sq and not arg_8_4.has_los_to_any_player then
			var_8_0:set_max_speed(var_8_13.catch_up_speed)

			var_8_12 = var_8_4.move_anim
		elseif var_8_11 >= var_8_4.leave_walk_dist_sq then
			var_8_0:set_max_speed(var_8_13.run_speed)

			var_8_12 = var_8_4.move_anim
		elseif arg_8_4.move_state == "walking" then
			var_8_0:set_max_speed(var_8_13.walk_speed)

			var_8_12 = var_8_4.walk_anim
		else
			var_8_0:set_max_speed(var_8_13.run_speed)

			var_8_12 = var_8_4.move_anim
		end
	end

	local var_8_14 = var_8_0:is_following_path()

	if var_8_14 and arg_8_4.move_state ~= "walking" and var_8_11 <= var_8_4.enter_walk_dist_sq and var_8_9 then
		arg_8_0:_go_walking(arg_8_1, arg_8_4, var_8_12)
	elseif var_8_14 and arg_8_4.move_state ~= "moving" and var_8_11 >= var_8_4.leave_walk_dist_sq then
		arg_8_0:_go_moving(arg_8_1, arg_8_4, var_8_12)
	elseif arg_8_4.move_state ~= "idle" and var_8_0:has_reached_destination(0.2) then
		arg_8_0:_go_idle(arg_8_1, arg_8_4, arg_8_5)
	end

	if not arg_8_4.animation_rotation_lock then
		if arg_8_4.target_outside_navmesh then
			local var_8_15 = LocomotionUtils.rotation_towards_unit_flat(arg_8_1, arg_8_4.target_unit)

			arg_8_5:set_wanted_rotation(var_8_15)
		else
			arg_8_5:set_wanted_rotation(nil)
		end
	end
end

BTErraticFollowAction.check_for_high_jump = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = World.get_data(arg_9_2.world, "physics_world")
	local var_9_1 = 1.2
	local var_9_2 = POSITION_LOOKUP[arg_9_1]
	local var_9_3 = Vector3.normalize(Quaternion.forward(Unit.world_rotation(arg_9_1, 0)))
	local var_9_4 = var_9_2 + Vector3(0, 0, 2)
	local var_9_5 = var_9_4 + var_9_3 * 2
	local var_9_6, var_9_7 = PhysicsWorld.immediate_raycast(var_9_0, var_9_5, Vector3(0, 0, 1), var_9_1, "closest", "collision_filter", "filter_ai_mover")
	local var_9_8, var_9_9 = PhysicsWorld.immediate_raycast(var_9_0, var_9_4, Vector3(0, 0, 1), var_9_1, "closest", "collision_filter", "filter_ai_mover")

	return (not var_9_6 or not var_9_7) and (not var_9_8 or not var_9_9)
end

BTErraticFollowAction.check_dir = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = Quaternion.rotate(Quaternion(Vector3.up(), arg_10_5.ray_angle), arg_10_2)
	local var_10_1 = arg_10_1 + var_10_0 * arg_10_5.ray_dist
	local var_10_2, var_10_3 = GwNavQueries.raycast(arg_10_3, arg_10_1, var_10_1, arg_10_4)
	local var_10_4 = #arg_10_5

	if var_10_2 then
		local var_10_5 = math.random(var_10_4)

		for iter_10_0 = 1, var_10_4 do
			local var_10_6 = arg_10_5[var_10_5]
			local var_10_7 = Quaternion.rotate(Quaternion(Vector3.up(), var_10_6.ray_angle), var_10_0)
			local var_10_8 = Vector3.dot(arg_10_2, var_10_7)
			local var_10_9 = var_10_1 + var_10_7 * var_10_6.ray_dist

			if var_10_8 <= 0 then
				return false
			end

			local var_10_10, var_10_11 = GwNavQueries.raycast(arg_10_3, var_10_1, var_10_9, arg_10_4)

			if var_10_10 then
				return var_10_6
			end

			var_10_5 = var_10_5 + 1

			if var_10_4 < var_10_5 then
				var_10_5 = 1
			end
		end
	elseif var_10_3 then
		return false
	end
end

BTErraticFollowAction.debug_ray_casts = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	arg_11_0:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_left_anims)
	arg_11_0:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_right_anims)
	arg_11_0:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_fwd_anims)
	arg_11_0:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_only_left_anims)
	arg_11_0:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_only_fwd_left_anims)
	arg_11_0:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_only_right_anims)
	arg_11_0:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_only_fwd_right_anims)
end

BTErraticFollowAction.investigate_jump = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	local var_12_0 = arg_12_3.navigation_extension
	local var_12_1 = var_12_0._nav_bot
	local var_12_2 = GwNavBot.get_path_current_node_index(var_12_1)
	local var_12_3 = GwNavBot.get_path_nodes_count(var_12_1)

	if var_12_2 < 0 or var_12_2 == var_12_3 then
		return false
	end

	local var_12_4 = arg_12_3.action
	local var_12_5 = GwNavBot.get_path_node_pos(var_12_1, var_12_2 + 1)
	local var_12_6 = Vector3.normalize(var_12_5 - arg_12_4)
	local var_12_7 = Quaternion.forward(Unit.local_rotation(arg_12_1, 0))
	local var_12_8 = Vector3.dot(var_12_7, var_12_6)
	local var_12_9 = arg_12_3.nav_world
	local var_12_10 = var_12_0:traverse_logic()
	local var_12_11
	local var_12_12

	if var_12_8 > 0.25 then
		local var_12_13 = arg_12_3.random_dirs

		table.shuffle(var_12_13)

		for iter_12_0 = 1, 3 do
			var_12_12 = arg_12_0:check_dir(arg_12_4, var_12_7, var_12_9, var_12_10, var_12_13[iter_12_0])

			if var_12_12 then
				break
			end
		end
	elseif Vector3.cross(var_12_7, var_12_6)[3] > 0 then
		print("moving away from target, need to turn left to get back")

		var_12_12 = arg_12_0:check_dir(arg_12_4, var_12_7, var_12_9, var_12_10, var_12_4.move_jump_only_fwd_left_anims)

		if not var_12_12 then
			var_12_12 = arg_12_0:check_dir(arg_12_4, var_12_7, var_12_9, var_12_10, var_12_4.move_jump_only_left_anims)
		end
	else
		print("moving away from target, need to turn right to get back")

		var_12_12 = arg_12_0:check_dir(arg_12_4, var_12_7, var_12_9, var_12_10, var_12_4.move_jump_only_right_anims)
		var_12_12 = var_12_12 or arg_12_0:check_dir(arg_12_4, var_12_7, var_12_9, var_12_10, var_12_4.move_jump_only_fwd_right_anims)

		if not var_12_12 then
			print("fail! could not turn back with, a jump")
		end
	end

	if var_12_12 then
		local var_12_14 = var_12_12[1]

		if var_12_4.uses_high_jumps and arg_12_0:check_for_high_jump(arg_12_1, arg_12_3) then
			var_12_14 = var_12_14 .. "_high"
		end

		arg_12_3.current_jump_data = var_12_12

		arg_12_5:set_movement_type("snap_to_navmesh")
		arg_12_5:set_animation_driven(true, false, false)
		LocomotionUtils.set_animation_translation_scale(arg_12_1, Vector3(1, 1, 1))
		arg_12_5:use_lerp_rotation(false)
		Managers.state.network:anim_event(arg_12_1, var_12_14)

		arg_12_3.jump_color = {
			math.random(100, 255),
			math.random(100, 255),
			math.random(100, 255)
		}
		arg_12_3.move_state = "jumping"

		return true
	end

	return false
end

BTErraticFollowAction.get_travel_dir = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_2.navigation_extension._nav_bot
	local var_13_1 = GwNavBot.get_path_current_node_index(var_13_0)
	local var_13_2 = GwNavBot.get_path_nodes_count(var_13_0)

	if var_13_1 < 0 or var_13_1 == var_13_2 then
		return
	end

	local var_13_3 = arg_13_2.action
	local var_13_4 = GwNavBot.get_path_node_pos(var_13_0, var_13_1 + 1)

	return (Vector3.normalize(var_13_4 - arg_13_3))
end

BTErraticFollowAction.anim_cb_move_jump_finished = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = POSITION_LOOKUP[arg_14_1]
	local var_14_1 = arg_14_2.locomotion_extension
	local var_14_2 = Quaternion.forward(Unit.local_rotation(arg_14_1, 0))
	local var_14_3 = arg_14_0:get_travel_dir(arg_14_1, arg_14_2, var_14_0) or var_14_2
	local var_14_4 = Vector3.dot(var_14_2, var_14_3)
	local var_14_5 = arg_14_2.target_dist > 10
	local var_14_6 = POSITION_LOOKUP[arg_14_2.target_unit]

	arg_14_2.navigation_extension:reset_destination(var_14_6)

	if var_14_5 then
		local var_14_7 = Managers.time:time("game")

		if arg_14_0:investigate_jump(arg_14_1, var_14_7, arg_14_2, var_14_0, var_14_1) then
			return
		end
	end

	var_14_1:set_animation_driven(false, true, false)
	var_14_1:use_lerp_rotation(true)
	var_14_1:set_movement_type("snap_to_navmesh")
	Managers.state.network:anim_event(arg_14_1, "move_fwd")

	arg_14_2.move_state = "moving"
end
