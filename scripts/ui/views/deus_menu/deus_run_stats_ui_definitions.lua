-- chunkname: @scripts/ui/views/deus_menu/deus_run_stats_ui_definitions.lua

require("scripts/ui/views/deus_menu/ui_widgets_deus")

local var_0_0 = false
local var_0_1 = {
	1920,
	1080
}
local var_0_2 = {
	410,
	240
}
local var_0_3 = {
	10,
	10
}
local var_0_4 = {
	410,
	0
}
local var_0_5 = 15
local var_0_6 = {
	360,
	32
}
local var_0_7 = {
	var_0_5,
	-50,
	1
}
local var_0_8 = {
	400,
	250
}
local var_0_9 = {
	var_0_5 + 5,
	80,
	1
}
local var_0_10 = {
	var_0_5 + 5 + var_0_3[1] + var_0_2[1],
	80,
	1
}
local var_0_11 = {
	var_0_5 + 5 + (var_0_3[1] + var_0_2[1]) * 2,
	80,
	1
}
local var_0_12 = {
	var_0_4[1] * 0.5,
	0,
	1
}
local var_0_13 = {
	var_0_7[1] + var_0_4[1] + var_0_5,
	var_0_7[2],
	1
}
local var_0_14 = UILayer.end_screen
local var_0_15 = {
	fullscreen_fade = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			var_0_14 - 1
		}
	},
	root = {
		is_root = true,
		size = var_0_1,
		position = {
			0,
			0,
			var_0_14
		}
	},
	screen = {
		scale = "fit",
		size = var_0_1,
		position = {
			0,
			0,
			var_0_14 + 100
		}
	},
	screen_reminder = {
		scale = "fit",
		size = var_0_1,
		position = {
			0,
			0,
			var_0_14
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
		size = var_0_1,
		position = {
			0,
			0,
			1
		}
	},
	power_up_description_root = {
		size = {
			484,
			194
		},
		position = {
			0,
			0,
			var_0_14 + 200
		}
	},
	center_title = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			200,
			60
		},
		position = {
			-70,
			-50,
			1
		}
	},
	options_background_mask = {
		scale = "fit_height",
		horizontal_alignment = "right",
		size = {
			1400,
			0
		},
		position = {
			425,
			0,
			var_0_14 + 6
		}
	},
	options_background = {
		scale = "fit_height",
		horizontal_alignment = "right",
		size = {
			900,
			0
		},
		position = {
			425,
			0,
			var_0_14 + 6
		}
	},
	options_background_edge = {
		scale = "fit_height",
		horizontal_alignment = "right",
		size = {
			200,
			0
		},
		position = {
			-260,
			0,
			var_0_14 + 3
		}
	},
	power_up_root = {
		vertical_alignment = "top",
		parent = "options_background_edge",
		horizontal_alignment = "left",
		size = {
			64,
			64
		},
		position = {
			240,
			-150,
			101
		}
	},
	power_up_anchor = {
		parent = "power_up_root"
	},
	scrollbar_anchor = {
		vertical_alignment = "top",
		parent = "power_up_root",
		horizontal_alignment = "left",
		size = {
			200,
			735
		}
	},
	power_up_window_anchor = {
		parent = "scrollbar_anchor",
		position = {
			-10,
			5,
			1
		}
	},
	power_up_window = {
		parent = "power_up_window_anchor"
	},
	blessing_root = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			50,
			50
		},
		position = {
			var_0_5 + 5,
			-130,
			10
		}
	},
	blessing_1 = {
		vertical_alignment = "center",
		parent = "blessing_root",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			0,
			20,
			10
		}
	},
	blessing_2 = {
		vertical_alignment = "center",
		parent = "blessing_1",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			var_0_2[1] + var_0_3[1],
			0,
			10
		}
	},
	blessing_3 = {
		vertical_alignment = "center",
		parent = "blessing_2",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			var_0_2[1] + var_0_3[1],
			0,
			10
		}
	},
	blessing_4 = {
		vertical_alignment = "center",
		parent = "blessing_root",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			var_0_2[1] + var_0_3[1],
			0,
			10
		}
	},
	blessing_5 = {
		vertical_alignment = "center",
		parent = "blessing_4",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			0,
			-var_0_2[2] - var_0_3[2],
			10
		}
	},
	blessing_6 = {
		vertical_alignment = "center",
		parent = "blessing_5",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			0,
			-var_0_2[2] - var_0_3[2],
			10
		}
	},
	no_blessings_text = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			400,
			30
		},
		position = {
			-760,
			-130,
			10
		}
	},
	deus_run_stats_input_description = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			564,
			30
		},
		position = {
			0,
			20,
			-1
		}
	},
	reminder_text = {
		vertical_alignment = "bottom",
		parent = "screen_reminder",
		horizontal_alignment = "center",
		size = {
			900,
			30
		},
		position = {
			0,
			190,
			300
		}
	},
	weapon_melee = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = var_0_7
	},
	weapon_ranged = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = var_0_13
	},
	weapon_melee_title = {
		vertical_alignment = "bottom",
		parent = "weapon_melee",
		horizontal_alignment = "center",
		size = var_0_6,
		position = var_0_12
	},
	weapon_ranged_title = {
		vertical_alignment = "bottom",
		parent = "weapon_ranged",
		horizontal_alignment = "center",
		size = var_0_6,
		position = var_0_12
	},
	healing_slot = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = var_0_9
	},
	potion_slot = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = var_0_10
	},
	grenade_slot = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = var_0_11
	}
}
local var_0_16 = {
	font_type = "hell_shark_header",
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 36,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	area_size = {
		350,
		200
	},
	text_color = Colors.get_table("font_title"),
	offset = {
		0,
		0,
		0
	}
}
local var_0_17 = {
	use_shadow = true,
	vertical_alignment = "top",
	localize = false,
	horizontal_alignment = "left",
	font_size = 24,
	font_type = "hell_shark",
	text_color = Colors.get_table("font_default"),
	offset = {
		0,
		0,
		0
	}
}
local var_0_18 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 32,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_table("font_title"),
	offset = {
		0,
		0,
		2
	}
}
local var_0_19 = {
	use_shadow = true,
	vertical_alignment = "top",
	horizontal_alignment = "right",
	dynamic_font_size = true,
	font_size = 28,
	font_type = "hell_shark",
	text_color = Colors.get_table("font_default"),
	offset = {
		0,
		0,
		2
	}
}
local var_0_20 = {
	use_shadow = true,
	upper_case = true,
	vertical_alignment = "center",
	horizontal_alignment = "right",
	font_size = 68,
	font_type = "hell_shark_header",
	text_color = Colors.get_table("font_title"),
	offset = {
		0,
		-3,
		1
	}
}
local var_0_21 = {
	word_wrap = false,
	use_shadow = true,
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = color or Colors.get_color_table_with_alpha("white", 255),
	rect_color = rect_color or Colors.get_color_table_with_alpha("black", 150),
	line_colors = {},
	offset = {
		0,
		0,
		50
	}
}

