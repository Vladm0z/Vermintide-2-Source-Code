-- chunkname: @scripts/ui/views/hero_view/windows/store/definitions/store_window_panel_definitions.lua

local var_0_0 = UISettings.console_menu_scenegraphs
local var_0_1 = {
	screen = var_0_0.screen,
	area = var_0_0.area,
	area_left = var_0_0.area_left,
	area_right = var_0_0.area_right,
	area_divider = var_0_0.area_divider,
	panel = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			1920,
			69
		},
		position = {
			0,
			0,
			UILayer.default + 4
		}
	},
	panel_shadow_top = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			1920,
			50
		},
		position = {
			0,
			0,
			UILayer.default + 5
		}
	},
	panel_edge_top = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			1920,
			6
		},
		position = {
			0,
			-63,
			UILayer.default + 10
		}
	},
	bottom_panel = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			1920,
			69
		},
		position = {
			0,
			0,
			UILayer.default + 4
		}
	},
	panel_shadow_bottom = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			1920,
			50
		},
		position = {
			0,
			0,
			UILayer.default + 5
		}
	},
	panel_shadow_bottom_2 = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			1920,
			20
		},
		position = {
			0,
			43,
			UILayer.default + 5
		}
	},
	panel_edge_bottom = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			1920,
			6
		},
		position = {
			0,
			63,
			UILayer.default + 10
		}
	},
	panel_entry_area = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			900,
			64
		},
		position = {
			100,
			0,
			7
		}
	},
	entry_panel_bg_masked = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			900,
			64
		},
		position = {
			0,
			0,
			7
		}
	},
	entry_panel_detail_left = {
		vertical_alignment = "top",
		parent = "panel_entry_area",
		horizontal_alignment = "left",
		size = {
			14,
			70
		},
		position = {
			-12,
			0,
			10
		}
	},
	entry_panel_detail_right = {
		vertical_alignment = "top",
		parent = "panel_entry_area",
		horizontal_alignment = "right",
		size = {
			14,
			70
		},
		position = {
			12,
			0,
			10
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
	back_button = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			40,
			-120,
			3
		}
	},
	close_button = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			45,
			-34,
			30
		}
	},
	game_option_pivot = {
		vertical_alignment = "top",
		parent = "panel_entry_area",
		horizontal_alignment = "left",
		size = {
			0,
			70
		},
		position = {
			0,
			0,
			14
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
			1
		}
	},
	entry_panel_selection = {
		vertical_alignment = "bottom",
		parent = "game_option_pivot",
		horizontal_alignment = "left",
		size = {
			213,
			23
		},
		position = {
			0,
			0,
			10
		}
	},
	mark_all_as_seen = {
		vertical_alignment = "bottom",
		parent = "panel",
		horizontal_alignment = "right",
		size = {
			270,
			70
		},
		position = {
			-30,
			-80,
			8
		}
	}
}
local var_0_2 = {
	word_wrap = false,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 32,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}

local function var_0_3(arg_1_0, arg_1_1)
	return {
		element = {
			passes = {
				{
					texture_id = "edge",
					style_id = "edge",
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
			edge = "store_menu_glow",
			write_mask = {
				texture_id = "circular_gradient_write_mask",
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
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-8,
					0
				}
			},
			write_mask = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					1,
					140
				},
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
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local var_0_4 = {
	panel_input_area_1 = UIWidgets.create_simple_texture("xbone_button_icon_lt", "panel_input_area_1"),
	panel_input_area_2 = UIWidgets.create_simple_texture("xbone_button_icon_rt", "panel_input_area_2"),
	panel = UIWidgets.create_simple_rect("panel", {
		120,
		0,
		0,
		0
	}),
	panel_edge_top = UIWidgets.create_simple_texture("store_menu_frame", "panel_edge_top"),
	panel_shadow_top = UIWidgets.create_simple_texture("loot_presentation_fg_01_fade", "panel_shadow_top", nil, nil, {
		255,
		255,
		255,
		255
	}),
	bottom_panel = UIWidgets.create_simple_rect("bottom_panel", {
		120,
		0,
		0,
		0
	}),
	panel_edge_bottom = UIWidgets.create_simple_texture("store_menu_frame", "panel_edge_bottom"),
	panel_shadow_bottom = UIWidgets.create_simple_texture("loot_presentation_fg_02_fade", "panel_shadow_bottom", nil, nil, {
		255,
		255,
		255,
		255
	}),
	panel_shadow_bottom_2 = UIWidgets.create_simple_texture("loot_presentation_fg_01_fade", "panel_shadow_bottom_2", nil, nil, {
		255,
		255,
		255,
		255
	}),
	back_button = UIWidgets.create_layout_button("back_button", "layout_button_back", "layout_button_back_glow"),
	close_button = UIWidgets.create_layout_button("close_button", "layout_button_close", "layout_button_close_glow"),
	entry_panel_selection = var_0_3("entry_panel_selection", var_0_1.entry_panel_selection.size),
	mark_all_seen_button = UIWidgets.create_store_panel_button("mark_all_as_seen", var_0_1.mark_all_as_seen.size, "mark_all_as_seen", 22)
}
local var_0_5 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				local var_3_0 = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = var_3_0
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = 1 - var_6_0
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_4,
	scenegraph_definition = var_0_1,
	animation_definitions = var_0_5
}
