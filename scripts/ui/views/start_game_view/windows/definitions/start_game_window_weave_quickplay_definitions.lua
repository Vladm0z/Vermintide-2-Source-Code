-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_quickplay_definitions.lua

local large_window_size = UISettings.game_start_windows.large_window_size
local str = "menu_frame_11"
local var_0_2 = UIFrameSettings[str].texture_sizes.vertical[1]
local tbl = {
	large_window_size[1] - var_0_2 * 2,
	large_window_size[2] - var_0_2 * 2
}
local tbl_2 = {
	tbl[1],
	194
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
	parent_window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = large_window_size,
		position = {
			0,
			0,
			1
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "parent_window",
		horizontal_alignment = "right",
		size = tbl,
		position = {
			-var_0_2,
			0,
			1
		}
	},
	difficulty_selected = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			150,
			150
		},
		position = {
			0,
			220,
			2
		}
	},
	difficulty_selected_effect = {
		vertical_alignment = "center",
		parent = "difficulty_selected",
		horizontal_alignment = "center",
		size = {
			300,
			300
		},
		position = {
			0,
			0,
			-1
		}
	},
	difficulty_title = {
		vertical_alignment = "bottom",
		parent = "difficulty_selected",
		horizontal_alignment = "center",
		size = {
			600,
			50
		},
		position = {
			0,
			-60,
			1
		}
	},
	difficulty_description = {
		vertical_alignment = "top",
		parent = "difficulty_title",
		horizontal_alignment = "center",
		size = {
			600,
			100
		},
		position = {
			0,
			-60,
			1
		}
	},
	difficulty_option = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			160,
			160
		},
		position = {
			0,
			-200,
			1
		}
	},
	play_button_console = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_2[1],
			tbl_2[2]
		},
		position = {
			0,
			-30,
			1
		}
	},
	play_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			400,
			72
		},
		position = {
			0,
			25,
			20
		}
	}
}
local tbl_4 = {
	word_wrap = true,
	upper_case = true,
	localize = true,
	use_shadow = true,
	font_size = 42,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_5 = {
	word_wrap = true,
	upper_case = false,
	localize = true,
	dynamic_font_size_word_wrap = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark"
}
local flag

flag = IS_WINDOWS or not 28 or 20
tbl_5.font_size = flag
tbl_5.text_color = Colors.get_color_table_with_alpha("font_default", 255)
tbl_5.offset = {
	0,
	0,
	2
}

function create_play_button(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	local var_1_0
	local str = "green"

	if not str then
		var_1_0 = "button_" .. str
	else
		var_1_0 = "button_normal"
	end

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(var_1_0, 255)
	local str_2 = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)
	local menu_frame_08 = UIFrameSettings.menu_frame_08
	local str_3 = "button_detail_05_glow"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(str_3).size

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "hover_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					style_id = "clicked_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 2
						local is_clicked = self.button_hotspot.is_clicked

						return not is_clicked and is_clicked == 0
					end
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 3
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_right",
					style_id = "side_detail_right",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 4
						return not self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_left",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 5
						return not self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_right",
					style_id = "side_detail_right_disabled",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 6
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_left",
					style_id = "side_detail_left_disabled",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 7
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_glow_right",
					pass_type = "texture_uv",
					content_id = "side_detail_glow",
					content_check_function = function (self)
						-- function 8
						return not self.parent.button_hotspot.disable_button
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_glow_left",
					pass_type = "texture",
					content_id = "side_detail_glow",
					content_check_function = function (self)
						-- function 9
						return not self.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 10
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 11
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass_top",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture"
				},
				{
					texture_id = "effect",
					style_id = "effect",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 12
						return not self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 13
						local button_hotspot = self.button_hotspot
						local is_selected

						if not button_hotspot.disable_button then
							is_selected = button_hotspot.is_selected

							if not is_selected then
								is_selected = button_hotspot.is_hover
							end
						else
							is_selected = false
						end

						if false then
							is_selected = true
						end

						return is_selected
					end
				},
				{
					additional_option_id = "cancel_matchmaking_tooltip",
					style_id = "cancel_matchmaking_tooltip",
					pass_type = "additional_option_tooltip",
					content_id = "hover_hotspot",
					content_check_function = function (self)
						-- function 14
						local button_hotspot = self.parent.button_hotspot
						local is_hover = self.is_hover

						is_hover = not is_hover and button_hotspot.disable_button

						return is_hover
					end
				}
			}
		},
		content = {
			side_detail_right = "button_detail_05_right",
			effect = "play_button_passive_glow",
			hover_glow = "button_state_hover_green",
			side_detail_left = "button_detail_05_left",
			glow = "button_state_normal_green",
			glass_top = "button_glass_01",
			side_detail_glow = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = str_3
			},
			button_hotspot = {},
			hover_hotspot = {
				cancel_matchmaking_tooltip = arg_1_5
			},
			title_text = arg_1_2 or "n/a",
			frame = menu_frame_08.texture,
			disable_with_gamepad = arg_1_4,
			background = {
				uvs = {
					{
						0,
						1 - arg_1_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_1_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = str_2
			}
		},
		style = {
			background = {
				color = get_color_table_with_alpha,
				offset = {
					0,
					0,
					0
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
				}
			},
			clicked_rect = {
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
				}
			},
			disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					0,
					0,
					7
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
				}
			},
			title_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_1_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					9
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_1_3 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					0,
					9
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_1_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					8
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
				}
			},
			frame = {
				texture_size = menu_frame_08.texture_size,
				texture_sizes = menu_frame_08.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					8
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
				}
			},
			hover_glow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					menu_frame_08.texture_sizes.horizontal[2],
					1
				},
				size = {
					arg_1_1[1],
					math.min(60, arg_1_1[2] - menu_frame_08.texture_sizes.horizontal[2] * 2)
				}
			},
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_1_1[2] - menu_frame_08.texture_sizes.horizontal[2] - 4,
					6
				},
				size = {
					arg_1_1[1],
					5
				}
			},
			glow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					menu_frame_08.texture_sizes.horizontal[2] - 1,
					3
				},
				size = {
					arg_1_1[1],
					math.min(60, arg_1_1[2] - menu_frame_08.texture_sizes.horizontal[2] * 2)
				}
			},
			effect = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					5
				},
				size = {
					arg_1_1[1],
					arg_1_1[2]
				}
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_1_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_1_1[1] - 88,
					arg_1_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_left_disabled = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					0,
					arg_1_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_right_disabled = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					arg_1_1[1] - 88,
					arg_1_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_glow_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_1_1[2] / 2 - size[2] / 2,
					10
				},
				size = {
					size[1],
					size[2]
				}
			},
			side_detail_glow_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_1_1[1] - size[1],
					arg_1_1[2] / 2 - size[2] / 2,
					10
				},
				size = {
					size[1],
					size[2]
				}
			},
			cancel_matchmaking_tooltip = {
				vertical_alignment = "top",
				max_width = 400,
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					0
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

local function fn(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local flag = true
	local str = "difficulty_option_1"
	local num = 0.6
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl = {
		math.floor(get_atlas_settings_by_texture_name.size[1] * num),
		math.floor(get_atlas_settings_by_texture_name.size[2] * num)
	}
	local flag_2 = arg_15_4 or "button_bg_01"
	local get_atlas_settings_by_texture_name_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(flag_2)
	local str_2 = "menu_frame_08"
	local var_15_8 = UIFrameSettings[str_2].texture_sizes.corner[1]
	local str_3 = "frame_outer_glow_01"
	local var_15_10 = UIFrameSettings[str_3].texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				},
				{
					texture_id = "glass_texture",
					style_id = "glass_texture",
					pass_type = "texture"
				},
				{
					texture_id = "background_glow",
					style_id = "background_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 16
						return not self.button_hotspot.is_selected
					end
				},
				{
					texture_id = "background_glow",
					style_id = "select_edge",
					pass_type = "texture"
				},
				{
					texture_id = "select_texture",
					style_id = "select_texture",
					pass_type = "texture"
				},
				{
					texture_id = "dlc_locked_texture",
					style_id = "dlc_locked_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 17
						return self.dlc_locked
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 18
						return not self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "icon",
					style_id = "icon_disabled",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 19
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 20
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 21
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				}
			}
		},
		content = {
			background_glow = "weaves_select_level_glow",
			title_text = "n/a",
			select_texture = "weave_difficulty_select_effect",
			glass_texture = "weaves_select_level_gloss",
			dlc_locked_texture = "hero_icon_locked",
			background = "weaves_select_level_background",
			icon = str,
			button_hotspot = {},
			dlc_locked = arg_15_5
		},
		style = {
			background = {
				color = {
					30,
					138,
					0,
					187
				},
				offset = {
					0,
					0,
					0
				},
				size = arg_15_1
			},
			glass_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					150,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					2
				},
				texture_size = arg_15_1
			},
			select_edge = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					255,
					193,
					161,
					116
				},
				offset = {
					0,
					0,
					5
				},
				texture_size = arg_15_1
			},
			background_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					255,
					138,
					0,
					187
				},
				offset = {
					0,
					0,
					3
				},
				texture_size = arg_15_1
			},
			select_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					0,
					38,
					0
				},
				texture_size = {
					200,
					300
				}
			},
			dlc_locked_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = {
					204,
					255,
					255,
					255
				},
				texture_size = {
					60,
					70
				},
				offset = {
					-100,
					0,
					4
				}
			},
			title_text = {
				font_size = 22,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				dynamic_font_size = flag,
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-30,
					6
				},
				size = {
					arg_15_1[1],
					arg_15_1[2]
				}
			},
			title_text_disabled = {
				font_size = 22,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				dynamic_font_size = flag,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					-30,
					6
				},
				size = {
					arg_15_1[1],
					arg_15_1[2]
				}
			},
			title_text_shadow = {
				font_size = 22,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				dynamic_font_size = flag,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-32,
					5
				},
				size = {
					arg_15_1[1],
					arg_15_1[2]
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = Colors.get_color_table_with_alpha("white", 255),
				default_color = Colors.get_color_table_with_alpha("white", 255),
				select_color = Colors.get_color_table_with_alpha("white", 255),
				texture_size = tbl,
				offset = {
					0,
					0,
					1
				}
			},
			icon_disabled = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					255,
					40,
					40,
					40
				},
				default_color = {
					255,
					40,
					40,
					40
				},
				select_color = {
					255,
					40,
					40,
					40
				},
				texture_size = tbl,
				offset = {
					0,
					0,
					2
				}
			}
		},
		scenegraph_id = arg_15_0,
		offset = {
			0,
			0,
			0
		}
	}
