-- chunkname: @scripts/ui/views/friends_ui_component_definitions.lua

local tbl = {
	400,
	550
}
local tbl_2 = {
	tbl[1],
	50
}
local tbl_3 = {
	tbl_2[1] - 6,
	0
}
local tbl_4 = {
	tbl[1],
	50
}
local tbl_5 = {
	tbl[1],
	tbl[2] - tbl_2[2] - tbl_4[2] * 1
}
local tbl_6 = {
	ui_size = tbl,
	tabs_size = tbl_4,
	tabs_active_size = tbl_5
}
local num = 400

if not IS_XB1 then
	num = 1000
elseif not IS_PS4 then
	num = 2000
end

local tbl_7 = {
	tbl[1],
	40
}
local tbl_8 = {
	friend_list_limit = num,
	friends_entry_size = tbl_7
}
local tbl_9 = {
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
		size = tbl,
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
		size = tbl_2,
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
		size = tbl_3,
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
			tbl_4[1],
			tbl_4[2]
		},
		position = {
			0,
			-tbl_4[2],
			0
		}
	},
	offline_tab = {
		vertical_alignment = "bottom",
		parent = "online_tab",
		horizontal_alignment = "center",
		size = {
			tbl_4[1],
			tbl_4[2]
		},
		position = {
			0,
			-tbl_4[2],
			0
		}
	},
	online_tab_list = {
		vertical_alignment = "top",
		parent = "online_tab",
		horizontal_alignment = "center",
		size = {
			tbl_7[1],
			tbl_7[2] * num
		},
		position = {
			0,
			-tbl_4[2],
			1
		}
	},
	offline_tab_list = {
		vertical_alignment = "top",
		parent = "offline_tab",
		horizontal_alignment = "center",
		size = {
			tbl_7[1],
			tbl_7[2] * num
		},
		position = {
			0,
			-tbl_4[2],
			1
		}
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
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
					-- function 2
					return not self.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "icon_hover",
				texture_id = "icon",
				content_check_function = function (self)
					-- function 3
					return self.button_hotspot.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "hover",
				texture_id = "hover",
				content_check_function = function (self)
					-- function 4
					return self.button_hotspot.is_hover
				end
			}
		}
	}
	local tbl_2 = {
		icon = "friends_icon_01",
		hover = "button_state_default_2",
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
		element = tbl,
		content = tbl_2,
		style = tbl_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local function fn_2(arg_5_0, arg_5_1)
	-- function 5
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

local function fn_3(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local tbl_2 = {
		arg_6_1[1] - 6,
		arg_6_1[2]
	}
	local tbl_3 = {
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
				content_check_function = function (self)
					-- function 7
					return not not self.active or not self.button_hotspot.is_hover
				end
			},
			{
				style_id = "text_hover",
				pass_type = "text",
				text_id = "real_text",
				content_check_function = function (self)
					-- function 8
					local active = self.active

					active = active or self.button_hotspot.is_hover

					return active
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
				content_check_function = function (self)
					-- function 9
					return self.active
				end
			},
			{
				style_id = "scrollbar",
				pass_type = "scrollbar",
				content_id = "scrollbar",
				content_check_function = function (self)
					-- function 10
					return self.active
				end
			},
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_texture",
				content_check_function = function (self)
					-- function 11
					return self.active
				end
			},
			{
				style_id = "list_style",
				pass_type = "list_pass",
				content_id = "list_content",
				content_check_function = function (self)
					-- function 12
					return self.active
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
						content_check_function = function (self)
							-- function 13
							return self.allow_invite
						end
					},
					{
						texture_id = "invite_button_texture",
						style_id = "invite_button",
						pass_type = "texture",
						content_id = "invite_button",
						content_check_function = function (self)
							-- function 14
							local allow_invite = self.allow_invite

							allow_invite = not allow_invite and not self.is_hover

							return allow_invite
						end
					},
					{
						texture_id = "invite_button_texture",
						style_id = "invite_button_hover",
						pass_type = "texture",
						content_id = "invite_button",
						content_check_function = function (self)
							-- function 15
							local allow_invite = self.allow_invite

							allow_invite = not allow_invite and self.is_hover

							return allow_invite
						end
					},
					{
						style_id = "profile_button",
						pass_type = "hotspot",
						content_id = "profile_button",
						content_check_function = function (self)
							-- function 16
							return self.allow_profile
						end
					},
					{
						texture_id = "profile_button_texture",
						style_id = "profile_button",
						pass_type = "texture",
						content_id = "profile_button",
						content_check_function = function (self)
							-- function 17
							local allow_profile = self.allow_profile

							allow_profile = not allow_profile and not self.is_hover

							return allow_profile
						end
					},
					{
						texture_id = "profile_button_texture",
						style_id = "profile_button_hover",
						pass_type = "texture",
						content_id = "profile_button",
						content_check_function = function (self)
							-- function 18
							local allow_profile = self.allow_profile

							allow_profile = not allow_profile and self.is_hover

							return allow_profile
						end
					},
					{
						style_id = "join_button",
						pass_type = "hotspot",
						content_id = "join_button",
						content_check_function = function (self)
							-- function 19
							return self.allow_join
						end
					},
					{
						texture_id = "join_button_texture",
						style_id = "join_button",
						pass_type = "texture",
						content_id = "join_button",
						content_check_function = function (self)
							-- function 20
							local allow_join = self.allow_join

							allow_join = not allow_join and not self.is_hover

							return allow_join
						end
					},
					{
						texture_id = "join_button_texture",
						style_id = "join_button_hover",
						pass_type = "texture",
						content_id = "join_button",
						content_check_function = function (self)
							-- function 21
							local allow_join = self.allow_join

							allow_join = not allow_join and self.is_hover

							return allow_join
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
	local tbl_6 = {
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
	local list_content = tbl_6.list_content

	for i = 1, num do
		list_content[i] = {
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

	local tbl_8 = {
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
				tbl_5[2] - tbl_4[2] - 10
			},
			offset = {
				tbl_5[1] - 15,
				10,
				100
			},
			background_color = Colors.get_color_table_with_alpha("very_dark_gray", 255),
			scrollbar_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			scroll_area_size = {
				tbl[1],
				tbl_5[2] - tbl_4[2]
			},
			scroll_area_offset = {
				-tbl[1] + 19,
				-10,
				0
			}
		},
		scrollbar_scroll_area = {},
		mask = {
			size = {
				arg_6_1[1],
				tbl_5[2] - tbl_4[2]
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
				tbl_7[2],
				0
			},
			size = {
				tbl_7[1],
				tbl_7[2]
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
				tbl_2[1],
				5
			},
			texture_tiling_size = {
				tbl_2[1] - 10,
				5
			},
			content_check_function = function (self)
				-- function 22
				return not self.edge_tab and not self.active
			end
		}
	}
	local item_styles = tbl_8.list_style.item_styles

	for j = 1, num do
		item_styles[j] = {
			list_member_offset = {
				0,
				-tbl_7[2],
				0
			},
			size = {
				tbl_7[1],
				tbl_7[2]
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
					tbl_4[1] - 112,
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
					tbl_4[1] - 112,
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
					tbl_4[1] - 80,
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
					tbl_4[1] - 80,
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
					tbl_4[1] - 48,
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
					tbl_4[1] - 48,
					3,
					1
				}
			},
			rect = {
				size = {
					tbl_7[1],
					tbl_7[2]
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
		element = tbl_3,
		content = tbl_6,
		style = tbl_8,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_6_0
	}
end

local function fn_4(arg_23_0, arg_23_1)
	-- function 23
	local size = tbl_9[arg_23_0].size
	local tbl = {
		passes = {
			{
				pass_type = "hotspot"
			},
			{
				pass_type = "texture",
				style_id = "button_texture",
				texture_id = "button_texture",
				content_check_function = function (self)
					-- function 24
					return not self.is_hover
				end
			},
			{
				pass_type = "texture",
				style_id = "button_texture_hover",
				texture_id = "button_texture",
				content_check_function = function (self)
					-- function 25
					return self.is_hover
				end
			}
		}
	}
	local tbl_2 = {
		button_texture = arg_23_1
	}
	local tbl_3 = {
		size = {
			size[1],
			size[2]
		},
		color = {
			255,
			255,
			255,
			255
		},
		button_texture_hover = {
			size = {
				size[1],
				size[2]
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
				size[1],
				size[2]
			},
			color = Colors.get_color_table_with_alpha("font_button_normal", 255)
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
		scenegraph_id = arg_23_0
	}
end

local function fn_5(arg_26_0, arg_26_1)
	-- function 26
	local size = tbl_9[arg_26_0].size
	local tbl = {
		passes = {
			{
				pass_type = "hotspot"
			},
			{
				pass_type = "rotated_texture",
				style_id = "button_texture",
				texture_id = "button_texture",
				content_check_function = function (self)
					-- function 27
					return not self.is_hover
				end
			},
			{
				pass_type = "rotated_texture",
				style_id = "button_texture_hover",
				texture_id = "button_texture",
				content_check_function = function (self)
					-- function 28
					return self.is_hover
				end
			}
		}
	}
	local tbl_2 = {
		button_texture = arg_26_1
	}
	local tbl_3 = {
		size = {
			size[1],
			size[2]
		},
		color = {
			255,
			255,
			255,
			255
		},
		button_texture_hover = {
			size = {
				size[1],
				size[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			angle = math.pi,
			pivot = {
				size[1] * 0.5,
				size[2] * 0.5
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
				size[1],
				size[2]
			},
			color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			pivot = {
				size[1] * 0.5,
				size[2] * 0.5
			},
			offset = {
				0,
				0,
				1
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
		scenegraph_id = arg_26_0
	}
end

local function fn_6(arg_29_0, arg_29_1)
	-- function 29
	local tbl = {}
	local tbl_2 = {
		allow_multi_hover = true
	}
	local tbl_3 = {}

	tbl[#tbl + 1] = {
		pass_type = "hotspot",
		style_id = "hotspot"
	}
	tbl_3.hotspot = {
		allow_multi_hover = true,
		size = arg_29_1
	}

	local tbl_4 = {
		element = {}
	}

	tbl_4.element.passes = tbl
	tbl_4.content = tbl_2
	tbl_4.style = tbl_3
	tbl_4.offset = {
		0,
		0,
		0
	}
	tbl_4.scenegraph_id = arg_29_0

	return tbl_4
end

local tbl_10 = {
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
local tbl_11 = {
	friends_button = fn("friends_button_root", tbl_9.friends_button_root.size),
	main_background = UIWidgets.create_simple_rect("main_background", Colors.get_color_table_with_alpha("black", 220)),
	main_background_frame = UIWidgets.create_frame("main_background", tbl_9.main_background.size, "menu_frame_12", 20),
	top_info_box_text = UIWidgets.create_simple_text(Localize("friends_view"), "top_info_box", 22, nil, tbl_10),
	top_info_box_divider = fn_2("top_info_box_divider", tbl_9.top_info_box_divider.size),
	exit_button = fn_4("exit_button", "friends_icon_close"),
	refresh_button = fn_5("refresh_button", "friends_icon_refresh"),
	online_tab = fn_3("online_tab", tbl_9.online_tab.size, Localize("friends_view_online"), "online_tab_list"),
	offline_tab = fn_3("offline_tab", tbl_9.offline_tab.size, Localize("friends_view_offline"), "offline_tab_list", true),
	hotspot_area = fn_6("main_background", tbl_9.main_background.size)
}

return {
	scenegraph_definition = tbl_9,
	widget_definitions = tbl_11,
	scenegraph_info = tbl_6,
	list_info = tbl_8
}
