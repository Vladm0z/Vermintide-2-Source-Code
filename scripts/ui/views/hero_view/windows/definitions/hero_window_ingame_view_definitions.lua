-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_ingame_view_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = UIFrameSettings[var_0_2].texture_sizes.vertical[1]
local var_0_5 = UIFrameSettings[var_0_2].texture_sizes.horizontal[2]
local var_0_6 = {
	var_0_3[1] - var_0_4 * 2,
	(var_0_3[2] - var_0_5 * 2) / 3.5
}
local var_0_7 = UISettings.console_menu_scenegraphs
local var_0_8 = {
	screen = var_0_7.screen,
	area = var_0_7.area,
	area_left = var_0_7.area_left,
	area_right = var_0_7.area_right,
	area_divider = var_0_7.area_divider,
	top_banner = {
		vertical_alignment = "bottom",
		parent = "divider",
		horizontal_alignment = "center",
		size = {
			600,
			180
		},
		position = {
			0,
			40,
			2
		}
	},
	description_text = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			600,
			180
		},
		position = {
			0,
			-220,
			2
		}
	},
	divider = {
		vertical_alignment = "bottom",
		parent = "description_text",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-40,
			1
		}
	},
	divider_bottom = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-20,
			1
		}
	},
	background = {
		vertical_alignment = "top",
		parent = "divider",
		horizontal_alignment = "center",
		size = {
			574,
			90
		},
		position = {
			0,
			-12,
			-1
		}
	},
	title_entry = {
		vertical_alignment = "top",
		parent = "divider",
		horizontal_alignment = "center",
		size = {
			800,
			50
		},
		position = {
			0,
			-20,
			1
		}
	},
	logo = {
		vertical_alignment = "bottom",
		parent = "divider",
		horizontal_alignment = "center",
		size = {
			390,
			197
		},
		position = {
			0,
			80,
			1
		}
	}
}
local var_0_9 = {
	default = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	}
}

local function var_0_10(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = {
		2,
		-2,
		3
	}

	if arg_1_3 then
		var_1_0[1] = var_1_0[1] + arg_1_3[1]
		var_1_0[2] = var_1_0[2] + arg_1_3[2]
		var_1_0[3] = arg_1_3[3] - 1
	end

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_field"
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (arg_2_0)
						return not arg_2_0.button_hotspot.disable_button and (arg_2_0.button_hotspot.is_hover or arg_2_0.button_hotspot.is_selected)
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (arg_3_0)
						return not arg_3_0.button_hotspot.disable_button and not arg_3_0.button_hotspot.is_hover and not arg_3_0.button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (arg_4_0)
						return arg_4_0.button_hotspot.disable_button
					end
				}
			}
		},
		content = {
			button_hotspot = {},
			text_field = arg_1_1,
			default_font_size = arg_1_2
		},
		style = {
			text = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_1_2,
				horizontal_alignment = arg_1_4 or "left",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = arg_1_3 or {
					0,
					0,
					4
				}
			},
			text_shadow = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_1_2,
				horizontal_alignment = arg_1_4 or "left",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = var_1_0
			},
			text_hover = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_1_2,
				horizontal_alignment = arg_1_4 or "left",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = arg_1_3 or {
					0,
					0,
					4
				}
			},
			text_disabled = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_1_2,
				horizontal_alignment = arg_1_4 or "left",
				text_color = Colors.get_color_table_with_alpha("gray", 50),
				offset = arg_1_3 or {
					0,
					0,
					4
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local var_0_11 = {}
local var_0_12 = 11

for iter_0_0 = 1, var_0_12 do
	var_0_11[iter_0_0] = var_0_10("title_entry", "n/a", 52, {
		0,
		-6,
		4
	}, "center")
end

local var_0_13 = {
	divider = UIWidgets.create_simple_texture("divider_01_top", "divider"),
	divider_bottom = UIWidgets.create_simple_texture("divider_01_top", "divider_bottom"),
	background = UIWidgets.create_simple_texture("ingame_view_background_console", "background", nil, nil, {
		255,
		0,
		0,
		0
	}),
	logo = UIWidgets.create_simple_texture("hero_view_home_logo", "logo")
}
local var_0_14 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				arg_5_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = var_6_0
				arg_6_0.area_left.local_position[1] = arg_6_1.area_left.position[1] + -100 * (1 - var_6_0)
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				arg_8_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				local var_9_0 = math.easeOutCubic(arg_9_3)

				arg_9_4.render_settings.alpha_multiplier = 1 - var_9_0
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_13,
	generic_input_actions = var_0_9,
	title_button_definitions = var_0_11,
	scenegraph_definition = var_0_8,
	animation_definitions = var_0_14
}
