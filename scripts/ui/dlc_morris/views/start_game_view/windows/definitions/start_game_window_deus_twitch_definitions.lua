-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_twitch_definitions.lua

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
	width = 72,
	spacing_x = 40
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
	level_root_node = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			285,
			40,
			10
		}
	},
	brush_stroke = {
		vertical_alignment = "center",
		parent = "level_root_node",
		horizontal_alignment = "left",
		size = {
			700,
			100
		},
		position = {
			-390,
			-10,
			0
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
		parent = "twitch_background",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			50
		},
		position = {
			0,
			70,
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
			280
		},
		position = {
			0,
			-75,
			1
		}
	},
	twitch_texture = {
		vertical_alignment = "top",
		parent = "twitch_background",
		horizontal_alignment = "center",
		size = {
			130,
			29
		},
		position = {
			0,
			45,
			2
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
			60,
			1
		}
	},
	difficulty_stepper = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2] + 22
		},
		position = {
			0,
			165,
			1
		}
	},
	difficulty_info = {
		vertical_alignment = "bottom",
		parent = "difficulty_stepper",
		horizontal_alignment = "center",
		size = {
			500,
			200
		},
		position = {
			500,
			0,
			1
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
			10
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
			11
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
			10
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
			11
		}
	},
	chat_feed_area_mask = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "right",
		size = {
			600,
			var_0_2[2] - 220
		},
		position = {
			0,
			-145,
			0
		}
	},
	chat_feed_area = {
		vertical_alignment = "bottom",
		parent = "chat_feed_area_mask",
		horizontal_alignment = "right",
		size = {
			600,
			var_0_2[2] - 220
		},
		position = {
			10,
			-120,
			1
		}
	},
	chat_text_box = {
		vertical_alignment = "bottom",
		parent = "chat_feed_area",
		horizontal_alignment = "right",
		size = {
			600,
			var_0_2[2] - 220
		}
	}
}

