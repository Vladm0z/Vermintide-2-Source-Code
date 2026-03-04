-- chunkname: @scripts/ui/dlc_upsell/alterantive_reminder_popup_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = 50
local var_0_3 = 455
local var_0_4 = 636
local var_0_5 = var_0_3 - var_0_2 * 2
local var_0_6 = {
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
			var_0_4
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
	body = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			75,
			0
		},
		size = {
			var_0_5,
			380
		}
	},
	ok_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			50,
			10
		},
		size = {
			320,
			76
		}
	}
}
local var_0_7 = {
	word_wrap = true,
	upper_case = false,
	localize = true,
	use_shadow = true,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_table("font_default"),
	offset = {
		0,
		0,
		2
	}
}
local var_0_8 = true
local var_0_9 = {
	window_background = UIWidgets.create_simple_texture("wom_upsell_popup_bg", "window"),
	window_top_detail = UIWidgets.create_simple_texture("tab_selection_01_bottom", "window_top_detail"),
	window_frame = UIWidgets.create_frame("window", var_0_6.window.size, "upsell_image_keyart_frame", 5),
	screen_background = UIWidgets.create_simple_rect("screen", {
		150,
		0,
		0,
		0
	}),
	body_text = UIWidgets.create_simple_text("not_assigned", "body", nil, nil, var_0_7),
	ok_button = UIWidgets.create_default_button("ok_button", var_0_6.ok_button.size, "upsell_image_button_frame", "button_bg_01", "", nil, nil, nil, nil, var_0_8, true)
}
local var_0_10 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				arg_2_4.render_settings.alpha_multiplier = math.easeOutCubic(arg_2_3)
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				arg_5_4.render_settings.alpha_multiplier = 1 - math.easeOutCubic(arg_5_3)
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}
local var_0_11 = {}

return {
	scenegraph_definition = var_0_6,
	widget_definitions = var_0_9,
	animation_definitions = var_0_10,
	generic_input_actions = var_0_11
}
