-- chunkname: @scripts/ui/views/tutorial_input_ui.lua

local var_0_0 = local_require("scripts/ui/views/tutorial_input_ui_definitions")
local flag = true

TutorialInputUI = class(TutorialInputUI)

TutorialInputUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._input_manager = arg_1_2.input_manager
	self._platform = PLATFORM
	self._ingame_ui_context = arg_1_2
	self._tutorial_tooltip_animations = {}
	self._tutorial_tooltip_input_widgets = {}
	self._active_tutorial_tooltips = {}
	self._current_profile_index = nil
	self._current_career_index = nil
	self._prefixes = {
		mouse = "mouse"
	}

	self:_create_ui_elements()
	Managers.state.event:register(self, "event_add_tutorial_input", "event_add_tutorial_input")
	Managers.state.event:register(self, "event_update_tutorial_input", "event_update_tutorial_input")
	Managers.state.event:register(self, "event_remove_tutorial_input", "event_remove_tutorial_input")
	Managers.state.event:register(self, "input_changed", "event_input_changed")
end

TutorialInputUI.destroy = function (arg_2_0)
	-- function 2
	if not Managers.state.event then
		Managers.state.event:unregister("event_add_tutorial_input", arg_2_0)
		Managers.state.event:unregister("event_update_tutorial_input", arg_2_0)
		Managers.state.event:unregister("event_remove_tutorial_input", arg_2_0)
		Managers.state.event:unregister("input_changed", arg_2_0)
	end
end

