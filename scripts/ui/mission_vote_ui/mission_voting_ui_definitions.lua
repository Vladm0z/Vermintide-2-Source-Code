-- chunkname: @scripts/ui/mission_vote_ui/mission_voting_ui_definitions.lua

local var_0_0 = not IS_PS4 and UISettings.game_start_windows or UISettings.game_start_windows_console
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = var_0_0.spacing
local var_0_4 = {
	var_0_2[1] + var_0_3 * 2,
	var_0_2[2] + 60
}
local var_0_5 = {
	var_0_2[1] - 20,
	233
}
local var_0_6 = "menu_frame_08"
local var_0_7 = UIFrameSettings[var_0_6].texture_sizes.corner[1]
local var_0_8 = {
	var_0_5[1],
	449
}
local var_0_9 = {
	var_0_8[1] - 10,
	0
}
local var_0_10 = var_0_0.large_window_frame
local var_0_11 = UIFrameSettings[var_0_10].texture_sizes.vertical[1]
local var_0_12 = {
	var_0_4[1] * 3 + var_0_3 * 2 + var_0_11 * 2,
	var_0_4[2] + var_0_11 * 2
}
local var_0_13 = {
	400,
	var_0_12[2]
}
local var_0_14 = {
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
	console_cursor = {
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
			-10
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
			UILayer.default
		}
	},
	screen = {
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
	window = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = var_0_4,
		position = {
			0,
			0,
			1
		}
	},
	deus_window = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			var_0_4[1] + 30,
			var_0_4[2] + 30
		},
		position = {
			0,
			0,
			1
		}
	},
	twitch_mode_info = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			400,
			200
		},
		position = {
			0,
			-215,
			1
		}
	},
	window_fade = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_4,
		position = {
			0,
			0,
			1
		}
	},
	inner_window = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_2,
		position = {
			0,
			0,
			2
		}
	},
	timer_bg = {
		vertical_alignment = "top",
		parent = "button_confirm",
		horizontal_alignment = "center",
		size = {
			500,
			16
		},
		position = {
			0,
			not IS_PS4 and 25 or 15,
			3
		}
	},
	timer_fg = {
		vertical_alignment = "center",
		parent = "timer_bg",
		horizontal_alignment = "left",
		size = {
			490,
			16
		},
		position = {
			5,
			0,
			3
		}
	},
	timer_glow = {
		vertical_alignment = "center",
		parent = "timer_fg",
		horizontal_alignment = "right",
		size = {
			45,
			80
		},
		position = {
			22,
			0,
			3
		}
	},
	deus_button_confirm = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_5[1] - 60,
			not IS_PS4 and 72 or 0
		},
		position = {
			0,
			38,
			20
		}
	},
	button_confirm = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			not IS_PS4 and 72 or 0
		},
		position = {
			0,
			38,
			20
		}
	},
	button_abort = {
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
			22
		}
	},
	game_options_right_chain = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			16,
			var_0_4[2]
		},
		position = {
			195,
			0,
			2
		}
	},
	game_options_left_chain = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			16,
			var_0_4[2]
		},
		position = {
			-195,
			0,
			2
		}
	},
	title = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			570,
			60
		},
		position = {
			0,
			34,
			22
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
	game_option_1 = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_5,
		position = {
			0,
			-36,
			3
		}
	},
	game_option_2 = {
		vertical_alignment = "bottom",
		parent = "game_option_1",
		horizontal_alignment = "center",
		size = var_0_5,
		position = {
			0,
			-249,
			0
		}
	},
	versus_reward_presentation = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			var_0_5[2] + 470
		},
		position = {
			0,
			-36,
			3
		}
	},
	switch_mechanism_title = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			100
		},
		position = {
			0,
			-66,
			2
		}
	},
	switch_mechanism_subtitle = {
		vertical_alignment = "bottom",
		parent = "switch_mechanism_title",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			40
		},
		position = {
			0,
			10,
			2
		}
	},
	switch_mechanism_description = {
		vertical_alignment = "bottom",
		parent = "switch_mechanism_subtitle",
		horizontal_alignment = "center",
		size = {
			var_0_5[1] - 40,
			100
		},
		position = {
			0,
			-150,
			2
		}
	},
	journey_name = {
		vertical_alignment = "top",
		parent = "game_option_1",
		horizontal_alignment = "left",
		size = {
			var_0_5[1] / 2,
			30
		},
		position = {
			15,
			-55,
			1
		}
	},
	journey_theme = {
		vertical_alignment = "center",
		parent = "game_option_1",
		horizontal_alignment = "left",
		size = {
			var_0_5[1] / 2,
			30
		},
		position = {
			15,
			10,
			1
		}
	},
	event_summary_frame = {
		vertical_alignment = "bottom",
		parent = "game_option_1",
		horizontal_alignment = "center",
		size = var_0_8,
		position = {
			0,
			-465,
			0
		}
	},
	event_summary = {
		vertical_alignment = "top",
		parent = "event_summary_frame",
		horizontal_alignment = "center",
		size = var_0_9,
		position = {
			0,
			-10,
			0
		}
	},
	additional_option = {
		vertical_alignment = "bottom",
		parent = "game_option_2",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			200
		},
		position = {
			0,
			-216,
			0
		}
	},
	private_button = {
		vertical_alignment = "bottom",
		parent = "additional_option",
		horizontal_alignment = "center",
		size = {
			var_0_5[1] - 20,
			40
		},
		position = {
			0,
			12,
			10
		}
	},
	private_button_frame = {
		vertical_alignment = "bottom",
		parent = "private_button",
		horizontal_alignment = "center",
		size = {
			var_0_5[1] - 20,
			45
		},
		position = {
			0,
			0,
			10
		}
	},
	host_button = {
		vertical_alignment = "top",
		parent = "private_button",
		horizontal_alignment = "center",
		size = {
			var_0_5[1] - 20,
			40
		},
		position = {
			0,
			45,
			10
		}
	},
	host_button_frame = {
		vertical_alignment = "bottom",
		parent = "host_button",
		horizontal_alignment = "center",
		size = {
			var_0_5[1] - 20,
			45
		},
		position = {
			0,
			0,
			10
		}
	},
	strict_matchmaking_button = {
		vertical_alignment = "top",
		parent = "host_button",
		horizontal_alignment = "center",
		size = {
			var_0_5[1] - 20,
			40
		},
		position = {
			0,
			45,
			10
		}
	},
	strict_matchmaking_button_frame = {
		vertical_alignment = "bottom",
		parent = "strict_matchmaking_button",
		horizontal_alignment = "center",
		size = {
			var_0_5[1] - 20,
			45
		},
		position = {
			0,
			0,
			10
		}
	},
	reward_presentation = {
		vertical_alignment = "bottom",
		parent = "game_option_1",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			449
		},
		position = {
			0,
			-465,
			0
		}
	},
	weave_quickplay_presentation = {
		vertical_alignment = "bottom",
		parent = "game_option_1",
		horizontal_alignment = "center",
		size = {
			246,
			252
		},
		position = {
			0,
			-465,
			0
		}
	},
	deed_option_bg = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			700
		},
		position = {
			0,
			-36,
			3
		}
	},
	item_presentation = {
		vertical_alignment = "top",
		parent = "game_option_1",
		horizontal_alignment = "center",
		size = {
			var_0_5[1] - 10,
			0
		},
		position = {
			0,
			-var_0_7,
			1
		}
	},
	mutator_icon = {
		vertical_alignment = "top",
		parent = "event_summary_frame",
		horizontal_alignment = "left",
		size = {
			40,
			40
		},
		position = {
			15,
			-50,
			5
		}
	},
	mutator_icon_frame = {
		vertical_alignment = "center",
		parent = "mutator_icon",
		horizontal_alignment = "center",
		size = {
			60,
			60
		},
		position = {
			0,
			0,
			1
		}
	},
	mutator_title_text = {
		vertical_alignment = "top",
		parent = "event_summary_frame",
		horizontal_alignment = "left",
		size = {
			var_0_13[1] * 0.6,
			50
		},
		position = {
			15,
			-5,
			1
		}
	},
	mutator_title_divider = {
		vertical_alignment = "bottom",
		parent = "mutator_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	mutator_description_text = {
		vertical_alignment = "top",
		parent = "mutator_icon",
		horizontal_alignment = "left",
		size = {
			var_0_5[1] - 100,
			100
		},
		position = {
			50,
			0,
			1
		}
	},
	objective_title = {
		vertical_alignment = "top",
		parent = "event_summary_frame",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			40
		},
		position = {
			0,
			-175,
			3
		}
	},
	objective_title_bg = {
		vertical_alignment = "center",
		parent = "objective_title",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			59
		},
		position = {
			0,
			0,
			-1
		}
	},
	objective_1 = {
		vertical_alignment = "bottom",
		parent = "objective_title",
		horizontal_alignment = "center",
		size = {
			var_0_13[1],
			30
		},
		position = {
			0,
			-35,
			3
		}
	},
	objective_2 = {
		vertical_alignment = "bottom",
		parent = "objective_1",
		horizontal_alignment = "center",
		size = {
			var_0_13[1],
			30
		},
		position = {
			0,
			-35,
			0
		}
	},
	private_checkbox = {
		vertical_alignment = "bottom",
		parent = "event_summary_frame",
		horizontal_alignment = "center",
		size = {
			var_0_5[1] - 20,
			40
		},
		position = {
			0,
			5,
			1
		}
	},
	game_option_deus_weekly_event = {
		vertical_alignment = "bottom",
		parent = "game_option_1",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			449
		},
		position = {
			0,
			-465,
			0
		}
	},
	game_option_deus_weekly = {
		vertical_alignment = "bottom",
		parent = "game_option_1",
		horizontal_alignment = "center",
		size = {
			var_0_5[1] - 50,
			439
		},
		position = {
			0,
			-465,
			0
		}
	},
	game_option_deus_weekly_anchor = {
		vertical_alignment = "center",
		parent = "game_option_deus_weekly"
	},
	scrollbar_window = {
		parent = "game_option_deus_weekly",
		position = {
			-45,
			12.5,
			0
		},
		size = {
			var_0_5[1],
			424
		}
	}
}
local var_0_15 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}

