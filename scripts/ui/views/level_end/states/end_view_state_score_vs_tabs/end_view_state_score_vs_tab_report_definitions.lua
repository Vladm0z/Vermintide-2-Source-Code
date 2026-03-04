-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_report_definitions.lua

local var_0_0 = {
	336,
	368
}
local var_0_1 = {
	0.12,
	0.865
}
local var_0_2 = {
	128,
	128
}
local var_0_3 = {
	80,
	80
}
local var_0_4 = {
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
	panel = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1800,
			920
		},
		position = {
			0,
			0,
			10
		}
	},
	insignia = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			100,
			276
		},
		position = {
			0,
			0,
			100
		}
	},
	level_up_anchor = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			80 + var_0_0[1] * 0.5,
			-344 - var_0_0[2] * 0.5,
			10
		}
	},
	level_up_text = {
		vertical_alignment = "center",
		parent = "level_up_anchor",
		horizontal_alignment = "center",
		size = var_0_0
	},
	versus_progress_anchor = {
		vertical_alignment = "top",
		parent = "level_up_anchor",
		horizontal_alignment = "left",
		size = {
			352,
			326
		},
		position = {
			var_0_0[1] * 0.5 + 25,
			var_0_0[2] * 0.5,
			0
		}
	},
	challenge_progress_anchor = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			830,
			225
		},
		position = {
			985,
			-550,
			1
		}
	},
	challenge_progress_area = {
		parent = "challenge_progress_anchor",
		position = {
			-15,
			-75,
			0
		}
	},
	challenge_entry_anchor = {
		vertical_alignment = "top",
		parent = "challenge_progress_area",
		position = {
			35,
			0,
			0
		},
		size = {
			830,
			110
		}
	},
	hero_progress_anchor = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			835,
			250
		},
		position = {
			985,
			-235,
			1
		}
	},
	hero_progress_item_anchor = {
		vertical_alignment = "top",
		parent = "hero_progress_anchor",
		horizontal_alignment = "left",
		size = var_0_3,
		position = {
			395,
			-80,
			1
		}
	},
	portrait = {
		vertical_alignment = "top",
		parent = "hero_progress_anchor",
		horizontal_alignment = "left",
		size = {
			100,
			100
		},
		position = {
			75,
			-50,
			0
		}
	},
	portrait_divider = {
		vertical_alignment = "top",
		parent = "portrait",
		horizontal_alignment = "right",
		size = {
			2,
			142
		},
		position = {
			-25,
			-20,
			0
		}
	},
	item_divider = {
		vertical_alignment = "top",
		parent = "portrait",
		horizontal_alignment = "right",
		size = {
			2,
			142
		},
		position = {
			200,
			-20,
			0
		}
	},
	hero_name = {
		vertical_alignment = "top",
		parent = "portrait_divider",
		horizontal_alignment = "right",
		size = {
			2,
			100
		},
		position = {
			20,
			0,
			0
		}
	},
	career_name = {
		vertical_alignment = "top",
		parent = "hero_name",
		horizontal_alignment = "right",
		size = {
			2,
			100
		},
		position = {
			0,
			-35,
			0
		}
	},
	experience_gained = {
		vertical_alignment = "bottom",
		parent = "career_name",
		horizontal_alignment = "right",
		size = {
			200,
			20
		},
		position = {
			192,
			25,
			0
		}
	},
	experience_bar = {
		vertical_alignment = "bottom",
		parent = "career_name",
		horizontal_alignment = "right",
		size = {
			200,
			20
		},
		position = {
			192,
			5,
			0
		}
	},
	sparkle_effect = {
		vertical_alignment = "top",
		parent = "experience_bar",
		horizontal_alignment = "right",
		size = var_0_2
	}
}

