-- chunkname: @scripts/ui/views/versus_menu/versus_party_char_selection_view_definitions.lua

local var_0_0 = false
local var_0_1 = 1600
local var_0_2 = 318
local var_0_3 = 60
local var_0_4 = {
	474,
	46
}
local var_0_5 = {
	70,
	80
}
local var_0_6 = {
	screen = {
		0,
		0,
		UILayer.default
	},
	player_name_box_1 = {
		-720,
		250,
		20
	},
	player_name_box_2 = {
		-240,
		250,
		20
	},
	player_name_box_3 = {
		240,
		250,
		20
	},
	player_name_box_4 = {
		720,
		250,
		20
	},
	bottom_bar = {
		0,
		0,
		10
	},
	menu_root = {
		0,
		0,
		0
	},
	hero_roster = {
		0,
		150,
		2
	},
	hero_group_1 = {
		-(var_0_2 + var_0_3) * 2,
		0,
		1
	},
	hero_group_2 = {
		-(var_0_2 + var_0_3),
		0,
		1
	},
	hero_group_3 = {
		0,
		0,
		1
	},
	hero_group_4 = {
		var_0_2 + var_0_3,
		0,
		1
	},
	hero_group_5 = {
		(var_0_2 + var_0_3) * 2,
		0,
		1
	},
	background = {
		0,
		0,
		1
	},
	progress_bar_edge_bottom = {
		0,
		-2,
		15
	},
	progress_bar_edge_top = {
		0,
		10,
		15
	},
	progress_bar = {
		0,
		0,
		1
	},
	progress_bar_anchor = {
		0,
		234,
		18
	},
	progress_bar_end_glow = {
		28,
		0,
		0
	},
	progress_bar_passive = {
		0,
		0,
		4
	},
	progress_bar_rect = {
		0,
		0,
		-1
	},
	progress_point = {
		0,
		0,
		100
	},
	countdown_timer = {
		0,
		130,
		3
	},
	selected_career_title = {
		50,
		-50,
		3
	},
	selected_hero_title = {
		70,
		-190,
		3
	},
	player_info_text = {
		0,
		-15,
		10
	},
	player_info_text_background = {
		0,
		200,
		10
	},
	local_player_picking_frame = {
		0,
		0,
		200
	},
	hero_name_text_anchor = {
		50,
		-75,
		10
	},
	parading_info = {
		0,
		-200,
		10
	}
}
local var_0_7 = {
	screen = {
		1920,
		1080
	},
	player_name_box_1 = var_0_4,
	player_name_box_2 = var_0_4,
	player_name_box_3 = var_0_4,
	player_name_box_4 = var_0_4,
	bottom_bar = {
		1920,
		250
	},
	menu_root = {
		1920,
		1080
	},
	hero_roster = {
		1920,
		0
	},
	hero_group_1 = {
		var_0_2,
		91
	},
	hero_group_2 = {
		var_0_2,
		91
	},
	hero_group_3 = {
		var_0_2,
		91
	},
	hero_group_4 = {
		var_0_2,
		91
	},
	hero_group_5 = {
		var_0_2,
		91
	},
	background = {
		1920,
		1080
	},
	progress_bar_edge_bottom = {
		1920,
		2
	},
	progress_bar_edge_top = {
		1920,
		2
	},
	progress_bar = {
		1920,
		10
	},
	progress_bar_end_glow = {
		100,
		10
	},
	progress_bar_passive = {
		1920,
		10
	},
	progress_bar_rect = {
		1920,
		10
	},
	progress_point = {
		0,
		0
	},
	countdown_timer = {
		1900,
		300
	},
	selected_career_title = {
		1900,
		180
	},
	selected_hero_title = {
		1900,
		180
	},
	player_info_text = {
		800,
		88
	},
	player_info_text_background = {
		1920,
		88
	},
	local_player_picking_frame = {
		1920,
		1080
	},
	local_player_flame_highlight = {
		1820,
		440
	},
	hero_name_text_anchor = {
		0,
		0
	},
	background_image_heroes = {
		892.8000000000001,
		1231.2
	},
	background_image_dark_pact = {
		873,
		927
	},
	parading_info = {
		640,
		120
	}
}
local var_0_8 = {
	screen = {
		scale = "fit",
		size = var_0_7.screen,
		position = var_0_6.screen
	},
	menu_root = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = var_0_7.menu_root,
		position = var_0_6.menu_root
	},
	bottom_bar = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		horizontal_alignment = "center",
		size = var_0_7.bottom_bar,
		position = var_0_6.bottom_bar
	},
	player_name_box_1 = {
		vertical_alignment = "bottom",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_7.player_name_box_1,
		position = var_0_6.player_name_box_1
	},
	player_name_box_2 = {
		vertical_alignment = "bottom",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_7.player_name_box_2,
		position = var_0_6.player_name_box_2
	},
	player_name_box_3 = {
		vertical_alignment = "bottom",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_7.player_name_box_3,
		position = var_0_6.player_name_box_3
	},
	player_name_box_4 = {
		vertical_alignment = "bottom",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_7.player_name_box_4,
		position = var_0_6.player_name_box_4
	},
	hero_roster = {
		vertical_alignment = "bottom",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_7.hero_roster,
		position = var_0_6.hero_roster
	},
	hero_group_1 = {
		vertical_alignment = "center",
		parent = "hero_roster",
		horizontal_alignment = "center",
		size = var_0_7.hero_group_1,
		position = var_0_6.hero_group_1
	},
	hero_group_2 = {
		vertical_alignment = "center",
		parent = "hero_roster",
		horizontal_alignment = "center",
		size = var_0_7.hero_group_2,
		position = var_0_6.hero_group_2
	},
	hero_group_3 = {
		vertical_alignment = "center",
		parent = "hero_roster",
		horizontal_alignment = "center",
		size = var_0_7.hero_group_3,
		position = var_0_6.hero_group_3
	},
	hero_group_4 = {
		vertical_alignment = "center",
		parent = "hero_roster",
		horizontal_alignment = "center",
		size = var_0_7.hero_group_4,
		position = var_0_6.hero_group_4
	},
	hero_group_5 = {
		vertical_alignment = "center",
		parent = "hero_roster",
		horizontal_alignment = "center",
		size = var_0_7.hero_group_5,
		position = var_0_6.hero_group_5
	},
	background = {
		vertical_alignment = "bottom",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = var_0_7.background,
		position = var_0_6.background
	},
	progress_bar_anchor = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = var_0_7.progress_bar,
		position = var_0_6.progress_bar_anchor
	},
	progress_bar = {
		vertical_alignment = "bottom",
		parent = "progress_bar_anchor",
		size = var_0_7.progress_bar,
		position = var_0_6.progress_bar
	},
	progress_bar_edge_bottom = {
		vertical_alignment = "bottom",
		parent = "progress_bar_anchor",
		size = var_0_7.progress_bar_edge_bottom,
		position = var_0_6.progress_bar_edge_bottom
	},
	progress_bar_edge_top = {
		vertical_alignment = "bottom",
		parent = "progress_bar_anchor",
		size = var_0_7.progress_bar_edge_top,
		position = var_0_6.progress_bar_edge_top
	},
	progress_bar_end_glow = {
		vertical_alignment = "center",
		parent = "progress_bar",
		horizontal_alignment = "right",
		size = var_0_7.progress_bar_end_glow,
		position = var_0_6.progress_bar_end_glow
	},
	progress_bar_passive = {
		vertical_alignment = "bottom",
		parent = "progress_bar",
		size = var_0_7.progress_bar_passive,
		position = var_0_6.progress_bar_passive
	},
	progress_bar_rect = {
		vertical_alignment = "bottom",
		parent = "progress_bar",
		size = var_0_7.progress_bar_rect,
		position = var_0_6.progress_bar_rect
	},
	progress_point = {
		vertical_alignment = "center",
		parent = "progress_bar_rect",
		horizontal_alignment = "left",
		size = var_0_7.progress_point,
		position = var_0_6.progress_point
	},
	countdown_timer = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = var_0_7.countdown_timer,
		position = var_0_6.countdown_timer
	},
	selected_career_title = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = var_0_7.selected_career_title,
		position = var_0_6.selected_career_title
	},
	selected_hero_title = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = var_0_7.selected_hero_title,
		position = var_0_6.selected_hero_title
	},
	player_info_text_background = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		horizontal_alignment = "center",
		size = var_0_7.player_info_text_background,
		position = var_0_6.player_info_text_background
	},
	player_info_text = {
		vertical_alignment = "bottom",
		parent = "player_info_text_background",
		horizontal_alignment = "center",
		size = var_0_7.player_info_text,
		position = var_0_6.player_info_text
	},
	local_player_picking_frame = {
		vertical_alignment = "bottom",
		scale = "fit",
		horizontal_alignment = "center",
		size = var_0_7.local_player_picking_frame,
		position = var_0_6.local_player_picking_frame
	},
	local_player_flame_highlight = {
		vertical_alignment = "bottom",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = var_0_7.local_player_flame_highlight,
		position = var_0_6.local_player_flame_highlight
	},
	hero_name_text_anchor = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = var_0_7.hero_name_text_anchor,
		position = var_0_6.hero_name_text_anchor
	},
	parading_info = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = var_0_7.parading_info,
		position = var_0_6.parading_info
	}
}

