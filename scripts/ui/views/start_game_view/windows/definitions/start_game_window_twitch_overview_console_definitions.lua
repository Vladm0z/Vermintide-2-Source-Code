-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_twitch_overview_console_definitions.lua

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
			tbl[1],
			tbl[2] + 22
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
			size[1] - 20,
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
			size[1] - 20,
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
			size[2]
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
			size[2]
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
			size[2]
		}
	}
}

if not IS_XB1 then
	tbl_4.connect_button = {
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

function create_button(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
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
		content_check_function = arg_7_4
	}
	tbl_4[str_2] = {
		size = arg_7_1,
		offset = tbl_5
	}
	tbl_3[str_2] = {}

	local var_7_8 = tbl_3[str_2]
	local str_3 = "background"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture_uv",
		content_id = str_3,
		style_id = str_3,
		content_check_function = arg_7_4
	}
	tbl_4[str_3] = {
		size = arg_7_1,
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
				1 - math.min(arg_7_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
			},
			{
				math.min(arg_7_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
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
		content_check_function = arg_7_4
	}
	tbl_4[str_4] = {
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
			tbl_5[1],
			tbl_5[2],
			1
		}
	}
	var_7_8[str_4] = "button_bg_fade"

	local str_5 = "hover_glow"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_5,
		style_id = str_5,
		content_check_function = arg_7_4
	}
	tbl_4[str_5] = {
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
			tbl_5[1],
			tbl_5[2] + 5,
			2
		}
	}
	var_7_8[str_5] = "button_state_default"

	local str_6 = "clicked_rect"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "rect",
		content_id = str_2,
		style_id = str_6,
		content_check_function = arg_7_4
	}
	tbl_4[str_6] = {
		size = arg_7_1,
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
		content_check_function = arg_7_4
	}
	tbl_4[str_7] = {
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
			tbl_5[1],
			tbl_5[2] + arg_7_1[2] - 11,
			5
		}
	}
	var_7_8[str_7] = "button_glass_02"

	local str_8 = "glass_bottom"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_8,
		style_id = str_8,
		content_check_function = arg_7_4
	}
	tbl_4[str_8] = {
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
			tbl_5[1],
			tbl_5[2] - 3,
			5
		}
	}
	var_7_8[str_8] = "button_glass_02"

	local str_9 = "text"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str_2,
		text_id = str_9,
		style_id = str_9,
		content_check_function = arg_7_4
	}
	tbl_4[str_9] = {
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
			10 + tbl_5[1],
			tbl_5[2] + 3,
			4
		},
		size = {
			arg_7_1[1] - 20,
			arg_7_1[2]
		}
	}
	var_7_8[str_9] = arg_7_2

	local str_10 = "text_shadow"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str_2,
		text_id = str_9,
		style_id = str_10,
		content_check_function = arg_7_4
	}
	tbl_4[str_10] = {
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
			10 + tbl_5[1] + 2,
			tbl_5[2] + 2,
			3
		},
		size = {
			arg_7_1[1] - 20,
			arg_7_1[2]
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
	tbl.scenegraph_id = arg_7_0

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
				content_check_function = function (arg_8_0)
					-- function 8
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

local function fn(arg_9_0, arg_9_1)
	-- function 9
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
				-- function 10
				return not not Managers.twitch:is_connected() or not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "login_hint",
			pass_type = "text",
			text_id = "login_hint",
			content_check_function = function (self, arg_11_1)
				-- function 11
				if not self.text_input_hotspot.is_hover then
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

				return self.twitch_name ~= "" or not not Managers.twitch:is_connected() or not not self.text_field_active or not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "twitch_name",
			pass_type = "text",
			text_id = "twitch_name",
			content_check_function = function (self, arg_12_1)
				-- function 12
				if not self.text_field_active then
					arg_12_1.caret_color[1] = 0
				else
					arg_12_1.caret_color[1] = 128 + math.sin(Managers.time:time("ui") * 5) * 128
				end

				return not not Managers.twitch:is_connected() or not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "connecting",
			pass_type = "text",
			text_id = "connecting_id",
			content_check_function = function (self, arg_13_1)
				-- function 13
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
	tbl.scenegraph_id = arg_9_0

	return tbl
end

function create_twitch_rect_with_outer_frame(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	arg_14_4 = arg_14_4 or {
		255,
		255,
		255,
		255
	}

	local var_14_0

	if not arg_14_2 then
		var_14_0 = UIFrameSettings[arg_14_2]

		if not var_14_0 then
			-- Nothing
		end
	end

	var_14_0 = UIFrameSettings.frame_outer_fade_02

	::label_14_0::

	local var_14_1 = var_14_0.texture_sizes.horizontal[2]
	local tbl = {
		arg_14_1[1] + var_14_1 * 2,
		arg_14_1[2] + var_14_1 * 2
	}
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame",
			content_check_function = function (arg_15_0, arg_15_1)
				-- function 15
				return Managers.twitch:is_connected()
			end
		},
		{
			style_id = "rect",
			pass_type = "rect",
			content_check_function = function (arg_16_0, arg_16_1)
				-- function 16
				return Managers.twitch:is_connected()
			end
		}
	}
	local tbl_4 = {
		frame = var_14_0.texture
	}
	local tbl_5 = {
		frame = {
			color = arg_14_5 or arg_14_4,
			size = tbl,
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

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = arg_14_0

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
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
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
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		2
	}
}

