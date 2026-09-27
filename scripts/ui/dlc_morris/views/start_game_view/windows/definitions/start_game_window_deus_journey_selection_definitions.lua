-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_journey_selection_definitions.lua

local game_start_windows = UISettings.game_start_windows
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local var_0_4 = UIFrameSettings[frame].texture_sizes.vertical[1]
local num = size[1] - (var_0_4 * 2 + 60)
local tbl = {
	size[1] * 2 + spacing,
	size[2]
}
local tbl_2 = {
	size[1],
	size[2]
}
local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl_3 = {
	tbl[1] - 50,
	200
}
local tbl_4 = {
	0,
	-50,
	0
}
local tbl_5 = {
	20,
	0
}
local tbl_6 = {
	tbl_3[1] + tbl_4[1] - tbl_5[1],
	tbl_3[2] + tbl_4[2] - tbl_5[2]
}
local tbl_7 = {
	0 + tbl_4[1],
	0 + tbl_4[2],
	2 + tbl_4[3]
}
local tbl_8 = {
	width = 180,
	spacing_x = 50
}
local tbl_9 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeOutCubic = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		},
		{
			name = "animate_in_window",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeOutCubic = math.easeOutCubic(arg_5_3)

				arg_5_0.window.local_position[1] = arg_5_1.window.position[1] + math.floor(-100 * (1 - easeOutCubic))
				arg_5_0.info_window.local_position[1] = arg_5_1.info_window.position[1] + math.floor(-80 * (1 - easeOutCubic))
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				arg_7_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local easeOutCubic = math.easeOutCubic(arg_8_3)

				arg_8_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		}
	}
}
local tbl_10 = {
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	area_left = console_menu_scenegraphs.area_left,
	area_right = console_menu_scenegraphs.area_right,
	area_divider = console_menu_scenegraphs.area_divider,
	window = {
		vertical_alignment = "center",
		parent = "area_left",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			100,
			0,
			1
		}
	},
	window_background = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			770
		},
		position = {
			0,
			0,
			0
		}
	},
	info_window = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = size,
		position = {
			tbl_2[1] + 25,
			0,
			1
		}
	},
	level_root_node = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			210,
			0,
			10
		}
	},
	end_level_root_node = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			90,
			0,
			10
		}
	},
	title_divider = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			0
		},
		position = {
			0,
			768,
			14
		}
	},
	mission_selection_title = {
		vertical_alignment = "bottom",
		parent = "title_divider",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			52
		},
		position = {
			0,
			0,
			1
		}
	},
	modifier_timer = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			512,
			100
		},
		position = {
			0,
			0,
			2
		}
	},
	modifier_info = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = tbl_3,
		position = {
			0,
			0,
			2
		}
	},
	modifier_info_god = {
		vertical_alignment = "top",
		parent = "modifier_info",
		horizontal_alignment = "center",
		size = tbl_6,
		position = tbl_7
	},
	description_text = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			num,
			size[2] / 2
		},
		position = {
			0,
			0,
			1
		}
	},
	locked_text = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			num,
			100
		},
		position = {
			0,
			40,
			1
		}
	},
	level_texture_frame = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			-103,
			2
		}
	},
	level_texture = {
		vertical_alignment = "center",
		parent = "level_texture_frame",
		horizontal_alignment = "center",
		size = {
			168,
			168
		},
		position = {
			0,
			0,
			-1
		}
	},
	level_texture_lock = {
		vertical_alignment = "center",
		parent = "level_texture_frame",
		horizontal_alignment = "center",
		size = {
			146,
			146
		},
		position = {
			0,
			0,
			1
		}
	},
	level_title_divider = {
		vertical_alignment = "bottom",
		parent = "level_texture_frame",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-90,
			1
		}
	},
	level_title = {
		vertical_alignment = "bottom",
		parent = "level_title_divider",
		horizontal_alignment = "center",
		size = {
			num,
			50
		},
		position = {
			0,
			20,
			1
		}
	},
	helper_text = {
		vertical_alignment = "bottom",
		parent = "level_title_divider",
		horizontal_alignment = "center",
		size = {
			num,
			50
		},
		position = {
			0,
			-50,
			1
		}
	},
	select_button = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			460,
			72
		},
		position = {
			0,
			18,
			20
		}
	}
}
local tbl_11 = {
	word_wrap = true,
	font_size = 18,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_12 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
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
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_14 = {
	font_size = 22,
	horizontal_alignment = "center",
	localize = false,
	word_wrap = true,
	use_shadow = true,
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		0
	}
}

