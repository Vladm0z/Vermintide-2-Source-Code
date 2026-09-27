-- chunkname: @scripts/ui/active_event/active_event_popup.lua

require("scripts/ui/dlc_upsell/common_popup")

ActiveEventPopup = class(ActiveEventPopup, CommonPopup)

ActiveEventPopup.create_ui_elements = function (self)
	-- function 1
	ActiveEventPopup.super.create_ui_elements(self)

	local _common_settings = self._common_settings

	self._widgets_by_name.window_background.content.texture_id = _common_settings.background_texture
	self._widgets_by_name.window_background.offset[1] = 100

	local var_1_1

	if not _common_settings.body_text then
		var_1_1 = Localize(_common_settings.body_text)

		if not var_1_1 then
			-- Nothing
		end
	end

	var_1_1 = ""

	::label_1_0::

	if var_1_1 == "" or not _common_settings.event_name then
		var_1_1 = string.format(var_1_1, _common_settings.event_name)
	end

	if not _common_settings.logo_data then
		local logo_data = _common_settings.logo_data
		local content = self._widgets_by_name.logo.content
		local logo_texture

		if not logo_data.logo_texture then
			logo_texture = logo_data.logo_texture

			if not logo_texture then
				-- Nothing
			end
		end

		logo_texture = "hero_view_home_logo"

		::label_1_1::

		content.texture_id = logo_texture

		local texture_id = self._widgets_by_name.logo.style.texture_id
		local size

		if not logo_data.size then
			size = logo_data.size

			if not size then
				-- Nothing
			end
		end

		size = {
			468,
			236.39999999999998
		}

		::label_1_2::

		texture_id.texture_size = size

		local logo = self._widgets_by_name.logo
		local offset

		if not logo_data.offset then
			offset = logo_data.offset

			if not offset then
				-- Nothing
			end
		end

		offset = {
			-234,
			-118.19999999999999,
			1
		}

		::label_1_3::

		logo.offset = offset
	end

	self._widgets_by_name.body_text.content.text = var_1_1
	self._widgets_by_name.close_button.content.title_text = Localize(_common_settings.button_text)

	if not _common_settings.top_detail_texture then
		self._widgets_by_name.window_top_detail.content.texture_id = _common_settings.top_detail_texture.texture
		self._widgets_by_name.window_top_detail.style.texture_id.size = _common_settings.top_detail_texture.size
		self._widgets_by_name.window_top_detail.style.texture_id.offset = _common_settings.top_detail_texture.offset
	end

	if not _common_settings.action_buttons then
		self._action_button_widgets = {}

		local action_buttons = _common_settings.action_buttons

		for i = 1, #action_buttons do
			local var_1_10 = action_buttons[i]
			local button_text = var_1_10.button_text
			local tbl = {
				360,
				60
			}
			local create_simple_action_button = self._definitions.create_simple_action_button("action_buttons_anchor", tbl, button_text, "button_frame_02_gold")
			local var_1_14 = UIWidget.init(create_simple_action_button)

			var_1_14.offset[1] = -(tbl[1] * 0.5)
			var_1_14.offset[2] = 80 * (#action_buttons - i)
			var_1_14.content.on_pressed = callback(var_1_10.on_pressed)
			self._action_button_widgets[#self._action_button_widgets + 1] = var_1_14
		end
	end

	self._selected_button_idx = #self._action_button_widgets
	self._buttons_amount = #self._action_button_widgets
	self._action_button_widgets[#self._action_button_widgets].content.button_hotspot.is_selected = true
end

ActiveEventPopup.update = function (self, arg_2_1)
	-- function 2
	if not (not self:should_show() and self._has_widget_been_closed) then
		self:show()
	end

	ActiveEventPopup.super.update(self, arg_2_1)
end

ActiveEventPopup.draw = function (self, arg_3_1)
	-- function 3
	ActiveEventPopup.super.draw(self, arg_3_1)

	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _get_input_service = self:_get_input_service()
	local _render_settings = self._render_settings
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, _get_input_service, arg_3_1, nil, _render_settings)

	if not self._action_button_widgets then
		UIRenderer.draw_all_widgets(_ui_top_renderer, self._action_button_widgets)
	end

	UIRenderer.end_pass(_ui_top_renderer)
	self:_update_scrolling_background(arg_3_1)
end

ActiveEventPopup._handle_input = function (self, arg_4_1)
	-- function 4
	local _get_input_service = self:_get_input_service()
	local _widgets_by_name = self._widgets_by_name
	local is_device_active = Managers.input:is_device_active("gamepad")

	if not is_device_active then
		self:_handle_gamepad_selection(arg_4_1, _get_input_service)
	else
		self:_handle_mouse_selection(arg_4_1, _get_input_service)
	end

	for i, v in ipairs(self._action_button_widgets) do
		v.content.button_hotspot.is_selected = not is_device_active and i == self._selected_button_idx
	end

	if not is_device_active and not _get_input_service:get("confirm_press", true) then
		self:play_sound("Play_gui_event_ui_select")

		local content = self._action_button_widgets[self._selected_button_idx].content

		if not content.on_pressed then
			local tbl = {
				on_exit_func = content.on_pressed
			}

			self:_on_close(tbl)
		end
	end

	if self._has_widget_been_closed or UIUtils.is_button_pressed(_widgets_by_name.close_button) or _get_input_service:get("back", true) or not _get_input_service:get("toggle_menu", true) then
		self:_on_close()

		return
	end
end

ActiveEventPopup._handle_gamepad_selection = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._action_button_widgets then
		local _action_button_widgets = self._action_button_widgets
		local _selected_button_idx = self._selected_button_idx

		if not arg_5_2:get("move_up") then
			_selected_button_idx = not (_selected_button_idx + 1 <= self._buttons_amount) or not (_selected_button_idx + 1) or 1

			self:play_sound("play_gui_start_menu_button_hover")
		elseif not arg_5_2:get("move_down") then
			_selected_button_idx = not (_selected_button_idx - 1 >= 1) or not (_selected_button_idx - 1) or self._buttons_amount

			self:play_sound("play_gui_start_menu_button_hover")
		end

		if _selected_button_idx ~= self._selected_button_idx then
			self._selected_button_idx = _selected_button_idx
		end
	end
end

ActiveEventPopup._handle_mouse_selection = function (self, arg_6_1, arg_6_2)
	-- function 6
	if not self._action_button_widgets then
		local _action_button_widgets = self._action_button_widgets

		for i = 1, #_action_button_widgets do
			local var_6_1 = _action_button_widgets[i]

			if not UIUtils.is_button_hover_enter(var_6_1) then
				self:play_sound("play_gui_start_menu_button_hover")
			end

			if not UIUtils.is_button_pressed(var_6_1) then
				self:play_sound("Play_gui_event_ui_select")

				local content = var_6_1.content

				if not content.on_pressed then
					local tbl = {
						on_exit_func = content.on_pressed
					}

					self:_on_close(tbl)

					return
				end
			end
		end
	end
end

ActiveEventPopup._on_close = function (self, arg_7_1)
	-- function 7
	self._has_widget_been_closed = true

	self:release_input()
	self:hide(arg_7_1)
end

ActiveEventPopup.show = function (self)
	-- function 8
	ActiveEventPopup.super.show(self)
	self:_start_transition_animation("on_enter")
	self:play_sound("Play_gui_event_ui_open")

	local world = Managers.world:world("level_world")

	World.set_data(world, "fullscreen_blur", 0.5)
end

ActiveEventPopup.hide = function (self, arg_9_1)
	-- function 9
	self._exit_anim_id = self:_start_transition_animation("on_exit", arg_9_1)

	local world = Managers.world:world("level_world")

	World.set_data(world, "fullscreen_blur", nil)
end

ActiveEventPopup._start_transition_animation = function (self, arg_10_1, arg_10_2)
	-- function 10
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}

	if not arg_10_2 then
		for k, v in pairs(arg_10_2) do
			tbl[k] = v
		end
	end

	return self._ui_animator:start_animation(arg_10_1, nil, self._definitions.scenegraph_definition, tbl)
end

ActiveEventPopup._update_animations = function (self, arg_11_1)
	-- function 11
	ActiveEventPopup.super._update_animations(self, arg_11_1)

	if not self._exit_anim_id and not self._ui_animator:is_animation_completed(self._exit_anim_id) then
		self._is_visible = false
	end

	local _widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_default_button(_widgets_by_name.close_button, arg_11_1)
end

ActiveEventPopup.should_show = function (self)
	-- function 12
	local is_in_inn = self._ui_context.is_in_inn

	if not is_in_inn then
		if not (Managers.popup:has_popup() ~= false or self._ui_context.ingame_ui.current_view ~= nil) then
			is_in_inn = self._ui_context.ingame_ui.has_left_menu

			if not is_in_inn then
				is_in_inn = not self._is_visible
			end
		else
			is_in_inn = false
		end
	end

	if false then
		is_in_inn = true
	end

	return is_in_inn
end

ActiveEventPopup._update_scrolling_background = function (self, arg_13_1)
	-- function 13
	local window_background = self._widgets_by_name.window_background
	local num = 100 + 150 * math.sin(Managers.time:time("ui") * 0.1)

	window_background.offset[1] = num
end
