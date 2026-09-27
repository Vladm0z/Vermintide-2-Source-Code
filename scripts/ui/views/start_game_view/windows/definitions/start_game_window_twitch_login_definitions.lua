-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_twitch_login_definitions.lua

local game_start_windows = UISettings.game_start_windows
local frame = game_start_windows.frame
local size = game_start_windows.size
local var_0_3 = UIFrameSettings[frame].texture_sizes.vertical[1]
local num = size[1] - var_0_3 * 2
local tbl = {
	num - 20 - 160,
	50
}
local tbl_2 = {
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
		horizontal_alignment = "center",
		size = size,
		position = {
			0,
			0,
			1
		}
	},
	description_text = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			num,
			size[2] / 2
		},
		position = {
			0,
			0,
			1
		}
	},
	texture_frame = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			383,
			383
		},
		position = {
			0,
			0,
			1
		}
	},
	twitch_texture = {
		vertical_alignment = "center",
		parent = "texture_frame",
		horizontal_alignment = "center",
		size = {
			294,
			98
		},
		position = {
			0,
			0,
			1
		}
	},
	twitch_title_divider = {
		vertical_alignment = "bottom",
		parent = "texture_frame",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-20,
			2
		}
	},
	login_text_area = {
		vertical_alignment = "bottom",
		parent = "twitch_title_divider",
		horizontal_alignment = "center",
		size = {
			num,
			50
		},
		position = {
			0,
			35,
			1
		}
	},
	login_text_frame = {
		vertical_alignment = "center",
		parent = "login_text_area",
		horizontal_alignment = "left",
		size = tbl,
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
	connecting = {
		vertical_alignment = "center",
		parent = "login_text_area",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			0,
			0,
			1
		}
	},
	chat_feed_frame = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1] - 20,
			size[2] / 2
		},
		position = {
			0,
			10,
			1
		}
	},
	chat_feed_area_mask = {
		vertical_alignment = "center",
		parent = "chat_feed_frame",
		horizontal_alignment = "center",
		size = {
			size[1] - 40,
			size[2] / 2
		}
	},
	chat_feed_area = {
		vertical_alignment = "center",
		parent = "chat_feed_area_mask",
		horizontal_alignment = "center",
		size = {
			size[1] - 20,
			size[2] / 2
		}
	},
	chat_text_box = {
		vertical_alignment = "top",
		parent = "chat_feed_area",
		horizontal_alignment = "center",
		size = {
			size[1] - 40,
			size[2] / 2
		},
		position = {
			0,
			0,
			1
		}
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local str = "menu_frame_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local menu_frame_02 = UIFrameSettings.menu_frame_02
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
		{
			scenegraph_id = "login_text_box",
			pass_type = "hotspot",
			content_id = "text_input_hotspot"
		},
		{
			scenegraph_id = "menu_root",
			pass_type = "hotspot",
			content_id = "screen_hotspot"
		},
		{
			scenegraph_id = "window",
			pass_type = "hotspot",
			content_id = "frame_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "twitch_texture",
			texture_id = "twitch_texture"
		},
		{
			style_id = "login_rect_bg",
			pass_type = "rect",
			content_check_function = function (arg_2_0, arg_2_1)
				-- function 2
				return not not Managers.twitch:is_connected() or not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "login_hint",
			pass_type = "text",
			text_id = "login_hint",
			content_check_function = function (self, arg_3_1)
				-- function 3
				if not self.text_input_hotspot.is_hover then
					arg_3_1.text_color = {
						128,
						255,
						255,
						255
					}
				else
					arg_3_1.text_color = {
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
			content_check_function = function (self, arg_4_1)
				-- function 4
				if not self.text_field_active then
					arg_4_1.caret_color[1] = 0
				else
					arg_4_1.caret_color[1] = 128 + math.sin(Managers.time:time("ui") * 5) * 128
				end

				return not not Managers.twitch:is_connected() or not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "connecting",
			pass_type = "text",
			text_id = "connecting_id",
			content_check_function = function (self, arg_5_1)
				-- function 5
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
		connecting_id = "Connecting",
		text_field_active = false,
		twitch_name = "",
		error_id = "",
		caret_index = 1,
		twitch_texture = "twitch_logo",
		text_index = 1,
		frame = menu_frame_02.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_1_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
					math.min(arg_1_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
				}
			},
			texture_id = str
		},
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
				1
			}
		},
		frame = {
			texture_size = menu_frame_02.texture_size,
			texture_sizes = menu_frame_02.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				5
			}
		},
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
			size = tbl
		},
		twitch_texture = {
			vertical_alignment = "center",
			scenegraph_id = "twitch_texture",
			horizontal_alignment = "center",
			offset = {
				0,
				0,
				1
			},
			color = {
				255,
				255,
				255,
				255
			}
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

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = arg_1_0

	return tbl_2
end

local tbl_3 = {
	scenegraph_id = "chat_feed_area",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_id",
				content_check_function = function (arg_6_0)
					-- function 6
					return Managers.twitch:is_connected()
				end
			},
			{
				style_id = "background",
				pass_type = "rect",
				content_check_function = function (arg_7_0)
					-- function 7
					return Managers.twitch:is_connected()
				end
			},
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
		mask = {
			corner_radius = 0,
			scenegraph_id = "chat_feed_area_mask",
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
		background = {
			scenegraph_id = "chat_feed_area",
			offset = {
				0,
				0,
				-1
			},
			color = {
				255,
				0,
				0,
				0
			}
		},
		chat_text_box = {
			word_wrap = true,
			scenegraph_id = "chat_text_box",
			spacing = 0,
			pixel_perfect = false,
			vertical_alignment = "top",
			dynamic_font = true,
			font_size = 18,
			font_type = "chat_output_font_masked",
			text_color = Colors.get_table("white"),
			name_color = Colors.get_table("sky_blue"),
			name_color_dev = Colors.get_table("cheeseburger"),
			name_color_system = Colors.get_table("gold"),
			offset = {
				0,
				-10,
				0
			}
		}
	}
}

