-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_panel_definitions.lua

local var_0_0 = UISettings.game_start_windows.size
local var_0_1 = UISettings.console_menu_scenegraphs
local var_0_2 = {
	220,
	68
}
local var_0_3 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - var_5_0
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}
local var_0_4 = {
	screen = var_0_1.screen,
	area = var_0_1.area,
	area_left = var_0_1.area_left,
	area_right = var_0_1.area_right,
	area_divider = var_0_1.area_divider,
	panel = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			1920,
			79
		},
		position = {
			0,
			0,
			UILayer.default + 1
		}
	},
	panel_edge = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			1920,
			4
		},
		position = {
			0,
			0,
			UILayer.default + 10
		}
	},
	bottom_panel = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			1920,
			79
		},
		position = {
			0,
			0,
			UILayer.default + 1
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
			40,
			-34,
			3
		}
	},
	panel_entry_area = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			1600,
			70
		},
		position = {
			70,
			0,
			1
		}
	},
	game_mode_option = {
		vertical_alignment = "top",
		parent = "panel_entry_area",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			20,
			0,
			14
		}
	},
	panel_input_area_1 = {
		vertical_alignment = "center",
		parent = "game_mode_option",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-50,
			8,
			1
		}
	},
	panel_input_area_2 = {
		vertical_alignment = "center",
		parent = "game_mode_option",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			50,
			8,
			1
		}
	},
	menu_root = {
		vertical_alignment = "center",
		parent = "screen",
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
		size = var_0_0,
		position = {
			0,
			0,
			1
		}
	},
	title_text_glow = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			544,
			16
		},
		position = {
			0,
			15,
			-1
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "title_text_glow",
		horizontal_alignment = "center",
		size = {
			var_0_0[1],
			50
		},
		position = {
			0,
			15,
			1
		}
	}
}
local var_0_5 = UISettings.console_menu_rect_color
local var_0_6 = {
	panel_edge = UIWidgets.create_simple_texture("menu_frame_04_divider", "panel_edge"),
	panel_input_area_1 = UIWidgets.create_simple_texture("xbone_button_icon_lt", "panel_input_area_1"),
	panel_input_area_2 = UIWidgets.create_simple_texture("xbone_button_icon_rt", "panel_input_area_2"),
	panel = UIWidgets.create_simple_texture("menu_panel_bg", "panel", nil, nil, var_0_5),
	bottom_panel = UIWidgets.create_simple_uv_texture("menu_panel_bg", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_panel", nil, nil, var_0_5),
	back_button = UIWidgets.create_layout_button("back_button", "layout_button_back", "layout_button_back_glow"),
	close_button = UIWidgets.create_layout_button("close_button", "layout_button_close", "layout_button_close_glow")
}

local function var_0_7(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	local var_7_0 = {
		-19,
		-25,
		10
	}
	local var_7_1 = {
		0,
		-3,
		1
	}
	local var_7_2 = {
		0,
		-4,
		0
	}
	local var_7_3 = {
		2,
		3,
		3
	}

	if arg_7_4 then
		var_7_3[1] = var_7_3[1] + arg_7_4[1]
		var_7_3[2] = var_7_3[2] + arg_7_4[2]
		var_7_3[3] = arg_7_4[3] - 1
		var_7_2[1] = var_7_2[1] + arg_7_4[1]
		var_7_2[2] = var_7_2[2] + arg_7_4[2]
		var_7_2[3] = arg_7_4[3] - 3
		var_7_1[1] = var_7_1[1] + arg_7_4[1]
		var_7_1[2] = var_7_1[2] + arg_7_4[2]
		var_7_1[3] = arg_7_4[3] - 2
		var_7_0[1] = var_7_0[1] + arg_7_4[1]
		var_7_0[2] = var_7_0[2] + arg_7_4[2]
		var_7_0[3] = arg_7_4[3] - 2
	end

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_field"
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_8_0)
						return not arg_8_0.button_hotspot.disable_button and (arg_8_0.button_hotspot.is_hover or arg_8_0.button_hotspot.is_selected)
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_9_0)
						return not arg_9_0.button_hotspot.disable_button and not arg_9_0.button_hotspot.is_hover and not arg_9_0.button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_10_0)
						return arg_10_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "selected_texture",
					style_id = "selected_texture",
					pass_type = "texture",
					content_check_function = function(arg_11_0)
						return not arg_11_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "marker",
					style_id = "marker_left",
					pass_type = "texture"
				},
				{
					texture_id = "marker",
					style_id = "marker_right",
					pass_type = "texture"
				},
				{
					texture_id = "marker_highlight",
					style_id = "marker_highlight_left",
					pass_type = "texture",
					content_check_function = function(arg_12_0)
						return arg_12_0.button_hotspot.is_selected
					end
				},
				{
					texture_id = "marker_highlight",
					style_id = "marker_highlight_right",
					pass_type = "texture",
					content_check_function = function(arg_13_0)
						return arg_13_0.button_hotspot.is_selected
					end
				},
				{
					texture_id = "new_marker",
					style_id = "new_marker",
					pass_type = "texture",
					content_check_function = function(arg_14_0)
						return arg_14_0.new
					end
				}
			}
		},
		content = {
			marker = "morris_panel_divider",
			marker_highlight = "morris_panel_highlight",
			selected_texture = "hero_panel_selection_glow",
			new_marker = "list_item_tag_new",
			button_hotspot = {},
			text_field = arg_7_2,
			default_font_size = arg_7_3
		},
		style = {
			text = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_7_3,
				horizontal_alignment = arg_7_5 or "left",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_offset = arg_7_4 or {
					0,
					10,
					4
				},
				offset = arg_7_4 or {
					0,
					5,
					4
				},
				size = arg_7_1
			},
			text_shadow = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_7_3,
				horizontal_alignment = arg_7_5 or "left",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_offset = var_7_3,
				offset = var_7_3,
				size = arg_7_1
			},
			text_hover = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_7_3,
				horizontal_alignment = arg_7_5 or "left",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				default_offset = arg_7_4 or {
					0,
					10,
					4
				},
				offset = arg_7_4 or {
					0,
					5,
					4
				},
				size = arg_7_1
			},
			text_disabled = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_7_3,
				horizontal_alignment = arg_7_5 or "left",
				text_color = Colors.get_color_table_with_alpha("gray", 50),
				default_offset = arg_7_4 or {
					0,
					10,
					4
				},
				offset = arg_7_4 or {
					0,
					5,
					4
				},
				size = arg_7_1
			},
			selected_texture = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = {
					169,
					35
				},
				color = arg_7_6 or Colors.get_color_table_with_alpha("font_title", 255),
				offset = var_7_2
			},
			marker_left = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					52,
					30
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_7_1[1] - 26,
					var_7_1[2],
					var_7_1[3]
				}
			},
			marker_right = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					52,
					30
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_7_1[1] + 26,
					var_7_1[2],
					var_7_1[3]
				}
			},
			marker_highlight_left = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					52,
					30
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_7_1[1] - 26,
					var_7_1[2],
					var_7_1[3] + 1
				}
			},
			marker_highlight_right = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					52,
					30
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_7_1[1] + 26,
					var_7_1[2],
					var_7_1[3] + 1
				}
			},
			new_marker = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					math.floor(88.19999999999999),
					math.floor(35.699999999999996)
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_7_0[1],
					var_7_0[2],
					var_7_0[3]
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_7_0
	}
end

return {
	widget_definitions = var_0_6,
	scenegraph_definition = var_0_4,
	animation_definitions = var_0_3,
	create_panel_button = var_0_7
}
