-- chunkname: @scripts/ui/views/options_view_definitions.lua

local num = 400
local tbl = {
	200,
	0,
	0,
	0
}
local tbl_2 = {
	14,
	14
}
local tbl_3 = {
	num,
	10
}
local num_2 = 2
local tbl_4 = {
	num,
	30
}
local num_3 = 1400
local num_4 = 900
local num_5 = 2
local get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_default", 50)
local tbl_5 = {
	root = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.options_menu + 10
		},
		size = {
			1920,
			1080
		}
	},
	safe_rect = {
		scale = "fit",
		position = {
			0,
			0,
			0
		},
		size = {
			1920,
			1080
		}
	},
	dead_space_filler = {
		scale = "fit",
		position = {
			0,
			0,
			0
		},
		size = {
			1920,
			1080
		}
	},
	logo = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "left",
		position = {
			45,
			-45,
			0
		},
		size = {
			280,
			200
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			num_3,
			num_4
		},
		position = {
			0,
			0,
			2
		}
	},
	window = {
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
			3
		}
	},
	back_button = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			40,
			-50,
			3
		}
	},
	background_frame = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			num_3,
			num_4
		},
		position = {
			0,
			0,
			1
		}
	},
	background_top_panel = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			num_3,
			50
		},
		position = {
			0,
			0,
			1
		}
	},
	background_top_panel_edge = {
		vertical_alignment = "bottom",
		parent = "background_top_panel",
		horizontal_alignment = "center",
		size = {
			num_3,
			0
		},
		position = {
			0,
			-5,
			1
		}
	},
	background_bottom_panel = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			num_3,
			50
		},
		position = {
			0,
			0,
			1
		}
	},
	background_bottom_panel_edge = {
		vertical_alignment = "top",
		parent = "background_bottom_panel",
		horizontal_alignment = "center",
		size = {
			num_3,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	frame_divider = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "left",
		position = {
			420,
			-90,
			2
		},
		size = {
			36,
			746
		}
	},
	button_pivot = {
		vertical_alignment = "bottom",
		parent = "background_top_panel",
		horizontal_alignment = "left",
		position = {
			65,
			9,
			2
		},
		size = {
			0,
			0
		}
	},
	menu_symbol = {
		vertical_alignment = "bottom",
		parent = "background_top_panel",
		horizontal_alignment = "left",
		position = {
			10,
			4,
			2
		},
		size = {
			40,
			40
		}
	},
	right_frame = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "right",
		position = {
			0,
			0,
			2
		},
		size = {
			1420,
			902
		}
	},
	gamepad_tooltip_text = {
		vertical_alignment = "top",
		parent = "right_frame",
		horizontal_alignment = "left",
		position = {
			20,
			-60,
			3
		},
		size = {
			820,
			762
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			-10,
			2
		},
		size = {
			480,
			28
		}
	},
	list_mask = {
		vertical_alignment = "center",
		parent = "background_frame",
		horizontal_alignment = "left",
		position = {
			18,
			0,
			2
		},
		size = {
			num_3,
			num_4 - 140
		}
	},
	list_edge_fade_bottom = {
		vertical_alignment = "bottom",
		parent = "list_mask",
		horizontal_alignment = "center",
		position = {
			0,
			-15,
			2
		},
		size = {
			num_3,
			15
		}
	},
	list_edge_fade_top = {
		vertical_alignment = "top",
		parent = "list_mask",
		horizontal_alignment = "center",
		position = {
			0,
			15,
			2
		},
		size = {
			num_3,
			15
		}
	},
	scrollbar_root = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "right",
		position = {
			-15,
			0,
			10
		},
		size = {
			8,
			num_4 - 120
		}
	},
	exit_button = {
		vertical_alignment = "bottom",
		parent = "background_top_panel",
		horizontal_alignment = "right",
		position = {
			-8,
			8,
			1
		},
		size = {
			32,
			32
		}
	},
	apply_button = {
		vertical_alignment = "top",
		parent = "background_bottom_panel",
		horizontal_alignment = "right",
		position = {
			-30,
			-7,
			1
		},
		size = {
			150,
			30
		}
	},
	reset_to_default = {
		vertical_alignment = "bottom",
		parent = "apply_button",
		horizontal_alignment = "right",
		position = {
			0,
			0,
			0
		},
		size = {
			150,
			30
		}
	},
	keybind_info = {
		vertical_alignment = "top",
		parent = "background_bottom_panel",
		horizontal_alignment = "left",
		position = {
			30,
			-7,
			1
		},
		size = {
			1000,
			30
		}
	},
	settings_button_1 = {
		vertical_alignment = "bottom",
		parent = "button_pivot",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			220,
			30
		}
	},
	settings_button_2 = {
		vertical_alignment = "bottom",
		parent = "button_pivot",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			220,
			30
		}
	},
	settings_button_3 = {
		vertical_alignment = "bottom",
		parent = "button_pivot",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			220,
			30
		}
	},
	settings_button_4 = {
		vertical_alignment = "bottom",
		parent = "button_pivot",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			220,
			30
		}
	},
	settings_button_5 = {
		vertical_alignment = "bottom",
		parent = "button_pivot",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			220,
			30
		}
	},
	settings_button_6 = {
		vertical_alignment = "bottom",
		parent = "button_pivot",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			220,
			30
		}
	},
	settings_button_7 = {
		vertical_alignment = "bottom",
		parent = "button_pivot",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			220,
			30
		}
	},
	settings_button_8 = {
		vertical_alignment = "bottom",
		parent = "button_pivot",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			220,
			30
		}
	},
	settings_button_9 = {
		vertical_alignment = "bottom",
		parent = "button_pivot",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			220,
			30
		}
	},
	settings_button_10 = {
		vertical_alignment = "bottom",
		parent = "button_pivot",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			220,
			30
		}
	},
	calibrate_ui_dummy = {
		position = {
			0,
			0,
			1
		},
		size = {
			1,
			1
		}
	}
}

local function fn(arg_1_0)
	-- function 1
	if not arg_1_0 then
		return 25 * arg_1_0
	else
		return 0
	end
end

local function fn_2(arg_2_0)
	-- function 2
	local tbl = {
		0,
		0
	}
	local tbl_2 = {
		5,
		5
	}

	return {
		scenegraph_id = "safe_rect",
		element = {
			passes = {
				{
					style_id = "bottom_left_triangle",
					pass_type = "triangle",
					content_change_function = function (arg_3_0, arg_3_1)
						-- function 3
						local user_setting = Application.user_setting("safe_rect")

						user_setting = user_setting or 0

						local num = user_setting * 0.01

						arg_3_1.offset[1] = tbl_2[1] + 1920 * num * 0.5
						arg_3_1.offset[2] = tbl_2[2] + 1080 * num * 0.5
					end
				},
				{
					style_id = "bottom_right_triangle",
					pass_type = "triangle",
					content_change_function = function (arg_4_0, arg_4_1)
						-- function 4
						local user_setting = Application.user_setting("safe_rect")

						user_setting = user_setting or 0

						local num = user_setting * 0.01

						arg_4_1.offset[1] = -tbl_2[1] - 1920 * num * 0.5
						arg_4_1.offset[2] = tbl_2[2] + 1080 * num * 0.5
					end
				},
				{
					style_id = "top_right_triangle",
					pass_type = "triangle",
					content_change_function = function (arg_5_0, arg_5_1)
						-- function 5
						local user_setting = Application.user_setting("safe_rect")

						user_setting = user_setting or 0

						local num = user_setting * 0.01

						arg_5_1.offset[1] = -tbl_2[1] - 1920 * num * 0.5
						arg_5_1.offset[2] = -tbl_2[2] - 1080 * num * 0.5
					end
				},
				{
					style_id = "top_left_triangle",
					pass_type = "triangle",
					content_change_function = function (arg_6_0, arg_6_1)
						-- function 6
						local user_setting = Application.user_setting("safe_rect")

						user_setting = user_setting or 0

						local num = user_setting * 0.01

						arg_6_1.offset[1] = tbl_2[1] + 1920 * num * 0.5
						arg_6_1.offset[2] = -tbl_2[2] - 1080 * num * 0.5
					end
				},
				{
					style_id = "left_line",
					pass_type = "rect",
					content_change_function = function (arg_7_0, arg_7_1)
						-- function 7
						local user_setting = Application.user_setting("safe_rect")

						user_setting = user_setting or 0

						local num = user_setting * 0.01

						arg_7_1.offset[1] = 1920 * num * 0.5
						arg_7_1.offset[2] = tbl_2[1] + 1080 * num * 0.5
						arg_7_1.texture_size[2] = 1080 - 1080 * num - tbl_2[2] * 2 - tbl[2]
					end
				},
				{
					style_id = "right_line",
					pass_type = "rect",
					content_change_function = function (arg_8_0, arg_8_1)
						-- function 8
						local user_setting = Application.user_setting("safe_rect")

						user_setting = user_setting or 0

						local num = user_setting * 0.01

						arg_8_1.offset[1] = -1920 * num * 0.5
						arg_8_1.offset[2] = tbl_2[1] + 1080 * num * 0.5
						arg_8_1.texture_size[2] = 1080 - 1080 * num - tbl_2[2] * 2 - tbl[2]
					end
				},
				{
					style_id = "top_line",
					pass_type = "rect",
					content_change_function = function (arg_9_0, arg_9_1)
						-- function 9
						local user_setting = Application.user_setting("safe_rect")

						user_setting = user_setting or 0

						local num = user_setting * 0.01

						arg_9_1.offset[1] = 1920 * num * 0.5
						arg_9_1.offset[2] = -1080 * num * 0.5
						arg_9_1.texture_size[1] = 1920 - 1920 * num - tbl[1]
					end
				},
				{
					style_id = "bottom_line",
					pass_type = "rect",
					content_change_function = function (arg_10_0, arg_10_1)
						-- function 10
						local user_setting = Application.user_setting("safe_rect")

						user_setting = user_setting or 0

						local num = user_setting * 0.01

						arg_10_1.offset[1] = 1920 * num * 0.5
						arg_10_1.offset[2] = 1080 * num * 0.5
						arg_10_1.texture_size[1] = 1920 - 1920 * num - tbl[1]
					end
				}
			}
		},
		content = {},
		style = {
			left_line = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = {
					5,
					1080
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
			},
			right_line = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					5,
					1080
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
			},
			top_line = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					1920,
					5
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
			},
			bottom_line = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = {
					1920,
					5
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
			},
			bottom_left_triangle = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				triangle_alignment = "bottom_left",
				texture_size = {
					100,
					100
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					500,
					500,
					0
				}
			},
			bottom_right_triangle = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				triangle_alignment = "bottom_right",
				texture_size = {
					100,
					100
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					500,
					500,
					0
				}
			},
			top_left_triangle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				triangle_alignment = "top_left",
				texture_size = {
					100,
					100
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					500,
					500,
					0
				}
			},
			top_right_triangle = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				triangle_alignment = "top_right",
				texture_size = {
					100,
					100
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					500,
					500,
					0
				}
			}
		},
		offset = {
			0,
			0,
			999
		}
	}
end

