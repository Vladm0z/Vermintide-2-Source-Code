-- chunkname: @scripts/ui/views/deus_menu/deus_cursed_chest_view_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = {
	400,
	600
}
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
local var_0_9 = {
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
		size = var_0_6,
		position = {
			0,
			0,
			1
		}
	},
	window_overlay = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_6,
		position = {
			0,
			0,
			5
		}
	},
	window_frame = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = var_0_6,
		position = {
			0,
			0,
			30
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
			100
		}
	},
	bottom_glow = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_6[1] - var_0_8 * 2,
			1000
		},
		position = {
			0,
			var_0_8,
			3
		}
	},
	bottom_glow_short = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_6[1] - var_0_8 * 2,
			500
		},
		position = {
			0,
			var_0_8,
			4
		}
	},
	bottom_glow_shortest = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_6[1] - var_0_8 * 2,
			200
		},
		position = {
			0,
			var_0_8,
			5
		}
	},
	background_wheel_01 = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = {
			188,
			188
		},
		position = {
			-100,
			0,
			6
		}
	},
	background_wheel_02 = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = {
			461,
			461
		},
		position = {
			-100,
			0,
			6
		}
	},
	background_wheel_03 = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = {
			1074,
			1074
		},
		position = {
			-100,
			0,
			6
		}
	},
	exit_button = {
		vertical_alignment = "bottom",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			380,
			42
		},
		position = {
			0,
			-16,
			10
		}
	},
	title = {
		vertical_alignment = "top",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			658,
			60
		},
		position = {
			0,
			34,
			20
		}
	},
	title_bg = {
		vertical_alignment = "top",
		parent = "title",
		horizontal_alignment = "center",
		size = {
			410,
			40
		},
		position = {
			0,
			-15,
			-1
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "title",
		horizontal_alignment = "center",
		size = {
			350,
			50
		},
		position = {
			0,
			-3,
			1
		}
	},
	top_corner_left = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			15
		}
	},
	bottom_corner_left = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			15
		}
	},
	options_background_mask = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			1000,
			var_0_6[2]
		},
		position = {
			0,
			0,
			6
		}
	},
	options_background = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			1000,
			900
		},
		position = {
			0,
			0,
			6
		}
	},
	options_window_edge = {
		vertical_alignment = "center",
		parent = "options_background",
		horizontal_alignment = "right",
		size = {
			0,
			900
		},
		position = {
			0,
			0,
			6
		}
	},
	options_background_edge = {
		vertical_alignment = "center",
		parent = "options_window_edge",
		horizontal_alignment = "right",
		size = {
			126,
			var_0_6[2] - 20
		},
		position = {
			-493,
			0,
			1
		}
	},
	power_up_root = {
		vertical_alignment = "center",
		parent = "options_background",
		horizontal_alignment = "center",
		size = {
			484,
			194
		},
		position = {
			160,
			0,
			7
		}
	},
	chest_name_text = {
		vertical_alignment = "center",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			-300,
			0,
			1
		}
	},
	chest_lore_text = {
		vertical_alignment = "center",
		parent = "chest_name_text",
		horizontal_alignment = "center",
		size = {
			500,
			70
		},
		position = {
			0,
			-50,
			1
		}
	}
}
local var_0_10 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
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
local var_0_11 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 46,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_12 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}

