-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_follow_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterFollowAction = class(BTPackMasterFollowAction, BTNode)

function BTPackMasterFollowAction.init(arg_1_0, ...)
	BTPackMasterFollowAction.super.init(arg_1_0, ...)

	arg_1_0.navigation_group_manager = Managers.state.conflict.navigation_group_manager
end

BTPackMasterFollowAction.name = "BTPackMasterFollowAction"

function BTPackMasterFollowAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.time_to_next_evaluate = arg_2_3 + 0.1

	local var_2_1 = var_2_0.tutorial_message_template

	if var_2_1 then
		local var_2_2 = NetworkLookup.tutorials[var_2_1]
		local var_2_3 = NetworkLookup.tutorials[arg_2_2.breed.name]

		Managers.state.network.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_2, var_2_3)
	end

	arg_2_2.start_anim_done = true
	arg_2_2.physics_world = arg_2_2.physics_world or World.get_data(arg_2_2.world, "physics_world")
end

function BTPackMasterFollowAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.action = nil
	arg_3_2.start_anim_locked = nil
	arg_3_2.anim_cb_rotation_start = nil
	arg_3_2.anim_cb_move = nil
	arg_3_2.start_anim_done = nil

	if arg_3_4 == "failed" then
		arg_3_2.target_unit = nil
	end
end

function BTPackMasterFollowAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.target_unit

	if not AiUtils.is_of_interest_to_packmaster(arg_4_1, var_4_0) then
		return "failed"
	end

	local var_4_1 = POSITION_LOOKUP[arg_4_1]
	local var_4_2 = POSITION_LOOKUP[var_4_0]
	local var_4_3 = 0.4
	local var_4_4 = var_4_2 + ScriptUnit.extension(var_4_0, "locomotion_system"):average_velocity() * var_4_3
	local var_4_5 = Vector3.distance_squared(var_4_1, var_4_4)
	local var_4_6 = arg_4_2.action.distance_to_attack

	if var_4_5 < var_4_6 * var_4_6 and PerceptionUtils.pack_master_has_line_of_sight_for_attack(arg_4_2.physics_world, arg_4_1, var_4_0) then
		return "done"
	end

	local var_4_7 = arg_4_2.navigation_extension

	if arg_4_2.start_anim_done then
		local var_4_8, var_4_9 = ScriptUnit.extension(var_4_0, "whereabouts_system"):closest_positions_when_outside_navmesh()

		if var_4_9 then
			local var_4_10 = POSITION_LOOKUP[var_4_0]

			var_4_7:move_to(var_4_10)
		elseif #var_4_8 > 0 then
			local var_4_11 = var_4_8[1]

			var_4_7:move_to(var_4_11:unbox())
		else
			return "failed"
		end
	end

	if var_4_7:has_reached_destination() then
		return "failed"
	end

	local var_4_12

	if arg_4_3 > arg_4_2.time_to_next_evaluate then
		var_4_12 = "evaluate"
		arg_4_2.time_to_next_evaluate = arg_4_3 + 0.1
	end

	local var_4_13 = var_4_7:is_computing_path()

	if arg_4_2.move_state ~= "moving" and not var_4_13 then
		local var_4_14 = Managers.state.network

		arg_4_2.move_state = "moving"

		var_4_14:anim_event(arg_4_1, arg_4_2.action.move_animation or "move_fwd")
		var_4_7:set_enabled(true)
	end

	return "running", var_4_12
end
