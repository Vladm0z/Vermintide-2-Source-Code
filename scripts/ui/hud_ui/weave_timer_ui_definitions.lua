-- chunkname: @scripts/ui/hud_ui/weave_timer_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = 1.5
local var_0_3 = {
	250 * var_0_2,
	21 * var_0_2
}
local var_0_4 = {
	21 * var_0_2,
	21 * var_0_2
}
local var_0_5 = {
	70,
	50
}
local var_0_6 = {
	325 * var_0_2,
	40 * var_0_2
}
local var_0_7 = {
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
	timer_bg = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			UILayer.hud + 200
		},
		size = {
			339,
			125
		}
	},
	timer_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			-20,
			-20 - var_0_6[2],
			0
		},
		size = var_0_6
	},
	timer_icon = {
		vertical_alignment = "center",
		parent = "timer_window",
		horizontal_alignment = "left",
		position = {
			47,
			0,
			1
		},
		size = var_0_5
	},
	timer_bar = {
		vertical_alignment = "center",
		parent = "timer_window",
		horizontal_alignment = "right",
		position = {
			0,
			0,
			1
		},
		size = var_0_3
	},
	outer_frame = {
		vertical_alignment = "center",
		parent = "timer_bar",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			var_0_3[1] + 26,
			var_0_3[2] + 26
		}
	}
}

local function var_0_8(arg_1_0, arg_1_1)
	local var_1_0 = UIFrameSettings.button_frame_02
	local var_1_1 = UIFrameSettings.frame_outer_glow_02

	return {
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "mask",
					texture_id = "mask_id"
				},
				{
					pass_type = "texture",
					style_id = "glass",
					texture_id = "glass_id"
				},
				{
					style_id = "progress_bar_fill",
					pass_type = "texture_uv",
					content_id = "progress_bar_fill_id",
					content_change_function = function (arg_2_0, arg_2_1)
						arg_2_1.texture_size[1] = var_0_3[1] - arg_2_0.parent.progress * var_0_3[1]
						arg_2_0.uvs[1][1] = arg_2_0.parent.progress
						arg_2_0.uvs[2][1] = 1
						arg_2_1.offset[1] = arg_2_0.parent.progress * var_0_3[1]
					end
				},
				{
					style_id = "progress_bar_tip",
					pass_type = "texture_uv",
					content_id = "progress_bar_tip",
					content_change_function = function (arg_3_0, arg_3_1)
						arg_3_1.offset[1] = arg_3_0.parent.progress * var_0_3[1]
					end
				},
				{
					texture_id = "frame_id",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					scenegraph_id = "outer_frame",
					pass_type = "texture_frame",
					texture_id = "outer_frame_id",
					style_id = "outer_frame",
					content_check_function = function (arg_4_0)
						return arg_4_0.progress > 0.9
					end,
					content_change_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
						if arg_5_0.progress >= 0.9 then
							local var_5_0 = 192 + math.sin(arg_5_0.timer) * 64

							arg_5_1.color[1] = var_5_0
							arg_5_0.timer = arg_5_0.timer + arg_5_3 * 7
						end
					end
				},
				{
					style_id = "progress_bar_end_left",
					pass_type = "texture_uv",
					content_id = "progress_bar_end_left_id"
				},
				{
					pass_type = "texture",
					style_id = "progress_bar_end_right",
					texture_id = "progress_bar_end_id"
				},
				{
					style_id = "timer_text",
					pass_type = "text",
					text_id = "timer_text_id"
				},
				{
					style_id = "timer_text_shadow",
					pass_type = "text",
					text_id = "timer_text_id"
				}
			}
		},
		content = {
			progress_bar_end_id = "weave_bar_end",
			progress = 0,
			progress_bar_tip_id = "experience_bar_edge_glow",
			glass_id = "button_glass_01",
			mask_id = "mask_rect",
			timer_text_id = "00:00:00",
			progress_bar_tip = {
				texture_id = "experience_bar_edge_glow",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			},
			progress_bar_fill_id = {
				texture_id = "weave_bar_fill_timer",
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				}
			},
			frame_id = var_1_0.texture,
			outer_frame_id = var_1_1.texture,
			progress_bar_end_left_id = {
				texture_id = "weave_bar_end",
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
			},
			timer = math.degrees_to_radians(-90)
		},
		style = {
			background = {
				color = {
					128,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				}
			},
			mask = {
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
			glass = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					2
				},
				texture_size = {
					var_0_3[1],
					var_0_3[2]
				}
			},
			progress_bar_fill = {
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
				texture_size = {
					var_0_3[1],
					var_0_3[2] - 1
				}
			},
			progress_bar_tip = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				masked = true,
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					var_0_4[1],
					var_0_4[2] - 1
				},
				offset = {
					0,
					0,
					1
				}
			},
			frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					3
				},
				texture_size = var_1_0.texture_size,
				texture_sizes = var_1_0.texture_sizes
			},
			outer_frame = {
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
				},
				texture_size = var_1_1.texture_size,
				texture_sizes = var_1_1.texture_sizes
			},
			progress_bar_end_right = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					4
				},
				texture_size = {
					17 * var_0_2,
					21 * var_0_2
				}
			},
			progress_bar_end_left = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					4
				},
				texture_size = {
					17 * var_0_2,
					21 * var_0_2
				}
			},
			timer_text = {
				word_wrap = false,
				localize = false,
				font_size = 20,
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					20,
					-2,
					6
				}
			},
			timer_text_shadow = {
				word_wrap = false,
				localize = false,
				font_size = 20,
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					22,
					-4,
					5
				}
			}
		},
		scenegraph_id = arg_1_0
	}
