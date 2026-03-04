-- chunkname: @scripts/ui/views/console_cursor_view_definitions.lua

local var_0_0 = {
	root = {
		is_root = true,
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
	screen = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			1920,
			1080
		}
	}
}
local var_0_1 = {
	scenegraph_id = "screen",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "console_cursor",
				texture_id = "icon_texture"
			}
		}
	},
	content = {
		icon_texture = "console_cursor"
	},
	style = {
		console_cursor = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				64,
				64
			},
			offset = {
				0,
				0,
				0
			},
			color = {
				255,
				255,
				255,
				255
			}
		}
	}
}

return {
	scenegraph_definition = var_0_0,
	widgets = {
		console_cursor = var_0_1
	}
}
