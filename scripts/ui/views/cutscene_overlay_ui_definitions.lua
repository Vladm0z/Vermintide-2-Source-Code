-- chunkname: @scripts/ui/views/cutscene_overlay_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			200
		},
		size = {
			num,
			num_2
		}
	},
	text_area = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			num - 100,
			num_2 - 100
		}
	},
	image_area = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			0,
			0
		}
	}
}
local tbl_2 = {
	word_wrap = false,
	font_size = 52,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 0),
	default_text_color = Colors.get_color_table_with_alpha("white", 0),
	offset = {
		0,
		0,
		1
	}
}
local tbl_3 = {
	text = UIWidgets.create_simple_text("", "text_area", nil, nil, tbl_2),
	image = {
		scenegraph_id = "image_area",
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				}
			}
		},
		content = {
			texture_id = "icons_placeholder"
		},
		style = {
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					50,
					50
				},
				color = {
					0,
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
		},
		offset = {
			0,
			0,
			0
		}
	}
}

return {
	scenegraph_definition = tbl,
	widget_definitions = tbl_3
}
