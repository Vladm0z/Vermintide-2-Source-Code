-- chunkname: @scripts/ui/views/deus_menu/deus_shop_view_definitions_v2.lua

require("scripts/ui/views/deus_menu/ui_widgets_deus")

local var_0_0 = {
	1920,
	1080
}
local var_0_1 = 200
local var_0_2 = true
local var_0_3 = {
	root = {
		is_root = true,
		size = var_0_0,
		position = {
			0,
			0,
			UILayer.default
		}
	},
	screen = {
		scale = "fit",
		size = var_0_0,
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
		size = var_0_0,
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
		size = var_0_0,
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
		size = var_0_0,
		position = {
			0,
			0,
			30
		}
	},
	background_unit = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_0[1],
			var_0_0[2]
		},
		position = {
			0,
			0,
			3
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
			var_0_0[1],
			1200
		},
		position = {
			0,
			0,
			3
		}
	},
	bottom_glow_short = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_0[1],
			500
		},
		position = {
			0,
			0,
			4
		}
	},
	bottom_glow_shortest = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_0[1],
			200
		},
		position = {
			0,
			0,
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
			0.6666666666666666 * var_0_1,
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
			0.6666666666666666 * var_0_1,
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
			0.6666666666666666 * var_0_1,
			0,
			6
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
			20
		}
	},
	bottom_corner_left_top = {
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
			20
		}
	},
	options_background_mask = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			900,
			var_0_0[2]
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
			900,
			var_0_0[2]
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
			var_0_0[2]
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
			var_0_0[2]
		},
		position = {
			-443,
			0,
			1
		}
	},
	options_background_mask_left = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			585,
			var_0_0[2]
		},
		position = {
			-225,
			0,
			6
		}
	},
	options_background_left = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			350,
			var_0_0[2]
		},
		position = {
			0,
			0,
			1
		}
	},
	options_window_edge_left = {
		vertical_alignment = "center",
		parent = "options_background_left",
		horizontal_alignment = "left",
		size = {
			0,
			var_0_0[2]
		},
		position = {
			-225,
			0,
			6
		}
	},
	options_background_edge_left = {
		vertical_alignment = "center",
		parent = "options_window_edge_left",
		horizontal_alignment = "left",
		size = {
			126,
			var_0_0[2]
		},
		position = {
			443,
			0,
			-5
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
			140,
			60,
			7
		}
	},
	blessing_root = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			484,
			194
		},
		position = {
			70 + var_0_1,
			60,
			10
		}
	},
	own_power_up_root = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			64,
			64
		},
		position = {
			45,
			-90,
			7
		}
	},
	own_power_up_anchor = {
		parent = "own_power_up_root",
		position = {
			0,
			0,
			0
		}
	},
	scrollbar_anchor = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		position = {
			50,
			-90,
			7
		},
		size = {
			200,
			735
		}
	},
	own_power_up_window = {
		parent = "scrollbar_anchor",
		position = {
			-20,
			0,
			0
		}
	},
	top_options_background = {
		vertical_alignment = "top",
		parent = "options_window_edge",
		horizontal_alignment = "right",
		size = {
			576,
			111
		},
		position = {
			0,
			0,
			10
		}
	},
	coins_text = {
		vertical_alignment = "center",
		parent = "top_options_background",
		horizontal_alignment = "center",
		size = {
			100,
			30
		},
		position = {
			40,
			20,
			1
		}
	},
	coins_icon = {
		vertical_alignment = "center",
		parent = "coins_text",
		horizontal_alignment = "left",
		size = {
			30,
			30
		},
		position = {
			-35,
			2,
			1
		}
	},
	top_options_background_left = {
		vertical_alignment = "top",
		parent = "options_window_edge_left",
		horizontal_alignment = "left",
		size = {
			351,
			111
		},
		position = {
			225,
			0,
			10
		}
	},
	boons_text = {
		vertical_alignment = "center",
		parent = "top_options_background_left",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		}
	},
	bottom_options_background = {
		vertical_alignment = "bottom",
		parent = "options_window_edge",
		horizontal_alignment = "right",
		size = {
			576,
			111
		},
		position = {
			0,
			0,
			10
		}
	},
	bottom_options_background_left = {
		vertical_alignment = "bottom",
		parent = "options_window_edge_left",
		horizontal_alignment = "left",
		size = {
			351,
			111
		},
		position = {
			225,
			0,
			10
		}
	},
	bottom_text = {
		vertical_alignment = "bottom",
		parent = "bottom_options_background",
		horizontal_alignment = "center",
		size = {
			320,
			30
		},
		position = {
			0,
			20,
			1
		}
	},
	ready_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			300,
			60
		},
		position = {
			0,
			75,
			6
		}
	},
	timer_text = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			350,
			150
		},
		position = {
			0,
			-500,
			10
		}
	},
	player_pivot = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-120,
			6
		}
	},
	player_1 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			120,
			150,
			6
		}
	},
	player_2 = {
		vertical_alignment = "top",
		parent = "player_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-280,
			-220 * 0,
			1
		}
	},
	player_3 = {
		vertical_alignment = "top",
		parent = "player_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-280,
			-220,
			1
		}
	},
	player_4 = {
		vertical_alignment = "top",
		parent = "player_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-280,
			-440,
			1
		}
	},
	title_background = {
		vertical_alignment = "center",
		parent = "window_overlay",
		horizontal_alignment = "center",
		size = {
			400,
			150
		},
		position = {
			0 + 0.6666666666666666 * var_0_1,
			0,
			3
		}
	},
	shrine_title_text = {
		vertical_alignment = "center",
		parent = "title_background",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			0,
			50,
			4
		}
	},
	shrine_sub_title_text = {
		vertical_alignment = "top",
		parent = "shrine_title_text",
		horizontal_alignment = "center",
		size = {
			400,
			100
		},
		position = {
			0,
			-50,
			4
		}
	},
	hold_to_buy_text = {
		vertical_alignment = "center",
		parent = "ready_button",
		horizontal_alignment = "center",
		size = {
			100,
			50
		},
		position = {
			-25,
			50,
			10
		}
	},
	power_up_description_root = {
		size = {
			484,
			194
		},
		position = {
			0,
			0,
			UILayer.end_screen + 200
		}
	},
	blocker = {
		parent = "window",
		size = {
			500,
			1080
		},
		position = {
			-500,
			0,
			400
		}
	},
	input_helper_text = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center"
	}
}
local var_0_4 = {
	64,
	64
}
local var_0_5 = {
	20,
	10
}
local var_0_6 = 100
local var_0_7 = 0
local var_0_8 = 0
local var_0_9 = {
	50,
	0
}
local var_0_10 = {
	use_shadow = true,
	upper_case = true,
	localize = true,
	font_size = 42,
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
	word_wrap = true,
	upper_case = false,
	localize = true,
	use_shadow = true,
	font_size = 22,
	horizontal_alignment = "center",
	vertical_alignment = "top",
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
	font_size = 28,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_13 = {
	use_shadow = true,
	upper_case = true,
	localize = true,
	font_size = 28,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		80,
		15,
		2
	},
	area_size = {
		326,
		135
	}
}
local var_0_14 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_15 = {
	font_size = 22,
	upper_case = true,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_16 = {
	font_size = 35,
	upper_case = true,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		-50,
		2
	}
}

