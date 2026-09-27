-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_area_selection_definitions.lua

local game_start_windows = UISettings.game_start_windows
local frame = game_start_windows.frame
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
		size = tbl,
		position = {
			size[1] + spacing,
			0,
			1
		}
	},
	video = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			0,
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
			1
		}
	},
	area_root = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			-60,
			3
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
		parent = "title_divider",
		horizontal_alignment = "center",
		size = {
			1200,
			50
		},
		position = {
			0,
			30,
			1
		}
	},
	description_text = {
		vertical_alignment = "top",
		parent = "title_divider",
		horizontal_alignment = "center",
		size = {
			800,
			150
		},
		position = {
			0,
			-50,
			1
		}
	},
	select_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			460,
			72
		},
		position = {
			0,
			120,
			20
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
			40,
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
			150,
			12
		}
	}
}
local tbl_4 = {
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
local tbl_5 = {
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
local tbl_6 = {
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
local tbl_7 = {
	font_size = 72,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
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

local function fn(arg_7_0, arg_7_1)
	-- function 7
	local var_7_0 = arg_7_1
	local tbl = {
		180,
		180
	}

	if not var_7_0 then
		var_7_0 = "area_root_" .. arg_7_0
		tbl_3[var_7_0] = {
			vertical_alignment = "center",
			parent = "area_root",
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
	local tbl_4 = {
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
		lock = "hero_icon_locked",
		icon_glow = "map_frame_glow_02",
		button_hotspot = {}
	}
	local tbl_6 = {
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
				0
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

	tbl_2.element.passes = tbl_4
	tbl_2.content = tbl_5
	tbl_2.style = tbl_6
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = var_7_0

	return tbl_2
end

local flag = true
local tbl_8 = {
	window = UIWidgets.create_frame("window", tbl, frame, 10),
	window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window", nil, nil, nil, 2),
	background = UIWidgets.create_simple_rect("window", {
		255,
		0,
		0,
		0
	}),
	area_title = UIWidgets.create_simple_text("area_title", "area_title", nil, nil, tbl_7),
	title_divider = UIWidgets.create_simple_texture("divider_01_top", "title_divider"),
	description_text = UIWidgets.create_simple_text("description_text", "description_text", nil, nil, tbl_6),
	not_owned_text = UIWidgets.create_simple_text("dlc1_2_dlc_level_locked_tooltip", "not_owned_text", nil, nil, tbl_5),
	requirements_not_met_text = UIWidgets.create_simple_text("lb_unknown", "requirements_not_met_text", nil, nil, tbl_4),
	select_button = UIWidgets.create_default_button("select_button", tbl_3.select_button.size, nil, nil, Localize("menu_select"), 32, nil, nil, nil, flag)
}
local tbl_9 = {}

for i = 1, 10 do
	tbl_9[i] = fn(i)
end

return {
	widgets = tbl_8,
	area_widgets = tbl_9,
	map_size = tbl,
	scenegraph_definition = tbl_3,
	animation_definitions = tbl_2
}
