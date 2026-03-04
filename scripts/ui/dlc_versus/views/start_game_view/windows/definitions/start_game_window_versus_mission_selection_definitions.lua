-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_mission_selection_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = {
	var_0_2[1] * 3 - 76,
	var_0_2[2]
}
local var_0_4 = UIFrameSettings[var_0_1].texture_sizes.vertical[1]
local var_0_5 = var_0_2[1] - (var_0_4 * 2 + 60)
local var_0_6 = {
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
		size = var_0_3,
		position = {
			0,
			0,
			1
		}
	},
	info_window = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			var_0_2[1],
			var_0_2[2]
		},
		position = {
			0,
			0,
			1
		}
	},
	background = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			var_0_2[1],
			var_0_2[2]
		},
		position = {
			0,
			0,
			0
		}
	},
	mask = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			660,
			var_0_2[2] + 10
		},
		position = {
			-30,
			10,
			0
		}
	},
	level_image = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			194,
			116
		},
		position = {
			-500,
			-30,
			1
		}
	},
	grid_anchor = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			0
		},
		size = {
			1920,
			1080
		}
	},
	scroller = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		position = {
			-40,
			10,
			0
		},
		size = {
			20,
			var_0_2[2] + 10
		}
	},
	description_text = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			var_0_2[2] / 2
		},
		position = {
			0,
			0,
			1
		}
	},
	locked_text = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			100
		},
		position = {
			0,
			-20,
			1
		}
	},
	level_texture_frame = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			-80,
			2
		}
	},
	level_texture = {
		vertical_alignment = "center",
		parent = "level_texture_frame",
		horizontal_alignment = "center",
		size = {
			168,
			168
		},
		position = {
			0,
			0,
			-1
		}
	},
	level_texture_lock = {
		vertical_alignment = "center",
		parent = "level_texture_frame",
		horizontal_alignment = "center",
		size = {
			146,
			146
		},
		position = {
			0,
			0,
			1
		}
	},
	level_title_divider = {
		vertical_alignment = "bottom",
		parent = "level_texture_frame",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-90,
			1
		}
	},
	level_title = {
		vertical_alignment = "bottom",
		parent = "level_title_divider",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			50
		},
		position = {
			0,
			20,
			1
		}
	},
	helper_text = {
		vertical_alignment = "bottom",
		parent = "level_title_divider",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			50
		},
		position = {
			0,
			-50,
			1
		}
	}
}
local var_0_7 = {
	margin = 20,
	columns = 4,
	area_spacing = {
		0,
		-40,
		0
	},
	act_spacing = {
		5,
		-33,
		1
	},
	level_spacing = {
		137.5,
		-87.5,
		0
	},
	level_size = {
		121.25,
		72.5
	},
	section_spacing = {
		0,
		-60,
		0
	}
}
local var_0_8 = {
	font_size = 24,
	use_shadow = true,
	localize = false,
	dynamic_font_size_word_wrap = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_9 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_10 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_11 = {
	font_size = 28,
	upper_case = true,
	localize = false,
	word_wrap = true,
	horizontal_alignment = "center",
	use_shadow = true,
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		0
	}
}
local var_0_12 = {
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
		},
		{
			name = "animate_in_window",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_0.window.local_position[1] = arg_5_1.window.position[1] + math.floor(-100 * (1 - var_5_0))
				arg_5_0.info_window.local_position[1] = arg_5_1.info_window.position[1] + math.floor(-80 * (1 - var_5_0))
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				arg_7_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				arg_8_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		}
	}
}

local function var_0_13(arg_10_0, arg_10_1)
	local var_10_0 = UIFrameSettings.frame_outer_fade_02
	local var_10_1 = var_10_0.texture_sizes.horizontal[2]

	return {
		scenegraph_id = "grid_anchor",
		element = {
			passes = {
				{
					style_id = "text_id",
					pass_type = "text",
					text_id = "text_id"
				},
				{
					style_id = "text_id_shadow",
					pass_type = "text",
					text_id = "text_id"
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background_id"
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				}
			}
		},
		content = {
			background_id = "rect_masked",
			text_id = arg_10_0.area_display_name,
			frame = var_10_0.texture
		},
		style = {
			text_id = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					10,
					-10,
					2
				}
			},
			text_id_shadow = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					12,
					-12,
					1
				}
			},
			background = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					160,
					0,
					0,
					0
				},
				texture_size = {
					var_0_7.level_spacing[1] * var_0_7.columns + var_0_7.margin * 2,
					0
				},
				offset = {
					0,
					0,
					0
				}
			},
			frame = {
				horizontal_alignment = "left",
				masked = true,
				vertical_alignment = "top",
				color = {
					160,
					0,
					0,
					0
				},
				edge_height = var_10_1,
				area_size = {
					var_0_7.level_spacing[1] * var_0_7.columns + var_0_7.margin * 2 + var_10_1 * 2,
					200
				},
				texture_size = var_10_0.texture_size,
				texture_sizes = var_10_0.texture_sizes,
				offset = {
					-var_10_1,
					var_10_1,
					0
				}
			}
		},
		offset = arg_10_1
	}
