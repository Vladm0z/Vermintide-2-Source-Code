-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_list_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = var_0_0.large_window_size
local var_0_5 = UIFrameSettings[var_0_2].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[var_0_2].texture_sizes.horizontal[2]
local var_0_7 = var_0_3[1] - (var_0_5 * 2 + 60)
local var_0_8 = 70
local var_0_9 = "menu_frame_11"
local var_0_10 = UIFrameSettings[var_0_9].texture_sizes.vertical[1]
local var_0_11 = {
	570,
	var_0_4[2] - var_0_10 * 2 - var_0_8
}
local var_0_12 = {
	var_0_3[1],
	var_0_11[2] - 300
}
local var_0_13 = {
	var_0_3[1] - 50,
	64
}
local var_0_14 = {
	16,
	var_0_11[2] - 150
}
local var_0_15 = 10
local var_0_16 = {
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
		size = var_0_4,
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
		size = var_0_11,
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
			var_0_13[1],
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
		size = var_0_13,
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
			var_0_12[1],
			var_0_12[2]
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
			var_0_12[1],
			var_0_12[2]
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
			var_0_12[1],
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
			var_0_12[1],
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
		size = var_0_13,
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
		size = var_0_14,
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
			var_0_3[1],
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
			var_0_13[1],
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
			var_0_11[2]
		},
		position = {
			20,
			0,
			13
		}
	}
}
local var_0_17 = {
	life = Colors.get_color_table_with_alpha("lime_green", 255),
	metal = Colors.get_color_table_with_alpha("yellow", 255),
	death = Colors.get_color_table_with_alpha("dark_magenta", 255),
	heavens = Colors.get_color_table_with_alpha("deep_sky_blue", 255),
	light = Colors.get_color_table_with_alpha("white", 255),
	beasts = Colors.get_color_table_with_alpha("saddle_brown", 255),
	fire = Colors.get_color_table_with_alpha("crimson", 255),
	shadow = Colors.get_color_table_with_alpha("gray", 255)
}

local function var_0_18(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = {
		255,
		255,
		255,
		255
	}

	arg_1_1 = arg_1_1 or 1

	if arg_1_2 then
		var_1_0[1] = arg_1_0[1]
	end

	var_1_0[2] = math.floor(arg_1_0[2] * arg_1_1)
	var_1_0[3] = math.floor(arg_1_0[3] * arg_1_1)
	var_1_0[4] = math.floor(arg_1_0[4] * arg_1_1)

	return var_1_0
end

local function var_0_19(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_4 or "list_anchor"
	local var_2_1 = var_0_15
	local var_2_2 = arg_2_3
	local var_2_3 = {
		64,
		64
	}
	local var_2_4 = var_0_13
	local var_2_5 = arg_2_2.tier .. ". " .. Localize(arg_2_2.display_name)
	local var_2_6 = arg_2_2.objectives[1].level_id
	local var_2_7 = arg_2_2.wind
	local var_2_8 = WindSettings[var_2_7].thumbnail_icon
	local var_2_9 = var_0_17[var_2_7]
	local var_2_10 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_2_8).size
	local var_2_11 = LevelSettings[var_2_6].display_name
	local var_2_12 = var_0_18(var_2_9)
	local var_2_13 = var_0_18(var_2_9, 0.7)
	local var_2_14 = var_0_18(var_2_9, 0.7)
	local var_2_15 = var_0_18(var_2_9, 0.7)
	local var_2_16 = UIFrameSettings.menu_frame_09
	local var_2_17 = var_2_16.texture_sizes.horizontal[2]
	local var_2_18 = UIFrameSettings.frame_outer_glow_04
	local var_2_19 = var_2_18.texture_sizes.horizontal[2]
	local var_2_20 = UIFrameSettings.frame_outer_glow_01
	local var_2_21 = var_2_20.texture_sizes.horizontal[2]
	local var_2_22 = {
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
				content_check_function = function (arg_3_0)
					return arg_3_0.new
				end,
				content_change_function = function (arg_4_0, arg_4_1)
					local var_4_0 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

					arg_4_1.color[1] = 55 + var_4_0 * 200
				end
			},
			{
				pass_type = "texture",
				style_id = "lock_texture",
				texture_id = "lock_texture",
				content_check_function = function (arg_5_0)
					return arg_5_0.locked
				end
			},
			{
				pass_type = "texture",
				style_id = "equipped_texture",
				texture_id = "equipped_texture",
				content_check_function = function (arg_6_0)
					return arg_6_0.equipped
				end
			},
			{
				pass_type = "texture",
				style_id = "new_texture",
				texture_id = "new_texture",
				content_check_function = function (arg_7_0)
					return arg_7_0.new
				end
			}
		}
	}
	local var_2_23 = {
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
		title = var_2_5,
		level_name = var_2_11,
		background_effect = var_2_2 and "weave_button_passive_glow" or "weave_button_passive_glow_unmasked",
		hover_frame = var_2_18.texture,
		new_frame = var_2_20.texture,
		entry_frame = var_2_16.texture,
		wind_symbol = var_2_8
	}
	local var_2_24 = 0.8
	local var_2_25 = Colors.get_color_table_with_alpha("font_button_normal", 255)
	local var_2_26 = {
		255,
		var_2_25[2] * var_2_24,
		var_2_25[3] * var_2_24,
		var_2_25[4] * var_2_24
	}
	local var_2_27 = {
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
		},
		title = {
			word_wrap = false,
			upper_case = false,
			localize = false,
			font_size = 26,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			dynamic_font_size = true,
			font_type = var_2_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = var_2_26,
			default_text_color = var_2_26,
			select_text_color = var_2_25,
			offset = {
				var_2_3[1] + 10,
				var_2_4[2] / 2 - 5,
				4
			},
			size = {
				var_2_4[1] - (var_2_3[1] + 20),
				var_2_4[2]
			}
		},
		title_shadow = {
			word_wrap = false,
			upper_case = false,
			localize = false,
			font_size = 26,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			dynamic_font_size = true,
			font_type = var_2_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			normal_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_2_3[1] + 10 + 2,
				var_2_4[2] / 2 - 7,
				3
			},
			size = {
				var_2_4[1] - (var_2_3[1] + 20),
				var_2_4[2]
			}
		},
		level_name = {
			word_wrap = true,
			font_size = 22,
			localize = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = var_2_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				var_2_3[1] + 10,
				-(var_2_4[2] / 2 + 0),
				4
			},
			size = {
				var_2_4[1] - (var_2_3[1] + 20),
				var_2_4[2]
			}
		},
		level_name_shadow = {
			word_wrap = true,
			font_size = 22,
			localize = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = var_2_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			normal_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_2_3[1] + 10 + 2,
				-(var_2_4[2] / 2 + 2),
				3
			},
			size = {
				var_2_4[1] - (var_2_3[1] + 20),
				var_2_4[2]
			}
		},
		background = {
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
		},
		background_fade = {
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
		},
		background_effect = {
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
		},
		hover_frame = {
			masked = var_2_2,
			texture_size = var_2_18.texture_size,
			texture_sizes = var_2_18.texture_sizes,
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
		},
		new_frame = {
			masked = var_2_2,
			texture_size = var_2_20.texture_size,
			texture_sizes = var_2_20.texture_sizes,
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
		},
		entry_frame = {
			masked = var_2_2,
			texture_size = var_2_16.texture_size,
			texture_sizes = var_2_16.texture_sizes,
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
		},
		lock_texture = {
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
		},
		equipped_texture = {
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
		},
		new_texture = {
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
		},
		symbol_frame = {
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
		},
		symbol_frame_selected = {
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
		},
		symbol_frame_selected_glow = {
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
		},
		symbol_bg = {
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
		},
		symbol_bg_glow = {
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
		},
		wind_symbol = {
			masked = var_2_2,
			size = {
				var_2_10[1],
				var_2_10[2]
			},
			color = var_2_12,
			offset = {
				32 - var_2_10[1] / 2,
				32 - var_2_10[2] / 2,
				10
			}
		}
	}

	return {
		element = var_2_22,
		content = var_2_23,
		style = var_2_27,
		offset = {
			0,
			-(arg_2_0 - 1) * var_0_13[2] - arg_2_0 * var_2_1,
			0
		},
		scenegraph_id = var_2_0
	}