local function var_0_13(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = {
		255,
		255,
		255,
		255
	}
	local var_1_1 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		masked = arg_1_2,
		color = {
			255,
			138,
			172,
			235
		},
		offset = {
			7,
			0,
			6
		},
		texture_size = {
			66,
			66
		}
	}
	local var_1_2 = table.clone(var_1_1)

	var_1_2.color = {
		255,
		80,
		80,
		80
	}

	local var_1_3 = {
		font_size = 20,
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		},
		font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			100,
			arg_1_1[2] - 70,
			3
		},
		size = {
			arg_1_1[1] - 270,
			30
		}
	}
	local var_1_4 = table.clone(var_1_3)

	var_1_4.text_color = {
		255,
		100,
		100,
		100
	}

	local var_1_5 = table.clone(var_1_3)

	var_1_5.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_1_5.offset = {
		var_1_3.offset[1] + 2,
		var_1_3.offset[2] - 2,
		var_1_3.offset[3] - 1
	}

	local var_1_6 = {
		font_size = 20,
		word_wrap = true,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		},
		font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			330,
			arg_1_1[2] - 70,
			3
		},
		size = {
			100,
			30
		}
	}
	local var_1_7 = table.clone(var_1_6)

	var_1_7.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_1_7.offset = {
		var_1_6.offset[1] + 2,
		var_1_6.offset[2] - 2,
		var_1_6.offset[3] - 1
	}

	local var_1_8 = {
		font_size = 18,
		word_wrap = true,
		dynamic_font_size_word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		color = {
			150,
			0,
			255,
			0
		},
		font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			100,
			arg_1_1[2] - 167,
			3
		},
		size = {
			arg_1_1[1] - 155,
			100
		}
	}
	local var_1_9 = table.clone(var_1_8)

	var_1_9.text_color = {
		255,
		80,
		80,
		80
	}

	local var_1_10 = table.clone(var_1_8)

	var_1_10.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_1_10.offset = {
		var_1_8.offset[1] + 2,
		var_1_8.offset[2] - 2,
		var_1_8.offset[3] - 1
	}

	local var_1_11 = {
		font_size = 22,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		},
		font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			-60,
			70,
			3
		},
		default_offset = {
			-60,
			70,
			3
		},
		size = {
			55,
			20
		},
		color_override = {},
		color_override_table = {
			start_index = 0,
			end_index = 0,
			color = {
				255,
				121,
				193,
				229
			}
		}
	}
	local var_1_12 = table.clone(var_1_11)

	var_1_12.text_color = Colors.get_color_table_with_alpha("red", 255)

	local var_1_13 = table.clone(var_1_11)

	var_1_13.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_1_13.offset = {
		var_1_11.offset[1] + 2,
		var_1_11.offset[2] - 2,
		var_1_11.offset[3] - 1
	}

	local var_1_14 = {
		font_size = 18,
		word_wrap = true,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		},
		font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
		text_color = {
			255,
			150,
			150,
			150
		},
		offset = {
			-155,
			40,
			3
		},
		size = {
			80,
			20
		}
	}
	local var_1_15 = table.clone(var_1_14)

	var_1_15.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_1_15.offset = {
		var_1_14.offset[1] + 2,
		var_1_14.offset[2] - 2,
		var_1_14.offset[3] - 1
	}

	local var_1_16 = {
		font_size = 18,
		word_wrap = true,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		},
		font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			-60,
			40,
			3
		},
		size = {
			30,
			20
		}
	}
	local var_1_17 = table.clone(var_1_16)

	var_1_17.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_1_17.offset = {
		var_1_16.offset[1] + 2,
		var_1_16.offset[2] - 2,
		var_1_16.offset[3] - 1
	}

	local var_1_18 = table.clone(var_1_14)

	var_1_18.offset[2] = 15

	local var_1_19 = table.clone(var_1_18)

	var_1_19.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_1_19.offset = {
		var_1_18.offset[1] + 2,
		var_1_18.offset[2] - 2,
		var_1_18.offset[3] - 1
	}

	local var_1_20 = table.clone(var_1_16)

	var_1_20.offset[2] = 15
	var_1_20.text_color = Colors.get_color_table_with_alpha("font_title", 255)

	local var_1_21 = table.clone(var_1_20)

	var_1_21.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_1_21.offset = {
		var_1_20.offset[1] + 2,
		var_1_20.offset[2] - 2,
		var_1_20.offset[3] - 1
	}

	local var_1_22 = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			style_id = "background",
			pass_type = "texture_uv",
			content_id = "background"
		},
		{
			style_id = "frame",
			pass_type = "texture_uv",
			content_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "icon_bought_frame",
			texture_id = "icon_bought_frame"
		},
		{
			pass_type = "texture",
			style_id = "icon_discount_frame",
			texture_id = "icon_discount_frame",
			content_check_function = function(arg_2_0)
				return arg_2_0.has_discount
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_hover_frame",
			texture_id = "icon_hover_frame"
		},
		{
			pass_type = "texture",
			style_id = "icon_background",
			texture_id = "icon_background"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function(arg_3_0)
				return arg_3_0.is_bought or not arg_3_0.button_hotspot.disable_button
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_disabled",
			texture_id = "icon",
			content_check_function = function(arg_4_0)
				return arg_4_0.button_hotspot.disable_button and not arg_4_0.is_bought
			end
		},
		{
			style_id = "sub_text_disabled",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function(arg_5_0)
				return arg_5_0.button_hotspot.disable_button and not arg_5_0.is_bought
			end
		},
		{
			style_id = "sub_text",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function(arg_6_0)
				return arg_6_0.is_bought or not arg_6_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "sub_text_shadow",
			pass_type = "text",
			text_id = "sub_text"
		},
		{
			style_id = "title_text_disabled",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function(arg_7_0)
				return arg_7_0.button_hotspot.disable_button and not arg_7_0.is_bought
			end
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function(arg_8_0)
				return arg_8_0.is_bought or not arg_8_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "rarity_text",
			pass_type = "text",
			text_id = "rarity_text"
		},
		{
			style_id = "rarity_text_shadow",
			pass_type = "text",
			text_id = "rarity_text"
		},
		{
			style_id = "price_text",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function(arg_9_0)
				return not arg_9_0.button_hotspot.disable_button and not arg_9_0.is_bought
			end
		},
		{
			style_id = "price_text_disabled",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function(arg_10_0)
				return arg_10_0.button_hotspot.disable_button and not arg_10_0.is_bought
			end
		},
		{
			style_id = "price_text_shadow",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function(arg_11_0)
				return not arg_11_0.is_bought
			end
		},
		{
			pass_type = "texture",
			style_id = "price_icon",
			texture_id = "price_icon",
			content_check_function = function(arg_12_0)
				return not arg_12_0.is_bought
			end
		},
		{
			style_id = "current_value_title_text",
			pass_type = "text",
			text_id = "current_value_title_text",
			content_check_function = function(arg_13_0)
				return not arg_13_0.is_bought and arg_13_0.current_value_text and arg_13_0.max_value_text
			end
		},
		{
			style_id = "current_value_title_text_shadow",
			pass_type = "text",
			text_id = "current_value_title_text",
			content_check_function = function(arg_14_0)
				return not arg_14_0.is_bought and arg_14_0.current_value_text and arg_14_0.max_value_text
			end
		},
		{
			style_id = "current_value_text",
			pass_type = "text",
			text_id = "current_value_text",
			content_check_function = function(arg_15_0)
				return not arg_15_0.is_bought and arg_15_0.current_value_text and arg_15_0.max_value_text
			end
		},
		{
			style_id = "current_value_text_shadow",
			pass_type = "text",
			text_id = "current_value_text",
			content_check_function = function(arg_16_0)
				return not arg_16_0.is_bought and arg_16_0.current_value_text and arg_16_0.max_value_text
			end
		},
		{
			style_id = "max_value_title_text",
			pass_type = "text",
			text_id = "max_value_title_text",
			content_check_function = function(arg_17_0)
				return not arg_17_0.is_bought and arg_17_0.current_value_text and arg_17_0.max_value_text
			end
		},
		{
			style_id = "max_value_title_text_shadow",
			pass_type = "text",
			text_id = "max_value_title_text",
			content_check_function = function(arg_18_0)
				return not arg_18_0.is_bought and arg_18_0.current_value_text and arg_18_0.max_value_text
			end
		},
		{
			style_id = "max_value_text",
			pass_type = "text",
			text_id = "max_value_text",
			content_check_function = function(arg_19_0)
				return not arg_19_0.is_bought and arg_19_0.current_value_text and arg_19_0.max_value_text
			end
		},
		{
			style_id = "max_value_text_shadow",
			pass_type = "text",
			text_id = "max_value_text",
			content_check_function = function(arg_20_0)
				return not arg_20_0.is_bought and arg_20_0.current_value_text and arg_20_0.max_value_text
			end
		},
		{
			style_id = "unlocked_text",
			pass_type = "text",
			text_id = "unlocked_text",
			content_check_function = function(arg_21_0)
				return arg_21_0.is_bought
			end
		},
		{
			style_id = "hover",
			pass_type = "texture_uv",
			content_id = "hover"
		},
		{
			style_id = "set_progression",
			pass_type = "text",
			text_id = "set_progression",
			content_check_function = function(arg_22_0)
				return arg_22_0.is_part_of_set
			end
		}
	}
	local var_1_23 = {
		title_text = "",
		icon_background = "button_frame_01",
		is_bought = false,
		price_icon = "deus_icons_coin",
		price_text = "0",
		icon_bought_frame = "frame_outer_glow_04_big",
		is_part_of_set = false,
		icon = "icon_property_attack_speed",
		max_value_text = "20%",
		current_value_text = "10%",
		has_discount = false,
		sub_text = "",
		rarity_text = "",
		icon_discount_frame = "button_detail_discount_01",
		icon_hover_frame = "frame_outer_glow_04",
		button_hotspot = {},
		background = {
			texture_id = "shrine_blessing_bg",
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
		hover = {
			texture_id = "shrine_blessing_bg_hover",
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
		frame = {
			texture_id = "shrine_blessing_frame",
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
		size = arg_1_1,
		current_value_title_text = Localize("deus_shrine_current_value"),
		max_value_title_text = Localize("deus_shrine_max_value"),
		unlocked_text = Localize("deus_shrine_unlocked"),
		bought_glow_style_ids = {
			"icon_bought_frame"
		}
	}
	local var_1_24 = {
		debug = {
			masked = arg_1_2,
			color = {
				255,
				255,
				0,
				0
			},
			offset = {
				-1,
				-1,
				8
			},
			size = {
				3,
				3
			}
		},
		icon_bought_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-39,
				0,
				2
			},
			texture_size = {
				158,
				158
			}
		},
		icon_discount_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_1_2,
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
			},
			texture_size = {
				80,
				80
			}
		},
		icon_hover_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-24,
				0,
				3
			},
			texture_size = {
				128,
				128
			}
		},
		icon_background = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			texture_size = {
				80,
				80
			},
			offset = {
				0,
				0,
				3
			}
		},
		icon = var_1_1,
		icon_disabled = var_1_2,
		icon_bg = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_1_2,
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				7,
				0,
				5
			},
			texture_size = {
				66,
				66
			}
		},
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_1_2,
			color = var_1_0,
			offset = {
				0,
				0,
				0
			},
			texture_size = arg_1_1
		},
		hover = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_1_2,
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
			},
			texture_size = arg_1_1
		},
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_1_2,
			color = var_1_0,
			offset = {
				0,
				0,
				2
			},
			texture_size = arg_1_1
		},
		price_icon = {
			masked = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-90,
				68
			},
			size = {
				20,
				20
			}
		},
		price_text = var_1_11,
		price_text_shadow = var_1_13,
		price_text_disabled = var_1_12,
		title_text_disabled = var_1_4,
		title_text = var_1_3,
		title_text_shadow = var_1_5,
		rarity_text = var_1_6,
		rarity_text_shadow = var_1_7,
		sub_text_disabled = var_1_9,
		sub_text = var_1_8,
		sub_text_shadow = var_1_10,
		current_value_title_text = var_1_14,
		current_value_title_text_shadow = var_1_15,
		current_value_text = var_1_16,
		current_value_text_shadow = var_1_17,
		max_value_title_text = var_1_18,
		max_value_title_text_shadow = var_1_19,
		max_value_text = var_1_20,
		max_value_text_shadow = var_1_21,
		unlocked_text = {
			font_size = 24,
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				-130,
				40,
				3
			},
			size = {
				120,
				30
			}
		},
		set_progression = {
			word_wrap = false,
			upper_case = false,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark",
			progression_colors = {
				incomplete = Colors.get_color_table_with_alpha("font_default", 255),
				complete = Colors.get_color_table_with_alpha("lime_green", 255)
			},
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			area_size = {
				250,
				22
			},
			size = {
				250,
				22
			},
			offset = {
				110,
				24,
				10
			}
		}
	}

	return {
		element = {
			passes = var_1_22
		},
		content = var_1_23,
		style = var_1_24,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local var_0_14 = {
	255,
	25,
	21,
	36
}
local var_0_15 = {
	255,
	159,
	154,
	210
}
local var_0_16 = {
	200,
	208,
	149,
	177
}
local var_0_17 = {
	200,
	94,
	67,
	101
}
local var_0_18 = {
	200,
	172,
	101,
	159
}
local var_0_19 = {
	130,
	250,
	212,
	251
}
local var_0_20 = true
local var_0_21 = {
	console_cursor = UIWidgets.create_console_cursor("console_cursor"),
	window_frame = UIWidgets.create_frame("window_frame", var_0_9.window.size, "menu_frame_11", 10),
	background_write_mask = UIWidgets.create_simple_texture("shrine_background_write_mask", "window"),
	background_wheel_01 = UIWidgets.create_simple_rotated_texture("shrine_circle_background_01", 0, {
		94,
		94
	}, "background_wheel_01", nil, nil, var_0_15),
	background_wheel_02 = UIWidgets.create_simple_rotated_texture("shrine_circle_background_02", 0, {
		230.5,
		230.5
	}, "background_wheel_02", nil, nil, var_0_15),
	background_wheel_03 = UIWidgets.create_simple_rotated_texture("shrine_circle_background_03", 0, {
		537,
		537
	}, "background_wheel_03", nil, nil, var_0_15),
	bottom_glow_smoke_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, var_0_16),
	bottom_glow_smoke_2 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, var_0_17),
	bottom_glow_smoke_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_shortest", nil, nil, var_0_18),
	bottom_glow_embers_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, var_0_19, 1),
	bottom_glow_embers_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_3", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, var_0_19, 1),
	window_background = UIWidgets.create_simple_rect("window", var_0_14),
	top_corner_left = UIWidgets.create_simple_texture("athanor_decoration_corner", "top_corner_left"),
	bottom_corner_left = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_corner_left"),
	options_background_edge = UIWidgets.create_simple_texture("shrine_sidebar_background", "options_background_edge"),
	options_background = UIWidgets.create_tiled_texture("options_background", "menu_frame_bg_01", {
		960,
		1080
	}, nil, true, {
		255,
		120,
		120,
		120
	}),
	options_background_mask = UIWidgets.create_simple_uv_texture("shrine_sidebar_write_mask", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "options_background_mask"),
	exit_button = UIWidgets.create_default_button("exit_button", var_0_9.exit_button.size, nil, nil, Localize("menu_close"), 24, nil, "button_detail_04", 34, var_0_20),
	title = UIWidgets.create_simple_texture("frame_title_bg", "title"),
	title_bg = UIWidgets.create_background("title_bg", var_0_9.title_bg.size, "menu_frame_bg_02"),
	title_text = UIWidgets.create_simple_text(Localize("deus_cursed_chest_title"), "title_text", nil, nil, var_0_10),
	chest_name_text = UIWidgets.create_simple_text(Localize("deus_cursed_chest_title"), "chest_name_text", nil, nil, var_0_11),
	chest_lore_text = UIWidgets.create_simple_text(Localize("deus_cursed_chest_lore"), "chest_lore_text", nil, nil, var_0_12)
}

return {
	scenegraph_definition = var_0_9,
	background_widgets = var_0_21,
	create_power_up_shop_item = var_0_13
}
