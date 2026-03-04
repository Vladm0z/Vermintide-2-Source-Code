-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_settings_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = {
	var_0_2[1] - 20,
	233
}
local var_0_4 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - var_5_0
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
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
	game_option_1 = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_3,
		position = {
			0,
			-16,
			2
		}
	},
	game_option_2 = {
		vertical_alignment = "bottom",
		parent = "game_option_1",
		horizontal_alignment = "center",
		size = var_0_3,
		position = {
			0,
			-249,
			0
		}
	},
	additional_option = {
		vertical_alignment = "bottom",
		parent = "game_option_2",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			200
		},
		position = {
			0,
			-216,
			0
		}
	},
	play_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
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
			1
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
			1
		}
	},
	private_button = {
		vertical_alignment = "bottom",
		parent = "additional_option",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] - 20,
			40
		},
		position = {
			0,
			12,
			10
		}
	},
	private_button_frame = {
		vertical_alignment = "bottom",
		parent = "private_button",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] - 20,
			45
		},
		position = {
			0,
			0,
			10
		}
	},
	host_button = {
		vertical_alignment = "top",
		parent = "private_button",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] - 20,
			40
		},
		position = {
			0,
			45,
			10
		}
	},
	host_button_frame = {
		vertical_alignment = "bottom",
		parent = "host_button",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] - 20,
			45
		},
		position = {
			0,
			0,
			10
		}
	},
	strict_matchmaking_button = {
		vertical_alignment = "top",
		parent = "host_button",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] - 20,
			40
		},
		position = {
			0,
			45,
			10
		}
	},
	strict_matchmaking_button_frame = {
		vertical_alignment = "bottom",
		parent = "strict_matchmaking_button",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] - 20,
			45
		},
		position = {
			0,
			0,
			10
		}
	}
}

