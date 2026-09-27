-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_weapons_definitions.lua

local game_start_windows = UISettings.game_start_windows
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local large_window_frame = game_start_windows.large_window_frame
local var_0_4 = UIFrameSettings[large_window_frame].texture_sizes.vertical[1]
local tbl = {
	size[1] * 3 + spacing * 2 + var_0_4 * 2,
	size[2] + 80
}
local tbl_2 = {
	tbl[1] + 50,
	tbl[2]
}
local str = "menu_frame_11"
local var_0_8 = UIFrameSettings[str].texture_sizes.vertical[1]
local game_start_windows_2 = UISettings.game_start_windows
local num = 1
local tbl_3 = {
	400,
	720
}
local tbl_4 = {
	480,
	600
}
local tbl_5 = {
	390,
	80
}
local tbl_6 = {
	16,
	tbl_2[2] - (var_0_8 * 2 + 220)
}
local tbl_7 = {
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
		size = tbl_2,
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
			var_0_8,
			-var_0_8,
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
			-var_0_8,
			-var_0_8,
			8
		}
	},
	viewport = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_2[1] - var_0_8 * 2,
			tbl_2[2] - var_0_8 * 2
		},
		position = {
			0,
			var_0_8,
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
			math.floor(1029 * num),
			math.floor(1029 * num)
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
			math.floor(640 * num),
			math.floor(640 * num)
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
			math.floor(796 * num),
			math.floor(797 * num)
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
			math.floor(1029 * num),
			math.floor(1029 * num)
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
			tbl_2[1] + 140,
			600
		},
		position = {
			0,
			-var_0_8,
			1
		}
	},
	top_glow_short = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_2[1] + 140,
			450
		},
		position = {
			0,
			-var_0_8,
			1
		}
	},
	bottom_glow = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_2[1] - var_0_8 * 2,
			600
		},
		position = {
			0,
			var_0_8,
			1
		}
	},
	bottom_glow_short = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_2[1] - var_0_8 * 2,
			200
		},
		position = {
			0,
			var_0_8,
			1
		}
	},
	bottom_glow_shortest = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_2[1] - var_0_8 * 2,
			100
		},
		position = {
			0,
			var_0_8,
			1
		}
	},
	weapon_list_background = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			tbl_3[1] + 80,
			tbl_2[2] - var_0_8 * 2
		},
		position = {
			var_0_8,
			var_0_8,
			3
		}
	},
	weapon_list_window = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = tbl_4,
		position = {
			60,
			150,
			3
		}
	},
	weapon_list_scrollbar = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = tbl_6,
		position = {
			var_0_8 + 20,
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
		size = tbl_5,
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
			tbl_3[1] + 80,
			tbl_2[2] - var_0_8 * 2
		},
		position = {
			-var_0_8,
			var_0_8,
			3
		}
	},
	stats_list_window = {
		vertical_alignment = "top",
		parent = "stats_list_background",
		horizontal_alignment = "center",
		size = tbl_3,
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
		size = tbl_6,
		position = {
			-(var_0_8 + 20),
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
			60,
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
			60,
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
local tbl_8 = {
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
local tbl_9 = {
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
local tbl_10 = {
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
local tbl_11 = {
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
local tbl_12 = {
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

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local flag = true
	local button_frame_02 = UIFrameSettings.button_frame_02
	local var_1_2 = button_frame_02.texture_sizes.horizontal[2]
	local shadow_frame_02 = UIFrameSettings.shadow_frame_02
	local var_1_4 = shadow_frame_02.texture_sizes.horizontal[2]
	local frame_outer_glow_04 = UIFrameSettings.frame_outer_glow_04
	local var_1_6 = frame_outer_glow_04.texture_sizes.horizontal[2]
	local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
	local var_1_8 = frame_outer_glow_01.texture_sizes.horizontal[2]
	local str = "frame_outer_glow_04_big"
	local var_1_10 = UIFrameSettings[str]
	local var_1_11 = var_1_10.texture_sizes.horizontal[2]
	local tbl = {
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
			content_check_function = function (self)
				-- function 2
				return not self.locked
			end
		},
		{
			style_id = "power_text_shadow",
			pass_type = "text",
			text_id = "power_text",
			content_check_function = function (self)
				-- function 3
				return not self.locked
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
			content_check_function = function (self)
				-- function 4
				return self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "equipped_frame_texture",
			texture_id = "equipped_frame_texture",
			content_check_function = function (self)
				-- function 5
				return self.equipped
			end
		},
		{
			style_id = "new_frame",
			texture_id = "new_frame",
			pass_type = "texture_frame",
			content_check_function = function (self)
				-- function 6
				local backend_id = self.backend_id

				return not backend_id and ItemHelper.is_new_backend_id(backend_id)
			end,
			content_change_function = function (self, arg_7_1)
				-- function 7
				local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

				arg_7_1.color[1] = 55 + num * 200

				local button_hotspot = self.button_hotspot
				local backend_id = self.backend_id

				if not button_hotspot.on_hover_enter and not backend_id and not ItemHelper.is_new_backend_id(backend_id) then
					ItemHelper.unmark_backend_id_as_new(backend_id)
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
	local tbl_2 = {
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
		frame = button_frame_02.texture,
		hover_frame = frame_outer_glow_04.texture,
		shadow_frame = shadow_frame_02.texture,
		new_frame = frame_outer_glow_01.texture,
		pulse_frame = var_1_10.texture,
		size = arg_1_1
	}
	local tbl_3 = {}
	local tbl_4 = {
		localize = false,
		font_size = 28,
		horizontal_alignment = "left",
		vertical_alignment = "center"
	}
	local flag_2

	flag_2 = not flag and "hell_shark_header_masked" and "hell_shark_header"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_4.hover_text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_4.default_text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_4.offset = {
		90,
		16,
		2
	}
	tbl_4.size = {
		arg_1_1[1] - 100,
		arg_1_1[2]
	}
	tbl_3.title = tbl_4

	local tbl_5 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		localize = false,
		font_size = 28
	}
	local flag_3

	flag_3 = not flag and "hell_shark_header_masked" and "hell_shark_header"
	tbl_5.font_type = flag_3
	tbl_5.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_5.offset = {
		92,
		14,
		1
	}
	tbl_5.size = {
		arg_1_1[1] - 100,
		arg_1_1[2]
	}
	tbl_3.title_shadow = tbl_5

	local tbl_6 = {
		localize = false,
		font_size = 20,
		horizontal_alignment = "left",
		vertical_alignment = "center"
	}
	local flag_4

	flag_4 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_4
	tbl_6.text_color = {
		255,
		120,
		120,
		120
	}
	tbl_6.hover_text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_6.default_text_color = {
		255,
		120,
		120,
		120
	}
	tbl_6.offset = {
		90,
		-16,
		2
	}
	tbl_6.size = {
		(arg_1_1[1] - 100) / 2,
		arg_1_1[2]
	}
	tbl_3.level_title = tbl_6

	local tbl_7 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		localize = false,
		font_size = 20
	}
	local flag_5

	flag_5 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_7.font_type = flag_5
	tbl_7.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_7.offset = {
		92,
		-18,
		1
	}
	tbl_7.size = {
		(arg_1_1[1] - 100) / 2,
		arg_1_1[2]
	}
	tbl_3.level_title_shadow = tbl_7

	local tbl_8 = {
		localize = false,
		font_size = 20,
		horizontal_alignment = "left",
		vertical_alignment = "center"
	}
	local flag_6

	flag_6 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_8.font_type = flag_6
	tbl_8.text_color = {
		255,
		120,
		120,
		120
	}
	tbl_8.hover_text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_8.default_text_color = {
		255,
		120,
		120,
		120
	}
	tbl_8.offset = {
		(arg_1_1[1] - 100) / 2,
		-16,
		2
	}
	tbl_8.size = {
		(arg_1_1[1] - 100) / 2,
		arg_1_1[2]
	}
	tbl_3.power_title = tbl_8

	local tbl_9 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		localize = false,
		font_size = 20
	}
	local flag_7

	flag_7 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_9.font_type = flag_7
	tbl_9.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_9.offset = {
		(arg_1_1[1] - 100) / 2 + 2,
		-18,
		1
	}
	tbl_9.size = {
		(arg_1_1[1] - 100) / 2,
		arg_1_1[2]
	}
	tbl_3.power_title_shadow = tbl_9

	local tbl_10 = {
		localize = false,
		font_size = 32,
		horizontal_alignment = "right",
		vertical_alignment = "center"
	}
	local flag_8

	flag_8 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_10.font_type = flag_8
	tbl_10.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_10.hover_text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_10.default_text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_10.offset = {
		-15,
		-2,
		2
	}
	tbl_10.size = arg_1_1
	tbl_3.power_text = tbl_10

	local tbl_11 = {
		vertical_alignment = "center",
		horizontal_alignment = "right",
		localize = false,
		font_size = 32
	}
	local flag_9

	flag_9 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_11.font_type = flag_9
	tbl_11.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_11.offset = {
		-13,
		-4,
		1
	}
	tbl_11.size = arg_1_1
	tbl_3.power_text_shadow = tbl_11
	tbl_3.background = {
		masked = flag,
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
	}
	tbl_3.equipped_frame_texture = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		masked = flag,
		texture_size = arg_1_1,
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			0,
			0,
			5
		}
	}
	tbl_3.icon = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		masked = flag,
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
	}
	tbl_3.icon_background = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		masked = flag,
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
	}
	tbl_3.lock_texture = {
		vertical_alignment = "center",
		horizontal_alignment = "right",
		masked = flag,
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
	}
	tbl_3.item_frame = {
		masked = flag,
		texture_size = button_frame_02.texture_size,
		texture_sizes = button_frame_02.texture_sizes,
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
	}
	tbl_3.hover_frame = {
		masked = flag,
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
	}
	tbl_3.pulse_frame = {
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		masked = flag,
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
	}
	tbl_3.new_frame = {
		masked = flag,
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
	}
	tbl_3.shadow_frame = {
		masked = flag,
		texture_size = shadow_frame_02.texture_size,
		texture_sizes = shadow_frame_02.texture_sizes,
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
	}
	tbl_3.frame = {
		masked = flag,
		texture_size = button_frame_02.texture_size,
		texture_sizes = button_frame_02.texture_sizes,
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

	return {
		element = {
			passes = tbl
		},
		content = tbl_2,
		style = tbl_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local function fn_2(arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	arg_8_2 = arg_8_2 or 20

	local tbl = {
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
	local tbl_2 = {
		mask_texture = "mask_rect",
		mask_edge = "mask_rect_edge_fade",
		hotspot = {
			allow_multi_hover = true
		}
	}
	local tbl_3 = {
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
		element = tbl,
		content = tbl_2,
		style = tbl_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_8_0
	}
end

local function fn_3(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local tbl = {
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
		}
	}
	local tbl_2 = {
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
		}
	}
	local tbl_3 = {
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
		}
	}
	local flag

	flag = not arg_9_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_3.offset = {
		0,
		-14,
		3
	}
	tbl_2.text = tbl_3

	local tbl_4 = {
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
		}
	}
	local flag_2

	flag_2 = not arg_9_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_4.offset = {
		2,
		-16,
		2
	}
	tbl_2.text_shadow = tbl_4
	tbl.style = tbl_2
	tbl.offset = {
		35,
		0,
		0
	}
	tbl.scenegraph_id = arg_9_1

	return tbl
end

local function fn_4(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local tbl = {
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
		}
	}
	local tbl_2 = {
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
		}
	}
	local tbl_3 = {
		font_size = 18,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true,
		size = {
			300,
			50
		}
	}
	local flag

	flag = not arg_10_2 and "hell_shark_masked" and "hell_shark"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_3.color_override = {}
	tbl_3.color_override_table = {
		start_index = 0,
		end_index = 0,
		color = Colors.get_color_table_with_alpha("corn_flower_blue", 255)
	}
	tbl_3.offset = {
		50,
		-23,
		3
	}
	tbl_2.text = tbl_3

	local tbl_4 = {
		font_size = 18,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true,
		size = {
			300,
			50
		}
	}
	local flag_2

	flag_2 = not arg_10_2 and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_4.offset = {
		51,
		-24,
		2
	}
	tbl_2.text_shadow = tbl_4
	tbl.style = tbl_2
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_10_1

	return tbl
end

local function fn_5(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local tbl = {
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
		}
	}
	local tbl_2 = {
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
		}
	}
	local tbl_3 = {
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
		}
	}
	local flag

	flag = not arg_11_2 and "hell_shark_masked" and "hell_shark"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_3.offset = {
		60,
		-5,
		3
	}
	tbl_2.title_text = tbl_3

	local tbl_4 = {
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
		}
	}
	local flag_2

	flag_2 = not arg_11_2 and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_4.offset = {
		61,
		-6,
		2
	}
	tbl_2.title_text_shadow = tbl_4

	local tbl_5 = {
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
		}
	}
	local flag_3

	flag_3 = not arg_11_2 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag_3
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_5.offset = {
		60,
		-54,
		3
	}
	tbl_2.description_text = tbl_5

	local tbl_6 = {
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
		}
	}
	local flag_4

	flag_4 = not arg_11_2 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_4
	tbl_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.offset = {
		61,
		-55,
		2
	}
	tbl_2.description_text_shadow = tbl_6
	tbl.style = tbl_2
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_11_1

	return tbl
