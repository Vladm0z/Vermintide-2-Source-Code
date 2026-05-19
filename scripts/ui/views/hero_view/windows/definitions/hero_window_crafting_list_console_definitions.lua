-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_crafting_list_console_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = UIFrameSettings[var_0_2].texture_sizes.vertical[1]
local var_0_5 = UIFrameSettings[var_0_2].texture_sizes.horizontal[2]
local var_0_6 = {
	var_0_3[1] - var_0_4 * 2,
	(var_0_3[2] - var_0_5 * 2) / 3.5
}
local var_0_7 = UISettings.console_menu_scenegraphs
local var_0_8 = {
	screen = var_0_7.screen,
	area = var_0_7.area,
	area_left = var_0_7.area_left,
	area_right = var_0_7.area_right,
	area_divider = var_0_7.area_divider,
	list_background_bottom = {
		vertical_alignment = "bottom",
		parent = "area_left",
		horizontal_alignment = "left",
		size = {
			241,
			434
		},
		position = {
			50,
			-30,
			1
		}
	},
	list_background_top = {
		vertical_alignment = "bottom",
		parent = "list_background_bottom",
		horizontal_alignment = "center",
		size = {
			241,
			434
		},
		position = {
			0,
			434,
			1
		}
	},
	list_entry_root = {
		vertical_alignment = "top",
		parent = "list_background_bottom",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			56,
			0,
			2
		}
	},
	list_entry = {
		vertical_alignment = "center",
		parent = "list_entry_root",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			2
		}
	},
	description_text = {
		vertical_alignment = "top",
		parent = "area_right",
		horizontal_alignment = "left",
		size = {
			650,
			400
		},
		position = {
			0,
			-140,
			2
		}
	},
	tite_text = {
		vertical_alignment = "top",
		parent = "description_text",
		horizontal_alignment = "center",
		size = {
			600,
			50
		},
		position = {
			0,
			-20,
			2
		}
	},
	divider = {
		vertical_alignment = "top",
		parent = "description_text",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-70,
			1
		}
	}
}
local var_0_9 = {
	font_size = 42,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = false,
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
local var_0_10 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		-20,
		2
	}
}
local var_0_11 = {
	default = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "show_gamercard",
			priority = 2,
			description_text = "start_menu_switch_hero"
		},
		{
			input_action = "confirm",
			priority = 3,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 4,
			description_text = "input_description_close"
		}
	}
}

local function var_0_12(arg_1_0, arg_1_1)
	return {
		element = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				},
				{
					texture_id = "selection",
					style_id = "selection",
					pass_type = "texture"
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture"
				},
				{
					texture_id = "holder",
					style_id = "holder",
					pass_type = "rotated_texture"
				}
			}
		},
		content = {
			holder = "console_crafting_recipe_holder",
			background = "console_crafting_disc_small",
			icon = "console_crafting_disc_small",
			selection = "console_crafting_disc_small_inner_glow",
			button_hotspot = {}
		},
		style = {
			hotspot = {
				size = {
					128,
					80
				},
				offset = {
					-64,
					-40,
					0
				}
			},
			background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					128,
					128
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					0
				}
			},
			selection = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					128,
					128
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					128,
					128
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					2
				}
			},
			holder = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = 0,
				pivot = {
					83.5,
					11
				},
				texture_size = {
					39,
					22
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-64,
					0,
					3
				}
			}
		},
		offset = {
			0,
			0,
			arg_1_1 * 4
		},
		scenegraph_id = arg_1_0
	}
end

local var_0_13 = {}
local var_0_14 = 10

for iter_0_0 = 1, var_0_14 do
	var_0_13[iter_0_0] = var_0_12("list_entry", iter_0_0)
end

local var_0_15 = {
	list_background_bottom = UIWidgets.create_simple_texture("console_crafting_recipe_bg", "list_background_bottom"),
	list_background_top = UIWidgets.create_simple_uv_texture("console_crafting_recipe_bg", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "list_background_top"),
	divider = UIWidgets.create_simple_texture("divider_01_top", "divider"),
	tite_text = UIWidgets.create_simple_text("n/a", "tite_text", nil, nil, var_0_9),
	description_text = UIWidgets.create_simple_text("n/a", "description_text", nil, nil, var_0_10),
	description_bg = UIWidgets.create_rect_with_outer_frame("description_text", var_0_8.description_text.size, "frame_outer_fade_02", 0, UISettings.console_menu_rect_color)
}
local var_0_16 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				arg_2_3.render_settings.alpha_multiplier = 0
				arg_2_3.animation_settings.entry_alignment_progress = 0
			end,
			update = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				local var_3_0 = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = var_3_0
				arg_3_4.animation_settings.entry_alignment_progress = var_3_0
				arg_3_0.area_left.local_position[1] = arg_3_1.area_left.position[1] + -100 * (1 - var_3_0)
			end,
			on_complete = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = 1 - var_6_0
			end,
			on_complete = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_15,
	generic_input_actions = var_0_11,
	title_button_definitions = var_0_13,
	scenegraph_definition = var_0_8,
	animation_definitions = var_0_16
}
