-- chunkname: @scripts/ui/text_popup/text_popup_ui.lua

local var_0_0 = local_require("scripts/ui/text_popup/text_popup_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local generic_input_actions = var_0_0.generic_input_actions
local var_0_3 = scenegraph_definition.text_entry.size[2]

TextPopupUI = class(TextPopupUI)

TextPopupUI.init = function (self, arg_1_1)
	-- function 1
	self._ui_top_renderer = arg_1_1.ui_top_renderer
	self._input_manager = arg_1_1.input_manager
	self._render_settings = {
		snap_pixel_positions = true
	}

	self:_create_ui_elements()
	self:_setup_input()

	local get_service = self._input_manager:get_service("Text")

	self._menu_input_description = MenuInputDescriptionUI:new(arg_1_1, self._ui_top_renderer, get_service, 3, 900, generic_input_actions.default)

	self._menu_input_description:set_input_description(nil)
end

TextPopupUI._setup_input = function (self)
	-- function 2
	self._input_manager:create_input_service("Text", "IngameMenuKeymaps", "IngameMenuFilters")
	self._input_manager:map_device_to_service("Text", "keyboard")
	self._input_manager:map_device_to_service("Text", "mouse")
	self._input_manager:map_device_to_service("Text", "gamepad")
end

TextPopupUI._create_ui_elements = function (self)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local widget_definitions = var_0_0.widget_definitions

	self._widgets = {}
	self._widgets_by_name = {}
	self._buttons = {}

	for k, v in pairs(widget_definitions) do
		local var_3_1 = UIWidget.init(v)

		self._widgets[#self._widgets + 1] = var_3_1

		if not string.ends_with(k, "_button") then
			self._buttons[k] = var_3_1
		else
			self._widgets_by_name[k] = var_3_1
		end
	end
end

TextPopupUI.show = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if not self._draw_widgets and not self.is_visible then
		print("TextPopupUI is already visible")

		return
	end

	if not arg_4_3 then
		self._on_close_callback = arg_4_3
	end

	self._widgets_by_name.title_text.content.text = Localize(arg_4_1)
	self._widgets_by_name.overlay_text.content.text = Localize(arg_4_2)

	self:_update_scroll_height(0)

	self._draw_widgets = true
	self.is_visible = true

	ShowCursorStack.show("TextPopupUI")
	self._input_manager:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "Text", "TextPopupUI")
end

TextPopupUI.hide = function (self)
	-- function 5
	if not (self._draw_widgets or self.is_visible) then
		return
	end

	self._draw_widgets = false
	self.is_visible = false

	ShowCursorStack.hide("TextPopupUI")
	self._input_manager:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "Text", "TextPopupUI")

	if not self._on_close_callback then
		self._on_close_callback()

		self._on_close_callback = nil
	end
end

TextPopupUI.update = function (self, arg_6_1)
	-- function 6
	if not (not self.is_visible and self._draw_widgets) then
		return
	end

	if not self:_button_clicked("ok_button") then
		self:hide()

		return
	end

	self:_update_mouse_scroll_input()
	self:_update_gamepad_scroll_input()
	self:_draw(arg_6_1)
end

TextPopupUI.post_update = function (arg_7_0, arg_7_1)
	-- function 7
	return
end

TextPopupUI.post_render = function (arg_8_0)
	-- function 8
	return
end

TextPopupUI._update_scroll_height = function (self, arg_9_1)
	-- function 9
	local get_text_height = UIUtils.get_text_height(self._ui_top_renderer, var_0_0.scenegraph_definition.text_entry.size, var_0_0.scroll_text_style, self._widgets_by_name.overlay_text.content.text)

	self._total_scroll_height = math.max(get_text_height - var_0_3, 0)

	self:_setup_scrollbar(get_text_height, arg_9_1)
end

TextPopupUI._setup_scrollbar = function (self, arg_10_1, arg_10_2)
	-- function 10
	local scrollbar = self._widgets_by_name.scrollbar
	local scenegraph_id = scrollbar.scenegraph_id
	local var_10_2 = self._ui_scenegraph[scenegraph_id].size[2]
	local min = math.min(var_10_2 / arg_10_1, 1)

	scrollbar.content.scroll_bar_info.bar_height_percentage = min

	self:_set_scrollbar_value(arg_10_2 or 0)

	local num = 2
	local num_2 = math.max(var_0_3 / self._total_scroll_height, 0) * num

	self._widgets_by_name.scroll_content.content.scroll_amount = num_2
end

