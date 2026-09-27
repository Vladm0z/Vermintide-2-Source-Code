-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_spawn/bt_erratic_follow_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTErraticFollowAction = class(BTErraticFollowAction, BTNode)

BTErraticFollowAction.init = function (arg_1_0, ...)
	-- function 1
	BTErraticFollowAction.super.init(arg_1_0, ...)
end

BTErraticFollowAction.name = "BTErraticFollowAction"

local flag = false

BTErraticFollowAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.remembered_threat_pos = nil

	local unreachable_timer = arg_2_2.unreachable_timer

	unreachable_timer = unreachable_timer or 0
	arg_2_2.chasing_timer = unreachable_timer
	arg_2_2.active_node = self

	local move_state = arg_2_2.move_state
	local var_2_3 = POSITION_LOOKUP[arg_2_2.target_unit]
	local get_start_move_animation = AiAnimUtils.get_start_move_animation(arg_2_1, var_2_3, action_data.start_anims_name)

	if arg_2_2.move_state ~= "moving" then
		self:_go_moving(arg_2_1, arg_2_2, get_start_move_animation)
	end

	local tutorial_message_template = action_data.tutorial_message_template

	if not tutorial_message_template then
		local var_2_6 = NetworkLookup.tutorials[tutorial_message_template]
		local var_2_7 = NetworkLookup.tutorials[arg_2_2.breed.name]

		Managers.state.network.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_6, var_2_7)
	end

	if not arg_2_2.random_dirs then
		arg_2_2.random_dirs = {
			action_data.move_jump_fwd_anims,
			action_data.move_jump_right_anims,
			action_data.move_jump_fwd_anims
		}
	end

	arg_2_2.next_jump_time = arg_2_3 + 1
	arg_2_2.boss_follow_next_line_of_sight_check_t = arg_2_3
end

BTErraticFollowAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(get_default_breed_move_speed)

	if not (not arg_3_2.is_turning and arg_3_5) then
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

	if not (arg_3_2.move_state ~= "jumping" or arg_3_5) then
		local locomotion_extension = arg_3_2.locomotion_extension

		locomotion_extension:set_animation_driven(false, true, false)
		locomotion_extension:use_lerp_rotation(true)
		locomotion_extension:set_movement_type("snap_to_navmesh")
		Managers.state.network:anim_event(arg_3_1, "move_fwd")

		arg_3_2.move_state = "moving"
	end
end

BTErraticFollowAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local locomotion_extension = arg_4_2.locomotion_extension

	if arg_4_2.move_state == "jumping" then
		-- Nothing
	else
		self:follow(arg_4_1, arg_4_3, arg_4_4, arg_4_2, locomotion_extension)
	end

	arg_4_2.chasing_timer = arg_4_2.chasing_timer + arg_4_4

	return "running", "evaluate"
end

BTErraticFollowAction._go_idle = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	arg_5_2.move_state = "idle"

	Managers.state.network:anim_event(arg_5_1, "idle")

	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.target_unit)

	arg_5_3:set_wanted_rotation(rotation_towards_unit_flat)
end

BTErraticFollowAction._go_moving = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	arg_6_2.move_state = "moving"

	Managers.state.network:anim_event(arg_6_1, arg_6_3)
end

BTErraticFollowAction._go_walking = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	arg_7_2.move_state = "walking"

	Managers.state.network:anim_event(arg_7_1, arg_7_3)
end

