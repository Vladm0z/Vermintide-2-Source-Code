-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_critter_nurgling_flee_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCritterNurglingFleeAction = class(BTCritterNurglingFleeAction, BTNode)

BTCritterNurglingFleeAction.init = function (arg_1_0, ...)
	BTCritterNurglingFleeAction.super.init(arg_1_0, ...)
end

BTCritterNurglingFleeAction.name = "BTCritterNurglingFleeAction"

BTCritterNurglingFleeAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data

	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.run_speed)

	if arg_2_2.move_state ~= "idle" then
		arg_2_0:start_idle_animation(arg_2_1, arg_2_2)

		arg_2_2.move_state = "idle"
	end
end

BTCritterNurglingFleeAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = Managers.state.conflict

	if arg_3_4 == "done" then
		var_3_0:destroy_unit(arg_3_1, arg_3_2, arg_3_4)
	end
end

BTCritterNurglingFleeAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_2.action
	local var_4_1 = arg_4_2.navigation_extension

	if not arg_4_2.move_pos then
		local var_4_2 = arg_4_0:get_random_move_pos(arg_4_1, arg_4_2, var_4_0)

		arg_4_2.move_pos = Vector3Box(var_4_2)

		var_4_1:move_to(var_4_2)
	end

	if var_4_1:number_failed_move_attempts() > 0 then
		arg_4_2.move_pos = nil

		if arg_4_2.move_state ~= "idle" then
			arg_4_0:start_idle_animation(arg_4_1, arg_4_2)
		end

		return "running"
	end

	if var_4_1:is_following_path() and arg_4_2.move_state ~= "moving" then
		arg_4_0:start_move_animation(arg_4_1, arg_4_2)
	end

	if arg_4_0:has_escaped_players(arg_4_1, arg_4_2, var_4_0) then
		return "done"
	end

	if var_4_1:has_reached_destination() then
		arg_4_2.move_pos = nil
	end

	return "running"
end

BTCritterNurglingFleeAction.start_idle_animation = function (arg_5_0, arg_5_1, arg_5_2)
	Managers.state.network:anim_event(arg_5_1, "idle")

	arg_5_2.move_state = "idle"
end

BTCritterNurglingFleeAction.has_escaped_players = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_3.has_escaped_players
	local var_6_1 = POSITION_LOOKUP[arg_6_1]
	local var_6_2 = arg_6_2.side.ENEMY_PLAYER_AND_BOT_UNITS

	for iter_6_0 = 1, #var_6_2 do
		local var_6_3 = var_6_2[iter_6_0]
		local var_6_4 = POSITION_LOOKUP[var_6_3]

		if Vector3.distance_squared(var_6_1, var_6_4) > var_6_0.despawn_distance_sq then
			return true
		end
	end

	return false
end

BTCritterNurglingFleeAction.get_random_move_pos = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_2.nav_world
	local var_7_1 = POSITION_LOOKUP[arg_7_1]
	local var_7_2 = arg_7_3.random_point_check
	local var_7_3 = var_7_2.min_random_point_check_dist
	local var_7_4 = var_7_2.max_random_point_check_dist
	local var_7_5 = var_7_2.max_tries
	local var_7_6 = var_7_2.above
	local var_7_7 = var_7_2.below

	return LocomotionUtils.new_random_goal(var_7_0, arg_7_2, var_7_1, var_7_3, var_7_4, var_7_5, nil, var_7_6, var_7_7) or var_7_1
end

BTCritterNurglingFleeAction.start_move_animation = function (arg_8_0, arg_8_1, arg_8_2)
	Managers.state.network:anim_event(arg_8_1, "move_fwd")

	arg_8_2.move_state = "moving"
end

BTCritterNurglingFleeAction.start_idle_animation = function (arg_9_0, arg_9_1, arg_9_2)
	Managers.state.network:anim_event(arg_9_1, "idle")

	arg_9_2.move_state = "idle"
end
