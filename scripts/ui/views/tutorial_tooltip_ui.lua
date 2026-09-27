-- chunkname: @scripts/ui/views/tutorial_tooltip_ui.lua

local var_0_0 = local_require("scripts/ui/views/tutorial_tooltip_ui_definitions")

TutorialTooltipUI = class(TutorialTooltipUI)

TutorialTooltipUI.init = function (self, arg_1_1)
	-- function 1
	self.ui_renderer = arg_1_1.ui_renderer
	self.input_manager = arg_1_1.input_manager
	self.platform = PLATFORM
	self.tutorial_tooltip_animations = {}
	self.tutorial_tooltip_input_widgets = {}

	self:create_ui_elements()
end

TutorialTooltipUI.destroy = function (arg_2_0)
	-- function 2
	return
end

TutorialTooltipUI.create_ui_elements = function (self)
	-- function 3
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph)
	self.tutorial_tooltip_widget = UIWidget.init(var_0_0.widgets.tutorial_tooltip)

	for i = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		self.tutorial_tooltip_input_widgets[i] = UIWidget.init(var_0_0.tutorial_tooltip_input_widgets[i])
	end
end

TutorialTooltipUI.button_texture_data_by_input_action = function (self, arg_4_1, arg_4_2)
	-- function 4
	local input_manager = self.input_manager
	local is_device_active = input_manager:is_device_active("gamepad")
	local PLATFORM = PLATFORM

	if not IS_WINDOWS and not is_device_active then
		PLATFORM = "xb1"
	end

	if not arg_4_2 then
		return (ButtonTextureByName(arg_4_2, PLATFORM))
	else
		local get_service = input_manager:get_service("Player")

		return UISettings.get_gamepad_input_texture_data(get_service, arg_4_1, is_device_active)
	end
end