local function fn(arg_10_0)
	-- function 10
	return {
		element = {
			passes = {
				{
					retained_mode = false,
					style_id = "title",
					pass_type = "text",
					text_id = "title"
				},
				{
					retained_mode = false,
					style_id = "time_text",
					pass_type = "text",
					text_id = "time_text"
				}
			}
		},
		content = {
			time_text = "3 days, 23h 03m",
			title = "deus_start_game_mod_timer_title"
		},
		style = {
			title = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				localize = true,
				font_size = 42,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					-5,
					1
				}
			},
			time_text = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				localize = false,
				font_size = 32,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					5,
					1
				}
			}
		},
		scenegraph_id = arg_10_0
	}
end

local function fn_2(arg_11_0)
	-- function 11
	local num = 10
	local num_2 = 32
	local tbl = {
		50,
		50
	}
	local tbl_2 = {
		0,
		40,
		0
	}
	local tbl_3 = {
		0,
		-num - tbl[2] + tbl_2[2],
		0
	}
	local tbl_4 = {
		0,
		-num - num_2 + tbl_3[2],
		0
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (self)
						-- function 12
						return self.icon ~= nil
					end
				},
				{
					retained_mode = false,
					style_id = "title",
					pass_type = "text",
					text_id = "title"
				},
				{
					retained_mode = false,
					style_id = "description",
					pass_type = "text",
					text_id = "description"
				}
			}
		},
		content = {
			description = "",
			title = ""
		},
		style = {
			icon = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = tbl,
				offset = tbl_2,
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			title = {
				upper_case = true,
				localize = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				font_size = num_2,
				offset = tbl_3
			},
			description = {
				horizontal_alignment = "center",
				font_size = 18,
				localize = false,
				word_wrap = true,
				vertical_alignment = "top",
				dynamic_font_size = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = tbl_4
			}
		},
		scenegraph_id = arg_11_0
	}
end

local function fn_3(arg_13_0)
	-- function 13
	local frame_outer_fade_01 = UIFrameSettings.frame_outer_fade_01
	local var_13_1 = frame_outer_fade_01.texture_sizes.horizontal[2]
	local size = tbl_10[arg_13_0].size
	local tbl = {
		size[1] + var_13_1 * 2,
		size[2] + var_13_1 * 2
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					style_id = "rect",
					pass_type = "rect",
					retained_mode = false
				}
			}
		},
		content = {
			title = "deus_start_game_mod_info_title",
			frame = frame_outer_fade_01.texture
		},
		style = {
			frame = {
				color = Colors.get_color_table_with_alpha("console_menu_rect", 128),
				size = tbl,
				texture_size = frame_outer_fade_01.texture_size,
				texture_sizes = frame_outer_fade_01.texture_sizes,
				offset = {
					-var_13_1,
					-var_13_1,
					0
				}
			},
			rect = {
				color = Colors.get_color_table_with_alpha("console_menu_rect", 128),
				offset = {
					0,
					0,
					0
				}
			},
			title = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				localize = true,
				font_size = 22,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					-10,
					0,
					1
				}
			}
		},
		scenegraph_id = arg_13_0
	}
end