end

local function fn_6(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local num = arg_12_3 / (math.pi * 2)
	local tbl = {
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
		}
	}
	local tbl_2 = {
		slot_texture = "icon_block",
		title_text = Localize("menu_weave_forge_weapon_block_title"),
		description_text = Localize("menu_weave_forge_weapon_block_description")
	}
	local flag

	flag = not arg_12_2 and "icon_block_arch_masked" and "icon_block_arch"
	tbl_2.arch_texture = flag
	tbl_2.size = arg_12_0
	tbl.content = tbl_2

	local tbl_3 = {
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
				255 * num,
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
				255 * num,
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
		}
	}
	local tbl_4 = {
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
		}
	}
	local flag_2

	flag_2 = not arg_12_2 and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_4.offset = {
		60,
		-5,
		3
	}
	tbl_3.title_text = tbl_4

	local tbl_5 = {
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
		}
	}
	local flag_3

	flag_3 = not arg_12_2 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag_3
	tbl_5.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_5.offset = {
		61,
		-6,
		2
	}
	tbl_3.title_text_shadow = tbl_5

	local tbl_6 = {
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
		}
	}
	local flag_4

	flag_4 = not arg_12_2 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_4
	tbl_6.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_6.offset = {
		60,
		-54,
		3
	}
	tbl_3.description_text = tbl_6

	local tbl_7 = {
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
		}
	}
	local flag_5

	flag_5 = not arg_12_2 and "hell_shark_masked" and "hell_shark"
	tbl_7.font_type = flag_5
	tbl_7.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_7.offset = {
		61,
		-55,
		2
	}
	tbl_3.description_text_shadow = tbl_7
	tbl.style = tbl_3
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_12_1

	return tbl
