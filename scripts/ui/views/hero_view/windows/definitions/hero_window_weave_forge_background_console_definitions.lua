-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_background_console_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.size
local var_0_2 = var_0_0.spacing
local var_0_3 = var_0_0.large_window_frame
local var_0_4 = UIFrameSettings[var_0_3].texture_sizes.vertical[1]
local var_0_5 = {
	var_0_1[1] * 3 + var_0_2 * 2 + var_0_4 * 2,
	var_0_1[2] + 80
}
local var_0_6 = {
	var_0_5[1] + 50,
	var_0_5[2]
}
local var_0_7 = "menu_frame_11"
local var_0_8 = UIFrameSettings[var_0_7].texture_sizes.vertical[1]
local var_0_9 = UISettings.game_start_windows
local var_0_10 = 0
local var_0_11 = {
	1920,
	1080
}
local var_0_12 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	screen_center = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = var_0_11,
		position = {
			0,
			0,
			1
		}
	},
	bottom_glow = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_11[1] - var_0_10 * 2,
			1000
		},
		position = {
			0,
			var_0_10,
			3
		}
	},
	bottom_glow_short = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_11[1] - var_0_10 * 2,
			500
		},
		position = {
			0,
			var_0_10,
			4
		}
	},
	bottom_glow_shortest = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_11[1] - var_0_10 * 2,
			200
		},
		position = {
			0,
			var_0_10,
			5
		}
	}
}

var_0_12.window.scale = "fit"

local var_0_13 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
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
local var_0_14 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_15 = {
	font_size = 28,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_16 = {
	font_size = 62,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
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
local var_0_17 = {
	font_size = 62,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_18 = {
	font_size = 20,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
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
local var_0_19 = {
	font_size = 20,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
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
local var_0_20 = {
	255,
	0,
	0,
	0
}
local var_0_21 = {
	200,
	138,
	0,
	147
}
local var_0_22 = {
	255,
	138,
	0,
	187
}
local var_0_23 = {
	200,
	128,
	0,
	217
}
local var_0_24 = {
	130,
	255,
	255,
	255
}
local var_0_25 = {
	bottom_glow_smoke_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, var_0_21),
	bottom_glow_smoke_2 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, var_0_22),
	bottom_glow_smoke_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_shortest", nil, nil, var_0_23),
	bottom_glow_embers_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, var_0_24, 1),
	bottom_glow_embers_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_3", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, var_0_24, 1),
	window_background = UIWidgets.create_simple_rect("window", var_0_20),
	screen_background = UIWidgets.create_simple_rect("screen", var_0_20)
}
local var_0_26 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - var_5_0
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_25,
	scenegraph_definition = var_0_12,
	animation_definitions = var_0_26
}
