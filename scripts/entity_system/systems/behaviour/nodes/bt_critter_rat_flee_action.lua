-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_critter_rat_flee_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCritterRatFleeAction = class(BTCritterRatFleeAction, BTNode)

BTCritterRatFleeAction.init = function (arg_1_0, ...)
	-- function 1
	BTCritterRatFleeAction.super.init(arg_1_0, ...)
end

BTCritterRatFleeAction.name = "BTCritterRatFleeAction"

BTCritterRatFleeAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data
	arg_2_2.move_pos = nil
	arg_2_2.using_cover_points = true
	arg_2_2.using_far_along_path_point = false
	arg_2_2.using_random_point_in_front_of_target = false
	arg_2_2.using_random_point = false

	if arg_2_2.move_state ~= "idle" then
		self:start_idle_animation(arg_2_1, arg_2_2)
	end
end

BTCritterRatFleeAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.move_pos = nil
	arg_3_2.move_check_index = nil
	arg_3_2.dig_timer = nil
	arg_3_2.current_check_list = nil
end

BTCritterRatFleeAction.run = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local navigation_extension = arg_4_2.navigation_extension

	if not (not arg_4_2.dig_timer and not (arg_4_3 > arg_4_2.dig_timer)) then
		return "done"
	end

	if not arg_4_2.move_pos then
		local select_move_pos = self:select_move_pos(arg_4_1, arg_4_2)

		navigation_extension:move_to(select_move_pos)

		arg_4_2.move_pos = Vector3Box(select_move_pos)
		arg_4_2.is_fleeing = true

		return "running"
	end

	if not (navigation_extension:number_failed_move_attempts() > 0) then
		arg_4_2.move_pos = nil

		if arg_4_2.move_state ~= "idle" then
			self:start_idle_animation(arg_4_1, arg_4_2)
		end

		return "running"
	end

	local is_following_path = navigation_extension:is_following_path()
	local has_reached_destination = navigation_extension:has_reached_destination()

	if not (not is_following_path and has_reached_destination or arg_4_2.move_state == "moving") then
		self:start_move_animation(arg_4_1, arg_4_2)

		return "running"
	end

	if not has_reached_destination then
		self:at_destination(arg_4_1, arg_4_2, arg_4_3)

		return "running"
	end

	return "running"
end

BTCritterRatFleeAction.select_move_pos = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0

	if not arg_5_2.using_cover_points then
		var_5_0 = self:_get_cover_point_flee_pos(arg_5_1, arg_5_2)
	end

	if not arg_5_2.using_far_along_path_point then
		var_5_0 = self:_get_far_along_path_pos(arg_5_1, arg_5_2)
	end

	if var_5_0 or not arg_5_2.using_random_point_in_front_of_target then
		var_5_0 = self:_get_random_flee_pos_in_front_of_target(arg_5_1, arg_5_2)
	end

	if var_5_0 or not arg_5_2.using_random_point then
		var_5_0 = self:_get_random_flee_pos(arg_5_1, arg_5_2)
	end

	return var_5_0
end