end

local function fn_7(self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local tbl = {
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
			size = self
		}
	}
	local tbl_2 = {
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
		}
	}
	local tbl_3 = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		font_size = 36,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		size = {
			50,
			self[2]
		}
	}
	local flag

	flag = not arg_13_2 and "hell_shark_masked" and "hell_shark"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_3.offset = {
		-20,
		-self[2] / 2,
		3
	}
	tbl_2.amount_text = tbl_3

	local tbl_4 = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		font_size = 36,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		size = {
			50,
			self[2]
		}
	}
	local flag_2

	flag_2 = not arg_13_2 and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_4.offset = {
		-18,
		-(self[2] / 2),
		2
	}
	tbl_2.amount_text_shadow = tbl_4

	local tbl_5 = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		font_size = 36,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		size = {
			50,
			self[2]
		}
	}
	local flag_3

	flag_3 = not arg_13_2 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag_3
	tbl_5.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_5.offset = {
		-20,
		-(self[2] / 2) + 2,
		2
	}
	tbl_2.amount_text_shadow_2 = tbl_5

	local tbl_6 = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		font_size = 36,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		size = {
			50,
			self[2]
		}
	}
	local flag_4

	flag_4 = not arg_13_2 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_4
	tbl_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.offset = {
		-20,
		-(self[2] / 2 + 2),
		2
	}
	tbl_2.amount_text_shadow_3 = tbl_6

	local tbl_7 = {
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
		}
	}
	local flag_5

	flag_5 = not arg_13_2 and "hell_shark_masked" and "hell_shark"
	tbl_7.font_type = flag_5
	tbl_7.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_7.offset = {
		60,
		-5,
		3
	}
	tbl_2.title_text = tbl_7

	local tbl_8 = {
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
		}
	}
	local flag_6

	flag_6 = not arg_13_2 and "hell_shark_masked" and "hell_shark"
	tbl_8.font_type = flag_6
	tbl_8.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_8.offset = {
		61,
		-6,
		2
	}
	tbl_2.title_text_shadow = tbl_8

	local tbl_9 = {
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
		}
	}
	local flag_7

	flag_7 = not arg_13_2 and "hell_shark_masked" and "hell_shark"
	tbl_9.font_type = flag_7
	tbl_9.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_9.offset = {
		60,
		-54,
		3
	}
	tbl_2.description_text = tbl_9

	local tbl_10 = {
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
		}
	}
	local flag_8

	flag_8 = not arg_13_2 and "hell_shark_masked" and "hell_shark"
	tbl_10.font_type = flag_8
	tbl_10.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_10.offset = {
		61,
		-55,
		2
	}
	tbl_2.description_text_shadow = tbl_10
	tbl.style = tbl_2
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_13_1

	return tbl
