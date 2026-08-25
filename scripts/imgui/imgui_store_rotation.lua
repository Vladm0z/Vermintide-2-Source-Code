-- chunkname: @scripts/imgui/imgui_store_rotation.lua

local var_0_0 = "    {\n        \"pages\": {\n          \"featured\": {\n            \"rotation_timestamp\": 1669633200,\n            \"display_name\": \"menu_store_panel_title_featured\",\n            \"grid\": [\n            ],\n            \"layout\": \"featured\",\n            \"slideshow\": [\n            ],\n            \"sound_event_enter\": \"Play_hud_store_category_front\"\n          },\n          \"dlc\": {\n            \"content\": [\n              \"ultimate_bundle\",\n              \"legacy_bundle\",\n              \"premium_career_bundle\",\n              \"premium_career_bundle_upgrade\",\n              \"shovel\",\n              \"shovel_upgrade\",\n              \"bless\",\n              \"bless_upgrade\",\n              \"woods\",\n              \"woods_upgrade\",\n              \"grass\",\n              \"cog\",\n              \"cog_upgrade\",\n              \"lake\",\n              \"lake_upgrade\",\n              \"scorpion\",\n              \"holly\",\n              \"bogenhafen\",\n              \"pre_order\"\n            ],\n            \"type\": \"dlc\",\n            \"display_name\": \"menu_store_panel_title_dlcs\",\n            \"layout\": \"dlc_list\",\n            \"sound_event_enter\": \"Play_hud_store_category_dlc\"\n          }\n        }\n      }\n"
local var_0_1 = "    {\n        \"featured\": {\n        },\n        \"discounts\" : {\n        }\n    }\n"
local var_0_2 = {
	[1] = "795750",
	[2] = "552500"
}
local var_0_3 = table.enum("slideshow", "featured", "discount")

local function var_0_4(arg_1_0)
	return (Localize(arg_1_0))
end

local var_0_5 = "/.shop/imgui_store_tool_save_file.json"

ImguiStoreRotation = class(ImguiStoreRotation)

local var_0_6 = Imgui
local var_0_7 = true

function ImguiStoreRotation.init(arg_2_0)
	arg_2_0._fp = nil
	arg_2_0._save_file = nil
	arg_2_0._first_launch = true

	arg_2_0:_load_saved_data()

	arg_2_0._item_keys_list = {}
	arg_2_0._layout_items = {}
	arg_2_0._slideshow_items = {}
	arg_2_0._dlc_list = {}
	arg_2_0._store_dlc_list = {}
	arg_2_0._search_type = var_0_3.featured

	arg_2_0:_setup_timpestamp_fields()

	arg_2_0._timestamp = 0

	arg_2_0:_setup_item_keys_list()
	arg_2_0:_setup_dlc_list()

	arg_2_0._item_search_results = table.clone(arg_2_0._item_keys_list)
	arg_2_0._searcheable_item_keys = {}

	arg_2_0:_filter_item_keys_list()

	arg_2_0._is_selecting_item = false
	arg_2_0._is_selecting_slideshow_item = false
	arg_2_0._selected_item_index = -1
	arg_2_0._item_search_text = ""
	arg_2_0._prio = 0
	arg_2_0._localize = false

	arg_2_0:_setup_layout_template()

	arg_2_0._appid = 795750
	arg_2_0._appid_idx = 1
	arg_2_0._is_selecting_discount_item = false
	arg_2_0._discount_amount = 0
	arg_2_0._discounted_items = {}
	arg_2_0._has_error_discount = false

	arg_2_0:_setup_discount_begin_end_date()

	arg_2_0._backend_store = Managers.backend:get_interface("peddler")
	arg_2_0._itemdef_filename = ""
	arg_2_0._all_feature_items = {}
	arg_2_0._all_slideshow_items = {}
	arg_2_0._missing_file_name = nil
	arg_2_0._timestamp_error = nil
	arg_2_0._tabs = {
		"Feature Page Rotation",
		"Store Discounts",
		"Store Item Utility"
	}
	arg_2_0._selected_tab = arg_2_0._tabs[1]
	arg_2_0._save_successful_discount = ""
	arg_2_0._save_successful_featured = ""
	arg_2_0._cosmetic_items = {}

	arg_2_0:_collect_cosmetic_items_data()
end

