-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_crafting_inventory_console_definitions.lua

local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl = {
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	area_left = console_menu_scenegraphs.area_left,
	area_right = console_menu_scenegraphs.area_right,
	area_divider = console_menu_scenegraphs.area_divider,
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
local tbl_2 = {
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
local tbl_3 = {
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
local tbl_4 = {
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

local function fn(arg_1_0)
	-- function 1
	local button_frame_01 = UIFrameSettings.button_frame_01
	local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
	local var_1_2 = frame_outer_glow_01.texture_sizes.horizontal[2]
	local size = tbl.search_input.size

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
					content_change_function = function (self, arg_2_1)
						-- function 2
						local disabled_color

						if not self.hotspot.disable_button then
							disabled_color = arg_2_1.disabled_color

							if not disabled_color then
								-- Nothing
							end
						end

						disabled_color = arg_2_1.base_color

						::label_2_0::

						arg_2_1.color = disabled_color
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
					content_change_function = function (self, arg_3_1)
						-- function 3
						local parent = self.parent
						local filter_selected = parent:filter_selected()
						local filter_active = parent:filter_active()

						if filter_selected or not self.input_active then
							arg_3_1.color[1] = 255
						elseif not (not self.hotspot.is_hover and filter_active) then
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
					content_check_function = function (self)
						-- function 4
						return self.search_query ~= "" or not not self.input_active or not self.hotspot.disable_button
					end
				},
				{
					style_id = "disabled_text",
					pass_type = "text",
					text_id = "disabled_text",
					content_check_function = function (self)
						-- function 5
						return self.hotspot.disable_button
					end
				},
				{
					style_id = "search_query",
					pass_type = "text",
					text_id = "search_query",
					content_check_function = function (self)
						-- function 6
						return not self.hotspot.disable_button
					end,
					content_change_function = function (self, arg_7_1)
						-- function 7
						if not self.input_active then
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
					content_check_function = function ()
						-- function 8
						return not Managers.input:is_device_active("gamepad")
					end,
					content_change_function = function (self, arg_9_1)
						-- function 9
						local filter_active = self.parent.parent:filter_active()

						if filter_active ~= self.filter_active then
							self.filter_active = filter_active

							if not filter_active then
								Colors.copy_to(arg_9_1.parent.search_filters_glow.color, Colors.color_definitions.white)
							else
								Colors.copy_to(arg_9_1.parent.search_filters_glow.color, Colors.color_definitions.font_title)
							end
						end

						local num = 0

						if not self.is_hover then
							num = 255
						elseif not self.filter_active then
							num = 200
						end

						arg_9_1.parent.search_filters_glow.color[1] = num
					end
				},
				{
					style_id = "search_filters_bg",
					texture_id = "search_filters_bg",
					pass_type = "texture",
					content_change_function = function (self, arg_10_1)
						-- function 10
						local disabled_color

						if not self.search_filters_hotspot.disable_button then
							disabled_color = arg_10_1.disabled_color

							if not disabled_color then
								-- Nothing
							end
						end

						disabled_color = arg_10_1.base_color

						::label_10_0::

						arg_10_1.color = disabled_color
					end
				},
				{
					style_id = "search_filters_icon",
					texture_id = "search_filters_icon",
					pass_type = "texture",
					content_change_function = function (self, arg_11_1)
						-- function 11
						local disabled_color

						if not self.search_filters_hotspot.disable_button then
							disabled_color = arg_11_1.disabled_color

							if not disabled_color then
								-- Nothing
							end
						end

						disabled_color = arg_11_1.base_color

						::label_11_0::

						arg_11_1.color = disabled_color
					end
				},
				{
					style_id = "search_filters_glow",
					texture_id = "search_filters_glow",
					pass_type = "texture",
					content_change_function = function (self, arg_12_1)
						-- function 12
						if not Managers.input:is_device_active("gamepad") then
							return
						end

						local parent = self.parent
						local filter_selected = parent:filter_selected()
						local filter_active = parent:filter_active()
						local color = arg_12_1.parent.search_filters_glow.color
						local flag

						flag = filter_selected or not filter_active or 255 or 0
						color[1] = flag
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
					content_check_function = function (self)
						-- function 13
						return self.search_query == "" or not self.hotspot.disable_button
					end,
					content_change_function = function (self, arg_14_1)
						-- function 14
						local clear_hotspot = self.clear_hotspot
						local is_hover = clear_hotspot.is_hover

						if is_hover ~= clear_hotspot.was_hover then
							clear_hotspot.was_hover = is_hover

							if not is_hover then
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
			frame = button_frame_01.texture,
			glow = frame_outer_glow_01.texture,
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
				texture_size = button_frame_01.texture_size,
				texture_sizes = button_frame_01.texture_sizes,
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
				texture_size = frame_outer_glow_01.texture_size,
				texture_sizes = frame_outer_glow_01.texture_sizes,
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
					size[1] - 90,
					size[2]
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

local tbl_5 = {
	255,
	32,
	32,
	32
}
local tbl_6 = {
	255,
	139,
	69,
	19
}

local function fn_2(arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local size = tbl[arg_15_0].size
	local tbl_2 = {
		size[1],
		450
	}
	local num = -20
	local button_frame_01 = UIFrameSettings.button_frame_01
	local tbl_3 = {
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
					content_change_function = function (self, arg_16_1)
						-- function 16
						if not self.on_pressed then
							local parent = self.parent
							local query = parent.query

							if not table.is_empty(query) then
								table.clear(query.sort)
								table.clear(query.filter)

								query.only_new = nil
								parent.query_dirty = true
							end
						end

						local color = arg_16_1.parent.reset_filter_fg.color
						local flag

						flag = not self.is_hover and 255 and 0
						color[1] = flag
					end
				},
				{
					texture_id = "reset_filter_bg",
					style_id = "reset_filter_bg",
					pass_type = "texture",
					content_check_function = function (arg_17_0, arg_17_1)
						-- function 17
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					texture_id = "reset_filter_fg",
					style_id = "reset_filter_fg",
					pass_type = "texture",
					content_check_function = function (arg_18_0, arg_18_1)
						-- function 18
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
			frame = button_frame_01.texture,
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
				area_size = tbl_2
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
				texture_size = tbl_2
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
				texture_size = button_frame_01.texture_size,
				texture_sizes = button_frame_01.texture_sizes,
				area_size = tbl_2,
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
					-10 + num,
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
					-50 + num,
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
					-10 + num - 150,
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
					-50 + num - 150,
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
					-60 + num + -20,
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
					-15 + num + 20,
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
					-15 + num + 20,
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
					-15 + num + 20,
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
	local passes = tbl_3.element.passes
	local content = tbl_3.content
	local style = tbl_3.style

	content.current_gamepad_index = {
		1,
		1
	}
	content.gamepad_input_matrix = {}

	local num_2 = 1
	local tbl_4 = {
		font_type = "hell_shark",
		font_size = 24
	}
	local var_15_10, var_15_11 = UIFontByResolution(tbl_4)
	local var_15_12 = var_15_10[1]
	local var_15_13 = var_15_11
	local var_15_14 = var_15_10[3]
	local tbl_5 = {
		{
			name = "rarity",
			text = Utf8.upper(Localize("search_filter_rarity"))
		},
		{
			name = "power_level",
			text = Utf8.upper(Localize("search_filter_power"))
		}
	}
	local num_3 = 50
	local num_4 = 0
	local num_5 = -num_3 * 0.5
	local tbl_6 = {}

	for i = 1, #tbl_5 do
		local text = tbl_5[i].text
		local text_size = UIRenderer.text_size(arg_15_1, text, var_15_12, var_15_13, tbl_2[1])

		tbl_6[#tbl_6 + 1] = text_size
		num_5 = num_5 + text_size + num_3
	end

	local num_6 = tbl_2[1] * 0.5 - num_5 * 0.5

	for j = 1, #tbl_5 do
		local var_15_23 = tbl_5[j]
		local text_2 = var_15_23.text
		local str = "sort_items_" .. var_15_23.name

		passes[#passes + 1] = {
			pass_type = "hotspot",
			content_id = str .. "_hotspot",
			style_id = str .. "_hotspot",
			content_change_function = function (self, arg_19_1)
				-- function 19
				if self.on_pressed or self.on_double_click or not self.gamepad_pressed then
					local sort = self.parent.query.sort
					local var_19_1 = sort[str]

					table.clear(sort)

					if var_19_1 == "descending" then
						sort[str] = "ascending"
					elseif not var_19_1 then
						sort[str] = "descending"
					end

					self.gamepad_pressed = nil
				end
			end
		}
		passes[#passes + 1] = {
			pass_type = "text",
			text_id = str .. "_text",
			style_id = str .. "_text",
			content_change_function = function (self, arg_20_1)
				-- function 20
				local is_device_active = Managers.input:is_device_active("gamepad")
				local current_gamepad_index = self.current_gamepad_index
				local var_20_2 = current_gamepad_index[1]
				local var_20_3 = current_gamepad_index[2]
				local var_20_4 = self.gamepad_input_matrix[var_20_2][var_20_3]
				local str_2 = str .. "_hotspot"
				local flag = not is_device_active and str_2 == var_20_4
				local is_hover = self[str_2].is_hover

				is_hover = is_hover or flag

				local text_color = arg_20_1.text_color
				local flag_2

				flag_2 = not is_hover and 255 and 128
				text_color[1] = flag_2

				local text_color_2 = arg_20_1.text_color
				local flag_3

				flag_3 = self.query.sort[str] or not is_hover or 255 or 128
				text_color_2[2] = flag_3

				local text_color_3 = arg_20_1.text_color
				local flag_4

				flag_4 = self.query.sort[str] or not is_hover or 255 or 128
				text_color_3[3] = flag_4

				local text_color_4 = arg_20_1.text_color
				local flag_5

				flag_5 = self.query.sort[str] or not is_hover or 255 or 128
				text_color_4[4] = flag_5
			end
		}
		passes[#passes + 1] = {
			pass_type = "rounded_background",
			style_id = str .. "_foreground"
		}
		passes[#passes + 1] = {
			pass_type = "rounded_background",
			style_id = str .. "_background",
			content_change_function = function (self, arg_21_1)
				-- function 21
				local var_21_0 = self[str .. "_hotspot"]
				local color = arg_21_1.color
				local flag

				flag = not self.query.sort[str] and 255 and 128
				color[1] = flag
			end
		}
		passes[#passes + 1] = {
			pass_type = "triangle",
			style_id = str .. "_arrow_up",
			content_check_function = function (self, arg_22_1)
				-- function 22
				return self.query.sort[str] == "ascending"
			end
		}
		passes[#passes + 1] = {
			pass_type = "triangle",
			style_id = str .. "_arrow_down",
			content_check_function = function (self, arg_23_1)
				-- function 23
				return self.query.sort[str] == "descending"
			end
		}
		passes[#passes + 1] = {
			pass_type = "triangle",
			style_id = str .. "_small_arrow_up",
			content_check_function = function (self, arg_24_1)
				-- function 24
				return not self.query.sort[str]
			end
		}
		passes[#passes + 1] = {
			pass_type = "triangle",
			style_id = str .. "_small_arrow_down",
			content_check_function = function (self, arg_25_1)
				-- function 25
				return not self.query.sort[str]
			end
		}
		content[str .. "_text"] = text_2
		content[str .. "_hotspot"] = {}

		local gamepad_input_matrix = content.gamepad_input_matrix
		local var_15_27 = content.gamepad_input_matrix[num_2]

		var_15_27 = var_15_27 or {}
		gamepad_input_matrix[num_2] = var_15_27
		content.gamepad_input_matrix[num_2][#content.gamepad_input_matrix[num_2] + 1] = str .. "_hotspot"
		style[str .. "_hotspot"] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			area_size = {
				tbl_6[j] + 40,
				35
			},
			offset = {
				num_6,
				-110,
				51
			}
		}
		style[str .. "_text"] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			font_size = tbl_4.font_size,
			font_type = tbl_4.font_type,
			text_color = {
				255,
				128,
				128,
				128
			},
			offset = {
				num_6,
				-110,
				51
			}
		}
		style[str .. "_foreground"] = {
			vertical_alignment = "top",
			corner_radius = 5,
			horizontal_alignment = "left",
			rect_size = {
				tbl_6[j] + 40,
				35
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				num_6 - 10,
				-112,
				50
			}
		}
		style[str .. "_background"] = {
			vertical_alignment = "top",
			corner_radius = 5,
			horizontal_alignment = "left",
			rect_size = {
				tbl_6[j] + 40 + 2,
				37
			},
			color = {
				255,
				128,
				128,
				128
			},
			offset = {
				num_6 - 10 - 1,
				-111,
				49
			}
		}
		style[str .. "_arrow_up"] = {
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
				num_6 + 5 + tbl_6[j],
				-110,
				53
			}
		}
		style[str .. "_arrow_down"] = {
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
				num_6 + 5 + tbl_6[j],
				-108,
				53
			}
		}
		style[str .. "_small_arrow_up"] = {
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
				num_6 + 10 + tbl_6[j],
				-105,
				53
			}
		}
		style[str .. "_small_arrow_down"] = {
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
				num_6 + 10 + tbl_6[j],
				-115,
				53
			}
		}
		num_6 = num_6 + tbl_6[j] + num_3
	end

	local num_7 = num_2 + 1
	local tbl_7 = {}

	for k, v in pairs(RaritySettings) do
		tbl_7[#tbl_7 + 1] = v
	end

	local function fn(self, arg_26_1)
		-- function 26
		return self.order < arg_26_1.order
	end

	table.sort(tbl_7, fn)

	local num_8 = 3
	local num_9 = 26
	local num_10 = -num_9 * 0.5
	local tbl_8 = {}
	local tbl_9 = {}

	for i4 = 1, #tbl_7 do
		local var_15_36 = tbl_7[i4]
		local text_size_2 = UIRenderer.text_size(arg_15_1, Localize(var_15_36.display_name), var_15_12, var_15_13, tbl_2[1])

		tbl_9[#tbl_9 + 1] = text_size_2
		num_10 = num_10 + text_size_2 + num_9

		if not (i4 % num_8 == 0 or i4 ~= #tbl_7) then
			tbl_8[#tbl_8 + 1] = tbl_2[1] * 0.5 - num_10 * 0.5
			num_10 = -num_9 * 0.5
		end
	end

	local num_11 = 1
	local var_15_39 = tbl_8[num_11]

	for i5 = 1, #tbl_7 do
		local var_15_40 = tbl_7[i5]
		local ceil = math.ceil(i5 / num_8)

		if ceil ~= num_11 then
			var_15_39 = tbl_8[ceil]
			num_11 = ceil
			num_7 = num_7 + 1
		end

		passes[#passes + 1] = {
			pass_type = "hotspot",
			content_id = var_15_40.name .. "_hotspot",
			style_id = var_15_40.name .. "_hotspot",
			content_change_function = function (self, arg_27_1)
				-- function 27
				if self.on_pressed or self.on_double_click or not self.gamepad_pressed then
					if not self.parent.query.filter[var_15_40.name] then
						self.parent.query.filter[var_15_40.name] = true
					else
						self.parent.query.filter[var_15_40.name] = nil
					end

					self.gamepad_pressed = nil
				end
			end
		}
		content[var_15_40.name .. "_hotspot"] = {}

		local gamepad_input_matrix_2 = content.gamepad_input_matrix
		local var_15_43 = content.gamepad_input_matrix[num_7]

		var_15_43 = var_15_43 or {}
		gamepad_input_matrix_2[num_7] = var_15_43
		content.gamepad_input_matrix[num_7][#content.gamepad_input_matrix[num_7] + 1] = var_15_40.name .. "_hotspot"
		style[var_15_40.name .. "_hotspot"] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			area_size = {
				tbl_9[i5] + 20,
				42,
				0
			},
			offset = {
				var_15_39 - 10,
				-250 + (num_11 - 1) * -50 - 15,
				50
			}
		}
		passes[#passes + 1] = {
			pass_type = "rect_text",
			text_id = var_15_40.name,
			style_id = var_15_40.name,
			content_change_function = function (self, arg_28_1)
				-- function 28
				local is_device_active = Managers.input:is_device_active("gamepad")
				local current_gamepad_index = self.current_gamepad_index
				local var_28_2 = current_gamepad_index[1]
				local var_28_3 = current_gamepad_index[2]
				local var_28_4 = self.gamepad_input_matrix[var_28_2][var_28_3]
				local str = var_15_40.name .. "_hotspot"
				local flag = not is_device_active and str == var_28_4

				if self[str].is_hover or not flag then
					local hovered_border_color

					if not self.query.filter[var_15_40.name] then
						hovered_border_color = arg_28_1.hovered_border_color

						if not hovered_border_color then
							-- Nothing
						end
					end

					hovered_border_color = arg_28_1.default_border_color

					::label_28_0::

					arg_28_1.border_color = hovered_border_color
					arg_28_1.text_color = arg_28_1.hovered_text_color
				elseif not self.query.filter[var_15_40.name] then
					arg_28_1.border_color = arg_28_1.selected_border_color
					arg_28_1.text_color = arg_28_1.selected_text_color
				else
					arg_28_1.border_color = arg_28_1.default_border_color
					arg_28_1.text_color = arg_28_1.default_text_color
				end
			end
		}
		content[var_15_40.name] = var_15_40.display_name
		style[var_15_40.name] = {
			localize = true,
			horizontal_alignment = "left",
			border = 1,
			vertical_alignment = "top",
			font_size = tbl_4.font_size,
			font_type = tbl_4.font_type,
			rect_color = {
				255,
				10,
				10,
				10
			},
			text_color = {
				160,
				var_15_40.color[2],
				var_15_40.color[3],
				var_15_40.color[4]
			},
			border_color = {
				160,
				var_15_40.frame_color[2],
				var_15_40.frame_color[3],
				var_15_40.frame_color[4]
			},
			selected_border_color = {
				160,
				var_15_40.frame_color[2],
				var_15_40.frame_color[3],
				var_15_40.frame_color[4]
			},
			selected_text_color = {
				160,
				var_15_40.color[2],
				var_15_40.color[3],
				var_15_40.color[4]
			},
			hovered_border_color = {
				255,
				var_15_40.frame_color[2],
				var_15_40.frame_color[3],
				var_15_40.frame_color[4]
			},
			hovered_text_color = {
				255,
				var_15_40.color[2],
				var_15_40.color[3],
				var_15_40.color[4]
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
				var_15_39,
				-250 + (num_11 - 1) * -50,
				50
			}
		}
		var_15_39 = var_15_39 + tbl_9[i5] + num_9
	end

	passes[#passes + 1] = {
		style_id = "checkbox_hotspot",
		pass_type = "hotspot",
		scenegraph_id = "new_checkbox",
		content_id = "checkbox_hotspot",
		content_change_function = function (self, arg_29_1)
			-- function 29
			if self.on_pressed or self.on_double_click or not self.gamepad_pressed then
				local flag = not self.parent.query.only_new

				self.parent.query.only_new = not flag and true
				self.gamepad_pressed = false
			end
		end
	}
	passes[#passes + 1] = {
		style_id = "checkbox_text",
		pass_type = "text",
		text_id = "checkbox_text",
		scenegraph_id = "new_checkbox",
		content_change_function = function (self, arg_30_1)
			-- function 30
			local is_device_active = Managers.input:is_device_active("gamepad")
			local current_gamepad_index = self.current_gamepad_index
			local var_30_2 = current_gamepad_index[1]
			local var_30_3 = current_gamepad_index[2]
			local var_30_4 = self.gamepad_input_matrix[var_30_2][var_30_3]
			local str = "checkbox_hotspot"
			local flag = not is_device_active and str == var_30_4
			local selected_color

			if self.checkbox_hotspot.is_hover or not flag then
				selected_color = arg_30_1.selected_color

				if not selected_color then
					-- Nothing
				end
			end

			selected_color = arg_30_1.base_color

			::label_30_0::

			arg_30_1.text_color = selected_color
		end
	}
	passes[#passes + 1] = {
		style_id = "checkbox_marker",
		scenegraph_id = "new_checkbox",
		texture_id = "checkbox_marker",
		pass_type = "texture",
		content_check_function = function (self, arg_31_1)
			-- function 31
			return self.query.only_new
		end
	}
	passes[#passes + 1] = {
		scenegraph_id = "new_checkbox",
		texture_id = "checkbox_frame",
		pass_type = "texture_frame",
		style_id = "checkbox_frame",
		content_change_function = function (self, arg_32_1)
			-- function 32
			local is_device_active = Managers.input:is_device_active("gamepad")
			local current_gamepad_index = self.current_gamepad_index
			local var_32_2 = current_gamepad_index[1]
			local var_32_3 = current_gamepad_index[2]
			local var_32_4 = self.gamepad_input_matrix[var_32_2][var_32_3]
			local str = "checkbox_hotspot"
			local flag = not is_device_active and str == var_32_4
			local selected_color

			if self.checkbox_hotspot.is_hover or not flag then
				selected_color = arg_32_1.selected_color

				if not selected_color then
					-- Nothing
				end
			end

			selected_color = arg_32_1.base_color

			::label_32_0::

			arg_32_1.text_color = selected_color
		end
	}
	passes[#passes + 1] = {
		scenegraph_id = "new_checkbox",
		style_id = "checkbox_background",
		pass_type = "rect"
	}

	local menu_frame_06 = UIFrameSettings.menu_frame_06

	content.checkbox_frame = menu_frame_06.texture
	content.checkbox_marker = "matchmaking_checkbox"
	content.checkbox_hotspot = {}
	content.checkbox_text = Localize("only_new_filter")

	local num_12 = num_7 + 1
	local gamepad_input_matrix_3 = content.gamepad_input_matrix
	local var_15_47 = content.gamepad_input_matrix[num_12]

	var_15_47 = var_15_47 or {}
	gamepad_input_matrix_3[num_12] = var_15_47
	content.gamepad_input_matrix[num_12][#content.gamepad_input_matrix[num_12] + 1] = "checkbox_hotspot"

	local num_13 = UIRenderer.text_size(arg_15_1, content.checkbox_text, var_15_12, var_15_13, tbl_2[1]) * 0.5 + 20

	style.checkbox_text = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		font_size = tbl_4.font_size,
		font_type = tbl_4.font_type,
		text_color = Colors.get_color_table_with_alpha("gray", 255),
		base_color = Colors.get_color_table_with_alpha("gray", 255),
		selected_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			0,
			4
		}
	}
	style.checkbox_marker = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			29.6,
			24.8
		},
		offset = {
			num_13 + 4,
			3,
			1
		},
		color = Colors.get_color_table_with_alpha("font_title", 255)
	}
	style.checkbox_background = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			30,
			30
		},
		offset = {
			num_13,
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
	style.checkbox_frame = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		area_size = {
			30,
			30
		},
		texture_size = menu_frame_06.texture_size,
		texture_sizes = menu_frame_06.texture_sizes,
		offset = {
			num_13,
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

	return tbl_3
end

local tbl_7 = {
	material_text_1 = UIWidgets.create_craft_material_widget("material_text_1"),
	material_text_2 = UIWidgets.create_craft_material_widget("material_text_2"),
	material_text_3 = UIWidgets.create_craft_material_widget("material_text_3"),
	material_text_4 = UIWidgets.create_craft_material_widget("material_text_4"),
	material_text_5 = UIWidgets.create_craft_material_widget("material_text_5"),
	material_text_6 = UIWidgets.create_craft_material_widget("material_text_6"),
	material_text_7 = UIWidgets.create_craft_material_widget("material_text_7"),
	item_tooltip = UIWidgets.create_simple_item_presentation("item_tooltip", UISettings.console_tooltip_pass_definitions),
	item_grid = UIWidgets.create_grid("item_grid", tbl.item_grid.size, 6, 5, 16, 10, false),
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
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, tbl_4),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_2),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_3),
	page_text_area = UIWidgets.create_simple_texture("tab_menu_bg_03", "page_text_area")
}
local tbl_8 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				-- function 33
				arg_33_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
				-- function 34
				local easeOutCubic = math.easeOutCubic(arg_34_3)

				arg_34_4.render_settings.alpha_multiplier = easeOutCubic
				arg_34_0.area_left.local_position[1] = arg_34_1.area_left.position[1] + -100 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				-- function 35
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				-- function 36
				arg_36_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
				-- function 37
				local easeOutCubic = math.easeOutCubic(arg_37_3)

				arg_37_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				-- function 38
				return
			end
		}
	}
}
local button_frame_01 = UIFrameSettings.button_frame_01
local tbl_9 = {
	texture_size = button_frame_01.texture_size,
	texture_sizes = button_frame_01.texture_sizes,
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
local tbl_10 = {
	pc_frame = UIWidgets.create_simple_frame(button_frame_01.texture, button_frame_01.texture_size, button_frame_01.texture_sizes.corner, button_frame_01.texture_sizes.vertical, button_frame_01.texture_sizes.horizontal, "pc_bg", tbl_9),
	pc_bg = UIWidgets.create_simple_texture("button_bg_01", "pc_bg", nil, nil, {
		255,
		64,
		64,
		64
	}),
	divider = UIWidgets.create_simple_texture("edge_divider_04_horizontal", "pc_divider"),
	apply_button = UIWidgets.create_default_button("pc_apply_button", tbl.pc_apply_button.size, nil, nil, Localize("input_description_apply"), 18, nil, nil, nil, true, true)
}

return {
	widgets = tbl_7,
	scenegraph_definition = tbl,
	animation_definitions = tbl_8,
	create_search_input_widget = fn,
	create_search_filters_widget = fn_2,
	pc_filter_widgets = tbl_10
}
