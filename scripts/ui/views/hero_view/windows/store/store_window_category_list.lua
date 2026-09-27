-- chunkname: @scripts/ui/views/hero_view/windows/store/store_window_category_list.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/store/definitions/store_window_category_list_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

local function fn(self, arg_1_1)
	-- function 1
	local sort_order = self.sort_order

	sort_order = sort_order or math.huge

	local sort_order_2 = arg_1_1.sort_order

	sort_order_2 = sort_order_2 or math.huge

	return sort_order < sort_order_2
end

local num = 10
local num_2 = 800

StoreWindowCategoryList = class(StoreWindowCategoryList)
StoreWindowCategoryList.NAME = "StoreWindowCategoryList"

StoreWindowCategoryList.on_enter = function (self, arg_2_1, arg_2_2)
	-- function 2
	print("[HeroViewWindow] Enter Substate StoreWindowCategoryList")

	self._params = arg_2_1
	self._parent = arg_2_1.parent
	self._params.last_selected_product = nil

	local get_renderers, var_2_1 = self._parent:get_renderers()

	self._ui_renderer = get_renderers
	self._ui_top_renderer = var_2_1
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._layout_settings = arg_2_1.layout_settings
	self._animations = {}
	self._ui_animations = {}

	self:_create_ui_elements(arg_2_1, arg_2_2)
	self:_start_transition_animation("on_enter")
	self._parent:set_list_details_visibility(true)
	self._parent:set_list_details_length(680, 0.3)
	self._parent:change_generic_actions("default")
end

StoreWindowCategoryList._start_transition_animation = function (self, arg_3_1)
	-- function 3
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {
		widgets_by_name = self._widgets_by_name,
		list_widgets = self._list_widgets
	}
	local start_animation = self._ui_animator:start_animation(arg_3_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_3_1] = start_animation
end

StoreWindowCategoryList._create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_4_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_4_2
		tbl_2[k] = var_4_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	local list_scrollbar = self._widgets_by_name.list_scrollbar

	self._scrollbar_logic = ScrollBarLogic:new(list_scrollbar)

	self:_setup_list_elements()
end

StoreWindowCategoryList.on_exit = function (self, arg_5_1, arg_5_2)
	-- function 5
	print("[HeroViewWindow] Exit Substate StoreWindowCategoryList")

	self._ui_animator = nil

	self:_destroy_product_widgets(arg_5_2)
end

StoreWindowCategoryList.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_update_animations(arg_6_1)
	self:_draw(arg_6_1)
end

StoreWindowCategoryList.post_update = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not self._list_initialized then
		self:_handle_input(arg_7_1, arg_7_2)
		self:_handle_gamepad_activity()
		self:_update_gamepad_focus()
	end
end

StoreWindowCategoryList._update_animations = function (self, arg_8_1)
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

StoreWindowCategoryList._is_list_hovered = function (self)
	-- function 9
	local is_hover = self._widgets_by_name.list.content.list_hotspot.is_hover

	is_hover = is_hover or false

	return is_hover
end

StoreWindowCategoryList._handle_input = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _parent = self._parent
	local _widgets_by_name = self._widgets_by_name
	local window_input_service = self._parent:window_input_service()

	if not self._list_initialized then
		if not self:_is_list_hovered() then
			local _list_index_pressed = self:_list_index_pressed()

			if not _list_index_pressed then
				self:_on_list_index_pressed(_list_index_pressed)
			end
		end

		if not self._gamepad_active_last_frame then
			if not window_input_service:get("confirm_press") then
				if not self._selected_gamepad_grid_index then
					self:_on_list_index_pressed(self._selected_gamepad_grid_index)
				end
			else
				self:_handle_gamepad_grid_selection(window_input_service)
			end
		end

		self._scrollbar_logic:update(arg_10_1, arg_10_2)
		self:_update_scroll_position()
	end
end

StoreWindowCategoryList._draw = function (self, arg_11_1)
	-- function 11
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_11_1, nil, self._render_settings)

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

StoreWindowCategoryList._play_sound = function (self, arg_12_1)
	-- function 12
	self._parent:play_sound(arg_12_1)
end

StoreWindowCategoryList._update_gamepad_focus = function (self)
	-- function 13
	local category_focused = self._params.category_focused

	if category_focused ~= self._category_focused then
		self._category_focused = category_focused

		if not category_focused then
			if not self._gamepad_active_last_frame then
				self:_on_list_index_selected(1)
			end
		else
			self:_on_list_index_selected(nil)
		end
	end
end

