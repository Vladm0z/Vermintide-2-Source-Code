-- chunkname: @scripts/ui/views/end_screens/versus_round_end_screen_ui_definitions.lua

local var_0_0 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.end_screen_banner
		},
		size = {
			1920,
			1080
		}
	},
	top_bar = {
		vertical_alignment = "top",
		scale = "fit_width",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			UILayer.end_screen_banner + 100
		},
		size = {
			1920,
			200
		}
	},
	level_name = {
		vertical_alignment = "center",
		parent = "top_bar",
		horizontal_alignment = "center",
		position = {
			200,
			20,
			1
		},
		size = {
			600,
			50
		}
	},
	round_count = {
		vertical_alignment = "center",
		parent = "top_bar",
		horizontal_alignment = "center",
		position = {
			200,
			-20,
			1
		},
		size = {
			600,
			50
		}
	},
	level_image = {
		vertical_alignment = "center",
		parent = "top_bar",
		horizontal_alignment = "center",
		position = {
			-200,
			0,
			1
		},
		size = {
			180,
			180
		}
	},
	team_1_banner = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			-710,
			40,
			2
		},
		size = {
			232,
			484
		}
	},
	team_1_winner = {
		vertical_alignment = "top",
		parent = "team_1_banner",
		horizontal_alignment = "center",
		position = {
			0,
			90,
			2
		},
		size = {
			140,
			140
		}
	},
	team_1_info = {
		vertical_alignment = "top",
		parent = "team_1_banner",
		horizontal_alignment = "right",
		position = {
			450,
			-10,
			-2
		},
		size = {
			500,
			98
		}
	},
	team_2_banner = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			710,
			40,
			2
		},
		size = {
			232,
			484
		}
	},
	team_2_winner = {
		vertical_alignment = "top",
		parent = "team_2_banner",
		horizontal_alignment = "center",
		position = {
			0,
			90,
			2
		},
		size = {
			140,
			140
		}
	},
	team_2_info = {
		vertical_alignment = "top",
		parent = "team_2_banner",
		horizontal_alignment = "left",
		position = {
			-450,
			-10,
			-2
		},
		size = {
			500,
			98
		}
	},
	total_score = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			50,
			2
		},
		size = {
			1180,
			180
		}
	},
	team_winning_text = {
		vertical_alignment = "center",
		parent = "total_score",
		horizontal_alignment = "center",
		position = {
			0,
			108,
			2
		},
		size = {
			1180,
			30
		}
	},
	team_1_total_score = {
		vertical_alignment = "top",
		parent = "total_score",
		horizontal_alignment = "center",
		position = {
			40,
			-36,
			2
		},
		size = {
			1020,
			30
		}
	},
	team_2_total_score = {
		vertical_alignment = "bottom",
		parent = "total_score",
		horizontal_alignment = "center",
		position = {
			40,
			36,
			2
		},
		size = {
			1020,
			30
		}
	},
	round_score_bgs_pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			-160,
			2
		},
		size = {
			920,
			100
		}
	},
	round_score_bar_team_1 = {
		vertical_alignment = "center",
		parent = "round_score_bgs_pivot",
		horizontal_alignment = "left",
		position = {
			40,
			-20,
			3
		},
		size = {
			400,
			14
		}
	},
	round_score_bar_team_2 = {
		vertical_alignment = "center",
		parent = "round_score_bgs_pivot",
		horizontal_alignment = "right",
		position = {
			-40,
			-20,
			3
		},
		size = {
			400,
			14
		}
	},
	title_text_round_end = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			300,
			1
		},
		size = {
			1400,
			100
		}
	}
}
local var_0_1 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 50,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_2 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 28,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_3 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 72,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_4 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	font_size = 68,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("local_player_team", 255),
	offset = {
		0,
		0,
		0
	}
}
local var_0_5 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 36,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		10
	}
}
local var_0_6 = table.clone(var_0_4)

var_0_6.horizontal_alignment = "right"
var_0_6.text_color = Colors.get_color_table_with_alpha("opponent_team", 255)

