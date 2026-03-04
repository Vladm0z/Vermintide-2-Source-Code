-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_journey_selection_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = var_0_0.spacing
local var_0_4 = UIFrameSettings[var_0_1].texture_sizes.vertical[1]
local var_0_5 = var_0_2[1] - (var_0_4 * 2 + 60)
local var_0_6 = {
	var_0_2[1] * 2 + var_0_3,
	var_0_2[2]
}
local var_0_7 = {
	var_0_2[1],
	var_0_2[2]
}
local var_0_8 = UISettings.console_menu_scenegraphs
local var_0_9 = {
	var_0_6[1] - 50,
	200
}
local var_0_10 = {
	0,
	-50,
	0
}
local var_0_11 = {
	20,
	0
}
local var_0_12 = {
	var_0_9[1] + var_0_10[1] - var_0_11[1],
	var_0_9[2] + var_0_10[2] - var_0_11[2]
}
local var_0_13 = {
	0 + var_0_10[1],
	0 + var_0_10[2],
	2 + var_0_10[3]
}
local var_0_14 = {
	width = 180,
	spacing_x = 50
}
local var_0_15 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		},
		{
			name = "animate_in_window",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_0.window.local_position[1] = arg_5_1.window.position[1] + math.floor(-100 * (1 - var_5_0))
				arg_5_0.info_window.local_position[1] = arg_5_1.info_window.position[1] + math.floor(-80 * (1 - var_5_0))
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
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
				arg_7_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = math.easeOutCubic(arg_8_3)

				arg_8_4.render_settings.alpha_multiplier = 1 - var_8_0
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		}
	}
}
local var_0_16 = {
	screen = var_0_8.screen,
	area = var_0_8.area,
	area_left = var_0_8.area_left,
	area_right = var_0_8.area_right,
	area_divider = var_0_8.area_divider,
	window = {
		vertical_alignment = "center",
		parent = "area_left",
		horizontal_alignment = "left",
		size = var_0_6,
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
			var_0_6[1],
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
		size = var_0_2,
		position = {
			var_0_7[1] + 25,
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
			var_0_6[1],
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
			var_0_6[1],
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
		size = var_0_9,
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
		size = var_0_12,
		position = var_0_13
	},
	description_text = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			var_0_2[2] / 2
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
			var_0_5,
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
			var_0_5,
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
			var_0_5,
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
local var_0_17 = {
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
local var_0_18 = {
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
local var_0_19 = {
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
local var_0_20 = {
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

local function var_0_21(arg_10_0)
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

local function var_0_22(arg_11_0)
	local var_11_0 = 10
	local var_11_1 = 32
	local var_11_2 = {
		50,
		50
	}
	local var_11_3 = {
		0,
		40,
		0
	}
	local var_11_4 = {
		0,
		-var_11_0 - var_11_2[2] + var_11_3[2],
		0
	}
	local var_11_5 = {
		0,
		-var_11_0 - var_11_1 + var_11_4[2],
		0
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (arg_12_0)
						return arg_12_0.icon ~= nil
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
				texture_size = var_11_2,
				offset = var_11_3,
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
				font_size = var_11_1,
				offset = var_11_4
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
				offset = var_11_5
			}
		},
		scenegraph_id = arg_11_0
	}
end

local function var_0_23(arg_13_0)
	local var_13_0 = UIFrameSettings.frame_outer_fade_01
	local var_13_1 = var_13_0.texture_sizes.horizontal[2]
	local var_13_2 = var_0_16[arg_13_0].size
	local var_13_3 = {
		var_13_2[1] + var_13_1 * 2,
		var_13_2[2] + var_13_1 * 2
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
			frame = var_13_0.texture
		},
		style = {
			frame = {
				color = Colors.get_color_table_with_alpha("console_menu_rect", 128),
				size = var_13_3,
				texture_size = var_13_0.texture_size,
				texture_sizes = var_13_0.texture_sizes,
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

local function var_0_24(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1
	local var_14_1 = {
		180,
		180
	}

	if not var_14_0 then
		var_14_0 = "level_root_" .. arg_14_0
		var_0_16[var_14_0] = {
			vertical_alignment = "center",
			parent = "level_root_node",
			horizontal_alignment = "center",
			size = var_14_1,
			position = {
				0,
				0,
				1
			}
		}
	end

	local var_14_2 = {
		element = {}
	}
	local var_14_3 = {
		{
			style_id = "icon",
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function (arg_15_0)
				return not arg_15_0.parent.locked
			end
		},
		{
			style_id = "icon",
			pass_type = "level_tooltip",
			level_id = "level_data",
			content_check_function = function (arg_16_0)
				return arg_16_0.button_hotspot.is_hover
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
			content_check_function = function (arg_17_0)
				return not arg_17_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_locked",
			texture_id = "icon",
			content_check_function = function (arg_18_0)
				return arg_18_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function (arg_19_0)
				return arg_19_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock_fade",
			texture_id = "lock_fade",
			content_check_function = function (arg_20_0)
				return arg_20_0.locked
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
			content_check_function = function (arg_21_0)
				return arg_21_0.draw_path
			end
		},
		{
			pass_type = "rotated_texture",
			style_id = "path_glow",
			texture_id = "path_glow",
			content_check_function = function (arg_22_0)
				return arg_22_0.draw_path and arg_22_0.draw_path_fill and not arg_22_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "chaos_symbol",
			texture_id = "chaos_symbol",
			content_check_function = function (arg_23_0)
				return arg_23_0.draw_chaos_symbol
			end
		},
		{
			pass_type = "texture",
			style_id = "theme_icon",
			texture_id = "theme_icon",
			content_check_function = function (arg_24_0)
				return arg_24_0.theme_icon ~= nil
			end
		}
	}
	local var_14_4 = {
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
	local var_14_5 = {
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
				var_14_1[1] / 2,
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
				var_14_1[1] / 2,
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

	var_14_2.element.passes = var_14_3
	var_14_2.content = var_14_4
	var_14_2.style = var_14_5
	var_14_2.offset = {
		0,
		0,
		0
	}
	var_14_2.scenegraph_id = var_14_0

	return var_14_2
end

local var_0_25 = {
	level_title = UIWidgets.create_simple_text("level_title", "level_title", nil, nil, var_0_18),
	selected_level = var_0_24(nil, "level_texture_frame"),
	level_title_divider = UIWidgets.create_simple_texture("divider_01_top", "level_title_divider"),
	description_text = UIWidgets.create_simple_text("", "description_text", nil, nil, var_0_17),
	helper_text = UIWidgets.create_simple_text(Localize("tutorial_map"), "helper_text", nil, nil, var_0_19),
	description_background = UIWidgets.create_rect_with_outer_frame("info_window", var_0_16.info_window.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	locked_text = UIWidgets.create_simple_text("", "locked_text", nil, nil, var_0_20),
	modifier_timer = var_0_21("modifier_timer"),
	modifier_info = var_0_23("modifier_info"),
	modifier_info_god = var_0_22("modifier_info_god")
}
local var_0_26 = {}

for iter_0_0 = 1, 20 do
	var_0_26[iter_0_0] = var_0_24(iter_0_0)
end

return {
	widgets = var_0_25,
	node_widgets = var_0_26,
	scenegraph_definition = var_0_16,
	animation_definitions = var_0_15,
	large_window_size = var_0_6,
	journey_widget_settings = var_0_14
}
