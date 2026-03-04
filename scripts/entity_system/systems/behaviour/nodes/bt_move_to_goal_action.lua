-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_move_to_goal_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTMoveToGoalAction = class(BTMoveToGoalAction, BTNode)

BTMoveToGoalAction.init = function (arg_1_0, ...)
	BTMoveToGoalAction.super.init(arg_1_0, ...)
end

BTMoveToGoalAction.name = "BTMoveToGoalAction"

BTMoveToGoalAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.time_to_next_evaluate = arg_2_3 + (arg_2_2.action.eval_time or 0.5)
	arg_2_2.time_to_next_friend_alert = arg_2_3 + 0.3

	local var_2_0 = arg_2_2.goal_destination:unbox()

	arg_2_2.navigation_extension:move_to(var_2_0)

	arg_2_2.new_move_to_goal = nil

	local var_2_1 = Managers.state.network
	local var_2_2 = arg_2_2.breed

	if var_2_2.passive_in_patrol == nil or var_2_2.passive_in_patrol and not arg_2_2.ignore_passive_on_patrol then
		AiUtils.enter_passive(arg_2_1, arg_2_2)
	else
		AiUtils.enter_combat(arg_2_1, arg_2_2)
	end

	if not var_2_2.dont_wield_weapon_on_patrol and ScriptUnit.has_extension(arg_2_1, "ai_inventory_system") then
		local var_2_3 = var_2_1:unit_game_object_id(arg_2_1)

		var_2_1.network_transmit:send_rpc_all("rpc_ai_inventory_wield", var_2_3, 1)
	end

	local var_2_4 = arg_2_2.action.override_move_speed

	if var_2_4 then
		arg_2_2.navigation_extension:set_max_speed(var_2_4)
	end
end

BTMoveToGoalAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if not arg_3_5 then
		arg_3_0:toggle_start_move_animation_lock(arg_3_1, false, arg_3_2)
	end

	arg_3_2.start_anim_locked = nil
	arg_3_2.anim_cb_rotation_start = nil
	arg_3_2.anim_cb_move = nil
	arg_3_2.start_anim_done = nil
	arg_3_2.skip_move_rotation = nil

	local var_3_0 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(var_3_0)
end

BTMoveToGoalAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if not arg_4_2.start_anim_done then
		if not arg_4_2.start_anim_locked then
			arg_4_0:start_move_animation(arg_4_1, arg_4_2)
		end

		if arg_4_2.anim_cb_rotation_start then
			arg_4_0:start_move_rotation(arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		end

		if arg_4_2.anim_cb_move then
			arg_4_2.anim_cb_move = false
			arg_4_2.move_state = "moving"

			arg_4_0:toggle_start_move_animation_lock(arg_4_1, false, arg_4_2)

			arg_4_2.start_anim_locked = nil
			arg_4_2.start_anim_done = true
		end
	else
		local var_4_0 = false

		if ScriptUnit.has_extension(arg_4_1, "ai_group_system") then
			var_4_0 = ScriptUnit.extension(arg_4_1, "ai_group_system").in_patrol
		end

		local var_4_1 = arg_4_2.action

		if not var_4_0 then
			local var_4_2 = POSITION_LOOKUP[arg_4_1]
			local var_4_3 = arg_4_2.goal_destination:unbox()
			local var_4_4 = Vector3.distance_squared(var_4_2, var_4_3)
			local var_4_5 = var_4_1.goal_margin or 0.75

			if var_4_4 < var_4_5 * var_4_5 then
				arg_4_2.goal_destination = nil
			end
		end

		if var_4_1.move_speed_func then
			var_4_1.move_speed_func(arg_4_1, arg_4_2)
		end
	end

	local var_4_6
	local var_4_7 = arg_4_2.navigation_extension

	if arg_4_3 > arg_4_2.time_to_next_evaluate or var_4_7:has_reached_destination() then
		var_4_6 = "evaluate"
		arg_4_2.time_to_next_evaluate = arg_4_3 + (arg_4_2.action.eval_time or 0.5)
	end

	if arg_4_2.new_move_to_goal then
		if arg_4_2.goal_destination then
			local var_4_8 = arg_4_2.goal_destination:unbox()

			var_4_7:move_to(var_4_8)

			if arg_4_1 == script_data.debug_unit then
				QuickDrawer:sphere(var_4_8, 1, Colors.get("yellow"))
			end
		end

		arg_4_2.new_move_to_goal = nil
	end

	return "running", var_4_6
end

BTMoveToGoalAction.start_move_animation = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:toggle_start_move_animation_lock(arg_5_1, true, arg_5_2)

	local var_5_0 = arg_5_2.breed
	local var_5_1 = var_5_0.passive_in_patrol == nil or var_5_0.passive_in_patrol
	local var_5_2 = "move_start_fwd"
	local var_5_3 = var_5_0.passive_in_patrol_start_anim

	if var_5_1 and var_5_3 then
		arg_5_2.anim_cb_move = true
		var_5_2 = type(var_5_3) == "table" and var_5_3[math.random(1, #var_5_3)] or var_5_3
		arg_5_2.skip_move_rotation = true
	end

	Managers.state.network:anim_event(arg_5_1, var_5_2)

	arg_5_2.move_animation_name = var_5_2
	arg_5_2.start_anim_locked = true
end

BTMoveToGoalAction.start_move_rotation = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if arg_6_2.move_animation_name == "move_start_fwd" or arg_6_2.skip_move_rotation then
		arg_6_0:toggle_start_move_animation_lock(arg_6_1, false, arg_6_2)
	else
		arg_6_2.anim_cb_rotation_start = false

		local var_6_0 = POSITION_LOOKUP[arg_6_2.target_unit]

		if not var_6_0 and arg_6_2.goal_destination then
			var_6_0 = arg_6_2.goal_destination:unbox()
		end

		local var_6_1 = AiAnimUtils.get_animation_rotation_scale(arg_6_1, var_6_0, arg_6_2.move_animation_name, arg_6_2.action.start_anims_data)

		LocomotionUtils.set_animation_rotation_scale(arg_6_1, var_6_1)
	end
end

BTMoveToGoalAction.toggle_start_move_animation_lock = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_3.locomotion_extension

	if not var_7_0._engine_extension_id then
		return
	end

	if arg_7_2 then
		var_7_0:use_lerp_rotation(false)
		LocomotionUtils.set_animation_driven_movement(arg_7_1, true, false, false)
	else
		var_7_0:use_lerp_rotation(true)
		LocomotionUtils.set_animation_driven_movement(arg_7_1, false)
		LocomotionUtils.set_animation_rotation_scale(arg_7_1, 1)
	end
end
