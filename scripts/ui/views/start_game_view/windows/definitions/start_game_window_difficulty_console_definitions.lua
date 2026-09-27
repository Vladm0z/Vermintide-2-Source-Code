-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_difficulty_console_definitions.lua

local game_start_windows = UISettings.game_start_windows
local frame = game_start_windows.frame
local size = game_start_windows.size
local var_0_3 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_4 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local num = size[1] - (var_0_3 * 2 + 60)
local tbl = {
	size[1],
	150
}
local num_2 = 0
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
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		},
		{
			name = "animate_in_window",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeOutCubic = math.easeOutCubic(arg_5_3)

				arg_5_0.window.local_position[1] = arg_5_1.window.position[1] + math.floor(-100 * (1 - easeOutCubic))
				arg_5_0.info_window.local_position[1] = arg_5_1.info_window.position[1] + math.floor(-80 * (1 - easeOutCubic))
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				arg_7_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				arg_8_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
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
	info_window = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1],
			size[2]
		},
		position = {
			size[1] + 200,
			50,
			1
		}
	},
	background = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			size[1],
			800
		},
		position = {
			0,
			-45,
			0
		}
	},
	difficulty_root = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-80,
			-var_0_4 / 2,
			1
		}
	},
	difficulty_option = {
		vertical_alignment = "top",
		parent = "difficulty_root",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			0,
			0,
			0
		}
	},
	difficulty_texture = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			150,
			150
		},
		position = {
			0,
			-30,
			1
		}
	},
	difficulty_title = {
		vertical_alignment = "bottom",
		parent = "difficulty_texture",
		horizontal_alignment = "center",
		size = {
			num,
			50
		},
		position = {
			0,
			-70,
			1
		}
	},
	difficulty_title_divider = {
		vertical_alignment = "top",
		parent = "difficulty_title",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-50,
			1
		}
	},
	description_background = {
		vertical_alignment = "top",
		parent = "difficulty_title_divider",
		horizontal_alignment = "center",
		size = {
			264,
			200
		},
		position = {
			0,
			0,
			1
		}
	},
	description_text = {
		vertical_alignment = "center",
		parent = "description_background",
		horizontal_alignment = "center",
		size = {
			num + 40,
			120
		},
		position = {
			0,
			20,
			1
		}
	},
	rewards_title = {
		vertical_alignment = "top",
		parent = "description_background",
		horizontal_alignment = "center",
		size = {
			num,
			30
		},
		position = {
			0,
			-160,
			0
		}
	},
	difficulty_xp_multiplier = {
		vertical_alignment = "top",
		parent = "rewards_title",
		horizontal_alignment = "center",
		size = {
			num,
			20
		},
		position = {
			0,
			-30,
			0
		}
	},
	difficulty_rewards_anchor = {
		vertical_alignment = "top",
		parent = "difficulty_xp_multiplier",
		horizontal_alignment = "center",
		size = {
			0,
			40
		},
		position = {
			0,
			-35,
			1
		}
	},
	difficulty_chest_info = {
		vertical_alignment = "top",
		parent = "difficulty_rewards_anchor",
		horizontal_alignment = "center",
		size = {
			num,
			20
		},
		position = {
			0,
			-65,
			0
		}
	},
	difficulty_bottom_divider = {
		vertical_alignment = "top",
		parent = "difficulty_chest_info",
		horizontal_alignment = "center",
		size = {
			264,
			21
		},
		position = {
			0,
			-20,
			1
		}
	},
	difficulty_is_locked_text = {
		vertical_alignment = "top",
		parent = "difficulty_bottom_divider",
		horizontal_alignment = "center",
		size = {
			num,
			20
		},
		position = {
			0,
			-70,
			0
		}
	},
	difficulty_lock_text = {
		vertical_alignment = "top",
		parent = "difficulty_is_locked_text",
		horizontal_alignment = "center",
		size = {
			num,
			20
		},
		position = {
			0,
			0,
			0
		}
	},
	requirement_bg = {
		vertical_alignment = "top",
		parent = "difficulty_lock_text",
		horizontal_alignment = "center",
		size = {
			size[1],
			100
		},
		position = {
			0,
			0,
			1
		}
	},
	buy_button = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			477,
			91
		},
		position = {
			0,
			-10,
			40
		}
	},
	title_button_start = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			800,
			30
		},
		position = {
			0,
			-70,
			1
		}
	}
}
local tbl_4 = {
	word_wrap = false,
	upper_case = true,
	localize = false,
	font_size = 26,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = {
		255,
		246,
		56,
		53
	},
	offset = {
		0,
		0,
		2
	}
}
local tbl_5 = {
	font_size = 42,
	upper_case = true,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_6 = {
	font_size = 32,
	upper_case = true,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_7 = {
	word_wrap = true,
	font_size = 18,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_8 = {
	font_size = 20,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		250,
		250,
		250
	},
	offset = {
		0,
		0,
		2
	}
}
local tbl_9 = {
	font_size = 18,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		250,
		250,
		250
	},
	offset = {
		0,
		0,
		2
	}
}
local tbl_10 = {
	font_size = 18,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		199,
		199,
		199
	},
	offset = {
		0,
		-30,
		2
	}
}
local tbl_11 = {
	font_size = 18,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = {
		255,
		199,
		199,
		199
	},
	offset = {
		0,
		-60,
		2
	}
}
local tbl_12 = {
	font_size = 20,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		220,
		148,
		64
	},
	offset = {
		0,
		0,
		2
	}
}
local tbl_13 = {
	font_size = 20,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		193,
		90,
		36
	},
	offset = {
		0,
		25,
		2
	}
}