local function var_0_22(arg_1_0, arg_1_1, arg_1_2)
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
			edge_holder_right = "menu_frame_09_divider_right",
			edge_holder_left = "menu_frame_09_divider_left",
			bottom_edge = "menu_frame_09_divider"
		},
		style = {
			bottom_edge = {
				size = {
					[2] = arg_1_1[2]
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
					arg_1_2
				},
				texture_tiling_size = {
					arg_1_1[1] - 10,
					5
				}
			},
			edge_holder_left = {
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-6,
					arg_1_2 + 1
				},
				texture_size = {
					9,
					17
				}
			},
			edge_holder_right = {
				horizontal_alignment = "right",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-6,
					arg_1_2 + 1
				},
				texture_size = {
					9,
					17
				}
			}
		},
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_23 = {
	200,
	10,
	10,
	10
}

function create_input_text(arg_2_0, arg_2_1, arg_2_2)
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_3_0, arg_3_1)
						return not ShowCursorStack.cursor_active()
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_4_0, arg_4_1)
						return not ShowCursorStack.cursor_active()
					end
				}
			}
		},
		content = {
			text = arg_2_0,
			disable_with_gamepad = arg_2_2
		},
		style = {
			text = {
				font_size = 24,
				upper_case = true,
				localize = true,
				use_shadow = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_table("white"),
				offset = {
					0,
					0,
					2
				}
			},
			text_shadow = {
				font_size = 24,
				upper_case = true,
				localize = true,
				use_shadow = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_table("black"),
				offset = {
					2,
					-2,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_2_1
	}
end

local var_0_24 = {
	reminder = {
		{
			name = "fade_in_reminder_text",
			start_progress = 4,
			end_progress = 4.3,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				return
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				arg_6_2.style.text.text_color[1] = arg_6_3 * 255
				arg_6_2.style.text_shadow.text_color[1] = arg_6_3 * 255
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		},
		{
			name = "fade_out_reminder_text",
			start_progress = 6,
			end_progress = 6.5,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				return
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				arg_9_2.style.text.text_color[1] = (1 - arg_9_3) * 255
				arg_9_2.style.text_shadow.text_color[1] = (1 - arg_9_3) * 255
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end
		}
	}
}

function create_reminder_text(arg_11_0, arg_11_1, arg_11_2)
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "power_up_text",
					content_check_function = function (arg_12_0)
						return arg_12_0.info_type == "deus_power_up"
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "power_up_text",
					content_check_function = function (arg_13_0)
						return arg_13_0.info_type == "deus_power_up"
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "item_text",
					content_check_function = function (arg_14_0)
						return arg_14_0.info_type == "deus_item_tooltip"
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "item_text",
					content_check_function = function (arg_15_0)
						return arg_15_0.info_type == "deus_item_tooltip"
					end
				}
			}
		},
		content = {
			item_text = "reliquary_z_reminder",
			info_type = "deus_item_tooltip",
			power_up_text = "reliquary_i_reminder"
		},
		style = {
			text = {
				vertical_alignment = "center",
				font_size = 32,
				localize = true,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 0),
				offset = {
					0,
					0,
					0
				}
			},
			text_shadow = {
				vertical_alignment = "center",
				font_size = 32,
				localize = true,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 0),
				offset = {
					2,
					-2,
					-1
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

local var_0_25 = true
local var_0_26 = {
	fullscreen_fade = UIWidgets.create_simple_rect("fullscreen_fade", {
		155,
		0,
		0,
		0
	}),
	center_title = UIWidgets.create_simple_text(Localize("menu_weave_forge_options_sub_title_properties_utility"), "center_title", 32, nil, var_0_20),
	center_title_bg = UIWidgets.create_simple_texture("tab_menu_bg_03", "center_title"),
	options_background_edge = UIWidgets.create_simple_texture("shrine_sidebar_background", "options_background_edge"),
	options_background = UIWidgets.create_tiled_texture("options_background", "menu_frame_bg_01_mask2", {
		960,
		1400
	}, nil, true, {
		255,
		120,
		120,
		120
	}),
	options_background_mask = UIWidgets.create_simple_uv_texture("shrine_sidebar_write_mask2", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "options_background_mask"),
	power_up_mask = UIWidgets.create_simple_texture("mask_rect", "power_up_window"),
	no_blessings_text = UIWidgets.create_simple_text("", "no_blessings_text", nil, nil, var_0_21),
	input_description_text = create_input_text("player_list_show_mouse_description", "deus_run_stats_input_description", var_0_25),
	power_up_description = UIWidgets.create_power_up("power_up_description_root", var_0_15.power_up_description_root.size, true, var_0_0)
}

local function var_0_27(arg_16_0, arg_16_1)
	return {
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "bg"
				},
				{
					style_id = "frame",
					pass_type = "texture_frame",
					texture_id = "frame",
					content_change_function = function (arg_17_0, arg_17_1)
						arg_17_0.frame = UIFrameSettings[arg_17_0.frame_settings_name].texture
						arg_17_1.texture_size = UIFrameSettings[arg_17_0.frame_settings_name].texture_size
						arg_17_1.texture_sizes = UIFrameSettings[arg_17_0.frame_settings_name].texture_sizes
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				}
			}
		},
		content = {
			frame_settings_name = "item_tooltip_frame_01",
			text = arg_16_1
		},
		style = {
			frame = {},
			bg = {
				color = {
					255,
					3,
					3,
					3
				}
			},
			text = {
				vertical_alignment = "center",
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				font_size = 20,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255)
			},
			text_shadow = {
				vertical_alignment = "center",
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				font_size = 20,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					1,
					-1,
					-1
				}
			}
		},
		scenegraph_id = arg_16_0
	}
