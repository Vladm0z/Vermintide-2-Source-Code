-- chunkname: @scripts/ui/views/versus_menu/versus_party_char_selection_view_definitions.lua

local flag = false
local num = 1600
local num_2 = 318
local num_3 = 60
local tbl = {
	474,
	46
}
local tbl_2 = {
	70,
	80
}
local tbl_3 = {
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
		-(num_2 + num_3) * 2,
		0,
		1
	},
	hero_group_2 = {
		-(num_2 + num_3),
		0,
		1
	},
	hero_group_3 = {
		0,
		0,
		1
	},
	hero_group_4 = {
		num_2 + num_3,
		0,
		1
	},
	hero_group_5 = {
		(num_2 + num_3) * 2,
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
local tbl_4 = {
	screen = {
		1920,
		1080
	},
	player_name_box_1 = tbl,
	player_name_box_2 = tbl,
	player_name_box_3 = tbl,
	player_name_box_4 = tbl,
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
		num_2,
		91
	},
	hero_group_2 = {
		num_2,
		91
	},
	hero_group_3 = {
		num_2,
		91
	},
	hero_group_4 = {
		num_2,
		91
	},
	hero_group_5 = {
		num_2,
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
local tbl_5 = {
	screen = {
		scale = "fit",
		size = tbl_4.screen,
		position = tbl_3.screen
	},
	menu_root = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = tbl_4.menu_root,
		position = tbl_3.menu_root
	},
	bottom_bar = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		horizontal_alignment = "center",
		size = tbl_4.bottom_bar,
		position = tbl_3.bottom_bar
	},
	player_name_box_1 = {
		vertical_alignment = "bottom",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_4.player_name_box_1,
		position = tbl_3.player_name_box_1
	},
	player_name_box_2 = {
		vertical_alignment = "bottom",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_4.player_name_box_2,
		position = tbl_3.player_name_box_2
	},
	player_name_box_3 = {
		vertical_alignment = "bottom",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_4.player_name_box_3,
		position = tbl_3.player_name_box_3
	},
	player_name_box_4 = {
		vertical_alignment = "bottom",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_4.player_name_box_4,
		position = tbl_3.player_name_box_4
	},
	hero_roster = {
		vertical_alignment = "bottom",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_4.hero_roster,
		position = tbl_3.hero_roster
	},
	hero_group_1 = {
		vertical_alignment = "center",
		parent = "hero_roster",
		horizontal_alignment = "center",
		size = tbl_4.hero_group_1,
		position = tbl_3.hero_group_1
	},
	hero_group_2 = {
		vertical_alignment = "center",
		parent = "hero_roster",
		horizontal_alignment = "center",
		size = tbl_4.hero_group_2,
		position = tbl_3.hero_group_2
	},
	hero_group_3 = {
		vertical_alignment = "center",
		parent = "hero_roster",
		horizontal_alignment = "center",
		size = tbl_4.hero_group_3,
		position = tbl_3.hero_group_3
	},
	hero_group_4 = {
		vertical_alignment = "center",
		parent = "hero_roster",
		horizontal_alignment = "center",
		size = tbl_4.hero_group_4,
		position = tbl_3.hero_group_4
	},
	hero_group_5 = {
		vertical_alignment = "center",
		parent = "hero_roster",
		horizontal_alignment = "center",
		size = tbl_4.hero_group_5,
		position = tbl_3.hero_group_5
	},
	background = {
		vertical_alignment = "bottom",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = tbl_4.background,
		position = tbl_3.background
	},
	progress_bar_anchor = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = tbl_4.progress_bar,
		position = tbl_3.progress_bar_anchor
	},
	progress_bar = {
		vertical_alignment = "bottom",
		parent = "progress_bar_anchor",
		size = tbl_4.progress_bar,
		position = tbl_3.progress_bar
	},
	progress_bar_edge_bottom = {
		vertical_alignment = "bottom",
		parent = "progress_bar_anchor",
		size = tbl_4.progress_bar_edge_bottom,
		position = tbl_3.progress_bar_edge_bottom
	},
	progress_bar_edge_top = {
		vertical_alignment = "bottom",
		parent = "progress_bar_anchor",
		size = tbl_4.progress_bar_edge_top,
		position = tbl_3.progress_bar_edge_top
	},
	progress_bar_end_glow = {
		vertical_alignment = "center",
		parent = "progress_bar",
		horizontal_alignment = "right",
		size = tbl_4.progress_bar_end_glow,
		position = tbl_3.progress_bar_end_glow
	},
	progress_bar_passive = {
		vertical_alignment = "bottom",
		parent = "progress_bar",
		size = tbl_4.progress_bar_passive,
		position = tbl_3.progress_bar_passive
	},
	progress_bar_rect = {
		vertical_alignment = "bottom",
		parent = "progress_bar",
		size = tbl_4.progress_bar_rect,
		position = tbl_3.progress_bar_rect
	},
	progress_point = {
		vertical_alignment = "center",
		parent = "progress_bar_rect",
		horizontal_alignment = "left",
		size = tbl_4.progress_point,
		position = tbl_3.progress_point
	},
	countdown_timer = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = tbl_4.countdown_timer,
		position = tbl_3.countdown_timer
	},
	selected_career_title = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = tbl_4.selected_career_title,
		position = tbl_3.selected_career_title
	},
	selected_hero_title = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = tbl_4.selected_hero_title,
		position = tbl_3.selected_hero_title
	},
	player_info_text_background = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		horizontal_alignment = "center",
		size = tbl_4.player_info_text_background,
		position = tbl_3.player_info_text_background
	},
	player_info_text = {
		vertical_alignment = "bottom",
		parent = "player_info_text_background",
		horizontal_alignment = "center",
		size = tbl_4.player_info_text,
		position = tbl_3.player_info_text
	},
	local_player_picking_frame = {
		vertical_alignment = "bottom",
		scale = "fit",
		horizontal_alignment = "center",
		size = tbl_4.local_player_picking_frame,
		position = tbl_3.local_player_picking_frame
	},
	local_player_flame_highlight = {
		vertical_alignment = "bottom",
		parent = "bottom_bar",
		horizontal_alignment = "center",
		size = tbl_4.local_player_flame_highlight,
		position = tbl_3.local_player_flame_highlight
	},
	hero_name_text_anchor = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = tbl_4.hero_name_text_anchor,
		position = tbl_3.hero_name_text_anchor
	},
	parading_info = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = tbl_4.parading_info,
		position = tbl_3.parading_info
	}
}

