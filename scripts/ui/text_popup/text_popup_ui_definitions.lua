-- chunkname: @scripts/ui/text_popup/text_popup_ui_definitions.lua

local str = "menu_frame_11"
local var_0_1 = UIFrameSettings[str].texture_sizes.horizontal[2]
local num = 18
local num_2 = 1920
local num_3 = 1080
local tbl = {
	871,
	730
}
local tbl_2 = {
	tbl[2] - var_0_1 * 2,
	tbl[2] - var_0_1 * 2 - num * 2
}
local tbl_3 = {
	16,
	tbl[2] - 42
}
local tbl_4 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.main_menu
		},
		size = {
			num_2,
			num_3
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
			tbl[1],
			tbl[2]
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = tbl,
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
			tbl[1],
			tbl_2[2] - num
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
			tbl[1],
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
			tbl[1],
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
		size = tbl_2,
		position = {
			0,
			-(var_0_1 + num),
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
		size = tbl_3,
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
local tbl_5 = {
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
local tbl_6 = {
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
local tbl_7 = {
	background = UIWidgets.create_background("background", tbl_4.background.size, "menu_frame_bg_02"),
	screen = UIWidgets.create_simple_rect("screen", {
		100,
		0,
		0,
		0
	}),
	window_frame = UIWidgets.create_frame("window", tbl_4.window.size, str, 20),
	window_mask = UIWidgets.create_simple_texture("mask_rect", "window_mask"),
	window_mask_bottom = UIWidgets.create_simple_rotated_texture("mask_rect_edge_fade", math.pi, {
		tbl[1] / 2,
		15
	}, "window_mask_bottom"),
	window_mask_top = UIWidgets.create_simple_texture("mask_rect_edge_fade", "window_mask_top"),
	overlay_text = UIWidgets.create_simple_text("", "text_entry", nil, nil, tbl_5),
	title = UIWidgets.create_simple_texture("frame_title_bg", "title"),
	title_bg = UIWidgets.create_background("title_bg", tbl_4.title_bg.size, "menu_frame_bg_02"),
	title_text = UIWidgets.create_simple_text("", "title_text", nil, nil, tbl_6),
	ok_button = UIWidgets.create_default_button("ok_button", tbl_4.ok_button.size, nil, nil, Localize("button_ok"), 24, nil, "button_detail_04", 34, true),
	scrollbar = UIWidgets.create_chain_scrollbar("scrollbar", nil, tbl_4.scrollbar.size),
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
						-- function 1
						local num = arg_1_4.y * -1

						if not (not IS_XB1 and not GameSettingsDevelopment.allow_keyboard_mouse and Managers.input:is_device_active("gamepad")) then
							num = math.sign(arg_1_4.x) * -1
						end

						local hotspot = arg_1_2.hotspot

						if num == 0 or not hotspot.is_hover then
							arg_1_2.axis_input = num
							arg_1_2.scroll_add = num * arg_1_2.scroll_amount
						else
							local axis_input = arg_1_2.axis_input
						end

						local scroll_add = arg_1_2.scroll_add

						if not scroll_add then
							local num_2 = scroll_add * (arg_1_5 * 5)
							local num_3 = scroll_add - num_2

							if math.abs(num_3) > 0 then
								arg_1_2.scroll_add = num_3
							else
								arg_1_2.scroll_add = nil
							end

							local scroll_value = arg_1_2.scroll_value

							arg_1_2.scroll_value = math.clamp(scroll_value + num_2, 0, 1)
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
local tbl_8 = {
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
	scenegraph_definition = tbl_4,
	widget_definitions = tbl_7,
	scroll_text_style = tbl_5,
	generic_input_actions = tbl_8
}
