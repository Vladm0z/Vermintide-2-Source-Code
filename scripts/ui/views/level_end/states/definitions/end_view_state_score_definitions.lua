-- chunkname: @scripts/ui/views/level_end/states/definitions/end_view_state_score_definitions.lua

local num = 20
local num_2 = 4
local tbl = {
	250,
	580
}
local num_3 = 1400 + tbl[1]
local tbl_2 = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.end_screen
		}
	},
	scores_topics = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			350,
			tbl[2]
		},
		position = {
			0,
			0,
			10
		}
	},
	summary_title = {
		vertical_alignment = "top",
		parent = "scores_topics",
		horizontal_alignment = "center",
		size = {
			1600,
			40
		},
		position = {
			0,
			0,
			1
		}
	},
	title_bg = {
		vertical_alignment = "center",
		parent = "summary_title",
		horizontal_alignment = "center",
		size = {
			334,
			60
		},
		position = {
			0,
			0,
			-1
		}
	},
	level = {
		vertical_alignment = "top",
		parent = "title_bg",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			200,
			5
		}
	},
	player_panel_1 = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			-700,
			0,
			1
		}
	},
	player_panel_2 = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			-375,
			0,
			1
		}
	},
	player_panel_3 = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			375,
			0,
			1
		}
	},
	player_panel_4 = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			700,
			0,
			1
		}
	},
	player_frame_1 = {
		vertical_alignment = "top",
		parent = "player_panel_1",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-15,
			10
		}
	},
	player_frame_2 = {
		vertical_alignment = "top",
		parent = "player_panel_2",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-15,
			10
		}
	},
	player_frame_3 = {
		vertical_alignment = "top",
		parent = "player_panel_3",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-15,
			10
		}
	},
	player_frame_4 = {
		vertical_alignment = "top",
		parent = "player_panel_4",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-15,
			10
		}
	}
}
local tbl_3 = {
	word_wrap = true,
	font_size = 52,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_4 = {
	word_wrap = true,
	font_size = 32,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_5 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 28,
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
local tbl_6 = {
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
local tbl_7 = {
	level = UIWidgets.create_level_widget("level"),
	summary_title = UIWidgets.create_simple_text(Localize("end_screen_scoreboard"), "summary_title", nil, nil, tbl_3),
	title_bg = UIWidgets.create_simple_texture("tab_menu_bg_03", "title_bg"),
	scores_topics = UIWidgets.create_score_topics("scores_topics", tbl_2.scores_topics.size, num_3, num)
}

if not Development.parameter("tobii_button") then
	tbl_2.tobii_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			600,
			200
		},
		position = {
			0,
			-30,
			1
		}
	}
	tbl_2.tobii_button = {
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
	tbl_2.tobii_description = {
		vertical_alignment = "bottom",
		parent = "tobii_window",
		horizontal_alignment = "center",
		size = {
			500,
			50
		},
		position = {
			0,
			60,
			10
		}
	}
	tbl_2.tobii_title = {
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
	tbl_2.tobii_title_divider = {
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
	tbl_2.tobii_title_effect = {
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
	tbl_2.scores_topics.position[2] = -50
	tbl_2.player_panel_1.position[2] = -50
	tbl_2.player_panel_2.position[2] = -50
	tbl_2.player_panel_3.position[2] = -50
	tbl_2.player_panel_4.position[2] = -50
	tbl_7.tobii_description = UIWidgets.create_simple_text("did you beat the beta challenge leader with your time?", "tobii_description", nil, nil, tbl_6)
	tbl_7.tobii_title = UIWidgets.create_simple_text("check out your score and if you won!", "tobii_title", nil, nil, tbl_5)
	tbl_7.tobii_title_effect = UIWidgets.create_simple_texture("play_button_frame_glow", "tobii_title_effect")
	tbl_7.tobii_title_divider = UIWidgets.create_simple_texture("divider_01_top", "tobii_title_divider")
	tbl_7.tobii_button = UIWidgets.create_default_button("tobii_button", tbl_2.tobii_button.size, nil, nil, "Read More", 24)
	tbl_7.tobii_window_frame = UIWidgets.create_frame("tobii_window", tbl_2.tobii_window.size, "menu_frame_12", 10)
	tbl_7.tobii_window = UIWidgets.create_background("tobii_window", tbl_2.tobii_window.size, "menu_frame_bg_01")
	tbl_7.tobii_window_background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "tobii_window", nil, nil, nil, 1)
end

local tbl_8 = {
	player_score_1 = UIWidgets.create_score_entry("player_panel_1", tbl_2.player_panel_1.size, num, "left"),
	player_score_2 = UIWidgets.create_score_entry("player_panel_2", tbl_2.player_panel_2.size, num),
	player_score_3 = UIWidgets.create_score_entry("player_panel_3", tbl_2.player_panel_3.size, num, "left"),
	player_score_4 = UIWidgets.create_score_entry("player_panel_4", tbl_2.player_panel_4.size, num)
}
local tbl_9 = {
	player_frame_1 = UIWidgets.create_portrait_frame("player_frame_1", "default", "-", 1, nil, "unit_frame_portrait_default"),
	player_frame_2 = UIWidgets.create_portrait_frame("player_frame_2", "default", "-", 1, nil, "unit_frame_portrait_default"),
	player_frame_3 = UIWidgets.create_portrait_frame("player_frame_3", "default", "-", 1, nil, "unit_frame_portrait_default"),
	player_frame_4 = UIWidgets.create_portrait_frame("player_frame_4", "default", "-", 1, nil, "unit_frame_portrait_default")
}
local tbl_10 = {
	transition_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeOutCubic = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		},
		{
			name = "move_inner_panels",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				arg_4_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeInCubic = math.easeInCubic(1 - arg_5_3)

				arg_5_0.player_panel_2.local_position[1] = -375 - 400 * easeInCubic
				arg_5_0.player_panel_3.local_position[1] = 375 + 400 * easeInCubic
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		},
		{
			name = "move_outer_panels",
			start_progress = 0,
			end_progress = 0.4,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				arg_7_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local easeInCubic = math.easeInCubic(1 - arg_8_3)

				arg_8_0.player_panel_1.local_position[1] = -700 - 400 * easeInCubic
				arg_8_0.player_panel_4.local_position[1] = 700 + 400 * easeInCubic
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		},
		{
			name = "move_level",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				local num = 1

				arg_10_0.level.local_position[2] = arg_10_1.level.position[2] + 50 * num
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local num = 1 - math.easeOutCubic(arg_11_3)

				arg_11_0.level.local_position[2] = arg_11_1.level.position[2] + 50 * num
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				return
			end
		}
	},
	transition_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				arg_13_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				local easeInCubic = math.easeInCubic(arg_14_3)

				arg_14_4.render_settings.alpha_multiplier = 1 - easeInCubic
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				return
			end
		}
	}
}

return {
	widgets = tbl_7,
	hero_widgets = tbl_9,
	score_widgets = tbl_8,
	player_score_size = tbl,
	scenegraph_definition = tbl_2,
	animation_definitions = tbl_10
}
