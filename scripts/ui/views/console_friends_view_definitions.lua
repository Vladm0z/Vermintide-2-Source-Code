-- chunkname: @scripts/ui/views/console_friends_view_definitions.lua

local tbl = {
	350,
	40
}
local num = 6
local tbl_2 = {
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
	background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			500,
			700
		},
		position = {
			0,
			0,
			1
		}
	},
	header = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center"
	},
	party_header = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			75,
			210,
			2
		}
	},
	header_divider = {
		vertical_alignment = "top",
		parent = "header",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-80,
			1
		}
	},
	bottom_rect = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			65
		}
	},
	party_divider = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			0,
			1
		}
	},
	friends_header = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "left",
		size = {
			350,
			100
		},
		position = {
			75,
			-32,
			2
		}
	},
	friends_base = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			0,
			tbl[2] * num + 40,
			10
		}
	},
	friends_mask = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			tbl[2] * num
		},
		position = {
			0,
			40,
			4
		}
	},
	open_profile_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			250,
			70
		},
		position = {
			-125,
			120,
			10
		}
	},
	invite_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			250,
			70
		},
		position = {
			125,
			120,
			10
		}
	},
	selection_handler = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			500,
			500
		},
		position = {
			0,
			0,
			50
		}
	}
}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local str = "small_unit_frame_portrait_default"

	if not arg_1_1 then
		str = "small_" .. arg_1_1.portrait_image
	end

	local tbl = {
		scenegraph_id = "party_header",
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_id"
				},
				{
					pass_type = "texture",
					style_id = "texture",
					texture_id = "texture_id"
				}
			}
		},
		content = {
			text_id = arg_1_0 or Localize("friends_view_free_slot"),
			texture_id = str
		}
	}
	local tbl_2 = {}
	local tbl_3 = {
		vertical_alignment = "center",
		font_size = 24,
		localize = false,
		horizontal_alignment = "left",
		word_wrap = true,
		font_type = "hell_shark"
	}
	local get_color_table_with_alpha

	if not arg_1_1 then
		get_color_table_with_alpha = Colors.get_color_table_with_alpha("white", 255)

		if not get_color_table_with_alpha then
			-- Nothing
		end
	end

	get_color_table_with_alpha = {
		255,
		80,
		80,
		80
	}

	::label_1_0::

	tbl_3.text_color = get_color_table_with_alpha
	tbl_3.offset = {
		35,
		0,
		1
	}
	tbl_2.text = tbl_3
	tbl_2.texture = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			30,
			35
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			0,
			0
		}
	}
	tbl.style = tbl_2
	tbl.offset = {
		0,
		not arg_1_2 and arg_1_2 and 0,
		0
	}

	return tbl
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local tbl = {
		scenegraph_id = "friends_base",
		element = {
			passes = {
				{
					style_id = "hover",
					pass_type = "hotspot",
					content_id = "entry_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "indicator_texture",
					texture_id = "indicator_texture_id"
				},
				{
					pass_type = "texture",
					style_id = "invite_texture",
					texture_id = "invite_texture_id"
				},
				{
					pass_type = "texture",
					style_id = "selected_texture",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 3
						return self.selected
					end
				},
				{
					pass_type = "texture",
					style_id = "hover",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 4
						local is_hover = self.entry_hotspot.is_hover

						is_hover = not is_hover and not self.selected

						return is_hover
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_id"
				}
			}
		},
		content = {
			indicator_texture_id = "page_indicator",
			texture_id = "rect_masked",
			selected = false,
			invite_texture_id = "friends_icon_invite",
			entry_hotspot = {},
			text_id = arg_2_0,
			friend = arg_2_3
		}
	}
	local tbl_2 = {}
	local tbl_3 = {
		vertical_alignment = "center",
		font_size = 20,
		localize = false,
		horizontal_alignment = "left",
		word_wrap = true,
		font_type = "hell_shark_masked"
	}
	local get_color_table_with_alpha

	if not arg_2_1 then
		get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_title", 255)

		if not get_color_table_with_alpha then
			-- Nothing
		end
	end

	get_color_table_with_alpha = {
		255,
		80,
		80,
		80
	}

	::label_2_0::

	tbl_3.text_color = get_color_table_with_alpha
	tbl_3.offset = {
		35,
		0,
		2
	}
	tbl_2.text = tbl_3

	local tbl_4 = {}
	local tbl_5

	if not arg_2_1 then
		tbl_5 = {
			255,
			0,
			255,
			0
		}

		if not tbl_5 then
			-- Nothing
		end
	end

	tbl_5 = {
		255,
		255,
		0,
		0
	}

	::label_2_1::

	tbl_4.color = tbl_5
	tbl_4.offset = {
		0,
		0,
		0
	}
	tbl_2.texture = tbl_4
	tbl_2.selected_texture = {
		color = {
			200,
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
	tbl_2.hover = {
		color = {
			128,
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
	tbl_2.invite_texture = {
		vertical_alignment = "center",
		horizontal_alignment = "right",
		texture_size = {
			32,
			32
		},
		color = {
			0,
			255,
			255,
			255
		},
		offset = {
			40,
			0,
			10
		}
	}

	local tbl_6 = {
		vertical_alignment = "center",
		masked = true,
		horizontal_alignment = "left",
		texture_size = {
			20,
			20
		}
	}
	local tbl_7

	if not arg_2_1 then
		tbl_7 = {
			255,
			0,
			255,
			0
		}

		if not tbl_7 then
			-- Nothing
		end
	end

	tbl_7 = {
		255,
		255,
		0,
		0
	}

	::label_2_2::

	tbl_6.color = tbl_7
	tbl_6.offset = {
		10,
		0,
		2
	}
	tbl_2.indicator_texture = tbl_6
	tbl.style = tbl_2
	tbl.offset = {
		0,
		not arg_2_2 and arg_2_2 and 0,
		0
	}

	return tbl
end

function create_selection_handler(arg_5_0)
	-- function 5
	return {
		element = {
			passes = {
				{
					style_id = "down_arrow_background",
					pass_type = "hotspot",
					content_id = "down_hotspot"
				},
				{
					style_id = "up_arrow_background",
					pass_type = "hotspot",
					content_id = "up_hotspot"
				},
				{
					texture_id = "texture_id",
					style_id = "down_arrow",
					pass_type = "texture",
					content_id = "arrow",
					content_check_function = function (arg_6_0, arg_6_1)
						-- function 6
						if not Managers.input:is_device_active("gamepad") then
							return false
						end

						return true
					end
				},
				{
					texture_id = "texture_id",
					style_id = "up_arrow",
					pass_type = "texture_uv",
					content_id = "arrow",
					content_check_function = function (arg_7_0, arg_7_1)
						-- function 7
						if not Managers.input:is_device_active("gamepad") then
							return false
						end

						return true
					end
				},
				{
					texture_id = "texture_id",
					style_id = "down_arrow_hover",
					pass_type = "texture",
					content_id = "arrow_hover_down",
					content_check_function = function (self)
						-- function 8
						return self.parent.down_hotspot.is_hover
					end
				},
				{
					texture_id = "texture_id",
					style_id = "up_arrow_hover",
					pass_type = "texture_uv",
					content_id = "arrow_hover",
					content_check_function = function (self)
						-- function 9
						return self.parent.up_hotspot.is_hover
					end
				}
			}
		},
		content = {
			rect_masked = "rect_masked",
			up_hotspot = {},
			down_hotspot = {},
			arrow = {
				texture_id = "drop_down_menu_arrow",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			},
			arrow_hover = {
				texture_id = "drop_down_menu_arrow_clicked",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			},
			arrow_hover_down = {
				texture_id = "drop_down_menu_arrow_clicked",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			}
		},
		style = {
			up_arrow = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				masked = false,
				offset = {
					-25,
					150,
					2
				},
				texture_size = {
					31,
					15
				}
			},
			up_arrow_background = {
				offset = {
					430,
					142,
					2
				},
				size = {
					60,
					30
				},
				color = {
					200,
					20,
					20,
					20
				}
			},
			down_arrow = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				masked = false,
				offset = {
					-25,
					-50,
					3
				},
				texture_size = {
					31,
					15
				}
			},
			up_arrow_hover = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				offset = {
					-25,
					130,
					0
				},
				texture_size = {
					31,
					28
				}
			},
			down_arrow_hover = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				offset = {
					-25,
					-43,
					2
				},
				texture_size = {
					31,
					28
				}
			},
			down_arrow_background = {
				offset = {
					430,
					-55,
					2
				},
				size = {
					60,
					30
				},
				color = {
					200,
					20,
					20,
					20
				}
			}
		},
		scenegraph_id = arg_5_0
	}
