-- chunkname: @scripts/ui/views/level_end/states/definitions/end_view_state_summary_definitions.lua

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
	background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1094,
			873
		},
		position = {
			0,
			0,
			1
		}
	},
	window = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			978,
			678
		},
		position = {
			0,
			20,
			1
		}
	},
	summary_title = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			350,
			50
		},
		position = {
			0,
			-48,
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
	experience_fg = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			985,
			91
		},
		position = {
			-2,
			-80,
			7
		}
	},
	sparkle_effect = {
		vertical_alignment = "center",
		parent = "experience_fg",
		horizontal_alignment = "center",
		size = {
			256,
			256
		},
		position = {
			434,
			15,
			10
		}
	},
	experience_bar = {
		vertical_alignment = "bottom",
		parent = "experience_fg",
		horizontal_alignment = "center",
		size = {
			816,
			70
		},
		position = {
			2,
			0,
			-6
		}
	},
	next_level_text = {
		vertical_alignment = "bottom",
		parent = "experience_fg",
		horizontal_alignment = "right",
		size = {
			54,
			54
		},
		position = {
			-9,
			9,
			-1
		}
	},
	current_level_text = {
		vertical_alignment = "bottom",
		parent = "experience_fg",
		horizontal_alignment = "left",
		size = {
			54,
			54
		},
		position = {
			13,
			9,
			-1
		}
	},
	experience_entry_root = {
		vertical_alignment = "top",
		parent = "experience_bar",
		horizontal_alignment = "center",
		size = {
			250,
			50
		},
		position = {
			0,
			-60,
			1
		}
	},
	summary_entry_root = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			820,
			40
		},
		position = {
			0,
			-100,
			1
		}
	},
	summary_entry_title = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			820,
			40
		},
		position = {
			0,
			210,
			1
		}
	},
	summary_entry_total_title = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			820,
			40
		},
		position = {
			0,
			-260,
			1
		}
	},
	summary_entry_total_essence_group = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			838,
			137
		},
		position = {
			0,
			-340,
			1
		}
	},
	summary_entry_essence_background = {
		vertical_alignment = "center",
		parent = "summary_entry_total_essence_group",
		horizontal_alignment = "center",
		size = {
			890,
			88
		},
		position = {
			0,
			0,
			1
		}
	},
	summary_entry_essence_background_effect_left = {
		vertical_alignment = "center",
		parent = "summary_entry_essence_background",
		horizontal_alignment = "left",
		size = {
			240,
			88
		},
		position = {
			0,
			0,
			1
		}
	},
	summary_entry_essence_background_effect_right = {
		vertical_alignment = "center",
		parent = "summary_entry_essence_background",
		horizontal_alignment = "right",
		size = {
			240,
			88
		},
		position = {
			0,
			0,
			1
		}
	},
	summary_entry_total_essence_title = {
		vertical_alignment = "center",
		parent = "summary_entry_essence_background",
		horizontal_alignment = "left",
		size = {
			646,
			97
		},
		position = {
			34,
			0,
			1
		}
	},
	summary_entry_total_essence_gained = {
		vertical_alignment = "center",
		parent = "summary_entry_essence_background",
		horizontal_alignment = "right",
		size = {
			300,
			97
		},
		position = {
			-34,
			0,
			1
		}
	},
	summary_entry_essence_icon = {
		vertical_alignment = "center",
		parent = "summary_entry_total_essence_gained",
		horizontal_alignment = "right",
		size = {
			32,
			32
		},
		position = {
			0,
			0,
			1
		}
	},
	entry_window = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			980,
			64
		},
		position = {
			0,
			0,
			3
		}
	},
	stamp = {
		vertical_alignment = "top",
		parent = "entry_window",
		horizontal_alignment = "center",
		size = {
			1024,
			83
		},
		position = {
			0,
			5,
			5
		}
	},
	left_entry_holder = {
		vertical_alignment = "center",
		parent = "entry_window",
		horizontal_alignment = "left",
		size = {
			50,
			102
		},
		position = {
			0,
			0,
			2
		}
	},
	right_entry_holder = {
		vertical_alignment = "center",
		parent = "entry_window",
		horizontal_alignment = "right",
		size = {
			50,
			102
		},
		position = {
			0,
			0,
			2
		}
	}
}
local tbl_2 = {}
local num = 10

for i = 1, num do
	tbl_2["summary_entry_" .. i] = UIWidgets.create_summary_entry("summary_entry_root", tbl.summary_entry_root.size, i)
end