local function fn_4(arg_14_0, arg_14_1)
	-- function 14
	local var_14_0 = arg_14_1
	local tbl = {
		180,
		180
	}

	if not var_14_0 then
		var_14_0 = "level_root_" .. arg_14_0
		tbl_10[var_14_0] = {
			vertical_alignment = "center",
			parent = "level_root_node",
			horizontal_alignment = "center",
			size = tbl,
			position = {
				0,
				0,
				1
			}
		}
	end

	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
		{
			style_id = "icon",
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function (self)
				-- function 15
				return not self.parent.locked
			end
		},
		{
			style_id = "icon",
			pass_type = "level_tooltip",
			level_id = "level_data",
			content_check_function = function (self)
				-- function 16
				return self.button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_glow",
			texture_id = "icon_glow"
		},
		{
			pass_type = "texture",
			style_id = "icon_unlock_guidance_glow",
			texture_id = "icon_unlock_guidance_glow"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (self)
				-- function 17
				return not self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_locked",
			texture_id = "icon",
			content_check_function = function (self)
				-- function 18
				return self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function (self)
				-- function 19
				return self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock_fade",
			texture_id = "lock_fade",
			content_check_function = function (self)
				-- function 20
				return self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "rotated_texture",
			style_id = "path",
			texture_id = "path",
			content_check_function = function (self)
				-- function 21
				return self.draw_path
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "path_glow",
			texture_id = "path_glow",
			content_check_function = function (self)
				-- function 22
				local draw_path = self.draw_path

				if not draw_path then
					draw_path = self.draw_path_fill
					draw_path = not draw_path and not self.locked
				end

				return draw_path
			end
		},
		{
			pass_type = "texture",
			style_id = "chaos_symbol",
			texture_id = "chaos_symbol",
			content_check_function = function (self)
				-- function 23
				return self.draw_chaos_symbol
			end
		},
		{
			pass_type = "texture",
			style_id = "theme_icon",
			texture_id = "theme_icon",
			content_check_function = function (self)
				-- function 24
				return self.theme_icon ~= nil
			end
		}
	}
	local tbl_4 = {
		frame = "map_frame_00",
		locked = true,
		lock = "map_frame_lock",
		draw_path = false,
		path_glow = "mission_select_screen_trail_fill",
		draw_path_fill = false,
		path = "mission_select_screen_trail",
		icon_glow = "map_frame_glow_02",
		icon_unlock_guidance_glow = "map_frame_glow_03",
		chaos_symbol = "map_frame_chaos_slot_01",
		lock_fade = "map_frame_fade",
		icon = "level_icon_01",
		draw_chaos_symbol = true,
		button_hotspot = {}
	}
	local tbl_5 = {
		path = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			angle = 0,
			pivot = {
				0,
				6.5
			},
			texture_size = {
				216,
				13
			},
			offset = {
				tbl[1] / 2,
				0,
				1
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		path_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			angle = 0,
			pivot = {
				0,
				21.5
			},
			texture_size = {
				216,
				43
			},
			offset = {
				tbl[1] / 2,
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
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				180,
				180
			},
			offset = {
				0,
				0,
				6
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				180,
				180
			},
			offset = {
				0,
				0,
				9
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock_fade = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				180,
				180
			},
			offset = {
				0,
				0,
				5
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
			texture_size = {
				168,
				168
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
				3
			}
		},
		icon_locked = {
			vertical_alignment = "center",
			saturated = true,
			horizontal_alignment = "center",
			texture_size = {
				168,
				168
			},
			color = {
				255,
				100,
				100,
				100
			},
			offset = {
				0,
				0,
				3
			}
		},
		icon_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				270,
				270
			},
			offset = {
				0,
				0,
				4
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		icon_unlock_guidance_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				180,
				180
			},
			offset = {
				0,
				0,
				7
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		chaos_symbol = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				110,
				110
			},
			offset = {
				0,
				90,
				8
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		theme_icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				50,
				50
			},
			offset = {
				0,
				90,
				8
			},
			color = {
				255,
				255,
				255,
				255
			}
		}
	}

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = var_14_0

	return tbl_2
end

local tbl_15 = {
	level_title = UIWidgets.create_simple_text("level_title", "level_title", nil, nil, tbl_12),
	selected_level = fn_4(nil, "level_texture_frame"),
	level_title_divider = UIWidgets.create_simple_texture("divider_01_top", "level_title_divider"),
	description_text = UIWidgets.create_simple_text("", "description_text", nil, nil, tbl_11),
	helper_text = UIWidgets.create_simple_text(Localize("tutorial_map"), "helper_text", nil, nil, tbl_13),
	description_background = UIWidgets.create_rect_with_outer_frame("info_window", tbl_10.info_window.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	locked_text = UIWidgets.create_simple_text("", "locked_text", nil, nil, tbl_14),
	modifier_timer = fn("modifier_timer"),
	modifier_info = fn_3("modifier_info"),
	modifier_info_god = fn_2("modifier_info_god")
}
local tbl_16 = {}

for i = 1, 20 do
	tbl_16[i] = fn_4(i)
end

return {
	widgets = tbl_15,
	node_widgets = tbl_16,
	scenegraph_definition = tbl_10,
	animation_definitions = tbl_9,
	large_window_size = tbl,
	journey_widget_settings = tbl_8
}
