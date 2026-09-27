-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_boss_follow_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBossFollowAction = class(BTBossFollowAction, BTNode)

BTBossFollowAction.init = function (arg_1_0, ...)
	-- function 1
	BTBossFollowAction.super.init(arg_1_0, ...)
end

BTBossFollowAction.name = "BTBossFollowAction"

BTBossFollowAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.remembered_threat_pos = nil

	local unreachable_timer = arg_2_2.unreachable_timer

	unreachable_timer = unreachable_timer or 0
	arg_2_2.chasing_timer = unreachable_timer

	local follow_data = arg_2_2.follow_data

	follow_data = follow_data or {}
	arg_2_2.follow_data = follow_data

	if not (not arg_2_2.fling_skaven_timer and not (arg_2_3 > arg_2_2.fling_skaven_timer)) then
		arg_2_2.fling_skaven_timer = arg_2_3 + 0.5
	end

	local tutorial_message_template = action_data.tutorial_message_template

	if not tutorial_message_template then
		local var_2_4 = NetworkLookup.tutorials[tutorial_message_template]
		local var_2_5 = NetworkLookup.tutorials[arg_2_2.breed.name]

		Managers.state.network.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_4, var_2_5)
	end

	arg_2_2.boss_follow_next_line_of_sight_check_t = arg_2_3
end

BTBossFollowAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
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
	arg_3_2.has_los_to_any_player = nil
	arg_3_2.boss_follow_next_line_of_sight_check_t = nil
end

BTBossFollowAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local locomotion_extension = arg_4_2.locomotion_extension

	self:follow(arg_4_1, arg_4_3, arg_4_4, arg_4_2, locomotion_extension)

	arg_4_2.chasing_timer = arg_4_2.chasing_timer + arg_4_4

	return "running", "evaluate"
end

BTBossFollowAction._go_idle = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	arg_5_2.move_state = "idle"

	if not arg_5_3:is_following_path() then
		arg_5_3:stop()
	end

	local action = arg_5_2.action
	local network = Managers.state.network
	local var_5_2 = network
	local anim_event = network.anim_event
	local var_5_4 = arg_5_1
	local idle_anim = action.idle_anim

	idle_anim = idle_anim or "idle"

	anim_event(var_5_2, var_5_4, idle_anim)

	local target_unit = arg_5_2.target_unit

	if not target_unit then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, target_unit)

		arg_5_4:set_wanted_rotation(rotation_towards_unit_flat)
	end
end

BTBossFollowAction._go_moving = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	arg_6_2.move_state = "moving"

	Managers.state.network:anim_event(arg_6_1, arg_6_3.move_anim)
end

BTBossFollowAction.follow = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local navigation_extension = arg_7_4.navigation_extension

	if navigation_extension:number_failed_move_attempts() > 1 then
		arg_7_4.remembered_threat_pos = false

		if arg_7_4.move_state ~= "idle" then
			self:_go_idle(arg_7_1, arg_7_4, navigation_extension, arg_7_5)
		end
	end

	local breed = arg_7_4.breed

	if not (not breed.use_big_boy_turning and arg_7_4.move_state ~= "moving") then
		if not arg_7_4.is_turning then
			LocomotionUtils.update_turning(arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		else
			LocomotionUtils.check_start_turning(arg_7_1, arg_7_2, arg_7_3, arg_7_4)
		end
	end

	local action = arg_7_4.action
	local var_7_3 = self[action.follow_target_function_name](self, arg_7_1, arg_7_4, arg_7_2, arg_7_3)

	if not var_7_3 then
		arg_7_4.wanted_destination = Vector3Box(var_7_3)
	end

	if not (not arg_7_4.fling_skaven_timer and not (arg_7_2 > arg_7_4.fling_skaven_timer)) then
		arg_7_4.fling_skaven_timer = arg_7_2 + 0.5

		self:check_fling_skaven(arg_7_1, arg_7_4, arg_7_2)
	end

	local num = navigation_extension:destination() - POSITION_LOOKUP[arg_7_1]

	Vector3.set_z(num, 0)

	local length_squared = Vector3.length_squared(num)

	if arg_7_2 > arg_7_4.boss_follow_next_line_of_sight_check_t then
		arg_7_4.has_los_to_any_player = PerceptionUtils.has_line_of_sight_to_any_player(arg_7_1)
		arg_7_4.boss_follow_next_line_of_sight_check_t = arg_7_2 + 2.5
	end

	if not action.override_move_speed then
		if not (not breed.catch_up_speed and not (length_squared > 1600) or arg_7_4.has_los_to_any_player) then
			navigation_extension:set_max_speed(breed.catch_up_speed)
		else
			navigation_extension:set_max_speed(action.override_move_speed)
		end
	elseif length_squared < 1 then
		navigation_extension:set_max_speed(breed.walk_speed)
	elseif not (not breed.catch_up_speed and not (length_squared > 1600) or arg_7_4.has_los_to_any_player) then
		navigation_extension:set_max_speed(breed.catch_up_speed)
	elseif length_squared > 4 then
		navigation_extension:set_max_speed(breed.run_speed)
	end

	local is_following_path = navigation_extension:is_following_path()

	if not ((arg_7_4.move_state == "moving" or not is_following_path) and not (length_squared > 0.25)) then
		self:_go_moving(arg_7_1, arg_7_4, action)
	elseif not (arg_7_4.move_state == "idle" or not is_following_path or not (length_squared < 0.04000000000000001)) then
		self:_go_idle(arg_7_1, arg_7_4, navigation_extension, arg_7_5)
	end

	if not not arg_7_4.animation_rotation_lock then
		if not arg_7_4.target_outside_navmesh then
			local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_7_1, arg_7_4.target_unit)

			arg_7_5:set_wanted_rotation(rotation_towards_unit_flat)
		else
			arg_7_5:set_wanted_rotation(nil)
		end
	end
