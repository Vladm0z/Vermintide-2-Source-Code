-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_definitions.lua

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
	description_text = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			num,
			size[2] / 2
		},
		position = {
			0,
			0,
			1
		}
	},
	weave_texture = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			246,
			252
		},
		position = {
			0,
			-65,
			1
		}
	},
	weave_title_divider = {
		vertical_alignment = "bottom",
		parent = "weave_texture",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-85,
			1
		}
	},
	weave_title = {
		vertical_alignment = "bottom",
		parent = "weave_title_divider",
		horizontal_alignment = "center",
		size = {
			num,
			50
		},
		position = {
			0,
			20,
			1
		}
	}
}
local tbl_2 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
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
	vertical_alignment = "top",
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
	description_text = UIWidgets.create_simple_text(Localize("start_game_window_weave_desc"), "description_text", nil, nil, tbl_3),
	weave_title = UIWidgets.create_simple_text(Localize("start_game_window_weave_title"), "weave_title", nil, nil, tbl_2),
	weave_texture = UIWidgets.create_simple_texture("weaves_icon", "weave_texture"),
	weave_title_divider = UIWidgets.create_simple_texture("divider_01_top", "weave_title_divider")
}

return {
	widgets = tbl_4,
	scenegraph_definition = tbl
}
