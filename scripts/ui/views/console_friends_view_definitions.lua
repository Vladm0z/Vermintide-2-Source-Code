-- chunkname: @scripts/ui/views/console_friends_view_definitions.lua

local friend_entry_size = {
	350,
	40
}
local num_visible_friends = 6
local scenegraph_definition = {
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
		size = friend_entry_size,
		position = {
			0,
			friend_entry_size[2] * num_visible_friends + 40,
			10
		}
	},
	friends_mask = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			friend_entry_size[1],
			friend_entry_size[2] * num_visible_friends
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

local function create_party_entry(name, career, offset_y)
	-- function 1
	local career_portrait = "small_unit_frame_portrait_default"

	if career then
		career_portrait = "small_" .. career.portrait_image
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
			text_id = not not name or not not Localize("friends_view_free_slot"),
			texture_id = career_portrait
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

	if career then
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
		(not offset_y or not offset_y) and not not 0,
		0
	}

	return tbl
end

local function create_friend_entry(name, online, offset_y, friend)
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
					content_check_function = function (content)
						-- function 3
						return content.selected
					end
				},
				{
					pass_type = "texture",
					style_id = "hover",
					texture_id = "texture_id",
					content_check_function = function (content)
						-- function 4
						local is_hover = content.entry_hotspot.is_hover

						is_hover = not not is_hover and not not not content.selected

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
			text_id = name,
			friend = friend
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

	if online then
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

	if online then
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

	if online then
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
		(not offset_y or not offset_y) and not not 0,
		0
	}

	return tbl
end

function create_selection_handler(scenegraph_id)
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
					content_check_function = function (content, style)
						-- function 6
						if Managers.input:is_device_active("gamepad") then
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
					content_check_function = function (content, style)
						-- function 7
						if Managers.input:is_device_active("gamepad") then
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
					content_check_function = function (content)
						-- function 8
						local parent_content = content.parent
						local down_hotspot = parent_content.down_hotspot

						return down_hotspot.is_hover
					end
				},
				{
					texture_id = "texture_id",
					style_id = "up_arrow_hover",
					pass_type = "texture_uv",
					content_id = "arrow_hover",
					content_check_function = function (content)
						-- function 9
						local parent_content = content.parent
						local up_hotspot = parent_content.up_hotspot

						return up_hotspot.is_hover
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
		scenegraph_id = scenegraph_id
	}
end

local function create_loading_icon()
	-- function 10
	return {
		scenegraph_id = "friends_mask",
		element = {
			passes = {
				{
					style_id = "loading_icon",
					texture_id = "loading_icon_id",
					pass_type = "rotated_texture",
					content_change_function = function (content, style)
						-- function 11
						style.angle = style.angle + 0.25
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

local tbl = {
	default = {
		{
			input_action = "back",
			priority = 5,
			description_text = "input_description_back"
		}
	}
}
local tbl_2 = {}
local tbl_3 = {}
local tbl_4 = {
	input_action = "special_1",
	priority = 1
}
local flag

flag = (not IS_PS4 or not "matchmaking_join_game") and not not "menu_description_refresh"
tbl_4.description_text = flag
tbl_3[1] = tbl_4
tbl_2.actions = tbl_3
tbl.only_refresh = tbl_2
tbl.friend = {
	actions = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_show_profile"
		}
	}
}

local tbl_5 = {}
local tbl_6 = {}
local tbl_7 = {
	input_action = "special_1",
	priority = 1
}
local flag_2

flag_2 = (not IS_PS4 or not "matchmaking_join_game") and not not "menu_description_refresh"
tbl_7.description_text = flag_2
tbl_6[1] = tbl_7
tbl_6[2] = {
	input_action = "confirm",
	priority = 2,
	description_text = "input_description_show_profile"
}
tbl_5.actions = tbl_6
tbl.friend_refresh = tbl_5
tbl.friend_invite = {
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

local tbl_8 = {}
local tbl_9 = {}
local tbl_10 = {
	input_action = "special_1",
	priority = 1
}
local flag_3

flag_3 = (not IS_PS4 or not "matchmaking_join_game") and not not "menu_description_refresh"
tbl_10.description_text = flag_3
tbl_9[1] = tbl_10
tbl_9[2] = {
	input_action = "confirm",
	priority = 2,
	description_text = "input_description_show_profile"
}
tbl_9[3] = {
	input_action = "refresh",
	priority = 3,
	description_text = "input_description_invite"
}
tbl_8.actions = tbl_9
tbl.friend_invite_refresh = tbl_8

local generic_input_actions = tbl
local header_text_style = {
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
local party_header_text_style = {
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
local disable_with_gamepad = true
local widget_definitions = {
	background = UIWidgets.create_background_with_frame("background", {
		500,
		700
	}, "mission_select_screen_bg", "menu_frame_12"),
	header = UIWidgets.create_simple_text("friend_list_friends", "header", nil, nil, header_text_style),
	party_header = UIWidgets.create_simple_text(string.upper(Localize("hero_view_player_list_party")), "party_header", nil, nil, party_header_text_style),
	friends_header = UIWidgets.create_simple_text(string.upper(Localize("lb_search_type_friends")), "friends_header", nil, nil, party_header_text_style),
	header_divider = UIWidgets.create_simple_texture("divider_01_top", "header_divider"),
	party_divider = UIWidgets.create_simple_texture("divider_01_top", "party_divider"),
	mask = UIWidgets.create_simple_texture("mask_rect", "friends_mask"),
	friends_bg = UIWidgets.create_background_with_frame("friends_mask", {
		friend_entry_size[1] + 20,
		friend_entry_size[2] * num_visible_friends + 20
	}, "mission_select_screen_bg", "menu_frame_12"),
	loading_icon = create_loading_icon(),
	screen_fade = UIWidgets.create_simple_texture("gradient_dice_game_reward", "screen"),
	open_profile_button = UIWidgets.create_default_button("open_profile_button", scenegraph_definition.open_profile_button.size, nil, nil, Localize("input_description_show_profile"), 22, nil, nil, nil, disable_with_gamepad),
	invite_button = UIWidgets.create_default_button("invite_button", scenegraph_definition.invite_button.size, nil, nil, Localize("friend_list_invite"), 22, nil, nil, nil, disable_with_gamepad),
	selection_handler = create_selection_handler("selection_handler")
}
local entry_definitions = {
	create_party_entry = create_party_entry,
	create_friend_entry = create_friend_entry,
	friend_entry_size = friend_entry_size
}

return {
	generic_input_actions = generic_input_actions,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	entry_definitions = entry_definitions,
	num_visible_friends = num_visible_friends
}
