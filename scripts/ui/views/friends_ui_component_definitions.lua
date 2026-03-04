-- chunkname: @scripts/ui/views/friends_ui_component_definitions.lua

local var_0_0 = {
	400,
	550
}
local var_0_1 = {
	var_0_0[1],
	50
}
local var_0_2 = {
	var_0_1[1] - 6,
	0
}
local var_0_3 = {
	var_0_0[1],
	50
}
local var_0_4 = {
	var_0_0[1],
	var_0_0[2] - var_0_1[2] - var_0_3[2] * 1
}
local var_0_5 = {
	ui_size = var_0_0,
	tabs_size = var_0_3,
	tabs_active_size = var_0_4
}
local var_0_6 = 400

if IS_XB1 then
	var_0_6 = 1000
elseif IS_PS4 then
	var_0_6 = 2000
end

local var_0_7 = {
	var_0_0[1],
	40
}
local var_0_8 = {
	friend_list_limit = var_0_6,
	friends_entry_size = var_0_7
}
local var_0_9 = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.chat
		}
	},
	friends_button_root = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			60,
			60
		},
		position = {
			90,
			20,
			1
		}
	},
	main_background = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = var_0_0,
		position = {
			20,
			100,
			1
		}
	},
	top_info_box = {
		vertical_alignment = "top",
		parent = "main_background",
		horizontal_alignment = "center",
		size = var_0_1,
		position = {
			0,
			0,
			1
		}
	},
	top_info_box_divider = {
		vertical_alignment = "bottom",
		parent = "top_info_box",
		horizontal_alignment = "center",
		size = var_0_2,
		position = {
			0,
			0,
			5
		}
	},
	exit_button = {
		vertical_alignment = "center",
		parent = "top_info_box",
		horizontal_alignment = "right",
		size = {
			32,
			32
		},
		position = {
			-10,
			0,
			1
		}
	},
	refresh_button = {
		vertical_alignment = "center",
		parent = "exit_button",
		horizontal_alignment = "left",
		size = {
			32,
			32
		},
		position = {
			-29,
			0,
			1
		}
	},
	online_tab = {
		vertical_alignment = "bottom",
		parent = "top_info_box",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			var_0_3[2]
		},
		position = {
			0,
			-var_0_3[2],
			0
		}
	},
	offline_tab = {
		vertical_alignment = "bottom",
		parent = "online_tab",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			var_0_3[2]
		},
		position = {
			0,
			-var_0_3[2],
			0
		}
	},
	online_tab_list = {
		vertical_alignment = "top",
		parent = "online_tab",
		horizontal_alignment = "center",
		size = {
			var_0_7[1],
			var_0_7[2] * var_0_6
		},
		position = {
			0,
			-var_0_3[2],
			1
		}
	},
	offline_tab_list = {
		vertical_alignment = "top",
		parent = "offline_tab",
		horizontal_alignment = "center",
		size = {
			var_0_7[1],
			var_0_7[2] * var_0_6
		},
		position = {
			0,
			-var_0_3[2],
			1
		}
	}
}