local function fn_3(arg_11_0, arg_11_1)
	-- function 11
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
			edge_holder_right = "menu_frame_12_divider_right",
			edge_holder_left = "menu_frame_12_divider_left",
			bottom_edge = "menu_frame_12_divider"
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
					arg_11_1[1] - 10,
					5
				},
				texture_tiling_size = {
					arg_11_1[1] - 10,
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
					arg_11_1[1] - 12,
					-6,
					10
				},
				size = {
					9,
					17
				}
			}
		},
		scenegraph_id = arg_11_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_4(arg_12_0, arg_12_1)
	-- function 12
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
			edge = "menu_frame_12_divider_vertical",
			edge_holder_top = "menu_frame_12_divider_top",
			edge_holder_bottom = "menu_frame_12_divider_bottom"
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
					arg_12_1[2] - 9
				},
				texture_tiling_size = {
					5,
					arg_12_1[2] - 9
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
					arg_12_1[2] - 7,
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
		scenegraph_id = arg_12_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local tbl_6 = {
	word_wrap = true,
	font_size = 28,
	localize = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	line_colors = {
		(Colors.get_color_table_with_alpha("font_title", 255))
	},
	offset = {
		32,
		-11,
		10
	}
}
local tbl_7 = {
	gamepad_tooltip_text = UIWidgets.create_simple_text("", "gamepad_tooltip_text", nil, nil, tbl_6)
}
local tbl_8 = {
	menu_symbol = UIWidgets.create_simple_texture("cogwheel_small", "menu_symbol", nil, nil, Colors.get_color_table_with_alpha("font_title", 255)),
	background_frame = UIWidgets.create_frame("background_frame", tbl_5.background_frame.size, "menu_frame_12"),
	background = UIWidgets.create_simple_rect("background", {
		255,
		15,
		15,
		15
	}),
	background_bottom_panel = UIWidgets.create_simple_rect("background_bottom_panel", {
		255,
		10,
		10,
		10
	}),
	background_bottom_panel_edge = fn_3("background_bottom_panel_edge", tbl_5.background_bottom_panel_edge.size),
	background_top_panel = UIWidgets.create_simple_rect("background_top_panel", {
		255,
		10,
		10,
		10
	}),
	background_top_panel_edge = fn_3("background_top_panel_edge", tbl_5.background_top_panel_edge.size),
	right_frame = {
		scenegraph_id = "right_frame",
		element = {
			passes = {
				{
					style_id = "edge_fade_top_id",
					pass_type = "texture_uv",
					content_id = "edge_fade_top_id"
				},
				{
					style_id = "edge_fade_bottom_id",
					pass_type = "texture_uv",
					content_id = "edge_fade_bottom_id"
				},
				{
					pass_type = "scroll",
					scroll_function = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
						-- function 13
						local is_device_active = Managers.input:is_device_active("gamepad")
						local scroll_step = arg_13_2.scroll_step

						scroll_step = scroll_step or 0.1

						local internal_scroll_value = arg_13_2.internal_scroll_value

						if is_device_active or not IS_XB1 then
							internal_scroll_value = internal_scroll_value + scroll_step * -arg_13_4.x * 0.01
						else
							internal_scroll_value = internal_scroll_value + scroll_step * -arg_13_4.y
						end

						arg_13_2.internal_scroll_value = math.clamp(internal_scroll_value, 0, 1)
					end
				}
			}
		},
		content = {
			internal_scroll_value = 0,
			texture_id = "settings_window_02",
			edge_fade_top_id = {
				texture_id = "mask_rect_edge_fade",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			},
			edge_fade_bottom_id = {
				texture_id = "mask_rect_edge_fade",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			}
		},
		style = {
			edge_fade_bottom_id = {
				scenegraph_id = "list_edge_fade_bottom",
				color = {
					255,
					255,
					255,
					255
				}
			},
			edge_fade_top_id = {
				scenegraph_id = "list_edge_fade_top",
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	},
	list_mask = {
		scenegraph_id = "list_mask",
		element = UIElements.SimpleTexture,
		content = {
			texture_id = "mask_rect"
		},
		style = {
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	dead_space_filler = {
		scenegraph_id = "dead_space_filler",
		element = UIElements.SimpleTexture,
		content = {
			texture_id = "gradient_dice_game_reward"
		},
		style = {
			color = {
				255,
				255,
				255,
				255
			}
		}
	}
}
local tbl_9 = {
	keybind_info = UIWidgets.create_simple_text("Hello world", "keybind_info", nil, nil, {
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = 24,
		horizontal_alignment = "left",
		text_color = Colors.get_color_table_with_alpha("font_default", 255)
	})
}

;({}).passes = {
	{
		pass_type = "hotspot",
		content_id = "hotspot"
	},
	{
		pass_type = "texture",
		texture_id = "texture_id",
		content_check_function = function (self)
			-- function 14
			return not not self.hotspot.is_hover or self.hotspot.is_clicked > 0
		end
	},
	{
		pass_type = "texture",
		texture_id = "texture_hover_id",
		content_check_function = function (self)
			-- function 15
			local is_hover = self.hotspot.is_hover

			is_hover = not is_hover and self.hotspot.is_clicked > 0

			return is_hover
		end
	},
	{
		pass_type = "texture",
		texture_id = "texture_click_id",
		content_check_function = function (self)
			-- function 16
			return self.hotspot.is_clicked == 0 or self.hotspot.is_selected
		end
	},
	{
		style_id = "text",
		pass_type = "text",
		text_id = "text_field",
		content_check_function = function (self, arg_17_1)
			-- function 17
			if not self.hotspot.is_hover then
				arg_17_1.text_color = arg_17_1.hover_color
			else
				arg_17_1.text_color = arg_17_1.default_color
			end

			return true
		end
	}
}

local function fn_5(arg_18_0, arg_18_1)
	-- function 18
	local size = tbl_5[arg_18_0].size
	local tbl = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				pass_type = "texture",
				style_id = "button_texture",
				texture_id = "button_texture",
				content_check_function = function (self)
					-- function 19
					return not self.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "button_texture_hover",
				texture_id = "button_texture",
				content_check_function = function (self)
					-- function 20
					return self.button_hotspot.is_hover
				end
			}
		}
	}
	local tbl_2 = {
		button_texture = arg_18_1,
		button_hotspot = {}
	}
	local tbl_3 = {
		size = {
			size[1],
			size[2]
		},
		color = {
			255,
			255,
			255,
			255
		},
		button_texture_hover = {
			size = {
				size[1],
				size[2]
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		button_texture = {
			size = {
				size[1],
				size[2]
			},
			color = Colors.get_color_table_with_alpha("font_button_normal", 255)
		}
	}

	return {
		element = tbl,
		content = tbl_2,
		style = tbl_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_18_0
	}
end

local tbl_10 = {
	exit_button = fn_5("exit_button", "friends_icon_close"),
	back_button = UIWidgets.create_layout_button("back_button", "layout_button_back", "layout_button_back_glow"),
	apply_button = UIWidgets.create_text_button("apply_button", "menu_settings_apply", 22, nil, "center"),
	reset_to_default = UIWidgets.create_text_button("reset_to_default", "menu_settings_reset_to_default", 22, nil, "center")
}
local var_0_21 = tbl_5.list_mask.size[1]
local size = tbl_5.scrollbar_root.size
local create_scrollbar = UIWidgets.create_scrollbar("scrollbar_root", size)
local flag = false
local tbl_11 = {
	var_0_21,
	30
}

local function fn_6(arg_21_0, arg_21_1, arg_21_2)
	-- function 21
	arg_21_2[2] = arg_21_2[2] - tbl_11[2]

	local tbl = {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "highlight_hotspot"
				},
				{
					style_id = "checkbox",
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "texture",
					style_id = "bottom_edge",
					texture_id = "rect_masked"
				},
				{
					pass_type = "texture",
					style_id = "highlight_texture",
					texture_id = "highlight_texture",
					content_check_function = function (self)
						-- function 22
						return self.is_highlighted
					end
				},
				{
					pass_type = "local_offset",
					offset_function = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
						-- function 23
						if not arg_23_2.hotspot.on_release then
							arg_23_2.flag = not arg_23_2.flag
						end

						if not arg_23_2.flag then
							arg_23_2.checkbox = "checkbox_checked"
						else
							arg_23_2.checkbox = "checkbox_unchecked"
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "checkbox",
					texture_id = "checkbox"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "rect",
					content_check_function = function (arg_24_0)
						-- function 24
						return flag
					end
				},
				{
					pass_type = "border",
					content_check_function = function (arg_25_0, arg_25_1)
						-- function 25
						if not flag then
							arg_25_1.thickness = 1
						end

						return flag
					end
				},
				{
					style_id = "debug_middle_line",
					pass_type = "rect",
					content_check_function = function (arg_26_0)
						-- function 26
						return flag
					end
				}
			}
		},
		content = {
			rect_masked = "rect_masked",
			flag = false,
			checkbox = "checkbox_unchecked",
			highlight_texture = "playerlist_hover",
			hotspot = {},
			highlight_hotspot = {
				allow_multi_hover = true
			},
			text = arg_21_0,
			hotspot_content_ids = {
				"hotspot"
			}
		},
		style = {
			highlight_texture = {
				masked = true,
				offset = {
					arg_21_2[1],
					arg_21_2[2],
					arg_21_2[3]
				},
				color = Colors.get_table("white"),
				size = {
					tbl_11[1],
					tbl_11[2]
				}
			},
			checkbox = {
				masked = true,
				offset = {
					arg_21_2[1] + 642,
					arg_21_2[2] + 17,
					arg_21_2[3]
				},
				size = {
					16,
					16
				}
			},
			text = {
				upper_case = true,
				localize = true,
				dynamic_font = true,
				font_size = 28,
				font_type = "hell_shark_masked",
				offset = {
					arg_21_2[1] + 2,
					arg_21_2[2] + 5,
					arg_21_2[3]
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255)
			},
			offset = {
				arg_21_2[1],
				arg_21_2[2],
				arg_21_2[3]
			},
			size = table.clone(tbl_11),
			color = {
				50,
				255,
				255,
				255
			},
			debug_middle_line = {
				offset = {
					arg_21_2[1],
					arg_21_2[2] + tbl_11[2] / 2 - 1,
					arg_21_2[3] + 10
				},
				size = {
					tbl_11[1],
					2
				},
				color = {
					200,
					0,
					255,
					0
				}
			},
			bottom_edge = {
				offset = {
					arg_21_2[1],
					arg_21_2[2],
					arg_21_2[3] + 1
				},
				color = get_color_table_with_alpha,
				size = {
					tbl_11[1],
					num_5
				}
			}
		},
		scenegraph_id = arg_21_1
	}

	return UIWidget.init(tbl)
end

local function fn_7(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	arg_27_3[2] = arg_27_3[2] - arg_27_1[2]

	local tbl = {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				}
			}
		},
		content = {
			rect_masked = "rect_masked",
			texture_id = arg_27_0
		},
		style = {
			size = {
				arg_27_1[1],
				arg_27_1[2]
			},
			offset = {
				arg_27_3[1],
				arg_27_3[2],
				arg_27_3[3]
			},
			texture_id = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_27_3[1],
					arg_27_3[2],
					arg_27_3[3] + 15
				},
				size = {
					arg_27_1[1],
					arg_27_1[2]
				}
			},
			bottom_edge = {
				offset = {
					arg_27_3[1],
					arg_27_3[2],
					arg_27_3[3] + 1
				},
				color = get_color_table_with_alpha,
				size = {
					arg_27_1[1],
					num_5
				}
			}
		},
		scenegraph_id = arg_27_2
	}

	return UIWidget.init(tbl)
end

