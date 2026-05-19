-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_weapons_console_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.size
local var_0_2 = var_0_0.spacing
local var_0_3 = var_0_0.large_window_frame
local var_0_4 = UIFrameSettings[var_0_3].texture_sizes.vertical[1]
local var_0_5 = {
	var_0_1[1] * 3 + var_0_2 * 2 + var_0_4 * 2,
	var_0_1[2] + 80
}
local var_0_6 = {
	var_0_5[1] + 50,
	var_0_5[2]
}
local var_0_7 = "menu_frame_11"
local var_0_8 = UIFrameSettings[var_0_7].texture_sizes.vertical[1]
local var_0_9 = UISettings.game_start_windows
local var_0_10 = 1
local var_0_11 = {
	400,
	720
}
local var_0_12 = {
	480,
	800
}
local var_0_13 = {
	390,
	80
}
local var_0_14 = 0
local var_0_15 = {
	1920,
	1080
}
local var_0_16 = {
	16,
	var_0_15[2] - (var_0_14 * 2 + 220)
}
local var_0_17 = {
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
	screen = {
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
	screen_center = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = var_0_15,
		position = {
			0,
			0,
			1
		}
	},
	top_corner_left = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			110,
			137
		},
		position = {
			var_0_14,
			-var_0_14,
			8
		}
	},
	top_corner_right = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			110,
			137
		},
		position = {
			-var_0_14,
			-var_0_14,
			8
		}
	},
	viewport = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_15[1] - var_0_14 * 2,
			var_0_15[2] - var_0_14 * 2
		},
		position = {
			0,
			var_0_14,
			3
		}
	},
	viewport_panel = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			450,
			100
		},
		position = {
			0,
			50,
			3
		}
	},
	viewport_panel_divider = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			68,
			19
		},
		position = {
			0,
			0,
			1
		}
	},
	viewport_panel_divider_left = {
		vertical_alignment = "center",
		parent = "viewport_panel_divider",
		horizontal_alignment = "left",
		size = {
			55,
			19
		},
		position = {
			-166,
			0,
			0
		}
	},
	viewport_panel_divider_right = {
		vertical_alignment = "center",
		parent = "viewport_panel_divider",
		horizontal_alignment = "right",
		size = {
			55,
			19
		},
		position = {
			166,
			0,
			0
		}
	},
	panel_level_title = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			-90,
			0,
			2
		}
	},
	panel_level_value = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			-90,
			-30,
			2
		}
	},
	panel_power_title = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			90,
			0,
			2
		}
	},
	panel_power_value = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			90,
			-30,
			2
		}
	},
	viewport_title = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			450,
			50
		},
		position = {
			0,
			70,
			3
		}
	},
	viewport_sub_title = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			450,
			50
		},
		position = {
			0,
			40,
			3
		}
	},
	background_wheel = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			math.floor(1029 * var_0_10),
			math.floor(1029 * var_0_10)
		},
		position = {
			0,
			0,
			1
		}
	},
	wheel_ring_1 = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			math.floor(640 * var_0_10),
			math.floor(640 * var_0_10)
		},
		position = {
			0,
			0,
			1
		}
	},
	wheel_ring_2 = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			math.floor(796 * var_0_10),
			math.floor(797 * var_0_10)
		},
		position = {
			0,
			0,
			1
		}
	},
	wheel_ring_3 = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			math.floor(1029 * var_0_10),
			math.floor(1029 * var_0_10)
		},
		position = {
			0,
			0,
			1
		}
	},
	top_glow = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_15[1] + 140,
			600
		},
		position = {
			0,
			-var_0_14,
			1
		}
	},
	top_glow_short = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_15[1] + 140,
			450
		},
		position = {
			0,
			-var_0_14,
			1
		}
	},
	bottom_glow = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_15[1] - var_0_14 * 2,
			600
		},
		position = {
			0,
			var_0_14,
			1
		}
	},
	bottom_glow_short = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_15[1] - var_0_14 * 2,
			200
		},
		position = {
			0,
			var_0_14,
			1
		}
	},
	bottom_glow_shortest = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_15[1] - var_0_14 * 2,
			100
		},
		position = {
			0,
			var_0_14,
			1
		}
	},
	weapon_list_background = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			var_0_11[1] + 80,
			var_0_15[2] - var_0_14 * 2
		},
		position = {
			var_0_14,
			var_0_14,
			3
		}
	},
	weapon_list_window = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = var_0_12,
		position = {
			60,
			180,
			3
		}
	},
	weapon_list_scrollbar = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = var_0_16,
		position = {
			var_0_14 + 20,
			0,
			10
		}
	},
	weapon_scroll_root = {
		vertical_alignment = "top",
		parent = "weapon_list_window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	weapon_list_entry = {
		vertical_alignment = "top",
		parent = "weapon_scroll_root",
		horizontal_alignment = "left",
		size = var_0_13,
		position = {
			25,
			0,
			0
		}
	},
	stats_list_background = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			var_0_11[1] + 80,
			var_0_15[2] - var_0_14 * 2
		},
		position = {
			-var_0_14,
			var_0_14,
			3
		}
	},
	stats_list_window = {
		vertical_alignment = "top",
		parent = "stats_list_background",
		horizontal_alignment = "center",
		size = var_0_11,
		position = {
			-10,
			0,
			1
		}
	},
	stats_list_scrollbar = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = var_0_16,
		position = {
			-(var_0_14 + 20),
			0,
			10
		}
	},
	stats_scroll_root = {
		vertical_alignment = "top",
		parent = "stats_list_window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	stat_option = {
		vertical_alignment = "top",
		parent = "stats_scroll_root",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			15,
			-30,
			1
		}
	},
	equip_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			330,
			60
		},
		position = {
			115,
			100,
			1
		}
	},
	customize_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			330,
			60
		},
		position = {
			-115,
			100,
			1
		}
	},
	unlock_button = {
		vertical_alignment = "bottom",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			452,
			112
		},
		position = {
			0,
			0,
			2
		}
	},
	upgrade_bg = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = {
			900,
			400
		},
		position = {
			0,
			10,
			11
		}
	},
	upgrade_text = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = {
			600,
			50
		},
		position = {
			0,
			0,
			12
		}
	},
	upgrade_effect = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			1000,
			400
		},
		position = {
			0,
			0,
			11
		}
	}
}
local var_0_18 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = false,
	font_size = 52,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = {
		180,
		0,
		0,
		0
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_19 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 18,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_20 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 38,
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
local var_0_21 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 32,
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
local var_0_22 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 22,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}

