-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_follow_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterFollowAction = class(BTPackMasterFollowAction, BTNode)

BTPackMasterFollowAction.init = function (self, ...)
	-- function 1
	BTPackMasterFollowAction.super.init(self, ...)

	self.navigation_group_manager = Managers.state.conflict.navigation_group_manager
end

BTPackMasterFollowAction.name = "BTPackMasterFollowAction"

BTPackMasterFollowAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.time_to_next_evaluate = arg_2_3 + 0.1

	local tutorial_message_template = action_data.tutorial_message_template

	if not tutorial_message_template then
		local var_2_2 = NetworkLookup.tutorials[tutorial_message_template]
		local var_2_3 = NetworkLookup.tutorials[arg_2_2.breed.name]

		Managers.state.network.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_2, var_2_3)
	end

	arg_2_2.start_anim_done = true

	local physics_world = arg_2_2.physics_world

	physics_world = physics_world or World.get_data(arg_2_2.world, "physics_world")
	arg_2_2.physics_world = physics_world
end

BTPackMasterFollowAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.action = nil
	arg_3_2.start_anim_locked = nil
	arg_3_2.anim_cb_rotation_start = nil
	arg_3_2.anim_cb_move = nil
	arg_3_2.start_anim_done = nil

	if arg_3_4 == "failed" then
		arg_3_2.target_unit = nil
	end
end

BTPackMasterFollowAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local target_unit = arg_4_2.target_unit

	if not AiUtils.is_of_interest_to_packmaster(arg_4_1, target_unit) then
		return "failed"
	end

	local var_4_1 = POSITION_LOOKUP[arg_4_1]
	local var_4_2 = POSITION_LOOKUP[target_unit]
	local num = 0.4
	local num_2 = var_4_2 + ScriptUnit.extension(target_unit, "locomotion_system"):average_velocity() * num
	local distance_squared = Vector3.distance_squared(var_4_1, num_2)
	local distance_to_attack = arg_4_2.action.distance_to_attack

	if not (distance_squared < distance_to_attack * distance_to_attack) or not PerceptionUtils.pack_master_has_line_of_sight_for_attack(arg_4_2.physics_world, arg_4_1, target_unit) then
		return "done"
	end

	local navigation_extension = arg_4_2.navigation_extension

	if not arg_4_2.start_anim_done then
		local closest_positions_when_outside_navmesh, var_4_9 = ScriptUnit.extension(target_unit, "whereabouts_system"):closest_positions_when_outside_navmesh()

		if not var_4_9 then
			local var_4_10 = POSITION_LOOKUP[target_unit]

			navigation_extension:move_to(var_4_10)
		elseif #closest_positions_when_outside_navmesh > 0 then
			local var_4_11 = closest_positions_when_outside_navmesh[1]

			navigation_extension:move_to(var_4_11:unbox())
		else
			return "failed"
		end
	end

	if not navigation_extension:has_reached_destination() then
		return "failed"
	end

	local var_4_12

	if arg_4_3 > arg_4_2.time_to_next_evaluate then
		var_4_12 = "evaluate"
		arg_4_2.time_to_next_evaluate = arg_4_3 + 0.1
	end

	local is_computing_path = navigation_extension:is_computing_path()

	if not (arg_4_2.move_state == "moving" or is_computing_path) then
		local network = Managers.state.network

		arg_4_2.move_state = "moving"

		local var_4_15 = network
		local anim_event = network.anim_event
		local var_4_17 = arg_4_1
		local move_animation = arg_4_2.action.move_animation

		move_animation = move_animation or "move_fwd"

		anim_event(var_4_15, var_4_17, move_animation)
		navigation_extension:set_enabled(true)
	end

	return "running", var_4_12
end
