-- chunkname: @scripts/ui/views/tutorial_tooltip_ui.lua

local var_0_0 = local_require("scripts/ui/views/tutorial_tooltip_ui_definitions")

TutorialTooltipUI = class(TutorialTooltipUI)

TutorialTooltipUI.init = function (arg_1_0, arg_1_1)
	arg_1_0.ui_renderer = arg_1_1.ui_renderer
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.platform = PLATFORM
	arg_1_0.tutorial_tooltip_animations = {}
	arg_1_0.tutorial_tooltip_input_widgets = {}

	arg_1_0:create_ui_elements()
end

TutorialTooltipUI.destroy = function (arg_2_0)
	return
end

TutorialTooltipUI.create_ui_elements = function (arg_3_0)
	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph)
	arg_3_0.tutorial_tooltip_widget = UIWidget.init(var_0_0.widgets.tutorial_tooltip)

	for iter_3_0 = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		arg_3_0.tutorial_tooltip_input_widgets[iter_3_0] = UIWidget.init(var_0_0.tutorial_tooltip_input_widgets[iter_3_0])
	end
end

TutorialTooltipUI.button_texture_data_by_input_action = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_0.input_manager
	local var_4_1 = var_4_0:is_device_active("gamepad")
	local var_4_2 = PLATFORM

	if IS_WINDOWS and var_4_1 then
		var_4_2 = "xb1"
	end

	if arg_4_2 then
		return (ButtonTextureByName(arg_4_2, var_4_2))
	else
		local var_4_3 = var_4_0:get_service("Player")

		return UISettings.get_gamepad_input_texture_data(var_4_3, arg_4_1, var_4_1)
	end
end

