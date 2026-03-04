-- chunkname: @scripts/managers/backend/backend_interface_loot.lua

require("scripts/managers/backend/data_server_queue")

local function var_0_0(...)
	print("[BackendInterfaceLoot]", ...)
end

BackendInterfaceLoot = class(BackendInterfaceLoot)

local var_0_1 = "item"

BackendInterfaceLoot.init = function (arg_2_0)
	return
end

BackendInterfaceLoot.setup = function (arg_3_0, arg_3_1)
	arg_3_0:_register_executors(arg_3_1)

	arg_3_0._queue = arg_3_1
	arg_3_0.dirty = false
	arg_3_0._attributes = {}
end

BackendInterfaceLoot._register_executors = function (arg_4_0, arg_4_1)
	arg_4_1:register_executor("loot_chest_generated", callback(arg_4_0, "_command_loot_chest_generated"))
	arg_4_1:register_executor("loot_chest_consumed", callback(arg_4_0, "_command_loot_chest_consumed"))
	arg_4_1:register_executor("weapon_with_properties_generated", callback(arg_4_0, "_command_weapon_with_properties_generated"))
end

BackendInterfaceLoot._command_loot_chest_generated = function (arg_5_0, arg_5_1)
	var_0_0("_command_loot_chest_generated ")

	arg_5_0.dirty = false
	arg_5_0.last_generated_loot_chest = Managers.backend:get_interface("items"):get_item_from_id(arg_5_1).key

	Backend.load_entities()
	arg_5_0:_refresh_attributes()
end

BackendInterfaceLoot._command_loot_chest_consumed = function (arg_6_0, arg_6_1)
	var_0_0("_command_loot_chest_consumed " .. arg_6_1)

	arg_6_0.dirty = false

	Backend.load_entities()
end

BackendInterfaceLoot._command_weapon_with_properties_generated = function (arg_7_0, arg_7_1)
	var_0_0("_command_weapon_with_properties_generated " .. arg_7_1)

	arg_7_0.dirty = false

	Backend.load_entities()
	arg_7_0:_refresh_attributes()
end

BackendInterfaceLoot.generate_loot_chest = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	arg_8_0._queue:add_item("generate_loot_chest_1", "hero_name", cjson.encode(arg_8_1), "difficulty", cjson.encode(arg_8_2), "tomes", cjson.encode(arg_8_3), "grimoires", cjson.encode(arg_8_4), "loot_dice", cjson.encode(arg_8_5), "level", cjson.encode(arg_8_6))

	arg_8_0.dirty = true
end

BackendInterfaceLoot.consume_loot_chest = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = ""

	fassert(arg_9_2, "Got nil item key to reward player")
	fassert(arg_9_3, "No properties found for item %s", arg_9_2)

	for iter_9_0, iter_9_1 in pairs(arg_9_3) do
		var_9_0 = var_9_0 .. iter_9_1.rune_slot .. ":" .. iter_9_1.property_key .. ",empty,"
	end

	arg_9_0._queue:add_item("consume_loot_chest_1", "entity_id", cjson.encode(arg_9_1), "item_key", cjson.encode(arg_9_2), "properties", cjson.encode(var_9_0))

	arg_9_0.dirty = true
end

BackendInterfaceLoot.generate_weapon_with_properties = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0._queue:add_item("generate_property_weapon", "item_key", cjson.encode(arg_10_1), "properties", cjson.encode(arg_10_2))

	arg_10_0.dirty = true
end

BackendInterfaceLoot._refresh_attributes = function (arg_11_0)
	local var_11_0 = Backend.get_entities_with_attributes(var_0_1)
	local var_11_1 = {}

	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		local var_11_2 = iter_11_1.attributes

		if var_11_2 then
			var_11_1[iter_11_0] = var_11_2
		end
	end

	arg_11_0._attributes = var_11_1
end

BackendInterfaceLoot.on_authenticated = function (arg_12_0)
	arg_12_0:_refresh_attributes()
end

BackendInterfaceLoot.get_loot = function (arg_13_0, arg_13_1)
	arg_13_0:_refresh_attributes()

	local var_13_0 = arg_13_0._attributes[arg_13_1]

	fassert(var_13_0, "[BackendInterfaceLoot:get_loot] Tried to get attributes from an item with no attributes", "error")

	local var_13_1 = {}

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		local var_13_2 = {}
		local var_13_3 = {}

		for iter_13_2, iter_13_3 in string.gmatch(iter_13_1, "([%w_]+),*([%w_]*);") do
			var_13_2.item_key = iter_13_2
			var_13_2.loot_type = iter_13_3
		end

		for iter_13_4, iter_13_5 in string.gmatch(iter_13_1, "([%w_]+):([%w_]+)") do
			var_13_3[#var_13_3 + 1] = {
				rune_value = "empty",
				rune_slot = iter_13_4,
				property_key = iter_13_5
			}
		end

		var_13_2.properties = var_13_3
		var_13_1[#var_13_1 + 1] = var_13_2
	end

	return var_13_1
end

BackendInterfaceLoot.is_dirty = function (arg_14_0)
	return arg_14_0.dirty
end

BackendInterfaceLoot.get_last_generated_loot_chest = function (arg_15_0)
	return arg_15_0.last_generated_loot_chest
end
