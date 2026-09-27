-- chunkname: @scripts/ui/views/hero_view/states/definitions/hero_view_state_handbook_definitions.lua

local game_start_windows = UISettings.game_start_windows
local spacing = game_start_windows.spacing
local large_window_size = game_start_windows.large_window_size
local var_0_3 = large_window_size[2]
local tbl = {
	math.floor((large_window_size[1] + 44) / 3),
	var_0_3
}
local tbl_2 = {
	large_window_size[1] + 22 - tbl[1],
	var_0_3
}
local tbl_3 = {
	tbl_2[1] - 22,
	tbl_2[2] - 104
}
local tbl_4 = {
	16,
	tbl_2[2] - 44
}
local num = tbl_3[1] - 150
local tbl_5 = {
	tbl[1] - 22,
	tbl[2] - 48
}
local tbl_6 = {
	tbl[1] - 120,
	60
}
local tbl_7 = {
	tbl_6[1] - spacing * 2,
	tbl[2] - tbl_6[2] - tbl_6[2]
}
local tbl_8 = {
	tbl_6[1] - spacing * 2,
	42
}
local num_2 = 5
local tbl_9 = {
	tab_size = tbl_6,
	tab_active_size = tbl_7,
	tab_list_entry_size = tbl_8,
	tab_list_entry_spacing = num_2
}
local num_3 = 14
local tbl_10 = {
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
	screen = {
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
	console_cursor = {
		vertical_alignment = "center",
		parent = "screen",
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
	header = {
		vertical_alignment = "top",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			1920,
			50
		},
		position = {
			0,
			-20,
			100
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = large_window_size,
		position = {
			0,
			0,
			1
		}
	},
	window_background = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			large_window_size[1] - 5,
			large_window_size[2] - 5
		},
		position = {
			0,
			0,
			0
		}
	},
	left_window = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			0,
			0,
			1
		}
	},
	left_window_fade = {
		vertical_alignment = "center",
		parent = "left_window",
		horizontal_alignment = "center",
		size = {
			tbl[1] - 44,
			tbl[2] - 44
		},
		position = {
			0,
			0,
			1
		}
	},
	right_window = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = tbl_2,
		position = {
			0,
			0,
			1
		}
	},
	right_window_fade = {
		vertical_alignment = "center",
		parent = "right_window",
		horizontal_alignment = "center",
		size = {
			tbl_2[1] - 44,
			tbl_2[2] - 44
		},
		position = {
			0,
			0,
			1
		}
	},
	category_window = {
		vertical_alignment = "center",
		parent = "left_window",
		horizontal_alignment = "center",
		size = tbl_5,
		position = {
			0,
			0,
			1
		}
	},
	category_window_mask = {
		vertical_alignment = "center",
		parent = "category_window",
		horizontal_alignment = "center",
		size = {
			tbl_5[1],
			tbl[2] - 44
		},
		position = {
			0,
			0,
			0
		}
	},
	category_window_mask_top = {
		vertical_alignment = "top",
		parent = "category_window_mask",
		horizontal_alignment = "center",
		size = {
			tbl_5[1],
			30
		},
		position = {
			0,
			0,
			1
		}
	},
	category_window_mask_bottom = {
		vertical_alignment = "bottom",
		parent = "category_window_mask",
		horizontal_alignment = "center",
		size = {
			tbl_5[1],
			30
		},
		position = {
			0,
			0,
			1
		}
	},
	category_root = {
		vertical_alignment = "top",
		parent = "category_window",
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
	category_scrollbar = {
		vertical_alignment = "center",
		parent = "category_window",
		horizontal_alignment = "right",
		size = tbl_4,
		position = {
			-spacing,
			0,
			3
		}
	},
	gamepad_background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			100
		}
	},
	achievement_window = {
		vertical_alignment = "center",
		parent = "right_window",
		horizontal_alignment = "center",
		size = tbl_3,
		position = {
			0,
			0,
			1
		}
	},
	achievement_window_mask = {
		vertical_alignment = "center",
		parent = "achievement_window",
		horizontal_alignment = "center",
		size = {
			tbl_3[1],
			tbl_2[2] - 44
		},
		position = {
			0,
			0,
			0
		}
	},
	achievement_window_mask_top = {
		vertical_alignment = "top",
		parent = "achievement_window_mask",
		horizontal_alignment = "center",
		size = {
			tbl_3[1],
			30
		},
		position = {
			0,
			0,
			1
		}
	},
	achievement_window_mask_bottom = {
		vertical_alignment = "bottom",
		parent = "achievement_window_mask",
		horizontal_alignment = "center",
		size = {
			tbl_3[1],
			30
		},
		position = {
			0,
			0,
			1
		}
	},
	achievement_root = {
		vertical_alignment = "top",
		parent = "achievement_window",
		horizontal_alignment = "center",
		size = {
			num,
			1
		},
		position = {
			0,
			0,
			0
		}
	},
	achievement_scrollbar = {
		vertical_alignment = "center",
		parent = "achievement_window",
		horizontal_alignment = "right",
		size = tbl_4,
		position = {
			-spacing,
			0,
			3
		}
	},
	page_text_area = {
		vertical_alignment = "bottom",
		parent = "right_window",
		horizontal_alignment = "center",
		size = {
			334,
			60
		},
		position = {
			0,
			30,
			3
		}
	},
	input_icon_previous = {
		vertical_alignment = "center",
		parent = "page_text_area",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-60,
			0,
			1
		}
	},
	input_icon_next = {
		vertical_alignment = "center",
		parent = "page_text_area",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			60,
			0,
			1
		}
	},
	input_arrow_next = {
		vertical_alignment = "center",
		parent = "input_icon_next",
		horizontal_alignment = "center",
		size = {
			19,
			27
		},
		position = {
			40,
			0,
			1
		}
	},
	input_arrow_previous = {
		vertical_alignment = "center",
		parent = "input_icon_previous",
		horizontal_alignment = "center",
		size = {
			19,
			27
		},
		position = {
			-40,
			0,
			1
		}
	},
	page_button_next = {
		vertical_alignment = "center",
		parent = "input_icon_next",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			20,
			0,
			1
		}
	},
	page_button_previous = {
		vertical_alignment = "center",
		parent = "input_icon_previous",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-20,
			0,
			1
		}
	},
	exit_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			380,
			42
		},
		position = {
			0,
			-16,
			42
		}
	},
	title = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			570,
			60
		},
		position = {
			0,
			34,
			46
		}
	},
	title_bg = {
		vertical_alignment = "top",
		parent = "title",
		horizontal_alignment = "center",
		size = {
			410,
			40
		},
		position = {
			0,
			-15,
			-1
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "title",
		horizontal_alignment = "center",
		size = {
			350,
			50
		},
		position = {
			0,
			-3,
			2
		}
	}
}
local tbl_11 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 28,
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
local tbl_12 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		-(large_window_size[1] * 0.1 + 5),
		4,
		2
	}
}
local tbl_13 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		large_window_size[1] * 0.1 + 4,
		4,
		2
	}
}
local tbl_14 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		4,
		2
	}
}

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local flag = true
	local str = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local button_frame_01 = UIFrameSettings.button_frame_01
	local var_1_4 = button_frame_01.texture_sizes.corner[1]
	local str_2 = "button_detail_02"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2).size
	local str_3 = "button_detail_03"
	local size_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_3).size
	local num = 20
	local num_4 = 20
	local tbl = {
		allow_multi_hover = true
	}
	local tbl_2 = {}

	for i = 1, num_3 do
		local var_1_13 = num_2

		tbl[i] = {
			text = "n/a",
			glass = "button_glass_02",
			hover_glow = "button_state_default",
			new = false,
			background_fade = "button_bg_fade",
			rect_masked = "rect_masked",
			new_texture = "list_item_tag_new",
			icon = "tooltip_marker",
			button_hotspot = {},
			side_detail = {
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
			frame = button_frame_01.texture,
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
				texture_id = str
			}
		}

		local tbl_3 = {
			list_member_offset = {
				0,
				-(tbl_8[2] + var_1_13),
				0
			},
			size = {
				tbl_8[1],
				tbl_8[2]
			}
		}
		local tbl_4 = {
			word_wrap = false,
			upper_case = true,
			font_size = 22,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true
		}
		local flag_2

		flag_2 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_4.font_type = flag_2
		tbl_4.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
		tbl_4.offset = {
			num + num_4,
			0,
			14
		}
		tbl_4.size = {
			tbl_8[1] - num - num_4 * 2,
			tbl_8[2]
		}
		tbl_3.text = tbl_4

		local tbl_5 = {
			word_wrap = false,
			upper_case = true,
			font_size = 22,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true
		}
		local flag_3

		flag_3 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_5.font_type = flag_3
		tbl_5.text_color = Colors.get_color_table_with_alpha("white", 255)
		tbl_5.offset = {
			num + num_4,
			0,
			14
		}
		tbl_5.size = {
			tbl_8[1] - num - num_4 * 2,
			tbl_8[2]
		}
		tbl_3.text_hover = tbl_5

		local tbl_6 = {
			word_wrap = false,
			upper_case = true,
			font_size = 22,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true
		}
		local flag_4

		flag_4 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_6.font_type = flag_4
		tbl_6.text_color = Colors.get_color_table_with_alpha("white", 255)
		tbl_6.offset = {
			num + num_4,
			0,
			14
		}
		tbl_6.size = {
			tbl_8[1] - num - num_4 * 2,
			tbl_8[2]
		}
		tbl_3.text_selected = tbl_6

		local tbl_7 = {
			word_wrap = false,
			upper_case = true,
			font_size = 22,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true
		}
		local flag_5

		flag_5 = not flag and "hell_shark_masked" and "hell_shark"
		tbl_7.font_type = flag_5
		tbl_7.text_color = Colors.get_color_table_with_alpha("black", 255)
		tbl_7.offset = {
			num + num_4 + 2,
			-2,
			13
		}
		tbl_7.size = {
			tbl_8[1] - num - num_4 * 2,
			tbl_8[2]
		}
		tbl_3.text_shadow = tbl_7
		tbl_3.rect = {
			masked = flag,
			size = {
				tbl_8[1],
				tbl_8[2]
			},
			color = {
				100,
				100,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		}
		tbl_3.icon = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = flag,
			texture_size = {
				13,
				13
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				num,
				0,
				10
			}
		}
		tbl_3.side_detail_left = {
			masked = flag,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-9,
				tbl_8[2] / 2 - size_2[2] / 2,
				9
			},
			size = size_2
		}
		tbl_3.side_detail_right = {
			masked = flag,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_8[1] - size_2[1] + 9,
				tbl_8[2] / 2 - size_2[2] / 2,
				9
			},
			size = size_2
		}
		tbl_3.frame = {
			masked = flag,
			size = tbl_8,
			texture_size = button_frame_01.texture_size,
			texture_sizes = button_frame_01.texture_sizes,
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
			}
		}
		tbl_3.background = {
			masked = flag,
			size = tbl_8,
			color = {
				255,
				150,
				150,
				150
			},
			offset = {
				0,
				0,
				0
			}
		}
		tbl_3.background_fade = {
			masked = flag,
			color = {
				200,
				255,
				255,
				255
			},
			offset = {
				var_1_4,
				var_1_4 - 2,
				2
			},
			size = {
				tbl_8[1] - var_1_4 * 2,
				tbl_8[2] - var_1_4 * 2
			}
		}
		tbl_3.hover_glow = {
			masked = flag,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				var_1_4 - 2,
				3
			},
			size = {
				tbl_8[1],
				math.min(tbl_8[2] - 5, 80)
			}
		}
		tbl_3.clicked_rect = {
			masked = flag,
			size = tbl_8,
			color = {
				0,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				7
			}
		}
		tbl_3.disabled_rect = {
			masked = flag,
			size = tbl_8,
			color = {
				150,
				20,
				20,
				20
			},
			offset = {
				0,
				0,
				1
			}
		}
		tbl_3.glass_top = {
			masked = flag,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				tbl_8[2] - (var_1_4 + 11),
				4
			},
			size = {
				tbl_8[1],
				11
			}
		}
		tbl_3.glass_bottom = {
			masked = flag,
			color = {
				100,
				255,
				255,
				255
			},
			offset = {
				0,
				var_1_4 - 9,
				4
			},
			size = {
				tbl_8[1],
				11
			}
		}
		tbl_3.new_texture = {
			masked = flag,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_8[1] - 63,
				tbl_8[2] / 2 - 12,
				12
			},
			size = {
				63,
				25
			}
		}
		tbl_2[i] = tbl_3
	end

	local tbl_9 = {
		element = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
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
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					texture_id = "rect_masked",
					style_id = "clicked_rect",
					pass_type = "texture"
				},
				{
					texture_id = "rect_masked",
					style_id = "disabled_rect",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 2
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail"
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 3
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 4
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				},
				{
					texture_id = "new_texture",
					style_id = "new_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 5
						return self.new
					end
				},
				{
					texture_id = "locked",
					style_id = "locked",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 6
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "list_style",
					pass_type = "list_pass",
					content_id = "list_content",
					content_check_function = function (self)
						-- function 7
						return self.active
					end,
					passes = {
						{
							style_id = "text",
							pass_type = "text",
							text_id = "text",
							content_check_function = function (self)
								-- function 8
								local button_hotspot = self.button_hotspot

								return not not button_hotspot.is_hover or not button_hotspot.is_selected
							end
						},
						{
							style_id = "text_hover",
							pass_type = "text",
							text_id = "text",
							content_check_function = function (self)
								-- function 9
								local button_hotspot = self.button_hotspot
								local is_hover = button_hotspot.is_hover

								is_hover = not is_hover and not button_hotspot.is_selected

								return is_hover
							end
						},
						{
							style_id = "text_selected",
							pass_type = "text",
							text_id = "text",
							content_check_function = function (self)
								-- function 10
								return self.button_hotspot.is_selected
							end
						},
						{
							style_id = "text_shadow",
							pass_type = "text",
							text_id = "text"
						},
						{
							pass_type = "texture",
							style_id = "icon",
							texture_id = "icon"
						},
						{
							pass_type = "hotspot",
							content_id = "button_hotspot"
						},
						{
							style_id = "side_detail_right",
							pass_type = "texture_uv",
							content_id = "side_detail"
						},
						{
							texture_id = "texture_id",
							style_id = "side_detail_left",
							pass_type = "texture",
							content_id = "side_detail"
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
							texture_id = "background_fade",
							style_id = "background_fade",
							pass_type = "texture"
						},
						{
							texture_id = "hover_glow",
							style_id = "hover_glow",
							pass_type = "texture",
							content_check_function = function (self)
								-- function 11
								local button_hotspot = self.button_hotspot
								local is_hover = button_hotspot.is_hover

								is_hover = is_hover or button_hotspot.is_selected

								return is_hover
							end
						},
						{
							texture_id = "rect_masked",
							style_id = "clicked_rect",
							pass_type = "texture"
						},
						{
							texture_id = "rect_masked",
							style_id = "disabled_rect",
							pass_type = "texture",
							content_check_function = function (self)
								-- function 12
								return self.button_hotspot.disable_button
							end
						},
						{
							texture_id = "glass",
							style_id = "glass_top",
							pass_type = "texture"
						},
						{
							texture_id = "glass",
							style_id = "glass_bottom",
							pass_type = "texture"
						},
						{
							texture_id = "glass",
							style_id = "glass_bottom",
							pass_type = "texture"
						},
						{
							texture_id = "new_texture",
							style_id = "new_texture",
							pass_type = "texture",
							content_check_function = function (self)
								-- function 13
								return self.new
							end
						}
					}
				}
			}
		},
		content = {
			locked = "achievement_symbol_lock",
			hover_glow = "button_state_default",
			background_fade = "button_bg_fade",
			new = false,
			glass = "button_glass_02",
			rect_masked = "rect_masked",
			new_texture = "list_item_tag_new",
			list_content = tbl,
			side_detail = {
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
				texture_id = str_2
			},
			button_hotspot = {},
			title_text = arg_1_2 or "n/a",
			frame = button_frame_01.texture,
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
				texture_id = str
			}
		}
	}
	local tbl_10 = {
		list_style = {
			start_index = 1,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			num_draws = 0,
			masked = flag,
			list_member_offset = {
				0,
				tbl_8[2],
				0
			},
			size = {
				tbl_8[1],
				tbl_8[2]
			},
			scenegraph_id = arg_1_3,
			item_styles = tbl_2
		},
		hotspot = {
			masked = flag,
			size = {
				arg_1_1[1],
				arg_1_1[2]
			},
			offset = {
				0,
				0,
				0
			}
		},
		background = {
			masked = flag,
			color = {
				255,
				150,
				150,
				150
			},
			offset = {
				0,
				0,
				0
			}
		},
		background_fade = {
			masked = flag,
			color = {
				200,
				255,
				255,
				255
			},
			offset = {
				var_1_4,
				var_1_4 - 2,
				2
			},
			size = {
				arg_1_1[1] - var_1_4 * 2,
				arg_1_1[2] - var_1_4 * 2
			}
		},
		hover_glow = {
			masked = flag,
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				var_1_4 - 2,
				3
			},
			size = {
				arg_1_1[1],
				math.min(arg_1_1[2] - 5, 80)
			}
		},
		clicked_rect = {
			masked = flag,
			color = {
				0,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				7
			}
		},
		disabled_rect = {
			masked = flag,
			color = {
				150,
				20,
				20,
				20
			},
			offset = {
				0,
				0,
				1
			}
		}
	}
	local tbl_11 = {
		upper_case = true,
		word_wrap = true,
		font_size = 24,
		horizontal_alignment = "left",
		vertical_alignment = "center"
	}
	local flag_6

	flag_6 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_11.font_type = flag_6
	tbl_11.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_11.default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_11.select_text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_11.offset = {
		30,
		0,
		6
	}
	tbl_10.title_text = tbl_11

	local tbl_12 = {
		upper_case = true,
		font_size = 24,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center"
	}
	local flag_7

	flag_7 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_12.font_type = flag_7
	tbl_12.text_color = Colors.get_color_table_with_alpha("gray", 255)
	tbl_12.default_text_color = Colors.get_color_table_with_alpha("gray", 255)
	tbl_12.offset = {
		30,
		0,
		6
	}
	tbl_10.title_text_disabled = tbl_12

	local tbl_13 = {
		upper_case = true,
		font_size = 24,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center"
	}
	local flag_8

	flag_8 = not flag and "hell_shark_masked" and "hell_shark"
	tbl_13.font_type = flag_8
	tbl_13.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_13.default_text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_13.offset = {
		32,
		-2,
		5
	}
	tbl_10.title_text_shadow = tbl_13
	tbl_10.frame = {
		masked = flag,
		texture_size = button_frame_01.texture_size,
		texture_sizes = button_frame_01.texture_sizes,
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
		}
	}
	tbl_10.glass_top = {
		masked = flag,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			arg_1_1[2] - (var_1_4 + 11),
			4
		},
		size = {
			arg_1_1[1],
			11
		}
	}
	tbl_10.glass_bottom = {
		masked = flag,
		color = {
			100,
			255,
			255,
			255
		},
		offset = {
			0,
			var_1_4 - 9,
			4
		},
		size = {
			arg_1_1[1],
			11
		}
	}
	tbl_10.side_detail_left = {
		masked = flag,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			-9,
			arg_1_1[2] / 2 - size[2] / 2,
			9
		},
		size = {
			size[1],
			size[2]
		}
	}
	tbl_10.side_detail_right = {
		masked = flag,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			arg_1_1[1] - size[1] + 9,
			arg_1_1[2] / 2 - size[2] / 2,
			9
		},
		size = {
			size[1],
			size[2]
		}
	}
	tbl_10.new_texture = {
		masked = flag,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			arg_1_1[1] - 126,
			arg_1_1[2] / 2 - 25,
			10
		},
		size = {
			126,
			51
		}
	}
	tbl_10.locked = {
		masked = flag,
		color = {
			255,
			100,
			100,
			100
		},
		offset = {
			arg_1_1[1] - 64,
			arg_1_1[2] / 2 - 20,
			10
		},
		size = {
			56,
			40
		}
	}
	tbl_9.style = tbl_10
	tbl_9.scenegraph_id = arg_1_0
	tbl_9.offset = {
		0,
		0,
		0
	}

	return tbl_9
