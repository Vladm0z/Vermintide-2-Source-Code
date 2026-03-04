-- chunkname: @scripts/ui/views/chat_gui_definitions.lua

local var_0_0 = 500
local var_0_1 = 200
local var_0_2 = var_0_0 - 10

if not rawget(_G, "Irc") then
	Irc = {
		PARTY_MSG = 7,
		META_MSG = 9,
		LIST_END_MSG = 8,
		PRIVATE_MSG = 0,
		LIST_MSG = 6,
		JOIN_MSG = 3,
		CHANNEL_MSG = 1,
		SYSTEM_MSG = 2,
		LEAVE_MSG = 4,
		NAMES_MSG = 5
	}
end

IRC_CHANNEL_COLORS = {
	[Irc.PRIVATE_MSG] = Colors.get_table("medium_purple"),
	[Irc.CHANNEL_MSG] = Colors.get_table("khaki"),
	[Irc.SYSTEM_MSG] = Colors.get_table("gold"),
	[Irc.PARTY_MSG] = Colors.get_table("khaki"),
	[Irc.TEAM_MSG] = Colors.get_table("khaki"),
	[Irc.ALL_MSG] = Colors.get_table("khaki")
}

local var_0_3 = {
	root_parent = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.chat
		},
		size = {
			1920,
			1080
		}
	},
	root = {
		parent = "root_parent",
		position = {
			0,
			0,
			0
		},
		size = {
			1920,
			1080
		}
	},
	root_dragger = {
		parent = "root",
		position = {
			0,
			200,
			0
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.chat
		},
		size = {
			1920,
			1080
		}
	},
	chat_window_root = {
		parent = "root",
		position = {
			0,
			200,
			0
		},
		size = {
			1,
			1
		}
	},
	chat_window_background = {
		parent = "chat_window_root",
		position = {
			0,
			0,
			1
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	chat_window_frame_top = {
		parent = "chat_window_root",
		position = {
			0,
			var_0_1,
			2
		},
		size = {
			var_0_0,
			4
		}
	},
	chat_window_frame_top_info = {
		vertical_alignment = "bottom",
		parent = "chat_window_frame_top",
		horizontal_alignment = "right",
		size = {
			24,
			24
		}
	},
	chat_window_frame_top_enlarge = {
		vertical_alignment = "bottom",
		parent = "chat_window_frame_top",
		horizontal_alignment = "right",
		position = {
			-24,
			0,
			0
		},
		size = {
			24,
			24
		}
	},
	chat_window_frame_top_filter = {
		vertical_alignment = "bottom",
		parent = "chat_window_frame_top",
		horizontal_alignment = "right",
		position = {
			-48,
			0,
			0
		},
		size = {
			24,
			24
		}
	},
	chat_window_frame_bottom = {
		parent = "chat_window_root",
		position = {
			0,
			0,
			2
		},
		size = {
			var_0_0,
			4
		}
	},
	chat_window_frame_top_target = {
		vertical_alignment = "bottom",
		parent = "chat_window_frame_top",
		horizontal_alignment = "right",
		position = {
			-72,
			0,
			0
		},
		size = {
			24,
			24
		}
	},
	chat_tab_root = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		position = {
			20,
			20,
			1
		},
		size = {
			60,
			60
		}
	},
	chat_scrollbar_root = {
		parent = "chat_window_root",
		position = {
			var_0_0 - 7,
			6,
			2
		},
		size = {
			1,
			1
		}
	},
	chat_scrollbar_background = {
		parent = "chat_scrollbar_root",
		position = {
			1,
			1,
			2
		},
		size = {
			2,
			var_0_1 - 14
		}
	},
	chat_scrollbar_background_hotspot = {
		parent = "chat_scrollbar_root",
		position = {
			-10,
			0,
			2
		},
		size = {
			24,
			var_0_1 - 14
		}
	},
	chat_background_stroke_top = {
		parent = "chat_scrollbar_root",
		position = {
			0,
			var_0_1 - 13,
			2
		},
		size = {
			4,
			1
		}
	},
	chat_background_stroke_bottom = {
		parent = "chat_scrollbar_root",
		position = {
			0,
			0,
			2
		},
		size = {
			4,
			1
		}
	},
	chat_background_stroke_left = {
		parent = "chat_scrollbar_root",
		position = {
			0,
			1,
			2
		},
		size = {
			1,
			var_0_1 - 14
		}
	},
	chat_background_stroke_right = {
		parent = "chat_scrollbar_root",
		position = {
			3,
			1,
			2
		},
		size = {
			1,
			var_0_1 - 14
		}
	},
	chat_scrollbar = {
		parent = "chat_scrollbar_root",
		position = {
			1,
			1,
			3
		},
		size = {
			2,
			65
		}
	},
	chat_scrollbar_stroke_top = {
		parent = "chat_scrollbar",
		position = {
			0,
			65,
			3
		},
		size = {
			2,
			2
		}
	},
	chat_scrollbar_stroke_bottom = {
		parent = "chat_scrollbar",
		position = {
			0,
			-2,
			3
		},
		size = {
			2,
			2
		}
	},
	chat_output_root = {
		parent = "chat_window_root",
		position = {
			8,
			0,
			1
		},
		size = {
			1,
			1
		}
	},
	chat_output_text = {
		parent = "chat_output_root",
		position = {
			0,
			0,
			2
		},
		size = {
			var_0_0 - 15,
			var_0_1 - 26
		}
	},
	chat_input_box = {
		vertical_alignment = "top",
		parent = "chat_window_background",
		horizontal_alignment = "left",
		position = {
			0,
			-var_0_1,
			5
		},
		size = {
			var_0_0,
			20
		}
	},
	chat_input_text = {
		vertical_alignment = "center",
		parent = "chat_input_box",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			var_0_0,
			20
		}
	},
	chat_mask = {
		parent = "root",
		position = {
			0,
			165,
			0
		},
		size = {
			var_0_0,
			var_0_1
		}
	}
}
local var_0_4 = {
	scenegraph_id = "chat_window_background",
	element = {
		passes = {
			{
				pass_type = "rect",
				style_id = "background"
			}
		}
	},
	content = {},
	style = {
		background = {
			masked = false,
			color = {
				180,
				20,
				20,
				20
			}
		}
	}
}
local var_0_5 = {
	scenegraph_id = "chat_input_box",
	element = {
		passes = {
			{
				style_id = "info_hotspot",
				pass_type = "hotspot",
				content_id = "info_hotspot"
			},
			{
				style_id = "info_hotspot",
				pass_type = "rect",
				content_check_function = function (arg_1_0)
					return GameSettingsDevelopment.use_global_chat
				end,
				content_change_function = function (arg_2_0, arg_2_1)
					arg_2_1.color = arg_2_0.info_hotspot.is_hover and arg_2_1.selected_color or arg_2_1.base_color
				end
			},
			{
				style_id = "info_icon",
				pass_type = "rect",
				content_check_function = function (arg_3_0)
					return GameSettingsDevelopment.use_global_chat
				end
			},
			{
				style_id = "info_icon_text",
				pass_type = "text",
				text_id = "info_icon_text",
				content_check_function = function (arg_4_0)
					return GameSettingsDevelopment.use_global_chat
				end,
				content_change_function = function (arg_5_0, arg_5_1)
					arg_5_1.text_color = arg_5_0.info_hotspot.is_hover and arg_5_1.selected_color or arg_5_1.base_color
				end
			},
			{
				style_id = "enlarge_hotspot",
				pass_type = "hotspot",
				content_id = "enlarge_hotspot"
			},
			{
				style_id = "enlarge_hotspot",
				pass_type = "rect",
				content_check_function = function (arg_6_0)
					return GameSettingsDevelopment.use_global_chat
				end,
				content_change_function = function (arg_7_0, arg_7_1)
					arg_7_1.color = arg_7_0.enlarge_hotspot.is_hover and arg_7_1.selected_color or arg_7_1.base_color
				end
			},
			{
				style_id = "enlarge_icon",
				pass_type = "rect",
				content_check_function = function (arg_8_0)
					return GameSettingsDevelopment.use_global_chat
				end
			},
			{
				style_id = "filter_hotspot",
				pass_type = "hotspot",
				content_id = "filter_hotspot"
			},
			{
				style_id = "filter_hotspot",
				pass_type = "rect",
				content_check_function = function (arg_9_0)
					return GameSettingsDevelopment.use_global_chat
				end,
				content_change_function = function (arg_10_0, arg_10_1)
					arg_10_1.color = arg_10_0.filter_hotspot.is_hover and arg_10_1.selected_color or arg_10_1.base_color
				end
			},
			{
				style_id = "filter_icon",
				pass_type = "triangle",
				content_check_function = function (arg_11_0)
					return GameSettingsDevelopment.use_global_chat
				end
			},
			{
				style_id = "target_hotspot",
				pass_type = "hotspot",
				content_id = "target_hotspot"
			},
			{
				style_id = "target_hotspot",
				pass_type = "rect",
				content_check_function = function (arg_12_0)
					return GameSettingsDevelopment.use_global_chat
				end,
				content_change_function = function (arg_13_0, arg_13_1)
					arg_13_1.color = arg_13_0.target_hotspot.is_hover and arg_13_1.selected_color or arg_13_1.base_color
				end
			},
			{
				style_id = "target_icon",
				pass_type = "triangle",
				content_check_function = function (arg_14_0)
					return GameSettingsDevelopment.use_global_chat
				end
			},
			{
				pass_type = "rect",
				style_id = "background"
			},
			{
				style_id = "background_header",
				pass_type = "rect",
				content_check_function = function (arg_15_0, arg_15_1)
					return GameSettingsDevelopment.use_global_chat
				end
			},
			{
				style_id = "background_header_front",
				pass_type = "rect",
				content_check_function = function (arg_16_0, arg_16_1)
					return GameSettingsDevelopment.use_global_chat
				end
			},
			{
				style_id = "text",
				pass_type = "text",
				text_id = "text_field"
			},
			{
				style_id = "channel_text",
				pass_type = "text",
				text_id = "channel_field"
			},
			{
				style_id = "header_text",
				pass_type = "text",
				text_id = "header_field",
				content_check_function = function (arg_17_0, arg_17_1)
					return GameSettingsDevelopment.use_global_chat
				end
			}
		}
	},
	content = {
		header_field = "All",
		channel_field = "Party",
		caret_index = 1,
		info_icon_text = "?",
		text_field = "",
		text_index = 1,
		info_hotspot = {},
		enlarge_hotspot = {},
		filter_hotspot = {},
		target_hotspot = {}
	},
	style = {
		background = {
			color = {
				200,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				1
			}
		},
		info_hotspot = {
			vertical_alignment = "center",
			scenegraph_id = "chat_window_frame_top_info",
			horizontal_alignment = "right",
			color = {
				255,
				255,
				255,
				255
			},
			base_color = {
				255,
				0,
				0,
				0
			},
			selected_color = {
				255,
				255,
				255,
				255
			},
			texture_size = {
				16,
				16
			},
			offset = {
				-4,
				0,
				2
			}
		},
		info_icon_text = {
			scenegraph_id = "chat_window_frame_top_info",
			font_size = 14,
			pixel_perfect = false,
			horizontal_alignment = "right",
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "arial",
			text_color = Colors.get_table("white"),
			base_color = {
				255,
				90,
				90,
				90
			},
			selected_color = Colors.get_table("white"),
			offset = {
				-8,
				0,
				5
			}
		},
		info_icon = {
			vertical_alignment = "center",
			scenegraph_id = "chat_window_frame_top_info",
			horizontal_alignment = "right",
			color = {
				255,
				0,
				0,
				0
			},
			texture_size = {
				14,
				14
			},
			offset = {
				-5,
				0,
				5
			}
		},
		enlarge_hotspot = {
			vertical_alignment = "center",
			scenegraph_id = "chat_window_frame_top_enlarge",
			horizontal_alignment = "right",
			color = {
				255,
				255,
				255,
				255
			},
			base_color = {
				255,
				90,
				90,
				90
			},
			selected_color = {
				255,
				255,
				255,
				255
			},
			texture_size = {
				14,
				14
			},
			offset = {
				-4,
				0,
				2
			}
		},
		enlarge_icon = {
			vertical_alignment = "center",
			scenegraph_id = "chat_window_frame_top_enlarge",
			horizontal_alignment = "right",
			color = {
				255,
				0,
				0,
				0
			},
			texture_size = {
				12,
				12
			},
			offset = {
				-5,
				0,
				2
			}
		},
		filter_hotspot = {
			vertical_alignment = "center",
			scenegraph_id = "chat_window_frame_top_filter",
			horizontal_alignment = "right",
			color = {
				255,
				255,
				255,
				255
			},
			base_color = {
				255,
				90,
				90,
				90
			},
			selected_color = {
				255,
				255,
				255,
				255
			},
			texture_size = {
				14,
				14
			},
			offset = {
				-4,
				0,
				2
			}
		},
		filter_icon = {
			vertical_alignment = "center",
			scenegraph_id = "chat_window_frame_top_filter",
			horizontal_alignment = "right",
			triangle_alignment = "top_left",
			color = {
				255,
				0,
				0,
				0
			},
			texture_size = {
				12,
				12
			},
			offset = {
				-5,
				0,
				2
			}
		},
		target_hotspot = {
			vertical_alignment = "center",
			scenegraph_id = "chat_window_frame_top_target",
			horizontal_alignment = "right",
			color = {
				255,
				255,
				255,
				255
			},
			base_color = {
				255,
				90,
				90,
				90
			},
			selected_color = {
				255,
				255,
				255,
				255
			},
			texture_size = {
				14,
				14
			},
			offset = {
				-4,
				-0,
				2
			}
		},
		target_icon = {
			vertical_alignment = "center",
			scenegraph_id = "chat_window_frame_top_target",
			horizontal_alignment = "right",
			triangle_alignment = "top_right",
			color = {
				255,
				0,
				0,
				0
			},
			texture_size = {
				12,
				12
			},
			offset = {
				-5,
				-0,
				2
			}
		},
		background_header = {
			scenegraph_id = "chat_window_frame_top",
			color = Colors.get_table("very_dark_gray"),
			size = {
				var_0_0,
				24
			}
		},
		background_header_front = {
			scenegraph_id = "chat_window_frame_top",
			color = Colors.get_table("black"),
			size = {
				var_0_0 - 2,
				22
			},
			offset = {
				1,
				1,
				1
			}
		},
		text = {
			scenegraph_id = "chat_input_text",
			font_size = 22,
			horizontal_scroll = true,
			pixel_perfect = false,
			dynamic_font = true,
			font_type = "arial",
			text_color = Colors.get_table("white"),
			offset = {
				10,
				0,
				3
			},
			caret_size = {
				2,
				26
			},
			caret_offset = {
				0,
				-6,
				4
			},
			caret_color = Colors.get_table("white")
		},
		channel_text = {
			horizontal_alignment = "left",
			scenegraph_id = "chat_input_text",
			font_size = 22,
			pixel_perfect = false,
			vertical_alignment = "center",
			dynamic_font = true,
			font_type = "arial",
			text_color = Colors.get_table("medium_purple"),
			offset = {
				6,
				0,
				3
			}
		},
		header_text = {
			font_size = 18,
			dynamic_font = true,
			scenegraph_id = "chat_window_frame_top",
			pixel_perfect = false,
			font_type = "arial",
			text_color = Colors.get_table("white"),
			offset = {
				8,
				-2,
				3
			}
		}
	}
}
local var_0_6 = {
	scenegraph_id = "chat_output_root",
	element = UIElements.TextAreaChat,
	content = {
		text_start_offset = 0,
		message_tables = {}
	},
	style = {
		background = {
			corner_radius = 0,
			color = Colors.get_table("black")
		},
		text = {
			font_size = 20,
			scenegraph_id = "chat_output_text",
			pixel_perfect = false,
			vertical_alignment = "top",
			dynamic_font = true,
			word_wrap = true,
			font_type = "chat_output_font",
			text_color = Colors.get_table("white"),
			default_color = Colors.get_table("white"),
			name_color = Colors.get_table("sky_blue"),
			name_color_dev = Colors.get_table("cheeseburger"),
			name_color_system = Colors.get_table("gold"),
			offset = {
				0,
				0,
				3
			}
		}
	}
}
local var_0_7 = {
	scenegraph_id = "chat_scrollbar_root",
	element = {
		passes = {
			{
				pass_type = "rect",
				style_id = "background",
				texture_id = "background_rect"
			},
			{
				pass_type = "rect",
				style_id = "background_stroke_top",
				texture_id = "background_stroke_top_rect"
			},
			{
				pass_type = "rect",
				style_id = "background_stroke_bottom",
				texture_id = "background_stroke_bottom_rect"
			},
			{
				pass_type = "rect",
				style_id = "background_stroke_left",
				texture_id = "background_stroke_left_rect"
			},
			{
				pass_type = "rect",
				style_id = "background_stroke_right",
				texture_id = "background_stroke_right_rect"
			},
			{
				style_id = "scrollbar",
				pass_type = "local_offset",
				offset_function = function (arg_18_0, arg_18_1, arg_18_2)
					local var_18_0 = UISceneGraph.get_local_position(arg_18_0, arg_18_1.scenegraph_id)
					local var_18_1 = arg_18_2.scroll_bar_height
					local var_18_2 = var_18_1 / 2
					local var_18_3 = arg_18_2.scroll_offset_min
					local var_18_4 = arg_18_2.scroll_offset_max
					local var_18_5 = math.min(var_18_3 + (var_18_4 - var_18_3) * arg_18_2.internal_scroll_value, var_18_4 - var_18_1)

					var_18_0[2] = var_18_5
					arg_18_2.scroll_value = (var_18_5 - var_18_3) / (var_18_4 - var_18_1 - var_18_3)
				end
			},
			{
				pass_type = "rect",
				style_id = "scrollbar",
				texture_id = "scrollbar_rect"
			},
			{
				pass_type = "rect",
				style_id = "scrollbar_stroke_top",
				texture_id = "scrollbar_stroke_top_rect"
			},
			{
				pass_type = "rect",
				style_id = "scrollbar_stroke_bottom",
				texture_id = "scrollbar_stroke_bottom_rect"
			},
			{
				pass_type = "hover",
				style_id = "background_hotspot"
			},
			{
				style_id = "background_hotspot",
				pass_type = "held",
				held_function = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
					local var_19_0 = UIInverseScaleVectorToResolution(arg_19_3:get("cursor"))
					local var_19_1 = arg_19_1.scenegraph_id
					local var_19_2 = UISceneGraph.get_world_position(arg_19_0, var_19_1)
					local var_19_3 = arg_19_2.scroll_bar_height / 2
					local var_19_4 = var_19_3
					local var_19_5 = var_19_0[2] - var_19_4
					local var_19_6 = UISceneGraph.get_size(arg_19_0, var_19_1)
					local var_19_7 = var_19_5 - var_19_2[2]
					local var_19_8 = var_19_2[2] + var_19_3
					local var_19_9 = arg_19_2.scroll_offset_max
					local var_19_10 = var_19_2[2] + var_19_9 - var_19_3 - arg_19_2.scroll_offset_min
					local var_19_11 = math.clamp(var_19_7, 0, var_19_6[2])

					arg_19_2.internal_scroll_value = math.min(var_19_11 / var_19_6[2], 1)
				end
			}
		}
	},
	content = {
		scroll_bar_height = 65,
		scroll_offset_min = 2,
		internal_scroll_value = 0,
		scroll_value = 0,
		scroll_offset_max = var_0_1 - 14
	},
	style = {
		background_hotspot = {
			scenegraph_id = "chat_scrollbar_background_hotspot",
			color = {
				0,
				0,
				0,
				0
			}
		},
		background = {
			scenegraph_id = "chat_scrollbar_background",
			color = Colors.get_table("gray")
		},
		scrollbar = {
			scenegraph_id = "chat_scrollbar",
			color = Colors.get_table("light_gray")
		},
		background_stroke_top = {
			scenegraph_id = "chat_background_stroke_top",
			color = Colors.get_table("black")
		},
		background_stroke_bottom = {
			scenegraph_id = "chat_background_stroke_bottom",
			color = Colors.get_table("black")
		},
		background_stroke_left = {
			scenegraph_id = "chat_background_stroke_left",
			color = Colors.get_table("black")
		},
		background_stroke_right = {
			scenegraph_id = "chat_background_stroke_right",
			color = Colors.get_table("black")
		},
		scrollbar_stroke_top = {
			scenegraph_id = "chat_scrollbar_stroke_top",
			color = Colors.get_table("black")
		},
		scrollbar_stroke_bottom = {
			scenegraph_id = "chat_scrollbar_stroke_bottom",
			color = Colors.get_table("black")
		}
	}
}

