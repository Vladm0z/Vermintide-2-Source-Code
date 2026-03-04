-- chunkname: @scripts/ui/views/level_end/states/definitions/end_view_state_weave_definitions.lua

local var_0_0 = 22
local var_0_1 = not IS_WINDOWS and 50 or 0
local var_0_2 = 1600
local var_0_3 = var_0_2 - 50
local var_0_4 = {
	1920,
	230 + var_0_1
}
local var_0_5 = {
	250,
	160
}
local var_0_6 = 30
local var_0_7 = {
	100,
	138,
	0,
	147
}
local var_0_8 = {
	150,
	138,
	0,
	187
}
local var_0_9 = {
	100,
	128,
	0,
	217
}
local var_0_10 = {
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
	content_bg = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = var_0_4,
		position = {
			0,
			0,
			UILayer.end_screen + 30
		}
	},
	content_top_fade = {
		vertical_alignment = "top",
		parent = "content_bg",
		size = {
			1920,
			200
		},
		position = {
			0,
			200,
			-4
		}
	},
	content_top_glow_1 = {
		vertical_alignment = "top",
		parent = "content_bg",
		size = {
			1920,
			350
		},
		position = {
			0,
			350,
			-3
		}
	},
	content_top_glow_2 = {
		vertical_alignment = "top",
		parent = "content_bg",
		size = {
			1920,
			300
		},
		position = {
			0,
			300,
			-2
		}
	},
	content_top_glow_3 = {
		vertical_alignment = "top",
		parent = "content_bg",
		size = {
			1920,
			250
		},
		position = {
			0,
			250,
			-1
		}
	},
	content = {
		vertical_alignment = "center",
		parent = "content_bg",
		horizontal_alignment = "center",
		size = var_0_4,
		position = {
			0,
			0,
			1
		}
	},
	content_corner_top_left = {
		vertical_alignment = "top",
		parent = "content_bg",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			2
		}
	},
	content_corner_top_right = {
		vertical_alignment = "top",
		parent = "content_bg",
		horizontal_alignment = "right",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			2
		}
	},
	content_corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "content_bg",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			2
		}
	},
	content_corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "content_bg",
		horizontal_alignment = "right",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			2
		}
	},
	ready_timer_bar = {
		vertical_alignment = "bottom",
		parent = "content",
		horizontal_alignment = "left",
		size = {
			1300,
			15
		},
		position = {
			150,
			35 + var_0_1,
			15
		}
	},
	ready_button = {
		vertical_alignment = "bottom",
		parent = "content",
		horizontal_alignment = "right",
		size = {
			300,
			40
		},
		position = {
			-150,
			20 + var_0_1,
			15
		}
	},
	ready_button_panel = {
		vertical_alignment = "bottom",
		parent = "ready_button",
		horizontal_alignment = "center",
		size = {
			260,
			103
		},
		position = {
			0,
			20,
			-1
		}
	},
	total_time_container = {
		vertical_alignment = "bottom",
		parent = "ready_timer_bar",
		horizontal_alignment = "left",
		size = var_0_5,
		position = {
			0,
			30,
			1
		}
	},
	time_score_container = {
		vertical_alignment = "top",
		parent = "total_time_container",
		horizontal_alignment = "left",
		size = var_0_5,
		position = {
			var_0_5[1] + var_0_6,
			0,
			1
		}
	},
	damage_bonus_container = {
		vertical_alignment = "top",
		parent = "time_score_container",
		horizontal_alignment = "left",
		size = var_0_5,
		position = {
			var_0_5[1] + var_0_6,
			0,
			1
		}
	},
	total_score_container = {
		vertical_alignment = "top",
		parent = "damage_bonus_container",
		horizontal_alignment = "left",
		size = {
			460,
			var_0_5[2]
		},
		position = {
			var_0_5[1] + var_0_6,
			0,
			1
		}
	},
	score_weave_num = {
		vertical_alignment = "top",
		parent = "content",
		horizontal_alignment = "center",
		size = {
			500,
			50
		},
		position = {
			0,
			73,
			3
		}
	},
	title_bg = {
		vertical_alignment = "top",
		parent = "content",
		horizontal_alignment = "center",
		size = {
			0,
			73
		},
		position = {
			0,
			93,
			-1
		}
	},
	title_bg_left = {
		vertical_alignment = "top",
		parent = "title_bg",
		horizontal_alignment = "left",
		size = {
			634,
			73
		},
		position = {
			-634,
			0,
			0
		}
	},
	title_bg_right = {
		vertical_alignment = "top",
		parent = "title_bg",
		horizontal_alignment = "right",
		size = {
			634,
			73
		},
		position = {
			634,
			0,
			0
		}
	},
	score_glow_1 = {
		vertical_alignment = "center",
		parent = "total_time_container",
		horizontal_alignment = "center",
		size = {
			300,
			120
		},
		position = {
			0,
			0,
			1
		}
	},
	score_glow_2 = {
		vertical_alignment = "center",
		parent = "time_score_container",
		horizontal_alignment = "center",
		size = {
			300,
			120
		},
		position = {
			0,
			0,
			1
		}
	},
	score_glow_3 = {
		vertical_alignment = "center",
		parent = "damage_bonus_container",
		horizontal_alignment = "center",
		size = {
			300,
			120
		},
		position = {
			0,
			0,
			1
		}
	},
	score_glow_4 = {
		vertical_alignment = "center",
		parent = "total_score_container",
		horizontal_alignment = "center",
		size = {
			400,
			140
		},
		position = {
			0,
			0,
			1
		}
	},
	score_divider_1 = {
		vertical_alignment = "center",
		parent = "total_time_container",
		horizontal_alignment = "center",
		size = {
			200,
			20
		},
		position = {
			0,
			0,
			2
		}
	},
	score_divider_2 = {
		vertical_alignment = "center",
		parent = "time_score_container",
		horizontal_alignment = "center",
		size = {
			200,
			20
		},
		position = {
			0,
			0,
			2
		}
	},
	score_divider_3 = {
		vertical_alignment = "center",
		parent = "damage_bonus_container",
		horizontal_alignment = "center",
		size = {
			200,
			20
		},
		position = {
			0,
			0,
			2
		}
	},
	score_divider_4 = {
		vertical_alignment = "center",
		parent = "total_score_container",
		horizontal_alignment = "left",
		size = {
			230,
			59
		},
		position = {
			0,
			-12,
			2
		}
	},
	score_divider_5 = {
		vertical_alignment = "center",
		parent = "total_score_container",
		horizontal_alignment = "right",
		size = {
			230,
			59
		},
		position = {
			0,
			-12,
			2
		}
	},
	highscore_sigil = {
		vertical_alignment = "center",
		parent = "score_divider_4",
		horizontal_alignment = "left",
		size = {
			53,
			53
		},
		position = {
			60,
			15,
			2
		}
	},
	highscore_ribbon = {
		vertical_alignment = "top",
		parent = "highscore_sigil",
		horizontal_alignment = "center",
		size = {
			34,
			50
		},
		position = {
			0,
			-30,
			-1
		}
	},
	highscore_text = {
		vertical_alignment = "center",
		parent = "total_score_container",
		horizontal_alignment = "center",
		size = {
			460,
			50
		},
		position = {
			0,
			-70,
			1
		}
	},
	player_frame = {
		vertical_alignment = "top",
		parent = "content_bg",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			190 + var_0_1 * 0.5,
			10
		}
	},
	player_insignia = {
		vertical_alignment = "top",
		parent = "content_bg",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-90,
			190 + var_0_1 * 0.5,
			12
		}
	},
	profile_selector = {
		vertical_alignment = "bottom",
		parent = "player_frame",
		horizontal_alignment = "center",
		size = {
			78,
			28
		},
		position = {
			0,
			-120,
			10
		}
	}
}
local var_0_11 = {
	font_size = 36,
	upper_case = false,
	localize = false,
	dynamic_font_size_word_wrap = true,
	word_wrap = true,
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
local var_0_12 = {
	font_size = 28,
	upper_case = false,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		30,
		2
	}
}
local var_0_13 = {
	font_size = 28,
	upper_case = false,
	localize = false,
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
local var_0_14 = {
	font_size = 28,
	upper_case = false,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		30,
		2
	}
}
local var_0_15 = {
	font_size = 42,
	upper_case = false,
	localize = false,
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
local var_0_16 = {
	font_size = 32,
	upper_case = false,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = {
		255,
		253,
		204,
		10
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_17 = {
	use_shadow = false,
	font_size = 22,
	localize = false,
	vertical_alignment = "bottom",
	word_wrap = false,
	horizontal_alignment = "center",
	font_type = "hell_shark",
	offset = {
		-2,
		-94,
		11
	}
}

local function var_0_18(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = UIWidgets.create_default_button(arg_1_0, arg_1_1, nil, nil, arg_1_2, 24, arg_1_3, arg_1_4, nil, arg_1_5)

	var_1_0.content.hover_glow = "button_state_hover_green"
	var_1_0.content.effect = "play_button_passive_glow"
	var_1_0.content.glow = "button_state_normal_green"

	return var_1_0
end

function create_leaderboard_button(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	arg_2_3 = arg_2_3 or "button_bg_01"

	local var_2_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_2_3)
	local var_2_1 = arg_2_2 and UIFrameSettings[arg_2_2] or UIFrameSettings.button_frame_01
	local var_2_2 = var_2_1.texture_sizes.corner[1]

	arg_2_4 = arg_2_4 or "loot_chest_icon"

	local var_2_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_2_4)
	local var_2_4 = var_2_3 and var_2_3.size or {
		50,
		50
	}
	local var_2_5 = 0
	local var_2_6 = math.min((arg_2_1[1] - var_2_5) / var_2_4[1], (arg_2_1[2] - var_2_5) / var_2_4[2])
	local var_2_7 = math.min(var_2_6, 1)
	local var_2_8 = {
		var_2_4[1] * var_2_7,
		var_2_4[2] * var_2_7
	}

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					pass_type = "rect",
					style_id = "clicked_rect"
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function(arg_3_0)
						return arg_3_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "background_icon",
					pass_type = "texture_uv",
					content_id = "background_icon"
				}
			}
		},
		content = {
			background_fade = "button_bg_fade",
			hover_glow = "button_state_default",
			button_hotspot = {},
			frame = var_2_1.texture,
			background_icon = {
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				},
				texture_id = arg_2_4
			},
			background = {
				uvs = {
					{
						0,
						1 - arg_2_1[2] / var_2_0.size[2]
					},
					{
						arg_2_1[1] / var_2_0.size[1],
						1
					}
				},
				texture_id = arg_2_3
			}
		},
		style = {
			background = {
				color = {
					255,
					150,
					150,
					150
				},
				offset = {
					0,
					0,
					0
				}
			},
			background_icon = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_2_1[1] / 2 - var_2_8[1] / 2,
					arg_2_1[2] / 2 - var_2_8[2] / 2,
					1
				},
				size = var_2_8
			},
			hover_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					4
				},
				size = {
					arg_2_1[1],
					math.min(arg_2_1[2] - 5, 80)
				}
			},
			clicked_rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					8
				}
			},
			disabled_rect = {
				color = {
					150,
					20,
					20,
					20
				},
				offset = {
					0,
					0,
					2
				}
			}
		},
		scenegraph_id = arg_2_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_19(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = UIFrameSettings.button_frame_02

	return {
		content = {
			background = "xp_bar_bg",
			bar_edge = "end_glow_greyscale",
			draw_frame = true,
			bar_fill = {
				texture_id = "timer_fg_greyscale",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			},
			frame = var_4_0.texture
		},
		element = {
			passes = {
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					style_id = "bar_edge",
					pass_type = "texture",
					texture_id = "bar_edge",
					content_change_function = function(arg_5_0, arg_5_1)
						local var_5_0 = arg_5_1.parent.bar_fill
						local var_5_1 = var_5_0.offset[1]

						arg_5_1.offset[1] = math.floor(var_5_0.size[1] + var_5_1 - arg_5_1.default_size[1] / 2)
					end,
					content_check_function = function(arg_6_0)
						return arg_6_0.active
					end
				},
				{
					style_id = "bar_fill",
					pass_type = "texture_uv",
					content_id = "bar_fill",
					content_check_function = function(arg_7_0)
						return arg_7_0.parent.active
					end
				}
			}
		},
		style = {
			background = {
				color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_4_1[1] - var_4_0.texture_sizes.horizontal[2] * 2,
					arg_4_1[2] - var_4_0.texture_sizes.vertical[1] * 2
				},
				offset = {
					var_4_0.texture_sizes.horizontal[2],
					var_4_0.texture_sizes.vertical[1],
					0
				}
			},
			bar_fill = {
				color = {
					255,
					100,
					150,
					150
				},
				size = {
					arg_4_1[1] - var_4_0.texture_sizes.horizontal[2] * 2,
					arg_4_1[2] - var_4_0.texture_sizes.vertical[1]
				},
				default_size = {
					arg_4_1[1] - var_4_0.texture_sizes.horizontal[2],
					arg_4_1[2] - var_4_0.texture_sizes.vertical[1]
				},
				offset = {
					var_4_0.texture_sizes.horizontal[2],
					var_4_0.texture_sizes.vertical[1] / 2,
					2
				}
			},
			bar_edge = {
				color = {
					255,
					100,
					255,
					255
				},
				size = {
					40,
					60
				},
				default_size = {
					40,
					60
				},
				offset = {
					var_4_0.texture_sizes.horizontal[2] - 20,
					var_4_0.texture_sizes.vertical[1] - 25,
					5
				}
			},
			frame = {
				texture_size = var_4_0.texture_size,
				texture_sizes = var_4_0.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					4
				}
			}
		},
		scenegraph_id = arg_4_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_20(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.content
	local var_8_1 = arg_8_0.style
	local var_8_2 = var_8_1.bar_fill
	local var_8_3 = var_8_2.size
	local var_8_4 = var_8_2.default_size

	var_8_3[1] = math.floor(var_8_4[1] * arg_8_1)

	local var_8_5 = 0.5
	local var_8_6 = 150
	local var_8_7 = 255
	local var_8_8 = math.ease_pulse(arg_8_2 * var_8_5 % 1)

	var_8_1.bar_edge.color[1] = var_8_6 + (var_8_7 - var_8_6) * var_8_8
end

function create_simple_gamepad_disabled_texture(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					retained_mode = arg_9_2
				},
				{
					style_id = "glow",
					pass_type = "texture",
					texture_id = "glow_id",
					retained_mode = arg_9_2,
					content_change_function = function(arg_10_0, arg_10_1)
						arg_10_1.color[1] = 40 + 20 * math.sin(Managers.time:time("ui") * 5)
					end
				}
			}
		},
		content = {
			glow_id = "winds_icon_background_glow",
			texture_id = "keep_decorations_divider_02",
			gamepad_disabled = arg_9_5
		},
		style = {
			texture_id = {
				color = arg_9_3 or {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				},
				masked = arg_9_1
			},
			glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					400,
					50
				},
				color = {
					40,
					255,
					255,
					0
				},
				offset = {
					0,
					30,
					0
				},
				masked = arg_9_1
			}
		},
		offset = {
			0,
			0,
			arg_9_4 or 0
		},
		scenegraph_id = arg_9_0
	}
