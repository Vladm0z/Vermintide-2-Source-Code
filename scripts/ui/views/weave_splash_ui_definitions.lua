-- chunkname: @scripts/ui/views/weave_splash_ui_definitions.lua

local_require("scripts/ui/ui_widgets")

local var_0_0 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			1
		},
		size = {
			1920,
			1080
		}
	},
	dead_space_filler = {
		scale = "fit",
		position = {
			0,
			0,
			0
		},
		size = {
			1920,
			1080
		}
	},
	background_image = {
		vertical_alignment = "center",
		scale = "aspect_ratio",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			2
		}
	}
}

local function var_0_1(arg_1_0, arg_1_1)
	return {
		scenegraph_id = "background_image",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "bg_texture",
					texture_id = "bg_texture"
				}
			}
		},
		content = {
			bg_texture = arg_1_0
		},
		style = {
			bg_texture = {
				color = {
					arg_1_1,
					255,
					255,
					255
				}
			}
		},
		offset = {
			0,
			0,
			5
		}
	}
end

local var_0_2 = {
	dead_space_filler = UIWidgets.create_simple_rect("root", {
		255,
		0,
		0,
		0
	}, -1)
}

return {
	scenegraph_definition = var_0_0,
	widget_definitions = var_0_2,
	create_weave_image_func = var_0_1
}
