-- chunkname: @scripts/entity_system/systems/behaviour/nodes/skaven_ratling_gunner/bt_ratling_gunner_approach_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTRatlingGunnerApproachAction = class(BTRatlingGunnerApproachAction, BTNode)

function BTRatlingGunnerApproachAction.init(arg_1_0, ...)
	BTRatlingGunnerApproachAction.super.init(arg_1_0, ...)
end

BTRatlingGunnerApproachAction.name = "BTRatlingGunnerApproachAction"

function BTRatlingGunnerApproachAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.attack_pattern_data = arg_2_2.attack_pattern_data or {}
	arg_2_2.action = var_2_0
	arg_2_2.lurk_start = arg_2_2.lurk_start or arg_2_3

	local var_2_1 = var_2_0.move_speed
	local var_2_2 = arg_2_2.navigation_extension

	var_2_2:set_max_speed(var_2_1)
	var_2_2:stop()

	if arg_2_2.move_state == "moving" then
		local var_2_3 = var_2_0.move_anim

		Managers.state.network:anim_event(arg_2_1, var_2_3)
	end

	local var_2_4 = var_2_0.tutorial_message_template

	if var_2_4 then
		local var_2_5 = NetworkLookup.tutorials[var_2_4]
		local var_2_6 = NetworkLookup.tutorials[arg_2_2.breed.name]

		Managers.state.network.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_5, var_2_6)
	end
end

function BTRatlingGunnerApproachAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_4 ~= "done" then
		arg_3_2.move_pos = nil
	end

	local var_3_0 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(var_3_0)
end

function BTRatlingGunnerApproachAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_0:is_within_check_distance(arg_4_1, arg_4_2) then
		return "done"
	end

	local var_4_0 = arg_4_2.move_pos
	local var_4_1 = var_4_0 and arg_4_2.destination_dist < 0.5

	if not var_4_0 or var_4_1 then
		local var_4_2 = arg_4_0:calculate_move_position(arg_4_1, arg_4_2)

		if var_4_2 then
			arg_4_0:move_to(var_4_2, arg_4_2)

			return "running"
		else
			return "failed"
		end
	end

	if arg_4_2.no_path_found then
		return "failed"
	end

	local var_4_3 = arg_4_2.is_computing_path

	if arg_4_2.move_state ~= "moving" and not var_4_3 then
		local var_4_4 = arg_4_2.action.move_anim

		Managers.state.network:anim_event(arg_4_1, var_4_4)

		arg_4_2.move_state = "moving"
	end

	return "running"
end

function BTRatlingGunnerApproachAction.is_within_check_distance(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2.action
	local var_5_1 = arg_5_2.previous_attacker

	return arg_5_2.target_dist < var_5_0.check_distance or var_5_1
end

function BTRatlingGunnerApproachAction.move_to(arg_6_0, arg_6_1, arg_6_2)
	arg_6_2.navigation_extension:move_to(arg_6_1)

	arg_6_2.move_pos = Vector3Box(arg_6_1)
end

function BTRatlingGunnerApproachAction.calculate_move_position(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2.action
	local var_7_1 = var_7_0.check_distance - 2
	local var_7_2 = var_7_0.check_distance
	local var_7_3 = var_7_0.min_angle_step
	local var_7_4 = var_7_0.max_angle_step

	return (AiUtils.advance_towards_target(arg_7_1, arg_7_2, var_7_1, var_7_2, var_7_3, var_7_4))
end
