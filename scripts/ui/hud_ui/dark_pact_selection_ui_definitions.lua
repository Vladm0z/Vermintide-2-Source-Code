-- chunkname: @scripts/ui/hud_ui/dark_pact_selection_ui_definitions.lua

local tbl = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.main_menu
		},
		size = {
			1920,
			1080
		}
	},
	pivot = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			1920,
			1080
		}
	},
	selection_pivot = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			205,
			0
		},
		size = {
			0,
			0
		}
	},
	info_text = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			80,
			0
		},
		size = {
			800,
			60
		}
	}
}
local dark_pact_profile_order = GameModeSettings.versus.dark_pact_profile_order
local tbl_2 = {}

for i = 1, #dark_pact_profile_order do
	local var_0_3 = dark_pact_profile_order[i]
	local var_0_4 = FindProfileIndex(var_0_3)
	local enemy_role = SPProfiles[var_0_4].enemy_role

	if not tbl_2[enemy_role] then
		local var_0_6 = tbl_2[enemy_role]

		var_0_6[#var_0_6 + 1] = var_0_3
	else
		tbl_2[enemy_role] = {}

		local var_0_7 = tbl_2[enemy_role]

		var_0_7[#var_0_7 + 1] = var_0_3
	end
end

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local str = "pactsworn_frame_01"
	local var_1_1 = UIFrameSettings[str]
	local var_1_2 = var_1_1.texture_sizes.horizontal[2]
	local flag = not arg_1_1 and arg_1_1 and {
		148,
		148
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "profile_texture",
					texture_id = "profile_texture"
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "texture",
					style_id = "hovered_frame",
					texture_id = "hovered_frame",
					content_check_function = function (self)
						-- function 2
						local is_hover = self.hotspot.is_hover

						is_hover = is_hover or self.selected

						return is_hover
					end
				}
			}
		},
		content = {
			hovered_frame = "pactsworn_frame_highlight",
			selected = false,
			profile_texture = "icons_placeholder",
			frame = var_1_1.texture,
			hotspot = {}
		},
		style = {
			profile_texture = {
				size = flag,
				default_size = flag,
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
			frame = {
				size = {
					flag[1] - 2,
					flag[2] - 4
				},
				default_size = {
					flag[1] - 2,
					flag[2] - 4
				},
				texture_size = var_1_1.texture_size,
				texture_sizes = var_1_1.texture_sizes,
				frame_margins = {
					-var_1_2,
					-var_1_2
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					2,
					4
				},
				default_offset = {
					0,
					2,
					4
				}
			},
			hotspot = {
				size = flag,
				offset = {
					0,
					0,
					0
				}
			},
			hovered_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = {
					flag[1] + 26,
					flag[2] + 30
				},
				default_size = {
					flag[1] + 26,
					flag[2] + 30
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-14,
					-16,
					21
				},
				default_offset = {
					-14,
					-16,
					21
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

local tbl_3 = {
	scenegraph_id = "pivot",
	element = {
		passes = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				pass_type = "texture",
				style_id = "gritty_border",
				texture_id = "gritty_border"
			},
			{
				pass_type = "texture",
				style_id = "profile_texture",
				texture_id = "profile_texture"
			}
		}
	},
	content = {
		gritty_border = "gritty_border",
		profile_texture = "icons_placeholder",
		hotspot = {}
	},
	style = {
		hotspot = {
			area_size = {
				148,
				148
			},
			offset = {
				0,
				80,
				0
			}
		},
		gritty_border = {
			texture_size = {
				150,
				160
			},
			color = Colors.get_table("black"),
			offset = {
				-20,
				60,
				0
			}
		},
		profile_texture = {
			texture_size = {
				148,
				148
			},
			offset = {
				0,
				80,
				0
			}
		}
	}
}
local tbl_4 = {
	255,
	Colors.from_hex("545454")
}
local tbl_5 = {
	255,
	Colors.from_hex("b65b00")
}
local tbl_6 = {
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("light_gray", 255),
	rect_color = Colors.get_color_table_with_alpha("black", 0),
	line_colors = {},
	offset = {
		0,
		0,
		50
	}
}
local tbl_7 = {
	font_size = 20,
	localize = false,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("black", 255),
	rect_color = Colors.get_color_table_with_alpha("black", 0),
	line_colors = {},
	offset = {
		1,
		1,
		49
	}
}
local tbl_8 = {
	overlay = UIWidgets.create_simple_rect("screen", {
		255,
		0,
		0,
		0
	}),
	chrome = {
		scenegraph_id = "pivot",
		offset = {
			0,
			0,
			1
		},
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "bottom_glow",
					texture_id = "bottom_glow"
				},
				{
					pass_type = "texture",
					style_id = "top_detail",
					texture_id = "top_detail"
				},
				{
					pass_type = "rotated_texture",
					style_id = "bottom_detail",
					texture_id = "bottom_detail"
				},
				{
					style_id = "category_text",
					pass_type = "text",
					text_id = "category_text"
				},
				{
					style_id = "pick_text",
					pass_type = "text",
					text_id = "pick_text"
				},
				{
					pass_type = "texture",
					style_id = "textured_backdrop",
					texture_id = "textured_backdrop"
				}
			}
		},
		content = {
			bottom_glow = "bottom_glow",
			pick_text = "",
			category_text = "",
			bottom_detail = "gritty_frame_wide",
			textured_backdrop = "textured_backdrop",
			top_detail = "gritty_frame_wide",
			color_disabled = tbl_4,
			color_available = tbl_5
		},
		style = {
			bottom_glow = {
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					-2
				},
				texture_size = {
					2800,
					344
				},
				color = Colors.get_color_table_with_alpha("white", 60)
			},
			top_detail = {
				horizontal_alignment = "center",
				offset = {
					0,
					150,
					0
				},
				texture_size = {
					522,
					65
				},
				color = Colors.get_color_table_with_alpha("black", 0)
			},
			bottom_detail = {
				horizontal_alignment = "center",
				angle = math.degrees_to_radians(180),
				pivot = {
					0,
					0
				},
				offset = {
					522,
					300,
					0
				},
				texture_size = {
					522,
					65
				},
				color = Colors.get_color_table_with_alpha("black", 0)
			},
			category_text = {
				use_shadow = true,
				upper_case = true,
				localize = false,
				font_size = 20,
				font_type = "hell_shark",
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					160,
					0
				}
			},
			pick_text = {
				upper_case = true,
				localize = false,
				font_size = 36,
				horizontal_alignment = "center",
				use_shadow = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("light_gray", 255),
				offset = {
					0,
					120,
					0
				},
				shadow_offset = {
					1,
					1,
					0
				},
				shadow_color = Colors.get_color_table_with_alpha("black", 255)
			},
			textured_backdrop = {
				horizontal_alignment = "center",
				offset = {
					0,
					105,
					-3
				},
				texture_size = {
					616,
					96
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			}
		}
	},
	info_text = UIWidgets.create_simple_rect_text("info_text", "", nil, nil, nil, tbl_6),
	info_text_shadow = UIWidgets.create_simple_rect_text("info_text", "", nil, nil, nil, tbl_7)
}
local tbl_9 = {
	on_enter = {
		{
			name = "fade_in_glow",
			duration = 0.6,
			init = NOP,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				local var_3_0 = arg_3_3

				arg_3_2.chrome.style.bottom_glow.color[1] = 150 * var_3_0
				arg_3_2.chrome.style.textured_backdrop.color[1] = 255 * var_3_0
				arg_3_2.overlay.style.rect.color[1] = 30 * var_3_0
			end,
			on_complete = NOP
		},
		{
			name = "fade_slide_in_bg",
			duration = 0.5,
			init = NOP,
			update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
				-- function 4
				local easeOutCubic = math.easeOutCubic(arg_4_3)
				local chrome = arg_4_2.chrome
				local num = 0 * easeOutCubic
				local num_2 = 480 * easeOutCubic
				local num_3 = 285 * easeOutCubic

				chrome.style.top_detail.color[1] = 0
				chrome.style.top_detail.offset[2] = 0
				chrome.style.bottom_detail.color[1] = 0
				chrome.style.bottom_detail.offset[2] = 0
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_text",
			delay = 0.3,
			duration = 0.4,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				arg_5_2.chrome.style.category_text.text_color[1] = 0
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				local easeOutCubic = math.easeOutCubic(arg_6_3)
				local chrome = arg_6_2.chrome
				local num = 255 * easeOutCubic

				chrome.style.category_text.text_color[1] = num
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_pick_text",
			delay = 0.4,
			duration = 0.5,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				arg_7_2.chrome.style.pick_text.text_color[1] = 0
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local easeOutCubic = math.easeOutCubic(arg_8_3)
				local chrome = arg_8_2.chrome
				local num = 255 * easeOutCubic

				chrome.style.pick_text.text_color[1] = num
			end,
			on_complete = NOP
		},
		{
			name = "slide_in_frames",
			delay = 0,
			duration = 0.5,
			init = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				local _selector_widgets = arg_9_3._selector_widgets

				for i = 1, #_selector_widgets do
					_selector_widgets[i].offset[2] = -1000
				end
			end,
			update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				-- function 10
				local num = 1 - math.easeOutCubic(arg_10_3)
				local _selector_widgets = arg_10_4._selector_widgets

				for i = 1, #_selector_widgets do
					_selector_widgets[i].offset[2] = (400 + 100 * i) * num
				end
			end,
			on_complete = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				arg_11_3:_capture_input()
			end
		},
		{
			name = "fade_in_info_text",
			delay = 0.5,
			duration = 0.2,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				arg_12_2.info_text.style.text.text_color[1] = 0
			end,
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				-- function 13
				arg_13_2.info_text.style.text.text_color[1] = 255 * math.easeOutCubic(arg_13_3)
			end,
			on_complete = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				return
			end
		},
		{
			name = "fade_in_info_text_shadow",
			delay = 0.5,
			duration = 0.2,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				arg_15_2.info_text_shadow.style.text.text_color[1] = 0
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				-- function 16
				arg_16_2.info_text_shadow.style.text.text_color[1] = 255 * math.easeOutCubic(arg_16_3)
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out_glow",
			duration = 0.2,
			init = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				arg_18_3:_release_input()
			end,
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				-- function 19
				local num = 1 - arg_19_3

				arg_19_2.chrome.style.bottom_glow.color[1] = 150 * num
				arg_19_2.chrome.style.textured_backdrop.color[1] = 255 * num
				arg_19_2.overlay.style.rect.color[1] = 30 * num
			end,
			on_complete = NOP
		},
		{
			name = "fade_slide_out",
			duration = 0.5,
			init = NOP,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				local num = 1 - math.easeOutCubic(arg_20_3)
				local chrome = arg_20_2.chrome
				local num_2 = 0 * num

				chrome.style.top_detail.color[1] = 0
				chrome.style.bottom_detail.color[1] = 0
				chrome.style.category_text.text_color[1] = num_2
				chrome.style.pick_text.text_color[1] = num_2
			end,
			on_complete = NOP
		},
		{
			name = "slide_out_frames",
			duration = 0.5,
			init = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				local _selector_widgets = arg_21_3._selector_widgets

				for i = 1, #_selector_widgets do
					_selector_widgets[i].offset[2] = 0
				end
			end,
			update = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				-- function 22
				local easeOutCubic = math.easeOutCubic(arg_22_3)
				local _selector_widgets = arg_22_4._selector_widgets

				for i = 1, #_selector_widgets do
					_selector_widgets[i].offset[2] = -(400 + 100 * i) * easeOutCubic
				end
			end,
			on_complete = NOP
		},
		{
			name = "fade_out_info_text",
			duration = 0.5,
			init = NOP,
			update = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				-- function 23
				arg_23_2.info_text.style.text.text_color[1] = 255 * (1 - math.easeOutCubic(arg_23_3))
			end,
			on_complete = NOP
		},
		{
			name = "fade_out_info_text_shadow",
			duration = 0.5,
			init = NOP,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				-- function 24
				arg_24_2.info_text_shadow.style.text.text_color[1] = 255 * (1 - math.easeOutCubic(arg_24_3))
			end,
			on_complete = NOP
		}
	}
}

return {
	scenegraph_definition = tbl,
	widget_definitions = tbl_8,
	animation_definitions = tbl_9,
	selection_frame_definition = tbl_3,
	ordered_pactsworn_slots = tbl_2,
	create_selection_widget = fn
}
