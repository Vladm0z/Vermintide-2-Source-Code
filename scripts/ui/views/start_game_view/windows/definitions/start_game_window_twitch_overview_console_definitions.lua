-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_twitch_overview_console_definitions.lua

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
	var_0_5 - 20 - 160,
	50
}
local var_0_7 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
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
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				arg_5_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}
local var_0_8 = {
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
		size = {
			var_0_2[1],
			var_0_2[2] + 100
		},
		position = {
			220,
			-50,
			1
		}
	},
	window_game_mode_root = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1],
			var_0_3
		},
		position = {
			0,
			-var_0_3,
			1
		}
	},
	login_text_area = {
		vertical_alignment = "bottom",
		parent = "twitch_divider",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			50
		},
		position = {
			0,
			-60,
			1
		}
	},
	login_text_frame = {
		vertical_alignment = "center",
		parent = "login_text_area",
		horizontal_alignment = "left",
		size = var_0_6,
		position = {
			10,
			0,
			1
		}
	},
	login_text_box = {
		vertical_alignment = "center",
		parent = "login_text_frame",
		horizontal_alignment = "center",
		size = {
			300,
			42
		},
		position = {
			0,
			0,
			1
		}
	},
	twitch_background = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] + 70,
			330
		},
		position = {
			0,
			0,
			1
		}
	},
	twitch_texture = {
		vertical_alignment = "top",
		parent = "twitch_background",
		horizontal_alignment = "center",
		size = {
			294,
			98
		},
		position = {
			0,
			-23,
			1
		}
	},
	twitch_divider = {
		vertical_alignment = "bottom",
		parent = "twitch_texture",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-36,
			1
		}
	},
	twitch_description = {
		vertical_alignment = "bottom",
		parent = "login_text_area",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			100
		},
		position = {
			0,
			-125,
			1
		}
	},
	client_disclaimer_background = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] + 70,
			150
		},
		position = {
			0,
			-380,
			1
		}
	},
	client_disclaimer_description = {
		vertical_alignment = "center",
		parent = "client_disclaimer_background",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			100
		},
		position = {
			0,
			0,
			1
		}
	},
	game_option_3 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2]
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
			var_0_4[1],
			var_0_4[2]
		},
		position = {
			-15,
			-15 + var_0_4[2],
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
			-15 + var_0_4[2] * 2,
			1
		}
	},
	play_button_console = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2]
		},
		position = {
			0,
			30,
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
	},
	selector = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2] + 22
		},
		position = {
			0,
			0,
			1
		}
	},
	connecting = {
		vertical_alignment = "center",
		parent = "login_text_area",
		horizontal_alignment = "center",
		size = var_0_6,
		position = {
			0,
			0,
			1
		}
	},
	connect_button = {
		vertical_alignment = "center",
		parent = "login_text_area",
		horizontal_alignment = "right",
		size = {
			160,
			45
		},
		position = {
			-10,
			-2,
			1
		}
	},
	connect_button_frame = {
		vertical_alignment = "center",
		parent = "connect_button",
		horizontal_alignment = "center",
		size = {
			160,
			50
		},
		position = {
			0,
			2,
			10
		}
	},
	disconnect_button = {
		vertical_alignment = "center",
		parent = "login_text_area",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] - 20,
			45
		},
		position = {
			0,
			-2,
			1
		}
	},
	disconnect_button_frame = {
		vertical_alignment = "center",
		parent = "disconnect_button",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] - 20,
			50
		},
		position = {
			0,
			2,
			10
		}
	},
	chat_feed_area_mask = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "right",
		size = {
			700,
			var_0_2[2]
		},
		position = {
			-220,
			0,
			0
		}
	},
	chat_feed_area = {
		vertical_alignment = "bottom",
		parent = "chat_feed_area_mask",
		horizontal_alignment = "right",
		size = {
			700,
			var_0_2[2]
		},
		position = {
			10,
			0,
			1
		}
	},
	chat_text_box = {
		vertical_alignment = "bottom",
		parent = "chat_feed_area",
		horizontal_alignment = "right",
		size = {
			700,
			var_0_2[2]
		}
	}
}