TutorialInputUI.event_add_tutorial_input = function (self, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0 = Missions[arg_3_1]

	fassert(var_3_0, "[TutorialInputUI:event_add_tutorial_input] There is no mission called %q", arg_3_1)

	self._active_tutorial_tooltips[#self._active_tutorial_tooltips + 1] = var_3_0
	self._current_profile_index, self._current_career_index = self:_get_profile_and_career_index()

	if not arg_3_2 then
		Unit.flow_event(arg_3_2, "lua_mission_started")
	end
end

TutorialInputUI.event_update_tutorial_input = function (arg_4_0, arg_4_1)
	-- function 4
	return
end

TutorialInputUI.event_remove_tutorial_input = function (self, arg_5_1)
	-- function 5
	fassert(Missions[arg_5_1], "[TutorialInputUI:event_remove_tutorial_input] There is no mission called %q", arg_5_1)

	local var_5_0

	for k, v in pairs(self._active_tutorial_tooltips) do
		if v.name == arg_5_1 then
			var_5_0 = k

			break
		end
	end

	if not var_5_0 then
		table.remove(self._active_tutorial_tooltips, var_5_0)
	end
end

TutorialInputUI.event_input_changed = function (self)
	-- function 6
	self._input_changed = true
end

TutorialInputUI._create_ui_elements = function (self)
	-- function 7
	self._tutorial_tooltip_animations = {}

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph)
	self._tutorial_tooltip_widget = UIWidget.init(var_0_0.widgets.tutorial_tooltip)

	for i = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		self._tutorial_tooltip_input_widgets[i] = UIWidget.init(var_0_0.tutorial_tooltip_input_widgets[i])
	end

	flag = false
	self._active_tooltip_name = nil
end

TutorialInputUI._button_texture_data_by_input_action = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local _input_manager = self._input_manager
	local is_device_active = _input_manager:is_device_active("gamepad")
	local PLATFORM = PLATFORM

	if not IS_WINDOWS and not is_device_active then
		PLATFORM = "xb1"
	end

	if not arg_8_2 then
		return (ButtonTextureByName(arg_8_2, PLATFORM))
	else
		local get_service = _input_manager:get_service("Player")
		local var_8_4

		if not arg_8_3.input_service_fallback then
			var_8_4 = _input_manager:get_service(arg_8_3.input_service_fallback)
		end

		return UISettings.get_gamepad_input_texture_data(get_service, arg_8_1, is_device_active, var_8_4)
	end
end

TutorialInputUI.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not flag then
		self:_create_ui_elements()
	end

	self:_update_animations(arg_9_1, arg_9_2)
	self:_update_tooltip(arg_9_1, arg_9_2)
	self:_draw(arg_9_1, arg_9_2)
end

TutorialInputUI._update_animations = function (self, arg_10_1, arg_10_2)
	-- function 10
	for k, v in pairs(self._tutorial_tooltip_animations) do
		UIAnimation.update(v, arg_10_1)

		if not UIAnimation.completed(v) then
			self._tutorial_tooltip_animations[k] = nil
		end
	end
end

TutorialInputUI._update_tooltip = function (self, arg_11_1, arg_11_2)
	-- function 11
	local var_11_0 = self._active_tutorial_tooltips[1]

	if not var_11_0 then
		if not self._active_tooltip_name then
			self:hide()
		end

		return
	end

	if not self:_is_in_inn() then
		local _get_profile_and_career_index, var_11_2 = self:_get_profile_and_career_index()

		if not (_get_profile_and_career_index ~= self._current_profile_index or var_11_2 == self._current_career_index) then
			self._current_profile_index = _get_profile_and_career_index
			self._current_career_index = var_11_2

			table.clear(self._active_tutorial_tooltips)

			return
		end
	end

	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local name = var_11_0.name
	local _active_tooltip_name = self._active_tooltip_name
	local style = self._tutorial_tooltip_widget.style
	local content = self._tutorial_tooltip_widget.content
	local text = var_11_0.text

	text = text or "-no text assigned-"

	local var_11_10

	if not var_11_0.sub_text then
		var_11_10 = Localize(var_11_0.sub_text)

		if not var_11_10 then
			-- Nothing
		end
	end

	var_11_10 = ""

	::label_11_0::

	local force_update = var_11_0.force_update
	local num = 0
	local num_2 = 0
	local is_device_active = self._input_manager:is_device_active("gamepad")
	local tooltip_gamepad_inputs

	if is_device_active or not IS_PS4 then
		tooltip_gamepad_inputs = var_11_0.tooltip_gamepad_inputs

		if not tooltip_gamepad_inputs then
			-- Nothing
		end
	end

	tooltip_gamepad_inputs = var_11_0.tooltip_inputs

	::label_11_1::

	if not _active_tooltip_name then
		self:fade_in()
	end

	local _tutorial_tooltip_input_widgets = self._tutorial_tooltip_input_widgets

	if force_update or name ~= _active_tooltip_name or is_device_active ~= content.using_gamepad_input or not self._input_changed then
		content.using_gamepad_input = is_device_active
		content.input_set = true
		content.unassigned = false
		self._input_changed = false
		self._active_tooltip_name = name

		if self._active_tooltip_name ~= name then
			if not tooltip_gamepad_inputs then
				self._tooltip_inputs = table.clone(tooltip_gamepad_inputs)
			else
				self._tooltip_inputs = nil
			end
		end

		local count

		if not tooltip_gamepad_inputs then
			count = #tooltip_gamepad_inputs

			if not count then
				-- Nothing
			end
		end

		count = 0

		::label_11_2::

		content.show_bg = count > 0
		content.description = text
		content.sub_description = var_11_10

		local var_11_18 = content
		local num_3 = 0
		local num_4 = 0

		for i = 1, count do
			local var_11_21 = _tutorial_tooltip_input_widgets[i]
			local content_2 = var_11_21.content
			local style_2 = var_11_21.style
			local var_11_24 = tooltip_gamepad_inputs[i]
			local action = var_11_24.action
			local _button_texture_data_by_input_action, var_11_27, var_11_28, var_11_29 = self:_button_texture_data_by_input_action(action, nil, var_11_0)

			if _button_texture_data_by_input_action or not var_11_0.alt_action_icons then
				_button_texture_data_by_input_action, var_11_27 = self:_button_texture_data_by_input_action(action, var_11_0.alt_action_icons[action], var_11_0)
			end

			local unassigned = var_11_18.unassigned

			unassigned = unassigned or var_11_29
			var_11_18.unassigned = unassigned

			local num_5 = 0
			local num_6 = 0

			if not _button_texture_data_by_input_action then
				num_4 = num_4 + 1

				if not _button_texture_data_by_input_action.texture then
					content_2.button_text = ""
					content_2.icon = {
						_button_texture_data_by_input_action.texture
					}
					style_2.icon.texture_sizes = {
						_button_texture_data_by_input_action.size
					}
					num_5 = _button_texture_data_by_input_action.size[1]
					num_6 = _button_texture_data_by_input_action.size[2]
				else
					if not (not var_11_28 and var_11_27 == "") then
						local var_11_33 = var_11_28[1]
						local flag = not var_11_33 and self._prefixes[var_11_33]

						if not flag then
							var_11_27 = flag .. " " .. var_11_27
						end
					end

					if var_11_27 == "" then
						var_11_27 = Localize("unassigned_keymap")
					else
						var_11_27 = "[" .. var_11_27 .. "]"
					end

					local tbl = {}
					local tbl_2 = {}
					local tbl_3 = {}
					local var_11_38, var_11_39 = UIFontByResolution(style_2.button_text)
					local text_size, var_11_41, var_11_42 = UIRenderer.text_size(_ui_renderer, var_11_27, var_11_38[1], var_11_39)

					for j = 1, #_button_texture_data_by_input_action do
						tbl[j] = _button_texture_data_by_input_action[j].texture
						tbl_2[j] = _button_texture_data_by_input_action[j].size

						if not _button_texture_data_by_input_action[j].tileable then
							tbl_3[j] = {
								text_size,
								tbl_2[j][2]
							}
							num_5 = num_5 + text_size

							if num_6 < tbl_2[j][2] then
								num_6 = tbl_2[j][2] or num_6
							end
						else
							num_5 = num_5 + tbl_2[j][1]
							num_6 = not (num_6 < tbl_2[j][2]) or not tbl_2[j][2] or num_6
						end
					end

					content_2.button_text = var_11_27
					style_2.icon.texture_sizes = tbl_2
					style_2.icon.tile_sizes = tbl_3
					content_2.icon = nil
				end

				_ui_scenegraph["input_description_icon_" .. i].size[1] = num_5
				_ui_scenegraph["input_description_icon_" .. i].size[2] = num_6

				local var_11_43

				if not (not var_11_24.prefix and var_11_24.prefix == "") then
					var_11_43 = Localize(var_11_24.prefix)

					if not var_11_43 then
						-- Nothing
					end
				end

				var_11_43 = ""

				::label_11_3::

				content_2.prefix_text = var_11_43
				content_2.suffix_text = var_11_24.suffix

				local var_11_44, var_11_45 = UIFontByResolution(style_2.prefix_text)
				local var_11_46, var_11_47 = UIFontByResolution(style_2.suffix_text)
				local text_size_2 = UIRenderer.text_size(_ui_renderer, content_2.prefix_text, var_11_44[1], var_11_45)
				local text_size_3 = UIRenderer.text_size(_ui_renderer, content_2.suffix_text, var_11_46[1], var_11_47)
				local num_7 = num_5 + text_size_2 + text_size_3 + 5

				_ui_scenegraph["input_description_icon_" .. i].local_position[1] = text_size_2
				_ui_scenegraph["input_description_" .. i].local_position[1] = num_3
				num_3 = num_3 + num_7
				var_11_21.content.visible = true
			end
		end

		for k = num_4 + 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
			_tutorial_tooltip_input_widgets[k].content.visible = false
		end

		_ui_scenegraph.tutorial_tooltip_input_field.local_position[1] = -(num_3 + 5) * 0.5

		return self._tutorial_tooltip_widget, name
	end
end

TutorialInputUI._draw = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local get_service = self._input_manager:get_service("Player")

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_12_1)
	UIRenderer.draw_widget(_ui_renderer, self._tutorial_tooltip_widget)

	for i = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		UIRenderer.draw_widget(_ui_renderer, self._tutorial_tooltip_input_widgets[i])
	end

	UIRenderer.end_pass(_ui_renderer)
