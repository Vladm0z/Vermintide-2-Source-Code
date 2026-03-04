-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_area_selection_console_v2_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.size
local var_0_2 = var_0_0.spacing
local var_0_3 = {
	var_0_1[1] * 3 + var_0_2 * 2,
	var_0_1[2]
}
local var_0_4 = {
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
local var_0_5 = {
	5,
	3
}
local var_0_6 = {
	root = {
		is_root = true,
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
	root_fit = {
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
	background = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			2
		}
	},
	video = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			1
		}
	},
	menu_root = {
		vertical_alignment = "center",
		parent = "root",
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
	window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			1960,
			1080
		},
		position = {
			0,
			0,
			1
		}
	},
	foreground = {
		parent = "window",
		position = {
			0,
			0,
			2
		}
	},
	area_root = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			220,
			2
		}
	},
	title_divider = {
		vertical_alignment = "bottom",
		parent = "area_root",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-160,
			1
		}
	},
	area_title = {
		vertical_alignment = "bottom",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			135,
			150,
			10
		}
	},
	description_text = {
		vertical_alignment = "bottom",
		parent = "menu_root",
		horizontal_alignment = "left",
		size = {
			1200,
			150
		},
		position = {
			135,
			190,
			2
		}
	},
	campaign_text = {
		vertical_alignment = "top",
		parent = "menu_root",
		horizontal_alignment = "left",
		position = {
			256,
			-440,
			5
		},
		size = {
			0,
			0
		}
	},
	side_quests_text = {
		vertical_alignment = "top",
		parent = "campaign_text",
		horizontal_alignment = "left",
		position = {
			206,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	not_owned_text = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			800,
			50
		},
		position = {
			0,
			150,
			12
		}
	},
	requirements_not_met_text = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			800,
			50
		},
		position = {
			0,
			200,
			12
		}
	}
}
local var_0_7 = {
	word_wrap = true,
	upper_case = true,
	localize = true,
	use_shadow = true,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		3
	}
}
local var_0_8 = {
	word_wrap = true,
	upper_case = true,
	localize = true,
	use_shadow = true,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		3
	}
}
local var_0_9 = {
	word_wrap = true,
	localize = false,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	draw_text_rect = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	rect_color = Colors.get_color_table_with_alpha("black", 150),
	offset = {
		0,
		0,
		3
	}
}
local var_0_10 = {
	font_size = 72,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
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
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = false,
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
local var_0_12 = {
	font_size = 32,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_13 = {
	font_size = 28,
	upper_case = false,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	area_size = {
		1200,
		1080
	},
	offset = {
		0,
		0,
		2
	}
}

local function var_0_14()
	local var_7_0 = {
		250,
		250
	}
	local var_7_1 = "area_root_main_campaign"

	var_0_6[var_7_1] = {
		vertical_alignment = "center",
		parent = "area_root",
		horizontal_alignment = "center",
		size = var_7_0,
		position = {
			0,
			100,
			1
		}
	}

	local var_7_2 = {
		element = {}
	}
	local var_7_3 = {
		{
			style_id = "icon",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "icon_glow",
			texture_id = "icon_glow"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon"
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function (arg_8_0)
				return arg_8_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local var_7_4 = {
		locked = true,
		frame = "map_frame_04",
		icon = "level_icon_01",
		lock = "hero_icon_locked_gold",
		icon_glow = "map_frame_glow_02",
		button_hotspot = {},
		divider = {
			texture_id = "menu_divider",
			uvs = {
				{
					0,
					1
				},
				{
					1,
					0
				}
			}
		}
	}
	local var_7_5 = {
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = var_7_0,
			offset = {
				0,
				0,
				6
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				76,
				87
			},
			offset = {
				64,
				-58,
				9
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				var_7_0[1] * 168 / 180,
				var_7_0[2] * 168 / 180
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
		},
		icon_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				var_7_0[1] * 270 / 180,
				var_7_0[2] * 270 / 180
			},
			offset = {
				0,
				0,
				3
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		divider = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			texture_size = {
				2,
				100
			},
			offset = {
				var_7_0[1] * 0.15,
				0,
				0
			},
			color = {
				192,
				255,
				255,
				255
			}
		},
		divider_top = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			texture_size = {
				2,
				var_7_0[2]
			},
			offset = {
				var_7_0[1] * 0.15,
				var_7_0[2] * 0.5,
				0
			},
			color = {
				192,
				255,
				255,
				255
			}
		},
		divider_bottom = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			texture_size = {
				2,
				var_7_0[2]
			},
			offset = {
				var_7_0[1] * 0.15,
				-var_7_0[2] * 0.5,
				0
			},
			color = {
				192,
				255,
				255,
				255
			}
		}
	}

	var_7_2.element.passes = var_7_3
	var_7_2.content = var_7_4
	var_7_2.style = var_7_5
	var_7_2.offset = {
		0,
		0,
		0
	}
	var_7_2.scenegraph_id = var_7_1

	return var_7_2
end

local function var_0_15(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1
	local var_9_1 = {
		150,
		150
	}

	if not var_9_0 then
		var_9_0 = "area_root_" .. arg_9_0
		var_0_6[var_9_0] = {
			vertical_alignment = "center",
			parent = "area_root",
			horizontal_alignment = "center",
			size = var_9_1,
			position = {
				0,
				100,
				1
			}
		}
	end

	local var_9_2 = {
		element = {}
	}
	local var_9_3 = {
		{
			style_id = "icon",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "icon_glow",
			texture_id = "icon_glow"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon"
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function (arg_10_0)
				return arg_10_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local var_9_4 = {
		locked = true,
		frame = "map_frame_04",
		icon = "level_icon_01",
		lock = "hero_icon_locked_gold",
		icon_glow = "map_frame_glow_02",
		button_hotspot = {}
	}
	local var_9_5 = {
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = var_9_1,
			offset = {
				0,
				0,
				6
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				76,
				87
			},
			offset = {
				64,
				-58,
				9
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				var_9_1[1] * 168 / 180,
				var_9_1[2] * 168 / 180
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
		},
		icon_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				var_9_1[1] * 270 / 180,
				var_9_1[2] * 270 / 180
			},
			offset = {
				0,
				0,
				3
			},
			color = {
				0,
				255,
				255,
				255
			}
		}
	}

	var_9_2.element.passes = var_9_3
	var_9_2.content = var_9_4
	var_9_2.style = var_9_5
	var_9_2.offset = {
		0,
		0,
		0
	}
	var_9_2.scenegraph_id = var_9_0

	return var_9_2
end

local function var_0_16()
	local var_11_0 = {
		420,
		1080
	}
	local var_11_1 = "left_fade"

	var_0_6[var_11_1] = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = var_11_0,
		position = {
			0,
			0,
			3
		}
	}

	local var_11_2 = {
		element = {}
	}
	local var_11_3 = {
		{
			style_id = "left_fade",
			pass_type = "texture_uv",
			content_id = "left_fade"
		}
	}
	local var_11_4 = {
		left_fade = {
			texture_id = "gradient",
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
		}
	}
	local var_11_5 = {
		left_fade = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			texture_size = {
				var_11_0[1],
				1080
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-960 + var_11_0[1] * 0.5,
				0
			}
		}
	}

	var_11_2.element.passes = var_11_3
	var_11_2.content = var_11_4
	var_11_2.style = var_11_5
	var_11_2.offset = {
		0,
		0,
		0
	}
	var_11_2.scenegraph_id = var_11_1

	return var_11_2
