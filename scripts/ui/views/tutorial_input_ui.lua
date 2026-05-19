-- chunkname: @scripts/ui/views/tutorial_input_ui.lua

local var_0_0 = local_require("scripts/ui/views/tutorial_input_ui_definitions")
local var_0_1 = true

TutorialInputUI = class(TutorialInputUI)

function TutorialInputUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._platform = PLATFORM
	arg_1_0._ingame_ui_context = arg_1_2
	arg_1_0._tutorial_tooltip_animations = {}
	arg_1_0._tutorial_tooltip_input_widgets = {}
	arg_1_0._active_tutorial_tooltips = {}
	arg_1_0._current_profile_index = nil
	arg_1_0._current_career_index = nil
	arg_1_0._prefixes = {
		mouse = "mouse"
	}

	arg_1_0:_create_ui_elements()
	Managers.state.event:register(arg_1_0, "event_add_tutorial_input", "event_add_tutorial_input")
	Managers.state.event:register(arg_1_0, "event_update_tutorial_input", "event_update_tutorial_input")
	Managers.state.event:register(arg_1_0, "event_remove_tutorial_input", "event_remove_tutorial_input")
	Managers.state.event:register(arg_1_0, "input_changed", "event_input_changed")
end

function TutorialInputUI.destroy(arg_2_0)
	if Managers.state.event then
		Managers.state.event:unregister("event_add_tutorial_input", arg_2_0)
		Managers.state.event:unregister("event_update_tutorial_input", arg_2_0)
		Managers.state.event:unregister("event_remove_tutorial_input", arg_2_0)
		Managers.state.event:unregister("input_changed", arg_2_0)
	end
end

