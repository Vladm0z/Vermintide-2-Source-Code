-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_skulk_approach_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSkulkApproachAction = class(BTSkulkApproachAction, BTNode)
BTSkulkApproachAction.name = "BTSkulkApproachAction"

BTSkulkApproachAction.init = function (arg_1_0, ...)
	BTSkulkApproachAction.super.init(arg_1_0, ...)
end

BTSkulkApproachAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data
	local var_2_1 = arg_2_2.target_dist
	local var_2_2 = var_2_1 and math.min(var_2_0.skulk_init_distance, var_2_1) or var_2_0.skulk_init_distance
	local var_2_3 = arg_2_2.skulk_data or {}

	var_2_3.direction = var_2_3.direction or 1 - math.random(0, 1) * 2
	var_2_3.radius = var_2_3.radius or var_2_2
	var_2_3.skulk_around_time = var_2_3.skulk_around_time or 0
	var_2_3.next_random_goal_at_radius = var_2_3.radius
	arg_2_2.skulk_data = var_2_3
	arg_2_2.action = var_2_0

	if arg_2_2.move_state ~= "idle" then
		arg_2_0:idle(arg_2_1, arg_2_2)
	end

	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.run_speed)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if arg_2_2.move_pos then
		local var_2_4 = arg_2_2.move_pos:unbox()

		arg_2_0:move_to(var_2_4, arg_2_1, arg_2_2)
	end

	local var_2_5 = Managers.state.network
	local var_2_6 = var_2_0.tutorial_message_template

	if var_2_6 then
		local var_2_7 = NetworkLookup.tutorials[var_2_6]
		local var_2_8 = NetworkLookup.tutorials[arg_2_2.breed.name]

		var_2_5.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_7, var_2_8)
	end
end

BTSkulkApproachAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.skulk_data.animation_state = nil
	arg_3_2.action = nil

	local var_3_0 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)
	local var_3_1 = arg_3_2.navigation_extension

	var_3_1:set_max_speed(var_3_0)

	if arg_3_4 == "aborted" then
		local var_3_2 = var_3_1:is_following_path()

		if arg_3_2.move_pos and var_3_2 and arg_3_2.move_state == "idle" then
			arg_3_0:start_move_animation(arg_3_1, arg_3_2)
		end
	end
end

local var_0_0 = 0.5

BTSkulkApproachAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	arg_4_0:update_skulk_data(arg_4_1, arg_4_2, arg_4_4)

	local var_4_0 = arg_4_2.navigation_extension
	local var_4_1 = var_4_0:is_following_path()
	local var_4_2 = var_4_0:number_failed_move_attempts()

	if arg_4_2.move_pos and var_4_1 and arg_4_2.move_state == "idle" then
		arg_4_0:start_move_animation(arg_4_1, arg_4_2)
	end

	local var_4_3 = arg_4_2.skulk_data
	local var_4_4 = arg_4_2.action

	if arg_4_0:commit_to_target(arg_4_1, arg_4_2, arg_4_4) then
		var_4_3.radius = var_4_4.skulk_init_distance

		return "done"
	end

	if arg_4_2.move_pos then
		if arg_4_0:at_goal(arg_4_1, arg_4_2) or var_4_2 > 0 then
			arg_4_2.move_pos = nil
		end

		return "running"
	end

	if var_4_3.radius <= var_4_3.next_random_goal_at_radius then
		local var_4_5 = arg_4_0:get_random_goal_on_circle(arg_4_1, arg_4_2)

		if var_4_5 then
			arg_4_0:move_to(var_4_5, arg_4_1, arg_4_2)

			return "running"
		end

		var_4_3.next_random_goal_at_radius = var_4_3.radius - var_0_0
	end

	if arg_4_2.move_state ~= "idle" then
		arg_4_0:idle(arg_4_1, arg_4_2)
	end

	return "running"
end

BTSkulkApproachAction.update_skulk_data = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_2.action
	local var_5_1 = var_5_0.skulk_init_distance
	local var_5_2 = arg_5_2.skulk_data
	local var_5_3

	if arg_5_2.move_pos then
		var_5_3 = arg_5_3 * var_5_0.decrease_radius_speed
	else
		var_5_3 = var_0_0
	end

	local var_5_4 = var_5_2.radius - var_5_3

	var_5_2.radius = math.clamp(var_5_4, 0, var_5_1)
	var_5_2.skulk_around_time = var_5_2.skulk_around_time + arg_5_3
