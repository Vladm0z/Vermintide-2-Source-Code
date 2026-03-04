-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_give_command_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

local var_0_0 = Unit.alive
local var_0_1 = {
	clan_rat_attack = "commanding"
}

BTGiveCommandAction = class(BTGiveCommandAction, BTNode)

BTGiveCommandAction.init = function (arg_1_0, ...)
	BTGiveCommandAction.super.init(arg_1_0, ...)
end

BTGiveCommandAction.name = "BTGiveCommandAction"

BTGiveCommandAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local var_2_1 = Managers.state.network

	var_2_1:anim_event(arg_2_1, "order")

	local var_2_2 = var_2_1:unit_game_object_id(arg_2_1)

	var_2_1.network_transmit:send_rpc_all("rpc_ai_inventory_wield", var_2_2, 1)

	local var_2_3 = var_2_0.tutorial_message_template

	if var_2_3 then
		local var_2_4 = NetworkLookup.tutorials[var_2_3]
		local var_2_5 = NetworkLookup.tutorials[arg_2_2.breed.name]

		var_2_1.network_transmit:send_rpc_all("rpc_tutorial_message", var_2_4, var_2_5)
	end
end

BTGiveCommandAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
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
	local var_4_0 = arg_4_2.command_target

	if not var_0_0(var_4_0) then
		return "failed"
	end

	local var_4_1 = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, var_4_0)

	arg_4_2.locomotion_extension:set_wanted_rotation(var_4_1)

	if arg_4_2.anim_cb_stormvermin_voice then
		arg_4_2.anim_cb_stormvermin_voice = nil

		local var_4_2 = ScriptUnit.extension_input(arg_4_1, "dialogue_system")
		local var_4_3 = FrameTable.alloc_table()
		local var_4_4 = arg_4_2.give_command

		if var_4_4 == "clan_rat_attack" then
			var_4_3.target_name = ScriptUnit.extension(var_4_0, "dialogue_system").context.player_profile
			var_4_3.num_units = arg_4_2.command_num_units

			if arg_4_2.command_target_previous == nil or var_4_0 == arg_4_2.command_target_previous then
				var_4_2:trigger_networked_dialogue_event("commanding", var_4_3)
			else
				var_4_2:trigger_networked_dialogue_event("command_change_target", var_4_3)
			end
		elseif var_4_4 == "cheer" then
			-- Nothing
		elseif var_4_4 == "rally" then
			-- Nothing
		elseif var_4_4 == "command_globadier" then
			var_4_2:trigger_networked_dialogue_event("command_globadier", var_4_3)
		elseif var_4_4 == "command_gutter_runner" then
			var_4_2:trigger_networked_dialogue_event("command_gutter_runner", var_4_3)
		elseif var_4_4 == "command_rat_ogre" then
			var_4_2:trigger_networked_dialogue_event("command_rat_ogre", var_4_3)
		end
	end

	if arg_4_2.anim_cb_order_finished then
		return "done"
	end

	return "running", "evaluate"
end
