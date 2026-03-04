-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_skulk_around_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterSkulkAroundAction = class(BTPackMasterSkulkAroundAction, BTNode)

function BTPackMasterSkulkAroundAction.init(arg_1_0, ...)
	BTPackMasterSkulkAroundAction.super.init(arg_1_0, ...)

	arg_1_0.navigation_group_manager = Managers.state.conflict.navigation_group_manager
end

BTPackMasterSkulkAroundAction.name = "BTPackMasterSkulkAroundAction"

function BTPackMasterSkulkAroundAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)
	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.run_speed)

	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.skulk_time = arg_2_2.skulk_time or arg_2_3 + var_2_0.skulk_time
	arg_2_2.skulk_time_force_attack = arg_2_2.skulk_time_force_attack or arg_2_3 + var_2_0.skulk_time_force_attack
	arg_2_2.skulk_goal_get_fails = 0
	arg_2_2.skulk_debug_state = "enter"

	arg_2_2.locomotion_extension:set_rotation_speed(5)

	arg_2_2.attack_cooldown = arg_2_2.attack_cooldown or 0
end

function BTPackMasterSkulkAroundAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.action = nil
	arg_3_2.skulk_pos = nil
	arg_3_2.skulk_around_dir = nil
	arg_3_2.skulk_in_los = nil
	arg_3_2.skulk_dogpile = nil
	arg_3_2.skulk_debug_state = nil
	arg_3_2.skulk_goal_get_fails = nil

	if arg_3_4 == "failed" then
		arg_3_2.target_unit = nil
		arg_3_2.skulk_time = nil
		arg_3_2.skulk_time_left = nil
	end

	local var_3_0 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(var_3_0)
end

local var_0_0 = {}

function BTPackMasterSkulkAroundAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if not AiUtils.is_of_interest_to_packmaster(arg_4_1, arg_4_2.target_unit) then
		return "failed"
	end

	local var_4_0 = arg_4_2.locomotion_extension
	local var_4_1 = arg_4_2.breed
	local var_4_2 = POSITION_LOOKUP[arg_4_2.target_unit]

	if script_data.debug_ai_movement then
		arg_4_2.skulk_time_left = string.format("%.2f", arg_4_2.skulk_time - arg_4_3)

		arg_4_0:debug(arg_4_1, arg_4_2)
	end

	if arg_4_3 > arg_4_2.skulk_time and arg_4_3 > arg_4_2.attack_cooldown then
		local var_4_3 = arg_4_2.action
		local var_4_4 = arg_4_3 > arg_4_2.skulk_time_force_attack
		local var_4_5 = Managers.state.entity:system("ai_slot_system"):slots_count(arg_4_2.target_unit)

		if var_4_5 >= var_4_3.dogpile_aggro_needed or script_data.ai_packmaster_ignore_dogpile or var_4_4 then
			arg_4_2.skulk_pos = nil
			arg_4_2.skulk_around_dir = nil

			return "done"
		end

		arg_4_2.skulk_dogpile = var_4_5
		arg_4_2.skulk_time = arg_4_3 + 1
	end

	if not arg_4_2.skulk_pos then
		arg_4_0:get_new_goal(arg_4_1, arg_4_2)

		arg_4_2.skulk_debug_state = "get_new_goal"

		return "running"
	end

	local var_4_6 = arg_4_2.navigation_extension
	local var_4_7 = var_4_6:is_computing_path()

	if arg_4_2.move_state ~= "moving" and not var_4_7 then
		local var_4_8 = Managers.state.network

		arg_4_2.move_state = "moving"

		var_4_8:anim_event(arg_4_1, arg_4_2.action.skulk_animation or "move_fwd")
		var_4_6:set_enabled(true)
	end

	local var_4_9 = arg_4_2.skulk_pos:unbox()
	local var_4_10 = POSITION_LOOKUP[arg_4_1]
	local var_4_11 = Vector3.distance_squared(var_4_9, var_4_10)

	var_4_0:set_wanted_rotation(nil)

	if var_4_11 < 9 then
		if arg_4_0:get_new_goal(arg_4_1, arg_4_2) then
			arg_4_2.skulk_debug_state = "new goal found"
		else
			table.clear(var_0_0)

			local var_4_12 = LocomotionUtils.new_random_goal(arg_4_2.nav_world, arg_4_2, var_4_2, 15, 30, 10, var_0_0)

			if var_4_12 then
				arg_4_2.skulk_debug_state = "fallback"
				arg_4_2.skulk_pos = Vector3Box(var_4_12)

				var_4_6:move_to(var_4_12)
			else
				arg_4_2.skulk_debug_state = "fallback fail"
			end
		end
	end

	if Vector3.distance_squared(var_4_2, var_4_10) < arg_4_2.action.melee_override_distance_sqr and arg_4_3 > arg_4_2.attack_cooldown then
		arg_4_2.skulk_pos = nil
		arg_4_2.skulk_around_dir = nil

		return "done"
	end

	return "running"
