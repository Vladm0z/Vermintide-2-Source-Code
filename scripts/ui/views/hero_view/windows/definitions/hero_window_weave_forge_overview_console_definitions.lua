-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_overview_console_definitions.lua

local game_start_windows = UISettings.game_start_windows
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local large_window_frame = game_start_windows.large_window_frame
local var_0_4 = UIFrameSettings[large_window_frame].texture_sizes.vertical[1]
local tbl = {
	size[1] * 3 + spacing * 2 + var_0_4 * 2,
	size[2] + 80
}
local tbl_2 = {
	tbl[1] + 50,
	tbl[2]
}
local str = "menu_frame_11"
local var_0_8 = UIFrameSettings[str].texture_sizes.vertical[1]
local game_start_windows_2 = UISettings.game_start_windows
local num = 30
local num_2 = 0
local tbl_3 = {
	1920,
	1080
}
local tbl_4 = {
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
		size = tbl_3,
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
			tbl_3[1] - num_2 * 2,
			tbl_3[2] - num_2 * 2
		},
		position = {
			0,
			num_2,
			3
		}
	},
	viewport_2 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_3[1] - num_2 * 2,
			tbl_3[2] - num_2 * 2
		},
		position = {
			0,
			num_2,
			3
		}
	},
	viewport_3 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_3[1] - num_2 * 2,
			tbl_3[2] - num_2 * 2
		},
		position = {
			0,
			num_2,
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
			tbl_3[2] - num_2 * 2
		},
		position = {
			-545,
			num_2,
			1
		}
	},
	viewport_button_highlight_2 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			545,
			tbl_3[2] - num_2 * 2
		},
		position = {
			0,
			num_2,
			1
		}
	},
	viewport_button_highlight_3 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			545,
			tbl_3[2] - num_2 * 2
		},
		position = {
			545,
			num_2,
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
			num,
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
			num,
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
			num,
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
			0 + num,
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
			-30 + num,
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
			0 + num,
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
			-30 + num,
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
			0 + num,
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
			-30 + num,
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
			0 + num,
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
			-30 + num,
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
			0 + num,
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
			-30 + num,
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
			0 + num,
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
			-30 + num,
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
			70 + num,
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
			70 + num,
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
			70 + num,
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
			40 + num,
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
			40 + num,
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
			40 + num,
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
			0 + num,
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
			0 + num,
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
			0 + num,
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
			-num_2,
			-num_2,
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
local tbl_5 = {
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
local tbl_6 = {
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
local tbl_7 = {
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
local tbl_8 = {
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
local tbl_9 = {
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
local tbl_10 = {
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
local tbl_11 = {
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
local tbl_12 = {
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
local tbl_13 = {
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
local tbl_14 = {
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
local tbl_15 = {
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

local function fn(arg_1_0)
	-- function 1
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

local function fn_2(arg_2_0)
	-- function 2
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

local function fn_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local str = "athanor_icon_upgrade"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(str).size
	local str_2 = "athanor_icon_loading"
	local size_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2).size

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
					content_check_function = function (self)
						-- function 4
						local tooltip = self.tooltip

						tooltip = not tooltip and self.tooltip_hotspot.is_hover

						return tooltip
					end
				},
				{
					pass_type = "texture",
					style_id = "price_icon",
					texture_id = "price_icon",
					content_check_function = function (self)
						-- function 5
						return not self.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "price_icon_disabled",
					texture_id = "price_icon",
					content_check_function = function (self)
						-- function 6
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "loading_icon",
					texture_id = "loading_icon",
					pass_type = "rotated_texture",
					content_check_function = function (self)
						-- function 7
						return self.upgrading
					end,
					content_change_function = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
						-- function 8
						local progress = arg_8_1.progress

						progress = progress or 0

						local num = (progress + arg_8_3) % 1

						arg_8_1.angle = math.pow(2, math.smoothstep(num, 0, 1)) * (math.pi * 2)
						arg_8_1.progress = num
					end
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (self)
						-- function 9
						return not not self.button_hotspot.disable_button or not self.upgrading
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_disabled",
					texture_id = "icon",
					content_check_function = function (self)
						-- function 10
						local disable_button = self.button_hotspot.disable_button

						disable_button = not disable_button and not self.upgrading

						return disable_button
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
					content_check_function = function (self)
						-- function 11
						return self.highlighted
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
					content_check_function = function (self)
						-- function 12
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 13
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 14
						return self.button_hotspot.disable_button
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
					content_check_function = function (self)
						-- function 15
						return self.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "button_icon_glow",
					texture_id = "button_icon_glow",
					content_check_function = function (self)
						-- function 16
						return not self.button_hotspot.disable_button
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
			icon = str,
			loading_icon = str_2,
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
					size_2[1] / 2,
					size_2[2] / 2
				},
				texture_size = {
					size_2[1],
					size_2[2]
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
					size[1],
					size[2]
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
					size[1],
					size[2]
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

local tbl_16 = {
	viewport_button_highlight_1 = fn("viewport_button_highlight_1"),
	viewport_button_highlight_2 = fn("viewport_button_highlight_2"),
	viewport_button_highlight_3 = fn("viewport_button_highlight_3")
}
local tbl_17 = {
	top_hdr_background_write_mask = UIWidgets.create_simple_texture("ui_write_mask", "window"),
	upgrade_bg = UIWidgets.create_simple_texture("weave_menu_athanor_upgrade_bg", "upgrade_bg")
}
local tbl_18 = {
	skull_circle = UIWidgets.create_simple_texture("weave_menu_upgrade_skull_circle", "skull_circle"),
	skull_circle_shade = UIWidgets.create_simple_texture("weave_menu_upgrade_skull_circle_shade", "skull_circle_shade")
}
local tbl_19 = {
	upgrade_text = UIWidgets.create_simple_text(Localize("menu_weave_forge_upgraded_effect_title"), "upgrade_text", nil, nil, tbl_5),
	viewport_button_text_highlight_1 = fn_2("viewport_button_highlight_1"),
	viewport_button_text_highlight_2 = fn_2("viewport_button_highlight_2"),
	viewport_button_text_highlight_3 = fn_2("viewport_button_highlight_3"),
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
	viewport_level_title_1 = UIWidgets.create_simple_text(Localize("menu_weave_forge_magic_level_title"), "panel_level_title_1", nil, nil, tbl_10),
	viewport_level_value_1 = UIWidgets.create_simple_text("0", "panel_level_value_1", nil, nil, tbl_11),
	viewport_power_title_1 = UIWidgets.create_simple_text(Localize("menu_weave_forge_loadout_power_title"), "panel_power_title_1", nil, nil, tbl_10),
	viewport_power_value_1 = UIWidgets.create_simple_text("0", "panel_power_value_1", nil, nil, tbl_11),
	viewport_level_title_2 = UIWidgets.create_simple_text(Localize("menu_weave_forge_magic_level_title"), "panel_level_title_2", nil, nil, tbl_10),
	viewport_level_value_2 = UIWidgets.create_simple_text("0", "panel_level_value_2", nil, nil, tbl_11),
	viewport_power_title_2 = UIWidgets.create_simple_text(Localize("menu_weave_forge_loadout_power_title"), "panel_power_title_2", nil, nil, tbl_10),
	viewport_power_value_2 = UIWidgets.create_simple_text("0", "panel_power_value_2", nil, nil, tbl_11),
	viewport_level_title_3 = UIWidgets.create_simple_text(Localize("menu_weave_forge_magic_level_title"), "panel_level_title_3", nil, nil, tbl_10),
	viewport_level_value_3 = UIWidgets.create_simple_text("0", "panel_level_value_3", nil, nil, tbl_11),
	viewport_power_title_3 = UIWidgets.create_simple_text(Localize("menu_weave_forge_loadout_power_title"), "panel_power_title_3", nil, nil, tbl_10),
	viewport_power_value_3 = UIWidgets.create_simple_text("0", "panel_power_value_3", nil, nil, tbl_11),
	viewport_title_1 = UIWidgets.create_simple_text("", "viewport_title_1", nil, nil, tbl_7),
	viewport_title_2 = UIWidgets.create_simple_text("", "viewport_title_2", nil, nil, tbl_7),
	viewport_title_3 = UIWidgets.create_simple_text("", "viewport_title_3", nil, nil, tbl_7),
	viewport_sub_title_1 = UIWidgets.create_simple_text("", "viewport_sub_title_1", nil, nil, tbl_8),
	viewport_sub_title_2 = UIWidgets.create_simple_text("", "viewport_sub_title_2", nil, nil, tbl_8),
	viewport_sub_title_3 = UIWidgets.create_simple_text("", "viewport_sub_title_3", nil, nil, tbl_8),
	change_button_1 = UIWidgets.create_weave_equipment_button("change_button_1"),
	change_button_3 = UIWidgets.create_weave_equipment_button("change_button_3"),
	change_button_1_tooltip = UIWidgets.create_additional_option_tooltip("change_button_1", tbl_4.change_button_1.size, nil, {
		title = Localize("menu_weave_forge_tooltip_choose_weapon_title"),
		description = Localize("menu_weave_forge_tooltip_choose_weapon_description")
	}, nil, nil, "top", nil, {
		0,
		7,
		0
	}),
	change_button_3_tooltip = UIWidgets.create_additional_option_tooltip("change_button_3", tbl_4.change_button_3.size, nil, {
		title = Localize("menu_weave_forge_tooltip_choose_weapon_title"),
		description = Localize("menu_weave_forge_tooltip_choose_weapon_description")
	}, nil, nil, "top", nil, {
		0,
		7,
		0
	}),
	upgrade_button = fn_3("upgrade_button", tbl_4.upgrade_button.size, Localize("menu_weave_forge_upgrade_button"), 20),
	forge_level_title = UIWidgets.create_simple_text(Localize("menu_weave_forge_level_title"), "forge_level_title", nil, nil, tbl_12),
	forge_level_text = UIWidgets.create_simple_text("0", "forge_level_text", nil, nil, tbl_13)
}
local tbl_20 = {
	tutorial_title = UIWidgets.create_simple_text("menu_weave_tutorial_athanor_01_empty_state_info_title", "tutorial_text_title", nil, nil, tbl_14),
	tutorial_body = UIWidgets.create_simple_text("menu_weave_tutorial_athanor_01_empty_state_info_body", "tutorial_text_body", nil, nil, tbl_15)
}
local tbl_21 = {
	upgrade = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				local upgrade_bg = arg_17_2.upgrade_bg
				local skull_circle = arg_17_2.skull_circle
				local upgrade_text = arg_17_2.upgrade_text
				local skull_circle_shade = arg_17_2.skull_circle_shade

				upgrade_bg.alpha_multiplier = 0
				skull_circle.alpha_multiplier = 0
				upgrade_text.alpha_multiplier = 0
				skull_circle_shade.alpha_multiplier = 0
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				-- function 18
				local easeOutCubic = math.easeOutCubic(arg_18_3)
				local upgrade_bg = arg_18_2.upgrade_bg
				local skull_circle = arg_18_2.skull_circle
				local skull_circle_shade = arg_18_2.skull_circle_shade
				local upgrade_text = arg_18_2.upgrade_text

				upgrade_bg.alpha_multiplier = easeOutCubic
				skull_circle.alpha_multiplier = easeOutCubic
				upgrade_text.alpha_multiplier = easeOutCubic
				skull_circle_shade.alpha_multiplier = 0.02 * easeOutCubic
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 1,
			end_progress = 2,
			init = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				return
			end,
			update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				-- function 21
				local easeInCubic = math.easeInCubic(1 - arg_21_3)
				local upgrade_bg = arg_21_2.upgrade_bg
				local skull_circle = arg_21_2.skull_circle
				local upgrade_text = arg_21_2.upgrade_text

				upgrade_bg.alpha_multiplier = easeInCubic
				upgrade_text.alpha_multiplier = easeInCubic
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				return
			end
		},
		{
			name = "font_size_increase",
			start_progress = 0,
			end_progress = 2,
			init = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				-- function 23
				return
			end,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				-- function 24
				local easeOutCubic = math.easeOutCubic(arg_24_3)

				arg_24_2.upgrade_text.offset[2] = -40 + 50 * easeOutCubic
			end,
			on_complete = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				return
			end
		},
		{
			name = "dissolve_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				local gui = arg_26_3.parent:hdr_renderer().gui
				local skull_circle_shade = arg_26_2.skull_circle_shade
				local skull_circle = arg_26_2.skull_circle
				local texture_id = skull_circle_shade.content.texture_id
				local texture_id_2 = skull_circle.content.texture_id
				local material = Gui.material(gui, texture_id)
				local material_2 = Gui.material(gui, texture_id_2)
				local num = 0

				Material.set_scalar(material, "progress", num)
				Material.set_scalar(material_2, "progress", num)
			end,
			update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				-- function 27
				local easeInCubic = math.easeInCubic(arg_27_3)
				local gui = arg_27_4.parent:hdr_renderer().gui
				local upgrade_bg = arg_27_2.upgrade_bg
				local skull_circle = arg_27_2.skull_circle
				local skull_circle_shade = arg_27_2.skull_circle_shade
				local texture_id = upgrade_bg.content.texture_id
				local texture_id_2 = skull_circle.content.texture_id
				local texture_id_3 = skull_circle_shade.content.texture_id
				local material = Gui.material(gui, texture_id)
				local material_2 = Gui.material(gui, texture_id_2)
				local material_3 = Gui.material(gui, texture_id_3)

				Material.set_scalar(material_2, "progress", arg_27_3)
				Material.set_scalar(material_3, "progress", arg_27_3)
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				return
			end
		},
		{
			name = "intensity",
			start_progress = 0.5,
			end_progress = 2,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				local gui = arg_29_3.parent:hdr_renderer().gui
				local texture_id = arg_29_2.skull_circle.content.texture_id
				local material = Gui.material(gui, texture_id)
				local num = 2

				Material.set_scalar(material, "intensity", num)
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				-- function 30
				local easeInCubic = math.easeInCubic(arg_30_3)
				local gui = arg_30_4.parent:hdr_renderer().gui
				local texture_id = arg_30_2.skull_circle.content.texture_id
				local material = Gui.material(gui, texture_id)
				local num = 2
				local num_2 = 10
				local num_3 = num + math.clamp(arg_30_3, 0, 1) * num_2

				Material.set_scalar(material, "intensity", num_3)
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				return
			end
		},
		{
			name = "dissolve_out",
			start_progress = 1,
			end_progress = 2.5,
			init = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				-- function 32
				return
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				-- function 33
				local easeInCubic = math.easeInCubic(1 - arg_33_3)
				local gui = arg_33_4.parent:hdr_renderer().gui
				local skull_circle_shade = arg_33_2.skull_circle_shade
				local skull_circle = arg_33_2.skull_circle
				local texture_id = skull_circle_shade.content.texture_id
				local texture_id_2 = skull_circle.content.texture_id
				local material = Gui.material(gui, texture_id)
				local material_2 = Gui.material(gui, texture_id_2)

				Material.set_scalar(material_2, "progress", easeInCubic)
				Material.set_scalar(material, "progress", easeInCubic)

				skull_circle_shade.alpha_multiplier = 0.02 * easeInCubic
			end,
			on_complete = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				return
			end
		},
		{
			name = "size_increase",
			start_progress = 0,
			end_progress = 4,
			init = function (self, arg_35_1, arg_35_2, arg_35_3)
				-- function 35
				local upgrade_bg = arg_35_2.upgrade_bg
				local skull_circle = arg_35_2.skull_circle
				local skull_circle_shade = arg_35_2.skull_circle_shade
				local scenegraph_id = upgrade_bg.scenegraph_id
				local scenegraph_id_2 = skull_circle.scenegraph_id
				local scenegraph_id_3 = skull_circle_shade.scenegraph_id
				local var_35_6 = arg_35_1[scenegraph_id]
				local var_35_7 = arg_35_1[scenegraph_id_2]
				local var_35_8 = arg_35_1[scenegraph_id_3]
				local size = var_35_6.size
				local size_2 = var_35_7.size
				local size_3 = var_35_8.size
				local var_35_12 = self[scenegraph_id]
				local var_35_13 = self[scenegraph_id_2]
				local var_35_14 = self[scenegraph_id_3]
				local size_4 = var_35_12.size
				local size_5 = var_35_13.size
				local size_6 = var_35_14.size

				size_5[1] = size_2[1]
				size_5[2] = size_2[2]
				size_6[1] = size_3[1]
				size_6[2] = size_3[2]
				size_4[1] = size[1]
				size_4[2] = size[2]
			end,
			update = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				-- function 36
				local easeOutCubic = math.easeOutCubic(arg_36_3)
				local upgrade_bg = arg_36_2.upgrade_bg
				local skull_circle = arg_36_2.skull_circle
				local skull_circle_shade = arg_36_2.skull_circle_shade
				local scenegraph_id = upgrade_bg.scenegraph_id
				local scenegraph_id_2 = skull_circle.scenegraph_id
				local scenegraph_id_3 = skull_circle_shade.scenegraph_id
				local var_36_7 = arg_36_1[scenegraph_id]
				local var_36_8 = arg_36_1[scenegraph_id_2]
				local var_36_9 = arg_36_1[scenegraph_id_3]
				local size = var_36_7.size
				local size_2 = var_36_8.size
				local size_3 = var_36_9.size
				local var_36_13 = self[scenegraph_id]
				local var_36_14 = self[scenegraph_id_2]
				local var_36_15 = self[scenegraph_id_3]
				local size_4 = var_36_13.size
				local size_5 = var_36_14.size
				local size_6 = var_36_15.size
				local num = 600
				local num_2 = 2200

				size_5[1] = size_2[1] + num * easeOutCubic
				size_5[2] = size_2[2] + num * easeOutCubic
				size_6[1] = size_3[1] + num_2 * easeOutCubic
				size_6[2] = size_3[2] + num_2 * easeOutCubic
				size_4[1] = size[1] + 200 * (1 - easeOutCubic)
				size_4[2] = size[2] + 200 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
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
				-- function 38
				arg_38_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				-- function 39
				local easeOutCubic = math.easeOutCubic(arg_39_3)

				arg_39_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
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
				-- function 41
				arg_41_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
				-- function 42
				local easeOutCubic = math.easeOutCubic(arg_42_3)

				arg_42_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				-- function 43
				return
			end
		}
	}
}

return {
	top_widgets = tbl_19,
	bottom_widgets = tbl_16,
	top_hdr_widgets = tbl_17,
	bottom_hdr_widgets = tbl_18,
	scenegraph_definition = tbl_4,
	animation_definitions = tbl_21,
	weapon_crafting_tutorial_definitions = tbl_20
}