local function var_0_23(arg_1_0, arg_1_1)
	local var_1_0 = true
	local var_1_1 = UIFrameSettings.button_frame_02
	local var_1_2 = var_1_1.texture_sizes.horizontal[2]
	local var_1_3 = UIFrameSettings.shadow_frame_02
	local var_1_4 = var_1_3.texture_sizes.horizontal[2]
	local var_1_5 = UIFrameSettings.frame_outer_glow_04
	local var_1_6 = var_1_5.texture_sizes.horizontal[2]
	local var_1_7 = UIFrameSettings.frame_outer_glow_01
	local var_1_8 = var_1_7.texture_sizes.horizontal[2]
	local var_1_9 = "frame_outer_glow_04_big"
	local var_1_10 = UIFrameSettings[var_1_9]
	local var_1_11 = var_1_10.texture_sizes.horizontal[2]
	local var_1_12 = {
		{
			style_id = "background",
			pass_type = "hotspot",
			content_id = "button_hotspot"
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
			style_id = "level_title",
			pass_type = "text",
			text_id = "level_title"
		},
		{
			style_id = "level_title_shadow",
			pass_type = "text",
			text_id = "level_title"
		},
		{
			style_id = "power_text",
			pass_type = "text",
			text_id = "power_text",
			content_check_function = function(arg_2_0)
				return not arg_2_0.locked
			end
		},
		{
			style_id = "power_text_shadow",
			pass_type = "text",
			text_id = "power_text",
			content_check_function = function(arg_3_0)
				return not arg_3_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "rect_masked"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon"
		},
		{
			pass_type = "texture",
			style_id = "icon_background",
			texture_id = "icon_background"
		},
		{
			pass_type = "texture",
			style_id = "lock_texture",
			texture_id = "lock_texture",
			content_check_function = function(arg_4_0)
				return arg_4_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "equipped_frame_texture",
			texture_id = "equipped_frame_texture",
			content_check_function = function(arg_5_0)
				return arg_5_0.equipped
			end
		},
		{
			style_id = "new_frame",
			texture_id = "new_frame",
			pass_type = "texture_frame",
			content_check_function = function(arg_6_0)
				local var_6_0 = arg_6_0.backend_id

				return var_6_0 and ItemHelper.is_new_backend_id(var_6_0)
			end,
			content_change_function = function(arg_7_0, arg_7_1)
				local var_7_0 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

				arg_7_1.color[1] = 55 + var_7_0 * 200

				local var_7_1 = arg_7_0.button_hotspot
				local var_7_2 = arg_7_0.backend_id

				if var_7_1.on_hover_enter and var_7_2 and ItemHelper.is_new_backend_id(var_7_2) then
					ItemHelper.unmark_backend_id_as_new(var_7_2)
				end
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "pulse_frame",
			texture_id = "pulse_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "shadow_frame",
			texture_id = "shadow_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "item_frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "hover_frame",
			texture_id = "hover_frame"
		}
	}
	local var_1_13 = {
		equipped = false,
		locked = true,
		equipped_in_another_slot = false,
		icon_background = "icon_bg_magic",
		title = "",
		power_title = "",
		icon = "icon_huntsman_hat_0009",
		lock_texture = "hero_icon_locked",
		level_title = "",
		equipped_frame_texture = "item_icon_selection_wide",
		rect_masked = "rect_masked",
		power_text = "",
		new = false,
		button_hotspot = {},
		frame = var_1_1.texture,
		hover_frame = var_1_5.texture,
		shadow_frame = var_1_3.texture,
		new_frame = var_1_7.texture,
		pulse_frame = var_1_10.texture,
		size = arg_1_1
	}
	local var_1_14 = {
		title = {
			localize = false,
			font_size = 28,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = var_1_0 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			hover_text_color = Colors.get_color_table_with_alpha("white", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				90,
				16,
				2
			},
			size = {
				arg_1_1[1] - 100,
				arg_1_1[2]
			}
		},
		title_shadow = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			localize = false,
			font_size = 28,
			font_type = var_1_0 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				92,
				14,
				1
			},
			size = {
				arg_1_1[1] - 100,
				arg_1_1[2]
			}
		},
		level_title = {
			localize = false,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				120,
				120,
				120
			},
			hover_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			default_text_color = {
				255,
				120,
				120,
				120
			},
			offset = {
				90,
				-16,
				2
			},
			size = {
				(arg_1_1[1] - 100) / 2,
				arg_1_1[2]
			}
		},
		level_title_shadow = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			localize = false,
			font_size = 20,
			font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				92,
				-18,
				1
			},
			size = {
				(arg_1_1[1] - 100) / 2,
				arg_1_1[2]
			}
		},
		power_title = {
			localize = false,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				120,
				120,
				120
			},
			hover_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			default_text_color = {
				255,
				120,
				120,
				120
			},
			offset = {
				(arg_1_1[1] - 100) / 2,
				-16,
				2
			},
			size = {
				(arg_1_1[1] - 100) / 2,
				arg_1_1[2]
			}
		},
		power_title_shadow = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			localize = false,
			font_size = 20,
			font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				(arg_1_1[1] - 100) / 2 + 2,
				-18,
				1
			},
			size = {
				(arg_1_1[1] - 100) / 2,
				arg_1_1[2]
			}
		},
		power_text = {
			localize = false,
			font_size = 32,
			horizontal_alignment = "right",
			vertical_alignment = "center",
			font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			hover_text_color = Colors.get_color_table_with_alpha("white", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				-15,
				-2,
				2
			},
			size = arg_1_1
		},
		power_text_shadow = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			localize = false,
			font_size = 32,
			font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				-13,
				-4,
				1
			},
			size = arg_1_1
		},
		background = {
			masked = var_1_0,
			size = {
				arg_1_1[1],
				arg_1_1[2]
			},
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		},
		equipped_frame_texture = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = var_1_0,
			texture_size = arg_1_1,
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				0,
				5
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = var_1_0,
			texture_size = {
				80,
				80
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
				2
			}
		},
		icon_background = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = var_1_0,
			texture_size = {
				80,
				80
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
				1
			}
		},
		lock_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = var_1_0,
			texture_size = {
				45.6,
				52.199999999999996
			},
			color = {
				180,
				255,
				255,
				255
			},
			offset = {
				-8,
				0,
				4
			}
		},
		item_frame = {
			masked = var_1_0,
			texture_size = var_1_1.texture_size,
			texture_sizes = var_1_1.texture_sizes,
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
			},
			size = {
				80,
				80
			}
		},
		hover_frame = {
			masked = var_1_0,
			texture_size = var_1_5.texture_size,
			texture_sizes = var_1_5.texture_sizes,
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				7
			},
			size = {
				arg_1_1[1],
				arg_1_1[2]
			},
			frame_margins = {
				-var_1_6,
				-var_1_6
			}
		},
		pulse_frame = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			masked = var_1_0,
			area_size = arg_1_1,
			texture_size = var_1_10.texture_size,
			texture_sizes = var_1_10.texture_sizes,
			frame_margins = {
				-var_1_11,
				-var_1_11
			},
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
			}
		},
		new_frame = {
			masked = var_1_0,
			texture_size = var_1_7.texture_size,
			texture_sizes = var_1_7.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				6
			},
			size = {
				arg_1_1[1],
				arg_1_1[2]
			},
			frame_margins = {
				-var_1_8,
				-var_1_8
			}
		},
		shadow_frame = {
			masked = var_1_0,
			texture_size = var_1_3.texture_size,
			texture_sizes = var_1_3.texture_sizes,
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				1
			},
			size = {
				arg_1_1[1],
				arg_1_1[2]
			},
			frame_margins = {
				-var_1_4,
				-var_1_4
			}
		},
		frame = {
			masked = var_1_0,
			texture_size = var_1_1.texture_size,
			texture_sizes = var_1_1.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				4
			},
			size = {
				arg_1_1[1],
				arg_1_1[2]
			}
		}
	}

	return {
		element = {
			passes = var_1_12
		},
		content = var_1_13,
		style = var_1_14,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local function var_0_24(arg_8_0, arg_8_1, arg_8_2)
	arg_8_2 = arg_8_2 or 20

	local var_8_0 = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_texture"
			},
			{
				pass_type = "texture",
				style_id = "mask_top",
				texture_id = "mask_edge"
			},
			{
				pass_type = "rotated_texture",
				style_id = "mask_bottom",
				texture_id = "mask_edge"
			}
		}
	}
	local var_8_1 = {
		mask_texture = "mask_rect",
		mask_edge = "mask_rect_edge_fade",
		hotspot = {
			allow_multi_hover = true
		}
	}
	local var_8_2 = {
		mask = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				arg_8_1[1],
				arg_8_1[2]
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
		mask_top = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				arg_8_1[1],
				arg_8_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				arg_8_2,
				0
			}
		},
		mask_bottom = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				arg_8_1[1],
				arg_8_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-arg_8_2,
				0
			},
			angle = math.pi,
			pivot = {
				arg_8_1[1] / 2,
				arg_8_2 / 2
			}
		}
	}

	return {
		element = var_8_0,
		content = var_8_1,
		style = var_8_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_8_0
	}
