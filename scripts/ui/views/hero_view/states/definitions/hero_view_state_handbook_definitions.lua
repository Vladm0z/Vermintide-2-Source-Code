-- chunkname: @scripts/ui/views/hero_view/states/definitions/hero_view_state_handbook_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.spacing
local var_0_2 = var_0_0.large_window_size
local var_0_3 = var_0_2[2]
local var_0_4 = {
	math.floor((var_0_2[1] + 44) / 3),
	var_0_3
}
local var_0_5 = {
	var_0_2[1] + 22 - var_0_4[1],
	var_0_3
}
local var_0_6 = {
	var_0_5[1] - 22,
	var_0_5[2] - 104
}
local var_0_7 = {
	16,
	var_0_5[2] - 44
}
local var_0_8 = var_0_6[1] - 150
local var_0_9 = {
	var_0_4[1] - 22,
	var_0_4[2] - 48
}
local var_0_10 = {
	var_0_4[1] - 120,
	60
}
local var_0_11 = {
	var_0_10[1] - var_0_1 * 2,
	var_0_4[2] - var_0_10[2] - var_0_10[2]
}
local var_0_12 = {
	var_0_10[1] - var_0_1 * 2,
	42
}
local var_0_13 = 5
local var_0_14 = {
	tab_size = var_0_10,
	tab_active_size = var_0_11,
	tab_list_entry_size = var_0_12,
	tab_list_entry_spacing = var_0_13
}
local var_0_15 = 14
local var_0_16 = {
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
		size = var_0_2,
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
			var_0_2[1] - 5,
			var_0_2[2] - 5
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
		size = var_0_4,
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
			var_0_4[1] - 44,
			var_0_4[2] - 44
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
		size = var_0_5,
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
			var_0_5[1] - 44,
			var_0_5[2] - 44
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
		size = var_0_9,
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
			var_0_9[1],
			var_0_4[2] - 44
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
			var_0_9[1],
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
			var_0_9[1],
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
		size = var_0_7,
		position = {
			-var_0_1,
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
		size = var_0_6,
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
			var_0_6[1],
			var_0_5[2] - 44
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
			var_0_6[1],
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
			var_0_6[1],
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
			var_0_8,
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
		size = var_0_7,
		position = {
			-var_0_1,
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
local var_0_17 = {
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
local var_0_18 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		-(var_0_2[1] * 0.1 + 5),
		4,
		2
	}
}
local var_0_19 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		var_0_2[1] * 0.1 + 4,
		4,
		2
	}
}
local var_0_20 = {
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

local function var_0_21(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = true
	local var_1_1 = "button_bg_01"
	local var_1_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_1)
	local var_1_3 = UIFrameSettings.button_frame_01
	local var_1_4 = var_1_3.texture_sizes.corner[1]
	local var_1_5 = "button_detail_02"
	local var_1_6 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_5).size
	local var_1_7 = "button_detail_03"
	local var_1_8 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_7).size
	local var_1_9 = 20
	local var_1_10 = 20
	local var_1_11 = {
		allow_multi_hover = true
	}
	local var_1_12 = {}

	for iter_1_0 = 1, var_0_15 do
		local var_1_13 = var_0_13

		var_1_11[iter_1_0] = {
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
				texture_id = var_1_7
			},
			frame = var_1_3.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_1_1[2] / var_1_2.size[2]
					},
					{
						arg_1_1[1] / var_1_2.size[1],
						1
					}
				},
				texture_id = var_1_1
			}
		}
		var_1_12[iter_1_0] = {
			list_member_offset = {
				0,
				-(var_0_12[2] + var_1_13),
				0
			},
			size = {
				var_0_12[1],
				var_0_12[2]
			},
			text = {
				word_wrap = false,
				upper_case = true,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					var_1_9 + var_1_10,
					0,
					14
				},
				size = {
					var_0_12[1] - var_1_9 - var_1_10 * 2,
					var_0_12[2]
				}
			},
			text_hover = {
				word_wrap = false,
				upper_case = true,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_1_9 + var_1_10,
					0,
					14
				},
				size = {
					var_0_12[1] - var_1_9 - var_1_10 * 2,
					var_0_12[2]
				}
			},
			text_selected = {
				word_wrap = false,
				upper_case = true,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_1_9 + var_1_10,
					0,
					14
				},
				size = {
					var_0_12[1] - var_1_9 - var_1_10 * 2,
					var_0_12[2]
				}
			},
			text_shadow = {
				word_wrap = false,
				upper_case = true,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_1_9 + var_1_10 + 2,
					-2,
					13
				},
				size = {
					var_0_12[1] - var_1_9 - var_1_10 * 2,
					var_0_12[2]
				}
			},
			rect = {
				masked = var_1_0,
				size = {
					var_0_12[1],
					var_0_12[2]
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
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				masked = var_1_0,
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
					var_1_9,
					0,
					10
				}
			},
			side_detail_left = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-9,
					var_0_12[2] / 2 - var_1_8[2] / 2,
					9
				},
				size = var_1_8
			},
			side_detail_right = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_0_12[1] - var_1_8[1] + 9,
					var_0_12[2] / 2 - var_1_8[2] / 2,
					9
				},
				size = var_1_8
			},
			frame = {
				masked = var_1_0,
				size = var_0_12,
				texture_size = var_1_3.texture_size,
				texture_sizes = var_1_3.texture_sizes,
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
			},
			background = {
				masked = var_1_0,
				size = var_0_12,
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
				masked = var_1_0,
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
					var_0_12[1] - var_1_4 * 2,
					var_0_12[2] - var_1_4 * 2
				}
			},
			hover_glow = {
				masked = var_1_0,
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
					var_0_12[1],
					math.min(var_0_12[2] - 5, 80)
				}
			},
			clicked_rect = {
				masked = var_1_0,
				size = var_0_12,
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
				masked = var_1_0,
				size = var_0_12,
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
			},
			glass_top = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_0_12[2] - (var_1_4 + 11),
					4
				},
				size = {
					var_0_12[1],
					11
				}
			},
			glass_bottom = {
				masked = var_1_0,
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
					var_0_12[1],
					11
				}
			},
			new_texture = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_0_12[1] - 63,
					var_0_12[2] / 2 - 12,
					12
				},
				size = {
					63,
					25
				}
			}
		}
	end

	return {
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
					content_check_function = function(arg_2_0)
						return arg_2_0.button_hotspot.disable_button
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
					content_check_function = function(arg_3_0)
						return not arg_3_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_4_0)
						return arg_4_0.button_hotspot.disable_button
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
					content_check_function = function(arg_5_0)
						return arg_5_0.new
					end
				},
				{
					texture_id = "locked",
					style_id = "locked",
					pass_type = "texture",
					content_check_function = function(arg_6_0)
						return arg_6_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "list_style",
					pass_type = "list_pass",
					content_id = "list_content",
					content_check_function = function(arg_7_0)
						return arg_7_0.active
					end,
					passes = {
						{
							style_id = "text",
							pass_type = "text",
							text_id = "text",
							content_check_function = function(arg_8_0)
								local var_8_0 = arg_8_0.button_hotspot

								return not var_8_0.is_hover and not var_8_0.is_selected
							end
						},
						{
							style_id = "text_hover",
							pass_type = "text",
							text_id = "text",
							content_check_function = function(arg_9_0)
								local var_9_0 = arg_9_0.button_hotspot

								return var_9_0.is_hover and not var_9_0.is_selected
							end
						},
						{
							style_id = "text_selected",
							pass_type = "text",
							text_id = "text",
							content_check_function = function(arg_10_0)
								return arg_10_0.button_hotspot.is_selected
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
							content_check_function = function(arg_11_0)
								local var_11_0 = arg_11_0.button_hotspot

								return var_11_0.is_hover or var_11_0.is_selected
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
							content_check_function = function(arg_12_0)
								return arg_12_0.button_hotspot.disable_button
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
							content_check_function = function(arg_13_0)
								return arg_13_0.new
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
			list_content = var_1_11,
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
				texture_id = var_1_5
			},
			button_hotspot = {},
			title_text = arg_1_2 or "n/a",
			frame = var_1_3.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_1_1[2] / var_1_2.size[2]
					},
					{
						arg_1_1[1] / var_1_2.size[1],
						1
					}
				},
				texture_id = var_1_1
			}
		},
		style = {
			list_style = {
				start_index = 1,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				num_draws = 0,
				masked = var_1_0,
				list_member_offset = {
					0,
					var_0_12[2],
					0
				},
				size = {
					var_0_12[1],
					var_0_12[2]
				},
				scenegraph_id = arg_1_3,
				item_styles = var_1_12
			},
			hotspot = {
				masked = var_1_0,
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
				masked = var_1_0,
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
				masked = var_1_0,
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
				masked = var_1_0,
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
				masked = var_1_0,
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
				masked = var_1_0,
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
			},
			title_text = {
				upper_case = true,
				word_wrap = true,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					30,
					0,
					6
				}
			},
			title_text_disabled = {
				upper_case = true,
				font_size = 24,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					30,
					0,
					6
				}
			},
			title_text_shadow = {
				upper_case = true,
				font_size = 24,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					32,
					-2,
					5
				}
			},
			frame = {
				masked = var_1_0,
				texture_size = var_1_3.texture_size,
				texture_sizes = var_1_3.texture_sizes,
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
			},
			glass_top = {
				masked = var_1_0,
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
			},
			glass_bottom = {
				masked = var_1_0,
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
			},
			side_detail_left = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-9,
					arg_1_1[2] / 2 - var_1_6[2] / 2,
					9
				},
				size = {
					var_1_6[1],
					var_1_6[2]
				}
			},
			side_detail_right = {
				masked = var_1_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_1_1[1] - var_1_6[1] + 9,
					arg_1_1[2] / 2 - var_1_6[2] / 2,
					9
				},
				size = {
					var_1_6[1],
					var_1_6[2]
				}
			},
			new_texture = {
				masked = var_1_0,
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
			},
			locked = {
				masked = var_1_0,
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
		},
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_22 = true
local var_0_23 = {
	window = UIWidgets.create_frame("window", var_0_16.window.size, "menu_frame_11", 40),
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
	right_window_frame = UIWidgets.create_frame("right_window", var_0_16.right_window.size, "menu_frame_11", 20),
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
		var_0_6[1] / 2,
		15
	}, "achievement_window_mask_bottom"),
	achievement_window_mask_top = UIWidgets.create_simple_texture("mask_rect_edge_fade", "achievement_window_mask_top"),
	exit_button = UIWidgets.create_default_button("exit_button", var_0_16.exit_button.size, nil, nil, Localize("menu_close"), 24, nil, "button_detail_04", 34, var_0_22),
	title = UIWidgets.create_simple_texture("frame_title_bg_02", "title"),
	title_bg = UIWidgets.create_background("title_bg", var_0_16.title_bg.size, "menu_frame_bg_02"),
	title_text = UIWidgets.create_simple_text(Localize("tutorial_menu_header"), "title_text", nil, nil, var_0_17),
	achievement_scrollbar = UIWidgets.create_chain_scrollbar("achievement_scrollbar", nil, var_0_16.achievement_scrollbar.size),
	category_scrollbar = UIWidgets.create_chain_scrollbar("category_scrollbar", "category_window_mask", var_0_16.category_scrollbar.size),
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
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, var_0_20),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_18),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_19),
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
					scroll_function = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
						local var_14_0 = arg_14_4.y * -1

						if IS_XB1 and GameSettingsDevelopment.allow_keyboard_mouse and not arg_14_2.is_gamepad_active then
							var_14_0 = math.sign(arg_14_4.x) * -1
						end

						local var_14_1 = arg_14_2.hotspot

						if var_14_0 ~= 0 and var_14_1.is_hover then
							arg_14_2.axis_input = var_14_0
							arg_14_2.scroll_add = var_14_0 * arg_14_2.scroll_amount
						end

						local var_14_2 = arg_14_2.scroll_add

						if var_14_2 then
							local var_14_3 = var_14_2 * (arg_14_5 * 5)
							local var_14_4 = var_14_2 - var_14_3

							if math.abs(var_14_4) > 0 then
								arg_14_2.scroll_add = var_14_4
							else
								arg_14_2.scroll_add = nil
							end

							local var_14_5 = arg_14_2.scroll_value

							arg_14_2.scroll_value = math.clamp(var_14_5 + var_14_3, 0, 1)
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