end

local function var_0_17(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1 and UIFrameSettings.button_frame_01_gold or UIFrameSettings.button_frame_01

	arg_12_0 = UIAtlasHelper.has_atlas_settings_by_texture_name(arg_12_0) and arg_12_0 or "any_small_image"

	local var_12_1 = {
		element = {}
	}
	local var_12_2 = {
		{
			texture_id = "level_image",
			style_id = "level_image",
			pass_type = "texture"
		},
		{
			texture_id = "frame",
			style_id = "frame",
			pass_type = "texture_frame"
		},
		{
			texture_id = "sigil",
			style_id = "sigil",
			pass_type = "texture",
			content_check_function = function (arg_13_0, arg_13_1)
				return arg_13_0.completed
			end
		},
		{
			texture_id = "sigil",
			style_id = "sigil_shadow",
			pass_type = "texture",
			content_check_function = function (arg_14_0, arg_14_1)
				return arg_14_0.completed
			end
		},
		{
			texture_id = "sigil_ribbon",
			style_id = "sigil_ribbon",
			pass_type = "texture",
			content_check_function = function (arg_15_0, arg_15_1)
				return arg_15_0.completed
			end
		},
		{
			texture_id = "sigil_ribbon",
			style_id = "sigil_ribbon_shadow",
			pass_type = "texture",
			content_check_function = function (arg_16_0, arg_16_1)
				return arg_16_0.completed
			end
		},
		{
			texture_id = "boss_icon",
			style_id = "boss_icon",
			pass_type = "texture",
			content_check_function = function (arg_17_0, arg_17_1)
				return arg_17_0.boss_level
			end
		}
	}
	local var_12_3 = {
		completed = false,
		boss_icon = "boss_icon",
		boss_level = true,
		sigil_ribbon = "store_owned_ribbon",
		sigil = "store_owned_sigil",
		level_image = arg_12_0,
		frame = var_12_0.texture
	}
	local var_12_4 = {
		level_image = {
			vertical_alignment = "bottom",
			saturated = true,
			horizontal_alignment = "left",
			texture_size = {
				97,
				58
			},
			color = {
				255,
				255,
				255,
				255
			},
			locked_color = {
				255,
				96,
				96,
				96
			},
			unlocked_color = {
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
		},
		sigil = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				39.75,
				39.75
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				1.625,
				-10.875,
				4
			}
		},
		sigil_shadow = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				39.75,
				39.75
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				3.625,
				-12.875,
				3
			}
		},
		sigil_ribbon = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				25.5,
				37.5
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				8.75,
				-29.75,
				2
			}
		},
		sigil_ribbon_shadow = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				25.5,
				37.5
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				10.75,
				-45.25,
				1
			}
		},
		boss_icon = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				34,
				34
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				69.8,
				-6.800000000000001,
				3
			}
		},
		frame = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			area_size = {
				97,
				58
			},
			texture_size = var_12_0.texture_size,
			texture_sizes = var_12_0.texture_sizes,
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
		}
	}

	var_12_1.element.passes = var_12_2
	var_12_1.content = var_12_3
	var_12_1.style = var_12_4
	var_12_1.offset = {
		0,
		-68,
		0
	}
	var_12_1.scenegraph_id = "area_title"

	return var_12_1
