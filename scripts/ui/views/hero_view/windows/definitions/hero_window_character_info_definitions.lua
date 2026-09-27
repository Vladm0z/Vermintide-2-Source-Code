-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_character_info_definitions.lua

local size = UISettings.game_start_windows.size
local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl = {
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	area_left = console_menu_scenegraphs.area_left,
	area_right = console_menu_scenegraphs.area_right,
	area_divider = console_menu_scenegraphs.area_divider,
	portrait_root = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-100,
			70,
			200
		}
	},
	insignia = {
		vertical_alignment = "bottom",
		parent = "portrait_root",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-90,
			0,
			0
		}
	},
	divider_1 = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			2,
			61
		},
		position = {
			-180 - UISettings.INSIGNIA_OFFSET,
			0,
			201
		}
	},
	divider_2 = {
		vertical_alignment = "bottom",
		parent = "divider_1",
		horizontal_alignment = "right",
		size = {
			2,
			61
		},
		position = {
			-0,
			60,
			1
		}
	},
	experience_bar_bg = {
		vertical_alignment = "bottom",
		parent = "divider_1",
		horizontal_alignment = "right",
		size = {
			144,
			8
		},
		position = {
			-20,
			14,
			1
		}
	},
	experience_bar = {
		vertical_alignment = "bottom",
		parent = "experience_bar_bg",
		horizontal_alignment = "left",
		size = {
			144,
			8
		},
		position = {
			0,
			0,
			2
		}
	},
	experience_bar_edge = {
		vertical_alignment = "center",
		parent = "experience_bar",
		horizontal_alignment = "right",
		size = {
			8,
			8
		},
		position = {
			8,
			0,
			3
		}
	},
	level_text = {
		vertical_alignment = "bottom",
		parent = "experience_bar_bg",
		horizontal_alignment = "left",
		size = {
			144,
			0
		},
		position = {
			0,
			10,
			5
		}
	},
	career_name = {
		vertical_alignment = "bottom",
		parent = "divider_2",
		horizontal_alignment = "right",
		size = {
			350,
			0
		},
		position = {
			-20,
			18,
			1
		}
	},
	hero_name = {
		vertical_alignment = "bottom",
		parent = "divider_2",
		horizontal_alignment = "right",
		size = {
			350,
			0
		},
		position = {
			-20,
			46,
			1
		}
	}
}
local tbl_2 = {
	use_shadow = true,
	upper_case = true,
	localize = true,
	font_size = 30,
	horizontal_alignment = "right",
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
local tbl_3 = {
	font_size = 24,
	use_shadow = true,
	localize = true,
	horizontal_alignment = "right",
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
local tbl_4 = {
	use_shadow = true,
	vertical_alignment = "bottom",
	localize = true,
	horizontal_alignment = "center",
	font_size = 20,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_5 = {
	font_size = 24,
	use_shadow = true,
	localize = false,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
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
					1,
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

local tbl_6 = {
	divider_1 = UIWidgets.create_simple_uv_texture("menu_divider", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "divider_1", nil, nil),
	divider_2 = UIWidgets.create_simple_texture("menu_divider", "divider_2", nil, nil, {
		255,
		255,
		255,
		255
	}),
	experience_bar_bg = UIWidgets.create_simple_rect("experience_bar_bg", {
		255,
		10,
		10,
		10
	}),
	experience_bar_edge = UIWidgets.create_simple_texture("experience_bar_edge_glow", "experience_bar_edge"),
	experience_bar = UIWidgets.create_simple_uv_texture("experience_bar_fill", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "experience_bar"),
	career_name = UIWidgets.create_simple_text("n/a", "career_name", 22, nil, tbl_2),
	hero_name = UIWidgets.create_simple_text("n/a", "hero_name", 22, nil, tbl_3),
	level_text = UIWidgets.create_simple_text("n/a", "level_text", 22, nil, tbl_5)
}
local tbl_7 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				local easeOutCubic = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				local easeOutCubic = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end
		}
	}
}

return {
	widgets = tbl_6,
	node_widgets = node_widgets,
	category_settings = category_settings,
	scenegraph_definition = tbl,
	animation_definitions = tbl_7
}
