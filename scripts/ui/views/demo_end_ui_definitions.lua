-- chunkname: @scripts/ui/views/demo_end_ui_definitions.lua

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
			0
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
			99
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
			700
		}
	}
}
local tbl_2 = {
	video_name = "video/demo_end_video_list",
	sound_start = "Play_ending_demo",
	scenegraph_id = "splash_video",
	loop = false,
	material_name = "demo_end_video_list",
	sound_stop = "Stop_ending_demo"
}
local tbl_3 = {
	dead_space_filler_widget = UIWidgets.create_simple_rect("dead_space_filler", {
		255,
		0,
		0,
		0
	})
}
local tbl_4 = {}

return {
	scenegraph_definition = tbl,
	background_widget_definitions = tbl_3,
	demo_video = tbl_2,
	widget_definitions = tbl_4
}
