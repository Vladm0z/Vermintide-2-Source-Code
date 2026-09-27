-- chunkname: @scripts/ui/views/hero_view/windows/store/store_window_item_list.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/store/definitions/store_window_item_list_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local num = 10
local num_2 = 800

StoreWindowItemList = class(StoreWindowItemList)
StoreWindowItemList.NAME = "StoreWindowItemList"

StoreWindowItemList.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate StoreWindowItemList")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local get_renderers, var_1_1 = self._parent:get_renderers()

	self._ui_renderer = get_renderers
	self._ui_top_renderer = var_1_1
	self._render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self._layout_settings = arg_1_1.layout_settings
	self._animations = {}
	self._ui_animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)
	self._parent:set_list_details_visibility(true)
	self._parent:set_list_details_length(930, 0.3)
	self._parent:change_generic_actions("default")
end

StoreWindowItemList._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {
		widgets_by_name = self._widgets_by_name,
		list_widgets = self._list_widgets
	}
	local start_animation = self._ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

StoreWindowItemList._create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	local list_scrollbar = self._widgets_by_name.list_scrollbar

	self._scrollbar_logic = ScrollBarLogic:new(list_scrollbar)
end

StoreWindowItemList.on_exit = function (self, arg_4_1, arg_4_2)
	-- function 4
	print("[HeroViewWindow] Exit Substate StoreWindowItemList")

	self._ui_animator = nil

	self:_destroy_product_widgets(arg_4_2)
end

StoreWindowItemList.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_handle_gamepad_activity()

	if not self:_sync_products_version() then
		self:_update_item_list()

		if not self._initialized then
			self._initialized = true

			self:_start_transition_animation("on_enter")
		end
	end

	self:_update_animations(arg_5_1)
	self:_draw(arg_5_1)
end

StoreWindowItemList.post_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self._initialized then
		self:_handle_input(arg_6_1, arg_6_2)
	end
end

StoreWindowItemList._sync_products_version = function (self)
	-- function 7
	local products_version_id = self._parent:products_version_id()

	if products_version_id ~= self._products_version_id then
		self._products_version_id = products_version_id

		return true
	end

	return false
end

StoreWindowItemList._update_animations = function (self, arg_8_1)
	-- function 8
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_8_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_8_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	if not self._list_initialized then
		self:_animate_list_entries(arg_8_1)
	end
end

StoreWindowItemList._is_list_hovered = function (self)
	-- function 9
	local is_hover = self._widgets_by_name.list.content.list_hotspot.is_hover

	is_hover = is_hover or false

	return is_hover
end

StoreWindowItemList._handle_input = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _parent = self._parent
	local _widgets_by_name = self._widgets_by_name
	local window_input_service = self._parent:window_input_service()

	if not self._list_initialized then
		if not self:_is_list_hovered() then
			local _list_index_pressed = self:_list_index_pressed()

			if not _list_index_pressed then
				self:_play_sound("Play_hud_store_button_select")
				self:_on_list_index_selected(_list_index_pressed)
			end
		end

		if not self._gamepad_active_last_frame then
			self:_handle_gamepad_grid_selection(window_input_service)
		end

		self._scrollbar_logic:update(arg_10_1, arg_10_2)
		self:_update_scroll_position()
	end
end

StoreWindowItemList._draw = function (self, arg_11_1)
	-- function 11
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_11_1, nil, _render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	if not self._list_initialized then
		local _list_widgets = self._list_widgets

		if not _list_widgets then
			local _update_visible_list_entries = self:_update_visible_list_entries()

			for i_2, v_2 in ipairs(_list_widgets) do
				if _update_visible_list_entries or not v_2.content.visible then
					UIRenderer.draw_widget(_ui_top_renderer, v_2)
				end
			end
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

StoreWindowItemList._play_sound = function (self, arg_12_1)
	-- function 12
	self._parent:play_sound(arg_12_1)
end

StoreWindowItemList._handle_gamepad_activity = function (self)
	-- function 13
	local is_device_active = Managers.input:is_device_active("mouse")
	local flag = self._gamepad_active_last_frame == nil

	if not is_device_active then
		if not self._gamepad_active_last_frame and not flag then
			self._gamepad_active_last_frame = true
		end
	elseif self._gamepad_active_last_frame or not flag then
		self._gamepad_active_last_frame = false
	end
end

