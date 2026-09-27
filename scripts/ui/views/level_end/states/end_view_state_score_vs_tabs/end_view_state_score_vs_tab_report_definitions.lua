-- chunkname: @scripts/ui/views/level_end/states/end_view_state_score_vs_tabs/end_view_state_score_vs_tab_report_definitions.lua

local tbl = {
	336,
	368
}
local tbl_2 = {
	0.12,
	0.865
}
local tbl_3 = {
	128,
	128
}
local tbl_4 = {
	80,
	80
}
local tbl_5 = {
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
			80 + tbl[1] * 0.5,
			-344 - tbl[2] * 0.5,
			10
		}
	},
	level_up_text = {
		vertical_alignment = "center",
		parent = "level_up_anchor",
		horizontal_alignment = "center",
		size = tbl
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
			tbl[1] * 0.5 + 25,
			tbl[2] * 0.5,
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
		size = tbl_4,
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
		size = tbl_3
	}
}

local function fn(arg_1_0)
	-- function 1
	local tbl_3 = {}
	local tbl_4 = {
		passes = {}
	}
	local passes = tbl_4.passes
	local tbl_5 = {}
	local tbl_6 = {}

	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "foreground",
		texture_id = "versus_circle_foreground"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "middle_fill",
		texture_id = "versus_circle_background"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "background",
		texture_id = "versus_circle_background"
	}
	passes[#passes + 1] = {
		pass_type = "rotated_texture",
		style_id = "left_lock",
		texture_id = "left_lock"
	}
	passes[#passes + 1] = {
		pass_type = "rotated_texture",
		style_id = "right_lock",
		texture_id = "left_lock"
	}
	passes[#passes + 1] = {
		style_id = "bottom_left_lock",
		pass_type = "texture_uv",
		content_id = "bottom_left_lock"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "bottom_right_lock",
		texture_id = "bottom_lock"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "lock_mask",
		texture_id = "lock_mask"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "lava",
		texture_id = "lava"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "lava_mask",
		texture_id = "lava_mask"
	}
	passes[#passes + 1] = {
		style_id = "pattern_1",
		texture_id = "versus_circle_pattern",
		pass_type = "rotated_texture",
		content_change_function = function (arg_2_0, arg_2_1)
			-- function 2
			local time_since_launch = Application.time_since_launch()

			arg_2_1.angle = math.degrees_to_radians(time_since_launch * 12 % 360)
		end
	}
	passes[#passes + 1] = {
		style_id = "pattern_2",
		texture_id = "versus_circle_pattern",
		pass_type = "rotated_texture",
		content_change_function = function (arg_3_0, arg_3_1)
			-- function 3
			local time_since_launch = Application.time_since_launch()

			arg_3_1.angle = math.degrees_to_radians(time_since_launch * 4 % 360)
		end
	}
	passes[#passes + 1] = {
		style_id = "static_progress_marker",
		texture_id = "static_marker",
		pass_type = "rotated_texture",
		content_check_function = function (self, arg_4_1)
			-- function 4
			return not (self.starting_progress >= tbl_2[1]) or self.starting_progress < tbl_2[2]
		end,
		content_change_function = function (self, arg_5_1)
			-- function 5
			arg_5_1.angle = self.starting_progress * 2 * math.pi
		end
	}
	passes[#passes + 1] = {
		style_id = "mask",
		texture_id = "versus_circle_mask",
		pass_type = "gradient_mask_texture",
		content_change_function = function (self, arg_6_1)
			-- function 6
			arg_6_1.gradient_threshold = self.final_progress
		end
	}
	passes[#passes + 1] = {
		style_id = "versus_static_circle",
		texture_id = "versus_static_circle",
		pass_type = "gradient_mask_texture",
		content_change_function = function (self, arg_7_1)
			-- function 7
			arg_7_1.gradient_threshold = self.starting_progress
		end
	}
	passes[#passes + 1] = {
		style_id = "versus_progress_circle",
		texture_id = "versus_progress_circle",
		pass_type = "gradient_mask_texture",
		content_change_function = function (self, arg_8_1)
			-- function 8
			arg_8_1.gradient_threshold = self.final_progress
		end
	}
	passes[#passes + 1] = {
		style_id = "progress_marker",
		texture_id = "rect_smooth",
		pass_type = "rotated_texture",
		content_change_function = function (self, arg_9_1)
			-- function 9
			arg_9_1.angle = self.final_progress * 2 * math.pi
		end
	}
	passes[#passes + 1] = {
		scenegraph_id = "level_up_text",
		style_id = "level_text",
		pass_type = "text",
		text_id = "level_text"
	}
	tbl_6.foreground = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			tbl[1],
			tbl[2]
		},
		color = Colors.get_color_table_with_alpha("white", 255)
	}
	tbl_6.middle_fill = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			tbl[1] * 0.75,
			tbl[2] * 0.75
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			0,
			-9
		}
	}
	tbl_6.background = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			tbl[1],
			tbl[2]
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			0,
			-10
		}
	}
	tbl_6.left_lock = {
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
	tbl_6.right_lock = {
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
	tbl_6.bottom_right_lock = {
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
	tbl_6.bottom_left_lock = {
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
	tbl_6.lock_mask = {
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
	tbl_6.lava = {
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
	tbl_6.lava_mask = {
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
	tbl_6.pattern_1 = {
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
	tbl_6.pattern_2 = {
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
	tbl_6.mask = {
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
	tbl_6.versus_static_circle = {
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
	tbl_6.static_progress_marker = {
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
	tbl_6.versus_progress_circle = {
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
	tbl_6.progress_marker = {
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
	tbl_6.level_text = {
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
	tbl_5.level_text = "0"
	tbl_5.starting_progress = 0
	tbl_5.final_progress = 0
	tbl_5.versus_circle_foreground = "versus_circle_foreground"
	tbl_5.versus_circle_background = "versus_circle_background"
	tbl_5.versus_static_circle = "versus_static_circle"
	tbl_5.rect_smooth = "rect_smooth"
	tbl_5.static_marker = "static_marker"
	tbl_5.versus_circle_mask = "versus_circle_mask"
	tbl_5.versus_circle_pattern = "versus_circle_pattern"
	tbl_5.versus_progress_circle = "versus_progress_circle"
	tbl_5.bg_circle = "circle"
	tbl_5.left_lock = "versus_end_screen_cover_top_left"
	tbl_5.bottom_lock = "versus_end_screen_cover_bottom_left"
	tbl_5.bottom_left_lock = {
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
	tbl_5.lock_mask = "versus_lock_mask"
	tbl_5.lava = "lava"
	tbl_5.lava_mask = "versus_circle_mask_2"
	tbl_3.element = tbl_4
	tbl_3.content = tbl_5
	tbl_3.style = tbl_6
	tbl_3.scenegraph_id = arg_1_0
	tbl_3.offset = {
		0,
		0,
		0
	}

	return tbl_3
end

local tbl_6 = {
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
local tbl_7 = {
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
local tbl_8 = {
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
local tbl_9 = {
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
local tbl_10 = {
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
local tbl_11 = {
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
local tbl_12 = {
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
local tbl_13 = {
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
local tbl_14 = {
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
local tbl_15 = {
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
local tbl_16 = {
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
local tbl_17 = {
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

local function fn_2(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local tbl = {
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
		}
	}
	local tbl_2 = {
		header = arg_10_1
	}
	local var_10_2

	if not arg_10_3 then
		var_10_2 = tostring(arg_10_2)

		if not var_10_2 then
			-- Nothing
		end
	end

	var_10_2 = "0"

	::label_10_0::

	tbl_2.experience = var_10_2
	tbl_2.xp = arg_10_2
	tbl.content = tbl_2

	local tbl_3 = {}
	local tbl_4 = {
		font_size = 28,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true,
		font_type = "hell_shark",
		area_size = {
			275,
			50
		}
	}
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha
	local str = "font_button_normal"
	local flag

	flag = not arg_10_3 and 255 and 0
	tbl_4.text_color = get_color_table_with_alpha(str, flag)
	tbl_4.offset = {
		5,
		0,
		0
	}
	tbl_3.header = tbl_4

	local tbl_5 = {
		vertical_alignment = "top",
		horizontal_alignment = "right",
		localize = false,
		font_size = 28,
		font_type = "hell_shark"
	}
	local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha
	local str_2 = "font_default"
	local flag_2

	flag_2 = not arg_10_3 and 255 and 0
	tbl_5.text_color = get_color_table_with_alpha_2(str_2, flag_2)
	tbl_5.offset = {
		-5,
		0,
		0
	}
	tbl_3.experience = tbl_5
	tbl.style = tbl_3
	tbl.offset = {
		0,
		-50 + (arg_10_0 - 1) * -35,
		5
	}

	return tbl
end

local function fn_3(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local var_11_0 = AchievementTemplates.achievements[arg_11_0]
	local icon = var_11_0.icon
	local name = var_11_0.name
	local desc

	if type(var_11_0.desc) == "function" then
		desc = var_11_0.desc()

		if not desc then
			-- Nothing
		end
	end

	desc = Localize(var_11_0.desc)

	::label_11_0::

	local tbl = {}
	local tbl_2 = {
		passes = {}
	}
	local passes = tbl_2.passes
	local tbl_3 = {}
	local tbl_4 = {}

	passes[#passes + 1] = {
		style_id = "completed",
		pass_type = "text",
		text_id = "completed",
		content_check_function = function (self, arg_12_1)
			-- function 12
			return self.is_completed
		end
	}
	passes[#passes + 1] = {
		style_id = "name",
		pass_type = "text",
		text_id = "name"
	}
	passes[#passes + 1] = {
		style_id = "desc",
		pass_type = "text",
		text_id = "desc"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "icon",
		texture_id = "icon"
	}
	passes[#passes + 1] = {
		style_id = "experience_start",
		pass_type = "texture_uv",
		content_id = "experience_start"
	}
	passes[#passes + 1] = {
		style_id = "experience_end",
		pass_type = "texture_uv",
		content_id = "experience_end"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "outer_frame",
		texture_id = "masked_rect"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "inner_frame",
		texture_id = "masked_rect"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "marker",
		texture_id = "masked_rect"
	}
	tbl_3.experience_start = {
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
	tbl_3.experience_end = {
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
	tbl_3.icon = icon
	tbl_3.name = name
	tbl_3.desc = desc
	tbl_3.completed = string.gsub(Localize("search_filter_completed"), "^%l", string.upper) .. "!"
	tbl_3.is_completed = arg_11_2 >= 1
	tbl_3.masked_rect = "rect_masked"
	tbl_3.progress = arg_11_2

	local flag

	flag = not arg_11_4 and 1 and 0
	tbl_3.alpha_multiplier = flag
	tbl_4.completed = tbl_15
	tbl_4.name = tbl_16
	tbl_4.desc = tbl_17
	tbl_4.icon = {
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

	local tbl_5 = {
		106,
		-35
	}

	tbl_4.experience_start = {
		vertical_alignment = "center",
		masked = true,
		horizontal_alignment = "left",
		texture_size = {
			246 * arg_11_1,
			10
		},
		color = Colors.get_color_table_with_alpha("green", 255),
		offset = {
			tbl_5[1] + 2,
			tbl_5[2],
			2
		}
	}
	tbl_4.experience_end = {
		vertical_alignment = "center",
		masked = true,
		horizontal_alignment = "left",
		texture_size = {
			246 * (arg_11_2 - arg_11_1),
			10
		},
		color = Colors.get_color_table_with_alpha("yellow", 255),
		offset = {
			tbl_5[1] + 2 + 246 * arg_11_1,
			tbl_5[2],
			2
		}
	}
	tbl_4.outer_frame = {
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
			tbl_5[1],
			tbl_5[2],
			0
		}
	}
	tbl_4.inner_frame = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			246,
			10
		},
		color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			tbl_5[1] + 2,
			tbl_5[2],
			1
		}
	}
	tbl_4.marker = {
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
			246 * arg_11_1 + tbl_5[1],
			tbl_5[2],
			3
		}
	}
	tbl.element = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.scenegraph_id = "challenge_entry_anchor"
	tbl.offset = arg_11_3 or {
		0,
		0,
		0
	}

	return tbl
end

local function fn_4(self, arg_13_1, arg_13_2)
	-- function 13
	local flag

	flag = not arg_13_2 and 255 and 0

	local clone = table.clone(tbl_4)
	local rarity = self.rarity
	local var_13_3 = UISettings.item_rarity_textures[rarity or "default"]
	local get_ui_information_from_item, var_13_5, var_13_6, var_13_7 = UIUtils.get_ui_information_from_item(self)

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
					content_check_function = function (self, arg_14_1)
						-- function 14
						return self.hotspot.is_hover
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
			item = self,
			texture_id = get_ui_information_from_item,
			rarity_texture = var_13_3,
			size = clone
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
					flag,
					255,
					255,
					255
				},
				texture_size = clone,
				offset = {
					0,
					0,
					1
				}
			},
			frame = {
				color = {
					flag,
					255,
					255,
					255
				},
				texture_size = clone,
				offset = {
					0,
					0,
					2
				}
			},
			rarity_texture = {
				color = {
					flag,
					255,
					255,
					255
				},
				texture_size = clone,
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

local gsub = string.gsub(Localize("search_filter_completed"), "^%l", string.upper)
local str = Localize("achv_menu_achievements_category_title") .. " {#color(181,181,181,255)}(%d " .. gsub .. ")"
local var_0_23 = Localize("hero_level_tag")
local str_2 = "%d XP"
local tbl_18 = {
	level_up = fn("level_up_anchor"),
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
		tbl_5.versus_progress_anchor.size[1],
		2
	}),
	versus_progress_text = UIWidgets.create_simple_text(Localize("versus_level_tag"), "versus_progress_anchor", nil, nil, tbl_6),
	summary_text = UIWidgets.create_simple_text("achv_menu_summary_category_title", "versus_progress_anchor", nil, nil, tbl_9),
	summary_value_text = UIWidgets.create_simple_text(string.format(str_2, 0), "versus_progress_anchor", nil, nil, tbl_10)
}
local tbl_19 = {
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
		tbl_5.hero_progress_anchor.size[1],
		2
	}),
	hero_progress_text = UIWidgets.create_simple_text(string.format(var_0_23, "hero_name"), "hero_progress_anchor", nil, nil, tbl_7),
	divider = UIWidgets.create_simple_rect("portrait_divider", {
		255,
		255,
		255,
		255
	}),
	hero_name = UIWidgets.create_simple_text("Sienna Fueganassus", "hero_name", nil, nil, tbl_12),
	career_name = UIWidgets.create_simple_text("NECROMANCER", "career_name", nil, nil, tbl_13),
	item_divider = UIWidgets.create_simple_rect("item_divider", {
		255,
		255,
		255,
		255
	}),
	experience_gained_text = UIWidgets.create_simple_text(string.format(str_2, 0), "experience_gained", nil, nil, tbl_11),
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
	experience_bar = UIWidgets.create_summary_experience_bar("experience_bar", tbl_5.experience_bar.size, nil, 20),
	level_up_text = UIWidgets.create_simple_text(Localize("summary_screen_level_up"), "experience_bar", nil, nil, tbl_14),
	sparkle_effect = UIWidgets.create_simple_rotated_texture("sparkle_effect", 0, {
		tbl_3[1] / 2,
		tbl_3[2] / 2
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
local tbl_20 = {
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
		tbl_5.challenge_progress_anchor.size[1],
		2
	}),
	challenge_progress_text = UIWidgets.create_simple_text(string.format(str, 0), "challenge_progress_anchor", nil, nil, tbl_8),
	challenge_progress_mask = UIWidgets.create_simple_texture("mask_rect", "challenge_progress_area"),
	challenge_progress_mask_top = UIWidgets.create_simple_texture("vertical_gradient_write_mask", "challenge_progress_area", nil, nil, nil, {
		15,
		tbl_5.challenge_progress_anchor.size[2],
		0
	}, {
		tbl_5.challenge_progress_anchor.size[1],
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
		tbl_5.challenge_progress_anchor.size[1],
		20
	})
}
local tbl_21 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				arg_15_3.render_settings.alpha_multiplier = 0

				arg_15_3.play_sound("Play_vs_hud_progression_personal_report_start")
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				-- function 16
				local easeOutCubic = math.easeOutCubic(arg_16_3)

				arg_16_4.render_settings.alpha_multiplier = easeOutCubic

				local level_up = arg_16_2.level_up

				level_up.offset[1] = math.lerp(-100, 0, easeOutCubic)
				level_up.style.level_text.offset[1] = math.lerp(-100, 0, easeOutCubic)

				local color = level_up.style.level_text.color
				local alpha_value = level_up.style.level_text.alpha_value

				alpha_value = alpha_value or 255
				color[1] = alpha_value

				local color_2 = level_up.style.pattern_1.color
				local alpha_value_2 = level_up.style.pattern_1.alpha_value

				alpha_value_2 = alpha_value_2 or 255
				color_2[1] = alpha_value_2

				local color_3 = level_up.style.pattern_2.color
				local alpha_value_3 = level_up.style.pattern_2.alpha_value

				alpha_value_3 = alpha_value_3 or 255
				color_3[1] = alpha_value_3

				local color_4 = level_up.style.mask.color
				local alpha_value_4 = level_up.style.mask.alpha_value

				alpha_value_4 = alpha_value_4 or 255
				color_4[1] = alpha_value_4

				local color_5 = level_up.style.versus_static_circle.color
				local alpha_value_5 = level_up.style.versus_static_circle.alpha_value

				alpha_value_5 = alpha_value_5 or 255
				color_5[1] = alpha_value_5

				local color_6 = level_up.style.static_progress_marker.color
				local alpha_value_6 = level_up.style.static_progress_marker.alpha_value

				alpha_value_6 = alpha_value_6 or 255
				color_6[1] = alpha_value_6

				local color_7 = level_up.style.versus_progress_circle.color
				local alpha_value_7 = level_up.style.versus_progress_circle.alpha_value

				alpha_value_7 = alpha_value_7 or 255
				color_7[1] = alpha_value_7

				local color_8 = level_up.style.progress_marker.color
				local alpha_value_8 = level_up.style.progress_marker.alpha_value

				alpha_value_8 = alpha_value_8 or 255
				color_8[1] = alpha_value_8

				local insignia = arg_16_2.insignia

				insignia.offset[1] = math.lerp(-100, 0, easeOutCubic)
				insignia.style.insignia_main.color[1] = easeOutCubic * 255
				arg_16_0.versus_progress_anchor.position[1] = math.lerp(arg_16_1.versus_progress_anchor.position[1] - 100, arg_16_1.versus_progress_anchor.position[1], easeOutCubic)
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
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
				-- function 18
				arg_18_3.render_settings.alpha_multiplier = 0
				arg_18_3.render_settings.hero_progress_alpha_multiplier = 0
				arg_18_3.render_settings.challenge_alpha_multiplier = 0
			end,
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				-- function 19
				local easeOutCubic = math.easeOutCubic(arg_19_3)

				arg_19_4.render_settings.alpha_multiplier = easeOutCubic
				arg_19_4.render_settings.hero_progress_alpha_multiplier = easeOutCubic
				arg_19_4.render_settings.challenge_alpha_multiplier = easeOutCubic

				local level_up = arg_19_2.level_up

				level_up.offset[1] = math.lerp(-100, 0, easeOutCubic)
				level_up.style.level_text.offset[1] = math.lerp(-100, 0, easeOutCubic)

				local color = level_up.style.level_text.color
				local alpha_value = level_up.style.level_text.alpha_value

				alpha_value = alpha_value or 255
				color[1] = alpha_value

				local color_2 = level_up.style.pattern_1.color
				local alpha_value_2 = level_up.style.pattern_1.alpha_value

				alpha_value_2 = alpha_value_2 or 255
				color_2[1] = alpha_value_2

				local color_3 = level_up.style.pattern_2.color
				local alpha_value_3 = level_up.style.pattern_2.alpha_value

				alpha_value_3 = alpha_value_3 or 255
				color_3[1] = alpha_value_3

				local color_4 = level_up.style.mask.color
				local alpha_value_4 = level_up.style.mask.alpha_value

				alpha_value_4 = alpha_value_4 or 255
				color_4[1] = alpha_value_4

				local color_5 = level_up.style.versus_static_circle.color
				local alpha_value_5 = level_up.style.versus_static_circle.alpha_value

				alpha_value_5 = alpha_value_5 or 255
				color_5[1] = alpha_value_5

				local color_6 = level_up.style.static_progress_marker.color
				local alpha_value_6 = level_up.style.static_progress_marker.alpha_value

				alpha_value_6 = alpha_value_6 or 255
				color_6[1] = alpha_value_6

				local color_7 = level_up.style.versus_progress_circle.color
				local alpha_value_7 = level_up.style.versus_progress_circle.alpha_value

				alpha_value_7 = alpha_value_7 or 255
				color_7[1] = alpha_value_7

				local color_8 = level_up.style.progress_marker.color
				local alpha_value_8 = level_up.style.progress_marker.alpha_value

				alpha_value_8 = alpha_value_8 or 255
				color_8[1] = alpha_value_8

				local insignia = arg_19_2.insignia

				insignia.offset[1] = math.lerp(-100, 0, easeOutCubic)
				insignia.style.insignia_main.color[1] = easeOutCubic * 255
				arg_19_0.versus_progress_anchor.position[1] = math.lerp(arg_19_1.versus_progress_anchor.position[1] - 100, arg_19_1.versus_progress_anchor.position[1], easeOutCubic)
			end,
			on_complete = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
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
				-- function 21
				local var_21_0 = arg_21_2[arg_21_3.data.entry_name]

				var_21_0.style.header.text_color[1] = 0
				var_21_0.style.experience.text_color[1] = 0

				arg_21_3.play_sound("Play_vs_hud_progression_xp_summary_table")
			end,
			update = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				-- function 22
				local easeOutCubic = math.easeOutCubic(arg_22_3)
				local var_22_1 = arg_22_2[arg_22_4.data.entry_name]

				var_22_1.style.header.text_color[1] = math.lerp(0, 255, easeOutCubic * easeOutCubic)
				var_22_1.style.header.offset[1] = math.lerp(-50, 5, easeOutCubic)
			end,
			on_complete = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				-- function 23
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
				-- function 24
				return
			end,
			update = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				-- function 25
				local easeOutCubic = math.easeOutCubic(arg_25_3)
				local var_25_1 = arg_25_2[arg_25_4.data.entry_name]

				var_25_1.content.experience = tostring(math.round(math.lerp(0, var_25_1.content.xp, easeOutCubic)))
				var_25_1.style.experience.text_color[1] = 255
			end,
			on_complete = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				local var_26_0 = arg_26_2[arg_26_3.data.entry_name]

				var_26_0.content.experience = tostring(var_26_0.content.xp)
			end
		},
		{
			name = "animate_progression_summary",
			start_progress = 0.8,
			end_progress = 1.2,
			init = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				local xp = arg_27_2[arg_27_3.data.entry_name].content.xp
				local summary_value_text = arg_27_2.summary_value_text
				local content = summary_value_text.content
				local value = summary_value_text.content.value

				value = value or 0
				content.value = value + xp
			end,
			update = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				-- function 28
				local ease_pulse = math.ease_pulse(arg_28_3)
				local num = 28
				local num_2 = num * 1.255
				local lerp = math.lerp(num, num_2, ease_pulse)
				local summary_value_text = arg_28_2.summary_value_text

				summary_value_text.content.text = string.format(str_2, summary_value_text.content.value)
				summary_value_text.style.text.font_size = lerp
			end,
			on_complete = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
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
				-- function 30
				arg_30_3.play_sound("Play_vs_hud_progression_level_counter_loop")
				arg_30_3.set_global_wwise_parameter("summary_meter_progress", arg_30_3.data.sound_parameter_values[1])
			end,
			update = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
				-- function 31
				local easeInCubic = math.easeInCubic(arg_31_3)

				arg_31_2.level_up.content.final_progress = math.lerp(tbl_2[1], tbl_2[2], arg_31_4.data.starting_progress + (arg_31_4.data.final_progress - arg_31_4.data.starting_progress) * easeInCubic)

				arg_31_4.set_global_wwise_parameter("summary_meter_progress", math.lerp(arg_31_4.data.sound_parameter_values[1], arg_31_4.data.sound_parameter_values[2], easeInCubic))
			end,
			on_complete = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				-- function 32
				arg_32_2.level_up.content.final_progress = math.lerp(tbl_2[1], tbl_2[2], arg_32_3.data.final_progress)

				arg_32_3.play_sound("Stop_vs_hud_progression_level_counter_loop")

				local level = arg_32_3.data.level

				if level % 50 == 1 then
					arg_32_3.play_sound("Play_vs_hud_progression_level_up_50")
				elseif level % 10 == 1 then
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
				-- function 33
				local level_up = arg_33_2.level_up

				level_up.style.left_lock.angle = math.degrees_to_radians(90)
				level_up.style.right_lock.angle = math.degrees_to_radians(-90)
				level_up.style.bottom_left_lock.offset[2] = -180
				level_up.style.bottom_right_lock.offset[2] = -180
			end,
			update = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
				-- function 34
				local easeInCubic = math.easeInCubic(arg_34_3)
				local level_up = arg_34_2.level_up

				level_up.style.lock_mask.color[1] = 255

				local lerp = math.lerp(90, 0, easeInCubic)

				level_up.style.left_lock.angle = math.degrees_to_radians(lerp)
				level_up.style.right_lock.angle = math.degrees_to_radians(-lerp)
			end,
			on_complete = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				-- function 35
				return
			end
		},
		{
			name = "close_bottom",
			start_progress = 3.2,
			end_progress = 3.6,
			init = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				-- function 36
				return
			end,
			update = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
				-- function 37
				local easeInCubic = math.easeInCubic(arg_37_3)
				local level_up = arg_37_2.level_up

				level_up.style.bottom_left_lock.offset[2] = math.lerp(-180, 14, easeInCubic)
				level_up.style.bottom_right_lock.offset[2] = math.lerp(-180, 14, easeInCubic)
			end,
			on_complete = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				-- function 38
				return
			end
		},
		{
			name = "level_up",
			start_progress = 3.6,
			end_progress = 4.1,
			init = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				-- function 39
				return
			end,
			update = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
				-- function 40
				local easeOutCubic = math.easeOutCubic(arg_40_3)
				local level_up = arg_40_2.level_up

				level_up.content.level_text = arg_40_4.data.level
				level_up.style.lava.color[1] = easeOutCubic * 255
				level_up.style.lava_mask.color[1] = 255
			end,
			on_complete = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				-- function 41
				local level_up = arg_41_2.level_up

				level_up.content.level_text = arg_41_3.data.level

				local content = level_up.content
				local on_complete_optional_starting_progress = arg_41_3.data.on_complete_optional_starting_progress

				on_complete_optional_starting_progress = on_complete_optional_starting_progress or 0
				content.starting_progress = on_complete_optional_starting_progress

				local content_2 = level_up.content
				local on_complete_optional_final_progress = arg_41_3.data.on_complete_optional_final_progress

				on_complete_optional_final_progress = on_complete_optional_final_progress or 0
				content_2.final_progress = on_complete_optional_final_progress

				local insignia = arg_41_2.insignia
				local get_insignia_texture_settings_from_level, var_41_7 = UIAtlasHelper.get_insignia_texture_settings_from_level(arg_41_3.data.level)

				insignia.content.insignia_main.uvs = get_insignia_texture_settings_from_level
				insignia.content.insignia_addon.uvs = var_41_7
				insignia.content.level = arg_41_3.data.level
			end
		},
		{
			name = "fade_out",
			start_progress = 4.6,
			end_progress = 5.1,
			init = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				-- function 42
				return
			end,
			update = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
				-- function 43
				local easeOutCubic = math.easeOutCubic(arg_43_3)
				local level_up = arg_43_2.level_up

				level_up.content.level_text = arg_43_4.data.level
				level_up.style.lava.color[1] = 255 - easeOutCubic * 255
			end,
			on_complete = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				-- function 44
				local level_up = arg_44_2.level_up

				level_up.content.level_text = arg_44_3.data.level
				level_up.style.lava.color[1] = 0
				level_up.style.lava_mask.color[1] = 0

				local insignia = arg_44_2.insignia
				local get_insignia_texture_settings_from_level, var_44_3 = UIAtlasHelper.get_insignia_texture_settings_from_level(arg_44_3.data.level)

				insignia.content.insignia_main.uvs = get_insignia_texture_settings_from_level
				insignia.content.insignia_addon.uvs = var_44_3
				insignia.content.level = arg_44_3.data.level
			end
		},
		{
			name = "open",
			start_progress = 5.1,
			end_progress = 5.6,
			init = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				-- function 45
				return
			end,
			update = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
				-- function 46
				local easeOutCubic = math.easeOutCubic(arg_46_3)
				local level_up = arg_46_2.level_up

				level_up.style.bottom_left_lock.offset[2] = math.lerp(14, -180, easeOutCubic)
				level_up.style.bottom_right_lock.offset[2] = math.lerp(14, -180, easeOutCubic)

				local lerp = math.lerp(0, 90, easeOutCubic)

				level_up.style.left_lock.angle = math.degrees_to_radians(lerp)
				level_up.style.right_lock.angle = math.degrees_to_radians(-lerp)
			end,
			on_complete = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
				-- function 47
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
				-- function 48
				arg_48_3.play_sound("Play_vs_hud_progression_level_counter_loop")
				arg_48_3.set_global_wwise_parameter("summary_meter_progress", arg_48_3.data.sound_parameter_values[1])
			end,
			update = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
				-- function 49
				local easeCubic = math.easeCubic(arg_49_3)

				arg_49_2.level_up.content.final_progress = math.lerp(tbl_2[1], tbl_2[2], arg_49_4.data.starting_progress + (arg_49_4.data.final_progress - arg_49_4.data.starting_progress) * easeCubic)

				arg_49_4.set_global_wwise_parameter("summary_meter_progress", math.lerp(arg_49_4.data.sound_parameter_values[1], arg_49_4.data.sound_parameter_values[2], easeCubic))
			end,
			on_complete = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
				-- function 50
				arg_50_2.level_up.content.final_progress = math.lerp(tbl_2[1], tbl_2[2], arg_50_3.data.final_progress)

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
				-- function 51
				arg_51_2.level_up.content.starting_progress = 0

				arg_51_3.play_sound("Play_vs_hud_progression_level_counter_loop")
				arg_51_3.set_global_wwise_parameter("summary_meter_progress", arg_51_3.data.sound_parameter_values[1])
			end,
			update = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
				-- function 52
				local easeOutCubic = math.easeOutCubic(arg_52_3)

				arg_52_2.level_up.content.final_progress = math.lerp(tbl_2[1], tbl_2[2], arg_52_4.data.starting_progress + (arg_52_4.data.final_progress - arg_52_4.data.starting_progress) * easeOutCubic)

				arg_52_4.set_global_wwise_parameter("summary_meter_progress", math.lerp(arg_52_4.data.sound_parameter_values[1], arg_52_4.data.sound_parameter_values[2], easeOutCubic))
			end,
			on_complete = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
				-- function 53
				arg_53_2.level_up.content.final_progress = math.lerp(tbl_2[1], tbl_2[2], arg_53_3.data.final_progress)

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
				-- function 54
				local level_up = arg_54_2.level_up

				level_up.content.starting_progress = 1
				level_up.content.final_progress = 1
			end,
			update = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
				-- function 55
				return
			end,
			on_complete = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
				-- function 56
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
				-- function 57
				local level_up = arg_57_2.level_up

				level_up.content.starting_progress = 0
				level_up.style.lock_mask.color[1] = 0

				arg_57_3.play_sound("Play_vs_hud_progression_level_counter_loop")
				arg_57_3.set_global_wwise_parameter("summary_meter_progress", arg_57_3.data.sound_parameter_values[1])
			end,
			update = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4)
				-- function 58
				local var_58_0 = arg_58_3

				arg_58_2.level_up.content.final_progress = math.lerp(tbl_2[1], tbl_2[2], var_58_0)

				arg_58_4.set_global_wwise_parameter("summary_meter_progress", math.lerp(arg_58_4.data.sound_parameter_values[1], arg_58_4.data.sound_parameter_values[2], var_58_0))
			end,
			on_complete = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3)
				-- function 59
				arg_59_2.level_up.content.final_progress = math.lerp(tbl_2[1], tbl_2[2], arg_59_3.data.final_progress)

				arg_59_3.play_sound("Stop_vs_hud_progression_level_counter_loop")

				local level = arg_59_3.data.level

				if level % 50 == 1 then
					arg_59_3.play_sound("Play_vs_hud_progression_level_up_50")
				elseif level % 10 == 1 then
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
				-- function 60
				local level_up = arg_60_2.level_up

				level_up.style.left_lock.angle = math.degrees_to_radians(90)
				level_up.style.right_lock.angle = math.degrees_to_radians(-90)
				level_up.style.bottom_left_lock.offset[2] = -180
				level_up.style.bottom_right_lock.offset[2] = -180
			end,
			update = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
				-- function 61
				local easeInCubic = math.easeInCubic(arg_61_3)
				local level_up = arg_61_2.level_up

				level_up.style.lock_mask.color[1] = 255

				local lerp = math.lerp(90, 0, easeInCubic)

				level_up.style.left_lock.angle = math.degrees_to_radians(lerp)
				level_up.style.right_lock.angle = math.degrees_to_radians(-lerp)
			end,
			on_complete = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
				-- function 62
				return
			end
		},
		{
			name = "close_bottom",
			start_progress = 1.7,
			end_progress = 2.1,
			init = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
				-- function 63
				return
			end,
			update = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4)
				-- function 64
				local easeInCubic = math.easeInCubic(arg_64_3)
				local level_up = arg_64_2.level_up

				level_up.style.bottom_left_lock.offset[2] = math.lerp(-180, 14, easeInCubic)
				level_up.style.bottom_right_lock.offset[2] = math.lerp(-180, 14, easeInCubic)
			end,
			on_complete = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
				-- function 65
				return
			end
		},
		{
			name = "level_up",
			start_progress = 2.1,
			end_progress = 2.5,
			init = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
				-- function 66
				return
			end,
			update = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4)
				-- function 67
				local easeInCubic = math.easeInCubic(arg_67_3)
				local level_up = arg_67_2.level_up

				level_up.content.level_text = arg_67_4.data.level
				level_up.style.lava.color[1] = easeInCubic * 255
				level_up.style.lava_mask.color[1] = 255
			end,
			on_complete = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3)
				-- function 68
				local level_up = arg_68_2.level_up

				level_up.content.level_text = arg_68_3.data.level
				level_up.content.starting_progress = 0
				level_up.content.final_progress = 0

				local insignia = arg_68_2.insignia
				local get_insignia_texture_settings_from_level, var_68_3 = UIAtlasHelper.get_insignia_texture_settings_from_level(arg_68_3.data.level)

				insignia.content.insignia_main.uvs = get_insignia_texture_settings_from_level
				insignia.content.insignia_addon.uvs = var_68_3
				insignia.content.level = arg_68_3.data.level
			end
		},
		{
			name = "fade_out",
			start_progress = 3,
			end_progress = 3.5,
			init = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3)
				-- function 69
				return
			end,
			update = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4)
				-- function 70
				local easeOutCubic = math.easeOutCubic(arg_70_3)
				local level_up = arg_70_2.level_up

				level_up.content.level_text = arg_70_4.data.level
				level_up.style.lava.color[1] = 255 - easeOutCubic * 255
			end,
			on_complete = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
				-- function 71
				local level_up = arg_71_2.level_up

				level_up.content.level_text = arg_71_3.data.level
				level_up.style.lava.color[1] = 0
				level_up.style.lava_mask.color[1] = 0

				local insignia = arg_71_2.insignia
				local get_insignia_texture_settings_from_level, var_71_3 = UIAtlasHelper.get_insignia_texture_settings_from_level(arg_71_3.data.level)

				insignia.content.insignia_main.uvs = get_insignia_texture_settings_from_level
				insignia.content.insignia_addon.uvs = var_71_3
				insignia.content.level = arg_71_3.data.level
			end
		},
		{
			name = "open",
			start_progress = 3.5,
			end_progress = 4,
			init = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3)
				-- function 72
				return
			end,
			update = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4)
				-- function 73
				local easeOutCubic = math.easeOutCubic(arg_73_3)
				local level_up = arg_73_2.level_up

				level_up.style.bottom_left_lock.offset[2] = math.lerp(14, -180, easeOutCubic)
				level_up.style.bottom_right_lock.offset[2] = math.lerp(14, -180, easeOutCubic)

				local lerp = math.lerp(0, 90, easeOutCubic)

				level_up.style.left_lock.angle = math.degrees_to_radians(lerp)
				level_up.style.right_lock.angle = math.degrees_to_radians(-lerp)
			end,
			on_complete = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3)
				-- function 74
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
				-- function 75
				arg_75_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3, arg_76_4)
				-- function 76
				local easeOutCubic = math.easeOutCubic(arg_76_3)

				arg_76_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3)
				-- function 77
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
				-- function 78
				return
			end,
			update = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4)
				-- function 79
				local sparkle_effect = arg_79_2.sparkle_effect
				local style = sparkle_effect.style
				local content = sparkle_effect.content
				local offset = sparkle_effect.offset
				local num = 180 * math.easeOutCubic(arg_79_3)
				local texture_id = style.texture_id

				texture_id.angle = math.degrees_to_radians(num)
				texture_id.color[1] = 255 * math.ease_pulse(arg_79_3)
			end,
			on_complete = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3)
				-- function 80
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
				-- function 81
				local data = arg_81_3.data
				local widget = data.widget

				widget.style.texture_id.color[1] = 0
				widget.style.frame.color[1] = 0
				widget.style.rarity_texture.color[1] = 0

				local size = arg_81_1.hero_progress_item_anchor.size

				widget.content.size[1] = size[1] * 2
				widget.content.size[2] = size[2] * 2

				local offset = data.offset

				widget.offset[1] = offset[1] - size[1] * 0.5
				widget.offset[2] = offset[2] - size[2] * 0.5

				arg_81_3.play_sound(arg_81_3.data.sound)
			end,
			update = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3, arg_82_4)
				-- function 82
				local widget = arg_82_4.data.widget
				local style = widget.style
				local content = widget.content
				local offset = widget.offset
				local easeOutCubic = math.easeOutCubic(arg_82_3)
				local size = arg_82_1.hero_progress_item_anchor.size

				content.size[1] = math.lerp(size[1] * 2, size[1], easeOutCubic)
				content.size[2] = math.lerp(size[2] * 2, size[2], easeOutCubic)
				style.texture_id.texture_size = content.size
				style.frame.texture_size = content.size
				style.rarity_texture.texture_size = content.size

				local offset_2 = arg_82_4.data.offset

				widget.offset[1] = offset_2[1] - math.lerp(size[1] * 0.5, 0, easeOutCubic)
				widget.offset[2] = offset_2[2] - math.lerp(size[2] * 0.5, 0, easeOutCubic)
				style.texture_id.color[1] = math.lerp(0, 255, easeOutCubic)
				style.frame.color[1] = math.lerp(0, 255, easeOutCubic)
				style.rarity_texture.color[1] = math.lerp(0, 255, easeOutCubic)
			end,
			on_complete = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3)
				-- function 83
				local data = arg_83_3.data
				local widget = data.widget
				local style = widget.style
				local content = widget.content

				style.texture_id.color[1] = 255
				style.frame.color[1] = 255
				style.rarity_texture.color[1] = 255

				local size = arg_83_1.hero_progress_item_anchor.size

				content.size[1] = size[1]
				content.size[2] = size[2]
				style.texture_id.texture_size = content.size
				style.frame.texture_size = content.size
				style.rarity_texture.texture_size = content.size

				local offset = data.offset

				widget.offset[1] = offset[1]
				widget.offset[2] = offset[2]
			end
		}
	},
	versus_level_up_pause = {
		{
			name = "pause",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3)
				-- function 84
				return
			end,
			update = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4)
				-- function 85
				return
			end,
			on_complete = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3)
				-- function 86
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
				-- function 87
				arg_87_3.render_settings.hero_progress_alpha_multiplier = 0
			end,
			update = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3, arg_88_4)
				-- function 88
				local easeOutCubic = math.easeOutCubic(arg_88_3)

				arg_88_4.render_settings.hero_progress_alpha_multiplier = easeOutCubic
				arg_88_0.hero_progress_anchor.position[1] = math.lerp(arg_88_1.hero_progress_anchor.position[1] + 100, arg_88_1.hero_progress_anchor.position[1], easeOutCubic)
			end,
			on_complete = function (arg_89_0, arg_89_1, arg_89_2, arg_89_3)
				-- function 89
				return
			end
		},
		{
			name = "animate_experience_gained",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3)
				-- function 90
				return
			end,
			update = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3, arg_91_4)
				-- function 91
				local easeOutCubic = math.easeOutCubic(arg_91_3)

				arg_91_0.experience_gained.position[1] = math.lerp(arg_91_1.experience_gained.position[1] - 50, arg_91_1.experience_gained.position[1], easeOutCubic)
				arg_91_2.experience_gained_text.style.text.text_color[1] = 255 * easeOutCubic
			end,
			on_complete = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3)
				-- function 92
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
				-- function 93
				arg_93_3.render_settings.hero_progress_alpha_multiplier = 0
				arg_93_2.experience_gained_text.style.text.text_color[1] = 255
			end,
			update = function (arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
				-- function 94
				local easeOutCubic = math.easeOutCubic(arg_94_3)

				arg_94_4.render_settings.hero_progress_alpha_multiplier = easeOutCubic
				arg_94_0.hero_progress_anchor.position[1] = math.lerp(arg_94_1.hero_progress_anchor.position[1] + 100, arg_94_1.hero_progress_anchor.position[1], easeOutCubic)
			end,
			on_complete = function (arg_95_0, arg_95_1, arg_95_2, arg_95_3)
				-- function 95
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
				-- function 96
				arg_96_3.render_settings.challenge_alpha_multiplier = 0
			end,
			update = function (arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4)
				-- function 97
				local easeOutCubic = math.easeOutCubic(arg_97_3)

				arg_97_4.render_settings.challenge_alpha_multiplier = easeOutCubic
				arg_97_0.challenge_progress_anchor.position[1] = math.lerp(arg_97_1.challenge_progress_anchor.position[1] + 100, arg_97_1.challenge_progress_anchor.position[1], easeOutCubic)
			end,
			on_complete = function (arg_98_0, arg_98_1, arg_98_2, arg_98_3)
				-- function 98
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
				-- function 99
				local var_99_0 = arg_99_2[arg_99_3.data.entry_name]

				var_99_0.base_offset = var_99_0.offset[1]
			end,
			update = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3, arg_100_4)
				-- function 100
				local easeOutCubic = math.easeOutCubic(arg_100_3)
				local var_100_1 = arg_100_2[arg_100_4.data.entry_name]

				var_100_1.offset[1] = math.lerp(var_100_1.base_offset + 50, var_100_1.base_offset, easeOutCubic)
				var_100_1.content.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3)
				-- function 101
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
				-- function 102
				return
			end,
			update = function (arg_103_0, arg_103_1, arg_103_2, arg_103_3, arg_103_4)
				-- function 103
				return
			end,
			on_complete = function (arg_104_0, arg_104_1, arg_104_2, arg_104_3)
				-- function 104
				return
			end
		}
	}
}

return {
	scenegraph_definition = tbl_5,
	widget_definitions = tbl_18,
	challenge_widget_definitions = tbl_20,
	hero_progress_widget_definitions = tbl_19,
	animation_definitions = tbl_21,
	challenge_progress_text_string = str,
	hero_progress_text_string = var_0_23,
	summary_value_string = str_2,
	create_summery_entry_func = fn_2,
	bar_thresholds = tbl_2,
	create_item_widget_func = fn_4,
	create_challenge_entry_func = fn_3
}
