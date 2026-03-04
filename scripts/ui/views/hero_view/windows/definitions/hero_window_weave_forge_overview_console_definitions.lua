-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_overview_console_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.size
local var_0_2 = var_0_0.spacing
local var_0_3 = var_0_0.large_window_frame
local var_0_4 = UIFrameSettings[var_0_3].texture_sizes.vertical[1]
local var_0_5 = {
	var_0_1[1] * 3 + var_0_2 * 2 + var_0_4 * 2,
	var_0_1[2] + 80
}
local var_0_6 = {
	var_0_5[1] + 50,
	var_0_5[2]
}
local var_0_7 = "menu_frame_11"
local var_0_8 = UIFrameSettings[var_0_7].texture_sizes.vertical[1]
local var_0_9 = UISettings.game_start_windows
local var_0_10 = 30
local var_0_11 = 0
local var_0_12 = {
	1920,
	1080
}
local var_0_13 = {
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
	screen = {
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
	screen_center = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = var_0_12,
		position = {
			0,
			0,
			1
		}
	},
	viewport_1 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_12[1] - var_0_11 * 2,
			var_0_12[2] - var_0_11 * 2
		},
		position = {
			0,
			var_0_11,
			3
		}
	},
	viewport_2 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_12[1] - var_0_11 * 2,
			var_0_12[2] - var_0_11 * 2
		},
		position = {
			0,
			var_0_11,
			3
		}
	},
	viewport_3 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_12[1] - var_0_11 * 2,
			var_0_12[2] - var_0_11 * 2
		},
		position = {
			0,
			var_0_11,
			3
		}
	},
	viewport_panel_1 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			450,
			100
		},
		position = {
			-545,
			75,
			3
		}
	},
	viewport_panel_2 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			450,
			100
		},
		position = {
			0,
			75,
			3
		}
	},
	viewport_panel_3 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			450,
			100
		},
		position = {
			545,
			75,
			3
		}
	},
	viewport_button_1 = {
		vertical_alignment = "bottom",
		parent = "viewport_panel_1",
		horizontal_alignment = "center",
		size = {
			545,
			540
		},
		position = {
			0,
			160,
			0
		}
	},
	viewport_button_2 = {
		vertical_alignment = "bottom",
		parent = "viewport_panel_2",
		horizontal_alignment = "center",
		size = {
			545,
			540
		},
		position = {
			0,
			160,
			0
		}
	},
	viewport_button_3 = {
		vertical_alignment = "bottom",
		parent = "viewport_panel_3",
		horizontal_alignment = "center",
		size = {
			545,
			540
		},
		position = {
			0,
			160,
			0
		}
	},
	viewport_button_highlight_1 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			545,
			var_0_12[2] - var_0_11 * 2
		},
		position = {
			-545,
			var_0_11,
			1
		}
	},
	viewport_button_highlight_2 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			545,
			var_0_12[2] - var_0_11 * 2
		},
		position = {
			0,
			var_0_11,
			1
		}
	},
	viewport_button_highlight_3 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			545,
			var_0_12[2] - var_0_11 * 2
		},
		position = {
			545,
			var_0_11,
			1
		}
	},
	viewport_panel_divider_1 = {
		vertical_alignment = "top",
		parent = "viewport_panel_1",
		horizontal_alignment = "center",
		size = {
			68,
			19
		},
		position = {
			0,
			var_0_10,
			1
		}
	},
	viewport_panel_divider_2 = {
		vertical_alignment = "top",
		parent = "viewport_panel_2",
		horizontal_alignment = "center",
		size = {
			68,
			19
		},
		position = {
			0,
			var_0_10,
			1
		}
	},
	viewport_panel_divider_3 = {
		vertical_alignment = "top",
		parent = "viewport_panel_3",
		horizontal_alignment = "center",
		size = {
			68,
			19
		},
		position = {
			0,
			var_0_10,
			1
		}
	},
	viewport_panel_divider_left_1 = {
		vertical_alignment = "center",
		parent = "viewport_panel_divider_1",
		horizontal_alignment = "left",
		size = {
			55,
			19
		},
		position = {
			-166,
			0,
			0
		}
	},
	viewport_panel_divider_right_1 = {
		vertical_alignment = "center",
		parent = "viewport_panel_divider_1",
		horizontal_alignment = "right",
		size = {
			55,
			19
		},
		position = {
			166,
			0,
			0
		}
	},
	viewport_panel_divider_left_2 = {
		vertical_alignment = "center",
		parent = "viewport_panel_divider_2",
		horizontal_alignment = "left",
		size = {
			55,
			19
		},
		position = {
			-166,
			0,
			0
		}
	},
	viewport_panel_divider_right_2 = {
		vertical_alignment = "center",
		parent = "viewport_panel_divider_2",
		horizontal_alignment = "right",
		size = {
			55,
			19
		},
		position = {
			166,
			0,
			0
		}
	},
	viewport_panel_divider_left_3 = {
		vertical_alignment = "center",
		parent = "viewport_panel_divider_3",
		horizontal_alignment = "left",
		size = {
			55,
			19
		},
		position = {
			-166,
			0,
			0
		}
	},
	viewport_panel_divider_right_3 = {
		vertical_alignment = "center",
		parent = "viewport_panel_divider_3",
		horizontal_alignment = "right",
		size = {
			55,
			19
		},
		position = {
			166,
			0,
			0
		}
	},
	panel_level_title_1 = {
		vertical_alignment = "top",
		parent = "viewport_panel_1",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			-90,
			0 + var_0_10,
			2
		}
	},
	panel_level_value_1 = {
		vertical_alignment = "top",
		parent = "viewport_panel_1",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			-90,
			-30 + var_0_10,
			2
		}
	},
	panel_power_title_1 = {
		vertical_alignment = "top",
		parent = "viewport_panel_1",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			90,
			0 + var_0_10,
			2
		}
	},
	panel_power_value_1 = {
		vertical_alignment = "top",
		parent = "viewport_panel_1",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			90,
			-30 + var_0_10,
			2
		}
	},
	panel_level_title_2 = {
		vertical_alignment = "top",
		parent = "viewport_panel_2",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			-90,
			0 + var_0_10,
			2
		}
	},
	panel_level_value_2 = {
		vertical_alignment = "top",
		parent = "viewport_panel_2",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			-90,
			-30 + var_0_10,
			2
		}
	},
	panel_power_title_2 = {
		vertical_alignment = "top",
		parent = "viewport_panel_2",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			90,
			0 + var_0_10,
			2
		}
	},
	panel_power_value_2 = {
		vertical_alignment = "top",
		parent = "viewport_panel_2",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			90,
			-30 + var_0_10,
			2
		}
	},
	panel_level_title_3 = {
		vertical_alignment = "top",
		parent = "viewport_panel_3",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			-90,
			0 + var_0_10,
			2
		}
	},
	panel_level_value_3 = {
		vertical_alignment = "top",
		parent = "viewport_panel_3",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			-90,
			-30 + var_0_10,
			2
		}
	},
	panel_power_title_3 = {
		vertical_alignment = "top",
		parent = "viewport_panel_3",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			90,
			0 + var_0_10,
			2
		}
	},
	panel_power_value_3 = {
		vertical_alignment = "top",
		parent = "viewport_panel_3",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			90,
			-30 + var_0_10,
			2
		}
	},
	panel_level_1 = {
		vertical_alignment = "top",
		parent = "viewport_panel_1",
		horizontal_alignment = "center",
		size = {
			120,
			30
		},
		position = {
			-77,
			-22,
			1
		}
	},
	panel_level_2 = {
		vertical_alignment = "top",
		parent = "viewport_panel_2",
		horizontal_alignment = "center",
		size = {
			120,
			30
		},
		position = {
			-77,
			-22,
			1
		}
	},
	panel_level_3 = {
		vertical_alignment = "top",
		parent = "viewport_panel_3",
		horizontal_alignment = "center",
		size = {
			120,
			30
		},
		position = {
			-77,
			-22,
			1
		}
	},
	panel_power_1 = {
		vertical_alignment = "top",
		parent = "viewport_panel_1",
		horizontal_alignment = "center",
		size = {
			120,
			30
		},
		position = {
			77,
			-22,
			1
		}
	},
	panel_power_2 = {
		vertical_alignment = "top",
		parent = "viewport_panel_2",
		horizontal_alignment = "center",
		size = {
			120,
			30
		},
		position = {
			77,
			-22,
			1
		}
	},
	panel_power_3 = {
		vertical_alignment = "top",
		parent = "viewport_panel_3",
		horizontal_alignment = "center",
		size = {
			120,
			30
		},
		position = {
			77,
			-22,
			1
		}
	},
	viewport_title_1 = {
		vertical_alignment = "top",
		parent = "viewport_panel_1",
		horizontal_alignment = "center",
		size = {
			450,
			50
		},
		position = {
			0,
			70 + var_0_10,
			3
		}
	},
	viewport_title_2 = {
		vertical_alignment = "top",
		parent = "viewport_panel_2",
		horizontal_alignment = "center",
		size = {
			450,
			50
		},
		position = {
			0,
			70 + var_0_10,
			3
		}
	},
	viewport_title_3 = {
		vertical_alignment = "top",
		parent = "viewport_panel_3",
		horizontal_alignment = "center",
		size = {
			450,
			50
		},
		position = {
			0,
			70 + var_0_10,
			3
		}
	},
	viewport_sub_title_1 = {
		vertical_alignment = "top",
		parent = "viewport_panel_1",
		horizontal_alignment = "center",
		size = {
			450,
			50
		},
		position = {
			0,
			40 + var_0_10,
			3
		}
	},
	viewport_sub_title_2 = {
		vertical_alignment = "top",
		parent = "viewport_panel_2",
		horizontal_alignment = "center",
		size = {
			450,
			50
		},
		position = {
			0,
			40 + var_0_10,
			3
		}
	},
	viewport_sub_title_3 = {
		vertical_alignment = "top",
		parent = "viewport_panel_3",
		horizontal_alignment = "center",
		size = {
			450,
			50
		},
		position = {
			0,
			40 + var_0_10,
			3
		}
	},
	change_button_1 = {
		vertical_alignment = "bottom",
		parent = "viewport_panel_1",
		horizontal_alignment = "center",
		size = {
			74,
			74
		},
		position = {
			0,
			0 + var_0_10,
			1
		}
	},
	change_button_2 = {
		vertical_alignment = "bottom",
		parent = "viewport_panel_2",
		horizontal_alignment = "center",
		size = {
			74,
			74
		},
		position = {
			0,
			0 + var_0_10,
			1
		}
	},
	change_button_3 = {
		vertical_alignment = "bottom",
		parent = "viewport_panel_3",
		horizontal_alignment = "center",
		size = {
			74,
			74
		},
		position = {
			0,
			0 + var_0_10,
			1
		}
	},
	upgrade_button = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			532,
			126
		},
		position = {
			-var_0_11,
			-var_0_11,
			4
		}
	},
	forge_level_title = {
		vertical_alignment = "center",
		parent = "upgrade_button",
		horizontal_alignment = "center",
		size = {
			300,
			20
		},
		position = {
			20,
			35,
			3
		}
	},
	forge_level_text = {
		vertical_alignment = "center",
		parent = "forge_level_title",
		horizontal_alignment = "center",
		size = {
			150,
			40
		},
		position = {
			0,
			0,
			0
		}
	},
	tutorial_text_title = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			350,
			60
		},
		position = {
			0,
			70,
			2
		}
	},
	tutorial_text_body = {
		vertical_alignment = "top",
		parent = "tutorial_text_title",
		horizontal_alignment = "center",
		size = {
			350,
			400
		},
		position = {
			0,
			-60,
			2
		}
	},
	skull_circle = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = {
			675,
			675
		},
		position = {
			0,
			0,
			10
		}
	},
	skull_circle_shade = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = {
			675,
			675
		},
		position = {
			0,
			0,
			9
		}
	},
	upgrade_bg = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = {
			900,
			400
		},
		position = {
			0,
			10,
			11
		}
	},
	upgrade_text = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = {
			600,
			50
		},
		position = {
			0,
			0,
			12
		}
	}
}
local var_0_14 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = false,
	font_size = 52,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = {
		180,
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
local var_0_15 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_16 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 32,
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
local var_0_17 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 22,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_18 = {
	font_size = 62,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_19 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 18,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_20 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 38,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_21 = {
	font_size = 22,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_22 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_23 = {
	word_wrap = false,
	upper_case = true,
	localize = true,
	use_shadow = true,
	font_size = 44,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_24 = {
	word_wrap = true,
	upper_case = true,
	localize = true,
	use_shadow = true,
	font_size = 22,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = false,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}

local function var_0_25(arg_1_0)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "top_bg",
					pass_type = "texture_uv",
					content_id = "top_bg"
				},
				{
					style_id = "bottom_bg",
					pass_type = "texture_uv",
					content_id = "bottom_bg"
				},
				{
					style_id = "top_highlight",
					pass_type = "texture_uv",
					content_id = "top_highlight"
				},
				{
					style_id = "bottom_highlight",
					pass_type = "texture_uv",
					content_id = "bottom_highlight"
				},
				{
					pass_type = "texture",
					style_id = "wheel",
					texture_id = "wheel"
				}
			}
		},
		content = {
			wheel = "athanor_temper_bg",
			button_hotspot = {
				allow_multi_hover = true
			},
			top_bg = {
				texture_id = "play_glow_mask",
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
			bottom_bg = {
				texture_id = "play_glow_mask",
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
			top_highlight = {
				texture_id = "play_glow_mask",
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
			bottom_highlight = {
				texture_id = "play_glow_mask",
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
			}
		},
		style = {
			wheel = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					273,
					273
				},
				color = {
					255,
					138,
					0,
					187
				},
				offset = {
					0,
					50,
					2
				}
			},
			top_bg = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = {
					545,
					800
				},
				color = {
					255,
					138,
					0,
					187
				},
				offset = {
					0,
					0,
					0
				}
			},
			bottom_bg = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					545,
					800
				},
				color = {
					255,
					138,
					0,
					187
				},
				offset = {
					0,
					0,
					0
				}
			},
			top_highlight = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = {
					400,
					500
				},
				color = {
					200,
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
			bottom_highlight = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					400,
					500
				},
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
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

