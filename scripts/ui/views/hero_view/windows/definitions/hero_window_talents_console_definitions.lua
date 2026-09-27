-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_talents_console_definitions.lua

local tbl = {
	1215,
	820
}
local tbl_2 = {
	450,
	170
}
local tbl_3 = {
	364,
	80
}
local num = 6
local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl_4 = {
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	area_left = console_menu_scenegraphs.area_left,
	area_right = console_menu_scenegraphs.area_right,
	area_divider = console_menu_scenegraphs.area_divider,
	info_window = {
		vertical_alignment = "top",
		parent = "area_right",
		horizontal_alignment = "right",
		size = {
			tbl_2[1] + 20,
			680
		},
		position = {
			0,
			-20,
			1
		}
	},
	scrollbar_anchor = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			tbl_2[1] + 20,
			680
		},
		position = {
			0,
			0,
			1
		}
	},
	scrollbar_window = {
		parent = "scrollbar_anchor"
	},
	passive_window = {
		vertical_alignment = "top",
		parent = "scrollbar_window",
		horizontal_alignment = "center",
		size = tbl_2,
		position = {
			0,
			-20,
			1
		}
	},
	passive_icon = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "left",
		size = {
			80,
			80
		},
		position = {
			10,
			-50,
			5
		}
	},
	passive_icon_frame = {
		vertical_alignment = "center",
		parent = "passive_icon",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	passive_title_text = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "left",
		size = {
			tbl_2[1] * 0.6,
			50
		},
		position = {
			10,
			-5,
			1
		}
	},
	passive_title_divider = {
		vertical_alignment = "bottom",
		parent = "passive_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	passive_type_title = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "right",
		size = {
			tbl_2[1] * 0.3,
			50
		},
		position = {
			-10,
			-5,
			1
		}
	},
	passive_description_text = {
		vertical_alignment = "top",
		parent = "passive_icon",
		horizontal_alignment = "left",
		size = {
			tbl_2[1] - 110,
			tbl_2[2] - 40
		},
		position = {
			90,
			0,
			1
		}
	},
	active_window = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "left",
		size = tbl_2,
		position = {
			0,
			-tbl_2[2],
			1
		}
	},
	active_icon = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "left",
		size = {
			80,
			80
		},
		position = {
			10,
			-50,
			5
		}
	},
	active_icon_frame = {
		vertical_alignment = "center",
		parent = "active_icon",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	active_title_text = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "left",
		size = {
			tbl_2[1] * 0.6,
			50
		},
		position = {
			10,
			-5,
			1
		}
	},
	active_title_divider = {
		vertical_alignment = "bottom",
		parent = "active_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	active_type_title = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "right",
		size = {
			tbl_2[1] * 0.3,
			50
		},
		position = {
			-10,
			-5,
			1
		}
	},
	active_description_text = {
		vertical_alignment = "top",
		parent = "active_icon",
		horizontal_alignment = "left",
		size = {
			tbl_2[1] - 110,
			tbl_2[2] - 40
		},
		position = {
			90,
			0,
			1
		}
	},
	perk_title_text = {
		vertical_alignment = "bottom",
		parent = "active_window",
		horizontal_alignment = "left",
		size = {
			tbl_2[1] * 0.6,
			50
		},
		position = {
			10,
			-50,
			1
		}
	},
	perk_title_divider = {
		vertical_alignment = "bottom",
		parent = "perk_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	career_perk_anchor = {
		vertical_alignment = "bottom",
		parent = "perk_title_divider",
		horizontal_alignment = "left",
		size = {
			0,
			0,
			1
		},
		position = {
			10,
			-30,
			1
		}
	},
	talent_row_1 = {
		vertical_alignment = "bottom",
		parent = "talent_row_2",
		horizontal_alignment = "left",
		size = {
			tbl[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_2 = {
		vertical_alignment = "bottom",
		parent = "talent_row_3",
		horizontal_alignment = "left",
		size = {
			tbl[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_3 = {
		vertical_alignment = "bottom",
		parent = "talent_row_4",
		horizontal_alignment = "left",
		size = {
			tbl[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_4 = {
		vertical_alignment = "bottom",
		parent = "talent_row_5",
		horizontal_alignment = "left",
		size = {
			tbl[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_5 = {
		vertical_alignment = "bottom",
		parent = "talent_row_6",
		horizontal_alignment = "left",
		size = {
			tbl[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_6 = {
		vertical_alignment = "bottom",
		parent = "area_left",
		horizontal_alignment = "left",
		size = {
			tbl[1] - 20,
			80
		},
		position = {
			0,
			10,
			5
		}
	},
	tooltip_area = {
		vertical_alignment = "top",
		parent = "area_left",
		horizontal_alignment = "left",
		size = {
			tbl[1] - 20,
			240
		},
		position = {
			0,
			-20,
			1
		}
	},
	tooltip_title = {
		vertical_alignment = "top",
		parent = "tooltip_area",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 40,
			40
		},
		position = {
			0,
			-10,
			1
		}
	},
	tooltip_description = {
		vertical_alignment = "top",
		parent = "tooltip_area",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 40,
			40
		},
		position = {
			0,
			-60,
			1
		}
	},
	tooltip_info = {
		vertical_alignment = "bottom",
		parent = "tooltip_area",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 40,
			40
		},
		position = {
			0,
			0,
			1
		}
	}
}

for i = 1, num do
	local num_2 = i - 1

	if i == 1 then
		num_2 = "anchor"
	end

	tbl_4["career_perk_" .. i] = {
		vertical_alignment = "bottom",
		horizontal_alignment = "left",
		parent = "career_perk_" .. num_2,
		size = {
			410,
			1
		},
		position = {
			0,
			0,
			1
		}
	}
end

local tbl_5 = {
	font_size = 42,
	upper_case = true,
	localize = false,
	use_shadow = true,
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
local tbl_6 = {
	font_size = 18,
	use_shadow = true,
	localize = false,
	dynamic_font_size_word_wrap = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_7 = {
	word_wrap = true,
	font_size = 24,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_8 = {
	word_wrap = true,
	font_size = 24,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_9 = {
	word_wrap = true,
	use_shadow = true,
	localize = false,
	font_size = 18,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("gray", 200),
	offset = {
		0,
		0,
		2
	}
}
local tbl_10 = {
	font_size = 32,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_11 = {
	font_size = 32,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header_masked",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local menu_frame_09 = UIFrameSettings.menu_frame_09
	local str = "frame_outer_glow_01"
	local var_1_2 = UIFrameSettings[str]
	local var_1_3 = var_1_2.texture_sizes.corner[1]
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame_lock",
			texture_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock"
		},
		{
			pass_type = "rect",
			style_id = "lock_rect"
		},
		{
			style_id = "level_text",
			pass_type = "text",
			text_id = "level_text"
		},
		{
			style_id = "level_text_shadow",
			pass_type = "text",
			text_id = "level_text"
		},
		{
			texture_id = "glow_frame",
			style_id = "glow_frame",
			pass_type = "texture_frame"
		}
	}
	local tbl_3 = {
		level_text = "0",
		lock = "talent_lock_fg",
		amount = arg_1_3,
		frame = menu_frame_09.texture,
		glow_frame = var_1_2.texture
	}
	local min = math.min(97, arg_1_1[2] - 8)
	local tbl_4 = {
		frame = {
			texture_size = menu_frame_09.texture_size,
			texture_sizes = menu_frame_09.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				arg_1_1[1],
				arg_1_1[2]
			},
			offset = {
				0,
				0,
				5
			}
		},
		frame_lock = {
			texture_size = menu_frame_09.texture_size,
			texture_sizes = menu_frame_09.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				103,
				arg_1_1[2]
			},
			offset = {
				0,
				0,
				3
			}
		},
		glow_frame = {
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				-2
			},
			size = arg_1_1,
			texture_size = var_1_2.texture_size,
			texture_sizes = var_1_2.texture_sizes,
			frame_margins = {
				-(var_1_3 - 1),
				-(var_1_3 - 1)
			}
		},
		lock_rect = {
			color = {
				150,
				0,
				0,
				0
			},
			size = {
				100,
				arg_1_1[2]
			},
			offset = {
				0,
				0,
				0
			}
		},
		lock = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			texture_size = {
				min,
				min
			},
			size = {
				100,
				arg_1_1[2]
			},
			offset = {
				3,
				2,
				1
			}
		},
		level_text = {
			word_wrap = true,
			font_size = 26,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				97,
				97
			},
			offset = {
				3,
				-12,
				3
			}
		},
		level_text_shadow = {
			word_wrap = true,
			font_size = 26,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				97,
				97
			},
			offset = {
				5,
				-14,
				2
			}
		}
	}
	local num = 0
	local num_2 = 0
	local tbl_5 = {
		80,
		80
	}
	local num_3 = arg_1_1[1] - (arg_1_2[1] * arg_1_3 + num * (arg_1_3 - 1))

	for i = 1, arg_1_3 do
		local str_2 = "_" .. tostring(i)
		local num_4 = i - 1
		local tbl_6 = {
			num_3,
			0,
			num_2
		}
		local str_3 = "hotspot" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "hotspot",
			content_id = str_3,
			style_id = str_3
		}
		tbl_4[str_3] = {
			size = arg_1_2,
			offset = tbl_6
		}
		tbl_3[str_3] = {}

		local var_1_17 = tbl_3[str_3]
		local str_4 = "background" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "rect",
			style_id = str_4
		}

		local tbl_7 = {
			size = arg_1_2
		}
		local tbl_8 = {
			nil,
			0,
			0,
			0
		}
		local flag

		flag = not IS_WINDOWS and 165 and 100
		tbl_8[1] = flag
		tbl_7.color = tbl_8
		tbl_7.offset = {
			tbl_6[1],
			tbl_6[2],
			0
		}
		tbl_4[str_4] = tbl_7

		local str_5 = "frame" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture_frame",
			texture_id = str_5,
			style_id = str_5
		}
		tbl_4[str_5] = {
			texture_size = menu_frame_09.texture_size,
			texture_sizes = menu_frame_09.texture_sizes,
			size = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1],
				tbl_6[2],
				7
			}
		}
		tbl_3[str_5] = menu_frame_09.texture

		local str_6 = "selected" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			texture_id = str_6,
			style_id = str_6,
			content_check_function = function (self)
				-- function 2
				return self[str_3].is_selected
			end
		}
		tbl_4[str_6] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = arg_1_2,
			size = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1],
				tbl_6[2],
				28
			}
		}
		tbl_3[str_6] = "talent_selected"

		local str_7 = "title_text" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			text_id = str_7,
			style_id = str_7,
			content_check_function = function (self)
				-- function 3
				local var_3_0 = self[str_3]

				return not not var_3_0.is_selected or not var_3_0.disabled
			end
		}
		tbl_4[str_7] = {
			word_wrap = true,
			font_size = 24,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				arg_1_2[1] - 100,
				arg_1_2[2]
			},
			offset = {
				tbl_6[1] + 90,
				tbl_6[2],
				3
			}
		}
		tbl_3[str_7] = "n/a"

		local str_8 = "title_text_selected" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			text_id = str_7,
			style_id = str_8,
			content_check_function = function (self)
				-- function 4
				local var_4_0 = self[str_3]
				local is_selected = var_4_0.is_selected

				is_selected = not is_selected and not var_4_0.disabled

				return is_selected
			end
		}
		tbl_4[str_8] = {
			word_wrap = true,
			font_size = 24,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			size = {
				arg_1_2[1] - 100,
				arg_1_2[2]
			},
			offset = {
				tbl_6[1] + 90,
				tbl_6[2],
				3
			}
		}

		local str_9 = "title_text_disabled" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			text_id = str_7,
			style_id = str_9,
			content_check_function = function (self)
				-- function 5
				return self[str_3].disabled
			end
		}
		tbl_4[str_9] = {
			word_wrap = true,
			font_size = 24,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = {
				255,
				50,
				50,
				50
			},
			size = {
				arg_1_2[1] - 100,
				arg_1_2[2]
			},
			offset = {
				tbl_6[1] + 90,
				tbl_6[2],
				3
			}
		}

		local str_10 = "title_text_shadow" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			text_id = str_7,
			style_id = str_10
		}
		tbl_4[str_10] = {
			word_wrap = true,
			font_size = 24,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				arg_1_2[1] - 100,
				arg_1_2[2]
			},
			offset = {
				tbl_6[1] + 90 + 2,
				tbl_6[2] - 2,
				2
			}
		}

		local str_11 = "background_glow" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			texture_id = str_11,
			style_id = str_11,
			content_check_function = function (self)
				-- function 6
				local var_6_0 = self[str_3]
				local is_hover = var_6_0.is_hover

				is_hover = is_hover or var_6_0.focused

				return is_hover
			end
		}
		tbl_4[str_11] = {
			size = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1],
				tbl_6[2],
				3
			}
		}
		tbl_3[str_11] = "talent_bg_glow_01"

		local str_12 = "glass_top" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			texture_id = str_12,
			style_id = str_12
		}
		tbl_4[str_12] = {
			size = {
				arg_1_2[1],
				3
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1],
				tbl_6[2] + arg_1_2[2] - 8,
				5
			}
		}
		tbl_3[str_12] = "button_glass_01"

		local str_13 = "icon" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			texture_id = str_13,
			style_id = str_13
		}
		tbl_4[str_13] = {
			saturated = true,
			size = tbl_5,
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				tbl_6[1],
				tbl_6[2] + arg_1_2[2] / 2 - tbl_5[2] / 2,
				3
			}
		}
		tbl_3[str_13] = "icons_placeholder"

		local str_14 = "icon_rect" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "rect",
			style_id = str_14,
			content_check_function = function (self)
				-- function 7
				local var_7_0 = self[str_3]

				return not not var_7_0.disabled or not var_7_0.is_selected
			end
		}
		tbl_4[str_14] = {
			size = tbl_5,
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				tbl_6[1],
				tbl_6[2] + arg_1_2[2] / 2 - tbl_5[2] / 2,
				4
			}
		}

		local str_15 = "icon_disabled_rect" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "rect",
			style_id = str_15,
			content_check_function = function (self)
				-- function 8
				return self[str_3].disabled
			end
		}
		tbl_4[str_15] = {
			size = tbl_5,
			color = {
				200,
				0,
				0,
				0
			},
			offset = {
				tbl_6[1],
				tbl_6[2] + arg_1_2[2] / 2 - tbl_5[2] / 2,
				4
			}
		}

		local str_16 = "icon_divider" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			texture_id = str_16,
			style_id = str_16
		}
		tbl_4[str_16] = {
			size = {
				5,
				tbl_5[2] - 2
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				tbl_6[1] + tbl_5[1] - 5,
				tbl_6[2] + arg_1_2[2] / 2 - tbl_5[2] / 2 + 1,
				6
			}
		}
		tbl_3[str_16] = "menu_frame_09_divider_vertical"

		local str_17 = "tooltip" .. str_2

		tbl_2[#tbl_2 + 1] = {
			talent_id = "talent",
			pass_type = "talent_tooltip",
			content_id = str_3,
			style_id = str_17,
			content_check_function = function (self)
				-- function 9
				local talent = self.talent

				talent = not talent and self.is_hover

				return talent
			end
		}
		tbl_4[str_17] = {
			size = arg_1_2,
			offset = {
				tbl_6[1],
				tbl_6[2],
				tbl_6[3] + 10
			}
		}
		tbl_3[str_17] = nil
		num_3 = num_3 + arg_1_2[1] + num
	end

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_1_0

	return tbl
