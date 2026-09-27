-- chunkname: @scripts/entity_system/systems/behaviour/nodes/skaven_ratling_gunner/bt_ratling_gunner_approach_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTRatlingGunnerApproachAction = class(BTRatlingGunnerApproachAction, BTNode)

BTRatlingGunnerApproachAction.init = function (arg_1_0, ...)
	-- function 1
	BTRatlingGunnerApproachAction.super.init(arg_1_0, ...)
end

BTRatlingGunnerApproachAction.name = "BTRatlingGunnerApproachAction"

BTRatlingGunnerApproachAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data
	local attack_pattern_data = arg_2_2.attack_pattern_data

	attack_pattern_data = attack_pattern_data or {}
	arg_2_2.attack_pattern_data = attack_pattern_data
	arg_2_2.action = action_data

	local lurk_start = arg_2_2.lurk_start

	lurk_start = lurk_start or arg_2_3
	arg_2_2.lurk_start = lurk_start

	local move_speed = action_data.move_speed
	local navigation_extension = arg_2_2.navigation_extension

	navigation_extension:set_max_speed(move_speed)
	navigation_extension:stop()

	if arg_2_2.move_state == "moving" then
		local move_anim = action_data.move_anim

		Managers.state.network:anim_event(arg_2_1, move_anim)
	end

	local tutorial_message_template = action_data.tutorial_message_template

	if not tutorial_message_template then
		local var_2_7 = NetworkLookup.tutorials[tutorial_message_template]
		local var_2_8 = NetworkLookup.tutorials[arg_2_2.breed.name]

		Managers.state.network.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_7, var_2_8)
	end
end

BTRatlingGunnerApproachAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if arg_3_4 ~= "done" then
		arg_3_2.move_pos = nil
	end

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(get_default_breed_move_speed)
end

BTRatlingGunnerApproachAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not self:is_within_check_distance(arg_4_1, arg_4_2) then
		return "done"
	end

	local move_pos = arg_4_2.move_pos
	local flag = not move_pos and arg_4_2.destination_dist < 0.5

	if not move_pos and not flag then
		local calculate_move_position = self:calculate_move_position(arg_4_1, arg_4_2)

		if not calculate_move_position then
			self:move_to(calculate_move_position, arg_4_2)

			return "running"
		else
			return "failed"
		end
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

BTRatlingGunnerApproachAction.is_within_check_distance = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local action = arg_5_2.action
	local previous_attacker = arg_5_2.previous_attacker

	return arg_5_2.target_dist < action.check_distance or previous_attacker
end

BTRatlingGunnerApproachAction.move_to = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	arg_6_2.navigation_extension:move_to(arg_6_1)

	arg_6_2.move_pos = Vector3Box(arg_6_1)
end

BTRatlingGunnerApproachAction.calculate_move_position = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	local action = arg_7_2.action
	local num = action.check_distance - 2
	local check_distance = action.check_distance
	local min_angle_step = action.min_angle_step
	local max_angle_step = action.max_angle_step

	return (AiUtils.advance_towards_target(arg_7_1, arg_7_2, num, check_distance, min_angle_step, max_angle_step))
end
