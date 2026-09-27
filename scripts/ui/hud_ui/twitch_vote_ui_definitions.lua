-- chunkname: @scripts/ui/hud_ui/twitch_vote_ui_definitions.lua

local tbl = {
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

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
	-- function 1
	arg_1_3 = arg_1_3 or 1

	local create_portrait_frame = UIWidgets.create_portrait_frame(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local passes = create_portrait_frame.element.passes
	local content = create_portrait_frame.content
	local style = create_portrait_frame.style
	local tbl = {
		255,
		255,
		255,
		255
	}
	local tbl_2 = {
		0,
		0,
		0
	}
	local tbl_3 = {
		86,
		108
	}

	tbl_3[1] = tbl_3[1] * arg_1_3
	tbl_3[2] = tbl_3[2] * arg_1_3

	local clone = table.clone(tbl_2)

	clone[1] = -(tbl_3[1] / 2) + clone[1] * arg_1_3
	clone[2] = -(tbl_3[2] / 2) + clone[2] * arg_1_3
	clone[3] = 2

	local str = "masked_portrait"

	content[str] = arg_1_6
	passes[#passes + 1] = {
		pass_type = "texture",
		texture_id = str,
		style_id = str,
		retained_mode = arg_1_4
	}
	style[str] = {
		color = tbl,
		offset = clone,
		size = tbl_3,
		texture_size = tbl_3
	}

	local str_2 = "mask"

	content[str_2] = "mask_rect"
	passes[#passes + 1] = {
		pass_type = "texture",
		texture_id = str_2,
		style_id = str_2,
		retained_mode = arg_1_4
	}
	style[str_2] = {
		offset = clone,
		texture_size = tbl_3,
		base_size = tbl_3
	}

	return create_portrait_frame
end

local tbl_2 = {
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
local tbl_3 = {
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
local tbl_4 = {
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
local clone = table.clone(tbl_4)

clone.font_size = 24
clone.text_color = Colors.get_color_table_with_alpha("twitch", 255)

local clone_2 = table.clone(tbl_4)

clone_2.font_size = 20
clone_2.text_color = Colors.get_color_table_with_alpha("white", 255)

local clone_3 = table.clone(tbl_4)

clone_3.localize = false
clone_3.font_size = 24

local clone_4 = table.clone(tbl_4)

clone_4.horizontal_alignment = "left"
clone_4.font_size = 24

local clone_5 = table.clone(tbl_4)

clone_5.horizontal_alignment = "right"
clone_5.font_size = 24

local num = 0.8
local tbl_5 = {
	offset = {
		-54 * num,
		-64 * num,
		0
	},
	texture_size = {
		108 * num,
		130 * num
	},
	color = {
		255,
		255,
		255,
		255
	}
}

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
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

local tbl_6 = {
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
local str = "twitch_icon_small"

return {
	vote_texts = tbl_6,
	scenegraph_definition = tbl,
	settings = {
		vote_icon_padding = 10
	},
	widgets = {
		multiple_choice = {
			background = UIWidgets.create_simple_texture("tab_menu_bg_02", "base_area"),
			timer = UIWidgets.create_simple_text("timer_default_text", "timer_rect", nil, nil, tbl_2),
			vote_icon_rect = UIWidgets.create_simple_texture("item_frame", "vote_icon_rect"),
			vote_icon = UIWidgets.create_simple_texture("markus_mercenary_crit_chance", "vote_icon"),
			vote_text = UIWidgets.create_simple_text("heal_all", "vote_text_rect", nil, nil, tbl_4),
			vote_input_rect_a = UIWidgets.create_rect_with_frame("vote_input_a", tbl.vote_input_a.size, {
				255,
				0,
				0,
				0
			}, "menu_frame_12"),
			vote_input_rect_b = UIWidgets.create_rect_with_frame("vote_input_b", tbl.vote_input_b.size, {
				255,
				0,
				0,
				0
			}, "menu_frame_12"),
			vote_input_rect_c = UIWidgets.create_rect_with_frame("vote_input_c", tbl.vote_input_c.size, {
				255,
				0,
				0,
				0
			}, "menu_frame_12"),
			vote_input_rect_d = UIWidgets.create_rect_with_frame("vote_input_d", tbl.vote_input_d.size, {
				255,
				0,
				0,
				0
			}, "menu_frame_12"),
			hero_1 = fn("portrait_a", "default", "-", num, nil, "unit_frame_portrait_default", "unit_frame_portrait_default"),
			hero_2 = fn("portrait_b", "default", "-", num, nil, "unit_frame_portrait_default", "unit_frame_portrait_default"),
			hero_3 = fn("portrait_c", "default", "-", num, nil, "unit_frame_portrait_default", "unit_frame_portrait_default"),
			hero_4 = fn("portrait_d", "default", "-", num, nil, "unit_frame_portrait_default", "unit_frame_portrait_default"),
			hero_glow_1 = UIWidgets.create_texture_with_style("portrait_glow", "portrait_a", tbl_5),
			hero_glow_2 = UIWidgets.create_texture_with_style("portrait_glow", "portrait_b", tbl_5),
			hero_glow_3 = UIWidgets.create_texture_with_style("portrait_glow", "portrait_c", tbl_5),
			hero_glow_4 = UIWidgets.create_texture_with_style("portrait_glow", "portrait_d", tbl_5),
			hero_vote_1 = UIWidgets.create_simple_text(tbl_6.multiple_choice[1], "vote_input_a", nil, nil, tbl_3),
			hero_vote_2 = UIWidgets.create_simple_text(tbl_6.multiple_choice[2], "vote_input_b", nil, nil, tbl_3),
			hero_vote_3 = UIWidgets.create_simple_text(tbl_6.multiple_choice[3], "vote_input_c", nil, nil, tbl_3),
			hero_vote_4 = UIWidgets.create_simple_text(tbl_6.multiple_choice[4], "vote_input_d", nil, nil, tbl_3),
			divider = UIWidgets.create_simple_texture("divider_01_top", "mc_divider"),
			twitch_icon_small = UIWidgets.create_simple_texture(str, "mc_twitch_icon_small")
		},
		multiple_choice_result = {
			background = UIWidgets.create_simple_texture("tab_menu_bg_02", "result_area"),
			divider = UIWidgets.create_simple_texture("divider_01_top", "mcr_divider"),
			twitch_icon_small = UIWidgets.create_simple_texture(str, "mcr_twitch_icon_small"),
			result_icon_rect = UIWidgets.create_simple_texture("item_frame", "result_icon_rect"),
			result_icon = UIWidgets.create_simple_texture("markus_mercenary_crit_chance", "result_icon"),
			result_text = UIWidgets.create_simple_text("heal_all", "result_text", nil, nil, clone),
			winner_portrait = UIWidgets.create_portrait_frame("winner_portrait", "hero_selection", "-", num, nil, "unit_frame_portrait_default"),
			winner_text = UIWidgets.create_simple_text("draw", "winner_name", nil, nil, clone_3)
		},
		standard_vote = {
			background = UIWidgets.create_simple_texture("tab_menu_bg_02", "base_area"),
			timer = UIWidgets.create_simple_text("timer_default_text", "sv_timer_rect", nil, nil, tbl_2),
			vote_icon_rect_a = UIWidgets.create_simple_texture("item_frame", "vote_icon_rect_a"),
			vote_icon_a = UIWidgets.create_simple_texture("markus_mercenary_crit_chance", "vote_icon_a"),
			vote_text_a = UIWidgets.create_simple_text("vote_text_a_default_text", "vote_text_rect_a", nil, nil, clone_4),
			vote_input_text_a = UIWidgets.create_simple_text(tbl_6.standard_vote[1], "vote_input_text_a", nil, nil, tbl_3),
			vote_icon_rect_b = UIWidgets.create_simple_texture("item_frame", "vote_icon_rect_b"),
			vote_icon_b = UIWidgets.create_simple_texture("markus_mercenary_activated_ability_clear_wounds", "vote_icon_b"),
			vote_text_b = UIWidgets.create_simple_text("vote_text_b_default_text", "vote_text_rect_b", nil, nil, clone_5),
			vote_input_text_b = UIWidgets.create_simple_text(tbl_6.standard_vote[2], "vote_input_text_b", nil, nil, tbl_3),
			result_bar_fg = UIWidgets.create_simple_texture("crafting_button_fg", "result_bar_fg"),
			result_bar_glass = UIWidgets.create_simple_texture("button_glass_01", "result_bar_glass"),
			result_bar_bg = UIWidgets.create_simple_rect("result_bar_bg", {
				255,
				0,
				0,
				0
			}),
			result_bar_fg2 = UIWidgets.create_rect_with_frame("result_bar_fg2", tbl.result_bar_fg2.size, {
				0,
				0,
				0,
				0
			}, "menu_frame_09"),
			result_bar_divier = fn_2("result_bar_mid", {
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
			twitch_icon_small = UIWidgets.create_simple_texture(str, "sv_twitch_icon_small")
		},
		standard_vote_result = {
			background = UIWidgets.create_simple_texture("tab_menu_bg_02", "sv_result_area"),
			divider = UIWidgets.create_simple_texture("divider_01_top", "sv_divider"),
			twitch_icon_small = UIWidgets.create_simple_texture(str, "svr_twitch_icon_small"),
			result_icon_rect = UIWidgets.create_simple_texture("item_frame", "sv_result_icon_rect"),
			result_icon = UIWidgets.create_simple_texture("markus_mercenary_crit_chance", "sv_result_icon"),
			result_text = UIWidgets.create_simple_text("default_result_text", "sv_result_text", nil, nil, clone),
			result_description_text = UIWidgets.create_simple_text("", "result_description_text", nil, nil, clone_2)
		}
	}
}
