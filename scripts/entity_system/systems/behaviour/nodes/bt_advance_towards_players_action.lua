-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_advance_towards_players_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTAdvanceTowardsPlayersAction = class(BTAdvanceTowardsPlayersAction, BTNode)
BTAdvanceTowardsPlayersAction.name = "BTAdvanceTowardsPlayersAction"

BTAdvanceTowardsPlayersAction.init = function (arg_1_0, ...)
	-- function 1
	BTAdvanceTowardsPlayersAction.super.init(arg_1_0, ...)
end

local num = 1

BTAdvanceTowardsPlayersAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	local throw_at_distance

	if not arg_2_2.has_thrown then
		throw_at_distance = action_data.throw_at_distance

		if not throw_at_distance then
			-- Nothing
		end
	end

	throw_at_distance = action_data.throw_at_distance_first_time

	::label_2_0::

	local advance_towards_players = arg_2_2.advance_towards_players

	advance_towards_players = advance_towards_players or {}

	local timer = advance_towards_players.timer

	timer = timer or 0
	advance_towards_players.timer = timer
	advance_towards_players.time_before_throw_timer = 0
	advance_towards_players.evaluate_timer = num

	local direction = advance_towards_players.direction

	direction = direction or 1 - math.random(0, 1) * 2
	advance_towards_players.direction = direction
	advance_towards_players.time_until_first_throw = AiUtils.random(action_data.time_until_first_throw[1], action_data.time_until_first_throw[2])
	advance_towards_players.throw_at_distance = AiUtils.random(throw_at_distance[1], throw_at_distance[2])

	local goal_get_fails = advance_towards_players.goal_get_fails

	goal_get_fails = goal_get_fails or 0
	advance_towards_players.goal_get_fails = goal_get_fails
	arg_2_2.advance_towards_players = advance_towards_players

	if arg_2_2.move_state ~= "idle" then
		self:start_idle_animation(arg_2_1, arg_2_2)
	end

	local navigation_extension = arg_2_2.navigation_extension

	navigation_extension:set_max_speed(arg_2_2.breed.walk_speed)

	if not arg_2_2.move_pos then
		local unbox = arg_2_2.move_pos:unbox()

		navigation_extension:move_to(unbox)
	end

	local tutorial_message_template = action_data.tutorial_message_template

	if not tutorial_message_template then
		local var_2_9 = NetworkLookup.tutorials[tutorial_message_template]
		local var_2_10 = NetworkLookup.tutorials[arg_2_2.breed.name]

		Managers.state.network.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_9, var_2_10)
	end
end

BTAdvanceTowardsPlayersAction.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.action = nil

	local navigation_extension = arg_3_2.navigation_extension

	if arg_3_4 == "aborted" then
		local is_following_path = navigation_extension:is_following_path()

		if not (not arg_3_2.move_pos and not is_following_path and arg_3_2.move_state ~= "idle") then
			self:start_move_animation(arg_3_1, arg_3_2)
		end

		arg_3_2.move_pos = nil
	end

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	navigation_extension:set_max_speed(get_default_breed_move_speed)
end

BTAdvanceTowardsPlayersAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local navigation_extension = arg_4_2.navigation_extension
	local breed = arg_4_2.breed
	local action = arg_4_2.action
	local advance_towards_players = arg_4_2.advance_towards_players
	local flag

	flag = arg_4_2.times_thrown == 0 or not 0 or advance_towards_players.evaluate_timer - arg_4_4
	advance_towards_players.evaluate_timer = flag
	advance_towards_players.timer = advance_towards_players.timer + arg_4_4
	advance_towards_players.time_before_throw_timer = advance_towards_players.time_before_throw_timer + arg_4_4

	local number_failed_move_attempts = navigation_extension:number_failed_move_attempts()
	local is_following_path = navigation_extension:is_following_path()

	if not (not arg_4_2.move_pos and not (number_failed_move_attempts > 0)) then
		if not self:get_new_goal(arg_4_1, arg_4_2) then
			return "failed"
		end

		local unbox = arg_4_2.move_pos:unbox()

		navigation_extension:move_to(unbox)

		return "running"
	end

	if not (not arg_4_2.move_pos and not is_following_path and arg_4_2.move_state ~= "idle") then
		self:start_move_animation(arg_4_1, arg_4_2)
	end

	arg_4_2.locomotion_extension:set_wanted_rotation(nil)

	local unbox_2 = arg_4_2.move_pos:unbox()
	local target_unit = arg_4_2.target_unit

	if Vector3.distance_squared(unbox_2, POSITION_LOOKUP[arg_4_1]) < 0.25 then
		arg_4_2.move_pos = nil
	end

	if advance_towards_players.evaluate_timer > 0 then
		return "running"
	end

	if arg_4_2.target_dist > action.exit_to_skulk_distance then
		arg_4_2.skulk_data.radius = arg_4_2.target_dist

		return "failed"
	end

	if not self:want_to_throw(arg_4_1, arg_4_2, arg_4_3) then
		advance_towards_players.evaluate_timer = num

		return "running"
	end

	local can_throw = self:can_throw(arg_4_1, arg_4_2, arg_4_3)

	if not self:has_valid_target(target_unit, arg_4_2) and not can_throw and not self:_calculate_trajectory_to_target(arg_4_1, arg_4_2.world, arg_4_2, action) then
		arg_4_2.has_thrown = true
		arg_4_2.move_pos = nil

		return "done"
	end

	advance_towards_players.evaluate_timer = num

	return "running"
