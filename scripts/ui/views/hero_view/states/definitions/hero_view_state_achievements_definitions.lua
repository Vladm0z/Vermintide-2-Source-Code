-- chunkname: @scripts/ui/views/hero_view/states/definitions/hero_view_state_achievements_definitions.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/quest_widget_definition")
local var_0_1 = local_require("scripts/ui/views/hero_view/states/definitions/achievement_widget_definition")
local game_start_windows = UISettings.game_start_windows
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local large_window_size = game_start_windows.large_window_size
local num = 200
local num_2 = large_window_size[2] - num + 22
local tbl = {
	math.floor((large_window_size[1] + 44) / 3),
	num_2
}
local tbl_2 = {
	large_window_size[1] + 22 - tbl[1],
	num_2
}
local tbl_3 = {
	900,
	156
}
local tbl_4 = {
	800,
	100
}
local tbl_5 = {
	tbl_2[1] - 22,
	tbl_2[2] - 104
}
local tbl_6 = {
	16,
	tbl_2[2] - 44
}
local num_3 = 4
local num_4 = 40
local num_5 = 20
local tbl_7 = {
	tbl_4[2] / 2,
	30
}
local tbl_8 = {
	tbl[1] - 22,
	tbl[2] - 48
}
local tbl_9 = {
	tbl[1] - 120,
	60
}
local tbl_10 = {
	tbl_9[1] - spacing * 2,
	tbl[2] - tbl_9[2] - tbl_9[2]
}
local tbl_11 = {
	tbl_9[1] - spacing * 2,
	42
}
local num_6 = 5
local tbl_12 = {
	tab_size = tbl_9,
	tab_active_size = tbl_10,
	tab_list_entry_size = tbl_11,
	tab_list_entry_spacing = num_6
}
local num_7 = 11
local tbl_13 = {
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
		size = large_window_size,
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
			large_window_size[1] - 5,
			large_window_size[2] - 5
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
			large_window_size[1],
			num
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
			large_window_size[1] - 44,
			num - 44
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
		size = tbl,
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
			tbl[1] - 44,
			tbl[2] - 44
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
		size = tbl_2,
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
			tbl_2[1] - 44,
			tbl_2[2] - 44
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
		size = tbl_8,
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
			tbl_8[1],
			tbl[2] - 44
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
			tbl_8[1],
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
			tbl_8[1],
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
		size = tbl_6,
		position = {
			-spacing,
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
		size = tbl_5,
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
			tbl_5[1],
			tbl_2[2] - 44
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
			tbl_5[1],
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
			tbl_5[1],
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
		size = tbl_3,
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
		size = tbl_6,
		position = {
			-spacing,
			0,
			3
		}
	},
	quest_timer = {
		vertical_alignment = "bottom",
		parent = "achievement_window",
		horizontal_alignment = "left",
		size = {
			tbl_5[1] - 70,
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
			size[1] - 60,
			108
		},
		position = {
			-(size[1] + 30),
			-46,
			10
		}
	},
	summary_button = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1] - 160,
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
			size[1] - 60,
			108
		},
		position = {
			size[1] + 30,
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
			tbl[1] + 2,
			tbl[2]
		},
		position = {
			tbl[1] - 22,
			0,
			1
		}
	},
	summary_center_window_fade = {
		vertical_alignment = "center",
		parent = "summary_center_window",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 40,
			tbl[2] - 44
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
			tbl[1] - 140,
			tbl[2] - 100
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
		size = tbl,
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
			tbl[1] - 44,
			tbl[2] - 44
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
			tbl[1] - 44,
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
			tbl[1] - 100,
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
			tbl[1] - 100,
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
			tbl[1] - 100,
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
			tbl[1] - 100,
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
			tbl[1] - 100,
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
			tbl[1] - 100,
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
			tbl[1],
			tbl[2]
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
			tbl[1] - 42,
			tbl[2] - 44
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
			tbl[1] - 44,
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
			tbl[1] - 40,
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
			tbl[1] - 40,
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
			tbl[1] - 40,
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
			tbl[1] - 100,
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
			tbl[1] - 100,
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
			tbl[1] - 100,
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
			tbl[1] - 100,
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
			tbl[1] - 100,
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
			tbl[1] - 100,
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
			tbl_5[1] / 2 - 300,
			100,
			5
		}
	}
}
local tbl_14 = {
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
local tbl_15 = {
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
local tbl_16 = {
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
local tbl_17 = {
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
local tbl_18 = {
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
local tbl_19 = {
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
local tbl_20 = {
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

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local flag = true
	local str = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local button_frame_01 = UIFrameSettings.button_frame_01
	local var_1_4 = button_frame_01.texture_sizes.corner[1]
	local str_2 = "button_detail_02"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2).size
	local str_3 = "button_detail_03"
	local size_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_3).size
	local tbl = {
		allow_multi_hover = true
	}
	local tbl_2 = {}

	for i = 1, num_7 do
		local var_1_11 = num_6

		tbl[i] = {
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
				texture_id = str_3
			},
			frame = button_frame_01.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_1_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_1_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = str
			}
		}

		local tbl_3 = {
			list_member_offset = {
				0,
				-(tbl_11[2] + var_1_11),
				0
			},
			size = {
				tbl_11[1],
				tbl_11[2]
			}
		}
		local tbl_4 = {
			vertical_alignment = "center",
			upper_case = true,
			font_size = 22,
			horizontal_alignment = "left",
			word_wrap = true
		}
		local flag_2

		flag_2 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_4.font_type = flag_2
		tbl_4.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
		tbl_4.offset = {
			40,
			0,
			14
		}
		tbl_3.text = tbl_4

		local tbl_5 = {
			vertical_alignment = "center",
			upper_case = true,
			font_size = 22,
			horizontal_alignment = "left",
			word_wrap = true
		}
		local flag_3

		flag_3 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_5.font_type = flag_3
		tbl_5.text_color = Colors.get_color_table_with_alpha("white", 255)
		tbl_5.offset = {
			40,
			0,
			14
		}
		tbl_3.text_hover = tbl_5

		local tbl_6 = {
			vertical_alignment = "center",
			upper_case = true,
			font_size = 22,
			horizontal_alignment = "left",
			word_wrap = true
		}
		local flag_4

		flag_4 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_6.font_type = flag_4
		tbl_6.text_color = Colors.get_color_table_with_alpha("white", 255)
		tbl_6.offset = {
			40,
			0,
			14
		}
		tbl_3.text_selected = tbl_6

		local tbl_7 = {
			vertical_alignment = "center",
			upper_case = true,
			font_size = 22,
			horizontal_alignment = "left",
			word_wrap = true
		}
		local flag_5

		flag_5 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_7.font_type = flag_5
		tbl_7.text_color = Colors.get_color_table_with_alpha("black", 255)
		tbl_7.offset = {
			42,
			-2,
			13
		}
		tbl_3.text_shadow = tbl_7
		tbl_3.rect = {
			masked = flag,
			size = {
				tbl_11[1],
				tbl_11[2]
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
		}
		tbl_3.icon = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = flag,
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
		}
		tbl_3.side_detail_left = {
			masked = flag,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-9,
				tbl_11[2] / 2 - size_2[2] / 2,
				9
			},
			size = size_2
		}
		tbl_3.side_detail_right = {
			masked = flag,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_11[1] - size_2[1] + 9,
				tbl_11[2] / 2 - size_2[2] / 2,
				9
			},
			size = size_2
		}
		tbl_3.frame = {
			masked = flag,
			size = tbl_11,
			texture_size = button_frame_01.texture_size,
			texture_sizes = button_frame_01.texture_sizes,
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
		}
		tbl_3.background = {
			masked = flag,
			size = tbl_11,
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
		}
		tbl_3.background_fade = {
			masked = flag,
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
				tbl_11[1] - var_1_4 * 2,
				tbl_11[2] - var_1_4 * 2
			}
		}
		tbl_3.hover_glow = {
			masked = flag,
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
				tbl_11[1],
				math.min(tbl_11[2] - 5, 80)
			}
		}
		tbl_3.clicked_rect = {
			masked = flag,
			size = tbl_11,
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
		}
		tbl_3.disabled_rect = {
			masked = flag,
			size = tbl_11,
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
		}
		tbl_3.glass_top = {
			masked = flag,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				tbl_11[2] - (var_1_4 + 11),
				4
			},
			size = {
				tbl_11[1],
				11
			}
		}
		tbl_3.glass_bottom = {
			masked = flag,
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
				tbl_11[1],
				11
			}
		}
		tbl_3.new_texture = {
			masked = flag,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_11[1] - 63,
				tbl_11[2] / 2 - 12,
				12
			},
			size = {
				63,
				25
			}
		}
		tbl_2[i] = tbl_3
	end

	local tbl_8 = {
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
					content_check_function = function (self)
						-- function 2
						return self.button_hotspot.disable_button
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
					content_check_function = function (self)
						-- function 3
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 4
						return self.button_hotspot.disable_button
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
					content_check_function = function (self)
						-- function 5
						return self.new
					end
				},
				{
					texture_id = "locked",
					style_id = "locked",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 6
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "list_style",
					pass_type = "list_pass",
					content_id = "list_content",
					content_check_function = function (self)
						-- function 7
						return self.active
					end,
					passes = {
						{
							style_id = "text",
							pass_type = "text",
							text_id = "text",
							content_check_function = function (self)
								-- function 8
								local button_hotspot = self.button_hotspot

								return not not button_hotspot.is_hover or not button_hotspot.is_selected
							end
						},
						{
							style_id = "text_hover",
							pass_type = "text",
							text_id = "text",
							content_check_function = function (self)
								-- function 9
								local button_hotspot = self.button_hotspot
								local is_hover = button_hotspot.is_hover

								is_hover = not is_hover and not button_hotspot.is_selected

								return is_hover
							end
						},
						{
							style_id = "text_selected",
							pass_type = "text",
							text_id = "text",
							content_check_function = function (self)
								-- function 10
								return self.button_hotspot.is_selected
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
							content_check_function = function (self)
								-- function 11
								local button_hotspot = self.button_hotspot
								local is_hover = button_hotspot.is_hover

								is_hover = is_hover or button_hotspot.is_selected

								return is_hover
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
							content_check_function = function (self)
								-- function 12
								return self.button_hotspot.disable_button
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
							content_check_function = function (self)
								-- function 13
								return self.new
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
			list_content = tbl,
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
				texture_id = str_2
			},
			button_hotspot = {},
			title_text = arg_1_2 or "n/a",
			frame = button_frame_01.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_1_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_1_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = str
			}
		}
	}
	local tbl_9 = {
		list_style = {
			start_index = 1,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			num_draws = 0,
			masked = flag,
			list_member_offset = {
				0,
				tbl_11[2],
				0
			},
			size = {
				tbl_11[1],
				tbl_11[2]
			},
			scenegraph_id = arg_1_3,
			item_styles = tbl_2
		},
		hotspot = {
			masked = flag,
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
			masked = flag,
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
			masked = flag,
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
			masked = flag,
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
			masked = flag,
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
			masked = flag,
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
		}
	}
	local tbl_10 = {
		upper_case = true,
		word_wrap = true,
		font_size = 24,
		horizontal_alignment = "left",
		vertical_alignment = "center"
	}
	local flag_6

	flag_6 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_10.font_type = flag_6
	tbl_10.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_10.default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_10.select_text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_10.offset = {
		30,
		0,
		6
	}
	tbl_9.title_text = tbl_10

	local tbl_12 = {
		upper_case = true,
		font_size = 24,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center"
	}
	local flag_7

	flag_7 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_12.font_type = flag_7
	tbl_12.text_color = Colors.get_color_table_with_alpha("gray", 255)
	tbl_12.default_text_color = Colors.get_color_table_with_alpha("gray", 255)
	tbl_12.offset = {
		30,
		0,
		6
	}
	tbl_9.title_text_disabled = tbl_12

	local tbl_13 = {
		upper_case = true,
		font_size = 24,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center"
	}
	local flag_8

	flag_8 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_13.font_type = flag_8
	tbl_13.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_13.default_text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_13.offset = {
		32,
		-2,
		5
	}
	tbl_9.title_text_shadow = tbl_13
	tbl_9.frame = {
		masked = flag,
		texture_size = button_frame_01.texture_size,
		texture_sizes = button_frame_01.texture_sizes,
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
	}
	tbl_9.glass_top = {
		masked = flag,
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
	}
	tbl_9.glass_bottom = {
		masked = flag,
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
	}
	tbl_9.side_detail_left = {
		masked = flag,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			-9,
			arg_1_1[2] / 2 - size[2] / 2,
			9
		},
		size = {
			size[1],
			size[2]
		}
	}
	tbl_9.side_detail_right = {
		masked = flag,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			arg_1_1[1] - size[1] + 9,
			arg_1_1[2] / 2 - size[2] / 2,
			9
		},
		size = {
			size[1],
			size[2]
		}
	}
	tbl_9.new_texture = {
		masked = flag,
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
	}
	tbl_9.locked = {
		masked = flag,
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
	tbl_8.style = tbl_9
	tbl_8.scenegraph_id = arg_1_0
	tbl_8.offset = {
		0,
		0,
		0
	}

	return tbl_8
end

local function fn_2(arg_14_0, arg_14_1, arg_14_2)
	-- function 14
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

local function fn_3(arg_15_0, arg_15_1)
	-- function 15
	local frame_inner_glow_01 = UIFrameSettings.frame_inner_glow_01

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
			hover_frame = frame_inner_glow_01.texture,
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
				texture_size = frame_inner_glow_01.texture_size,
				texture_sizes = frame_inner_glow_01.texture_sizes,
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

local function fn_4(arg_16_0)
	-- function 16
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
					content_check_function = function (self)
						-- function 17
						return not self.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "edge_glow_2",
					texture_id = "edge_glow_2",
					content_check_function = function (self)
						-- function 18
						return not self.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "top_glow_1",
					texture_id = "top_glow_1",
					content_check_function = function (self)
						-- function 19
						return not self.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "top_glow_2",
					texture_id = "top_glow_2",
					content_check_function = function (self)
						-- function 20
						return not self.disabled
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

local function fn_5(arg_21_0)
	-- function 21
	local frame_outer_glow_02 = UIFrameSettings.frame_outer_glow_02
	local var_21_1 = frame_outer_glow_02.texture_sizes.horizontal[2]

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
					content_check_function = function (self)
						-- function 22
						return self.hotspot.is_hover
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
			hover_frame = frame_outer_glow_02.texture
		},
		style = {
			hover_frame = {
				texture_size = frame_outer_glow_02.texture_size,
				texture_sizes = frame_outer_glow_02.texture_sizes,
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

local function fn_6(arg_23_0)
	-- function 23
	local button_frame_01 = UIFrameSettings.button_frame_01
	local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
	local var_23_2 = frame_outer_glow_01.texture_sizes.horizontal[2]
	local size = tbl_13[arg_23_0].size

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
					content_change_function = function (self, arg_24_1)
						-- function 24
						if not self.input_active then
							arg_24_1.color[1] = 255
						elseif not self.hotspot.is_hover then
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
					content_check_function = function (self)
						-- function 25
						return self.search_query ~= "" or not self.input_active
					end
				},
				{
					style_id = "search_query",
					pass_type = "text",
					text_id = "search_query",
					content_change_function = function (self, arg_26_1)
						-- function 26
						if not self.input_active then
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
					content_check_function = function ()
						-- function 27
						return not Managers.input:is_device_active("gamepad")
					end,
					content_change_function = function (self, arg_28_1)
						-- function 28
						local filters_active = self.parent.filters_active

						if filters_active ~= self.filters_active then
							self.filters_active = filters_active

							if not filters_active then
								Colors.copy_to(arg_28_1.parent.search_filters_glow.color, Colors.color_definitions.white)
							else
								Colors.copy_to(arg_28_1.parent.search_filters_glow.color, Colors.color_definitions.font_title)
							end
						end

						local num = 0

						if not self.is_hover then
							num = 255
						elseif not self.filters_active then
							num = 200
						end

						arg_28_1.parent.search_filters_glow.color[1] = num
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
					content_check_function = function (self)
						-- function 29
						return self.search_query ~= ""
					end,
					content_change_function = function (self, arg_30_1)
						-- function 30
						local clear_hotspot = self.clear_hotspot
						local is_hover = clear_hotspot.is_hover

						if is_hover ~= clear_hotspot.was_hover then
							clear_hotspot.was_hover = is_hover

							if not is_hover then
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
			frame = button_frame_01.texture,
			glow = frame_outer_glow_01.texture,
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
				texture_size = button_frame_01.texture_size,
				texture_sizes = button_frame_01.texture_sizes,
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
				texture_size = frame_outer_glow_01.texture_size,
				texture_sizes = frame_outer_glow_01.texture_sizes,
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
					size[1] - 90,
					size[2]
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

local function fn_7(arg_31_0, arg_31_1)
	-- function 31
	local flag = arg_31_1 or tbl_13[arg_31_0].size
	local str = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local button_frame_01 = UIFrameSettings.button_frame_01
	local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
	local var_31_5 = frame_outer_glow_01.texture_sizes.corner[1]

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
					content_check_function = function (self)
						-- function 32
						return self.button_hotspot.is_hover
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
					content_check_function = function (self)
						-- function 33
						local is_clicked = self.button_hotspot.is_clicked

						return not is_clicked and is_clicked == 0
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
						math.min(flag[1] / get_atlas_settings_by_texture_name.size[1], 1),
						math.min(flag[2] / get_atlas_settings_by_texture_name.size[2], 1)
					}
				},
				texture_id = str
			},
			button_frame = button_frame_01.texture,
			button_glow = frame_outer_glow_01.texture,
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
				size = flag,
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
				size = flag,
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
				size = flag,
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
				texture_size = frame_outer_glow_01.texture_size,
				texture_sizes = frame_outer_glow_01.texture_sizes,
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
				area_size = flag,
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
				texture_size = button_frame_01.texture_size,
				texture_sizes = button_frame_01.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				area_size = flag,
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
				size = flag,
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
					tbl_5[1],
					tbl_5[2] * 0.33
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
					flag[1],
					flag[2] + 10
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
				size = flag
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
				size = flag
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

