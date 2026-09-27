-- chunkname: @scripts/ui/views/character_inspect_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	124,
	124
}
local num_3 = 30
local num_4 = 7
local num_5 = 50
local tbl_2 = {
	tbl[1] * num_4 + (num_4 - 1) * num_3 + num_5 * 2,
	550
}
local tbl_3 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.ingame_player_list + 50
		},
		size = {
			num,
			num_2
		}
	},
	screen = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			1920,
			1080
		}
	},
	rect = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			160,
			1
		},
		size = {
			num,
			num_2 - 360
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "rect",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			tbl_2[1],
			tbl_2[2]
		}
	},
	item_background = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			-80,
			1
		},
		size = {
			tbl_2[1] - num_5 * 2,
			tbl[2] + num_3
		}
	},
	item_title = {
		vertical_alignment = "top",
		parent = "item_background",
		horizontal_alignment = "center",
		position = {
			0,
			50,
			1
		},
		size = {
			tbl_2[1],
			50
		}
	},
	talents_background = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			-300,
			1
		},
		size = {
			tbl_2[1] - num_5 * 2,
			tbl[2] + num_3
		}
	},
	talents_title = {
		vertical_alignment = "top",
		parent = "talents_background",
		horizontal_alignment = "center",
		position = {
			0,
			50,
			1
		},
		size = {
			tbl_2[1],
			50
		}
	},
	item_slot = {
		vertical_alignment = "center",
		parent = "item_background",
		horizontal_alignment = "left",
		position = {
			num_3 / 2,
			0,
			5
		},
		size = {
			tbl[1],
			tbl[2]
		}
	},
	portrait_pivot = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			10
		},
		size = {
			0,
			0
		}
	}
}
local tbl_4 = {
	word_wrap = true,
	upper_case = true,
	localize = true,
	font_size = 28,
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
local tbl_5 = {
	240,
	5,
	5,
	5
}
local tbl_6 = {
	200,
	10,
	10,
	10
}
local tbl_7 = {
	item_title = UIWidgets.create_simple_text("equipment", "item_title", nil, nil, tbl_4),
	talents_title = UIWidgets.create_simple_text("talents", "talents_title", nil, nil, tbl_4),
	rect = UIWidgets.create_simple_rect("rect", tbl_5),
	background = UIWidgets.create_background_with_frame("background", tbl_3.background.size, "menu_frame_bg_01", "menu_frame_02"),
	item_background = UIWidgets.create_rect_with_frame("item_background", tbl_3.item_background.size, tbl_6, "menu_frame_06"),
	talents_background = UIWidgets.create_rect_with_frame("talents_background", tbl_3.talents_background.size, tbl_6, "menu_frame_06"),
	loadout = UIWidgets.create_loadout_grid("item_slot", tbl, num_4, num_3, true),
	portrait = UIWidgets.create_portrait_frame("portrait_pivot", "default", "-", 1, nil, "unit_frame_portrait_way_watcher")
}

return {
	scenegraph_definition = tbl_3,
	widget_definitions = tbl_7
}