end

local function var_0_25(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
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
		},
		content = {
			texture_id = "divider_01_top",
			text = arg_9_3,
			size = arg_9_0
		},
		style = {
			texture_id = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				masked = arg_9_2,
				size = {
					300,
					50
				},
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
					-34,
					2
				}
			},
			text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 24,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_9_2 and "hell_shark_header_masked" or "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					0,
					-14,
					3
				}
			},
			text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 24,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_9_2 and "hell_shark_header_masked" or "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-16,
					2
				}
			}
		},
		offset = {
			35,
			0,
			0
		},
		scenegraph_id = arg_9_1
	}
end

local function var_0_26(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
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
		},
		content = {
			text = arg_10_3,
			texture_id = arg_10_4,
			size = arg_10_0
		},
		style = {
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				masked = arg_10_2,
				texture_size = {
					50,
					50
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					5,
					0,
					2
				}
			},
			text = {
				font_size = 18,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_10_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				color_override = {},
				color_override_table = {
					start_index = 0,
					end_index = 0,
					color = Colors.get_color_table_with_alpha("corn_flower_blue", 255)
				},
				offset = {
					50,
					-23,
					3
				}
			},
			text_shadow = {
				font_size = 18,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_10_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					51,
					-24,
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_10_1
	}
end

local function var_0_27(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					style_id = "description_text_shadow",
					pass_type = "text",
					text_id = "description_text"
				}
			}
		},
		content = {
			title_text = arg_11_3,
			description_text = arg_11_4,
			texture_id = arg_11_5,
			size = arg_11_0
		},
		style = {
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				masked = arg_11_2,
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					5,
					0,
					2
				}
			},
			title_text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_11_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					60,
					-5,
					3
				}
			},
			title_text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_11_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					61,
					-6,
					2
				}
			},
			description_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					300,
					50
				},
				font_type = arg_11_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					60,
					-54,
					3
				}
			},
			description_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					300,
					50
				},
				font_type = arg_11_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					61,
					-55,
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_11_1
	}
