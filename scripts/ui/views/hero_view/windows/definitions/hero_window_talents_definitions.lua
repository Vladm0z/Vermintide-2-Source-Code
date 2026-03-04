-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_talents_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = var_0_0.spacing
local var_0_5 = UIFrameSettings[var_0_2].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[var_0_2].texture_sizes.horizontal[2]
local var_0_7 = var_0_3[1] * 2 + var_0_4 * 2
local var_0_8 = var_0_3[1] - (var_0_5 * 2 + 60)
local var_0_9 = {
	var_0_3[1] * 2 + var_0_4,
	var_0_3[2]
}
local var_0_10 = {
	math.floor(var_0_9[1] / 2 - 10),
	160
}
local var_0_11 = {
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
		size = var_0_3,
		position = {
			0,
			0,
			1
		}
	},
	window_frame = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = var_0_9,
		position = {
			0,
			0,
			1
		}
	},
	career_window = {
		vertical_alignment = "top",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 20,
			var_0_10[2] + 40
		},
		position = {
			0,
			-10,
			1
		}
	},
	career_window_edge = {
		vertical_alignment = "bottom",
		parent = "career_window",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 20,
			0
		},
		position = {
			0,
			40,
			1
		}
	},
	career_window_center_edge = {
		vertical_alignment = "top",
		parent = "career_window",
		horizontal_alignment = "center",
		size = {
			0,
			var_0_10[2] - 5
		},
		position = {
			0,
			-5,
			1
		}
	},
	passive_window = {
		vertical_alignment = "top",
		parent = "career_window",
		horizontal_alignment = "left",
		size = var_0_10,
		position = {
			0,
			0,
			1
		}
	},
	passive_icon = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "left",
		size = {
			80,
			80
		},
		position = {
			10,
			-50,
			5
		}
	},
	passive_icon_frame = {
		vertical_alignment = "center",
		parent = "passive_icon",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	passive_title_text = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "left",
		size = {
			var_0_10[1] * 0.6,
			50
		},
		position = {
			10,
			-5,
			1
		}
	},
	passive_title_divider = {
		vertical_alignment = "bottom",
		parent = "passive_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	passive_type_title = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "right",
		size = {
			var_0_10[1] * 0.3,
			50
		},
		position = {
			-10,
			-5,
			1
		}
	},
	passive_description_text = {
		vertical_alignment = "top",
		parent = "passive_icon",
		horizontal_alignment = "left",
		size = {
			var_0_10[1] - 110,
			var_0_10[2] - 50
		},
		position = {
			90,
			0,
			1
		}
	},
	active_window = {
		vertical_alignment = "top",
		parent = "career_window",
		horizontal_alignment = "right",
		size = var_0_10,
		position = {
			0,
			0,
			1
		}
	},
	active_icon = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "left",
		size = {
			80,
			80
		},
		position = {
			10,
			-50,
			5
		}
	},
	active_icon_frame = {
		vertical_alignment = "center",
		parent = "active_icon",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	active_title_text = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "left",
		size = {
			var_0_10[1] * 0.6,
			50
		},
		position = {
			10,
			-5,
			1
		}
	},
	active_title_divider = {
		vertical_alignment = "bottom",
		parent = "active_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	active_type_title = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "right",
		size = {
			var_0_10[1] * 0.3,
			50
		},
		position = {
			-10,
			-5,
			1
		}
	},
	active_description_text = {
		vertical_alignment = "top",
		parent = "active_icon",
		horizontal_alignment = "left",
		size = {
			var_0_10[1] - 110,
			var_0_10[2] - 50
		},
		position = {
			90,
			0,
			1
		}
	},
	career_perks = {
		vertical_alignment = "bottom",
		parent = "career_window",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 40,
			40
		},
		position = {
			0,
			10,
			4
		}
	},
	career_perk_1 = {
		vertical_alignment = "center",
		parent = "career_perks",
		horizontal_alignment = "center",
		size = {
			200,
			40
		},
		position = {
			-350,
			-6,
			1
		}
	},
	career_perk_2 = {
		vertical_alignment = "center",
		parent = "career_perks",
		horizontal_alignment = "center",
		size = {
			200,
			40
		},
		position = {
			0,
			-6,
			1
		}
	},
	career_perk_3 = {
		vertical_alignment = "center",
		parent = "career_perks",
		horizontal_alignment = "center",
		size = {
			200,
			40
		},
		position = {
			350,
			-6,
			1
		}
	},
	talent_title_text = {
		vertical_alignment = "bottom",
		parent = "career_window",
		horizontal_alignment = "center",
		size = {
			var_0_9[1],
			50
		},
		position = {
			0,
			-50,
			1
		}
	},
	talent_title_divider = {
		vertical_alignment = "bottom",
		parent = "talent_title_text",
		horizontal_alignment = "center",
		size = {
			264,
			21
		},
		position = {
			0,
			-10,
			1
		}
	},
	talents_window = {
		vertical_alignment = "bottom",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			var_0_9[1],
			505
		},
		position = {
			0,
			0,
			1
		}
	},
	talent_row_1 = {
		vertical_alignment = "bottom",
		parent = "talent_row_2",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_2 = {
		vertical_alignment = "bottom",
		parent = "talent_row_3",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_3 = {
		vertical_alignment = "bottom",
		parent = "talent_row_4",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_4 = {
		vertical_alignment = "bottom",
		parent = "talent_row_5",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_5 = {
		vertical_alignment = "bottom",
		parent = "talent_row_6",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 20,
			80
		},
		position = {
			0,
			90,
			0
		}
	},
	talent_row_6 = {
		vertical_alignment = "bottom",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			var_0_9[1] - 20,
			80
		},
		position = {
			0,
			10,
			5
		}
	}
}
local var_0_12 = {
	font_size = 42,
	upper_case = true,
	localize = false,
	use_shadow = true,
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
local var_0_13 = {
	font_size = 17,
	use_shadow = true,
	localize = false,
	dynamic_font_size_word_wrap = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_14 = {
	word_wrap = true,
	use_shadow = true,
	localize = false,
	font_size = 18,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("gray", 200),
	offset = {
		0,
		0,
		2
	}
}
local var_0_15 = {
	font_size = 32,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_16 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		-6,
		2
	}
}

local function var_0_17(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0

	if arg_1_5 then
		var_1_0 = "button_" .. arg_1_5
	else
		var_1_0 = "button_normal"
	end

	local var_1_1 = Colors.get_color_table_with_alpha(var_1_0, 255)
	local var_1_2 = "button_bg_01"
	local var_1_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_2)

	return {
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
					content_check_function = function (arg_2_0)
						local var_2_0 = arg_2_0.button_hotspot

						return not var_2_0.disable_button and (var_2_0.is_selected or var_2_0.is_hover)
					end
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (arg_3_0)
						return not arg_3_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (arg_4_0)
						return arg_4_0.button_hotspot.disable_button
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
					content_check_function = function (arg_5_0)
						local var_5_0 = arg_5_0.button_hotspot.is_clicked

						return not var_5_0 or var_5_0 == 0
					end
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (arg_6_0)
						return arg_6_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture",
					content_check_function = function (arg_7_0)
						return arg_7_0.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture",
					content_check_function = function (arg_8_0)
						return arg_8_0.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture",
					content_check_function = function (arg_9_0)
						return arg_9_0.use_bottom_edge
					end
				}
			}
		},
		content = {
			edge_holder_left = "menu_frame_09_divider_left",
			edge_holder_right = "menu_frame_09_divider_right",
			glass_top = "button_glass_01",
			bottom_edge = "menu_frame_09_divider",
			use_bottom_edge = arg_1_4,
			button_hotspot = {},
			button_text = arg_1_2 or "n/a",
			hover_glow = arg_1_5 and "button_state_hover_" .. arg_1_5 or "button_state_hover",
			glow = arg_1_5 and "button_state_normal_" .. arg_1_5 or "button_state_normal",
			button_background = {
				uvs = {
					{
						0,
						1 - math.min(arg_1_1[2] / var_1_3.size[2], 1)
					},
					{
						math.min(arg_1_1[1] / var_1_3.size[1], 1),
						1
					}
				},
				texture_id = var_1_2
			}
		},
		style = {
			button_background = {
				color = var_1_1,
				offset = {
					0,
					0,
					2
				},
				size = arg_1_1
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
					arg_1_1[2],
					3
				},
				size = {
					arg_1_1[1],
					5
				},
				texture_tiling_size = {
					1,
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
					arg_1_1[2] - 4,
					3
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
					5,
					3
				},
				size = {
					arg_1_1[1],
					arg_1_1[2] - 5
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
					arg_1_1[1],
					arg_1_1[2] - 5
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
					arg_1_1[1] - 10,
					5
				},
				texture_tiling_size = {
					1,
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
			},
			button_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_1_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					5,
					4
				},
				size = arg_1_1
			},
			button_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_1_3 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					5,
					4
				},
				size = arg_1_1
			},
			button_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_1_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					3,
					3
				},
				size = arg_1_1
			},
			button_clicked_rect = {
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					5,
					0,
					5
				},
				size = {
					arg_1_1[1] - 10,
					arg_1_1[2]
				}
			},
			button_disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					5,
					0,
					5
				},
				size = {
					arg_1_1[1] - 10,
					arg_1_1[2]
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

local function var_0_18(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = UIFrameSettings.menu_frame_09
	local var_10_1 = "frame_outer_glow_01"
	local var_10_2 = UIFrameSettings[var_10_1]
	local var_10_3 = var_10_2.texture_sizes.corner[1]
	local var_10_4 = {
		element = {}
	}
	local var_10_5 = {
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame_lock",
			texture_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "lock",
			texture_id = "lock"
		},
		{
			pass_type = "rect",
			style_id = "lock_rect"
		},
		{
			style_id = "level_text",
			pass_type = "text",
			text_id = "level_text"
		},
		{
			style_id = "level_text_shadow",
			pass_type = "text",
			text_id = "level_text"
		},
		{
			texture_id = "glow_frame",
			style_id = "glow_frame",
			pass_type = "texture_frame"
		}
	}
	local var_10_6 = {
		level_text = "0",
		lock = "talent_lock_fg",
		amount = arg_10_2,
		frame = var_10_0.texture,
		glow_frame = var_10_2.texture
	}
	local var_10_7 = {
		frame = {
			texture_size = var_10_0.texture_size,
			texture_sizes = var_10_0.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				arg_10_1[1],
				arg_10_1[2]
			},
			offset = {
				0,
				0,
				5
			}
		},
		frame_lock = {
			texture_size = var_10_0.texture_size,
			texture_sizes = var_10_0.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				103,
				arg_10_1[2]
			},
			offset = {
				0,
				0,
				3
			}
		},
		glow_frame = {
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				-2
			},
			size = arg_10_1,
			texture_size = var_10_2.texture_size,
			texture_sizes = var_10_2.texture_sizes,
			frame_margins = {
				-(var_10_3 - 1),
				-(var_10_3 - 1)
			}
		},
		lock_rect = {
			color = {
				100,
				0,
				0,
				0
			},
			size = {
				100,
				arg_10_1[2]
			},
			offset = {
				0,
				0,
				0
			}
		},
		lock = {
			color = {
				255,
				255,
				255,
				255
			},
			size = {
				97,
				arg_10_1[2]
			},
			offset = {
				3,
				2,
				1
			}
		},
		level_text = {
			word_wrap = true,
			font_size = 26,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				97,
				97
			},
			offset = {
				3,
				-12,
				3
			}
		},
		level_text_shadow = {
			word_wrap = true,
			font_size = 26,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				97,
				97
			},
			offset = {
				5,
				-14,
				2
			}
		}
	}
	local var_10_8 = 0
	local var_10_9 = 0
	local var_10_10 = {
		314,
		arg_10_1[2]
	}
	local var_10_11 = {
		80,
		80
	}
	local var_10_12 = arg_10_1[1] - (var_10_10[1] * arg_10_2 + var_10_8 * (arg_10_2 - 1))

	for iter_10_0 = 1, arg_10_2 do
		local var_10_13 = "_" .. tostring(iter_10_0)
		local var_10_14 = iter_10_0 - 1
		local var_10_15 = {
			var_10_12,
			0,
			var_10_9
		}
		local var_10_16 = "hotspot" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "hotspot",
			content_id = var_10_16,
			style_id = var_10_16
		}
		var_10_7[var_10_16] = {
			size = var_10_10,
			offset = var_10_15
		}
		var_10_6[var_10_16] = {}

		local var_10_17 = var_10_6[var_10_16]
		local var_10_18 = "background" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "rect",
			style_id = var_10_18
		}
		var_10_7[var_10_18] = {
			size = var_10_10,
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				var_10_15[1],
				var_10_15[2],
				0
			}
		}

		local var_10_19 = "frame" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "texture_frame",
			texture_id = var_10_19,
			style_id = var_10_19
		}
		var_10_7[var_10_19] = {
			texture_size = var_10_0.texture_size,
			texture_sizes = var_10_0.texture_sizes,
			size = var_10_10,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_10_15[1],
				var_10_15[2],
				7
			}
		}
		var_10_6[var_10_19] = var_10_0.texture

		local var_10_20 = "selected" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "texture",
			texture_id = var_10_20,
			style_id = var_10_20,
			content_check_function = function (arg_11_0)
				return arg_11_0[var_10_16].is_selected
			end
		}
		var_10_7[var_10_20] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				318,
				80
			},
			size = var_10_10,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_10_15[1],
				var_10_15[2],
				28
			}
		}
		var_10_6[var_10_20] = "talent_selected"

		local var_10_21 = "title_text" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "text",
			text_id = var_10_21,
			style_id = var_10_21,
			content_check_function = function (arg_12_0)
				local var_12_0 = arg_12_0[var_10_16]

				return not var_12_0.is_selected and not var_12_0.disabled
			end
		}
		var_10_7[var_10_21] = {
			word_wrap = true,
			font_size = 24,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				var_10_10[1] - 100,
				var_10_10[2]
			},
			offset = {
				var_10_15[1] + 90,
				var_10_15[2],
				3
			}
		}
		var_10_6[var_10_21] = "n/a"

		local var_10_22 = "title_text_selected" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "text",
			text_id = var_10_21,
			style_id = var_10_22,
			content_check_function = function (arg_13_0)
				local var_13_0 = arg_13_0[var_10_16]

				return var_13_0.is_selected and not var_13_0.disabled
			end
		}
		var_10_7[var_10_22] = {
			word_wrap = true,
			font_size = 24,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			size = {
				var_10_10[1] - 100,
				var_10_10[2]
			},
			offset = {
				var_10_15[1] + 90,
				var_10_15[2],
				3
			}
		}

		local var_10_23 = "title_text_disabled" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "text",
			text_id = var_10_21,
			style_id = var_10_23,
			content_check_function = function (arg_14_0)
				return arg_14_0[var_10_16].disabled
			end
		}
		var_10_7[var_10_23] = {
			word_wrap = true,
			font_size = 24,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = {
				255,
				50,
				50,
				50
			},
			size = {
				var_10_10[1] - 100,
				var_10_10[2]
			},
			offset = {
				var_10_15[1] + 90,
				var_10_15[2],
				3
			}
		}

		local var_10_24 = "title_text_shadow" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "text",
			text_id = var_10_21,
			style_id = var_10_24
		}
		var_10_7[var_10_24] = {
			word_wrap = true,
			font_size = 24,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				var_10_10[1] - 100,
				var_10_10[2]
			},
			offset = {
				var_10_15[1] + 90 + 2,
				var_10_15[2] - 2,
				2
			}
		}

		local var_10_25 = "background_glow" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "texture",
			texture_id = var_10_25,
			style_id = var_10_25,
			content_check_function = function (arg_15_0)
				return arg_15_0[var_10_16].is_hover
			end
		}
		var_10_7[var_10_25] = {
			size = var_10_10,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_10_15[1],
				var_10_15[2],
				3
			}
		}
		var_10_6[var_10_25] = "talent_bg_glow_01"

		local var_10_26 = "glass_top" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "texture",
			texture_id = var_10_26,
			style_id = var_10_26
		}
		var_10_7[var_10_26] = {
			size = {
				var_10_10[1],
				3
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_10_15[1],
				var_10_15[2] + var_10_10[2] - 8,
				5
			}
		}
		var_10_6[var_10_26] = "button_glass_01"

		local var_10_27 = "icon" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "texture",
			texture_id = var_10_27,
			style_id = var_10_27
		}
		var_10_7[var_10_27] = {
			saturated = true,
			size = var_10_11,
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				var_10_15[1],
				var_10_15[2] + var_10_10[2] / 2 - var_10_11[2] / 2,
				3
			}
		}
		var_10_6[var_10_27] = "icons_placeholder"

		local var_10_28 = "icon_rect" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "rect",
			style_id = var_10_28,
			content_check_function = function (arg_16_0)
				local var_16_0 = arg_16_0[var_10_16]

				return not var_16_0.disabled and not var_16_0.is_selected
			end
		}
		var_10_7[var_10_28] = {
			size = var_10_11,
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				var_10_15[1],
				var_10_15[2] + var_10_10[2] / 2 - var_10_11[2] / 2,
				4
			}
		}

		local var_10_29 = "icon_disabled_rect" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "rect",
			style_id = var_10_29,
			content_check_function = function (arg_17_0)
				return arg_17_0[var_10_16].disabled
			end
		}
		var_10_7[var_10_29] = {
			size = var_10_11,
			color = {
				200,
				0,
				0,
				0
			},
			offset = {
				var_10_15[1],
				var_10_15[2] + var_10_10[2] / 2 - var_10_11[2] / 2,
				4
			}
		}

		local var_10_30 = "icon_divider" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			pass_type = "texture",
			texture_id = var_10_30,
			style_id = var_10_30
		}
		var_10_7[var_10_30] = {
			size = {
				5,
				var_10_11[2] - 2
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				var_10_15[1] + var_10_11[1] - 5,
				var_10_15[2] + var_10_10[2] / 2 - var_10_11[2] / 2 + 1,
				6
			}
		}
		var_10_6[var_10_30] = "menu_frame_09_divider_vertical"

		local var_10_31 = "tooltip" .. var_10_13

		var_10_5[#var_10_5 + 1] = {
			talent_id = "talent",
			pass_type = "talent_tooltip",
			content_id = var_10_16,
			style_id = var_10_31,
			content_check_function = function (arg_18_0)
				return arg_18_0.talent and arg_18_0.is_hover
			end
		}
		var_10_7[var_10_31] = {
			size = var_10_10,
			offset = {
				var_10_15[1],
				var_10_15[2],
				var_10_15[3] + 10
			}
		}
		var_10_6[var_10_31] = nil
		var_10_12 = var_10_12 + var_10_10[1] + var_10_8
	end

	var_10_4.element.passes = var_10_5
	var_10_4.content = var_10_6
	var_10_4.style = var_10_7
	var_10_4.offset = {
		0,
		0,
		0
	}
	var_10_4.scenegraph_id = arg_10_0

	return var_10_4
