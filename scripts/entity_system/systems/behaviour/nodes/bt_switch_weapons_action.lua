-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_switch_weapons_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSwitchWeaponsAction = class(BTSwitchWeaponsAction, BTNode)
BTSwitchWeaponsAction.name = "BTSwitchWeaponsAction"

BTSwitchWeaponsAction.init = function (self, ...)
	-- function 1
	BTSwitchWeaponsAction.super.init(self, ...)
end

BTSwitchWeaponsAction.enter = function (self, unit, blackboard, t)
	-- function 2
	local action = self._tree_node.action_data

	blackboard.action = action
	blackboard.active_node = BTSwitchWeaponsAction

	blackboard.navigation_extension:set_enabled(false)
	blackboard.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))

	local ai_inventory_ext = ScriptUnit.has_extension(unit, "ai_inventory_system")
	local switch_weapon_index

	if action then
		switch_weapon_index = action.switch_weapon_index

		if not switch_weapon_index then
			-- Nothing
		end
	end

	switch_weapon_index = blackboard.switching_weapons

	local wanted_set = switch_weapon_index

	::label_2_0::

	ai_inventory_ext:wield_item_set(wanted_set)

	blackboard.inventory_item_set = wanted_set

	local switch_done_time

	if action then
		switch_done_time = action.switch_done_time

		if not switch_done_time then
			-- Nothing
		end
	end

	switch_done_time = 0.75

	::label_2_1::

	blackboard.switching_done_time = t + switch_done_time
	blackboard.move_state = "idle"

	local switch_animation = not not action and not not action.switch_animation

	if switch_animation == "to_combat" then
		AiUtils.enter_combat(unit, blackboard)
	elseif switch_animation == "to_passive" then
		AiUtils.enter_passive(unit, blackboard)
	elseif switch_animation then
		Managers.state.network:anim_event(unit, switch_animation)
	end
end

BTSwitchWeaponsAction.leave = function (self, unit, blackboard, t, reason, destroy)
	-- function 3
	blackboard.switching_weapons = false
	blackboard.has_switched_weapons = true
	blackboard.spawn_to_running = nil

	local navigation_extension = blackboard.navigation_extension

	navigation_extension:set_enabled(true)
end

BTSwitchWeaponsAction.run = function (self, unit, blackboard, t, dt)
	-- function 4
	if t > blackboard.switching_done_time then
		return "done"
	end

	return "running"
end
