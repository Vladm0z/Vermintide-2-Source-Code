-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_twitch_login_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = UIFrameSettings[var_0_1].texture_sizes.vertical[1]
local var_0_4 = var_0_2[1] - var_0_3 * 2
local var_0_5 = {
	var_0_4 - 20 - 160,
	50
}
local var_0_6 = {
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
		size = var_0_2,
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
			var_0_4,
			var_0_2[2] / 2
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
			var_0_4,
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
		size = var_0_5,
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
	connecting = {
		vertical_alignment = "center",
		parent = "login_text_area",
		horizontal_alignment = "center",
		size = var_0_5,
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
			var_0_2[1] - 20,
			var_0_2[2] / 2
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
			var_0_2[1] - 40,
			var_0_2[2] / 2
		}
	},
	chat_feed_area = {
		vertical_alignment = "center",
		parent = "chat_feed_area_mask",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] - 20,
			var_0_2[2] / 2
		}
	},
	chat_text_box = {
		vertical_alignment = "top",
		parent = "chat_feed_area",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] - 40,
			var_0_2[2] / 2
		},
		position = {
			0,
			0,
			1
		}
	}
}

local function var_0_7(arg_1_0, arg_1_1)
	local var_1_0 = "menu_frame_bg_01"
	local var_1_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_0)
	local var_1_2 = UIFrameSettings.menu_frame_02
	local var_1_3 = {
		element = {}
	}
	local var_1_4 = {
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
				return not Managers.twitch:is_connected() and not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "login_hint",
			pass_type = "text",
			text_id = "login_hint",
			content_check_function = function (arg_3_0, arg_3_1)
				if arg_3_0.text_input_hotspot.is_hover then
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

				return arg_3_0.twitch_name == "" and not Managers.twitch:is_connected() and not arg_3_0.text_field_active and not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "twitch_name",
			pass_type = "text",
			text_id = "twitch_name",
			content_check_function = function (arg_4_0, arg_4_1)
				if not arg_4_0.text_field_active then
					arg_4_1.caret_color[1] = 0
				else
					arg_4_1.caret_color[1] = 128 + math.sin(Managers.time:time("ui") * 5) * 128
				end

				return not Managers.twitch:is_connected() and not Managers.twitch:is_connecting()
			end
		},
		{
			style_id = "connecting",
			pass_type = "text",
			text_id = "connecting_id",
			content_check_function = function (arg_5_0, arg_5_1)
				if not Managers.twitch:is_connecting() then
					return
				end

				local var_5_0 = 10 * Managers.time:time("ui")
				local var_5_1 = string.rep(".", var_5_0 % 5)

				arg_5_0.connecting_id = Localize("start_game_window_twitch_connecting") .. var_5_1

				return true
			end
		}
	}
	local var_1_5 = {
		text_start_offset = 0,
		connecting_id = "Connecting",
		text_field_active = false,
		twitch_name = "",
		error_id = "",
		caret_index = 1,
		twitch_texture = "twitch_logo",
		text_index = 1,
		frame = var_1_2.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_1_1[1] / var_1_1.size[1], 1),
					math.min(arg_1_1[2] / var_1_1.size[2], 1)
				}
			},
			texture_id = var_1_0
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
	local var_1_6 = {
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
			texture_size = var_1_2.texture_size,
			texture_sizes = var_1_2.texture_sizes,
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
			size = var_0_5
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

	var_1_3.element.passes = var_1_4
	var_1_3.content = var_1_5
	var_1_3.style = var_1_6
	var_1_3.offset = {
		0,
		0,
		0
	}
	var_1_3.scenegraph_id = arg_1_0

	return var_1_3
end

local var_0_8 = {
	scenegraph_id = "chat_feed_area",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_id",
				content_check_function = function (arg_6_0)
					return Managers.twitch:is_connected()
				end
			},
			{
				style_id = "background",
				pass_type = "rect",
				content_check_function = function (arg_7_0)
					return Managers.twitch:is_connected()
				end
			},
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
	local var_9_0 = "button_bg_01"
	local var_9_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_9_0)
	local var_9_2 = {
		element = {}
	}
	local var_9_3 = {}
	local var_9_4 = {}
	local var_9_5 = {}
	local var_9_6 = {
		0,
		0,
		0
	}
	local var_9_7 = "button_hotspot"

	var_9_3[#var_9_3 + 1] = {
		pass_type = "hotspot",
		content_id = var_9_7,
		style_id = var_9_7,
		content_check_function = arg_9_4
	}
	var_9_5[var_9_7] = {
		size = arg_9_1,
		offset = var_9_6
	}
	var_9_4[var_9_7] = {}

	local var_9_8 = var_9_4[var_9_7]
	local var_9_9 = "background"

	var_9_3[#var_9_3 + 1] = {
		pass_type = "texture_uv",
		content_id = var_9_9,
		style_id = var_9_9,
		content_check_function = arg_9_4
	}
	var_9_5[var_9_9] = {
		size = arg_9_1,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_9_6[1],
			var_9_6[2],
			0
		}
	}
	var_9_4[var_9_9] = {
		uvs = {
			{
				0,
				1 - math.min(arg_9_1[2] / var_9_1.size[2], 1)
			},
			{
				math.min(arg_9_1[1] / var_9_1.size[1], 1),
				1
			}
		},
		texture_id = var_9_0
	}

	local var_9_10 = "background_fade"

	var_9_3[#var_9_3 + 1] = {
		pass_type = "texture",
		content_id = var_9_7,
		texture_id = var_9_10,
		style_id = var_9_10,
		content_check_function = arg_9_4
	}
	var_9_5[var_9_10] = {
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
			var_9_6[1],
			var_9_6[2],
			1
		}
	}
	var_9_8[var_9_10] = "button_bg_fade"

	local var_9_11 = "hover_glow"

	var_9_3[#var_9_3 + 1] = {
		pass_type = "texture",
		content_id = var_9_7,
		texture_id = var_9_11,
		style_id = var_9_11,
		content_check_function = arg_9_4
	}
	var_9_5[var_9_11] = {
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
			var_9_6[1],
			var_9_6[2] + 5,
			2
		}
	}
	var_9_8[var_9_11] = "button_state_default"

	local var_9_12 = "clicked_rect"

	var_9_3[#var_9_3 + 1] = {
		pass_type = "rect",
		content_id = var_9_7,
		style_id = var_9_12,
		content_check_function = arg_9_4
	}
	var_9_5[var_9_12] = {
		size = arg_9_1,
		color = {
			100,
			0,
			0,
			0
		},
		offset = {
			var_9_6[1],
			var_9_6[2],
			6
		}
	}

	local var_9_13 = "glass_top"

	var_9_3[#var_9_3 + 1] = {
		pass_type = "texture",
		content_id = var_9_7,
		texture_id = var_9_13,
		style_id = var_9_13,
		content_check_function = arg_9_4
	}
	var_9_5[var_9_13] = {
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
			var_9_6[1],
			var_9_6[2] + arg_9_1[2] - 11,
			5
		}
	}
	var_9_8[var_9_13] = "button_glass_02"

	local var_9_14 = "glass_bottom"

	var_9_3[#var_9_3 + 1] = {
		pass_type = "texture",
		content_id = var_9_7,
		texture_id = var_9_14,
		style_id = var_9_14,
		content_check_function = arg_9_4
	}
	var_9_5[var_9_14] = {
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
			var_9_6[1],
			var_9_6[2] - 3,
			5
		}
	}
	var_9_8[var_9_14] = "button_glass_02"

	local var_9_15 = "text"

	var_9_3[#var_9_3 + 1] = {
		pass_type = "text",
		content_id = var_9_7,
		text_id = var_9_15,
		style_id = var_9_15,
		content_check_function = arg_9_4
	}
	var_9_5[var_9_15] = {
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
			10 + var_9_6[1],
			var_9_6[2] + 3,
			4
		},
		size = {
			arg_9_1[1] - 20,
			arg_9_1[2]
		}
	}
	var_9_8[var_9_15] = arg_9_2

	local var_9_16 = "text_shadow"

	var_9_3[#var_9_3 + 1] = {
		pass_type = "text",
		content_id = var_9_7,
		text_id = var_9_15,
		style_id = var_9_16,
		content_check_function = arg_9_4
	}
	var_9_5[var_9_16] = {
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
			10 + var_9_6[1] + 2,
			var_9_6[2] + 2,
			3
		},
		size = {
			arg_9_1[1] - 20,
			arg_9_1[2]
		}
	}
	var_9_2.element.passes = var_9_3
	var_9_2.content = var_9_4
	var_9_2.style = var_9_5
	var_9_2.offset = {
		0,
		0,
		0
	}
	var_9_2.scenegraph_id = arg_9_0

	return var_9_2