local tbl_21 = {
	255,
	32,
	32,
	32
}
local tbl_22 = {
	255,
	139,
	69,
	19
}

local function fn_8(arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	local size = tbl_13[arg_34_0].size
	local tbl = {
		size[1],
		100
	}
	local button_frame_01 = UIFrameSettings.button_frame_01
	local tbl_2 = {
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
					content_check_function = function (arg_35_0, arg_35_1)
						-- function 35
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
					content_change_function = function (self, arg_36_1)
						-- function 36
						if not self.on_pressed then
							local parent = self.parent
							local query = parent.query

							if not table.is_empty(query) then
								table.clear(query)

								parent.query_dirty = true
							end
						end

						local color = arg_36_1.parent.reset_filter_fg.color
						local flag

						flag = not self.is_hover and 255 and 0
						color[1] = flag
					end
				},
				{
					texture_id = "reset_filter_bg",
					style_id = "reset_filter_bg",
					pass_type = "texture",
					content_check_function = function (arg_37_0, arg_37_1)
						-- function 37
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					texture_id = "reset_filter_fg",
					style_id = "reset_filter_fg",
					pass_type = "texture",
					content_check_function = function (arg_38_0, arg_38_1)
						-- function 38
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
			frame = button_frame_01.texture,
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
				area_size = tbl
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
				texture_size = tbl
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
				texture_size = button_frame_01.texture_size,
				texture_sizes = button_frame_01.texture_sizes,
				area_size = tbl,
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
	local num = 20
	local num_2 = 25
	local num_3 = num + 15
	local num_4 = 10
	local hell_shark = Fonts.hell_shark
	local max = math.max(num * RESOLUTION_LOOKUP.scale, 1)
	local var_34_10 = hell_shark[1]
	local var_34_11 = hell_shark[2]
	local var_34_12 = hell_shark[3]
	local texture_size = tbl_2.style.divider_left.texture_size
	local num_5 = -80

	for i = 1, #arg_34_2 do
		local var_34_15 = arg_34_2[i]
		local key = var_34_15.key
		local str = key .. "_header"

		table.insert(tbl_2.element.passes, {
			pass_type = "text",
			text_id = str,
			style_id = str
		})

		tbl_2.content[str] = Localize("search_filter_" .. key)
		tbl_2.style[str] = {
			vertical_alignment = "top",
			upper_case = true,
			horizontal_alignment = "left",
			font_type = "hell_shark",
			font_size = num,
			text_color = Colors.get_table("font_button_normal"),
			offset = {
				num_2,
				-10 + num_5,
				3
			}
		}

		local num_6 = 200
		local var_34_19 = num_6

		for j = 1, #var_34_15 do
			local var_34_20 = var_34_15[j]
			local var_34_21 = var_34_20[1]
			local var_34_22 = var_34_20[2]
			local match = string.match(Localize(var_34_22), "^[^,]+")
			local num_7 = 10 + UIRenderer.text_size(arg_34_1, match, var_34_10, max, var_34_12)

			if var_34_19 + num_7 >= tbl[1] - num_2 then
				var_34_19 = num_6
				num_5 = num_5 - num_3
				texture_size[1] = texture_size[1] + num_3
				tbl[2] = tbl[2] + num_3
			end

			local str_2 = str .. "_hotspot_" .. var_34_22

			table.insert(tbl_2.element.passes, {
				pass_type = "hotspot",
				content_id = str_2,
				style_id = str_2
			})

			tbl_2.content[str_2] = {}
			tbl_2.style[str_2] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				area_size = {
					num_7,
					30
				},
				offset = {
					var_34_19,
					-5 + num_5,
					3
				}
			}

			local str_3 = str .. "_rect_" .. var_34_20[2]

			table.insert(tbl_2.element.passes, {
				pass_type = "rect",
				style_id = str_3,
				content_change_function = function (self, arg_39_1)
					-- function 39
					local var_39_0 = self[str_2]
					local flag = var_34_21 == self.query[key]
					local var_39_2

					if not flag then
						var_39_2 = tbl_22

						if not var_39_2 then
							-- Nothing
						end
					end

					var_39_2 = tbl_21

					::label_39_0::

					Colors.copy_to(arg_39_1.color, var_39_2)

					local color = arg_39_1.color
					local flag_2

					flag_2 = not var_39_0.is_hover and 255 and 175
					color[1] = flag_2

					if not var_39_0.on_pressed then
						if not flag then
							self.query[key] = nil
						else
							self.query[key] = var_34_21
						end

						self.query_dirty = true
					end
				end
			})

			tbl_2.style[str_3] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					num_7,
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
					-7 + num_5,
					4
				}
			}

			local frame_outer_glow_01_white = UIFrameSettings.frame_outer_glow_01_white
			local var_34_28 = frame_outer_glow_01_white.texture_sizes.corner[1]
			local str_4 = str .. "_texture_frame_" .. var_34_20[2]

			table.insert(tbl_2.element.passes, {
				pass_type = "texture_frame",
				texture_id = str_4 .. "_id",
				style_id = str_4,
				content_check_function = function (self, arg_40_1)
					-- function 40
					return not Managers.input:is_device_active("gamepad") and self.gamepad_button_index[1] ~= j or self.gamepad_button_index[2] == i
				end
			})

			tbl_2.content[str_4 .. "_id"] = frame_outer_glow_01_white.texture
			tbl_2.style[str_4] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = frame_outer_glow_01_white.texture_size,
				texture_sizes = frame_outer_glow_01_white.texture_sizes,
				color = Colors.get_table("font_title"),
				offset = {
					var_34_19 - var_34_28,
					num_5 + var_34_28 - 7,
					5
				},
				area_size = {
					num_7 + var_34_28 * 2,
					30 + var_34_28 * 2
				}
			}

			local str_5 = str .. "_fade1_" .. var_34_20[2]

			table.insert(tbl_2.element.passes, {
				pass_type = "texture",
				texture_id = str_5,
				style_id = str_5
			})

			tbl_2.content[str_5] = "button_state_default"
			tbl_2.style[str_5] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					num_7,
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
					-7 + num_5,
					5
				}
			}

			local str_6 = str .. "_fade2_" .. var_34_20[2]

			table.insert(tbl_2.element.passes, {
				pass_type = "texture",
				texture_id = str_6,
				style_id = str_6
			})

			tbl_2.content[str_6] = "button_bg_fade"
			tbl_2.style[str_6] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					num_7,
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
					-7 + num_5,
					6
				}
			}

			local str_7 = str .. "_fade3_" .. var_34_20[2]

			table.insert(tbl_2.element.passes, {
				pass_type = "texture",
				texture_id = str_7,
				style_id = str_7
			})

			tbl_2.content[str_7] = "menu_frame_glass_01"
			tbl_2.style[str_7] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					num_7,
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
					-7 + num_5,
					7
				}
			}

			local str_8 = str .. "_text_" .. var_34_20[2]

			table.insert(tbl_2.element.passes, {
				pass_type = "text",
				text_id = str_8,
				style_id = str_8
			})

			tbl_2.content[str_8] = match
			tbl_2.style[str_8] = {
				vertical_alignment = "top",
				font_type = "hell_shark",
				font_size = 20,
				horizontal_alignment = "left",
				text_color = Colors.get_table("font_default"),
				offset = {
					5 + var_34_19,
					-10 + num_5,
					10
				}
			}
			var_34_19 = var_34_19 + 10 + num_7
		end

		local num_8 = num_3 + num_4

		num_5 = num_5 - num_8
		texture_size[1] = texture_size[1] + num_8
		tbl[2] = tbl[2] + num_8
	end

	return tbl_2
