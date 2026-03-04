-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_critter_nurgling_roam_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCritterNurglingRoamAction = class(BTCritterNurglingRoamAction, BTNode)

BTCritterNurglingRoamAction.init = function (arg_1_0, ...)
	BTCritterNurglingRoamAction.super.init(arg_1_0, ...)
end

BTCritterNurglingRoamAction.name = "BTCritterNurglingRoamAction"

BTCritterNurglingRoamAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.walk_speed)

	arg_2_2.action = arg_2_0._tree_node.action_data

	arg_2_0:start_idle_animation(arg_2_1, arg_2_2)
end

BTCritterNurglingRoamAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.navigation_extension:set_max_speed(arg_3_2.breed.run_speed)
	arg_3_0:start_idle_animation(arg_3_1, arg_3_2)

	arg_3_2.move_pos = nil
	arg_3_2.idle = nil
	arg_3_2.wait_time = nil
	arg_3_2.action = nil
end

BTCritterNurglingRoamAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_2.action
	local var_4_1 = arg_4_2.navigation_extension

	if not arg_4_2.move_pos then
		local var_4_2 = arg_4_0:find_move_pos(arg_4_2, var_4_0)

		if var_4_2 then
			arg_4_2.move_pos = Vector3Box(var_4_2)

			var_4_1:move_to(var_4_2)
		end
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

	if var_4_1:has_reached_destination() then
		return arg_4_0:try_exit_state(arg_4_1, arg_4_2, var_4_0, arg_4_3)
	end

	return "running"
end

BTCritterNurglingRoamAction.find_move_pos = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = Managers.state.entity:system("ai_system"):nav_world()
	local var_5_1 = arg_5_2.find_move_pos
	local var_5_2 = arg_5_1.altar_pos:unbox()

	return ConflictUtils.get_spawn_pos_on_circle(var_5_0, var_5_2, var_5_1.radius, var_5_1.spread, var_5_1.tries)
end

BTCritterNurglingRoamAction.start_move_animation = function (arg_6_0, arg_6_1, arg_6_2)
	Managers.state.network:anim_event(arg_6_1, "walk")

	arg_6_2.move_state = "moving"
end

BTCritterNurglingRoamAction.start_idle_animation = function (arg_7_0, arg_7_1, arg_7_2)
	Managers.state.network:anim_event(arg_7_1, "idle")

	arg_7_2.move_state = "idle"
end

BTCritterNurglingRoamAction.try_exit_state = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	if arg_8_0:has_overlap(arg_8_1, arg_8_2, arg_8_3) then
		arg_8_2.move_pos = nil

		return "running"
	end

	return "done"
end

local var_0_0 = {}

BTCritterNurglingRoamAction.has_overlap = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if not arg_9_2.move_pos then
		return true
	end

	return Broadphase.query(arg_9_2.group_blackboard.broadphase, arg_9_2.move_pos:unbox(), arg_9_3.check_overlap_radius, var_0_0) > 1
end
