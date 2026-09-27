-- chunkname: @scripts/ui/views/level_end/states/definitions/end_view_state_weave_definitions.lua

local num = 22
local flag

flag = IS_WINDOWS or not 50 or 0

local num_2 = 1600
local num_3 = num_2 - 50
local tbl = {
	1920,
	230 + flag
}
local tbl_2 = {
	250,
	160
}
local num_4 = 30
local tbl_3 = {
	100,
	138,
	0,
	147
}
local tbl_4 = {
	150,
	138,
	0,
	187
}
local tbl_5 = {
	100,
	128,
	0,
	217
}
local tbl_6 = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.end_screen
		}
	},
	content_bg = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = tbl,
		position = {
			0,
			0,
			UILayer.end_screen + 30
		}
	},
	content_top_fade = {
		vertical_alignment = "top",
		parent = "content_bg",
		size = {
			1920,
			200
		},
		position = {
			0,
			200,
			-4
		}
	},
	content_top_glow_1 = {
		vertical_alignment = "top",
		parent = "content_bg",
		size = {
			1920,
			350
		},
		position = {
			0,
			350,
			-3
		}
	},
	content_top_glow_2 = {
		vertical_alignment = "top",
		parent = "content_bg",
		size = {
			1920,
			300
		},
		position = {
			0,
			300,
			-2
		}
	},
	content_top_glow_3 = {
		vertical_alignment = "top",
		parent = "content_bg",
		size = {
			1920,
			250
		},
		position = {
			0,
			250,
			-1
		}
	},
	content = {
		vertical_alignment = "center",
		parent = "content_bg",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			0,
			0,
			1
		}
	},
	content_corner_top_left = {
		vertical_alignment = "top",
		parent = "content_bg",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			2
		}
	},
	content_corner_top_right = {
		vertical_alignment = "top",
		parent = "content_bg",
		horizontal_alignment = "right",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			2
		}
	},
	content_corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "content_bg",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			2
		}
	},
	content_corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "content_bg",
		horizontal_alignment = "right",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			2
		}
	},
	ready_timer_bar = {
		vertical_alignment = "bottom",
		parent = "content",
		horizontal_alignment = "left",
		size = {
			1300,
			15
		},
		position = {
			150,
			35 + flag,
			15
		}
	},
	ready_button = {
		vertical_alignment = "bottom",
		parent = "content",
		horizontal_alignment = "right",
		size = {
			300,
			40
		},
		position = {
			-150,
			20 + flag,
			15
		}
	},
	ready_button_panel = {
		vertical_alignment = "bottom",
		parent = "ready_button",
		horizontal_alignment = "center",
		size = {
			260,
			103
		},
		position = {
			0,
			20,
			-1
		}
	},
	total_time_container = {
		vertical_alignment = "bottom",
		parent = "ready_timer_bar",
		horizontal_alignment = "left",
		size = tbl_2,
		position = {
			0,
			30,
			1
		}
	},
	time_score_container = {
		vertical_alignment = "top",
		parent = "total_time_container",
		horizontal_alignment = "left",
		size = tbl_2,
		position = {
			tbl_2[1] + num_4,
			0,
			1
		}
	},
	damage_bonus_container = {
		vertical_alignment = "top",
		parent = "time_score_container",
		horizontal_alignment = "left",
		size = tbl_2,
		position = {
			tbl_2[1] + num_4,
			0,
			1
		}
	},
	total_score_container = {
		vertical_alignment = "top",
		parent = "damage_bonus_container",
		horizontal_alignment = "left",
		size = {
			460,
			tbl_2[2]
		},
		position = {
			tbl_2[1] + num_4,
			0,
			1
		}
	},
	score_weave_num = {
		vertical_alignment = "top",
		parent = "content",
		horizontal_alignment = "center",
		size = {
			500,
			50
		},
		position = {
			0,
			73,
			3
		}
	},
	title_bg = {
		vertical_alignment = "top",
		parent = "content",
		horizontal_alignment = "center",
		size = {
			0,
			73
		},
		position = {
			0,
			93,
			-1
		}
	},
	title_bg_left = {
		vertical_alignment = "top",
		parent = "title_bg",
		horizontal_alignment = "left",
		size = {
			634,
			73
		},
		position = {
			-634,
			0,
			0
		}
	},
	title_bg_right = {
		vertical_alignment = "top",
		parent = "title_bg",
		horizontal_alignment = "right",
		size = {
			634,
			73
		},
		position = {
			634,
			0,
			0
		}
	},
	score_glow_1 = {
		vertical_alignment = "center",
		parent = "total_time_container",
		horizontal_alignment = "center",
		size = {
			300,
			120
		},
		position = {
			0,
			0,
			1
		}
	},
	score_glow_2 = {
		vertical_alignment = "center",
		parent = "time_score_container",
		horizontal_alignment = "center",
		size = {
			300,
			120
		},
		position = {
			0,
			0,
			1
		}
	},
	score_glow_3 = {
		vertical_alignment = "center",
		parent = "damage_bonus_container",
		horizontal_alignment = "center",
		size = {
			300,
			120
		},
		position = {
			0,
			0,
			1
		}
	},
	score_glow_4 = {
		vertical_alignment = "center",
		parent = "total_score_container",
		horizontal_alignment = "center",
		size = {
			400,
			140
		},
		position = {
			0,
			0,
			1
		}
	},
	score_divider_1 = {
		vertical_alignment = "center",
		parent = "total_time_container",
		horizontal_alignment = "center",
		size = {
			200,
			20
		},
		position = {
			0,
			0,
			2
		}
	},
	score_divider_2 = {
		vertical_alignment = "center",
		parent = "time_score_container",
		horizontal_alignment = "center",
		size = {
			200,
			20
		},
		position = {
			0,
			0,
			2
		}
	},
	score_divider_3 = {
		vertical_alignment = "center",
		parent = "damage_bonus_container",
		horizontal_alignment = "center",
		size = {
			200,
			20
		},
		position = {
			0,
			0,
			2
		}
	},
	score_divider_4 = {
		vertical_alignment = "center",
		parent = "total_score_container",
		horizontal_alignment = "left",
		size = {
			230,
			59
		},
		position = {
			0,
			-12,
			2
		}
	},
	score_divider_5 = {
		vertical_alignment = "center",
		parent = "total_score_container",
		horizontal_alignment = "right",
		size = {
			230,
			59
		},
		position = {
			0,
			-12,
			2
		}
	},
	highscore_sigil = {
		vertical_alignment = "center",
		parent = "score_divider_4",
		horizontal_alignment = "left",
		size = {
			53,
			53
		},
		position = {
			60,
			15,
			2
		}
	},
	highscore_ribbon = {
		vertical_alignment = "top",
		parent = "highscore_sigil",
		horizontal_alignment = "center",
		size = {
			34,
			50
		},
		position = {
			0,
			-30,
			-1
		}
	},
	highscore_text = {
		vertical_alignment = "center",
		parent = "total_score_container",
		horizontal_alignment = "center",
		size = {
			460,
			50
		},
		position = {
			0,
			-70,
			1
		}
	},
	player_frame = {
		vertical_alignment = "top",
		parent = "content_bg",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			190 + flag * 0.5,
			10
		}
	},
	player_insignia = {
		vertical_alignment = "top",
		parent = "content_bg",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-90,
			190 + flag * 0.5,
			12
		}
	},
	profile_selector = {
		vertical_alignment = "bottom",
		parent = "player_frame",
		horizontal_alignment = "center",
		size = {
			78,
			28
		},
		position = {
			0,
			-120,
			10
		}
	}
}
local tbl_7 = {
	font_size = 36,
	upper_case = false,
	localize = false,
	dynamic_font_size_word_wrap = true,
	word_wrap = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_8 = {
	font_size = 28,
	upper_case = false,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		30,
		2
	}
}
local tbl_9 = {
	font_size = 28,
	upper_case = false,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		-30,
		2
	}
}
local tbl_10 = {
	font_size = 28,
	upper_case = false,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		30,
		2
	}
}
local tbl_11 = {
	font_size = 42,
	upper_case = false,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		-30,
		2
	}
}
local tbl_12 = {
	font_size = 32,
	upper_case = false,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = {
		255,
		253,
		204,
		10
	},
	offset = {
		0,
		0,
		2
	}
}
local tbl_13 = {
	use_shadow = false,
	font_size = 22,
	localize = false,
	vertical_alignment = "bottom",
	word_wrap = false,
	horizontal_alignment = "center",
	font_type = "hell_shark",
	offset = {
		-2,
		-94,
		11
	}
}

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	local create_default_button = UIWidgets.create_default_button(arg_1_0, arg_1_1, nil, nil, arg_1_2, 24, arg_1_3, arg_1_4, nil, arg_1_5)

	create_default_button.content.hover_glow = "button_state_hover_green"
	create_default_button.content.effect = "play_button_passive_glow"
	create_default_button.content.glow = "button_state_normal_green"

	return create_default_button