local function var_0_9(arg_1_0)
	return {
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture",
					content_check_function = function (arg_2_0)
						return arg_2_0.highlight and arg_2_0.is_local_player and not arg_2_0.done
					end
				},
				{
					texture_id = "glow_done",
					style_id = "glow_done",
					pass_type = "texture",
					content_check_function = function (arg_3_0)
						return arg_3_0.done
					end
				},
				{
					style_id = "glow_done_animation",
					pass_type = "texture",
					texture_id = "glow_done",
					content_check_function = function (arg_4_0)
						return arg_4_0.done
					end,
					content_change_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
						local var_5_0 = arg_5_0.done
						local var_5_1 = arg_5_1.anim_progress

						if var_5_0 then
							var_5_1 = arg_5_1.anim_progress or 0

							local var_5_2 = arg_5_1.texture_size
							local var_5_3 = arg_5_1.default_size
							local var_5_4 = 2
							local var_5_5 = math.easeOutCubic(var_5_1)

							var_5_2[1] = var_5_3[1] + var_5_3[1] * var_5_4 * var_5_5
							var_5_2[2] = var_5_3[2] + var_5_3[2] * var_5_4 * var_5_5
							arg_5_1.color[1] = 255 * (1 - var_5_5)
							arg_5_1.anim_progress = math.min(var_5_1 + arg_5_3, 1)
						elseif var_5_1 then
							arg_5_1.anim_progress = nil
						end
					end
				}
			}
		},
		content = {
			is_local_player = false,
			background = "versus_hero_selection_skull",
			glow = "versus_hero_selection_skull_eyes_glow",
			highlight = false,
			glow_done = "versus_hero_selection_skull_eyes_glow"
		},
		style = {
			background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					36,
					50
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-1,
					0,
					1
				}
			},
			glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					48,
					55
				},
				color = {
					255,
					0,
					136,
					255
				},
				offset = {
					-1,
					5,
					2
				}
			},
			glow_done = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					48,
					55
				},
				color = {
					255,
					255,
					123,
					0
				},
				offset = {
					-1,
					5,
					3
				}
			},
			glow_done_animation = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					48,
					55
				},
				default_size = {
					48,
					55
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-1,
					0,
					3
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local function var_0_10(arg_6_0, arg_6_1)
	local var_6_0 = "versus_hero_selection_hero_portrait_frame"
	local var_6_1 = UIFrameSettings[var_6_0]
	local var_6_2 = var_6_1.texture_sizes.horizontal[2]
	local var_6_3 = "shadow_frame_02"
	local var_6_4 = UIFrameSettings[var_6_3]
	local var_6_5 = var_6_4.texture_sizes.horizontal[2]

	return {
		alpha_multiplier = 1,
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "portrait",
					style_id = "portrait",
					pass_type = "texture"
				},
				{
					texture_id = "lock_texture",
					style_id = "lock_texture",
					pass_type = "texture",
					content_check_function = function (arg_7_0)
						return arg_7_0.locked
					end
				},
				{
					texture_id = "lock_texture",
					style_id = "lock_texture_shadow",
					pass_type = "texture",
					content_check_function = function (arg_8_0)
						return arg_8_0.locked
					end
				},
				{
					texture_id = "selected_texture",
					style_id = "local_player_selected_texture",
					pass_type = "texture"
				},
				{
					texture_id = "selected_texture",
					style_id = "other_player_selected_texture",
					pass_type = "texture"
				},
				{
					pass_type = "texture_frame",
					style_id = "frame_passive",
					texture_id = "frame_passive",
					content_check_function = function (arg_9_0)
						return arg_9_0.locked or arg_9_0.taken or arg_9_0.other_picking
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame_passive",
					texture_id = "frame_passive",
					content_check_function = function (arg_10_0)
						return arg_10_0.locked or arg_10_0.taken or arg_10_0.other_picking
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "local_player_frame",
					texture_id = "local_player_frame",
					content_check_function = function (arg_11_0)
						return not arg_11_0.locked and not arg_11_0.taken and not arg_11_0.other_picking
					end
				},
				{
					pass_type = "texture",
					style_id = "other_hover",
					texture_id = "other_hover",
					content_check_function = function (arg_12_0)
						return arg_12_0.hovered_by_other and not arg_12_0.button_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "local_player_select_frame",
					texture_id = "local_player_select_frame",
					content_check_function = function (arg_13_0)
						return arg_13_0.button_hotspot.is_hover or arg_13_0.gamepad_selected
					end
				}
			}
		},
		content = {
			portrait = "icons_placeholder",
			hovered_by_other = false,
			selected_texture = "versus_hero_selection_hero_selected_effect",
			lock_texture = "hero_icon_locked_gold",
			other_hover = "versus_hero_selection_frame",
			taken_id = 1,
			other_picking = true,
			gamepad_selected = false,
			taken = false,
			local_player_select_frame = "versus_hero_selection_frame",
			button_hotspot = {},
			local_player_frame = var_6_1.texture,
			frame_passive = var_6_4.texture,
			size = arg_6_1
		},
		style = {
			portrait = {
				size = arg_6_1,
				default_size = arg_6_1,
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
				default_offset = {
					0,
					0,
					1
				}
			},
			lock_texture = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = {
					50,
					57
				},
				default_size = {
					50,
					57
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					(arg_6_1[1] - 50) / 2,
					(arg_6_1[2] - 57) / 2,
					5
				},
				default_offset = {
					(arg_6_1[1] - 50) / 2,
					(arg_6_1[2] - 57) / 2,
					5
				}
			},
			lock_texture_shadow = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = {
					50,
					57
				},
				default_size = {
					50,
					57
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					(arg_6_1[1] - 50) / 2 + 2,
					(arg_6_1[2] - 57) / 2 - 2,
					4
				},
				default_offset = {
					(arg_6_1[1] - 50) / 2 + 2,
					(arg_6_1[2] - 57) / 2 - 2,
					4
				}
			},
			local_player_selected_texture = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = {
					arg_6_1[1],
					arg_6_1[2] - 2
				},
				default_size = {
					arg_6_1[1],
					arg_6_1[2] - 2
				},
				color = Colors.get_color_table_with_alpha("local_player_picking", 255),
				offset = {
					0,
					0,
					2
				},
				default_offset = {
					0,
					0,
					2
				}
			},
			other_player_selected_texture = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = {
					arg_6_1[1],
					arg_6_1[2] - 2
				},
				default_size = {
					arg_6_1[1],
					arg_6_1[2] - 2
				},
				color = Colors.get_color_table_with_alpha("other_player_picking", 255),
				offset = {
					0,
					0,
					2
				},
				default_offset = {
					0,
					0,
					2
				}
			},
			local_player_frame = {
				size = {
					arg_6_1[1] - 2,
					arg_6_1[2] - 2
				},
				default_size = {
					arg_6_1[1] - 2,
					arg_6_1[2] - 2
				},
				texture_size = var_6_1.texture_size,
				texture_sizes = var_6_1.texture_sizes,
				frame_margins = {
					-var_6_2,
					-var_6_2
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
					4
				},
				default_offset = {
					0,
					0,
					4
				}
			},
			frame_passive = {
				size = arg_6_1,
				default_size = arg_6_1,
				texture_size = var_6_4.texture_size,
				texture_sizes = var_6_4.texture_sizes,
				frame_margins = {
					-var_6_5,
					-var_6_5
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					4
				},
				default_offset = {
					0,
					0,
					4
				}
			},
			local_player_select_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = {
					arg_6_1[1] + 16,
					arg_6_1[2] + 20
				},
				default_size = {
					arg_6_1[1] + 16,
					arg_6_1[2] + 20
				},
				color = Colors.get_color_table_with_alpha("local_player_picking", 255),
				offset = {
					-9,
					-10,
					21
				},
				default_offset = {
					-10,
					-10,
					21
				}
			},
			other_hover = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = {
					arg_6_1[1] + 16,
					arg_6_1[2] + 20
				},
				default_size = {
					arg_6_1[1] + 16,
					arg_6_1[2] + 20
				},
				color = Colors.get_color_table_with_alpha("other_player_picking", 255),
				offset = {
					-9,
					-10,
					21
				},
				default_offset = {
					-10,
					-10,
					21
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_6_0
	}
