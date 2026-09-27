-- chunkname: @scripts/ui/dlc_upsell/handbook_popup_definitions.lua

local spacing = UISettings.game_start_windows.spacing
local tbl = {
	1128,
	900
}
local var_0_2 = tbl[2]
local tbl_2 = {
	tbl[1],
	var_0_2
}
local tbl_3 = {
	tbl_2[1] - 22,
	tbl_2[2] - 104
}
local tbl_4 = {
	16,
	tbl_2[2] - 44
}
local num = tbl_3[1] - 150
local tbl_5 = {
	screen = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.item_display_popup
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			0,
			50,
			1
		}
	},
	window_background = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 5,
			tbl[2] - 5
		},
		position = {
			0,
			0,
			0
		}
	},
	right_window = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = tbl_2,
		position = {
			0,
			0,
			1
		}
	},
	right_window_fade = {
		vertical_alignment = "center",
		parent = "right_window",
		horizontal_alignment = "center",
		size = {
			tbl_2[1] - 44,
			tbl_2[2] - 44
		},
		position = {
			0,
			0,
			1
		}
	},
	achievement_window = {
		vertical_alignment = "center",
		parent = "right_window",
		horizontal_alignment = "center",
		size = tbl_3,
		position = {
			0,
			0,
			1
		}
	},
	achievement_window_mask = {
		vertical_alignment = "center",
		parent = "achievement_window",
		horizontal_alignment = "center",
		size = {
			tbl_3[1],
			tbl_2[2] - 44
		},
		position = {
			0,
			0,
			0
		}
	},
	achievement_window_mask_top = {
		vertical_alignment = "top",
		parent = "achievement_window_mask",
		horizontal_alignment = "center",
		size = {
			tbl_3[1],
			30
		},
		position = {
			0,
			0,
			1
		}
	},
	achievement_window_mask_bottom = {
		vertical_alignment = "bottom",
		parent = "achievement_window_mask",
		horizontal_alignment = "center",
		size = {
			tbl_3[1],
			30
		},
		position = {
			0,
			0,
			1
		}
	},
	achievement_root = {
		vertical_alignment = "top",
		parent = "achievement_window",
		horizontal_alignment = "center",
		size = {
			num,
			1
		},
		position = {
			0,
			0,
			10
		}
	},
	achievement_scrollbar = {
		vertical_alignment = "center",
		parent = "achievement_window",
		horizontal_alignment = "right",
		size = tbl_4,
		position = {
			-spacing,
			0,
			3
		}
	},
	exit_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			380,
			42
		},
		position = {
			0,
			-16,
			42
		}
	},
	page_text_area = {
		vertical_alignment = "bottom",
		parent = "right_window",
		horizontal_alignment = "center",
		size = {
			334,
			60
		},
		position = {
			0,
			30,
			20
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
	input_arrow_next = {
		vertical_alignment = "center",
		parent = "input_icon_next",
		horizontal_alignment = "center",
		size = {
			19,
			27
		},
		position = {
			40,
			0,
			1
		}
	},
	input_arrow_previous = {
		vertical_alignment = "center",
		parent = "input_icon_previous",
		horizontal_alignment = "center",
		size = {
			19,
			27
		},
		position = {
			-40,
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
	}
}
local large_window_size = UISettings.game_start_windows.large_window_size
local tbl_6 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		-(large_window_size[1] * 0.1 + 5),
		4,
		2
	}
}
local tbl_7 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		large_window_size[1] * 0.1 + 4,
		4,
		2
	}
}
local tbl_8 = {
	word_wrap = true,
	font_size = 20,
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
local flag = true
local tbl_9 = {
	window = UIWidgets.create_frame("window", tbl_5.window.size, "menu_frame_11", 40),
	window_background = UIWidgets.create_tiled_texture("window_background", "menu_frame_bg_01", {
		960,
		1080
	}, nil, nil, {
		255,
		100,
		100,
		100
	}),
	right_window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "right_window_fade"),
	right_window = UIWidgets.create_tiled_texture("right_window", "achievement_background_leather_02", {
		256,
		256
	}, nil, nil, {
		255,
		180,
		180,
		180
	}),
	right_window_mask = UIWidgets.create_simple_texture("mask_rect", "achievement_window"),
	achievement_window_mask_bottom = UIWidgets.create_simple_rotated_texture("mask_rect_edge_fade", math.pi, {
		tbl_3[1] / 2,
		15
	}, "achievement_window_mask_bottom"),
	achievement_window_mask_top = UIWidgets.create_simple_texture("mask_rect_edge_fade", "achievement_window_mask_top"),
	exit_button = UIWidgets.create_default_button("exit_button", tbl_5.exit_button.size, nil, nil, Localize("menu_close"), 24, nil, "button_detail_04", 34, flag),
	achievement_scrollbar = UIWidgets.create_chain_scrollbar("achievement_scrollbar", nil, tbl_5.achievement_scrollbar.size),
	page_button_next = UIWidgets.create_arrow_button("page_button_next", math.pi),
	page_button_previous = UIWidgets.create_arrow_button("page_button_previous"),
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
	}, "input_arrow_next"),
	input_arrow_previous = UIWidgets.create_simple_texture("settings_arrow_normal", "input_arrow_previous"),
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, tbl_8),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_6),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_7),
	page_text_area = UIWidgets.create_simple_texture("tab_menu_bg_03", "page_text_area"),
	achievement_window = {
		scenegraph_id = "achievement_window_mask",
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

						if not (not IS_XB1 and not GameSettingsDevelopment.allow_keyboard_mouse and arg_1_2.is_gamepad_active) then
							num = math.sign(arg_1_4.x) * -1
						end

						local hotspot = arg_1_2.hotspot

						if num == 0 or hotspot.is_hover or not arg_1_2.is_gamepad_active then
							arg_1_2.axis_input = num
							arg_1_2.scroll_add = num * arg_1_2.scroll_amount
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
local tbl_10 = {
	on_enter = {
		{
			name = "fade_in",
			duration = 0.6,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				arg_3_4.render_settings.alpha_multiplier = math.easeOutCubic(arg_3_3)
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			duration = 0.1,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				arg_6_4.render_settings.alpha_multiplier = 1 - math.easeOutCubic(arg_6_3)
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end
		}
	}
}
local tbl_11 = {
	default = {
		{
			input_action = "back",
			priority = 2,
			description_text = "input_description_back"
		}
	},
	has_pages = {
		actions = {
			{
				input_action = "l1_r1",
				priority = 2,
				description_text = "input_description_change_tab",
				ignore_keybinding = true
			}
		}
	}
}

return {
	scenegraph_definition = tbl_5,
	widget_definitions = tbl_9,
	animation_definitions = tbl_10,
	generic_input_actions = tbl_11,
	achievement_window_size = tbl_3,
	achievement_scrollbar_size = tbl_4
}