end

local flag = true
local tbl_15 = {
	window = UIWidgets.create_frame("window", tbl_10.window.size, "menu_frame_11", 40),
	window_background = UIWidgets.create_tiled_texture("window_background", "menu_frame_bg_01", {
		960,
		1080
	}, nil, nil, {
		255,
		100,
		100,
		100
	}),
	left_window_mask = UIWidgets.create_simple_texture("mask_rect", "category_window"),
	category_window_mask_top = UIWidgets.create_simple_texture("mask_rect_edge_fade", "category_window_mask_top"),
	category_window_mask_bottom = UIWidgets.create_simple_uv_texture("mask_rect_edge_fade", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "category_window_mask_bottom"),
	right_window_frame = UIWidgets.create_frame("right_window", tbl_10.right_window.size, "menu_frame_11", 20),
	right_window_fade = UIWidgets.create_simple_texture("options_window_fade_01", "right_window_fade"),
	right_window = UIWidgets.create_tiled_texture("right_window", "achievement_background_leather_02", {
		256,
		256
	}, nil, nil, {
		255,
		180,
		180,
		180
	}),
	right_window_mask = UIWidgets.create_simple_texture("mask_rect", "achievement_window"),
	achievement_window_mask_bottom = UIWidgets.create_simple_rotated_texture("mask_rect_edge_fade", math.pi, {
		tbl_3[1] / 2,
		15
	}, "achievement_window_mask_bottom"),
	achievement_window_mask_top = UIWidgets.create_simple_texture("mask_rect_edge_fade", "achievement_window_mask_top"),
	exit_button = UIWidgets.create_default_button("exit_button", tbl_10.exit_button.size, nil, nil, Localize("menu_close"), 24, nil, "button_detail_04", 34, flag),
	title = UIWidgets.create_simple_texture("frame_title_bg_02", "title"),
	title_bg = UIWidgets.create_background("title_bg", tbl_10.title_bg.size, "menu_frame_bg_02"),
	title_text = UIWidgets.create_simple_text(Localize("tutorial_menu_header"), "title_text", nil, nil, tbl_11),
	achievement_scrollbar = UIWidgets.create_chain_scrollbar("achievement_scrollbar", nil, tbl_10.achievement_scrollbar.size),
	category_scrollbar = UIWidgets.create_chain_scrollbar("category_scrollbar", "category_window_mask", tbl_10.category_scrollbar.size),
	page_button_next = UIWidgets.create_arrow_button("page_button_next", math.pi),
	page_button_previous = UIWidgets.create_arrow_button("page_button_previous"),
	input_icon_next = UIWidgets.create_simple_texture("xbone_button_icon_a", "input_icon_next"),
	input_icon_previous = UIWidgets.create_simple_texture("xbone_button_icon_a", "input_icon_previous"),
	input_arrow_next = UIWidgets.create_simple_uv_texture("settings_arrow_normal", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "input_arrow_next"),
	input_arrow_previous = UIWidgets.create_simple_texture("settings_arrow_normal", "input_arrow_previous"),
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, tbl_14),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_12),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_13),
	page_text_area = UIWidgets.create_simple_texture("tab_menu_bg_03", "page_text_area"),
	achievement_window = {
		scenegraph_id = "achievement_window_mask",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "scroll",
					scroll_function = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
						-- function 14
						local num = arg_14_4.y * -1

						if not (not IS_XB1 and not GameSettingsDevelopment.allow_keyboard_mouse and arg_14_2.is_gamepad_active) then
							num = math.sign(arg_14_4.x) * -1
						end

						local hotspot = arg_14_2.hotspot

						if num == 0 or not hotspot.is_hover then
							arg_14_2.axis_input = num
							arg_14_2.scroll_add = num * arg_14_2.scroll_amount
						end

						local scroll_add = arg_14_2.scroll_add

						if not scroll_add then
							local num_2 = scroll_add * (arg_14_5 * 5)
							local num_3 = scroll_add - num_2

							if math.abs(num_3) > 0 then
								arg_14_2.scroll_add = num_3
							else
								arg_14_2.scroll_add = nil
							end

							local scroll_value = arg_14_2.scroll_value

							arg_14_2.scroll_value = math.clamp(scroll_value + num_2, 0, 1)
						end
					end
				}
			}
		},
		content = {
			scroll_amount = 0.1,
			scroll_value = 1,
			hotspot = {
				allow_multi_hover = true
			}
		},
		style = {}
	}
}

