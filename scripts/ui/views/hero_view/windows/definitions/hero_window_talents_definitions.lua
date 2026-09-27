-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_talents_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local var_0_5 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local num = size[1] * 2 + spacing * 2
local num_2 = size[1] - (var_0_5 * 2 + 60)
local tbl = {
	size[1] * 2 + spacing,
	size[2]
}
local tbl_2 = {
	math.floor(tbl[1] / 2 - 10),
	160
}
local tbl_3 = {
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
	window_frame = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			0,
			0,
			1
		}
	},
	career_window = {
		vertical_alignment = "top",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 20,
			tbl_2[2] + 40
		},
		position = {
			0,
			-10,
			1
		}
	},
	career_window_edge = {
		vertical_alignment = "bottom",
		parent = "career_window",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 20,
			0
		},
		position = {
			0,
			40,
			1
		}
	},
	career_window_center_edge = {
		vertical_alignment = "top",
		parent = "career_window",
		horizontal_alignment = "center",
		size = {
			0,
			tbl_2[2] - 5
		},
		position = {
			0,
			-5,
			1
		}
	},
	passive_window = {
		vertical_alignment = "top",
		parent = "career_window",
		horizontal_alignment = "left",
		size = tbl_2,
		position = {
			0,
			0,
			1
		}
	},
	passive_icon = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "left",
		size = {
			80,
			80
		},
		position = {
			10,
			-50,
			5
		}
	},
	passive_icon_frame = {
		vertical_alignment = "center",
		parent = "passive_icon",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	passive_title_text = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "left",
		size = {
			tbl_2[1] * 0.6,
			50
		},
		position = {
			10,
			-5,
			1
		}
	},
	passive_title_divider = {
		vertical_alignment = "bottom",
		parent = "passive_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	passive_type_title = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "right",
		size = {
			tbl_2[1] * 0.3,
			50
		},
		position = {
			-10,
			-5,
			1
		}
	},
	passive_description_text = {
		vertical_alignment = "top",
		parent = "passive_icon",
		horizontal_alignment = "left",
		size = {
			tbl_2[1] - 110,
			tbl_2[2] - 50
		},
		position = {
			90,
			0,
			1
		}
	},
	active_window = {
		vertical_alignment = "top",
		parent = "career_window",
		horizontal_alignment = "right",
		size = tbl_2,
		position = {
			0,
			0,
			1
		}
	},
	active_icon = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "left",
		size = {
			80,
			80
		},
		position = {
			10,
			-50,
			5
		}
	},
	active_icon_frame = {
		vertical_alignment = "center",
		parent = "active_icon",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	active_title_text = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "left",
		size = {
			tbl_2[1] * 0.6,
			50
		},
		position = {
			10,
			-5,
			1
		}
	},
	active_title_divider = {
		vertical_alignment = "bottom",
		parent = "active_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	active_type_title = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "right",
		size = {
			tbl_2[1] * 0.3,
			50
		},
		position = {
			-10,
			-5,
			1
		}
	},
	active_description_text = {
		vertical_alignment = "top",
		parent = "active_icon",
		horizontal_alignment = "left",
		size = {
			tbl_2[1] - 110,
			tbl_2[2] - 50
		},
		position = {
			90,
			0,
			1
		}
	},
	career_perks = {
		vertical_alignment = "bottom",
		parent = "career_window",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 40,
			40
		},
		position = {
			0,
			10,
			4
		}
	},
	career_perk_1 = {
		vertical_alignment = "center",
		parent = "career_perks",
		horizontal_alignment = "center",
		size = {
			200,
			40
		},
		position = {
			-350,
			-6,
			1
		}
	},
	career_perk_2 = {
		vertical_alignment = "center",
		parent = "career_perks",
		horizontal_alignment = "center",
		size = {
			200,
			40
		},
		position = {
			0,
			-6,
			1
		}
	},
	career_perk_3 = {
		vertical_alignment = "center",
		parent = "career_perks",
		horizontal_alignment = "center",
		size = {
			200,
			40
		},
		position = {
			350,
			-6,
			1
		}
	},
	talent_title_text = {
		vertical_alignment = "bottom",
		parent = "career_window",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			50
		},
		position = {
			0,
			-50,
			1
		}
	},
	talent_title_divider = {
		vertical_alignment = "bottom",
		parent = "talent_title_text",
		horizontal_alignment = "center",
		size = {
			264,
			21
		},
		position = {
			0,
			-10,
			1
		}
	},
	talents_window = {
		vertical_alignment = "bottom",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			505
		},
		position = {
			0,
			0,
			1
		}
	},
	talent_row_1 = {
		vertical_alignment = "bottom",
		parent = "talent_row_2",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_2 = {
		vertical_alignment = "bottom",
		parent = "talent_row_3",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_3 = {
		vertical_alignment = "bottom",
		parent = "talent_row_4",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_4 = {
		vertical_alignment = "bottom",
		parent = "talent_row_5",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_5 = {
		vertical_alignment = "bottom",
		parent = "talent_row_6",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_6 = {
		vertical_alignment = "bottom",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 20,
			80
		},
		position = {
			0,
			10,
			5
		}
	}
}
local tbl_4 = {
	font_size = 42,
	upper_case = true,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_5 = {
	font_size = 17,
	use_shadow = true,
	localize = false,
	dynamic_font_size_word_wrap = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_6 = {
	word_wrap = true,
	use_shadow = true,
	localize = false,
	font_size = 18,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("gray", 200),
	offset = {
		0,
		0,
		2
	}
}
local tbl_7 = {
	font_size = 32,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_8 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		-6,
		2
	}
}

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	local var_1_0

	if not arg_1_5 then
		var_1_0 = "button_" .. arg_1_5
	else
		var_1_0 = "button_normal"
	end

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(var_1_0, 255)
	local str = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl = {
		element = {
			passes = {
				{
					style_id = "button_background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "button_background",
					pass_type = "texture_uv",
					content_id = "button_background"
				},
				{
					texture_id = "bottom_edge",
					style_id = "button_edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "glass_top",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 2
						local button_hotspot = self.button_hotspot
						local is_selected

						if not button_hotspot.disable_button then
							is_selected = button_hotspot.is_selected

							if not is_selected then
								is_selected = button_hotspot.is_hover
							end
						else
							is_selected = false
						end

						if false then
							is_selected = true
						end

						return is_selected
					end
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 3
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 4
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_shadow",
					pass_type = "text",
					text_id = "button_text"
				},
				{
					style_id = "button_clicked_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 5
						local is_clicked = self.button_hotspot.is_clicked

						return not is_clicked and is_clicked == 0
					end
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 6
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture",
					content_check_function = function (self)
						-- function 7
						return self.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 8
						return self.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 9
						return self.use_bottom_edge
					end
				}
			}
		}
	}
	local tbl_2 = {
		edge_holder_left = "menu_frame_09_divider_left",
		edge_holder_right = "menu_frame_09_divider_right",
		glass_top = "button_glass_01",
		bottom_edge = "menu_frame_09_divider",
		use_bottom_edge = arg_1_4,
		button_hotspot = {},
		button_text = arg_1_2 or "n/a"
	}
	local str_2

	if not arg_1_5 then
		str_2 = "button_state_hover_" .. arg_1_5

		if not str_2 then
			-- Nothing
		end
	end

	str_2 = "button_state_hover"

	::label_1_0::

	tbl_2.hover_glow = str_2

	local str_3

	if not arg_1_5 then
		str_3 = "button_state_normal_" .. arg_1_5

		if not str_3 then
			-- Nothing
		end
	end

	str_3 = "button_state_normal"

	::label_1_1::

	tbl_2.glow = str_3
	tbl_2.button_background = {
		uvs = {
			{
				0,
				1 - math.min(arg_1_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
			},
			{
				math.min(arg_1_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
				1
			}
		},
		texture_id = str
	}
	tbl.content = tbl_2
	tbl.style = {
		button_background = {
			color = get_color_table_with_alpha,
			offset = {
				0,
				0,
				2
			},
			size = arg_1_1
		},
		button_edge = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				arg_1_1[2],
				3
			},
			size = {
				arg_1_1[1],
				5
			},
			texture_tiling_size = {
				1,
				5
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
				arg_1_1[2] - 4,
				3
			},
			size = {
				arg_1_1[1],
				5
			}
		},
		glow = {
			color = {
				255,
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
				arg_1_1[1],
				arg_1_1[2] - 5
			}
		},
		hover_glow = {
			color = {
				255,
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
				arg_1_1[1],
				arg_1_1[2] - 5
			}
		},
		bottom_edge = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				5,
				0,
				6
			},
			size = {
				arg_1_1[1] - 10,
				5
			},
			texture_tiling_size = {
				1,
				5
			}
		},
		edge_holder_left = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				3,
				-6,
				10
			},
			size = {
				9,
				17
			}
		},
		edge_holder_right = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_1_1[1] - 12,
				-6,
				10
			},
			size = {
				9,
				17
			}
		},
		button_text = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_1_3 or 24,
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				0,
				5,
				4
			},
			size = arg_1_1
		},
		button_text_disabled = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_1_3 or 24,
			text_color = Colors.get_color_table_with_alpha("gray", 255),
			offset = {
				0,
				5,
				4
			},
			size = arg_1_1
		},
		button_text_shadow = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_1_3 or 24,
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				3,
				3
			},
			size = arg_1_1
		},
		button_clicked_rect = {
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				5,
				0,
				5
			},
			size = {
				arg_1_1[1] - 10,
				arg_1_1[2]
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
				5,
				0,
				5
			},
			size = {
				arg_1_1[1] - 10,
				arg_1_1[2]
			}
		}
	}
	tbl.scenegraph_id = arg_1_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