end

function create_leaderboard_button(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	arg_2_3 = arg_2_3 or "button_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_2_3)
	local var_2_1

	if not arg_2_2 then
		var_2_1 = UIFrameSettings[arg_2_2]

		if not var_2_1 then
			-- Nothing
		end
	end

	var_2_1 = UIFrameSettings.button_frame_01

	::label_2_0::

	local var_2_2 = var_2_1.texture_sizes.corner[1]

	arg_2_4 = arg_2_4 or "loot_chest_icon"

	local get_atlas_settings_by_texture_name_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_2_4)
	local size

	if not get_atlas_settings_by_texture_name_2 then
		size = get_atlas_settings_by_texture_name_2.size

		if not size then
			-- Nothing
		end
	end

	size = {
		50,
		50
	}

	::label_2_1::

	local num = 0
	local min = math.min((arg_2_1[1] - num) / size[1], (arg_2_1[2] - num) / size[2])
	local min_2 = math.min(min, 1)
	local tbl = {
		size[1] * min_2,
		size[2] * min_2
	}

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					pass_type = "rect",
					style_id = "clicked_rect"
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 3
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "background_icon",
					pass_type = "texture_uv",
					content_id = "background_icon"
				}
			}
		},
		content = {
			background_fade = "button_bg_fade",
			hover_glow = "button_state_default",
			button_hotspot = {},
			frame = var_2_1.texture,
			background_icon = {
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				},
				texture_id = arg_2_4
			},
			background = {
				uvs = {
					{
						0,
						1 - arg_2_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_2_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = arg_2_3
			}
		},
		style = {
			background = {
				color = {
					255,
					150,
					150,
					150
				},
				offset = {
					0,
					0,
					0
				}
			},
			background_icon = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_2_1[1] / 2 - tbl[1] / 2,
					arg_2_1[2] / 2 - tbl[2] / 2,
					1
				},
				size = tbl
			},
			hover_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					4
				},
				size = {
					arg_2_1[1],
					math.min(arg_2_1[2] - 5, 80)
				}
			},
			clicked_rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					8
				}
			},
			disabled_rect = {
				color = {
					150,
					20,
					20,
					20
				},
				offset = {
					0,
					0,
					2
				}
			}
		},
		scenegraph_id = arg_2_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_2(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local button_frame_02 = UIFrameSettings.button_frame_02

	return {
		content = {
			background = "xp_bar_bg",
			bar_edge = "end_glow_greyscale",
			draw_frame = true,
			bar_fill = {
				texture_id = "timer_fg_greyscale",
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
			},
			frame = button_frame_02.texture
		},
		element = {
			passes = {
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					style_id = "bar_edge",
					pass_type = "texture",
					texture_id = "bar_edge",
					content_change_function = function (arg_5_0, arg_5_1)
						-- function 5
						local bar_fill = arg_5_1.parent.bar_fill
						local var_5_1 = bar_fill.offset[1]

						arg_5_1.offset[1] = math.floor(bar_fill.size[1] + var_5_1 - arg_5_1.default_size[1] / 2)
					end,
					content_check_function = function (self)
						-- function 6
						return self.active
					end
				},
				{
					style_id = "bar_fill",
					pass_type = "texture_uv",
					content_id = "bar_fill",
					content_check_function = function (self)
						-- function 7
						return self.parent.active
					end
				}
			}
		},
		style = {
			background = {
				color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_4_1[1] - button_frame_02.texture_sizes.horizontal[2] * 2,
					arg_4_1[2] - button_frame_02.texture_sizes.vertical[1] * 2
				},
				offset = {
					button_frame_02.texture_sizes.horizontal[2],
					button_frame_02.texture_sizes.vertical[1],
					0
				}
			},
			bar_fill = {
				color = {
					255,
					100,
					150,
					150
				},
				size = {
					arg_4_1[1] - button_frame_02.texture_sizes.horizontal[2] * 2,
					arg_4_1[2] - button_frame_02.texture_sizes.vertical[1]
				},
				default_size = {
					arg_4_1[1] - button_frame_02.texture_sizes.horizontal[2],
					arg_4_1[2] - button_frame_02.texture_sizes.vertical[1]
				},
				offset = {
					button_frame_02.texture_sizes.horizontal[2],
					button_frame_02.texture_sizes.vertical[1] / 2,
					2
				}
			},
			bar_edge = {
				color = {
					255,
					100,
					255,
					255
				},
				size = {
					40,
					60
				},
				default_size = {
					40,
					60
				},
				offset = {
					button_frame_02.texture_sizes.horizontal[2] - 20,
					button_frame_02.texture_sizes.vertical[1] - 25,
					5
				}
			},
			frame = {
				texture_size = button_frame_02.texture_size,
				texture_sizes = button_frame_02.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					4
				}
			}
		},
		scenegraph_id = arg_4_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_3(self, arg_8_1, arg_8_2)
	-- function 8
	local content = self.content
	local style = self.style
	local bar_fill = style.bar_fill
	local size = bar_fill.size
	local default_size = bar_fill.default_size

	size[1] = math.floor(default_size[1] * arg_8_1)

	local num = 0.5
	local num_2 = 150
	local num_3 = 255
	local ease_pulse = math.ease_pulse(arg_8_2 * num % 1)

	style.bar_edge.color[1] = num_2 + (num_3 - num_2) * ease_pulse
