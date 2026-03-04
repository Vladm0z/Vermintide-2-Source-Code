-- chunkname: @scripts/ui/views/level_end/level_end_view_v2_definitions.lua

local_require("scripts/ui/ui_widgets")

local var_0_0 = 20
local var_0_1 = {
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
	dead_space_filler_mask = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	dead_space_filler = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	console_cursor = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			10
		}
	},
	page_background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			-55
		}
	},
	edge_rect_left = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			200,
			1080
		},
		position = {
			-200,
			0,
			25
		}
	},
	edge_rect_right = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			200,
			1080
		},
		position = {
			200,
			0,
			25
		}
	},
	edge_rect_top = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			200
		},
		position = {
			0,
			200,
			25
		}
	},
	edge_rect_bottom = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			200
		},
		position = {
			0,
			-200,
			25
		}
	},
	bottom_panel = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			160
		},
		position = {
			0,
			0,
			1
		}
	},
	bottom_panel_frame = {
		vertical_alignment = "top",
		parent = "bottom_panel",
		horizontal_alignment = "center",
		size = {
			1950,
			180
		},
		position = {
			0,
			0,
			1
		}
	},
	bottom_panel_fade_left = {
		vertical_alignment = "bottom",
		parent = "bottom_panel",
		horizontal_alignment = "left",
		size = {
			600,
			160
		},
		position = {
			0,
			0,
			3
		}
	},
	bottom_panel_fade_right = {
		vertical_alignment = "bottom",
		parent = "bottom_panel",
		horizontal_alignment = "right",
		size = {
			600,
			160
		},
		position = {
			0,
			0,
			3
		}
	},
	top_panel = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			160
		},
		position = {
			0,
			0,
			1
		}
	},
	top_panel_frame = {
		vertical_alignment = "bottom",
		parent = "top_panel",
		horizontal_alignment = "center",
		size = {
			1950,
			180
		},
		position = {
			0,
			0,
			1
		}
	},
	top_panel_fade_left = {
		vertical_alignment = "bottom",
		parent = "top_panel",
		horizontal_alignment = "left",
		size = {
			600,
			160
		},
		position = {
			0,
			0,
			3
		}
	},
	top_panel_fade_right = {
		vertical_alignment = "bottom",
		parent = "top_panel",
		horizontal_alignment = "right",
		size = {
			600,
			160
		},
		position = {
			0,
			0,
			3
		}
	},
	player_frame_1 = {
		vertical_alignment = "bottom",
		parent = "top_panel",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-450,
			70,
			2
		}
	},
	player_frame_2 = {
		vertical_alignment = "bottom",
		parent = "top_panel",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-150,
			70,
			2
		}
	},
	player_frame_3 = {
		vertical_alignment = "bottom",
		parent = "top_panel",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			150,
			70,
			2
		}
	},
	player_frame_4 = {
		vertical_alignment = "bottom",
		parent = "top_panel",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			450,
			70,
			2
		}
	},
	score_panel = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			700
		},
		position = {
			0,
			-600,
			10
		}
	},
	bottom_edge_fade = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			25
		},
		position = {
			0,
			0,
			13
		}
	},
	hero_root = {
		vertical_alignment = "top",
		parent = "score_panel",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			20,
			1
		}
	},
	hero_1 = {
		vertical_alignment = "center",
		parent = "hero_root",
		horizontal_alignment = "center",
		size = {
			250,
			270
		},
		position = {
			-450,
			0,
			1
		}
	},
	hero_2 = {
		vertical_alignment = "center",
		parent = "hero_root",
		horizontal_alignment = "center",
		size = {
			250,
			270
		},
		position = {
			-150,
			0,
			1
		}
	},
	hero_3 = {
		vertical_alignment = "center",
		parent = "hero_root",
		horizontal_alignment = "center",
		size = {
			250,
			270
		},
		position = {
			150,
			0,
			1
		}
	},
	hero_4 = {
		vertical_alignment = "center",
		parent = "hero_root",
		horizontal_alignment = "center",
		size = {
			250,
			270
		},
		position = {
			450,
			0,
			1
		}
	},
	reward_entry_root = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			300,
			300
		},
		position = {
			0,
			0,
			1
		}
	},
	reset_button = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			64,
			64
		},
		position = {
			0,
			0,
			1
		}
	},
	level_up = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			354,
			180
		},
		position = {
			0,
			120,
			1
		}
	},
	summary_entry_root = {
		vertical_alignment = "top",
		parent = "top_panel",
		horizontal_alignment = "center",
		size = {
			1600,
			40
		},
		position = {
			0,
			-300,
			1
		}
	},
	timer_bg = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			400,
			60
		},
		position = {
			90,
			85,
			1
		}
	},
	timer_text = {
		vertical_alignment = "center",
		parent = "timer_bg",
		horizontal_alignment = "left",
		size = {
			1600,
			60
		},
		position = {
			50,
			0,
			1
		}
	},
	ready_button_alone = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			370,
			70
		},
		position = {
			0,
			80,
			15
		}
	},
	ready_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			370,
			70
		},
		position = {
			250,
			80,
			15
		}
	},
	retry_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			370,
			70
		},
		position = {
			-250,
			80,
			1
		}
	},
	page_selector = {
		vertical_alignment = "bottom",
		parent = "ready_button_alone",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-40,
			10
		}
	},
	bottom_glow = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1280
		},
		position = {
			0,
			0,
			-597
		}
	},
	bottom_glow_short = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			375
		},
		position = {
			0,
			0,
			-596
		}
	},
	bottom_glow_shortest = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			200
		},
		position = {
			0,
			0,
			-595
		}
	}
}