end

local function var_0_28(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_3 / (math.pi * 2)

	return {
		element = {
			passes = {
				{
					pass_type = "rotated_texture",
					style_id = "arch_texture_1",
					texture_id = "arch_texture"
				},
				{
					pass_type = "rotated_texture",
					style_id = "arch_texture_2",
					texture_id = "arch_texture"
				},
				{
					pass_type = "texture",
					style_id = "slot_texture",
					texture_id = "slot_texture"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					style_id = "description_text_shadow",
					pass_type = "text",
					text_id = "description_text"
				}
			}
		},
		content = {
			slot_texture = "icon_block",
			title_text = Localize("menu_weave_forge_weapon_block_title"),
			description_text = Localize("menu_weave_forge_weapon_block_description"),
			arch_texture = arg_12_2 and "icon_block_arch_masked" or "icon_block_arch",
			size = arg_12_0
		},
		style = {
			arch_texture_1 = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				angle = -arg_12_3 / 2,
				pivot = {
					32,
					32
				},
				texture_size = {
					64,
					64
				},
				color = {
					255 * var_12_0,
					255,
					255,
					255
				},
				offset = {
					-5,
					0,
					1
				}
			},
			arch_texture_2 = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
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
				angle = arg_12_3 / 2,
				pivot = {
					32,
					32
				},
				texture_size = {
					64,
					64
				},
				color = {
					255 * var_12_0,
					255,
					255,
					255
				},
				offset = {
					-5,
					0,
					1
				}
			},
			slot_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				masked = arg_12_2,
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
					-5,
					0,
					2
				}
			},
			title_text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_12_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					60,
					-5,
					3
				}
			},
			title_text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_12_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					61,
					-6,
					2
				}
			},
			description_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					300,
					50
				},
				font_type = arg_12_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					60,
					-54,
					3
				}
			},
			description_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					300,
					50
				},
				font_type = arg_12_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					61,
					-55,
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_12_1
	}