local function var_0_5(arg_1_0)
	local var_1_0 = {}
	local var_1_1 = {
		passes = {}
	}
	local var_1_2 = var_1_1.passes
	local var_1_3 = {}
	local var_1_4 = {}

	var_1_2[#var_1_2 + 1] = {
		pass_type = "texture",
		style_id = "foreground",
		texture_id = "versus_circle_foreground"
	}
	var_1_2[#var_1_2 + 1] = {
		pass_type = "texture",
		style_id = "middle_fill",
		texture_id = "versus_circle_background"
	}
	var_1_2[#var_1_2 + 1] = {
		pass_type = "texture",
		style_id = "background",
		texture_id = "versus_circle_background"
	}
	var_1_2[#var_1_2 + 1] = {
		pass_type = "rotated_texture",
		style_id = "left_lock",
		texture_id = "left_lock"
	}
	var_1_2[#var_1_2 + 1] = {
		pass_type = "rotated_texture",
		style_id = "right_lock",
		texture_id = "left_lock"
	}
	var_1_2[#var_1_2 + 1] = {
		style_id = "bottom_left_lock",
		pass_type = "texture_uv",
		content_id = "bottom_left_lock"
	}
	var_1_2[#var_1_2 + 1] = {
		pass_type = "texture",
		style_id = "bottom_right_lock",
		texture_id = "bottom_lock"
	}
	var_1_2[#var_1_2 + 1] = {
		pass_type = "texture",
		style_id = "lock_mask",
		texture_id = "lock_mask"
	}
	var_1_2[#var_1_2 + 1] = {
		pass_type = "texture",
		style_id = "lava",
		texture_id = "lava"
	}
	var_1_2[#var_1_2 + 1] = {
		pass_type = "texture",
		style_id = "lava_mask",
		texture_id = "lava_mask"
	}
	var_1_2[#var_1_2 + 1] = {
		style_id = "pattern_1",
		texture_id = "versus_circle_pattern",
		pass_type = "rotated_texture",
		content_change_function = function (arg_2_0, arg_2_1)
			local var_2_0 = Application.time_since_launch()

			arg_2_1.angle = math.degrees_to_radians(var_2_0 * 12 % 360)
		end
	}
	var_1_2[#var_1_2 + 1] = {
		style_id = "pattern_2",
		texture_id = "versus_circle_pattern",
		pass_type = "rotated_texture",
		content_change_function = function (arg_3_0, arg_3_1)
			local var_3_0 = Application.time_since_launch()

			arg_3_1.angle = math.degrees_to_radians(var_3_0 * 4 % 360)
		end
	}
	var_1_2[#var_1_2 + 1] = {
		style_id = "static_progress_marker",
		texture_id = "static_marker",
		pass_type = "rotated_texture",
		content_check_function = function (arg_4_0, arg_4_1)
			return arg_4_0.starting_progress >= var_0_1[1] and arg_4_0.starting_progress < var_0_1[2]
		end,
		content_change_function = function (arg_5_0, arg_5_1)
			arg_5_1.angle = arg_5_0.starting_progress * 2 * math.pi
		end
	}
	var_1_2[#var_1_2 + 1] = {
		style_id = "mask",
		texture_id = "versus_circle_mask",
		pass_type = "gradient_mask_texture",
		content_change_function = function (arg_6_0, arg_6_1)
			arg_6_1.gradient_threshold = arg_6_0.final_progress
		end
	}
	var_1_2[#var_1_2 + 1] = {
		style_id = "versus_static_circle",
		texture_id = "versus_static_circle",
		pass_type = "gradient_mask_texture",
		content_change_function = function (arg_7_0, arg_7_1)
			arg_7_1.gradient_threshold = arg_7_0.starting_progress
		end
	}
	var_1_2[#var_1_2 + 1] = {
		style_id = "versus_progress_circle",
		texture_id = "versus_progress_circle",
		pass_type = "gradient_mask_texture",
		content_change_function = function (arg_8_0, arg_8_1)
			arg_8_1.gradient_threshold = arg_8_0.final_progress
		end
	}
	var_1_2[#var_1_2 + 1] = {
		style_id = "progress_marker",
		texture_id = "rect_smooth",
		pass_type = "rotated_texture",
		content_change_function = function (arg_9_0, arg_9_1)
			arg_9_1.angle = arg_9_0.final_progress * 2 * math.pi
		end
	}
	var_1_2[#var_1_2 + 1] = {
		scenegraph_id = "level_up_text",
		style_id = "level_text",
		pass_type = "text",
		text_id = "level_text"
	}
	var_1_4.foreground = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			var_0_0[1],
			var_0_0[2]
		},
		color = Colors.get_color_table_with_alpha("white", 255)
	}
	var_1_4.middle_fill = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			var_0_0[1] * 0.75,
			var_0_0[2] * 0.75
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			0,
			-9
		}
	}
	var_1_4.background = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			var_0_0[1],
			var_0_0[2]
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			0,
			-10
		}
	}
	var_1_4.left_lock = {
		horizontal_alignment = "center",
		alpha_value = 255,
		vertical_alignment = "bottom",
		masked = true,
		angle = 0,
		texture_size = {
			104,
			156
		},
		pivot = {
			104,
			156
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			-52,
			-38,
			2
		}
	}
	var_1_4.right_lock = {
		horizontal_alignment = "center",
		alpha_value = 255,
		vertical_alignment = "bottom",
		masked = true,
		angle = 0,
		texture_size = {
			104,
			156
		},
		pivot = {
			0,
			156
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			52,
			-38,
			2
		},
		uvs = {
			{
				1,
				0
			},
			{
				0,
				1
			}
		}
	}
	var_1_4.bottom_right_lock = {
		vertical_alignment = "top",
		masked = true,
		horizontal_alignment = "center",
		alpha_value = 255,
		texture_size = {
			90,
			104
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			45,
			14,
			2
		}
	}
	var_1_4.bottom_left_lock = {
		vertical_alignment = "top",
		masked = true,
		horizontal_alignment = "center",
		alpha_value = 255,
		texture_size = {
			90,
			104
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			-45,
			14,
			2
		}
	}
	var_1_4.lock_mask = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			336,
			360
		},
		color = Colors.get_color_table_with_alpha("white", 0),
		offset = {
			0,
			14,
			10
		}
	}
	var_1_4.lava = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			336,
			360
		},
		color = Colors.get_color_table_with_alpha("white", 0),
		offset = {
			0,
			14,
			10
		}
	}
	var_1_4.lava_mask = {
		vertical_alignment = "top",
		horizontal_alignment = "center",
		texture_size = {
			330,
			330
		},
		color = Colors.get_color_table_with_alpha("white", 0),
		offset = {
			0,
			181.5,
			10
		}
	}
	var_1_4.pattern_1 = {
		vertical_alignment = "top",
		angle = 0,
		horizontal_alignment = "center",
		alpha_value = 192,
		texture_size = {
			330,
			330
		},
		pivot = {
			168,
			168
		},
		color = Colors.get_color_table_with_alpha("white", 0),
		offset = {
			0,
			181.5,
			-2
		}
	}
	var_1_4.pattern_2 = {
		vertical_alignment = "top",
		angle = 0,
		horizontal_alignment = "center",
		alpha_value = 128,
		texture_size = {
			330,
			330
		},
		pivot = {
			168,
			168
		},
		color = Colors.get_color_table_with_alpha("white", 0),
		offset = {
			0,
			181.5,
			-2
		}
	}
	var_1_4.mask = {
		vertical_alignment = "top",
		gradient_threshold = 0,
		horizontal_alignment = "center",
		texture_size = {
			330,
			330
		},
		color = Colors.get_color_table_with_alpha("white", 0),
		offset = {
			0,
			181.5,
			0
		}
	}
	var_1_4.versus_static_circle = {
		vertical_alignment = "top",
		gradient_threshold = 0.3,
		horizontal_alignment = "center",
		texture_size = {
			330,
			330
		},
		color = Colors.get_color_table_with_alpha("green", 0),
		offset = {
			0,
			181.5,
			-4
		}
	}
	var_1_4.static_progress_marker = {
		vertical_alignment = "top",
		horizontal_alignment = "center",
		angle = 0.5,
		pivot = {
			8,
			153
		},
		texture_size = {
			16,
			30
		},
		color = Colors.get_color_table_with_alpha("white", 0),
		offset = {
			0,
			-107,
			-2
		}
	}
	var_1_4.versus_progress_circle = {
		vertical_alignment = "top",
		gradient_threshold = 0,
		horizontal_alignment = "center",
		texture_size = {
			330,
			330
		},
		color = Colors.get_color_table_with_alpha("yellow", 0),
		offset = {
			0,
			181.5,
			-6
		}
	}
	var_1_4.progress_marker = {
		vertical_alignment = "top",
		horizontal_alignment = "center",
		angle = 0,
		pivot = {
			7,
			153
		},
		texture_size = {
			14,
			30
		},
		color = {
			0,
			255,
			255,
			100
		},
		offset = {
			0,
			-107,
			-3
		}
	}
	var_1_4.level_text = {
		localize = false,
		font_size = 45,
		horizontal_alignment = "center",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		area_size = {
			55,
			20
		},
		color = Colors.get_color_table_with_alpha("font_default", 0),
		offset = {
			-50,
			13,
			1
		}
	}
	var_1_3.level_text = "0"
	var_1_3.starting_progress = 0
	var_1_3.final_progress = 0
	var_1_3.versus_circle_foreground = "versus_circle_foreground"
	var_1_3.versus_circle_background = "versus_circle_background"
	var_1_3.versus_static_circle = "versus_static_circle"
	var_1_3.rect_smooth = "rect_smooth"
	var_1_3.static_marker = "static_marker"
	var_1_3.versus_circle_mask = "versus_circle_mask"
	var_1_3.versus_circle_pattern = "versus_circle_pattern"
	var_1_3.versus_progress_circle = "versus_progress_circle"
	var_1_3.bg_circle = "circle"
	var_1_3.left_lock = "versus_end_screen_cover_top_left"
	var_1_3.bottom_lock = "versus_end_screen_cover_bottom_left"
	var_1_3.bottom_left_lock = {
		texture_id = "versus_end_screen_cover_bottom_left",
		uvs = {
			{
				1,
				0
			},
			{
				0,
				1
			}
		}
	}
	var_1_3.lock_mask = "versus_lock_mask"
	var_1_3.lava = "lava"
	var_1_3.lava_mask = "versus_circle_mask_2"
	var_1_0.element = var_1_1
	var_1_0.content = var_1_3
	var_1_0.style = var_1_4
	var_1_0.scenegraph_id = arg_1_0
	var_1_0.offset = {
		0,
		0,
		0
	}

	return var_1_0
end

