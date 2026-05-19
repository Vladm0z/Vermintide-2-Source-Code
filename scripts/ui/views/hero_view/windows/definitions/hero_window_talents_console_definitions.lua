-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_talents_console_definitions.lua

local var_0_0 = {
	1215,
	820
}
local var_0_1 = {
	450,
	170
}
local var_0_2 = {
	364,
	80
}
local var_0_3 = UISettings.console_menu_scenegraphs
local var_0_4 = {
	screen = var_0_3.screen,
	area = var_0_3.area,
	area_left = var_0_3.area_left,
	area_right = var_0_3.area_right,
	area_divider = var_0_3.area_divider,
	info_window = {
		vertical_alignment = "top",
		parent = "area_right",
		horizontal_alignment = "right",
		size = {
			var_0_1[1] + 20,
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
			var_0_1[1] + 20,
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
		size = var_0_1,
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
			var_0_1[1] * 0.6,
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
			var_0_1[1] * 0.3,
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
			var_0_1[1] - 110,
			var_0_1[2] - 40
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
		size = var_0_1,
		position = {
			0,
			-var_0_1[2],
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
			var_0_1[1] * 0.6,
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
			var_0_1[1] * 0.3,
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
			var_0_1[1] - 110,
			var_0_1[2] - 40
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
			var_0_1[1] * 0.6,
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
	talent_row_1 = {
		vertical_alignment = "bottom",
		parent = "talent_row_2",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] - 20,
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
			var_0_0[1] - 20,
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
			var_0_0[1] - 20,
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
			var_0_0[1] - 20,
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
			var_0_0[1] - 20,
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
			var_0_0[1] - 20,
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
			var_0_0[1] - 20,
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
			var_0_0[1] - 40,
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
			var_0_0[1] - 40,
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
			var_0_0[1] - 40,
			40
		},
		position = {
			0,
			0,
			1
		}
	}
}
local var_0_5 = {
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
local var_0_6 = {
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
local var_0_7 = {
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
local var_0_8 = {
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
local var_0_9 = {
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
local var_0_10 = {
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
local var_0_11 = {
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

local function var_0_12(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = UIFrameSettings.menu_frame_09
	local var_1_1 = "frame_outer_glow_01"
	local var_1_2 = UIFrameSettings[var_1_1]
	local var_1_3 = var_1_2.texture_sizes.corner[1]
	local var_1_4 = {
		element = {}
	}
	local var_1_5 = {
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
	local var_1_6 = {
		level_text = "0",
		lock = "talent_lock_fg",
		amount = arg_1_3,
		frame = var_1_0.texture,
		glow_frame = var_1_2.texture
	}
	local var_1_7 = math.min(97, arg_1_1[2] - 8)
	local var_1_8 = {
		frame = {
			texture_size = var_1_0.texture_size,
			texture_sizes = var_1_0.texture_sizes,
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
			texture_size = var_1_0.texture_size,
			texture_sizes = var_1_0.texture_sizes,
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
				var_1_7,
				var_1_7
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
	local var_1_9 = 0
	local var_1_10 = 0
	local var_1_11 = {
		80,
		80
	}
	local var_1_12 = arg_1_1[1] - (arg_1_2[1] * arg_1_3 + var_1_9 * (arg_1_3 - 1))

	for iter_1_0 = 1, arg_1_3 do
		local var_1_13 = "_" .. tostring(iter_1_0)
		local var_1_14 = iter_1_0 - 1
		local var_1_15 = {
			var_1_12,
			0,
			var_1_10
		}
		local var_1_16 = "hotspot" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "hotspot",
			content_id = var_1_16,
			style_id = var_1_16
		}
		var_1_8[var_1_16] = {
			size = arg_1_2,
			offset = var_1_15
		}
		var_1_6[var_1_16] = {}

		local var_1_17 = var_1_6[var_1_16]
		local var_1_18 = "background" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "rect",
			style_id = var_1_18
		}
		var_1_8[var_1_18] = {
			size = arg_1_2,
			color = {
				IS_WINDOWS and 165 or 100,
				0,
				0,
				0
			},
			offset = {
				var_1_15[1],
				var_1_15[2],
				0
			}
		}

		local var_1_19 = "frame" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "texture_frame",
			texture_id = var_1_19,
			style_id = var_1_19
		}
		var_1_8[var_1_19] = {
			texture_size = var_1_0.texture_size,
			texture_sizes = var_1_0.texture_sizes,
			size = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_1_15[1],
				var_1_15[2],
				7
			}
		}
		var_1_6[var_1_19] = var_1_0.texture

		local var_1_20 = "selected" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "texture",
			texture_id = var_1_20,
			style_id = var_1_20,
			content_check_function = function(arg_2_0)
				return arg_2_0[var_1_16].is_selected
			end
		}
		var_1_8[var_1_20] = {
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
				var_1_15[1],
				var_1_15[2],
				28
			}
		}
		var_1_6[var_1_20] = "talent_selected"

		local var_1_21 = "title_text" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "text",
			text_id = var_1_21,
			style_id = var_1_21,
			content_check_function = function(arg_3_0)
				local var_3_0 = arg_3_0[var_1_16]

				return not var_3_0.is_selected and not var_3_0.disabled
			end
		}
		var_1_8[var_1_21] = {
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
				var_1_15[1] + 90,
				var_1_15[2],
				3
			}
		}
		var_1_6[var_1_21] = "n/a"

		local var_1_22 = "title_text_selected" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "text",
			text_id = var_1_21,
			style_id = var_1_22,
			content_check_function = function(arg_4_0)
				local var_4_0 = arg_4_0[var_1_16]

				return var_4_0.is_selected and not var_4_0.disabled
			end
		}
		var_1_8[var_1_22] = {
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
				var_1_15[1] + 90,
				var_1_15[2],
				3
			}
		}

		local var_1_23 = "title_text_disabled" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "text",
			text_id = var_1_21,
			style_id = var_1_23,
			content_check_function = function(arg_5_0)
				return arg_5_0[var_1_16].disabled
			end
		}
		var_1_8[var_1_23] = {
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
				var_1_15[1] + 90,
				var_1_15[2],
				3
			}
		}

		local var_1_24 = "title_text_shadow" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "text",
			text_id = var_1_21,
			style_id = var_1_24
		}
		var_1_8[var_1_24] = {
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
				var_1_15[1] + 90 + 2,
				var_1_15[2] - 2,
				2
			}
		}

		local var_1_25 = "background_glow" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "texture",
			texture_id = var_1_25,
			style_id = var_1_25,
			content_check_function = function(arg_6_0)
				local var_6_0 = arg_6_0[var_1_16]

				return var_6_0.is_hover or var_6_0.focused
			end
		}
		var_1_8[var_1_25] = {
			size = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_1_15[1],
				var_1_15[2],
				3
			}
		}
		var_1_6[var_1_25] = "talent_bg_glow_01"

		local var_1_26 = "glass_top" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "texture",
			texture_id = var_1_26,
			style_id = var_1_26
		}
		var_1_8[var_1_26] = {
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
				var_1_15[1],
				var_1_15[2] + arg_1_2[2] - 8,
				5
			}
		}
		var_1_6[var_1_26] = "button_glass_01"

		local var_1_27 = "icon" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "texture",
			texture_id = var_1_27,
			style_id = var_1_27
		}
		var_1_8[var_1_27] = {
			saturated = true,
			size = var_1_11,
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				var_1_15[1],
				var_1_15[2] + arg_1_2[2] / 2 - var_1_11[2] / 2,
				3
			}
		}
		var_1_6[var_1_27] = "icons_placeholder"

		local var_1_28 = "icon_rect" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "rect",
			style_id = var_1_28,
			content_check_function = function(arg_7_0)
				local var_7_0 = arg_7_0[var_1_16]

				return not var_7_0.disabled and not var_7_0.is_selected
			end
		}
		var_1_8[var_1_28] = {
			size = var_1_11,
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				var_1_15[1],
				var_1_15[2] + arg_1_2[2] / 2 - var_1_11[2] / 2,
				4
			}
		}

		local var_1_29 = "icon_disabled_rect" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "rect",
			style_id = var_1_29,
			content_check_function = function(arg_8_0)
				return arg_8_0[var_1_16].disabled
			end
		}
		var_1_8[var_1_29] = {
			size = var_1_11,
			color = {
				200,
				0,
				0,
				0
			},
			offset = {
				var_1_15[1],
				var_1_15[2] + arg_1_2[2] / 2 - var_1_11[2] / 2,
				4
			}
		}

		local var_1_30 = "icon_divider" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			pass_type = "texture",
			texture_id = var_1_30,
			style_id = var_1_30
		}
		var_1_8[var_1_30] = {
			size = {
				5,
				var_1_11[2] - 2
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				var_1_15[1] + var_1_11[1] - 5,
				var_1_15[2] + arg_1_2[2] / 2 - var_1_11[2] / 2 + 1,
				6
			}
		}
		var_1_6[var_1_30] = "menu_frame_09_divider_vertical"

		local var_1_31 = "tooltip" .. var_1_13

		var_1_5[#var_1_5 + 1] = {
			talent_id = "talent",
			pass_type = "talent_tooltip",
			content_id = var_1_16,
			style_id = var_1_31,
			content_check_function = function(arg_9_0)
				return arg_9_0.talent and arg_9_0.is_hover
			end
		}
		var_1_8[var_1_31] = {
			size = arg_1_2,
			offset = {
				var_1_15[1],
				var_1_15[2],
				var_1_15[3] + 10
			}
		}
		var_1_6[var_1_31] = nil
		var_1_12 = var_1_12 + arg_1_2[1] + var_1_9
	end

	var_1_4.element.passes = var_1_5
	var_1_4.content = var_1_6
	var_1_4.style = var_1_8
	var_1_4.offset = {
		0,
		0,
		0
	}
	var_1_4.scenegraph_id = arg_1_0

	return var_1_4