end

local function var_0_19(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_2 or "09"

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
			edge_holder_left = "menu_frame_" .. var_19_0 .. "_divider_left",
			edge_holder_right = "menu_frame_" .. var_19_0 .. "_divider_right",
			bottom_edge = "menu_frame_" .. var_19_0 .. "_divider"
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
					arg_19_1[1] - 10,
					5
				},
				texture_tiling_size = {
					arg_19_1[1] - 10,
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
					arg_19_1[1] - 12,
					-6,
					10
				},
				size = {
					9,
					17
				}
			}
		},
		scenegraph_id = arg_19_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_20(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_2 or "09"

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
			edge_holder_top = "menu_frame_" .. var_20_0 .. "_divider_top",
			edge_holder_bottom = "menu_frame_" .. var_20_0 .. "_divider_bottom",
			edge = "menu_frame_" .. var_20_0 .. "_divider_vertical"
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
					arg_20_1[2] - 9
				},
				texture_tiling_size = {
					5,
					arg_20_1[2] - 9
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
					arg_20_1[2] - 7,
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
		scenegraph_id = arg_20_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_21(arg_21_0, arg_21_1)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_22_0)
						return not arg_22_0.button_hotspot.is_hover
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_23_0)
						return arg_23_0.button_hotspot.is_hover
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "tooltip",
					additional_option_id = "tooltip_data",
					pass_type = "additional_option_tooltip",
					content_check_function = function (arg_24_0)
						return arg_24_0.button_hotspot.is_hover
					end
				}
			}
		},
		content = {
			text = arg_21_0,
			button_hotspot = {
				allow_multi_hover = true
			}
		},
		style = {
			text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					2
				}
			},
			text_hover = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					2
				}
			},
			text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					0
				}
			},
			tooltip = {
				vertical_alignment = "top",
				localize = true,
				horizontal_alignment = "center"
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_21_1
	}