local function fn(arg_1_0)
	-- function 1
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
					content_check_function = function (self)
						-- function 2
						local highlight = self.highlight

						if not highlight then
							highlight = self.is_local_player
							highlight = not highlight and not self.done
						end

						return highlight
					end
				},
				{
					texture_id = "glow_done",
					style_id = "glow_done",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 3
						return self.done
					end
				},
				{
					style_id = "glow_done_animation",
					pass_type = "texture",
					texture_id = "glow_done",
					content_check_function = function (self)
						-- function 4
						return self.done
					end,
					content_change_function = function (self, arg_5_1, arg_5_2, arg_5_3)
						-- function 5
						local done = self.done
						local anim_progress = arg_5_1.anim_progress

						if not done then
							anim_progress = arg_5_1.anim_progress or 0

							local texture_size = arg_5_1.texture_size
							local default_size = arg_5_1.default_size
							local num = 2
							local easeOutCubic = math.easeOutCubic(anim_progress)

							texture_size[1] = default_size[1] + default_size[1] * num * easeOutCubic
							texture_size[2] = default_size[2] + default_size[2] * num * easeOutCubic
							arg_5_1.color[1] = 255 * (1 - easeOutCubic)
							arg_5_1.anim_progress = math.min(anim_progress + arg_5_3, 1)
						elseif not anim_progress then
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

local function fn_2(arg_6_0, arg_6_1)
	-- function 6
	local str = "versus_hero_selection_hero_portrait_frame"
	local var_6_1 = UIFrameSettings[str]
	local var_6_2 = var_6_1.texture_sizes.horizontal[2]
	local str_2 = "shadow_frame_02"
	local var_6_4 = UIFrameSettings[str_2]
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
					content_check_function = function (self)
						-- function 7
						return self.locked
					end
				},
				{
					texture_id = "lock_texture",
					style_id = "lock_texture_shadow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 8
						return self.locked
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
					content_check_function = function (self)
						-- function 9
						local locked = self.locked

						if not locked then
							locked = self.taken
							locked = locked or self.other_picking
						end

						return locked
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame_passive",
					texture_id = "frame_passive",
					content_check_function = function (self)
						-- function 10
						local locked = self.locked

						if not locked then
							locked = self.taken
							locked = locked or self.other_picking
						end

						return locked
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "local_player_frame",
					texture_id = "local_player_frame",
					content_check_function = function (self)
						-- function 11
						return not not self.locked or not not self.taken or not self.other_picking
					end
				},
				{
					pass_type = "texture",
					style_id = "other_hover",
					texture_id = "other_hover",
					content_check_function = function (self)
						-- function 12
						local hovered_by_other = self.hovered_by_other

						hovered_by_other = not hovered_by_other and not self.button_hotspot.is_hover

						return hovered_by_other
					end
				},
				{
					pass_type = "texture",
					style_id = "local_player_select_frame",
					texture_id = "local_player_select_frame",
					content_check_function = function (self)
						-- function 13
						local is_hover = self.button_hotspot.is_hover

						is_hover = is_hover or self.gamepad_selected

						return is_hover
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

local function fn_3(arg_14_0)
	-- function 14
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
					content_change_function = function (self, arg_15_1)
						-- function 15
						if not self.taken then
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
					content_check_function = function (self)
						-- function 16
						return self.side == "dark_pact"
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

local function fn_4()
	-- function 17
	local tbl = {}
	local tbl_3 = {
		4,
		4,
		4,
		4,
		4
	}
	local tbl_4 = {}

	for i = 1, #tbl_3 do
		local var_17_3 = tbl_3[i]
		local str = "hero_group_" .. i
		local var_17_5 = tbl_5[str]
		local num = 10
		local num_2 = var_17_5.size[1] - num / 2

		tbl[i] = {}
		tbl_4[i] = fn_3("hero_group_" .. i)

		for j = 1, var_17_3 do
			local str_2 = "hero_root_" .. i .. "_" .. j

			tbl_5[str_2] = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				parent = str,
				size = {
					70,
					80
				},
				position = {
					0 + (j - 1) * 77,
					0,
					1
				}
			}
			tbl[i][j] = fn_2(str_2, tbl_2)
		end
	end

	return tbl, tbl_4