local function var_0_17(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or 255

	local var_1_0 = UIFrameSettings.frame_outer_fade_02
	local var_1_1 = var_1_0.texture_sizes.horizontal[2]
	local var_1_2 = var_0_3[arg_1_0].size
	local var_1_3 = {
		var_1_2[1] + var_1_1 * 2,
		var_1_2[2] + var_1_1 * 2
	}
	local var_1_4 = {
		var_1_3[1],
		var_1_3[2]
	}
	local var_1_5 = {
		-var_1_1,
		-var_1_1,
		0
	}
	local var_1_6 = {
		var_1_5[1] + 1,
		var_1_5[2]
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					style_id = "rect",
					pass_type = "rect",
					retained_mode = false
				}
			}
		},
		content = {
			frame = var_1_0.texture
		},
		style = {
			frame = {
				color = Colors.get_color_table_with_alpha("black", arg_1_1),
				size = var_1_4,
				texture_size = var_1_0.texture_size,
				texture_sizes = var_1_0.texture_sizes,
				offset = var_1_6
			},
			rect = {
				color = Colors.get_color_table_with_alpha("black", arg_1_1),
				offset = {
					0,
					0,
					0
				}
			}
		},
		scenegraph_id = arg_1_0
	}
end

local var_0_18 = {
	offset = {
		10,
		-30,
		0
	},
	texture_size = {
		20,
		20
	}
}

local function var_0_19(arg_2_0)
	local var_2_0 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		dynamic_font_size = true,
		font_size = 24,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			10,
			0,
			0
		},
		size = {
			180,
			24
		}
	}
	local var_2_1 = table.clone(var_2_0)

	var_2_1.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_2_1.offset = {
		var_2_0.offset[1] + 2,
		var_2_0.offset[2] - 2,
		var_2_0.offset[3] - 1
	}

	local var_2_2 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		dynamic_font_size = true,
		font_size = 26,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			var_0_18.offset[1] + var_0_18.texture_size[1] + 5,
			var_0_18.offset[2] - 1,
			var_0_18.offset[3]
		},
		size = {
			100,
			20
		}
	}
	local var_2_3 = table.clone(var_2_2)

	var_2_3.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_2_3.offset = {
		var_2_2.offset[1] + 2,
		var_2_2.offset[2] - 2,
		var_2_2.offset[3] - 1
	}

	return {
		element = {
			passes = {
				{
					style_id = "name_text",
					pass_type = "text",
					text_id = "name_text",
					content_check_function = function(arg_3_0)
						return arg_3_0.visible
					end
				},
				{
					style_id = "name_text_shadow",
					pass_type = "text",
					text_id = "name_text",
					content_check_function = function(arg_4_0)
						return arg_4_0.visible
					end
				},
				{
					style_id = "coins_text",
					pass_type = "text",
					text_id = "coins_text",
					content_check_function = function(arg_5_0)
						return arg_5_0.visible
					end
				},
				{
					style_id = "coins_text_shadow",
					pass_type = "text",
					text_id = "coins_text",
					content_check_function = function(arg_6_0)
						return arg_6_0.visible
					end
				},
				{
					pass_type = "texture",
					style_id = "coins_icon",
					texture_id = "coins_icon",
					content_check_function = function(arg_7_0)
						return arg_7_0.visible
					end
				}
			}
		},
		content = {
			visible = true,
			coins_text = "0",
			name_text = "",
			coins_icon = "deus_icons_coin"
		},
		style = {
			name_text = var_2_0,
			name_text_shadow = var_2_1,
			coins_text = var_2_2,
			coins_text_shadow = var_2_3,
			coins_icon = var_0_18
		},
		scenegraph_id = arg_2_0
	}
end