end

function create_simple_gamepad_disabled_texture(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					retained_mode = arg_9_2
				},
				{
					style_id = "glow",
					pass_type = "texture",
					texture_id = "glow_id",
					retained_mode = arg_9_2,
					content_change_function = function (arg_10_0, arg_10_1)
						-- function 10
						arg_10_1.color[1] = 40 + 20 * math.sin(Managers.time:time("ui") * 5)
					end
				}
			}
		},
		content = {
			glow_id = "winds_icon_background_glow",
			texture_id = "keep_decorations_divider_02",
			gamepad_disabled = arg_9_5
		},
		style = {
			texture_id = {
				color = arg_9_3 or {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				},
				masked = arg_9_1
			},
			glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					400,
					50
				},
				color = {
					40,
					255,
					255,
					0
				},
				offset = {
					0,
					30,
					0
				},
				masked = arg_9_1
			}
		},
		offset = {
			0,
			0,
			arg_9_4 or 0
		},
		scenegraph_id = arg_9_0
	}
end

local tbl_14 = {
	90,
	90,
	70,
	55
}
local tbl_15 = {
	255,
	30,
	30,
	30
}
local flag_2 = true
local tbl_16 = {
	content_bg = UIWidgets.create_tiled_texture("content_bg", "menu_frame_bg_06", {
		256,
		256
	}, nil, nil, {
		255,
		150,
		150,
		150
	}),
	content_border = UIWidgets.create_frame("content_bg", {
		30,
		30
	}, "menu_frame_11", 4, nil, {
		-num,
		-num
	}),
	content_border_fade = UIWidgets.create_simple_texture("edge_fade_small", "content_top_fade", nil, nil, {
		220,
		0,
		0,
		0
	}),
	content_top_glow_1 = UIWidgets.create_simple_uv_texture("end_screen_weave_smoke_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "content_top_glow_1", nil, nil, tbl_3),
	content_top_glow_2 = UIWidgets.create_simple_uv_texture("end_screen_weave_smoke_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "content_top_glow_2", nil, nil, tbl_4),
	content_top_glow_3 = UIWidgets.create_simple_uv_texture("end_screen_weave_embers_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "content_top_glow_3", nil, nil, tbl_5),
	content_background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "content_bg", nil, nil, {
		150,
		0,
		0,
		0
	}, 1),
	content_corner_top_left = UIWidgets.create_simple_texture("athanor_decoration_corner", "content_corner_top_left"),
	content_corner_top_right = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "content_corner_top_right"),
	content_corner_bottom_left = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "content_corner_bottom_left"),
	content_corner_bottom_right = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			1,
			1
		},
		{
			0,
			0
		}
	}, "content_corner_bottom_right"),
	score_weave_num = UIWidgets.create_simple_text("", "score_weave_num", nil, nil, tbl_7),
	title_bg_left = UIWidgets.create_simple_texture("athanor_power_bg", "title_bg_left"),
	title_bg_right = UIWidgets.create_simple_uv_texture("athanor_power_bg", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "title_bg_right"),
	score_divider_1 = UIWidgets.create_simple_texture("journal_content_divider_medium", "score_divider_1", nil, nil, tbl_15),
	score_divider_2 = UIWidgets.create_simple_texture("journal_content_divider_medium", "score_divider_2", nil, nil, tbl_15),
	score_divider_3 = UIWidgets.create_simple_texture("journal_content_divider_medium", "score_divider_3", nil, nil, tbl_15),
	score_divider_4 = UIWidgets.create_simple_texture("frame_detail_03", "score_divider_4"),
	score_divider_5 = UIWidgets.create_simple_uv_texture("frame_detail_03", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "score_divider_5"),
	score_glow_1 = UIWidgets.create_simple_texture("winds_icon_background_glow", "score_glow_1", nil, nil, tbl_14),
	score_glow_2 = UIWidgets.create_simple_texture("winds_icon_background_glow", "score_glow_2", nil, nil, tbl_14),
	score_glow_3 = UIWidgets.create_simple_texture("winds_icon_background_glow", "score_glow_3", nil, nil, tbl_14),
	score_glow_4 = UIWidgets.create_simple_texture("winds_icon_background_glow", "score_glow_4", nil, nil, tbl_14),
	total_time_text = UIWidgets.create_simple_text("weave_endscreen_total_time", "total_time_container", nil, nil, tbl_8),
	total_time_value = UIWidgets.create_simple_text("", "total_time_container", nil, nil, tbl_9),
	time_score_text = UIWidgets.create_simple_text("weave_endscreen_time_score", "time_score_container", nil, nil, tbl_8),
	time_score_value = UIWidgets.create_simple_text("", "time_score_container", nil, nil, tbl_9),
	damage_bonus_text = UIWidgets.create_simple_text("weave_endscreen_damage_score", "damage_bonus_container", nil, nil, tbl_8),
	damage_bonus_value = UIWidgets.create_simple_text("", "damage_bonus_container", nil, nil, tbl_9),
	total_score_text = UIWidgets.create_simple_text("weave_endscreen_total_score", "total_score_container", nil, nil, tbl_10),
	total_score_value = UIWidgets.create_simple_text("", "total_score_container", nil, nil, tbl_11),
	ready_button_panel = UIWidgets.create_simple_texture("esc_menu_top", "ready_button_panel"),
	ready_button = fn("ready_button", tbl_6.ready_button.size, Localize("continue"), 24, "button_detail_03", flag_2),
	ready_timer = fn_2("ready_timer_bar", tbl_6.ready_timer_bar.size),
	profile_selector = create_simple_gamepad_disabled_texture("profile_selector", nil, nil, nil, nil, gamepad_disabled),
	highscore_sigil = UIWidgets.create_simple_texture("weave_highscore_sigil", "highscore_sigil"),
	highscore_ribbon = UIWidgets.create_simple_texture("weave_highscore_ribbon", "highscore_ribbon"),
	highscore_text = UIWidgets.create_simple_text("weave_endscreen_new_record", "highscore_text", nil, nil, tbl_12)
}
local tbl_17 = {
	player_frame = UIWidgets.create_portrait_frame("player_frame", "default", nil, 1, nil, "unit_frame_portrait_default"),
	player_insignia = UIWidgets.create_small_insignia("player_insignia", 0),
	player_name = UIWidgets.create_simple_text("", "player_frame", nil, nil, tbl_13)
}
local tbl_18 = {
	transition_enter = {
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

				local content_bg = arg_12_1.content_bg
				local num = content_bg.size[2] * (1 - easeOutCubic)
				local var_12_3 = content_bg.position[2]

				arg_12_0.content_bg.position[2] = var_12_3 - num
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end
		}
	},
	transition_exit = {
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
				local easeInCubic = math.easeInCubic(arg_15_3)

				arg_15_4.render_settings.alpha_multiplier = 1 - easeInCubic

				local content_bg = arg_15_1.content_bg
				local num = content_bg.size[2] * easeInCubic
				local var_15_3 = content_bg.position[2]

				arg_15_0.content_bg.position[2] = var_15_3 - num
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				return
			end
		}
	},
	score_entry = {
		{
			name = "count_up",
			start_progress = 0.5,
			end_progress = 1.4,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				arg_17_3.widget.content.text = UIUtils.comma_value(arg_17_3.start_value)
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				-- function 18
				local content = arg_18_4.widget.content
				local floor = math.floor(math.lerp(arg_18_4.start_value, arg_18_4.end_value, arg_18_3))

				content.text = UIUtils.comma_value(floor)

				if not arg_18_4.wwise_world then
					WwiseWorld.trigger_event(arg_18_4.wwise_world, "play_gui_mission_summary_entry_count")
				end
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end
		},
		{
			name = "bump",
			start_progress = 1.5,
			end_progress = 1.8,
			init = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				arg_20_3.widget.content.entered = false
			end,
			update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				-- function 21
				local widget = arg_21_4.widget
				local content = widget.content
				local style = widget.style
				local text = style.text
				local text_shadow = style.text_shadow
				local start_font_size = arg_21_4.start_font_size
				local peak_font_size = arg_21_4.peak_font_size
				local ease_pulse = math.ease_pulse(arg_21_3)
				local lerp = math.lerp(start_font_size, peak_font_size, ease_pulse)

				text.font_size = lerp
				text_shadow.font_size = lerp

				if not (not arg_21_4.wwise_world and content.entered ~= false) then
					WwiseWorld.trigger_event(arg_21_4.wwise_world, "play_gui_mission_summary_entry_total_sum")

					content.entered = true
				end
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				return
			end
		}
	},
	highscore_presentation = {
		{
			name = "sigil_alpha",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				-- function 23
				local highscore_sigil = arg_23_2.highscore_sigil
				local highscore_ribbon = arg_23_2.highscore_ribbon
				local num = 0

				highscore_sigil.style.texture_id.color[1] = num
				highscore_ribbon.style.texture_id.color[1] = num
				arg_23_2.highscore_sigil.content.visible = true
				arg_23_2.highscore_ribbon.content.visible = true
				arg_23_2.highscore_text.content.visible = true
			end,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				-- function 24
				local ease_in_exp = math.ease_in_exp(arg_24_3)
				local highscore_sigil = arg_24_2.highscore_sigil
				local highscore_ribbon = arg_24_2.highscore_ribbon
				local num = 255 * ease_in_exp

				highscore_sigil.style.texture_id.color[1] = num
				highscore_ribbon.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				return
			end
		},
		{
			name = "sigil_entry",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				return
			end,
			update = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				-- function 27
				local ease_out_exp = math.ease_out_exp(1 - arg_27_3)
				local scenegraph_id = arg_27_2.highscore_sigil.scenegraph_id
				local var_27_2 = arg_27_1[scenegraph_id]
				local var_27_3 = self[scenegraph_id]
				local position = var_27_2.position
				local local_position = var_27_3.local_position
				local size = var_27_2.size
				local size_2 = var_27_3.size

				size_2[1] = size[1] + size[1] * ease_out_exp
				size_2[2] = size[2] + size[2] * ease_out_exp
				local_position[1] = position[1] - position[1] / 2 * ease_out_exp
				local_position[2] = position[2] + position[2] / 2 * ease_out_exp

				local scenegraph_id_2 = arg_27_2.highscore_ribbon.scenegraph_id
				local var_27_9 = arg_27_1[scenegraph_id_2]
				local var_27_10 = self[scenegraph_id_2]
				local position_2 = var_27_9.position
				local local_position_2 = var_27_10.local_position
				local size_3 = var_27_9.size
				local size_4 = var_27_10.size

				size_4[1] = size_3[1] + size_3[1] * ease_out_exp
				size_4[2] = size_3[2] + size_3[2] * ease_out_exp
				local_position_2[1] = position_2[1] + position_2[1] * ease_out_exp
				local_position_2[2] = position_2[2] + position_2[2] * ease_out_exp

				if arg_27_3 ~= 1 or not arg_27_4.wwise_world then
					WwiseWorld.trigger_event(arg_27_4.wwise_world, "menu_wind_level_choose_wind")
				end
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				return
			end
		},
		{
			name = "text_entry",
			start_progress = 0.7,
			end_progress = 1.1,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				local highscore_text = arg_29_2.highscore_text
				local content = highscore_text.content
				local style = highscore_text.style
				local text = style.text
				local text_shadow = style.text_shadow
				local offset = highscore_text.offset

				text.text_color[1] = 0
				text_shadow.text_color[1] = 0
				offset[1] = 0
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				-- function 30
				local highscore_text = arg_30_2.highscore_text
				local content = highscore_text.content
				local style = highscore_text.style
				local text = style.text
				local text_shadow = style.text_shadow
				local offset = highscore_text.offset
				local easeOutCubic = math.easeOutCubic(arg_30_3)

				text.text_color[1] = 255 * easeOutCubic
				text_shadow.text_color[1] = 255 * easeOutCubic
				offset[1] = 10 * easeOutCubic
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				return
			end
		},
		{
			name = "background_glow_entry",
			start_progress = 0.7,
			end_progress = 2.5,
			init = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				-- function 32
				local score_glow_4 = arg_32_2.score_glow_4
				local content = score_glow_4.content
				local color = score_glow_4.style.texture_id.color

				color[1] = 90
				color[2] = 90
				color[3] = 70
				color[4] = 55
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				-- function 33
				local score_glow_4 = arg_33_2.score_glow_4
				local content = score_glow_4.content
				local color = score_glow_4.style.texture_id.color
				local easeOutCubic = math.easeOutCubic(arg_33_3)
				local tbl = {
					90,
					90,
					70,
					55
				}
				local tbl_2 = {
					60,
					223,
					204,
					50
				}

				Colors.lerp_color_tables(tbl, tbl_2, easeOutCubic, color)
			end,
			on_complete = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				return
			end
		}
	}
}
local tbl_19 = {
	default = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 3,
			description_text = "continue_menu_button_name"
		}
	},
	show_profile = {
		actions = {
			{
				input_action = "special_1",
				priority = 2,
				description_text = "input_description_show_profile"
			}
		}
	}
}

return {
	widgets = tbl_16,
	hero_widgets = tbl_17,
	score_widgets = score_widgets,
	scenegraph_definition = tbl_6,
	animation_definitions = tbl_18,
	update_bar_progress = fn_3,
	generic_input_actions = tbl_19
}
