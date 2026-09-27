-- chunkname: @scripts/imgui/imgui_store_rotation.lua

local str = "    {\n        \"pages\": {\n          \"featured\": {\n            \"rotation_timestamp\": 1669633200,\n            \"display_name\": \"menu_store_panel_title_featured\",\n            \"grid\": [\n            ],\n            \"layout\": \"featured\",\n            \"slideshow\": [\n            ],\n            \"sound_event_enter\": \"Play_hud_store_category_front\"\n          },\n          \"dlc\": {\n            \"content\": [\n              \"ultimate_bundle\",\n              \"legacy_bundle\",\n              \"premium_career_bundle\",\n              \"premium_career_bundle_upgrade\",\n              \"shovel\",\n              \"shovel_upgrade\",\n              \"bless\",\n              \"bless_upgrade\",\n              \"woods\",\n              \"woods_upgrade\",\n              \"grass\",\n              \"cog\",\n              \"cog_upgrade\",\n              \"lake\",\n              \"lake_upgrade\",\n              \"scorpion\",\n              \"holly\",\n              \"bogenhafen\",\n              \"pre_order\"\n            ],\n            \"type\": \"dlc\",\n            \"display_name\": \"menu_store_panel_title_dlcs\",\n            \"layout\": \"dlc_list\",\n            \"sound_event_enter\": \"Play_hud_store_category_dlc\"\n          }\n        }\n      }\n"
local str_2 = "    {\n        \"featured\": {\n        },\n        \"discounts\" : {\n        }\n    }\n"
local tbl = {
	[1] = "795750",
	[2] = "552500"
}
local enum = table.enum("slideshow", "featured", "discount")

local function fn(arg_1_0)
	-- function 1
	return (Localize(arg_1_0))
end

local str_3 = "/.shop/imgui_store_tool_save_file.json"

ImguiStoreRotation = class(ImguiStoreRotation)

local Imgui = Imgui
local flag = true

ImguiStoreRotation.init = function (self)
	-- function 2
	self._fp = nil
	self._save_file = nil
	self._first_launch = true

	self:_load_saved_data()

	self._item_keys_list = {}
	self._layout_items = {}
	self._slideshow_items = {}
	self._dlc_list = {}
	self._store_dlc_list = {}
	self._search_type = enum.featured

	self:_setup_timpestamp_fields()

	self._timestamp = 0

	self:_setup_item_keys_list()
	self:_setup_dlc_list()

	self._item_search_results = table.clone(self._item_keys_list)
	self._searcheable_item_keys = {}

	self:_filter_item_keys_list()

	self._is_selecting_item = false
	self._is_selecting_slideshow_item = false
	self._selected_item_index = -1
	self._item_search_text = ""
	self._prio = 0
	self._localize = false

	self:_setup_layout_template()

	self._appid = 795750
	self._appid_idx = 1
	self._is_selecting_discount_item = false
	self._discount_amount = 0
	self._discounted_items = {}
	self._has_error_discount = false

	self:_setup_discount_begin_end_date()

	self._backend_store = Managers.backend:get_interface("peddler")
	self._itemdef_filename = ""
	self._all_feature_items = {}
	self._all_slideshow_items = {}
	self._missing_file_name = nil
	self._timestamp_error = nil
	self._tabs = {
		"Feature Page Rotation",
		"Store Discounts",
		"Store Item Utility"
	}
	self._selected_tab = self._tabs[1]
	self._save_successful_discount = ""
	self._save_successful_featured = ""
	self._cosmetic_items = {}

	self:_collect_cosmetic_items_data()
end