local function fn_2(arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	local menu_frame_09 = UIFrameSettings.menu_frame_09
	local str = "frame_outer_glow_01"
	local var_10_2 = UIFrameSettings[str]
	local var_10_3 = var_10_2.texture_sizes.corner[1]
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame_lock",
			texture_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock"
		},
		{
			pass_type = "rect",
			style_id = "lock_rect"
		},
		{
			style_id = "level_text",
			pass_type = "text",
			text_id = "level_text"
		},
		{
			style_id = "level_text_shadow",
			pass_type = "text",
			text_id = "level_text"
		},
		{
			texture_id = "glow_frame",
			style_id = "glow_frame",
			pass_type = "texture_frame"
		}
	}
	local tbl_3 = {
		level_text = "0",
		lock = "talent_lock_fg",
		amount = arg_10_2,
		frame = menu_frame_09.texture,
		glow_frame = var_10_2.texture
	}
	local tbl_4 = {
		frame = {
			texture_size = menu_frame_09.texture_size,
			texture_sizes = menu_frame_09.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				arg_10_1[1],
				arg_10_1[2]
			},
			offset = {
				0,
				0,
				5
			}
		},
		frame_lock = {
			texture_size = menu_frame_09.texture_size,
			texture_sizes = menu_frame_09.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				103,
				arg_10_1[2]
			},
			offset = {
				0,
				0,
				3
			}
		},
		glow_frame = {
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				-2
			},
			size = arg_10_1,
			texture_size = var_10_2.texture_size,
			texture_sizes = var_10_2.texture_sizes,
			frame_margins = {
				-(var_10_3 - 1),
				-(var_10_3 - 1)
			}
		},
		lock_rect = {
			color = {
				100,
				0,
				0,
				0
			},
			size = {
				100,
				arg_10_1[2]
			},
			offset = {
				0,
				0,
				0
			}
		},
		lock = {
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				97,
				arg_10_1[2]
			},
			offset = {
				3,
				2,
				1
			}
		},
		level_text = {
			word_wrap = true,
			font_size = 26,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				97,
				97
			},
			offset = {
				3,
				-12,
				3
			}
		},
		level_text_shadow = {
			word_wrap = true,
			font_size = 26,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				97,
				97
			},
			offset = {
				5,
				-14,
				2
			}
		}
	}
	local num = 0
	local num_2 = 0
	local tbl_5 = {
		314,
		arg_10_1[2]
	}
	local tbl_6 = {
		80,
		80
	}
	local num_3 = arg_10_1[1] - (tbl_5[1] * arg_10_2 + num * (arg_10_2 - 1))

	for i = 1, arg_10_2 do
		local str_2 = "_" .. tostring(i)
		local num_4 = i - 1
		local tbl_7 = {
			num_3,
			0,
			num_2
		}
		local str_3 = "hotspot" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "hotspot",
			content_id = str_3,
			style_id = str_3
		}
		tbl_4[str_3] = {
			size = tbl_5,
			offset = tbl_7
		}
		tbl_3[str_3] = {}

		local var_10_17 = tbl_3[str_3]
		local str_4 = "background" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "rect",
			style_id = str_4
		}
		tbl_4[str_4] = {
			size = tbl_5,
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				tbl_7[1],
				tbl_7[2],
				0
			}
		}

		local str_5 = "frame" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture_frame",
			texture_id = str_5,
			style_id = str_5
		}
		tbl_4[str_5] = {
			texture_size = menu_frame_09.texture_size,
			texture_sizes = menu_frame_09.texture_sizes,
			size = tbl_5,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2],
				7
			}
		}
		tbl_3[str_5] = menu_frame_09.texture

		local str_6 = "selected" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			texture_id = str_6,
			style_id = str_6,
			content_check_function = function (self)
				-- function 11
				return self[str_3].is_selected
			end
		}
		tbl_4[str_6] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				318,
				80
			},
			size = tbl_5,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2],
				28
			}
		}
		tbl_3[str_6] = "talent_selected"

		local str_7 = "title_text" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			text_id = str_7,
			style_id = str_7,
			content_check_function = function (self)
				-- function 12
				local var_12_0 = self[str_3]

				return not not var_12_0.is_selected or not var_12_0.disabled
			end
		}
		tbl_4[str_7] = {
			word_wrap = true,
			font_size = 24,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				tbl_5[1] - 100,
				tbl_5[2]
			},
			offset = {
				tbl_7[1] + 90,
				tbl_7[2],
				3
			}
		}
		tbl_3[str_7] = "n/a"

		local str_8 = "title_text_selected" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			text_id = str_7,
			style_id = str_8,
			content_check_function = function (self)
				-- function 13
				local var_13_0 = self[str_3]
				local is_selected = var_13_0.is_selected

				is_selected = not is_selected and not var_13_0.disabled

				return is_selected
			end
		}
		tbl_4[str_8] = {
			word_wrap = true,
			font_size = 24,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			size = {
				tbl_5[1] - 100,
				tbl_5[2]
			},
			offset = {
				tbl_7[1] + 90,
				tbl_7[2],
				3
			}
		}

		local str_9 = "title_text_disabled" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			text_id = str_7,
			style_id = str_9,
			content_check_function = function (self)
				-- function 14
				return self[str_3].disabled
			end
		}
		tbl_4[str_9] = {
			word_wrap = true,
			font_size = 24,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = {
				255,
				50,
				50,
				50
			},
			size = {
				tbl_5[1] - 100,
				tbl_5[2]
			},
			offset = {
				tbl_7[1] + 90,
				tbl_7[2],
				3
			}
		}

		local str_10 = "title_text_shadow" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			text_id = str_7,
			style_id = str_10
		}
		tbl_4[str_10] = {
			word_wrap = true,
			font_size = 24,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				tbl_5[1] - 100,
				tbl_5[2]
			},
			offset = {
				tbl_7[1] + 90 + 2,
				tbl_7[2] - 2,
				2
			}
		}

		local str_11 = "background_glow" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			texture_id = str_11,
			style_id = str_11,
			content_check_function = function (self)
				-- function 15
				return self[str_3].is_hover
			end
		}
		tbl_4[str_11] = {
			size = tbl_5,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2],
				3
			}
		}
		tbl_3[str_11] = "talent_bg_glow_01"

		local str_12 = "glass_top" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			texture_id = str_12,
			style_id = str_12
		}
		tbl_4[str_12] = {
			size = {
				tbl_5[1],
				3
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2] + tbl_5[2] - 8,
				5
			}
		}
		tbl_3[str_12] = "button_glass_01"

		local str_13 = "icon" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			texture_id = str_13,
			style_id = str_13
		}
		tbl_4[str_13] = {
			saturated = true,
			size = tbl_6,
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				tbl_7[1],
				tbl_7[2] + tbl_5[2] / 2 - tbl_6[2] / 2,
				3
			}
		}
		tbl_3[str_13] = "icons_placeholder"

		local str_14 = "icon_rect" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "rect",
			style_id = str_14,
			content_check_function = function (self)
				-- function 16
				local var_16_0 = self[str_3]

				return not not var_16_0.disabled or not var_16_0.is_selected
			end
		}
		tbl_4[str_14] = {
			size = tbl_6,
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				tbl_7[1],
				tbl_7[2] + tbl_5[2] / 2 - tbl_6[2] / 2,
				4
			}
		}

		local str_15 = "icon_disabled_rect" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "rect",
			style_id = str_15,
			content_check_function = function (self)
				-- function 17
				return self[str_3].disabled
			end
		}
		tbl_4[str_15] = {
			size = tbl_6,
			color = {
				200,
				0,
				0,
				0
			},
			offset = {
				tbl_7[1],
				tbl_7[2] + tbl_5[2] / 2 - tbl_6[2] / 2,
				4
			}
		}

		local str_16 = "icon_divider" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			texture_id = str_16,
			style_id = str_16
		}
		tbl_4[str_16] = {
			size = {
				5,
				tbl_6[2] - 2
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				tbl_7[1] + tbl_6[1] - 5,
				tbl_7[2] + tbl_5[2] / 2 - tbl_6[2] / 2 + 1,
				6
			}
		}
		tbl_3[str_16] = "menu_frame_09_divider_vertical"

		local str_17 = "tooltip" .. str_2

		tbl_2[#tbl_2 + 1] = {
			talent_id = "talent",
			pass_type = "talent_tooltip",
			content_id = str_3,
			style_id = str_17,
			content_check_function = function (self)
				-- function 18
				local talent = self.talent

				talent = not talent and self.is_hover

				return talent
			end
		}
		tbl_4[str_17] = {
			size = tbl_5,
			offset = {
				tbl_7[1],
				tbl_7[2],
				tbl_7[3] + 10
			}
		}
		tbl_3[str_17] = nil
		num_3 = num_3 + tbl_5[1] + num
	end

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_10_0

	return tbl