BTCritterRatFleeAction._get_cover_point_flee_pos = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local target_unit = arg_6_2.target_unit
	local var_6_1

	if not Unit.alive(target_unit) then
		local var_6_2 = POSITION_LOOKUP[arg_6_1]
		local var_6_3 = POSITION_LOOKUP[target_unit]
		local cover_point_check = arg_6_2.action.cover_point_check
		local max_height_diff = cover_point_check.max_height_diff

		if not arg_6_2.current_check_list then
			local min_cover_point_check_dist = cover_point_check.min_cover_point_check_dist
			local max_cover_point_check_dist = cover_point_check.max_cover_point_check_dist
			local ENEMY_PLAYER_AND_BOT_POSITIONS = arg_6_2.side.ENEMY_PLAYER_AND_BOT_POSITIONS
			local hidden_cover_points, var_6_10 = ConflictUtils.hidden_cover_points(var_6_2, ENEMY_PLAYER_AND_BOT_POSITIONS, min_cover_point_check_dist, max_cover_point_check_dist)

			arg_6_2.current_check_list = var_6_10

			for i = hidden_cover_points + 1, #var_6_10 do
				var_6_10[i] = nil
			end

			table.shuffle(arg_6_2.current_check_list)
		end

		local move_check_index = arg_6_2.move_check_index

		move_check_index = move_check_index or 1

		for j = move_check_index, #arg_6_2.current_check_list do
			local var_6_12 = arg_6_2.current_check_list[j]
			local local_position = Unit.local_position(var_6_12, 0)
			local flag = Vector3.distance_squared(local_position, var_6_3) > Vector3.distance_squared(local_position, var_6_2)
			local abs = math.abs(var_6_2.z - local_position.z)

			if not (not flag and not (abs < max_height_diff)) then
				var_6_1 = local_position
				arg_6_2.move_check_index = j + 1

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
	-- function 7
	local var_7_0
	local target_unit = arg_7_2.target_unit

	if not Unit.alive(target_unit) then
		local conflict = Managers.state.conflict
		local level_analysis = conflict.level_analysis
		local current_path_index = conflict.main_path_info.current_path_index
		local main_path_next_break, var_7_6, var_7_7 = EngineOptimized.main_path_next_break(current_path_index)
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
	-- function 8
	local var_8_0
	local nav_world = arg_8_2.nav_world
	local var_8_2 = POSITION_LOOKUP[arg_8_1]
	local random_point_in_front_check = arg_8_2.action.random_point_in_front_check
	local min_random_point_in_front_check_dist = random_point_in_front_check.min_random_point_in_front_check_dist
	local max_random_point_in_front_check_dist = random_point_in_front_check.max_random_point_in_front_check_dist
	local max_tries = random_point_in_front_check.max_tries
	local above = random_point_in_front_check.above
	local below = random_point_in_front_check.below
	local min_width = random_point_in_front_check.min_width
	local max_width = random_point_in_front_check.max_width
	local target_unit = arg_8_2.target_unit

	if not Unit.alive(target_unit) then
		var_8_0 = LocomotionUtils.new_random_goal_in_front_of_unit(nav_world, target_unit, min_random_point_in_front_check_dist, max_random_point_in_front_check_dist, max_tries, nil, min_width, max_width, above, below)
	end

	if not var_8_0 then
		-- Nothing
	end

	arg_8_2.using_random_point_in_front_of_target = false
	arg_8_2.using_random_point = true

	return var_8_0
end

BTCritterRatFleeAction._get_random_flee_pos = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	local action = arg_9_2.action
	local nav_world = arg_9_2.nav_world
	local var_9_2 = POSITION_LOOKUP[arg_9_1]
	local random_point_check = action.random_point_check
	local min_random_point_check_dist = random_point_check.min_random_point_check_dist
	local max_random_point_check_dist = random_point_check.max_random_point_check_dist
	local max_tries = random_point_check.max_tries
	local above = random_point_check.above
	local below = random_point_check.below
	local new_random_goal = LocomotionUtils.new_random_goal(nav_world, arg_9_2, var_9_2, min_random_point_check_dist, max_random_point_check_dist, max_tries, nil, above, below)

	new_random_goal = new_random_goal or POSITION_LOOKUP[arg_9_1]

	return new_random_goal
end

BTCritterRatFleeAction.start_idle_animation = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	Managers.state.network:anim_event(arg_10_1, "idle")

	arg_10_2.move_state = "idle"
end

BTCritterRatFleeAction.start_move_animation = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	Managers.state.network:anim_event(arg_11_1, "move_fwd")

	arg_11_2.move_state = "moving"
end

BTCritterRatFleeAction.at_destination = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	if arg_12_2.move_state ~= "idle" then
		self:start_idle_animation(arg_12_1, arg_12_2)
	end

	if not arg_12_2.dig_timer then
		local dig_timer = arg_12_2.action.dig_timer
		local min_time_before_dig = dig_timer.min_time_before_dig
		local max_time_before_dig = dig_timer.max_time_before_dig

		arg_12_2.dig_timer = arg_12_3 + math.random(min_time_before_dig, max_time_before_dig)
	end

	if not BTConditions.can_see_player(arg_12_2) then
		arg_12_2.move_pos = nil
		arg_12_2.using_random_point = false
		arg_12_2.using_cover_points = true
	end
end