end

local function var_0_11(arg_14_0)
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "detail_texture",
					texture_id = "detail_texture"
				},
				{
					style_id = "hero_name",
					pass_type = "text",
					text_id = "hero_name",
					content_change_function = function (arg_15_0, arg_15_1)
						if arg_15_0.taken then
							arg_15_1.text_color = {
								255,
								76,
								35,
								14
							}
						end
					end
				},
				{
					style_id = "available_text",
					pass_type = "text",
					text_id = "available_text",
					content_check_function = function (arg_16_0)
						return arg_16_0.side == "dark_pact"
					end
				}
			}
		},
		content = {
			available_text = "-/-",
			side = "heroes",
			detail_texture = "versus_hero_selection_divider",
			hero_name = "HERO",
			taken = false,
			enemy_role = "-"
		},
		style = {
			detail_texture = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					256,
					28.8
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
					1
				}
			},
			hero_name = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 25,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				use_shadow = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-30,
					2
				},
				shadow_offset = {
					1,
					1,
					0
				}
			},
			available_text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 25,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				use_shadow = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("green", 255),
				offset = {
					100,
					-30,
					3
				},
				shadow_offset = {
					1,
					1,
					0
				}
			}
		},
		offset = {
			0,
			-25,
			100
		},
		scenegraph_id = arg_14_0
	}
