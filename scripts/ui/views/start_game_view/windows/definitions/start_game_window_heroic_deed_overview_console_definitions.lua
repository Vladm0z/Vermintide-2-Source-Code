-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_heroic_deed_overview_console_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = UIFrameSettings[var_0_1].texture_sizes.horizontal[2]
local var_0_4 = {
	var_0_2[1],
	194
}
local var_0_5 = var_0_2[1]
local var_0_6 = {
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
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				arg_5_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}
local var_0_7 = {
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
	window_game_mode_root = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1],
			var_0_3
		},
		position = {
			0,
			-var_0_3,
			1
		}
	},
	heroic_deed_background = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] + 70,
			500
		},
		position = {
			0,
			0,
			1
		}
	},
	heroic_deed_title = {
		vertical_alignment = "top",
		parent = "heroic_deed_background",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			50
		},
		position = {
			0,
			-30,
			1
		}
	},
	heroic_deed_divider = {
		vertical_alignment = "top",
		parent = "heroic_deed_title",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-36,
			1
		}
	},
	heroic_deed_description = {
		vertical_alignment = "top",
		parent = "heroic_deed_divider",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			200
		},
		position = {
			0,
			-36,
			1
		}
	},
	game_option_3 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2]
		},
		position = {
			-15,
			-90,
			1
		}
	},
	game_option_2 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2]
		},
		position = {
			-15,
			-90 + var_0_4[2],
			1
		}
	},
	game_option_1 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2]
		},
		position = {
			-15,
			-90 + var_0_4[2] * 2,
			1
		}
	},
	play_button_console = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2]
		},
		position = {
			0,
			-58,
			1
		}
	},
	play_button = {
		vertical_alignment = "center",
		parent = "play_button_console",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-165,
			0,
			1
		}
	}
}