local function fn(arg_10_0, arg_10_1)
	-- function 10
	local num = 0.8
	local str = "difficulty_option_1"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl = {
		math.floor(get_atlas_settings_by_texture_name.size[1] * num),
		math.floor(get_atlas_settings_by_texture_name.size[2] * num)
	}
	local tbl_2 = {
		math.floor(180 * num),
		math.floor(180 * num)
	}
	local tbl_3 = {
		math.floor(270 * num),
		math.floor(270 * num)
	}
	local tbl_4 = {
		math.floor(414),
		math.floor(118 * num)
	}
	local tbl_5 = {
		tbl_2[1] + 15,
		0,
		-2
	}
	local tbl_6 = {
		tbl_5[1] + 30,
		0,
		5
	}
	local tbl_7 = {}
	local tbl_8 = {}
	local tbl_9 = {}
	local str_2 = "button_hotspot"

	tbl_7[#tbl_7 + 1] = {
		pass_type = "hotspot",
		content_id = str_2
	}
	tbl_8[str_2] = {}

	local str_3 = "selection_background"

	tbl_7[#tbl_7 + 1] = {
		pass_type = "texture_uv",
		content_id = str_3,
		style_id = str_3
	}
	tbl_8[str_3] = {
		texture_id = "item_slot_side_fade",
		uvs = {
			{
				0,
				0
			},
			{
				1,
				1
			}
		}
	}
	tbl_9[str_3] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = tbl_4,
		color = UISettings.console_start_game_menu_rect_color,
		offset = tbl_5
	}

	local str_4 = "bg_effect"

	tbl_7[#tbl_7 + 1] = {
		pass_type = "texture",
		texture_id = str_4,
		style_id = str_4,
		content_check_function = function (self)
			-- function 11
			return self.is_selected
		end
	}
	tbl_9[str_4] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			tbl_4[1],
			tbl_4[2] + 8
		},
		color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			tbl_5[1],
			tbl_5[2],
			tbl_5[3] + 1
		}
	}
	tbl_8[str_4] = "item_slot_side_effect"

	local str_5 = "text_title"
	local str_6 = str_5 .. "_shadow"

	tbl_7[#tbl_7 + 1] = {
		pass_type = "text",
		text_id = str_5,
		style_id = str_5,
		content_change_function = function (self, arg_12_1)
			-- function 12
			if not self.is_selected then
				arg_12_1.text_color = arg_12_1.selected_color
			else
				arg_12_1.text_color = arg_12_1.default_color
			end
		end
	}
	tbl_7[#tbl_7 + 1] = {
		pass_type = "text",
		text_id = str_5,
		style_id = str_6
	}
	tbl_8[str_5] = "n/a"

	local tbl_10 = {
		word_wrap = false,
		upper_case = true,
		localize = false,
		font_size = 42,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark_header",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		selected_color = Colors.get_color_table_with_alpha("white", 255),
		default_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			tbl_6[1],
			tbl_6[2],
			tbl_6[3]
		}
	}
	local clone = table.clone(tbl_10)

	clone.text_color = {
		255,
		0,
		0,
		0
	}
	clone.offset = {
		tbl_6[1] + 2,
		tbl_6[2] - 2,
		tbl_6[3] - 1
	}
	tbl_9[str_5] = tbl_10
	tbl_9[str_6] = clone

	local str_7 = "icon_texture"

	tbl_7[#tbl_7 + 1] = {
		pass_type = "texture",
		style_id = str_7,
		texture_id = str_7,
		content_check_function = function (self, arg_13_1)
			-- function 13
			return self[str_7]
		end,
		content_change_function = function (self, arg_14_1)
			-- function 14
			if not self.locked then
				arg_14_1.saturated = true
			else
				arg_14_1.saturated = false
			end
		end
	}
	tbl_8[str_7] = str

	local tbl_11 = {
		-(arg_10_1[1] / 2) + 108,
		0,
		5
	}

	tbl_9[str_7] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = tbl,
		color = {
			255,
			255,
			255,
			255
		},
		offset = tbl_11
	}
	tbl_8.icon_locked_z_offset = 1
	tbl_8.icon_unlocked_z_offset = 5

	local str_8 = "icon_background"

	tbl_7[#tbl_7 + 1] = {
		pass_type = "texture",
		texture_id = str_8,
		style_id = str_8
	}
	tbl_8[str_8] = "level_icon_09"
	tbl_9[str_8] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = tbl,
		color = UISettings.console_start_game_menu_rect_color,
		offset = {
			tbl_11[1],
			tbl_11[2],
			tbl_11[3] - 6
		}
	}

	local str_9 = "icon_frame_texture"

	tbl_7[#tbl_7 + 1] = {
		pass_type = "texture",
		style_id = str_9,
		texture_id = str_9,
		content_check_function = function (self, arg_15_1)
			-- function 15
			return self[str_7]
		end,
		content_change_function = function (self, arg_16_1)
			-- function 16
			if not self.locked then
				arg_16_1.saturated = true
			else
				arg_16_1.saturated = false
			end
		end
	}
	tbl_8[str_9] = "map_frame_00"
	tbl_9[str_9] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = tbl_2,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_11[1],
			tbl_11[2],
			tbl_11[3] - 1
		}
	}

	local str_10 = "icon_texture_glow"

	tbl_7[#tbl_7 + 1] = {
		pass_type = "texture",
		style_id = str_10,
		texture_id = str_10,
		content_check_function = function (self)
			-- function 17
			return self.is_selected
		end
	}
	tbl_8[str_10] = "map_frame_glow_02"
	tbl_9[str_10] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = tbl_3,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_11[1],
			tbl_11[2],
			tbl_11[3] - 5
		}
	}
	tbl_7[#tbl_7 + 1] = {
		pass_type = "texture",
		style_id = "lock",
		texture_id = "lock",
		content_check_function = function (self)
			-- function 18
			return self.locked
		end
	}
	tbl_7[#tbl_7 + 1] = {
		pass_type = "texture",
		style_id = "lock_fade",
		texture_id = "lock_fade",
		content_check_function = function (self)
			-- function 19
			return self.locked
		end
	}
	tbl_8.lock = "map_frame_lock"
	tbl_8.lock_fade = "map_frame_fade"
	tbl_9.lock = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = tbl_2,
		offset = {
			tbl_11[1],
			tbl_11[2],
			tbl_11[3] + 3
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_9.lock_fade = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = tbl_2,
		offset = {
			tbl_11[1],
			tbl_11[2],
			tbl_11[3] - 2
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	return {
		element = {
			passes = tbl_7
		},
		content = tbl_8,
		style = tbl_9,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_10_0
	}
end

local function fn_2(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	-- function 20
	local tbl = {
		2,
		-2,
		3
	}

	if not arg_20_3 then
		tbl[1] = tbl[1] + arg_20_3[1]
		tbl[2] = tbl[2] + arg_20_3[2]
		tbl[3] = arg_20_3[3] - 1
	end

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_field"
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 21
						local is_hover

						if not self.button_hotspot.disable_button then
							is_hover = self.button_hotspot.is_hover

							if not is_hover then
								is_hover = self.button_hotspot.is_selected
							end
						else
							is_hover = false
						end

						if false then
							is_hover = true
						end

						return is_hover
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 22
						return not not self.button_hotspot.disable_button or not not self.button_hotspot.is_hover or not self.button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 23
						return self.button_hotspot.disable_button
					end
				}
			}
		},
		content = {
			button_hotspot = {},
			text_field = arg_20_1,
			default_font_size = arg_20_2
		},
		style = {
			text = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_20_2,
				horizontal_alignment = arg_20_4 or "left",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = arg_20_3 or {
					0,
					0,
					4
				}
			},
			text_shadow = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_20_2,
				horizontal_alignment = arg_20_4 or "left",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = tbl
			},
			text_hover = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_20_2,
				horizontal_alignment = arg_20_4 or "left",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = arg_20_3 or {
					0,
					0,
					4
				}
			},
			text_disabled = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_20_2,
				horizontal_alignment = arg_20_4 or "left",
				text_color = Colors.get_color_table_with_alpha("gray", 50),
				offset = arg_20_3 or {
					0,
					0,
					4
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_20_0
	}
