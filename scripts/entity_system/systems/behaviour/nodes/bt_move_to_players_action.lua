-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_move_to_players_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTMoveToPlayersAction = class(BTMoveToPlayersAction, BTNode)

local num = 0.25

BTMoveToPlayersAction.init = function (arg_1_0, ...)
	-- function 1
	BTMoveToPlayersAction.super.init(arg_1_0, ...)
end

BTMoveToPlayersAction.name = "BTMoveToPlayersAction"

BTMoveToPlayersAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data

	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if arg_2_2.move_state ~= "idle" then
		self:start_idle_animation(arg_2_1, arg_2_2)
	end

	local navigation_extension = arg_2_2.navigation_extension
	local walk_speed = arg_2_2.breed.walk_speed

	navigation_extension:set_max_speed(walk_speed)

	if not arg_2_2.move_to_players_position then
		local unbox = arg_2_2.move_to_players_position:unbox()

		navigation_extension:move_to(unbox)
	end

	local tbl = {}
	local tbl_2 = {
		target_units = tbl
	}

	arg_2_2.move_to_players = tbl_2

	self:_init_targets(tbl_2, arg_2_3, arg_2_1, arg_2_2)
end

BTMoveToPlayersAction._init_targets = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	arg_3_1.index = 0
	arg_3_1.eval_timer = arg_3_2 + num
	arg_3_1.find_move_position_attempts = 0

	local ENEMY_PLAYER_UNITS = arg_3_4.side.ENEMY_PLAYER_UNITS

	table.merge(arg_3_1.target_units, ENEMY_PLAYER_UNITS)
end

BTMoveToPlayersAction.leave = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.action = nil
	arg_4_2.move_to_players = nil

	local navigation_extension = arg_4_2.navigation_extension

	if arg_4_4 == "aborted" then
		local is_following_path = navigation_extension:is_following_path()

		if not (not arg_4_2.move_to_players_position and not is_following_path and arg_4_2.move_state ~= "idle") then
			self:start_move_animation(arg_4_1, arg_4_2)
		end

		arg_4_2.move_to_players_position = nil
	end

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	navigation_extension:set_max_speed(get_default_breed_move_speed)
end

BTMoveToPlayersAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local navigation_extension = arg_5_2.navigation_extension
	local move_to_players = arg_5_2.move_to_players
	local var_5_2 = POSITION_LOOKUP[arg_5_2.target_unit]

	if not (not arg_5_2.move_to_players_position and not (Vector3.distance_squared(arg_5_2.move_to_players_position:unbox(), var_5_2) > 9)) then
		self:_update_move_to_players_position(arg_5_2, navigation_extension, var_5_2, move_to_players)

		return "running"
	end

	local is_following_path = navigation_extension:is_following_path()

	if not (not arg_5_2.move_to_players_position and not is_following_path and arg_5_2.move_state ~= "idle") then
		self:start_move_animation(arg_5_1, arg_5_2)
	end

	return (self:_evalute_targets(arg_5_1, arg_5_2, move_to_players, arg_5_3))
end

BTMoveToPlayersAction._evalute_targets = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	if not (arg_6_4 > arg_6_3.eval_timer) then
		arg_6_3.eval_timer = arg_6_4 + num
	else
		return "running"
	end

	local index = arg_6_3.index
	local var_6_1

	repeat
		index = index + 1
		var_6_1 = arg_6_3.target_units[index]
	until var_6_1 == nil or not Unit.alive(var_6_1)

	if not var_6_1 then
		table.clear(arg_6_3.target_units)
		self:_init_targets(arg_6_3, arg_6_4, arg_6_1, arg_6_2)

		return "running"
	else
		arg_6_3.index = index
	end

	local action = arg_6_2.action
	local flag

	flag = not self[action.find_target_function_name](self, arg_6_1, arg_6_2, action, var_6_1, arg_6_4) and "done" and "running"

	return flag
end

BTMoveToPlayersAction._find_target_globadier = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local throw_globe_data = arg_7_2.throw_globe_data

	if not (not throw_globe_data and not throw_globe_data.next_throw_at and not (arg_7_2.target_dist < 4)) then
		throw_globe_data.next_throw_at = -math.huge
	end

	if not self:_valid_globadier_target(arg_7_4, arg_7_2, arg_7_2.target_dist, arg_7_3) and not self:_has_line_of_sight(arg_7_1, arg_7_4, arg_7_2.world, arg_7_5) then
		local _calculate_trajectory_to_target, var_7_2, var_7_3, var_7_4, var_7_5 = self:_calculate_trajectory_to_target(arg_7_1, arg_7_2.world, arg_7_4, arg_7_3.attack_throw_offset, arg_7_2.breed.max_globe_throw_speed)

		if not _calculate_trajectory_to_target then
			arg_7_2.has_thrown = true
			arg_7_2.move_to_players_position = nil

			local throw_globe_data_2 = arg_7_2.throw_globe_data

			throw_globe_data_2 = throw_globe_data_2 or {
				throw_pos = Vector3Box(),
				target_direction = Vector3Box()
			}
			throw_globe_data_2.angle = var_7_2
			throw_globe_data_2.speed = var_7_3

			throw_globe_data_2.throw_pos:store(var_7_4)
			throw_globe_data_2.target_direction:store(var_7_5)

			arg_7_2.throw_globe_data = throw_globe_data_2

			return true
		end
	end

	return false
