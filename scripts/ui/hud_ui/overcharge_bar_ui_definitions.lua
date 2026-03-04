-- chunkname: @scripts/ui/hud_ui/overcharge_bar_ui_definitions.lua

local var_0_0 = {
	250,
	16
}
local var_0_1 = {
	250,
	70
}
local var_0_2 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud_inventory
		},
		size = {
			1920,
			1080
		}
	},
	screen_bottom_pivot_parent = {
		parent = "screen",
		position = {
			0,
			0,
			0
		},
		size = {
			0,
			0
		}
	},
	screen_bottom_pivot = {
		parent = "screen_bottom_pivot_parent",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	charge_bar = {
		vertical_alignment = "center",
		parent = "screen_bottom_pivot",
		horizontal_alignment = "center",
		size = var_0_0,
		position = {
			0,
			-220,
			1
		}
	},
	charge_bar_dark_pact = {
		vertical_alignment = "center",
		parent = "screen_bottom_pivot",
		horizontal_alignment = "center",
		size = var_0_1,
		position = {
			0,
			-120,
			1
		}
	}
}
local var_0_3 = UIFrameSettings.frame_outer_glow_01.texture_sizes.corner[1]
local var_0_4 = {}

return {
	scenegraph_definition = var_0_2,
	widget_definitions = var_0_4,
	DEFAULT_BAR_SIZE = var_0_0,
	DEFAULT_DARK_PACT_BAR_SIZE = var_0_1
}