TutorialTooltipUI.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if next(arg_5_0.tutorial_tooltip_animations) ~= nil then
		arg_5_0:set_dirty()
	end

	for iter_5_0, iter_5_1 in pairs(arg_5_0.tutorial_tooltip_animations) do
		UIAnimation.update(iter_5_1, arg_5_3)

		if UIAnimation.completed(iter_5_1) then
			arg_5_0.tutorial_tooltip_animations[iter_5_0] = nil
		end
	end

	local var_5_0 = arg_5_0.ui_renderer
	local var_5_1 = arg_5_0.ui_scenegraph
	local var_5_2 = arg_5_1.name
	local var_5_3 = TutorialTemplates[var_5_2]
	local var_5_4 = arg_5_0.active_tooltip_name
	local var_5_5 = arg_5_0.tutorial_tooltip_widget.style
	local var_5_6 = arg_5_0.tutorial_tooltip_widget.content
	local var_5_7 = var_5_3.text or "-no text assigned-"
	local var_5_8 = var_5_3.action
	local var_5_9 = var_5_3.force_update
	local var_5_10 = 0
	local var_5_11 = 0
	local var_5_12 = arg_5_0.input_manager:is_device_active("gamepad")
	local var_5_13 = var_5_12 and var_5_3.gamepad_inputs or var_5_3.inputs

	if var_5_13 and #var_5_13 > 0 then
		if not var_5_4 then
			arg_5_0:fade_in()
		end

		local var_5_14 = arg_5_0.tutorial_tooltip_input_widgets

		if var_5_9 or var_5_2 ~= var_5_4 or var_5_12 ~= var_5_6.using_gamepad_input then
			var_5_6.using_gamepad_input = var_5_12
			var_5_6.input_set = true
			arg_5_0.active_tooltip_name = var_5_2
			var_5_6.description = var_5_7

			local var_5_15 = 0
			local var_5_16 = #var_5_13
			local var_5_17 = 0

			for iter_5_2 = 1, var_5_16 do
				local var_5_18 = var_5_14[iter_5_2]
				local var_5_19 = var_5_18.content
				local var_5_20 = var_5_18.style
				local var_5_21 = var_5_13[iter_5_2]
				local var_5_22, var_5_23 = arg_5_0:button_texture_data_by_input_action(var_5_21.action)

				if not var_5_22 and var_5_3.alt_action_icons then
					var_5_22, var_5_23 = arg_5_0:button_texture_data_by_input_action(var_5_21.action, var_5_3.alt_action_icons[var_5_21.action])
				end

				local var_5_24 = 0
				local var_5_25 = 0

				if var_5_22 then
					var_5_17 = var_5_17 + 1

					if var_5_22.texture then
						var_5_19.button_text = ""
						var_5_19.icon = {
							var_5_22.texture
						}
						var_5_20.icon.texture_sizes = {
							var_5_22.size
						}
						var_5_24 = var_5_22.size[1]
						var_5_25 = var_5_22.size[2]
					else
						local var_5_26 = {}
						local var_5_27 = {}
						local var_5_28 = {}
						local var_5_29, var_5_30 = UIFontByResolution(var_5_20.button_text)
						local var_5_31, var_5_32, var_5_33 = UIRenderer.text_size(var_5_0, var_5_23, var_5_29[1], var_5_30)

						for iter_5_3 = 1, #var_5_22 do
							var_5_26[iter_5_3] = var_5_22[iter_5_3].texture
							var_5_27[iter_5_3] = var_5_22[iter_5_3].size

							if var_5_22[iter_5_3].tileable then
								var_5_28[iter_5_3] = {
									var_5_31,
									var_5_27[iter_5_3][2]
								}
								var_5_24 = var_5_24 + var_5_31

								if var_5_25 < var_5_27[iter_5_3][2] then
									var_5_25 = var_5_27[iter_5_3][2] or var_5_25
								end
							else
								var_5_24 = var_5_24 + var_5_27[iter_5_3][1]
								var_5_25 = var_5_25 < var_5_27[iter_5_3][2] and var_5_27[iter_5_3][2] or var_5_25
							end
						end

						var_5_19.icon = var_5_26
						var_5_19.button_text = var_5_23
						var_5_20.icon.texture_sizes = var_5_27
						var_5_20.icon.tile_sizes = var_5_28
					end

					var_5_1["input_description_icon_" .. iter_5_2].size[1] = var_5_24
					var_5_1["input_description_icon_" .. iter_5_2].size[2] = var_5_25
					var_5_19.prefix_text = var_5_21.prefix and var_5_21.prefix ~= "" and Localize(var_5_21.prefix) or ""
					var_5_19.suffix_text = var_5_21.suffix

					local var_5_34, var_5_35 = UIFontByResolution(var_5_20.prefix_text)
					local var_5_36, var_5_37 = UIFontByResolution(var_5_20.suffix_text)
					local var_5_38 = UIRenderer.text_size(var_5_0, var_5_19.prefix_text, var_5_34[1], var_5_35)
					local var_5_39 = UIRenderer.text_size(var_5_0, var_5_19.suffix_text, var_5_36[1], var_5_37)
					local var_5_40 = var_5_24 + var_5_38 + var_5_39 + 5

					var_5_1["input_description_icon_" .. iter_5_2].local_position[1] = var_5_38
					var_5_1["input_description_" .. iter_5_2].local_position[1] = var_5_15
					var_5_15 = var_5_15 + var_5_40
					var_5_18.content.visible = true
					var_5_18.element.dirty = true
				end
			end

			arg_5_0.tutorial_tooltip_widget.element.dirty = true

			for iter_5_4 = var_5_17 + 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
				local var_5_41 = var_5_14[iter_5_4]

				var_5_41.content.visible = false
				var_5_41.element.dirty = true
			end

			var_5_1.tutorial_tooltip_input_field.local_position[1] = (1920 - var_5_15 + 5) * 0.5

			return arg_5_0.tutorial_tooltip_widget, var_5_2
		end
	end
end

TutorialTooltipUI.draw = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.ui_renderer
	local var_6_1 = arg_6_0.ui_scenegraph
	local var_6_2 = arg_6_0.input_manager:get_service("Player")

	UIRenderer.begin_pass(var_6_0, var_6_1, var_6_2, arg_6_1)
	UIRenderer.draw_widget(var_6_0, arg_6_0.tutorial_tooltip_widget)

	for iter_6_0 = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		UIRenderer.draw_widget(var_6_0, arg_6_0.tutorial_tooltip_input_widgets[iter_6_0])
	end

	UIRenderer.end_pass(var_6_0)
