-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_event_overview_console_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = UIFrameSettings[var_0_1].texture_sizes.horizontal[2]
local var_0_4 = {
	var_0_2[1],
	194
}
local var_0_5 = var_0_2[1]
local var_0_6 = {
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
				arg_5_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}
local var_0_7 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	root_fit = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	menu_root = {
		vertical_alignment = "center",
		parent = "root",
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
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			220,
			0,
			1
		}
	},
	window_game_mode_root = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1],
			var_0_3
		},
		position = {
			0,
			-var_0_3,
			1
		}
	},
	event_background = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] + 70,
			230
		},
		position = {
			0,
			0,
			1
		}
	},
	event_title = {
		vertical_alignment = "top",
		parent = "event_background",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			50
		},
		position = {
			0,
			-30,
			1
		}
	},
	event_divider = {
		vertical_alignment = "top",
		parent = "event_title",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-36,
			1
		}
	},
	event_description = {
		vertical_alignment = "top",
		parent = "event_divider",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			200
		},
		position = {
			0,
			-36,
			1
		}
	},
	difficulty_setting = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_4,
		position = {
			-15,
			-15 + var_0_4[2] * 2,
			1
		}
	},
	play_button_console = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_4,
		position = {
			0,
			220,
			1
		}
	},
	play_button = {
		vertical_alignment = "center",
		parent = "play_button_console",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-165,
			0,
			1
		}
	}
}
local var_0_8 = {
	font_size = 50,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_9 = {
	font_size = 28,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_10 = {
	event_description_background = UIWidgets.create_rect_with_outer_frame("event_background", var_0_7.event_background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	event_title = UIWidgets.create_simple_text("", "event_title", nil, nil, var_0_8),
	event_divider = UIWidgets.create_simple_texture("divider_01_top", "event_divider"),
	event_description = UIWidgets.create_simple_text("start_game_window_event_desc", "event_description", nil, nil, var_0_9),
	difficulty_setting = UIWidgets.create_start_game_console_setting_button("difficulty_setting", Localize("start_game_window_difficulty"), nil, "difficulty_option_1", nil, var_0_7.difficulty_setting.size, true),
	play_button = UIWidgets.create_icon_and_name_button("play_button", "options_button_icon_quickplay", Localize("start_game_window_play"))
}
local var_0_11 = {
	"difficulty_setting",
	"play_button"
}

return {
	scenegraph_definition = var_0_7,
	widgets = var_0_10,
	animation_definitions = var_0_6,
	selector_input_definition = var_0_11
}
