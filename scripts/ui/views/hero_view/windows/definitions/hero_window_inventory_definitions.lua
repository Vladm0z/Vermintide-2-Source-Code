-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_inventory_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = var_0_0.spacing
local var_0_5 = UIFrameSettings[var_0_2].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[var_0_2].texture_sizes.horizontal[2]
local var_0_7 = var_0_3[1] - (var_0_5 * 2 + 60)
local var_0_8 = {
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
		horizontal_alignment = "center",
		size = var_0_3,
		position = {
			0,
			0,
			1
		}
	},
	window_fade = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			var_0_3[2] - 100
		},
		position = {
			0,
			0,
			0
		}
	},
	material_icons_bg = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			100
		},
		position = {
			0,
			0,
			1
		}
	},
	material_icons_divider = {
		vertical_alignment = "bottom",
		parent = "material_icons_bg",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			0
		},
		position = {
			0,
			0,
			2
		}
	},
	material_text_1 = {
		vertical_alignment = "bottom",
		parent = "material_icons_bg",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] / 7 - 5,
			100
		},
		position = {
			-210,
			0,
			2
		}
	},
	material_text_2 = {
		vertical_alignment = "bottom",
		parent = "material_icons_bg",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] / 7 - 5,
			100
		},
		position = {
			-140,
			0,
			2
		}
	},
	material_text_3 = {
		vertical_alignment = "bottom",
		parent = "material_icons_bg",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] / 7 - 5,
			100
		},
		position = {
			-70,
			0,
			2
		}
	},
	material_text_4 = {
		vertical_alignment = "bottom",
		parent = "material_icons_bg",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] / 7 - 5,
			100
		},
		position = {
			0,
			0,
			2
		}
	},
	material_text_5 = {
		vertical_alignment = "bottom",
		parent = "material_icons_bg",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] / 7 - 5,
			100
		},
		position = {
			70,
			0,
			2
		}
	},
	material_text_6 = {
		vertical_alignment = "bottom",
		parent = "material_icons_bg",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] / 7 - 5,
			100
		},
		position = {
			140,
			0,
			2
		}
	},
	material_text_7 = {
		vertical_alignment = "bottom",
		parent = "material_icons_bg",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] / 7 - 5,
			100
		},
		position = {
			210,
			0,
			2
		}
	},
	item_grid = {
		vertical_alignment = "bottom",
		parent = "page_button_divider",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			var_0_3[2] - 130
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
			var_0_3[1],
			0
		},
		position = {
			0,
			25,
			7
		}
	},
	page_button_next = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			var_0_3[1] * 0.4,
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
			var_0_3[1] * 0.4,
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
			var_0_3[1],
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
			var_0_3[1] * 0.2,
			42
		},
		position = {
			0,
			0,
			3
		}
	}
}
local var_0_9 = {
	vertical_alignment = "center",
	font_size = 20,
	localize = false,
	horizontal_alignment = "right",
	word_wrap = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		-(var_0_3[1] * 0.1 + 5),
		4,
		2
	}
}
local var_0_10 = {
	vertical_alignment = "center",
	font_size = 20,
	localize = false,
	horizontal_alignment = "left",
	word_wrap = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		var_0_3[1] * 0.1 + 4,
		4,
		2
	}
}
local var_0_11 = {
	vertical_alignment = "center",
	font_size = 20,
	localize = false,
	horizontal_alignment = "center",
	word_wrap = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		4,
		2
	}
}

local function var_0_12(arg_1_0, arg_1_1)
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

local function var_0_13(arg_2_0, arg_2_1)
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

local function var_0_14(arg_3_0)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					pass_type = "rotated_texture",
					style_id = "effect",
					texture_id = "effect"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "rect",
					style_id = "text_bg"
				},
				{
					pass_type = "rect",
					style_id = "text_bg_2"
				},
				{
					item_id = "item",
					pass_type = "item_tooltip",
					content_check_function = function (arg_4_0)
						return arg_4_0.button_hotspot.is_hover and arg_4_0.item
					end
				}
			}
		},
		content = {
			text = "0",
			icon = "icon_crafting_dust_01_small",
			effect = "sparkle_effect",
			button_hotspot = {}
		},
		style = {
			text_bg = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					60,
					80
				},
				color = {
					0,
					10,
					10,
					10
				},
				offset = {
					2,
					10,
					1
				}
			},
			text_bg_2 = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					60,
					25
				},
				color = {
					180,
					5,
					5,
					5
				},
				offset = {
					0,
					12,
					0
				}
			},
			icon = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = {
					50,
					50
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
					3
				}
			},
			hover = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					140,
					89
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
					1
				}
			},
			effect = {
				vertical_alignment = "top",
				angle = 0,
				horizontal_alignment = "right",
				offset = {
					110,
					120,
					4
				},
				pivot = {
					128,
					128
				},
				texture_size = {
					256,
					256
				},
				color = Colors.get_color_table_with_alpha("white", 0)
			},
			text = {
				vertical_alignment = "bottom",
				font_size = 20,
				localize = false,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					10,
					3
				}
			},
			text_shadow = {
				vertical_alignment = "bottom",
				font_size = 20,
				localize = false,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					8,
					2
				}
			}
		},
		scenegraph_id = arg_3_0
	}
end

local var_0_15 = {
	item_grid = UIWidgets.create_grid("item_grid", var_0_8.item_grid.size, 7, 5, 16, 10, false),
	window_frame = UIWidgets.create_frame("window", var_0_8.window.size, var_0_2, 10),
	window = UIWidgets.create_background("window", var_0_8.window.size, "background_leather_02"),
	window_background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window_fade", nil, nil, nil, 1),
	material_icons_bg = UIWidgets.create_background("material_icons_bg", var_0_8.material_icons_bg.size, "crafting_bg_top"),
	material_icons_divider = var_0_12("material_icons_divider", var_0_8.material_icons_divider.size),
	material_text_1 = var_0_14("material_text_1"),
	material_text_2 = var_0_14("material_text_2"),
	material_text_3 = var_0_14("material_text_3"),
	material_text_4 = var_0_14("material_text_4"),
	material_text_5 = var_0_14("material_text_5"),
	material_text_6 = var_0_14("material_text_6"),
	material_text_7 = var_0_14("material_text_7"),
	page_button_next = UIWidgets.create_simple_window_button("page_button_next", var_0_8.page_button_next.size, Localize("menu_next"), 16),
	page_button_previous = UIWidgets.create_simple_window_button("page_button_previous", var_0_8.page_button_previous.size, Localize("menu_previous"), 16),
	page_button_divider = var_0_12("page_button_divider", var_0_8.page_button_divider.size),
	page_button_edge_left = var_0_13("page_button_edge_left", var_0_8.page_button_edge_left.size),
	page_button_edge_right = var_0_13("page_button_edge_right", var_0_8.page_button_edge_right.size),
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, var_0_11),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_9),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_10),
	page_text_area = UIWidgets.create_simple_rect("page_text_area", {
		255,
		0,
		0,
		0
	})
}
local var_0_16 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				arg_5_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = var_6_0
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				arg_8_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				local var_9_0 = math.easeOutCubic(arg_9_3)

				arg_9_4.render_settings.alpha_multiplier = 1 - var_9_0
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_15,
	node_widgets = node_widgets,
	scenegraph_definition = var_0_8,
	animation_definitions = var_0_16
}
