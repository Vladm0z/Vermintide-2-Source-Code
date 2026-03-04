-- chunkname: @scripts/ui/views/level_end/states/definitions/end_view_state_chest_definitions.lua

local var_0_0 = {
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
	chest_title = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1200,
			50
		},
		position = {
			0,
			-100,
			1
		}
	},
	chest_sub_title = {
		vertical_alignment = "top",
		parent = "chest_title",
		horizontal_alignment = "center",
		size = {
			1200,
			50
		},
		position = {
			0,
			-40,
			1
		}
	},
	upgrade_root = {
		vertical_alignment = "center",
		parent = "chest_title",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-110,
			5
		}
	},
	upgrade_background = {
		vertical_alignment = "center",
		parent = "upgrade_root",
		horizontal_alignment = "center",
		size = {
			500,
			90
		},
		position = {
			0,
			0,
			0
		}
	},
	upgrade_divider = {
		vertical_alignment = "center",
		parent = "upgrade_root",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-40,
			2
		}
	},
	upgrade_divider_glow = {
		vertical_alignment = "bottom",
		parent = "upgrade_divider",
		horizontal_alignment = "center",
		size = {
			264,
			80
		},
		position = {
			0,
			20,
			-1
		}
	},
	right_side_root = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-20,
			0,
			1
		}
	},
	left_side_root = {
		vertical_alignment = "top",
		parent = "screen",
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
	score_bar_bg = {
		vertical_alignment = "bottom",
		parent = "score_entry_window",
		horizontal_alignment = "center",
		size = {
			278,
			30
		},
		position = {
			0,
			-36,
			1
		}
	},
	score_bar = {
		vertical_alignment = "bottom",
		parent = "score_bar_bg",
		horizontal_alignment = "left",
		size = {
			278,
			30
		},
		position = {
			0,
			0,
			2
		}
	},
	score_bar_edge = {
		vertical_alignment = "center",
		parent = "score_bar",
		horizontal_alignment = "right",
		size = {
			35,
			30
		},
		position = {
			35,
			0,
			3
		}
	},
	background = {
		vertical_alignment = "bottom",
		parent = "score_bar_bg",
		horizontal_alignment = "center",
		size = {
			820,
			90
		},
		position = {
			0,
			38,
			-3
		}
	},
	score_bar_fg = {
		vertical_alignment = "bottom",
		parent = "score_bar_bg",
		horizontal_alignment = "center",
		size = {
			352,
			134
		},
		position = {
			0,
			-14,
			8
		}
	},
	score_bar_start = {
		vertical_alignment = "bottom",
		parent = "score_bar_bg",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			3
		}
	},
	score_entry_texture = {
		vertical_alignment = "top",
		parent = "score_bar_bg",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			80,
			3
		}
	},
	score_entry_bg_left = {
		vertical_alignment = "center",
		parent = "score_entry_texture",
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
	score_entry_bg_right = {
		vertical_alignment = "center",
		parent = "score_entry_texture",
		horizontal_alignment = "center",
		size = {
			334,
			60
		},
		position = {
			0,
			0,
			-2
		}
	},
	score_entry_text = {
		vertical_alignment = "center",
		parent = "score_entry_texture",
		horizontal_alignment = "left",
		size = {
			800,
			40
		},
		position = {
			0,
			0,
			1
		}
	},
	score_entry_window = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			360,
			576
		},
		position = {
			50,
			50,
			1
		}
	},
	score_window_top_divider = {
		vertical_alignment = "top",
		parent = "score_entry_window",
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
	score_entry_root = {
		vertical_alignment = "top",
		parent = "score_entry_window",
		horizontal_alignment = "left",
		size = {
			300,
			100
		},
		position = {
			40,
			-10,
			1
		}
	}
}
local var_0_1 = {
	word_wrap = false,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 50,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 0),
	offset = {
		0,
		-4,
		2
	}
}
local var_0_2 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 42,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 0),
	offset = {
		0,
		0,
		2
	}
}
local var_0_3 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 0),
	offset = {
		0,
		0,
		2
	}
}
local var_0_4 = {}
local var_0_5 = 10

