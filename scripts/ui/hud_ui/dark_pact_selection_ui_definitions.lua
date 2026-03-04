-- chunkname: @scripts/ui/hud_ui/dark_pact_selection_ui_definitions.lua

local var_0_0 = {
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
local var_0_1 = GameModeSettings.versus.dark_pact_profile_order
local var_0_2 = {}

for iter_0_0 = 1, #var_0_1 do
	local var_0_3 = var_0_1[iter_0_0]
	local var_0_4 = FindProfileIndex(var_0_3)
	local var_0_5 = SPProfiles[var_0_4].enemy_role

	if var_0_2[var_0_5] then
		local var_0_6 = var_0_2[var_0_5]

		var_0_6[#var_0_6 + 1] = var_0_3
	else
		var_0_2[var_0_5] = {}

		local var_0_7 = var_0_2[var_0_5]

		var_0_7[#var_0_7 + 1] = var_0_3
	end
end

local function var_0_8(arg_1_0, arg_1_1)
	local var_1_0 = "pactsworn_frame_01"
	local var_1_1 = UIFrameSettings[var_1_0]
	local var_1_2 = var_1_1.texture_sizes.horizontal[2]
	local var_1_3 = arg_1_1 and arg_1_1 or {
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
					content_check_function = function (arg_2_0)
						return arg_2_0.hotspot.is_hover or arg_2_0.selected
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
				size = var_1_3,
				default_size = var_1_3,
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
					var_1_3[1] - 2,
					var_1_3[2] - 4
				},
				default_size = {
					var_1_3[1] - 2,
					var_1_3[2] - 4
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
				size = var_1_3,
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
					var_1_3[1] + 26,
					var_1_3[2] + 30
				},
				default_size = {
					var_1_3[1] + 26,
					var_1_3[2] + 30
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

local var_0_9 = {
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
local var_0_10 = {
	255,
	Colors.from_hex("545454")
}
local var_0_11 = {
	255,
	Colors.from_hex("b65b00")
}
local var_0_12 = {
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
local var_0_13 = {
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
local var_0_14 = {
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
			color_disabled = var_0_10,
			color_available = var_0_11
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
	info_text = UIWidgets.create_simple_rect_text("info_text", "", nil, nil, nil, var_0_12),
	info_text_shadow = UIWidgets.create_simple_rect_text("info_text", "", nil, nil, nil, var_0_13)
}
local var_0_15 = {
	on_enter = {
		{
			name = "fade_in_glow",
			duration = 0.6,
			init = NOP,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
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
				local var_4_0 = math.easeOutCubic(arg_4_3)
				local var_4_1 = arg_4_2.chrome
				local var_4_2 = 0 * var_4_0
				local var_4_3 = 480 * var_4_0
				local var_4_4 = 285 * var_4_0

				var_4_1.style.top_detail.color[1] = 0
				var_4_1.style.top_detail.offset[2] = 0
				var_4_1.style.bottom_detail.color[1] = 0
				var_4_1.style.bottom_detail.offset[2] = 0
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_text",
			delay = 0.3,
			duration = 0.4,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				arg_5_2.chrome.style.category_text.text_color[1] = 0
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeOutCubic(arg_6_3)
				local var_6_1 = arg_6_2.chrome
				local var_6_2 = 255 * var_6_0

				var_6_1.style.category_text.text_color[1] = var_6_2
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_pick_text",
			delay = 0.4,
			duration = 0.5,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				arg_7_2.chrome.style.pick_text.text_color[1] = 0
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = math.easeOutCubic(arg_8_3)
				local var_8_1 = arg_8_2.chrome
				local var_8_2 = 255 * var_8_0

				var_8_1.style.pick_text.text_color[1] = var_8_2
			end,
			on_complete = NOP
		},
		{
			name = "slide_in_frames",
			delay = 0,
			duration = 0.5,
			init = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				local var_9_0 = arg_9_3._selector_widgets

				for iter_9_0 = 1, #var_9_0 do
					var_9_0[iter_9_0].offset[2] = -1000
				end
			end,
			update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				local var_10_0 = 1 - math.easeOutCubic(arg_10_3)
				local var_10_1 = arg_10_4._selector_widgets

				for iter_10_0 = 1, #var_10_1 do
					var_10_1[iter_10_0].offset[2] = (400 + 100 * iter_10_0) * var_10_0
				end
			end,
			on_complete = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				arg_11_3:_capture_input()
			end
		},
		{
			name = "fade_in_info_text",
			delay = 0.5,
			duration = 0.2,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				arg_12_2.info_text.style.text.text_color[1] = 0
			end,
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				arg_13_2.info_text.style.text.text_color[1] = 255 * math.easeOutCubic(arg_13_3)
			end,
			on_complete = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				return
			end
		},
		{
			name = "fade_in_info_text_shadow",
			delay = 0.5,
			duration = 0.2,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				arg_15_2.info_text_shadow.style.text.text_color[1] = 0
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				arg_16_2.info_text_shadow.style.text.text_color[1] = 255 * math.easeOutCubic(arg_16_3)
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out_glow",
			duration = 0.2,
			init = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				arg_18_3:_release_input()
			end,
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				local var_19_0 = 1 - arg_19_3

				arg_19_2.chrome.style.bottom_glow.color[1] = 150 * var_19_0
				arg_19_2.chrome.style.textured_backdrop.color[1] = 255 * var_19_0
				arg_19_2.overlay.style.rect.color[1] = 30 * var_19_0
			end,
			on_complete = NOP
		},
		{
			name = "fade_slide_out",
			duration = 0.5,
			init = NOP,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				local var_20_0 = 1 - math.easeOutCubic(arg_20_3)
				local var_20_1 = arg_20_2.chrome
				local var_20_2 = 0 * var_20_0

				var_20_1.style.top_detail.color[1] = 0
				var_20_1.style.bottom_detail.color[1] = 0
				var_20_1.style.category_text.text_color[1] = var_20_2
				var_20_1.style.pick_text.text_color[1] = var_20_2
			end,
			on_complete = NOP
		},
		{
			name = "slide_out_frames",
			duration = 0.5,
			init = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				local var_21_0 = arg_21_3._selector_widgets

				for iter_21_0 = 1, #var_21_0 do
					var_21_0[iter_21_0].offset[2] = 0
				end
			end,
			update = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				local var_22_0 = math.easeOutCubic(arg_22_3)
				local var_22_1 = arg_22_4._selector_widgets

				for iter_22_0 = 1, #var_22_1 do
					var_22_1[iter_22_0].offset[2] = -(400 + 100 * iter_22_0) * var_22_0
				end
			end,
			on_complete = NOP
		},
		{
			name = "fade_out_info_text",
			duration = 0.5,
			init = NOP,
			update = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				arg_23_2.info_text.style.text.text_color[1] = 255 * (1 - math.easeOutCubic(arg_23_3))
			end,
			on_complete = NOP
		},
		{
			name = "fade_out_info_text_shadow",
			duration = 0.5,
			init = NOP,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				arg_24_2.info_text_shadow.style.text.text_color[1] = 255 * (1 - math.easeOutCubic(arg_24_3))
			end,
			on_complete = NOP
		}
	}
}

return {
	scenegraph_definition = var_0_0,
	widget_definitions = var_0_14,
	animation_definitions = var_0_15,
	selection_frame_definition = var_0_9,
	ordered_pactsworn_slots = var_0_2,
	create_selection_widget = var_0_8
}
