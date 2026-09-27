-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_summary_definitions.lua

local game_start_windows = UISettings.game_start_windows
local frame = game_start_windows.frame
local size = game_start_windows.size
local tbl = {
	size[1] - 60,
	72
}
local tbl_2 = {
	size[1] - 20,
	size[2] - (50 + tbl[2])
}
local str = "menu_frame_08"
local var_0_6 = UIFrameSettings[str].texture_sizes.corner[1]
local tbl_3 = {
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
		size = size,
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
			size[2]
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
			size[2]
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
		size = tbl_2,
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
			tbl_2[1] - 10,
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
		size = tbl,
		position = {
			0,
			18,
			20
		}
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local str = "game_options_bg_04"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local str_2 = "menu_frame_08"
	local var_1_3 = UIFrameSettings[str_2]

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
						1 - math.min(arg_1_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
					},
					{
						math.min(arg_1_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
						1
					}
				},
				texture_id = str
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

local tbl_4 = {
	background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window"),
	window = UIWidgets.create_frame("window", size, frame, 20),
	confirm_button = UIWidgets.create_default_button("confirm_button", tbl_3.confirm_button.size, nil, nil, Localize("confirm_menu_button_name"), 32),
	game_options_left_chain = UIWidgets.create_tiled_texture("game_options_left_chain", "chain_link_01", {
		16,
		19
	}),
	game_options_right_chain = UIWidgets.create_tiled_texture("game_options_right_chain", "chain_link_01", {
		16,
		19
	}),
	game_option_placeholder = fn("game_option_1", tbl_3.game_option_1.size),
	item_presentation_frame = UIWidgets.create_frame("game_option_1", tbl_3.game_option_1.size, str, 20),
	item_presentation_bg = UIWidgets.create_simple_texture("game_options_bg_04", "game_option_1"),
	item_presentation = UIWidgets.create_simple_item_presentation("item_presentation")
}

return {
	widgets = tbl_4,
	scenegraph_definition = tbl_3
}