end

local function var_0_20(arg_8_0)
	local var_8_0 = var_0_16[arg_8_0].size

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
					var_8_0[1],
					var_8_0[2]
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

local var_0_21 = {
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
local var_0_22 = {
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
local var_0_23 = {
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
local var_0_24 = {
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
	list_hotspot = var_0_20("list_window"),
	list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "list_window", var_0_16.list_scrollbar.size),
	background_fade = UIWidgets.create_rect_with_outer_frame("window", var_0_16.window.size, "shadow_frame_02", nil, {
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
	next_weaves_title = UIWidgets.create_simple_text(Localize("menu_weave_play_next_weave"), "next_weave_bg", nil, nil, var_0_21),
	next_weave_description = UIWidgets.create_simple_text(Localize("menu_weave_play_complete_to_unlock"), "next_weave_bg", nil, nil, var_0_23),
	unlocked_weaves_top = UIWidgets.create_simple_texture("divider_01_top", "unlocked_weaves_top"),
	unlocked_weaves_bottom = UIWidgets.create_simple_texture("divider_01_bottom", "unlocked_weaves_bottom"),
	unlocked_weaves_bg = UIWidgets.create_simple_texture("hud_difficulty_unlocked_bg_fade", "unlocked_weaves_bg"),
	unlocked_weaves_title = UIWidgets.create_simple_text(Localize("menu_weave_play_completed_weaves"), "unlocked_weaves_bg", nil, nil, var_0_22)
}
local var_0_25 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				arg_9_2.background_fade.alpha_multiplier = 0
			end,
			update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				local var_10_0 = math.easeInCubic(arg_10_3)

				arg_10_2.background_fade.alpha_multiplier = var_10_0
			end,
			on_complete = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				return
			end
		},
		{
			name = "fade_in_2",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				arg_12_3.render_settings.alpha_multiplier = 0
				arg_12_0.list_window.position[1] = arg_12_1.list_window.position[1]
			end,
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				local var_13_0 = math.easeInCubic(arg_13_3)

				arg_13_4.render_settings.alpha_multiplier = var_13_0
				arg_13_0.list_window.position[1] = arg_13_1.list_window.position[1] + (1 - var_13_0) * 30
			end,
			on_complete = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
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
				arg_15_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				local var_16_0 = math.easeOutCubic(arg_16_3)

				arg_16_4.render_settings.alpha_multiplier = 1 - var_16_0
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end
		}
	}
}

return {
	num_visible_weave_entries = 9,
	entry_size = var_0_13,
	entry_spacing = var_0_15,
	widgets = var_0_24,
	create_weave_entry_func = var_0_19,
	scenegraph_definition = var_0_16,
	animation_definitions = var_0_25
}