if IS_XB1 then
	var_0_8.connect_button = {
		vertical_alignment = "center",
		parent = "login_text_area",
		horizontal_alignment = "center",
		size = {
			160,
			45
		},
		position = {
			0,
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

function create_button(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = "button_bg_01"
	local var_1_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_0)
	local var_1_2 = {
		element = {}
	}
	local var_1_3 = {}
	local var_1_4 = {}
	local var_1_5 = {}
	local var_1_6 = {
		0,
		0,
		0
	}
	local var_1_7 = "button_hotspot"

	var_1_3[#var_1_3 + 1] = {
		pass_type = "hotspot",
		content_id = var_1_7,
		style_id = var_1_7,
		content_check_function = arg_1_4
	}
	var_1_5[var_1_7] = {
		size = arg_1_1,
		offset = var_1_6
	}
	var_1_4[var_1_7] = {}

	local var_1_8 = var_1_4[var_1_7]
	local var_1_9 = "background"

	var_1_3[#var_1_3 + 1] = {
		pass_type = "texture_uv",
		content_id = var_1_9,
		style_id = var_1_9,
		content_check_function = arg_1_4
	}
	var_1_5[var_1_9] = {
		size = arg_1_1,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_1_6[1],
			var_1_6[2],
			0
		}
	}
	var_1_4[var_1_9] = {
		uvs = {
			{
				0,
				1 - math.min(arg_1_1[2] / var_1_1.size[2], 1)
			},
			{
				math.min(arg_1_1[1] / var_1_1.size[1], 1),
				1
			}
		},
		texture_id = var_1_0
	}

	local var_1_10 = "background_fade"

	var_1_3[#var_1_3 + 1] = {
		pass_type = "texture",
		content_id = var_1_7,
		texture_id = var_1_10,
		style_id = var_1_10,
		content_check_function = arg_1_4
	}
	var_1_5[var_1_10] = {
		size = {
			arg_1_1[1],
			arg_1_1[2]
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_1_6[1],
			var_1_6[2],
			1
		}
	}
	var_1_8[var_1_10] = "button_bg_fade"

	local var_1_11 = "hover_glow"

	var_1_3[#var_1_3 + 1] = {
		pass_type = "texture",
		content_id = var_1_7,
		texture_id = var_1_11,
		style_id = var_1_11,
		content_check_function = arg_1_4
	}
	var_1_5[var_1_11] = {
		size = {
			arg_1_1[1],
			math.min(arg_1_1[2] - 5, 80)
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_1_6[1],
			var_1_6[2] + 5,
			2
		}
	}
	var_1_8[var_1_11] = "button_state_default"

	local var_1_12 = "clicked_rect"

	var_1_3[#var_1_3 + 1] = {
		pass_type = "rect",
		content_id = var_1_7,
		style_id = var_1_12,
		content_check_function = arg_1_4
	}
	var_1_5[var_1_12] = {
		size = arg_1_1,
		color = {
			100,
			0,
			0,
			0
		},
		offset = {
			var_1_6[1],
			var_1_6[2],
			6
		}
	}

	local var_1_13 = "glass_top"

	var_1_3[#var_1_3 + 1] = {
		pass_type = "texture",
		content_id = var_1_7,
		texture_id = var_1_13,
		style_id = var_1_13,
		content_check_function = arg_1_4
	}
	var_1_5[var_1_13] = {
		size = {
			arg_1_1[1],
			11
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_1_6[1],
			var_1_6[2] + arg_1_1[2] - 11,
			5
		}
	}
	var_1_8[var_1_13] = "button_glass_02"

	local var_1_14 = "glass_bottom"

	var_1_3[#var_1_3 + 1] = {
		pass_type = "texture",
		content_id = var_1_7,
		texture_id = var_1_14,
		style_id = var_1_14,
		content_check_function = arg_1_4
	}
	var_1_5[var_1_14] = {
		size = {
			arg_1_1[1],
			11
		},
		color = {
			100,
			255,
			255,
			255
		},
		offset = {
			var_1_6[1],
			var_1_6[2] - 3,
			5
		}
	}
	var_1_8[var_1_14] = "button_glass_02"

	local var_1_15 = "text"

	var_1_3[#var_1_3 + 1] = {
		pass_type = "text",
		content_id = var_1_7,
		text_id = var_1_15,
		style_id = var_1_15,
		content_check_function = arg_1_4
	}
	var_1_5[var_1_15] = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_type = "hell_shark",
		font_size = arg_1_3,
		text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		select_text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			10 + var_1_6[1],
			var_1_6[2] + 3,
			4
		},
		size = {
			arg_1_1[1] - 20,
			arg_1_1[2]
		}
	}
	var_1_8[var_1_15] = arg_1_2

	local var_1_16 = "text_shadow"

	var_1_3[#var_1_3 + 1] = {
		pass_type = "text",
		content_id = var_1_7,
		text_id = var_1_15,
		style_id = var_1_16,
		content_check_function = arg_1_4
	}
	var_1_5[var_1_16] = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_type = "hell_shark",
		font_size = arg_1_3,
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			10 + var_1_6[1] + 2,
			var_1_6[2] + 2,
			3
		},
		size = {
			arg_1_1[1] - 20,
			arg_1_1[2]
		}
	}
	var_1_2.element.passes = var_1_3
	var_1_2.content = var_1_4
	var_1_2.style = var_1_5
	var_1_2.offset = {
		0,
		0,
		0
	}
	var_1_2.scenegraph_id = arg_1_0

	return var_1_2
end

