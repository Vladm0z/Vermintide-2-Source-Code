-- chunkname: @scripts/ui/views/hero_view/states/definitions/hero_view_state_achievements_definitions.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/quest_widget_definition")
local var_0_1 = local_require("scripts/ui/views/hero_view/states/definitions/achievement_widget_definition")
local var_0_2 = UISettings.game_start_windows
local var_0_3 = var_0_2.frame
local var_0_4 = var_0_2.size
local var_0_5 = var_0_2.spacing
local var_0_6 = var_0_2.large_window_size
local var_0_7 = 200
local var_0_8 = var_0_6[2] - var_0_7 + 22
local var_0_9 = {
	math.floor((var_0_6[1] + 44) / 3),
	var_0_8
}
local var_0_10 = {
	var_0_6[1] + 22 - var_0_9[1],
	var_0_8
}
local var_0_11 = {
	900,
	156
}
local var_0_12 = {
	800,
	100
}
local var_0_13 = {
	var_0_10[1] - 22,
	var_0_10[2] - 104
}
local var_0_14 = {
	16,
	var_0_10[2] - 44
}
local var_0_15 = 4
local var_0_16 = 40
local var_0_17 = 20
local var_0_18 = {
	var_0_12[2] / 2,
	30
}
local var_0_19 = {
	var_0_9[1] - 22,
	var_0_9[2] - 48
}
local var_0_20 = {
	var_0_9[1] - 120,
	60
}
local var_0_21 = {
	var_0_20[1] - var_0_5 * 2,
	var_0_9[2] - var_0_20[2] - var_0_20[2]
}
local var_0_22 = {
	var_0_20[1] - var_0_5 * 2,
	42
}
local var_0_23 = 5
local var_0_24 = {
	tab_size = var_0_20,
	tab_active_size = var_0_21,
	tab_list_entry_size = var_0_22,
	tab_list_entry_spacing = var_0_23
}
local var_0_25 = 11
local var_0_26 = {
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
		size = var_0_6,
		position = {
			0,
			0,
			1
		}
	},
	window_background = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_6[1] - 5,
			var_0_6[2] - 5
		},
		position = {
			0,
			0,
			0
		}
	},
	claim_overlay_divider = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			314,
			33
		},
		position = {
			0,
			20,
			40
		}
	},
	window_top = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			var_0_6[1],
			var_0_7
		},
		position = {
			0,
			0,
			1
		}
	},
	window_top_fade = {
		vertical_alignment = "center",
		parent = "window_top",
		horizontal_alignment = "center",
		size = {
			var_0_6[1] - 44,
			var_0_7 - 44
		},
		position = {
			0,
			0,
			1
		}
	},
	left_window = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = var_0_9,
		position = {
			0,
			0,
			1
		}
	},
	left_window_fade = {
		vertical_alignment = "center",
		parent = "left_window",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 44,
			var_0_9[2] - 44
		},
		position = {
			0,
			0,
			1
		}
	},
	right_window = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = var_0_10,
		position = {
			0,
			0,
			1
		}
	},
	right_window_fade = {
		vertical_alignment = "center",
		parent = "right_window",
		horizontal_alignment = "center",
		size = {
			var_0_10[1] - 44,
			var_0_10[2] - 44
		},
		position = {
			0,
			0,
			1
		}
	},
	category_window = {
		vertical_alignment = "center",
		parent = "left_window",
		horizontal_alignment = "center",
		size = var_0_19,
		position = {
			0,
			0,
			1
		}
	},
	category_window_mask = {
		vertical_alignment = "center",
		parent = "category_window",
		horizontal_alignment = "center",
		size = {
			var_0_19[1],
			var_0_9[2] - 44
		},
		position = {
			0,
			0,
			0
		}
	},
	category_window_mask_top = {
		vertical_alignment = "top",
		parent = "category_window_mask",
		horizontal_alignment = "center",
		size = {
			var_0_19[1],
			30
		},
		position = {
			0,
			0,
			1
		}
	},
	category_window_mask_bottom = {
		vertical_alignment = "bottom",
		parent = "category_window_mask",
		horizontal_alignment = "center",
		size = {
			var_0_19[1],
			30
		},
		position = {
			0,
			0,
			1
		}
	},
	category_root = {
		vertical_alignment = "top",
		parent = "category_window",
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
	category_scrollbar = {
		vertical_alignment = "center",
		parent = "category_window",
		horizontal_alignment = "right",
		size = var_0_14,
		position = {
			-var_0_5,
			0,
			3
		}
	},
	search_input = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			850,
			42
		},
		position = {
			280,
			-174,
			50
		}
	},
	search_filters = {
		vertical_alignment = "bottom",
		parent = "search_input",
		horizontal_alignment = "center",
		size = {
			850,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	gamepad_search_filters = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			850,
			0
		},
		position = {
			0,
			300,
			100
		}
	},
	gamepad_background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			100
		}
	},
	achievement_window = {
		vertical_alignment = "center",
		parent = "right_window",
		horizontal_alignment = "center",
		size = var_0_13,
		position = {
			0,
			0,
			1
		}
	},
	achievement_window_mask = {
		vertical_alignment = "center",
		parent = "achievement_window",
		horizontal_alignment = "center",
		size = {
			var_0_13[1],
			var_0_10[2] - 44
		},
		position = {
			0,
			0,
			0
		}
	},
	achievement_window_mask_top = {
		vertical_alignment = "top",
		parent = "achievement_window_mask",
		horizontal_alignment = "center",
		size = {
			var_0_13[1],
			30
		},
		position = {
			0,
			0,
			1
		}
	},
	achievement_window_mask_bottom = {
		vertical_alignment = "bottom",
		parent = "achievement_window_mask",
		horizontal_alignment = "center",
		size = {
			var_0_13[1],
			30
		},
		position = {
			0,
			0,
			1
		}
	},
	achievement_root = {
		vertical_alignment = "top",
		parent = "achievement_window",
		horizontal_alignment = "center",
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
	achievement_entry = {
		vertical_alignment = "top",
		parent = "achievement_root",
		horizontal_alignment = "center",
		size = var_0_11,
		position = {
			0,
			0,
			3
		}
	},
	achievement_scrollbar = {
		vertical_alignment = "center",
		parent = "achievement_window",
		horizontal_alignment = "right",
		size = var_0_14,
		position = {
			-var_0_5,
			0,
			3
		}
	},
	quest_timer = {
		vertical_alignment = "bottom",
		parent = "achievement_window",
		horizontal_alignment = "left",
		size = {
			var_0_13[1] - 70,
			50
		},
		position = {
			0,
			-30,
			20
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
			42
		}
	},
	quests_button = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1] - 60,
			108
		},
		position = {
			-(var_0_4[1] + 30),
			-46,
			10
		}
	},
	summary_button = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1] - 160,
			70
		},
		position = {
			0,
			-65,
			10
		}
	},
	achievements_button = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1] - 60,
			108
		},
		position = {
			var_0_4[1] + 30,
			-46,
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
			46
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
	summary_center_window = {
		vertical_alignment = "center",
		parent = "left_window",
		horizontal_alignment = "left",
		size = {
			var_0_9[1] + 2,
			var_0_9[2]
		},
		position = {
			var_0_9[1] - 22,
			0,
			1
		}
	},
	summary_center_window_fade = {
		vertical_alignment = "center",
		parent = "summary_center_window",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 40,
			var_0_9[2] - 44
		},
		position = {
			0,
			0,
			1
		}
	},
	summary_center_text = {
		vertical_alignment = "center",
		parent = "summary_center_window",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 140,
			var_0_9[2] - 100
		},
		position = {
			0,
			-40,
			3
		}
	},
	summary_right_window = {
		vertical_alignment = "bottom",
		parent = "right_window",
		horizontal_alignment = "right",
		size = var_0_9,
		position = {
			0,
			0,
			1
		}
	},
	summary_right_window_fade = {
		vertical_alignment = "center",
		parent = "summary_right_window",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 44,
			var_0_9[2] - 44
		},
		position = {
			0,
			0,
			1
		}
	},
	summary_right_arrow = {
		vertical_alignment = "top",
		parent = "summary_right_window",
		horizontal_alignment = "center",
		size = {
			59,
			31
		},
		position = {
			0,
			18,
			22
		}
	},
	summary_right_title_divider = {
		vertical_alignment = "center",
		parent = "summary_right_window",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-20,
			3
		}
	},
	summary_right_title = {
		vertical_alignment = "top",
		parent = "summary_right_title_divider",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 44,
			20
		},
		position = {
			0,
			20,
			3
		}
	},
	summary_achievement_flag = {
		vertical_alignment = "top",
		parent = "summary_right_window_fade",
		horizontal_alignment = "center",
		size = {
			320,
			320
		},
		position = {
			0,
			0,
			1
		}
	},
	summary_achievement_bar_1 = {
		vertical_alignment = "center",
		parent = "summary_right_window",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 100,
			42
		},
		position = {
			0,
			-60,
			5
		}
	},
	summary_achievement_bar_2 = {
		vertical_alignment = "bottom",
		parent = "summary_achievement_bar_1",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 100,
			42
		},
		position = {
			0,
			-50,
			1
		}
	},
	summary_achievement_bar_3 = {
		vertical_alignment = "bottom",
		parent = "summary_achievement_bar_2",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 100,
			42
		},
		position = {
			0,
			-50,
			1
		}
	},
	summary_achievement_bar_4 = {
		vertical_alignment = "bottom",
		parent = "summary_achievement_bar_3",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 100,
			42
		},
		position = {
			0,
			-50,
			1
		}
	},
	summary_achievement_bar_5 = {
		vertical_alignment = "bottom",
		parent = "summary_achievement_bar_4",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 100,
			42
		},
		position = {
			0,
			-50,
			1
		}
	},
	summary_achievement_bar_6 = {
		vertical_alignment = "bottom",
		parent = "summary_achievement_bar_5",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 100,
			42
		},
		position = {
			0,
			-50,
			1
		}
	},
	summary_left_window = {
		vertical_alignment = "bottom",
		parent = "left_window",
		horizontal_alignment = "left",
		size = {
			var_0_9[1],
			var_0_9[2]
		},
		position = {
			0,
			0,
			0
		}
	},
	summary_left_window_fade = {
		vertical_alignment = "center",
		parent = "summary_left_window",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 42,
			var_0_9[2] - 44
		},
		position = {
			0,
			0,
			1
		}
	},
	summary_left_arrow = {
		vertical_alignment = "top",
		parent = "summary_left_window",
		horizontal_alignment = "center",
		size = {
			59,
			31
		},
		position = {
			0,
			18,
			22
		}
	},
	summary_left_title_divider = {
		vertical_alignment = "center",
		parent = "summary_left_window",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-20,
			45
		}
	},
	summary_left_title = {
		vertical_alignment = "top",
		parent = "summary_left_title_divider",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 44,
			20
		},
		position = {
			0,
			20,
			3
		}
	},
	summary_quest_book = {
		vertical_alignment = "center",
		parent = "summary_left_window",
		horizontal_alignment = "center",
		size = {
			256,
			256
		},
		position = {
			0,
			170,
			40
		}
	},
	summary_quest_bar_background_1 = {
		vertical_alignment = "center",
		parent = "summary_left_window",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 40,
			60
		},
		position = {
			0,
			-100,
			5
		}
	},
	summary_quest_bar_background_2 = {
		vertical_alignment = "center",
		parent = "summary_quest_bar_background_1",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 40,
			60
		},
		position = {
			0,
			-100,
			5
		}
	},
	summary_quest_bar_background_3 = {
		vertical_alignment = "center",
		parent = "summary_quest_bar_background_2",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 40,
			60
		},
		position = {
			0,
			-100,
			5
		}
	},
	summary_quest_bar_1 = {
		vertical_alignment = "center",
		parent = "summary_quest_bar_background_1",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 100,
			16
		},
		position = {
			0,
			0,
			5
		}
	},
	summary_quest_bar_2 = {
		vertical_alignment = "center",
		parent = "summary_quest_bar_background_2",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 100,
			16
		},
		position = {
			0,
			0,
			1
		}
	},
	summary_quest_bar_3 = {
		vertical_alignment = "center",
		parent = "summary_quest_bar_background_3",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 100,
			16
		},
		position = {
			0,
			0,
			1
		}
	},
	summary_quest_bar_title_1 = {
		vertical_alignment = "bottom",
		parent = "summary_quest_bar_1",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 100,
			16
		},
		position = {
			0,
			40,
			5
		}
	},
	summary_quest_bar_title_2 = {
		vertical_alignment = "bottom",
		parent = "summary_quest_bar_2",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 100,
			16
		},
		position = {
			0,
			40,
			5
		}
	},
	summary_quest_bar_title_3 = {
		vertical_alignment = "bottom",
		parent = "summary_quest_bar_3",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 100,
			16
		},
		position = {
			0,
			40,
			5
		}
	},
	summary_left_title_banner = {
		vertical_alignment = "bottom",
		parent = "summary_left_window",
		horizontal_alignment = "center",
		size = {
			438,
			54
		},
		position = {
			0,
			290,
			20
		}
	},
	claim_all_button_anchor = {
		vertical_alignment = "bottom",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			300,
			100
		},
		position = {
			var_0_13[1] / 2 - 300,
			100,
			5
		}
	}
}
local var_0_27 = {
	font_size = 28,
	upper_case = false,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_28 = {
	font_size = 24,
	upper_case = true,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_29 = {
	font_size = 24,
	upper_case = false,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "bottom",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_30 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 58,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		10
	}
}
local var_0_31 = {
	font_size = 26,
	upper_case = false,
	localize = false,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = {
		255,
		5,
		5,
		5
	},
	offset = {
		0,
		-50,
		2
	}
}
local var_0_32 = {
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
local var_0_33 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 28,
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

local function var_0_34(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = true
	local var_1_1 = "button_bg_01"
	local var_1_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_1)
	local var_1_3 = UIFrameSettings.button_frame_01
	local var_1_4 = var_1_3.texture_sizes.corner[1]
	local var_1_5 = "button_detail_02"
	local var_1_6 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_5).size
	local var_1_7 = "button_detail_03"
	local var_1_8 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_7).size
	local var_1_9 = {
		allow_multi_hover = true
	}
	local var_1_10 = {}

	for iter_1_0 = 1, var_0_25 do
		local var_1_11 = var_0_23

		var_1_9[iter_1_0] = {
			text = "n/a",
			glass = "button_glass_02",
			hover_glow = "button_state_default",
			new = false,
			background_fade = "button_bg_fade",
			rect_masked = "rect_masked",
			new_texture = "list_item_tag_new",
			icon = "tooltip_marker",
			button_hotspot = {},
			side_detail = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = var_1_7
			},
			frame = var_1_3.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_1_1[2] / var_1_2.size[2]
					},
					{
						arg_1_1[1] / var_1_2.size[1],
						1
					}
				},
				texture_id = var_1_1
			}
		}
		var_1_10[iter_1_0] = {
			list_member_offset = {
				0,
				-(var_0_22[2] + var_1_11),
				0
			},
			size = {
				var_0_22[1],
				var_0_22[2]
			},
			text = {
				vertical_alignment = "center",
				upper_case = true,
				font_size = 22,
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					40,
					0,
					14
				}
			},
			text_hover = {
				vertical_alignment = "center",
				upper_case = true,
				font_size = 22,
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					40,
					0,
					14
				}
			},
			text_selected = {
				vertical_alignment = "center",
				upper_case = true,
				font_size = 22,
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					40,
					0,
					14
				}
			},
			text_shadow = {
				vertical_alignment = "center",
				upper_case = true,
				font_size = 22,
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					42,
					-2,
					13
				}
			},
			rect = {
				masked = var_1_0,
				size = {
					var_0_22[1],
					var_0_22[2]
				},
				color = {
					100,
					100,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				masked = var_1_0,
				texture_size = {
					13,
					13
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					20,
					0,
					10
				}
			},
			side_detail_left = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-9,
					var_0_22[2] / 2 - var_1_8[2] / 2,
					9
				},
				size = var_1_8
			},
			side_detail_right = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_0_22[1] - var_1_8[1] + 9,
					var_0_22[2] / 2 - var_1_8[2] / 2,
					9
				},
				size = var_1_8
			},
			frame = {
				masked = var_1_0,
				size = var_0_22,
				texture_size = var_1_3.texture_size,
				texture_sizes = var_1_3.texture_sizes,
				color = {
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
			background = {
				masked = var_1_0,
				size = var_0_22,
				color = {
					255,
					150,
					150,
					150
				},
				offset = {
					0,
					0,
					0
				}
			},
			background_fade = {
				masked = var_1_0,
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					var_1_4,
					var_1_4 - 2,
					2
				},
				size = {
					var_0_22[1] - var_1_4 * 2,
					var_0_22[2] - var_1_4 * 2
				}
			},
			hover_glow = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_1_4 - 2,
					3
				},
				size = {
					var_0_22[1],
					math.min(var_0_22[2] - 5, 80)
				}
			},
			clicked_rect = {
				masked = var_1_0,
				size = var_0_22,
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				}
			},
			disabled_rect = {
				masked = var_1_0,
				size = var_0_22,
				color = {
					150,
					20,
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			},
			glass_top = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_0_22[2] - (var_1_4 + 11),
					4
				},
				size = {
					var_0_22[1],
					11
				}
			},
			glass_bottom = {
				masked = var_1_0,
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					0,
					var_1_4 - 9,
					4
				},
				size = {
					var_0_22[1],
					11
				}
			},
			new_texture = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_0_22[1] - 63,
					var_0_22[2] / 2 - 12,
					12
				},
				size = {
					63,
					25
				}
			}
		}
	end

	return {
		element = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					texture_id = "rect_masked",
					style_id = "clicked_rect",
					pass_type = "texture"
				},
				{
					texture_id = "rect_masked",
					style_id = "disabled_rect",
					pass_type = "texture",
					content_check_function = function(arg_2_0)
						return arg_2_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail"
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_3_0)
						return not arg_3_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_4_0)
						return arg_4_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				},
				{
					texture_id = "new_texture",
					style_id = "new_texture",
					pass_type = "texture",
					content_check_function = function(arg_5_0)
						return arg_5_0.new
					end
				},
				{
					texture_id = "locked",
					style_id = "locked",
					pass_type = "texture",
					content_check_function = function(arg_6_0)
						return arg_6_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "list_style",
					pass_type = "list_pass",
					content_id = "list_content",
					content_check_function = function(arg_7_0)
						return arg_7_0.active
					end,
					passes = {
						{
							style_id = "text",
							pass_type = "text",
							text_id = "text",
							content_check_function = function(arg_8_0)
								local var_8_0 = arg_8_0.button_hotspot

								return not var_8_0.is_hover and not var_8_0.is_selected
							end
						},
						{
							style_id = "text_hover",
							pass_type = "text",
							text_id = "text",
							content_check_function = function(arg_9_0)
								local var_9_0 = arg_9_0.button_hotspot

								return var_9_0.is_hover and not var_9_0.is_selected
							end
						},
						{
							style_id = "text_selected",
							pass_type = "text",
							text_id = "text",
							content_check_function = function(arg_10_0)
								return arg_10_0.button_hotspot.is_selected
							end
						},
						{
							style_id = "text_shadow",
							pass_type = "text",
							text_id = "text"
						},
						{
							pass_type = "texture",
							style_id = "icon",
							texture_id = "icon"
						},
						{
							pass_type = "hotspot",
							content_id = "button_hotspot"
						},
						{
							style_id = "side_detail_right",
							pass_type = "texture_uv",
							content_id = "side_detail"
						},
						{
							texture_id = "texture_id",
							style_id = "side_detail_left",
							pass_type = "texture",
							content_id = "side_detail"
						},
						{
							texture_id = "frame",
							style_id = "frame",
							pass_type = "texture_frame"
						},
						{
							style_id = "background",
							pass_type = "texture_uv",
							content_id = "background"
						},
						{
							texture_id = "background_fade",
							style_id = "background_fade",
							pass_type = "texture"
						},
						{
							texture_id = "hover_glow",
							style_id = "hover_glow",
							pass_type = "texture",
							content_check_function = function(arg_11_0)
								local var_11_0 = arg_11_0.button_hotspot

								return var_11_0.is_hover or var_11_0.is_selected
							end
						},
						{
							texture_id = "rect_masked",
							style_id = "clicked_rect",
							pass_type = "texture"
						},
						{
							texture_id = "rect_masked",
							style_id = "disabled_rect",
							pass_type = "texture",
							content_check_function = function(arg_12_0)
								return arg_12_0.button_hotspot.disable_button
							end
						},
						{
							texture_id = "glass",
							style_id = "glass_top",
							pass_type = "texture"
						},
						{
							texture_id = "glass",
							style_id = "glass_bottom",
							pass_type = "texture"
						},
						{
							texture_id = "glass",
							style_id = "glass_bottom",
							pass_type = "texture"
						},
						{
							texture_id = "new_texture",
							style_id = "new_texture",
							pass_type = "texture",
							content_check_function = function(arg_13_0)
								return arg_13_0.new
							end
						}
					}
				}
			}
		},
		content = {
			locked = "achievement_symbol_lock",
			hover_glow = "button_state_default",
			background_fade = "button_bg_fade",
			new = false,
			glass = "button_glass_02",
			rect_masked = "rect_masked",
			new_texture = "list_item_tag_new",
			list_content = var_1_9,
			side_detail = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = var_1_5
			},
			button_hotspot = {},
			title_text = arg_1_2 or "n/a",
			frame = var_1_3.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_1_1[2] / var_1_2.size[2]
					},
					{
						arg_1_1[1] / var_1_2.size[1],
						1
					}
				},
				texture_id = var_1_1
			}
		},
		style = {
			list_style = {
				start_index = 1,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				num_draws = 0,
				masked = var_1_0,
				list_member_offset = {
					0,
					var_0_22[2],
					0
				},
				size = {
					var_0_22[1],
					var_0_22[2]
				},
				scenegraph_id = arg_1_3,
				item_styles = var_1_10
			},
			hotspot = {
				masked = var_1_0,
				size = {
					arg_1_1[1],
					arg_1_1[2]
				},
				offset = {
					0,
					0,
					0
				}
			},
			background = {
				masked = var_1_0,
				color = {
					255,
					150,
					150,
					150
				},
				offset = {
					0,
					0,
					0
				}
			},
			background_fade = {
				masked = var_1_0,
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					var_1_4,
					var_1_4 - 2,
					2
				},
				size = {
					arg_1_1[1] - var_1_4 * 2,
					arg_1_1[2] - var_1_4 * 2
				}
			},
			hover_glow = {
				masked = var_1_0,
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					var_1_4 - 2,
					3
				},
				size = {
					arg_1_1[1],
					math.min(arg_1_1[2] - 5, 80)
				}
			},
			clicked_rect = {
				masked = var_1_0,
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				}
			},
			disabled_rect = {
				masked = var_1_0,
				color = {
					150,
					20,
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			},
			title_text = {
				upper_case = true,
				word_wrap = true,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					30,
					0,
					6
				}
			},
			title_text_disabled = {
				upper_case = true,
				font_size = 24,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					30,
					0,
					6
				}
			},
			title_text_shadow = {
				upper_case = true,
				font_size = 24,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					32,
					-2,
					5
				}
			},
			frame = {
				masked = var_1_0,
				texture_size = var_1_3.texture_size,
				texture_sizes = var_1_3.texture_sizes,
				color = {
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
			glass_top = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_1_1[2] - (var_1_4 + 11),
					4
				},
				size = {
					arg_1_1[1],
					11
				}
			},
			glass_bottom = {
				masked = var_1_0,
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					0,
					var_1_4 - 9,
					4
				},
				size = {
					arg_1_1[1],
					11
				}
			},
			side_detail_left = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-9,
					arg_1_1[2] / 2 - var_1_6[2] / 2,
					9
				},
				size = {
					var_1_6[1],
					var_1_6[2]
				}
			},
			side_detail_right = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_1_1[1] - var_1_6[1] + 9,
					arg_1_1[2] / 2 - var_1_6[2] / 2,
					9
				},
				size = {
					var_1_6[1],
					var_1_6[2]
				}
			},
			new_texture = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_1_1[1] - 126,
					arg_1_1[2] / 2 - 25,
					10
				},
				size = {
					126,
					51
				}
			},
			locked = {
				masked = var_1_0,
				color = {
					255,
					100,
					100,
					100
				},
				offset = {
					arg_1_1[1] - 64,
					arg_1_1[2] / 2 - 20,
					10
				},
				size = {
					56,
					40
				}
			}
		},
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_35(arg_14_0, arg_14_1, arg_14_2)
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
					(arg_14_2 or 0) + 6
				},
				size = {
					arg_14_1[1] - 10,
					5
				},
				texture_tiling_size = {
					arg_14_1[1] - 10,
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
					(arg_14_2 or 0) + 10
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
					arg_14_1[1] - 12,
					-6,
					(arg_14_2 or 0) + 10
				},
				size = {
					9,
					17
				}
			}
		},
		scenegraph_id = arg_14_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_36(arg_15_0, arg_15_1)
	local var_15_0 = UIFrameSettings.frame_inner_glow_01

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture_frame",
					style_id = "hover_frame",
					texture_id = "hover_frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "fade",
					texture_id = "fade"
				}
			}
		},
		content = {
			fade = "options_window_fade_01",
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				},
				texture_id = arg_15_1
			},
			hover_frame = var_15_0.texture,
			button_hotspot = {
				allow_multi_hover = true
			}
		},
		style = {
			fade = {
				offset = {
					0,
					0,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			background = {
				color = {
					255,
					100,
					100,
					100
				}
			},
			hover_frame = {
				texture_size = var_15_0.texture_size,
				texture_sizes = var_15_0.texture_sizes,
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		scenegraph_id = arg_15_0
	}
end

local function var_0_37(arg_16_0)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "book",
					texture_id = "book"
				},
				{
					pass_type = "texture",
					style_id = "edge_glow_1",
					texture_id = "edge_glow_1",
					content_check_function = function(arg_17_0)
						return not arg_17_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "edge_glow_2",
					texture_id = "edge_glow_2",
					content_check_function = function(arg_18_0)
						return not arg_18_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "top_glow_1",
					texture_id = "top_glow_1",
					content_check_function = function(arg_19_0)
						return not arg_19_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "top_glow_2",
					texture_id = "top_glow_2",
					content_check_function = function(arg_20_0)
						return not arg_20_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "ribbon_1",
					texture_id = "ribbon_1"
				},
				{
					pass_type = "texture",
					style_id = "ribbon_2",
					texture_id = "ribbon_2"
				}
			}
		},
		content = {
			ribbon_1 = "achievement_book_ribbon_01",
			edge_glow_2 = "achievement_book_glow_02",
			top_glow_2 = "achievement_book_glow_03",
			disabled = false,
			book = "achievement_book_base",
			top_glow_1 = "achievement_book_glow_04",
			ribbon_2 = "achievement_book_ribbon_02",
			edge_glow_1 = "achievement_book_glow_01"
		},
		style = {
			book = {
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
			ribbon_1 = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					32,
					128
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-40,
					-78,
					4
				}
			},
			ribbon_2 = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					32,
					128
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					35,
					-78,
					4
				}
			},
			edge_glow_1 = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					256,
					512
				},
				color = {
					255,
					238,
					122,
					20
				},
				offset = {
					7,
					32,
					0
				}
			},
			edge_glow_2 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					256,
					256
				},
				color = {
					255,
					238,
					122,
					20
				},
				offset = {
					7,
					0,
					3
				}
			},
			top_glow_1 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					256,
					256
				},
				color = {
					255,
					238,
					122,
					20
				},
				offset = {
					0,
					0,
					4
				}
			},
			top_glow_2 = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					64,
					64
				},
				color = {
					255,
					240,
					255,
					143
				},
				offset = {
					6,
					-3,
					5
				}
			}
		},
		scenegraph_id = arg_16_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_38(arg_21_0)
	local var_21_0 = UIFrameSettings.frame_outer_glow_02
	local var_21_1 = var_21_0.texture_sizes.horizontal[2]

	return {
		scenegraph_id = arg_21_0,
		offset = {
			0,
			0,
			0
		},
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "texture_frame",
					style_id = "hover_frame",
					texture_id = "hover_frame",
					content_check_function = function(arg_22_0)
						return arg_22_0.hotspot.is_hover
					end
				},
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				}
			}
		},
		content = {
			texture_id = "tab_menu_bg_02",
			hotspot = {},
			hover_frame = var_21_0.texture
		},
		style = {
			hover_frame = {
				texture_size = var_21_0.texture_size,
				texture_sizes = var_21_0.texture_sizes,
				frame_margins = {
					-var_21_1,
					-var_21_1
				},
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					10
				}
			},
			texture_id = {
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
		}
	}
