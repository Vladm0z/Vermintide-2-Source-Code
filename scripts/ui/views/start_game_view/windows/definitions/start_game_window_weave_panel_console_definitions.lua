-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_panel_console_definitions.lua

local var_0_0 = UISettings.game_start_windows.large_window_size
local var_0_1 = "menu_frame_11"
local var_0_2 = UIFrameSettings[var_0_1].texture_sizes.vertical[1]
local var_0_3 = {
	var_0_0[1] - var_0_2 * 2,
	var_0_0[2] - var_0_2 * 2
}
local var_0_4 = 70
local var_0_5 = {
	1920,
	1080
}
local var_0_6 = 0
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
			0
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
	parent_window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = var_0_5,
		position = {
			0,
			0,
			1
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "parent_window",
		horizontal_alignment = "right",
		size = var_0_5,
		position = {
			-var_0_6,
			0,
			1
		}
	},
	panel = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			var_0_4
		},
		position = {
			0,
			3,
			6
		}
	},
	panel_left = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			256,
			45
		},
		position = {
			0,
			3,
			6
		}
	},
	panel_right = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			256,
			45
		},
		position = {
			211,
			3,
			6
		}
	},
	panel_bottom = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			90
		},
		position = {
			0,
			-3,
			0
		}
	},
	panel_edge_top = {
		vertical_alignment = "bottom",
		parent = "panel",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			5
		},
		position = {
			0,
			-3,
			6
		}
	},
	panel_edge_bottom = {
		vertical_alignment = "top",
		parent = "panel_bottom",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			5
		},
		position = {
			0,
			3,
			6
		}
	},
	panel_entry_area = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			var_0_5[1],
			64
		},
		position = {
			150,
			0,
			2
		}
	},
	panel_input_area_1 = {
		vertical_alignment = "center",
		parent = "panel_entry_area",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-50,
			0,
			1
		}
	},
	panel_input_area_2 = {
		vertical_alignment = "center",
		parent = "panel_entry_area",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			50,
			0,
			1
		}
	},
	game_option_pivot = {
		vertical_alignment = "top",
		parent = "panel_entry_area",
		horizontal_alignment = "left",
		size = {
			0,
			var_0_4
		},
		position = {
			0,
			0,
			0
		}
	},
	game_option = {
		vertical_alignment = "top",
		parent = "game_option_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			64
		},
		position = {
			0,
			0,
			3
		}
	},
	entry_panel_selection = {
		vertical_alignment = "bottom",
		parent = "game_option_pivot",
		horizontal_alignment = "left",
		size = {
			0,
			23
		},
		position = {
			0,
			0,
			0
		}
	}
}
local var_0_8 = true

local function var_0_9(arg_1_0, arg_1_1)
	return {
		element = {
			passes = {
				{
					texture_id = "edge",
					style_id = "edge",
					pass_type = "texture"
				},
				{
					texture_id = "selection",
					style_id = "selection",
					pass_type = "texture"
				},
				{
					style_id = "write_mask",
					pass_type = "texture_uv",
					content_id = "write_mask"
				}
			}
		},
		content = {
			edge = "weave_menu_glow",
			selection = "athanor_item_divider_middle",
			write_mask = {
				texture_id = "weave_preview_smoke_01",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						0.5
					}
				}
			},
			size = arg_1_1
		},
		style = {
			edge = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					-8,
					1
				}
			},
			write_mask = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					200,
					150
				},
				color = {
					255,
					138,
					0,
					187
				},
				offset = {
					0,
					0,
					2
				}
			},
			selection = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					68,
					19
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-10,
					20
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local var_0_10 = {
	panel_input_area_1 = UIWidgets.create_simple_texture("xbone_button_icon_lt", "panel_input_area_1"),
	panel_input_area_2 = UIWidgets.create_simple_texture("xbone_button_icon_rt", "panel_input_area_2"),
	panel = UIWidgets.create_tiled_texture("panel", "menu_frame_bg_03", {
		256,
		256
	}, nil, nil, {
		255,
		150,
		150,
		150
	}),
	panel_bottom = UIWidgets.create_tiled_texture("panel_bottom", "athanor_panel_back", {
		64,
		84
	}, nil, nil, {
		255,
		150,
		150,
		150
	}),
	panel_fade = UIWidgets.create_simple_texture("options_window_fade_01", "panel", nil, nil, {
		255,
		0,
		0,
		0
	}, 1),
	panel_edge_top = UIWidgets.create_simple_texture("menu_frame_09_divider", "panel_edge_top"),
	panel_edge_bottom = UIWidgets.create_simple_texture("menu_frame_09_divider", "panel_edge_bottom"),
	panel_fade_bottom = UIWidgets.create_simple_uv_texture("options_window_fade_01", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "panel_bottom", nil, nil, {
		255,
		0,
		0,
		0
	}, 2),
	entry_panel_selection = var_0_9("entry_panel_selection", var_0_7.entry_panel_selection.size)
}
local var_0_11 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				local var_3_0 = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = var_3_0
			end,
			on_complete = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = 1 - var_6_0
			end,
			on_complete = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_10,
	scenegraph_definition = var_0_7,
	animation_definitions = var_0_11
}
