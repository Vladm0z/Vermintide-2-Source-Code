-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_move_to_players_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTMoveToPlayersAction = class(BTMoveToPlayersAction, BTNode)

local var_0_0 = 0.25

BTMoveToPlayersAction.init = function (arg_1_0, ...)
	BTMoveToPlayersAction.super.init(arg_1_0, ...)
end

BTMoveToPlayersAction.name = "BTMoveToPlayersAction"

BTMoveToPlayersAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data

	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if arg_2_2.move_state ~= "idle" then
		arg_2_0:start_idle_animation(arg_2_1, arg_2_2)
	end

	local var_2_0 = arg_2_2.navigation_extension
	local var_2_1 = arg_2_2.breed.walk_speed

	var_2_0:set_max_speed(var_2_1)

	if arg_2_2.move_to_players_position then
		local var_2_2 = arg_2_2.move_to_players_position:unbox()

		var_2_0:move_to(var_2_2)
	end

	local var_2_3 = {}
	local var_2_4 = {
		target_units = var_2_3
	}

	arg_2_2.move_to_players = var_2_4

	arg_2_0:_init_targets(var_2_4, arg_2_3, arg_2_1, arg_2_2)
end

BTMoveToPlayersAction._init_targets = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_1.index = 0
	arg_3_1.eval_timer = arg_3_2 + var_0_0
	arg_3_1.find_move_position_attempts = 0

	local var_3_0 = arg_3_4.side.ENEMY_PLAYER_UNITS

	table.merge(arg_3_1.target_units, var_3_0)
end

BTMoveToPlayersAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.action = nil
	arg_4_2.move_to_players = nil

	local var_4_0 = arg_4_2.navigation_extension

	if arg_4_4 == "aborted" then
		local var_4_1 = var_4_0:is_following_path()

		if arg_4_2.move_to_players_position and var_4_1 and arg_4_2.move_state == "idle" then
			arg_4_0:start_move_animation(arg_4_1, arg_4_2)
		end

		arg_4_2.move_to_players_position = nil
	end

	local var_4_2 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	var_4_0:set_max_speed(var_4_2)
end

BTMoveToPlayersAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_2.navigation_extension
	local var_5_1 = arg_5_2.move_to_players
	local var_5_2 = POSITION_LOOKUP[arg_5_2.target_unit]

	if not arg_5_2.move_to_players_position or Vector3.distance_squared(arg_5_2.move_to_players_position:unbox(), var_5_2) > 9 then
		arg_5_0:_update_move_to_players_position(arg_5_2, var_5_0, var_5_2, var_5_1)

		return "running"
	end

	local var_5_3 = var_5_0:is_following_path()

	if arg_5_2.move_to_players_position and var_5_3 and arg_5_2.move_state == "idle" then
		arg_5_0:start_move_animation(arg_5_1, arg_5_2)
	end

	return (arg_5_0:_evalute_targets(arg_5_1, arg_5_2, var_5_1, arg_5_3))
end

BTMoveToPlayersAction._evalute_targets = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_4 > arg_6_3.eval_timer then
		arg_6_3.eval_timer = arg_6_4 + var_0_0
	else
		return "running"
	end

	local var_6_0 = arg_6_3.index
	local var_6_1

	repeat
		var_6_0 = var_6_0 + 1
		var_6_1 = arg_6_3.target_units[var_6_0]
	until var_6_1 == nil or Unit.alive(var_6_1)

	if not var_6_1 then
		table.clear(arg_6_3.target_units)
		arg_6_0:_init_targets(arg_6_3, arg_6_4, arg_6_1, arg_6_2)

		return "running"
	else
		arg_6_3.index = var_6_0
	end

	local var_6_2 = arg_6_2.action

	return arg_6_0[var_6_2.find_target_function_name](arg_6_0, arg_6_1, arg_6_2, var_6_2, var_6_1, arg_6_4) and "done" or "running"
end

BTMoveToPlayersAction._find_target_globadier = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_2.throw_globe_data

	if var_7_0 and var_7_0.next_throw_at and arg_7_2.target_dist < 4 then
		var_7_0.next_throw_at = -math.huge
	end

	if arg_7_0:_valid_globadier_target(arg_7_4, arg_7_2, arg_7_2.target_dist, arg_7_3) and arg_7_0:_has_line_of_sight(arg_7_1, arg_7_4, arg_7_2.world, arg_7_5) then
		local var_7_1, var_7_2, var_7_3, var_7_4, var_7_5 = arg_7_0:_calculate_trajectory_to_target(arg_7_1, arg_7_2.world, arg_7_4, arg_7_3.attack_throw_offset, arg_7_2.breed.max_globe_throw_speed)

		if var_7_1 then
			arg_7_2.has_thrown = true
			arg_7_2.move_to_players_position = nil

			local var_7_6 = arg_7_2.throw_globe_data or {
				throw_pos = Vector3Box(),
				target_direction = Vector3Box()
			}

			var_7_6.angle = var_7_2
			var_7_6.speed = var_7_3

			var_7_6.throw_pos:store(var_7_4)
			var_7_6.target_direction:store(var_7_5)

			arg_7_2.throw_globe_data = var_7_6

			return true
		end
	end

	return false