end

local function fn_5(arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	local flag = arg_18_2 or tbl_5[arg_18_0].size
	local flag_2 = arg_18_1 or {
		0,
		0,
		11
	}
	local str = "menu_frame_12"
	local var_18_3 = UIFrameSettings[str]
	local var_18_4 = var_18_3.texture_sizes.horizontal[2]
	local button_frame_02 = UIFrameSettings.button_frame_02

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
					content_check_function = function (self)
						-- function 19
						local is_player = self.is_player
						local is_player_2 = self.is_player

						is_player_2 = not is_player_2 and not self.is_local_player

						return is_player_2
					end
				},
				{
					texture_id = "mute_button_frame",
					style_id = "mute_button_frame",
					pass_type = "texture_frame",
					content_check_function = function (self)
						-- function 20
						local is_player = self.is_player
						local is_player_2 = self.is_player

						is_player_2 = not is_player_2 and not self.is_local_player

						return is_player_2
					end
				},
				{
					pass_type = "texture",
					style_id = "mute_icon",
					texture_id = "mute_icon",
					content_check_function = function (self)
						-- function 21
						local is_player = self.is_player
						local is_player_2 = self.is_player

						is_player_2 = not is_player_2 and not self.is_local_player

						return is_player_2
					end
				},
				{
					pass_type = "texture",
					style_id = "mute_icon_hovered",
					texture_id = "mute_icon",
					content_check_function = function (self)
						-- function 22
						local is_player = self.is_player

						is_player = not is_player and not not self.is_local_player or self.hotspot.is_hover

						return is_player
					end
				},
				{
					pass_type = "texture",
					style_id = "mute_icon_muted",
					texture_id = "mute_icon_muted",
					content_check_function = function (self)
						-- function 23
						local is_player = self.is_player

						is_player = not is_player and not not self.is_local_player or self.muted

						return is_player
					end
				},
				{
					style_id = "mute_icon",
					pass_type = "hotspot",
					content_id = "hotspot",
					content_check_function = function (self)
						-- function 24
						local is_player = self.parent.is_player

						is_player = not is_player and not self.parent.is_local_player

						return is_player
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
			mute_button_frame = button_frame_02.texture,
			frame = var_18_3.texture,
			hotspot = {}
		},
		style = {
			background = {
				vertical_alignment = "center",
				masked = true,
				horizontal_alignment = "center",
				texture_size = tbl,
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
					flag[1] - 6,
					flag[2] - 6
				},
				default_size = flag,
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
					tbl_5[arg_18_0].size[1] - 57,
					3,
					8
				}
			},
			mute_button_frame = {
				size = {
					42,
					42
				},
				texture_size = button_frame_02.texture_size,
				texture_sizes = button_frame_02.texture_sizes,
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					tbl_5[arg_18_0].size[1] - 57,
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
					tbl_5[arg_18_0].size[1] - 55,
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
					tbl_5[arg_18_0].size[1] - 55,
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
					tbl_5[arg_18_0].size[1] - 55,
					5,
					10
				}
			}
		},
		scenegraph_id = arg_18_0,
		offset = flag_2
	}
