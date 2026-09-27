-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_custom_game_settings_definitions.lua

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
	container = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			660,
			380
		},
		position = {
			0,
			-100,
			10
		}
	},
	settings_anchor = {
		vertical_alignment = "top",
		parent = "container",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-10,
			1
		}
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	arg_1_1 = arg_1_1 or {
		600,
		380
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "mask",
					texture_id = "mask"
				},
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot"
				}
			}
		},
		content = {
			mask = "mask_rect",
			hotspot = {}
		},
		style = {
			mask = {
				texture_size = arg_1_1,
				offset = {
					0,
					0,
					0
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			hotspot = {
				size = arg_1_1,
				offset = {
					0,
					0,
					0
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local tbl_2 = {
	background = UIWidgets.create_rect_with_outer_frame("container", tbl.container.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	mask = fn("container", tbl.container.size)
}
local tbl_3 = {}

return {
	scenegraph_definition = tbl,
	widget_definitions = tbl_2,
	animation_definitions = tbl_3
}