end

local function fn_2(arg_10_0)
	-- function 10
	return {
		element = {
			passes = {
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					style_id = "description_text_shadow",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				}
			}
		},
		content = {
			icon = "tooltip_marker",
			title_text = "n/a",
			description_text = "n/a"
		},
		style = {
			icon = {
				vertical_alignment = "bottom",
				masked = true,
				horizontal_alignment = "left",
				texture_size = {
					13,
					13
				},
				offset = {
					0,
					6,
					2
				}
			},
			title_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					20,
					-5,
					2
				}
			},
			title_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					22,
					-7,
					0
				}
			},
			description_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					20,
					0,
					2
				}
			},
			description_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					22,
					-2,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_10_0
	}
end

local tbl_12 = {
	font_size = 32,
	use_shadow = true,
	localize = false,
	dynamic_font_size_word_wrap = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_13 = {
	tooltip_area = UIWidgets.create_rect_with_outer_frame("tooltip_area", tbl_4.tooltip_area.size, "frame_outer_fade_02", 0, UISettings.console_menu_rect_color),
	tooltip_title = UIWidgets.create_simple_text("n/a", "tooltip_title", nil, nil, tbl_10),
	tooltip_description = UIWidgets.create_simple_text("n/a", "tooltip_description", nil, nil, tbl_7),
	tooltip_info = UIWidgets.create_simple_text("n/a", "tooltip_info", nil, nil, tbl_8),
	talent_row_1 = fn("talent_row_1", tbl_4.talent_row_1.size, tbl_3, 3),
	talent_row_2 = fn("talent_row_2", tbl_4.talent_row_2.size, tbl_3, 3),
	talent_row_3 = fn("talent_row_3", tbl_4.talent_row_3.size, tbl_3, 3),
	talent_row_4 = fn("talent_row_4", tbl_4.talent_row_4.size, tbl_3, 3),
	talent_row_5 = fn("talent_row_5", tbl_4.talent_row_5.size, tbl_3, 3),
	talent_row_6 = fn("talent_row_6", tbl_4.talent_row_6.size, tbl_3, 3),
	info_window_background = UIWidgets.create_rect_with_outer_frame("info_window", tbl_4.info_window.size, "frame_outer_fade_02", 0, UISettings.console_menu_rect_color),
	mask = UIWidgets.create_simple_texture("mask_rect", "scrollbar_anchor"),
	perk_title_text = UIWidgets.create_simple_text(Localize("hero_view_perk_title"), "perk_title_text", nil, nil, tbl_11),
	perk_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "perk_title_divider", true),
	passive_title_text = UIWidgets.create_simple_text("n/a", "passive_title_text", nil, nil, tbl_11),
	passive_type_title = UIWidgets.create_simple_text(Localize("hero_view_passive_ability"), "passive_type_title", nil, nil, tbl_9),
	passive_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "passive_title_divider", true),
	passive_description_text = UIWidgets.create_simple_text("n/a", "passive_description_text", nil, nil, tbl_6),
	passive_icon = UIWidgets.create_simple_texture("icons_placeholder", "passive_icon", true),
	passive_icon_frame = UIWidgets.create_simple_texture("talent_frame", "passive_icon_frame", true),
	active_title_text = UIWidgets.create_simple_text("n/a", "active_title_text", nil, nil, tbl_11),
	active_type_title = UIWidgets.create_simple_text(Localize("hero_view_activated_ability"), "active_type_title", nil, nil, tbl_9),
	active_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "active_title_divider", true),
	active_description_text = UIWidgets.create_simple_text("n/a", "active_description_text", nil, nil, tbl_6),
	active_icon = UIWidgets.create_simple_texture("icons_placeholder", "active_icon", true),
	active_icon_frame = UIWidgets.create_simple_texture("talent_frame", "active_icon_frame", true)
}