end

TutorialInputUI.hide = function (self)
	-- function 13
	self._active_tooltip_name = nil

	self:fade_out()
end

local num = 0.25

TutorialInputUI.fade_in = function (self)
	-- function 14
	self:_fade(0, 255, num, false)
end

TutorialInputUI.fade_out = function (self)
	-- function 15
	self:_fade(255, 0, num, true)
end

TutorialInputUI._fade = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local style = self._tutorial_tooltip_widget.style
	local background = style.background
	local divider = style.divider
	local description = style.description
	local description_shadow = style.description_shadow
	local sub_description = style.sub_description
	local sub_description_shadow = style.sub_description_shadow
	local completed_texture = style.completed_texture
	local completed_texture_shadow = style.completed_texture_shadow
	local unassigned = style.unassigned
	local unassigned_shadow = style.unassigned_shadow
	local unassigned_background = style.unassigned_background
	local _tutorial_tooltip_animations = self._tutorial_tooltip_animations
	local flag

	flag = not arg_16_4 and 0.5 and 0
	self._tutorial_tooltip_widget.content.completed = arg_16_4

	if not arg_16_4 then
		local num = 0.3

		_tutorial_tooltip_animations.completed_size_x = UIAnimation.init(UIAnimation.function_by_time, completed_texture.texture_size, 1, 1224, 408, num, math.easeInCubic)
		_tutorial_tooltip_animations.completed_size_y = UIAnimation.init(UIAnimation.function_by_time, completed_texture.texture_size, 2, 537, 179, num, math.easeInCubic)
		_tutorial_tooltip_animations.completed_fade_in = UIAnimation.init(UIAnimation.function_by_time, completed_texture.color, 1, 0, 255, arg_16_3, math.easeInCubic)
		_tutorial_tooltip_animations.completed_shadow_fade_in = UIAnimation.init(UIAnimation.function_by_time, completed_texture_shadow.color, 1, 0, 255, arg_16_3, math.easeInCubic)
	end

	_tutorial_tooltip_animations.completed_fade = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, completed_texture.color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	_tutorial_tooltip_animations.completed_shadow_fade = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, completed_texture_shadow.color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	_tutorial_tooltip_animations.unassigned_fade = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, unassigned.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	_tutorial_tooltip_animations.unassigned_shadow_fade = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, unassigned_shadow.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	_tutorial_tooltip_animations.unassigned_background_fade = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, unassigned_background.color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	_tutorial_tooltip_animations.tooltip_bg_fade = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, background.color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	_tutorial_tooltip_animations.tooltip_divider_fade = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, divider.color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	_tutorial_tooltip_animations.tooltip_description_fade = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, description.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	_tutorial_tooltip_animations.tooltip_description_shadow_fade = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, description_shadow.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	_tutorial_tooltip_animations.tooltip_sub_description_fade = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, sub_description.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	_tutorial_tooltip_animations.tooltip_sub_description_shadow_fade = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, sub_description_shadow.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)

	local _tutorial_tooltip_input_widgets = self._tutorial_tooltip_input_widgets

	for i = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		local style_2 = _tutorial_tooltip_input_widgets[i].style
		local prefix_text = style_2.prefix_text
		local prefix_text_shadow = style_2.prefix_text_shadow
		local suffix_text = style_2.suffix_text
		local suffix_text_shadow = style_2.suffix_text_shadow
		local button_text = style_2.button_text
		local button_text_shadow = style_2.button_text_shadow
		local icon = style_2.icon

		_tutorial_tooltip_animations["tooltip_input_prefix_" .. i] = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, prefix_text.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
		_tutorial_tooltip_animations["tooltip_input_prefix_shadow_" .. i] = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, prefix_text_shadow.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
		_tutorial_tooltip_animations["tooltip_input_suffix_" .. i] = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, suffix_text.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
		_tutorial_tooltip_animations["tooltip_input_suffix_shadow_" .. i] = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, suffix_text_shadow.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
		_tutorial_tooltip_animations["tooltip_input_button_" .. i] = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, button_text.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
		_tutorial_tooltip_animations["tooltip_input_button_shadow_" .. i] = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, button_text_shadow.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
		_tutorial_tooltip_animations["tooltip_input_icon_" .. i] = UIAnimation.init(UIAnimation.wait, flag, UIAnimation.function_by_time, icon.color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	end
end

TutorialInputUI.has_completed_fade = function (self)
	-- function 17
	if next(self._tutorial_tooltip_animations) ~= nil then
		return false
	end

	return true
end

TutorialInputUI.set_visible = function (self, arg_18_1)
	-- function 18
	self._is_visible = arg_18_1

	local _ui_renderer = self._ui_renderer

	for i, v in ipairs(self._tutorial_tooltip_input_widgets) do
		UIRenderer.set_element_visible(_ui_renderer, v.element, arg_18_1)
	end

	UIRenderer.set_element_visible(_ui_renderer, self._tutorial_tooltip_widget.element, arg_18_1)
end

TutorialInputUI._get_profile_and_career_index = function (arg_19_0)
	-- function 19
	local local_player = Managers.player:local_player(1)
	local career_index

	if not local_player then
		career_index = local_player:career_index()

		if not career_index then
			-- Nothing
		end
	end

	career_index = 1

	do
		local profile_index
	end

	::label_19_0::

	if not local_player then
		profile_index = local_player:profile_index()

		if not profile_index then
			-- Nothing
		end
	end

	profile_index = 1

	::label_19_1::

	return profile_index, career_index
end

TutorialInputUI._is_in_inn = function (arg_20_0)
	-- function 20
	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()

	return LevelSettings[get_current_level_keys].hub_level
end