local function var_0_20(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = {
		255,
		255,
		255,
		255
	}
	local var_8_1 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		masked = arg_8_2,
		color = {
			255,
			138,
			172,
			235
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
	}
	local var_8_2 = table.clone(var_8_1)

	var_8_2.color = {
		255,
		80,
		80,
		80
	}

	local var_8_3 = {
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
		font_type = arg_8_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			100,
			arg_8_1[2] - 70,
			3
		},
		size = {
			arg_8_1[1] - 260,
			30
		}
	}
	local var_8_4 = table.clone(var_8_3)

	var_8_4.text_color = {
		255,
		100,
		100,
		100
	}

	local var_8_5 = table.clone(var_8_3)

	var_8_5.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_8_5.offset = {
		var_8_3.offset[1] + 2,
		var_8_3.offset[2] - 2,
		var_8_3.offset[3] - 1
	}

	local var_8_6 = {
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
		font_type = arg_8_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			325,
			arg_8_1[2] - 70,
			3
		},
		size = {
			100,
			30
		}
	}
	local var_8_7 = table.clone(var_8_6)

	var_8_7.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_8_7.offset = {
		var_8_6.offset[1] + 2,
		var_8_6.offset[2] - 2,
		var_8_6.offset[3] - 1
	}

	local var_8_8 = {
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
		font_type = arg_8_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			100,
			arg_8_1[2] - 167,
			3
		},
		size = {
			arg_8_1[1] - 160,
			90
		}
	}
	local var_8_9 = table.clone(var_8_8)

	var_8_9.text_color = {
		255,
		80,
		80,
		80
	}

	local var_8_10 = table.clone(var_8_8)

	var_8_10.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_8_10.offset = {
		var_8_8.offset[1] + 2,
		var_8_8.offset[2] - 2,
		var_8_8.offset[3] - 1
	}

	local var_8_11 = {
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
		font_type = arg_8_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			-66,
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
	local var_8_12 = table.clone(var_8_11)

	var_8_12.text_color = Colors.get_color_table_with_alpha("red", 255)

	local var_8_13 = table.clone(var_8_11)

	var_8_13.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_8_13.offset = {
		var_8_11.offset[1] + 2,
		var_8_11.offset[2] - 2,
		var_8_11.offset[3] - 1
	}

	local var_8_14 = {
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
		font_type = arg_8_2 and "hell_shark_masked" or "hell_shark",
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
	local var_8_15 = table.clone(var_8_14)

	var_8_15.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_8_15.offset = {
		var_8_14.offset[1] + 2,
		var_8_14.offset[2] - 2,
		var_8_14.offset[3] - 1
	}

	local var_8_16 = {
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
		font_type = arg_8_2 and "hell_shark_masked" or "hell_shark",
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
	local var_8_17 = table.clone(var_8_16)

	var_8_17.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_8_17.offset = {
		var_8_16.offset[1] + 2,
		var_8_16.offset[2] - 2,
		var_8_16.offset[3] - 1
	}

	local var_8_18 = table.clone(var_8_14)

	var_8_18.offset[2] = 15

	local var_8_19 = table.clone(var_8_18)

	var_8_19.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_8_19.offset = {
		var_8_18.offset[1] + 2,
		var_8_18.offset[2] - 2,
		var_8_18.offset[3] - 1
	}

	local var_8_20 = table.clone(var_8_16)

	var_8_20.offset[2] = 15
	var_8_20.text_color = Colors.get_color_table_with_alpha("font_title", 255)

	local var_8_21 = table.clone(var_8_20)

	var_8_21.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_8_21.offset = {
		var_8_20.offset[1] + 2,
		var_8_20.offset[2] - 2,
		var_8_20.offset[3] - 1
	}

	local var_8_22 = {
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
			style_id = "loading_frame",
			texture_id = "loading_frame",
			content_check_function = function(arg_9_0)
				return not arg_9_0.is_bought and not arg_9_0.button_hotspot.disable_button
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_discount_frame",
			texture_id = "icon_discount_frame",
			content_check_function = function(arg_10_0)
				return arg_10_0.has_discount
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
			content_check_function = function(arg_11_0)
				return arg_11_0.is_bought or not arg_11_0.button_hotspot.disable_button
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_disabled",
			texture_id = "icon",
			content_check_function = function(arg_12_0)
				return arg_12_0.button_hotspot.disable_button and not arg_12_0.is_bought
			end
		},
		{
			style_id = "sub_text_disabled",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function(arg_13_0)
				return arg_13_0.button_hotspot.disable_button and not arg_13_0.is_bought
			end
		},
		{
			style_id = "sub_text",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function(arg_14_0)
				return arg_14_0.is_bought or not arg_14_0.button_hotspot.disable_button
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
			content_check_function = function(arg_15_0)
				return arg_15_0.button_hotspot.disable_button and not arg_15_0.is_bought
			end
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function(arg_16_0)
				return arg_16_0.is_bought or not arg_16_0.button_hotspot.disable_button
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
			content_check_function = function(arg_17_0)
				return not arg_17_0.button_hotspot.disable_button and not arg_17_0.is_bought
			end
		},
		{
			style_id = "price_text_disabled",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function(arg_18_0)
				return arg_18_0.button_hotspot.disable_button and not arg_18_0.is_bought
			end
		},
		{
			style_id = "price_text_shadow",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function(arg_19_0)
				return not arg_19_0.is_bought
			end
		},
		{
			pass_type = "texture",
			style_id = "price_icon",
			texture_id = "price_icon",
			content_check_function = function(arg_20_0)
				return not arg_20_0.is_bought
			end
		},
		{
			style_id = "current_value_title_text",
			pass_type = "text",
			text_id = "current_value_title_text",
			content_check_function = function(arg_21_0)
				return not arg_21_0.is_bought and arg_21_0.current_value_text and arg_21_0.max_value_text
			end
		},
		{
			style_id = "current_value_title_text_shadow",
			pass_type = "text",
			text_id = "current_value_title_text",
			content_check_function = function(arg_22_0)
				return not arg_22_0.is_bought and arg_22_0.current_value_text and arg_22_0.max_value_text
			end
		},
		{
			style_id = "current_value_text",
			pass_type = "text",
			text_id = "current_value_text",
			content_check_function = function(arg_23_0)
				return not arg_23_0.is_bought and arg_23_0.current_value_text and arg_23_0.max_value_text
			end
		},
		{
			style_id = "current_value_text_shadow",
			pass_type = "text",
			text_id = "current_value_text",
			content_check_function = function(arg_24_0)
				return not arg_24_0.is_bought and arg_24_0.current_value_text and arg_24_0.max_value_text
			end
		},
		{
			style_id = "max_value_title_text",
			pass_type = "text",
			text_id = "max_value_title_text",
			content_check_function = function(arg_25_0)
				return not arg_25_0.is_bought and arg_25_0.current_value_text and arg_25_0.max_value_text
			end
		},
		{
			style_id = "max_value_title_text_shadow",
			pass_type = "text",
			text_id = "max_value_title_text",
			content_check_function = function(arg_26_0)
				return not arg_26_0.is_bought and arg_26_0.current_value_text and arg_26_0.max_value_text
			end
		},
		{
			style_id = "max_value_text",
			pass_type = "text",
			text_id = "max_value_text",
			content_check_function = function(arg_27_0)
				return not arg_27_0.is_bought and arg_27_0.current_value_text and arg_27_0.max_value_text
			end
		},
		{
			style_id = "max_value_text_shadow",
			pass_type = "text",
			text_id = "max_value_text",
			content_check_function = function(arg_28_0)
				return not arg_28_0.is_bought and arg_28_0.current_value_text and arg_28_0.max_value_text
			end
		},
		{
			style_id = "unlocked_text",
			pass_type = "text",
			text_id = "unlocked_text",
			content_check_function = function(arg_29_0)
				return arg_29_0.is_bought
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
			content_check_function = function(arg_30_0)
				return arg_30_0.is_part_of_set
			end
		}
	}
	local var_8_23 = {
		price_icon = "deus_icons_coin",
		icon_discount_frame = "menu_frame_12_gold",
		loading_frame = "deus_shop_square_gradient",
		icon_hover_frame = "frame_outer_glow_04",
		icon_background = "button_frame_01",
		is_bought = false,
		title_text = "",
		icon_bought_frame = "frame_outer_glow_04_big",
		icon = "icon_property_attack_speed",
		current_value_text = "10%",
		has_discount = false,
		set_progression = "%d/%d",
		sub_text = "",
		price_text = "0",
		rarity_text = "",
		max_value_text = "20%",
		has_buying_animation_played = false,
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
		size = arg_8_1,
		current_value_title_text = Localize("deus_shrine_current_value"),
		max_value_title_text = Localize("deus_shrine_max_value"),
		unlocked_text = Localize("deus_shrine_unlocked"),
		bought_glow_style_ids = {
			"icon_bought_frame"
		}
	}
	local var_8_24 = {
		icon_bought_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_8_2,
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
		loading_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_8_2,
			color = {
				0,
				255,
				152,
				15
			},
			offset = {
				-6,
				0,
				3
			},
			texture_size = {
				92,
				92
			}
		},
		icon_discount_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_8_2,
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
			masked = arg_8_2,
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
			masked = arg_8_2,
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
			},
			texture_size = {
				80,
				80
			}
		},
		icon = var_8_1,
		icon_disabled = var_8_2,
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_8_2,
			color = var_8_0,
			offset = {
				0,
				0,
				0
			},
			texture_size = arg_8_1
		},
		hover = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_8_2,
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
			texture_size = arg_8_1
		},
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_8_2,
			color = var_8_0,
			offset = {
				0,
				0,
				2
			},
			texture_size = arg_8_1
		},
		price_icon = {
			masked = arg_8_2,
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
		price_text = var_8_11,
		price_text_shadow = var_8_13,
		price_text_disabled = var_8_12,
		title_text_disabled = var_8_4,
		title_text = var_8_3,
		title_text_shadow = var_8_5,
		rarity_text = var_8_6,
		rarity_text_shadow = var_8_7,
		sub_text_disabled = var_8_9,
		sub_text = var_8_8,
		sub_text_shadow = var_8_10,
		current_value_title_text = var_8_14,
		current_value_title_text_shadow = var_8_15,
		current_value_text = var_8_16,
		current_value_text_shadow = var_8_17,
		max_value_title_text = var_8_18,
		max_value_title_text_shadow = var_8_19,
		max_value_text = var_8_20,
		max_value_text_shadow = var_8_21,
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
			font_type = arg_8_2 and "hell_shark_masked" or "hell_shark",
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
			font_size = 24,
			horizontal_alignment = "right",
			vertical_alignment = "bottom",
			font_type = "hell_shark",
			progression_colors = {
				incomplete = Colors.get_color_table_with_alpha("font_default", 255),
				complete = Colors.get_color_table_with_alpha("lime_green", 255)
			},
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				arg_8_1[1] - 66,
				30
			},
			offset = {
				0,
				18,
				5
			}
		}
	}

	return {
		element = {
			passes = var_8_22
		},
		content = var_8_23,
		style = var_8_24,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_8_0
	}
