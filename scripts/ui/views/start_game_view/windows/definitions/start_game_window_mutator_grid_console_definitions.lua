-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_grid_console_definitions.lua

local game_start_windows = UISettings.game_start_windows
local frame = game_start_windows.frame
local size = game_start_windows.size
local var_0_3 = UIFrameSettings[frame].texture_sizes.vertical[1]
local num = size[1] - (var_0_3 * 2 + 60)
local tbl = {
	size[1],
	size[2]
}
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
				arg_2_0.actual_window.local_position[2] = arg_2_1.actual_window.position[2] + math.floor(-100 * (1 - easeOutCubic))
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
				local easeOutCubic = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - easeOutCubic
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
	deletion_overlay_background = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			20
		}
	},
	deletion_overlay = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			314,
			33
		},
		position = {
			0,
			20,
			60
		}
	},
	heroic_deed_background = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1] + 90,
			100
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
			size[1],
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
	actual_window = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			0,
			0,
			1
		}
	},
	item_grid = {
		vertical_alignment = "center",
		parent = "actual_window",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			0,
			50,
			3
		}
	},
	title_text_detail = {
		vertical_alignment = "top",
		parent = "actual_window",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			21,
			10
		}
	},
	title_text_detail_glow = {
		vertical_alignment = "top",
		parent = "title_text_detail",
		horizontal_alignment = "center",
		size = {
			544,
			16
		},
		position = {
			0,
			5,
			-1
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "title_text_detail",
		horizontal_alignment = "center",
		size = {
			size[1],
			50
		},
		position = {
			0,
			25,
			1
		}
	},
	description_text = {
		vertical_alignment = "bottom",
		parent = "window",
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
	page_text_area = {
		vertical_alignment = "center",
		parent = "actual_window",
		horizontal_alignment = "center",
		size = {
			334,
			60
		},
		position = {
			0,
			-240,
			3
		}
	},
	input_icon_previous = {
		vertical_alignment = "center",
		parent = "page_text_area",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-60,
			0,
			1
		}
	},
	input_icon_next = {
		vertical_alignment = "center",
		parent = "page_text_area",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			60,
			0,
			1
		}
	},
	page_button_next = {
		vertical_alignment = "center",
		parent = "input_icon_next",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			20,
			0,
			1
		}
	},
	page_button_previous = {
		vertical_alignment = "center",
		parent = "input_icon_previous",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-20,
			0,
			1
		}
	},
	clear_bottons_anchor = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			225,
			50
		},
		position = {
			20,
			20,
			1
		}
	},
	delete_bottons_anchor = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			225,
			50
		},
		position = {
			275,
			20,
			1
		}
	},
	mark_deeds_text_anchor = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			225,
			50
		},
		position = {
			170,
			80,
			1
		}
	}
}
local tbl_4 = {
	word_wrap = true,
	font_size = 26,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		-172,
		4,
		2
	}
}
local tbl_5 = {
	word_wrap = true,
	font_size = 26,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		171,
		4,
		2
	}
}
local tbl_6 = {
	word_wrap = true,
	font_size = 26,
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
local tbl_7 = {
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
local tbl_8 = {
	font_size = 28,
	upper_case = false,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local num_2 = 5
local num_3 = 7
local num_4 = 12
local num_5 = 12
local flag = false
local tbl_9 = {
	heroic_deed_description_background = UIWidgets.create_rect_with_outer_frame("heroic_deed_background", tbl_3.heroic_deed_background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	heroic_deed_title = UIWidgets.create_simple_text(Localize("start_game_window_mutator_title"), "heroic_deed_title", nil, nil, tbl_7),
	heroic_deed_divider = UIWidgets.create_simple_texture("divider_01_top", "heroic_deed_divider"),
	item_grid = UIWidgets.create_grid("item_grid", tbl_3.item_grid.size, num_2, num_3, num_4, num_5, flag, nil, true),
	input_icon_next = UIWidgets.create_simple_texture("xbone_button_icon_a", "input_icon_next"),
	input_icon_previous = UIWidgets.create_simple_texture("xbone_button_icon_a", "input_icon_previous"),
	input_arrow_next = UIWidgets.create_simple_uv_texture("settings_arrow_normal", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "page_button_next"),
	input_arrow_previous = UIWidgets.create_simple_texture("settings_arrow_normal", "page_button_previous"),
	page_button_next = UIWidgets.create_arrow_button("page_button_next", math.pi),
	page_button_previous = UIWidgets.create_arrow_button("page_button_previous"),
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, tbl_6),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_4),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_5),
	page_text_area = UIWidgets.create_simple_texture("tab_menu_bg_03", "page_text_area")
}
local tbl_10 = {
	claim_overlay = UIWidgets.create_simple_rect("deletion_overlay_background", {
		220,
		12,
		12,
		12
	}, 36),
	claim_overlay_fade = UIWidgets.create_simple_texture("options_window_fade_01", "deletion_overlay_background", nil, nil, nil, 37),
	claim_overlay_loading_glow = UIWidgets.create_simple_texture("loading_title_divider", "deletion_overlay", nil, nil, nil, 1),
	claim_overlay_loading_frame = UIWidgets.create_simple_texture("loading_title_divider_background", "deletion_overlay")
}
local tbl_11 = {
	mark_deeds_text = UIWidgets.create_simple_text(string.format(Localize("mark_deeds_text"), "$KEY;start_game_view__mouse_middle_press:"), "mark_deeds_text_anchor", {
		600,
		100
	}, nil, tbl_8, nil, false, true),
	button_clear = UIWidgets.create_default_button("clear_bottons_anchor", tbl_3.clear_bottons_anchor.size, nil, nil, Localize("button_clear_all"), 21, nil, nil, nil, true, true),
	button_delete = UIWidgets.create_default_button("delete_bottons_anchor", tbl_3.delete_bottons_anchor.size, nil, nil, Localize("button_delete_selected"), 21, nil, nil, nil, true, true)
}

return {
	widgets = tbl_9,
	scenegraph_definition = tbl_3,
	animation_definitions = tbl_2,
	delete_deeds_button_widgets = tbl_11,
	overlay_widgets = tbl_10
}
