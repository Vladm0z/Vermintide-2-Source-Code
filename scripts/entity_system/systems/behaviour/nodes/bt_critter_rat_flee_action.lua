-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_critter_rat_flee_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCritterRatFleeAction = class(BTCritterRatFleeAction, BTNode)

BTCritterRatFleeAction.init = function (arg_1_0, ...)
	BTCritterRatFleeAction.super.init(arg_1_0, ...)
end

BTCritterRatFleeAction.name = "BTCritterRatFleeAction"

BTCritterRatFleeAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.move_pos = nil
	arg_2_2.using_cover_points = true
	arg_2_2.using_far_along_path_point = false
	arg_2_2.using_random_point_in_front_of_target = false
	arg_2_2.using_random_point = false

	if arg_2_2.move_state ~= "idle" then
		arg_2_0:start_idle_animation(arg_2_1, arg_2_2)
	end
end

BTCritterRatFleeAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.move_pos = nil
	arg_3_2.move_check_index = nil
	arg_3_2.dig_timer = nil
	arg_3_2.current_check_list = nil
end

BTCritterRatFleeAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_2.navigation_extension

	if arg_4_2.dig_timer and arg_4_3 > arg_4_2.dig_timer then
		return "done"
	end

	if not arg_4_2.move_pos then
		local var_4_1 = arg_4_0:select_move_pos(arg_4_1, arg_4_2)

		var_4_0:move_to(var_4_1)

		arg_4_2.move_pos = Vector3Box(var_4_1)
		arg_4_2.is_fleeing = true

		return "running"
	end

	if var_4_0:number_failed_move_attempts() > 0 then
		arg_4_2.move_pos = nil

		if arg_4_2.move_state ~= "idle" then
			arg_4_0:start_idle_animation(arg_4_1, arg_4_2)
		end

		return "running"
	end

	local var_4_2 = var_4_0:is_following_path()
	local var_4_3 = var_4_0:has_reached_destination()

	if var_4_2 and not var_4_3 and arg_4_2.move_state ~= "moving" then
		arg_4_0:start_move_animation(arg_4_1, arg_4_2)

		return "running"
	end

	if var_4_3 then
		arg_4_0:at_destination(arg_4_1, arg_4_2, arg_4_3)

		return "running"
	end

	return "running"
end

BTCritterRatFleeAction.select_move_pos = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0

	if arg_5_2.using_cover_points then
		var_5_0 = arg_5_0:_get_cover_point_flee_pos(arg_5_1, arg_5_2)
	end

	if arg_5_2.using_far_along_path_point then
		var_5_0 = arg_5_0:_get_far_along_path_pos(arg_5_1, arg_5_2)
	end

	if not var_5_0 and arg_5_2.using_random_point_in_front_of_target then
		var_5_0 = arg_5_0:_get_random_flee_pos_in_front_of_target(arg_5_1, arg_5_2)
	end

	if not var_5_0 and arg_5_2.using_random_point then
		var_5_0 = arg_5_0:_get_random_flee_pos(arg_5_1, arg_5_2)
	end

	return var_5_0
end

BTCritterRatFleeAction._get_cover_point_flee_pos = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.target_unit
	local var_6_1

	if Unit.alive(var_6_0) then
		local var_6_2 = POSITION_LOOKUP[arg_6_1]
		local var_6_3 = POSITION_LOOKUP[var_6_0]
		local var_6_4 = arg_6_2.action.cover_point_check
		local var_6_5 = var_6_4.max_height_diff

		if not arg_6_2.current_check_list then
			local var_6_6 = var_6_4.min_cover_point_check_dist
			local var_6_7 = var_6_4.max_cover_point_check_dist
			local var_6_8 = arg_6_2.side.ENEMY_PLAYER_AND_BOT_POSITIONS
			local var_6_9, var_6_10 = ConflictUtils.hidden_cover_points(var_6_2, var_6_8, var_6_6, var_6_7)

			arg_6_2.current_check_list = var_6_10

			for iter_6_0 = var_6_9 + 1, #var_6_10 do
				var_6_10[iter_6_0] = nil
			end

			table.shuffle(arg_6_2.current_check_list)
		end

		for iter_6_1 = arg_6_2.move_check_index or 1, #arg_6_2.current_check_list do
			local var_6_11 = arg_6_2.current_check_list[iter_6_1]
			local var_6_12 = Unit.local_position(var_6_11, 0)
			local var_6_13 = Vector3.distance_squared(var_6_12, var_6_3) > Vector3.distance_squared(var_6_12, var_6_2)
			local var_6_14 = math.abs(var_6_2.z - var_6_12.z)

			if var_6_13 and var_6_14 < var_6_5 then
				var_6_1 = var_6_12
				arg_6_2.move_check_index = iter_6_1 + 1

				break
			end
		end
	end

	if not var_6_1 then
		arg_6_2.using_cover_points = false
		arg_6_2.using_far_along_path_point = true
		arg_6_2.move_check_index = nil
		arg_6_2.current_check_list = nil
	end

	return var_6_1