StoreWindowCategoryList._handle_gamepad_activity = function (self)
	-- function 14
	local is_device_active = Managers.input:is_device_active("mouse")
	local flag = self._gamepad_active_last_frame == nil

	if not is_device_active then
		if not self._gamepad_active_last_frame and not flag then
			self._gamepad_active_last_frame = true
			self._params.category_focused = true
		end
	elseif self._gamepad_active_last_frame or not flag then
		self._gamepad_active_last_frame = false
		self._params.category_focused = nil
	end
end

StoreWindowCategoryList._get_items_by_filter = function (arg_15_0, arg_15_1)
	-- function 15
	return (Managers.backend:get_interface("peddler"):get_filtered_items(arg_15_1))
end

StoreWindowCategoryList._get_all_items = function (arg_16_0)
	-- function 16
	return (Managers.backend:get_interface("peddler"):get_peddler_stock())
end

StoreWindowCategoryList._get_items_by_path = function (self, arg_17_1)
	-- function 17
	local str = ""
	local num = 0
	local pages = StoreLayoutConfig.pages

	for i, v in ipairs(arg_17_1) do
		local var_17_3 = pages[v]

		if not var_17_3.item_filter then
			if num > 0 then
				str = str .. " and "
			end

			str = str .. var_17_3.item_filter
			num = num + 1
		end
	end

	local var_17_4

	if num > 0 then
		var_17_4 = self:_get_items_by_filter(str)
	else
		var_17_4 = self:_get_all_items()
	end

	return var_17_4
end

StoreWindowCategoryList._populate_list = function (self, arg_18_1)
	-- function 18
	local tbl = {}
	local str = "item_root"
	local flag = true
	local tbl_2 = {
		550,
		80
	}
	local get_interface = Managers.backend:get_interface("items")
	local item_rarity_textures = UISettings.item_rarity_textures
	local get_store_path = self._parent:get_store_path()

	for i, v in ipairs(arg_18_1) do
		local type = v.type
		local var_18_8

		if type == "collection_item" then
			local create_store_collection_entry_definition = UIWidgets.create_store_collection_entry_definition(str, tbl_2, flag)

			var_18_8 = UIWidget.init(create_store_collection_entry_definition)
		else
			local create_store_category_entry_definition = UIWidgets.create_store_category_entry_definition(str, tbl_2, flag)

			var_18_8 = UIWidget.init(create_store_category_entry_definition)
		end

		tbl[i] = var_18_8

		local content = var_18_8.content
		local style = var_18_8.style
		local display_name = v.display_name

		content.title = Localize(display_name)

		if type == "collection_item" then
			self._parent:populate_product_widget(var_18_8, v)
		else
			local category_texture = v.category_texture

			content.category_texture = category_texture

			if not category_texture then
				local size = UIAtlasHelper.get_atlas_settings_by_texture_name(category_texture).size
				local texture_size = style.category_texture.texture_size

				texture_size[1] = size[1]
				texture_size[2] = size[2]
			end
		end

		local clone = table.clone(get_store_path)
		local count = #clone
		local page_name = v.page_name

		clone[count + 1] = page_name
	end

	self._list_widgets = tbl

	self:_align_entry_widgets()
	self:_initialize_scrollbar()
end

StoreWindowCategoryList._destroy_product_widgets = function (self, arg_19_1)
	-- function 19
	local _parent = self._parent
	local _layout = self._layout
	local _list_widgets = self._list_widgets

	if not _list_widgets and not _layout then
		for i, v in ipairs(_layout) do
			if v.type == "collection_item" then
				local var_19_3 = _list_widgets[i]

				_parent:destroy_product_widget(var_19_3, v, arg_19_1)
			end
		end
	end
end

StoreWindowCategoryList._align_entry_widgets = function (self)
	-- function 20
	local num_3 = 0
	local num_4 = 0
	local var_20_2 = num
	local num_5 = 1
	local num_6 = 1
	local tbl = {}
	local _list_widgets = self._list_widgets
	local count = #_list_widgets

	for i, v in ipairs(_list_widgets) do
		local offset = v.offset
		local content = v.content
		local size = content.size
		local var_20_11 = size[1]
		local var_20_12 = size[2]
		local flag = num_4 + var_20_11 > num_2

		if i == 1 then
			var_20_2 = -var_20_12
		end

		if not flag then
			num_6 = 1
			num_5 = num_5 + 1
			num_4 = 0
			var_20_2 = var_20_2 - (var_20_12 + num)
		end

		offset[1] = num_4
		offset[2] = var_20_2
		v.default_offset = table.clone(offset)
		content.row = num_5
		content.column = num_6
		num_4 = num_4 + (var_20_11 + num)

		if i == count then
			num_3 = math.abs(var_20_2)
		end

		if not tbl[num_5] then
			tbl[num_5] = {}
		end

		tbl[num_5][num_6] = i
		num_6 = num_6 + 1
	end

	self._gamepad_navigation = tbl
	self._total_list_height = num_3