local function var_0_16(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = {}
	local var_1_1 = {}
	local var_1_2 = {}
	local var_1_3 = {}
	local var_1_4 = {}

	var_1_2[#var_1_2 + 1] = {
		style_id = "header",
		pass_type = "text",
		text_id = "header"
	}
	var_1_2[#var_1_2 + 1] = {
		pass_type = "texture",
		style_id = "plus_horizontal",
		texture_id = "masked_rect",
		content_check_function = function (arg_2_0, arg_2_1)
			return arg_1_2 and arg_1_2 == "boon"
		end
	}
	var_1_2[#var_1_2 + 1] = {
		pass_type = "texture",
		style_id = "plus_vertical",
		texture_id = "masked_rect",
		content_check_function = function (arg_3_0, arg_3_1)
			return arg_1_2 and arg_1_2 == "boon"
		end
	}
	var_1_2[#var_1_2 + 1] = {
		pass_type = "texture",
		style_id = "minus",
		texture_id = "masked_rect",
		content_check_function = function (arg_4_0, arg_4_1)
			return arg_1_2 and arg_1_2 == "curse"
		end
	}
	var_1_3.header = arg_1_0
	var_1_3.masked_rect = "rect_masked"

	local var_1_5 = 32

	var_1_4.header = {
		vertical_alignment = "top",
		upper_case = true,
		localize = true,
		horizontal_alignment = "left",
		font_type = "hell_shark_header_masked",
		font_size = var_1_5,
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			arg_1_2 and 25 or 0,
			0,
			2
		}
	}
	var_1_4.plus_horizontal = {
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
	var_1_4.plus_vertical = {
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
	var_1_4.minus = {
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
	var_1_1.passes = var_1_2
	var_1_0.element = var_1_1
	var_1_0.content = var_1_3
	var_1_0.style = var_1_4
	var_1_0.scenegraph_id = "game_option_deus_weekly_anchor"
	var_1_0.offset = {
		0,
		arg_1_1,
		2
	}

	return var_1_0
end

local function var_0_17(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = {}
	local var_5_1 = {}
	local var_5_2 = {}
	local var_5_3 = {}
	local var_5_4 = {}

	var_5_2[#var_5_2 + 1] = {
		style_id = "title",
		pass_type = "text",
		text_id = "title"
	}
	var_5_2[#var_5_2 + 1] = {
		style_id = "desc",
		pass_type = "text",
		text_id = "desc"
	}
	var_5_2[#var_5_2 + 1] = {
		pass_type = "texture",
		style_id = "icon",
		texture_id = "icon"
	}
	var_5_3.title = arg_5_1
	var_5_3.desc = arg_5_2
	var_5_3.icon = arg_5_0

	local var_5_5 = 10

	var_5_4.title = {
		word_wrap = true,
		font_size = 22,
		localize = true,
		dynamic_font_size_word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			35 + var_5_5,
			-3,
			2
		},
		area_size = {
			var_0_14.game_option_deus_weekly.size[1] - 35 - var_5_5,
			50
		}
	}
	var_5_4.desc = {
		word_wrap = true,
		horizontal_alignment = "left",
		localize = false,
		font_size = 22,
		vertical_alignment = "top",
		font_type = "hell_shark_masked",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			35 + var_5_5,
			-30,
			2
		},
		area_size = {
			var_0_14.game_option_deus_weekly.size[1] - 35 - var_5_5,
			50
		}
	}
	var_5_4.icon = {
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
			var_5_5,
			-5,
			0
		}
	}
	var_5_1.passes = var_5_2
	var_5_0.element = var_5_1
	var_5_0.content = var_5_3
	var_5_0.style = var_5_4
	var_5_0.scenegraph_id = "game_option_deus_weekly_anchor"
	var_5_0.offset = {
		0,
		arg_5_3,
		2
	}

	return var_5_0
end

local function var_0_18(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	arg_6_3 = arg_6_3 or "map_frame_fade"

	local var_6_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_6_3)
	local var_6_1 = var_6_0 and var_6_0.size or {
		150,
		150
	}

	arg_6_5 = arg_6_5 == nil or arg_6_5
	arg_6_4 = arg_6_4 or "game_options_bg_02"

	local var_6_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_6_4)
	local var_6_3 = "menu_frame_08"
	local var_6_4 = UIFrameSettings[var_6_3]
	local var_6_5 = var_6_4.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					texture_id = "icon_frame",
					style_id = "icon_frame",
					pass_type = "texture",
					content_check_function = function (arg_7_0)
						return arg_7_0.icon_visible
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (arg_8_0)
						return arg_8_0.icon_visible
					end
				},
				{
					style_id = "option_text",
					pass_type = "text",
					text_id = "option_text"
				},
				{
					style_id = "option_text_shadow",
					pass_type = "text",
					text_id = "option_text"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					pass_type = "texture",
					style_id = "title_bg",
					texture_id = "title_bg"
				},
				{
					pass_type = "texture",
					style_id = "title_edge",
					texture_id = "title_edge"
				}
			}
		},
		content = {
			title_bg = "playername_bg_02",
			icon_frame = "map_frame_00",
			title_edge = "game_option_divider",
			option_text = "",
			frame = var_6_4.texture,
			title_text = arg_6_2 or "n/a",
			icon = arg_6_3,
			icon_visible = arg_6_5,
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_6_1[2] / var_6_2.size[2], 1)
					},
					{
						math.min(arg_6_1[1] / var_6_2.size[1], 1),
						1
					}
				},
				texture_id = arg_6_4
			}
		},
		style = {
			frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					10
				},
				size = arg_6_1,
				texture_size = var_6_4.texture_size,
				texture_sizes = var_6_4.texture_sizes
			},
			background = {
				texture_tiling_size = {
					400,
					150
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = var_6_1,
				offset = {
					arg_6_1[1] / 2 - 120,
					0,
					5
				}
			},
			icon_frame = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					180,
					180
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_6_1[1] / 2 - 120,
					0,
					6
				}
			},
			title_bg = {
				size = {
					arg_6_1[1],
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_6_1[2] - 38 - var_6_5,
					2
				}
			},
			title_edge = {
				size = {
					arg_6_1[1],
					5
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_6_1[2] - 38 - var_6_5,
					4
				}
			},
			title_text = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_6_5 + 5,
					-var_6_5,
					10
				}
			},
			title_text_shadow = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_6_5 + 5 + 2,
					-(var_6_5 + 2),
					9
				}
			},
			option_text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_6_5 + 5,
					-55,
					10
				}
			},
			option_text_shadow = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_6_5 + 5 + 2,
					-57,
					9
				}
			}
		},
		scenegraph_id = arg_6_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_19(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	arg_9_3 = arg_9_3 or "map_frame_fade"

	local var_9_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_9_3)
	local var_9_1 = var_9_0 and var_9_0.size or {
		150,
		150
	}

	arg_9_5 = arg_9_5 == nil or arg_9_5

	local var_9_2 = UIAtlasHelper.get_atlas_settings_by_texture_name("vote_background_morris")
	local var_9_3 = UIFrameSettings.menu_frame_02_morris
	local var_9_4 = var_9_3.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "texture",
					content_id = "background"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					pass_type = "rotated_texture",
					style_id = "icon_mask",
					texture_id = "icon_mask",
					content_check_function = function (arg_10_0)
						return arg_10_0.icon_visible
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (arg_11_0)
						return arg_11_0.icon_visible
					end
				},
				{
					texture_id = "journey_border",
					style_id = "journey_border",
					pass_type = "texture",
					content_check_function = function (arg_12_0)
						return arg_12_0.icon_visible and arg_12_0.show_journey_border and not arg_12_0.with_belakor
					end
				},
				{
					texture_id = "belakor_journey_border",
					style_id = "belakor_journey_border",
					pass_type = "texture",
					content_check_function = function (arg_13_0)
						return arg_13_0.icon_visible and arg_13_0.show_journey_border and arg_13_0.with_belakor
					end
				},
				{
					style_id = "option_text",
					pass_type = "text",
					text_id = "option_text"
				},
				{
					style_id = "option_text_shadow",
					pass_type = "text",
					text_id = "option_text"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				}
			}
		},
		content = {
			journey_border = "vote_expedition_border",
			with_belakor = false,
			show_journey_border = false,
			belakor_journey_border = "vote_icon_border_belakor",
			option_text = "",
			icon_mask = "mask_rect",
			frame = var_9_3.texture,
			title_text = arg_9_2 or "n/a",
			icon = arg_9_3,
			icon_visible = arg_9_5,
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_9_1[2] / var_9_2.size[2], 1)
					},
					{
						math.min(arg_9_1[1] / var_9_2.size[1], 1),
						1
					}
				},
				texture_id = var_9_2.texture_name
			}
		},
		style = {
			frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					10
				},
				size = arg_9_1,
				texture_size = var_9_3.texture_size,
				texture_sizes = var_9_3.texture_sizes
			},
			background = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			icon_mask = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					117,
					117
				},
				angle = math.degrees_to_radians(45),
				pivot = {
					58.5,
					58.5
				},
				offset = {
					arg_9_1[1] / 2 - 120,
					0,
					5
				}
			},
			icon = {
				vertical_alignment = "center",
				masked = true,
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = var_9_1,
				offset = {
					arg_9_1[1] / 2 - 120,
					0,
					5
				}
			},
			journey_border = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					180,
					180
				},
				offset = {
					arg_9_1[1] / 2 - 120,
					0,
					5
				}
			},
			belakor_journey_border = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					210,
					210
				},
				offset = {
					arg_9_1[1] / 2 - 120,
					0,
					5
				}
			},
			title_text = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_9_4 + 5,
					-var_9_4,
					10
				}
			},
			title_text_shadow = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_9_4 + 5 + 2,
					-(var_9_4 + 2),
					9
				}
			},
			option_text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_9_4 + 5,
					-55,
					10
				}
			},
			option_text_shadow = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_9_4 + 5 + 2,
					-57,
					9
				}
			}
		},
		scenegraph_id = arg_9_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_20(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	arg_14_3 = arg_14_3 or "map_frame_fade"

	local var_14_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_14_3)
	local var_14_1 = var_14_0 and var_14_0.size or {
		150,
		150
	}

	arg_14_5 = arg_14_5 == nil or arg_14_5

	local var_14_2 = UIAtlasHelper.get_atlas_settings_by_texture_name("vote_background_morris")
	local var_14_3 = UIFrameSettings.menu_frame_02_morris
	local var_14_4 = var_14_3.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "texture",
					content_id = "background"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					pass_type = "rotated_texture",
					style_id = "icon_mask",
					texture_id = "icon_mask",
					content_check_function = function (arg_15_0)
						return arg_15_0.icon_visible
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (arg_16_0)
						return arg_16_0.icon_visible
					end
				},
				{
					texture_id = "journey_border",
					style_id = "journey_border",
					pass_type = "texture",
					content_check_function = function (arg_17_0)
						return arg_17_0.icon_visible and arg_17_0.show_journey_border and not arg_17_0.with_belakor
					end
				},
				{
					texture_id = "belakor_journey_border",
					style_id = "belakor_journey_border",
					pass_type = "texture",
					content_check_function = function (arg_18_0)
						return arg_18_0.icon_visible and arg_18_0.show_journey_border and arg_18_0.with_belakor
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "difficulty_text",
					pass_type = "text",
					text_id = "difficulty_text"
				},
				{
					style_id = "difficulty_text_shadow",
					pass_type = "text",
					text_id = "difficulty_text"
				},
				{
					style_id = "difficulty_title_text",
					pass_type = "text",
					text_id = "difficulty_title_text"
				},
				{
					style_id = "difficulty_title_text_shadow",
					pass_type = "text",
					text_id = "difficulty_title_text"
				},
				{
					texture_id = "difficulty_icon",
					style_id = "difficulty_icon",
					pass_type = "texture"
				}
			}
		},
		content = {
			difficulty_text = "",
			with_belakor = false,
			show_journey_border = false,
			belakor_journey_border = "vote_icon_border_belakor",
			journey_border = "vote_expedition_border",
			difficulty_icon = "icons_placeholder",
			option_text = "",
			icon_mask = "mask_rect",
			frame = var_14_3.texture,
			title_text = arg_14_2 or "n/a",
			icon = arg_14_3,
			icon_visible = arg_14_5,
			difficulty_title_text = Localize("start_game_window_difficulty"),
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_14_1[2] / var_14_2.size[2], 1)
					},
					{
						math.min(arg_14_1[1] / var_14_2.size[1], 1),
						1
					}
				},
				texture_id = var_14_2.texture_name
			}
		},
		style = {
			frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					10
				},
				size = arg_14_1,
				texture_size = var_14_3.texture_size,
				texture_sizes = var_14_3.texture_sizes
			},
			background = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			icon_mask = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					117,
					117
				},
				angle = math.degrees_to_radians(45),
				pivot = {
					58.5,
					58.5
				},
				offset = {
					arg_14_1[1] / 2 - 120,
					0,
					5
				}
			},
			icon = {
				vertical_alignment = "center",
				masked = true,
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = var_14_1,
				offset = {
					arg_14_1[1] / 2 - 120,
					0,
					5
				}
			},
			journey_border = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					180,
					180
				},
				offset = {
					arg_14_1[1] / 2 - 120,
					0,
					6
				}
			},
			belakor_journey_border = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					210,
					210
				},
				offset = {
					arg_14_1[1] / 2 - 120,
					0,
					6
				}
			},
			title_text = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_14_4 + 5,
					-var_14_4 - 5,
					10
				}
			},
			title_text_shadow = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_14_4 + 5 + 2,
					-(var_14_4 + 2) - 5,
					9
				}
			},
			difficulty_icon = {
				vertical_alignment = "top",
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
					var_14_4,
					-135,
					5
				}
			},
			difficulty_title_text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_14_4 + 5 + 40,
					-135,
					10
				}
			},
			difficulty_title_text_shadow = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_14_4 + 5 + 2 + 40,
					-137,
					9
				}
			},
			difficulty_text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_14_4 + 5 + 40,
					-165,
					10
				}
			},
			difficulty_text_shadow = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_14_4 + 5 + 2 + 40,
					-167,
					9
				}
			}
		},
		scenegraph_id = arg_14_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_21(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	arg_19_3 = arg_19_3 or "map_frame_fade"

	local var_19_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_19_3)
	local var_19_1 = var_19_0 and var_19_0.size or {
		150,
		150
	}

	arg_19_5 = arg_19_5 == nil or arg_19_5
	arg_19_4 = arg_19_4 or "game_options_bg_02"

	local var_19_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_19_4)
	local var_19_3 = "menu_frame_08"
	local var_19_4 = UIFrameSettings[var_19_3]
	local var_19_5 = var_19_4.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					texture_id = "icon_frame",
					style_id = "icon_frame",
					pass_type = "texture",
					content_check_function = function (arg_20_0)
						return arg_20_0.icon_visible
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (arg_21_0)
						return arg_21_0.icon_visible
					end
				},
				{
					texture_id = "wind_icon",
					style_id = "wind_icon",
					pass_type = "texture",
					content_check_function = function (arg_22_0)
						return arg_22_0.icon_visible
					end
				},
				{
					texture_id = "wind_icon_bg",
					style_id = "wind_icon_bg",
					pass_type = "texture",
					content_check_function = function (arg_23_0)
						return arg_23_0.icon_visible
					end
				},
				{
					texture_id = "wind_icon_glow",
					style_id = "wind_icon_glow",
					pass_type = "texture",
					content_check_function = function (arg_24_0)
						return arg_24_0.icon_visible
					end
				},
				{
					texture_id = "wind_icon_slot",
					style_id = "wind_icon_slot",
					pass_type = "texture",
					content_check_function = function (arg_25_0)
						return arg_25_0.icon_visible
					end
				},
				{
					style_id = "option_text",
					pass_type = "text",
					text_id = "option_text"
				},
				{
					style_id = "option_text_shadow",
					pass_type = "text",
					text_id = "option_text"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "mission_title",
					pass_type = "text",
					text_id = "mission_title"
				},
				{
					style_id = "mission_title_shadow",
					pass_type = "text",
					text_id = "mission_title"
				},
				{
					style_id = "mission_name",
					pass_type = "text",
					text_id = "mission_name"
				},
				{
					style_id = "mission_name_shadow",
					pass_type = "text",
					text_id = "mission_name"
				},
				{
					style_id = "wind_name",
					pass_type = "text",
					text_id = "wind_name"
				},
				{
					style_id = "wind_name_shadow",
					pass_type = "text",
					text_id = "wind_name"
				},
				{
					pass_type = "texture",
					style_id = "title_bg",
					texture_id = "title_bg"
				},
				{
					pass_type = "texture",
					style_id = "title_edge",
					texture_id = "title_edge"
				}
			}
		},
		content = {
			wind_icon_glow = "winds_icon_background_glow",
			icon_frame = "map_frame_weaves",
			wind_icon_slot = "weave_item_icon_border_center",
			wind_icon_bg = "weave_item_icon_border_selected",
			title_edge = "game_option_divider",
			option_text = "",
			wind_icon = "icon_wind_azyr",
			title_bg = "playername_bg_02",
			wind_title = "Wind: ",
			frame = var_19_4.texture,
			title_text = arg_19_2 or "n/a",
			icon = arg_19_3,
			icon_visible = arg_19_5,
			mission_title = Localize("lb_level") .. ":",
			mission_name = Localize("level_name_farmlands"),
			wind_name = Localize("wind_metal_name"),
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_19_1[2] / var_19_2.size[2], 1)
					},
					{
						math.min(arg_19_1[1] / var_19_2.size[1], 1),
						1
					}
				},
				texture_id = arg_19_4
			}
		},
		style = {
			wind_icon = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					51.2,
					51.2
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-94,
					10,
					13
				}
			},
			wind_icon_glow = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40.800000000000004,
					42.400000000000006
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-99,
					15,
					12
				}
			},
			wind_icon_slot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					51.2,
					51.2
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-94,
					10,
					11
				}
			},
			wind_icon_bg = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					58.400000000000006,
					58.400000000000006
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-91,
					7,
					10
				}
			},
			frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					10
				},
				size = arg_19_1,
				texture_size = var_19_4.texture_size,
				texture_sizes = var_19_4.texture_sizes
			},
			background = {
				texture_tiling_size = {
					400,
					150
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = var_19_1,
				offset = {
					arg_19_1[1] / 2 - 120,
					-15,
					5
				}
			},
			icon_frame = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					164.8,
					164.8
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_19_1[1] / 2 - 120,
					-15,
					6
				}
			},
			title_bg = {
				size = {
					arg_19_1[1],
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_19_1[2] - 38 - var_19_5,
					2
				}
			},
			title_edge = {
				size = {
					arg_19_1[1],
					5
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_19_1[2] - 38 - var_19_5,
					4
				}
			},
			title_text = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				font_size = 32,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					var_0_5[1] - (var_19_5 + 10),
					var_0_5[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_19_5 + 5,
					-var_19_5,
					10
				}
			},
			title_text_shadow = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				font_size = 32,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					var_0_5[1] - (var_19_5 + 10),
					var_0_5[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_19_5 + 5 + 2,
					-(var_19_5 + 2),
					9
				}
			},
			mission_title = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					var_0_5[1] - (var_19_5 + 10),
					var_0_5[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_19_5 + 5,
					-var_19_5 - 50,
					12
				}
			},
			mission_title_shadow = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					var_0_5[1] - (var_19_5 + 10),
					var_0_5[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_19_5 + 5 + 2,
					-(var_19_5 + 2) - 50,
					11
				}
			},
			wind_title = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					var_0_5[1] - (var_19_5 + 10),
					var_0_5[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_19_5 + 5,
					-var_19_5 - 80,
					12
				}
			},
			wind_title_shadow = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					var_0_5[1] - (var_19_5 + 10),
					var_0_5[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_19_5 + 5 + 2,
					-(var_19_5 + 2) - 80,
					11
				}
			},
			mission_name = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					var_0_5[1] - (var_19_5 + 10),
					var_0_5[2]
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				default_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_19_5 + 5,
					-var_19_5 - 75,
					10
				}
			},
			mission_name_shadow = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					var_0_5[1] - (var_19_5 + 10),
					var_0_5[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_19_5 + 5 + 2,
					-(var_19_5 + 2) - 75,
					9
				}
			},
			wind_name = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					var_0_5[1] - (var_19_5 + 10),
					var_0_5[2]
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				default_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_19_5 + 5,
					-var_19_5 - 100,
					10
				}
			},
			wind_name_shadow = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					var_0_5[1] - (var_19_5 + 10),
					var_0_5[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_19_5 + 5 + 2,
					-(var_19_5 + 2) - 100,
					9
				}
			},
			option_text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_19_5 + 5,
					-55,
					10
				}
			},
			option_text_shadow = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_19_5 + 5 + 2,
					-57,
					9
				}
			}
		},
		scenegraph_id = arg_19_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_22(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
	local var_26_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_26_3 or "game_options_bg_02")

	arg_26_4 = arg_26_4 or "menu_frame_08"

	local var_26_1 = UIFrameSettings[arg_26_4]
	local var_26_2 = var_26_1.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					pass_type = "texture",
					style_id = "title_bg",
					texture_id = "title_bg"
				},
				{
					pass_type = "texture",
					style_id = "title_edge",
					texture_id = "title_edge"
				},
				{
					style_id = "option_text",
					pass_type = "text",
					text_id = "option_text"
				},
				{
					style_id = "option_text_shadow",
					pass_type = "text",
					text_id = "option_text"
				}
			}
		},
		content = {
			title_bg = "playername_bg_02",
			option_text = "",
			title_edge = "game_option_divider",
			frame = var_26_1.texture,
			title_text = arg_26_2 or "n/a",
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_26_1[2] / var_26_0.size[2], 1)
					},
					{
						math.min(arg_26_1[1] / var_26_0.size[1], 1),
						1
					}
				},
				texture_id = var_26_0.texture_name
			}
		},
		style = {
			frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					10
				},
				size = arg_26_1,
				texture_size = var_26_1.texture_size,
				texture_sizes = var_26_1.texture_sizes
			},
			background = {
				texture_tiling_size = {
					400,
					150
				},
				color = {
					arg_26_3 and 255 or 0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			title_bg = {
				size = {
					arg_26_1[1],
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_26_1[2] - 38 - var_26_2,
					2
				}
			},
			title_edge = {
				size = {
					arg_26_1[1],
					5
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_26_1[2] - 38 - var_26_2,
					4
				}
			},
			title_text = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_26_2 + 5,
					-var_26_2,
					10
				}
			},
			title_text_shadow = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_26_2 + 5 + 2,
					-(var_26_2 + 2),
					9
				}
			},
			option_text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_26_2 + 5,
					-55,
					10
				}
			},
			option_text_shadow = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_26_2 + 5 + 2,
					-57,
					9
				}
			}
		},
		scenegraph_id = arg_26_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_23(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = "game_options_bg_05"
	local var_27_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_27_0)

	arg_27_2 = arg_27_2 or "menu_frame_08"

	local var_27_2 = UIFrameSettings[arg_27_2]
	local var_27_3 = var_27_2.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "option_text",
					pass_type = "text",
					text_id = "option_text"
				},
				{
					style_id = "option_text_shadow",
					pass_type = "text",
					text_id = "option_text"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					pass_type = "texture",
					style_id = "title_bg",
					texture_id = "title_bg"
				},
				{
					pass_type = "texture",
					style_id = "title_edge",
					texture_id = "title_edge"
				}
			}
		},
		content = {
			title_bg = "playername_bg_02",
			title_edge = "game_option_divider",
			button_hotspot = {},
			frame = var_27_2.texture,
			option_text = Localize("start_game_window_adventure_reward_desc"),
			title_text = Localize("start_game_window_adventure_reward_title"),
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_27_1[2] / var_27_1.size[2], 1)
					},
					{
						math.min(arg_27_1[1] / var_27_1.size[1], 1),
						1
					}
				},
				texture_id = var_27_0
			}
		},
		style = {
			frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					10
				},
				size = arg_27_1,
				texture_size = var_27_2.texture_size,
				texture_sizes = var_27_2.texture_sizes
			},
			background = {
				texture_tiling_size = {
					400,
					150
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			title_bg = {
				size = {
					arg_27_1[1],
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_27_1[2] - 38 - var_27_3,
					2
				}
			},
			title_edge = {
				size = {
					arg_27_1[1],
					5
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_27_1[2] - 38 - var_27_3,
					4
				}
			},
			title_text = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_27_3 + 5,
					-var_27_3,
					10
				}
			},
			title_text_shadow = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_27_3 + 5 + 2,
					-(var_27_3 + 2),
					9
				}
			},
			option_text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_27_3,
					var_27_3 + 10,
					10
				},
				size = {
					arg_27_1[1] - var_27_3 * 2,
					arg_27_1[2]
				}
			},
			option_text_shadow = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_27_3 + 2,
					var_27_3 + 8,
					9
				},
				size = {
					arg_27_1[1] - var_27_3 * 2,
					arg_27_1[2]
				}
			},
			button_disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					var_27_3,
					var_27_3,
					15
				},
				size = {
					arg_27_1[1] - var_27_3 * 2,
					arg_27_1[2] - var_27_3 * 2
				}
			}
		},
		scenegraph_id = arg_27_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_24(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = "game_options_versus"
	local var_28_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_28_0)

	arg_28_2 = arg_28_2 or "menu_frame_08"

	local var_28_2 = UIFrameSettings[arg_28_2]
	local var_28_3 = var_28_2.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					pass_type = "texture",
					style_id = "title_bg",
					texture_id = "title_bg"
				},
				{
					pass_type = "texture",
					style_id = "title_edge",
					texture_id = "title_edge"
				}
			}
		},
		content = {
			title_bg = "playername_bg_02",
			title_edge = "game_option_divider",
			button_hotspot = {},
			frame = var_28_2.texture,
			option_text = Localize("start_game_window_adventure_reward_desc"),
			title_text = Localize("lb_game_type_versus_quickplay"),
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_28_1[2] / var_28_1.size[2], 1)
					},
					{
						math.min(arg_28_1[1] / var_28_1.size[1], 1),
						1
					}
				},
				texture_id = var_28_0
			}
		},
		style = {
			frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					10
				},
				size = arg_28_1,
				texture_size = var_28_2.texture_size,
				texture_sizes = var_28_2.texture_sizes
			},
			background = {
				texture_tiling_size = {
					400,
					150
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			title_bg = {
				size = {
					arg_28_1[1],
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_28_1[2] - 38 - var_28_3,
					2
				}
			},
			title_edge = {
				size = {
					arg_28_1[1],
					5
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_28_1[2] - 38 - var_28_3,
					4
				}
			},
			title_text = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_28_3 + 5,
					-var_28_3,
					10
				}
			},
			title_text_shadow = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_28_3 + 5 + 2,
					-(var_28_3 + 2),
					9
				}
			},
			option_text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_28_3,
					var_28_3 + 10,
					10
				},
				size = {
					arg_28_1[1] - var_28_3 * 2,
					arg_28_1[2]
				}
			},
			option_text_shadow = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_28_3 + 2,
					var_28_3 + 8,
					9
				},
				size = {
					arg_28_1[1] - var_28_3 * 2,
					arg_28_1[2]
				}
			},
			button_disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					var_28_3,
					var_28_3,
					15
				},
				size = {
					arg_28_1[1] - var_28_3 * 2,
					arg_28_1[2] - var_28_3 * 2
				}
			}
		},
		scenegraph_id = arg_28_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_25(arg_29_0, arg_29_1)
	local var_29_0 = "weaves_icon"
	local var_29_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_29_0)
	local var_29_2 = "menu_frame_08"
	local var_29_3 = UIFrameSettings[var_29_2]
	local var_29_4 = var_29_3.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					pass_type = "rect",
					style_id = "bg_color"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "option_text",
					pass_type = "text",
					text_id = "option_text"
				},
				{
					style_id = "option_text_shadow",
					pass_type = "text",
					text_id = "option_text"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					pass_type = "texture",
					style_id = "title_bg",
					texture_id = "title_bg"
				},
				{
					pass_type = "texture",
					style_id = "title_edge",
					texture_id = "title_edge"
				},
				{
					style_id = "smoke_1",
					pass_type = "texture_uv",
					content_id = "smoke_1"
				},
				{
					style_id = "smoke_2",
					pass_type = "texture_uv",
					content_id = "smoke_2"
				},
				{
					style_id = "ember_1",
					pass_type = "texture_uv",
					content_id = "ember_1"
				},
				{
					style_id = "ember_2",
					pass_type = "texture_uv",
					content_id = "ember_2"
				},
				{
					style_id = "ember_3",
					pass_type = "texture_uv",
					content_id = "ember_3"
				}
			}
		},
		content = {
			title_bg = "playername_bg_02",
			title_edge = "game_option_divider",
			button_hotspot = {},
			frame = var_29_3.texture,
			option_text = Localize("menu_weave_quick_play_body"),
			title_text = Localize("start_game_window_weave_quickplay_title"),
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_29_1[2] / var_29_1.size[2], 1)
					},
					{
						math.min(arg_29_1[1] / var_29_1.size[1], 1),
						1
					}
				},
				texture_id = var_29_0
			},
			smoke_1 = {
				texture_id = "forge_overview_bottom_glow_effect_smoke_1",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			},
			smoke_2 = {
				texture_id = "forge_overview_bottom_glow_effect_smoke_2",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			},
			ember_1 = {
				texture_id = "forge_overview_bottom_glow_effect_embers_1",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			},
			ember_2 = {
				texture_id = "forge_overview_bottom_glow_effect_embers_2",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			},
			ember_3 = {
				texture_id = "forge_overview_bottom_glow_effect_embers_3",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			}
		},
		style = {
			frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					10
				},
				size = arg_29_1,
				texture_size = var_29_3.texture_size,
				texture_sizes = var_29_3.texture_sizes
			},
			background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = var_29_1.size,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					7
				}
			},
			bg_color = {
				color = {
					255,
					0,
					0,
					0
				}
			},
			title_bg = {
				size = {
					arg_29_1[1],
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_29_1[2] - 38 - var_29_4,
					2
				}
			},
			title_edge = {
				size = {
					arg_29_1[1],
					5
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_29_1[2] - 38 - var_29_4,
					4
				}
			},
			title_text = {
				font_size = 32,
				upper_case = true,
				localize = false,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_29_4 + 5,
					-var_29_4,
					10
				}
			},
			title_text_shadow = {
				font_size = 32,
				upper_case = true,
				localize = false,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_29_4 + 5 + 2,
					-(var_29_4 + 2),
					9
				}
			},
			option_text = {
				font_size = 26,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_29_4,
					var_29_4 + 10,
					10
				},
				size = {
					arg_29_1[1] - var_29_4 * 2,
					arg_29_1[2]
				}
			},
			option_text_shadow = {
				font_size = 26,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_29_4 + 2,
					var_29_4 + 8,
					9
				},
				size = {
					arg_29_1[1] - var_29_4 * 2,
					arg_29_1[2]
				}
			},
			button_disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					var_29_4,
					var_29_4,
					15
				},
				size = {
					arg_29_1[1] - var_29_4 * 2,
					arg_29_1[2] - var_29_4 * 2
				}
			},
			smoke_1 = {
				color = {
					200,
					138,
					0,
					147
				},
				offset = {
					0,
					0,
					1
				}
			},
			smoke_2 = {
				color = {
					255,
					138,
					0,
					187
				},
				size = {
					arg_29_1[1],
					arg_29_1[2] * 0.5
				},
				offset = {
					0,
					0,
					2
				}
			},
			ember_1 = {
				color = {
					200,
					128,
					0,
					217
				},
				size = {
					arg_29_1[1],
					arg_29_1[2] * 0.3
				},
				offset = {
					0,
					0,
					3
				}
			},
			ember_2 = {
				color = {
					130,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					4
				}
			},
			ember_3 = {
				color = {
					130,
					255,
					255,
					255
				},
				size = {
					arg_29_1[1],
					arg_29_1[2] * 0.7
				},
				offset = {
					0,
					0,
					5
				}
			}
		},
		scenegraph_id = arg_29_0,
		offset = {
			0,
			0,
			0
		}
	}