local function var_0_8(arg_20_0, arg_20_1)
	local var_20_0 = UIFrameSettings.menu_frame_12
	local var_20_1 = {
		passes = {
			{
				style_id = "button",
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				pass_type = "rect",
				style_id = "button"
			},
			{
				pass_type = "texture_frame",
				style_id = "frame",
				texture_id = "frame"
			},
			{
				pass_type = "texture",
				style_id = "icon",
				texture_id = "icon",
				content_check_function = function (arg_21_0)
					return not arg_21_0.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "icon_hover",
				texture_id = "icon",
				content_check_function = function (arg_22_0)
					return arg_22_0.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "hover",
				texture_id = "hover",
				content_check_function = function (arg_23_0)
					return arg_23_0.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "button_notification",
				texture_id = "button_notification"
			}
		}
	}
	local var_20_2 = {
		button_notification = "chat_icon_glow",
		hover = "button_state_default_2",
		icon = "chat_icon_01",
		button_hotspot = {},
		frame = var_20_0.texture
	}
	local var_20_3 = {
		button = {
			color = Colors.get_color_table_with_alpha("black", 200),
			offset = {
				0,
				0,
				0
			}
		},
		icon = {
			color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				0,
				0,
				4
			}
		},
		icon_hover = {
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				0,
				4
			}
		},
		frame = {
			texture_size = var_20_0.texture_size,
			texture_sizes = var_20_0.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				3
			}
		},
		hover = {
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
		button_notification = {
			color = {
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
	}

	return {
		element = var_20_1,
		content = var_20_2,
		style = var_20_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_20_0
	}
end

function create_additional_chat_tooltip(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7, arg_24_8)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "tooltip",
					additional_option_id = "tooltip",
					pass_type = "additional_option_tooltip",
					content_passes = arg_24_2 or {
						"additional_option_info"
					},
					content_check_function = function (arg_25_0)
						return arg_25_0.tooltip and arg_25_0.button_hotspot.is_hover and GameSettingsDevelopment.use_global_chat
					end
				}
			}
		},
		content = {
			tooltip = arg_24_3 or nil,
			button_hotspot = {
				allow_multi_hover = true
			}
		},
		style = {
			tooltip = {
				grow_downwards = arg_24_7,
				max_width = arg_24_4 or 300,
				horizontal_alignment = arg_24_5 or "center",
				vertical_alignment = arg_24_6 or "bottom",
				offset = arg_24_8 or {
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
		},
		scenegraph_id = arg_24_0
	}
end

local var_0_9 = {
	chat_target_tooltip = create_additional_chat_tooltip("chat_window_frame_top_target", var_0_3.chat_window_frame_top_filter.size, nil, {
		title = Localize("chat_menu_tooltip_target_title"),
		description = Localize("menu_chat_tooltip_target_description")
	}, nil, nil, "top", nil),
	chat_filter_tooltip = create_additional_chat_tooltip("chat_window_frame_top_filter", var_0_3.chat_window_frame_top_filter.size, nil, {
		title = Localize("chat_menu_tooltip_filter_title"),
		description = Localize("menu_chat_tooltip_filter_description")
	}, nil, nil, "top", nil),
	chat_enlarge_tooltip = create_additional_chat_tooltip("chat_window_frame_top_enlarge", var_0_3.chat_window_frame_top_enlarge.size, nil, {
		title = Localize("chat_menu_tooltip_enlarge_title"),
		description = Localize("menu_chat_tooltip_enlarge_description")
	}, nil, nil, "top", nil),
	chat_info_tooltip = create_additional_chat_tooltip("chat_window_frame_top_info", var_0_3.chat_window_frame_top_info.size, nil, {
		title = Localize("chat_menu_tooltip_info_title"),
		description = Localize("menu_chat_tooltip_info_description")
	}, nil, nil, "top", nil)
}

return {
	CHAT_WIDTH = var_0_0,
	CHAT_HEIGHT = var_0_1,
	CHAT_INPUT_TEXT_WIDTH = var_0_2,
	scenegraph_definition = var_0_3,
	chat_window_widget = var_0_4,
	chat_output_widget = var_0_6,
	chat_input_widget = var_0_5,
	chat_scrollbar_widget = var_0_7,
	chat_tab_widget = var_0_8("chat_tab_root", var_0_3.chat_tab_root.size),
	widgets = var_0_9
}
