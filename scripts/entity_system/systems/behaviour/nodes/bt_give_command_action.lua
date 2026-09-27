-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_give_command_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local alive = Unit.alive
local tbl = {
	clan_rat_attack = "commanding"
}

BTGiveCommandAction = class(BTGiveCommandAction, BTNode)

BTGiveCommandAction.init = function (arg_1_0, ...)
	-- function 1
	BTGiveCommandAction.super.init(arg_1_0, ...)
end

BTGiveCommandAction.name = "BTGiveCommandAction"

BTGiveCommandAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local network = Managers.state.network

	network:anim_event(arg_2_1, "order")

	local unit_game_object_id = network:unit_game_object_id(arg_2_1)

	network.network_transmit:send_rpc_all("rpc_ai_inventory_wield", unit_game_object_id, 1)

	local tutorial_message_template = action_data.tutorial_message_template

	if not tutorial_message_template then
		local var_2_4 = NetworkLookup.tutorials[tutorial_message_template]
		local var_2_5 = NetworkLookup.tutorials[arg_2_2.breed.name]

		network.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_4, var_2_5)
	end
end

BTGiveCommandAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.navigation_extension:set_enabled(true)

	arg_3_2.target_unit = arg_3_2.command_target

	AiUtils.activate_unit(arg_3_2)

	arg_3_2.command_target_previous = arg_3_2.command_target
	arg_3_2.anim_cb_order_finished = nil
	arg_3_2.give_command = nil
	arg_3_2.command_target = nil
	arg_3_2.command_num_units = nil
	arg_3_2.anim_cb_stormvermin_voice = nil
end

BTGiveCommandAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local command_target = arg_4_2.command_target

	if not alive(command_target) then
		return "failed"
	end

	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, command_target)

	arg_4_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)

	if not arg_4_2.anim_cb_stormvermin_voice then
		arg_4_2.anim_cb_stormvermin_voice = nil

		local extension_input = ScriptUnit.extension_input(arg_4_1, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()
		local give_command = arg_4_2.give_command

		if give_command == "clan_rat_attack" then
			alloc_table.target_name = ScriptUnit.extension(command_target, "dialogue_system").context.player_profile
			alloc_table.num_units = arg_4_2.command_num_units

			if not (arg_4_2.command_target_previous == nil or command_target ~= arg_4_2.command_target_previous) then
				extension_input:trigger_networked_dialogue_event("commanding", alloc_table)
			else
				extension_input:trigger_networked_dialogue_event("command_change_target", alloc_table)
			end
		elseif give_command == "cheer" then
			-- Nothing
		elseif give_command == "rally" then
			-- Nothing
		elseif give_command == "command_globadier" then
			extension_input:trigger_networked_dialogue_event("command_globadier", alloc_table)
		elseif give_command == "command_gutter_runner" then
			extension_input:trigger_networked_dialogue_event("command_gutter_runner", alloc_table)
		elseif give_command == "command_rat_ogre" then
			extension_input:trigger_networked_dialogue_event("command_rat_ogre", alloc_table)
		end
	end

	if not arg_4_2.anim_cb_order_finished then
		return "done"
	end

	return "running", "evaluate"
end
