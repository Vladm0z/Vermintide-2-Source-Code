-- chunkname: @scripts/ui/views/hero_view/windows/store/store_window_panel.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/store/definitions/store_window_panel_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local str = "cycle_next"
local str_2 = "cycle_previous"

StoreWindowPanel = class(StoreWindowPanel)
StoreWindowPanel.NAME = "StoreWindowPanel"

StoreWindowPanel.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate StoreWindowPanel")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local get_renderers, var_1_1 = self._parent:get_renderers()

	self._ui_renderer = get_renderers
	self._ui_top_renderer = var_1_1
	self._layout_settings = arg_1_1.layout_settings
	self._animations = {}
	self._ui_animations = {}
	self._currency_types = DLCSettings.store.currency_types
	self._currency_ui_settings = DLCSettings.store.currency_ui_settings
	self._currencies = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)
	self:_setup_input_buttons()
end

StoreWindowPanel._create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	local _currency_types = self._currency_types
	local _currency_ui_settings = self._currency_ui_settings
	local tbl = {}

	for i = 1, #_currency_types do
		local var_2_3 = _currency_types[i]
		local str = "currency_node_" .. var_2_3
		local tbl_2 = {}

		tbl_2.parent = "panel"
		tbl_2.size = {
			200,
			70
		}
		tbl_2.position = {
			-92 - 200 * (i - 1),
			0,
			20
		}
		tbl_2.horizontal_alignment = "right"
		tbl_2.vertical_alignment = "bottom"
		scenegraph_definition[str] = tbl_2

		local var_2_6 = _currency_ui_settings[var_2_3]
		local background_ui_settings = var_2_6.background_ui_settings

		tbl["currency_panel_widget_" .. var_2_3] = UIWidgets.create_store_panel_currency_widget(str, var_2_6.frame, var_2_6.icon_big, background_ui_settings.texture, background_ui_settings.size)
		tbl["currency_text_tooltip_" .. var_2_3] = UIWidgets.create_additional_option_tooltip(str, {
			200,
			70
		}, {
			"weave_progression_slot_titles"
		}, {
			title = Localize(var_2_6.tooltip_title),
			description = Localize(var_2_6.tooltip_description),
			input = Localize(var_2_6.tooltip_input)
		}, 400, "right", "bottom", true, {
			0,
			-22,
			0
		})
	end

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widgets)
	self._top_widgets, self._top_widgets_by_name = UIUtils.create_widgets(tbl)

	local tbl_3 = {}
	local window_layouts = self._layout_settings.window_layouts
	local pages = StoreLayoutConfig.pages
	local menu_options = StoreLayoutConfig.menu_options
	local str_2 = "game_option"
	local size = scenegraph_definition[str_2].size
	local num = 28
	local str_3 = "center"
	local tbl_4 = {
		upper_case = true,
		localize = true,
		dynamic_font_size = true,
		word_wrap = false,
		font_type = "hell_shark_header",
		font_size = num
	}
	local tab_cat = self._parent.tab_cat

	ItemHelper.create_tab_unseen_item_stars(tab_cat)

	local num_2 = 0

	for i_2, v in ipairs(menu_options) do
		local display_name = pages[v].display_name

		display_name = display_name or "n/a"

		local _get_text_width = self:_get_text_width(tbl_4, display_name)
		local tbl_5 = {
			math.min(_get_text_width + 40, 400),
			size[2]
		}
		local tbl_6 = {
			num_2,
			0,
			0
		}
		local create_store_panel_button = UIWidgets.create_store_panel_button(str_2, tbl_5, display_name, num, tbl_6, str_3)

		num_2 = num_2 + tbl_5[1]

		local var_2_24 = UIWidget.init(create_store_panel_button)

		self:_set_text_button_size(var_2_24, tbl_5[1])

		local content = var_2_24.content

		content.page_name = v

		if tab_cat[v] > 0 then
			content.new = true
		end

		tbl_3[#tbl_3 + 1] = var_2_24
	end

	self.tab_cat = tab_cat
	self._ui_scenegraph.panel_entry_area.size[1] = num_2
	self._title_button_widgets = tbl_3

	local mark_all_seen_button = self._widgets_by_name.mark_all_seen_button

	mark_all_seen_button.content.new = true
	mark_all_seen_button.style.new_marker.offset = {
		-80,
		8,
		10
	}

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_2_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end
end

StoreWindowPanel.on_exit = function (self, arg_3_1)
	-- function 3
	print("[HeroViewWindow] Exit Substate StoreWindowPanel")

	self._ui_animator = nil
end

StoreWindowPanel.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_handle_gamepad_activity()
	self:_handle_back_button_visibility()
	self:_sync_player_wallet()
	self:_sync_wallet_matchmaking_location()
	self:_update_selected_option()
	self:_update_animations(arg_4_1)
	self:_draw(arg_4_1)
end

StoreWindowPanel.post_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_handle_input(arg_5_1, arg_5_2)
end

StoreWindowPanel._update_animations = function (self, arg_6_1)
	-- function 6
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_6_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_6_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	local tab_cat = self._parent.tab_cat
	local _title_button_widgets = self._title_button_widgets
	local num = 0

	for i, v_3 in ipairs(_title_button_widgets) do
		self:_animate_title_entry(v_3, arg_6_1)

		local content = v_3.content
		local page_name = content.page_name
		local rotation_timestamp = StoreLayoutConfig.pages[page_name].rotation_timestamp

		content.timer = not rotation_timestamp and rotation_timestamp > os.time()

		local var_6_9 = tab_cat[page_name]

		content.new = var_6_9 > 0
		num = num + var_6_9
	end

	local is_device_active = Managers.input:is_device_active("gamepad")
	local mark_all_seen_button = self._widgets_by_name.mark_all_seen_button
	local flag = num > 0

	mark_all_seen_button.content.visible = not not is_device_active or flag
	mark_all_seen_button.content.enabled = not not is_device_active or flag

	local _widgets_by_name = self._widgets_by_name
	local back_button = _widgets_by_name.back_button
	local close_button = _widgets_by_name.close_button

	self:_animate_back_button(back_button, arg_6_1)
	self:_animate_back_button(close_button, arg_6_1)
	self:_update_panel_selection_animation(arg_6_1)
end

StoreWindowPanel._is_stepper_button_pressed = function (arg_7_0, arg_7_1)
	-- function 7
	local content = arg_7_1.content
	local button_hotspot_left = content.button_hotspot_left
	local button_hotspot_right = content.button_hotspot_right

	if not button_hotspot_left.on_release then
		button_hotspot_left.on_release = false

		return true, -1
	elseif not button_hotspot_right.on_release then
		button_hotspot_right.on_release = false

		return true, 1
	end
end

StoreWindowPanel._handle_input = function (self, arg_8_1, arg_8_2)
	-- function 8
	local _parent = self._parent
	local _widgets_by_name = self._widgets_by_name
	local window_input_service = self._parent:window_input_service()
	local flag = false
	local close_button = _widgets_by_name.close_button
	local back_button = _widgets_by_name.back_button
	local mark_all_seen_button = _widgets_by_name.mark_all_seen_button

	if UIUtils.is_button_hover_enter(back_button) or not UIUtils.is_button_hover_enter(close_button) then
		self:_play_sound("Play_hud_hover")
	end

	if flag or not UIUtils.is_button_pressed(close_button) then
		_parent:close_menu()

		flag = true
	end

	if flag or not UIUtils.is_button_pressed(mark_all_seen_button) then
		mark_all_seen_button.content.new = false

		ItemHelper.set_all_shop_item_seen(self._parent.tab_cat)

		flag = true
	end

	local count = #_parent:get_store_path()
	local _title_button_widgets = self._title_button_widgets
	local count_2 = #_title_button_widgets

	for i, v in ipairs(_title_button_widgets) do
		if not (not v.content.button_hotspot.is_selected and not (count > 1)) then
			if not UIUtils.is_button_hover_enter(v) then
				self:_play_sound("Play_hud_store_button_hover_category")
			end

			if not UIUtils.is_button_pressed(v) then
				self:_on_panel_button_selected(i)

				flag = true
			end
		end
	end

	if not flag then
		local _selected_index = self._selected_index

		_selected_index = _selected_index or 1

		local count_3 = #_title_button_widgets

		if not window_input_service:get(str_2) then
			local num

			if _selected_index > 1 then
				num = _selected_index - 1

				if not num then
					-- Nothing
				end
			end

			num = count_3

			::label_8_0::

			self:_on_panel_button_selected(num)
		elseif not window_input_service:get(str) then
			local num_2 = _selected_index % count_3 + 1

			self:_on_panel_button_selected(num_2)
		end
	end
end

StoreWindowPanel._on_panel_button_selected = function (self, arg_9_1)
	-- function 9
	local _parent = self._parent
	local page_name = self._title_button_widgets[arg_9_1].content.page_name
	local tbl = {
		page_name
	}

	_parent:go_to_store_path(tbl)
end

StoreWindowPanel._set_selected_option = function (self, arg_10_1)
	-- function 10
	self:_start_panel_selection_animation(self._selected_index, arg_10_1)

	local _title_button_widgets = self._title_button_widgets

	for i, v in ipairs(_title_button_widgets) do
		v.content.button_hotspot.is_selected = i == arg_10_1
	end
end

StoreWindowPanel._update_selected_option = function (self)
	-- function 11
	local get_store_path = self._parent:get_store_path()

	if not get_store_path then
		local var_11_1 = get_store_path[1]
		local _title_button_widgets = self._title_button_widgets

		for i, v in ipairs(_title_button_widgets) do
			if not (v.content.page_name ~= var_11_1 or i == self._selected_index) then
				self:_set_selected_option(i)

				self._selected_index = i
			end
		end
	end
end

StoreWindowPanel._draw = function (self, arg_12_1)
	-- function 12
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, window_input_service, arg_12_1, nil, _render_settings)
	UIRenderer.draw_all_widgets(_ui_renderer, self._widgets)
	UIRenderer.draw_all_widgets(_ui_renderer, self._title_button_widgets)
	UIRenderer.end_pass(_ui_renderer)
	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_12_1, nil, _render_settings)
	UIRenderer.draw_all_widgets(_ui_top_renderer, self._top_widgets)
	UIRenderer.end_pass(_ui_top_renderer)