for iter_0_0 = 1, var_0_5 do
	var_0_4[iter_0_0] = UIWidgets.create_chest_score_entry("score_entry_root", var_0_0.score_entry_root.size, iter_0_0)
end

local var_0_6 = {
	chest_title = UIWidgets.create_simple_text("chest_title", "chest_title", nil, nil, var_0_2),
	chest_sub_title = UIWidgets.create_simple_text("chest_sub_title", "chest_sub_title", nil, nil, var_0_3),
	upgrade_background = UIWidgets.create_simple_texture("tab_menu_bg_02", "upgrade_background", nil, nil, {
		0,
		255,
		255,
		255
	}),
	upgrade_text = UIWidgets.create_simple_text(Localize("end_screen_chest_upgrade"), "upgrade_background", nil, nil, var_0_1),
	score_window_top_divider = UIWidgets.create_simple_texture("divider_01_top", "score_window_top_divider"),
	score_entry_window = UIWidgets.create_simple_texture("info_window_background", "score_entry_window"),
	score_entry_texture = UIWidgets.create_simple_texture("icons_placeholder", "score_entry_texture"),
	score_entry_bg_left = UIWidgets.create_simple_texture("tab_menu_bg_03", "score_entry_bg_left"),
	score_entry_bg_right = UIWidgets.create_simple_texture("tab_menu_bg_03", "score_entry_bg_right"),
	bar_bg = UIWidgets.create_simple_texture("chest_upgrade_bg", "score_bar_bg"),
	score_bar_edge = UIWidgets.create_simple_texture("chest_upgrade_fill_glow", "score_bar_edge"),
	score_bar = UIWidgets.create_simple_uv_texture("chest_upgrade_fill", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "score_bar"),
	score_bar_fg = UIWidgets.create_simple_texture("chest_upgrade_fg", "score_bar_fg")
}

