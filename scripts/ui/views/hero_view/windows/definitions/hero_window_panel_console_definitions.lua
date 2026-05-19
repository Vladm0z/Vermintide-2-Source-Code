-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_panel_console_definitions.lua

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
	panel = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			1920,
			79
		},
		position = {
			0,
			0,
			UILayer.options_menu + 1
		}
	},
	panel_edge = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			1920,
			4
		},
		position = {
			0,
			0,
			UILayer.options_menu + 10
		}
	},
	bottom_panel = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			1920,
			79
		},
		position = {
			0,
			0,
			UILayer.options_menu + 1
		}
	},
	system_button = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			254,
			114
		},
		position = {
			68,
			0,
			3
		}
	},
	bot_customization_button = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "right",
		size = {
			250,
			105
		},
		position = {
			-25,
			10,
			0
		}
	},
	bot_customization_info_bar = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "right",
		size = {
			464,
			100
		},
		position = {
			-180,
			20,
			3
		}
	},
	panel_entry_area = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			900,
			70
		},
		position = {
			320,
			0,
			1
		}
	},
	panel_input_area_1 = {
		vertical_alignment = "center",
		parent = "game_option_1",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-300,
			8,
			1
		}
	},
	panel_input_area_2 = {
		vertical_alignment = "center",
		parent = "game_option_5",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			50,
			8,
			1
		}
	},
	back_button = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			40,
			-120,
			3
		}
	},
	close_button = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			40,
			-34,
			3
		}
	},
	game_option_pivot = {
		vertical_alignment = "top",
		parent = "panel_entry_area",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			20,
			0,
			1
		}
	},
	game_option_1 = {
		vertical_alignment = "top",
		parent = "game_option_pivot",
		horizontal_alignment = "left",
		size = {
			220,
			68
		},
		position = {
			0,
			0,
			0
		}
	},
	game_option_2 = {
		vertical_alignment = "top",
		parent = "game_option_pivot",
		horizontal_alignment = "left",
		size = {
			220,
			68
		},
		position = {
			0,
			0,
			0
		}
	},
	game_option_3 = {
		vertical_alignment = "top",
		parent = "game_option_pivot",
		horizontal_alignment = "left",
		size = {
			220,
			68
		},
		position = {
			0,
			0,
			0
		}
	},
	game_option_4 = {
		vertical_alignment = "top",
		parent = "game_option_pivot",
		horizontal_alignment = "left",
		size = {
			220,
			68
		},
		position = {
			0,
			0,
			0
		}
	},
	game_option_5 = {
		vertical_alignment = "top",
		parent = "game_option_pivot",
		horizontal_alignment = "left",
		size = {
			220,
			68
		},
		position = {
			0,
			0,
			0
		}
	},
	preorder_divider = {
		vertical_alignment = "center",
		parent = "panel",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-110,
			3
		}
	},
	preorder_divider_effect = {
		vertical_alignment = "bottom",
		parent = "preorder_divider",
		horizontal_alignment = "center",
		size = {
			310,
			120
		},
		position = {
			0,
			7,
			-1
		}
	},
	preorder_divider_top = {
		vertical_alignment = "center",
		parent = "preorder_divider",
		horizontal_alignment = "center",
		size = {
			264,
			21
		},
		position = {
			0,
			80,
			3
		}
	},
	preorder_divider_top_effect = {
		vertical_alignment = "bottom",
		parent = "preorder_divider_top",
		horizontal_alignment = "center",
		size = {
			310,
			120
		},
		position = {
			0,
			-106,
			-1
		}
	},
	preorder_input = {
		vertical_alignment = "center",
		parent = "preorder_divider",
		horizontal_alignment = "center",
		size = {
			64,
			64
		},
		position = {
			0,
			-3,
			1
		}
	},
	preorder_text = {
		vertical_alignment = "center",
		parent = "preorder_divider",
		horizontal_alignment = "center",
		size = {
			220,
			40
		},
		position = {
			0,
			36,
			10
		}
	},
	preorder_text_bg = {
		vertical_alignment = "center",
		parent = "preorder_text",
		horizontal_alignment = "center",
		size = {
			600,
			120
		},
		position = {
			0,
			0,
			-15
		}
	},
	bot_warning = {
		vertical_alignment = "center",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			464,
			80
		},
		position = {
			1375,
			0,
			0
		}
	},
	bot_information_mask = {
		vertical_alignment = "center",
		parent = "panel",
		horizontal_alignment = "left",
		position = {
			1375,
			0,
			2
		}
	}
}
local var_0_9 = {
	font_size = 42,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_10 = 32
local var_0_11 = {}

var_0_11[#var_0_11 + 1] = UIWidgets.create_console_panel_button("game_option_1", var_0_8.game_option_1.size, "hero_window_equipment", var_0_10, nil, "center")
var_0_11[#var_0_11 + 1] = UIWidgets.create_console_panel_button("game_option_2", var_0_8.game_option_2.size, "hero_window_talents", var_0_10, nil, "center")
var_0_11[#var_0_11 + 1] = UIWidgets.create_console_panel_button("game_option_3", var_0_8.game_option_3.size, "hero_window_crafting", var_0_10, nil, "center")
var_0_11[#var_0_11 + 1] = UIWidgets.create_console_panel_button("game_option_4", var_0_8.game_option_4.size, "hero_window_cosmetics", var_0_10, nil, "center")
var_0_11[#var_0_11 + 1] = UIWidgets.create_console_panel_button("game_option_5", var_0_8.game_option_5.size, "hero_window_pactsworn_equipment", var_0_10, nil, "center")

local var_0_12 = UISettings.console_menu_rect_color
local var_0_13 = {
	system_button = {
		scenegraph_id = "system_button",
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					pass_type = "texture",
					style_id = "selected_texture",
					texture_id = "selected_texture"
				}
			}
		},
		content = {
			selected_texture = "console_menu_system_highlight",
			texture_id = "console_menu_system",
			button_hotspot = {}
		},
		style = {
			button_hotspot = {
				size = {
					220,
					90
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					17,
					24,
					0
				}
			},
			texture_id = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			selected_texture = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	panel_input_area_1 = UIWidgets.create_simple_texture("xbone_button_icon_lt", "panel_input_area_1"),
	panel_input_area_2 = UIWidgets.create_simple_texture("xbone_button_icon_rt", "panel_input_area_2"),
	panel = UIWidgets.create_simple_texture("menu_panel_bg", "panel", nil, nil, var_0_12),
	panel_edge = UIWidgets.create_tiled_texture("panel_edge", "menu_frame_04_divider", {
		1920,
		4
	}),
	bottom_panel = UIWidgets.create_simple_uv_texture("menu_panel_bg", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_panel", nil, nil, var_0_12),
	preorder_text = UIWidgets.create_simple_text(Localize("preorder_now"), "preorder_text", nil, nil, var_0_9),
	preorder_divider = UIWidgets.create_simple_texture("divider_01_top", "preorder_divider"),
	preorder_divider_top = UIWidgets.create_simple_texture("divider_01_bottom", "preorder_divider_top"),
	preorder_divider_effect = UIWidgets.create_simple_texture("play_button_frame_glow", "preorder_divider_effect", nil, nil, Colors.get_color_table_with_alpha("light_sky_blue", 255)),
	preorder_divider_top_effect = UIWidgets.create_simple_uv_texture("play_button_frame_glow", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "preorder_divider_top_effect", nil, nil, Colors.get_color_table_with_alpha("light_sky_blue", 255)),
	preorder_input = UIWidgets.create_simple_texture("xbone_button_icon_show_large", "preorder_input"),
	preorder_text_bg = UIWidgets.create_simple_texture("bg_center_fade", "preorder_text_bg", nil, nil, var_0_12),
	back_button = UIWidgets.create_layout_button("back_button", "layout_button_back", "layout_button_back_glow", {
		0,
		0,
		100
	}),
	close_button = UIWidgets.create_layout_button("close_button", "layout_button_close", "layout_button_close_glow", {
		0,
		0,
		100
	})
}
local var_0_14 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - var_5_0
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	},
	bot_info_enter = {
		{
			name = "bot_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end,
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = math.easeOutCubic(arg_8_3)

				arg_8_2.bot_customization_button.content.progress = var_8_0
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		}
	},
	bot_info_exit = {
		{
			name = "bot_fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end,
			update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				local var_11_0 = math.easeOutCubic(arg_11_3)

				arg_11_2.bot_customization_button.content.progress = 1 - var_11_0
			end,
			on_complete = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_13,
	create_bot_cusomization_button = UIWidgets.create_bot_cusomization_button,
	title_button_definitions = var_0_11,
	scenegraph_definition = var_0_8,
	animation_definitions = var_0_14
}
