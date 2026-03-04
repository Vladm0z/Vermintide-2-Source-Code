-- chunkname: @scripts/ui/views/transition_video_definitions.lua

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
			UILayer.transition
		}
	},
	dead_space_filler = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			1
		}
	},
	splash_video = {
		parent = "background",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			50
		}
	}
}
local var_0_1 = {
	video_name = "video/demo_end_video_logo",
	scenegraph_id = "splash_video",
	material_name = "demo_end_video_logo",
	loop = false
}
local var_0_2 = {
	dead_space_filler_widget = UIWidgets.create_simple_rect("dead_space_filler", {
		255,
		0,
		0,
		0
	})
}
local var_0_3 = {}

return {
	scenegraph_definition = var_0_0,
	background_widget_definitions = var_0_2,
	demo_video = var_0_1,
	widget_definitions = var_0_3
}