end

local function fn_3()
	-- function 10
	return {
		scenegraph_id = "friends_mask",
		element = {
			passes = {
				{
					style_id = "loading_icon",
					texture_id = "loading_icon_id",
					pass_type = "rotated_texture",
					content_change_function = function (arg_11_0, arg_11_1)
						-- function 11
						arg_11_1.angle = arg_11_1.angle + 0.25
					end
				}
			}
		},
		content = {
			loading_icon_id = "friends_icon_refresh"
		},
		style = {
			loading_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = 0,
				pivot = {
					16,
					16
				},
				texture_size = {
					32,
					32
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
end

local tbl_3 = {
	default = {
		{
			input_action = "back",
			priority = 5,
			description_text = "input_description_back"
		}
	}
}
local tbl_4 = {}
local tbl_5 = {}
local tbl_6 = {
	input_action = "special_1",
	priority = 1
}
local flag

flag = not IS_PS4 and "matchmaking_join_game" and "menu_description_refresh"
tbl_6.description_text = flag
tbl_5[1] = tbl_6
tbl_4.actions = tbl_5
tbl_3.only_refresh = tbl_4
tbl_3.friend = {
	actions = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_show_profile"
		}
	}
}

local tbl_7 = {}
local tbl_8 = {}
local tbl_9 = {
	input_action = "special_1",
	priority = 1
}
local flag_2

flag_2 = not IS_PS4 and "matchmaking_join_game" and "menu_description_refresh"
tbl_9.description_text = flag_2
tbl_8[1] = tbl_9
tbl_8[2] = {
	input_action = "confirm",
	priority = 2,
	description_text = "input_description_show_profile"
}
tbl_7.actions = tbl_8
tbl_3.friend_refresh = tbl_7
tbl_3.friend_invite = {
	actions = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_show_profile"
		},
		{
			input_action = "refresh",
			priority = 3,
			description_text = "input_description_invite"
		}
	}
}