end

local tbl_6 = {
	480,
	80
}

local function fn_6()
	-- function 25
	local tbl = {}
	local num = 4

	for i = 1, num do
		local str = "player_name_box_" .. i
		local var_25_3 = fn_5(str)

		tbl[#tbl + 1] = var_25_3
	end

	return tbl
end

local function fn_7(arg_26_0)
	-- function 26
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
						-- function 27
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
			tbl[1] * 0.5 - 50,
			30,
			50
		},
		scenegraph_id = arg_26_0
	}
end

local function fn_8(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local flag = arg_28_2 or "icons_placeholder"
	local flag_2 = arg_28_1 or "n/a"
	local flag_3 = arg_28_3 or "n/a"

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
			skill_icon = flag,
			skill_type = flag_2,
			skill_name = flag_3
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

local tbl_7 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				arg_29_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				-- function 30
				local easeOutCubic = math.easeOutCubic(arg_30_3)

				arg_30_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
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
				-- function 32
				arg_32_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				-- function 33
				local easeOutCubic = math.easeOutCubic(arg_33_3)

				arg_33_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
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
				-- function 35
				return
			end,
			update = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				-- function 36
				local _widgets_by_name = arg_36_4.self._widgets_by_name
				local countdown_timer = _widgets_by_name.countdown_timer
				local your_turn_indicator_text = _widgets_by_name.your_turn_indicator_text
				local easeOutCubic = math.easeOutCubic(arg_36_3)

				countdown_timer.alpha_multiplier = 1 - easeOutCubic
				your_turn_indicator_text.style.text.text_color[1] = 255 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
				return
			end
		},
		{
			name = "fade_in_top_details",
			start_progress = 0,
			end_progress = 0.4,
			init = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				-- function 38
				return
			end,
			update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				-- function 39
				local _top_detail_widgets = arg_39_4.self._top_detail_widgets
				local easeOutCubic = math.easeOutCubic(arg_39_3)

				for i, v in ipairs(_top_detail_widgets) do
					v.alpha_multiplier = easeOutCubic
				end
			end,
			on_complete = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
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
				-- function 41
				return
			end,
			update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
				-- function 42
				local self = arg_42_4.self
				local easeOutCubic = math.easeOutCubic(arg_42_3)

				for i, v in ipairs(self._other_widgets) do
					if v.alpha_multiplier ~= 0 then
						v.alpha_multiplier = 1 - easeOutCubic
					end
				end

				for i_2, v_2 in ipairs(self._hero_group_widgets) do
					v_2.alpha_multiplier = 1 - easeOutCubic
				end

				for i_3, v_3 in ipairs(self._hero_group_detail_widgets) do
					v_3.alpha_multiplier = 1 - easeOutCubic
				end

				for i_4, v_4 in ipairs(self._player_name_box_widgets) do
					v_4.alpha_multiplier = 1 - easeOutCubic
				end

				for i_5, v_5 in ipairs(self._top_detail_widgets) do
					v_5.alpha_multiplier = 1 - easeOutCubic
				end
			end,
			on_complete = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				-- function 43
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
				-- function 44
				return
			end,
			update = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
				-- function 45
				local num = 155 + 100 * (1 - math.easeOutCubic(arg_45_3))

				arg_45_2.style.background.color = {
					255,
					num,
					num,
					num
				}
			end,
			on_complete = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				-- function 46
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
				-- function 47
				return
			end,
			update = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
				-- function 48
				local num = 255 * math.easeOutCubic(arg_48_3)

				arg_48_2.style.background.color = {
					255,
					num,
					num,
					num
				}
			end,
			on_complete = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
				-- function 49
				return
			end
		}
	}
}
local tbl_8 = {
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
local tbl_9 = {
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
local tbl_10 = {
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
local tbl_11 = {
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
local tbl_12 = {
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
local tbl_13 = {
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
local tbl_14 = {
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
local tbl_15 = {
	local_player_picking_frame = UIWidgets.create_frame("local_player_picking_frame", tbl_5.local_player_picking_frame.size, "frame_inner_glow_02", nil, nil, nil, true),
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
	your_turn_indicator_text = fn_7("player_name_box_1"),
	countdown_timer = UIWidgets.create_simple_text("", "countdown_timer", nil, nil, tbl_9)
}
local tbl_16 = {
	selected_career_title = UIWidgets.create_simple_text("", "selected_career_title", nil, nil, tbl_8),
	selected_hero_title = UIWidgets.create_simple_text("", "selected_hero_title", nil, nil, tbl_10),
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
local parading_info = tbl_4.parading_info
local tbl_17 = {
	parading_info[1] / 2 - 227,
	parading_info[2] / 2 - 25,
	1
}
local tbl_18 = {
	player_picking_text = UIWidgets.create_simple_text(Localize("versus_hero_selection_view_local_player_picking"), "hero_name_text_anchor", nil, nil, tbl_13),
	hero_career_name_text = UIWidgets.create_simple_text("", "hero_name_text_anchor", nil, nil, tbl_14),
	passive_skill = fn_8("hero_name_text_anchor"),
	career_skill = fn_8("hero_name_text_anchor")
}

return {
	scenegraph_definition = tbl_5,
	widget_definitions = tbl_16,
	retained_mode = flag,
	create_player_name_box_widgets = fn_6,
	create_hero_roster_widget_defitions = fn_4,
	create_skill_info_widget = fn_8,
	other_definitions = tbl_15,
	animation_definitions = tbl_7,
	create_progress_marker = fn,
	intro_view_settings = intro_view_settings,
	top_detail_widgets_definitions = tbl_18,
	generic_input_actions = generic_input_actions
}