end

StoreWindowPanel._play_sound = function (self, arg_13_1)
	-- function 13
	return self._parent:play_sound(arg_13_1)
end

StoreWindowPanel._setup_input_buttons = function (self)
	-- function 14
	local flag = true
	local window_input_service = self._parent:window_input_service(flag)
	local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(window_input_service, str_2, true)
	local get_gamepad_input_texture_data_2 = UISettings.get_gamepad_input_texture_data(window_input_service, str, true)
	local _widgets_by_name = self._widgets_by_name
	local panel_input_area_1 = _widgets_by_name.panel_input_area_1
	local panel_input_area_2 = _widgets_by_name.panel_input_area_2
	local texture_id = panel_input_area_1.style.texture_id

	texture_id.horizontal_alignment = "center"
	texture_id.vertical_alignment = "center"
	texture_id.texture_size = {
		get_gamepad_input_texture_data.size[1],
		get_gamepad_input_texture_data.size[2]
	}
	panel_input_area_1.content.texture_id = get_gamepad_input_texture_data.texture

	local texture_id_2 = panel_input_area_2.style.texture_id

	texture_id_2.horizontal_alignment = "center"
	texture_id_2.vertical_alignment = "center"
	texture_id_2.texture_size = {
		get_gamepad_input_texture_data_2.size[1],
		get_gamepad_input_texture_data_2.size[2]
	}
	panel_input_area_2.content.texture_id = get_gamepad_input_texture_data_2.texture