local tbl_3 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
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
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 42,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		-2
	}
}
local tbl_5 = {
	font_size = 32,
	upper_case = true,
	word_wrap = true,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	font_type = "hell_shark",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}
local tbl_6 = {
	font_size = 32,
	upper_case = true,
	word_wrap = true,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "bottom",
	font_type = "hell_shark",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}
local tbl_7 = {
	font_size = 32,
	upper_case = true,
	word_wrap = true,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_8 = {
	font_size = 32,
	upper_case = true,
	word_wrap = true,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_9 = {
	font_size = 40,
	upper_case = true,
	word_wrap = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 0),
	offset = {
		0,
		2,
		10
	}
}
local tbl_10 = {
	font_size = 32,
	upper_case = true,
	word_wrap = true,
	use_shadow = true,
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
local tbl_11 = {
	font_size = 32,
	upper_case = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_12 = {
	font_size = 32,
	upper_case = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = {
		255,
		160,
		160,
		160
	},
	offset = {
		0,
		0,
		2
	}
}
local tbl_13 = {
	objective_title = UIWidgets.create_simple_text(Localize("summary_screen_objective_title"), "summary_entry_title", nil, nil, tbl_5),
	experience_title = UIWidgets.create_simple_text(Localize("summary_screen_experience_title"), "summary_entry_title", nil, nil, tbl_6),
	total_title = UIWidgets.create_simple_text(Localize("summary_screen_total_title"), "summary_entry_total_title", nil, nil, tbl_7),
	experience_total_text = UIWidgets.create_simple_text("", "summary_entry_total_title", nil, nil, tbl_8),
	next_level_text = UIWidgets.create_simple_text("0", "next_level_text", nil, nil, tbl_4),
	current_level_text = UIWidgets.create_simple_text("0", "current_level_text", nil, nil, tbl_4),
	summary_title = UIWidgets.create_simple_text(Localize("end_screen_mission_summary"), "summary_title", nil, nil, tbl_3),
	level_up_text = UIWidgets.create_simple_text(Localize("summary_screen_level_up"), "experience_bar", nil, nil, tbl_9),
	background = UIWidgets.create_simple_texture("summary_screen", "background"),
	experience_fg = UIWidgets.create_simple_texture("summary_screen_fg", "experience_fg"),
	experience_bar = UIWidgets.create_summary_experience_bar("experience_bar", tbl.experience_bar.size),
	sparkle_effect = UIWidgets.create_simple_rotated_texture("sparkle_effect", 0, {
		128,
		128
	}, "sparkle_effect", nil, nil, {
		0,
		255,
		255,
		255
	}),
	essence_background = UIWidgets.create_tiled_texture("summary_entry_essence_background", "menu_frame_bg_06", {
		256,
		256
	}, nil, nil, {
		255,
		100,
		100,
		100
	}),
	essence_background_shadow = UIWidgets.create_simple_texture("options_window_fade_01", "summary_entry_essence_background", nil, nil, nil, 2),
	essence_background_effect_left = UIWidgets.create_simple_uv_texture("scorpion_icon_lit", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "summary_entry_essence_background_effect_left", nil, nil, {
		255,
		100,
		100,
		100
	}),
	essence_background_effect_right = UIWidgets.create_simple_texture("scorpion_icon_lit", "summary_entry_essence_background_effect_right", nil, nil, {
		150,
		255,
		255,
		255
	}),
	essence_background_frame = UIWidgets.create_frame("summary_entry_essence_background", tbl.summary_entry_essence_background.size, "button_frame_01", 3),
	total_essence_title = UIWidgets.create_simple_text(Localize("summary_total_essence_title"), "summary_entry_total_essence_title", nil, nil, tbl_10),
	essence_total_text = UIWidgets.create_simple_text("", "summary_entry_total_essence_gained", nil, nil, tbl_11),
	essence_total_text_max = UIWidgets.create_simple_text(Localize("weave_endscreen_max_essence"), "summary_entry_total_essence_gained", nil, nil, tbl_12),
	icon_essence = UIWidgets.create_simple_texture("icon_crafting_essence_small", "summary_entry_essence_icon")
}
local num_2 = 10

for j = 1, num_2 do
	tbl_13["experience_entry_" .. j] = UIWidgets.create_experience_entry("experience_entry_root", tbl.experience_entry_root.size)
end

local tbl_14 = {
	transition_enter_fast = {
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
				arg_2_0.background.local_position[2] = 400 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		}
	},
	transition_enter = {
		{
			name = "fade_in",
			start_progress = 2,
			end_progress = 2.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				arg_4_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeOutCubic = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = easeOutCubic
				arg_5_0.background.local_position[2] = 400 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		}
	},
	transition_exit = {
		{
			name = "fade_out",
			start_progress = 1,
			end_progress = 1.3,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				arg_7_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local easeInCubic = math.easeInCubic(arg_8_3)

				arg_8_4.render_settings.alpha_multiplier = 1 - easeInCubic
				arg_8_0.background.local_position[2] = -400 * easeInCubic
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		}
	},
	summary_entry_initial = {
		{
			name = "move",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				local widget = arg_10_3.widget
				local content = widget.content
				local style = widget.style
				local offset = widget.offset
				local size = arg_10_1[widget.scenegraph_id].size
				local list_index = arg_10_3.list_index
				local spacing = arg_10_3.spacing
				local num = (size[2] + spacing) * (list_index - 1)
				local num_2 = size[2] + spacing

				offset[2] = -num
				offset[2] = -num
			end,
			update = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local position = arg_11_1.entry_window.position
				local size = arg_11_1.entry_window.size
				local local_position = self.entry_window.local_position
				local widget = arg_11_4.widget
				local content = widget.content
				local style = widget.style

				widget.offset[1] = -30 * math.easeInCubic(1 - arg_11_3)
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				return
			end
		},
		{
			name = "description_entry",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				local widget = arg_13_3.widget
				local content = widget.content
				local style = widget.style
				local summary_text = style.summary_text
				local summary_text_shadow = style.summary_text_shadow

				summary_text.text_color[1] = 0
				summary_text_shadow.text_color[1] = 0

				local title_text = arg_13_3.title_text

				title_text = title_text or "n/a"
				content.summary_text = title_text
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				local style = arg_14_4.widget.style
				local summary_text = style.summary_text
				local summary_text_shadow = style.summary_text_shadow
				local background = style.background
				local num = math.easeOutCubic(arg_14_3) * 255

				summary_text.text_color[1] = num
				summary_text_shadow.text_color[1] = num
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				return
			end
		},
		{
			name = "xp_entry",
			start_progress = 0.5,
			end_progress = 1,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				local widget = arg_16_3.widget
				local content = widget.content
				local style = widget.style
				local xp_text = style.xp_text
				local xp_text_shadow = style.xp_text_shadow

				xp_text.text_color[1] = 0
				xp_text_shadow.text_color[1] = 0
				content.xp_text = ""
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				local widget = arg_17_4.widget
				local style = widget.style
				local content = widget.content
				local experience = arg_17_4.experience
				local value = arg_17_4.value
				local floor = math.floor((experience or value) * arg_17_3)

				if not (not content.xp_count and content.xp_count == floor) then
					WwiseWorld.trigger_event(arg_17_4.wwise_world, "play_gui_mission_summary_entry_count")
				end

				content.xp_count = floor
				content.xp_text = tostring(floor)

				local xp_text = style.xp_text
				local xp_text_shadow = style.xp_text_shadow
				local num = math.easeOutCubic(arg_17_3) * 255

				xp_text.text_color[1] = num
				xp_text_shadow.text_color[1] = num
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				return
			end
		}
	},
	total_experience_increase = {
		{
			name = "bump",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				local experience_total_text = arg_19_2.experience_total_text
				local content = experience_total_text.content
				local style = experience_total_text.style
				local experience = arg_19_3.experience

				if not experience then
					local experience_2 = content.experience

					experience_2 = experience_2 or 0

					local num = experience_2 + experience

					content.text = tostring(num)
					content.experience = num
					content.animate = true

					WwiseWorld.trigger_event(arg_19_3.wwise_world, "play_gui_mission_summary_entry_total_sum")
				else
					content.animate = false
				end
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				local experience_total_text = arg_20_2.experience_total_text
				local style = experience_total_text.style

				if not experience_total_text.content.animate then
					local text = style.text
					local text_shadow = style.text_shadow
					local num = 32
					local num_2 = 40
					local ease_pulse = math.ease_pulse(arg_20_3)
					local num_3 = num + (num_2 - num) * ease_pulse

					text.font_size = num_3
					text_shadow.font_size = num_3
				end
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				return
			end
		}
	},
	level_up = {
		{
			name = "in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				WwiseWorld.trigger_event(arg_22_3.wwise_world, "play_gui_mission_summary_level_up")
			end,
			update = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				-- function 23
				local level_up_text = arg_23_2.level_up_text
				local style = level_up_text.style
				local content = level_up_text.content
				local offset = level_up_text.offset
				local easeOutCubic = math.easeOutCubic(1 - arg_23_3)

				offset[1] = -(30 + 220 * easeOutCubic)

				local num = 255 - easeOutCubic * 255

				style.text.text_color[1] = num
				style.text_shadow.text_color[1] = num
			end,
			on_complete = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				-- function 24
				return
			end
		},
		{
			name = "move",
			start_progress = 0.3,
			end_progress = 1.3,
			init = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				return
			end,
			update = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				-- function 26
				local level_up_text = arg_26_2.level_up_text
				local style = level_up_text.style
				local content = level_up_text.content

				level_up_text.offset[1] = -30 + 30 * math.easeOutCubic(arg_26_3)
			end,
			on_complete = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				return
			end
		},
		{
			name = "out",
			start_progress = 1.3,
			end_progress = 1.6,
			init = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				return
			end,
			update = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				-- function 29
				local level_up_text = arg_29_2.level_up_text
				local style = level_up_text.style
				local content = level_up_text.content
				local offset = level_up_text.offset
				local easeOutCubic = math.easeOutCubic(arg_29_3)

				offset[1] = 250 * easeOutCubic

				local num = 255 - easeOutCubic * 255

				style.text.text_color[1] = num
				style.text_shadow.text_color[1] = num
			end,
			on_complete = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				-- function 30
				return
			end
		},
		{
			name = "spark",
			start_progress = 1.2,
			end_progress = 1.9,
			init = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				return
			end,
			update = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				-- function 32
				local sparkle_effect = arg_32_2.sparkle_effect
				local style = sparkle_effect.style
				local content = sparkle_effect.content
				local offset = sparkle_effect.offset
				local num = 180 * math.easeOutCubic(arg_32_3)
				local texture_id = style.texture_id

				texture_id.angle = math.degrees_to_radians(num)
				texture_id.color[1] = 255 * math.ease_pulse(arg_32_3)
			end,
			on_complete = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				-- function 33
				return
			end
		},
		{
			name = "bump_next_level",
			start_progress = 1.3,
			end_progress = 1.6,
			init = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				return
			end,
			update = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				-- function 35
				local next_level_text = arg_35_2.next_level_text
				local style = next_level_text.style
				local content = next_level_text.content
				local text = style.text
				local text_shadow = style.text_shadow
				local num = 42
				local num_2 = 60
				local easeOutCubic = math.easeOutCubic(arg_35_3)
				local ease_pulse = math.ease_pulse(easeOutCubic)
				local num_3 = num + (num_2 - num) * ease_pulse

				text.font_size = num_3
				text_shadow.font_size = num_3
			end,
			on_complete = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				-- function 36
				return
			end
		},
		{
			name = "bump_current_level",
			start_progress = 1.3,
			end_progress = 1.6,
			init = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
				return
			end,
			update = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				-- function 38
				local current_level_text = arg_38_2.current_level_text
				local style = current_level_text.style
				local content = current_level_text.content
				local text = style.text
				local text_shadow = style.text_shadow
				local num = 42
				local num_2 = 60
				local easeOutCubic = math.easeOutCubic(arg_38_3)
				local ease_pulse = math.ease_pulse(easeOutCubic)
				local num_3 = num + (num_2 - num) * ease_pulse

				text.font_size = num_3
				text_shadow.font_size = num_3
			end,
			on_complete = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				-- function 39
				return
			end
		}
	},
	summary_entry_text_shadow = {
		{
			name = "description",
			start_progress = 1.2,
			end_progress = 1.6,
			init = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				return
			end,
			update = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				-- function 41
				local summary_text_shadow = arg_41_4.widget.style.summary_text_shadow
				local num = math.easeOutCubic(1 - arg_41_3) * 255

				summary_text_shadow.text_color[1] = num
			end,
			on_complete = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				-- function 42
				return
			end
		},
		{
			name = "xp",
			start_progress = 1.2,
			end_progress = 1.6,
			init = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				-- function 43
				return
			end,
			update = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				-- function 44
				local xp_text_shadow = arg_44_4.widget.style.xp_text_shadow
				local num = math.easeOutCubic(1 - arg_44_3) * 255

				xp_text_shadow.text_color[1] = num
			end,
			on_complete = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				-- function 45
				return
			end
		}
	}
}

return {
	widgets = tbl_13,
	summary_entry_widgets = tbl_2,
	scenegraph_definition = tbl,
	animation_definitions = tbl_14
}