StoreWindowItemList._list_index_pressed = function (self)
	-- function 14
	local _list_widgets = self._list_widgets

	if not _list_widgets then
		for i, v in ipairs(_list_widgets) do
			local content = v.content
			local hotspot = content.hotspot

			hotspot = hotspot or content.button_hotspot

			if not hotspot and not hotspot.on_release then
				hotspot.on_release = false

				return i
			end
		end
	end
end

StoreWindowItemList._animate_list_entries = function (self, arg_15_1)
	-- function 15
	local _parent = self._parent
	local _is_list_hovered = self:_is_list_hovered()

	if not self._gamepad_active_last_frame then
		_is_list_hovered = true
	end

	local _list_widgets = self._list_widgets

	for i, v in ipairs(_list_widgets) do
		local content = v.content
		local style = v.style
		local button_hotspot = content.button_hotspot

		button_hotspot = button_hotspot or content.hotspot

		if not button_hotspot.on_hover_enter then
			self:_play_sound("Play_hud_store_button_hover")

			button_hotspot.on_hover_enter = false
		end

		_parent:animate_store_product(v, arg_15_1, _is_list_hovered)
	end
end

StoreWindowItemList._get_items_by_filter = function (arg_16_0, arg_16_1)
	-- function 16
	return (Managers.backend:get_interface("peddler"):get_filtered_items(arg_16_1))
end

StoreWindowItemList._get_all_items = function (arg_17_0)
	-- function 17
	return (Managers.backend:get_interface("peddler"):get_peddler_stock())
end

