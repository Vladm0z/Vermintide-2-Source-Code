-- chunkname: @scripts/ui/diorama/hero_diorama_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	screen = {
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
		},
		scale = not IS_WINDOWS and "hud_fit" or "fit"
	},
	background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			500,
			500
		},
		position = {
			0,
			0,
			0
		}
	},
	viewport = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			500,
			500
		},
		position = {
			0,
			0,
			0
		}
	},
	portrait_pivot = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			63,
			69,
			10
		}
	},
	corner_top_left = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			10
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "right",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			10
		}
	},
	corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "bottom_panel",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			0,
			100,
			1
		}
	},
	corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "bottom_panel",
		horizontal_alignment = "right",
		size = {
			110,
			110
		},
		position = {
			0,
			100,
			1
		}
	},
	bottom_panel = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "right",
		size = {
			500,
			100
		},
		position = {
			0,
			5,
			1
		}
	},
	bottom_panel_edge = {
		vertical_alignment = "top",
		parent = "bottom_panel",
		horizontal_alignment = "center",
		size = {
			500,
			5
		},
		position = {
			0,
			0,
			1
		}
	},
	hero_text_box = {
		vertical_alignment = "top",
		parent = "bottom_panel",
		horizontal_alignment = "center",
		size = {
			500,
			100
		},
		position = {
			20,
			5,
			10
		}
	},
	player_text_box = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			500,
			100
		},
		position = {
			0,
			-5,
			10
		}
	}
}
local var_0_3 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 36,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		10,
		2
	}
}
local var_0_4 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 20,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "arial",
	text_color = {
		255,
		160,
		160,
		160
	},
	offset = {
		0,
		-25,
		2
	}
}

local function var_0_5(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_2 = arg_1_2 or "menu_frame_bg_01"

	local var_1_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_1_2)
	local var_1_1 = {
		element = {}
	}
	local var_1_2 = {
		{
			style_id = "background",
			pass_type = "texture_uv",
			content_id = "background"
		}
	}
	local var_1_3 = {
		background = {
			uvs = {
				{
					0.5,
					1
				},
				{
					0.5 - math.min(arg_1_1[1] / var_1_0.size[1], 1),
					1 - math.min(arg_1_1[2] / var_1_0.size[2], 1)
				}
			},
			texture_id = arg_1_2
		}
	}
	local var_1_4 = {
		background = {
			color = arg_1_3 or {
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

	var_1_1.element.passes = var_1_2
	var_1_1.content = var_1_3
	var_1_1.style = var_1_4
	var_1_1.offset = {
		0,
		0,
		0
	}
	var_1_1.scenegraph_id = arg_1_0

	return var_1_1
end

local var_0_6 = {
	overlay = UIWidgets.create_simple_rect("viewport", {
		255,
		0,
		0,
		0
	}),
	background = UIWidgets.create_simple_texture("default_offscreen_write_mask", "background"),
	corner_top_left = UIWidgets.create_simple_texture("athanor_decoration_corner", "corner_top_left"),
	corner_top_right = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "corner_top_right"),
	corner_bottom_left = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			1,
			1
		},
		{
			0,
			0
		}
	}, "corner_bottom_right"),
	frame = UIWidgets.create_frame("background", var_0_2.background.size, "menu_frame_12", 11),
	viewport_frame = UIWidgets.create_frame("viewport", var_0_2.background.size, "frame_inner_glow_01", 1, {
		255,
		0,
		0,
		0
	}, {
		5,
		5
	}),
	bottom_panel_edge = UIWidgets.create_simple_texture("menu_frame_09_divider", "bottom_panel_edge"),
	career_name = UIWidgets.create_simple_text("", "hero_text_box", nil, nil, var_0_3),
	player_name = UIWidgets.create_simple_text("", "hero_text_box", nil, nil, var_0_4)
}
local var_0_7 = {}

return {
	animation_definitions = var_0_7,
	scenegraph_definition = var_0_2,
	widget_definitions = var_0_6,
	create_panel_background = var_0_5
}
