-- chunkname: @scripts/ui/views/level_end/states/definitions/end_view_state_chest_definitions.lua

local tbl = {
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
local tbl_2 = {
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
local tbl_3 = {
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
local tbl_4 = {
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
local tbl_5 = {}
local num = 10

for i = 1, num do
	tbl_5[i] = UIWidgets.create_chest_score_entry("score_entry_root", tbl.score_entry_root.size, i)
end

local tbl_6 = {
	chest_title = UIWidgets.create_simple_text("chest_title", "chest_title", nil, nil, tbl_3),
	chest_sub_title = UIWidgets.create_simple_text("chest_sub_title", "chest_sub_title", nil, nil, tbl_4),
	upgrade_background = UIWidgets.create_simple_texture("tab_menu_bg_02", "upgrade_background", nil, nil, {
		0,
		255,
		255,
		255
	}),
	upgrade_text = UIWidgets.create_simple_text(Localize("end_screen_chest_upgrade"), "upgrade_background", nil, nil, tbl_2),
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

local function fn(arg_1_0)
	-- function 1
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

local tbl_7 = {
	transition_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				local easeOutCubic = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = easeOutCubic
				arg_3_0.score_entry_window.local_position[1] = 50 - 400 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
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
				-- function 5
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				local easeInCubic = math.easeInCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = 1 - easeInCubic
				arg_6_0.score_entry_window.local_position[1] = 50 - 400 * easeInCubic
				arg_6_0.chest_title.local_position[2] = -100 + 100 * easeInCubic
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
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
				-- function 8
				arg_8_3.widget.style.texture_id.color[1] = 0
				arg_8_3.enter_sound_played = false
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				-- function 9
				if not arg_9_4.enter_sound_played then
					arg_9_4.enter_sound_played = true

					WwiseWorld.trigger_event(arg_9_4.wwise_world, "play_gui_mission_summary_chest_upgrade_topic_enter")
				end

				local style = arg_9_4.widget.style
				local easeInCubic = math.easeInCubic(arg_9_3)
				local num = easeInCubic * 255

				style.texture_id.color[1] = num
				style.text.text_color[1] = num
				style.text_disabled.text_color[1] = 255 - num

				local font_default = Colors.color_definitions.font_default
				local white = Colors.color_definitions.white
				local color = style.marker.color

				Colors.lerp_color_tables(font_default, white, easeInCubic, color)
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end
		},
		{
			name = "icon_size",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				return
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				-- function 12
				local ease_pulse = math.ease_pulse(arg_12_3)
				local texture_id = arg_12_4.widget.style.texture_id
				local texture_size = texture_id.texture_size
				local default_size = texture_id.default_size
				local offset = texture_id.offset
				local num = 10

				texture_size[1] = default_size[1] + num * ease_pulse
				texture_size[2] = default_size[2] + num * ease_pulse
				offset[1] = -(texture_size[1] - default_size[1]) * 0.5
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
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
				-- function 14
				arg_14_3.enter_sound_played = false
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				-- function 15
				if not arg_15_4.enter_sound_played then
					arg_15_4.enter_sound_played = true

					local str = "play_gui_mission_summary_chest_upgrade_check_0" .. arg_15_4.entry_index

					WwiseWorld.trigger_event(arg_15_4.wwise_world, str)
				end

				local widget = arg_15_4.widget
				local style = widget.style
				local offset = widget.offset
				local easeInCubic = math.easeInCubic(arg_15_3)
				local num = easeInCubic * 255
				local color = style.texture_id_glow.color
				local text_color = style.text.text_color

				color[1] = num

				local white = Colors.color_definitions.white
				local font_title = Colors.color_definitions.font_title

				Colors.lerp_color_tables(white, font_title, easeInCubic, text_color)

				offset[1] = easeInCubic * 20
				style.marker.offset[1] = -10 + -offset[1]
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
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
				-- function 17
				return
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				-- function 18
				local widget = arg_18_4.widget
				local style = widget.style
				local offset = widget.offset
				local easeInCubic = math.easeInCubic(arg_18_3)
				local num = 255 - easeInCubic * 255
				local color = style.texture_id.color
				local color_2 = style.texture_id_glow.color
				local text_color = style.text.text_color

				color_2[1] = num

				local font_title = Colors.color_definitions.font_title
				local get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_default", 255)
				local num_2 = 0.8

				get_color_table_with_alpha[2] = get_color_table_with_alpha[2] * num_2
				get_color_table_with_alpha[3] = get_color_table_with_alpha[3] * num_2
				get_color_table_with_alpha[4] = get_color_table_with_alpha[4] * num_2

				Colors.lerp_color_tables(font_title, get_color_table_with_alpha, easeInCubic, text_color)
				Colors.lerp_color_tables(Colors.color_definitions.white, get_color_table_with_alpha, easeInCubic, color)

				offset[1] = 20 - easeInCubic * 20
				style.marker.offset[1] = -10 + -offset[1]
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end
		},
		{
			name = "checkbox_enter",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				arg_20_3.checkbox_sound_played = false
			end,
			update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				-- function 21
				if not arg_21_4.checkbox_sound_played then
					arg_21_4.checkbox_sound_played = true

					WwiseWorld.trigger_event(arg_21_4.wwise_world, "play_gui_mission_summary_chest_upgrade_topic_ticked")
				end

				local widget = arg_21_4.widget
				local style = widget.style
				local offset = widget.offset
				local easeOutCubic = math.easeOutCubic(arg_21_3)
				local num = easeOutCubic * 255

				style.checkbox.color[1] = num
				style.checkbox_shadow.color[1] = num

				local texture_size = style.checkbox.texture_size
				local num_2 = 37
				local num_3 = 31

				texture_size[1] = num_2 + (1 - easeOutCubic) * num_2 * 2
				texture_size[2] = num_3 + (1 - easeOutCubic) * num_3 * 2
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
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
				-- function 23
				return
			end,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				-- function 24
				local num = math.easeInCubic(arg_24_3) * 255

				arg_24_2.chest_title.style.text.text_color[1] = num
				arg_24_2.chest_title.style.text_shadow.text_color[1] = num
				arg_24_2.chest_sub_title.style.text.text_color[1] = num
				arg_24_2.chest_sub_title.style.text_shadow.text_color[1] = num
			end,
			on_complete = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
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
				-- function 26
				local num = 0

				arg_26_2.upgrade_background.style.texture_id.color[1] = num
			end,
			update = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				-- function 27
				local easeInCubic = math.easeInCubic(arg_27_3)
				local num = easeInCubic * 255

				arg_27_2.upgrade_background.style.texture_id.color[1] = num

				local str = "upgrade_background"
				local size = arg_27_1[str].size
				local size_2 = self[str].size

				size_2[1] = size[1] + size[1] * (1 - easeInCubic)
				size_2[2] = size[2] + size[2] * (1 - easeInCubic)
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				return
			end
		},
		{
			name = "upgrade_text_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				local num = 0

				arg_29_2.upgrade_text.style.text.text_color[1] = num
				arg_29_2.upgrade_text.style.text_shadow.text_color[1] = num
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				-- function 30
				local easeInCubic = math.easeInCubic(arg_30_3)
				local num = easeInCubic * 255
				local upgrade_text = arg_30_2.upgrade_text

				upgrade_text.style.text.text_color[1] = num
				upgrade_text.style.text_shadow.text_color[1] = num

				local num_2 = 50
				local num_3 = num_2 + (100 - num_2) * (1 - easeInCubic)

				upgrade_text.style.text.font_size = num_3
				upgrade_text.style.text_shadow.font_size = num_3
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				return
			end
		},
		{
			name = "upgrade_background_fade_out",
			start_progress = 0.8,
			end_progress = 1.3,
			init = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				-- function 32
				return
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				-- function 33
				local num = 255 - math.easeInCubic(arg_33_3) * 255

				arg_33_2.upgrade_background.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				return
			end
		},
		{
			name = "upgrade_text_fade_out",
			start_progress = 0.9,
			end_progress = 1.3,
			init = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				-- function 35
				return
			end,
			update = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				-- function 36
				local num = 255 - math.easeInCubic(arg_36_3) * 255

				arg_36_2.upgrade_text.style.text.text_color[1] = num
				arg_36_2.upgrade_text.style.text_shadow.text_color[1] = num
			end,
			on_complete = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
				return
			end
		},
		{
			name = "title_fade_in",
			start_progress = 1.2,
			end_progress = 1.6,
			init = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				-- function 38
				local num = 0

				arg_38_2.chest_title.style.text.text_color[1] = num
				arg_38_2.chest_title.style.text_shadow.text_color[1] = num
				arg_38_2.chest_sub_title.style.text.text_color[1] = num
				arg_38_2.chest_sub_title.style.text_shadow.text_color[1] = num
			end,
			update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				-- function 39
				local num = math.easeInCubic(arg_39_3) * 255

				arg_39_2.chest_title.style.text.text_color[1] = num
				arg_39_2.chest_title.style.text_shadow.text_color[1] = num
				arg_39_2.chest_sub_title.style.text.text_color[1] = num
				arg_39_2.chest_sub_title.style.text_shadow.text_color[1] = num
			end,
			on_complete = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				return
			end
		}
	}
}

return {
	widgets = tbl_6,
	score_entry_widgets = tbl_5,
	scenegraph_definition = tbl,
	animation_definitions = tbl_7,
	create_bar_divider = fn
}
