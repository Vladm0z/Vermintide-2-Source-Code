-- chunkname: @scripts/ui/views/hero_view/states/definitions/hero_view_state_keep_decorations_definitions.lua

local tbl = {
	480,
	700
}
local tbl_2 = {
	16,
	tbl[2] - 20
}
local tbl_3 = {
	450,
	tbl[2] + 20
}
local IS_WINDOWS = IS_WINDOWS
local flag

flag = not IS_WINDOWS and 35 and 50

local flag_2

flag_2 = not IS_WINDOWS and 22 and 28

local tbl_4 = {
	400,
	flag
}
local tbl_5 = {
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
	list_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			120,
			-140,
			10
		}
	},
	list_scrollbar = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "left",
		size = tbl_2,
		position = {
			-30,
			-10,
			10
		}
	},
	list_scroll_root = {
		vertical_alignment = "top",
		parent = "list_window",
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
	list_entry = {
		vertical_alignment = "top",
		parent = "list_scroll_root",
		horizontal_alignment = "left",
		size = tbl_4,
		position = {
			25,
			0,
			0
		}
	},
	list_detail_top = {
		vertical_alignment = "top",
		parent = "list_scrollbar",
		horizontal_alignment = "left",
		size = {
			488,
			95
		},
		position = {
			-45,
			60,
			2
		}
	},
	list_detail_bottom = {
		vertical_alignment = "bottom",
		parent = "list_scrollbar",
		horizontal_alignment = "left",
		size = {
			488,
			95
		},
		position = {
			-45,
			-60,
			2
		}
	},
	confirm_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			380,
			70
		},
		position = {
			0,
			30,
			10
		}
	},
	close_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			300,
			70
		},
		position = {
			-80,
			30,
			10
		}
	},
	info_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = tbl_3,
		position = {
			-70,
			-130,
			10
		}
	},
	info_top_left = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "left",
		size = {
			244,
			95
		},
		position = {
			0,
			40,
			2
		}
	},
	info_top_right = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "right",
		size = {
			244,
			95
		},
		position = {
			0,
			40,
			2
		}
	},
	info_bottom_left = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "left",
		size = {
			244,
			95
		},
		position = {
			0,
			-40,
			2
		}
	},
	info_bottom_right = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "right",
		size = {
			244,
			95
		},
		position = {
			0,
			-40,
			2
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			tbl_3[1] - 40,
			300
		},
		position = {
			0,
			-30,
			1
		}
	},
	title_divider = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			78,
			28
		},
		position = {
			0,
			-45,
			1
		}
	},
	description_text = {
		vertical_alignment = "top",
		parent = "title_divider",
		horizontal_alignment = "center",
		size = {
			tbl_3[1] - 40,
			300
		},
		position = {
			0,
			-50,
			1
		}
	},
	artist_text = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			tbl_3[1] - 40,
			300
		},
		position = {
			0,
			10,
			1
		}
	}
}
local tbl_6 = {
	200,
	10,
	10,
	10
}
local tbl_7 = {
	dynamic_height = false,
	upper_case = true,
	localize = false,
	word_wrap = true,
	font_size = 32,
	vertical_alignment = "top",
	horizontal_alignment = "center",
	use_shadow = true,
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_8 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 26,
	use_shadow = true,
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
local tbl_9 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 18,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}

