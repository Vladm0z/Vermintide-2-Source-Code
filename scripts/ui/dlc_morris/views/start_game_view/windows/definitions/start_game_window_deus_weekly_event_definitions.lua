-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_weekly_event_definitions.lua

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
	adventure_background = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1] + 70,
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
			tbl[1],
			tbl[2]
		},
		position = {
			-15,
			-105 + tbl[2] * 2,
			1
		}
	},
	right_window = {
		vertical_alignment = "top",
		parent = "menu_root",
		horizontal_alignment = "right",
		size = {
			size[1],
			size[2]
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
			size[1],
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
			tbl[1],
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
			tbl[1],
			tbl[2]
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
		size = tbl_2,
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
			size[1] - 50,
			size[2] - 80
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
			size[1],
			size[2] - 40
		}
	},
	scrollbar_window = {
		parent = "scrollbar_anchor",
		size = {
			size[1] - 20,
			size[2] - 40
		}
	}
}
local tbl_4 = {
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

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local tbl = {}
	local tbl_2 = {}
	local tbl_4 = {}
	local tbl_5 = {}
	local tbl_6 = {}
	local str = "morris_gaze_header"
	local str_2 = "menu_frame_detail_morris"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local get_atlas_settings_by_texture_name_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)

	tbl_4[#tbl_4 + 1] = {
		style_id = "frame_top",
		pass_type = "texture_uv",
		content_id = "frame_top"
	}
	tbl_4[#tbl_4 + 1] = {
		style_id = "frame_bottom",
		pass_type = "texture_uv",
		content_id = "frame_bottom"
	}
	tbl_4[#tbl_4 + 1] = {
		style_id = "frame_right",
		pass_type = "texture_uv",
		content_id = "frame_right"
	}
	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		style_id = "frame_left",
		texture_id = "frame_left"
	}
	tbl_5.frame_top = {
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
	tbl_5.frame_bottom = {
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
	tbl_5.frame_right = {
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
	tbl_5.frame_left = "menu_frame_detail_morris"
	tbl_6.frame_top = {
		vertical_alignment = "top",
		horizontal_alignment = "center",
		texture_size = {
			tbl_3.right_window.size[1],
			get_atlas_settings_by_texture_name.size[2] * 0.5 * tbl_3.right_window.size[1] / get_atlas_settings_by_texture_name.size[1]
		},
		offset = {
			0,
			get_atlas_settings_by_texture_name.size[2] * 0.5 * tbl_3.right_window.size[1] / get_atlas_settings_by_texture_name.size[1] - 13,
			1
		}
	}
	tbl_6.frame_bottom = {
		vertical_alignment = "bottom",
		horizontal_alignment = "center",
		texture_size = {
			tbl_3.right_window.size[1],
			get_atlas_settings_by_texture_name.size[2] * 0.5 * tbl_3.right_window.size[1] / get_atlas_settings_by_texture_name.size[1]
		},
		offset = {
			0,
			-20,
			1
		}
	}
	tbl_6.frame_right = {
		vertical_alignment = "center",
		horizontal_alignment = "right",
		texture_size = {
			get_atlas_settings_by_texture_name_2.size[1],
			tbl_3.right_window.size[2]
		},
		offset = {
			get_atlas_settings_by_texture_name_2.size[1] - 5,
			0,
			1
		}
	}
	tbl_6.frame_left = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			get_atlas_settings_by_texture_name_2.size[1],
			tbl_3.right_window.size[2]
		},
		offset = {
			-get_atlas_settings_by_texture_name_2.size[1] + 5,
			0,
			1
		}
	}
	tbl_2.passes = tbl_4
	tbl.element = tbl_2
	tbl.content = tbl_5
	tbl.style = tbl_6
	tbl.scenegraph_id = "right_window"
	tbl.offset = arg_1_1 or {
		0,
		0,
		0
	}

	return tbl
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {}

	tbl_3[#tbl_3 + 1] = {
		style_id = "header",
		pass_type = "text",
		text_id = "header"
	}
	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		style_id = "plus_horizontal",
		texture_id = "masked_rect",
		content_check_function = function (arg_3_0, arg_3_1)
			-- function 3
			local var_3_0 = arg_2_2

			var_3_0 = not var_3_0 and arg_2_2 == "boon"

			return var_3_0
		end
	}
	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		style_id = "plus_vertical",
		texture_id = "masked_rect",
		content_check_function = function (arg_4_0, arg_4_1)
			-- function 4
			local var_4_0 = arg_2_2

			var_4_0 = not var_4_0 and arg_2_2 == "boon"

			return var_4_0
		end
	}
	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		style_id = "minus",
		texture_id = "masked_rect",
		content_check_function = function (arg_5_0, arg_5_1)
			-- function 5
			local var_5_0 = arg_2_2

			var_5_0 = not var_5_0 and arg_2_2 == "curse"

			return var_5_0
		end
	}
	tbl_4.header = arg_2_0
	tbl_4.masked_rect = "rect_masked"

	local num = 32
	local tbl_6 = {
		vertical_alignment = "top",
		upper_case = true,
		localize = true,
		horizontal_alignment = "left",
		font_type = "hell_shark_header_masked",
		font_size = num,
		text_color = Colors.get_color_table_with_alpha("white", 255)
	}
	local tbl_7 = {
		nil,
		0,
		2
	}
	local flag

	flag = not arg_2_2 and 25 and 0
	tbl_7[1] = flag
	tbl_6.offset = tbl_7
	tbl_5.header = tbl_6
	tbl_5.plus_horizontal = {
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
	tbl_5.plus_vertical = {
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
	tbl_5.minus = {
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
	tbl_2.passes = tbl_3
	tbl.element = tbl_2
	tbl.content = tbl_4
	tbl.style = tbl_5
	tbl.scenegraph_id = "info_box_anchor"
	tbl.offset = {
		0,
		arg_2_1,
		2
	}

	return tbl
end

local function fn_3(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local tbl = {}
	local tbl_2 = {}
	local tbl_4 = {}
	local tbl_5 = {}
	local tbl_6 = {}

	tbl_4[#tbl_4 + 1] = {
		style_id = "title",
		pass_type = "text",
		text_id = "title"
	}
	tbl_4[#tbl_4 + 1] = {
		style_id = "desc",
		pass_type = "text",
		text_id = "desc"
	}
	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		style_id = "icon",
		texture_id = "icon"
	}
	tbl_5.title = arg_6_1
	tbl_5.desc = arg_6_2
	tbl_5.icon = arg_6_0

	local num = 10

	tbl_6.title = {
		word_wrap = true,
		horizontal_alignment = "left",
		localize = true,
		font_size = 22,
		vertical_alignment = "top",
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			35 + num,
			-3,
			2
		},
		area_size = {
			tbl_3.info_box.size[1] - 35 - num,
			50
		}
	}
	tbl_6.desc = {
		word_wrap = true,
		horizontal_alignment = "left",
		localize = false,
		font_size = 22,
		vertical_alignment = "top",
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			35 + num,
			-30,
			2
		},
		area_size = {
			tbl_3.info_box.size[1] - 35 - num,
			50
		}
	}
	tbl_6.icon = {
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
			num,
			-5,
			0
		}
	}
	tbl_2.passes = tbl_4
	tbl.element = tbl_2
	tbl.content = tbl_5
	tbl.style = tbl_6
	tbl.scenegraph_id = "info_box_anchor"
	tbl.offset = {
		0,
		arg_6_3,
		2
	}

	return tbl