local function fn_2(arg_15_0)
	-- function 15
	local tbl = {}

	for i = 1, arg_15_0 + 1 do
		local flag = i == 1
		local str = "category_tab_" .. i
		local str_2 = "category_tab_" .. i .. "_list"
		local str_3 = "category_tab_" .. i - 1 .. "_list"
		local var_15_5 = tbl_10
		local tbl_2 = {
			horizontal_alignment = "center"
		}
		local flag_2

		flag_2 = not flag and "category_root" and str_3
		tbl_2.parent = flag_2

		local flag_3

		flag_3 = not flag and "top" and "bottom"
		tbl_2.vertical_alignment = flag_3
		tbl_2.size = tbl_6

		local tbl_3 = {
			nil,
			nil,
			0
		}
		local flag_4

		flag_4 = not flag and -15 and 0
		tbl_3[1] = flag_4

		local flag_5

		flag_5 = not flag and -20 and -(tbl_6[2] + num_2)
		tbl_3[2] = flag_5
		tbl_2.position = tbl_3
		var_15_5[str] = tbl_2
		tbl_10[str_2] = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			parent = str,
			size = {
				tbl_6[1],
				0
			},
			position = {
				0,
				-(tbl_6[2] + num_2),
				0
			}
		}
		tbl[i] = fn(str, tbl_6, "n/a", str_2)
	end

	return tbl