end

local function fn_3(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {}
	local num = 52
	local num_2 = 16
	local num_3 = num + num_2 * 1.5
	local num_4 = (arg_24_2 - 1 - (arg_24_3 - 0.5) * 0.5) * num_3
	local flag = arg_24_2 ~= arg_24_3

	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		style_id = "icon",
		texture_id = "icon"
	}
	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		style_id = "frame",
		texture_id = "frame"
	}
	tbl_3[#tbl_3 + 1] = {
		style_id = "hotspot",
		pass_type = "hotspot",
		content_id = "hotspot"
	}
	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		style_id = "reward_hover",
		texture_id = "reward_hover",
		content_check_function = function (self)
			-- function 25
			local is_hover = self.hotspot.is_hover

			if not is_hover then
				is_hover = self.item
				is_hover = not is_hover and self.tooltip
			end

			return is_hover
		end
	}
	tbl_3[#tbl_3 + 1] = {
		item_id = "item",
		style_id = "tooltip",
		pass_type = "item_tooltip",
		text_id = "tooltip",
		content_check_function = function (self)
			-- function 26
			local is_hover = self.hotspot.is_hover

			if not is_hover then
				is_hover = self.item
				is_hover = not is_hover and self.tooltip
			end

			return is_hover
		end
	}

	if not flag then
		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			style_id = "separator",
			texture_id = "separator"
		}
	end

	local var_24_10 = ItemMasterList[arg_24_1]

	tbl_4.tooltip = "tooltip_text"
	tbl_4.item_tooltip = {}
	tbl_4.hotspot = {}
	tbl_4.frame = "button_frame_01"

	local inventory_icon = var_24_10.inventory_icon

	inventory_icon = inventory_icon or "icons_placeholder"
	tbl_4.icon = inventory_icon
	tbl_4.visible = false
	tbl_4.difficulty_key = arg_24_0
	tbl_4.item = {
		data = var_24_10
	}
	tbl_4.force_equipped = nil
	tbl_4.reward_hover = "item_icon_hover"

	if not flag then
		tbl_4.separator = "menu_frame_12_divider_middle"
	end

	tbl_5.icon = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		color = {
			255,
			255,
			255,
			255
		},
		texture_size = {
			num,
			num
		},
		offset = {
			0,
			0,
			0
		}
	}
	tbl_5.frame = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		color = {
			255,
			255,
			255,
			255
		},
		texture_size = {
			num,
			num
		},
		offset = {
			0,
			0,
			1
		}
	}
	tbl_5.tooltip = {
		font_size = 18,
		font_type = "hell_shark",
		localize = true,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		max_width = 1500,
		size = {
			400,
			0
		},
		text_color = Colors.get_color_table_with_alpha("white", 255),
		line_colors = {
			Colors.get_color_table_with_alpha("font_title", 255),
			Colors.get_color_table_with_alpha("white", 255)
		}
	}
	tbl_5.hotspot = {
		size = {
			num,
			num
		},
		offset = {
			0,
			-12,
			0
		}
	}
	tbl_5.reward_hover = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			num * 1.6,
			num * 1.6
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			-15,
			15,
			1
		}
	}

	if not flag then
		tbl_5.separator = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = {
				255,
				255,
				255,
				255
			},
			texture_size = {
				num_2,
				num_2
			},
			offset = {
				num * 0.5 + num_3 * 0.5 - num_2 * 0.5,
				-num * 0.5 + num_2 * 0.5,
				1
			}
		}
	end

	tbl_2.passes = tbl_3
	tbl.element = tbl_2
	tbl.content = tbl_4
	tbl.style = tbl_5
	tbl.scenegraph_id = "difficulty_rewards_anchor"
	tbl.offset = {
		num_4,
		0,
		2
	}

	return tbl
