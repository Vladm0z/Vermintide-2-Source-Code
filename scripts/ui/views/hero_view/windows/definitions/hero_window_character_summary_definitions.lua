-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_character_summary_definitions.lua

local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local num = 2
local tbl = {
	400,
	20
}
local tbl_2 = {
	450,
	170
}
local tbl_3 = {
	screen = console_menu_scenegraphs.screen,
	item_list_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			tbl[1] + 60,
			740
		},
		position = {
			0,
			-100,
			1
		}
	},
	item_list_mask = {
		vertical_alignment = "bottom",
		parent = "item_list_window",
		horizontal_alignment = "center",
		size = {
			tbl[1] + 60,
			690
		},
		position = {
			0,
			0,
			1
		}
	},
	item_list = {
		vertical_alignment = "top",
		parent = "item_list_mask",
		horizontal_alignment = "center",
		size = {
			tbl[1] + 60,
			672
		},
		position = {
			0,
			-14,
			1
		}
	},
	list_scrollbar = {
		vertical_alignment = "top",
		parent = "item_list_mask",
		horizontal_alignment = "right",
		size = {
			16,
			690
		},
		position = {
			-12,
			0,
			1
		}
	},
	list_scroll_root = {
		vertical_alignment = "top",
		parent = "item_list_mask",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	list_item = {
		vertical_alignment = "top",
		parent = "list_scroll_root",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			12,
			-10,
			1
		}
	},
	window_title = {
		vertical_alignment = "top",
		parent = "item_list_window",
		horizontal_alignment = "left",
		size = {
			tbl[1] + 40,
			40
		},
		position = {
			0,
			-10,
			1
		}
	},
	passive_window = {
		vertical_alignment = "top",
		parent = "item_list_window",
		horizontal_alignment = "left",
		size = tbl_2,
		position = {
			0,
			-60,
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
			tbl_2[2] - 90
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
			tbl_2[2] - 90
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
	career_perk_1 = {
		vertical_alignment = "bottom",
		parent = "perk_title_divider",
		horizontal_alignment = "left",
		size = {
			420,
			1
		},
		position = {
			10,
			-30,
			1
		}
	},
	career_perk_2 = {
		vertical_alignment = "center",
		parent = "career_perk_1",
		horizontal_alignment = "left",
		size = {
			420,
			1
		},
		position = {
			0,
			0,
			1
		}
	},
	career_perk_3 = {
		vertical_alignment = "center",
		parent = "career_perk_2",
		horizontal_alignment = "left",
		size = {
			420,
			1
		},
		position = {
			0,
			0,
			1
		}
	},
	talent_root = {
		vertical_alignment = "bottom",
		parent = "item_list_window",
		horizontal_alignment = "left",
		size = {
			80,
			80
		},
		position = {
			0,
			-86,
			10
		}
	},
	hero_root = {
		vertical_alignment = "top",
		parent = "item_list_window",
		horizontal_alignment = "left",
		size = {
			110,
			130
		},
		position = {
			106,
			-56,
			1
		}
	},
	hero_icon_root = {
		vertical_alignment = "center",
		parent = "hero_root",
		horizontal_alignment = "left",
		size = {
			80,
			80
		},
		position = {
			-93,
			0,
			1
		}
	},
	hero_selection_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			465,
			110
		},
		position = {
			0,
			0,
			30
		}
	},
	hero_selection_warning = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			465,
			30
		},
		position = {
			0,
			-70,
			1
		}
	}
}