local var_0_6 = {
	vertical_alignment = "top",
	upper_case = true,
	localize = false,
	horizontal_alignment = "left",
	font_size = 44,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		-2,
		2
	}
}
local var_0_7 = {
	vertical_alignment = "top",
	horizontal_alignment = "left",
	localize = false,
	font_size = 28,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		-12,
		2
	}
}
local var_0_8 = {
	vertical_alignment = "top",
	horizontal_alignment = "left",
	localize = false,
	font_size = 28,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		-12,
		2
	}
}
local var_0_9 = {
	vertical_alignment = "bottom",
	horizontal_alignment = "left",
	localize = true,
	font_size = 28,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		5,
		0,
		2
	}
}
local var_0_10 = {
	vertical_alignment = "bottom",
	horizontal_alignment = "right",
	localize = false,
	font_size = 28,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		-5,
		0,
		2
	}
}
local var_0_11 = {
	vertical_alignment = "bottm",
	horizontal_alignment = "left",
	localize = false,
	font_size = 28,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 0),
	offset = {
		0,
		0,
		2
	}
}
local var_0_12 = {
	font_type = "hell_shark",
	font_size = 30,
	localize = false,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	area_size = {
		200,
		200
	},
	offset = {
		-5,
		0,
		2
	}
}
local var_0_13 = {
	font_size = 45,
	upper_case = true,
	localize = false,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	area_size = {
		200,
		200
	},
	offset = {
		-5,
		0,
		2
	}
}
local var_0_14 = {
	font_size = 40,
	upper_case = true,
	word_wrap = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header_masked",
	text_color = Colors.get_color_table_with_alpha("white", 0),
	offset = {
		0,
		2,
		10
	}
}
local var_0_15 = {
	font_size = 20,
	horizontal_alignment = "left",
	use_shadow = true,
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		106,
		38,
		0
	},
	area_size = {
		250,
		100
	}
}
local var_0_16 = {
	font_size = 35,
	use_shadow = true,
	localize = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header_masked",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		106,
		10,
		0
	},
	area_size = {
		250,
		100
	}
}
local var_0_17 = {
	font_size = 18,
	use_shadow = true,
	localize = false,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		106,
		-15,
		0
	},
	area_size = {
		250,
		100
	}
}

local function var_0_18(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	return {
		scenegraph_id = "versus_progress_anchor",
		element = {
			passes = {
				{
					style_id = "header",
					pass_type = "text",
					text_id = "header"
				},
				{
					style_id = "experience",
					pass_type = "text",
					text_id = "experience"
				}
			}
		},
		content = {
			header = arg_10_1,
			experience = arg_10_3 and tostring(arg_10_2) or "0",
			xp = arg_10_2
		},
		style = {
			header = {
				font_size = 28,
				localize = false,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark",
				area_size = {
					275,
					50
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", arg_10_3 and 255 or 0),
				offset = {
					5,
					0,
					0
				}
			},
			experience = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				localize = false,
				font_size = 28,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", arg_10_3 and 255 or 0),
				offset = {
					-5,
					0,
					0
				}
			}
		},
		offset = {
			0,
			-50 + (arg_10_0 - 1) * -35,
			5
		}
	}
end

local function var_0_19(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = AchievementTemplates.achievements[arg_11_0]
	local var_11_1 = var_11_0.icon
	local var_11_2 = var_11_0.name
	local var_11_3 = type(var_11_0.desc) == "function" and var_11_0.desc() or Localize(var_11_0.desc)
	local var_11_4 = {}
	local var_11_5 = {
		passes = {}
	}
	local var_11_6 = var_11_5.passes
	local var_11_7 = {}
	local var_11_8 = {}

	var_11_6[#var_11_6 + 1] = {
		style_id = "completed",
		pass_type = "text",
		text_id = "completed",
		content_check_function = function (arg_12_0, arg_12_1)
			return arg_12_0.is_completed
		end
	}
	var_11_6[#var_11_6 + 1] = {
		style_id = "name",
		pass_type = "text",
		text_id = "name"
	}
	var_11_6[#var_11_6 + 1] = {
		style_id = "desc",
		pass_type = "text",
		text_id = "desc"
	}
	var_11_6[#var_11_6 + 1] = {
		pass_type = "texture",
		style_id = "icon",
		texture_id = "icon"
	}
	var_11_6[#var_11_6 + 1] = {
		style_id = "experience_start",
		pass_type = "texture_uv",
		content_id = "experience_start"
	}
	var_11_6[#var_11_6 + 1] = {
		style_id = "experience_end",
		pass_type = "texture_uv",
		content_id = "experience_end"
	}
	var_11_6[#var_11_6 + 1] = {
		pass_type = "texture",
		style_id = "outer_frame",
		texture_id = "masked_rect"
	}
	var_11_6[#var_11_6 + 1] = {
		pass_type = "texture",
		style_id = "inner_frame",
		texture_id = "masked_rect"
	}
	var_11_6[#var_11_6 + 1] = {
		pass_type = "texture",
		style_id = "marker",
		texture_id = "masked_rect"
	}
	var_11_7.experience_start = {
		texture_id = "versus_summary_screen_fill",
		uvs = {
			{
				0,
				0
			},
			{
				arg_11_1,
				1
			}
		}
	}
	var_11_7.experience_end = {
		texture_id = "versus_summary_screen_fill",
		uvs = {
			{
				arg_11_1,
				0
			},
			{
				arg_11_2,
				1
			}
		}
	}
	var_11_7.icon = var_11_1
	var_11_7.name = var_11_2
	var_11_7.desc = var_11_3
	var_11_7.completed = string.gsub(Localize("search_filter_completed"), "^%l", string.upper) .. "!"
	var_11_7.is_completed = arg_11_2 >= 1
	var_11_7.masked_rect = "rect_masked"
	var_11_7.progress = arg_11_2
	var_11_7.alpha_multiplier = arg_11_4 and 1 or 0
	var_11_8.completed = var_0_15
	var_11_8.name = var_0_16
	var_11_8.desc = var_0_17
	var_11_8.icon = {
		vertical_alignment = "center",
		masked = true,
		horizontal_alignment = "left",
		texture_size = {
			96,
			96
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		}
	}

	local var_11_9 = {
		106,
		-35
	}

	var_11_8.experience_start = {
		vertical_alignment = "center",
		masked = true,
		horizontal_alignment = "left",
		texture_size = {
			246 * arg_11_1,
			10
		},
		color = Colors.get_color_table_with_alpha("green", 255),
		offset = {
			var_11_9[1] + 2,
			var_11_9[2],
			2
		}
	}
	var_11_8.experience_end = {
		vertical_alignment = "center",
		masked = true,
		horizontal_alignment = "left",
		texture_size = {
			246 * (arg_11_2 - arg_11_1),
			10
		},
		color = Colors.get_color_table_with_alpha("yellow", 255),
		offset = {
			var_11_9[1] + 2 + 246 * arg_11_1,
			var_11_9[2],
			2
		}
	}
	var_11_8.outer_frame = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			250,
			14
		},
		color = {
			255,
			64,
			58.400000000000006,
			40.400000000000006
		},
		offset = {
			var_11_9[1],
			var_11_9[2],
			0
		}
	}
	var_11_8.inner_frame = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			246,
			10
		},
		color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			var_11_9[1] + 2,
			var_11_9[2],
			1
		}
	}
	var_11_8.marker = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			2,
			10
		},
		color = {
			255,
			32,
			29.200000000000003,
			20.200000000000003
		},
		offset = {
			246 * arg_11_1 + var_11_9[1],
			var_11_9[2],
			3
		}
	}
	var_11_4.element = var_11_5
	var_11_4.content = var_11_7
	var_11_4.style = var_11_8
	var_11_4.scenegraph_id = "challenge_entry_anchor"
	var_11_4.offset = arg_11_3 or {
		0,
		0,
		0
	}

	return var_11_4