end

local function var_0_9(arg_6_0, arg_6_1)
	local var_6_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_6_0)

	return {
		element = {
			passes = {
				{
					style_id = "time_left",
					pass_type = "text",
					text_id = "time_left_id"
				},
				{
					style_id = "timer_text",
					pass_type = "text",
					text_id = "timer_text_id"
				},
				{
					style_id = "timer_text_shadow",
					pass_type = "text",
					text_id = "timer_text_id"
				},
				{
					style_id = "background",
					texture_id = "background_id",
					pass_type = "texture",
					content_check_function = function (arg_7_0)
						return arg_7_0.progress >= arg_7_0.progress_cutoff
					end,
					content_change_function = function (arg_8_0, arg_8_1)
						if arg_8_0.progress >= arg_8_0.progress_cutoff then
							local var_8_0 = Managers.time:time("game")
							local var_8_1 = arg_8_0.progress < 1 and math.cos(var_8_0 * math.pi * 2) or 1

							arg_8_1.color[1] = 192 + var_8_1 * 64
							arg_8_1.texture_size[1] = math.lerp(var_6_0.size[1], var_6_0.size[1] * 1.25, var_8_1)
						end
					end
				}
			}
		},
		content = {
			progress_cutoff = 1,
			show_background = false,
			progress = 0,
			timer_text_id = "00:00",
			time_left_id = "timer_prefix_time_left",
			background_id = arg_6_0
		},
		style = {
			time_left = {
				word_wrap = false,
				upper_case = false,
				localize = true,
				font_size = 32,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = {
					255,
					216,
					114,
					35
				},
				offset = {
					0,
					-15,
					0
				}
			},
			background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = var_6_0.size,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					10,
					0
				}
			},
			timer_text = {
				word_wrap = false,
				localize = false,
				font_size = 42,
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					140,
					20,
					6
				}
			},
			timer_text_shadow = {
				word_wrap = false,
				localize = false,
				font_size = 42,
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					140,
					18,
					5
				}
			}
		},
		scenegraph_id = arg_6_1
	}
end

local var_0_10 = {
	timer = var_0_9("weaves_timer_highlight", "timer_bg")
}

return {
	scenegraph_definition = var_0_7,
	widgets = var_0_10
}
