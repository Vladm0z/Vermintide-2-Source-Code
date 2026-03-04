-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_adventure_mode_settings_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = UIFrameSettings[var_0_1].texture_sizes.vertical[1]
local var_0_4 = var_0_2[1] - var_0_3 * 2
local var_0_5 = {
	var_0_2[1] - 20,
	233
}
local var_0_6 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - var_5_0
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}
local var_0_7 = {
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
	window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = var_0_2,
		position = {
			0,
			0,
			1
		}
	},
	game_option_difficulty = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_5,
		position = {
			0,
			-16,
			4
		}
	},
	game_option_next_mission = {
		vertical_alignment = "bottom",
		parent = "game_option_difficulty",
		horizontal_alignment = "center",
		size = var_0_5,
		position = {
			0,
			-(var_0_5[2] + 16),
			4
		}
	},
	play_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_5[1],
			72
		},
		position = {
			0,
			18,
			20
		}
	},
	game_options_right_chain = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			16,
			var_0_2[2]
		},
		position = {
			195,
			0,
			3
		}
	},
	game_options_left_chain = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			16,
			var_0_2[2]
		},
		position = {
			-195,
			0,
			3
		}
	}
}

local function var_0_8(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	arg_7_4 = arg_7_4 or "level_icon_01"

	local var_7_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_7_4)
	local var_7_1 = var_7_0 and var_7_0.size or {
		200,
		200
	}
	local var_7_2 = {
		var_7_1[1],
		var_7_1[2]
	}

	arg_7_5 = arg_7_5 or "game_options_bg_02"

	local var_7_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_7_5)
	local var_7_4 = "menu_frame_08"
	local var_7_5 = UIFrameSettings[var_7_4]
	local var_7_6 = var_7_5.texture_sizes.corner[1]
	local var_7_7 = "frame_outer_glow_01"
	local var_7_8 = UIFrameSettings[var_7_7]
	local var_7_9 = var_7_8.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background",
					content_change_function = function (arg_8_0, arg_8_1)
						if arg_8_0.parent.button_hotspot.disable_button then
							arg_8_1.saturated = true
						else
							arg_8_1.saturated = false
						end
					end
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					texture_id = "glow_frame",
					style_id = "glow_frame",
					pass_type = "texture_frame",
					content_check_function = function (arg_9_0)
						return not arg_9_0.button_hotspot.disable_button and arg_9_0.option_text == ""
					end
				},
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "glass",
					style_id = "glass",
					pass_type = "texture"
				},
				{
					style_id = "button_clicked_rect",
					pass_type = "rect",
					content_check_function = function (arg_10_0)
						local var_10_0 = arg_10_0.button_hotspot.is_clicked

						return not var_10_0 or var_10_0 == 0
					end
				},
				{
					pass_type = "rect",
					style_id = "button_hover_rect"
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (arg_11_0)
						return arg_11_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "icon_frame",
					pass_type = "texture",
					texture_id = "icon_frame",
					content_check_function = function (arg_12_0, arg_12_1)
						return arg_12_0.icon
					end,
					content_change_function = function (arg_13_0, arg_13_1)
						if arg_13_0.button_hotspot.disable_button then
							arg_13_1.saturated = true
						else
							arg_13_1.saturated = false
						end
					end
				},
				{
					texture_id = "icon_glow",
					style_id = "icon_glow",
					pass_type = "texture",
					content_check_function = function (arg_14_0, arg_14_1)
						return arg_14_0.icon
					end
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture"
				},
				{
					style_id = "icon",
					pass_type = "texture",
					texture_id = "icon",
					content_check_function = function (arg_15_0, arg_15_1)
						return arg_15_0.icon
					end,
					content_change_function = function (arg_16_0, arg_16_1)
						if arg_16_0.button_hotspot.disable_button then
							arg_16_1.saturated = true
						else
							arg_16_1.saturated = false
						end
					end
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (arg_17_0)
						return not arg_17_0.button_hotspot.disable_button and not arg_17_0.icon
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (arg_18_0)
						return arg_18_0.button_hotspot.disable_button and not arg_18_0.icon
					end
				},
				{
					style_id = "button_text_shadow",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (arg_19_0)
						return not arg_19_0.button_hotspot.disable_button and not arg_19_0.icon
					end
				},
				{
					style_id = "option_text",
					pass_type = "text",
					text_id = "option_text",
					content_check_function = function (arg_20_0)
						return not arg_20_0.button_hotspot.disable_button and arg_20_0.icon
					end
				},
				{
					style_id = "option_text_shadow",
					pass_type = "text",
					text_id = "option_text",
					content_check_function = function (arg_21_0)
						return not arg_21_0.button_hotspot.disable_button and arg_21_0.icon
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_22_0)
						return not arg_22_0.button_hotspot.disable_button and arg_22_0.icon
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_23_0)
						return not arg_23_0.button_hotspot.disable_button and arg_23_0.icon
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_24_0)
						return arg_24_0.button_hotspot.disable_button and arg_24_0.icon
					end
				},
				{
					pass_type = "texture",
					style_id = "title_bg",
					texture_id = "title_bg",
					content_check_function = function (arg_25_0)
						return arg_25_0.icon
					end
				},
				{
					pass_type = "texture",
					style_id = "title_edge",
					texture_id = "title_edge",
					content_check_function = function (arg_26_0)
						return arg_26_0.icon
					end
				}
			}
		},
		content = {
			option_text = "",
			icon_frame = "map_frame_00",
			glass = "game_options_fg",
			title_edge = "game_option_divider",
			glow = "game_options_glow_01",
			title_bg = "playername_bg_02",
			icon_glow = "map_frame_glow",
			button_hotspot = {},
			frame = var_7_5.texture,
			glow_frame = var_7_8.texture,
			button_text = arg_7_3,
			title_text = arg_7_2 or "n/a",
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_7_1[2] / var_7_3.size[2], 1)
					},
					{
						math.min(arg_7_1[1] / var_7_3.size[1], 1),
						1
					}
				},
				texture_id = arg_7_5
			}
		},
		style = {
			frame = {
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
				},
				size = arg_7_1,
				texture_size = var_7_5.texture_size,
				texture_sizes = var_7_5.texture_sizes
			},
			glow_frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					-2
				},
				size = arg_7_1,
				texture_size = var_7_8.texture_size,
				texture_sizes = var_7_8.texture_sizes,
				frame_margins = {
					-(var_7_9 - 1),
					-(var_7_9 - 1)
				}
			},
			background = {
				saturated = true,
				texture_tiling_size = {
					400,
					150
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
					0
				}
			},
			glass = {
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
				size = arg_7_1
			},
			glow = {
				color = {
					0,
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
			icon = {
				vertical_alignment = "center",
				saturated = true,
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = var_7_2,
				offset = {
					arg_7_1[1] / 2 - 120,
					0,
					5
				}
			},
			icon_frame = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					180,
					180
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_7_1[1] / 2 - 120,
					0,
					6
				}
			},
			icon_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					318,
					318
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					arg_7_1[1] / 2 - 120,
					0,
					4
				}
			},
			title_bg = {
				size = {
					arg_7_1[1],
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_7_1[2] - 38 - var_7_6,
					2
				}
			},
			title_edge = {
				size = {
					arg_7_1[1],
					5
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_7_1[2] - 38 - var_7_6,
					4
				}
			},
			title_text = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_7_6 + 5,
					-var_7_6,
					10
				}
			},
			title_text_shadow = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_7_6 + 5 + 2,
					-(var_7_6 + 2),
					9
				}
			},
			title_text_disabled = {
				font_size = 32,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					var_7_6 + 5,
					-var_7_6,
					10
				}
			},
			option_text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_7_6 + 5,
					-55,
					10
				}
			},
			option_text_shadow = {
				font_size = 28,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_7_6 + 5 + 2,
					-57,
					9
				}
			},
			button_text = {
				font_size = 38,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				default_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_7_6,
					var_7_6,
					10
				},
				size = {
					arg_7_1[1] - var_7_6 * 2,
					arg_7_1[2] - var_7_6 * 2
				}
			},
			button_text_disabled = {
				font_size = 38,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					var_7_6,
					var_7_6,
					10
				},
				size = {
					arg_7_1[1] - var_7_6 * 2,
					arg_7_1[2] - var_7_6 * 2
				}
			},
			button_text_shadow = {
				font_size = 38,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_7_6 + 2,
					var_7_6 - 2,
					9
				},
				size = {
					arg_7_1[1] - var_7_6 * 2,
					arg_7_1[2] - var_7_6 * 2
				}
			},
			button_hover_rect = {
				color = {
					30,
					0,
					0,
					0
				},
				offset = {
					var_7_6,
					var_7_6,
					1
				},
				size = {
					arg_7_1[1] - var_7_6 * 2,
					arg_7_1[2] - var_7_6 * 2
				}
			},
			button_clicked_rect = {
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					var_7_6,
					var_7_6,
					15
				},
				size = {
					arg_7_1[1] - var_7_6 * 2,
					arg_7_1[2] - var_7_6 * 2
				}
			},
			button_disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					var_7_6,
					var_7_6,
					15
				},
				size = {
					arg_7_1[1] - var_7_6 * 2,
					arg_7_1[2] - var_7_6 * 2
				}
			}
		},
		scenegraph_id = arg_7_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_9 = {
	background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window"),
	window = UIWidgets.create_frame("window", var_0_2, var_0_1, 20),
	play_button = UIWidgets.create_play_button("play_button", var_0_7.play_button.size, Localize("start_game_window_play"), 34),
	game_option_difficulty = var_0_8("game_option_difficulty", var_0_7.game_option_difficulty.size, Localize("start_game_window_difficulty"), Localize("start_game_window_change_difficulty"), "difficulty_option_1", "game_options_bg_02"),
	game_option_next_mission = var_0_8("game_option_next_mission", var_0_7.game_option_next_mission.size, Localize("start_game_window_mission"), Localize("start_game_window_change_mission"), nil, "game_options_bg_01"),
	game_options_left_chain = UIWidgets.create_tiled_texture("game_options_left_chain", "chain_link_01", {
		16,
		19
	}),
	game_options_right_chain = UIWidgets.create_tiled_texture("game_options_right_chain", "chain_link_01", {
		16,
		19
	})
}

return {
	widgets = var_0_9,
	scenegraph_definition = var_0_7,
	animation_definitions = var_0_6
}
