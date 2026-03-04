-- chunkname: @scripts/ui/views/versus_menu/versus_team_parading_view_v2_definitions.lua

local var_0_0 = {
	474,
	46
}
local var_0_1 = {
	screen = {
		0,
		0,
		UILayer.default
	},
	bottom_bar = {
		0,
		0,
		10
	},
	bottom_bar_detail = {
		0,
		0,
		1
	},
	top_bar_detail = {
		0,
		-20,
		1
	},
	center_pivot = {
		0,
		0,
		1
	},
	player_portrait_anchor_1 = {
		528,
		200,
		20
	},
	player_portrait_anchor_2 = {
		816,
		200,
		20
	},
	player_portrait_anchor_3 = {
		1104,
		200,
		20
	},
	player_portrait_anchor_4 = {
		1392,
		200,
		20
	},
	player_insignia_anchor_1 = {
		-523,
		80,
		40
	},
	player_insignia_anchor_2 = {
		-235,
		80,
		40
	},
	player_insignia_anchor_3 = {
		55,
		80,
		40
	},
	player_insignia_anchor_4 = {
		343,
		80,
		40
	}
}
local var_0_2 = {
	screen = {
		1920,
		1080
	},
	bottom_bar = {
		1920,
		250
	},
	bottom_bar_detail = {
		1860,
		14
	},
	top_bar_detail = {
		1860,
		14
	},
	center_pivot = {
		0,
		0
	},
	player_portrait_anchor_1 = player_portrait_anchor_size,
	player_portrait_anchor_2 = player_portrait_anchor_size,
	player_portrait_anchor_3 = player_portrait_anchor_size,
	player_portrait_anchor_4 = player_portrait_anchor_size,
	player_insignia_anchor_1 = player_portrait_anchor_size,
	player_insignia_anchor_2 = player_portrait_anchor_size,
	player_insignia_anchor_3 = player_portrait_anchor_size,
	player_insignia_anchor_4 = player_portrait_anchor_size
}
local var_0_3 = {
	screen = {
		scale = "fit",
		size = var_0_2.screen,
		position = var_0_1.screen
	},
	bottom_bar = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		horizontal_alignment = "center",
		size = var_0_2.bottom_bar,
		position = var_0_1.bottom_bar
	},
	bottom_bar_detail = {
		vertical_alignment = "top",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_2.bottom_bar_detail,
		position = var_0_1.bottom_bar_detail
	},
	top_bar_detail = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = var_0_2.top_bar_detail,
		position = var_0_1.top_bar_detail
	},
	center_pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = var_0_2.center_pivot,
		position = var_0_1.center_pivot
	},
	player_portrait_anchor_1 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_2.player_portrait_anchor_1,
		position = var_0_1.player_portrait_anchor_1
	},
	player_portrait_anchor_2 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_2.player_portrait_anchor_2,
		position = var_0_1.player_portrait_anchor_2
	},
	player_portrait_anchor_3 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_2.player_portrait_anchor_3,
		position = var_0_1.player_portrait_anchor_3
	},
	player_portrait_anchor_4 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_2.player_portrait_anchor_4,
		position = var_0_1.player_portrait_anchor_4
	},
	player_insignia_anchor_1 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_2.player_insignia_anchor_1,
		position = var_0_1.player_insignia_anchor_1
	},
	player_insignia_anchor_2 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_2.player_insignia_anchor_2,
		position = var_0_1.player_insignia_anchor_2
	},
	player_insignia_anchor_3 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_2.player_insignia_anchor_3,
		position = var_0_1.player_insignia_anchor_3
	},
	player_insignia_anchor_4 = {
		vertical_alignment = "center",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_2.player_insignia_anchor_4,
		position = var_0_1.player_insignia_anchor_4
	}
}
local var_0_4 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	font_size = 72,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("local_player_team", 0),
	offset = {
		0,
		-10,
		2
	}
}

function create_rotated_texture(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	return {
		alpha_multiplier = 0,
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "rotated_texture"
				}
			}
		},
		content = {
			texture_id = arg_1_0
		},
		style = {
			texture_id = {
				angle = arg_1_1,
				pivot = arg_1_3,
				color = arg_1_5 or {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					arg_1_6 or 0
				},
				texture_size = arg_1_2
			}
		},
		offset = arg_1_7 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_4
	}