local var_0_7 = {
	background = UIWidgets.create_simple_rect("screen", {
		0,
		0,
		0,
		0
	}),
	banner = UIWidgets.create_shader_tiled_texture("top_bar", "carousel_end_screen_panel", {
		512,
		200
	}),
	banner_mask = UIWidgets.create_shader_tiled_texture("top_bar", "carousel_end_screen_panel_mask", {
		512,
		200
	}),
	banner_gradient = UIWidgets.create_simple_texture("end_screen_banner_gradient", "top_bar", nil, nil, {
		76.8,
		255,
		255,
		255
	}, {
		0,
		0,
		10
	}),
	level_image = UIWidgets.create_level_widget("level_image"),
	level_name = UIWidgets.create_simple_text("LEVEL NAME", "level_name", nil, nil, var_0_1),
	round_counter = UIWidgets.create_simple_text("Round 1/3", "round_count", nil, nil, var_0_2),
	team_1_banner = UIWidgets.create_simple_texture("banner_skulls_local_long", "team_1_banner"),
	team_1_info = UIWidgets.create_team_banner_info("team_1_info", true),
	team_2_banner = UIWidgets.create_simple_texture("banner_skulls_opponent_long", "team_2_banner"),
	team_2_info = UIWidgets.create_team_banner_info("team_2_info", false),
	total_score_bg = UIWidgets.create_round_end_total_score_widget("total_score", var_0_0.total_score.size),
	team_wining_status_text = UIWidgets.create_simple_text("Your Team is Winning", "team_winning_text", nil, nil, var_0_5)
}
local var_0_8 = UIUtils.set_widget_alpha

