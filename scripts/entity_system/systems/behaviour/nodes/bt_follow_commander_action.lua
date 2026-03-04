-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_follow_commander_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTFollowCommanderAction = class(BTFollowCommanderAction, BTNode)

function BTFollowCommanderAction.init(arg_1_0, ...)
	BTFollowCommanderAction.super.init(arg_1_0, ...)
end

BTFollowCommanderAction.name = "BTFollowCommanderAction"

function BTFollowCommanderAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.time_to_next_evaluate = arg_2_3 + 0.5
	arg_2_2.time_to_next_friend_alert = arg_2_3 + 0.3

	local var_2_0 = arg_2_2.commander_extension

	var_2_0:register_follow_node_update(arg_2_1)

	arg_2_2.follow_node_position, arg_2_2.commander_extension = var_2_0:follow_node_position(arg_2_1), var_2_0
	arg_2_2.new_follow_node_pos = true

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

	arg_2_2.speed_animation_variable = arg_2_2.speed_animation_variable or Unit.animation_has_variable(arg_2_1, "move_speed") and Unit.animation_find_variable(arg_2_1, "move_speed")
end

function BTFollowCommanderAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if not arg_3_5 then
		arg_3_0:toggle_start_move_animation_lock(arg_3_1, false, arg_3_2)
	end

	if arg_3_2.commander_extension then
		arg_3_2.commander_extension:unregister_follow_node_update(arg_3_1)
	end

	arg_3_2.start_anim_locked = nil
	arg_3_2.anim_cb_rotation_start = nil
	arg_3_2.anim_cb_move = nil
	arg_3_2.start_anim_done = nil
	arg_3_2.skip_move_rotation = nil

	local var_3_0 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(var_3_0)

	if arg_3_2.speed_animation_variable then
		Unit.animation_set_variable(arg_3_1, arg_3_2.speed_animation_variable, var_3_0)

		arg_3_2.speed_animation_variable = nil
	end
end

function BTFollowCommanderAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.navigation_extension

	if arg_4_2.commander_extension:follow_node_pending(arg_4_2) then
		return "running"
	end

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
		local var_4_1 = arg_4_2.follow_node_position:unbox()
		local var_4_2 = POSITION_LOOKUP[arg_4_1]

		if arg_4_2.new_follow_node_pos then
			var_4_0:move_to(var_4_1)

			arg_4_2.new_follow_node_pos = nil
			arg_4_2.finalized_new_follow_node_pos = nil
		end

		if var_4_0:has_reached_destination() then
			arg_4_2.follow_node_position = nil

			return "done"
		end

		local var_4_3 = 0
		local var_4_4 = ScriptUnit.has_extension(arg_4_2.commander_unit, "locomotion_system")

		if var_4_4 then
			var_4_3 = Vector3.length(var_4_4:current_velocity())
		end

		local var_4_5 = Vector3.distance(var_4_2, var_4_1)
		local var_4_6 = math.max(arg_4_2.breed.run_speed, var_4_3)
		local var_4_7 = math.max(arg_4_2.breed.min_run_speed, var_4_3)
		local var_4_8 = arg_4_2.breed.run_max_speed_distance
		local var_4_9 = arg_4_2.breed.run_min_speed_distance
		local var_4_10 = math.lerp(var_4_7, var_4_6, math.clamp01((var_4_5 - var_4_9) / var_4_8))

		var_4_0:set_max_speed(var_4_10)

		if arg_4_2.speed_animation_variable then
			Unit.animation_set_variable(arg_4_1, arg_4_2.speed_animation_variable, var_4_10)
		end
	end

	local var_4_11

	if arg_4_3 > arg_4_2.time_to_next_evaluate or not arg_4_2.new_follow_node_pos and var_4_0:has_reached_destination() then
		var_4_11 = "evaluate"
		arg_4_2.time_to_next_evaluate = arg_4_3 + 0.5
	end

	return "running", var_4_11
end

function BTFollowCommanderAction.start_move_animation(arg_5_0, arg_5_1, arg_5_2)
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

function BTFollowCommanderAction.start_move_rotation(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
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

function BTFollowCommanderAction.toggle_start_move_animation_lock(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
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
