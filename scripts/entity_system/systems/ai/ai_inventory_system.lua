-- chunkname: @scripts/entity_system/systems/ai/ai_inventory_system.lua

require("scripts/settings/ai_inventory_templates")
require("scripts/entity_system/systems/ai/ai_inventory_extension")

local var_0_0 = {
	"rpc_ai_inventory_wield",
	"rpc_ai_drop_single_item",
	"rpc_ai_show_single_item"
}
local var_0_1 = {
	"AIInventoryExtension"
}

AIInventorySystem = class(AIInventorySystem, ExtensionSystemBase)

AIInventorySystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.entity_manager

	var_1_0:register_system(arg_1_0, arg_1_2, var_0_1)

	arg_1_0.entity_manager = var_1_0
	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit_storage = arg_1_1.unit_storage

	local var_1_1 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_1

	var_1_1:register(arg_1_0, unpack(var_0_0))

	arg_1_0.unit_extension_data = {}
	arg_1_0.frozen_unit_extension_data = {}
	arg_1_0.units_to_wield = {}
	arg_1_0.units_to_wield_n = 0
	arg_1_0.units_to_drop = {}
	arg_1_0.units_to_drop_n = 0
	arg_1_0.item_set_to_wield = {}
end

AIInventorySystem.destroy = function (arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)
end

AIInventorySystem.drop_item = function (arg_3_0, arg_3_1)
	arg_3_0.units_to_drop_n = arg_3_0.units_to_drop_n + 1
	arg_3_0.units_to_drop[arg_3_0.units_to_drop_n] = arg_3_1
end

