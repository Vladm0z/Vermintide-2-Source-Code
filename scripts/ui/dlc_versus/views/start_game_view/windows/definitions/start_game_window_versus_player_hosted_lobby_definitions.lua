-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_player_hosted_lobby_definitions.lua

local var_0_0 = 24
local var_0_1 = {
	520,
	194
}
local var_0_2 = {
	480,
	80
}
local var_0_3 = {
	480,
	100
}
local var_0_4 = {
	var_0_3[1],
	30 + 4 * var_0_3[2]
}
local var_0_5 = {
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
	console_cursor = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			-10
		},
		size = {
			1920,
			1080
		}
	},
	settings_container = {
		vertical_alignment = "top",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			600,
			250
		},
		position = {
			0,
			-600,
			1
		}
	},
	game_option_1 = {
		vertical_alignment = "top",
		parent = "settings_container",
		horizontal_alignment = "center",
		size = var_0_1,
		position = {
			0,
			var_0_1[2] + 200,
			1
		}
	},
	button_controls = {
		vertical_alignment = "bottom",
		parent = "settings_container",
		horizontal_alignment = "center",
		size = {
			490,
			140
		},
		position = {
			0,
			-230,
			1
		}
	},
	force_start_button = {
		vertical_alignment = "top",
		parent = "button_controls",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			60,
			25,
			1
		}
	},
	locked_reason = {
		vertical_alignment = "top",
		parent = "button_controls",
		horizontal_alignment = "left",
		size = {
			490,
			140
		},
		position = {
			0,
			40,
			1
		}
	},
	settings_button = {
		vertical_alignment = "top",
		parent = "button_controls",
		horizontal_alignment = "left",
		size = {
			490,
			70
		},
		position = {
			0,
			-170,
			1
		}
	},
	leave_game_button = {
		vertical_alignment = "bottom",
		parent = "team_1_panel",
		horizontal_alignment = "center",
		size = {
			390,
			70
		},
		position = {
			0,
			-625,
			1
		}
	},
	lobby_name = {
		vertical_alignment = "top",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			825,
			119
		},
		position = {
			0,
			-100,
			1
		}
	},
	team_1 = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "left",
		size = var_0_4,
		position = {
			100,
			0,
			10
		}
	},
	team_1_panel = {
		vertical_alignment = "top",
		parent = "team_1",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			0,
			90,
			3
		}
	},
	team_1_player_panel = {
		vertical_alignment = "top",
		parent = "team_1",
		horizontal_alignment = "left",
		size = var_0_3,
		position = {
			0,
			-150 * 0,
			10
		}
	},
	team_2 = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "right",
		size = var_0_4,
		position = {
			-100,
			0,
			10
		}
	},
	team_2_panel = {
		vertical_alignment = "top",
		parent = "team_2",
		horizontal_alignment = "right",
		size = var_0_2,
		position = {
			0,
			90,
			3
		}
	},
	team_2_player_panel = {
		vertical_alignment = "top",
		parent = "team_2",
		horizontal_alignment = "right",
		size = var_0_3,
		position = {
			0,
			-150 * 0,
			10
		}
	},
	toggle_settings_button = {
		vertical_alignment = "top",
		parent = "settings_container",
		horizontal_alignment = "left",
		size = {
			600,
			36
		},
		position = {
			0,
			200,
			1
		}
	}
}
local var_0_6 = {
	title = Localize("start_game_window_other_options_private"),
	description = Localize("start_game_window_other_options_private_description")
}

