-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_critter_nurgling_flee_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCritterNurglingFleeAction = class(BTCritterNurglingFleeAction, BTNode)

BTCritterNurglingFleeAction.init = function (arg_1_0, ...)
	-- function 1
	BTCritterNurglingFleeAction.super.init(arg_1_0, ...)
end

BTCritterNurglingFleeAction.name = "BTCritterNurglingFleeAction"

BTCritterNurglingFleeAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data

	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.run_speed)

	if arg_2_2.move_state ~= "idle" then
		self:start_idle_animation(arg_2_1, arg_2_2)

		arg_2_2.move_state = "idle"
	end
end

BTCritterNurglingFleeAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local conflict = Managers.state.conflict

	if arg_3_4 == "done" then
		conflict:destroy_unit(arg_3_1, arg_3_2, arg_3_4)
	end
end

BTCritterNurglingFleeAction.run = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local action = arg_4_2.action
	local navigation_extension = arg_4_2.navigation_extension

	if not arg_4_2.move_pos then
		local get_random_move_pos = self:get_random_move_pos(arg_4_1, arg_4_2, action)

		arg_4_2.move_pos = Vector3Box(get_random_move_pos)

		navigation_extension:move_to(get_random_move_pos)
	end

	if navigation_extension:number_failed_move_attempts() > 0 then
		arg_4_2.move_pos = nil

		if arg_4_2.move_state ~= "idle" then
			self:start_idle_animation(arg_4_1, arg_4_2)
		end

		return "running"
	end

	if not (not navigation_extension:is_following_path() and arg_4_2.move_state == "moving") then
		self:start_move_animation(arg_4_1, arg_4_2)
	end

	if not self:has_escaped_players(arg_4_1, arg_4_2, action) then
		return "done"
	end

	if not navigation_extension:has_reached_destination() then
		arg_4_2.move_pos = nil
	end

	return "running"
end

BTCritterNurglingFleeAction.start_idle_animation = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	Managers.state.network:anim_event(arg_5_1, "idle")

	arg_5_2.move_state = "idle"
end

BTCritterNurglingFleeAction.has_escaped_players = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local has_escaped_players = arg_6_3.has_escaped_players
	local var_6_1 = POSITION_LOOKUP[arg_6_1]
	local ENEMY_PLAYER_AND_BOT_UNITS = arg_6_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_6_3 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local var_6_4 = POSITION_LOOKUP[var_6_3]

		if Vector3.distance_squared(var_6_1, var_6_4) > has_escaped_players.despawn_distance_sq then
			return true
		end
	end

	return false
end

BTCritterNurglingFleeAction.get_random_move_pos = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local nav_world = arg_7_2.nav_world
	local var_7_1 = POSITION_LOOKUP[arg_7_1]
	local random_point_check = arg_7_3.random_point_check
	local min_random_point_check_dist = random_point_check.min_random_point_check_dist
	local max_random_point_check_dist = random_point_check.max_random_point_check_dist
	local max_tries = random_point_check.max_tries
	local above = random_point_check.above
	local below = random_point_check.below
	local new_random_goal = LocomotionUtils.new_random_goal(nav_world, arg_7_2, var_7_1, min_random_point_check_dist, max_random_point_check_dist, max_tries, nil, above, below)

	new_random_goal = new_random_goal or var_7_1

	return new_random_goal
end

BTCritterNurglingFleeAction.start_move_animation = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	Managers.state.network:anim_event(arg_8_1, "move_fwd")

	arg_8_2.move_state = "moving"
end

BTCritterNurglingFleeAction.start_idle_animation = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	Managers.state.network:anim_event(arg_9_1, "idle")

	arg_9_2.move_state = "idle"
end
