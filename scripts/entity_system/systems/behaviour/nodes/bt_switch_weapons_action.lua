-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_switch_weapons_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSwitchWeaponsAction = class(BTSwitchWeaponsAction, BTNode)
BTSwitchWeaponsAction.name = "BTSwitchWeaponsAction"

BTSwitchWeaponsAction.init = function (arg_1_0, ...)
	-- function 1
	BTSwitchWeaponsAction.super.init(arg_1_0, ...)
end

BTSwitchWeaponsAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.active_node = BTSwitchWeaponsAction

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))

	local has_extension = ScriptUnit.has_extension(arg_2_1, "ai_inventory_system")
	local switch_weapon_index

	if not action_data then
		switch_weapon_index = action_data.switch_weapon_index

		if not switch_weapon_index then
			-- Nothing
		end
	end

	switch_weapon_index = arg_2_2.switching_weapons

	::label_2_0::

	has_extension:wield_item_set(switch_weapon_index)

	arg_2_2.inventory_item_set = switch_weapon_index

	local switch_done_time

	if not action_data then
		switch_done_time = action_data.switch_done_time

		if not switch_done_time then
			-- Nothing
		end
	end

	switch_done_time = 0.75

	::label_2_1::

	arg_2_2.switching_done_time = arg_2_3 + switch_done_time
	arg_2_2.move_state = "idle"

	local flag = not action_data and action_data.switch_animation

	if flag == "to_combat" then
		AiUtils.enter_combat(arg_2_1, arg_2_2)
	elseif flag == "to_passive" then
		AiUtils.enter_passive(arg_2_1, arg_2_2)
	elseif not flag then
		Managers.state.network:anim_event(arg_2_1, flag)
	end
end

BTSwitchWeaponsAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.switching_weapons = false
	arg_3_2.has_switched_weapons = true
	arg_3_2.spawn_to_running = nil

	arg_3_2.navigation_extension:set_enabled(true)
end

BTSwitchWeaponsAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if arg_4_3 > arg_4_2.switching_done_time then
		return "done"
	end

	return "running"
end