end

local function fn_8(self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local tbl = {
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
			size = self
		}
	}
	local tbl_2 = {}
	local tbl_3 = {
		font_size = 18,
		upper_case = true,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		size = {
			370,
			self[2]
		}
	}
	local flag

	flag = not arg_14_2 and "hell_shark_masked" and "hell_shark"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("forest_green", 255)
	tbl_3.offset = {
		0,
		-self[2] / 2,
		3
	}
	tbl_2.text = tbl_3

	local tbl_4 = {
		font_size = 18,
		upper_case = true,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		size = {
			370,
			self[2]
		}
	}
	local flag_2

	flag_2 = not arg_14_2 and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_4.offset = {
		1,
		-(self[2] / 2 + 1),
		2
	}
	tbl_2.text_shadow = tbl_4
	tbl.style = tbl_2
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_14_1

	return tbl
end

local function fn_9(arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local tbl = {
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
		}
	}
	local tbl_2 = {
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
		}
	}
	local tbl_3 = {
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
		}
	}
	local flag

	flag = not arg_15_2 and "hell_shark_masked" and "hell_shark"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_3.offset = {
		60,
		-5,
		3
	}
	tbl_2.title_text = tbl_3

	local tbl_4 = {
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
		}
	}
	local flag_2

	flag_2 = not arg_15_2 and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_4.offset = {
		61,
		-6,
		2
	}
	tbl_2.title_text_shadow = tbl_4

	local tbl_5 = {
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
		}
	}
	local flag_3

	flag_3 = not arg_15_2 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag_3
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_5.offset = {
		60,
		-54,
		3
	}
	tbl_2.description_text = tbl_5

	local tbl_6 = {
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
		}
	}
	local flag_4

	flag_4 = not arg_15_2 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_4
	tbl_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.offset = {
		61,
		-55,
		2
	}
	tbl_2.description_text_shadow = tbl_6
	tbl.style = tbl_2
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_15_1

	return tbl