end

StoreWindowPanel._handle_back_button_visibility = function (self)
	-- function 15
	if not self.gamepad_active_last_frame then
		local close_on_exit = self._parent:close_on_exit()
		local back_button = self._widgets_by_name.back_button
		local flag = not close_on_exit

		back_button.content.visible = flag
	end
end

StoreWindowPanel._reset_back_button = function (self)
	-- function 16
	local button_hotspot = self._widgets_by_name.back_button.content.button_hotspot

	table.clear(button_hotspot)
end

StoreWindowPanel._handle_gamepad_activity = function (self)
	-- function 17
	local is_device_active = Managers.input:is_device_active("gamepad")
	local get_most_recent_device = Managers.input:get_most_recent_device()
	local flag = self.gamepad_active_last_frame == nil or not is_device_active or get_most_recent_device ~= self._most_recent_device

	if not is_device_active then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true

			local _widgets_by_name = self._widgets_by_name

			_widgets_by_name.panel_input_area_1.content.visible = true
			_widgets_by_name.panel_input_area_2.content.visible = true
			_widgets_by_name.back_button.content.visible = false
			_widgets_by_name.close_button.content.visible = false

			self:_setup_input_buttons()
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		local _widgets_by_name_2 = self._widgets_by_name

		_widgets_by_name_2.panel_input_area_1.content.visible = false
		_widgets_by_name_2.panel_input_area_2.content.visible = false
		_widgets_by_name_2.close_button.content.visible = true
	end

	self._most_recent_device = get_most_recent_device
end

StoreWindowPanel._set_text_button_size = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	arg_18_0._ui_scenegraph[arg_18_1.scenegraph_id].size[1] = arg_18_2

	local style = arg_18_1.style
	local num = 5
	local num_2 = arg_18_2 - num * 2

	style.text.size[1] = num_2
	style.text_shadow.size[1] = num_2
	style.text_hover.size[1] = num_2
	style.text_disabled.size[1] = num_2
	style.text.offset[1] = style.text.default_offset[1] + num
	style.text_shadow.offset[1] = style.text_shadow.default_offset[1] + num
	style.text_hover.offset[1] = style.text_hover.default_offset[1] + num
	style.text_disabled.offset[1] = style.text_disabled.default_offset[1] + num
