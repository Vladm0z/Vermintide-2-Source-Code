-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_crafting_inventory_console_definitions.lua

local var_0_0 = UISettings.console_menu_scenegraphs
local var_0_1 = {
	screen = var_0_0.screen,
	area = var_0_0.area,
	area_left = var_0_0.area_left,
	area_right = var_0_0.area_right,
	area_divider = var_0_0.area_divider,
	item_tooltip = {
		vertical_alignment = "top",
		parent = "area_right",
		horizontal_alignment = "right",
		size = {
			400,
			0
		},
		position = {
			-60,
			-90,
			0
		}
	},
	item_grid = {
		vertical_alignment = "top",
		parent = "area_left",
		horizontal_alignment = "center",
		size = {
			520,
			690
		},
		position = {
			-9,
			-100,
			1
		}
	},
	search_input = {
		vertical_alignment = "top",
		parent = "item_grid",
		horizontal_alignment = "left",
		size = {
			420,
			42
		},
		position = {
			73,
			-5,
			50
		}
	},
	search_filters = {
		vertical_alignment = "top",
		parent = "search_input",
		horizontal_alignment = "right",
		size = {
			455,
			42
		},
		position = {
			475,
			0,
			10
		}
	},
	new_checkbox = {
		vertical_alignment = "bottom",
		parent = "search_filters",
		horizontal_alignment = "center",
		size = {
			455,
			42
		},
		position = {
			0,
			-390,
			10
		}
	},
	pc_bg = {
		vertical_alignment = "top",
		parent = "search_filters",
		horizontal_alignment = "left",
		size = {
			455,
			550
		},
		position = {
			0,
			0,
			2
		}
	},
	pc_apply_button = {
		vertical_alignment = "bottom",
		parent = "pc_bg",
		horizontal_alignment = "center",
		size = {
			150,
			42
		},
		position = {
			0,
			20,
			60
		}
	},
	pc_divider = {
		vertical_alignment = "top",
		parent = "pc_apply_button",
		horizontal_alignment = "center",
		size = {
			350,
			14
		},
		position = {
			0,
			40,
			61
		}
	},
	gamepad_background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			100
		}
	},
	material_text_1 = {
		vertical_alignment = "top",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			55,
			100
		},
		position = {
			-210,
			110,
			2
		}
	},
	material_text_2 = {
		vertical_alignment = "top",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			55,
			100
		},
		position = {
			-140,
			110,
			2
		}
	},
	material_text_3 = {
		vertical_alignment = "top",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			55,
			100
		},
		position = {
			-70,
			110,
			2
		}
	},
	material_text_4 = {
		vertical_alignment = "top",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			55,
			100
		},
		position = {
			0,
			110,
			2
		}
	},
	material_text_5 = {
		vertical_alignment = "top",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			55,
			100
		},
		position = {
			70,
			110,
			2
		}
	},
	material_text_6 = {
		vertical_alignment = "top",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			55,
			100
		},
		position = {
			140,
			110,
			2
		}
	},
	material_text_7 = {
		vertical_alignment = "top",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			55,
			100
		},
		position = {
			210,
			110,
			2
		}
	},
	page_text_area = {
		vertical_alignment = "bottom",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			334,
			60
		},
		position = {
			0,
			0,
			3
		}
	},
	input_icon_previous = {
		vertical_alignment = "center",
		parent = "page_text_area",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-60,
			0,
			1
		}
	},
	input_icon_next = {
		vertical_alignment = "center",
		parent = "page_text_area",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			60,
			0,
			1
		}
	},
	input_arrow_next = {
		vertical_alignment = "center",
		parent = "input_icon_next",
		horizontal_alignment = "center",
		size = {
			19,
			27
		},
		position = {
			40,
			0,
			1
		}
	},
	input_arrow_previous = {
		vertical_alignment = "center",
		parent = "input_icon_previous",
		horizontal_alignment = "center",
		size = {
			19,
			27
		},
		position = {
			-40,
			0,
			1
		}
	},
	page_button_next = {
		vertical_alignment = "center",
		parent = "input_icon_next",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			20,
			0,
			1
		}
	},
	page_button_previous = {
		vertical_alignment = "center",
		parent = "input_icon_previous",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-20,
			0,
			1
		}
	}
}
local var_0_2 = {
	word_wrap = true,
	font_size = 26,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		-172,
		4,
		2
	}
}
local var_0_3 = {
	word_wrap = true,
	font_size = 26,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		171,
		4,
		2
	}
}
local var_0_4 = {
	word_wrap = true,
	font_size = 26,
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

local function var_0_5(arg_1_0)
	local var_1_0 = UIFrameSettings.button_frame_01
	local var_1_1 = UIFrameSettings.frame_outer_glow_01
	local var_1_2 = var_1_1.texture_sizes.horizontal[2]
	local var_1_3 = var_0_1.search_input.size

	return {
		scenegraph_id = "search_input",
		offset = {
			0,
			0,
			0
		},
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					style_id = "bg_texture",
					texture_id = "bg_texture",
					pass_type = "texture",
					content_change_function = function(arg_2_0, arg_2_1)
						arg_2_1.color = arg_2_0.hotspot.disable_button and arg_2_1.disabled_color or arg_2_1.base_color
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					style_id = "detail_left",
					pass_type = "texture",
					content_id = "details"
				},
				{
					style_id = "glow",
					texture_id = "glow",
					pass_type = "texture_frame",
					content_change_function = function(arg_3_0, arg_3_1)
						local var_3_0 = arg_3_0.parent
						local var_3_1 = var_3_0:filter_selected()
						local var_3_2 = var_3_0:filter_active()

						if var_3_1 or arg_3_0.input_active then
							arg_3_1.color[1] = 255
						elseif arg_3_0.hotspot.is_hover and not var_3_2 then
							arg_3_1.color[1] = 100
						else
							arg_3_1.color[1] = 0
						end
					end
				},
				{
					style_id = "search_placeholder",
					pass_type = "text",
					text_id = "search_placeholder",
					content_check_function = function(arg_4_0)
						return arg_4_0.search_query == "" and not arg_4_0.input_active and not arg_4_0.hotspot.disable_button
					end
				},
				{
					style_id = "disabled_text",
					pass_type = "text",
					text_id = "disabled_text",
					content_check_function = function(arg_5_0)
						return arg_5_0.hotspot.disable_button
					end
				},
				{
					style_id = "search_query",
					pass_type = "text",
					text_id = "search_query",
					content_check_function = function(arg_6_0)
						return not arg_6_0.hotspot.disable_button
					end,
					content_change_function = function(arg_7_0, arg_7_1)
						if not arg_7_0.input_active then
							arg_7_1.caret_color[1] = 0
						else
							arg_7_1.caret_color[1] = 127 + 128 * math.sin(5 * Managers.time:time("ui"))
						end
					end
				},
				{
					style_id = "search_filters_hotspot",
					pass_type = "hotspot",
					content_id = "search_filters_hotspot",
					content_check_function = function()
						return not Managers.input:is_device_active("gamepad")
					end,
					content_change_function = function(arg_9_0, arg_9_1)
						local var_9_0 = arg_9_0.parent.parent:filter_active()

						if var_9_0 ~= arg_9_0.filter_active then
							arg_9_0.filter_active = var_9_0

							if var_9_0 then
								Colors.copy_to(arg_9_1.parent.search_filters_glow.color, Colors.color_definitions.white)
							else
								Colors.copy_to(arg_9_1.parent.search_filters_glow.color, Colors.color_definitions.font_title)
							end
						end

						local var_9_1 = 0

						if arg_9_0.is_hover then
							var_9_1 = 255
						elseif arg_9_0.filter_active then
							var_9_1 = 200
						end

						arg_9_1.parent.search_filters_glow.color[1] = var_9_1
					end
				},
				{
					style_id = "search_filters_bg",
					texture_id = "search_filters_bg",
					pass_type = "texture",
					content_change_function = function(arg_10_0, arg_10_1)
						arg_10_1.color = arg_10_0.search_filters_hotspot.disable_button and arg_10_1.disabled_color or arg_10_1.base_color
					end
				},
				{
					style_id = "search_filters_icon",
					texture_id = "search_filters_icon",
					pass_type = "texture",
					content_change_function = function(arg_11_0, arg_11_1)
						arg_11_1.color = arg_11_0.search_filters_hotspot.disable_button and arg_11_1.disabled_color or arg_11_1.base_color
					end
				},
				{
					style_id = "search_filters_glow",
					texture_id = "search_filters_glow",
					pass_type = "texture",
					content_change_function = function(arg_12_0, arg_12_1)
						if not Managers.input:is_device_active("gamepad") then
							return
						end

						local var_12_0 = arg_12_0.parent
						local var_12_1 = var_12_0:filter_selected()
						local var_12_2 = var_12_0:filter_active()

						arg_12_1.parent.search_filters_glow.color[1] = (var_12_1 or var_12_2) and 255 or 0
					end
				},
				{
					style_id = "clear_icon",
					pass_type = "hotspot",
					content_id = "clear_hotspot"
				},
				{
					style_id = "clear_icon",
					texture_id = "clear_icon",
					pass_type = "texture",
					content_check_function = function(arg_13_0)
						return arg_13_0.search_query ~= "" and not arg_13_0.hotspot.disable_button
					end,
					content_change_function = function(arg_14_0, arg_14_1)
						local var_14_0 = arg_14_0.clear_hotspot
						local var_14_1 = var_14_0.is_hover

						if var_14_1 ~= var_14_0.was_hover then
							var_14_0.was_hover = var_14_1

							if var_14_1 then
								Colors.copy_to(arg_14_1.color, Colors.color_definitions.font_title)
							else
								Colors.copy_to(arg_14_1.color, Colors.color_definitions.very_dark_gray)
							end
						end
					end
				}
			}
		},
		content = {
			input_active = false,
			clear_icon = "friends_icon_close",
			search_filters_bg = "search_filters_bg",
			search_filters_glow = "search_filters_icon_glow",
			disabled_text = "inventory_search_disabled",
			search_query = "",
			search_filters_icon = "search_filters_icon",
			search_placeholder = "inventory_search_prompt",
			text_index = 1,
			bg_texture = "search_bar_texture",
			caret_index = 1,
			hotspot = {
				allow_multi_hover = true
			},
			frame = var_1_0.texture,
			glow = var_1_1.texture,
			details = {
				texture_id = "button_detail_04",
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				}
			},
			search_filters_hotspot = {},
			clear_hotspot = {},
			parent = arg_1_0
		},
		style = {
			bg_texture = {
				color = {
					255,
					200,
					200,
					200
				},
				base_color = {
					255,
					200,
					200,
					200
				},
				disabled_color = {
					255,
					100,
					100,
					100
				},
				offset = {
					0,
					0,
					0
				}
			},
			frame = {
				texture_size = var_1_0.texture_size,
				texture_sizes = var_1_0.texture_sizes,
				offset = {
					0,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			detail_left = {
				horizontal_alignment = "left",
				offset = {
					-34,
					0,
					3
				},
				texture_size = {
					60,
					42
				}
			},
			detail_right = {
				horizontal_alignment = "right",
				offset = {
					34,
					0,
					3
				},
				texture_size = {
					60,
					42
				}
			},
			glow = {
				frame_margins = {
					-var_1_2,
					-var_1_2
				},
				texture_size = var_1_1.texture_size,
				texture_sizes = var_1_1.texture_sizes,
				offset = {
					0,
					0,
					3
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			search_placeholder = {
				horizontal_alignment = "left",
				localize = true,
				font_size = 25,
				pixel_perfect = true,
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = {
					255,
					25,
					25,
					25
				},
				offset = {
					47,
					-3,
					5
				}
			},
			disabled_text = {
				upper_case = true,
				localize = true,
				font_size = 25,
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = {
					128,
					0,
					0,
					0
				},
				offset = {
					47,
					-3,
					5
				}
			},
			search_query = {
				word_wrap = false,
				font_size = 25,
				horizontal_scroll = true,
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_table("black"),
				offset = {
					47,
					13,
					3
				},
				caret_size = {
					2,
					26
				},
				caret_offset = {
					0,
					-6,
					6
				},
				caret_color = Colors.get_table("black"),
				size = {
					var_1_3[1] - 90,
					var_1_3[2]
				}
			},
			search_filters_hotspot = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				area_size = {
					96,
					96
				},
				offset = {
					-42,
					28,
					7
				}
			},
			search_filters_bg = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Colors.get_color_table_with_alpha("white", 255),
				base_color = Colors.get_color_table_with_alpha("white", 255),
				disabled_color = {
					255,
					128,
					128,
					128
				},
				texture_size = {
					128,
					128
				},
				offset = {
					-80,
					-4,
					58
				}
			},
			search_filters_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Colors.get_color_table_with_alpha("white", 255),
				base_color = Colors.get_color_table_with_alpha("white", 255),
				disabled_color = {
					128,
					128,
					128,
					128
				},
				texture_size = {
					128,
					128
				},
				offset = {
					-80,
					-4,
					58
				}
			},
			search_filters_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Colors.get_color_table_with_alpha("font_title", 255),
				texture_size = {
					128,
					128
				},
				offset = {
					-80,
					-4,
					59
				}
			},
			clear_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = {
					255,
					80,
					80,
					80
				},
				texture_size = {
					32,
					32
				},
				area_size = {
					32,
					32
				},
				offset = {
					-15,
					0,
					7
				}
			},
			help_tooltip = {
				font_size = 18,
				max_width = 1500,
				localize = false,
				cursor_side = "right",
				horizontal_alignment = "left",
				vertical_alignment = "center",
				draw_downwards = true,
				font_type = "hell_shark",
				text_color = Colors.get_table("white"),
				line_colors = {
					Colors.get_table("orange_red")
				},
				cursor_offset = {
					0,
					30
				},
				offset = {
					0,
					0,
					50
				},
				area_size = {
					45,
					45
				}
			}
		}
	}