end

local function var_0_18()
	local var_18_0 = {
		element = {}
	}
	local var_18_1 = {
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text",
			content_change_function = function (arg_19_0, arg_19_1)
				arg_19_1.offset[1] = (arg_19_0.locked or arg_19_0.dlc) and 36 or 0
			end
		},
		{
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text",
			content_change_function = function (arg_20_0, arg_20_1)
				arg_20_1.offset[1] = (arg_20_0.locked or arg_20_0.dlc) and 36.9 or 0
			end
		},
		{
			texture_id = "lock",
			style_id = "lock",
			pass_type = "texture",
			content_check_function = function (arg_21_0, arg_21_1)
				return arg_21_0.locked and not arg_21_0.dlc
			end
		},
		{
			texture_id = "lock_dlc",
			style_id = "lock",
			pass_type = "texture",
			content_check_function = function (arg_22_0, arg_22_1)
				return arg_22_0.locked and arg_22_0.dlc_locked
			end
		}
	}
	local var_18_2 = {
		text = "area_selection_campaign",
		locked = true,
		lock = "hero_icon_locked",
		dlc_locked = true,
		lock_dlc = "hero_icon_locked_gold"
	}
	local var_18_3 = {
		text = {
			word_wrap = false,
			upper_case = false,
			localize = true,
			font_size = 28,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				0,
				80,
				2
			}
		},
		text_shadow = {
			word_wrap = false,
			upper_case = false,
			localize = true,
			font_size = 28,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				78,
				1
			}
		},
		lock = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				34.2,
				39.15
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				82,
				0
			}
		}
	}

	var_18_0.element.passes = var_18_1
	var_18_0.content = var_18_2
	var_18_0.style = var_18_3
	var_18_0.offset = {
		0,
		0,
		0
	}
	var_18_0.scenegraph_id = "area_title"

	return var_18_0
end

local var_0_19 = {
	background = UIWidgets.create_simple_rect("background", {
		255,
		0,
		0,
		0
	}),
	foreground = UIWidgets.create_simple_rect("foreground", {
		255,
		0,
		0,
		0
	}),
	window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "video", nil, nil, nil, 2),
	left_fade = var_0_16(),
	campaign = UIWidgets.create_simple_text(Localize("area_selection_campaign"), "campaign_text", nil, nil, var_0_11),
	area_title = UIWidgets.create_simple_text("area_title", "area_title", nil, nil, var_0_10),
	area_desc = UIWidgets.create_simple_text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut fringilla in nulla eu rutrum. Etiam non dapibus orci, sit amet tempus tortor. Mauris porttitor finibus quam eget tempor. Cras sed dui bibendum, gravida quam a, sodales justo. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut fringilla in nulla eu rutrum. Etiam non dapibus orci, sit amet tempus tortor. Mauris porttitor finibus quam eget tempor. Cras sed dui bibendum, gravida quam a, sodales justo. ", "description_text", nil, nil, var_0_13),
	area_type = var_0_18(),
	title_divider = UIWidgets.create_simple_texture("edge_divider_04_horizontal", "area_title", nil, nil, nil, nil, {
		var_0_13.area_size[1] * 0.9,
		8
	})
}
local var_0_20 = {}

for iter_0_0 = 1, 20 do
	var_0_20[iter_0_0] = var_0_15(iter_0_0)
end

return {
	widgets = var_0_19,
	area_widgets = var_0_20,
	create_level_image_func = var_0_17,
	main_campaign_widget = var_0_14(),
	map_size = var_0_3,
	scenegraph_definition = var_0_6,
	animation_definitions = var_0_4,
	grid_settings = var_0_5
}
