-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_area_selection_console_v2_definitions.lua

local game_start_windows = UISettings.game_start_windows
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local tbl = {
	size[1] * 3 + spacing * 2,
	size[2]
}
local tbl_2 = {
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
local tbl_3 = {
	5,
	3
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
			0
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
			0
		}
	},
	background = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			2
		}
	},
	video = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			1
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
		size = {
			1960,
			1080
		},
		position = {
			0,
			0,
			1
		}
	},
	foreground = {
		parent = "window",
		position = {
			0,
			0,
			2
		}
	},
	area_root = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			220,
			2
		}
	},
	title_divider = {
		vertical_alignment = "bottom",
		parent = "area_root",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-160,
			1
		}
	},
	area_title = {
		vertical_alignment = "bottom",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			135,
			150,
			10
		}
	},
	description_text = {
		vertical_alignment = "bottom",
		parent = "menu_root",
		horizontal_alignment = "left",
		size = {
			1200,
			150
		},
		position = {
			135,
			190,
			2
		}
	},
	campaign_text = {
		vertical_alignment = "top",
		parent = "menu_root",
		horizontal_alignment = "left",
		position = {
			256,
			-440,
			5
		},
		size = {
			0,
			0
		}
	},
	side_quests_text = {
		vertical_alignment = "top",
		parent = "campaign_text",
		horizontal_alignment = "left",
		position = {
			206,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	not_owned_text = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			800,
			50
		},
		position = {
			0,
			150,
			12
		}
	},
	requirements_not_met_text = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			800,
			50
		},
		position = {
			0,
			200,
			12
		}
	}
}
local tbl_5 = {
	word_wrap = true,
	upper_case = true,
	localize = true,
	use_shadow = true,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		3
	}
}
local tbl_6 = {
	word_wrap = true,
	upper_case = true,
	localize = true,
	use_shadow = true,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		3
	}
}
local tbl_7 = {
	word_wrap = true,
	localize = false,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	draw_text_rect = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	rect_color = Colors.get_color_table_with_alpha("black", 150),
	offset = {
		0,
		0,
		3
	}
}
local tbl_8 = {
	font_size = 72,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_9 = {
	font_size = 32,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_10 = {
	font_size = 32,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_11 = {
	font_size = 28,
	upper_case = false,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	area_size = {
		1200,
		1080
	},
	offset = {
		0,
		0,
		2
	}
}

local function fn()
	-- function 7
	local tbl = {
		250,
		250
	}
	local str = "area_root_main_campaign"

	tbl_4[str] = {
		vertical_alignment = "center",
		parent = "area_root",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			0,
			100,
			1
		}
	}

	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
		{
			style_id = "icon",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "icon_glow",
			texture_id = "icon_glow"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon"
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function (self)
				-- function 8
				return self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local tbl_5 = {
		locked = true,
		frame = "map_frame_04",
		icon = "level_icon_01",
		lock = "hero_icon_locked_gold",
		icon_glow = "map_frame_glow_02",
		button_hotspot = {},
		divider = {
			texture_id = "menu_divider",
			uvs = {
				{
					0,
					1
				},
				{
					1,
					0
				}
			}
		}
	}
	local tbl_6 = {
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = tbl,
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
				76,
				87
			},
			offset = {
				64,
				-58,
				9
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
				tbl[1] * 168 / 180,
				tbl[2] * 168 / 180
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
		icon_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				tbl[1] * 270 / 180,
				tbl[2] * 270 / 180
			},
			offset = {
				0,
				0,
				3
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		divider = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			texture_size = {
				2,
				100
			},
			offset = {
				tbl[1] * 0.15,
				0,
				0
			},
			color = {
				192,
				255,
				255,
				255
			}
		},
		divider_top = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			texture_size = {
				2,
				tbl[2]
			},
			offset = {
				tbl[1] * 0.15,
				tbl[2] * 0.5,
				0
			},
			color = {
				192,
				255,
				255,
				255
			}
		},
		divider_bottom = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			texture_size = {
				2,
				tbl[2]
			},
			offset = {
				tbl[1] * 0.15,
				-tbl[2] * 0.5,
				0
			},
			color = {
				192,
				255,
				255,
				255
			}
		}
	}

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_5
	tbl_2.style = tbl_6
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = str

	return tbl_2
end

