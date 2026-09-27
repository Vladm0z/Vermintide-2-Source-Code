-- chunkname: @scripts/managers/backend/backend_interface_loot.lua

require("scripts/managers/backend/data_server_queue")

local function fn(...)
	-- function 1
	print("[BackendInterfaceLoot]", ...)
end

BackendInterfaceLoot = class(BackendInterfaceLoot)

local str = "item"

BackendInterfaceLoot.init = function (arg_2_0)
	-- function 2
	return
end

BackendInterfaceLoot.setup = function (self, arg_3_1)
	-- function 3
	self:_register_executors(arg_3_1)

	self._queue = arg_3_1
	self.dirty = false
	self._attributes = {}
end

BackendInterfaceLoot._register_executors = function (arg_4_0, arg_4_1)
	-- function 4
	arg_4_1:register_executor("loot_chest_generated", callback(arg_4_0, "_command_loot_chest_generated"))
	arg_4_1:register_executor("loot_chest_consumed", callback(arg_4_0, "_command_loot_chest_consumed"))
	arg_4_1:register_executor("weapon_with_properties_generated", callback(arg_4_0, "_command_weapon_with_properties_generated"))
end

BackendInterfaceLoot._command_loot_chest_generated = function (self, arg_5_1)
	-- function 5
	fn("_command_loot_chest_generated ")

	self.dirty = false
	self.last_generated_loot_chest = Managers.backend:get_interface("items"):get_item_from_id(arg_5_1).key

	Backend.load_entities()
	self:_refresh_attributes()
end

BackendInterfaceLoot._command_loot_chest_consumed = function (self, arg_6_1)
	-- function 6
	fn("_command_loot_chest_consumed " .. arg_6_1)

	self.dirty = false

	Backend.load_entities()
end

BackendInterfaceLoot._command_weapon_with_properties_generated = function (self, arg_7_1)
	-- function 7
	fn("_command_weapon_with_properties_generated " .. arg_7_1)

	self.dirty = false

	Backend.load_entities()
	self:_refresh_attributes()
end

BackendInterfaceLoot.generate_loot_chest = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	-- function 8
	self._queue:add_item("generate_loot_chest_1", "hero_name", cjson.encode(arg_8_1), "difficulty", cjson.encode(arg_8_2), "tomes", cjson.encode(arg_8_3), "grimoires", cjson.encode(arg_8_4), "loot_dice", cjson.encode(arg_8_5), "level", cjson.encode(arg_8_6))

	self.dirty = true
end

BackendInterfaceLoot.consume_loot_chest = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local str = ""

	fassert(arg_9_2, "Got nil item key to reward player")
	fassert(arg_9_3, "No properties found for item %s", arg_9_2)

	for k, v in pairs(arg_9_3) do
		str = str .. v.rune_slot .. ":" .. v.property_key .. ",empty,"
	end

	self._queue:add_item("consume_loot_chest_1", "entity_id", cjson.encode(arg_9_1), "item_key", cjson.encode(arg_9_2), "properties", cjson.encode(str))

	self.dirty = true
end

BackendInterfaceLoot.generate_weapon_with_properties = function (self, arg_10_1, arg_10_2)
	-- function 10
	self._queue:add_item("generate_property_weapon", "item_key", cjson.encode(arg_10_1), "properties", cjson.encode(arg_10_2))

	self.dirty = true
end

BackendInterfaceLoot._refresh_attributes = function (self)
	-- function 11
	local get_entities_with_attributes = Backend.get_entities_with_attributes(str)
	local tbl = {}

	for k, v in pairs(get_entities_with_attributes) do
		local attributes = v.attributes

		if not attributes then
			tbl[k] = attributes
		end
	end

	self._attributes = tbl
end

BackendInterfaceLoot.on_authenticated = function (self)
	-- function 12
	self:_refresh_attributes()
end

BackendInterfaceLoot.get_loot = function (self, arg_13_1)
	-- function 13
	self:_refresh_attributes()

	local var_13_0 = self._attributes[arg_13_1]

	fassert(var_13_0, "[BackendInterfaceLoot:get_loot] Tried to get attributes from an item with no attributes", "error")

	local tbl = {}

	for k, v in pairs(var_13_0) do
		local tbl_2 = {}
		local tbl_3 = {}

		for iter_13_2, iter_13_3 in string.gmatch(v, "([%w_]+),*([%w_]*);") do
			tbl_2.item_key = iter_13_2
			tbl_2.loot_type = iter_13_3
		end

		for iter_13_4, iter_13_5 in string.gmatch(v, "([%w_]+):([%w_]+)") do
			tbl_3[#tbl_3 + 1] = {
				rune_value = "empty",
				rune_slot = iter_13_4,
				property_key = iter_13_5
			}
		end

		tbl_2.properties = tbl_3
		tbl[#tbl + 1] = tbl_2
	end

	return tbl
end

BackendInterfaceLoot.is_dirty = function (self)
	-- function 14
	return self.dirty
end

BackendInterfaceLoot.get_last_generated_loot_chest = function (self)
	-- function 15
	return self.last_generated_loot_chest
end
