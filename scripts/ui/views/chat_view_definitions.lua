-- chunkname: @scripts/ui/views/chat_view_definitions.lua

local var_0_0 = 800
local var_0_1 = "menu_frame_06"
local var_0_2 = UIFrameSettings[var_0_1].texture_sizes.corner[2]
local var_0_3 = 12
local var_0_4 = "menu_frame_06"
local var_0_5 = UIFrameSettings[var_0_4]
local var_0_6 = var_0_5.texture_sizes.horizontal[2]
local var_0_7 = (var_0_0 - var_0_2 * 2) / var_0_3
local var_0_8 = {
	emoji_width_spacing = 5,
	max_rows = 7,
	emoji_height_spacing = 5,
	emojis_per_row = 9,
	emoji_size = {
		35,
		35
	},
	emoji_offset = {
		5,
		2
	}
}
local var_0_9 = {
	max_rows = 6,
	channels_per_row = 3,
	channels_width_spacing = 5,
	channels_height_spacing = 5,
	channels_offset = {
		10,
		-10,
		0
	}
}
local var_0_10 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.default
		},
		size = {
			1920,
			1080
		}
	},
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.default
		},
		size = {
			1920,
			1080
		}
	},
	popup_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			1200,
			1000
		}
	},
	input_field = {
		vertical_alignment = "bottom",
		parent = "popup_root",
		horizontal_alignment = "left",
		position = {
			0,
			100,
			1
		},
		size = {
			625,
			50
		},
		position = {
			150,
			50,
			2
		}
	},
	commands_list = {
		vertical_alignment = "bottom",
		parent = "input_field",
		horizontal_alignment = "left",
		position = {
			25,
			65,
			12
		},
		size = {
			400,
			300
		}
	},
	commands_list_entry = {
		vertical_alignment = "top",
		parent = "commands_list",
		horizontal_alignment = "left",
		position = {
			0,
			5,
			1
		},
		size = {
			500,
			20
		}
	},
	filtered_user_names_list = {
		vertical_alignment = "bottom",
		parent = "input_field",
		horizontal_alignment = "left",
		position = {
			25,
			60,
			12
		},
		size = {
			400,
			300
		}
	},
	filtered_user_names_list_entry = {
		vertical_alignment = "top",
		parent = "filtered_user_names_list",
		horizontal_alignment = "left",
		position = {
			0,
			5,
			1
		},
		size = {
			500,
			20
		}
	},
	logo = {
		vertical_alignment = "top",
		parent = "popup_root",
		horizontal_alignment = "center",
		position = {
			0,
			-50,
			1
		},
		size = {
			600,
			216
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "logo",
		horizontal_alignment = "center",
		position = {
			0,
			-100,
			1
		},
		size = {
			800,
			0
		}
	},
	connecting = {
		vertical_alignment = "center",
		parent = "popup_root",
		horizontal_alignment = "center",
		position = {
			120,
			-50,
			1
		},
		size = {
			400,
			50
		}
	},
	popup_text_box = {
		vertical_alignment = "center",
		parent = "popup_root",
		horizontal_alignment = "center",
		position = {
			-100,
			-50,
			1
		},
		size = {
			400,
			50
		}
	},
	popup_text = {
		vertical_alignment = "top",
		parent = "logo",
		horizontal_alignment = "center",
		position = {
			0,
			-150,
			2
		},
		size = {
			520,
			260
		}
	},
	twitch_connect_button = {
		vertical_alignment = "center",
		parent = "popup_text_box",
		horizontal_alignment = "left",
		position = {
			420,
			0,
			2
		},
		size = {
			188,
			50
		}
	},
	twitch_disconnect_button = {
		vertical_alignment = "center",
		parent = "popup_root",
		horizontal_alignment = "center",
		position = {
			0,
			-50,
			2
		},
		size = {
			188,
			50
		}
	},
	glass_indicator = {
		vertical_alignment = "top",
		parent = "popup_root",
		horizontal_alignment = "right",
		size = {
			40,
			40
		},
		position = {
			-20,
			-20,
			1
		}
	},
	fuzzy_circle = {
		vertical_alignment = "center",
		parent = "glass_indicator",
		horizontal_alignment = "center",
		size = {
			90,
			90
		}
	},
	feed_area_edge = {
		vertical_alignment = "bottom",
		parent = "popup_root",
		horizontal_alignment = "left",
		size = {
			730,
			800
		},
		position = {
			50,
			110,
			2
		}
	},
	feed_area_top = {
		vertical_alignment = "center",
		parent = "feed_area_edge",
		horizontal_alignment = "center",
		size = {
			686,
			796
		}
	},
	channel_tab_anchor = {
		vertical_alignment = "top",
		parent = "feed_area_top",
		horizontal_alignment = "left",
		size = {
			167,
			40
		},
		position = {
			10,
			40,
			2
		}
	},
	feed_area = {
		vertical_alignment = "center",
		parent = "feed_area_top",
		horizontal_alignment = "center",
		size = {
			690 - var_0_6 * 2 + 25,
			800 - var_0_6 * 2 - 7.5
		}
	},
	list_area = {
		vertical_alignment = "top",
		parent = "feed_area_edge",
		horizontal_alignment = "right",
		size = {
			370,
			var_0_0
		},
		position = {
			380,
			0,
			1
		}
	},
	entry_root = {
		vertical_alignment = "top",
		parent = "list_area",
		horizontal_alignment = "left",
		size = {
			400 - var_0_2 * 2 - 30,
			var_0_7
		},
		position = {
			var_0_2,
			-var_0_2,
			0
		}
	},
	temp_user_list_area = {
		vertical_alignment = "center",
		parent = "list_area",
		horizontal_alignment = "center",
		position = {
			300,
			0,
			0
		},
		size = {
			190,
			780
		}
	},
	down_arrow = {
		vertical_alignment = "top",
		parent = "popup_root",
		horizontal_alignment = "left",
		position = {
			25,
			-20,
			10
		},
		size = {
			60,
			45
		}
	},
	channel_list = {
		vertical_alignment = "top",
		parent = "down_arrow",
		horizontal_alignment = "left",
		position = {
			25,
			-55,
			12
		},
		size = {
			400,
			300
		}
	},
	channel_list_entry = {
		vertical_alignment = "top",
		parent = "channel_list",
		horizontal_alignment = "left",
		position = {
			0,
			-5,
			1
		},
		size = {
			500,
			30
		}
	},
	exit_button = {
		vertical_alignment = "top",
		parent = "channel_list",
		horizontal_alignment = "right",
		position = {
			-25,
			0,
			1
		},
		size = {
			40,
			40
		}
	},
	private_messages_button = {
		vertical_alignment = "bottom",
		parent = "list_area",
		horizontal_alignment = "left",
		position = {
			0,
			-53,
			1
		},
		size = {
			120,
			44
		}
	},
	private_user_list = {
		vertical_alignment = "top",
		parent = "private_messages_button",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			12
		},
		size = {
			400,
			300
		}
	},
	private_user_list_entry = {
		vertical_alignment = "top",
		parent = "private_user_list",
		horizontal_alignment = "left",
		position = {
			0,
			5,
			1
		},
		size = {
			500,
			30
		}
	},
	exit_button_private_user = {
		vertical_alignment = "top",
		parent = "private_user_list",
		horizontal_alignment = "right",
		position = {
			-25,
			0,
			1
		},
		size = {
			25,
			25
		}
	},
	channels_button = {
		vertical_alignment = "bottom",
		parent = "private_messages_button",
		horizontal_alignment = "right",
		position = {
			125,
			0,
			1
		},
		size = {
			120,
			44
		}
	},
	channels_button_list = {
		vertical_alignment = "top",
		parent = "channels_button",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			12
		},
		size = {
			400,
			300
		}
	},
	channels_button_list_entry = {
		vertical_alignment = "top",
		parent = "channels_button_list",
		horizontal_alignment = "left",
		position = {
			0,
			5,
			1
		},
		size = {
			500,
			30
		}
	},
	exit_button_channel = {
		vertical_alignment = "top",
		parent = "channels_button_list",
		horizontal_alignment = "right",
		position = {
			-25,
			0,
			1
		},
		size = {
			25,
			25
		}
	},
	popular_channels_button = {
		vertical_alignment = "bottom",
		parent = "channels_button",
		horizontal_alignment = "right",
		position = {
			125,
			0,
			1
		},
		size = {
			120,
			44
		}
	},
	popular_channels_button_list = {
		vertical_alignment = "top",
		parent = "popular_channels_button",
		horizontal_alignment = "right",
		position = {
			0,
			0,
			12
		},
		size = {
			400,
			300
		}
	},
	popular_channels_button_list_entry = {
		vertical_alignment = "top",
		parent = "popular_channels_button_list",
		horizontal_alignment = "left",
		position = {
			0,
			5,
			1
		},
		size = {
			500,
			30
		}
	},
	commands_button = {
		vertical_alignment = "bottom",
		parent = "input_field",
		horizontal_alignment = "left",
		position = {
			-50,
			7.5,
			1
		},
		size = {
			44,
			44
		}
	},
	emoji_button = {
		vertical_alignment = "bottom",
		parent = "commands_button",
		horizontal_alignment = "left",
		position = {
			-50,
			0,
			0
		},
		size = {
			44,
			44
		}
	},
	emoji_frame = {
		vertical_alignment = "bottom",
		parent = "feed_area",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			15
		},
		size = {
			500,
			500
		}
	},
	emoji_scrollbar = {
		vertical_alignment = "top",
		parent = "emoji_frame",
		horizontal_alignment = "right",
		position = {
			-15,
			-12,
			10
		},
		size = {
			10,
			500
		}
	},
	emoji = {
		vertical_alignment = "bottom",
		parent = "feed_area",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			16
		},
		size = {
			32,
			32
		}
	},
	channels_window_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			100
		},
		size = {
			800,
			500
		}
	},
	channels_window_text_box = {
		vertical_alignment = "top",
		parent = "channels_window_root",
		horizontal_alignment = "right",
		position = {
			-40,
			-110,
			1
		},
		size = {
			300,
			40
		}
	},
	channels_window_text = {
		vertical_alignment = "top",
		parent = "channels_window_text_box",
		horizontal_alignment = "center",
		position = {
			0,
			-150,
			2
		},
		size = {
			520,
			260
		}
	},
	channels_window_list_box = {
		vertical_alignment = "bottom",
		parent = "channels_window_root",
		horizontal_alignment = "center",
		position = {
			0,
			80,
			2
		},
		size = {
			720,
			260
		}
	},
	channels_window_list_box_entry = {
		vertical_alignment = "top",
		parent = "channels_window_list_box",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			2
		},
		size = {
			0,
			0
		}
	},
	channels_window_close = {
		vertical_alignment = "top",
		parent = "channels_window_root",
		horizontal_alignment = "right",
		position = {
			-10,
			-10,
			2
		},
		size = {
			40,
			40
		}
	},
	join_channel_button = {
		vertical_alignment = "bottom",
		parent = "channels_window_root",
		horizontal_alignment = "right",
		position = {
			-40,
			20,
			1
		},
		size = {
			120,
			44
		}
	},
	create_channel_button = {
		vertical_alignment = "bottom",
		parent = "channels_window_root",
		horizontal_alignment = "left",
		position = {
			40,
			20,
			1
		},
		size = {
			120,
			44
		}
	},
	recent_channels_button = {
		vertical_alignment = "bottom",
		parent = "create_channel_button",
		horizontal_alignment = "left",
		position = {
			140,
			0,
			1
		},
		size = {
			120,
			44
		}
	},
	channels_window_list_header = {
		vertical_alignment = "top",
		parent = "channels_window_root",
		horizontal_alignment = "center",
		position = {
			0,
			25,
			5
		},
		size = {
			200,
			50
		}
	},
	create_channels_window_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			100
		},
		size = {
			500,
			250
		}
	},
	create_channel_input = {
		vertical_alignment = "center",
		parent = "create_channels_window_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			300,
			40
		}
	},
	create_channel_window_close = {
		vertical_alignment = "top",
		parent = "create_channels_window_root",
		horizontal_alignment = "right",
		position = {
			-10,
			-10,
			2
		},
		size = {
			40,
			40
		}
	},
	create_channel_window_list_header = {
		vertical_alignment = "top",
		parent = "create_channels_window_root",
		horizontal_alignment = "center",
		position = {
			0,
			25,
			5
		},
		size = {
			300,
			50
		}
	},
	inner_create_channel_button = {
		vertical_alignment = "bottom",
		parent = "create_channels_window_root",
		horizontal_alignment = "center",
		position = {
			0,
			20,
			1
		},
		size = {
			120,
			44
		}
	},
	recent_channels_window_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			100
		},
		size = {
			500,
			500
		}
	},
	recent_join_channel_button = {
		vertical_alignment = "bottom",
		parent = "recent_channels_window_root",
		horizontal_alignment = "center",
		position = {
			0,
			20,
			1
		},
		size = {
			120,
			44
		}
	},
	recent_channel_window_list_header = {
		vertical_alignment = "top",
		parent = "recent_channels_window_root",
		horizontal_alignment = "center",
		position = {
			0,
			25,
			5
		},
		size = {
			300,
			50
		}
	},
	recent_channels_window_list_box = {
		vertical_alignment = "center",
		parent = "recent_channels_window_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			260,
			290
		}
	},
	recent_channels_window_list_box_entry = {
		vertical_alignment = "top",
		parent = "recent_channels_window_list_box",
		horizontal_alignment = "center",
		position = {
			0,
			-5,
			2
		},
		size = {
			250,
			52
		}
	},
	recent_channels_window_close = {
		vertical_alignment = "top",
		parent = "recent_channels_window_root",
		horizontal_alignment = "right",
		position = {
			-10,
			-10,
			2
		},
		size = {
			40,
			40
		}
	},
	send_invite_button = {
		vertical_alignment = "bottom",
		parent = "create_channels_window_root",
		horizontal_alignment = "center",
		position = {
			0,
			20,
			1
		},
		size = {
			200,
			44
		}
	}
}

