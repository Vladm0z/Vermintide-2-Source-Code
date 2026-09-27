-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_quickplay_definitions.lua

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
	500,
	200
}
local tbl_3 = {
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
	},
	gamemode_text_swap = {
		{
			name = "gamemode_swap_text_fade_out",
			start_progress = 0,
			end_progress = 0.2,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local easeOutCubic = math.easeOutCubic(arg_8_3)

				arg_8_2.style.game_mode_text.text_color[1] = 255 * (1 - easeOutCubic)
				arg_8_2.style.press_key_text.text_color[1] = 255 * (1 - easeOutCubic)

				if not arg_8_2.content.show_note then
					arg_8_2.style.note_text.text_color[1] = 255 * (1 - easeOutCubic)
				end
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		},
		{
			name = "gamemode_swap_text_fade_in",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				if not arg_11_2.content.is_showing_info then
					arg_11_2.content.game_mode_text = Localize("expedition_info")
					arg_11_2.content.show_note = true
				else
					arg_11_2.content.game_mode_text = string.gsub(Localize("start_game_window_deus_quickplay_desc"), Localize("expedition_highlight_text"), "{#color(255,168,0)}" .. Localize("expedition_highlight_text") .. "{#reset()}")
					arg_11_2.content.show_note = false
				end

				arg_11_2.style.game_mode_text.text_color[1] = 255 * math.easeOutCubic(arg_11_3)
				arg_11_2.style.press_key_text.text_color[1] = 255 * math.easeOutCubic(arg_11_3)

				if not arg_11_2.content.show_note then
					arg_11_2.style.note_text.text_color[1] = 255 * math.easeOutCubic(arg_11_3)
				end
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				return
			end
		}
	},
	right_arrow_flick = {
		{
			name = "right_arrow_flick",
			start_progress = 0,
			end_progress = 0.6,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				arg_14_4.right_key.color[1] = 255 * (1 - math.easeOutCubic(arg_14_3))
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				arg_15_2.content.right_arrow_pressed = false
			end
		}
	},
	left_arrow_flick = {
		{
			name = "left_arrow_flick",
			start_progress = 0,
			end_progress = 0.6,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				return
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				arg_17_4.left_key.color[1] = 255 * (1 - math.easeOutCubic(arg_17_3))
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				arg_18_2.content.left_arrow_pressed = false
			end
		}
	},
	difficulty_info_enter = {
		{
			name = "difficulty_info_enter",
			start_progress = 0,
			end_progress = 0.6,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				arg_19_2.difficulty_info.content.visible = true

				local style = arg_19_2.difficulty_info.style

				style.background.color[1] = 0
				style.border.color[1] = 0
				style.difficulty_description.text_color[1] = 0
				style.highest_obtainable_level.text_color[1] = 0
				style.difficulty_separator.color[1] = 0
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				local easeOutCubic = math.easeOutCubic(arg_20_3)
				local difficulty_info = arg_20_2.difficulty_info
				local style = arg_20_2.difficulty_info.style
				local content = arg_20_2.difficulty_info.content

				difficulty_info.offset[1] = 50 * easeOutCubic
				arg_20_2.upsell_button.offset[1] = 50 * easeOutCubic

				local num = 200 * easeOutCubic

				style.background.color[1] = num
				style.border.color[1] = num

				local num_2 = 255 * easeOutCubic

				style.difficulty_description.text_color[1] = num_2
				style.highest_obtainable_level.text_color[1] = num_2
				style.difficulty_separator.color[1] = num_2

				if not content.should_show_diff_lock_text then
					style.difficulty_lock_text.text_color[1] = num_2
				end

				if not content.should_show_dlc_lock then
					style.dlc_lock_text.text_color[1] = num_2
				end
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				return
			end
		}
	}
}
local tbl_4 = {
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
	quickplay_background = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1] + 70,
			460
		},
		position = {
			0,
			-110,
			1
		}
	},
	quickplay_title = {
		vertical_alignment = "top",
		parent = "quickplay_background",
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
	quickplay_sub_title = {
		vertical_alignment = "top",
		parent = "quickplay_background",
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
	quickplay_divider = {
		vertical_alignment = "top",
		parent = "quickplay_sub_title",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-44,
			1
		}
	},
	quickplay_description = {
		vertical_alignment = "top",
		parent = "quickplay_divider",
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
			-15,
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
			-15 + tbl[2],
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
			-105 + tbl[2] * 2,
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
			-42,
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
local tbl_5 = {
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
local tbl_6 = {
	font_size = 34,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_7 = {
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
local tbl_8 = {
	font_size = 28,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		40,
		-60,
		2
	},
	size = {
		600,
		30
	},
	area_size = {
		600,
		30
	}
}
local flag = true
local tbl_9 = {
	quickplay_description_background = UIWidgets.create_rect_with_outer_frame("quickplay_background", tbl_4.quickplay_background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	quickplay_title = UIWidgets.create_simple_text(Localize("menu_store_panel_title_versus"), "quickplay_title", nil, nil, tbl_5),
	quickplay_sub_title = UIWidgets.create_simple_text(Localize("versus_start_game_window_dedicated_server"), "quickplay_sub_title", nil, nil, tbl_6),
	quickplay_description = UIWidgets.create_simple_text(Localize("vs_quick_play_description"), "quickplay_description", nil, nil, tbl_7),
	quickplay_divider = UIWidgets.create_simple_texture("divider_01_top", "quickplay_divider"),
	play_button = UIWidgets.create_icon_and_name_button("play_button", "options_button_icon_quickplay", Localize("versus_start_game_button_queue_up")),
	quickplay_disabled_disclaimer = UIWidgets.create_simple_text("", "play_button", nil, nil, tbl_8)
}
local tbl_10 = {
	{
		widget_name = "play_button",
		enter_requirements = function (self)
			-- function 22
			return not Managers.input:is_device_active("gamepad") and not self.gamepad_active_last_frame
		end,
		on_enter = function (arg_23_0, arg_23_1, arg_23_2)
			-- function 23
			arg_23_0._widgets_by_name.play_button.content.is_selected = true
		end,
		update = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
			-- function 24
			if not arg_24_1:get("confirm_press") and arg_24_2 and not arg_24_1:get("skip_press") then
				self:_option_selected("play_button", nil, arg_24_4)
			end
		end,
		on_exit = function (arg_25_0, arg_25_1, arg_25_2)
			-- function 25
			arg_25_0._widgets_by_name.play_button.content.is_selected = false
		end
	}
}

return {
	scenegraph_definition = tbl_4,
	widget_definitions = tbl_9,
	animation_definitions = tbl_3,
	selector_input_definitions = tbl_10
}
