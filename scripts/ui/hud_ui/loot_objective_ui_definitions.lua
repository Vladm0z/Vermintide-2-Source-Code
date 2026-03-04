-- chunkname: @scripts/ui/hud_ui/loot_objective_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	64,
	64
}
local var_0_3 = {
	819,
	60
}
local var_0_4 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
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

local function var_0_5(arg_1_0, arg_1_1)
	local var_1_0 = {
		20,
		20
	}
	local var_1_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_1_0).size
	local var_1_2 = var_1_1[1] * arg_1_1
	local var_1_3 = var_1_0[1] * (arg_1_1 - 1)
	local var_1_4 = {
		var_1_2 + var_1_3,
		var_1_1[2] + var_1_0[2]
	}
	local var_1_5 = UIFrameSettings.item_hover_01
	local var_1_6 = var_1_5.texture_sizes.corner
	local var_1_7 = {}
	local var_1_8 = {}
	local var_1_9 = {}
	local var_1_10 = {}
	local var_1_11 = {}

	for iter_1_0 = 1, arg_1_1 do
		var_1_7[iter_1_0] = arg_1_0
		var_1_8[iter_1_0] = arg_1_0 .. "_glow"
		var_1_9[iter_1_0] = arg_1_0 .. "_bg"
		var_1_10[iter_1_0] = var_1_1
		var_1_11[iter_1_0] = {
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
			frame = var_1_5.texture,
			icon_textures = var_1_7,
			glow_icon_textures = var_1_8,
			background_icon_textures = var_1_9
		},
		style = {
			frame = {
				texture_size = var_1_5.texture_size,
				texture_sizes = var_1_5.texture_sizes,
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
					var_1_4[1] + var_1_6[1] * 2,
					var_1_4[2] + var_1_6[2] * 2
				},
				offset = {
					-var_1_6[1],
					-var_1_6[2],
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
					var_1_0[1],
					0
				},
				texture_sizes = var_1_10,
				texture_colors = var_1_11,
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
					-var_1_4[1] / 2,
					-var_1_1[2] / 2,
					2
				},
				draw_count = arg_1_1
			},
			background_icon_textures = {
				scenegraph_id = "pivot",
				axis = 1,
				direction = 1,
				spacing = {
					var_1_0[1],
					0
				},
				texture_sizes = var_1_10,
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
					-var_1_4[1] / 2,
					-var_1_1[2] / 2,
					1
				},
				draw_count = arg_1_1
			},
			glow_icon_textures = {
				scenegraph_id = "pivot",
				axis = 1,
				direction = 1,
				spacing = {
					var_1_0[1],
					0
				},
				texture_sizes = var_1_10,
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
					-var_1_4[1] / 2,
					-var_1_1[2] / 2,
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

local var_0_6 = {}

return {
	scenegraph_definition = var_0_4,
	widget_definitions = var_0_6,
	create_loot_widget = var_0_5
}