end

local var_0_28 = {
	"item_titles",
	"skin_applied",
	"ammunition",
	"fatigue",
	"item_power_level",
	"properties",
	"traits",
	"weapon_skin_title",
	"keywords",
	"light_attack_stats",
	"heavy_attack_stats",
	"detailed_stats_light",
	"detailed_stats_heavy",
	"detailed_stats_push",
	"detailed_stats_ranged_light",
	"detailed_stats_ranged_heavy"
}
local var_0_29 = {
	weapon_melee = UIWidgets.create_simple_item_tooltip("weapon_melee", var_0_28),
	weapon_ranged = UIWidgets.create_simple_item_tooltip("weapon_ranged", var_0_28),
	weapon_melee_title = var_0_27("weapon_melee_title", "deus_weapon_inspect_primary_title"),
	weapon_ranged_title = var_0_27("weapon_ranged_title", "deus_weapon_inspect_secondary_title"),
	healing_slot = UIWidgets.create_framed_info_box("healing_slot", "menu_frame_12", "menu_frame_12", "menu_frame_12", Localize("deus_weapon_inspect_healing_title"), "consumables_empty_medpack", {
		50,
		50
	}, "button_frame_01_gold", Localize("deus_weapon_inspect_title_unavailable"), Localize("deus_weapon_inspect_info_unavailable"), {
		400,
		100
	}),
	potion_slot = UIWidgets.create_framed_info_box("potion_slot", "menu_frame_12", "menu_frame_12", "menu_frame_12", Localize("deus_weapon_inspect_potion_title"), "consumables_empty_potion", {
		50,
		50
	}, "button_frame_01_gold", Localize("deus_weapon_inspect_title_unavailable"), Localize("deus_weapon_inspect_info_unavailable"), {
		400,
		100
	}),
	grenade_slot = UIWidgets.create_framed_info_box("grenade_slot", "menu_frame_12", "menu_frame_12", "menu_frame_12", Localize("deus_weapon_inspect_grenade_title"), "consumables_empty_grenade", {
		50,
		50
	}, "button_frame_01_gold", Localize("deus_weapon_inspect_title_unavailable"), Localize("deus_weapon_inspect_info_unavailable"), {
		400,
		100
	})
}
local var_0_30 = var_0_29.weapon_melee.content