local function var_0_11(arg_1_0, arg_1_1)
	local var_1_0 = "menu_frame_bg_03"
	local var_1_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_0)
	local var_1_2 = UIFrameSettings.menu_frame_02
	local var_1_3 = UIFrameSettings.menu_frame_06
	local var_1_4 = {
		element = {}
	}
	local var_1_5 = {
		{
			style_id = "left_arrow_top",
			pass_type = "triangle",
			content_change_function = function(arg_2_0, arg_2_1)
				arg_2_1.color = arg_2_0.left_hotspot.is_hover and arg_2_1.hover_color or arg_2_1.base_color
			end
		},
		{
			style_id = "left_arrow_bottom",
			pass_type = "triangle",
			content_change_function = function(arg_3_0, arg_3_1)
				arg_3_1.color = arg_3_0.left_hotspot.is_hover and arg_3_1.hover_color or arg_3_1.base_color
			end
		},
		{
			style_id = "right_arrow_top",
			pass_type = "triangle",
			content_change_function = function(arg_4_0, arg_4_1)
				arg_4_1.color = arg_4_0.right_hotspot.is_hover and arg_4_1.hover_color or arg_4_1.base_color
			end
		},
		{
			style_id = "right_arrow_bottom",
			pass_type = "triangle",
			content_change_function = function(arg_5_0, arg_5_1)
				arg_5_1.color = arg_5_0.right_hotspot.is_hover and arg_5_1.hover_color or arg_5_1.base_color
			end
		},
		{
			pass_type = "rect",
			style_id = "outer_tab_bg_left"
		},
		{
			pass_type = "rect",
			style_id = "inner_tab_bg_left"
		},
		{
			pass_type = "rect",
			style_id = "outer_tab_bg_right"
		},
		{
			pass_type = "rect",
			style_id = "inner_tab_bg_right"
		},
		{
			style_id = "left_hotspot",
			pass_type = "hotspot",
			content_id = "left_hotspot"
		},
		{
			style_id = "right_hotspot",
			pass_type = "hotspot",
			content_id = "right_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "mask",
			texture_id = "mask_id"
		},
		{
			scenegraph_id = "input_field",
			pass_type = "hotspot",
			content_id = "text_input_hotspot"
		},
		{
			scenegraph_id = "root",
			pass_type = "hotspot",
			content_id = "screen_hotspot"
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background_id"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "rect",
			style_id = "inner_rect"
		},
		{
			pass_type = "rect",
			style_id = "inner_inner_rect"
		},
		{
			pass_type = "texture",
			style_id = "background_tint",
			texture_id = "background_tint"
		},
		{
			style_id = "chat_text",
			pass_type = "text",
			text_id = "real_chat_text",
			content_check_function = function(arg_6_0, arg_6_1)
				if not arg_6_0.text_field_active then
					return false
				else
					arg_6_1.caret_color[1] = 128 + math.sin(Managers.time:time("ui") * 5) * 128
				end

				arg_6_0.real_chat_text = arg_6_0.chat_text.text

				return true
			end
		},
		{
			style_id = "chat_hint",
			pass_type = "text",
			text_id = "chat_hint",
			content_check_function = function(arg_7_0, arg_7_1)
				if arg_7_0.text_input_hotspot.is_hover then
					arg_7_1.text_color = {
						128,
						255,
						255,
						255
					}
				else
					arg_7_1.text_color = {
						60,
						255,
						255,
						255
					}
				end

				return arg_7_0.chat_text.text == "" and not arg_7_0.text_field_active
			end
		},
		{
			style_id = "private_user_name",
			pass_type = "text",
			text_id = "trimmed_private_user_name",
			content_check_function = function(arg_8_0)
				if not arg_8_0.private_user_name then
					return false
				end

				return true
			end
		}
	}
	local var_1_6 = {
		text_field_active = false,
		text_start_offset = 0,
		channel_arrow_id = "down_arrow",
		text_index = 1,
		chat_hint = "Press Enter to chat or / for commands",
		channel_name = " ",
		caret_index = 1,
		mask_id = "mask_rect",
		background_tint = "gradient_dice_game_reward",
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
		background_id = var_1_0,
		text_input_hotspot = {},
		screen_hotspot = {},
		channel_hotspot = {},
		left_hotspot = {},
		right_hotspot = {},
		chat_text = {
			text = ""
		}
	}
	local var_1_7 = {
		left_hotspot = {
			color = {
				50,
				255,
				255,
				255
			},
			offset = {
				50,
				910,
				100
			},
			size = {
				28,
				35
			}
		},
		right_hotspot = {
			color = {
				50,
				255,
				255,
				255
			},
			offset = {
				750,
				910,
				100
			},
			size = {
				28,
				35
			}
		},
		left_arrow_top = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			triangle_alignment = "bottom_right",
			base_color = {
				255,
				105,
				90,
				70
			},
			hover_color = {
				255,
				210,
				180,
				140
			},
			texture_size = {
				12,
				12
			},
			offset = {
				63,
				-61,
				100
			}
		},
		left_arrow_bottom = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			triangle_alignment = "top_right",
			base_color = {
				255,
				105,
				90,
				70
			},
			hover_color = {
				255,
				210,
				180,
				140
			},
			texture_size = {
				12,
				12
			},
			offset = {
				63,
				-73,
				100
			}
		},
		right_arrow_top = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			triangle_alignment = "bottom_left",
			base_color = {
				255,
				105,
				90,
				70
			},
			hover_color = {
				255,
				210,
				180,
				140
			},
			texture_size = {
				12,
				12
			},
			offset = {
				758,
				-61,
				100
			}
		},
		right_arrow_bottom = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			triangle_alignment = "top_left",
			base_color = {
				255,
				105,
				90,
				70
			},
			hover_color = {
				255,
				210,
				180,
				140
			},
			texture_size = {
				12,
				12
			},
			offset = {
				758,
				-73,
				100
			}
		},
		inner_tab_bg_left = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = {
				255,
				20,
				20,
				20
			},
			texture_size = {
				21,
				33
			},
			offset = {
				60,
				-57,
				3
			}
		},
		outer_tab_bg_left = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = {
				255,
				0,
				0,
				0
			},
			texture_size = {
				25,
				35
			},
			offset = {
				58,
				-55,
				2
			}
		},
		inner_tab_bg_right = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = {
				255,
				20,
				20,
				20
			},
			texture_size = {
				21,
				33
			},
			offset = {
				752,
				-57,
				3
			}
		},
		outer_tab_bg_right = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = {
				255,
				0,
				0,
				0
			},
			texture_size = {
				25,
				35
			},
			offset = {
				750,
				-55,
				2
			}
		},
		mask = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = {
				671,
				35
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				79,
				-55,
				100
			}
		},
		background = {
			color = {
				255,
				60,
				60,
				60
			},
			offset = {
				0,
				0,
				1
			},
			texture_tiling_size = var_1_1.size
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
		background_tint = {
			scenegraph_id = "screen",
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
		inner_rect = {
			scenegraph_id = "input_field",
			color = {
				255,
				128,
				128,
				128
			},
			offset = {
				0,
				10,
				0
			},
			size = {
				625,
				40
			}
		},
		inner_inner_rect = {
			scenegraph_id = "input_field",
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				2,
				12,
				0
			},
			size = {
				621,
				36
			}
		},
		chat_hint = {
			word_wrap = true,
			scenegraph_id = "input_field",
			font_size = 28,
			pixel_perfect = true,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = {
				60,
				255,
				255,
				255
			},
			offset = {
				25,
				10,
				10
			}
		},
		chat_text = {
			horizontal_scroll = true,
			scenegraph_id = "input_field",
			word_wrap = false,
			pixel_perfect = true,
			horizontal_alignment = "left",
			font_size = 16,
			vertical_alignment = "bottom",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("white"),
			offset = {
				10,
				20,
				10
			},
			size = {
				var_0_10.input_field.size[1] - 10,
				var_0_10.input_field.size[2]
			},
			caret_size = {
				2,
				18
			},
			caret_offset = {
				-2,
				-2,
				4
			},
			caret_color = Colors.get_table("white")
		},
		channel = {
			word_wrap = false,
			scenegraph_id = "popup_root",
			font_size = 36,
			pixel_perfect = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("cheeseburger"),
			offset = {
				85,
				-35,
				10
			}
		},
		private_user_name = {
			word_wrap = false,
			scenegraph_id = "popup_root",
			font_size = 36,
			pixel_perfect = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("medium_purple"),
			offset = {
				85,
				-35,
				10
			}
		},
		channel_arrow = {
			vertical_alignment = "top",
			scenegraph_id = "popup_root",
			horizontal_alignment = "left",
			offset = {
				50,
				-43,
				10
			},
			texture_size = {
				20,
				15
			},
			color = Colors.get_table("cheeseburger")
		}
	}

	var_1_4.element.passes = var_1_5
	var_1_4.content = var_1_6
	var_1_4.style = var_1_7
	var_1_4.offset = {
		0,
		0,
		0
	}
	var_1_4.scenegraph_id = arg_1_0

	return var_1_4
