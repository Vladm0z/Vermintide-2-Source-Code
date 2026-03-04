-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_quickplay_definitions.lua

local var_0_0 = UISettings.game_start_windows.large_window_size
local var_0_1 = "menu_frame_11"
local var_0_2 = UIFrameSettings[var_0_1].texture_sizes.vertical[1]
local var_0_3 = {
	var_0_0[1] - var_0_2 * 2,
	var_0_0[2] - var_0_2 * 2
}
local var_0_4 = {
	var_0_3[1],
	194
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
	parent_window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = var_0_0,
		position = {
			0,
			0,
			1
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "parent_window",
		horizontal_alignment = "right",
		size = var_0_3,
		position = {
			-var_0_2,
			0,
			1
		}
	},
	difficulty_selected = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			150,
			150
		},
		position = {
			0,
			220,
			2
		}
	},
	difficulty_selected_effect = {
		vertical_alignment = "center",
		parent = "difficulty_selected",
		horizontal_alignment = "center",
		size = {
			300,
			300
		},
		position = {
			0,
			0,
			-1
		}
	},
	difficulty_title = {
		vertical_alignment = "bottom",
		parent = "difficulty_selected",
		horizontal_alignment = "center",
		size = {
			600,
			50
		},
		position = {
			0,
			-60,
			1
		}
	},
	difficulty_description = {
		vertical_alignment = "top",
		parent = "difficulty_title",
		horizontal_alignment = "center",
		size = {
			600,
			100
		},
		position = {
			0,
			-60,
			1
		}
	},
	difficulty_option = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			160,
			160
		},
		position = {
			0,
			-200,
			1
		}
	},
	play_button_console = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_4[1],
			var_0_4[2]
		},
		position = {
			0,
			-30,
			1
		}
	},
	play_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			400,
			72
		},
		position = {
			0,
			25,
			20
		}
	}
}
local var_0_6 = {
	word_wrap = true,
	upper_case = true,
	localize = true,
	use_shadow = true,
	font_size = 42,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_7 = {
	word_wrap = true,
	upper_case = false,
	localize = true,
	dynamic_font_size_word_wrap = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	font_size = not IS_WINDOWS and 28 or 20,
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}

function create_play_button(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0
	local var_1_1 = "green"

	if var_1_1 then
		var_1_0 = "button_" .. var_1_1
	else
		var_1_0 = "button_normal"
	end

	local var_1_2 = Colors.get_color_table_with_alpha(var_1_0, 255)
	local var_1_3 = "button_bg_01"
	local var_1_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_3)
	local var_1_5 = UIFrameSettings.menu_frame_08
	local var_1_6 = "button_detail_05_glow"
	local var_1_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_6).size

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "hover_hotspot"
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
					content_check_function = function (arg_2_0)
						local var_2_0 = arg_2_0.button_hotspot.is_clicked

						return not var_2_0 or var_2_0 == 0
					end
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (arg_3_0)
						return arg_3_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_right",
					style_id = "side_detail_right",
					pass_type = "texture",
					content_check_function = function (arg_4_0)
						return not arg_4_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_left",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_check_function = function (arg_5_0)
						return not arg_5_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_right",
					style_id = "side_detail_right_disabled",
					pass_type = "texture",
					content_check_function = function (arg_6_0)
						return arg_6_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_left",
					style_id = "side_detail_left_disabled",
					pass_type = "texture",
					content_check_function = function (arg_7_0)
						return arg_7_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_glow_right",
					pass_type = "texture_uv",
					content_id = "side_detail_glow",
					content_check_function = function (arg_8_0)
						return not arg_8_0.parent.button_hotspot.disable_button
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_glow_left",
					pass_type = "texture",
					content_id = "side_detail_glow",
					content_check_function = function (arg_9_0)
						return not arg_9_0.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_10_0)
						return not arg_10_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_11_0)
						return arg_11_0.button_hotspot.disable_button
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
					texture_id = "effect",
					style_id = "effect",
					pass_type = "texture",
					content_check_function = function (arg_12_0)
						return not arg_12_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (arg_13_0)
						local var_13_0 = arg_13_0.button_hotspot

						return not var_13_0.disable_button and (var_13_0.is_selected or var_13_0.is_hover)
					end
				},
				{
					additional_option_id = "cancel_matchmaking_tooltip",
					style_id = "cancel_matchmaking_tooltip",
					pass_type = "additional_option_tooltip",
					content_id = "hover_hotspot",
					content_check_function = function (arg_14_0)
						local var_14_0 = arg_14_0.parent.button_hotspot

						return arg_14_0.is_hover and var_14_0.disable_button
					end
				}
			}
		},
		content = {
			side_detail_right = "button_detail_05_right",
			effect = "play_button_passive_glow",
			hover_glow = "button_state_hover_green",
			side_detail_left = "button_detail_05_left",
			glow = "button_state_normal_green",
			glass_top = "button_glass_01",
			side_detail_glow = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = var_1_6
			},
			button_hotspot = {},
			hover_hotspot = {
				cancel_matchmaking_tooltip = arg_1_5
			},
			title_text = arg_1_2 or "n/a",
			frame = var_1_5.texture,
			disable_with_gamepad = arg_1_4,
			background = {
				uvs = {
					{
						0,
						1 - arg_1_1[2] / var_1_4.size[2]
					},
					{
						arg_1_1[1] / var_1_4.size[1],
						1
					}
				},
				texture_id = var_1_3
			}
		},
		style = {
			background = {
				color = var_1_2,
				offset = {
					0,
					0,
					0
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
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
					7
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
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
					7
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
				}
			},
			title_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_1_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					9
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_1_3 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					0,
					9
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_1_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					8
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
				}
			},
			frame = {
				texture_size = var_1_5.texture_size,
				texture_sizes = var_1_5.texture_sizes,
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
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
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
					var_1_5.texture_sizes.horizontal[2],
					1
				},
				size = {
					arg_1_1[1],
					math.min(60, arg_1_1[2] - var_1_5.texture_sizes.horizontal[2] * 2)
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
					arg_1_1[2] - var_1_5.texture_sizes.horizontal[2] - 4,
					6
				},
				size = {
					arg_1_1[1],
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
					var_1_5.texture_sizes.horizontal[2] - 1,
					3
				},
				size = {
					arg_1_1[1],
					math.min(60, arg_1_1[2] - var_1_5.texture_sizes.horizontal[2] * 2)
				}
			},
			effect = {
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
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
				}
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_1_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_1_1[1] - 88,
					arg_1_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_left_disabled = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					0,
					arg_1_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_right_disabled = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					arg_1_1[1] - 88,
					arg_1_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_glow_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_1_1[2] / 2 - var_1_7[2] / 2,
					10
				},
				size = {
					var_1_7[1],
					var_1_7[2]
				}
			},
			side_detail_glow_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_1_1[1] - var_1_7[1],
					arg_1_1[2] / 2 - var_1_7[2] / 2,
					10
				},
				size = {
					var_1_7[1],
					var_1_7[2]
				}
			},
			cancel_matchmaking_tooltip = {
				vertical_alignment = "top",
				max_width = 400,
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					0
				}
			}
		},
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_8(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = true
	local var_15_1 = "difficulty_option_1"
	local var_15_2 = 0.6
	local var_15_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_15_1)
	local var_15_4 = {
		math.floor(var_15_3.size[1] * var_15_2),
		math.floor(var_15_3.size[2] * var_15_2)
	}
	local var_15_5 = arg_15_4 or "button_bg_01"
	local var_15_6 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_15_5)
	local var_15_7 = "menu_frame_08"
	local var_15_8 = UIFrameSettings[var_15_7].texture_sizes.corner[1]
	local var_15_9 = "frame_outer_glow_01"
	local var_15_10 = UIFrameSettings[var_15_9].texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				},
				{
					texture_id = "glass_texture",
					style_id = "glass_texture",
					pass_type = "texture"
				},
				{
					texture_id = "background_glow",
					style_id = "background_glow",
					pass_type = "texture",
					content_check_function = function (arg_16_0)
						return not arg_16_0.button_hotspot.is_selected
					end
				},
				{
					texture_id = "background_glow",
					style_id = "select_edge",
					pass_type = "texture"
				},
				{
					texture_id = "select_texture",
					style_id = "select_texture",
					pass_type = "texture"
				},
				{
					texture_id = "dlc_locked_texture",
					style_id = "dlc_locked_texture",
					pass_type = "texture",
					content_check_function = function (arg_17_0)
						return arg_17_0.dlc_locked
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (arg_18_0)
						return not arg_18_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "icon",
					style_id = "icon_disabled",
					pass_type = "texture",
					content_check_function = function (arg_19_0)
						return arg_19_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_20_0)
						return not arg_20_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_21_0)
						return arg_21_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				}
			}
		},
		content = {
			background_glow = "weaves_select_level_glow",
			title_text = "n/a",
			select_texture = "weave_difficulty_select_effect",
			glass_texture = "weaves_select_level_gloss",
			dlc_locked_texture = "hero_icon_locked",
			background = "weaves_select_level_background",
			icon = var_15_1,
			button_hotspot = {},
			dlc_locked = arg_15_5
		},
		style = {
			background = {
				color = {
					30,
					138,
					0,
					187
				},
				offset = {
					0,
					0,
					0
				},
				size = arg_15_1
			},
			glass_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					150,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					2
				},
				texture_size = arg_15_1
			},
			select_edge = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					255,
					193,
					161,
					116
				},
				offset = {
					0,
					0,
					5
				},
				texture_size = arg_15_1
			},
			background_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					255,
					138,
					0,
					187
				},
				offset = {
					0,
					0,
					3
				},
				texture_size = arg_15_1
			},
			select_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					0,
					38,
					0
				},
				texture_size = {
					200,
					300
				}
			},
			dlc_locked_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = {
					204,
					255,
					255,
					255
				},
				texture_size = {
					60,
					70
				},
				offset = {
					-100,
					0,
					4
				}
			},
			title_text = {
				font_size = 22,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				dynamic_font_size = var_15_0,
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-30,
					6
				},
				size = {
					arg_15_1[1],
					arg_15_1[2]
				}
			},
			title_text_disabled = {
				font_size = 22,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				dynamic_font_size = var_15_0,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					-30,
					6
				},
				size = {
					arg_15_1[1],
					arg_15_1[2]
				}
			},
			title_text_shadow = {
				font_size = 22,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				dynamic_font_size = var_15_0,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-32,
					5
				},
				size = {
					arg_15_1[1],
					arg_15_1[2]
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Colors.get_color_table_with_alpha("white", 255),
				default_color = Colors.get_color_table_with_alpha("white", 255),
				select_color = Colors.get_color_table_with_alpha("white", 255),
				texture_size = var_15_4,
				offset = {
					0,
					0,
					1
				}
			},
			icon_disabled = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					255,
					40,
					40,
					40
				},
				default_color = {
					255,
					40,
					40,
					40
				},
				select_color = {
					255,
					40,
					40,
					40
				},
				texture_size = var_15_4,
				offset = {
					0,
					0,
					2
				}
			}
		},
		scenegraph_id = arg_15_0,
		offset = {
			0,
			0,
			0
		}
	}
