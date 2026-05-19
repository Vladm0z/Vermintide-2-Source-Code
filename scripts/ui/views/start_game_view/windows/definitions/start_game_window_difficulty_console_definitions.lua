-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_difficulty_console_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = UIFrameSettings[var_0_1].texture_sizes.vertical[1]
local var_0_4 = UIFrameSettings[var_0_1].texture_sizes.horizontal[2]
local var_0_5 = var_0_2[1] - (var_0_3 * 2 + 60)
local var_0_6 = {
	var_0_2[1],
	150
}
local var_0_7 = 0
local var_0_8 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		},
		{
			name = "animate_in_window",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_0.window.local_position[1] = arg_5_1.window.position[1] + math.floor(-100 * (1 - var_5_0))
				arg_5_0.info_window.local_position[1] = arg_5_1.info_window.position[1] + math.floor(-80 * (1 - var_5_0))
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				arg_7_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				arg_8_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		}
	}
}
local var_0_9 = {
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
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			220,
			0,
			1
		}
	},
	info_window = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1],
			var_0_2[2]
		},
		position = {
			var_0_2[1] + 200,
			50,
			1
		}
	},
	background = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1],
			800
		},
		position = {
			0,
			-45,
			0
		}
	},
	difficulty_root = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-80,
			-var_0_4 / 2,
			1
		}
	},
	difficulty_option = {
		vertical_alignment = "top",
		parent = "difficulty_root",
		horizontal_alignment = "left",
		size = var_0_6,
		position = {
			0,
			0,
			0
		}
	},
	difficulty_texture = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			150,
			150
		},
		position = {
			0,
			-30,
			1
		}
	},
	difficulty_title = {
		vertical_alignment = "bottom",
		parent = "difficulty_texture",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			50
		},
		position = {
			0,
			-70,
			1
		}
	},
	difficulty_title_divider = {
		vertical_alignment = "top",
		parent = "difficulty_title",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-50,
			1
		}
	},
	description_background = {
		vertical_alignment = "top",
		parent = "difficulty_title_divider",
		horizontal_alignment = "center",
		size = {
			264,
			200
		},
		position = {
			0,
			0,
			1
		}
	},
	description_text = {
		vertical_alignment = "center",
		parent = "description_background",
		horizontal_alignment = "center",
		size = {
			var_0_5 + 40,
			120
		},
		position = {
			0,
			20,
			1
		}
	},
	rewards_title = {
		vertical_alignment = "top",
		parent = "description_background",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			30
		},
		position = {
			0,
			-160,
			0
		}
	},
	difficulty_xp_multiplier = {
		vertical_alignment = "top",
		parent = "rewards_title",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			20
		},
		position = {
			0,
			-30,
			0
		}
	},
	difficulty_rewards_anchor = {
		vertical_alignment = "top",
		parent = "difficulty_xp_multiplier",
		horizontal_alignment = "center",
		size = {
			0,
			40
		},
		position = {
			0,
			-35,
			1
		}
	},
	difficulty_chest_info = {
		vertical_alignment = "top",
		parent = "difficulty_rewards_anchor",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			20
		},
		position = {
			0,
			-65,
			0
		}
	},
	difficulty_bottom_divider = {
		vertical_alignment = "top",
		parent = "difficulty_chest_info",
		horizontal_alignment = "center",
		size = {
			264,
			21
		},
		position = {
			0,
			-20,
			1
		}
	},
	difficulty_is_locked_text = {
		vertical_alignment = "top",
		parent = "difficulty_bottom_divider",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			20
		},
		position = {
			0,
			-70,
			0
		}
	},
	difficulty_lock_text = {
		vertical_alignment = "top",
		parent = "difficulty_is_locked_text",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			20
		},
		position = {
			0,
			0,
			0
		}
	},
	requirement_bg = {
		vertical_alignment = "top",
		parent = "difficulty_lock_text",
		horizontal_alignment = "center",
		size = {
			var_0_2[1],
			100
		},
		position = {
			0,
			0,
			1
		}
	},
	buy_button = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			477,
			91
		},
		position = {
			0,
			-10,
			40
		}
	},
	title_button_start = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			800,
			30
		},
		position = {
			0,
			-70,
			1
		}
	}
}
local var_0_10 = {
	word_wrap = false,
	upper_case = true,
	localize = false,
	font_size = 26,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = {
		255,
		246,
		56,
		53
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_11 = {
	font_size = 42,
	upper_case = true,
	localize = false,
	use_shadow = true,
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
local var_0_12 = {
	font_size = 32,
	upper_case = true,
	localize = false,
	use_shadow = true,
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
local var_0_13 = {
	word_wrap = true,
	font_size = 18,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_14 = {
	font_size = 20,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		250,
		250,
		250
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_15 = {
	font_size = 18,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		250,
		250,
		250
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_16 = {
	font_size = 18,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		199,
		199,
		199
	},
	offset = {
		0,
		-30,
		2
	}
}
local var_0_17 = {
	font_size = 18,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = {
		255,
		199,
		199,
		199
	},
	offset = {
		0,
		-60,
		2
	}
}
local var_0_18 = {
	font_size = 20,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		220,
		148,
		64
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_19 = {
	font_size = 20,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		193,
		90,
		36
	},
	offset = {
		0,
		25,
		2
	}
}

local function var_0_20(arg_10_0, arg_10_1)
	local var_10_0 = 0.8
	local var_10_1 = "difficulty_option_1"
	local var_10_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_10_1)
	local var_10_3 = {
		math.floor(var_10_2.size[1] * var_10_0),
		math.floor(var_10_2.size[2] * var_10_0)
	}
	local var_10_4 = {
		math.floor(180 * var_10_0),
		math.floor(180 * var_10_0)
	}
	local var_10_5 = {
		math.floor(270 * var_10_0),
		math.floor(270 * var_10_0)
	}
	local var_10_6 = {
		math.floor(414),
		math.floor(118 * var_10_0)
	}
	local var_10_7 = {
		var_10_4[1] + 15,
		0,
		-2
	}
	local var_10_8 = {
		var_10_7[1] + 30,
		0,
		5
	}
	local var_10_9 = {}
	local var_10_10 = {}
	local var_10_11 = {}
	local var_10_12 = "button_hotspot"

	var_10_9[#var_10_9 + 1] = {
		pass_type = "hotspot",
		content_id = var_10_12
	}
	var_10_10[var_10_12] = {}

	local var_10_13 = "selection_background"

	var_10_9[#var_10_9 + 1] = {
		pass_type = "texture_uv",
		content_id = var_10_13,
		style_id = var_10_13
	}
	var_10_10[var_10_13] = {
		texture_id = "item_slot_side_fade",
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
	var_10_11[var_10_13] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = var_10_6,
		color = UISettings.console_start_game_menu_rect_color,
		offset = var_10_7
	}

	local var_10_14 = "bg_effect"

	var_10_9[#var_10_9 + 1] = {
		pass_type = "texture",
		texture_id = var_10_14,
		style_id = var_10_14,
		content_check_function = function(arg_11_0)
			return arg_11_0.is_selected
		end
	}
	var_10_11[var_10_14] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			var_10_6[1],
			var_10_6[2] + 8
		},
		color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			var_10_7[1],
			var_10_7[2],
			var_10_7[3] + 1
		}
	}
	var_10_10[var_10_14] = "item_slot_side_effect"

	local var_10_15 = "text_title"
	local var_10_16 = var_10_15 .. "_shadow"

	var_10_9[#var_10_9 + 1] = {
		pass_type = "text",
		text_id = var_10_15,
		style_id = var_10_15,
		content_change_function = function(arg_12_0, arg_12_1)
			if arg_12_0.is_selected then
				arg_12_1.text_color = arg_12_1.selected_color
			else
				arg_12_1.text_color = arg_12_1.default_color
			end
		end
	}
	var_10_9[#var_10_9 + 1] = {
		pass_type = "text",
		text_id = var_10_15,
		style_id = var_10_16
	}
	var_10_10[var_10_15] = "n/a"

	local var_10_17 = {
		word_wrap = false,
		upper_case = true,
		localize = false,
		font_size = 42,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark_header",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		selected_color = Colors.get_color_table_with_alpha("white", 255),
		default_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			var_10_8[1],
			var_10_8[2],
			var_10_8[3]
		}
	}
	local var_10_18 = table.clone(var_10_17)

	var_10_18.text_color = {
		255,
		0,
		0,
		0
	}
	var_10_18.offset = {
		var_10_8[1] + 2,
		var_10_8[2] - 2,
		var_10_8[3] - 1
	}
	var_10_11[var_10_15] = var_10_17
	var_10_11[var_10_16] = var_10_18

	local var_10_19 = "icon_texture"

	var_10_9[#var_10_9 + 1] = {
		pass_type = "texture",
		style_id = var_10_19,
		texture_id = var_10_19,
		content_check_function = function(arg_13_0, arg_13_1)
			return arg_13_0[var_10_19]
		end,
		content_change_function = function(arg_14_0, arg_14_1)
			if arg_14_0.locked then
				arg_14_1.saturated = true
			else
				arg_14_1.saturated = false
			end
		end
	}
	var_10_10[var_10_19] = var_10_1

	local var_10_20 = {
		-(arg_10_1[1] / 2) + 108,
		0,
		5
	}

	var_10_11[var_10_19] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_10_3,
		color = {
			255,
			255,
			255,
			255
		},
		offset = var_10_20
	}
	var_10_10.icon_locked_z_offset = 1
	var_10_10.icon_unlocked_z_offset = 5

	local var_10_21 = "icon_background"

	var_10_9[#var_10_9 + 1] = {
		pass_type = "texture",
		texture_id = var_10_21,
		style_id = var_10_21
	}
	var_10_10[var_10_21] = "level_icon_09"
	var_10_11[var_10_21] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_10_3,
		color = UISettings.console_start_game_menu_rect_color,
		offset = {
			var_10_20[1],
			var_10_20[2],
			var_10_20[3] - 6
		}
	}

	local var_10_22 = "icon_frame_texture"

	var_10_9[#var_10_9 + 1] = {
		pass_type = "texture",
		style_id = var_10_22,
		texture_id = var_10_22,
		content_check_function = function(arg_15_0, arg_15_1)
			return arg_15_0[var_10_19]
		end,
		content_change_function = function(arg_16_0, arg_16_1)
			if arg_16_0.locked then
				arg_16_1.saturated = true
			else
				arg_16_1.saturated = false
			end
		end
	}
	var_10_10[var_10_22] = "map_frame_00"
	var_10_11[var_10_22] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_10_4,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_10_20[1],
			var_10_20[2],
			var_10_20[3] - 1
		}
	}

	local var_10_23 = "icon_texture_glow"

	var_10_9[#var_10_9 + 1] = {
		pass_type = "texture",
		style_id = var_10_23,
		texture_id = var_10_23,
		content_check_function = function(arg_17_0)
			return arg_17_0.is_selected
		end
	}
	var_10_10[var_10_23] = "map_frame_glow_02"
	var_10_11[var_10_23] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_10_5,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_10_20[1],
			var_10_20[2],
			var_10_20[3] - 5
		}
	}
	var_10_9[#var_10_9 + 1] = {
		pass_type = "texture",
		style_id = "lock",
		texture_id = "lock",
		content_check_function = function(arg_18_0)
			return arg_18_0.locked
		end
	}
	var_10_9[#var_10_9 + 1] = {
		pass_type = "texture",
		style_id = "lock_fade",
		texture_id = "lock_fade",
		content_check_function = function(arg_19_0)
			return arg_19_0.locked
		end
	}
	var_10_10.lock = "map_frame_lock"
	var_10_10.lock_fade = "map_frame_fade"
	var_10_11.lock = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_10_4,
		offset = {
			var_10_20[1],
			var_10_20[2],
			var_10_20[3] + 3
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	var_10_11.lock_fade = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_10_4,
		offset = {
			var_10_20[1],
			var_10_20[2],
			var_10_20[3] - 2
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	return {
		element = {
			passes = var_10_9
		},
		content = var_10_10,
		style = var_10_11,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_10_0
	}
end

local function var_0_21(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	local var_20_0 = {
		2,
		-2,
		3
	}

	if arg_20_3 then
		var_20_0[1] = var_20_0[1] + arg_20_3[1]
		var_20_0[2] = var_20_0[2] + arg_20_3[2]
		var_20_0[3] = arg_20_3[3] - 1
	end

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_field"
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_21_0)
						return not arg_21_0.button_hotspot.disable_button and (arg_21_0.button_hotspot.is_hover or arg_21_0.button_hotspot.is_selected)
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_22_0)
						return not arg_22_0.button_hotspot.disable_button and not arg_22_0.button_hotspot.is_hover and not arg_22_0.button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function(arg_23_0)
						return arg_23_0.button_hotspot.disable_button
					end
				}
			}
		},
		content = {
			button_hotspot = {},
			text_field = arg_20_1,
			default_font_size = arg_20_2
		},
		style = {
			text = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_20_2,
				horizontal_alignment = arg_20_4 or "left",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = arg_20_3 or {
					0,
					0,
					4
				}
			},
			text_shadow = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_20_2,
				horizontal_alignment = arg_20_4 or "left",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = var_20_0
			},
			text_hover = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_20_2,
				horizontal_alignment = arg_20_4 or "left",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = arg_20_3 or {
					0,
					0,
					4
				}
			},
			text_disabled = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_20_2,
				horizontal_alignment = arg_20_4 or "left",
				text_color = Colors.get_color_table_with_alpha("gray", 50),
				offset = arg_20_3 or {
					0,
					0,
					4
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_20_0
	}
