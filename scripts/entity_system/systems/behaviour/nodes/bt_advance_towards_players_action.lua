-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_advance_towards_players_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTAdvanceTowardsPlayersAction = class(BTAdvanceTowardsPlayersAction, BTNode)
BTAdvanceTowardsPlayersAction.name = "BTAdvanceTowardsPlayersAction"

function BTAdvanceTowardsPlayersAction.init(arg_1_0, ...)
	BTAdvanceTowardsPlayersAction.super.init(arg_1_0, ...)
end

local var_0_0 = 1

function BTAdvanceTowardsPlayersAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0

	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	local var_2_1 = arg_2_2.has_thrown and var_2_0.throw_at_distance or var_2_0.throw_at_distance_first_time
	local var_2_2 = arg_2_2.advance_towards_players or {}

	var_2_2.timer = var_2_2.timer or 0
	var_2_2.time_before_throw_timer = 0
	var_2_2.evaluate_timer = var_0_0
	var_2_2.direction = var_2_2.direction or 1 - math.random(0, 1) * 2
	var_2_2.time_until_first_throw = AiUtils.random(var_2_0.time_until_first_throw[1], var_2_0.time_until_first_throw[2])
	var_2_2.throw_at_distance = AiUtils.random(var_2_1[1], var_2_1[2])
	var_2_2.goal_get_fails = var_2_2.goal_get_fails or 0
	arg_2_2.advance_towards_players = var_2_2

	if arg_2_2.move_state ~= "idle" then
		arg_2_0:start_idle_animation(arg_2_1, arg_2_2)
	end

	local var_2_3 = arg_2_2.navigation_extension

	var_2_3:set_max_speed(arg_2_2.breed.walk_speed)

	if arg_2_2.move_pos then
		local var_2_4 = arg_2_2.move_pos:unbox()

		var_2_3:move_to(var_2_4)
	end

	local var_2_5 = var_2_0.tutorial_message_template

	if var_2_5 then
		local var_2_6 = NetworkLookup.tutorials[var_2_5]
		local var_2_7 = NetworkLookup.tutorials[arg_2_2.breed.name]

		Managers.state.network.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_6, var_2_7)
	end
end

function BTAdvanceTowardsPlayersAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.action = nil

	local var_3_0 = arg_3_2.navigation_extension

	if arg_3_4 == "aborted" then
		local var_3_1 = var_3_0:is_following_path()

		if arg_3_2.move_pos and var_3_1 and arg_3_2.move_state == "idle" then
			arg_3_0:start_move_animation(arg_3_1, arg_3_2)
		end

		arg_3_2.move_pos = nil
	end

	local var_3_2 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	var_3_0:set_max_speed(var_3_2)
end

function BTAdvanceTowardsPlayersAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.navigation_extension
	local var_4_1 = arg_4_2.breed
	local var_4_2 = arg_4_2.action
	local var_4_3 = arg_4_2.advance_towards_players

	var_4_3.evaluate_timer = arg_4_2.times_thrown ~= 0 and 0 or var_4_3.evaluate_timer - arg_4_4
	var_4_3.timer = var_4_3.timer + arg_4_4
	var_4_3.time_before_throw_timer = var_4_3.time_before_throw_timer + arg_4_4

	local var_4_4 = var_4_0:number_failed_move_attempts()
	local var_4_5 = var_4_0:is_following_path()

	if not arg_4_2.move_pos or var_4_4 > 0 then
		if not arg_4_0:get_new_goal(arg_4_1, arg_4_2) then
			return "failed"
		end

		local var_4_6 = arg_4_2.move_pos:unbox()

		var_4_0:move_to(var_4_6)

		return "running"
	end

	if arg_4_2.move_pos and var_4_5 and arg_4_2.move_state == "idle" then
		arg_4_0:start_move_animation(arg_4_1, arg_4_2)
	end

	arg_4_2.locomotion_extension:set_wanted_rotation(nil)

	local var_4_7 = arg_4_2.move_pos:unbox()
	local var_4_8 = arg_4_2.target_unit

	if Vector3.distance_squared(var_4_7, POSITION_LOOKUP[arg_4_1]) < 0.25 then
		arg_4_2.move_pos = nil
	end

	if var_4_3.evaluate_timer > 0 then
		return "running"
	end

	if arg_4_2.target_dist > var_4_2.exit_to_skulk_distance then
		arg_4_2.skulk_data.radius = arg_4_2.target_dist

		return "failed"
	end

	if not arg_4_0:want_to_throw(arg_4_1, arg_4_2, arg_4_3) then
		var_4_3.evaluate_timer = var_0_0

		return "running"
	end

	local var_4_9 = arg_4_0:can_throw(arg_4_1, arg_4_2, arg_4_3)

	if arg_4_0:has_valid_target(var_4_8, arg_4_2) and var_4_9 and arg_4_0:_calculate_trajectory_to_target(arg_4_1, arg_4_2.world, arg_4_2, var_4_2) then
		arg_4_2.has_thrown = true
		arg_4_2.move_pos = nil

		return "done"
	end

	var_4_3.evaluate_timer = var_0_0

	return "running"
end