local function fn(arg_1_0)
	-- function 1
	local size = tbl_3[arg_1_0].size
	local str = "shadow_frame_02"
	local var_1_2 = UIFrameSettings[str]
	local var_1_3 = var_1_2.texture_sizes.horizontal[2]
	local str_2 = "frame_outer_glow_04"
	local var_1_5 = UIFrameSettings[str_2]
	local var_1_6 = var_1_5.texture_sizes.horizontal[2]
	local tbl = {
		{
			style_id = "button_hotspot",
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function (self)
				-- function 2
				return not self.parent.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (self)
				-- function 3
				return not self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "selected_frame",
			texture_id = "selected_frame",
			content_check_function = function (self)
				-- function 4
				return self.selected
			end
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function (self)
				-- function 5
				return self.locked
			end
		},
		{
			style_id = "level_text",
			pass_type = "text",
			text_id = "level_text",
			content_check_function = function (self)
				-- function 6
				return self.locked
			end
		},
		{
			style_id = "level_text_shadow",
			pass_type = "text",
			text_id = "level_text",
			content_check_function = function (self)
				-- function 7
				return self.locked
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "shadow_frame",
			texture_id = "shadow_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "hover_frame",
			texture_id = "hover_frame"
		},
		{
			style_id = "talent",
			talent_id = "talent",
			pass_type = "talent_tooltip",
			content_check_function = function (self)
				-- function 8
				local talent = self.talent

				talent = not talent and self.button_hotspot.is_hover

				return talent
			end
		}
	}
	local tbl_2 = {
		selected = false,
		locked = false,
		icon = "talent_lock_fg",
		frame = "talent_frame",
		lock = "talent_lock_fg",
		background = "simple_rect_texture",
		level_text = "-",
		selected_frame = "item_icon_selection",
		button_hotspot = {},
		shadow_frame = var_1_2.texture,
		hover_frame = var_1_5.texture,
		size = size
	}
	local tbl_4 = {
		talent = {
			offset = {
				-244,
				-80,
				10
			}
		},
		button_hotspot = {
			offset = {
				0,
				0,
				0
			}
		},
		lock = {
			saturated = true,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				1
			}
		},
		icon = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				1
			}
		},
		frame = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				2
			}
		},
		selected_frame = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				3
			}
		},
		background = {
			color = {
				255,
				10,
				10,
				10
			},
			offset = {
				0,
				0,
				0
			}
		},
		shadow_frame = {
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			},
			frame_margins = {
				-var_1_3,
				-var_1_3
			},
			texture_size = var_1_2.texture_size,
			texture_sizes = var_1_2.texture_sizes
		},
		hover_frame = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				16
			},
			frame_margins = {
				-var_1_6,
				-var_1_6
			},
			texture_size = var_1_5.texture_size,
			texture_sizes = var_1_5.texture_sizes
		},
		level_text = {
			vertical_alignment = "center",
			font_size = 28,
			localize = false,
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("red", 255),
			offset = {
				0,
				-5,
				4
			}
		},
		level_text_shadow = {
			vertical_alignment = "center",
			font_size = 28,
			localize = false,
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-7,
				3
			}
		}
	}

	return {
		element = {
			passes = tbl
		},
		content = tbl_2,
		style = tbl_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local function fn_2(arg_9_0, arg_9_1)
	-- function 9
	local size = tbl_3[arg_9_0].size
	local tbl = {
		{
			style_id = "button_hotspot",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			style_id = "name",
			pass_type = "text",
			text_id = "name"
		},
		{
			style_id = "name_shadow",
			pass_type = "text",
			text_id = "name"
		},
		{
			style_id = "title",
			pass_type = "text",
			text_id = "title"
		},
		{
			style_id = "title_shadow",
			pass_type = "text",
			text_id = "title"
		},
		{
			style_id = "value",
			pass_type = "text",
			text_id = "value"
		},
		{
			style_id = "value_shadow",
			pass_type = "text",
			text_id = "value"
		}
	}
	local tbl_2 = {
		name = "n/a",
		background = "headline_bg_40",
		value = "n/a",
		title = "n/a",
		button_hotspot = {},
		size = size
	}
	local tbl_4 = {
		button_hotspot = {
			offset = {
				0,
				0,
				0
			}
		},
		background = {
			masked = arg_9_1,
			color = {
				255,
				10,
				10,
				10
			},
			offset = {
				0,
				0,
				0
			}
		}
	}
	local tbl_5 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		localize = false,
		font_size = 20
	}
	local flag

	flag = not arg_9_1 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_5.offset = {
		0,
		0,
		2
	}
	tbl_4.name = tbl_5

	local tbl_6 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		localize = false,
		font_size = 20
	}
	local flag_2

	flag_2 = not arg_9_1 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_2
	tbl_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.offset = {
		1,
		-1,
		1
	}
	tbl_4.name_shadow = tbl_6

	local tbl_7 = {
		vertical_alignment = "center",
		upper_case = true,
		localize = false,
		horizontal_alignment = "left",
		font_size = 24
	}
	local flag_3

	flag_3 = not arg_9_1 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_7.font_type = flag_3
	tbl_7.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_7.offset = {
		0,
		0,
		2
	}
	tbl_4.title = tbl_7

	local tbl_8 = {
		vertical_alignment = "center",
		upper_case = true,
		localize = false,
		horizontal_alignment = "left",
		font_size = 24
	}
	local flag_4

	flag_4 = not arg_9_1 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_8.font_type = flag_4
	tbl_8.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_8.offset = {
		2,
		-2,
		1
	}
	tbl_4.title_shadow = tbl_8

	local tbl_9 = {
		vertical_alignment = "center",
		horizontal_alignment = "right",
		localize = false,
		font_size = 20
	}
	local flag_5

	flag_5 = not arg_9_1 and "hell_shark_masked" and "hell_shark"
	tbl_9.font_type = flag_5
	tbl_9.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_9.offset = {
		0,
		0,
		2
	}
	tbl_4.value = tbl_9

	local tbl_10 = {
		vertical_alignment = "center",
		horizontal_alignment = "right",
		localize = false,
		font_size = 20
	}
	local flag_6

	flag_6 = not arg_9_1 and "hell_shark_masked" and "hell_shark"
	tbl_10.font_type = flag_6
	tbl_10.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_10.offset = {
		1,
		-1,
		1
	}
	tbl_4.value_shadow = tbl_10

	return {
		element = {
			passes = tbl
		},
		content = tbl_2,
		style = tbl_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_9_0
	}