end

local function var_0_21(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = {
		255,
		255,
		255,
		255
	}
	local var_31_1 = {
		vertical_alignment = "center",
		horizontal_alignment = "right",
		masked = arg_31_2,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			-1,
			-1,
			4
		},
		texture_size = {
			90,
			90
		}
	}
	local var_31_2 = table.clone(var_31_1)

	var_31_2.color = {
		255,
		80,
		80,
		80
	}

	local var_31_3 = {
		font_size = 26,
		upper_case = true,
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
		font_type = arg_31_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			60,
			arg_31_1[2] - 58,
			3
		},
		size = {
			arg_31_1[1] - 160,
			40
		}
	}
	local var_31_4 = table.clone(var_31_3)

	var_31_4.text_color = {
		255,
		100,
		100,
		100
	}

	local var_31_5 = table.clone(var_31_3)

	var_31_5.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_31_5.offset = {
		var_31_3.offset[1] + 2,
		var_31_3.offset[2] - 2,
		var_31_3.offset[3] - 1
	}

	local var_31_6 = {
		font_size = 18,
		word_wrap = true,
		dynamic_font_size_word_wrap = true,
		horizontal_alignment = "right",
		vertical_alignment = "top",
		color = {
			150,
			0,
			255,
			0
		},
		font_type = arg_31_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			55,
			arg_31_1[2] - 173,
			3
		},
		size = {
			arg_31_1[1] - 155,
			120
		}
	}
	local var_31_7 = table.clone(var_31_6)

	var_31_7.text_color = {
		255,
		80,
		80,
		80
	}

	local var_31_8 = table.clone(var_31_6)

	var_31_8.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_31_8.offset = {
		var_31_6.offset[1] + 2,
		var_31_6.offset[2] - 2,
		var_31_6.offset[3] - 1
	}

	local var_31_9 = {
		font_size = 22,
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
		font_type = arg_31_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			arg_31_1[1] + 12,
			88,
			3
		},
		size = {
			55,
			20
		}
	}
	local var_31_10 = table.clone(var_31_9)

	var_31_10.text_color = Colors.get_color_table_with_alpha("red", 255)

	local var_31_11 = table.clone(var_31_9)

	var_31_11.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_31_11.offset = {
		var_31_9.offset[1] + 2,
		var_31_9.offset[2] - 2,
		var_31_9.offset[3] - 1
	}

	local var_31_12 = {
		font_size = 18,
		upper_case = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		},
		font_type = arg_31_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			var_31_9.offset[1],
			var_31_9.offset[2] - 35,
			3
		},
		size = {
			80,
			30
		}
	}
	local var_31_13 = table.clone(var_31_12)

	var_31_13.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_31_13.offset = {
		var_31_12.offset[1] + 2,
		var_31_12.offset[2] - 2,
		var_31_12.offset[3] - 1
	}

	local var_31_14 = {
		font_size = 26,
		upper_case = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		},
		font_type = arg_31_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			arg_31_1[1] + 10,
			40,
			3
		},
		size = {
			100,
			26
		}
	}
	local var_31_15 = table.clone(var_31_14)

	var_31_15.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_31_15.offset = {
		var_31_14.offset[1] + 2,
		var_31_14.offset[2] - 2,
		var_31_14.offset[3] - 1
	}

	local var_31_16 = {
		font_size = 26,
		upper_case = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		},
		font_type = arg_31_2 and "hell_shark_masked" or "hell_shark",
		text_color = Colors.get_color_table_with_alpha("yellow", 255),
		offset = {
			arg_31_1[1] + 10,
			18,
			3
		},
		size = {
			200,
			26
		}
	}
	local var_31_17 = table.clone(var_31_16)

	var_31_17.text_color = Colors.get_color_table_with_alpha("black", 255)
	var_31_17.offset = {
		var_31_16.offset[1] + 2,
		var_31_16.offset[2] - 2,
		var_31_16.offset[3] - 1
	}

	local var_31_18 = {
		496,
		80,
		9
	}
	local var_31_19 = {
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
			style_id = "frame_glow",
			pass_type = "texture_uv",
			content_id = "frame_glow"
		},
		{
			pass_type = "texture",
			style_id = "icon_bought_frame",
			texture_id = "icon_bought_frame"
		},
		{
			pass_type = "texture",
			style_id = "loading_frame",
			texture_id = "loading_frame",
			content_check_function = function(arg_32_0)
				return not arg_32_0.is_bought and not arg_32_0.button_hotspot.disable_button
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
			content_check_function = function(arg_33_0)
				return arg_33_0.is_bought or not arg_33_0.button_hotspot.disable_button
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_disabled",
			texture_id = "icon",
			content_check_function = function(arg_34_0)
				return arg_34_0.button_hotspot.disable_button and not arg_34_0.is_bought
			end
		},
		{
			style_id = "sub_text_disabled",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function(arg_35_0)
				return arg_35_0.button_hotspot.disable_button and not arg_35_0.is_bought
			end
		},
		{
			style_id = "sub_text",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function(arg_36_0)
				return arg_36_0.is_bought or not arg_36_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "sub_text_shadow",
			pass_type = "text",
			text_id = "sub_text"
		},
		{
			style_id = "shared_text",
			pass_type = "text",
			text_id = "shared_text",
			content_check_function = function(arg_37_0)
				return not arg_37_0.is_bought
			end
		},
		{
			style_id = "shared_text_shadow",
			pass_type = "text",
			text_id = "shared_text",
			content_check_function = function(arg_38_0)
				return not arg_38_0.is_bought
			end
		},
		{
			style_id = "title_text_disabled",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function(arg_39_0)
				return arg_39_0.button_hotspot.disable_button and not arg_39_0.is_bought
			end
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function(arg_40_0)
				return arg_40_0.is_bought or not arg_40_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "price_text",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function(arg_41_0)
				return not arg_41_0.button_hotspot.disable_button and not arg_41_0.is_bought
			end
		},
		{
			style_id = "price_text_disabled",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function(arg_42_0)
				return arg_42_0.button_hotspot.disable_button and not arg_42_0.is_bought
			end
		},
		{
			style_id = "price_text_shadow",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function(arg_43_0)
				return not arg_43_0.is_bought
			end
		},
		{
			pass_type = "texture",
			style_id = "price_icon",
			texture_id = "price_icon",
			content_check_function = function(arg_44_0)
				return not arg_44_0.is_bought
			end
		},
		{
			style_id = "bought_by_text",
			pass_type = "text",
			text_id = "bought_by_text",
			content_check_function = function(arg_45_0)
				return arg_45_0.is_bought
			end
		},
		{
			style_id = "bought_by_text_shadow",
			pass_type = "text",
			text_id = "bought_by_text",
			content_check_function = function(arg_46_0)
				return arg_46_0.is_bought
			end
		},
		{
			style_id = "player_name_text",
			pass_type = "text",
			text_id = "player_name_text",
			content_check_function = function(arg_47_0)
				return arg_47_0.is_bought
			end
		},
		{
			style_id = "player_name_text_shadow",
			pass_type = "text",
			text_id = "player_name_text",
			content_check_function = function(arg_48_0)
				return arg_48_0.is_bought
			end
		},
		{
			pass_type = "texture",
			style_id = "character_portrait",
			texture_id = "character_portrait",
			content_check_function = function(arg_49_0)
				return arg_49_0.is_bought
			end
		},
		{
			style_id = "hover",
			pass_type = "texture_uv",
			content_id = "hover"
		}
	}
	local var_31_20 = {
		price_icon = "deus_icons_coin",
		loading_frame = "deus_shop_circular_gradient",
		icon_background = "button_round_bg",
		icon_hover_frame = "button_round_highlight",
		title_text = "",
		sub_text = "",
		icon_bought_frame = "button_round_bought",
		player_name_text = "",
		icon = "blessing_abundance_02",
		character_portrait = "unit_frame_portrait_default",
		price_text = "9001",
		is_bought = false,
		has_buying_animation_played = false,
		button_hotspot = {},
		background = {
			texture_id = "shrine_blessing_bg",
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
		hover = {
			texture_id = "shrine_blessing_bg_hover",
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
		frame = {
			texture_id = "shrine_blessing_frame",
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
		frame_glow = {
			texture_id = "athanor_entry_trait_glow",
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
		bought_glow_style_ids = {
			"icon_bought_frame",
			"frame_glow"
		},
		size = arg_31_1,
		shared_text = Localize("deus_blessing_shared"),
		bought_by_text = Localize("deus_shrine_buyer_title_text")
	}
	local var_31_21 = {
		icon_bought_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = arg_31_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				50,
				-3,
				2
			},
			texture_size = {
				190,
				190
			}
		},
		loading_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = arg_31_2,
			color = {
				0,
				255,
				152,
				15
			},
			offset = {
				9,
				0,
				3
			},
			texture_size = {
				110,
				110
			}
		},
		icon_hover_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = arg_31_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				3,
				0,
				2
			},
			texture_size = {
				98,
				98
			}
		},
		icon_background = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = arg_31_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-8,
				0,
				3
			},
			texture_size = {
				75,
				75
			}
		},
		icon = var_31_1,
		icon_disabled = var_31_2,
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_31_2,
			color = var_31_0,
			offset = {
				0,
				0,
				0
			},
			texture_size = arg_31_1
		},
		hover = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_31_2,
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
			texture_size = arg_31_1
		},
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_31_2,
			color = var_31_0,
			offset = {
				0,
				0,
				2
			},
			texture_size = arg_31_1
		},
		frame_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_31_2,
			color = var_31_0,
			offset = {
				22,
				0,
				2
			},
			texture_size = {
				54,
				165
			}
		},
		price_icon = {
			masked = arg_31_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_31_1[1] + 10,
				88,
				3
			},
			size = {
				20,
				20
			}
		},
		price_text = var_31_9,
		price_text_shadow = var_31_11,
		price_text_disabled = var_31_10,
		bought_by_text = var_31_14,
		bought_by_text_shadow = var_31_15,
		player_name_text = var_31_16,
		player_name_text_shadow = var_31_17,
		shared_text = var_31_12,
		shared_text_shadow = var_31_13,
		title_text_disabled = var_31_4,
		title_text = var_31_3,
		title_text_shadow = var_31_5,
		sub_text_disabled = var_31_7,
		sub_text = var_31_6,
		sub_text_shadow = var_31_8,
		character_portrait = {
			size = {
				86,
				108
			},
			offset = var_31_18,
			color = {
				255,
				255,
				255,
				255
			}
		}
	}

	return {
		element = {
			passes = var_31_19
		},
		content = var_31_20,
		style = var_31_21,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_31_0
	}
