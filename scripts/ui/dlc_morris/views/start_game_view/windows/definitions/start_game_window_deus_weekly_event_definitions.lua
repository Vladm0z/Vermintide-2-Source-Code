-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_weekly_event_definitions.lua

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
	500,
	200
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
	adventure_background = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] + 70,
			260
		},
		position = {
			0,
			-75,
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
			-105 + var_0_4[2] * 2,
			1
		}
	},
	right_window = {
		vertical_alignment = "top",
		parent = "menu_root",
		horizontal_alignment = "right",
		size = {
			var_0_2[1],
			var_0_2[2]
		},
		position = {
			-100,
			-160,
			1
		}
	},
	divider = {
		vertical_alignment = "top",
		parent = "right_window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1],
			4
		},
		position = {
			20,
			-50,
			2
		}
	},
	play_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			72
		},
		position = {
			0,
			-40,
			1
		}
	},
	difficulty_stepper = {
		vertical_alignment = "bottom",
		parent = "game_option_1",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2]
		},
		position = {
			17.5,
			0,
			0
		}
	},
	difficulty_info = {
		vertical_alignment = "center",
		parent = "difficulty_stepper",
		horizontal_alignment = "center",
		size = var_0_6,
		position = {
			500,
			-10,
			0
		}
	},
	upsell_button = {
		vertical_alignment = "center",
		parent = "difficulty_info",
		horizontal_alignment = "center",
		size = {
			28,
			28
		},
		position = {
			218,
			0,
			2
		}
	},
	info_box = {
		vertical_alignment = "bottom",
		parent = "right_window",
		horizontal_alignment = "left",
		position = {
			20,
			20,
			1
		},
		size = {
			var_0_2[1] - 50,
			var_0_2[2] - 80
		}
	},
	info_box_anchor = {
		parent = "info_box"
	},
	scrollbar_anchor = {
		vertical_alignment = "top",
		parent = "right_window",
		horizontal_alignment = "center",
		position = {
			0,
			-20,
			1
		},
		size = {
			var_0_2[1],
			var_0_2[2] - 40
		}
	},
	scrollbar_window = {
		parent = "scrollbar_anchor",
		size = {
			var_0_2[1] - 20,
			var_0_2[2] - 40
		}
	}
}
local var_0_8 = {
	font_size = 28,
	upper_case = false,
	localize = false,
	use_shadow = false,
	word_wrap = false,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = false,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		-10,
		2
	}
}

