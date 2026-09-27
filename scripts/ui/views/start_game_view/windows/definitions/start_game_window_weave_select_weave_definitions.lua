-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_select_weave_definitions.lua

local game_start_windows = UISettings.game_start_windows
local frame = game_start_windows.frame
local size = game_start_windows.size
local tbl = {
	size[1] - 20,
	72
}
local tbl_2 = {
	size[1] - 20,
	size[2] - 32
}
local str = "menu_frame_08"
local var_0_6 = UIFrameSettings[str].texture_sizes.corner[1]
local tbl_3 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeOutCubic = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
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
				-- function 4
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeOutCubic = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		}
	}
}
local tbl_4 = {
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
		size = size,
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
		size = tbl,
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
			size[2]
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
			size[2]
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
		size = tbl_2,
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
			tbl_2[1] - 10,
			0
		},
		position = {
			0,
			-var_0_6,
			1
		}
	}
}

local function fn(arg_7_0, arg_7_1)
	-- function 7
	local str = "game_options_bg_04"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local str_2 = "menu_frame_08"
	local var_7_3 = UIFrameSettings[str_2]
	local var_7_4 = var_7_3.texture_sizes.corner[1]
	local str_3 = "frame_outer_glow_01"
	local var_7_6 = UIFrameSettings[str_3]
	local var_7_7 = var_7_6.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background",
					content_change_function = function (self, arg_8_1)
						-- function 8
						if not self.parent.button_hotspot.disable_button then
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
					content_check_function = function (self)
						-- function 9
						return not not self.button_hotspot.disable_button or not self.has_item
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
					content_check_function = function (self)
						-- function 10
						local is_clicked = self.button_hotspot.is_clicked

						return not is_clicked and is_clicked == 0
					end
				},
				{
					pass_type = "rect",
					style_id = "button_hover_rect"
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 11
						return self.button_hotspot.disable_button
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
					content_check_function = function (self)
						-- function 12
						return not not self.button_hotspot.disable_button or not self.has_item
					end
				},
				{
					style_id = "option_text_shadow",
					pass_type = "text",
					text_id = "option_text",
					content_check_function = function (self)
						-- function 13
						return not not self.button_hotspot.disable_button or not self.has_item
					end
				},
				{
					style_id = "warning_text",
					pass_type = "text",
					text_id = "warning_text",
					content_check_function = function (self)
						-- function 14
						local disable_button = self.button_hotspot.disable_button

						disable_button = not disable_button and not self.has_item

						return disable_button
					end
				},
				{
					style_id = "warning_text_shadow",
					pass_type = "text",
					text_id = "warning_text",
					content_check_function = function (self)
						-- function 15
						local disable_button = self.button_hotspot.disable_button

						disable_button = not disable_button and not self.has_item

						return disable_button
					end
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text",
					content_check_function = function (self)
						-- function 16
						return not not self.button_hotspot.disable_button or not self.has_item
					end
				},
				{
					pass_type = "texture",
					style_id = "divider",
					texture_id = "divider"
				}
			}
		},
		content = {
			glass = "game_options_fg_04",
			glow = "game_options_glow_01",
			divider = "divider_01_top",
			button_hotspot = {},
			frame = var_7_3.texture,
			glow_frame = var_7_6.texture,
			option_text = Localize("start_game_window_weave_select_weave"),
			warning_text = Localize("start_game_window_no_deeds_available"),
			description_text = Localize("start_game_window_weave_select_weave_description"),
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_7_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
					},
					{
						math.min(arg_7_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
						1
					}
				},
				texture_id = str
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
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_7_4 * 2,
					60,
					10
				},
				size = {
					arg_7_1[1] - var_7_4 * 4,
					arg_7_1[2]
				}
			},
			option_text_shadow = {
				font_size = 42,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_7_4 * 2 + 2,
					58,
					9
				},
				size = {
					arg_7_1[1] - var_7_4 * 4,
					arg_7_1[2]
				}
			},
			warning_text = {
				font_size = 42,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("red", 255),
				default_text_color = Colors.get_color_table_with_alpha("red", 255),
				offset = {
					var_7_4 * 2,
					60,
					10
				},
				size = {
					arg_7_1[1] - var_7_4 * 4,
					arg_7_1[2]
				}
			},
			warning_text_shadow = {
				font_size = 42,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_7_4 * 2 + 2,
					58,
					9
				},
				size = {
					arg_7_1[1] - var_7_4 * 4,
					arg_7_1[2]
				}
			},
			description_text = {
				word_wrap = true,
				font_size = 18,
				localize = false,
				use_shadow = true,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_7_4 * 2 + 2 + 55,
					-400,
					9
				},
				size = {
					arg_7_1[1] - var_7_4 * 4 - 100,
					arg_7_1[2]
				}
			},
			divider = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					246,
					32
				},
				offset = {
					0,
					25,
					9
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

local tbl_5 = {
	overlay_button = fn("game_option_1", tbl_4.game_option_1.size),
	background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window"),
	window = UIWidgets.create_frame("window", size, frame, 20)
}

return {
	widgets = tbl_5,
	scenegraph_definition = tbl_4,
	animation_definitions = tbl_3
}
