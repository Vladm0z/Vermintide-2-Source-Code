-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_list_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local large_window_size = game_start_windows.large_window_size
local var_0_5 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local num = size[1] - (var_0_5 * 2 + 60)
local num_2 = 70
local str = "menu_frame_11"
local var_0_10 = UIFrameSettings[str].texture_sizes.vertical[1]
local tbl = {
	570,
	large_window_size[2] - var_0_10 * 2 - num_2
}
local tbl_2 = {
	size[1],
	tbl[2] - 300
}
local tbl_3 = {
	size[1] - 50,
	64
}
local tbl_4 = {
	16,
	tbl[2] - 150
}
local num_3 = 10
local tbl_5 = {
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
	parent_window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = large_window_size,
		position = {
			0,
			0,
			1
		}
	},
	window = {
		vertical_alignment = "bottom",
		parent = "parent_window",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			var_0_10,
			var_0_10,
			1
		}
	},
	next_weave_bg = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_3[1],
			80
		},
		position = {
			20,
			-30,
			10
		}
	},
	next_window_top = {
		vertical_alignment = "top",
		parent = "next_weave_bg",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			13,
			1
		}
	},
	next_window_bottom = {
		vertical_alignment = "bottom",
		parent = "next_weave_bg",
		horizontal_alignment = "center",
		size = {
			264,
			21
		},
		position = {
			0,
			-1,
			1
		}
	},
	next_weave = {
		vertical_alignment = "center",
		parent = "next_weave_bg",
		horizontal_alignment = "center",
		size = tbl_3,
		position = {
			0,
			-80,
			4
		}
	},
	list_mask = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_2[1],
			tbl_2[2]
		},
		position = {
			20,
			0,
			2
		}
	},
	list_window = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_2[1],
			tbl_2[2]
		},
		position = {
			20,
			0,
			2
		}
	},
	list_window_top_edge = {
		vertical_alignment = "top",
		parent = "list_mask",
		horizontal_alignment = "center",
		size = {
			tbl_2[1],
			20
		},
		position = {
			0,
			0,
			0
		}
	},
	list_window_bottom_edge = {
		vertical_alignment = "bottom",
		parent = "list_mask",
		horizontal_alignment = "center",
		size = {
			tbl_2[1],
			20
		},
		position = {
			0,
			0,
			0
		}
	},
	list_anchor = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "center",
		size = tbl_3,
		position = {
			0,
			0,
			0
		}
	},
	list_scrollbar = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = tbl_4,
		position = {
			20,
			-40,
			3
		}
	},
	unlocked_weaves_title_bg = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "center",
		size = {
			size[1],
			55
		},
		position = {
			0,
			55,
			-1
		}
	},
	unlocked_weaves_bg = {
		vertical_alignment = "bottom",
		parent = "next_weave",
		horizontal_alignment = "center",
		size = {
			tbl_3[1],
			60
		},
		position = {
			0,
			-95,
			2
		}
	},
	unlocked_weaves_top = {
		vertical_alignment = "top",
		parent = "unlocked_weaves_bg",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			13,
			1
		}
	},
	unlocked_weaves_bottom = {
		vertical_alignment = "bottom",
		parent = "unlocked_weaves_bg",
		horizontal_alignment = "center",
		size = {
			264,
			21
		},
		position = {
			0,
			-1,
			1
		}
	},
	top_corner_right = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			12
		}
	},
	bottom_corner_right = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			12
		}
	},
	side_edge = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			45,
			tbl[2]
		},
		position = {
			20,
			0,
			13
		}
	}
}
local tbl_6 = {
	life = Colors.get_color_table_with_alpha("lime_green", 255),
	metal = Colors.get_color_table_with_alpha("yellow", 255),
	death = Colors.get_color_table_with_alpha("dark_magenta", 255),
	heavens = Colors.get_color_table_with_alpha("deep_sky_blue", 255),
	light = Colors.get_color_table_with_alpha("white", 255),
	beasts = Colors.get_color_table_with_alpha("saddle_brown", 255),
	fire = Colors.get_color_table_with_alpha("crimson", 255),
	shadow = Colors.get_color_table_with_alpha("gray", 255)
}

