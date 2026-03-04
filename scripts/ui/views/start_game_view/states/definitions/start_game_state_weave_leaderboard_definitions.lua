-- chunkname: @scripts/ui/views/start_game_view/states/definitions/start_game_state_weave_leaderboard_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.size
local var_0_2 = var_0_0.spacing
local var_0_3 = "menu_frame_11"
local var_0_4 = UIFrameSettings[var_0_3].texture_sizes.vertical[1]
local var_0_5 = var_0_0.large_window_frame
local var_0_6 = UIFrameSettings[var_0_5].texture_sizes.vertical[1]
local var_0_7 = {
	var_0_1[1] * 3 + var_0_2 * 2 + var_0_6 * 2,
	var_0_1[2] + 80
}
local var_0_8 = {
	var_0_7[1] + 50,
	var_0_7[2]
}
local var_0_9 = 40
local var_0_10 = 10
local var_0_11 = {
	var_0_8[1] - var_0_4 * 2,
	var_0_8[2] - var_0_4 * 2
}
local var_0_12 = {
	var_0_11[1] - 100,
	var_0_11[2] - 280
}
local var_0_13 = {
	16,
	var_0_12[2]
}
local var_0_14 = {
	var_0_12[1] - 80,
	48
}
local var_0_15 = {
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
			0
		}
	},
	header = {
		vertical_alignment = "top",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			1920,
			50
		},
		position = {
			0,
			-20,
			100
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = var_0_8,
		position = {
			0,
			0,
			0
		}
	},
	window_background = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_8[1] - 5,
			var_0_8[2] - 5
		},
		position = {
			0,
			0,
			0
		}
	},
	window_background_mask = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_8[1] - 5,
			var_0_8[2] - 5
		},
		position = {
			0,
			0,
			1
		}
	},
	inner_window = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_7,
		position = {
			0,
			0,
			1
		}
	},
	exit_button = {
		vertical_alignment = "bottom",
		parent = "window",
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
		parent = "window",
		horizontal_alignment = "center",
		size = {
			658,
			60
		},
		position = {
			0,
			34,
			10
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
			2
		}
	},
	list_window = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = var_0_11,
		position = {
			var_0_4,
			0,
			1
		}
	},
	list_mask = {
		vertical_alignment = "bottom",
		parent = "list_window",
		horizontal_alignment = "center",
		size = var_0_12,
		position = {
			0,
			80,
			3
		}
	},
	list_scrollbar = {
		vertical_alignment = "bottom",
		parent = "list_mask",
		horizontal_alignment = "right",
		size = var_0_13,
		position = {
			-16,
			0,
			10
		}
	},
	list_scroll_root = {
		vertical_alignment = "top",
		parent = "list_mask",
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
	list_entry = {
		vertical_alignment = "top",
		parent = "list_scroll_root",
		horizontal_alignment = "left",
		size = var_0_14,
		position = {
			25,
			0,
			0
		}
	},
	setting_stepper_1 = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "center",
		size = {
			var_0_11[1] / 3,
			85
		},
		position = {
			var_0_11[1] / 5,
			-(var_0_9 + 13),
			4
		}
	},
	setting_stepper_2 = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "center",
		size = {
			var_0_11[1] / 3,
			85
		},
		position = {
			-var_0_11[1] / 5,
			-(var_0_9 + 13),
			4
		}
	},
	loading_icon = {
		vertical_alignment = "center",
		parent = "list_mask",
		horizontal_alignment = "center",
		size = {
			150,
			150
		},
		position = {
			0,
			0,
			19
		}
	},
	list_title_rank = {
		vertical_alignment = "top",
		parent = "list_mask",
		horizontal_alignment = "left",
		size = {
			90,
			40
		},
		position = {
			112,
			45,
			1
		}
	},
	list_title_name = {
		vertical_alignment = "center",
		parent = "list_title_rank",
		horizontal_alignment = "right",
		size = {
			430,
			40
		},
		position = {
			748,
			0,
			0
		}
	},
	list_title_weave = {
		vertical_alignment = "center",
		parent = "list_title_name",
		horizontal_alignment = "right",
		size = {
			144,
			40
		},
		position = {
			306,
			0,
			0
		}
	},
	list_title_score = {
		vertical_alignment = "center",
		parent = "list_title_weave",
		horizontal_alignment = "right",
		size = {
			290,
			40
		},
		position = {
			261,
			0,
			0
		}
	},
	option_tabs = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "center",
		size = {
			var_0_11[1],
			var_0_9
		},
		position = {
			0,
			0,
			1
		}
	},
	option_tabs_segments = {
		vertical_alignment = "bottom",
		parent = "option_tabs",
		horizontal_alignment = "center",
		size = {
			var_0_11[1],
			0
		},
		position = {
			0,
			5,
			1
		}
	},
	option_tabs_segments_top = {
		vertical_alignment = "top",
		parent = "option_tabs",
		horizontal_alignment = "center",
		size = {
			var_0_11[1],
			0
		},
		position = {
			0,
			-7,
			10
		}
	},
	option_tabs_segments_bottom = {
		vertical_alignment = "bottom",
		parent = "option_tabs",
		horizontal_alignment = "center",
		size = {
			var_0_11[1],
			0
		},
		position = {
			0,
			3,
			10
		}
	},
	option_tabs_divider = {
		vertical_alignment = "bottom",
		parent = "option_tabs",
		horizontal_alignment = "center",
		size = {
			var_0_11[1] + 6,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	refresh_button = {
		vertical_alignment = "bottom",
		parent = "list_mask",
		horizontal_alignment = "left",
		size = {
			30,
			30
		},
		position = {
			0,
			-50,
			3
		}
	},
	refresh_text = {
		vertical_alignment = "center",
		parent = "refresh_button",
		horizontal_alignment = "left",
		size = {
			var_0_11[1] - 40,
			30
		},
		position = {
			40,
			0,
			1
		}
	},
	no_placement_text = {
		vertical_alignment = "center",
		parent = "inner_window",
		horizontal_alignment = "center",
		size = {
			1280,
			100
		},
		position = {
			8,
			0,
			10
		}
	}
}

if not IS_WINDOWS then
	var_0_15.setting_stepper_1 = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "center",
		size = {
			var_0_11[1] / 3.5,
			85
		},
		position = {
			var_0_11[1] / 3,
			-(var_0_9 + 13),
			4
		}
	}
	var_0_15.setting_stepper_2 = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "center",
		size = {
			var_0_11[1] / 3.5,
			85
		},
		position = {
			0,
			-(var_0_9 + 13),
			4
		}
	}
	var_0_15.setting_stepper_3 = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "center",
		size = {
			var_0_11[1] / 3.5,
			85
		},
		position = {
			-var_0_11[1] / 3,
			-(var_0_9 + 13),
			4
		}
	}
