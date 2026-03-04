-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_drop_pickup_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotDropPickupAction = class(BTBotDropPickupAction, BTNode)

BTBotDropPickupAction.init = function (arg_1_0, ...)
	BTBotDropPickupAction.super.init(arg_1_0, ...)
end

BTBotDropPickupAction.name = "BTBotDropPickupAction"

BTBotDropPickupAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.inventory_extension
	local var_2_1 = var_2_0:get_wielded_slot_name()
	local var_2_2 = var_2_0:get_slot_data(var_2_1).item_data
	local var_2_3 = BackendUtils.get_item_template(var_2_2)
	local var_2_4, var_2_5, var_2_6 = CharacterStateHelper.get_item_data_and_weapon_extensions(var_2_0)
	local var_2_7, var_2_8, var_2_9 = CharacterStateHelper.get_current_action_data(var_2_6, var_2_5)
	local var_2_10 = AiUtils.get_bot_weapon_extension(arg_2_2)

	arg_2_2.drop = {
		weapon_extension = var_2_10,
		wielded_item_template = var_2_3
	}
end

BTBotDropPickupAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.drop = nil
end

BTBotDropPickupAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.drop
	local var_4_1 = var_4_0.weapon_extension
	local var_4_2 = var_4_0.wielded_item_template
	local var_4_3 = "hold_attack"
	local var_4_4 = var_4_2.attack_meta_data[var_4_3]

	var_4_1:request_bot_attack_action(var_4_3, var_4_2.actions, var_4_2.name, var_4_4.attack_chain)

	return "running"
end
