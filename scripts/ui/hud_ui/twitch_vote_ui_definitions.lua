-- chunkname: @scripts/ui/hud_ui/twitch_vote_ui_definitions.lua

local var_0_0 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.popup + 1
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
			UILayer.popup + 1
		}
	},
	base_area = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			800,
			128
		},
		position = {
			0,
			210,
			1
		}
	},
	vote_icon_rect = {
		vertical_alignment = "top",
		parent = "base_area",
		horizontal_alignment = "center",
		size = {
			56,
			56
		},
		position = {
			0,
			41,
			10
		}
	},
	vote_icon = {
		vertical_alignment = "center",
		parent = "vote_icon_rect",
		horizontal_alignment = "center",
		size = {
			56,
			56
		},
		position = {
			0,
			0,
			-1
		}
	},
	vote_text_rect = {
		vertical_alignment = "center",
		parent = "base_area",
		horizontal_alignment = "center",
		size = {
			260,
			42
		},
		position = {
			0,
			30,
			10
		}
	},
	timer_rect = {
		vertical_alignment = "center",
		parent = "base_area",
		horizontal_alignment = "center",
		size = {
			48,
			32
		},
		position = {
			0,
			-50,
			10
		}
	},
	portrait_a = {
		vertical_alignment = "center",
		parent = "base_area",
		horizontal_alignment = "center",
		size = {
			96,
			72
		},
		position = {
			-240,
			52,
			10
		}
	},
	portrait_b = {
		vertical_alignment = "center",
		parent = "base_area",
		horizontal_alignment = "center",
		size = {
			96,
			72
		},
		position = {
			-144,
			52,
			10
		}
	},
	portrait_c = {
		vertical_alignment = "center",
		parent = "base_area",
		horizontal_alignment = "center",
		size = {
			96,
			72
		},
		position = {
			240,
			52,
			10
		}
	},
	portrait_d = {
		vertical_alignment = "center",
		parent = "base_area",
		horizontal_alignment = "center",
		size = {
			96,
			72
		},
		position = {
			336,
			52,
			10
		}
	},
	vote_input_a = {
		vertical_alignment = "bottom",
		parent = "portrait_a",
		horizontal_alignment = "left",
		size = {
			48,
			32
		},
		position = {
			-24,
			-67,
			20
		}
	},
	vote_input_b = {
		vertical_alignment = "bottom",
		parent = "portrait_b",
		horizontal_alignment = "left",
		size = {
			48,
			32
		},
		position = {
			-24,
			-67,
			20
		}
	},
	vote_input_c = {
		vertical_alignment = "bottom",
		parent = "portrait_c",
		horizontal_alignment = "left",
		size = {
			48,
			32
		},
		position = {
			-24,
			-67,
			20
		}
	},
	vote_input_d = {
		vertical_alignment = "bottom",
		parent = "portrait_d",
		horizontal_alignment = "left",
		size = {
			48,
			32
		},
		position = {
			-24,
			-67,
			20
		}
	},
	mc_divider = {
		vertical_alignment = "center",
		parent = "base_area",
		horizontal_alignment = "center",
		size = {
			160,
			25
		},
		position = {
			0,
			0,
			1
		}
	},
	mc_twitch_icon_small = {
		vertical_alignment = "center",
		parent = "mc_divider",
		horizontal_alignment = "center",
		size = {
			27,
			27
		},
		position = {
			0,
			0,
			1
		}
	},
	result_area = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			650,
			100
		},
		position = {
			0,
			285,
			0
		}
	},
	mcr_divider = {
		vertical_alignment = "center",
		parent = "result_area",
		horizontal_alignment = "center",
		size = {
			211,
			25
		},
		position = {
			0,
			0,
			1
		}
	},
	mcr_twitch_icon_small = {
		vertical_alignment = "center",
		parent = "mcr_divider",
		horizontal_alignment = "center",
		size = {
			27,
			27
		},
		position = {
			0,
			2,
			1
		}
	},
	result_icon_rect = {
		vertical_alignment = "top",
		parent = "result_area",
		horizontal_alignment = "center",
		size = {
			56,
			56
		},
		position = {
			0,
			48,
			10
		}
	},
	result_icon = {
		vertical_alignment = "center",
		parent = "result_icon_rect",
		horizontal_alignment = "center",
		size = {
			48,
			48
		},
		position = {
			0,
			0,
			-1
		}
	},
	winner_portrait = {
		vertical_alignment = "center",
		parent = "result_area",
		horizontal_alignment = "center",
		size = {
			96,
			72
		},
		position = {
			48,
			-52,
			1
		}
	},
	result_text = {
		vertical_alignment = "center",
		parent = "result_area",
		horizontal_alignment = "center",
		size = {
			800,
			36
		},
		position = {
			0,
			28,
			1
		}
	},
	result_description_text = {
		vertical_alignment = "center",
		parent = "result_area",
		horizontal_alignment = "center",
		size = {
			800,
			36
		},
		position = {
			0,
			-64,
			1
		}
	},
	winner_name = {
		vertical_alignment = "center",
		parent = "result_area",
		horizontal_alignment = "center",
		size = {
			640,
			24
		},
		position = {
			0,
			-28,
			1
		}
	},
	sv_timer_rect = {
		vertical_alignment = "center",
		parent = "base_area",
		horizontal_alignment = "center",
		size = {
			48,
			32
		},
		position = {
			0,
			37,
			10
		}
	},
	result_bar_fg = {
		vertical_alignment = "center",
		parent = "base_area",
		horizontal_alignment = "center",
		size = {
			459,
			36
		},
		position = {
			0,
			-0,
			7
		}
	},
	result_bar_fg2 = {
		vertical_alignment = "center",
		parent = "base_area",
		horizontal_alignment = "center",
		size = {
			463,
			38
		},
		position = {
			0,
			-2,
			8
		}
	},
	result_bar_mid = {
		vertical_alignment = "bottom",
		parent = "result_bar_fg",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-1,
			0,
			0
		}
	},
	result_bar_glass = {
		vertical_alignment = "top",
		parent = "result_bar_fg",
		horizontal_alignment = "center",
		size = {
			394,
			4
		},
		position = {
			0,
			-6,
			-1
		}
	},
	result_bar_bg = {
		vertical_alignment = "center",
		parent = "result_bar_fg",
		horizontal_alignment = "center",
		size = {
			394,
			36
		},
		position = {
			0,
			-0,
			-6
		}
	},
	sv_twitch_icon_small = {
		vertical_alignment = "center",
		parent = "result_bar_mid",
		horizontal_alignment = "center",
		size = {
			29,
			29
		},
		position = {
			1,
			16,
			10
		}
	},
	result_a_bar = {
		vertical_alignment = "bottom",
		parent = "result_bar_mid",
		horizontal_alignment = "right",
		size = {
			197,
			36
		},
		position = {
			0,
			0,
			-2
		}
	},
	result_a_bar_edge = {
		vertical_alignment = "center",
		parent = "result_a_bar",
		horizontal_alignment = "left",
		size = {
			36,
			36
		},
		position = {
			-36,
			0,
			-1
		}
	},
	result_bar_a_eyes = {
		vertical_alignment = "center",
		parent = "result_bar_fg",
		horizontal_alignment = "left",
		size = {
			75,
			20
		},
		position = {
			-22,
			-3,
			8
		}
	},
	result_b_bar = {
		vertical_alignment = "bottom",
		parent = "result_bar_mid",
		horizontal_alignment = "left",
		size = {
			197,
			36
		},
		position = {
			0,
			-0,
			-2
		}
	},
	result_b_bar_edge = {
		vertical_alignment = "center",
		parent = "result_b_bar",
		horizontal_alignment = "right",
		size = {
			36,
			36
		},
		position = {
			36,
			-0,
			-1
		}
	},
	result_bar_b_eyes = {
		vertical_alignment = "center",
		parent = "result_bar_fg",
		horizontal_alignment = "right",
		size = {
			75,
			20
		},
		position = {
			22,
			-3,
			8
		}
	},
	vote_icon_a = {
		vertical_alignment = "center",
		parent = "result_bar_fg",
		horizontal_alignment = "left",
		size = {
			48,
			48
		},
		position = {
			-60,
			0,
			-1
		}
	},
	vote_icon_rect_a = {
		vertical_alignment = "center",
		parent = "vote_icon_a",
		horizontal_alignment = "center",
		size = {
			56,
			56
		},
		position = {
			0,
			0,
			4
		}
	},
	vote_text_rect_a = {
		vertical_alignment = "bottom",
		parent = "vote_icon_a",
		horizontal_alignment = "left",
		size = {
			240,
			24
		},
		position = {
			0,
			-30,
			10
		}
	},
	vote_input_text_a = {
		vertical_alignment = "center",
		parent = "base_area",
		horizontal_alignment = "center",
		size = {
			60,
			30
		},
		position = {
			-207,
			32,
			10
		}
	},
	vote_icon_b = {
		vertical_alignment = "center",
		parent = "result_bar_fg",
		horizontal_alignment = "right",
		size = {
			48,
			48
		},
		position = {
			60,
			0,
			-1
		}
	},
	vote_icon_rect_b = {
		vertical_alignment = "center",
		parent = "vote_icon_b",
		horizontal_alignment = "center",
		size = {
			56,
			56
		},
		position = {
			0,
			0,
			4
		}
	},
	vote_text_rect_b = {
		vertical_alignment = "bottom",
		parent = "vote_icon_b",
		horizontal_alignment = "right",
		size = {
			240,
			24
		},
		position = {
			0,
			-30,
			10
		}
	},
	vote_input_text_b = {
		vertical_alignment = "center",
		parent = "base_area",
		horizontal_alignment = "center",
		size = {
			60,
			30
		},
		position = {
			207,
			32,
			10
		}
	},
	sv_result_area = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			650,
			135
		},
		position = {
			0,
			180,
			0
		}
	},
	sv_divider = {
		vertical_alignment = "center",
		parent = "sv_result_area",
		horizontal_alignment = "center",
		size = {
			211,
			26
		},
		position = {
			0,
			0,
			1
		}
	},
	svr_twitch_icon_small = {
		vertical_alignment = "center",
		parent = "sv_divider",
		horizontal_alignment = "center",
		size = {
			27,
			27
		},
		position = {
			0,
			2,
			1
		}
	},
	sv_result_icon_rect = {
		vertical_alignment = "top",
		parent = "sv_result_area",
		horizontal_alignment = "center",
		size = {
			56,
			56
		},
		position = {
			0,
			26,
			10
		}
	},
	sv_result_icon = {
		vertical_alignment = "center",
		parent = "sv_result_icon_rect",
		horizontal_alignment = "center",
		size = {
			48,
			48
		},
		position = {
			0,
			0,
			-1
		}
	},
	sv_result_text = {
		vertical_alignment = "center",
		parent = "sv_result_area",
		horizontal_alignment = "center",
		size = {
			640,
			24
		},
		position = {
			0,
			-32,
			1
		}
	}
}

