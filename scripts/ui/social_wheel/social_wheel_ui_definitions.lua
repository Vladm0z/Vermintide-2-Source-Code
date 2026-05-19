-- chunkname: @scripts/ui/social_wheel/social_wheel_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	root_screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	pivot_console = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			110,
			0
		}
	},
	pivot = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	social_event_text = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			0,
			100,
			0
		}
	},
	icon = {
		vertical_alignment = "bottom",
		parent = "root_screen",
		horizontal_alignment = "left",
		size = {
			128,
			128
		},
		position = {
			0,
			0,
			0
		}
	},
	next_page_input = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			300,
			50
		},
		position = {
			450,
			300,
			0
		}
	}
}

if not IS_WINDOWS then
	var_0_2.screen.scale = "hud_fit"
end

local function var_0_3(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = arg_1_2.size
	local var_1_1 = Vector3(math.cos(arg_1_1), math.sin(arg_1_1), 0)
	local var_1_2 = arg_1_4 and #arg_1_2[arg_1_4] or #arg_1_2
	local var_1_3 = arg_1_1 + 2 * math.pi * (1 / var_1_2) * 0.5
	local var_1_4 = Vector3(math.cos(var_1_3), math.sin(var_1_3), 0)
	local var_1_5 = 1 / var_1_2 * 360 / 90 * arg_1_2.wedge_adjustment
	local var_1_6 = 3
	local var_1_7 = true

	if arg_1_0.localize == false then
		var_1_7 = false
	end

	local var_1_8 = var_1_0[1] / var_1_0[2]

	return {
		element = {
			passes = {
				{
					style_id = "divider",
					pass_type = "rotated_texture",
					texture_id = "divider_id",
					content_change_function = function(arg_2_0, arg_2_1)
						if arg_2_0.activated then
							arg_2_1.color[1] = 0
						else
							arg_2_1.texture_size[2] = arg_2_1.base_texture_size[2] * arg_2_0.size_multiplier
							arg_2_1.pivot[2] = arg_2_1.base_texture_size[2] * arg_2_0.size_multiplier * 0.5
							arg_2_1.color[1] = math.clamp(255 * arg_2_0.size_multiplier, 0, 255)
						end

						local var_2_0 = arg_2_0.settings
						local var_2_1 = var_2_0.is_valid_func
						local var_2_2 = arg_1_3()

						if var_2_1 and var_2_2 then
							arg_2_0.is_valid = var_2_1(var_2_0.data, var_2_2, arg_2_0, arg_2_1)
						end
					end,
					content_check_function = function(arg_3_0, arg_3_1)
						return not arg_1_2.individual_bg
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "fade",
					texture_id = "fade_texture_id",
					content_check_function = function(arg_4_0, arg_4_1)
						return arg_4_0.selected and arg_4_0.is_valid and not arg_1_2.individual_bg
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_bg",
					texture_id = "icon_bg_id",
					content_check_function = function(arg_5_0, arg_5_1)
						return arg_1_2.individual_bg and arg_5_0.is_valid
					end
				},
				{
					style_id = "icon",
					texture_id = "icon_id",
					pass_type = "texture",
					content_change_function = function(arg_6_0, arg_6_1)
						if arg_6_0.activated then
							arg_6_1.color[2] = arg_6_1.activated_color[2]
							arg_6_1.color[3] = arg_6_1.activated_color[3]
							arg_6_1.color[4] = arg_6_1.activated_color[4]
						elseif arg_6_0.selected and arg_6_0.is_valid then
							arg_6_1.color[1] = 255
							arg_6_1.color[2] = 255
							arg_6_1.color[3] = 255
							arg_6_1.color[4] = 255
						else
							arg_6_1.color[1] = 96
							arg_6_1.color[2] = 255
							arg_6_1.color[3] = 255
							arg_6_1.color[4] = 255
						end
					end
				},
				{
					style_id = "icon_shadow",
					texture_id = "icon_id",
					pass_type = "texture",
					content_change_function = function(arg_7_0, arg_7_1)
						if not arg_7_0.activated then
							if arg_7_0.selected and arg_7_0.is_valid then
								arg_7_1.color[1] = 255
							else
								arg_7_1.color[1] = 96
							end
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_unavailable",
					texture_id = "icon_unavailable_id",
					content_check_function = function(arg_8_0, arg_8_1)
						return not arg_8_0.is_valid
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_glow",
					texture_id = "icon_glow_id",
					content_check_function = function(arg_9_0, arg_9_1)
						return arg_9_0.selected and not arg_9_0.activated
					end
				},
				{
					pass_type = "texture",
					style_id = "bg_top_right",
					texture_id = "fade_bg",
					content_check_function = function(arg_10_0, arg_10_1)
						return not arg_1_2.individual_bg
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_id",
					content_check_function = function(arg_11_0, arg_11_1)
						if arg_11_0.selected then
							arg_11_1.text_color = arg_11_1.selected_color
						else
							arg_11_1.text_color = arg_11_1.base_color
						end

						return IS_WINDOWS or arg_1_0.disable_input_text
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_id",
					content_check_function = function(arg_12_0, arg_12_1)
						if arg_12_0.selected then
							arg_12_1.text_color = arg_12_1.selected_color
						else
							arg_12_1.text_color = arg_12_1.base_color
						end

						return IS_WINDOWS or arg_1_0.disable_input_text
					end
				}
			}
		},
		content = {
			fade_texture_id = "radial_chat_wedge",
			divider_id = "radial_chat_bg_line",
			selected = false,
			is_valid = true,
			fade_bg = "radial_chat_bg",
			icon_unavailable_id = "radial_chat_icon_unavailable",
			size_multiplier = 0,
			final_size_multiplier = 1,
			icon_bg_id = "radial_chat_icon_bg",
			icon_id = arg_1_0.icon or "radial_chat_icon_boss",
			icon_glow_id = arg_1_0.icon and (arg_1_0.icon_glow or arg_1_0.icon .. "_glow") or "radial_chat_icon_boss_glow",
			settings = arg_1_0,
			category_settings = arg_1_2,
			text_id = arg_1_0.text,
			dir = Vector3Box(var_1_1),
			final_offset = var_1_0
		},
		style = {
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				base_texture_size = arg_1_2.icon_size or {
					128,
					128
				},
				texture_size = arg_1_2.icon_size or {
					128,
					128
				},
				activated_color = Colors.get_color_table_with_alpha("font_title", 255),
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					10
				}
			},
			icon_shadow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				base_texture_size = arg_1_2.icon_size or {
					128,
					128
				},
				texture_size = arg_1_2.icon_size or {
					128,
					128
				},
				activated_color = Colors.get_color_table_with_alpha("black", 255),
				color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					9
				}
			},
			icon_bg = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				base_texture_size = arg_1_2.icon_size or {
					128,
					128
				},
				texture_size = arg_1_2.icon_size or {
					128,
					128
				},
				color = Colors.get_color_table_with_alpha("black", 125),
				offset = {
					0,
					0,
					8
				}
			},
			icon_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				base_texture_size = arg_1_2.icon_size or {
					128,
					128
				},
				texture_size = arg_1_2.icon_size or {
					128,
					128
				},
				color = {
					255,
					232,
					86,
					14
				},
				offset = {
					0,
					0,
					11
				}
			},
			icon_unavailable = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				base_texture_size = arg_1_2.icon_size or {
					128,
					128
				},
				texture_size = arg_1_2.icon_size or {
					128,
					128
				},
				color = {
					255,
					128,
					60,
					60
				},
				offset = {
					0,
					0,
					12
				}
			},
			divider = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				base_texture_size = {
					4,
					250
				},
				texture_size = {
					4,
					250
				},
				pivot = {
					2,
					125
				},
				angle = 2 * math.pi - var_1_3 + math.pi * 0.5,
				color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-var_1_1[1] * var_1_0[1] + var_1_4[1] * 227,
					-var_1_1[2] * var_1_0[2] + var_1_4[2] * 227,
					1
				}
			},
			fade = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					389 * var_1_5 * var_1_6,
					195 * var_1_6
				},
				pivot = {
					389 * var_1_5 * 0.5 * var_1_6,
					97.5 * var_1_6
				},
				angle = 2 * math.pi - arg_1_1 + math.pi * 0.5,
				color = Colors.get_color_table_with_alpha("white", 30),
				offset = {
					-var_1_1[1] * var_1_0[1] + var_1_1[1] * 195 * 0.5 * var_1_6,
					-var_1_1[2] * var_1_0[2] + var_1_1[2] * 195 * 0.5 * var_1_6,
					10
				}
			},
			text = {
				word_wrap = false,
				font_size = 32,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				localize = var_1_7,
				selected_color = Colors.get_color_table_with_alpha("font_title", 255),
				base_color = Colors.get_color_table_with_alpha("white", 128),
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-80,
					2
				}
			},
			text_shadow = {
				word_wrap = false,
				font_size = 32,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				localize = var_1_7,
				selected_color = Colors.get_color_table_with_alpha("black", 255),
				base_color = Colors.get_color_table_with_alpha("black", 128),
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-82,
					1
				}
			},
			bg_top_right = {}
		},
		offset = {
			var_1_1[1] * var_1_0[1],
			var_1_1[2] * var_1_0[2],
			1
		},
		scenegraph_id = IS_WINDOWS and "pivot" or "pivot_console"
	}
