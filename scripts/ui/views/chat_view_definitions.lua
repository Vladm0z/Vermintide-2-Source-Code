-- chunkname: @scripts/ui/views/chat_view_definitions.lua

local num = 800
local str = "menu_frame_06"
local var_0_2 = UIFrameSettings[str].texture_sizes.corner[2]
local num_2 = 12
local str_2 = "menu_frame_06"
local var_0_5 = UIFrameSettings[str_2]
local var_0_6 = var_0_5.texture_sizes.horizontal[2]
local num_3 = (num - var_0_2 * 2) / num_2
local tbl = {
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
local tbl_2 = {
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
local tbl_3 = {
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
			num
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
			num_3
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

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local str = "menu_frame_bg_03"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local menu_frame_02 = UIFrameSettings.menu_frame_02
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			style_id = "left_arrow_top",
			pass_type = "triangle",
			content_change_function = function (self, arg_2_1)
				-- function 2
				local hover_color

				if not self.left_hotspot.is_hover then
					hover_color = arg_2_1.hover_color

					if not hover_color then
						-- Nothing
					end
				end

				hover_color = arg_2_1.base_color

				::label_2_0::

				arg_2_1.color = hover_color
			end
		},
		{
			style_id = "left_arrow_bottom",
			pass_type = "triangle",
			content_change_function = function (self, arg_3_1)
				-- function 3
				local hover_color

				if not self.left_hotspot.is_hover then
					hover_color = arg_3_1.hover_color

					if not hover_color then
						-- Nothing
					end
				end

				hover_color = arg_3_1.base_color

				::label_3_0::

				arg_3_1.color = hover_color
			end
		},
		{
			style_id = "right_arrow_top",
			pass_type = "triangle",
			content_change_function = function (self, arg_4_1)
				-- function 4
				local hover_color

				if not self.right_hotspot.is_hover then
					hover_color = arg_4_1.hover_color

					if not hover_color then
						-- Nothing
					end
				end

				hover_color = arg_4_1.base_color

				::label_4_0::

				arg_4_1.color = hover_color
			end
		},
		{
			style_id = "right_arrow_bottom",
			pass_type = "triangle",
			content_change_function = function (self, arg_5_1)
				-- function 5
				local hover_color

				if not self.right_hotspot.is_hover then
					hover_color = arg_5_1.hover_color

					if not hover_color then
						-- Nothing
					end
				end

				hover_color = arg_5_1.base_color

				::label_5_0::

				arg_5_1.color = hover_color
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
			content_check_function = function (self, arg_6_1)
				-- function 6
				if not self.text_field_active then
					return false
				else
					arg_6_1.caret_color[1] = 128 + math.sin(Managers.time:time("ui") * 5) * 128
				end

				self.real_chat_text = self.chat_text.text

				return true
			end
		},
		{
			style_id = "chat_hint",
			pass_type = "text",
			text_id = "chat_hint",
			content_check_function = function (self, arg_7_1)
				-- function 7
				if not self.text_input_hotspot.is_hover then
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

				return self.chat_text.text ~= "" or not self.text_field_active
			end
		},
		{
			style_id = "private_user_name",
			pass_type = "text",
			text_id = "trimmed_private_user_name",
			content_check_function = function (self)
				-- function 8
				if not self.private_user_name then
					return false
				end

				return true
			end
		}
	}
	local tbl_4 = {
		text_field_active = false,
		text_start_offset = 0,
		channel_arrow_id = "down_arrow",
		text_index = 1,
		chat_hint = "Press Enter to chat or / for commands",
		channel_name = " ",
		caret_index = 1,
		mask_id = "mask_rect",
		background_tint = "gradient_dice_game_reward",
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
		background_id = str,
		text_input_hotspot = {},
		screen_hotspot = {},
		channel_hotspot = {},
		left_hotspot = {},
		right_hotspot = {},
		chat_text = {
			text = ""
		}
	}
	local tbl_5 = {
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
			texture_tiling_size = get_atlas_settings_by_texture_name.size
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
				tbl_3.input_field.size[1] - 10,
				tbl_3.input_field.size[2]
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_4
	tbl.style = tbl_5
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_1_0

	return tbl
end

local function fn_2(arg_9_0, arg_9_1)
	-- function 9
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self, arg_10_1)
				-- function 10
				if not self.private_user_name then
					return false
				end

				local var_10_0 = self.channel_messages_table[self.channel_name]

				var_10_0 = var_10_0 or {}
				self.message_tables = var_10_0

				return true
			end
		},
		{
			style_id = "text",
			pass_type = "text_area_chat",
			text_id = "text_field",
			content_check_function = function (self, arg_11_1)
				-- function 11
				if not self.private_user_name then
					return false
				end

				local var_11_0 = self.private_messages_table[self.private_user_name]

				var_11_0 = var_11_0 or {}
				self.message_tables = var_11_0

				return true
			end
		}
	}
	local tbl_3 = {
		text_start_offset = 0,
		channel_name = " ",
		mask_id = "mask_rect",
		channel_messages_table = {},
		private_messages_table = {},
		message_tables = {},
		frame = var_0_5.texture
	}
	local tbl_4 = {
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

local function fn_3(arg_12_0, arg_12_1)
	-- function 12
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self, arg_13_1)
				-- function 13
				local var_13_0 = self.channel_messages_table[self.channel_name]

				var_13_0 = var_13_0 or {}
				self.message_tables = var_13_0

				return true
			end
		}
	}
	local tbl_3 = {
		text_start_offset = 0,
		channel_name = " ",
		mask_id = "mask_rect",
		channel_messages_table = {},
		message_tables = {}
	}
	local tbl_4 = {
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_12_0

	return tbl
end

local function fn_4(arg_14_0)
	-- function 14
	local str = "entry_root"
	local size = tbl_3[str].size
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local tbl = {
		0,
		-(num_3 * (arg_14_0 - 1)),
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
					content_check_function = function (self)
						-- function 15
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.is_selected or not button_hotspot.is_hover
					end
				},
				{
					style_id = "title_text_hover",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 16
						local button_hotspot = self.button_hotspot
						local is_selected

						if not button_hotspot.disable_button then
							is_selected = button_hotspot.is_selected

							if not is_selected then
								is_selected = button_hotspot.is_hover
							end
						else
							is_selected = false
						end

						if false then
							is_selected = true
						end

						return is_selected
					end
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 17
						local button_hotspot = self.button_hotspot
						local is_selected

						if not button_hotspot.disable_button then
							is_selected = button_hotspot.is_selected

							if not is_selected then
								is_selected = button_hotspot.is_hover
							end
						else
							is_selected = false
						end

						if false then
							is_selected = true
						end

						return is_selected
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
			frame = menu_frame_06.texture
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
					size[2],
					size[2]
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
					tbl_3[str].size[1] - 70,
					tbl_3[str].size[2]
				},
				offset = {
					size[2] + var_0_2,
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
					tbl_3[str].size[1] - 70,
					tbl_3[str].size[2]
				},
				offset = {
					size[2] + var_0_2,
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
					size[2] + var_0_2,
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
					size[2] + var_0_2,
					4,
					3
				}
			},
			frame = {
				texture_size = menu_frame_06.texture_size,
				texture_sizes = menu_frame_06.texture_sizes,
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
		scenegraph_id = str,
		offset = tbl
	}