end

local var_0_22 = {
	talent_title_text = UIWidgets.create_simple_text(Localize("hero_window_talents"), "talent_title_text", nil, nil, var_0_16),
	talent_row_1 = var_0_18("talent_row_1", var_0_11.talent_row_1.size, 3, "green"),
	talent_row_2 = var_0_18("talent_row_2", var_0_11.talent_row_2.size, 3),
	talent_row_3 = var_0_18("talent_row_3", var_0_11.talent_row_3.size, 3),
	talent_row_4 = var_0_18("talent_row_4", var_0_11.talent_row_4.size, 3),
	talent_row_5 = var_0_18("talent_row_5", var_0_11.talent_row_5.size, 3),
	talent_row_6 = var_0_18("talent_row_6", var_0_11.talent_row_6.size, 3),
	career_background = UIWidgets.create_background("window_frame", var_0_11.window_frame.size, "talent_tree_bg_01"),
	career_window = UIWidgets.create_frame("window_frame", var_0_11.window_frame.size, var_0_2, 10),
	career_background_rect = UIWidgets.create_simple_rect("window_frame", {
		150,
		0,
		0,
		0
	}, 1),
	career_info_window = UIWidgets.create_frame("career_window", var_0_11.window_frame.size, var_0_2, 10),
	career_info_window_rect = UIWidgets.create_simple_rect("career_window", {
		150,
		0,
		0,
		0
	}, 1),
	career_info_window_bottom_edge = var_0_19("career_window_edge", var_0_11.career_window_edge.size),
	career_info_window_center_edge = var_0_20("career_window_center_edge", var_0_11.career_window_center_edge.size),
	career_perks_dots = UIWidgets.create_simple_centered_texture_amount("mission_objective_01", {
		54,
		22
	}, "career_perks", 2),
	career_perks_dots_glow = UIWidgets.create_simple_centered_texture_amount("mission_objective_glow_02", {
		54,
		22
	}, "career_perks", 2),
	career_perk_1 = var_0_21("", "career_perk_1"),
	career_perk_2 = var_0_21("", "career_perk_2"),
	career_perk_3 = var_0_21("", "career_perk_3"),
	passive_title_text = UIWidgets.create_simple_text("n/a", "passive_title_text", nil, nil, var_0_15),
	passive_type_title = UIWidgets.create_simple_text(Localize("hero_view_passive_ability"), "passive_type_title", nil, nil, var_0_14),
	passive_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "passive_title_divider"),
	passive_description_text = UIWidgets.create_simple_text("n/a", "passive_description_text", nil, nil, var_0_13),
	passive_icon = UIWidgets.create_simple_texture("icons_placeholder", "passive_icon"),
	passive_icon_frame = UIWidgets.create_simple_texture("talent_frame", "passive_icon_frame"),
	active_title_text = UIWidgets.create_simple_text("n/a", "active_title_text", nil, nil, var_0_15),
	active_type_title = UIWidgets.create_simple_text(Localize("hero_view_activated_ability"), "active_type_title", nil, nil, var_0_14),
	active_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "active_title_divider"),
	active_description_text = UIWidgets.create_simple_text("n/a", "active_description_text", nil, nil, var_0_13),
	active_icon = UIWidgets.create_simple_texture("icons_placeholder", "active_icon"),
	active_icon_frame = UIWidgets.create_simple_texture("talent_frame", "active_icon_frame")
}
local var_0_23 = {
	default = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	}
}
local var_0_24 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				arg_25_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				local var_26_0 = math.easeOutCubic(arg_26_3)

				arg_26_4.render_settings.alpha_multiplier = var_26_0
			end,
			on_complete = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				arg_28_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				local var_29_0 = math.easeOutCubic(arg_29_3)

				arg_29_4.render_settings.alpha_multiplier = 1 - var_29_0
			end,
			on_complete = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_22,
	node_widgets = node_widgets,
	scenegraph_definition = var_0_11,
	animation_definitions = var_0_24,
	generic_input_actions = var_0_23
}