local function var_0_24(arg_15_0)
	local var_15_0 = {}

	for iter_15_0 = 1, arg_15_0 + 1 do
		local var_15_1 = iter_15_0 == 1
		local var_15_2 = "category_tab_" .. iter_15_0
		local var_15_3 = "category_tab_" .. iter_15_0 .. "_list"
		local var_15_4 = "category_tab_" .. iter_15_0 - 1 .. "_list"

		var_0_16[var_15_2] = {
			horizontal_alignment = "center",
			parent = var_15_1 and "category_root" or var_15_4,
			vertical_alignment = var_15_1 and "top" or "bottom",
			size = var_0_10,
			position = {
				var_15_1 and -15 or 0,
				var_15_1 and -20 or -(var_0_10[2] + var_0_13),
				0
			}
		}
		var_0_16[var_15_3] = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			parent = var_15_2,
			size = {
				var_0_10[1],
				0
			},
			position = {
				0,
				-(var_0_10[2] + var_0_13),
				0
			}
		}
		var_15_0[iter_15_0] = var_0_21(var_15_2, var_0_10, "n/a", var_15_3)
	end

	return var_15_0
end

local var_0_25 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				arg_16_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				arg_17_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				arg_19_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				arg_20_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				return
			end
		}
	}
}
local var_0_26 = {
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

local function var_0_27(arg_22_0)
	local var_22_0, var_22_1, var_22_2 = string.find(arg_22_0, "^<(/?)kw")

	if not var_22_0 then
		return arg_22_0
	end

	return var_22_2 and "{#reset()}" or "{#color(255,193,91)}"
end

local function var_0_28(arg_23_0, arg_23_1)
	return {
		scenegraph_id = arg_23_0.scenegraph_id,
		element = {
			passes = {}
		},
		content = {
			size = arg_23_1.size
		},
		style = {}
	}
end

local function var_0_29(arg_24_0, arg_24_1)
	local var_24_0 = {
		var_0_8,
		0
	}
	local var_24_1 = Localize(arg_24_1.text or "n/a")

	if arg_24_1.inputs then
		local var_24_2 = {}

		for iter_24_0, iter_24_1 in ipairs(arg_24_1.inputs) do
			local var_24_3 = "Player"
			local var_24_4 = iter_24_1

			var_24_2[iter_24_0] = string.format("$KEY;%s__%s: ", var_24_3, var_24_4)
		end

		var_24_1 = string.format(var_24_1, unpack(var_24_2))
	end

	local var_24_5 = string.gsub(var_24_1, "%b<>", var_0_27)
	local var_24_6 = {
		vertical_alignment = "top",
		word_wrap = true,
		localize = false,
		horizontal_alignment = "center",
		font_size = 24,
		font_type = "hell_shark_masked",
		size = var_24_0,
		text_color = Colors.get_color_table_with_alpha("font_default", 255)
	}

	if arg_24_1.style then
		table.merge(var_24_6, arg_24_1.style)
	end

	local var_24_7
	local var_24_8
	local var_24_9

	if var_24_6.use_shadow then
		var_24_7 = {
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text_shadow"
		}
		var_24_8 = string.gsub(var_24_5, "%b{}", "")
		var_24_9 = table.shallow_copy(var_24_6)
		var_24_9.offset = {
			2,
			2,
			-1
		}
		var_24_9.skip_button_rendering = true
		var_24_9.text_color = {
			var_24_6.text_color[1],
			0,
			0,
			0
		}

		if var_24_6.shadow_color then
			Colors.copy_no_alpha_to(var_24_9.text_color, var_24_6.shadow_color)
		end
	end

	var_24_0[2] = UIUtils.get_text_height(arg_24_0.ui_renderer, var_24_0, var_24_6, var_24_5)

	return {
		scenegraph_id = arg_24_0.scenegraph_id,
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				var_24_7
			}
		},
		content = {
			text = var_24_5,
			text_shadow = var_24_8,
			size = var_24_0,
			padding = arg_24_1.padding or 25
		},
		style = {
			text = var_24_6,
			text_shadow = var_24_9
		}
	}
