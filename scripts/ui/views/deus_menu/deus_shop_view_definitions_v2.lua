-- chunkname: @scripts/ui/views/deus_menu/deus_shop_view_definitions_v2.lua

require("scripts/ui/views/deus_menu/ui_widgets_deus")

local tbl = {
	1920,
	1080
}
local num = 200
local flag = true
local tbl_2 = {
	root = {
		is_root = true,
		size = tbl,
		position = {
			0,
			0,
			UILayer.default
		}
	},
	screen = {
		scale = "fit",
		size = tbl,
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
		size = tbl,
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
		size = tbl,
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
		size = tbl,
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
			tbl[1],
			tbl[2]
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
			tbl[1],
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
			tbl[1],
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
			tbl[1],
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
			0.6666666666666666 * num,
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
			0.6666666666666666 * num,
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
			0.6666666666666666 * num,
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
			tbl[2]
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
			tbl[2]
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
			tbl[2]
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
			tbl[2]
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
			tbl[2]
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
			tbl[2]
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
			tbl[2]
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
			tbl[2]
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
			70 + num,
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
			0 + 0.6666666666666666 * num,
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
local tbl_3 = {
	64,
	64
}
local tbl_4 = {
	20,
	10
}
local num_2 = 100
local num_3 = 0
local num_4 = 0
local tbl_5 = {
	50,
	0
}
local tbl_6 = {
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
local tbl_7 = {
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
local tbl_8 = {
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
local tbl_9 = {
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
local tbl_10 = {
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
local tbl_11 = {
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
local tbl_12 = {
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

local function fn(arg_1_0, arg_1_1)
	-- function 1
	arg_1_1 = arg_1_1 or 255

	local frame_outer_fade_02 = UIFrameSettings.frame_outer_fade_02
	local var_1_1 = frame_outer_fade_02.texture_sizes.horizontal[2]
	local size = tbl_2[arg_1_0].size
	local tbl = {
		size[1] + var_1_1 * 2,
		size[2] + var_1_1 * 2
	}
	local tbl_3 = {
		tbl[1],
		tbl[2]
	}
	local tbl_4 = {
		-var_1_1,
		-var_1_1,
		0
	}
	local tbl_5 = {
		tbl_4[1] + 1,
		tbl_4[2]
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
			frame = frame_outer_fade_02.texture
		},
		style = {
			frame = {
				color = Colors.get_color_table_with_alpha("black", arg_1_1),
				size = tbl_3,
				texture_size = frame_outer_fade_02.texture_size,
				texture_sizes = frame_outer_fade_02.texture_sizes,
				offset = tbl_5
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

local tbl_13 = {
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

local function fn_2(arg_2_0)
	-- function 2
	local tbl = {
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
	local clone = table.clone(tbl)

	clone.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone.offset = {
		tbl.offset[1] + 2,
		tbl.offset[2] - 2,
		tbl.offset[3] - 1
	}

	local tbl_2 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		dynamic_font_size = true,
		font_size = 26,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			tbl_13.offset[1] + tbl_13.texture_size[1] + 5,
			tbl_13.offset[2] - 1,
			tbl_13.offset[3]
		},
		size = {
			100,
			20
		}
	}
	local clone_2 = table.clone(tbl_2)

	clone_2.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_2.offset = {
		tbl_2.offset[1] + 2,
		tbl_2.offset[2] - 2,
		tbl_2.offset[3] - 1
	}

	return {
		element = {
			passes = {
				{
					style_id = "name_text",
					pass_type = "text",
					text_id = "name_text",
					content_check_function = function (self)
						-- function 3
						return self.visible
					end
				},
				{
					style_id = "name_text_shadow",
					pass_type = "text",
					text_id = "name_text",
					content_check_function = function (self)
						-- function 4
						return self.visible
					end
				},
				{
					style_id = "coins_text",
					pass_type = "text",
					text_id = "coins_text",
					content_check_function = function (self)
						-- function 5
						return self.visible
					end
				},
				{
					style_id = "coins_text_shadow",
					pass_type = "text",
					text_id = "coins_text",
					content_check_function = function (self)
						-- function 6
						return self.visible
					end
				},
				{
					pass_type = "texture",
					style_id = "coins_icon",
					texture_id = "coins_icon",
					content_check_function = function (self)
						-- function 7
						return self.visible
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
			name_text = tbl,
			name_text_shadow = clone,
			coins_text = tbl_2,
			coins_text_shadow = clone_2,
			coins_icon = tbl_13
		},
		scenegraph_id = arg_2_0
	}
end

local function fn_3(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local tbl = {
		255,
		255,
		255,
		255
	}
	local tbl_2 = {
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
	local clone = table.clone(tbl_2)

	clone.color = {
		255,
		80,
		80,
		80
	}

	local tbl_3 = {
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
		}
	}
	local flag

	flag = not arg_8_2 and "hell_shark_masked" and "hell_shark"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_3.offset = {
		100,
		arg_8_1[2] - 70,
		3
	}
	tbl_3.size = {
		arg_8_1[1] - 260,
		30
	}

	local clone_2 = table.clone(tbl_3)

	clone_2.text_color = {
		255,
		100,
		100,
		100
	}

	local clone_3 = table.clone(tbl_3)

	clone_3.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_3.offset = {
		tbl_3.offset[1] + 2,
		tbl_3.offset[2] - 2,
		tbl_3.offset[3] - 1
	}

	local tbl_4 = {
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
		}
	}
	local flag_2

	flag_2 = not arg_8_2 and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_4.offset = {
		325,
		arg_8_1[2] - 70,
		3
	}
	tbl_4.size = {
		100,
		30
	}

	local clone_4 = table.clone(tbl_4)

	clone_4.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_4.offset = {
		tbl_4.offset[1] + 2,
		tbl_4.offset[2] - 2,
		tbl_4.offset[3] - 1
	}

	local tbl_5 = {
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
		}
	}
	local flag_3

	flag_3 = not arg_8_2 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag_3
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_5.offset = {
		100,
		arg_8_1[2] - 167,
		3
	}
	tbl_5.size = {
		arg_8_1[1] - 160,
		90
	}

	local clone_5 = table.clone(tbl_5)

	clone_5.text_color = {
		255,
		80,
		80,
		80
	}

	local clone_6 = table.clone(tbl_5)

	clone_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_6.offset = {
		tbl_5.offset[1] + 2,
		tbl_5.offset[2] - 2,
		tbl_5.offset[3] - 1
	}

	local tbl_6 = {
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
		}
	}
	local flag_4

	flag_4 = not arg_8_2 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_4
	tbl_6.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_6.offset = {
		-66,
		70,
		3
	}
	tbl_6.size = {
		55,
		20
	}
	tbl_6.color_override = {}
	tbl_6.color_override_table = {
		start_index = 0,
		end_index = 0,
		color = {
			255,
			121,
			193,
			229
		}
	}

	local clone_7 = table.clone(tbl_6)

	clone_7.text_color = Colors.get_color_table_with_alpha("red", 255)

	local clone_8 = table.clone(tbl_6)

	clone_8.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_8.offset = {
		tbl_6.offset[1] + 2,
		tbl_6.offset[2] - 2,
		tbl_6.offset[3] - 1
	}

	local tbl_7 = {
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
		}
	}
	local flag_5

	flag_5 = not arg_8_2 and "hell_shark_masked" and "hell_shark"
	tbl_7.font_type = flag_5
	tbl_7.text_color = {
		255,
		150,
		150,
		150
	}
	tbl_7.offset = {
		-155,
		40,
		3
	}
	tbl_7.size = {
		80,
		20
	}

	local clone_9 = table.clone(tbl_7)

	clone_9.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_9.offset = {
		tbl_7.offset[1] + 2,
		tbl_7.offset[2] - 2,
		tbl_7.offset[3] - 1
	}

	local tbl_8 = {
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
		}
	}
	local flag_6

	flag_6 = not arg_8_2 and "hell_shark_masked" and "hell_shark"
	tbl_8.font_type = flag_6
	tbl_8.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_8.offset = {
		-60,
		40,
		3
	}
	tbl_8.size = {
		30,
		20
	}

	local clone_10 = table.clone(tbl_8)

	clone_10.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_10.offset = {
		tbl_8.offset[1] + 2,
		tbl_8.offset[2] - 2,
		tbl_8.offset[3] - 1
	}

	local clone_11 = table.clone(tbl_7)

	clone_11.offset[2] = 15

	local clone_12 = table.clone(clone_11)

	clone_12.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_12.offset = {
		clone_11.offset[1] + 2,
		clone_11.offset[2] - 2,
		clone_11.offset[3] - 1
	}

	local clone_13 = table.clone(tbl_8)

	clone_13.offset[2] = 15
	clone_13.text_color = Colors.get_color_table_with_alpha("font_title", 255)

	local clone_14 = table.clone(clone_13)

	clone_14.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_14.offset = {
		clone_13.offset[1] + 2,
		clone_13.offset[2] - 2,
		clone_13.offset[3] - 1
	}

	local tbl_9 = {
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
			content_check_function = function (self)
				-- function 9
				return not not self.is_bought or not self.button_hotspot.disable_button
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_discount_frame",
			texture_id = "icon_discount_frame",
			content_check_function = function (self)
				-- function 10
				return self.has_discount
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
			content_check_function = function (self)
				-- function 11
				local is_bought = self.is_bought

				is_bought = is_bought or not self.button_hotspot.disable_button

				return is_bought
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_disabled",
			texture_id = "icon",
			content_check_function = function (self)
				-- function 12
				local disable_button = self.button_hotspot.disable_button

				disable_button = not disable_button and not self.is_bought

				return disable_button
			end
		},
		{
			style_id = "sub_text_disabled",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function (self)
				-- function 13
				local disable_button = self.button_hotspot.disable_button

				disable_button = not disable_button and not self.is_bought

				return disable_button
			end
		},
		{
			style_id = "sub_text",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function (self)
				-- function 14
				local is_bought = self.is_bought

				is_bought = is_bought or not self.button_hotspot.disable_button

				return is_bought
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
			content_check_function = function (self)
				-- function 15
				local disable_button = self.button_hotspot.disable_button

				disable_button = not disable_button and not self.is_bought

				return disable_button
			end
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (self)
				-- function 16
				local is_bought = self.is_bought

				is_bought = is_bought or not self.button_hotspot.disable_button

				return is_bought
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
			content_check_function = function (self)
				-- function 17
				return not not self.button_hotspot.disable_button or not self.is_bought
			end
		},
		{
			style_id = "price_text_disabled",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (self)
				-- function 18
				local disable_button = self.button_hotspot.disable_button

				disable_button = not disable_button and not self.is_bought

				return disable_button
			end
		},
		{
			style_id = "price_text_shadow",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (self)
				-- function 19
				return not self.is_bought
			end
		},
		{
			pass_type = "texture",
			style_id = "price_icon",
			texture_id = "price_icon",
			content_check_function = function (self)
				-- function 20
				return not self.is_bought
			end
		},
		{
			style_id = "current_value_title_text",
			pass_type = "text",
			text_id = "current_value_title_text",
			content_check_function = function (self)
				-- function 21
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "current_value_title_text_shadow",
			pass_type = "text",
			text_id = "current_value_title_text",
			content_check_function = function (self)
				-- function 22
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "current_value_text",
			pass_type = "text",
			text_id = "current_value_text",
			content_check_function = function (self)
				-- function 23
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "current_value_text_shadow",
			pass_type = "text",
			text_id = "current_value_text",
			content_check_function = function (self)
				-- function 24
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "max_value_title_text",
			pass_type = "text",
			text_id = "max_value_title_text",
			content_check_function = function (self)
				-- function 25
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "max_value_title_text_shadow",
			pass_type = "text",
			text_id = "max_value_title_text",
			content_check_function = function (self)
				-- function 26
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "max_value_text",
			pass_type = "text",
			text_id = "max_value_text",
			content_check_function = function (self)
				-- function 27
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "max_value_text_shadow",
			pass_type = "text",
			text_id = "max_value_text",
			content_check_function = function (self)
				-- function 28
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "unlocked_text",
			pass_type = "text",
			text_id = "unlocked_text",
			content_check_function = function (self)
				-- function 29
				return self.is_bought
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
			content_check_function = function (self)
				-- function 30
				return self.is_part_of_set
			end
		}
	}
	local tbl_10 = {
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
	local tbl_11 = {
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
		icon = tbl_2,
		icon_disabled = clone,
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_8_2,
			color = tbl,
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
			color = tbl,
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
		price_text = tbl_6,
		price_text_shadow = clone_8,
		price_text_disabled = clone_7,
		title_text_disabled = clone_2,
		title_text = tbl_3,
		title_text_shadow = clone_3,
		rarity_text = tbl_4,
		rarity_text_shadow = clone_4,
		sub_text_disabled = clone_5,
		sub_text = tbl_5,
		sub_text_shadow = clone_6,
		current_value_title_text = tbl_7,
		current_value_title_text_shadow = clone_9,
		current_value_text = tbl_8,
		current_value_text_shadow = clone_10,
		max_value_title_text = clone_11,
		max_value_title_text_shadow = clone_12,
		max_value_text = clone_13,
		max_value_text_shadow = clone_14
	}
	local tbl_12 = {
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
		}
	}
	local flag_7

	flag_7 = not arg_8_2 and "hell_shark_masked" and "hell_shark"
	tbl_12.font_type = flag_7
	tbl_12.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_12.offset = {
		-130,
		40,
		3
	}
	tbl_12.size = {
		120,
		30
	}
	tbl_11.unlocked_text = tbl_12
	tbl_11.set_progression = {
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

	return {
		element = {
			passes = tbl_9
		},
		content = tbl_10,
		style = tbl_11,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_8_0
	}
end

local function fn_4(arg_31_0, arg_31_1, arg_31_2)
	-- function 31
	local tbl = {
		255,
		255,
		255,
		255
	}
	local tbl_2 = {
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
	local clone = table.clone(tbl_2)

	clone.color = {
		255,
		80,
		80,
		80
	}

	local tbl_3 = {
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
		}
	}
	local flag

	flag = not arg_31_2 and "hell_shark_masked" and "hell_shark"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_3.offset = {
		60,
		arg_31_1[2] - 58,
		3
	}
	tbl_3.size = {
		arg_31_1[1] - 160,
		40
	}

	local clone_2 = table.clone(tbl_3)

	clone_2.text_color = {
		255,
		100,
		100,
		100
	}

	local clone_3 = table.clone(tbl_3)

	clone_3.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_3.offset = {
		tbl_3.offset[1] + 2,
		tbl_3.offset[2] - 2,
		tbl_3.offset[3] - 1
	}

	local tbl_4 = {
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
		}
	}
	local flag_2

	flag_2 = not arg_31_2 and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_4.offset = {
		55,
		arg_31_1[2] - 173,
		3
	}
	tbl_4.size = {
		arg_31_1[1] - 155,
		120
	}

	local clone_4 = table.clone(tbl_4)

	clone_4.text_color = {
		255,
		80,
		80,
		80
	}

	local clone_5 = table.clone(tbl_4)

	clone_5.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_5.offset = {
		tbl_4.offset[1] + 2,
		tbl_4.offset[2] - 2,
		tbl_4.offset[3] - 1
	}

	local tbl_5 = {
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
		}
	}
	local flag_3

	flag_3 = not arg_31_2 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag_3
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_5.offset = {
		arg_31_1[1] + 12,
		88,
		3
	}
	tbl_5.size = {
		55,
		20
	}

	local clone_6 = table.clone(tbl_5)

	clone_6.text_color = Colors.get_color_table_with_alpha("red", 255)

	local clone_7 = table.clone(tbl_5)

	clone_7.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_7.offset = {
		tbl_5.offset[1] + 2,
		tbl_5.offset[2] - 2,
		tbl_5.offset[3] - 1
	}

	local tbl_6 = {
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
		}
	}
	local flag_4

	flag_4 = not arg_31_2 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_4
	tbl_6.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_6.offset = {
		tbl_5.offset[1],
		tbl_5.offset[2] - 35,
		3
	}
	tbl_6.size = {
		80,
		30
	}

	local clone_8 = table.clone(tbl_6)

	clone_8.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_8.offset = {
		tbl_6.offset[1] + 2,
		tbl_6.offset[2] - 2,
		tbl_6.offset[3] - 1
	}

	local tbl_7 = {
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
		}
	}
	local flag_5

	flag_5 = not arg_31_2 and "hell_shark_masked" and "hell_shark"
	tbl_7.font_type = flag_5
	tbl_7.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_7.offset = {
		arg_31_1[1] + 10,
		40,
		3
	}
	tbl_7.size = {
		100,
		26
	}

	local clone_9 = table.clone(tbl_7)

	clone_9.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_9.offset = {
		tbl_7.offset[1] + 2,
		tbl_7.offset[2] - 2,
		tbl_7.offset[3] - 1
	}

	local tbl_8 = {
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
		}
	}
	local flag_6

	flag_6 = not arg_31_2 and "hell_shark_masked" and "hell_shark"
	tbl_8.font_type = flag_6
	tbl_8.text_color = Colors.get_color_table_with_alpha("yellow", 255)
	tbl_8.offset = {
		arg_31_1[1] + 10,
		18,
		3
	}
	tbl_8.size = {
		200,
		26
	}

	local clone_10 = table.clone(tbl_8)

	clone_10.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_10.offset = {
		tbl_8.offset[1] + 2,
		tbl_8.offset[2] - 2,
		tbl_8.offset[3] - 1
	}

	local tbl_9 = {
		496,
		80,
		9
	}
	local tbl_10 = {
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
			content_check_function = function (self)
				-- function 32
				return not not self.is_bought or not self.button_hotspot.disable_button
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
			content_check_function = function (self)
				-- function 33
				local is_bought = self.is_bought

				is_bought = is_bought or not self.button_hotspot.disable_button

				return is_bought
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_disabled",
			texture_id = "icon",
			content_check_function = function (self)
				-- function 34
				local disable_button = self.button_hotspot.disable_button

				disable_button = not disable_button and not self.is_bought

				return disable_button
			end
		},
		{
			style_id = "sub_text_disabled",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function (self)
				-- function 35
				local disable_button = self.button_hotspot.disable_button

				disable_button = not disable_button and not self.is_bought

				return disable_button
			end
		},
		{
			style_id = "sub_text",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function (self)
				-- function 36
				local is_bought = self.is_bought

				is_bought = is_bought or not self.button_hotspot.disable_button

				return is_bought
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
			content_check_function = function (self)
				-- function 37
				return not self.is_bought
			end
		},
		{
			style_id = "shared_text_shadow",
			pass_type = "text",
			text_id = "shared_text",
			content_check_function = function (self)
				-- function 38
				return not self.is_bought
			end
		},
		{
			style_id = "title_text_disabled",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (self)
				-- function 39
				local disable_button = self.button_hotspot.disable_button

				disable_button = not disable_button and not self.is_bought

				return disable_button
			end
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (self)
				-- function 40
				local is_bought = self.is_bought

				is_bought = is_bought or not self.button_hotspot.disable_button

				return is_bought
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
			content_check_function = function (self)
				-- function 41
				return not not self.button_hotspot.disable_button or not self.is_bought
			end
		},
		{
			style_id = "price_text_disabled",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (self)
				-- function 42
				local disable_button = self.button_hotspot.disable_button

				disable_button = not disable_button and not self.is_bought

				return disable_button
			end
		},
		{
			style_id = "price_text_shadow",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (self)
				-- function 43
				return not self.is_bought
			end
		},
		{
			pass_type = "texture",
			style_id = "price_icon",
			texture_id = "price_icon",
			content_check_function = function (self)
				-- function 44
				return not self.is_bought
			end
		},
		{
			style_id = "bought_by_text",
			pass_type = "text",
			text_id = "bought_by_text",
			content_check_function = function (self)
				-- function 45
				return self.is_bought
			end
		},
		{
			style_id = "bought_by_text_shadow",
			pass_type = "text",
			text_id = "bought_by_text",
			content_check_function = function (self)
				-- function 46
				return self.is_bought
			end
		},
		{
			style_id = "player_name_text",
			pass_type = "text",
			text_id = "player_name_text",
			content_check_function = function (self)
				-- function 47
				return self.is_bought
			end
		},
		{
			style_id = "player_name_text_shadow",
			pass_type = "text",
			text_id = "player_name_text",
			content_check_function = function (self)
				-- function 48
				return self.is_bought
			end
		},
		{
			pass_type = "texture",
			style_id = "character_portrait",
			texture_id = "character_portrait",
			content_check_function = function (self)
				-- function 49
				return self.is_bought
			end
		},
		{
			style_id = "hover",
			pass_type = "texture_uv",
			content_id = "hover"
		}
	}
	local tbl_11 = {
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
	local tbl_12 = {
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
		icon = tbl_2,
		icon_disabled = clone,
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_31_2,
			color = tbl,
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
			color = tbl,
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
			color = tbl,
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
		price_text = tbl_5,
		price_text_shadow = clone_7,
		price_text_disabled = clone_6,
		bought_by_text = tbl_7,
		bought_by_text_shadow = clone_9,
		player_name_text = tbl_8,
		player_name_text_shadow = clone_10,
		shared_text = tbl_6,
		shared_text_shadow = clone_8,
		title_text_disabled = clone_2,
		title_text = tbl_3,
		title_text_shadow = clone_3,
		sub_text_disabled = clone_4,
		sub_text = tbl_4,
		sub_text_shadow = clone_5,
		character_portrait = {
			size = {
				86,
				108
			},
			offset = tbl_9,
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
			passes = tbl_10
		},
		content = tbl_11,
		style = tbl_12,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_31_0
	}
end

local function fn_5(arg_50_0, arg_50_1)
	-- function 50
	local num = 40
	local num_2 = 25
	local num_3 = 45

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
					content_check_function = function (self)
						-- function 51
						return self.token_icon_1
					end
				},
				{
					pass_type = "texture",
					style_id = "token_icon_2",
					texture_id = "token_icon_2",
					content_check_function = function (self)
						-- function 52
						return self.token_icon_2
					end
				},
				{
					pass_type = "texture",
					style_id = "token_icon_3",
					texture_id = "token_icon_3",
					content_check_function = function (self)
						-- function 53
						return self.token_icon_3
					end
				},
				{
					pass_type = "texture",
					style_id = "token_icon_4",
					texture_id = "token_icon_4",
					content_check_function = function (self)
						-- function 54
						return self.token_icon_4
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
					num,
					num
				},
				offset = {
					0,
					num_2,
					0
				}
			},
			token_icon_2 = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				texture_size = {
					num,
					num
				},
				offset = {
					0,
					-num_2,
					0
				}
			},
			token_icon_3 = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				texture_size = {
					num,
					num
				},
				offset = {
					-num_3,
					num_2,
					0
				}
			},
			token_icon_4 = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				texture_size = {
					num,
					num
				},
				offset = {
					-num_3,
					-num_2,
					0
				}
			}
		}
	}
