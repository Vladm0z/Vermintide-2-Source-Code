-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_mission_selection_console_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = var_0_0.spacing
local var_0_4 = UIFrameSettings[var_0_1].texture_sizes.vertical[1]
local var_0_5 = var_0_2[1] - (var_0_4 * 2 + 60)
local var_0_6 = {
	var_0_2[1] * 2 + var_0_3,
	var_0_2[2]
}
local var_0_7 = {
	var_0_2[1],
	var_0_2[2] + 50
}
local var_0_8 = UISettings.console_menu_scenegraphs
local var_0_9 = true
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
				arg_5_0.info_window.local_position[1] = arg_5_1.info_window.position[1] + 200 * (1 - var_5_0)
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
				local var_8_0 = math.easeOutCubic(arg_8_3)

				arg_8_4.render_settings.alpha_multiplier = 1 - var_8_0
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		}
	}
}
local var_0_11 = {
	screen = var_0_8.screen,
	area = var_0_8.area,
	area_left = var_0_8.area_left,
	area_right = var_0_8.area_right,
	area_divider = var_0_8.area_divider,
	window = {
		vertical_alignment = "center",
		parent = "area_left",
		horizontal_alignment = "left",
		size = var_0_6,
		position = {
			100,
			0,
			1
		}
	},
	window_background = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_6[1],
			770
		},
		position = {
			0,
			0,
			0
		}
	},
	info_window = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = var_0_7,
		position = {
			var_0_7[1] - 25,
			0,
			1
		}
	},
	act_root_node = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			var_0_6[1] - 256,
			256
		},
		position = {
			0,
			0,
			1
		}
	},
	end_act_root_node = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			261,
			768
		},
		position = {
			0,
			0,
			1
		}
	},
	level_root_node = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			210,
			-100,
			10
		}
	},
	end_level_root_node = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			90,
			-24,
			10
		}
	},
	act_text_root_node = {
		vertical_alignment = "center",
		parent = "level_root_node",
		horizontal_alignment = "center",
		size = {
			100,
			50
		},
		position = {
			-150,
			0,
			10
		}
	},
	title_divider = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_6[1],
			0
		},
		position = {
			0,
			768,
			14
		}
	},
	mission_selection_title = {
		vertical_alignment = "bottom",
		parent = "title_divider",
		horizontal_alignment = "center",
		size = {
			var_0_6[1],
			52
		},
		position = {
			0,
			0,
			1
		}
	},
	locked_text = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			100
		},
		position = {
			0,
			40,
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
			-20,
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
	},
	description_text = {
		vertical_alignment = "top",
		parent = "level_title_divider",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			200
		},
		position = {
			0,
			-20,
			1
		}
	},
	progression_divider = {
		vertical_alignment = "bottom",
		parent = "description_text",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-50,
			1
		}
	},
	loot_objective = {
		vertical_alignment = "top",
		parent = "progression_divider",
		horizontal_alignment = "center",
		size = {
			var_0_5,
			90
		},
		position = {
			-25,
			-150,
			1
		}
	},
	hero_tabs = {
		vertical_alignment = "top",
		parent = "loot_objective",
		horizontal_alignment = "center",
		size = {
			0,
			90
		},
		position = {
			25,
			-135,
			1
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
	}
}
local var_0_12 = {
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
local var_0_13 = {
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
local var_0_14 = {
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
local var_0_15 = {
	use_shadow = true,
	vertical_alignment = "top",
	localize = false,
	horizontal_alignment = "center",
	font_size = 22,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		30,
		10
	}
}
local var_0_16 = {
	font_size = 22,
	horizontal_alignment = "center",
	localize = false,
	word_wrap = true,
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

local function var_0_17(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1
	local var_10_1 = {
		180,
		180
	}

	if not var_10_0 then
		var_10_0 = "level_root_" .. arg_10_0
		var_0_11[var_10_0] = {
			vertical_alignment = "center",
			parent = "level_root_node",
			horizontal_alignment = "center",
			size = var_10_1,
			position = {
				0,
				0,
				1
			}
		}
	end

	local var_10_2 = {
		element = {}
	}
	local var_10_3 = {
		{
			style_id = "icon",
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function(arg_11_0)
				return not arg_11_0.parent.locked
			end
		},
		{
			style_id = "icon",
			pass_type = "level_tooltip",
			level_id = "level_data",
			content_check_function = function(arg_12_0)
				return arg_12_0.button_hotspot.is_hover
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
			content_check_function = function(arg_13_0)
				return not arg_13_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_locked",
			texture_id = "icon",
			content_check_function = function(arg_14_0)
				return arg_14_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function(arg_15_0)
				return arg_15_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock_fade",
			texture_id = "lock_fade",
			content_check_function = function(arg_16_0)
				return arg_16_0.locked
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
			content_check_function = function(arg_17_0)
				return arg_17_0.boss_level
			end
		}
	}
	local var_10_4 = {
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
	local var_10_5 = {
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

	var_10_2.element.passes = var_10_3
	var_10_2.content = var_10_4
	var_10_2.style = var_10_5
	var_10_2.offset = {
		0,
		0,
		0
	}
	var_10_2.scenegraph_id = var_10_0

	return var_10_2
end

local function var_0_18(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_1 or "09"
	local var_18_1 = "act_text_root_node"
	local var_18_2 = var_0_11[var_18_1].size
	local var_18_3 = arg_18_0 > 1
	local var_18_4 = {
		element = {}
	}
	local var_18_5 = {
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text"
		},
		{
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text"
		}
	}
	local var_18_6 = {
		text = "title_text",
		title_edge = "game_option_divider",
		background = "menu_frame_bg_01",
		title_bg = "playername_bg_02",
		draw_divider = var_18_3,
		edge_holder_left = "menu_frame_" .. var_18_0 .. "_divider_left",
		edge_holder_right = "menu_frame_" .. var_18_0 .. "_divider_right",
		bottom_edge = "menu_frame_" .. var_18_0 .. "_divider"
	}
	local var_18_7 = {
		16,
		-3,
		10
	}
	local var_18_8 = {
		text = {
			vertical_alignment = "center",
			upper_case = true,
			localize = false,
			horizontal_alignment = "left",
			font_size = 28,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = var_18_7
		},
		text_shadow = {
			vertical_alignment = "center",
			upper_case = true,
			localize = false,
			horizontal_alignment = "left",
			font_size = 28,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_18_7[1] + 1,
				var_18_7[2] - 1,
				var_18_7[3] - 1
			}
		},
		background = {
			offset = {
				0,
				0,
				0
			},
			color = {
				0,
				100,
				100,
				100
			}
		},
		bottom_edge = {
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				5,
				var_18_2[2] - 4,
				6
			},
			size = {
				var_18_2[1] - 10,
				5
			},
			texture_tiling_size = {
				var_18_2[1] - 10,
				5
			}
		},
		edge_holder_left = {
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				3,
				var_18_2[2] - 10,
				15
			},
			size = {
				9,
				17
			}
		},
		edge_holder_right = {
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				var_18_2[1] - 12,
				var_18_2[2] - 10,
				15
			},
			size = {
				9,
				17
			}
		},
		title_bg = {
			size = {
				var_18_2[1] / 2,
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
				var_18_2[2] - 40,
				2
			}
		},
		title_edge = {
			size = {
				var_18_2[1] / 2,
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
				var_18_2[2] - 40,
				4
			}
		},
		rect = {
			color = {
				100,
				255,
				255,
				0
			}
		}
	}

	var_18_4.element.passes = var_18_5
	var_18_4.content = var_18_6
	var_18_4.style = var_18_8
	var_18_4.offset = {
		0,
		0,
		0
	}
	var_18_4.scenegraph_id = var_18_1

	return var_18_4
end

local function var_0_19(arg_19_0)
	local var_19_0 = arg_19_0 or "09"
	local var_19_1 = "end_act_root_node"
	local var_19_2 = var_0_11[var_19_1].size
	local var_19_3 = {
		element = {}
	}
	local var_19_4 = {}
	local var_19_5 = {
		text = "title_text",
		title_edge = "game_option_divider",
		background = "menu_frame_bg_01",
		title_bg = "playername_bg_02",
		edge_holder_top = "menu_frame_" .. var_19_0 .. "_divider_top",
		edge_holder_bottom = "menu_frame_" .. var_19_0 .. "_divider_bottom",
		edge = "menu_frame_" .. var_19_0 .. "_divider_vertical"
	}
	local var_19_6 = {
		text = {
			vertical_alignment = "top",
			upper_case = true,
			localize = false,
			horizontal_alignment = "left",
			font_size = 28,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				16,
				-5,
				10
			}
		},
		text_shadow = {
			vertical_alignment = "top",
			upper_case = true,
			localize = false,
			horizontal_alignment = "left",
			font_size = 28,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				18,
				-7,
				9
			}
		},
		background = {
			offset = {
				0,
				0,
				0
			},
			color = {
				0,
				100,
				100,
				100
			}
		},
		edge = {
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				6,
				6
			},
			size = {
				5,
				var_19_2[2] - 9
			},
			texture_tiling_size = {
				5,
				var_19_2[2] - 9
			}
		},
		edge_holder_top = {
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				-6,
				var_19_2[2] - 7,
				20
			},
			size = {
				17,
				9
			}
		},
		edge_holder_bottom = {
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				-6,
				3,
				10
			},
			size = {
				17,
				9
			}
		},
		title_bg = {
			size = {
				var_19_2[1] / 2,
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
				var_19_2[2] - 40,
				2
			}
		},
		title_edge = {
			size = {
				var_19_2[1] / 2,
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
				var_19_2[2] - 40,
				4
			}
		}
	}

	var_19_3.element.passes = var_19_4
	var_19_3.content = var_19_5
	var_19_3.style = var_19_6
	var_19_3.offset = {
		0,
		0,
		0
	}
	var_19_3.scenegraph_id = var_19_1

	return var_19_3