end

local function var_0_39(arg_23_0)
	local var_23_0 = UIFrameSettings.button_frame_01
	local var_23_1 = UIFrameSettings.frame_outer_glow_01
	local var_23_2 = var_23_1.texture_sizes.horizontal[2]
	local var_23_3 = var_0_26[arg_23_0].size

	return {
		scenegraph_id = arg_23_0,
		offset = {
			0,
			0,
			0
		},
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "texture",
					style_id = "bg_texture",
					texture_id = "bg_texture"
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					style_id = "detail_left",
					pass_type = "texture",
					content_id = "details"
				},
				{
					style_id = "detail_right",
					pass_type = "texture_uv",
					content_id = "details"
				},
				{
					style_id = "glow",
					texture_id = "glow",
					pass_type = "texture_frame",
					content_change_function = function(arg_24_0, arg_24_1)
						if arg_24_0.input_active then
							arg_24_1.color[1] = 255
						elseif arg_24_0.hotspot.is_hover then
							arg_24_1.color[1] = 100
						else
							arg_24_1.color[1] = 0
						end
					end
				},
				{
					style_id = "search_placeholder",
					pass_type = "text",
					text_id = "search_placeholder",
					content_check_function = function(arg_25_0)
						return arg_25_0.search_query == "" and not arg_25_0.input_active
					end
				},
				{
					style_id = "search_query",
					pass_type = "text",
					text_id = "search_query",
					content_change_function = function(arg_26_0, arg_26_1)
						if not arg_26_0.input_active then
							arg_26_1.caret_color[1] = 0
						else
							arg_26_1.caret_color[1] = 127 + 128 * math.sin(5 * Managers.time:time("ui"))
						end
					end
				},
				{
					style_id = "search_filters_hotspot",
					pass_type = "hotspot",
					content_id = "search_filters_hotspot",
					content_check_function = function()
						return not Managers.input:is_device_active("gamepad")
					end,
					content_change_function = function(arg_28_0, arg_28_1)
						local var_28_0 = arg_28_0.parent.filters_active

						if var_28_0 ~= arg_28_0.filters_active then
							arg_28_0.filters_active = var_28_0

							if var_28_0 then
								Colors.copy_to(arg_28_1.parent.search_filters_glow.color, Colors.color_definitions.white)
							else
								Colors.copy_to(arg_28_1.parent.search_filters_glow.color, Colors.color_definitions.font_title)
							end
						end

						local var_28_1 = 0

						if arg_28_0.is_hover then
							var_28_1 = 255
						elseif arg_28_0.filters_active then
							var_28_1 = 200
						end

						arg_28_1.parent.search_filters_glow.color[1] = var_28_1
					end
				},
				{
					pass_type = "texture",
					style_id = "search_filters_bg",
					texture_id = "search_filters_bg"
				},
				{
					pass_type = "texture",
					style_id = "search_filters_icon",
					texture_id = "search_filters_icon"
				},
				{
					pass_type = "texture",
					style_id = "search_filters_glow",
					texture_id = "search_filters_glow"
				},
				{
					style_id = "clear_icon",
					pass_type = "hotspot",
					content_id = "clear_hotspot"
				},
				{
					style_id = "clear_icon",
					texture_id = "clear_icon",
					pass_type = "texture",
					content_check_function = function(arg_29_0)
						return arg_29_0.search_query ~= ""
					end,
					content_change_function = function(arg_30_0, arg_30_1)
						local var_30_0 = arg_30_0.clear_hotspot
						local var_30_1 = var_30_0.is_hover

						if var_30_1 ~= var_30_0.was_hover then
							var_30_0.was_hover = var_30_1

							if var_30_1 then
								Colors.copy_to(arg_30_1.color, Colors.color_definitions.font_title)
							else
								Colors.copy_to(arg_30_1.color, Colors.color_definitions.very_dark_gray)
							end
						end
					end
				}
			}
		},
		content = {
			search_placeholder = "achievement_search_prompt",
			clear_icon = "friends_icon_close",
			bg_texture = "search_bar_texture",
			input_active = false,
			search_query = "",
			caret_index = 1,
			search_filters_icon = "search_filters_icon",
			text_index = 1,
			search_filters_bg = "search_filters_bg",
			search_filters_glow = "search_filters_icon_glow",
			hotspot = {
				allow_multi_hover = true
			},
			frame = var_23_0.texture,
			glow = var_23_1.texture,
			details = {
				texture_id = "button_detail_04",
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
			search_filters_hotspot = {},
			clear_hotspot = {}
		},
		style = {
			bg_texture = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					0,
					0,
					0
				}
			},
			frame = {
				texture_size = var_23_0.texture_size,
				texture_sizes = var_23_0.texture_sizes,
				offset = {
					0,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			detail_left = {
				horizontal_alignment = "left",
				offset = {
					-34,
					0,
					3
				},
				texture_size = {
					60,
					42
				}
			},
			detail_right = {
				horizontal_alignment = "right",
				offset = {
					34,
					0,
					3
				},
				texture_size = {
					60,
					42
				}
			},
			glow = {
				frame_margins = {
					-var_23_2,
					-var_23_2
				},
				texture_size = var_23_1.texture_size,
				texture_sizes = var_23_1.texture_sizes,
				offset = {
					0,
					0,
					3
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			search_placeholder = {
				horizontal_alignment = "left",
				localize = true,
				font_size = 25,
				pixel_perfect = true,
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = {
					255,
					25,
					25,
					25
				},
				offset = {
					47,
					-3,
					5
				}
			},
			search_query = {
				word_wrap = false,
				font_size = 25,
				horizontal_scroll = true,
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_table("black"),
				offset = {
					47,
					13,
					3
				},
				caret_size = {
					2,
					26
				},
				caret_offset = {
					0,
					-6,
					6
				},
				caret_color = Colors.get_table("black"),
				size = {
					var_23_3[1] - 90,
					var_23_3[2]
				}
			},
			search_filters_hotspot = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				area_size = {
					96,
					96
				},
				offset = {
					-42,
					28,
					7
				}
			},
			search_filters_bg = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					128,
					128
				},
				offset = {
					-80,
					-4,
					8
				}
			},
			search_filters_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Colors.get_color_table_with_alpha("white", 255),
				texture_size = {
					128,
					128
				},
				offset = {
					-80,
					-4,
					8
				}
			},
			search_filters_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Colors.get_color_table_with_alpha("font_title", 255),
				texture_size = {
					128,
					128
				},
				offset = {
					-80,
					-4,
					9
				}
			},
			clear_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = {
					255,
					80,
					80,
					80
				},
				texture_size = {
					32,
					32
				},
				area_size = {
					32,
					32
				},
				offset = {
					-15,
					0,
					7
				}
			},
			help_tooltip = {
				font_size = 18,
				max_width = 1500,
				localize = false,
				cursor_side = "right",
				horizontal_alignment = "left",
				vertical_alignment = "center",
				draw_downwards = true,
				font_type = "hell_shark",
				text_color = Colors.get_table("white"),
				line_colors = {
					Colors.get_table("orange_red")
				},
				cursor_offset = {
					0,
					30
				},
				offset = {
					0,
					0,
					50
				},
				area_size = {
					45,
					45
				}
			}
		}
	}