end

local function fn_3(arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	local flag = arg_19_2 or "09"

	return {
		element = {
			passes = {
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge_holder_left = "menu_frame_" .. flag .. "_divider_left",
			edge_holder_right = "menu_frame_" .. flag .. "_divider_right",
			bottom_edge = "menu_frame_" .. flag .. "_divider"
		},
		style = {
			bottom_edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					5,
					0,
					6
				},
				size = {
					arg_19_1[1] - 10,
					5
				},
				texture_tiling_size = {
					arg_19_1[1] - 10,
					5
				}
			},
			edge_holder_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					3,
					-6,
					10
				},
				size = {
					9,
					17
				}
			},
			edge_holder_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_19_1[1] - 12,
					-6,
					10
				},
				size = {
					9,
					17
				}
			}
		},
		scenegraph_id = arg_19_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_4(arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	local flag = arg_20_2 or "09"

	return {
		element = {
			passes = {
				{
					texture_id = "edge",
					style_id = "edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_top",
					style_id = "edge_holder_top",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_bottom",
					style_id = "edge_holder_bottom",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge_holder_top = "menu_frame_" .. flag .. "_divider_top",
			edge_holder_bottom = "menu_frame_" .. flag .. "_divider_bottom",
			edge = "menu_frame_" .. flag .. "_divider_vertical"
		},
		style = {
			edge = {
				color = {
					255,
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
					arg_20_1[2] - 9
				},
				texture_tiling_size = {
					5,
					arg_20_1[2] - 9
				}
			},
			edge_holder_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-6,
					arg_20_1[2] - 7,
					10
				},
				size = {
					17,
					9
				}
			},
			edge_holder_bottom = {
				color = {
					255,
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
			}
		},
		scenegraph_id = arg_20_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_5(arg_21_0, arg_21_1)
	-- function 21
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 22
						return not self.button_hotspot.is_hover
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 23
						return self.button_hotspot.is_hover
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "tooltip",
					additional_option_id = "tooltip_data",
					pass_type = "additional_option_tooltip",
					content_check_function = function (self)
						-- function 24
						return self.button_hotspot.is_hover
					end
				}
			}
		},
		content = {
			text = arg_21_0,
			button_hotspot = {
				allow_multi_hover = true
			}
		},
		style = {
			text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					2
				}
			},
			text_hover = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					2
				}
			},
			text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					0
				}
			},
			tooltip = {
				vertical_alignment = "top",
				localize = true,
				horizontal_alignment = "center"
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_21_1
	}