end

local function fn_3(arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local size = tbl_3[arg_10_0].size
	local num = 10
	local tbl = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			style_id = "title_text1",
			pass_type = "text",
			text_id = "title_text1"
		},
		{
			style_id = "title_text1_shadow",
			pass_type = "text",
			text_id = "title_text1"
		},
		{
			style_id = "title_text2",
			pass_type = "text",
			text_id = "title_text2"
		},
		{
			style_id = "title_text2_shadow",
			pass_type = "text",
			text_id = "title_text2"
		},
		{
			style_id = "divider",
			pass_type = "text",
			text_id = "divider"
		},
		{
			style_id = "divider_shadow",
			pass_type = "text",
			text_id = "divider"
		}
	}
	local tbl_2 = {
		background = "headline_bg_40",
		divider = "  /  ",
		hotspot = {},
		default_title_text1 = arg_10_1,
		title_text1 = arg_10_1,
		default_title_text2 = arg_10_2,
		title_text2 = arg_10_2,
		size = size,
		text_spacing = num
	}
	local tbl_4 = {
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			texture_size = size,
			color = {
				120,
				10,
				10,
				10
			},
			offset = {
				0,
				0,
				0
			}
		},
		title_text1 = {
			font_size = 34,
			upper_case = true,
			default_font_size = 28,
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			default_color = {
				255,
				120,
				120,
				120
			},
			selected_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				0,
				-7,
				2
			},
			default_offset = {
				0,
				-7,
				2
			}
		},
		title_text1_shadow = {
			vertical_alignment = "bottom",
			upper_case = true,
			horizontal_alignment = "right",
			font_size = 34,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-9,
				1
			},
			default_offset = {
				2,
				-9,
				1
			}
		},
		title_text2 = {
			font_size = 34,
			upper_case = true,
			default_font_size = 28,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			default_color = {
				255,
				120,
				120,
				120
			},
			selected_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				0,
				-7,
				2
			},
			default_offset = {
				0,
				-7,
				2
			}
		},
		title_text2_shadow = {
			vertical_alignment = "bottom",
			upper_case = true,
			horizontal_alignment = "left",
			font_size = 34,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-9,
				1
			},
			default_offset = {
				2,
				-9,
				1
			}
		},
		divider = {
			vertical_alignment = "bottom",
			upper_case = true,
			default_font_size = 28,
			horizontal_alignment = "left",
			font_size = 34,
			font_type = "hell_shark_header",
			text_color = {
				255,
				120,
				120,
				120
			},
			offset = {
				0,
				-7,
				2
			}
		},
		divider_shadow = {
			vertical_alignment = "bottom",
			upper_case = true,
			horizontal_alignment = "left",
			font_size = 34,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-9,
				1
			}
		}
	}

	return {
		element = {
			passes = tbl
		},
		content = tbl_2,
		style = tbl_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_10_0
	}