end

local tbl_4 = {
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

local function fn_5(arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	local button_frame_01 = UIFrameSettings.button_frame_01
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self, arg_19_1)
				-- function 19
				if not self.tab_hotspot.is_hover then
					arg_19_1.text_color = arg_19_1.hover_color
				elseif not self.selected then
					arg_19_1.text_color = arg_19_1.selected_color
				else
					arg_19_1.text_color = arg_19_1.base_color
				end

				return true
			end
		}
	}
	local tbl_4 = {
		texture_id = "rect_masked",
		tab_hotspot = {},
		exit_button_hotspot = {},
		channel_name = arg_18_0,
		frame = button_frame_01.texture,
		selected = arg_18_2 == arg_18_0
	}
	local tbl_5 = {
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
				tbl_3.channel_tab_anchor.size[1] - 10,
				tbl_3.channel_tab_anchor.size[2]
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
			texture_size = tbl_3.channel_tab_anchor.size,
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
				tbl_3.channel_tab_anchor.size[1] - 4,
				tbl_3.channel_tab_anchor.size[2] - 2
			},
			offset = {
				2,
				-2,
				-2
			}
		},
		frame = {
			masked = true,
			texture_size = button_frame_01.texture_size,
			texture_sizes = button_frame_01.texture_sizes,
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_4
	tbl.style = tbl_5
	tbl.offset = {
		(arg_18_1 - 1) * tbl_3.channel_tab_anchor.size[1],
		0,
		0
	}
	tbl.scenegraph_id = "channel_tab_anchor"

	return tbl
end

local tbl_5 = {
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
local tbl_6 = {
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
local tbl_7 = {
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
	-- function 20
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			style_id = "exit_button_hotspot",
			pass_type = "hotspot",
			content_id = "exit_button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "exit_button",
			texture_id = "exit_texture_id",
			content_check_function = function (self)
				-- function 21
				return not self.exit_button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "exit_button_hover",
			texture_id = "exit_texture_hover_id",
			content_check_function = function (self)
				-- function 22
				return self.exit_button_hotspot.is_hover
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
			content_check_function = function (self, arg_23_1)
				-- function 23
				if not self.channel_hotspot.is_hover then
					arg_23_1.text_color = Colors.get_table("white")
				else
					arg_23_1.text_color = Colors.get_table("cheeseburger")
				end

				return true
			end
		}
	}
	local tbl_3 = {
		exit_texture_id = "tabs_icon_power",
		exit_texture_hover_id = "tabs_icon_power_glow",
		channel_hotspot = {},
		channel_name = arg_20_0,
		exit_button_hotspot = {}
	}
	local tbl_4 = {
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		arg_20_1,
		0
	}
	tbl.scenegraph_id = "channel_list_entry"

	return tbl
end

function create_recent_channel_entry(arg_24_0, arg_24_1)
	-- function 24
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			pass_type = "hotspot",
			content_id = "channel_hotspot"
		},
		{
			style_id = "channel_name",
			pass_type = "text",
			text_id = "channel_name",
			content_check_function = function (self, arg_25_1)
				-- function 25
				if not self.channel_hotspot.is_hover then
					arg_25_1.text_color = Colors.get_table("white")
				else
					arg_25_1.text_color = Colors.get_table("cheeseburger")
				end

				return true
			end
		}
	}
	local tbl_3 = {
		exit_texture_id = "tabs_icon_power",
		exit_texture_hover_id = "tabs_icon_power_glow",
		channel_hotspot = {},
		channel_name = arg_24_0,
		exit_button_hotspot = {}
	}
	local tbl_4 = {
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		arg_24_1,
		0
	}
	tbl.scenegraph_id = "channels_button_list_entry"

	return tbl