local function fn()
	-- function 1
	local flag = true
	local frame_outer_glow_04 = UIFrameSettings.frame_outer_glow_04
	local var_1_2 = frame_outer_glow_04.texture_sizes.horizontal[2]
	local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
	local var_1_4 = frame_outer_glow_01.texture_sizes.horizontal[2]
	local str = "frame_outer_glow_04_big"
	local var_1_6 = UIFrameSettings[str]
	local var_1_7 = var_1_6.texture_sizes.horizontal[2]
	local str_2 = "list_entry"
	local size = tbl_5[str_2].size
	local tbl = {
		{
			style_id = "background",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			style_id = "title",
			pass_type = "text",
			text_id = "title",
			content_check_function = function (self)
				-- function 2
				return not self.locked
			end
		},
		{
			style_id = "locked_title",
			pass_type = "text",
			text_id = "title",
			content_check_function = function (self)
				-- function 3
				return self.locked
			end
		},
		{
			style_id = "title_shadow",
			pass_type = "text",
			text_id = "title"
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "edge_fade",
			texture_id = "edge_fade"
		},
		{
			pass_type = "texture_frame",
			style_id = "hover_frame",
			texture_id = "hover_frame"
		},
		{
			style_id = "new_frame",
			texture_id = "new_frame",
			pass_type = "texture_frame",
			content_check_function = function (self)
				-- function 4
				local new = self.new

				new = not new and not self.button_hotspot.is_hover

				return new
			end,
			content_change_function = function (arg_5_0, arg_5_1)
				-- function 5
				local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

				arg_5_1.color[1] = 55 + num * 200
			end
		},
		{
			pass_type = "texture",
			style_id = "dot_texture",
			texture_id = "dot_texture",
			content_check_function = function (self)
				-- function 6
				local locked = self.locked
				local equipped = self.equipped
				local new = self.new
				local in_use = self.in_use

				return not not locked or not not equipped or not not new or not in_use
			end
		},
		{
			pass_type = "texture",
			style_id = "lock_texture",
			texture_id = "lock_texture",
			content_check_function = function (self)
				-- function 7
				return self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "equipped_texture",
			texture_id = "equipped_texture",
			content_check_function = function (self)
				-- function 8
				return self.equipped
			end
		},
		{
			pass_type = "texture",
			style_id = "equipped_shadow_texture",
			texture_id = "equipped_texture",
			content_check_function = function (self)
				-- function 9
				return self.equipped
			end
		},
		{
			pass_type = "texture",
			style_id = "in_use_texture",
			texture_id = "equipped_texture",
			content_check_function = function (self)
				-- function 10
				local in_use = self.in_use

				in_use = not in_use and not self.equipped

				return in_use
			end
		},
		{
			style_id = "new_texture",
			texture_id = "new_texture",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 11
				return self.new
			end,
			content_change_function = function (arg_12_0, arg_12_1)
				-- function 12
				local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

				arg_12_1.color[1] = 55 + num * 200
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "pulse_frame",
			texture_id = "pulse_frame"
		}
	}
	local tbl_2 = {
		background = "rect_masked",
		locked = false,
		title = "",
		lock_texture = "achievement_symbol_lock",
		equipped = false,
		equipped_texture = "matchmaking_checkbox",
		new_texture = "list_item_tag_new",
		edge_fade = "playername_bg_02",
		new = false,
		dot_texture = "tooltip_marker",
		button_hotspot = {},
		hover_frame = frame_outer_glow_04.texture,
		new_frame = frame_outer_glow_01.texture,
		pulse_frame = var_1_6.texture,
		size = size
	}
	local tbl_3 = {}
	local tbl_4 = {
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_size = flag_2
	}
	local flag_3

	flag_3 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_3
	tbl_4.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_4.hover_text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_4.default_text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_4.offset = {
		40,
		0,
		2
	}
	tbl_4.size = {
		size[1] - 55,
		size[2]
	}
	tbl_3.title = tbl_4

	local tbl_6 = {
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_size = flag_2
	}
	local flag_4

	flag_4 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_4
	tbl_6.text_color = {
		255,
		80,
		80,
		80
	}
	tbl_6.hover_text_color = {
		255,
		80,
		80,
		80
	}
	tbl_6.default_text_color = {
		255,
		80,
		80,
		80
	}
	tbl_6.offset = {
		40,
		0,
		2
	}
	tbl_6.size = {
		size[1] - 55,
		size[2]
	}
	tbl_3.locked_title = tbl_6

	local tbl_7 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		localize = false,
		font_size = flag_2
	}
	local flag_5

	flag_5 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_7.font_type = flag_5
	tbl_7.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_7.offset = {
		41,
		-1,
		1
	}
	tbl_7.size = {
		size[1] - 55,
		size[2]
	}
	tbl_3.title_shadow = tbl_7
	tbl_3.background = {
		masked = flag,
		size = {
			size[1] - 20,
			size[2]
		},
		color = {
			180,
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
	tbl_3.edge_fade = {
		vertical_alignment = "center",
		horizontal_alignment = "right",
		masked = flag,
		texture_size = {
			20,
			size[2]
		},
		color = {
			180,
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
			6
		},
		size = {
			size[1],
			size[2]
		},
		frame_margins = {
			-var_1_2,
			-var_1_2
		}
	}
	tbl_3.pulse_frame = {
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		masked = flag,
		area_size = size,
		texture_size = var_1_6.texture_size,
		texture_sizes = var_1_6.texture_sizes,
		frame_margins = {
			-var_1_7,
			-var_1_7
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
			size[1],
			size[2]
		},
		frame_margins = {
			-var_1_4,
			-var_1_4
		}
	}
	tbl_3.dot_texture = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		masked = flag,
		texture_size = {
			13,
			13
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			11,
			-1,
			5
		}
	}
	tbl_3.lock_texture = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		masked = flag,
		texture_size = {
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
			-10,
			0,
			2
		}
	}
	tbl_3.equipped_texture = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		masked = flag,
		texture_size = {
			37,
			31
		},
		color = Colors.get_color_table_with_alpha("green", 255),
		offset = {
			4,
			0,
			3
		}
	}
	tbl_3.equipped_shadow_texture = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		masked = flag,
		texture_size = {
			37,
			31
		},
		color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			5,
			-1,
			2
		}
	}
	tbl_3.new_texture = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		masked = flag,
		texture_size = {
			113.4,
			45.9
		},
		color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			-64,
			0,
			2
		}
	}
	tbl_3.in_use_texture = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		masked = flag,
		texture_size = {
			37,
			31
		},
		color = Colors.get_color_table_with_alpha("gray", 255),
		offset = {
			4,
			0,
			3
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
		scenegraph_id = str_2
	}
end