end

function create_start_game_console_play_button(arg_22_0, arg_22_1)
	-- function 22
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local str = "text"
	local str_2 = str .. "_shadow"

	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str,
		style_id = str,
		content_change_function = function (self, arg_23_1)
			-- function 23
			if not self.locked then
				arg_23_1.text_color = arg_23_1.disabled_color
			else
				arg_23_1.text_color = arg_23_1.normal_color
			end
		end
	}
	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str,
		style_id = str_2
	}
	tbl_2[str] = arg_22_1

	local tbl_4 = {
		0,
		6,
		1
	}
	local tbl_5 = {
		word_wrap = false,
		upper_case = true,
		localize = false,
		font_size = 48,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		disabled_color = Colors.get_color_table_with_alpha("dark_gray", 255),
		normal_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			tbl_4[1],
			tbl_4[2],
			tbl_4[3]
		}
	}
	local clone = table.clone(tbl_5)

	clone.text_color = {
		255,
		0,
		0,
		0
	}
	clone.offset = {
		tbl_4[1] + 2,
		tbl_4[2] - 2,
		tbl_4[3] - 1
	}
	tbl_3[str] = tbl_5
	tbl_3[str_2] = clone

	local str_3 = "divider"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_3,
		style_id = str_3
	}
	tbl_2[str_3] = "divider_01_top"
	tbl_3[str_3] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			264,
			32
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			-36,
			1
		}
	}

	local str_4 = "input_texture"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_4,
		style_id = str_4,
		content_change_function = function (self, arg_24_1)
			-- function 24
			if not self.locked then
				arg_24_1.saturated = true
			else
				arg_24_1.saturated = false
			end
		end
	}
	tbl_2[str_4] = ""
	tbl_3[str_4] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			64,
			64
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			-34,
			2
		}
	}

	local str_5 = "glow"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_5,
		style_id = str_5,
		content_check_function = function (self)
			-- function 25
			return not self.locked
		end
	}
	tbl_2[str_5] = "play_glow_mask"
	tbl_3[str_5] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			256,
			126
		},
		color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			0,
			33,
			-1
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
		scenegraph_id = arg_22_0
	}