end

local function fn_4(self, arg_7_1)
	-- function 7
	local tbl = {}
	local tbl_2 = {}
	local tbl_4 = {}
	local tbl_5 = {}
	local tbl_6 = {}

	tbl_4[#tbl_4 + 1] = {
		style_id = "difficulty",
		pass_type = "text",
		text_id = "difficulty"
	}
	tbl_4[#tbl_4 + 1] = {
		style_id = "desc",
		pass_type = "text",
		text_id = "desc"
	}
	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		style_id = "icon",
		texture_id = "icon"
	}
	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		style_id = "checkmark",
		texture_id = "checkmark",
		content_check_function = function (self)
			-- function 8
			return self.collected
		end
	}
	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		style_id = "frame",
		texture_id = "frame"
	}
	tbl_4[#tbl_4 + 1] = {
		style_id = "num_rewards",
		pass_type = "text",
		text_id = "num_rewards_text",
		content_check_function = function (self)
			-- function 9
			return self.num_rewards > 1
		end
	}
	tbl_4[#tbl_4 + 1] = {
		style_id = "num_rewards_shadow",
		pass_type = "text",
		text_id = "num_rewards_text",
		content_check_function = function (self)
			-- function 10
			return self.num_rewards > 1
		end
	}
	tbl_5.frame = "button_frame_01"

	local difficulty_name = self.difficulty_name

	difficulty_name = difficulty_name or "MISSING DIFFICULTY"
	tbl_5.difficulty = difficulty_name

	local desc = self.desc

	desc = desc or "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
	tbl_5.desc = desc

	local icon = self.icon

	icon = icon or "icon_placeholder"
	tbl_5.icon = icon
	tbl_5.num_rewards = self.num_rewards
	tbl_5.num_rewards_text = "x" .. tbl_5.num_rewards
	tbl_5.checkmark = "plain_checkmark"
	tbl_5.collected = self.collected

	local num = 40

	tbl_6.difficulty = {
		vertical_alignment = "top",
		font_size = 22,
		horizontal_alignment = "left",
		word_wrap = true,
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			50 + num,
			0,
			2
		},
		area_size = {
			tbl_3.info_box.size[1] - 50 - num,
			50
		}
	}
	tbl_6.desc = {
		vertical_alignment = "top",
		font_size = 22,
		horizontal_alignment = "left",
		word_wrap = true,
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			50 + num,
			-22,
			2
		},
		area_size = {
			tbl_3.info_box.size[1] - 50 - num,
			50
		}
	}
	tbl_6.num_rewards = {
		vertical_alignment = "top",
		font_size = 22,
		horizontal_alignment = "left",
		word_wrap = true,
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			num + 20,
			-22,
			6
		}
	}
	tbl_6.num_rewards_shadow = {
		vertical_alignment = "top",
		font_size = 25,
		horizontal_alignment = "left",
		word_wrap = true,
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			num + 20 + 1,
			-23,
			5
		}
	}
	tbl_6.icon = {
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
			num,
			-5,
			0
		}
	}
	tbl_6.frame = {
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
			num,
			-5,
			1
		}
	}
	tbl_6.checkmark = {
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
	tbl_2.passes = tbl_4
	tbl.element = tbl_2
	tbl.content = tbl_5
	tbl.style = tbl_6
	tbl.scenegraph_id = "info_box_anchor"
	tbl.offset = {
		0,
		arg_7_1,
		2
	}

	return tbl
end

local flag = true
local tbl_5 = {
	quickplay_gamemode_info_box = UIWidgets.create_start_game_deus_gamemode_info_box("adventure_background", tbl_3.adventure_background.size, Localize("cw_weekly_expedition_name_long"), string.gsub(Localize("cw_weekly_expedition_description"), Localize("expedition_highlight_text"), "{#color(255,168,0)}" .. Localize("expedition_highlight_text") .. "{#reset()}"), false, true),
	difficulty_stepper = UIWidgets.create_start_game_difficulty_stepper("difficulty_stepper", Localize("start_game_window_difficulty"), "difficulty_option_1"),
	difficulty_info = UIWidgets.create_start_game_deus_difficulty_info_box("difficulty_info", tbl_3.difficulty_info.size),
	upsell_button = UIWidgets.create_simple_two_state_button("upsell_button", "icon_redirect", "icon_redirect_hover"),
	play_button = UIWidgets.create_start_game_deus_play_button("play_button", tbl_3.play_button.size, Localize("start_game_window_play"), 34, flag),
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
	timer = UIWidgets.create_simple_text("4 Days, 11h 49min", "right_window", 28, nil, tbl_4),
	divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "divider")
}
local tbl_6 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				arg_11_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				-- function 12
				local easeOutCubic = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
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
				-- function 14
				arg_14_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				-- function 15
				arg_15_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
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
				-- function 17
				return
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				-- function 18
				local easeOutCubic = math.easeOutCubic(arg_18_3)

				arg_18_2.style.game_mode_text.text_color[1] = 255 * (1 - easeOutCubic)
				arg_18_2.style.press_key_text.text_color[1] = 255 * (1 - easeOutCubic)

				if not arg_18_2.content.show_note then
					arg_18_2.style.note_text.text_color[1] = 255 * (1 - easeOutCubic)
				end
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end
		},
		{
			name = "gamemode_swap_text_fade_in",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				return
			end,
			update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				-- function 21
				if not arg_21_2.content.is_showing_info then
					arg_21_2.content.game_mode_text = Localize("expedition_info")
					arg_21_2.content.show_note = true
				else
					arg_21_2.content.game_mode_text = string.gsub(Localize("cw_weekly_expedition_description"), Localize("expedition_highlight_text"), "{#color(255,168,0)}" .. Localize("expedition_highlight_text") .. "{#reset()}")
					arg_21_2.content.show_note = false
				end

				arg_21_2.style.game_mode_text.text_color[1] = 255 * math.easeOutCubic(arg_21_3)
				arg_21_2.style.press_key_text.text_color[1] = 255 * math.easeOutCubic(arg_21_3)

				if not arg_21_2.content.show_note then
					arg_21_2.style.note_text.text_color[1] = 255 * math.easeOutCubic(arg_21_3)
				end
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
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
				-- function 23
				return
			end,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				-- function 24
				arg_24_4.right_key.color[1] = 255 * (1 - math.easeOutCubic(arg_24_3))
			end,
			on_complete = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
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
				-- function 26
				return
			end,
			update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				-- function 27
				arg_27_4.left_key.color[1] = 255 * (1 - math.easeOutCubic(arg_27_3))
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
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
				-- function 29
				arg_29_2.difficulty_info.content.visible = true

				local style = arg_29_2.difficulty_info.style

				style.background.color[1] = 0
				style.border.color[1] = 0
				style.difficulty_description.text_color[1] = 0
				style.highest_obtainable_level.text_color[1] = 0
				style.difficulty_separator.color[1] = 0
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				-- function 30
				local easeOutCubic = math.easeOutCubic(arg_30_3)
				local difficulty_info = arg_30_2.difficulty_info
				local style = arg_30_2.difficulty_info.style
				local content = arg_30_2.difficulty_info.content

				difficulty_info.offset[1] = 50 * easeOutCubic
				arg_30_2.upsell_button.offset[1] = 50 * easeOutCubic

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
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				return
			end
		}
	}
}
local tbl_7 = {
	{
		widget_name = "difficulty_stepper",
		enter_requirements = function (arg_32_0)
			-- function 32
			return true
		end,
		on_enter = function (arg_33_0, arg_33_1, arg_33_2)
			-- function 33
			arg_33_0._widgets_by_name.difficulty_stepper.content.is_selected = true
		end,
		update = function (self, arg_34_1, arg_34_2, arg_34_3)
			-- function 34
			local difficulty_stepper = self._widgets_by_name.difficulty_stepper
			local tbl = {
				difficulty_info = self._widgets_by_name.difficulty_info,
				upsell_button = self._widgets_by_name.upsell_button
			}

			if not self.diff_info_anim_played then
				self._diff_anim_id = self._ui_animator:start_animation("difficulty_info_enter", tbl, tbl_3)
				self.diff_info_anim_played = true
			end

			local tbl_2 = {}

			if not arg_34_1:get("move_left") then
				self:_option_selected("difficulty_stepper", "left_arrow", arg_34_3)

				difficulty_stepper.content.left_arrow_pressed = true
				tbl_2.left_key = difficulty_stepper.style.left_arrow_gamepad_highlight

				if not self._arrow_anim_id then
					self._ui_animator:stop_animation(self._arrow_anim_id)

					difficulty_stepper.style.right_arrow_gamepad_highlight.color[1] = 0
				end

				self._arrow_anim_id = self._ui_animator:start_animation("left_arrow_flick", difficulty_stepper, tbl_3, tbl_2)
			elseif not arg_34_1:get("move_right") then
				self:_option_selected("difficulty_stepper", "right_arrow", arg_34_3)

				difficulty_stepper.content.right_arrow_pressed = true
				tbl_2.right_key = difficulty_stepper.style.right_arrow_gamepad_highlight

				if not self._arrow_anim_id then
					self._ui_animator:stop_animation(self._arrow_anim_id)

					difficulty_stepper.style.left_arrow_gamepad_highlight.color[1] = 0
				end

				self._arrow_anim_id = self._ui_animator:start_animation("right_arrow_flick", difficulty_stepper, tbl_3, tbl_2)
			end

			if not arg_34_1:get("confirm_press", true) and not self._dlc_locked then
				Managers.unlock:open_dlc_page(self._dlc_name)
			end

			self:_update_difficulty_lock()
		end,
		on_exit = function (self, arg_35_1, arg_35_2)
			-- function 35
			self._widgets_by_name.difficulty_stepper.content.is_selected = false

			local upsell_button = self._widgets_by_name.upsell_button
			local difficulty_info = self._widgets_by_name.difficulty_info

			if not self._diff_anim_id then
				self._ui_animator:stop_animation(self._diff_anim_id)
			end

			difficulty_info.content.visible = false
			upsell_button.content.visible = false
			self.diff_info_anim_played = false
		end
	},
	{
		widget_name = "play_button",
		enter_requirements = function (arg_36_0)
			-- function 36
			return not Managers.input:is_device_active("gamepad")
		end,
		on_enter = function (arg_37_0, arg_37_1, arg_37_2)
			-- function 37
			arg_37_0._widgets_by_name.play_button.content.is_selected = true
		end,
		update = function (self, arg_38_1, arg_38_2, arg_38_3)
			-- function 38
			if arg_38_1:get("confirm_press") or not arg_38_1:get("skip_press") then
				self:_option_selected("play_button", nil, arg_38_3)
			end
		end,
		on_exit = function (arg_39_0, arg_39_1, arg_39_2)
			-- function 39
			arg_39_0._widgets_by_name.play_button.content.is_selected = false
		end
	}
}

return {
	scenegraph_definition = tbl_3,
	widget_definitions = tbl_5,
	animation_definitions = tbl_6,
	selector_input_definitions = tbl_7,
	create_weekly_event_information_box = fn,
	create_header = fn_2,
	create_entry_widget = fn_3,
	create_reward_widget = fn_4
}