end

function create_twitch_disclaimer(arg_30_0)
	local var_30_0 = "twitch_mode_info"
	local var_30_1 = var_0_14[var_30_0].size
	local var_30_2 = "menu_frame_08"
	local var_30_3 = UIFrameSettings[var_30_2]
	local var_30_4 = var_30_3.texture_sizes.corner[1]
	local var_30_5 = {
		350 / var_30_1[1],
		108 / var_30_1[2]
	}
	local var_30_6 = "Twitch"
	local var_30_7 = arg_30_0 and "twitch_warning_text_server" or "twitch_warning_text_client"
	local var_30_8 = string.format(Localize(var_30_7), var_30_6, var_30_6)

	return {
		element = {
			passes = {
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					pass_type = "rect",
					style_id = "background"
				},
				{
					texture_id = "twitch_background_texture_id",
					style_id = "twitch_background",
					pass_type = "texture"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "disclaimer_text",
					pass_type = "text",
					text_id = "disclaimer_text"
				},
				{
					style_id = "disclaimer_text_shadow",
					pass_type = "text",
					text_id = "disclaimer_text"
				},
				{
					pass_type = "texture",
					style_id = "title_bg",
					texture_id = "title_bg"
				},
				{
					pass_type = "texture",
					style_id = "title_edge",
					texture_id = "title_edge"
				}
			}
		},
		content = {
			title_edge = "game_option_divider",
			title_text = "twitch_disconnect_warning",
			title_bg = "playername_bg_02",
			twitch_background_texture_id = "menu_options_button_image_03",
			frame = var_30_3.texture,
			disclaimer_text = var_30_8
		},
		style = {
			frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					10
				},
				size = var_30_1,
				texture_size = var_30_3.texture_size,
				texture_sizes = var_30_3.texture_sizes
			},
			background = {
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				}
			},
			twitch_background = {
				horizontal_alignment = "right",
				texture_size = {
					var_30_1[1] * var_30_5[1],
					var_30_1[2] * var_30_5[2]
				},
				color = {
					192,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				}
			},
			title_bg = {
				size = {
					var_30_1[1],
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_30_1[2] - 38 - var_30_4,
					2
				}
			},
			title_edge = {
				size = {
					var_30_1[1],
					5
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_30_1[2] - 38 - var_30_4,
					4
				}
			},
			title_text = {
				font_size = 32,
				upper_case = true,
				localize = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("red", 255),
				default_text_color = Colors.get_color_table_with_alpha("red", 255),
				offset = {
					var_30_4 + 5,
					-var_30_4,
					10
				}
			},
			title_text_shadow = {
				font_size = 32,
				upper_case = true,
				localize = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_30_4 + 5 + 2,
					-(var_30_4 + 2),
					9
				}
			},
			disclaimer_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				size = {
					var_30_1[1] - 15,
					var_30_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_30_4 + 5,
					-var_30_4 - 40,
					10
				}
			},
			disclaimer_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				size = {
					var_30_1[1] - 15,
					var_30_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_30_4 + 5 + 2,
					-(var_30_4 + 2) - 40,
					9
				}
			}
		},
		scenegraph_id = var_30_0,
		offset = {
			0,
			0,
			0
		}
	}
