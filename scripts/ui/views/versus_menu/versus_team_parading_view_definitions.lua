-- chunkname: @scripts/ui/views/versus_menu/versus_team_parading_view_definitions.lua

local var_0_0 = {
	400,
	640
}
local var_0_1 = 50
local var_0_2 = {
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
			var_0_0[2] + 100
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
			var_0_0[1],
			var_0_0[2]
		},
		position = {
			-(var_0_0[1] + var_0_1) * 1.5,
			0,
			3
		}
	},
	player_2 = {
		vertical_alignment = "center",
		parent = "root_center_pivot",
		horizontal_alignment = "center",
		size = {
			var_0_0[1],
			var_0_0[2]
		},
		position = {
			-(var_0_0[1] / 2 + var_0_1 / 2),
			0,
			3
		}
	},
	player_3 = {
		vertical_alignment = "center",
		parent = "root_center_pivot",
		horizontal_alignment = "center",
		size = {
			var_0_0[1],
			var_0_0[2]
		},
		position = {
			var_0_0[1] / 2 + var_0_1 / 2,
			0,
			3
		}
	},
	player_4 = {
		vertical_alignment = "center",
		parent = "root_center_pivot",
		horizontal_alignment = "center",
		size = {
			var_0_0[1],
			var_0_0[2]
		},
		position = {
			(var_0_0[1] + var_0_1) * 1.5,
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
local var_0_3 = {
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
local var_0_4 = {
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
local var_0_5 = {
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
local var_0_6 = {
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
local var_0_7 = {
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
local var_0_8 = {
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
local var_0_9 = "frame_outer_glow_01"
local var_0_10 = UIFrameSettings[var_0_9].texture_sizes.horizontal[2]
local var_0_11 = {
	-var_0_10,
	-var_0_10
}
local var_0_12 = {
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
	background_frame = UIWidgets.create_frame("background_banner", var_0_2.background_banner.size, var_0_9, 3, {
		255,
		0,
		0,
		0
	}, var_0_11)
}
local var_0_13 = {
	round_title = UIWidgets.create_simple_text("", "round_title", nil, nil, var_0_8),
	timer_title = UIWidgets.create_simple_text(Localize("vote_timer_game_start"), "timer_title", nil, nil, var_0_7),
	screen_timer_text = UIWidgets.create_simple_text("", "screen_timer_area", nil, nil, var_0_5),
	screen_timer_text_big = UIWidgets.create_simple_text("", "screen_timer_area", nil, nil, var_0_6),
	team_name_text = UIWidgets.create_simple_text("", "team_name", nil, nil, var_0_3),
	team_title = UIWidgets.create_simple_text("Starting As Heroes", "team_title", nil, nil, var_0_4)
}
local var_0_14 = {
	start = {
		{
			name = "background_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
				arg_1_2.screen_timer_text_big.alpha_multiplier = 0
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeInCubic(arg_2_3)

				arg_2_2.background.alpha_multiplier = var_2_0
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		},
		{
			name = "round_title_in",
			start_progress = 0.5,
			end_progress = 2,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				if not arg_5_4.round_title_sound_played then
					WwiseWorld.trigger_event(arg_5_4.wwise_world, "play_gui_mission_summary_level_up")

					arg_5_4.round_title_sound_played = true
				end

				local var_5_0 = math.easeOutCubic(1 - arg_5_3)
				local var_5_1 = arg_5_2.round_title

				var_5_1.offset[1] = -(50 + 720 * var_5_0)
				var_5_1.alpha_multiplier = 1 - var_5_0
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		},
		{
			name = "round_title_move",
			start_progress = 2,
			end_progress = 4,
			init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end,
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				arg_8_2.round_title.offset[1] = -50 + 50 * math.ease_out_exp(arg_8_3)
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		},
		{
			name = "round_title_out",
			start_progress = 3,
			end_progress = 4,
			init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end,
			update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				local var_11_0 = arg_11_2.round_title
				local var_11_1 = var_11_0.offset
				local var_11_2 = math.ease_in_exp(arg_11_3)

				var_11_1[1] = var_11_1[1] + 770 * var_11_2
				var_11_0.alpha_multiplier = 1 - var_11_2
			end,
			on_complete = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end
		},
		{
			name = "banner_expand",
			start_progress = 3.5,
			end_progress = 4.5,
			init = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				local var_13_0 = "background_banner"
				local var_13_1 = arg_13_0[var_13_0]
				local var_13_2 = arg_13_1[var_13_0]

				var_13_1.size[2] = 0
			end,
			update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				local var_14_0 = math.easeCubic(arg_14_3)
				local var_14_1 = "background_banner"
				local var_14_2 = arg_14_0[var_14_1]
				local var_14_3 = arg_14_1[var_14_1]

				var_14_2.size[2] = var_14_3.size[2] * var_14_0
				arg_14_2.background_banner.alpha_multiplier = var_14_0
				arg_14_2.background_frame.alpha_multiplier = var_14_0
			end,
			on_complete = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				return
			end
		},
		{
			name = "widgets_fade_in",
			start_progress = 4.6,
			end_progress = 4.9,
			init = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				arg_16_3.render_settings.alpha_multiplier = 0
				arg_16_3.show_diorama = true
			end,
			update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				local var_17_0 = math.easeInCubic(arg_17_3)

				arg_17_4.render_settings.alpha_multiplier = var_17_0

				local var_17_1 = arg_17_4.diorama_list

				if var_17_1 then
					local var_17_2 = arg_17_4.show_diorama
					local var_17_3 = 0.5

					for iter_17_0 = 1, #var_17_1 do
						local var_17_4 = var_17_1[iter_17_0]

						if var_17_2 then
							var_17_4:set_viewport_active(true)
							var_17_4:fade_in(var_17_3)
						end

						var_17_4:update_position()
					end

					arg_17_4.show_diorama = false
				end
			end,
			on_complete = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				arg_18_2.background_banner.alpha_multiplier = nil
				arg_18_2.background_frame.alpha_multiplier = nil
			end
		},
		{
			name = "fade_out",
			start_progress = 7.5,
			end_progress = 8,
			init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end,
			update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				return
			end,
			on_complete = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				Managers.transition:fade_in(1.5)
			end
		},
		{
			name = "screen_move_out",
			start_progress = 8.5,
			end_progress = 9.5,
			init = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				local var_22_0 = "screen_timer_area"
				local var_22_1 = arg_22_0[var_22_0]
				local var_22_2 = arg_22_1[var_22_0]

				var_22_1.local_position[2] = var_22_2.position[2]
				arg_22_3.hide_diorama = true
			end,
			update = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				local var_23_0 = arg_23_4.diorama_list

				if var_23_0 then
					local var_23_1 = arg_23_4.hide_diorama
					local var_23_2 = 0.5

					for iter_23_0 = 1, #var_23_0 do
						local var_23_3 = var_23_0[iter_23_0]

						if var_23_1 then
							var_23_3:fade_out(var_23_2)
						end

						var_23_3:update_position()
					end

					arg_23_4.hide_diorama = false
				end

				local var_23_4 = math.easeOutCubic(arg_23_3)
				local var_23_5 = "screen_timer_area"
				local var_23_6 = arg_23_0[var_23_5]
				local var_23_7 = arg_23_1[var_23_5]

				var_23_6.local_position[2] = var_23_7.position[2] + 490 * var_23_4
				arg_23_4.render_settings.alpha_multiplier = math.easeInCubic(1 - var_23_4)

				local var_23_8 = arg_23_2.screen_timer_text

				var_23_8.alpha_multiplier = 1

				local var_23_9 = var_23_8.style
				local var_23_10 = var_23_9.text
				local var_23_11 = var_23_9.text_shadow
				local var_23_12 = var_23_10.default_font_size
				local var_23_13 = var_23_12 + (var_23_10.max_font_size - var_23_12) * var_23_4

				var_23_10.font_size = var_23_13
				var_23_11.font_size = var_23_13
			end,
			on_complete = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				arg_24_2.screen_timer_text_big.alpha_multiplier = 1
			end
		}
	}
}

return {
	DIORAMA_SIZE = var_0_0,
	animations = var_0_14,
	scenegraph_definition = var_0_2,
	widget_definitions = var_0_12,
	top_widget_definitions = var_0_13
}