end

StoreWindowCategoryList._list_index_pressed = function (self)
	-- function 21
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

StoreWindowCategoryList._animate_list_entries = function (self, arg_22_1)
	-- function 22
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

		self:_animate_list_entry(content, style, arg_22_1, _is_list_hovered)
	end
end

StoreWindowCategoryList._animate_list_entry = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	-- function 23
	local button_hotspot = arg_23_1.button_hotspot

	button_hotspot = button_hotspot or arg_23_1.hotspot

	local flag = not arg_23_4 and button_hotspot.on_hover_enter
	local flag_2 = not arg_23_4 and button_hotspot.is_hover
	local is_selected = button_hotspot.is_selected
	local is_clicked

	if not is_selected then
		is_clicked = button_hotspot.is_clicked

		if not is_clicked then
			-- Nothing
		end

		if button_hotspot.is_clicked ~= 0 then
			-- Nothing
		end
	end

	is_clicked = false

	goto label_23_1

	::label_23_0::

	is_clicked = true

	::label_23_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local pulse_progress = button_hotspot.pulse_progress

	pulse_progress = pulse_progress or 1

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local flag_3

	flag_3 = flag_2 or not is_selected or 14 or 3

	local num = 3
	local num_2 = 20

	if not is_clicked then
		input_progress = math.min(input_progress + arg_23_3 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_23_3 * num_2, 0)
	end

	local easeOutCubic = math.easeOutCubic(input_progress)
	local easeInCubic = math.easeInCubic(input_progress)

	if not flag then
		pulse_progress = 0
	end

	local min = math.min(pulse_progress + arg_23_3 * num, 1)
	local easeOutCubic_2 = math.easeOutCubic(min)
	local easeInCubic_2 = math.easeInCubic(min)

	if not flag_2 then
		hover_progress = math.min(hover_progress + arg_23_3 * flag_3, 1)
	else
		hover_progress = math.max(hover_progress - arg_23_3 * flag_3, 0)
	end

	local easeOutCubic_3 = math.easeOutCubic(hover_progress)
	local easeInCubic_3 = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_23_3 * flag_3, 1)
	else
		selection_progress = math.max(selection_progress - arg_23_3 * flag_3, 0)
	end

	local easeOutCubic_4 = math.easeOutCubic(selection_progress)
	local easeInCubic_4 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_4, easeOutCubic_3)
	local max_3 = math.max(easeInCubic_3, easeInCubic_4)
	local num_3 = 255 * max

	arg_23_2.hover_frame.color[1] = num_3

	local num_4 = 100 + 155 * max

	arg_23_2.category_texture.color[1] = num_4

	local num_5 = 255 - 255 * min

	arg_23_2.pulse_frame.color[1] = num_5

	local title = arg_23_2.title
	local text_color = title.text_color
	local default_text_color = title.default_text_color
	local select_text_color = title.select_text_color

	Colors.lerp_color_tables(default_text_color, select_text_color, max, text_color)

	button_hotspot.pulse_progress = min
	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end