end

local var_0_6 = {
	255,
	32,
	32,
	32
}
local var_0_7 = {
	255,
	139,
	69,
	19
}

local function var_0_8(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = var_0_1[arg_15_0].size
	local var_15_1 = {
		var_15_0[1],
		450
	}
	local var_15_2 = -20
	local var_15_3 = UIFrameSettings.button_frame_01
	local var_15_4 = {
		scenegraph_id = arg_15_0,
		offset = {
			0,
			0,
			0
		},
		element = {
			passes = {
				{
					texture_id = "bg",
					style_id = "bg",
					pass_type = "texture"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "sort_text",
					pass_type = "text",
					text_id = "sort_text"
				},
				{
					texture_id = "divider_top",
					style_id = "divider_top",
					pass_type = "texture"
				},
				{
					style_id = "filter_text",
					pass_type = "text",
					text_id = "filter_text"
				},
				{
					texture_id = "divider_top",
					style_id = "filter_divider_top",
					pass_type = "texture"
				},
				{
					texture_id = "divider_left",
					style_id = "divider_left",
					pass_type = "rotated_texture"
				},
				{
					style_id = "area_hotspot",
					pass_type = "hotspot",
					content_id = "area_hotspot"
				},
				{
					style_id = "close_filter_hotspot",
					pass_type = "hotspot",
					content_id = "close_filter_hotspot"
				},
				{
					style_id = "reset_filter_hotspot",
					pass_type = "hotspot",
					content_id = "reset_filter_hotspot",
					content_change_function = function(arg_16_0, arg_16_1)
						if arg_16_0.on_pressed then
							local var_16_0 = arg_16_0.parent
							local var_16_1 = var_16_0.query

							if not table.is_empty(var_16_1) then
								table.clear(var_16_1.sort)
								table.clear(var_16_1.filter)

								var_16_1.only_new = nil
								var_16_0.query_dirty = true
							end
						end

						arg_16_1.parent.reset_filter_fg.color[1] = arg_16_0.is_hover and 255 or 0
					end
				},
				{
					texture_id = "reset_filter_bg",
					style_id = "reset_filter_bg",
					pass_type = "texture",
					content_check_function = function(arg_17_0, arg_17_1)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					texture_id = "reset_filter_fg",
					style_id = "reset_filter_fg",
					pass_type = "texture",
					content_check_function = function(arg_18_0, arg_18_1)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "hover",
					style_id = "hover"
				}
			}
		},
		content = {
			bg = "button_bg_01",
			divider_left = "divider_01_bottom",
			divider_top = "edge_divider_04_horizontal",
			reset_filter_bg = "achievement_refresh_off",
			filter_text = "filters",
			visible = true,
			reset_filter_fg = "achievement_refresh_on",
			query_dirty = false,
			sort_text = "Sort by",
			frame = var_15_3.texture,
			reset_filter_hotspot = {},
			close_filter_hotspot = {},
			area_hotspot = {},
			query = {
				sort = {},
				filter = {}
			},
			gamepad_button_index = {
				1,
				1
			}
		},
		style = {
			hover = {
				vertical_alignment = "top",
				offset = {
					0,
					0,
					0
				},
				area_size = var_15_1
			},
			bg = {
				vertical_alignment = "top",
				offset = {
					0,
					0,
					1
				},
				color = {
					255,
					64,
					64,
					64
				},
				texture_size = var_15_1
			},
			gamepad_background = {
				offset = {
					0,
					0,
					-1
				},
				color = {
					128,
					0,
					0,
					0
				}
			},
			frame = {
				vertical_alignment = "top",
				texture_size = var_15_3.texture_size,
				texture_sizes = var_15_3.texture_sizes,
				area_size = var_15_1,
				offset = {
					0,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			sort_text = {
				vertical_alignment = "top",
				upper_case = true,
				localize = false,
				horizontal_alignment = "center",
				font_size = 40,
				font_type = "hell_shark_header",
				text_color = Colors.get_table("font_title"),
				offset = {
					0,
					-10 + var_15_2,
					3
				}
			},
			divider_top = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = {
					350,
					14
				},
				offset = {
					0,
					-50 + var_15_2,
					3
				}
			},
			filter_text = {
				vertical_alignment = "top",
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				font_size = 40,
				font_type = "hell_shark_header",
				text_color = Colors.get_table("font_title"),
				offset = {
					0,
					-10 + var_15_2 - 150,
					3
				}
			},
			filter_divider_top = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = {
					350,
					14
				},
				offset = {
					0,
					-50 + var_15_2 - 150,
					3
				}
			},
			divider_left = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					0,
					21
				},
				offset = {
					170,
					-60 + var_15_2 + -20,
					3
				},
				angle = math.pi * 0.5,
				pivot = {
					0,
					0
				}
			},
			reset_filter_hotspot = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				area_size = {
					37.5,
					37.5
				},
				offset = {
					-15,
					-15 + var_15_2 + 20,
					3
				}
			},
			close_filter_hotspot = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				area_size = {
					75,
					75
				},
				offset = {
					-20,
					10,
					3
				}
			},
			area_hotspot = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				area_size = {
					455,
					500
				},
				offset = {
					0,
					0,
					0
				}
			},
			reset_filter_bg = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					37.5,
					37.5
				},
				offset = {
					-15,
					-15 + var_15_2 + 20,
					4
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			reset_filter_fg = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					37.5,
					37.5
				},
				offset = {
					-15,
					-15 + var_15_2 + 20,
					5
				},
				color = {
					0,
					255,
					255,
					255
				}
			}
		}
	}
	local var_15_5 = var_15_4.element.passes
	local var_15_6 = var_15_4.content
	local var_15_7 = var_15_4.style

	var_15_6.current_gamepad_index = {
		1,
		1
	}
	var_15_6.gamepad_input_matrix = {}

	local var_15_8 = 1
	local var_15_9 = {
		font_type = "hell_shark",
		font_size = 24
	}
	local var_15_10, var_15_11 = UIFontByResolution(var_15_9)
	local var_15_12 = var_15_10[1]
	local var_15_13 = var_15_11
	local var_15_14 = var_15_10[3]
	local var_15_15 = {
		{
			name = "rarity",
			text = Utf8.upper(Localize("search_filter_rarity"))
		},
		{
			name = "power_level",
			text = Utf8.upper(Localize("search_filter_power"))
		}
	}
	local var_15_16 = 50
	local var_15_17 = 0
	local var_15_18 = -var_15_16 * 0.5
	local var_15_19 = {}

	for iter_15_0 = 1, #var_15_15 do
		local var_15_20 = var_15_15[iter_15_0].text
		local var_15_21 = UIRenderer.text_size(arg_15_1, var_15_20, var_15_12, var_15_13, var_15_1[1])

		var_15_19[#var_15_19 + 1] = var_15_21
		var_15_18 = var_15_18 + var_15_21 + var_15_16
	end

	local var_15_22 = var_15_1[1] * 0.5 - var_15_18 * 0.5

	for iter_15_1 = 1, #var_15_15 do
		local var_15_23 = var_15_15[iter_15_1]
		local var_15_24 = var_15_23.text
		local var_15_25 = "sort_items_" .. var_15_23.name

		var_15_5[#var_15_5 + 1] = {
			pass_type = "hotspot",
			content_id = var_15_25 .. "_hotspot",
			style_id = var_15_25 .. "_hotspot",
			content_change_function = function(arg_19_0, arg_19_1)
				if arg_19_0.on_pressed or arg_19_0.on_double_click or arg_19_0.gamepad_pressed then
					local var_19_0 = arg_19_0.parent.query.sort
					local var_19_1 = var_19_0[var_15_25]

					table.clear(var_19_0)

					if var_19_1 == "descending" then
						var_19_0[var_15_25] = "ascending"
					elseif not var_19_1 then
						var_19_0[var_15_25] = "descending"
					end

					arg_19_0.gamepad_pressed = nil
				end
			end
		}
		var_15_5[#var_15_5 + 1] = {
			pass_type = "text",
			text_id = var_15_25 .. "_text",
			style_id = var_15_25 .. "_text",
			content_change_function = function(arg_20_0, arg_20_1)
				local var_20_0 = Managers.input:is_device_active("gamepad")
				local var_20_1 = arg_20_0.current_gamepad_index
				local var_20_2 = var_20_1[1]
				local var_20_3 = var_20_1[2]
				local var_20_4 = arg_20_0.gamepad_input_matrix[var_20_2][var_20_3]
				local var_20_5 = var_15_25 .. "_hotspot"
				local var_20_6 = var_20_0 and var_20_5 == var_20_4
				local var_20_7 = arg_20_0[var_20_5].is_hover or var_20_6

				arg_20_1.text_color[1] = var_20_7 and 255 or 128
				arg_20_1.text_color[2] = (arg_20_0.query.sort[var_15_25] or var_20_7) and 255 or 128
				arg_20_1.text_color[3] = (arg_20_0.query.sort[var_15_25] or var_20_7) and 255 or 128
				arg_20_1.text_color[4] = (arg_20_0.query.sort[var_15_25] or var_20_7) and 255 or 128
			end
		}
		var_15_5[#var_15_5 + 1] = {
			pass_type = "rounded_background",
			style_id = var_15_25 .. "_foreground"
		}
		var_15_5[#var_15_5 + 1] = {
			pass_type = "rounded_background",
			style_id = var_15_25 .. "_background",
			content_change_function = function(arg_21_0, arg_21_1)
				local var_21_0 = arg_21_0[var_15_25 .. "_hotspot"]

				arg_21_1.color[1] = arg_21_0.query.sort[var_15_25] and 255 or 128
			end
		}
		var_15_5[#var_15_5 + 1] = {
			pass_type = "triangle",
			style_id = var_15_25 .. "_arrow_up",
			content_check_function = function(arg_22_0, arg_22_1)
				return arg_22_0.query.sort[var_15_25] == "ascending"
			end
		}
		var_15_5[#var_15_5 + 1] = {
			pass_type = "triangle",
			style_id = var_15_25 .. "_arrow_down",
			content_check_function = function(arg_23_0, arg_23_1)
				return arg_23_0.query.sort[var_15_25] == "descending"
			end
		}
		var_15_5[#var_15_5 + 1] = {
			pass_type = "triangle",
			style_id = var_15_25 .. "_small_arrow_up",
			content_check_function = function(arg_24_0, arg_24_1)
				return not arg_24_0.query.sort[var_15_25]
			end
		}
		var_15_5[#var_15_5 + 1] = {
			pass_type = "triangle",
			style_id = var_15_25 .. "_small_arrow_down",
			content_check_function = function(arg_25_0, arg_25_1)
				return not arg_25_0.query.sort[var_15_25]
			end
		}
		var_15_6[var_15_25 .. "_text"] = var_15_24
		var_15_6[var_15_25 .. "_hotspot"] = {}
		var_15_6.gamepad_input_matrix[var_15_8] = var_15_6.gamepad_input_matrix[var_15_8] or {}
		var_15_6.gamepad_input_matrix[var_15_8][#var_15_6.gamepad_input_matrix[var_15_8] + 1] = var_15_25 .. "_hotspot"
		var_15_7[var_15_25 .. "_hotspot"] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			area_size = {
				var_15_19[iter_15_1] + 40,
				35
			},
			offset = {
				var_15_22,
				-110,
				51
			}
		}
		var_15_7[var_15_25 .. "_text"] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			font_size = var_15_9.font_size,
			font_type = var_15_9.font_type,
			text_color = {
				255,
				128,
				128,
				128
			},
			offset = {
				var_15_22,
				-110,
				51
			}
		}
		var_15_7[var_15_25 .. "_foreground"] = {
			vertical_alignment = "top",
			corner_radius = 5,
			horizontal_alignment = "left",
			rect_size = {
				var_15_19[iter_15_1] + 40,
				35
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				var_15_22 - 10,
				-112,
				50
			}
		}
		var_15_7[var_15_25 .. "_background"] = {
			vertical_alignment = "top",
			corner_radius = 5,
			horizontal_alignment = "left",
			rect_size = {
				var_15_19[iter_15_1] + 40 + 2,
				37
			},
			color = {
				255,
				128,
				128,
				128
			},
			offset = {
				var_15_22 - 10 - 1,
				-111,
				49
			}
		}
		var_15_7[var_15_25 .. "_arrow_up"] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			triangle_alignment = "up",
			texture_size = {
				16,
				12
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_15_22 + 5 + var_15_19[iter_15_1],
				-110,
				53
			}
		}
		var_15_7[var_15_25 .. "_arrow_down"] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			triangle_alignment = "down",
			texture_size = {
				16,
				12
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_15_22 + 5 + var_15_19[iter_15_1],
				-108,
				53
			}
		}
		var_15_7[var_15_25 .. "_small_arrow_up"] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			triangle_alignment = "up",
			texture_size = {
				8,
				6
			},
			color = {
				128,
				128,
				128,
				128
			},
			offset = {
				var_15_22 + 10 + var_15_19[iter_15_1],
				-105,
				53
			}
		}
		var_15_7[var_15_25 .. "_small_arrow_down"] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			triangle_alignment = "down",
			texture_size = {
				8,
				6
			},
			color = {
				128,
				128,
				128,
				128
			},
			offset = {
				var_15_22 + 10 + var_15_19[iter_15_1],
				-115,
				53
			}
		}
		var_15_22 = var_15_22 + var_15_19[iter_15_1] + var_15_16
	end

	local var_15_26 = var_15_8 + 1
	local var_15_27 = {}

	for iter_15_2, iter_15_3 in pairs(RaritySettings) do
		var_15_27[#var_15_27 + 1] = iter_15_3
	end

	local function var_15_28(arg_26_0, arg_26_1)
		return arg_26_0.order < arg_26_1.order
	end

	table.sort(var_15_27, var_15_28)

	local var_15_29 = 3
	local var_15_30 = 26
	local var_15_31 = -var_15_30 * 0.5
	local var_15_32 = {}
	local var_15_33 = {}

	for iter_15_4 = 1, #var_15_27 do
		local var_15_34 = var_15_27[iter_15_4]
		local var_15_35 = UIRenderer.text_size(arg_15_1, Localize(var_15_34.display_name), var_15_12, var_15_13, var_15_1[1])

		var_15_33[#var_15_33 + 1] = var_15_35
		var_15_31 = var_15_31 + var_15_35 + var_15_30

		if iter_15_4 % var_15_29 == 0 or iter_15_4 == #var_15_27 then
			var_15_32[#var_15_32 + 1] = var_15_1[1] * 0.5 - var_15_31 * 0.5
			var_15_31 = -var_15_30 * 0.5
		end
	end

	local var_15_36 = 1
	local var_15_37 = var_15_32[var_15_36]

	for iter_15_5 = 1, #var_15_27 do
		local var_15_38 = var_15_27[iter_15_5]
		local var_15_39 = math.ceil(iter_15_5 / var_15_29)

		if var_15_39 ~= var_15_36 then
			var_15_37 = var_15_32[var_15_39]
			var_15_36 = var_15_39
			var_15_26 = var_15_26 + 1
		end

		var_15_5[#var_15_5 + 1] = {
			pass_type = "hotspot",
			content_id = var_15_38.name .. "_hotspot",
			style_id = var_15_38.name .. "_hotspot",
			content_change_function = function(arg_27_0, arg_27_1)
				if arg_27_0.on_pressed or arg_27_0.on_double_click or arg_27_0.gamepad_pressed then
					if not arg_27_0.parent.query.filter[var_15_38.name] then
						arg_27_0.parent.query.filter[var_15_38.name] = true
					else
						arg_27_0.parent.query.filter[var_15_38.name] = nil
					end

					arg_27_0.gamepad_pressed = nil
				end
			end
		}
		var_15_6[var_15_38.name .. "_hotspot"] = {}
		var_15_6.gamepad_input_matrix[var_15_26] = var_15_6.gamepad_input_matrix[var_15_26] or {}
		var_15_6.gamepad_input_matrix[var_15_26][#var_15_6.gamepad_input_matrix[var_15_26] + 1] = var_15_38.name .. "_hotspot"
		var_15_7[var_15_38.name .. "_hotspot"] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			area_size = {
				var_15_33[iter_15_5] + 20,
				42,
				0
			},
			offset = {
				var_15_37 - 10,
				-250 + (var_15_36 - 1) * -50 - 15,
				50
			}
		}
		var_15_5[#var_15_5 + 1] = {
			pass_type = "rect_text",
			text_id = var_15_38.name,
			style_id = var_15_38.name,
			content_change_function = function(arg_28_0, arg_28_1)
				local var_28_0 = Managers.input:is_device_active("gamepad")
				local var_28_1 = arg_28_0.current_gamepad_index
				local var_28_2 = var_28_1[1]
				local var_28_3 = var_28_1[2]
				local var_28_4 = arg_28_0.gamepad_input_matrix[var_28_2][var_28_3]
				local var_28_5 = var_15_38.name .. "_hotspot"
				local var_28_6 = var_28_0 and var_28_5 == var_28_4

				if arg_28_0[var_28_5].is_hover or var_28_6 then
					arg_28_1.border_color = not arg_28_0.query.filter[var_15_38.name] and arg_28_1.hovered_border_color or arg_28_1.default_border_color
					arg_28_1.text_color = arg_28_1.hovered_text_color
				elseif not arg_28_0.query.filter[var_15_38.name] then
					arg_28_1.border_color = arg_28_1.selected_border_color
					arg_28_1.text_color = arg_28_1.selected_text_color
				else
					arg_28_1.border_color = arg_28_1.default_border_color
					arg_28_1.text_color = arg_28_1.default_text_color
				end
			end
		}
		var_15_6[var_15_38.name] = var_15_38.display_name
		var_15_7[var_15_38.name] = {
			localize = true,
			horizontal_alignment = "left",
			border = 1,
			vertical_alignment = "top",
			font_size = var_15_9.font_size,
			font_type = var_15_9.font_type,
			rect_color = {
				255,
				10,
				10,
				10
			},
			text_color = {
				160,
				var_15_38.color[2],
				var_15_38.color[3],
				var_15_38.color[4]
			},
			border_color = {
				160,
				var_15_38.frame_color[2],
				var_15_38.frame_color[3],
				var_15_38.frame_color[4]
			},
			selected_border_color = {
				160,
				var_15_38.frame_color[2],
				var_15_38.frame_color[3],
				var_15_38.frame_color[4]
			},
			selected_text_color = {
				160,
				var_15_38.color[2],
				var_15_38.color[3],
				var_15_38.color[4]
			},
			hovered_border_color = {
				255,
				var_15_38.frame_color[2],
				var_15_38.frame_color[3],
				var_15_38.frame_color[4]
			},
			hovered_text_color = {
				255,
				var_15_38.color[2],
				var_15_38.color[3],
				var_15_38.color[4]
			},
			default_border_color = {
				160,
				90,
				90,
				90
			},
			default_text_color = {
				160,
				90,
				90,
				90
			},
			line_colors = {},
			offset = {
				var_15_37,
				-250 + (var_15_36 - 1) * -50,
				50
			}
		}
		var_15_37 = var_15_37 + var_15_33[iter_15_5] + var_15_30
	end

	var_15_5[#var_15_5 + 1] = {
		style_id = "checkbox_hotspot",
		pass_type = "hotspot",
		scenegraph_id = "new_checkbox",
		content_id = "checkbox_hotspot",
		content_change_function = function(arg_29_0, arg_29_1)
			if arg_29_0.on_pressed or arg_29_0.on_double_click or arg_29_0.gamepad_pressed then
				local var_29_0 = not arg_29_0.parent.query.only_new

				arg_29_0.parent.query.only_new = var_29_0 and true
				arg_29_0.gamepad_pressed = false
			end
		end
	}
	var_15_5[#var_15_5 + 1] = {
		style_id = "checkbox_text",
		pass_type = "text",
		text_id = "checkbox_text",
		scenegraph_id = "new_checkbox",
		content_change_function = function(arg_30_0, arg_30_1)
			local var_30_0 = Managers.input:is_device_active("gamepad")
			local var_30_1 = arg_30_0.current_gamepad_index
			local var_30_2 = var_30_1[1]
			local var_30_3 = var_30_1[2]
			local var_30_4 = arg_30_0.gamepad_input_matrix[var_30_2][var_30_3]
			local var_30_5 = "checkbox_hotspot"
			local var_30_6 = var_30_0 and var_30_5 == var_30_4

			arg_30_1.text_color = (arg_30_0.checkbox_hotspot.is_hover or var_30_6) and arg_30_1.selected_color or arg_30_1.base_color
		end
	}
	var_15_5[#var_15_5 + 1] = {
		style_id = "checkbox_marker",
		scenegraph_id = "new_checkbox",
		texture_id = "checkbox_marker",
		pass_type = "texture",
		content_check_function = function(arg_31_0, arg_31_1)
			return arg_31_0.query.only_new
		end
	}
	var_15_5[#var_15_5 + 1] = {
		scenegraph_id = "new_checkbox",
		texture_id = "checkbox_frame",
		pass_type = "texture_frame",
		style_id = "checkbox_frame",
		content_change_function = function(arg_32_0, arg_32_1)
			local var_32_0 = Managers.input:is_device_active("gamepad")
			local var_32_1 = arg_32_0.current_gamepad_index
			local var_32_2 = var_32_1[1]
			local var_32_3 = var_32_1[2]
			local var_32_4 = arg_32_0.gamepad_input_matrix[var_32_2][var_32_3]
			local var_32_5 = "checkbox_hotspot"
			local var_32_6 = var_32_0 and var_32_5 == var_32_4

			arg_32_1.text_color = (arg_32_0.checkbox_hotspot.is_hover or var_32_6) and arg_32_1.selected_color or arg_32_1.base_color
		end
	}
	var_15_5[#var_15_5 + 1] = {
		scenegraph_id = "new_checkbox",
		style_id = "checkbox_background",
		pass_type = "rect"
	}

	local var_15_40 = UIFrameSettings.menu_frame_06

	var_15_6.checkbox_frame = var_15_40.texture
	var_15_6.checkbox_marker = "matchmaking_checkbox"
	var_15_6.checkbox_hotspot = {}
	var_15_6.checkbox_text = Localize("only_new_filter")

	local var_15_41 = var_15_26 + 1

	var_15_6.gamepad_input_matrix[var_15_41] = var_15_6.gamepad_input_matrix[var_15_41] or {}
	var_15_6.gamepad_input_matrix[var_15_41][#var_15_6.gamepad_input_matrix[var_15_41] + 1] = "checkbox_hotspot"

	local var_15_42 = UIRenderer.text_size(arg_15_1, var_15_6.checkbox_text, var_15_12, var_15_13, var_15_1[1]) * 0.5 + 20

	var_15_7.checkbox_text = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		font_size = var_15_9.font_size,
		font_type = var_15_9.font_type,
		text_color = Colors.get_color_table_with_alpha("gray", 255),
		base_color = Colors.get_color_table_with_alpha("gray", 255),
		selected_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			0,
			4
		}
	}
	var_15_7.checkbox_marker = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			29.6,
			24.8
		},
		offset = {
			var_15_42 + 4,
			3,
			1
		},
		color = Colors.get_color_table_with_alpha("font_title", 255)
	}
	var_15_7.checkbox_background = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			30,
			30
		},
		offset = {
			var_15_42,
			0,
			0
		},
		color = {
			255,
			0,
			0,
			0
		}
	}
	var_15_7.checkbox_frame = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		area_size = {
			30,
			30
		},
		texture_size = var_15_40.texture_size,
		texture_sizes = var_15_40.texture_sizes,
		offset = {
			var_15_42,
			0,
			1
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	return var_15_4
end

local var_0_9 = {
	material_text_1 = UIWidgets.create_craft_material_widget("material_text_1"),
	material_text_2 = UIWidgets.create_craft_material_widget("material_text_2"),
	material_text_3 = UIWidgets.create_craft_material_widget("material_text_3"),
	material_text_4 = UIWidgets.create_craft_material_widget("material_text_4"),
	material_text_5 = UIWidgets.create_craft_material_widget("material_text_5"),
	material_text_6 = UIWidgets.create_craft_material_widget("material_text_6"),
	material_text_7 = UIWidgets.create_craft_material_widget("material_text_7"),
	item_tooltip = UIWidgets.create_simple_item_presentation("item_tooltip", UISettings.console_tooltip_pass_definitions),
	item_grid = UIWidgets.create_grid("item_grid", var_0_1.item_grid.size, 6, 5, 16, 10, false),
	page_button_next = UIWidgets.create_arrow_button("page_button_next", math.pi),
	page_button_previous = UIWidgets.create_arrow_button("page_button_previous"),
	input_icon_next = UIWidgets.create_simple_texture("xbone_button_icon_a", "input_icon_next"),
	input_icon_previous = UIWidgets.create_simple_texture("xbone_button_icon_a", "input_icon_previous"),
	input_arrow_next = UIWidgets.create_simple_uv_texture("settings_arrow_normal", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "input_arrow_next"),
	input_arrow_previous = UIWidgets.create_simple_texture("settings_arrow_normal", "input_arrow_previous"),
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, var_0_4),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_2),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_3),
	page_text_area = UIWidgets.create_simple_texture("tab_menu_bg_03", "page_text_area")
}
local var_0_10 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				arg_33_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
				local var_34_0 = math.easeOutCubic(arg_34_3)

				arg_34_4.render_settings.alpha_multiplier = var_34_0
				arg_34_0.area_left.local_position[1] = arg_34_1.area_left.position[1] + -100 * (1 - var_34_0)
			end,
			on_complete = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				arg_36_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
				local var_37_0 = math.easeOutCubic(arg_37_3)

				arg_37_4.render_settings.alpha_multiplier = 1 - var_37_0
			end,
			on_complete = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				return
			end
		}
	}
}
local var_0_11 = UIFrameSettings.button_frame_01
local var_0_12 = {
	texture_size = var_0_11.texture_size,
	texture_sizes = var_0_11.texture_sizes,
	offset = {
		0,
		0,
		2
	},
	color = {
		255,
		255,
		255,
		255
	}
}
local var_0_13 = {
	pc_frame = UIWidgets.create_simple_frame(var_0_11.texture, var_0_11.texture_size, var_0_11.texture_sizes.corner, var_0_11.texture_sizes.vertical, var_0_11.texture_sizes.horizontal, "pc_bg", var_0_12),
	pc_bg = UIWidgets.create_simple_texture("button_bg_01", "pc_bg", nil, nil, {
		255,
		64,
		64,
		64
	}),
	divider = UIWidgets.create_simple_texture("edge_divider_04_horizontal", "pc_divider"),
	apply_button = UIWidgets.create_default_button("pc_apply_button", var_0_1.pc_apply_button.size, nil, nil, Localize("input_description_apply"), 18, nil, nil, nil, true, true)
}

return {
	widgets = var_0_9,
	scenegraph_definition = var_0_1,
	animation_definitions = var_0_10,
	create_search_input_widget = var_0_5,
	create_search_filters_widget = var_0_8,
	pc_filter_widgets = var_0_13
}