local var_0_9 = {
	scenegraph_id = "chat_feed_area",
	element = {
		passes = {
			{
				style_id = "chat_text_box",
				pass_type = "text_area_chat",
				text_id = "text_field",
				content_check_function = function(arg_2_0)
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
				45,
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

local function var_0_10(arg_3_0, arg_3_1)
	local var_3_0 = {
		element = {}
	}
	local var_3_1 = {
		{
			scenegraph_id = "login_text_box",
			pass_type = "hotspot",
			content_id = "text_input_hotspot"
		},
		{
			scenegraph_id = "window",
			pass_type = "hotspot",
			content_id = "frame_hotspot"
		},
		{
			scenegraph_id = "menu_root",
			pass_type = "hotspot",
			content_id = "screen_hotspot"
		},
		{
			style_id = "login_rect_bg",
			pass_type = "rect",
			content_check_function = function(arg_4_0, arg_4_1)
				return not Managers.twitch:is_connected() and not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "login_hint",
			pass_type = "text",
			text_id = "login_hint",
			content_check_function = function(arg_5_0, arg_5_1)
				if arg_5_0.text_input_hotspot.is_hover then
					arg_5_1.text_color = {
						128,
						255,
						255,
						255
					}
				else
					arg_5_1.text_color = {
						60,
						255,
						255,
						255
					}
				end

				return arg_5_0.twitch_name == "" and not Managers.twitch:is_connected() and not arg_5_0.text_field_active and not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "twitch_name",
			pass_type = "text",
			text_id = "twitch_name",
			content_check_function = function(arg_6_0, arg_6_1)
				if not arg_6_0.text_field_active then
					arg_6_1.caret_color[1] = 0
				else
					arg_6_1.caret_color[1] = 128 + math.sin(Managers.time:time("ui") * 5) * 128
				end

				return not Managers.twitch:is_connected() and not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "connecting",
			pass_type = "text",
			text_id = "connecting_id",
			content_check_function = function(arg_7_0, arg_7_1)
				if not Managers.twitch:is_connecting() then
					return
				end

				local var_7_0 = 10 * Managers.time:time("ui")
				local var_7_1 = string.rep(".", var_7_0 % 5)

				arg_7_0.connecting_id = Localize("start_game_window_twitch_connecting") .. var_7_1

				return true
			end
		}
	}
	local var_3_2 = {
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
	local var_3_3 = {
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

	var_3_0.element.passes = var_3_1
	var_3_0.content = var_3_2
	var_3_0.style = var_3_3
	var_3_0.offset = {
		0,
		0,
		0
	}
	var_3_0.scenegraph_id = arg_3_0

	return var_3_0
end

function create_twitch_rect_with_outer_frame(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	arg_8_4 = arg_8_4 or {
		255,
		255,
		255,
		255
	}

	local var_8_0 = arg_8_2 and UIFrameSettings[arg_8_2] or UIFrameSettings.frame_outer_fade_02
	local var_8_1 = var_8_0.texture_sizes.horizontal[2]
	local var_8_2 = {
		arg_8_1[1] + var_8_1 * 2,
		arg_8_1[2] + var_8_1 * 2
	}
	local var_8_3 = {
		element = {}
	}
	local var_8_4 = {
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame",
			content_check_function = function(arg_9_0, arg_9_1)
				return Managers.twitch:is_connected()
			end
		},
		{
			style_id = "rect",
			pass_type = "rect",
			content_check_function = function(arg_10_0, arg_10_1)
				return Managers.twitch:is_connected()
			end
		}
	}
	local var_8_5 = {
		frame = var_8_0.texture
	}
	local var_8_6 = {
		frame = {
			color = arg_8_5 or arg_8_4,
			size = var_8_2,
			texture_size = var_8_0.texture_size,
			texture_sizes = var_8_0.texture_sizes,
			offset = {
				-var_8_1,
				-var_8_1,
				arg_8_3 or 0
			}
		},
		rect = {
			color = arg_8_4,
			offset = {
				0,
				0,
				arg_8_3 or 0
			}
		}
	}

	var_8_3.element.passes = var_8_4
	var_8_3.content = var_8_5
	var_8_3.style = var_8_6
	var_8_3.offset = {
		0,
		0,
		0
	}
	var_8_3.scenegraph_id = arg_8_0

	return var_8_3
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
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		2
	}
}

local function var_0_12(arg_11_0)
	return not Managers.twitch:is_connecting() and not Managers.twitch:is_connected() and not Managers.input:is_device_active("gamepad")
end

local function var_0_13(arg_12_0)
	return not Managers.twitch:is_connecting() and Managers.twitch:is_connected() and not Managers.input:is_device_active("gamepad")
end

local var_0_14 = string.gsub(Localize("start_game_window_deus_twitch_desc"), Localize("expedition_highlight_text"), "{#color(255,168,0)}" .. Localize("expedition_highlight_text") .. "{#reset()}")
local var_0_15 = "start_game_window_twitch_client_disclaimer_description"
local var_0_16 = true
local var_0_17 = {
	difficulty_stepper = UIWidgets.create_start_game_difficulty_stepper("difficulty_stepper", Localize("start_game_window_difficulty"), "difficulty_option_1"),
	play_button = UIWidgets.create_start_game_deus_play_button("play_button", var_0_8.play_button.size, Localize("start_game_window_play"), 34, var_0_16)
}
local var_0_18 = {
	client_disclaimer_background = UIWidgets.create_rect_with_outer_frame("client_disclaimer_background", var_0_8.client_disclaimer_background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	client_disclaimer_description = UIWidgets.create_simple_text(Localize(var_0_15), "client_disclaimer_description", nil, nil, var_0_11)
}
local var_0_19 = {
	brush_stroke = UIWidgets.create_simple_texture("brush_stroke", "brush_stroke")
}
local var_0_20 = {
	twitch_texture = UIWidgets.create_simple_texture("twitch_logo_new", "twitch_texture"),
	twitch_gamemode_info_box = UIWidgets.create_start_game_deus_gamemode_info_box("twitch_background", var_0_8.twitch_background.size, nil, var_0_14, true),
	button_1 = create_button("connect_button", var_0_8.connect_button.size, Localize("start_game_window_twitch_connect"), 24, var_0_12),
	button_2 = create_button("disconnect_button", var_0_8.disconnect_button.size, string.format(Localize("start_game_window_twitch_disconnect"), "N/A"), 24, var_0_13),
	connect_button_frame = UIWidgets.create_frame("connect_button_frame", var_0_8.connect_button_frame.size, var_0_1, 1),
	disconnect_button_frame = UIWidgets.create_frame("disconnect_button_frame", var_0_8.disconnect_button_frame.size, var_0_1, 1),
	login_text_frame = UIWidgets.create_frame("login_text_frame", {
		var_0_5,
		50
	}, "menu_frame_09", 1),
	frame_widget = var_0_10("twitch_background", var_0_8.twitch_background.size),
	difficulty_info = UIWidgets.create_start_game_deus_difficulty_info_box("difficulty_info", var_0_8.difficulty_info.size),
	upsell_button = UIWidgets.create_simple_two_state_button("upsell_button", "icon_redirect", "icon_redirect_hover"),
	chat_output_widget = var_0_9,
	chat_mask = UIWidgets.create_simple_texture("mask_rect", "chat_feed_area_mask"),
	chat_output_background = create_twitch_rect_with_outer_frame("chat_feed_area_mask", var_0_8.chat_feed_area_mask.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color)
}

var_0_20.login_text_frame.element.passes[1].content_check_function = var_0_12
var_0_20.connect_button_frame.element.passes[1].content_check_function = var_0_12
var_0_20.disconnect_button_frame.element.passes[1].content_check_function = var_0_13

local var_0_21 = {}
local var_0_22 = {
	{
		enter_requirements = function(arg_13_0)
			return arg_13_0._is_server
		end,
		on_enter = function(arg_14_0, arg_14_1, arg_14_2)
			arg_14_0._expedition_level_index = 1

			local var_14_0 = arg_14_0._expedition_widgets

			for iter_14_0 = 1, #var_14_0 do
				var_14_0[iter_14_0].content.gamepad_selected = false
			end

			var_14_0[arg_14_0._expedition_level_index].content.gamepad_selected = true
		end,
		update = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
			local var_15_0 = arg_15_0._expedition_widgets
			local var_15_1 = arg_15_0._expedition_level_index

			if arg_15_1:get("move_left") then
				var_15_1 = math.max(var_15_1 - 1, 1)
			elseif arg_15_1:get("move_right") then
				var_15_1 = math.min(var_15_1 + 1, #var_15_0)
			elseif arg_15_1:get("confirm_press") then
				if arg_15_0._expeditions_selection_index then
					arg_15_0._expedition_widgets[arg_15_0._expeditions_selection_index].content.button_hotspot.is_selected = nil
				end

				local var_15_2 = arg_15_0._expedition_widgets[var_15_1]

				var_15_2.content.button_hotspot.is_selected = true

				local var_15_3 = var_15_2.content.journey_name

				arg_15_0._parent:set_selected_level_id(var_15_3)

				arg_15_0._expeditions_selection_index = var_15_1

				arg_15_0:_play_sound("play_gui_lobby_button_01_difficulty_select_normal")
			end

			if var_15_1 ~= arg_15_0._expedition_level_index then
				local var_15_4 = var_15_0[var_15_1]

				if not var_15_4.content.locked then
					var_15_4.content.gamepad_selected = true
					var_15_0[arg_15_0._expedition_level_index].content.gamepad_selected = false
					arg_15_0._expedition_level_index = var_15_1

					arg_15_0._parent:play_sound("play_gui_lobby_button_02_mission_act_click")
				end
			end
		end,
		on_exit = function(arg_16_0, arg_16_1, arg_16_2)
			local var_16_0 = arg_16_0._expedition_level_index or 1
			local var_16_1 = arg_16_0._expedition_widgets
			local var_16_2 = var_16_1[var_16_0]

			if var_16_2 then
				var_16_2.content.gamepad_selected = false
			end

			if arg_16_0._expeditions_selection_index then
				var_16_1[arg_16_0._expeditions_selection_index].content.gamepad_selected = true
			end
		end
	},
	{
		enter_requirements = function(arg_17_0)
			return arg_17_0._is_server
		end,
		on_enter = function(arg_18_0, arg_18_1, arg_18_2)
			arg_18_0._selection_widgets_by_name.difficulty_stepper.content.is_selected = true
		end,
		update = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
			local var_19_0 = arg_19_0._selection_widgets_by_name.difficulty_stepper
			local var_19_1 = {
				difficulty_info = arg_19_0._widgets_by_name.difficulty_info,
				upsell_button = arg_19_0._widgets_by_name.upsell_button
			}

			if not arg_19_0.diff_info_anim_played then
				arg_19_0._diff_anim_id = arg_19_0._ui_animator:start_animation("difficulty_info_enter", var_19_1, var_0_8)
				arg_19_0.diff_info_anim_played = true
			end

			local var_19_2 = {}

			if arg_19_1:get("move_left") then
				arg_19_0:_option_selected("difficulty_stepper", "left_arrow", arg_19_3)

				var_19_0.content.left_arrow_pressed = true
				var_19_2.left_key = var_19_0.style.left_arrow_gamepad_highlight

				if arg_19_0._arrow_anim_id then
					arg_19_0._ui_animator:stop_animation(arg_19_0._arrow_anim_id)

					var_19_0.style.right_arrow_gamepad_highlight.color[1] = 0
				end

				arg_19_0._arrow_anim_id = arg_19_0._ui_animator:start_animation("left_arrow_flick", var_19_0, var_0_8, var_19_2)
			elseif arg_19_1:get("move_right") then
				arg_19_0:_option_selected("difficulty_stepper", "right_arrow", arg_19_3)

				var_19_0.content.right_arrow_pressed = true
				var_19_2.right_key = var_19_0.style.right_arrow_gamepad_highlight

				if arg_19_0._arrow_anim_id then
					arg_19_0._ui_animator:stop_animation(arg_19_0._arrow_anim_id)

					var_19_0.style.left_arrow_gamepad_highlight.color[1] = 0
				end

				arg_19_0._arrow_anim_id = arg_19_0._ui_animator:start_animation("right_arrow_flick", var_19_0, var_0_8, var_19_2)
			end

			if arg_19_1:get("confirm_press", true) and arg_19_0._dlc_locked then
				Managers.unlock:open_dlc_page(arg_19_0._dlc_name)
			end

			arg_19_0:_update_difficulty_lock()
		end,
		on_exit = function(arg_20_0, arg_20_1, arg_20_2)
			arg_20_0._selection_widgets_by_name.difficulty_stepper.content.is_selected = false

			local var_20_0 = arg_20_0._widgets_by_name.upsell_button
			local var_20_1 = arg_20_0._widgets_by_name.difficulty_info

			if arg_20_0._diff_anim_id then
				arg_20_0._ui_animator:stop_animation(arg_20_0._diff_anim_id)
			end

			var_20_1.content.visible = false
			var_20_0.content.visible = false
			arg_20_0.diff_info_anim_played = false
		end
	},
	{
		enter_requirements = function(arg_21_0)
			return not Managers.input:is_device_active("gamepad") and arg_21_0._is_server and Managers.twitch:is_connected()
		end,
		on_enter = function(arg_22_0, arg_22_1, arg_22_2)
			arg_22_0._selection_widgets_by_name.play_button.content.is_selected = true
		end,
		update = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
			if arg_23_1:get("confirm_press") and Managers.twitch:is_connected() then
				arg_23_0:_option_selected("play_button", nil, arg_23_3)
			end
		end,
		on_exit = function(arg_24_0, arg_24_1, arg_24_2)
			arg_24_0._selection_widgets_by_name.play_button.content.is_selected = false
		end
	}
}
local var_0_23 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				arg_25_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				local var_26_0 = math.easeOutCubic(arg_26_3)

				arg_26_4.render_settings.alpha_multiplier = var_26_0
			end,
			on_complete = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				arg_28_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				arg_29_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				return
			end
		}
	},
	right_arrow_flick = {
		{
			name = "right_arrow_flick",
			start_progress = 0,
			end_progress = 0.6,
			init = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end,
			update = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				arg_32_4.right_key.color[1] = 255 * (1 - math.easeOutCubic(arg_32_3))
			end,
			on_complete = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				arg_33_2.content.right_arrow_pressed = false
			end
		}
	},
	left_arrow_flick = {
		{
			name = "left_arrow_flick",
			start_progress = 0,
			end_progress = 0.6,
			init = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end,
			update = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				arg_35_4.left_key.color[1] = 255 * (1 - math.easeOutCubic(arg_35_3))
			end,
			on_complete = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				arg_36_2.content.left_arrow_pressed = false
			end
		}
	},
	gamemode_text_swap = {
		{
			name = "gamemode_swap_text_fade_out",
			start_progress = 0,
			end_progress = 0.2,
			init = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				return
			end,
			update = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				local var_38_0 = math.easeOutCubic(arg_38_3)

				arg_38_2.style.game_mode_text.text_color[1] = 255 * (1 - var_38_0)
				arg_38_2.style.press_key_text.text_color[1] = 255 * (1 - var_38_0)

				if arg_38_2.content.show_note then
					arg_38_2.style.note_text.text_color[1] = 255 * (1 - var_38_0)
				end
			end,
			on_complete = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				return
			end
		},
		{
			name = "gamemode_swap_text_fade_in",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				return
			end,
			update = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				if arg_41_2.content.is_showing_info then
					arg_41_2.content.game_mode_text = Localize("expedition_info")
					arg_41_2.content.show_note = true
				else
					arg_41_2.content.game_mode_text = string.gsub(Localize("start_game_window_deus_twitch_desc"), Localize("expedition_highlight_text"), "{#color(255,168,0)}" .. Localize("expedition_highlight_text") .. "{#reset()}")
					arg_41_2.content.show_note = false
				end

				arg_41_2.style.game_mode_text.text_color[1] = 255 * math.easeOutCubic(arg_41_3)
				arg_41_2.style.press_key_text.text_color[1] = 255 * math.easeOutCubic(arg_41_3)

				if arg_41_2.content.show_note then
					arg_41_2.style.note_text.text_color[1] = 255 * math.easeOutCubic(arg_41_3)
				end
			end,
			on_complete = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				return
			end
		}
	},
	difficulty_info_enter = {
		{
			name = "difficulty_info_enter",
			start_progress = 0,
			end_progress = 0.6,
			init = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				arg_43_2.difficulty_info.content.visible = true

				local var_43_0 = arg_43_2.difficulty_info.style

				var_43_0.background.color[1] = 0
				var_43_0.border.color[1] = 0
				var_43_0.difficulty_description.text_color[1] = 0
				var_43_0.highest_obtainable_level.text_color[1] = 0
				var_43_0.difficulty_separator.color[1] = 0
			end,
			update = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				local var_44_0 = math.easeOutCubic(arg_44_3)
				local var_44_1 = arg_44_2.difficulty_info
				local var_44_2 = arg_44_2.difficulty_info.style
				local var_44_3 = arg_44_2.difficulty_info.content

				var_44_1.offset[1] = 50 * var_44_0
				arg_44_2.upsell_button.offset[1] = 50 * var_44_0

				local var_44_4 = 200 * var_44_0

				var_44_2.background.color[1] = var_44_4
				var_44_2.border.color[1] = var_44_4

				local var_44_5 = 255 * var_44_0

				var_44_2.difficulty_description.text_color[1] = var_44_5
				var_44_2.highest_obtainable_level.text_color[1] = var_44_5
				var_44_2.difficulty_separator.color[1] = var_44_5

				if var_44_3.should_show_diff_lock_text then
					var_44_2.difficulty_lock_text.text_color[1] = var_44_5
				end

				if var_44_3.should_show_dlc_lock then
					var_44_2.dlc_lock_text.text_color[1] = var_44_5
				end
			end,
			on_complete = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				return
			end
		}
	}
}

return {
	scenegraph_definition = var_0_8,
	widgets = var_0_20,
	selection_widgets = var_0_17,
	client_widgets = var_0_18,
	server_widgets = var_0_19,
	additional_settings_widgets = var_0_21,
	animation_definitions = var_0_23,
	selector_input_definition = var_0_22,
	journey_widget_settings = var_0_7,
	twitch_keyboard_anchor_point = {
		230,
		350
	}
}