end

local function var_0_29(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "shield_texture",
					texture_id = "shield_texture"
				},
				{
					style_id = "amount_text",
					pass_type = "text",
					text_id = "amount_text"
				},
				{
					style_id = "amount_text_shadow",
					pass_type = "text",
					text_id = "amount_text"
				},
				{
					style_id = "amount_text_shadow_2",
					pass_type = "text",
					text_id = "amount_text"
				},
				{
					style_id = "amount_text_shadow_3",
					pass_type = "text",
					text_id = "amount_text"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					style_id = "description_text_shadow",
					pass_type = "text",
					text_id = "description_text"
				}
			}
		},
		content = {
			shield_texture = "icon_stamina",
			amount_text = arg_13_3 or "",
			title_text = Localize("menu_weave_forge_weapon_stamina_title"),
			description_text = Localize("menu_weave_forge_weapon_stamina_description"),
			size = arg_13_0
		},
		style = {
			shield_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				masked = arg_13_2,
				texture_size = {
					56,
					60
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-2,
					0,
					2
				}
			},
			amount_text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 36,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					50,
					arg_13_0[2]
				},
				font_type = arg_13_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-20,
					-arg_13_0[2] / 2,
					3
				}
			},
			amount_text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 36,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					50,
					arg_13_0[2]
				},
				font_type = arg_13_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-18,
					-(arg_13_0[2] / 2),
					2
				}
			},
			amount_text_shadow_2 = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 36,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					50,
					arg_13_0[2]
				},
				font_type = arg_13_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-20,
					-(arg_13_0[2] / 2) + 2,
					2
				}
			},
			amount_text_shadow_3 = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 36,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					50,
					arg_13_0[2]
				},
				font_type = arg_13_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-20,
					-(arg_13_0[2] / 2 + 2),
					2
				}
			},
			title_text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_13_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					60,
					-5,
					3
				}
			},
			title_text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_13_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					61,
					-6,
					2
				}
			},
			description_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					300,
					50
				},
				font_type = arg_13_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					60,
					-54,
					3
				}
			},
			description_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					300,
					50
				},
				font_type = arg_13_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					61,
					-55,
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_13_1
	}
end

local function var_0_30(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	return {
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
				}
			}
		},
		content = {
			text = arg_14_3 or "",
			size = arg_14_0
		},
		style = {
			text = {
				font_size = 18,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					370,
					arg_14_0[2]
				},
				font_type = arg_14_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("forest_green", 255),
				offset = {
					0,
					-arg_14_0[2] / 2,
					3
				}
			},
			text_shadow = {
				font_size = 18,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					370,
					arg_14_0[2]
				},
				font_type = arg_14_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					1,
					-(arg_14_0[2] / 2 + 1),
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_14_1
	}