TutorialTooltipUI.update = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	if next(self.tutorial_tooltip_animations) ~= nil then
		self:set_dirty()
	end

	for k, v in pairs(self.tutorial_tooltip_animations) do
		UIAnimation.update(v, arg_5_3)

		if not UIAnimation.completed(v) then
			self.tutorial_tooltip_animations[k] = nil
		end
	end

	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local name = arg_5_1.name
	local var_5_3 = TutorialTemplates[name]
	local active_tooltip_name = self.active_tooltip_name
	local style = self.tutorial_tooltip_widget.style
	local content = self.tutorial_tooltip_widget.content
	local text = var_5_3.text

	text = text or "-no text assigned-"

	local action = var_5_3.action
	local force_update = var_5_3.force_update
	local num = 0
	local num_2 = 0
	local is_device_active = self.input_manager:is_device_active("gamepad")
	local gamepad_inputs

	if not is_device_active then
		gamepad_inputs = var_5_3.gamepad_inputs

		if not gamepad_inputs then
			-- Nothing
		end
	end

	gamepad_inputs = var_5_3.inputs

	::label_5_0::

	if not (not gamepad_inputs and not (#gamepad_inputs > 0)) then
		if not active_tooltip_name then
			self:fade_in()
		end

		local tutorial_tooltip_input_widgets = self.tutorial_tooltip_input_widgets

		if not (force_update or name ~= active_tooltip_name or is_device_active == content.using_gamepad_input) then
			content.using_gamepad_input = is_device_active
			content.input_set = true
			self.active_tooltip_name = name
			content.description = text

			local num_3 = 0
			local count = #gamepad_inputs
			local num_4 = 0

			for k_2 = 1, count do
				local var_5_18 = tutorial_tooltip_input_widgets[k_2]
				local content_2 = var_5_18.content
				local style_2 = var_5_18.style
				local var_5_21 = gamepad_inputs[k_2]
				local button_texture_data_by_input_action, var_5_23 = self:button_texture_data_by_input_action(var_5_21.action)

				if button_texture_data_by_input_action or not var_5_3.alt_action_icons then
					button_texture_data_by_input_action, var_5_23 = self:button_texture_data_by_input_action(var_5_21.action, var_5_3.alt_action_icons[var_5_21.action])
				end

				local num_5 = 0
				local num_6 = 0

				if not button_texture_data_by_input_action then
					num_4 = num_4 + 1

					if not button_texture_data_by_input_action.texture then
						content_2.button_text = ""
						content_2.icon = {
							button_texture_data_by_input_action.texture
						}
						style_2.icon.texture_sizes = {
							button_texture_data_by_input_action.size
						}
						num_5 = button_texture_data_by_input_action.size[1]
						num_6 = button_texture_data_by_input_action.size[2]
					else
						local tbl = {}
						local tbl_2 = {}
						local tbl_3 = {}
						local var_5_29, var_5_30 = UIFontByResolution(style_2.button_text)
						local text_size, var_5_32, var_5_33 = UIRenderer.text_size(ui_renderer, var_5_23, var_5_29[1], var_5_30)

						for l = 1, #button_texture_data_by_input_action do
							tbl[l] = button_texture_data_by_input_action[l].texture
							tbl_2[l] = button_texture_data_by_input_action[l].size

							if not button_texture_data_by_input_action[l].tileable then
								tbl_3[l] = {
									text_size,
									tbl_2[l][2]
								}
								num_5 = num_5 + text_size

								if num_6 < tbl_2[l][2] then
									num_6 = tbl_2[l][2] or num_6
								end
							else
								num_5 = num_5 + tbl_2[l][1]
								num_6 = not (num_6 < tbl_2[l][2]) or not tbl_2[l][2] or num_6
							end
						end

						content_2.icon = tbl
						content_2.button_text = var_5_23
						style_2.icon.texture_sizes = tbl_2
						style_2.icon.tile_sizes = tbl_3
					end

					ui_scenegraph["input_description_icon_" .. k_2].size[1] = num_5
					ui_scenegraph["input_description_icon_" .. k_2].size[2] = num_6

					local var_5_34

					if not (not var_5_21.prefix and var_5_21.prefix == "") then
						var_5_34 = Localize(var_5_21.prefix)

						if not var_5_34 then
							-- Nothing
						end
					end

					var_5_34 = ""

					::label_5_1::

					content_2.prefix_text = var_5_34
					content_2.suffix_text = var_5_21.suffix

					local var_5_35, var_5_36 = UIFontByResolution(style_2.prefix_text)
					local var_5_37, var_5_38 = UIFontByResolution(style_2.suffix_text)
					local text_size_2 = UIRenderer.text_size(ui_renderer, content_2.prefix_text, var_5_35[1], var_5_36)
					local text_size_3 = UIRenderer.text_size(ui_renderer, content_2.suffix_text, var_5_37[1], var_5_38)
					local num_7 = num_5 + text_size_2 + text_size_3 + 5

					ui_scenegraph["input_description_icon_" .. k_2].local_position[1] = text_size_2
					ui_scenegraph["input_description_" .. k_2].local_position[1] = num_3
					num_3 = num_3 + num_7
					var_5_18.content.visible = true
					var_5_18.element.dirty = true
				end
			end

			self.tutorial_tooltip_widget.element.dirty = true

			for i4 = num_4 + 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
				local var_5_42 = tutorial_tooltip_input_widgets[i4]

				var_5_42.content.visible = false
				var_5_42.element.dirty = true
			end

			ui_scenegraph.tutorial_tooltip_input_field.local_position[1] = (1920 - num_3 + 5) * 0.5

			return self.tutorial_tooltip_widget, name
		end
	end
end

TutorialTooltipUI.draw = function (self, arg_6_1, arg_6_2)
	-- function 6
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("Player")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_6_1)
	UIRenderer.draw_widget(ui_renderer, self.tutorial_tooltip_widget)

	for i = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		UIRenderer.draw_widget(ui_renderer, self.tutorial_tooltip_input_widgets[i])
	end

	UIRenderer.end_pass(ui_renderer)
end

TutorialTooltipUI.set_dirty = function (self)
	-- function 7
	self.tutorial_tooltip_widget.element.dirty = true

	local tutorial_tooltip_input_widgets = self.tutorial_tooltip_input_widgets

	for i = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		tutorial_tooltip_input_widgets[i].element.dirty = true
	end
end

TutorialTooltipUI.hide = function (self)
	-- function 8
	local ui_renderer = self.ui_renderer

	self.active_tooltip_name = nil

	UIRenderer.set_element_visible(ui_renderer, self.tutorial_tooltip_widget.element, false)

	local tutorial_tooltip_input_widgets = self.tutorial_tooltip_input_widgets

	for i = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		local var_8_2 = tutorial_tooltip_input_widgets[i]

		UIRenderer.set_element_visible(ui_renderer, var_8_2.element, false)
	end
end

local num = 0.1

TutorialTooltipUI.fade_in = function (self)
	-- function 9
	self:_fade(0, 255, num)
end

TutorialTooltipUI.fade_out = function (self)
	-- function 10
	self:_fade(255, 0, num)
end

TutorialTooltipUI._fade = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local style = self.tutorial_tooltip_widget.style
	local background = style.background
	local description = style.description

	self.tutorial_tooltip_animations.tooltip_bg_fade = UIAnimation.init(UIAnimation.function_by_time, background.color, 1, arg_11_1, arg_11_2, arg_11_3, math.easeInCubic)
	self.tutorial_tooltip_animations.tooltip_description_fade = UIAnimation.init(UIAnimation.function_by_time, description.text_color, 1, arg_11_1, arg_11_2, arg_11_3, math.easeInCubic)

	local tutorial_tooltip_input_widgets = self.tutorial_tooltip_input_widgets

	for i = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		local style_2 = tutorial_tooltip_input_widgets[i].style
		local prefix_text = style_2.prefix_text
		local suffix_text = style_2.suffix_text
		local button_text = style_2.button_text
		local icon = style_2.icon

		self.tutorial_tooltip_animations["tooltip_input_prefix_" .. i] = UIAnimation.init(UIAnimation.function_by_time, prefix_text.text_color, 1, arg_11_1, arg_11_2, arg_11_3, math.easeInCubic)
		self.tutorial_tooltip_animations["tooltip_input_suffix_" .. i] = UIAnimation.init(UIAnimation.function_by_time, suffix_text.text_color, 1, arg_11_1, arg_11_2, arg_11_3, math.easeInCubic)
		self.tutorial_tooltip_animations["tooltip_input_button_" .. i] = UIAnimation.init(UIAnimation.function_by_time, button_text.text_color, 1, arg_11_1, arg_11_2, arg_11_3, math.easeInCubic)
		self.tutorial_tooltip_animations["tooltip_input_icon_" .. i] = UIAnimation.init(UIAnimation.function_by_time, icon.color, 1, arg_11_1, arg_11_2, arg_11_3, math.easeInCubic)
	end
end

TutorialTooltipUI.has_completed_fade = function (self)
	-- function 12
	if next(self.tutorial_tooltip_animations) ~= nil then
		return false
	end

	return true
end

TutorialTooltipUI.set_visible = function (self, arg_13_1)
	-- function 13
	self._is_visible = arg_13_1

	local ui_renderer = self.ui_renderer

	for i, v in ipairs(self.tutorial_tooltip_input_widgets) do
		UIRenderer.set_element_visible(ui_renderer, v.element, arg_13_1)
	end

	UIRenderer.set_element_visible(ui_renderer, self.tutorial_tooltip_widget.element, arg_13_1)
end