local function fn_2()
	-- function 13
	local flag = true
	local str = "list_entry"
	local size = tbl_5[str].size
	local tbl = {
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "edge_fade",
			texture_id = "edge_fade"
		}
	}
	local tbl_2 = {
		title = "",
		locked = false,
		background = "rect_masked",
		edge_fade = "playername_bg_02",
		new = false,
		equipped = false,
		button_hotspot = {},
		size = size
	}
	local tbl_3 = {
		background = {
			masked = flag,
			size = {
				size[1] - 20,
				size[2]
			},
			color = {
				180,
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
		edge_fade = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = flag,
			texture_size = {
				20,
				size[2]
			},
			color = {
				180,
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
		scenegraph_id = str
	}
end

local function fn_3(arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local tbl_3 = {
		frame = "menu_frame_13"
	}
	local tbl_4 = {
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = arg_14_1,
			color = arg_14_2 or {
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
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = arg_14_1,
			texture_size = {
				84,
				84
			},
			texture_sizes = {
				corner = {
					32,
					32
				},
				vertical = {
					27,
					1
				},
				horizontal = {
					1,
					27
				}
			},
			frame_margins = {
				-27,
				-27
			},
			color = arg_14_2 or {
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
		0,
		0
	}
	tbl.scenegraph_id = arg_14_0

	return tbl
end

local function fn_4(arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	arg_15_2 = arg_15_2 or 20

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
		hotspot = {}
	}
	local tbl_3 = {
		mask = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				arg_15_1[1],
				arg_15_1[2]
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
				arg_15_1[1],
				arg_15_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				arg_15_2,
				0
			}
		},
		mask_bottom = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				arg_15_1[1],
				arg_15_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-arg_15_2,
				0
			},
			angle = math.pi,
			pivot = {
				arg_15_1[1] / 2,
				arg_15_2 / 2
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
		scenegraph_id = arg_15_0
	}
end

local flag_3 = true
local tbl_10 = {
	list_detail_top = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "list_detail_top"),
	list_detail_bottom = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "list_detail_bottom"),
	list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "list_window", tbl_5.list_scrollbar.size, "gold"),
	list_mask = fn_4("list_window", tbl_5.list_window.size, 10),
	title_text = UIWidgets.create_simple_text("n/a", "title_text", nil, nil, tbl_7),
	title_divider = UIWidgets.create_simple_texture("keep_decorations_divider_02", "title_divider"),
	description_text = UIWidgets.create_simple_text("n/a", "description_text", nil, nil, tbl_8),
	artist_text = UIWidgets.create_simple_text("n/a", "artist_text", nil, nil, tbl_9),
	background = UIWidgets.create_simple_texture("options_window_fade_01", "screen"),
	info_window = fn_3("info_window", {
		tbl_3[1] - 20,
		tbl_3[2]
	}, tbl_6),
	info_bottom_right = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			0.5,
			1
		},
		{
			1,
			0
		}
	}, "info_bottom_right"),
	info_bottom_left = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			1,
			1
		},
		{
			0.5,
			0
		}
	}, "info_bottom_left"),
	info_top_right = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			0.5,
			0
		},
		{
			1,
			1
		}
	}, "info_top_right"),
	info_top_left = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			1,
			0
		},
		{
			0.5,
			1
		}
	}, "info_top_left"),
	confirm_button = UIWidgets.create_default_button("confirm_button", tbl_5.confirm_button.size, "button_frame_01_gold", nil, Localize("menu_settings_apply"), 32, nil, "button_detail_01_gold", nil, flag_3),
	close_button = UIWidgets.create_default_button("close_button", tbl_5.close_button.size, "button_frame_01_gold", nil, Localize("interaction_action_close"), 32, nil, "button_detail_01_gold", nil, flag_3)
}
local tbl_11 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				arg_16_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				local easeOutCubic = math.easeOutCubic(arg_17_3)

				arg_17_4.render_settings.alpha_multiplier = easeOutCubic

				local num = 200 * (1 - easeOutCubic)
				local position = arg_17_1.info_window.position

				arg_17_0.info_window.position[1] = position[1] + num

				local position_2 = arg_17_1.close_button.position

				arg_17_0.close_button.position[1] = position_2[1] + num

				local position_3 = arg_17_1.list_window.position

				arg_17_0.list_window.position[1] = position_3[1] - num

				local position_4 = arg_17_1.confirm_button.position

				arg_17_0.confirm_button.position[2] = position_4[2] - num
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				return
			end
		}
	}
}
local tbl_12 = {
	{
		input_action = "back",
		priority = 3,
		description_text = "input_description_close"
	}
}
local tbl_13 = {
	default = {
		actions = {
			{
				input_action = "confirm",
				priority = 2,
				description_text = "input_description_apply"
			}
		}
	},
	remove = {
		actions = {
			{
				input_action = "confirm",
				priority = 2,
				description_text = "input_description_remove"
			}
		}
	}
}

return {
	input_actions = tbl_13,
	entry_widget_definition = fn(),
	dummy_entry_widget_definition = fn_2(),
	animation_definitions = tbl_11,
	generic_input_actions = tbl_12,
	scenegraph_definition = tbl_5,
	widgets_definitions = tbl_10
}