end

local function var_0_12()
	local var_17_0 = {}
	local var_17_1 = {
		4,
		4,
		4,
		4,
		4
	}
	local var_17_2 = {}

	for iter_17_0 = 1, #var_17_1 do
		local var_17_3 = var_17_1[iter_17_0]
		local var_17_4 = "hero_group_" .. iter_17_0
		local var_17_5 = var_0_8[var_17_4]
		local var_17_6 = 10
		local var_17_7 = var_17_5.size[1] - var_17_6 / 2

		var_17_0[iter_17_0] = {}
		var_17_2[iter_17_0] = var_0_11("hero_group_" .. iter_17_0)

		for iter_17_1 = 1, var_17_3 do
			local var_17_8 = "hero_root_" .. iter_17_0 .. "_" .. iter_17_1

			var_0_8[var_17_8] = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				parent = var_17_4,
				size = {
					70,
					80
				},
				position = {
					0 + (iter_17_1 - 1) * 77,
					0,
					1
				}
			}
			var_17_0[iter_17_0][iter_17_1] = var_0_10(var_17_8, var_0_5)
		end
	end

	return var_17_0, var_17_2
end

local function var_0_13(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_2 or var_0_8[arg_18_0].size
	local var_18_1 = arg_18_1 or {
		0,
		0,
		11
	}
	local var_18_2 = "menu_frame_12"
	local var_18_3 = UIFrameSettings[var_18_2]
	local var_18_4 = var_18_3.texture_sizes.horizontal[2]
	local var_18_5 = UIFrameSettings.button_frame_02

	return {
		element = {
			passes = {
				{
					pass_type = "tiled_texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					style_id = "player_name",
					pass_type = "text",
					text_id = "player_name"
				},
				{
					pass_type = "texture",
					style_id = "mute_background_fade",
					texture_id = "mute_background_fade",
					content_check_function = function (arg_19_0)
						local var_19_0 = arg_19_0.is_player

						return arg_19_0.is_player and not arg_19_0.is_local_player
					end
				},
				{
					texture_id = "mute_button_frame",
					style_id = "mute_button_frame",
					pass_type = "texture_frame",
					content_check_function = function (arg_20_0)
						local var_20_0 = arg_20_0.is_player

						return arg_20_0.is_player and not arg_20_0.is_local_player
					end
				},
				{
					pass_type = "texture",
					style_id = "mute_icon",
					texture_id = "mute_icon",
					content_check_function = function (arg_21_0)
						local var_21_0 = arg_21_0.is_player

						return arg_21_0.is_player and not arg_21_0.is_local_player
					end
				},
				{
					pass_type = "texture",
					style_id = "mute_icon_hovered",
					texture_id = "mute_icon",
					content_check_function = function (arg_22_0)
						return arg_22_0.is_player and not arg_22_0.is_local_player and arg_22_0.hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "mute_icon_muted",
					texture_id = "mute_icon_muted",
					content_check_function = function (arg_23_0)
						return arg_23_0.is_player and not arg_23_0.is_local_player and arg_23_0.muted
					end
				},
				{
					style_id = "mute_icon",
					pass_type = "hotspot",
					content_id = "hotspot",
					content_check_function = function (arg_24_0)
						return arg_24_0.parent.is_player and not arg_24_0.parent.is_local_player
					end
				}
			}
		},
		content = {
			mute_icon_muted = "tab_menu_icon_03",
			player_name = "BOT",
			mute_background_fade = "button_bg_fade",
			is_player = false,
			muted = false,
			is_local_player = false,
			background = "item_tooltip_background",
			mute_icon = "tab_menu_icon_01",
			mute_button_frame = var_18_5.texture,
			frame = var_18_3.texture,
			hotspot = {}
		},
		style = {
			background = {
				vertical_alignment = "center",
				masked = true,
				horizontal_alignment = "center",
				texture_size = var_0_4,
				texture_tiling_size = {
					256,
					256
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
					1
				}
			},
			frame = {
				size = {
					var_18_0[1] - 6,
					var_18_0[2] - 6
				},
				default_size = var_18_0,
				texture_size = var_18_3.texture_size,
				texture_sizes = var_18_3.texture_sizes,
				frame_margins = {
					-var_18_4 - 2,
					-var_18_4 - 2
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					3,
					3,
					4
				},
				default_offset = {
					3,
					3,
					4
				}
			},
			player_name = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 25,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				use_shadow = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					8
				},
				shadow_offset = {
					1,
					1,
					0
				}
			},
			mute_background_fade = {
				size = {
					42,
					42
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_0_8[arg_18_0].size[1] - 57,
					3,
					8
				}
			},
			mute_button_frame = {
				size = {
					42,
					42
				},
				texture_size = var_18_5.texture_size,
				texture_sizes = var_18_5.texture_sizes,
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_0_8[arg_18_0].size[1] - 57,
					3,
					8
				}
			},
			mute_icon = {
				size = {
					38,
					38
				},
				color = Colors.get_color_table_with_alpha("white", 200),
				offset = {
					var_0_8[arg_18_0].size[1] - 55,
					5,
					8
				}
			},
			mute_icon_hovered = {
				size = {
					38,
					38
				},
				color = Colors.get_color_table_with_alpha("white", 250),
				offset = {
					var_0_8[arg_18_0].size[1] - 55,
					5,
					9
				}
			},
			mute_icon_muted = {
				size = {
					38,
					38
				},
				color = Colors.get_color_table_with_alpha("red", 250),
				offset = {
					var_0_8[arg_18_0].size[1] - 55,
					5,
					10
				}
			}
		},
		scenegraph_id = arg_18_0,
		offset = var_18_1
	}
