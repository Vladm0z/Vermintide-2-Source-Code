-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_options_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local var_0_4 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_5 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local tbl = {
	size[1] - var_0_4 * 2,
	(size[2] - var_0_5 * 2) / 3.5
}
local tbl_2 = {
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
		size = size,
		position = {
			0,
			0,
			1
		}
	},
	title_text_glow = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			544,
			16
		},
		position = {
			0,
			15,
			-1
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "title_text_glow",
		horizontal_alignment = "center",
		size = {
			size[1],
			50
		},
		position = {
			0,
			15,
			1
		}
	},
	hero_info_bg = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1],
			220
		},
		position = {
			0,
			0,
			1
		}
	},
	hero_info_divider = {
		vertical_alignment = "bottom",
		parent = "hero_info_bg",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			0,
			10
		}
	},
	hero_info_detail = {
		vertical_alignment = "center",
		parent = "hero_info_divider",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			0,
			11
		}
	},
	prestige_button = {
		vertical_alignment = "top",
		parent = "hero_info_bg",
		horizontal_alignment = "right",
		size = {
			size[1] / 2,
			35
		},
		position = {
			0,
			-5,
			1
		}
	},
	prestige_divider = {
		vertical_alignment = "center",
		parent = "prestige_button",
		horizontal_alignment = "left",
		size = {
			size[1] / 2,
			35
		},
		position = {
			-5,
			0,
			1
		}
	},
	experience_bar_fg = {
		vertical_alignment = "top",
		parent = "hero_info_bg",
		horizontal_alignment = "left",
		size = {
			size[1] - 10,
			40
		},
		position = {
			5,
			0,
			7
		}
	},
	experience_bar_glass = {
		vertical_alignment = "top",
		parent = "experience_bar_fg",
		horizontal_alignment = "center",
		size = {
			438,
			5
		},
		position = {
			0,
			-5,
			-1
		}
	},
	experience_divider = {
		vertical_alignment = "bottom",
		parent = "experience_bar_fg",
		horizontal_alignment = "left",
		size = {
			size[1],
			0
		},
		position = {
			-5,
			-5,
			10
		}
	},
	experience_bar_bg = {
		vertical_alignment = "center",
		parent = "experience_bar_fg",
		horizontal_alignment = "center",
		size = {
			438,
			40
		},
		position = {
			0,
			0,
			-6
		}
	},
	experience_bar = {
		vertical_alignment = "bottom",
		parent = "experience_bar_bg",
		horizontal_alignment = "left",
		size = {
			438,
			40
		},
		position = {
			0,
			0,
			2
		}
	},
	experience_bar_edge = {
		vertical_alignment = "center",
		parent = "experience_bar",
		horizontal_alignment = "right",
		size = {
			40,
			40
		},
		position = {
			40,
			0,
			3
		}
	},
	portrait_root = {
		vertical_alignment = "top",
		parent = "hero_info_bg",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-100,
			-130,
			5
		}
	},
	career_name = {
		vertical_alignment = "top",
		parent = "hero_info_bg",
		horizontal_alignment = "left",
		size = {
			size[1] - 190,
			0
		},
		position = {
			20,
			-65,
			1
		}
	},
	name_divider = {
		vertical_alignment = "bottom",
		parent = "career_name",
		horizontal_alignment = "left",
		size = {
			size[1] / 2,
			4
		},
		position = {
			0,
			-16,
			1
		}
	},
	hero_name = {
		vertical_alignment = "bottom",
		parent = "name_divider",
		horizontal_alignment = "left",
		size = {
			size[1] - 190,
			0
		},
		position = {
			0,
			-12,
			1
		}
	},
	power_text_bg = {
		vertical_alignment = "bottom",
		parent = "hero_info_bg",
		horizontal_alignment = "left",
		size = {
			115,
			63
		},
		position = {
			30,
			10,
			1
		}
	},
	power_text = {
		vertical_alignment = "center",
		parent = "power_text_bg",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			-4,
			-3,
			1
		}
	},
	power_title = {
		vertical_alignment = "top",
		parent = "power_text_bg",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	level_text = {
		vertical_alignment = "center",
		parent = "experience_bar_fg",
		horizontal_alignment = "left",
		size = {
			size[1],
			0
		},
		position = {
			0,
			-3,
			5
		}
	},
	game_option_1 = {
		vertical_alignment = "bottom",
		parent = "game_option_2",
		horizontal_alignment = "center",
		size = {
			size[1] - 20,
			108
		},
		position = {
			0,
			124,
			3
		}
	},
	game_option_2 = {
		vertical_alignment = "bottom",
		parent = "game_option_3",
		horizontal_alignment = "center",
		size = {
			size[1] - 20,
			108
		},
		position = {
			0,
			124,
			3
		}
	},
	game_option_3 = {
		vertical_alignment = "bottom",
		parent = "game_option_4",
		horizontal_alignment = "center",
		size = {
			size[1] - 20,
			108
		},
		position = {
			0,
			124,
			3
		}
	},
	game_option_4 = {
		vertical_alignment = "bottom",
		parent = "game_option_5",
		horizontal_alignment = "center",
		size = {
			size[1] - 20,
			108
		},
		position = {
			0,
			84,
			3
		}
	},
	game_option_5 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1] - 40,
			70
		},
		position = {
			0,
			18,
			1
		}
	},
	game_options_right_chain = {
		vertical_alignment = "top",
		parent = "hero_info_divider",
		horizontal_alignment = "center",
		size = {
			16,
			600
		},
		position = {
			195,
			0,
			-10
		}
	},
	game_options_left_chain = {
		vertical_alignment = "top",
		parent = "hero_info_divider",
		horizontal_alignment = "center",
		size = {
			16,
			600
		},
		position = {
			-195,
			0,
			-10
		}
	},
	game_options_right_chain_end = {
		vertical_alignment = "bottom",
		parent = "game_options_right_chain",
		horizontal_alignment = "center",
		size = {
			19,
			20
		},
		position = {
			-1,
			-20,
			1
		}
	},
	game_options_left_chain_end = {
		vertical_alignment = "bottom",
		parent = "game_options_left_chain",
		horizontal_alignment = "center",
		size = {
			19,
			20
		},
		position = {
			-1,
			-20,
			1
		}
	}
}
local tbl_3 = {
	use_shadow = true,
	upper_case = true,
	localize = true,
	font_size = 28,
	horizontal_alignment = "left",
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
local tbl_4 = {
	font_size = 20,
	use_shadow = true,
	localize = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_5 = {
	use_shadow = true,
	vertical_alignment = "bottom",
	localize = true,
	horizontal_alignment = "center",
	font_size = 20,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_6 = {
	use_shadow = true,
	vertical_alignment = "center",
	localize = false,
	horizontal_alignment = "center",
	font_size = 24,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_7 = {
	use_shadow = true,
	vertical_alignment = "center",
	localize = false,
	horizontal_alignment = "center",
	font_size = 42,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
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
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					5,
					0,
					6
				},
				size = {
					arg_1_1[1] - 10,
					5
				},
				texture_tiling_size = {
					arg_1_1[1] - 10,
					5
				}
			},
			edge_holder_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					3,
					-6,
					10
				},
				size = {
					9,
					17
				}
			},
			edge_holder_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_1_1[1] - 12,
					-6,
					10
				},
				size = {
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
					5,
					arg_2_1[2] - 9
				},
				texture_tiling_size = {
					5,
					arg_2_1[2] - 9
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
					17,
					9
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
					17,
					9
				}
			}
		},
		scenegraph_id = arg_2_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local var_3_0

	if not arg_3_5 then
		var_3_0 = "button_" .. arg_3_5
	else
		var_3_0 = "button_normal"
	end

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(var_3_0, 255)
	local str = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl = {
		element = {
			passes = {
				{
					style_id = "button_background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "button_background",
					pass_type = "texture_uv",
					content_id = "button_background"
				},
				{
					texture_id = "bottom_edge",
					style_id = "button_edge",
					pass_type = "tiled_texture"
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
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 4
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
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 5
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 6
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_shadow",
					pass_type = "text",
					text_id = "button_text"
				},
				{
					style_id = "button_clicked_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 7
						local is_clicked = self.button_hotspot.is_clicked

						return not is_clicked and is_clicked == 0
					end
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 8
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture",
					content_check_function = function (self)
						-- function 9
						return self.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 10
						return self.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 11
						return self.use_bottom_edge
					end
				}
			}
		}
	}
	local tbl_2 = {
		edge_holder_left = "menu_frame_09_divider_left",
		edge_holder_right = "menu_frame_09_divider_right",
		glass_top = "button_glass_01",
		bottom_edge = "menu_frame_09_divider",
		use_bottom_edge = arg_3_4,
		button_hotspot = {},
		button_text = arg_3_2 or "n/a"
	}
	local str_2

	if not arg_3_5 then
		str_2 = "button_state_hover_" .. arg_3_5

		if not str_2 then
			-- Nothing
		end
	end

	str_2 = "button_state_hover"

	::label_3_0::

	tbl_2.hover_glow = str_2

	local str_3

	if not arg_3_5 then
		str_3 = "button_state_normal_" .. arg_3_5

		if not str_3 then
			-- Nothing
		end
	end

	str_3 = "button_state_normal"

	::label_3_1::

	tbl_2.glow = str_3
	tbl_2.button_background = {
		uvs = {
			{
				0,
				1 - math.min(arg_3_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
			},
			{
				math.min(arg_3_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
				1
			}
		},
		texture_id = str
	}
	tbl.content = tbl_2
	tbl.style = {
		button_background = {
			color = get_color_table_with_alpha,
			offset = {
				0,
				0,
				2
			},
			size = arg_3_1
		},
		button_edge = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				arg_3_1[2],
				3
			},
			size = {
				arg_3_1[1],
				5
			},
			texture_tiling_size = {
				arg_3_1[1],
				5
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
				arg_3_1[2] - 4,
				3
			},
			size = {
				arg_3_1[1],
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
				5,
				3
			},
			size = {
				arg_3_1[1],
				arg_3_1[2] - 5
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
				5,
				2
			},
			size = {
				arg_3_1[1],
				arg_3_1[2] - 5
			}
		},
		bottom_edge = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				5,
				0,
				6
			},
			size = {
				arg_3_1[1] - 10,
				5
			},
			texture_tiling_size = {
				arg_3_1[1] - 10,
				5
			}
		},
		edge_holder_left = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				3,
				-6,
				10
			},
			size = {
				9,
				17
			}
		},
		edge_holder_right = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_3_1[1] - 12,
				-6,
				10
			},
			size = {
				9,
				17
			}
		},
		button_text = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_3_3 or 24,
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				0,
				3,
				4
			},
			size = arg_3_1
		},
		button_text_disabled = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_3_3 or 24,
			text_color = Colors.get_color_table_with_alpha("gray", 255),
			offset = {
				0,
				3,
				4
			},
			size = arg_3_1
		},
		button_text_shadow = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_3_3 or 24,
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				1,
				3
			},
			size = arg_3_1
		},
		button_clicked_rect = {
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				5
			},
			size = arg_3_1
		},
		button_disabled_rect = {
			color = {
				150,
				5,
				5,
				5
			},
			offset = {
				0,
				0,
				5
			},
			size = arg_3_1
		}
	}
	tbl.scenegraph_id = arg_3_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