end

local function var_0_12(arg_9_0, arg_9_1)
	local var_9_0 = {
		element = {}
	}
	local var_9_1 = {
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			style_id = "text",
			pass_type = "text_area_chat",
			text_id = "text_field",
			content_check_function = function(arg_10_0, arg_10_1)
				if arg_10_0.private_user_name then
					return false
				end

				arg_10_0.message_tables = arg_10_0.channel_messages_table[arg_10_0.channel_name] or {}

				return true
			end
		},
		{
			style_id = "text",
			pass_type = "text_area_chat",
			text_id = "text_field",
			content_check_function = function(arg_11_0, arg_11_1)
				if not arg_11_0.private_user_name then
					return false
				end

				arg_11_0.message_tables = arg_11_0.private_messages_table[arg_11_0.private_user_name] or {}

				return true
			end
		}
	}
	local var_9_2 = {
		text_start_offset = 0,
		channel_name = " ",
		mask_id = "mask_rect",
		channel_messages_table = {},
		private_messages_table = {},
		message_tables = {},
		frame = var_0_5.texture
	}
	local var_9_3 = {
		mask = {
			corner_radius = 0,
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
		frame = {
			texture_size = var_0_5.texture_size,
			texture_sizes = var_0_5.texture_sizes,
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
		background = {
			offset = {
				0,
				0,
				0
			},
			color = {
				160,
				0,
				0,
				0
			}
		},
		text = {
			font_size = 16,
			scenegraph_id = "feed_area",
			spacing = 7,
			pixel_perfect = false,
			vertical_alignment = "bottom",
			dynamic_font = true,
			word_wrap = true,
			font_type = "chat_output_font",
			text_color = Colors.get_table("white"),
			name_color = Colors.get_table("sky_blue"),
			name_color_dev = Colors.get_table("cheeseburger"),
			name_color_system = Colors.get_table("gold"),
			emoji_size = {
				24,
				24
			},
			offset = {
				0,
				0,
				3
			}
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

local function var_0_13(arg_12_0, arg_12_1)
	local var_12_0 = {
		element = {}
	}
	local var_12_1 = {
		{
			pass_type = "texture",
			style_id = "mask",
			texture_id = "mask_id"
		},
		{
			pass_type = "rounded_background",
			style_id = "edge"
		},
		{
			pass_type = "rounded_background",
			style_id = "background"
		},
		{
			style_id = "text",
			pass_type = "user_list_chat",
			text_id = "text_field",
			content_check_function = function(arg_13_0, arg_13_1)
				arg_13_0.message_tables = arg_13_0.channel_messages_table[arg_13_0.channel_name] or {}

				return true
			end
		}
	}
	local var_12_2 = {
		text_start_offset = 0,
		channel_name = " ",
		mask_id = "mask_rect",
		channel_messages_table = {},
		message_tables = {}
	}
	local var_12_3 = {
		mask = {
			corner_radius = 0,
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
			},
			scenegraph_id = arg_12_0 .. "_top"
		},
		edge = {
			corner_radius = 0,
			offset = {
				0,
				0,
				1
			},
			color = {
				60,
				255,
				255,
				255
			},
			scenegraph_id = arg_12_0 .. "_edge"
		},
		background = {
			corner_radius = 0,
			offset = {
				0,
				0,
				0
			},
			color = Colors.get_color_table_with_alpha("black", 255),
			scenegraph_id = arg_12_0 .. "_top"
		},
		text = {
			word_wrap = true,
			font_size = 18,
			pixel_perfect = false,
			vertical_alignment = "top",
			dynamic_font = true,
			font_type = "hell_shark_arial_masked",
			text_color = Colors.get_table("white"),
			name_color = Colors.get_table("sky_blue"),
			name_color_dev = Colors.get_table("cheeseburger"),
			name_color_system = Colors.get_table("gold"),
			offset = {
				0,
				arg_12_1,
				3
			},
			scenegraph_id = arg_12_0
		}
	}

	var_12_0.element.passes = var_12_1
	var_12_0.content = var_12_2
	var_12_0.style = var_12_3
	var_12_0.offset = {
		0,
		0,
		0
	}
	var_12_0.scenegraph_id = arg_12_0

	return var_12_0
end

local function var_0_14(arg_14_0)
	local var_14_0 = "entry_root"
	local var_14_1 = var_0_10[var_14_0].size
	local var_14_2 = UIFrameSettings.menu_frame_06
	local var_14_3 = {
		0,
		-(var_0_7 * (arg_14_0 - 1)),
		0
	}

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture"
				},
				{
					style_id = "level_text",
					pass_type = "text",
					text_id = "level_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_15_0)
						local var_15_0 = arg_15_0.button_hotspot

						return not var_15_0.is_selected and not var_15_0.is_hover
					end
				},
				{
					style_id = "title_text_hover",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_16_0)
						local var_16_0 = arg_16_0.button_hotspot

						return not var_16_0.disable_button and (var_16_0.is_selected or var_16_0.is_hover)
					end
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture",
					content_check_function = function(arg_17_0)
						local var_17_0 = arg_17_0.button_hotspot

						return not var_17_0.disable_button and (var_17_0.is_selected or var_17_0.is_hover)
					end
				}
			}
		},
		content = {
			level_text = "n/a",
			title_text = "n/a",
			glow = "tabs_glow",
			description_text = "n/a",
			icon = "icons_placeholder",
			button_hotspot = {},
			frame = var_14_2.texture
		},
		style = {
			icon = {
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
				},
				size = {
					var_14_1[2],
					var_14_1[2]
				}
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
			title_text = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				dynamic_font_size = true,
				font_size = 24,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				size = {
					var_0_10[var_14_0].size[1] - 70,
					var_0_10[var_14_0].size[2]
				},
				offset = {
					var_14_1[2] + var_0_2,
					-10,
					3
				}
			},
			title_text_hover = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				dynamic_font_size = true,
				font_size = 24,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				size = {
					var_0_10[var_14_0].size[1] - 70,
					var_0_10[var_14_0].size[2]
				},
				offset = {
					var_14_1[2] + var_0_2,
					-10,
					3
				}
			},
			level_text = {
				vertical_alignment = "bottom",
				font_size = 20,
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("rosy_brown", 255),
				offset = {
					var_14_1[2] + var_0_2,
					4,
					3
				}
			},
			description_text = {
				vertical_alignment = "bottom",
				font_size = 20,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_14_1[2] + var_0_2,
					4,
					3
				}
			},
			frame = {
				texture_size = var_14_2.texture_size,
				texture_sizes = var_14_2.texture_sizes,
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
				}
			},
			glow = {
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
			}
		},
		scenegraph_id = var_14_0,
		offset = var_14_3
	}
end

local var_0_15 = {
	scenegraph_id = "channel_list",
	element = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				scenegraph_id = "root",
				pass_type = "hotspot",
				content_id = "screen_hotspot"
			},
			{
				pass_type = "texture_frame",
				style_id = "frame",
				texture_id = "frame"
			},
			{
				pass_type = "rect",
				style_id = "rect"
			}
		}
	},
	content = {
		frame = UIFrameSettings.menu_frame_06.texture,
		hotspot = {},
		screen_hotspot = {}
	},
	style = {
		frame = {
			texture_size = UIFrameSettings.menu_frame_06.texture_size,
			texture_sizes = UIFrameSettings.menu_frame_06.texture_sizes,
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
		rect = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = Colors.get_table("black"),
			offset = {
				0,
				0,
				0
			}
		}
	},
	offset = {
		0,
		0,
		0
	}
}

local function var_0_16(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = UIFrameSettings.button_frame_01
	local var_18_1 = {
		element = {}
	}
	local var_18_2 = {
		{
			texture_id = "frame",
			style_id = "frame",
			pass_type = "texture_frame"
		},
		{
			pass_type = "texture",
			style_id = "inner_tab",
			texture_id = "texture_id"
		},
		{
			pass_type = "hotspot",
			content_id = "tab_hotspot"
		},
		{
			style_id = "channel_name",
			pass_type = "text",
			text_id = "channel_name",
			content_check_function = function(arg_19_0, arg_19_1)
				if arg_19_0.tab_hotspot.is_hover then
					arg_19_1.text_color = arg_19_1.hover_color
				elseif arg_19_0.selected then
					arg_19_1.text_color = arg_19_1.selected_color
				else
					arg_19_1.text_color = arg_19_1.base_color
				end

				return true
			end
		}
	}
	local var_18_3 = {
		texture_id = "rect_masked",
		tab_hotspot = {},
		exit_button_hotspot = {},
		channel_name = arg_18_0,
		frame = var_18_0.texture,
		selected = arg_18_2 == arg_18_0
	}
	local var_18_4 = {
		channel_name = {
			font_size = 18,
			pixel_perfect = false,
			vertical_alignment = "center",
			word_wrap = false,
			horizontal_alignment = "center",
			dynamic_font = true,
			dynamic_font_size = true,
			font_type = "hell_shark_arial_masked",
			text_color = Colors.get_table("white"),
			base_color = {
				255,
				128,
				128,
				128
			},
			selected_color = Colors.get_table("cheeseburger"),
			hover_color = Colors.get_table("white"),
			size = {
				var_0_10.channel_tab_anchor.size[1] - 10,
				var_0_10.channel_tab_anchor.size[2]
			},
			offset = {
				0,
				-5,
				-1
			}
		},
		tab = {
			vertical_alignment = "top",
			masked = true,
			horizontal_alignment = "left",
			color = {
				255,
				255,
				255,
				255
			},
			texture_size = var_0_10.channel_tab_anchor.size,
			offset = {
				0,
				0,
				-3
			}
		},
		inner_tab = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = {
				255,
				0,
				0,
				0
			},
			texture_size = {
				var_0_10.channel_tab_anchor.size[1] - 4,
				var_0_10.channel_tab_anchor.size[2] - 2
			},
			offset = {
				2,
				-2,
				-2
			}
		},
		frame = {
			masked = true,
			texture_size = var_18_0.texture_size,
			texture_sizes = var_18_0.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-4,
				0
			}
		}
	}

	var_18_1.element.passes = var_18_2
	var_18_1.content = var_18_3
	var_18_1.style = var_18_4
	var_18_1.offset = {
		(arg_18_1 - 1) * var_0_10.channel_tab_anchor.size[1],
		0,
		0
	}
	var_18_1.scenegraph_id = "channel_tab_anchor"

	return var_18_1
end