StoreWindowItemList._update_item_list = function (self)
	-- function 18
	if not self._initialized then
		local item = self._params.selected_product.item

		if self._params.selected_product.product_type == "collection" then
			local get_interface = Managers.backend:get_interface("items")
			local bundle = self._params.selected_product.product_item.data.bundle
			local flag = not bundle and bundle.BundledItems
			local flag_2 = true

			for i = 1, #flag do
				local var_18_5 = flag[i]

				if not get_interface:has_item(var_18_5) then
					flag_2 = false

					break
				end
			end

			if not flag_2 then
				for j = 1, #self._list_widgets do
					self._list_widgets[j].content.owned = true
				end
			end
		elseif not item then
			local get_interface_2 = Managers.backend:get_interface("items")
			local key = item.key
			local has_item = get_interface_2:has_item(key)

			if not has_item then
				has_item = get_interface_2:has_weapon_illusion(key)
				has_item = has_item or get_interface_2:has_bundle_contents(item.data.bundle_contains)
			end

			local item_type = item.data.item_type

			item.owned = has_item
			self._list_widgets[self._selected_gamepad_grid_index].content.owned = has_item
		end

		return
	end

	self:_destroy_product_widgets()

	local get_store_path = self._parent:get_store_path()
	local pages = StoreLayoutConfig.pages
	local var_18_12 = get_store_path[#get_store_path]
	local var_18_13 = pages[var_18_12]

	var_18_13 = var_18_13 or self._parent:get_temporary_page(var_18_12)

	local type = var_18_13.type
	local content = var_18_13.content
	local tbl = {}

	if type == "item" then
		local get_item_filter = StoreLayoutConfig.get_item_filter(get_store_path, callback(self._parent.get_temporary_page, self))
		local _get_items_by_filter = self:_get_items_by_filter(get_item_filter)
		local num = 0

		for k, v in pairs(_get_items_by_filter) do
			local data = v.data
			local flag_3 = not data and data.bundle

			if not flag_3 then
				for i_2, v_2 in ipairs(flag_3.BundledItems) do
					local clone = table.clone(ItemMasterList[v_2])

					clone.data = clone

					local tbl_2 = {
						item = clone,
						type = type,
						product_id = data.key,
						sort_key = clone.key,
						settings = {
							hide_price = true,
							icon_size = data.icon_size
						}
					}

					tbl[#tbl + 1] = tbl_2
				end
			else
				tbl[num], num = {
					item = v,
					type = type,
					product_id = v.key,
					sort_key = StoreLayoutConfig.make_sort_key(v)
				}, num + 1
			end
		end

		table.sort(tbl, StoreLayoutConfig.compare_sort_key)
	elseif type == "dlc" then
		for i_3, v_3 in ipairs(content) do
			local find_by_key = table.find_by_key(StoreDlcSettings, "dlc_name", v_3)
			local var_18_25 = StoreDlcSettings[find_by_key]

			if not var_18_25 then
				tbl[#tbl + 1] = {
					dlc_settings = var_18_25,
					type = type,
					product_id = var_18_25.dlc_name
				}
			end
		end
	elseif type == "bundle_items" then
		local bundle_contains = var_18_13.bundle_contains

		for k_2, v_4 in pairs(bundle_contains) do
			local var_18_27 = ItemMasterList[v_4]

			tbl[#tbl + 1] = {
				type = "item",
				item = {
					dlc_name = var_18_13.dlc_name,
					data = var_18_27
				},
				product_id = var_18_27.key,
				settings = {
					hide_price = true,
					hide_new = true
				}
			}
		end
	elseif type == "collection_item" then
		local str = ""
		local num_2 = 0
		local var_18_30 = get_store_path[#get_store_path]
		local var_18_31 = pages[var_18_30]

		var_18_31 = var_18_31 or self._parent:get_temporary_page(var_18_30)

		if not var_18_31.item_filter then
			if num_2 > 0 then
				str = str .. " and "
			end

			str = str .. var_18_31.item_filter
			num_2 = num_2 + 1
		end

		local var_18_32

		if num_2 > 0 then
			var_18_32 = self:_get_items_by_filter(str)
		else
			var_18_32 = self:_get_all_items()
		end

		for k_3, v_5 in pairs(var_18_32) do
			local data_2 = v_5.data
			local flag_4 = not data_2 and data_2.bundle

			for i_4, v_6 in ipairs(flag_4.BundledItems) do
				local clone_2 = table.clone(ItemMasterList[v_6])

				clone_2.data = table.clone(clone_2)
				tbl[#tbl + 1] = {
					product_type = "collection",
					item = clone_2,
					product_item = v_5,
					type = clone_2.item_type,
					product_id = v_5.key,
					settings = {
						hide_price = true,
						part_of_bundle = true,
						hide_new = true,
						icon_size = data_2.icon_size
					},
					parent_settings = {
						icon_size = data_2.icon_size
					},
					sort_key = StoreLayoutConfig.make_sort_key(clone_2)
				}
			end

			table.sort(tbl, StoreLayoutConfig.compare_sort_key)
		end
	end

	self._layout = tbl

	self:_create_product_widgets(tbl)

	self._list_initialized = true
end

local tbl = {
	common = 2,
	promo = 7,
	magic = 5,
	plentiful = 1,
	exotic = 4,
	rare = 3,
	unique = 6
}

StoreWindowItemList._sort_peddler_items_by_type = function (arg_19_0, arg_19_1)
	-- function 19
	local tbl_2 = {}

	table.clear(tbl_2)

	local tbl_3 = {}
	local var_19_2

	for k, v in pairs(arg_19_1) do
		local flag = not v.data and v.data.item_type and "unknown"

		if flag == "weapon_skin" then
			flag = not v.data and v.data.matching_item_key and "unknown"
		end

		local var_19_4 = tbl_2[flag]

		var_19_4 = var_19_4 or {}
		tbl_2[flag] = var_19_4
		tbl_2[flag][#tbl_2[flag] + 1] = v
	end

	local function fn(self, arg_20_1)
		-- function 20
		local var_20_0

		if not self.data and not self.data.rarity then
			var_20_0 = tbl[self.data.rarity]

			if not var_20_0 then
				-- Nothing
			end
		end

		var_20_0 = 1

		do
			local var_20_1
		end

		::label_20_0::

		if not arg_20_1.data and not arg_20_1.data.rarity then
			var_20_1 = tbl[arg_20_1.data.rarity]

			if not var_20_1 then
				-- Nothing
			end
		end

		var_20_1 = 1

		::label_20_1::

		return var_20_1 < var_20_0
	end

	for k_2, v_2 in pairs(tbl_2) do
		table.sort(v_2, fn)
		table.append(tbl_3, v_2)
		print(k_2)
	end

	return tbl_3
end

StoreWindowItemList._sort_peddler_items_by_price = function (arg_21_0, arg_21_1)
	-- function 21
	local function fn(self, arg_22_1)
		-- function 22
		local SM

		if not self.current_prices then
			SM = self.current_prices.SM

			if not SM then
				-- Nothing
			end
		end

		SM = 0

		do
			local SM_2
		end

		::label_22_0::

		if not arg_22_1.current_prices then
			SM_2 = arg_22_1.current_prices.SM

			if not SM_2 then
				-- Nothing
			end
		end

		SM_2 = 0

		::label_22_1::

		return SM_2 < SM
	end

	table.sort(arg_21_1, fn)

	return arg_21_1
end

StoreWindowItemList._get_list_index_by_product_id = function (self, arg_23_1)
	-- function 23
	local _layout = self._layout
	local num = 1

	for i, v in ipairs(_layout) do
		if v.product_id == arg_23_1 then
			return i
		end
	end
end

StoreWindowItemList._on_list_index_selected = function (self, arg_24_1, arg_24_2)
	-- function 24
	local var_24_0 = self._layout[arg_24_1]

	self._params.selected_product = var_24_0

	local _list_widgets = self._list_widgets

	if not var_24_0.item then
		local data = var_24_0.item.data

		ItemHelper.set_shop_item_seen(var_24_0.product_id, data.item_type, self._parent.tab_cat)
	elseif not var_24_0.dlc_settings then
		ItemHelper.set_shop_item_seen(var_24_0.product_id, "dlc", self._parent.tab_cat)
	end

	local var_24_3
	local var_24_4

	if not _list_widgets then
		for i, v in ipairs(_list_widgets) do
			local content = v.content
			local hotspot = content.hotspot

			hotspot = hotspot or content.button_hotspot

			if not hotspot then
				local flag = i == arg_24_1

				hotspot.is_selected = flag

				if not flag then
					var_24_3 = content.row
					var_24_4 = content.column
					hotspot.on_hover_enter = true
				end
			end
		end
	end

	self._previous_gamepad_grid_index = self._selected_gamepad_grid_index
	self._previous_gamepad_grid_row = self._selected_gamepad_grid_row
	self._previous_gamepad_grid_column = self._selected_gamepad_grid_column
	self._selected_gamepad_grid_index = arg_24_1
	self._selected_gamepad_grid_row = var_24_3
	self._selected_gamepad_grid_column = var_24_4

	if not arg_24_2 then
		local scroll_bar_info = self._widgets_by_name.list_scrollbar.content.scroll_bar_info
		local function_by_time = UIAnimation.function_by_time
		local var_24_10 = scroll_bar_info
		local str = "scroll_value"
		local scroll_value = scroll_bar_info.scroll_value
		local var_24_13 = arg_24_2
		local num = 0.3
		local easeOutCubic = math.easeOutCubic

		self._ui_animations.scrollbar = UIAnimation.init(function_by_time, var_24_10, str, scroll_value, var_24_13, num, easeOutCubic)
	else
		self._ui_animations.scrollbar = nil
	end
end

StoreWindowItemList._create_product_widgets = function (self, arg_25_1)
	-- function 25
	local tbl = {}
	local _parent = self._parent
	local str = "item_root"
	local flag = true

	for i, v in ipairs(arg_25_1) do
		local create_item_widget = _parent:create_item_widget(v, str, flag)

		_parent:populate_product_widget(create_item_widget, v)

		tbl[i] = create_item_widget
	end

	self._list_widgets = tbl

	self:_align_item_widgets()
	self:_initialize_scrollbar()

	if #tbl > 0 then
		local last_selected_product = self._params.last_selected_product

		last_selected_product = last_selected_product or self._params.selected_product

		local flag_2 = not last_selected_product and last_selected_product.product_id
		local _get_list_index_by_product_id = self:_get_list_index_by_product_id(flag_2)

		_get_list_index_by_product_id = _get_list_index_by_product_id or 1

		self:_on_list_index_selected(_get_list_index_by_product_id)
		self:_scroll_to_list_index(_get_list_index_by_product_id)
	else
		self._params.selected_product = nil
	end
end

StoreWindowItemList._destroy_product_widgets = function (self, arg_26_1)
	-- function 26
	local _parent = self._parent
	local _layout = self._layout
	local _list_widgets = self._list_widgets

	if not _list_widgets and not _layout then
		for i, v in ipairs(_layout) do
			local var_26_3 = _list_widgets[i]

			_parent:destroy_product_widget(var_26_3, v, arg_26_1)
		end
	end
end

StoreWindowItemList._align_item_widgets = function (self)
	-- function 27
	local num_3 = 0
	local num_4 = 0
	local num_5 = 0
	local num_6 = 1
	local num_7 = 1
	local tbl = {}
	local _list_widgets = self._list_widgets
	local count = #_list_widgets

	for i, v in ipairs(_list_widgets) do
		local offset = v.offset
		local content = v.content
		local size = content.size
		local var_27_11 = size[1]
		local var_27_12 = size[2]

		if not (num_4 + var_27_11 > num_2) then
			num_7 = 1
			num_6 = num_6 + 1
			num_4 = 0
			num_5 = num_5 - (var_27_12 + num)
		end

		offset[1] = num_4
		offset[2] = num_5
		v.default_offset = table.clone(offset)
		content.row = num_6
		content.column = num_7
		num_4 = num_4 + (var_27_11 + num)

		if i == count then
			num_3 = math.abs(num_5 - var_27_12)
		end

		if not tbl[num_6] then
			tbl[num_6] = {}
		end

		tbl[num_6][num_7] = i
		num_7 = num_7 + 1
	end

	self._gamepad_navigation = tbl
	self._total_list_height = num_3
end

StoreWindowItemList._handle_gamepad_grid_selection = function (self, arg_28_1)
	-- function 28
	if not self._selected_gamepad_grid_index then
		return
	end

	local _gamepad_navigation = self._gamepad_navigation
	local count = #_gamepad_navigation
	local _selected_gamepad_grid_index = self._selected_gamepad_grid_index
	local _selected_gamepad_grid_row = self._selected_gamepad_grid_row
	local _selected_gamepad_grid_column = self._selected_gamepad_grid_column
	local var_28_5 = _gamepad_navigation[_selected_gamepad_grid_row]
	local count_2 = #var_28_5
	local var_28_7
	local var_28_8

	if not arg_28_1:get("move_left_hold_continuous") then
		if _selected_gamepad_grid_column > 1 then
			var_28_8 = var_28_5[_selected_gamepad_grid_column - 1]
		end
	elseif not arg_28_1:get("move_right_hold_continuous") then
		if _selected_gamepad_grid_column < count_2 then
			var_28_8 = var_28_5[_selected_gamepad_grid_column + 1]
		end
	elseif not arg_28_1:get("move_up_hold_continuous") then
		var_28_7 = math.max(_selected_gamepad_grid_row - 1, 1)
	elseif not arg_28_1:get("move_down_hold_continuous") then
		var_28_7 = math.min(_selected_gamepad_grid_row + 1, count)
	end

	if not (not var_28_7 and var_28_7 == _selected_gamepad_grid_row) then
		local var_28_9 = _gamepad_navigation[var_28_7]

		var_28_8 = self:_find_closest_neighbour(var_28_9, _selected_gamepad_grid_index, 1)
	end

	if not var_28_8 then
		local _get_scrollbar_percentage_by_index = self:_get_scrollbar_percentage_by_index(var_28_8)

		self:_on_list_index_selected(var_28_8, _get_scrollbar_percentage_by_index)
	end
end

StoreWindowItemList._find_closest_neighbour = function (self, arg_29_1, arg_29_2)
	-- function 29
	local _list_widgets = self._list_widgets
	local var_29_1 = _list_widgets[arg_29_2]
	local size = var_29_1.content.size
	local offset = var_29_1.offset
	local num = size[1] * 0.5 + offset[1]
	local huge = math.huge
	local var_29_6

	for k, v in pairs(arg_29_1) do
		local var_29_7 = _list_widgets[v]
		local offset_2 = var_29_7.offset
		local num_2 = var_29_7.content.size[1] * 0.5 + offset_2[1]
		local abs = math.abs(num_2 - num)

		if abs < huge then
			huge = abs
			var_29_6 = v
		end
	end

	if not var_29_6 then
		return var_29_6
	end
end

StoreWindowItemList._initialize_scrollbar = function (self)
	-- function 30
	local size = scenegraph_definition.list_window.size
	local size_2 = scenegraph_definition.list_scrollbar.size
	local var_30_2 = size[2]
	local _total_list_height = self._total_list_height
	local var_30_4 = size_2[2]
	local num_2 = 220 + num * 1.5
	local num_3 = 1
	local _scrollbar_logic = self._scrollbar_logic

	_scrollbar_logic:set_scrollbar_values(var_30_2, _total_list_height, var_30_4, num_2, num_3)

	local var_30_8 = _scrollbar_logic
	local set_scroll_percentage = _scrollbar_logic.set_scroll_percentage
	local _scroll_value = _scrollbar_logic._scroll_value

	_scroll_value = _scroll_value or 0

	set_scroll_percentage(var_30_8, _scroll_value)
end

StoreWindowItemList._update_scroll_position = function (self)
	-- function 31
	local get_scrolled_length = self._scrollbar_logic:get_scrolled_length()

	if get_scrolled_length ~= self._scrolled_length then
		self._ui_scenegraph.list.local_position[2] = get_scrolled_length
		self._scrolled_length = get_scrolled_length
	end
end

StoreWindowItemList._update_visible_list_entries = function (self)
	-- function 32
	local _scrollbar_logic = self._scrollbar_logic

	if not _scrollbar_logic:enabled() then
		return true
	end

	local get_scroll_percentage = _scrollbar_logic:get_scroll_percentage()
	local get_scrolled_length = _scrollbar_logic:get_scrolled_length()
	local get_scroll_length = _scrollbar_logic:get_scroll_length()
	local size = scenegraph_definition.list_window.size
	local num_2 = num * 2
	local num_3 = size[2] + num_2
	local _list_widgets = self._list_widgets
	local count = #_list_widgets

	for i, v in ipairs(_list_widgets) do
		local offset = v.offset
		local content = v.content
		local size_2 = content.size
		local num_4 = math.abs(offset[2]) + size_2[2]
		local flag = false

		if num_4 < get_scrolled_length - num_2 then
			flag = true
		elseif num_3 < math.abs(offset[2]) - get_scrolled_length then
			flag = true
		end

		content.visible = not flag
	end
end

StoreWindowItemList._scroll_to_list_index = function (self, arg_33_1)
	-- function 33
	local _scrollbar_logic = self._scrollbar_logic

	if not _scrollbar_logic:enabled() then
		local get_scroll_percentage = _scrollbar_logic:get_scroll_percentage()
		local get_scrolled_length = _scrollbar_logic:get_scrolled_length()
		local get_scroll_length = _scrollbar_logic:get_scroll_length()
		local var_33_4 = scenegraph_definition.list_window.size[2]
		local var_33_5 = get_scrolled_length
		local num = var_33_5 + var_33_4
		local _list_widgets = self._list_widgets

		if not _list_widgets then
			local var_33_8 = _list_widgets[arg_33_1]
			local content = var_33_8.content
			local offset = var_33_8.offset
			local var_33_11 = content.size[2]
			local abs = math.abs(offset[2])
			local num_2 = abs + var_33_11
			local var_33_14

			if num < num_2 then
				local num_3 = num_2 - num

				var_33_14 = math.clamp(num_3 / get_scroll_length, 0, 1)
			elseif abs < var_33_5 then
				local num_4 = var_33_5 - abs

				var_33_14 = -math.clamp(num_4 / get_scroll_length, 0, 1)
			end

			if not var_33_14 then
				local clamp = math.clamp(get_scroll_percentage + var_33_14, 0, 1)

				_scrollbar_logic:set_scroll_percentage(clamp)
			end
		end
	end
end

StoreWindowItemList._get_scrollbar_percentage_by_index = function (self, arg_34_1)
	-- function 34
	local _scrollbar_logic = self._scrollbar_logic

	if not _scrollbar_logic:enabled() then
		local get_scroll_percentage = _scrollbar_logic:get_scroll_percentage()
		local get_scrolled_length = _scrollbar_logic:get_scrolled_length()
		local get_scroll_length = _scrollbar_logic:get_scroll_length()
		local var_34_4 = scenegraph_definition.list_window.size[2]
		local var_34_5 = get_scrolled_length
		local num = var_34_5 + var_34_4
		local _list_widgets = self._list_widgets

		if not _list_widgets then
			local var_34_8 = _list_widgets[arg_34_1]
			local content = var_34_8.content
			local offset = var_34_8.offset
			local var_34_11 = content.size[2]
			local abs = math.abs(offset[2])
			local num_2 = abs + var_34_11
			local num_3 = 0

			if num < num_2 then
				local num_4 = num_2 - num

				num_3 = math.clamp(num_4 / get_scroll_length, 0, 1)
			elseif abs < var_34_5 then
				local num_5 = var_34_5 - abs

				num_3 = -math.clamp(num_5 / get_scroll_length, 0, 1)
			end

			if not num_3 then
				return (math.clamp(get_scroll_percentage + num_3, 0, 1))
			end
		end
	end

	return 0
end