end

local var_0_21 = {
	90,
	90,
	70,
	55
}
local var_0_22 = {
	255,
	30,
	30,
	30
}
local var_0_23 = true
local var_0_24 = {
	content_bg = UIWidgets.create_tiled_texture("content_bg", "menu_frame_bg_06", {
		256,
		256
	}, nil, nil, {
		255,
		150,
		150,
		150
	}),
	content_border = UIWidgets.create_frame("content_bg", {
		30,
		30
	}, "menu_frame_11", 4, nil, {
		-var_0_0,
		-var_0_0
	}),
	content_border_fade = UIWidgets.create_simple_texture("edge_fade_small", "content_top_fade", nil, nil, {
		220,
		0,
		0,
		0
	}),
	content_top_glow_1 = UIWidgets.create_simple_uv_texture("end_screen_weave_smoke_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "content_top_glow_1", nil, nil, var_0_7),
	content_top_glow_2 = UIWidgets.create_simple_uv_texture("end_screen_weave_smoke_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "content_top_glow_2", nil, nil, var_0_8),
	content_top_glow_3 = UIWidgets.create_simple_uv_texture("end_screen_weave_embers_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "content_top_glow_3", nil, nil, var_0_9),
	content_background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "content_bg", nil, nil, {
		150,
		0,
		0,
		0
	}, 1),
	content_corner_top_left = UIWidgets.create_simple_texture("athanor_decoration_corner", "content_corner_top_left"),
	content_corner_top_right = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "content_corner_top_right"),
	content_corner_bottom_left = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "content_corner_bottom_left"),
	content_corner_bottom_right = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			1,
			1
		},
		{
			0,
			0
		}
	}, "content_corner_bottom_right"),
	score_weave_num = UIWidgets.create_simple_text("", "score_weave_num", nil, nil, var_0_11),
	title_bg_left = UIWidgets.create_simple_texture("athanor_power_bg", "title_bg_left"),
	title_bg_right = UIWidgets.create_simple_uv_texture("athanor_power_bg", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "title_bg_right"),
	score_divider_1 = UIWidgets.create_simple_texture("journal_content_divider_medium", "score_divider_1", nil, nil, var_0_22),
	score_divider_2 = UIWidgets.create_simple_texture("journal_content_divider_medium", "score_divider_2", nil, nil, var_0_22),
	score_divider_3 = UIWidgets.create_simple_texture("journal_content_divider_medium", "score_divider_3", nil, nil, var_0_22),
	score_divider_4 = UIWidgets.create_simple_texture("frame_detail_03", "score_divider_4"),
	score_divider_5 = UIWidgets.create_simple_uv_texture("frame_detail_03", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "score_divider_5"),
	score_glow_1 = UIWidgets.create_simple_texture("winds_icon_background_glow", "score_glow_1", nil, nil, var_0_21),
	score_glow_2 = UIWidgets.create_simple_texture("winds_icon_background_glow", "score_glow_2", nil, nil, var_0_21),
	score_glow_3 = UIWidgets.create_simple_texture("winds_icon_background_glow", "score_glow_3", nil, nil, var_0_21),
	score_glow_4 = UIWidgets.create_simple_texture("winds_icon_background_glow", "score_glow_4", nil, nil, var_0_21),
	total_time_text = UIWidgets.create_simple_text("weave_endscreen_total_time", "total_time_container", nil, nil, var_0_12),
	total_time_value = UIWidgets.create_simple_text("", "total_time_container", nil, nil, var_0_13),
	time_score_text = UIWidgets.create_simple_text("weave_endscreen_time_score", "time_score_container", nil, nil, var_0_12),
	time_score_value = UIWidgets.create_simple_text("", "time_score_container", nil, nil, var_0_13),
	damage_bonus_text = UIWidgets.create_simple_text("weave_endscreen_damage_score", "damage_bonus_container", nil, nil, var_0_12),
	damage_bonus_value = UIWidgets.create_simple_text("", "damage_bonus_container", nil, nil, var_0_13),
	total_score_text = UIWidgets.create_simple_text("weave_endscreen_total_score", "total_score_container", nil, nil, var_0_14),
	total_score_value = UIWidgets.create_simple_text("", "total_score_container", nil, nil, var_0_15),
	ready_button_panel = UIWidgets.create_simple_texture("esc_menu_top", "ready_button_panel"),
	ready_button = var_0_18("ready_button", var_0_10.ready_button.size, Localize("continue"), 24, "button_detail_03", var_0_23),
	ready_timer = var_0_19("ready_timer_bar", var_0_10.ready_timer_bar.size),
	profile_selector = create_simple_gamepad_disabled_texture("profile_selector", nil, nil, nil, nil, gamepad_disabled),
	highscore_sigil = UIWidgets.create_simple_texture("weave_highscore_sigil", "highscore_sigil"),
	highscore_ribbon = UIWidgets.create_simple_texture("weave_highscore_ribbon", "highscore_ribbon"),
	highscore_text = UIWidgets.create_simple_text("weave_endscreen_new_record", "highscore_text", nil, nil, var_0_16)
}
local var_0_25 = {
	player_frame = UIWidgets.create_portrait_frame("player_frame", "default", nil, 1, nil, "unit_frame_portrait_default"),
	player_insignia = UIWidgets.create_small_insignia("player_insignia", 0),
	player_name = UIWidgets.create_simple_text("", "player_frame", nil, nil, var_0_17)
}
local var_0_26 = {
	transition_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				arg_11_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				local var_12_0 = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.alpha_multiplier = var_12_0

				local var_12_1 = arg_12_1.content_bg
				local var_12_2 = var_12_1.size[2] * (1 - var_12_0)
				local var_12_3 = var_12_1.position[2]

				arg_12_0.content_bg.position[2] = var_12_3 - var_12_2
			end,
			on_complete = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		}
	},
	transition_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				arg_14_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				local var_15_0 = math.easeInCubic(arg_15_3)

				arg_15_4.render_settings.alpha_multiplier = 1 - var_15_0

				local var_15_1 = arg_15_1.content_bg
				local var_15_2 = var_15_1.size[2] * var_15_0
				local var_15_3 = var_15_1.position[2]

				arg_15_0.content_bg.position[2] = var_15_3 - var_15_2
			end,
			on_complete = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end
		}
	},
	score_entry = {
		{
			name = "count_up",
			start_progress = 0.5,
			end_progress = 1.4,
			init = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				arg_17_3.widget.content.text = UIUtils.comma_value(arg_17_3.start_value)
			end,
			update = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				local var_18_0 = arg_18_4.widget.content
				local var_18_1 = math.floor(math.lerp(arg_18_4.start_value, arg_18_4.end_value, arg_18_3))

				var_18_0.text = UIUtils.comma_value(var_18_1)

				if arg_18_4.wwise_world then
					WwiseWorld.trigger_event(arg_18_4.wwise_world, "play_gui_mission_summary_entry_count")
				end
			end,
			on_complete = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end
		},
		{
			name = "bump",
			start_progress = 1.5,
			end_progress = 1.8,
			init = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				arg_20_3.widget.content.entered = false
			end,
			update = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				local var_21_0 = arg_21_4.widget
				local var_21_1 = var_21_0.content
				local var_21_2 = var_21_0.style
				local var_21_3 = var_21_2.text
				local var_21_4 = var_21_2.text_shadow
				local var_21_5 = arg_21_4.start_font_size
				local var_21_6 = arg_21_4.peak_font_size
				local var_21_7 = math.ease_pulse(arg_21_3)
				local var_21_8 = math.lerp(var_21_5, var_21_6, var_21_7)

				var_21_3.font_size = var_21_8
				var_21_4.font_size = var_21_8

				if arg_21_4.wwise_world and var_21_1.entered == false then
					WwiseWorld.trigger_event(arg_21_4.wwise_world, "play_gui_mission_summary_entry_total_sum")

					var_21_1.entered = true
				end
			end,
			on_complete = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				return
			end
		}
	},
	highscore_presentation = {
		{
			name = "sigil_alpha",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				local var_23_0 = arg_23_2.highscore_sigil
				local var_23_1 = arg_23_2.highscore_ribbon
				local var_23_2 = 0

				var_23_0.style.texture_id.color[1] = var_23_2
				var_23_1.style.texture_id.color[1] = var_23_2
				arg_23_2.highscore_sigil.content.visible = true
				arg_23_2.highscore_ribbon.content.visible = true
				arg_23_2.highscore_text.content.visible = true
			end,
			update = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				local var_24_0 = math.ease_in_exp(arg_24_3)
				local var_24_1 = arg_24_2.highscore_sigil
				local var_24_2 = arg_24_2.highscore_ribbon
				local var_24_3 = 255 * var_24_0

				var_24_1.style.texture_id.color[1] = var_24_3
				var_24_2.style.texture_id.color[1] = var_24_3
			end,
			on_complete = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				return
			end
		},
		{
			name = "sigil_entry",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				return
			end,
			update = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				local var_27_0 = math.ease_out_exp(1 - arg_27_3)
				local var_27_1 = arg_27_2.highscore_sigil.scenegraph_id
				local var_27_2 = arg_27_1[var_27_1]
				local var_27_3 = arg_27_0[var_27_1]
				local var_27_4 = var_27_2.position
				local var_27_5 = var_27_3.local_position
				local var_27_6 = var_27_2.size
				local var_27_7 = var_27_3.size

				var_27_7[1] = var_27_6[1] + var_27_6[1] * var_27_0
				var_27_7[2] = var_27_6[2] + var_27_6[2] * var_27_0
				var_27_5[1] = var_27_4[1] - var_27_4[1] / 2 * var_27_0
				var_27_5[2] = var_27_4[2] + var_27_4[2] / 2 * var_27_0

				local var_27_8 = arg_27_2.highscore_ribbon.scenegraph_id
				local var_27_9 = arg_27_1[var_27_8]
				local var_27_10 = arg_27_0[var_27_8]
				local var_27_11 = var_27_9.position
				local var_27_12 = var_27_10.local_position
				local var_27_13 = var_27_9.size
				local var_27_14 = var_27_10.size

				var_27_14[1] = var_27_13[1] + var_27_13[1] * var_27_0
				var_27_14[2] = var_27_13[2] + var_27_13[2] * var_27_0
				var_27_12[1] = var_27_11[1] + var_27_11[1] * var_27_0
				var_27_12[2] = var_27_11[2] + var_27_11[2] * var_27_0

				if arg_27_3 == 1 and arg_27_4.wwise_world then
					WwiseWorld.trigger_event(arg_27_4.wwise_world, "menu_wind_level_choose_wind")
				end
			end,
			on_complete = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				return
			end
		},
		{
			name = "text_entry",
			start_progress = 0.7,
			end_progress = 1.1,
			init = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				local var_29_0 = arg_29_2.highscore_text
				local var_29_1 = var_29_0.content
				local var_29_2 = var_29_0.style
				local var_29_3 = var_29_2.text
				local var_29_4 = var_29_2.text_shadow
				local var_29_5 = var_29_0.offset

				var_29_3.text_color[1] = 0
				var_29_4.text_color[1] = 0
				var_29_5[1] = 0
			end,
			update = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				local var_30_0 = arg_30_2.highscore_text
				local var_30_1 = var_30_0.content
				local var_30_2 = var_30_0.style
				local var_30_3 = var_30_2.text
				local var_30_4 = var_30_2.text_shadow
				local var_30_5 = var_30_0.offset
				local var_30_6 = math.easeOutCubic(arg_30_3)

				var_30_3.text_color[1] = 255 * var_30_6
				var_30_4.text_color[1] = 255 * var_30_6
				var_30_5[1] = 10 * var_30_6
			end,
			on_complete = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end
		},
		{
			name = "background_glow_entry",
			start_progress = 0.7,
			end_progress = 2.5,
			init = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				local var_32_0 = arg_32_2.score_glow_4
				local var_32_1 = var_32_0.content
				local var_32_2 = var_32_0.style.texture_id.color

				var_32_2[1] = 90
				var_32_2[2] = 90
				var_32_2[3] = 70
				var_32_2[4] = 55
			end,
			update = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				local var_33_0 = arg_33_2.score_glow_4
				local var_33_1 = var_33_0.content
				local var_33_2 = var_33_0.style.texture_id.color
				local var_33_3 = math.easeOutCubic(arg_33_3)
				local var_33_4 = {
					90,
					90,
					70,
					55
				}
				local var_33_5 = {
					60,
					223,
					204,
					50
				}

				Colors.lerp_color_tables(var_33_4, var_33_5, var_33_3, var_33_2)
			end,
			on_complete = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end
		}
	}
}
local var_0_27 = {
	default = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 3,
			description_text = "continue_menu_button_name"
		}
	},
	show_profile = {
		actions = {
			{
				input_action = "special_1",
				priority = 2,
				description_text = "input_description_show_profile"
			}
		}
	}
}

return {
	widgets = var_0_24,
	hero_widgets = var_0_25,
	score_widgets = score_widgets,
	scenegraph_definition = var_0_10,
	animation_definitions = var_0_26,
	update_bar_progress = var_0_20,
	generic_input_actions = var_0_27
}