end

BTMoveToPlayersAction._find_target_ratling_gunner = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	local var_8_0, var_8_1, var_8_2 = PerceptionUtils.pick_ratling_gun_target(arg_8_1, arg_8_2, nil)

	if var_8_0 then
		local var_8_3 = arg_8_2.attack_pattern_data or {}

		var_8_3.target_unit = var_8_0
		var_8_3.target_node_name = var_8_1
		arg_8_2.attack_pattern_data = var_8_3

		return true
	else
		return false
	end
end

BTMoveToPlayersAction._update_move_to_players_position = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_4.find_move_position_attempts
	local var_9_1 = 0.7 + var_9_0 * 0.2
	local var_9_2 = 2 + var_9_0 * 0.2
	local var_9_3
	local var_9_4 = arg_9_2:traverse_logic()
	local var_9_5 = arg_9_2:nav_world()
	local var_9_6, var_9_7 = GwNavQueries.triangle_from_position(var_9_5, arg_9_3, var_9_1, var_9_2, var_9_4)

	if var_9_6 then
		var_9_3 = Vector3(arg_9_3.x, arg_9_3.y, var_9_7)
	else
		local var_9_8 = 0
		local var_9_9 = var_9_0 * 0.5

		var_9_3 = GwNavQueries.inside_position_from_outside_position(var_9_5, arg_9_3, var_9_2, var_9_1, var_9_9, var_9_8, var_9_4)
	end

	if var_9_3 then
		arg_9_2:move_to(var_9_3)

		local var_9_10 = arg_9_1.move_to_players_position or Vector3Box()

		var_9_10:store(var_9_3)

		arg_9_1.move_to_players_position = var_9_10
		arg_9_4.find_move_position_attempts = 0
	else
		arg_9_4.find_move_position_attempts = var_9_0 + 1
	end
end

BTMoveToPlayersAction._calculate_trajectory_to_target = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = Vector3.copy(POSITION_LOOKUP[arg_10_1])
	local var_10_1 = LocomotionUtils.rotation_towards_unit_flat(arg_10_1, arg_10_3)
	local var_10_2, var_10_3, var_10_4 = unpack(arg_10_4)
	local var_10_5 = Vector3(var_10_2, var_10_3, var_10_4)
	local var_10_6 = var_10_0 + Quaternion.rotate(var_10_1, var_10_5)

	var_10_0.z = var_10_6.z

	local var_10_7 = var_10_6 - var_10_0
	local var_10_8 = Vector3.normalize(var_10_7)
	local var_10_9 = Vector3.length(var_10_7)
	local var_10_10 = World.get_data(arg_10_2, "physics_world")

	if PhysicsWorld.immediate_raycast(var_10_10, var_10_0, var_10_8, var_10_9, "closest", "collision_filter", "filter_enemy_ray_projectile") then
		return false
	end

	local var_10_11 = POSITION_LOOKUP[arg_10_3]
	local var_10_12 = Vector3.normalize(var_10_11 - var_10_6)
	local var_10_13, var_10_14, var_10_15 = WeaponHelper:calculate_trajectory(arg_10_2, var_10_6, var_10_11, ProjectileGravitySettings.default, arg_10_5)

	return var_10_13, var_10_14, var_10_15, var_10_6, var_10_12
end

BTMoveToPlayersAction._valid_globadier_target = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	return arg_11_2.side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_11_1] and arg_11_3 < arg_11_4.attack_distance
end

BTMoveToPlayersAction._has_line_of_sight = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = POSITION_LOOKUP[arg_12_1] + Vector3.up()
	local var_12_1 = POSITION_LOOKUP[arg_12_2] + Vector3.up() * 1.75 - var_12_0
	local var_12_2 = Vector3.normalize(var_12_1)
	local var_12_3 = Vector3.length(var_12_1)
	local var_12_4, var_12_5, var_12_6, var_12_7, var_12_8 = PhysicsWorld.immediate_raycast(World.get_data(arg_12_3, "physics_world"), var_12_0, var_12_2, var_12_3, "closest", "collision_filter", "filter_ai_line_of_sight_check")

	return not var_12_4
end

BTMoveToPlayersAction.start_idle_animation = function (arg_13_0, arg_13_1, arg_13_2)
	Managers.state.network:anim_event(arg_13_1, "idle")

	arg_13_2.move_state = "idle"
end

BTMoveToPlayersAction.start_move_animation = function (arg_14_0, arg_14_1, arg_14_2)
	Managers.state.network:anim_event(arg_14_1, "move_fwd")

	arg_14_2.move_state = "moving"
end
