-- chunkname: @scripts/ui/views/options_view_definitions.lua

local var_0_0 = 400
local var_0_1 = {
	200,
	0,
	0,
	0
}
local var_0_2 = {
	14,
	14
}
local var_0_3 = {
	var_0_0,
	10
}
local var_0_4 = 2
local var_0_5 = {
	var_0_0,
	30
}
local var_0_6 = 1400
local var_0_7 = 900
local var_0_8 = 2
local var_0_9 = Colors.get_color_table_with_alpha("font_default", 50)
local var_0_10 = {
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
			var_0_6,
			var_0_7
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
			var_0_6,
			var_0_7
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
			var_0_6,
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
			var_0_6,
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
			var_0_6,
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
			var_0_6,
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
			var_0_6,
			var_0_7 - 140
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
			var_0_6,
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
			var_0_6,
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
			var_0_7 - 120
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

local function var_0_11(arg_1_0)
	if arg_1_0 then
		return 25 * arg_1_0
	else
		return 0
	end
end

local function var_0_12(arg_2_0)
	local var_2_0 = {
		0,
		0
	}
	local var_2_1 = {
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
					content_change_function = function(arg_3_0, arg_3_1)
						local var_3_0 = (Application.user_setting("safe_rect") or 0) * 0.01

						arg_3_1.offset[1] = var_2_1[1] + 1920 * var_3_0 * 0.5
						arg_3_1.offset[2] = var_2_1[2] + 1080 * var_3_0 * 0.5
					end
				},
				{
					style_id = "bottom_right_triangle",
					pass_type = "triangle",
					content_change_function = function(arg_4_0, arg_4_1)
						local var_4_0 = (Application.user_setting("safe_rect") or 0) * 0.01

						arg_4_1.offset[1] = -var_2_1[1] - 1920 * var_4_0 * 0.5
						arg_4_1.offset[2] = var_2_1[2] + 1080 * var_4_0 * 0.5
					end
				},
				{
					style_id = "top_right_triangle",
					pass_type = "triangle",
					content_change_function = function(arg_5_0, arg_5_1)
						local var_5_0 = (Application.user_setting("safe_rect") or 0) * 0.01

						arg_5_1.offset[1] = -var_2_1[1] - 1920 * var_5_0 * 0.5
						arg_5_1.offset[2] = -var_2_1[2] - 1080 * var_5_0 * 0.5
					end
				},
				{
					style_id = "top_left_triangle",
					pass_type = "triangle",
					content_change_function = function(arg_6_0, arg_6_1)
						local var_6_0 = (Application.user_setting("safe_rect") or 0) * 0.01

						arg_6_1.offset[1] = var_2_1[1] + 1920 * var_6_0 * 0.5
						arg_6_1.offset[2] = -var_2_1[2] - 1080 * var_6_0 * 0.5
					end
				},
				{
					style_id = "left_line",
					pass_type = "rect",
					content_change_function = function(arg_7_0, arg_7_1)
						local var_7_0 = (Application.user_setting("safe_rect") or 0) * 0.01

						arg_7_1.offset[1] = 1920 * var_7_0 * 0.5
						arg_7_1.offset[2] = var_2_1[1] + 1080 * var_7_0 * 0.5
						arg_7_1.texture_size[2] = 1080 - 1080 * var_7_0 - var_2_1[2] * 2 - var_2_0[2]
					end
				},
				{
					style_id = "right_line",
					pass_type = "rect",
					content_change_function = function(arg_8_0, arg_8_1)
						local var_8_0 = (Application.user_setting("safe_rect") or 0) * 0.01

						arg_8_1.offset[1] = -1920 * var_8_0 * 0.5
						arg_8_1.offset[2] = var_2_1[1] + 1080 * var_8_0 * 0.5
						arg_8_1.texture_size[2] = 1080 - 1080 * var_8_0 - var_2_1[2] * 2 - var_2_0[2]
					end
				},
				{
					style_id = "top_line",
					pass_type = "rect",
					content_change_function = function(arg_9_0, arg_9_1)
						local var_9_0 = (Application.user_setting("safe_rect") or 0) * 0.01

						arg_9_1.offset[1] = 1920 * var_9_0 * 0.5
						arg_9_1.offset[2] = -1080 * var_9_0 * 0.5
						arg_9_1.texture_size[1] = 1920 - 1920 * var_9_0 - var_2_0[1]
					end
				},
				{
					style_id = "bottom_line",
					pass_type = "rect",
					content_change_function = function(arg_10_0, arg_10_1)
						local var_10_0 = (Application.user_setting("safe_rect") or 0) * 0.01

						arg_10_1.offset[1] = 1920 * var_10_0 * 0.5
						arg_10_1.offset[2] = 1080 * var_10_0 * 0.5
						arg_10_1.texture_size[1] = 1920 - 1920 * var_10_0 - var_2_0[1]
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

local function var_0_13(arg_11_0, arg_11_1)
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

local function var_0_14(arg_12_0, arg_12_1)
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

local var_0_15 = {
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
local var_0_16 = {
	gamepad_tooltip_text = UIWidgets.create_simple_text("", "gamepad_tooltip_text", nil, nil, var_0_15)
}
local var_0_17 = {
	menu_symbol = UIWidgets.create_simple_texture("cogwheel_small", "menu_symbol", nil, nil, Colors.get_color_table_with_alpha("font_title", 255)),
	background_frame = UIWidgets.create_frame("background_frame", var_0_10.background_frame.size, "menu_frame_12"),
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
	background_bottom_panel_edge = var_0_13("background_bottom_panel_edge", var_0_10.background_bottom_panel_edge.size),
	background_top_panel = UIWidgets.create_simple_rect("background_top_panel", {
		255,
		10,
		10,
		10
	}),
	background_top_panel_edge = var_0_13("background_top_panel_edge", var_0_10.background_top_panel_edge.size),
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
					scroll_function = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
						local var_13_0 = Managers.input:is_device_active("gamepad")
						local var_13_1 = arg_13_2.scroll_step or 0.1
						local var_13_2 = arg_13_2.internal_scroll_value

						if not var_13_0 and IS_XB1 then
							var_13_2 = var_13_2 + var_13_1 * -arg_13_4.x * 0.01
						else
							var_13_2 = var_13_2 + var_13_1 * -arg_13_4.y
						end

						arg_13_2.internal_scroll_value = math.clamp(var_13_2, 0, 1)
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
local var_0_18 = {
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
		content_check_function = function(arg_14_0)
			return not arg_14_0.hotspot.is_hover and arg_14_0.hotspot.is_clicked > 0
		end
	},
	{
		pass_type = "texture",
		texture_id = "texture_hover_id",
		content_check_function = function(arg_15_0)
			return arg_15_0.hotspot.is_hover and arg_15_0.hotspot.is_clicked > 0
		end
	},
	{
		pass_type = "texture",
		texture_id = "texture_click_id",
		content_check_function = function(arg_16_0)
			return arg_16_0.hotspot.is_clicked == 0 or arg_16_0.hotspot.is_selected
		end
	},
	{
		style_id = "text",
		pass_type = "text",
		text_id = "text_field",
		content_check_function = function(arg_17_0, arg_17_1)
			if arg_17_0.hotspot.is_hover then
				arg_17_1.text_color = arg_17_1.hover_color
			else
				arg_17_1.text_color = arg_17_1.default_color
			end

			return true
		end
	}
}

local function var_0_19(arg_18_0, arg_18_1)
	local var_18_0 = var_0_10[arg_18_0].size
	local var_18_1 = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				pass_type = "texture",
				style_id = "button_texture",
				texture_id = "button_texture",
				content_check_function = function(arg_19_0)
					return not arg_19_0.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "button_texture_hover",
				texture_id = "button_texture",
				content_check_function = function(arg_20_0)
					return arg_20_0.button_hotspot.is_hover
				end
			}
		}
	}
	local var_18_2 = {
		button_texture = arg_18_1,
		button_hotspot = {}
	}
	local var_18_3 = {
		size = {
			var_18_0[1],
			var_18_0[2]
		},
		color = {
			255,
			255,
			255,
			255
		},
		button_texture_hover = {
			size = {
				var_18_0[1],
				var_18_0[2]
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
				var_18_0[1],
				var_18_0[2]
			},
			color = Colors.get_color_table_with_alpha("font_button_normal", 255)
		}
	}

	return {
		element = var_18_1,
		content = var_18_2,
		style = var_18_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_18_0
	}
end

local var_0_20 = {
	exit_button = var_0_19("exit_button", "friends_icon_close"),
	back_button = UIWidgets.create_layout_button("back_button", "layout_button_back", "layout_button_back_glow"),
	apply_button = UIWidgets.create_text_button("apply_button", "menu_settings_apply", 22, nil, "center"),
	reset_to_default = UIWidgets.create_text_button("reset_to_default", "menu_settings_reset_to_default", 22, nil, "center")
}
local var_0_21 = var_0_10.list_mask.size[1]
local var_0_22 = var_0_10.scrollbar_root.size
local var_0_23 = UIWidgets.create_scrollbar("scrollbar_root", var_0_22)
local var_0_24 = false
local var_0_25 = {
	var_0_21,
	30
}

local function var_0_26(arg_21_0, arg_21_1, arg_21_2)
	arg_21_2[2] = arg_21_2[2] - var_0_25[2]

	local var_21_0 = {
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
					content_check_function = function(arg_22_0)
						return arg_22_0.is_highlighted
					end
				},
				{
					pass_type = "local_offset",
					offset_function = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
						if arg_23_2.hotspot.on_release then
							arg_23_2.flag = not arg_23_2.flag
						end

						if arg_23_2.flag then
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
					content_check_function = function(arg_24_0)
						return var_0_24
					end
				},
				{
					pass_type = "border",
					content_check_function = function(arg_25_0, arg_25_1)
						if var_0_24 then
							arg_25_1.thickness = 1
						end

						return var_0_24
					end
				},
				{
					style_id = "debug_middle_line",
					pass_type = "rect",
					content_check_function = function(arg_26_0)
						return var_0_24
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
					var_0_25[1],
					var_0_25[2]
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
			size = table.clone(var_0_25),
			color = {
				50,
				255,
				255,
				255
			},
			debug_middle_line = {
				offset = {
					arg_21_2[1],
					arg_21_2[2] + var_0_25[2] / 2 - 1,
					arg_21_2[3] + 10
				},
				size = {
					var_0_25[1],
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
				color = var_0_9,
				size = {
					var_0_25[1],
					var_0_8
				}
			}
		},
		scenegraph_id = arg_21_1
	}

	return UIWidget.init(var_21_0)
end

local function var_0_27(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	arg_27_3[2] = arg_27_3[2] - arg_27_1[2]

	local var_27_0 = {
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
				color = var_0_9,
				size = {
					arg_27_1[1],
					var_0_8
				}
			}
		},
		scenegraph_id = arg_27_2
	}

	return UIWidget.init(var_27_0)
end

