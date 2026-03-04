-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_boss_follow_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBossFollowAction = class(BTBossFollowAction, BTNode)

BTBossFollowAction.init = function (arg_1_0, ...)
	BTBossFollowAction.super.init(arg_1_0, ...)
end

BTBossFollowAction.name = "BTBossFollowAction"

BTBossFollowAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.remembered_threat_pos = nil
	arg_2_2.chasing_timer = arg_2_2.unreachable_timer or 0
	arg_2_2.follow_data = arg_2_2.follow_data or {}

	if arg_2_2.fling_skaven_timer and arg_2_3 > arg_2_2.fling_skaven_timer then
		arg_2_2.fling_skaven_timer = arg_2_3 + 0.5
	end

	local var_2_1 = var_2_0.tutorial_message_template

	if var_2_1 then
		local var_2_2 = NetworkLookup.tutorials[var_2_1]
		local var_2_3 = NetworkLookup.tutorials[arg_2_2.breed.name]

		Managers.state.network.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_2, var_2_3)
	end

	arg_2_2.boss_follow_next_line_of_sight_check_t = arg_2_3
end

BTBossFollowAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
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
	arg_3_2.has_los_to_any_player = nil
	arg_3_2.boss_follow_next_line_of_sight_check_t = nil
end

BTBossFollowAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.locomotion_extension

	arg_4_0:follow(arg_4_1, arg_4_3, arg_4_4, arg_4_2, var_4_0)

	arg_4_2.chasing_timer = arg_4_2.chasing_timer + arg_4_4

	return "running", "evaluate"
end

BTBossFollowAction._go_idle = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	arg_5_2.move_state = "idle"

	if arg_5_3:is_following_path() then
		arg_5_3:stop()
	end

	local var_5_0 = arg_5_2.action

	Managers.state.network:anim_event(arg_5_1, var_5_0.idle_anim or "idle")

	local var_5_1 = arg_5_2.target_unit

	if var_5_1 then
		local var_5_2 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, var_5_1)

		arg_5_4:set_wanted_rotation(var_5_2)
	end
end

BTBossFollowAction._go_moving = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_2.move_state = "moving"

	Managers.state.network:anim_event(arg_6_1, arg_6_3.move_anim)
end

