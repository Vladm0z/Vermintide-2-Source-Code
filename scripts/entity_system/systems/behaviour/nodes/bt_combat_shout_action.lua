-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_combat_shout_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCombatShoutAction = class(BTCombatShoutAction, BTNode)

BTCombatShoutAction.init = function (arg_1_0, ...)
	-- function 1
	BTCombatShoutAction.super.init(arg_1_0, ...)
end

BTCombatShoutAction.name = "BTCombatShoutAction"

BTCombatShoutAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.anim_cb_shout_finished = nil
	arg_2_2.active_node = BTCombatShoutAction

	Managers.state.network:anim_event(arg_2_1, action_data.shout_anim)
	arg_2_2.navigation_extension:set_enabled(false)

	local locomotion_extension = arg_2_2.locomotion_extension

	locomotion_extension:set_wanted_velocity(Vector3.zero())

	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_2_1, arg_2_2.target_unit)

	locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)

	arg_2_2.spawn_to_running = nil
end

BTCombatShoutAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.navigation_extension:set_enabled(true)

	arg_3_2.active_node = nil
end

BTCombatShoutAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local locomotion_extension = arg_4_2.locomotion_extension
	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, arg_4_2.target_unit)

	locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)

	local flag = arg_4_2.have_slot == 1

	if arg_4_2.anim_cb_shout_finished or not flag then
		return "done"
	else
		return "running"
	end
end

BTCombatShoutAction.anim_cb_shout_vo = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	if not Managers.state.network:game() then
		local extension_input = ScriptUnit.extension_input(arg_5_1, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		extension_input:trigger_networked_dialogue_event("shouting", alloc_table)
	end
end