end

local function fn_4(arg_11_0, arg_11_1)
	-- function 11
	local size = tbl_3[arg_11_0].size
	local num = 10
	local tbl = {
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text"
		}
	}
	local tbl_2 = {
		background = "headline_bg_40",
		default_title_text = arg_11_1,
		title_text = arg_11_1,
		size = size,
		text_spacing = num
	}
	local tbl_4 = {
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			texture_size = size,
			color = {
				120,
				10,
				10,
				10
			},
			offset = {
				0,
				0,
				0
			}
		},
		title_text = {
			vertical_alignment = "center",
			upper_case = true,
			horizontal_alignment = "left",
			font_size = 34,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				num,
				-3,
				2
			},
			size = {
				size[1] - num,
				size[2]
			}
		},
		title_text_shadow = {
			vertical_alignment = "center",
			upper_case = true,
			horizontal_alignment = "left",
			font_size = 34,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				num + 2,
				-5,
				1
			},
			size = {
				size[1] - num,
				size[2]
			}
		}
	}

	return {
		element = {
			passes = tbl
		},
		content = tbl_2,
		style = tbl_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_11_0
	}
end

local function fn_5(arg_12_0)
	-- function 12
	local size = tbl_3[arg_12_0].size
	local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
	local var_12_2 = frame_outer_glow_01.texture_sizes.horizontal[2]
	local tbl = {
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			pass_type = "tiled_texture",
			style_id = "pattern",
			texture_id = "pattern"
		},
		{
			pass_type = "texture",
			style_id = "pattern_mask",
			texture_id = "pattern_mask"
		},
		{
			pass_type = "tiled_texture",
			style_id = "top_edge",
			texture_id = "edge"
		},
		{
			pass_type = "tiled_texture",
			style_id = "bottom_edge",
			texture_id = "edge"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			style_id = "top_corner",
			pass_type = "texture_uv",
			content_id = "top_corner"
		},
		{
			style_id = "bottom_corner",
			pass_type = "texture_uv",
			content_id = "bottom_corner"
		}
	}
	local tbl_2 = {
		pattern_mask = "background_pattern_fade_write_mask",
		background = "headline_bg_40",
		pattern = "background_pattern_01_transparent",
		edge = "edge_divider_01_horizontal",
		top_corner = {
			texture_id = "divider_corner_01",
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
		},
		bottom_corner = {
			texture_id = "divider_corner_01",
			uvs = {
				{
					1,
					1
				},
				{
					0,
					0
				}
			}
		},
		frame = frame_outer_glow_01.texture,
		size = size
	}
	local tbl_4 = {
		background = {
			color = {
				0,
				0,
				0,
				0
			},
			default_color = {
				0,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		},
		frame = {
			frame_margins = {
				-var_12_2,
				-var_12_2
			},
			color = {
				150,
				0,
				0,
				0
			},
			default_color = {
				150,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			},
			texture_size = frame_outer_glow_01.texture_size,
			texture_sizes = frame_outer_glow_01.texture_sizes
		},
		pattern = {
			texture_tiling_size = {
				256,
				256
			},
			color = {
				255,
				10,
				10,
				10
			},
			default_color = {
				255,
				10,
				10,
				10
			},
			offset = {
				0,
				0,
				1
			}
		},
		pattern_mask = {
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				1
			}
		},
		top_edge = {
			horizontal_alignment = "left",
			use_parent_width = true,
			vertical_alignment = "top",
			use_parent_height = false,
			texture_size = {
				64,
				4
			},
			texture_tiling_size = {
				64,
				4
			},
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				8
			}
		},
		bottom_edge = {
			horizontal_alignment = "left",
			use_parent_width = true,
			vertical_alignment = "bottom",
			use_parent_height = false,
			texture_size = {
				64,
				4
			},
			texture_tiling_size = {
				64,
				4
			},
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				8
			}
		},
		top_corner = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = {
				28,
				28
			},
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				9
			}
		},
		bottom_corner = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				28,
				28
			},
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				9
			}
		}
	}

	return {
		element = {
			passes = tbl
		},
		content = tbl_2,
		style = tbl_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_12_0
	}