local tbl_10 = {}
local tbl_11 = {}
local tbl_12 = {
	input_action = "special_1",
	priority = 1
}
local flag_3

flag_3 = not IS_PS4 and "matchmaking_join_game" and "menu_description_refresh"
tbl_12.description_text = flag_3
tbl_11[1] = tbl_12
tbl_11[2] = {
	input_action = "confirm",
	priority = 2,
	description_text = "input_description_show_profile"
}
tbl_11[3] = {
	input_action = "refresh",
	priority = 3,
	description_text = "input_description_invite"
}
tbl_10.actions = tbl_11
tbl_3.friend_invite_refresh = tbl_10

local tbl_13 = {
	vertical_alignment = "top",
	font_size = 56,
	localize = true,
	horizontal_alignment = "center",
	word_wrap = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		-20,
		2
	}
}
local tbl_14 = {
	vertical_alignment = "center",
	font_size = 36,
	localize = false,
	horizontal_alignment = "left",
	word_wrap = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		0
	}
}
local flag_4 = true
local tbl_15 = {
	background = UIWidgets.create_background_with_frame("background", {
		500,
		700
	}, "mission_select_screen_bg", "menu_frame_12"),
	header = UIWidgets.create_simple_text("friend_list_friends", "header", nil, nil, tbl_13),
	party_header = UIWidgets.create_simple_text(string.upper(Localize("hero_view_player_list_party")), "party_header", nil, nil, tbl_14),
	friends_header = UIWidgets.create_simple_text(string.upper(Localize("lb_search_type_friends")), "friends_header", nil, nil, tbl_14),
	header_divider = UIWidgets.create_simple_texture("divider_01_top", "header_divider"),
	party_divider = UIWidgets.create_simple_texture("divider_01_top", "party_divider"),
	mask = UIWidgets.create_simple_texture("mask_rect", "friends_mask"),
	friends_bg = UIWidgets.create_background_with_frame("friends_mask", {
		tbl[1] + 20,
		tbl[2] * num + 20
	}, "mission_select_screen_bg", "menu_frame_12"),
	loading_icon = fn_3(),
	screen_fade = UIWidgets.create_simple_texture("gradient_dice_game_reward", "screen"),
	open_profile_button = UIWidgets.create_default_button("open_profile_button", tbl_2.open_profile_button.size, nil, nil, Localize("input_description_show_profile"), 22, nil, nil, nil, flag_4),
	invite_button = UIWidgets.create_default_button("invite_button", tbl_2.invite_button.size, nil, nil, Localize("friend_list_invite"), 22, nil, nil, nil, flag_4),
	selection_handler = create_selection_handler("selection_handler")
}
local tbl_16 = {
	create_party_entry = fn,
	create_friend_entry = fn_2,
	friend_entry_size = tbl
}

return {
	generic_input_actions = tbl_3,
	widget_definitions = tbl_15,
	scenegraph_definition = tbl_2,
	entry_definitions = tbl_16,
	num_visible_friends = num
}
