-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_panel_definitions.lua

local size = UISettings.game_start_windows.size
local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl = {
	220,
	68
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
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	area_left = console_menu_scenegraphs.area_left,
	area_right = console_menu_scenegraphs.area_right,
	area_divider = console_menu_scenegraphs.area_divider,
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
		size = tbl,
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
		size = size,
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
			size[1],
			50
		},
		position = {
			0,
			15,
			1
		}
	}
}
local console_menu_rect_color = UISettings.console_menu_rect_color
local tbl_4 = {
	panel_edge = UIWidgets.create_simple_texture("menu_frame_04_divider", "panel_edge"),
	panel_input_area_1 = UIWidgets.create_simple_texture("xbone_button_icon_lt", "panel_input_area_1"),
	panel_input_area_2 = UIWidgets.create_simple_texture("xbone_button_icon_rt", "panel_input_area_2"),
	panel = UIWidgets.create_simple_texture("menu_panel_bg", "panel", nil, nil, console_menu_rect_color),
	bottom_panel = UIWidgets.create_simple_uv_texture("menu_panel_bg", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_panel", nil, nil, console_menu_rect_color),
	back_button = UIWidgets.create_layout_button("back_button", "layout_button_back", "layout_button_back_glow"),
	close_button = UIWidgets.create_layout_button("close_button", "layout_button_close", "layout_button_close_glow")
}

local function fn(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	local tbl = {
		-19,
		-25,
		10
	}
	local tbl_2 = {
		0,
		-3,
		1
	}
	local tbl_3 = {
		0,
		-4,
		0
	}
	local tbl_4 = {
		2,
		3,
		3
	}

	if not arg_7_4 then
		tbl_4[1] = tbl_4[1] + arg_7_4[1]
		tbl_4[2] = tbl_4[2] + arg_7_4[2]
		tbl_4[3] = arg_7_4[3] - 1
		tbl_3[1] = tbl_3[1] + arg_7_4[1]
		tbl_3[2] = tbl_3[2] + arg_7_4[2]
		tbl_3[3] = arg_7_4[3] - 3
		tbl_2[1] = tbl_2[1] + arg_7_4[1]
		tbl_2[2] = tbl_2[2] + arg_7_4[2]
		tbl_2[3] = arg_7_4[3] - 2
		tbl[1] = tbl[1] + arg_7_4[1]
		tbl[2] = tbl[2] + arg_7_4[2]
		tbl[3] = arg_7_4[3] - 2
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
					content_check_function = function (self)
						-- function 8
						local is_hover

						if not self.button_hotspot.disable_button then
							is_hover = self.button_hotspot.is_hover

							if not is_hover then
								is_hover = self.button_hotspot.is_selected
							end
						else
							is_hover = false
						end

						if false then
							is_hover = true
						end

						return is_hover
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 9
						return not not self.button_hotspot.disable_button or not not self.button_hotspot.is_hover or not self.button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 10
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "selected_texture",
					style_id = "selected_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 11
						return not self.button_hotspot.disable_button
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
					content_check_function = function (self)
						-- function 12
						return self.button_hotspot.is_selected
					end
				},
				{
					texture_id = "marker_highlight",
					style_id = "marker_highlight_right",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 13
						return self.button_hotspot.is_selected
					end
				},
				{
					texture_id = "new_marker",
					style_id = "new_marker",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 14
						return self.new
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
				default_offset = tbl_4,
				offset = tbl_4,
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
				offset = tbl_3
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
					tbl_2[1] - 26,
					tbl_2[2],
					tbl_2[3]
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
					tbl_2[1] + 26,
					tbl_2[2],
					tbl_2[3]
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
					tbl_2[1] - 26,
					tbl_2[2],
					tbl_2[3] + 1
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
					tbl_2[1] + 26,
					tbl_2[2],
					tbl_2[3] + 1
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
					tbl[1],
					tbl[2],
					tbl[3]
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
	widget_definitions = tbl_4,
	scenegraph_definition = tbl_3,
	animation_definitions = tbl_2,
	create_panel_button = fn
}