end

local function fn_6(arg_13_0)
	-- function 13
	local tbl = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_texture"
			}
		}
	}
	local tbl_2 = {
		mask_texture = "mask_rect",
		hotspot = {}
	}
	local tbl_3 = {
		mask = {
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
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
	}

	return {
		element = tbl,
		content = tbl_2,
		style = tbl_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_13_0
	}
end

local function fn_7(arg_14_0)
	-- function 14
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
				horizontal_alignment = "left",
				texture_size = {
					13,
					13
				},
				offset = {
					-5,
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
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					15,
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
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					17,
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
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					15,
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
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					17,
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
		scenegraph_id = arg_14_0
	}
end

local function fn_8(arg_15_0)
	-- function 15
	local size = tbl_3[arg_15_0].size
	local str = "menu_frame_12"
	local var_15_2 = UIFrameSettings[str]
	local str_2 = "shadow_frame_02"
	local var_15_4 = UIFrameSettings[str_2]
	local var_15_5 = var_15_4.texture_sizes.horizontal[2]
	local str_3 = "frame_outer_glow_04"
	local var_15_7 = UIFrameSettings[str_3]
	local var_15_8 = var_15_7.texture_sizes.horizontal[2]

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "portrait",
					style_id = "portrait",
					pass_type = "texture"
				},
				{
					pass_type = "rect",
					style_id = "rect"
				},
				{
					texture_id = "lock_texture",
					style_id = "lock_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 16
						return self.locked
					end
				},
				{
					texture_id = "taken_texture",
					style_id = "taken_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 17
						local taken = self.taken

						taken = not taken and not self.locked

						return taken
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					style_id = "overlay_locked",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 18
						local button_hotspot = self.button_hotspot

						return self.locked
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "hover_frame",
					texture_id = "hover_frame"
				},
				{
					pass_type = "texture_frame",
					style_id = "shadow_frame",
					texture_id = "shadow_frame"
				}
			}
		},
		content = {
			portrait = "icons_placeholder",
			locked = false,
			lock_texture = "hero_icon_locked",
			taken = false,
			taken_texture = "hero_icon_unavailable",
			button_hotspot = {},
			frame = var_15_2.texture,
			hover_frame = var_15_7.texture,
			shadow_frame = var_15_4.texture,
			size = size
		},
		style = {
			rect = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = size,
				color = {
					200,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				}
			},
			portrait = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = size,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				}
			},
			lock_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					76,
					87
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
					5
				}
			},
			taken_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					112,
					112
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
					6
				}
			},
			overlay_locked = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = size,
				color = {
					200,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					2
				}
			},
			frame = {
				texture_size = var_15_2.texture_size,
				texture_sizes = var_15_2.texture_sizes,
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
			},
			shadow_frame = {
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				},
				frame_margins = {
					-var_15_5,
					-var_15_5
				},
				texture_size = var_15_4.texture_size,
				texture_sizes = var_15_4.texture_sizes
			},
			hover_frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					5
				},
				frame_margins = {
					-var_15_8,
					-var_15_8
				},
				texture_size = var_15_7.texture_size,
				texture_sizes = var_15_7.texture_sizes
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_15_0
	}
end