end

local function var_0_40(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_1 or var_0_26[arg_31_0].size
	local var_31_1 = "button_bg_01"
	local var_31_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_31_1)
	local var_31_3 = UIFrameSettings.button_frame_01
	local var_31_4 = UIFrameSettings.frame_outer_glow_01
	local var_31_5 = var_31_4.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					scenegraph_id = "claim_all_button_anchor",
					style_id = "hover_hotspot",
					pass_type = "hotspot",
					content_id = "hover_hotspot"
				},
				{
					scenegraph_id = "claim_all_button_anchor",
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "button_bg",
					pass_type = "texture_uv",
					content_id = "button_bg"
				},
				{
					pass_type = "texture",
					style_id = "button_bg_fade",
					texture_id = "button_bg_fade"
				},
				{
					pass_type = "texture_frame",
					style_id = "button_frame",
					texture_id = "button_frame"
				},
				{
					pass_type = "texture",
					style_id = "button_hover",
					texture_id = "button_hover",
					content_check_function = function(arg_32_0)
						return arg_32_0.button_hotspot.is_hover
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "button_glow",
					texture_id = "button_glow"
				},
				{
					pass_type = "texture",
					style_id = "button_clicked",
					texture_id = "button_clicked",
					content_check_function = function(arg_33_0)
						local var_33_0 = arg_33_0.button_hotspot.is_clicked

						return not var_33_0 or var_33_0 == 0
					end
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text"
				},
				{
					style_id = "button_text_shadow",
					pass_type = "text",
					text_id = "button_text"
				}
			}
		},
		content = {
			button_hover = "button_state_default",
			visible = false,
			button_text = "claim_all_challenges",
			button_bg_fade = "options_window_fade_01",
			button_clicked = "rect_masked",
			should_show = false,
			button_bg = {
				uvs = {
					{
						0,
						0
					},
					{
						math.min(var_31_0[1] / var_31_2.size[1], 1),
						math.min(var_31_0[2] / var_31_2.size[2], 1)
					}
				},
				texture_id = var_31_1
			},
			button_frame = var_31_3.texture,
			button_glow = var_31_4.texture,
			button_hotspot = {},
			hover_hotspot = {
				allow_multi_hover = true
			}
		},
		style = {
			button_bg = {
				masked = true,
				color = {
					255,
					255,
					255,
					255
				},
				size = var_31_0,
				offset = {
					0,
					0,
					0
				}
			},
			button_bg_fade = {
				masked = true,
				color = {
					255,
					255,
					255,
					255
				},
				size = var_31_0,
				offset = {
					0,
					0,
					1
				}
			},
			button_hover = {
				masked = true,
				color = {
					255,
					255,
					255,
					255
				},
				size = var_31_0,
				offset = {
					0,
					0,
					2
				}
			},
			button_glow = {
				masked = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				texture_size = var_31_4.texture_size,
				texture_sizes = var_31_4.texture_sizes,
				frame_margins = {
					-(var_31_5 - 1),
					-(var_31_5 - 1)
				},
				color = {
					255,
					255,
					168,
					0
				},
				area_size = var_31_0,
				offset = {
					0,
					0,
					2
				}
			},
			button_frame = {
				vertical_alignment = "bottom",
				masked = true,
				horizontal_alignment = "center",
				texture_size = var_31_3.texture_size,
				texture_sizes = var_31_3.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				area_size = var_31_0,
				offset = {
					0,
					0,
					6
				}
			},
			button_clicked = {
				masked = true,
				color = {
					125,
					29,
					29,
					29
				},
				size = var_31_0,
				offset = {
					0,
					0,
					3
				}
			},
			hover_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				area_size = {
					var_0_13[1],
					var_0_13[2] * 0.33
				},
				offset = {
					20,
					20,
					10
				}
			},
			button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				area_size = {
					var_31_0[1],
					var_31_0[2] + 10
				},
				offset = {
					20,
					20,
					10
				}
			},
			button_text = {
				upper_case = true,
				localize = true,
				font_size = 21,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_masked",
				text_color = {
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
				size = var_31_0
			},
			button_text_shadow = {
				upper_case = true,
				localize = true,
				font_size = 21,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_masked",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					1,
					-1,
					4
				},
				size = var_31_0
			}
		},
		scenegraph_id = arg_31_0,
		offset = {
			20,
			-20,
			20
		}
	}