function create_button(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
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
		content_check_function = arg_9_4
	}
	tbl_4[str_2] = {
		size = arg_9_1,
		offset = tbl_5
	}
	tbl_3[str_2] = {}

	local var_9_8 = tbl_3[str_2]
	local str_3 = "background"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture_uv",
		content_id = str_3,
		style_id = str_3,
		content_check_function = arg_9_4
	}
	tbl_4[str_3] = {
		size = arg_9_1,
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
				1 - math.min(arg_9_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
			},
			{
				math.min(arg_9_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
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
		content_check_function = arg_9_4
	}
	tbl_4[str_4] = {
		size = {
			arg_9_1[1],
			arg_9_1[2]
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
	var_9_8[str_4] = "button_bg_fade"

	local str_5 = "hover_glow"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_5,
		style_id = str_5,
		content_check_function = arg_9_4
	}
	tbl_4[str_5] = {
		size = {
			arg_9_1[1],
			math.min(arg_9_1[2] - 5, 80)
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
	var_9_8[str_5] = "button_state_default"

	local str_6 = "clicked_rect"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "rect",
		content_id = str_2,
		style_id = str_6,
		content_check_function = arg_9_4
	}
	tbl_4[str_6] = {
		size = arg_9_1,
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
		content_check_function = arg_9_4
	}
	tbl_4[str_7] = {
		size = {
			arg_9_1[1],
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
			tbl_5[2] + arg_9_1[2] - 11,
			5
		}
	}
	var_9_8[str_7] = "button_glass_02"

	local str_8 = "glass_bottom"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_8,
		style_id = str_8,
		content_check_function = arg_9_4
	}
	tbl_4[str_8] = {
		size = {
			arg_9_1[1],
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
	var_9_8[str_8] = "button_glass_02"

	local str_9 = "text"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str_2,
		text_id = str_9,
		style_id = str_9,
		content_check_function = arg_9_4
	}
	tbl_4[str_9] = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_type = "hell_shark",
		font_size = arg_9_3,
		text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		select_text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			10 + tbl_5[1],
			tbl_5[2] + 3,
			4
		},
		size = {
			arg_9_1[1] - 20,
			arg_9_1[2]
		}
	}
	var_9_8[str_9] = arg_9_2

	local str_10 = "text_shadow"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str_2,
		text_id = str_9,
		style_id = str_10,
		content_check_function = arg_9_4
	}
	tbl_4[str_10] = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_type = "hell_shark",
		font_size = arg_9_3,
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			10 + tbl_5[1] + 2,
			tbl_5[2] + 2,
			3
		},
		size = {
			arg_9_1[1] - 20,
			arg_9_1[2]
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
	tbl.scenegraph_id = arg_9_0

	return tbl
end

local tbl_4 = {
	word_wrap = true,
	font_size = 22,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}

local function fn_2(arg_10_0)
	-- function 10
	return not not Managers.twitch:is_connecting() or not Managers.twitch:is_connected()
end

local function fn_3(arg_11_0)
	-- function 11
	return not not Managers.twitch:is_connecting() or Managers.twitch:is_connected()
end

local function fn_4(arg_12_0)
	-- function 12
	local is_connecting = Managers.twitch:is_connecting()

	is_connecting = is_connecting or not Managers.twitch:is_connected()

	return is_connecting
end

local str = "start_game_window_twitch_connect_description"
local tbl_5 = {
	background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window"),
	background_mask = UIWidgets.create_simple_texture("mask_rect", "window"),
	window = UIWidgets.create_frame("window", size, frame, 20),
	frame_widget = fn("window", tbl_2.window.size),
	login_text_frame = UIWidgets.create_frame("login_text_frame", {
		num,
		50
	}, "menu_frame_09", 1),
	chat_feed_frame = UIWidgets.create_frame("chat_feed_frame", {
		num - 20,
		250
	}, "menu_frame_09", 1),
	description_text = UIWidgets.create_simple_text(Localize(str), "description_text", nil, nil, tbl_4),
	twitch_texture = UIWidgets.create_simple_texture("twitch_logo", "twitch_texture"),
	twitch_title_divider = UIWidgets.create_simple_texture("divider_01_top", "twitch_title_divider"),
	chat_output_widget = tbl_3,
	button_1 = create_button("connect_button", tbl_2.connect_button.size, Localize("start_game_window_twitch_connect"), 24, fn_2),
	button_2 = create_button("disconnect_button", tbl_2.disconnect_button.size, string.format(Localize("start_game_window_twitch_disconnect"), "N/A"), 24, fn_3),
	connect_button_frame = UIWidgets.create_frame("connect_button_frame", tbl_2.connect_button_frame.size, frame, 1),
	disconnect_button_frame = UIWidgets.create_frame("disconnect_button_frame", tbl_2.disconnect_button_frame.size, frame, 1)
}

tbl_5.login_text_frame.element.passes[1].content_check_function = fn_2
tbl_5.connect_button_frame.element.passes[1].content_check_function = fn_2
tbl_5.disconnect_button_frame.element.passes[1].content_check_function = fn_3
tbl_5.chat_feed_frame.element.passes[1].content_check_function = fn_3
tbl_5.description_text.element.passes[1].content_check_function = fn_4
tbl_5.description_text.element.passes[2].content_check_function = fn_4

return {
	widgets = tbl_5,
	scenegraph_definition = tbl_2
}