end

local function var_0_31(arg_15_0, arg_15_1, arg_15_2)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "flame_texture",
					texture_id = "flame_texture"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					style_id = "description_text_shadow",
					pass_type = "text",
					text_id = "description_text"
				}
			}
		},
		content = {
			flame_texture = "icon_fire",
			title_text = Localize("menu_weave_forge_weapon_ammo_burn_title"),
			description_text = Localize("menu_weave_forge_weapon_ammo_burn_description"),
			size = arg_15_0
		},
		style = {
			flame_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				masked = arg_15_2,
				texture_size = {
					46,
					61
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-5,
					2
				}
			},
			title_text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_15_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					60,
					-5,
					3
				}
			},
			title_text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_15_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					61,
					-6,
					2
				}
			},
			description_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					300,
					50
				},
				font_type = arg_15_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					60,
					-54,
					3
				}
			},
			description_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					300,
					50
				},
				font_type = arg_15_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					61,
					-55,
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_15_1
	}
end

local function var_0_32(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "ammunition_texture",
					texture_id = "ammunition_texture",
					content_check_function = function(arg_17_0)
						return not arg_17_0.hide_ammo_ui
					end
				},
				{
					pass_type = "texture",
					style_id = "flame_texture",
					texture_id = "flame_texture",
					content_check_function = function(arg_18_0)
						return arg_18_0.hide_ammo_ui
					end
				},
				{
					style_id = "amount_text",
					pass_type = "text",
					text_id = "amount_text",
					content_check_function = function(arg_19_0)
						return not arg_19_0.hide_ammo_ui
					end
				},
				{
					style_id = "amount_text_shadow",
					pass_type = "text",
					text_id = "amount_text",
					content_check_function = function(arg_20_0)
						return not arg_20_0.hide_ammo_ui
					end
				},
				{
					style_id = "amount_text_shadow_2",
					pass_type = "text",
					text_id = "amount_text",
					content_check_function = function(arg_21_0)
						return not arg_21_0.hide_ammo_ui
					end
				},
				{
					style_id = "amount_text_shadow_3",
					pass_type = "text",
					text_id = "amount_text",
					content_check_function = function(arg_22_0)
						return not arg_22_0.hide_ammo_ui
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					style_id = "description_text_shadow",
					pass_type = "text",
					text_id = "description_text"
				}
			}
		},
		content = {
			hide_ammo_ui = false,
			flame_texture = "icon_fire",
			ammunition_texture = "icon_ammo",
			amount_text = arg_16_3 or "-",
			title_text = Localize("menu_weave_forge_weapon_ammo_regular_title"),
			description_text = Localize("menu_weave_forge_weapon_ammo_regular_description"),
			size = arg_16_0
		},
		style = {
			ammunition_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				masked = arg_16_2,
				texture_size = {
					68,
					36
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-12,
					-25,
					2
				}
			},
			flame_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				masked = arg_16_2,
				texture_size = {
					46,
					61
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-5,
					2
				}
			},
			amount_text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 36,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					60,
					arg_16_0[2]
				},
				font_type = arg_16_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-8,
					-arg_16_0[2] / 2,
					3
				}
			},
			amount_text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 36,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					60,
					arg_16_0[2]
				},
				font_type = arg_16_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-6,
					-(arg_16_0[2] / 2),
					2
				}
			},
			amount_text_shadow_2 = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 36,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					60,
					arg_16_0[2]
				},
				font_type = arg_16_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-8,
					-(arg_16_0[2] / 2) + 2,
					2
				}
			},
			amount_text_shadow_3 = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 36,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					60,
					arg_16_0[2]
				},
				font_type = arg_16_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-8,
					-(arg_16_0[2] / 2 + 2),
					2
				}
			},
			title_text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_16_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					60,
					-5,
					3
				}
			},
			title_text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					300,
					50
				},
				font_type = arg_16_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					61,
					-6,
					2
				}
			},
			description_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					300,
					50
				},
				font_type = arg_16_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					60,
					-54,
					3
				}
			},
			description_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					300,
					50
				},
				font_type = arg_16_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					61,
					-55,
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_16_1
	}
end