local var_0_17 = {
	scenegraph_id = "private_user_list",
	element = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				scenegraph_id = "root",
				pass_type = "hotspot",
				content_id = "screen_hotspot"
			},
			{
				pass_type = "texture_frame",
				style_id = "frame",
				texture_id = "frame"
			},
			{
				pass_type = "rect",
				style_id = "rect"
			}
		}
	},
	content = {
		frame = UIFrameSettings.menu_frame_06.texture,
		hotspot = {},
		screen_hotspot = {}
	},
	style = {
		frame = {
			texture_size = UIFrameSettings.menu_frame_06.texture_size,
			texture_sizes = UIFrameSettings.menu_frame_06.texture_sizes,
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
		rect = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = Colors.get_table("black"),
			offset = {
				0,
				0,
				0
			}
		}
	},
	offset = {
		0,
		0,
		0
	}
}
local var_0_18 = {
	scenegraph_id = "channels_button_list",
	element = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				scenegraph_id = "root",
				pass_type = "hotspot",
				content_id = "screen_hotspot"
			},
			{
				pass_type = "texture_frame",
				style_id = "frame",
				texture_id = "frame"
			},
			{
				pass_type = "rect",
				style_id = "rect"
			}
		}
	},
	content = {
		num_recent_channels = 0,
		frame = UIFrameSettings.menu_frame_06.texture,
		hotspot = {},
		screen_hotspot = {}
	},
	style = {
		frame = {
			texture_size = UIFrameSettings.menu_frame_06.texture_size,
			texture_sizes = UIFrameSettings.menu_frame_06.texture_sizes,
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
		rect = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = Colors.get_table("black"),
			offset = {
				0,
				0,
				0
			}
		}
	},
	offset = {
		0,
		0,
		0
	}
}
local var_0_19 = {
	scenegraph_id = "popular_channels_button_list",
	element = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				scenegraph_id = "root",
				pass_type = "hotspot",
				content_id = "screen_hotspot"
			},
			{
				pass_type = "texture_frame",
				style_id = "frame",
				texture_id = "frame"
			},
			{
				pass_type = "rect",
				style_id = "rect"
			}
		}
	},
	content = {
		frame = UIFrameSettings.menu_frame_06.texture,
		hotspot = {},
		screen_hotspot = {}
	},
	style = {
		frame = {
			texture_size = UIFrameSettings.menu_frame_06.texture_size,
			texture_sizes = UIFrameSettings.menu_frame_06.texture_sizes,
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
		rect = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = Colors.get_table("black"),
			offset = {
				0,
				0,
				0
			}
		}
	},
	offset = {
		0,
		0,
		0
	}
}

function create_channel_entry(arg_20_0, arg_20_1)
	local var_20_0 = {
		element = {}
	}
	local var_20_1 = {
		{
			style_id = "exit_button_hotspot",
			pass_type = "hotspot",
			content_id = "exit_button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "exit_button",
			texture_id = "exit_texture_id",
			content_check_function = function(arg_21_0)
				return not arg_21_0.exit_button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "exit_button_hover",
			texture_id = "exit_texture_hover_id",
			content_check_function = function(arg_22_0)
				return arg_22_0.exit_button_hotspot.is_hover
			end
		},
		{
			pass_type = "hotspot",
			content_id = "channel_hotspot"
		},
		{
			style_id = "channel_name",
			pass_type = "text",
			text_id = "channel_name",
			content_check_function = function(arg_23_0, arg_23_1)
				if arg_23_0.channel_hotspot.is_hover then
					arg_23_1.text_color = Colors.get_table("white")
				else
					arg_23_1.text_color = Colors.get_table("cheeseburger")
				end

				return true
			end
		}
	}
	local var_20_2 = {
		exit_texture_id = "tabs_icon_power",
		exit_texture_hover_id = "tabs_icon_power_glow",
		channel_hotspot = {},
		channel_name = arg_20_0,
		exit_button_hotspot = {}
	}
	local var_20_3 = {
		channel_name = {
			font_size = 18,
			word_wrap = false,
			pixel_perfect = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("white"),
			offset = {
				50,
				0,
				3
			}
		},
		exit_button_hotspot = {
			vertical_alignment = "top",
			scenegraph_id = "exit_button",
			horizontal_alignment = "right",
			offset = {
				0,
				arg_20_1,
				0
			}
		},
		exit_button_hover = {
			vertical_alignment = "top",
			scenegraph_id = "exit_button",
			horizontal_alignment = "right",
			offset = {
				0,
				arg_20_1 - 3,
				0
			},
			color = {
				255,
				255,
				30,
				30
			},
			texture_size = {
				30,
				30
			}
		},
		exit_button = {
			vertical_alignment = "top",
			scenegraph_id = "exit_button",
			horizontal_alignment = "right",
			offset = {
				0,
				arg_20_1 - 3,
				0
			},
			texture_size = {
				30,
				30
			}
		}
	}

	var_20_0.element.passes = var_20_1
	var_20_0.content = var_20_2
	var_20_0.style = var_20_3
	var_20_0.offset = {
		0,
		arg_20_1,
		0
	}
	var_20_0.scenegraph_id = "channel_list_entry"

	return var_20_0
end

function create_recent_channel_entry(arg_24_0, arg_24_1)
	local var_24_0 = {
		element = {}
	}
	local var_24_1 = {
		{
			pass_type = "hotspot",
			content_id = "channel_hotspot"
		},
		{
			style_id = "channel_name",
			pass_type = "text",
			text_id = "channel_name",
			content_check_function = function(arg_25_0, arg_25_1)
				if arg_25_0.channel_hotspot.is_hover then
					arg_25_1.text_color = Colors.get_table("white")
				else
					arg_25_1.text_color = Colors.get_table("cheeseburger")
				end

				return true
			end
		}
	}
	local var_24_2 = {
		exit_texture_id = "tabs_icon_power",
		exit_texture_hover_id = "tabs_icon_power_glow",
		channel_hotspot = {},
		channel_name = arg_24_0,
		exit_button_hotspot = {}
	}
	local var_24_3 = {
		channel_name = {
			font_size = 28,
			word_wrap = false,
			pixel_perfect = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("white"),
			offset = {
				50,
				0,
				3
			}
		}
	}

	var_24_0.element.passes = var_24_1
	var_24_0.content = var_24_2
	var_24_0.style = var_24_3
	var_24_0.offset = {
		0,
		arg_24_1,
		0
	}
	var_24_0.scenegraph_id = "channels_button_list_entry"

	return var_24_0
end

function create_popular_channels_entry(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = {
		element = {}
	}
	local var_26_1 = {
		{
			pass_type = "hotspot",
			content_id = "channel_hotspot"
		},
		{
			style_id = "channel_name",
			pass_type = "text",
			text_id = "channel_name",
			content_check_function = function(arg_27_0, arg_27_1)
				if arg_27_0.channel_hotspot.is_hover then
					arg_27_1.text_color = Colors.get_table("white")
				else
					arg_27_1.text_color = Colors.get_table("cheeseburger")
				end

				return true
			end
		},
		{
			style_id = "num_users",
			pass_type = "text",
			text_id = "num_users"
		}
	}
	local var_26_2 = {
		exit_texture_id = "tabs_icon_power",
		exit_texture_hover_id = "tabs_icon_power_glow",
		channel_hotspot = {},
		channel_name = arg_26_0,
		num_users = arg_26_1,
		exit_button_hotspot = {}
	}
	local var_26_3 = {
		channel_name = {
			font_size = 28,
			word_wrap = false,
			pixel_perfect = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("white"),
			offset = {
				50,
				0,
				3
			}
		},
		num_users = {
			font_size = 28,
			word_wrap = false,
			pixel_perfect = false,
			horizontal_alignment = "right",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("white"),
			offset = {
				50,
				0,
				3
			}
		}
	}

	var_26_0.element.passes = var_26_1
	var_26_0.content = var_26_2
	var_26_0.style = var_26_3
	var_26_0.offset = {
		0,
		arg_26_2,
		0
	}
	var_26_0.scenegraph_id = "popular_channels_button_list_entry"

	return var_26_0
end

function create_filtered_user_name_entry(arg_28_0, arg_28_1)
	local var_28_0 = {
		element = {}
	}
	local var_28_1 = {
		{
			pass_type = "hotspot",
			content_id = "user_name_hotspot"
		},
		{
			style_id = "user_name",
			pass_type = "text",
			text_id = "user_name",
			content_check_function = function(arg_29_0, arg_29_1)
				if arg_29_0.user_name_hotspot.is_hover then
					arg_29_1.text_color = Colors.get_table("white")
				else
					arg_29_1.text_color = Colors.get_table("medium_purple")
				end

				return true
			end
		}
	}
	local var_28_2 = {
		exit_texture_hover_id = "tabs_icon_power_glow",
		exit_texture_id = "tabs_icon_power",
		user_name_hotspot = {},
		user_name = arg_28_0,
		exit_button_hotspot = {}
	}
	local var_28_3 = {
		user_name = {
			font_size = 16,
			word_wrap = false,
			pixel_perfect = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("white"),
			offset = {
				30,
				0,
				3
			}
		}
	}

	var_28_0.element.passes = var_28_1
	var_28_0.content = var_28_2
	var_28_0.style = var_28_3
	var_28_0.offset = {
		0,
		arg_28_1,
		0
	}
	var_28_0.scenegraph_id = "filtered_user_names_list_entry"

	return var_28_0
end

function create_private_user_entry(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = {
		element = {}
	}
	local var_30_1 = string.sub(arg_30_0, 1, -11)
	local var_30_2 = {
		{
			style_id = "exit_button_hotspot",
			pass_type = "hotspot",
			content_id = "exit_button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "exit_button",
			texture_id = "exit_texture_id",
			content_check_function = function(arg_31_0)
				return not arg_31_0.exit_button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "exit_button_hover",
			texture_id = "exit_texture_hover_id",
			content_check_function = function(arg_32_0)
				return arg_32_0.exit_button_hotspot.is_hover
			end
		},
		{
			pass_type = "hotspot",
			content_id = "user_hotspot"
		},
		{
			style_id = "user_name",
			pass_type = "text",
			text_id = "trimmed_name",
			content_check_function = function(arg_33_0, arg_33_1)
				local var_33_0 = arg_33_1.selected_color
				local var_33_1 = arg_33_1.unselected_color

				if arg_33_0.user_hotspot.is_hover then
					arg_33_1.text_color = var_33_0
				else
					local var_33_2 = 1

					if arg_33_0.new then
						local var_33_3 = Managers.time:time("main")

						var_33_2 = 0.5 + math.sin(var_33_3 * 8) * 0.5
					end

					arg_33_1.current_color[2] = math.lerp(var_33_0[2], var_33_1[2], var_33_2)
					arg_33_1.current_color[3] = math.lerp(var_33_0[3], var_33_1[3], var_33_2)
					arg_33_1.current_color[4] = math.lerp(var_33_0[4], var_33_1[4], var_33_2)
					arg_33_1.text_color = arg_33_1.current_color
				end

				return true
			end
		}
	}
	local var_30_3 = {
		exit_texture_hover_id = "tabs_icon_power_glow",
		exit_texture_id = "tabs_icon_power",
		user_hotspot = {},
		user_name = arg_30_0,
		trimmed_name = var_30_1,
		exit_button_hotspot = {},
		new = arg_30_2
	}
	local var_30_4 = {
		user_name = {
			font_size = 16,
			horizontal_alignment = "left",
			word_wrap = false,
			pixel_perfect = false,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("medium_purple"),
			unselected_color = Colors.get_table("medium_purple"),
			selected_color = Colors.get_table("white"),
			current_color = Colors.get_table("white"),
			offset = {
				50,
				0,
				3
			}
		},
		exit_button_hotspot = {
			vertical_alignment = "top",
			scenegraph_id = "exit_button_private_user",
			horizontal_alignment = "right",
			offset = {
				0,
				arg_30_1 + 5,
				0
			}
		},
		exit_button_hover = {
			vertical_alignment = "top",
			scenegraph_id = "exit_button_private_user",
			horizontal_alignment = "right",
			offset = {
				0,
				arg_30_1 + 5,
				0
			},
			color = {
				255,
				255,
				30,
				30
			}
		},
		exit_button = {
			vertical_alignment = "top",
			scenegraph_id = "exit_button_private_user",
			horizontal_alignment = "right",
			offset = {
				0,
				arg_30_1 + 5,
				0
			}
		}
	}

	var_30_0.element.passes = var_30_2
	var_30_0.content = var_30_3
	var_30_0.style = var_30_4
	var_30_0.offset = {
		0,
		arg_30_1,
		0
	}
	var_30_0.scenegraph_id = "private_user_list_entry"

	return var_30_0
end

local var_0_20 = {
	scenegraph_id = "commands_list",
	element = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				scenegraph_id = "root",
				pass_type = "hotspot",
				content_id = "screen_hotspot"
			},
			{
				pass_type = "texture_frame",
				style_id = "frame",
				texture_id = "frame"
			},
			{
				pass_type = "rect",
				style_id = "rect"
			}
		}
	},
	content = {
		frame = UIFrameSettings.menu_frame_06.texture,
		hotspot = {},
		screen_hotspot = {}
	},
	style = {
		frame = {
			texture_size = UIFrameSettings.menu_frame_06.texture_size,
			texture_sizes = UIFrameSettings.menu_frame_06.texture_sizes,
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
		rect = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = Colors.get_table("black"),
			offset = {
				0,
				0,
				0
			}
		}
	},
	offset = {
		0,
		0,
		0
	}
}
local var_0_21 = {
	scenegraph_id = "filtered_user_names_list",
	element = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				scenegraph_id = "root",
				pass_type = "hotspot",
				content_id = "screen_hotspot"
			},
			{
				pass_type = "texture_frame",
				style_id = "frame",
				texture_id = "frame"
			},
			{
				pass_type = "rect",
				style_id = "rect"
			}
		}
	},
	content = {
		frame = UIFrameSettings.menu_frame_06.texture,
		hotspot = {},
		screen_hotspot = {}
	},
	style = {
		frame = {
			texture_size = UIFrameSettings.menu_frame_06.texture_size,
			texture_sizes = UIFrameSettings.menu_frame_06.texture_sizes,
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
		rect = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			color = Colors.get_table("black"),
			offset = {
				0,
				0,
				0
			}
		}
	},
	offset = {
		0,
		0,
		0
	}
}