end

local var_0_41 = {
	255,
	32,
	32,
	32
}
local var_0_42 = {
	255,
	139,
	69,
	19
}

local function var_0_43(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = var_0_26[arg_34_0].size
	local var_34_1 = {
		var_34_0[1],
		100
	}
	local var_34_2 = UIFrameSettings.button_frame_01
	local var_34_3 = {
		scenegraph_id = arg_34_0,
		offset = {
			0,
			0,
			0
		},
		element = {
			passes = {
				{
					texture_id = "bg",
					style_id = "bg",
					pass_type = "texture"
				},
				{
					scenegraph_id = "gamepad_background",
					style_id = "gamepad_background",
					pass_type = "rect",
					content_check_function = function(arg_35_0, arg_35_1)
						return (Managers.input:is_device_active("gamepad"))
					end
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "divider_top",
					style_id = "divider_top",
					pass_type = "texture"
				},
				{
					texture_id = "divider_left",
					style_id = "divider_left",
					pass_type = "rotated_texture"
				},
				{
					style_id = "reset_filter_hotspot",
					pass_type = "hotspot",
					content_id = "reset_filter_hotspot",
					content_change_function = function(arg_36_0, arg_36_1)
						if arg_36_0.on_pressed then
							local var_36_0 = arg_36_0.parent
							local var_36_1 = var_36_0.query

							if not table.is_empty(var_36_1) then
								table.clear(var_36_1)

								var_36_0.query_dirty = true
							end
						end

						arg_36_1.parent.reset_filter_fg.color[1] = arg_36_0.is_hover and 255 or 0
					end
				},
				{
					texture_id = "reset_filter_bg",
					style_id = "reset_filter_bg",
					pass_type = "texture",
					content_check_function = function(arg_37_0, arg_37_1)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					texture_id = "reset_filter_fg",
					style_id = "reset_filter_fg",
					pass_type = "texture",
					content_check_function = function(arg_38_0, arg_38_1)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "hover",
					style_id = "hover"
				}
			}
		},
		content = {
			divider_left = "divider_01_bottom",
			title_text = "filters",
			bg = "button_bg_01",
			reset_filter_bg = "achievement_refresh_off",
			reset_filter_fg = "achievement_refresh_on",
			divider_top = "divider_01_top",
			visible = true,
			query_dirty = false,
			frame = var_34_2.texture,
			reset_filter_hotspot = {},
			query = {},
			gamepad_button_index = {
				1,
				1
			}
		},
		style = {
			hover = {
				vertical_alignment = "top",
				offset = {
					0,
					0,
					0
				},
				area_size = var_34_1
			},
			bg = {
				vertical_alignment = "top",
				offset = {
					0,
					0,
					1
				},
				color = {
					255,
					64,
					64,
					64
				},
				texture_size = var_34_1
			},
			gamepad_background = {
				offset = {
					0,
					0,
					-1
				},
				color = {
					128,
					0,
					0,
					0
				}
			},
			frame = {
				vertical_alignment = "top",
				texture_size = var_34_2.texture_size,
				texture_sizes = var_34_2.texture_sizes,
				area_size = var_34_1,
				offset = {
					0,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			title_text = {
				vertical_alignment = "top",
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				font_size = 40,
				font_type = "hell_shark_header",
				text_color = Colors.get_table("font_title"),
				offset = {
					0,
					-10,
					3
				}
			},
			divider_top = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = {
					264,
					32
				},
				offset = {
					0,
					-50,
					3
				}
			},
			divider_left = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					0,
					21
				},
				offset = {
					170,
					-60,
					3
				},
				angle = math.pi * 0.5,
				pivot = {
					0,
					0
				}
			},
			reset_filter_hotspot = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				area_size = {
					37.5,
					37.5
				},
				offset = {
					-15,
					-15,
					3
				}
			},
			reset_filter_bg = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					37.5,
					37.5
				},
				offset = {
					-15,
					-15,
					4
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			reset_filter_fg = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					37.5,
					37.5
				},
				offset = {
					-15,
					-15,
					5
				},
				color = {
					0,
					255,
					255,
					255
				}
			}
		}
	}
	local var_34_4 = 20
	local var_34_5 = 25
	local var_34_6 = var_34_4 + 15
	local var_34_7 = 10
	local var_34_8 = Fonts.hell_shark
	local var_34_9 = math.max(var_34_4 * RESOLUTION_LOOKUP.scale, 1)
	local var_34_10 = var_34_8[1]
	local var_34_11 = var_34_8[2]
	local var_34_12 = var_34_8[3]
	local var_34_13 = var_34_3.style.divider_left.texture_size
	local var_34_14 = -80

	for iter_34_0 = 1, #arg_34_2 do
		local var_34_15 = arg_34_2[iter_34_0]
		local var_34_16 = var_34_15.key
		local var_34_17 = var_34_16 .. "_header"

		table.insert(var_34_3.element.passes, {
			pass_type = "text",
			text_id = var_34_17,
			style_id = var_34_17
		})

		var_34_3.content[var_34_17] = Localize("search_filter_" .. var_34_16)
		var_34_3.style[var_34_17] = {
			vertical_alignment = "top",
			upper_case = true,
			horizontal_alignment = "left",
			font_type = "hell_shark",
			font_size = var_34_4,
			text_color = Colors.get_table("font_button_normal"),
			offset = {
				var_34_5,
				-10 + var_34_14,
				3
			}
		}

		local var_34_18 = 200
		local var_34_19 = var_34_18

		for iter_34_1 = 1, #var_34_15 do
			local var_34_20 = var_34_15[iter_34_1]
			local var_34_21 = var_34_20[1]
			local var_34_22 = var_34_20[2]
			local var_34_23 = string.match(Localize(var_34_22), "^[^,]+")
			local var_34_24 = 10 + UIRenderer.text_size(arg_34_1, var_34_23, var_34_10, var_34_9, var_34_12)

			if var_34_19 + var_34_24 >= var_34_1[1] - var_34_5 then
				var_34_19 = var_34_18
				var_34_14 = var_34_14 - var_34_6
				var_34_13[1] = var_34_13[1] + var_34_6
				var_34_1[2] = var_34_1[2] + var_34_6
			end

			local var_34_25 = var_34_17 .. "_hotspot_" .. var_34_22

			table.insert(var_34_3.element.passes, {
				pass_type = "hotspot",
				content_id = var_34_25,
				style_id = var_34_25
			})

			var_34_3.content[var_34_25] = {}
			var_34_3.style[var_34_25] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				area_size = {
					var_34_24,
					30
				},
				offset = {
					var_34_19,
					-5 + var_34_14,
					3
				}
			}

			local var_34_26 = var_34_17 .. "_rect_" .. var_34_20[2]

			table.insert(var_34_3.element.passes, {
				pass_type = "rect",
				style_id = var_34_26,
				content_change_function = function(arg_39_0, arg_39_1)
					local var_39_0 = arg_39_0[var_34_25]
					local var_39_1 = var_34_21 == arg_39_0.query[var_34_16]
					local var_39_2 = var_39_1 and var_0_42 or var_0_41

					Colors.copy_to(arg_39_1.color, var_39_2)

					arg_39_1.color[1] = var_39_0.is_hover and 255 or 175

					if var_39_0.on_pressed then
						if var_39_1 then
							arg_39_0.query[var_34_16] = nil
						else
							arg_39_0.query[var_34_16] = var_34_21
						end

						arg_39_0.query_dirty = true
					end
				end
			})

			var_34_3.style[var_34_26] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					var_34_24,
					30
				},
				color = {
					255,
					64,
					64,
					64
				},
				offset = {
					var_34_19,
					-7 + var_34_14,
					4
				}
			}

			local var_34_27 = UIFrameSettings.frame_outer_glow_01_white
			local var_34_28 = var_34_27.texture_sizes.corner[1]
			local var_34_29 = var_34_17 .. "_texture_frame_" .. var_34_20[2]

			table.insert(var_34_3.element.passes, {
				pass_type = "texture_frame",
				texture_id = var_34_29 .. "_id",
				style_id = var_34_29,
				content_check_function = function(arg_40_0, arg_40_1)
					return Managers.input:is_device_active("gamepad") and arg_40_0.gamepad_button_index[1] == iter_34_1 and arg_40_0.gamepad_button_index[2] == iter_34_0
				end
			})

			var_34_3.content[var_34_29 .. "_id"] = var_34_27.texture
			var_34_3.style[var_34_29] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = var_34_27.texture_size,
				texture_sizes = var_34_27.texture_sizes,
				color = Colors.get_table("font_title"),
				offset = {
					var_34_19 - var_34_28,
					var_34_14 + var_34_28 - 7,
					5
				},
				area_size = {
					var_34_24 + var_34_28 * 2,
					30 + var_34_28 * 2
				}
			}

			local var_34_30 = var_34_17 .. "_fade1_" .. var_34_20[2]

			table.insert(var_34_3.element.passes, {
				pass_type = "texture",
				texture_id = var_34_30,
				style_id = var_34_30
			})

			var_34_3.content[var_34_30] = "button_state_default"
			var_34_3.style[var_34_30] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					var_34_24,
					30
				},
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					var_34_19,
					-7 + var_34_14,
					5
				}
			}

			local var_34_31 = var_34_17 .. "_fade2_" .. var_34_20[2]

			table.insert(var_34_3.element.passes, {
				pass_type = "texture",
				texture_id = var_34_31,
				style_id = var_34_31
			})

			var_34_3.content[var_34_31] = "button_bg_fade"
			var_34_3.style[var_34_31] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					var_34_24,
					30
				},
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					var_34_19,
					-7 + var_34_14,
					6
				}
			}

			local var_34_32 = var_34_17 .. "_fade3_" .. var_34_20[2]

			table.insert(var_34_3.element.passes, {
				pass_type = "texture",
				texture_id = var_34_32,
				style_id = var_34_32
			})

			var_34_3.content[var_34_32] = "menu_frame_glass_01"
			var_34_3.style[var_34_32] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					var_34_24,
					30
				},
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					var_34_19,
					-7 + var_34_14,
					7
				}
			}

			local var_34_33 = var_34_17 .. "_text_" .. var_34_20[2]

			table.insert(var_34_3.element.passes, {
				pass_type = "text",
				text_id = var_34_33,
				style_id = var_34_33
			})

			var_34_3.content[var_34_33] = var_34_23
			var_34_3.style[var_34_33] = {
				vertical_alignment = "top",
				font_type = "hell_shark",
				font_size = 20,
				horizontal_alignment = "left",
				text_color = Colors.get_table("font_default"),
				offset = {
					5 + var_34_19,
					-10 + var_34_14,
					10
				}
			}
			var_34_19 = var_34_19 + 10 + var_34_24
		end

		local var_34_34 = var_34_6 + var_34_7

		var_34_14 = var_34_14 - var_34_34
		var_34_13[1] = var_34_13[1] + var_34_34
		var_34_1[2] = var_34_1[2] + var_34_34
	end

	return var_34_3