local function var_0_9(arg_1_0, arg_1_1)
	local var_1_0 = {}
	local var_1_1 = {}
	local var_1_2 = {}
	local var_1_3 = {}
	local var_1_4 = {}
	local var_1_5 = "morris_gaze_header"
	local var_1_6 = "menu_frame_detail_morris"
	local var_1_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_5)
	local var_1_8 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_6)

	var_1_2[#var_1_2 + 1] = {
		style_id = "frame_top",
		pass_type = "texture_uv",
		content_id = "frame_top"
	}
	var_1_2[#var_1_2 + 1] = {
		style_id = "frame_bottom",
		pass_type = "texture_uv",
		content_id = "frame_bottom"
	}
	var_1_2[#var_1_2 + 1] = {
		style_id = "frame_right",
		pass_type = "texture_uv",
		content_id = "frame_right"
	}
	var_1_2[#var_1_2 + 1] = {
		pass_type = "texture",
		style_id = "frame_left",
		texture_id = "frame_left"
	}
	var_1_3.frame_top = {
		texture_id = "morris_gaze_header",
		uvs = {
			{
				0,
				0
			},
			{
				1,
				0.5
			}
		}
	}
	var_1_3.frame_bottom = {
		texture_id = "morris_gaze_header",
		uvs = {
			{
				0,
				0.5
			},
			{
				1,
				1
			}
		}
	}
	var_1_3.frame_right = {
		texture_id = "menu_frame_detail_morris",
		uvs = {
			{
				1,
				0
			},
			{
				0,
				1
			}
		}
	}
	var_1_3.frame_left = "menu_frame_detail_morris"
	var_1_4.frame_top = {
		vertical_alignment = "top",
		horizontal_alignment = "center",
		texture_size = {
			var_0_7.right_window.size[1],
			var_1_7.size[2] * 0.5 * var_0_7.right_window.size[1] / var_1_7.size[1]
		},
		offset = {
			0,
			var_1_7.size[2] * 0.5 * var_0_7.right_window.size[1] / var_1_7.size[1] - 13,
			1
		}
	}
	var_1_4.frame_bottom = {
		vertical_alignment = "bottom",
		horizontal_alignment = "center",
		texture_size = {
			var_0_7.right_window.size[1],
			var_1_7.size[2] * 0.5 * var_0_7.right_window.size[1] / var_1_7.size[1]
		},
		offset = {
			0,
			-20,
			1
		}
	}
	var_1_4.frame_right = {
		vertical_alignment = "center",
		horizontal_alignment = "right",
		texture_size = {
			var_1_8.size[1],
			var_0_7.right_window.size[2]
		},
		offset = {
			var_1_8.size[1] - 5,
			0,
			1
		}
	}
	var_1_4.frame_left = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			var_1_8.size[1],
			var_0_7.right_window.size[2]
		},
		offset = {
			-var_1_8.size[1] + 5,
			0,
			1
		}
	}
	var_1_1.passes = var_1_2
	var_1_0.element = var_1_1
	var_1_0.content = var_1_3
	var_1_0.style = var_1_4
	var_1_0.scenegraph_id = "right_window"
	var_1_0.offset = arg_1_1 or {
		0,
		0,
		0
	}

	return var_1_0
end

local function var_0_10(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = {}
	local var_2_1 = {}
	local var_2_2 = {}
	local var_2_3 = {}
	local var_2_4 = {}

	var_2_2[#var_2_2 + 1] = {
		style_id = "header",
		pass_type = "text",
		text_id = "header"
	}
	var_2_2[#var_2_2 + 1] = {
		pass_type = "texture",
		style_id = "plus_horizontal",
		texture_id = "masked_rect",
		content_check_function = function (arg_3_0, arg_3_1)
			return arg_2_2 and arg_2_2 == "boon"
		end
	}
	var_2_2[#var_2_2 + 1] = {
		pass_type = "texture",
		style_id = "plus_vertical",
		texture_id = "masked_rect",
		content_check_function = function (arg_4_0, arg_4_1)
			return arg_2_2 and arg_2_2 == "boon"
		end
	}
	var_2_2[#var_2_2 + 1] = {
		pass_type = "texture",
		style_id = "minus",
		texture_id = "masked_rect",
		content_check_function = function (arg_5_0, arg_5_1)
			return arg_2_2 and arg_2_2 == "curse"
		end
	}
	var_2_3.header = arg_2_0
	var_2_3.masked_rect = "rect_masked"

	local var_2_5 = 32

	var_2_4.header = {
		vertical_alignment = "top",
		upper_case = true,
		localize = true,
		horizontal_alignment = "left",
		font_type = "hell_shark_header_masked",
		font_size = var_2_5,
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			arg_2_2 and 25 or 0,
			0,
			2
		}
	}
	var_2_4.plus_horizontal = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		color = {
			255,
			255,
			255,
			0
		},
		texture_size = {
			20,
			4
		},
		offset = {
			0,
			-14,
			0
		}
	}
	var_2_4.plus_vertical = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		color = {
			255,
			255,
			255,
			0
		},
		texture_size = {
			4,
			20
		},
		offset = {
			8,
			-6,
			0
		}
	}
	var_2_4.minus = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		color = {
			255,
			255,
			0,
			0
		},
		texture_size = {
			20,
			4
		},
		offset = {
			0,
			-14,
			0
		}
	}
	var_2_1.passes = var_2_2
	var_2_0.element = var_2_1
	var_2_0.content = var_2_3
	var_2_0.style = var_2_4
	var_2_0.scenegraph_id = "info_box_anchor"
	var_2_0.offset = {
		0,
		arg_2_1,
		2
	}

	return var_2_0