StoreWindowCategoryList._setup_list_elements = function (self)
	-- function 24
	self:_destroy_product_widgets()

	local get_store_path = self._parent:get_store_path()
	local structure = StoreLayoutConfig.structure

	for k, v in pairs(get_store_path) do
		structure = structure[v]
	end

	local tbl = {}
	local pages = StoreLayoutConfig.pages
	local var_24_4 = pages[get_store_path[#get_store_path]]

	if var_24_4.type == "collection_item" then
		local item_filter = var_24_4.item_filter
		local var_24_6

		if not item_filter then
			var_24_6 = self:_get_items_by_filter(item_filter)
		else
			var_24_6 = self:_get_all_items()
		end

		for i, v_2 in ipairs(var_24_6) do
			local data = v_2.data
			local tbl_2 = {
				type = "collection_item",
				display_name = data.display_name,
				page_name = data.display_name,
				page = {
					sound_event_enter = "Play_hud_store_category_button",
					layout = "item_list",
					type = "collection_item",
					category_button_texture = "store_category_icon_pactsworn",
					hide_preview_details = true,
					exclusive_filter = true,
					display_name = data.display_name,
					item_filter = item_filter .. " and item_key == " .. data.key
				},
				product_id = data.key,
				item = v_2,
				sort_order = Localize(data.display_name)
			}

			tbl[#tbl + 1] = tbl_2
		end
	else
		for k_2, v_3 in pairs(structure) do
			local var_24_9 = pages[k_2]

			if not self:_valid_category(var_24_9.item_filter) then
				local tbl_3 = {
					display_name = var_24_9.display_name,
					page_name = k_2,
					sort_order = var_24_9.sort_order,
					category_texture = var_24_9.category_button_texture
				}

				tbl[#tbl + 1] = tbl_3
			end
		end
	end

	table.sort(tbl, fn)
	self:_populate_list(tbl)

	self._layout = tbl
	self._list_initialized = true
end

StoreWindowCategoryList._valid_category = function (self, arg_25_1)
	-- function 25
	return #self:_get_items_by_filter(arg_25_1) ~= 0
end

StoreWindowCategoryList._on_list_index_pressed = function (self, arg_26_1)
	-- function 26
	local var_26_0 = self._layout[arg_26_1]
	local page_name = var_26_0.page_name
	local _parent = self._parent
	local get_store_path = _parent:get_store_path()
	local clone = table.clone(get_store_path)

	clone[#clone + 1] = page_name

	_parent:go_to_store_path(clone, nil, var_26_0.page)
end

StoreWindowCategoryList._on_list_index_selected = function (self, arg_27_1, arg_27_2)
	-- function 27
	local var_27_0 = self._layout[arg_27_1]

	self._params.selected_product = var_27_0

	local var_27_1
	local var_27_2
	local _list_widgets = self._list_widgets

	if not _list_widgets then
		for i, v in ipairs(_list_widgets) do
			local content = v.content
			local hotspot = content.hotspot

			hotspot = hotspot or content.button_hotspot

			if not hotspot then
				local flag = i == arg_27_1

				hotspot.is_selected = flag

				if not flag then
					var_27_1 = content.row
					var_27_2 = content.column
					hotspot.on_hover_enter = true
				end
			end
		end
	end

	self._previous_gamepad_grid_index = self._selected_gamepad_grid_index
	self._previous_gamepad_grid_row = self._selected_gamepad_grid_row
	self._previous_gamepad_grid_column = self._selected_gamepad_grid_column
	self._selected_gamepad_grid_index = arg_27_1
	self._selected_gamepad_grid_row = var_27_1
	self._selected_gamepad_grid_column = var_27_2

	if not arg_27_2 then
		local scroll_bar_info = self._widgets_by_name.list_scrollbar.content.scroll_bar_info
		local function_by_time = UIAnimation.function_by_time
		local var_27_9 = scroll_bar_info
		local str = "scroll_value"
		local scroll_value = scroll_bar_info.scroll_value
		local var_27_12 = arg_27_2
		local num = 0.3
		local easeOutCubic = math.easeOutCubic

		self._ui_animations.scrollbar = UIAnimation.init(function_by_time, var_27_9, str, scroll_value, var_27_12, num, easeOutCubic)
	else
		self._ui_animations.scrollbar = nil
	end
end

StoreWindowCategoryList._handle_gamepad_grid_selection = function (self, arg_28_1)
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
		self._params.category_focused = false
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

StoreWindowCategoryList._find_closest_neighbour = function (self, arg_29_1, arg_29_2)
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

StoreWindowCategoryList._initialize_scrollbar = function (self)
	-- function 30
	local size = scenegraph_definition.list_window.size
	local size_2 = scenegraph_definition.list_scrollbar.size
	local var_30_2 = size[2]
	local _total_list_height = self._total_list_height
	local var_30_4 = size_2[2]
	local num = 80
	local num_2 = 1
	local _scrollbar_logic = self._scrollbar_logic

	_scrollbar_logic:set_scrollbar_values(var_30_2, _total_list_height, var_30_4, num, num_2)
	_scrollbar_logic:set_scroll_percentage(0)
end

StoreWindowCategoryList._update_scroll_position = function (self)
	-- function 31
	local get_scrolled_length = self._scrollbar_logic:get_scrolled_length()

	if get_scrolled_length ~= self._scrolled_length then
		self._ui_scenegraph.list.local_position[2] = get_scrolled_length
		self._scrolled_length = get_scrolled_length
	end
end

StoreWindowCategoryList._update_visible_list_entries = function (self)
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
		local abs = math.abs(offset[2])
		local flag = false

		if abs < get_scrolled_length - num_2 then
			flag = true
		elseif num_3 < math.abs(offset[2] + size_2[2]) - get_scrolled_length then
			flag = true
		end

		content.visible = not flag
	end
end

StoreWindowCategoryList._scroll_to_list_index = function (self, arg_33_1)
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

StoreWindowCategoryList._get_scrollbar_percentage_by_index = function (self, arg_34_1)
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
			local abs = math.abs(offset[2] + var_34_11)
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