end

local function var_0_22(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0 = {}
	local var_24_1 = {}
	local var_24_2 = {}
	local var_24_3 = {}
	local var_24_4 = {}
	local var_24_5 = 52
	local var_24_6 = 16
	local var_24_7 = var_24_5 + var_24_6 * 1.5
	local var_24_8 = (arg_24_2 - 1 - (arg_24_3 - 0.5) * 0.5) * var_24_7
	local var_24_9 = arg_24_2 ~= arg_24_3

	var_24_2[#var_24_2 + 1] = {
		pass_type = "texture",
		style_id = "icon",
		texture_id = "icon"
	}
	var_24_2[#var_24_2 + 1] = {
		pass_type = "texture",
		style_id = "frame",
		texture_id = "frame"
	}
	var_24_2[#var_24_2 + 1] = {
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot"
	}
	var_24_2[#var_24_2 + 1] = {
		pass_type = "texture",
		style_id = "reward_hover",
		texture_id = "reward_hover",
		content_check_function = function(arg_25_0)
			return arg_25_0.hotspot.is_hover and arg_25_0.item and arg_25_0.tooltip
		end
	}
	var_24_2[#var_24_2 + 1] = {
		item_id = "item",
		style_id = "tooltip",
		pass_type = "item_tooltip",
		text_id = "tooltip",
		content_check_function = function(arg_26_0)
			return arg_26_0.hotspot.is_hover and arg_26_0.item and arg_26_0.tooltip
		end
	}

	if var_24_9 then
		var_24_2[#var_24_2 + 1] = {
			pass_type = "texture",
			style_id = "separator",
			texture_id = "separator"
		}
	end

	local var_24_10 = ItemMasterList[arg_24_1]

	var_24_3.tooltip = "tooltip_text"
	var_24_3.item_tooltip = {}
	var_24_3.hotspot = {}
	var_24_3.frame = "button_frame_01"
	var_24_3.icon = var_24_10.inventory_icon or "icons_placeholder"
	var_24_3.visible = false
	var_24_3.difficulty_key = arg_24_0
	var_24_3.item = {
		data = var_24_10
	}
	var_24_3.force_equipped = nil
	var_24_3.reward_hover = "item_icon_hover"

	if var_24_9 then
		var_24_3.separator = "menu_frame_12_divider_middle"
	end

	var_24_4.icon = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		color = {
			255,
			255,
			255,
			255
		},
		texture_size = {
			var_24_5,
			var_24_5
		},
		offset = {
			0,
			0,
			0
		}
	}
	var_24_4.frame = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		color = {
			255,
			255,
			255,
			255
		},
		texture_size = {
			var_24_5,
			var_24_5
		},
		offset = {
			0,
			0,
			1
		}
	}
	var_24_4.tooltip = {
		font_size = 18,
		font_type = "hell_shark",
		localize = true,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		max_width = 1500,
		size = {
			400,
			0
		},
		text_color = Colors.get_color_table_with_alpha("white", 255),
		line_colors = {
			Colors.get_color_table_with_alpha("font_title", 255),
			Colors.get_color_table_with_alpha("white", 255)
		}
	}
	var_24_4.hotspot = {
		size = {
			var_24_5,
			var_24_5
		},
		offset = {
			0,
			-12,
			0
		}
	}
	var_24_4.reward_hover = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			var_24_5 * 1.6,
			var_24_5 * 1.6
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			-15,
			15,
			1
		}
	}

	if var_24_9 then
		var_24_4.separator = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = {
				255,
				255,
				255,
				255
			},
			texture_size = {
				var_24_6,
				var_24_6
			},
			offset = {
				var_24_5 * 0.5 + var_24_7 * 0.5 - var_24_6 * 0.5,
				-var_24_5 * 0.5 + var_24_6 * 0.5,
				1
			}
		}
	end

	var_24_1.passes = var_24_2
	var_24_0.element = var_24_1
	var_24_0.content = var_24_3
	var_24_0.style = var_24_4
	var_24_0.scenegraph_id = "difficulty_rewards_anchor"
	var_24_0.offset = {
		var_24_8,
		0,
		2
	}

	return var_24_0