local function var_0_7(arg_1_0)
	return {
		scenegraph_id = "score_bar_start",
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "divider"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				}
			}
		},
		content = {
			icon = arg_1_0
		},
		style = {
			divider = {
				size = {
					4,
					80
				},
				offset = {
					0,
					0,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			icon = {
				size = {
					60,
					60
				},
				offset = {
					-30,
					-65,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_8 = {
	transition_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				local var_3_0 = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = var_3_0
				arg_3_0.score_entry_window.local_position[1] = 50 - 400 * (1 - var_3_0)
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end
		}
	},
	transition_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeInCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = 1 - var_6_0
				arg_6_0.score_entry_window.local_position[1] = 50 - 400 * var_6_0
				arg_6_0.chest_title.local_position[2] = -100 + 100 * var_6_0
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		}
	},
	score_entry_add = {
		{
			name = "icon_entry",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				arg_8_3.widget.style.texture_id.color[1] = 0
				arg_8_3.enter_sound_played = false
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				if not arg_9_4.enter_sound_played then
					arg_9_4.enter_sound_played = true

					WwiseWorld.trigger_event(arg_9_4.wwise_world, "play_gui_mission_summary_chest_upgrade_topic_enter")
				end

				local var_9_0 = arg_9_4.widget.style
				local var_9_1 = math.easeInCubic(arg_9_3)
				local var_9_2 = var_9_1 * 255

				var_9_0.texture_id.color[1] = var_9_2
				var_9_0.text.text_color[1] = var_9_2
				var_9_0.text_disabled.text_color[1] = 255 - var_9_2

				local var_9_3 = Colors.color_definitions.font_default
				local var_9_4 = Colors.color_definitions.white
				local var_9_5 = var_9_0.marker.color

				Colors.lerp_color_tables(var_9_3, var_9_4, var_9_1, var_9_5)
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end
		},
		{
			name = "icon_size",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				return
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				local var_12_0 = math.ease_pulse(arg_12_3)
				local var_12_1 = arg_12_4.widget.style.texture_id
				local var_12_2 = var_12_1.texture_size
				local var_12_3 = var_12_1.default_size
				local var_12_4 = var_12_1.offset
				local var_12_5 = 10

				var_12_2[1] = var_12_3[1] + var_12_5 * var_12_0
				var_12_2[2] = var_12_3[2] + var_12_5 * var_12_0
				var_12_4[1] = -(var_12_2[1] - var_12_3[1]) * 0.5
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		}
	},
	score_presentation_start = {
		{
			name = "highlight_start",
			start_progress = 0.5,
			end_progress = 0.8,
			init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				arg_14_3.enter_sound_played = false
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				if not arg_15_4.enter_sound_played then
					arg_15_4.enter_sound_played = true

					local var_15_0 = "play_gui_mission_summary_chest_upgrade_check_0" .. arg_15_4.entry_index

					WwiseWorld.trigger_event(arg_15_4.wwise_world, var_15_0)
				end

				local var_15_1 = arg_15_4.widget
				local var_15_2 = var_15_1.style
				local var_15_3 = var_15_1.offset
				local var_15_4 = math.easeInCubic(arg_15_3)
				local var_15_5 = var_15_4 * 255
				local var_15_6 = var_15_2.texture_id_glow.color
				local var_15_7 = var_15_2.text.text_color

				var_15_6[1] = var_15_5

				local var_15_8 = Colors.color_definitions.white
				local var_15_9 = Colors.color_definitions.font_title

				Colors.lerp_color_tables(var_15_8, var_15_9, var_15_4, var_15_7)

				var_15_3[1] = var_15_4 * 20
				var_15_2.marker.offset[1] = -10 + -var_15_3[1]
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end
		}
	},
	score_presentation_end = {
		{
			name = "highlight_end",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				local var_18_0 = arg_18_4.widget
				local var_18_1 = var_18_0.style
				local var_18_2 = var_18_0.offset
				local var_18_3 = math.easeInCubic(arg_18_3)
				local var_18_4 = 255 - var_18_3 * 255
				local var_18_5 = var_18_1.texture_id.color
				local var_18_6 = var_18_1.texture_id_glow.color
				local var_18_7 = var_18_1.text.text_color

				var_18_6[1] = var_18_4

				local var_18_8 = Colors.color_definitions.font_title
				local var_18_9 = Colors.get_color_table_with_alpha("font_default", 255)
				local var_18_10 = 0.8

				var_18_9[2] = var_18_9[2] * var_18_10
				var_18_9[3] = var_18_9[3] * var_18_10
				var_18_9[4] = var_18_9[4] * var_18_10

				Colors.lerp_color_tables(var_18_8, var_18_9, var_18_3, var_18_7)
				Colors.lerp_color_tables(Colors.color_definitions.white, var_18_9, var_18_3, var_18_5)

				var_18_2[1] = 20 - var_18_3 * 20
				var_18_1.marker.offset[1] = -10 + -var_18_2[1]
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end
		},
		{
			name = "checkbox_enter",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				arg_20_3.checkbox_sound_played = false
			end,
			update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				if not arg_21_4.checkbox_sound_played then
					arg_21_4.checkbox_sound_played = true

					WwiseWorld.trigger_event(arg_21_4.wwise_world, "play_gui_mission_summary_chest_upgrade_topic_ticked")
				end

				local var_21_0 = arg_21_4.widget
				local var_21_1 = var_21_0.style
				local var_21_2 = var_21_0.offset
				local var_21_3 = math.easeOutCubic(arg_21_3)
				local var_21_4 = var_21_3 * 255

				var_21_1.checkbox.color[1] = var_21_4
				var_21_1.checkbox_shadow.color[1] = var_21_4

				local var_21_5 = var_21_1.checkbox.texture_size
				local var_21_6 = 37
				local var_21_7 = 31

				var_21_5[1] = var_21_6 + (1 - var_21_3) * var_21_6 * 2
				var_21_5[2] = var_21_7 + (1 - var_21_3) * var_21_7 * 2
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				return
			end
		}
	},
	chest_title_initialize = {
		{
			name = "fade_in",
			start_progress = 0.5,
			end_progress = 0.9,
			init = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				return
			end,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				local var_24_0 = math.easeInCubic(arg_24_3) * 255

				arg_24_2.chest_title.style.text.text_color[1] = var_24_0
				arg_24_2.chest_title.style.text_shadow.text_color[1] = var_24_0
				arg_24_2.chest_sub_title.style.text.text_color[1] = var_24_0
				arg_24_2.chest_sub_title.style.text_shadow.text_color[1] = var_24_0
			end,
			on_complete = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				return
			end
		}
	},
	chest_title_update = {
		{
			name = "upgrade_background_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				local var_26_0 = 0

				arg_26_2.upgrade_background.style.texture_id.color[1] = var_26_0
			end,
			update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				local var_27_0 = math.easeInCubic(arg_27_3)
				local var_27_1 = var_27_0 * 255

				arg_27_2.upgrade_background.style.texture_id.color[1] = var_27_1

				local var_27_2 = "upgrade_background"
				local var_27_3 = arg_27_1[var_27_2].size
				local var_27_4 = arg_27_0[var_27_2].size

				var_27_4[1] = var_27_3[1] + var_27_3[1] * (1 - var_27_0)
				var_27_4[2] = var_27_3[2] + var_27_3[2] * (1 - var_27_0)
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				return
			end
		},
		{
			name = "upgrade_text_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				local var_29_0 = 0

				arg_29_2.upgrade_text.style.text.text_color[1] = var_29_0
				arg_29_2.upgrade_text.style.text_shadow.text_color[1] = var_29_0
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				local var_30_0 = math.easeInCubic(arg_30_3)
				local var_30_1 = var_30_0 * 255
				local var_30_2 = arg_30_2.upgrade_text

				var_30_2.style.text.text_color[1] = var_30_1
				var_30_2.style.text_shadow.text_color[1] = var_30_1

				local var_30_3 = 50
				local var_30_4 = var_30_3 + (100 - var_30_3) * (1 - var_30_0)

				var_30_2.style.text.font_size = var_30_4
				var_30_2.style.text_shadow.font_size = var_30_4
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end
		},
		{
			name = "upgrade_background_fade_out",
			start_progress = 0.8,
			end_progress = 1.3,
			init = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				return
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				local var_33_0 = 255 - math.easeInCubic(arg_33_3) * 255

				arg_33_2.upgrade_background.style.texture_id.color[1] = var_33_0
			end,
			on_complete = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end
		},
		{
			name = "upgrade_text_fade_out",
			start_progress = 0.9,
			end_progress = 1.3,
			init = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				return
			end,
			update = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				local var_36_0 = 255 - math.easeInCubic(arg_36_3) * 255

				arg_36_2.upgrade_text.style.text.text_color[1] = var_36_0
				arg_36_2.upgrade_text.style.text_shadow.text_color[1] = var_36_0
			end,
			on_complete = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				return
			end
		},
		{
			name = "title_fade_in",
			start_progress = 1.2,
			end_progress = 1.6,
			init = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				local var_38_0 = 0

				arg_38_2.chest_title.style.text.text_color[1] = var_38_0
				arg_38_2.chest_title.style.text_shadow.text_color[1] = var_38_0
				arg_38_2.chest_sub_title.style.text.text_color[1] = var_38_0
				arg_38_2.chest_sub_title.style.text_shadow.text_color[1] = var_38_0
			end,
			update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				local var_39_0 = math.easeInCubic(arg_39_3) * 255

				arg_39_2.chest_title.style.text.text_color[1] = var_39_0
				arg_39_2.chest_title.style.text_shadow.text_color[1] = var_39_0
				arg_39_2.chest_sub_title.style.text.text_color[1] = var_39_0
				arg_39_2.chest_sub_title.style.text_shadow.text_color[1] = var_39_0
			end,
			on_complete = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_6,
	score_entry_widgets = var_0_4,
	scenegraph_definition = var_0_0,
	animation_definitions = var_0_8,
	create_bar_divider = var_0_7
}