local function var_0_9(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0.style
	local var_1_1 = arg_1_0.content
	local var_1_2 = var_1_1.current_score
	local var_1_3 = var_1_1.max_score
	local var_1_4 = math.min(var_1_2 / var_1_3, 1)

	var_1_1.score_progress = var_1_4 * arg_1_1
	var_1_0.current_score_icon.offset[1] = 75 + var_1_1.progress_bar_max_size * (var_1_4 * arg_1_1) - 32
	var_1_0.current_score_text.offset[1] = 75 + var_1_1.progress_bar_max_size * (var_1_4 * arg_1_1) - 32
	var_1_1.current_score_text = math.floor(var_1_4 * arg_1_1 * var_1_3)
end

local var_0_10 = {
	round_end = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				var_0_8(arg_2_2.background, 0)

				arg_2_3.draw_flags.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				local var_3_0 = math.easeCubic(arg_3_3)

				arg_3_4.draw_flags.alpha_multiplier = var_3_0

				var_0_8(arg_3_2.background, var_3_0 * 60)
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end
		},
		{
			name = "set_team_score_progress",
			start_progress = 0.9,
			end_progress = 2.5,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				if arg_5_3.current_round > 1 then
					for iter_5_0 = 1, 2 do
						for iter_5_1 = 1, arg_5_3.current_round - 1 do
							local var_5_0 = arg_5_2["round_" .. iter_5_1 .. "_team_" .. iter_5_0 .. "_score_bar"]
							local var_5_1 = var_5_0.content
							local var_5_2 = var_5_0.style
							local var_5_3 = var_5_1.bar_fill_threashold
							local var_5_4 = var_5_2.current_score_bg

							var_5_4.offset[1] = var_5_4.default_offset[1] + (var_5_1.bar_size[1] - var_5_1.score_size[1] - 50) * math.max(0, var_5_3)

							local var_5_5 = var_5_2.current_score_frame

							var_5_5.offset[1] = var_5_5.default_offset[1] + (var_5_1.bar_size[1] - var_5_1.score_size[1] - 50) * math.max(0, var_5_3)

							local var_5_6 = var_5_2.current_score

							var_5_6.offset[1] = var_5_6.default_offset[1] + (var_5_1.bar_size[1] - var_5_1.score_size[1] - 50) * math.max(0, var_5_3)
							var_5_1.current_bar_fil_threshold = var_5_3
						end
					end
				end
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeCubic(arg_6_3)

				for iter_6_0 = 1, 2 do
					local var_6_1 = arg_6_4.current_round
					local var_6_2 = arg_6_2["round_" .. var_6_1 .. "_team_" .. iter_6_0 .. "_score_bar"]
					local var_6_3 = var_6_2.content
					local var_6_4 = var_6_2.style
					local var_6_5 = var_6_3.bar_fill_threashold * var_6_0
					local var_6_6 = var_6_4.current_score_bg

					var_6_6.offset[1] = var_6_6.default_offset[1] + (var_6_3.bar_size[1] - var_6_3.score_size[1] - 50) * math.max(0, var_6_5)

					local var_6_7 = var_6_4.current_score_frame

					var_6_7.offset[1] = var_6_7.default_offset[1] + (var_6_3.bar_size[1] - var_6_3.score_size[1] - 50) * math.max(0, var_6_5)

					local var_6_8 = var_6_4.current_score

					var_6_8.offset[1] = var_6_8.default_offset[1] + (var_6_3.bar_size[1] - var_6_3.score_size[1] - 50) * math.max(0, var_6_5)
					var_6_3.current_bar_fil_threshold = var_6_5
				end
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		},
		{
			name = "total_score_progress",
			start_progress = 1.3,
			end_progress = 2.5,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				return
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				local var_9_0 = math.easeCubic(arg_9_3)

				for iter_9_0 = 1, 2 do
					local var_9_1 = arg_9_2["team_" .. iter_9_0 .. "_total_score"]
					local var_9_2 = var_9_1.content
					local var_9_3 = var_9_1.style
					local var_9_4 = var_9_2.bar_fill_threashold * var_9_0
					local var_9_5 = var_9_3.current_score_background

					var_9_5.offset[1] = var_9_5.default_offset[1] + (var_9_2.bar_size[1] - var_9_2.current_score_size[1] - 65) * math.max(0, var_9_4)

					local var_9_6 = var_9_3.gold_frame

					var_9_6.offset[1] = var_9_6.default_offset[1] + (var_9_2.bar_size[1] - var_9_2.current_score_size[1] - 65) * math.max(0, var_9_4)

					local var_9_7 = var_9_3.left_detail_w

					var_9_7.offset[1] = var_9_7.default_offset[1] + (var_9_2.bar_size[1] - var_9_2.current_score_size[1] - 65) * math.max(0, var_9_4)

					local var_9_8 = var_9_3.right_detail_w

					var_9_8.offset[1] = var_9_8.default_offset[1] + (var_9_2.bar_size[1] - var_9_2.current_score_size[1] - 65) * math.max(0, var_9_4)

					local var_9_9 = var_9_3.bronze_frame

					var_9_9.offset[1] = var_9_9.default_offset[1] + (var_9_2.bar_size[1] - var_9_2.current_score_size[1] - 65) * math.max(0, var_9_4)

					local var_9_10 = var_9_3.left_detail_l

					var_9_10.offset[1] = var_9_10.default_offset[1] + (var_9_2.bar_size[1] - var_9_2.current_score_size[1] - 65) * math.max(0, var_9_4)

					local var_9_11 = var_9_3.right_detail_l

					var_9_11.offset[1] = var_9_11.default_offset[1] + (var_9_2.bar_size[1] - var_9_2.current_score_size[1] - 65) * math.max(0, var_9_4)

					local var_9_12 = var_9_3.current_score

					var_9_12.offset[1] = var_9_12.default_offset[1] + (var_9_2.bar_size[1] - var_9_2.current_score_size[1] - 65) * math.max(0, var_9_4)
					var_9_2.current_score_text = math.floor(var_9_2.current_score * var_9_0)
					var_9_2.current_bar_fil_threshold = var_9_4
				end
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 9.5,
			end_progress = 10,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				return
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				local var_12_0 = 1 - math.easeInCubic(arg_12_3)

				arg_12_4.draw_flags.alpha_multiplier = var_12_0
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		}
	}
}

return {
	scenegraph_definition = var_0_0,
	widget_definitions = var_0_7,
	animation_definitions = var_0_10
}