local function var_0_10(arg_1_0, arg_1_1)
	local var_1_0 = UIFrameSettings.menu_frame_12
	local var_1_1 = {
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
				content_check_function = function(arg_2_0)
					return not arg_2_0.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "icon_hover",
				texture_id = "icon",
				content_check_function = function(arg_3_0)
					return arg_3_0.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "hover",
				texture_id = "hover",
				content_check_function = function(arg_4_0)
					return arg_4_0.button_hotspot.is_hover
				end
			}
		}
	}
	local var_1_2 = {
		icon = "friends_icon_01",
		hover = "button_state_default_2",
		button_hotspot = {},
		frame = var_1_0.texture
	}
	local var_1_3 = {
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
				3
			}
		},
		icon_hover = {
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				0,
				3
			}
		},
		frame = {
			texture_size = var_1_0.texture_size,
			texture_sizes = var_1_0.texture_sizes,
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
		}
	}

	return {
		element = var_1_1,
		content = var_1_2,
		style = var_1_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local function var_0_11(arg_5_0, arg_5_1)
	return {
		element = {
			passes = {
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge_holder_right = "menu_frame_12_divider_right",
			edge_holder_left = "menu_frame_12_divider_left",
			bottom_edge = "menu_frame_12_divider"
		},
		style = {
			bottom_edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					6
				},
				size = {
					arg_5_1[1],
					5
				},
				texture_tiling_size = {
					arg_5_1[1] - 10,
					5
				}
			},
			edge_holder_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-6,
					10
				},
				size = {
					9,
					17
				}
			},
			edge_holder_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_5_1[1] - 9,
					-6,
					10
				},
				size = {
					9,
					17
				}
			}
		},
		scenegraph_id = arg_5_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_12(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = {
		arg_6_1[1] - 6,
		arg_6_1[2]
	}
	local var_6_1 = {
		passes = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				style_id = "text",
				pass_type = "text",
				text_id = "real_text",
				content_check_function = function(arg_7_0)
					return not arg_7_0.active and not arg_7_0.button_hotspot.is_hover
				end
			},
			{
				style_id = "text_hover",
				pass_type = "text",
				text_id = "real_text",
				content_check_function = function(arg_8_0)
					return arg_8_0.active or arg_8_0.button_hotspot.is_hover
				end
			},
			{
				pass_type = "rotated_texture",
				style_id = "drop_down_arrow",
				texture_id = "drop_down_arrow"
			},
			{
				style_id = "scrollbar",
				pass_type = "scrollbar_hotspot",
				content_id = "scrollbar",
				content_check_function = function(arg_9_0)
					return arg_9_0.active
				end
			},
			{
				style_id = "scrollbar",
				pass_type = "scrollbar",
				content_id = "scrollbar",
				content_check_function = function(arg_10_0)
					return arg_10_0.active
				end
			},
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_texture",
				content_check_function = function(arg_11_0)
					return arg_11_0.active
				end
			},
			{
				style_id = "list_style",
				pass_type = "list_pass",
				content_id = "list_content",
				content_check_function = function(arg_12_0)
					return arg_12_0.active
				end,
				passes = {
					{
						style_id = "name",
						pass_type = "text",
						text_id = "name"
					},
					{
						style_id = "invite_button",
						pass_type = "hotspot",
						content_id = "invite_button",
						content_check_function = function(arg_13_0)
							return arg_13_0.allow_invite
						end
					},
					{
						texture_id = "invite_button_texture",
						style_id = "invite_button",
						pass_type = "texture",
						content_id = "invite_button",
						content_check_function = function(arg_14_0)
							return arg_14_0.allow_invite and not arg_14_0.is_hover
						end
					},
					{
						texture_id = "invite_button_texture",
						style_id = "invite_button_hover",
						pass_type = "texture",
						content_id = "invite_button",
						content_check_function = function(arg_15_0)
							return arg_15_0.allow_invite and arg_15_0.is_hover
						end
					},
					{
						style_id = "profile_button",
						pass_type = "hotspot",
						content_id = "profile_button",
						content_check_function = function(arg_16_0)
							return arg_16_0.allow_profile
						end
					},
					{
						texture_id = "profile_button_texture",
						style_id = "profile_button",
						pass_type = "texture",
						content_id = "profile_button",
						content_check_function = function(arg_17_0)
							return arg_17_0.allow_profile and not arg_17_0.is_hover
						end
					},
					{
						texture_id = "profile_button_texture",
						style_id = "profile_button_hover",
						pass_type = "texture",
						content_id = "profile_button",
						content_check_function = function(arg_18_0)
							return arg_18_0.allow_profile and arg_18_0.is_hover
						end
					},
					{
						style_id = "join_button",
						pass_type = "hotspot",
						content_id = "join_button",
						content_check_function = function(arg_19_0)
							return arg_19_0.allow_join
						end
					},
					{
						texture_id = "join_button_texture",
						style_id = "join_button",
						pass_type = "texture",
						content_id = "join_button",
						content_check_function = function(arg_20_0)
							return arg_20_0.allow_join and not arg_20_0.is_hover
						end
					},
					{
						texture_id = "join_button_texture",
						style_id = "join_button_hover",
						pass_type = "texture",
						content_id = "join_button",
						content_check_function = function(arg_21_0)
							return arg_21_0.allow_join and arg_21_0.is_hover
						end
					}
				}
			},
			{
				texture_id = "bottom_edge",
				style_id = "bottom_edge",
				pass_type = "tiled_texture"
			}
		}
	}
	local var_6_2 = {
		drop_down_arrow = "drop_down_menu_arrow",
		mask_texture = "mask_rect",
		edge_holder_left = "menu_frame_12_divider_left",
		edge_holder_right = "menu_frame_12_divider_right",
		bottom_edge = "menu_frame_12_divider",
		edge_tab = true,
		button_hotspot = {},
		text = arg_6_2,
		real_text = arg_6_2 .. " (0)",
		scrollbar = {
			scroll_amount = 0.1,
			percentage = 0.1,
			scroll_value = 1
		},
		list_content = {
			allow_multi_hover = true
		}
	}
	local var_6_3 = var_6_2.list_content

	for iter_6_0 = 1, var_0_6 do
		var_6_3[iter_6_0] = {
			name = "friends_view_unknown",
			button_hotspot = {},
			invite_button = {
				allow_invite = true,
				invite_button_texture = "friends_icon_invite"
			},
			profile_button = {
				profile_button_texture = "friends_icon_profile",
				allow_profile = true
			},
			join_button = {
				join_button_texture = "friends_icon_join",
				allow_join = true
			}
		}
	end

	local var_6_4 = {
		hotspot = {
			size = {
				arg_6_1[1],
				arg_6_1[2]
			},
			offset = {
				0,
				0,
				0
			}
		},
		text = {
			word_wrap = true,
			font_size = 22,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			normal_color = Colors.get_color_table_with_alpha("font_default", 255),
			highlighted_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				13,
				-8,
				5
			}
		},
		text_hover = {
			word_wrap = true,
			font_size = 22,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			normal_color = Colors.get_color_table_with_alpha("font_default", 255),
			highlighted_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				13,
				-8,
				5
			}
		},
		drop_down_arrow = {
			vertical_alignment = "top",
			horizontal_alignment = "right",
			angle = 0,
			texture_size = {
				31,
				15
			},
			pivot = {
				15.5,
				7.5
			},
			offset = {
				-12,
				-14,
				1
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		scrollbar = {
			hotspot_width_modifier = 5,
			min_scrollbar_height = 30,
			size = {
				2,
				var_0_4[2] - var_0_3[2] - 10
			},
			offset = {
				var_0_4[1] - 15,
				10,
				100
			},
			background_color = Colors.get_color_table_with_alpha("very_dark_gray", 255),
			scrollbar_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			scroll_area_size = {
				var_0_0[1],
				var_0_4[2] - var_0_3[2]
			},
			scroll_area_offset = {
				-var_0_0[1] + 19,
				-10,
				0
			}
		},
		scrollbar_scroll_area = {},
		mask = {
			size = {
				arg_6_1[1],
				var_0_4[2] - var_0_3[2]
			},
			color = {
				150,
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
		list_style = {
			vertical_alignment = "top",
			num_draws = 0,
			start_index = 1,
			horizontal_alignment = "center",
			list_member_offset = {
				0,
				var_0_7[2],
				0
			},
			size = {
				var_0_7[1],
				var_0_7[2]
			},
			scenegraph_id = arg_6_3,
			item_styles = {}
		},
		bottom_edge = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				3,
				0,
				6
			},
			size = {
				var_6_0[1],
				5
			},
			texture_tiling_size = {
				var_6_0[1] - 10,
				5
			},
			content_check_function = function(arg_22_0)
				return not arg_22_0.edge_tab or not arg_22_0.active
			end
		}
	}
	local var_6_5 = var_6_4.list_style.item_styles

	for iter_6_1 = 1, var_0_6 do
		var_6_5[iter_6_1] = {
			list_member_offset = {
				0,
				-var_0_7[2],
				0
			},
			size = {
				var_0_7[1],
				var_0_7[2]
			},
			name = {
				word_wrap = true,
				font_size = 22,
				localize = false,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				normal_color = Colors.get_color_table_with_alpha("font_default", 255),
				highlighted_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					13,
					0,
					1
				}
			},
			join_button = {
				masked = true,
				size = {
					32,
					32
				},
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					var_0_3[1] - 112,
					3,
					1
				}
			},
			join_button_hover = {
				masked = true,
				size = {
					32,
					32
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_0_3[1] - 112,
					3,
					1
				}
			},
			invite_button = {
				masked = true,
				size = {
					32,
					32
				},
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					var_0_3[1] - 80,
					3,
					1
				}
			},
			invite_button_hover = {
				masked = true,
				size = {
					32,
					32
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_0_3[1] - 80,
					3,
					1
				}
			},
			profile_button = {
				masked = true,
				size = {
					32,
					32
				},
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					var_0_3[1] - 48,
					3,
					1
				}
			},
			profile_button_hover = {
				masked = true,
				size = {
					32,
					32
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_0_3[1] - 48,
					3,
					1
				}
			},
			rect = {
				size = {
					var_0_7[1],
					var_0_7[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					100
				}
			}
		}
	end

	return {
		element = var_6_1,
		content = var_6_2,
		style = var_6_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_6_0
	}
