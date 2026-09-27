-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_event_definitions.lua

local game_start_windows = UISettings.game_start_windows
local frame = game_start_windows.frame
local size = game_start_windows.size
local var_0_3 = UIFrameSettings[frame].texture_sizes.vertical[1]
local num = size[1] - (var_0_3 * 2 + 60)
local tbl = {
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
	root_fit = {
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
		size = size,
		position = {
			0,
			0,
			1
		}
	},
	event_texture = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			480,
			564
		},
		position = {
			0,
			-60,
			1
		}
	},
	event_title = {
		vertical_alignment = "top",
		parent = "event_texture",
		horizontal_alignment = "center",
		size = {
			300,
			80
		},
		position = {
			0,
			-40,
			1
		}
	},
	description_text = {
		vertical_alignment = "bottom",
		parent = "event_texture",
		horizontal_alignment = "center",
		size = {
			300,
			120
		},
		position = {
			0,
			10,
			1
		}
	}
}
local tbl_2 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 52,
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
local tbl_3 = {
	word_wrap = true,
	font_size = 22,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_4 = {
	background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window"),
	background_mask = UIWidgets.create_simple_texture("mask_rect", "window"),
	window = UIWidgets.create_frame("window", size, frame, 20),
	description_text = UIWidgets.create_simple_text("", "description_text", nil, nil, tbl_3),
	event_title = UIWidgets.create_simple_text("", "event_title", nil, nil, tbl_2),
	event_texture = UIWidgets.create_simple_texture("adventure_icon", "event_texture")
}

return {
	widgets = tbl_4,
	scenegraph_definition = tbl
}
