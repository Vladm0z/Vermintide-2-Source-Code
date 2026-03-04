-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_area_selection_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.frame
local var_0_2 = var_0_0.size
local var_0_3 = var_0_0.spacing
local var_0_4 = {
	var_0_2[1] * 3 + var_0_3 * 2,
	var_0_2[2]
}
local var_0_5 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
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
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - var_5_0
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}
local var_0_6 = {
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
		size = var_0_4,
		position = {
			var_0_2[1] + var_0_3,
			0,
			1
		}
	},
	video = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_4,
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
			var_0_4[1],
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
local var_0_7 = {
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
local var_0_8 = {
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
local var_0_9 = {
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
local var_0_10 = {
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

local function var_0_11(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1
	local var_7_1 = {
		180,
		180
	}

	if not var_7_0 then
		var_7_0 = "area_root_" .. arg_7_0
		var_0_6[var_7_0] = {
			vertical_alignment = "center",
			parent = "area_root",
			horizontal_alignment = "center",
			size = var_7_1,
			position = {
				0,
				0,
				1
			}
		}
	end

	local var_7_2 = {
		element = {}
	}
	local var_7_3 = {
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
			content_check_function = function (arg_8_0)
				return arg_8_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local var_7_4 = {
		locked = true,
		frame = "map_frame_04",
		icon = "level_icon_01",
		lock = "hero_icon_locked",
		icon_glow = "map_frame_glow_02",
		button_hotspot = {}
	}
	local var_7_5 = {
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

	var_7_2.element.passes = var_7_3
	var_7_2.content = var_7_4
	var_7_2.style = var_7_5
	var_7_2.offset = {
		0,
		0,
		0
	}
	var_7_2.scenegraph_id = var_7_0

	return var_7_2
end

local var_0_12 = true
local var_0_13 = {
	window = UIWidgets.create_frame("window", var_0_4, var_0_1, 10),
	window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window", nil, nil, nil, 2),
	background = UIWidgets.create_simple_rect("window", {
		255,
		0,
		0,
		0
	}),
	area_title = UIWidgets.create_simple_text("area_title", "area_title", nil, nil, var_0_10),
	title_divider = UIWidgets.create_simple_texture("divider_01_top", "title_divider"),
	description_text = UIWidgets.create_simple_text("description_text", "description_text", nil, nil, var_0_9),
	not_owned_text = UIWidgets.create_simple_text("dlc1_2_dlc_level_locked_tooltip", "not_owned_text", nil, nil, var_0_8),
	requirements_not_met_text = UIWidgets.create_simple_text("lb_unknown", "requirements_not_met_text", nil, nil, var_0_7),
	select_button = UIWidgets.create_default_button("select_button", var_0_6.select_button.size, nil, nil, Localize("menu_select"), 32, nil, nil, nil, var_0_12)
}
local var_0_14 = {}

for iter_0_0 = 1, 10 do
	var_0_14[iter_0_0] = var_0_11(iter_0_0)
end

return {
	widgets = var_0_13,
	area_widgets = var_0_14,
	map_size = var_0_4,
	scenegraph_definition = var_0_6,
	animation_definitions = var_0_5
}