local function var_0_1(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	arg_1_3 = arg_1_3 or 1

	local var_1_0 = UIWidgets.create_portrait_frame(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_1 = var_1_0.element.passes
	local var_1_2 = var_1_0.content
	local var_1_3 = var_1_0.style
	local var_1_4 = {
		255,
		255,
		255,
		255
	}
	local var_1_5 = {
		0,
		0,
		0
	}
	local var_1_6 = {
		86,
		108
	}

	var_1_6[1] = var_1_6[1] * arg_1_3
	var_1_6[2] = var_1_6[2] * arg_1_3

	local var_1_7 = table.clone(var_1_5)

	var_1_7[1] = -(var_1_6[1] / 2) + var_1_7[1] * arg_1_3
	var_1_7[2] = -(var_1_6[2] / 2) + var_1_7[2] * arg_1_3
	var_1_7[3] = 2

	local var_1_8 = "masked_portrait"

	var_1_2[var_1_8] = arg_1_6
	var_1_1[#var_1_1 + 1] = {
		pass_type = "texture",
		texture_id = var_1_8,
		style_id = var_1_8,
		retained_mode = arg_1_4
	}
	var_1_3[var_1_8] = {
		color = var_1_4,
		offset = var_1_7,
		size = var_1_6,
		texture_size = var_1_6
	}

	local var_1_9 = "mask"

	var_1_2[var_1_9] = "mask_rect"
	var_1_1[#var_1_1 + 1] = {
		pass_type = "texture",
		texture_id = var_1_9,
		style_id = var_1_9,
		retained_mode = arg_1_4
	}
	var_1_3[var_1_9] = {
		offset = var_1_7,
		texture_size = var_1_6,
		base_size = var_1_6
	}

	return var_1_0
end

local var_0_2 = {
	font_size = 60,
	upper_case = true,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_3 = {
	font_size = 26,
	upper_case = true,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
	offset = {
		-2,
		0,
		2
	}
}
local var_0_4 = {
	font_size = 28,
	upper_case = true,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		-2,
		0,
		2
	}
}
local var_0_5 = table.clone(var_0_4)

var_0_5.font_size = 24
var_0_5.text_color = Colors.get_color_table_with_alpha("twitch", 255)

local var_0_6 = table.clone(var_0_4)

var_0_6.font_size = 20
var_0_6.text_color = Colors.get_color_table_with_alpha("white", 255)

local var_0_7 = table.clone(var_0_4)

var_0_7.localize = false
var_0_7.font_size = 24

local var_0_8 = table.clone(var_0_4)

var_0_8.horizontal_alignment = "left"
var_0_8.font_size = 24

local var_0_9 = table.clone(var_0_4)

var_0_9.horizontal_alignment = "right"
var_0_9.font_size = 24

local var_0_10 = 0.8
local var_0_11 = {
	offset = {
		-54 * var_0_10,
		-64 * var_0_10,
		0
	},
	texture_size = {
		108 * var_0_10,
		130 * var_0_10
	},
	color = {
		255,
		255,
		255,
		255
	}
}

local function var_0_12(arg_2_0, arg_2_1)
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
			edge = "menu_frame_09_divider_vertical",
			edge_holder_top = "menu_frame_09_divider_top",
			edge_holder_bottom = "menu_frame_09_divider_bottom"
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
					4,
					arg_2_1[2] - 7
				},
				texture_tiling_size = {
					4,
					arg_2_1[2] - 7
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
					arg_2_1[2] - 7,
					10
				},
				size = {
					14,
					7
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
					14,
					7
				}
			}
		},
		scenegraph_id = arg_2_0,
		offset = {
			0,
			-4,
			0
		}
	}