if IS_XB1 then
	var_0_8.connect_button = {
		vertical_alignment = "center",
		parent = "login_text_area",
		horizontal_alignment = "right",
		size = {
			160,
			45
		},
		position = {
			-10,
			-2,
			1
		}
	}
	var_0_8.connect_button_frame = {
		vertical_alignment = "center",
		parent = "connect_button",
		horizontal_alignment = "center",
		size = {
			160,
			50
		},
		position = {
			0,
			2,
			10
		}
	}
end

function create_button(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = "button_bg_01"
	local var_7_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_7_0)
	local var_7_2 = {
		element = {}
	}
	local var_7_3 = {}
	local var_7_4 = {}
	local var_7_5 = {}
	local var_7_6 = {
		0,
		0,
		0
	}
	local var_7_7 = "button_hotspot"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "hotspot",
		content_id = var_7_7,
		style_id = var_7_7,
		content_check_function = arg_7_4
	}
	var_7_5[var_7_7] = {
		size = arg_7_1,
		offset = var_7_6
	}
	var_7_4[var_7_7] = {}

	local var_7_8 = var_7_4[var_7_7]
	local var_7_9 = "background"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "texture_uv",
		content_id = var_7_9,
		style_id = var_7_9,
		content_check_function = arg_7_4
	}
	var_7_5[var_7_9] = {
		size = arg_7_1,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_7_6[1],
			var_7_6[2],
			0
		}
	}
	var_7_4[var_7_9] = {
		uvs = {
			{
				0,
				1 - math.min(arg_7_1[2] / var_7_1.size[2], 1)
			},
			{
				math.min(arg_7_1[1] / var_7_1.size[1], 1),
				1
			}
		},
		texture_id = var_7_0
	}

	local var_7_10 = "background_fade"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "texture",
		content_id = var_7_7,
		texture_id = var_7_10,
		style_id = var_7_10,
		content_check_function = arg_7_4
	}
	var_7_5[var_7_10] = {
		size = {
			arg_7_1[1],
			arg_7_1[2]
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_7_6[1],
			var_7_6[2],
			1
		}
	}
	var_7_8[var_7_10] = "button_bg_fade"

	local var_7_11 = "hover_glow"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "texture",
		content_id = var_7_7,
		texture_id = var_7_11,
		style_id = var_7_11,
		content_check_function = arg_7_4
	}
	var_7_5[var_7_11] = {
		size = {
			arg_7_1[1],
			math.min(arg_7_1[2] - 5, 80)
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_7_6[1],
			var_7_6[2] + 5,
			2
		}
	}
	var_7_8[var_7_11] = "button_state_default"

	local var_7_12 = "clicked_rect"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "rect",
		content_id = var_7_7,
		style_id = var_7_12,
		content_check_function = arg_7_4
	}
	var_7_5[var_7_12] = {
		size = arg_7_1,
		color = {
			100,
			0,
			0,
			0
		},
		offset = {
			var_7_6[1],
			var_7_6[2],
			6
		}
	}

	local var_7_13 = "glass_top"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "texture",
		content_id = var_7_7,
		texture_id = var_7_13,
		style_id = var_7_13,
		content_check_function = arg_7_4
	}
	var_7_5[var_7_13] = {
		size = {
			arg_7_1[1],
			11
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_7_6[1],
			var_7_6[2] + arg_7_1[2] - 11,
			5
		}
	}
	var_7_8[var_7_13] = "button_glass_02"

	local var_7_14 = "glass_bottom"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "texture",
		content_id = var_7_7,
		texture_id = var_7_14,
		style_id = var_7_14,
		content_check_function = arg_7_4
	}
	var_7_5[var_7_14] = {
		size = {
			arg_7_1[1],
			11
		},
		color = {
			100,
			255,
			255,
			255
		},
		offset = {
			var_7_6[1],
			var_7_6[2] - 3,
			5
		}
	}
	var_7_8[var_7_14] = "button_glass_02"

	local var_7_15 = "text"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "text",
		content_id = var_7_7,
		text_id = var_7_15,
		style_id = var_7_15,
		content_check_function = arg_7_4
	}
	var_7_5[var_7_15] = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_type = "hell_shark",
		font_size = arg_7_3,
		text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		select_text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			10 + var_7_6[1],
			var_7_6[2] + 3,
			4
		},
		size = {
			arg_7_1[1] - 20,
			arg_7_1[2]
		}
	}
	var_7_8[var_7_15] = arg_7_2

	local var_7_16 = "text_shadow"

	var_7_3[#var_7_3 + 1] = {
		pass_type = "text",
		content_id = var_7_7,
		text_id = var_7_15,
		style_id = var_7_16,
		content_check_function = arg_7_4
	}
	var_7_5[var_7_16] = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_type = "hell_shark",
		font_size = arg_7_3,
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			10 + var_7_6[1] + 2,
			var_7_6[2] + 2,
			3
		},
		size = {
			arg_7_1[1] - 20,
			arg_7_1[2]
		}
	}
	var_7_2.element.passes = var_7_3
	var_7_2.content = var_7_4
	var_7_2.style = var_7_5
	var_7_2.offset = {
		0,
		0,
		0
	}
	var_7_2.scenegraph_id = arg_7_0

	return var_7_2
