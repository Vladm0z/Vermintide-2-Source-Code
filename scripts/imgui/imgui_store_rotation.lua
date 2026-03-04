-- chunkname: @scripts/imgui/imgui_store_rotation.lua

local var_0_0 = "    {\n        \"pages\": {\n          \"featured\": {\n            \"rotation_timestamp\": 1669633200,\n            \"display_name\": \"menu_store_panel_title_featured\",\n            \"grid\": [\n            ],\n            \"layout\": \"featured\",\n            \"slideshow\": [\n            ],\n            \"sound_event_enter\": \"Play_hud_store_category_front\"\n          },\n          \"dlc\": {\n            \"content\": [\n              \"ultimate_bundle\",\n              \"legacy_bundle\",\n              \"premium_career_bundle\",\n              \"premium_career_bundle_upgrade\",\n              \"shovel\",\n              \"shovel_upgrade\",\n              \"bless\",\n              \"bless_upgrade\",\n              \"woods\",\n              \"woods_upgrade\",\n              \"grass\",\n              \"cog\",\n              \"cog_upgrade\",\n              \"lake\",\n              \"lake_upgrade\",\n              \"scorpion\",\n              \"holly\",\n              \"bogenhafen\",\n              \"pre_order\"\n            ],\n            \"type\": \"dlc\",\n            \"display_name\": \"menu_store_panel_title_dlcs\",\n            \"layout\": \"dlc_list\",\n            \"sound_event_enter\": \"Play_hud_store_category_dlc\"\n          }\n        }\n      }\n"
local var_0_1 = "    {\n        \"featured\": {\n        },\n        \"discounts\" : {\n        }\n    }\n"
local var_0_2 = {
	[1] = "795750",
	[2] = "552500"
}
local var_0_3 = table.enum("slideshow", "featured", "discount")
local var_0_4 = "/.shop/imgui_store_tool_save_file.json"

ImguiStoreRotation = class(ImguiStoreRotation)

local var_0_5 = Imgui
local var_0_6 = true

ImguiStoreRotation.init = function (arg_1_0)
	arg_1_0._fp = nil
	arg_1_0._save_file = nil
	arg_1_0._first_launch = true

	arg_1_0:_load_saved_data()

	arg_1_0._item_keys_list = {}
	arg_1_0._layout_items = {}
	arg_1_0._slideshow_items = {}
	arg_1_0._dlc_list = {}
	arg_1_0._store_dlc_list = {}
	arg_1_0._search_type = var_0_3.featured

	arg_1_0:_setup_timpestamp_fields()

	arg_1_0._timestamp = 0

	arg_1_0:_setup_item_keys_list()
	arg_1_0:_setup_dlc_list()

	arg_1_0._item_search_results = table.clone(arg_1_0._item_keys_list)
	arg_1_0._searcheable_item_keys = {}

	arg_1_0:_filter_item_keys_list()

	arg_1_0._is_selecting_item = false
	arg_1_0._is_selecting_slideshow_item = false
	arg_1_0._selected_item_index = -1
	arg_1_0._item_search_text = ""
	arg_1_0._prio = 0
	arg_1_0._localize = false

	arg_1_0:_setup_layout_template()

	arg_1_0._appid = 795750
	arg_1_0._appid_idx = 1
	arg_1_0._is_selecting_discount_item = false
	arg_1_0._discount_amount = 0
	arg_1_0._discounted_items = {}
	arg_1_0._has_error_discount = false

	arg_1_0:_setup_discount_begin_end_date()

	arg_1_0._backend_store = Managers.backend:get_interface("peddler")
	arg_1_0._itemdef_filename = ""
	arg_1_0._all_feature_items = {}
	arg_1_0._all_slideshow_items = {}
	arg_1_0._missing_file_name = nil
	arg_1_0._timestamp_error = nil
	arg_1_0._tabs = {
		"Feature Page Rotation",
		"Store Discounts",
		"Store Item Utility"
	}
	arg_1_0._selected_tab = arg_1_0._tabs[1]
	arg_1_0._save_successful_discount = ""
	arg_1_0._save_successful_featured = ""
	arg_1_0._cosmetic_items = {}

	arg_1_0:_collect_cosmetic_items_data()
end