end

local var_0_13 = {
	standard_vote = {
		"#A",
		"#B"
	},
	multiple_choice = {
		"#A",
		"#B",
		"#C",
		"#D",
		"#E"
	}
}
local var_0_14 = "twitch_icon_small"

return {
	vote_texts = var_0_13,
	scenegraph_definition = var_0_0,
	settings = {
		vote_icon_padding = 10
	},
	widgets = {
		multiple_choice = {
			background = UIWidgets.create_simple_texture("tab_menu_bg_02", "base_area"),
			timer = UIWidgets.create_simple_text("timer_default_text", "timer_rect", nil, nil, var_0_2),
			vote_icon_rect = UIWidgets.create_simple_texture("item_frame", "vote_icon_rect"),
			vote_icon = UIWidgets.create_simple_texture("markus_mercenary_crit_chance", "vote_icon"),
			vote_text = UIWidgets.create_simple_text("heal_all", "vote_text_rect", nil, nil, var_0_4),
			vote_input_rect_a = UIWidgets.create_rect_with_frame("vote_input_a", var_0_0.vote_input_a.size, {
				255,
				0,
				0,
				0
			}, "menu_frame_12"),
			vote_input_rect_b = UIWidgets.create_rect_with_frame("vote_input_b", var_0_0.vote_input_b.size, {
				255,
				0,
				0,
				0
			}, "menu_frame_12"),
			vote_input_rect_c = UIWidgets.create_rect_with_frame("vote_input_c", var_0_0.vote_input_c.size, {
				255,
				0,
				0,
				0
			}, "menu_frame_12"),
			vote_input_rect_d = UIWidgets.create_rect_with_frame("vote_input_d", var_0_0.vote_input_d.size, {
				255,
				0,
				0,
				0
			}, "menu_frame_12"),
			hero_1 = var_0_1("portrait_a", "default", "-", var_0_10, nil, "unit_frame_portrait_default", "unit_frame_portrait_default"),
			hero_2 = var_0_1("portrait_b", "default", "-", var_0_10, nil, "unit_frame_portrait_default", "unit_frame_portrait_default"),
			hero_3 = var_0_1("portrait_c", "default", "-", var_0_10, nil, "unit_frame_portrait_default", "unit_frame_portrait_default"),
			hero_4 = var_0_1("portrait_d", "default", "-", var_0_10, nil, "unit_frame_portrait_default", "unit_frame_portrait_default"),
			hero_glow_1 = UIWidgets.create_texture_with_style("portrait_glow", "portrait_a", var_0_11),
			hero_glow_2 = UIWidgets.create_texture_with_style("portrait_glow", "portrait_b", var_0_11),
			hero_glow_3 = UIWidgets.create_texture_with_style("portrait_glow", "portrait_c", var_0_11),
			hero_glow_4 = UIWidgets.create_texture_with_style("portrait_glow", "portrait_d", var_0_11),
			hero_vote_1 = UIWidgets.create_simple_text(var_0_13.multiple_choice[1], "vote_input_a", nil, nil, var_0_3),
			hero_vote_2 = UIWidgets.create_simple_text(var_0_13.multiple_choice[2], "vote_input_b", nil, nil, var_0_3),
			hero_vote_3 = UIWidgets.create_simple_text(var_0_13.multiple_choice[3], "vote_input_c", nil, nil, var_0_3),
			hero_vote_4 = UIWidgets.create_simple_text(var_0_13.multiple_choice[4], "vote_input_d", nil, nil, var_0_3),
			divider = UIWidgets.create_simple_texture("divider_01_top", "mc_divider"),
			twitch_icon_small = UIWidgets.create_simple_texture(var_0_14, "mc_twitch_icon_small")
		},
		multiple_choice_result = {
			background = UIWidgets.create_simple_texture("tab_menu_bg_02", "result_area"),
			divider = UIWidgets.create_simple_texture("divider_01_top", "mcr_divider"),
			twitch_icon_small = UIWidgets.create_simple_texture(var_0_14, "mcr_twitch_icon_small"),
			result_icon_rect = UIWidgets.create_simple_texture("item_frame", "result_icon_rect"),
			result_icon = UIWidgets.create_simple_texture("markus_mercenary_crit_chance", "result_icon"),
			result_text = UIWidgets.create_simple_text("heal_all", "result_text", nil, nil, var_0_5),
			winner_portrait = UIWidgets.create_portrait_frame("winner_portrait", "hero_selection", "-", var_0_10, nil, "unit_frame_portrait_default"),
			winner_text = UIWidgets.create_simple_text("draw", "winner_name", nil, nil, var_0_7)
		},
		standard_vote = {
			background = UIWidgets.create_simple_texture("tab_menu_bg_02", "base_area"),
			timer = UIWidgets.create_simple_text("timer_default_text", "sv_timer_rect", nil, nil, var_0_2),
			vote_icon_rect_a = UIWidgets.create_simple_texture("item_frame", "vote_icon_rect_a"),
			vote_icon_a = UIWidgets.create_simple_texture("markus_mercenary_crit_chance", "vote_icon_a"),
			vote_text_a = UIWidgets.create_simple_text("vote_text_a_default_text", "vote_text_rect_a", nil, nil, var_0_8),
			vote_input_text_a = UIWidgets.create_simple_text(var_0_13.standard_vote[1], "vote_input_text_a", nil, nil, var_0_3),
			vote_icon_rect_b = UIWidgets.create_simple_texture("item_frame", "vote_icon_rect_b"),
			vote_icon_b = UIWidgets.create_simple_texture("markus_mercenary_activated_ability_clear_wounds", "vote_icon_b"),
			vote_text_b = UIWidgets.create_simple_text("vote_text_b_default_text", "vote_text_rect_b", nil, nil, var_0_9),
			vote_input_text_b = UIWidgets.create_simple_text(var_0_13.standard_vote[2], "vote_input_text_b", nil, nil, var_0_3),
			result_bar_fg = UIWidgets.create_simple_texture("crafting_button_fg", "result_bar_fg"),
			result_bar_glass = UIWidgets.create_simple_texture("button_glass_01", "result_bar_glass"),
			result_bar_bg = UIWidgets.create_simple_rect("result_bar_bg", {
				255,
				0,
				0,
				0
			}),
			result_bar_fg2 = UIWidgets.create_rect_with_frame("result_bar_fg2", var_0_0.result_bar_fg2.size, {
				0,
				0,
				0,
				0
			}, "menu_frame_09"),
			result_bar_divier = var_0_12("result_bar_mid", {
				4,
				40
			}),
			result_a_bar_edge = UIWidgets.create_simple_uv_texture("experience_bar_edge_glow", {
				{
					1,
					1
				},
				{
					0,
					0
				}
			}, "result_a_bar_edge"),
			result_a_bar = UIWidgets.create_simple_uv_texture("experience_bar_fill", {
				{
					1,
					1
				},
				{
					0,
					0
				}
			}, "result_a_bar"),
			result_bar_a_eyes = UIWidgets.create_simple_texture("mission_objective_glow_02", "result_bar_a_eyes"),
			result_b_bar_edge = UIWidgets.create_simple_uv_texture("experience_bar_edge_glow", {
				{
					0,
					0
				},
				{
					1,
					1
				}
			}, "result_b_bar_edge", nil, nil, Colors.get_table("yellow")),
			result_b_bar = UIWidgets.create_simple_uv_texture("experience_bar_fill", {
				{
					0,
					0
				},
				{
					1,
					1
				}
			}, "result_b_bar", nil, nil, Colors.get_table("yellow")),
			result_bar_b_eyes = UIWidgets.create_simple_texture("mission_objective_glow_02", "result_bar_b_eyes"),
			twitch_icon_small = UIWidgets.create_simple_texture(var_0_14, "sv_twitch_icon_small")
		},
		standard_vote_result = {
			background = UIWidgets.create_simple_texture("tab_menu_bg_02", "sv_result_area"),
			divider = UIWidgets.create_simple_texture("divider_01_top", "sv_divider"),
			twitch_icon_small = UIWidgets.create_simple_texture(var_0_14, "svr_twitch_icon_small"),
			result_icon_rect = UIWidgets.create_simple_texture("item_frame", "sv_result_icon_rect"),
			result_icon = UIWidgets.create_simple_texture("markus_mercenary_crit_chance", "sv_result_icon"),
			result_text = UIWidgets.create_simple_text("default_result_text", "sv_result_text", nil, nil, var_0_5),
			result_description_text = UIWidgets.create_simple_text("", "result_description_text", nil, nil, var_0_6)
		}
	}
}