end

local var_0_9 = {
	scenegraph_id = "chat_feed_area",
	element = {
		passes = {
			{
				style_id = "chat_text_box",
				pass_type = "text_area_chat",
				text_id = "text_field",
				content_check_function = function (arg_8_0)
					return Managers.twitch:is_connected()
				end
			}
		}
	},
	content = {
		mask_id = "mask_rect",
		text_start_offset = 0,
		message_tables = {}
	},
	style = {
		chat_text_box = {
			word_wrap = true,
			font_size = 18,
			spacing = 0,
			pixel_perfect = false,
			vertical_alignment = "top",
			dynamic_font = true,
			font_type = "chat_output_font_masked",
			text_color = Colors.get_table("white"),
			name_color = Colors.get_table("sky_blue"),
			name_color_dev = Colors.get_table("cheeseburger"),
			name_color_system = Colors.get_table("gold"),
			offset = {
				0,
				-10,
				10
			}
		}
	},
	offset = {
		0,
		0,
		0
	}
}

local function var_0_10(arg_9_0, arg_9_1)
	local var_9_0 = {
		element = {}
	}
	local var_9_1 = {
		{
			scenegraph_id = "login_text_box",
			pass_type = "hotspot",
			content_id = "text_input_hotspot"
		},
		{
			scenegraph_id = "root_fit",
			pass_type = "hotspot",
			content_id = "screen_hotspot"
		},
		{
			scenegraph_id = "window",
			pass_type = "hotspot",
			content_id = "frame_hotspot"
		},
		{
			style_id = "login_rect_bg",
			pass_type = "rect",
			content_check_function = function (arg_10_0, arg_10_1)
				return not Managers.twitch:is_connected() and not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "login_hint",
			pass_type = "text",
			text_id = "login_hint",
			content_check_function = function (arg_11_0, arg_11_1)
				if arg_11_0.text_input_hotspot.is_hover then
					arg_11_1.text_color = {
						128,
						255,
						255,
						255
					}
				else
					arg_11_1.text_color = {
						60,
						255,
						255,
						255
					}
				end

				return arg_11_0.twitch_name == "" and not Managers.twitch:is_connected() and not arg_11_0.text_field_active and not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "twitch_name",
			pass_type = "text",
			text_id = "twitch_name",
			content_check_function = function (arg_12_0, arg_12_1)
				if not arg_12_0.text_field_active then
					arg_12_1.caret_color[1] = 0
				else
					arg_12_1.caret_color[1] = 128 + math.sin(Managers.time:time("ui") * 5) * 128
				end

				return not Managers.twitch:is_connected() and not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "connecting",
			pass_type = "text",
			text_id = "connecting_id",
			content_check_function = function (arg_13_0, arg_13_1)
				if not Managers.twitch:is_connecting() then
					return
				end

				local var_13_0 = 10 * Managers.time:time("ui")
				local var_13_1 = string.rep(".", var_13_0 % 5)

				arg_13_0.connecting_id = Localize("start_game_window_twitch_connecting") .. var_13_1

				return true
			end
		}
	}
	local var_9_2 = {
		text_start_offset = 0,
		text_field_active = false,
		connecting_id = "Connecting",
		error_id = "",
		twitch_name = "",
		caret_index = 1,
		text_index = 1,
		login_hint = Localize("start_game_window_twitch_login_hint"),
		text_input_hotspot = {},
		screen_hotspot = {
			allow_multi_hover = true
		},
		frame_hotspot = {
			allow_multi_hover = true
		}
	}
	local var_9_3 = {
		login_rect_bg = {
			scenegraph_id = "login_text_frame",
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				-1
			},
			size = var_0_6
		},
		login_hint = {
			word_wrap = true,
			scenegraph_id = "login_text_box",
			font_size = 24,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = {
				60,
				255,
				255,
				255
			},
			offset = {
				5,
				0,
				10
			},
			size = {
				290,
				42
			}
		},
		connecting = {
			word_wrap = false,
			scenegraph_id = "connecting",
			font_size = 24,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = {
				90,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				10
			}
		},
		twitch_name = {
			word_wrap = false,
			scenegraph_id = "login_text_box",
			horizontal_scroll = true,
			pixel_perfect = true,
			horizontal_alignment = "left",
			font_size = 28,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("white"),
			offset = {
				10,
				10,
				10
			},
			caret_size = {
				2,
				26
			},
			caret_offset = {
				0,
				-4,
				4
			},
			caret_color = Colors.get_table("white")
		}
	}

	var_9_0.element.passes = var_9_1
	var_9_0.content = var_9_2
	var_9_0.style = var_9_3
	var_9_0.offset = {
		0,
		0,
		0
	}
	var_9_0.scenegraph_id = arg_9_0

	return var_9_0
