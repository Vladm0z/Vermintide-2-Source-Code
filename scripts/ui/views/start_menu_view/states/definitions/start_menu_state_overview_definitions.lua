-- chunkname: @scripts/ui/views/start_menu_view/states/definitions/start_menu_state_overview_definitions.lua

local var_0_0 = 4
local var_0_1 = 40
local var_0_2 = {
	250,
	250
}
local var_0_3 = {
	250,
	250
}
local var_0_4 = {
	var_0_2[1] * var_0_0 + var_0_1 * (var_0_0 - 1),
	var_0_2[2]
}
local var_0_5 = {
	screen = {
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
	right_side_root = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			1080
		},
		position = {
			0,
			0,
			1
		}
	},
	left_side_root = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			1080
		},
		position = {
			0,
			0,
			1
		}
	},
	console_cursor = {
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
	menu_options_panel = {
		vertical_alignment = "top",
		parent = "left_side_root",
		horizontal_alignment = "left",
		size = {
			260,
			103
		},
		position = {
			130,
			-300,
			6
		}
	},
	play_button = {
		vertical_alignment = "bottom",
		parent = "menu_options_panel",
		horizontal_alignment = "center",
		size = {
			380,
			70
		},
		position = {
			0,
			-85,
			1
		}
	},
	options_button = {
		vertical_alignment = "center",
		parent = "play_button",
		horizontal_alignment = "center",
		size = {
			380,
			70
		},
		position = {
			0,
			-85,
			1
		}
	},
	tutorial_button = {
		vertical_alignment = "center",
		parent = "options_button",
		horizontal_alignment = "center",
		size = {
			380,
			70
		},
		position = {
			0,
			-85,
			1
		}
	},
	cinematics_button = {
		vertical_alignment = "center",
		parent = "tutorial_button",
		horizontal_alignment = "center",
		size = {
			380,
			70
		},
		position = {
			0,
			-85,
			1
		}
	},
	credits_button = {
		vertical_alignment = "center",
		parent = "cinematics_button",
		horizontal_alignment = "center",
		size = {
			380,
			70
		},
		position = {
			0,
			-85,
			1
		}
	},
	quit_button = {
		vertical_alignment = "center",
		parent = "credits_button",
		horizontal_alignment = "center",
		size = {
			300,
			70
		},
		position = {
			0,
			-85,
			1
		}
	},
	game_options_title = {
		vertical_alignment = "top",
		parent = "right_side_root",
		horizontal_alignment = "right",
		size = {
			465,
			171
		},
		position = {
			-75,
			-70,
			6
		}
	},
	game_options_window = {
		vertical_alignment = "center",
		parent = "game_options_title",
		horizontal_alignment = "center",
		size = {
			380,
			150
		},
		position = {
			0,
			-150,
			1
		}
	},
	selection_info = {
		vertical_alignment = "top",
		parent = "right_side_root",
		horizontal_alignment = "right",
		size = {
			264,
			130
		},
		position = {
			-85,
			-446,
			1
		}
	},
	selection_info_top = {
		vertical_alignment = "top",
		parent = "selection_info",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			14,
			1
		}
	},
	selection_info_bottom = {
		vertical_alignment = "bottom",
		parent = "selection_info",
		horizontal_alignment = "center",
		size = {
			264,
			21
		},
		position = {
			0,
			-1,
			1
		}
	},
	info_career_name = {
		vertical_alignment = "top",
		parent = "selection_info",
		horizontal_alignment = "center",
		size = {
			400,
			25
		},
		position = {
			0,
			-23,
			1
		}
	},
	info_hero_name = {
		vertical_alignment = "top",
		parent = "info_career_name",
		horizontal_alignment = "center",
		size = {
			400,
			25
		},
		position = {
			0,
			-35,
			1
		}
	},
	info_hero_level = {
		vertical_alignment = "top",
		parent = "info_hero_name",
		horizontal_alignment = "center",
		size = {
			450,
			25
		},
		position = {
			0,
			-30,
			1
		}
	},
	hero_button = {
		vertical_alignment = "bottom",
		parent = "selection_info",
		horizontal_alignment = "center",
		size = {
			300,
			60
		},
		position = {
			0,
			-85,
			1
		}
	},
	portrait_root = {
		vertical_alignment = "top",
		parent = "selection_info",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			80,
			1
		}
	},
	logo = {
		vertical_alignment = "top",
		parent = "left_side_root",
		horizontal_alignment = "left",
		size = {
			390,
			197
		},
		position = {
			64,
			-45,
			1
		}
	},
	game_options_right_chain = {
		vertical_alignment = "top",
		parent = "selection_info",
		horizontal_alignment = "center",
		size = {
			16,
			105
		},
		position = {
			100,
			-130,
			-4
		}
	},
	game_options_left_chain = {
		vertical_alignment = "top",
		parent = "selection_info",
		horizontal_alignment = "center",
		size = {
			16,
			90
		},
		position = {
			-100,
			-130,
			-4
		}
	},
	game_options_right_chain_end = {
		vertical_alignment = "bottom",
		parent = "game_options_right_chain",
		horizontal_alignment = "center",
		size = {
			19,
			20
		},
		position = {
			-1,
			-20,
			1
		}
	},
	game_options_left_chain_end = {
		vertical_alignment = "bottom",
		parent = "game_options_left_chain",
		horizontal_alignment = "center",
		size = {
			19,
			20
		},
		position = {
			-1,
			-20,
			1
		}
	},
	menu_options_right_chain = {
		vertical_alignment = "top",
		parent = "menu_options_panel",
		horizontal_alignment = "center",
		size = {
			16,
			450
		},
		position = {
			100,
			-90,
			-4
		}
	},
	menu_options_left_chain = {
		vertical_alignment = "top",
		parent = "menu_options_panel",
		horizontal_alignment = "center",
		size = {
			16,
			480
		},
		position = {
			-100,
			-90,
			-4
		}
	},
	menu_options_right_chain_end = {
		vertical_alignment = "bottom",
		parent = "menu_options_right_chain",
		horizontal_alignment = "center",
		size = {
			19,
			20
		},
		position = {
			-1,
			-20,
			1
		}
	},
	menu_options_left_chain_end = {
		vertical_alignment = "bottom",
		parent = "menu_options_left_chain",
		horizontal_alignment = "center",
		size = {
			19,
			20
		},
		position = {
			-1,
			-20,
			1
		}
	}
}