end

local function var_0_22(arg_50_0, arg_50_1)
	local var_50_0 = 40
	local var_50_1 = 25
	local var_50_2 = 45

	return {
		scenegraph_id = arg_50_0,
		offset = {
			10,
			0,
			20
		},
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "token_icon_1",
					texture_id = "token_icon_1",
					content_check_function = function(arg_51_0)
						return arg_51_0.token_icon_1
					end
				},
				{
					pass_type = "texture",
					style_id = "token_icon_2",
					texture_id = "token_icon_2",
					content_check_function = function(arg_52_0)
						return arg_52_0.token_icon_2
					end
				},
				{
					pass_type = "texture",
					style_id = "token_icon_3",
					texture_id = "token_icon_3",
					content_check_function = function(arg_53_0)
						return arg_53_0.token_icon_3
					end
				},
				{
					pass_type = "texture",
					style_id = "token_icon_4",
					texture_id = "token_icon_4",
					content_check_function = function(arg_54_0)
						return arg_54_0.token_icon_4
					end
				}
			}
		},
		content = {},
		style = {
			token_icon_1 = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				texture_size = {
					var_50_0,
					var_50_0
				},
				offset = {
					0,
					var_50_1,
					0
				}
			},
			token_icon_2 = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				texture_size = {
					var_50_0,
					var_50_0
				},
				offset = {
					0,
					-var_50_1,
					0
				}
			},
			token_icon_3 = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				texture_size = {
					var_50_0,
					var_50_0
				},
				offset = {
					-var_50_2,
					var_50_1,
					0
				}
			},
			token_icon_4 = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				texture_size = {
					var_50_0,
					var_50_0
				},
				offset = {
					-var_50_2,
					-var_50_1,
					0
				}
			}
		}
	}