end

function create_twitch_rect_with_outer_frame(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	arg_14_4 = arg_14_4 or {
		255,
		255,
		255,
		255
	}

	local var_14_0 = arg_14_2 and UIFrameSettings[arg_14_2] or UIFrameSettings.frame_outer_fade_02
	local var_14_1 = var_14_0.texture_sizes.horizontal[2]
	local var_14_2 = {
		arg_14_1[1] + var_14_1 * 2,
		arg_14_1[2] + var_14_1 * 2
	}
	local var_14_3 = {
		element = {}
	}
	local var_14_4 = {
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame",
			content_check_function = function (arg_15_0, arg_15_1)
				return Managers.twitch:is_connected()
			end
		},
		{
			style_id = "rect",
			pass_type = "rect",
			content_check_function = function (arg_16_0, arg_16_1)
				return Managers.twitch:is_connected()
			end
		}
	}
	local var_14_5 = {
		frame = var_14_0.texture
	}
	local var_14_6 = {
		frame = {
			color = arg_14_5 or arg_14_4,
			size = var_14_2,
			texture_size = var_14_0.texture_size,
			texture_sizes = var_14_0.texture_sizes,
			offset = {
				-var_14_1,
				-var_14_1,
				arg_14_3 or 0
			}
		},
		rect = {
			color = arg_14_4,
			offset = {
				0,
				0,
				arg_14_3 or 0
			}
		}
	}

	var_14_3.element.passes = var_14_4
	var_14_3.content = var_14_5
	var_14_3.style = var_14_6
	var_14_3.offset = {
		0,
		0,
		0
	}
	var_14_3.scenegraph_id = arg_14_0

	return var_14_3