end

StoreWindowPanel._get_text_width = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not arg_19_1.localize then
		arg_19_2 = Localize(arg_19_2)
	end

	if not arg_19_1.upper_case then
		arg_19_2 = TextToUpper(arg_19_2)
	end

	local _ui_renderer = self._ui_renderer
	local var_19_1, var_19_2 = UIFontByResolution(arg_19_1)

	return (UIRenderer.text_size(_ui_renderer, arg_19_2, var_19_1[1], var_19_2))
end

StoreWindowPanel._set_text_button_horizontal_position = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	arg_20_1.offset[1] = arg_20_2
end

StoreWindowPanel._animate_title_entry = function (arg_21_0, arg_21_1, arg_21_2)
	-- function 21
	local content = arg_21_1.content
	local style = arg_21_1.style
	local button_hotspot = content.button_hotspot
	local is_hover = button_hotspot.is_hover
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

	goto label_21_1

	::label_21_0::

	is_clicked = true

	::label_21_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8
	local num_2 = 20
	local animate_value = UIUtils.animate_value(input_progress, arg_21_2 * num_2, is_clicked)
	local animate_value_2 = UIUtils.animate_value(hover_progress, arg_21_2 * num, is_hover)
	local animate_value_3 = UIUtils.animate_value(selection_progress, arg_21_2 * num, is_selected)
	local easeOutCubic = math.easeOutCubic(animate_value_2)
	local easeInCubic = math.easeInCubic(animate_value_2)
	local easeOutCubic_2 = math.easeOutCubic(animate_value_3)
	local easeInCubic_2 = math.easeInCubic(animate_value_3)
	local max = math.max(animate_value_2, animate_value_3)
	local max_2 = math.max(easeOutCubic_2, easeOutCubic)
	local max_3 = math.max(easeInCubic, easeInCubic_2)
	local num_3 = 255 * max

	if not style.text then
		local num_4 = 1 * max

		style.text.offset[2] = -(2 + num_4)
		style.text_shadow.offset[2] = -(4 + num_4)
		style.text_hover.offset[2] = -(2 + num_4)
		style.text_disabled.offset[2] = -(2 + num_4)
	end

	if not style.new_marker then
		local num_5 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

		style.new_marker.color[1] = 100 + 155 * num_5
	end

	button_hotspot.hover_progress = animate_value_2
	button_hotspot.input_progress = animate_value
	button_hotspot.selection_progress = animate_value_3
end

StoreWindowPanel._animate_back_button = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	local content = arg_22_1.content
	local style = arg_22_1.style
	local button_hotspot = content.button_hotspot
	local is_hover = button_hotspot.is_hover
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

	goto label_22_1

	::label_22_0::

	is_clicked = true

	::label_22_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8
	local num_2 = 20
	local animate_value = UIUtils.animate_value(input_progress, arg_22_2 * num_2, is_clicked)
	local animate_value_2 = UIUtils.animate_value(hover_progress, arg_22_2 * num, is_hover)
	local animate_value_3 = UIUtils.animate_value(selection_progress, arg_22_2 * num, is_selected)
	local easeOutCubic = math.easeOutCubic(animate_value_2)
	local easeInCubic = math.easeInCubic(animate_value_2)
	local easeOutCubic_2 = math.easeOutCubic(animate_value_3)
	local easeInCubic_2 = math.easeInCubic(animate_value_3)
	local max = math.max(animate_value_2, animate_value_3)
	local max_2 = math.max(easeOutCubic_2, easeOutCubic)
	local max_3 = math.max(easeInCubic, easeInCubic_2)
	local num_3 = 255 * max

	style.texture_id.color[1] = 255 - num_3
	style.texture_hover_id.color[1] = num_3
	style.selected_texture.color[1] = num_3
	button_hotspot.hover_progress = animate_value_2
	button_hotspot.input_progress = animate_value
	button_hotspot.selection_progress = animate_value_3
end

StoreWindowPanel._sync_wallet_matchmaking_location = function (self)
	-- function 23
	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()

	if is_game_matchmaking ~= self._is_game_matchmaking then
		self._is_game_matchmaking = is_game_matchmaking

		local _ui_scenegraph = self._ui_scenegraph
		local flag

		flag = not is_game_matchmaking and 26 and 0

		local _currency_types = self._currency_types

		for i = 1, #_currency_types do
			local var_23_4 = _currency_types[i]
			local str = "currency_node_" .. var_23_4

			_ui_scenegraph[str].position[1] = scenegraph_definition[str].position[1] - flag
		end
	end
