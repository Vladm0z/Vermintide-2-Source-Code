-- chunkname: @scripts/ui/hud_ui/loot_objective_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	64,
	64
}
local tbl_2 = {
	819,
	60
}
local tbl_3 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			num,
			num_2
		}
	},
	background_parent = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			-200,
			-100,
			1
		},
		size = {
			383,
			86
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
			383,
			86
		}
	},
	pivot = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	}
}

table.clone(Colors.color_definitions.white)[1] = 0

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local tbl = {
		20,
		20
	}
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_1_0).size
	local num = size[1] * arg_1_1
	local num_2 = tbl[1] * (arg_1_1 - 1)
	local tbl_2 = {
		num + num_2,
		size[2] + tbl[2]
	}
	local item_hover_01 = UIFrameSettings.item_hover_01
	local corner = item_hover_01.texture_sizes.corner
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {}
	local tbl_6 = {}
	local tbl_7 = {}

	for i = 1, arg_1_1 do
		tbl_3[i] = arg_1_0
		tbl_4[i] = arg_1_0 .. "_glow"
		tbl_5[i] = arg_1_0 .. "_bg"
		tbl_6[i] = size
		tbl_7[i] = {
			0,
			255,
			255,
			255
		}
	end

	return {
		scenegraph_id = "background",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					pass_type = "multi_texture",
					style_id = "icon_textures",
					texture_id = "icon_textures"
				},
				{
					pass_type = "multi_texture",
					style_id = "background_icon_textures",
					texture_id = "background_icon_textures"
				},
				{
					pass_type = "multi_texture",
					style_id = "glow_icon_textures",
					texture_id = "glow_icon_textures"
				}
			}
		},
		content = {
			draw_count = 0,
			background = "loot_objective_bg",
			amount = arg_1_1,
			frame = item_hover_01.texture,
			icon_textures = tbl_3,
			glow_icon_textures = tbl_4,
			background_icon_textures = tbl_5
		},
		style = {
			frame = {
				texture_size = item_hover_01.texture_size,
				texture_sizes = item_hover_01.texture_sizes,
				color = {
					150,
					255,
					255,
					255
				},
				default_color = {
					150,
					255,
					255,
					255
				},
				size = {
					tbl_2[1] + corner[1] * 2,
					tbl_2[2] + corner[2] * 2
				},
				offset = {
					-corner[1],
					-corner[2],
					2
				}
			},
			background = {
				color = {
					255,
					255,
					255,
					255
				},
				default_color = {
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
			},
			icon_textures = {
				scenegraph_id = "pivot",
				axis = 1,
				direction = 1,
				spacing = {
					tbl[1],
					0
				},
				texture_sizes = tbl_6,
				texture_colors = tbl_7,
				color = {
					0,
					255,
					255,
					255
				},
				default_color = {
					0,
					255,
					255,
					255
				},
				offset = {
					-tbl_2[1] / 2,
					-size[2] / 2,
					2
				},
				draw_count = arg_1_1
			},
			background_icon_textures = {
				scenegraph_id = "pivot",
				axis = 1,
				direction = 1,
				spacing = {
					tbl[1],
					0
				},
				texture_sizes = tbl_6,
				color = {
					255,
					255,
					255,
					255
				},
				default_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-tbl_2[1] / 2,
					-size[2] / 2,
					1
				},
				draw_count = arg_1_1
			},
			glow_icon_textures = {
				scenegraph_id = "pivot",
				axis = 1,
				direction = 1,
				spacing = {
					tbl[1],
					0
				},
				texture_sizes = tbl_6,
				color = {
					255,
					255,
					255,
					255
				},
				default_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-tbl_2[1] / 2,
					-size[2] / 2,
					3
				},
				draw_count = arg_1_1
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local tbl_4 = {}

return {
	scenegraph_definition = tbl_3,
	widget_definitions = tbl_4,
	create_loot_widget = fn
}
