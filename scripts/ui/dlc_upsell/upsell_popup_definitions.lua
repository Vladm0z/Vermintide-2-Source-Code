-- chunkname: @scripts/ui/dlc_upsell/upsell_popup_definitions.lua

local num = 1920
local num_2 = 1080
local num_3 = 50
local num_4 = 455
local num_5 = 636
local num_6 = num_4 - num_3 * 2
local tbl = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.item_display_popup
		},
		size = {
			num,
			num_2
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			num_4,
			num_5
		}
	},
	window_top_detail = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			6
		},
		size = {
			45,
			12
		}
	},
	title = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			-30,
			1
		},
		size = {
			num_6,
			60
		}
	},
	body = {
		vertical_alignment = "top",
		parent = "title",
		horizontal_alignment = "center",
		position = {
			0,
			-60,
			0
		},
		size = {
			num_6,
			380
		}
	},
	store_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			50,
			10
		},
		size = {
			320,
			76
		}
	},
	ok_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			-20,
			10
		},
		size = {
			160,
			50
		}
	}
}
local tbl_2 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 32,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_table("cheeseburger"),
	offset = {
		0,
		0,
		2
	}
}
local tbl_3 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 20,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_table("font_default"),
	offset = {
		0,
		0,
		2
	}
}

function create_frameless_button(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9, arg_1_10)
	-- function 1
	arg_1_2 = arg_1_2 or "button_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_1_2)
	local flag = arg_1_8 or "button_detail_01"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(flag).size
	local flag_2 = arg_1_4 or 24
	local flag_3 = arg_1_5 or "hell_shark"
	local flag_4 = arg_1_7 or "font_button_normal"
	local flag_5 = arg_1_6 == nil or arg_1_6
	local flag_6 = arg_1_9 or 9

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
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
					pass_type = "rect",
					style_id = "clicked_rect"
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
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
				}
			}
		},
		content = {
			glass = "button_glass_02",
			hover_glow = "button_state_default",
			background_fade = "button_bg_fade",
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
				texture_id = flag
			},
			button_hotspot = {},
			title_text = arg_1_3 or "n/a",
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
				texture_id = arg_1_2
			},
			disable_with_gamepad = arg_1_10
		},
		style = {
			background = {
				color = {
					255,
					150,
					150,
					150
				},
				offset = {
					0,
					4,
					0
				},
				size = {
					arg_1_1[1],
					arg_1_1[2] - 8
				}
			},
			background_fade = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					0,
					4,
					2
				},
				size = {
					arg_1_1[1],
					arg_1_1[2] - 8
				}
			},
			hover_glow = {
				color = {
					0,
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
					math.min(arg_1_1[2] - 5, 80)
				}
			},
			clicked_rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					4,
					7
				},
				size = {
					arg_1_1[1],
					arg_1_1[2] - 8
				}
			},
			disabled_rect = {
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
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				upper_case = flag_5,
				font_size = flag_2,
				font_type = flag_3,
				text_color = Colors.get_color_table_with_alpha(flag_4, 255),
				default_text_color = Colors.get_color_table_with_alpha(flag_4, 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_1_1[1] - 40,
					arg_1_1[2]
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_disabled = {
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				upper_case = flag_5,
				font_size = flag_2,
				font_type = flag_3,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				size = {
					arg_1_1[1] - 40,
					arg_1_1[2]
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_shadow = {
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				upper_case = flag_5,
				font_size = flag_2,
				font_type = flag_3,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					arg_1_1[1] - 40,
					arg_1_1[2]
				},
				offset = {
					22,
					-2,
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
					arg_1_1[2] - 16,
					4
				},
				size = {
					arg_1_1[1],
					11
				}
			},
			glass_bottom = {
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					0,
					-4,
					4
				},
				size = {
					arg_1_1[1],
					11
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
					-flag_6,
					arg_1_1[2] / 2 - size[2] / 2,
					9
				},
				size = {
					size[1],
					size[2]
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
					arg_1_1[1] - size[1] + flag_6,
					arg_1_1[2] / 2 - size[2] / 2,
					9
				},
				size = {
					size[1],
					size[2]
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

local flag = true
local tbl_4 = {
	window_background = UIWidgets.create_simple_texture("wom_upsell_popup_bg", "window"),
	window_top_detail = UIWidgets.create_simple_texture("tab_selection_01_bottom", "window_top_detail"),
	window_frame = UIWidgets.create_frame("window", tbl.window.size, "menu_frame_12_gold", 5),
	screen_background = UIWidgets.create_simple_rect("screen", {
		150,
		0,
		0,
		0
	}),
	title_text = UIWidgets.create_simple_text("menu_weave_area_no_wom_title", "title", nil, nil, tbl_2),
	body_text = UIWidgets.create_simple_text("menu_weave_area_no_wom_body", "body", nil, nil, tbl_3),
	ok_button = create_frameless_button("ok_button", tbl.ok_button.size, nil, "", nil, nil, nil, nil, "button_detail_03_gold", nil, flag),
	store_button = create_frameless_button("store_button", tbl.store_button.size, nil, "", nil, "hell_shark_header", false, "white", "button_detail_01_gold", nil, flag)
}
local tbl_5 = {
	transition_enter = {
		{
			name = "fade_in",
			duration = 0.2,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				arg_5_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				arg_6_4.render_settings.alpha_multiplier = math.easeOutCubic(arg_6_3)
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end
		}
	}
}
local tbl_6 = {
	default = {
		{
			input_action = "back",
			priority = 2,
			description_text = "input_description_back"
		}
	}
}

return {
	scenegraph_definition = tbl,
	widget_definitions = tbl_4,
	animation_definitions = tbl_5,
	generic_input_actions = tbl_6
}