local function var_0_7(arg_1_0, arg_1_1, arg_1_2)
	return {
		scenegraph_id = arg_1_0,
		element = {
			passes = {
				{
					style_id = "team_name",
					pass_type = "text",
					text_id = "team_name"
				},
				{
					style_id = "team_name_shadow",
					pass_type = "text",
					text_id = "team_name"
				},
				{
					style_id = "player_count",
					pass_type = "text",
					text_id = "player_count"
				},
				{
					pass_type = "texture",
					style_id = "team_icon_bg",
					texture_id = "team_icon_bg"
				},
				{
					pass_type = "texture",
					style_id = "team_icon",
					texture_id = "team_icon"
				}
			}
		},
		content = {
			player_count = "n/a",
			team_name = Localize(arg_1_1.display_name),
			team_icon_bg = arg_1_1.background_texture,
			team_icon = arg_1_1.team_icon,
			styles_with_team_color = {
				"team_name",
				"team_icon",
				"team_icon_bg"
			}
		},
		style = {
			team_name = {
				use_shadow = true,
				upper_case = true,
				localize = false,
				vertical_alignment = "top",
				font_size = 48,
				font_type = "hell_shark_header",
				text_color = arg_1_2,
				offset = {
					90,
					0,
					1
				}
			},
			team_name_shadow = {
				use_shadow = true,
				upper_case = true,
				vertical_alignment = "top",
				font_size = 48,
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					91,
					-1,
					0
				}
			},
			player_count = {
				vertical_alignment = "top",
				use_shadow = true,
				font_size = 24,
				font_type = "hell_shark",
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					94,
					-48,
					1
				}
			},
			team_icon_bg = {
				vertical_alignment = "top",
				texture_size = {
					80,
					80
				},
				color = arg_1_2
			},
			team_icon = {
				vertical_alignment = "top",
				texture_size = {
					80,
					80
				},
				color = arg_1_2,
				offset = {
					0,
					0,
					1
				}
			}
		}
	}
end

local var_0_8
local var_0_9
local var_0_10 = {
	scenegraph_id = "settings_container",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "divider",
				texture_id = "divider"
			}
		}
	},
	content = {
		divider = "popup_divider"
	},
	style = {
		divider = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				379,
				8
			},
			offset = {
				0,
				0,
				0
			}
		}
	}
}
local var_0_11 = {
	font_size = 24,
	upper_case = true,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = {
		255,
		255,
		62,
		62
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_12 = true
local var_0_13 = {
	scenegraph_id = "lobby_name",
	element = {
		passes = {
			{
				style_id = "background",
				texture_id = "background",
				pass_type = "texture",
				content_change_function = function (arg_2_0, arg_2_1)
					arg_2_1.color[1] = arg_2_0.input.active and 255 or 127
				end
			},
			{
				pass_type = "texture",
				style_id = "top_detail_bar",
				texture_id = "detail_bar"
			},
			{
				pass_type = "texture",
				style_id = "bottom_detail_bar",
				texture_id = "detail_bar"
			},
			{
				pass_type = "texture",
				style_id = "top_center",
				texture_id = "top_center"
			},
			{
				pass_type = "texture",
				style_id = "top_detail",
				texture_id = "top_detail"
			},
			{
				pass_type = "texture",
				style_id = "top_detail_glow",
				texture_id = "top_detail_glow",
				content_check_function = function (arg_3_0, arg_3_1)
					return arg_3_0.input.active
				end
			},
			{
				pass_type = "texture",
				style_id = "bottom_center",
				texture_id = "bottom_center"
			},
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				input_text_id = "text",
				pass_type = "keystrokes",
				content_id = "input"
			},
			{
				style_id = "default_text",
				pass_type = "text",
				text_id = "default_text",
				content_id = "input",
				content_check_function = function (arg_4_0)
					return arg_4_0.text == ""
				end
			},
			{
				style_id = "input_text",
				pass_type = "text",
				text_id = "text",
				content_id = "input",
				content_change_function = function (arg_5_0, arg_5_1)
					local var_5_0 = 0

					if arg_5_0.active then
						var_5_0 = 127 + 128 * math.sin(5 * Managers.time:time("ui"))
					end

					arg_5_1.caret_color[1] = var_5_0
				end
			}
		}
	},
	content = {
		bottom_center = "mission_objective_02",
		detail_bar = "mission_objective_05",
		top_center = "mission_objective_04",
		background = "mission_objective_bg",
		top_detail_glow = "mission_objective_glow_02",
		default_text = "Test 1",
		top_detail = "mission_objective_01",
		hotspot = {},
		input = {
			text = "",
			caret_index = 1,
			max_length = 32,
			text_index = 1,
			input_mode = "insert"
		}
	},
	style = {
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				-1
			},
			texture_size = {
				825,
				90
			}
		},
		top_center = {
			masked = false,
			texture_size = {
				54,
				22
			},
			offset = {
				385.5,
				90,
				5
			},
			color = Colors.get_color_table_with_alpha("white", 255)
		},
		top_detail = {
			masked = false,
			texture_size = {
				54,
				22
			},
			offset = {
				385.5,
				90,
				6
			},
			color = Colors.get_color_table_with_alpha("white", 255)
		},
		top_detail_glow = {
			masked = false,
			texture_size = {
				54,
				22
			},
			offset = {
				385.5,
				90,
				7
			},
			color = Colors.get_color_table_with_alpha("white", 255)
		},
		bottom_center = {
			masked = false,
			texture_size = {
				54,
				22
			},
			offset = {
				385.5,
				10,
				5
			},
			color = Colors.get_color_table_with_alpha("white", 255)
		},
		top_detail_bar = {
			masked = false,
			texture_size = {
				544,
				5
			},
			offset = {
				140.5,
				100,
				2
			},
			color = Colors.get_color_table_with_alpha("white", 255)
		},
		bottom_detail_bar = {
			masked = false,
			texture_size = {
				544,
				5
			},
			offset = {
				140.5,
				14,
				2
			},
			color = Colors.get_color_table_with_alpha("white", 255)
		},
		default_text = {
			word_wrap = true,
			font_size = 46,
			horizontal_scroll = true,
			pixel_perfect = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = false,
			font_type = "hell_shark_arial",
			text_color = Colors.get_color_table_with_alpha("dim_gray", 255),
			offset = {
				0,
				0,
				0
			},
			area_size = {
				825,
				90
			}
		},
		input_text = {
			word_wrap = true,
			font_size = 46,
			horizontal_scroll = true,
			pixel_perfect = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font = false,
			font_type = "hell_shark_arial",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				0,
				0,
				1
			},
			area_size = {
				825,
				90
			},
			caret_size = {
				2,
				46
			},
			caret_offset = {
				0,
				-8,
				4
			},
			caret_color = Colors.get_table("white")
		}
	}
}
local var_0_14 = {
	mission_setting = UIWidgets.create_start_game_console_setting_button("game_option_1", Localize("start_game_window_mission"), nil, nil, nil, var_0_5.game_option_1.size),
	team_1 = var_0_7("team_1_panel", UISettings.teams_ui_assets.team_hammers, Colors.get_color_table_with_alpha("local_player_team_lighter", 255)),
	team_2 = var_0_7("team_2_panel", UISettings.teams_ui_assets.team_skulls, Colors.get_color_table_with_alpha("opponent_team_lighter", 255)),
	toggle_custom_settings_button = UIWidgets.create_default_checkbox_button_console("toggle_settings_button", var_0_5.toggle_settings_button.size, Localize("start_game_window_toggle_custom_setting"), 24, var_0_6, "menu_frame_03_morris"),
	lobby_name = var_0_13,
	leave_game_button = UIWidgets.create_default_button("leave_game_button", var_0_5.leave_game_button.size, nil, nil, Localize("exit"), var_0_0, nil, nil, nil, var_0_12)
}
local var_0_15 = {
	force_start_button = UIWidgets.create_icon_and_name_button("force_start_button", "options_button_icon_quickplay", Localize("input_description_play")),
	locked_reason = UIWidgets.create_simple_text("tutorial_no_text", "locked_reason", nil, nil, var_0_11)
}

