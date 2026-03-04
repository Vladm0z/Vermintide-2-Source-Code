-- chunkname: @scripts/ui/views/disconnect_indicator_view_definitions.lua

local var_0_0 = 64
local var_0_1 = 8
local var_0_2 = 200
local var_0_3 = 800
local var_0_4 = {
	screen = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		scale = "fit",
		position = {
			0,
			0,
			UILayer.transition
		},
		size = {
			1920,
			1080
		}
	},
	indicator = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			var_0_0,
			var_0_0
		},
		position = {
			0,
			var_0_2,
			1
		}
	},
	text = {
		vertical_alignment = "center",
		parent = "indicator",
		horizontal_alignment = "left",
		size = {
			var_0_3,
			100
		},
		position = {
			var_0_0 + var_0_1,
			0,
			1
		}
	}
}

if not IS_WINDOWS then
	var_0_4.screen.scale = "hud_fit"
end

local function var_0_5(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				}
			}
		},
		content = {
			texture_id = arg_1_0,
			text = arg_1_1
		},
		style = {
			text = arg_1_4 or {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 26,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				scenegraph_id = arg_1_3
			},
			texture_id = {
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_1_2
	}
end

return {
	scenegraph_definition = var_0_4,
	icon_text = var_0_5("icon_connection_lost", "", "indicator", "text", nil),
	padding = var_0_1,
	max_text_width = var_0_3
}
