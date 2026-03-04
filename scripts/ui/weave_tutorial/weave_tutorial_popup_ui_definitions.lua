-- chunkname: @scripts/ui/weave_tutorial/weave_tutorial_popup_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = 50
local var_0_3 = 460
local var_0_4 = var_0_3 - var_0_2 * 2
local var_0_5 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.item_display_popup
		},
		size = {
			var_0_0,
			var_0_1
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
			var_0_3,
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
			var_0_4,
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
			var_0_4,
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
			var_0_4,
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
local var_0_6 = {
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
local var_0_7 = {
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
local var_0_8 = {
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
local var_0_9 = true

local function var_0_10(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = UIWidgets.create_default_button(arg_1_0, arg_1_1, "button_detail_03_gold", "button_bg_01", arg_1_2, nil, nil, "button_detail_03_gold", nil, var_0_9)

	var_1_0.content.draw_frame = false

	local var_1_1 = var_1_0.style

	var_1_1.background.size = {
		arg_1_1[1],
		arg_1_1[2] - 8
	}
	var_1_1.background.offset = {
		0,
		4,
		0
	}
	var_1_1.background_fade.offset = {
		0,
		4,
		2
	}
	var_1_1.background_fade.size = {
		arg_1_1[1],
		arg_1_1[2] - 8
	}
	var_1_1.hover_glow.offset = {
		0,
		5,
		3
	}
	var_1_1.clicked_rect.offset = {
		0,
		4,
		7
	}
	var_1_1.clicked_rect.size = {
		arg_1_1[1],
		arg_1_1[2] - 8
	}
	var_1_1.glass_top.offset = {
		0,
		arg_1_1[2] - 16,
		4
	}
	var_1_1.glass_bottom.offset = {
		0,
		-4,
		4
	}

	return var_1_0
end

local var_0_11 = {
	window_background = UIWidgets.create_tiled_texture("window", "mission_select_screen_bg", {
		1065,
		770
	}),
	window_top_detail = UIWidgets.create_simple_texture("tab_selection_01_bottom", "window_top_detail"),
	window_frame = UIWidgets.create_frame("window", var_0_5.window.size, "menu_frame_12_gold", 5),
	screen_background = UIWidgets.create_simple_rect("screen", {
		150,
		0,
		0,
		0
	}),
	title_text = UIWidgets.create_simple_text("", "title", nil, nil, var_0_6),
	sub_title_text = UIWidgets.create_simple_text("", "sub_title", nil, nil, var_0_7),
	button_1 = var_0_10("button_1", var_0_5.button_1.size, Localize("menu_weave_tutorial_popup_confirm_button")),
	button_2 = var_0_10("button_2", var_0_5.button_2.size, "")
}
local var_0_12 = {
	body_text = UIWidgets.create_simple_text("", "body", nil, nil, var_0_8),
	paragraph_divider = UIWidgets.create_simple_texture("popup_divider", "paragraph_divider")
}
local var_0_13 = {
	transition_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.2,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				local var_3_0 = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = var_3_0
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end
		}
	}
}
local var_0_14 = {
	default = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "button_ok"
		}
	}
}

return {
	generic_input_actions = var_0_14,
	scenegraph_definition = var_0_5,
	widget_definitions = var_0_11,
	body_definitions = var_0_12,
	animation_definitions = var_0_13
}