end

local function var_0_14(arg_11_0, arg_11_1)
	return {
		scenegraph_id = "grid_anchor",
		element = {
			passes = {
				{
					style_id = "text_id",
					pass_type = "text",
					text_id = "text_id"
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background_id"
				}
			}
		},
		content = {
			background_id = "rect_masked",
			text_id = arg_11_0
		},
		style = {
			text_id = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_masked",
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					10,
					-10,
					1
				}
			},
			background = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = UISettings.console_start_game_menu_rect_color,
				texture_size = {
					var_0_7.level_spacing[1] * var_0_7.columns + 5,
					25
				},
				offset = {
					0,
					-10,
					0
				}
			}
		},
		offset = arg_11_1
	}
end

local function var_0_15(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	local var_12_0 = "icons_placeholder"
	local var_12_1 = arg_12_0.small_level_image or LevelHelper:get_small_level_image(arg_12_0.level_id)
	local var_12_2 = UIAtlasHelper.has_texture_by_name(var_12_1) and UIAtlasHelper.get_atlas_settings_by_texture_name(var_12_1) or UIAtlasHelper.get_atlas_settings_by_texture_name(var_12_0)
	local var_12_3 = UIFrameSettings.frame_outer_glow_01
	local var_12_4 = var_12_3.texture_sizes.horizontal[2]
	local var_12_5 = math.min(var_0_7.level_size[1], var_0_7.level_size[2])

	return {
		scenegraph_id = "grid_anchor",
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				},
				{
					style_id = "frame",
					texture_id = "frame",
					pass_type = "texture_frame",
					content_check_function = function(arg_13_0, arg_13_1)
						return arg_13_0.index[1] == arg_13_0.selected_index[1] and arg_13_0.index[2] == arg_13_0.selected_index[2]
					end,
					content_change_function = function(arg_14_0, arg_14_1)
						local var_14_0 = Managers.time:time("game")

						arg_14_1.color[1] = 192 + math.sin(var_14_0 * 6) * 63
					end
				},
				{
					texture_id = "gold_lock",
					style_id = "gold_lock",
					pass_type = "texture",
					content_check_function = function(arg_15_0)
						return arg_15_0.show_gold_lock
					end
				},
				{
					texture_id = "forbidden",
					style_id = "forbidden",
					pass_type = "texture",
					content_check_function = function(arg_16_0)
						return arg_16_0.show_forbidden
					end
				}
			}
		},
		content = {
			gold_lock = "hero_icon_locked_gold",
			forbidden = "hero_icon_unavailable",
			selection_id = "rect_masked",
			fade_id = "text_gradient",
			button_hotspot = {
				disable_button = arg_12_4
			},
			texture_id = var_12_2.texture_name,
			level_settings = arg_12_0,
			index = arg_12_3,
			selected_index = arg_12_2,
			frame = var_12_3.texture,
			is_disabled = arg_12_4,
			show_gold_lock = arg_12_4 and arg_12_5 == "dlc",
			show_forbidden = arg_12_4 and arg_12_5 ~= "dlc"
		},
		style = {
			button_hotspot = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				area_size = var_0_7.level_size,
				offset = {
					10,
					-10,
					2
				}
			},
			texture_id = {
				vertical_alignment = "top",
				masked = true,
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = var_0_7.level_size,
				saturated = arg_12_4,
				offset = {
					10,
					-10,
					2
				}
			},
			frame = {
				horizontal_alignment = "left",
				masked = true,
				vertical_alignment = "top",
				color = {
					255,
					255,
					255,
					255
				},
				edge_height = var_12_4,
				area_size = {
					math.ceil(var_0_7.level_size[1] + var_12_4 * 2),
					var_0_7.level_size[2] + var_12_4 * 2
				},
				texture_size = var_12_3.texture_size,
				texture_sizes = var_12_3.texture_sizes,
				offset = {
					-4,
					4,
					4
				}
			},
			gold_lock = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				offset = {
					38,
					-10,
					4
				},
				texture_size = {
					var_12_5 * 0.8735632183908046,
					var_12_5
				}
			},
			forbidden = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				offset = {
					35,
					-10,
					4
				},
				texture_size = {
					var_12_5,
					var_12_5
				}
			}
		},
		offset = arg_12_1
	}
end