end

function create_player_name_career_text(arg_2_0)
	return {
		element = {
			passes = {
				{
					style_id = "player_name",
					pass_type = "text",
					text_id = "player_name"
				},
				{
					style_id = "career_name",
					pass_type = "text",
					text_id = "career_name"
				}
			}
		},
		content = {
			career_name = "n/a",
			player_name = "n/a"
		},
		style = {
			player_name = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 28,
				use_shadow = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("local_player_team_lighter", 255),
				offset = {
					0,
					0,
					2
				}
			},
			career_name = {
				word_wrap = true,
				upper_case = false,
				localize = true,
				font_size = 24,
				use_shadow = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					-30,
					2
				}
			}
		},
		scenegraph_id = arg_2_0,
		offset = {
			-960,
			0,
			10
		}
	}
end

local var_0_5 = {
	bottom_background = UIWidgets.create_simple_rect("bottom_bar", Colors.get_color_table_with_alpha("black", 100)),
	bottom_background_detail = UIWidgets.create_parading_screen_divider("bottom_bar_detail", var_0_3.bottom_bar_detail.size)
}
local var_0_6 = {
	top_background_detail = UIWidgets.create_parading_screen_divider("top_bar_detail", var_0_3.top_bar_detail.size),
	team_flag = UIWidgets.create_simple_texture("banner_hammers_local_long", "top_bar_detail", nil, nil, {
		255,
		255,
		255,
		255
	}, {
		50,
		-252,
		0
	}, {
		232,
		484
	})
}
local var_0_7 = {
	512,
	512
}
local var_0_8 = {
	-var_0_7[1] / 2,
	-var_0_7[1] / 2,
	0
}
local var_0_9 = {
	2300,
	50
}
local var_0_10 = {
	2300,
	500
}
local var_0_11 = {
	-1160,
	250,
	0
}
local var_0_12 = {
	-1160,
	-300,
	0
}
local var_0_13 = {
	background = UIWidgets.create_simple_rect("screen", Colors.get_color_table_with_alpha("black", 255))
}
local var_0_14 = {
	level_name = "levels/carousel_podium/world"
}
local var_0_15 = {
	on_enter_local_player = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				local var_3_0 = arg_3_3.self
				local var_3_1 = var_3_0._bottom_widgets
				local var_3_2 = var_3_0._team_portrait_frame_widgets
				local var_3_3 = var_3_0._top_widgets
				local var_3_4 = var_3_0._player_name_widgets
				local var_3_5 = var_3_0._team_insignia_widgets

				for iter_3_0, iter_3_1 in ipairs(var_3_1) do
					iter_3_1.alpha_multiplier = 0
				end

				for iter_3_2, iter_3_3 in ipairs(var_3_2) do
					iter_3_3.alpha_multiplier = 0
				end

				for iter_3_4, iter_3_5 in ipairs(var_3_5) do
					iter_3_5.alpha_multiplier = 0
				end

				for iter_3_6, iter_3_7 in ipairs(var_3_3) do
					iter_3_7.alpha_multiplier = 0
				end

				for iter_3_8, iter_3_9 in ipairs(var_3_3) do
					iter_3_9.alpha_multiplier = 0
				end
			end,
			update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
				local var_4_0 = math.easeOutCubic(arg_4_3)
				local var_4_1 = arg_4_4.self
				local var_4_2 = var_4_1._bottom_widgets
				local var_4_3 = var_4_1._team_portrait_frame_widgets
				local var_4_4 = var_4_1._top_widgets
				local var_4_5 = var_4_1._team_insignia_widgets

				for iter_4_0, iter_4_1 in ipairs(var_4_2) do
					iter_4_1.alpha_multiplier = var_4_0
				end

				for iter_4_2, iter_4_3 in ipairs(var_4_3) do
					iter_4_3.alpha_multiplier = var_4_0
				end

				for iter_4_4, iter_4_5 in ipairs(var_4_5) do
					iter_4_5.alpha_multiplier = var_4_0
				end

				for iter_4_6, iter_4_7 in ipairs(var_4_4) do
					iter_4_7.alpha_multiplier = var_4_0
				end

				for iter_4_8, iter_4_9 in ipairs(var_4_4) do
					iter_4_9.alpha_multiplier = var_4_0
				end
			end,
			on_complete = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				local var_5_0 = arg_5_3.self._transition_widgets

				for iter_5_0, iter_5_1 in ipairs(var_5_0) do
					iter_5_1.alpha_multiplier = 0
				end
			end
		},
		{
			name = "slide_up_bottom_widgets",
			start_progress = 0,
			end_progress = 0.8,
			init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end,
			update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				local var_7_0 = math.easeOutCubic(arg_7_3)
				local var_7_1 = arg_7_4.self
				local var_7_2 = var_7_1._bottom_widgets
				local var_7_3 = var_7_1._team_portrait_frame_widgets
				local var_7_4 = var_7_1._team_insignia_widgets
				local var_7_5 = var_7_1._player_name_widgets

				for iter_7_0, iter_7_1 in ipairs(var_7_2) do
					local var_7_6 = -250 + 250 * var_7_0

					iter_7_1.offset[2] = var_7_6
				end

				for iter_7_2, iter_7_3 in ipairs(var_7_3) do
					local var_7_7 = -200 + 200 * var_7_0

					iter_7_3.offset[2] = var_7_7
				end

				for iter_7_4, iter_7_5 in ipairs(var_7_4) do
					local var_7_8 = -200 + 200 * var_7_0

					iter_7_5.offset[2] = var_7_8
				end

				for iter_7_6, iter_7_7 in ipairs(var_7_5) do
					local var_7_9 = -270 + 50 * var_7_0

					iter_7_7.offset[2] = var_7_9
				end
			end,
			on_complete = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				return
			end
		},
		{
			name = "slide_in_top_widgets",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end,
			update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				local var_10_0 = math.easeOutCubic(arg_10_3)
				local var_10_1 = math.ease_out_quad(arg_10_3)
				local var_10_2 = arg_10_4.self
				local var_10_3 = var_10_2._widgets_by_name.top_background_detail
				local var_10_4 = var_10_2._widgets_by_name.team_flag
				local var_10_5 = 1920 - 1920 * var_10_0

				var_10_3.offset[1] = var_10_5

				local var_10_6 = -480 + 480 * (1 - var_10_0)

				var_10_4.offset[2] = var_10_6
			end,
			on_complete = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				return
			end
		}
	},
	team_transition_fade_in = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.25,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				local var_12_0 = arg_12_3.self
				local var_12_1 = var_12_0._bottom_widgets
				local var_12_2 = var_12_0._transition_widgets
				local var_12_3 = var_12_0._top_widgets

				for iter_12_0, iter_12_1 in ipairs(var_12_1) do
					iter_12_1.alpha_multiplier = 0
				end

				for iter_12_2, iter_12_3 in ipairs(var_12_2) do
					iter_12_3.alpha_multiplier = 0
				end

				for iter_12_4, iter_12_5 in ipairs(var_12_3) do
					iter_12_5.alpha_multiplier = 0
				end
			end,
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				local var_13_0 = math.easeOutCubic(arg_13_3)
				local var_13_1 = arg_13_4.self._transition_widgets

				for iter_13_0, iter_13_1 in ipairs(var_13_1) do
					iter_13_1.alpha_multiplier = var_13_0
				end
			end,
			on_complete = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				return
			end
		},
		{
			name = "slide_in",
			start_progress = 0,
			end_progress = 0.25,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				return
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				return
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				local var_17_0 = arg_17_3.self
				local var_17_1 = var_17_0._opponents_party_data

				var_17_0:_change_team_info(var_17_1)
			end
		}
	},
	on_enter_opponent_team = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				local var_18_0 = arg_18_3.self
				local var_18_1 = var_18_0._bottom_widgets
				local var_18_2 = var_18_0._team_portrait_frame_widgets
				local var_18_3 = var_18_0._player_name_widgets
				local var_18_4 = var_18_0._team_insignia_widgets

				for iter_18_0, iter_18_1 in ipairs(var_18_1) do
					iter_18_1.alpha_multiplier = 0
				end

				for iter_18_2, iter_18_3 in ipairs(var_18_2) do
					iter_18_3.alpha_multiplier = 0
				end

				for iter_18_4, iter_18_5 in ipairs(var_18_4) do
					iter_18_5.alpha_multiplier = 0
				end

				for iter_18_6, iter_18_7 in ipairs(var_18_3) do
					iter_18_7.alpha_multiplier = 0
				end
			end,
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				local var_19_0 = math.easeOutCubic(arg_19_3)
				local var_19_1 = arg_19_4.self
				local var_19_2 = arg_19_4.self
				local var_19_3 = var_19_2._bottom_widgets
				local var_19_4 = var_19_2._team_portrait_frame_widgets
				local var_19_5 = var_19_2._top_widgets
				local var_19_6 = var_19_2._player_name_widgets
				local var_19_7 = var_19_2._team_insignia_widgets

				for iter_19_0, iter_19_1 in ipairs(var_19_3) do
					iter_19_1.alpha_multiplier = var_19_0
				end

				for iter_19_2, iter_19_3 in ipairs(var_19_4) do
					iter_19_3.alpha_multiplier = var_19_0
				end

				for iter_19_4, iter_19_5 in ipairs(var_19_7) do
					iter_19_5.alpha_multiplier = var_19_0
				end

				for iter_19_6, iter_19_7 in ipairs(var_19_5) do
					iter_19_7.alpha_multiplier = var_19_0
				end

				for iter_19_8, iter_19_9 in ipairs(var_19_6) do
					iter_19_9.alpha_multiplier = var_19_0
				end
			end,
			on_complete = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end
		},
		{
			name = "slide_up_bottom_widgets",
			start_progress = 0,
			end_progress = 0.8,
			init = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				return
			end,
			update = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				local var_22_0 = math.easeOutCubic(arg_22_3)
				local var_22_1 = arg_22_4.self
				local var_22_2 = var_22_1._bottom_widgets
				local var_22_3 = var_22_1._team_portrait_frame_widgets
				local var_22_4 = var_22_1._player_name_widgets
				local var_22_5 = var_22_1._team_insignia_widgets

				for iter_22_0, iter_22_1 in ipairs(var_22_2) do
					local var_22_6 = -250 + 250 * var_22_0

					iter_22_1.offset[2] = var_22_6
				end

				for iter_22_2, iter_22_3 in ipairs(var_22_3) do
					local var_22_7 = -200 + 200 * var_22_0

					iter_22_3.offset[2] = var_22_7
				end

				for iter_22_4, iter_22_5 in ipairs(var_22_5) do
					local var_22_8 = -200 + 200 * var_22_0

					iter_22_5.offset[2] = var_22_8
				end

				for iter_22_6, iter_22_7 in ipairs(var_22_4) do
					local var_22_9 = -270 + 50 * var_22_0

					iter_22_7.offset[2] = var_22_9
				end
			end,
			on_complete = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				return
			end
		},
		{
			name = "slide_in_top_widgets",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				return
			end,
			update = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				local var_25_0 = math.easeOutCubic(arg_25_3)
				local var_25_1 = math.ease_out_quad(arg_25_3)
				local var_25_2 = arg_25_4.self
				local var_25_3 = var_25_2._widgets_by_name.top_background_detail
				local var_25_4 = var_25_2._widgets_by_name.team_flag
				local var_25_5 = var_25_2._ui_top_renderer
				local var_25_6 = 0 + -3840 * (1 - var_25_0)

				var_25_3.offset[1] = var_25_6

				local var_25_7 = -480 + 480 * (1 - var_25_0)

				var_25_4.offset[2] = var_25_7
			end,
			on_complete = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				return
			end
		}
	},
	team_transition_fade_out = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.25,
			init = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				return
			end,
			update = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				local var_28_0 = math.easeOutCubic(arg_28_3)
				local var_28_1 = arg_28_4.self._transition_widgets

				for iter_28_0, iter_28_1 in ipairs(var_28_1) do
					iter_28_1.alpha_multiplier = 1 - var_28_0
				end
			end,
			on_complete = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				arg_30_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
				local var_31_0 = math.easeOutCubic(arg_31_3)

				arg_31_4.render_settings.alpha_multiplier = 1 - var_31_0
			end,
			on_complete = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				return
			end
		}
	}
}

return {
	scenegraph_definition = var_0_3,
	bottom_widgets_definitions = var_0_5,
	top_widgets_definitions = var_0_6,
	animation_definitions = var_0_15,
	transition_widget_definitions = var_0_13,
	create_player_name_career_text = create_player_name_career_text,
	view_settings = var_0_14
}
