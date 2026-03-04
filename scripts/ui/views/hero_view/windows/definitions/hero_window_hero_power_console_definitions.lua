-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_hero_power_console_definitions.lua

local var_0_0 = UISettings.game_start_windows.size
local var_0_1 = UISettings.console_menu_scenegraphs
local var_0_2 = {
	screen = var_0_1.screen,
	area = var_0_1.area,
	area_left = var_0_1.area_left,
	area_right = var_0_1.area_right,
	area_divider = var_0_1.area_divider,
	divider = {
		vertical_alignment = "top",
		parent = "area_left",
		horizontal_alignment = "left",
		size = {
			489,
			137
		},
		position = {
			50,
			-13,
			1
		}
	},
	divider_detail_1 = {
		vertical_alignment = "center",
		parent = "divider",
		horizontal_alignment = "left",
		size = {
			55,
			59
		},
		position = {
			51,
			-4,
			1
		}
	},
	divider_detail_2 = {
		vertical_alignment = "center",
		parent = "divider",
		horizontal_alignment = "left",
		size = {
			494,
			138
		},
		position = {
			-12,
			44,
			-1
		}
	},
	hero_power_number = {
		vertical_alignment = "top",
		parent = "divider",
		horizontal_alignment = "left",
		size = {
			500,
			120
		},
		position = {
			164,
			26,
			1
		}
	},
	hero_power_text = {
		vertical_alignment = "center",
		parent = "divider",
		horizontal_alignment = "left",
		size = {
			500,
			40
		},
		position = {
			170,
			-24,
			1
		}
	}
}
local var_0_3 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 102,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_4 = {
	font_size = 28,
	upper_case = false,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_5 = {
	hero_power_tooltip = {
		scenegraph_id = "divider",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "hero_power_tooltip",
					content_check_function = function(arg_1_0)
						return arg_1_0.button_hotspot.is_hover
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "effect",
					texture_id = "effect"
				}
			}
		},
		content = {
			effect = "sparkle_effect",
			background = "hero_power_bg",
			hover = "hero_power_bg_hover",
			button_hotspot = {}
		},
		style = {
			effect = {
				vertical_alignment = "top",
				angle = 0,
				horizontal_alignment = "left",
				offset = {
					40,
					40,
					4
				},
				pivot = {
					128,
					128
				},
				texture_size = {
					256,
					256
				},
				color = Colors.get_color_table_with_alpha("white", 0)
			}
		}
	},
	divider = UIWidgets.create_simple_texture("hero_power_bg_console", "divider"),
	divider_detail_1 = UIWidgets.create_simple_texture("hero_power_eyes_console", "divider_detail_1"),
	divider_detail_2 = UIWidgets.create_simple_texture("hero_power_glow_console", "divider_detail_2", nil, nil, Colors.get_color_table_with_alpha("font_title", 255)),
	power_text = UIWidgets.create_simple_text("10", "hero_power_number", nil, nil, var_0_3),
	power_title = UIWidgets.create_simple_text("hero_power_header", "hero_power_text", nil, nil, var_0_4)
}
local var_0_6 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				local var_3_0 = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = var_3_0
			end,
			on_complete = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = 1 - var_6_0
			end,
			on_complete = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_5,
	node_widgets = node_widgets,
	category_settings = category_settings,
	scenegraph_definition = var_0_2,
	animation_definitions = var_0_6
}