end

local tbl_14 = {}
local num_3 = 10

for i = 1, num_3 do
	tbl_14[i] = fn_2("title_button_start", "n/a", 32, nil, "center")
end

local tbl_15 = {
	background = UIWidgets.create_rect_with_outer_frame("background", tbl_3.background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	difficulty_texture = UIWidgets.create_simple_texture("difficulty_option_1", "difficulty_texture"),
	difficulty_title = UIWidgets.create_simple_text(Localize("start_game_window_difficulty"), "difficulty_title", nil, nil, tbl_5),
	difficulty_title_divider = UIWidgets.create_simple_texture("divider_01_top", "difficulty_title_divider"),
	description_text = UIWidgets.create_simple_text(Localize("start_game_window_adventure_desc"), "description_text", nil, nil, tbl_7),
	difficulty_bottom_divider = UIWidgets.create_simple_texture("divider_01_bottom", "difficulty_bottom_divider"),
	rewards_title = UIWidgets.create_simple_text(Localize("deed_reward_title"), "rewards_title", nil, nil, tbl_6),
	difficulty_chest_info = UIWidgets.create_simple_text("", "difficulty_chest_info", nil, nil, tbl_8),
	xp_multiplier = UIWidgets.create_simple_text("", "difficulty_xp_multiplier", nil, nil, tbl_9),
	difficulty_lock_text = UIWidgets.create_simple_text("difficulty_lock_text", "difficulty_is_locked_text", nil, nil, tbl_10),
	difficulty_is_locked_text = UIWidgets.create_simple_text("Some people in your party do not meet the required Hero Power.", "difficulty_is_locked_text", nil, nil, tbl_12),
	difficulty_second_lock_text = UIWidgets.create_simple_text("KIll all the lords on Legend Difficulty", "requirement_bg", nil, nil, tbl_11),
	dlc_lock_text = UIWidgets.create_simple_text(Localize("cataclysm_no_wom"), "buy_button", nil, nil, tbl_13),
	buy_button = create_buy_button("buy_button", tbl_3.buy_button.size, nil, "wom_button", Localize("menu_weave_area_no_wom_button"), 32, nil, nil, nil, false)
}

return {
	widgets = tbl_15,
	title_button_definitions = tbl_14,
	create_difficulty_button = fn,
	scenegraph_definition = tbl_3,
	animation_definitions = tbl_2,
	create_difficulty_reward_widget = fn_3
}
