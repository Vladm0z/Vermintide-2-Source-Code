-- chunkname: @scripts/ui/views/hero_view/windows/store/definitions/store_window_item_details_definitions.lua

local var_0_0 = UISettings.console_menu_scenegraphs
local var_0_1 = {
	550,
	700
}
local var_0_2 = {
	var_0_1[1] - 84,
	var_0_1[2] - 84
}
local var_0_3 = {
	screen = var_0_0.screen,
	area = var_0_0.area,
	area_left = var_0_0.area_left,
	area_right = var_0_0.area_right,
	area_divider = var_0_0.area_divider,
	window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = var_0_1,
		position = {
			130,
			-215,
			10
		}
	},
	window_background = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_2,
		position = {
			0,
			0,
			0
		}
	},
	paper_background = {
		vertical_alignment = "center",
		parent = "window_background",
		horizontal_alignment = "center",
		size = {
			470,
			620
		},
		position = {
			0,
			0,
			2
		}
	},
	top_banner = {
		vertical_alignment = "top",
		parent = "paper_background",
		horizontal_alignment = "center",
		size = {
			470,
			92
		},
		position = {
			0,
			20,
			1
		}
	},
	top_banner_fade = {
		vertical_alignment = "bottom",
		parent = "background_edge_top",
		horizontal_alignment = "center",
		size = {
			470,
			30
		},
		position = {
			0,
			-25,
			-1
		}
	},
	item_icon_holder = {
		vertical_alignment = "top",
		parent = "paper_background",
		horizontal_alignment = "center",
		size = {
			369,
			136
		},
		position = {
			0,
			-30,
			1
		}
	},
	item_icon = {
		vertical_alignment = "center",
		parent = "item_icon_holder",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	item_icon_mask = {
		vertical_alignment = "center",
		parent = "item_icon_holder",
		horizontal_alignment = "center",
		size = {
			80,
			82
		},
		position = {
			0,
			0,
			1
		}
	},
	background_edge_top = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_1[1] - 42,
			42
		},
		position = {
			0,
			0,
			4
		}
	},
	background_edge_bottom = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_1[1] - 42,
			42
		},
		position = {
			0,
			0,
			4
		}
	},
	background_edge_left = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			42,
			var_0_1[2] - 42
		},
		position = {
			0,
			0,
			4
		}
	},
	background_edge_right = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			42,
			var_0_1[2] - 42
		},
		position = {
			0,
			0,
			4
		}
	},
	corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			151,
			151
		},
		position = {
			-6,
			-6,
			5
		}
	},
	corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			151,
			151
		},
		position = {
			6,
			-6,
			5
		}
	},
	corner_top_left = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			151,
			151
		},
		position = {
			-6,
			6,
			5
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			151,
			151
		},
		position = {
			6,
			6,
			5
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "item_icon_holder",
		horizontal_alignment = "center",
		size = {
			380,
			40
		},
		position = {
			0,
			-140,
			2
		}
	},
	title_text_edge_top = {
		vertical_alignment = "top",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			380,
			4
		},
		position = {
			0,
			4,
			1
		}
	},
	title_text_edge_bottom = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			380,
			4
		},
		position = {
			0,
			-4,
			1
		}
	},
	sub_title_text = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			320,
			30
		},
		position = {
			0,
			-35,
			2
		}
	},
	sub_title_text_edge_left = {
		vertical_alignment = "center",
		parent = "sub_title_text",
		horizontal_alignment = "left",
		size = {
			20,
			14
		},
		position = {
			-20,
			0,
			1
		}
	},
	sub_title_text_edge_right = {
		vertical_alignment = "center",
		parent = "sub_title_text",
		horizontal_alignment = "right",
		size = {
			20,
			14
		},
		position = {
			20,
			0,
			1
		}
	},
	sub_title_divider = {
		vertical_alignment = "bottom",
		parent = "sub_title_text",
		horizontal_alignment = "center",
		size = {
			200,
			20
		},
		position = {
			0,
			-25,
			1
		}
	},
	description_text = {
		vertical_alignment = "top",
		parent = "sub_title_text",
		horizontal_alignment = "center",
		size = {
			350,
			200
		},
		position = {
			0,
			-60,
			2
		}
	},
	career_icons = {
		vertical_alignment = "bottom",
		parent = "paper_background",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			50,
			2
		}
	},
	hero_text_divider = {
		vertical_alignment = "top",
		parent = "career_icons",
		horizontal_alignment = "center",
		size = {
			200,
			20
		},
		position = {
			0,
			75,
			1
		}
	},
	hero_text = {
		vertical_alignment = "top",
		parent = "hero_text_divider",
		horizontal_alignment = "center",
		size = {
			320,
			30
		},
		position = {
			0,
			-18,
			1
		}
	}
}
local var_0_4 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		-2,
		2
	}
}
local var_0_5 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = false,
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = {
		255,
		0,
		0,
		0
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_6 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 20,
	use_shadow = false,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		0,
		0,
		0
	},
	offset = {
		0,
		0,
		2
	}
}

