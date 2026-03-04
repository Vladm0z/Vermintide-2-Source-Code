-- chunkname: @scripts/ui/views/versus_mission_objective_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	819,
	60
}
local var_0_3 = {
	64,
	64
}
local var_0_4 = {
	var_0_2[1],
	var_0_2[2]
}
local var_0_5 = {
	screen = {
		size = {
			var_0_0,
			var_0_1
		},
		position = {
			0,
			0,
			UILayer.hud
		},
		scale = not IS_WINDOWS and "hud_fit" or "fit"
	},
	pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			100
		}
	},
	objective_detail = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-25,
			0
		}
	},
	objective_text = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "center",
		size = {
			544,
			50
		},
		position = {
			0,
			-10,
			0
		}
	},
	objective = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "center",
		size = {
			302.4,
			117.6
		},
		position = {
			0,
			-60,
			10
		}
	},
	mission_pivot = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-250,
			1
		}
	},
	mission_widget = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "center",
		size = var_0_4,
		position = {
			0,
			0,
			0
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "mission_pivot",
		horizontal_alignment = "center",
		size = {
			574,
			90
		},
		position = {
			0,
			-1,
			0
		}
	},
	area_text_background = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			1800,
			90
		},
		position = {
			0,
			0,
			0
		}
	},
	duration_text_background = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			1800,
			90
		},
		position = {
			0,
			0,
			0
		}
	},
	top_center = {
		vertical_alignment = "center",
		parent = "mission_pivot",
		horizontal_alignment = "center",
		size = {
			54,
			22
		},
		position = {
			0,
			0,
			5
		}
	},
	top_left = {
		vertical_alignment = "center",
		parent = "top_center",
		horizontal_alignment = "right",
		size = {
			264,
			6
		},
		position = {
			-31,
			0,
			-1
		}
	},
	top_right = {
		vertical_alignment = "center",
		parent = "top_center",
		horizontal_alignment = "left",
		size = {
			264,
			6
		},
		position = {
			31,
			0,
			-1
		}
	},
	top_detail = {
		vertical_alignment = "center",
		parent = "top_center",
		horizontal_alignment = "center",
		size = {
			54,
			22
		},
		position = {
			0,
			0,
			8
		}
	},
	bottom_center = {
		vertical_alignment = "center",
		parent = "mission_pivot",
		horizontal_alignment = "center",
		size = {
			54,
			22
		},
		position = {
			0,
			-1,
			6
		}
	},
	bottom_left = {
		vertical_alignment = "center",
		parent = "bottom_center",
		horizontal_alignment = "right",
		size = {
			264,
			6
		},
		position = {
			-31,
			-3,
			-1
		}
	},
	bottom_right = {
		vertical_alignment = "center",
		parent = "bottom_center",
		horizontal_alignment = "left",
		size = {
			264,
			6
		},
		position = {
			31,
			-3,
			-1
		}
	},
	mission_icon_left = {
		vertical_alignment = "center",
		parent = "mission_widget",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			var_0_3[2]
		},
		position = {
			0,
			0,
			1
		}
	},
	mission_icon_right = {
		vertical_alignment = "center",
		parent = "mission_widget",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			var_0_3[2]
		},
		position = {
			0,
			0,
			1
		}
	},
	frame_top_right = {
		vertical_alignment = "top",
		parent = "mission_widget",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			var_0_2[1] / 2,
			2,
			3
		}
	},
	frame_top_left = {
		vertical_alignment = "top",
		parent = "mission_widget",
		horizontal_alignment = "right",
		size = {
			450,
			4
		},
		position = {
			-var_0_2[1] / 2,
			2,
			3
		}
	},
	frame_bottom_right = {
		vertical_alignment = "bottom",
		parent = "mission_widget",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			var_0_2[1] / 2,
			-2,
			3
		}
	},
	frame_bottom_left = {
		vertical_alignment = "bottom",
		parent = "mission_widget",
		horizontal_alignment = "right",
		size = {
			450,
			4
		},
		position = {
			-var_0_2[1] / 2,
			-2,
			3
		}
	}
}
local var_0_6 = {
	word_wrap = true,
	localize = false,
	upper_case = false,
	font_size = 24,
	vertical_alignment = "center",
	horizontal_alignment = "center",
	use_shadow = true,
	dynamic_font_size = false,
	draw_text_rect = true,
	font_type = "hell_shark",
	rect_color = {
		0,
		0,
		0,
		0
	},
	text_color = Colors.get_color_table_with_alpha("white_smoke", 255),
	shadow_offset = {
		1,
		1,
		0
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_7 = table.clone(var_0_6)

var_0_7.font_size = 38
var_0_7.offset = {
	0,
	-20,
	2
}
var_0_7.text_color = Colors.get_color_table_with_alpha("white_smoke", 255)
var_0_7.size = {
	50,
	50
}
var_0_7.dynamic_font_size = true

local var_0_8 = table.clone(var_0_6)

var_0_8.font_size = 24
var_0_8.dynamic_font_size = true
var_0_8.word_wrap = false
var_0_8.offset = {
	0,
	-75,
	2
}
var_0_8.text_color = Colors.get_color_table_with_alpha("white_smoke", 255)
var_0_8.size = {
	50,
	50
}

local var_0_9 = {
	255,
	144,
	144,
	144
}

local function var_0_10(arg_1_0)
	return {
		alpha_multiplier = 1,
		element = {
			passes = {
				{
					style_id = "area_text_style",
					pass_type = "text",
					text_id = "area_text_content"
				},
				{
					style_id = "area_text_shadow_style",
					pass_type = "text",
					text_id = "area_text_content"
				},
				{
					style_id = "duration_text_style",
					pass_type = "text",
					text_id = "duration_text_content",
					content_check_function = function(arg_2_0, arg_2_1)
						return arg_2_0.duration_text_content
					end
				},
				{
					style_id = "duration_text_shadow_style",
					pass_type = "text",
					text_id = "duration_text_content",
					content_check_function = function(arg_3_0, arg_3_1)
						return arg_3_0.duration_text_content
					end
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "top_center",
					texture_id = "top_center"
				},
				{
					style_id = "top_glow",
					pass_type = "texture_uv",
					content_id = "top_glow"
				},
				{
					style_id = "top_edge_glow",
					pass_type = "texture_uv",
					content_id = "top_edge_glow"
				},
				{
					pass_type = "texture",
					style_id = "top_detail",
					texture_id = "top_detail"
				},
				{
					pass_type = "texture",
					style_id = "top_detail_glow",
					texture_id = "top_detail_glow"
				},
				{
					style_id = "top_left",
					pass_type = "texture_uv",
					content_id = "top_left"
				},
				{
					style_id = "top_right",
					pass_type = "texture_uv",
					content_id = "top_right"
				},
				{
					style_id = "bottom_left",
					pass_type = "texture_uv",
					content_id = "bottom_left"
				},
				{
					style_id = "bottom_right",
					pass_type = "texture_uv",
					content_id = "bottom_right"
				},
				{
					pass_type = "texture",
					style_id = "bottom_center",
					texture_id = "bottom_center"
				},
				{
					style_id = "bottom_glow",
					pass_type = "texture_uv",
					content_id = "bottom_glow"
				},
				{
					pass_type = "texture",
					style_id = "bottom_edge_glow",
					texture_id = "bottom_edge_glow"
				},
				{
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					style_id = "background_texture",
					texture_id = "background_texture",
					dynamic_function = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
						local var_4_0 = arg_4_0.fraction
						local var_4_1 = arg_4_1.color
						local var_4_2 = arg_4_1.uv_start_pixels
						local var_4_3 = arg_4_1.uv_scale_pixels
						local var_4_4 = var_4_2 + var_4_3 * var_4_0
						local var_4_5 = arg_4_1.uvs
						local var_4_6 = arg_4_1.scale_axis
						local var_4_7 = (1 - var_4_4 / (var_4_2 + var_4_3)) * 0.5

						var_4_5[1][var_4_6] = var_4_7
						var_4_5[2][var_4_6] = 1 - var_4_7

						return var_4_1, var_4_5, arg_4_2, arg_4_1.offset
					end
				}
			}
		},
		content = {
			background_texture = "hud_difficulty_notification_bg_center",
			area_text_content = "n/a",
			bottom_edge_glow = "mission_objective_glow_01",
			top_center = "mission_objective_04",
			fraction = 1,
			top_detail_glow = "mission_objective_glow_02",
			bottom_center = "mission_objective_02",
			top_detail = "mission_objective_01",
			background = {
				texture_id = "mission_objective_bg",
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
			top_glow = {
				texture_id = "mission_objective_top",
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
			bottom_glow = {
				texture_id = "mission_objective_bottom",
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
			top_edge_glow = {
				texture_id = "mission_objective_glow_01",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			},
			top_left = {
				texture_id = "mission_objective_05",
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
			top_right = {
				texture_id = "mission_objective_05",
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
			bottom_left = {
				texture_id = "mission_objective_03",
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
			bottom_right = {
				texture_id = "mission_objective_03",
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
			}
		},
		style = {
			background = {
				scenegraph_id = "background",
				offset = {
					0,
					0,
					0
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			top_center = {
				scenegraph_id = "top_center",
				offset = {
					0,
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
			top_glow = {
				scenegraph_id = "top_center",
				size = {
					544,
					90
				},
				default_size = {
					544,
					90
				},
				offset = {
					-245,
					-80,
					-4
				},
				default_offset = {
					-245,
					-80,
					-4
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			top_edge_glow = {
				scenegraph_id = "top_center",
				size = {
					544,
					16
				},
				default_size = {
					544,
					16
				},
				offset = {
					-245,
					-6,
					-4
				},
				default_offset = {
					-245,
					-6,
					-5
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			top_detail = {
				scenegraph_id = "top_detail",
				offset = {
					0,
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
			top_detail_glow = {
				scenegraph_id = "top_detail",
				offset = {
					0,
					0,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			top_left = {
				scenegraph_id = "top_left",
				offset = {
					0,
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
			top_right = {
				scenegraph_id = "top_right",
				offset = {
					0,
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
			bottom_left = {
				scenegraph_id = "bottom_left",
				offset = {
					0,
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
			bottom_right = {
				scenegraph_id = "bottom_right",
				offset = {
					0,
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
			bottom_center = {
				scenegraph_id = "bottom_center",
				offset = {
					0,
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
			bottom_glow = {
				scenegraph_id = "bottom_center",
				size = {
					544,
					90
				},
				default_size = {
					544,
					90
				},
				offset = {
					-245,
					10,
					-4
				},
				default_offset = {
					-245,
					10,
					-4
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			bottom_edge_glow = {
				scenegraph_id = "bottom_center",
				size = {
					544,
					16
				},
				default_size = {
					544,
					16
				},
				offset = {
					-245,
					10,
					-4
				},
				default_offset = {
					-245,
					10,
					-5
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			area_text_style = {
				min_font_size = 20,
				upper_case = true,
				localize = false,
				font_size = 30,
				default_font_size = 30,
				horizontal_alignment = "center",
				word_wrap = true,
				vertical_alignment = "center",
				scenegraph_id = "area_text_background",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-1,
					11
				}
			},
			area_text_shadow_style = {
				min_font_size = 20,
				upper_case = true,
				localize = false,
				font_size = 30,
				default_font_size = 30,
				horizontal_alignment = "center",
				word_wrap = true,
				vertical_alignment = "center",
				scenegraph_id = "area_text_background",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-3,
					10
				}
			},
			duration_text_style = {
				min_font_size = 20,
				upper_case = false,
				localize = false,
				font_size = 30,
				default_font_size = 30,
				horizontal_alignment = "center",
				word_wrap = true,
				vertical_alignment = "center",
				scenegraph_id = "duration_text_background",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-1,
					11
				}
			},
			duration_text_shadow_style = {
				min_font_size = 20,
				upper_case = false,
				localize = false,
				font_size = 30,
				default_font_size = 30,
				horizontal_alignment = "center",
				word_wrap = true,
				vertical_alignment = "center",
				scenegraph_id = "duration_text_background",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-3,
					10
				}
			},
			background_texture = {
				uv_start_pixels = 0,
				offset_scale = 1,
				background_component = true,
				scale_axis = 2,
				uv_scale_pixels = var_0_2[2],
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				},
				offset = {
					0,
					0,
					0
				},
				color = {
					0,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_1_0
	}
end

local var_0_11 = {
	round_start_timer = UIWidgets.create_simple_text("", "objective", nil, nil, var_0_7),
	round_starting_text = UIWidgets.create_simple_text("", "objective", nil, nil, var_0_8),
	objective = UIWidgets.create_objective_score_widget("objective", var_0_5.objective.size)
}
local var_0_12 = 1.5
local var_0_13 = {
	announcement = {
		{
			name = "fade_in_header",
			start_progress = 0 * var_0_12,
			end_progress = 0.5 * var_0_12,
			init = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				return
			end,
			update = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeOutCubic(arg_6_3)
				local var_6_1 = math.ease_pulse(var_6_0)
				local var_6_2 = widget.style
				local var_6_3 = var_6_2.text
				local var_6_4 = var_6_2.text_shadow
				local var_6_5 = var_6_3.default_font_size

				var_6_3.font_size = var_6_5 + math.floor(var_6_5 * 1) * (1 - var_6_0)
				var_6_4.font_size = var_6_3.font_size
			end,
			on_complete = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		},
		{
			name = "fade_in_value",
			start_progress = 0.5 * var_0_12,
			end_progress = 1 * var_0_12,
			init = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				return
			end,
			update = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				local var_9_0 = math.easeOutCubic(arg_9_3)
				local var_9_1 = math.ease_pulse(var_9_0)
				local var_9_2 = arg_9_2.announcement_value_text

				var_9_2.alpha_multiplier = math.easeCubic(arg_9_3)

				local var_9_3 = var_9_2.style
				local var_9_4 = -70 * (1 - math.ease_out_exp(arg_9_3))

				var_9_2.offset[2] = var_9_4
			end,
			on_complete = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end
		},
		{
			name = "fade_out_header",
			start_progress = 2 * var_0_12,
			end_progress = 2.5 * var_0_12,
			init = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				return
			end,
			update = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				local var_12_0 = math.easeOutCubic(arg_12_3)
			end,
			on_complete = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		},
		{
			name = "fade_out_value",
			start_progress = 1.7 * var_0_12,
			end_progress = 2.5 * var_0_12,
			init = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				return
			end,
			update = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				local var_15_0 = math.easeOutCubic(arg_15_3)

				arg_15_2.announcement_value_text.alpha_multiplier = 1 - var_15_0
			end,
			on_complete = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end
		}
	},
	mission_start = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				arg_17_2.alpha_multiplier = 0
				arg_17_3.render_settings.snap_pixel_positions = false
				arg_17_2.style.top_edge_glow.color[1] = 0
				arg_17_2.style.bottom_edge_glow.color[1] = 0
				arg_17_0.mission_pivot.local_position[2] = arg_17_1.mission_pivot.position[2]

				local var_17_0 = arg_17_2.style
				local var_17_1 = arg_17_2.content
				local var_17_2 = var_17_0.area_text_style
				local var_17_3 = var_17_0.area_text_shadow_style

				var_17_2.font_size = var_17_2.default_font_size
				var_17_3.font_size = var_17_2.default_font_size
				var_17_2.text_color[1] = 0
				var_17_3.text_color[1] = 0

				local var_17_4 = var_17_0.duration_text_style
				local var_17_5 = var_17_0.duration_text_shadow_style

				var_17_4.font_size = var_17_4.default_font_size
				var_17_5.font_size = var_17_4.default_font_size
				var_17_4.text_color[1] = 0
				var_17_5.text_color[1] = 0
			end,
			update = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				arg_18_2.alpha_multiplier = math.easeOutCubic(arg_18_3)
			end,
			on_complete = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end
		},
		{
			name = "unfold",
			start_progress = 0.3,
			end_progress = 0.8,
			init = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				local var_20_0 = 0.1
				local var_20_1 = arg_20_2.style
				local var_20_2 = arg_20_2.content
				local var_20_3 = var_20_2.top_left
				local var_20_4 = var_20_1.top_left
				local var_20_5 = var_20_3.uvs
				local var_20_6 = arg_20_0.top_left
				local var_20_7 = arg_20_1.top_left

				var_20_6.size[1] = var_20_7.size[1] * var_20_0
				var_20_5[2][1] = var_20_0

				local var_20_8 = var_20_2.bottom_left
				local var_20_9 = var_20_1.bottom_left
				local var_20_10 = var_20_8.uvs
				local var_20_11 = arg_20_0.bottom_left
				local var_20_12 = arg_20_1.bottom_left

				var_20_11.size[1] = var_20_12.size[1] * var_20_0
				var_20_10[2][1] = var_20_0

				local var_20_13 = var_20_2.top_right
				local var_20_14 = var_20_1.top_right
				local var_20_15 = var_20_13.uvs
				local var_20_16 = arg_20_0.top_right
				local var_20_17 = arg_20_1.top_right

				var_20_16.size[1] = var_20_17.size[1] * var_20_0
				var_20_15[1][1] = 1 - var_20_0

				local var_20_18 = var_20_2.bottom_right
				local var_20_19 = var_20_1.bottom_right
				local var_20_20 = var_20_18.uvs
				local var_20_21 = arg_20_0.bottom_right
				local var_20_22 = arg_20_1.bottom_right

				var_20_21.size[1] = var_20_22.size[1] * var_20_0
				var_20_20[1][1] = 1 - var_20_0
			end,
			update = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				local var_21_0 = math.min(0.1 + math.easeInCubic(arg_21_3), 1)
				local var_21_1 = arg_21_2.style
				local var_21_2 = arg_21_2.content
				local var_21_3 = var_21_2.top_left
				local var_21_4 = var_21_1.top_left
				local var_21_5 = var_21_3.uvs
				local var_21_6 = arg_21_0.top_left
				local var_21_7 = arg_21_1.top_left

				var_21_6.size[1] = var_21_7.size[1] * var_21_0
				var_21_5[2][1] = var_21_0

				local var_21_8 = var_21_2.bottom_left
				local var_21_9 = var_21_1.bottom_left
				local var_21_10 = var_21_8.uvs
				local var_21_11 = arg_21_0.bottom_left
				local var_21_12 = arg_21_1.bottom_left

				var_21_11.size[1] = var_21_12.size[1] * var_21_0
				var_21_10[2][1] = var_21_0

				local var_21_13 = var_21_2.top_right
				local var_21_14 = var_21_1.top_right
				local var_21_15 = var_21_13.uvs
				local var_21_16 = arg_21_0.top_right
				local var_21_17 = arg_21_1.top_right

				var_21_16.size[1] = var_21_17.size[1] * var_21_0
				var_21_15[1][1] = 1 - var_21_0

				local var_21_18 = var_21_2.bottom_right
				local var_21_19 = var_21_1.bottom_right
				local var_21_20 = var_21_18.uvs
				local var_21_21 = arg_21_0.bottom_right
				local var_21_22 = arg_21_1.bottom_right

				var_21_21.size[1] = var_21_22.size[1] * var_21_0
				var_21_20[1][1] = 1 - var_21_0
			end,
			on_complete = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				return
			end
		},
		{
			name = "open",
			start_progress = 0.8,
			end_progress = 1.5,
			init = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				local var_23_0 = arg_23_2.style
				local var_23_1 = arg_23_2.content
				local var_23_2 = var_23_0.top_glow
				local var_23_3 = var_23_0.bottom_glow
				local var_23_4 = var_23_0.background

				var_23_1.top_glow.uvs[1][2] = 0
				var_23_1.bottom_glow.uvs[2][2] = 1
				var_23_2.size[2] = 0
				var_23_3.size[2] = 0
				var_23_4.color[1] = 0
				arg_23_0.top_center.local_position[2] = arg_23_1.top_center.position[2]
				arg_23_0.bottom_center.local_position[2] = arg_23_1.bottom_center.position[2]
			end,
			update = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				local var_24_0 = math.easeOutCubic(arg_24_3)

				arg_24_0.top_center.local_position[2] = arg_24_1.top_center.position[2] + 45 * var_24_0
				arg_24_0.bottom_center.local_position[2] = arg_24_1.bottom_center.position[2] + -45 * var_24_0

				local var_24_1 = arg_24_2.style
				local var_24_2 = arg_24_2.content
				local var_24_3 = var_24_2.top_glow
				local var_24_4 = var_24_2.bottom_glow
				local var_24_5 = var_24_3.uvs
				local var_24_6 = var_24_4.uvs

				var_24_5[2][2] = var_24_0
				var_24_6[1][2] = 1 - var_24_0

				local var_24_7 = var_24_1.top_glow
				local var_24_8 = var_24_1.bottom_glow
				local var_24_9 = var_24_8.size
				local var_24_10 = var_24_8.default_size
				local var_24_11 = var_24_8.offset
				local var_24_12 = var_24_8.default_offset

				var_24_9[2] = var_24_10[2] * var_24_0

				local var_24_13 = var_24_7.size
				local var_24_14 = var_24_7.default_size
				local var_24_15 = var_24_7.offset
				local var_24_16 = var_24_7.default_offset

				var_24_13[2] = var_24_14[2] * var_24_0
				var_24_15[2] = 10 - var_24_13[2]

				local var_24_17 = var_24_2.background
				local var_24_18 = var_24_1.background
				local var_24_19 = var_24_17.uvs
				local var_24_20 = arg_24_0.background
				local var_24_21 = arg_24_1.background

				var_24_20.size[2] = var_24_21.size[2] * var_24_0
				var_24_19[1][2] = 0.5 - 0.5 * var_24_0
				var_24_19[2][2] = 0.5 + 0.5 * var_24_0
				var_24_18.color[1] = 255
				arg_24_2.style.top_edge_glow.color[1] = 255 * var_24_0
				arg_24_2.style.bottom_edge_glow.color[1] = 255 * var_24_0
			end,
			on_complete = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				return
			end
		},
		{
			name = "text_entry",
			start_progress = 0.9,
			end_progress = 1.5,
			init = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				local var_26_0 = arg_26_2.style
				local var_26_1 = arg_26_2.content
			end,
			update = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				local var_27_0 = math.easeCubic(arg_27_3)
				local var_27_1 = arg_27_2.style
				local var_27_2 = arg_27_2.content
				local var_27_3 = var_27_1.area_text_style
				local var_27_4 = var_27_1.area_text_shadow_style
				local var_27_5 = 255 * var_27_0

				var_27_3.text_color[1] = var_27_5
				var_27_4.text_color[1] = var_27_5

				local var_27_6 = var_27_1.duration_text_style
				local var_27_7 = var_27_1.duration_text_shadow_style

				var_27_6.text_color[1] = var_27_5
				var_27_7.text_color[1] = var_27_5

				local var_27_8 = math.ease_pulse(math.easeInCubic(arg_27_3))
			end,
			on_complete = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				arg_28_3.render_settings.snap_pixel_positions = false
			end
		},
		{
			name = "text_minimize",
			start_progress = 5,
			end_progress = 5.3,
			init = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				local var_29_0 = arg_29_2.style
				local var_29_1 = arg_29_2.content
			end,
			update = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				local var_30_0 = math.easeOutCubic(arg_30_3)
				local var_30_1 = arg_30_2.style
				local var_30_2 = arg_30_2.content
				local var_30_3 = var_30_1.area_text_style
				local var_30_4 = var_30_1.area_text_shadow_style
				local var_30_5 = var_30_1.duration_text_style
				local var_30_6 = var_30_1.duration_text_shadow_style
				local var_30_7 = var_30_3.min_font_size
				local var_30_8 = var_30_3.default_font_size
				local var_30_9 = var_30_8 - (var_30_8 - var_30_7) * var_30_0

				var_30_3.font_size = var_30_9
				var_30_4.font_size = var_30_9
				var_30_5.font_size = var_30_9
				var_30_6.font_size = var_30_9
			end,
			on_complete = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				local var_31_0 = arg_31_2.style
				local var_31_1 = arg_31_2.content
				local var_31_2 = var_31_1.area_text_content
				local var_31_3 = var_31_1.duration_text_content

				if var_31_3 then
					local var_31_4 = arg_31_3.ui_renderer
					local var_31_5, var_31_6 = UIFontByResolution(var_31_0.area_text_style)
					local var_31_7 = var_31_5[1]
					local var_31_8 = var_31_6
					local var_31_9 = string.upper(var_31_1.area_text_content)
					local var_31_10 = UIRenderer.text_size(var_31_4, var_31_9, var_31_7, var_31_8)
					local var_31_11 = var_31_3
					local var_31_12 = UIRenderer.text_size(var_31_4, var_31_11, var_31_7, var_31_8)
					local var_31_13 = arg_31_0.area_text_background.size[1]
					local var_31_14 = arg_31_0.duration_text_background.size[1]

					arg_31_0.area_text_background.position[1] = var_31_12 * 0.5
					arg_31_0.duration_text_background.position[1] = -var_31_10 * 0.5
				end
			end
		},
		{
			name = "collapse",
			start_progress = 5,
			end_progress = 5.3,
			init = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				local var_32_0 = arg_32_2.style
				local var_32_1 = arg_32_2.content
				local var_32_2 = var_32_0.top_glow
				local var_32_3 = var_32_0.bottom_glow
				local var_32_4 = var_32_0.background

				var_32_2.size[2] = 0
				var_32_3.size[2] = 0
				var_32_4.color[1] = 0
			end,
			update = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				local var_33_0 = math.easeOutCubic(arg_33_3)
				local var_33_1 = 1 - math.easeOutCubic(arg_33_3)
				local var_33_2 = arg_33_2.style
				local var_33_3 = arg_33_2.content
				local var_33_4 = var_33_3.text_height or 45
				local var_33_5 = (90 - var_33_4) / 2

				arg_33_0.top_center.local_position[2] = arg_33_1.top_center.position[2] + 45 - var_33_5 * var_33_0
				arg_33_0.bottom_center.local_position[2] = arg_33_1.bottom_center.position[2] - 45 + var_33_5 * var_33_0

				local var_33_6 = var_33_3.top_glow
				local var_33_7 = var_33_3.bottom_glow
				local var_33_8 = var_33_6.uvs

				var_33_7.uvs[2][2] = var_33_1
				var_33_8[1][2] = 1 - var_33_1

				local var_33_9 = var_33_2.top_glow
				local var_33_10 = var_33_2.bottom_glow
				local var_33_11 = var_33_10.size
				local var_33_12 = var_33_10.default_size
				local var_33_13 = var_33_10.offset
				local var_33_14 = var_33_10.default_offset

				var_33_11[2] = var_33_12[2] * var_33_1

				local var_33_15 = var_33_9.size
				local var_33_16 = var_33_9.default_size
				local var_33_17 = var_33_9.offset
				local var_33_18 = var_33_9.default_offset

				var_33_15[2] = var_33_16[2] * var_33_1
				var_33_17[2] = 10 - var_33_15[2]

				local var_33_19 = var_33_3.background
				local var_33_20 = var_33_2.background
				local var_33_21 = var_33_19.uvs
				local var_33_22 = arg_33_0.background
				local var_33_23 = arg_33_1.background
				local var_33_24 = var_33_22.size
				local var_33_25 = var_33_23.size

				var_33_24[2] = var_33_25[2] - (var_33_25[2] - var_33_4) * var_33_0

				local var_33_26 = var_33_4 / var_33_25[2] * var_33_0

				var_33_21[1][2] = 0.5 * var_33_26
				var_33_21[2][2] = 1 - var_33_26 / 2
			end,
			on_complete = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 5,
			end_progress = 5.3,
			init = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				return
			end,
			update = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				arg_36_2.alpha_multiplier = 1 - math.easeOutCubic(arg_36_3)
			end,
			on_complete = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				arg_37_0.mission_pivot.local_position[2] = -30
			end
		},
		{
			name = "fade_in",
			start_progress = 5.3,
			end_progress = 5.6,
			init = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				return
			end,
			update = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				if Managers.state.game_mode:game_mode_key() ~= "weave" then
					arg_39_2.alpha_multiplier = math.easeOutCubic(arg_39_3)
				end
			end,
			on_complete = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				arg_40_3.render_settings.snap_pixel_positions = true
			end
		}
	}
}

return {
	animation_definitions = var_0_13,
	scenegraph_definition = var_0_5,
	widget_definitions = var_0_11,
	objective_text = var_0_10("mission_pivot")
}
