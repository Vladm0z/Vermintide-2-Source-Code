-- chunkname: @scripts/imgui/imgui_craft_item.lua

ImguiCraftItem = class(ImguiCraftItem)

local var_0_0 = true
local var_0_1 = 20
local var_0_2 = 5
local var_0_3 = 300
local var_0_4 = 0.1
local var_0_5 = 1

ImguiCraftItem.init = function (arg_1_0)
	arg_1_0._properties = {}
	arg_1_0._traits = {}
	arg_1_0._skins = {}
	arg_1_0._types = {}
	arg_1_0._rarities = {
		"default",
		"plentiful",
		"common",
		"rare",
		"exotic",
		"unique",
		"magic"
	}
	arg_1_0._items_per_type = {}
	arg_1_0._power_level = 300
	arg_1_0._property_strength = 1
	arg_1_0._current_type = -1
	arg_1_0._current_item = -1
	arg_1_0._current_rarity = -1
	arg_1_0._current_skin = -1
	arg_1_0._current_property = -1
	arg_1_0._current_trait = -1
	arg_1_0._current_magic_level = 1
	arg_1_0._active_protperties = {}
	arg_1_0._active_traits = {}

	arg_1_0:_parse_master_list()
end

ImguiCraftItem.update = function (arg_2_0)
	if var_0_0 then
		arg_2_0:init()

		var_0_0 = false
	end
end

ImguiCraftItem.is_persistent = function (arg_3_0)
	return false
end

ImguiCraftItem.draw = function (arg_4_0, arg_4_1)
	local var_4_0 = Imgui.begin_window("Craft Item")

	Imgui.set_window_size(500, 335, "once")

	arg_4_0._power_level = math.floor(Imgui.slider_float("Power Level", arg_4_0._power_level, var_0_2, var_0_3))
	arg_4_0._current_type = Imgui.combo("Item Type", arg_4_0._current_type, arg_4_0._types, var_0_1)

	local var_4_1 = arg_4_0._current_type >= 0 and arg_4_0._types[arg_4_0._current_type]
	local var_4_2 = var_4_1 and arg_4_0._items_per_type[var_4_1] or {}

	arg_4_0._current_item = Imgui.combo("Item Name", arg_4_0._current_item, var_4_2, var_0_1)
	arg_4_0._current_rarity = Imgui.combo("Item Rarity", arg_4_0._current_rarity, arg_4_0._rarities, var_0_1)

	local var_4_3 = arg_4_0._current_item >= 0 and var_4_2[arg_4_0._current_item]
	local var_4_4 = arg_4_0:_get_skins_for_item(var_4_3)

	arg_4_0._current_skin = Imgui.combo("Item Skin", arg_4_0._current_skin, var_4_4, var_0_1)

	if arg_4_0._rarities[arg_4_0._current_rarity] == "magic" then
		local var_4_5 = Managers.backend:get_interface("weaves"):max_magic_level()

		arg_4_0._current_magic_level = math.floor(Imgui.slider_float("Magic Level", arg_4_0._current_magic_level, 1, var_4_5))
	end

	Imgui.separator()

	arg_4_0._property_strength = Imgui.slider_float("Property Strength", arg_4_0._property_strength, var_0_4, var_0_5)
	arg_4_0._current_property = Imgui.combo("Item Properties", arg_4_0._current_property, arg_4_0._properties, var_0_1)

	if Imgui.button("Add Property") then
		local var_4_6 = arg_4_0._current_property > 0 and arg_4_0._properties[arg_4_0._current_property]

		if var_4_6 then
			arg_4_0._active_protperties[var_4_6] = arg_4_0._property_strength
		end
	end

	Imgui.separator()

	arg_4_0._current_trait = Imgui.combo("Item Traits", arg_4_0._current_trait, arg_4_0._traits, var_0_1)

	if Imgui.button("Add Trait") then
		local var_4_7 = arg_4_0._current_trait > 0 and arg_4_0._traits[arg_4_0._current_trait]

		if var_4_7 then
			arg_4_0._active_traits[var_4_7] = true
		end
	end

	Imgui.separator()
	Imgui.text("Properties:")

	for iter_4_0, iter_4_1 in pairs(arg_4_0._active_protperties) do
		Imgui.tree_push(iter_4_0)
		Imgui.text(string.format("%32s : %.2f", iter_4_0, iter_4_1))
		Imgui.same_line()

		if Imgui.button("Remove") then
			arg_4_0._active_protperties[iter_4_0] = nil
		end

		Imgui.tree_pop()
	end

	Imgui.text("Traits:")

	for iter_4_2, iter_4_3 in pairs(arg_4_0._active_traits) do
		Imgui.tree_push(iter_4_2)
		Imgui.text(string.format("%48s", iter_4_2))
		Imgui.same_line()

		if Imgui.button("Remove") then
			arg_4_0._active_traits[iter_4_2] = nil
		end

		Imgui.tree_pop()
	end

	Imgui.separator()

	if Imgui.button("Add Item", 100, 20) and arg_4_0._current_rarity then
		local var_4_8 = arg_4_0._power_level
		local var_4_9 = arg_4_0._current_rarity > 0 and arg_4_0._rarities[arg_4_0._current_rarity]
		local var_4_10 = arg_4_0._current_skin > 0 and var_4_4[arg_4_0._current_skin]
		local var_4_11 = var_4_9 == "magic" and arg_4_0._current_magic_level

		arg_4_0:give_item(var_4_3, var_4_8, var_4_10, var_4_9, var_4_11, arg_4_0._active_protperties, arg_4_0._active_traits)
	end

	Imgui.end_window()

	return var_4_0