end

local var_0_44 = true
local var_0_45 = {
	window = UIWidgets.create_frame("window", var_0_26.window.size, "menu_frame_11", 40),
	window_background = UIWidgets.create_tiled_texture("window_background", "menu_frame_bg_01", {
		960,
		1080
	}, nil, nil, {
		255,
		100,
		100,
		100
	}),
	window_top_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window_top_fade"),
	window_top = UIWidgets.create_tiled_texture("window_top", "achievement_plank", {
		307,
		200
	}, nil, nil, {
		255,
		255,
		255,
		255
	}),
	left_window_frame = UIWidgets.create_frame("left_window", var_0_26.left_window.size, "menu_frame_11", 20),
	left_window_mask = UIWidgets.create_simple_texture("mask_rect", "category_window"),
	category_window_mask_top = UIWidgets.create_simple_texture("mask_rect_edge_fade", "category_window_mask_top"),
	category_window_mask_bottom = UIWidgets.create_simple_uv_texture("mask_rect_edge_fade", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "category_window_mask_bottom"),
	right_window_frame = UIWidgets.create_frame("right_window", var_0_26.right_window.size, "menu_frame_11", 20),
	right_window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "right_window_fade"),
	right_window = UIWidgets.create_tiled_texture("right_window", "achievement_background_leather", {
		256,
		256
	}, nil, nil, {
		255,
		180,
		180,
		180
	}),
	right_window_mask = UIWidgets.create_simple_texture("mask_rect", "achievement_window"),
	achievement_window_mask_bottom = UIWidgets.create_simple_rotated_texture("mask_rect_edge_fade", math.pi, {
		var_0_13[1] / 2,
		15
	}, "achievement_window_mask_bottom"),
	achievement_window_mask_top = UIWidgets.create_simple_texture("mask_rect_edge_fade", "achievement_window_mask_top"),
	exit_button = UIWidgets.create_default_button("exit_button", var_0_26.exit_button.size, nil, nil, Localize("menu_close"), 24, nil, "button_detail_04", 34, var_0_44),
	summary_button = UIWidgets.create_default_button("summary_button", var_0_26.summary_button.size, nil, nil, Localize("achv_menu_summary_category_title"), 24),
	quests_button = UIWidgets.create_window_category_button("quests_button", var_0_26.quests_button.size, Localize("achv_menu_quests_category_title"), "achievement_button_icon_quests", "achievement_button_background_quests", true),
	achievements_button = UIWidgets.create_window_category_button_mirrored("achievements_button", var_0_26.achievements_button.size, Localize("achv_menu_achievements_category_title"), "achievement_button_icon_achievements", "achievement_button_background_achievements", true),
	title = UIWidgets.create_simple_texture("frame_title_bg", "title"),
	title_bg = UIWidgets.create_background("title_bg", var_0_26.title_bg.size, "menu_frame_bg_02"),
	title_text = UIWidgets.create_simple_text(Localize("achv_menu_title"), "title_text", nil, nil, var_0_32),
	achievement_scrollbar = UIWidgets.create_chain_scrollbar("achievement_scrollbar", nil, var_0_26.achievement_scrollbar.size),
	category_scrollbar = UIWidgets.create_chain_scrollbar("category_scrollbar", "category_window_mask", var_0_26.category_scrollbar.size),
	achievement_window = {
		scenegraph_id = "achievement_window_mask",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "scroll",
					scroll_function = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5)
						local var_41_0 = arg_41_4.y * -1

						if IS_XB1 and GameSettingsDevelopment.allow_keyboard_mouse and not Managers.input:is_device_active("gamepad") then
							var_41_0 = math.sign(arg_41_4.x) * -1
						end

						local var_41_1 = arg_41_2.hotspot

						if var_41_0 ~= 0 and var_41_1.is_hover then
							arg_41_2.axis_input = var_41_0
							arg_41_2.scroll_add = var_41_0 * arg_41_2.scroll_amount
						else
							local var_41_2 = arg_41_2.axis_input
						end

						local var_41_3 = arg_41_2.scroll_add

						if var_41_3 then
							local var_41_4 = var_41_3 * (arg_41_5 * 5)
							local var_41_5 = var_41_3 - var_41_4

							if math.abs(var_41_5) > 0 then
								arg_41_2.scroll_add = var_41_5
							else
								arg_41_2.scroll_add = nil
							end

							local var_41_6 = arg_41_2.scroll_value

							arg_41_2.scroll_value = math.clamp(var_41_6 + var_41_4, 0, 1)
						end
					end
				}
			}
		},
		content = {
			scroll_amount = 0.1,
			scroll_value = 1,
			hotspot = {
				allow_multi_hover = true
			}
		},
		style = {}
	}
}
local var_0_46 = {
	input = var_0_39("search_input")
}
local var_0_47 = {
	left_window = UIWidgets.create_simple_uv_texture("achievement_quests_bg", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "summary_left_window_fade", nil, nil, {
		255,
		100,
		100,
		100
	}),
	left_window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "summary_left_window_fade", nil, nil, nil, 1),
	time_left_text = UIWidgets.create_simple_text(Localize("achv_menu_summary_quest_refresh") .. " 00:00:00", "quest_timer", nil, nil, var_0_27),
	overlay = UIWidgets.create_simple_rect("achievement_window_mask", {
		220,
		12,
		12,
		12
	}, 4),
	overlay_fade = UIWidgets.create_simple_texture("options_window_fade_01", "achievement_window_mask", nil, nil, nil, 5),
	overlay_text = UIWidgets.create_simple_text(Localize("achv_menu_no_quests_text"), "achievement_window_mask", nil, nil, var_0_30),
	claim_all_quests = var_0_40("claim_all_button_anchor", {
		300,
		44
	})
}
local var_0_48 = {
	left_window = UIWidgets.create_simple_uv_texture("achievement_challenges_bg", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "summary_left_window_fade", nil, nil, {
		255,
		100,
		100,
		100
	}),
	left_window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "summary_left_window_fade", nil, nil, nil, 1),
	overlay = UIWidgets.create_simple_rect("achievement_window_mask", {
		220,
		12,
		12,
		12
	}, 4),
	overlay_fade = UIWidgets.create_simple_texture("options_window_fade_01", "achievement_window_mask", nil, nil, nil, 5),
	overlay_text = UIWidgets.create_simple_text(Localize("achv_menu_no_quests_text"), "achievement_window_mask", nil, nil, var_0_30),
	claim_all_achievements = var_0_40("claim_all_button_anchor", {
		300,
		44
	})
}
local var_0_49 = {
	claim_overlay = UIWidgets.create_simple_rect("window", {
		220,
		12,
		12,
		12
	}, 36),
	claim_overlay_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window", nil, nil, nil, 37),
	claim_overlay_loading_glow = UIWidgets.create_simple_texture("loading_title_divider", "claim_overlay_divider", nil, nil, nil, 1),
	claim_overlay_loading_frame = UIWidgets.create_simple_texture("loading_title_divider_background", "claim_overlay_divider")
}
local var_0_50 = {
	summary_center_window = UIWidgets.create_simple_texture("achievement_summary_bg", "summary_center_window_fade"),
	summary_center_window_frame = UIWidgets.create_frame("summary_center_window", var_0_26.summary_center_window.size, "menu_frame_11", 30),
	summary_center_text = UIWidgets.create_simple_text(Localize("achv_menu_summary_description_text"), "summary_center_text", nil, nil, var_0_31),
	summary_right_window_frame = UIWidgets.create_frame("summary_right_window", var_0_26.summary_right_window.size, "menu_frame_11", 20),
	summary_right_window_button = var_0_36("summary_right_window_fade", "achievement_challenges_bg"),
	summary_right_arrow = UIWidgets.create_simple_texture("achievement_arrow_hover", "summary_right_arrow"),
	summary_right_title = UIWidgets.create_simple_text(Localize("achv_menu_summary_overview_title"), "summary_right_title", nil, nil, var_0_33),
	summary_right_title_divider = UIWidgets.create_simple_texture("divider_01_top", "summary_right_title_divider"),
	summary_achievement_bar_1 = UIWidgets.create_statistics_bar("summary_achievement_bar_1", var_0_26.summary_achievement_bar_1.size),
	summary_achievement_bar_2 = UIWidgets.create_statistics_bar("summary_achievement_bar_2", var_0_26.summary_achievement_bar_2.size),
	summary_achievement_bar_3 = UIWidgets.create_statistics_bar("summary_achievement_bar_3", var_0_26.summary_achievement_bar_3.size),
	summary_achievement_bar_4 = UIWidgets.create_statistics_bar("summary_achievement_bar_4", var_0_26.summary_achievement_bar_4.size),
	summary_achievement_bar_5 = UIWidgets.create_statistics_bar("summary_achievement_bar_5", var_0_26.summary_achievement_bar_5.size),
	summary_achievement_bar_6 = UIWidgets.create_statistics_bar("summary_achievement_bar_6", var_0_26.summary_achievement_bar_6.size),
	summary_quest_bar_background_1 = var_0_38("summary_quest_bar_background_1"),
	summary_quest_bar_background_2 = var_0_38("summary_quest_bar_background_2"),
	summary_quest_bar_background_3 = var_0_38("summary_quest_bar_background_3"),
	summary_quest_bar_1 = UIWidgets.create_quest_bar("summary_quest_bar_1", var_0_26.summary_quest_bar_1.size),
	summary_quest_bar_2 = UIWidgets.create_quest_bar("summary_quest_bar_2", var_0_26.summary_quest_bar_2.size),
	summary_quest_bar_3 = UIWidgets.create_quest_bar("summary_quest_bar_3", var_0_26.summary_quest_bar_3.size),
	summary_quest_bar_title_1 = UIWidgets.create_simple_text(Localize("achv_menu_daily_category_title"), "summary_quest_bar_title_1", nil, nil, var_0_28),
	summary_quest_bar_title_2 = UIWidgets.create_simple_text(Localize("achv_menu_weekly_category_title"), "summary_quest_bar_title_2", nil, nil, var_0_28),
	summary_quest_bar_title_3 = UIWidgets.create_simple_text(Localize("achv_menu_event_category_title"), "summary_quest_bar_title_3", nil, nil, var_0_28),
	summary_quest_bar_timer_1 = UIWidgets.create_simple_text("", "summary_quest_bar_title_1", nil, nil, var_0_29),
	summary_quest_bar_timer_2 = UIWidgets.create_simple_text("", "summary_quest_bar_title_2", nil, nil, var_0_29),
	summary_quest_bar_timer_3 = UIWidgets.create_simple_text("", "summary_quest_bar_title_3", nil, nil, var_0_29),
	summary_left_window_frame = UIWidgets.create_frame("summary_left_window", var_0_26.summary_left_window.size, "menu_frame_11", 20),
	summary_left_window_button = var_0_36("summary_left_window_fade", "achievement_quests_bg"),
	summary_left_arrow = UIWidgets.create_simple_texture("achievement_arrow_hover", "summary_left_arrow"),
	summary_left_title = UIWidgets.create_simple_text(Localize("achv_menu_summary_quests_available"), "summary_left_title", nil, nil, var_0_33),
	summary_left_title_divider = UIWidgets.create_simple_texture("divider_01_top", "summary_left_title_divider"),
	summary_quest_book = var_0_37("summary_quest_book"),
	summary_achievement_flag = UIWidgets.create_simple_texture("achievement_menu_flag", "summary_achievement_flag")
}