local function var_0_16(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1
	local var_17_1 = {
		180,
		180
	}

	if not var_17_0 then
		var_17_0 = "level_root_" .. arg_17_0
		var_0_6[var_17_0] = {
			vertical_alignment = "center",
			parent = "level_root_node",
			horizontal_alignment = "center",
			size = var_17_1,
			position = {
				0,
				0,
				1
			}
		}
	end

	local var_17_2 = {
		element = {}
	}
	local var_17_3 = {
		{
			style_id = "icon",
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function(arg_18_0)
				return not arg_18_0.parent.locked
			end
		},
		{
			style_id = "icon",
			pass_type = "level_tooltip",
			level_id = "level_data",
			content_check_function = function(arg_19_0)
				return arg_19_0.button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_glow",
			texture_id = "icon_glow"
		},
		{
			pass_type = "texture",
			style_id = "icon_unlock_guidance_glow",
			texture_id = "icon_unlock_guidance_glow"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function(arg_20_0)
				return not arg_20_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_locked",
			texture_id = "icon",
			content_check_function = function(arg_21_0)
				return arg_21_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function(arg_22_0)
				return arg_22_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock_fade",
			texture_id = "lock_fade",
			content_check_function = function(arg_23_0)
				return arg_23_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "glass",
			texture_id = "glass"
		},
		{
			pass_type = "texture",
			style_id = "boss_icon",
			texture_id = "boss_icon",
			content_check_function = function(arg_24_0)
				return arg_24_0.boss_level
			end
		}
	}
	local var_17_4 = {
		lock = "map_frame_lock",
		locked = true,
		lock_fade = "map_frame_fade",
		draw_path = false,
		frame = "map_frame_00",
		draw_path_fill = false,
		icon_unlock_guidance_glow = "map_frame_glow_03",
		boss_level = true,
		glass = "act_presentation_fg_glass",
		boss_icon = "boss_icon",
		icon = "level_icon_01",
		icon_glow = "map_frame_glow_02",
		button_hotspot = {}
	}
	local var_17_5 = {
		glass = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				216,
				216
			},
			offset = {
				0,
				0,
				7
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				180,
				180
			},
			offset = {
				0,
				0,
				6
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				180,
				180
			},
			offset = {
				0,
				0,
				9
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock_fade = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				180,
				180
			},
			offset = {
				0,
				0,
				5
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				168,
				168
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
				3
			}
		},
		icon_locked = {
			vertical_alignment = "center",
			saturated = true,
			horizontal_alignment = "center",
			texture_size = {
				168,
				168
			},
			color = {
				255,
				100,
				100,
				100
			},
			offset = {
				0,
				0,
				3
			}
		},
		icon_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				270,
				270
			},
			offset = {
				0,
				0,
				4
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		icon_unlock_guidance_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				180,
				180
			},
			offset = {
				0,
				0,
				7
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		boss_icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				68,
				68
			},
			offset = {
				0,
				-60,
				8
			},
			color = {
				255,
				255,
				255,
				255
			}
		}
	}

	var_17_2.element.passes = var_17_3
	var_17_2.content = var_17_4
	var_17_2.style = var_17_5
	var_17_2.offset = {
		0,
		0,
		0
	}
	var_17_2.scenegraph_id = var_17_0

	return var_17_2
end

local function var_0_17(arg_25_0)
	return {
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "background"
				},
				{
					pass_type = "rect",
					style_id = "inner_rect"
				},
				{
					pass_type = "rect",
					style_id = "scroller"
				}
			}
		},
		content = {},
		style = {
			background = {
				color = {
					255,
					5,
					5,
					5
				}
			},
			inner_rect = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					15,
					15,
					15
				},
				offset = {
					3,
					-3,
					1
				},
				texture_size = {
					var_0_6[arg_25_0].size[1] - 6,
					var_0_6[arg_25_0].size[2] - 6
				}
			},
			scroller = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					50,
					50,
					50
				},
				offset = {
					3,
					-3,
					2
				},
				texture_size = {
					var_0_6[arg_25_0].size[1] - 6,
					94
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_25_0
	}
end

local var_0_18 = {
	create_area_entry = var_0_13,
	create_act_entry = var_0_14,
	create_level_entry = var_0_15
}
local var_0_19 = {
	background = UIWidgets.create_rect_with_outer_frame("background", var_0_6.background.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	mask = UIWidgets.create_simple_texture("mask_rect", "mask"),
	scroller = var_0_17("scroller"),
	level_title = UIWidgets.create_simple_text("", "level_title", nil, nil, var_0_9),
	selected_level = var_0_16(nil, "level_texture_frame"),
	level_title_divider = UIWidgets.create_simple_texture("divider_01_top", "level_title_divider"),
	description_text = UIWidgets.create_simple_text("", "description_text", nil, nil, var_0_8),
	helper_text = UIWidgets.create_simple_text(Localize("tutorial_map"), "helper_text", nil, nil, var_0_10),
	description_background = UIWidgets.create_rect_with_outer_frame("info_window", var_0_6.info_window.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	locked_text = UIWidgets.create_simple_text("", "locked_text", nil, nil, var_0_11)
}

return {
	widgets = var_0_19,
	widget_functions = var_0_18,
	grid_settings = var_0_7,
	scenegraph_definition = var_0_6,
	animation_definitions = var_0_12
}
