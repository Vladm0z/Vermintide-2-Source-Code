-- chunkname: @scripts/ui/views/menu_input_description_ui.lua

local var_0_0 = {
	screen = {
		vertical_alignment = "center",
		scale = "fit",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.controller_description
		}
	},
	input_description_field = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			1800,
			70
		}
	},
	background = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center"
	},
	fullscreen_background = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			1920,
			79
		},
		position = {
			0,
			0,
			UILayer.default + 1
		}
	}
}

if not IS_WINDOWS then
	var_0_0.screen.scale = "hud_fit"
end

local function var_0_1(arg_1_0, arg_1_1)
	return arg_1_0.priority < arg_1_1.priority
end

local var_0_2 = UIAtlasHelper.get_atlas_settings_by_texture_name("tab_menu_bg_02")

local function var_0_3(arg_2_0)
	return {
		scenegraph_id = "background",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background_id"
				}
			}
		},
		content = {
			background_id = "tab_menu_bg_02"
		},
		style = {
			background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					var_0_2.size[1] * arg_2_0,
					var_0_2.size[2] * 1.2
				}
			}
		}
	}
end

local function var_0_4()
	return UIWidgets.create_simple_uv_texture("menu_panel_bg", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "fullscreen_background", nil, nil, {
		200,
		10,
		10,
		10
	})
end