local function var_0_16(arg_6_0)
	return arg_6_0.empty
end

local function var_0_17(arg_7_0)
	return not arg_7_0.empty
end

local function var_0_18(arg_8_0, arg_8_1)
	local var_8_0 = "team_" .. arg_8_0 .. "_player_panel"
	local var_8_1 = var_0_5[var_8_0].size
	local var_8_2 = UIFrameSettings.button_frame_02
	local var_8_3 = UIFrameSettings.shadow_frame_02
	local var_8_4 = UIFrameSettings.frame_outer_glow_04
	local var_8_5 = UIFrameSettings.frame_outer_glow_01
	local var_8_6 = UIFrameSettings.frame_bevel_01
	local var_8_7 = arg_8_0 == 1 and Colors.get_color_table_with_alpha("local_player_team_lighter", 255) or Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
	local var_8_8 = var_8_1[2] / 138
	local var_8_9 = {
		50 * var_8_8,
		138 * var_8_8
	}

	return {
		scenegraph_id = var_8_0,
		offset = {
			0,
			-120 * (arg_8_1 - 1),
			0
		},
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "empty_background",
					pass_type = "rect",
					content_check_function = var_0_16
				},
				{
					pass_type = "texture_frame",
					style_id = "empty_hover_frame",
					texture_id = "empty_hover_frame",
					content_check_function = function (arg_9_0)
						return arg_9_0.empty and arg_9_0.button_hotspot.is_hover or arg_9_0.is_gamepad_active and arg_9_0.empty and arg_9_0.is_selected
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "empty_frame",
					texture_id = "empty_frame",
					content_check_function = var_0_16
				},
				{
					style_id = "open_slot_text",
					pass_type = "text",
					text_id = "open_slot_text",
					content_check_function = var_0_16
				},
				{
					style_id = "open_slot_text_shadow",
					pass_type = "text",
					text_id = "open_slot_text",
					content_check_function = var_0_16
				},
				{
					style_id = "background",
					pass_type = "rect",
					content_check_function = var_0_17
				},
				{
					style_id = "hover_frame",
					texture_id = "hover_frame",
					pass_type = "texture_frame",
					content_check_function = function (arg_10_0)
						return not arg_10_0.empty and arg_10_0.button_hotspot.is_hover or arg_10_0.is_gamepad_active and not arg_10_0.empty and arg_10_0.is_selected
					end,
					content_change_function = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
						local var_11_0 = arg_11_0.focused

						arg_11_1.color[1] = var_11_0 and 150 + 105 * math.sin(Managers.time:time("ui") * 7.5) or 255
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame",
					content_check_function = var_0_17
				},
				{
					pass_type = "texture_frame",
					style_id = "shadow_frame",
					texture_id = "shadow_frame",
					content_check_function = var_0_17
				},
				{
					pass_type = "texture",
					style_id = "player_avatar",
					texture_id = "player_avatar",
					content_check_function = function (arg_12_0)
						return not arg_12_0.empty and arg_12_0.player_avatar
					end
				},
				{
					pass_type = "texture",
					style_id = "host_texture",
					texture_id = "host_texture",
					content_check_function = function (arg_13_0)
						return not arg_13_0.empty and arg_13_0.show_host
					end
				},
				{
					style_id = "player_name",
					pass_type = "text",
					text_id = "player_name",
					content_check_function = var_0_17
				},
				{
					style_id = "player_level",
					pass_type = "text",
					text_id = "player_level",
					content_check_function = var_0_17
				},
				{
					style_id = "insignia_main",
					pass_type = "texture_uv",
					content_id = "insignia_main",
					content_check_function = function (arg_14_0)
						return not arg_14_0.parent.empty
					end
				},
				{
					style_id = "insignia_addon",
					pass_type = "texture_uv",
					content_id = "insignia_addon",
					content_check_function = function (arg_15_0)
						return not arg_15_0.parent.empty and arg_15_0.uvs
					end
				},
				{
					style_id = "party_color",
					pass_type = "rect",
					content_check_function = var_0_17
				},
				{
					style_id = "kick_button_background",
					pass_type = "rect",
					content_check_function = function (arg_16_0, arg_16_1)
						return arg_16_0.show_kick_button
					end
				},
				{
					texture_id = "button_frame",
					style_id = "kick_button_frame",
					pass_type = "texture",
					content_check_function = function (arg_17_0, arg_17_1)
						return arg_17_0.show_kick_button
					end
				},
				{
					pass_type = "texture",
					style_id = "kick_button_hotspot",
					texture_id = "kick_button_texture",
					content_check_function = function (arg_18_0, arg_18_1)
						return arg_18_0.show_kick_button
					end
				},
				{
					style_id = "kick_button_hotspot",
					pass_type = "hotspot",
					content_id = "kick_button_hotspot",
					content_check_function = function (arg_19_0)
						return arg_19_0.parent.show_kick_button and not arg_19_0.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "kick_tooltip_text",
					content_check_function = function (arg_20_0)
						return arg_20_0.show_kick_button and arg_20_0.kick_button_hotspot.is_hover
					end
				},
				{
					pass_type = "rect",
					style_id = "chat_button_background",
					texture_id = "chat_button_texture",
					content_check_function = function (arg_21_0)
						return arg_21_0.show_chat_button
					end
				},
				{
					texture_id = "button_frame",
					style_id = "chat_button_frame",
					pass_type = "texture",
					content_check_function = function (arg_22_0)
						return arg_22_0.show_chat_button
					end
				},
				{
					pass_type = "texture",
					style_id = "chat_button_hotspot",
					texture_id = "chat_button_texture",
					content_check_function = function (arg_23_0)
						return arg_23_0.show_chat_button
					end
				},
				{
					pass_type = "texture",
					style_id = "chat_button_disabled",
					texture_id = "disabled_texture",
					content_check_function = function (arg_24_0)
						return arg_24_0.show_chat_button and arg_24_0.chat_button_hotspot.is_selected
					end
				},
				{
					style_id = "chat_button_hotspot",
					pass_type = "hotspot",
					content_id = "chat_button_hotspot",
					content_check_function = function (arg_25_0)
						return arg_25_0.parent.show_chat_button and not arg_25_0.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "chat_tooltip_text_mute",
					content_check_function = function (arg_26_0)
						return arg_26_0.show_chat_button and not arg_26_0.chat_button_hotspot.is_selected and arg_26_0.chat_button_hotspot.is_hover
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "chat_tooltip_text_unmute",
					content_check_function = function (arg_27_0)
						return arg_27_0.show_chat_button and arg_27_0.chat_button_hotspot.is_selected and arg_27_0.chat_button_hotspot.is_hover
					end
				},
				{
					style_id = "profile_button_background",
					pass_type = "rect",
					content_check_function = function (arg_28_0)
						return arg_28_0.show_profile_button
					end
				},
				{
					texture_id = "button_frame",
					style_id = "profile_button_frame",
					pass_type = "texture",
					content_check_function = function (arg_29_0)
						return arg_29_0.show_profile_button
					end
				},
				{
					pass_type = "texture",
					style_id = "profile_button_hotspot",
					texture_id = "profile_button_texture",
					content_check_function = function (arg_30_0)
						return arg_30_0.show_profile_button
					end
				},
				{
					style_id = "profile_button_hotspot",
					pass_type = "hotspot",
					content_id = "profile_button_hotspot",
					content_check_function = function (arg_31_0)
						return arg_31_0.parent.show_profile_button and not arg_31_0.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "profile_tooltip_text",
					content_check_function = function (arg_32_0)
						return arg_32_0.show_profile_button and arg_32_0.profile_button_hotspot.is_hover
					end
				}
			}
		},
		content = {
			show_profile_button = false,
			disabled_texture = "tab_menu_icon_03",
			show_chat_button = false,
			player_level = "*Level 0",
			profile_button_texture = "tab_menu_icon_05",
			host_texture = "host_icon",
			profile_tooltip_text = "input_description_show_profile",
			show_kick_button = false,
			chat_tooltip_text_unmute = "input_description_unmute_chat",
			kick_tooltip_text = "vs_player_hosted_lobby_kick",
			show_ping = false,
			voice_tooltip_text_unmute = "input_description_unmute_voice",
			player_name = "*Missing Name",
			voice_tooltip_text_mute = "input_description_mute_voice",
			chat_button_texture = "tab_menu_icon_02",
			voice_button_texture = "tab_menu_icon_01",
			button_frame = "reward_pop_up_item_frame",
			empty = true,
			chat_tooltip_text_mute = "input_description_mute_chat",
			is_local_player = false,
			kick_button_texture = "tab_menu_icon_04",
			button_hotspot = {
				allow_multi_hover = true
			},
			frame = var_8_2.texture,
			shadow_frame = var_8_3.texture,
			hover_frame = var_8_4.texture,
			empty_hover_frame = var_8_5.texture,
			empty_frame = var_8_6.texture,
			open_slot_text = Localize("vs_lobby_slot_available"),
			chat_button_hotspot = {},
			kick_button_hotspot = {},
			voice_button_hotspot = {},
			profile_button_hotspot = {},
			styles_with_team_color = {
				"player_name"
			},
			insignia_main = {
				texture_id = "insignias_main_small",
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
			},
			insignia_addon = {
				texture_id = "insignias_addon_small",
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
			empty_background = {
				color = {
					80,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				}
			},
			frame = {
				texture_size = var_8_2.texture_size,
				texture_sizes = var_8_2.texture_sizes,
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
			empty_frame = {
				texture_size = var_8_6.texture_size,
				texture_sizes = var_8_6.texture_sizes,
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
			shadow_frame = {
				frame_margins = {
					-14,
					-14
				},
				texture_size = var_8_3.texture_size,
				texture_sizes = var_8_3.texture_sizes,
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				}
			},
			hover_frame = {
				frame_margins = {
					-14,
					-14
				},
				texture_size = var_8_4.texture_size,
				texture_sizes = var_8_4.texture_sizes,
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
			empty_hover_frame = {
				frame_margins = {
					-14,
					-14
				},
				texture_size = var_8_5.texture_size,
				texture_sizes = var_8_5.texture_sizes,
				color = {
					255,
					100,
					100,
					100
				},
				offset = {
					0,
					0,
					2
				}
			},
			background = {
				color = {
					127,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				}
			},
			open_slot_text = {
				vertical_alignment = "center",
				upper_case = true,
				font_size = 24,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark_header",
				text_color = {
					255,
					60,
					60,
					60
				},
				offset = {
					0,
					0,
					2
				}
			},
			open_slot_text_shadow = {
				vertical_alignment = "center",
				upper_case = true,
				font_size = 24,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					2,
					-2,
					1
				}
			},
			player_avatar = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					var_8_1[2] - 6,
					var_8_1[2] - 6
				},
				offset = {
					20 + var_8_9[1],
					0,
					1
				}
			},
			host_texture = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				offset = {
					-15,
					-5,
					2
				},
				texture_size = {
					40,
					40
				}
			},
			player_name = {
				vertical_alignment = "top",
				font_type = "arial",
				font_size = 22,
				horizontal_alignment = "left",
				text_color = var_8_7,
				offset = {
					120 + var_8_9[1],
					-20,
					2
				}
			},
			player_level = {
				vertical_alignment = "top",
				font_type = "hell_shark",
				font_size = 22,
				horizontal_alignment = "left",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					120 + var_8_9[1],
					-50,
					2
				}
			},
			insignia_main = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = var_8_9,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					10,
					0,
					3
				}
			},
			insignia_addon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = var_8_9,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					10,
					0,
					2
				}
			},
			party_color = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				texture_size = {
					5,
					var_8_1[2] - 10
				},
				color = {
					255,
					255,
					0,
					255
				},
				offset = {
					-5,
					0,
					5
				}
			},
			tooltip_text = {
				vertical_alignment = "top",
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				font_size = 18,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					20
				}
			},
			profile_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-20 + 0 * -50,
					10,
					11
				}
			},
			profile_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-20 + 0 * -50,
					10,
					13
				}
			},
			profile_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-20 + 0 * -50,
					10,
					12
				}
			},
			voice_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-120,
					10,
					13
				}
			},
			voice_chat_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-120,
					10,
					16
				}
			},
			voice_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-120,
					10,
					14
				}
			},
			voice_button_disabled = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					0,
					0
				},
				offset = {
					-120,
					10,
					15
				}
			},
			chat_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-70,
					10,
					11
				}
			},
			chat_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-70,
					10,
					16
				}
			},
			chat_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-70,
					10,
					14
				}
			},
			chat_button_disabled = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					0,
					0
				},
				offset = {
					-70,
					10,
					15
				}
			},
			kick_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-120,
					10,
					13
				}
			},
			kick_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-120,
					10,
					16
				}
			},
			kick_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-120,
					10,
					14
				}
			},
			ping_texture = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					54,
					50
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-210,
					5,
					15
				}
			},
			ping_text = {
				horizontal_alignment = "right",
				font_size = 20,
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "arial",
				offset = {
					-255,
					13,
					3
				},
				text_color = Colors.get_table("font_default"),
				high_ping_color = Colors.get_table("crimson"),
				medium_ping_color = Colors.get_table("gold"),
				low_ping_color = Colors.get_table("lime_green")
			}
		}
	}
