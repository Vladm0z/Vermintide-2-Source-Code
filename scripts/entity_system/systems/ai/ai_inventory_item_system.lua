-- chunkname: @scripts/entity_system/systems/ai/ai_inventory_item_system.lua

local tbl = {}
local tbl_2 = {
	"AIInventoryItemExtension"
}

AIInventoryItemSystem = class(AIInventoryItemSystem, ExtensionSystemBase)

AIInventoryItemSystem.init = function (self, arg_1_1, arg_1_2)
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

	self.entities = {}
end

AIInventoryItemSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)
end

local tbl_3 = {}

AIInventoryItemSystem.on_add_extension = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local tbl = {}

	ScriptUnit.set_extension(arg_3_2, "ai_inventory_item_system", tbl, tbl_3)

	if arg_3_3 == "AIInventoryItemExtension" then
		arg_3_0.entities[arg_3_2] = tbl
		tbl.wielding_unit = arg_3_4.wielding_unit
	end

	return tbl
end

AIInventoryItemSystem.on_remove_extension = function (self, arg_4_1, arg_4_2)
	-- function 4
	self.entities[arg_4_1] = nil

	ScriptUnit.remove_extension(arg_4_1, self.NAME)
end

AIInventoryItemSystem.hot_join_sync = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

AIInventoryItemSystem.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	return
end
