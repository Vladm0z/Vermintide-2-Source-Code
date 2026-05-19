-- chunkname: @scripts/ui/views/hero_view/windows/store/definitions/store_window_item_preview_definitions.lua

local var_0_0 = UISettings.console_menu_scenegraphs
local var_0_1 = {
	800,
	600
}
local var_0_2 = {
	800,
	220
}
local var_0_3 = {
	16,
	var_0_1[2] + 100
}
local var_0_4 = {
	screen = var_0_0.screen,
	background = {
		scale = "fit_height",
		horizontal_alignment = "right",
		size = {
			960,
			1080
		},
		position = {
			0,
			0,
			UILayer.default + 100
		}
	},
	pivot = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "right",
		size = {
			960,
			740
		},
		position = {
			0,
			-190,
			0
		}
	},
	viewport = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "right",
		size = {
			960,
			732
		},
		position = {
			0,
			0,
			1
		}
	},
	smoke_effect = {
		vertical_alignment = "bottom",
		parent = "viewport",
		horizontal_alignment = "center",
		size = {
			700,
			100
		},
		position = {
			0,
			0,
			0
		}
	},
	list_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = var_0_1,
		position = {
			-130,
			-255,
			10
		}
	},
	list = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "right",
		size = var_0_1,
		position = {
			0,
			-var_0_1[2],
			0
		}
	},
	list_scrollbar = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "right",
		size = var_0_3,
		position = {
			58,
			40,
			1
		}
	},
	item_root = {
		vertical_alignment = "top",
		parent = "list",
		horizontal_alignment = "left",
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
	list_background = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "left",
		size = {
			var_0_1[1] + 62,
			var_0_1[2] + 130
		},
		position = {
			-10,
			55,
			0
		}
	},
	list_detail_top_left = {
		vertical_alignment = "top",
		parent = "list_scrollbar",
		horizontal_alignment = "right",
		size = {
			157,
			97
		},
		position = {
			45,
			60,
			2
		}
	},
	list_detail_bottom_left = {
		vertical_alignment = "bottom",
		parent = "list_scrollbar",
		horizontal_alignment = "right",
		size = {
			157,
			97
		},
		position = {
			45,
			-60,
			2
		}
	},
	list_detail_top_center = {
		vertical_alignment = "top",
		parent = "list_detail_top_left",
		horizontal_alignment = "right",
		size = {
			750,
			97
		},
		position = {
			-157,
			0,
			0
		}
	},
	list_detail_bottom_center = {
		vertical_alignment = "bottom",
		parent = "list_detail_bottom_left",
		horizontal_alignment = "right",
		size = {
			750,
			97
		},
		position = {
			-157,
			0,
			0
		}
	},
	list_detail_top_right = {
		vertical_alignment = "top",
		parent = "list_detail_top_center",
		horizontal_alignment = "left",
		size = {
			23,
			97
		},
		position = {
			-23,
			0,
			0
		}
	},
	list_detail_bottom_right = {
		vertical_alignment = "bottom",
		parent = "list_detail_bottom_center",
		horizontal_alignment = "left",
		size = {
			23,
			97
		},
		position = {
			-23,
			0,
			0
		}
	},
	loading_icon = {
		vertical_alignment = "center",
		parent = "viewport",
		horizontal_alignment = "center",
		size = {
			150,
			150
		},
		position = {
			0,
			0,
			10
		}
	},
	unlock_button = {
		vertical_alignment = "bottom",
		parent = "viewport",
		horizontal_alignment = "center",
		size = {
			460,
			68
		},
		position = {
			20,
			-37,
			15
		}
	},
	unlock_button_edge = {
		vertical_alignment = "bottom",
		parent = "viewport",
		horizontal_alignment = "center",
		size = {
			826,
			97
		},
		position = {
			20,
			-45,
			0
		}
	},
	unlock_button_edge_left = {
		vertical_alignment = "center",
		parent = "unlock_button_edge",
		horizontal_alignment = "left",
		size = {
			23,
			97
		},
		position = {
			-3,
			0,
			1
		}
	},
	unlock_button_edge_right = {
		vertical_alignment = "center",
		parent = "unlock_button_edge",
		horizontal_alignment = "right",
		size = {
			23,
			97
		},
		position = {
			3,
			0,
			1
		}
	},
	disclaimer_text = {
		vertical_alignment = "bottom",
		parent = "unlock_button",
		horizontal_alignment = "center",
		size = {
			700,
			60
		},
		position = {
			0,
			-55,
			10
		}
	},
	disclaimer_divider = {
		vertical_alignment = "center",
		parent = "disclaimer_text",
		horizontal_alignment = "center",
		size = {
			13,
			13
		},
		position = {
			0,
			0,
			0
		}
	},
	title_text = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "right",
		size = {
			700,
			60
		},
		position = {
			-190,
			735,
			8
		}
	},
	sub_title_text = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			700,
			30
		},
		position = {
			0,
			-45,
			1
		}
	},
	career_title_text = {
		vertical_alignment = "bottom",
		parent = "sub_title_text",
		horizontal_alignment = "center",
		size = {
			700,
			45
		},
		position = {
			0,
			-40,
			1
		}
	},
	details_button_bg = {
		vertical_alignment = "bottom",
		parent = "pivot",
		horizontal_alignment = "right",
		size = {
			146,
			141
		},
		position = {
			-20,
			664,
			1
		}
	},
	details_button = {
		vertical_alignment = "center",
		parent = "details_button_bg",
		horizontal_alignment = "center",
		size = {
			89,
			93
		},
		position = {
			0,
			0,
			1
		}
	},
	title_edge = {
		vertical_alignment = "center",
		parent = "details_button_bg",
		horizontal_alignment = "right",
		size = {
			700,
			97
		},
		position = {
			-146,
			-8,
			1
		}
	},
	title_edge_detail = {
		vertical_alignment = "center",
		parent = "title_edge",
		horizontal_alignment = "left",
		size = {
			23,
			97
		},
		position = {
			-23,
			0,
			0
		}
	},
	details_disabled = {
		vertical_alignment = "center",
		parent = "details_button_bg",
		horizontal_alignment = "center",
		size = {
			93,
			93
		},
		position = {
			0,
			0,
			1
		}
	}
}
local var_0_5 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 64,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_6 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 24,
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
local var_0_7 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 24,
	horizontal_alignment = "right",
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
local var_0_8 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 24,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_9 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 20,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_10 = {
	loading_icon = {
		scenegraph_id = "loading_icon",
		element = {
			passes = {
				{
					style_id = "texture_id",
					pass_type = "rotated_texture",
					texture_id = "texture_id",
					content_change_function = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
						local var_1_0 = ((arg_1_1.progress or 0) + arg_1_3) % 1

						arg_1_1.angle = math.pow(2, math.smoothstep(var_1_0, 0, 1)) * (math.pi * 2)
						arg_1_1.progress = var_1_0
					end
				}
			}
		},
		content = {
			texture_id = "loot_loading"
		},
		style = {
			texture_id = {
				angle = 0,
				pivot = {
					75,
					75
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
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
}

local function var_0_11(arg_2_0, arg_2_1)
	return {
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				}
			}
		},
		content = {
			title_text = "n/a",
			background = "rect_masked",
			description_text = "n/a",
			size = arg_2_1
		},
		style = {
			background = {
				masked = true,
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
			title_text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 32,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark_header_masked",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					30,
					arg_2_1[2] - 170,
					2
				},
				size = {
					arg_2_1[1] - 60,
					40
				}
			},
			title_text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 32,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark_header_masked",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					32,
					arg_2_1[2] - 170 - 2,
					1
				},
				size = {
					arg_2_1[1] - 60,
					40
				}
			},
			description_text = {
				word_wrap = true,
				horizontal_alignment = "left",
				localize = false,
				font_size = 18,
				vertical_alignment = "top",
				font_type = "hell_shark_masked",
				text_color = {
					255,
					10,
					10,
					10
				},
				offset = {
					30,
					24,
					2
				},
				size = {
					arg_2_1[1] - 60,
					165
				}
			},
			description_text_shadow = {
				word_wrap = true,
				horizontal_alignment = "left",
				localize = false,
				font_size = 18,
				vertical_alignment = "top",
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					32,
					22,
					1
				},
				size = {
					arg_2_1[1] - 60,
					165
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_2_0
	}
