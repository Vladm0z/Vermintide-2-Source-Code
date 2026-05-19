-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_list_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = {
	var_0_2[1] - 20,
	72
}
local var_0_4 = {
	var_0_2[1] - 20,
	var_0_2[2] - (50 + var_0_3[2])
}
local var_0_5 = "menu_frame_08"
local var_0_6 = UIFrameSettings[var_0_5].texture_sizes.corner[1]
local var_0_7 = {
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
local var_0_8 = {
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
	play_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_3,
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
	},
	game_option_1 = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_4,
		position = {
			0,
			-16,
			4
		}
	},
	item_presentation = {
		vertical_alignment = "top",
		parent = "game_option_1",
		horizontal_alignment = "center",
		size = {
			var_0_4[1] - 10,
			0
		},
		position = {
			0,
			-var_0_6,
			1
		}
	}
}

local function var_0_9(arg_7_0, arg_7_1)
	local var_7_0 = "game_options_bg_04"
	local var_7_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_7_0)
	local var_7_2 = "menu_frame_08"
	local var_7_3 = UIFrameSettings[var_7_2]
	local var_7_4 = var_7_3.texture_sizes.corner[1]
	local var_7_5 = "frame_outer_glow_01"
	local var_7_6 = UIFrameSettings[var_7_5]
	local var_7_7 = var_7_6.texture_sizes.corner[1]

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
						return not arg_9_0.button_hotspot.disable_button and not arg_9_0.has_item
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
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture"
				},
				{
					style_id = "option_text",
					pass_type = "text",
					text_id = "option_text",
					content_check_function = function(arg_12_0)
						return not arg_12_0.button_hotspot.disable_button and not arg_12_0.has_item
					end
				},
				{
					style_id = "option_text_shadow",
					pass_type = "text",
					text_id = "option_text",
					content_check_function = function(arg_13_0)
						return not arg_13_0.button_hotspot.disable_button and not arg_13_0.has_item
					end
				},
				{
					style_id = "warning_text",
					pass_type = "text",
					text_id = "warning_text",
					content_check_function = function(arg_14_0)
						return arg_14_0.button_hotspot.disable_button and not arg_14_0.has_item
					end
				},
				{
					style_id = "warning_text_shadow",
					pass_type = "text",
					text_id = "warning_text",
					content_check_function = function(arg_15_0)
						return arg_15_0.button_hotspot.disable_button and not arg_15_0.has_item
					end
				}
			}
		},
		content = {
			glass = "game_options_fg_04",
			glow = "game_options_glow_01",
			button_hotspot = {},
			frame = var_7_3.texture,
			glow_frame = var_7_6.texture,
			option_text = Localize("start_game_window_select_deed"),
			warning_text = Localize("start_game_window_no_deeds_available"),
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_7_1[2] / var_7_1.size[2], 1)
					},
					{
						math.min(arg_7_1[1] / var_7_1.size[1], 1),
						1
					}
				},
				texture_id = var_7_0
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
				texture_size = var_7_3.texture_size,
				texture_sizes = var_7_3.texture_sizes
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
				texture_size = var_7_6.texture_size,
				texture_sizes = var_7_6.texture_sizes,
				frame_margins = {
					-(var_7_7 - 1),
					-(var_7_7 - 1)
				}
			},
			background = {
				saturated = true,
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
				},
				size = {
					arg_7_1[1],
					233
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
					var_7_4,
					var_7_4,
					1
				},
				size = {
					arg_7_1[1] - var_7_4 * 2,
					arg_7_1[2] - var_7_4 * 2
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
					var_7_4,
					var_7_4,
					15
				},
				size = {
					arg_7_1[1] - var_7_4 * 2,
					arg_7_1[2] - var_7_4 * 2
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
					var_7_4,
					var_7_4,
					15
				},
				size = {
					arg_7_1[1] - var_7_4 * 2,
					arg_7_1[2] - var_7_4 * 2
				}
			},
			option_text = {
				font_size = 42,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_7_4 * 2,
					0,
					10
				},
				size = {
					arg_7_1[1] - var_7_4 * 4,
					arg_7_1[2]
				}
			},
			option_text_shadow = {
				font_size = 42,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_7_4 * 2 + 2,
					-2,
					9
				},
				size = {
					arg_7_1[1] - var_7_4 * 4,
					arg_7_1[2]
				}
			},
			warning_text = {
				font_size = 42,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("red", 255),
				default_text_color = Colors.get_color_table_with_alpha("red", 255),
				offset = {
					var_7_4 * 2,
					0,
					10
				},
				size = {
					arg_7_1[1] - var_7_4 * 4,
					arg_7_1[2]
				}
			},
			warning_text_shadow = {
				font_size = 42,
				upper_case = false,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_7_4 * 2 + 2,
					-2,
					9
				},
				size = {
					arg_7_1[1] - var_7_4 * 4,
					arg_7_1[2]
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

local var_0_10 = {
	item_presentation = UIWidgets.create_simple_item_presentation("item_presentation"),
	overlay_button = var_0_9("game_option_1", var_0_8.game_option_1.size),
	game_options_left_chain = UIWidgets.create_tiled_texture("game_options_left_chain", "chain_link_01", {
		16,
		19
	}),
	game_options_right_chain = UIWidgets.create_tiled_texture("game_options_right_chain", "chain_link_01", {
		16,
		19
	}),
	background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window"),
	window = UIWidgets.create_frame("window", var_0_2, var_0_1, 20),
	play_button = UIWidgets.create_play_button("play_button", var_0_8.play_button.size, Localize("start_game_window_play"), 34)
}

return {
	widgets = var_0_10,
	scenegraph_definition = var_0_8,
	animation_definitions = var_0_7
}