end

local function var_0_30(arg_25_0, arg_25_1)
	local var_25_0 = {
		674,
		380
	}
	local var_25_1 = 0.5 * (var_0_8 - var_25_0[1])
	local var_25_2 = UIFrameSettings.menu_frame_06
	local var_25_3 = UIFrameSettings.shadow_frame_02
	local var_25_4 = -1 * var_25_3.texture_sizes.horizontal[2]
	local var_25_5 = {
		var_25_4,
		var_25_4
	}

	return {
		scenegraph_id = arg_25_0.scenegraph_id,
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture",
					texture_id = "texture",
					content_check_function = function(arg_26_0)
						return arg_26_0.texture
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "shadow",
					texture_id = "shadow",
					content_check_function = function(arg_27_0)
						return arg_27_0.texture
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame",
					content_check_function = function(arg_28_0)
						return arg_28_0.texture
					end
				},
				{
					style_id = "loading_icon",
					texture_id = "loading_icon",
					pass_type = "rotated_texture",
					content_check_function = function(arg_29_0)
						return not arg_29_0.texture
					end,
					content_change_function = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
						local var_30_0 = (arg_30_0.loading_progress + arg_30_3) % 1

						arg_30_1.angle = 2^math.smoothstep(var_30_0, 0, 1) * math.tau
						arg_30_0.loading_progress = var_30_0
					end
				}
			}
		},
		content = {
			loading_progress = 0,
			loading_icon = "loot_loading",
			size = var_25_0,
			frame = var_25_2.texture,
			shadow = var_25_3.texture,
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
				texture_size = var_25_0
			},
			shadow = {
				masked = true,
				offset = {
					var_25_1,
					0,
					0
				},
				area_size = var_25_0,
				frame_margins = var_25_5,
				texture_size = var_25_3.texture_size,
				texture_sizes = var_25_3.texture_sizes,
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
					var_25_1,
					0,
					1
				},
				area_size = var_25_0,
				texture_size = var_25_2.texture_size,
				texture_sizes = var_25_2.texture_sizes,
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
				size = var_25_0,
				offset = {
					var_25_1 - 40,
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
				size = var_25_0,
				offset = {
					var_25_1 + 50,
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
					var_25_1,
					0,
					0
				},
				size = var_25_0,
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

local function var_0_31(arg_31_0, arg_31_1)
	local var_31_0 = {
		852,
		480
	}
	local var_31_1 = 0.5 * (var_0_8 - var_31_0[1])
	local var_31_2 = UIFrameSettings.menu_frame_06
	local var_31_3 = UIFrameSettings.shadow_frame_02
	local var_31_4 = -1 * var_31_3.texture_sizes.horizontal[2]
	local var_31_5 = {
		var_31_4,
		var_31_4
	}
	local var_31_6 = "video/tutorial_videos/" .. arg_31_1.path
	local var_31_7 = arg_31_0.layout:create_video_player(var_31_6)

	return {
		scenegraph_id = arg_31_0.scenegraph_id,
		element = {
			passes = {
				{
					style_id = "video",
					pass_type = "video",
					content_check_function = function(arg_32_0)
						return arg_32_0.video_player_reference
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "shadow",
					texture_id = "shadow",
					content_check_function = function(arg_33_0)
						return arg_33_0.video_player_reference
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame",
					content_check_function = function(arg_34_0)
						return arg_34_0.video_player_reference
					end
				}
			}
		},
		content = {
			loading_progress = 0,
			loading_icon = "loot_loading",
			size = var_31_0,
			material_name = arg_31_1.path,
			video_player_reference = var_31_7,
			frame = var_31_2.texture,
			shadow = var_31_3.texture,
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
				size = var_31_0,
				offset = {
					var_31_1,
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
					var_31_1,
					0,
					0
				},
				area_size = var_31_0,
				frame_margins = var_31_5,
				texture_size = var_31_3.texture_size,
				texture_sizes = var_31_3.texture_sizes,
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
					var_31_1,
					0,
					1
				},
				size = var_31_0,
				texture_size = var_31_2.texture_size,
				texture_sizes = var_31_2.texture_sizes,
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
	generic_input_actions = var_0_26,
	category_tab_info = var_0_14,
	achievement_window_size = var_0_6,
	achievement_scrollbar_size = var_0_7,
	content_blueprints = {
		spacing = var_0_28,
		text = var_0_29,
		image = var_0_30,
		video = var_0_31
	},
	widgets = var_0_23,
	create_category_tab_widgets_func = var_0_24,
	scenegraph_definition = var_0_16,
	animation_definitions = var_0_25,
	console_cursor_definition = UIWidgets.create_console_cursor("console_cursor")
}
