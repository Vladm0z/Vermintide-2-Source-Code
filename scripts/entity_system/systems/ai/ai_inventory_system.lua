-- chunkname: @scripts/entity_system/systems/ai/ai_inventory_system.lua

require("scripts/settings/ai_inventory_templates")
require("scripts/entity_system/systems/ai/ai_inventory_extension")

local tbl = {
	"rpc_ai_inventory_wield",
	"rpc_ai_drop_single_item",
	"rpc_ai_show_single_item"
}
local tbl_2 = {
	"AIInventoryExtension"
}

AIInventorySystem = class(AIInventorySystem, ExtensionSystemBase)

AIInventorySystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local entity_manager = arg_1_1.entity_manager

	entity_manager:register_system(self, arg_1_2, tbl_2)

	self.entity_manager = entity_manager
	self.is_server = arg_1_1.is_server
	self.world = arg_1_1.world
	self.unit_storage = arg_1_1.unit_storage

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.unit_extension_data = {}
	self.frozen_unit_extension_data = {}
	self.units_to_wield = {}
	self.units_to_wield_n = 0
	self.units_to_drop = {}
	self.units_to_drop_n = 0
	self.item_set_to_wield = {}
end

AIInventorySystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

AIInventorySystem.drop_item = function (self, arg_3_1)
	-- function 3
	self.units_to_drop_n = self.units_to_drop_n + 1
	self.units_to_drop[self.units_to_drop_n] = arg_3_1
end