if Development.parameter("tobii_button") then
	var_0_5.tobii_window = {
		vertical_alignment = "bottom",
		parent = "right_side_root",
		horizontal_alignment = "right",
		size = {
			600,
			200
		},
		position = {
			-90,
			80,
			1
		}
	}
	var_0_5.tobii_button = {
		vertical_alignment = "bottom",
		parent = "tobii_window",
		horizontal_alignment = "center",
		size = {
			300,
			70
		},
		position = {
			0,
			-33,
			30
		}
	}
	var_0_5.tobii_description = {
		vertical_alignment = "bottom",
		parent = "tobii_window",
		horizontal_alignment = "center",
		size = {
			500,
			50
		},
		position = {
			0,
			50,
			10
		}
	}
	var_0_5.tobii_title = {
		vertical_alignment = "center",
		parent = "tobii_window",
		horizontal_alignment = "center",
		size = {
			580,
			50
		},
		position = {
			0,
			60,
			10
		}
	}
	var_0_5.tobii_title_divider = {
		vertical_alignment = "center",
		parent = "tobii_title",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-30,
			-3
		}
	}
	var_0_5.tobii_title_effect = {
		vertical_alignment = "bottom",
		parent = "tobii_title_divider",
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
	}
end

local var_0_6 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_7 = {
	word_wrap = true,
	use_shadow = true,
	localize = false,
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_8 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_9 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 36,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_10 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_11 = {
	tutorial_button = UIWidgets.create_default_button("tutorial_button", var_0_5.tutorial_button.size, nil, nil, Localize("start_menu_tutorial"), 24),
	cinematics_button = UIWidgets.create_default_button("cinematics_button", var_0_5.cinematics_button.size, nil, nil, Localize("start_menu_cinematics"), 24),
	credits_button = UIWidgets.create_default_button("credits_button", var_0_5.credits_button.size, nil, nil, Localize("start_menu_credits"), 24),
	quit_button = UIWidgets.create_default_button("quit_button", var_0_5.quit_button.size, nil, nil, Localize("start_menu_quit"), 24),
	play_button = UIWidgets.create_default_button("play_button", var_0_5.play_button.size, nil, nil, Localize("start_menu_play"), 24, "green"),
	options_button = UIWidgets.create_default_button("options_button", var_0_5.options_button.size, nil, nil, Localize("start_menu_options"), 24),
	hero_button = UIWidgets.create_default_button("hero_button", var_0_5.hero_button.size, nil, nil, Localize("start_menu_switch_hero"), 24, nil, "button_detail_02"),
	game_options_right_chain_end = UIWidgets.create_simple_texture("chain_link_02", "game_options_right_chain_end"),
	game_options_left_chain_end = UIWidgets.create_simple_texture("chain_link_02", "game_options_left_chain_end"),
	game_options_left_chain = UIWidgets.create_tiled_texture("game_options_left_chain", "chain_link_01", {
		16,
		19
	}),
	game_options_right_chain = UIWidgets.create_tiled_texture("game_options_right_chain", "chain_link_01", {
		16,
		19
	}),
	menu_options_right_chain_end = UIWidgets.create_simple_texture("chain_link_02", "menu_options_right_chain_end"),
	menu_options_left_chain_end = UIWidgets.create_simple_texture("chain_link_02", "menu_options_left_chain_end"),
	menu_options_left_chain = UIWidgets.create_tiled_texture("menu_options_left_chain", "chain_link_01", {
		16,
		19
	}),
	menu_options_right_chain = UIWidgets.create_tiled_texture("menu_options_right_chain", "chain_link_01", {
		16,
		19
	}),
	menu_options_panel = UIWidgets.create_simple_texture("esc_menu_top", "menu_options_panel"),
	logo = UIWidgets.create_simple_texture("hero_view_home_logo", "logo"),
	selection_info_top = UIWidgets.create_simple_texture("divider_01_top", "selection_info_top"),
	selection_info_bottom = UIWidgets.create_simple_texture("divider_01_bottom", "selection_info_bottom"),
	selection_info = UIWidgets.create_simple_texture("divider_01_bg", "selection_info", nil, nil, {
		255,
		0,
		0,
		0
	}),
	info_career_name = UIWidgets.create_simple_text("n/a", "info_career_name", nil, nil, var_0_6),
	info_hero_name = UIWidgets.create_simple_text("n/a", "info_hero_name", nil, nil, var_0_7),
	info_hero_level = UIWidgets.create_simple_text("n/a", "info_hero_level", nil, nil, var_0_8)
}

if Development.parameter("tobii_button") then
	var_0_11.tobii_description = UIWidgets.create_simple_text("Rush into the chance to win exclusive prizes", "tobii_description", nil, nil, var_0_10)
	var_0_11.tobii_title = UIWidgets.create_simple_text("JOIN AN EPIC CHALLENGE", "tobii_title", nil, nil, var_0_9)
	var_0_11.tobii_title_effect = UIWidgets.create_simple_texture("play_button_frame_glow", "tobii_title_effect")
	var_0_11.tobii_title_divider = UIWidgets.create_simple_texture("divider_01_top", "tobii_title_divider")
	var_0_11.tobii_button = UIWidgets.create_default_button("tobii_button", var_0_5.tobii_button.size, nil, nil, "Read More", 24)
	var_0_11.tobii_window_frame = UIWidgets.create_frame("tobii_window", var_0_5.tobii_window.size, "menu_frame_12", 10)
	var_0_11.tobii_window = UIWidgets.create_background("tobii_window", var_0_5.tobii_window.size, "menu_frame_bg_01")
	var_0_11.tobii_window_background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "tobii_window", nil, nil, nil, 1)
end

local var_0_12 = {
	default = {
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
local var_0_13 = {
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
				arg_2_0.left_side_root.local_position[1] = arg_2_1.left_side_root.position[1] + -100 * (1 - var_2_0)
				arg_2_0.right_side_root.local_position[1] = arg_2_1.right_side_root.position[1] + 100 * (1 - var_2_0)
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
			end_progress = 1,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - var_5_0
				arg_5_0.left_side_root.local_position[1] = arg_5_1.left_side_root.position[1] + -100 * var_5_0
				arg_5_0.right_side_root.local_position[1] = arg_5_1.right_side_root.position[1] + 100 * var_5_0
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_11,
	generic_input_actions = var_0_12,
	scenegraph_definition = var_0_5,
	animation_definitions = var_0_13,
	console_cursor_definition = UIWidgets.create_console_cursor("console_cursor")
}