end

local function var_0_20(arg_20_0, arg_20_1)
	local var_20_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_20_0).size

	return {
		scenegraph_id = "loot_objective",
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "counter_text",
					pass_type = "text",
					text_id = "counter_text"
				},
				{
					style_id = "counter_text_shadow",
					pass_type = "text",
					text_id = "counter_text"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "background_icon",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "glow_icon",
					texture_id = "glow_icon",
					content_check_function = function(arg_21_0, arg_21_1)
						return not arg_21_0.disable_glow
					end
				},
				{
					pass_type = "texture",
					style_id = "checkmark",
					texture_id = "checkmark",
					content_check_function = function(arg_22_0, arg_22_1)
						return arg_22_0.amount >= arg_22_0.total_amount
					end
				}
			}
		},
		content = {
			total_amount = 0,
			counter_text = "0/0",
			checkmark = "matchmaking_checkbox",
			amount = 0,
			text = arg_20_1 or "n/a",
			icon = arg_20_0,
			glow_icon = arg_20_0 .. "_glow"
		},
		style = {
			text = {
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				horizontal_alignment = "left",
				dynamic_font_size = false,
				font_size = 32,
				area_size = {
					150,
					300
				},
				text_color = Colors.get_table("font_title"),
				offset = {
					var_20_0[1] + 15,
					var_20_0[2] - 50,
					1
				}
			},
			text_shadow = {
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				horizontal_alignment = "left",
				dynamic_font_size = false,
				font_size = 32,
				area_size = {
					150,
					300
				},
				text_color = Colors.get_table("black"),
				offset = {
					var_20_0[1] + 15 + 1,
					var_20_0[2] - 50 - 1,
					0
				}
			},
			counter_text = {
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				font_size = 32,
				horizontal_alignment = "left",
				text_color = Colors.get_table("font_default"),
				default_color = Colors.get_table("font_default"),
				completed_color = Colors.get_table("online_green"),
				offset = {
					var_20_0[1] + 15,
					-40,
					10
				}
			},
			counter_text_shadow = {
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				font_size = 32,
				horizontal_alignment = "left",
				text_color = Colors.get_table("black"),
				offset = {
					var_20_0[1] + 15 + 1,
					-41,
					0
				}
			},
			icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				},
				texture_size = var_20_0
			},
			checkmark = {
				vertical_alignment = "left",
				horizontal_alignment = "bottom",
				color = Colors.get_table("online_green"),
				offset = {
					68,
					20,
					5
				},
				texture_size = {
					27.75,
					23.25
				}
			},
			background_icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
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
				},
				texture_size = var_20_0
			},
			glow_icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
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
				},
				texture_size = var_20_0
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_21(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = {
		80,
		90
	}

	return {
		scenegraph_id = "loot_objective",
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "difficulty_text",
					pass_type = "text",
					text_id = "difficulty_text",
					content_check_function = function(arg_24_0, arg_24_1)
						return arg_24_0.completed_difficulty_index < 4
					end
				},
				{
					style_id = "difficulty_text_completed",
					pass_type = "text",
					text_id = "difficulty_text",
					content_check_function = function(arg_25_0, arg_25_1)
						return arg_25_0.completed_difficulty_index >= 4
					end
				},
				{
					style_id = "difficulty_text",
					pass_type = "text",
					text_id = "difficulty_text"
				},
				{
					style_id = "difficulty_text_disabled",
					pass_type = "text",
					text_id = "difficulty_text"
				},
				{
					style_id = "difficulty_text_shadow",
					pass_type = "text",
					text_id = "difficulty_text"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "background_icon",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "checkmark",
					texture_id = "checkmark",
					content_check_function = function(arg_26_0, arg_26_1)
						return arg_26_0.completed_difficulty_index >= 4
					end
				}
			}
		},
		content = {
			completed_difficulty_index = 0,
			checkmark = "matchmaking_checkbox",
			difficulty_text = Localize(arg_23_2),
			text = arg_23_1,
			icon = arg_23_0
		},
		style = {
			text = {
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				horizontal_alignment = "left",
				dynamic_font_size = false,
				font_size = 32,
				area_size = {
					150,
					300
				},
				text_color = Colors.get_table("font_title"),
				offset = {
					var_23_0[1] + 15,
					var_23_0[2] - 50,
					1
				}
			},
			text_shadow = {
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				horizontal_alignment = "left",
				dynamic_font_size = false,
				font_size = 32,
				area_size = {
					150,
					300
				},
				text_color = Colors.get_table("black"),
				offset = {
					var_23_0[1] + 15 + 1,
					var_23_0[2] - 50 - 1,
					0
				}
			},
			difficulty_text = {
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				font_size = 32,
				horizontal_alignment = "left",
				text_color = Colors.get_table("font_default"),
				offset = {
					var_23_0[1] + 15,
					-40,
					1
				}
			},
			difficulty_text_completed = {
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				font_size = 32,
				horizontal_alignment = "left",
				text_color = Colors.get_table("online_green"),
				offset = {
					var_23_0[1] + 15,
					-40,
					2
				}
			},
			difficulty_text_disabled = {
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				font_size = 32,
				horizontal_alignment = "left",
				text_color = {
					255,
					130,
					130,
					130
				},
				offset = {
					var_23_0[1] + 15,
					-40,
					1
				}
			},
			difficulty_text_shadow = {
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				font_size = 32,
				horizontal_alignment = "left",
				text_color = Colors.get_table("black"),
				offset = {
					var_23_0[1] + 15 + 1,
					-41,
					0
				}
			},
			icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				},
				texture_size = var_23_0
			},
			background_icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
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
				},
				texture_size = var_23_0
			},
			checkmark = {
				vertical_alignment = "left",
				horizontal_alignment = "bottom",
				color = Colors.get_table("online_green"),
				offset = {
					68,
					20,
					5
				},
				texture_size = {
					27.75,
					23.25
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

function create_simple_texture(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7)
	if type(arg_27_5) ~= "table" then
		arg_27_5 = {
			0,
			0,
			arg_27_5 or 0
		}
	end

	if arg_27_6 == "native" then
		local var_27_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_27_0).size

		arg_27_6 = {
			var_27_0[1],
			var_27_0[2]
		}
	end

	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					retained_mode = arg_27_3
				}
			}
		},
		content = {
			texture_id = arg_27_0,
			disable_with_gamepad = arg_27_7
		},
		style = {
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = arg_27_4 or {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				},
				masked = arg_27_2,
				texture_size = arg_27_6
			}
		},
		offset = arg_27_5,
		scenegraph_id = arg_27_1
	}
