-- chunkname: @scripts/ui/views/character_inspect_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	124,
	124
}
local var_0_3 = 30
local var_0_4 = 7
local var_0_5 = 50
local var_0_6 = {
	var_0_2[1] * var_0_4 + (var_0_4 - 1) * var_0_3 + var_0_5 * 2,
	550
}
local var_0_7 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.ingame_player_list + 50
		},
		size = {
			var_0_0,
			var_0_1
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
			var_0_0,
			var_0_1 - 360
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
			var_0_6[1],
			var_0_6[2]
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
			var_0_6[1] - var_0_5 * 2,
			var_0_2[2] + var_0_3
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
			var_0_6[1],
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
			var_0_6[1] - var_0_5 * 2,
			var_0_2[2] + var_0_3
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
			var_0_6[1],
			50
		}
	},
	item_slot = {
		vertical_alignment = "center",
		parent = "item_background",
		horizontal_alignment = "left",
		position = {
			var_0_3 / 2,
			0,
			5
		},
		size = {
			var_0_2[1],
			var_0_2[2]
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
local var_0_8 = {
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
local var_0_9 = {
	240,
	5,
	5,
	5
}
local var_0_10 = {
	200,
	10,
	10,
	10
}
local var_0_11 = {
	item_title = UIWidgets.create_simple_text("equipment", "item_title", nil, nil, var_0_8),
	talents_title = UIWidgets.create_simple_text("talents", "talents_title", nil, nil, var_0_8),
	rect = UIWidgets.create_simple_rect("rect", var_0_9),
	background = UIWidgets.create_background_with_frame("background", var_0_7.background.size, "menu_frame_bg_01", "menu_frame_02"),
	item_background = UIWidgets.create_rect_with_frame("item_background", var_0_7.item_background.size, var_0_10, "menu_frame_06"),
	talents_background = UIWidgets.create_rect_with_frame("talents_background", var_0_7.talents_background.size, var_0_10, "menu_frame_06"),
	loadout = UIWidgets.create_loadout_grid("item_slot", var_0_2, var_0_4, var_0_3, true),
	portrait = UIWidgets.create_portrait_frame("portrait_pivot", "default", "-", 1, nil, "unit_frame_portrait_way_watcher")
}

return {
	scenegraph_definition = var_0_7,
	widget_definitions = var_0_11
}