function ImguiStoreRotation._cleanup_slideshow(arg_3_0)
	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0 = 1, #arg_3_0._item_keys_list do
		local var_3_2 = arg_3_0._item_keys_list[iter_3_0]
		local var_3_3 = arg_3_0:_is_a_dlc(var_3_2)
		local var_3_4 = var_3_3 and StoreDlcSettingsByName[var_3_2] or rawget(ItemMasterList, var_3_2)

		if not var_3_4 or var_3_4.item_type ~= "bundle" and not var_3_3 and not var_3_4.store_bundle_big_image then
			-- block empty
		elseif var_3_4.item_type == "bundle" or var_3_3 then
			var_3_0[#var_3_0 + 1] = var_3_2
		end
	end

	arg_3_0._slideshow_item_keys = var_3_0
end

function ImguiStoreRotation._filter_item_keys_list(arg_4_0)
	local var_4_0 = {}
	local var_4_1 = {}
	local var_4_2 = {}

	arg_4_0._name_to_key = {}

	for iter_4_0 = 1, #arg_4_0._item_keys_list do
		local var_4_3 = arg_4_0._item_keys_list[iter_4_0]
		local var_4_4 = arg_4_0:_is_a_dlc(var_4_3)
		local var_4_5 = var_4_4 and StoreDlcSettingsByName[var_4_3] or rawget(ItemMasterList, var_4_3)

		if not var_4_5 or var_4_5.item_type == "deed" then
			-- block empty
		else
			local var_4_6 = var_0_4(var_4_5.display_name or var_4_5.name)

			if var_4_5.item_type == "bundle" or var_4_4 then
				var_4_0[#var_4_0 + 1] = var_4_3
				var_4_0[#var_4_0 + 1] = var_4_6
			end

			var_4_1[#var_4_1 + 1] = var_4_3
			var_4_1[#var_4_1 + 1] = var_4_6
			arg_4_0._name_to_key[var_4_6] = var_4_3

			if var_4_5.steam_itemdefid or var_4_5.current_prices then
				var_4_2[#var_4_2 + 1] = var_4_3
				var_4_2[#var_4_2 + 1] = var_4_6
			end
		end
	end

	arg_4_0._searcheable_item_keys.slideshow = var_4_0
	arg_4_0._searcheable_item_keys.featured = var_4_1
	arg_4_0._searcheable_item_keys.discount = var_4_2
end

function ImguiStoreRotation._load_saved_data(arg_5_0)
	arg_5_0._save_data = {}

	if script_data.source_dir then
		local var_5_0 = script_data.source_dir .. var_0_5

		arg_5_0._save_file = io.open(var_5_0, "r")

		if arg_5_0._save_file then
			local var_5_1 = arg_5_0._save_file:read("*all")

			arg_5_0._save_data = cjson.decode(var_5_1)

			arg_5_0._save_file:close()
		else
			arg_5_0._save_data = cjson.decode(var_0_1)
		end
	else
		Application.warning("[ImguiStoreRotation] script_data.source_dir is nil, cannot load store rotation settings, using default!")

		arg_5_0._save_data = cjson.decode(var_0_1)
	end
end

function ImguiStoreRotation._save_settings(arg_6_0)
	arg_6_0._save_data.featured.end_year = arg_6_0._timestamp_year
	arg_6_0._save_data.featured.end_month = arg_6_0._timestamp_month
	arg_6_0._save_data.featured.end_day = arg_6_0._timestamp_day
	arg_6_0._save_data.featured.timestamp = arg_6_0._timestamp
	arg_6_0._save_data.discounts.end_year = arg_6_0._end_discount_year
	arg_6_0._save_data.discounts.end_month = arg_6_0._end_discount_month
	arg_6_0._save_data.discounts.end_day = arg_6_0._end_discount_day

	local var_6_0 = cjson.encode(arg_6_0._save_data)

	if script_data.source_dir then
		local var_6_1 = script_data.source_dir .. var_0_5
		local var_6_2 = assert(io.open(var_6_1, "w"))

		var_6_2:write(var_6_0)
		var_6_2:close()
	else
		Application.warning("[ImguiStoreRotation] script_data.source_dir is nil, cannot save store rotation settings!")
	end
end

function ImguiStoreRotation._setup_timpestamp_fields(arg_7_0)
	arg_7_0._timestamp_year = arg_7_0._save_data.featured.end_year and arg_7_0._save_data.featured.end_year or os.date("%Y")
	arg_7_0._timestamp_month = arg_7_0._save_data.featured.end_month and arg_7_0._save_data.featured.end_month or os.date("%m")
	arg_7_0._timestamp_day = arg_7_0._save_data.featured.end_day and arg_7_0._save_data.featured.end_day or os.date("%d")
	arg_7_0._timestamp_hour = "12"
	arg_7_0._timestamp_minutes = "00"
	arg_7_0._timestamp_seconds = "00"
	arg_7_0._timestamp = arg_7_0._save_data.featured.timestamp and arg_7_0._save_data.featured.timestamp or 0
	arg_7_0._new_rotation_file_name = string.format("layout_%s_%s_%s", os.date("%Y"), os.date("%m"), os.date("%d"))
	arg_7_0._new_discount_file_name = string.format("rotation_%s_%s_%s", os.date("%Y"), os.date("%m"), os.date("%d"))
end

function ImguiStoreRotation._setup_discount_begin_end_date(arg_8_0)
	arg_8_0._begin_discount_year = os.date("%Y")
	arg_8_0._begin_discount_month = os.date("%m")
	arg_8_0._begin_discount_day = os.date("%d")
	arg_8_0._end_discount_year = arg_8_0._save_data.discounts.end_year and arg_8_0._save_data.discounts.end_year or "00"
	arg_8_0._end_discount_month = arg_8_0._save_data.discounts.end_month and arg_8_0._save_data.discounts.end_month or "00"
	arg_8_0._end_discount_day = arg_8_0._save_data.discounts.end_day and arg_8_0._save_data.discounts.end_day or "00"
end

function ImguiStoreRotation._setup_layout_template(arg_9_0)
	local var_9_0 = cjson.decode(var_0_0)

	if var_9_0 then
		arg_9_0._lua_layout = var_9_0
	end
end

function ImguiStoreRotation._setup_item_keys_list(arg_10_0)
	table.clear(arg_10_0._item_keys_list)

	arg_10_0._item_keys_list = table.keys(ItemMasterList)

	table.sort(arg_10_0._item_keys_list)
end

function ImguiStoreRotation._setup_dlc_list(arg_11_0)
	local var_11_0 = 0

	table.clear(arg_11_0._dlc_list)

	for iter_11_0, iter_11_1 in ipairs(UnlockSettings) do
		for iter_11_2, iter_11_3 in pairs(iter_11_1.unlocks) do
			var_11_0 = var_11_0 + 1
			arg_11_0._dlc_list[var_11_0] = iter_11_2
		end
	end

	table.sort(arg_11_0._dlc_list)
	table.append(arg_11_0._item_keys_list, arg_11_0._dlc_list)
end

function ImguiStoreRotation.is_persistent(arg_12_0)
	return false
end

function ImguiStoreRotation.update(arg_13_0)
	if var_0_7 then
		arg_13_0:init()

		var_0_7 = false
	end
end

function ImguiStoreRotation.draw(arg_14_0, arg_14_1)
	if arg_14_0._first_launch then
		local var_14_0, var_14_1 = Application.resolution()

		var_0_6.set_next_window_size(var_14_0 * 0.8, var_14_1 * 0.8)

		arg_14_0._first_launch = false
	end

	local var_14_2 = var_0_6.begin_window("Create Store Rotation", "menu_bar")

	var_0_6.text("This is the store rotation tool!!")
	var_0_6.separator()

	if var_0_6.begin_menu_bar() then
		for iter_14_0, iter_14_1 in ipairs(arg_14_0._tabs) do
			local var_14_3 = arg_14_0._selected_tab ~= iter_14_1 and " " .. iter_14_1 .. " " or "[" .. iter_14_1 .. "]"

			if var_0_6.menu_item(var_14_3) then
				arg_14_0._selected_tab = iter_14_1
			end
		end

		var_0_6.end_menu_bar()
	end

	var_0_6.begin_child_window("child_window", 0, 0, true)

	if arg_14_0._selected_tab == "Feature Page Rotation" then
		arg_14_0:_featured_page_tab()
	elseif arg_14_0._selected_tab == "Store Discounts" then
		arg_14_0:_store_rotation_discounts_tab()
	elseif arg_14_0._selected_tab == "Store Item Utility" then
		arg_14_0:_store_item_utility_tab()
	end

	var_0_6.end_child_window()
	var_0_6:end_window()

	return var_14_2
end

function ImguiStoreRotation._featured_page_tab(arg_15_0)
	arg_15_0:_do_new_file_name()
	arg_15_0:_do_timestamp_settings()
	var_0_6.text("Timestamp: ")
	var_0_6.same_line()
	var_0_6.text_colored(arg_15_0._timestamp, 44, 192, 133, 255)
	var_0_6.separator()
	var_0_6.columns(2, true)
	arg_15_0:_do_edit_buttons()
	arg_15_0:_do_clear_edit_buttons()
	arg_15_0:_do_save_file_button()

	if arg_15_0._save_successful_featured ~= "" then
		var_0_6.text_colored(arg_15_0._save_successful_featured, 255, 196, 0, 255)
	end

	var_0_6.next_column()
	var_0_6.text("Content Preview")
	var_0_6.separator()
	arg_15_0:_draw_layout_slideshow_preview()
	var_0_6.next_column()
	arg_15_0:_handle_error_messages()
end

function ImguiStoreRotation._do_edit_buttons(arg_16_0)
	var_0_6.text("Edit Feature Page Layout and Slideshow Composition")
	var_0_6.dummy(2, 10)

	arg_16_0._localize = var_0_6.checkbox("Localize headers and descriptions in the preview", arg_16_0._localize)

	var_0_6.dummy(2, 10)
	var_0_6.text_colored("EDIT FEATURED PAGE:", 245, 245, 207, 255)
	var_0_6.dummy(2, 5)
	var_0_6.text("Edit Slideshow")
	var_0_6.text_colored("Add the items that will be displayed in the Store Featured Page Slideshow :", 245, 245, 207, 255)

	if var_0_6.button("ADD Slideshow Item", 200, 20) then
		arg_16_0._is_selecting_slideshow_item = true
		arg_16_0._is_selecting_item = false

		arg_16_0:_on_search_type_changed(var_0_3.slideshow)
	end

	if arg_16_0._is_selecting_slideshow_item then
		arg_16_0:_draw_item_selection()

		if arg_16_0._selected_item_index ~= -1 then
			local var_16_0 = arg_16_0._item_search_results[arg_16_0._selected_item_index]

			arg_16_0._slideshow_items[#arg_16_0._slideshow_items + 1] = arg_16_0:_get_slideshow_item(var_16_0)
			arg_16_0._is_selecting_slideshow_item = false
			arg_16_0._selected_item_index = -1
			arg_16_0._item_search_text = ""
		end
	end

	if var_0_6.button("REMOVE LAST Slideshow Item", 200, 20) then
		arg_16_0:_remove_last_added_item(arg_16_0._slideshow_items)
	end

	var_0_6.dummy(2, 10)
	var_0_6.text("Edit Featured Items")
	var_0_6.text_colored("Add the items to highlight as featured in the Store Featured Page :", 245, 245, 207, 255)

	if var_0_6.button("ADD Featured Item", 200, 20) then
		arg_16_0._is_selecting_item = true
		arg_16_0._is_selecting_slideshow_item = false

		arg_16_0:_on_search_type_changed(var_0_3.featured)
	end

	if arg_16_0._is_selecting_item then
		arg_16_0:_draw_item_selection()

		if arg_16_0._selected_item_index ~= -1 then
			local var_16_1 = arg_16_0._item_search_results[arg_16_0._selected_item_index]

			arg_16_0._layout_items[#arg_16_0._layout_items + 1] = arg_16_0:_get_layout_item(var_16_1)
			arg_16_0._is_selecting_item = false
			arg_16_0._selected_item_index = -1
			arg_16_0._item_search_text = ""
		end
	end

	if var_0_6.button("REMOVE LAST Featured Item", 200, 20) then
		arg_16_0:_remove_last_added_item(arg_16_0._layout_items)
	end
end

function ImguiStoreRotation._do_item_selection(arg_17_0)
	if arg_17_0._is_selecting_item or arg_17_0._is_selecting_slideshow_item then
		arg_17_0:_draw_item_selection()

		if arg_17_0._selected_item_index ~= -1 then
			local var_17_0 = arg_17_0._item_search_results[arg_17_0._selected_item_index]

			if arg_17_0._is_selecting_item then
				arg_17_0._layout_items[#arg_17_0._layout_items + 1] = arg_17_0:_get_layout_item(var_17_0)
				arg_17_0._is_selecting_item = false
			end

			if arg_17_0._is_selecting_slideshow_item then
				arg_17_0._slideshow_items[#arg_17_0._slideshow_items + 1] = arg_17_0:_get_slideshow_item(var_17_0)
				arg_17_0._is_selecting_slideshow_item = false
			end

			arg_17_0._selected_item_index = -1
			arg_17_0._item_search_text = ""
		end
	end
end

function ImguiStoreRotation._do_save_file_button(arg_18_0)
	var_0_6.dummy(2, 10)
	var_0_6.text("Preview the featured page rotation, before saving your changes and uploading them.")

	if var_0_6.button("PREVIEW CHANGES", 250, 35) then
		arg_18_0:_preview_changes()
	end

	var_0_6.dummy(2, 10)
	var_0_6.text("Save the edits to the feature page layout in to a file.")

	if var_0_6.button("SAVE FILE AND COPY TO CLIPBOARD", 250, 50) then
		arg_18_0:_save_to_file()
	end

	var_0_6.text("All the edits will be copied to the clipboard as text.")
end

function ImguiStoreRotation._preview_changes(arg_19_0)
	local var_19_0 = Managers.backend:get_interface("peddler")

	if var_19_0:has_force_override() then
		return
	end

	local var_19_1 = false
	local var_19_2, var_19_3 = arg_19_0:_calculate_timestamp(arg_19_0._timestamp_year, arg_19_0._timestamp_month, arg_19_0._timestamp_day, arg_19_0._timestamp_hour, arg_19_0._timestamp_minutes, arg_19_0._timestamp_seconds)

	if not var_19_3 then
		arg_19_0._timestamp_error = true
		var_19_1 = true
	end

	if not var_19_1 then
		arg_19_0._timestamp = var_19_2
		arg_19_0._lua_layout.pages.featured.rotation_timestamp = arg_19_0._timestamp

		arg_19_0:_save_layout_items(arg_19_0._layout_items)
		arg_19_0:_save_slideshow_items(arg_19_0._slideshow_items)

		local var_19_4 = arg_19_0._lua_layout
		local var_19_5 = cjson.encode(var_19_4)

		var_19_0:force_layout_override(var_19_5)
	end
end

function ImguiStoreRotation._draw_layout_slideshow_preview(arg_20_0)
	var_0_6.dummy(2, 10)
	var_0_6.text_colored("LAYOUT ITEMS: " .. tostring(#arg_20_0._layout_items), 0, 179, 255, 255)
	var_0_6.dummy(2, 10)

	if #arg_20_0._layout_items ~= 0 then
		arg_20_0:_draw_selcted_layout_items(arg_20_0._layout_items)
	end

	var_0_6.text_colored("SLIDESHOW ITEMS: " .. tostring(#arg_20_0._slideshow_items), 0, 179, 255, 255)
	var_0_6.dummy(2, 10)

	if #arg_20_0._slideshow_items ~= 0 then
		arg_20_0:_draw_selcted_slideshow_items(arg_20_0._slideshow_items)
	end
end

function ImguiStoreRotation._do_new_file_name(arg_21_0)
	arg_21_0._new_rotation_file_name = var_0_6.input_text("New Rotation File Name ", arg_21_0._new_rotation_file_name)

	var_0_6.dummy(2, 10)
end

local function var_0_8(arg_22_0)
	return arg_22_0.steam_itemdefid and true or false
end

function ImguiStoreRotation._is_a_dlc(arg_23_0, arg_23_1)
	return (table.find(arg_23_0._dlc_list, arg_23_1))
end

function ImguiStoreRotation._get_layout_item(arg_24_0, arg_24_1)
	arg_24_1 = arg_24_0._name_to_key[arg_24_1] or arg_24_1

	local var_24_0 = {}

	if arg_24_0:_is_a_dlc(arg_24_1) then
		var_24_0.id = arg_24_1
		var_24_0.type = "dlc"
	else
		local var_24_1 = rawget(ItemMasterList, arg_24_1)

		if var_0_8(var_24_1) then
			var_24_0.steam_itemdefid = var_24_1.steam_itemdefid
			var_24_0.id = arg_24_1
			var_24_0.type = "item"
			var_24_0.key = arg_24_1
		else
			var_24_0.id = arg_24_1
			var_24_0.type = "item"
		end
	end

	return var_24_0
end

function ImguiStoreRotation._get_slideshow_item(arg_25_0, arg_25_1)
	arg_25_1 = arg_25_0._name_to_key[arg_25_1] or arg_25_1

	local var_25_0 = {}
	local var_25_1
	local var_25_2
	local var_25_3
	local var_25_4
	local var_25_5
	local var_25_6
	local var_25_7 = arg_25_0:_is_a_dlc(arg_25_1)
	local var_25_8 = var_25_7 and "dlc" or "item"
	local var_25_9 = var_25_7 and StoreDlcSettingsByName[arg_25_1] or rawget(ItemMasterList, arg_25_1)

	if not var_25_9 or var_25_9.item_type ~= "bundle" and not var_25_7 and not var_25_9.store_bundle_big_image then
		var_25_0.error_text = "Item " .. arg_25_1 .. " Cannot be used as a slideshow item."

		return var_25_0
	end

	if var_25_9.item_type == "bundle" or var_25_7 then
		local var_25_10 = false

		for iter_25_0 = 1, #StoreDlcSettings do
			local var_25_11 = StoreDlcSettings[iter_25_0]

			if var_25_11.dlc_name == arg_25_1 or var_25_11.name == arg_25_1 then
				if not var_25_11.slideshow_texture then
					var_25_0.error_text = "Item " .. arg_25_1 .. " Cannot be used as a slideshow item."

					return var_25_0
				end

				var_25_8 = "item"
				var_25_2 = var_25_11.name
				var_25_3 = var_25_11.slideshow_texture
				var_25_4 = arg_25_1
				var_25_5 = var_25_11.information_text
				var_25_10 = true
			end
		end

		if not var_25_10 then
			var_25_2 = var_25_9.display_name
			var_25_3 = var_25_9.store_bundle_big_image and string.match(var_25_9.store_bundle_big_image, "[^/]+$") or ""
			var_25_4 = arg_25_1
			var_25_5 = var_25_9.description
		end
	else
		var_25_2 = var_25_9.display_name
		var_25_3 = var_25_9.store_bundle_big_image and string.match(var_25_9.store_bundle_big_image, "[^/]+$") or ""
		var_25_4 = arg_25_1
		var_25_5 = var_25_9.description
	end

	if var_0_8(var_25_9) then
		var_25_0.steam_itemdefid = var_25_9.steam_itemdefid
	end

	var_25_0.product_type = var_25_8
	var_25_0.header = var_25_2
	var_25_0.texture = var_25_3
	var_25_0.product_id = var_25_4
	var_25_0.description = var_25_5

	local var_25_12 = arg_25_0._prio + 100

	var_25_0.prio = var_25_12
	arg_25_0._prio = var_25_12

	return var_25_0
end

function ImguiStoreRotation._draw_item_selection(arg_26_0)
	var_0_6.text("Select Item")

	local var_26_0, var_26_1, var_26_2 = ImguiX.combo_search(arg_26_0._selected_item_index, arg_26_0._item_search_results, arg_26_0._item_search_text, arg_26_0._searcheable_item_keys[arg_26_0._search_type])

	arg_26_0._selected_item_index = var_26_0
	arg_26_0._item_search_results = var_26_1
	arg_26_0._item_search_text = var_26_2
end

function ImguiStoreRotation._draw_selcted_layout_items(arg_27_0, arg_27_1)
	for iter_27_0 = 1, #arg_27_1 do
		local var_27_0 = arg_27_1[iter_27_0]
		local var_27_1 = var_27_0.key or var_27_0.id

		if arg_27_0._localize then
			local var_27_2 = rawget(ItemMasterList, var_27_1)
			local var_27_3 = var_0_4(var_27_2.display_name)

			var_0_6.text_colored("Featured Item: " .. var_27_3, 245, 245, 207, 255)
		else
			var_0_6.text_colored("Featured Item: " .. var_27_1, 245, 245, 207, 255)
		end

		var_0_6.dummy(2, 5)

		for iter_27_1, iter_27_2 in pairs(var_27_0) do
			var_0_6.text_colored(iter_27_1 .. " : ", 0, 186, 112, 255)
			var_0_6.same_line()
			var_0_6.text_colored(tostring(iter_27_2), 0, 193, 212, 255)
		end

		arg_27_0:_draw_selected_item_image(var_27_1)
		var_0_6.dummy(2, 5)
	end
end

function ImguiStoreRotation._draw_selcted_slideshow_items(arg_28_0, arg_28_1)
	for iter_28_0 = 1, #arg_28_1 do
		local var_28_0 = arg_28_1[iter_28_0]

		if not var_28_0.error_text then
			local var_28_1 = var_28_0.product_id or var_28_0.dlc_name

			var_0_6.text_colored("Slideshow Item: " .. var_28_1, 245, 245, 207, 255)
		end

		var_0_6.dummy(2, 5)

		for iter_28_1, iter_28_2 in pairs(var_28_0) do
			if var_28_0.error_text then
				var_0_6.text_colored(iter_28_1 .. " : " .. iter_28_2, 255, 0, 0, 255)
			elseif arg_28_0._localize and (iter_28_1 == "header" or iter_28_1 == "description") then
				local var_28_2 = var_0_4(iter_28_2)

				var_0_6.text_colored(iter_28_1 .. " : ", 0, 186, 112, 255)
				var_0_6.same_line()
				var_0_6.text_colored(var_28_2, 0, 193, 212, 255)
			else
				var_0_6.text_colored(iter_28_1 .. " : ", 0, 186, 112, 255)
				var_0_6.same_line()
				var_0_6.text_colored(tostring(iter_28_2), 0, 193, 212, 255)
			end
		end

		local var_28_3 = var_28_0.product_id or var_28_0.dlc_name

		arg_28_0:_draw_selected_item_image(var_28_3)
		var_0_6.dummy(2, 5)
	end
end

function ImguiStoreRotation._draw_selected_item_image(arg_29_0, arg_29_1)
	local var_29_0 = rawget(ItemMasterList, arg_29_1)

	if var_29_0 then
		if var_29_0.item_type ~= "bundle" then
			local var_29_1 = "store_item_icon_" .. arg_29_1
			local var_29_2 = "gui/1080p/single_textures/store_item_icons/" .. var_29_1 .. "/" .. var_29_1
			local var_29_3 = "resource_packages/store/item_icons/" .. var_29_1

			if not Application.can_get("texture", var_29_2) and Application.can_get("package", var_29_3) then
				local var_29_4 = Managers.package

				local function var_29_5()
					Debug.sticky_text("Image Loaded " .. var_29_2)
				end

				local var_29_6 = callback(var_29_5)
				local var_29_7 = "ImguiStoreRotation"

				var_29_4:load(var_29_3, var_29_7, var_29_6, true)
			elseif Application.can_get("texture", var_29_2) then
				local var_29_8 = 130
				local var_29_9 = 110

				var_0_6.image(var_29_2, var_29_8, var_29_9)
			else
				local var_29_10 = "gui/1080p/single_textures/vermintide_2_logo_for_dark_backgrounds"

				if Application.can_get("texture", var_29_10) then
					local var_29_11 = 342
					local var_29_12 = 192

					var_0_6.image(var_29_10, var_29_11, var_29_12)
					var_0_6.text_colored("Missing Texture for Item: " .. arg_29_1, 0, 186, 112, 255)
				end
			end
		elseif var_29_0.item_type == "bundle" then
			local var_29_13 = "store_item_icon_" .. arg_29_1
			local var_29_14 = "gui/1080p/single_textures/store_bundle/" .. var_29_13
			local var_29_15 = "resource_packages/store/bundle_icons/" .. var_29_13

			if not Application.can_get("texture", var_29_14) and Application.can_get("package", var_29_15) then
				local var_29_16 = Managers.package

				local function var_29_17()
					Debug.sticky_text("Image Loaded " .. var_29_14)
				end

				local var_29_18 = callback(var_29_17)
				local var_29_19 = "ImguiStoreRotation"

				var_29_16:load(var_29_15, var_29_19, var_29_18, true)
			elseif Application.can_get("texture", var_29_14) then
				local var_29_20 = 400
				local var_29_21 = 110

				var_0_6.image(var_29_14, var_29_20, var_29_21)
			else
				var_0_6.text_colored("Loading Texture", 0, 186, 112, 255)
			end
		end
	end
end

function ImguiStoreRotation._do_timestamp_settings(arg_32_0)
	var_0_6.text("Set End Date, This will be used for the countdown displayed at the top of the Store Feature Page ")
	var_0_6.dummy(2, 10)
	var_0_6.columns(6, false)

	arg_32_0._timestamp_year = var_0_6.input_text("<-Year", arg_32_0._timestamp_year)

	var_0_6.next_column()

	arg_32_0._timestamp_month = var_0_6.input_text("<-Month", arg_32_0._timestamp_month)

	var_0_6.next_column()

	arg_32_0._timestamp_day = var_0_6.input_text("<-Day", arg_32_0._timestamp_day)

	var_0_6.next_column()

	arg_32_0._timestamp_hour = var_0_6.input_text("<-Hour", arg_32_0._timestamp_hour)

	var_0_6.next_column()

	arg_32_0._timestamp_minutes = var_0_6.input_text("<-Min", arg_32_0._timestamp_minutes)

	var_0_6.next_column()

	arg_32_0._timestamp_seconds = var_0_6.input_text("<-Secs", arg_32_0._timestamp_seconds)

	var_0_6.next_column()

	if var_0_6.button("Preview Timestamp", 150, 20) then
		arg_32_0._timestamp = arg_32_0:_calculate_timestamp(arg_32_0._timestamp_year, arg_32_0._timestamp_month, arg_32_0._timestamp_day, arg_32_0._timestamp_hour, arg_32_0._timestamp_minutes, arg_32_0._timestamp_seconds)
	end
end

local function var_0_9(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	if arg_33_0 == "" or tonumber(arg_33_0) < tonumber(os.date("%Y")) then
		return false
	elseif arg_33_1 == "" or tonumber(arg_33_1) > 12 or tonumber(arg_33_1) < 1 then
		return false
	elseif not arg_33_2 or arg_33_2 == "" or tonumber(arg_33_2) > 31 or tonumber(arg_33_2) < 1 then
		return false
	elseif arg_33_3 and (arg_33_3 == "" or tonumber(arg_33_3) > 23 or tonumber(arg_33_3) < 0) then
		return false
	elseif arg_33_4 and (arg_33_4 == "" or tonumber(arg_33_4) > 59 or tonumber(arg_33_4) < 0) then
		return false
	elseif arg_33_5 and (arg_33_5 == "" or tonumber(arg_33_5) > 59 or tonumber(arg_33_5) < 0) then
		return false
	end

	return true
end

function ImguiStoreRotation._calculate_timestamp(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6)
	if not var_0_9(arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6) then
		return 0, false
	end

	local var_34_0 = false
	local var_34_1 = os.time({
		day = arg_34_3,
		month = arg_34_2,
		year = arg_34_1,
		hour = arg_34_4,
		min = arg_34_5,
		sec = arg_34_6,
		isdst = var_34_0
	})

	arg_34_0._timestamp_error = false

	return var_34_1, true
end

function ImguiStoreRotation._save_layout_items(arg_35_0, arg_35_1)
	if table.is_empty(arg_35_1) then
		return
	end

	local var_35_0 = arg_35_0._lua_layout.pages.featured.grid

	table.clear(var_35_0)

	for iter_35_0, iter_35_1 in pairs(arg_35_1) do
		var_35_0[#var_35_0 + 1] = iter_35_1
	end

	arg_35_0._lua_layout.pages.featured.grid = var_35_0

	table.dump(arg_35_0._lua_layout.pages.featured, "FEATURED", 5)
end

function ImguiStoreRotation._save_slideshow_items(arg_36_0, arg_36_1)
	if table.is_empty(arg_36_1) then
		return
	end

	local var_36_0 = arg_36_0._lua_layout.pages.featured.slideshow

	table.clear(var_36_0)

	for iter_36_0, iter_36_1 in pairs(arg_36_1) do
		if iter_36_1.error_text then
			-- block empty
		else
			var_36_0[#var_36_0 + 1] = iter_36_1
		end
	end

	arg_36_0._lua_layout.pages.featured.slideshow = var_36_0

	table.dump(arg_36_0._lua_layout.pages.featured, "FEATURED", 5)
end

function ImguiStoreRotation._remove_last_added_item(arg_37_0, arg_37_1)
	arg_37_1[#arg_37_1] = nil
end

function ImguiStoreRotation._do_clear_edit_buttons(arg_38_0)
	var_0_6.dummy(2, 10)
	var_0_6.text("Clear Edits")
	var_0_6.text_colored("Clear the edits made, the uses can delete a whole section or the entire edits. ", 245, 245, 207, 255)

	if var_0_6.button("Clear Featured Items", 180, 20) then
		table.clear(arg_38_0._layout_items)
	end

	if var_0_6.button("Clear Slideshow Items", 180, 20) then
		table.clear(arg_38_0._slideshow_items)

		arg_38_0._prio = 0
	end

	if var_0_6.button("Clear All", 180, 20) then
		table.clear(arg_38_0._layout_items)
		table.clear(arg_38_0._slideshow_items)
	end
end

function ImguiStoreRotation._save_to_file(arg_39_0)
	local var_39_0 = false

	if arg_39_0._new_rotation_file_name == "" then
		arg_39_0._missing_file_name = true
		var_39_0 = true
	end

	local var_39_1, var_39_2 = arg_39_0:_calculate_timestamp(arg_39_0._timestamp_year, arg_39_0._timestamp_month, arg_39_0._timestamp_day, arg_39_0._timestamp_hour, arg_39_0._timestamp_minutes, arg_39_0._timestamp_seconds)

	if not var_39_2 then
		arg_39_0._timestamp_error = true
		var_39_0 = true
	end

	if not var_39_0 then
		arg_39_0._timestamp = var_39_1
		arg_39_0._lua_layout.pages.featured.rotation_timestamp = arg_39_0._timestamp

		arg_39_0:_save_layout_items(arg_39_0._layout_items)
		arg_39_0:_save_slideshow_items(arg_39_0._slideshow_items)

		local var_39_3 = arg_39_0._lua_layout
		local var_39_4 = cjson.encode(var_39_3)
		local var_39_5 = script_data.source_dir

		arg_39_0._fp = assert(io.open(var_39_5 .. "/.shop/rotation/" .. arg_39_0._new_rotation_file_name .. ".json", "w"))

		arg_39_0._fp:write(var_39_4)
		arg_39_0._fp:close()
		Clipboard.put(var_39_4)

		arg_39_0._save_successful_featured = "File saved successfully at\n" .. var_39_5 .. "/.shop/rotation/" .. arg_39_0._new_rotation_file_name .. ".json"

		arg_39_0:_save_settings()
	end
end

function ImguiStoreRotation._calculate_discount(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_1:gsub("%s+", "")
	local var_40_1 = arg_40_2 / 100
	local var_40_2 = string.format("%s%s%sT110000Z", arg_40_0._begin_discount_year, arg_40_0._begin_discount_month, arg_40_0._begin_discount_day)
	local var_40_3 = string.format("%s%s%sT110000Z", arg_40_0._end_discount_year, arg_40_0._end_discount_month, arg_40_0._end_discount_day)
	local var_40_4 = SteamItemService.apply_discounts(var_40_0, var_40_1, var_40_2, var_40_3)

	print(var_40_4)

	return var_40_4
end

function ImguiStoreRotation._make_item_def(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	local var_41_0 = arg_41_2.steam_itemdefid
	local var_41_1 = SteamInventory.get_item_definition_property(var_41_0, "price")
	local var_41_2 = var_0_4(arg_41_2.display_name)
	local var_41_3 = var_0_4(arg_41_2.description)

	return {
		item_quality = 2,
		type = "item",
		purchase_limit = 1,
		tradable = false,
		marketable = false,
		store_hidden = false,
		hidden = false,
		itemdefid = arg_41_2.steam_itemdefid,
		display_type = SteamInventory.get_item_definition_property(var_41_0, "display_type"),
		name = var_41_2,
		price = arg_41_0:_calculate_discount(var_41_1, arg_41_3),
		description = var_41_3,
		name_color = SteamInventory.get_item_definition_property(var_41_0, "name_color"),
		background_color = SteamInventory.get_item_definition_property(var_41_0, "background_color"),
		icon_url = SteamInventory.get_item_definition_property(var_41_0, "icon_url")
	}
end

function ImguiStoreRotation._make_bundle_def(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = arg_42_2.steam_itemdefid
	local var_42_1 = SteamInventory.get_item_definition_property(var_42_0, "price")
	local var_42_2 = var_0_4(arg_42_2 and arg_42_2.display_name or "not_assigned")
	local var_42_3 = var_0_4(arg_42_2 and arg_42_2.description or "not_assigned")

	return {
		item_quality = 2,
		use_bundle_price = true,
		type = "bundle",
		tradable = false,
		marketable = false,
		hidden = false,
		store_hidden = false,
		itemdefid = arg_42_2.steam_itemdefid,
		display_type = SteamInventory.get_item_definition_property(var_42_0, "display_type"),
		bundle = SteamInventory.get_item_definition_property(var_42_0, "bundle"),
		name = var_42_2,
		price = arg_42_0:_calculate_discount(var_42_1, arg_42_3),
		description = var_42_3,
		name_color = SteamInventory.get_item_definition_property(var_42_0, "name_color"),
		background_color = SteamInventory.get_item_definition_property(var_42_0, "background_color"),
		icon_url = SteamInventory.get_item_definition_property(var_42_0, "icon_url")
	}
end

function ImguiStoreRotation._generate_discounted_item(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	if arg_43_2.item_type ~= "bundle" and arg_43_2.item_type ~= "cosmetic_bundle" then
		return arg_43_0:_make_item_def(arg_43_1, arg_43_2, arg_43_3)
	else
		return arg_43_0:_make_bundle_def(arg_43_1, arg_43_2, arg_43_3)
	end
end

function ImguiStoreRotation._draw_dicount_begin_and_end_fields(arg_44_0)
	var_0_6.text("Setup Discount Begin and End Date")
	var_0_6.text_colored("Set the start date from when the an item should be on sale", 245, 245, 207, 255)
	var_0_6.text("Begin Date")
	var_0_6.columns(3, false)
	var_0_6.set_column_width(300)

	arg_44_0._begin_discount_year = var_0_6.input_text("Begin Year", arg_44_0._begin_discount_year)

	var_0_6.next_column()
	var_0_6.set_column_width(300)

	arg_44_0._begin_discount_month = var_0_6.input_text("Begin Month", arg_44_0._begin_discount_month)

	var_0_6.next_column()
	var_0_6.set_column_width(300)

	arg_44_0._begin_discount_day = var_0_6.input_text("Begin Day", arg_44_0._begin_discount_day)

	var_0_6.columns(0, false)
	var_0_6.text("End Date")
	var_0_6.text_colored("Set the end date from when the sale on the item should end", 245, 245, 207, 255)
	var_0_6.columns(3, false)

	arg_44_0._end_discount_year = var_0_6.input_text("End Year", arg_44_0._end_discount_year)

	var_0_6.next_column()
	var_0_6.set_column_width(300)

	arg_44_0._end_discount_month = var_0_6.input_text("End Month", arg_44_0._end_discount_month)

	var_0_6.next_column()
	var_0_6.set_column_width(300)

	arg_44_0._end_discount_day = var_0_6.input_text("End Day", arg_44_0._end_discount_day)

	var_0_6.next_column()
end

function ImguiStoreRotation._store_rotation_discounts_tab(arg_45_0)
	var_0_6.text("Store Rotation Discounts")
	var_0_6.text_colored("This tab only supports discounting STEAM ITEMS.\nSupport to discount PLAYFAB items will be added in the near future.", 255, 0, 0, 255)
	var_0_6.dummy(2, 5)
	var_0_6.text_colored("Set the file name and the Steam Application ID (This field is prefilled to be the 'Vermintide 2 Internal Test' Steam App ID: 795750)", 245, 245, 207, 255)
	arg_45_0:_do_discount_rotation_file_name()
	arg_45_0:_draw_dicount_begin_and_end_fields()
	var_0_6.dummy(2, 5)
	var_0_6.separator()
	var_0_6.columns(2, true)
	var_0_6.text("Edit Discounts")
	arg_45_0:_do_edit_discounts_button()

	local var_45_0 = var_0_9(arg_45_0._end_discount_year, arg_45_0._end_discount_month, arg_45_0._end_discount_day)

	arg_45_0:_do_discount_item_selection(var_45_0)
	arg_45_0:_handle_discount_page_errors(var_45_0)
	arg_45_0:_do_clear_discount_edit_buttons()
	arg_45_0:_do_save_discounted_items_button()

	if arg_45_0._save_successful_discount ~= "" then
		var_0_6.text_colored(arg_45_0._save_successful_discount, 255, 196, 0, 255)
	end

	var_0_6.next_column()
	var_0_6.text("Preview Discounted Items")
	var_0_6.separator()
	arg_45_0:_do_preview_discounted_items()
	var_0_6.next_column()
	var_0_6.columns(0, false)
end

function ImguiStoreRotation._do_discount_rotation_file_name(arg_46_0)
	var_0_6.dummy(2, 3)

	arg_46_0._new_discount_file_name = var_0_6.input_text("Steam Discount File Name", arg_46_0._new_discount_file_name)

	local var_46_0 = var_0_6.combo("Steam App Id", arg_46_0._appid_idx, var_0_2, 2)

	if var_46_0 ~= arg_46_0._appid_idx then
		arg_46_0._appid = var_0_2[var_46_0]
		arg_46_0._appid_idx = var_46_0
	end

	var_0_6.dummy(2, 5)
	var_0_6.separator()
end

function ImguiStoreRotation._do_edit_discounts_button(arg_47_0)
	var_0_6.dummy(2, 10)
	var_0_6.text("Edit Discounts")
	var_0_6.text_colored("Select an item and set the anount of which it should be discounted by", 245, 245, 207, 255)

	if var_0_6.button("DISCOUNT Item", 200, 20) then
		arg_47_0._is_selecting_discount_item = true

		arg_47_0:_on_search_type_changed(var_0_3.discount)
	end

	if var_0_6.button("REMOVE LAST Item", 200, 20) then
		arg_47_0:_remove_last_added_item(arg_47_0._discounted_items)
	end
end

function ImguiStoreRotation._on_search_type_changed(arg_48_0, arg_48_1)
	arg_48_0._search_type = arg_48_1
	arg_48_0._item_search_results = table.clone(arg_48_0._searcheable_item_keys[arg_48_1])
end

function ImguiStoreRotation._do_discount_item_selection(arg_49_0, arg_49_1)
	if arg_49_0._is_selecting_discount_item then
		var_0_6.dummy(2, 5)
		var_0_6.text_colored("OBS! PRESS ENTER", 255, 0, 0, 255)
		var_0_6.same_line()
		var_0_6.text("after inputting the discoiunt to apply it")

		arg_49_0._discount_amount = var_0_6.input_int("Discount amount", arg_49_0._discount_amount)

		arg_49_0:_draw_item_selection()

		if arg_49_0._selected_item_index ~= -1 then
			if arg_49_0._discount_amount > 0 and arg_49_0._discount_amount <= 100 and arg_49_1 then
				local var_49_0 = arg_49_0._item_search_results[arg_49_0._selected_item_index]

				var_49_0 = arg_49_0._name_to_key[var_49_0] or var_49_0

				local var_49_1 = rawget(ItemMasterList, var_49_0)

				fassert(var_49_1, "Item %s is not in the ItemMasterList", var_49_0)

				local var_49_2 = var_0_8(var_49_1)

				arg_49_0._is_playfab_item = not var_49_2

				if var_49_2 then
					local var_49_3 = arg_49_0._discount_amount
					local var_49_4 = arg_49_0:_generate_discounted_item(var_49_0, var_49_1, var_49_3)
					local var_49_5 = {
						key = var_49_0,
						item = var_49_4
					}

					arg_49_0._discounted_items[#arg_49_0._discounted_items + 1] = var_49_5
					arg_49_0._has_error_discount = false
					arg_49_0._selected_item_index = -1
					arg_49_0._item_search_text = ""
					arg_49_0._is_selecting_discount_item = false
				else
					arg_49_0._has_error_discount = true
				end
			else
				arg_49_0._has_error_discount = true
				arg_49_0._selected_item_index = -1
				arg_49_0._item_search_text = ""
			end
		end
	end
end

function ImguiStoreRotation._handle_discount_page_errors(arg_50_0, arg_50_1)
	if arg_50_0._has_error_discount then
		local var_50_0 = ""

		if arg_50_0._discount_amount <= 0 then
			var_50_0 = string.format("ERROR: You are tring to discount an item by %d,\nThe discount amount must be greater than 0", arg_50_0._discount_amount)
		elseif arg_50_0._discount_amount > 100 then
			var_50_0 = string.format("ERROR: You are tring to discount an item by %d,\nThe discount amount must be less then or equal to 100", arg_50_0._discount_amount)
		end

		if not arg_50_1 then
			var_50_0 = var_50_0 .. "\n" .. string.format("ERROR: You are tring to set a discount time with an invalid end date,\nThe date cannot be %s-%s-%s", arg_50_0._end_discount_year, arg_50_0._end_discount_month, arg_50_0._end_discount_day)
		end

		if arg_50_0._is_playfab_item then
			var_50_0 = var_50_0 .. "\n" .. "ERROR: The Item you are trying to discount is a Playfab item.\nCurrently this tool does not support discounting Playfab items."
		end

		if var_50_0 then
			var_0_6.text_colored(var_50_0, 255, 0, 0, 255)
		end
	end
end

function ImguiStoreRotation._do_clear_discount_edit_buttons(arg_51_0)
	var_0_6.dummy(2, 10)
	var_0_6.text("Clear All Discounted Items")
	var_0_6.text_colored("Delete all the edited discounted items.", 245, 245, 207, 255)

	if var_0_6.button("Clear Discounted Items", 200, 20) then
		table.clear(arg_51_0._discounted_items)
	end
end

function ImguiStoreRotation._do_save_discounted_items_button(arg_52_0)
	var_0_6.dummy(2, 10)
	var_0_6.text("Save Discounts")
	var_0_6.text_colored("Save the discounted items to a JSON file, that can be easily uploaded to Steam.", 245, 245, 207, 255)

	if var_0_6.button("SAVE DISCOUNTS TO FILE", 250, 50) then
		arg_52_0:_save_discounts_to_file()
	end
end

function ImguiStoreRotation._do_preview_discounted_items(arg_53_0)
	var_0_6.dummy(2, 10)
	var_0_6.text("DISCOUNTED ITEMS: " .. #arg_53_0._discounted_items)

	if not table.is_empty(arg_53_0._discounted_items) then
		arg_53_0:_draw_discounted_items(arg_53_0._discounted_items)
	end
end

function ImguiStoreRotation._get_from_to_discount_price(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0._backend_store
	local var_54_1 = "Discounted by %d percent from %.2f %s to %.2f %s"
	local var_54_2, var_54_3 = var_54_0:get_steam_item_price(arg_54_1)
	local var_54_4 = var_54_2 - math.floor(var_54_2 * (arg_54_0._discount_amount / 100))

	return (string.format(var_54_1, arg_54_0._discount_amount, var_54_2 * 0.01, var_54_3, var_54_4 * 0.01, var_54_3))
end

function ImguiStoreRotation._draw_discounted_items(arg_55_0, arg_55_1)
	for iter_55_0 = 1, #arg_55_1 do
		local var_55_0 = arg_55_1[iter_55_0]
		local var_55_1 = var_55_0.item
		local var_55_2 = var_55_0.key

		var_0_6.text_colored("Discounted Item: " .. var_55_2, 245, 245, 207, 255)

		local var_55_3 = arg_55_0:_get_from_to_discount_price(var_55_1.itemdefid)

		var_0_6.text(var_55_3)
		var_0_6.dummy(2, 5)

		for iter_55_1, iter_55_2 in pairs(var_55_1) do
			if var_55_1.error_text then
				var_0_6.text_colored(iter_55_1 .. " : " .. iter_55_2, 255, 0, 0, 255)
			else
				var_0_6.text_colored(iter_55_1 .. " : ", 0, 186, 112, 255)
				var_0_6.same_line()
				var_0_6.text_colored(tostring(iter_55_2), 0, 193, 212, 255)
			end
		end

		var_0_6.dummy(2, 5)
	end
end

function ImguiStoreRotation._get_rotation_items(arg_56_0)
	local var_56_0 = {}

	for iter_56_0 = 1, #arg_56_0._discounted_items do
		local var_56_1 = arg_56_0._discounted_items[iter_56_0]

		var_56_0[#var_56_0 + 1] = var_56_1.item
	end

	return var_56_0
end

function ImguiStoreRotation._save_discounts_to_file(arg_57_0)
	if not arg_57_0._has_error_discount then
		local var_57_0 = arg_57_0:_get_rotation_items()
		local var_57_1 = cjson.encode({
			appid = arg_57_0._appid,
			items = var_57_0
		}):gsub("\\/", "/")
		local var_57_2 = script_data.source_dir

		arg_57_0._fp = assert(io.open(var_57_2 .. "/.shop/rotation/" .. arg_57_0._new_discount_file_name .. ".json", "w"))

		arg_57_0._fp:write(var_57_1)
		arg_57_0._fp:close()

		arg_57_0._save_successful_discount = "File saved succsessfully at\n" .. var_57_2 .. "/.shop/rotation/" .. arg_57_0._new_discount_file_name .. ".json"

		arg_57_0:_save_settings()
	end
end

function ImguiStoreRotation._store_item_utility_tab(arg_58_0)
	var_0_6.text("Store Items Utility")
	var_0_6.dummy(2, 5)
	var_0_6.text_colored("Create a .CSV file containing all the items present in the game", 64, 255, 255, 255)
	var_0_6.text_colored("The item information collected will be the Hero Name, Cosmetic Type, Localized Name, Item Key and Which Career Can Wield/Equip the Item", 64, 255, 255, 255)

	if var_0_6.button("Create cosmetics List file", 250, 50) then
		arg_58_0:_create_cosmetics_item_list_file()
	end

	var_0_6.dummy(2, 5)
	var_0_6.text_colored("Create a .JSON file containing all the feature and slideshow items available in the game", 64, 255, 255, 255)

	if var_0_6.button("Create Featured and Slideshow Json file", 250, 50) then
		arg_58_0:_create_rotation_items_json_file()
	end
end

function ImguiStoreRotation._create_rotation_items_json_file(arg_59_0)
	local var_59_0 = arg_59_0:_collect_all_feature_items()
	local var_59_1 = arg_59_0:_collect_all_slideshow_items()
	local var_59_2 = cjson.encode({
		featured_items = var_59_0,
		slideshow_items = var_59_1
	}):gsub("\\/", "/")
	local var_59_3 = script_data.source_dir

	arg_59_0._fp = assert(io.open(var_59_3 .. "/.shop/collected_featured_and_slideshow_items.json", "w"))

	arg_59_0._fp:write(var_59_2)
	arg_59_0._fp:close()
end

function ImguiStoreRotation._collect_all_feature_items(arg_60_0)
	local var_60_0 = {}

	for iter_60_0, iter_60_1 in ipairs(arg_60_0._item_keys_list) do
		var_60_0[iter_60_1] = arg_60_0:_get_layout_item(iter_60_1)
	end

	arg_60_0._all_feature_items = var_60_0

	return var_60_0
end

function ImguiStoreRotation._collect_all_slideshow_items(arg_61_0)
	local var_61_0 = {}

	for iter_61_0, iter_61_1 in pairs(arg_61_0._item_keys_list) do
		local var_61_1 = arg_61_0:_get_slideshow_item(iter_61_1)

		if not var_61_1.error_text then
			var_61_0[iter_61_1] = var_61_1
		end
	end

	arg_61_0._all_slideshow_items = var_61_0

	return var_61_0
end

function ImguiStoreRotation._create_cosmetics_item_list_file(arg_62_0)
	local var_62_0 = "Hero, Comsetic Type, Localized Name, Item Key, Can Wield Careers \n"

	local function var_62_1(arg_63_0)
		local var_63_0 = ""

		for iter_63_0 = 1, #arg_63_0 do
			local var_63_1 = var_0_4(arg_63_0[iter_63_0])

			if iter_63_0 == #arg_63_0 then
				var_63_0 = var_63_0 .. var_63_1
			else
				var_63_0 = var_63_0 .. var_63_1 .. " , "
			end
		end

		return "\" " .. var_63_0 .. " \""
	end

	for iter_62_0, iter_62_1 in pairs(arg_62_0._cosmetic_items) do
		local var_62_2 = var_0_4(iter_62_0)

		if iter_62_0 == "frame" then
			for iter_62_2, iter_62_3 in pairs(iter_62_1) do
				local var_62_3 = var_0_4(iter_62_2)
				local var_62_4 = iter_62_3.item_key

				var_62_0 = var_62_0 .. "\" \"" .. "," .. var_62_2 .. "," .. "\"" .. var_62_3 .. "\"" .. ", " .. var_62_4 .. ", All" .. "\n"
			end
		else
			for iter_62_4, iter_62_5 in pairs(iter_62_1) do
				local var_62_5 = var_0_4(iter_62_4)

				for iter_62_6, iter_62_7 in pairs(iter_62_5) do
					local var_62_6 = var_0_4(iter_62_6)

					var_62_0 = var_62_0 .. var_62_2 .. "," .. var_62_5 .. ","

					local var_62_7 = ""

					if iter_62_7.can_wield then
						var_62_7 = var_62_1(iter_62_7.can_wield)
					end

					var_62_0 = var_62_0 .. "\"" .. var_62_6 .. "\"" .. ", " .. iter_62_7.item_key .. ", " .. var_62_7 .. "\n"
				end
			end
		end
	end

	local var_62_8 = script_data.source_dir

	arg_62_0._fp = assert(io.open(var_62_8 .. "/.shop/cosmetic_items_list.csv", "w"))

	arg_62_0._fp:write(var_62_0)
	arg_62_0._fp:close()
end

local var_0_10 = {
	frame = true,
	skin = true,
	weapon_skin = true,
	cosmetic_bundles = true
}

function ImguiStoreRotation._collect_cosmetic_items_data(arg_64_0)
	local var_64_0 = {}

	for iter_64_0, iter_64_1 in pairs(ItemMasterList) do
		local var_64_1 = iter_64_1.item_type

		if not iter_64_1.base_skin_item and var_0_10[var_64_1] then
			if var_64_1 == "frame" then
				if not var_64_0.frame then
					var_64_0.frame = {}
				end

				local var_64_2 = {
					item_key = iter_64_0,
					icon = iter_64_1.inventory_icon or "icons_placeholder"
				}

				var_64_0.frame[iter_64_1.display_name] = var_64_2
			else
				local var_64_3 = iter_64_1.can_wield[1]
				local var_64_4 = PROFILES_BY_CAREER_NAMES[var_64_3].ingame_display_name

				if not var_64_0[var_64_4] then
					var_64_0[var_64_4] = {}
				end

				local var_64_5 = {
					item_key = iter_64_0,
					can_wield = iter_64_1.can_wield,
					icon = iter_64_1.inventory_icon or "icons_placeholder"
				}
				local var_64_6 = var_64_0[var_64_4]

				if not var_64_6[var_64_1] then
					var_64_6[var_64_1] = {}
				end

				local var_64_7 = iter_64_1.display_name

				var_64_6[var_64_1][var_64_7] = var_64_5
			end
		end
	end

	arg_64_0._cosmetic_items = var_64_0
end

function ImguiStoreRotation._handle_error_messages(arg_65_0)
	if arg_65_0._timestamp_error then
		var_0_6.text_colored("Achtung!!: ", 255, 0, 0, 255)
		var_0_6.same_line()
		var_0_6.text("Something is wrong with the date you have given, something seems to be missing!")
	end

	if arg_65_0._missing_file_name then
		if arg_65_0._new_rotation_file_name ~= "" then
			arg_65_0._missing_file_name = nil
		end

		var_0_6.text_colored("Achtung!!: ", 255, 0, 0, 255)
		var_0_6.same_line()
		var_0_6.text("No new file name has been given please name your file before saving!")
	end
end