end

function create_start_game_console_play_button(arg_22_0, arg_22_1)
	local var_22_0 = {}
	local var_22_1 = {}
	local var_22_2 = {}
	local var_22_3 = "text"
	local var_22_4 = var_22_3 .. "_shadow"

	var_22_0[#var_22_0 + 1] = {
		pass_type = "text",
		text_id = var_22_3,
		style_id = var_22_3,
		content_change_function = function (arg_23_0, arg_23_1)
			if arg_23_0.locked then
				arg_23_1.text_color = arg_23_1.disabled_color
			else
				arg_23_1.text_color = arg_23_1.normal_color
			end
		end
	}
	var_22_0[#var_22_0 + 1] = {
		pass_type = "text",
		text_id = var_22_3,
		style_id = var_22_4
	}
	var_22_1[var_22_3] = arg_22_1

	local var_22_5 = {
		0,
		6,
		1
	}
	local var_22_6 = {
		word_wrap = false,
		upper_case = true,
		localize = false,
		font_size = 48,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		disabled_color = Colors.get_color_table_with_alpha("dark_gray", 255),
		normal_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			var_22_5[1],
			var_22_5[2],
			var_22_5[3]
		}
	}
	local var_22_7 = table.clone(var_22_6)

	var_22_7.text_color = {
		255,
		0,
		0,
		0
	}
	var_22_7.offset = {
		var_22_5[1] + 2,
		var_22_5[2] - 2,
		var_22_5[3] - 1
	}
	var_22_2[var_22_3] = var_22_6
	var_22_2[var_22_4] = var_22_7

	local var_22_8 = "divider"

	var_22_0[#var_22_0 + 1] = {
		pass_type = "texture",
		texture_id = var_22_8,
		style_id = var_22_8
	}
	var_22_1[var_22_8] = "divider_01_top"
	var_22_2[var_22_8] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			264,
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
			-36,
			1
		}
	}

	local var_22_9 = "input_texture"

	var_22_0[#var_22_0 + 1] = {
		pass_type = "texture",
		texture_id = var_22_9,
		style_id = var_22_9,
		content_change_function = function (arg_24_0, arg_24_1)
			if arg_24_0.locked then
				arg_24_1.saturated = true
			else
				arg_24_1.saturated = false
			end
		end
	}
	var_22_1[var_22_9] = ""
	var_22_2[var_22_9] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			64,
			64
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			-34,
			2
		}
	}

	local var_22_10 = "glow"

	var_22_0[#var_22_0 + 1] = {
		pass_type = "texture",
		texture_id = var_22_10,
		style_id = var_22_10,
		content_check_function = function (arg_25_0)
			return not arg_25_0.locked
		end
	}
	var_22_1[var_22_10] = "play_glow_mask"
	var_22_2[var_22_10] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			256,
			126
		},
		color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			0,
			33,
			-1
		}
	}

	return {
		element = {
			passes = var_22_0
		},
		content = var_22_1,
		style = var_22_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_22_0
	}