local function fn(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	for i, v in ipairs(arg_4_0) do
		local source = v.source
		local target = v.target
		local node

		if type(source) == "string" then
			node = Unit.node(arg_4_3, source)

			if not node then
				-- Nothing
			end
		end

		node = source

		do
			local node_2
		end

		::label_4_0::

		if type(target) == "string" then
			node_2 = Unit.node(arg_4_2, target)

			if not node_2 then
				-- Nothing
			end
		end

		node_2 = target

		::label_4_1::

		World.link_unit(arg_4_1, arg_4_2, node_2, arg_4_3, node)
	end
end

local tbl_3 = {}

AIInventorySystem.on_add_extension = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local var_5_0

	fassert(next(arg_5_4) ~= nil, "AI's unit template specifies inventory extension but no init data was sent")

	arg_5_4.world = self.world
	arg_5_4.is_server = self.is_server

	local var_5_1 = AIInventoryExtension:new(arg_5_2, arg_5_4)

	ScriptUnit.set_extension(arg_5_2, "ai_inventory_system", var_5_1, tbl_3)

	self.unit_extension_data[arg_5_2] = var_5_1

	return var_5_1
end

AIInventorySystem.on_remove_extension = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_cleanup_extension(arg_6_1, arg_6_2)
	ScriptUnit.remove_extension(arg_6_1, self.NAME)
end

AIInventorySystem.on_freeze_extension = function (self, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = self._extensions[arg_7_1]

	fassert(var_7_0, "Unit was already frozen.")

	if var_7_0 == nil then
		return
	end

	self.frozen_unit_extension_data[arg_7_1] = var_7_0

	self:_cleanup_extension(arg_7_1, arg_7_2)
end

AIInventorySystem._cleanup_extension = function (self, arg_8_1, arg_8_2)
	-- function 8
	local units_to_wield = self.units_to_wield
	local units_to_wield_n = self.units_to_wield_n
	local num = 1

	while num <= units_to_wield_n do
		if arg_8_1 == units_to_wield[num] then
			units_to_wield[num] = units_to_wield[units_to_wield_n]
			units_to_wield_n = units_to_wield_n - 1
		else
			num = num + 1
		end
	end

	self.units_to_wield_n = units_to_wield_n

	local units_to_drop = self.units_to_drop
	local units_to_drop_n = self.units_to_drop_n
	local num_2 = 1

	while num_2 <= units_to_drop_n do
		if arg_8_1 == units_to_drop[num_2] then
			units_to_drop[num_2] = units_to_drop[units_to_drop_n]
			units_to_drop_n = units_to_drop_n - 1
		else
			num_2 = num_2 + 1
		end
	end

	self.units_to_drop_n = units_to_drop_n
end

AIInventorySystem.freeze = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local frozen_unit_extension_data = self.frozen_unit_extension_data

	if not frozen_unit_extension_data[arg_9_1] then
		return
	end

	local var_9_1 = self.unit_extension_data[arg_9_1]

	fassert(var_9_1, "Unit to freeze didn't have unfrozen extension")
	self:_cleanup_extension(arg_9_1, arg_9_2)

	self.unit_extension_data[arg_9_1] = nil
	frozen_unit_extension_data[arg_9_1] = var_9_1

	var_9_1:freeze()
end

AIInventorySystem.unfreeze = function (self, arg_10_1)
	-- function 10
	local var_10_0 = self.frozen_unit_extension_data[arg_10_1]

	fassert(var_10_0, "Unit to unfreeze didn't have frozen extension")

	self.frozen_unit_extension_data[arg_10_1] = nil
	self.unit_extension_data[arg_10_1] = var_10_0

	var_10_0:unfreeze()
end

AIInventorySystem.update = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local world = self.world
	local units_to_wield = self.units_to_wield
	local units_to_wield_n = self.units_to_wield_n

	for i = 1, units_to_wield_n do
		local var_11_3 = units_to_wield[i]
		local var_11_4 = self.unit_extension_data[var_11_3]
		local var_11_5
		local var_11_6
		local item_sets = var_11_4.item_sets

		if not item_sets then
			if not var_11_4.wielded then
				var_11_4:unwield_set(var_11_4.current_item_set_index)
			end

			local var_11_8 = self.item_set_to_wield[var_11_3]

			var_11_4.current_item_set_index = var_11_8

			local var_11_9 = item_sets[var_11_8]

			var_11_5, var_11_6 = var_11_9.start_index, not var_11_4.dropped and 0 and var_11_9.end_index
		else
			var_11_5, var_11_6 = 1, not var_11_4.dropped and 0 and var_11_4.inventory_items_n
		end

		var_11_4.wielded = true

		local inventory_item_definitions = var_11_4.inventory_item_definitions
		local inventory_item_units = var_11_4.inventory_item_units
		local flag

		flag = not var_11_4.dropped and 0 and var_11_4.inventory_items_n

		if not script_data.ai_debug_inventory then
			-- Nothing
		end

		for j = var_11_5, var_11_6 do
			local wielded = inventory_item_definitions[j].attachment_node_linking.wielded

			if not wielded then
				local var_11_14 = inventory_item_units[j]

				fn(wielded, world, var_11_14, var_11_3)
			end
		end

		local get_data = Unit.get_data(var_11_3, "breed")

		if not get_data and not get_data.on_weapon_wield then
			get_data.on_weapon_wield(var_11_3)
		end
	end

	self.units_to_wield_n = 0

	local units_to_drop = self.units_to_drop
	local units_to_drop_n = self.units_to_drop_n

	for k = 1, units_to_drop_n do
		local var_11_18 = units_to_drop[k]
		local var_11_19 = self.unit_extension_data[var_11_18]

		fassert(not var_11_19.dropped, "Tried to drop weapon twice")

		var_11_19.dropped = true

		local inventory_item_definitions_2 = var_11_19.inventory_item_definitions
		local inventory_items_n = var_11_19.inventory_items_n

		for l = 1, inventory_items_n do
			var_11_19:drop_single_item(l, "death")
		end
	end

	self.units_to_drop_n = 0
end

AIInventorySystem.rpc_ai_inventory_wield = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local unit = self.unit_storage:unit(arg_12_2)

	if unit == nil then
		return
	end

	if not self.frozen_unit_extension_data[unit] then
		return
	end

	self.units_to_wield_n = self.units_to_wield_n + 1
	self.units_to_wield[self.units_to_wield_n] = unit
	self.item_set_to_wield[unit] = arg_12_3
end

AIInventorySystem.rpc_ai_drop_single_item = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	local unit = self.unit_storage:unit(arg_13_2)

	if unit == nil then
		return
	end

	if not self.frozen_unit_extension_data[unit] then
		return
	end

	ScriptUnit.extension(unit, "ai_inventory_system"):drop_single_item(arg_13_3, NetworkLookup.item_drop_reasons[arg_13_4])
end

AIInventorySystem.rpc_ai_show_single_item = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	local unit = self.unit_storage:unit(arg_14_2)

	if unit == nil then
		return
	end

	if not self.frozen_unit_extension_data[unit] then
		return
	end

	ScriptUnit.extension(unit, "ai_inventory_system"):show_single_item(arg_14_3, arg_14_4)
end

AIInventorySystem.hot_join_sync = function (self, arg_15_1)
	-- function 15
	for k, v in pairs(self.unit_extension_data) do
		v:hot_join_sync(arg_15_1)
	end
end