end

local function fn_6(arg_55_0)
	-- function 55
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					retained_mode = false,
					content_check_function = function (self)
						-- function 56
						return self.text
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

local tbl_14 = {
	130,
	215,
	150,
	0
}
local tbl_15 = {
	255,
	25,
	21,
	36
}
local tbl_16 = {
	255,
	159,
	154,
	210
}
local tbl_17 = {
	200,
	208,
	149,
	177
}
local tbl_18 = {
	200,
	94,
	67,
	101
}
local tbl_19 = {
	200,
	172,
	101,
	159
}
local tbl_20 = {
	130,
	250,
	212,
	251
}
local tbl_21 = {
	background_write_mask = UIWidgets.create_simple_texture("shrine_background_write_mask", "screen"),
	background_wheel_01 = UIWidgets.create_simple_rotated_texture("shrine_circle_background_01", 0, {
		94,
		94
	}, "background_wheel_01", nil, nil, tbl_16),
	background_wheel_02 = UIWidgets.create_simple_rotated_texture("shrine_circle_background_02", 0, {
		230.5,
		230.5
	}, "background_wheel_02", nil, nil, tbl_16),
	background_wheel_03 = UIWidgets.create_simple_rotated_texture("shrine_circle_background_03", 0, {
		537,
		537
	}, "background_wheel_03", nil, nil, tbl_16),
	bottom_glow_smoke_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, tbl_17),
	bottom_glow_smoke_2 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, tbl_18),
	bottom_glow_smoke_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_shortest", nil, nil, tbl_19),
	bottom_glow_embers_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, tbl_20, 1),
	bottom_glow_embers_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_3", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, tbl_20, 1),
	screen_background = UIWidgets.create_simple_rect("screen", {
		255,
		0,
		0,
		0
	}),
	window_background = UIWidgets.create_simple_rect("window", tbl_15),
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
	}, "top_options_background_left", nil, nil, nil, nil, nil, tbl_2.top_options_background_left.size),
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
	bottom_text = UIWidgets.create_simple_text(nil, "bottom_text", nil, nil, tbl_10, nil, nil, true),
	ready_button = UIWidgets.create_default_button("ready_button", tbl_2.ready_button.size, nil, nil, nil, 26, nil, "button_detail_02", nil, nil),
	ready_button_tokens = fn_5("ready_button", tbl_2.ready_button.size),
	coins_icon = UIWidgets.create_simple_texture("deus_icons_coin", "coins_icon"),
	coins_text = UIWidgets.create_simple_text("0", "coins_text", nil, nil, tbl_8),
	boons_text = UIWidgets.create_simple_text("menu_weave_forge_options_sub_title_properties_utility", "boons_text", nil, nil, tbl_9),
	screen_overlay = UIWidgets.create_simple_rect("blessing_root", {
		0,
		255,
		10,
		10
	}),
	hold_to_buy_text = UIWidgets.create_simple_text("hold_to_buy", "hold_to_buy_text", nil, nil, tbl_11),
	power_up_description = UIWidgets.create_power_up("power_up_description_root", tbl_2.power_up_description_root.size, true, flag),
	blocker = UIWidgets.create_simple_rect("blocker", {
		255,
		0,
		0,
		0
	}),
	portrait_input_helper_text = UIWidgets.create_simple_text("menu_description_show_team", "input_helper_text", nil, nil, tbl_12),
	boon_input_helper_text = UIWidgets.create_simple_text("menu_description_show_boons", "input_helper_text", nil, nil, tbl_12)
}
local tbl_22 = {
	console_cursor = UIWidgets.create_console_cursor("console_cursor"),
	title_background = fn("title_background", 80),
	shrine_title_text = UIWidgets.create_simple_text("deus_shrine", "shrine_title_text", nil, nil, tbl_6),
	shrine_sub_title_text = UIWidgets.create_simple_text("deus_shrine_description", "shrine_sub_title_text", nil, nil, tbl_7),
	timer_text = fn_6("timer_text")
}
local tbl_23 = {}
local tbl_24 = {
	0,
	0
}
local num_5 = 300
local tbl_25 = {
	200,
	80
}
local tbl_26 = {
	70,
	80
}
local num_6 = 4
local tbl_27 = {
	0,
	-55,
	1
}
local tbl_28 = {
	50,
	20,
	0
}

