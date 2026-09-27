-- chunkname: @scripts/ui/views/chat_gui_definitions.lua

local num = 500
local num_2 = 200
local num_3 = num - 10

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

local tbl = {
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
			num,
			num_2
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
			num,
			num_2
		}
	},
	chat_window_frame_top = {
		parent = "chat_window_root",
		position = {
			0,
			num_2,
			2
		},
		size = {
			num,
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
			num,
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
			num - 7,
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
			num_2 - 14
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
			num_2 - 14
		}
	},
	chat_background_stroke_top = {
		parent = "chat_scrollbar_root",
		position = {
			0,
			num_2 - 13,
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
			num_2 - 14
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
			num_2 - 14
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
			num - 15,
			num_2 - 26
		}
	},
	chat_input_box = {
		vertical_alignment = "top",
		parent = "chat_window_background",
		horizontal_alignment = "left",
		position = {
			0,
			-num_2,
			5
		},
		size = {
			num,
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
			num,
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
			num,
			num_2
		}
	}
}
local tbl_2 = {
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
local tbl_3 = {
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
					-- function 1
					return GameSettingsDevelopment.use_global_chat
				end,
				content_change_function = function (self, arg_2_1)
					-- function 2
					local selected_color

					if not self.info_hotspot.is_hover then
						selected_color = arg_2_1.selected_color

						if not selected_color then
							-- Nothing
						end
					end

					selected_color = arg_2_1.base_color

					::label_2_0::

					arg_2_1.color = selected_color
				end
			},
			{
				style_id = "info_icon",
				pass_type = "rect",
				content_check_function = function (arg_3_0)
					-- function 3
					return GameSettingsDevelopment.use_global_chat
				end
			},
			{
				style_id = "info_icon_text",
				pass_type = "text",
				text_id = "info_icon_text",
				content_check_function = function (arg_4_0)
					-- function 4
					return GameSettingsDevelopment.use_global_chat
				end,
				content_change_function = function (self, arg_5_1)
					-- function 5
					local selected_color

					if not self.info_hotspot.is_hover then
						selected_color = arg_5_1.selected_color

						if not selected_color then
							-- Nothing
						end
					end

					selected_color = arg_5_1.base_color

					::label_5_0::

					arg_5_1.text_color = selected_color
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
					-- function 6
					return GameSettingsDevelopment.use_global_chat
				end,
				content_change_function = function (self, arg_7_1)
					-- function 7
					local selected_color

					if not self.enlarge_hotspot.is_hover then
						selected_color = arg_7_1.selected_color

						if not selected_color then
							-- Nothing
						end
					end

					selected_color = arg_7_1.base_color

					::label_7_0::

					arg_7_1.color = selected_color
				end
			},
			{
				style_id = "enlarge_icon",
				pass_type = "rect",
				content_check_function = function (arg_8_0)
					-- function 8
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
					-- function 9
					return GameSettingsDevelopment.use_global_chat
				end,
				content_change_function = function (self, arg_10_1)
					-- function 10
					local selected_color

					if not self.filter_hotspot.is_hover then
						selected_color = arg_10_1.selected_color

						if not selected_color then
							-- Nothing
						end
					end

					selected_color = arg_10_1.base_color

					::label_10_0::

					arg_10_1.color = selected_color
				end
			},
			{
				style_id = "filter_icon",
				pass_type = "triangle",
				content_check_function = function (arg_11_0)
					-- function 11
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
					-- function 12
					return GameSettingsDevelopment.use_global_chat
				end,
				content_change_function = function (self, arg_13_1)
					-- function 13
					local selected_color

					if not self.target_hotspot.is_hover then
						selected_color = arg_13_1.selected_color

						if not selected_color then
							-- Nothing
						end
					end

					selected_color = arg_13_1.base_color

					::label_13_0::

					arg_13_1.color = selected_color
				end
			},
			{
				style_id = "target_icon",
				pass_type = "triangle",
				content_check_function = function (arg_14_0)
					-- function 14
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
					-- function 15
					return GameSettingsDevelopment.use_global_chat
				end
			},
			{
				style_id = "background_header_front",
				pass_type = "rect",
				content_check_function = function (arg_16_0, arg_16_1)
					-- function 16
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
					-- function 17
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
				num,
				24
			}
		},
		background_header_front = {
			scenegraph_id = "chat_window_frame_top",
			color = Colors.get_table("black"),
			size = {
				num - 2,
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
local tbl_4 = {
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
local tbl_5 = {
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
					-- function 18
					local get_local_position = UISceneGraph.get_local_position(arg_18_0, arg_18_1.scenegraph_id)
					local scroll_bar_height = arg_18_2.scroll_bar_height
					local num = scroll_bar_height / 2
					local scroll_offset_min = arg_18_2.scroll_offset_min
					local scroll_offset_max = arg_18_2.scroll_offset_max
					local min = math.min(scroll_offset_min + (scroll_offset_max - scroll_offset_min) * arg_18_2.internal_scroll_value, scroll_offset_max - scroll_bar_height)

					get_local_position[2] = min
					arg_18_2.scroll_value = (min - scroll_offset_min) / (scroll_offset_max - scroll_bar_height - scroll_offset_min)
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
					-- function 19
					local var_19_0 = UIInverseScaleVectorToResolution(arg_19_3:get("cursor"))
					local scenegraph_id = arg_19_1.scenegraph_id
					local get_world_position = UISceneGraph.get_world_position(arg_19_0, scenegraph_id)
					local num = arg_19_2.scroll_bar_height / 2
					local var_19_4 = num
					local num_2 = var_19_0[2] - var_19_4
					local get_size = UISceneGraph.get_size(arg_19_0, scenegraph_id)
					local num_3 = num_2 - get_world_position[2]
					local num_4 = get_world_position[2] + num
					local scroll_offset_max = arg_19_2.scroll_offset_max
					local num_5 = get_world_position[2] + scroll_offset_max - num - arg_19_2.scroll_offset_min
					local clamp = math.clamp(num_3, 0, get_size[2])

					arg_19_2.internal_scroll_value = math.min(clamp / get_size[2], 1)
				end
			}
		}
	},
	content = {
		scroll_bar_height = 65,
		scroll_offset_min = 2,
		internal_scroll_value = 0,
		scroll_value = 0,
		scroll_offset_max = num_2 - 14
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

local function fn(arg_20_0, arg_20_1)
	-- function 20
	local menu_frame_12 = UIFrameSettings.menu_frame_12
	local tbl = {
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
				content_check_function = function (self)
					-- function 21
					return not self.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "icon_hover",
				texture_id = "icon",
				content_check_function = function (self)
					-- function 22
					return self.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "hover",
				texture_id = "hover",
				content_check_function = function (self)
					-- function 23
					return self.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "button_notification",
				texture_id = "button_notification"
			}
		}
	}
	local tbl_2 = {
		button_notification = "chat_icon_glow",
		hover = "button_state_default_2",
		icon = "chat_icon_01",
		button_hotspot = {},
		frame = menu_frame_12.texture
	}
	local tbl_3 = {
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
			texture_size = menu_frame_12.texture_size,
			texture_sizes = menu_frame_12.texture_sizes,
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
		element = tbl,
		content = tbl_2,
		style = tbl_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_20_0
	}