function TutorialInputUI.event_add_tutorial_input(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = Missions[arg_3_1]

	fassert(var_3_0, "[TutorialInputUI:event_add_tutorial_input] There is no mission called %q", arg_3_1)

	arg_3_0._active_tutorial_tooltips[#arg_3_0._active_tutorial_tooltips + 1] = var_3_0
	arg_3_0._current_profile_index, arg_3_0._current_career_index = arg_3_0:_get_profile_and_career_index()

	if arg_3_2 then
		Unit.flow_event(arg_3_2, "lua_mission_started")
	end
end

function TutorialInputUI.event_update_tutorial_input(arg_4_0, arg_4_1)
	return
end

function TutorialInputUI.event_remove_tutorial_input(arg_5_0, arg_5_1)
	fassert(Missions[arg_5_1], "[TutorialInputUI:event_remove_tutorial_input] There is no mission called %q", arg_5_1)

	local var_5_0

	for iter_5_0, iter_5_1 in pairs(arg_5_0._active_tutorial_tooltips) do
		if iter_5_1.name == arg_5_1 then
			var_5_0 = iter_5_0

			break
		end
	end

	if var_5_0 then
		table.remove(arg_5_0._active_tutorial_tooltips, var_5_0)
	end
end

function TutorialInputUI.event_input_changed(arg_6_0)
	arg_6_0._input_changed = true
end

function TutorialInputUI._create_ui_elements(arg_7_0)
	arg_7_0._tutorial_tooltip_animations = {}

	UIRenderer.clear_scenegraph_queue(arg_7_0._ui_renderer)

	arg_7_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph)
	arg_7_0._tutorial_tooltip_widget = UIWidget.init(var_0_0.widgets.tutorial_tooltip)

	for iter_7_0 = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		arg_7_0._tutorial_tooltip_input_widgets[iter_7_0] = UIWidget.init(var_0_0.tutorial_tooltip_input_widgets[iter_7_0])
	end

	var_0_1 = false
	arg_7_0._active_tooltip_name = nil
end

function TutorialInputUI._button_texture_data_by_input_action(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0._input_manager
	local var_8_1 = var_8_0:is_device_active("gamepad")
	local var_8_2 = PLATFORM

	if IS_WINDOWS and var_8_1 then
		var_8_2 = "xb1"
	end

	if arg_8_2 then
		return (ButtonTextureByName(arg_8_2, var_8_2))
	else
		local var_8_3 = var_8_0:get_service("Player")
		local var_8_4

		if arg_8_3.input_service_fallback then
			var_8_4 = var_8_0:get_service(arg_8_3.input_service_fallback)
		end

		return UISettings.get_gamepad_input_texture_data(var_8_3, arg_8_1, var_8_1, var_8_4)
	end
end

function TutorialInputUI.update(arg_9_0, arg_9_1, arg_9_2)
	if var_0_1 then
		arg_9_0:_create_ui_elements()
	end

	arg_9_0:_update_animations(arg_9_1, arg_9_2)
	arg_9_0:_update_tooltip(arg_9_1, arg_9_2)
	arg_9_0:_draw(arg_9_1, arg_9_2)
end

function TutorialInputUI._update_animations(arg_10_0, arg_10_1, arg_10_2)
	for iter_10_0, iter_10_1 in pairs(arg_10_0._tutorial_tooltip_animations) do
		UIAnimation.update(iter_10_1, arg_10_1)

		if UIAnimation.completed(iter_10_1) then
			arg_10_0._tutorial_tooltip_animations[iter_10_0] = nil
		end
	end
end

function TutorialInputUI._update_tooltip(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._active_tutorial_tooltips[1]

	if not var_11_0 then
		if arg_11_0._active_tooltip_name then
			arg_11_0:hide()
		end

		return
	end

	if arg_11_0:_is_in_inn() then
		local var_11_1, var_11_2 = arg_11_0:_get_profile_and_career_index()

		if var_11_1 ~= arg_11_0._current_profile_index or var_11_2 ~= arg_11_0._current_career_index then
			arg_11_0._current_profile_index = var_11_1
			arg_11_0._current_career_index = var_11_2

			table.clear(arg_11_0._active_tutorial_tooltips)

			return
		end
	end

	local var_11_3 = arg_11_0._ui_renderer
	local var_11_4 = arg_11_0._ui_scenegraph
	local var_11_5 = var_11_0.name
	local var_11_6 = arg_11_0._active_tooltip_name
	local var_11_7 = arg_11_0._tutorial_tooltip_widget.style
	local var_11_8 = arg_11_0._tutorial_tooltip_widget.content
	local var_11_9 = var_11_0.text or "-no text assigned-"
	local var_11_10 = var_11_0.sub_text and Localize(var_11_0.sub_text) or ""
	local var_11_11 = var_11_0.force_update
	local var_11_12 = 0
	local var_11_13 = 0
	local var_11_14 = arg_11_0._input_manager:is_device_active("gamepad")
	local var_11_15 = (var_11_14 or IS_PS4) and var_11_0.tooltip_gamepad_inputs or var_11_0.tooltip_inputs

	if not var_11_6 then
		arg_11_0:fade_in()
	end

	local var_11_16 = arg_11_0._tutorial_tooltip_input_widgets

	if var_11_11 or var_11_5 ~= var_11_6 or var_11_14 ~= var_11_8.using_gamepad_input or arg_11_0._input_changed then
		var_11_8.using_gamepad_input = var_11_14
		var_11_8.input_set = true
		var_11_8.unassigned = false
		arg_11_0._input_changed = false
		arg_11_0._active_tooltip_name = var_11_5

		if arg_11_0._active_tooltip_name ~= var_11_5 then
			if var_11_15 then
				arg_11_0._tooltip_inputs = table.clone(var_11_15)
			else
				arg_11_0._tooltip_inputs = nil
			end
		end

		local var_11_17 = var_11_15 and #var_11_15 or 0

		var_11_8.show_bg = var_11_17 > 0
		var_11_8.description = var_11_9
		var_11_8.sub_description = var_11_10

		local var_11_18 = var_11_8
		local var_11_19 = 0
		local var_11_20 = 0

		for iter_11_0 = 1, var_11_17 do
			local var_11_21 = var_11_16[iter_11_0]
			local var_11_22 = var_11_21.content
			local var_11_23 = var_11_21.style
			local var_11_24 = var_11_15[iter_11_0]
			local var_11_25 = var_11_24.action
			local var_11_26, var_11_27, var_11_28, var_11_29 = arg_11_0:_button_texture_data_by_input_action(var_11_25, nil, var_11_0)

			if not var_11_26 and var_11_0.alt_action_icons then
				var_11_26, var_11_27 = arg_11_0:_button_texture_data_by_input_action(var_11_25, var_11_0.alt_action_icons[var_11_25], var_11_0)
			end

			var_11_18.unassigned = var_11_18.unassigned or var_11_29

			local var_11_30 = 0
			local var_11_31 = 0

			if var_11_26 then
				var_11_20 = var_11_20 + 1

				if var_11_26.texture then
					var_11_22.button_text = ""
					var_11_22.icon = {
						var_11_26.texture
					}
					var_11_23.icon.texture_sizes = {
						var_11_26.size
					}
					var_11_30 = var_11_26.size[1]
					var_11_31 = var_11_26.size[2]
				else
					if var_11_28 and var_11_27 ~= "" then
						local var_11_32 = var_11_28[1]
						local var_11_33 = var_11_32 and arg_11_0._prefixes[var_11_32]

						if var_11_33 then
							var_11_27 = var_11_33 .. " " .. var_11_27
						end
					end

					if var_11_27 == "" then
						var_11_27 = Localize("unassigned_keymap")
					else
						var_11_27 = "[" .. var_11_27 .. "]"
					end

					local var_11_34 = {}
					local var_11_35 = {}
					local var_11_36 = {}
					local var_11_37, var_11_38 = UIFontByResolution(var_11_23.button_text)
					local var_11_39, var_11_40, var_11_41 = UIRenderer.text_size(var_11_3, var_11_27, var_11_37[1], var_11_38)

					for iter_11_1 = 1, #var_11_26 do
						var_11_34[iter_11_1] = var_11_26[iter_11_1].texture
						var_11_35[iter_11_1] = var_11_26[iter_11_1].size

						if var_11_26[iter_11_1].tileable then
							var_11_36[iter_11_1] = {
								var_11_39,
								var_11_35[iter_11_1][2]
							}
							var_11_30 = var_11_30 + var_11_39

							if var_11_31 < var_11_35[iter_11_1][2] then
								var_11_31 = var_11_35[iter_11_1][2] or var_11_31
							end
						else
							var_11_30 = var_11_30 + var_11_35[iter_11_1][1]
							var_11_31 = var_11_31 < var_11_35[iter_11_1][2] and var_11_35[iter_11_1][2] or var_11_31
						end
					end

					var_11_22.button_text = var_11_27
					var_11_23.icon.texture_sizes = var_11_35
					var_11_23.icon.tile_sizes = var_11_36
					var_11_22.icon = nil
				end

				var_11_4["input_description_icon_" .. iter_11_0].size[1] = var_11_30
				var_11_4["input_description_icon_" .. iter_11_0].size[2] = var_11_31
				var_11_22.prefix_text = var_11_24.prefix and var_11_24.prefix ~= "" and Localize(var_11_24.prefix) or ""
				var_11_22.suffix_text = var_11_24.suffix

				local var_11_42, var_11_43 = UIFontByResolution(var_11_23.prefix_text)
				local var_11_44, var_11_45 = UIFontByResolution(var_11_23.suffix_text)
				local var_11_46 = UIRenderer.text_size(var_11_3, var_11_22.prefix_text, var_11_42[1], var_11_43)
				local var_11_47 = UIRenderer.text_size(var_11_3, var_11_22.suffix_text, var_11_44[1], var_11_45)
				local var_11_48 = var_11_30 + var_11_46 + var_11_47 + 5

				var_11_4["input_description_icon_" .. iter_11_0].local_position[1] = var_11_46
				var_11_4["input_description_" .. iter_11_0].local_position[1] = var_11_19
				var_11_19 = var_11_19 + var_11_48
				var_11_21.content.visible = true
			end
		end

		for iter_11_2 = var_11_20 + 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
			var_11_16[iter_11_2].content.visible = false
		end

		var_11_4.tutorial_tooltip_input_field.local_position[1] = -(var_11_19 + 5) * 0.5

		return arg_11_0._tutorial_tooltip_widget, var_11_5
	end
end

function TutorialInputUI._draw(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._ui_renderer
	local var_12_1 = arg_12_0._ui_scenegraph
	local var_12_2 = arg_12_0._input_manager:get_service("Player")

	UIRenderer.begin_pass(var_12_0, var_12_1, var_12_2, arg_12_1)
	UIRenderer.draw_widget(var_12_0, arg_12_0._tutorial_tooltip_widget)

	for iter_12_0 = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		UIRenderer.draw_widget(var_12_0, arg_12_0._tutorial_tooltip_input_widgets[iter_12_0])
	end

	UIRenderer.end_pass(var_12_0)
end

function TutorialInputUI.hide(arg_13_0)
	arg_13_0._active_tooltip_name = nil

	arg_13_0:fade_out()
end

local var_0_2 = 0.25

function TutorialInputUI.fade_in(arg_14_0)
	arg_14_0:_fade(0, 255, var_0_2, false)
end

function TutorialInputUI.fade_out(arg_15_0)
	arg_15_0:_fade(255, 0, var_0_2, true)
end

function TutorialInputUI._fade(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = arg_16_0._tutorial_tooltip_widget.style
	local var_16_1 = var_16_0.background
	local var_16_2 = var_16_0.divider
	local var_16_3 = var_16_0.description
	local var_16_4 = var_16_0.description_shadow
	local var_16_5 = var_16_0.sub_description
	local var_16_6 = var_16_0.sub_description_shadow
	local var_16_7 = var_16_0.completed_texture
	local var_16_8 = var_16_0.completed_texture_shadow
	local var_16_9 = var_16_0.unassigned
	local var_16_10 = var_16_0.unassigned_shadow
	local var_16_11 = var_16_0.unassigned_background
	local var_16_12 = arg_16_0._tutorial_tooltip_animations
	local var_16_13 = arg_16_4 and 0.5 or 0

	arg_16_0._tutorial_tooltip_widget.content.completed = arg_16_4

	if arg_16_4 then
		local var_16_14 = 0.3

		var_16_12.completed_size_x = UIAnimation.init(UIAnimation.function_by_time, var_16_7.texture_size, 1, 1224, 408, var_16_14, math.easeInCubic)
		var_16_12.completed_size_y = UIAnimation.init(UIAnimation.function_by_time, var_16_7.texture_size, 2, 537, 179, var_16_14, math.easeInCubic)
		var_16_12.completed_fade_in = UIAnimation.init(UIAnimation.function_by_time, var_16_7.color, 1, 0, 255, arg_16_3, math.easeInCubic)
		var_16_12.completed_shadow_fade_in = UIAnimation.init(UIAnimation.function_by_time, var_16_8.color, 1, 0, 255, arg_16_3, math.easeInCubic)
	end

	var_16_12.completed_fade = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_7.color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	var_16_12.completed_shadow_fade = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_8.color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	var_16_12.unassigned_fade = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_9.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	var_16_12.unassigned_shadow_fade = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_10.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	var_16_12.unassigned_background_fade = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_11.color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	var_16_12.tooltip_bg_fade = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_1.color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	var_16_12.tooltip_divider_fade = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_2.color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	var_16_12.tooltip_description_fade = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_3.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	var_16_12.tooltip_description_shadow_fade = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_4.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	var_16_12.tooltip_sub_description_fade = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_5.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	var_16_12.tooltip_sub_description_shadow_fade = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_6.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)

	local var_16_15 = arg_16_0._tutorial_tooltip_input_widgets

	for iter_16_0 = 1, var_0_0.NUMBER_OF_TOOLTIP_INPUT_WIDGETS do
		local var_16_16 = var_16_15[iter_16_0].style
		local var_16_17 = var_16_16.prefix_text
		local var_16_18 = var_16_16.prefix_text_shadow
		local var_16_19 = var_16_16.suffix_text
		local var_16_20 = var_16_16.suffix_text_shadow
		local var_16_21 = var_16_16.button_text
		local var_16_22 = var_16_16.button_text_shadow
		local var_16_23 = var_16_16.icon

		var_16_12["tooltip_input_prefix_" .. iter_16_0] = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_17.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
		var_16_12["tooltip_input_prefix_shadow_" .. iter_16_0] = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_18.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
		var_16_12["tooltip_input_suffix_" .. iter_16_0] = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_19.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
		var_16_12["tooltip_input_suffix_shadow_" .. iter_16_0] = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_20.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
		var_16_12["tooltip_input_button_" .. iter_16_0] = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_21.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
		var_16_12["tooltip_input_button_shadow_" .. iter_16_0] = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_22.text_color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
		var_16_12["tooltip_input_icon_" .. iter_16_0] = UIAnimation.init(UIAnimation.wait, var_16_13, UIAnimation.function_by_time, var_16_23.color, 1, arg_16_1, arg_16_2, arg_16_3, math.easeInCubic)
	end
end

function TutorialInputUI.has_completed_fade(arg_17_0)
	if next(arg_17_0._tutorial_tooltip_animations) ~= nil then
		return false
	end

	return true
end

function TutorialInputUI.set_visible(arg_18_0, arg_18_1)
	arg_18_0._is_visible = arg_18_1

	local var_18_0 = arg_18_0._ui_renderer

	for iter_18_0, iter_18_1 in ipairs(arg_18_0._tutorial_tooltip_input_widgets) do
		UIRenderer.set_element_visible(var_18_0, iter_18_1.element, arg_18_1)
	end

	UIRenderer.set_element_visible(var_18_0, arg_18_0._tutorial_tooltip_widget.element, arg_18_1)
end

function TutorialInputUI._get_profile_and_career_index(arg_19_0)
	local var_19_0 = Managers.player:local_player(1)
	local var_19_1 = var_19_0 and var_19_0:career_index() or 1

	return var_19_0 and var_19_0:profile_index() or 1, var_19_1
end

function TutorialInputUI._is_in_inn(arg_20_0)
	local var_20_0 = Managers.level_transition_handler:get_current_level_keys()

	return LevelSettings[var_20_0].hub_level
end
