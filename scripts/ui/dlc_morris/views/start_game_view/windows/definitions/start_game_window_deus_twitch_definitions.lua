-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_twitch_definitions.lua

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
	var_0_5 - 20 - 160,
	50
}
local tbl_3 = {
	width = 72,
	spacing_x = 40
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
		size = {
			size[1],
			size[2] + 100
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
			size[1],
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
		size = tbl_2,
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
			size[1] + 70,
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
			size[1] + 70,
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
			-15 + tbl[2] * 2,
			1
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
			60,
			1
		}
	},
	difficulty_stepper = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			tbl[2] + 22
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
		size = tbl_2,
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
			size[1] - 20,
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
			size[1] - 20,
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
			size[2] - 220
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
			size[2] - 220
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
			size[2] - 220
		}
	}
}

if not IS_XB1 then
	tbl_4.connect_button = {
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
	tbl_4.connect_button_frame = {
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
	-- function 1
	local str = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {
		0,
		0,
		0
	}
	local str_2 = "button_hotspot"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "hotspot",
		content_id = str_2,
		style_id = str_2,
		content_check_function = arg_1_4
	}
	tbl_4[str_2] = {
		size = arg_1_1,
		offset = tbl_5
	}
	tbl_3[str_2] = {}

	local var_1_8 = tbl_3[str_2]
	local str_3 = "background"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture_uv",
		content_id = str_3,
		style_id = str_3,
		content_check_function = arg_1_4
	}
	tbl_4[str_3] = {
		size = arg_1_1,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_5[1],
			tbl_5[2],
			0
		}
	}
	tbl_3[str_3] = {
		uvs = {
			{
				0,
				1 - math.min(arg_1_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
			},
			{
				math.min(arg_1_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
				1
			}
		},
		texture_id = str
	}

	local str_4 = "background_fade"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_4,
		style_id = str_4,
		content_check_function = arg_1_4
	}
	tbl_4[str_4] = {
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
			tbl_5[1],
			tbl_5[2],
			1
		}
	}
	var_1_8[str_4] = "button_bg_fade"

	local str_5 = "hover_glow"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_5,
		style_id = str_5,
		content_check_function = arg_1_4
	}
	tbl_4[str_5] = {
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
			tbl_5[1],
			tbl_5[2] + 5,
			2
		}
	}
	var_1_8[str_5] = "button_state_default"

	local str_6 = "clicked_rect"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "rect",
		content_id = str_2,
		style_id = str_6,
		content_check_function = arg_1_4
	}
	tbl_4[str_6] = {
		size = arg_1_1,
		color = {
			100,
			0,
			0,
			0
		},
		offset = {
			tbl_5[1],
			tbl_5[2],
			6
		}
	}

	local str_7 = "glass_top"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_7,
		style_id = str_7,
		content_check_function = arg_1_4
	}
	tbl_4[str_7] = {
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
			tbl_5[1],
			tbl_5[2] + arg_1_1[2] - 11,
			5
		}
	}
	var_1_8[str_7] = "button_glass_02"

	local str_8 = "glass_bottom"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_8,
		style_id = str_8,
		content_check_function = arg_1_4
	}
	tbl_4[str_8] = {
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
			tbl_5[1],
			tbl_5[2] - 3,
			5
		}
	}
	var_1_8[str_8] = "button_glass_02"

	local str_9 = "text"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str_2,
		text_id = str_9,
		style_id = str_9,
		content_check_function = arg_1_4
	}
	tbl_4[str_9] = {
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
			10 + tbl_5[1],
			tbl_5[2] + 3,
			4
		},
		size = {
			arg_1_1[1] - 20,
			arg_1_1[2]
		}
	}
	var_1_8[str_9] = arg_1_2

	local str_10 = "text_shadow"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str_2,
		text_id = str_9,
		style_id = str_10,
		content_check_function = arg_1_4
	}
	tbl_4[str_10] = {
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
			10 + tbl_5[1] + 2,
			tbl_5[2] + 2,
			3
		},
		size = {
			arg_1_1[1] - 20,
			arg_1_1[2]
		}
	}
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_1_0

	return tbl
end