end

StoreWindowPanel._sync_player_wallet = function (self)
	-- function 24
	local _currency_types = self._currency_types
	local num = 0
	local flag = false

	for i = 1, #_currency_types do
		local var_24_3 = _currency_types[i]
		local get_chips = Managers.backend:get_interface("peddler"):get_chips(var_24_3)

		if get_chips ~= self._currencies[var_24_3] then
			self._currencies[var_24_3] = get_chips
			flag = true
		end
	end

	if not flag then
		for j = 1, #_currency_types do
			local var_24_5 = _currency_types[j]
			local var_24_6 = self._currencies[var_24_5]
			local var_24_7 = self._top_widgets_by_name["currency_panel_widget_" .. var_24_5]
			local content = var_24_7.content
			local style = var_24_7.style
			local var_24_10 = self._currency_ui_settings[var_24_5]
			local comma_value = UIUtils.comma_value(tostring(var_24_6))

			if not var_24_10.max_amount then
				comma_value = string.format("%s/{#size(20)}%s{#reset()}", comma_value, tostring(var_24_10.max_amount))
			end

			content.currency_text = comma_value

			local _ui_renderer = self._ui_renderer
			local get_text_width = UIUtils.get_text_width(_ui_renderer, style.currency_text, comma_value)
			local var_24_14 = style.currency_icon.texture_size[1]
			local num_2 = 10
			local num_3 = var_24_14 + get_text_width + num_2 * 2
			local _ui_scenegraph = self._ui_scenegraph
			local num_4 = num_3 + 60

			_ui_scenegraph["currency_node_" .. var_24_5].size[1] = num_4
			scenegraph_definition["currency_node_" .. var_24_5].position[1] = -92 - num

			local flag_2

			flag_2 = not Managers.matchmaking:is_game_matchmaking() and 26 and 0
			_ui_scenegraph["currency_node_" .. var_24_5].position[1] = scenegraph_definition["currency_node_" .. var_24_5].position[1] - flag_2
			num = num + num_4
		end
	end
end

StoreWindowPanel._start_panel_selection_animation = function (self, arg_25_1, arg_25_2)
	-- function 25
	local entry_panel_selection = self._widgets_by_name.entry_panel_selection
	local offset = entry_panel_selection.offset
	local size = entry_panel_selection.content.size
	local _panel_selection_animation = self._panel_selection_animation

	_panel_selection_animation = _panel_selection_animation or {}
	self._panel_selection_animation = _panel_selection_animation

	local var_25_4 = offset[1]
	local var_25_5 = size[1]
	local var_25_6 = self._title_button_widgets[arg_25_2].offset[1]
	local var_25_7 = self._title_button_widgets[arg_25_2].content.size[1]
	local num = 0.3

	_panel_selection_animation.duration = num
	_panel_selection_animation.total_duration = num
	_panel_selection_animation.target_offset = var_25_6
	_panel_selection_animation.start_offset = var_25_4
	_panel_selection_animation.target_width = var_25_7
	_panel_selection_animation.start_width = var_25_5
end

StoreWindowPanel._update_panel_selection_animation = function (self, arg_26_1)
	-- function 26
	local _panel_selection_animation = self._panel_selection_animation

	if not _panel_selection_animation then
		return
	end

	local duration = _panel_selection_animation.duration

	if not duration then
		return
	end

	local max = math.max(duration - arg_26_1, 0)
	local start_offset = _panel_selection_animation.start_offset
	local target_offset = _panel_selection_animation.target_offset
	local start_width = _panel_selection_animation.start_width
	local target_width = _panel_selection_animation.target_width
	local num = 1 - max / _panel_selection_animation.total_duration
	local easeOutCubic = math.easeOutCubic(num)
	local num_2 = start_width + (target_width - start_width) * easeOutCubic
	local num_3 = start_offset + (target_offset - start_offset) * easeOutCubic
	local entry_panel_selection = self._widgets_by_name.entry_panel_selection
	local texture_size = entry_panel_selection.style.write_mask.texture_size
	local size = entry_panel_selection.content.size
	local scenegraph_id = entry_panel_selection.scenegraph_id

	size[1] = num_2
	texture_size[1] = num_2 * 1.5
	self._ui_scenegraph[scenegraph_id].size[1] = num_2
	entry_panel_selection.offset[1] = num_3

	if max == 0 then
		_panel_selection_animation.duration = nil
	else
		_panel_selection_animation.duration = max
	end
end