end

function create_twitch_mode(arg_31_0)
	local var_31_0 = "twitch_mode_info"
	local var_31_1 = var_0_14[var_31_0].size
	local var_31_2 = "menu_frame_08"
	local var_31_3 = UIFrameSettings[var_31_2]
	local var_31_4 = var_31_3.texture_sizes.corner[1]
	local var_31_5 = {
		350 / var_31_1[1],
		108 / var_31_1[2]
	}
	local var_31_6 = "Twitch"
	local var_31_7 = Localize("twitch_info_text_server")
	local var_31_8 = string.format(var_31_7, var_31_6)

	return {
		element = {
			passes = {
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					pass_type = "rect",
					style_id = "background"
				},
				{
					texture_id = "twitch_background_texture_id",
					style_id = "twitch_background",
					pass_type = "texture"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "info_text",
					pass_type = "text",
					text_id = "info_text"
				},
				{
					style_id = "info_text_shadow",
					pass_type = "text",
					text_id = "info_text"
				},
				{
					pass_type = "texture",
					style_id = "title_bg",
					texture_id = "title_bg"
				},
				{
					pass_type = "texture",
					style_id = "title_edge",
					texture_id = "title_edge"
				}
			}
		},
		content = {
			title_edge = "game_option_divider",
			title_text = "twitch_mode",
			title_bg = "playername_bg_02",
			twitch_background_texture_id = "menu_options_button_image_03",
			frame = var_31_3.texture,
			info_text = var_31_8
		},
		style = {
			frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					10
				},
				size = var_31_1,
				texture_size = var_31_3.texture_size,
				texture_sizes = var_31_3.texture_sizes
			},
			background = {
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				}
			},
			twitch_background = {
				horizontal_alignment = "right",
				texture_size = {
					var_31_1[1] * var_31_5[1],
					var_31_1[2] * var_31_5[2]
				},
				color = {
					192,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				}
			},
			title_bg = {
				size = {
					var_31_1[1],
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_31_1[2] - 38 - var_31_4,
					2
				}
			},
			title_edge = {
				size = {
					var_31_1[1],
					5
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_31_1[2] - 38 - var_31_4,
					4
				}
			},
			title_text = {
				font_size = 32,
				upper_case = true,
				localize = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				default_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_31_4 + 5,
					-var_31_4,
					10
				}
			},
			title_text_shadow = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_31_4 + 5 + 2,
					-(var_31_4 + 2),
					9
				}
			},
			info_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				size = {
					var_31_1[1] - 15,
					var_31_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_31_4 + 5,
					-var_31_4 - 40,
					10
				}
			},
			info_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				size = {
					var_31_1[1] - 15,
					var_31_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_31_4 + 5 + 2,
					-(var_31_4 + 2) - 40,
					9
				}
			}
		},
		scenegraph_id = var_31_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_26(arg_32_0, arg_32_1)
	return {
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture",
					content_check_function = function (arg_33_0)
						return arg_33_0.text ~= "tutorial_no_text"
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (arg_34_0)
						return arg_34_0.text ~= "tutorial_no_text"
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_35_0)
						return arg_35_0.text ~= "tutorial_no_text"
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_36_0)
						return arg_36_0.text ~= "tutorial_no_text"
					end
				}
			}
		},
		content = {
			text = "-",
			icon = "objective_icon_general",
			background = "chest_upgrade_fill_glow"
		},
		style = {
			background = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					22,
					23
				},
				color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					0,
					1
				}
			},
			text = {
				word_wrap = true,
				localize = true,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				size = {
					arg_32_1[1] - 60,
					arg_32_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					50,
					0,
					2
				}
			},
			text_shadow = {
				word_wrap = true,
				localize = true,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				size = {
					arg_32_1[1] - 60,
					arg_32_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					52,
					-2,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_32_0
	}
end

local function var_0_27(arg_37_0, arg_37_1)
	return {
		element = {
			passes = {
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (arg_38_0)
						return #arg_38_0.text > 0
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_39_0)
						return #arg_39_0.text > 0
					end
				}
			}
		},
		content = {
			text = "",
			icon = arg_37_1
		},
		style = {
			icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					30,
					30
				},
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			text = {
				font_size = 26,
				upper_case = false,
				localize = true,
				use_shadow = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					40,
					0,
					0
				}
			}
		},
		scenegraph_id = arg_37_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_28 = {
	font_size = 32,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_29 = {
	font_size = 24,
	use_shadow = true,
	localize = false,
	dynamic_font_size_word_wrap = true,
	word_wrap = true,
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
local var_0_30 = {
	font_size = 28,
	upper_case = true,
	localize = true,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_31 = {
	font_size = 55,
	upper_case = true,
	localize = true,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		162,
		102,
		74
	},
	adventure_text_color = {
		255,
		162,
		102,
		74
	},
	morris_text_color = {
		255,
		255,
		107,
		0
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_32 = {
	font_size = 32,
	upper_case = false,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	adventure_text_color = {
		255,
		255,
		255,
		255
	},
	morris_text_color = {
		255,
		255,
		107,
		0
	},
	text_color = {
		255,
		255,
		255,
		255
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_33 = table.clone(var_0_32)

var_0_33.font_size = 32

local var_0_34 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		10,
		0,
		2
	}
}
local var_0_35 = {
	font_size = 28,
	upper_case = false,
	localize = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		0
	}
}
local var_0_36 = true
local var_0_37 = {
	background = {
		scenegraph_id = "screen",
		element = UIElements.SimpleTexture,
		content = {
			texture_id = "gradient_dice_game_reward"
		},
		style = {
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	window = UIWidgets.create_frame("window", var_0_14.window.size, "menu_frame_11", 10),
	window_background = UIWidgets.create_tiled_texture("window", "menu_frame_bg_01", {
		960,
		1080
	}, nil, nil, {
		255,
		100,
		100,
		100
	}),
	window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window_fade"),
	button_confirm = UIWidgets.create_play_button("button_confirm", var_0_14.button_confirm.size, "n/a", 34, var_0_36),
	button_abort = UIWidgets.create_default_button("button_abort", var_0_14.button_abort.size, nil, nil, "n/a", 24, nil, "button_detail_04", 34, var_0_36),
	game_options_left_chain = UIWidgets.create_tiled_texture("game_options_left_chain", "chain_link_01", {
		16,
		19
	}),
	game_options_right_chain = UIWidgets.create_tiled_texture("game_options_right_chain", "chain_link_01", {
		16,
		19
	}),
	title = UIWidgets.create_simple_texture("frame_title_bg_02", "title"),
	title_bg = UIWidgets.create_background("title_bg", var_0_14.title_bg.size, "menu_frame_bg_02"),
	title_text = UIWidgets.create_simple_text("", "title_text", nil, nil, var_0_15),
	timer_bg = UIWidgets.create_simple_texture("timer_bg", "timer_bg"),
	timer_fg = UIWidgets.create_simple_uv_texture("timer_fg", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "timer_fg"),
	timer_glow = UIWidgets.create_simple_texture("timer_detail", "timer_glow")
}
local var_0_38 = {
	background = {
		scenegraph_id = "screen",
		element = UIElements.SimpleTexture,
		content = {
			texture_id = "gradient_dice_game_reward"
		},
		style = {
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	deus_window = UIWidgets.create_frame("deus_window", var_0_14.deus_window.size, "menu_frame_04_morris", 10),
	window_background = UIWidgets.create_tiled_texture("window", "menu_frame_bg_01", {
		960,
		1080
	}, nil, nil, {
		255,
		100,
		100,
		100
	}),
	window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window_fade"),
	button_confirm = UIWidgets.create_start_game_deus_play_button("deus_button_confirm", var_0_14.deus_button_confirm.size, "n/a", 34, var_0_36),
	button_abort = UIWidgets.create_deus_default_button("button_abort", var_0_14.button_abort.size, "n/a", 24, var_0_36),
	game_options_left_chain = UIWidgets.create_tiled_texture("game_options_left_chain", "chain_link_01", {
		16,
		19
	}),
	game_options_right_chain = UIWidgets.create_tiled_texture("game_options_right_chain", "chain_link_01", {
		16,
		19
	}),
	title = UIWidgets.create_simple_texture("header_vote_morris", "title"),
	title_text = UIWidgets.create_simple_text("", "title_text", nil, nil, var_0_15),
	timer_bg = UIWidgets.create_simple_texture("timer_bg_morris", "timer_bg"),
	timer_fg = UIWidgets.create_simple_uv_texture("timer_fg", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "timer_fg"),
	timer_glow = UIWidgets.create_simple_texture("timer_detail", "timer_glow"),
	window_decorations = {
		scenegraph_id = "deus_window",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "left"
				},
				{
					pass_type = "texture_uv",
					style_id = "right"
				}
			}
		},
		content = {
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
		},
		style = {
			rect = {
				color = {
					127,
					255,
					255,
					255
				}
			},
			left = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				offset = {
					-15,
					0,
					10
				},
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					33,
					846
				}
			},
			right = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				offset = {
					15,
					0,
					10
				},
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					33,
					846
				}
			}
		}
	}
}
local var_0_39 = {}
local var_0_40 = {}
local var_0_41 = {}