end

local var_0_23 = {}
local var_0_24 = 10

for iter_0_0 = 1, var_0_24 do
	var_0_23[iter_0_0] = var_0_21("title_button_start", "n/a", 32, nil, "center")
end

local var_0_25 = {
	background = UIWidgets.create_rect_with_outer_frame("background", var_0_9.background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	difficulty_texture = UIWidgets.create_simple_texture("difficulty_option_1", "difficulty_texture"),
	difficulty_title = UIWidgets.create_simple_text(Localize("start_game_window_difficulty"), "difficulty_title", nil, nil, var_0_11),
	difficulty_title_divider = UIWidgets.create_simple_texture("divider_01_top", "difficulty_title_divider"),
	description_text = UIWidgets.create_simple_text(Localize("start_game_window_adventure_desc"), "description_text", nil, nil, var_0_13),
	difficulty_bottom_divider = UIWidgets.create_simple_texture("divider_01_bottom", "difficulty_bottom_divider"),
	rewards_title = UIWidgets.create_simple_text(Localize("deed_reward_title"), "rewards_title", nil, nil, var_0_12),
	difficulty_chest_info = UIWidgets.create_simple_text("", "difficulty_chest_info", nil, nil, var_0_14),
	xp_multiplier = UIWidgets.create_simple_text("", "difficulty_xp_multiplier", nil, nil, var_0_15),
	difficulty_lock_text = UIWidgets.create_simple_text("difficulty_lock_text", "difficulty_is_locked_text", nil, nil, var_0_16),
	difficulty_is_locked_text = UIWidgets.create_simple_text("Some people in your party do not meet the required Hero Power.", "difficulty_is_locked_text", nil, nil, var_0_18),
	difficulty_second_lock_text = UIWidgets.create_simple_text("KIll all the lords on Legend Difficulty", "requirement_bg", nil, nil, var_0_17),
	dlc_lock_text = UIWidgets.create_simple_text(Localize("cataclysm_no_wom"), "buy_button", nil, nil, var_0_19),
	buy_button = create_buy_button("buy_button", var_0_9.buy_button.size, nil, "wom_button", Localize("menu_weave_area_no_wom_button"), 32, nil, nil, nil, false)
}

return {
	widgets = var_0_25,
	title_button_definitions = var_0_23,
	create_difficulty_button = var_0_20,
	scenegraph_definition = var_0_9,
	animation_definitions = var_0_8,
	create_difficulty_reward_widget = var_0_22
}