end

local var_0_14 = {
	480,
	80
}

local function var_0_15()
	local var_25_0 = {}
	local var_25_1 = 4

	for iter_25_0 = 1, var_25_1 do
		local var_25_2 = "player_name_box_" .. iter_25_0
		local var_25_3 = var_0_13(var_25_2)

		var_25_0[#var_25_0 + 1] = var_25_3
	end

	return var_25_0
end

local function var_0_16(arg_26_0)
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "arrow_texture",
					texture_id = "arrow_texture",
					pass_type = "texture",
					content_change_function = function (arg_27_0, arg_27_1)
						arg_27_1.color[1] = 165 + 95 * math.sin(Managers.time:time("ui") * 5) * 0.75
					end
				}
			}
		},
		content = {
			text = "versus_hero_selection_view_you",
			arrow_texture = "turn_arrow"
		},
		style = {
			text = {
				font_size = 120,
				upper_case = true,
				localize = true,
				word_wrap = false,
				horizontal_alignment = "center",
				use_shadow = true,
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				size = {
					100,
					100
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					40,
					2
				},
				shadow_offset = {
					1,
					1,
					0
				}
			},
			arrow_texture = {
				size = {
					83.2,
					26.650000000000002
				},
				color = Colors.get_color_table_with_alpha("local_player_picking", 255),
				offset = {
					0,
					25,
					4
				}
			}
		},
		offset = {
			var_0_4[1] * 0.5 - 50,
			30,
			50
		},
		scenegraph_id = arg_26_0
	}