local function var_0_28(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	arg_28_5[2] = arg_28_5[2] - arg_28_1[2]

	local var_28_0 = PLATFORM
	local var_28_1

	if IS_WINDOWS then
		var_28_1 = UIWidgets.create_gamepad_layout_win32(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_5, arg_28_4)
	elseif IS_XB1 then
		var_28_1 = UIWidgets.create_gamepad_layout_xb1(arg_28_0, arg_28_1, arg_28_5, arg_28_4)
	elseif IS_PS4 then
		var_28_1 = UIWidgets.create_gamepad_layout_ps4(arg_28_0, arg_28_1, arg_28_5, arg_28_4)
	end

	return UIWidget.init(var_28_1)
end

local var_0_29 = {
	var_0_21 - 100,
	30
}

local function var_0_30(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	arg_29_3[2] = arg_29_3[2] - var_0_29[2]

	local var_29_0 = {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "slider_box",
					texture_id = "rect_masked",
					content_check_function = function(arg_30_0)
						return not arg_30_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "disabled_slider_box",
					texture_id = "rect_masked",
					content_check_function = function(arg_31_0)
						return arg_31_0.disabled
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
					content_check_function = function(arg_32_0)
						return arg_32_0.is_highlighted
					end
				},
				{
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function(arg_33_0)
						return arg_33_0.tooltip_text and arg_33_0.highlight_hotspot.is_hover and not Managers.input:is_device_active("gamepad")
					end
				},
				{
					content_check_hover = "hotspot",
					pass_type = "held",
					style_id = "slider_box",
					held_function = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
						local var_34_0
						local var_34_1 = Managers.input:is_device_active("gamepad")

						if var_34_1 then
							var_34_0 = arg_34_3:get("cursor")
						elseif IS_XB1 and GameSettingsDevelopment.allow_keyboard_mouse and not var_34_1 then
							var_34_0 = arg_34_3:get("cursor")
						else
							var_34_0 = UIInverseScaleVectorToResolution(arg_34_3:get("cursor"))
						end

						local var_34_2 = arg_34_2.scenegraph_id
						local var_34_3 = UISceneGraph.get_world_position(arg_34_0, var_34_2)
						local var_34_4 = arg_34_1.size[1]
						local var_34_5 = var_34_0[1]
						local var_34_6 = var_34_3[1] + arg_34_1.offset[1]
						local var_34_7 = arg_34_2.internal_value
						local var_34_8 = var_34_5 - var_34_6
						local var_34_9 = math.clamp(var_34_8 / var_34_4, 0, 1)

						arg_34_2.internal_value = var_34_9

						if var_34_7 ~= var_34_9 and not arg_34_2.callback_on_release then
							arg_34_2.callback(arg_34_2, arg_34_1.parent)
						end
					end,
					release_function = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
						arg_35_2.callback(arg_35_2, arg_35_1.parent)
					end
				},
				{
					style_id = "slider_box_hotspot",
					pass_type = "hotspot",
					content_id = "hotspot",
					content_check_function = function(arg_36_0)
						return not arg_36_0.parent.disabled
					end
				},
				{
					pass_type = "local_offset",
					offset_function = function(arg_37_0, arg_37_1, arg_37_2)
						local var_37_0 = arg_37_2.internal_value
						local var_37_1 = arg_37_2.min
						local var_37_2 = arg_37_2.max
						local var_37_3 = math.round_with_precision(var_37_1 + (var_37_2 - var_37_1) * var_37_0, arg_37_2.num_decimals or 0)

						arg_37_2.value = var_37_3
						arg_37_2.value_text = var_37_3

						local var_37_4 = arg_37_1.slider_box
						local var_37_5 = var_37_4.size
						local var_37_6 = var_37_4.offset[1]
						local var_37_7 = var_37_5[1] * var_37_0
						local var_37_8 = arg_37_1.slider
						local var_37_9 = arg_37_1.slider_hover
						local var_37_10 = var_37_8.offset
						local var_37_11 = var_37_8.size
						local var_37_12 = math.max(0, math.min(var_37_7 - var_37_11[1], var_37_5[1] - var_37_11[1]))

						var_37_8.offset[1] = var_37_6 + var_37_7 - var_37_8.size[1] / 2
						var_37_9.offset[1] = var_37_8.offset[1] + var_37_11[1] / 2 - var_37_9.size[1] / 2

						if arg_37_2.hotspot.is_hover or arg_37_2.altering_value then
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
					content_check_function = function(arg_38_0)
						return not arg_38_0.disabled
					end
				},
				{
					style_id = "disabled_value_text",
					pass_type = "text",
					text_id = "value_text",
					content_check_function = function(arg_39_0)
						return arg_39_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "slider",
					texture_id = "slider",
					content_check_function = function(arg_40_0)
						return not arg_40_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "slider_hover",
					texture_id = "slider_hover",
					content_check_function = function(arg_41_0)
						if arg_41_0.disabled then
							return false
						end

						return arg_41_0.hotspot.is_hover
					end
				},
				{
					pass_type = "rect",
					content_check_function = function(arg_42_0)
						return var_0_24
					end
				},
				{
					style_id = "slider_box",
					pass_type = "rect",
					content_check_function = function(arg_43_0)
						return var_0_24
					end
				},
				{
					pass_type = "border",
					content_check_function = function(arg_44_0, arg_44_1)
						if var_0_24 then
							arg_44_1.thickness = 1
						end

						return var_0_24
					end
				},
				{
					style_id = "debug_middle_line",
					pass_type = "rect",
					content_check_function = function(arg_45_0)
						return var_0_24
					end
				},
				{
					pass_type = "texture",
					style_id = "slider_image",
					texture_id = "slider_image",
					content_check_function = function(arg_46_0)
						return arg_46_0.slider_image ~= ""
					end
				},
				{
					style_id = "slider_image_text",
					pass_type = "text",
					text_id = "slider_image_text",
					content_check_function = function(arg_47_0)
						return arg_47_0.slider_image_text ~= ""
					end
				},
				{
					style_id = "left_arrow",
					pass_type = "hotspot",
					content_id = "left_hotspot",
					content_check_function = function(arg_48_0)
						return not arg_48_0.parent.disabled
					end
				},
				{
					style_id = "right_arrow",
					pass_type = "hotspot",
					content_id = "right_hotspot",
					content_check_function = function(arg_49_0)
						return not arg_49_0.parent.disabled
					end
				},
				{
					texture_id = "texture_id",
					style_id = "left_arrow",
					pass_type = "texture",
					content_id = "arrow",
					content_check_function = function(arg_50_0)
						return not arg_50_0.parent.disabled
					end
				},
				{
					texture_id = "texture_id",
					style_id = "right_arrow",
					pass_type = "texture_uv",
					content_id = "arrow",
					content_check_function = function(arg_51_0)
						return not arg_51_0.parent.disabled
					end
				},
				{
					texture_id = "texture_id",
					style_id = "left_arrow_hover",
					pass_type = "texture",
					content_id = "arrow_hover",
					content_check_function = function(arg_52_0)
						return not arg_52_0.parent.disabled
					end
				},
				{
					texture_id = "texture_id",
					style_id = "right_arrow_hover",
					pass_type = "texture_uv",
					content_id = "arrow_hover",
					content_check_function = function(arg_53_0)
						return not arg_53_0.parent.disabled
					end
				},
				{
					pass_type = "local_offset",
					offset_function = function(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
						local var_54_0 = arg_54_2.left_hotspot
						local var_54_1 = arg_54_2.right_hotspot

						if var_54_0.on_hover_enter then
							local var_54_2 = arg_54_2.on_hover_enter_callback

							if var_54_2 then
								var_54_2("left_arrow_hover")
							end
						end

						if var_54_0.on_hover_exit then
							local var_54_3 = arg_54_2.on_hover_exit_callback

							if var_54_3 then
								var_54_3("left_arrow_hover")
							end
						end

						if var_54_0.on_release then
							local var_54_4 = arg_54_2.on_pressed_callback

							if var_54_4 then
								var_54_4("left_arrow")
								var_54_4("left_arrow_hover")
							end
						end

						if var_54_1.on_hover_enter then
							local var_54_5 = arg_54_2.on_hover_enter_callback

							if var_54_5 then
								var_54_5("right_arrow_hover")
							end
						end

						if var_54_1.on_hover_exit then
							local var_54_6 = arg_54_2.on_hover_exit_callback

							if var_54_6 then
								var_54_6("right_arrow_hover")
							end
						end

						if var_54_1.on_release then
							local var_54_7 = arg_54_2.on_pressed_callback

							if var_54_7 then
								var_54_7("right_arrow")
								var_54_7("right_arrow_hover")
							end
						end
					end
				}
			}
		},
		content = {
			slider = "slider_thumb",
			internal_value = 0.5,
			rect_masked = "rect_masked",
			slider_hover = "slider_thumb_hover",
			value = 0.5,
			highlight_texture = "playerlist_hover",
			scenegraph_id = arg_29_2,
			text = arg_29_0,
			slider_image = arg_29_4 and arg_29_4.slider_image or "",
			slider_image_text = arg_29_5 and arg_29_5.text or "",
			tooltip_text = arg_29_1,
			hotspot = {},
			highlight_hotspot = {
				allow_multi_hover = true
			},
			hotspot_content_ids = {
				"hotspot"
			},
			left_hotspot = {},
			right_hotspot = {},
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
			}
		},
		style = {
			offset = {
				arg_29_3[1],
				arg_29_3[2] - (arg_29_4 and arg_29_4.size[2] or 0),
				arg_29_3[3]
			},
			size = {
				var_0_29[1],
				var_0_29[2] + (arg_29_4 and arg_29_4.size[2] or 0)
			},
			color = {
				50,
				255,
				255,
				255
			},
			highlight_texture = {
				masked = true,
				offset = {
					arg_29_3[1],
					arg_29_3[2],
					arg_29_3[3]
				},
				color = Colors.get_table("white"),
				size = {
					var_0_29[1],
					var_0_29[2]
				}
			},
			tooltip_text = {
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
			},
			text = {
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
			},
			slider_box = {
				offset = {
					arg_29_3[1] + var_0_29[1] - var_0_0 + 30,
					arg_29_3[2] + var_0_29[2] / 2 - 4,
					arg_29_3[3] + 10
				},
				size = {
					var_0_0 - 112,
					10
				},
				color = {
					255,
					5,
					5,
					5
				}
			},
			disabled_slider_box = {
				offset = {
					arg_29_3[1] + var_0_29[1] - var_0_0 + 30,
					arg_29_3[2] + var_0_29[2] / 2 - 4,
					arg_29_3[3] + 10
				},
				size = {
					var_0_0 - 112,
					10
				},
				color = {
					255,
					20,
					20,
					20
				}
			},
			slider_box_hotspot = {
				offset = {
					arg_29_3[1] + var_0_29[1] - var_0_0 + 19,
					arg_29_3[2] + var_0_29[2] / 2 - 13.5,
					arg_29_3[3] + 10
				},
				size = {
					var_0_0 - 90,
					27
				}
			},
			slider = {
				masked = true,
				color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					arg_29_3[1] + var_0_29[1] - var_0_0,
					arg_29_3[2] + var_0_29[2] / 2 - 13.5,
					arg_29_3[3] + 15
				},
				size = {
					14,
					27
				}
			},
			slider_hover = {
				masked = true,
				color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					arg_29_3[1] + var_0_29[1] - var_0_0,
					arg_29_3[2] + var_0_29[2] / 2 - 12.5,
					arg_29_3[3] + 15
				},
				size = {
					34,
					25
				}
			},
			input_field_background = {
				offset = {
					arg_29_3[1] + var_0_29[1] - 50 - 2,
					arg_29_3[2] + var_0_29[2] / 2 - (var_0_29[2] - 10) / 2,
					arg_29_3[3]
				},
				color = var_0_1,
				size = {
					52,
					var_0_29[2] - 10 + 2
				}
			},
			input_field_background_2 = {
				offset = {
					arg_29_3[1] + var_0_29[1] - 50,
					arg_29_3[2] + var_0_29[2] / 2 - (var_0_29[2] - 10) / 2,
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
					var_0_29[2] - 10
				}
			},
			value_text = {
				font_size = 16,
				upper_case = true,
				localize = false,
				horizontal_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_masked",
				offset = {
					arg_29_3[1] + var_0_29[1] - 25,
					arg_29_3[2] + var_0_29[2] / 2 - (var_0_29[2] - 10) / 2 - 2,
					arg_29_3[3] + 2
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				hover_color = Colors.get_color_table_with_alpha("font_default", 255)
			},
			disabled_value_text = {
				font_size = 16,
				upper_case = true,
				localize = false,
				horizontal_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_masked",
				offset = {
					arg_29_3[1] + var_0_29[1] - 25,
					arg_29_3[2] + var_0_29[2] / 2 - (var_0_29[2] - 10) / 2 - 2,
					arg_29_3[3] + 2
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 50),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				hover_color = Colors.get_color_table_with_alpha("font_default", 255)
			},
			debug_middle_line = {
				offset = {
					arg_29_3[1],
					arg_29_3[2] + var_0_29[2] / 2 - 1,
					arg_29_3[3] + 10
				},
				size = {
					var_0_29[1],
					2
				},
				color = {
					200,
					0,
					255,
					0
				}
			},
			slider_image = {
				masked = true,
				color = arg_29_4 and arg_29_4.color or nil,
				size = arg_29_4 and arg_29_4.size or {
					0,
					0
				},
				offset = {
					arg_29_3[1] + var_0_29[1] - (arg_29_4 and arg_29_4.size[1] or 0),
					arg_29_3[2] - (arg_29_4 and arg_29_4.size[2] or 0),
					arg_29_3[3] + 15
				}
			},
			slider_image_text = {
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font = true,
				offset = {
					arg_29_3[1] + var_0_29[1] - (arg_29_4 and arg_29_4.size[1] or 0) + 5,
					arg_29_3[2] - (arg_29_4 and arg_29_4.size[2] / 2 or 0),
					arg_29_3[3] + 16
				},
				text_color = arg_29_5 and arg_29_5.color or Colors.get_color_table_with_alpha("font_default", 255),
				upper_case = arg_29_5 and arg_29_5.upper_case or false,
				font_type = arg_29_5 and arg_29_5.font or "hell_shark_masked",
				font_size = arg_29_5 and arg_29_5.font_size or 16,
				localize = arg_29_5 and arg_29_5.localize or false
			},
			bottom_edge = {
				offset = {
					arg_29_3[1],
					arg_29_3[2],
					arg_29_3[3] + 1
				},
				color = var_0_9,
				size = {
					var_0_29[1],
					var_0_8
				}
			},
			left_arrow = {
				masked = true,
				offset = {
					arg_29_3[1] + var_0_29[1] - var_0_0,
					arg_29_3[2] + (var_0_29[2] / 2 - 13.5),
					arg_29_3[3] + 1
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
					arg_29_3[1] + var_0_29[1] - var_0_0 + 6,
					arg_29_3[2] + (var_0_29[2] / 2 - 17.5),
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
			},
			left_arrow_hotspot = {
				offset = {
					arg_29_3[1] + var_0_29[1] - var_0_0,
					arg_29_3[2] + (var_0_29[2] / 2 - 13.5),
					arg_29_3[3]
				},
				size = {
					var_0_0 / 2,
					27
				}
			},
			right_arrow = {
				masked = true,
				offset = {
					arg_29_3[1] + var_0_29[1] - 19 - 52,
					arg_29_3[2] + (var_0_29[2] / 2 - 13.5),
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
			},
			right_arrow_hover = {
				masked = true,
				offset = {
					arg_29_3[1] + var_0_29[1] - 30 - 52 - 5,
					arg_29_3[2] + (var_0_29[2] / 2 - 17.5),
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
			},
			right_arrow_hotspot = {
				offset = {
					arg_29_3[1] + var_0_29[1] - var_0_0 / 2,
					arg_29_3[2] + (var_0_29[2] / 2 - 13.5),
					arg_29_3[3]
				},
				size = {
					var_0_0 / 2,
					27
				}
			}
		},
		scenegraph_id = arg_29_2
	}

	arg_29_3[2] = arg_29_3[2] - var_0_29[2] - (arg_29_4 and arg_29_4.size[2] or 0)

	return UIWidget.init(var_29_0)
end

local var_0_31 = {
	var_0_21 - 100,
	30
}

local function var_0_32(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6, arg_55_7, arg_55_8)
	local var_55_0 = {}
	local var_55_1 = {}
	local var_55_2 = #arg_55_1

	for iter_55_0 = 1, var_55_2 do
		var_55_0[iter_55_0] = arg_55_1[iter_55_0].text
		var_55_1[iter_55_0] = arg_55_1[iter_55_0].value
	end

	arg_55_6[2] = arg_55_6[2] - var_0_31[2]

	local var_55_3 = {
		var_0_0 - 56,
		24
	}
	local var_55_4 = {}
	local var_55_5 = {}
	local var_55_6 = math.min(var_55_2, 10)
	local var_55_7 = var_55_3[2] * var_55_6
	local var_55_8 = var_55_6 < var_55_2

	if var_55_8 then
		var_55_3[1] = var_55_3[1] - 25
	end

	for iter_55_1 = 1, var_55_2 do
		var_55_5[iter_55_1], var_55_4[iter_55_1] = {
			selected = false,
			highlight_texture = "playerlist_hover",
			hotspot = {},
			text = var_55_0[iter_55_1]
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
				size = var_55_3
			},
			highlight_texture = {
				offset = {
					0,
					0,
					24
				},
				color = Colors.get_table("white"),
				size = var_55_3
			},
			size = var_55_3,
			color = {
				50,
				255,
				255,
				255
			}
		}
	end

	local var_55_9 = math.pi
	local var_55_10 = {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_change_function = function(arg_56_0, arg_56_1)
						if arg_56_0.disabled then
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
					content_check_function = function(arg_57_0)
						return arg_57_0.is_highlighted
					end
				},
				{
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function(arg_58_0)
						if not arg_58_0.highlight_hotspot.is_hover or Managers.input:is_device_active("gamepad") then
							return false
						end

						if not arg_58_0.disabled then
							return arg_58_0.tooltip_text
						else
							return not arg_58_0.disabled_tooltip_text
						end
					end
				},
				{
					style_id = "disabled_tooltip_text",
					pass_type = "option_tooltip",
					text_id = "disabled_tooltip_text",
					content_check_function = function(arg_59_0)
						if not arg_59_0.disabled or not arg_59_0.highlight_hotspot.is_hover or Managers.input:is_device_active("gamepad") then
							return false
						end

						if arg_59_0.overriden_reason then
							arg_59_0.disabled_tooltip_text = arg_59_0.overriden_reason
						end

						if arg_59_0.disabled_tooltip_text then
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
					content_check_function = function(arg_60_0, arg_60_1)
						local var_60_0 = arg_60_0.parent

						if var_60_0.disabled then
							return false
						end

						return var_60_0.active
					end
				},
				{
					texture_id = "texture_id",
					style_id = "arrow",
					pass_type = "texture",
					content_id = "arrow",
					content_check_function = function(arg_61_0, arg_61_1)
						local var_61_0 = arg_61_0.parent

						if var_61_0.disabled then
							return false
						end

						return not var_61_0.active
					end
				},
				{
					texture_id = "texture_id",
					style_id = "arrow_hover_flipped",
					pass_type = "texture_uv",
					content_id = "arrow_hover",
					content_check_function = function(arg_62_0, arg_62_1)
						local var_62_0 = arg_62_0.parent

						if var_62_0.hotspot.is_hover then
							if var_62_0.disabled then
								return false
							end

							return var_62_0.active
						end
					end
				},
				{
					texture_id = "texture_id",
					style_id = "arrow_hover",
					pass_type = "texture",
					content_id = "arrow_hover",
					content_check_function = function(arg_63_0, arg_63_1)
						local var_63_0 = arg_63_0.parent

						if var_63_0.hotspot.is_hover then
							if var_63_0.disabled then
								return false
							end

							return not var_63_0.active
						end
					end
				},
				{
					style_id = "selected_option",
					pass_type = "text",
					text_id = "selected_option",
					content_check_function = function(arg_64_0, arg_64_1)
						if arg_64_0.disabled then
							arg_64_1.text_color = arg_64_1.disabled_color
						elseif arg_64_0.hotspot.is_hover or arg_64_0.active then
							arg_64_1.text_color = arg_64_1.hover_color
						else
							arg_64_1.text_color = arg_64_1.default_color
						end

						if arg_64_0._last_selection ~= arg_64_0.current_selection or arg_64_0._last_overriden_setting ~= arg_64_0.overriden_setting then
							arg_64_0._last_selection = arg_64_0.current_selection
							arg_64_0._last_overriden_setting = arg_64_0.overriden_setting

							local var_64_0 = Utf8.upper(arg_64_0.options_texts[arg_64_0.current_selection] or "n/a")
							local var_64_1 = arg_64_0.overriden_setting

							if var_64_1 then
								local var_64_2 = arg_64_0.disabled and arg_64_1.override_color or arg_64_1.default_color
								local var_64_3 = arg_64_1.disabled_color

								arg_64_0.selected_option = string.format("{#color(%d,%d,%d,%d)}%s {#color(%d,%d,%d,%d);strike(true)}%s{#strike(false)}", var_64_2[2], var_64_2[3], var_64_2[4], var_64_2[1], var_64_0, var_64_3[2], var_64_3[3], var_64_3[4], var_64_3[1], Utf8.upper(var_64_1))
							else
								arg_64_0.selected_option = var_64_0
							end
						end

						if arg_64_0.selected_option == nil then
							arg_64_0.selected_option = ""
						end

						return true
					end
				},
				{
					style_id = "list_style",
					pass_type = "list_pass",
					content_id = "list_content",
					content_check_function = function(arg_65_0, arg_65_1)
						return arg_65_1.active
					end,
					passes = {
						{
							pass_type = "hotspot",
							content_id = "hotspot"
						},
						{
							pass_type = "local_offset",
							offset_function = function(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
								local var_66_0 = arg_66_2.hotspot
								local var_66_1 = arg_66_1.text

								if var_66_0.on_hover_enter then
									var_66_0.is_selected = true
								elseif var_66_0.on_hover_exit then
									var_66_0.is_selected = false
								end

								if var_66_0.disabled then
									var_66_1.text_color = var_66_1.disabled_color
								elseif var_66_0.is_selected then
									var_66_1.text_color = var_66_1.hover_color
								else
									var_66_1.text_color = var_66_1.default_color
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
							content_check_function = function(arg_67_0)
								local var_67_0 = arg_67_0.hotspot

								if var_67_0.disabled then
									return false
								end

								return var_67_0.is_hover or Managers.input:is_device_active("gamepad") and var_67_0.is_selected
							end
						}
					}
				},
				{
					style_id = "selected_bg",
					pass_type = "rect",
					content_check_function = function(arg_68_0, arg_68_1)
						return arg_68_0.active
					end
				},
				{
					style_id = "selected_bg_shade",
					pass_type = "rect",
					content_check_function = function(arg_69_0, arg_69_1)
						return arg_69_0.active
					end
				},
				{
					pass_type = "rect",
					content_check_function = function(arg_70_0)
						return var_0_24
					end
				},
				{
					pass_type = "border",
					content_check_function = function(arg_71_0, arg_71_1)
						if var_0_24 then
							arg_71_1.thickness = 1
						end

						return var_0_24
					end
				},
				{
					style_id = "debug_middle_line",
					pass_type = "rect",
					content_check_function = function(arg_72_0)
						return var_0_24
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
			using_scrollbar = var_55_8,
			hotspot = {},
			highlight_hotspot = {},
			list_content = var_55_5,
			text = arg_55_0,
			selected_option = var_55_0[arg_55_2],
			current_selection = arg_55_2,
			options_texts = var_55_0,
			options_values = var_55_1,
			tooltip_text = arg_55_3,
			disabled_tooltip_text = arg_55_4 and Localize(arg_55_4),
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
					arg_55_6[1] + var_0_31[1] - var_0_0 + 28,
					arg_55_6[2] - var_55_3[2],
					arg_55_6[3] + 5
				},
				num_draws = var_55_6,
				total_draws = var_55_2,
				list_member_offset = {
					0,
					-var_55_3[2],
					0
				},
				item_styles = var_55_4
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
					var_0_31[1],
					var_0_31[2]
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
					var_0_31[1],
					var_0_31[2]
				}
			},
			hotspot = {
				offset = {
					arg_55_6[1] + var_0_31[1] - var_0_0,
					arg_55_6[2],
					arg_55_6[3]
				},
				size = {
					var_0_0,
					var_0_31[2]
				}
			},
			text = {
				font_size = 16,
				upper_case = true,
				localize = true,
				dynamic_font = true,
				font_type = "hell_shark_masked",
				offset = {
					arg_55_6[1] + 2 + var_0_11(arg_55_7),
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
					arg_55_6[1] + var_0_31[1] - 31,
					arg_55_6[2] + (var_0_31[2] / 2 - 7.5),
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
					arg_55_6[1] + var_0_31[1] - 31,
					arg_55_6[2] + (var_0_31[2] / 2 - 14) + 13,
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
					arg_55_6[1] + var_0_31[1] - 31,
					arg_55_6[2] + (var_0_31[2] / 2 - 14) - 12,
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
					arg_55_6[1] + var_0_31[1] - var_0_0 / 2,
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
					arg_55_6[1] + var_0_31[1] - (var_0_0 - 28),
					arg_55_6[2] - var_55_7,
					arg_55_6[3] + 20
				},
				size = {
					var_0_0 - 56,
					var_55_7
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
					arg_55_6[1] + var_0_31[1] - (var_0_0 - 28) - 2,
					arg_55_6[2] - (var_55_7 + 2),
					arg_55_6[3] + 19
				},
				size = {
					var_0_0 - 56 + 4,
					var_55_7 + 2
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
					arg_55_6[2] + var_0_31[2] / 2 - 1,
					arg_55_6[3] + 10
				},
				size = {
					var_0_31[1],
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
				color = var_0_9,
				size = {
					var_0_31[1],
					var_0_8
				}
			},
			size = table.clone(var_0_31),
			color = {
				50,
				255,
				255,
				255
			}
		},
		scenegraph_id = arg_55_5
	}

	if var_55_8 then
		local var_55_11 = (var_55_2 - var_55_6) / var_55_2
		local var_55_12 = var_55_7 * var_55_11
		local var_55_13 = var_55_7 - var_55_12
		local var_55_14 = var_55_13 / (var_55_2 - var_55_6) - 1
		local var_55_15 = {
			style_id = "thumbnail",
			pass_type = "hotspot",
			content_id = "thumbnail_hotspot",
			content_check_function = function(arg_73_0)
				return arg_73_0.parent.active
			end
		}
		local var_55_16 = {
			style_id = "thumbnail",
			pass_type = "held",
			content_id = "thumbnail_hotspot",
			content_check_function = function(arg_74_0)
				return arg_74_0.parent.active
			end,
			held_function = function(arg_75_0, arg_75_1, arg_75_2, arg_75_3)
				if Managers.input:is_device_active("gamepad") then
					return
				end

				local var_75_0 = arg_75_2.thumbnail_fraction
				local var_75_1 = arg_75_2.thumbnail_length
				local var_75_2 = arg_75_2.scroll_length
				local var_75_3 = arg_75_1.parent.offset
				local var_75_4 = arg_75_1.default_offset_y
				local var_75_5 = arg_75_1.offset
				local var_75_6 = 2
				local var_75_7 = arg_75_3:get("cursor")
				local var_75_8 = UIInverseScaleVectorToResolution(var_75_7)[var_75_6]

				if not arg_75_2.cursor_y then
					arg_75_2.cursor_y = var_75_8
					arg_75_2.parent.dragging = true
				end

				local var_75_9 = var_75_8 - arg_75_2.cursor_y

				arg_75_2.cursor_y = var_75_8

				local var_75_10 = 0
				local var_75_11 = var_75_2
				local var_75_12 = var_75_4 - var_75_5[var_75_6] - var_75_9
				local var_75_13 = math.clamp(var_75_12, var_75_10, var_75_11) / var_75_11
				local var_75_14 = arg_75_1.parent.list_style
				local var_75_15 = var_75_14.num_draws
				local var_75_16 = 1 / (var_75_14.total_draws - var_75_15)

				var_75_14.start_index = math.floor(var_75_13 / var_75_16) + 1
				arg_75_2.scroll_progress = var_75_13
			end,
			release_function = function(arg_76_0, arg_76_1, arg_76_2, arg_76_3)
				arg_76_2.cursor_y = nil
				arg_76_2.parent.dragging = nil
			end
		}
		local var_55_17 = {
			style_id = "thumbnail",
			texture_id = "rect_masked",
			pass_type = "texture",
			content_check_function = function(arg_77_0, arg_77_1)
				return arg_77_0.active
			end,
			content_change_function = function(arg_78_0, arg_78_1)
				local var_78_0 = arg_78_1.default_offset_y
				local var_78_1 = arg_78_1.offset
				local var_78_2 = arg_78_1.step_size
				local var_78_3 = arg_78_1.size
				local var_78_4 = 2
				local var_78_5 = arg_78_0.thumbnail_hotspot
				local var_78_6 = var_78_5.scroll_progress
				local var_78_7 = var_78_5.scroll_length
				local var_78_8 = var_78_5.thumbnail_length
				local var_78_9 = 0
				local var_78_10 = var_78_7 - var_78_8

				var_78_1[var_78_4] = var_78_0 - var_78_7 * var_78_6
			end
		}
		local var_55_18 = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			step_size = var_55_14,
			default_offset_y = arg_55_6[2] - var_55_12,
			offset = {
				arg_55_6[1] + var_0_31[1] - 50,
				arg_55_6[2] - var_55_12,
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
				var_55_12
			},
			texture_size = {
				5,
				var_55_12
			}
		}

		var_55_10.element.passes[#var_55_10.element.passes + 1] = var_55_17
		var_55_10.element.passes[#var_55_10.element.passes + 1] = var_55_16
		var_55_10.element.passes[#var_55_10.element.passes + 1] = var_55_15
		var_55_10.content.thumbnail_hotspot = {
			scroll_progress = 0,
			thumbnail_fraction = var_55_11,
			thumbnail_length = var_55_12,
			scroll_length = var_55_13,
			scenegraph_id = arg_55_5
		}
		var_55_10.style.thumbnail = var_55_18
	end

	return UIWidget.init(var_55_10)
end

local var_0_33 = {
	var_0_21 - 100,
	30
}

local function var_0_34(arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4, arg_79_5, arg_79_6, arg_79_7)
	local var_79_0 = {}
	local var_79_1 = {}
	local var_79_2 = #arg_79_1

	for iter_79_0 = 1, var_79_2 do
		var_79_0[iter_79_0] = arg_79_1[iter_79_0].text
		var_79_1[iter_79_0] = arg_79_1[iter_79_0].value
	end

	arg_79_6[2] = arg_79_6[2] - var_0_33[2]

	local var_79_3 = {
		element = {
			passes = {
				{
					pass_type = "local_offset",
					offset_function = function(arg_80_0, arg_80_1, arg_80_2, arg_80_3)
						if arg_80_2._last_selection ~= arg_80_2.current_selection or arg_80_2._last_overriden_setting ~= arg_80_2.overriden_setting then
							arg_80_2._last_selection = arg_80_2.current_selection
							arg_80_2._last_overriden_setting = arg_80_2.overriden_setting

							local var_80_0 = Utf8.upper(arg_80_2.options_texts[arg_80_2.current_selection] or "n/a")
							local var_80_1 = arg_80_2.overriden_setting

							if var_80_1 then
								local var_80_2 = arg_80_1.selection_text.override_color
								local var_80_3 = arg_80_1.selection_text.disabled_color

								arg_80_2.selection_text = string.format("{#color(%d,%d,%d,%d)}%s {#color(%d,%d,%d,%d);strike(true)}%s{#strike(false)}", var_80_2[2], var_80_2[3], var_80_2[4], var_80_2[1], var_80_0, var_80_3[2], var_80_3[3], var_80_3[4], var_80_3[1], Utf8.upper(var_80_1))
							else
								arg_80_2.selection_text = var_80_0
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
					content_check_function = function(arg_81_0)
						return not arg_81_0.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "highlight_texture",
					texture_id = "highlight_texture",
					content_check_function = function(arg_82_0)
						return arg_82_0.is_highlighted
					end
				},
				{
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function(arg_83_0)
						if not arg_83_0.highlight_hotspot.is_hover or Managers.input:is_device_active("gamepad") then
							return false
						end

						if not arg_83_0.disabled then
							return arg_83_0.tooltip_text
						else
							return not arg_83_0.disabled_tooltip_text
						end
					end
				},
				{
					style_id = "disabled_tooltip_text",
					pass_type = "option_tooltip",
					text_id = "disabled_tooltip_text",
					content_check_function = function(arg_84_0)
						if not arg_84_0.disabled or not arg_84_0.highlight_hotspot.is_hover or Managers.input:is_device_active("gamepad") then
							return false
						end

						if arg_84_0.overriden_reason then
							arg_84_0.disabled_tooltip_text = arg_84_0.overriden_reason
						end

						if arg_84_0.disabled_tooltip_text then
							return true
						end
					end
				},
				{
					pass_type = "local_offset",
					offset_function = function(arg_85_0, arg_85_1, arg_85_2, arg_85_3)
						local var_85_0 = arg_85_2.left_hotspot
						local var_85_1 = arg_85_2.right_hotspot

						if var_85_0.on_hover_enter then
							local var_85_2 = arg_85_2.on_hover_enter_callback

							if var_85_2 then
								var_85_2("left_arrow_hover")
							end
						end

						if var_85_0.on_hover_exit then
							local var_85_3 = arg_85_2.on_hover_exit_callback

							if var_85_3 then
								var_85_3("left_arrow_hover")
							end
						end

						if var_85_0.on_release then
							local var_85_4 = arg_85_2.on_pressed_callback

							if var_85_4 then
								var_85_4("left_arrow")
								var_85_4("left_arrow_hover")
							end
						end

						if var_85_1.on_hover_enter then
							local var_85_5 = arg_85_2.on_hover_enter_callback

							if var_85_5 then
								var_85_5("right_arrow_hover")
							end
						end

						if var_85_1.on_hover_exit then
							local var_85_6 = arg_85_2.on_hover_exit_callback

							if var_85_6 then
								var_85_6("right_arrow_hover")
							end
						end

						if var_85_1.on_release then
							local var_85_7 = arg_85_2.on_pressed_callback

							if var_85_7 then
								var_85_7("right_arrow")
								var_85_7("right_arrow_hover")
							end
						end

						if arg_85_2.disabled then
							arg_85_1.selection_text.text_color = arg_85_1.selection_text.disabled_color
						elseif var_85_0.is_hover or var_85_1.is_hover then
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
					content_change_function = function(arg_86_0, arg_86_1)
						if arg_86_0.disabled then
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
					content_check_function = function(arg_87_0)
						return not arg_87_0.disabled
					end
				},
				{
					style_id = "right_arrow_hotspot",
					pass_type = "hotspot",
					content_id = "right_hotspot",
					content_check_function = function(arg_88_0)
						return not arg_88_0.disabled
					end
				},
				{
					texture_id = "texture_id",
					style_id = "left_arrow",
					pass_type = "texture",
					content_id = "arrow",
					content_check_function = function(arg_89_0)
						return not arg_89_0.parent.disabled
					end
				},
				{
					texture_id = "texture_id",
					style_id = "right_arrow",
					pass_type = "texture_uv",
					content_id = "arrow",
					content_check_function = function(arg_90_0)
						return not arg_90_0.parent.disabled
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
					content_check_function = function(arg_91_0)
						local var_91_0 = arg_91_0.selection_text

						return var_91_0 and var_91_0 ~= ""
					end
				},
				{
					pass_type = "rect",
					content_check_function = function(arg_92_0)
						return var_0_24
					end
				},
				{
					pass_type = "border",
					content_check_function = function(arg_93_0, arg_93_1)
						if var_0_24 then
							arg_93_1.thickness = 1
						end

						return var_0_24
					end
				},
				{
					style_id = "debug_middle_line",
					pass_type = "rect",
					content_check_function = function(arg_94_0)
						return var_0_24
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
			disabled_tooltip_text = arg_79_4 and Localize(arg_79_4),
			current_selection = arg_79_2,
			options_texts = var_79_0,
			options_values = var_79_1,
			num_options = var_79_2,
			hotspot_content_ids = {
				"left_hotspot",
				"right_hotspot"
			}
		},
		style = {
			offset = table.clone(arg_79_6),
			size = table.clone(var_0_33),
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
					var_0_33[1],
					var_0_33[2]
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
					var_0_33[1],
					var_0_33[2]
				}
			},
			left_arrow = {
				masked = true,
				offset = {
					arg_79_6[1] + var_0_33[1] - var_0_0,
					arg_79_6[2] + (var_0_33[2] / 2 - 13.5),
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
					arg_79_6[1] + var_0_33[1] - var_0_0 + 6,
					arg_79_6[2] + (var_0_33[2] / 2 - 17.5),
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
					arg_79_6[1] + var_0_33[1] - var_0_0,
					arg_79_6[2] + (var_0_33[2] / 2 - 13.5),
					arg_79_6[3]
				},
				size = {
					var_0_0 / 2,
					27
				}
			},
			right_arrow = {
				masked = true,
				offset = {
					arg_79_6[1] + var_0_33[1] - 19,
					arg_79_6[2] + (var_0_33[2] / 2 - 13.5),
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
					arg_79_6[1] + var_0_33[1] - 30 - 5,
					arg_79_6[2] + (var_0_33[2] / 2 - 17.5),
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
					arg_79_6[1] + var_0_33[1] - var_0_0 / 2,
					arg_79_6[2] + (var_0_33[2] / 2 - 13.5),
					arg_79_6[3]
				},
				size = {
					var_0_0 / 2,
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
					arg_79_6[1] + 2 + var_0_11(arg_79_7),
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
					arg_79_6[1] + var_0_33[1] - var_0_0 / 2,
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
					arg_79_6[2] + var_0_33[2] / 2 - 1,
					arg_79_6[3] + 10
				},
				size = {
					var_0_33[1],
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
				color = var_0_9,
				size = {
					var_0_33[1],
					var_0_8
				}
			},
			input_field_background = {
				offset = {
					arg_79_6[1] + var_0_33[1] - var_0_0,
					arg_79_6[2],
					arg_79_6[3]
				},
				color = var_0_1,
				size = {
					var_0_0,
					var_0_33[2]
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

	return UIWidget.init(var_79_3)
end

local var_0_35 = {
	var_0_21 - 100,
	50
}

local function var_0_36(arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4, arg_95_5)
	arg_95_5[2] = arg_95_5[2] - var_0_35[2]

	local var_95_0 = {
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
					content_check_function = function(arg_96_0)
						return var_0_24
					end
				},
				{
					pass_type = "border",
					content_check_function = function(arg_97_0, arg_97_1)
						if var_0_24 then
							arg_97_1.thickness = 1
						end

						return var_0_24
					end
				},
				{
					style_id = "debug_middle_line",
					pass_type = "rect",
					content_check_function = function(arg_98_0)
						return var_0_24
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
			size = table.clone(var_0_35),
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
				size = table.clone(var_0_35)
			},
			debug_middle_line = {
				offset = {
					arg_95_5[1],
					arg_95_5[2] + var_0_35[2] / 2 - 1,
					arg_95_5[3] + 10
				},
				size = {
					var_0_35[1],
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
				color = var_0_9,
				size = {
					var_0_35[1],
					var_0_8
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

	return UIWidget.init(var_95_0)
end

local var_0_37 = {
	var_0_21 - 100,
	50
}

local function var_0_38(arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6)
	arg_99_6[2] = arg_99_6[2] - var_0_37[2]

	local var_99_0 = {
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
					content_check_function = function(arg_100_0)
						return arg_100_0.is_highlighted
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_101_0)
						return not arg_101_0.hotspot.is_hover
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_102_0)
						return arg_102_0.hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "bottom_edge",
					texture_id = "rect_masked"
				},
				{
					pass_type = "rect",
					content_check_function = function(arg_103_0)
						return var_0_24
					end
				},
				{
					pass_type = "border",
					content_check_function = function(arg_104_0, arg_104_1)
						if var_0_24 then
							arg_104_1.thickness = 1
						end

						return var_0_24
					end
				},
				{
					style_id = "debug_middle_line",
					pass_type = "rect",
					content_check_function = function(arg_105_0)
						return var_0_24
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
			size = table.clone(var_0_37),
			highlight_texture = {
				masked = true,
				offset = {
					arg_99_6[1],
					arg_99_6[2],
					arg_99_6[3]
				},
				color = Colors.get_table("white"),
				size = {
					var_0_37[1],
					var_0_37[2]
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
				size = table.clone(var_0_37)
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
				size = table.clone(var_0_37)
			},
			debug_middle_line = {
				offset = {
					arg_99_6[1],
					arg_99_6[2] + var_0_37[2] / 2 - 1,
					arg_99_6[3] + 10
				},
				size = {
					var_0_37[1],
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
				color = var_0_9,
				size = {
					var_0_37[1],
					var_0_8
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

	return UIWidget.init(var_99_0)
end

local var_0_39 = {
	var_0_21 - 100,
	50
}

local function var_0_40(arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4, arg_106_5, arg_106_6)
	local var_106_0 = {}
	local var_106_1 = {}
	local var_106_2 = #arg_106_2

	for iter_106_0 = 1, var_106_2 do
		var_106_0[iter_106_0] = arg_106_2[iter_106_0].text
		var_106_1[iter_106_0] = arg_106_2[iter_106_0].value
	end

	arg_106_6[2] = arg_106_6[2] - var_0_39[2]

	local var_106_3 = {}
	local var_106_4 = {
		passes = var_106_3
	}
	local var_106_5 = {}
	local var_106_6 = {}
	local var_106_7 = {
		element = var_106_4,
		content = var_106_5,
		style = var_106_6,
		scenegraph_id = arg_106_5
	}

	var_106_3[#var_106_3 + 1] = {
		pass_type = "local_offset",
		offset_function = function(arg_107_0, arg_107_1, arg_107_2, arg_107_3)
			local var_107_0 = arg_107_2.current_selection

			if var_107_0 ~= arg_107_2.local_selection then
				arg_107_2.local_selection = var_107_0

				local var_107_1 = arg_107_2.num_options

				for iter_107_0 = 1, var_107_1 do
					local var_107_2 = "option_" .. iter_107_0
					local var_107_3 = "option_text_" .. iter_107_0
					local var_107_4 = iter_107_0 == var_107_0

					arg_107_2[var_107_2].is_selected = var_107_4
					arg_107_1[var_107_3].text_color = var_107_4 and arg_107_1[var_107_3].highlight_color or arg_107_1[var_107_3].default_color
				end
			end
		end
	}
	var_106_3[#var_106_3 + 1] = {
		pass_type = "texture",
		style_id = "highlight_texture",
		texture_id = "highlight_texture",
		content_check_function = function(arg_108_0)
			return arg_108_0.is_highlighted
		end
	}
	var_106_3[#var_106_3 + 1] = {
		pass_type = "hotspot",
		content_id = "highlight_hotspot"
	}
	var_106_3[#var_106_3 + 1] = {
		pass_type = "option_tooltip",
		text_id = "tooltip_text",
		content_check_function = function(arg_109_0)
			return arg_109_0.tooltip_text and arg_109_0.highlight_hotspot.is_hover and not Managers.input:is_device_active("gamepad")
		end
	}
	var_106_3[#var_106_3 + 1] = {
		pass_type = "texture",
		style_id = "bottom_edge",
		texture_id = "rect_masked"
	}
	var_106_3[#var_106_3 + 1] = {
		style_id = "text",
		pass_type = "text",
		text_id = "text"
	}
	var_106_3[#var_106_3 + 1] = {
		pass_type = "rect",
		content_check_function = function(arg_110_0)
			return var_0_24
		end
	}
	var_106_3[#var_106_3 + 1] = {
		pass_type = "border",
		content_check_function = function(arg_111_0, arg_111_1)
			if var_0_24 then
				arg_111_1.thickness = 1
			end

			return var_0_24
		end
	}
	var_106_3[#var_106_3 + 1] = {
		style_id = "debug_middle_line",
		pass_type = "rect",
		content_check_function = function(arg_112_0)
			return var_0_24
		end
	}
	var_106_5.text = arg_106_1
	var_106_5.tooltip_text = arg_106_4
	var_106_5.current_selection = arg_106_3
	var_106_5.options_texts = var_106_0
	var_106_5.options_values = var_106_1
	var_106_5.num_options = var_106_2
	var_106_5.highlight_hotspot = {
		allow_multi_hover = true
	}
	var_106_5.highlight_texture = "playerlist_hover"
	var_106_5.rect_masked = "rect_masked"

	local var_106_8 = {}

	var_106_5.hotspot_content_ids = var_106_8
	var_106_6.offset = table.clone(arg_106_6)
	var_106_6.size = table.clone(var_0_39)
	var_106_6.highlight_texture = {
		upper_case = true,
		masked = true,
		offset = {
			arg_106_6[1],
			arg_106_6[2],
			arg_106_6[3]
		},
		color = Colors.get_table("white"),
		size = {
			var_0_39[1],
			var_0_39[2]
		}
	}
	var_106_6.tooltip_text = {
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
	var_106_6.text = {
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
	var_106_6.debug_middle_line = {
		offset = {
			arg_106_6[1],
			arg_106_6[2] + var_0_39[2] / 2 - 1,
			arg_106_6[3] + 10
		},
		size = {
			var_0_39[1],
			2
		},
		color = {
			200,
			0,
			255,
			0
		}
	}
	var_106_6.color = {
		50,
		255,
		255,
		255
	}
	var_106_6.bottom_edge = {
		offset = {
			arg_106_6[1],
			arg_106_6[2],
			arg_106_6[3] + 1
		},
		color = var_0_9,
		size = {
			var_0_39[1],
			var_0_8
		}
	}

	local var_106_9 = 20
	local var_106_10 = 20
	local var_106_11 = 120
	local var_106_12 = arg_106_6[1] + var_0_39[1]
	local var_106_13 = -var_106_9

	for iter_106_1 = 1, var_106_2 do
		local var_106_14 = arg_106_2[iter_106_1].text
		local var_106_15 = "option_text_" .. iter_106_1

		var_106_3[#var_106_3 + 1] = {
			pass_type = "text",
			style_id = var_106_15,
			text_id = var_106_15,
			content_change_function = function(arg_113_0, arg_113_1)
				local var_113_0 = arg_113_0["option_" .. iter_106_1]

				if not var_113_0.is_selected then
					if var_113_0.is_hover then
						arg_113_1.text_color = Colors.get_color_table_with_alpha("font_default", 255)
					else
						arg_113_1.text_color = Colors.get_color_table_with_alpha("font_title", 255)
					end
				end
			end
		}
		var_106_6[var_106_15] = {
			upper_case = true,
			horizontal_alignment = "center",
			font_size = 22,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_masked",
			size = {
				500,
				var_0_39[2]
			},
			offset = {
				var_106_12 - var_106_13,
				arg_106_6[2],
				arg_106_6[3] + 1
			},
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			highlight_color = Colors.get_color_table_with_alpha("black", 255),
			default_color = Colors.get_color_table_with_alpha("font_title", 255)
		}
		var_106_5[var_106_15] = var_106_14

		if var_106_6[var_106_15].upper_case then
			var_106_14 = TextToUpper(var_106_14)
		end

		local var_106_16, var_106_17 = UIFontByResolution(var_106_6[var_106_15])
		local var_106_18, var_106_19, var_106_20 = UIRenderer.text_size(arg_106_0, var_106_14, var_106_16[1], var_106_17)
		local var_106_21 = math.max(var_106_18 + var_106_10, var_106_11)

		var_106_13 = var_106_13 + var_106_21 + var_106_9
		var_106_6[var_106_15].size[1] = var_106_21
		var_106_6[var_106_15].offset[1] = var_106_12 - var_106_13

		local var_106_22 = "option_" .. iter_106_1

		var_106_3[#var_106_3 + 1] = {
			pass_type = "hotspot",
			style_id = var_106_22,
			content_id = var_106_22
		}
		var_106_5[var_106_22] = {}
		var_106_3[#var_106_3 + 1] = {
			texture_id = "rect_texture",
			pass_type = "texture",
			style_id = var_106_22,
			content_check_function = function(arg_114_0)
				return arg_114_0[var_106_22].is_selected
			end,
			content_change_function = function(arg_115_0, arg_115_1)
				local var_115_0 = arg_115_0["option_" .. iter_106_1]

				if var_115_0.is_selected then
					if var_115_0.is_hover then
						arg_115_1.color = Colors.get_color_table_with_alpha("font_default", 255)
					else
						arg_115_1.color = Colors.get_color_table_with_alpha("font_title", 255)
					end
				end
			end
		}
		var_106_5.rect_texture = "rect_masked"
		var_106_6[var_106_22] = {
			size = {
				var_106_21,
				var_0_39[2] - 10
			},
			offset = {
				var_106_12 - var_106_13,
				arg_106_6[2] + 5,
				arg_106_6[3]
			},
			color = Colors.get_color_table_with_alpha("font_title", 255)
		}
		var_106_8[#var_106_8 + 1] = var_106_22
	end

	return UIWidget.init(var_106_7)
end

local var_0_41 = {
	var_0_21 - 100,
	30
}

local function var_0_42(arg_116_0, arg_116_1, arg_116_2, arg_116_3, arg_116_4, arg_116_5, arg_116_6)
	arg_116_6[2] = arg_116_6[2] - var_0_41[2]

	local var_116_0 = {
		element = {
			passes = {
				{
					style_id = "hotspot_1",
					pass_type = "hotspot",
					content_id = "hotspot_1",
					content_check_function = function(arg_117_0)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "hotspot_2",
					pass_type = "hotspot",
					content_id = "hotspot_2",
					content_check_function = function(arg_118_0)
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
					content_check_function = function(arg_119_0)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "texture",
					style_id = "highlight_texture",
					texture_id = "highlight_texture",
					content_check_function = function(arg_120_0)
						return arg_120_0.is_highlighted and not Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "selected_key_1",
					pass_type = "text",
					text_id = "selected_key_1",
					content_check_function = function(arg_121_0)
						return not arg_121_0.active_1
					end,
					content_change_function = function(arg_122_0, arg_122_1)
						if arg_122_0.active_1 or arg_122_0.hotspot_1.is_hover then
							arg_122_1.text_color = arg_122_1.hover_color
						elseif arg_122_0.is_unassigned_1 then
							arg_122_1.text_color = arg_122_1.unassigned_color
						else
							arg_122_1.text_color = arg_122_1.default_color
						end

						if arg_122_0.active_1 then
							arg_122_0.active_t = arg_122_0.active_t + ui_renderer.dt * 2.5

							local var_122_0 = math.sirp(0, 1, arg_122_0.active_t)

							arg_122_1.parent.selected_rect_1.color[1] = var_122_0 * 255
						else
							arg_122_1.parent.selected_rect_1.color[1] = 255
						end
					end
				},
				{
					style_id = "selected_key_2",
					pass_type = "text",
					text_id = "selected_key_2",
					content_check_function = function(arg_123_0)
						return not arg_123_0.active_2
					end,
					content_change_function = function(arg_124_0, arg_124_1)
						if arg_124_0.active_2 or arg_124_0.hotspot_2.is_hover then
							arg_124_1.text_color = arg_124_1.hover_color
						elseif arg_124_0.is_unassigned_2 then
							arg_124_1.text_color = arg_124_1.unassigned_color
						else
							arg_124_1.text_color = arg_124_1.default_color
						end

						if arg_124_0.active_2 then
							arg_124_0.active_t = arg_124_0.active_t + ui_renderer.dt * 2.5

							local var_124_0 = math.sirp(0, 1, arg_124_0.active_t)

							arg_124_1.parent.selected_rect_2.color[1] = var_124_0 * 255
						else
							arg_124_1.parent.selected_rect_2.color[1] = 255
						end
					end
				},
				{
					style_id = "selected_rect_1",
					pass_type = "rect",
					content_check_function = function(arg_125_0)
						return arg_125_0.active_1
					end
				},
				{
					style_id = "selected_rect_2",
					pass_type = "rect",
					content_check_function = function(arg_126_0)
						return arg_126_0.active_2
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
					arg_116_6[1] + var_0_41[1] - 2 * (20 + var_0_0 - 2),
					arg_116_6[2] + var_0_41[2] / 2 - (var_0_41[2] - 10) / 2,
					arg_116_6[3] + 2
				},
				area_size = {
					var_0_0 - 2,
					var_0_41[2] - 10
				}
			},
			hotspot_2 = {
				offset = {
					arg_116_6[1] + var_0_41[1] - (var_0_0 - 2),
					arg_116_6[2] + var_0_41[2] / 2 - (var_0_41[2] - 10) / 2,
					arg_116_6[3] + 2
				},
				area_size = {
					var_0_0 - 2,
					var_0_41[2] - 10
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
					var_0_41[1],
					var_0_41[2]
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
					arg_116_6[1] + var_0_41[1] - 2 * (20 + var_0_0),
					arg_116_6[2] + 2,
					arg_116_6[3] + 5
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				hover_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				unassigned_color = Colors.get_color_table_with_alpha("dim_gray", 255),
				size = {
					var_0_0,
					var_0_41[2] - 10
				}
			},
			selected_key_2 = {
				upper_case = true,
				horizontal_alignment = "center",
				font_size = 16,
				dynamic_font = true,
				font_type = "hell_shark_masked",
				offset = {
					arg_116_6[1] + var_0_41[1] - var_0_0,
					arg_116_6[2] + 2,
					arg_116_6[3] + 5
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				hover_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				unassigned_color = Colors.get_color_table_with_alpha("dim_gray", 255),
				size = {
					var_0_0,
					var_0_41[2] - 10
				}
			},
			selected_rect_1 = {
				offset = {
					arg_116_6[1] + var_0_41[1] - 2 * (20 + var_0_0 - 2),
					arg_116_6[2] + var_0_41[2] / 2 - (var_0_41[2] - 10) / 2,
					arg_116_6[3] + 2
				},
				size = {
					var_0_0 - 2,
					var_0_41[2] - 10
				},
				color = Colors.get_color_table_with_alpha("font_default", 100)
			},
			selected_rect_2 = {
				offset = {
					arg_116_6[1] + var_0_41[1] - (var_0_0 - 2),
					arg_116_6[2] + var_0_41[2] / 2 - (var_0_41[2] - 10) / 2,
					arg_116_6[3] + 2
				},
				size = {
					var_0_0 - 2,
					var_0_41[2] - 10
				},
				color = Colors.get_color_table_with_alpha("font_default", 100)
			},
			debug_middle_line = {
				offset = {
					arg_116_6[1],
					arg_116_6[2] + var_0_41[2] / 2 - 1,
					arg_116_6[3] + 10
				},
				size = {
					var_0_41[1],
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
				color = var_0_9,
				size = {
					var_0_41[1],
					var_0_8
				}
			},
			input_field_1_background_bevel = {
				offset = {
					arg_116_6[1] + var_0_41[1] - 2 * (20 + var_0_0),
					arg_116_6[2] + var_0_41[2] / 2 - (var_0_41[2] - 10) / 2,
					arg_116_6[3] + 1
				},
				color = var_0_1,
				size = {
					var_0_0,
					var_0_41[2] - 10 + 2
				}
			},
			input_field_1_background = {
				offset = {
					arg_116_6[1] + var_0_41[1] - 2 * (20 + var_0_0 - 2),
					arg_116_6[2] + var_0_41[2] / 2 - (var_0_41[2] - 10) / 2,
					arg_116_6[3] + 2
				},
				color = {
					255,
					10,
					10,
					10
				},
				size = {
					var_0_0 - 2,
					var_0_41[2] - 10
				}
			},
			input_field_2_background_bevel = {
				offset = {
					arg_116_6[1] + var_0_41[1] - var_0_0,
					arg_116_6[2] + var_0_41[2] / 2 - (var_0_41[2] - 10) / 2,
					arg_116_6[3] + 1
				},
				color = var_0_1,
				size = {
					var_0_0,
					var_0_41[2] - 10 + 2
				}
			},
			input_field_2_background = {
				offset = {
					arg_116_6[1] + var_0_41[1] - (var_0_0 - 2),
					arg_116_6[2] + var_0_41[2] / 2 - (var_0_41[2] - 10) / 2,
					arg_116_6[3] + 2
				},
				color = {
					255,
					10,
					10,
					10
				},
				size = {
					var_0_0 - 2,
					var_0_41[2] - 10
				}
			},
			size = table.clone(var_0_41),
			color = {
				50,
				255,
				255,
				255
			}
		},
		scenegraph_id = arg_116_5
	}

	return UIWidget.init(var_116_0)
end

local var_0_43 = var_0_21 - 100
local var_0_44 = 28

local function var_0_45(arg_127_0, arg_127_1, arg_127_2, arg_127_3, arg_127_4, arg_127_5, arg_127_6, arg_127_7)
	local var_127_0 = #arg_127_2
	local var_127_1 = 10
	local var_127_2 = {
		var_0_43,
		var_127_0 * arg_127_4[2] + var_127_1
	}
	local var_127_3 = var_127_2[2] - var_127_1
	local var_127_4 = {
		35,
		(var_127_2[2] - var_127_1) / 2 - 2
	}

	arg_127_7[2] = arg_127_7[2] - var_127_2[2]

	local var_127_5 = Colors.get_color_table_with_alpha("font_default", 255)
	local var_127_6 = Colors.get_color_table_with_alpha("font_default", 100)
	local var_127_7 = {
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
					content_check_function = function(arg_128_0, arg_128_1)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "texture",
					style_id = "background_fg",
					texture_id = "rect_masked",
					content_check_function = function(arg_129_0, arg_129_1)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "texture",
					style_id = "bottom_edge",
					texture_id = "rect_masked",
					content_check_function = function(arg_130_0, arg_130_1)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "texture",
					style_id = "arrow_buttons_edge_horizontal",
					texture_id = "rect_masked",
					content_check_function = function(arg_131_0, arg_131_1)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					pass_type = "texture",
					style_id = "arrow_buttons_edge_vertical",
					texture_id = "rect_masked",
					content_check_function = function(arg_132_0, arg_132_1)
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
					content_check_function = function(arg_133_0)
						return arg_133_0.is_highlighted and Managers.input:is_device_active("gamepad") and not arg_133_0.active
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function(arg_134_0)
						return arg_134_0.tooltip_text and arg_134_0.highlight_hotspot.is_hover and not Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "down_arrow_background",
					pass_type = "hotspot",
					content_id = "down_hotspot",
					content_check_function = function(arg_135_0)
						return arg_135_0.active
					end
				},
				{
					style_id = "up_arrow_background",
					pass_type = "hotspot",
					content_id = "up_hotspot",
					content_check_function = function(arg_136_0)
						return arg_136_0.active
					end
				},
				{
					pass_type = "texture",
					style_id = "down_arrow_background",
					texture_id = "rect_masked",
					content_check_function = function(arg_137_0)
						if Managers.input:is_device_active("gamepad") then
							return false
						end

						local var_137_0 = arg_137_0.down_hotspot

						return var_137_0.active and var_137_0.is_hover
					end
				},
				{
					texture_id = "texture_id",
					style_id = "down_arrow",
					pass_type = "texture",
					content_id = "arrow",
					content_check_function = function(arg_138_0, arg_138_1)
						if Managers.input:is_device_active("gamepad") then
							return false
						end

						local var_138_0 = arg_138_0.parent
						local var_138_1 = arg_138_1.parent

						arg_138_1.color = var_138_0.down_hotspot.active and var_138_1.enabled_color or var_138_1.disabled_color

						return true
					end
				},
				{
					pass_type = "texture",
					style_id = "up_arrow_background",
					texture_id = "rect_masked",
					content_check_function = function(arg_139_0)
						if Managers.input:is_device_active("gamepad") then
							return false
						end

						local var_139_0 = arg_139_0.up_hotspot

						return var_139_0.active and var_139_0.is_hover
					end
				},
				{
					texture_id = "texture_id",
					style_id = "up_arrow",
					pass_type = "texture_uv",
					content_id = "arrow",
					content_check_function = function(arg_140_0, arg_140_1)
						if Managers.input:is_device_active("gamepad") then
							return false
						end

						local var_140_0 = arg_140_0.parent
						local var_140_1 = arg_140_1.parent

						arg_140_1.color = var_140_0.up_hotspot.active and var_140_1.enabled_color or var_140_1.disabled_color

						return true
					end
				},
				{
					texture_id = "texture_id",
					style_id = "down_arrow_hover",
					pass_type = "texture",
					content_id = "arrow_hover",
					content_check_function = function(arg_141_0)
						local var_141_0 = arg_141_0.parent.down_hotspot

						return var_141_0.active and var_141_0.is_hover
					end
				},
				{
					texture_id = "texture_id",
					style_id = "up_arrow_hover",
					pass_type = "texture_uv",
					content_id = "arrow_hover",
					content_check_function = function(arg_142_0)
						local var_142_0 = arg_142_0.parent.up_hotspot

						return var_142_0.active and var_142_0.is_hover
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
							content_check_function = function(arg_143_0)
								return not arg_143_0.hotspot.is_hover and not arg_143_0.hotspot.is_selected
							end,
							content_change_function = arg_127_5
						},
						{
							style_id = "highlight_texture",
							texture_id = "highlight_texture",
							pass_type = "texture",
							content_check_function = function(arg_144_0, arg_144_1, arg_144_2)
								return arg_144_0.hotspot.is_hover or arg_144_0.hotspot.is_selected
							end,
							content_change_function = arg_127_5
						},
						{
							style_id = "background_highlight_texture",
							texture_id = "background_highlight_texture",
							pass_type = "texture",
							content_check_function = function(arg_145_0, arg_145_1, arg_145_2)
								return arg_145_0.hotspot.is_hover and not arg_145_0.hotspot.is_selected
							end,
							content_change_function = arg_127_5
						},
						{
							style_id = "background_selected_texture",
							texture_id = "background_highlight_texture",
							pass_type = "texture",
							content_check_function = function(arg_146_0, arg_146_1, arg_146_2)
								return arg_146_0.hotspot.is_selected
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
			size = table.clone(var_127_2),
			color = {
				50,
				255,
				255,
				255
			},
			enabled_color = var_127_5,
			disabled_color = var_127_6,
			background = {
				offset = {
					arg_127_7[1] + 7 * var_127_2[1] / 10,
					arg_127_7[2] + var_127_1 / 2,
					arg_127_7[3]
				},
				color = var_0_1,
				size = {
					3 * var_127_2[1] / 10,
					var_127_3
				}
			},
			background_fg = {
				offset = {
					arg_127_7[1] + 7 * var_127_2[1] / 10 + 2,
					arg_127_7[2] + var_127_1 / 2,
					arg_127_7[3] + 1
				},
				color = {
					255,
					10,
					10,
					10
				},
				size = {
					3 * var_127_2[1] / 10 - 2,
					var_127_3 - 2
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
					arg_127_7[2] + var_127_2[2] - (var_0_44 + 4),
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
					arg_127_7[2] + var_127_2[2] - var_0_44 - 50,
					arg_127_7[3] + 20
				}
			},
			up_arrow = {
				masked = true,
				offset = {
					arg_127_7[1] + var_127_2[1] - (var_127_4[1] + 31) / 2,
					arg_127_7[2] + 1.5 * var_127_4[2] - 7.5 + var_127_1 / 2,
					arg_127_7[3] + 2
				},
				size = {
					31,
					15
				},
				color = var_127_5
			},
			up_arrow_hover = {
				masked = true,
				offset = {
					arg_127_7[1] + var_127_2[1] - (var_127_4[1] + 31) / 2,
					arg_127_7[2] + 1.5 * var_127_4[2] - 27 + var_127_1 / 2,
					arg_127_7[3] + 1
				},
				size = {
					31,
					28
				},
				color = var_127_5
			},
			up_arrow_background = {
				offset = {
					arg_127_7[1] + var_127_2[1] - var_127_4[1],
					arg_127_7[2] + var_127_4[2] + 2 + var_127_1 / 2,
					arg_127_7[3] + 1
				},
				color = {
					200,
					20,
					20,
					20
				},
				size = var_127_4
			},
			arrow_buttons_edge_horizontal = {
				offset = {
					arg_127_7[1] + var_127_2[1] - var_127_4[1] - 2,
					arg_127_7[2] + var_127_4[2] + var_127_1 / 2,
					arg_127_7[3] + 1
				},
				color = var_0_1,
				size = {
					var_127_4[1],
					2
				}
			},
			arrow_buttons_edge_vertical = {
				offset = {
					arg_127_7[1] + var_127_2[1] - var_127_4[1] - 2,
					arg_127_7[2] + var_127_1 / 2,
					arg_127_7[3] + 1
				},
				color = var_0_1,
				size = {
					2,
					var_127_3
				}
			},
			down_arrow = {
				masked = true,
				offset = {
					arg_127_7[1] + var_127_2[1] - (var_127_4[1] + 31) / 2,
					arg_127_7[2] + (var_127_4[2] - 15) / 2 + var_127_1 / 2,
					arg_127_7[3] + 2
				},
				size = {
					31,
					15
				},
				color = var_127_5
			},
			down_arrow_hover = {
				masked = true,
				offset = {
					arg_127_7[1] + var_127_2[1] - (var_127_4[1] + 31) / 2,
					arg_127_7[2] + var_127_4[2] / 2 + var_127_1 / 2 - 1,
					arg_127_7[3] + 1
				},
				size = {
					31,
					28
				},
				color = var_127_5
			},
			down_arrow_background = {
				offset = {
					arg_127_7[1] + var_127_2[1] - var_127_4[1],
					arg_127_7[2] + var_127_1 / 2,
					arg_127_7[3] + 1
				},
				color = {
					200,
					20,
					20,
					20
				},
				size = var_127_4
			},
			bottom_edge = {
				offset = {
					arg_127_7[1],
					arg_127_7[2] - var_0_8,
					arg_127_7[3] + 1
				},
				color = var_0_9,
				size = {
					var_127_2[1],
					var_0_8
				}
			},
			list_style = {
				active = true,
				start_index = 1,
				offset = {
					arg_127_7[1] + 7 * var_127_2[1] / 10 + 5,
					arg_127_7[2] + var_127_2[2] - arg_127_4[2] - var_127_1 / 2,
					arg_127_7[3] + 5
				},
				num_draws = var_127_0,
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
					var_127_2[1],
					var_127_2[2]
				}
			}
		},
		scenegraph_id = arg_127_6
	}

	return UIWidget.init(var_127_7)
end

SettingsWidgetTypeTemplate = {
	drop_down = {
		input_function = function(arg_147_0, arg_147_1)
			local var_147_0 = arg_147_0.content
			local var_147_1 = arg_147_0.style
			local var_147_2 = var_147_0.list_content
			local var_147_3 = var_147_1.list_style
			local var_147_4 = var_147_3.start_index
			local var_147_5 = var_147_3.num_draws
			local var_147_6 = var_147_3.total_draws
			local var_147_7 = var_147_0.using_scrollbar
			local var_147_8 = var_147_0.thumbnail_hotspot

			if var_147_0.active then
				local var_147_9 = false

				if arg_147_1:get("move_up_hold_continuous") then
					local var_147_10

					for iter_147_0 = 1, var_147_6 do
						if var_147_2[iter_147_0].hotspot.is_selected then
							var_147_10 = iter_147_0

							break
						end
					end

					if var_147_10 then
						if var_147_10 > 1 then
							var_147_2[var_147_10].hotspot.is_selected = false
							var_147_2[var_147_10 - 1].hotspot.is_selected = true

							if var_147_7 and var_147_4 >= var_147_10 - 1 then
								var_147_3.start_index = math.max(var_147_4 - 1, 1)
							end
						end
					else
						var_147_2[1].hotspot.is_selected = true
					end

					var_147_9 = true
				elseif arg_147_1:get("move_down_hold_continuous") then
					local var_147_11

					for iter_147_1 = 1, var_147_6 do
						if var_147_2[iter_147_1].hotspot.is_selected then
							var_147_11 = iter_147_1

							break
						end
					end

					if var_147_11 then
						if var_147_11 < var_147_6 then
							var_147_2[var_147_11].hotspot.is_selected = false
							var_147_2[var_147_11 + 1].hotspot.is_selected = true

							if var_147_7 and var_147_5 <= var_147_11 + 1 then
								var_147_3.start_index = math.min(var_147_4 + 1, var_147_6 - var_147_5 + 1)
							end
						end
					else
						var_147_2[1].hotspot.is_selected = true
					end

					var_147_9 = true
				end

				if var_147_9 then
					if var_147_7 then
						local var_147_12 = var_147_3.start_index
						local var_147_13 = var_147_6 - var_147_5

						var_147_8.scroll_progress = (var_147_12 - 1) / var_147_13
					end

					return true
				end
			end

			if arg_147_1:get("confirm") then
				if not var_147_0.active then
					var_147_0.active = true
					var_147_3.active = true

					if not Managers.input:is_device_active("mouse") then
						local var_147_14 = var_147_0.current_selection

						if var_147_14 then
							var_147_2[var_147_14].hotspot.is_selected = true

							if var_147_7 then
								local var_147_15 = var_147_6 - var_147_5

								var_147_3.start_index = math.min(var_147_14, var_147_15)
								var_147_8.scroll_progress = (var_147_3.start_index - 1) / var_147_15
							end
						end
					end
				else
					var_147_0.active = false
					var_147_3.active = false

					local var_147_16 = var_147_3.num_draws
					local var_147_17

					for iter_147_2 = 1, var_147_6 do
						local var_147_18 = var_147_2[iter_147_2].hotspot

						if var_147_18.is_selected then
							var_147_18.is_selected = false
							var_147_17 = iter_147_2

							break
						end
					end

					if var_147_17 then
						var_147_0.current_selection = var_147_17

						var_147_0.callback(var_147_0)
					end
				end

				return true, var_147_0.active
			end

			if var_147_0.active and arg_147_1:get("back") then
				var_147_0.active = false
				var_147_3.active = false

				local var_147_19 = var_147_3.num_draws

				for iter_147_3 = 1, var_147_19 do
					local var_147_20 = var_147_2[iter_147_3].hotspot

					if var_147_20.is_selected then
						var_147_20.is_selected = false

						break
					end
				end

				return true, var_147_0.active
			end

			return var_147_0.active
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
		input_function = function(arg_148_0, arg_148_1)
			local var_148_0 = arg_148_0.content

			if arg_148_1:get("confirm") then
				var_148_0.hotspot.on_release = true

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
		input_function = function(arg_149_0, arg_149_1)
			local var_149_0 = arg_149_0.content
			local var_149_1 = var_149_0.num_options
			local var_149_2 = var_149_0.current_selection

			if arg_149_1:get("move_left") then
				if var_149_2 > 1 then
					local var_149_3 = var_149_2 - 1

					var_149_0["option_" .. var_149_3].on_release = true
				end

				return true
			elseif arg_149_1:get("move_right") then
				if var_149_2 < var_149_1 then
					local var_149_4 = var_149_2 + 1

					var_149_0["option_" .. var_149_4].on_release = true
				end

				return true
			end
		end
	},
	keybind = {
		input_function = function(arg_150_0, arg_150_1)
			local var_150_0 = arg_150_0.content
			local var_150_1 = arg_150_0.style

			if var_150_0.active and arg_150_1:get("back", true) then
				var_150_0.controller_input_pressed = true

				return true
			end

			if var_150_0.active and (arg_150_1:get("move_up") or arg_150_1:get("move_down") or arg_150_1:get("move_up_hold") or arg_150_1:get("move_down_hold")) then
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
		input_function = function(arg_151_0, arg_151_1)
			local var_151_0 = arg_151_0.content
			local var_151_1 = var_151_0.list_content
			local var_151_2 = arg_151_0.style

			if not Managers.input:is_device_active("gamepad") and var_151_0.active then
				var_151_0.controller_input_pressed = true
				var_151_0.active = false
				hotspot.is_selected = true

				local var_151_3 = #var_151_1

				for iter_151_0 = 1, var_151_3 do
					var_151_1[iter_151_0].hotspot.is_selected = false
				end

				return true, var_151_0.active
			end

			if not var_151_0.active and arg_151_1:get("confirm") then
				var_151_0.active = true
				var_151_0.controller_input_pressed = true
				var_151_1[1].hotspot.is_selected = true

				Managers.music:trigger_event("Play_hud_select")

				return true
			elseif var_151_0.active then
				if arg_151_1:get("move_up") then
					local var_151_4 = #var_151_1
					local var_151_5

					for iter_151_1 = 1, var_151_4 do
						if var_151_1[iter_151_1].hotspot.is_selected then
							var_151_5 = iter_151_1

							break
						end
					end

					if var_151_5 then
						if var_151_5 > 1 then
							var_151_1[var_151_5].hotspot.is_selected = false
							var_151_1[var_151_5 - 1].hotspot.is_selected = true

							Managers.music:trigger_event("Play_hud_select")
						end
					else
						var_151_1[1].hotspot.is_selected = true
					end

					return true
				elseif arg_151_1:get("move_down") then
					local var_151_6 = #var_151_1
					local var_151_7

					for iter_151_2 = 1, var_151_6 do
						if var_151_1[iter_151_2].hotspot.is_selected then
							var_151_7 = iter_151_2

							break
						end
					end

					if var_151_7 then
						if var_151_7 < var_151_6 then
							var_151_1[var_151_7].hotspot.is_selected = false
							var_151_1[var_151_7 + 1].hotspot.is_selected = true

							Managers.music:trigger_event("Play_hud_select")
						end
					else
						var_151_1[1].hotspot.is_selected = true
					end

					return true
				elseif arg_151_1:get("back", true) then
					var_151_0.controller_input_pressed = true
					var_151_0.active = false

					local var_151_8 = #var_151_1

					for iter_151_3 = 1, var_151_8 do
						var_151_1[iter_151_3].hotspot.is_selected = false
					end

					Managers.music:trigger_event("Play_hud_select")

					return true, var_151_0.active
				elseif arg_151_1:get("confirm", true) then
					local var_151_9
					local var_151_10 = #var_151_1

					for iter_151_4 = 1, var_151_10 do
						if var_151_1[iter_151_4].hotspot.is_selected then
							var_151_9 = iter_151_4

							break
						end
					end

					if var_151_9 then
						local var_151_11 = var_151_1[var_151_9]

						table.remove(var_151_1, var_151_9)
						table.insert(var_151_1, 1, var_151_11)
						var_151_0.callback(var_151_0, var_151_2)
						Managers.music:trigger_event("Play_hud_select")

						for iter_151_5, iter_151_6 in ipairs(var_151_1) do
							iter_151_6.index_text = iter_151_5 .. "."
						end
					end
				end

				return true, var_151_0.active
			end

			return false, var_151_0.active
		end
	},
	stepper = {
		input_function = function(arg_152_0, arg_152_1)
			local var_152_0 = arg_152_0.content

			if arg_152_1:get("move_left") then
				var_152_0.controller_on_release_left = true

				return true
			elseif arg_152_1:get("move_right") then
				var_152_0.controller_on_release_right = true

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
		input_function = function(arg_153_0, arg_153_1, arg_153_2)
			local var_153_0 = arg_153_0.content
			local var_153_1 = var_153_0.input_cooldown
			local var_153_2 = var_153_0.input_cooldown_multiplier
			local var_153_3 = false

			if var_153_1 then
				var_153_3 = true

				local var_153_4 = math.max(var_153_1 - arg_153_2, 0)

				var_153_1 = var_153_4 > 0 and var_153_4 or nil
				var_153_0.input_cooldown = var_153_1
			end

			local var_153_5 = var_153_0.internal_value
			local var_153_6 = var_153_0.num_decimals
			local var_153_7 = var_153_0.min
			local var_153_8 = 1 / ((var_153_0.max - var_153_7) * 10^var_153_6)
			local var_153_9 = false

			if arg_153_1:get("move_left_hold") then
				if not var_153_1 then
					var_153_0.internal_value = math.clamp(var_153_5 - var_153_8, 0, 1)
					var_153_9 = true
				end
			elseif arg_153_1:get("move_right_hold") and not var_153_1 then
				var_153_0.internal_value = math.clamp(var_153_5 + var_153_8, 0, 1)
				var_153_9 = true
			end

			if var_153_9 then
				var_153_0.changed = true

				if var_153_3 then
					local var_153_10 = math.max(var_153_2 - 0.1, 0.1)

					var_153_0.input_cooldown = 0.2 * math.ease_in_exp(var_153_10)
					var_153_0.input_cooldown_multiplier = var_153_10
				else
					local var_153_11 = 1

					var_153_0.input_cooldown = 0.2 * math.ease_in_exp(var_153_11)
					var_153_0.input_cooldown_multiplier = var_153_11
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
		input_function = function()
			return
		end,
		input_description = {
			name = "image",
			gamepad_support = true,
			actions = {}
		}
	},
	title = {
		input_function = function()
			return
		end,
		input_description = {
			name = "title",
			gamepad_support = true,
			actions = {}
		}
	},
	text_link = {
		input_function = function(arg_156_0, arg_156_1)
			local var_156_0 = arg_156_0.content

			var_156_0.controller_input_pressed = nil

			if arg_156_1:get("confirm") then
				var_156_0.controller_input_pressed = true

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
		input_function = function()
			return
		end,
		input_description = {
			name = "gamepad_layout",
			gamepad_support = true,
			actions = {}
		}
	}
}

local var_0_46 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.25,
			init = function(arg_158_0, arg_158_1, arg_158_2, arg_158_3)
				arg_158_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_159_0, arg_159_1, arg_159_2, arg_159_3, arg_159_4)
				local var_159_0 = math.easeOutCubic(arg_159_3)

				arg_159_4.render_settings.alpha_multiplier = var_159_0
			end,
			on_complete = function(arg_160_0, arg_160_1, arg_160_2, arg_160_3)
				arg_160_3.render_settings.alpha_multiplier = 1
			end
		}
	}
}

return {
	scenegraph_definition = var_0_10,
	background_widget_definitions = var_0_17,
	gamepad_frame_widget_definitions = var_0_16,
	widget_definitions = var_0_18,
	button_definitions = var_0_20,
	scrollbar_definition = var_0_23,
	animation_definitions = var_0_46,
	create_title_widget = var_0_36,
	create_checkbox_widget = var_0_26,
	create_slider_widget = var_0_30,
	create_drop_down_widget = var_0_32,
	create_stepper_widget = var_0_34,
	create_option_widget = var_0_40,
	create_text_link_widget = var_0_38,
	create_keybind_widget = var_0_42,
	create_sorted_list_widget = var_0_45,
	create_simple_texture_widget = var_0_27,
	create_gamepad_layout_widget = var_0_28,
	create_safe_rect_widget = var_0_12
}
