-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_panel_console_definitions.lua

local var_0_0 = UISettings.game_start_windows.size
local var_0_1 = UISettings.console_menu_scenegraphs
local var_0_2 = {
	220,
	68
}
local var_0_3 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - var_5_0
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}
local var_0_4 = {
	screen = var_0_1.screen,
	area = var_0_1.area,
	area_left = var_0_1.area_left,
	area_right = var_0_1.area_right,
	area_divider = var_0_1.area_divider,
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
			UILayer.default + 1
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
			UILayer.default + 10
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
			UILayer.default + 1
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
	panel_entry_area = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			1600,
			70
		},
		position = {
			70,
			0,
			1
		}
	},
	game_mode_option = {
		vertical_alignment = "top",
		parent = "panel_entry_area",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			20,
			0,
			14
		}
	},
	panel_input_area_1 = {
		vertical_alignment = "center",
		parent = "game_mode_option",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-50,
			8,
			1
		}
	},
	panel_input_area_2 = {
		vertical_alignment = "center",
		parent = "game_mode_option",
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
	menu_root = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = var_0_0,
		position = {
			0,
			0,
			1
		}
	},
	title_text_glow = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			544,
			16
		},
		position = {
			0,
			15,
			-1
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "title_text_glow",
		horizontal_alignment = "center",
		size = {
			var_0_0[1],
			50
		},
		position = {
			0,
			15,
			1
		}
	}
}
local var_0_5 = UISettings.console_menu_rect_color
local var_0_6 = {
	panel_edge = UIWidgets.create_simple_texture("menu_frame_04_divider", "panel_edge"),
	panel_input_area_1 = UIWidgets.create_simple_texture("xbone_button_icon_lt", "panel_input_area_1"),
	panel_input_area_2 = UIWidgets.create_simple_texture("xbone_button_icon_rt", "panel_input_area_2"),
	panel = UIWidgets.create_simple_texture("menu_panel_bg", "panel", nil, nil, var_0_5),
	bottom_panel = UIWidgets.create_simple_uv_texture("menu_panel_bg", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_panel", nil, nil, var_0_5),
	back_button = UIWidgets.create_layout_button("back_button", "layout_button_back", "layout_button_back_glow"),
	close_button = UIWidgets.create_layout_button("close_button", "layout_button_close", "layout_button_close_glow")
}

return {
	widget_definitions = var_0_6,
	scenegraph_definition = var_0_4,
	animation_definitions = var_0_3,
	create_panel_button = UIWidgets.create_console_panel_button
}
