-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_inventory_switch_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotInventorySwitchAction = class(BTBotInventorySwitchAction, BTNode)

function BTBotInventorySwitchAction.init(arg_1_0, ...)
	BTBotInventorySwitchAction.super.init(arg_1_0, ...)
end

BTBotInventorySwitchAction.name = "BTBotInventorySwitchAction"

function BTBotInventorySwitchAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.node_timer = arg_2_3

	local var_2_0 = arg_2_0._tree_node.action_data

	if var_2_0.wanted_slot_key then
		arg_2_2.wanted_slot = arg_2_2[var_2_0.wanted_slot_key]
	else
		arg_2_2.wanted_slot = arg_2_0._tree_node.action_data.wanted_slot
	end
end

function BTBotInventorySwitchAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.wanted_slot = nil
end

function BTBotInventorySwitchAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.wanted_slot

	if var_4_0 == nil then
		return "failed"
	end

	local var_4_1 = arg_4_2.inventory_extension
	local var_4_2 = arg_4_2.input_extension

	if var_4_1:equipment().wielded_slot == var_4_0 then
		return "done"
	elseif arg_4_3 > arg_4_2.node_timer + 0.3 then
		arg_4_2.node_timer = arg_4_3

		return "running", "evaluate"
	else
		var_4_2:wield(var_4_0)

		return "running"
	end
end