end

TutorialTooltipUI.set_dirty = function (arg_7_0)
	arg_7_0.tutorial_tooltip_widget.element.dirty = true

	local var_7_0 = arg_7_0.tutorial_tooltip_input_widgets

	for iter_7_0 = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		var_7_0[iter_7_0].element.dirty = true
	end
end

TutorialTooltipUI.hide = function (arg_8_0)
	local var_8_0 = arg_8_0.ui_renderer

	arg_8_0.active_tooltip_name = nil

	UIRenderer.set_element_visible(var_8_0, arg_8_0.tutorial_tooltip_widget.element, false)

	local var_8_1 = arg_8_0.tutorial_tooltip_input_widgets

	for iter_8_0 = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		local var_8_2 = var_8_1[iter_8_0]

		UIRenderer.set_element_visible(var_8_0, var_8_2.element, false)
	end
end

local var_0_1 = 0.1

TutorialTooltipUI.fade_in = function (arg_9_0)
	arg_9_0:_fade(0, 255, var_0_1)
end

TutorialTooltipUI.fade_out = function (arg_10_0)
	arg_10_0:_fade(255, 0, var_0_1)
end

TutorialTooltipUI._fade = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_0.tutorial_tooltip_widget.style
	local var_11_1 = var_11_0.background
	local var_11_2 = var_11_0.description

	arg_11_0.tutorial_tooltip_animations.tooltip_bg_fade = UIAnimation.init(UIAnimation.function_by_time, var_11_1.color, 1, arg_11_1, arg_11_2, arg_11_3, math.easeInCubic)
	arg_11_0.tutorial_tooltip_animations.tooltip_description_fade = UIAnimation.init(UIAnimation.function_by_time, var_11_2.text_color, 1, arg_11_1, arg_11_2, arg_11_3, math.easeInCubic)

	local var_11_3 = arg_11_0.tutorial_tooltip_input_widgets

	for iter_11_0 = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		local var_11_4 = var_11_3[iter_11_0].style
		local var_11_5 = var_11_4.prefix_text
		local var_11_6 = var_11_4.suffix_text
		local var_11_7 = var_11_4.button_text
		local var_11_8 = var_11_4.icon

		arg_11_0.tutorial_tooltip_animations["tooltip_input_prefix_" .. iter_11_0] = UIAnimation.init(UIAnimation.function_by_time, var_11_5.text_color, 1, arg_11_1, arg_11_2, arg_11_3, math.easeInCubic)
		arg_11_0.tutorial_tooltip_animations["tooltip_input_suffix_" .. iter_11_0] = UIAnimation.init(UIAnimation.function_by_time, var_11_6.text_color, 1, arg_11_1, arg_11_2, arg_11_3, math.easeInCubic)
		arg_11_0.tutorial_tooltip_animations["tooltip_input_button_" .. iter_11_0] = UIAnimation.init(UIAnimation.function_by_time, var_11_7.text_color, 1, arg_11_1, arg_11_2, arg_11_3, math.easeInCubic)
		arg_11_0.tutorial_tooltip_animations["tooltip_input_icon_" .. iter_11_0] = UIAnimation.init(UIAnimation.function_by_time, var_11_8.color, 1, arg_11_1, arg_11_2, arg_11_3, math.easeInCubic)
	end
end

TutorialTooltipUI.has_completed_fade = function (arg_12_0)
	if next(arg_12_0.tutorial_tooltip_animations) ~= nil then
		return false
	end

	return true
end

TutorialTooltipUI.set_visible = function (arg_13_0, arg_13_1)
	arg_13_0._is_visible = arg_13_1

	local var_13_0 = arg_13_0.ui_renderer

	for iter_13_0, iter_13_1 in ipairs(arg_13_0.tutorial_tooltip_input_widgets) do
		UIRenderer.set_element_visible(var_13_0, iter_13_1.element, arg_13_1)
	end

	UIRenderer.set_element_visible(var_13_0, arg_13_0.tutorial_tooltip_widget.element, arg_13_1)
end