end

function create_hero_widgets(arg_28_0)
	local var_28_0 = {
		75.60000000000001,
		97.2
	}
	local var_28_1 = {
		90,
		90
	}
	local var_28_2 = {}

	for iter_28_0 = 1, #ProfilePriority do
		local var_28_3 = ProfilePriority[iter_28_0]
		local var_28_4 = SPProfiles[var_28_3].careers[1]

		var_28_2[#var_28_2 + 1] = var_28_4.picking_image
	end

	local var_28_5 = 0.75
	local var_28_6 = 96 * var_28_5
	local var_28_7 = 112 * var_28_5
	local var_28_8 = 25 * var_28_5, {
		86 * var_28_5,
		108 * var_28_5
	}
	local var_28_9 = {
		255,
		255,
		255,
		255
	}
	local var_28_10 = Colors.get_color_table_with_alpha("font_title", 255)
	local var_28_11 = #var_28_2
	local var_28_12 = {
		element = {}
	}
	local var_28_13 = {}
	local var_28_14 = {}
	local var_28_15 = {}
	local var_28_16 = var_28_8 or 0
	local var_28_17 = 0
	local var_28_18 = -var_28_16
	local var_28_19 = 0
	local var_28_20 = UIPlayerPortraitFrameSettings.default

	for iter_28_1 = 1, var_28_11 do
		local var_28_21 = "_" .. tostring(iter_28_1)
		local var_28_22 = iter_28_1 - 1

		var_28_18 = var_28_18 + var_28_0[1] + var_28_16

		local var_28_23 = {
			var_28_19,
			0,
			var_28_17
		}
		local var_28_24 = "icon_data" .. var_28_21

		var_28_14[var_28_24] = {}

		local var_28_25 = var_28_14[var_28_24]
		local var_28_26 = var_28_2[iter_28_1]
		local var_28_27 = "icon" .. var_28_21

		var_28_13[#var_28_13 + 1] = {
			pass_type = "texture",
			content_id = var_28_24,
			texture_id = var_28_27,
			style_id = var_28_27,
			content_check_function = function(arg_29_0)
				return not arg_29_0.icon_disabled
			end
		}
		var_28_15[var_28_27] = {
			masked = true,
			size = var_28_0,
			color = var_28_9,
			offset = {
				var_28_23[1],
				var_28_23[2],
				var_28_23[3] + 2
			}
		}
		var_28_25[var_28_27] = var_28_26

		local var_28_28 = var_28_2[iter_28_1]
		local var_28_29 = "icon" .. var_28_21 .. "_disabled"

		var_28_13[#var_28_13 + 1] = {
			pass_type = "texture",
			content_id = var_28_24,
			texture_id = var_28_29,
			style_id = var_28_29,
			content_check_function = function(arg_30_0)
				return arg_30_0.icon_disabled
			end
		}
		var_28_15[var_28_29] = {
			saturated = true,
			masked = true,
			size = var_28_0,
			color = var_28_9,
			default_color = var_28_9,
			disabled_color = {
				255,
				60,
				60,
				60
			},
			offset = {
				var_28_23[1],
				var_28_23[2],
				var_28_23[3] + 2
			}
		}
		var_28_25[var_28_29] = var_28_28

		local var_28_30 = "frame" .. var_28_21

		var_28_13[#var_28_13 + 1] = {
			pass_type = "texture",
			content_id = var_28_24,
			texture_id = var_28_30,
			style_id = var_28_30
		}
		var_28_15[var_28_30] = {
			size = {
				var_28_1[1],
				var_28_1[2]
			},
			color = var_28_9,
			offset = {
				var_28_23[1] + var_28_0[1] / 2 - var_28_1[1] / 2,
				var_28_23[2] + var_28_0[2] / 2 - var_28_1[2] / 2,
				var_28_23[3] + 3
			}
		}
		var_28_25[var_28_30] = "map_frame_00"

		local var_28_31 = "frame" .. var_28_21 .. "_mask"

		var_28_13[#var_28_13 + 1] = {
			pass_type = "texture",
			content_id = var_28_24,
			texture_id = var_28_31,
			style_id = var_28_31
		}
		var_28_15[var_28_31] = {
			size = {
				var_28_1[1],
				var_28_1[2]
			},
			color = var_28_9,
			offset = {
				var_28_23[1] + var_28_0[1] / 2 - var_28_1[1] / 2,
				var_28_23[2] + var_28_0[2] / 2 - var_28_1[2] / 2,
				var_28_23[3] + 3
			}
		}
		var_28_25[var_28_31] = "map_frame_mask"
		var_28_19 = var_28_19 + var_28_0[1] + var_28_16
	end

	var_28_12.element.passes = var_28_13
	var_28_12.content = var_28_14
	var_28_12.style = var_28_15
	var_28_12.offset = {
		-var_28_18 / 2,
		-5,
		0
	}
	var_28_12.scenegraph_id = arg_28_0

	return var_28_12
end

local var_0_22 = var_0_19()
local var_0_23 = {
	level_title = UIWidgets.create_simple_text("level_title", "level_title", nil, nil, var_0_13),
	selected_level = var_0_17(nil, "level_texture_frame"),
	description_text = UIWidgets.create_simple_text("", "description_text", nil, nil, var_0_12),
	helper_text = UIWidgets.create_simple_text(Localize("tutorial_map"), "helper_text", nil, nil, var_0_14),
	description_background = UIWidgets.create_rect_with_outer_frame("info_window", var_0_11.info_window.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	locked_text = UIWidgets.create_simple_text("", "locked_text", nil, nil, var_0_16),
	progression_divider = UIWidgets.create_simple_texture("divider_01_top", "progression_divider"),
	heros_completed_text = UIWidgets.create_simple_text(Localize("heroes_completed"), "hero_tabs", nil, nil, var_0_15)
}
local var_0_24 = {}

for iter_0_0 = 1, #ProfilePriority do
	local var_0_25 = ProfilePriority[iter_0_0]
	local var_0_26 = SPProfiles[var_0_25]

	var_0_24[#var_0_24 + 1] = var_0_26.ui_portrait
end

local var_0_27 = 0.75
local var_0_28 = 96 * var_0_27
local var_0_29 = 112 * var_0_27
local var_0_30 = 10 * var_0_27
local var_0_31 = {
	86 * var_0_27,
	108 * var_0_27
}

if var_0_9 then
	var_0_23.hero_tabs = create_hero_widgets("hero_tabs")
else
	var_0_23.hero_tabs = UIWidgets.create_icon_selector("hero_tabs", {
		var_0_28,
		var_0_29
	}, var_0_24, var_0_30, true, var_0_31, true, true)
end

local var_0_32 = {}

for iter_0_1 = 1, 20 do
	var_0_32[iter_0_1] = var_0_17(iter_0_1)
end

local var_0_33 = {}

for iter_0_2 = 1, 5 do
	var_0_33[iter_0_2] = var_0_18(iter_0_2)
end

local var_0_34 = {
	{
		texture = "loot_objective_icon_02",
		key = "tome",
		title_text = "dlc1_3_1_tomes",
		widget_name = "tome_counter",
		stat_name = "collected_tomes"
	},
	{
		texture = "loot_objective_icon_06",
		key = "painting_scrap",
		title_text = "keep_decoration_painting",
		widget_name = "painting_scrap_counter",
		total_amount_func = "_calculate_paint_scrap_amount",
		stat_name = "collected_painting_scraps"
	},
	{
		texture = "loot_objective_icon_01",
		key = "grimoire",
		title_text = "dlc1_3_1_grimoires",
		widget_name = "grimoire_counter",
		stat_name = "collected_grimoires"
	}
}

return {
	widgets = var_0_23,
	act_widgets = var_0_33,
	node_widgets = var_0_32,
	end_act_widget = var_0_22,
	scenegraph_definition = var_0_11,
	animation_definitions = var_0_10,
	large_window_size = var_0_6,
	mission_settings = var_0_34,
	create_loot_widget = var_0_20,
	create_difficulty_widget = var_0_21,
	use_career_completion = var_0_9
}
