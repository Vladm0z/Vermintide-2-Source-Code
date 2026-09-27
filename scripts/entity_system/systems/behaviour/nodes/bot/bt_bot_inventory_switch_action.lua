-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_inventory_switch_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotInventorySwitchAction = class(BTBotInventorySwitchAction, BTNode)

BTBotInventorySwitchAction.init = function (arg_1_0, ...)
	-- function 1
	BTBotInventorySwitchAction.super.init(arg_1_0, ...)
end

BTBotInventorySwitchAction.name = "BTBotInventorySwitchAction"

BTBotInventorySwitchAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.node_timer = arg_2_3

	local action_data = self._tree_node.action_data

	if not action_data.wanted_slot_key then
		arg_2_2.wanted_slot = arg_2_2[action_data.wanted_slot_key]
	else
		arg_2_2.wanted_slot = self._tree_node.action_data.wanted_slot
	end
end

BTBotInventorySwitchAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.wanted_slot = nil
end

BTBotInventorySwitchAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local wanted_slot = arg_4_2.wanted_slot

	if wanted_slot == nil then
		return "failed"
	end

	local inventory_extension = arg_4_2.inventory_extension
	local input_extension = arg_4_2.input_extension

	if inventory_extension:equipment().wielded_slot == wanted_slot then
		return "done"
	elseif arg_4_3 > arg_4_2.node_timer + 0.3 then
		arg_4_2.node_timer = arg_4_3

		return "running", "evaluate"
	else
		input_extension:wield(wanted_slot)

		return "running"
	end
end