end

local function var_0_17(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	local var_28_0 = arg_28_2 or "icons_placeholder"
	local var_28_1 = arg_28_1 or "n/a"
	local var_28_2 = arg_28_3 or "n/a"

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "skill_icon",
					texture_id = "skill_icon"
				},
				{
					pass_type = "texture",
					style_id = "icon_frame",
					texture_id = "icon_frame"
				},
				{
					style_id = "skill_type",
					pass_type = "text",
					text_id = "skill_type"
				},
				{
					style_id = "skill_name",
					pass_type = "text",
					text_id = "skill_name"
				}
			}
		},
		content = {
			icon_frame = "icon_talent_frame",
			skill_icon = var_28_0,
			skill_type = var_28_1,
			skill_name = var_28_2
		},
		style = {
			skill_icon = {
				size = {
					64,
					64
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-32,
					5
				}
			},
			icon_frame = {
				size = {
					64,
					64
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-32,
					6
				}
			},
			skill_type = {
				word_wrap = false,
				font_size = 20,
				localize = false,
				use_shadow = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark",
				size = {
					100,
					25
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					75,
					0,
					2
				},
				shadow_offset = {
					1,
					1,
					0
				}
			},
			skill_name = {
				word_wrap = false,
				font_size = 24,
				localize = false,
				use_shadow = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark",
				size = {
					100,
					25
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					75,
					-24,
					2
				},
				shadow_offset = {
					1,
					1,
					0
				}
			}
		},
		offset = {
			0,
			0,
			10
		},
		scenegraph_id = arg_28_0
	}