local function fn(self, arg_1_1, arg_1_2)
	-- function 1
	local tbl = {
		255,
		255,
		255,
		255
	}

	arg_1_1 = arg_1_1 or 1

	if not arg_1_2 then
		tbl[1] = self[1]
	end

	tbl[2] = math.floor(self[2] * arg_1_1)
	tbl[3] = math.floor(self[3] * arg_1_1)
	tbl[4] = math.floor(self[4] * arg_1_1)

	return tbl
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local flag = arg_2_4 or "list_anchor"
	local var_2_1 = num_3
	local var_2_2 = arg_2_3
	local tbl = {
		64,
		64
	}
	local var_2_4 = tbl_3
	local str = arg_2_2.tier .. ". " .. Localize(arg_2_2.display_name)
	local level_id = arg_2_2.objectives[1].level_id
	local wind = arg_2_2.wind
	local thumbnail_icon = WindSettings[wind].thumbnail_icon
	local var_2_9 = tbl_6[wind]
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(thumbnail_icon).size
	local display_name = LevelSettings[level_id].display_name
	local var_2_12 = fn(var_2_9)
	local var_2_13 = fn(var_2_9, 0.7)
	local var_2_14 = fn(var_2_9, 0.7)
	local var_2_15 = fn(var_2_9, 0.7)
	local menu_frame_09 = UIFrameSettings.menu_frame_09
	local var_2_17 = menu_frame_09.texture_sizes.horizontal[2]
	local frame_outer_glow_04 = UIFrameSettings.frame_outer_glow_04
	local var_2_19 = frame_outer_glow_04.texture_sizes.horizontal[2]
	local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
	local var_2_21 = frame_outer_glow_01.texture_sizes.horizontal[2]
	local tbl_2 = {
		passes = {
			{
				style_id = "background",
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				pass_type = "tiled_texture",
				style_id = "background",
				texture_id = "background"
			},
			{
				pass_type = "texture",
				style_id = "background_fade",
				texture_id = "background_fade"
			},
			{
				pass_type = "texture",
				style_id = "background_effect",
				texture_id = "background_effect"
			},
			{
				pass_type = "texture_frame",
				style_id = "entry_frame",
				texture_id = "entry_frame"
			},
			{
				pass_type = "texture_frame",
				style_id = "hover_frame",
				texture_id = "hover_frame"
			},
			{
				pass_type = "texture",
				style_id = "symbol_frame",
				texture_id = "symbol_frame"
			},
			{
				pass_type = "texture",
				style_id = "symbol_frame_selected",
				texture_id = "symbol_frame_selected"
			},
			{
				pass_type = "texture",
				style_id = "symbol_frame_selected_glow",
				texture_id = "symbol_frame_selected_glow"
			},
			{
				pass_type = "texture",
				style_id = "symbol_bg",
				texture_id = "symbol_bg"
			},
			{
				pass_type = "texture",
				style_id = "symbol_bg_glow",
				texture_id = "symbol_bg_glow"
			},
			{
				pass_type = "texture",
				style_id = "wind_symbol",
				texture_id = "wind_symbol"
			},
			{
				style_id = "title",
				pass_type = "text",
				text_id = "title"
			},
			{
				style_id = "title_shadow",
				pass_type = "text",
				text_id = "title"
			},
			{
				style_id = "level_name",
				pass_type = "text",
				text_id = "level_name"
			},
			{
				style_id = "level_name_shadow",
				pass_type = "text",
				text_id = "level_name"
			},
			{
				style_id = "new_frame",
				texture_id = "new_frame",
				pass_type = "texture_frame",
				content_check_function = function (self)
					-- function 3
					return self.new
				end,
				content_change_function = function (arg_4_0, arg_4_1)
					-- function 4
					local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

					arg_4_1.color[1] = 55 + num * 200
				end
			},
			{
				pass_type = "texture",
				style_id = "lock_texture",
				texture_id = "lock_texture",
				content_check_function = function (self)
					-- function 5
					return self.locked
				end
			},
			{
				pass_type = "texture",
				style_id = "equipped_texture",
				texture_id = "equipped_texture",
				content_check_function = function (self)
					-- function 6
					return self.equipped
				end
			},
			{
				pass_type = "texture",
				style_id = "new_texture",
				texture_id = "new_texture",
				content_check_function = function (self)
					-- function 7
					return self.new
				end
			}
		}
	}
	local tbl_4 = {
		symbol_frame = "weave_item_icon_border",
		symbol_frame_selected_glow = "weave_item_selected_glow",
		symbol_frame_selected = "weave_item_icon_border_selected",
		new_texture = "list_item_tag_new",
		symbol_bg_glow = "winds_icon_background_glow",
		lock_texture = "achievement_symbol_lock",
		equipped_texture = "matchmaking_checkbox",
		symbol_bg = "weave_item_icon_border_center",
		background_fade = "button_bg_fade",
		background = "button_bg_01",
		template_id = arg_2_1,
		weave_template_name = arg_2_2.name,
		button_hotspot = {},
		title = str,
		level_name = display_name
	}
	local flag_2

	flag_2 = not var_2_2 and "weave_button_passive_glow" and "weave_button_passive_glow_unmasked"
	tbl_4.background_effect = flag_2
	tbl_4.hover_frame = frame_outer_glow_04.texture
	tbl_4.new_frame = frame_outer_glow_01.texture
	tbl_4.entry_frame = menu_frame_09.texture
	tbl_4.wind_symbol = thumbnail_icon

	local num = 0.8
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_button_normal", 255)
	local tbl_5 = {
		255,
		get_color_table_with_alpha[2] * num,
		get_color_table_with_alpha[3] * num,
		get_color_table_with_alpha[4] * num
	}
	local tbl_7 = {
		hotspot = {
			size = {
				var_2_4[1],
				var_2_4[2]
			},
			offset = {
				0,
				0,
				0
			}
		}
	}
	local tbl_8 = {
		word_wrap = false,
		upper_case = false,
		localize = false,
		font_size = 26,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true
	}
	local flag_3

	flag_3 = not var_2_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_8.font_type = flag_3
	tbl_8.text_color = tbl_5
	tbl_8.default_text_color = tbl_5
	tbl_8.select_text_color = get_color_table_with_alpha
	tbl_8.offset = {
		tbl[1] + 10,
		var_2_4[2] / 2 - 5,
		4
	}
	tbl_8.size = {
		var_2_4[1] - (tbl[1] + 20),
		var_2_4[2]
	}
	tbl_7.title = tbl_8

	local tbl_9 = {
		word_wrap = false,
		upper_case = false,
		localize = false,
		font_size = 26,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true
	}
	local flag_4

	flag_4 = not var_2_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_9.font_type = flag_4
	tbl_9.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_9.normal_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_9.offset = {
		tbl[1] + 10 + 2,
		var_2_4[2] / 2 - 7,
		3
	}
	tbl_9.size = {
		var_2_4[1] - (tbl[1] + 20),
		var_2_4[2]
	}
	tbl_7.title_shadow = tbl_9

	local tbl_10 = {
		word_wrap = true,
		font_size = 22,
		localize = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true
	}
	local flag_5

	flag_5 = not var_2_2 and "hell_shark_masked" and "hell_shark"
	tbl_10.font_type = flag_5
	tbl_10.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_10.default_text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_10.select_text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_10.offset = {
		tbl[1] + 10,
		-(var_2_4[2] / 2 + 0),
		4
	}
	tbl_10.size = {
		var_2_4[1] - (tbl[1] + 20),
		var_2_4[2]
	}
	tbl_7.level_name = tbl_10

	local tbl_11 = {
		word_wrap = true,
		font_size = 22,
		localize = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true
	}
	local flag_6

	flag_6 = not var_2_2 and "hell_shark_masked" and "hell_shark"
	tbl_11.font_type = flag_6
	tbl_11.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_11.normal_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_11.offset = {
		tbl[1] + 10 + 2,
		-(var_2_4[2] / 2 + 2),
		3
	}
	tbl_11.size = {
		var_2_4[1] - (tbl[1] + 20),
		var_2_4[2]
	}
	tbl_7.level_name_shadow = tbl_11
	tbl_7.background = {
		masked = var_2_2,
		size = {
			var_2_4[1],
			var_2_4[2]
		},
		color = {
			255,
			255,
			255,
			255
		},
		texture_tiling_size = {
			480,
			270
		},
		offset = {
			0,
			0,
			0
		}
	}
	tbl_7.background_fade = {
		masked = var_2_2,
		size = {
			var_2_4[1],
			var_2_4[2]
		},
		color = {
			200,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			2
		}
	}
	tbl_7.background_effect = {
		masked = var_2_2,
		size = {
			var_2_4[1],
			var_2_4[2]
		},
		color = var_2_14,
		offset = {
			0,
			0,
			1
		}
	}
	tbl_7.hover_frame = {
		masked = var_2_2,
		texture_size = frame_outer_glow_04.texture_size,
		texture_sizes = frame_outer_glow_04.texture_sizes,
		color = {
			0,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			0
		},
		size = {
			var_2_4[1],
			var_2_4[2]
		},
		frame_margins = {
			-var_2_19,
			-var_2_19
		}
	}
	tbl_7.new_frame = {
		masked = var_2_2,
		texture_size = frame_outer_glow_01.texture_size,
		texture_sizes = frame_outer_glow_01.texture_sizes,
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
		size = {
			var_2_4[1],
			var_2_4[2]
		},
		frame_margins = {
			-var_2_21,
			-var_2_21
		}
	}
	tbl_7.entry_frame = {
		masked = var_2_2,
		texture_size = menu_frame_09.texture_size,
		texture_sizes = menu_frame_09.texture_sizes,
		color = {
			255,
			255,
			255,
			255
		},
		size = {
			var_2_4[1],
			var_2_4[2]
		},
		offset = {
			0,
			0,
			3
		}
	}
	tbl_7.lock_texture = {
		masked = var_2_2,
		size = {
			56,
			40
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_2_4[1] - 56,
			var_2_4[2] / 2 - 20,
			2
		}
	}
	tbl_7.equipped_texture = {
		masked = var_2_2,
		size = {
			37,
			31
		},
		color = Colors.get_color_table_with_alpha("green", 255),
		offset = {
			var_2_4[1] - 37,
			var_2_4[2] / 2 - 15.5,
			2
		}
	}
	tbl_7.new_texture = {
		masked = var_2_2,
		size = {
			126,
			51
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			var_2_4[1] - 120,
			var_2_4[2] / 2 - 25.5,
			2
		}
	}
	tbl_7.symbol_frame = {
		masked = var_2_2,
		size = {
			64,
			64
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			var_2_4[2] / 2 - 32,
			5
		}
	}
	tbl_7.symbol_frame_selected = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		masked = var_2_2,
		texture_size = {
			73,
			73
		},
		default_size = {
			73,
			73
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			-4.5,
			0,
			6
		},
		default_offset = {
			-4.5,
			0,
			6
		}
	}
	tbl_7.symbol_frame_selected_glow = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		masked = var_2_2,
		texture_size = {
			73,
			73
		},
		default_size = {
			73,
			73
		},
		color = var_2_15,
		offset = {
			-4.5,
			0,
			6
		},
		default_offset = {
			-4.5,
			0,
			7
		}
	}
	tbl_7.symbol_bg = {
		masked = var_2_2,
		size = {
			64,
			64
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			var_2_4[2] / 2 - 32,
			8
		}
	}
	tbl_7.symbol_bg_glow = {
		masked = var_2_2,
		size = {
			51,
			53
		},
		color = var_2_12,
		offset = {
			7,
			var_2_4[2] / 2 - 26.5,
			9
		}
	}
	tbl_7.wind_symbol = {
		masked = var_2_2,
		size = {
			size[1],
			size[2]
		},
		color = var_2_12,
		offset = {
			32 - size[1] / 2,
			32 - size[2] / 2,
			10
		}
	}

	return {
		element = tbl_2,
		content = tbl_4,
		style = tbl_7,
		offset = {
			0,
			-(arg_2_0 - 1) * tbl_3[2] - arg_2_0 * var_2_1,
			0
		},
		scenegraph_id = flag
	}
