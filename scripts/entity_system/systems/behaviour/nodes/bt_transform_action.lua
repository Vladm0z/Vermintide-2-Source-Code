-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_transform_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTransformAction = class(BTTransformAction, BTNode)

BTTransformAction.init = function (arg_1_0, ...)
	BTTransformAction.super.init(arg_1_0, ...)
end

BTTransformAction.name = "BTTransformAction"

BTTransformAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.active_node = BTTransformAction

	local var_2_0 = arg_2_2.action
	local var_2_1 = Managers.state.network
	local var_2_2 = var_2_0.transform_animation

	if var_2_2 then
		var_2_1:anim_event(arg_2_1, var_2_2)
	else
		arg_2_2.transform_anim_finished = true
	end

	local var_2_3 = arg_2_2.navigation_extension

	var_2_3:set_enabled(false)
	var_2_3:set_max_speed(0)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))
end

BTTransformAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if not arg_3_2.has_transformed then
		arg_3_0:transform(arg_3_1, arg_3_2)
	end
end

BTTransformAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_2.transform_anim_finished and not arg_4_2.has_transformed then
		arg_4_0:transform(arg_4_1, arg_4_2)

		return "done"
	end

	return "running"
end

BTTransformAction.anim_cb_transform_finished = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_2.transform_anim_finished = true
end

BTTransformAction.transform = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.action
	local var_6_1 = var_6_0.transfer_health_percentage
	local var_6_2 = {
		original_hp_percentage = ScriptUnit.extension(arg_6_1, "health_system"):current_health_percent(),
		spawned_func = function (arg_7_0, arg_7_1, arg_7_2)
			if var_6_1 then
				local var_7_0 = arg_7_2.original_hp_percentage
				local var_7_1 = ScriptUnit.extension(arg_7_0, "health_system")
				local var_7_2 = var_7_1:get_max_health() * (1 - math.max(var_7_0, 0.1))

				var_7_1:set_current_damage(var_7_2)

				local var_7_3, var_7_4 = Managers.state.network:game_object_or_level_id(arg_7_0)
				local var_7_5 = NetworkLookup.health_statuses[var_7_1.state]

				Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_damage_taken", var_7_3, var_7_4, false, var_7_2, var_7_5)
			end
		end
	}
	local var_6_3 = Breeds[var_6_0.wanted_breed_transform]
	local var_6_4 = "misc"
	local var_6_5 = Managers.state.conflict
	local var_6_6 = arg_6_1 and POSITION_LOOKUP[arg_6_1] or Unit.world_position(arg_6_1, 0)
	local var_6_7 = arg_6_1 and Unit.local_rotation(arg_6_1, 0) or Quaternion.identity()

	if var_6_6 and var_6_7 then
		var_6_5:spawn_queued_unit(var_6_3, Vector3Box(var_6_6), QuaternionBox(var_6_7), var_6_4, nil, nil, var_6_2)
	end

	var_6_5:destroy_unit(arg_6_1, arg_6_2, "boss_transformation")

	arg_6_2.has_transformed = true
end