end

function create_popular_channels_entry(arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			pass_type = "hotspot",
			content_id = "channel_hotspot"
		},
		{
			style_id = "channel_name",
			pass_type = "text",
			text_id = "channel_name",
			content_check_function = function (self, arg_27_1)
				-- function 27
				if not self.channel_hotspot.is_hover then
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
	local tbl_3 = {
		exit_texture_id = "tabs_icon_power",
		exit_texture_hover_id = "tabs_icon_power_glow",
		channel_hotspot = {},
		channel_name = arg_26_0,
		num_users = arg_26_1,
		exit_button_hotspot = {}
	}
	local tbl_4 = {
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		arg_26_2,
		0
	}
	tbl.scenegraph_id = "popular_channels_button_list_entry"

	return tbl
end

function create_filtered_user_name_entry(arg_28_0, arg_28_1)
	-- function 28
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			pass_type = "hotspot",
			content_id = "user_name_hotspot"
		},
		{
			style_id = "user_name",
			pass_type = "text",
			text_id = "user_name",
			content_check_function = function (self, arg_29_1)
				-- function 29
				if not self.user_name_hotspot.is_hover then
					arg_29_1.text_color = Colors.get_table("white")
				else
					arg_29_1.text_color = Colors.get_table("medium_purple")
				end

				return true
			end
		}
	}
	local tbl_3 = {
		exit_texture_hover_id = "tabs_icon_power_glow",
		exit_texture_id = "tabs_icon_power",
		user_name_hotspot = {},
		user_name = arg_28_0,
		exit_button_hotspot = {}
	}
	local tbl_4 = {
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		arg_28_1,
		0
	}
	tbl.scenegraph_id = "filtered_user_names_list_entry"

	return tbl
