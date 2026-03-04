-- chunkname: @scripts/ui/views/mission_objective_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	64,
	64
}
local var_0_3 = {
	819,
	60
}
local var_0_4 = {
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
	pivot_parent = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			-50,
			100
		},
		size = {
			0,
			0
		}
	},
	pivot = {
		vertical_alignment = "top",
		parent = "pivot_parent",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			0,
			0
		}
	},
	mission_pivot = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			-200,
			1
		},
		size = {
			0,
			0
		}
	},
	mission_widget = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			var_0_3[1],
			var_0_3[2]
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
			var_0_2[1],
			var_0_2[2]
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
			var_0_2[1],
			var_0_2[2]
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
			var_0_3[1] / 2,
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
			-var_0_3[1] / 2,
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
			var_0_3[1] / 2,
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
			-var_0_3[1] / 2,
			-2,
			3
		}
	}
}

if not IS_WINDOWS then
	var_0_4.screen.scale = "hud_fit"
end

table.clone(Colors.color_definitions.white)[1] = 0

local var_0_5 = {
	mission_widget = {
		scenegraph_id = "mission_pivot",
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
					content_check_function = function(arg_1_0, arg_1_1)
						return arg_1_0.duration_text_content
					end
				},
				{
					style_id = "duration_text_shadow_style",
					pass_type = "text",
					text_id = "duration_text_content",
					content_check_function = function(arg_2_0, arg_2_1)
						return arg_2_0.duration_text_content
					end
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "top_center",
					style_id = "top_center",
					pass_type = "texture"
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
					texture_id = "top_detail",
					style_id = "top_detail",
					pass_type = "texture"
				},
				{
					texture_id = "top_detail_glow",
					style_id = "top_detail_glow",
					pass_type = "texture"
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
					texture_id = "bottom_center",
					style_id = "bottom_center",
					pass_type = "texture"
				},
				{
					style_id = "bottom_glow",
					pass_type = "texture_uv",
					content_id = "bottom_glow"
				},
				{
					texture_id = "bottom_edge_glow",
					style_id = "bottom_edge_glow",
					pass_type = "texture"
				},
				{
					texture_id = "frame_texture",
					style_id = "frame_texture_top_right",
					pass_type = "texture"
				},
				{
					style_id = "frame_texture_top_left",
					pass_type = "texture_uv",
					content_id = "frame_texture_top_left"
				},
				{
					texture_id = "frame_texture",
					style_id = "frame_texture_bottom_right",
					pass_type = "texture"
				},
				{
					style_id = "frame_texture_bottom_left",
					pass_type = "texture_uv",
					content_id = "frame_texture_bottom_left"
				},
				{
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					style_id = "background_texture",
					texture_id = "background_texture",
					dynamic_function = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
						local var_3_0 = arg_3_0.fraction
						local var_3_1 = arg_3_1.color
						local var_3_2 = arg_3_1.uv_start_pixels
						local var_3_3 = arg_3_1.uv_scale_pixels
						local var_3_4 = var_3_2 + var_3_3 * var_3_0
						local var_3_5 = arg_3_1.uvs
						local var_3_6 = arg_3_1.scale_axis
						local var_3_7 = (1 - var_3_4 / (var_3_2 + var_3_3)) * 0.5

						var_3_5[1][var_3_6] = var_3_7
						var_3_5[2][var_3_6] = 1 - var_3_7

						return var_3_1, var_3_5, arg_3_2, arg_3_1.offset
					end
				},
				{
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					style_id = "mission_icon_left",
					texture_id = "mission_icon_left",
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
						arg_4_2[2] = 64 * var_4_0

						local var_4_8 = arg_4_1.offset

						var_4_8[2] = (64 - arg_4_2[2]) / 4

						return var_4_1, var_4_5, arg_4_2, var_4_8
					end
				},
				{
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					style_id = "mission_icon_right",
					texture_id = "mission_icon_right",
					dynamic_function = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
						local var_5_0 = arg_5_0.fraction
						local var_5_1 = arg_5_1.color
						local var_5_2 = arg_5_1.uv_start_pixels
						local var_5_3 = arg_5_1.uv_scale_pixels
						local var_5_4 = var_5_2 + var_5_3 * var_5_0
						local var_5_5 = arg_5_1.uvs
						local var_5_6 = arg_5_1.scale_axis
						local var_5_7 = (1 - var_5_4 / (var_5_2 + var_5_3)) * 0.5

						var_5_5[1][var_5_6] = var_5_7
						var_5_5[2][var_5_6] = 1 - var_5_7
						arg_5_2[2] = 64 * var_5_0

						local var_5_8 = arg_5_1.offset

						var_5_8[2] = (64 - arg_5_2[2]) / 4

						return var_5_1, var_5_5, arg_5_2, var_5_8
					end
				}
			}
		},
		content = {
			bottom_edge_glow = "mission_objective_glow_01",
			background_texture = "hud_difficulty_notification_bg_center",
			fraction = 1,
			mission_icon_right = "hud_tutorial_icon_mission",
			area_text_content = "n/a",
			top_detail_glow = "mission_objective_glow_02",
			mission_icon_left = "hud_tutorial_icon_mission",
			top_center = "mission_objective_04",
			frame_texture = "infoslate_frame_horizontal",
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
			frame_texture_top_left = {
				texture_id = "infoslate_frame_horizontal",
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
			frame_texture_bottom_left = {
				texture_id = "infoslate_frame_horizontal",
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
			mission_icon_left = {
				uv_start_pixels = 0,
				uv_scale_pixels = 64,
				offset_scale = 1,
				scale_axis = 2,
				scenegraph_id = "mission_icon_left",
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
			},
			mission_icon_right = {
				uv_start_pixels = 0,
				uv_scale_pixels = 64,
				offset_scale = 1,
				scale_axis = 2,
				scenegraph_id = "mission_icon_right",
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
			},
			background_texture = {
				uv_start_pixels = 0,
				offset_scale = 1,
				background_component = true,
				scale_axis = 2,
				uv_scale_pixels = var_0_3[2],
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
			},
			frame_texture_top_right = {
				scenegraph_id = "frame_top_right",
				color = {
					0,
					255,
					255,
					255
				}
			},
			frame_texture_bottom_right = {
				scenegraph_id = "frame_bottom_right",
				color = {
					0,
					255,
					255,
					255
				}
			},
			frame_texture_top_left = {
				scenegraph_id = "frame_top_left",
				color = {
					0,
					255,
					255,
					255
				}
			},
			frame_texture_bottom_left = {
				scenegraph_id = "frame_bottom_left",
				color = {
					0,
					255,
					255,
					255
				}
			}
		}
	}
}
local var_0_6 = {
	mission_start = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				arg_6_3.render_settings.alpha_multiplier = 0
				arg_6_3.render_settings.snap_pixel_positions = false
				arg_6_2.style.top_edge_glow.color[1] = 0
				arg_6_2.style.bottom_edge_glow.color[1] = 0
				arg_6_0.mission_pivot.local_position[2] = arg_6_1.mission_pivot.position[2]

				local var_6_0 = arg_6_2.style
				local var_6_1 = arg_6_2.content
				local var_6_2 = var_6_0.area_text_style
				local var_6_3 = var_6_0.area_text_shadow_style

				var_6_2.font_size = var_6_2.default_font_size
				var_6_3.font_size = var_6_2.default_font_size
				var_6_2.text_color[1] = 0
				var_6_3.text_color[1] = 0

				local var_6_4 = var_6_0.duration_text_style
				local var_6_5 = var_6_0.duration_text_shadow_style

				var_6_4.font_size = var_6_4.default_font_size
				var_6_5.font_size = var_6_4.default_font_size
				var_6_4.text_color[1] = 0
				var_6_5.text_color[1] = 0
			end,
			update = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				local var_7_0 = math.easeOutCubic(arg_7_3)

				arg_7_4.render_settings.alpha_multiplier = var_7_0
			end,
			on_complete = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				return
			end
		},
		{
			name = "unfold",
			start_progress = 0.3,
			end_progress = 0.8,
			init = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				local var_9_0 = 0.1
				local var_9_1 = arg_9_2.style
				local var_9_2 = arg_9_2.content
				local var_9_3 = var_9_2.top_left
				local var_9_4 = var_9_1.top_left
				local var_9_5 = var_9_3.uvs
				local var_9_6 = arg_9_0.top_left
				local var_9_7 = arg_9_1.top_left

				var_9_6.size[1] = var_9_7.size[1] * var_9_0
				var_9_5[2][1] = var_9_0

				local var_9_8 = var_9_2.bottom_left
				local var_9_9 = var_9_1.bottom_left
				local var_9_10 = var_9_8.uvs
				local var_9_11 = arg_9_0.bottom_left
				local var_9_12 = arg_9_1.bottom_left

				var_9_11.size[1] = var_9_12.size[1] * var_9_0
				var_9_10[2][1] = var_9_0

				local var_9_13 = var_9_2.top_right
				local var_9_14 = var_9_1.top_right
				local var_9_15 = var_9_13.uvs
				local var_9_16 = arg_9_0.top_right
				local var_9_17 = arg_9_1.top_right

				var_9_16.size[1] = var_9_17.size[1] * var_9_0
				var_9_15[1][1] = 1 - var_9_0

				local var_9_18 = var_9_2.bottom_right
				local var_9_19 = var_9_1.bottom_right
				local var_9_20 = var_9_18.uvs
				local var_9_21 = arg_9_0.bottom_right
				local var_9_22 = arg_9_1.bottom_right

				var_9_21.size[1] = var_9_22.size[1] * var_9_0
				var_9_20[1][1] = 1 - var_9_0
			end,
			update = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				local var_10_0 = math.min(0.1 + math.easeInCubic(arg_10_3), 1)
				local var_10_1 = arg_10_2.style
				local var_10_2 = arg_10_2.content
				local var_10_3 = var_10_2.top_left
				local var_10_4 = var_10_1.top_left
				local var_10_5 = var_10_3.uvs
				local var_10_6 = arg_10_0.top_left
				local var_10_7 = arg_10_1.top_left

				var_10_6.size[1] = var_10_7.size[1] * var_10_0
				var_10_5[2][1] = var_10_0

				local var_10_8 = var_10_2.bottom_left
				local var_10_9 = var_10_1.bottom_left
				local var_10_10 = var_10_8.uvs
				local var_10_11 = arg_10_0.bottom_left
				local var_10_12 = arg_10_1.bottom_left

				var_10_11.size[1] = var_10_12.size[1] * var_10_0
				var_10_10[2][1] = var_10_0

				local var_10_13 = var_10_2.top_right
				local var_10_14 = var_10_1.top_right
				local var_10_15 = var_10_13.uvs
				local var_10_16 = arg_10_0.top_right
				local var_10_17 = arg_10_1.top_right

				var_10_16.size[1] = var_10_17.size[1] * var_10_0
				var_10_15[1][1] = 1 - var_10_0

				local var_10_18 = var_10_2.bottom_right
				local var_10_19 = var_10_1.bottom_right
				local var_10_20 = var_10_18.uvs
				local var_10_21 = arg_10_0.bottom_right
				local var_10_22 = arg_10_1.bottom_right

				var_10_21.size[1] = var_10_22.size[1] * var_10_0
				var_10_20[1][1] = 1 - var_10_0
			end,
			on_complete = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				return
			end
		},
		{
			name = "open",
			start_progress = 0.8,
			end_progress = 1.5,
			init = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				local var_12_0 = arg_12_2.style
				local var_12_1 = arg_12_2.content
				local var_12_2 = var_12_0.top_glow
				local var_12_3 = var_12_0.bottom_glow
				local var_12_4 = var_12_0.background

				var_12_1.top_glow.uvs[1][2] = 0
				var_12_1.bottom_glow.uvs[2][2] = 1
				var_12_2.size[2] = 0
				var_12_3.size[2] = 0
				var_12_4.color[1] = 0
				arg_12_0.top_center.local_position[2] = arg_12_1.top_center.position[2]
				arg_12_0.bottom_center.local_position[2] = arg_12_1.bottom_center.position[2]
			end,
			update = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				local var_13_0 = math.easeOutCubic(arg_13_3)

				arg_13_0.top_center.local_position[2] = arg_13_1.top_center.position[2] + 45 * var_13_0
				arg_13_0.bottom_center.local_position[2] = arg_13_1.bottom_center.position[2] + -45 * var_13_0

				local var_13_1 = arg_13_2.style
				local var_13_2 = arg_13_2.content
				local var_13_3 = var_13_2.top_glow
				local var_13_4 = var_13_2.bottom_glow
				local var_13_5 = var_13_3.uvs
				local var_13_6 = var_13_4.uvs

				var_13_5[2][2] = var_13_0
				var_13_6[1][2] = 1 - var_13_0

				local var_13_7 = var_13_1.top_glow
				local var_13_8 = var_13_1.bottom_glow
				local var_13_9 = var_13_8.size
				local var_13_10 = var_13_8.default_size
				local var_13_11 = var_13_8.offset
				local var_13_12 = var_13_8.default_offset

				var_13_9[2] = var_13_10[2] * var_13_0

				local var_13_13 = var_13_7.size
				local var_13_14 = var_13_7.default_size
				local var_13_15 = var_13_7.offset
				local var_13_16 = var_13_7.default_offset

				var_13_13[2] = var_13_14[2] * var_13_0
				var_13_15[2] = 10 - var_13_13[2]

				local var_13_17 = var_13_2.background
				local var_13_18 = var_13_1.background
				local var_13_19 = var_13_17.uvs
				local var_13_20 = arg_13_0.background
				local var_13_21 = arg_13_1.background

				var_13_20.size[2] = var_13_21.size[2] * var_13_0
				var_13_19[1][2] = 0.5 - 0.5 * var_13_0
				var_13_19[2][2] = 0.5 + 0.5 * var_13_0
				var_13_18.color[1] = 255
				arg_13_2.style.top_edge_glow.color[1] = 255 * var_13_0
				arg_13_2.style.bottom_edge_glow.color[1] = 255 * var_13_0
			end,
			on_complete = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				return
			end
		},
		{
			name = "text_entry",
			start_progress = 0.9,
			end_progress = 1.5,
			init = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				local var_15_0 = arg_15_2.style
				local var_15_1 = arg_15_2.content
			end,
			update = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				local var_16_0 = math.easeCubic(arg_16_3)
				local var_16_1 = arg_16_2.style
				local var_16_2 = arg_16_2.content
				local var_16_3 = var_16_1.area_text_style
				local var_16_4 = var_16_1.area_text_shadow_style
				local var_16_5 = 255 * var_16_0

				var_16_3.text_color[1] = var_16_5
				var_16_4.text_color[1] = var_16_5

				local var_16_6 = var_16_1.duration_text_style
				local var_16_7 = var_16_1.duration_text_shadow_style

				var_16_6.text_color[1] = var_16_5
				var_16_7.text_color[1] = var_16_5

				local var_16_8 = math.ease_pulse(math.easeInCubic(arg_16_3))
			end,
			on_complete = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				arg_17_3.render_settings.snap_pixel_positions = false
			end
		},
		{
			name = "text_minimize",
			start_progress = 5,
			end_progress = 5.3,
			init = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				local var_18_0 = arg_18_2.style
				local var_18_1 = arg_18_2.content
			end,
			update = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				local var_19_0 = math.easeOutCubic(arg_19_3)
				local var_19_1 = arg_19_2.style
				local var_19_2 = arg_19_2.content
				local var_19_3 = var_19_1.area_text_style
				local var_19_4 = var_19_1.area_text_shadow_style
				local var_19_5 = var_19_1.duration_text_style
				local var_19_6 = var_19_1.duration_text_shadow_style
				local var_19_7 = var_19_3.min_font_size
				local var_19_8 = var_19_3.default_font_size
				local var_19_9 = var_19_8 - (var_19_8 - var_19_7) * var_19_0

				var_19_3.font_size = var_19_9
				var_19_4.font_size = var_19_9
				var_19_5.font_size = var_19_9
				var_19_6.font_size = var_19_9
			end,
			on_complete = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				local var_20_0 = arg_20_2.style
				local var_20_1 = arg_20_2.content
				local var_20_2 = var_20_1.area_text_content
				local var_20_3 = var_20_1.duration_text_content

				if var_20_3 then
					local var_20_4 = arg_20_3.ui_renderer
					local var_20_5, var_20_6 = UIFontByResolution(var_20_0.area_text_style)
					local var_20_7 = var_20_5[1]
					local var_20_8 = var_20_6
					local var_20_9 = string.upper(var_20_1.area_text_content)
					local var_20_10 = UIRenderer.text_size(var_20_4, var_20_9, var_20_7, var_20_8)
					local var_20_11 = var_20_3
					local var_20_12 = UIRenderer.text_size(var_20_4, var_20_11, var_20_7, var_20_8)
					local var_20_13 = arg_20_0.area_text_background.size[1]
					local var_20_14 = arg_20_0.duration_text_background.size[1]

					arg_20_0.area_text_background.position[1] = var_20_12 * 0.5
					arg_20_0.duration_text_background.position[1] = -var_20_10 * 0.5
				end
			end
		},
		{
			name = "collapse",
			start_progress = 5,
			end_progress = 5.3,
			init = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				local var_21_0 = arg_21_2.style
				local var_21_1 = arg_21_2.content
				local var_21_2 = var_21_0.top_glow
				local var_21_3 = var_21_0.bottom_glow
				local var_21_4 = var_21_0.background

				var_21_2.size[2] = 0
				var_21_3.size[2] = 0
				var_21_4.color[1] = 0
			end,
			update = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				local var_22_0 = math.easeOutCubic(arg_22_3)
				local var_22_1 = 1 - math.easeOutCubic(arg_22_3)
				local var_22_2 = arg_22_2.style
				local var_22_3 = arg_22_2.content
				local var_22_4 = var_22_3.text_height
				local var_22_5 = (90 - var_22_4) / 2

				arg_22_0.top_center.local_position[2] = arg_22_1.top_center.position[2] + 45 - var_22_5 * var_22_0
				arg_22_0.bottom_center.local_position[2] = arg_22_1.bottom_center.position[2] - 45 + var_22_5 * var_22_0

				local var_22_6 = var_22_3.top_glow
				local var_22_7 = var_22_3.bottom_glow
				local var_22_8 = var_22_6.uvs

				var_22_7.uvs[2][2] = var_22_1
				var_22_8[1][2] = 1 - var_22_1

				local var_22_9 = var_22_2.top_glow
				local var_22_10 = var_22_2.bottom_glow
				local var_22_11 = var_22_10.size
				local var_22_12 = var_22_10.default_size
				local var_22_13 = var_22_10.offset
				local var_22_14 = var_22_10.default_offset

				var_22_11[2] = var_22_12[2] * var_22_1

				local var_22_15 = var_22_9.size
				local var_22_16 = var_22_9.default_size
				local var_22_17 = var_22_9.offset
				local var_22_18 = var_22_9.default_offset

				var_22_15[2] = var_22_16[2] * var_22_1
				var_22_17[2] = 10 - var_22_15[2]

				local var_22_19 = var_22_3.background
				local var_22_20 = var_22_2.background
				local var_22_21 = var_22_19.uvs
				local var_22_22 = arg_22_0.background
				local var_22_23 = arg_22_1.background
				local var_22_24 = var_22_22.size
				local var_22_25 = var_22_23.size

				var_22_24[2] = var_22_25[2] - (var_22_25[2] - var_22_4) * var_22_0

				local var_22_26 = var_22_4 / var_22_25[2] * var_22_0

				var_22_21[1][2] = 0.5 * var_22_26
				var_22_21[2][2] = 1 - var_22_26 / 2
			end,
			on_complete = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 5,
			end_progress = 5.3,
			init = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				return
			end,
			update = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				local var_25_0 = math.easeOutCubic(arg_25_3)

				arg_25_4.render_settings.alpha_multiplier = 1 - var_25_0
			end,
			on_complete = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				arg_26_0.mission_pivot.local_position[2] = 0
			end
		},
		{
			name = "fade_in",
			start_progress = 5.3,
			end_progress = 5.6,
			init = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				return
			end,
			update = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				if Managers.state.game_mode:game_mode_key() ~= "weave" then
					local var_28_0 = math.easeOutCubic(arg_28_3)

					arg_28_4.render_settings.alpha_multiplier = var_28_0
				end
			end,
			on_complete = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				arg_29_3.render_settings.snap_pixel_positions = true
			end
		}
	},
	mission_end = {
		{
			name = "exit",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				arg_30_3.render_settings.alpha_multiplier = 0
				arg_30_3.render_settings.snap_pixel_positions = false
			end,
			update = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
				if Managers.state.game_mode:game_mode_key() ~= "weave" then
					local var_31_0 = math.easeOutCubic(arg_31_3)

					arg_31_4.render_settings.alpha_multiplier = 1 - var_31_0
				end
			end,
			on_complete = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				local var_32_0 = arg_32_2.style
				local var_32_1 = arg_32_2.content
				local var_32_2 = var_32_0.area_text_style
				local var_32_3 = var_32_0.area_text_shadow_style

				var_32_2.font_size = var_32_2.default_font_size
				var_32_3.font_size = var_32_2.default_font_size

				local var_32_4 = var_32_0.duration_text_style
				local var_32_5 = var_32_0.duration_text_shadow_style

				var_32_4.font_size = var_32_4.default_font_size
				var_32_5.font_size = var_32_4.default_font_size
			end
		}
	}
}

return {
	animation_definitions = var_0_6,
	scenegraph_definition = var_0_4,
	widget_definitions = var_0_5
}
