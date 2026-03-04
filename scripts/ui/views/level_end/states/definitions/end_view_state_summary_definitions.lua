-- chunkname: @scripts/ui/views/level_end/states/definitions/end_view_state_summary_definitions.lua

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
local var_0_1 = {}
local var_0_2 = 10

for iter_0_0 = 1, var_0_2 do
	var_0_1["summary_entry_" .. iter_0_0] = UIWidgets.create_summary_entry("summary_entry_root", var_0_0.summary_entry_root.size, iter_0_0)
end

local var_0_3 = {
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
local var_0_4 = {
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
local var_0_5 = {
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
local var_0_6 = {
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
local var_0_7 = {
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
local var_0_8 = {
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
local var_0_9 = {
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
local var_0_10 = {
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
local var_0_11 = {
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
local var_0_12 = {
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
local var_0_13 = {
	objective_title = UIWidgets.create_simple_text(Localize("summary_screen_objective_title"), "summary_entry_title", nil, nil, var_0_5),
	experience_title = UIWidgets.create_simple_text(Localize("summary_screen_experience_title"), "summary_entry_title", nil, nil, var_0_6),
	total_title = UIWidgets.create_simple_text(Localize("summary_screen_total_title"), "summary_entry_total_title", nil, nil, var_0_7),
	experience_total_text = UIWidgets.create_simple_text("", "summary_entry_total_title", nil, nil, var_0_8),
	next_level_text = UIWidgets.create_simple_text("0", "next_level_text", nil, nil, var_0_4),
	current_level_text = UIWidgets.create_simple_text("0", "current_level_text", nil, nil, var_0_4),
	summary_title = UIWidgets.create_simple_text(Localize("end_screen_mission_summary"), "summary_title", nil, nil, var_0_3),
	level_up_text = UIWidgets.create_simple_text(Localize("summary_screen_level_up"), "experience_bar", nil, nil, var_0_9),
	background = UIWidgets.create_simple_texture("summary_screen", "background"),
	experience_fg = UIWidgets.create_simple_texture("summary_screen_fg", "experience_fg"),
	experience_bar = UIWidgets.create_summary_experience_bar("experience_bar", var_0_0.experience_bar.size),
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
	essence_background_frame = UIWidgets.create_frame("summary_entry_essence_background", var_0_0.summary_entry_essence_background.size, "button_frame_01", 3),
	total_essence_title = UIWidgets.create_simple_text(Localize("summary_total_essence_title"), "summary_entry_total_essence_title", nil, nil, var_0_10),
	essence_total_text = UIWidgets.create_simple_text("", "summary_entry_total_essence_gained", nil, nil, var_0_11),
	essence_total_text_max = UIWidgets.create_simple_text(Localize("weave_endscreen_max_essence"), "summary_entry_total_essence_gained", nil, nil, var_0_12),
	icon_essence = UIWidgets.create_simple_texture("icon_crafting_essence_small", "summary_entry_essence_icon")
}
local var_0_14 = 10

for iter_0_1 = 1, var_0_14 do
	var_0_13["experience_entry_" .. iter_0_1] = UIWidgets.create_experience_entry("experience_entry_root", var_0_0.experience_entry_root.size)
end

local var_0_15 = {
	transition_enter_fast = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
				arg_2_0.background.local_position[2] = 400 * (1 - var_2_0)
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	transition_enter = {
		{
			name = "fade_in",
			start_progress = 2,
			end_progress = 2.3,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = var_5_0
				arg_5_0.background.local_position[2] = 400 * (1 - var_5_0)
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	},
	transition_exit = {
		{
			name = "fade_out",
			start_progress = 1,
			end_progress = 1.3,
			init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				arg_7_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = math.easeInCubic(arg_8_3)

				arg_8_4.render_settings.alpha_multiplier = 1 - var_8_0
				arg_8_0.background.local_position[2] = -400 * var_8_0
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		}
	},
	summary_entry_initial = {
		{
			name = "move",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				local var_10_0 = arg_10_3.widget
				local var_10_1 = var_10_0.content
				local var_10_2 = var_10_0.style
				local var_10_3 = var_10_0.offset
				local var_10_4 = arg_10_1[var_10_0.scenegraph_id].size
				local var_10_5 = arg_10_3.list_index
				local var_10_6 = arg_10_3.spacing
				local var_10_7 = (var_10_4[2] + var_10_6) * (var_10_5 - 1)
				local var_10_8 = var_10_4[2] + var_10_6

				var_10_3[2] = -var_10_7
				var_10_3[2] = -var_10_7
			end,
			update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				local var_11_0 = arg_11_1.entry_window.position
				local var_11_1 = arg_11_1.entry_window.size
				local var_11_2 = arg_11_0.entry_window.local_position
				local var_11_3 = arg_11_4.widget
				local var_11_4 = var_11_3.content
				local var_11_5 = var_11_3.style

				var_11_3.offset[1] = -30 * math.easeInCubic(1 - arg_11_3)
			end,
			on_complete = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end
		},
		{
			name = "description_entry",
			start_progress = 0,
			end_progress = 1,
			init = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				local var_13_0 = arg_13_3.widget
				local var_13_1 = var_13_0.content
				local var_13_2 = var_13_0.style
				local var_13_3 = var_13_2.summary_text
				local var_13_4 = var_13_2.summary_text_shadow

				var_13_3.text_color[1] = 0
				var_13_4.text_color[1] = 0
				var_13_1.summary_text = arg_13_3.title_text or "n/a"
			end,
			update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				local var_14_0 = arg_14_4.widget.style
				local var_14_1 = var_14_0.summary_text
				local var_14_2 = var_14_0.summary_text_shadow
				local var_14_3 = var_14_0.background
				local var_14_4 = math.easeOutCubic(arg_14_3) * 255

				var_14_1.text_color[1] = var_14_4
				var_14_2.text_color[1] = var_14_4
			end,
			on_complete = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				return
			end
		},
		{
			name = "xp_entry",
			start_progress = 0.5,
			end_progress = 1,
			init = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				local var_16_0 = arg_16_3.widget
				local var_16_1 = var_16_0.content
				local var_16_2 = var_16_0.style
				local var_16_3 = var_16_2.xp_text
				local var_16_4 = var_16_2.xp_text_shadow

				var_16_3.text_color[1] = 0
				var_16_4.text_color[1] = 0
				var_16_1.xp_text = ""
			end,
			update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				local var_17_0 = arg_17_4.widget
				local var_17_1 = var_17_0.style
				local var_17_2 = var_17_0.content
				local var_17_3 = arg_17_4.experience
				local var_17_4 = arg_17_4.value
				local var_17_5 = math.floor((var_17_3 or var_17_4) * arg_17_3)

				if not var_17_2.xp_count or var_17_2.xp_count ~= var_17_5 then
					WwiseWorld.trigger_event(arg_17_4.wwise_world, "play_gui_mission_summary_entry_count")
				end

				var_17_2.xp_count = var_17_5
				var_17_2.xp_text = tostring(var_17_5)

				local var_17_6 = var_17_1.xp_text
				local var_17_7 = var_17_1.xp_text_shadow
				local var_17_8 = math.easeOutCubic(arg_17_3) * 255

				var_17_6.text_color[1] = var_17_8
				var_17_7.text_color[1] = var_17_8
			end,
			on_complete = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end
		}
	},
	total_experience_increase = {
		{
			name = "bump",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				local var_19_0 = arg_19_2.experience_total_text
				local var_19_1 = var_19_0.content
				local var_19_2 = var_19_0.style
				local var_19_3 = arg_19_3.experience

				if var_19_3 then
					local var_19_4 = (var_19_1.experience or 0) + var_19_3

					var_19_1.text = tostring(var_19_4)
					var_19_1.experience = var_19_4
					var_19_1.animate = true

					WwiseWorld.trigger_event(arg_19_3.wwise_world, "play_gui_mission_summary_entry_total_sum")
				else
					var_19_1.animate = false
				end
			end,
			update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				local var_20_0 = arg_20_2.experience_total_text
				local var_20_1 = var_20_0.style

				if var_20_0.content.animate then
					local var_20_2 = var_20_1.text
					local var_20_3 = var_20_1.text_shadow
					local var_20_4 = 32
					local var_20_5 = 40
					local var_20_6 = math.ease_pulse(arg_20_3)
					local var_20_7 = var_20_4 + (var_20_5 - var_20_4) * var_20_6

					var_20_2.font_size = var_20_7
					var_20_3.font_size = var_20_7
				end
			end,
			on_complete = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				return
			end
		}
	},
	level_up = {
		{
			name = "in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				WwiseWorld.trigger_event(arg_22_3.wwise_world, "play_gui_mission_summary_level_up")
			end,
			update = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				local var_23_0 = arg_23_2.level_up_text
				local var_23_1 = var_23_0.style
				local var_23_2 = var_23_0.content
				local var_23_3 = var_23_0.offset
				local var_23_4 = math.easeOutCubic(1 - arg_23_3)

				var_23_3[1] = -(30 + 220 * var_23_4)

				local var_23_5 = 255 - var_23_4 * 255

				var_23_1.text.text_color[1] = var_23_5
				var_23_1.text_shadow.text_color[1] = var_23_5
			end,
			on_complete = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				return
			end
		},
		{
			name = "move",
			start_progress = 0.3,
			end_progress = 1.3,
			init = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				return
			end,
			update = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				local var_26_0 = arg_26_2.level_up_text
				local var_26_1 = var_26_0.style
				local var_26_2 = var_26_0.content

				var_26_0.offset[1] = -30 + 30 * math.easeOutCubic(arg_26_3)
			end,
			on_complete = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				return
			end
		},
		{
			name = "out",
			start_progress = 1.3,
			end_progress = 1.6,
			init = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				return
			end,
			update = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				local var_29_0 = arg_29_2.level_up_text
				local var_29_1 = var_29_0.style
				local var_29_2 = var_29_0.content
				local var_29_3 = var_29_0.offset
				local var_29_4 = math.easeOutCubic(arg_29_3)

				var_29_3[1] = 250 * var_29_4

				local var_29_5 = 255 - var_29_4 * 255

				var_29_1.text.text_color[1] = var_29_5
				var_29_1.text_shadow.text_color[1] = var_29_5
			end,
			on_complete = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				return
			end
		},
		{
			name = "spark",
			start_progress = 1.2,
			end_progress = 1.9,
			init = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end,
			update = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				local var_32_0 = arg_32_2.sparkle_effect
				local var_32_1 = var_32_0.style
				local var_32_2 = var_32_0.content
				local var_32_3 = var_32_0.offset
				local var_32_4 = 180 * math.easeOutCubic(arg_32_3)
				local var_32_5 = var_32_1.texture_id

				var_32_5.angle = math.degrees_to_radians(var_32_4)
				var_32_5.color[1] = 255 * math.ease_pulse(arg_32_3)
			end,
			on_complete = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				return
			end
		},
		{
			name = "bump_next_level",
			start_progress = 1.3,
			end_progress = 1.6,
			init = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end,
			update = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				local var_35_0 = arg_35_2.next_level_text
				local var_35_1 = var_35_0.style
				local var_35_2 = var_35_0.content
				local var_35_3 = var_35_1.text
				local var_35_4 = var_35_1.text_shadow
				local var_35_5 = 42
				local var_35_6 = 60
				local var_35_7 = math.easeOutCubic(arg_35_3)
				local var_35_8 = math.ease_pulse(var_35_7)
				local var_35_9 = var_35_5 + (var_35_6 - var_35_5) * var_35_8

				var_35_3.font_size = var_35_9
				var_35_4.font_size = var_35_9
			end,
			on_complete = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				return
			end
		},
		{
			name = "bump_current_level",
			start_progress = 1.3,
			end_progress = 1.6,
			init = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				return
			end,
			update = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				local var_38_0 = arg_38_2.current_level_text
				local var_38_1 = var_38_0.style
				local var_38_2 = var_38_0.content
				local var_38_3 = var_38_1.text
				local var_38_4 = var_38_1.text_shadow
				local var_38_5 = 42
				local var_38_6 = 60
				local var_38_7 = math.easeOutCubic(arg_38_3)
				local var_38_8 = math.ease_pulse(var_38_7)
				local var_38_9 = var_38_5 + (var_38_6 - var_38_5) * var_38_8

				var_38_3.font_size = var_38_9
				var_38_4.font_size = var_38_9
			end,
			on_complete = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				return
			end
		}
	},
	summary_entry_text_shadow = {
		{
			name = "description",
			start_progress = 1.2,
			end_progress = 1.6,
			init = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				return
			end,
			update = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				local var_41_0 = arg_41_4.widget.style.summary_text_shadow
				local var_41_1 = math.easeOutCubic(1 - arg_41_3) * 255

				var_41_0.text_color[1] = var_41_1
			end,
			on_complete = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				return
			end
		},
		{
			name = "xp",
			start_progress = 1.2,
			end_progress = 1.6,
			init = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				return
			end,
			update = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				local var_44_0 = arg_44_4.widget.style.xp_text_shadow
				local var_44_1 = math.easeOutCubic(1 - arg_44_3) * 255

				var_44_0.text_color[1] = var_44_1
			end,
			on_complete = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_13,
	summary_entry_widgets = var_0_1,
	scenegraph_definition = var_0_0,
	animation_definitions = var_0_15
}