end

BTMoveToPlayersAction._find_target_ratling_gunner = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local pick_ratling_gun_target, var_8_1, var_8_2 = PerceptionUtils.pick_ratling_gun_target(arg_8_1, arg_8_2, nil)

	if not pick_ratling_gun_target then
		local attack_pattern_data = arg_8_2.attack_pattern_data

		attack_pattern_data = attack_pattern_data or {}
		attack_pattern_data.target_unit = pick_ratling_gun_target
		attack_pattern_data.target_node_name = var_8_1
		arg_8_2.attack_pattern_data = attack_pattern_data

		return true
	else
		return false
	end
end

BTMoveToPlayersAction._update_move_to_players_position = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local find_move_position_attempts = arg_9_4.find_move_position_attempts
	local num = 0.7 + find_move_position_attempts * 0.2
	local num_2 = 2 + find_move_position_attempts * 0.2
	local var_9_3
	local traverse_logic = arg_9_2:traverse_logic()
	local nav_world = arg_9_2:nav_world()
	local triangle_from_position, var_9_7 = GwNavQueries.triangle_from_position(nav_world, arg_9_3, num, num_2, traverse_logic)

	if not triangle_from_position then
		var_9_3 = Vector3(arg_9_3.x, arg_9_3.y, var_9_7)
	else
		local num_3 = 0
		local num_4 = find_move_position_attempts * 0.5

		var_9_3 = GwNavQueries.inside_position_from_outside_position(nav_world, arg_9_3, num_2, num, num_4, num_3, traverse_logic)
	end

	if not var_9_3 then
		arg_9_2:move_to(var_9_3)

		local move_to_players_position = arg_9_1.move_to_players_position

		move_to_players_position = move_to_players_position or Vector3Box()

		move_to_players_position:store(var_9_3)

		arg_9_1.move_to_players_position = move_to_players_position
		arg_9_4.find_move_position_attempts = 0
	else
		arg_9_4.find_move_position_attempts = find_move_position_attempts + 1
	end
end

BTMoveToPlayersAction._calculate_trajectory_to_target = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local copy = Vector3.copy(POSITION_LOOKUP[arg_10_1])
	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_10_1, arg_10_3)
	local var_10_2, var_10_3, var_10_4 = unpack(arg_10_4)
	local var_10_5 = Vector3(var_10_2, var_10_3, var_10_4)
	local num = copy + Quaternion.rotate(rotation_towards_unit_flat, var_10_5)

	copy.z = num.z

	local num_2 = num - copy
	local normalize = Vector3.normalize(num_2)
	local length = Vector3.length(num_2)
	local get_data = World.get_data(arg_10_2, "physics_world")

	if not PhysicsWorld.immediate_raycast(get_data, copy, normalize, length, "closest", "collision_filter", "filter_enemy_ray_projectile") then
		return false
	end

	local var_10_11 = POSITION_LOOKUP[arg_10_3]
	local normalize_2 = Vector3.normalize(var_10_11 - num)
	local calculate_trajectory, var_10_14, var_10_15 = WeaponHelper:calculate_trajectory(arg_10_2, num, var_10_11, ProjectileGravitySettings.default, arg_10_5)

	return calculate_trajectory, var_10_14, var_10_15, num, normalize_2
end

BTMoveToPlayersAction._valid_globadier_target = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local var_11_0 = arg_11_2.side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_11_1]

	var_11_0 = not var_11_0 and arg_11_3 < arg_11_4.attack_distance

	return var_11_0
end

BTMoveToPlayersAction._has_line_of_sight = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local num = POSITION_LOOKUP[arg_12_1] + Vector3.up()
	local num_2 = POSITION_LOOKUP[arg_12_2] + Vector3.up() * 1.75 - num
	local normalize = Vector3.normalize(num_2)
	local length = Vector3.length(num_2)
	local immediate_raycast, var_12_5, var_12_6, var_12_7, var_12_8 = PhysicsWorld.immediate_raycast(World.get_data(arg_12_3, "physics_world"), num, normalize, length, "closest", "collision_filter", "filter_ai_line_of_sight_check")

	return not immediate_raycast
end

BTMoveToPlayersAction.start_idle_animation = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	Managers.state.network:anim_event(arg_13_1, "idle")

	arg_13_2.move_state = "idle"
end

BTMoveToPlayersAction.start_move_animation = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	Managers.state.network:anim_event(arg_14_1, "move_fwd")

	arg_14_2.move_state = "moving"
end