local function var_0_7(arg_1_0)
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "tooltip",
					additional_option_id = "tooltip",
					pass_type = "additional_option_tooltip",
					content_passes = {
						"additional_option_info"
					},
					content_check_function = function (arg_2_0)
						return arg_2_0.tooltip and arg_2_0.button_hotspot.is_hover
					end
				},
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture"
				}
			}
		},
		content = {
			background = "store_preview_info_career_icon_border",
			icon = "store_preview_info_career_icon_border",
			tooltip = {},
			button_hotspot = {
				allow_multi_hover = true
			}
		},
		style = {
			button_hotspot = {
				size = {
					50,
					50
				},
				offset = {
					-25,
					-25,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					0
				},
				texture_size = {
					48,
					50
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					1
				},
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			tooltip = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				grow_downwards = false,
				max_width = 300,
				offset = {
					0,
					0,
					0
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

local var_0_8 = {
	window_background = UIWidgets.create_tiled_texture("window_background", "menu_frame_bg_03", {
		256,
		256
	}),
	window_background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window_background", nil, nil, nil, 1),
	paper_background = UIWidgets.create_simple_texture("store_preview_info_paper", "paper_background"),
	top_banner = UIWidgets.create_simple_texture("store_preview_info_ribbon", "top_banner"),
	top_banner_fade = UIWidgets.create_simple_uv_texture("edge_fade_small", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "top_banner_fade"),
	item_icon_holder = UIWidgets.create_simple_texture("store_preview_info_icon_frame", "item_icon_holder"),
	item_icon = UIWidgets.create_simple_texture("options_window_fade_01", "item_icon", true),
	item_icon_mask = UIWidgets.create_simple_texture("store_preview_info_icon_mask", "item_icon_mask"),
	background_edge_top = UIWidgets.create_tiled_texture("background_edge_top", "store_frame_small_side_01", {
		128,
		42
	}),
	background_edge_bottom = UIWidgets.create_tiled_texture("background_edge_bottom", "store_frame_small_side_03", {
		128,
		42
	}),
	background_edge_left = UIWidgets.create_tiled_texture("background_edge_left", "store_frame_small_side_04", {
		42,
		128
	}),
	background_edge_right = UIWidgets.create_tiled_texture("background_edge_right", "store_frame_small_side_02", {
		42,
		128
	}),
	corner_bottom_left = UIWidgets.create_simple_rotated_texture("store_frame_small_corner", 0, {
		75.5,
		75.5
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidgets.create_simple_rotated_texture("store_frame_small_corner", -math.pi / 2, {
		75.5,
		75.5
	}, "corner_bottom_right"),
	corner_top_left = UIWidgets.create_simple_rotated_texture("store_frame_small_corner", math.pi / 2, {
		75.5,
		75.5
	}, "corner_top_left"),
	corner_top_right = UIWidgets.create_simple_rotated_texture("store_frame_small_corner", math.pi, {
		75.5,
		75.5
	}, "corner_top_right"),
	title_text_background = UIWidgets.create_simple_texture("store_preview_info_text_backdrop", "title_text"),
	title_text_edge_top = UIWidgets.create_simple_texture("store_preview_info_backdrop_border", "title_text_edge_top"),
	title_text_edge_bottom = UIWidgets.create_simple_texture("store_preview_info_backdrop_border", "title_text_edge_bottom"),
	title_text = UIWidgets.create_simple_text("n/a", "title_text", nil, nil, var_0_4),
	sub_title_text = UIWidgets.create_simple_text("n/a", "sub_title_text", nil, nil, var_0_5),
	sub_title_text_edge_right = UIWidgets.create_simple_uv_texture("store_preview_info_arrow", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "sub_title_text_edge_right"),
	sub_title_text_edge_left = UIWidgets.create_simple_texture("store_preview_info_arrow", "sub_title_text_edge_left"),
	sub_title_divider = UIWidgets.create_simple_texture("journal_content_divider_medium", "sub_title_divider"),
	description_text = UIWidgets.create_simple_text("n/a", "description_text", nil, nil, var_0_6),
	hero_text_divider = UIWidgets.create_simple_texture("journal_content_divider_medium", "hero_text_divider"),
	hero_text = UIWidgets.create_simple_text("n/a", "hero_text", nil, nil, var_0_5)
}
local var_0_9 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				arg_3_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
				local var_4_0 = math.easeOutCubic(arg_4_3)

				arg_4_4.render_settings.alpha_multiplier = var_4_0

				local var_4_1 = 250
				local var_4_2 = var_4_1 * var_4_0
				local var_4_3 = arg_4_1.window.position

				arg_4_0.window.local_position[1] = math.floor(var_4_3[1] + var_4_1 - var_4_2)
			end,
			on_complete = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
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
				arg_6_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				local var_7_0 = math.easeOutCubic(arg_7_3)

				arg_7_4.render_settings.alpha_multiplier = 1 - var_7_0
			end,
			on_complete = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_8,
	create_career_icon = var_0_7,
	title_button_definitions = title_button_definitions,
	scenegraph_definition = var_0_3,
	animation_definitions = var_0_9
}
