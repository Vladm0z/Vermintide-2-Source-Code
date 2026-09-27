-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_transform_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTransformAction = class(BTTransformAction, BTNode)

BTTransformAction.init = function (arg_1_0, ...)
	-- function 1
	BTTransformAction.super.init(arg_1_0, ...)
end

BTTransformAction.name = "BTTransformAction"

BTTransformAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data
	arg_2_2.active_node = BTTransformAction

	local action = arg_2_2.action
	local network = Managers.state.network
	local transform_animation = action.transform_animation

	if not transform_animation then
		network:anim_event(arg_2_1, transform_animation)
	else
		arg_2_2.transform_anim_finished = true
	end

	local navigation_extension = arg_2_2.navigation_extension

	navigation_extension:set_enabled(false)
	navigation_extension:set_max_speed(0)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))
end

BTTransformAction.leave = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not arg_3_2.has_transformed then
		self:transform(arg_3_1, arg_3_2)
	end
end

BTTransformAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not (not arg_4_2.transform_anim_finished and arg_4_2.has_transformed) then
		self:transform(arg_4_1, arg_4_2)

		return "done"
	end

	return "running"
end

BTTransformAction.anim_cb_transform_finished = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	arg_5_2.transform_anim_finished = true
end

BTTransformAction.transform = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local action = arg_6_2.action
	local transfer_health_percentage = action.transfer_health_percentage
	local tbl = {
		original_hp_percentage = ScriptUnit.extension(arg_6_1, "health_system"):current_health_percent(),
		spawned_func = function (arg_7_0, arg_7_1, arg_7_2)
			-- function 7
			if not transfer_health_percentage then
				local original_hp_percentage = arg_7_2.original_hp_percentage
				local extension = ScriptUnit.extension(arg_7_0, "health_system")
				local num = extension:get_max_health() * (1 - math.max(original_hp_percentage, 0.1))

				extension:set_current_damage(num)

				local game_object_or_level_id, var_7_4 = Managers.state.network:game_object_or_level_id(arg_7_0)
				local var_7_5 = NetworkLookup.health_statuses[extension.state]

				Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_damage_taken", game_object_or_level_id, var_7_4, false, num, var_7_5)
			end
		end
	}
	local var_6_3 = Breeds[action.wanted_breed_transform]
	local str = "misc"
	local conflict = Managers.state.conflict
	local var_6_6

	if not arg_6_1 then
		var_6_6 = POSITION_LOOKUP[arg_6_1]

		if not var_6_6 then
			-- Nothing
		end
	end

	var_6_6 = Unit.world_position(arg_6_1, 0)

	do
		local local_rotation
	end

	::label_6_0::

	if not arg_6_1 then
		local_rotation = Unit.local_rotation(arg_6_1, 0)

		if not local_rotation then
			-- Nothing
		end
	end

	local_rotation = Quaternion.identity()

	::label_6_1::

	if not var_6_6 and not local_rotation then
		conflict:spawn_queued_unit(var_6_3, Vector3Box(var_6_6), QuaternionBox(local_rotation), str, nil, nil, tbl)
	end

	conflict:destroy_unit(arg_6_1, arg_6_2, "boss_transformation")

	arg_6_2.has_transformed = true
end
