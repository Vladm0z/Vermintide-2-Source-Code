-- chunkname: @scripts/imgui/imgui_ui_asset_test.lua

ImguiUIAssetCheck = class(ImguiUIAssetCheck)

local var_0_0 = Gui
local var_0_1 = Imgui
local var_0_2 = true
local var_0_3 = {
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

ImguiUIAssetCheck.init = function (arg_1_0)
	arg_1_0._active = false
	arg_1_0._first_launch = true
	arg_1_0._missing_asset_items_list = {}
	arg_1_0._show_test_items = false
	arg_1_0._show_bundles = true
	arg_1_0._show_frames = true
	arg_1_0._show_weapon_skin = true
	arg_1_0._show_skin = true
	arg_1_0._show_ranged = true
	arg_1_0._show_hat = true
	arg_1_0._show_trinket = true
	arg_1_0._show_charm = true
	arg_1_0._show_melee = true
end

ImguiUIAssetCheck.update = function (arg_2_0)
	if var_0_2 then
		arg_2_0:init()

		var_0_2 = false
	end
end

ImguiUIAssetCheck.on_show = function (arg_3_0)
	arg_3_0._active = true
end

ImguiUIAssetCheck.on_hide = function (arg_4_0)
	arg_4_0._active = false
end

ImguiUIAssetCheck.draw = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:_do_main_window()

	arg_5_0:_do_preview_window()

	return var_5_0
end

ImguiUIAssetCheck.is_persistent = function (arg_6_0)
	return true
end

ImguiUIAssetCheck._do_main_window = function (arg_7_0)
	if arg_7_0._first_launch then
		local var_7_0, var_7_1 = Application.resolution()

		var_0_1.set_next_window_size(var_7_0 * 0.4, var_7_1 * 0.7)
	end

	local var_7_2 = var_0_1.begin_window("UI Items Asset Ckeck", "menu_bar")

	var_0_1.separator()
	var_0_1.dummy(2, 5)
	var_0_1.text_colored("Check Items", 245, 245, 207, 255)
	arg_7_0:_do_filter_settings()

	if var_0_1.button("Do Check", 250, 35) then
		arg_7_0:_do_asset_check()
	end

	var_0_1:end_window()

	return var_7_2
end

ImguiUIAssetCheck._do_preview_window = function (arg_8_0)
	if arg_8_0._first_launch then
		local var_8_0, var_8_1 = Application.resolution()

		var_0_1.set_next_window_size(var_8_0 * 0.4, var_8_1 * 0.7)

		local var_8_2, var_8_3 = var_0_1.get_window_pos()

		var_0_1.set_next_window_pos(var_8_2 + var_8_0 * 0.4 + 20, var_8_3)

		arg_8_0._first_launch = false
	end

	local var_8_4, var_8_5 = var_0_1.begin_window("UI Asset Check Preview", "menu_bar")

	var_0_1.separator()
	var_0_1.dummy(2, 5)
	var_0_1.text_colored("Items Preview", 245, 245, 207, 255)

	if not table.is_empty(arg_8_0._missing_asset_items_list) then
		arg_8_0:_do_preview()
	end

	var_0_1:end_window()
end

ImguiUIAssetCheck._do_filter_settings = function (arg_9_0)
	arg_9_0._show_test_items = var_0_1.checkbox("Show Test Items", arg_9_0._show_test_items)
	arg_9_0._show_bundles = var_0_1.checkbox("Show Bundles", arg_9_0._show_bundles)
	arg_9_0._show_frames = var_0_1.checkbox("show Frames", arg_9_0._show_frames)
	arg_9_0._show_weapon_skin = var_0_1.checkbox("show Weapon Skin", arg_9_0._show_weapon_skin)
	arg_9_0._show_skin = var_0_1.checkbox("show Skin", arg_9_0._show_skin)
	arg_9_0._show_ranged = var_0_1.checkbox("show Ranged", arg_9_0._show_ranged)
	arg_9_0._show_hat = var_0_1.checkbox("show Hat", arg_9_0._show_hat)
	arg_9_0._show_trinket = var_0_1.checkbox("show Trinket", arg_9_0._show_trinket)
	arg_9_0._show_charm = var_0_1.checkbox("show Charm", arg_9_0._show_charm)
	arg_9_0._show_melee = var_0_1.checkbox("show Melee", arg_9_0._show_melee)
	var_0_3.bundle = arg_9_0._ignore_bundles
	var_0_3.frame = arg_9_0._show_frames
	var_0_3.weapon_skin = arg_9_0._show_weapon_skin
	var_0_3.skin = arg_9_0._show_skin
	var_0_3.ranged = arg_9_0._show_ranged
	var_0_3.trinket = arg_9_0._show_trinket
	var_0_3.hat = arg_9_0._show_hat
	var_0_3.charm = arg_9_0._show_charm
	var_0_3.melee = arg_9_0._show_melee

	var_0_1.dummy(2, 25)
end

ImguiUIAssetCheck._do_asset_check = function (arg_10_0)
	table.clear(arg_10_0._missing_asset_items_list)

	for iter_10_0, iter_10_1 in pairs(ItemMasterList) do
		if iter_10_1.slot_type and var_0_3[iter_10_1.slot_type] then
			local var_10_0 = iter_10_1.inventory_icon
			local var_10_1 = iter_10_1.description
			local var_10_2 = iter_10_1.display_name
			local var_10_3 = var_10_0 ~= nil and (var_10_0 ~= "icons_placeholder" or UIAtlasHelper.has_texture_by_name(var_10_0))
			local var_10_4 = var_10_1 and Managers.localizer:_base_lookup(var_10_1)
			local var_10_5 = var_10_2 and Managers.localizer:_base_lookup(var_10_2)

			if not var_10_3 and not iter_10_1.slot_type == "bundle" or not var_10_4 or not var_10_5 then
				if string.find(iter_10_0, "test") and arg_10_0._show_test_items then
					arg_10_0._missing_asset_items_list[iter_10_0] = iter_10_1
				elseif string.find(iter_10_0, "test") and not arg_10_0._show_test_items then
					-- Nothing
				else
					arg_10_0._missing_asset_items_list[iter_10_0] = iter_10_1
				end
			end
		end
	end
end

ImguiUIAssetCheck._should_add_item = function (arg_11_0, arg_11_1)
	return
end

ImguiUIAssetCheck._do_preview = function (arg_12_0)
	for iter_12_0, iter_12_1 in pairs(arg_12_0._missing_asset_items_list) do
		var_0_1.text_colored(iter_12_0 .. " : ", 0, 186, 112, 255)
		var_0_1.dummy(2, 4)
		var_0_1.text_colored("Icon", 0, 193, 212, 255)
		var_0_1.same_line()

		if iter_12_1.inventory_icon ~= nil and (iter_12_1.inventory_icon ~= "icons_placeholder" or UIAtlasHelper.has_texture_by_name(iter_12_1.inventory_icon)) then
			var_0_1.text_colored(tostring(iter_12_1.inventory_icon), 245, 245, 207, 255)
		else
			var_0_1.text_colored(tostring(iter_12_1.inventory_icon), 220, 20, 60, 255)
		end

		var_0_1.text_colored("Description", 0, 193, 212, 255)
		var_0_1.same_line()

		if iter_12_1.description and Managers.localizer:_base_lookup(iter_12_1.description) then
			var_0_1.text_colored(Localize(iter_12_1.description), 245, 245, 207, 255)
		else
			var_0_1.text_colored(tostring(iter_12_1.description), 220, 20, 60, 255)
		end

		var_0_1.text_colored("Display Name", 0, 193, 212, 255)
		var_0_1.same_line()

		if iter_12_1.display_name and Managers.localizer:_base_lookup(iter_12_1.display_name) then
			var_0_1.text_colored(Localize(iter_12_1.display_name), 245, 245, 207, 255)
		else
			var_0_1.text_colored(tostring(iter_12_1.display_name), 220, 20, 60, 255)
		end

		if var_0_1.button("Save Item Name to Clipboard", 400, 20) then
			Clipboard.put(iter_12_0)
		end

		var_0_1.dummy(2, 4)
	end
end
