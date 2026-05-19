-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_rat_ogre_walk_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTRatOgreWalkAction = class(BTRatOgreWalkAction, BTNode)

function BTRatOgreWalkAction.init(arg_1_0, ...)
	BTRatOgreWalkAction.super.init(arg_1_0, ...)
end

BTRatOgreWalkAction.name = "BTRatOgreWalkAction"

local var_0_0 = 5

function BTRatOgreWalkAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.wait_for_ogre = false

	local var_2_0 = arg_2_2.navigation_extension
	local var_2_1

	if arg_2_2.patroling then
		var_2_1 = arg_2_2.patrol_goal_pos:unbox()
	else
		arg_2_2.patroling = {}
		var_2_1 = arg_2_0:find_patrol_goal(arg_2_1, arg_2_2, var_0_0)

		if var_2_1 then
			arg_2_2.patrol_goal_pos = Vector3Box(var_2_1)
		end
	end

	if var_2_1 then
		Managers.state.network:anim_event(arg_2_1, "walk_fwd")
		arg_2_2.locomotion_extension:set_rotation_speed(10)
		var_2_0:move_to(var_2_1)
		var_2_0:set_max_speed(arg_2_2.breed.patrol_walk_speed)
	else
		arg_2_2.ratogre_walking = false
	end
end

function BTRatOgreWalkAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_4 == "aborted" then
		arg_3_2.wait_for_ogre = true
	else
		arg_3_2.ratogre_walking = false
	end
end

function BTRatOgreWalkAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.locomotion_extension

	arg_4_0:follow(arg_4_1, arg_4_3, arg_4_4, arg_4_2, var_4_0)

	return "running", "evaluate"
end

local var_0_1 = {}

function BTRatOgreWalkAction.follow(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	if arg_5_4.navigation_extension:number_failed_move_attempts() > 1 then
		arg_5_4.move_state = nil
	end

	local var_5_0 = arg_5_4.navigation_extension
	local var_5_1 = arg_5_4.patrol_goal_pos:unbox() - POSITION_LOOKUP[arg_5_1]

	Vector3.set_z(var_5_1, 0)

	local var_5_2 = Vector3.length(var_5_1)

	if var_5_2 < 1 then
		local var_5_3 = arg_5_0:find_patrol_goal(arg_5_1, arg_5_4, var_0_0)

		arg_5_4.patrol_goal_pos = Vector3Box(var_5_3)

		local var_5_4 = arg_5_4.navigation_extension

		var_5_4:move_to(var_5_3)
		var_5_4:set_max_speed(arg_5_4.breed.patrol_walk_speed)
	end

	QuickDrawer:sphere(arg_5_4.patrol_goal_pos:unbox(), 1.2 + math.sin(arg_5_2 * 7))

	if arg_5_4.move_state ~= "moving" and var_5_2 > 0.5 then
		arg_5_4.move_state = "moving"

		local var_5_5 = arg_5_0._tree_node.action_data
		local var_5_6

		Managers.state.network:anim_event(arg_5_1, var_5_6 or var_5_5.move_anim)
	elseif arg_5_4.move_state ~= "idle" and var_5_2 < 0.2 then
		arg_5_4.move_state = "idle"

		Managers.state.network:anim_event(arg_5_1, "idle")
	end
end

function BTRatOgreWalkAction.find_patrol_goal(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = Managers.state.conflict
	local var_6_1 = var_6_0.main_path_info
	local var_6_2 = var_6_0.main_path_player_info
	local var_6_3 = var_6_1.main_paths
	local var_6_4
	local var_6_5, var_6_6 = MainPathUtils.closest_pos_at_main_path(var_6_3, POSITION_LOOKUP[arg_6_1])

	QuickDrawerStay:sphere(var_6_5, 1.5, Color(0, 100, 255))

	if var_6_1.ahead_unit then
		local var_6_7 = var_6_2[var_6_1.ahead_unit]
		local var_6_8 = var_6_7.path_pos:unbox()
		local var_6_9 = var_6_7.travel_dist

		QuickDrawerStay:sphere(var_6_8, 3, Color(255, 10, 255))

		if var_6_9 < var_6_6 then
			var_6_4 = MainPathUtils.point_on_mainpath(var_6_3, var_6_9 - arg_6_3)
		else
			var_6_4 = MainPathUtils.point_on_mainpath(var_6_3, var_6_9 + arg_6_3)
		end

		QuickDrawerStay:sphere(var_6_4, 2, Color(0, 10, 255))
	end

	return var_6_4
end
