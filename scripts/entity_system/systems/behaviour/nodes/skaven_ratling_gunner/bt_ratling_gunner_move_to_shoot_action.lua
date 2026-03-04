-- chunkname: @scripts/entity_system/systems/behaviour/nodes/skaven_ratling_gunner/bt_ratling_gunner_move_to_shoot_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTRatlingGunnerMoveToShootAction = class(BTRatlingGunnerMoveToShootAction, BTNode)

BTRatlingGunnerMoveToShootAction.init = function (arg_1_0, ...)
	BTRatlingGunnerMoveToShootAction.super.init(arg_1_0, ...)
end

BTRatlingGunnerMoveToShootAction.name = "BTRatlingGunnerMoveToShootAction"

BTRatlingGunnerMoveToShootAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data
	local var_2_1 = {}

	arg_2_2.attack_pattern_data = var_2_1
	arg_2_2.action = var_2_0

	local var_2_2, var_2_3 = PerceptionUtils.pick_ratling_gun_target(arg_2_1, arg_2_2)

	if var_2_2 then
		var_2_1.target_unit = var_2_2
		var_2_1.target_node_name = var_2_3
		var_2_1.exit_node = true

		return
	end

	local var_2_4 = var_2_0.move_speed
	local var_2_5 = arg_2_2.navigation_extension

	var_2_5:set_max_speed(var_2_4)
	var_2_5:stop()

	arg_2_2.move_pos = nil

	Managers.state.network:anim_event(arg_2_1, "idle")

	arg_2_2.move_state = "idle"
	arg_2_2.move_attempts = 0
end

BTRatlingGunnerMoveToShootAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_4 ~= "done" then
		arg_3_2.move_pos = nil
	end

	arg_3_2.move_attempts = nil

	local var_3_0 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(var_3_0)
end

BTRatlingGunnerMoveToShootAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_2.attack_pattern_data.exit_node then
		arg_4_2.attack_pattern_data.exit_node = nil

		return "done"
	end

	local var_4_0 = arg_4_2.move_pos

	if not var_4_0 then
		local var_4_1 = arg_4_0:calculate_move_position(arg_4_1, arg_4_2)

		arg_4_2.move_attempts = arg_4_2.move_attempts or 0
		arg_4_2.move_attempts = arg_4_2.move_attempts + 1

		if var_4_1 then
			arg_4_0:move_to(var_4_1, arg_4_1, arg_4_2)
		elseif arg_4_2.move_attempts > 5 then
			return "failed"
		end

		return "running"
	end

	if var_4_0 and arg_4_2.destination_dist < 0.5 then
		return "done"
	end

	if arg_4_2.no_path_found then
		return "failed"
	end

	local var_4_2 = arg_4_2.is_computing_path

	if arg_4_2.move_state ~= "moving" and not var_4_2 then
		local var_4_3 = arg_4_2.action.move_anim

		Managers.state.network:anim_event(arg_4_1, var_4_3)

		arg_4_2.move_state = "moving"
	end

	return "running"
end

BTRatlingGunnerMoveToShootAction.move_to = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_3.navigation_extension:move_to(arg_5_1)

	arg_5_3.move_pos = Vector3Box(arg_5_1)
end

BTRatlingGunnerMoveToShootAction.calculate_move_position = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.action
	local var_6_1 = var_6_0.keep_target_distance[1]
	local var_6_2 = var_6_0.keep_target_distance[2]
	local var_6_3 = 1
	local var_6_4 = 3
	local var_6_5 = 6

	return (AiUtils.advance_towards_target(arg_6_1, arg_6_2, var_6_1, var_6_2, var_6_3, var_6_4, var_6_5))
end
