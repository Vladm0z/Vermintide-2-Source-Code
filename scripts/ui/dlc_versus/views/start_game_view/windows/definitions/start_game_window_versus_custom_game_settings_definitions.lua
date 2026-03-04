-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_custom_game_settings_definitions.lua

local var_0_0 = {
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

local function var_0_1(arg_1_0, arg_1_1)
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

local var_0_2 = {
	background = UIWidgets.create_rect_with_outer_frame("container", var_0_0.container.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	mask = var_0_1("container", var_0_0.container.size)
}
local var_0_3 = {}

return {
	scenegraph_definition = var_0_0,
	widget_definitions = var_0_2,
	animation_definitions = var_0_3
}