end

local function var_0_23(arg_55_0)
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					retained_mode = false,
					content_check_function = function(arg_56_0)
						return arg_56_0.text
					end
				}
			}
		},
		content = {},
		style = {
			text = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				localize = false,
				font_size = 28,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					0,
					1
				}
			}
		},
		scenegraph_id = arg_55_0
	}
end

local var_0_24 = {
	130,
	215,
	150,
	0
}
local var_0_25 = {
	255,
	25,
	21,
	36
}
local var_0_26 = {
	255,
	159,
	154,
	210
}
local var_0_27 = {
	200,
	208,
	149,
	177
}
local var_0_28 = {
	200,
	94,
	67,
	101
}
local var_0_29 = {
	200,
	172,
	101,
	159
}
local var_0_30 = {
	130,
	250,
	212,
	251
}
local var_0_31 = {
	background_write_mask = UIWidgets.create_simple_texture("shrine_background_write_mask", "screen"),
	background_wheel_01 = UIWidgets.create_simple_rotated_texture("shrine_circle_background_01", 0, {
		94,
		94
	}, "background_wheel_01", nil, nil, var_0_26),
	background_wheel_02 = UIWidgets.create_simple_rotated_texture("shrine_circle_background_02", 0, {
		230.5,
		230.5
	}, "background_wheel_02", nil, nil, var_0_26),
	background_wheel_03 = UIWidgets.create_simple_rotated_texture("shrine_circle_background_03", 0, {
		537,
		537
	}, "background_wheel_03", nil, nil, var_0_26),
	bottom_glow_smoke_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, var_0_27),
	bottom_glow_smoke_2 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, var_0_28),
	bottom_glow_smoke_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_shortest", nil, nil, var_0_29),
	bottom_glow_embers_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, var_0_30, 1),
	bottom_glow_embers_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_3", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, var_0_30, 1),
	screen_background = UIWidgets.create_simple_rect("screen", {
		255,
		0,
		0,
		0
	}),
	window_background = UIWidgets.create_simple_rect("window", var_0_25),
	top_options_background = UIWidgets.create_simple_texture("athanor_decoration_headline", "top_options_background"),
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
	top_options_background_left = UIWidgets.create_simple_uv_texture("athanor_decoration_headline", {
		{
			0.609375,
			0
		},
		{
			0,
			1
		}
	}, "top_options_background_left", nil, nil, nil, nil, nil, var_0_3.top_options_background_left.size),
	options_background_edge_left = UIWidgets.create_simple_uv_texture("shrine_sidebar_background", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "options_background_edge_left"),
	options_background_left = UIWidgets.create_tiled_texture("options_background_left", "menu_frame_bg_01_mask2", {
		960,
		1080
	}, nil, true, {
		255,
		128,
		128,
		128
	}),
	options_background_mask_left = UIWidgets.create_simple_uv_texture("shrine_sidebar_write_mask2", {
		{
			1,
			0
		},
		{
			0.35,
			1
		}
	}, "options_background_mask_left"),
	power_up_mask = UIWidgets.create_simple_texture("mask_rect", "own_power_up_window"),
	options_background_bottom = UIWidgets.create_simple_uv_texture("athanor_decoration_headline", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_options_background"),
	bottom_text = UIWidgets.create_simple_text(nil, "bottom_text", nil, nil, var_0_14, nil, nil, true),
	ready_button = UIWidgets.create_default_button("ready_button", var_0_3.ready_button.size, nil, nil, nil, 26, nil, "button_detail_02", nil, nil),
	ready_button_tokens = var_0_22("ready_button", var_0_3.ready_button.size),
	coins_icon = UIWidgets.create_simple_texture("deus_icons_coin", "coins_icon"),
	coins_text = UIWidgets.create_simple_text("0", "coins_text", nil, nil, var_0_12),
	boons_text = UIWidgets.create_simple_text("menu_weave_forge_options_sub_title_properties_utility", "boons_text", nil, nil, var_0_13),
	screen_overlay = UIWidgets.create_simple_rect("blessing_root", {
		0,
		255,
		10,
		10
	}),
	hold_to_buy_text = UIWidgets.create_simple_text("hold_to_buy", "hold_to_buy_text", nil, nil, var_0_15),
	power_up_description = UIWidgets.create_power_up("power_up_description_root", var_0_3.power_up_description_root.size, true, var_0_2),
	blocker = UIWidgets.create_simple_rect("blocker", {
		255,
		0,
		0,
		0
	}),
	portrait_input_helper_text = UIWidgets.create_simple_text("menu_description_show_team", "input_helper_text", nil, nil, var_0_16),
	boon_input_helper_text = UIWidgets.create_simple_text("menu_description_show_boons", "input_helper_text", nil, nil, var_0_16)
}
local var_0_32 = {
	console_cursor = UIWidgets.create_console_cursor("console_cursor"),
	title_background = var_0_17("title_background", 80),
	shrine_title_text = UIWidgets.create_simple_text("deus_shrine", "shrine_title_text", nil, nil, var_0_10),
	shrine_sub_title_text = UIWidgets.create_simple_text("deus_shrine_description", "shrine_sub_title_text", nil, nil, var_0_11),
	timer_text = var_0_23("timer_text")
}
local var_0_33 = {}
local var_0_34 = {
	0,
	0
}
local var_0_35 = 300
local var_0_36 = {
	200,
	80
}
local var_0_37 = {
	70,
	80
}
local var_0_38 = 4
local var_0_39 = {
	0,
	-55,
	1
}
local var_0_40 = {
	50,
	20,
	0
}