local function var_0_6(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	arg_7_4 = arg_7_4 or "level_icon_01"

	local var_7_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_7_4)
	local var_7_1 = var_7_0 and var_7_0.size or {
		150,
		150
	}

	arg_7_5 = arg_7_5 or "game_options_bg_02"

	local var_7_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_7_5)
	local var_7_3 = "menu_frame_08"
	local var_7_4 = UIFrameSettings[var_7_3]
	local var_7_5 = var_7_4.texture_sizes.corner[1]
	local var_7_6 = "frame_outer_glow_01"
	local var_7_7 = UIFrameSettings[var_7_6]
	local var_7_8 = var_7_7.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background",
					content_change_function = function(arg_8_0, arg_8_1)
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
					content_check_function = function(arg_9_0)
						return not arg_9_0.button_hotspot.disable_button and (arg_9_0.option_text == "" or arg_9_0.option_text == "n/a")
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
					content_check_function = function(arg_10_0)
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
					content_check_function = function(arg_11_0)
						return arg_11_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "icon_frame",
					pass_type = "texture",
					texture_id = "icon_frame",
					content_check_function = function(arg_12_0, arg_12_1)
						return arg_12_0.icon
					end,
					content_change_function = function(arg_13_0, arg_13_1)
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
					content_check_function = function(arg_14_0, arg_14_1)
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
					content_check_function = function(arg_15_0, arg_15_1)
						return arg_15_0.icon
					end,
					content_change_function = function(arg_16_0, arg_16_1)
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
					content_check_function = function(arg_17_0)
						return not arg_17_0.button_hotspot.disable_button and not arg_17_0.icon
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function(arg_18_0)
						return arg_18_0.button_hotspot.disable_button and not arg_18_0.icon
					end
				},
				{
					style_id = "button_text_shadow",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function(arg_19_0)
						return not arg_19_0.button_hotspot.disable_button and not arg_19_0.icon
					end
				},
				{
					style_id = "option_text",
					pass_type = "text",
					text_id = "option_text",
					content_check_function = function(arg_20_0)
						return not arg_20_0.button_hotspot.disable_button and arg_20_0.icon
					end
				},
				{
					style_id = "option_text_shadow",
					pass_type = "text",
					text_id = "option_text",
					content_check_function = function(arg_21_0)
						return not arg_21_0.button_hotspot.disable_button and arg_21_0.icon
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_22_0)
						return not arg_22_0.button_hotspot.disable_button and arg_22_0.icon
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_23_0)
						return not arg_23_0.button_hotspot.disable_button and arg_23_0.icon
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_24_0)
						return arg_24_0.button_hotspot.disable_button and arg_24_0.icon
					end
				},
				{
					pass_type = "texture",
					style_id = "title_bg",
					texture_id = "title_bg",
					content_check_function = function(arg_25_0)
						return arg_25_0.icon
					end
				},
				{
					pass_type = "texture",
					style_id = "title_edge",
					texture_id = "title_edge",
					content_check_function = function(arg_26_0)
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
			frame = var_7_4.texture,
			glow_frame = var_7_7.texture,
			button_text = arg_7_3,
			title_text = arg_7_2 or "n/a",
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_7_1[2] / var_7_2.size[2], 1)
					},
					{
						math.min(arg_7_1[1] / var_7_2.size[1], 1),
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
				texture_size = var_7_4.texture_size,
				texture_sizes = var_7_4.texture_sizes
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
				texture_size = var_7_7.texture_size,
				texture_sizes = var_7_7.texture_sizes,
				frame_margins = {
					-(var_7_8 - 1),
					-(var_7_8 - 1)
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
				texture_size = var_7_1,
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
			icon_lock = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					146,
					146
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
					7
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
					arg_7_1[2] - 38 - var_7_5,
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
					arg_7_1[2] - 38 - var_7_5,
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
					var_7_5 + 5,
					-var_7_5,
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
					var_7_5 + 5 + 2,
					-(var_7_5 + 2),
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
					var_7_5 + 5,
					-var_7_5,
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
					var_7_5 + 5,
					-55,
					10
				},
				size = {
					arg_7_1[1] - var_7_1[1] - 60,
					arg_7_1[2]
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
					var_7_5 + 5 + 2,
					-57,
					9
				},
				size = {
					arg_7_1[1] - var_7_1[1] - 60,
					arg_7_1[2]
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
					var_7_5,
					var_7_5,
					10
				},
				size = {
					arg_7_1[1] - var_7_5 * 2,
					arg_7_1[2] - var_7_5 * 2
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
					var_7_5,
					var_7_5,
					10
				},
				size = {
					arg_7_1[1] - var_7_5 * 2,
					arg_7_1[2] - var_7_5 * 2
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
					var_7_5 + 2,
					var_7_5 - 2,
					9
				},
				size = {
					arg_7_1[1] - var_7_5 * 2,
					arg_7_1[2] - var_7_5 * 2
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
					var_7_5,
					var_7_5,
					1
				},
				size = {
					arg_7_1[1] - var_7_5 * 2,
					arg_7_1[2] - var_7_5 * 2
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
					var_7_5,
					var_7_5,
					15
				},
				size = {
					arg_7_1[1] - var_7_5 * 2,
					arg_7_1[2] - var_7_5 * 2
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
					var_7_5,
					var_7_5,
					15
				},
				size = {
					arg_7_1[1] - var_7_5 * 2,
					arg_7_1[2] - var_7_5 * 2
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

local function var_0_7(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	arg_27_3 = arg_27_3 or "game_options_bg_02"

	local var_27_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_27_3)
	local var_27_1 = "menu_frame_08"
	local var_27_2 = UIFrameSettings[var_27_1]
	local var_27_3 = var_27_2.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background",
					content_change_function = function(arg_28_0, arg_28_1)
						if arg_28_0.parent.button_hotspot.disable_button then
							arg_28_1.saturated = true
						else
							arg_28_1.saturated = false
						end
					end
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function(arg_29_0)
						return arg_29_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_30_0)
						return not arg_30_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_31_0)
						return arg_31_0.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "title_bg",
					texture_id = "title_bg"
				},
				{
					pass_type = "texture",
					style_id = "title_edge",
					texture_id = "title_edge"
				}
			}
		},
		content = {
			title_edge = "game_option_divider",
			title_bg = "playername_bg_02",
			button_hotspot = {
				allow_multi_hover = true
			},
			frame = var_27_2.texture,
			title_text = arg_27_2 or "n/a",
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_27_1[2] / var_27_0.size[2], 1)
					},
					{
						math.min(arg_27_1[1] / var_27_0.size[1], 1),
						1
					}
				},
				texture_id = arg_27_3
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
				size = arg_27_1,
				texture_size = var_27_2.texture_size,
				texture_sizes = var_27_2.texture_sizes
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
			title_bg = {
				size = {
					arg_27_1[1],
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
					arg_27_1[2] - 38 - var_27_3,
					2
				}
			},
			title_edge = {
				size = {
					arg_27_1[1],
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
					arg_27_1[2] - 38 - var_27_3,
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
					var_27_3 + 5,
					-var_27_3,
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
					var_27_3 + 5 + 2,
					-(var_27_3 + 2),
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
				text_color = {
					255,
					108,
					108,
					108
				},
				default_text_color = {
					255,
					108,
					108,
					108
				},
				offset = {
					var_27_3 + 5,
					-var_27_3,
					10
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
					5,
					0,
					15
				},
				size = {
					arg_27_1[1] - 10,
					arg_27_1[2]
				}
			}
		},
		scenegraph_id = arg_27_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_8 = {
	background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window"),
	window = UIWidgets.create_frame("window", var_0_2, var_0_1, 20),
	play_button = UIWidgets.create_play_button("play_button", var_0_5.play_button.size, Localize("start_game_window_play"), 34),
	game_option_1 = var_0_6("game_option_1", var_0_5.game_option_1.size, Localize("start_game_window_mission"), Localize("start_game_window_change_mission"), nil, "game_options_bg_01"),
	game_option_2 = var_0_6("game_option_2", var_0_5.game_option_2.size, Localize("start_game_window_difficulty"), Localize("start_game_window_change_difficulty"), "difficulty_option_1", "game_options_bg_02"),
	game_options_left_chain = UIWidgets.create_tiled_texture("game_options_left_chain", "chain_link_01", {
		16,
		19
	}),
	game_options_right_chain = UIWidgets.create_tiled_texture("game_options_right_chain", "chain_link_01", {
		16,
		19
	})
}
local var_0_9 = {
	additional_option = var_0_7("additional_option", var_0_5.additional_option.size, Localize("start_game_window_other_options_title"), "game_options_bg_03"),
	private_frame = UIWidgets.create_frame("private_button_frame", var_0_5.private_button_frame.size, var_0_1, 1),
	private_button = UIWidgets.create_default_checkbox_button("private_button", var_0_5.private_button.size, Localize("start_game_window_other_options_private"), 24, {
		title = Localize("start_game_window_other_options_private"),
		description = Localize("start_game_window_other_options_private_description")
	}),
	host_frame = UIWidgets.create_frame("host_button_frame", var_0_5.host_button_frame.size, var_0_1, 1),
	host_button = UIWidgets.create_default_checkbox_button("host_button", var_0_5.host_button.size, Localize("start_game_window_other_options_always_host"), 24, {
		title = Localize("start_game_window_other_options_always_host"),
		description = Localize("start_game_window_other_options_always_host_description")
	}),
	strict_matchmaking_frame = UIWidgets.create_frame("strict_matchmaking_button_frame", var_0_5.strict_matchmaking_button_frame.size, var_0_1, 1),
	strict_matchmaking_button = UIWidgets.create_default_checkbox_button("strict_matchmaking_button", var_0_5.strict_matchmaking_button.size, Localize("start_game_window_other_options_strict_matchmaking"), 24, {
		title = Localize("start_game_window_other_options_strict_matchmaking"),
		description = Localize("start_game_window_other_options_strict_matchmaking_description")
	})
}

return {
	widgets = var_0_8,
	other_options_widgets = var_0_9,
	scenegraph_definition = var_0_5,
	animation_definitions = var_0_4
}