end

local function fn_3(arg_8_0)
	-- function 8
	local size = tbl_5[arg_8_0].size

	return {
		element = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot"
				}
			}
		},
		content = {
			hotspot = {}
		},
		style = {
			hotspot = {
				color = {
					128,
					255,
					255,
					255
				},
				size = {
					size[1],
					size[2]
				},
				offset = {
					0,
					0,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_8_0
	}
end

local tbl_7 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		24,
		2
	}
}
local tbl_8 = {
	font_size = 32,
	use_shadow = true,
	localize = false,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_9 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		-48,
		2
	}
}
local tbl_10 = {
	mask_top_edge = UIWidgets.create_simple_uv_texture("mask_rect_edge_fade", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "list_window_top_edge"),
	mask_bottom_edge = UIWidgets.create_simple_uv_texture("mask_rect_edge_fade", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "list_window_bottom_edge"),
	mask = UIWidgets.create_simple_texture("mask_rect", "list_mask"),
	list_hotspot = fn_3("list_window"),
	list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "list_window", tbl_5.list_scrollbar.size),
	background_fade = UIWidgets.create_rect_with_outer_frame("window", tbl_5.window.size, "shadow_frame_02", nil, {
		100,
		0,
		0,
		0
	}, {
		255,
		0,
		0,
		0
	}),
	next_window_top = UIWidgets.create_simple_texture("divider_01_top", "next_window_top"),
	next_window_bottom = UIWidgets.create_simple_texture("divider_01_bottom", "next_window_bottom"),
	next_weave_bg = UIWidgets.create_simple_texture("hud_difficulty_unlocked_bg_fade", "next_weave_bg"),
	next_weaves_title = UIWidgets.create_simple_text(Localize("menu_weave_play_next_weave"), "next_weave_bg", nil, nil, tbl_7),
	next_weave_description = UIWidgets.create_simple_text(Localize("menu_weave_play_complete_to_unlock"), "next_weave_bg", nil, nil, tbl_9),
	unlocked_weaves_top = UIWidgets.create_simple_texture("divider_01_top", "unlocked_weaves_top"),
	unlocked_weaves_bottom = UIWidgets.create_simple_texture("divider_01_bottom", "unlocked_weaves_bottom"),
	unlocked_weaves_bg = UIWidgets.create_simple_texture("hud_difficulty_unlocked_bg_fade", "unlocked_weaves_bg"),
	unlocked_weaves_title = UIWidgets.create_simple_text(Localize("menu_weave_play_completed_weaves"), "unlocked_weaves_bg", nil, nil, tbl_8)
}
local tbl_11 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				arg_9_2.background_fade.alpha_multiplier = 0
			end,
			update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				-- function 10
				local easeInCubic = math.easeInCubic(arg_10_3)

				arg_10_2.background_fade.alpha_multiplier = easeInCubic
			end,
			on_complete = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				return
			end
		},
		{
			name = "fade_in_2",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				arg_12_3.render_settings.alpha_multiplier = 0
				arg_12_0.list_window.position[1] = arg_12_1.list_window.position[1]
			end,
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				-- function 13
				local easeInCubic = math.easeInCubic(arg_13_3)

				arg_13_4.render_settings.alpha_multiplier = easeInCubic
				arg_13_0.list_window.position[1] = arg_13_1.list_window.position[1] + (1 - easeInCubic) * 30
			end,
			on_complete = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				arg_15_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				-- function 16
				local easeOutCubic = math.easeOutCubic(arg_16_3)

				arg_16_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				return
			end
		}
	}
}

return {
	num_visible_weave_entries = 9,
	entry_size = tbl_3,
	entry_spacing = num_3,
	widgets = tbl_10,
	create_weave_entry_func = fn_2,
	scenegraph_definition = tbl_5,
	animation_definitions = tbl_11
}
