-- chunkname: @scripts/settings/dlcs/bless/priest_resource_bar_ui_definition.lua

local var_0_0 = {
	250,
	16
}
local var_0_1 = {
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
	}
}
local var_0_2 = UIFrameSettings.frame_outer_glow_01.texture_sizes.corner[1]
local var_0_3 = {
	charge_bar = {
		scenegraph_id = "charge_bar",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "bar_fg",
					texture_id = "bar_fg"
				},
				{
					pass_type = "rect",
					style_id = "bar_bg"
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "bar_1",
					texture_id = "bar_1"
				},
				{
					pass_type = "texture",
					style_id = "glow",
					texture_id = "glow"
				},
				{
					pass_type = "texture",
					style_id = "bar_detail",
					texture_id = "bar_detail"
				},
				{
					pass_type = "texture",
					style_id = "bar_active",
					texture_id = "bar_active"
				}
			}
		},
		content = {
			bar_1 = "overcharge_bar_warrior_priest",
			glow = "overcharge_bar_warrior_priest_bar_glow",
			bar_active = "overcharge_bar_warrior_priest_active",
			bar_detail = "overcharge_bar_warrior_priest_slim_bar",
			bar_fg = "overcharge_frame_priest",
			size = {
				var_0_0[1] - 6,
				var_0_0[2]
			}
		},
		style = {
			bar_1 = {
				gradient_threshold = 0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					3,
					3,
					3
				},
				size = {
					var_0_0[1] - 6,
					var_0_0[2] - 6
				}
			},
			bar_fg = {
				offset = {
					0,
					0,
					5
				},
				color = {
					204,
					255,
					255,
					255
				}
			},
			bar_bg = {
				size = {
					var_0_0[1] - 6,
					var_0_0[2] - 6
				},
				offset = {
					3,
					3,
					0
				},
				color = {
					100,
					0,
					0,
					0
				}
			},
			glow = {
				size = {
					75,
					75
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-37.5 + var_0_0[2] / 2,
					11
				}
			},
			bar_detail = {
				color = {
					255,
					255,
					109,
					0
				},
				offset = {
					3,
					3,
					3
				},
				size = {
					var_0_0[1] - 6,
					var_0_0[2] - 6
				}
			},
			bar_active = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					3,
					-50 + var_0_0[2] / 2,
					10
				},
				size = {
					var_0_0[1] - 6,
					100
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
}

return {
	scenegraph_definition = var_0_1,
	widget_definitions = var_0_3
}