end

function create_private_user_entry(arg_30_0, arg_30_1, arg_30_2)
	-- function 30
	local tbl = {
		element = {}
	}
	local sub = string.sub(arg_30_0, 1, -11)
	local tbl_2 = {
		{
			style_id = "exit_button_hotspot",
			pass_type = "hotspot",
			content_id = "exit_button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "exit_button",
			texture_id = "exit_texture_id",
			content_check_function = function (self)
				-- function 31
				return not self.exit_button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "exit_button_hover",
			texture_id = "exit_texture_hover_id",
			content_check_function = function (self)
				-- function 32
				return self.exit_button_hotspot.is_hover
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
			content_check_function = function (self, arg_33_1)
				-- function 33
				local selected_color = arg_33_1.selected_color
				local unselected_color = arg_33_1.unselected_color

				if not self.user_hotspot.is_hover then
					arg_33_1.text_color = selected_color
				else
					local num = 1

					if not self.new then
						local time = Managers.time:time("main")

						num = 0.5 + math.sin(time * 8) * 0.5
					end

					arg_33_1.current_color[2] = math.lerp(selected_color[2], unselected_color[2], num)
					arg_33_1.current_color[3] = math.lerp(selected_color[3], unselected_color[3], num)
					arg_33_1.current_color[4] = math.lerp(selected_color[4], unselected_color[4], num)
					arg_33_1.text_color = arg_33_1.current_color
				end

				return true
			end
		}
	}
	local tbl_3 = {
		exit_texture_hover_id = "tabs_icon_power_glow",
		exit_texture_id = "tabs_icon_power",
		user_hotspot = {},
		user_name = arg_30_0,
		trimmed_name = sub,
		exit_button_hotspot = {},
		new = arg_30_2
	}
	local tbl_4 = {
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		arg_30_1,
		0
	}
	tbl.scenegraph_id = "private_user_list_entry"

	return tbl
end

local tbl_8 = {
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
local tbl_9 = {
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
	-- function 34
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self, arg_35_1)
				-- function 35
				if not self.command_hotspot.is_hover then
					self.command_compare = self.command

					return true
				end

				local text = arg_34_6.text
				local command = self.command
				local len = string.len(command)
				local find, var_35_4 = string.find(command, text)

				if not (find == 1 or var_35_4 == len) then
					return false
				else
					self.command_compare = text

					return true
				end
			end
		},
		{
			style_id = "description",
			pass_type = "text",
			text_id = "description",
			content_check_function = function (self, arg_36_1)
				-- function 36
				return self.description ~= nil
			end
		}
	}
	local tbl_3 = {
		command_compare = " ",
		command_hotspot = {},
		command = arg_34_0,
		description = arg_34_1,
		parameter = arg_34_2,
		chat_text = arg_34_6
	}
	local tbl_4 = {
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		arg_34_5,
		0
	}
	tbl.scenegraph_id = "commands_list_entry"

	return tbl
end