local function fn_8(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	-- function 28
	arg_28_5[2] = arg_28_5[2] - arg_28_1[2]

	local PLATFORM = PLATFORM
	local var_28_1

	if not IS_WINDOWS then
		var_28_1 = UIWidgets.create_gamepad_layout_win32(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_5, arg_28_4)
	elseif not IS_XB1 then
		var_28_1 = UIWidgets.create_gamepad_layout_xb1(arg_28_0, arg_28_1, arg_28_5, arg_28_4)
	elseif not IS_PS4 then
		var_28_1 = UIWidgets.create_gamepad_layout_ps4(arg_28_0, arg_28_1, arg_28_5, arg_28_4)
	end

	return UIWidget.init(var_28_1)
end

local tbl_12 = {
	var_0_21 - 100,
	30
}

local function fn_9(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	-- function 29
	arg_29_3[2] = arg_29_3[2] - tbl_12[2]

	local tbl_2 = {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "slider_box",
					texture_id = "rect_masked",
					content_check_function = function (self)
						-- function 30
						return not self.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "disabled_slider_box",
					texture_id = "rect_masked",
					content_check_function = function (self)
						-- function 31
						return self.disabled
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "texture",
					style_id = "bottom_edge",
					texture_id = "rect_masked"
				},
				{
					pass_type = "texture",
					style_id = "input_field_background",
					texture_id = "rect_masked"
				},
				{
					pass_type = "texture",
					style_id = "input_field_background_2",
					texture_id = "rect_masked"
				},
				{
					pass_type = "hotspot",
					content_id = "highlight_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "highlight_texture",
					texture_id = "highlight_texture",
					content_check_function = function (self)
						-- function 32
						return self.is_highlighted
					end
				},
				{
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function (self)
						-- function 33
						local tooltip_text = self.tooltip_text

						if not tooltip_text then
							tooltip_text = self.highlight_hotspot.is_hover
							tooltip_text = not tooltip_text and not Managers.input:is_device_active("gamepad")
						end

						return tooltip_text
					end
				},
				{
					content_check_hover = "hotspot",
					pass_type = "held",
					style_id = "slider_box",
					held_function = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
						-- function 34
						local var_34_0
						local is_device_active = Managers.input:is_device_active("gamepad")

						if not is_device_active then
							var_34_0 = arg_34_3:get("cursor")
						elseif not (not IS_XB1 and not GameSettingsDevelopment.allow_keyboard_mouse and is_device_active) then
							var_34_0 = arg_34_3:get("cursor")
						else
							var_34_0 = UIInverseScaleVectorToResolution(arg_34_3:get("cursor"))
						end

						local scenegraph_id = arg_34_2.scenegraph_id
						local get_world_position = UISceneGraph.get_world_position(arg_34_0, scenegraph_id)
						local var_34_4 = arg_34_1.size[1]
						local var_34_5 = var_34_0[1]
						local num = get_world_position[1] + arg_34_1.offset[1]
						local internal_value = arg_34_2.internal_value
						local num_2 = var_34_5 - num
						local clamp = math.clamp(num_2 / var_34_4, 0, 1)

						arg_34_2.internal_value = clamp

						if not (internal_value == clamp or arg_34_2.callback_on_release) then
							arg_34_2.callback(arg_34_2, arg_34_1.parent)
						end
					end,
					release_function = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
						-- function 35
						arg_35_2.callback(arg_35_2, arg_35_1.parent)
					end
				},
				{
					style_id = "slider_box_hotspot",
					pass_type = "hotspot",
					content_id = "hotspot",
					content_check_function = function (self)
						-- function 36
						return not self.parent.disabled
					end
				},
				{
					pass_type = "local_offset",
					offset_function = function (arg_37_0, arg_37_1, arg_37_2)
						-- function 37
						local internal_value = arg_37_2.internal_value
						local min = arg_37_2.min
						local max = arg_37_2.max
						local round_with_precision = math.round_with_precision
						local num = min + (max - min) * internal_value
						local num_decimals = arg_37_2.num_decimals

						num_decimals = num_decimals or 0

						local var_37_6 = round_with_precision(num, num_decimals)

						arg_37_2.value = var_37_6
						arg_37_2.value_text = var_37_6

						local slider_box = arg_37_1.slider_box
						local size = slider_box.size
						local var_37_9 = slider_box.offset[1]
						local num_2 = size[1] * internal_value
						local slider = arg_37_1.slider
						local slider_hover = arg_37_1.slider_hover
						local offset = slider.offset
						local size_2 = slider.size
						local max_2 = math.max(0, math.min(num_2 - size_2[1], size[1] - size_2[1]))

						slider.offset[1] = var_37_9 + num_2 - slider.size[1] / 2
						slider_hover.offset[1] = slider.offset[1] + size_2[1] / 2 - slider_hover.size[1] / 2

						if arg_37_2.hotspot.is_hover or not arg_37_2.altering_value then
							arg_37_1.value_text.text_color = arg_37_1.value_text.hover_color
						else
							arg_37_1.value_text.text_color = arg_37_1.value_text.default_color
						end
					end
				},
				{
					style_id = "value_text",
					pass_type = "text",
					text_id = "value_text",
					content_check_function = function (self)
						-- function 38
						return not self.disabled
					end
				},
				{
					style_id = "disabled_value_text",
					pass_type = "text",
					text_id = "value_text",
					content_check_function = function (self)
						-- function 39
						return self.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "slider",
					texture_id = "slider",
					content_check_function = function (self)
						-- function 40
						return not self.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "slider_hover",
					texture_id = "slider_hover",
					content_check_function = function (self)
						-- function 41
						if not self.disabled then
							return false
						end

						return self.hotspot.is_hover
					end
				},
				{
					pass_type = "rect",
					content_check_function = function (arg_42_0)
						-- function 42
						return flag
					end
				},
				{
					style_id = "slider_box",
					pass_type = "rect",
					content_check_function = function (arg_43_0)
						-- function 43
						return flag
					end
				},
				{
					pass_type = "border",
					content_check_function = function (arg_44_0, arg_44_1)
						-- function 44
						if not flag then
							arg_44_1.thickness = 1
						end

						return flag
					end
				},
				{
					style_id = "debug_middle_line",
					pass_type = "rect",
					content_check_function = function (arg_45_0)
						-- function 45
						return flag
					end
				},
				{
					pass_type = "texture",
					style_id = "slider_image",
					texture_id = "slider_image",
					content_check_function = function (self)
						-- function 46
						return self.slider_image ~= ""
					end
				},
				{
					style_id = "slider_image_text",
					pass_type = "text",
					text_id = "slider_image_text",
					content_check_function = function (self)
						-- function 47
						return self.slider_image_text ~= ""
					end
				},
				{
					style_id = "left_arrow",
					pass_type = "hotspot",
					content_id = "left_hotspot",
					content_check_function = function (self)
						-- function 48
						return not self.parent.disabled
					end
				},
				{
					style_id = "right_arrow",
					pass_type = "hotspot",
					content_id = "right_hotspot",
					content_check_function = function (self)
						-- function 49
						return not self.parent.disabled
					end
				},
				{
					texture_id = "texture_id",
					style_id = "left_arrow",
					pass_type = "texture",
					content_id = "arrow",
					content_check_function = function (self)
						-- function 50
						return not self.parent.disabled
					end
				},
				{
					texture_id = "texture_id",
					style_id = "right_arrow",
					pass_type = "texture_uv",
					content_id = "arrow",
					content_check_function = function (self)
						-- function 51
						return not self.parent.disabled
					end
				},
				{
					texture_id = "texture_id",
					style_id = "left_arrow_hover",
					pass_type = "texture",
					content_id = "arrow_hover",
					content_check_function = function (self)
						-- function 52
						return not self.parent.disabled
					end
				},
				{
					texture_id = "texture_id",
					style_id = "right_arrow_hover",
					pass_type = "texture_uv",
					content_id = "arrow_hover",
					content_check_function = function (self)
						-- function 53
						return not self.parent.disabled
					end
				},
				{
					pass_type = "local_offset",
					offset_function = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
						-- function 54
						local left_hotspot = arg_54_2.left_hotspot
						local right_hotspot = arg_54_2.right_hotspot

						if not left_hotspot.on_hover_enter then
							local on_hover_enter_callback = arg_54_2.on_hover_enter_callback

							if not on_hover_enter_callback then
								on_hover_enter_callback("left_arrow_hover")
							end
						end

						if not left_hotspot.on_hover_exit then
							local on_hover_exit_callback = arg_54_2.on_hover_exit_callback

							if not on_hover_exit_callback then
								on_hover_exit_callback("left_arrow_hover")
							end
						end

						if not left_hotspot.on_release then
							local on_pressed_callback = arg_54_2.on_pressed_callback

							if not on_pressed_callback then
								on_pressed_callback("left_arrow")
								on_pressed_callback("left_arrow_hover")
							end
						end

						if not right_hotspot.on_hover_enter then
							local on_hover_enter_callback_2 = arg_54_2.on_hover_enter_callback

							if not on_hover_enter_callback_2 then
								on_hover_enter_callback_2("right_arrow_hover")
							end
						end

						if not right_hotspot.on_hover_exit then
							local on_hover_exit_callback_2 = arg_54_2.on_hover_exit_callback

							if not on_hover_exit_callback_2 then
								on_hover_exit_callback_2("right_arrow_hover")
							end
						end

						if not right_hotspot.on_release then
							local on_pressed_callback_2 = arg_54_2.on_pressed_callback

							if not on_pressed_callback_2 then
								on_pressed_callback_2("right_arrow")
								on_pressed_callback_2("right_arrow_hover")
							end
						end
					end
				}
			}
		}
	}
	local tbl_3 = {
		slider = "slider_thumb",
		internal_value = 0.5,
		rect_masked = "rect_masked",
		slider_hover = "slider_thumb_hover",
		value = 0.5,
		highlight_texture = "playerlist_hover",
		scenegraph_id = arg_29_2,
		text = arg_29_0
	}
	local slider_image

	if not arg_29_4 then
		slider_image = arg_29_4.slider_image

		if not slider_image then
			-- Nothing
		end
	end

	slider_image = ""

	::label_29_0::

	tbl_3.slider_image = slider_image

	local text

	if not arg_29_5 then
		text = arg_29_5.text

		if not text then
			-- Nothing
		end
	end

	text = ""

	::label_29_1::

	tbl_3.slider_image_text = text
	tbl_3.tooltip_text = arg_29_1
	tbl_3.hotspot = {}
	tbl_3.highlight_hotspot = {
		allow_multi_hover = true
	}
	tbl_3.hotspot_content_ids = {
		"hotspot"
	}
	tbl_3.left_hotspot = {}
	tbl_3.right_hotspot = {}
	tbl_3.arrow = {
		texture_id = "settings_arrow_normal",
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
	}
	tbl_3.arrow_hover = {
		texture_id = "settings_arrow_clicked",
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
	}
	tbl_2.content = tbl_3

	local tbl_4 = {}
	local tbl_5 = {
		arg_29_3[1]
	}
	local var_29_6 = arg_29_3[2]
	local var_29_7

	if not arg_29_4 then
		var_29_7 = arg_29_4.size[2]

		if not var_29_7 then
			-- Nothing
		end
	end

	var_29_7 = 0

	::label_29_2::

	tbl_5[2] = var_29_6 - var_29_7
	tbl_5[3] = arg_29_3[3]
	tbl_4.offset = tbl_5

	local tbl_6 = {
		tbl_12[1]
	}
	local var_29_9 = tbl_12[2]
	local var_29_10

	if not arg_29_4 then
		var_29_10 = arg_29_4.size[2]

		if not var_29_10 then
			-- Nothing
		end
	end

	var_29_10 = 0

	::label_29_3::

	tbl_6[2] = var_29_9 + var_29_10
	tbl_4.size = tbl_6
	tbl_4.color = {
		50,
		255,
		255,
		255
	}
	tbl_4.highlight_texture = {
		masked = true,
		offset = {
			arg_29_3[1],
			arg_29_3[2],
			arg_29_3[3]
		},
		color = Colors.get_table("white"),
		size = {
			tbl_12[1],
			tbl_12[2]
		}
	}
	tbl_4.tooltip_text = {
		font_size = 24,
		width = 500,
		localize = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		line_colors = {
			(Colors.get_color_table_with_alpha("font_title", 255))
		},
		offset = {
			0,
			0,
			0
		}
	}
	tbl_4.text = {
		upper_case = true,
		localize = true,
		dynamic_font = true,
		font_size = 16,
		font_type = "hell_shark_masked",
		offset = {
			arg_29_3[1],
			arg_29_3[2] + 5,
			arg_29_3[3]
		},
		text_color = Colors.get_color_table_with_alpha("font_default", 255)
	}
	tbl_4.slider_box = {
		offset = {
			arg_29_3[1] + tbl_12[1] - num + 30,
			arg_29_3[2] + tbl_12[2] / 2 - 4,
			arg_29_3[3] + 10
		},
		size = {
			num - 112,
			10
		},
		color = {
			255,
			5,
			5,
			5
		}
	}
	tbl_4.disabled_slider_box = {
		offset = {
			arg_29_3[1] + tbl_12[1] - num + 30,
			arg_29_3[2] + tbl_12[2] / 2 - 4,
			arg_29_3[3] + 10
		},
		size = {
			num - 112,
			10
		},
		color = {
			255,
			20,
			20,
			20
		}
	}
	tbl_4.slider_box_hotspot = {
		offset = {
			arg_29_3[1] + tbl_12[1] - num + 19,
			arg_29_3[2] + tbl_12[2] / 2 - 13.5,
			arg_29_3[3] + 10
		},
		size = {
			num - 90,
			27
		}
	}
	tbl_4.slider = {
		masked = true,
		color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			arg_29_3[1] + tbl_12[1] - num,
			arg_29_3[2] + tbl_12[2] / 2 - 13.5,
			arg_29_3[3] + 15
		},
		size = {
			14,
			27
		}
	}
	tbl_4.slider_hover = {
		masked = true,
		color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			arg_29_3[1] + tbl_12[1] - num,
			arg_29_3[2] + tbl_12[2] / 2 - 12.5,
			arg_29_3[3] + 15
		},
		size = {
			34,
			25
		}
	}
	tbl_4.input_field_background = {
		offset = {
			arg_29_3[1] + tbl_12[1] - 50 - 2,
			arg_29_3[2] + tbl_12[2] / 2 - (tbl_12[2] - 10) / 2,
			arg_29_3[3]
		},
		color = tbl,
		size = {
			52,
			tbl_12[2] - 10 + 2
		}
	}
	tbl_4.input_field_background_2 = {
		offset = {
			arg_29_3[1] + tbl_12[1] - 50,
			arg_29_3[2] + tbl_12[2] / 2 - (tbl_12[2] - 10) / 2,
			arg_29_3[3] + 1
		},
		color = {
			255,
			10,
			10,
			10
		},
		size = {
			50,
			tbl_12[2] - 10
		}
	}
	tbl_4.value_text = {
		font_size = 16,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		dynamic_font = true,
		font_type = "hell_shark_masked",
		offset = {
			arg_29_3[1] + tbl_12[1] - 25,
			arg_29_3[2] + tbl_12[2] / 2 - (tbl_12[2] - 10) / 2 - 2,
			arg_29_3[3] + 2
		},
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		default_color = Colors.get_color_table_with_alpha("font_default", 255),
		hover_color = Colors.get_color_table_with_alpha("font_default", 255)
	}
	tbl_4.disabled_value_text = {
		font_size = 16,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		dynamic_font = true,
		font_type = "hell_shark_masked",
		offset = {
			arg_29_3[1] + tbl_12[1] - 25,
			arg_29_3[2] + tbl_12[2] / 2 - (tbl_12[2] - 10) / 2 - 2,
			arg_29_3[3] + 2
		},
		text_color = Colors.get_color_table_with_alpha("font_default", 50),
		default_color = Colors.get_color_table_with_alpha("font_default", 255),
		hover_color = Colors.get_color_table_with_alpha("font_default", 255)
	}
	tbl_4.debug_middle_line = {
		offset = {
			arg_29_3[1],
			arg_29_3[2] + tbl_12[2] / 2 - 1,
			arg_29_3[3] + 10
		},
		size = {
			tbl_12[1],
			2
		},
		color = {
			200,
			0,
			255,
			0
		}
	}

	local tbl_7 = {
		masked = true
	}
	local color

	if not arg_29_4 then
		color = arg_29_4.color

		if not color then
			-- Nothing
		end
	end

	color = nil

	::label_29_4::

	tbl_7.color = color

	local size

	if not arg_29_4 then
		size = arg_29_4.size

		if not size then
			-- Nothing
		end
	end

	size = {
		0,
		0
	}

	::label_29_5::

	tbl_7.size = size

	local tbl_8 = {}
	local num_2 = arg_29_3[1] + tbl_12[1]
	local var_29_16

	if not arg_29_4 then
		var_29_16 = arg_29_4.size[1]

		if not var_29_16 then
			-- Nothing
		end
	end

	var_29_16 = 0

	::label_29_6::

	tbl_8[1] = num_2 - var_29_16

	local var_29_17 = arg_29_3[2]
	local var_29_18

	if not arg_29_4 then
		var_29_18 = arg_29_4.size[2]

		if not var_29_18 then
			-- Nothing
		end
	end

	var_29_18 = 0

	::label_29_7::

	tbl_8[2] = var_29_17 - var_29_18
	tbl_8[3] = arg_29_3[3] + 15
	tbl_7.offset = tbl_8
	tbl_4.slider_image = tbl_7

	local tbl_9 = {
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font = true
	}
	local tbl_10 = {}
	local num_3 = arg_29_3[1] + tbl_12[1]
	local var_29_22

	if not arg_29_4 then
		var_29_22 = arg_29_4.size[1]

		if not var_29_22 then
			-- Nothing
		end
	end

	var_29_22 = 0

	::label_29_8::

	tbl_10[1] = num_3 - var_29_22 + 5

	local var_29_23 = arg_29_3[2]
	local num_4

	if not arg_29_4 then
		num_4 = arg_29_4.size[2] / 2

		if not num_4 then
			-- Nothing
		end
	end

	num_4 = 0

	::label_29_9::

	tbl_10[2] = var_29_23 - num_4
	tbl_10[3] = arg_29_3[3] + 16
	tbl_9.offset = tbl_10

	local color_2

	if not arg_29_5 then
		color_2 = arg_29_5.color

		if not color_2 then
			-- Nothing
		end
	end

	color_2 = Colors.get_color_table_with_alpha("font_default", 255)

	::label_29_10::

	tbl_9.text_color = color_2

	local upper_case

	if not arg_29_5 then
		upper_case = arg_29_5.upper_case

		if not upper_case then
			-- Nothing
		end
	end

	upper_case = false

	::label_29_11::

	tbl_9.upper_case = upper_case

	local font

	if not arg_29_5 then
		font = arg_29_5.font

		if not font then
			-- Nothing
		end
	end

	font = "hell_shark_masked"

	::label_29_12::

	tbl_9.font_type = font

	local font_size

	if not arg_29_5 then
		font_size = arg_29_5.font_size

		if not font_size then
			-- Nothing
		end
	end

	font_size = 16

	::label_29_13::

	tbl_9.font_size = font_size

	local localize

	if not arg_29_5 then
		localize = arg_29_5.localize

		if not localize then
			-- Nothing
		end
	end

	localize = false

	::label_29_14::

	tbl_9.localize = localize
	tbl_4.slider_image_text = tbl_9
	tbl_4.bottom_edge = {
		offset = {
			arg_29_3[1],
			arg_29_3[2],
			arg_29_3[3] + 1
		},
		color = get_color_table_with_alpha,
		size = {
			tbl_12[1],
			num_5
		}
	}
	tbl_4.left_arrow = {
		masked = true,
		offset = {
			arg_29_3[1] + tbl_12[1] - num,
			arg_29_3[2] + (tbl_12[2] / 2 - 13.5),
			arg_29_3[3] + 1
		},
		size = {
			19,
			27
		},
		color = Colors.get_color_table_with_alpha("font_default", 255)
	}
	tbl_4.left_arrow_hover = {
		masked = true,
		offset = {
			arg_29_3[1] + tbl_12[1] - num + 6,
			arg_29_3[2] + (tbl_12[2] / 2 - 17.5),
			arg_29_3[3]
		},
		size = {
			30,
			35
		},
		color = {
			0,
			255,
			255,
			255
		}
	}
	tbl_4.left_arrow_hotspot = {
		offset = {
			arg_29_3[1] + tbl_12[1] - num,
			arg_29_3[2] + (tbl_12[2] / 2 - 13.5),
			arg_29_3[3]
		},
		size = {
			num / 2,
			27
		}
	}
	tbl_4.right_arrow = {
		masked = true,
		offset = {
			arg_29_3[1] + tbl_12[1] - 19 - 52,
			arg_29_3[2] + (tbl_12[2] / 2 - 13.5),
			arg_29_3[3]
		},
		size = {
			19,
			27
		},
		color = Colors.get_color_table_with_alpha("font_default", 255),
		pivot = {
			9.5,
			13.5
		}
	}
	tbl_4.right_arrow_hover = {
		masked = true,
		offset = {
			arg_29_3[1] + tbl_12[1] - 30 - 52 - 5,
			arg_29_3[2] + (tbl_12[2] / 2 - 17.5),
			arg_29_3[3]
		},
		size = {
			30,
			35
		},
		color = {
			0,
			255,
			255,
			255
		},
		pivot = {
			9.5,
			13.5
		}
	}
	tbl_4.right_arrow_hotspot = {
		offset = {
			arg_29_3[1] + tbl_12[1] - num / 2,
			arg_29_3[2] + (tbl_12[2] / 2 - 13.5),
			arg_29_3[3]
		},
		size = {
			num / 2,
			27
		}
	}
	tbl_2.style = tbl_4
	tbl_2.scenegraph_id = arg_29_2

	local num_6 = arg_29_3[2] - tbl_12[2]
	local var_29_31

	if not arg_29_4 then
		var_29_31 = arg_29_4.size[2]

		if not var_29_31 then
			-- Nothing
		end
	end

	var_29_31 = 0

	::label_29_15::

	arg_29_3[2] = num_6 - var_29_31

	return UIWidget.init(tbl_2)
end

local tbl_13 = {
	var_0_21 - 100,
	30
}

