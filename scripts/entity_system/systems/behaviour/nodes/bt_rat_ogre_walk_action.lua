-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_rat_ogre_walk_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTRatOgreWalkAction = class(BTRatOgreWalkAction, BTNode)

BTRatOgreWalkAction.init = function (arg_1_0, ...)
	-- function 1
	BTRatOgreWalkAction.super.init(arg_1_0, ...)
end

BTRatOgreWalkAction.name = "BTRatOgreWalkAction"

local num = 5

BTRatOgreWalkAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data
	arg_2_2.wait_for_ogre = false

	local navigation_extension = arg_2_2.navigation_extension
	local var_2_1

	if not arg_2_2.patroling then
		var_2_1 = arg_2_2.patrol_goal_pos:unbox()
	else
		arg_2_2.patroling = {}
		var_2_1 = self:find_patrol_goal(arg_2_1, arg_2_2, num)

		if not var_2_1 then
			arg_2_2.patrol_goal_pos = Vector3Box(var_2_1)
		end
	end

	if not var_2_1 then
		Managers.state.network:anim_event(arg_2_1, "walk_fwd")
		arg_2_2.locomotion_extension:set_rotation_speed(10)
		navigation_extension:move_to(var_2_1)
		navigation_extension:set_max_speed(arg_2_2.breed.patrol_walk_speed)
	else
		arg_2_2.ratogre_walking = false
	end
end

BTRatOgreWalkAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if arg_3_4 == "aborted" then
		arg_3_2.wait_for_ogre = true
	else
		arg_3_2.ratogre_walking = false
	end
end

BTRatOgreWalkAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local locomotion_extension = arg_4_2.locomotion_extension

	self:follow(arg_4_1, arg_4_3, arg_4_4, arg_4_2, locomotion_extension)

	return "running", "evaluate"
end

local tbl = {}

BTRatOgreWalkAction.follow = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	if arg_5_4.navigation_extension:number_failed_move_attempts() > 1 then
		arg_5_4.move_state = nil
	end

	local navigation_extension = arg_5_4.navigation_extension
	local num_2 = arg_5_4.patrol_goal_pos:unbox() - POSITION_LOOKUP[arg_5_1]

	Vector3.set_z(num_2, 0)

	local length = Vector3.length(num_2)

	if length < 1 then
		local find_patrol_goal = self:find_patrol_goal(arg_5_1, arg_5_4, num)

		arg_5_4.patrol_goal_pos = Vector3Box(find_patrol_goal)

		local navigation_extension_2 = arg_5_4.navigation_extension

		navigation_extension_2:move_to(find_patrol_goal)
		navigation_extension_2:set_max_speed(arg_5_4.breed.patrol_walk_speed)
	end

	QuickDrawer:sphere(arg_5_4.patrol_goal_pos:unbox(), 1.2 + math.sin(arg_5_2 * 7))

	if not (arg_5_4.move_state == "moving" or not (length > 0.5)) then
		arg_5_4.move_state = "moving"

		local action_data = self._tree_node.action_data
		local var_5_6

		Managers.state.network:anim_event(arg_5_1, var_5_6 or action_data.move_anim)
	elseif not (arg_5_4.move_state == "idle" or not (length < 0.2)) then
		arg_5_4.move_state = "idle"

		Managers.state.network:anim_event(arg_5_1, "idle")
	end
end

BTRatOgreWalkAction.find_patrol_goal = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local conflict = Managers.state.conflict
	local main_path_info = conflict.main_path_info
	local main_path_player_info = conflict.main_path_player_info
	local main_paths = main_path_info.main_paths
	local var_6_4
	local closest_pos_at_main_path, var_6_6 = MainPathUtils.closest_pos_at_main_path(main_paths, POSITION_LOOKUP[arg_6_1])

	QuickDrawerStay:sphere(closest_pos_at_main_path, 1.5, Color(0, 100, 255))

	if not main_path_info.ahead_unit then
		local var_6_7 = main_path_player_info[main_path_info.ahead_unit]
		local unbox = var_6_7.path_pos:unbox()
		local travel_dist = var_6_7.travel_dist

		QuickDrawerStay:sphere(unbox, 3, Color(255, 10, 255))

		if travel_dist < var_6_6 then
			var_6_4 = MainPathUtils.point_on_mainpath(main_paths, travel_dist - arg_6_3)
		else
			var_6_4 = MainPathUtils.point_on_mainpath(main_paths, travel_dist + arg_6_3)
		end

		QuickDrawerStay:sphere(var_6_4, 2, Color(0, 10, 255))
	end

	return var_6_4
end