local function var_0_26(arg_2_0)
	return {
		element = {
			passes = {
				{
					style_id = "background_top",
					pass_type = "texture_uv",
					content_id = "background_top"
				},
				{
					style_id = "background_top_light",
					pass_type = "texture_uv",
					content_id = "background_top"
				},
				{
					style_id = "background_bottom",
					pass_type = "texture_uv",
					content_id = "background_bottom"
				},
				{
					style_id = "background_bottom_light",
					pass_type = "texture_uv",
					content_id = "background_bottom"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				}
			}
		},
		content = {
			title_text = Localize("menu_weave_forge_customize_loadout_button"),
			background_top = {
				texture_id = "wom_text_highlight",
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
			background_bottom = {
				texture_id = "wom_text_highlight",
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
			background_top = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					500,
					130
				},
				color = {
					255,
					138,
					0,
					147
				},
				offset = {
					0,
					65,
					0
				}
			},
			background_top_light = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					400,
					90
				},
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					0,
					45,
					1
				}
			},
			background_bottom = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					500,
					130
				},
				color = {
					255,
					138,
					0,
					147
				},
				offset = {
					0,
					-65,
					0
				}
			},
			background_bottom_light = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					400,
					90
				},
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					0,
					-45,
					1
				}
			},
			title_text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 28,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					0,
					3
				}
			},
			title_text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 28,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					2
				}
			}
		},
		offset = {
			0,
			50,
			3
		},
		scenegraph_id = arg_2_0
	}