local tbl_5 = {
	scenegraph_id = "chat_feed_area",
	element = {
		passes = {
			{
				style_id = "chat_text_box",
				pass_type = "text_area_chat",
				text_id = "text_field",
				content_check_function = function (arg_2_0)
					-- function 2
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

local function fn(arg_3_0, arg_3_1)
	-- function 3
	local tbl = {
		element = {}
	}
	local tbl_3 = {
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
			content_check_function = function (arg_4_0, arg_4_1)
				-- function 4
				return not not Managers.twitch:is_connected() or not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "login_hint",
			pass_type = "text",
			text_id = "login_hint",
			content_check_function = function (self, arg_5_1)
				-- function 5
				if not self.text_input_hotspot.is_hover then
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

				return self.twitch_name ~= "" or not not Managers.twitch:is_connected() or not not self.text_field_active or not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "twitch_name",
			pass_type = "text",
			text_id = "twitch_name",
			content_check_function = function (self, arg_6_1)
				-- function 6
				if not self.text_field_active then
					arg_6_1.caret_color[1] = 0
				else
					arg_6_1.caret_color[1] = 128 + math.sin(Managers.time:time("ui") * 5) * 128
				end

				return not not Managers.twitch:is_connected() or not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "connecting",
			pass_type = "text",
			text_id = "connecting_id",
			content_check_function = function (self, arg_7_1)
				-- function 7
				if not Managers.twitch:is_connecting() then
					return
				end

				local num = 10 * Managers.time:time("ui")
				local rep = string.rep(".", num % 5)

				self.connecting_id = Localize("start_game_window_twitch_connecting") .. rep

				return true
			end
		}
	}
	local tbl_4 = {
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
	local tbl_5 = {
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
			size = tbl_2
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

	tbl.element.passes = tbl_3
	tbl.content = tbl_4
	tbl.style = tbl_5
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_3_0

	return tbl
end

function create_twitch_rect_with_outer_frame(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	arg_8_4 = arg_8_4 or {
		255,
		255,
		255,
		255
	}

	local var_8_0

	if not arg_8_2 then
		var_8_0 = UIFrameSettings[arg_8_2]

		if not var_8_0 then
			-- Nothing
		end
	end

	var_8_0 = UIFrameSettings.frame_outer_fade_02

	::label_8_0::

	local var_8_1 = var_8_0.texture_sizes.horizontal[2]
	local tbl = {
		arg_8_1[1] + var_8_1 * 2,
		arg_8_1[2] + var_8_1 * 2
	}
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame",
			content_check_function = function (arg_9_0, arg_9_1)
				-- function 9
				return Managers.twitch:is_connected()
			end
		},
		{
			style_id = "rect",
			pass_type = "rect",
			content_check_function = function (arg_10_0, arg_10_1)
				-- function 10
				return Managers.twitch:is_connected()
			end
		}
	}
	local tbl_4 = {
		frame = var_8_0.texture
	}
	local tbl_5 = {
		frame = {
			color = arg_8_5 or arg_8_4,
			size = tbl,
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

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = arg_8_0

	return tbl_2
end

local tbl_6 = {
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

local function fn_2(arg_11_0)
	-- function 11
	return not not Managers.twitch:is_connecting() or not not Managers.twitch:is_connected() or not Managers.input:is_device_active("gamepad")
end

local function fn_3(arg_12_0)
	-- function 12
	local is_connected

	if not Managers.twitch:is_connecting() then
		is_connected = Managers.twitch:is_connected()

		if not is_connected then
			is_connected = not Managers.input:is_device_active("gamepad")
		end
	else
		is_connected = false
	end

	if false then
		is_connected = true
	end

	return is_connected
end

local gsub = string.gsub(Localize("start_game_window_deus_twitch_desc"), Localize("expedition_highlight_text"), "{#color(255,168,0)}" .. Localize("expedition_highlight_text") .. "{#reset()}")
local str = "start_game_window_twitch_client_disclaimer_description"
local flag = true
local tbl_7 = {
	difficulty_stepper = UIWidgets.create_start_game_difficulty_stepper("difficulty_stepper", Localize("start_game_window_difficulty"), "difficulty_option_1"),
	play_button = UIWidgets.create_start_game_deus_play_button("play_button", tbl_4.play_button.size, Localize("start_game_window_play"), 34, flag)
}
local tbl_8 = {
	client_disclaimer_background = UIWidgets.create_rect_with_outer_frame("client_disclaimer_background", tbl_4.client_disclaimer_background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	client_disclaimer_description = UIWidgets.create_simple_text(Localize(str), "client_disclaimer_description", nil, nil, tbl_6)
}
local tbl_9 = {
	brush_stroke = UIWidgets.create_simple_texture("brush_stroke", "brush_stroke")
}
local tbl_10 = {
	twitch_texture = UIWidgets.create_simple_texture("twitch_logo_new", "twitch_texture"),
	twitch_gamemode_info_box = UIWidgets.create_start_game_deus_gamemode_info_box("twitch_background", tbl_4.twitch_background.size, nil, gsub, true),
	button_1 = create_button("connect_button", tbl_4.connect_button.size, Localize("start_game_window_twitch_connect"), 24, fn_2),
	button_2 = create_button("disconnect_button", tbl_4.disconnect_button.size, string.format(Localize("start_game_window_twitch_disconnect"), "N/A"), 24, fn_3),
	connect_button_frame = UIWidgets.create_frame("connect_button_frame", tbl_4.connect_button_frame.size, frame, 1),
	disconnect_button_frame = UIWidgets.create_frame("disconnect_button_frame", tbl_4.disconnect_button_frame.size, frame, 1),
	login_text_frame = UIWidgets.create_frame("login_text_frame", {
		var_0_5,
		50
	}, "menu_frame_09", 1),
	frame_widget = fn("twitch_background", tbl_4.twitch_background.size),
	difficulty_info = UIWidgets.create_start_game_deus_difficulty_info_box("difficulty_info", tbl_4.difficulty_info.size),
	upsell_button = UIWidgets.create_simple_two_state_button("upsell_button", "icon_redirect", "icon_redirect_hover"),
	chat_output_widget = tbl_5,
	chat_mask = UIWidgets.create_simple_texture("mask_rect", "chat_feed_area_mask"),
	chat_output_background = create_twitch_rect_with_outer_frame("chat_feed_area_mask", tbl_4.chat_feed_area_mask.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color)
}

tbl_10.login_text_frame.element.passes[1].content_check_function = fn_2
tbl_10.connect_button_frame.element.passes[1].content_check_function = fn_2
tbl_10.disconnect_button_frame.element.passes[1].content_check_function = fn_3

local tbl_11 = {}
local tbl_12 = {
	{
		enter_requirements = function (self)
			-- function 13
			return self._is_server
		end,
		on_enter = function (self, arg_14_1, arg_14_2)
			-- function 14
			self._expedition_level_index = 1

			local _expedition_widgets = self._expedition_widgets

			for i = 1, #_expedition_widgets do
				_expedition_widgets[i].content.gamepad_selected = false
			end

			_expedition_widgets[self._expedition_level_index].content.gamepad_selected = true
		end,
		update = function (self, arg_15_1, arg_15_2, arg_15_3)
			-- function 15
			local _expedition_widgets = self._expedition_widgets
			local _expedition_level_index = self._expedition_level_index

			if not arg_15_1:get("move_left") then
				_expedition_level_index = math.max(_expedition_level_index - 1, 1)
			elseif not arg_15_1:get("move_right") then
				_expedition_level_index = math.min(_expedition_level_index + 1, #_expedition_widgets)
			elseif not arg_15_1:get("confirm_press") then
				if not self._expeditions_selection_index then
					self._expedition_widgets[self._expeditions_selection_index].content.button_hotspot.is_selected = nil
				end

				local var_15_2 = self._expedition_widgets[_expedition_level_index]

				var_15_2.content.button_hotspot.is_selected = true

				local journey_name = var_15_2.content.journey_name

				self._parent:set_selected_level_id(journey_name)

				self._expeditions_selection_index = _expedition_level_index

				self:_play_sound("play_gui_lobby_button_01_difficulty_select_normal")
			end

			if _expedition_level_index ~= self._expedition_level_index then
				local var_15_4 = _expedition_widgets[_expedition_level_index]

				if not var_15_4.content.locked then
					var_15_4.content.gamepad_selected = true
					_expedition_widgets[self._expedition_level_index].content.gamepad_selected = false
					self._expedition_level_index = _expedition_level_index

					self._parent:play_sound("play_gui_lobby_button_02_mission_act_click")
				end
			end
		end,
		on_exit = function (self, arg_16_1, arg_16_2)
			-- function 16
			local _expedition_level_index = self._expedition_level_index

			_expedition_level_index = _expedition_level_index or 1

			local _expedition_widgets = self._expedition_widgets
			local var_16_2 = _expedition_widgets[_expedition_level_index]

			if not var_16_2 then
				var_16_2.content.gamepad_selected = false
			end

			if not self._expeditions_selection_index then
				_expedition_widgets[self._expeditions_selection_index].content.gamepad_selected = true
			end
		end
	},
	{
		enter_requirements = function (self)
			-- function 17
			return self._is_server
		end,
		on_enter = function (arg_18_0, arg_18_1, arg_18_2)
			-- function 18
			arg_18_0._selection_widgets_by_name.difficulty_stepper.content.is_selected = true
		end,
		update = function (self, arg_19_1, arg_19_2, arg_19_3)
			-- function 19
			local difficulty_stepper = self._selection_widgets_by_name.difficulty_stepper
			local tbl = {
				difficulty_info = self._widgets_by_name.difficulty_info,
				upsell_button = self._widgets_by_name.upsell_button
			}

			if not self.diff_info_anim_played then
				self._diff_anim_id = self._ui_animator:start_animation("difficulty_info_enter", tbl, tbl_4)
				self.diff_info_anim_played = true
			end

			local tbl_2 = {}

			if not arg_19_1:get("move_left") then
				self:_option_selected("difficulty_stepper", "left_arrow", arg_19_3)

				difficulty_stepper.content.left_arrow_pressed = true
				tbl_2.left_key = difficulty_stepper.style.left_arrow_gamepad_highlight

				if not self._arrow_anim_id then
					self._ui_animator:stop_animation(self._arrow_anim_id)

					difficulty_stepper.style.right_arrow_gamepad_highlight.color[1] = 0
				end

				self._arrow_anim_id = self._ui_animator:start_animation("left_arrow_flick", difficulty_stepper, tbl_4, tbl_2)
			elseif not arg_19_1:get("move_right") then
				self:_option_selected("difficulty_stepper", "right_arrow", arg_19_3)

				difficulty_stepper.content.right_arrow_pressed = true
				tbl_2.right_key = difficulty_stepper.style.right_arrow_gamepad_highlight

				if not self._arrow_anim_id then
					self._ui_animator:stop_animation(self._arrow_anim_id)

					difficulty_stepper.style.left_arrow_gamepad_highlight.color[1] = 0
				end

				self._arrow_anim_id = self._ui_animator:start_animation("right_arrow_flick", difficulty_stepper, tbl_4, tbl_2)
			end

			if not arg_19_1:get("confirm_press", true) and not self._dlc_locked then
				Managers.unlock:open_dlc_page(self._dlc_name)
			end

			self:_update_difficulty_lock()
		end,
		on_exit = function (self, arg_20_1, arg_20_2)
			-- function 20
			self._selection_widgets_by_name.difficulty_stepper.content.is_selected = false

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
		enter_requirements = function (self)
			-- function 21
			local _is_server

			if not Managers.input:is_device_active("gamepad") then
				_is_server = self._is_server

				if not _is_server then
					_is_server = Managers.twitch:is_connected()
				end
			else
				_is_server = false
			end

			if false then
				_is_server = true
			end

			return _is_server
		end,
		on_enter = function (arg_22_0, arg_22_1, arg_22_2)
			-- function 22
			arg_22_0._selection_widgets_by_name.play_button.content.is_selected = true
		end,
		update = function (self, arg_23_1, arg_23_2, arg_23_3)
			-- function 23
			if not arg_23_1:get("confirm_press") and not Managers.twitch:is_connected() then
				self:_option_selected("play_button", nil, arg_23_3)
			end
		end,
		on_exit = function (arg_24_0, arg_24_1, arg_24_2)
			-- function 24
			arg_24_0._selection_widgets_by_name.play_button.content.is_selected = false
		end
	}
}
local tbl_13 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				arg_25_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				-- function 26
				local easeOutCubic = math.easeOutCubic(arg_26_3)

				arg_26_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				arg_28_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				-- function 29
				arg_29_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				-- function 30
				return
			end
		}
	},
	right_arrow_flick = {
		{
			name = "right_arrow_flick",
			start_progress = 0,
			end_progress = 0.6,
			init = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				return
			end,
			update = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				-- function 32
				arg_32_4.right_key.color[1] = 255 * (1 - math.easeOutCubic(arg_32_3))
			end,
			on_complete = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				-- function 33
				arg_33_2.content.right_arrow_pressed = false
			end
		}
	},
	left_arrow_flick = {
		{
			name = "left_arrow_flick",
			start_progress = 0,
			end_progress = 0.6,
			init = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				return
			end,
			update = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				-- function 35
				arg_35_4.left_key.color[1] = 255 * (1 - math.easeOutCubic(arg_35_3))
			end,
			on_complete = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				-- function 36
				arg_36_2.content.left_arrow_pressed = false
			end
		}
	},
	gamemode_text_swap = {
		{
			name = "gamemode_swap_text_fade_out",
			start_progress = 0,
			end_progress = 0.2,
			init = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
				return
			end,
			update = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				-- function 38
				local easeOutCubic = math.easeOutCubic(arg_38_3)

				arg_38_2.style.game_mode_text.text_color[1] = 255 * (1 - easeOutCubic)
				arg_38_2.style.press_key_text.text_color[1] = 255 * (1 - easeOutCubic)

				if not arg_38_2.content.show_note then
					arg_38_2.style.note_text.text_color[1] = 255 * (1 - easeOutCubic)
				end
			end,
			on_complete = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				-- function 39
				return
			end
		},
		{
			name = "gamemode_swap_text_fade_in",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				return
			end,
			update = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				-- function 41
				if not arg_41_2.content.is_showing_info then
					arg_41_2.content.game_mode_text = Localize("expedition_info")
					arg_41_2.content.show_note = true
				else
					arg_41_2.content.game_mode_text = string.gsub(Localize("start_game_window_deus_twitch_desc"), Localize("expedition_highlight_text"), "{#color(255,168,0)}" .. Localize("expedition_highlight_text") .. "{#reset()}")
					arg_41_2.content.show_note = false
				end

				arg_41_2.style.game_mode_text.text_color[1] = 255 * math.easeOutCubic(arg_41_3)
				arg_41_2.style.press_key_text.text_color[1] = 255 * math.easeOutCubic(arg_41_3)

				if not arg_41_2.content.show_note then
					arg_41_2.style.note_text.text_color[1] = 255 * math.easeOutCubic(arg_41_3)
				end
			end,
			on_complete = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				-- function 42
				return
			end
		}
	},
	difficulty_info_enter = {
		{
			name = "difficulty_info_enter",
			start_progress = 0,
			end_progress = 0.6,
			init = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				-- function 43
				arg_43_2.difficulty_info.content.visible = true

				local style = arg_43_2.difficulty_info.style

				style.background.color[1] = 0
				style.border.color[1] = 0
				style.difficulty_description.text_color[1] = 0
				style.highest_obtainable_level.text_color[1] = 0
				style.difficulty_separator.color[1] = 0
			end,
			update = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				-- function 44
				local easeOutCubic = math.easeOutCubic(arg_44_3)
				local difficulty_info = arg_44_2.difficulty_info
				local style = arg_44_2.difficulty_info.style
				local content = arg_44_2.difficulty_info.content

				difficulty_info.offset[1] = 50 * easeOutCubic
				arg_44_2.upsell_button.offset[1] = 50 * easeOutCubic

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
			on_complete = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				-- function 45
				return
			end
		}
	}
}

return {
	scenegraph_definition = tbl_4,
	widgets = tbl_10,
	selection_widgets = tbl_7,
	client_widgets = tbl_8,
	server_widgets = tbl_9,
	additional_settings_widgets = tbl_11,
	animation_definitions = tbl_13,
	selector_input_definition = tbl_12,
	journey_widget_settings = tbl_3,
	twitch_keyboard_anchor_point = {
		230,
		350
	}
}