end

BTAdvanceTowardsPlayersAction._calculate_trajectory_to_target = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local copy = Vector3.copy(POSITION_LOOKUP[arg_5_1])
	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_3.target_unit)
	local var_5_2, var_5_3, var_5_4 = unpack(arg_5_4.attack_throw_offset)
	local var_5_5 = Vector3(var_5_2, var_5_3, var_5_4)
	local num = copy + Quaternion.rotate(rotation_towards_unit_flat, var_5_5)

	copy.z = num.z

	local num_2 = num - copy
	local normalize = Vector3.normalize(num_2)
	local length = Vector3.length(num_2)
	local get_data = World.get_data(arg_5_2, "physics_world")

	if not PhysicsWorld.immediate_raycast(get_data, copy, normalize, length, "closest", "collision_filter", "filter_enemy_ray_projectile") then
		return false
	end

	local num_3 = arg_5_4.radius - 1
	local range = arg_5_4.range
	local pick_area_target = PerceptionUtils.pick_area_target(arg_5_1, arg_5_3, nil, num_3, range)
	local normalize_2 = Vector3.normalize(pick_area_target - num)
	local calculate_trajectory, var_5_16, var_5_17 = WeaponHelper:calculate_trajectory(arg_5_2, num, pick_area_target, ProjectileGravitySettings.default, arg_5_3.breed.max_globe_throw_speed)

	if not calculate_trajectory then
		local throw_globe_data = arg_5_3.throw_globe_data

		throw_globe_data = throw_globe_data or {
			throw_pos = Vector3Box(),
			target_direction = Vector3Box()
		}
		arg_5_3.throw_globe_data = throw_globe_data
		arg_5_3.throw_globe_data.angle = var_5_16
		arg_5_3.throw_globe_data.speed = var_5_17

		arg_5_3.throw_globe_data.throw_pos:store(num)
		arg_5_3.throw_globe_data.target_direction:store(normalize_2)
	end

	return calculate_trajectory
end

BTAdvanceTowardsPlayersAction.has_valid_target = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return arg_6_2.side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_6_1]
end

BTAdvanceTowardsPlayersAction.want_to_throw = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local action = arg_7_2.action
	local total_slots_count = arg_7_2.total_slots_count
	local advance_towards_players = arg_7_2.advance_towards_players

	if advance_towards_players.time_until_first_throw + action.slot_count_time_modifier * total_slots_count > advance_towards_players.timer then
		return false
	end

	local throw_globe_data = arg_7_2.throw_globe_data

	if not (not throw_globe_data and not throw_globe_data.next_throw_at and not (arg_7_2.target_dist < 4)) then
		throw_globe_data.next_throw_at = -math.huge

		return true
	end

	local flag = not throw_globe_data and throw_globe_data.next_throw_at

	if not flag then
		if flag < arg_7_3 then
			if arg_7_2.target_dist < action.range then
				return true
			end
		else
			return false
		end
	end

	local num = action.time_before_throw_distance_modifier * advance_towards_players.time_before_throw_timer
	local num_2 = action.slot_count_distance_modifier * total_slots_count

	if advance_towards_players.throw_at_distance + num_2 + num < arg_7_2.target_dist then
		return false
	end

	return true
end

BTAdvanceTowardsPlayersAction.can_throw = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	if not arg_8_2.action.ignore_LOS_check_after_first_throw and not arg_8_2.has_thrown then
		return true
	end

	local num = POSITION_LOOKUP[arg_8_1] + Vector3.up()
	local num_2 = POSITION_LOOKUP[arg_8_2.target_unit] + Vector3.up() * 2 - num
	local normalize = Vector3.normalize(num_2)
	local length = Vector3.length(num_2)
	local immediate_raycast, var_8_5, var_8_6, var_8_7, var_8_8 = PhysicsWorld.immediate_raycast(World.get_data(arg_8_2.world, "physics_world"), num, normalize, length, "closest", "collision_filter", "filter_ai_line_of_sight_check")

	return not immediate_raycast
end

BTAdvanceTowardsPlayersAction.get_new_goal = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local action = arg_9_2.action
	local var_9_1 = action.keep_target_distance[1]
	local var_9_2 = action.keep_target_distance[2]
	local advance_towards_players = arg_9_2.advance_towards_players
	local goal_get_fails = advance_towards_players.goal_get_fails
	local min = math.min(3 + 5 * goal_get_fails, 30)
	local advance_towards_target, var_9_7, var_9_8 = AiUtils.advance_towards_target(arg_9_1, arg_9_2, var_9_1, var_9_2, nil, nil, nil, nil, advance_towards_players.direction, min, min)

	if not advance_towards_target then
		arg_9_2.move_pos = Vector3Box(advance_towards_target)
		arg_9_2.wanted_distance = var_9_7
		advance_towards_players.direction = var_9_8
		advance_towards_players.goal_get_fails = 0

		return true
	end

	advance_towards_players.goal_get_fails = goal_get_fails + 1
	advance_towards_players.direction = math.sign(advance_towards_players.direction)

	return false
end

BTAdvanceTowardsPlayersAction.start_idle_animation = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	Managers.state.network:anim_event(arg_10_1, "idle")

	arg_10_2.move_state = "idle"
end

BTAdvanceTowardsPlayersAction.start_move_animation = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	Managers.state.network:anim_event(arg_11_1, "move_fwd")

	arg_11_2.move_state = "moving"
end