end

BTCritterRatFleeAction._get_far_along_path_pos = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0
	local var_7_1 = arg_7_2.target_unit

	if Unit.alive(var_7_1) then
		local var_7_2 = Managers.state.conflict
		local var_7_3 = var_7_2.level_analysis
		local var_7_4 = var_7_2.main_path_info.current_path_index
		local var_7_5, var_7_6, var_7_7 = EngineOptimized.main_path_next_break(var_7_4)
		local var_7_8 = POSITION_LOOKUP[arg_7_1]

		if Vector3.distance_squared(var_7_8, var_7_7) > arg_7_2.action.min_far_along_path_pos_distance_sq then
			var_7_0 = var_7_7
		end
	end

	arg_7_2.using_far_along_path_point = false
	arg_7_2.using_random_point_in_front_of_target = true

	return var_7_0
end

BTCritterRatFleeAction._get_random_flee_pos_in_front_of_target = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0
	local var_8_1 = arg_8_2.nav_world
	local var_8_2 = POSITION_LOOKUP[arg_8_1]
	local var_8_3 = arg_8_2.action.random_point_in_front_check
	local var_8_4 = var_8_3.min_random_point_in_front_check_dist
	local var_8_5 = var_8_3.max_random_point_in_front_check_dist
	local var_8_6 = var_8_3.max_tries
	local var_8_7 = var_8_3.above
	local var_8_8 = var_8_3.below
	local var_8_9 = var_8_3.min_width
	local var_8_10 = var_8_3.max_width
	local var_8_11 = arg_8_2.target_unit

	if Unit.alive(var_8_11) then
		var_8_0 = LocomotionUtils.new_random_goal_in_front_of_unit(var_8_1, var_8_11, var_8_4, var_8_5, var_8_6, nil, var_8_9, var_8_10, var_8_7, var_8_8)
	end

	if not var_8_0 then
		-- Nothing
	end

	arg_8_2.using_random_point_in_front_of_target = false
	arg_8_2.using_random_point = true

	return var_8_0
end

BTCritterRatFleeAction._get_random_flee_pos = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2.action
	local var_9_1 = arg_9_2.nav_world
	local var_9_2 = POSITION_LOOKUP[arg_9_1]
	local var_9_3 = var_9_0.random_point_check
	local var_9_4 = var_9_3.min_random_point_check_dist
	local var_9_5 = var_9_3.max_random_point_check_dist
	local var_9_6 = var_9_3.max_tries
	local var_9_7 = var_9_3.above
	local var_9_8 = var_9_3.below

	return LocomotionUtils.new_random_goal(var_9_1, arg_9_2, var_9_2, var_9_4, var_9_5, var_9_6, nil, var_9_7, var_9_8) or POSITION_LOOKUP[arg_9_1]
end

BTCritterRatFleeAction.start_idle_animation = function (arg_10_0, arg_10_1, arg_10_2)
	Managers.state.network:anim_event(arg_10_1, "idle")

	arg_10_2.move_state = "idle"
end

BTCritterRatFleeAction.start_move_animation = function (arg_11_0, arg_11_1, arg_11_2)
	Managers.state.network:anim_event(arg_11_1, "move_fwd")

	arg_11_2.move_state = "moving"
end

BTCritterRatFleeAction.at_destination = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	if arg_12_2.move_state ~= "idle" then
		arg_12_0:start_idle_animation(arg_12_1, arg_12_2)
	end

	if not arg_12_2.dig_timer then
		local var_12_0 = arg_12_2.action.dig_timer
		local var_12_1 = var_12_0.min_time_before_dig
		local var_12_2 = var_12_0.max_time_before_dig

		arg_12_2.dig_timer = arg_12_3 + math.random(var_12_1, var_12_2)
	end

	if BTConditions.can_see_player(arg_12_2) then
		arg_12_2.move_pos = nil
		arg_12_2.using_random_point = false
		arg_12_2.using_cover_points = true
	end
end