function create_category_tab_widgets()
	local var_42_0 = {}
	local var_42_1 = Managers.state.achievement:num_achievement_categories()

	for iter_42_0 = 1, var_42_1 + 1 do
		local var_42_2 = iter_42_0 == 1
		local var_42_3 = "category_tab_" .. iter_42_0
		local var_42_4 = "category_tab_" .. iter_42_0 .. "_list"
		local var_42_5 = "category_tab_" .. iter_42_0 - 1
		local var_42_6 = "category_tab_" .. iter_42_0 - 1 .. "_list"

		var_0_26[var_42_3] = {
			horizontal_alignment = "center",
			parent = var_42_2 and "category_root" or var_42_6,
			vertical_alignment = var_42_2 and "top" or "bottom",
			size = var_0_20,
			position = {
				var_42_2 and -15 or 0,
				var_42_2 and -20 or -(var_0_20[2] + var_0_23),
				0
			}
		}
		var_0_26[var_42_4] = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			parent = var_42_3,
			size = {
				var_0_20[1],
				0
			},
			position = {
				0,
				-(var_0_20[2] + var_0_23),
				0
			}
		}
		var_42_0[iter_42_0] = var_0_34(var_42_3, var_0_20, "n/a", var_42_4)
	end

	return var_42_0
end