local tbl_8 = {
	hero_power_tooltip = {
		scenegraph_id = "power_text_bg",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "hover",
					texture_id = "hover",
					content_check_function = function (self)
						-- function 12
						return self.button_hotspot.is_hover
					end
				},
				{
					pass_type = "hero_power_tooltip",
					content_check_function = function (self)
						-- function 13
						return self.button_hotspot.is_hover
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "effect",
					texture_id = "effect"
				}
			}
		},
		content = {
			effect = "sparkle_effect",
			background = "hero_power_bg",
			hover = "hero_power_bg_hover",
			button_hotspot = {}
		},
		style = {
			background = {
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
			hover = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					140,
					89
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
			effect = {
				vertical_alignment = "top",
				angle = 0,
				horizontal_alignment = "right",
				offset = {
					110,
					120,
					4
				},
				pivot = {
					128,
					128
				},
				texture_size = {
					256,
					256
				},
				color = Colors.get_color_table_with_alpha("white", 0)
			}
		}
	},
	hero_info_divider = fn("hero_info_divider", tbl_2.hero_info_divider.size),
	hero_info_detail = UIWidgets.create_simple_texture("divider_01_top", "hero_info_detail"),
	background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window"),
	window = UIWidgets.create_frame("window", size, frame, 20),
	game_option_1 = UIWidgets.create_window_category_button("game_option_1", tbl_2.game_option_1.size, Localize("hero_window_equipment"), "options_button_icon_equipment", "menu_options_button_image_01"),
	game_option_2 = UIWidgets.create_window_category_button("game_option_2", tbl_2.game_option_2.size, Localize("hero_window_talents"), "options_button_icon_talents", "menu_options_button_image_08"),
	game_option_3 = UIWidgets.create_window_category_button("game_option_3", tbl_2.game_option_3.size, Localize("hero_window_crafting"), "options_button_icon_crafting", "menu_options_button_image_06"),
	game_option_4 = UIWidgets.create_window_category_button("game_option_4", tbl_2.game_option_4.size, Localize("hero_window_cosmetics"), "options_button_icon_cosmetics", "menu_options_button_image_07"),
	game_option_5 = UIWidgets.create_default_image_button("game_option_5", tbl_2.game_option_5.size, nil, nil, Localize("hero_window_loot_crates"), 28),
	game_options_left_chain = UIWidgets.create_tiled_texture("game_options_left_chain", "chain_link_01", {
		16,
		19
	}),
	game_options_right_chain = UIWidgets.create_tiled_texture("game_options_right_chain", "chain_link_01", {
		16,
		19
	}),
	experience_bar_fg = UIWidgets.create_simple_texture("crafting_button_fg", "experience_bar_fg"),
	experience_bar_glass = UIWidgets.create_simple_texture("button_glass_01", "experience_bar_glass"),
	experience_bar_bg = UIWidgets.create_simple_rect("experience_bar_bg", {
		255,
		0,
		0,
		0
	}),
	experience_bar_edge = UIWidgets.create_simple_texture("experience_bar_edge_glow", "experience_bar_edge"),
	experience_bar = UIWidgets.create_simple_uv_texture("experience_bar_fill", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "experience_bar"),
	experience_divider = fn("experience_divider", tbl_2.experience_divider.size),
	career_name = UIWidgets.create_simple_text("n/a", "career_name", 22, nil, tbl_3),
	hero_name = UIWidgets.create_simple_text("n/a", "hero_name", 22, nil, tbl_4),
	name_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "name_divider"),
	power_title = UIWidgets.create_simple_text("hero_power_header", "power_title", 22, nil, tbl_5),
	power_text = UIWidgets.create_simple_text("n/a", "power_text", 22, nil, tbl_7),
	level_text = UIWidgets.create_simple_text("n/a", "level_text", 22, nil, tbl_6)
}
local tbl_9 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				arg_14_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				-- function 15
				local easeOutCubic = math.easeOutCubic(arg_15_3)

				arg_15_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				arg_17_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				-- function 18
				local easeOutCubic = math.easeOutCubic(arg_18_3)

				arg_18_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end
		}
	}
}

return {
	widgets = tbl_8,
	node_widgets = node_widgets,
	scenegraph_definition = tbl_2,
	animation_definitions = tbl_9
}
