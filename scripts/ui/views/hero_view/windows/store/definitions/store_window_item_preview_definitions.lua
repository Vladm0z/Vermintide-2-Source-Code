-- chunkname: @scripts/ui/views/hero_view/windows/store/definitions/store_window_item_preview_definitions.lua

local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl = {
	800,
	600
}
local tbl_2 = {
	800,
	220
}
local tbl_3 = {
	16,
	tbl[2] + 100
}
local tbl_4 = {
	screen = console_menu_scenegraphs.screen,
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
		size = tbl,
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
		size = tbl,
		position = {
			0,
			-tbl[2],
			0
		}
	},
	list_scrollbar = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "right",
		size = tbl_3,
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
			tbl[1] + 62,
			tbl[2] + 130
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
local tbl_5 = {
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
local tbl_6 = {
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
local tbl_7 = {
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
local tbl_8 = {
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
local tbl_9 = {
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
local tbl_10 = {
	loading_icon = {
		scenegraph_id = "loading_icon",
		element = {
			passes = {
				{
					style_id = "texture_id",
					pass_type = "rotated_texture",
					texture_id = "texture_id",
					content_change_function = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
						-- function 1
						local progress = arg_1_1.progress

						progress = progress or 0

						local num = (progress + arg_1_3) % 1

						arg_1_1.angle = math.pow(2, math.smoothstep(num, 0, 1)) * (math.pi * 2)
						arg_1_1.progress = num
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

local function fn(arg_2_0, arg_2_1)
	-- function 2
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

local function fn_2(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local var_3_0 = UIFrameSettings.frame_outer_glow_04_big.texture_sizes.horizontal[2]
	local tbl = {
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
	local tbl_2 = {
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
	local tbl_3 = {
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
		element = tbl,
		content = tbl_2,
		style = tbl_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_3_0
	}
end

local tbl_11 = {}
local tbl_12 = {
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
					content_check_function = function (self)
						-- function 4
						return not self.button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "normal_glow",
					texture_id = "normal_glow",
					content_check_function = function (self)
						-- function 5
						return not self.button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "expanded",
					texture_id = "expanded",
					content_check_function = function (self)
						-- function 6
						return self.button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "expanded_glow",
					texture_id = "expanded_glow",
					content_check_function = function (self)
						-- function 7
						return self.button_hotspot.is_selected
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
local flag = false
local tbl_13 = {
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
	disclaimer_text = UIWidgets.create_simple_text("Headgear is sold separatly", "disclaimer_text", nil, nil, tbl_9),
	expire_timer_text = UIWidgets.create_simple_text("", "disclaimer_text", nil, nil, tbl_9),
	title_text = UIWidgets.create_simple_text("", "title_text", nil, nil, tbl_5),
	sub_title_text = UIWidgets.create_simple_text("", "sub_title_text", nil, nil, tbl_6),
	type_title_text = UIWidgets.create_simple_text("", "sub_title_text", nil, nil, tbl_7),
	career_title_text = UIWidgets.create_simple_text("", "career_title_text", nil, nil, tbl_8)
}
local create_store_purchase_button = UIWidgets.create_store_purchase_button
local str = "unlock_button"
local size = tbl_4.unlock_button.size
local var_0_20

if not IS_PS4 then
	var_0_20 = Localize("menu_store_purchase_button_unlock")

	if not var_0_20 then
		-- Nothing
	end
end

var_0_20 = ""

::label_0_0::

tbl_13.unlock_button = create_store_purchase_button(str, size, var_0_20, 32, flag)
tbl_13.viewport_button = UIWidgets.create_simple_hotspot("viewport")

local tbl_14 = {
	255,
	0,
	0,
	0
}
local str_2 = "shadow_frame_02"
local corner = UIFrameSettings[str_2].texture_sizes.corner
local tbl_15 = {
	-corner[1],
	-corner[2]
}
local tbl_16 = {
	list = fn_2("list_window", "list", tbl, tbl_2),
	list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "list_window", tbl_4.list_scrollbar.size, "gold", nil, true),
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
local tbl_17 = {
	list_background = UIWidgets.create_simple_rect("list_background", tbl_14),
	list_background_frame = UIWidgets.create_frame("list_background", tbl_4.list_background.size, "shadow_frame_01", 0, tbl_14, tbl_15)
}
local tbl_18 = {
	on_enter = {
		{
			name = "delay",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				return
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				-- function 9
				return
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end
		},
		{
			name = "fade_in",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				arg_11_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				-- function 12
				local easeOutCubic = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end
		}
	},
	expand = {
		{
			name = "move",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				return
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				-- function 15
				local easeOutCubic = math.easeOutCubic(arg_15_3)
				local num = 255
				local num_2 = 130
				local floor = math.floor(num * easeOutCubic)
				local floor_2 = math.floor(num_2 * easeOutCubic)
				local size = arg_15_1.background.size

				arg_15_0.background.size[1] = size[1] + floor

				local size_2 = arg_15_1.viewport.size
				local position = arg_15_1.viewport.position

				arg_15_0.viewport.size[1] = size_2[1] + floor
				arg_15_0.viewport.size[2] = size_2[2] + floor_2

				local num_3 = 255 - 255 * easeOutCubic
				local title_text = arg_15_2.title_text

				title_text.style.text.text_color[1] = num_3
				title_text.style.text_shadow.text_color[1] = num_3

				local sub_title_text = arg_15_2.sub_title_text

				sub_title_text.style.text.text_color[1] = num_3
				sub_title_text.style.text_shadow.text_color[1] = num_3

				local type_title_text = arg_15_2.type_title_text

				type_title_text.style.text.text_color[1] = num_3
				type_title_text.style.text_shadow.text_color[1] = num_3

				local career_title_text = arg_15_2.career_title_text

				career_title_text.style.text.text_color[1] = num_3
				career_title_text.style.text_shadow.text_color[1] = num_3
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				return
			end
		}
	},
	collapse = {
		{
			name = "move",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				return
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				-- function 18
				local easeOutCubic = math.easeOutCubic(arg_18_3)
				local num = 255
				local num_2 = 130
				local floor = math.floor(num * easeOutCubic)
				local floor_2 = math.floor(num_2 * easeOutCubic)
				local size = arg_18_1.background.size

				arg_18_0.background.size[1] = size[1] + num - floor

				local size_2 = arg_18_1.viewport.size
				local position = arg_18_1.viewport.position

				arg_18_0.viewport.size[1] = size_2[1] + num - floor
				arg_18_0.viewport.size[2] = size_2[2] + num_2 - floor_2

				local num_3 = 255 * easeOutCubic
				local title_text = arg_18_2.title_text

				title_text.style.text.text_color[1] = num_3
				title_text.style.text_shadow.text_color[1] = num_3

				local sub_title_text = arg_18_2.sub_title_text

				sub_title_text.style.text.text_color[1] = num_3
				sub_title_text.style.text_shadow.text_color[1] = num_3

				local type_title_text = arg_18_2.type_title_text

				type_title_text.style.text.text_color[1] = num_3
				type_title_text.style.text_shadow.text_color[1] = num_3

				local career_title_text = arg_18_2.career_title_text

				career_title_text.style.text.text_color[1] = num_3
				career_title_text.style.text_shadow.text_color[1] = num_3
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end
		}
	}
}
local tbl_19 = {
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
			content_check_function = function ()
				-- function 20
				local IS_PS4 = IS_PS4

				IS_PS4 = IS_PS4 or IS_XB1

				return IS_PS4
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
	}
}
local tbl_20 = {}
local tbl_21 = {
	input_action = "confirm",
	priority = 2
}
local flag_2

flag_2 = not IS_WINDOWS and "interaction_action_unlock" and "dlc1_4_input_description_storepage"
tbl_21.description_text = flag_2
tbl_20[1] = tbl_21
tbl_20[2] = {
	input_action = "right_stick",
	priority = 5,
	description_text = "input_description_scroll_details",
	ignore_keybinding = true
}
tbl_20[3] = {
	input_action = "back",
	priority = 6,
	description_text = "input_description_close"
}
tbl_19.dlc_preview_purchase = tbl_20

local tbl_22 = {
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

tbl_19.dlc_preview_owned = tbl_22

local tbl_23 = {}
local tbl_24 = {
	input_action = "confirm",
	priority = 2
}
local flag_3

flag_3 = not IS_WINDOWS and "interaction_action_unlock" and "dlc1_4_input_description_storepage"
tbl_24.description_text = flag_3
tbl_23[1] = tbl_24
tbl_23[2] = {
	input_action = "special_1",
	priority = 4,
	description_text = "input_description_view_content"
}
tbl_23[3] = {
	input_action = "right_stick",
	priority = 5,
	description_text = "input_description_scroll_details",
	ignore_keybinding = true
}
tbl_23[4] = {
	input_action = "back",
	priority = 6,
	description_text = "input_description_back"
}
tbl_19.dlc_bundle_purchase = tbl_23

return {
	generic_input_actions = tbl_19,
	create_dlc_entry_definition = fn,
	item_widgets = tbl_12,
	top_widgets = tbl_13,
	bottom_widgets = tbl_11,
	dlc_top_widgets = tbl_16,
	dlc_bottom_widgets = tbl_17,
	scenegraph_definition = tbl_4,
	animation_definitions = tbl_18,
	loading_widgets = tbl_10
}
