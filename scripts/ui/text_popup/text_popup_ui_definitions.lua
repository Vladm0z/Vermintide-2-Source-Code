-- chunkname: @scripts/ui/text_popup/text_popup_ui_definitions.lua

local var_0_0 = "menu_frame_11"
local var_0_1 = UIFrameSettings[var_0_0].texture_sizes.horizontal[2]
local var_0_2 = 18
local var_0_3 = 1920
local var_0_4 = 1080
local var_0_5 = {
	871,
	730
}
local var_0_6 = {
	var_0_5[2] - var_0_1 * 2,
	var_0_5[2] - var_0_1 * 2 - var_0_2 * 2
}
local var_0_7 = {
	16,
	var_0_5[2] - 42
}
local var_0_8 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.main_menu
		},
		size = {
			var_0_3,
			var_0_4
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
			var_0_5[1],
			var_0_5[2]
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = var_0_5,
		position = {
			0,
			0,
			1
		}
	},
	window_mask = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			var_0_6[2] - var_0_2
		},
		position = {
			0,
			0,
			0
		}
	},
	window_mask_top = {
		vertical_alignment = "top",
		parent = "window_mask",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			30
		},
		position = {
			0,
			20,
			1
		}
	},
	window_mask_bottom = {
		vertical_alignment = "bottom",
		parent = "window_mask",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			30
		},
		position = {
			0,
			-20,
			1
		}
	},
	text_entry = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		size = var_0_6,
		position = {
			0,
			-(var_0_1 + var_0_2),
			53
		}
	},
	title = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			658,
			60
		},
		position = {
			0,
			34,
			46
		}
	},
	title_bg = {
		vertical_alignment = "top",
		parent = "title",
		horizontal_alignment = "center",
		size = {
			410,
			40
		},
		position = {
			0,
			-15,
			-1
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "title",
		horizontal_alignment = "center",
		size = {
			350,
			50
		},
		position = {
			0,
			-3,
			2
		}
	},
	scrollbar = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = var_0_7,
		position = {
			-26,
			0,
			30
		}
	},
	ok_button = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			-16,
			42
		},
		size = {
			380,
			42
		}
	}
}
local var_0_9 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 22,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = false,
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		10
	}
}
local var_0_10 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		4,
		10
	}
}
local var_0_11 = {
	background = UIWidgets.create_background("background", var_0_8.background.size, "menu_frame_bg_02"),
	screen = UIWidgets.create_simple_rect("screen", {
		100,
		0,
		0,
		0
	}),
	window_frame = UIWidgets.create_frame("window", var_0_8.window.size, var_0_0, 20),
	window_mask = UIWidgets.create_simple_texture("mask_rect", "window_mask"),
	window_mask_bottom = UIWidgets.create_simple_rotated_texture("mask_rect_edge_fade", math.pi, {
		var_0_5[1] / 2,
		15
	}, "window_mask_bottom"),
	window_mask_top = UIWidgets.create_simple_texture("mask_rect_edge_fade", "window_mask_top"),
	overlay_text = UIWidgets.create_simple_text("", "text_entry", nil, nil, var_0_9),
	title = UIWidgets.create_simple_texture("frame_title_bg", "title"),
	title_bg = UIWidgets.create_background("title_bg", var_0_8.title_bg.size, "menu_frame_bg_02"),
	title_text = UIWidgets.create_simple_text("", "title_text", nil, nil, var_0_10),
	ok_button = UIWidgets.create_default_button("ok_button", var_0_8.ok_button.size, nil, nil, Localize("button_ok"), 24, nil, "button_detail_04", 34, true),
	scrollbar = UIWidgets.create_chain_scrollbar("scrollbar", nil, var_0_8.scrollbar.size),
	scroll_content = {
		scenegraph_id = "window",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "scroll",
					scroll_function = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
						local var_1_0 = arg_1_4.y * -1

						if IS_XB1 and GameSettingsDevelopment.allow_keyboard_mouse and not Managers.input:is_device_active("gamepad") then
							var_1_0 = math.sign(arg_1_4.x) * -1
						end

						local var_1_1 = arg_1_2.hotspot

						if var_1_0 ~= 0 and var_1_1.is_hover then
							arg_1_2.axis_input = var_1_0
							arg_1_2.scroll_add = var_1_0 * arg_1_2.scroll_amount
						else
							local var_1_2 = arg_1_2.axis_input
						end

						local var_1_3 = arg_1_2.scroll_add

						if var_1_3 then
							local var_1_4 = var_1_3 * (arg_1_5 * 5)
							local var_1_5 = var_1_3 - var_1_4

							if math.abs(var_1_5) > 0 then
								arg_1_2.scroll_add = var_1_5
							else
								arg_1_2.scroll_add = nil
							end

							local var_1_6 = arg_1_2.scroll_value

							arg_1_2.scroll_value = math.clamp(var_1_6 + var_1_4, 0, 1)
						end
					end
				}
			}
		},
		content = {
			scroll_amount = 0.1,
			scroll_value = 1,
			hotspot = {
				allow_multi_hover = true
			}
		},
		style = {}
	}
}
local var_0_12 = {
	default = {
		{
			input_action = "left_stick",
			priority = 1,
			description_text = "input_description_scroll_details",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_close"
		}
	}
}

return {
	scenegraph_definition = var_0_8,
	widget_definitions = var_0_11,
	scroll_text_style = var_0_9,
	generic_input_actions = var_0_12
}
