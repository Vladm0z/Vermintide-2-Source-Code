-- chunkname: @scripts/ui/weave_tutorial/weave_tutorial_popup_ui_definitions.lua

local num = 1920
local num_2 = 1080
local num_3 = 50
local num_4 = 460
local num_5 = num_4 - num_3 * 2
local tbl = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.item_display_popup
		},
		size = {
			num,
			num_2
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			num_4,
			500
		}
	},
	window_top_detail = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			6
		},
		size = {
			45,
			12
		}
	},
	title = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			-30,
			1
		},
		size = {
			num_5,
			60
		}
	},
	sub_title = {
		vertical_alignment = "top",
		parent = "title",
		horizontal_alignment = "center",
		position = {
			0,
			-40,
			0
		},
		size = {
			num_5,
			50
		}
	},
	body = {
		vertical_alignment = "top",
		parent = "sub_title",
		horizontal_alignment = "center",
		position = {
			0,
			-60,
			0
		},
		size = {
			num_5,
			380
		}
	},
	paragraph_divider = {
		vertical_alignment = "top",
		parent = "body",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			200,
			8
		}
	},
	button_1 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			-20,
			10
		},
		size = {
			160,
			50
		}
	},
	button_2 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			-20,
			10
		},
		size = {
			160,
			50
		}
	}
}
local tbl_2 = {
	use_shadow = true,
	upper_case = true,
	localize = true,
	font_size = 32,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("orange", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_3 = {
	use_shadow = true,
	upper_case = true,
	localize = true,
	font_size = 24,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("orange", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_4 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 20,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local flag = true

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local create_default_button = UIWidgets.create_default_button(arg_1_0, arg_1_1, "button_detail_03_gold", "button_bg_01", arg_1_2, nil, nil, "button_detail_03_gold", nil, flag)

	create_default_button.content.draw_frame = false

	local style = create_default_button.style

	style.background.size = {
		arg_1_1[1],
		arg_1_1[2] - 8
	}
	style.background.offset = {
		0,
		4,
		0
	}
	style.background_fade.offset = {
		0,
		4,
		2
	}
	style.background_fade.size = {
		arg_1_1[1],
		arg_1_1[2] - 8
	}
	style.hover_glow.offset = {
		0,
		5,
		3
	}
	style.clicked_rect.offset = {
		0,
		4,
		7
	}
	style.clicked_rect.size = {
		arg_1_1[1],
		arg_1_1[2] - 8
	}
	style.glass_top.offset = {
		0,
		arg_1_1[2] - 16,
		4
	}
	style.glass_bottom.offset = {
		0,
		-4,
		4
	}

	return create_default_button
end

local tbl_5 = {
	window_background = UIWidgets.create_tiled_texture("window", "mission_select_screen_bg", {
		1065,
		770
	}),
	window_top_detail = UIWidgets.create_simple_texture("tab_selection_01_bottom", "window_top_detail"),
	window_frame = UIWidgets.create_frame("window", tbl.window.size, "menu_frame_12_gold", 5),
	screen_background = UIWidgets.create_simple_rect("screen", {
		150,
		0,
		0,
		0
	}),
	title_text = UIWidgets.create_simple_text("", "title", nil, nil, tbl_2),
	sub_title_text = UIWidgets.create_simple_text("", "sub_title", nil, nil, tbl_3),
	button_1 = fn("button_1", tbl.button_1.size, Localize("menu_weave_tutorial_popup_confirm_button")),
	button_2 = fn("button_2", tbl.button_2.size, "")
}
local tbl_6 = {
	body_text = UIWidgets.create_simple_text("", "body", nil, nil, tbl_4),
	paragraph_divider = UIWidgets.create_simple_texture("popup_divider", "paragraph_divider")
}
local tbl_7 = {
	transition_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.2,
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
	}
}
local tbl_8 = {
	default = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "button_ok"
		}
	}
}

return {
	generic_input_actions = tbl_8,
	scenegraph_definition = tbl,
	widget_definitions = tbl_5,
	body_definitions = tbl_6,
	animation_definitions = tbl_7
}