end

local function var_0_20(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_2 and 255 or 0
	local var_13_1 = table.clone(var_0_3)
	local var_13_2 = arg_13_0.rarity
	local var_13_3 = UISettings.item_rarity_textures[var_13_2 or "default"]
	local var_13_4, var_13_5, var_13_6, var_13_7 = UIUtils.get_ui_information_from_item(arg_13_0)

	return {
		scenegraph_id = "hero_progress_item_anchor",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					item_id = "item",
					style_id = "item_tooltip",
					pass_type = "item_tooltip",
					content_check_function = function (arg_14_0, arg_14_1)
						return arg_14_0.hotspot.is_hover
					end
				},
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture"
				},
				{
					texture_id = "rarity_texture",
					style_id = "rarity_texture",
					pass_type = "texture"
				}
			}
		},
		content = {
			frame = "reward_pop_up_item_frame",
			hotspot = {},
			item = arg_13_0,
			texture_id = var_13_4,
			rarity_texture = var_13_3,
			size = var_13_1
		},
		style = {
			item = {
				font_size = 18,
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("white", 255)
				},
				offset = {
					0,
					0,
					100
				}
			},
			texture_id = {
				color = {
					var_13_0,
					255,
					255,
					255
				},
				texture_size = var_13_1,
				offset = {
					0,
					0,
					1
				}
			},
			frame = {
				color = {
					var_13_0,
					255,
					255,
					255
				},
				texture_size = var_13_1,
				offset = {
					0,
					0,
					2
				}
			},
			rarity_texture = {
				color = {
					var_13_0,
					255,
					255,
					255
				},
				texture_size = var_13_1,
				offset = {
					0,
					0,
					0
				}
			}
		},
		offset = arg_13_1
	}
end