end

local var_0_9 = {
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

local function var_0_10(arg_10_0)
	return not Managers.twitch:is_connecting() and not Managers.twitch:is_connected()
end

local function var_0_11(arg_11_0)
	return not Managers.twitch:is_connecting() and Managers.twitch:is_connected()
end

local function var_0_12(arg_12_0)
	return Managers.twitch:is_connecting() or not Managers.twitch:is_connected()
end

local var_0_13 = "start_game_window_twitch_connect_description"
local var_0_14 = {
	background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window"),
	background_mask = UIWidgets.create_simple_texture("mask_rect", "window"),
	window = UIWidgets.create_frame("window", var_0_2, var_0_1, 20),
	frame_widget = var_0_7("window", var_0_6.window.size),
	login_text_frame = UIWidgets.create_frame("login_text_frame", {
		var_0_4,
		50
	}, "menu_frame_09", 1),
	chat_feed_frame = UIWidgets.create_frame("chat_feed_frame", {
		var_0_4 - 20,
		250
	}, "menu_frame_09", 1),
	description_text = UIWidgets.create_simple_text(Localize(var_0_13), "description_text", nil, nil, var_0_9),
	twitch_texture = UIWidgets.create_simple_texture("twitch_logo", "twitch_texture"),
	twitch_title_divider = UIWidgets.create_simple_texture("divider_01_top", "twitch_title_divider"),
	chat_output_widget = var_0_8,
	button_1 = create_button("connect_button", var_0_6.connect_button.size, Localize("start_game_window_twitch_connect"), 24, var_0_10),
	button_2 = create_button("disconnect_button", var_0_6.disconnect_button.size, string.format(Localize("start_game_window_twitch_disconnect"), "N/A"), 24, var_0_11),
	connect_button_frame = UIWidgets.create_frame("connect_button_frame", var_0_6.connect_button_frame.size, var_0_1, 1),
	disconnect_button_frame = UIWidgets.create_frame("disconnect_button_frame", var_0_6.disconnect_button_frame.size, var_0_1, 1)
}

var_0_14.login_text_frame.element.passes[1].content_check_function = var_0_10
var_0_14.connect_button_frame.element.passes[1].content_check_function = var_0_10
var_0_14.disconnect_button_frame.element.passes[1].content_check_function = var_0_11
var_0_14.chat_feed_frame.element.passes[1].content_check_function = var_0_11
var_0_14.description_text.element.passes[1].content_check_function = var_0_12
var_0_14.description_text.element.passes[2].content_check_function = var_0_12

return {
	widgets = var_0_14,
	scenegraph_definition = var_0_6
}
