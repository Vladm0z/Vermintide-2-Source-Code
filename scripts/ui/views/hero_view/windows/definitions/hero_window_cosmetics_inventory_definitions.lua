-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_inventory_definitions.lua

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
			15,
			7
		}
	},
	item_grid_header_fade = {
		vertical_alignment = "top",
		parent = "item_tabs_divider",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
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
			var_0_3[1] - 20,
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
			var_0_3[1],
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
			var_0_3[1],
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
			var_0_3[1],
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
			var_0_3[1],
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
			var_0_3[1],
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
local var_0_10 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		-(var_0_3[1] * 0.1 + 5),
		4,
		2
	}
}
local var_0_11 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		var_0_3[1] * 0.1 + 4,
		4,
		2
	}
}
local var_0_12 = {
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

local function var_0_13(arg_1_0, arg_1_1)
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

local function var_0_14(arg_2_0, arg_2_1)
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

local function var_0_15(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0

	if arg_3_5 then
		var_3_0 = "button_" .. arg_3_5
	else
		var_3_0 = "button_normal"
	end

	local var_3_1 = Colors.get_color_table_with_alpha(var_3_0, 255)
	local var_3_2 = "button_bg_01"
	local var_3_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_3_2)

	return {
		element = {
			passes = {
				{
					style_id = "button_background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "button_background",
					pass_type = "texture_uv",
					content_id = "button_background"
				},
				{
					texture_id = "bottom_edge",
					style_id = "button_edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "glass_top",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (arg_4_0)
						local var_4_0 = arg_4_0.button_hotspot

						return not var_4_0.disable_button and (var_4_0.is_selected or var_4_0.is_hover)
					end
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (arg_5_0)
						return not arg_5_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (arg_6_0)
						return arg_6_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_shadow",
					pass_type = "text",
					text_id = "button_text"
				},
				{
					style_id = "button_clicked_rect",
					pass_type = "rect",
					content_check_function = function (arg_7_0)
						local var_7_0 = arg_7_0.button_hotspot.is_clicked

						return not var_7_0 or var_7_0 == 0
					end
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (arg_8_0)
						return arg_8_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture",
					content_check_function = function (arg_9_0)
						return arg_9_0.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture",
					content_check_function = function (arg_10_0)
						return arg_10_0.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture",
					content_check_function = function (arg_11_0)
						return arg_11_0.use_bottom_edge
					end
				}
			}
		},
		content = {
			edge_holder_left = "menu_frame_09_divider_left",
			edge_holder_right = "menu_frame_09_divider_right",
			glass_top = "button_glass_01",
			bottom_edge = "menu_frame_09_divider",
			use_bottom_edge = arg_3_4,
			button_hotspot = {},
			button_text = arg_3_2 or "n/a",
			hover_glow = arg_3_5 and "button_state_hover_" .. arg_3_5 or "button_state_hover",
			glow = arg_3_5 and "button_state_normal_" .. arg_3_5 or "button_state_normal",
			button_background = {
				uvs = {
					{
						0,
						1 - math.min(arg_3_1[2] / var_3_3.size[2], 1)
					},
					{
						math.min(arg_3_1[1] / var_3_3.size[1], 1),
						1
					}
				},
				texture_id = var_3_2
			}
		},
		style = {
			button_background = {
				color = var_3_1,
				offset = {
					0,
					0,
					2
				},
				size = arg_3_1
			},
			button_edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_3_1[2],
					3
				},
				size = {
					arg_3_1[1],
					5
				},
				texture_tiling_size = {
					arg_3_1[1],
					5
				}
			},
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_3_1[2] - 4,
					3
				},
				size = {
					arg_3_1[1],
					5
				}
			},
			glow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					5,
					3
				},
				size = {
					arg_3_1[1],
					arg_3_1[2] - 5
				}
			},
			hover_glow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					5,
					2
				},
				size = {
					arg_3_1[1],
					arg_3_1[2] - 5
				}
			},
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
					arg_3_1[1] - 10,
					5
				},
				texture_tiling_size = {
					arg_3_1[1] - 10,
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
					arg_3_1[1] - 12,
					-6,
					10
				},
				size = {
					9,
					17
				}
			},
			button_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_3_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					5,
					4
				},
				size = arg_3_1
			},
			button_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_3_3 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					5,
					4
				},
				size = arg_3_1
			},
			button_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_3_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					3,
					3
				},
				size = arg_3_1
			},
			button_clicked_rect = {
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					5
				},
				size = arg_3_1
			},
			button_disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					0,
					0,
					5
				},
				size = arg_3_1
			}
		},
		scenegraph_id = arg_3_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_16 = {
	{
		wield = true,
		name = "hats",
		item_filter = "slot_type == hat",
		hero_specific_filter = true,
		display_name = Localize("inventory_screen_hats_title"),
		item_types = {
			"hat"
		},
		icon = UISettings.slot_icons.hat
	},
	{
		wield = true,
		name = "skin",
		item_filter = "slot_type == skin",
		hero_specific_filter = true,
		display_name = Localize("inventory_screen_skins_title"),
		item_types = {
			"skin"
		},
		icon = UISettings.slot_icons.skins
	},
	{
		name = "frames",
		item_filter = "slot_type == frame",
		hero_specific_filter = true,
		display_name = Localize("inventory_screen_frames_title"),
		item_types = {
			"frame"
		},
		icon = UISettings.slot_icons.portrait_frame
	},
	{
		name = "poses",
		item_filter = "item_type == weapon_pose",
		hero_specific_filter = true,
		display_name = Localize("inventory_screen_poses_title"),
		item_types = {
			"weapon_pose"
		},
		icon = UISettings.slot_icons.pose
	}
}
local var_0_17 = #var_0_16
local var_0_18 = {
	item_grid = UIWidgets.create_grid("item_grid", var_0_8.item_grid.size, 7, 5, 16, 10, false),
	item_tabs_divider = var_0_13("item_tabs_divider", var_0_8.item_tabs_divider.size),
	item_grid_header = UIWidgets.create_simple_text(Localize("hero_view_inventory"), "item_grid_header", nil, nil, var_0_9),
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
	window_frame = UIWidgets.create_frame("window", var_0_8.window.size, var_0_2, 10),
	window = UIWidgets.create_background("window", var_0_8.window.size, "background_leather_02"),
	window_background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window", nil, nil, nil, 1),
	item_tabs = UIWidgets.create_default_icon_tabs("item_tabs", var_0_8.item_tabs.size, var_0_17),
	item_tabs_segments = UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_vertical", {
		5,
		35
	}, "item_tabs_segments", var_0_17 - 1),
	item_tabs_segments_top = UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_top", {
		17,
		9
	}, "item_tabs_segments_top", var_0_17 - 1),
	item_tabs_segments_bottom = UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_bottom", {
		17,
		9
	}, "item_tabs_segments_bottom", var_0_17 - 1),
	page_button_next = UIWidgets.create_simple_window_button("page_button_next", var_0_8.page_button_next.size, Localize("menu_next"), 16),
	page_button_previous = UIWidgets.create_simple_window_button("page_button_previous", var_0_8.page_button_previous.size, Localize("menu_previous"), 16),
	page_button_divider = var_0_13("page_button_divider", var_0_8.page_button_divider.size),
	page_button_edge_left = var_0_14("page_button_edge_left", var_0_8.page_button_edge_left.size),
	page_button_edge_right = var_0_14("page_button_edge_right", var_0_8.page_button_edge_right.size),
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, var_0_12),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_10),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_11),
	page_text_area = UIWidgets.create_simple_rect("page_text_area", {
		255,
		0,
		0,
		0
	})
}
local var_0_19 = {
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
local var_0_20 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				arg_12_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				local var_13_0 = math.easeOutCubic(arg_13_3)

				arg_13_4.render_settings.alpha_multiplier = var_13_0
			end,
			on_complete = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				arg_15_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				local var_16_0 = math.easeOutCubic(arg_16_3)

				arg_16_4.render_settings.alpha_multiplier = 1 - var_16_0
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_18,
	category_settings = var_0_16,
	scenegraph_definition = var_0_8,
	animation_definitions = var_0_20,
	generic_input_actions = var_0_19
}