end

local function var_0_11(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = {}
	local var_6_1 = {}
	local var_6_2 = {}
	local var_6_3 = {}
	local var_6_4 = {}

	var_6_2[#var_6_2 + 1] = {
		style_id = "title",
		pass_type = "text",
		text_id = "title"
	}
	var_6_2[#var_6_2 + 1] = {
		style_id = "desc",
		pass_type = "text",
		text_id = "desc"
	}
	var_6_2[#var_6_2 + 1] = {
		pass_type = "texture",
		style_id = "icon",
		texture_id = "icon"
	}
	var_6_3.title = arg_6_1
	var_6_3.desc = arg_6_2
	var_6_3.icon = arg_6_0

	local var_6_5 = 10

	var_6_4.title = {
		word_wrap = true,
		horizontal_alignment = "left",
		localize = true,
		font_size = 22,
		vertical_alignment = "top",
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			35 + var_6_5,
			-3,
			2
		},
		area_size = {
			var_0_7.info_box.size[1] - 35 - var_6_5,
			50
		}
	}
	var_6_4.desc = {
		word_wrap = true,
		horizontal_alignment = "left",
		localize = false,
		font_size = 22,
		vertical_alignment = "top",
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			35 + var_6_5,
			-30,
			2
		},
		area_size = {
			var_0_7.info_box.size[1] - 35 - var_6_5,
			50
		}
	}
	var_6_4.icon = {
		vertical_alignment = "top",
		masked = true,
		horizontal_alignment = "left",
		color = {
			255,
			255,
			255,
			255
		},
		texture_size = {
			25,
			25
		},
		offset = {
			var_6_5,
			-5,
			0
		}
	}
	var_6_1.passes = var_6_2
	var_6_0.element = var_6_1
	var_6_0.content = var_6_3
	var_6_0.style = var_6_4
	var_6_0.scenegraph_id = "info_box_anchor"
	var_6_0.offset = {
		0,
		arg_6_3,
		2
	}

	return var_6_0
end