var_0_30.disable_fade_in = true
var_0_30.no_equipped_item = true
var_0_30.force_top_alignment = true

local var_0_31 = var_0_29.weapon_ranged.content

var_0_31.disable_fade_in = true
var_0_31.no_equipped_item = true
var_0_31.force_top_alignment = true

local var_0_32 = {
	reminder_text = create_reminder_text("n/a", "reminder_text")
}
local var_0_33 = {
	64,
	64
}
local var_0_34 = {
	20,
	10
}
local var_0_35 = {
	title_frame_name = "menu_frame_12",
	max_blessing_amount = 6,
	icon_frame_name = "button_frame_01_gold",
	info_frame_name = "menu_frame_12",
	spacing = 0,
	icon_size = {
		50,
		50
	},
	bottom_panel_size = {
		400,
		150
	}
}
local var_0_36 = {
	background_icon = "button_frame_01",
	width = var_0_33[1],
	icon_size = {
		35,
		35
	},
	icon_offset = {
		15.5,
		14,
		1
	},
	background_icon_size = {
		65,
		65
	},
	background_icon_offset = {
		0,
		0,
		-1
	}
}
local var_0_37 = {
	background_icon = "button_frame_01",
	width = var_0_33[1],
	icon_size = {
		58,
		58
	},
	icon_offset = {
		5,
		5,
		0
	},
	background_icon_size = {
		65,
		65
	},
	background_icon_offset = {
		0,
		0,
		1
	}
}
local var_0_38 = {
	default = {
		{
			input_action = "left_stick",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 2,
			description_text = "input_description_close"
		}
	}
}

return {
	generic_input_actions = var_0_38,
	scenegraph = var_0_15,
	widgets = var_0_26,
	equipment_widgets = var_0_29,
	reminder_widgets = var_0_32,
	blessing_widget_data = var_0_35,
	max_power_up_amount = max_power_up_amount,
	round_power_up_widget_data = var_0_36,
	rectangular_power_up_widget_data = var_0_37,
	animations_definitions = var_0_24,
	power_up_widget_size = var_0_33,
	power_up_widget_spacing = var_0_34,
	allow_boon_removal = var_0_0
}
