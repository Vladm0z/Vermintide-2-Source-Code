-- chunkname: @scripts/entity_system/systems/behaviour/nodes/skaven_ratling_gunner/bt_ratling_gunner_move_to_shoot_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTRatlingGunnerMoveToShootAction = class(BTRatlingGunnerMoveToShootAction, BTNode)

BTRatlingGunnerMoveToShootAction.init = function (arg_1_0, ...)
	-- function 1
	BTRatlingGunnerMoveToShootAction.super.init(arg_1_0, ...)
end

BTRatlingGunnerMoveToShootAction.name = "BTRatlingGunnerMoveToShootAction"

BTRatlingGunnerMoveToShootAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data
	local tbl = {}

	arg_2_2.attack_pattern_data = tbl
	arg_2_2.action = action_data

	local pick_ratling_gun_target, var_2_3 = PerceptionUtils.pick_ratling_gun_target(arg_2_1, arg_2_2)

	if not pick_ratling_gun_target then
		tbl.target_unit = pick_ratling_gun_target
		tbl.target_node_name = var_2_3
		tbl.exit_node = true

		return
	end

	local move_speed = action_data.move_speed
	local navigation_extension = arg_2_2.navigation_extension

	navigation_extension:set_max_speed(move_speed)
	navigation_extension:stop()

	arg_2_2.move_pos = nil

	Managers.state.network:anim_event(arg_2_1, "idle")

	arg_2_2.move_state = "idle"
	arg_2_2.move_attempts = 0
end

BTRatlingGunnerMoveToShootAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if arg_3_4 ~= "done" then
		arg_3_2.move_pos = nil
	end

	arg_3_2.move_attempts = nil

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(get_default_breed_move_speed)
end

BTRatlingGunnerMoveToShootAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not arg_4_2.attack_pattern_data.exit_node then
		arg_4_2.attack_pattern_data.exit_node = nil

		return "done"
	end

	local move_pos = arg_4_2.move_pos

	if not move_pos then
		local calculate_move_position = self:calculate_move_position(arg_4_1, arg_4_2)
		local move_attempts = arg_4_2.move_attempts

		move_attempts = move_attempts or 0
		arg_4_2.move_attempts = move_attempts
		arg_4_2.move_attempts = arg_4_2.move_attempts + 1

		if not calculate_move_position then
			self:move_to(calculate_move_position, arg_4_1, arg_4_2)
		elseif arg_4_2.move_attempts > 5 then
			return "failed"
		end

		return "running"
	end

	if not (not move_pos and arg_4_2.destination_dist < 0.5) then
		return "done"
	end

	if not arg_4_2.no_path_found then
		return "failed"
	end

	local is_computing_path = arg_4_2.is_computing_path

	if not (arg_4_2.move_state == "moving" or is_computing_path) then
		local move_anim = arg_4_2.action.move_anim

		Managers.state.network:anim_event(arg_4_1, move_anim)

		arg_4_2.move_state = "moving"
	end

	return "running"
end

BTRatlingGunnerMoveToShootAction.move_to = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	arg_5_3.navigation_extension:move_to(arg_5_1)

	arg_5_3.move_pos = Vector3Box(arg_5_1)
end

BTRatlingGunnerMoveToShootAction.calculate_move_position = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local action = arg_6_2.action
	local var_6_1 = action.keep_target_distance[1]
	local var_6_2 = action.keep_target_distance[2]
	local num = 1
	local num_2 = 3
	local num_3 = 6

	return (AiUtils.advance_towards_target(arg_6_1, arg_6_2, var_6_1, var_6_2, num, num_2, num_3))
end