BTErraticFollowAction.follow = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local navigation_extension = arg_8_4.navigation_extension

	if navigation_extension:number_failed_move_attempts() > 1 then
		arg_8_4.remembered_threat_pos = false

		if arg_8_4.move_state ~= "idle" then
			self:_go_idle(arg_8_1, arg_8_4, arg_8_5)
		end
	end

	local var_8_1 = POSITION_LOOKUP[arg_8_1]

	if not (not (arg_8_4.target_dist > 10) or arg_8_4.consecutive_jump or not (arg_8_2 > arg_8_4.next_jump_time)) then
		arg_8_4.consecutive_jump = false

		if not self:investigate_jump(arg_8_1, arg_8_2, arg_8_4, var_8_1, arg_8_5) then
			arg_8_4.next_jump_time = arg_8_2 + math.random() * 4

			return
		else
			arg_8_4.next_jump_time = arg_8_2 + 2
		end
	end

	if not (not arg_8_4.breed.use_big_boy_turning and arg_8_4.move_state ~= "moving") then
		local is_turning = arg_8_4.is_turning
		local flag

		flag = not is_turning and "true" and "false"

		Debug.text("move_state:%s turning:%s", arg_8_4.move_state, flag)

		if not is_turning then
			LocomotionUtils.update_turning(arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		else
			LocomotionUtils.check_start_turning(arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		end
	end

	local action = arg_8_4.action
	local is_following_path = navigation_extension:is_following_path()
	local follow_target_ogre = LocomotionUtils.follow_target_ogre(arg_8_1, arg_8_4, arg_8_2, arg_8_3)

	if not follow_target_ogre then
		local flat = Vector3.flat(follow_target_ogre - POSITION_LOOKUP[arg_8_1])
		local length_squared = Vector3.length_squared(flat)

		arg_8_4.wanted_destination = Vector3Box(follow_target_ogre)
		arg_8_4.walking_allowed = not not is_following_path or length_squared <= action.enter_walk_dist_sq
	end

	if arg_8_2 > arg_8_4.boss_follow_next_line_of_sight_check_t then
		arg_8_4.has_los_to_any_player = PerceptionUtils.has_line_of_sight_to_any_player(arg_8_1)
		arg_8_4.boss_follow_next_line_of_sight_check_t = arg_8_2 + 2.5
	end

	local walking_allowed = arg_8_4.walking_allowed
	local flat_2 = Vector3.flat(navigation_extension:destination() - POSITION_LOOKUP[arg_8_1])
	local length_squared_2 = Vector3.length_squared(flat_2)
	local var_8_12

	if not action.override_move_speed then
		navigation_extension:set_max_speed(action.override_move_speed)
	else
		local breed = arg_8_4.breed

		if not (length_squared_2 <= action.enter_walk_dist_sq) or not walking_allowed then
			navigation_extension:set_max_speed(breed.walk_speed)

			var_8_12 = action.walk_anim
		elseif not (not breed.catch_up_speed and not (length_squared_2 > action.enter_catch_up_dist_sq) or arg_8_4.has_los_to_any_player) then
			navigation_extension:set_max_speed(breed.catch_up_speed)

			var_8_12 = action.move_anim
		elseif length_squared_2 >= action.leave_walk_dist_sq then
			navigation_extension:set_max_speed(breed.run_speed)

			var_8_12 = action.move_anim
		elseif arg_8_4.move_state == "walking" then
			navigation_extension:set_max_speed(breed.walk_speed)

			var_8_12 = action.walk_anim
		else
			navigation_extension:set_max_speed(breed.run_speed)

			var_8_12 = action.move_anim
		end
	end

	local is_following_path_2 = navigation_extension:is_following_path()

	if not is_following_path_2 and arg_8_4.move_state == "walking" and not (length_squared_2 <= action.enter_walk_dist_sq) or not walking_allowed then
		self:_go_walking(arg_8_1, arg_8_4, var_8_12)
	elseif not (not is_following_path_2 and arg_8_4.move_state == "moving" or not (length_squared_2 >= action.leave_walk_dist_sq)) then
		self:_go_moving(arg_8_1, arg_8_4, var_8_12)
	elseif arg_8_4.move_state == "idle" or not navigation_extension:has_reached_destination(0.2) then
		self:_go_idle(arg_8_1, arg_8_4, arg_8_5)
	end

	if not not arg_8_4.animation_rotation_lock then
		if not arg_8_4.target_outside_navmesh then
			local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_8_1, arg_8_4.target_unit)

			arg_8_5:set_wanted_rotation(rotation_towards_unit_flat)
		else
			arg_8_5:set_wanted_rotation(nil)
		end
	end
end

BTErraticFollowAction.check_for_high_jump = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local get_data = World.get_data(arg_9_2.world, "physics_world")
	local num = 1.2
	local var_9_2 = POSITION_LOOKUP[arg_9_1]
	local normalize = Vector3.normalize(Quaternion.forward(Unit.world_rotation(arg_9_1, 0)))
	local num_2 = var_9_2 + Vector3(0, 0, 2)
	local num_3 = num_2 + normalize * 2
	local immediate_raycast, var_9_7 = PhysicsWorld.immediate_raycast(get_data, num_3, Vector3(0, 0, 1), num, "closest", "collision_filter", "filter_ai_mover")
	local immediate_raycast_2, var_9_9 = PhysicsWorld.immediate_raycast(get_data, num_2, Vector3(0, 0, 1), num, "closest", "collision_filter", "filter_ai_mover")

	return (not immediate_raycast and not not var_9_7 or not immediate_raycast_2) and not var_9_9
end

BTErraticFollowAction.check_dir = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local rotate = Quaternion.rotate(Quaternion(Vector3.up(), arg_10_5.ray_angle), arg_10_2)
	local num = arg_10_1 + rotate * arg_10_5.ray_dist
	local raycast, var_10_3 = GwNavQueries.raycast(arg_10_3, arg_10_1, num, arg_10_4)
	local count = #arg_10_5

	if not raycast then
		local random = math.random(count)

		for i = 1, count do
			local var_10_6 = arg_10_5[random]
			local rotate_2 = Quaternion.rotate(Quaternion(Vector3.up(), var_10_6.ray_angle), rotate)
			local dot = Vector3.dot(arg_10_2, rotate_2)
			local num_2 = num + rotate_2 * var_10_6.ray_dist

			if dot <= 0 then
				return false
			end

			local raycast_2, var_10_11 = GwNavQueries.raycast(arg_10_3, num, num_2, arg_10_4)

			if not raycast_2 then
				return var_10_6
			end

			random = random + 1

			if count < random then
				random = 1
			end
		end
	elseif not var_10_3 then
		return false
	end
end

BTErraticFollowAction.debug_ray_casts = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	self:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_left_anims)
	self:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_right_anims)
	self:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_fwd_anims)
	self:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_only_left_anims)
	self:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_only_fwd_left_anims)
	self:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_only_right_anims)
	self:check_dir(arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5.move_jump_only_fwd_right_anims)