ImguiStoreRotation._cleanup_slideshow = function (arg_2_0)
	local var_2_0 = {}
	local var_2_1 = {}

	for iter_2_0 = 1, #arg_2_0._item_keys_list do
		local var_2_2 = arg_2_0._item_keys_list[iter_2_0]
		local var_2_3 = arg_2_0:_is_a_dlc(var_2_2)
		local var_2_4 = var_2_3 and StoreDlcSettingsByName[var_2_2] or rawget(ItemMasterList, var_2_2)

		if not var_2_4 or var_2_4.item_type ~= "bundle" and not var_2_3 and not var_2_4.store_bundle_big_image then
			-- Nothing
		elseif var_2_4.item_type == "bundle" or var_2_3 then
			var_2_0[#var_2_0 + 1] = var_2_2
		end
	end

	arg_2_0._slideshow_item_keys = var_2_0
end

ImguiStoreRotation._filter_item_keys_list = function (arg_3_0)
	local var_3_0 = {}
	local var_3_1 = {}
	local var_3_2 = {}

	for iter_3_0 = 1, #arg_3_0._item_keys_list do
		local var_3_3 = arg_3_0._item_keys_list[iter_3_0]
		local var_3_4 = arg_3_0:_is_a_dlc(var_3_3)
		local var_3_5 = var_3_4 and StoreDlcSettingsByName[var_3_3] or rawget(ItemMasterList, var_3_3)

		if not var_3_5 or var_3_5.item_type == "deed" then
			-- Nothing
		else
			if var_3_5.item_type == "bundle" or var_3_4 then
				var_3_0[#var_3_0 + 1] = var_3_3
				var_3_1[#var_3_1 + 1] = var_3_3
			else
				var_3_1[#var_3_1 + 1] = var_3_3
			end

			if var_3_5.steam_itemdefid or var_3_5.current_prices then
				var_3_2[#var_3_2 + 1] = var_3_3
			end
		end
	end

	arg_3_0._searcheable_item_keys.slideshow = var_3_0
	arg_3_0._searcheable_item_keys.featured = var_3_1
	arg_3_0._searcheable_item_keys.discount = var_3_2
end

ImguiStoreRotation._load_saved_data = function (arg_4_0)
	arg_4_0._save_data = {}

	if script_data.source_dir then
		local var_4_0 = script_data.source_dir .. var_0_4

		arg_4_0._save_file = io.open(var_4_0, "r")

		if arg_4_0._save_file then
			local var_4_1 = arg_4_0._save_file:read("*all")

			arg_4_0._save_data = cjson.decode(var_4_1)

			arg_4_0._save_file:close()
		else
			arg_4_0._save_data = cjson.decode(var_0_1)
		end
	else
		Application.warning("[ImguiStoreRotation] script_data.source_dir is nil, cannot load store rotation settings, using default!")

		arg_4_0._save_data = cjson.decode(var_0_1)
	end
end

ImguiStoreRotation._save_settings = function (arg_5_0)
	arg_5_0._save_data.featured.end_year = arg_5_0._timestamp_year
	arg_5_0._save_data.featured.end_month = arg_5_0._timestamp_month
	arg_5_0._save_data.featured.end_day = arg_5_0._timestamp_day
	arg_5_0._save_data.featured.timestamp = arg_5_0._timestamp
	arg_5_0._save_data.discounts.end_year = arg_5_0._end_discount_year
	arg_5_0._save_data.discounts.end_month = arg_5_0._end_discount_month
	arg_5_0._save_data.discounts.end_day = arg_5_0._end_discount_day

	local var_5_0 = cjson.encode(arg_5_0._save_data)

	if script_data.source_dir then
		local var_5_1 = script_data.source_dir .. var_0_4
		local var_5_2 = assert(io.open(var_5_1, "w"))

		var_5_2:write(var_5_0)
		var_5_2:close()
	else
		Application.warning("[ImguiStoreRotation] script_data.source_dir is nil, cannot save store rotation settings!")
	end
end

ImguiStoreRotation._setup_timpestamp_fields = function (arg_6_0)
	arg_6_0._timestamp_year = arg_6_0._save_data.featured.end_year and arg_6_0._save_data.featured.end_year or os.date("%Y")
	arg_6_0._timestamp_month = arg_6_0._save_data.featured.end_month and arg_6_0._save_data.featured.end_month or os.date("%m")
	arg_6_0._timestamp_day = arg_6_0._save_data.featured.end_day and arg_6_0._save_data.featured.end_day or os.date("%d")
	arg_6_0._timestamp_hour = "12"
	arg_6_0._timestamp_minutes = "00"
	arg_6_0._timestamp_seconds = "00"
	arg_6_0._timestamp = arg_6_0._save_data.featured.timestamp and arg_6_0._save_data.featured.timestamp or 0
	arg_6_0._new_rotation_file_name = string.format("layout_%s_%s_%s", os.date("%Y"), os.date("%m"), os.date("%d"))
	arg_6_0._new_discount_file_name = string.format("rotation_%s_%s_%s", os.date("%Y"), os.date("%m"), os.date("%d"))
end

ImguiStoreRotation._setup_discount_begin_end_date = function (arg_7_0)
	arg_7_0._begin_discount_year = os.date("%Y")
	arg_7_0._begin_discount_month = os.date("%m")
	arg_7_0._begin_discount_day = os.date("%d")
	arg_7_0._end_discount_year = arg_7_0._save_data.discounts.end_year and arg_7_0._save_data.discounts.end_year or "00"
	arg_7_0._end_discount_month = arg_7_0._save_data.discounts.end_month and arg_7_0._save_data.discounts.end_month or "00"
	arg_7_0._end_discount_day = arg_7_0._save_data.discounts.end_day and arg_7_0._save_data.discounts.end_day or "00"
end

ImguiStoreRotation._setup_layout_template = function (arg_8_0)
	local var_8_0 = cjson.decode(var_0_0)

	if var_8_0 then
		arg_8_0._lua_layout = var_8_0
	end
end

ImguiStoreRotation._setup_item_keys_list = function (arg_9_0)
	table.clear(arg_9_0._item_keys_list)

	arg_9_0._item_keys_list = table.keys(ItemMasterList)

	table.sort(arg_9_0._item_keys_list)
end

ImguiStoreRotation._setup_dlc_list = function (arg_10_0)
	local var_10_0 = 0

	table.clear(arg_10_0._dlc_list)

	for iter_10_0, iter_10_1 in ipairs(UnlockSettings) do
		for iter_10_2, iter_10_3 in pairs(iter_10_1.unlocks) do
			var_10_0 = var_10_0 + 1
			arg_10_0._dlc_list[var_10_0] = iter_10_2
		end
	end

	table.sort(arg_10_0._dlc_list)
	table.append(arg_10_0._item_keys_list, arg_10_0._dlc_list)
end

ImguiStoreRotation.is_persistent = function (arg_11_0)
	return false
end

ImguiStoreRotation.update = function (arg_12_0)
	if var_0_6 then
		arg_12_0:init()

		var_0_6 = false
	end
end

ImguiStoreRotation.draw = function (arg_13_0, arg_13_1)
	if arg_13_0._first_launch then
		local var_13_0, var_13_1 = Application.resolution()

		var_0_5.set_next_window_size(var_13_0 * 0.8, var_13_1 * 0.8)

		arg_13_0._first_launch = false
	end

	local var_13_2 = var_0_5.begin_window("Create Store Rotation", "menu_bar")

	var_0_5.text("This is the store rotation tool!!")
	var_0_5.separator()

	if var_0_5.begin_menu_bar() then
		for iter_13_0, iter_13_1 in ipairs(arg_13_0._tabs) do
			local var_13_3 = arg_13_0._selected_tab ~= iter_13_1 and " " .. iter_13_1 .. " " or "[" .. iter_13_1 .. "]"

			if var_0_5.menu_item(var_13_3) then
				arg_13_0._selected_tab = iter_13_1
			end
		end

		var_0_5.end_menu_bar()
	end

	var_0_5.begin_child_window("child_window", 0, 0, true)

	if arg_13_0._selected_tab == "Feature Page Rotation" then
		arg_13_0:_featured_page_tab()
	elseif arg_13_0._selected_tab == "Store Discounts" then
		arg_13_0:_store_rotation_discounts_tab()
	elseif arg_13_0._selected_tab == "Store Item Utility" then
		arg_13_0:_store_item_utility_tab()
	end

	var_0_5.end_child_window()
	var_0_5:end_window()

	return var_13_2
end

ImguiStoreRotation._featured_page_tab = function (arg_14_0)
	arg_14_0:_do_new_file_name()
	arg_14_0:_do_timestamp_settings()
	var_0_5.text("Timestamp: ")
	var_0_5.same_line()
	var_0_5.text_colored(arg_14_0._timestamp, 44, 192, 133, 255)
	var_0_5.separator()
	var_0_5.columns(2, true)
	arg_14_0:_do_edit_buttons()
	arg_14_0:_do_clear_edit_buttons()
	arg_14_0:_do_save_file_button()

	if arg_14_0._save_successful_featured ~= "" then
		var_0_5.text_colored(arg_14_0._save_successful_featured, 255, 196, 0, 255)
	end

	var_0_5.next_column()
	var_0_5.text("Content Preview")
	var_0_5.separator()
	arg_14_0:_draw_layout_slideshow_preview()
	var_0_5.next_column()
	arg_14_0:_handle_error_messages()
end

ImguiStoreRotation._do_edit_buttons = function (arg_15_0)
	var_0_5.text("Edit Feature Page Layout and Slideshow Composition")
	var_0_5.dummy(2, 10)

	arg_15_0._localize = var_0_5.checkbox("Localize headers and descriptions in the preview", arg_15_0._localize)

	var_0_5.dummy(2, 10)
	var_0_5.text_colored("EDIT FEATURED PAGE:", 245, 245, 207, 255)
	var_0_5.dummy(2, 5)
	var_0_5.text("Edit Slideshow")
	var_0_5.text_colored("Add the items that will be displayed in the Store Featured Page Slideshow :", 245, 245, 207, 255)

	if var_0_5.button("ADD Slideshow Item", 200, 20) then
		arg_15_0._is_selecting_slideshow_item = true
		arg_15_0._is_selecting_item = false

		arg_15_0:_on_search_type_changed(var_0_3.slideshow)
	end

	if arg_15_0._is_selecting_slideshow_item then
		arg_15_0:_draw_item_selection()

		if arg_15_0._selected_item_index ~= -1 then
			local var_15_0 = arg_15_0._item_search_results[arg_15_0._selected_item_index]

			arg_15_0._slideshow_items[#arg_15_0._slideshow_items + 1] = arg_15_0:_get_slideshow_item(var_15_0)
			arg_15_0._is_selecting_slideshow_item = false
			arg_15_0._selected_item_index = -1
			arg_15_0._item_search_text = ""
		end
	end

	if var_0_5.button("REMOVE LAST Slideshow Item", 200, 20) then
		arg_15_0:_remove_last_added_item(arg_15_0._slideshow_items)
	end

	var_0_5.dummy(2, 10)
	var_0_5.text("Edit Featured Items")
	var_0_5.text_colored("Add the items to highlight as featured in the Store Featured Page :", 245, 245, 207, 255)

	if var_0_5.button("ADD Featured Item", 200, 20) then
		arg_15_0._is_selecting_item = true
		arg_15_0._is_selecting_slideshow_item = false

		arg_15_0:_on_search_type_changed(var_0_3.featured)
	end

	if arg_15_0._is_selecting_item then
		arg_15_0:_draw_item_selection()

		if arg_15_0._selected_item_index ~= -1 then
			local var_15_1 = arg_15_0._item_search_results[arg_15_0._selected_item_index]

			arg_15_0._layout_items[#arg_15_0._layout_items + 1] = arg_15_0:_get_layout_item(var_15_1)
			arg_15_0._is_selecting_item = false
			arg_15_0._selected_item_index = -1
			arg_15_0._item_search_text = ""
		end
	end

	if var_0_5.button("REMOVE LAST Featured Item", 200, 20) then
		arg_15_0:_remove_last_added_item(arg_15_0._layout_items)
	end
end

ImguiStoreRotation._do_item_selection = function (arg_16_0)
	if arg_16_0._is_selecting_item or arg_16_0._is_selecting_slideshow_item then
		arg_16_0:_draw_item_selection()

		if arg_16_0._selected_item_index ~= -1 then
			local var_16_0 = arg_16_0._item_search_results[arg_16_0._selected_item_index]

			if arg_16_0._is_selecting_item then
				arg_16_0._layout_items[#arg_16_0._layout_items + 1] = arg_16_0:_get_layout_item(var_16_0)
				arg_16_0._is_selecting_item = false
			end

			if arg_16_0._is_selecting_slideshow_item then
				arg_16_0._slideshow_items[#arg_16_0._slideshow_items + 1] = arg_16_0:_get_slideshow_item(var_16_0)
				arg_16_0._is_selecting_slideshow_item = false
			end

			arg_16_0._selected_item_index = -1
			arg_16_0._item_search_text = ""
		end
	end
end

ImguiStoreRotation._do_save_file_button = function (arg_17_0)
	var_0_5.dummy(2, 10)
	var_0_5.text("Preview the featured page rotation, before saving your changes and uploading them.")

	if var_0_5.button("PREVIEW CHANGES", 250, 35) then
		arg_17_0:_preview_changes()
	end

	var_0_5.dummy(2, 10)
	var_0_5.text("Save the edits to the feature page layout in to a file.")

	if var_0_5.button("SAVE FILE AND COPY TO CLIPBOARD", 250, 50) then
		arg_17_0:_save_to_file()
	end

	var_0_5.text("All the edits will be copied to the clipboard as text.")
end

ImguiStoreRotation._preview_changes = function (arg_18_0)
	local var_18_0 = Managers.backend:get_interface("peddler")

	if var_18_0:has_force_override() then
		return
	end

	local var_18_1 = false
	local var_18_2, var_18_3 = arg_18_0:_calculate_timestamp(arg_18_0._timestamp_year, arg_18_0._timestamp_month, arg_18_0._timestamp_day, arg_18_0._timestamp_hour, arg_18_0._timestamp_minutes, arg_18_0._timestamp_seconds)

	if not var_18_3 then
		arg_18_0._timestamp_error = true
		var_18_1 = true
	end

	if not var_18_1 then
		arg_18_0._timestamp = var_18_2
		arg_18_0._lua_layout.pages.featured.rotation_timestamp = arg_18_0._timestamp

		arg_18_0:_save_layout_items(arg_18_0._layout_items)
		arg_18_0:_save_slideshow_items(arg_18_0._slideshow_items)

		local var_18_4 = arg_18_0._lua_layout
		local var_18_5 = cjson.encode(var_18_4)

		var_18_0:force_layout_override(var_18_5)
	end
end

ImguiStoreRotation._draw_layout_slideshow_preview = function (arg_19_0)
	var_0_5.dummy(2, 10)
	var_0_5.text_colored("LAYOUT ITEMS: " .. tostring(#arg_19_0._layout_items), 0, 179, 255, 255)
	var_0_5.dummy(2, 10)

	if #arg_19_0._layout_items ~= 0 then
		arg_19_0:_draw_selcted_layout_items(arg_19_0._layout_items)
	end

	var_0_5.text_colored("SLIDESHOW ITEMS: " .. tostring(#arg_19_0._slideshow_items), 0, 179, 255, 255)
	var_0_5.dummy(2, 10)

	if #arg_19_0._slideshow_items ~= 0 then
		arg_19_0:_draw_selcted_slideshow_items(arg_19_0._slideshow_items)
	end
end

ImguiStoreRotation._do_new_file_name = function (arg_20_0)
	arg_20_0._new_rotation_file_name = var_0_5.input_text("New Rotation File Name ", arg_20_0._new_rotation_file_name)

	var_0_5.dummy(2, 10)
end

local function var_0_7(arg_21_0)
	return arg_21_0.steam_itemdefid and true or false
end

ImguiStoreRotation._is_a_dlc = function (arg_22_0, arg_22_1)
	return (table.find(arg_22_0._dlc_list, arg_22_1))
end

ImguiStoreRotation._get_layout_item = function (arg_23_0, arg_23_1)
	local var_23_0 = {}

	if arg_23_0:_is_a_dlc(arg_23_1) then
		var_23_0.id = arg_23_1
		var_23_0.type = "dlc"
	else
		local var_23_1 = rawget(ItemMasterList, arg_23_1)

		if var_0_7(var_23_1) then
			var_23_0.steam_itemdefid = var_23_1.steam_itemdefid
			var_23_0.id = arg_23_1
			var_23_0.type = "item"
			var_23_0.key = arg_23_1
		else
			var_23_0.id = arg_23_1
			var_23_0.type = "item"
		end
	end

	return var_23_0
end

ImguiStoreRotation._get_slideshow_item = function (arg_24_0, arg_24_1)
	local var_24_0 = {}
	local var_24_1
	local var_24_2
	local var_24_3
	local var_24_4
	local var_24_5
	local var_24_6
	local var_24_7 = arg_24_0:_is_a_dlc(arg_24_1)
	local var_24_8 = var_24_7 and "dlc" or "item"
	local var_24_9 = var_24_7 and StoreDlcSettingsByName[arg_24_1] or rawget(ItemMasterList, arg_24_1)

	if not var_24_9 or var_24_9.item_type ~= "bundle" and not var_24_7 and not var_24_9.store_bundle_big_image then
		var_24_0.error_text = "Item " .. arg_24_1 .. " Cannot be used as a slideshow item."

		return var_24_0
	end

	if var_24_9.item_type == "bundle" or var_24_7 then
		local var_24_10 = false

		for iter_24_0 = 1, #StoreDlcSettings do
			local var_24_11 = StoreDlcSettings[iter_24_0]

			if var_24_11.dlc_name == arg_24_1 or var_24_11.name == arg_24_1 then
				if not var_24_11.slideshow_texture then
					var_24_0.error_text = "Item " .. arg_24_1 .. " Cannot be used as a slideshow item."

					return var_24_0
				end

				var_24_8 = "item"
				var_24_2 = var_24_11.name
				var_24_3 = var_24_11.slideshow_texture
				var_24_4 = arg_24_1
				var_24_5 = var_24_11.information_text
				var_24_10 = true
			end
		end

		if not var_24_10 then
			var_24_2 = var_24_9.display_name
			var_24_3 = var_24_9.store_bundle_big_image and string.match(var_24_9.store_bundle_big_image, "[^/]+$") or ""
			var_24_4 = arg_24_1
			var_24_5 = var_24_9.description
		end
	else
		var_24_2 = var_24_9.display_name
		var_24_3 = var_24_9.store_bundle_big_image and string.match(var_24_9.store_bundle_big_image, "[^/]+$") or ""
		var_24_4 = arg_24_1
		var_24_5 = var_24_9.description
	end

	if var_0_7(var_24_9) then
		var_24_0.steam_itemdefid = var_24_9.steam_itemdefid
	end

	var_24_0.product_type = var_24_8
	var_24_0.header = var_24_2
	var_24_0.texture = var_24_3
	var_24_0.product_id = var_24_4
	var_24_0.description = var_24_5

	local var_24_12 = arg_24_0._prio + 100

	var_24_0.prio = var_24_12
	arg_24_0._prio = var_24_12

	return var_24_0
end

ImguiStoreRotation._draw_item_selection = function (arg_25_0)
	var_0_5.text("Select Item")

	local var_25_0, var_25_1, var_25_2 = ImguiX.combo_search(arg_25_0._selected_item_index, arg_25_0._item_search_results, arg_25_0._item_search_text, arg_25_0._searcheable_item_keys[arg_25_0._search_type])

	arg_25_0._selected_item_index = var_25_0
	arg_25_0._item_search_results = var_25_1
	arg_25_0._item_search_text = var_25_2
end

ImguiStoreRotation._draw_selcted_layout_items = function (arg_26_0, arg_26_1)
	for iter_26_0 = 1, #arg_26_1 do
		local var_26_0 = arg_26_1[iter_26_0]
		local var_26_1 = var_26_0.key or var_26_0.id

		if arg_26_0._localize then
			local var_26_2 = rawget(ItemMasterList, var_26_1)
			local var_26_3 = Localize(var_26_2.display_name)

			var_0_5.text_colored("Featured Item: " .. var_26_3, 245, 245, 207, 255)
		else
			var_0_5.text_colored("Featured Item: " .. var_26_1, 245, 245, 207, 255)
		end

		var_0_5.dummy(2, 5)

		for iter_26_1, iter_26_2 in pairs(var_26_0) do
			var_0_5.text_colored(iter_26_1 .. " : ", 0, 186, 112, 255)
			var_0_5.same_line()
			var_0_5.text_colored(tostring(iter_26_2), 0, 193, 212, 255)
		end

		arg_26_0:_draw_selected_item_image(var_26_1)
		var_0_5.dummy(2, 5)
	end
end

ImguiStoreRotation._draw_selcted_slideshow_items = function (arg_27_0, arg_27_1)
	for iter_27_0 = 1, #arg_27_1 do
		local var_27_0 = arg_27_1[iter_27_0]

		if not var_27_0.error_text then
			local var_27_1 = var_27_0.product_id or var_27_0.dlc_name

			var_0_5.text_colored("Slideshow Item: " .. var_27_1, 245, 245, 207, 255)
		end

		var_0_5.dummy(2, 5)

		for iter_27_1, iter_27_2 in pairs(var_27_0) do
			if var_27_0.error_text then
				var_0_5.text_colored(iter_27_1 .. " : " .. iter_27_2, 255, 0, 0, 255)
			elseif arg_27_0._localize and (iter_27_1 == "header" or iter_27_1 == "description") then
				var_0_5.text_colored(iter_27_1 .. " : ", 0, 186, 112, 255)
				var_0_5.same_line()
				var_0_5.text_colored(Localize(iter_27_2), 0, 193, 212, 255)
			else
				var_0_5.text_colored(iter_27_1 .. " : ", 0, 186, 112, 255)
				var_0_5.same_line()
				var_0_5.text_colored(tostring(iter_27_2), 0, 193, 212, 255)
			end
		end

		local var_27_2 = var_27_0.product_id or var_27_0.dlc_name

		arg_27_0:_draw_selected_item_image(var_27_2)
		var_0_5.dummy(2, 5)
	end
end

ImguiStoreRotation._draw_selected_item_image = function (arg_28_0, arg_28_1)
	local var_28_0 = rawget(ItemMasterList, arg_28_1)

	if var_28_0 then
		if var_28_0.item_type ~= "bundle" then
			local var_28_1 = "store_item_icon_" .. arg_28_1
			local var_28_2 = "gui/1080p/single_textures/store_item_icons/" .. var_28_1 .. "/" .. var_28_1
			local var_28_3 = "resource_packages/store/item_icons/" .. var_28_1

			if not Application.can_get("texture", var_28_2) and Application.can_get("package", var_28_3) then
				local var_28_4 = Managers.package

				local function var_28_5()
					Debug.sticky_text("Image Loaded " .. var_28_2)
				end

				local var_28_6 = callback(var_28_5)
				local var_28_7 = "ImguiStoreRotation"

				var_28_4:load(var_28_3, var_28_7, var_28_6, true)
			elseif Application.can_get("texture", var_28_2) then
				local var_28_8 = 130
				local var_28_9 = 110

				var_0_5.image(var_28_2, var_28_8, var_28_9)
			else
				local var_28_10 = "gui/1080p/single_textures/vermintide_2_logo_for_dark_backgrounds"

				if Application.can_get("texture", var_28_10) then
					local var_28_11 = 342
					local var_28_12 = 192

					var_0_5.image(var_28_10, var_28_11, var_28_12)
					var_0_5.text_colored("Missing Texture for Item: " .. arg_28_1, 0, 186, 112, 255)
				end
			end
		elseif var_28_0.item_type == "bundle" then
			local var_28_13 = "store_item_icon_" .. arg_28_1
			local var_28_14 = "gui/1080p/single_textures/store_bundle/" .. var_28_13
			local var_28_15 = "resource_packages/store/bundle_icons/" .. var_28_13

			if not Application.can_get("texture", var_28_14) and Application.can_get("package", var_28_15) then
				local var_28_16 = Managers.package

				local function var_28_17()
					Debug.sticky_text("Image Loaded " .. var_28_14)
				end

				local var_28_18 = callback(var_28_17)
				local var_28_19 = "ImguiStoreRotation"

				var_28_16:load(var_28_15, var_28_19, var_28_18, true)
			elseif Application.can_get("texture", var_28_14) then
				local var_28_20 = 400
				local var_28_21 = 110

				var_0_5.image(var_28_14, var_28_20, var_28_21)
			else
				var_0_5.text_colored("Loading Texture", 0, 186, 112, 255)
			end
		end
	end
end

ImguiStoreRotation._do_timestamp_settings = function (arg_31_0)
	var_0_5.text("Set End Date, This will be used for the countdown displayed at the top of the Store Feature Page ")
	var_0_5.dummy(2, 10)
	var_0_5.columns(6, false)

	arg_31_0._timestamp_year = var_0_5.input_text("<-Year", arg_31_0._timestamp_year)

	var_0_5.next_column()

	arg_31_0._timestamp_month = var_0_5.input_text("<-Month", arg_31_0._timestamp_month)

	var_0_5.next_column()

	arg_31_0._timestamp_day = var_0_5.input_text("<-Day", arg_31_0._timestamp_day)

	var_0_5.next_column()

	arg_31_0._timestamp_hour = var_0_5.input_text("<-Hour", arg_31_0._timestamp_hour)

	var_0_5.next_column()

	arg_31_0._timestamp_minutes = var_0_5.input_text("<-Min", arg_31_0._timestamp_minutes)

	var_0_5.next_column()

	arg_31_0._timestamp_seconds = var_0_5.input_text("<-Secs", arg_31_0._timestamp_seconds)

	var_0_5.next_column()

	if var_0_5.button("Preview Timestamp", 150, 20) then
		arg_31_0._timestamp = arg_31_0:_calculate_timestamp(arg_31_0._timestamp_year, arg_31_0._timestamp_month, arg_31_0._timestamp_day, arg_31_0._timestamp_hour, arg_31_0._timestamp_minutes, arg_31_0._timestamp_seconds)
	end
end

local function var_0_8(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
	if arg_32_0 == "" or tonumber(arg_32_0) < tonumber(os.date("%Y")) then
		return false
	elseif arg_32_1 == "" or tonumber(arg_32_1) > 12 or tonumber(arg_32_1) < 1 then
		return false
	elseif not arg_32_2 or arg_32_2 == "" or tonumber(arg_32_2) > 31 or tonumber(arg_32_2) < 1 then
		return false
	elseif arg_32_3 and (arg_32_3 == "" or tonumber(arg_32_3) > 23 or tonumber(arg_32_3) < 0) then
		return false
	elseif arg_32_4 and (arg_32_4 == "" or tonumber(arg_32_4) > 59 or tonumber(arg_32_4) < 0) then
		return false
	elseif arg_32_5 and (arg_32_5 == "" or tonumber(arg_32_5) > 59 or tonumber(arg_32_5) < 0) then
		return false
	end

	return true
end

ImguiStoreRotation._calculate_timestamp = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6)
	if not var_0_8(arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6) then
		return 0, false
	end

	local var_33_0 = false
	local var_33_1 = os.time({
		day = arg_33_3,
		month = arg_33_2,
		year = arg_33_1,
		hour = arg_33_4,
		min = arg_33_5,
		sec = arg_33_6,
		isdst = var_33_0
	})

	arg_33_0._timestamp_error = false

	return var_33_1, true
end

ImguiStoreRotation._save_layout_items = function (arg_34_0, arg_34_1)
	if table.is_empty(arg_34_1) then
		return
	end

	local var_34_0 = arg_34_0._lua_layout.pages.featured.grid

	table.clear(var_34_0)

	for iter_34_0, iter_34_1 in pairs(arg_34_1) do
		var_34_0[#var_34_0 + 1] = iter_34_1
	end

	arg_34_0._lua_layout.pages.featured.grid = var_34_0

	table.dump(arg_34_0._lua_layout.pages.featured, "FEATURED", 5)
end

ImguiStoreRotation._save_slideshow_items = function (arg_35_0, arg_35_1)
	if table.is_empty(arg_35_1) then
		return
	end

	local var_35_0 = arg_35_0._lua_layout.pages.featured.slideshow

	table.clear(var_35_0)

	for iter_35_0, iter_35_1 in pairs(arg_35_1) do
		if iter_35_1.error_text then
			-- Nothing
		else
			var_35_0[#var_35_0 + 1] = iter_35_1
		end
	end

	arg_35_0._lua_layout.pages.featured.slideshow = var_35_0

	table.dump(arg_35_0._lua_layout.pages.featured, "FEATURED", 5)
end

ImguiStoreRotation._remove_last_added_item = function (arg_36_0, arg_36_1)
	arg_36_1[#arg_36_1] = nil
end

ImguiStoreRotation._do_clear_edit_buttons = function (arg_37_0)
	var_0_5.dummy(2, 10)
	var_0_5.text("Clear Edits")
	var_0_5.text_colored("Clear the edits made, the uses can delete a whole section or the entire edits. ", 245, 245, 207, 255)

	if var_0_5.button("Clear Featured Items", 180, 20) then
		table.clear(arg_37_0._layout_items)
	end

	if var_0_5.button("Clear Slideshow Items", 180, 20) then
		table.clear(arg_37_0._slideshow_items)

		arg_37_0._prio = 0
	end

	if var_0_5.button("Clear All", 180, 20) then
		table.clear(arg_37_0._layout_items)
		table.clear(arg_37_0._slideshow_items)
	end
end

ImguiStoreRotation._save_to_file = function (arg_38_0)
	local var_38_0 = false

	if arg_38_0._new_rotation_file_name == "" then
		arg_38_0._missing_file_name = true
		var_38_0 = true
	end

	local var_38_1, var_38_2 = arg_38_0:_calculate_timestamp(arg_38_0._timestamp_year, arg_38_0._timestamp_month, arg_38_0._timestamp_day, arg_38_0._timestamp_hour, arg_38_0._timestamp_minutes, arg_38_0._timestamp_seconds)

	if not var_38_2 then
		arg_38_0._timestamp_error = true
		var_38_0 = true
	end

	if not var_38_0 then
		arg_38_0._timestamp = var_38_1
		arg_38_0._lua_layout.pages.featured.rotation_timestamp = arg_38_0._timestamp

		arg_38_0:_save_layout_items(arg_38_0._layout_items)
		arg_38_0:_save_slideshow_items(arg_38_0._slideshow_items)

		local var_38_3 = arg_38_0._lua_layout
		local var_38_4 = cjson.encode(var_38_3)
		local var_38_5 = script_data.source_dir

		arg_38_0._fp = assert(io.open(var_38_5 .. "/.shop/rotation/" .. arg_38_0._new_rotation_file_name .. ".json", "w"))

		arg_38_0._fp:write(var_38_4)
		arg_38_0._fp:close()
		Clipboard.put(var_38_4)

		arg_38_0._save_successful_featured = "File saved successfully at\n" .. var_38_5 .. "/.shop/rotation/" .. arg_38_0._new_rotation_file_name .. ".json"

		arg_38_0:_save_settings()
	end
end

ImguiStoreRotation._calculate_discount = function (arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_1:gsub("%s+", "")
	local var_39_1 = arg_39_2 / 100
	local var_39_2 = string.format("%s%s%sT110000Z", arg_39_0._begin_discount_year, arg_39_0._begin_discount_month, arg_39_0._begin_discount_day)
	local var_39_3 = string.format("%s%s%sT110000Z", arg_39_0._end_discount_year, arg_39_0._end_discount_month, arg_39_0._end_discount_day)
	local var_39_4 = SteamItemService.apply_discounts(var_39_0, var_39_1, var_39_2, var_39_3)

	print(var_39_4)

	return var_39_4
end

ImguiStoreRotation._make_item_def = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = arg_40_2.steam_itemdefid
	local var_40_1 = SteamInventory.get_item_definition_property(var_40_0, "price")

	return {
		item_quality = 2,
		type = "item",
		purchase_limit = 1,
		tradable = false,
		marketable = false,
		store_hidden = false,
		hidden = false,
		itemdefid = arg_40_2.steam_itemdefid,
		display_type = SteamInventory.get_item_definition_property(var_40_0, "display_type"),
		name = Localize(arg_40_2.display_name),
		price = arg_40_0:_calculate_discount(var_40_1, arg_40_3),
		description = Localize(arg_40_2.description),
		name_color = SteamInventory.get_item_definition_property(var_40_0, "name_color"),
		background_color = SteamInventory.get_item_definition_property(var_40_0, "background_color"),
		icon_url = SteamInventory.get_item_definition_property(var_40_0, "icon_url")
	}
end

ImguiStoreRotation._make_bundle_def = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	local var_41_0 = arg_41_2.steam_itemdefid
	local var_41_1 = SteamInventory.get_item_definition_property(var_41_0, "price")

	return {
		item_quality = 2,
		use_bundle_price = true,
		type = "bundle",
		tradable = false,
		marketable = false,
		hidden = false,
		store_hidden = false,
		itemdefid = arg_41_2.steam_itemdefid,
		display_type = SteamInventory.get_item_definition_property(var_41_0, "display_type"),
		bundle = SteamInventory.get_item_definition_property(var_41_0, "bundle"),
		name = Localize(arg_41_2 and arg_41_2.display_name or "not_assigned"),
		price = arg_41_0:_calculate_discount(var_41_1, arg_41_3),
		description = Localize(arg_41_2 and arg_41_2.description or "not_assigned"),
		name_color = SteamInventory.get_item_definition_property(var_41_0, "name_color"),
		background_color = SteamInventory.get_item_definition_property(var_41_0, "background_color"),
		icon_url = SteamInventory.get_item_definition_property(var_41_0, "icon_url")
	}
end

ImguiStoreRotation._generate_discounted_item = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	if arg_42_2.item_type ~= "bundle" and arg_42_2.item_type ~= "cosmetic_bundle" then
		return arg_42_0:_make_item_def(arg_42_1, arg_42_2, arg_42_3)
	else
		return arg_42_0:_make_bundle_def(arg_42_1, arg_42_2, arg_42_3)
	end
end

ImguiStoreRotation._draw_dicount_begin_and_end_fields = function (arg_43_0)
	var_0_5.text("Setup Discount Begin and End Date")
	var_0_5.text_colored("Set the start date from when the an item should be on sale", 245, 245, 207, 255)
	var_0_5.text("Begin Date")
	var_0_5.columns(3, false)
	var_0_5.set_column_width(300)

	arg_43_0._begin_discount_year = var_0_5.input_text("Begin Year", arg_43_0._begin_discount_year)

	var_0_5.next_column()
	var_0_5.set_column_width(300)

	arg_43_0._begin_discount_month = var_0_5.input_text("Begin Month", arg_43_0._begin_discount_month)

	var_0_5.next_column()
	var_0_5.set_column_width(300)

	arg_43_0._begin_discount_day = var_0_5.input_text("Begin Day", arg_43_0._begin_discount_day)

	var_0_5.columns(0, false)
	var_0_5.text("End Date")
	var_0_5.text_colored("Set the end date from when the sale on the item should end", 245, 245, 207, 255)
	var_0_5.columns(3, false)

	arg_43_0._end_discount_year = var_0_5.input_text("End Year", arg_43_0._end_discount_year)

	var_0_5.next_column()
	var_0_5.set_column_width(300)

	arg_43_0._end_discount_month = var_0_5.input_text("End Month", arg_43_0._end_discount_month)

	var_0_5.next_column()
	var_0_5.set_column_width(300)

	arg_43_0._end_discount_day = var_0_5.input_text("End Day", arg_43_0._end_discount_day)

	var_0_5.next_column()
end

ImguiStoreRotation._store_rotation_discounts_tab = function (arg_44_0)
	var_0_5.text("Store Rotation Discounts")
	var_0_5.text_colored("This tab only supports discounting STEAM ITEMS.\nSupport to discount PLAYFAB items will be added in the near future.", 255, 0, 0, 255)
	var_0_5.dummy(2, 5)
	var_0_5.text_colored("Set the file name and the Steam Application ID (This field is prefilled to be the 'Vermintide 2 Internal Test' Steam App ID: 795750)", 245, 245, 207, 255)
	arg_44_0:_do_discount_rotation_file_name()
	arg_44_0:_draw_dicount_begin_and_end_fields()
	var_0_5.dummy(2, 5)
	var_0_5.separator()
	var_0_5.columns(2, true)
	var_0_5.text("Edit Discounts")
	arg_44_0:_do_edit_discounts_button()

	local var_44_0 = var_0_8(arg_44_0._end_discount_year, arg_44_0._end_discount_month, arg_44_0._end_discount_day)

	arg_44_0:_do_discount_item_selection(var_44_0)
	arg_44_0:_handle_discount_page_errors(var_44_0)
	arg_44_0:_do_clear_discount_edit_buttons()
	arg_44_0:_do_save_discounted_items_button()

	if arg_44_0._save_successful_discount ~= "" then
		var_0_5.text_colored(arg_44_0._save_successful_discount, 255, 196, 0, 255)
	end

	var_0_5.next_column()
	var_0_5.text("Preview Discounted Items")
	var_0_5.separator()
	arg_44_0:_do_preview_discounted_items()
	var_0_5.next_column()
	var_0_5.columns(0, false)
end

ImguiStoreRotation._do_discount_rotation_file_name = function (arg_45_0)
	var_0_5.dummy(2, 3)

	arg_45_0._new_discount_file_name = var_0_5.input_text("Steam Discount File Name", arg_45_0._new_discount_file_name)

	local var_45_0 = var_0_5.combo("Steam App Id", arg_45_0._appid_idx, var_0_2, 2)

	if var_45_0 ~= arg_45_0._appid_idx then
		arg_45_0._appid = var_0_2[var_45_0]
		arg_45_0._appid_idx = var_45_0
	end

	var_0_5.dummy(2, 5)
	var_0_5.separator()
end

ImguiStoreRotation._do_edit_discounts_button = function (arg_46_0)
	var_0_5.dummy(2, 10)
	var_0_5.text("Edit Discounts")
	var_0_5.text_colored("Select an item and set the anount of which it should be discounted by", 245, 245, 207, 255)

	if var_0_5.button("DISCOUNT Item", 200, 20) then
		arg_46_0._is_selecting_discount_item = true

		arg_46_0:_on_search_type_changed(var_0_3.discount)
	end

	if var_0_5.button("REMOVE LAST Item", 200, 20) then
		arg_46_0:_remove_last_added_item(arg_46_0._discounted_items)
	end
end

ImguiStoreRotation._on_search_type_changed = function (arg_47_0, arg_47_1)
	arg_47_0._search_type = arg_47_1
	arg_47_0._item_search_results = table.clone(arg_47_0._searcheable_item_keys[arg_47_1])
end

ImguiStoreRotation._do_discount_item_selection = function (arg_48_0, arg_48_1)
	if arg_48_0._is_selecting_discount_item then
		var_0_5.dummy(2, 5)
		var_0_5.text_colored("OBS! PRESS ENTER", 255, 0, 0, 255)
		var_0_5.same_line()
		var_0_5.text("after inputting the discoiunt to apply it")

		arg_48_0._discount_amount = var_0_5.input_int("Discount amount", arg_48_0._discount_amount)

		arg_48_0:_draw_item_selection()

		if arg_48_0._selected_item_index ~= -1 then
			if arg_48_0._discount_amount > 0 and arg_48_0._discount_amount <= 100 and arg_48_1 then
				local var_48_0 = arg_48_0._item_search_results[arg_48_0._selected_item_index]
				local var_48_1 = rawget(ItemMasterList, var_48_0)

				fassert(var_48_1, "Item %s is not in the ItemMasterList", var_48_0)

				local var_48_2 = var_0_7(var_48_1)

				arg_48_0._is_playfab_item = not var_48_2

				if var_48_2 then
					local var_48_3 = arg_48_0._discount_amount
					local var_48_4 = arg_48_0:_generate_discounted_item(var_48_0, var_48_1, var_48_3)
					local var_48_5 = {
						key = var_48_0,
						item = var_48_4
					}

					arg_48_0._discounted_items[#arg_48_0._discounted_items + 1] = var_48_5
					arg_48_0._has_error_discount = false
					arg_48_0._selected_item_index = -1
					arg_48_0._item_search_text = ""
					arg_48_0._is_selecting_discount_item = false
				else
					arg_48_0._has_error_discount = true
				end
			else
				arg_48_0._has_error_discount = true
				arg_48_0._selected_item_index = -1
				arg_48_0._item_search_text = ""
			end
		end
	end
end

ImguiStoreRotation._handle_discount_page_errors = function (arg_49_0, arg_49_1)
	if arg_49_0._has_error_discount then
		local var_49_0 = ""

		if arg_49_0._discount_amount <= 0 then
			var_49_0 = string.format("ERROR: You are tring to discount an item by %d,\nThe discount amount must be greater than 0", arg_49_0._discount_amount)
		elseif arg_49_0._discount_amount > 100 then
			var_49_0 = string.format("ERROR: You are tring to discount an item by %d,\nThe discount amount must be less then or equal to 100", arg_49_0._discount_amount)
		end

		if not arg_49_1 then
			var_49_0 = var_49_0 .. "\n" .. string.format("ERROR: You are tring to set a discount time with an invalid end date,\nThe date cannot be %s-%s-%s", arg_49_0._end_discount_year, arg_49_0._end_discount_month, arg_49_0._end_discount_day)
		end

		if arg_49_0._is_playfab_item then
			var_49_0 = var_49_0 .. "\n" .. "ERROR: The Item you are trying to discount is a Playfab item.\nCurrently this tool does not support discounting Playfab items."
		end

		if var_49_0 then
			var_0_5.text_colored(var_49_0, 255, 0, 0, 255)
		end
	end
end

ImguiStoreRotation._do_clear_discount_edit_buttons = function (arg_50_0)
	var_0_5.dummy(2, 10)
	var_0_5.text("Clear All Discounted Items")
	var_0_5.text_colored("Delete all the edited discounted items.", 245, 245, 207, 255)

	if var_0_5.button("Clear Discounted Items", 200, 20) then
		table.clear(arg_50_0._discounted_items)
	end
end

ImguiStoreRotation._do_save_discounted_items_button = function (arg_51_0)
	var_0_5.dummy(2, 10)
	var_0_5.text("Save Discounts")
	var_0_5.text_colored("Save the discounted items to a JSON file, that can be easily uploaded to Steam.", 245, 245, 207, 255)

	if var_0_5.button("SAVE DISCOUNTS TO FILE", 250, 50) then
		arg_51_0:_save_discounts_to_file()
	end
end

ImguiStoreRotation._do_preview_discounted_items = function (arg_52_0)
	var_0_5.dummy(2, 10)
	var_0_5.text("DISCOUNTED ITEMS: " .. #arg_52_0._discounted_items)

	if not table.is_empty(arg_52_0._discounted_items) then
		arg_52_0:_draw_discounted_items(arg_52_0._discounted_items)
	end
end

ImguiStoreRotation._get_from_to_discount_price = function (arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0._backend_store
	local var_53_1 = "Discounted by %d percent from %.2f %s to %.2f %s"
	local var_53_2, var_53_3 = var_53_0:get_steam_item_price(arg_53_1)
	local var_53_4 = var_53_2 - math.floor(var_53_2 * (arg_53_0._discount_amount / 100))

	return (string.format(var_53_1, arg_53_0._discount_amount, var_53_2 * 0.01, var_53_3, var_53_4 * 0.01, var_53_3))
end

ImguiStoreRotation._draw_discounted_items = function (arg_54_0, arg_54_1)
	for iter_54_0 = 1, #arg_54_1 do
		local var_54_0 = arg_54_1[iter_54_0]
		local var_54_1 = var_54_0.item
		local var_54_2 = var_54_0.key

		var_0_5.text_colored("Discounted Item: " .. var_54_2, 245, 245, 207, 255)

		local var_54_3 = arg_54_0:_get_from_to_discount_price(var_54_1.itemdefid)

		var_0_5.text(var_54_3)
		var_0_5.dummy(2, 5)

		for iter_54_1, iter_54_2 in pairs(var_54_1) do
			if var_54_1.error_text then
				var_0_5.text_colored(iter_54_1 .. " : " .. iter_54_2, 255, 0, 0, 255)
			else
				var_0_5.text_colored(iter_54_1 .. " : ", 0, 186, 112, 255)
				var_0_5.same_line()
				var_0_5.text_colored(tostring(iter_54_2), 0, 193, 212, 255)
			end
		end

		var_0_5.dummy(2, 5)
	end
end

ImguiStoreRotation._get_rotation_items = function (arg_55_0)
	local var_55_0 = {}

	for iter_55_0 = 1, #arg_55_0._discounted_items do
		local var_55_1 = arg_55_0._discounted_items[iter_55_0]

		var_55_0[#var_55_0 + 1] = var_55_1.item
	end

	return var_55_0
end

ImguiStoreRotation._save_discounts_to_file = function (arg_56_0)
	if not arg_56_0._has_error_discount then
		local var_56_0 = arg_56_0:_get_rotation_items()
		local var_56_1 = cjson.encode({
			appid = arg_56_0._appid,
			items = var_56_0
		}):gsub("\\/", "/")
		local var_56_2 = script_data.source_dir

		arg_56_0._fp = assert(io.open(var_56_2 .. "/.shop/rotation/" .. arg_56_0._new_discount_file_name .. ".json", "w"))

		arg_56_0._fp:write(var_56_1)
		arg_56_0._fp:close()

		arg_56_0._save_successful_discount = "File saved succsessfully at\n" .. var_56_2 .. "/.shop/rotation/" .. arg_56_0._new_discount_file_name .. ".json"

		arg_56_0:_save_settings()
	end
end

ImguiStoreRotation._store_item_utility_tab = function (arg_57_0)
	var_0_5.text("Store Items Utility")
	var_0_5.dummy(2, 5)
	var_0_5.text_colored("Create a .CSV file containing all the items present in the game", 64, 255, 255, 255)
	var_0_5.text_colored("The item information collected will be the Hero Name, Cosmetic Type, Localized Name, Item Key and Which Career Can Wield/Equip the Item", 64, 255, 255, 255)

	if var_0_5.button("Create cosmetics List file", 250, 50) then
		arg_57_0:_create_cosmetics_item_list_file()
	end

	var_0_5.dummy(2, 5)
	var_0_5.text_colored("Create a .JSON file containing all the feature and slideshow items available in the game", 64, 255, 255, 255)

	if var_0_5.button("Create Featured and Slideshow Json file", 250, 50) then
		arg_57_0:_create_rotation_items_json_file()
	end
end

ImguiStoreRotation._create_rotation_items_json_file = function (arg_58_0)
	local var_58_0 = arg_58_0:_collect_all_feature_items()
	local var_58_1 = arg_58_0:_collect_all_slideshow_items()
	local var_58_2 = cjson.encode({
		featured_items = var_58_0,
		slideshow_items = var_58_1
	}):gsub("\\/", "/")
	local var_58_3 = script_data.source_dir

	arg_58_0._fp = assert(io.open(var_58_3 .. "/.shop/collected_featured_and_slideshow_items.json", "w"))

	arg_58_0._fp:write(var_58_2)
	arg_58_0._fp:close()
end

ImguiStoreRotation._collect_all_feature_items = function (arg_59_0)
	local var_59_0 = {}

	for iter_59_0, iter_59_1 in ipairs(arg_59_0._item_keys_list) do
		var_59_0[iter_59_1] = arg_59_0:_get_layout_item(iter_59_1)
	end

	arg_59_0._all_feature_items = var_59_0

	return var_59_0
end

ImguiStoreRotation._collect_all_slideshow_items = function (arg_60_0)
	local var_60_0 = {}

	for iter_60_0, iter_60_1 in pairs(arg_60_0._item_keys_list) do
		local var_60_1 = arg_60_0:_get_slideshow_item(iter_60_1)

		if not var_60_1.error_text then
			var_60_0[iter_60_1] = var_60_1
		end
	end

	arg_60_0._all_slideshow_items = var_60_0

	return var_60_0
end

ImguiStoreRotation._create_cosmetics_item_list_file = function (arg_61_0)
	local var_61_0 = "Hero, Comsetic Type, Localized Name, Item Key, Can Wield Careers \n"

	local function var_61_1(arg_62_0)
		local var_62_0 = ""

		for iter_62_0 = 1, #arg_62_0 do
			if iter_62_0 == #arg_62_0 then
				var_62_0 = var_62_0 .. Localize(arg_62_0[iter_62_0])
			else
				var_62_0 = var_62_0 .. Localize(arg_62_0[iter_62_0]) .. " , "
			end
		end

		return "\" " .. var_62_0 .. " \""
	end

	for iter_61_0, iter_61_1 in pairs(arg_61_0._cosmetic_items) do
		if iter_61_0 == "frame" then
			for iter_61_2, iter_61_3 in pairs(iter_61_1) do
				local var_61_2 = iter_61_3.item_key

				var_61_0 = var_61_0 .. "\" \"" .. "," .. Localize(iter_61_0) .. "," .. "\"" .. Localize(iter_61_2) .. "\"" .. ", " .. var_61_2 .. ", All" .. "\n"
			end
		else
			for iter_61_4, iter_61_5 in pairs(iter_61_1) do
				for iter_61_6, iter_61_7 in pairs(iter_61_5) do
					var_61_0 = var_61_0 .. Localize(iter_61_0) .. "," .. Localize(iter_61_4) .. ","

					local var_61_3 = ""

					if iter_61_7.can_wield then
						var_61_3 = var_61_1(iter_61_7.can_wield)
					end

					local var_61_4 = iter_61_7.item_key

					var_61_0 = var_61_0 .. "\"" .. Localize(iter_61_6) .. "\"" .. ", " .. iter_61_7.item_key .. ", " .. var_61_3 .. "\n"
				end
			end
		end
	end

	local var_61_5 = script_data.source_dir

	arg_61_0._fp = assert(io.open(var_61_5 .. "/.shop/cosmetic_items_list.csv", "w"))

	arg_61_0._fp:write(var_61_0)
	arg_61_0._fp:close()
end

local var_0_9 = {
	frame = true,
	skin = true,
	weapon_skin = true,
	cosmetic_bundles = true
}

ImguiStoreRotation._collect_cosmetic_items_data = function (arg_63_0)
	local var_63_0 = {}

	for iter_63_0, iter_63_1 in pairs(ItemMasterList) do
		local var_63_1 = iter_63_1.item_type

		if not iter_63_1.base_skin_item and var_0_9[var_63_1] then
			if var_63_1 == "frame" then
				if not var_63_0.frame then
					var_63_0.frame = {}
				end

				local var_63_2 = {
					item_key = iter_63_0,
					icon = iter_63_1.inventory_icon or "icons_placeholder"
				}

				var_63_0.frame[iter_63_1.display_name] = var_63_2
			else
				local var_63_3 = iter_63_1.can_wield[1]
				local var_63_4 = PROFILES_BY_CAREER_NAMES[var_63_3].ingame_display_name

				if not var_63_0[var_63_4] then
					var_63_0[var_63_4] = {}
				end

				local var_63_5 = {
					item_key = iter_63_0,
					can_wield = iter_63_1.can_wield,
					icon = iter_63_1.inventory_icon or "icons_placeholder"
				}
				local var_63_6 = var_63_0[var_63_4]

				if not var_63_6[var_63_1] then
					var_63_6[var_63_1] = {}
				end

				local var_63_7 = iter_63_1.display_name

				var_63_6[var_63_1][var_63_7] = var_63_5
			end
		end
	end

	arg_63_0._cosmetic_items = var_63_0
end

ImguiStoreRotation._handle_error_messages = function (arg_64_0)
	if arg_64_0._timestamp_error then
		var_0_5.text_colored("Achtung!!: ", 255, 0, 0, 255)
		var_0_5.same_line()
		var_0_5.text("Something is wrong with the date you have given, something seems to be missing!")
	end

	if arg_64_0._missing_file_name then
		if arg_64_0._new_rotation_file_name ~= "" then
			arg_64_0._missing_file_name = nil
		end

		var_0_5.text_colored("Achtung!!: ", 255, 0, 0, 255)
		var_0_5.same_line()
		var_0_5.text("No new file name has been given please name your file before saving!")
	end
end
