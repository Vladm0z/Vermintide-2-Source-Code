-- chunkname: @scripts/ui/views/area_indicator_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
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
			var_0_0,
			50
		}
	}
}

if not IS_WINDOWS then
	var_0_2.screen.scale = "hud_fit"
end

local var_0_3 = {
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
local var_0_4 = {
	area_text_box = UIWidgets.create_simple_text("placeholder_area_text", "area_text_box", nil, nil, var_0_3)
}

return {
	scenegraph_definition = var_0_2,
	widget_definitions = var_0_4
}
