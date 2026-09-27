-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_weave_panel_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_panel_console_definitions")
local widgets = var_0_0.widgets
local title_button_definitions = var_0_0.title_button_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local str = "cycle_next"
local str_2 = "cycle_previous"

StartGameWindowWeavePanelConsole = class(StartGameWindowWeavePanelConsole)
StartGameWindowWeavePanelConsole.NAME = "StartGameWindowWeavePanelConsole"

StartGameWindowWeavePanelConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowWeavePanelConsole")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui = ingame_ui_context.ingame_ui
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._layout_settings = arg_1_1.layout_settings
	self._animations = {}
	self._ui_animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)
	self:_setup_input_buttons()
end

StartGameWindowWeavePanelConsole._create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widgets)

	local tbl = {}
	local window_layouts = self._layout_settings.window_layouts
	local str = "game_option"
	local size = scenegraph_definition[str].size
	local num = 28
	local str_2 = "center"
	local tbl_2 = {
		upper_case = true,
		localize = true,
		dynamic_font_size = true,
		word_wrap = false,
		font_type = "hell_shark_header",
		font_size = num
	}
	local _parent = self._parent
	local num_2 = 0

	for i, v in ipairs(window_layouts) do
		if not v.panel_sorting and not _parent:can_add_layout(v) then
			local name = v.name
			local display_name = v.display_name

			display_name = display_name or "n/a"

			local _get_text_width = self:_get_text_width(tbl_2, display_name)
			local tbl_3 = {
				math.min(_get_text_width + 40, 400),
				size[2]
			}
			local tbl_4 = {
				num_2,
				0,
				0
			}
			local create_weave_panel_button = UIWidgets.create_weave_panel_button(str, tbl_3, display_name, num, tbl_4, str_2)

			num_2 = num_2 + tbl_3[1]

			local var_2_15 = UIWidget.init(create_weave_panel_button)

			self:_set_text_button_size(var_2_15, tbl_3[1])

			var_2_15.content.layout_name = name
			tbl[#tbl + 1] = var_2_15
		end
	end

	self._ui_scenegraph.panel_entry_area.size[1] = num_2
	self._title_button_widgets = tbl

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
end

StartGameWindowWeavePanelConsole.on_exit = function (self, arg_3_1)
	-- function 3
	print("[StartGameWindow] Exit Substate StartGameWindowWeavePanelConsole")

	self._ui_animator = nil
end

StartGameWindowWeavePanelConsole.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not DO_RELOAD then
		self:_create_ui_elements()
	end

	self:_handle_gamepad_activity()
	self:_update_selected_option()
	self:_update_animations(arg_4_1)
	self:_draw(arg_4_1)
end

StartGameWindowWeavePanelConsole.post_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_handle_input(arg_5_1, arg_5_2)
end

StartGameWindowWeavePanelConsole._update_animations = function (self, arg_6_1)
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

	local _title_button_widgets = self._title_button_widgets

	for i, v_3 in ipairs(_title_button_widgets) do
		self:_animate_title_entry(v_3, arg_6_1)
	end

	self:_update_panel_selection_animation(arg_6_1)
end

StartGameWindowWeavePanelConsole._is_button_pressed = function (arg_7_0, arg_7_1)
	-- function 7
	local content = arg_7_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.button_text

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowWeavePanelConsole._is_stepper_button_pressed = function (arg_8_0, arg_8_1)
	-- function 8
	local content = arg_8_1.content
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

StartGameWindowWeavePanelConsole._is_button_hover_enter = function (arg_9_0, arg_9_1)
	-- function 9
	return arg_9_1.content.button_hotspot.on_hover_enter
end

StartGameWindowWeavePanelConsole._is_button_hover_exit = function (arg_10_0, arg_10_1)
	-- function 10
	return arg_10_1.content.button_hotspot.on_hover_exit
end

StartGameWindowWeavePanelConsole._is_button_selected = function (arg_11_0, arg_11_1)
	-- function 11
	return arg_11_1.content.button_hotspot.is_selected
end

StartGameWindowWeavePanelConsole._handle_input = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _parent = self._parent
	local _widgets_by_name = self._widgets_by_name
	local window_input_service = self._parent:window_input_service()
	local flag = false
	local _title_button_widgets = self._title_button_widgets
	local count = #_title_button_widgets

	for i, v in ipairs(_title_button_widgets) do
		if not v.content.button_hotspot.is_selected then
			if not self:_is_button_hover_enter(v) then
				self:_play_sound("Play_hud_store_button_hover_category")
			end

			if not self:_is_button_pressed(v) then
				self:_on_panel_button_selected(i)

				flag = true
			end
		end
	end

	if not flag then
		local _selected_index = self._selected_index

		_selected_index = _selected_index or 1

		local count_2 = #_title_button_widgets

		if not window_input_service:get(str_2) then
			local num

			if _selected_index > 1 then
				num = _selected_index - 1

				if not num then
					-- Nothing
				end
			end

			num = count_2

			::label_12_0::

			self:_on_panel_button_selected(num)
		elseif not window_input_service:get(str) then
			local num_2 = _selected_index % count_2 + 1

			self:_on_panel_button_selected(num_2)
		end
	end
end

StartGameWindowWeavePanelConsole._on_panel_button_selected = function (self, arg_13_1)
	-- function 13
	local _parent = self._parent
	local layout_name = self._title_button_widgets[arg_13_1].content.layout_name

	print("_on_panel_button_selected", arg_13_1, layout_name)
	_parent:set_layout_by_name(layout_name)
end

StartGameWindowWeavePanelConsole._set_selected_option = function (self, arg_14_1)
	-- function 14
	self:_start_panel_selection_animation(self._selected_index, arg_14_1)

	local _title_button_widgets = self._title_button_widgets

	for i, v in ipairs(_title_button_widgets) do
		v.content.button_hotspot.is_selected = i == arg_14_1
	end
end

StartGameWindowWeavePanelConsole._update_selected_option = function (self)
	-- function 15
	local get_selected_layout_name = self._parent:get_selected_layout_name()

	if not get_selected_layout_name then
		local _title_button_widgets = self._title_button_widgets

		for i, v in ipairs(_title_button_widgets) do
			if not (v.content.layout_name ~= get_selected_layout_name or i == self._selected_index) then
				self:_set_selected_option(i)

				self._selected_index = i
			end
		end
	end
end

StartGameWindowWeavePanelConsole._draw = function (self, arg_16_1)
	-- function 16
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_16_1, nil, _render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	for i_2, v_2 in ipairs(self._title_button_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v_2)
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowWeavePanelConsole._play_sound = function (self, arg_17_1)
	-- function 17
	self._parent:play_sound(arg_17_1)
end

StartGameWindowWeavePanelConsole._setup_input_buttons = function (self)
	-- function 18
	local window_input_service = self._parent:window_input_service()
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

StartGameWindowWeavePanelConsole._handle_gamepad_activity = function (self)
	-- function 19
	local is_device_active = Managers.input:is_device_active("gamepad")
	local get_most_recent_device = Managers.input:get_most_recent_device()
	local flag = self.gamepad_active_last_frame == nil or not is_device_active or get_most_recent_device ~= self._most_recent_device

	if not is_device_active then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true

			local _widgets_by_name = self._widgets_by_name

			_widgets_by_name.panel_input_area_1.content.visible = true
			_widgets_by_name.panel_input_area_2.content.visible = true

			self:_setup_input_buttons()
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		local _widgets_by_name_2 = self._widgets_by_name

		_widgets_by_name_2.panel_input_area_1.content.visible = false
		_widgets_by_name_2.panel_input_area_2.content.visible = false
	end

	self._most_recent_device = get_most_recent_device
end

StartGameWindowWeavePanelConsole._set_text_button_size = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	arg_20_0._ui_scenegraph[arg_20_1.scenegraph_id].size[1] = arg_20_2

	local style = arg_20_1.style
	local num = 5
	local num_2 = arg_20_2 - num * 2

	style.text.size[1] = num_2
	style.text_shadow.size[1] = num_2
	style.text_hover.size[1] = num_2
	style.text_disabled.size[1] = num_2
	style.text.offset[1] = style.text.default_offset[1] + num
	style.text_shadow.offset[1] = style.text_shadow.default_offset[1] + num
	style.text_hover.offset[1] = style.text_hover.default_offset[1] + num
	style.text_disabled.offset[1] = style.text_disabled.default_offset[1] + num
end

StartGameWindowWeavePanelConsole._get_text_width = function (self, arg_21_1, arg_21_2)
	-- function 21
	if not arg_21_1.localize then
		arg_21_2 = Localize(arg_21_2)
	end

	if not arg_21_1.upper_case then
		arg_21_2 = TextToUpper(arg_21_2)
	end

	local _ui_renderer = self._ui_renderer
	local var_21_1, var_21_2 = UIFontByResolution(arg_21_1)
	local text_size, var_21_4, var_21_5 = UIRenderer.text_size(_ui_renderer, arg_21_2, var_21_1[1], var_21_2)

	return text_size
end

StartGameWindowWeavePanelConsole._set_text_button_horizontal_position = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	arg_22_1.offset[1] = arg_22_2
end

StartGameWindowWeavePanelConsole._animate_title_entry = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	local content = arg_23_1.content
	local style = arg_23_1.style
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

	goto label_23_1

	::label_23_0::

	is_clicked = true

	::label_23_1::

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8
	local num_2 = 20

	if not is_clicked then
		input_progress = math.min(input_progress + arg_23_2 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_23_2 * num_2, 0)
	end

	local easeOutCubic = math.easeOutCubic(input_progress)
	local easeInCubic = math.easeInCubic(input_progress)

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_23_2 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_23_2 * num, 0)
	end

	local easeOutCubic_2 = math.easeOutCubic(hover_progress)
	local easeInCubic_2 = math.easeInCubic(hover_progress)

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_23_2 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_23_2 * num, 0)
	end

	local easeOutCubic_3 = math.easeOutCubic(selection_progress)
	local easeInCubic_3 = math.easeInCubic(selection_progress)
	local max = math.max(hover_progress, selection_progress)
	local max_2 = math.max(easeOutCubic_3, easeOutCubic_2)
	local max_3 = math.max(easeInCubic_2, easeInCubic_3)
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

	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress
end

StartGameWindowWeavePanelConsole._start_panel_selection_animation = function (self, arg_24_1, arg_24_2)
	-- function 24
	local entry_panel_selection = self._widgets_by_name.entry_panel_selection
	local offset = entry_panel_selection.offset
	local size = entry_panel_selection.content.size
	local _panel_selection_animation = self._panel_selection_animation

	_panel_selection_animation = _panel_selection_animation or {}
	self._panel_selection_animation = _panel_selection_animation

	local var_24_4 = offset[1]
	local var_24_5 = size[1]
	local var_24_6 = self._title_button_widgets[arg_24_2].offset[1]
	local var_24_7 = self._title_button_widgets[arg_24_2].content.size[1]
	local num = 0.3

	_panel_selection_animation.duration = num
	_panel_selection_animation.total_duration = num
	_panel_selection_animation.target_offset = var_24_6
	_panel_selection_animation.start_offset = var_24_4
	_panel_selection_animation.target_width = var_24_7
	_panel_selection_animation.start_width = var_24_5
end

StartGameWindowWeavePanelConsole._update_panel_selection_animation = function (self, arg_25_1)
	-- function 25
	local _panel_selection_animation = self._panel_selection_animation

	if not _panel_selection_animation then
		return
	end

	local duration = _panel_selection_animation.duration

	if not duration then
		return
	end

	local max = math.max(duration - arg_25_1, 0)
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
	texture_size[1] = num_2 * 2
	self._ui_scenegraph[scenegraph_id].size[1] = num_2
	entry_panel_selection.offset[1] = num_3

	if max == 0 then
		_panel_selection_animation.duration = nil
	else
		_panel_selection_animation.duration = max
	end
end