local function fn_2(arg_17_0)
	-- function 17
	return not not Managers.twitch:is_connecting() or not not Managers.twitch:is_connected() or not Managers.input:is_device_active("gamepad")
end

local function fn_3(arg_18_0)
	-- function 18
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

local str = "start_game_window_twitch_connect_description"
local str_2 = "start_game_window_twitch_client_disclaimer_description"
local tbl_8 = {
	mission_setting = UIWidgets.create_start_game_console_setting_button("game_option_1", Localize("start_game_window_mission"), nil, nil, nil, tbl_4.game_option_1.size),
	difficulty_setting = UIWidgets.create_start_game_console_setting_button("game_option_2", Localize("start_game_window_difficulty"), nil, "difficulty_option_1", nil, tbl_4.game_option_2.size, true),
	play_button = UIWidgets.create_icon_and_name_button("play_button", "options_button_icon_quickplay", Localize("start_game_window_play"))
}
local tbl_9 = {
	client_disclaimer_background = UIWidgets.create_rect_with_outer_frame("client_disclaimer_background", tbl_4.client_disclaimer_background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	client_disclaimer_description = UIWidgets.create_simple_text(Localize(str_2), "client_disclaimer_description", nil, nil, tbl_7)
}
local tbl_10 = {
	twitch_description_background = UIWidgets.create_rect_with_outer_frame("twitch_background", tbl_4.twitch_background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	twitch_texture = UIWidgets.create_simple_texture("twitch_logo", "twitch_texture"),
	twitch_divider = UIWidgets.create_simple_texture("divider_01_top", "twitch_divider"),
	twitch_description = UIWidgets.create_simple_text(Localize(str), "twitch_description", nil, nil, tbl_6),
	button_1 = create_button("connect_button", tbl_4.connect_button.size, Localize("start_game_window_twitch_connect"), 24, fn_2),
	button_2 = create_button("disconnect_button", tbl_4.disconnect_button.size, string.format(Localize("start_game_window_twitch_disconnect"), "N/A"), 24, fn_3),
	connect_button_frame = UIWidgets.create_frame("connect_button_frame", tbl_4.connect_button_frame.size, frame, 1),
	disconnect_button_frame = UIWidgets.create_frame("disconnect_button_frame", tbl_4.disconnect_button_frame.size, frame, 1),
	login_text_frame = UIWidgets.create_frame("login_text_frame", {
		var_0_5,
		50
	}, "menu_frame_09", 1),
	frame_widget = fn("twitch_background", tbl_4.twitch_background.size),
	chat_output_widget = tbl_5,
	chat_mask = UIWidgets.create_simple_texture("mask_rect", "chat_feed_area_mask"),
	chat_output_background = create_twitch_rect_with_outer_frame("chat_feed_area_mask", tbl_4.chat_feed_area_mask.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color)
}

tbl_10.login_text_frame.element.passes[1].content_check_function = fn_2
tbl_10.connect_button_frame.element.passes[1].content_check_function = fn_2
tbl_10.disconnect_button_frame.element.passes[1].content_check_function = fn_3

local tbl_11 = {}
local tbl_12 = {
	"mission_setting",
	"difficulty_setting",
	"play_button"
}

return {
	scenegraph_definition = tbl_4,
	widgets = tbl_10,
	play_widgets = tbl_8,
	client_widgets = tbl_9,
	additional_settings_widgets = tbl_11,
	animation_definitions = tbl_3,
	selector_input_definition = tbl_12,
	twitch_keyboard_anchor_point = {
		230,
		350
	}
}