end

local var_0_9 = true
local var_0_10 = {
	difficulty_title = UIWidgets.create_simple_text("n/a", "difficulty_title", nil, nil, var_0_6),
	difficulty_description = UIWidgets.create_simple_text("n/a", "difficulty_description", nil, nil, var_0_7),
	difficulty_selected = UIWidgets.create_simple_texture("icons_placeholder", "difficulty_selected"),
	difficulty_selected_effect = UIWidgets.create_simple_texture("weave_difficulty_highlight_effect", "difficulty_selected_effect", nil, nil, {
		255,
		138,
		0,
		187
	}),
	play_button = create_play_button("play_button", var_0_5.play_button.size, Localize("start_game_window_play"), 34, var_0_9, {
		title = Localize("start_game_weave_disabled_tooltip_title"),
		description = Localize("start_game_weave_disabled_tooltip_description")
	}, var_0_9),
	play_button_console = create_start_game_console_play_button("play_button_console", Localize("start_game_window_play"))
}
local var_0_11 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				arg_26_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				local var_27_0 = math.easeInCubic(arg_27_3)

				arg_27_4.render_settings.alpha_multiplier = var_27_0
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				arg_29_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				local var_30_0 = math.easeOutCubic(arg_30_3)

				arg_30_4.render_settings.alpha_multiplier = 1 - var_30_0
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_10,
	create_difficulty_button = var_0_8,
	scenegraph_definition = var_0_5,
	animation_definitions = var_0_11
}