end

generic_input_actions = {
	default = {
		actions = {
			{
				input_action = "d_horizontal",
				priority = 1,
				description_text = "input_description_navigate",
				ignore_keybinding = true
			},
			{
				input_action = "confirm",
				priority = 2,
				description_text = "input_description_select_character"
			},
			{
				input_action = "cycle_next",
				priority = 3,
				description_text = "input_description_next_hero"
			},
			{
				input_action = "cycle_previous",
				priority = 4,
				description_text = "input_description_previous_hero"
			}
		}
	}
}

local var_0_18 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				arg_29_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				local var_30_0 = math.easeOutCubic(arg_30_3)

				arg_30_4.render_settings.alpha_multiplier = var_30_0
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				arg_32_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				local var_33_0 = math.easeOutCubic(arg_33_3)

				arg_33_4.render_settings.alpha_multiplier = 1 - var_33_0
			end,
			on_complete = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end
		}
	},
	transition_to_selection = {
		{
			name = "fade_out_startup",
			start_progress = 0,
			end_progress = 0.4,
			init = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				return
			end,
			update = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				local var_36_0 = arg_36_4.self._widgets_by_name
				local var_36_1 = var_36_0.countdown_timer
				local var_36_2 = var_36_0.your_turn_indicator_text
				local var_36_3 = math.easeOutCubic(arg_36_3)

				var_36_1.alpha_multiplier = 1 - var_36_3
				var_36_2.style.text.text_color[1] = 255 * (1 - var_36_3)
			end,
			on_complete = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				return
			end
		},
		{
			name = "fade_in_top_details",
			start_progress = 0,
			end_progress = 0.4,
			init = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				return
			end,
			update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				local var_39_0 = arg_39_4.self._top_detail_widgets
				local var_39_1 = math.easeOutCubic(arg_39_3)

				for iter_39_0, iter_39_1 in ipairs(var_39_0) do
					iter_39_1.alpha_multiplier = var_39_1
				end
			end,
			on_complete = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				return
			end
		}
	},
	transition_to_team_parading = {
		{
			name = "fade_out_hero_selection",
			start_progress = 0,
			end_progress = 0.4,
			init = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				return
			end,
			update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
				local var_42_0 = arg_42_4.self
				local var_42_1 = math.easeOutCubic(arg_42_3)

				for iter_42_0, iter_42_1 in ipairs(var_42_0._other_widgets) do
					if iter_42_1.alpha_multiplier ~= 0 then
						iter_42_1.alpha_multiplier = 1 - var_42_1
					end
				end

				for iter_42_2, iter_42_3 in ipairs(var_42_0._hero_group_widgets) do
					iter_42_3.alpha_multiplier = 1 - var_42_1
				end

				for iter_42_4, iter_42_5 in ipairs(var_42_0._hero_group_detail_widgets) do
					iter_42_5.alpha_multiplier = 1 - var_42_1
				end

				for iter_42_6, iter_42_7 in ipairs(var_42_0._player_name_box_widgets) do
					iter_42_7.alpha_multiplier = 1 - var_42_1
				end

				for iter_42_8, iter_42_9 in ipairs(var_42_0._top_detail_widgets) do
					iter_42_9.alpha_multiplier = 1 - var_42_1
				end
			end,
			on_complete = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				return
			end
		}
	},
	name_box_fade_to_black = {
		{
			name = "fade_to_black",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				return
			end,
			update = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
				local var_45_0 = 155 + 100 * (1 - math.easeOutCubic(arg_45_3))

				arg_45_2.style.background.color = {
					255,
					var_45_0,
					var_45_0,
					var_45_0
				}
			end,
			on_complete = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				return
			end
		}
	},
	name_box_fade_to_gray = {
		{
			name = "fade_to_gray",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
				return
			end,
			update = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
				local var_48_0 = 255 * math.easeOutCubic(arg_48_3)

				arg_48_2.style.background.color = {
					255,
					var_48_0,
					var_48_0,
					var_48_0
				}
			end,
			on_complete = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
				return
			end
		}
	}
}
local var_0_19 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 160,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	use_shadow = true,
	font_type = "hell_shark_header",
	text_color = {
		50,
		255,
		255,
		255
	},
	offset = {
		0,
		0,
		2
	},
	shadow_offset = {
		1,
		1,
		0
	}
}
local var_0_20 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	font_size = 400,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	},
	shadow_offset = {
		1,
		1,
		0
	}
}
local var_0_21 = {
	word_wrap = true,
	font_size = 70,
	localize = false,
	dynamic_font_size_word_wrap = true,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = {
		50,
		180,
		180,
		180
	},
	offset = {
		0,
		0,
		2
	},
	shadow_offset = {
		1,
		1,
		0
	}
}
local var_0_22 = {
	word_wrap = true,
	horizontal_alignment = "center",
	localize = false,
	font_size = 45,
	use_shadow = true,
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("local_player_team_lighter", 255),
	offset = {
		0,
		0,
		1
	},
	shadow_offset = {
		1,
		1,
		0
	}
}
local var_0_23 = {
	word_wrap = true,
	horizontal_alignment = "center",
	localize = false,
	font_size = 30,
	use_shadow = true,
	vertical_alignment = "bottom",
	font_type = "hell_shark",
	text_color = {
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
	shadow_offset = {
		1,
		1,
		0
	}
}
local var_0_24 = {
	word_wrap = false,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	size = {
		200,
		25
	},
	text_color = {
		255,
		255,
		255,
		255
	},
	offset = {
		0,
		15,
		1
	},
	shadow_offset = {
		1,
		1,
		0
	}
}
local var_0_25 = {
	word_wrap = false,
	font_size = 48,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	size = {
		600,
		60
	},
	text_color = {
		255,
		255,
		255,
		255
	},
	offset = {
		0,
		-45,
		1
	},
	shadow_offset = {
		1,
		1,
		0
	}
}
local var_0_26 = {
	local_player_picking_frame = UIWidgets.create_frame("local_player_picking_frame", var_0_8.local_player_picking_frame.size, "frame_inner_glow_02", nil, nil, nil, true),
	local_player_picking_frame_write_mask = UIWidgets.create_simple_texture("mask_rect_edge_fade", "local_player_picking_frame"),
	progress_bar_edge_top = UIWidgets.create_simple_texture("menu_frame_09_divider", "progress_bar_edge_top"),
	progress_bar_edge_bottom = UIWidgets.create_simple_texture("menu_frame_09_divider", "progress_bar_edge_bottom"),
	progress_bar = UIWidgets.create_simple_uv_texture("picking_bar_fill_orange", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "progress_bar"),
	progress_bar_end_glow = UIWidgets.create_simple_texture("picking_bar_fill_highlight", "progress_bar_end_glow"),
	progress_bar_rect = UIWidgets.create_simple_rect("progress_bar_rect", {
		255,
		0,
		0,
		0
	}),
	your_turn_indicator_text = var_0_16("player_name_box_1"),
	countdown_timer = UIWidgets.create_simple_text("", "countdown_timer", nil, nil, var_0_20)
}
local var_0_27 = {
	selected_career_title = UIWidgets.create_simple_text("", "selected_career_title", nil, nil, var_0_19),
	selected_hero_title = UIWidgets.create_simple_text("", "selected_hero_title", nil, nil, var_0_21),
	character_selection_bg = UIWidgets.create_simple_texture("versus_hero_selection_bottom_frame_background", "bottom_bar", nil, nil, {
		255,
		136,
		136,
		136
	}, {
		0,
		0,
		1
	}),
	character_selection_bg_fade = UIWidgets.create_simple_texture("loot_presentation_fg_02_fade", "bottom_bar", nil, nil, {
		255,
		255,
		255,
		255
	}, {
		0,
		0,
		1
	})
}
local var_0_28 = var_0_7.parading_info
local var_0_29 = {
	var_0_28[1] / 2 - 227,
	var_0_28[2] / 2 - 25,
	1
}
local var_0_30 = {
	player_picking_text = UIWidgets.create_simple_text(Localize("versus_hero_selection_view_local_player_picking"), "hero_name_text_anchor", nil, nil, var_0_24),
	hero_career_name_text = UIWidgets.create_simple_text("", "hero_name_text_anchor", nil, nil, var_0_25),
	passive_skill = var_0_17("hero_name_text_anchor"),
	career_skill = var_0_17("hero_name_text_anchor")
}

return {
	scenegraph_definition = var_0_8,
	widget_definitions = var_0_27,
	retained_mode = var_0_0,
	create_player_name_box_widgets = var_0_15,
	create_hero_roster_widget_defitions = var_0_12,
	create_skill_info_widget = var_0_17,
	other_definitions = var_0_26,
	animation_definitions = var_0_18,
	create_progress_marker = var_0_9,
	intro_view_settings = intro_view_settings,
	top_detail_widgets_definitions = var_0_30,
	generic_input_actions = generic_input_actions
}
