-- chunkname: @scripts/ui/views/end_screens/versus_round_end_screen_ui_definitions.lua

local tbl = {
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
local tbl_2 = {
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
local tbl_3 = {
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
local tbl_4 = {
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
local tbl_5 = {
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
local tbl_6 = {
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
local clone = table.clone(tbl_5)

clone.horizontal_alignment = "right"
clone.text_color = Colors.get_color_table_with_alpha("opponent_team", 255)

local tbl_7 = {
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
	level_name = UIWidgets.create_simple_text("LEVEL NAME", "level_name", nil, nil, tbl_2),
	round_counter = UIWidgets.create_simple_text("Round 1/3", "round_count", nil, nil, tbl_3),
	team_1_banner = UIWidgets.create_simple_texture("banner_skulls_local_long", "team_1_banner"),
	team_1_info = UIWidgets.create_team_banner_info("team_1_info", true),
	team_2_banner = UIWidgets.create_simple_texture("banner_skulls_opponent_long", "team_2_banner"),
	team_2_info = UIWidgets.create_team_banner_info("team_2_info", false),
	total_score_bg = UIWidgets.create_round_end_total_score_widget("total_score", tbl.total_score.size),
	team_wining_status_text = UIWidgets.create_simple_text("Your Team is Winning", "team_winning_text", nil, nil, tbl_6)
}
local set_widget_alpha = UIUtils.set_widget_alpha

local function fn(self, arg_1_1)
	-- function 1
	local style = self.style
	local content = self.content
	local current_score = content.current_score
	local max_score = content.max_score
	local min = math.min(current_score / max_score, 1)

	content.score_progress = min * arg_1_1
	style.current_score_icon.offset[1] = 75 + content.progress_bar_max_size * (min * arg_1_1) - 32
	style.current_score_text.offset[1] = 75 + content.progress_bar_max_size * (min * arg_1_1) - 32
	content.current_score_text = math.floor(min * arg_1_1 * max_score)
end

local tbl_8 = {
	round_end = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				set_widget_alpha(arg_2_2.background, 0)

				arg_2_3.draw_flags.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				local easeCubic = math.easeCubic(arg_3_3)

				arg_3_4.draw_flags.alpha_multiplier = easeCubic

				set_widget_alpha(arg_3_2.background, easeCubic * 60)
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end
		},
		{
			name = "set_team_score_progress",
			start_progress = 0.9,
			end_progress = 2.5,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				if arg_5_3.current_round > 1 then
					for i = 1, 2 do
						for j = 1, arg_5_3.current_round - 1 do
							local var_5_0 = arg_5_2["round_" .. j .. "_team_" .. i .. "_score_bar"]
							local content = var_5_0.content
							local style = var_5_0.style
							local bar_fill_threashold = content.bar_fill_threashold
							local current_score_bg = style.current_score_bg

							current_score_bg.offset[1] = current_score_bg.default_offset[1] + (content.bar_size[1] - content.score_size[1] - 50) * math.max(0, bar_fill_threashold)

							local current_score_frame = style.current_score_frame

							current_score_frame.offset[1] = current_score_frame.default_offset[1] + (content.bar_size[1] - content.score_size[1] - 50) * math.max(0, bar_fill_threashold)

							local current_score = style.current_score

							current_score.offset[1] = current_score.default_offset[1] + (content.bar_size[1] - content.score_size[1] - 50) * math.max(0, bar_fill_threashold)
							content.current_bar_fil_threshold = bar_fill_threashold
						end
					end
				end
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				local easeCubic = math.easeCubic(arg_6_3)

				for i = 1, 2 do
					local current_round = arg_6_4.current_round
					local var_6_2 = arg_6_2["round_" .. current_round .. "_team_" .. i .. "_score_bar"]
					local content = var_6_2.content
					local style = var_6_2.style
					local num = content.bar_fill_threashold * easeCubic
					local current_score_bg = style.current_score_bg

					current_score_bg.offset[1] = current_score_bg.default_offset[1] + (content.bar_size[1] - content.score_size[1] - 50) * math.max(0, num)

					local current_score_frame = style.current_score_frame

					current_score_frame.offset[1] = current_score_frame.default_offset[1] + (content.bar_size[1] - content.score_size[1] - 50) * math.max(0, num)

					local current_score = style.current_score

					current_score.offset[1] = current_score.default_offset[1] + (content.bar_size[1] - content.score_size[1] - 50) * math.max(0, num)
					content.current_bar_fil_threshold = num
				end
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end
		},
		{
			name = "total_score_progress",
			start_progress = 1.3,
			end_progress = 2.5,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				return
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				-- function 9
				local easeCubic = math.easeCubic(arg_9_3)

				for i = 1, 2 do
					local var_9_1 = arg_9_2["team_" .. i .. "_total_score"]
					local content = var_9_1.content
					local style = var_9_1.style
					local num = content.bar_fill_threashold * easeCubic
					local current_score_background = style.current_score_background

					current_score_background.offset[1] = current_score_background.default_offset[1] + (content.bar_size[1] - content.current_score_size[1] - 65) * math.max(0, num)

					local gold_frame = style.gold_frame

					gold_frame.offset[1] = gold_frame.default_offset[1] + (content.bar_size[1] - content.current_score_size[1] - 65) * math.max(0, num)

					local left_detail_w = style.left_detail_w

					left_detail_w.offset[1] = left_detail_w.default_offset[1] + (content.bar_size[1] - content.current_score_size[1] - 65) * math.max(0, num)

					local right_detail_w = style.right_detail_w

					right_detail_w.offset[1] = right_detail_w.default_offset[1] + (content.bar_size[1] - content.current_score_size[1] - 65) * math.max(0, num)

					local bronze_frame = style.bronze_frame

					bronze_frame.offset[1] = bronze_frame.default_offset[1] + (content.bar_size[1] - content.current_score_size[1] - 65) * math.max(0, num)

					local left_detail_l = style.left_detail_l

					left_detail_l.offset[1] = left_detail_l.default_offset[1] + (content.bar_size[1] - content.current_score_size[1] - 65) * math.max(0, num)

					local right_detail_l = style.right_detail_l

					right_detail_l.offset[1] = right_detail_l.default_offset[1] + (content.bar_size[1] - content.current_score_size[1] - 65) * math.max(0, num)

					local current_score = style.current_score

					current_score.offset[1] = current_score.default_offset[1] + (content.bar_size[1] - content.current_score_size[1] - 65) * math.max(0, num)
					content.current_score_text = math.floor(content.current_score * easeCubic)
					content.current_bar_fil_threshold = num
				end
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 9.5,
			end_progress = 10,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				return
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				-- function 12
				local num = 1 - math.easeInCubic(arg_12_3)

				arg_12_4.draw_flags.alpha_multiplier = num
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end
		}
	}
}

return {
	scenegraph_definition = tbl,
	widget_definitions = tbl_7,
	animation_definitions = tbl_8
}
