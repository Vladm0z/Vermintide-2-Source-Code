-- chunkname: @scripts/ui/views/area_indicator_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			num,
			num_2
		}
	},
	area_text_box = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			-310,
			100
		},
		size = {
			num,
			50
		}
	}
}

if not IS_WINDOWS then
	tbl.screen.scale = "hud_fit"
end

local tbl_2 = {
	word_wrap = false,
	font_size = 52,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
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
	area_text_box = UIWidgets.create_simple_text("placeholder_area_text", "area_text_box", nil, nil, tbl_2)
}

return {
	scenegraph_definition = tbl,
	widget_definitions = tbl_3
}
