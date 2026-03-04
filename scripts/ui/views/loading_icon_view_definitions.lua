-- chunkname: @scripts/ui/views/loading_icon_view_definitions.lua

local var_0_0 = {
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
	loading_icon = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			114,
			114
		},
		position = {
			-90,
			114,
			1
		}
	}
}

local function var_0_1(arg_1_0, arg_1_1)
	return {
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "background_rect"
				},
				{
					texture_id = "loading_icon_id",
					style_id = "loading_icon",
					pass_type = "texture"
				}
			}
		},
		content = {
			current_index = 0,
			loading_icon_id = arg_1_0
		},
		style = {
			background_rect = {
				offset = {
					0,
					0,
					-1
				},
				color = {
					0,
					0,
					0,
					0
				}
			},
			loading_icon = {
				color = {
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
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_1
	}
end

return {
	scenegraph_definition = var_0_0,
	loading_icon = var_0_1("default", "loading_icon")
}