BTBossFollowAction.follow = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_4.navigation_extension

	if var_7_0:number_failed_move_attempts() > 1 then
		arg_7_4.remembered_threat_pos = false

		if arg_7_4.move_state ~= "idle" then
			arg_7_0:_go_idle(arg_7_1, arg_7_4, var_7_0, arg_7_5)
		end
	end

	local var_7_1 = arg_7_4.breed

	if var_7_1.use_big_boy_turning and arg_7_4.move_state == "moving" then
		if arg_7_4.is_turning then
			LocomotionUtils.update_turning(arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		else
			LocomotionUtils.check_start_turning(arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		end
	end

	local var_7_2 = arg_7_4.action
	local var_7_3 = arg_7_0[var_7_2.follow_target_function_name](arg_7_0, arg_7_1, arg_7_4, arg_7_2, arg_7_3)

	if var_7_3 then
		arg_7_4.wanted_destination = Vector3Box(var_7_3)
	end

	if arg_7_4.fling_skaven_timer and arg_7_2 > arg_7_4.fling_skaven_timer then
		arg_7_4.fling_skaven_timer = arg_7_2 + 0.5

		arg_7_0:check_fling_skaven(arg_7_1, arg_7_4, arg_7_2)
	end

	local var_7_4 = var_7_0:destination() - POSITION_LOOKUP[arg_7_1]

	Vector3.set_z(var_7_4, 0)

	local var_7_5 = Vector3.length_squared(var_7_4)

	if arg_7_2 > arg_7_4.boss_follow_next_line_of_sight_check_t then
		arg_7_4.has_los_to_any_player = PerceptionUtils.has_line_of_sight_to_any_player(arg_7_1)
		arg_7_4.boss_follow_next_line_of_sight_check_t = arg_7_2 + 2.5
	end

	if var_7_2.override_move_speed then
		if var_7_1.catch_up_speed and var_7_5 > 1600 and not arg_7_4.has_los_to_any_player then
			var_7_0:set_max_speed(var_7_1.catch_up_speed)
		else
			var_7_0:set_max_speed(var_7_2.override_move_speed)
		end
	elseif var_7_5 < 1 then
		var_7_0:set_max_speed(var_7_1.walk_speed)
	elseif var_7_1.catch_up_speed and var_7_5 > 1600 and not arg_7_4.has_los_to_any_player then
		var_7_0:set_max_speed(var_7_1.catch_up_speed)
	elseif var_7_5 > 4 then
		var_7_0:set_max_speed(var_7_1.run_speed)
	end

	local var_7_6 = var_7_0:is_following_path()

	if arg_7_4.move_state ~= "moving" and var_7_6 and var_7_5 > 0.25 then
		arg_7_0:_go_moving(arg_7_1, arg_7_4, var_7_2)
	elseif arg_7_4.move_state ~= "idle" and (not var_7_6 or var_7_5 < 0.04000000000000001) then
		arg_7_0:_go_idle(arg_7_1, arg_7_4, var_7_0, arg_7_5)
	end

	if not arg_7_4.animation_rotation_lock then
		if arg_7_4.target_outside_navmesh then
			local var_7_7 = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, arg_7_4.target_unit)

			arg_7_5:set_wanted_rotation(var_7_7)
		else
			arg_7_5:set_wanted_rotation(nil)
		end
	end
end

local var_0_0 = {}

BTBossFollowAction.check_fling_skaven = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = Quaternion.forward(Unit.local_rotation(arg_8_1, 0))
	local var_8_1 = POSITION_LOOKUP[arg_8_1] + var_8_0 * 2.6
	local var_8_2 = Managers.state.entity:system("ai_system")
	local var_8_3 = Broadphase.query(var_8_2.broadphase, var_8_1, 1, var_0_0)

	if var_8_3 > 0 then
		local var_8_4 = BLACKBOARDS

		for iter_8_0 = 1, var_8_3 do
			local var_8_5 = var_0_0[iter_8_0]
			local var_8_6 = var_8_4[var_8_5]
			local var_8_7 = var_8_6 and var_8_6.breed

			if var_8_7 and var_8_7.flingable and HEALTH_ALIVE[var_8_5] then
				arg_8_2.fling_skaven = true
				arg_8_2.fling_skaven_timer = arg_8_3 + 5

				break
			end
		end
	end
end

BTBossFollowAction._follow_target_rat_ogre = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	return LocomotionUtils.follow_target_ogre(arg_9_1, arg_9_2, arg_9_3, arg_9_4)
end

local var_0_1 = 25
local var_0_2 = 0.25

BTBossFollowAction._follow_target_stormfiend = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_2.nav_world
	local var_10_1 = arg_10_2.action.follow_target_function_data
	local var_10_2 = var_10_1.check_distance
	local var_10_3 = arg_10_2.target_dist
	local var_10_4 = arg_10_2.navigation_extension
	local var_10_5 = var_10_4:has_reached_destination(0.5)
	local var_10_6
	local var_10_7 = POSITION_LOOKUP[arg_10_1]
	local var_10_8 = arg_10_2.target_unit
	local var_10_9 = POSITION_LOOKUP[var_10_8]

	if var_10_1.check_ray_can_go_to_target then
		arg_10_2.ray_can_go_to_target = LocomotionUtils.ray_can_go_on_mesh(var_10_0, var_10_7, var_10_9, nil, 1, 1)
	end

	local var_10_10 = arg_10_2.follow_data
	local var_10_11
	local var_10_12

	if var_10_10.remembered_target_position then
		local var_10_13 = var_10_10.remembered_target_position:unbox()

		var_10_12 = Vector3.distance_squared(var_10_9, var_10_13) > var_0_1
	else
		var_10_10.remembered_target_position = Vector3Box(var_10_9)

		local var_10_14 = var_10_9

		var_10_12 = false
	end

	if var_10_5 and (var_10_2 < var_10_3 or arg_10_2.find_new_shoot_position) or not var_10_5 and var_10_12 then
		local var_10_15 = var_10_10.min_angle or 0
		local var_10_16 = var_10_1.min_angle_step
		local var_10_17 = var_10_1.max_angle_step
		local var_10_18 = var_10_10.min_distance or var_10_1.min_wanted_distance
		local var_10_19 = var_10_10.max_distance or var_10_1.max_wanted_distance

		if arg_10_2.find_new_shoot_position then
			arg_10_2.find_new_shoot_position = nil
			var_10_15 = var_10_15 + var_10_1.failed_move_attempt_angle_increment

			if var_10_15 >= 360 then
				var_10_15 = var_10_15 - 360
				var_10_18 = var_10_18 * 0.8
				var_10_19 = var_10_19 * 0.8
			end
		end

		if var_10_19 < 1 then
			local var_10_20 = 2
			local var_10_21 = 2

			var_10_6 = LocomotionUtils.pos_on_mesh(var_10_0, var_10_9, var_10_20, var_10_21)

			if var_10_6 == nil then
				arg_10_2.target_outside_navmesh = true
			end
		else
			var_10_6 = AiUtils.advance_towards_target(arg_10_1, arg_10_2, var_10_18, var_10_19, var_10_16, var_10_17, var_10_15)
		end

		local var_10_22 = var_10_6 and Vector3.distance_squared(var_10_7, var_10_6)

		if var_10_6 and var_10_22 > var_0_2 then
			var_10_4:move_to(var_10_6)

			var_10_10.min_angle = 0
			var_10_10.min_distance = var_10_1.min_wanted_distance
			var_10_10.max_distance = var_10_1.max_wanted_distance

			var_10_10.remembered_target_position:store(var_10_9)
		else
			arg_10_2.find_new_shoot_position = true
			var_10_10.min_angle = var_10_15
			var_10_10.min_distance = var_10_18
			var_10_10.max_distance = var_10_19
		end
	end

	return var_10_6
end

BTBossFollowAction._follow_target_chaos_spawn = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	return LocomotionUtils.follow_target_ogre(arg_11_1, arg_11_2, arg_11_3, arg_11_4)
end

BTBossFollowAction._debug_big_boy_turning = function (arg_12_0, arg_12_1)
	if script_data.debug_ai_movement then
		local var_12_0 = arg_12_1.is_turning and "true" or "false"

		Debug.text("move_state:%s turning:%s", arg_12_1.move_state, var_12_0)
	end
end
