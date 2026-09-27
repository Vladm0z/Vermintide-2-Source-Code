-- chunkname: @scripts/imgui/imgui_ui_asset_test.lua

ImguiUIAssetCheck = class(ImguiUIAssetCheck)

local Gui = Gui
local Imgui = Imgui
local flag = true
local tbl = {
	frame = true,
	weapon_skin = true,
	bundle = true,
	trinket = true,
	melee = true,
	skin = true,
	hat = true,
	ranged = true,
	charm = true
}

ImguiUIAssetCheck.init = function (self)
	-- function 1
	self._active = false
	self._first_launch = true
	self._missing_asset_items_list = {}
	self._show_test_items = false
	self._show_bundles = true
	self._show_frames = true
	self._show_weapon_skin = true
	self._show_skin = true
	self._show_ranged = true
	self._show_hat = true
	self._show_trinket = true
	self._show_charm = true
	self._show_melee = true
end

ImguiUIAssetCheck.update = function (self)
	-- function 2
	if not flag then
		self:init()

		flag = false
	end
end

ImguiUIAssetCheck.on_show = function (self)
	-- function 3
	self._active = true
end

ImguiUIAssetCheck.on_hide = function (self)
	-- function 4
	self._active = false
end

ImguiUIAssetCheck.draw = function (self, arg_5_1)
	-- function 5
	local _do_main_window = self:_do_main_window()

	self:_do_preview_window()

	return _do_main_window
end

ImguiUIAssetCheck.is_persistent = function (arg_6_0)
	-- function 6
	return true
end

ImguiUIAssetCheck._do_main_window = function (self)
	-- function 7
	if not self._first_launch then
		local resolution, var_7_1 = Application.resolution()

		Imgui.set_next_window_size(resolution * 0.4, var_7_1 * 0.7)
	end

	local begin_window = Imgui.begin_window("UI Items Asset Ckeck", "menu_bar")

	Imgui.separator()
	Imgui.dummy(2, 5)
	Imgui.text_colored("Check Items", 245, 245, 207, 255)
	self:_do_filter_settings()

	if not Imgui.button("Do Check", 250, 35) then
		self:_do_asset_check()
	end

	Imgui:end_window()

	return begin_window
end

ImguiUIAssetCheck._do_preview_window = function (self)
	-- function 8
	if not self._first_launch then
		local resolution, var_8_1 = Application.resolution()

		Imgui.set_next_window_size(resolution * 0.4, var_8_1 * 0.7)

		local get_window_pos, var_8_3 = Imgui.get_window_pos()

		Imgui.set_next_window_pos(get_window_pos + resolution * 0.4 + 20, var_8_3)

		self._first_launch = false
	end

	local begin_window, var_8_5 = Imgui.begin_window("UI Asset Check Preview", "menu_bar")

	Imgui.separator()
	Imgui.dummy(2, 5)
	Imgui.text_colored("Items Preview", 245, 245, 207, 255)

	if not table.is_empty(self._missing_asset_items_list) then
		self:_do_preview()
	end

	Imgui:end_window()
end

ImguiUIAssetCheck._do_filter_settings = function (self)
	-- function 9
	self._show_test_items = Imgui.checkbox("Show Test Items", self._show_test_items)
	self._show_bundles = Imgui.checkbox("Show Bundles", self._show_bundles)
	self._show_frames = Imgui.checkbox("show Frames", self._show_frames)
	self._show_weapon_skin = Imgui.checkbox("show Weapon Skin", self._show_weapon_skin)
	self._show_skin = Imgui.checkbox("show Skin", self._show_skin)
	self._show_ranged = Imgui.checkbox("show Ranged", self._show_ranged)
	self._show_hat = Imgui.checkbox("show Hat", self._show_hat)
	self._show_trinket = Imgui.checkbox("show Trinket", self._show_trinket)
	self._show_charm = Imgui.checkbox("show Charm", self._show_charm)
	self._show_melee = Imgui.checkbox("show Melee", self._show_melee)
	tbl.bundle = self._ignore_bundles
	tbl.frame = self._show_frames
	tbl.weapon_skin = self._show_weapon_skin
	tbl.skin = self._show_skin
	tbl.ranged = self._show_ranged
	tbl.trinket = self._show_trinket
	tbl.hat = self._show_hat
	tbl.charm = self._show_charm
	tbl.melee = self._show_melee

	Imgui.dummy(2, 25)
end

ImguiUIAssetCheck._do_asset_check = function (self)
	-- function 10
	table.clear(self._missing_asset_items_list)

	for k, v in pairs(ItemMasterList) do
		if not v.slot_type and not tbl[v.slot_type] then
			local inventory_icon = v.inventory_icon
			local description = v.description
			local display_name = v.display_name
			local flag = inventory_icon == nil or inventory_icon ~= "icons_placeholder" or UIAtlasHelper.has_texture_by_name(inventory_icon)
			local flag_2 = not description and Managers.localizer:_base_lookup(description)
			local flag_3 = not display_name and Managers.localizer:_base_lookup(display_name)

			if not ((flag or not v.slot_type ~= "bundle" or not flag_2) and flag_3) then
				if not string.find(k, "test") and not self._show_test_items then
					self._missing_asset_items_list[k] = v
				elseif not (not string.find(k, "test") and self._show_test_items) then
					-- Nothing
				else
					self._missing_asset_items_list[k] = v
				end
			end
		end
	end
end

ImguiUIAssetCheck._should_add_item = function (arg_11_0, arg_11_1)
	-- function 11
	return
end

ImguiUIAssetCheck._do_preview = function (self)
	-- function 12
	for k, v in pairs(self._missing_asset_items_list) do
		Imgui.text_colored(k .. " : ", 0, 186, 112, 255)
		Imgui.dummy(2, 4)
		Imgui.text_colored("Icon", 0, 193, 212, 255)
		Imgui.same_line()

		if not (v.inventory_icon == nil or v.inventory_icon ~= "icons_placeholder" or UIAtlasHelper.has_texture_by_name(v.inventory_icon)) then
			Imgui.text_colored(tostring(v.inventory_icon), 245, 245, 207, 255)
		else
			Imgui.text_colored(tostring(v.inventory_icon), 220, 20, 60, 255)
		end

		Imgui.text_colored("Description", 0, 193, 212, 255)
		Imgui.same_line()

		local description = v.description

		description = not description and Managers.localizer:_base_lookup(v.description)

		if not description then
			Imgui.text_colored(Localize(v.description), 245, 245, 207, 255)
		else
			Imgui.text_colored(tostring(v.description), 220, 20, 60, 255)
		end

		Imgui.text_colored("Display Name", 0, 193, 212, 255)
		Imgui.same_line()

		local display_name = v.display_name

		display_name = not display_name and Managers.localizer:_base_lookup(v.display_name)

		if not display_name then
			Imgui.text_colored(Localize(v.display_name), 245, 245, 207, 255)
		else
			Imgui.text_colored(tostring(v.display_name), 220, 20, 60, 255)
		end

		if not Imgui.button("Save Item Name to Clipboard", 400, 20) then
			Clipboard.put(k)
		end

		Imgui.dummy(2, 4)
	end
end
