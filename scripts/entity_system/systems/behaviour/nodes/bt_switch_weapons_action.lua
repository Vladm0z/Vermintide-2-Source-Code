-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_switch_weapons_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSwitchWeaponsAction = class(BTSwitchWeaponsAction, BTNode)
BTSwitchWeaponsAction.name = "BTSwitchWeaponsAction"

BTSwitchWeaponsAction.init = function (arg_1_0, ...)
	BTSwitchWeaponsAction.super.init(arg_1_0, ...)
end

BTSwitchWeaponsAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.active_node = BTSwitchWeaponsAction

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))

	local var_2_1 = ScriptUnit.has_extension(arg_2_1, "ai_inventory_system")
	local var_2_2 = var_2_0 and var_2_0.switch_weapon_index or arg_2_2.switching_weapons

	var_2_1:wield_item_set(var_2_2)

	arg_2_2.inventory_item_set = var_2_2
	arg_2_2.switching_done_time = arg_2_3 + (var_2_0 and var_2_0.switch_done_time or 0.75)
	arg_2_2.move_state = "idle"

	local var_2_3 = var_2_0 and var_2_0.switch_animation

	if var_2_3 == "to_combat" then
		AiUtils.enter_combat(arg_2_1, arg_2_2)
	elseif var_2_3 == "to_passive" then
		AiUtils.enter_passive(arg_2_1, arg_2_2)
	elseif var_2_3 then
		Managers.state.network:anim_event(arg_2_1, var_2_3)
	end
end

BTSwitchWeaponsAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.switching_weapons = false
	arg_3_2.has_switched_weapons = true
	arg_3_2.spawn_to_running = nil

	arg_3_2.navigation_extension:set_enabled(true)
end

BTSwitchWeaponsAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_3 > arg_4_2.switching_done_time then
		return "done"
	end

	return "running"
end