end

local tbl_16 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				arg_16_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				arg_17_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				arg_19_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				arg_20_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				return
			end
		}
	}
}
local tbl_17 = {
	default = {
		{
			input_action = "confirm",
			priority = 1,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 4,
			description_text = "input_description_close"
		}
	},
	has_pages = {
		actions = {
			{
				input_action = "l1_r1",
				priority = 2,
				description_text = "input_description_change_tab",
				ignore_keybinding = true
			}
		}
	}
}

local function fn_3(arg_22_0)
	-- function 22
	local find, var_22_1, var_22_2 = string.find(arg_22_0, "^<(/?)kw")

	if not find then
		return arg_22_0
	end

	local flag

	flag = not var_22_2 and "{#reset()}" and "{#color(255,193,91)}"

	return flag
end

local function fn_4(self, arg_23_1)
	-- function 23
	return {
		scenegraph_id = self.scenegraph_id,
		element = {
			passes = {}
		},
		content = {
			size = arg_23_1.size
		},
		style = {}
	}
end

local function fn_5(self, arg_24_1)
	-- function 24
	local tbl = {
		num,
		0
	}
	local Localize = Localize
	local text = arg_24_1.text

	text = text or "n/a"

	local var_24_3 = Localize(text)

	if not arg_24_1.inputs then
		local tbl_2 = {}

		for i, v in ipairs(arg_24_1.inputs) do
			local str = "Player"
			local var_24_6 = v

			tbl_2[i] = string.format("$KEY;%s__%s: ", str, var_24_6)
		end

		var_24_3 = string.format(var_24_3, unpack(tbl_2))
	end

	local gsub = string.gsub(var_24_3, "%b<>", fn_3)
	local tbl_3 = {
		vertical_alignment = "top",
		word_wrap = true,
		localize = false,
		horizontal_alignment = "center",
		font_size = 24,
		font_type = "hell_shark_masked",
		size = tbl,
		text_color = Colors.get_color_table_with_alpha("font_default", 255)
	}

	if not arg_24_1.style then
		table.merge(tbl_3, arg_24_1.style)
	end

	local var_24_9
	local var_24_10
	local var_24_11

	if not tbl_3.use_shadow then
		var_24_9 = {
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text_shadow"
		}
		var_24_10 = string.gsub(gsub, "%b{}", "")
		var_24_11 = table.shallow_copy(tbl_3)
		var_24_11.offset = {
			2,
			2,
			-1
		}
		var_24_11.skip_button_rendering = true
		var_24_11.text_color = {
			tbl_3.text_color[1],
			0,
			0,
			0
		}

		if not tbl_3.shadow_color then
			Colors.copy_no_alpha_to(var_24_11.text_color, tbl_3.shadow_color)
		end
	end

	tbl[2] = UIUtils.get_text_height(self.ui_renderer, tbl, tbl_3, gsub)

	local tbl_4 = {
		scenegraph_id = self.scenegraph_id,
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				var_24_9
			}
		}
	}
	local tbl_5 = {
		text = gsub,
		text_shadow = var_24_10,
		size = tbl
	}
	local padding = arg_24_1.padding

	padding = padding or 25
	tbl_5.padding = padding
	tbl_4.content = tbl_5
	tbl_4.style = {
		text = tbl_3,
		text_shadow = var_24_11
	}

	return tbl_4