local var_0_21 = string.gsub(Localize("search_filter_completed"), "^%l", string.upper)
local var_0_22 = Localize("achv_menu_achievements_category_title") .. " {#color(181,181,181,255)}(%d " .. var_0_21 .. ")"
local var_0_23 = Localize("hero_level_tag")
local var_0_24 = "%d XP"
local var_0_25 = {
	level_up = var_0_5("level_up_anchor"),
	insignia = UIWidgets.create_large_insignia("level_up_anchor", 1, false, {
		255,
		255,
		255,
		255
	}, {
		85,
		234.6
	}, {
		0,
		5,
		-2
	}),
	level_progress_bg = UIWidgets.create_simple_uv_texture("vertical_gradient", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "versus_progress_anchor", nil, nil, {
		128,
		0,
		0,
		0
	}, {
		0,
		-50,
		0
	}),
	level_progress_divider = UIWidgets.create_simple_rect("versus_progress_anchor", Colors.get_color_table_with_alpha("font_button_normal", 255), nil, {
		0,
		-48,
		0
	}, {
		var_0_4.versus_progress_anchor.size[1],
		2
	}),
	versus_progress_text = UIWidgets.create_simple_text(Localize("versus_level_tag"), "versus_progress_anchor", nil, nil, var_0_6),
	summary_text = UIWidgets.create_simple_text("achv_menu_summary_category_title", "versus_progress_anchor", nil, nil, var_0_9),
	summary_value_text = UIWidgets.create_simple_text(string.format(var_0_24, 0), "versus_progress_anchor", nil, nil, var_0_10)
}
local var_0_26 = {
	hero_progress_bg = UIWidgets.create_simple_uv_texture("vertical_gradient", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "hero_progress_anchor", nil, nil, {
		128,
		0,
		0,
		0
	}, {
		0,
		-50,
		0
	}),
	hero_progress_divider = UIWidgets.create_simple_rect("hero_progress_anchor", Colors.get_color_table_with_alpha("font_button_normal", 255), nil, {
		0,
		-48,
		0
	}, {
		var_0_4.hero_progress_anchor.size[1],
		2
	}),
	hero_progress_text = UIWidgets.create_simple_text(string.format(var_0_23, "hero_name"), "hero_progress_anchor", nil, nil, var_0_7),
	divider = UIWidgets.create_simple_rect("portrait_divider", {
		255,
		255,
		255,
		255
	}),
	hero_name = UIWidgets.create_simple_text("Sienna Fueganassus", "hero_name", nil, nil, var_0_12),
	career_name = UIWidgets.create_simple_text("NECROMANCER", "career_name", nil, nil, var_0_13),
	item_divider = UIWidgets.create_simple_rect("item_divider", {
		255,
		255,
		255,
		255
	}),
	experience_gained_text = UIWidgets.create_simple_text(string.format(var_0_24, 0), "experience_gained", nil, nil, var_0_11),
	experience_fg = UIWidgets.create_simple_uv_texture("summary_screen_fg", {
		{
			0.075,
			0.2
		},
		{
			0.927,
			1
		}
	}, "experience_bar", nil, nil, {
		255,
		255,
		255,
		255
	}, {
		0,
		0,
		20
	}),
	experience_bar = UIWidgets.create_summary_experience_bar("experience_bar", var_0_4.experience_bar.size, nil, 20),
	level_up_text = UIWidgets.create_simple_text(Localize("summary_screen_level_up"), "experience_bar", nil, nil, var_0_14),
	sparkle_effect = UIWidgets.create_simple_rotated_texture("sparkle_effect", 0, {
		var_0_2[1] / 2,
		var_0_2[2] / 2
	}, "sparkle_effect", nil, nil, {
		0,
		255,
		255,
		255
	}, nil, {
		55,
		65,
		50
	})
}
local var_0_27 = {
	challenge_progress_bg = UIWidgets.create_simple_uv_texture("vertical_gradient", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "challenge_progress_anchor", nil, nil, {
		128,
		0,
		0,
		0
	}, {
		0,
		-50,
		-5
	}),
	challenge_progress_divider = UIWidgets.create_simple_rect("challenge_progress_anchor", Colors.get_color_table_with_alpha("font_button_normal", 255), nil, {
		0,
		-48,
		0
	}, {
		var_0_4.challenge_progress_anchor.size[1],
		2
	}),
	challenge_progress_text = UIWidgets.create_simple_text(string.format(var_0_22, 0), "challenge_progress_anchor", nil, nil, var_0_8),
	challenge_progress_mask = UIWidgets.create_simple_texture("mask_rect", "challenge_progress_area"),
	challenge_progress_mask_top = UIWidgets.create_simple_texture("vertical_gradient_write_mask", "challenge_progress_area", nil, nil, nil, {
		15,
		var_0_4.challenge_progress_anchor.size[2],
		0
	}, {
		var_0_4.challenge_progress_anchor.size[1],
		20
	}),
	challenge_progress_mask_bottom = UIWidgets.create_simple_uv_texture("vertical_gradient_write_mask", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "challenge_progress_area", nil, nil, nil, {
		15,
		-20,
		0
	}, nil, {
		var_0_4.challenge_progress_anchor.size[1],
		20
	})
}
local var_0_28 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				arg_15_3.render_settings.alpha_multiplier = 0

				arg_15_3.play_sound("Play_vs_hud_progression_personal_report_start")
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				local var_16_0 = math.easeOutCubic(arg_16_3)

				arg_16_4.render_settings.alpha_multiplier = var_16_0

				local var_16_1 = arg_16_2.level_up

				var_16_1.offset[1] = math.lerp(-100, 0, var_16_0)
				var_16_1.style.level_text.offset[1] = math.lerp(-100, 0, var_16_0)
				var_16_1.style.level_text.color[1] = var_16_1.style.level_text.alpha_value or 255
				var_16_1.style.pattern_1.color[1] = var_16_1.style.pattern_1.alpha_value or 255
				var_16_1.style.pattern_2.color[1] = var_16_1.style.pattern_2.alpha_value or 255
				var_16_1.style.mask.color[1] = var_16_1.style.mask.alpha_value or 255
				var_16_1.style.versus_static_circle.color[1] = var_16_1.style.versus_static_circle.alpha_value or 255
				var_16_1.style.static_progress_marker.color[1] = var_16_1.style.static_progress_marker.alpha_value or 255
				var_16_1.style.versus_progress_circle.color[1] = var_16_1.style.versus_progress_circle.alpha_value or 255
				var_16_1.style.progress_marker.color[1] = var_16_1.style.progress_marker.alpha_value or 255

				local var_16_2 = arg_16_2.insignia

				var_16_2.offset[1] = math.lerp(-100, 0, var_16_0)
				var_16_2.style.insignia_main.color[1] = var_16_0 * 255
				arg_16_0.versus_progress_anchor.position[1] = math.lerp(arg_16_1.versus_progress_anchor.position[1] - 100, arg_16_1.versus_progress_anchor.position[1], var_16_0)
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end
		}
	},
	on_enter_forced = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				arg_18_3.render_settings.alpha_multiplier = 0
				arg_18_3.render_settings.hero_progress_alpha_multiplier = 0
				arg_18_3.render_settings.challenge_alpha_multiplier = 0
			end,
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				local var_19_0 = math.easeOutCubic(arg_19_3)

				arg_19_4.render_settings.alpha_multiplier = var_19_0
				arg_19_4.render_settings.hero_progress_alpha_multiplier = var_19_0
				arg_19_4.render_settings.challenge_alpha_multiplier = var_19_0

				local var_19_1 = arg_19_2.level_up

				var_19_1.offset[1] = math.lerp(-100, 0, var_19_0)
				var_19_1.style.level_text.offset[1] = math.lerp(-100, 0, var_19_0)
				var_19_1.style.level_text.color[1] = var_19_1.style.level_text.alpha_value or 255
				var_19_1.style.pattern_1.color[1] = var_19_1.style.pattern_1.alpha_value or 255
				var_19_1.style.pattern_2.color[1] = var_19_1.style.pattern_2.alpha_value or 255
				var_19_1.style.mask.color[1] = var_19_1.style.mask.alpha_value or 255
				var_19_1.style.versus_static_circle.color[1] = var_19_1.style.versus_static_circle.alpha_value or 255
				var_19_1.style.static_progress_marker.color[1] = var_19_1.style.static_progress_marker.alpha_value or 255
				var_19_1.style.versus_progress_circle.color[1] = var_19_1.style.versus_progress_circle.alpha_value or 255
				var_19_1.style.progress_marker.color[1] = var_19_1.style.progress_marker.alpha_value or 255

				local var_19_2 = arg_19_2.insignia

				var_19_2.offset[1] = math.lerp(-100, 0, var_19_0)
				var_19_2.style.insignia_main.color[1] = var_19_0 * 255
				arg_19_0.versus_progress_anchor.position[1] = math.lerp(arg_19_1.versus_progress_anchor.position[1] - 100, arg_19_1.versus_progress_anchor.position[1], var_19_0)
			end,
			on_complete = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end
		}
	},
	animate_progression_entry = {
		{
			name = "animate_header_in",
			start_progress = 0,
			end_progress = 0.4,
			init = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				local var_21_0 = arg_21_2[arg_21_3.data.entry_name]

				var_21_0.style.header.text_color[1] = 0
				var_21_0.style.experience.text_color[1] = 0

				arg_21_3.play_sound("Play_vs_hud_progression_xp_summary_table")
			end,
			update = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				local var_22_0 = math.easeOutCubic(arg_22_3)
				local var_22_1 = arg_22_2[arg_22_4.data.entry_name]

				var_22_1.style.header.text_color[1] = math.lerp(0, 255, var_22_0 * var_22_0)
				var_22_1.style.header.offset[1] = math.lerp(-50, 5, var_22_0)
			end,
			on_complete = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				local var_23_0 = arg_23_2[arg_23_3.data.entry_name]

				var_23_0.style.header.text_color[1] = 255
				var_23_0.style.header.offset[1] = 5
			end
		},
		{
			name = "animate_entry_experience",
			start_progress = 0.4,
			end_progress = 0.8,
			init = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				return
			end,
			update = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				local var_25_0 = math.easeOutCubic(arg_25_3)
				local var_25_1 = arg_25_2[arg_25_4.data.entry_name]

				var_25_1.content.experience = tostring(math.round(math.lerp(0, var_25_1.content.xp, var_25_0)))
				var_25_1.style.experience.text_color[1] = 255
			end,
			on_complete = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				local var_26_0 = arg_26_2[arg_26_3.data.entry_name]

				var_26_0.content.experience = tostring(var_26_0.content.xp)
			end
		},
		{
			name = "animate_progression_summary",
			start_progress = 0.8,
			end_progress = 1.2,
			init = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				local var_27_0 = arg_27_2[arg_27_3.data.entry_name].content.xp
				local var_27_1 = arg_27_2.summary_value_text

				var_27_1.content.value = (var_27_1.content.value or 0) + var_27_0
			end,
			update = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				local var_28_0 = math.ease_pulse(arg_28_3)
				local var_28_1 = 28
				local var_28_2 = var_28_1 * 1.255
				local var_28_3 = math.lerp(var_28_1, var_28_2, var_28_0)
				local var_28_4 = arg_28_2.summary_value_text

				var_28_4.content.text = string.format(var_0_24, var_28_4.content.value)
				var_28_4.style.text.font_size = var_28_3
			end,
			on_complete = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				arg_29_2.summary_value_text.style.text.font_size = 28
			end
		}
	},
	animate_level_up_start = {
		{
			name = "animate_level_up_widget",
			start_progress = 0,
			end_progress = 3,
			init = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				arg_30_3.play_sound("Play_vs_hud_progression_level_counter_loop")
				arg_30_3.set_global_wwise_parameter("summary_meter_progress", arg_30_3.data.sound_parameter_values[1])
			end,
			update = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
				local var_31_0 = math.easeInCubic(arg_31_3)

				arg_31_2.level_up.content.final_progress = math.lerp(var_0_1[1], var_0_1[2], arg_31_4.data.starting_progress + (arg_31_4.data.final_progress - arg_31_4.data.starting_progress) * var_31_0)

				arg_31_4.set_global_wwise_parameter("summary_meter_progress", math.lerp(arg_31_4.data.sound_parameter_values[1], arg_31_4.data.sound_parameter_values[2], var_31_0))
			end,
			on_complete = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				arg_32_2.level_up.content.final_progress = math.lerp(var_0_1[1], var_0_1[2], arg_32_3.data.final_progress)

				arg_32_3.play_sound("Stop_vs_hud_progression_level_counter_loop")

				local var_32_0 = arg_32_3.data.level

				if var_32_0 % 50 == 1 then
					arg_32_3.play_sound("Play_vs_hud_progression_level_up_50")
				elseif var_32_0 % 10 == 1 then
					arg_32_3.play_sound("Play_vs_hud_progression_level_up_5")
				else
					arg_32_3.play_sound("Play_vs_hud_progression_level_up")
				end
			end
		},
		{
			name = "close_top",
			start_progress = 3,
			end_progress = 3.4,
			init = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				local var_33_0 = arg_33_2.level_up

				var_33_0.style.left_lock.angle = math.degrees_to_radians(90)
				var_33_0.style.right_lock.angle = math.degrees_to_radians(-90)
				var_33_0.style.bottom_left_lock.offset[2] = -180
				var_33_0.style.bottom_right_lock.offset[2] = -180
			end,
			update = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
				local var_34_0 = math.easeInCubic(arg_34_3)
				local var_34_1 = arg_34_2.level_up

				var_34_1.style.lock_mask.color[1] = 255

				local var_34_2 = math.lerp(90, 0, var_34_0)

				var_34_1.style.left_lock.angle = math.degrees_to_radians(var_34_2)
				var_34_1.style.right_lock.angle = math.degrees_to_radians(-var_34_2)
			end,
			on_complete = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				return
			end
		},
		{
			name = "close_bottom",
			start_progress = 3.2,
			end_progress = 3.6,
			init = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				return
			end,
			update = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
				local var_37_0 = math.easeInCubic(arg_37_3)
				local var_37_1 = arg_37_2.level_up

				var_37_1.style.bottom_left_lock.offset[2] = math.lerp(-180, 14, var_37_0)
				var_37_1.style.bottom_right_lock.offset[2] = math.lerp(-180, 14, var_37_0)
			end,
			on_complete = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				return
			end
		},
		{
			name = "level_up",
			start_progress = 3.6,
			end_progress = 4.1,
			init = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				return
			end,
			update = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
				local var_40_0 = math.easeOutCubic(arg_40_3)
				local var_40_1 = arg_40_2.level_up

				var_40_1.content.level_text = arg_40_4.data.level
				var_40_1.style.lava.color[1] = var_40_0 * 255
				var_40_1.style.lava_mask.color[1] = 255
			end,
			on_complete = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				local var_41_0 = arg_41_2.level_up

				var_41_0.content.level_text = arg_41_3.data.level
				var_41_0.content.starting_progress = arg_41_3.data.on_complete_optional_starting_progress or 0
				var_41_0.content.final_progress = arg_41_3.data.on_complete_optional_final_progress or 0

				local var_41_1 = arg_41_2.insignia
				local var_41_2, var_41_3 = UIAtlasHelper.get_insignia_texture_settings_from_level(arg_41_3.data.level)

				var_41_1.content.insignia_main.uvs = var_41_2
				var_41_1.content.insignia_addon.uvs = var_41_3
				var_41_1.content.level = arg_41_3.data.level
			end
		},
		{
			name = "fade_out",
			start_progress = 4.6,
			end_progress = 5.1,
			init = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				return
			end,
			update = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
				local var_43_0 = math.easeOutCubic(arg_43_3)
				local var_43_1 = arg_43_2.level_up

				var_43_1.content.level_text = arg_43_4.data.level
				var_43_1.style.lava.color[1] = 255 - var_43_0 * 255
			end,
			on_complete = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				local var_44_0 = arg_44_2.level_up

				var_44_0.content.level_text = arg_44_3.data.level
				var_44_0.style.lava.color[1] = 0
				var_44_0.style.lava_mask.color[1] = 0

				local var_44_1 = arg_44_2.insignia
				local var_44_2, var_44_3 = UIAtlasHelper.get_insignia_texture_settings_from_level(arg_44_3.data.level)

				var_44_1.content.insignia_main.uvs = var_44_2
				var_44_1.content.insignia_addon.uvs = var_44_3
				var_44_1.content.level = arg_44_3.data.level
			end
		},
		{
			name = "open",
			start_progress = 5.1,
			end_progress = 5.6,
			init = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				return
			end,
			update = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
				local var_46_0 = math.easeOutCubic(arg_46_3)
				local var_46_1 = arg_46_2.level_up

				var_46_1.style.bottom_left_lock.offset[2] = math.lerp(14, -180, var_46_0)
				var_46_1.style.bottom_right_lock.offset[2] = math.lerp(14, -180, var_46_0)

				local var_46_2 = math.lerp(0, 90, var_46_0)

				var_46_1.style.left_lock.angle = math.degrees_to_radians(var_46_2)
				var_46_1.style.right_lock.angle = math.degrees_to_radians(-var_46_2)
			end,
			on_complete = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
				arg_47_2.level_up.style.lock_mask.color[1] = 0
			end
		}
	},
	animate_level_up_start_end = {
		{
			name = "animate_level_up_widget",
			start_progress = 0,
			end_progress = 3,
			init = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
				arg_48_3.play_sound("Play_vs_hud_progression_level_counter_loop")
				arg_48_3.set_global_wwise_parameter("summary_meter_progress", arg_48_3.data.sound_parameter_values[1])
			end,
			update = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
				local var_49_0 = math.easeCubic(arg_49_3)

				arg_49_2.level_up.content.final_progress = math.lerp(var_0_1[1], var_0_1[2], arg_49_4.data.starting_progress + (arg_49_4.data.final_progress - arg_49_4.data.starting_progress) * var_49_0)

				arg_49_4.set_global_wwise_parameter("summary_meter_progress", math.lerp(arg_49_4.data.sound_parameter_values[1], arg_49_4.data.sound_parameter_values[2], var_49_0))
			end,
			on_complete = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
				arg_50_2.level_up.content.final_progress = math.lerp(var_0_1[1], var_0_1[2], arg_50_3.data.final_progress)

				arg_50_3.play_sound("Stop_vs_hud_progression_level_counter_loop")
			end
		}
	},
	animate_level_up_end = {
		{
			name = "animate_level_up_widget",
			start_progress = 0,
			end_progress = 3,
			init = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
				arg_51_2.level_up.content.starting_progress = 0

				arg_51_3.play_sound("Play_vs_hud_progression_level_counter_loop")
				arg_51_3.set_global_wwise_parameter("summary_meter_progress", arg_51_3.data.sound_parameter_values[1])
			end,
			update = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
				local var_52_0 = math.easeOutCubic(arg_52_3)

				arg_52_2.level_up.content.final_progress = math.lerp(var_0_1[1], var_0_1[2], arg_52_4.data.starting_progress + (arg_52_4.data.final_progress - arg_52_4.data.starting_progress) * var_52_0)

				arg_52_4.set_global_wwise_parameter("summary_meter_progress", math.lerp(arg_52_4.data.sound_parameter_values[1], arg_52_4.data.sound_parameter_values[2], var_52_0))
			end,
			on_complete = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
				arg_53_2.level_up.content.final_progress = math.lerp(var_0_1[1], var_0_1[2], arg_53_3.data.final_progress)

				arg_53_3.play_sound("Stop_vs_hud_progression_level_counter_loop")
			end
		}
	},
	animate_level_up_instant = {
		{
			name = "animate_level_up_widget",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
				local var_54_0 = arg_54_2.level_up

				var_54_0.content.starting_progress = 1
				var_54_0.content.final_progress = 1
			end,
			update = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
				return
			end,
			on_complete = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
				return
			end
		}
	},
	animate_level_up_linear = {
		{
			name = "animate_level_up_widget",
			start_progress = 0,
			end_progress = 1.5,
			init = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
				local var_57_0 = arg_57_2.level_up

				var_57_0.content.starting_progress = 0
				var_57_0.style.lock_mask.color[1] = 0

				arg_57_3.play_sound("Play_vs_hud_progression_level_counter_loop")
				arg_57_3.set_global_wwise_parameter("summary_meter_progress", arg_57_3.data.sound_parameter_values[1])
			end,
			update = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4)
				local var_58_0 = arg_58_3

				arg_58_2.level_up.content.final_progress = math.lerp(var_0_1[1], var_0_1[2], var_58_0)

				arg_58_4.set_global_wwise_parameter("summary_meter_progress", math.lerp(arg_58_4.data.sound_parameter_values[1], arg_58_4.data.sound_parameter_values[2], var_58_0))
			end,
			on_complete = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3)
				arg_59_2.level_up.content.final_progress = math.lerp(var_0_1[1], var_0_1[2], arg_59_3.data.final_progress)

				arg_59_3.play_sound("Stop_vs_hud_progression_level_counter_loop")

				local var_59_0 = arg_59_3.data.level

				if var_59_0 % 50 == 1 then
					arg_59_3.play_sound("Play_vs_hud_progression_level_up_50")
				elseif var_59_0 % 10 == 1 then
					arg_59_3.play_sound("Play_vs_hud_progression_level_up_5")
				else
					arg_59_3.play_sound("Play_vs_hud_progression_level_up")
				end
			end
		},
		{
			name = "close_top",
			start_progress = 1.5,
			end_progress = 1.9,
			init = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
				local var_60_0 = arg_60_2.level_up

				var_60_0.style.left_lock.angle = math.degrees_to_radians(90)
				var_60_0.style.right_lock.angle = math.degrees_to_radians(-90)
				var_60_0.style.bottom_left_lock.offset[2] = -180
				var_60_0.style.bottom_right_lock.offset[2] = -180
			end,
			update = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
				local var_61_0 = math.easeInCubic(arg_61_3)
				local var_61_1 = arg_61_2.level_up

				var_61_1.style.lock_mask.color[1] = 255

				local var_61_2 = math.lerp(90, 0, var_61_0)

				var_61_1.style.left_lock.angle = math.degrees_to_radians(var_61_2)
				var_61_1.style.right_lock.angle = math.degrees_to_radians(-var_61_2)
			end,
			on_complete = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
				return
			end
		},
		{
			name = "close_bottom",
			start_progress = 1.7,
			end_progress = 2.1,
			init = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
				return
			end,
			update = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4)
				local var_64_0 = math.easeInCubic(arg_64_3)
				local var_64_1 = arg_64_2.level_up

				var_64_1.style.bottom_left_lock.offset[2] = math.lerp(-180, 14, var_64_0)
				var_64_1.style.bottom_right_lock.offset[2] = math.lerp(-180, 14, var_64_0)
			end,
			on_complete = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
				return
			end
		},
		{
			name = "level_up",
			start_progress = 2.1,
			end_progress = 2.5,
			init = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
				return
			end,
			update = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4)
				local var_67_0 = math.easeInCubic(arg_67_3)
				local var_67_1 = arg_67_2.level_up

				var_67_1.content.level_text = arg_67_4.data.level
				var_67_1.style.lava.color[1] = var_67_0 * 255
				var_67_1.style.lava_mask.color[1] = 255
			end,
			on_complete = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3)
				local var_68_0 = arg_68_2.level_up

				var_68_0.content.level_text = arg_68_3.data.level
				var_68_0.content.starting_progress = 0
				var_68_0.content.final_progress = 0

				local var_68_1 = arg_68_2.insignia
				local var_68_2, var_68_3 = UIAtlasHelper.get_insignia_texture_settings_from_level(arg_68_3.data.level)

				var_68_1.content.insignia_main.uvs = var_68_2
				var_68_1.content.insignia_addon.uvs = var_68_3
				var_68_1.content.level = arg_68_3.data.level
			end
		},
		{
			name = "fade_out",
			start_progress = 3,
			end_progress = 3.5,
			init = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3)
				return
			end,
			update = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4)
				local var_70_0 = math.easeOutCubic(arg_70_3)
				local var_70_1 = arg_70_2.level_up

				var_70_1.content.level_text = arg_70_4.data.level
				var_70_1.style.lava.color[1] = 255 - var_70_0 * 255
			end,
			on_complete = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
				local var_71_0 = arg_71_2.level_up

				var_71_0.content.level_text = arg_71_3.data.level
				var_71_0.style.lava.color[1] = 0
				var_71_0.style.lava_mask.color[1] = 0

				local var_71_1 = arg_71_2.insignia
				local var_71_2, var_71_3 = UIAtlasHelper.get_insignia_texture_settings_from_level(arg_71_3.data.level)

				var_71_1.content.insignia_main.uvs = var_71_2
				var_71_1.content.insignia_addon.uvs = var_71_3
				var_71_1.content.level = arg_71_3.data.level
			end
		},
		{
			name = "open",
			start_progress = 3.5,
			end_progress = 4,
			init = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3)
				return
			end,
			update = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4)
				local var_73_0 = math.easeOutCubic(arg_73_3)
				local var_73_1 = arg_73_2.level_up

				var_73_1.style.bottom_left_lock.offset[2] = math.lerp(14, -180, var_73_0)
				var_73_1.style.bottom_right_lock.offset[2] = math.lerp(14, -180, var_73_0)

				local var_73_2 = math.lerp(0, 90, var_73_0)

				var_73_1.style.left_lock.angle = math.degrees_to_radians(var_73_2)
				var_73_1.style.right_lock.angle = math.degrees_to_radians(-var_73_2)
			end,
			on_complete = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3)
				arg_74_2.level_up.style.lock_mask.color[1] = 0
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3)
				arg_75_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3, arg_76_4)
				local var_76_0 = math.easeOutCubic(arg_76_3)

				arg_76_4.render_settings.alpha_multiplier = 1 - var_76_0
			end,
			on_complete = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3)
				return
			end
		}
	},
	level_up = {
		{
			name = "spark",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3)
				return
			end,
			update = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4)
				local var_79_0 = arg_79_2.sparkle_effect
				local var_79_1 = var_79_0.style
				local var_79_2 = var_79_0.content
				local var_79_3 = var_79_0.offset
				local var_79_4 = 180 * math.easeOutCubic(arg_79_3)
				local var_79_5 = var_79_1.texture_id

				var_79_5.angle = math.degrees_to_radians(var_79_4)
				var_79_5.color[1] = 255 * math.ease_pulse(arg_79_3)
			end,
			on_complete = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3)
				return
			end
		}
	},
	animate_item = {
		{
			name = "animate_item",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3)
				local var_81_0 = arg_81_3.data
				local var_81_1 = var_81_0.widget

				var_81_1.style.texture_id.color[1] = 0
				var_81_1.style.frame.color[1] = 0
				var_81_1.style.rarity_texture.color[1] = 0

				local var_81_2 = arg_81_1.hero_progress_item_anchor.size

				var_81_1.content.size[1] = var_81_2[1] * 2
				var_81_1.content.size[2] = var_81_2[2] * 2

				local var_81_3 = var_81_0.offset

				var_81_1.offset[1] = var_81_3[1] - var_81_2[1] * 0.5
				var_81_1.offset[2] = var_81_3[2] - var_81_2[2] * 0.5

				arg_81_3.play_sound(arg_81_3.data.sound)
			end,
			update = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3, arg_82_4)
				local var_82_0 = arg_82_4.data.widget
				local var_82_1 = var_82_0.style
				local var_82_2 = var_82_0.content
				local var_82_3 = var_82_0.offset
				local var_82_4 = math.easeOutCubic(arg_82_3)
				local var_82_5 = arg_82_1.hero_progress_item_anchor.size

				var_82_2.size[1] = math.lerp(var_82_5[1] * 2, var_82_5[1], var_82_4)
				var_82_2.size[2] = math.lerp(var_82_5[2] * 2, var_82_5[2], var_82_4)
				var_82_1.texture_id.texture_size = var_82_2.size
				var_82_1.frame.texture_size = var_82_2.size
				var_82_1.rarity_texture.texture_size = var_82_2.size

				local var_82_6 = arg_82_4.data.offset

				var_82_0.offset[1] = var_82_6[1] - math.lerp(var_82_5[1] * 0.5, 0, var_82_4)
				var_82_0.offset[2] = var_82_6[2] - math.lerp(var_82_5[2] * 0.5, 0, var_82_4)
				var_82_1.texture_id.color[1] = math.lerp(0, 255, var_82_4)
				var_82_1.frame.color[1] = math.lerp(0, 255, var_82_4)
				var_82_1.rarity_texture.color[1] = math.lerp(0, 255, var_82_4)
			end,
			on_complete = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3)
				local var_83_0 = arg_83_3.data
				local var_83_1 = var_83_0.widget
				local var_83_2 = var_83_1.style
				local var_83_3 = var_83_1.content

				var_83_2.texture_id.color[1] = 255
				var_83_2.frame.color[1] = 255
				var_83_2.rarity_texture.color[1] = 255

				local var_83_4 = arg_83_1.hero_progress_item_anchor.size

				var_83_3.size[1] = var_83_4[1]
				var_83_3.size[2] = var_83_4[2]
				var_83_2.texture_id.texture_size = var_83_3.size
				var_83_2.frame.texture_size = var_83_3.size
				var_83_2.rarity_texture.texture_size = var_83_3.size

				local var_83_5 = var_83_0.offset

				var_83_1.offset[1] = var_83_5[1]
				var_83_1.offset[2] = var_83_5[2]
			end
		}
	},
	versus_level_up_pause = {
		{
			name = "pause",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3)
				return
			end,
			update = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
				return
			end,
			on_complete = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3)
				return
			end
		}
	},
	animate_hero_progress = {
		{
			name = "animate_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3)
				arg_87_3.render_settings.hero_progress_alpha_multiplier = 0
			end,
			update = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3, arg_88_4)
				local var_88_0 = math.easeOutCubic(arg_88_3)

				arg_88_4.render_settings.hero_progress_alpha_multiplier = var_88_0
				arg_88_0.hero_progress_anchor.position[1] = math.lerp(arg_88_1.hero_progress_anchor.position[1] + 100, arg_88_1.hero_progress_anchor.position[1], var_88_0)
			end,
			on_complete = function (arg_89_0, arg_89_1, arg_89_2, arg_89_3)
				return
			end
		},
		{
			name = "animate_experience_gained",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3)
				return
			end,
			update = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3, arg_91_4)
				local var_91_0 = math.easeOutCubic(arg_91_3)

				arg_91_0.experience_gained.position[1] = math.lerp(arg_91_1.experience_gained.position[1] - 50, arg_91_1.experience_gained.position[1], var_91_0)
				arg_91_2.experience_gained_text.style.text.text_color[1] = 255 * var_91_0
			end,
			on_complete = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3)
				return
			end
		}
	},
	animate_hero_progress_forced = {
		{
			name = "animate_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_93_0, arg_93_1, arg_93_2, arg_93_3)
				arg_93_3.render_settings.hero_progress_alpha_multiplier = 0
				arg_93_2.experience_gained_text.style.text.text_color[1] = 255
			end,
			update = function (arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
				local var_94_0 = math.easeOutCubic(arg_94_3)

				arg_94_4.render_settings.hero_progress_alpha_multiplier = var_94_0
				arg_94_0.hero_progress_anchor.position[1] = math.lerp(arg_94_1.hero_progress_anchor.position[1] + 100, arg_94_1.hero_progress_anchor.position[1], var_94_0)
			end,
			on_complete = function (arg_95_0, arg_95_1, arg_95_2, arg_95_3)
				return
			end
		}
	},
	animate_challenge_progress = {
		{
			name = "animate_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_96_0, arg_96_1, arg_96_2, arg_96_3)
				arg_96_3.render_settings.challenge_alpha_multiplier = 0
			end,
			update = function (arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4)
				local var_97_0 = math.easeOutCubic(arg_97_3)

				arg_97_4.render_settings.challenge_alpha_multiplier = var_97_0
				arg_97_0.challenge_progress_anchor.position[1] = math.lerp(arg_97_1.challenge_progress_anchor.position[1] + 100, arg_97_1.challenge_progress_anchor.position[1], var_97_0)
			end,
			on_complete = function (arg_98_0, arg_98_1, arg_98_2, arg_98_3)
				return
			end
		}
	},
	animate_challenge_entry = {
		{
			name = "challenge_entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_99_0, arg_99_1, arg_99_2, arg_99_3)
				local var_99_0 = arg_99_2[arg_99_3.data.entry_name]

				var_99_0.base_offset = var_99_0.offset[1]
			end,
			update = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3, arg_100_4)
				local var_100_0 = math.easeOutCubic(arg_100_3)
				local var_100_1 = arg_100_2[arg_100_4.data.entry_name]

				var_100_1.offset[1] = math.lerp(var_100_1.base_offset + 50, var_100_1.base_offset, var_100_0)
				var_100_1.content.alpha_multiplier = var_100_0
			end,
			on_complete = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3)
				return
			end
		}
	},
	wait = {
		{
			name = "challenge_entry",
			start_progress = 0,
			end_progress = 0.1,
			init = function (arg_102_0, arg_102_1, arg_102_2, arg_102_3)
				return
			end,
			update = function (arg_103_0, arg_103_1, arg_103_2, arg_103_3, arg_103_4)
				return
			end,
			on_complete = function (arg_104_0, arg_104_1, arg_104_2, arg_104_3)
				return
			end
		}
	}
}

return {
	scenegraph_definition = var_0_4,
	widget_definitions = var_0_25,
	challenge_widget_definitions = var_0_27,
	hero_progress_widget_definitions = var_0_26,
	animation_definitions = var_0_28,
	challenge_progress_text_string = var_0_22,
	hero_progress_text_string = var_0_23,
	summary_value_string = var_0_24,
	create_summery_entry_func = var_0_18,
	bar_thresholds = var_0_1,
	create_item_widget_func = var_0_20,
	create_challenge_entry_func = var_0_19
}