end

local var_0_11 = {
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
local var_0_12 = {
	font_size = 28,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		2
	}
}

local function var_0_13(arg_17_0)
	return not Managers.twitch:is_connecting() and not Managers.twitch:is_connected() and not Managers.input:is_device_active("gamepad")
end

local function var_0_14(arg_18_0)
	return not Managers.twitch:is_connecting() and Managers.twitch:is_connected() and not Managers.input:is_device_active("gamepad")
end

local var_0_15 = "start_game_window_twitch_connect_description"
local var_0_16 = "start_game_window_twitch_client_disclaimer_description"
local var_0_17 = {
	mission_setting = UIWidgets.create_start_game_console_setting_button("game_option_1", Localize("start_game_window_mission"), nil, nil, nil, var_0_8.game_option_1.size),
	difficulty_setting = UIWidgets.create_start_game_console_setting_button("game_option_2", Localize("start_game_window_difficulty"), nil, "difficulty_option_1", nil, var_0_8.game_option_2.size, true),
	play_button = UIWidgets.create_icon_and_name_button("play_button", "options_button_icon_quickplay", Localize("start_game_window_play"))
}
local var_0_18 = {
	client_disclaimer_background = UIWidgets.create_rect_with_outer_frame("client_disclaimer_background", var_0_8.client_disclaimer_background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	client_disclaimer_description = UIWidgets.create_simple_text(Localize(var_0_16), "client_disclaimer_description", nil, nil, var_0_12)
}
local var_0_19 = {
	twitch_description_background = UIWidgets.create_rect_with_outer_frame("twitch_background", var_0_8.twitch_background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	twitch_texture = UIWidgets.create_simple_texture("twitch_logo", "twitch_texture"),
	twitch_divider = UIWidgets.create_simple_texture("divider_01_top", "twitch_divider"),
	twitch_description = UIWidgets.create_simple_text(Localize(var_0_15), "twitch_description", nil, nil, var_0_11),
	button_1 = create_button("connect_button", var_0_8.connect_button.size, Localize("start_game_window_twitch_connect"), 24, var_0_13),
	button_2 = create_button("disconnect_button", var_0_8.disconnect_button.size, string.format(Localize("start_game_window_twitch_disconnect"), "N/A"), 24, var_0_14),
	connect_button_frame = UIWidgets.create_frame("connect_button_frame", var_0_8.connect_button_frame.size, var_0_1, 1),
	disconnect_button_frame = UIWidgets.create_frame("disconnect_button_frame", var_0_8.disconnect_button_frame.size, var_0_1, 1),
	login_text_frame = UIWidgets.create_frame("login_text_frame", {
		var_0_5,
		50
	}, "menu_frame_09", 1),
	frame_widget = var_0_10("twitch_background", var_0_8.twitch_background.size),
	chat_output_widget = var_0_9,
	chat_mask = UIWidgets.create_simple_texture("mask_rect", "chat_feed_area_mask"),
	chat_output_background = create_twitch_rect_with_outer_frame("chat_feed_area_mask", var_0_8.chat_feed_area_mask.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color)
}

var_0_19.login_text_frame.element.passes[1].content_check_function = var_0_13
var_0_19.connect_button_frame.element.passes[1].content_check_function = var_0_13
var_0_19.disconnect_button_frame.element.passes[1].content_check_function = var_0_14

local var_0_20 = {}
local var_0_21 = {
	"mission_setting",
	"difficulty_setting",
	"play_button"
}

return {
	scenegraph_definition = var_0_8,
	widgets = var_0_19,
	play_widgets = var_0_17,
	client_widgets = var_0_18,
	additional_settings_widgets = var_0_20,
	animation_definitions = var_0_7,
	selector_input_definition = var_0_21,
	twitch_keyboard_anchor_point = {
		230,
		350
	}
}