end

local function fn_10(self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local tbl = {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "ammunition_texture",
					texture_id = "ammunition_texture"
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
			ammunition_texture = "icon_ammo",
			amount_text = arg_16_3 or "-",
			title_text = Localize("menu_weave_forge_weapon_ammo_regular_title"),
			description_text = Localize("menu_weave_forge_weapon_ammo_regular_description"),
			size = self
		}
	}
	local tbl_2 = {
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
		}
	}
	local tbl_3 = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		font_size = 36,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		size = {
			60,
			self[2]
		}
	}
	local flag

	flag = not arg_16_2 and "hell_shark_masked" and "hell_shark"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_3.offset = {
		-8,
		-self[2] / 2,
		3
	}
	tbl_2.amount_text = tbl_3

	local tbl_4 = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		font_size = 36,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		size = {
			60,
			self[2]
		}
	}
	local flag_2

	flag_2 = not arg_16_2 and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_4.offset = {
		-6,
		-(self[2] / 2),
		2
	}
	tbl_2.amount_text_shadow = tbl_4

	local tbl_5 = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		font_size = 36,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		size = {
			60,
			self[2]
		}
	}
	local flag_3

	flag_3 = not arg_16_2 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag_3
	tbl_5.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_5.offset = {
		-8,
		-(self[2] / 2) + 2,
		2
	}
	tbl_2.amount_text_shadow_2 = tbl_5

	local tbl_6 = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		font_size = 36,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		size = {
			60,
			self[2]
		}
	}
	local flag_4

	flag_4 = not arg_16_2 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_4
	tbl_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.offset = {
		-8,
		-(self[2] / 2 + 2),
		2
	}
	tbl_2.amount_text_shadow_3 = tbl_6

	local tbl_7 = {
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
		}
	}
	local flag_5

	flag_5 = not arg_16_2 and "hell_shark_masked" and "hell_shark"
	tbl_7.font_type = flag_5
	tbl_7.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_7.offset = {
		60,
		-5,
		3
	}
	tbl_2.title_text = tbl_7

	local tbl_8 = {
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
		}
	}
	local flag_6

	flag_6 = not arg_16_2 and "hell_shark_masked" and "hell_shark"
	tbl_8.font_type = flag_6
	tbl_8.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_8.offset = {
		61,
		-6,
		2
	}
	tbl_2.title_text_shadow = tbl_8

	local tbl_9 = {
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
		}
	}
	local flag_7

	flag_7 = not arg_16_2 and "hell_shark_masked" and "hell_shark"
	tbl_9.font_type = flag_7
	tbl_9.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_9.offset = {
		60,
		-54,
		3
	}
	tbl_2.description_text = tbl_9

	local tbl_10 = {
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
		}
	}
	local flag_8

	flag_8 = not arg_16_2 and "hell_shark_masked" and "hell_shark"
	tbl_10.font_type = flag_8
	tbl_10.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_10.offset = {
		61,
		-55,
		2
	}
	tbl_2.description_text_shadow = tbl_10
	tbl.style = tbl_2
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_16_1

	return tbl
