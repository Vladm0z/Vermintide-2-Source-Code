-- chunkname: @scripts/ui/views/versus_menu/versus_inventory_grid_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local var_0_5 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local num = size[1] - (var_0_5 * 2 + 60)
local tbl = {
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
	background = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			800
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = size,
		position = {
			0,
			0,
			0
		}
	},
	item_grid = {
		vertical_alignment = "bottom",
		parent = "page_button_divider",
		horizontal_alignment = "center",
		size = {
			size[1],
			size[2] - 130
		},
		position = {
			0,
			-5,
			-10
		}
	},
	item_grid_divider = {
		vertical_alignment = "top",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			15,
			7
		}
	},
	item_grid_header_fade = {
		vertical_alignment = "top",
		parent = "item_tabs_divider",
		horizontal_alignment = "center",
		size = {
			size[1],
			60
		},
		position = {
			0,
			0,
			-1
		}
	},
	item_grid_header = {
		vertical_alignment = "center",
		parent = "item_grid_divider",
		horizontal_alignment = "center",
		size = {
			size[1] - 20,
			40
		},
		position = {
			0,
			8,
			1
		}
	},
	item_grid_header_detail = {
		vertical_alignment = "bottom",
		parent = "item_grid_header",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-30,
			0
		}
	},
	item_tabs = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1],
			40
		},
		position = {
			0,
			-5,
			1
		}
	},
	item_tabs_segments = {
		vertical_alignment = "bottom",
		parent = "item_tabs",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			5,
			10
		}
	},
	item_tabs_segments_top = {
		vertical_alignment = "top",
		parent = "item_tabs",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			-7,
			20
		}
	},
	item_tabs_segments_bottom = {
		vertical_alignment = "bottom",
		parent = "item_tabs",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			3,
			20
		}
	},
	item_tabs_divider = {
		vertical_alignment = "bottom",
		parent = "item_tabs",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			0,
			7
		}
	},
	page_button_next = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			size[1] * 0.4,
			42
		},
		position = {
			0,
			0,
			1
		}
	},
	page_button_edge_right = {
		vertical_alignment = "center",
		parent = "page_button_next",
		horizontal_alignment = "left",
		size = {
			0,
			42
		},
		position = {
			0,
			0,
			10
		}
	},
	page_button_previous = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			size[1] * 0.4,
			42
		},
		position = {
			0,
			0,
			1
		}
	},
	page_button_edge_left = {
		vertical_alignment = "center",
		parent = "page_button_previous",
		horizontal_alignment = "right",
		size = {
			0,
			42
		},
		position = {
			0,
			0,
			10
		}
	},
	page_button_divider = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			42,
			14
		}
	},
	page_text_area = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1] * 0.2,
			42
		},
		position = {
			0,
			0,
			3
		}
	}
}
local tbl_2 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_3 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		-(size[1] * 0.1 + 5),
		4,
		2
	}
}
local tbl_4 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		size[1] * 0.1 + 4,
		4,
		2
	}
}
local tbl_5 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		4,
		2
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	return {
		element = {
			passes = {
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge_holder_right = "menu_frame_09_divider_right",
			edge_holder_left = "menu_frame_09_divider_left",
			bottom_edge = "menu_frame_09_divider"
		},
		style = {
			bottom_edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					5,
					0,
					6
				},
				size = {
					arg_1_1[1] - 10,
					5
				},
				texture_tiling_size = {
					arg_1_1[1] - 10,
					5
				}
			},
			edge_holder_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					3,
					-6,
					10
				},
				size = {
					9,
					17
				}
			},
			edge_holder_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_1_1[1] - 12,
					-6,
					10
				},
				size = {
					9,
					17
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

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	return {
		element = {
			passes = {
				{
					texture_id = "edge",
					style_id = "edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_top",
					style_id = "edge_holder_top",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_bottom",
					style_id = "edge_holder_bottom",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge = "menu_frame_09_divider_vertical",
			edge_holder_top = "menu_frame_09_divider_top",
			edge_holder_bottom = "menu_frame_09_divider_bottom"
		},
		style = {
			edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					6,
					6
				},
				size = {
					5,
					arg_2_1[2] - 9
				},
				texture_tiling_size = {
					5,
					arg_2_1[2] - 9
				}
			},
			edge_holder_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-6,
					arg_2_1[2] - 7,
					10
				},
				size = {
					17,
					9
				}
			},
			edge_holder_bottom = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-6,
					3,
					10
				},
				size = {
					17,
					9
				}
			}
		},
		scenegraph_id = arg_2_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local tbl_6 = {
	background = UIWidgets.create_simple_rect("background", {
		190,
		0,
		0,
		0
	}),
	item_grid = UIWidgets.create_grid("item_grid", tbl.item_grid.size, 7, 5, 16, 10, false),
	item_tabs_divider = fn("item_tabs_divider", tbl.item_tabs_divider.size),
	item_grid_header = UIWidgets.create_simple_text(Localize("hero_view_inventory"), "item_grid_header", nil, nil, tbl_2),
	item_grid_header_fade = UIWidgets.create_simple_uv_texture("edge_fade_small", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "item_grid_header_fade"),
	item_grid_header_detail = UIWidgets.create_simple_texture("divider_01_top", "item_grid_header_detail"),
	window_frame = UIWidgets.create_frame("window", tbl.window.size, frame, 10),
	window = UIWidgets.create_background("window", tbl.window.size, "background_leather_02"),
	window_background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window", nil, nil, nil, 1),
	page_button_next = UIWidgets.create_simple_window_button("page_button_next", tbl.page_button_next.size, Localize("menu_next"), 16),
	page_button_previous = UIWidgets.create_simple_window_button("page_button_previous", tbl.page_button_previous.size, Localize("menu_previous"), 16),
	page_button_divider = fn("page_button_divider", tbl.page_button_divider.size),
	page_button_edge_left = fn_2("page_button_edge_left", tbl.page_button_edge_left.size),
	page_button_edge_right = fn_2("page_button_edge_right", tbl.page_button_edge_right.size),
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, tbl_5),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_3),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_4),
	page_text_area = UIWidgets.create_simple_rect("page_text_area", {
		255,
		0,
		0,
		0
	})
}
local tbl_7 = {
	default = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "l1_r1",
			priority = 2,
			description_text = "input_description_change_tab",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 3,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 4,
			description_text = "input_description_close"
		}
	}
}
local tbl_8 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				arg_3_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
				-- function 4
				local easeOutCubic = math.easeOutCubic(arg_4_3)

				arg_4_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				arg_6_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				-- function 7
				local easeOutCubic = math.easeOutCubic(arg_7_3)

				arg_7_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				return
			end
		}
	}
}

return {
	widgets = tbl_6,
	category_settings = category_settings,
	scenegraph_definition = tbl,
	animation_definitions = tbl_8,
	generic_input_actions = tbl_7
}