end

local var_0_1 = 5

BTSkulkApproachAction.commit_to_target = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_2.action
	local var_6_1 = arg_6_2.previous_attacker

	return arg_6_2.target_dist < var_6_0.commit_distance or var_6_1 or arg_6_2.skulk_data.radius <= var_0_1
end

BTSkulkApproachAction.at_goal = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2.skulk_data
	local var_7_1 = arg_7_2.move_pos

	if not var_7_1 then
		return false
	end

	local var_7_2 = var_7_1:unbox()

	if Vector3.distance_squared(var_7_2, POSITION_LOOKUP[arg_7_1]) < 0.25 then
		return true
	end
end

BTSkulkApproachAction.move_to = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_3.skulk_data

	arg_8_3.navigation_extension:move_to(arg_8_1)

	arg_8_3.move_pos = Vector3Box(arg_8_1)
end

BTSkulkApproachAction.idle = function (arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:anim_event(arg_9_1, arg_9_2, "idle")

	arg_9_2.move_state = "idle"
end

BTSkulkApproachAction.start_move_animation = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0:anim_event(arg_10_1, arg_10_2, "move_fwd_run")

	arg_10_2.move_state = "moving"
end

BTSkulkApproachAction.anim_event = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_2.skulk_data

	if var_11_0.animation_state ~= arg_11_3 then
		Managers.state.network:anim_event(arg_11_1, arg_11_3)

		var_11_0.animation_state = arg_11_3
	end
end

local var_0_2 = 15

BTSkulkApproachAction.get_random_goal_on_circle = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_2.skulk_data
	local var_12_1 = var_12_0.radius
	local var_12_2 = arg_12_2.target_unit
	local var_12_3 = POSITION_LOOKUP[var_12_2]
	local var_12_4 = POSITION_LOOKUP[arg_12_1]
	local var_12_5 = var_12_0.direction
	local var_12_6 = Vector3.up() * 0.2
	local var_12_7 = var_12_4 - var_12_3
	local var_12_8 = Quaternion.look(var_12_7, Vector3.up())
	local var_12_9 = Quaternion.forward(var_12_8)
	local var_12_10 = Vector3.forward()
	local var_12_11, var_12_12 = AiUtils.get_angle_between_vectors(var_12_9, var_12_10)

	for iter_12_0 = 1, var_0_2 do
		local var_12_13 = (iter_12_0 * 3 + Math.random(0, 3)) * var_12_5

		if iter_12_0 == var_0_2 then
			var_12_13 = 2 * var_12_5
		end

		local var_12_14 = var_12_12 + var_12_13
		local var_12_15 = math.degrees_to_radians(var_12_14)
		local var_12_16 = var_12_1 + Math.random(-1, 0)
		local var_12_17 = Quaternion.axis_angle(Vector3.up(), var_12_15)
		local var_12_18 = var_12_3 + Quaternion.forward(var_12_17) * var_12_16
		local var_12_19 = arg_12_2.nav_world
		local var_12_20, var_12_21 = GwNavQueries.triangle_from_position(var_12_19, var_12_18, 5, 5)

		if var_12_20 then
			var_12_18.z = var_12_21

			if script_data.ai_globadier_behavior then
				QuickDrawerStay:sphere(var_12_18 + var_12_6, 0.25, Colors.get("aqua_marine"))
			end

			arg_12_2.wanted_distance = var_12_16

			return var_12_18
		elseif script_data.ai_globadier_behavior then
			QuickDrawerStay:sphere(var_12_18 + var_12_6, 0.25, Colors.get_color_with_alpha("aqua_marine", 100))
		end
	end

	return false
end

BTSkulkApproachAction.debug_show_skulk_circle = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_2.action.skulk_init_distance
	local var_13_1 = arg_13_2.skulk_data.radius
	local var_13_2 = arg_13_2.target_unit
	local var_13_3 = POSITION_LOOKUP[var_13_2]
	local var_13_4 = Vector3.up() * 0.2

	QuickDrawer:circle(var_13_3 + var_13_4, var_13_1, Vector3.up(), Colors.get("light_green"))
	QuickDrawer:circle(var_13_3 + var_13_4, var_13_0, Vector3.up(), Colors.get("light_green"))
end