end

local flag = true
local tbl_13 = {
	top_hdr_background_write_mask = UIWidgets.create_simple_texture("ui_write_mask", "window"),
	upgrade_bg = UIWidgets.create_simple_texture("weave_menu_athanor_upgrade_bg", "upgrade_bg")
}
local tbl_14 = {
	upgrade_effect = UIWidgets.create_simple_texture("athanor_item_unlock", "upgrade_effect")
}
local tbl_15 = {}
local tbl_16 = {
	upgrade_text = UIWidgets.create_simple_text(Localize("menu_weave_weapon_forged_unlocked"), "upgrade_text", nil, nil, tbl_8),
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
	viewport_level_title = UIWidgets.create_simple_text(Localize("menu_weave_forge_magic_level_title"), "panel_level_title", nil, nil, tbl_9),
	viewport_level_value = UIWidgets.create_simple_text("0", "panel_level_value", nil, nil, tbl_10),
	viewport_power_title = UIWidgets.create_simple_text(Localize("menu_weave_forge_loadout_power_title"), "panel_power_title", nil, nil, tbl_9),
	viewport_power_value = UIWidgets.create_simple_text("0", "panel_power_value", nil, nil, tbl_10),
	viewport_title = UIWidgets.create_simple_text("", "viewport_title", nil, nil, tbl_11),
	viewport_sub_title = UIWidgets.create_simple_text("", "viewport_sub_title", nil, nil, tbl_12),
	weapon_list_background = UIWidgets.create_rect_with_outer_frame("weapon_list_background", tbl_7.weapon_list_background.size, "shadow_frame_02", nil, {
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
	weapon_list_scrollbar = UIWidgets.create_chain_scrollbar("weapon_list_scrollbar", "weapon_list_window", tbl_7.weapon_list_scrollbar.size),
	weapon_list_mask = fn_2("weapon_list_window", tbl_7.weapon_list_window.size, 10),
	stats_list_background = UIWidgets.create_rect_with_outer_frame("stats_list_background", tbl_7.stats_list_background.size, "shadow_frame_02", nil, {
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
	stats_list_scrollbar = UIWidgets.create_chain_scrollbar("stats_list_scrollbar", "stats_list_window", tbl_7.stats_list_scrollbar.size),
	stats_list_mask = fn_2("stats_list_window", tbl_7.stats_list_window.size, 10),
	equip_button = UIWidgets.create_default_button("equip_button", tbl_7.equip_button.size, nil, nil, Localize("input_description_equip"), 26, nil, "button_detail_02"),
	customize_button = UIWidgets.create_default_button("customize_button", tbl_7.customize_button.size, nil, nil, Localize("menu_weave_forge_customize_loadout_button"), 26, nil, "button_detail_02"),
	unlock_button = UIWidgets.create_athanor_upgrade_button("unlock_button", tbl_7.unlock_button.size, "athanor_icon_unlock", Localize("menu_weave_forge_unlock_weapon_button"), 24)
}
local tbl_17 = {
	upgrade = {
		{
			name = "fade_in_text_panel",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				local upgrade_bg = arg_17_2.upgrade_bg
				local upgrade_text = arg_17_2.upgrade_text

				upgrade_bg.alpha_multiplier = 0
				upgrade_text.alpha_multiplier = 0
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				-- function 18
				local easeOutCubic = math.easeOutCubic(arg_18_3)
				local upgrade_bg = arg_18_2.upgrade_bg
				local upgrade_text = arg_18_2.upgrade_text

				upgrade_bg.alpha_multiplier = easeOutCubic
				upgrade_text.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end
		},
		{
			name = "fade_out_text_panel",
			start_progress = 1,
			end_progress = 2,
			init = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				return
			end,
			update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				-- function 21
				local easeInCubic = math.easeInCubic(1 - arg_21_3)
				local upgrade_bg = arg_21_2.upgrade_bg
				local upgrade_text = arg_21_2.upgrade_text

				upgrade_bg.alpha_multiplier = easeInCubic
				upgrade_text.alpha_multiplier = easeInCubic
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				return
			end
		},
		{
			name = "font_offset",
			start_progress = 0,
			end_progress = 2,
			init = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				-- function 23
				return
			end,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				-- function 24
				local easeOutCubic = math.easeOutCubic(arg_24_3)

				arg_24_2.upgrade_text.offset[2] = -40 + 50 * easeOutCubic
			end,
			on_complete = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				return
			end
		},
		{
			name = "font_panel_size_increase",
			start_progress = 0,
			end_progress = 4,
			init = function (self, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				local scenegraph_id = arg_26_2.upgrade_bg.scenegraph_id
				local size = arg_26_1[scenegraph_id].size
				local size_2 = self[scenegraph_id].size

				size_2[1] = size[1]
				size_2[2] = size[2]
			end,
			update = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				-- function 27
				local easeOutCubic = math.easeOutCubic(arg_27_3)
				local scenegraph_id = arg_27_2.upgrade_bg.scenegraph_id
				local size = arg_27_1[scenegraph_id].size
				local size_2 = self[scenegraph_id].size

				size_2[1] = size[1] + 200 * (1 - easeOutCubic)
				size_2[2] = size[2] + 200 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				return
			end
		},
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.25,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				arg_29_2.upgrade_effect.alpha_multiplier = 0
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				-- function 30
				local easeOutCubic = math.easeOutCubic(arg_30_3)

				arg_30_2.upgrade_effect.alpha_multiplier = 1
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 0.75,
			end_progress = 1.5,
			init = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				-- function 32
				return
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				-- function 33
				local easeInCubic = math.easeInCubic(arg_33_3)

				arg_33_2.upgrade_effect.alpha_multiplier = math.max(1 - easeInCubic, 0.01)
			end,
			on_complete = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				return
			end
		},
		{
			name = "size_in",
			start_progress = 0,
			end_progress = 2,
			init = function (self, arg_35_1, arg_35_2, arg_35_3)
				-- function 35
				local scenegraph_id = arg_35_2.upgrade_effect.scenegraph_id
				local var_35_1 = arg_35_1[scenegraph_id]
				local var_35_2 = self[scenegraph_id]
				local size = var_35_1.size
				local size_2 = var_35_2.size
			end,
			update = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				-- function 36
				local easeOutCubic = math.easeOutCubic(arg_36_3)
				local scenegraph_id = arg_36_2.upgrade_effect.scenegraph_id
				local var_36_2 = arg_36_1[scenegraph_id]
				local var_36_3 = self[scenegraph_id]
				local size = var_36_2.size

				var_36_3.size[2] = size[2] + size[2] * 10 * easeOutCubic
			end,
			on_complete = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
				return
			end
		},
		{
			name = "intensity_out",
			start_progress = 1,
			end_progress = 1.5,
			init = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				-- function 38
				local gui = arg_38_3.parent:hdr_renderer().gui
				local texture_id = arg_38_2.upgrade_effect.content.texture_id
				local material = Gui.material(gui, texture_id)
				local num = 0.4

				Material.set_scalar(material, "intensity", num)
			end,
			update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				-- function 39
				local easeOutCubic = math.easeOutCubic(1 - arg_39_3)
				local gui = arg_39_4.parent:hdr_renderer().gui
				local texture_id = arg_39_2.upgrade_effect.content.texture_id
				local material = Gui.material(gui, texture_id)
				local num = 0
				local num_2 = 0.4
				local num_3 = num + math.clamp(easeOutCubic, 0, 1) * num_2

				Material.set_scalar(material, "intensity", num_3)
			end,
			on_complete = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				return
			end
		}
	},
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				-- function 41
				arg_41_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
				-- function 42
				local easeOutCubic = math.easeOutCubic(arg_42_3)

				arg_42_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				-- function 43
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				-- function 44
				arg_44_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
				-- function 45
				local easeOutCubic = math.easeOutCubic(arg_45_3)

				arg_45_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				-- function 46
				return
			end
		}
	}
}

return {
	top_widgets = tbl_16,
	bottom_widgets = tbl_15,
	top_hdr_widgets = tbl_13,
	bottom_hdr_widgets = tbl_14,
	create_trait_option = fn_5,
	create_divider_option = fn_3,
	create_property_option = fn_4,
	create_item_block_option = fn_6,
	create_item_stamina_option = fn_7,
	create_item_ammunition_option = fn_10,
	create_item_overheat_option = fn_9,
	create_item_keywords_option = fn_8,
	create_weapon_entry_widget = fn,
	scenegraph_definition = tbl_7,
	animation_definitions = tbl_17
}