end

local function var_0_4()
	return {
		element = {
			passes = {
				{
					style_id = "bg_top_right",
					texture_id = "fade_bg",
					pass_type = "texture",
					content_change_function = function(arg_14_0, arg_14_1)
						arg_14_1.texture_size[1] = arg_14_1.base_texture_size[1] * arg_14_0.size_multiplier
						arg_14_1.texture_size[2] = arg_14_1.base_texture_size[2] * arg_14_0.size_multiplier
					end
				},
				{
					style_id = "bg_top_left",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function(arg_15_0, arg_15_1)
						arg_15_1.texture_size[1] = arg_15_1.base_texture_size[1] * arg_15_0.size_multiplier
						arg_15_1.texture_size[2] = arg_15_1.base_texture_size[2] * arg_15_0.size_multiplier
					end
				},
				{
					style_id = "bg_bottom_right",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function(arg_16_0, arg_16_1)
						arg_16_1.texture_size[1] = arg_16_1.base_texture_size[1] * arg_16_0.size_multiplier
						arg_16_1.texture_size[2] = arg_16_1.base_texture_size[2] * arg_16_0.size_multiplier
					end
				},
				{
					style_id = "bg_bottom_left",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function(arg_17_0, arg_17_1)
						arg_17_1.texture_size[1] = arg_17_1.base_texture_size[1] * arg_17_0.size_multiplier
						arg_17_1.texture_size[2] = arg_17_1.base_texture_size[2] * arg_17_0.size_multiplier
					end
				},
				{
					style_id = "bg_top_right_masked",
					texture_id = "fade_bg",
					pass_type = "texture",
					content_change_function = function(arg_18_0, arg_18_1)
						arg_18_1.texture_size[1] = arg_18_1.base_texture_size[1] * arg_18_0.size_multiplier
						arg_18_1.texture_size[2] = arg_18_1.base_texture_size[2] * arg_18_0.size_multiplier
					end
				},
				{
					style_id = "bg_top_left_masked",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function(arg_19_0, arg_19_1)
						arg_19_1.texture_size[1] = arg_19_1.base_texture_size[1] * arg_19_0.size_multiplier
						arg_19_1.texture_size[2] = arg_19_1.base_texture_size[2] * arg_19_0.size_multiplier
					end
				},
				{
					style_id = "bg_bottom_right_masked",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function(arg_20_0, arg_20_1)
						arg_20_1.texture_size[1] = arg_20_1.base_texture_size[1] * arg_20_0.size_multiplier
						arg_20_1.texture_size[2] = arg_20_1.base_texture_size[2] * arg_20_0.size_multiplier
					end
				},
				{
					style_id = "bg_bottom_left_masked",
					texture_id = "fade_bg",
					pass_type = "rotated_texture",
					content_change_function = function(arg_21_0, arg_21_1)
						arg_21_1.texture_size[1] = arg_21_1.base_texture_size[1] * arg_21_0.size_multiplier
						arg_21_1.texture_size[2] = arg_21_1.base_texture_size[2] * arg_21_0.size_multiplier
					end
				},
				{
					style_id = "circle",
					texture_id = "circle_id",
					pass_type = "texture",
					content_change_function = function(arg_22_0, arg_22_1)
						arg_22_1.texture_size[1] = arg_22_1.base_texture_size[1] * arg_22_0.size_multiplier
						arg_22_1.texture_size[2] = arg_22_1.base_texture_size[2] * arg_22_0.size_multiplier
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_id"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_id"
				}
			}
		},
		content = {
			fade_bg = "radial_chat_bg",
			final_size_multiplier = 1,
			size_multiplier = 0,
			circle_id = "radial_chat_bg_ring",
			text_id = Localize("tutorial_no_text")
		},
		style = {
			bg_top_right = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				color = Colors.get_color_table_with_alpha("black", 60)
			},
			bg_top_left = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				pivot = {
					0,
					0
				},
				angle = 2 * math.pi * 0.75,
				color = Colors.get_color_table_with_alpha("black", 60)
			},
			bg_bottom_right = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				pivot = {
					0,
					0
				},
				angle = 2 * math.pi * 0.25,
				color = Colors.get_color_table_with_alpha("black", 60)
			},
			bg_bottom_left = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				pivot = {
					0,
					0
				},
				angle = 2 * math.pi * 0.5,
				color = Colors.get_color_table_with_alpha("black", 60)
			},
			bg_top_right_masked = {
				vertical_alignment = "bottom",
				masked = true,
				horizontal_alignment = "left",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				color = Colors.get_color_table_with_alpha("white", 60),
				offset = {
					0,
					0,
					1
				}
			},
			bg_top_left_masked = {
				masked = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				pivot = {
					0,
					0
				},
				angle = 2 * math.pi * 0.75,
				color = Colors.get_color_table_with_alpha("white", 60),
				offset = {
					0,
					0,
					1
				}
			},
			bg_bottom_right_masked = {
				masked = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				pivot = {
					0,
					0
				},
				angle = 2 * math.pi * 0.25,
				color = Colors.get_color_table_with_alpha("white", 60),
				offset = {
					0,
					0,
					1
				}
			},
			bg_bottom_left_masked = {
				masked = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				base_texture_size = {
					389,
					389
				},
				texture_size = {
					389,
					389
				},
				pivot = {
					0,
					0
				},
				angle = 2 * math.pi * 0.5,
				color = Colors.get_color_table_with_alpha("white", 60),
				offset = {
					0,
					0,
					1
				}
			},
			circle = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				base_texture_size = {
					205,
					205
				},
				texture_size = {
					205,
					205
				},
				color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					0,
					0,
					2
				}
			},
			text = {
				word_wrap = false,
				localize = false,
				font_size = 56,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-385,
					2
				}
			},
			text_shadow = {
				word_wrap = false,
				localize = false,
				font_size = 56,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 128),
				offset = {
					2,
					-387,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = IS_WINDOWS and "pivot" or "pivot_console"
	}