function create_private_button(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6)
	-- function 37
	local var_37_0

	if not arg_37_6 then
		var_37_0 = "button_" .. arg_37_6
	else
		var_37_0 = "button_normal"
	end

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(var_37_0, 255)

	arg_37_3 = arg_37_3 or "button_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_37_3)
	local var_37_3

	if not arg_37_2 then
		var_37_3 = UIFrameSettings[arg_37_2]

		if not var_37_3 then
			-- Nothing
		end
	end

	var_37_3 = UIFrameSettings.button_frame_01

	::label_37_0::

	local tbl = {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (self)
						-- function 38
						self.disable_button = not self.parent.has_private_conversations

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
					content_check_function = function (self)
						-- function 39
						local is_clicked = self.button_hotspot.is_clicked

						return not is_clicked and is_clicked == 0
					end
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 40
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 41
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 42
						return self.button_hotspot.disable_button
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
					content_check_function = function (self)
						-- function 43
						local button_hotspot = self.button_hotspot
						local is_selected

						if not button_hotspot.disable_button then
							is_selected = button_hotspot.is_selected

							if not is_selected then
								is_selected = button_hotspot.is_hover
							end
						else
							is_selected = false
						end

						if false then
							is_selected = true
						end

						return is_selected
					end
				},
				{
					texture_id = "speech_bubble_id",
					style_id = "speech_bubble",
					pass_type = "texture",
					content_check_function = function (self, arg_44_1)
						-- function 44
						return self.num_private_messages > 0
					end
				},
				{
					style_id = "message_number",
					pass_type = "text",
					text_id = "message_number_text",
					content_check_function = function (self)
						-- function 45
						local num_private_messages = self.num_private_messages

						if num_private_messages <= 0 then
							return false
						end

						if num_private_messages > 10 then
							self.message_number_text = "..."
						else
							self.message_number_text = tostring(num_private_messages)
						end

						return true
					end
				}
			}
		}
	}
	local tbl_2 = {
		speech_bubble_id = "speech_bubble",
		message_number_text = "",
		num_private_messages = 0,
		glass_top = "button_glass_01",
		has_private_conversations = false
	}
	local str

	if not arg_37_6 then
		str = "button_state_hover_" .. arg_37_6

		if not str then
			-- Nothing
		end
	end

	str = "button_state_hover"

	::label_37_1::

	tbl_2.hover_glow = str

	local str_2

	if not arg_37_6 then
		str_2 = "button_state_normal_" .. arg_37_6

		if not str_2 then
			-- Nothing
		end
	end

	str_2 = "button_state_normal"

	::label_37_2::

	tbl_2.glow = str_2
	tbl_2.button_hotspot = {}
	tbl_2.title_text = arg_37_4 or "n/a"
	tbl_2.frame = var_37_3.texture
	tbl_2.background = {
		uvs = {
			{
				0,
				1 - arg_37_1[2] / get_atlas_settings_by_texture_name.size[2]
			},
			{
				arg_37_1[1] / get_atlas_settings_by_texture_name.size[1],
				1
			}
		},
		texture_id = arg_37_3
	}
	tbl_2.new_per_user = {}
	tbl.content = tbl_2
	tbl.style = {
		background = {
			color = get_color_table_with_alpha,
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
	}
	tbl.scenegraph_id = arg_37_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

local function fn_6()
	-- function 46
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
					content_check_function = function (self)
						-- function 47
						local texture_id = self.texture_id

						texture_id = not texture_id and self.hotspot.is_hover

						return texture_id
					end
				},
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 48
						return self.texture_id
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