for iter_0_0 = 1, var_0_38 do
	local var_0_41 = iter_0_0 - 1
	local var_0_42 = {
		var_0_36[1] + (var_0_35 + var_0_34[1]) * var_0_41,
		var_0_36[2],
		1
	}
	local var_0_43 = "player_portrait_" .. iter_0_0

	var_0_3[var_0_43] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		parent = "player_" .. iter_0_0,
		size = {
			0,
			0
		},
		position = var_0_39
	}
	var_0_33[var_0_43] = UIWidgets.create_deus_player_status_portrait(var_0_43, nil, "")

	local var_0_44 = "player_texts_" .. iter_0_0

	var_0_3[var_0_44] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		parent = "player_" .. iter_0_0,
		size = {
			0,
			0
		},
		position = var_0_40
	}
	var_0_33[var_0_44] = var_0_19(var_0_44)
end

local function var_0_45(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
	local var_57_0 = arg_57_3
	local var_57_1 = arg_57_0
	local var_57_2 = {
		element = {
			passes = {}
		},
		content = {},
		style = {}
	}
	local var_57_3 = UIPlayerPortraitFrameSettings[arg_57_1]
	local var_57_4 = {
		255,
		255,
		255,
		255
	}
	local var_57_5 = arg_57_4 or {
		0,
		0,
		0
	}

	var_57_2.content.frame_settings_name = arg_57_1
	var_57_2.content.is_bought = false

	for iter_57_0, iter_57_1 in ipairs(var_57_3) do
		local var_57_6 = "texture_" .. iter_57_0
		local var_57_7 = iter_57_1.texture or "icons_placeholder"
		local var_57_8

		if UIAtlasHelper.has_atlas_settings_by_texture_name(var_57_7) then
			var_57_8 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_57_7).size
		else
			var_57_8 = iter_57_1.size
		end

		local var_57_9

		var_57_9 = var_57_8 and table.clone(var_57_8) or {
			0,
			0
		}

		local var_57_10 = {}

		if iter_57_1.offset then
			var_57_10 = table.clone(iter_57_1.offset)
			var_57_10[1] = var_57_5[1] + (-(var_57_9[1] / 2) + var_57_10[1])
			var_57_10[2] = var_57_5[2] + 60 + var_57_10[2]
			var_57_10[3] = iter_57_1.layer or 0
		else
			var_57_10 = table.clone(var_57_5)
			var_57_10[1] = -(var_57_9[1] / 2) + var_57_10[1]
			var_57_10[2] = var_57_10[2]
			var_57_10[3] = iter_57_1.layer or 0
		end

		var_57_2.element.passes[#var_57_2.element.passes + 1] = {
			pass_type = "texture",
			texture_id = var_57_6,
			style_id = var_57_6,
			retained_mode = var_57_0,
			content_check_function = function(arg_58_0)
				return arg_58_0.is_bought
			end
		}
		var_57_2.content[var_57_6] = var_57_7
		var_57_2.style[var_57_6] = {
			color = iter_57_1.color or var_57_4,
			offset = var_57_10,
			size = var_57_9
		}
	end

	local var_57_11 = {
		86,
		108
	}

	var_57_11[1] = var_57_11[1]
	var_57_11[2] = var_57_11[2]

	local var_57_12 = {
		var_57_5[1] - 15,
		var_57_5[2],
		var_57_5[3] + 1
	}
	local var_57_13 = "level"

	var_57_2.element.passes[#var_57_2.element.passes + 1] = {
		pass_type = "text",
		text_id = var_57_13,
		style_id = var_57_13,
		retained_mode = var_57_0,
		content_check_function = function(arg_59_0)
			return arg_59_0.is_bought
		end
	}
	var_57_2.content[var_57_13] = arg_57_2
	var_57_2.style[var_57_13] = {
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = 12,
		horizontal_alignment = "center",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = var_57_12,
		size = {
			30,
			20
		}
	}
	var_57_2.scenegraph_id = var_57_1

	return var_57_2
end