TextPopupUI._update_mouse_scroll_input = function (self)
	-- function 11
	local _widgets_by_name = self._widgets_by_name
	local scrollbar = _widgets_by_name.scrollbar
	local scroll_content = _widgets_by_name.scroll_content

	if not scrollbar.content.scroll_bar_info.on_pressed then
		scroll_content.content.scroll_add = nil
	end

	local scroll_value = scroll_content.content.scroll_value

	if not scroll_value then
		return
	end

	local value = scrollbar.content.scroll_bar_info.value
	local _scroll_value = self._scroll_value

	_scroll_value = _scroll_value or 0

	if _scroll_value ~= scroll_value then
		self:_set_scrollbar_value(scroll_value)
	elseif _scroll_value ~= value then
		self:_set_scrollbar_value(value)
	end
end

TextPopupUI._update_gamepad_scroll_input = function (self)
	-- function 12
	if not Managers.input:is_device_active("gamepad") then
		return
	end

	local get = self._input_manager:get_service("Text"):get("gamepad_left_axis")

	if math.abs(get.y) == 0 then
		return
	end

	local content = self._widgets_by_name.scroll_content.content

	content.scroll_add = content.scroll_amount * get.y * -1 * 0.1
end

TextPopupUI._set_scrollbar_value = function (self, arg_13_1)
	-- function 13
	if not arg_13_1 then
		local _widgets_by_name = self._widgets_by_name

		_widgets_by_name.scrollbar.content.scroll_bar_info.value = arg_13_1
		_widgets_by_name.scroll_content.content.scroll_value = arg_13_1
		self._scroll_value = arg_13_1

		local str = "text_entry"
		local _ui_scenegraph = self._ui_scenegraph
		local position = scenegraph_definition[str].position

		_ui_scenegraph[str].local_position[2] = position[2] + arg_13_1 * self._total_scroll_height
	end
end

TextPopupUI._draw = function (self, arg_14_1)
	-- function 14
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("Text")
	local is_device_active = Managers.input:is_device_active("gamepad")
	local _render_settings = self._render_settings

	for k, v in pairs(self._buttons) do
		self:_animate_button(v, arg_14_1)
	end

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, get_service, arg_14_1, nil, _render_settings)

	for i, v_2 in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v_2)
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not is_device_active then
		self._menu_input_description:draw(_ui_top_renderer, arg_14_1)
	end
end

TextPopupUI._button_clicked = function (self, arg_15_1)
	-- function 15
	local on_release = self._buttons[arg_15_1].content.button_hotspot.on_release

	on_release = not Managers.input:is_device_active("gamepad") and arg_15_1 == "ok_button" and self._input_manager:get_service("Text"):get("confirm") and on_release

	if not on_release then
		self._buttons[arg_15_1].content.button_hotspot.on_release = false
	end

	return on_release
end

TextPopupUI._animate_button = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	local content = arg_16_1.content
	local style = arg_16_1.style
	local button_hotspot = content.button_hotspot
	local is_hover = button_hotspot.is_hover
	local is_selected = button_hotspot.is_selected
	local is_clicked = button_hotspot.is_clicked

	is_clicked = not is_clicked and button_hotspot.is_clicked == 0

	local input_progress = button_hotspot.input_progress

	input_progress = input_progress or 0

	local hover_progress = button_hotspot.hover_progress

	hover_progress = hover_progress or 0

	local selection_progress = button_hotspot.selection_progress

	selection_progress = selection_progress or 0

	local num = 8
	local num_2 = 20

	if not is_clicked then
		input_progress = math.min(input_progress + arg_16_2 * num_2, 1)
	else
		input_progress = math.max(input_progress - arg_16_2 * num_2, 0)
	end

	if not is_hover then
		hover_progress = math.min(hover_progress + arg_16_2 * num, 1)
	else
		hover_progress = math.max(hover_progress - arg_16_2 * num, 0)
	end

	if not is_selected then
		selection_progress = math.min(selection_progress + arg_16_2 * num, 1)
	else
		selection_progress = math.max(selection_progress - arg_16_2 * num, 0)
	end

	local max = math.max(hover_progress, selection_progress)

	style.clicked_rect.color[1] = 100 * input_progress

	local num_3 = 255 * hover_progress

	style.hover_glow.color[1] = num_3

	local title_text_disabled = style.title_text_disabled
	local default_text_color = title_text_disabled.default_text_color
	local text_color = title_text_disabled.text_color

	text_color[2] = default_text_color[2] * 0.4
	text_color[3] = default_text_color[3] * 0.4
	text_color[4] = default_text_color[4] * 0.4
	button_hotspot.hover_progress = hover_progress
	button_hotspot.input_progress = input_progress
	button_hotspot.selection_progress = selection_progress

	local title_text = style.title_text
	local text_color_2 = title_text.text_color
	local default_text_color_2 = title_text.default_text_color
	local select_text_color = title_text.select_text_color

	Colors.lerp_color_tables(default_text_color_2, select_text_color, max, text_color_2)
end

TextPopupUI.destroy = function (self)
	-- function 17
	self._draw_widgets = false
	self.is_visible = false
	self._widgets = nil
	self._widgets_by_name = nil
	self._buttons = nil
	self._on_close_callback = nil
end