for iter_0_0 = 1, 5 do
	var_0_40[iter_0_0] = "icon_score_rating"
	var_0_41[iter_0_0] = "icon_score_rating_empty"
	var_0_39[iter_0_0] = {
		22,
		22
	}
end

local var_0_42 = {
	"event_mission",
	"mutators"
}
local var_0_43 = {
	game_option_1 = var_0_18("game_option_1", var_0_14.game_option_1.size, Localize("start_game_window_difficulty"), "difficulty_option_1", "game_options_bg_02"),
	reward_presentation = var_0_23("reward_presentation", var_0_14.reward_presentation.size)
}
local var_0_44 = {
	game_mode_text = UIWidgets.create_simple_text("n/a", "mutator_description_text", nil, nil, var_0_30),
	frame = UIWidgets.create_frame("deed_option_bg", var_0_14.deed_option_bg.size, var_0_6, 20),
	bg = UIWidgets.create_simple_texture("game_options_bg_04", "deed_option_bg")
}
local var_0_45 = {
	title = UIWidgets.create_simple_text("n/a", "switch_mechanism_title", nil, nil, var_0_31),
	subtitle = UIWidgets.create_simple_text("n/a", "switch_mechanism_subtitle", nil, nil, var_0_32),
	description = UIWidgets.create_simple_text("n/a", "switch_mechanism_description", nil, nil, var_0_33),
	frame = UIWidgets.create_frame("deed_option_bg", var_0_14.deed_option_bg.size, var_0_6, 20),
	background = UIWidgets.create_simple_texture("vote_switch_mechanism_adventure_background", "deed_option_bg")
}
local var_0_46 = {
	game_option_1 = var_0_18("game_option_1", var_0_14.game_option_1.size, Localize("start_game_window_difficulty"), "difficulty_option_1", "game_options_bg_02"),
	reward_presentation = var_0_25("reward_presentation", var_0_14.reward_presentation.size)
}
local var_0_47 = {
	game_option_1 = var_0_18("game_option_1", var_0_14.game_option_1.size, Localize("start_game_window_mission"), nil, "game_options_bg_01"),
	game_option_2 = var_0_18("game_option_2", var_0_14.game_option_2.size, Localize("start_game_window_difficulty"), "difficulty_option_1", "game_options_bg_02"),
	additional_option = var_0_22("additional_option", var_0_14.additional_option.size, Localize("start_game_window_other_options_title"), "game_options_bg_03"),
	private_frame = UIWidgets.create_frame("private_button_frame", var_0_14.private_button_frame.size, var_0_1, 1),
	private_button = UIWidgets.create_default_checkbox_button("private_button", var_0_14.private_button.size, Localize("start_game_window_other_options_private"), 24, {
		title = Localize("start_game_window_other_options_private"),
		description = Localize("start_game_window_other_options_private_description")
	}),
	host_frame = UIWidgets.create_frame("host_button_frame", var_0_14.host_button_frame.size, var_0_1, 1),
	host_button = UIWidgets.create_default_checkbox_button("host_button", var_0_14.host_button.size, Localize("start_game_window_other_options_always_host"), 24, {
		title = Localize("start_game_window_other_options_always_host"),
		description = Localize("start_game_window_other_options_always_host_description")
	}),
	strict_matchmaking_frame = UIWidgets.create_frame("strict_matchmaking_button_frame", var_0_14.strict_matchmaking_button_frame.size, var_0_1, 1),
	strict_matchmaking_button = UIWidgets.create_default_checkbox_button("strict_matchmaking_button", var_0_14.strict_matchmaking_button.size, Localize("start_game_window_other_options_strict_matchmaking"), 24, {
		title = Localize("start_game_window_other_options_strict_matchmaking"),
		description = Localize("start_game_window_other_options_strict_matchmaking_description")
	})
}
local var_0_48 = {
	item_presentation_frame = UIWidgets.create_frame("deed_option_bg", var_0_14.deed_option_bg.size, var_0_6, 20),
	item_presentation_bg = UIWidgets.create_simple_texture("game_options_bg_04", "deed_option_bg"),
	item_presentation = UIWidgets.create_simple_item_presentation("item_presentation")
}
local var_0_49 = {
	game_option_1 = var_0_18("game_option_1", var_0_14.game_option_1.size, Localize("start_game_window_difficulty"), "difficulty_option_1", "game_options_bg_02"),
	event_summary_frame = UIWidgets.create_background_with_frame("event_summary_frame", var_0_14.event_summary_frame.size, "game_options_bg_04", "menu_frame_08", true),
	event_summary = UIWidgets.create_simple_item_presentation("event_summary", var_0_42)
}
local var_0_50 = {
	game_option_1 = var_0_21("game_option_1", var_0_14.game_option_1.size, Localize("start_game_window_mission"), nil, "game_options_bg_01"),
	event_summary_frame = UIWidgets.create_background_with_frame("event_summary_frame", var_0_14.event_summary_frame.size, "game_options_bg_04", "menu_frame_08", true),
	mutator_icon = UIWidgets.create_simple_texture("icons_placeholder", "mutator_icon"),
	mutator_title_text = UIWidgets.create_simple_text("n/a", "mutator_title_text", nil, nil, var_0_28),
	mutator_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "mutator_title_divider"),
	mutator_description_text = UIWidgets.create_simple_text("n/a", "mutator_description_text", nil, nil, var_0_29),
	objective_title_bg = UIWidgets.create_simple_texture("menu_subheader_bg", "objective_title_bg"),
	objective_title = UIWidgets.create_simple_text("weave_objective_title", "objective_title", nil, nil, var_0_30),
	objective_1 = var_0_26("objective_1", var_0_14.objective_1.size),
	objective_2 = var_0_26("objective_2", var_0_14.objective_2.size),
	private_checkbox = UIWidgets.create_default_checkbox_button("private_checkbox", var_0_14.private_checkbox.size, Localize("start_game_window_join_disallowed"), 24, {
		title = Localize("start_game_window_join_disallowed"),
		description = Localize("start_game_window_disallow_join_description")
	}, true)
}
local var_0_51 = {
	game_option_1 = var_0_19("game_option_1", var_0_14.game_option_1.size, Localize("start_game_window_mission"), nil, true),
	reward_presentation = var_0_23("reward_presentation", var_0_14.reward_presentation.size, "menu_frame_02_morris")
}
local var_0_52 = "menu_frame_01_morris"
local var_0_53 = {
	game_option_1 = var_0_19("game_option_1", var_0_14.game_option_1.size, Localize("start_game_window_mission"), nil, true),
	journey_name = UIWidgets.create_simple_text("n/a", "journey_name", nil, nil, var_0_35),
	journey_theme = var_0_27("journey_theme"),
	game_option_2 = var_0_19("game_option_2", var_0_14.game_option_2.size, Localize("start_game_window_difficulty"), "difficulty_option_1", nil),
	additional_option = var_0_22("additional_option", var_0_14.additional_option.size, Localize("start_game_window_other_options_title"), false, "menu_frame_02_morris"),
	private_frame = UIWidgets.create_frame("private_button_frame", var_0_14.private_button_frame.size, var_0_52, 1),
	private_button = UIWidgets.create_default_checkbox_button("private_button", var_0_14.private_button.size, Localize("start_game_window_other_options_private"), 24, {
		title = Localize("start_game_window_other_options_private"),
		description = Localize("start_game_window_other_options_private_description")
	}, nil, "menu_frame_03_morris"),
	host_frame = UIWidgets.create_frame("host_button_frame", var_0_14.host_button_frame.size, var_0_52, 1),
	host_button = UIWidgets.create_default_checkbox_button("host_button", var_0_14.host_button.size, Localize("start_game_window_other_options_always_host"), 24, {
		title = Localize("start_game_window_other_options_always_host"),
		description = Localize("start_game_window_other_options_always_host_description")
	}, nil, "menu_frame_03_morris"),
	strict_matchmaking_frame = UIWidgets.create_frame("strict_matchmaking_button_frame", var_0_14.strict_matchmaking_button_frame.size, var_0_52, 1),
	strict_matchmaking_button = UIWidgets.create_default_checkbox_button("strict_matchmaking_button", var_0_14.strict_matchmaking_button.size, Localize("start_game_window_other_options_strict_matchmaking"), 24, {
		title = Localize("start_game_window_other_options_strict_matchmaking"),
		description = Localize("start_game_window_other_options_strict_matchmaking_description")
	}, nil, "menu_frame_03_morris")
}
local var_0_54 = "menu_frame_01_morris"
local var_0_55 = {
	game_option_1 = var_0_20("game_option_1", var_0_14.game_option_1.size, Localize("cw_weekly_expedition_name_long"), nil, true),
	journey_name = UIWidgets.create_simple_text("n/a", "journey_name", nil, nil, var_0_35),
	journey_theme = var_0_27("journey_theme"),
	mask = UIWidgets.create_simple_texture("mask_rect", "game_option_deus_weekly", nil, nil, {
		255,
		255,
		255,
		255
	}),
	deus_weekly_event_frame = UIWidgets.create_background_with_frame("game_option_deus_weekly_event", var_0_14.game_option_deus_weekly_event.size, "vote_switch_mechanism_morris_background", "menu_frame_08", true, {
		255,
		50,
		50,
		50
	})
}
local var_0_56 = {
	reward_presentation = var_0_24("versus_reward_presentation", var_0_14.versus_reward_presentation.size)
}
local var_0_57 = {
	game_option_1 = var_0_18("game_option_1", var_0_14.game_option_1.size, Localize("start_game_window_mission"), nil, "game_options_bg_01"),
	game_option_2 = var_0_18("game_option_2", var_0_14.game_option_2.size, Localize("start_game_window_difficulty"), "difficulty_option_1", "game_options_bg_02"),
	additional_option = var_0_22("additional_option", var_0_14.additional_option.size, Localize("start_game_window_other_options_title"), "game_options_bg_03"),
	player_hosted_frame = UIWidgets.create_frame("strict_matchmaking_button_frame", var_0_14.strict_matchmaking_button_frame.size, var_0_1, 1),
	player_hosted_button = UIWidgets.create_default_checkbox_button("strict_matchmaking_button", var_0_14.strict_matchmaking_button.size, Localize("player_hosted_title"), 24, {
		title = Localize("player_hosted_title"),
		description = Localize("player_hosted_desc")
	}),
	dedicated_server_win_frame = UIWidgets.create_frame("host_button_frame", var_0_14.host_button_frame.size, var_0_1, 1),
	dedicated_server_win_button = UIWidgets.create_default_checkbox_button("host_button", var_0_14.host_button.size, Localize("dedicated_server_win_title"), 24, {
		title = Localize("dedicated_server_win_title"),
		description = Localize("dedicated_server_win_desc")
	}),
	dedicated_server_aws_frame = UIWidgets.create_frame("private_button_frame", var_0_14.private_button_frame.size, var_0_1, 1),
	dedicated_server_aws_button = UIWidgets.create_default_checkbox_button("private_button", var_0_14.private_button.size, Localize("dedicated_server_aws_title"), 24, {
		title = Localize("dedicated_server_aws_title"),
		description = Localize("dedicated_server_aws_desc")
	})
}
local var_0_58 = {
	twitch_disclaimer = create_twitch_disclaimer,
	twitch_mode = create_twitch_mode
}
local var_0_59 = {
	default = {},
	default_voting = {
		actions = {
			{
				input_action = "confirm",
				priority = 1,
				description_text = "menu_accept"
			},
			{
				input_action = "back",
				priority = 2,
				description_text = "dlc1_3_1_decline"
			}
		}
	}
}

return {
	generic_input_actions = var_0_59,
	scenegraph_definition = var_0_14,
	adventure_game_widgets = var_0_43,
	game_mode_widgets = var_0_44,
	custom_game_widgets = var_0_47,
	deed_game_widgets = var_0_48,
	event_game_widgets = var_0_49,
	weave_game_widgets = var_0_50,
	deus_quickplay_widget = var_0_51,
	deus_custom_widget = var_0_53,
	weave_quickplay_widgets = var_0_46,
	twitch_mode_widget_funcs = var_0_58,
	switch_mechanism_widgets = var_0_45,
	versus_quickplay_widgets = var_0_56,
	versus_custom_widgets = var_0_57,
	widgets = var_0_37,
	widgets_deus = var_0_38,
	deus_weekly_event_create_header = var_0_16,
	deus_weekly_event_create_entry_widget = var_0_17,
	deus_weekly_event_widgets = var_0_55
}