end

BTErraticFollowAction.investigate_jump = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	local navigation_extension = arg_12_3.navigation_extension
	local _nav_bot = navigation_extension._nav_bot
	local get_path_current_node_index = GwNavBot.get_path_current_node_index(_nav_bot)
	local get_path_nodes_count = GwNavBot.get_path_nodes_count(_nav_bot)

	if not (get_path_current_node_index < 0 or get_path_current_node_index ~= get_path_nodes_count) then
		return false
	end

	local action = arg_12_3.action
	local get_path_node_pos = GwNavBot.get_path_node_pos(_nav_bot, get_path_current_node_index + 1)
	local normalize = Vector3.normalize(get_path_node_pos - arg_12_4)
	local forward = Quaternion.forward(Unit.local_rotation(arg_12_1, 0))
	local dot = Vector3.dot(forward, normalize)
	local nav_world = arg_12_3.nav_world
	local traverse_logic = navigation_extension:traverse_logic()
	local var_12_11
	local var_12_12

	if not (dot > 0.25) then
		local random_dirs = arg_12_3.random_dirs

		table.shuffle(random_dirs)

		for i = 1, 3 do
			var_12_12 = self:check_dir(arg_12_4, forward, nav_world, traverse_logic, random_dirs[i])

			if not var_12_12 then
				break
			end
		end
	elseif not (Vector3.cross(forward, normalize)[3] > 0) then
		print("moving away from target, need to turn left to get back")

		var_12_12 = self:check_dir(arg_12_4, forward, nav_world, traverse_logic, action.move_jump_only_fwd_left_anims)

		if not var_12_12 then
			var_12_12 = self:check_dir(arg_12_4, forward, nav_world, traverse_logic, action.move_jump_only_left_anims)
		end
	else
		print("moving away from target, need to turn right to get back")

		var_12_12 = self:check_dir(arg_12_4, forward, nav_world, traverse_logic, action.move_jump_only_right_anims)
		var_12_12 = var_12_12 or self:check_dir(arg_12_4, forward, nav_world, traverse_logic, action.move_jump_only_fwd_right_anims)

		if not var_12_12 then
			print("fail! could not turn back with, a jump")
		end
	end

	if not var_12_12 then
		local var_12_14 = var_12_12[1]

		if not action.uses_high_jumps and not self:check_for_high_jump(arg_12_1, arg_12_3) then
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
	-- function 13
	local _nav_bot = arg_13_2.navigation_extension._nav_bot
	local get_path_current_node_index = GwNavBot.get_path_current_node_index(_nav_bot)
	local get_path_nodes_count = GwNavBot.get_path_nodes_count(_nav_bot)

	if not (get_path_current_node_index < 0 or get_path_current_node_index ~= get_path_nodes_count) then
		return
	end

	local action = arg_13_2.action
	local get_path_node_pos = GwNavBot.get_path_node_pos(_nav_bot, get_path_current_node_index + 1)

	return (Vector3.normalize(get_path_node_pos - arg_13_3))
end

BTErraticFollowAction.anim_cb_move_jump_finished = function (self, arg_14_1, arg_14_2)
	-- function 14
	local var_14_0 = POSITION_LOOKUP[arg_14_1]
	local locomotion_extension = arg_14_2.locomotion_extension
	local forward = Quaternion.forward(Unit.local_rotation(arg_14_1, 0))
	local get_travel_dir = self:get_travel_dir(arg_14_1, arg_14_2, var_14_0)

	get_travel_dir = get_travel_dir or forward

	local dot = Vector3.dot(forward, get_travel_dir)
	local flag = arg_14_2.target_dist > 10
	local var_14_6 = POSITION_LOOKUP[arg_14_2.target_unit]

	arg_14_2.navigation_extension:reset_destination(var_14_6)

	if not flag then
		local time = Managers.time:time("game")

		if not self:investigate_jump(arg_14_1, time, arg_14_2, var_14_0, locomotion_extension) then
			return
		end
	end

	locomotion_extension:set_animation_driven(false, true, false)
	locomotion_extension:use_lerp_rotation(true)
	locomotion_extension:set_movement_type("snap_to_navmesh")
	Managers.state.network:anim_event(arg_14_1, "move_fwd")

	arg_14_2.move_state = "moving"
end