local var_0_51 = var_0_0("achievement_entry", var_0_11)
local var_0_52 = var_0_1("achievement_entry", var_0_11)
local var_0_53 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				arg_43_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				local var_44_0 = math.easeOutCubic(arg_44_3)

				arg_44_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				arg_46_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
				local var_47_0 = math.easeOutCubic(arg_47_3)

				arg_47_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
				return
			end
		}
	}
}
local var_0_54 = {
	default = {
		{
			input_action = "confirm",
			priority = 1,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 4,
			description_text = "input_description_close"
		}
	},
	filter_unavailable = {
		actions = {
			{
				input_action = "refresh",
				priority = 2,
				description_text = "input_description_filter"
			}
		}
	},
	filter_available = {
		actions = {
			{
				input_action = "refresh",
				priority = 2,
				description_text = "input_description_filter"
			},
			{
				input_action = "special_1",
				priority = 3,
				description_text = "lb_reset_filters"
			}
		}
	}
}

return {
	generic_input_actions = var_0_54,
	search_widget_definitions = var_0_46,
	quest_widgets = var_0_47,
	achievement_widgets = var_0_48,
	category_tab_info = var_0_24,
	achievement_spacing = var_0_16,
	checklist_entry_size = var_0_18,
	achievement_entry_size = var_0_11,
	achievement_window_size = var_0_13,
	achievement_scrollbar_size = var_0_14,
	achievement_presentation_amount = var_0_15,
	quest_scrollbar_bottom_inset = var_0_17,
	widgets = var_0_45,
	overlay_widgets = var_0_49,
	summary_widgets = var_0_50,
	create_category_tab_widgets_func = create_category_tab_widgets,
	scenegraph_definition = var_0_26,
	animation_definitions = var_0_53,
	quest_entry_definition = var_0_51,
	achievement_entry_definition = var_0_52,
	console_cursor_definition = UIWidgets.create_console_cursor("console_cursor"),
	virtual_keyboard_anchor_point = {
		230,
		350
	},
	create_search_filters_widget = var_0_43
}