local function var_0_8(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	arg_7_3 = arg_7_3 or "level_icon_01"

	local var_7_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_7_3)
	local var_7_1 = var_7_0 and var_7_0.size or {
		150,
		150
	}
	local var_7_2 = var_0_7[arg_7_0].size
	local var_7_3 = {}
	local var_7_4 = {}
	local var_7_5 = {}
	local var_7_6 = "button_hotspot"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "hotspot",
		content_id = var_7_6
	}
	var_7_4[var_7_6] = {}

	local var_7_7 = "selection_background"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "texture_uv",
		content_id = var_7_7,
		style_id = var_7_7
	}
	var_7_4[var_7_7] = {
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

	local var_7_8 = {
		168,
		0,
		-2
	}

	var_7_5[var_7_7] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			414,
			118
		},
		color = UISettings.console_start_game_menu_rect_color,
		offset = var_7_8
	}

	local var_7_9 = "bg_effect"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "texture",
		texture_id = var_7_9,
		style_id = var_7_9,
		content_check_function = function(arg_8_0)
			return arg_8_0.is_selected
		end
	}
	var_7_5[var_7_9] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			414,
			126
		},
		color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			var_7_8[1],
			var_7_8[2],
			var_7_8[3] + 1
		}
	}
	var_7_4[var_7_9] = "item_slot_side_effect"

	local var_7_10 = "text_title"
	local var_7_11 = var_7_10 .. "_shadow"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "text",
		text_id = var_7_10,
		style_id = var_7_10,
		content_change_function = function(arg_9_0, arg_9_1)
			if arg_9_0.is_selected then
				arg_9_1.text_color = arg_9_1.selected_color
			else
				arg_9_1.text_color = arg_9_1.default_color
			end
		end
	}
	var_7_3[#var_7_3 + 1] = {
		pass_type = "text",
		text_id = var_7_10,
		style_id = var_7_11
	}
	var_7_4[var_7_10] = arg_7_1

	local var_7_12 = {
		225,
		16,
		5
	}
	local var_7_13 = {
		word_wrap = false,
		upper_case = true,
		localize = false,
		font_size = 32,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark_header",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		selected_color = Colors.get_color_table_with_alpha("white", 255),
		default_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			var_7_12[1],
			var_7_12[2],
			var_7_12[3]
		}
	}
	local var_7_14 = table.clone(var_7_13)

	var_7_14.text_color = {
		255,
		0,
		0,
		0
	}
	var_7_14.offset = {
		var_7_12[1] + 2,
		var_7_12[2] - 2,
		var_7_12[3] - 1
	}
	var_7_5[var_7_10] = var_7_13
	var_7_5[var_7_11] = var_7_14

	local var_7_15 = "input_text"
	local var_7_16 = var_7_15 .. "shadow"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "text",
		text_id = var_7_15,
		style_id = var_7_15
	}
	var_7_3[#var_7_3 + 1] = {
		pass_type = "text",
		text_id = var_7_15,
		style_id = var_7_16
	}
	var_7_4[var_7_15] = Localize("not_assigned")

	local var_7_17 = {
		vertical_alignment = "center",
		font_size = 22,
		localize = false,
		horizontal_alignment = "left",
		word_wrap = false,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			var_7_12[1],
			-18,
			var_7_12[3]
		}
	}
	local var_7_18 = var_7_17.offset
	local var_7_19 = table.clone(var_7_17)

	var_7_19.text_color = {
		255,
		0,
		0,
		0
	}
	var_7_19.offset = {
		var_7_18[1] + 2,
		var_7_18[2] - 2,
		var_7_18[3] - 1
	}
	var_7_5[var_7_15] = var_7_17
	var_7_5[var_7_16] = var_7_19

	local var_7_20 = {
		-(var_7_2[1] / 2) + 108,
		0,
		5
	}
	local var_7_21 = {
		var_7_20[1],
		var_7_20[2],
		var_7_20[3] - 2
	}
	local var_7_22 = {
		var_7_20[1],
		var_7_20[2],
		var_7_20[3] + 2
	}
	local var_7_23 = {
		var_7_20[1],
		var_7_20[2],
		var_7_20[3] - 1
	}
	local var_7_24 = "icon_texture"
	local var_7_25 = "icon_texture_frame"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "texture",
		style_id = var_7_24,
		texture_id = var_7_24,
		content_check_function = function(arg_10_0, arg_10_1)
			return arg_10_0[var_7_24]
		end,
		content_change_function = function(arg_11_0, arg_11_1)
			if arg_11_0.button_hotspot.disable_button then
				arg_11_1.saturated = true
			else
				arg_11_1.saturated = false
			end
		end
	}
	var_7_3[#var_7_3 + 1] = {
		pass_type = "texture",
		texture_id = var_7_25,
		style_id = var_7_25,
		content_check_function = function(arg_12_0, arg_12_1)
			return arg_12_0[var_7_24]
		end
	}
	var_7_4[var_7_24] = nil
	var_7_4[var_7_25] = "item_frame"
	var_7_5[var_7_24] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_7_1,
		color = {
			255,
			255,
			255,
			255
		},
		offset = var_7_20
	}
	var_7_5[var_7_25] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			80,
			80
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = var_7_20
	}

	local var_7_26 = "icon_background"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "texture",
		texture_id = var_7_26,
		style_id = var_7_26
	}
	var_7_4[var_7_26] = "level_icon_09"
	var_7_5[var_7_26] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			150,
			150
		},
		color = UISettings.console_start_game_menu_rect_color,
		offset = var_7_21
	}

	local var_7_27 = "icon_frame_texture"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "texture",
		style_id = var_7_27,
		texture_id = var_7_27,
		content_check_function = function(arg_13_0, arg_13_1)
			return arg_13_0[var_7_27]
		end,
		content_change_function = function(arg_14_0, arg_14_1)
			if arg_14_0.button_hotspot.disable_button then
				arg_14_1.saturated = true
			else
				arg_14_1.saturated = false
			end
		end
	}
	var_7_4[var_7_27] = arg_7_4 or "map_frame_00"
	var_7_5[var_7_27] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			180,
			180
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = var_7_22
	}

	local var_7_28 = "icon_texture_glow"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "texture",
		style_id = var_7_28,
		texture_id = var_7_28,
		content_check_function = function(arg_15_0)
			return arg_15_0.is_selected
		end
	}
	var_7_4[var_7_28] = "map_frame_glow_02"
	var_7_5[var_7_28] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			270,
			270
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = var_7_23
	}

	return {
		element = {
			passes = var_7_3
		},
		content = var_7_4,
		style = var_7_5,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_7_0
	}
end

local var_0_9 = {
	font_size = 50,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = false,
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
local var_0_10 = {
	font_size = 28,
	upper_case = false,
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
local var_0_11 = {
	heroic_deed_description_background = UIWidgets.create_rect_with_outer_frame("heroic_deed_background", var_0_7.heroic_deed_background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	heroic_deed_title = UIWidgets.create_simple_text(Localize("start_game_window_mutator_title"), "heroic_deed_title", nil, nil, var_0_9),
	heroic_deed_divider = UIWidgets.create_simple_texture("divider_01_top", "heroic_deed_divider"),
	heroic_deed_description = UIWidgets.create_simple_text(Localize("start_game_window_mutator_desc"), "heroic_deed_description", nil, nil, var_0_10),
	heroic_deed_setting = var_0_8("game_option_2", Localize("start_game_window_mutator_title"), nil, "icon_deed_normal_01"),
	play_button = UIWidgets.create_icon_and_name_button("play_button", "options_button_icon_quickplay", Localize("start_game_window_play"))
}
local var_0_12 = {
	"heroic_deed_setting",
	"play_button"
}

return {
	scenegraph_definition = var_0_7,
	widgets = var_0_11,
	animation_definitions = var_0_6,
	selector_input_definition = var_0_12
}