local var_0_33 = true
local var_0_34 = {
	top_hdr_background_write_mask = UIWidgets.create_simple_texture("ui_write_mask", "window"),
	upgrade_bg = UIWidgets.create_simple_texture("weave_menu_athanor_upgrade_bg", "upgrade_bg")
}
local var_0_35 = {
	upgrade_effect = UIWidgets.create_simple_texture("athanor_item_unlock", "upgrade_effect")
}
local var_0_36 = {}
local var_0_37 = {
	upgrade_text = UIWidgets.create_simple_text(Localize("menu_weave_weapon_forged_unlocked"), "upgrade_text", nil, nil, var_0_18),
	viewport_panel_divider = UIWidgets.create_simple_texture("athanor_item_divider_middle", "viewport_panel_divider"),
	viewport_panel_divider_left = UIWidgets.create_simple_uv_texture("athanor_item_divider_edge", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "viewport_panel_divider_left"),
	viewport_panel_divider_right = UIWidgets.create_simple_texture("athanor_item_divider_edge", "viewport_panel_divider_right"),
	viewport_level_title = UIWidgets.create_simple_text(Localize("menu_weave_forge_magic_level_title"), "panel_level_title", nil, nil, var_0_19),
	viewport_level_value = UIWidgets.create_simple_text("0", "panel_level_value", nil, nil, var_0_20),
	viewport_power_title = UIWidgets.create_simple_text(Localize("menu_weave_forge_loadout_power_title"), "panel_power_title", nil, nil, var_0_19),
	viewport_power_value = UIWidgets.create_simple_text("0", "panel_power_value", nil, nil, var_0_20),
	viewport_title = UIWidgets.create_simple_text("", "viewport_title", nil, nil, var_0_21),
	viewport_sub_title = UIWidgets.create_simple_text("", "viewport_sub_title", nil, nil, var_0_22),
	weapon_list_background = UIWidgets.create_rect_with_outer_frame("weapon_list_background", var_0_17.weapon_list_background.size, "shadow_frame_02", nil, {
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
	weapon_list_scrollbar = UIWidgets.create_chain_scrollbar("weapon_list_scrollbar", "weapon_list_window", var_0_17.weapon_list_scrollbar.size),
	weapon_list_mask = var_0_24("weapon_list_window", var_0_17.weapon_list_window.size, 10),
	stats_list_background = UIWidgets.create_rect_with_outer_frame("stats_list_background", var_0_17.stats_list_background.size, "shadow_frame_02", nil, {
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
	stats_list_scrollbar = UIWidgets.create_chain_scrollbar("stats_list_scrollbar", "stats_list_window", var_0_17.stats_list_scrollbar.size),
	stats_list_mask = var_0_24("stats_list_window", var_0_17.stats_list_window.size, 10),
	equip_button = UIWidgets.create_default_button("equip_button", var_0_17.equip_button.size, nil, nil, Localize("input_description_equip"), 26, nil, "button_detail_02"),
	customize_button = UIWidgets.create_default_button("customize_button", var_0_17.customize_button.size, nil, nil, Localize("menu_weave_forge_customize_loadout_button"), 26, nil, "button_detail_02"),
	unlock_button = UIWidgets.create_athanor_upgrade_button("unlock_button", var_0_17.unlock_button.size, "athanor_icon_unlock", Localize("menu_weave_forge_unlock_weapon_button"), 24)
}
local var_0_38 = {
	upgrade = {
		{
			name = "fade_in_text_panel",
			start_progress = 0,
			end_progress = 1,
			init = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				local var_23_0 = arg_23_2.upgrade_bg
				local var_23_1 = arg_23_2.upgrade_text

				var_23_0.alpha_multiplier = 0
				var_23_1.alpha_multiplier = 0
			end,
			update = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				local var_24_0 = math.easeOutCubic(arg_24_3)
				local var_24_1 = arg_24_2.upgrade_bg
				local var_24_2 = arg_24_2.upgrade_text

				var_24_1.alpha_multiplier = var_24_0
				var_24_2.alpha_multiplier = var_24_0
			end,
			on_complete = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				return
			end
		},
		{
			name = "fade_out_text_panel",
			start_progress = 1,
			end_progress = 2,
			init = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				return
			end,
			update = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				local var_27_0 = math.easeInCubic(1 - arg_27_3)
				local var_27_1 = arg_27_2.upgrade_bg
				local var_27_2 = arg_27_2.upgrade_text

				var_27_1.alpha_multiplier = var_27_0
				var_27_2.alpha_multiplier = var_27_0
			end,
			on_complete = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				return
			end
		},
		{
			name = "font_offset",
			start_progress = 0,
			end_progress = 2,
			init = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				return
			end,
			update = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				local var_30_0 = math.easeOutCubic(arg_30_3)

				arg_30_2.upgrade_text.offset[2] = -40 + 50 * var_30_0
			end,
			on_complete = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end
		},
		{
			name = "font_panel_size_increase",
			start_progress = 0,
			end_progress = 4,
			init = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				local var_32_0 = arg_32_2.upgrade_bg.scenegraph_id
				local var_32_1 = arg_32_1[var_32_0].size
				local var_32_2 = arg_32_0[var_32_0].size

				var_32_2[1] = var_32_1[1]
				var_32_2[2] = var_32_1[2]
			end,
			update = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				local var_33_0 = math.easeOutCubic(arg_33_3)
				local var_33_1 = arg_33_2.upgrade_bg.scenegraph_id
				local var_33_2 = arg_33_1[var_33_1].size
				local var_33_3 = arg_33_0[var_33_1].size

				var_33_3[1] = var_33_2[1] + 200 * (1 - var_33_0)
				var_33_3[2] = var_33_2[2] + 200 * (1 - var_33_0)
			end,
			on_complete = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end
		},
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.25,
			init = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				arg_35_2.upgrade_effect.alpha_multiplier = 0
			end,
			update = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				local var_36_0 = math.easeOutCubic(arg_36_3)

				arg_36_2.upgrade_effect.alpha_multiplier = 1
			end,
			on_complete = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 0.75,
			end_progress = 1.5,
			init = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				return
			end,
			update = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				local var_39_0 = math.easeInCubic(arg_39_3)

				arg_39_2.upgrade_effect.alpha_multiplier = math.max(1 - var_39_0, 0.01)
			end,
			on_complete = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				return
			end
		},
		{
			name = "size_in",
			start_progress = 0,
			end_progress = 2,
			init = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				local var_41_0 = arg_41_2.upgrade_effect.scenegraph_id
				local var_41_1 = arg_41_1[var_41_0]
				local var_41_2 = arg_41_0[var_41_0]
				local var_41_3 = var_41_1.size
				local var_41_4 = var_41_2.size
			end,
			update = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
				local var_42_0 = math.easeOutCubic(arg_42_3)
				local var_42_1 = arg_42_2.upgrade_effect.scenegraph_id
				local var_42_2 = arg_42_1[var_42_1]
				local var_42_3 = arg_42_0[var_42_1]
				local var_42_4 = var_42_2.size

				var_42_3.size[2] = var_42_4[2] + var_42_4[2] * 10 * var_42_0
			end,
			on_complete = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				return
			end
		},
		{
			name = "intensity_out",
			start_progress = 1,
			end_progress = 1.5,
			init = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				local var_44_0 = arg_44_3.parent:hdr_renderer().gui
				local var_44_1 = arg_44_2.upgrade_effect.content.texture_id
				local var_44_2 = Gui.material(var_44_0, var_44_1)
				local var_44_3 = 0.4

				Material.set_scalar(var_44_2, "intensity", var_44_3)
			end,
			update = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
				local var_45_0 = math.easeOutCubic(1 - arg_45_3)
				local var_45_1 = arg_45_4.parent:hdr_renderer().gui
				local var_45_2 = arg_45_2.upgrade_effect.content.texture_id
				local var_45_3 = Gui.material(var_45_1, var_45_2)
				local var_45_4 = 0
				local var_45_5 = 0.4
				local var_45_6 = var_45_4 + math.clamp(var_45_0, 0, 1) * var_45_5

				Material.set_scalar(var_45_3, "intensity", var_45_6)
			end,
			on_complete = function(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				return
			end
		}
	},
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
				arg_47_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
				local var_48_0 = math.easeOutCubic(arg_48_3)

				arg_48_4.render_settings.alpha_multiplier = var_48_0
			end,
			on_complete = function(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
				arg_50_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
				local var_51_0 = math.easeOutCubic(arg_51_3)

				arg_51_4.render_settings.alpha_multiplier = 1 - var_51_0
			end,
			on_complete = function(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
				return
			end
		}
	}
}

return {
	top_widgets = var_0_37,
	bottom_widgets = var_0_36,
	top_hdr_widgets = var_0_34,
	bottom_hdr_widgets = var_0_35,
	create_trait_option = var_0_27,
	create_divider_option = var_0_25,
	create_property_option = var_0_26,
	create_item_block_option = var_0_28,
	create_item_stamina_option = var_0_29,
	create_item_ammunition_option = var_0_32,
	create_item_overheat_option = var_0_31,
	create_item_keywords_option = var_0_30,
	create_weapon_entry_widget = var_0_23,
	scenegraph_definition = var_0_17,
	animation_definitions = var_0_38
}