local function fn_2(arg_9_0, arg_9_1)
	-- function 9
	local var_9_0 = arg_9_1
	local tbl = {
		150,
		150
	}

	if not var_9_0 then
		var_9_0 = "area_root_" .. arg_9_0
		tbl_4[var_9_0] = {
			vertical_alignment = "center",
			parent = "area_root",
			horizontal_alignment = "center",
			size = tbl,
			position = {
				0,
				100,
				1
			}
		}
	end

	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
		{
			style_id = "icon",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "icon_glow",
			texture_id = "icon_glow"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon"
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function (self)
				-- function 10
				return self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local tbl_5 = {
		locked = true,
		frame = "map_frame_04",
		icon = "level_icon_01",
		lock = "hero_icon_locked_gold",
		icon_glow = "map_frame_glow_02",
		button_hotspot = {}
	}
	local tbl_6 = {
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = tbl,
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
				76,
				87
			},
			offset = {
				64,
				-58,
				9
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
				tbl[1] * 168 / 180,
				tbl[2] * 168 / 180
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
		icon_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				tbl[1] * 270 / 180,
				tbl[2] * 270 / 180
			},
			offset = {
				0,
				0,
				3
			},
			color = {
				0,
				255,
				255,
				255
			}
		}
	}

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_5
	tbl_2.style = tbl_6
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = var_9_0

	return tbl_2
end

local function fn_3()
	-- function 11
	local tbl = {
		420,
		1080
	}
	local str = "left_fade"

	tbl_4[str] = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			0,
			0,
			3
		}
	}

	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
		{
			style_id = "left_fade",
			pass_type = "texture_uv",
			content_id = "left_fade"
		}
	}
	local tbl_5 = {
		left_fade = {
			texture_id = "gradient",
			uvs = {
				{
					0,
					0
				},
				{
					1,
					1
				}
			}
		}
	}
	local tbl_6 = {
		left_fade = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			texture_size = {
				tbl[1],
				1080
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-960 + tbl[1] * 0.5,
				0
			}
		}
	}

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_5
	tbl_2.style = tbl_6
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = str

	return tbl_2
end

local function fn_4(arg_12_0, arg_12_1)
	-- function 12
	local button_frame_01_gold

	if not arg_12_1 then
		button_frame_01_gold = UIFrameSettings.button_frame_01_gold

		if not button_frame_01_gold then
			-- Nothing
		end
	end

	button_frame_01_gold = UIFrameSettings.button_frame_01

	::label_12_0::

	arg_12_0 = not UIAtlasHelper.has_atlas_settings_by_texture_name(arg_12_0) and arg_12_0 and "any_small_image"

	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			texture_id = "level_image",
			style_id = "level_image",
			pass_type = "texture"
		},
		{
			texture_id = "frame",
			style_id = "frame",
			pass_type = "texture_frame"
		},
		{
			texture_id = "sigil",
			style_id = "sigil",
			pass_type = "texture",
			content_check_function = function (self, arg_13_1)
				-- function 13
				return self.completed
			end
		},
		{
			texture_id = "sigil",
			style_id = "sigil_shadow",
			pass_type = "texture",
			content_check_function = function (self, arg_14_1)
				-- function 14
				return self.completed
			end
		},
		{
			texture_id = "sigil_ribbon",
			style_id = "sigil_ribbon",
			pass_type = "texture",
			content_check_function = function (self, arg_15_1)
				-- function 15
				return self.completed
			end
		},
		{
			texture_id = "sigil_ribbon",
			style_id = "sigil_ribbon_shadow",
			pass_type = "texture",
			content_check_function = function (self, arg_16_1)
				-- function 16
				return self.completed
			end
		},
		{
			texture_id = "boss_icon",
			style_id = "boss_icon",
			pass_type = "texture",
			content_check_function = function (self, arg_17_1)
				-- function 17
				return self.boss_level
			end
		}
	}
	local tbl_3 = {
		completed = false,
		boss_icon = "boss_icon",
		boss_level = true,
		sigil_ribbon = "store_owned_ribbon",
		sigil = "store_owned_sigil",
		level_image = arg_12_0,
		frame = button_frame_01_gold.texture
	}
	local tbl_4 = {
		level_image = {
			vertical_alignment = "bottom",
			saturated = true,
			horizontal_alignment = "left",
			texture_size = {
				97,
				58
			},
			color = {
				255,
				255,
				255,
				255
			},
			locked_color = {
				255,
				96,
				96,
				96
			},
			unlocked_color = {
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
		sigil = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				39.75,
				39.75
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				1.625,
				-10.875,
				4
			}
		},
		sigil_shadow = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				39.75,
				39.75
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				3.625,
				-12.875,
				3
			}
		},
		sigil_ribbon = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				25.5,
				37.5
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				8.75,
				-29.75,
				2
			}
		},
		sigil_ribbon_shadow = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				25.5,
				37.5
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				10.75,
				-45.25,
				1
			}
		},
		boss_icon = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				34,
				34
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				69.8,
				-6.800000000000001,
				3
			}
		},
		frame = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			area_size = {
				97,
				58
			},
			texture_size = button_frame_01_gold.texture_size,
			texture_sizes = button_frame_01_gold.texture_sizes,
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
	}

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		-68,
		0
	}
	tbl.scenegraph_id = "area_title"

	return tbl
