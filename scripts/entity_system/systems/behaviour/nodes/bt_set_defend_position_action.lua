-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_set_defend_position_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSetDefendPositionAction = class(BTSetDefendPositionAction, BTNode)

BTSetDefendPositionAction.init = function (arg_1_0, ...)
	-- function 1
	BTSetDefendPositionAction.super.init(arg_1_0, ...)
end

BTSetDefendPositionAction.name = "BTSetDefendPositionAction"

BTSetDefendPositionAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data

	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.run_speed)

	arg_2_2.next_check = arg_2_3
end

BTSetDefendPositionAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.defend_get_in_position = nil
end

BTSetDefendPositionAction.run = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if arg_4_3 < arg_4_2.next_check then
		return "running"
	end

	local action = arg_4_2.action
	local find_move_pos = self:find_move_pos(arg_4_2, action)

	arg_4_2.next_check = arg_4_3 + action.function_call_interval

	if not find_move_pos then
		return "running"
	elseif not self:has_overlap_at_pos(find_move_pos, arg_4_2, action) then
		return "running"
	end

	arg_4_2.goal_destination = Vector3Box(find_move_pos)

	return "done"
end

BTSetDefendPositionAction.find_move_pos = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local nav_world = arg_5_1.nav_world
	local find_move_pos = arg_5_2.find_move_pos
	local unbox = arg_5_1.destructible_pos:unbox()

	return (ConflictUtils.get_spawn_pos_on_circle(nav_world, unbox, find_move_pos.radius, find_move_pos.spread, find_move_pos.tries, false, nil, nil, find_move_pos.max_above, find_move_pos.below))
end

local tbl = {}

BTSetDefendPositionAction.has_overlap_at_pos = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local radius = arg_6_3.has_overlap_at_pos.radius

	return Broadphase.query(arg_6_2.group_blackboard.broadphase, arg_6_1, radius, tbl) > 0
end