end

local function fn_6(self, arg_25_1)
	-- function 25
	local tbl = {
		674,
		380
	}
	local num_2 = 0.5 * (num - tbl[1])
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local shadow_frame_02 = UIFrameSettings.shadow_frame_02
	local num_3 = -1 * shadow_frame_02.texture_sizes.horizontal[2]
	local tbl_2 = {
		num_3,
		num_3
	}

	return {
		scenegraph_id = self.scenegraph_id,
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture",
					texture_id = "texture",
					content_check_function = function (self)
						-- function 26
						return self.texture
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "shadow",
					texture_id = "shadow",
					content_check_function = function (self)
						-- function 27
						return self.texture
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame",
					content_check_function = function (self)
						-- function 28
						return self.texture
					end
				},
				{
					style_id = "loading_icon",
					texture_id = "loading_icon",
					pass_type = "rotated_texture",
					content_check_function = function (self)
						-- function 29
						return not self.texture
					end,
					content_change_function = function (self, arg_30_1, arg_30_2, arg_30_3)
						-- function 30
						local num = (self.loading_progress + arg_30_3) % 1

						arg_30_1.angle = 2^math.smoothstep(num, 0, 1) * math.tau
						self.loading_progress = num
					end
				}
			}
		},
		content = {
			loading_progress = 0,
			loading_icon = "loot_loading",
			size = tbl,
			frame = menu_frame_06.texture,
			shadow = shadow_frame_02.texture,
			frame_detail = {
				texture_id = "frame_detail_03",
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				}
			}
		},
		style = {
			texture = {
				vertical_alignment = "bottom",
				masked = true,
				horizontal_alignment = "center",
				texture_size = tbl
			},
			shadow = {
				masked = true,
				offset = {
					num_2,
					0,
					0
				},
				area_size = tbl,
				frame_margins = tbl_2,
				texture_size = shadow_frame_02.texture_size,
				texture_sizes = shadow_frame_02.texture_sizes,
				color = {
					255,
					0,
					0,
					0
				}
			},
			frame = {
				masked = true,
				offset = {
					num_2,
					0,
					1
				},
				area_size = tbl,
				texture_size = menu_frame_06.texture_size,
				texture_sizes = menu_frame_06.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				}
			},
			frame_detail_left = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					230,
					59
				},
				size = tbl,
				offset = {
					num_2 - 40,
					16,
					2
				}
			},
			frame_detail_right = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					230,
					59
				},
				size = tbl,
				offset = {
					num_2 + 50,
					12,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			loading_icon = {
				horizontal_alignment = "center",
				masked = true,
				vertical_alignment = "center",
				angle = 0,
				texture_size = {
					150,
					150
				},
				offset = {
					num_2,
					0,
					0
				},
				size = tbl,
				pivot = {
					75,
					75
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}
end

local function fn_7(self, arg_31_1)
	-- function 31
	local tbl = {
		852,
		480
	}
	local num_2 = 0.5 * (num - tbl[1])
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local shadow_frame_02 = UIFrameSettings.shadow_frame_02
	local num_3 = -1 * shadow_frame_02.texture_sizes.horizontal[2]
	local tbl_2 = {
		num_3,
		num_3
	}
	local str = "video/tutorial_videos/" .. arg_31_1.path
	local create_video_player = self.layout:create_video_player(str)

	return {
		scenegraph_id = self.scenegraph_id,
		element = {
			passes = {
				{
					style_id = "video",
					pass_type = "video",
					content_check_function = function (self)
						-- function 32
						return self.video_player_reference
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "shadow",
					texture_id = "shadow",
					content_check_function = function (self)
						-- function 33
						return self.video_player_reference
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame",
					content_check_function = function (self)
						-- function 34
						return self.video_player_reference
					end
				}
			}
		},
		content = {
			loading_progress = 0,
			loading_icon = "loot_loading",
			size = tbl,
			material_name = arg_31_1.path,
			video_player_reference = create_video_player,
			frame = menu_frame_06.texture,
			shadow = shadow_frame_02.texture,
			frame_detail = {
				texture_id = "frame_detail_03",
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				}
			}
		},
		style = {
			video = {
				size = tbl,
				offset = {
					num_2,
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			shadow = {
				masked = true,
				offset = {
					num_2,
					0,
					0
				},
				area_size = tbl,
				frame_margins = tbl_2,
				texture_size = shadow_frame_02.texture_size,
				texture_sizes = shadow_frame_02.texture_sizes,
				color = {
					255,
					0,
					0,
					0
				}
			},
			frame = {
				masked = true,
				offset = {
					num_2,
					0,
					1
				},
				size = tbl,
				texture_size = menu_frame_06.texture_size,
				texture_sizes = menu_frame_06.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				}
			}
		}
	}
end

return {
	generic_input_actions = tbl_17,
	category_tab_info = tbl_9,
	achievement_window_size = tbl_3,
	achievement_scrollbar_size = tbl_4,
	content_blueprints = {
		spacing = fn_4,
		text = fn_5,
		image = fn_6,
		video = fn_7
	},
	widgets = tbl_15,
	create_category_tab_widgets_func = fn_2,
	scenegraph_definition = tbl_10,
	animation_definitions = tbl_16,
	console_cursor_definition = UIWidgets.create_console_cursor("console_cursor")
}
