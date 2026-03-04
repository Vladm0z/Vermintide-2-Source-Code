-- chunkname: @scripts/ui/views/water_mark_view_definitions.lua

local var_0_0 = {
	root = {
		scale = "fit",
		is_root = true,
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
	water_mark = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			-200,
			-20,
			999
		},
		size = {
			256,
			128
		}
	}
}

return {
	scenegraph_definition = var_0_0,
	water_mark = UIWidgets.create_simple_texture("demo_water_mark", "water_mark", false, false)
}
