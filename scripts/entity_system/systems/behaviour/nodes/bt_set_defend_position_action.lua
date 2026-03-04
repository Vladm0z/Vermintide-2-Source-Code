-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_set_defend_position_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSetDefendPositionAction = class(BTSetDefendPositionAction, BTNode)

BTSetDefendPositionAction.init = function (arg_1_0, ...)
	BTSetDefendPositionAction.super.init(arg_1_0, ...)
end

BTSetDefendPositionAction.name = "BTSetDefendPositionAction"

BTSetDefendPositionAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data

	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.run_speed)

	arg_2_2.next_check = arg_2_3
end

BTSetDefendPositionAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.defend_get_in_position = nil
end

BTSetDefendPositionAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_3 < arg_4_2.next_check then
		return "running"
	end

	local var_4_0 = arg_4_2.action
	local var_4_1 = arg_4_0:find_move_pos(arg_4_2, var_4_0)

	arg_4_2.next_check = arg_4_3 + var_4_0.function_call_interval

	if not var_4_1 then
		return "running"
	elseif arg_4_0:has_overlap_at_pos(var_4_1, arg_4_2, var_4_0) then
		return "running"
	end

	arg_4_2.goal_destination = Vector3Box(var_4_1)

	return "done"
end

BTSetDefendPositionAction.find_move_pos = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_1.nav_world
	local var_5_1 = arg_5_2.find_move_pos
	local var_5_2 = arg_5_1.destructible_pos:unbox()

	return (ConflictUtils.get_spawn_pos_on_circle(var_5_0, var_5_2, var_5_1.radius, var_5_1.spread, var_5_1.tries, false, nil, nil, var_5_1.max_above, var_5_1.below))
end

local var_0_0 = {}

BTSetDefendPositionAction.has_overlap_at_pos = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_3.has_overlap_at_pos.radius

	return Broadphase.query(arg_6_2.group_blackboard.broadphase, arg_6_1, var_6_0, var_0_0) > 0
end