local function fn_9(arg_19_0)
	-- function 19
	local size = tbl_3[arg_19_0].size

	return {
		element = {
			passes = {
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture"
				},
				{
					texture_id = "icon_highlight",
					style_id = "icon_highlight",
					pass_type = "texture"
				}
			}
		},
		content = {
			icon_highlight = "hero_icon_large_bright_wizard",
			icon = "hero_icon_large_bright_wizard",
			size = size
		},
		style = {
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = size,
				color = {
					200,
					80,
					80,
					80
				},
				offset = {
					0,
					0,
					1
				}
			},
			icon_highlight = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = size,
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_19_0
	}
end

local tbl_4 = {
	word_wrap = true,
	font_size = 18,
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
local tbl_5 = {
	word_wrap = true,
	use_shadow = true,
	localize = false,
	font_size = 18,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("gray", 200),
	offset = {
		0,
		0,
		2
	}
}
local tbl_6 = {
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
local tbl_7 = {
	font_size = 32,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_8 = {
	summary_title = fn_3("window_title", "Overview", "Statistics"),
	hero_selection_title = fn_4("window_title", Localize("popup_choice_switch_hero")),
	item_list_window = fn_5("item_list_window"),
	item_list_mask = fn_6("item_list_mask", tbl_3.item_list_mask.size, 20),
	list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "item_list_window", tbl_3.list_scrollbar.size),
	hero_selection_button = UIWidgets.create_simple_hotspot("hero_selection_button"),
	window_button = UIWidgets.create_simple_hotspot("item_list_window"),
	hero_selection_warning = UIWidgets.create_simple_text("Currently playing as another hero", "hero_selection_warning", nil, nil, tbl_7)
}
local tbl_9 = {
	perk_title_text = UIWidgets.create_simple_text(Localize("hero_view_perk_title"), "perk_title_text", nil, nil, tbl_6),
	perk_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "perk_title_divider"),
	career_perk_1 = fn_7("career_perk_1"),
	career_perk_2 = fn_7("career_perk_2"),
	career_perk_3 = fn_7("career_perk_3"),
	passive_title_text = UIWidgets.create_simple_text("n/a", "passive_title_text", nil, nil, tbl_6),
	passive_type_title = UIWidgets.create_simple_text(Localize("hero_view_passive_ability"), "passive_type_title", nil, nil, tbl_5),
	passive_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "passive_title_divider"),
	passive_description_text = UIWidgets.create_simple_text("n/a", "passive_description_text", nil, nil, tbl_4),
	passive_icon = UIWidgets.create_simple_texture("icons_placeholder", "passive_icon"),
	passive_icon_frame = UIWidgets.create_simple_texture("talent_frame", "passive_icon_frame"),
	active_title_text = UIWidgets.create_simple_text("n/a", "active_title_text", nil, nil, tbl_6),
	active_type_title = UIWidgets.create_simple_text(Localize("hero_view_activated_ability"), "active_type_title", nil, nil, tbl_5),
	active_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "active_title_divider"),
	active_description_text = UIWidgets.create_simple_text("n/a", "active_description_text", nil, nil, tbl_4),
	active_icon = UIWidgets.create_simple_texture("icons_placeholder", "active_icon"),
	active_icon_frame = UIWidgets.create_simple_texture("talent_frame", "active_icon_frame")
}
local tbl_10 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				arg_20_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				-- function 21
				local easeOutCubic = math.easeOutCubic(arg_21_3)

				arg_21_4.render_settings.alpha_multiplier = easeOutCubic
				arg_21_0.item_list_window.local_position[1] = arg_21_1.item_list_window.position[1] + math.floor(100 * (1 - easeOutCubic))
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				return
			end
		}
	}
}

return {
	widgets = tbl_8,
	career_info_widgets = tbl_9,
	list_spacing = num,
	create_hero_icon_widget = fn_9,
	create_hero_widget = fn_8,
	create_stat_widget = fn_2,
	create_talent_widget = fn,
	scenegraph_definition = tbl_3,
	animation_definitions = tbl_10
}