end

local tbl_9 = {
	talent_title_text = UIWidgets.create_simple_text(Localize("hero_window_talents"), "talent_title_text", nil, nil, tbl_8),
	talent_row_1 = fn_2("talent_row_1", tbl_3.talent_row_1.size, 3, "green"),
	talent_row_2 = fn_2("talent_row_2", tbl_3.talent_row_2.size, 3),
	talent_row_3 = fn_2("talent_row_3", tbl_3.talent_row_3.size, 3),
	talent_row_4 = fn_2("talent_row_4", tbl_3.talent_row_4.size, 3),
	talent_row_5 = fn_2("talent_row_5", tbl_3.talent_row_5.size, 3),
	talent_row_6 = fn_2("talent_row_6", tbl_3.talent_row_6.size, 3),
	career_background = UIWidgets.create_background("window_frame", tbl_3.window_frame.size, "talent_tree_bg_01"),
	career_window = UIWidgets.create_frame("window_frame", tbl_3.window_frame.size, frame, 10),
	career_background_rect = UIWidgets.create_simple_rect("window_frame", {
		150,
		0,
		0,
		0
	}, 1),
	career_info_window = UIWidgets.create_frame("career_window", tbl_3.window_frame.size, frame, 10),
	career_info_window_rect = UIWidgets.create_simple_rect("career_window", {
		150,
		0,
		0,
		0
	}, 1),
	career_info_window_bottom_edge = fn_3("career_window_edge", tbl_3.career_window_edge.size),
	career_info_window_center_edge = fn_4("career_window_center_edge", tbl_3.career_window_center_edge.size),
	career_perks_dots = UIWidgets.create_simple_centered_texture_amount("mission_objective_01", {
		54,
		22
	}, "career_perks", 2),
	career_perks_dots_glow = UIWidgets.create_simple_centered_texture_amount("mission_objective_glow_02", {
		54,
		22
	}, "career_perks", 2),
	career_perk_1 = fn_5("", "career_perk_1"),
	career_perk_2 = fn_5("", "career_perk_2"),
	career_perk_3 = fn_5("", "career_perk_3"),
	passive_title_text = UIWidgets.create_simple_text("n/a", "passive_title_text", nil, nil, tbl_7),
	passive_type_title = UIWidgets.create_simple_text(Localize("hero_view_passive_ability"), "passive_type_title", nil, nil, tbl_6),
	passive_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "passive_title_divider"),
	passive_description_text = UIWidgets.create_simple_text("n/a", "passive_description_text", nil, nil, tbl_5),
	passive_icon = UIWidgets.create_simple_texture("icons_placeholder", "passive_icon"),
	passive_icon_frame = UIWidgets.create_simple_texture("talent_frame", "passive_icon_frame"),
	active_title_text = UIWidgets.create_simple_text("n/a", "active_title_text", nil, nil, tbl_7),
	active_type_title = UIWidgets.create_simple_text(Localize("hero_view_activated_ability"), "active_type_title", nil, nil, tbl_6),
	active_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "active_title_divider"),
	active_description_text = UIWidgets.create_simple_text("n/a", "active_description_text", nil, nil, tbl_5),
	active_icon = UIWidgets.create_simple_texture("icons_placeholder", "active_icon"),
	active_icon_frame = UIWidgets.create_simple_texture("talent_frame", "active_icon_frame")
}
local tbl_10 = {
	default = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	}
}
local tbl_11 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				arg_25_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				-- function 26
				local easeOutCubic = math.easeOutCubic(arg_26_3)

				arg_26_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				arg_28_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				-- function 29
				local easeOutCubic = math.easeOutCubic(arg_29_3)

				arg_29_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				-- function 30
				return
			end
		}
	}
}

return {
	widgets = tbl_9,
	node_widgets = node_widgets,
	scenegraph_definition = tbl_3,
	animation_definitions = tbl_11,
	generic_input_actions = tbl_10
}