end

local function var_0_27(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = "athanor_icon_upgrade"
	local var_3_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_3_0).size
	local var_3_2 = "athanor_icon_loading"
	local var_3_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_3_2).size

	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "tooltip_hotspot"
				},
				{
					style_id = "tooltip",
					additional_option_id = "tooltip",
					pass_type = "additional_option_tooltip",
					content_passes = {
						"weave_progression_slot_titles",
						"athanor_upgrade_tooltip"
					},
					content_check_function = function (arg_4_0)
						return arg_4_0.tooltip and arg_4_0.tooltip_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "price_icon",
					texture_id = "price_icon",
					content_check_function = function (arg_5_0)
						return not arg_5_0.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "price_icon_disabled",
					texture_id = "price_icon",
					content_check_function = function (arg_6_0)
						return arg_6_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "loading_icon",
					texture_id = "loading_icon",
					pass_type = "rotated_texture",
					content_check_function = function (arg_7_0)
						return arg_7_0.upgrading
					end,
					content_change_function = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
						local var_8_0 = ((arg_8_1.progress or 0) + arg_8_3) % 1

						arg_8_1.angle = math.pow(2, math.smoothstep(var_8_0, 0, 1)) * (math.pi * 2)
						arg_8_1.progress = var_8_0
					end
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (arg_9_0)
						return not arg_9_0.button_hotspot.disable_button and not arg_9_0.upgrading
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_disabled",
					texture_id = "icon",
					content_check_function = function (arg_10_0)
						return arg_10_0.button_hotspot.disable_button and not arg_10_0.upgrading
					end
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "hover_glow",
					texture_id = "hover_glow"
				},
				{
					pass_type = "texture",
					style_id = "texture_highlight",
					texture_id = "texture_highlight",
					content_check_function = function (arg_11_0)
						return arg_11_0.highlighted
					end
				},
				{
					pass_type = "texture",
					style_id = "clicked_rect",
					texture_id = "overlay"
				},
				{
					pass_type = "texture",
					style_id = "disabled_rect",
					texture_id = "overlay",
					content_check_function = function (arg_12_0)
						return arg_12_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_13_0)
						return not arg_13_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_14_0)
						return arg_14_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					pass_type = "texture",
					style_id = "button_icon",
					texture_id = "button_icon",
					content_check_function = function (arg_15_0)
						return arg_15_0.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "button_icon_glow",
					texture_id = "button_icon_glow",
					content_check_function = function (arg_16_0)
						return not arg_16_0.button_hotspot.disable_button
					end
				}
			}
		},
		content = {
			button_icon_glow = "athanor_upgrade_kettle_active",
			hover_glow = "athanor_upgrade_bg_highlight",
			upgrading = false,
			price_icon = "icon_crafting_essence_small",
			overlay = "athanor_upgrade_bg_overlay",
			button_icon = "athanor_upgrade_kettle_inactive",
			background = "athanor_upgrade_bg",
			highlighted = false,
			texture_highlight = "tutorial_overlay_round",
			size = arg_3_1,
			button_hotspot = {
				allow_multi_hover = true
			},
			tooltip_hotspot = {},
			icon = var_3_0,
			loading_icon = var_3_2,
			title_text = arg_3_2 or "n/a"
		},
		style = {
			tooltip = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				grow_downwards = true,
				max_width = 325,
				offset = {
					60,
					10,
					0
				}
			},
			button_hotspot = {
				size = {
					arg_3_1[1] - 160,
					arg_3_1[2] - 30
				},
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					115,
					28,
					0
				}
			},
			loading_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				angle = 0,
				pivot = {
					var_3_3[1] / 2,
					var_3_3[2] / 2
				},
				texture_size = {
					var_3_3[1],
					var_3_3[2]
				},
				color = {
					255,
					80,
					80,
					80
				},
				offset = {
					127,
					-8,
					7
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					var_3_1[1],
					var_3_1[2]
				},
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					130,
					-8,
					6
				}
			},
			icon_disabled = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					var_3_1[1],
					var_3_1[2]
				},
				color = {
					255,
					80,
					80,
					80
				},
				offset = {
					130,
					-8,
					6
				}
			},
			button_icon = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					64,
					80
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-75,
					40,
					9
				}
			},
			button_icon_glow = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					87,
					97
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-64,
					35,
					10
				}
			},
			price_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					32,
					32
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
					6
				}
			},
			price_icon_disabled = {
				vertical_alignment = "center",
				saturated = true,
				horizontal_alignment = "center",
				texture_size = {
					32,
					32
				},
				color = {
					255,
					120,
					120,
					120
				},
				offset = {
					0,
					0,
					6
				}
			},
			background = {
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
			hover_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					3
				}
			},
			texture_highlight = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					96,
					96
				},
				offset = {
					96,
					-8,
					6
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			clicked_rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				}
			},
			disabled_rect = {
				color = {
					150,
					20,
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			},
			title_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_3_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_3_1[1] - 40,
					arg_3_1[2]
				},
				default_offset = {
					40,
					0,
					6
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_3_3 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				size = {
					arg_3_1[1] - 40,
					arg_3_1[2]
				},
				default_offset = {
					40,
					0,
					6
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_3_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					arg_3_1[1] - 40,
					arg_3_1[2]
				},
				default_offset = {
					42,
					-2,
					5
				},
				offset = {
					22,
					-2,
					5
				}
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

local var_0_28 = {
	viewport_button_highlight_1 = var_0_25("viewport_button_highlight_1"),
	viewport_button_highlight_2 = var_0_25("viewport_button_highlight_2"),
	viewport_button_highlight_3 = var_0_25("viewport_button_highlight_3")
}
local var_0_29 = {
	top_hdr_background_write_mask = UIWidgets.create_simple_texture("ui_write_mask", "window"),
	upgrade_bg = UIWidgets.create_simple_texture("weave_menu_athanor_upgrade_bg", "upgrade_bg")
}
local var_0_30 = {
	skull_circle = UIWidgets.create_simple_texture("weave_menu_upgrade_skull_circle", "skull_circle"),
	skull_circle_shade = UIWidgets.create_simple_texture("weave_menu_upgrade_skull_circle_shade", "skull_circle_shade")
}
local var_0_31 = {
	upgrade_text = UIWidgets.create_simple_text(Localize("menu_weave_forge_upgraded_effect_title"), "upgrade_text", nil, nil, var_0_14),
	viewport_button_text_highlight_1 = var_0_26("viewport_button_highlight_1"),
	viewport_button_text_highlight_2 = var_0_26("viewport_button_highlight_2"),
	viewport_button_text_highlight_3 = var_0_26("viewport_button_highlight_3"),
	viewport_button_1 = UIWidgets.create_simple_hotspot("viewport_button_1"),
	viewport_button_2 = UIWidgets.create_simple_hotspot("viewport_button_2"),
	viewport_button_3 = UIWidgets.create_simple_hotspot("viewport_button_3"),
	viewport_panel_divider_1 = UIWidgets.create_simple_texture("athanor_item_divider_middle", "viewport_panel_divider_1"),
	viewport_panel_divider_2 = UIWidgets.create_simple_texture("athanor_item_divider_middle", "viewport_panel_divider_2"),
	viewport_panel_divider_3 = UIWidgets.create_simple_texture("athanor_item_divider_middle", "viewport_panel_divider_3"),
	viewport_panel_divider_left_1 = UIWidgets.create_simple_uv_texture("athanor_item_divider_edge", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "viewport_panel_divider_left_1"),
	viewport_panel_divider_right_1 = UIWidgets.create_simple_texture("athanor_item_divider_edge", "viewport_panel_divider_right_1"),
	viewport_panel_divider_left_2 = UIWidgets.create_simple_uv_texture("athanor_item_divider_edge", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "viewport_panel_divider_left_2"),
	viewport_panel_divider_right_2 = UIWidgets.create_simple_texture("athanor_item_divider_edge", "viewport_panel_divider_right_2"),
	viewport_panel_divider_left_3 = UIWidgets.create_simple_uv_texture("athanor_item_divider_edge", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "viewport_panel_divider_left_3"),
	viewport_panel_divider_right_3 = UIWidgets.create_simple_texture("athanor_item_divider_edge", "viewport_panel_divider_right_3"),
	viewport_level_title_1 = UIWidgets.create_simple_text(Localize("menu_weave_forge_magic_level_title"), "panel_level_title_1", nil, nil, var_0_19),
	viewport_level_value_1 = UIWidgets.create_simple_text("0", "panel_level_value_1", nil, nil, var_0_20),
	viewport_power_title_1 = UIWidgets.create_simple_text(Localize("menu_weave_forge_loadout_power_title"), "panel_power_title_1", nil, nil, var_0_19),
	viewport_power_value_1 = UIWidgets.create_simple_text("0", "panel_power_value_1", nil, nil, var_0_20),
	viewport_level_title_2 = UIWidgets.create_simple_text(Localize("menu_weave_forge_magic_level_title"), "panel_level_title_2", nil, nil, var_0_19),
	viewport_level_value_2 = UIWidgets.create_simple_text("0", "panel_level_value_2", nil, nil, var_0_20),
	viewport_power_title_2 = UIWidgets.create_simple_text(Localize("menu_weave_forge_loadout_power_title"), "panel_power_title_2", nil, nil, var_0_19),
	viewport_power_value_2 = UIWidgets.create_simple_text("0", "panel_power_value_2", nil, nil, var_0_20),
	viewport_level_title_3 = UIWidgets.create_simple_text(Localize("menu_weave_forge_magic_level_title"), "panel_level_title_3", nil, nil, var_0_19),
	viewport_level_value_3 = UIWidgets.create_simple_text("0", "panel_level_value_3", nil, nil, var_0_20),
	viewport_power_title_3 = UIWidgets.create_simple_text(Localize("menu_weave_forge_loadout_power_title"), "panel_power_title_3", nil, nil, var_0_19),
	viewport_power_value_3 = UIWidgets.create_simple_text("0", "panel_power_value_3", nil, nil, var_0_20),
	viewport_title_1 = UIWidgets.create_simple_text("", "viewport_title_1", nil, nil, var_0_16),
	viewport_title_2 = UIWidgets.create_simple_text("", "viewport_title_2", nil, nil, var_0_16),
	viewport_title_3 = UIWidgets.create_simple_text("", "viewport_title_3", nil, nil, var_0_16),
	viewport_sub_title_1 = UIWidgets.create_simple_text("", "viewport_sub_title_1", nil, nil, var_0_17),
	viewport_sub_title_2 = UIWidgets.create_simple_text("", "viewport_sub_title_2", nil, nil, var_0_17),
	viewport_sub_title_3 = UIWidgets.create_simple_text("", "viewport_sub_title_3", nil, nil, var_0_17),
	change_button_1 = UIWidgets.create_weave_equipment_button("change_button_1"),
	change_button_3 = UIWidgets.create_weave_equipment_button("change_button_3"),
	change_button_1_tooltip = UIWidgets.create_additional_option_tooltip("change_button_1", var_0_13.change_button_1.size, nil, {
		title = Localize("menu_weave_forge_tooltip_choose_weapon_title"),
		description = Localize("menu_weave_forge_tooltip_choose_weapon_description")
	}, nil, nil, "top", nil, {
		0,
		7,
		0
	}),
	change_button_3_tooltip = UIWidgets.create_additional_option_tooltip("change_button_3", var_0_13.change_button_3.size, nil, {
		title = Localize("menu_weave_forge_tooltip_choose_weapon_title"),
		description = Localize("menu_weave_forge_tooltip_choose_weapon_description")
	}, nil, nil, "top", nil, {
		0,
		7,
		0
	}),
	upgrade_button = var_0_27("upgrade_button", var_0_13.upgrade_button.size, Localize("menu_weave_forge_upgrade_button"), 20),
	forge_level_title = UIWidgets.create_simple_text(Localize("menu_weave_forge_level_title"), "forge_level_title", nil, nil, var_0_21),
	forge_level_text = UIWidgets.create_simple_text("0", "forge_level_text", nil, nil, var_0_22)
}
local var_0_32 = {
	tutorial_title = UIWidgets.create_simple_text("menu_weave_tutorial_athanor_01_empty_state_info_title", "tutorial_text_title", nil, nil, var_0_23),
	tutorial_body = UIWidgets.create_simple_text("menu_weave_tutorial_athanor_01_empty_state_info_body", "tutorial_text_body", nil, nil, var_0_24)
}
local var_0_33 = {
	upgrade = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				local var_17_0 = arg_17_2.upgrade_bg
				local var_17_1 = arg_17_2.skull_circle
				local var_17_2 = arg_17_2.upgrade_text
				local var_17_3 = arg_17_2.skull_circle_shade

				var_17_0.alpha_multiplier = 0
				var_17_1.alpha_multiplier = 0
				var_17_2.alpha_multiplier = 0
				var_17_3.alpha_multiplier = 0
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				local var_18_0 = math.easeOutCubic(arg_18_3)
				local var_18_1 = arg_18_2.upgrade_bg
				local var_18_2 = arg_18_2.skull_circle
				local var_18_3 = arg_18_2.skull_circle_shade
				local var_18_4 = arg_18_2.upgrade_text

				var_18_1.alpha_multiplier = var_18_0
				var_18_2.alpha_multiplier = var_18_0
				var_18_4.alpha_multiplier = var_18_0
				var_18_3.alpha_multiplier = 0.02 * var_18_0
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 1,
			end_progress = 2,
			init = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end,
			update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				local var_21_0 = math.easeInCubic(1 - arg_21_3)
				local var_21_1 = arg_21_2.upgrade_bg
				local var_21_2 = arg_21_2.skull_circle
				local var_21_3 = arg_21_2.upgrade_text

				var_21_1.alpha_multiplier = var_21_0
				var_21_3.alpha_multiplier = var_21_0
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				return
			end
		},
		{
			name = "font_size_increase",
			start_progress = 0,
			end_progress = 2,
			init = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				return
			end,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				local var_24_0 = math.easeOutCubic(arg_24_3)

				arg_24_2.upgrade_text.offset[2] = -40 + 50 * var_24_0
			end,
			on_complete = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				return
			end
		},
		{
			name = "dissolve_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				local var_26_0 = arg_26_3.parent:hdr_renderer().gui
				local var_26_1 = arg_26_2.skull_circle_shade
				local var_26_2 = arg_26_2.skull_circle
				local var_26_3 = var_26_1.content.texture_id
				local var_26_4 = var_26_2.content.texture_id
				local var_26_5 = Gui.material(var_26_0, var_26_3)
				local var_26_6 = Gui.material(var_26_0, var_26_4)
				local var_26_7 = 0

				Material.set_scalar(var_26_5, "progress", var_26_7)
				Material.set_scalar(var_26_6, "progress", var_26_7)
			end,
			update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				local var_27_0 = math.easeInCubic(arg_27_3)
				local var_27_1 = arg_27_4.parent:hdr_renderer().gui
				local var_27_2 = arg_27_2.upgrade_bg
				local var_27_3 = arg_27_2.skull_circle
				local var_27_4 = arg_27_2.skull_circle_shade
				local var_27_5 = var_27_2.content.texture_id
				local var_27_6 = var_27_3.content.texture_id
				local var_27_7 = var_27_4.content.texture_id
				local var_27_8 = Gui.material(var_27_1, var_27_5)
				local var_27_9 = Gui.material(var_27_1, var_27_6)
				local var_27_10 = Gui.material(var_27_1, var_27_7)

				Material.set_scalar(var_27_9, "progress", arg_27_3)
				Material.set_scalar(var_27_10, "progress", arg_27_3)
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				return
			end
		},
		{
			name = "intensity",
			start_progress = 0.5,
			end_progress = 2,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				local var_29_0 = arg_29_3.parent:hdr_renderer().gui
				local var_29_1 = arg_29_2.skull_circle.content.texture_id
				local var_29_2 = Gui.material(var_29_0, var_29_1)
				local var_29_3 = 2

				Material.set_scalar(var_29_2, "intensity", var_29_3)
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				local var_30_0 = math.easeInCubic(arg_30_3)
				local var_30_1 = arg_30_4.parent:hdr_renderer().gui
				local var_30_2 = arg_30_2.skull_circle.content.texture_id
				local var_30_3 = Gui.material(var_30_1, var_30_2)
				local var_30_4 = 2
				local var_30_5 = 10
				local var_30_6 = var_30_4 + math.clamp(arg_30_3, 0, 1) * var_30_5

				Material.set_scalar(var_30_3, "intensity", var_30_6)
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end
		},
		{
			name = "dissolve_out",
			start_progress = 1,
			end_progress = 2.5,
			init = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				return
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				local var_33_0 = math.easeInCubic(1 - arg_33_3)
				local var_33_1 = arg_33_4.parent:hdr_renderer().gui
				local var_33_2 = arg_33_2.skull_circle_shade
				local var_33_3 = arg_33_2.skull_circle
				local var_33_4 = var_33_2.content.texture_id
				local var_33_5 = var_33_3.content.texture_id
				local var_33_6 = Gui.material(var_33_1, var_33_4)
				local var_33_7 = Gui.material(var_33_1, var_33_5)

				Material.set_scalar(var_33_7, "progress", var_33_0)
				Material.set_scalar(var_33_6, "progress", var_33_0)

				var_33_2.alpha_multiplier = 0.02 * var_33_0
			end,
			on_complete = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end
		},
		{
			name = "size_increase",
			start_progress = 0,
			end_progress = 4,
			init = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				local var_35_0 = arg_35_2.upgrade_bg
				local var_35_1 = arg_35_2.skull_circle
				local var_35_2 = arg_35_2.skull_circle_shade
				local var_35_3 = var_35_0.scenegraph_id
				local var_35_4 = var_35_1.scenegraph_id
				local var_35_5 = var_35_2.scenegraph_id
				local var_35_6 = arg_35_1[var_35_3]
				local var_35_7 = arg_35_1[var_35_4]
				local var_35_8 = arg_35_1[var_35_5]
				local var_35_9 = var_35_6.size
				local var_35_10 = var_35_7.size
				local var_35_11 = var_35_8.size
				local var_35_12 = arg_35_0[var_35_3]
				local var_35_13 = arg_35_0[var_35_4]
				local var_35_14 = arg_35_0[var_35_5]
				local var_35_15 = var_35_12.size
				local var_35_16 = var_35_13.size
				local var_35_17 = var_35_14.size

				var_35_16[1] = var_35_10[1]
				var_35_16[2] = var_35_10[2]
				var_35_17[1] = var_35_11[1]
				var_35_17[2] = var_35_11[2]
				var_35_15[1] = var_35_9[1]
				var_35_15[2] = var_35_9[2]
			end,
			update = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				local var_36_0 = math.easeOutCubic(arg_36_3)
				local var_36_1 = arg_36_2.upgrade_bg
				local var_36_2 = arg_36_2.skull_circle
				local var_36_3 = arg_36_2.skull_circle_shade
				local var_36_4 = var_36_1.scenegraph_id
				local var_36_5 = var_36_2.scenegraph_id
				local var_36_6 = var_36_3.scenegraph_id
				local var_36_7 = arg_36_1[var_36_4]
				local var_36_8 = arg_36_1[var_36_5]
				local var_36_9 = arg_36_1[var_36_6]
				local var_36_10 = var_36_7.size
				local var_36_11 = var_36_8.size
				local var_36_12 = var_36_9.size
				local var_36_13 = arg_36_0[var_36_4]
				local var_36_14 = arg_36_0[var_36_5]
				local var_36_15 = arg_36_0[var_36_6]
				local var_36_16 = var_36_13.size
				local var_36_17 = var_36_14.size
				local var_36_18 = var_36_15.size
				local var_36_19 = 600
				local var_36_20 = 2200

				var_36_17[1] = var_36_11[1] + var_36_19 * var_36_0
				var_36_17[2] = var_36_11[2] + var_36_19 * var_36_0
				var_36_18[1] = var_36_12[1] + var_36_20 * var_36_0
				var_36_18[2] = var_36_12[2] + var_36_20 * var_36_0
				var_36_16[1] = var_36_10[1] + 200 * (1 - var_36_0)
				var_36_16[2] = var_36_10[2] + 200 * (1 - var_36_0)
			end,
			on_complete = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				return
			end
		}
	},
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				arg_38_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				local var_39_0 = math.easeOutCubic(arg_39_3)

				arg_39_4.render_settings.alpha_multiplier = var_39_0
			end,
			on_complete = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				arg_41_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
				local var_42_0 = math.easeOutCubic(arg_42_3)

				arg_42_4.render_settings.alpha_multiplier = 1 - var_42_0
			end,
			on_complete = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				return
			end
		}
	}
}

return {
	top_widgets = var_0_31,
	bottom_widgets = var_0_28,
	top_hdr_widgets = var_0_29,
	bottom_hdr_widgets = var_0_30,
	scenegraph_definition = var_0_13,
	animation_definitions = var_0_33,
	weapon_crafting_tutorial_definitions = var_0_32
}
