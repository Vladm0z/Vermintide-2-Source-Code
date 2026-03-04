-- chunkname: @scripts/ui/hud_ui/gameplay_info_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = false
local var_0_3 = {
	screen = {
		scale = "hud_scale_fit",
		size = {
			var_0_0,
			var_0_1
		},
		position = {
			0,
			0,
			UILayer.hud
		}
	},
	center_screen = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			512,
			256
		},
		position = {
			0,
			-var_0_1 * 0.3,
			15
		}
	},
	teleport_text = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			800,
			50
		},
		position = {
			0,
			200,
			2
		}
	},
	spawn_text = {
		vertical_alignment = "bottom",
		parent = "teleport_text",
		horizontal_alignment = "center",
		size = {
			800,
			50
		},
		position = {
			0,
			110,
			2
		}
	},
	spawn_reason = {
		vertical_alignment = "bottom",
		parent = "spawn_text",
		horizontal_alignment = "center",
		size = {
			800,
			50
		},
		position = {
			0,
			-48,
			2
		}
	},
	spawn_info = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			550,
			200
		},
		position = {
			0,
			40,
			2
		}
	},
	spawn_info_text = {
		vertical_alignment = "center",
		parent = "spawn_info",
		horizontal_alignment = "right",
		size = {
			400,
			184
		},
		position = {
			16,
			0,
			4
		}
	}
}
local var_0_4 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = false,
	draw_text_rect = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("light_gray", 255),
	rect_color = Colors.get_color_table_with_alpha("black", 0),
	offset = {
		0,
		0,
		2
	},
	shadow_offset = {
		1,
		1,
		0
	}
}
local var_0_5 = {
	font_size = 40,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	draw_text_rect = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	rect_color = Colors.get_color_table_with_alpha("black", 0),
	offset = {
		0,
		0,
		10
	},
	shadow_offset = {
		1,
		1,
		0
	}
}
local var_0_6 = {
	font_size = 24,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	draw_text_rect = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	rect_color = Colors.get_color_table_with_alpha("dark_red", 100),
	offset = {
		0,
		0,
		10
	},
	shadow_offset = {
		1,
		1,
		0
	}
}
local var_0_7 = {
	teleport_text = UIWidgets.create_simple_text("", "teleport_text", nil, nil, var_0_4, nil, var_0_2)
}
local var_0_8 = {
	spawn_text = UIWidgets.create_simple_text("", "spawn_text", nil, nil, var_0_5, nil, var_0_2),
	spawn_reason = UIWidgets.create_simple_text("", "spawn_reason", nil, nil, var_0_6, nil, var_0_2)
}
local var_0_9 = {}

return {
	scenegraph = var_0_3,
	widgets = var_0_7,
	spawn_info_widgets = var_0_8,
	animation_definitions = var_0_9
}