end

local function var_0_12(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = UIFrameSettings.frame_outer_glow_04_big.texture_sizes.horizontal[2]
	local var_3_1 = {
		passes = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				style_id = "list_hotspot",
				pass_type = "hotspot",
				content_id = "list_hotspot"
			},
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_texture"
			},
			{
				pass_type = "texture",
				style_id = "mask_top",
				texture_id = "mask_edge"
			},
			{
				pass_type = "rotated_texture",
				style_id = "mask_bottom",
				texture_id = "mask_edge"
			}
		}
	}
	local var_3_2 = {
		mask_edge = "mask_rect_edge_fade",
		mask_texture = "mask_rect",
		list_hotspot = {},
		button_hotspot = {},
		scrollbar = {
			scroll_amount = 0.1,
			percentage = 0.1,
			scroll_value = 1
		}
	}
	local var_3_3 = {
		hotspot = {
			size = {
				arg_3_2[1],
				arg_3_2[2]
			},
			offset = {
				0,
				0,
				0
			}
		},
		list_hotspot = {
			size = {
				arg_3_2[1] + var_3_0 * 2,
				arg_3_2[2] + var_3_0 * 2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-var_3_0,
				-var_3_0,
				0
			}
		},
		mask = {
			size = {
				arg_3_2[1] + var_3_0 * 2,
				arg_3_2[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-var_3_0,
				0,
				0
			}
		},
		mask_top = {
			size = {
				arg_3_2[1] + var_3_0 * 2,
				var_3_0
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-var_3_0,
				arg_3_2[2],
				0
			}
		},
		mask_bottom = {
			size = {
				arg_3_2[1] + var_3_0 * 2,
				var_3_0
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-var_3_0,
				-var_3_0,
				0
			},
			angle = math.pi,
			pivot = {
				(arg_3_2[1] + var_3_0 * 2) / 2,
				var_3_0 / 2
			}
		}
	}

	return {
		element = var_3_1,
		content = var_3_2,
		style = var_3_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_3_0
	}
end

local var_0_13 = {}
local var_0_14 = {
	unlock_button_edge = UIWidgets.create_tiled_texture("unlock_button_edge", "divider_skull_middle_down", {
		64,
		97
	}),
	unlock_button_edge_left = UIWidgets.create_simple_uv_texture("divider_skull_right", {
		{
			1,
			1
		},
		{
			0,
			0
		}
	}, "unlock_button_edge_left"),
	unlock_button_edge_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "unlock_button_edge_right"),
	details_button_bg = UIWidgets.create_simple_texture("button_detail_10", "details_button_bg"),
	title_edge = UIWidgets.create_tiled_texture("title_edge", "divider_skull_middle", {
		64,
		97
	}),
	title_edge_detail = UIWidgets.create_simple_uv_texture("divider_skull_right", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "title_edge_detail"),
	details_button = {
		scenegraph_id = "details_button",
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "normal",
					texture_id = "normal",
					content_check_function = function(arg_4_0)
						return not arg_4_0.button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "normal_glow",
					texture_id = "normal_glow",
					content_check_function = function(arg_5_0)
						return not arg_5_0.button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "expanded",
					texture_id = "expanded",
					content_check_function = function(arg_6_0)
						return arg_6_0.button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "expanded_glow",
					texture_id = "expanded_glow",
					content_check_function = function(arg_7_0)
						return arg_7_0.button_hotspot.is_selected
					end
				}
			}
		},
		content = {
			normal_glow = "store_info_expand_on",
			expanded = "store_info_contract_off",
			expanded_glow = "store_info_contract_on",
			normal = "store_info_expand_off",
			button_hotspot = {}
		},
		style = {
			normal = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			normal_glow = {
				color = {
					0,
					255,
					255,
					255
				}
			},
			expanded = {
				color = {
					255,
					255,
					255,
					255
				}
			},
			expanded_glow = {
				color = {
					0,
					255,
					255,
					255
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
}
local var_0_15 = false
local var_0_16 = {
	smoke_effect = UIWidgets.create_simple_uv_texture("item_preview_smoke_01", {
		{
			0,
			0
		},
		{
			1,
			0.5
		}
	}, "smoke_effect", nil, nil, Colors.get_color_table_with_alpha("gold", 255)),
	disclaimer_divider = UIWidgets.create_simple_texture("tooltip_marker_gold", "disclaimer_divider"),
	disclaimer_text = UIWidgets.create_simple_text("Headgear is sold separatly", "disclaimer_text", nil, nil, var_0_9),
	expire_timer_text = UIWidgets.create_simple_text("", "disclaimer_text", nil, nil, var_0_9),
	title_text = UIWidgets.create_simple_text("", "title_text", nil, nil, var_0_5),
	sub_title_text = UIWidgets.create_simple_text("", "sub_title_text", nil, nil, var_0_6),
	type_title_text = UIWidgets.create_simple_text("", "sub_title_text", nil, nil, var_0_7),
	career_title_text = UIWidgets.create_simple_text("", "career_title_text", nil, nil, var_0_8),
	unlock_button = UIWidgets.create_store_purchase_button("unlock_button", var_0_4.unlock_button.size, not IS_PS4 and Localize("menu_store_purchase_button_unlock") or "", 32, var_0_15),
	viewport_button = UIWidgets.create_simple_hotspot("viewport")
}
local var_0_17 = {
	255,
	0,
	0,
	0
}
local var_0_18 = "shadow_frame_02"
local var_0_19 = UIFrameSettings[var_0_18].texture_sizes.corner
local var_0_20 = {
	-var_0_19[1],
	-var_0_19[2]
}
local var_0_21 = {
	list = var_0_12("list_window", "list", var_0_1, var_0_2),
	list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "list_window", var_0_4.list_scrollbar.size, "gold", nil, true),
	list_detail_top_left = UIWidgets.create_simple_uv_texture("divider_skull_left", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "list_detail_top_left"),
	list_detail_bottom_left = UIWidgets.create_simple_uv_texture("divider_skull_left", {
		{
			1,
			1
		},
		{
			0,
			0
		}
	}, "list_detail_bottom_left"),
	list_detail_top_center = UIWidgets.create_tiled_texture("list_detail_top_center", "divider_skull_middle", {
		64,
		97
	}),
	list_detail_bottom_center = UIWidgets.create_tiled_texture("list_detail_bottom_center", "divider_skull_middle_down", {
		64,
		97
	}),
	list_detail_top_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "list_detail_top_right"),
	list_detail_bottom_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
		{
			1,
			1
		},
		{
			0,
			0
		}
	}, "list_detail_bottom_right")
}
local var_0_22 = {
	list_background = UIWidgets.create_simple_rect("list_background", var_0_17),
	list_background_frame = UIWidgets.create_frame("list_background", var_0_4.list_background.size, "shadow_frame_01", 0, var_0_17, var_0_20)
}
local var_0_23 = {
	on_enter = {
		{
			name = "delay",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				return
			end,
			update = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				return
			end,
			on_complete = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end
		},
		{
			name = "fade_in",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				arg_11_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				local var_12_0 = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.alpha_multiplier = var_12_0
			end,
			on_complete = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		}
	},
	expand = {
		{
			name = "move",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				return
			end,
			update = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				local var_15_0 = math.easeOutCubic(arg_15_3)
				local var_15_1 = 255
				local var_15_2 = 130
				local var_15_3 = math.floor(var_15_1 * var_15_0)
				local var_15_4 = math.floor(var_15_2 * var_15_0)
				local var_15_5 = arg_15_1.background.size

				arg_15_0.background.size[1] = var_15_5[1] + var_15_3

				local var_15_6 = arg_15_1.viewport.size
				local var_15_7 = arg_15_1.viewport.position

				arg_15_0.viewport.size[1] = var_15_6[1] + var_15_3
				arg_15_0.viewport.size[2] = var_15_6[2] + var_15_4

				local var_15_8 = 255 - 255 * var_15_0
				local var_15_9 = arg_15_2.title_text

				var_15_9.style.text.text_color[1] = var_15_8
				var_15_9.style.text_shadow.text_color[1] = var_15_8

				local var_15_10 = arg_15_2.sub_title_text

				var_15_10.style.text.text_color[1] = var_15_8
				var_15_10.style.text_shadow.text_color[1] = var_15_8

				local var_15_11 = arg_15_2.type_title_text

				var_15_11.style.text.text_color[1] = var_15_8
				var_15_11.style.text_shadow.text_color[1] = var_15_8

				local var_15_12 = arg_15_2.career_title_text

				var_15_12.style.text.text_color[1] = var_15_8
				var_15_12.style.text_shadow.text_color[1] = var_15_8
			end,
			on_complete = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end
		}
	},
	collapse = {
		{
			name = "move",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end,
			update = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				local var_18_0 = math.easeOutCubic(arg_18_3)
				local var_18_1 = 255
				local var_18_2 = 130
				local var_18_3 = math.floor(var_18_1 * var_18_0)
				local var_18_4 = math.floor(var_18_2 * var_18_0)
				local var_18_5 = arg_18_1.background.size

				arg_18_0.background.size[1] = var_18_5[1] + var_18_1 - var_18_3

				local var_18_6 = arg_18_1.viewport.size
				local var_18_7 = arg_18_1.viewport.position

				arg_18_0.viewport.size[1] = var_18_6[1] + var_18_1 - var_18_3
				arg_18_0.viewport.size[2] = var_18_6[2] + var_18_2 - var_18_4

				local var_18_8 = 255 * var_18_0
				local var_18_9 = arg_18_2.title_text

				var_18_9.style.text.text_color[1] = var_18_8
				var_18_9.style.text_shadow.text_color[1] = var_18_8

				local var_18_10 = arg_18_2.sub_title_text

				var_18_10.style.text.text_color[1] = var_18_8
				var_18_10.style.text_shadow.text_color[1] = var_18_8

				local var_18_11 = arg_18_2.type_title_text

				var_18_11.style.text.text_color[1] = var_18_8
				var_18_11.style.text_shadow.text_color[1] = var_18_8

				local var_18_12 = arg_18_2.career_title_text

				var_18_12.style.text.text_color[1] = var_18_8
				var_18_12.style.text_shadow.text_color[1] = var_18_8
			end,
			on_complete = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end
		}
	}
}
local var_0_24 = {
	default = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "buy_now"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_back"
		}
	},
	item_preview_purchase = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "menu_store_purchase_button_unlock"
		},
		{
			input_action = "special_1",
			priority = 4,
			description_text = "input_description_toggle_hero_details",
			content_check_function = function()
				return IS_PS4 or IS_XB1
			end
		},
		{
			input_action = "right_stick",
			priority = 5,
			description_text = "input_description_rotate",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 6,
			description_text = "input_description_close"
		}
	},
	item_preview_purchase_no_details = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "menu_store_purchase_button_unlock"
		},
		{
			input_action = "right_stick",
			priority = 5,
			description_text = "input_description_rotate",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 6,
			description_text = "input_description_back"
		}
	},
	item_preview_owned = {
		{
			input_action = "special_1",
			priority = 4,
			description_text = "input_description_toggle_hero_details"
		},
		{
			input_action = "right_stick",
			priority = 5,
			description_text = "input_description_rotate",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 6,
			description_text = "input_description_back"
		}
	},
	item_preview_owned_no_details = {
		{
			input_action = "right_stick",
			priority = 5,
			description_text = "input_description_rotate",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 6,
			description_text = "input_description_back"
		}
	},
	dlc_preview_purchase = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = IS_WINDOWS and "interaction_action_unlock" or "dlc1_4_input_description_storepage"
		},
		{
			input_action = "right_stick",
			priority = 5,
			description_text = "input_description_scroll_details",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 6,
			description_text = "input_description_close"
		}
	},
	dlc_preview_owned = {
		{
			input_action = "right_stick",
			priority = 5,
			description_text = "input_description_scroll_details",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 6,
			description_text = "input_description_back"
		}
	},
	dlc_bundle_purchase = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = IS_WINDOWS and "interaction_action_unlock" or "dlc1_4_input_description_storepage"
		},
		{
			input_action = "special_1",
			priority = 4,
			description_text = "input_description_view_content"
		},
		{
			input_action = "right_stick",
			priority = 5,
			description_text = "input_description_scroll_details",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 6,
			description_text = "input_description_back"
		}
	}
}

return {
	generic_input_actions = var_0_24,
	create_dlc_entry_definition = var_0_11,
	item_widgets = var_0_14,
	top_widgets = var_0_16,
	bottom_widgets = var_0_13,
	dlc_top_widgets = var_0_21,
	dlc_bottom_widgets = var_0_22,
	scenegraph_definition = var_0_4,
	animation_definitions = var_0_23,
	loading_widgets = var_0_10
}