end

local function var_0_13(arg_10_0)
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

local var_0_14 = {
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
local var_0_15 = {
	tooltip_area = UIWidgets.create_rect_with_outer_frame("tooltip_area", var_0_4.tooltip_area.size, "frame_outer_fade_02", 0, UISettings.console_menu_rect_color),
	tooltip_title = UIWidgets.create_simple_text("n/a", "tooltip_title", nil, nil, var_0_10),
	tooltip_description = UIWidgets.create_simple_text("n/a", "tooltip_description", nil, nil, var_0_7),
	tooltip_info = UIWidgets.create_simple_text("n/a", "tooltip_info", nil, nil, var_0_8),
	talent_row_1 = var_0_12("talent_row_1", var_0_4.talent_row_1.size, var_0_2, 3),
	talent_row_2 = var_0_12("talent_row_2", var_0_4.talent_row_2.size, var_0_2, 3),
	talent_row_3 = var_0_12("talent_row_3", var_0_4.talent_row_3.size, var_0_2, 3),
	talent_row_4 = var_0_12("talent_row_4", var_0_4.talent_row_4.size, var_0_2, 3),
	talent_row_5 = var_0_12("talent_row_5", var_0_4.talent_row_5.size, var_0_2, 3),
	talent_row_6 = var_0_12("talent_row_6", var_0_4.talent_row_6.size, var_0_2, 3),
	info_window_background = UIWidgets.create_rect_with_outer_frame("info_window", var_0_4.info_window.size, "frame_outer_fade_02", 0, UISettings.console_menu_rect_color),
	mask = UIWidgets.create_simple_texture("mask_rect", "scrollbar_anchor"),
	perk_title_text = UIWidgets.create_simple_text(Localize("hero_view_perk_title"), "perk_title_text", nil, nil, var_0_11),
	perk_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "perk_title_divider", true),
	career_perk_1 = var_0_13("career_perk_1"),
	career_perk_2 = var_0_13("career_perk_2"),
	career_perk_3 = var_0_13("career_perk_3"),
	passive_title_text = UIWidgets.create_simple_text("n/a", "passive_title_text", nil, nil, var_0_11),
	passive_type_title = UIWidgets.create_simple_text(Localize("hero_view_passive_ability"), "passive_type_title", nil, nil, var_0_9),
	passive_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "passive_title_divider", true),
	passive_description_text = UIWidgets.create_simple_text("n/a", "passive_description_text", nil, nil, var_0_6),
	passive_icon = UIWidgets.create_simple_texture("icons_placeholder", "passive_icon", true),
	passive_icon_frame = UIWidgets.create_simple_texture("talent_frame", "passive_icon_frame", true),
	active_title_text = UIWidgets.create_simple_text("n/a", "active_title_text", nil, nil, var_0_11),
	active_type_title = UIWidgets.create_simple_text(Localize("hero_view_activated_ability"), "active_type_title", nil, nil, var_0_9),
	active_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "active_title_divider", true),
	active_description_text = UIWidgets.create_simple_text("n/a", "active_description_text", nil, nil, var_0_6),
	active_icon = UIWidgets.create_simple_texture("icons_placeholder", "active_icon", true),
	active_icon_frame = UIWidgets.create_simple_texture("talent_frame", "active_icon_frame", true)
}
local var_0_16 = {
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
local var_0_17 = {
	on_enter = {
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
				arg_12_0.area_left.local_position[1] = arg_12_1.area_left.position[1] + -100 * (1 - var_12_0)
				arg_12_0.area_right.local_position[1] = arg_12_1.area_right.position[1] + -100 * (1 - var_12_0)
			end,
			on_complete = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				arg_14_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				local var_15_0 = math.easeOutCubic(arg_15_3)

				arg_15_4.render_settings.alpha_multiplier = 1 - var_15_0
			end,
			on_complete = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_15,
	scenegraph_definition = var_0_4,
	animation_definitions = var_0_17,
	generic_input_actions = var_0_16
}
