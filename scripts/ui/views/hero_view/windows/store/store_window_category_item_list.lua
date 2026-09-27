-- chunkname: @scripts/ui/views/hero_view/windows/store/store_window_category_item_list.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/store/definitions/store_window_category_item_list_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local num = 10
local num_2 = 800

StoreWindowCategoryItemList = class(StoreWindowCategoryItemList)
StoreWindowCategoryItemList.NAME = "StoreWindowCategoryItemList"

StoreWindowCategoryItemList.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate StoreWindowCategoryItemList")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local get_renderers, var_1_1 = self._parent:get_renderers()

	self._ui_renderer = get_renderers
	self._ui_top_renderer = var_1_1
	self._render_settings = {
		alpha_multiplier = 0,
		list_alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self._layout_settings = arg_1_1.layout_settings
	self._animations = {}
	self._ui_animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)
	self:_start_transition_animation("on_enter")
end

StoreWindowCategoryItemList._start_transition_animation = function (self, arg_2_1)
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

StoreWindowCategoryItemList._create_ui_elements = function (self, arg_3_1, arg_3_2)
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

StoreWindowCategoryItemList.on_exit = function (self, arg_4_1, arg_4_2)
	-- function 4
	print("[HeroViewWindow] Exit Substate StoreWindowCategoryItemList")

	self._ui_animator = nil

	self:_destroy_product_widgets(arg_4_2)
end

StoreWindowCategoryItemList.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	local flag = false

	if not self:_sync_products_version() then
		flag = self._selected_product ~= nil
	end

	if not self._create_widgets then
		self._create_widgets = self:_create_product_widgets(self._layout, false)
	end

	self:_sync_layout_path(flag)
	self:_update_animations(arg_5_1)
	self:_draw(arg_5_1)
end

StoreWindowCategoryItemList._sync_products_version = function (self)
	-- function 6
	local products_version_id = self._parent:products_version_id()

	if products_version_id ~= self._products_version_id then
		self._products_version_id = products_version_id

		return true
	end

	return false
end

StoreWindowCategoryItemList.post_update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not self._list_initialized then
		self:_handle_input(arg_7_1, arg_7_2)
		self:_handle_gamepad_activity()
		self:_update_gamepad_focus()
	end
end

StoreWindowCategoryItemList._update_animations = function (self, arg_8_1)
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

StoreWindowCategoryItemList._is_list_hovered = function (self)
	-- function 9
	local is_hover = self._widgets_by_name.list.content.list_hotspot.is_hover

	is_hover = is_hover or false

	return is_hover
end

StoreWindowCategoryItemList._handle_input = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _parent = self._parent
	local _widgets_by_name = self._widgets_by_name
	local window_input_service = self._parent:window_input_service()

	if not self._list_initialized then
		if not self:_is_list_hovered() then
			local _list_index_pressed = self:_list_index_pressed()

			if not _list_index_pressed then
				self:_play_sound("Play_hud_store_button_select")
				self:_on_list_index_pressed(_list_index_pressed)
			end
		end

		if not self._gamepad_active_last_frame then
			if not window_input_service:get("confirm_press") then
				local _selected_gamepad_grid_index = self._selected_gamepad_grid_index

				if not _selected_gamepad_grid_index then
					self:_play_sound("Play_hud_store_button_select")
					self:_on_list_index_pressed(_selected_gamepad_grid_index)
				end
			else
				self:_handle_gamepad_grid_selection(window_input_service)
			end
		end

		self._scrollbar_logic:update(arg_10_1, arg_10_2)
		self:_update_scroll_position()
	end
end

StoreWindowCategoryItemList._draw = function (self, arg_11_1)
	-- function 11
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings
	local alpha_multiplier = _render_settings.alpha_multiplier

	alpha_multiplier = alpha_multiplier or 0

	local list_alpha_multiplier = _render_settings.list_alpha_multiplier

	list_alpha_multiplier = list_alpha_multiplier or 0

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_11_1, nil, _render_settings)

	_render_settings.alpha_multiplier = alpha_multiplier

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	_render_settings.alpha_multiplier = math.min(alpha_multiplier, list_alpha_multiplier)

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

	_render_settings.alpha_multiplier = alpha_multiplier

	UIRenderer.end_pass(_ui_top_renderer)
end

StoreWindowCategoryItemList._play_sound = function (self, arg_12_1)
	-- function 12
	self._parent:play_sound(arg_12_1)
end