for j = 1, num do
	tbl_13["career_perk_" .. j] = UIWidgets.create_career_perk_text("career_perk_" .. j)
end

local tbl_14 = {
	default = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "l2_r2",
			priority = 2,
			description_text = "input_description_select_loadout",
			ignore_keybinding = true
		},
		{
			input_action = "right_stick_press",
			priority = 3,
			description_text = "input_description_manage_loadouts",
			ignore_keybinding = false
		},
		{
			input_action = "show_gamercard",
			priority = 4,
			description_text = "start_menu_switch_hero"
		},
		{
			input_action = "confirm",
			priority = 5,
			description_text = "input_description_select"
		},
		{
			input_action = "refresh",
			priority = 6,
			description_text = "input_description_remove"
		},
		{
			input_action = "back",
			priority = 7,
			description_text = "input_description_close"
		}
	}
}
local tbl_15 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				arg_11_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				-- function 12
				local easeOutCubic = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.alpha_multiplier = easeOutCubic
				arg_12_0.area_left.local_position[1] = arg_12_1.area_left.position[1] + -100 * (1 - easeOutCubic)
				arg_12_0.area_right.local_position[1] = arg_12_1.area_right.position[1] + -100 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				arg_14_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				-- function 15
				local easeOutCubic = math.easeOutCubic(arg_15_3)

				arg_15_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				return
			end
		}
	}
}

return {
	widgets = tbl_13,
	scenegraph_definition = tbl_4,
	animation_definitions = tbl_15,
	generic_input_actions = tbl_14,
	NUM_PERKS = num
}