end

local flag = true
local tbl_23 = {
	window = UIWidgets.create_frame("window", tbl_13.window.size, "menu_frame_11", 40),
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
	left_window_frame = UIWidgets.create_frame("left_window", tbl_13.left_window.size, "menu_frame_11", 20),
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
	right_window_frame = UIWidgets.create_frame("right_window", tbl_13.right_window.size, "menu_frame_11", 20),
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
		tbl_5[1] / 2,
		15
	}, "achievement_window_mask_bottom"),
	achievement_window_mask_top = UIWidgets.create_simple_texture("mask_rect_edge_fade", "achievement_window_mask_top"),
	exit_button = UIWidgets.create_default_button("exit_button", tbl_13.exit_button.size, nil, nil, Localize("menu_close"), 24, nil, "button_detail_04", 34, flag),
	summary_button = UIWidgets.create_default_button("summary_button", tbl_13.summary_button.size, nil, nil, Localize("achv_menu_summary_category_title"), 24),
	quests_button = UIWidgets.create_window_category_button("quests_button", tbl_13.quests_button.size, Localize("achv_menu_quests_category_title"), "achievement_button_icon_quests", "achievement_button_background_quests", true),
	achievements_button = UIWidgets.create_window_category_button_mirrored("achievements_button", tbl_13.achievements_button.size, Localize("achv_menu_achievements_category_title"), "achievement_button_icon_achievements", "achievement_button_background_achievements", true),
	title = UIWidgets.create_simple_texture("frame_title_bg", "title"),
	title_bg = UIWidgets.create_background("title_bg", tbl_13.title_bg.size, "menu_frame_bg_02"),
	title_text = UIWidgets.create_simple_text(Localize("achv_menu_title"), "title_text", nil, nil, tbl_19),
	achievement_scrollbar = UIWidgets.create_chain_scrollbar("achievement_scrollbar", nil, tbl_13.achievement_scrollbar.size),
	category_scrollbar = UIWidgets.create_chain_scrollbar("category_scrollbar", "category_window_mask", tbl_13.category_scrollbar.size),
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
					scroll_function = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5)
						-- function 41
						local num = arg_41_4.y * -1

						if not (not IS_XB1 and not GameSettingsDevelopment.allow_keyboard_mouse and Managers.input:is_device_active("gamepad")) then
							num = math.sign(arg_41_4.x) * -1
						end

						local hotspot = arg_41_2.hotspot

						if num == 0 or not hotspot.is_hover then
							arg_41_2.axis_input = num
							arg_41_2.scroll_add = num * arg_41_2.scroll_amount
						else
							local axis_input = arg_41_2.axis_input
						end

						local scroll_add = arg_41_2.scroll_add

						if not scroll_add then
							local num_2 = scroll_add * (arg_41_5 * 5)
							local num_3 = scroll_add - num_2

							if math.abs(num_3) > 0 then
								arg_41_2.scroll_add = num_3
							else
								arg_41_2.scroll_add = nil
							end

							local scroll_value = arg_41_2.scroll_value

							arg_41_2.scroll_value = math.clamp(scroll_value + num_2, 0, 1)
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
local tbl_24 = {
	input = fn_6("search_input")
}
local tbl_25 = {
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
	time_left_text = UIWidgets.create_simple_text(Localize("achv_menu_summary_quest_refresh") .. " 00:00:00", "quest_timer", nil, nil, tbl_14),
	overlay = UIWidgets.create_simple_rect("achievement_window_mask", {
		220,
		12,
		12,
		12
	}, 4),
	overlay_fade = UIWidgets.create_simple_texture("options_window_fade_01", "achievement_window_mask", nil, nil, nil, 5),
	overlay_text = UIWidgets.create_simple_text(Localize("achv_menu_no_quests_text"), "achievement_window_mask", nil, nil, tbl_17),
	claim_all_quests = fn_7("claim_all_button_anchor", {
		300,
		44
	})
}
local tbl_26 = {
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
	overlay_text = UIWidgets.create_simple_text(Localize("achv_menu_no_quests_text"), "achievement_window_mask", nil, nil, tbl_17),
	claim_all_achievements = fn_7("claim_all_button_anchor", {
		300,
		44
	})
}
local tbl_27 = {
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
local tbl_28 = {
	summary_center_window = UIWidgets.create_simple_texture("achievement_summary_bg", "summary_center_window_fade"),
	summary_center_window_frame = UIWidgets.create_frame("summary_center_window", tbl_13.summary_center_window.size, "menu_frame_11", 30),
	summary_center_text = UIWidgets.create_simple_text(Localize("achv_menu_summary_description_text"), "summary_center_text", nil, nil, tbl_18),
	summary_right_window_frame = UIWidgets.create_frame("summary_right_window", tbl_13.summary_right_window.size, "menu_frame_11", 20),
	summary_right_window_button = fn_3("summary_right_window_fade", "achievement_challenges_bg"),
	summary_right_arrow = UIWidgets.create_simple_texture("achievement_arrow_hover", "summary_right_arrow"),
	summary_right_title = UIWidgets.create_simple_text(Localize("achv_menu_summary_overview_title"), "summary_right_title", nil, nil, tbl_20),
	summary_right_title_divider = UIWidgets.create_simple_texture("divider_01_top", "summary_right_title_divider"),
	summary_achievement_bar_1 = UIWidgets.create_statistics_bar("summary_achievement_bar_1", tbl_13.summary_achievement_bar_1.size),
	summary_achievement_bar_2 = UIWidgets.create_statistics_bar("summary_achievement_bar_2", tbl_13.summary_achievement_bar_2.size),
	summary_achievement_bar_3 = UIWidgets.create_statistics_bar("summary_achievement_bar_3", tbl_13.summary_achievement_bar_3.size),
	summary_achievement_bar_4 = UIWidgets.create_statistics_bar("summary_achievement_bar_4", tbl_13.summary_achievement_bar_4.size),
	summary_achievement_bar_5 = UIWidgets.create_statistics_bar("summary_achievement_bar_5", tbl_13.summary_achievement_bar_5.size),
	summary_achievement_bar_6 = UIWidgets.create_statistics_bar("summary_achievement_bar_6", tbl_13.summary_achievement_bar_6.size),
	summary_quest_bar_background_1 = fn_5("summary_quest_bar_background_1"),
	summary_quest_bar_background_2 = fn_5("summary_quest_bar_background_2"),
	summary_quest_bar_background_3 = fn_5("summary_quest_bar_background_3"),
	summary_quest_bar_1 = UIWidgets.create_quest_bar("summary_quest_bar_1", tbl_13.summary_quest_bar_1.size),
	summary_quest_bar_2 = UIWidgets.create_quest_bar("summary_quest_bar_2", tbl_13.summary_quest_bar_2.size),
	summary_quest_bar_3 = UIWidgets.create_quest_bar("summary_quest_bar_3", tbl_13.summary_quest_bar_3.size),
	summary_quest_bar_title_1 = UIWidgets.create_simple_text(Localize("achv_menu_daily_category_title"), "summary_quest_bar_title_1", nil, nil, tbl_15),
	summary_quest_bar_title_2 = UIWidgets.create_simple_text(Localize("achv_menu_weekly_category_title"), "summary_quest_bar_title_2", nil, nil, tbl_15),
	summary_quest_bar_title_3 = UIWidgets.create_simple_text(Localize("achv_menu_event_category_title"), "summary_quest_bar_title_3", nil, nil, tbl_15),
	summary_quest_bar_timer_1 = UIWidgets.create_simple_text("", "summary_quest_bar_title_1", nil, nil, tbl_16),
	summary_quest_bar_timer_2 = UIWidgets.create_simple_text("", "summary_quest_bar_title_2", nil, nil, tbl_16),
	summary_quest_bar_timer_3 = UIWidgets.create_simple_text("", "summary_quest_bar_title_3", nil, nil, tbl_16),
	summary_left_window_frame = UIWidgets.create_frame("summary_left_window", tbl_13.summary_left_window.size, "menu_frame_11", 20),
	summary_left_window_button = fn_3("summary_left_window_fade", "achievement_quests_bg"),
	summary_left_arrow = UIWidgets.create_simple_texture("achievement_arrow_hover", "summary_left_arrow"),
	summary_left_title = UIWidgets.create_simple_text(Localize("achv_menu_summary_quests_available"), "summary_left_title", nil, nil, tbl_20),
	summary_left_title_divider = UIWidgets.create_simple_texture("divider_01_top", "summary_left_title_divider"),
	summary_quest_book = fn_4("summary_quest_book"),
	summary_achievement_flag = UIWidgets.create_simple_texture("achievement_menu_flag", "summary_achievement_flag")
}

function create_category_tab_widgets()
	-- function 42
	local tbl = {}
	local num_achievement_categories = Managers.state.achievement:num_achievement_categories()

	for i = 1, num_achievement_categories + 1 do
		local flag = i == 1
		local str = "category_tab_" .. i
		local str_2 = "category_tab_" .. i .. "_list"
		local str_3 = "category_tab_" .. i - 1
		local str_4 = "category_tab_" .. i - 1 .. "_list"
		local var_42_7 = tbl_13
		local tbl_2 = {
			horizontal_alignment = "center"
		}
		local flag_2

		flag_2 = not flag and "category_root" and str_4
		tbl_2.parent = flag_2

		local flag_3

		flag_3 = not flag and "top" and "bottom"
		tbl_2.vertical_alignment = flag_3
		tbl_2.size = tbl_9

		local tbl_3 = {
			nil,
			nil,
			0
		}
		local flag_4

		flag_4 = not flag and -15 and 0
		tbl_3[1] = flag_4

		local flag_5

		flag_5 = not flag and -20 and -(tbl_9[2] + num_6)
		tbl_3[2] = flag_5
		tbl_2.position = tbl_3
		var_42_7[str] = tbl_2
		tbl_13[str_2] = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			parent = str,
			size = {
				tbl_9[1],
				0
			},
			position = {
				0,
				-(tbl_9[2] + num_6),
				0
			}
		}
		tbl[i] = fn(str, tbl_9, "n/a", str_2)
	end

	return tbl