local function var_0_5(arg_4_0)
	local var_4_0 = {}

	for iter_4_0 = 1, arg_4_0 do
		local var_4_1 = "input_description_root_" .. iter_4_0
		local var_4_2 = "input_description_" .. iter_4_0
		local var_4_3 = "input_description_icon_" .. iter_4_0
		local var_4_4 = "input_description_text_" .. iter_4_0

		var_0_0[var_4_1] = {
			vertical_alignment = "center",
			parent = "input_description_field",
			horizontal_alignment = "left",
			size = {
				1,
				1
			},
			position = {
				0,
				0,
				1
			}
		}
		var_0_0[var_4_2] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = var_4_1,
			size = {
				200,
				40
			},
			position = {
				0,
				0,
				1
			}
		}
		var_0_0[var_4_3] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = var_4_2,
			size = {
				40,
				40
			},
			position = {
				0,
				0,
				1
			}
		}
		var_0_0[var_4_4] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = var_4_3,
			size = {
				500,
				40
			},
			position = {
				40,
				1,
				1
			}
		}

		local var_4_5 = {
			element = {
				passes = {
					{
						style_id = "text",
						pass_type = "text",
						text_id = "text"
					},
					{
						style_id = "text_shadow",
						pass_type = "text",
						text_id = "text"
					},
					{
						pass_type = "texture",
						style_id = "icon",
						texture_id = "icon"
					}
				}
			},
			content = {
				text = "",
				icon = "xbone_button_icon_a"
			},
			style = {
				text = {
					font_size = 24,
					word_wrap = true,
					pixel_perfect = true,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("white", 255),
					offset = {
						0,
						0,
						2
					},
					scenegraph_id = var_4_4
				},
				text_shadow = {
					font_size = 24,
					word_wrap = true,
					pixel_perfect = true,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					dynamic_font = true,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("black", 255),
					offset = {
						2,
						-2,
						1
					},
					scenegraph_id = var_4_4
				},
				icon = {
					scenegraph_id = var_4_3
				}
			},
			scenegraph_id = var_4_2
		}

		var_4_0[#var_4_0 + 1] = UIWidget.init(var_4_5)
	end

	return var_4_0
end

MenuInputDescriptionUI = class(MenuInputDescriptionUI)

function MenuInputDescriptionUI.init(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8)
	arg_5_0:clear_input_descriptions()

	arg_5_0.input_service = arg_5_3
	arg_5_0.ui_renderer = arg_5_2
	arg_5_0.generic_actions = arg_5_6
	arg_5_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_5_0._max_width = arg_5_8 or math.huge
	arg_5_0._use_fullscreen_layout = arg_5_7
	var_0_0.screen.position[3] = arg_5_5 and arg_5_5 + 10 or UILayer.controller_description

	arg_5_0:create_ui_elements(arg_5_2, arg_5_4, arg_5_7)
end

function MenuInputDescriptionUI.create_ui_elements(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0.console_input_description_widgets = var_0_5(arg_6_2 or 5)

	if arg_6_3 then
		arg_6_0.background_widget = nil
	else
		arg_6_0.background_widget = UIWidget.init(var_0_3(arg_6_2 or 3))
	end

	arg_6_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0)

	UIRenderer.clear_scenegraph_queue(arg_6_1)
end

function MenuInputDescriptionUI._verify_input(arg_7_0)
	if Managers.input:get_most_recent_device() ~= arg_7_0._most_recent_device then
		arg_7_0:set_input_description(arg_7_0.current_console_selection_data)
	end
end

function MenuInputDescriptionUI.draw(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:_verify_input()

	local var_8_0 = arg_8_0.ui_scenegraph
	local var_8_1 = arg_8_0.input_service
	local var_8_2 = arg_8_0.ui_renderer

	UIRenderer.begin_pass(var_8_2, var_8_0, var_8_1, arg_8_2, nil, arg_8_0.render_settings)

	local var_8_3 = arg_8_0.number_of_descriptions_in_use
	local var_8_4 = arg_8_0.console_input_description_widgets

	if var_8_3 then
		for iter_8_0 = 1, var_8_3 do
			UIRenderer.draw_widget(var_8_2, var_8_4[iter_8_0])
		end

		if arg_8_0.background_widget then
			UIRenderer.draw_widget(var_8_2, arg_8_0.background_widget)
		end
	end

	UIRenderer.end_pass(var_8_2)
end

function MenuInputDescriptionUI.destroy(arg_9_0)
	return
end

function MenuInputDescriptionUI.change_generic_actions(arg_10_0, arg_10_1)
	arg_10_0.generic_actions = arg_10_1

	arg_10_0:set_input_description(arg_10_0.current_console_selection_data)
end

function MenuInputDescriptionUI.setup_console_widget_selections(arg_11_0)
	local var_11_0 = arg_11_0.steppers

	return {
		{
			name = "difficulty",
			gamepad_support = true,
			widget = var_11_0.difficulty.widget,
			actions = {
				{
					hotspot_id = "left_button_hotspot",
					input_action = "move_left",
					description_text = "input_description_previous"
				},
				{
					hotspot_id = "right_button_hotspot",
					input_action = "move_right",
					description_text = "input_description_next"
				}
			}
		},
		{
			name = "privacy",
			gamepad_support = true,
			widget = var_11_0.privacy.widget,
			actions = {
				{
					hotspot_id = "left_button_hotspot",
					input_action = "move_left",
					description_text = "input_description_previous"
				},
				{
					hotspot_id = "right_button_hotspot",
					input_action = "move_right",
					description_text = "input_description_next"
				}
			}
		},
		{
			name = "level",
			gamepad_support = true,
			widget = var_11_0.level.widget,
			actions = {
				{
					hotspot_id = "left_button_hotspot",
					input_action = "move_left",
					description_text = "input_description_previous"
				},
				{
					hotspot_id = "right_button_hotspot",
					input_action = "move_right",
					description_text = "input_description_next"
				}
			}
		},
		{
			name = "play_button",
			gamepad_support = false,
			widget = arg_11_0.play_button_console_widget,
			actions = {
				{
					hotspot_id = "button_hotspot",
					input_action = "confirm",
					description_text = "input_description_confirm"
				}
			}
		},
		{
			name = "quickmatch_button",
			gamepad_support = false,
			widget = arg_11_0.quickmatch_button_console_widget,
			actions = {
				{
					hotspot_id = "button_hotspot",
					input_action = "confirm",
					description_text = "input_description_confirm"
				}
			}
		}
	}
end

function MenuInputDescriptionUI.set_input_description(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0:clear_input_descriptions()

	local var_12_0 = arg_12_2 or 1
	local var_12_1 = arg_12_0.ui_renderer
	local var_12_2 = arg_12_0.ui_scenegraph
	local var_12_3 = arg_12_0.console_input_description_widgets
	local var_12_4 = 30 * var_12_0
	local var_12_5 = {}
	local var_12_6 = 0
	local var_12_7 = 0

	arg_12_0.current_console_selection_data = arg_12_1

	local var_12_8 = arg_12_1 and arg_12_1.actions and table.clone(arg_12_1.actions) or {}
	local var_12_9 = arg_12_1 and arg_12_1.ignore_generic_actions
	local var_12_10 = {}

	if not var_12_9 then
		local var_12_11 = arg_12_0.generic_actions

		if var_12_11 then
			for iter_12_0, iter_12_1 in ipairs(var_12_11) do
				if not iter_12_1.content_check_function or iter_12_1.content_check_function() then
					var_12_10[#var_12_10 + 1] = iter_12_1
				end
			end
		end
	end

	for iter_12_2, iter_12_3 in pairs(var_12_8) do
		if not iter_12_3.content_check_function or iter_12_3.content_check_function() then
			var_12_10[#var_12_10 + 1] = iter_12_3
		end
	end

	table.sort(var_12_10, var_0_1)

	for iter_12_4, iter_12_5 in pairs(var_12_10) do
		local var_12_12 = iter_12_5.input_action
		local var_12_13 = iter_12_5.description_text
		local var_12_14 = iter_12_5.ignore_keybinding

		if var_12_13 then
			var_12_7 = var_12_7 + 1
			var_12_13 = iter_12_5.ignore_localization and var_12_13 or Localize(var_12_13)

			local var_12_15 = arg_12_0:get_gamepad_input_texture_data(var_12_12, var_12_14)
			local var_12_16 = var_12_3[var_12_7]
			local var_12_17 = var_12_16.content
			local var_12_18 = var_12_16.style
			local var_12_19 = "input_description_" .. var_12_7
			local var_12_20 = "input_description_icon_" .. var_12_7
			local var_12_21 = "input_description_text_" .. var_12_7
			local var_12_22 = table.shallow_copy(var_12_15.size)

			var_12_22[1] = var_12_22[1] * var_12_0
			var_12_22[2] = var_12_22[2] * var_12_0
			var_12_2[var_12_20].size = var_12_22
			var_12_2[var_12_21].local_position[1] = var_12_22[1]
			var_12_17.icon = var_12_15.texture

			local var_12_23 = " " .. var_12_13

			var_12_17.text = var_12_23

			local var_12_24 = var_12_18.text

			var_12_24._original_font_size = var_12_24._original_font_size or var_12_24.font_size
			var_12_24.font_size = var_12_24._original_font_size * var_12_0

			local var_12_25, var_12_26 = UIFontByResolution(var_12_24)
			local var_12_27 = UIRenderer.text_size(var_12_1, var_12_23, var_12_25[1], var_12_26)
			local var_12_28 = var_12_22[1] + var_12_27

			if arg_12_0._use_fullscreen_layout then
				var_12_2[var_12_19].local_position[1] = 0
			else
				var_12_2[var_12_19].local_position[1] = -var_12_28 / 2
			end

			var_12_18.text_shadow.font_size = var_12_24._original_font_size * var_12_0
			var_12_6 = var_12_6 + var_12_28 + var_12_4
			var_12_5[var_12_7] = var_12_28
		end
	end

	if not arg_12_2 and var_12_6 > arg_12_0._max_width then
		return arg_12_0:set_input_description(arg_12_1, arg_12_0._max_width / var_12_6)
	end

	arg_12_0.number_of_descriptions_in_use = var_12_7 ~= 0 and var_12_7 or nil

	arg_12_0:_align_inputs(var_12_6, var_12_4, var_12_5)

	arg_12_0._most_recent_device = Managers.input:get_most_recent_device()
end

function MenuInputDescriptionUI.clear_input_descriptions(arg_13_0)
	arg_13_0.number_of_descriptions_in_use = nil
end

function MenuInputDescriptionUI.get_gamepad_input_texture_data(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = PLATFORM

	if IS_WINDOWS then
		var_14_0 = "xb1"
	end

	if arg_14_2 then
		return ButtonTextureByName(arg_14_1, var_14_0)
	else
		local var_14_1 = arg_14_0.input_service

		return UISettings.get_gamepad_input_texture_data(var_14_1, arg_14_1, true)
	end
end

function MenuInputDescriptionUI._align_inputs(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = arg_15_0.ui_scenegraph

	arg_15_1 = arg_15_1 - arg_15_2

	local var_15_1 = var_15_0.input_description_field.size[1]
	local var_15_2 = arg_15_0.number_of_descriptions_in_use

	if var_15_2 then
		if arg_15_0._use_fullscreen_layout then
			local var_15_3 = 50
			local var_15_4 = math.min(arg_15_0._max_width, var_15_1)
			local var_15_5 = math.clamp(var_15_4 - (arg_15_1 + var_15_3 * 2), 0, var_15_3)

			for iter_15_0 = 1, var_15_2 do
				local var_15_6 = arg_15_3[iter_15_0]

				var_15_0["input_description_root_" .. iter_15_0].local_position[1] = var_15_5
				var_15_5 = var_15_5 + var_15_6 + arg_15_2
			end
		else
			local var_15_7 = var_15_1 / 2 - arg_15_1 / 2

			for iter_15_1 = 1, var_15_2 do
				local var_15_8 = arg_15_3[iter_15_1]
				local var_15_9 = var_15_7 + var_15_8 / 2

				var_15_0["input_description_root_" .. iter_15_1].local_position[1] = var_15_9
				var_15_7 = var_15_9 + var_15_8 / 2 + arg_15_2
			end
		end
	end
end
