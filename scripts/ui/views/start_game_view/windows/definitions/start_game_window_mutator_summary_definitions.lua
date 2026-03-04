-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_summary_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = {
	var_0_2[1] - 60,
	72
}
local var_0_4 = {
	var_0_2[1] - 20,
	var_0_2[2] - (50 + var_0_3[2])
}
local var_0_5 = "menu_frame_08"
local var_0_6 = UIFrameSettings[var_0_5].texture_sizes.corner[1]
local var_0_7 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	root_fit = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	menu_root = {
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
			0
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = var_0_2,
		position = {
			0,
			0,
			1
		}
	},
	game_options_right_chain = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			16,
			var_0_2[2]
		},
		position = {
			195,
			0,
			1
		}
	},
	game_options_left_chain = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			16,
			var_0_2[2]
		},
		position = {
			-195,
			0,
			1
		}
	},
	game_option_1 = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_4,
		position = {
			0,
			-16,
			2
		}
	},
	item_presentation = {
		vertical_alignment = "top",
		parent = "game_option_1",
		horizontal_alignment = "center",
		size = {
			var_0_4[1] - 10,
			0
		},
		position = {
			0,
			-var_0_6,
			1
		}
	},
	confirm_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_3,
		position = {
			0,
			18,
			20
		}
	}
}

local function var_0_8(arg_1_0, arg_1_1)
	local var_1_0 = "game_options_bg_04"
	local var_1_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_0)
	local var_1_2 = "menu_frame_08"
	local var_1_3 = UIFrameSettings[var_1_2]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				}
			}
		},
		content = {
			frame = var_1_3.texture,
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_1_1[2] / var_1_1.size[2], 1)
					},
					{
						math.min(arg_1_1[1] / var_1_1.size[1], 1),
						1
					}
				},
				texture_id = var_1_0
			}
		},
		style = {
			frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					10
				},
				size = arg_1_1,
				texture_size = var_1_3.texture_size,
				texture_sizes = var_1_3.texture_sizes
			},
			background = {
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
				}
			}
		},
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_9 = {
	background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window"),
	window = UIWidgets.create_frame("window", var_0_2, var_0_1, 20),
	confirm_button = UIWidgets.create_default_button("confirm_button", var_0_7.confirm_button.size, nil, nil, Localize("confirm_menu_button_name"), 32),
	game_options_left_chain = UIWidgets.create_tiled_texture("game_options_left_chain", "chain_link_01", {
		16,
		19
	}),
	game_options_right_chain = UIWidgets.create_tiled_texture("game_options_right_chain", "chain_link_01", {
		16,
		19
	}),
	game_option_placeholder = var_0_8("game_option_1", var_0_7.game_option_1.size),
	item_presentation_frame = UIWidgets.create_frame("game_option_1", var_0_7.game_option_1.size, var_0_5, 20),
	item_presentation_bg = UIWidgets.create_simple_texture("game_options_bg_04", "game_option_1"),
	item_presentation = UIWidgets.create_simple_item_presentation("item_presentation")
}

return {
	widgets = var_0_9,
	scenegraph_definition = var_0_7
}