end

local var_0_19 = {
	on_enter = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				local var_33_0 = math.random() < 0.01

				arg_33_3.ease = var_33_0 and math.ease_out_elastic or math.easeOutCubic
				arg_33_3.offset = var_33_0 and 100 or 200

				local var_33_1 = arg_33_3.offset

				arg_33_0.team_1.position[1] = arg_33_1.team_1.position[1] - var_33_1
				arg_33_0.team_2.position[1] = arg_33_1.team_2.position[1] + var_33_1
			end,
			update = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
				local var_34_0 = (1 - arg_34_4.ease(arg_34_3)) * arg_34_4.offset

				arg_34_0.team_1.position[1] = arg_34_1.team_1.position[1] - var_34_0
				arg_34_0.team_2.position[1] = arg_34_1.team_2.position[1] + var_34_0
				arg_34_0.leave_game_button.position[1] = arg_34_1.leave_game_button.position[1] + var_34_0
			end,
			on_complete = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				return
			end
		}
	}
}

return {
	create_player_panel_widget = var_0_18,
	loading_spinner_definition = UIWidgets.create_loading_spinner("menu_root"),
	console_cursor_definition = UIWidgets.create_console_cursor("console_cursor"),
	animation_definitions = var_0_19,
	scenegraph_definition = var_0_5,
	widget_definitions = var_0_14,
	host_widget_definitions = var_0_15
}