StoreWindowCategoryItemList._update_gamepad_focus = function (self)
	-- function 13
	local category_focused = self._params.category_focused

	if category_focused ~= self._category_focused then
		self._category_focused = category_focused

		if not category_focused then
			self:_on_list_index_selected(nil)
		elseif not self._gamepad_active_last_frame then
			local var_13_1 = self
			local _on_list_index_selected = self._on_list_index_selected
			local _previous_gamepad_grid_index = self._previous_gamepad_grid_index

			_previous_gamepad_grid_index = _previous_gamepad_grid_index or 1

			_on_list_index_selected(var_13_1, _previous_gamepad_grid_index)
		end
	end
end

StoreWindowCategoryItemList._handle_gamepad_activity = function (self)
	-- function 14
	local is_device_active = Managers.input:is_device_active("mouse")
	local flag = self._gamepad_active_last_frame == nil

	if not is_device_active then
		if not self._gamepad_active_last_frame and not flag then
			self._gamepad_active_last_frame = true
		end
	elseif self._gamepad_active_last_frame or not flag then
		self._gamepad_active_last_frame = false

		self:_on_list_index_selected(nil)
	end
end

StoreWindowCategoryItemList._list_index_pressed = function (self)
	-- function 15
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

StoreWindowCategoryItemList._animate_list_entries = function (self, arg_16_1)
	-- function 16
	local _parent = self._parent
	local _is_list_hovered = self:_is_list_hovered()
	local _list_widgets = self._list_widgets

	if not self._gamepad_active_last_frame then
		_is_list_hovered = true
	end

	for i, v in ipairs(_list_widgets) do
		local content = v.content
		local style = v.style
		local button_hotspot = content.button_hotspot

		button_hotspot = button_hotspot or content.hotspot

		if not button_hotspot.on_hover_enter then
			self:_play_sound("Play_hud_store_button_hover")

			button_hotspot.on_hover_enter = false
		end

		_parent:animate_store_product(v, arg_16_1, _is_list_hovered)
	end
end

StoreWindowCategoryItemList._get_items_by_filter = function (arg_17_0, arg_17_1)
	-- function 17
	return (Managers.backend:get_interface("peddler"):get_filtered_items(arg_17_1))
end

StoreWindowCategoryItemList._get_all_items = function (arg_18_0)
	-- function 18
	return (Managers.backend:get_interface("peddler"):get_peddler_stock())
end

