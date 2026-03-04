-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_difficulty_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = var_0_0.spacing
local var_0_4 = UIFrameSettings[var_0_1].texture_sizes.vertical[1]
local var_0_5 = UIFrameSettings[var_0_1].texture_sizes.horizontal[2]
local var_0_6 = var_0_2[1] * 2 + var_0_3 * 2
local var_0_7 = var_0_2[1] - (var_0_4 * 2 + 60)
local var_0_8 = {
	var_0_2[1] * 2 + var_0_3,
	var_0_2[2]
}
local var_0_9 = {
	var_0_8[1] - 20,
	108
}
local var_0_10 = {
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
local var_0_11 = {
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
		size = var_0_8,
		position = {
			var_0_2[1] / 2 + var_0_3 / 2,
			0,
			1
		}
	},
	info_window = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = var_0_2,
		position = {
			var_0_2[1] + var_0_3,
			0,
			1
		}
	},
	difficulty_root = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			10,
			-16,
			3
		}
	},
	difficulty_option = {
		vertical_alignment = "top",
		parent = "difficulty_root",
		horizontal_alignment = "left",
		size = var_0_9,
		position = {
			0,
			0,
			0
		}
	},
	difficulty_texture = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			150,
			150
		},
		position = {
			0,
			-60,
			1
		}
	},
	difficulty_title = {
		vertical_alignment = "center",
		parent = "difficulty_texture",
		horizontal_alignment = "center",
		size = {
			var_0_7,
			50
		},
		position = {
			0,
			-108,
			1
		}
	},
	difficulty_title_divider = {
		vertical_alignment = "center",
		parent = "difficulty_title",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-55,
			1
		}
	},
	description_text = {
		vertical_alignment = "center",
		parent = "difficulty_title_divider",
		horizontal_alignment = "center",
		size = {
			var_0_7,
			var_0_2[2] / 2
		},
		position = {
			0,
			-65,
			1
		}
	},
	background_fade = {
		vertical_alignment = "center",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1],
			200
		},
		position = {
			0,
			15,
			0
		}
	},
	difficulty_bottom_divider = {
		vertical_alignment = "bottom",
		parent = "background_fade",
		horizontal_alignment = "center",
		size = {
			264,
			21
		},
		position = {
			0,
			0,
			1
		}
	},
	warning_bg = {
		vertical_alignment = "bottom",
		parent = "background_fade",
		horizontal_alignment = "center",
		size = {
			var_0_2[1],
			100
		},
		position = {
			0,
			-100,
			1
		}
	},
	warning_texture = {
		vertical_alignment = "center",
		parent = "warning_bg",
		horizontal_alignment = "center",
		size = {
			485,
			103
		},
		position = {
			0,
			0,
			1
		}
	},
	requirement_bg = {
		vertical_alignment = "bottom",
		parent = "warning_bg",
		horizontal_alignment = "center",
		size = {
			var_0_2[1],
			100
		},
		position = {
			0,
			-80,
			1
		}
	},
	difficulty_chest_info = {
		vertical_alignment = "bottom",
		parent = "background_fade",
		horizontal_alignment = "center",
		size = {
			var_0_7,
			20
		},
		position = {
			0,
			40,
			0
		}
	},
	difficulty_xp_multiplier = {
		vertical_alignment = "top",
		parent = "difficulty_chest_info",
		horizontal_alignment = "center",
		size = {
			var_0_7,
			20
		},
		position = {
			0,
			-30,
			0
		}
	},
	difficulty_lock_text = {
		vertical_alignment = "top",
		parent = "difficulty_xp_multiplier",
		horizontal_alignment = "center",
		size = {
			var_0_7,
			20
		},
		position = {
			0,
			-90,
			0
		}
	},
	difficulty_second_lock_text = {
		vertical_alignment = "top",
		parent = "difficulty_xp_multiplier",
		horizontal_alignment = "center",
		size = {
			var_0_7,
			20
		},
		position = {
			0,
			-55,
			0
		}
	},
	difficulty_is_locked_text = {
		vertical_alignment = "top",
		parent = "difficulty_lock_text",
		horizontal_alignment = "center",
		size = {
			var_0_7,
			20
		},
		position = {
			0,
			-70,
			0
		}
	},
	select_button = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			460,
			72
		},
		position = {
			0,
			18,
			20
		}
	},
	buy_button = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			477,
			91
		},
		position = {
			0,
			18,
			40
		}
	},
	game_options_right_chain = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			16,
			var_0_2[2] - 230
		},
		position = {
			300,
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
			-300,
			0,
			1
		}
	},
	game_options_right_chain_end = {
		vertical_alignment = "bottom",
		parent = "game_options_right_chain",
		horizontal_alignment = "center",
		size = {
			19,
			20
		},
		position = {
			-1,
			-20,
			1
		}
	},
	game_options_left_chain_end = {
		vertical_alignment = "bottom",
		parent = "game_options_left_chain",
		horizontal_alignment = "center",
		size = {
			19,
			20
		},
		position = {
			-1,
			-20,
			1
		}
	},
	dlc_difficulty_divider = {
		vertical_alignment = "center",
		parent = "difficulty_option",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-55,
			1
		}
	}
}
local var_0_12 = {
	word_wrap = false,
	upper_case = true,
	localize = false,
	font_size = 26,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = {
		255,
		246,
		56,
		53
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_13 = {
	word_wrap = true,
	font_size = 18,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_14 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = {
		255,
		199,
		199,
		199
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_15 = {
	font_size = 20,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		250,
		250,
		250
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_16 = {
	font_size = 20,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("cyan", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_17 = {
	font_size = 18,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		199,
		199,
		199
	},
	offset = {
		0,
		-30,
		2
	}
}
local var_0_18 = {
	font_size = 18,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = false,
	font_type = "hell_shark",
	text_color = {
		255,
		199,
		199,
		199
	},
	offset = {
		0,
		-60,
		2
	}
}
local var_0_19 = {
	font_size = 20,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		220,
		148,
		64
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_20 = {
	font_size = 20,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		193,
		90,
		36
	},
	offset = {
		0,
		25,
		2
	}
}

local function var_0_21(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = true
	local var_7_1 = "difficulty_option_1"
	local var_7_2 = 0.5
	local var_7_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_7_1)
	local var_7_4 = {
		math.floor(var_7_3.size[1] * var_7_2),
		math.floor(var_7_3.size[2] * var_7_2)
	}
	local var_7_5 = arg_7_4 or "button_bg_01"
	local var_7_6 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_7_5)
	local var_7_7 = "menu_frame_08"
	local var_7_8 = UIFrameSettings[var_7_7]
	local var_7_9 = var_7_8.texture_sizes.corner[1]
	local var_7_10 = "frame_outer_glow_01"
	local var_7_11 = UIFrameSettings[var_7_10].texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
				},
				{
					texture_id = "background_icon",
					style_id = "background_icon",
					pass_type = "texture",
					content_check_function = function(arg_8_0)
						local var_8_0 = arg_8_0.button_hotspot

						return arg_8_0.background_icon and (var_8_0.is_hover or var_8_0.is_selected)
					end
				},
				{
					texture_id = "background_icon_unlit",
					style_id = "background_icon_unlit",
					pass_type = "texture",
					content_check_function = function(arg_9_0)
						local var_9_0 = arg_9_0.button_hotspot

						return arg_9_0.background_icon_unlit and not var_9_0.is_hover
					end
				},
				{
					texture_id = "dlc_locked_texture",
					style_id = "dlc_locked_texture",
					pass_type = "texture",
					content_check_function = function(arg_10_0)
						return arg_10_0.dlc_locked
					end
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					texture_id = "new_texture",
					style_id = "new_texture",
					pass_type = "texture",
					content_check_function = function(arg_11_0)
						return arg_11_0.new
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function(arg_12_0)
						return not arg_12_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "icon",
					style_id = "icon_disabled",
					pass_type = "texture",
					content_check_function = function(arg_13_0)
						return arg_13_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "icon_frame",
					style_id = "icon_frame",
					pass_type = "texture"
				},
				{
					texture_id = "icon_glass",
					style_id = "icon_glass",
					pass_type = "texture"
				},
				{
					texture_id = "icon_bg_glow",
					style_id = "icon_bg_glow",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					texture_id = "select_glow",
					style_id = "select_glow",
					pass_type = "texture"
				},
				{
					texture_id = "skull_select_glow",
					style_id = "skull_select_glow",
					pass_type = "texture"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_14_0)
						return not arg_14_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_15_0)
						return arg_15_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					pass_type = "rect",
					style_id = "button_clicked_rect"
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function(arg_16_0)
						return arg_16_0.button_hotspot.disable_button
					end
				}
			}
		},
		content = {
			glass = "button_glass_02",
			title_text = "n/a",
			hover_glow = "button_state_default",
			icon_frame = "menu_options_button_bg",
			icon_bg_glow = "menu_options_button_glow_01",
			dlc_locked_texture = "hero_icon_locked",
			icon_glass = "menu_options_button_fg",
			new_texture = "list_item_tag_new",
			select_glow = "button_state_default_2",
			background_fade = "button_bg_fade",
			skull_select_glow = "menu_options_button_glow_03",
			background_icon = arg_7_2,
			background_icon_unlit = arg_7_3,
			icon = var_7_1,
			frame = var_7_8.texture,
			button_hotspot = {},
			dlc_locked = arg_7_5,
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_7_1[2] / var_7_6.size[2], 1)
					},
					{
						math.min(arg_7_1[1] / var_7_6.size[1], 1),
						1
					}
				},
				texture_id = var_7_5
			}
		},
		style = {
			background = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					0,
					0,
					0
				},
				size = arg_7_1
			},
			background_fade = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_7_9,
					var_7_9,
					1
				},
				size = {
					arg_7_1[1] - var_7_9 * 2,
					arg_7_1[2] - var_7_9 * 2
				}
			},
			background_icon = {
				vertical_alignment = "center",
				saturated = false,
				horizontal_alignment = "right",
				color = {
					150,
					100,
					100,
					100
				},
				default_color = {
					150,
					100,
					100,
					100
				},
				texture_size = {
					350,
					108
				},
				offset = {
					0,
					0,
					3
				}
			},
			background_icon_unlit = {
				vertical_alignment = "center",
				saturated = false,
				horizontal_alignment = "right",
				color = {
					150,
					100,
					100,
					100
				},
				default_color = {
					150,
					100,
					100,
					100
				},
				texture_size = {
					350,
					108
				},
				offset = {
					0,
					0,
					3
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
					3
				}
			},
			hover_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					5,
					2
				},
				size = {
					arg_7_1[1],
					math.min(arg_7_1[2] - 5, 80)
				}
			},
			select_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					5,
					3
				},
				size = {
					arg_7_1[1],
					math.min(arg_7_1[2] - 5, 80)
				}
			},
			title_text = {
				font_size = 32,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				dynamic_font_size = var_7_0,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					130,
					0,
					6
				},
				size = {
					arg_7_1[1] - 140,
					arg_7_1[2]
				}
			},
			title_text_disabled = {
				font_size = 32,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				dynamic_font_size = var_7_0,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					130,
					0,
					6
				},
				size = {
					arg_7_1[1] - 140,
					arg_7_1[2]
				}
			},
			title_text_shadow = {
				font_size = 32,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				dynamic_font_size = var_7_0,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					132,
					-2,
					5
				},
				size = {
					arg_7_1[1] - 140,
					arg_7_1[2]
				}
			},
			button_clicked_rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				},
				size = arg_7_1
			},
			button_disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					0,
					0,
					5
				},
				size = arg_7_1
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
					arg_7_1[2] - (var_7_9 + 9),
					6
				},
				size = {
					arg_7_1[1],
					11
				}
			},
			glass_bottom = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					0,
					var_7_9 - 11,
					6
				},
				size = {
					arg_7_1[1],
					11
				}
			},
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
				texture_size = var_7_8.texture_size,
				texture_sizes = var_7_8.texture_sizes
			},
			new_texture = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_7_1[1] - 126,
					arg_7_1[2] - 56,
					6
				},
				size = {
					126,
					51
				}
			},
			icon_frame = {
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					116,
					108
				},
				offset = {
					0,
					0,
					11
				}
			},
			icon_glass = {
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					116,
					108
				},
				offset = {
					0,
					0,
					15
				}
			},
			icon_bg_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				texture_size = {
					116,
					108
				},
				offset = {
					0,
					0,
					11
				}
			},
			icon = {
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_color = Colors.get_color_table_with_alpha("white", 255),
				texture_size = var_7_4,
				offset = {
					54 - var_7_4[1] / 2,
					54 - var_7_4[2] / 2,
					12
				}
			},
			icon_disabled = {
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
				texture_size = var_7_4,
				offset = {
					54 - var_7_4[1] / 2,
					54 - var_7_4[2] / 2,
					12
				}
			},
			skull_select_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					12
				},
				size = {
					28,
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

function create_buy_button(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9)
	arg_17_3 = arg_17_3 or "button_bg_01"

	local var_17_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_17_3)
	local var_17_1 = arg_17_2 and UIFrameSettings[arg_17_2] or UIFrameSettings.button_frame_01
	local var_17_2 = var_17_1.texture_sizes.corner[1]
	local var_17_3 = arg_17_7 or "button_detail_01"
	local var_17_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_17_3).size

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame",
					content_check_function = function(arg_18_0)
						return arg_18_0.draw_frame
					end
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					pass_type = "rect",
					style_id = "clicked_rect"
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function(arg_19_0)
						return arg_19_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_20_0)
						return not arg_20_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_21_0)
						return arg_21_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				}
			}
		},
		content = {
			glass = "button_glass_02",
			hover_glow = "button_state_default",
			draw_frame = true,
			button_hotspot = {},
			title_text = arg_17_4 or "n/a",
			frame = var_17_1.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_17_1[2] / var_17_0.size[2]
					},
					{
						arg_17_1[1] / var_17_0.size[1],
						1
					}
				},
				texture_id = arg_17_3
			},
			disable_with_gamepad = arg_17_9
		},
		style = {
			background = {
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
			hover_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					var_17_2 - 2,
					3
				},
				size = {
					arg_17_1[1],
					math.min(arg_17_1[2] - 5, 80)
				}
			},
			clicked_rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				}
			},
			disabled_rect = {
				color = {
					150,
					20,
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			},
			title_text = {
				upper_case = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_17_5 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = {
					255,
					250,
					250,
					250
				},
				size = {
					arg_17_1[1] - 40,
					arg_17_1[2]
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_disabled = {
				upper_case = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_17_5 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				size = {
					arg_17_1[1] - 40,
					arg_17_1[2]
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_shadow = {
				upper_case = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_17_5 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					arg_17_1[1] - 40,
					arg_17_1[2]
				},
				offset = {
					22,
					-2,
					5
				}
			},
			frame = {
				texture_size = var_17_1.texture_size,
				texture_sizes = var_17_1.texture_sizes,
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
					arg_17_1[2] - (var_17_2 + 11),
					4
				},
				size = {
					arg_17_1[1],
					11
				}
			},
			glass_bottom = {
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					0,
					var_17_2 - 9,
					4
				},
				size = {
					arg_17_1[1],
					11
				}
			}
		},
		scenegraph_id = arg_17_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_22 = true
local var_0_23 = {
	background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "info_window"),
	background_mask = UIWidgets.create_simple_texture("mask_rect", "info_window"),
	info_window = UIWidgets.create_frame("info_window", var_0_2, var_0_1, 20),
	window = UIWidgets.create_frame("window", var_0_8, var_0_1, 10),
	info_bg_fade = UIWidgets.create_simple_texture("difficulty_gradient", "background_fade", nil, nil, {
		128,
		255,
		255,
		255
	}),
	difficulty_bottom_divider = UIWidgets.create_simple_texture("divider_01_bottom", "difficulty_bottom_divider"),
	extreme_difficulty_bg = UIWidgets.create_simple_texture("extreme_difficulty_bg", "warning_texture"),
	extremely_hard_text = UIWidgets.create_simple_text(Localize("difficulty_cataclysm_warning"), "warning_bg", nil, nil, var_0_12),
	difficulty_title = UIWidgets.create_simple_text("difficulty_title", "difficulty_title", nil, nil, var_0_14),
	difficulty_texture = UIWidgets.create_simple_texture("difficulty_option_1", "difficulty_texture"),
	difficulty_title_divider = UIWidgets.create_simple_texture("divider_01_top", "difficulty_title_divider"),
	description_text = UIWidgets.create_simple_text(Localize("start_game_window_adventure_desc"), "description_text", nil, nil, var_0_13),
	difficulty_chest_info = UIWidgets.create_simple_text("", "difficulty_chest_info", nil, nil, var_0_15),
	difficulty_lock_text = UIWidgets.create_simple_text("difficulty_lock_text", "requirement_bg", nil, nil, var_0_17),
	difficulty_second_lock_text = UIWidgets.create_simple_text("n/a", "requirement_bg", nil, nil, var_0_18),
	difficulty_is_locked_text = UIWidgets.create_simple_text("n/a", "requirement_bg", nil, nil, var_0_19),
	dlc_lock_text = UIWidgets.create_simple_text(Localize("cataclysm_no_wom"), "buy_button", nil, nil, var_0_20),
	select_button = UIWidgets.create_default_button("select_button", var_0_11.select_button.size, nil, nil, Localize("confirm_menu_button_name"), 32, nil, nil, nil, var_0_22),
	buy_button = create_buy_button("buy_button", var_0_11.buy_button.size, nil, "wom_button", Localize("menu_weave_area_no_wom_button"), 32, nil, nil, nil, var_0_22),
	game_options_left_chain = UIWidgets.create_tiled_texture("game_options_left_chain", "chain_link_01", {
		16,
		19
	}),
	game_options_right_chain = UIWidgets.create_tiled_texture("game_options_right_chain", "chain_link_01", {
		16,
		19
	}),
	game_options_right_chain_end = UIWidgets.create_simple_texture("chain_link_02", "game_options_right_chain_end"),
	game_options_left_chain_end = UIWidgets.create_simple_texture("chain_link_02", "game_options_left_chain_end")
}

return {
	widgets = var_0_23,
	create_difficulty_button = var_0_21,
	scenegraph_definition = var_0_11,
	animation_definitions = var_0_10,
	create_dlc_difficulty_divider = UIWidgets.create_simple_texture
}
