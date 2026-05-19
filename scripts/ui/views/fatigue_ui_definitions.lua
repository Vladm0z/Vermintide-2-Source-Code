-- chunkname: @scripts/ui/views/fatigue_ui_definitions.lua

local var_0_0 = {
	root = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			1920,
			1080
		}
	},
	background_parent = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			-120,
			1
		},
		size = {
			500,
			200
		}
	},
	background = {
		vertical_alignment = "bottom",
		parent = "background_parent",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			0
		},
		size = {
			500,
			200
		}
	},
	background_dragger = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			-50,
			0
		},
		size = {
			320,
			40
		}
	},
	shield = {
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			90,
			90
		}
	}
}
local var_0_1 = {
	state_2 = {
		time = 0.2,
		pictures = {
			"fatigue_icon_02",
			"fatigue_icon_05"
		}
	},
	state_3 = {
		time = 0.4,
		pictures = {
			"fatigue_icon_02",
			"fatigue_icon_03",
			"fatigue_icon_04",
			"fatigue_icon_05",
			"fatigue_icon_06",
			"fatigue_icon_07",
			"fatigue_icon_08"
		}
	}
}
local var_0_2 = {
	scenegraph_id = "shield",
	element = {
		passes = {
			{
				pass_type = "texture",
				texture_id = "texture_id"
			},
			{
				pass_type = "texture",
				style_id = "texture_glow_id",
				texture_id = "texture_glow_id",
				content_check_function = function(arg_1_0)
					return arg_1_0.show_glow
				end
			}
		}
	},
	content = {
		show_glow = false,
		texture_id = "fatigue_icon_01",
		texture_glow_id = "fatigue_icon_glow"
	},
	style = {
		size = {
			90,
			90
		},
		offset = {
			0,
			0,
			0
		},
		color = {
			0,
			255,
			255,
			255
		},
		state_textures = {
			state_3 = "fatigue_icon_08",
			state_2 = "fatigue_icon_02",
			state_1 = "fatigue_icon_01"
		},
		state_animations = {
			state_1 = {
				state_3 = var_0_1.state_3
			},
			state_2 = {
				state_3 = var_0_1.state_3
			}
		},
		texture_glow_id = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				64,
				64
			},
			color = {
				255,
				90,
				240,
				90
			},
			offset = {
				0,
				0,
				1
			}
		}
	}
}

return {
	scenegraph_definition = var_0_0,
	shield_definition = var_0_2
}