function create_command_entry(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6)
	local var_34_0 = {
		element = {}
	}
	local var_34_1 = {
		{
			pass_type = "hotspot",
			content_id = "command_hotspot"
		},
		{
			style_id = "command",
			pass_type = "text",
			text_id = "command"
		},
		{
			style_id = "command_compare",
			pass_type = "text",
			text_id = "command_compare",
			content_check_function = function(arg_35_0, arg_35_1)
				if arg_35_0.command_hotspot.is_hover then
					arg_35_0.command_compare = arg_35_0.command

					return true
				end

				local var_35_0 = arg_34_6.text
				local var_35_1 = arg_35_0.command
				local var_35_2 = string.len(var_35_1)
				local var_35_3, var_35_4 = string.find(var_35_1, var_35_0)

				if var_35_3 ~= 1 and var_35_4 ~= var_35_2 then
					return false
				else
					arg_35_0.command_compare = var_35_0

					return true
				end
			end
		},
		{
			style_id = "description",
			pass_type = "text",
			text_id = "description",
			content_check_function = function(arg_36_0, arg_36_1)
				return arg_36_0.description ~= nil
			end
		}
	}
	local var_34_2 = {
		command_compare = " ",
		command_hotspot = {},
		command = arg_34_0,
		description = arg_34_1,
		parameter = arg_34_2,
		chat_text = arg_34_6
	}
	local var_34_3 = {
		command = {
			font_size = 16,
			word_wrap = false,
			pixel_perfect = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("white"),
			offset = {
				30,
				0,
				3
			}
		},
		command_compare = {
			font_size = 16,
			word_wrap = false,
			pixel_perfect = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = arg_34_4 or Colors.get_table("light_blue"),
			offset = {
				30,
				0,
				4
			}
		},
		description = {
			font_size = 16,
			word_wrap = false,
			pixel_perfect = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("gray"),
			offset = {
				30 + arg_34_3,
				0,
				3
			}
		}
	}

	var_34_0.element.passes = var_34_1
	var_34_0.content = var_34_2
	var_34_0.style = var_34_3
	var_34_0.offset = {
		0,
		arg_34_5,
		0
	}
	var_34_0.scenegraph_id = "commands_list_entry"

	return var_34_0
end

function create_private_button(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6)
	local var_37_0

	if arg_37_6 then
		var_37_0 = "button_" .. arg_37_6
	else
		var_37_0 = "button_normal"
	end

	local var_37_1 = Colors.get_color_table_with_alpha(var_37_0, 255)

	arg_37_3 = arg_37_3 or "button_bg_01"

	local var_37_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_37_3)
	local var_37_3 = arg_37_2 and UIFrameSettings[arg_37_2] or UIFrameSettings.button_frame_01

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function(arg_38_0)
						arg_38_0.disable_button = not arg_38_0.parent.has_private_conversations

						return true
					end
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					style_id = "clicked_rect",
					pass_type = "rect",
					content_check_function = function(arg_39_0)
						local var_39_0 = arg_39_0.button_hotspot.is_clicked

						return not var_39_0 or var_39_0 == 0
					end
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function(arg_40_0)
						return arg_40_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_41_0)
						return not arg_41_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_42_0)
						return arg_42_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass_top",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function(arg_43_0)
						local var_43_0 = arg_43_0.button_hotspot

						return not var_43_0.disable_button and (var_43_0.is_selected or var_43_0.is_hover)
					end
				},
				{
					texture_id = "speech_bubble_id",
					style_id = "speech_bubble",
					pass_type = "texture",
					content_check_function = function(arg_44_0, arg_44_1)
						return arg_44_0.num_private_messages > 0
					end
				},
				{
					style_id = "message_number",
					pass_type = "text",
					text_id = "message_number_text",
					content_check_function = function(arg_45_0)
						local var_45_0 = arg_45_0.num_private_messages

						if var_45_0 <= 0 then
							return false
						end

						if var_45_0 > 10 then
							arg_45_0.message_number_text = "..."
						else
							arg_45_0.message_number_text = tostring(var_45_0)
						end

						return true
					end
				}
			}
		},
		content = {
			speech_bubble_id = "speech_bubble",
			message_number_text = "",
			num_private_messages = 0,
			glass_top = "button_glass_01",
			has_private_conversations = false,
			hover_glow = arg_37_6 and "button_state_hover_" .. arg_37_6 or "button_state_hover",
			glow = arg_37_6 and "button_state_normal_" .. arg_37_6 or "button_state_normal",
			button_hotspot = {},
			title_text = arg_37_4 or "n/a",
			frame = var_37_3.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_37_1[2] / var_37_2.size[2]
					},
					{
						arg_37_1[1] / var_37_2.size[1],
						1
					}
				},
				texture_id = arg_37_3
			},
			new_per_user = {}
		},
		style = {
			background = {
				color = var_37_1,
				offset = {
					0,
					0,
					0
				}
			},
			clicked_rect = {
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					6
				}
			},
			disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					0,
					0,
					6
				}
			},
			title_text = {
				vertical_alignment = "center",
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_37_5 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					5
				}
			},
			title_text_disabled = {
				vertical_alignment = "center",
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_37_5 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					0,
					5
				}
			},
			title_text_shadow = {
				vertical_alignment = "center",
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_37_5 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					4
				}
			},
			frame = {
				texture_size = var_37_3.texture_size,
				texture_sizes = var_37_3.texture_sizes,
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
			hover_glow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_37_3.texture_sizes.horizontal[2],
					1
				},
				size = {
					arg_37_1[1],
					math.min(60, arg_37_1[2] - var_37_3.texture_sizes.horizontal[2] * 2)
				}
			},
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_37_1[2] - var_37_3.texture_sizes.horizontal[2] - 4,
					3
				},
				size = {
					arg_37_1[1],
					5
				}
			},
			glow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_37_3.texture_sizes.horizontal[2] - 1,
					2
				},
				size = {
					arg_37_1[1],
					math.min(60, arg_37_1[2] - var_37_3.texture_sizes.horizontal[2] * 2)
				}
			},
			speech_bubble = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					35,
					35
				},
				offset = {
					10,
					10,
					10
				}
			},
			message_number = {
				vertical_alignment = "center",
				font_size = 18,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark_arial",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					57,
					17,
					11
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

local function var_0_22()
	return {
		scenegraph_id = "emoji",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					style_id = "rect",
					pass_type = "rounded_background",
					content_check_function = function(arg_47_0)
						return arg_47_0.texture_id and arg_47_0.hotspot.is_hover
					end
				},
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					content_check_function = function(arg_48_0)
						return arg_48_0.texture_id
					end
				}
			}
		},
		content = {
			hotspot = {}
		},
		style = {
			rect = {
				corner_radius = 5,
				masked = false,
				color = Colors.get_color_table_with_alpha("font_button_normal", 128),
				offset = {
					7.5,
					-2.5,
					-1
				},
				size = {
					37,
					37
				}
			},
			texture_id = {
				masked = true,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					10,
					0,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_23()
	local var_49_0 = UIFrameSettings.menu_frame_06
	local var_49_1 = {
		element = {}
	}
	local var_49_2 = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			scenegraph_id = "root",
			pass_type = "hotspot",
			content_id = "screen_hotspot"
		},
		{
			pass_type = "rect",
			style_id = "rect"
		},
		{
			pass_type = "texture",
			style_id = "mask_rect",
			texture_id = "mask_texture"
		},
		{
			style_id = "emoji_text",
			pass_type = "text",
			text_id = "emoji_text_id",
			content_check_function = function(arg_50_0)
				return arg_50_0.emoji_text_id ~= nil
			end
		},
		{
			texture_id = "emoji_texture_id",
			style_id = "emoji_texture",
			pass_type = "texture",
			content_check_function = function(arg_51_0)
				return arg_51_0.emoji_texture_id
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local var_49_3 = {
		mask_texture = "mask_rect",
		frame = var_49_0.texture,
		hotspot = {},
		screen_hotspot = {}
	}
	local var_49_4 = {
		rect = {
			offset = {
				0,
				0,
				0
			},
			color = {
				255,
				0,
				0,
				0
			}
		},
		mask_rect = {
			offset = {
				0,
				0,
				5
			}
		},
		frame = {
			texture_size = var_49_0.texture_size,
			texture_sizes = var_49_0.texture_sizes,
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
		emoji_text = {
			vertical_alignment = "bottom",
			font_size = 22,
			word_wrap = false,
			horizontal_alignment = "left",
			pixel_perfect = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("white"),
			offset = {
				0,
				10,
				0
			}
		},
		emoji_texture = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			masked = false,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				10,
				0
			},
			texture_size = {
				32,
				32
			}
		}
	}

	var_49_1.element.passes = var_49_2
	var_49_1.content = var_49_3
	var_49_1.style = var_49_4
	var_49_1.offset = {
		0,
		0,
		0
	}
	var_49_1.scenegraph_id = "emoji_frame"

	return var_49_1
end

local function var_0_24()
	local var_52_0 = {
		element = {}
	}
	local var_52_1 = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "rect",
			style_id = "scrollbar"
		}
	}
	local var_52_2 = {
		hotspot = {}
	}
	local var_52_3 = {
		scrollbar = {
			color = Colors.get_color_table_with_alpha("font_button_normal", 128)
		}
	}

	var_52_0.element.passes = var_52_1
	var_52_0.content = var_52_2
	var_52_0.style = var_52_3
	var_52_0.offset = {
		0,
		0,
		0
	}
	var_52_0.scenegraph_id = "emoji_scrollbar"

	return var_52_0