local function var_0_12(arg_7_0, arg_7_1)
	local var_7_0 = {}
	local var_7_1 = {}
	local var_7_2 = {}
	local var_7_3 = {}
	local var_7_4 = {}

	var_7_2[#var_7_2 + 1] = {
		style_id = "difficulty",
		pass_type = "text",
		text_id = "difficulty"
	}
	var_7_2[#var_7_2 + 1] = {
		style_id = "desc",
		pass_type = "text",
		text_id = "desc"
	}
	var_7_2[#var_7_2 + 1] = {
		pass_type = "texture",
		style_id = "icon",
		texture_id = "icon"
	}
	var_7_2[#var_7_2 + 1] = {
		pass_type = "texture",
		style_id = "checkmark",
		texture_id = "checkmark",
		content_check_function = function (arg_8_0)
			return arg_8_0.collected
		end
	}
	var_7_2[#var_7_2 + 1] = {
		pass_type = "texture",
		style_id = "frame",
		texture_id = "frame"
	}
	var_7_2[#var_7_2 + 1] = {
		style_id = "num_rewards",
		pass_type = "text",
		text_id = "num_rewards_text",
		content_check_function = function (arg_9_0)
			return arg_9_0.num_rewards > 1
		end
	}
	var_7_2[#var_7_2 + 1] = {
		style_id = "num_rewards_shadow",
		pass_type = "text",
		text_id = "num_rewards_text",
		content_check_function = function (arg_10_0)
			return arg_10_0.num_rewards > 1
		end
	}
	var_7_3.frame = "button_frame_01"
	var_7_3.difficulty = arg_7_0.difficulty_name or "MISSING DIFFICULTY"
	var_7_3.desc = arg_7_0.desc or "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
	var_7_3.icon = arg_7_0.icon or "icon_placeholder"
	var_7_3.num_rewards = arg_7_0.num_rewards
	var_7_3.num_rewards_text = "x" .. var_7_3.num_rewards
	var_7_3.checkmark = "plain_checkmark"
	var_7_3.collected = arg_7_0.collected

	local var_7_5 = 40

	var_7_4.difficulty = {
		vertical_alignment = "top",
		font_size = 22,
		horizontal_alignment = "left",
		word_wrap = true,
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			50 + var_7_5,
			0,
			2
		},
		area_size = {
			var_0_7.info_box.size[1] - 50 - var_7_5,
			50
		}
	}
	var_7_4.desc = {
		vertical_alignment = "top",
		font_size = 22,
		horizontal_alignment = "left",
		word_wrap = true,
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			50 + var_7_5,
			-22,
			2
		},
		area_size = {
			var_0_7.info_box.size[1] - 50 - var_7_5,
			50
		}
	}
	var_7_4.num_rewards = {
		vertical_alignment = "top",
		font_size = 22,
		horizontal_alignment = "left",
		word_wrap = true,
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			var_7_5 + 20,
			-22,
			6
		}
	}
	var_7_4.num_rewards_shadow = {
		vertical_alignment = "top",
		font_size = 25,
		horizontal_alignment = "left",
		word_wrap = true,
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			var_7_5 + 20 + 1,
			-23,
			5
		}
	}
	var_7_4.icon = {
		vertical_alignment = "top",
		masked = true,
		horizontal_alignment = "left",
		color = {
			255,
			255,
			255,
			255
		},
		texture_size = {
			40,
			40
		},
		offset = {
			var_7_5,
			-5,
			0
		}
	}
	var_7_4.frame = {
		vertical_alignment = "top",
		masked = true,
		horizontal_alignment = "left",
		color = {
			255,
			255,
			255,
			255
		},
		texture_size = {
			40,
			40
		},
		offset = {
			var_7_5,
			-5,
			1
		}
	}
	var_7_4.checkmark = {
		vertical_alignment = "top",
		masked = true,
		horizontal_alignment = "left",
		color = {
			255,
			0,
			255,
			0
		},
		texture_size = {
			15,
			15
		},
		offset = {
			10,
			-20,
			0
		}
	}
	var_7_1.passes = var_7_2
	var_7_0.element = var_7_1
	var_7_0.content = var_7_3
	var_7_0.style = var_7_4
	var_7_0.scenegraph_id = "info_box_anchor"
	var_7_0.offset = {
		0,
		arg_7_1,
		2
	}

	return var_7_0
end

