-- chunkname: @scripts/ui/views/credits_view.lua

local var_0_0 = local_require("scripts/settings/credits")
local var_0_1 = local_require("scripts/ui/views/credits_view_definitions")
local tbl = {
	header = Colors.color_definitions.credits_header,
	title = Colors.color_definitions.credits_title,
	normal = Colors.color_definitions.credits_normal
}
local tbl_2 = {
	legal = 15,
	normal = 30
}

CreditsView = class(CreditsView)

CreditsView.init = function (self, arg_1_1)
	-- function 1
	self._ui_renderer = arg_1_1.ui_renderer
	self._ui_top_renderer = arg_1_1.ui_top_renderer
	self._ingame_ui = arg_1_1.ingame_ui
	self._in_title_screen = arg_1_1.in_title_screen

	local input_manager = arg_1_1.input_manager

	self._input_manager = input_manager

	input_manager:create_input_service("credits_view", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("credits_view", "keyboard")
	input_manager:map_device_to_service("credits_view", "mouse")
	input_manager:map_device_to_service("credits_view", "gamepad")
	self:_create_ui_elements()
end

CreditsView._create_ui_elements = function (self)
	-- function 2
	self._num_credits = #var_0_0.entries
	self._current_offset = 0
	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1.scenegraph_definition)
	self._credits_widget = UIWidget.init(var_0_1.widget_definitions.credits)
	self._back_button_widget = UIWidget.init(var_0_1.widget_definitions.back_button)
end

CreditsView.input_service = function (self)
	-- function 3
	return self._input_manager:get_service("credits_view")
end

CreditsView.on_enter = function (self)
	-- function 4
	self._input_manager:capture_input(ALL_INPUT_METHODS, 1, "credits_view", "CreditsView")

	self._current_offset = 0
	self._active = true

	UIWidgetUtils.reset_layout_button(self._back_button_widget)
end

CreditsView.on_exit = function (self)
	-- function 5
	self._input_manager:release_input(ALL_INPUT_METHODS, 1, "credits_view", "CreditsView")

	self.active = nil
	self.exiting = nil

	local music = Managers.music
	local var_5_1 = music
	local trigger_event = music.trigger_event
	local flag

	flag = not IS_WINDOWS and "Play_console_menu_back" and "Play_console_menu_select"

	trigger_event(var_5_1, flag)
end

CreditsView.exit = function (self, arg_6_1)
	-- function 6
	local flag

	flag = not arg_6_1 and "exit_menu" and "ingame_menu"

	self.ingame_ui:handle_transition(flag)

	self.exiting = nil
end

CreditsView.update = function (self, arg_7_1)
	-- function 7
	local _input_manager = self._input_manager
	local get_service = _input_manager:get_service("credits_view")
	local is_device_active = _input_manager:is_device_active("gamepad")

	if get_service:get("toggle_menu", true) or not is_device_active or not get_service:get("back", true) then
		self:exit()

		return
	end

	local get

	if not is_device_active then
		get = get_service:get("gamepad_left_axis")

		if not get then
			-- Nothing
		end
	end

	get = get_service:get("scroll_axis")

	::label_7_0::

	local y = get.y

	if is_device_active or not IS_XB1 then
		y = math.sign(get.x) * 5
	end

	local max = math.max(0, self._current_offset + arg_7_1 * 50 - y * 30)

	self._current_offset = max

	local _ui_top_renderer = self._ui_top_renderer
	local _credits_widget = self._credits_widget
	local content = _credits_widget.content
	local style = _credits_widget.style

	UIRenderer.begin_pass(_ui_top_renderer, self._ui_scenegraph, get_service, arg_7_1)

	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local inv_scale = RESOLUTION_LOOKUP.inv_scale

	UIRenderer.draw_texture(_ui_top_renderer, "gradient_credits_menu", Vector3(0, 0, UILayer.credits_gradient), Vector2(res_w * inv_scale, res_h * inv_scale))

	local entries = var_0_0.entries

	for i = 1, self._num_credits do
		local var_7_14 = entries[i]
		local localized_str = var_7_14.localized_str

		if not localized_str then
			if not var_7_14.localized then
				localized_str = Localize(var_7_14.text)

				if not localized_str then
					-- Nothing
				end
			end

			localized_str = var_7_14.text
		end

		::label_7_1::

		content.text_field = localized_str
		var_7_14.localized_str = content.text_field

		if var_7_14.type == "header" then
			style.text.text_color = tbl.header
			style.text.font_size = tbl_2.normal
			max = max - 84 - 5
		elseif var_7_14.type == "title" then
			style.text.text_color = tbl.title
			style.text.font_size = tbl_2.normal
			max = max - 64 - 5
		elseif var_7_14.type == "legal" then
			style.text.text_color = tbl.normal
			style.text.font_size = tbl_2.legal
			max = max - 15 - 5
		else
			style.text.text_color = tbl.normal
			style.text.font_size = tbl_2.normal
			max = max - 30 - 5
		end

		if max < -84 then
			break
		elseif max < res_h then
			_credits_widget.offset[2] = max

			UIRenderer.draw_widget(_ui_top_renderer, _credits_widget)
		end
	end

	if not self._in_title_screen then
		self:_handle_back_button(_ui_top_renderer, arg_7_1)
	end

	if max > 1200 then
		self._current_offset = 0
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

CreditsView._handle_back_button = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not Managers.input:is_device_active("mouse") then
		return
	end

	local _back_button_widget = self._back_button_widget

	UIWidgetUtils.animate_layout_button(_back_button_widget, arg_8_2)
	UIRenderer.draw_widget(arg_8_1, _back_button_widget)

	if not UIUtils.is_button_pressed(_back_button_widget, "button_hotspot") then
		self:exit()
	end
end
