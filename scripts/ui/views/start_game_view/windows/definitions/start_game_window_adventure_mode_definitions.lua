-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_adventure_mode_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = UIFrameSettings[var_0_1].texture_sizes.vertical[1]
local var_0_4 = var_0_2[1] - (var_0_3 * 2 + 60)
local var_0_5 = {
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
		size = var_0_2,
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
			var_0_4,
			var_0_2[2] / 2
		},
		position = {
			0,
			0,
			1
		}
	},
	adventure_texture = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			383,
			383
		},
		position = {
			0,
			0,
			1
		}
	},
	adventure_title_divider = {
		vertical_alignment = "bottom",
		parent = "adventure_texture",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-20,
			1
		}
	},
	adventure_title = {
		vertical_alignment = "bottom",
		parent = "adventure_title_divider",
		horizontal_alignment = "center",
		size = {
			var_0_4,
			50
		},
		position = {
			0,
			20,
			1
		}
	}
}
local var_0_6 = {
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
local var_0_7 = {
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
local var_0_8 = {
	background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window"),
	background_mask = UIWidgets.create_simple_texture("mask_rect", "window"),
	window = UIWidgets.create_frame("window", var_0_2, var_0_1, 20),
	description_text = UIWidgets.create_simple_text(Localize("start_game_window_adventure_mode_desc"), "description_text", nil, nil, var_0_7),
	adventure_title = UIWidgets.create_simple_text(Localize("start_game_window_adventure_mode_title"), "adventure_title", nil, nil, var_0_6),
	adventure_texture = UIWidgets.create_simple_texture("adventure_icon", "adventure_texture"),
	adventure_title_divider = UIWidgets.create_simple_texture("divider_01_top", "adventure_title_divider")
}

return {
	widgets = var_0_8,
	scenegraph_definition = var_0_5
}