function BTAdvanceTowardsPlayersAction._calculate_trajectory_to_target(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = Vector3.copy(POSITION_LOOKUP[arg_5_1])
	local var_5_1 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_3.target_unit)
	local var_5_2, var_5_3, var_5_4 = unpack(arg_5_4.attack_throw_offset)
	local var_5_5 = Vector3(var_5_2, var_5_3, var_5_4)
	local var_5_6 = var_5_0 + Quaternion.rotate(var_5_1, var_5_5)

	var_5_0.z = var_5_6.z

	local var_5_7 = var_5_6 - var_5_0
	local var_5_8 = Vector3.normalize(var_5_7)
	local var_5_9 = Vector3.length(var_5_7)
	local var_5_10 = World.get_data(arg_5_2, "physics_world")

	if PhysicsWorld.immediate_raycast(var_5_10, var_5_0, var_5_8, var_5_9, "closest", "collision_filter", "filter_enemy_ray_projectile") then
		return false
	end

	local var_5_11 = arg_5_4.radius - 1
	local var_5_12 = arg_5_4.range
	local var_5_13 = PerceptionUtils.pick_area_target(arg_5_1, arg_5_3, nil, var_5_11, var_5_12)
	local var_5_14 = Vector3.normalize(var_5_13 - var_5_6)
	local var_5_15, var_5_16, var_5_17 = WeaponHelper:calculate_trajectory(arg_5_2, var_5_6, var_5_13, ProjectileGravitySettings.default, arg_5_3.breed.max_globe_throw_speed)

	if var_5_15 then
		arg_5_3.throw_globe_data = arg_5_3.throw_globe_data or {
			throw_pos = Vector3Box(),
			target_direction = Vector3Box()
		}
		arg_5_3.throw_globe_data.angle = var_5_16
		arg_5_3.throw_globe_data.speed = var_5_17

		arg_5_3.throw_globe_data.throw_pos:store(var_5_6)
		arg_5_3.throw_globe_data.target_direction:store(var_5_14)
	end

	return var_5_15
end

function BTAdvanceTowardsPlayersAction.has_valid_target(arg_6_0, arg_6_1, arg_6_2)
	return arg_6_2.side.VALID_ENEMY_TARGETS_PLAYERS_AND_BOTS[arg_6_1]
end

function BTAdvanceTowardsPlayersAction.want_to_throw(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_2.action
	local var_7_1 = arg_7_2.total_slots_count
	local var_7_2 = arg_7_2.advance_towards_players

	if var_7_2.time_until_first_throw + var_7_0.slot_count_time_modifier * var_7_1 > var_7_2.timer then
		return false
	end

	local var_7_3 = arg_7_2.throw_globe_data

	if var_7_3 and var_7_3.next_throw_at and arg_7_2.target_dist < 4 then
		var_7_3.next_throw_at = -math.huge

		return true
	end

	local var_7_4 = var_7_3 and var_7_3.next_throw_at

	if var_7_4 then
		if var_7_4 < arg_7_3 then
			if arg_7_2.target_dist < var_7_0.range then
				return true
			end
		else
			return false
		end
	end

	local var_7_5 = var_7_0.time_before_throw_distance_modifier * var_7_2.time_before_throw_timer
	local var_7_6 = var_7_0.slot_count_distance_modifier * var_7_1

	if var_7_2.throw_at_distance + var_7_6 + var_7_5 < arg_7_2.target_dist then
		return false
	end

	return true
end

function BTAdvanceTowardsPlayersAction.can_throw(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_2.action.ignore_LOS_check_after_first_throw and arg_8_2.has_thrown then
		return true
	end

	local var_8_0 = POSITION_LOOKUP[arg_8_1] + Vector3.up()
	local var_8_1 = POSITION_LOOKUP[arg_8_2.target_unit] + Vector3.up() * 2 - var_8_0
	local var_8_2 = Vector3.normalize(var_8_1)
	local var_8_3 = Vector3.length(var_8_1)
	local var_8_4, var_8_5, var_8_6, var_8_7, var_8_8 = PhysicsWorld.immediate_raycast(World.get_data(arg_8_2.world, "physics_world"), var_8_0, var_8_2, var_8_3, "closest", "collision_filter", "filter_ai_line_of_sight_check")

	return not var_8_4
end

function BTAdvanceTowardsPlayersAction.get_new_goal(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2.action
	local var_9_1 = var_9_0.keep_target_distance[1]
	local var_9_2 = var_9_0.keep_target_distance[2]
	local var_9_3 = arg_9_2.advance_towards_players
	local var_9_4 = var_9_3.goal_get_fails
	local var_9_5 = math.min(3 + 5 * var_9_4, 30)
	local var_9_6, var_9_7, var_9_8 = AiUtils.advance_towards_target(arg_9_1, arg_9_2, var_9_1, var_9_2, nil, nil, nil, nil, var_9_3.direction, var_9_5, var_9_5)

	if var_9_6 then
		arg_9_2.move_pos = Vector3Box(var_9_6)
		arg_9_2.wanted_distance = var_9_7
		var_9_3.direction = var_9_8
		var_9_3.goal_get_fails = 0

		return true
	end

	var_9_3.goal_get_fails = var_9_4 + 1
	var_9_3.direction = math.sign(var_9_3.direction)

	return false
end

function BTAdvanceTowardsPlayersAction.start_idle_animation(arg_10_0, arg_10_1, arg_10_2)
	Managers.state.network:anim_event(arg_10_1, "idle")

	arg_10_2.move_state = "idle"
end

function BTAdvanceTowardsPlayersAction.start_move_animation(arg_11_0, arg_11_1, arg_11_2)
	Managers.state.network:anim_event(arg_11_1, "move_fwd")

	arg_11_2.move_state = "moving"
end
