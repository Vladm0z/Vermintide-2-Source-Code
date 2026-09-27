-- chunkname: @scripts/ui/views/disconnect_indicator_view_definitions.lua

local num = 64
local num_2 = 8
local num_3 = 200
local num_4 = 800
local tbl = {
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
			num,
			num
		},
		position = {
			0,
			num_3,
			1
		}
	},
	text = {
		vertical_alignment = "center",
		parent = "indicator",
		horizontal_alignment = "left",
		size = {
			num_4,
			100
		},
		position = {
			num + num_2,
			0,
			1
		}
	}
}

if not IS_WINDOWS then
	tbl.screen.scale = "hud_fit"
end

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
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
	scenegraph_definition = tbl,
	icon_text = fn("icon_connection_lost", "", "indicator", "text", nil),
	padding = num_2,
	max_text_width = num_4
}