end

function create_additional_chat_tooltip(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7, arg_24_8)
	-- function 24
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
					content_check_function = function (self)
						-- function 25
						local tooltip = self.tooltip

						if not tooltip then
							tooltip = self.button_hotspot.is_hover
							tooltip = not tooltip and GameSettingsDevelopment.use_global_chat
						end

						return tooltip
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

local tbl_6 = {
	chat_target_tooltip = create_additional_chat_tooltip("chat_window_frame_top_target", tbl.chat_window_frame_top_filter.size, nil, {
		title = Localize("chat_menu_tooltip_target_title"),
		description = Localize("menu_chat_tooltip_target_description")
	}, nil, nil, "top", nil),
	chat_filter_tooltip = create_additional_chat_tooltip("chat_window_frame_top_filter", tbl.chat_window_frame_top_filter.size, nil, {
		title = Localize("chat_menu_tooltip_filter_title"),
		description = Localize("menu_chat_tooltip_filter_description")
	}, nil, nil, "top", nil),
	chat_enlarge_tooltip = create_additional_chat_tooltip("chat_window_frame_top_enlarge", tbl.chat_window_frame_top_enlarge.size, nil, {
		title = Localize("chat_menu_tooltip_enlarge_title"),
		description = Localize("menu_chat_tooltip_enlarge_description")
	}, nil, nil, "top", nil),
	chat_info_tooltip = create_additional_chat_tooltip("chat_window_frame_top_info", tbl.chat_window_frame_top_info.size, nil, {
		title = Localize("chat_menu_tooltip_info_title"),
		description = Localize("menu_chat_tooltip_info_description")
	}, nil, nil, "top", nil)
}

return {
	CHAT_WIDTH = num,
	CHAT_HEIGHT = num_2,
	CHAT_INPUT_TEXT_WIDTH = num_3,
	scenegraph_definition = tbl,
	chat_window_widget = tbl_2,
	chat_output_widget = tbl_4,
	chat_input_widget = tbl_3,
	chat_scrollbar_widget = tbl_5,
	chat_tab_widget = fn("chat_tab_root", tbl.chat_tab_root.size),
	widgets = tbl_6
}