end

function BTPackMasterSkulkAroundAction.get_new_goal(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2.target_unit

	if Unit.alive(var_5_0) then
		local var_5_1 = arg_5_2.skulk_goal_get_fails
		local var_5_2
		local var_5_3 = 10
		local var_5_4 = 25
		local var_5_5 = arg_5_2.skulk_around_dir or 1 - math.random(0, 1) * 2

		arg_5_2.skulk_around_dir = var_5_5

		local var_5_6 = math.random(10, 180) * var_5_5
		local var_5_7 = 5 + var_5_1 * 5
		local var_5_8 = LocomotionUtils.outside_goal(arg_5_2.nav_world, POSITION_LOOKUP[arg_5_1], POSITION_LOOKUP[var_5_0], var_5_3, var_5_4, var_5_6, 5, var_5_7, var_5_7)

		if var_5_8 then
			arg_5_2.skulk_goal_get_fails = 0
			arg_5_2.skulk_pos = Vector3Box(var_5_8)

			arg_5_2.navigation_extension:move_to(var_5_8)

			return true
		else
			arg_5_2.skulk_goal_get_fails = var_5_1 + 1
		end
	end
end

function BTPackMasterSkulkAroundAction.debug(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = POSITION_LOOKUP[arg_6_1]

	if arg_6_2.skulk_pos then
		local var_6_1 = arg_6_2.skulk_pos:unbox()

		QuickDrawer:sphere(var_6_1 + Vector3(0, 0, 1), 0.5, Color(255, 144, 43, 207))
		QuickDrawer:sphere(var_6_1 + Vector3(0, 0, 1.5), 0.25, Color(255, 144, 43, 207))
		QuickDrawer:sphere(var_6_1 + Vector3(0, 0, 1.725), 0.125, Color(255, 144, 43, 207))

		if arg_6_2.in_los then
			QuickDrawer:sphere(var_6_1 + Vector3(0, 0, 2), 0.25, Color(255, 144, 43, 43))
		end
	else
		QuickDrawer:sphere(var_6_0 + Vector3(0, 0, 1), 0.5, Color(255, 144, 43, 207))
		QuickDrawer:sphere(var_6_0 + Vector3(0, 0, 1.55), 0.25, Color(255, 144, 43, 207))
		QuickDrawer:sphere(var_6_0 + Vector3(0, 0, 1.725), 0.125, Color(255, 144, 43, 207))
	end

	if not arg_6_2.skulk_in_los then
		QuickDrawer:sphere(var_6_0 + Vector3(0, 0, 2), 0.25, Colors.get("red"))
	end

	for iter_6_0 = 1, #var_0_0 do
		local var_6_2 = var_0_0[iter_6_0]:unbox()

		QuickDrawer:sphere(var_6_2 + Vector3(0, 0, 2), 0.5, Color(255, 43, 43, 207))
	end
end
