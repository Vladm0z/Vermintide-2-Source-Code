-- chunkname: @scripts/entity_system/systems/ai/ai_inventory_item_system.lua

local var_0_0 = {}
local var_0_1 = {
	"AIInventoryItemExtension"
}

AIInventoryItemSystem = class(AIInventoryItemSystem, ExtensionSystemBase)

AIInventoryItemSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.entity_manager

	var_1_0:register_system(arg_1_0, arg_1_2, var_0_1)

	arg_1_0.entity_manager = var_1_0
	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit_storage = arg_1_1.unit_storage

	local var_1_1 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_1

	var_1_1:register(arg_1_0, unpack(var_0_0))

	arg_1_0.entities = {}
end

AIInventoryItemSystem.destroy = function (arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
end

local var_0_2 = {}

AIInventoryItemSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = {}

	ScriptUnit.set_extension(arg_3_2, "ai_inventory_item_system", var_3_0, var_0_2)

	if arg_3_3 == "AIInventoryItemExtension" then
		arg_3_0.entities[arg_3_2] = var_3_0
		var_3_0.wielding_unit = arg_3_4.wielding_unit
	end

	return var_3_0
end

AIInventoryItemSystem.on_remove_extension = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.entities[arg_4_1] = nil

	ScriptUnit.remove_extension(arg_4_1, arg_4_0.NAME)
end

AIInventoryItemSystem.hot_join_sync = function (arg_5_0, arg_5_1)
	return
end

AIInventoryItemSystem.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	return
end
