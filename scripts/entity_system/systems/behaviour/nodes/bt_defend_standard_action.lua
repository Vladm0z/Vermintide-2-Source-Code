-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_defend_standard_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTDefendStandardAction = class(BTDefendStandardAction, BTNode)

BTDefendStandardAction.init = function (arg_1_0, ...)
	BTDefendStandardAction.super.init(arg_1_0, ...)
end

BTDefendStandardAction.name = "BTDefendStandardAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

BTDefendStandardAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_2.action = arg_3_0._tree_node.action_data
	arg_3_2.active_node = BTDefendStandardAction

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)

	local var_3_0 = Unit.local_position(arg_3_2.standard_unit, 0)

	arg_3_2.navigation_extension:move_to(var_3_0)

	arg_3_2.standard_position_boxed = Vector3Box(var_3_0)

	Managers.state.network:anim_event(arg_3_1, "move_start_fwd")

	arg_3_2.move_state = "moving"
	arg_3_2.moving_to_defend_standard = true
end

BTDefendStandardAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
	local var_4_1 = arg_4_2.navigation_extension

	var_4_1:set_enabled(true)
	var_4_1:set_max_speed(var_4_0)

	arg_4_2.action = nil
	arg_4_2.active_node = nil
	arg_4_2.moving_to_defend_standard = nil
	arg_4_2.next_move_adjustment_t = nil
	arg_4_2.reached_standard = nil
	arg_4_2.standard_position_boxed = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)

	arg_4_2.move_state = "idle"
end

BTDefendStandardAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if not HEALTH_ALIVE[arg_5_2.standard_unit] then
		return "done"
	end

	local var_5_0 = arg_5_2.standard_position_boxed:unbox()
	local var_5_1 = POSITION_LOOKUP[arg_5_1]

	if Vector3.distance(var_5_0, var_5_1) < 2.5 and not arg_5_2.reached_standard then
		arg_5_2.reached_standard = true

		Managers.state.network:anim_event(arg_5_1, "idle")
		arg_5_0:_enable_navigation(arg_5_2, false)

		arg_5_2.next_move_adjustment_t = arg_5_3 + 1

		arg_5_2.navigation_extension:set_max_speed(arg_5_2.breed.walk_speed)
	end

	if arg_5_2.reached_standard then
		local var_5_2 = arg_5_2.target_unit

		if HEALTH_ALIVE[var_5_2] then
			local var_5_3 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, var_5_2)

			arg_5_2.locomotion_extension:set_wanted_rotation(var_5_3)

			local var_5_4 = arg_5_2.target_distance_to_standard

			if var_5_4 and var_5_4 < arg_5_2.breed.defensive_threshold_distance then
				return "done"
			end

			if arg_5_3 > arg_5_2.next_move_adjustment_t then
				arg_5_0:_adjust_defend_position(arg_5_1, arg_5_2, var_5_2, var_5_1, var_5_0, var_5_3)

				arg_5_2.next_move_adjustment_t = arg_5_3 + 1
			elseif arg_5_2.navigation_extension:has_reached_destination() and not arg_5_2.has_reached_adjustment_position then
				arg_5_0:_enable_navigation(arg_5_2, false)
				Managers.state.network:anim_event(arg_5_1, "idle")

				arg_5_2.has_reached_adjustment_position = true
			end
		end
	end

	return "running"
end

BTDefendStandardAction._adjust_defend_position = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	local var_6_0 = POSITION_LOOKUP[arg_6_3]
	local var_6_1 = arg_6_5 + Vector3.normalize(var_6_0 - arg_6_5) * Math.random_range(1, 1.5)
	local var_6_2 = arg_6_2.nav_world
	local var_6_3 = 1
	local var_6_4 = 1
	local var_6_5, var_6_6 = GwNavQueries.triangle_from_position(var_6_2, var_6_1, var_6_3, var_6_4)
	local var_6_7

	if var_6_5 then
		var_6_7 = Vector3.copy(var_6_1)
		var_6_7.z = var_6_6
	else
		local var_6_8 = 1
		local var_6_9 = 0.05

		var_6_7 = GwNavQueries.inside_position_from_outside_position(var_6_2, var_6_1, var_6_3, var_6_4, var_6_8, var_6_9)
	end

	if var_6_7 and Vector3.distance(arg_6_4, var_6_7) > 1 then
		arg_6_0:_enable_navigation(arg_6_2, true)

		arg_6_2.has_reached_adjustment_position = nil

		arg_6_2.navigation_extension:move_to(var_6_7)

		local var_6_10 = Vector3.normalize(var_6_7 - arg_6_4)
		local var_6_11 = arg_6_0:_calculate_walk_dir(Quaternion.right(arg_6_6), Quaternion.forward(arg_6_6), var_6_10, arg_6_4)
		local var_6_12 = arg_6_0:_calculate_walk_animation(var_6_11)

		Managers.state.network:anim_event(arg_6_1, var_6_12)

		arg_6_2.move_state = "moving"
	end
end

BTDefendStandardAction._enable_navigation = function (arg_7_0, arg_7_1, arg_7_2)
	if arg_7_2 then
		arg_7_1.navigation_extension:set_enabled(true)
	else
		arg_7_1.navigation_extension:set_enabled(false)
		arg_7_1.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))
	end
end

BTDefendStandardAction._calculate_walk_animation = function (arg_8_0, arg_8_1)
	local var_8_0

	return arg_8_1 == "right" and "move_right_walk" or arg_8_1 == "left" and "move_left_walk" or arg_8_1 == "forward" and "move_fwd_walk" or "move_bwd_walk"
end

BTDefendStandardAction._calculate_walk_dir = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = Vector3.dot(arg_9_1, arg_9_3)
	local var_9_1 = Vector3.dot(arg_9_2, arg_9_3)
	local var_9_2 = math.abs(var_9_0)
	local var_9_3 = math.abs(var_9_1)

	arg_9_3 = var_9_3 < var_9_2 and var_9_0 > 0 and "right" or var_9_3 < var_9_2 and "left" or var_9_1 > 0 and "forward" or "backward"

	return arg_9_3
end