end

local tbl = {}

BTBossFollowAction.check_fling_skaven = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local forward = Quaternion.forward(Unit.local_rotation(arg_8_1, 0))
	local num = POSITION_LOOKUP[arg_8_1] + forward * 2.6
	local system = Managers.state.entity:system("ai_system")
	local query = Broadphase.query(system.broadphase, num, 1, tbl)

	if query > 0 then
		local BLACKBOARDS = BLACKBOARDS

		for i = 1, query do
			local var_8_5 = tbl[i]
			local var_8_6 = BLACKBOARDS[var_8_5]
			local flag = not var_8_6 and var_8_6.breed

			if not flag and not flag.flingable and not HEALTH_ALIVE[var_8_5] then
				arg_8_2.fling_skaven = true
				arg_8_2.fling_skaven_timer = arg_8_3 + 5

				break
			end
		end
	end
end

BTBossFollowAction._follow_target_rat_ogre = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	return LocomotionUtils.follow_target_ogre(arg_9_1, arg_9_2, arg_9_3, arg_9_4)
end

local num = 25
local num_2 = 0.25

BTBossFollowAction._follow_target_stormfiend = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local nav_world = arg_10_2.nav_world
	local follow_target_function_data = arg_10_2.action.follow_target_function_data
	local check_distance = follow_target_function_data.check_distance
	local target_dist = arg_10_2.target_dist
	local navigation_extension = arg_10_2.navigation_extension
	local has_reached_destination = navigation_extension:has_reached_destination(0.5)
	local var_10_6
	local var_10_7 = POSITION_LOOKUP[arg_10_1]
	local target_unit = arg_10_2.target_unit
	local var_10_9 = POSITION_LOOKUP[target_unit]

	if not follow_target_function_data.check_ray_can_go_to_target then
		arg_10_2.ray_can_go_to_target = LocomotionUtils.ray_can_go_on_mesh(nav_world, var_10_7, var_10_9, nil, 1, 1)
	end

	local follow_data = arg_10_2.follow_data
	local var_10_11
	local var_10_12

	if not follow_data.remembered_target_position then
		local unbox = follow_data.remembered_target_position:unbox()

		var_10_12 = Vector3.distance_squared(var_10_9, unbox) > num
	else
		follow_data.remembered_target_position = Vector3Box(var_10_9)

		local var_10_14 = var_10_9

		var_10_12 = false
	end

	if not has_reached_destination and check_distance < target_dist and arg_10_2.find_new_shoot_position and has_reached_destination or not var_10_12 then
		local min_angle = follow_data.min_angle

		min_angle = min_angle or 0

		local min_angle_step = follow_target_function_data.min_angle_step
		local max_angle_step = follow_target_function_data.max_angle_step
		local min_distance = follow_data.min_distance

		min_distance = min_distance or follow_target_function_data.min_wanted_distance

		local max_distance = follow_data.max_distance

		max_distance = max_distance or follow_target_function_data.max_wanted_distance

		if not arg_10_2.find_new_shoot_position then
			arg_10_2.find_new_shoot_position = nil
			min_angle = min_angle + follow_target_function_data.failed_move_attempt_angle_increment

			if min_angle >= 360 then
				min_angle = min_angle - 360
				min_distance = min_distance * 0.8
				max_distance = max_distance * 0.8
			end
		end

		if max_distance < 1 then
			local num_3 = 2
			local num_4 = 2

			var_10_6 = LocomotionUtils.pos_on_mesh(nav_world, var_10_9, num_3, num_4)

			if var_10_6 == nil then
				arg_10_2.target_outside_navmesh = true
			end
		else
			var_10_6 = AiUtils.advance_towards_target(arg_10_1, arg_10_2, min_distance, max_distance, min_angle_step, max_angle_step, min_angle)
		end

		local flag = not var_10_6 and Vector3.distance_squared(var_10_7, var_10_6)

		if not (not var_10_6 and not (flag > num_2)) then
			navigation_extension:move_to(var_10_6)

			follow_data.min_angle = 0
			follow_data.min_distance = follow_target_function_data.min_wanted_distance
			follow_data.max_distance = follow_target_function_data.max_wanted_distance

			follow_data.remembered_target_position:store(var_10_9)
		else
			arg_10_2.find_new_shoot_position = true
			follow_data.min_angle = min_angle
			follow_data.min_distance = min_distance
			follow_data.max_distance = max_distance
		end
	end

	return var_10_6
end

BTBossFollowAction._follow_target_chaos_spawn = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	return LocomotionUtils.follow_target_ogre(arg_11_1, arg_11_2, arg_11_3, arg_11_4)
end

BTBossFollowAction._debug_big_boy_turning = function (arg_12_0, arg_12_1)
	-- function 12
	if not script_data.debug_ai_movement then
		local flag

		flag = not arg_12_1.is_turning and "true" and "false"

		Debug.text("move_state:%s turning:%s", arg_12_1.move_state, flag)
	end
end