end

local function var_0_25(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_1 and UIFrameSettings[arg_53_1] or UIFrameSettings.menu_frame_06
	local var_53_1 = arg_53_2 and UIFrameSettings[arg_53_2] or UIFrameSettings.frame_outer_glow_01
	local var_53_2 = {
		element = {}
	}
	local var_53_3 = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame_id"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon_id"
		},
		{
			style_id = "channel_name",
			pass_type = "text",
			text_id = "channel_name_id"
		},
		{
			style_id = "num_members",
			pass_type = "text",
			text_id = "num_members_id"
		},
		{
			style_id = "background",
			pass_type = "rect",
			content_check_function = function(arg_54_0, arg_54_1)
				arg_54_1.color = arg_54_0.hotspot.is_hover and arg_54_1.hover_color or arg_54_1.base_color

				return true
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "selected_frame",
			texture_id = "selected_frame_id",
			content_check_function = function(arg_55_0)
				return arg_55_0.channel_name == arg_55_0.selected_channel
			end
		}
	}
	local var_53_4 = {
		num_members_id = "0",
		icon_id = "icons_placeholder",
		channel_name_id = "",
		frame_id = var_53_0.texture,
		selected_frame_id = var_53_1.texture,
		hotspot = {}
	}
	local var_53_5 = {
		background = {
			color = {
				0,
				0,
				0,
				0
			},
			base_color = {
				255,
				0,
				0,
				0
			},
			hover_color = {
				255,
				30,
				30,
				30
			},
			offset = {
				0,
				0,
				-1
			},
			size = {
				0,
				0
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			texture_size = {
				0,
				0
			}
		},
		frame = {
			texture_size = var_53_0.texture_size,
			texture_sizes = var_53_0.texture_sizes,
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
		selected_frame = {
			texture_size = var_53_1.texture_size,
			texture_sizes = var_53_1.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-5,
				4
			},
			frame_margins = {
				-13,
				-13
			}
		},
		channel_name = {
			word_wrap = false,
			font_size = 16,
			pixel_perfect = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("font_button_normal"),
			offset = {
				0,
				-10,
				0
			}
		},
		num_members = {
			word_wrap = false,
			font_size = 12,
			pixel_perfect = true,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("white"),
			offset = {
				0,
				0,
				0
			}
		}
	}

	var_53_2.element.passes = var_53_3
	var_53_2.content = var_53_4
	var_53_2.style = var_53_5
	var_53_2.offset = {
		0,
		0,
		0
	}
	var_53_2.scenegraph_id = arg_53_0

	return var_53_2
end

local function var_0_26(arg_56_0, arg_56_1)
	local var_56_0 = "menu_frame_bg_03"
	local var_56_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_56_0)
	local var_56_2 = UIFrameSettings.menu_frame_02
	local var_56_3 = UIFrameSettings.menu_frame_06
	local var_56_4 = UIFrameSettings.menu_frame_06
	local var_56_5 = {
		element = {}
	}
	local var_56_6 = {
		{
			scenegraph_id = "channels_window_text_box",
			pass_type = "hotspot",
			content_id = "input_hotspot"
		},
		{
			scenegraph_id = "channels_window_root",
			pass_type = "hotspot",
			content_id = "widget_hotspot"
		},
		{
			scenegraph_id = "channels_window_root",
			pass_type = "hotspot",
			content_id = "channels_list_hotspot"
		},
		{
			scenegraph_id = "root",
			pass_type = "hotspot",
			content_id = "screen_hotspot"
		},
		{
			scenegraph_id = "channels_window_close",
			pass_type = "hotspot",
			content_id = "close_hotspot"
		},
		{
			pass_type = "rotated_texture",
			style_id = "connecting_icon",
			texture_id = "connecting_icon",
			content_check_function = function(arg_57_0, arg_57_1)
				if not arg_57_0.fetching_channels then
					return false
				end

				local var_57_0 = Managers.time:mean_dt() * 400 % 360
				local var_57_1 = math.degrees_to_radians(var_57_0)

				arg_57_1.angle = arg_57_1.angle + var_57_1

				return true
			end
		},
		{
			pass_type = "texture",
			style_id = "mask",
			texture_id = "mask_id",
			scenegraph_id = "channels_window_text_box"
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background_id"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "inner_frame",
			texture_id = "inner_frame"
		},
		{
			pass_type = "rect",
			style_id = "inner_rect"
		},
		{
			pass_type = "texture_frame",
			style_id = "list_frame",
			texture_id = "inner_frame"
		},
		{
			pass_type = "texture",
			style_id = "search_icon",
			texture_id = "search_icon_id",
			content_check_function = function(arg_58_0, arg_58_1)
				if arg_58_0.text_field_active then
					return
				end

				if arg_58_0.input_hotspot.is_hover then
					arg_58_1.color[1] = 128
				else
					arg_58_1.color[1] = 60
				end

				return true
			end
		},
		{
			pass_type = "rect",
			style_id = "list_inner_rect"
		},
		{
			pass_type = "texture",
			style_id = "background_tint",
			texture_id = "background_tint"
		},
		{
			style_id = "info_text",
			pass_type = "text",
			text_id = "info_id"
		},
		{
			style_id = "search_text",
			pass_type = "text",
			text_id = "search_text_id"
		},
		{
			style_id = "channel_text",
			pass_type = "text",
			text_id = "channel_text_id"
		},
		{
			pass_type = "tiled_texture",
			style_id = "header_background",
			texture_id = "background_id"
		},
		{
			style_id = "header_text",
			pass_type = "text",
			text_id = "header_id"
		},
		{
			pass_type = "texture_frame",
			style_id = "header_frame",
			texture_id = "inner_frame"
		},
		{
			style_id = "chat_text",
			pass_type = "text",
			text_id = "chat_text_id",
			content_check_function = function(arg_59_0, arg_59_1)
				if not arg_59_0.text_field_active then
					return
				end

				local var_59_0 = math.floor(Managers.time:time("main") * 2) % 2

				arg_59_1.caret_color[1] = var_59_0 == 0 and 255 or 0

				return true
			end
		},
		{
			style_id = "close_text",
			pass_type = "text",
			text_id = "close_text_id",
			content_check_function = function(arg_60_0, arg_60_1)
				if arg_60_0.close_hotspot.is_hover then
					arg_60_1.text_color[1] = 255
				else
					arg_60_1.text_color[1] = 128
				end

				return true
			end
		}
	}
	local var_56_7 = {
		chat_text_id = "",
		text_start_offset = 0,
		header_id = "CHANNELS",
		search_icon_id = "search_icon",
		search_text_id = "Search",
		connecting_icon = "matchmaking_connecting_icon",
		close_text_id = "X",
		text_index = 1,
		info_id = "",
		caret_index = 1,
		mask_id = "mask_rect",
		background_tint = "gradient_dice_game_reward",
		channel_text_id = "Channels",
		input_hotspot = {},
		screen_hotspot = {},
		widget_hotspot = {},
		channels_list_hotspot = {},
		close_hotspot = {},
		frame = var_56_2.texture,
		inner_frame = var_56_3.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_56_1[1] / var_56_1.size[1], 1),
					math.min(arg_56_1[2] / var_56_1.size[2], 1)
				}
			},
			texture_id = var_56_0
		},
		background_id = var_56_0
	}
	local var_56_8 = {
		connecting_icon = {
			vertical_alignment = "center",
			scenegraph_id = "channels_window_list_box",
			horizontal_alignment = "center",
			angle = 0,
			pivot = {
				25,
				25
			},
			texture_size = {
				50,
				50
			},
			offset = {
				0,
				0,
				12
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		background = {
			color = {
				255,
				60,
				60,
				60
			},
			offset = {
				0,
				0,
				1
			},
			texture_tiling_size = var_56_1.size
		},
		mask = {
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
		frame = {
			texture_size = var_56_2.texture_size,
			texture_sizes = var_56_2.texture_sizes,
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
		inner_rect = {
			scenegraph_id = "channels_window_text_box",
			color = {
				200,
				10,
				10,
				10
			},
			offset = {
				0,
				0,
				0
			}
		},
		inner_frame = {
			scenegraph_id = "channels_window_text_box",
			texture_size = var_56_3.texture_size,
			texture_sizes = var_56_3.texture_sizes,
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
		search_icon = {
			vertical_alignment = "center",
			scenegraph_id = "channels_window_text_box",
			horizontal_alignment = "right",
			texture_size = {
				24,
				24
			},
			color = {
				60,
				255,
				255,
				255
			},
			offset = {
				-10,
				0,
				1
			}
		},
		background_tint = {
			scenegraph_id = "screen",
			offset = {
				0,
				0,
				100
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		info_text = {
			word_wrap = true,
			scenegraph_id = "channels_window_text_box",
			font_size = 16,
			pixel_perfect = true,
			horizontal_alignment = "right",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				-320,
				0,
				2
			}
		},
		search_text = {
			word_wrap = false,
			scenegraph_id = "channels_window_text_box",
			font_size = 22,
			pixel_perfect = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_table("font_default"),
			offset = {
				5,
				25,
				10
			}
		},
		chat_text = {
			horizontal_scroll = true,
			scenegraph_id = "channels_window_text_box",
			word_wrap = false,
			pixel_perfect = true,
			horizontal_alignment = "left",
			font_size = 16,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("white"),
			offset = {
				5,
				13,
				10
			},
			caret_size = {
				2,
				18
			},
			caret_offset = {
				-2,
				-2,
				4
			},
			caret_color = Colors.get_table("white")
		},
		channel_text = {
			word_wrap = false,
			scenegraph_id = "channels_window_list_box",
			font_size = 22,
			pixel_perfect = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_table("font_default"),
			offset = {
				5,
				25,
				10
			}
		},
		header_text = {
			word_wrap = true,
			scenegraph_id = "channels_window_list_header",
			font_size = 28,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				0,
				0,
				10
			}
		},
		header_frame = {
			scenegraph_id = "channels_window_list_header",
			texture_size = var_56_4.texture_size,
			texture_sizes = var_56_4.texture_sizes,
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
		header_background = {
			scenegraph_id = "channels_window_list_header",
			color = {
				255,
				60,
				60,
				60
			},
			offset = {
				0,
				0,
				1
			},
			texture_tiling_size = var_56_1.size
		},
		close_text = {
			word_wrap = false,
			scenegraph_id = "channels_window_close",
			font_size = 22,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 128),
			offset = {
				0,
				0,
				10
			}
		},
		list_inner_rect = {
			scenegraph_id = "channels_window_list_box",
			color = {
				200,
				10,
				10,
				10
			},
			offset = {
				0,
				0,
				0
			}
		},
		list_frame = {
			scenegraph_id = "channels_window_list_box",
			texture_size = var_56_3.texture_size,
			texture_sizes = var_56_3.texture_sizes,
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
		}
	}

	var_56_5.element.passes = var_56_6
	var_56_5.content = var_56_7
	var_56_5.style = var_56_8
	var_56_5.offset = {
		0,
		0,
		0
	}
	var_56_5.scenegraph_id = arg_56_0

	return var_56_5
end

local function var_0_27(arg_61_0, arg_61_1)
	local var_61_0 = "menu_frame_bg_03"
	local var_61_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_61_0)
	local var_61_2 = UIFrameSettings.menu_frame_02
	local var_61_3 = UIFrameSettings.menu_frame_06
	local var_61_4 = UIFrameSettings.menu_frame_06
	local var_61_5 = {
		element = {}
	}
	local var_61_6 = {
		{
			scenegraph_id = "create_channel_input",
			pass_type = "hotspot",
			content_id = "input_hotspot"
		},
		{
			scenegraph_id = "create_channels_window_root",
			pass_type = "hotspot",
			content_id = "widget_hotspot"
		},
		{
			scenegraph_id = "root",
			pass_type = "hotspot",
			content_id = "screen_hotspot"
		},
		{
			scenegraph_id = "create_channel_window_close",
			pass_type = "hotspot",
			content_id = "close_hotspot"
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background_id"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "inner_frame",
			texture_id = "inner_frame"
		},
		{
			pass_type = "rect",
			style_id = "inner_rect"
		},
		{
			pass_type = "texture",
			style_id = "background_tint",
			texture_id = "background_tint"
		},
		{
			style_id = "channel_name_text",
			pass_type = "text",
			text_id = "channel_name_id"
		},
		{
			style_id = "header_background",
			pass_type = "texture_uv",
			content_id = "background"
		},
		{
			style_id = "header_text",
			pass_type = "text",
			text_id = "header_id"
		},
		{
			pass_type = "texture_frame",
			style_id = "header_frame",
			texture_id = "inner_frame"
		},
		{
			style_id = "chat_text",
			pass_type = "text",
			text_id = "chat_text_id",
			content_check_function = function(arg_62_0, arg_62_1)
				if not arg_62_0.text_field_active then
					return
				end

				local var_62_0 = math.floor(Managers.time:time("main") * 2) % 2

				arg_62_1.caret_color[1] = var_62_0 == 0 and 255 or 0

				return true
			end
		},
		{
			style_id = "close_text",
			pass_type = "text",
			text_id = "close_text_id",
			content_check_function = function(arg_63_0, arg_63_1)
				if arg_63_0.close_hotspot.is_hover then
					arg_63_1.text_color[1] = 255
				else
					arg_63_1.text_color[1] = 128
				end

				return true
			end
		}
	}
	local var_61_7 = {
		chat_text_id = "",
		text_start_offset = 0,
		channel_name_id = "Channel Name",
		header_id = "CREATE CHANNEL",
		close_text_id = "X",
		text_index = 1,
		caret_index = 1,
		background_tint = "gradient_dice_game_reward",
		input_hotspot = {},
		screen_hotspot = {},
		widget_hotspot = {},
		channels_list_hotspot = {},
		close_hotspot = {},
		frame = var_61_2.texture,
		inner_frame = var_61_3.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_61_1[1] / var_61_1.size[1], 1),
					math.min(arg_61_1[2] / var_61_1.size[2], 1)
				}
			},
			texture_id = var_61_0
		},
		background_id = var_61_0
	}
	local var_61_8 = {
		background = {
			color = {
				255,
				60,
				60,
				60
			},
			offset = {
				0,
				0,
				1
			},
			texture_tiling_size = var_61_1.size
		},
		frame = {
			texture_size = var_61_2.texture_size,
			texture_sizes = var_61_2.texture_sizes,
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
		inner_rect = {
			scenegraph_id = "create_channel_input",
			color = {
				200,
				10,
				10,
				10
			},
			offset = {
				0,
				0,
				0
			}
		},
		inner_frame = {
			scenegraph_id = "create_channel_input",
			texture_size = var_61_3.texture_size,
			texture_sizes = var_61_3.texture_sizes,
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
		search_icon = {
			vertical_alignment = "center",
			scenegraph_id = "create_channel_input",
			horizontal_alignment = "right",
			texture_size = {
				24,
				24
			},
			color = {
				60,
				255,
				255,
				255
			},
			offset = {
				-10,
				0,
				1
			}
		},
		background_tint = {
			scenegraph_id = "screen",
			offset = {
				0,
				0,
				100
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		channel_name_text = {
			word_wrap = false,
			scenegraph_id = "create_channel_input",
			font_size = 22,
			pixel_perfect = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_table("font_default"),
			offset = {
				5,
				25,
				10
			}
		},
		chat_text = {
			horizontal_scroll = true,
			scenegraph_id = "create_channel_input",
			word_wrap = false,
			pixel_perfect = true,
			horizontal_alignment = "left",
			font_size = 16,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("white"),
			offset = {
				5,
				13,
				10
			},
			caret_size = {
				2,
				18
			},
			caret_offset = {
				-2,
				-2,
				4
			},
			caret_color = Colors.get_table("white")
		},
		header_text = {
			word_wrap = true,
			scenegraph_id = "create_channel_window_list_header",
			font_size = 28,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				0,
				0,
				10
			}
		},
		header_frame = {
			scenegraph_id = "create_channel_window_list_header",
			texture_size = var_61_4.texture_size,
			texture_sizes = var_61_4.texture_sizes,
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
		header_background = {
			scenegraph_id = "create_channel_window_list_header",
			color = {
				255,
				60,
				60,
				60
			},
			offset = {
				0,
				0,
				1
			}
		},
		close_text = {
			word_wrap = false,
			scenegraph_id = "create_channel_window_close",
			font_size = 22,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 128),
			offset = {
				0,
				0,
				10
			}
		}
	}

	var_61_5.element.passes = var_61_6
	var_61_5.content = var_61_7
	var_61_5.style = var_61_8
	var_61_5.offset = {
		0,
		0,
		0
	}
	var_61_5.scenegraph_id = arg_61_0

	return var_61_5
end

local function var_0_28(arg_64_0, arg_64_1)
	local var_64_0 = "menu_frame_bg_03"
	local var_64_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_64_0)
	local var_64_2 = UIFrameSettings.menu_frame_02
	local var_64_3 = UIFrameSettings.menu_frame_06
	local var_64_4 = UIFrameSettings.menu_frame_06
	local var_64_5 = {
		element = {}
	}
	local var_64_6 = {
		{
			scenegraph_id = "create_channel_input",
			pass_type = "hotspot",
			content_id = "input_hotspot"
		},
		{
			scenegraph_id = "create_channels_window_root",
			pass_type = "hotspot",
			content_id = "widget_hotspot"
		},
		{
			scenegraph_id = "root",
			pass_type = "hotspot",
			content_id = "screen_hotspot"
		},
		{
			scenegraph_id = "create_channel_window_close",
			pass_type = "hotspot",
			content_id = "close_hotspot"
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background_id"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "inner_frame",
			texture_id = "inner_frame"
		},
		{
			pass_type = "rect",
			style_id = "inner_rect"
		},
		{
			pass_type = "texture",
			style_id = "background_tint",
			texture_id = "background_tint"
		},
		{
			style_id = "channel_name_text",
			pass_type = "text",
			text_id = "channel_name_id"
		},
		{
			pass_type = "tiled_texture",
			style_id = "header_background",
			texture_id = "background_id"
		},
		{
			style_id = "header_text",
			pass_type = "text",
			text_id = "header_id"
		},
		{
			pass_type = "texture_frame",
			style_id = "header_frame",
			texture_id = "inner_frame"
		},
		{
			style_id = "chat_text",
			pass_type = "text",
			text_id = "chat_text_id",
			content_check_function = function(arg_65_0, arg_65_1)
				if not arg_65_0.text_field_active then
					return
				end

				local var_65_0 = math.floor(Managers.time:time("main") * 2) % 2

				arg_65_1.caret_color[1] = var_65_0 == 0 and 255 or 0

				return true
			end
		},
		{
			style_id = "close_text",
			pass_type = "text",
			text_id = "close_text_id",
			content_check_function = function(arg_66_0, arg_66_1)
				if arg_66_0.close_hotspot.is_hover then
					arg_66_1.text_color[1] = 255
				else
					arg_66_1.text_color[1] = 128
				end

				return true
			end
		}
	}
	local var_64_7 = {
		chat_text_id = "",
		text_start_offset = 0,
		channel_name_id = "Description",
		header_id = "POST INVITE LINK",
		close_text_id = "X",
		text_index = 1,
		caret_index = 1,
		background_tint = "gradient_dice_game_reward",
		input_hotspot = {},
		screen_hotspot = {},
		widget_hotspot = {},
		channels_list_hotspot = {},
		close_hotspot = {},
		frame = var_64_2.texture,
		inner_frame = var_64_3.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_64_1[1] / var_64_1.size[1], 1),
					math.min(arg_64_1[2] / var_64_1.size[2], 1)
				}
			},
			texture_id = var_64_0
		},
		background_id = var_64_0
	}
	local var_64_8 = {
		background = {
			color = {
				255,
				60,
				60,
				60
			},
			offset = {
				0,
				0,
				1
			},
			texture_tiling_size = var_64_1.size
		},
		frame = {
			texture_size = var_64_2.texture_size,
			texture_sizes = var_64_2.texture_sizes,
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
		inner_rect = {
			scenegraph_id = "create_channel_input",
			color = {
				200,
				10,
				10,
				10
			},
			offset = {
				0,
				0,
				0
			}
		},
		inner_frame = {
			scenegraph_id = "create_channel_input",
			texture_size = var_64_3.texture_size,
			texture_sizes = var_64_3.texture_sizes,
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
		search_icon = {
			vertical_alignment = "center",
			scenegraph_id = "create_channel_input",
			horizontal_alignment = "right",
			texture_size = {
				24,
				24
			},
			color = {
				60,
				255,
				255,
				255
			},
			offset = {
				-10,
				0,
				1
			}
		},
		background_tint = {
			scenegraph_id = "screen",
			offset = {
				0,
				0,
				100
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		channel_name_text = {
			word_wrap = false,
			scenegraph_id = "create_channel_input",
			font_size = 22,
			pixel_perfect = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_table("font_default"),
			offset = {
				5,
				25,
				10
			}
		},
		chat_text = {
			horizontal_scroll = true,
			scenegraph_id = "create_channel_input",
			word_wrap = false,
			pixel_perfect = true,
			horizontal_alignment = "left",
			font_size = 16,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_arial",
			text_color = Colors.get_table("white"),
			offset = {
				5,
				13,
				10
			},
			caret_size = {
				2,
				18
			},
			caret_offset = {
				-2,
				-2,
				4
			},
			caret_color = Colors.get_table("white")
		},
		header_text = {
			word_wrap = true,
			scenegraph_id = "create_channel_window_list_header",
			font_size = 28,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				0,
				0,
				10
			}
		},
		header_frame = {
			scenegraph_id = "create_channel_window_list_header",
			texture_size = var_64_4.texture_size,
			texture_sizes = var_64_4.texture_sizes,
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
		header_background = {
			scenegraph_id = "create_channel_window_list_header",
			color = {
				255,
				60,
				60,
				60
			},
			offset = {
				0,
				0,
				1
			},
			texture_tiling_size = var_64_1.size
		},
		close_text = {
			word_wrap = false,
			scenegraph_id = "create_channel_window_close",
			font_size = 22,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 128),
			offset = {
				0,
				0,
				10
			}
		}
	}

	var_64_5.element.passes = var_64_6
	var_64_5.content = var_64_7
	var_64_5.style = var_64_8
	var_64_5.offset = {
		0,
		0,
		0
	}
	var_64_5.scenegraph_id = arg_64_0

	return var_64_5
end

local function var_0_29(arg_67_0, arg_67_1)
	local var_67_0 = "menu_frame_bg_03"
	local var_67_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_67_0)
	local var_67_2 = UIFrameSettings.menu_frame_02
	local var_67_3 = UIFrameSettings.menu_frame_06
	local var_67_4 = UIFrameSettings.menu_frame_06
	local var_67_5 = {
		element = {}
	}
	local var_67_6 = {
		{
			scenegraph_id = "recent_channels_window_list_box",
			pass_type = "hotspot",
			content_id = "list_hotspot"
		},
		{
			scenegraph_id = "recent_channels_window_root",
			pass_type = "hotspot",
			content_id = "widget_hotspot"
		},
		{
			scenegraph_id = "root",
			pass_type = "hotspot",
			content_id = "screen_hotspot"
		},
		{
			scenegraph_id = "recent_channels_window_close",
			pass_type = "hotspot",
			content_id = "close_hotspot"
		},
		{
			pass_type = "rotated_texture",
			style_id = "connecting_icon",
			texture_id = "connecting_icon",
			content_check_function = function(arg_68_0, arg_68_1)
				if not arg_68_0.fetching_channels then
					return false
				end

				local var_68_0 = Managers.time:mean_dt() * 400 % 360
				local var_68_1 = math.degrees_to_radians(var_68_0)

				arg_68_1.angle = arg_68_1.angle + var_68_1

				return true
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background_id"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "inner_frame",
			texture_id = "inner_frame"
		},
		{
			pass_type = "rect",
			style_id = "inner_rect"
		},
		{
			pass_type = "texture",
			style_id = "background_tint",
			texture_id = "background_tint"
		},
		{
			pass_type = "tiled_texture",
			style_id = "header_background",
			texture_id = "background_id"
		},
		{
			style_id = "header_text",
			pass_type = "text",
			text_id = "header_id"
		},
		{
			pass_type = "texture_frame",
			style_id = "header_frame",
			texture_id = "inner_frame"
		},
		{
			style_id = "close_text",
			pass_type = "text",
			text_id = "close_text_id",
			content_check_function = function(arg_69_0, arg_69_1)
				if arg_69_0.close_hotspot.is_hover then
					arg_69_1.text_color[1] = 255
				else
					arg_69_1.text_color[1] = 128
				end

				return true
			end
		}
	}
	local var_67_7 = {
		chat_text_id = "",
		text_start_offset = 0,
		header_id = "RECENT CHANNELS",
		channel_name_id = "Channel Name",
		connecting_icon = "matchmaking_connecting_icon",
		close_text_id = "X",
		text_index = 1,
		caret_index = 1,
		background_tint = "gradient_dice_game_reward",
		list_hotspot = {},
		screen_hotspot = {},
		widget_hotspot = {},
		channels_list_hotspot = {},
		close_hotspot = {},
		frame = var_67_2.texture,
		inner_frame = var_67_3.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_67_1[1] / var_67_1.size[1], 1),
					math.min(arg_67_1[2] / var_67_1.size[2], 1)
				}
			},
			texture_id = var_67_0
		},
		background_id = var_67_0
	}
	local var_67_8 = {
		connecting_icon = {
			vertical_alignment = "center",
			scenegraph_id = "recent_channels_window_list_box",
			horizontal_alignment = "center",
			angle = 0,
			pivot = {
				25,
				25
			},
			texture_size = {
				50,
				50
			},
			offset = {
				0,
				0,
				12
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		background = {
			color = {
				255,
				60,
				60,
				60
			},
			offset = {
				0,
				0,
				1
			},
			texture_tiling_size = var_67_1.size
		},
		frame = {
			texture_size = var_67_2.texture_size,
			texture_sizes = var_67_2.texture_sizes,
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
		inner_rect = {
			scenegraph_id = "recent_channels_window_list_box",
			color = {
				200,
				10,
				10,
				10
			},
			offset = {
				0,
				0,
				0
			}
		},
		inner_frame = {
			scenegraph_id = "recent_channels_window_list_box",
			texture_size = var_67_3.texture_size,
			texture_sizes = var_67_3.texture_sizes,
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
		background_tint = {
			scenegraph_id = "screen",
			offset = {
				0,
				0,
				100
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		header_text = {
			word_wrap = true,
			scenegraph_id = "recent_channel_window_list_header",
			font_size = 28,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				0,
				0,
				10
			}
		},
		header_frame = {
			scenegraph_id = "recent_channel_window_list_header",
			texture_size = var_67_4.texture_size,
			texture_sizes = var_67_4.texture_sizes,
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
		header_background = {
			scenegraph_id = "recent_channel_window_list_header",
			color = {
				255,
				60,
				60,
				60
			},
			offset = {
				0,
				0,
				1
			},
			texture_tiling_size = var_67_1.size
		},
		close_text = {
			word_wrap = false,
			scenegraph_id = "recent_channels_window_close",
			font_size = 22,
			pixel_perfect = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 128),
			offset = {
				0,
				0,
				10
			}
		}
	}

	var_67_5.element.passes = var_67_6
	var_67_5.content = var_67_7
	var_67_5.style = var_67_8
	var_67_5.offset = {
		0,
		0,
		0
	}
	var_67_5.scenegraph_id = arg_67_0

	return var_67_5
end

function create_default_button(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5, arg_70_6)
	arg_70_3 = arg_70_3 or "button_bg_01"

	local var_70_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_70_3)
	local var_70_1 = arg_70_2 and UIFrameSettings[arg_70_2] or UIFrameSettings.button_frame_01
	local var_70_2 = var_70_1.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame",
					content_check_function = function(arg_71_0)
						return arg_71_0.draw_frame
					end
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
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
					content_check_function = function(arg_72_0)
						return arg_72_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_73_0)
						return not arg_73_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_74_0)
						return arg_74_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				}
			}
		},
		content = {
			glass = "button_glass_02",
			hover_glow = "button_state_default",
			draw_frame = true,
			background_fade = "button_bg_fade",
			button_hotspot = {},
			title_text = arg_70_4 or "n/a",
			frame = var_70_1.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_70_1[2] / var_70_0.size[2]
					},
					{
						arg_70_1[1] / var_70_0.size[1],
						1
					}
				},
				texture_id = arg_70_3
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
			background_fade = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					var_70_2,
					var_70_2 - 2,
					2
				},
				size = {
					arg_70_1[1] - var_70_2 * 2,
					arg_70_1[2] - var_70_2 * 2
				}
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
					var_70_2 - 2,
					3
				},
				size = {
					arg_70_1[1],
					math.min(arg_70_1[2] - 5, 80)
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
					7
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
					1
				}
			},
			title_text = {
				upper_case = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				dynamic_font_size = not arg_70_6,
				font_size = arg_70_5 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_70_1[1] - 40,
					arg_70_1[2]
				},
				offset = {
					20,
					-2,
					6
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_70_5 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				size = {
					arg_70_1[1] - 40,
					arg_70_1[2]
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_70_5 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					arg_70_1[1] - 40,
					arg_70_1[2]
				},
				offset = {
					22,
					-2,
					5
				}
			},
			frame = {
				texture_size = var_70_1.texture_size,
				texture_sizes = var_70_1.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					8
				}
			},
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_70_1[2] - (var_70_2 + 11),
					4
				},
				size = {
					arg_70_1[1],
					11
				}
			},
			glass_bottom = {
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					0,
					var_70_2 - 9,
					4
				},
				size = {
					arg_70_1[1],
					11
				}
			}
		},
		scenegraph_id = arg_70_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_30 = {
	widgets = {
		frame_widget = var_0_11("popup_root", var_0_10.popup_root.size),
		chat_output_widget = var_0_12("feed_area_edge", 0),
		name_list_widget = UIWidgets.create_rect_with_frame("list_area", var_0_10.list_area.size, {
			160,
			0,
			0,
			0
		}, var_0_1),
		list_area_hotspot_widget = UIWidgets.create_simple_hotspot("list_area"),
		private_messages_widget = create_private_button("private_messages_button", var_0_10.private_messages_button.size, nil, nil, "Private", 20),
		send_invite_widget = create_default_button("channels_button", var_0_10.channels_button.size, nil, nil, "Invite", 20),
		channels_widget = create_default_button("popular_channels_button", var_0_10.popular_channels_button.size, nil, nil, "Channels", 20),
		commands_widget = create_default_button("commands_button", var_0_10.commands_button.size, nil, nil, "?", 20, true),
		emoji_widget = create_default_button("emoji_button", var_0_10.emoji_button.size, nil, nil, ":)", 20, true)
	},
	create_channel_entry_func = create_channel_entry,
	channel_list_frame = var_0_15,
	create_channel_tab = var_0_16,
	create_private_user_entry_func = create_private_user_entry,
	private_user_list_frame = var_0_17,
	create_recent_channel_entry_func = create_recent_channel_entry,
	recent_channels_list_frame = var_0_18,
	create_popular_channels_entry_func = create_popular_channels_entry,
	popular_channels_list_frame = var_0_19,
	create_command_entry_func = create_command_entry,
	commands_list_frame = var_0_20,
	create_emoji_func = var_0_22,
	create_emoji_frame_func = var_0_23,
	create_emoji_scroller_func = var_0_24,
	channels_window = var_0_26("channels_window_root", var_0_10.channels_window_root.size),
	channel_entry = var_0_25("channels_window_list_box_entry"),
	join_channel_button = create_default_button("join_channel_button", var_0_10.join_channel_button.size, nil, nil, "Join", 20),
	create_channel_button = create_default_button("create_channel_button", var_0_10.create_channel_button.size, nil, nil, "Create", 20),
	recent_channels_button = create_default_button("recent_channels_button", var_0_10.recent_channels_button.size, nil, nil, "Recent", 20),
	create_channel_window = var_0_27("create_channels_window_root", var_0_10.create_channels_window_root.size),
	inner_create_channel_button = create_default_button("inner_create_channel_button", var_0_10.inner_create_channel_button.size, nil, nil, "Create", 20),
	recent_channels_window = var_0_29("recent_channels_window_root", var_0_10.recent_channels_window_root.size),
	recent_join_channel_button = create_default_button("recent_join_channel_button", var_0_10.join_channel_button.size, nil, nil, "Join", 20),
	create_channel_list_entry_func = var_0_25,
	send_invite_window = var_0_28("create_channels_window_root", var_0_10.create_channels_window_root.size),
	send_invite_button = create_default_button("send_invite_button", var_0_10.send_invite_button.size, nil, nil, "Send Invite", 20),
	create_filtered_user_name_entry_func = create_filtered_user_name_entry,
	filtered_user_names_list_frame = var_0_21
}

return {
	num_users_in_list = var_0_3,
	create_entry_func = var_0_14,
	scenegraph_definition = var_0_10,
	widget_definitions = var_0_30,
	emoji_list_settings = var_0_8,
	channels_list_settings = var_0_9
}