local function var_0_2(arg_1_0, arg_1_1)
	local var_1_0 = {
		30,
		30
	}
	local var_1_1 = 7
	local var_1_2 = {
		var_1_1,
		var_1_0[2] + var_1_1
	}

	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "checkbox_1",
					pass_type = "texture",
					content_check_function = function(arg_2_0, arg_2_1)
						return GameSettingsDevelopment.allow_retry_weave and arg_2_0.votes > 0
					end
				},
				{
					texture_id = "texture_id",
					style_id = "checkbox_2",
					pass_type = "texture",
					content_check_function = function(arg_3_0, arg_3_1)
						return GameSettingsDevelopment.allow_retry_weave and arg_3_0.votes > 1
					end
				},
				{
					texture_id = "texture_id",
					style_id = "checkbox_3",
					pass_type = "texture",
					content_check_function = function(arg_4_0, arg_4_1)
						return GameSettingsDevelopment.allow_retry_weave and arg_4_0.votes > 2
					end
				},
				{
					texture_id = "texture_id",
					style_id = "checkbox_4",
					pass_type = "texture",
					content_check_function = function(arg_5_0, arg_5_1)
						return GameSettingsDevelopment.allow_retry_weave and arg_5_0.votes > 3
					end
				}
			}
		},
		content = {
			texture_id = "matchmaking_checkbox",
			votes = 0
		},
		style = {
			checkbox_1 = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = arg_1_1 or {
					255,
					255,
					255,
					255
				},
				offset = {
					var_1_2[1] + (var_1_0[1] + var_1_1) * 0,
					var_1_2[2],
					0
				},
				texture_size = var_1_0
			},
			checkbox_2 = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = arg_1_1 or {
					255,
					255,
					255,
					255
				},
				offset = {
					var_1_2[1] + (var_1_0[1] + var_1_1) * 1,
					var_1_2[2],
					0
				},
				texture_size = var_1_0
			},
			checkbox_3 = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = arg_1_1 or {
					255,
					255,
					255,
					255
				},
				offset = {
					var_1_2[1] + (var_1_0[1] + var_1_1) * 2,
					var_1_2[2],
					0
				},
				texture_size = var_1_0
			},
			checkbox_4 = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = arg_1_1 or {
					255,
					255,
					255,
					255
				},
				offset = {
					var_1_2[1] + (var_1_0[1] + var_1_1) * 3,
					var_1_2[2],
					0
				},
				texture_size = var_1_0
			}
		},
		offset = {
			0,
			0,
			10
		},
		scenegraph_id = arg_1_0
	}
end