StoreWindowCategoryItemList._update_item_list = function (self)
	-- function 19
	self:_destroy_product_widgets()

	local get_store_path = self._parent:get_store_path()
	local pages = StoreLayoutConfig.pages
	local str = "item"
	local tbl = {}
	local get_item_filter = StoreLayoutConfig.get_item_filter(get_store_path, callback(self._parent.get_temporary_page, self))
	local _get_items_by_filter = self:_get_items_by_filter(get_item_filter)
	local num = 0

	for k, v in pairs(_get_items_by_filter) do
		local data = v.data
		local flag = not data and data.bundle

		if not flag then
			for i, v_2 in ipairs(flag.BundledItems) do
				local var_19_9 = ItemMasterList[v_2]
				local tbl_2 = {
					item = var_19_9,
					type = var_19_9.item_type,
					product_item = v,
					product_id = data.key,
					sort_key = Localize(data.display_name),
					settings = {
						hide_price = true,
						hide_new = true,
						icon_size = data.icon_size
					},
					page_name = data.display_name,
					page = {
						sound_event_enter = "Play_hud_store_category_button",
						type = "collection_item",
						category_button_texture = "store_category_icon_pactsworn",
						hide_preview_details = true,
						exclusive_filter = true,
						layout = "item_list",
						sort_order = 5,
						display_name = data.display_name,
						item_filter = "item_type == " .. data.item_type .. " and item_key == " .. data.key
					}
				}

				tbl[#tbl + 1] = tbl_2
			end
		else
			tbl[num], num = {
				item = v,
				type = str,
				product_id = v.key,
				sort_key = StoreLayoutConfig.make_sort_key(v)
			}, num + 1
		end
	end

	table.sort(tbl, StoreLayoutConfig.compare_sort_key)

	self._layout = tbl
	self._create_widgets = self:_create_product_widgets(tbl, true)

	local var_19_11 = get_store_path[#get_store_path]
	local var_19_12 = pages[var_19_11]

	var_19_12 = var_19_12 or self._parent:get_temporary_page(var_19_11)

	local display_name = var_19_12.display_name

	self:_set_title_texts(Localize(display_name))

	self._previous_gamepad_grid_index = nil
	self._previous_gamepad_grid_row = nil
	self._previous_gamepad_grid_column = nil

	if not self._list_initialized then
		self:_start_transition_animation("on_item_list_initialized")
	else
		self:_start_transition_animation("on_item_list_updated")
	end

	self._list_initialized = true
end

StoreWindowCategoryItemList._set_title_texts = function (arg_20_0, arg_20_1)
	-- function 20
	arg_20_0._widgets_by_name.title_text.content.text = arg_20_1
end

StoreWindowCategoryItemList._get_list_index_by_product_id = function (self, arg_21_1)
	-- function 21
	local _layout = self._layout
	local num = 1

	for i, v in ipairs(_layout) do
		if v.product_id == arg_21_1 then
			return i
		end
	end
end

StoreWindowCategoryItemList._on_list_index_selected = function (self, arg_22_1, arg_22_2)
	-- function 22
	local var_22_0 = self._layout[arg_22_1]

	self._params.selected_product = var_22_0

	local var_22_1
	local var_22_2
	local _list_widgets = self._list_widgets

	if not _list_widgets then
		for i, v in ipairs(_list_widgets) do
			local content = v.content
			local hotspot = content.hotspot

			hotspot = hotspot or content.button_hotspot

			if not hotspot then
				local flag = i == arg_22_1

				hotspot.is_selected = flag

				if not flag then
					var_22_1 = content.row
					var_22_2 = content.column
					hotspot.on_hover_enter = true
				end
			end
		end
	end

	self._previous_gamepad_grid_index = self._selected_gamepad_grid_index
	self._previous_gamepad_grid_row = self._selected_gamepad_grid_row
	self._previous_gamepad_grid_column = self._selected_gamepad_grid_column
	self._selected_gamepad_grid_index = arg_22_1
	self._selected_gamepad_grid_row = var_22_1
	self._selected_gamepad_grid_column = var_22_2

	if not arg_22_2 then
		local scroll_bar_info = self._widgets_by_name.list_scrollbar.content.scroll_bar_info
		local function_by_time = UIAnimation.function_by_time
		local var_22_9 = scroll_bar_info
		local str = "scroll_value"
		local scroll_value = scroll_bar_info.scroll_value
		local var_22_12 = arg_22_2
		local num = 0.3
		local easeOutCubic = math.easeOutCubic

		self._ui_animations.scrollbar = UIAnimation.init(function_by_time, var_22_9, str, scroll_value, var_22_12, num, easeOutCubic)
	else
		self._ui_animations.scrollbar = nil
	end
end

StoreWindowCategoryItemList._on_list_index_pressed = function (self, arg_23_1)
	-- function 23
	local var_23_0 = self._layout[arg_23_1]
	local product_id = var_23_0.product_id
	local _parent = self._parent
	local flag = true
	local get_store_path = _parent:get_store_path()
	local clone = table.clone(get_store_path)

	if not var_23_0.page then
		local page_name = var_23_0.page_name

		clone[#clone + 1] = page_name

		_parent:go_to_store_path(clone, flag, var_23_0.page)
	else
		clone[#clone + 1] = "all_items"

		_parent:go_to_product(product_id, clone, nil, flag)
	end
end

StoreWindowCategoryItemList._create_product_widgets = function (self, arg_24_1, arg_24_2)
	-- function 24
	local _create_widget_index = self._create_widget_index
	local _list_widgets = self._list_widgets
	local num = 12

	if not arg_24_2 then
		_create_widget_index = 1
		_list_widgets = {}
		self._list_widgets = _list_widgets
	end

	local _parent = self._parent
	local str = "item_root"
	local flag = true

	for i = _create_widget_index, math.min(#arg_24_1, _create_widget_index + num) do
		_create_widget_index = _create_widget_index + 1

		local var_24_6 = arg_24_1[i]
		local create_item_widget = _parent:create_item_widget(var_24_6, str, flag)

		_parent:populate_product_widget(create_item_widget, var_24_6)

		_list_widgets[i] = create_item_widget
	end

	self._create_widget_index = _create_widget_index

	self:_align_item_widgets()
	self:_initialize_scrollbar()

	return _create_widget_index <= #arg_24_1
end

StoreWindowCategoryItemList._destroy_product_widgets = function (self, arg_25_1)
	-- function 25
	local _parent = self._parent
	local _layout = self._layout
	local _list_widgets = self._list_widgets

	if not _list_widgets and not _layout then
		for i, v in ipairs(_list_widgets) do
			local var_25_3 = _layout[i]

			_parent:destroy_product_widget(v, var_25_3, arg_25_1)
		end
	end
end

StoreWindowCategoryItemList._align_item_widgets = function (self)
	-- function 26
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
		local var_26_11 = size[1]
		local var_26_12 = size[2]

		if not (num_4 + var_26_11 > num_2) then
			num_7 = 1
			num_6 = num_6 + 1
			num_4 = 0
			num_5 = num_5 - (var_26_12 + num)
		end

		offset[1] = num_4
		offset[2] = num_5
		v.default_offset = table.clone(offset)
		content.row = num_6
		content.column = num_7
		num_4 = num_4 + (var_26_11 + num)

		if i == count then
			num_3 = math.abs(num_5 - var_26_12)
		end

		if not tbl[num_6] then
			tbl[num_6] = {}
		end

		tbl[num_6][num_7] = i
		num_7 = num_7 + 1
	end

	self._gamepad_navigation = tbl
	self._total_list_height = num_3

	self:_right_align_item_widgets()
end

StoreWindowCategoryItemList._right_align_item_widgets = function (self)
	-- function 27
	local _list_widgets = self._list_widgets
	local var_27_1
	local var_27_2

	for iter_27_0, iter_27_1 in ripairs(_list_widgets) do
		local offset = iter_27_1.offset
		local default_offset = iter_27_1.default_offset
		local content = iter_27_1.content
		local var_27_6 = content.size[1]
		local var_27_7 = offset[1]

		if not (num_2 - (var_27_7 + var_27_6) == 0) then
			break
		end

		if not var_27_2 then
			var_27_2 = var_27_2 - (var_27_6 + num)
		else
			var_27_2 = num_2 - var_27_6
		end

		offset[1] = var_27_2
		default_offset[1] = var_27_2

		local column = content.column

		if not (not var_27_1 and not (column < var_27_1)) then
			break
		end

		var_27_1 = column
	end
end

StoreWindowCategoryItemList._sync_layout_path = function (self, arg_28_1)
	-- function 28
	local get_store_path = self._parent:get_store_path()
	local structure = StoreLayoutConfig.structure
	local pages = StoreLayoutConfig.pages
	local _saved_path = self._saved_path

	_saved_path = _saved_path or {}

	local flag = false

	if #get_store_path ~= #_saved_path then
		flag = true
	else
		for i = 1, #get_store_path do
			if get_store_path[i] ~= _saved_path[i] then
				flag = true

				break
			end
		end
	end

	if flag or not arg_28_1 then
		self:_update_item_list()

		self._saved_path = table.clone(get_store_path)
	end
end

StoreWindowCategoryItemList._handle_gamepad_grid_selection = function (self, arg_29_1)
	-- function 29
	if not self._selected_gamepad_grid_index then
		return
	end

	local _gamepad_navigation = self._gamepad_navigation
	local count = #_gamepad_navigation
	local _selected_gamepad_grid_index = self._selected_gamepad_grid_index
	local _selected_gamepad_grid_row = self._selected_gamepad_grid_row
	local _selected_gamepad_grid_column = self._selected_gamepad_grid_column
	local var_29_5 = _gamepad_navigation[_selected_gamepad_grid_row]
	local count_2 = #var_29_5
	local var_29_7
	local var_29_8

	if not arg_29_1:get("move_left_hold_continuous") then
		if _selected_gamepad_grid_column == 1 then
			self._params.category_focused = true

			return
		elseif _selected_gamepad_grid_column > 1 then
			var_29_8 = var_29_5[_selected_gamepad_grid_column - 1]
		end
	elseif not arg_29_1:get("move_right_hold_continuous") then
		if _selected_gamepad_grid_column < count_2 then
			var_29_8 = var_29_5[_selected_gamepad_grid_column + 1]
		end
	elseif not arg_29_1:get("move_up_hold_continuous") then
		var_29_7 = math.max(_selected_gamepad_grid_row - 1, 1)
	elseif not arg_29_1:get("move_down_hold_continuous") then
		var_29_7 = math.min(_selected_gamepad_grid_row + 1, count)
	end

	if not (not var_29_7 and var_29_7 == _selected_gamepad_grid_row) then
		local var_29_9 = _gamepad_navigation[var_29_7]

		var_29_8 = self:_find_closest_neighbour(var_29_9, _selected_gamepad_grid_index, 1)
	end

	if not var_29_8 then
		local _get_scrollbar_percentage_by_index = self:_get_scrollbar_percentage_by_index(var_29_8)

		self:_on_list_index_selected(var_29_8, _get_scrollbar_percentage_by_index)
	end
end

StoreWindowCategoryItemList._find_closest_neighbour = function (self, arg_30_1, arg_30_2)
	-- function 30
	local _list_widgets = self._list_widgets
	local var_30_1 = _list_widgets[arg_30_2]
	local size = var_30_1.content.size
	local offset = var_30_1.offset
	local num = size[1] * 0.5 + offset[1]
	local huge = math.huge
	local var_30_6

	for k, v in pairs(arg_30_1) do
		local var_30_7 = _list_widgets[v]
		local offset_2 = var_30_7.offset
		local num_2 = var_30_7.content.size[1] * 0.5 + offset_2[1]
		local abs = math.abs(num_2 - num)

		if abs < huge then
			huge = abs
			var_30_6 = v
		end
	end

	if not var_30_6 then
		return var_30_6
	end
end

StoreWindowCategoryItemList._initialize_scrollbar = function (self)
	-- function 31
	local size = scenegraph_definition.list_window.size
	local size_2 = scenegraph_definition.list_scrollbar.size
	local var_31_2 = size[2]
	local _total_list_height = self._total_list_height
	local var_31_4 = size_2[2]
	local num = 200
	local num_2 = 1
	local _scrollbar_logic = self._scrollbar_logic

	_scrollbar_logic:set_scrollbar_values(var_31_2, _total_list_height, var_31_4, num, num_2)
	_scrollbar_logic:set_scroll_percentage(0)
end

StoreWindowCategoryItemList._update_scroll_position = function (self)
	-- function 32
	local get_scrolled_length = self._scrollbar_logic:get_scrolled_length()

	if get_scrolled_length ~= self._scrolled_length then
		self._ui_scenegraph.list.local_position[2] = get_scrolled_length
		self._scrolled_length = get_scrolled_length
	end
end

StoreWindowCategoryItemList._update_visible_list_entries = function (self)
	-- function 33
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

		local button_hotspot = content.button_hotspot

		button_hotspot = button_hotspot or content.hotspot

		if not flag then
			table.clear(button_hotspot)
		end
	end
end

StoreWindowCategoryItemList._scroll_to_list_index = function (self, arg_34_1)
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
			local var_34_14

			if num < num_2 then
				local num_3 = num_2 - num

				var_34_14 = math.clamp(num_3 / get_scroll_length, 0, 1)
			elseif abs < var_34_5 then
				local num_4 = var_34_5 - abs

				var_34_14 = -math.clamp(num_4 / get_scroll_length, 0, 1)
			end

			if not var_34_14 then
				local clamp = math.clamp(get_scroll_percentage + var_34_14, 0, 1)

				_scrollbar_logic:set_scroll_percentage(clamp)
			end
		end
	end
end

StoreWindowCategoryItemList._get_scrollbar_percentage_by_index = function (self, arg_35_1)
	-- function 35
	local _scrollbar_logic = self._scrollbar_logic

	if not _scrollbar_logic:enabled() then
		local get_scroll_percentage = _scrollbar_logic:get_scroll_percentage()
		local get_scrolled_length = _scrollbar_logic:get_scrolled_length()
		local get_scroll_length = _scrollbar_logic:get_scroll_length()
		local var_35_4 = scenegraph_definition.list_window.size[2]
		local var_35_5 = get_scrolled_length
		local num = var_35_5 + var_35_4
		local _list_widgets = self._list_widgets

		if not _list_widgets then
			local var_35_8 = _list_widgets[arg_35_1]
			local content = var_35_8.content
			local offset = var_35_8.offset
			local var_35_11 = content.size[2]
			local abs = math.abs(offset[2])
			local num_2 = abs + var_35_11
			local num_3 = 0

			if num < num_2 then
				local num_4 = num_2 - num

				num_3 = math.clamp(num_4 / get_scroll_length, 0, 1)
			elseif abs < var_35_5 then
				local num_5 = var_35_5 - abs

				num_3 = -math.clamp(num_5 / get_scroll_length, 0, 1)
			end

			if not num_3 then
				return (math.clamp(get_scroll_percentage + num_3, 0, 1))
			end
		end
	end

	return 0
end
