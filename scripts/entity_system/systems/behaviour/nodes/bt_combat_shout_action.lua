-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_combat_shout_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCombatShoutAction = class(BTCombatShoutAction, BTNode)

BTCombatShoutAction.init = function (arg_1_0, ...)
	BTCombatShoutAction.super.init(arg_1_0, ...)
end

BTCombatShoutAction.name = "BTCombatShoutAction"

BTCombatShoutAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.anim_cb_shout_finished = nil
	arg_2_2.active_node = BTCombatShoutAction

	Managers.state.network:anim_event(arg_2_1, var_2_0.shout_anim)
	arg_2_2.navigation_extension:set_enabled(false)

	local var_2_1 = arg_2_2.locomotion_extension

	var_2_1:set_wanted_velocity(Vector3.zero())

	local var_2_2 = LocomotionUtils.rotation_towards_unit_flat(arg_2_1, arg_2_2.target_unit)

	var_2_1:set_wanted_rotation(var_2_2)

	arg_2_2.spawn_to_running = nil
end

BTCombatShoutAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.navigation_extension:set_enabled(true)

	arg_3_2.active_node = nil
end

BTCombatShoutAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.locomotion_extension
	local var_4_1 = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, arg_4_2.target_unit)

	var_4_0:set_wanted_rotation(var_4_1)

	local var_4_2 = arg_4_2.have_slot == 1

	if arg_4_2.anim_cb_shout_finished or var_4_2 then
		return "done"
	else
		return "running"
	end
end

BTCombatShoutAction.anim_cb_shout_vo = function (arg_5_0, arg_5_1, arg_5_2)
	if Managers.state.network:game() then
		local var_5_0 = ScriptUnit.extension_input(arg_5_1, "dialogue_system")
		local var_5_1 = FrameTable.alloc_table()

		var_5_0:trigger_networked_dialogue_event("shouting", var_5_1)
	end
end