end

local flag_2 = true
local tbl_6 = {
	difficulty_title = UIWidgets.create_simple_text("n/a", "difficulty_title", nil, nil, tbl_4),
	difficulty_description = UIWidgets.create_simple_text("n/a", "difficulty_description", nil, nil, tbl_5),
	difficulty_selected = UIWidgets.create_simple_texture("icons_placeholder", "difficulty_selected"),
	difficulty_selected_effect = UIWidgets.create_simple_texture("weave_difficulty_highlight_effect", "difficulty_selected_effect", nil, nil, {
		255,
		138,
		0,
		187
	}),
	play_button = create_play_button("play_button", tbl_3.play_button.size, Localize("start_game_window_play"), 34, flag_2, {
		title = Localize("start_game_weave_disabled_tooltip_title"),
		description = Localize("start_game_weave_disabled_tooltip_description")
	}, flag_2),
	play_button_console = create_start_game_console_play_button("play_button_console", Localize("start_game_window_play"))
}
local tbl_7 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				arg_26_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				-- function 27
				local easeInCubic = math.easeInCubic(arg_27_3)

				arg_27_4.render_settings.alpha_multiplier = easeInCubic
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				arg_29_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				-- function 30
				local easeOutCubic = math.easeOutCubic(arg_30_3)

				arg_30_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				return
			end
		}
	}
}

return {
	widgets = tbl_6,
	create_difficulty_button = fn,
	scenegraph_definition = tbl_3,
	animation_definitions = tbl_7
}
