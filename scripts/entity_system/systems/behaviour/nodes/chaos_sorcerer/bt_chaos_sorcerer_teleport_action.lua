-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_chaos_sorcerer_teleport_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTChaosSorcererTeleportAction = class(BTChaosSorcererTeleportAction, BTNode)
BTChaosSorcererTeleportAction.name = "BTChaosSorcererTeleportAction"

BTChaosSorcererTeleportAction.init = function (arg_1_0, ...)
	-- function 1
	BTChaosSorcererTeleportAction.super.init(arg_1_0, ...)
end

BTChaosSorcererTeleportAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local next_smart_object_data = arg_2_2.next_smart_object_data
	local unbox = next_smart_object_data.entrance_pos:unbox()
	local unbox_2 = next_smart_object_data.exit_pos:unbox()

	arg_2_2.active_node = BTChaosSorcererTeleportAction
	arg_2_2.smart_object_data = next_smart_object_data.smart_object_data
	arg_2_2.teleport_position = Vector3Box(unbox_2)
	arg_2_2.entrance_position = Vector3Box(unbox)

	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	arg_2_2.navigation_extension:set_enabled(false)
	Managers.state.network:anim_event(arg_2_1, "teleport_start")
end

BTChaosSorcererTeleportAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.teleport_position = nil
	arg_3_2.entrance_position = nil
	arg_3_2.teleport_timeout = nil
	arg_3_2.anim_cb_teleport_finished = nil
	arg_3_2.active_node = nil

	local navigation_extension = arg_3_2.navigation_extension

	navigation_extension:set_enabled(true)

	if not navigation_extension:is_using_smart_object() then
		local use_smart_object = navigation_extension:use_smart_object(false)
	end
end

BTChaosSorcererTeleportAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if arg_4_2.smart_object_data ~= arg_4_2.next_smart_object_data.smart_object_data then
		return "failed"
	end

	local navigation_extension = arg_4_2.navigation_extension
	local var_4_1 = POSITION_LOOKUP[arg_4_1]
	local unbox = arg_4_2.entrance_position:unbox()
	local num = unbox - var_4_1
	local normalize = Vector3.normalize(navigation_extension:desired_velocity())
	local flat = Vector3.flat(normalize)

	if not (not (Vector3.length(flat) < 0.05) or not (Vector3.dot(normalize, Vector3.normalize(num)) > 0.99)) then
		local teleport_timeout = arg_4_2.teleport_timeout

		teleport_timeout = teleport_timeout or arg_4_3 + 0.3
		arg_4_2.teleport_timeout = teleport_timeout
	else
		arg_4_2.teleport_timeout = nil
	end

	if arg_4_2.teleport_timeout == nil or arg_4_3 > arg_4_2.teleport_timeout or not arg_4_2.anim_cb_teleport_finished then
		local locomotion_extension = arg_4_2.locomotion_extension
		local unbox_2 = arg_4_2.teleport_position:unbox()

		navigation_extension:set_navbot_position(unbox_2)
		locomotion_extension:teleport_to(unbox_2)
		self:play_teleport_effect(arg_4_1, unbox, unbox_2)

		return "done"
	else
		return "running"
	end
end

BTChaosSorcererTeleportAction.play_teleport_effect = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local action_data = self._tree_node.action_data
	local teleport_effect

	if not action_data then
		teleport_effect = action_data.teleport_effect

		if not teleport_effect then
			-- Nothing
		end
	end

	teleport_effect = "fx/chr_chaos_sorcerer_teleport"

	::label_5_0::

	local var_5_2 = NetworkLookup.effects[teleport_effect]
	local network = Managers.state.network
	local unit_game_object_id = network:unit_game_object_id(arg_5_1)
	local num = 0
	local identity = Quaternion.identity()

	network:rpc_play_particle_effect(nil, var_5_2, NetworkConstants.invalid_game_object_id, num, arg_5_2, identity, false)
	network:rpc_play_particle_effect(nil, var_5_2, NetworkConstants.invalid_game_object_id, num, arg_5_3, identity, false)
end

BTChaosSorcererTeleportAction.anim_cb_teleport_start_finished = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	arg_6_2.anim_cb_teleport_finished = true
end
