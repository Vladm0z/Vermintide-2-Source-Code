-- chunkname: @scripts/imgui/imgui_craft_item.lua

ImguiCraftItem = class(ImguiCraftItem)

local flag = true
local num = 20
local num_2 = 5
local num_3 = 300
local num_4 = 0.1
local num_5 = 1

ImguiCraftItem.init = function (self)
	-- function 1
	self._properties = {}
	self._traits = {}
	self._skins = {}
	self._types = {}
	self._rarities = {
		"default",
		"plentiful",
		"common",
		"rare",
		"exotic",
		"unique",
		"magic"
	}
	self._items_per_type = {}
	self._power_level = 300
	self._property_strength = 1
	self._current_type = -1
	self._current_item = -1
	self._current_rarity = -1
	self._current_skin = -1
	self._current_property = -1
	self._current_trait = -1
	self._current_magic_level = 1
	self._active_protperties = {}
	self._active_traits = {}

	self:_parse_master_list()
end

ImguiCraftItem.update = function (self)
	-- function 2
	if not flag then
		self:init()

		flag = false
	end
end

ImguiCraftItem.is_persistent = function (arg_3_0)
	-- function 3
	return false
end

ImguiCraftItem.draw = function (self, arg_4_1)
	-- function 4
	local begin_window = Imgui.begin_window("Craft Item")

	Imgui.set_window_size(500, 335, "once")

	self._power_level = math.floor(Imgui.slider_float("Power Level", self._power_level, num_2, num_3))
	self._current_type = Imgui.combo("Item Type", self._current_type, self._types, num)

	local flag = not (self._current_type >= 0) or self._types[self._current_type]
	local var_4_2

	if not flag then
		var_4_2 = self._items_per_type[flag]

		if not var_4_2 then
			-- Nothing
		end
	end

	var_4_2 = {}

	::label_4_0::

	self._current_item = Imgui.combo("Item Name", self._current_item, var_4_2, num)
	self._current_rarity = Imgui.combo("Item Rarity", self._current_rarity, self._rarities, num)

	local flag_2 = not (self._current_item >= 0) or var_4_2[self._current_item]
	local _get_skins_for_item = self:_get_skins_for_item(flag_2)

	self._current_skin = Imgui.combo("Item Skin", self._current_skin, _get_skins_for_item, num)

	if self._rarities[self._current_rarity] == "magic" then
		local max_magic_level = Managers.backend:get_interface("weaves"):max_magic_level()

		self._current_magic_level = math.floor(Imgui.slider_float("Magic Level", self._current_magic_level, 1, max_magic_level))
	end

	Imgui.separator()

	self._property_strength = Imgui.slider_float("Property Strength", self._property_strength, num_4, num_5)
	self._current_property = Imgui.combo("Item Properties", self._current_property, self._properties, num)

	if not Imgui.button("Add Property") then
		local flag_3 = not (self._current_property > 0) or self._properties[self._current_property]

		if not flag_3 then
			self._active_protperties[flag_3] = self._property_strength
		end
	end

	Imgui.separator()

	self._current_trait = Imgui.combo("Item Traits", self._current_trait, self._traits, num)

	if not Imgui.button("Add Trait") then
		local flag_4 = not (self._current_trait > 0) or self._traits[self._current_trait]

		if not flag_4 then
			self._active_traits[flag_4] = true
		end
	end

	Imgui.separator()
	Imgui.text("Properties:")

	for k, v in pairs(self._active_protperties) do
		Imgui.tree_push(k)
		Imgui.text(string.format("%32s : %.2f", k, v))
		Imgui.same_line()

		if not Imgui.button("Remove") then
			self._active_protperties[k] = nil
		end

		Imgui.tree_pop()
	end

	Imgui.text("Traits:")

	for k_2, v_2 in pairs(self._active_traits) do
		Imgui.tree_push(k_2)
		Imgui.text(string.format("%48s", k_2))
		Imgui.same_line()

		if not Imgui.button("Remove") then
			self._active_traits[k_2] = nil
		end

		Imgui.tree_pop()
	end

	Imgui.separator()

	if not Imgui.button("Add Item", 100, 20) and not self._current_rarity then
		local _power_level = self._power_level
		local flag_5 = not (self._current_rarity > 0) or self._rarities[self._current_rarity]
		local flag_6 = not (self._current_skin > 0) or _get_skins_for_item[self._current_skin]
		local flag_7 = flag_5 ~= "magic" or self._current_magic_level

		self:give_item(flag_2, _power_level, flag_6, flag_5, flag_7, self._active_protperties, self._active_traits)
	end

	Imgui.end_window()

	return begin_window
end

ImguiCraftItem.give_item = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
	-- function 5
	if not arg_5_1 and not arg_5_2 then
		local get_interface = Managers.backend:get_interface("items")

		if not get_interface.award_custom_item then
			get_interface:award_custom_item(arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
		end
	end
end

ImguiCraftItem._parse_master_list = function (self)
	-- function 6
	local _types = self._types
	local _items_per_type = self._items_per_type
	local ItemMasterList = ItemMasterList

	for k, v in pairs(ItemMasterList) do
		local slot_type = v.slot_type

		if not (not slot_type and v.is_local) then
			if not table.contains(_types, slot_type) then
				table.insert(_types, slot_type)
			end

			if not _items_per_type[slot_type] then
				_items_per_type[slot_type] = {}
			end

			table.insert(_items_per_type[slot_type], k)
		end
	end

	table.sort(_types)

	for k_2, v_2 in pairs(_items_per_type) do
		table.sort(_items_per_type[k_2])
	end

	local properties = WeaponProperties.properties

	for k_3, v_3 in pairs(properties) do
		table.insert(self._properties, k_3)
	end

	table.sort(self._properties)

	local traits = WeaponTraits.traits

	for k_4, v_4 in pairs(traits) do
		table.insert(self._traits, k_4)
	end

	table.sort(self._traits)
end

ImguiCraftItem._get_skins_for_item = function (arg_7_0, arg_7_1)
	-- function 7
	if not arg_7_1 then
		local var_7_0 = ItemMasterList[arg_7_1]
		local flag = not var_7_0 and var_7_0.skin_combination_table
		local flag_2 = not flag and WeaponSkins.skin_combinations[flag]
		local tbl = {}

		if not flag_2 then
			for k, v in pairs(flag_2) do
				table.append(tbl, v)
			end
		end

		table.sort(tbl)

		return tbl
	end

	return {}
end