local var_0_13 = true
local var_0_14 = {
	quickplay_gamemode_info_box = UIWidgets.create_start_game_deus_gamemode_info_box("adventure_background", var_0_7.adventure_background.size, Localize("cw_weekly_expedition_name_long"), string.gsub(Localize("cw_weekly_expedition_description"), Localize("expedition_highlight_text"), "{#color(255,168,0)}" .. Localize("expedition_highlight_text") .. "{#reset()}"), false, true),
	difficulty_stepper = UIWidgets.create_start_game_difficulty_stepper("difficulty_stepper", Localize("start_game_window_difficulty"), "difficulty_option_1"),
	difficulty_info = UIWidgets.create_start_game_deus_difficulty_info_box("difficulty_info", var_0_7.difficulty_info.size),
	upsell_button = UIWidgets.create_simple_two_state_button("upsell_button", "icon_redirect", "icon_redirect_hover"),
	play_button = UIWidgets.create_start_game_deus_play_button("play_button", var_0_7.play_button.size, Localize("start_game_window_play"), 34, var_0_13),
	info_box_bg = UIWidgets.create_simple_rect("right_window", {
		164,
		0,
		0,
		0
	}),
	info_box_mask = UIWidgets.create_simple_texture("mask_rect", "info_box", nil, nil, {
		255,
		255,
		255,
		255
	}),
	timer = UIWidgets.create_simple_text("4 Days, 11h 49min", "right_window", 28, nil, var_0_8),
	divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "divider")
}
local var_0_15 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				arg_11_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				local var_12_0 = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.alpha_multiplier = var_12_0
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				arg_14_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				arg_15_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end
		}
	},
	gamemode_text_swap = {
		{
			name = "gamemode_swap_text_fade_out",
			start_progress = 0,
			end_progress = 0.2,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				local var_18_0 = math.easeOutCubic(arg_18_3)

				arg_18_2.style.game_mode_text.text_color[1] = 255 * (1 - var_18_0)
				arg_18_2.style.press_key_text.text_color[1] = 255 * (1 - var_18_0)

				if arg_18_2.content.show_note then
					arg_18_2.style.note_text.text_color[1] = 255 * (1 - var_18_0)
				end
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end
		},
		{
			name = "gamemode_swap_text_fade_in",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end,
			update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				if arg_21_2.content.is_showing_info then
					arg_21_2.content.game_mode_text = Localize("expedition_info")
					arg_21_2.content.show_note = true
				else
					arg_21_2.content.game_mode_text = string.gsub(Localize("cw_weekly_expedition_description"), Localize("expedition_highlight_text"), "{#color(255,168,0)}" .. Localize("expedition_highlight_text") .. "{#reset()}")
					arg_21_2.content.show_note = false
				end

				arg_21_2.style.game_mode_text.text_color[1] = 255 * math.easeOutCubic(arg_21_3)
				arg_21_2.style.press_key_text.text_color[1] = 255 * math.easeOutCubic(arg_21_3)

				if arg_21_2.content.show_note then
					arg_21_2.style.note_text.text_color[1] = 255 * math.easeOutCubic(arg_21_3)
				end
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				return
			end
		}
	},
	right_arrow_flick = {
		{
			name = "right_arrow_flick",
			start_progress = 0,
			end_progress = 0.6,
			init = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				return
			end,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				arg_24_4.right_key.color[1] = 255 * (1 - math.easeOutCubic(arg_24_3))
			end,
			on_complete = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				arg_25_2.content.right_arrow_pressed = false
			end
		}
	},
	left_arrow_flick = {
		{
			name = "left_arrow_flick",
			start_progress = 0,
			end_progress = 0.6,
			init = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				return
			end,
			update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				arg_27_4.left_key.color[1] = 255 * (1 - math.easeOutCubic(arg_27_3))
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				arg_28_2.content.left_arrow_pressed = false
			end
		}
	},
	difficulty_info_enter = {
		{
			name = "difficulty_info_enter",
			start_progress = 0,
			end_progress = 0.6,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				arg_29_2.difficulty_info.content.visible = true

				local var_29_0 = arg_29_2.difficulty_info.style

				var_29_0.background.color[1] = 0
				var_29_0.border.color[1] = 0
				var_29_0.difficulty_description.text_color[1] = 0
				var_29_0.highest_obtainable_level.text_color[1] = 0
				var_29_0.difficulty_separator.color[1] = 0
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				local var_30_0 = math.easeOutCubic(arg_30_3)
				local var_30_1 = arg_30_2.difficulty_info
				local var_30_2 = arg_30_2.difficulty_info.style
				local var_30_3 = arg_30_2.difficulty_info.content

				var_30_1.offset[1] = 50 * var_30_0
				arg_30_2.upsell_button.offset[1] = 50 * var_30_0

				local var_30_4 = 200 * var_30_0

				var_30_2.background.color[1] = var_30_4
				var_30_2.border.color[1] = var_30_4

				local var_30_5 = 255 * var_30_0

				var_30_2.difficulty_description.text_color[1] = var_30_5
				var_30_2.highest_obtainable_level.text_color[1] = var_30_5
				var_30_2.difficulty_separator.color[1] = var_30_5

				if var_30_3.should_show_diff_lock_text then
					var_30_2.difficulty_lock_text.text_color[1] = var_30_5
				end

				if var_30_3.should_show_dlc_lock then
					var_30_2.dlc_lock_text.text_color[1] = var_30_5
				end
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end
		}
	}
}
local var_0_16 = {
	{
		widget_name = "difficulty_stepper",
		enter_requirements = function (arg_32_0)
			return true
		end,
		on_enter = function (arg_33_0, arg_33_1, arg_33_2)
			arg_33_0._widgets_by_name.difficulty_stepper.content.is_selected = true
		end,
		update = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
			local var_34_0 = arg_34_0._widgets_by_name.difficulty_stepper
			local var_34_1 = {
				difficulty_info = arg_34_0._widgets_by_name.difficulty_info,
				upsell_button = arg_34_0._widgets_by_name.upsell_button
			}

			if not arg_34_0.diff_info_anim_played then
				arg_34_0._diff_anim_id = arg_34_0._ui_animator:start_animation("difficulty_info_enter", var_34_1, var_0_7)
				arg_34_0.diff_info_anim_played = true
			end

			local var_34_2 = {}

			if arg_34_1:get("move_left") then
				arg_34_0:_option_selected("difficulty_stepper", "left_arrow", arg_34_3)

				var_34_0.content.left_arrow_pressed = true
				var_34_2.left_key = var_34_0.style.left_arrow_gamepad_highlight

				if arg_34_0._arrow_anim_id then
					arg_34_0._ui_animator:stop_animation(arg_34_0._arrow_anim_id)

					var_34_0.style.right_arrow_gamepad_highlight.color[1] = 0
				end

				arg_34_0._arrow_anim_id = arg_34_0._ui_animator:start_animation("left_arrow_flick", var_34_0, var_0_7, var_34_2)
			elseif arg_34_1:get("move_right") then
				arg_34_0:_option_selected("difficulty_stepper", "right_arrow", arg_34_3)

				var_34_0.content.right_arrow_pressed = true
				var_34_2.right_key = var_34_0.style.right_arrow_gamepad_highlight

				if arg_34_0._arrow_anim_id then
					arg_34_0._ui_animator:stop_animation(arg_34_0._arrow_anim_id)

					var_34_0.style.left_arrow_gamepad_highlight.color[1] = 0
				end

				arg_34_0._arrow_anim_id = arg_34_0._ui_animator:start_animation("right_arrow_flick", var_34_0, var_0_7, var_34_2)
			end

			if arg_34_1:get("confirm_press", true) and arg_34_0._dlc_locked then
				Managers.unlock:open_dlc_page(arg_34_0._dlc_name)
			end

			arg_34_0:_update_difficulty_lock()
		end,
		on_exit = function (arg_35_0, arg_35_1, arg_35_2)
			arg_35_0._widgets_by_name.difficulty_stepper.content.is_selected = false

			local var_35_0 = arg_35_0._widgets_by_name.upsell_button
			local var_35_1 = arg_35_0._widgets_by_name.difficulty_info

			if arg_35_0._diff_anim_id then
				arg_35_0._ui_animator:stop_animation(arg_35_0._diff_anim_id)
			end

			var_35_1.content.visible = false
			var_35_0.content.visible = false
			arg_35_0.diff_info_anim_played = false
		end
	},
	{
		widget_name = "play_button",
		enter_requirements = function (arg_36_0)
			return not Managers.input:is_device_active("gamepad")
		end,
		on_enter = function (arg_37_0, arg_37_1, arg_37_2)
			arg_37_0._widgets_by_name.play_button.content.is_selected = true
		end,
		update = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
			if arg_38_1:get("confirm_press") or arg_38_1:get("skip_press") then
				arg_38_0:_option_selected("play_button", nil, arg_38_3)
			end
		end,
		on_exit = function (arg_39_0, arg_39_1, arg_39_2)
			arg_39_0._widgets_by_name.play_button.content.is_selected = false
		end
	}
}

return {
	scenegraph_definition = var_0_7,
	widget_definitions = var_0_14,
	animation_definitions = var_0_15,
	selector_input_definitions = var_0_16,
	create_weekly_event_information_box = var_0_9,
	create_header = var_0_10,
	create_entry_widget = var_0_11,
	create_reward_widget = var_0_12
}