local function fn_7()
	-- function 49
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self)
				-- function 50
				return self.emoji_text_id ~= nil
			end
		},
		{
			texture_id = "emoji_texture_id",
			style_id = "emoji_texture",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 51
				return self.emoji_texture_id
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local tbl_3 = {
		mask_texture = "mask_rect",
		frame = menu_frame_06.texture,
		hotspot = {},
		screen_hotspot = {}
	}
	local tbl_4 = {
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
			texture_size = menu_frame_06.texture_size,
			texture_sizes = menu_frame_06.texture_sizes,
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = "emoji_frame"

	return tbl
end

local function fn_8()
	-- function 52
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "rect",
			style_id = "scrollbar"
		}
	}
	local tbl_3 = {
		hotspot = {}
	}
	local tbl_4 = {
		scrollbar = {
			color = Colors.get_color_table_with_alpha("font_button_normal", 128)
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
	tbl.scenegraph_id = "emoji_scrollbar"

	return tbl
end

local function fn_9(arg_53_0, arg_53_1, arg_53_2)
	-- function 53
	local var_53_0

	if not arg_53_1 then
		var_53_0 = UIFrameSettings[arg_53_1]

		if not var_53_0 then
			-- Nothing
		end
	end

	var_53_0 = UIFrameSettings.menu_frame_06

	do
		local var_53_1
	end

	::label_53_0::

	if not arg_53_2 then
		var_53_1 = UIFrameSettings[arg_53_2]

		if not var_53_1 then
			-- Nothing
		end
	end

	var_53_1 = UIFrameSettings.frame_outer_glow_01

	::label_53_1::

	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self, arg_54_1)
				-- function 54
				local hover_color

				if not self.hotspot.is_hover then
					hover_color = arg_54_1.hover_color

					if not hover_color then
						-- Nothing
					end
				end

				hover_color = arg_54_1.base_color

				::label_54_0::

				arg_54_1.color = hover_color

				return true
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "selected_frame",
			texture_id = "selected_frame_id",
			content_check_function = function (self)
				-- function 55
				return self.channel_name == self.selected_channel
			end
		}
	}
	local tbl_3 = {
		num_members_id = "0",
		icon_id = "icons_placeholder",
		channel_name_id = "",
		frame_id = var_53_0.texture,
		selected_frame_id = var_53_1.texture,
		hotspot = {}
	}
	local tbl_4 = {
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_53_0

	return tbl
end

local function fn_10(arg_56_0, arg_56_1)
	-- function 56
	local str = "menu_frame_bg_03"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local menu_frame_02 = UIFrameSettings.menu_frame_02
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local menu_frame_06_2 = UIFrameSettings.menu_frame_06
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self, arg_57_1)
				-- function 57
				if not self.fetching_channels then
					return false
				end

				local num = Managers.time:mean_dt() * 400 % 360
				local degrees_to_radians = math.degrees_to_radians(num)

				arg_57_1.angle = arg_57_1.angle + degrees_to_radians

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
			content_check_function = function (self, arg_58_1)
				-- function 58
				if not self.text_field_active then
					return
				end

				if not self.input_hotspot.is_hover then
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
			content_check_function = function (self, arg_59_1)
				-- function 59
				if not self.text_field_active then
					return
				end

				local num = math.floor(Managers.time:time("main") * 2) % 2
				local caret_color = arg_59_1.caret_color
				local flag

				flag = num ~= 0 or not 255 or 0
				caret_color[1] = flag

				return true
			end
		},
		{
			style_id = "close_text",
			pass_type = "text",
			text_id = "close_text_id",
			content_check_function = function (self, arg_60_1)
				-- function 60
				if not self.close_hotspot.is_hover then
					arg_60_1.text_color[1] = 255
				else
					arg_60_1.text_color[1] = 128
				end

				return true
			end
		}
	}
	local tbl_3 = {
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
		frame = menu_frame_02.texture,
		inner_frame = menu_frame_06.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_56_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
					math.min(arg_56_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
				}
			},
			texture_id = str
		},
		background_id = str
	}
	local tbl_4 = {
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
			texture_tiling_size = get_atlas_settings_by_texture_name.size
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
			texture_size = menu_frame_06.texture_size,
			texture_sizes = menu_frame_06.texture_sizes,
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
			texture_size = menu_frame_06_2.texture_size,
			texture_sizes = menu_frame_06_2.texture_sizes,
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
			texture_tiling_size = get_atlas_settings_by_texture_name.size
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
			texture_size = menu_frame_06.texture_size,
			texture_sizes = menu_frame_06.texture_sizes,
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_56_0

	return tbl
end

local function fn_11(arg_61_0, arg_61_1)
	-- function 61
	local str = "menu_frame_bg_03"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local menu_frame_02 = UIFrameSettings.menu_frame_02
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local menu_frame_06_2 = UIFrameSettings.menu_frame_06
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self, arg_62_1)
				-- function 62
				if not self.text_field_active then
					return
				end

				local num = math.floor(Managers.time:time("main") * 2) % 2
				local caret_color = arg_62_1.caret_color
				local flag

				flag = num ~= 0 or not 255 or 0
				caret_color[1] = flag

				return true
			end
		},
		{
			style_id = "close_text",
			pass_type = "text",
			text_id = "close_text_id",
			content_check_function = function (self, arg_63_1)
				-- function 63
				if not self.close_hotspot.is_hover then
					arg_63_1.text_color[1] = 255
				else
					arg_63_1.text_color[1] = 128
				end

				return true
			end
		}
	}
	local tbl_3 = {
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
		frame = menu_frame_02.texture,
		inner_frame = menu_frame_06.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_61_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
					math.min(arg_61_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
				}
			},
			texture_id = str
		},
		background_id = str
	}
	local tbl_4 = {
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
			texture_tiling_size = get_atlas_settings_by_texture_name.size
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
			texture_size = menu_frame_06.texture_size,
			texture_sizes = menu_frame_06.texture_sizes,
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
			texture_size = menu_frame_06_2.texture_size,
			texture_sizes = menu_frame_06_2.texture_sizes,
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_61_0

	return tbl
end

local function fn_12(arg_64_0, arg_64_1)
	-- function 64
	local str = "menu_frame_bg_03"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local menu_frame_02 = UIFrameSettings.menu_frame_02
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local menu_frame_06_2 = UIFrameSettings.menu_frame_06
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self, arg_65_1)
				-- function 65
				if not self.text_field_active then
					return
				end

				local num = math.floor(Managers.time:time("main") * 2) % 2
				local caret_color = arg_65_1.caret_color
				local flag

				flag = num ~= 0 or not 255 or 0
				caret_color[1] = flag

				return true
			end
		},
		{
			style_id = "close_text",
			pass_type = "text",
			text_id = "close_text_id",
			content_check_function = function (self, arg_66_1)
				-- function 66
				if not self.close_hotspot.is_hover then
					arg_66_1.text_color[1] = 255
				else
					arg_66_1.text_color[1] = 128
				end

				return true
			end
		}
	}
	local tbl_3 = {
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
		frame = menu_frame_02.texture,
		inner_frame = menu_frame_06.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_64_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
					math.min(arg_64_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
				}
			},
			texture_id = str
		},
		background_id = str
	}
	local tbl_4 = {
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
			texture_tiling_size = get_atlas_settings_by_texture_name.size
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
			texture_size = menu_frame_06.texture_size,
			texture_sizes = menu_frame_06.texture_sizes,
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
			texture_size = menu_frame_06_2.texture_size,
			texture_sizes = menu_frame_06_2.texture_sizes,
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
			texture_tiling_size = get_atlas_settings_by_texture_name.size
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_64_0

	return tbl
end

local function fn_13(arg_67_0, arg_67_1)
	-- function 67
	local str = "menu_frame_bg_03"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local menu_frame_02 = UIFrameSettings.menu_frame_02
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local menu_frame_06_2 = UIFrameSettings.menu_frame_06
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self, arg_68_1)
				-- function 68
				if not self.fetching_channels then
					return false
				end

				local num = Managers.time:mean_dt() * 400 % 360
				local degrees_to_radians = math.degrees_to_radians(num)

				arg_68_1.angle = arg_68_1.angle + degrees_to_radians

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
			content_check_function = function (self, arg_69_1)
				-- function 69
				if not self.close_hotspot.is_hover then
					arg_69_1.text_color[1] = 255
				else
					arg_69_1.text_color[1] = 128
				end

				return true
			end
		}
	}
	local tbl_3 = {
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
		frame = menu_frame_02.texture,
		inner_frame = menu_frame_06.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_67_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
					math.min(arg_67_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
				}
			},
			texture_id = str
		},
		background_id = str
	}
	local tbl_4 = {
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
			texture_tiling_size = get_atlas_settings_by_texture_name.size
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
			texture_size = menu_frame_06.texture_size,
			texture_sizes = menu_frame_06.texture_sizes,
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
			texture_size = menu_frame_06_2.texture_size,
			texture_sizes = menu_frame_06_2.texture_sizes,
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
			texture_tiling_size = get_atlas_settings_by_texture_name.size
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_67_0

	return tbl
end

function create_default_button(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5, arg_70_6)
	-- function 70
	arg_70_3 = arg_70_3 or "button_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_70_3)
	local var_70_1

	if not arg_70_2 then
		var_70_1 = UIFrameSettings[arg_70_2]

		if not var_70_1 then
			-- Nothing
		end
	end

	var_70_1 = UIFrameSettings.button_frame_01

	::label_70_0::

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
					content_check_function = function (self)
						-- function 71
						return self.draw_frame
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
					content_check_function = function (self)
						-- function 72
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 73
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 74
						return self.button_hotspot.disable_button
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
						1 - arg_70_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_70_1[1] / get_atlas_settings_by_texture_name.size[1],
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

local tbl_10 = {
	widgets = {
		frame_widget = fn("popup_root", tbl_3.popup_root.size),
		chat_output_widget = fn_2("feed_area_edge", 0),
		name_list_widget = UIWidgets.create_rect_with_frame("list_area", tbl_3.list_area.size, {
			160,
			0,
			0,
			0
		}, str),
		list_area_hotspot_widget = UIWidgets.create_simple_hotspot("list_area"),
		private_messages_widget = create_private_button("private_messages_button", tbl_3.private_messages_button.size, nil, nil, "Private", 20),
		send_invite_widget = create_default_button("channels_button", tbl_3.channels_button.size, nil, nil, "Invite", 20),
		channels_widget = create_default_button("popular_channels_button", tbl_3.popular_channels_button.size, nil, nil, "Channels", 20),
		commands_widget = create_default_button("commands_button", tbl_3.commands_button.size, nil, nil, "?", 20, true),
		emoji_widget = create_default_button("emoji_button", tbl_3.emoji_button.size, nil, nil, ":)", 20, true)
	},
	create_channel_entry_func = create_channel_entry,
	channel_list_frame = tbl_4,
	create_channel_tab = fn_5,
	create_private_user_entry_func = create_private_user_entry,
	private_user_list_frame = tbl_5,
	create_recent_channel_entry_func = create_recent_channel_entry,
	recent_channels_list_frame = tbl_6,
	create_popular_channels_entry_func = create_popular_channels_entry,
	popular_channels_list_frame = tbl_7,
	create_command_entry_func = create_command_entry,
	commands_list_frame = tbl_8,
	create_emoji_func = fn_6,
	create_emoji_frame_func = fn_7,
	create_emoji_scroller_func = fn_8,
	channels_window = fn_10("channels_window_root", tbl_3.channels_window_root.size),
	channel_entry = fn_9("channels_window_list_box_entry"),
	join_channel_button = create_default_button("join_channel_button", tbl_3.join_channel_button.size, nil, nil, "Join", 20),
	create_channel_button = create_default_button("create_channel_button", tbl_3.create_channel_button.size, nil, nil, "Create", 20),
	recent_channels_button = create_default_button("recent_channels_button", tbl_3.recent_channels_button.size, nil, nil, "Recent", 20),
	create_channel_window = fn_11("create_channels_window_root", tbl_3.create_channels_window_root.size),
	inner_create_channel_button = create_default_button("inner_create_channel_button", tbl_3.inner_create_channel_button.size, nil, nil, "Create", 20),
	recent_channels_window = fn_13("recent_channels_window_root", tbl_3.recent_channels_window_root.size),
	recent_join_channel_button = create_default_button("recent_join_channel_button", tbl_3.join_channel_button.size, nil, nil, "Join", 20),
	create_channel_list_entry_func = fn_9,
	send_invite_window = fn_12("create_channels_window_root", tbl_3.create_channels_window_root.size),
	send_invite_button = create_default_button("send_invite_button", tbl_3.send_invite_button.size, nil, nil, "Send Invite", 20),
	create_filtered_user_name_entry_func = create_filtered_user_name_entry,
	filtered_user_names_list_frame = tbl_9
}

return {
	num_users_in_list = num_2,
	create_entry_func = fn_4,
	scenegraph_definition = tbl_3,
	widget_definitions = tbl_10,
	emoji_list_settings = tbl,
	channels_list_settings = tbl_2
}