for i = 1, num_6 do
	local num_7 = i - 1
	local tbl_29 = {
		tbl_25[1] + (num_5 + tbl_24[1]) * num_7,
		tbl_25[2],
		1
	}
	local str = "player_portrait_" .. i

	tbl_2[str] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		parent = "player_" .. i,
		size = {
			0,
			0
		},
		position = tbl_27
	}
	tbl_23[str] = UIWidgets.create_deus_player_status_portrait(str, nil, "")

	local str_2 = "player_texts_" .. i

	tbl_2[str_2] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		parent = "player_" .. i,
		size = {
			0,
			0
		},
		position = tbl_28
	}
	tbl_23[str_2] = fn_2(str_2)
end

local function fn_7(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
	-- function 57
	local var_57_0 = arg_57_3
	local var_57_1 = arg_57_0
	local tbl = {
		element = {
			passes = {}
		},
		content = {},
		style = {}
	}
	local var_57_3 = UIPlayerPortraitFrameSettings[arg_57_1]
	local tbl_2 = {
		255,
		255,
		255,
		255
	}
	local flag = arg_57_4 or {
		0,
		0,
		0
	}

	tbl.content.frame_settings_name = arg_57_1
	tbl.content.is_bought = false

	for i, v in ipairs(var_57_3) do
		local str = "texture_" .. i
		local texture = v.texture

		texture = texture or "icons_placeholder"

		local var_57_8

		if not UIAtlasHelper.has_atlas_settings_by_texture_name(texture) then
			var_57_8 = UIAtlasHelper.get_atlas_settings_by_texture_name(texture).size
		else
			var_57_8 = v.size
		end

		local flag_2

		flag_2 = not var_57_8 and table.clone(var_57_8) and {
			0,
			0
		}

		local tbl_3 = {}

		if not v.offset then
			tbl_3 = table.clone(v.offset)
			tbl_3[1] = flag[1] + (-(flag_2[1] / 2) + tbl_3[1])
			tbl_3[2] = flag[2] + 60 + tbl_3[2]

			local layer = v.layer

			layer = layer or 0
			tbl_3[3] = layer
		else
			tbl_3 = table.clone(flag)
			tbl_3[1] = -(flag_2[1] / 2) + tbl_3[1]
			tbl_3[2] = tbl_3[2]

			local layer_2 = v.layer

			layer_2 = layer_2 or 0
			tbl_3[3] = layer_2
		end

		tbl.element.passes[#tbl.element.passes + 1] = {
			pass_type = "texture",
			texture_id = str,
			style_id = str,
			retained_mode = var_57_0,
			content_check_function = function (self)
				-- function 58
				return self.is_bought
			end
		}
		tbl.content[str] = texture

		local style = tbl.style
		local tbl_4 = {}
		local color = v.color

		color = color or tbl_2
		tbl_4.color = color
		tbl_4.offset = tbl_3
		tbl_4.size = flag_2
		style[str] = tbl_4
	end

	local tbl_5 = {
		86,
		108
	}

	tbl_5[1] = tbl_5[1]
	tbl_5[2] = tbl_5[2]

	local tbl_6 = {
		flag[1] - 15,
		flag[2],
		flag[3] + 1
	}
	local str_2 = "level"

	tbl.element.passes[#tbl.element.passes + 1] = {
		pass_type = "text",
		text_id = str_2,
		style_id = str_2,
		retained_mode = var_57_0,
		content_check_function = function (self)
			-- function 59
			return self.is_bought
		end
	}
	tbl.content[str_2] = arg_57_2
	tbl.style[str_2] = {
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = 12,
		horizontal_alignment = "center",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = tbl_6,
		size = {
			30,
			20
		}
	}
	tbl.scenegraph_id = var_57_1

	return tbl
end

local tbl_30 = {
	flash_icon = {
		{
			name = "flash_icon",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
				-- function 60
				arg_60_2.content.has_buying_animation_played = true
			end,
			update = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4)
				-- function 61
				local style = arg_61_2.style
				local num = 60 * math.sin(10 * Managers.time:time("ui"))

				style.icon.color[2] = 152 - num
				style.icon.color[3] = 152 - num
				style.icon.color[4] = 152 - num
			end,
			on_complete = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
				-- function 62
				local style = arg_62_2.style

				style.icon.color[2] = 255
				style.icon.color[3] = 255
				style.icon.color[4] = 255
			end
		}
	},
	switch_to_portraits = {
		{
			name = "animate_out",
			start_progress = 0,
			end_progress = 0.2,
			init = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
				-- function 63
				return
			end,
			update = function (self, arg_64_1, arg_64_2, arg_64_3, arg_64_4)
				-- function 64
				local easeOutCubic = math.easeOutCubic(arg_64_3)
				local options_background_mask_left_start_pos = arg_64_4.options_background_mask_left_start_pos

				options_background_mask_left_start_pos = options_background_mask_left_start_pos or self.options_background_mask_left.local_position[1]
				arg_64_4.options_background_mask_left_start_pos = options_background_mask_left_start_pos

				local options_background_left_start_pos = arg_64_4.options_background_left_start_pos

				options_background_left_start_pos = options_background_left_start_pos or self.options_background_left.local_position[1]
				arg_64_4.options_background_left_start_pos = options_background_left_start_pos
				self.options_background_mask_left.local_position[1] = math.lerp(self.options_background_mask_left.local_position[1], arg_64_1.options_background_mask_left.position[1] - 400, easeOutCubic)
				self.options_background_left.local_position[1] = math.lerp(self.options_background_left.local_position[1], arg_64_1.options_background_left.position[1] - 400, easeOutCubic)
				self.own_power_up_anchor.local_position[1] = math.lerp(self.own_power_up_anchor.local_position[1], arg_64_1.own_power_up_anchor.position[1] - 400, easeOutCubic)
				self.scrollbar_anchor.local_position[1] = math.lerp(self.scrollbar_anchor.local_position[1], arg_64_1.scrollbar_anchor.position[1] - 400, easeOutCubic)
			end,
			on_complete = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
				-- function 65
				arg_65_3.options_background_mask_left_start_pos = nil
				arg_65_3.options_background_left_start_pos = nil
			end
		},
		{
			name = "animate_in",
			start_progress = 0.1,
			end_progress = 0.3,
			init = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
				-- function 66
				return
			end,
			update = function (self, arg_67_1, arg_67_2, arg_67_3, arg_67_4)
				-- function 67
				local easeOutCubic = math.easeOutCubic(arg_67_3)

				for i = 2, 4 do
					local str = "player_" .. i

					self[str].local_position[1] = math.lerp(self[str].local_position[1], arg_67_1[str].position[1] + 400, easeOutCubic)
				end
			end,
			on_complete = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3)
				-- function 68
				return
			end
		}
	},
	switch_to_boons = {
		{
			name = "animate_out",
			start_progress = 0,
			end_progress = 0.2,
			init = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3)
				-- function 69
				return
			end,
			update = function (self, arg_70_1, arg_70_2, arg_70_3, arg_70_4)
				-- function 70
				local easeOutCubic = math.easeOutCubic(arg_70_3)

				for i = 2, 4 do
					local str = "player_" .. i

					self[str].local_position[1] = math.lerp(self[str].local_position[1], arg_70_1[str].position[1], easeOutCubic)
				end
			end,
			on_complete = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
				-- function 71
				return
			end
		},
		{
			name = "animate_in",
			start_progress = 0.1,
			end_progress = 0.3,
			init = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3)
				-- function 72
				return
			end,
			update = function (self, arg_73_1, arg_73_2, arg_73_3, arg_73_4)
				-- function 73
				local easeOutCubic = math.easeOutCubic(arg_73_3)

				self.options_background_mask_left.local_position[1] = math.lerp(self.options_background_mask_left.local_position[1], arg_73_1.options_background_mask_left.position[1], easeOutCubic)
				self.options_background_left.local_position[1] = math.lerp(self.options_background_left.local_position[1], arg_73_1.options_background_left.position[1], easeOutCubic)
				self.own_power_up_anchor.local_position[1] = math.lerp(self.own_power_up_anchor.local_position[1], arg_73_1.own_power_up_anchor.position[1], easeOutCubic)
				self.scrollbar_anchor.local_position[1] = math.lerp(self.scrollbar_anchor.local_position[1], arg_73_1.scrollbar_anchor.position[1], easeOutCubic)
			end,
			on_complete = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3)
				-- function 74
				return
			end
		}
	}
}
local tbl_31 = {
	interaction_started = false,
	purchase_duration = 0.4,
	interaction_ongoing = false,
	progress = 0,
	interaction_successful = false
}
local tbl_32 = {
	start = function (self, arg_75_1)
		-- function 75
		self.done_time = arg_75_1 + self.purchase_duration
		self.interaction_started = true
		self.interaction_successful = false
	end,
	update = function (self, arg_76_1)
		-- function 76
		local max = math.max(self.done_time - arg_76_1, 0)

		self.progress = 1 - math.min(max / self.purchase_duration, 1)

		if not (not self.interaction_started and not self.done_time and not self.interaction_ongoing and not (max <= 0)) then
			self.interaction_successful = true

			return true
		end

		return false
	end,
	successful = function (self)
		-- function 77
		if not self.interaction_successful then
			self.done_time = nil
			self.interaction_started = false
			self.interaction_ongoing = false
		end
	end,
	abort = function (self)
		-- function 78
		self.done_time = nil
		self.interaction_started = false
		self.interaction_ongoing = false
	end
}
local tbl_33 = {
	background_icon = "button_frame_01",
	width = tbl_3[1],
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
local tbl_34 = {
	background_icon = "button_frame_01",
	width = tbl_3[1],
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
	scenegraph_definition = tbl_2,
	widgets = tbl_21,
	top_widgets = tbl_22,
	player_widgets = tbl_23,
	create_blessing_portraits_frame = fn_7,
	create_power_up_shop_item = fn_3,
	create_blessing_shop_item = fn_4,
	discount_text_color = Colors.get_color_table_with_alpha("yellow", 255),
	single_price_offset = {
		0,
		-22
	},
	interaction_data = tbl_31,
	purchase_interaction = tbl_32,
	animations_definitions = tbl_30,
	max_power_up_amount = num_2,
	round_power_up_widget_data = tbl_33,
	rectangular_power_up_widget_data = tbl_34,
	power_up_widget_size = tbl_3,
	power_up_widget_spacing = tbl_4,
	allow_boon_removal = flag
}