local var_0_3 = {
	word_wrap = true,
	font_size = 52,
	localize = false,
	use_shadow = true,
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
local var_0_4 = {
	vertical_alignment = "top",
	font_size = 20,
	localize = false,
	horizontal_alignment = "center",
	word_wrap = false,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_5

var_0_5 = IS_XB1 and "leave_party_xb1" or "leave_party"

local var_0_6 = true
local var_0_7 = true
local var_0_8 = {
	timer_text = UIWidgets.create_simple_text(Localize("timer_prefix_time_left"), "timer_text", nil, nil, var_0_3),
	timer_bg = UIWidgets.create_simple_texture("tab_menu_bg_03", "timer_bg"),
	ready_button = UIWidgets.create_default_button("ready_button", var_0_1.ready_button.size, nil, nil, Localize("return_to_inn"), 32, nil, nil, nil, var_0_7),
	reset_button = UIWidgets.create_simple_two_state_button("reset_button", "scroll_bar_button_up", "scroll_bar_button_up_clicked"),
	page_background = UIWidgets.create_simple_rect("page_background", {
		150,
		0,
		0,
		0
	}),
	retry_checkboxes = var_0_2("retry_button", {
		255,
		0,
		255,
		0
	}),
	reload_checkboxes = var_0_2("ready_button", {
		255,
		255,
		0,
		0
	}),
	dead_space_filler_mask = UIWidgets.create_simple_texture("mask_rect", "dead_space_filler", false, false, {
		255,
		255,
		255,
		255
	}),
	dead_space_filler_unmask = UIWidgets.create_simple_texture("mask_rect", "dead_space_filler_mask", false, false, {
		1,
		21,
		21,
		21
	})
}
local var_0_9 = {
	200,
	138,
	0,
	147
}
local var_0_10 = {
	255,
	138,
	0,
	187
}
local var_0_11 = {
	200,
	128,
	0,
	217
}
local var_0_12 = {
	130,
	255,
	255,
	255
}
local var_0_13 = {
	bottom_glow_smoke_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, var_0_9),
	bottom_glow_smoke_2 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, var_0_10),
	bottom_glow_smoke_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_shortest", nil, nil, var_0_11),
	bottom_glow_embers_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, var_0_12, 1),
	bottom_glow_embers_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_3", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, var_0_12, 1),
	dead_space_filler = UIWidgets.create_simple_texture("rect_masked", "dead_space_filler", false, false, {
		255,
		0,
		0,
		0
	})
}
local var_0_14 = {
	ready_button_entry_alone = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				arg_6_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				local var_7_0 = math.easeCubic(arg_7_3)
				local var_7_1 = math.easeCubic(1 - arg_7_3)

				arg_7_0.ready_button_alone.local_position[2] = arg_7_1.ready_button_alone.position[2] - 100 * var_7_1
				arg_7_4.render_settings.alpha_multiplier = var_7_0
			end,
			on_complete = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				return
			end
		}
	},
	ready_button_exit_alone = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0,
			init = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end,
			update = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				arg_10_0.ready_button_alone.local_position[2] = arg_10_1.ready_button_alone.position[2]
				arg_10_4.render_settings.alpha_multiplier = 0
			end,
			on_complete = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				return
			end
		}
	},
	ready_button_entry = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				arg_12_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				local var_13_0 = math.easeCubic(arg_13_3)
				local var_13_1 = math.easeCubic(1 - arg_13_3)

				arg_13_0.ready_button.local_position[2] = arg_13_1.ready_button.position[2] - 100 * var_13_1
				arg_13_4.render_settings.alpha_multiplier = var_13_0
			end,
			on_complete = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				return
			end
		}
	},
	retry_button_entry = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				arg_15_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				local var_16_0 = math.easeCubic(arg_16_3)
				local var_16_1 = math.easeCubic(1 - arg_16_3)

				arg_16_0.retry_button.local_position[2] = arg_16_1.retry_button.position[2] - 100 * var_16_1
				arg_16_4.render_settings.alpha_multiplier = var_16_0
			end,
			on_complete = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end
		}
	}
}
local var_0_15 = {
	default = {
		{
			input_action = "analog_input",
			priority = 1,
			description_text = "scoreboard_navigation"
		},
		{
			input_action = "refresh",
			priority = 3,
			description_text = "return_to_inn"
		}
	},
	profile_available = {
		actions = {
			{
				input_action = "confirm",
				priority = 2,
				description_text = "input_description_show_profile"
			}
		}
	}
}

return {
	num_reward_entries = num_reward_entries,
	num_experience_entries = num_experience_entries,
	scenegraph_definition = var_0_1,
	widgets_definitions = var_0_8,
	weave_widget_definitions = var_0_13,
	animations = var_0_14,
	generic_input_actions = var_0_15,
	console_cursor_definition = UIWidgets.create_console_cursor("console_cursor")
}
