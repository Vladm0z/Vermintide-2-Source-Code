-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_drop_pickup_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotDropPickupAction = class(BTBotDropPickupAction, BTNode)

BTBotDropPickupAction.init = function (arg_1_0, ...)
	-- function 1
	BTBotDropPickupAction.super.init(arg_1_0, ...)
end

BTBotDropPickupAction.name = "BTBotDropPickupAction"

BTBotDropPickupAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local inventory_extension = arg_2_2.inventory_extension
	local get_wielded_slot_name = inventory_extension:get_wielded_slot_name()
	local item_data = inventory_extension:get_slot_data(get_wielded_slot_name).item_data
	local get_item_template = BackendUtils.get_item_template(item_data)
	local get_item_data_and_weapon_extensions, var_2_5, var_2_6 = CharacterStateHelper.get_item_data_and_weapon_extensions(inventory_extension)
	local get_current_action_data, var_2_8, var_2_9 = CharacterStateHelper.get_current_action_data(var_2_6, var_2_5)
	local get_bot_weapon_extension = AiUtils.get_bot_weapon_extension(arg_2_2)

	arg_2_2.drop = {
		weapon_extension = get_bot_weapon_extension,
		wielded_item_template = get_item_template
	}
end

BTBotDropPickupAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.drop = nil
end

BTBotDropPickupAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local drop = arg_4_2.drop
	local weapon_extension = drop.weapon_extension
	local wielded_item_template = drop.wielded_item_template
	local str = "hold_attack"
	local var_4_4 = wielded_item_template.attack_meta_data[str]

	weapon_extension:request_bot_attack_action(str, wielded_item_template.actions, wielded_item_template.name, var_4_4.attack_chain)

	return "running"
end
