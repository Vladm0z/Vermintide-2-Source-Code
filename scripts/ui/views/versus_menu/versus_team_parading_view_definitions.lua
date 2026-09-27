-- chunkname: @scripts/ui/views/versus_menu/versus_team_parading_view_definitions.lua

local tbl = {
	400,
	640
}
local num = 50
local tbl_2 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.transition
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
			UILayer.transition
		}
	},
	root_center_pivot = {
		vertical_alignment = "center",
		parent = "root_fit",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	background_banner = {
		vertical_alignment = "center",
		parent = "root_fit",
		scale = "fit_width",
		horizontal_alignment = "left",
		size = {
			1920,
			tbl[2] + 100
		},
		position = {
			0,
			0,
			1
		}
	},
	player_1 = {
		vertical_alignment = "center",
		parent = "root_center_pivot",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			tbl[2]
		},
		position = {
			-(tbl[1] + num) * 1.5,
			0,
			3
		}
	},
	player_2 = {
		vertical_alignment = "center",
		parent = "root_center_pivot",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			tbl[2]
		},
		position = {
			-(tbl[1] / 2 + num / 2),
			0,
			3
		}
	},
	player_3 = {
		vertical_alignment = "center",
		parent = "root_center_pivot",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			tbl[2]
		},
		position = {
			tbl[1] / 2 + num / 2,
			0,
			3
		}
	},
	player_4 = {
		vertical_alignment = "center",
		parent = "root_center_pivot",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			tbl[2]
		},
		position = {
			(tbl[1] + num) * 1.5,
			0,
			3
		}
	},
	team_title = {
		vertical_alignment = "center",
		parent = "root_center_pivot",
		horizontal_alignment = "center",
		size = {
			800,
			60
		},
		position = {
			0,
			500,
			4
		}
	},
	team_name = {
		vertical_alignment = "center",
		parent = "root_center_pivot",
		horizontal_alignment = "center",
		size = {
			800,
			60
		},
		position = {
			0,
			420,
			4
		}
	},
	round_title = {
		vertical_alignment = "center",
		parent = "root_center_pivot",
		horizontal_alignment = "center",
		size = {
			800,
			60
		},
		position = {
			0,
			0,
			10
		}
	},
	timer_title = {
		vertical_alignment = "center",
		parent = "root_center_pivot",
		horizontal_alignment = "center",
		size = {
			800,
			60
		},
		position = {
			0,
			-430,
			4
		}
	},
	screen_timer_area = {
		vertical_alignment = "center",
		parent = "root_center_pivot",
		horizontal_alignment = "center",
		size = {
			2200,
			800
		},
		position = {
			0,
			-470,
			8
		}
	}
}
local tbl_3 = {
	word_wrap = true,
	font_size = 64,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
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
	vertical_alignment = "bottom",
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
	font_size = 64,
	localize = false,
	use_shadow = true,
	default_font_size = 64,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	max_font_size = 450,
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
	font_size = 500,
	localize = false,
	use_shadow = true,
	default_font_size = 500,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	max_font_size = 1200,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 100),
	offset = {
		0,
		0,
		0
	}
}
local tbl_7 = {
	word_wrap = true,
	font_size = 36,
	localize = false,
	use_shadow = true,
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
local tbl_8 = {
	word_wrap = true,
	font_size = 172,
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
local str = "frame_outer_glow_01"
local var_0_10 = UIFrameSettings[str].texture_sizes.horizontal[2]
local tbl_9 = {
	-var_0_10,
	-var_0_10
}
local tbl_10 = {
	background = UIWidgets.create_simple_rect("root_fit", {
		180,
		0,
		0,
		0
	}),
	background_banner = UIWidgets.create_tiled_texture("background_banner", "quests_background", {
		50,
		156
	}, nil, nil, {
		255,
		200,
		200,
		200
	}),
	background_frame = UIWidgets.create_frame("background_banner", tbl_2.background_banner.size, str, 3, {
		255,
		0,
		0,
		0
	}, tbl_9)
}
local tbl_11 = {
	round_title = UIWidgets.create_simple_text("", "round_title", nil, nil, tbl_8),
	timer_title = UIWidgets.create_simple_text(Localize("vote_timer_game_start"), "timer_title", nil, nil, tbl_7),
	screen_timer_text = UIWidgets.create_simple_text("", "screen_timer_area", nil, nil, tbl_5),
	screen_timer_text_big = UIWidgets.create_simple_text("", "screen_timer_area", nil, nil, tbl_6),
	team_name_text = UIWidgets.create_simple_text("", "team_name", nil, nil, tbl_3),
	team_title = UIWidgets.create_simple_text("Starting As Heroes", "team_title", nil, nil, tbl_4)
}
local tbl_12 = {
	start = {
		{
			name = "background_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				arg_1_3.render_settings.alpha_multiplier = 0
				arg_1_2.screen_timer_text_big.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeInCubic = math.easeInCubic(arg_2_3)

				arg_2_2.background.alpha_multiplier = easeInCubic
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		},
		{
			name = "round_title_in",
			start_progress = 0.5,
			end_progress = 2,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				if not arg_5_4.round_title_sound_played then
					WwiseWorld.trigger_event(arg_5_4.wwise_world, "play_gui_mission_summary_level_up")

					arg_5_4.round_title_sound_played = true
				end

				local easeOutCubic = math.easeOutCubic(1 - arg_5_3)
				local round_title = arg_5_2.round_title

				round_title.offset[1] = -(50 + 720 * easeOutCubic)
				round_title.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		},
		{
			name = "round_title_move",
			start_progress = 2,
			end_progress = 4,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				arg_8_2.round_title.offset[1] = -50 + 50 * math.ease_out_exp(arg_8_3)
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		},
		{
			name = "round_title_out",
			start_progress = 3,
			end_progress = 4,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local round_title = arg_11_2.round_title
				local offset = round_title.offset
				local ease_in_exp = math.ease_in_exp(arg_11_3)

				offset[1] = offset[1] + 770 * ease_in_exp
				round_title.alpha_multiplier = 1 - ease_in_exp
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				return
			end
		},
		{
			name = "banner_expand",
			start_progress = 3.5,
			end_progress = 4.5,
			init = function (self, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				local str = "background_banner"
				local var_13_1 = self[str]
				local var_13_2 = arg_13_1[str]

				var_13_1.size[2] = 0
			end,
			update = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				local easeCubic = math.easeCubic(arg_14_3)
				local str = "background_banner"
				local var_14_2 = self[str]
				local var_14_3 = arg_14_1[str]

				var_14_2.size[2] = var_14_3.size[2] * easeCubic
				arg_14_2.background_banner.alpha_multiplier = easeCubic
				arg_14_2.background_frame.alpha_multiplier = easeCubic
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				return
			end
		},
		{
			name = "widgets_fade_in",
			start_progress = 4.6,
			end_progress = 4.9,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				arg_16_3.render_settings.alpha_multiplier = 0
				arg_16_3.show_diorama = true
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				local easeInCubic = math.easeInCubic(arg_17_3)

				arg_17_4.render_settings.alpha_multiplier = easeInCubic

				local diorama_list = arg_17_4.diorama_list

				if not diorama_list then
					local show_diorama = arg_17_4.show_diorama
					local num = 0.5

					for i = 1, #diorama_list do
						local var_17_4 = diorama_list[i]

						if not show_diorama then
							var_17_4:set_viewport_active(true)
							var_17_4:fade_in(num)
						end

						var_17_4:update_position()
					end

					arg_17_4.show_diorama = false
				end
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				arg_18_2.background_banner.alpha_multiplier = nil
				arg_18_2.background_frame.alpha_multiplier = nil
			end
		},
		{
			name = "fade_out",
			start_progress = 7.5,
			end_progress = 8,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				return
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				Managers.transition:fade_in(1.5)
			end
		},
		{
			name = "screen_move_out",
			start_progress = 8.5,
			end_progress = 9.5,
			init = function (self, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				local str = "screen_timer_area"
				local var_22_1 = self[str]
				local var_22_2 = arg_22_1[str]

				var_22_1.local_position[2] = var_22_2.position[2]
				arg_22_3.hide_diorama = true
			end,
			update = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				-- function 23
				local diorama_list = arg_23_4.diorama_list

				if not diorama_list then
					local hide_diorama = arg_23_4.hide_diorama
					local num = 0.5

					for i = 1, #diorama_list do
						local var_23_3 = diorama_list[i]

						if not hide_diorama then
							var_23_3:fade_out(num)
						end

						var_23_3:update_position()
					end

					arg_23_4.hide_diorama = false
				end

				local easeOutCubic = math.easeOutCubic(arg_23_3)
				local str = "screen_timer_area"
				local var_23_6 = self[str]
				local var_23_7 = arg_23_1[str]

				var_23_6.local_position[2] = var_23_7.position[2] + 490 * easeOutCubic
				arg_23_4.render_settings.alpha_multiplier = math.easeInCubic(1 - easeOutCubic)

				local screen_timer_text = arg_23_2.screen_timer_text

				screen_timer_text.alpha_multiplier = 1

				local style = screen_timer_text.style
				local text = style.text
				local text_shadow = style.text_shadow
				local default_font_size = text.default_font_size
				local num_2 = default_font_size + (text.max_font_size - default_font_size) * easeOutCubic

				text.font_size = num_2
				text_shadow.font_size = num_2
			end,
			on_complete = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				-- function 24
				arg_24_2.screen_timer_text_big.alpha_multiplier = 1
			end
		}
	}
}

return {
	DIORAMA_SIZE = tbl,
	animations = tbl_12,
	scenegraph_definition = tbl_2,
	widget_definitions = tbl_10,
	top_widget_definitions = tbl_11
}