local var_0_46 = {
	flash_icon = {
		{
			name = "flash_icon",
			start_progress = 0,
			end_progress = 1,
			init = function(arg_60_0, arg_60_1, arg_60_2, arg_60_3)
				arg_60_2.content.has_buying_animation_played = true
			end,
			update = function(arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
				local var_61_0 = arg_61_2.style
				local var_61_1 = 60 * math.sin(10 * Managers.time:time("ui"))

				var_61_0.icon.color[2] = 152 - var_61_1
				var_61_0.icon.color[3] = 152 - var_61_1
				var_61_0.icon.color[4] = 152 - var_61_1
			end,
			on_complete = function(arg_62_0, arg_62_1, arg_62_2, arg_62_3)
				local var_62_0 = arg_62_2.style

				var_62_0.icon.color[2] = 255
				var_62_0.icon.color[3] = 255
				var_62_0.icon.color[4] = 255
			end
		}
	},
	switch_to_portraits = {
		{
			name = "animate_out",
			start_progress = 0,
			end_progress = 0.2,
			init = function(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
				return
			end,
			update = function(arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4)
				local var_64_0 = math.easeOutCubic(arg_64_3)

				arg_64_4.options_background_mask_left_start_pos = arg_64_4.options_background_mask_left_start_pos or arg_64_0.options_background_mask_left.local_position[1]
				arg_64_4.options_background_left_start_pos = arg_64_4.options_background_left_start_pos or arg_64_0.options_background_left.local_position[1]
				arg_64_0.options_background_mask_left.local_position[1] = math.lerp(arg_64_0.options_background_mask_left.local_position[1], arg_64_1.options_background_mask_left.position[1] - 400, var_64_0)
				arg_64_0.options_background_left.local_position[1] = math.lerp(arg_64_0.options_background_left.local_position[1], arg_64_1.options_background_left.position[1] - 400, var_64_0)
				arg_64_0.own_power_up_anchor.local_position[1] = math.lerp(arg_64_0.own_power_up_anchor.local_position[1], arg_64_1.own_power_up_anchor.position[1] - 400, var_64_0)
				arg_64_0.scrollbar_anchor.local_position[1] = math.lerp(arg_64_0.scrollbar_anchor.local_position[1], arg_64_1.scrollbar_anchor.position[1] - 400, var_64_0)
			end,
			on_complete = function(arg_65_0, arg_65_1, arg_65_2, arg_65_3)
				arg_65_3.options_background_mask_left_start_pos = nil
				arg_65_3.options_background_left_start_pos = nil
			end
		},
		{
			name = "animate_in",
			start_progress = 0.1,
			end_progress = 0.3,
			init = function(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
				return
			end,
			update = function(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4)
				local var_67_0 = math.easeOutCubic(arg_67_3)

				for iter_67_0 = 2, 4 do
					local var_67_1 = "player_" .. iter_67_0

					arg_67_0[var_67_1].local_position[1] = math.lerp(arg_67_0[var_67_1].local_position[1], arg_67_1[var_67_1].position[1] + 400, var_67_0)
				end
			end,
			on_complete = function(arg_68_0, arg_68_1, arg_68_2, arg_68_3)
				return
			end
		}
	},
	switch_to_boons = {
		{
			name = "animate_out",
			start_progress = 0,
			end_progress = 0.2,
			init = function(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
				return
			end,
			update = function(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4)
				local var_70_0 = math.easeOutCubic(arg_70_3)

				for iter_70_0 = 2, 4 do
					local var_70_1 = "player_" .. iter_70_0

					arg_70_0[var_70_1].local_position[1] = math.lerp(arg_70_0[var_70_1].local_position[1], arg_70_1[var_70_1].position[1], var_70_0)
				end
			end,
			on_complete = function(arg_71_0, arg_71_1, arg_71_2, arg_71_3)
				return
			end
		},
		{
			name = "animate_in",
			start_progress = 0.1,
			end_progress = 0.3,
			init = function(arg_72_0, arg_72_1, arg_72_2, arg_72_3)
				return
			end,
			update = function(arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4)
				local var_73_0 = math.easeOutCubic(arg_73_3)

				arg_73_0.options_background_mask_left.local_position[1] = math.lerp(arg_73_0.options_background_mask_left.local_position[1], arg_73_1.options_background_mask_left.position[1], var_73_0)
				arg_73_0.options_background_left.local_position[1] = math.lerp(arg_73_0.options_background_left.local_position[1], arg_73_1.options_background_left.position[1], var_73_0)
				arg_73_0.own_power_up_anchor.local_position[1] = math.lerp(arg_73_0.own_power_up_anchor.local_position[1], arg_73_1.own_power_up_anchor.position[1], var_73_0)
				arg_73_0.scrollbar_anchor.local_position[1] = math.lerp(arg_73_0.scrollbar_anchor.local_position[1], arg_73_1.scrollbar_anchor.position[1], var_73_0)
			end,
			on_complete = function(arg_74_0, arg_74_1, arg_74_2, arg_74_3)
				return
			end
		}
	}
}
local var_0_47 = {
	interaction_started = false,
	purchase_duration = 0.4,
	interaction_ongoing = false,
	progress = 0,
	interaction_successful = false
}
local var_0_48 = {
	start = function(arg_75_0, arg_75_1)
		arg_75_0.done_time = arg_75_1 + arg_75_0.purchase_duration
		arg_75_0.interaction_started = true
		arg_75_0.interaction_successful = false
	end,
	update = function(arg_76_0, arg_76_1)
		local var_76_0 = math.max(arg_76_0.done_time - arg_76_1, 0)

		arg_76_0.progress = 1 - math.min(var_76_0 / arg_76_0.purchase_duration, 1)

		if arg_76_0.interaction_started and arg_76_0.done_time and arg_76_0.interaction_ongoing and var_76_0 <= 0 then
			arg_76_0.interaction_successful = true

			return true
		end

		return false
	end,
	successful = function(arg_77_0)
		if arg_77_0.interaction_successful then
			arg_77_0.done_time = nil
			arg_77_0.interaction_started = false
			arg_77_0.interaction_ongoing = false
		end
	end,
	abort = function(arg_78_0)
		arg_78_0.done_time = nil
		arg_78_0.interaction_started = false
		arg_78_0.interaction_ongoing = false
	end
}
local var_0_49 = {
	background_icon = "button_frame_01",
	width = var_0_4[1],
	icon_size = {
		35,
		35
	},
	icon_offset = {
		15.5,
		14,
		1
	},
	background_icon_size = {
		65,
		65
	},
	background_icon_offset = {
		0,
		0,
		-1
	}
}
local var_0_50 = {
	background_icon = "button_frame_01",
	width = var_0_4[1],
	icon_size = {
		58,
		58
	},
	icon_offset = {
		5,
		5,
		0
	},
	background_icon_size = {
		65,
		65
	},
	background_icon_offset = {
		0,
		0,
		1
	}
}

return {
	scenegraph_definition = var_0_3,
	widgets = var_0_31,
	top_widgets = var_0_32,
	player_widgets = var_0_33,
	create_blessing_portraits_frame = var_0_45,
	create_power_up_shop_item = var_0_20,
	create_blessing_shop_item = var_0_21,
	discount_text_color = Colors.get_color_table_with_alpha("yellow", 255),
	single_price_offset = {
		0,
		-22
	},
	interaction_data = var_0_47,
	purchase_interaction = var_0_48,
	animations_definitions = var_0_46,
	max_power_up_amount = var_0_6,
	round_power_up_widget_data = var_0_49,
	rectangular_power_up_widget_data = var_0_50,
	power_up_widget_size = var_0_4,
	power_up_widget_spacing = var_0_5,
	allow_boon_removal = var_0_2
}