local function var_0_2(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	for iter_4_0, iter_4_1 in ipairs(arg_4_0) do
		local var_4_0 = iter_4_1.source
		local var_4_1 = iter_4_1.target
		local var_4_2 = type(var_4_0) == "string" and Unit.node(arg_4_3, var_4_0) or var_4_0
		local var_4_3 = type(var_4_1) == "string" and Unit.node(arg_4_2, var_4_1) or var_4_1

		World.link_unit(arg_4_1, arg_4_2, var_4_3, arg_4_3, var_4_2)
	end
end

local var_0_3 = {}

AIInventorySystem.on_add_extension = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0

	fassert(next(arg_5_4) ~= nil, "AI's unit template specifies inventory extension but no init data was sent")

	arg_5_4.world = arg_5_0.world
	arg_5_4.is_server = arg_5_0.is_server

	local var_5_1 = AIInventoryExtension:new(arg_5_2, arg_5_4)

	ScriptUnit.set_extension(arg_5_2, "ai_inventory_system", var_5_1, var_0_3)

	arg_5_0.unit_extension_data[arg_5_2] = var_5_1

	return var_5_1
end

AIInventorySystem.on_remove_extension = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:_cleanup_extension(arg_6_1, arg_6_2)
	ScriptUnit.remove_extension(arg_6_1, arg_6_0.NAME)
end

AIInventorySystem.on_freeze_extension = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._extensions[arg_7_1]

	fassert(var_7_0, "Unit was already frozen.")

	if var_7_0 == nil then
		return
	end

	arg_7_0.frozen_unit_extension_data[arg_7_1] = var_7_0

	arg_7_0:_cleanup_extension(arg_7_1, arg_7_2)
end

AIInventorySystem._cleanup_extension = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.units_to_wield
	local var_8_1 = arg_8_0.units_to_wield_n
	local var_8_2 = 1

	while var_8_2 <= var_8_1 do
		if arg_8_1 == var_8_0[var_8_2] then
			var_8_0[var_8_2] = var_8_0[var_8_1]
			var_8_1 = var_8_1 - 1
		else
			var_8_2 = var_8_2 + 1
		end
	end

	arg_8_0.units_to_wield_n = var_8_1

	local var_8_3 = arg_8_0.units_to_drop
	local var_8_4 = arg_8_0.units_to_drop_n
	local var_8_5 = 1

	while var_8_5 <= var_8_4 do
		if arg_8_1 == var_8_3[var_8_5] then
			var_8_3[var_8_5] = var_8_3[var_8_4]
			var_8_4 = var_8_4 - 1
		else
			var_8_5 = var_8_5 + 1
		end
	end

	arg_8_0.units_to_drop_n = var_8_4
end

AIInventorySystem.freeze = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0.frozen_unit_extension_data

	if var_9_0[arg_9_1] then
		return
	end

	local var_9_1 = arg_9_0.unit_extension_data[arg_9_1]

	fassert(var_9_1, "Unit to freeze didn't have unfrozen extension")
	arg_9_0:_cleanup_extension(arg_9_1, arg_9_2)

	arg_9_0.unit_extension_data[arg_9_1] = nil
	var_9_0[arg_9_1] = var_9_1

	var_9_1:freeze()
end

AIInventorySystem.unfreeze = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.frozen_unit_extension_data[arg_10_1]

	fassert(var_10_0, "Unit to unfreeze didn't have frozen extension")

	arg_10_0.frozen_unit_extension_data[arg_10_1] = nil
	arg_10_0.unit_extension_data[arg_10_1] = var_10_0

	var_10_0:unfreeze()
end

AIInventorySystem.update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_0.world
	local var_11_1 = arg_11_0.units_to_wield
	local var_11_2 = arg_11_0.units_to_wield_n

	for iter_11_0 = 1, var_11_2 do
		local var_11_3 = var_11_1[iter_11_0]
		local var_11_4 = arg_11_0.unit_extension_data[var_11_3]
		local var_11_5
		local var_11_6
		local var_11_7 = var_11_4.item_sets

		if var_11_7 then
			if var_11_4.wielded then
				var_11_4:unwield_set(var_11_4.current_item_set_index)
			end

			local var_11_8 = arg_11_0.item_set_to_wield[var_11_3]

			var_11_4.current_item_set_index = var_11_8

			local var_11_9 = var_11_7[var_11_8]

			var_11_5, var_11_6 = var_11_9.start_index, var_11_4.dropped and 0 or var_11_9.end_index
		else
			var_11_5, var_11_6 = 1, var_11_4.dropped and 0 or var_11_4.inventory_items_n
		end

		var_11_4.wielded = true

		local var_11_10 = var_11_4.inventory_item_definitions
		local var_11_11 = var_11_4.inventory_item_units
		local var_11_12

		var_11_12 = var_11_4.dropped and 0 or var_11_4.inventory_items_n

		if script_data.ai_debug_inventory then
			-- Nothing
		end

		for iter_11_1 = var_11_5, var_11_6 do
			local var_11_13 = var_11_10[iter_11_1].attachment_node_linking.wielded

			if var_11_13 then
				local var_11_14 = var_11_11[iter_11_1]

				var_0_2(var_11_13, var_11_0, var_11_14, var_11_3)
			end
		end

		local var_11_15 = Unit.get_data(var_11_3, "breed")

		if var_11_15 and var_11_15.on_weapon_wield then
			var_11_15.on_weapon_wield(var_11_3)
		end
	end

	arg_11_0.units_to_wield_n = 0

	local var_11_16 = arg_11_0.units_to_drop
	local var_11_17 = arg_11_0.units_to_drop_n

	for iter_11_2 = 1, var_11_17 do
		local var_11_18 = var_11_16[iter_11_2]
		local var_11_19 = arg_11_0.unit_extension_data[var_11_18]

		fassert(not var_11_19.dropped, "Tried to drop weapon twice")

		var_11_19.dropped = true

		local var_11_20 = var_11_19.inventory_item_definitions
		local var_11_21 = var_11_19.inventory_items_n

		for iter_11_3 = 1, var_11_21 do
			var_11_19:drop_single_item(iter_11_3, "death")
		end
	end

	arg_11_0.units_to_drop_n = 0
end

AIInventorySystem.rpc_ai_inventory_wield = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_0.unit_storage:unit(arg_12_2)

	if var_12_0 == nil then
		return
	end

	if arg_12_0.frozen_unit_extension_data[var_12_0] then
		return
	end

	arg_12_0.units_to_wield_n = arg_12_0.units_to_wield_n + 1
	arg_12_0.units_to_wield[arg_12_0.units_to_wield_n] = var_12_0
	arg_12_0.item_set_to_wield[var_12_0] = arg_12_3
end

AIInventorySystem.rpc_ai_drop_single_item = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	local var_13_0 = arg_13_0.unit_storage:unit(arg_13_2)

	if var_13_0 == nil then
		return
	end

	if arg_13_0.frozen_unit_extension_data[var_13_0] then
		return
	end

	ScriptUnit.extension(var_13_0, "ai_inventory_system"):drop_single_item(arg_13_3, NetworkLookup.item_drop_reasons[arg_13_4])
end

AIInventorySystem.rpc_ai_show_single_item = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	local var_14_0 = arg_14_0.unit_storage:unit(arg_14_2)

	if var_14_0 == nil then
		return
	end

	if arg_14_0.frozen_unit_extension_data[var_14_0] then
		return
	end

	ScriptUnit.extension(var_14_0, "ai_inventory_system"):show_single_item(arg_14_3, arg_14_4)
end

AIInventorySystem.hot_join_sync = function (arg_15_0, arg_15_1)
	for iter_15_0, iter_15_1 in pairs(arg_15_0.unit_extension_data) do
		iter_15_1:hot_join_sync(arg_15_1)
	end
end