end

local function fn_5()
	-- function 18
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text",
			content_change_function = function (self, arg_19_1)
				-- function 19
				local offset = arg_19_1.offset
				local flag

				flag = self.locked or not self.dlc or 36 or 0
				offset[1] = flag
			end
		},
		{
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text",
			content_change_function = function (self, arg_20_1)
				-- function 20
				local offset = arg_20_1.offset
				local flag

				flag = self.locked or not self.dlc or 36.9 or 0
				offset[1] = flag
			end
		},
		{
			texture_id = "lock",
			style_id = "lock",
			pass_type = "texture",
			content_check_function = function (self, arg_21_1)
				-- function 21
				local locked = self.locked

				locked = not locked and not self.dlc

				return locked
			end
		},
		{
			texture_id = "lock_dlc",
			style_id = "lock",
			pass_type = "texture",
			content_check_function = function (self, arg_22_1)
				-- function 22
				local locked = self.locked

				locked = not locked and self.dlc_locked

				return locked
			end
		}
	}
	local tbl_3 = {
		text = "area_selection_campaign",
		locked = true,
		lock = "hero_icon_locked",
		dlc_locked = true,
		lock_dlc = "hero_icon_locked_gold"
	}
	local tbl_4 = {
		text = {
			word_wrap = false,
			upper_case = false,
			localize = true,
			font_size = 28,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				0,
				80,
				2
			}
		},
		text_shadow = {
			word_wrap = false,
			upper_case = false,
			localize = true,
			font_size = 28,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				78,
				1
			}
		},
		lock = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				34.2,
				39.15
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				82,
				0
			}
		}
	}

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = "area_title"

	return tbl
end

local tbl_12 = {
	background = UIWidgets.create_simple_rect("background", {
		255,
		0,
		0,
		0
	}),
	foreground = UIWidgets.create_simple_rect("foreground", {
		255,
		0,
		0,
		0
	}),
	window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "video", nil, nil, nil, 2),
	left_fade = fn_3(),
	campaign = UIWidgets.create_simple_text(Localize("area_selection_campaign"), "campaign_text", nil, nil, tbl_9),
	area_title = UIWidgets.create_simple_text("area_title", "area_title", nil, nil, tbl_8),
	area_desc = UIWidgets.create_simple_text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut fringilla in nulla eu rutrum. Etiam non dapibus orci, sit amet tempus tortor. Mauris porttitor finibus quam eget tempor. Cras sed dui bibendum, gravida quam a, sodales justo. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut fringilla in nulla eu rutrum. Etiam non dapibus orci, sit amet tempus tortor. Mauris porttitor finibus quam eget tempor. Cras sed dui bibendum, gravida quam a, sodales justo. ", "description_text", nil, nil, tbl_11),
	area_type = fn_5(),
	title_divider = UIWidgets.create_simple_texture("edge_divider_04_horizontal", "area_title", nil, nil, nil, nil, {
		tbl_11.area_size[1] * 0.9,
		8
	})
}
local tbl_13 = {}

for i = 1, 20 do
	tbl_13[i] = fn_2(i)
end

return {
	widgets = tbl_12,
	area_widgets = tbl_13,
	create_level_image_func = fn_4,
	main_campaign_widget = fn(),
	map_size = tbl,
	scenegraph_definition = tbl_4,
	animation_definitions = tbl_2,
	grid_settings = tbl_3
}