end

local function var_0_5()
	return {
		element = {
			passes = {
				{
					pass_type = "rotated_texture",
					style_id = "arrow",
					texture_id = "texture_id"
				},
				{
					pass_type = "texture",
					style_id = "cursor",
					texture_id = "dot_texture_id"
				}
			}
		},
		content = {
			dot_texture_id = "crosshair_01_center",
			texture_id = "radial_chat_cursor_arrow",
			pointing_point = Vector3Box(0, 0, 0)
		},
		style = {
			cursor = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				},
				pivot = {
					4,
					4
				},
				texture_size = {
					8,
					8
				}
			},
			arrow = {
				vertical_alignment = "center",
				angle = 0,
				horizontal_alignment = "center",
				pivot = {
					14.25,
					27
				},
				texture_size = {
					28.5,
					54
				},
				color = {
					192,
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
			10
		},
		scenegraph_id = IS_WINDOWS and "pivot" or "pivot_console"
	}
end

local function var_0_6()
	return {
		scenegraph_id = "next_page_input",
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_id"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_id"
				},
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				}
			}
		},
		content = {
			background = "hud_brushstroke",
			text_id = Localize("input_description_next_page") .. ": $KEY;Player__social_wheel_page:"
		},
		style = {
			text = {
				word_wrap = false,
				localize = false,
				font_size = 32,
				pixel_perfect = true,
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
			},
			text_shadow = {
				font_size = 32,
				font_type = "hell_shark_header",
				localize = false,
				word_wrap = false,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				skip_button_rendering = true,
				text_color = Colors.get_color_table_with_alpha("black", 128),
				offset = {
					2,
					-2,
					1
				}
			},
			background = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = {
					150,
					100,
					100,
					100
				},
				offset = {
					-20,
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
end

local function var_0_7(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0

	if arg_25_3 then
		var_25_0 = Colors.get_color_table_with_alpha("medium_purple", 255)
	else
		var_25_0 = Colors.get_color_table_with_alpha("light_sky_blue", 255)
	end

	var_25_0[2] = var_25_0[2] * 0.75
	var_25_0[3] = var_25_0[3] * 0.75
	var_25_0[4] = var_25_0[4] * 0.75

	return {
		scenegraph_id = "social_event_text",
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_id"
				},
				{
					pass_type = "texture",
					style_id = "texture",
					texture_id = "texture_id"
				}
			}
		},
		content = {
			spacing = 60,
			text_id = arg_25_2,
			texture_id = arg_25_1,
			is_local_player = arg_25_3
		},
		style = {
			text = {
				word_wrap = false,
				localize = false,
				font_size = 32,
				pixel_perfect = true,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = var_25_0,
				offset = {
					0,
					0,
					2
				}
			},
			texture = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					45,
					52.5
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					10,
					0,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_8(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	return {
		scenegraph_id = "icon",
		element = {
			passes = {
				{
					style_id = "texture",
					texture_id = "icon_id",
					pass_type = "texture",
					content_check_function = function(arg_27_0, arg_27_1)
						local var_27_0 = Managers.player:player_from_peer_id(arg_27_0.peer_id)
						local var_27_1 = var_27_0 and var_27_0.player_unit

						if not Unit.alive(var_27_1) then
							arg_27_0.is_visible = false

							return false
						end

						local var_27_2 = Camera.world_pose(arg_27_0.camera)
						local var_27_3 = Matrix4x4.translation(var_27_2)
						local var_27_4 = Unit.world_position(var_27_1, 0) - var_27_3
						local var_27_5 = Vector3.normalize(Vector3.flat(var_27_4))
						local var_27_6 = Matrix4x4.forward(var_27_2)
						local var_27_7 = Vector3.normalize(Vector3.flat(var_27_6))

						if Vector3.dot(var_27_7, var_27_5) <= 0 then
							arg_27_0.is_visible = false

							return false
						end

						arg_27_0.is_visible = true

						return true
					end,
					content_change_function = function(arg_28_0, arg_28_1)
						local var_28_0 = Managers.player:player_from_peer_id(arg_28_0.peer_id)
						local var_28_1 = var_28_0 and var_28_0.player_unit

						if Unit.alive(var_28_1) and Unit.has_node(var_28_1, "j_head") then
							local var_28_2 = Camera.world_position(arg_28_0.camera)
							local var_28_3 = RESOLUTION_LOOKUP.inv_scale
							local var_28_4 = Unit.node(var_28_1, "j_head")
							local var_28_5 = Unit.world_position(var_28_1, var_28_4)
							local var_28_6 = Vector3.distance_squared(var_28_2, var_28_5)
							local var_28_7 = math.lerp(1, 0.5, math.clamp(var_28_6 / 49, 0, 1))
							local var_28_8 = var_28_5 + Vector3(0, 0, 0.5) + Vector3(0, 0, 0.5) * (1 - var_28_7)
							local var_28_9 = Camera.world_to_screen(arg_28_0.camera, var_28_8)
							local var_28_10 = Managers.time:time("game")
							local var_28_11 = math.sin(var_28_10 * 15) * 0.1

							arg_28_1.texture_size[1] = arg_28_1.base_texture_size[1] * var_28_7 + arg_28_1.base_texture_size[1] * var_28_7 * var_28_11
							arg_28_1.texture_size[2] = arg_28_1.base_texture_size[2] * var_28_7 + arg_28_1.base_texture_size[2] * var_28_7 * var_28_11
							arg_28_1.offset[1] = var_28_9[1] * var_28_3 - arg_28_1.texture_size[1] * 0.5
							arg_28_1.offset[2] = var_28_9[2] * var_28_3 - arg_28_1.texture_size[1] * 0.5
							arg_28_0.offset = arg_28_1.offset
							arg_28_0.distance_scale = var_28_7
							arg_28_0.scale = var_28_11

							if var_28_10 > arg_28_0.end_time - arg_28_0.fade_time then
								local var_28_12 = arg_28_0.end_time - var_28_10

								arg_28_0.alpha = math.lerp(0, 255, math.clamp(var_28_12 / arg_28_0.fade_time, 0, 1))
								arg_28_1.color[1] = arg_28_0.alpha
							end
						end
					end
				},
				{
					style_id = "texture_glow",
					texture_id = "icon_glow_id",
					pass_type = "texture",
					content_check_function = function(arg_29_0, arg_29_1)
						return arg_29_0.is_visible
					end,
					content_change_function = function(arg_30_0, arg_30_1)
						local var_30_0 = arg_30_0.offset
						local var_30_1 = arg_30_0.distance_scale
						local var_30_2 = arg_30_0.scale
						local var_30_3 = arg_30_0.alpha

						arg_30_1.offset[1] = var_30_0[1]
						arg_30_1.offset[2] = var_30_0[2]
						arg_30_1.texture_size[1] = arg_30_1.base_texture_size[1] * var_30_1 + arg_30_1.base_texture_size[1] * var_30_1 * var_30_2
						arg_30_1.texture_size[2] = arg_30_1.base_texture_size[2] * var_30_1 + arg_30_1.base_texture_size[2] * var_30_1 * var_30_2
						arg_30_1.color[1] = var_30_3
					end
				},
				{
					style_id = "texture_shadow",
					texture_id = "icon_id",
					pass_type = "texture",
					content_check_function = function(arg_31_0, arg_31_1)
						return arg_31_0.is_visible
					end,
					content_change_function = function(arg_32_0, arg_32_1)
						local var_32_0 = arg_32_0.offset
						local var_32_1 = arg_32_0.distance_scale
						local var_32_2 = arg_32_0.scale
						local var_32_3 = arg_32_0.alpha

						arg_32_1.offset[1] = var_32_0[1] + 2
						arg_32_1.offset[2] = var_32_0[2] - 2
						arg_32_1.texture_size[1] = arg_32_1.base_texture_size[1] * var_32_1 + arg_32_1.base_texture_size[1] * var_32_1 * var_32_2
						arg_32_1.texture_size[2] = arg_32_1.base_texture_size[2] * var_32_1 + arg_32_1.base_texture_size[2] * var_32_1 * var_32_2
						arg_32_1.color[1] = var_32_3
					end
				}
			}
		},
		content = {
			alpha = 255,
			icon_bg_id = "radial_chat_icon_bg",
			icon_id = arg_26_0.icon or "radial_chat_icon_boss",
			icon_glow_id = arg_26_0.icon and arg_26_0.icon .. "_glow" or "radial_chat_icon_boss_glow",
			peer_id = arg_26_1,
			camera = arg_26_2,
			world = arg_26_3,
			end_time = arg_26_4 or Managers.time:time("game") + 5,
			fade_time = arg_26_5 or 0.5
		},
		style = {
			texture = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				base_texture_size = {
					128,
					128
				},
				texture_size = {
					128,
					128
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
					10
				}
			},
			texture_glow = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = {
					128,
					128
				},
				base_texture_size = {
					128,
					128
				},
				color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					0,
					0,
					10
				}
			},
			texture_shadow = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				base_texture_size = {
					128,
					128
				},
				texture_size = {
					128,
					128
				},
				color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
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
end

return {
	scenegraph_definition = var_0_2,
	create_social_widget = var_0_3,
	arrow_widget = var_0_5(),
	create_social_text_event = var_0_7,
	create_social_icon = var_0_8,
	create_bg_widget = var_0_4,
	page_input_widget = var_0_6()
}
