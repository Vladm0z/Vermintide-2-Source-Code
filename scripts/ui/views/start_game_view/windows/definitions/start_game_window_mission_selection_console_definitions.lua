-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_mission_selection_console_definitions.lua

local game_start_windows = UISettings.game_start_windows
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local var_0_4 = UIFrameSettings[frame].texture_sizes.vertical[1]
local num = size[1] - (var_0_4 * 2 + 60)
local tbl = {
	size[1] * 2 + spacing,
	size[2]
}
local tbl_2 = {
	size[1],
	size[2] + 50
}
local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local flag = true
local tbl_3 = {
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
		},
		{
			name = "animate_in_window",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeOutCubic = math.easeOutCubic(arg_5_3)

				arg_5_0.window.local_position[1] = arg_5_1.window.position[1] + math.floor(-100 * (1 - easeOutCubic))
				arg_5_0.info_window.local_position[1] = arg_5_1.info_window.position[1] + 200 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				arg_7_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local easeOutCubic = math.easeOutCubic(arg_8_3)

				arg_8_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		}
	}
}
local tbl_4 = {
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	area_left = console_menu_scenegraphs.area_left,
	area_right = console_menu_scenegraphs.area_right,
	area_divider = console_menu_scenegraphs.area_divider,
	window = {
		vertical_alignment = "center",
		parent = "area_left",
		horizontal_alignment = "left",
		size = tbl,
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
			tbl[1],
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
		size = tbl_2,
		position = {
			tbl_2[1] - 25,
			0,
			1
		}
	},
	act_root_node = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			tbl[1] - 256,
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
			tbl[1],
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
			tbl[1],
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
			num,
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
			num,
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
			num,
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
			num,
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
			num,
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
local tbl_5 = {
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
local tbl_6 = {
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
local tbl_7 = {
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
local tbl_8 = {
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
local tbl_9 = {
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

local function fn(arg_10_0, arg_10_1)
	-- function 10
	local var_10_0 = arg_10_1
	local tbl = {
		180,
		180
	}

	if not var_10_0 then
		var_10_0 = "level_root_" .. arg_10_0
		tbl_4[var_10_0] = {
			vertical_alignment = "center",
			parent = "level_root_node",
			horizontal_alignment = "center",
			size = tbl,
			position = {
				0,
				0,
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
			content_id = "button_hotspot",
			content_check_function = function (self)
				-- function 11
				return not self.parent.locked
			end
		},
		{
			style_id = "icon",
			pass_type = "level_tooltip",
			level_id = "level_data",
			content_check_function = function (self)
				-- function 12
				return self.button_hotspot.is_hover
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
			content_check_function = function (self)
				-- function 13
				return not self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_locked",
			texture_id = "icon",
			content_check_function = function (self)
				-- function 14
				return self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock",
			content_check_function = function (self)
				-- function 15
				return self.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "lock_fade",
			texture_id = "lock_fade",
			content_check_function = function (self)
				-- function 16
				return self.locked
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
			content_check_function = function (self)
				-- function 17
				return self.boss_level
			end
		}
	}
	local tbl_5 = {
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
	local tbl_6 = {
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

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_5
	tbl_2.style = tbl_6
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = var_10_0

	return tbl_2
end

local function fn_2(arg_18_0, arg_18_1)
	-- function 18
	local flag = arg_18_1 or "09"
	local str = "act_text_root_node"
	local size = tbl_4[str].size
	local flag_2 = arg_18_0 > 1
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
	local tbl_3 = {
		text = "title_text",
		title_edge = "game_option_divider",
		background = "menu_frame_bg_01",
		title_bg = "playername_bg_02",
		draw_divider = flag_2,
		edge_holder_left = "menu_frame_" .. flag .. "_divider_left",
		edge_holder_right = "menu_frame_" .. flag .. "_divider_right",
		bottom_edge = "menu_frame_" .. flag .. "_divider"
	}
	local tbl_5 = {
		16,
		-3,
		10
	}
	local tbl_6 = {
		text = {
			vertical_alignment = "center",
			upper_case = true,
			localize = false,
			horizontal_alignment = "left",
			font_size = 28,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = tbl_5
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
				tbl_5[1] + 1,
				tbl_5[2] - 1,
				tbl_5[3] - 1
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
				size[2] - 4,
				6
			},
			size = {
				size[1] - 10,
				5
			},
			texture_tiling_size = {
				size[1] - 10,
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
				size[2] - 10,
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
				size[1] - 12,
				size[2] - 10,
				15
			},
			size = {
				9,
				17
			}
		},
		title_bg = {
			size = {
				size[1] / 2,
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
				size[2] - 40,
				2
			}
		},
		title_edge = {
			size = {
				size[1] / 2,
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
				size[2] - 40,
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

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_6
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = str

	return tbl
end

local function fn_3(arg_19_0)
	-- function 19
	local flag = arg_19_0 or "09"
	local str = "end_act_root_node"
	local size = tbl_4[str].size
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {
		text = "title_text",
		title_edge = "game_option_divider",
		background = "menu_frame_bg_01",
		title_bg = "playername_bg_02",
		edge_holder_top = "menu_frame_" .. flag .. "_divider_top",
		edge_holder_bottom = "menu_frame_" .. flag .. "_divider_bottom",
		edge = "menu_frame_" .. flag .. "_divider_vertical"
	}
	local tbl_5 = {
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
				size[2] - 9
			},
			texture_tiling_size = {
				5,
				size[2] - 9
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
				size[2] - 7,
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
				size[1] / 2,
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
				size[2] - 40,
				2
			}
		},
		title_edge = {
			size = {
				size[1] / 2,
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
				size[2] - 40,
				4
			}
		}
	}

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_5
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = str

	return tbl
end

local function fn_4(arg_20_0, arg_20_1)
	-- function 20
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_20_0).size

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
					content_check_function = function (self, arg_21_1)
						-- function 21
						return not self.disable_glow
					end
				},
				{
					pass_type = "texture",
					style_id = "checkmark",
					texture_id = "checkmark",
					content_check_function = function (self, arg_22_1)
						-- function 22
						return self.amount >= self.total_amount
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
					size[1] + 15,
					size[2] - 50,
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
					size[1] + 15 + 1,
					size[2] - 50 - 1,
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
					size[1] + 15,
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
					size[1] + 15 + 1,
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
				texture_size = size
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
				texture_size = size
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
				texture_size = size
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_5(arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	local tbl = {
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
					content_check_function = function (self, arg_24_1)
						-- function 24
						return self.completed_difficulty_index < 4
					end
				},
				{
					style_id = "difficulty_text_completed",
					pass_type = "text",
					text_id = "difficulty_text",
					content_check_function = function (self, arg_25_1)
						-- function 25
						return self.completed_difficulty_index >= 4
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
					content_check_function = function (self, arg_26_1)
						-- function 26
						return self.completed_difficulty_index >= 4
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
					tbl[1] + 15,
					tbl[2] - 50,
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
					tbl[1] + 15 + 1,
					tbl[2] - 50 - 1,
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
					tbl[1] + 15,
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
					tbl[1] + 15,
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
					tbl[1] + 15,
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
					tbl[1] + 15 + 1,
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
				texture_size = tbl
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
				texture_size = tbl
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
	-- function 27
	if type(arg_27_5) ~= "table" then
		arg_27_5 = {
			0,
			0,
			arg_27_5 or 0
		}
	end

	if arg_27_6 == "native" then
		local size = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_27_0).size

		arg_27_6 = {
			size[1],
			size[2]
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
	-- function 28
	local tbl = {
		75.60000000000001,
		97.2
	}
	local tbl_2 = {
		90,
		90
	}
	local tbl_3 = {}

	for i = 1, #ProfilePriority do
		local var_28_3 = ProfilePriority[i]
		local var_28_4 = SPProfiles[var_28_3].careers[1]

		tbl_3[#tbl_3 + 1] = var_28_4.picking_image
	end

	local num = 0.75
	local num_2 = 96 * num
	local num_3 = 112 * num
	local num_4 = 25 * num, {
		86 * num,
		108 * num
	}
	local tbl_4 = {
		255,
		255,
		255,
		255
	}
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_title", 255)
	local count = #tbl_3
	local tbl_5 = {
		element = {}
	}
	local tbl_6 = {}
	local tbl_7 = {}
	local tbl_8 = {}
	local flag = num_4 or 0
	local num_5 = 0
	local num_6 = -flag
	local num_7 = 0
	local default = UIPlayerPortraitFrameSettings.default

	for j = 1, count do
		local str = "_" .. tostring(j)
		local num_8 = j - 1

		num_6 = num_6 + tbl[1] + flag

		local tbl_9 = {
			num_7,
			0,
			num_5
		}
		local str_2 = "icon_data" .. str

		tbl_7[str_2] = {}

		local var_28_25 = tbl_7[str_2]
		local var_28_26 = tbl_3[j]
		local str_3 = "icon" .. str

		tbl_6[#tbl_6 + 1] = {
			pass_type = "texture",
			content_id = str_2,
			texture_id = str_3,
			style_id = str_3,
			content_check_function = function (self)
				-- function 29
				return not self.icon_disabled
			end
		}
		tbl_8[str_3] = {
			masked = true,
			size = tbl,
			color = tbl_4,
			offset = {
				tbl_9[1],
				tbl_9[2],
				tbl_9[3] + 2
			}
		}
		var_28_25[str_3] = var_28_26

		local var_28_28 = tbl_3[j]
		local str_4 = "icon" .. str .. "_disabled"

		tbl_6[#tbl_6 + 1] = {
			pass_type = "texture",
			content_id = str_2,
			texture_id = str_4,
			style_id = str_4,
			content_check_function = function (self)
				-- function 30
				return self.icon_disabled
			end
		}
		tbl_8[str_4] = {
			saturated = true,
			masked = true,
			size = tbl,
			color = tbl_4,
			default_color = tbl_4,
			disabled_color = {
				255,
				60,
				60,
				60
			},
			offset = {
				tbl_9[1],
				tbl_9[2],
				tbl_9[3] + 2
			}
		}
		var_28_25[str_4] = var_28_28

		local str_5 = "frame" .. str

		tbl_6[#tbl_6 + 1] = {
			pass_type = "texture",
			content_id = str_2,
			texture_id = str_5,
			style_id = str_5
		}
		tbl_8[str_5] = {
			size = {
				tbl_2[1],
				tbl_2[2]
			},
			color = tbl_4,
			offset = {
				tbl_9[1] + tbl[1] / 2 - tbl_2[1] / 2,
				tbl_9[2] + tbl[2] / 2 - tbl_2[2] / 2,
				tbl_9[3] + 3
			}
		}
		var_28_25[str_5] = "map_frame_00"

		local str_6 = "frame" .. str .. "_mask"

		tbl_6[#tbl_6 + 1] = {
			pass_type = "texture",
			content_id = str_2,
			texture_id = str_6,
			style_id = str_6
		}
		tbl_8[str_6] = {
			size = {
				tbl_2[1],
				tbl_2[2]
			},
			color = tbl_4,
			offset = {
				tbl_9[1] + tbl[1] / 2 - tbl_2[1] / 2,
				tbl_9[2] + tbl[2] / 2 - tbl_2[2] / 2,
				tbl_9[3] + 3
			}
		}
		var_28_25[str_6] = "map_frame_mask"
		num_7 = num_7 + tbl[1] + flag
	end

	tbl_5.element.passes = tbl_6
	tbl_5.content = tbl_7
	tbl_5.style = tbl_8
	tbl_5.offset = {
		-num_6 / 2,
		-5,
		0
	}
	tbl_5.scenegraph_id = arg_28_0

	return tbl_5
end

local var_0_22 = fn_3()
local tbl_10 = {
	level_title = UIWidgets.create_simple_text("level_title", "level_title", nil, nil, tbl_6),
	selected_level = fn(nil, "level_texture_frame"),
	description_text = UIWidgets.create_simple_text("", "description_text", nil, nil, tbl_5),
	helper_text = UIWidgets.create_simple_text(Localize("tutorial_map"), "helper_text", nil, nil, tbl_7),
	description_background = UIWidgets.create_rect_with_outer_frame("info_window", tbl_4.info_window.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color),
	locked_text = UIWidgets.create_simple_text("", "locked_text", nil, nil, tbl_9),
	progression_divider = UIWidgets.create_simple_texture("divider_01_top", "progression_divider"),
	heros_completed_text = UIWidgets.create_simple_text(Localize("heroes_completed"), "hero_tabs", nil, nil, tbl_8)
}
local tbl_11 = {}

for i = 1, #ProfilePriority do
	local var_0_25 = ProfilePriority[i]
	local var_0_26 = SPProfiles[var_0_25]

	tbl_11[#tbl_11 + 1] = var_0_26.ui_portrait
end

local num_2 = 0.75
local num_3 = 96 * num_2
local num_4 = 112 * num_2
local num_5 = 10 * num_2
local tbl_12 = {
	86 * num_2,
	108 * num_2
}

if not flag then
	tbl_10.hero_tabs = create_hero_widgets("hero_tabs")
else
	tbl_10.hero_tabs = UIWidgets.create_icon_selector("hero_tabs", {
		num_3,
		num_4
	}, tbl_11, num_5, true, tbl_12, true, true)
end

local tbl_13 = {}

for j = 1, 20 do
	tbl_13[j] = fn(j)
end

local tbl_14 = {}

for k = 1, 5 do
	tbl_14[k] = fn_2(k)
end

local tbl_15 = {
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
	widgets = tbl_10,
	act_widgets = tbl_14,
	node_widgets = tbl_13,
	end_act_widget = var_0_22,
	scenegraph_definition = tbl_4,
	animation_definitions = tbl_3,
	large_window_size = tbl,
	mission_settings = tbl_15,
	create_loot_widget = fn_4,
	create_difficulty_widget = fn_5,
	use_career_completion = flag
}
