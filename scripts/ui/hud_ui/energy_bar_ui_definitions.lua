-- chunkname: @scripts/ui/hud_ui/energy_bar_ui_definitions.lua

local tbl = {
	250,
	16
}
local tbl_2 = {
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
	screen_bottom_pivot = {
		parent = "screen",
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
		size = tbl,
		position = {
			0,
			-220,
			1
		}
	}
}
local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
local var_0_3 = frame_outer_glow_01.texture_sizes.corner[1]
local tbl_3 = {
	charge_bar = {
		scenegraph_id = "charge_bar",
		element = {
			passes = {
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "icon_shadow",
					texture_id = "icon"
				},
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
					pass_type = "rect",
					style_id = "min_threshold"
				},
				{
					pass_type = "rect",
					style_id = "max_threshold"
				}
			}
		},
		content = {
			icon = "tabs_icon_all_selected",
			bar_1 = "energy_bar",
			bar_fg = "overcharge_frame",
			size = {
				tbl[1] - 6,
				tbl[2]
			},
			frame = frame_outer_glow_01.texture
		},
		style = {
			frame = {
				frame_margins = {
					-(var_0_3 - 1),
					-(var_0_3 - 1)
				},
				texture_size = frame_outer_glow_01.texture_size,
				texture_sizes = frame_outer_glow_01.texture_sizes,
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
				},
				size = tbl
			},
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
					tbl[1] - 6,
					tbl[2] - 6
				}
			},
			icon = {
				size = {
					34,
					34
				},
				offset = {
					tbl[1],
					tbl[2] / 2 - 17,
					5
				},
				color = {
					100,
					0,
					0,
					1
				}
			},
			icon_shadow = {
				size = {
					34,
					34
				},
				offset = {
					tbl[1] + 2,
					tbl[2] / 2 - 17 - 2,
					5
				},
				color = {
					0,
					0,
					0,
					0
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
					tbl[1] - 6,
					tbl[2] - 6
				},
				offset = {
					3,
					3,
					0
				},
				color = {
					0,
					0,
					100,
					0
				}
			},
			min_threshold = {
				pivot = {
					0,
					0
				},
				offset = {
					0,
					3,
					4
				},
				color = {
					204,
					0,
					0,
					0
				},
				size = {
					2,
					tbl[2] - 6
				}
			},
			max_threshold = {
				pivot = {
					0,
					0
				},
				offset = {
					0,
					3,
					4
				},
				color = {
					204,
					0,
					0,
					0
				},
				size = {
					2,
					tbl[2] - 6
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
	scenegraph_definition = tbl_2,
	widget_definitions = tbl_3
}