end

ImguiCraftItem.give_item = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
	if arg_5_1 and arg_5_2 then
		local var_5_0 = Managers.backend:get_interface("items")

		if var_5_0.award_custom_item then
			var_5_0:award_custom_item(arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
		end
	end
end

ImguiCraftItem._parse_master_list = function (arg_6_0)
	local var_6_0 = arg_6_0._types
	local var_6_1 = arg_6_0._items_per_type
	local var_6_2 = ItemMasterList

	for iter_6_0, iter_6_1 in pairs(var_6_2) do
		local var_6_3 = iter_6_1.slot_type

		if var_6_3 and not iter_6_1.is_local then
			if not table.contains(var_6_0, var_6_3) then
				table.insert(var_6_0, var_6_3)
			end

			if not var_6_1[var_6_3] then
				var_6_1[var_6_3] = {}
			end

			table.insert(var_6_1[var_6_3], iter_6_0)
		end
	end

	table.sort(var_6_0)

	for iter_6_2, iter_6_3 in pairs(var_6_1) do
		table.sort(var_6_1[iter_6_2])
	end

	local var_6_4 = WeaponProperties.properties

	for iter_6_4, iter_6_5 in pairs(var_6_4) do
		table.insert(arg_6_0._properties, iter_6_4)
	end

	table.sort(arg_6_0._properties)

	local var_6_5 = WeaponTraits.traits

	for iter_6_6, iter_6_7 in pairs(var_6_5) do
		table.insert(arg_6_0._traits, iter_6_6)
	end

	table.sort(arg_6_0._traits)
end

ImguiCraftItem._get_skins_for_item = function (arg_7_0, arg_7_1)
	if arg_7_1 then
		local var_7_0 = ItemMasterList[arg_7_1]
		local var_7_1 = var_7_0 and var_7_0.skin_combination_table
		local var_7_2 = var_7_1 and WeaponSkins.skin_combinations[var_7_1]
		local var_7_3 = {}

		if var_7_2 then
			for iter_7_0, iter_7_1 in pairs(var_7_2) do
				table.append(var_7_3, iter_7_1)
			end
		end

		table.sort(var_7_3)

		return var_7_3
	end

	return {}
end
