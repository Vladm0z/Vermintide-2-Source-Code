-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_heroic_deed_overview_console_definitions.lua

local game_start_windows = UISettings.game_start_windows
local frame = game_start_windows.frame
local size = game_start_windows.size
local var_0_3 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local tbl = {
	size[1],
	194
}
local var_0_5 = size[1]
local tbl_2 = {
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
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				arg_5_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		}
	}
}
local tbl_3 = {
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
		size = size,
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
			size[1],
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
			size[1] + 70,
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
			tbl[1],
			tbl[2]
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
			tbl[1],
			tbl[2]
		},
		position = {
			-15,
			-90 + tbl[2],
			1
		}
	},
	game_option_1 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			tbl[2]
		},
		position = {
			-15,
			-90 + tbl[2] * 2,
			1
		}
	},
	play_button_console = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			tbl[2]
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

local function fn(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	arg_7_3 = arg_7_3 or "level_icon_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_7_3)
	local size

	if not get_atlas_settings_by_texture_name then
		size = get_atlas_settings_by_texture_name.size

		if not size then
			-- Nothing
		end
	end

	size = {
		150,
		150
	}

	::label_7_0::

	local size_2 = tbl_3[arg_7_0].size
	local tbl = {}
	local tbl_2 = {}
	local tbl_4 = {}
	local str = "button_hotspot"

	tbl[#tbl + 1] = {
		pass_type = "hotspot",
		content_id = str
	}
	tbl_2[str] = {}

	local str_2 = "selection_background"

	tbl[#tbl + 1] = {
		pass_type = "texture_uv",
		content_id = str_2,
		style_id = str_2
	}
	tbl_2[str_2] = {
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

	local tbl_5 = {
		168,
		0,
		-2
	}

	tbl_4[str_2] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			414,
			118
		},
		color = UISettings.console_start_game_menu_rect_color,
		offset = tbl_5
	}

	local str_3 = "bg_effect"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_3,
		style_id = str_3,
		content_check_function = function (self)
			-- function 8
			return self.is_selected
		end
	}
	tbl_4[str_3] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			414,
			126
		},
		color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			tbl_5[1],
			tbl_5[2],
			tbl_5[3] + 1
		}
	}
	tbl_2[str_3] = "item_slot_side_effect"

	local str_4 = "text_title"
	local str_5 = str_4 .. "_shadow"

	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str_4,
		style_id = str_4,
		content_change_function = function (self, arg_9_1)
			-- function 9
			if not self.is_selected then
				arg_9_1.text_color = arg_9_1.selected_color
			else
				arg_9_1.text_color = arg_9_1.default_color
			end
		end
	}
	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str_4,
		style_id = str_5
	}
	tbl_2[str_4] = arg_7_1

	local tbl_6 = {
		225,
		16,
		5
	}
	local tbl_7 = {
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
			tbl_6[1],
			tbl_6[2],
			tbl_6[3]
		}
	}
	local clone = table.clone(tbl_7)

	clone.text_color = {
		255,
		0,
		0,
		0
	}
	clone.offset = {
		tbl_6[1] + 2,
		tbl_6[2] - 2,
		tbl_6[3] - 1
	}
	tbl_4[str_4] = tbl_7
	tbl_4[str_5] = clone

	local str_6 = "input_text"
	local str_7 = str_6 .. "shadow"

	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str_6,
		style_id = str_6
	}
	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str_6,
		style_id = str_7
	}
	tbl_2[str_6] = Localize("not_assigned")

	local tbl_8 = {
		vertical_alignment = "center",
		font_size = 22,
		localize = false,
		horizontal_alignment = "left",
		word_wrap = false,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			tbl_6[1],
			-18,
			tbl_6[3]
		}
	}
	local offset = tbl_8.offset
	local clone_2 = table.clone(tbl_8)

	clone_2.text_color = {
		255,
		0,
		0,
		0
	}
	clone_2.offset = {
		offset[1] + 2,
		offset[2] - 2,
		offset[3] - 1
	}
	tbl_4[str_6] = tbl_8
	tbl_4[str_7] = clone_2

	local tbl_9 = {
		-(size_2[1] / 2) + 108,
		0,
		5
	}
	local tbl_10 = {
		tbl_9[1],
		tbl_9[2],
		tbl_9[3] - 2
	}
	local tbl_11 = {
		tbl_9[1],
		tbl_9[2],
		tbl_9[3] + 2
	}
	local tbl_12 = {
		tbl_9[1],
		tbl_9[2],
		tbl_9[3] - 1
	}
	local str_8 = "icon_texture"
	local str_9 = "icon_texture_frame"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		style_id = str_8,
		texture_id = str_8,
		content_check_function = function (self, arg_10_1)
			-- function 10
			return self[str_8]
		end,
		content_change_function = function (self, arg_11_1)
			-- function 11
			if not self.button_hotspot.disable_button then
				arg_11_1.saturated = true
			else
				arg_11_1.saturated = false
			end
		end
	}
	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_9,
		style_id = str_9,
		content_check_function = function (self, arg_12_1)
			-- function 12
			return self[str_8]
		end
	}
	tbl_2[str_8] = nil
	tbl_2[str_9] = "item_frame"
	tbl_4[str_8] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = size,
		color = {
			255,
			255,
			255,
			255
		},
		offset = tbl_9
	}
	tbl_4[str_9] = {
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
		offset = tbl_9
	}

	local str_10 = "icon_background"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_10,
		style_id = str_10
	}
	tbl_2[str_10] = "level_icon_09"
	tbl_4[str_10] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			150,
			150
		},
		color = UISettings.console_start_game_menu_rect_color,
		offset = tbl_10
	}

	local str_11 = "icon_frame_texture"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		style_id = str_11,
		texture_id = str_11,
		content_check_function = function (self, arg_13_1)
			-- function 13
			return self[str_11]
		end,
		content_change_function = function (self, arg_14_1)
			-- function 14
			if not self.button_hotspot.disable_button then
				arg_14_1.saturated = true
			else
				arg_14_1.saturated = false
			end
		end
	}
	tbl_2[str_11] = arg_7_4 or "map_frame_00"
	tbl_4[str_11] = {
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
		offset = tbl_11
	}

	local str_12 = "icon_texture_glow"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		style_id = str_12,
		texture_id = str_12,
		content_check_function = function (self)
			-- function 15
			return self.is_selected
		end
	}
	tbl_2[str_12] = "map_frame_glow_02"
	tbl_4[str_12] = {
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
		offset = tbl_12
	}

	return {
		element = {
			passes = tbl
		},
		content = tbl_2,
		style = tbl_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_7_0
	}
end

local tbl_4 = {
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
local tbl_5 = {
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
local tbl_6 = {
	heroic_deed_description_background = UIWidgets.create_rect_with_outer_frame("heroic_deed_background", tbl_3.heroic_deed_background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	heroic_deed_title = UIWidgets.create_simple_text(Localize("start_game_window_mutator_title"), "heroic_deed_title", nil, nil, tbl_4),
	heroic_deed_divider = UIWidgets.create_simple_texture("divider_01_top", "heroic_deed_divider"),
	heroic_deed_description = UIWidgets.create_simple_text(Localize("start_game_window_mutator_desc"), "heroic_deed_description", nil, nil, tbl_5),
	heroic_deed_setting = fn("game_option_2", Localize("start_game_window_mutator_title"), nil, "icon_deed_normal_01"),
	play_button = UIWidgets.create_icon_and_name_button("play_button", "options_button_icon_quickplay", Localize("start_game_window_play"))
}
local tbl_7 = {
	"heroic_deed_setting",
	"play_button"
}

return {
	scenegraph_definition = tbl_3,
	widgets = tbl_6,
	animation_definitions = tbl_2,
	selector_input_definition = tbl_7
}