local function fn_10(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6, arg_55_7, arg_55_8)
	-- function 55
	local tbl = {}
	local tbl_2 = {}
	local count = #arg_55_1

	for i = 1, count do
		tbl[i] = arg_55_1[i].text
		tbl_2[i] = arg_55_1[i].value
	end

	arg_55_6[2] = arg_55_6[2] - tbl_13[2]

	local tbl_3 = {
		num - 56,
		24
	}
	local tbl_4 = {}
	local tbl_5 = {}
	local min = math.min(count, 10)
	local num_2 = tbl_3[2] * min
	local flag_2 = min < count

	if not flag_2 then
		tbl_3[1] = tbl_3[1] - 25
	end

	for j = 1, count do
		tbl_5[j], tbl_4[j] = {
			selected = false,
			highlight_texture = "playerlist_hover",
			hotspot = {},
			text = tbl[j]
		}, {
			text = {
				horizontal_alignment = "center",
				font_size = 16,
				dynamic_font = true,
				font_type = "hell_shark",
				offset = {
					0,
					0,
					25
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				hover_color = Colors.get_color_table_with_alpha("font_default", 255),
				disabled_color = Colors.get_color_table_with_alpha("font_default", 75),
				upper_case = not arg_55_8,
				size = tbl_3
			},
			highlight_texture = {
				offset = {
					0,
					0,
					24
				},
				color = Colors.get_table("white"),
				size = tbl_3
			},
			size = tbl_3,
			color = {
				50,
				255,
				255,
				255
			}
		}
	end

	local pi = math.pi
	local tbl_6 = {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_change_function = function (self, arg_56_1)
						-- function 56
						if not self.disabled then
							arg_56_1.text_color = arg_56_1.disabled_color
						else
							arg_56_1.text_color = arg_56_1.default_color
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "bottom_edge",
					texture_id = "rect_masked"
				},
				{
					pass_type = "hotspot",
					content_id = "highlight_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "highlight_texture",
					texture_id = "highlight_texture",
					content_check_function = function (self)
						-- function 57
						return self.is_highlighted
					end
				},
				{
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function (self)
						-- function 58
						if not self.highlight_hotspot.is_hover and not Managers.input:is_device_active("gamepad") then
							return false
						end

						if not self.disabled then
							return self.tooltip_text
						else
							return not self.disabled_tooltip_text
						end
					end
				},
				{
					style_id = "disabled_tooltip_text",
					pass_type = "option_tooltip",
					text_id = "disabled_tooltip_text",
					content_check_function = function (self)
						-- function 59
						if not self.disabled and not self.highlight_hotspot.is_hover and not Managers.input:is_device_active("gamepad") then
							return false
						end

						if not self.overriden_reason then
							self.disabled_tooltip_text = self.overriden_reason
						end

						if not self.disabled_tooltip_text then
							return true
						end
					end
				},
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					texture_id = "texture_id",
					style_id = "arrow",
					pass_type = "texture_uv",
					content_id = "arrow",
					content_check_function = function (self, arg_60_1)
						-- function 60
						local parent = self.parent

						if not parent.disabled then
							return false
						end

						return parent.active
					end
				},
				{
					texture_id = "texture_id",
					style_id = "arrow",
					pass_type = "texture",
					content_id = "arrow",
					content_check_function = function (self, arg_61_1)
						-- function 61
						local parent = self.parent

						if not parent.disabled then
							return false
						end

						return not parent.active
					end
				},
				{
					texture_id = "texture_id",
					style_id = "arrow_hover_flipped",
					pass_type = "texture_uv",
					content_id = "arrow_hover",
					content_check_function = function (self, arg_62_1)
						-- function 62
						local parent = self.parent

						if not parent.hotspot.is_hover then
							if not parent.disabled then
								return false
							end

							return parent.active
						end
					end
				},
				{
					texture_id = "texture_id",
					style_id = "arrow_hover",
					pass_type = "texture",
					content_id = "arrow_hover",
					content_check_function = function (self, arg_63_1)
						-- function 63
						local parent = self.parent

						if not parent.hotspot.is_hover then
							if not parent.disabled then
								return false
							end

							return not parent.active
						end
					end
				},
				{
					style_id = "selected_option",
					pass_type = "text",
					text_id = "selected_option",
					content_check_function = function (self, arg_64_1)
						-- function 64
						if not self.disabled then
							arg_64_1.text_color = arg_64_1.disabled_color
						elseif self.hotspot.is_hover or not self.active then
							arg_64_1.text_color = arg_64_1.hover_color
						else
							arg_64_1.text_color = arg_64_1.default_color
						end

						if not (self._last_selection ~= self.current_selection or self._last_overriden_setting == self.overriden_setting) then
							self._last_selection = self.current_selection
							self._last_overriden_setting = self.overriden_setting

							local upper = Utf8.upper
							local var_64_1 = self.options_texts[self.current_selection]

							var_64_1 = var_64_1 or "n/a"

							local var_64_2 = upper(var_64_1)
							local overriden_setting = self.overriden_setting

							if not overriden_setting then
								local override_color

								if not self.disabled then
									override_color = arg_64_1.override_color

									if not override_color then
										-- Nothing
									end
								end

								override_color = arg_64_1.default_color

								::label_64_0::

								local disabled_color = arg_64_1.disabled_color

								self.selected_option = string.format("{#color(%d,%d,%d,%d)}%s {#color(%d,%d,%d,%d);strike(true)}%s{#strike(false)}", override_color[2], override_color[3], override_color[4], override_color[1], var_64_2, disabled_color[2], disabled_color[3], disabled_color[4], disabled_color[1], Utf8.upper(overriden_setting))
							else
								self.selected_option = var_64_2
							end
						end

						if self.selected_option == nil then
							self.selected_option = ""
						end

						return true
					end
				},
				{
					style_id = "list_style",
					pass_type = "list_pass",
					content_id = "list_content",
					content_check_function = function (arg_65_0, arg_65_1)
						-- function 65
						return arg_65_1.active
					end,
					passes = {
						{
							pass_type = "hotspot",
							content_id = "hotspot"
						},
						{
							pass_type = "local_offset",
							offset_function = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
								-- function 66
								local hotspot = arg_66_2.hotspot
								local text = arg_66_1.text

								if not hotspot.on_hover_enter then
									hotspot.is_selected = true
								elseif not hotspot.on_hover_exit then
									hotspot.is_selected = false
								end

								if not hotspot.disabled then
									text.text_color = text.disabled_color
								elseif not hotspot.is_selected then
									text.text_color = text.hover_color
								else
									text.text_color = text.default_color
								end
							end
						},
						{
							style_id = "text",
							pass_type = "text",
							text_id = "text"
						},
						{
							pass_type = "texture",
							style_id = "highlight_texture",
							texture_id = "highlight_texture",
							content_check_function = function (self)
								-- function 67
								local hotspot = self.hotspot

								if not hotspot.disabled then
									return false
								end

								local is_hover = hotspot.is_hover

								if not is_hover then
									is_hover = Managers.input:is_device_active("gamepad")
									is_hover = not is_hover and hotspot.is_selected
								end

								return is_hover
							end
						}
					}
				},
				{
					style_id = "selected_bg",
					pass_type = "rect",
					content_check_function = function (self, arg_68_1)
						-- function 68
						return self.active
					end
				},
				{
					style_id = "selected_bg_shade",
					pass_type = "rect",
					content_check_function = function (self, arg_69_1)
						-- function 69
						return self.active
					end
				},
				{
					pass_type = "rect",
					content_check_function = function (arg_70_0)
						-- function 70
						return flag
					end
				},
				{
					pass_type = "border",
					content_check_function = function (arg_71_0, arg_71_1)
						-- function 71
						if not flag then
							arg_71_1.thickness = 1
						end

						return flag
					end
				},
				{
					style_id = "debug_middle_line",
					pass_type = "rect",
					content_check_function = function (arg_72_0)
						-- function 72
						return flag
					end
				}
			}
		},
		content = {
			selected_bg = "drop_down_menu_selected_bg",
			highlight_texture = "playerlist_hover",
			rect_masked = "rect_masked",
			disabled = false,
			active = false,
			using_scrollbar = flag_2,
			hotspot = {},
			highlight_hotspot = {},
			list_content = tbl_5,
			text = arg_55_0,
			selected_option = tbl[arg_55_2],
			current_selection = arg_55_2,
			options_texts = tbl,
			options_values = tbl_2,
			tooltip_text = arg_55_3,
			disabled_tooltip_text = not arg_55_4 and Localize(arg_55_4),
			arrow = {
				texture_id = "drop_down_menu_arrow",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			},
			arrow_hover = {
				texture_id = "drop_down_menu_arrow_clicked",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			},
			hotspot_content_ids = {
				"hotspot"
			}
		},
		style = {
			offset = {
				arg_55_6[1],
				arg_55_6[2],
				arg_55_6[3]
			},
			list_style = {
				active = false,
				start_index = 1,
				offset = {
					arg_55_6[1] + tbl_13[1] - num + 28,
					arg_55_6[2] - tbl_3[2],
					arg_55_6[3] + 5
				},
				num_draws = min,
				total_draws = count,
				list_member_offset = {
					0,
					-tbl_3[2],
					0
				},
				item_styles = tbl_4
			},
			highlight_texture = {
				masked = true,
				offset = {
					arg_55_6[1],
					arg_55_6[2],
					arg_55_6[3]
				},
				color = Colors.get_table("white"),
				size = {
					tbl_13[1],
					tbl_13[2]
				}
			},
			tooltip_text = {
				font_type = "hell_shark",
				localize = true,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				cursor_side = "left",
				max_width = 600,
				cursor_offset = {
					-10,
					-27
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				line_colors = {
					(Colors.get_color_table_with_alpha("font_title", 255))
				},
				offset = {
					0,
					0,
					arg_55_6[3] + 20
				}
			},
			disabled_tooltip_text = {
				localize = false,
				offset = {
					arg_55_6[1],
					arg_55_6[2],
					arg_55_6[3]
				},
				size = {
					tbl_13[1],
					tbl_13[2]
				}
			},
			hotspot = {
				offset = {
					arg_55_6[1] + tbl_13[1] - num,
					arg_55_6[2],
					arg_55_6[3]
				},
				size = {
					num,
					tbl_13[2]
				}
			},
			text = {
				font_size = 16,
				upper_case = true,
				localize = true,
				dynamic_font = true,
				font_type = "hell_shark_masked",
				offset = {
					arg_55_6[1] + 2 + fn(arg_55_7),
					arg_55_6[2] + 5,
					arg_55_6[3] + 10
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				disabled_color = Colors.get_color_table_with_alpha("font_default", 50)
			},
			arrow = {
				masked = true,
				offset = {
					arg_55_6[1] + tbl_13[1] - 31,
					arg_55_6[2] + (tbl_13[2] / 2 - 7.5),
					arg_55_6[3] + 1
				},
				size = {
					31,
					15
				},
				color = Colors.get_color_table_with_alpha("font_default", 255)
			},
			arrow_hover = {
				masked = true,
				offset = {
					arg_55_6[1] + tbl_13[1] - 31,
					arg_55_6[2] + (tbl_13[2] / 2 - 14) + 13,
					arg_55_6[3]
				},
				size = {
					31,
					28
				},
				color = Colors.get_color_table_with_alpha("font_default", 255)
			},
			arrow_hover_flipped = {
				masked = true,
				offset = {
					arg_55_6[1] + tbl_13[1] - 31,
					arg_55_6[2] + (tbl_13[2] / 2 - 14) - 12,
					arg_55_6[3]
				},
				size = {
					31,
					28
				},
				color = Colors.get_color_table_with_alpha("font_default", 255)
			},
			selected_option = {
				horizontal_alignment = "center",
				font_size = 16,
				dynamic_font = true,
				font_type = "hell_shark_masked",
				offset = {
					arg_55_6[1] + tbl_13[1] - num / 2,
					arg_55_6[2] + 2,
					arg_55_6[3] + 3
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				hover_color = Colors.get_color_table_with_alpha("font_default", 255),
				disabled_color = Colors.get_color_table_with_alpha("font_default", 50),
				override_color = Colors.get_color_table_with_alpha("font_default", 155)
			},
			selected_bg = {
				masked = true,
				offset = {
					arg_55_6[1] + tbl_13[1] - (num - 28),
					arg_55_6[2] - num_2,
					arg_55_6[3] + 20
				},
				size = {
					num - 56,
					num_2
				},
				color = {
					255,
					10,
					10,
					10
				}
			},
			selected_bg_shade = {
				masked = true,
				offset = {
					arg_55_6[1] + tbl_13[1] - (num - 28) - 2,
					arg_55_6[2] - (num_2 + 2),
					arg_55_6[3] + 19
				},
				size = {
					num - 56 + 4,
					num_2 + 2
				},
				color = {
					255,
					80,
					80,
					80
				}
			},
			debug_middle_line = {
				offset = {
					arg_55_6[1],
					arg_55_6[2] + tbl_13[2] / 2 - 1,
					arg_55_6[3] + 10
				},
				size = {
					tbl_13[1],
					2
				},
				color = {
					200,
					0,
					255,
					0
				}
			},
			bottom_edge = {
				offset = {
					arg_55_6[1],
					arg_55_6[2],
					arg_55_6[3] + 1
				},
				color = get_color_table_with_alpha,
				size = {
					tbl_13[1],
					num_5
				}
			},
			size = table.clone(tbl_13),
			color = {
				50,
				255,
				255,
				255
			}
		},
		scenegraph_id = arg_55_5
	}

	if not flag_2 then
		local num_3 = (count - min) / count
		local num_4 = num_2 * num_3
		local num_6 = num_2 - num_4
		local num_7 = num_6 / (count - min) - 1
		local tbl_7 = {
			style_id = "thumbnail",
			pass_type = "hotspot",
			content_id = "thumbnail_hotspot",
			content_check_function = function (self)
				-- function 73
				return self.parent.active
			end
		}
		local tbl_8 = {
			style_id = "thumbnail",
			pass_type = "held",
			content_id = "thumbnail_hotspot",
			content_check_function = function (self)
				-- function 74
				return self.parent.active
			end,
			held_function = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3)
				-- function 75
				if not Managers.input:is_device_active("gamepad") then
					return
				end

				local thumbnail_fraction = arg_75_2.thumbnail_fraction
				local thumbnail_length = arg_75_2.thumbnail_length
				local scroll_length = arg_75_2.scroll_length
				local offset = arg_75_1.parent.offset
				local default_offset_y = arg_75_1.default_offset_y
				local offset_2 = arg_75_1.offset
				local num = 2
				local get = arg_75_3:get("cursor")
				local var_75_8 = UIInverseScaleVectorToResolution(get)[num]

				if not arg_75_2.cursor_y then
					arg_75_2.cursor_y = var_75_8
					arg_75_2.parent.dragging = true
				end

				local num_2 = var_75_8 - arg_75_2.cursor_y

				arg_75_2.cursor_y = var_75_8

				local num_3 = 0
				local var_75_11 = scroll_length
				local num_4 = default_offset_y - offset_2[num] - num_2
				local num_5 = math.clamp(num_4, num_3, var_75_11) / var_75_11
				local list_style = arg_75_1.parent.list_style
				local num_draws = list_style.num_draws
				local num_6 = 1 / (list_style.total_draws - num_draws)

				list_style.start_index = math.floor(num_5 / num_6) + 1
				arg_75_2.scroll_progress = num_5
			end,
			release_function = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
				-- function 76
				arg_76_2.cursor_y = nil
				arg_76_2.parent.dragging = nil
			end
		}
		local tbl_9 = {
			style_id = "thumbnail",
			texture_id = "rect_masked",
			pass_type = "texture",
			content_check_function = function (self, arg_77_1)
				-- function 77
				return self.active
			end,
			content_change_function = function (self, arg_78_1)
				-- function 78
				local default_offset_y = arg_78_1.default_offset_y
				local offset = arg_78_1.offset
				local step_size = arg_78_1.step_size
				local size = arg_78_1.size
				local num = 2
				local thumbnail_hotspot = self.thumbnail_hotspot
				local scroll_progress = thumbnail_hotspot.scroll_progress
				local scroll_length = thumbnail_hotspot.scroll_length
				local thumbnail_length = thumbnail_hotspot.thumbnail_length
				local num_2 = 0
				local num_3 = scroll_length - thumbnail_length

				offset[num] = default_offset_y - scroll_length * scroll_progress
			end
		}
		local tbl_10 = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			step_size = num_7,
			default_offset_y = arg_55_6[2] - num_4,
			offset = {
				arg_55_6[1] + tbl_13[1] - 50,
				arg_55_6[2] - num_4,
				arg_55_6[3] + 25
			},
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				20,
				num_4
			},
			texture_size = {
				5,
				num_4
			}
		}

		tbl_6.element.passes[#tbl_6.element.passes + 1] = tbl_9
		tbl_6.element.passes[#tbl_6.element.passes + 1] = tbl_8
		tbl_6.element.passes[#tbl_6.element.passes + 1] = tbl_7
		tbl_6.content.thumbnail_hotspot = {
			scroll_progress = 0,
			thumbnail_fraction = num_3,
			thumbnail_length = num_4,
			scroll_length = num_6,
			scenegraph_id = arg_55_5
		}
		tbl_6.style.thumbnail = tbl_10
	end

	return UIWidget.init(tbl_6)
end

local tbl_14 = {
	var_0_21 - 100,
	30
}

local function fn_11(arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4, arg_79_5, arg_79_6, arg_79_7)
	-- function 79
	local tbl_2 = {}
	local tbl_3 = {}
	local count = #arg_79_1

	for i = 1, count do
		tbl_2[i] = arg_79_1[i].text
		tbl_3[i] = arg_79_1[i].value
	end

	arg_79_6[2] = arg_79_6[2] - tbl_14[2]

	local tbl_4 = {
		element = {
			passes = {
				{
					pass_type = "local_offset",
					offset_function = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3)
						-- function 80
						if not (arg_80_2._last_selection ~= arg_80_2.current_selection or arg_80_2._last_overriden_setting == arg_80_2.overriden_setting) then
							arg_80_2._last_selection = arg_80_2.current_selection
							arg_80_2._last_overriden_setting = arg_80_2.overriden_setting

							local upper = Utf8.upper
							local var_80_1 = arg_80_2.options_texts[arg_80_2.current_selection]

							var_80_1 = var_80_1 or "n/a"

							local var_80_2 = upper(var_80_1)
							local overriden_setting = arg_80_2.overriden_setting

							if not overriden_setting then
								local override_color = arg_80_1.selection_text.override_color
								local disabled_color = arg_80_1.selection_text.disabled_color

								arg_80_2.selection_text = string.format("{#color(%d,%d,%d,%d)}%s {#color(%d,%d,%d,%d);strike(true)}%s{#strike(false)}", override_color[2], override_color[3], override_color[4], override_color[1], var_80_2, disabled_color[2], disabled_color[3], disabled_color[4], disabled_color[1], Utf8.upper(overriden_setting))
							else
								arg_80_2.selection_text = var_80_2
							end
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "bottom_edge",
					texture_id = "rect_masked"
				},
				{
					pass_type = "hotspot",
					content_id = "highlight_hotspot",
					content_check_function = function (self)
						-- function 81
						return not self.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "highlight_texture",
					texture_id = "highlight_texture",
					content_check_function = function (self)
						-- function 82
						return self.is_highlighted
					end
				},
				{
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function (self)
						-- function 83
						if not self.highlight_hotspot.is_hover and not Managers.input:is_device_active("gamepad") then
							return false
						end

						if not self.disabled then
							return self.tooltip_text
						else
							return not self.disabled_tooltip_text
						end
					end
				},
				{
					style_id = "disabled_tooltip_text",
					pass_type = "option_tooltip",
					text_id = "disabled_tooltip_text",
					content_check_function = function (self)
						-- function 84
						if not self.disabled and not self.highlight_hotspot.is_hover and not Managers.input:is_device_active("gamepad") then
							return false
						end

						if not self.overriden_reason then
							self.disabled_tooltip_text = self.overriden_reason
						end

						if not self.disabled_tooltip_text then
							return true
						end
					end
				},
				{
					pass_type = "local_offset",
					offset_function = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
						-- function 85
						local left_hotspot = arg_85_2.left_hotspot
						local right_hotspot = arg_85_2.right_hotspot

						if not left_hotspot.on_hover_enter then
							local on_hover_enter_callback = arg_85_2.on_hover_enter_callback

							if not on_hover_enter_callback then
								on_hover_enter_callback("left_arrow_hover")
							end
						end

						if not left_hotspot.on_hover_exit then
							local on_hover_exit_callback = arg_85_2.on_hover_exit_callback

							if not on_hover_exit_callback then
								on_hover_exit_callback("left_arrow_hover")
							end
						end

						if not left_hotspot.on_release then
							local on_pressed_callback = arg_85_2.on_pressed_callback

							if not on_pressed_callback then
								on_pressed_callback("left_arrow")
								on_pressed_callback("left_arrow_hover")
							end
						end

						if not right_hotspot.on_hover_enter then
							local on_hover_enter_callback_2 = arg_85_2.on_hover_enter_callback

							if not on_hover_enter_callback_2 then
								on_hover_enter_callback_2("right_arrow_hover")
							end
						end

						if not right_hotspot.on_hover_exit then
							local on_hover_exit_callback_2 = arg_85_2.on_hover_exit_callback

							if not on_hover_exit_callback_2 then
								on_hover_exit_callback_2("right_arrow_hover")
							end
						end

						if not right_hotspot.on_release then
							local on_pressed_callback_2 = arg_85_2.on_pressed_callback

							if not on_pressed_callback_2 then
								on_pressed_callback_2("right_arrow")
								on_pressed_callback_2("right_arrow_hover")
							end
						end

						if not arg_85_2.disabled then
							arg_85_1.selection_text.text_color = arg_85_1.selection_text.disabled_color
						elseif left_hotspot.is_hover or not right_hotspot.is_hover then
							arg_85_1.selection_text.text_color = arg_85_1.selection_text.highlight_color
						else
							arg_85_1.selection_text.text_color = arg_85_1.selection_text.default_color
						end
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_change_function = function (self, arg_86_1)
						-- function 86
						if not self.disabled then
							arg_86_1.text_color = arg_86_1.disabled_color
						else
							arg_86_1.text_color = arg_86_1.default_color
						end
					end
				},
				{
					style_id = "left_arrow_hotspot",
					pass_type = "hotspot",
					content_id = "left_hotspot",
					content_check_function = function (self)
						-- function 87
						return not self.disabled
					end
				},
				{
					style_id = "right_arrow_hotspot",
					pass_type = "hotspot",
					content_id = "right_hotspot",
					content_check_function = function (self)
						-- function 88
						return not self.disabled
					end
				},
				{
					texture_id = "texture_id",
					style_id = "left_arrow",
					pass_type = "texture",
					content_id = "arrow",
					content_check_function = function (self)
						-- function 89
						return not self.parent.disabled
					end
				},
				{
					texture_id = "texture_id",
					style_id = "right_arrow",
					pass_type = "texture_uv",
					content_id = "arrow",
					content_check_function = function (self)
						-- function 90
						return not self.parent.disabled
					end
				},
				{
					texture_id = "texture_id",
					style_id = "left_arrow_hover",
					pass_type = "texture",
					content_id = "arrow_hover"
				},
				{
					texture_id = "texture_id",
					style_id = "right_arrow_hover",
					pass_type = "texture_uv",
					content_id = "arrow_hover"
				},
				{
					style_id = "selection_text",
					pass_type = "text",
					text_id = "selection_text",
					content_check_function = function (self)
						-- function 91
						local selection_text = self.selection_text

						return not selection_text and selection_text ~= ""
					end
				},
				{
					pass_type = "rect",
					content_check_function = function (arg_92_0)
						-- function 92
						return flag
					end
				},
				{
					pass_type = "border",
					content_check_function = function (arg_93_0, arg_93_1)
						-- function 93
						if not flag then
							arg_93_1.thickness = 1
						end

						return flag
					end
				},
				{
					style_id = "debug_middle_line",
					pass_type = "rect",
					content_check_function = function (arg_94_0)
						-- function 94
						return flag
					end
				}
			}
		},
		content = {
			left_arrow = "settings_arrow_normal",
			right_arrow_hover = "settings_arrow_clicked",
			right_arrow = "settings_arrow_normal",
			left_arrow_hover = "settings_arrow_clicked",
			selection_text = "",
			highlight_texture = "playerlist_hover",
			rect_masked = "rect_masked",
			disabled = false,
			left_hotspot = {},
			right_hotspot = {},
			highlight_hotspot = {
				allow_multi_hover = true
			},
			text = arg_79_0,
			arrow = {
				texture_id = "settings_arrow_normal",
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
			arrow_hover = {
				texture_id = "settings_arrow_clicked",
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
			tooltip_text = arg_79_3,
			disabled_tooltip_text = not arg_79_4 and Localize(arg_79_4),
			current_selection = arg_79_2,
			options_texts = tbl_2,
			options_values = tbl_3,
			num_options = count,
			hotspot_content_ids = {
				"left_hotspot",
				"right_hotspot"
			}
		},
		style = {
			offset = table.clone(arg_79_6),
			size = table.clone(tbl_14),
			highlight_texture = {
				upper_case = true,
				masked = true,
				offset = {
					arg_79_6[1],
					arg_79_6[2],
					arg_79_6[3]
				},
				color = Colors.get_table("white"),
				size = {
					tbl_14[1],
					tbl_14[2]
				}
			},
			tooltip_text = {
				font_type = "hell_shark",
				localize = true,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				cursor_side = "left",
				max_width = 600,
				cursor_offset = {
					-10,
					-27
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				line_colors = {
					(Colors.get_color_table_with_alpha("font_title", 255))
				},
				offset = {
					0,
					0,
					arg_79_6[3] + 20
				}
			},
			disabled_tooltip_text = {
				localize = false,
				offset = {
					arg_79_6[1],
					arg_79_6[2],
					arg_79_6[3]
				},
				size = {
					tbl_14[1],
					tbl_14[2]
				}
			},
			left_arrow = {
				masked = true,
				offset = {
					arg_79_6[1] + tbl_14[1] - num,
					arg_79_6[2] + (tbl_14[2] / 2 - 13.5),
					arg_79_6[3] + 1
				},
				size = {
					19,
					27
				},
				color = Colors.get_color_table_with_alpha("font_default", 255)
			},
			left_arrow_hover = {
				masked = true,
				offset = {
					arg_79_6[1] + tbl_14[1] - num + 6,
					arg_79_6[2] + (tbl_14[2] / 2 - 17.5),
					arg_79_6[3]
				},
				size = {
					30,
					35
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			left_arrow_hotspot = {
				offset = {
					arg_79_6[1] + tbl_14[1] - num,
					arg_79_6[2] + (tbl_14[2] / 2 - 13.5),
					arg_79_6[3]
				},
				size = {
					num / 2,
					27
				}
			},
			right_arrow = {
				masked = true,
				offset = {
					arg_79_6[1] + tbl_14[1] - 19,
					arg_79_6[2] + (tbl_14[2] / 2 - 13.5),
					arg_79_6[3] + 1
				},
				size = {
					19,
					27
				},
				color = Colors.get_color_table_with_alpha("font_default", 255)
			},
			right_arrow_hover = {
				masked = true,
				offset = {
					arg_79_6[1] + tbl_14[1] - 30 - 5,
					arg_79_6[2] + (tbl_14[2] / 2 - 17.5),
					arg_79_6[3]
				},
				size = {
					30,
					35
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			right_arrow_hotspot = {
				offset = {
					arg_79_6[1] + tbl_14[1] - num / 2,
					arg_79_6[2] + (tbl_14[2] / 2 - 13.5),
					arg_79_6[3]
				},
				size = {
					num / 2,
					27
				}
			},
			text = {
				font_size = 16,
				upper_case = true,
				localize = true,
				dynamic_font = true,
				font_type = "hell_shark_masked",
				offset = {
					arg_79_6[1] + 2 + fn(arg_79_7),
					arg_79_6[2] + 2,
					arg_79_6[3]
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				disabled_color = Colors.get_color_table_with_alpha("font_default", 50)
			},
			selection_text = {
				font_size = 16,
				horizontal_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_masked",
				offset = {
					arg_79_6[1] + tbl_14[1] - num / 2,
					arg_79_6[2] + 2,
					arg_79_6[3]
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				highlight_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				disabled_color = Colors.get_color_table_with_alpha("font_default", 50),
				override_color = Colors.get_color_table_with_alpha("font_default", 155)
			},
			debug_middle_line = {
				offset = {
					arg_79_6[1],
					arg_79_6[2] + tbl_14[2] / 2 - 1,
					arg_79_6[3] + 10
				},
				size = {
					tbl_14[1],
					2
				},
				color = {
					200,
					0,
					255,
					0
				}
			},
			bottom_edge = {
				offset = {
					arg_79_6[1],
					arg_79_6[2],
					arg_79_6[3] + 1
				},
				color = get_color_table_with_alpha,
				size = {
					tbl_14[1],
					num_5
				}
			},
			input_field_background = {
				offset = {
					arg_79_6[1] + tbl_14[1] - num,
					arg_79_6[2],
					arg_79_6[3]
				},
				color = tbl,
				size = {
					num,
					tbl_14[2]
				}
			},
			color = {
				50,
				255,
				255,
				255
			}
		},
		scenegraph_id = arg_79_5
	}

	return UIWidget.init(tbl_4)
end

local tbl_15 = {
	var_0_21 - 100,
	50
}

local function fn_12(arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4, arg_95_5)
	-- function 95
	arg_95_5[2] = arg_95_5[2] - tbl_15[2]

	local tbl = {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "highlight_hotspot"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "texture",
					style_id = "bottom_edge",
					texture_id = "rect_masked"
				},
				{
					pass_type = "rect",
					content_check_function = function (arg_96_0)
						-- function 96
						return flag
					end
				},
				{
					pass_type = "border",
					content_check_function = function (arg_97_0, arg_97_1)
						-- function 97
						if not flag then
							arg_97_1.thickness = 1
						end

						return flag
					end
				},
				{
					style_id = "debug_middle_line",
					pass_type = "rect",
					content_check_function = function (arg_98_0)
						-- function 98
						return flag
					end
				}
			}
		},
		content = {
			rect_masked = "rect_masked",
			highlight_hotspot = {
				allow_multi_hover = true
			},
			text = arg_95_0
		},
		style = {
			offset = table.clone(arg_95_5),
			size = table.clone(tbl_15),
			text = {
				upper_case = true,
				localize = true,
				dynamic_font_size = true,
				font_type = "hell_shark_header_masked",
				offset = {
					arg_95_5[1] + 2,
					arg_95_5[2] + 5,
					arg_95_5[3]
				},
				text_color = arg_95_2 or Colors.get_color_table_with_alpha("font_title", 255),
				font_size = arg_95_1 or 18,
				horizontal_alignment = arg_95_3 or "left",
				size = table.clone(tbl_15)
			},
			debug_middle_line = {
				offset = {
					arg_95_5[1],
					arg_95_5[2] + tbl_15[2] / 2 - 1,
					arg_95_5[3] + 10
				},
				size = {
					tbl_15[1],
					2
				},
				color = {
					200,
					0,
					255,
					0
				}
			},
			bottom_edge = {
				offset = {
					arg_95_5[1],
					arg_95_5[2],
					arg_95_5[3] + 1
				},
				color = get_color_table_with_alpha,
				size = {
					tbl_15[1],
					num_5
				}
			},
			color = {
				50,
				255,
				255,
				255
			}
		},
		scenegraph_id = arg_95_4
	}

	return UIWidget.init(tbl)
end

local tbl_16 = {
	var_0_21 - 100,
	50
}

local function fn_13(arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6)
	-- function 99
	arg_99_6[2] = arg_99_6[2] - tbl_16[2]

	local tbl = {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "hotspot",
					content_id = "highlight_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "highlight_texture",
					texture_id = "highlight_texture",
					content_check_function = function (self)
						-- function 100
						return self.is_highlighted
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 101
						return not self.hotspot.is_hover
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 102
						return self.hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "bottom_edge",
					texture_id = "rect_masked"
				},
				{
					pass_type = "rect",
					content_check_function = function (arg_103_0)
						-- function 103
						return flag
					end
				},
				{
					pass_type = "border",
					content_check_function = function (arg_104_0, arg_104_1)
						-- function 104
						if not flag then
							arg_104_1.thickness = 1
						end

						return flag
					end
				},
				{
					style_id = "debug_middle_line",
					pass_type = "rect",
					content_check_function = function (arg_105_0)
						-- function 105
						return flag
					end
				}
			}
		},
		content = {
			rect_masked = "rect_masked",
			highlight_texture = "playerlist_hover",
			hotspot = {},
			highlight_hotspot = {
				allow_multi_hover = true
			},
			text = arg_99_0,
			url = arg_99_1
		},
		style = {
			offset = table.clone(arg_99_6),
			size = table.clone(tbl_16),
			highlight_texture = {
				masked = true,
				offset = {
					arg_99_6[1],
					arg_99_6[2],
					arg_99_6[3]
				},
				color = Colors.get_table("white"),
				size = {
					tbl_16[1],
					tbl_16[2]
				}
			},
			text = {
				upper_case = true,
				localize = true,
				dynamic_font_size = true,
				font_type = "hell_shark_header_masked",
				offset = {
					arg_99_6[1] + 2,
					arg_99_6[2] + 5,
					arg_99_6[3]
				},
				text_color = arg_99_3 or Colors.get_color_table_with_alpha("font_title", 255),
				font_size = arg_99_2 or 18,
				horizontal_alignment = arg_99_4 or "left",
				size = table.clone(tbl_16)
			},
			text_hover = {
				upper_case = true,
				localize = true,
				dynamic_font_size = true,
				font_type = "hell_shark_header_masked",
				offset = {
					arg_99_6[1] + 2,
					arg_99_6[2] + 5,
					arg_99_6[3]
				},
				text_color = arg_99_3 or Colors.get_color_table_with_alpha("font_default", 255),
				font_size = arg_99_2 or 18,
				horizontal_alignment = arg_99_4 or "left",
				size = table.clone(tbl_16)
			},
			debug_middle_line = {
				offset = {
					arg_99_6[1],
					arg_99_6[2] + tbl_16[2] / 2 - 1,
					arg_99_6[3] + 10
				},
				size = {
					tbl_16[1],
					2
				},
				color = {
					200,
					0,
					255,
					0
				}
			},
			bottom_edge = {
				offset = {
					arg_99_6[1],
					arg_99_6[2],
					arg_99_6[3] + 1
				},
				color = get_color_table_with_alpha,
				size = {
					tbl_16[1],
					num_5
				}
			},
			color = {
				50,
				255,
				255,
				255
			}
		},
		scenegraph_id = arg_99_5
	}

	return UIWidget.init(tbl)
end

local tbl_17 = {
	var_0_21 - 100,
	50
}

local function fn_14(arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4, arg_106_5, arg_106_6)
	-- function 106
	local tbl = {}
	local tbl_2 = {}
	local count = #arg_106_2

	for i = 1, count do
		tbl[i] = arg_106_2[i].text
		tbl_2[i] = arg_106_2[i].value
	end

	arg_106_6[2] = arg_106_6[2] - tbl_17[2]

	local tbl_3 = {}
	local tbl_4 = {
		passes = tbl_3
	}
	local tbl_5 = {}
	local tbl_6 = {}
	local tbl_7 = {
		element = tbl_4,
		content = tbl_5,
		style = tbl_6,
		scenegraph_id = arg_106_5
	}

	tbl_3[#tbl_3 + 1] = {
		pass_type = "local_offset",
		offset_function = function (arg_107_0, arg_107_1, arg_107_2, arg_107_3)
			-- function 107
			local current_selection = arg_107_2.current_selection

			if current_selection ~= arg_107_2.local_selection then
				arg_107_2.local_selection = current_selection

				local num_options = arg_107_2.num_options

				for i = 1, num_options do
					local str = "option_" .. i
					local str_2 = "option_text_" .. i
					local flag = i == current_selection

					arg_107_2[str].is_selected = flag

					local var_107_5 = arg_107_1[str_2]
					local highlight_color

					if not flag then
						highlight_color = arg_107_1[str_2].highlight_color

						if not highlight_color then
							-- Nothing
						end
					end

					highlight_color = arg_107_1[str_2].default_color

					::label_107_0::

					var_107_5.text_color = highlight_color
				end
			end
		end
	}
	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		style_id = "highlight_texture",
		texture_id = "highlight_texture",
		content_check_function = function (self)
			-- function 108
			return self.is_highlighted
		end
	}
	tbl_3[#tbl_3 + 1] = {
		pass_type = "hotspot",
		content_id = "highlight_hotspot"
	}
	tbl_3[#tbl_3 + 1] = {
		pass_type = "option_tooltip",
		text_id = "tooltip_text",
		content_check_function = function (self)
			-- function 109
			local tooltip_text = self.tooltip_text

			if not tooltip_text then
				tooltip_text = self.highlight_hotspot.is_hover
				tooltip_text = not tooltip_text and not Managers.input:is_device_active("gamepad")
			end

			return tooltip_text
		end
	}
	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		style_id = "bottom_edge",
		texture_id = "rect_masked"
	}
	tbl_3[#tbl_3 + 1] = {
		style_id = "text",
		pass_type = "text",
		text_id = "text"
	}
	tbl_3[#tbl_3 + 1] = {
		pass_type = "rect",
		content_check_function = function (arg_110_0)
			-- function 110
			return flag
		end
	}
	tbl_3[#tbl_3 + 1] = {
		pass_type = "border",
		content_check_function = function (arg_111_0, arg_111_1)
			-- function 111
			if not flag then
				arg_111_1.thickness = 1
			end

			return flag
		end
	}
	tbl_3[#tbl_3 + 1] = {
		style_id = "debug_middle_line",
		pass_type = "rect",
		content_check_function = function (arg_112_0)
			-- function 112
			return flag
		end
	}
	tbl_5.text = arg_106_1
	tbl_5.tooltip_text = arg_106_4
	tbl_5.current_selection = arg_106_3
	tbl_5.options_texts = tbl
	tbl_5.options_values = tbl_2
	tbl_5.num_options = count
	tbl_5.highlight_hotspot = {
		allow_multi_hover = true
	}
	tbl_5.highlight_texture = "playerlist_hover"
	tbl_5.rect_masked = "rect_masked"

	local tbl_8 = {}

	tbl_5.hotspot_content_ids = tbl_8
	tbl_6.offset = table.clone(arg_106_6)
	tbl_6.size = table.clone(tbl_17)
	tbl_6.highlight_texture = {
		upper_case = true,
		masked = true,
		offset = {
			arg_106_6[1],
			arg_106_6[2],
			arg_106_6[3]
		},
		color = Colors.get_table("white"),
		size = {
			tbl_17[1],
			tbl_17[2]
		}
	}
	tbl_6.tooltip_text = {
		font_type = "hell_shark",
		localize = true,
		font_size = 24,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		cursor_side = "left",
		max_width = 600,
		cursor_offset = {
			-10,
			-27
		},
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		line_colors = {
			(Colors.get_color_table_with_alpha("font_title", 255))
		},
		offset = {
			0,
			0,
			arg_106_6[3] + 20
		}
	}
	tbl_6.text = {
		upper_case = true,
		localize = true,
		dynamic_font = true,
		font_size = 22,
		font_type = "hell_shark_masked",
		offset = {
			arg_106_6[1] + 2,
			arg_106_6[2] + 5,
			arg_106_6[3]
		},
		text_color = Colors.get_color_table_with_alpha("font_default", 255)
	}
	tbl_6.debug_middle_line = {
		offset = {
			arg_106_6[1],
			arg_106_6[2] + tbl_17[2] / 2 - 1,
			arg_106_6[3] + 10
		},
		size = {
			tbl_17[1],
			2
		},
		color = {
			200,
			0,
			255,
			0
		}
	}
	tbl_6.color = {
		50,
		255,
		255,
		255
	}
	tbl_6.bottom_edge = {
		offset = {
			arg_106_6[1],
			arg_106_6[2],
			arg_106_6[3] + 1
		},
		color = get_color_table_with_alpha,
		size = {
			tbl_17[1],
			num_5
		}
	}

	local num = 20
	local num_2 = 20
	local num_3 = 120
	local num_4 = arg_106_6[1] + tbl_17[1]
	local num_6 = -num

	for j = 1, count do
		local text = arg_106_2[j].text
		local str = "option_text_" .. j

		tbl_3[#tbl_3 + 1] = {
			pass_type = "text",
			style_id = str,
			text_id = str,
			content_change_function = function (self, arg_113_1)
				-- function 113
				local var_113_0 = self["option_" .. j]

				if not var_113_0.is_selected then
					if not var_113_0.is_hover then
						arg_113_1.text_color = Colors.get_color_table_with_alpha("font_default", 255)
					else
						arg_113_1.text_color = Colors.get_color_table_with_alpha("font_title", 255)
					end
				end
			end
		}
		tbl_6[str] = {
			upper_case = true,
			horizontal_alignment = "center",
			font_size = 22,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_masked",
			size = {
				500,
				tbl_17[2]
			},
			offset = {
				num_4 - num_6,
				arg_106_6[2],
				arg_106_6[3] + 1
			},
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			highlight_color = Colors.get_color_table_with_alpha("black", 255),
			default_color = Colors.get_color_table_with_alpha("font_title", 255)
		}
		tbl_5[str] = text

		if not tbl_6[str].upper_case then
			text = TextToUpper(text)
		end

		local var_106_16, var_106_17 = UIFontByResolution(tbl_6[str])
		local text_size, var_106_19, var_106_20 = UIRenderer.text_size(arg_106_0, text, var_106_16[1], var_106_17)
		local max = math.max(text_size + num_2, num_3)

		num_6 = num_6 + max + num
		tbl_6[str].size[1] = max
		tbl_6[str].offset[1] = num_4 - num_6

		local str_2 = "option_" .. j

		tbl_3[#tbl_3 + 1] = {
			pass_type = "hotspot",
			style_id = str_2,
			content_id = str_2
		}
		tbl_5[str_2] = {}
		tbl_3[#tbl_3 + 1] = {
			texture_id = "rect_texture",
			pass_type = "texture",
			style_id = str_2,
			content_check_function = function (self)
				-- function 114
				return self[str_2].is_selected
			end,
			content_change_function = function (self, arg_115_1)
				-- function 115
				local var_115_0 = self["option_" .. j]

				if not var_115_0.is_selected then
					if not var_115_0.is_hover then
						arg_115_1.color = Colors.get_color_table_with_alpha("font_default", 255)
					else
						arg_115_1.color = Colors.get_color_table_with_alpha("font_title", 255)
					end
				end
			end
		}
		tbl_5.rect_texture = "rect_masked"
		tbl_6[str_2] = {
			size = {
				max,
				tbl_17[2] - 10
			},
			offset = {
				num_4 - num_6,
				arg_106_6[2] + 5,
				arg_106_6[3]
			},
			color = Colors.get_color_table_with_alpha("font_title", 255)
		}
		tbl_8[#tbl_8 + 1] = str_2
	end

	return UIWidget.init(tbl_7)
end

local tbl_18 = {
	var_0_21 - 100,
	30
}

local function fn_15(arg_116_0, arg_116_1, arg_116_2, arg_116_3, arg_116_4, arg_116_5, arg_116_6)
	-- function 116
	arg_116_6[2] = arg_116_6[2] - tbl_18[2]

	local tbl_2 = {
		element = {
			passes = {
				{
					style_id = "hotspot_1",
					pass_type = "hotspot",
					content_id = "hotspot_1",
					content_check_function = function (arg_117_0)
						-- function 117
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "hotspot_2",
					pass_type = "hotspot",
					content_id = "hotspot_2",
					content_check_function = function (arg_118_0)
						-- function 118
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "texture",
					style_id = "bottom_edge",
					texture_id = "rect_masked"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "hotspot",
					content_id = "highlight_hotspot",
					content_check_function = function (arg_119_0)
						-- function 119
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "texture",
					style_id = "highlight_texture",
					texture_id = "highlight_texture",
					content_check_function = function (self)
						-- function 120
						local is_highlighted = self.is_highlighted

						is_highlighted = not is_highlighted and not Managers.input:is_device_active("gamepad")

						return is_highlighted
					end
				},
				{
					style_id = "selected_key_1",
					pass_type = "text",
					text_id = "selected_key_1",
					content_check_function = function (self)
						-- function 121
						return not self.active_1
					end,
					content_change_function = function (self, arg_122_1)
						-- function 122
						if self.active_1 or not self.hotspot_1.is_hover then
							arg_122_1.text_color = arg_122_1.hover_color
						elseif not self.is_unassigned_1 then
							arg_122_1.text_color = arg_122_1.unassigned_color
						else
							arg_122_1.text_color = arg_122_1.default_color
						end

						if not self.active_1 then
							self.active_t = self.active_t + ui_renderer.dt * 2.5

							local sirp = math.sirp(0, 1, self.active_t)

							arg_122_1.parent.selected_rect_1.color[1] = sirp * 255
						else
							arg_122_1.parent.selected_rect_1.color[1] = 255
						end
					end
				},
				{
					style_id = "selected_key_2",
					pass_type = "text",
					text_id = "selected_key_2",
					content_check_function = function (self)
						-- function 123
						return not self.active_2
					end,
					content_change_function = function (self, arg_124_1)
						-- function 124
						if self.active_2 or not self.hotspot_2.is_hover then
							arg_124_1.text_color = arg_124_1.hover_color
						elseif not self.is_unassigned_2 then
							arg_124_1.text_color = arg_124_1.unassigned_color
						else
							arg_124_1.text_color = arg_124_1.default_color
						end

						if not self.active_2 then
							self.active_t = self.active_t + ui_renderer.dt * 2.5

							local sirp = math.sirp(0, 1, self.active_t)

							arg_124_1.parent.selected_rect_2.color[1] = sirp * 255
						else
							arg_124_1.parent.selected_rect_2.color[1] = 255
						end
					end
				},
				{
					style_id = "selected_rect_1",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 125
						return self.active_1
					end
				},
				{
					style_id = "selected_rect_2",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 126
						return self.active_2
					end
				},
				{
					pass_type = "texture",
					style_id = "input_field_1_background_bevel",
					texture_id = "rect_masked"
				},
				{
					pass_type = "texture",
					style_id = "input_field_1_background",
					texture_id = "rect_masked"
				},
				{
					pass_type = "texture",
					style_id = "input_field_2_background_bevel",
					texture_id = "rect_masked"
				},
				{
					pass_type = "texture",
					style_id = "input_field_2_background",
					texture_id = "rect_masked"
				}
			}
		},
		content = {
			active_t = 0,
			rect_masked = "rect_masked",
			highlight_texture = "playerlist_hover",
			hotspot_1 = {},
			hotspot_2 = {},
			highlight_hotspot = {
				allow_multi_hover = true
			},
			text = arg_116_2 or arg_116_3[1],
			actions = arg_116_3,
			actions_info = arg_116_4,
			selected_key_1 = arg_116_0,
			selected_key_2 = arg_116_1,
			hotspot_content_ids = {
				"hotspot_1",
				"hotspot_2"
			}
		},
		style = {
			offset = table.clone(arg_116_6),
			hotspot_1 = {
				offset = {
					arg_116_6[1] + tbl_18[1] - 2 * (20 + num - 2),
					arg_116_6[2] + tbl_18[2] / 2 - (tbl_18[2] - 10) / 2,
					arg_116_6[3] + 2
				},
				area_size = {
					num - 2,
					tbl_18[2] - 10
				}
			},
			hotspot_2 = {
				offset = {
					arg_116_6[1] + tbl_18[1] - (num - 2),
					arg_116_6[2] + tbl_18[2] / 2 - (tbl_18[2] - 10) / 2,
					arg_116_6[3] + 2
				},
				area_size = {
					num - 2,
					tbl_18[2] - 10
				}
			},
			highlight_texture = {
				masked = true,
				offset = {
					arg_116_6[1],
					arg_116_6[2],
					arg_116_6[3]
				},
				color = Colors.get_table("white"),
				size = {
					tbl_18[1],
					tbl_18[2]
				}
			},
			text = {
				upper_case = true,
				localize = true,
				dynamic_font = true,
				font_size = 16,
				font_type = "hell_shark_masked",
				offset = {
					arg_116_6[1] + 2,
					arg_116_6[2] + 5,
					arg_116_6[3] + 1
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255)
			},
			selected_key_1 = {
				upper_case = true,
				horizontal_alignment = "center",
				font_size = 16,
				dynamic_font = true,
				font_type = "hell_shark_masked",
				offset = {
					arg_116_6[1] + tbl_18[1] - 2 * (20 + num),
					arg_116_6[2] + 2,
					arg_116_6[3] + 5
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				hover_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				unassigned_color = Colors.get_color_table_with_alpha("dim_gray", 255),
				size = {
					num,
					tbl_18[2] - 10
				}
			},
			selected_key_2 = {
				upper_case = true,
				horizontal_alignment = "center",
				font_size = 16,
				dynamic_font = true,
				font_type = "hell_shark_masked",
				offset = {
					arg_116_6[1] + tbl_18[1] - num,
					arg_116_6[2] + 2,
					arg_116_6[3] + 5
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				hover_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				unassigned_color = Colors.get_color_table_with_alpha("dim_gray", 255),
				size = {
					num,
					tbl_18[2] - 10
				}
			},
			selected_rect_1 = {
				offset = {
					arg_116_6[1] + tbl_18[1] - 2 * (20 + num - 2),
					arg_116_6[2] + tbl_18[2] / 2 - (tbl_18[2] - 10) / 2,
					arg_116_6[3] + 2
				},
				size = {
					num - 2,
					tbl_18[2] - 10
				},
				color = Colors.get_color_table_with_alpha("font_default", 100)
			},
			selected_rect_2 = {
				offset = {
					arg_116_6[1] + tbl_18[1] - (num - 2),
					arg_116_6[2] + tbl_18[2] / 2 - (tbl_18[2] - 10) / 2,
					arg_116_6[3] + 2
				},
				size = {
					num - 2,
					tbl_18[2] - 10
				},
				color = Colors.get_color_table_with_alpha("font_default", 100)
			},
			debug_middle_line = {
				offset = {
					arg_116_6[1],
					arg_116_6[2] + tbl_18[2] / 2 - 1,
					arg_116_6[3] + 10
				},
				size = {
					tbl_18[1],
					2
				},
				color = {
					200,
					0,
					255,
					0
				}
			},
			bottom_edge = {
				offset = {
					arg_116_6[1],
					arg_116_6[2],
					arg_116_6[3] + 1
				},
				color = get_color_table_with_alpha,
				size = {
					tbl_18[1],
					num_5
				}
			},
			input_field_1_background_bevel = {
				offset = {
					arg_116_6[1] + tbl_18[1] - 2 * (20 + num),
					arg_116_6[2] + tbl_18[2] / 2 - (tbl_18[2] - 10) / 2,
					arg_116_6[3] + 1
				},
				color = tbl,
				size = {
					num,
					tbl_18[2] - 10 + 2
				}
			},
			input_field_1_background = {
				offset = {
					arg_116_6[1] + tbl_18[1] - 2 * (20 + num - 2),
					arg_116_6[2] + tbl_18[2] / 2 - (tbl_18[2] - 10) / 2,
					arg_116_6[3] + 2
				},
				color = {
					255,
					10,
					10,
					10
				},
				size = {
					num - 2,
					tbl_18[2] - 10
				}
			},
			input_field_2_background_bevel = {
				offset = {
					arg_116_6[1] + tbl_18[1] - num,
					arg_116_6[2] + tbl_18[2] / 2 - (tbl_18[2] - 10) / 2,
					arg_116_6[3] + 1
				},
				color = tbl,
				size = {
					num,
					tbl_18[2] - 10 + 2
				}
			},
			input_field_2_background = {
				offset = {
					arg_116_6[1] + tbl_18[1] - (num - 2),
					arg_116_6[2] + tbl_18[2] / 2 - (tbl_18[2] - 10) / 2,
					arg_116_6[3] + 2
				},
				color = {
					255,
					10,
					10,
					10
				},
				size = {
					num - 2,
					tbl_18[2] - 10
				}
			},
			size = table.clone(tbl_18),
			color = {
				50,
				255,
				255,
				255
			}
		},
		scenegraph_id = arg_116_5
	}

	return UIWidget.init(tbl_2)
end

local num_6 = var_0_21 - 100
local num_7 = 28

local function fn_16(arg_127_0, arg_127_1, arg_127_2, arg_127_3, arg_127_4, arg_127_5, arg_127_6, arg_127_7)
	-- function 127
	local count = #arg_127_2
	local num = 10
	local tbl_2 = {
		num_6,
		count * arg_127_4[2] + num
	}
	local num_2 = tbl_2[2] - num
	local tbl_3 = {
		35,
		(tbl_2[2] - num) / 2 - 2
	}

	arg_127_7[2] = arg_127_7[2] - tbl_2[2]

	local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("font_default", 255)
	local get_color_table_with_alpha_3 = Colors.get_color_table_with_alpha("font_default", 100)
	local tbl_4 = {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "rect_masked",
					content_check_function = function (arg_128_0, arg_128_1)
						-- function 128
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "texture",
					style_id = "background_fg",
					texture_id = "rect_masked",
					content_check_function = function (arg_129_0, arg_129_1)
						-- function 129
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "texture",
					style_id = "bottom_edge",
					texture_id = "rect_masked",
					content_check_function = function (arg_130_0, arg_130_1)
						-- function 130
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "texture",
					style_id = "arrow_buttons_edge_horizontal",
					texture_id = "rect_masked",
					content_check_function = function (arg_131_0, arg_131_1)
						-- function 131
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "texture",
					style_id = "arrow_buttons_edge_vertical",
					texture_id = "rect_masked",
					content_check_function = function (arg_132_0, arg_132_1)
						-- function 132
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "hotspot",
					content_id = "highlight_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "highlight_texture",
					texture_id = "highlight_texture",
					content_check_function = function (self)
						-- function 133
						local is_highlighted = self.is_highlighted

						if not is_highlighted then
							is_highlighted = Managers.input:is_device_active("gamepad")
							is_highlighted = not is_highlighted and not self.active
						end

						return is_highlighted
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function (self)
						-- function 134
						local tooltip_text = self.tooltip_text

						if not tooltip_text then
							tooltip_text = self.highlight_hotspot.is_hover
							tooltip_text = not tooltip_text and not Managers.input:is_device_active("gamepad")
						end

						return tooltip_text
					end
				},
				{
					style_id = "down_arrow_background",
					pass_type = "hotspot",
					content_id = "down_hotspot",
					content_check_function = function (self)
						-- function 135
						return self.active
					end
				},
				{
					style_id = "up_arrow_background",
					pass_type = "hotspot",
					content_id = "up_hotspot",
					content_check_function = function (self)
						-- function 136
						return self.active
					end
				},
				{
					pass_type = "texture",
					style_id = "down_arrow_background",
					texture_id = "rect_masked",
					content_check_function = function (self)
						-- function 137
						if not Managers.input:is_device_active("gamepad") then
							return false
						end

						local down_hotspot = self.down_hotspot
						local active = down_hotspot.active

						active = not active and down_hotspot.is_hover

						return active
					end
				},
				{
					texture_id = "texture_id",
					style_id = "down_arrow",
					pass_type = "texture",
					content_id = "arrow",
					content_check_function = function (self, arg_138_1)
						-- function 138
						if not Managers.input:is_device_active("gamepad") then
							return false
						end

						local parent = self.parent
						local parent_2 = arg_138_1.parent
						local enabled_color

						if not parent.down_hotspot.active then
							enabled_color = parent_2.enabled_color

							if not enabled_color then
								-- Nothing
							end
						end

						enabled_color = parent_2.disabled_color

						::label_138_0::

						arg_138_1.color = enabled_color

						return true
					end
				},
				{
					pass_type = "texture",
					style_id = "up_arrow_background",
					texture_id = "rect_masked",
					content_check_function = function (self)
						-- function 139
						if not Managers.input:is_device_active("gamepad") then
							return false
						end

						local up_hotspot = self.up_hotspot
						local active = up_hotspot.active

						active = not active and up_hotspot.is_hover

						return active
					end
				},
				{
					texture_id = "texture_id",
					style_id = "up_arrow",
					pass_type = "texture_uv",
					content_id = "arrow",
					content_check_function = function (self, arg_140_1)
						-- function 140
						if not Managers.input:is_device_active("gamepad") then
							return false
						end

						local parent = self.parent
						local parent_2 = arg_140_1.parent
						local enabled_color

						if not parent.up_hotspot.active then
							enabled_color = parent_2.enabled_color

							if not enabled_color then
								-- Nothing
							end
						end

						enabled_color = parent_2.disabled_color

						::label_140_0::

						arg_140_1.color = enabled_color

						return true
					end
				},
				{
					texture_id = "texture_id",
					style_id = "down_arrow_hover",
					pass_type = "texture",
					content_id = "arrow_hover",
					content_check_function = function (self)
						-- function 141
						local down_hotspot = self.parent.down_hotspot
						local active = down_hotspot.active

						active = not active and down_hotspot.is_hover

						return active
					end
				},
				{
					texture_id = "texture_id",
					style_id = "up_arrow_hover",
					pass_type = "texture_uv",
					content_id = "arrow_hover",
					content_check_function = function (self)
						-- function 142
						local up_hotspot = self.parent.up_hotspot
						local active = up_hotspot.active

						active = not active and up_hotspot.is_hover

						return active
					end
				},
				{
					style_id = "list_style",
					pass_type = "list_pass",
					content_id = "list_content",
					passes = {
						{
							pass_type = "hotspot",
							content_id = "hotspot"
						},
						{
							style_id = "texture",
							texture_id = "texture",
							pass_type = "texture",
							content_check_function = function (self)
								-- function 143
								return not not self.hotspot.is_hover or not self.hotspot.is_selected
							end,
							content_change_function = arg_127_5
						},
						{
							style_id = "highlight_texture",
							texture_id = "highlight_texture",
							pass_type = "texture",
							content_check_function = function (self, arg_144_1, arg_144_2)
								-- function 144
								local is_hover = self.hotspot.is_hover

								is_hover = is_hover or self.hotspot.is_selected

								return is_hover
							end,
							content_change_function = arg_127_5
						},
						{
							style_id = "background_highlight_texture",
							texture_id = "background_highlight_texture",
							pass_type = "texture",
							content_check_function = function (self, arg_145_1, arg_145_2)
								-- function 145
								local is_hover = self.hotspot.is_hover

								is_hover = not is_hover and not self.hotspot.is_selected

								return is_hover
							end,
							content_change_function = arg_127_5
						},
						{
							style_id = "background_selected_texture",
							texture_id = "background_highlight_texture",
							pass_type = "texture",
							content_check_function = function (self, arg_146_1, arg_146_2)
								-- function 146
								return self.hotspot.is_selected
							end,
							content_change_function = arg_127_5
						},
						{
							style_id = "index_text",
							pass_type = "text",
							text_id = "index_text",
							content_change_function = arg_127_5
						},
						{
							style_id = "text",
							pass_type = "text",
							text_id = "text",
							content_change_function = arg_127_5
						}
					}
				}
			}
		},
		content = {
			highlight_texture = "playerlist_hover",
			rect_masked = "rect_masked",
			text = arg_127_0,
			tooltip_text = arg_127_1,
			up_hotspot = {
				active = false
			},
			down_hotspot = {
				active = false
			},
			highlight_hotspot = {
				allow_multi_hover = true
			},
			arrow = {
				texture_id = "drop_down_menu_arrow",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			},
			arrow_hover = {
				texture_id = "drop_down_menu_arrow_clicked",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			},
			hotspot_content_ids = {
				"up_hotspot",
				"down_hotspot"
			},
			list_content = arg_127_2
		},
		style = {
			offset = table.clone(arg_127_7),
			size = table.clone(tbl_2),
			color = {
				50,
				255,
				255,
				255
			},
			enabled_color = get_color_table_with_alpha_2,
			disabled_color = get_color_table_with_alpha_3,
			background = {
				offset = {
					arg_127_7[1] + 7 * tbl_2[1] / 10,
					arg_127_7[2] + num / 2,
					arg_127_7[3]
				},
				color = tbl,
				size = {
					3 * tbl_2[1] / 10,
					num_2
				}
			},
			background_fg = {
				offset = {
					arg_127_7[1] + 7 * tbl_2[1] / 10 + 2,
					arg_127_7[2] + num / 2,
					arg_127_7[3] + 1
				},
				color = {
					255,
					10,
					10,
					10
				},
				size = {
					3 * tbl_2[1] / 10 - 2,
					num_2 - 2
				}
			},
			text = {
				upper_case = true,
				localize = true,
				dynamic_font = true,
				font_size = 16,
				font_type = "hell_shark_masked",
				offset = {
					arg_127_7[1] + 2,
					arg_127_7[2] + tbl_2[2] - (num_7 + 4),
					arg_127_7[3]
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255)
			},
			tooltip_text = {
				font_type = "hell_shark",
				localize = true,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				cursor_side = "left",
				max_width = 600,
				cursor_offset = {
					-10,
					-27
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				line_colors = {
					(Colors.get_color_table_with_alpha("font_title", 255))
				},
				offset = {
					0,
					arg_127_7[2] + tbl_2[2] - num_7 - 50,
					arg_127_7[3] + 20
				}
			},
			up_arrow = {
				masked = true,
				offset = {
					arg_127_7[1] + tbl_2[1] - (tbl_3[1] + 31) / 2,
					arg_127_7[2] + 1.5 * tbl_3[2] - 7.5 + num / 2,
					arg_127_7[3] + 2
				},
				size = {
					31,
					15
				},
				color = get_color_table_with_alpha_2
			},
			up_arrow_hover = {
				masked = true,
				offset = {
					arg_127_7[1] + tbl_2[1] - (tbl_3[1] + 31) / 2,
					arg_127_7[2] + 1.5 * tbl_3[2] - 27 + num / 2,
					arg_127_7[3] + 1
				},
				size = {
					31,
					28
				},
				color = get_color_table_with_alpha_2
			},
			up_arrow_background = {
				offset = {
					arg_127_7[1] + tbl_2[1] - tbl_3[1],
					arg_127_7[2] + tbl_3[2] + 2 + num / 2,
					arg_127_7[3] + 1
				},
				color = {
					200,
					20,
					20,
					20
				},
				size = tbl_3
			},
			arrow_buttons_edge_horizontal = {
				offset = {
					arg_127_7[1] + tbl_2[1] - tbl_3[1] - 2,
					arg_127_7[2] + tbl_3[2] + num / 2,
					arg_127_7[3] + 1
				},
				color = tbl,
				size = {
					tbl_3[1],
					2
				}
			},
			arrow_buttons_edge_vertical = {
				offset = {
					arg_127_7[1] + tbl_2[1] - tbl_3[1] - 2,
					arg_127_7[2] + num / 2,
					arg_127_7[3] + 1
				},
				color = tbl,
				size = {
					2,
					num_2
				}
			},
			down_arrow = {
				masked = true,
				offset = {
					arg_127_7[1] + tbl_2[1] - (tbl_3[1] + 31) / 2,
					arg_127_7[2] + (tbl_3[2] - 15) / 2 + num / 2,
					arg_127_7[3] + 2
				},
				size = {
					31,
					15
				},
				color = get_color_table_with_alpha_2
			},
			down_arrow_hover = {
				masked = true,
				offset = {
					arg_127_7[1] + tbl_2[1] - (tbl_3[1] + 31) / 2,
					arg_127_7[2] + tbl_3[2] / 2 + num / 2 - 1,
					arg_127_7[3] + 1
				},
				size = {
					31,
					28
				},
				color = get_color_table_with_alpha_2
			},
			down_arrow_background = {
				offset = {
					arg_127_7[1] + tbl_2[1] - tbl_3[1],
					arg_127_7[2] + num / 2,
					arg_127_7[3] + 1
				},
				color = {
					200,
					20,
					20,
					20
				},
				size = tbl_3
			},
			bottom_edge = {
				offset = {
					arg_127_7[1],
					arg_127_7[2] - num_5,
					arg_127_7[3] + 1
				},
				color = get_color_table_with_alpha,
				size = {
					tbl_2[1],
					num_5
				}
			},
			list_style = {
				active = true,
				start_index = 1,
				offset = {
					arg_127_7[1] + 7 * tbl_2[1] / 10 + 5,
					arg_127_7[2] + tbl_2[2] - arg_127_4[2] - num / 2,
					arg_127_7[3] + 5
				},
				num_draws = count,
				list_member_offset = {
					0,
					-arg_127_4[2],
					0
				},
				item_styles = arg_127_3
			},
			highlight_texture = {
				masked = true,
				offset = {
					arg_127_7[1],
					arg_127_7[2],
					arg_127_7[3]
				},
				color = Colors.get_table("white"),
				size = {
					tbl_2[1],
					tbl_2[2]
				}
			}
		},
		scenegraph_id = arg_127_6
	}

	return UIWidget.init(tbl_4)
end

SettingsWidgetTypeTemplate = {
	drop_down = {
		input_function = function (self, arg_147_1)
			-- function 147
			local content = self.content
			local style = self.style
			local list_content = content.list_content
			local list_style = style.list_style
			local start_index = list_style.start_index
			local num_draws = list_style.num_draws
			local total_draws = list_style.total_draws
			local using_scrollbar = content.using_scrollbar
			local thumbnail_hotspot = content.thumbnail_hotspot

			if not content.active then
				local flag = false

				if not arg_147_1:get("move_up_hold_continuous") then
					local var_147_10

					for i = 1, total_draws do
						if not list_content[i].hotspot.is_selected then
							var_147_10 = i

							break
						end
					end

					if not var_147_10 then
						if var_147_10 > 1 then
							list_content[var_147_10].hotspot.is_selected = false
							list_content[var_147_10 - 1].hotspot.is_selected = true

							if not (not using_scrollbar and not (start_index >= var_147_10 - 1)) then
								list_style.start_index = math.max(start_index - 1, 1)
							end
						end
					else
						list_content[1].hotspot.is_selected = true
					end

					flag = true
				elseif not arg_147_1:get("move_down_hold_continuous") then
					local var_147_11

					for j = 1, total_draws do
						if not list_content[j].hotspot.is_selected then
							var_147_11 = j

							break
						end
					end

					if not var_147_11 then
						if var_147_11 < total_draws then
							list_content[var_147_11].hotspot.is_selected = false
							list_content[var_147_11 + 1].hotspot.is_selected = true

							if not (not using_scrollbar and not (num_draws <= var_147_11 + 1)) then
								list_style.start_index = math.min(start_index + 1, total_draws - num_draws + 1)
							end
						end
					else
						list_content[1].hotspot.is_selected = true
					end

					flag = true
				end

				if not flag then
					if not using_scrollbar then
						local start_index_2 = list_style.start_index
						local num = total_draws - num_draws

						thumbnail_hotspot.scroll_progress = (start_index_2 - 1) / num
					end

					return true
				end
			end

			if not arg_147_1:get("confirm") then
				if not content.active then
					content.active = true
					list_style.active = true

					if not Managers.input:is_device_active("mouse") then
						local current_selection = content.current_selection

						if not current_selection then
							list_content[current_selection].hotspot.is_selected = true

							if not using_scrollbar then
								local num_2 = total_draws - num_draws

								list_style.start_index = math.min(current_selection, num_2)
								thumbnail_hotspot.scroll_progress = (list_style.start_index - 1) / num_2
							end
						end
					end
				else
					content.active = false
					list_style.active = false

					local num_draws_2 = list_style.num_draws
					local var_147_17

					for k = 1, total_draws do
						local hotspot = list_content[k].hotspot

						if not hotspot.is_selected then
							hotspot.is_selected = false
							var_147_17 = k

							break
						end
					end

					if not var_147_17 then
						content.current_selection = var_147_17

						content.callback(content)
					end
				end

				return true, content.active
			end

			if not content.active and not arg_147_1:get("back") then
				content.active = false
				list_style.active = false

				local num_draws_3 = list_style.num_draws

				for l = 1, num_draws_3 do
					local hotspot_2 = list_content[l].hotspot

					if not hotspot_2.is_selected then
						hotspot_2.is_selected = false

						break
					end
				end

				return true, content.active
			end

			return content.active
		end,
		input_description = {
			name = "drop_down",
			gamepad_support = true,
			actions = {
				{
					input_action = "confirm",
					priority = 3,
					description_text = "input_description_open"
				}
			}
		},
		active_input_description = {
			ignore_generic_actions = true,
			name = "drop_down",
			gamepad_support = true,
			actions = {
				{
					input_action = "back",
					priority = 3,
					description_text = "input_description_back"
				},
				{
					input_action = "confirm",
					priority = 2,
					description_text = "input_description_confirm"
				},
				{
					input_action = "d_vertical",
					priority = 1,
					description_text = "input_description_change",
					ignore_keybinding = true
				}
			}
		}
	},
	checkbox = {
		input_function = function (self, arg_148_1)
			-- function 148
			local content = self.content

			if not arg_148_1:get("confirm") then
				content.hotspot.on_release = true

				return true
			end
		end,
		input_description = {
			name = "checkbox",
			gamepad_support = true,
			actions = {
				{
					input_action = "confirm",
					priority = 3,
					description_text = "input_description_toggle"
				}
			}
		}
	},
	option = {
		input_function = function (self, arg_149_1)
			-- function 149
			local content = self.content
			local num_options = content.num_options
			local current_selection = content.current_selection

			if not arg_149_1:get("move_left") then
				if current_selection > 1 then
					local num = current_selection - 1

					content["option_" .. num].on_release = true
				end

				return true
			elseif not arg_149_1:get("move_right") then
				if current_selection < num_options then
					local num_2 = current_selection + 1

					content["option_" .. num_2].on_release = true
				end

				return true
			end
		end
	},
	keybind = {
		input_function = function (self, arg_150_1)
			-- function 150
			local content = self.content
			local style = self.style

			if not content.active and not arg_150_1:get("back", true) then
				content.controller_input_pressed = true

				return true
			end

			if not content.active and arg_150_1:get("move_up") and arg_150_1:get("move_down") and arg_150_1:get("move_up_hold") and not arg_150_1:get("move_down_hold") then
				return true
			end
		end,
		input_description = {
			name = "keybind",
			gamepad_support = true,
			actions = {}
		}
	},
	sorted_list = {
		input_description = {
			name = "sorted_list",
			gamepad_support = true,
			actions = {
				{
					input_action = "confirm",
					priority = 2,
					description_text = "input_description_select"
				}
			}
		},
		active_input_description = {
			name = "sorted_list",
			gamepad_support = true,
			actions = {
				{
					input_action = "d_vertical",
					priority = 2,
					description_text = "input_description_select",
					ignore_keybinding = true
				},
				{
					input_action = "confirm",
					priority = 3,
					description_text = "input_description_move_to_top"
				}
			}
		},
		input_function = function (self, arg_151_1)
			-- function 151
			local content = self.content
			local list_content = content.list_content
			local style = self.style

			if Managers.input:is_device_active("gamepad") or not content.active then
				content.controller_input_pressed = true
				content.active = false
				hotspot.is_selected = true

				local count = #list_content

				for i = 1, count do
					list_content[i].hotspot.is_selected = false
				end

				return true, content.active
			end

			if content.active or not arg_151_1:get("confirm") then
				content.active = true
				content.controller_input_pressed = true
				list_content[1].hotspot.is_selected = true

				Managers.music:trigger_event("Play_hud_select")

				return true
			elseif not content.active then
				if not arg_151_1:get("move_up") then
					local count_2 = #list_content
					local var_151_5

					for j = 1, count_2 do
						if not list_content[j].hotspot.is_selected then
							var_151_5 = j

							break
						end
					end

					if not var_151_5 then
						if var_151_5 > 1 then
							list_content[var_151_5].hotspot.is_selected = false
							list_content[var_151_5 - 1].hotspot.is_selected = true

							Managers.music:trigger_event("Play_hud_select")
						end
					else
						list_content[1].hotspot.is_selected = true
					end

					return true
				elseif not arg_151_1:get("move_down") then
					local count_3 = #list_content
					local var_151_7

					for k = 1, count_3 do
						if not list_content[k].hotspot.is_selected then
							var_151_7 = k

							break
						end
					end

					if not var_151_7 then
						if var_151_7 < count_3 then
							list_content[var_151_7].hotspot.is_selected = false
							list_content[var_151_7 + 1].hotspot.is_selected = true

							Managers.music:trigger_event("Play_hud_select")
						end
					else
						list_content[1].hotspot.is_selected = true
					end

					return true
				elseif not arg_151_1:get("back", true) then
					content.controller_input_pressed = true
					content.active = false

					local count_4 = #list_content

					for l = 1, count_4 do
						list_content[l].hotspot.is_selected = false
					end

					Managers.music:trigger_event("Play_hud_select")

					return true, content.active
				elseif not arg_151_1:get("confirm", true) then
					local var_151_9
					local count_5 = #list_content

					for i4 = 1, count_5 do
						if not list_content[i4].hotspot.is_selected then
							var_151_9 = i4

							break
						end
					end

					if not var_151_9 then
						local var_151_11 = list_content[var_151_9]

						table.remove(list_content, var_151_9)
						table.insert(list_content, 1, var_151_11)
						content.callback(content, style)
						Managers.music:trigger_event("Play_hud_select")

						for i_2, v in ipairs(list_content) do
							v.index_text = i_2 .. "."
						end
					end
				end

				return true, content.active
			end

			return false, content.active
		end
	},
	stepper = {
		input_function = function (self, arg_152_1)
			-- function 152
			local content = self.content

			if not arg_152_1:get("move_left") then
				content.controller_on_release_left = true

				return true
			elseif not arg_152_1:get("move_right") then
				content.controller_on_release_right = true

				return true
			end
		end,
		input_description = {
			name = "stepper",
			gamepad_support = true,
			actions = {
				{
					input_action = "d_horizontal",
					priority = 2,
					description_text = "input_description_change",
					ignore_keybinding = true
				}
			}
		}
	},
	slider = {
		input_function = function (self, arg_153_1, arg_153_2)
			-- function 153
			local content = self.content
			local input_cooldown = content.input_cooldown
			local input_cooldown_multiplier = content.input_cooldown_multiplier
			local flag = false

			if not input_cooldown then
				flag = true

				local max = math.max(input_cooldown - arg_153_2, 0)

				input_cooldown = not (max > 0) or not max or nil
				content.input_cooldown = input_cooldown
			end

			local internal_value = content.internal_value
			local num_decimals = content.num_decimals
			local min = content.min
			local num = 1 / ((content.max - min) * 10^num_decimals)
			local flag_2 = false

			if not arg_153_1:get("move_left_hold") then
				if not input_cooldown then
					content.internal_value = math.clamp(internal_value - num, 0, 1)
					flag_2 = true
				end
			elseif not (not arg_153_1:get("move_right_hold") and input_cooldown) then
				content.internal_value = math.clamp(internal_value + num, 0, 1)
				flag_2 = true
			end

			if not flag_2 then
				content.changed = true

				if not flag then
					local max_2 = math.max(input_cooldown_multiplier - 0.1, 0.1)

					content.input_cooldown = 0.2 * math.ease_in_exp(max_2)
					content.input_cooldown_multiplier = max_2
				else
					local num_2 = 1

					content.input_cooldown = 0.2 * math.ease_in_exp(num_2)
					content.input_cooldown_multiplier = num_2
				end

				return true
			end
		end,
		input_description = {
			name = "slider",
			gamepad_support = true,
			actions = {
				{
					input_action = "d_horizontal",
					priority = 2,
					description_text = "input_description_change",
					ignore_keybinding = true
				}
			}
		}
	},
	image = {
		input_function = function ()
			-- function 154
			return
		end,
		input_description = {
			name = "image",
			gamepad_support = true,
			actions = {}
		}
	},
	title = {
		input_function = function ()
			-- function 155
			return
		end,
		input_description = {
			name = "title",
			gamepad_support = true,
			actions = {}
		}
	},
	text_link = {
		input_function = function (self, arg_156_1)
			-- function 156
			local content = self.content

			content.controller_input_pressed = nil

			if not arg_156_1:get("confirm") then
				content.controller_input_pressed = true

				return true
			end
		end,
		input_description = {
			name = "title",
			gamepad_support = true,
			actions = {
				{
					input_action = "confirm",
					priority = 3,
					description_text = "input_description_open"
				}
			}
		}
	},
	gamepad_layout = {
		input_function = function ()
			-- function 157
			return
		end,
		input_description = {
			name = "gamepad_layout",
			gamepad_support = true,
			actions = {}
		}
	}
}

local tbl_19 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.25,
			init = function (arg_158_0, arg_158_1, arg_158_2, arg_158_3)
				-- function 158
				arg_158_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_159_0, arg_159_1, arg_159_2, arg_159_3, arg_159_4)
				-- function 159
				local easeOutCubic = math.easeOutCubic(arg_159_3)

				arg_159_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_160_0, arg_160_1, arg_160_2, arg_160_3)
				-- function 160
				arg_160_3.render_settings.alpha_multiplier = 1
			end
		}
	}
}

return {
	scenegraph_definition = tbl_5,
	background_widget_definitions = tbl_8,
	gamepad_frame_widget_definitions = tbl_7,
	widget_definitions = tbl_9,
	button_definitions = tbl_10,
	scrollbar_definition = create_scrollbar,
	animation_definitions = tbl_19,
	create_title_widget = fn_12,
	create_checkbox_widget = fn_6,
	create_slider_widget = fn_9,
	create_drop_down_widget = fn_10,
	create_stepper_widget = fn_11,
	create_option_widget = fn_14,
	create_text_link_widget = fn_13,
	create_keybind_widget = fn_15,
	create_sorted_list_widget = fn_16,
	create_simple_texture_widget = fn_7,
	create_gamepad_layout_widget = fn_8,
	create_safe_rect_widget = fn_2
}
