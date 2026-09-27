-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_summary_console_definitions.lua

local size = UISettings.game_start_windows.size
local tbl = {
	size[1] - 20,
	700
}
local tbl_2 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeOutCubic = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeOutCubic = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		}
	}
}
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
		horizontal_alignment = "left",
		size = size,
		position = {
			850,
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
		size = tbl,
		position = {
			0,
			0,
			2
		}
	},
	item_presentation = {
		vertical_alignment = "top",
		parent = "game_option_1",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 10,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	confirm_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 40,
			72
		},
		position = {
			0,
			18,
			20
		}
	}
}

local function fn(arg_7_0, arg_7_1)
	-- function 7
	local str = "game_options_bg_04"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local str_2 = "menu_frame_08"
	local var_7_3 = UIFrameSettings[str_2]

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
			frame = var_7_3.texture,
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_7_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
					},
					{
						math.min(arg_7_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
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
				size = arg_7_1,
				texture_size = var_7_3.texture_size,
				texture_sizes = var_7_3.texture_sizes
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
		scenegraph_id = arg_7_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local tbl_4 = {
	game_option_placeholder = fn("game_option_1", tbl_3.game_option_1.size),
	item_presentation = UIWidgets.create_simple_item_presentation("item_presentation", UISettings.console_tooltip_pass_definitions)
}

return {
	widgets = tbl_4,
	scenegraph_definition = tbl_3,
	animation_definitions = tbl_2
}