end

local function var_0_13(arg_23_0, arg_23_1)
	local var_23_0 = var_0_9[arg_23_0].size
	local var_23_1 = {
		passes = {
			{
				pass_type = "hotspot"
			},
			{
				pass_type = "texture",
				style_id = "button_texture",
				texture_id = "button_texture",
				content_check_function = function(arg_24_0)
					return not arg_24_0.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "button_texture_hover",
				texture_id = "button_texture",
				content_check_function = function(arg_25_0)
					return arg_25_0.is_hover
				end
			}
		}
	}
	local var_23_2 = {
		button_texture = arg_23_1
	}
	local var_23_3 = {
		size = {
			var_23_0[1],
			var_23_0[2]
		},
		color = {
			255,
			255,
			255,
			255
		},
		button_texture_hover = {
			size = {
				var_23_0[1],
				var_23_0[2]
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		button_texture = {
			size = {
				var_23_0[1],
				var_23_0[2]
			},
			color = Colors.get_color_table_with_alpha("font_button_normal", 255)
		}
	}

	return {
		element = var_23_1,
		content = var_23_2,
		style = var_23_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_23_0
	}
end

local function var_0_14(arg_26_0, arg_26_1)
	local var_26_0 = var_0_9[arg_26_0].size
	local var_26_1 = {
		passes = {
			{
				pass_type = "hotspot"
			},
			{
				pass_type = "rotated_texture",
				style_id = "button_texture",
				texture_id = "button_texture",
				content_check_function = function(arg_27_0)
					return not arg_27_0.is_hover
				end
			},
			{
				pass_type = "rotated_texture",
				style_id = "button_texture_hover",
				texture_id = "button_texture",
				content_check_function = function(arg_28_0)
					return arg_28_0.is_hover
				end
			}
		}
	}
	local var_26_2 = {
		button_texture = arg_26_1
	}
	local var_26_3 = {
		size = {
			var_26_0[1],
			var_26_0[2]
		},
		color = {
			255,
			255,
			255,
			255
		},
		button_texture_hover = {
			size = {
				var_26_0[1],
				var_26_0[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			angle = math.pi,
			pivot = {
				var_26_0[1] * 0.5,
				var_26_0[2] * 0.5
			},
			offset = {
				0,
				0,
				1
			}
		},
		button_texture = {
			angle = 0,
			size = {
				var_26_0[1],
				var_26_0[2]
			},
			color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			pivot = {
				var_26_0[1] * 0.5,
				var_26_0[2] * 0.5
			},
			offset = {
				0,
				0,
				1
			}
		}
	}

	return {
		element = var_26_1,
		content = var_26_2,
		style = var_26_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_26_0
	}
end

local function var_0_15(arg_29_0, arg_29_1)
	local var_29_0 = {}
	local var_29_1 = {
		allow_multi_hover = true
	}
	local var_29_2 = {}

	var_29_0[#var_29_0 + 1] = {
		pass_type = "hotspot",
		style_id = "hotspot"
	}
	var_29_2.hotspot = {
		allow_multi_hover = true,
		size = arg_29_1
	}

	local var_29_3 = {
		element = {}
	}

	var_29_3.element.passes = var_29_0
	var_29_3.content = var_29_1
	var_29_3.style = var_29_2
	var_29_3.offset = {
		0,
		0,
		0
	}
	var_29_3.scenegraph_id = arg_29_0

	return var_29_3
end

local var_0_16 = {
	vertical_alignment = "center",
	font_size = 22,
	localize = false,
	horizontal_alignment = "left",
	word_wrap = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		13,
		2,
		5
	}
}
local var_0_17 = {
	friends_button = var_0_10("friends_button_root", var_0_9.friends_button_root.size),
	main_background = UIWidgets.create_simple_rect("main_background", Colors.get_color_table_with_alpha("black", 220)),
	main_background_frame = UIWidgets.create_frame("main_background", var_0_9.main_background.size, "menu_frame_12", 20),
	top_info_box_text = UIWidgets.create_simple_text(Localize("friends_view"), "top_info_box", 22, nil, var_0_16),
	top_info_box_divider = var_0_11("top_info_box_divider", var_0_9.top_info_box_divider.size),
	exit_button = var_0_13("exit_button", "friends_icon_close"),
	refresh_button = var_0_14("refresh_button", "friends_icon_refresh"),
	online_tab = var_0_12("online_tab", var_0_9.online_tab.size, Localize("friends_view_online"), "online_tab_list"),
	offline_tab = var_0_12("offline_tab", var_0_9.offline_tab.size, Localize("friends_view_offline"), "offline_tab_list", true),
	hotspot_area = var_0_15("main_background", var_0_9.main_background.size)
}

return {
	scenegraph_definition = var_0_9,
	widget_definitions = var_0_17,
	scenegraph_info = var_0_5,
	list_info = var_0_8
}
