-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_teleport_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosSorcererTeleportAction = class(BTChaosSorcererTeleportAction, BTNode)
BTChaosSorcererTeleportAction.name = "BTChaosSorcererTeleportAction"

BTChaosSorcererTeleportAction.init = function (arg_1_0, ...)
	BTChaosSorcererTeleportAction.super.init(arg_1_0, ...)
end

BTChaosSorcererTeleportAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.next_smart_object_data
	local var_2_1 = var_2_0.entrance_pos:unbox()
	local var_2_2 = var_2_0.exit_pos:unbox()

	arg_2_2.active_node = BTChaosSorcererTeleportAction
	arg_2_2.smart_object_data = var_2_0.smart_object_data
	arg_2_2.teleport_position = Vector3Box(var_2_2)
	arg_2_2.entrance_position = Vector3Box(var_2_1)

	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	arg_2_2.navigation_extension:set_enabled(false)
	Managers.state.network:anim_event(arg_2_1, "teleport_start")
end

BTChaosSorcererTeleportAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.teleport_position = nil
	arg_3_2.entrance_position = nil
	arg_3_2.teleport_timeout = nil
	arg_3_2.anim_cb_teleport_finished = nil
	arg_3_2.active_node = nil

	local var_3_0 = arg_3_2.navigation_extension

	var_3_0:set_enabled(true)

	if var_3_0:is_using_smart_object() then
		local var_3_1 = var_3_0:use_smart_object(false)
	end
end

BTChaosSorcererTeleportAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_2.smart_object_data ~= arg_4_2.next_smart_object_data.smart_object_data then
		return "failed"
	end

	local var_4_0 = arg_4_2.navigation_extension
	local var_4_1 = POSITION_LOOKUP[arg_4_1]
	local var_4_2 = arg_4_2.entrance_position:unbox()
	local var_4_3 = var_4_2 - var_4_1
	local var_4_4 = Vector3.normalize(var_4_0:desired_velocity())
	local var_4_5 = Vector3.flat(var_4_4)

	if Vector3.length(var_4_5) < 0.05 and Vector3.dot(var_4_4, Vector3.normalize(var_4_3)) > 0.99 then
		arg_4_2.teleport_timeout = arg_4_2.teleport_timeout or arg_4_3 + 0.3
	else
		arg_4_2.teleport_timeout = nil
	end

	if (arg_4_2.teleport_timeout == nil or arg_4_3 > arg_4_2.teleport_timeout) and arg_4_2.anim_cb_teleport_finished then
		local var_4_6 = arg_4_2.locomotion_extension
		local var_4_7 = arg_4_2.teleport_position:unbox()

		var_4_0:set_navbot_position(var_4_7)
		var_4_6:teleport_to(var_4_7)
		arg_4_0:play_teleport_effect(arg_4_1, var_4_2, var_4_7)

		return "done"
	else
		return "running"
	end
end

BTChaosSorcererTeleportAction.play_teleport_effect = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0._tree_node.action_data
	local var_5_1 = var_5_0 and var_5_0.teleport_effect or "fx/chr_chaos_sorcerer_teleport"
	local var_5_2 = NetworkLookup.effects[var_5_1]
	local var_5_3 = Managers.state.network
	local var_5_4 = var_5_3:unit_game_object_id(arg_5_1)
	local var_5_5 = 0
	local var_5_6 = Quaternion.identity()

	var_5_3:rpc_play_particle_effect(nil, var_5_2, NetworkConstants.invalid_game_object_id, var_5_5, arg_5_2, var_5_6, false)
	var_5_3:rpc_play_particle_effect(nil, var_5_2, NetworkConstants.invalid_game_object_id, var_5_5, arg_5_3, var_5_6, false)
end

BTChaosSorcererTeleportAction.anim_cb_teleport_start_finished = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_2.anim_cb_teleport_finished = true
end