end

local var_0_16 = {
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
local var_0_17 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_18 = {
	use_shadow = true,
	upper_case = false,
	localize = false,
	font_size = 18,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_19 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 52,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}

local function var_0_20(arg_1_0, arg_1_1, arg_1_2)
	arg_1_2 = arg_1_2 or 20

	local var_1_0 = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_texture"
			},
			{
				pass_type = "texture",
				style_id = "mask_top",
				texture_id = "mask_edge"
			},
			{
				pass_type = "rotated_texture",
				style_id = "mask_bottom",
				texture_id = "mask_edge"
			}
		}
	}
	local var_1_1 = {
		mask_texture = "mask_rect",
		mask_edge = "mask_rect_edge_fade",
		hotspot = {
			allow_multi_hover = true
		}
	}
	local var_1_2 = {
		mask = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				arg_1_1[1],
				arg_1_1[2] - arg_1_2 * 2
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
		mask_top = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				arg_1_1[1],
				arg_1_2
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
		mask_bottom = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				arg_1_1[1],
				arg_1_2
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
			},
			angle = math.pi,
			pivot = {
				arg_1_1[1] / 2,
				arg_1_2 / 2
			}
		}
	}

	return {
		element = var_1_0,
		content = var_1_1,
		style = var_1_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local function var_0_21(arg_2_0, arg_2_1)
	local var_2_0 = {
		17,
		27
	}
	local var_2_1 = {
		30,
		40
	}
	local var_2_2 = {
		0,
		0,
		0
	}
	local var_2_3 = {
		arg_2_1[1] - var_2_1[1],
		0,
		0
	}

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
					pass_type = "texture",
					style_id = "setting_background",
					texture_id = "setting_background"
				},
				{
					style_id = "setting_text",
					pass_type = "text",
					text_id = "setting_text"
				},
				{
					style_id = "setting_text_shadow",
					pass_type = "text",
					text_id = "setting_text"
				},
				{
					style_id = "button_hotspot_left",
					pass_type = "hotspot",
					content_id = "button_hotspot_left"
				},
				{
					texture_id = "texture_id",
					style_id = "left_arrow_icon",
					pass_type = "texture",
					content_id = "arrow_icon"
				},
				{
					style_id = "button_hotspot_right",
					pass_type = "hotspot",
					content_id = "button_hotspot_right"
				},
				{
					texture_id = "texture_id",
					style_id = "right_arrow_icon",
					pass_type = "texture_uv",
					content_id = "arrow_icon"
				}
			}
		},
		content = {
			title_text = "title_text",
			setting_background = "menu_subheader_bg",
			setting_text = "setting_text",
			arrow_icon = {
				texture_id = "settings_arrow_normal",
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
			button_hotspot_left = {},
			button_hotspot_right = {}
		},
		style = {
			setting_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					400,
					59
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-10,
					0
				}
			},
			title_text = {
				word_wrap = true,
				upper_case = true,
				font_size = 20,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					0,
					arg_2_1[2] - 50,
					4
				},
				size = {
					arg_2_1[1],
					59
				}
			},
			title_text_shadow = {
				word_wrap = true,
				upper_case = true,
				font_size = 20,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					arg_2_1[2] - 50 - 2,
					3
				},
				size = {
					arg_2_1[1],
					59
				}
			},
			setting_text = {
				word_wrap = true,
				font_size = 20,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_2_1[1] + 10,
					0,
					4
				},
				size = {
					arg_2_1[1] - (var_2_1[1] * 2 + 20),
					var_2_1[2]
				}
			},
			setting_text_shadow = {
				word_wrap = true,
				font_size = 20,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_2_1[1] + 10 + 2,
					-2,
					3
				},
				size = {
					arg_2_1[1] - (var_2_1[1] * 2 + 20),
					var_2_1[2]
				}
			},
			button_hotspot_left = {
				color = {
					150,
					30,
					30,
					30
				},
				size = var_2_1,
				offset = var_2_2
			},
			left_arrow_icon = {
				size = var_2_0,
				offset = {
					var_2_2[1] + (var_2_1[1] / 2 - var_2_0[1] / 2),
					var_2_2[2] + (var_2_1[2] / 2 - var_2_0[2] / 2),
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			button_hotspot_right = {
				size = var_2_1,
				offset = var_2_3
			},
			right_arrow_icon = {
				angle = math.degrees_to_radians(180),
				pivot = {
					14,
					17
				},
				size = var_2_0,
				offset = {
					var_2_3[1] + (var_2_1[1] / 2 - var_2_0[1] / 2),
					var_2_3[2] + (var_2_1[2] / 2 - var_2_0[2] / 2),
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_2_0
	}
end

local function var_0_22(arg_3_0, arg_3_1)
	return {
		element = {
			passes = {
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge_holder_right = "menu_frame_09_divider_right",
			edge_holder_left = "menu_frame_09_divider_left",
			bottom_edge = "menu_frame_09_divider"
		},
		style = {
			bottom_edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					5,
					0,
					6
				},
				size = {
					arg_3_1[1] - 10,
					5
				},
				texture_tiling_size = {
					arg_3_1[1] - 10,
					5
				}
			},
			edge_holder_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					3,
					-6,
					10
				},
				size = {
					9,
					17
				}
			},
			edge_holder_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_3_1[1] - 12,
					-6,
					10
				},
				size = {
					9,
					17
				}
			}
		},
		scenegraph_id = arg_3_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_23(arg_4_0, arg_4_1)
	local var_4_0 = UIFrameSettings.menu_frame_09
	local var_4_1 = {
		passes = {
			{
				style_id = "button",
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				pass_type = "rect",
				style_id = "button"
			},
			{
				pass_type = "texture_frame",
				style_id = "frame",
				texture_id = "frame"
			},
			{
				pass_type = "texture",
				style_id = "icon",
				texture_id = "icon",
				content_check_function = function(arg_5_0)
					return not arg_5_0.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "icon_hover",
				texture_id = "icon",
				content_check_function = function(arg_6_0)
					return arg_6_0.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "hover",
				texture_id = "hover",
				content_check_function = function(arg_7_0)
					return arg_7_0.button_hotspot.is_hover
				end
			}
		}
	}
	local var_4_2 = {
		icon = "leaderboard_icon_refresh",
		hover = "button_state_default_2",
		button_hotspot = {},
		frame = var_4_0.texture
	}
	local var_4_3 = {
		button = {
			color = Colors.get_color_table_with_alpha("black", 200),
			offset = {
				0,
				0,
				0
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				15,
				13
			},
			color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				0,
				0,
				3
			}
		},
		icon_hover = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				15,
				13
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				0,
				3
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
				2
			}
		},
		hover = {
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

	return {
		element = var_4_1,
		content = var_4_2,
		style = var_4_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_4_0
	}
end

local var_0_24 = true
local var_0_25 = {
	window = UIWidgets.create_frame("window", var_0_15.window.size, "menu_frame_11"),
	window_background = UIWidgets.create_tiled_texture("window_background", "quests_background", {
		50,
		156
	}, {
		0,
		0,
		-1
	}, nil, {
		255,
		200,
		200,
		200
	}),
	exit_button = UIWidgets.create_default_button("exit_button", var_0_15.exit_button.size, nil, nil, Localize("menu_close"), 24, nil, "button_detail_04", 34, var_0_24),
	title = UIWidgets.create_simple_texture("frame_title_bg", "title"),
	title_bg = UIWidgets.create_background("title_bg", var_0_15.title_bg.size, "menu_frame_bg_02"),
	title_text = UIWidgets.create_simple_text(Localize("menu_weave_leaderboard_title"), "title_text", nil, nil, var_0_16),
	option_tabs_divider = var_0_22("option_tabs_divider", var_0_15.option_tabs_divider.size),
	list_title_rank = UIWidgets.create_simple_text(Localize("menu_weave_leaderboard_title_rank"), "list_title_rank", nil, nil, var_0_17),
	list_title_name = UIWidgets.create_simple_text(not IS_XB1 and Localize("menu_weave_leaderboard_title_player_name") or Localize("menu_weave_leaderboard_title_gamertag"), "list_title_name", nil, nil, var_0_17),
	list_title_weave = UIWidgets.create_simple_text(Localize("menu_weave_leaderboard_title_weave_number"), "list_title_weave", nil, nil, var_0_17),
	list_title_score = UIWidgets.create_simple_text(Localize("menu_weave_leaderboard_title_weave_score"), "list_title_score", nil, nil, var_0_17),
	no_placement_text = UIWidgets.create_simple_text(Localize("menu_weave_leaderboard_no_placement_text"), "no_placement_text", nil, nil, var_0_19),
	refresh_button = var_0_23("refresh_button", var_0_15.refresh_button.size),
	refresh_text = UIWidgets.create_simple_text(Localize("menu_description_refresh"), "refresh_text", nil, nil, var_0_18),
	list_window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "list_window", nil, nil, nil, -1),
	list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "list_mask", var_0_15.list_scrollbar.size),
	list_mask = var_0_20("list_mask", var_0_15.list_mask.size, var_0_10),
	list_mask_window = UIWidgets.create_rect_with_outer_frame("list_mask", var_0_15.list_mask.size, "shadow_frame_02", nil, {
		100,
		0,
		0,
		0
	}, {
		255,
		0,
		0,
		0
	}),
	setting_stepper_1 = var_0_21("setting_stepper_1", var_0_15.setting_stepper_1.size),
	setting_stepper_2 = var_0_21("setting_stepper_2", var_0_15.setting_stepper_2.size),
	loading_icon = UIWidgets.create_leaderboard_loading_icon("loading_icon", {
		"list_mask"
	})
}

if not IS_WINDOWS then
	var_0_25.setting_stepper_3 = var_0_21("setting_stepper_3", var_0_15.setting_stepper_3.size)
end

local var_0_26 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				arg_8_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				local var_9_0 = math.easeOutCubic(arg_9_3)

				arg_9_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				arg_11_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				local var_12_0 = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		}
	}
}
local var_0_27 = {
	default = {
		{
			input_action = "special_1",
			priority = 3,
			description_text = "menu_description_refresh"
		},
		{
			input_action = "confirm",
			priority = 4,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 5,
			description_text = "input_description_close"
		}
	},
	open_profile = {
		actions = {
			{
				input_action = "refresh",
				priority = 1,
				description_text = "input_description_show_profile"
			}
		}
	}
}

return {
	widgets = var_0_25,
	scenegraph_definition = var_0_15,
	animation_definitions = var_0_26,
	console_cursor_definition = UIWidgets.create_console_cursor("console_cursor"),
	generic_input_actions = var_0_27
}