end

local var_0_51 = var_0_0("achievement_entry", tbl_3)
local var_0_52 = var_0_1("achievement_entry", tbl_3)
local tbl_29 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				-- function 43
				arg_43_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				-- function 44
				local easeOutCubic = math.easeOutCubic(arg_44_3)

				arg_44_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				-- function 45
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				-- function 46
				arg_46_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
				-- function 47
				local easeOutCubic = math.easeOutCubic(arg_47_3)

				arg_47_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
				-- function 48
				return
			end
		}
	}
}
local tbl_30 = {
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
	generic_input_actions = tbl_30,
	search_widget_definitions = tbl_24,
	quest_widgets = tbl_25,
	achievement_widgets = tbl_26,
	category_tab_info = tbl_12,
	achievement_spacing = num_4,
	checklist_entry_size = tbl_7,
	achievement_entry_size = tbl_3,
	achievement_window_size = tbl_5,
	achievement_scrollbar_size = tbl_6,
	achievement_presentation_amount = num_3,
	quest_scrollbar_bottom_inset = num_5,
	widgets = tbl_23,
	overlay_widgets = tbl_27,
	summary_widgets = tbl_28,
	create_category_tab_widgets_func = create_category_tab_widgets,
	scenegraph_definition = tbl_13,
	animation_definitions = tbl_29,
	quest_entry_definition = var_0_51,
	achievement_entry_definition = var_0_52,
	console_cursor_definition = UIWidgets.create_console_cursor("console_cursor"),
	virtual_keyboard_anchor_point = {
		230,
		350
	},
	create_search_filters_widget = fn_8
}