ImguiStoreRotation._cleanup_slideshow = function (self)
	-- function 3
	local tbl = {}
	local tbl_2 = {}

	for i = 1, #self._item_keys_list do
		local var_3_2 = self._item_keys_list[i]
		local _is_a_dlc = self:_is_a_dlc(var_3_2)
		local var_3_4

		if not _is_a_dlc then
			var_3_4 = StoreDlcSettingsByName[var_3_2]

			if not var_3_4 then
				-- Nothing
			end
		end

		var_3_4 = rawget(ItemMasterList, var_3_2)

		::label_3_0::

		if not (not var_3_4 and var_3_4.item_type == "bundle" and _is_a_dlc and var_3_4.store_bundle_big_image) then
			-- Nothing
		elseif var_3_4.item_type == "bundle" or not _is_a_dlc then
			tbl[#tbl + 1] = var_3_2
		end
	end

	self._slideshow_item_keys = tbl
end

ImguiStoreRotation._filter_item_keys_list = function (self)
	-- function 4
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}

	self._name_to_key = {}

	for i = 1, #self._item_keys_list do
		local var_4_3 = self._item_keys_list[i]
		local _is_a_dlc = self:_is_a_dlc(var_4_3)
		local var_4_5

		if not _is_a_dlc then
			var_4_5 = StoreDlcSettingsByName[var_4_3]

			if not var_4_5 then
				-- Nothing
			end
		end

		var_4_5 = rawget(ItemMasterList, var_4_3)

		::label_4_0::

		if not (not var_4_5 and var_4_5.item_type ~= "deed") then
			-- Nothing
		else
			local var_4_6 = fn
			local display_name = var_4_5.display_name

			display_name = display_name or var_4_5.name

			local var_4_8 = var_4_6(display_name)

			if var_4_5.item_type == "bundle" or not _is_a_dlc then
				tbl[#tbl + 1] = var_4_3
				tbl[#tbl + 1] = var_4_8
			end

			tbl_2[#tbl_2 + 1] = var_4_3
			tbl_2[#tbl_2 + 1] = var_4_8
			self._name_to_key[var_4_8] = var_4_3

			if var_4_5.steam_itemdefid or not var_4_5.current_prices then
				tbl_3[#tbl_3 + 1] = var_4_3
				tbl_3[#tbl_3 + 1] = var_4_8
			end
		end
	end

	self._searcheable_item_keys.slideshow = tbl
	self._searcheable_item_keys.featured = tbl_2
	self._searcheable_item_keys.discount = tbl_3
end

ImguiStoreRotation._load_saved_data = function (self)
	-- function 5
	self._save_data = {}

	if not script_data.source_dir then
		local str = script_data.source_dir .. str_3

		self._save_file = io.open(str, "r")

		if not self._save_file then
			local read = self._save_file:read("*all")

			self._save_data = cjson.decode(read)

			self._save_file:close()
		else
			self._save_data = cjson.decode(str_2)
		end
	else
		Application.warning("[ImguiStoreRotation] script_data.source_dir is nil, cannot load store rotation settings, using default!")

		self._save_data = cjson.decode(str_2)
	end
end

ImguiStoreRotation._save_settings = function (self)
	-- function 6
	self._save_data.featured.end_year = self._timestamp_year
	self._save_data.featured.end_month = self._timestamp_month
	self._save_data.featured.end_day = self._timestamp_day
	self._save_data.featured.timestamp = self._timestamp
	self._save_data.discounts.end_year = self._end_discount_year
	self._save_data.discounts.end_month = self._end_discount_month
	self._save_data.discounts.end_day = self._end_discount_day

	local encode = cjson.encode(self._save_data)

	if not script_data.source_dir then
		local str = script_data.source_dir .. str_3
		local var_6_2 = assert(io.open(str, "w"))

		var_6_2:write(encode)
		var_6_2:close()
	else
		Application.warning("[ImguiStoreRotation] script_data.source_dir is nil, cannot save store rotation settings!")
	end
end

ImguiStoreRotation._setup_timpestamp_fields = function (self)
	-- function 7
	local end_year

	if not self._save_data.featured.end_year then
		end_year = self._save_data.featured.end_year

		if not end_year then
			-- Nothing
		end
	end

	end_year = os.date("%Y")

	::label_7_0::

	self._timestamp_year = end_year

	local end_month

	if not self._save_data.featured.end_month then
		end_month = self._save_data.featured.end_month

		if not end_month then
			-- Nothing
		end
	end

	end_month = os.date("%m")

	::label_7_1::

	self._timestamp_month = end_month

	local end_day

	if not self._save_data.featured.end_day then
		end_day = self._save_data.featured.end_day

		if not end_day then
			-- Nothing
		end
	end

	end_day = os.date("%d")

	::label_7_2::

	self._timestamp_day = end_day
	self._timestamp_hour = "12"
	self._timestamp_minutes = "00"
	self._timestamp_seconds = "00"

	local timestamp

	if not self._save_data.featured.timestamp then
		timestamp = self._save_data.featured.timestamp

		if not timestamp then
			-- Nothing
		end
	end

	timestamp = 0

	::label_7_3::

	self._timestamp = timestamp
	self._new_rotation_file_name = string.format("layout_%s_%s_%s", os.date("%Y"), os.date("%m"), os.date("%d"))
	self._new_discount_file_name = string.format("rotation_%s_%s_%s", os.date("%Y"), os.date("%m"), os.date("%d"))
end

ImguiStoreRotation._setup_discount_begin_end_date = function (self)
	-- function 8
	self._begin_discount_year = os.date("%Y")
	self._begin_discount_month = os.date("%m")
	self._begin_discount_day = os.date("%d")

	local end_year

	if not self._save_data.discounts.end_year then
		end_year = self._save_data.discounts.end_year

		if not end_year then
			-- Nothing
		end
	end

	end_year = "00"

	::label_8_0::

	self._end_discount_year = end_year

	local end_month

	if not self._save_data.discounts.end_month then
		end_month = self._save_data.discounts.end_month

		if not end_month then
			-- Nothing
		end
	end

	end_month = "00"

	::label_8_1::

	self._end_discount_month = end_month

	local end_day

	if not self._save_data.discounts.end_day then
		end_day = self._save_data.discounts.end_day

		if not end_day then
			-- Nothing
		end
	end

	end_day = "00"

	::label_8_2::

	self._end_discount_day = end_day
end

ImguiStoreRotation._setup_layout_template = function (self)
	-- function 9
	local decode = cjson.decode(str)

	if not decode then
		self._lua_layout = decode
	end
end

ImguiStoreRotation._setup_item_keys_list = function (self)
	-- function 10
	table.clear(self._item_keys_list)

	self._item_keys_list = table.keys(ItemMasterList)

	table.sort(self._item_keys_list)
end

ImguiStoreRotation._setup_dlc_list = function (self)
	-- function 11
	local num = 0

	table.clear(self._dlc_list)

	for i, v in ipairs(UnlockSettings) do
		for k, v_2 in pairs(v.unlocks) do
			num = num + 1
			self._dlc_list[num] = k
		end
	end

	table.sort(self._dlc_list)
	table.append(self._item_keys_list, self._dlc_list)
end

ImguiStoreRotation.is_persistent = function (arg_12_0)
	-- function 12
	return false
end

ImguiStoreRotation.update = function (self)
	-- function 13
	if not flag then
		self:init()

		flag = false
	end
end

ImguiStoreRotation.draw = function (self, arg_14_1)
	-- function 14
	if not self._first_launch then
		local resolution, var_14_1 = Application.resolution()

		Imgui.set_next_window_size(resolution * 0.8, var_14_1 * 0.8)

		self._first_launch = false
	end

	local begin_window = Imgui.begin_window("Create Store Rotation", "menu_bar")

	Imgui.text("This is the store rotation tool!!")
	Imgui.separator()

	if not Imgui.begin_menu_bar() then
		for i, v in ipairs(self._tabs) do
			local str

			if self._selected_tab ~= v then
				str = " " .. v .. " "

				if not str then
					-- Nothing
				end
			end

			str = "[" .. v .. "]"

			::label_14_0::

			if not Imgui.menu_item(str) then
				self._selected_tab = v
			end
		end

		Imgui.end_menu_bar()
	end

	Imgui.begin_child_window("child_window", 0, 0, true)

	if self._selected_tab == "Feature Page Rotation" then
		self:_featured_page_tab()
	elseif self._selected_tab == "Store Discounts" then
		self:_store_rotation_discounts_tab()
	elseif self._selected_tab == "Store Item Utility" then
		self:_store_item_utility_tab()
	end

	Imgui.end_child_window()
	Imgui:end_window()

	return begin_window
end

ImguiStoreRotation._featured_page_tab = function (self)
	-- function 15
	self:_do_new_file_name()
	self:_do_timestamp_settings()
	Imgui.text("Timestamp: ")
	Imgui.same_line()
	Imgui.text_colored(self._timestamp, 44, 192, 133, 255)
	Imgui.separator()
	Imgui.columns(2, true)
	self:_do_edit_buttons()
	self:_do_clear_edit_buttons()
	self:_do_save_file_button()

	if self._save_successful_featured ~= "" then
		Imgui.text_colored(self._save_successful_featured, 255, 196, 0, 255)
	end

	Imgui.next_column()
	Imgui.text("Content Preview")
	Imgui.separator()
	self:_draw_layout_slideshow_preview()
	Imgui.next_column()
	self:_handle_error_messages()
end

ImguiStoreRotation._do_edit_buttons = function (self)
	-- function 16
	Imgui.text("Edit Feature Page Layout and Slideshow Composition")
	Imgui.dummy(2, 10)

	self._localize = Imgui.checkbox("Localize headers and descriptions in the preview", self._localize)

	Imgui.dummy(2, 10)
	Imgui.text_colored("EDIT FEATURED PAGE:", 245, 245, 207, 255)
	Imgui.dummy(2, 5)
	Imgui.text("Edit Slideshow")
	Imgui.text_colored("Add the items that will be displayed in the Store Featured Page Slideshow :", 245, 245, 207, 255)

	if not Imgui.button("ADD Slideshow Item", 200, 20) then
		self._is_selecting_slideshow_item = true
		self._is_selecting_item = false

		self:_on_search_type_changed(enum.slideshow)
	end

	if not self._is_selecting_slideshow_item then
		self:_draw_item_selection()

		if self._selected_item_index ~= -1 then
			local var_16_0 = self._item_search_results[self._selected_item_index]

			self._slideshow_items[#self._slideshow_items + 1] = self:_get_slideshow_item(var_16_0)
			self._is_selecting_slideshow_item = false
			self._selected_item_index = -1
			self._item_search_text = ""
		end
	end

	if not Imgui.button("REMOVE LAST Slideshow Item", 200, 20) then
		self:_remove_last_added_item(self._slideshow_items)
	end

	Imgui.dummy(2, 10)
	Imgui.text("Edit Featured Items")
	Imgui.text_colored("Add the items to highlight as featured in the Store Featured Page :", 245, 245, 207, 255)

	if not Imgui.button("ADD Featured Item", 200, 20) then
		self._is_selecting_item = true
		self._is_selecting_slideshow_item = false

		self:_on_search_type_changed(enum.featured)
	end

	if not self._is_selecting_item then
		self:_draw_item_selection()

		if self._selected_item_index ~= -1 then
			local var_16_1 = self._item_search_results[self._selected_item_index]

			self._layout_items[#self._layout_items + 1] = self:_get_layout_item(var_16_1)
			self._is_selecting_item = false
			self._selected_item_index = -1
			self._item_search_text = ""
		end
	end

	if not Imgui.button("REMOVE LAST Featured Item", 200, 20) then
		self:_remove_last_added_item(self._layout_items)
	end
end

ImguiStoreRotation._do_item_selection = function (self)
	-- function 17
	if self._is_selecting_item or not self._is_selecting_slideshow_item then
		self:_draw_item_selection()

		if self._selected_item_index ~= -1 then
			local var_17_0 = self._item_search_results[self._selected_item_index]

			if not self._is_selecting_item then
				self._layout_items[#self._layout_items + 1] = self:_get_layout_item(var_17_0)
				self._is_selecting_item = false
			end

			if not self._is_selecting_slideshow_item then
				self._slideshow_items[#self._slideshow_items + 1] = self:_get_slideshow_item(var_17_0)
				self._is_selecting_slideshow_item = false
			end

			self._selected_item_index = -1
			self._item_search_text = ""
		end
	end
end

ImguiStoreRotation._do_save_file_button = function (self)
	-- function 18
	Imgui.dummy(2, 10)
	Imgui.text("Preview the featured page rotation, before saving your changes and uploading them.")

	if not Imgui.button("PREVIEW CHANGES", 250, 35) then
		self:_preview_changes()
	end

	Imgui.dummy(2, 10)
	Imgui.text("Save the edits to the feature page layout in to a file.")

	if not Imgui.button("SAVE FILE AND COPY TO CLIPBOARD", 250, 50) then
		self:_save_to_file()
	end

	Imgui.text("All the edits will be copied to the clipboard as text.")
end

ImguiStoreRotation._preview_changes = function (self)
	-- function 19
	local get_interface = Managers.backend:get_interface("peddler")

	if not get_interface:has_force_override() then
		return
	end

	local flag = false
	local _calculate_timestamp, var_19_3 = self:_calculate_timestamp(self._timestamp_year, self._timestamp_month, self._timestamp_day, self._timestamp_hour, self._timestamp_minutes, self._timestamp_seconds)

	if not var_19_3 then
		self._timestamp_error = true
		flag = true
	end

	if not flag then
		self._timestamp = _calculate_timestamp
		self._lua_layout.pages.featured.rotation_timestamp = self._timestamp

		self:_save_layout_items(self._layout_items)
		self:_save_slideshow_items(self._slideshow_items)

		local _lua_layout = self._lua_layout
		local encode = cjson.encode(_lua_layout)

		get_interface:force_layout_override(encode)
	end
end

ImguiStoreRotation._draw_layout_slideshow_preview = function (self)
	-- function 20
	Imgui.dummy(2, 10)
	Imgui.text_colored("LAYOUT ITEMS: " .. tostring(#self._layout_items), 0, 179, 255, 255)
	Imgui.dummy(2, 10)

	if #self._layout_items ~= 0 then
		self:_draw_selcted_layout_items(self._layout_items)
	end

	Imgui.text_colored("SLIDESHOW ITEMS: " .. tostring(#self._slideshow_items), 0, 179, 255, 255)
	Imgui.dummy(2, 10)

	if #self._slideshow_items ~= 0 then
		self:_draw_selcted_slideshow_items(self._slideshow_items)
	end
end

ImguiStoreRotation._do_new_file_name = function (self)
	-- function 21
	self._new_rotation_file_name = Imgui.input_text("New Rotation File Name ", self._new_rotation_file_name)

	Imgui.dummy(2, 10)
end

local function fn_2(self)
	-- function 22
	local flag

	flag = not self.steam_itemdefid and true and false

	return flag
end

ImguiStoreRotation._is_a_dlc = function (self, arg_23_1)
	-- function 23
	return (table.find(self._dlc_list, arg_23_1))
end

ImguiStoreRotation._get_layout_item = function (self, arg_24_1)
	-- function 24
	arg_24_1 = self._name_to_key[arg_24_1] or arg_24_1

	local tbl = {}

	if not self:_is_a_dlc(arg_24_1) then
		tbl.id = arg_24_1
		tbl.type = "dlc"
	else
		local var_24_1 = rawget(ItemMasterList, arg_24_1)

		if not fn_2(var_24_1) then
			tbl.steam_itemdefid = var_24_1.steam_itemdefid
			tbl.id = arg_24_1
			tbl.type = "item"
			tbl.key = arg_24_1
		else
			tbl.id = arg_24_1
			tbl.type = "item"
		end
	end

	return tbl
end

ImguiStoreRotation._get_slideshow_item = function (self, arg_25_1)
	-- function 25
	arg_25_1 = self._name_to_key[arg_25_1] or arg_25_1

	local tbl = {}
	local var_25_1
	local var_25_2
	local var_25_3
	local var_25_4
	local var_25_5
	local var_25_6
	local _is_a_dlc = self:_is_a_dlc(arg_25_1)
	local flag

	flag = not _is_a_dlc and "dlc" and "item"

	local var_25_9

	if not _is_a_dlc then
		var_25_9 = StoreDlcSettingsByName[arg_25_1]

		if not var_25_9 then
			-- Nothing
		end
	end

	var_25_9 = rawget(ItemMasterList, arg_25_1)

	::label_25_0::

	if not (not var_25_9 and var_25_9.item_type == "bundle" and _is_a_dlc and var_25_9.store_bundle_big_image) then
		tbl.error_text = "Item " .. arg_25_1 .. " Cannot be used as a slideshow item."

		return tbl
	end

	if var_25_9.item_type == "bundle" or not _is_a_dlc then
		local flag_2 = false

		for i = 1, #StoreDlcSettings do
			local var_25_11 = StoreDlcSettings[i]

			if not (var_25_11.dlc_name == arg_25_1 or var_25_11.name ~= arg_25_1) then
				if not var_25_11.slideshow_texture then
					tbl.error_text = "Item " .. arg_25_1 .. " Cannot be used as a slideshow item."

					return tbl
				end

				flag = "item"
				var_25_2 = var_25_11.name
				var_25_3 = var_25_11.slideshow_texture
				var_25_4 = arg_25_1
				var_25_5 = var_25_11.information_text
				flag_2 = true
			end
		end

		if not flag_2 then
			var_25_2 = var_25_9.display_name
			var_25_3 = not var_25_9.store_bundle_big_image and string.match(var_25_9.store_bundle_big_image, "[^/]+$") and ""
			var_25_4 = arg_25_1
			var_25_5 = var_25_9.description
		end
	else
		var_25_2 = var_25_9.display_name
		var_25_3 = not var_25_9.store_bundle_big_image and string.match(var_25_9.store_bundle_big_image, "[^/]+$") and ""
		var_25_4 = arg_25_1
		var_25_5 = var_25_9.description
	end

	if not fn_2(var_25_9) then
		tbl.steam_itemdefid = var_25_9.steam_itemdefid
	end

	tbl.product_type = flag
	tbl.header = var_25_2
	tbl.texture = var_25_3
	tbl.product_id = var_25_4
	tbl.description = var_25_5

	local num = self._prio + 100

	tbl.prio = num
	self._prio = num

	return tbl
end

ImguiStoreRotation._draw_item_selection = function (self)
	-- function 26
	Imgui.text("Select Item")

	local combo_search, var_26_1, var_26_2 = ImguiX.combo_search(self._selected_item_index, self._item_search_results, self._item_search_text, self._searcheable_item_keys[self._search_type])

	self._selected_item_index = combo_search
	self._item_search_results = var_26_1
	self._item_search_text = var_26_2
end

ImguiStoreRotation._draw_selcted_layout_items = function (self, arg_27_1)
	-- function 27
	for i = 1, #arg_27_1 do
		local var_27_0 = arg_27_1[i]
		local key = var_27_0.key

		key = key or var_27_0.id

		if not self._localize then
			local var_27_2 = rawget(ItemMasterList, key)
			local var_27_3 = fn(var_27_2.display_name)

			Imgui.text_colored("Featured Item: " .. var_27_3, 245, 245, 207, 255)
		else
			Imgui.text_colored("Featured Item: " .. key, 245, 245, 207, 255)
		end

		Imgui.dummy(2, 5)

		for k, v in pairs(var_27_0) do
			Imgui.text_colored(k .. " : ", 0, 186, 112, 255)
			Imgui.same_line()
			Imgui.text_colored(tostring(v), 0, 193, 212, 255)
		end

		self:_draw_selected_item_image(key)
		Imgui.dummy(2, 5)
	end
end

ImguiStoreRotation._draw_selcted_slideshow_items = function (self, arg_28_1)
	-- function 28
	for i = 1, #arg_28_1 do
		local var_28_0 = arg_28_1[i]

		if not var_28_0.error_text then
			local product_id = var_28_0.product_id

			product_id = product_id or var_28_0.dlc_name

			Imgui.text_colored("Slideshow Item: " .. product_id, 245, 245, 207, 255)
		end

		Imgui.dummy(2, 5)

		for k, v in pairs(var_28_0) do
			if not var_28_0.error_text then
				Imgui.text_colored(k .. " : " .. v, 255, 0, 0, 255)
			elseif not (not self._localize and k == "header" or k ~= "description") then
				local var_28_2 = fn(v)

				Imgui.text_colored(k .. " : ", 0, 186, 112, 255)
				Imgui.same_line()
				Imgui.text_colored(var_28_2, 0, 193, 212, 255)
			else
				Imgui.text_colored(k .. " : ", 0, 186, 112, 255)
				Imgui.same_line()
				Imgui.text_colored(tostring(v), 0, 193, 212, 255)
			end
		end

		local product_id_2 = var_28_0.product_id

		product_id_2 = product_id_2 or var_28_0.dlc_name

		self:_draw_selected_item_image(product_id_2)
		Imgui.dummy(2, 5)
	end
end

ImguiStoreRotation._draw_selected_item_image = function (arg_29_0, arg_29_1)
	-- function 29
	local var_29_0 = rawget(ItemMasterList, arg_29_1)

	if not var_29_0 then
		if var_29_0.item_type ~= "bundle" then
			local str = "store_item_icon_" .. arg_29_1
			local str_2 = "gui/1080p/single_textures/store_item_icons/" .. str .. "/" .. str
			local str_3 = "resource_packages/store/item_icons/" .. str

			if Application.can_get("texture", str_2) or not Application.can_get("package", str_3) then
				local package = Managers.package

				local function fn()
					-- function 30
					Debug.sticky_text("Image Loaded " .. str_2)
				end

				local var_29_6 = callback(fn)
				local str_4 = "ImguiStoreRotation"

				package:load(str_3, str_4, var_29_6, true)
			elseif not Application.can_get("texture", str_2) then
				local num = 130
				local num_2 = 110

				Imgui.image(str_2, num, num_2)
			else
				local str_5 = "gui/1080p/single_textures/vermintide_2_logo_for_dark_backgrounds"

				if not Application.can_get("texture", str_5) then
					local num_3 = 342
					local num_4 = 192

					Imgui.image(str_5, num_3, num_4)
					Imgui.text_colored("Missing Texture for Item: " .. arg_29_1, 0, 186, 112, 255)
				end
			end
		elseif var_29_0.item_type == "bundle" then
			local str_6 = "store_item_icon_" .. arg_29_1
			local str_7 = "gui/1080p/single_textures/store_bundle/" .. str_6
			local str_8 = "resource_packages/store/bundle_icons/" .. str_6

			if Application.can_get("texture", str_7) or not Application.can_get("package", str_8) then
				local package_2 = Managers.package

				local function fn_2()
					-- function 31
					Debug.sticky_text("Image Loaded " .. str_7)
				end

				local var_29_18 = callback(fn_2)
				local str_9 = "ImguiStoreRotation"

				package_2:load(str_8, str_9, var_29_18, true)
			elseif not Application.can_get("texture", str_7) then
				local num_5 = 400
				local num_6 = 110

				Imgui.image(str_7, num_5, num_6)
			else
				Imgui.text_colored("Loading Texture", 0, 186, 112, 255)
			end
		end
	end
end

ImguiStoreRotation._do_timestamp_settings = function (self)
	-- function 32
	Imgui.text("Set End Date, This will be used for the countdown displayed at the top of the Store Feature Page ")
	Imgui.dummy(2, 10)
	Imgui.columns(6, false)

	self._timestamp_year = Imgui.input_text("<-Year", self._timestamp_year)

	Imgui.next_column()

	self._timestamp_month = Imgui.input_text("<-Month", self._timestamp_month)

	Imgui.next_column()

	self._timestamp_day = Imgui.input_text("<-Day", self._timestamp_day)

	Imgui.next_column()

	self._timestamp_hour = Imgui.input_text("<-Hour", self._timestamp_hour)

	Imgui.next_column()

	self._timestamp_minutes = Imgui.input_text("<-Min", self._timestamp_minutes)

	Imgui.next_column()

	self._timestamp_seconds = Imgui.input_text("<-Secs", self._timestamp_seconds)

	Imgui.next_column()

	if not Imgui.button("Preview Timestamp", 150, 20) then
		self._timestamp = self:_calculate_timestamp(self._timestamp_year, self._timestamp_month, self._timestamp_day, self._timestamp_hour, self._timestamp_minutes, self._timestamp_seconds)
	end
end

local function fn_3(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	-- function 33
	if not (arg_33_0 == "" or not (tonumber(arg_33_0) < tonumber(os.date("%Y")))) then
		return false
	elseif not (arg_33_1 == "" or tonumber(arg_33_1) > 12 or not (tonumber(arg_33_1) < 1)) then
		return false
	elseif not (not arg_33_2 and arg_33_2 == "" and tonumber(arg_33_2) > 31 or not (tonumber(arg_33_2) < 1)) then
		return false
	elseif not (not arg_33_3 and arg_33_3 == "" or tonumber(arg_33_3) > 23 or not (tonumber(arg_33_3) < 0)) then
		return false
	elseif not (not arg_33_4 and arg_33_4 == "" or tonumber(arg_33_4) > 59 or not (tonumber(arg_33_4) < 0)) then
		return false
	elseif not (not arg_33_5 and arg_33_5 == "" or tonumber(arg_33_5) > 59 or not (tonumber(arg_33_5) < 0)) then
		return false
	end

	return true
end

ImguiStoreRotation._calculate_timestamp = function (self, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6)
	-- function 34
	if not fn_3(arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6) then
		return 0, false
	end

	local flag = false
	local time = os.time({
		day = arg_34_3,
		month = arg_34_2,
		year = arg_34_1,
		hour = arg_34_4,
		min = arg_34_5,
		sec = arg_34_6,
		isdst = flag
	})

	self._timestamp_error = false

	return time, true
end

ImguiStoreRotation._save_layout_items = function (self, arg_35_1)
	-- function 35
	if not table.is_empty(arg_35_1) then
		return
	end

	local grid = self._lua_layout.pages.featured.grid

	table.clear(grid)

	for k, v in pairs(arg_35_1) do
		grid[#grid + 1] = v
	end

	self._lua_layout.pages.featured.grid = grid

	table.dump(self._lua_layout.pages.featured, "FEATURED", 5)
end

ImguiStoreRotation._save_slideshow_items = function (self, arg_36_1)
	-- function 36
	if not table.is_empty(arg_36_1) then
		return
	end

	local slideshow = self._lua_layout.pages.featured.slideshow

	table.clear(slideshow)

	for k, v in pairs(arg_36_1) do
		if not v.error_text then
			-- Nothing
		else
			slideshow[#slideshow + 1] = v
		end
	end

	self._lua_layout.pages.featured.slideshow = slideshow

	table.dump(self._lua_layout.pages.featured, "FEATURED", 5)
end

ImguiStoreRotation._remove_last_added_item = function (arg_37_0, arg_37_1)
	-- function 37
	arg_37_1[#arg_37_1] = nil
end

ImguiStoreRotation._do_clear_edit_buttons = function (self)
	-- function 38
	Imgui.dummy(2, 10)
	Imgui.text("Clear Edits")
	Imgui.text_colored("Clear the edits made, the uses can delete a whole section or the entire edits. ", 245, 245, 207, 255)

	if not Imgui.button("Clear Featured Items", 180, 20) then
		table.clear(self._layout_items)
	end

	if not Imgui.button("Clear Slideshow Items", 180, 20) then
		table.clear(self._slideshow_items)

		self._prio = 0
	end

	if not Imgui.button("Clear All", 180, 20) then
		table.clear(self._layout_items)
		table.clear(self._slideshow_items)
	end
end

ImguiStoreRotation._save_to_file = function (self)
	-- function 39
	local flag = false

	if self._new_rotation_file_name == "" then
		self._missing_file_name = true
		flag = true
	end

	local _calculate_timestamp, var_39_2 = self:_calculate_timestamp(self._timestamp_year, self._timestamp_month, self._timestamp_day, self._timestamp_hour, self._timestamp_minutes, self._timestamp_seconds)

	if not var_39_2 then
		self._timestamp_error = true
		flag = true
	end

	if not flag then
		self._timestamp = _calculate_timestamp
		self._lua_layout.pages.featured.rotation_timestamp = self._timestamp

		self:_save_layout_items(self._layout_items)
		self:_save_slideshow_items(self._slideshow_items)

		local _lua_layout = self._lua_layout
		local encode = cjson.encode(_lua_layout)
		local source_dir = script_data.source_dir

		self._fp = assert(io.open(source_dir .. "/.shop/rotation/" .. self._new_rotation_file_name .. ".json", "w"))

		self._fp:write(encode)
		self._fp:close()
		Clipboard.put(encode)

		self._save_successful_featured = "File saved successfully at\n" .. source_dir .. "/.shop/rotation/" .. self._new_rotation_file_name .. ".json"

		self:_save_settings()
	end
end

ImguiStoreRotation._calculate_discount = function (self, arg_40_1, arg_40_2)
	-- function 40
	local gsub = arg_40_1:gsub("%s+", "")
	local num = arg_40_2 / 100
	local format = string.format("%s%s%sT110000Z", self._begin_discount_year, self._begin_discount_month, self._begin_discount_day)
	local format_2 = string.format("%s%s%sT110000Z", self._end_discount_year, self._end_discount_month, self._end_discount_day)
	local apply_discounts = SteamItemService.apply_discounts(gsub, num, format, format_2)

	print(apply_discounts)

	return apply_discounts
end

ImguiStoreRotation._make_item_def = function (self, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	local steam_itemdefid = arg_41_2.steam_itemdefid
	local get_item_definition_property = SteamInventory.get_item_definition_property(steam_itemdefid, "price")
	local var_41_2 = fn(arg_41_2.display_name)
	local var_41_3 = fn(arg_41_2.description)

	return {
		item_quality = 2,
		type = "item",
		purchase_limit = 1,
		tradable = false,
		marketable = false,
		store_hidden = false,
		hidden = false,
		itemdefid = arg_41_2.steam_itemdefid,
		display_type = SteamInventory.get_item_definition_property(steam_itemdefid, "display_type"),
		name = var_41_2,
		price = self:_calculate_discount(get_item_definition_property, arg_41_3),
		description = var_41_3,
		name_color = SteamInventory.get_item_definition_property(steam_itemdefid, "name_color"),
		background_color = SteamInventory.get_item_definition_property(steam_itemdefid, "background_color"),
		icon_url = SteamInventory.get_item_definition_property(steam_itemdefid, "icon_url")
	}
end

ImguiStoreRotation._make_bundle_def = function (self, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local steam_itemdefid = arg_42_2.steam_itemdefid
	local get_item_definition_property = SteamInventory.get_item_definition_property(steam_itemdefid, "price")
	local var_42_2 = fn
	local display_name

	if not arg_42_2 then
		display_name = arg_42_2.display_name

		if not display_name then
			-- Nothing
		end
	end

	display_name = "not_assigned"

	::label_42_0::

	local var_42_4 = var_42_2(display_name)
	local var_42_5 = fn
	local description

	if not arg_42_2 then
		description = arg_42_2.description

		if not description then
			-- Nothing
		end
	end

	description = "not_assigned"

	::label_42_1::

	local var_42_7 = var_42_5(description)

	return {
		item_quality = 2,
		use_bundle_price = true,
		type = "bundle",
		tradable = false,
		marketable = false,
		hidden = false,
		store_hidden = false,
		itemdefid = arg_42_2.steam_itemdefid,
		display_type = SteamInventory.get_item_definition_property(steam_itemdefid, "display_type"),
		bundle = SteamInventory.get_item_definition_property(steam_itemdefid, "bundle"),
		name = var_42_4,
		price = self:_calculate_discount(get_item_definition_property, arg_42_3),
		description = var_42_7,
		name_color = SteamInventory.get_item_definition_property(steam_itemdefid, "name_color"),
		background_color = SteamInventory.get_item_definition_property(steam_itemdefid, "background_color"),
		icon_url = SteamInventory.get_item_definition_property(steam_itemdefid, "icon_url")
	}
end

ImguiStoreRotation._generate_discounted_item = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	if not (arg_43_2.item_type == "bundle" or arg_43_2.item_type == "cosmetic_bundle") then
		return self:_make_item_def(arg_43_1, arg_43_2, arg_43_3)
	else
		return self:_make_bundle_def(arg_43_1, arg_43_2, arg_43_3)
	end
end

ImguiStoreRotation._draw_dicount_begin_and_end_fields = function (self)
	-- function 44
	Imgui.text("Setup Discount Begin and End Date")
	Imgui.text_colored("Set the start date from when the an item should be on sale", 245, 245, 207, 255)
	Imgui.text("Begin Date")
	Imgui.columns(3, false)
	Imgui.set_column_width(300)

	self._begin_discount_year = Imgui.input_text("Begin Year", self._begin_discount_year)

	Imgui.next_column()
	Imgui.set_column_width(300)

	self._begin_discount_month = Imgui.input_text("Begin Month", self._begin_discount_month)

	Imgui.next_column()
	Imgui.set_column_width(300)

	self._begin_discount_day = Imgui.input_text("Begin Day", self._begin_discount_day)

	Imgui.columns(0, false)
	Imgui.text("End Date")
	Imgui.text_colored("Set the end date from when the sale on the item should end", 245, 245, 207, 255)
	Imgui.columns(3, false)

	self._end_discount_year = Imgui.input_text("End Year", self._end_discount_year)

	Imgui.next_column()
	Imgui.set_column_width(300)

	self._end_discount_month = Imgui.input_text("End Month", self._end_discount_month)

	Imgui.next_column()
	Imgui.set_column_width(300)

	self._end_discount_day = Imgui.input_text("End Day", self._end_discount_day)

	Imgui.next_column()
end

ImguiStoreRotation._store_rotation_discounts_tab = function (self)
	-- function 45
	Imgui.text("Store Rotation Discounts")
	Imgui.text_colored("This tab only supports discounting STEAM ITEMS.\nSupport to discount PLAYFAB items will be added in the near future.", 255, 0, 0, 255)
	Imgui.dummy(2, 5)
	Imgui.text_colored("Set the file name and the Steam Application ID (This field is prefilled to be the 'Vermintide 2 Internal Test' Steam App ID: 795750)", 245, 245, 207, 255)
	self:_do_discount_rotation_file_name()
	self:_draw_dicount_begin_and_end_fields()
	Imgui.dummy(2, 5)
	Imgui.separator()
	Imgui.columns(2, true)
	Imgui.text("Edit Discounts")
	self:_do_edit_discounts_button()

	local var_45_0 = fn_3(self._end_discount_year, self._end_discount_month, self._end_discount_day)

	self:_do_discount_item_selection(var_45_0)
	self:_handle_discount_page_errors(var_45_0)
	self:_do_clear_discount_edit_buttons()
	self:_do_save_discounted_items_button()

	if self._save_successful_discount ~= "" then
		Imgui.text_colored(self._save_successful_discount, 255, 196, 0, 255)
	end

	Imgui.next_column()
	Imgui.text("Preview Discounted Items")
	Imgui.separator()
	self:_do_preview_discounted_items()
	Imgui.next_column()
	Imgui.columns(0, false)
end

ImguiStoreRotation._do_discount_rotation_file_name = function (self)
	-- function 46
	Imgui.dummy(2, 3)

	self._new_discount_file_name = Imgui.input_text("Steam Discount File Name", self._new_discount_file_name)

	local combo = Imgui.combo("Steam App Id", self._appid_idx, tbl, 2)

	if combo ~= self._appid_idx then
		self._appid = tbl[combo]
		self._appid_idx = combo
	end

	Imgui.dummy(2, 5)
	Imgui.separator()
end

ImguiStoreRotation._do_edit_discounts_button = function (self)
	-- function 47
	Imgui.dummy(2, 10)
	Imgui.text("Edit Discounts")
	Imgui.text_colored("Select an item and set the anount of which it should be discounted by", 245, 245, 207, 255)

	if not Imgui.button("DISCOUNT Item", 200, 20) then
		self._is_selecting_discount_item = true

		self:_on_search_type_changed(enum.discount)
	end

	if not Imgui.button("REMOVE LAST Item", 200, 20) then
		self:_remove_last_added_item(self._discounted_items)
	end
end

ImguiStoreRotation._on_search_type_changed = function (self, arg_48_1)
	-- function 48
	self._search_type = arg_48_1
	self._item_search_results = table.clone(self._searcheable_item_keys[arg_48_1])
end

ImguiStoreRotation._do_discount_item_selection = function (self, arg_49_1)
	-- function 49
	if not self._is_selecting_discount_item then
		Imgui.dummy(2, 5)
		Imgui.text_colored("OBS! PRESS ENTER", 255, 0, 0, 255)
		Imgui.same_line()
		Imgui.text("after inputting the discoiunt to apply it")

		self._discount_amount = Imgui.input_int("Discount amount", self._discount_amount)

		self:_draw_item_selection()

		if self._selected_item_index ~= -1 then
			if not (not (self._discount_amount > 0) or self._discount_amount <= 100) and not arg_49_1 then
				local var_49_0 = self._item_search_results[self._selected_item_index]

				var_49_0 = self._name_to_key[var_49_0] or var_49_0

				local var_49_1 = rawget(ItemMasterList, var_49_0)

				fassert(var_49_1, "Item %s is not in the ItemMasterList", var_49_0)

				local var_49_2 = fn_2(var_49_1)

				self._is_playfab_item = not var_49_2

				if not var_49_2 then
					local _discount_amount = self._discount_amount
					local _generate_discounted_item = self:_generate_discounted_item(var_49_0, var_49_1, _discount_amount)
					local tbl = {
						key = var_49_0,
						item = _generate_discounted_item
					}

					self._discounted_items[#self._discounted_items + 1] = tbl
					self._has_error_discount = false
					self._selected_item_index = -1
					self._item_search_text = ""
					self._is_selecting_discount_item = false
				else
					self._has_error_discount = true
				end
			else
				self._has_error_discount = true
				self._selected_item_index = -1
				self._item_search_text = ""
			end
		end
	end
end

ImguiStoreRotation._handle_discount_page_errors = function (self, arg_50_1)
	-- function 50
	if not self._has_error_discount then
		local str = ""

		if self._discount_amount <= 0 then
			str = string.format("ERROR: You are tring to discount an item by %d,\nThe discount amount must be greater than 0", self._discount_amount)
		elseif self._discount_amount > 100 then
			str = string.format("ERROR: You are tring to discount an item by %d,\nThe discount amount must be less then or equal to 100", self._discount_amount)
		end

		if not arg_50_1 then
			str = str .. "\n" .. string.format("ERROR: You are tring to set a discount time with an invalid end date,\nThe date cannot be %s-%s-%s", self._end_discount_year, self._end_discount_month, self._end_discount_day)
		end

		if not self._is_playfab_item then
			str = str .. "\n" .. "ERROR: The Item you are trying to discount is a Playfab item.\nCurrently this tool does not support discounting Playfab items."
		end

		if not str then
			Imgui.text_colored(str, 255, 0, 0, 255)
		end
	end
end

ImguiStoreRotation._do_clear_discount_edit_buttons = function (self)
	-- function 51
	Imgui.dummy(2, 10)
	Imgui.text("Clear All Discounted Items")
	Imgui.text_colored("Delete all the edited discounted items.", 245, 245, 207, 255)

	if not Imgui.button("Clear Discounted Items", 200, 20) then
		table.clear(self._discounted_items)
	end
end

ImguiStoreRotation._do_save_discounted_items_button = function (self)
	-- function 52
	Imgui.dummy(2, 10)
	Imgui.text("Save Discounts")
	Imgui.text_colored("Save the discounted items to a JSON file, that can be easily uploaded to Steam.", 245, 245, 207, 255)

	if not Imgui.button("SAVE DISCOUNTS TO FILE", 250, 50) then
		self:_save_discounts_to_file()
	end
end

ImguiStoreRotation._do_preview_discounted_items = function (self)
	-- function 53
	Imgui.dummy(2, 10)
	Imgui.text("DISCOUNTED ITEMS: " .. #self._discounted_items)

	if not table.is_empty(self._discounted_items) then
		self:_draw_discounted_items(self._discounted_items)
	end
end

ImguiStoreRotation._get_from_to_discount_price = function (self, arg_54_1)
	-- function 54
	local _backend_store = self._backend_store
	local str = "Discounted by %d percent from %.2f %s to %.2f %s"
	local get_steam_item_price, var_54_3 = _backend_store:get_steam_item_price(arg_54_1)
	local num = get_steam_item_price - math.floor(get_steam_item_price * (self._discount_amount / 100))

	return (string.format(str, self._discount_amount, get_steam_item_price * 0.01, var_54_3, num * 0.01, var_54_3))
end

ImguiStoreRotation._draw_discounted_items = function (self, arg_55_1)
	-- function 55
	for i = 1, #arg_55_1 do
		local var_55_0 = arg_55_1[i]
		local item = var_55_0.item
		local key = var_55_0.key

		Imgui.text_colored("Discounted Item: " .. key, 245, 245, 207, 255)

		local _get_from_to_discount_price = self:_get_from_to_discount_price(item.itemdefid)

		Imgui.text(_get_from_to_discount_price)
		Imgui.dummy(2, 5)

		for k, v in pairs(item) do
			if not item.error_text then
				Imgui.text_colored(k .. " : " .. v, 255, 0, 0, 255)
			else
				Imgui.text_colored(k .. " : ", 0, 186, 112, 255)
				Imgui.same_line()
				Imgui.text_colored(tostring(v), 0, 193, 212, 255)
			end
		end

		Imgui.dummy(2, 5)
	end
end

ImguiStoreRotation._get_rotation_items = function (self)
	-- function 56
	local tbl = {}

	for i = 1, #self._discounted_items do
		local var_56_1 = self._discounted_items[i]

		tbl[#tbl + 1] = var_56_1.item
	end

	return tbl
end

ImguiStoreRotation._save_discounts_to_file = function (self)
	-- function 57
	if not self._has_error_discount then
		local _get_rotation_items = self:_get_rotation_items()
		local gsub = cjson.encode({
			appid = self._appid,
			items = _get_rotation_items
		}):gsub("\\/", "/")
		local source_dir = script_data.source_dir

		self._fp = assert(io.open(source_dir .. "/.shop/rotation/" .. self._new_discount_file_name .. ".json", "w"))

		self._fp:write(gsub)
		self._fp:close()

		self._save_successful_discount = "File saved succsessfully at\n" .. source_dir .. "/.shop/rotation/" .. self._new_discount_file_name .. ".json"

		self:_save_settings()
	end
end

ImguiStoreRotation._store_item_utility_tab = function (self)
	-- function 58
	Imgui.text("Store Items Utility")
	Imgui.dummy(2, 5)
	Imgui.text_colored("Create a .CSV file containing all the items present in the game", 64, 255, 255, 255)
	Imgui.text_colored("The item information collected will be the Hero Name, Cosmetic Type, Localized Name, Item Key and Which Career Can Wield/Equip the Item", 64, 255, 255, 255)

	if not Imgui.button("Create cosmetics List file", 250, 50) then
		self:_create_cosmetics_item_list_file()
	end

	Imgui.dummy(2, 5)
	Imgui.text_colored("Create a .JSON file containing all the feature and slideshow items available in the game", 64, 255, 255, 255)

	if not Imgui.button("Create Featured and Slideshow Json file", 250, 50) then
		self:_create_rotation_items_json_file()
	end
end

ImguiStoreRotation._create_rotation_items_json_file = function (self)
	-- function 59
	local _collect_all_feature_items = self:_collect_all_feature_items()
	local _collect_all_slideshow_items = self:_collect_all_slideshow_items()
	local gsub = cjson.encode({
		featured_items = _collect_all_feature_items,
		slideshow_items = _collect_all_slideshow_items
	}):gsub("\\/", "/")
	local source_dir = script_data.source_dir

	self._fp = assert(io.open(source_dir .. "/.shop/collected_featured_and_slideshow_items.json", "w"))

	self._fp:write(gsub)
	self._fp:close()
end

ImguiStoreRotation._collect_all_feature_items = function (self)
	-- function 60
	local tbl = {}

	for i, v in ipairs(self._item_keys_list) do
		tbl[v] = self:_get_layout_item(v)
	end

	self._all_feature_items = tbl

	return tbl
end

ImguiStoreRotation._collect_all_slideshow_items = function (self)
	-- function 61
	local tbl = {}

	for k, v in pairs(self._item_keys_list) do
		local _get_slideshow_item = self:_get_slideshow_item(v)

		if not _get_slideshow_item.error_text then
			tbl[v] = _get_slideshow_item
		end
	end

	self._all_slideshow_items = tbl

	return tbl
end

ImguiStoreRotation._create_cosmetics_item_list_file = function (self)
	-- function 62
	local str = "Hero, Comsetic Type, Localized Name, Item Key, Can Wield Careers \n"

	local function fn_2(self)
		-- function 63
		local str = ""

		for i = 1, #self do
			local var_63_1 = fn(self[i])

			if i == #self then
				str = str .. var_63_1
			else
				str = str .. var_63_1 .. " , "
			end
		end

		return "\" " .. str .. " \""
	end

	for k, v in pairs(self._cosmetic_items) do
		local var_62_2 = fn(k)

		if k == "frame" then
			for k_2, v_2 in pairs(v) do
				local var_62_3 = fn(k_2)
				local item_key = v_2.item_key

				str = str .. "\" \"" .. "," .. var_62_2 .. "," .. "\"" .. var_62_3 .. "\"" .. ", " .. item_key .. ", All" .. "\n"
			end
		else
			for k_3, v_3 in pairs(v) do
				local var_62_5 = fn(k_3)

				for k_4, v_4 in pairs(v_3) do
					local var_62_6 = fn(k_4)

					str = str .. var_62_2 .. "," .. var_62_5 .. ","

					local str_2 = ""

					if not v_4.can_wield then
						str_2 = fn_2(v_4.can_wield)
					end

					str = str .. "\"" .. var_62_6 .. "\"" .. ", " .. v_4.item_key .. ", " .. str_2 .. "\n"
				end
			end
		end
	end

	local source_dir = script_data.source_dir

	self._fp = assert(io.open(source_dir .. "/.shop/cosmetic_items_list.csv", "w"))

	self._fp:write(str)
	self._fp:close()
end

local tbl_2 = {
	frame = true,
	skin = true,
	weapon_skin = true,
	cosmetic_bundles = true
}

ImguiStoreRotation._collect_cosmetic_items_data = function (self)
	-- function 64
	local tbl = {}

	for k, v in pairs(ItemMasterList) do
		local item_type = v.item_type

		if v.base_skin_item or not tbl_2[item_type] then
			if item_type == "frame" then
				if not tbl.frame then
					tbl.frame = {}
				end

				local tbl_3 = {
					item_key = k
				}
				local inventory_icon = v.inventory_icon

				inventory_icon = inventory_icon or "icons_placeholder"
				tbl_3.icon = inventory_icon
				tbl.frame[v.display_name] = tbl_3
			else
				local var_64_4 = v.can_wield[1]
				local ingame_display_name = PROFILES_BY_CAREER_NAMES[var_64_4].ingame_display_name

				if not tbl[ingame_display_name] then
					tbl[ingame_display_name] = {}
				end

				local tbl_4 = {
					item_key = k,
					can_wield = v.can_wield
				}
				local inventory_icon_2 = v.inventory_icon

				inventory_icon_2 = inventory_icon_2 or "icons_placeholder"
				tbl_4.icon = inventory_icon_2

				local var_64_8 = tbl[ingame_display_name]

				if not var_64_8[item_type] then
					var_64_8[item_type] = {}
				end

				local display_name = v.display_name

				var_64_8[item_type][display_name] = tbl_4
			end
		end
	end

	self._cosmetic_items = tbl
end

ImguiStoreRotation._handle_error_messages = function (self)
	-- function 65
	if not self._timestamp_error then
		Imgui.text_colored("Achtung!!: ", 255, 0, 0, 255)
		Imgui.same_line()
		Imgui.text("Something is wrong with the date you have given, something seems to be missing!")
	end

	if not self._missing_file_name then
		if self._new_rotation_file_name ~= "" then
			self._missing_file_name = nil
		end

		Imgui.text_colored("Achtung!!: ", 255, 0, 0, 255)
		Imgui.same_line()
		Imgui.text("No new file name has been given please name your file before saving!")
	end
end
