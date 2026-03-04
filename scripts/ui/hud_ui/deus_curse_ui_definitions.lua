-- chunkname: @scripts/ui/hud_ui/deus_curse_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	819,
	60
}
local var_0_3 = {
	0,
	20
}
local var_0_4 = 100
local var_0_5 = var_0_4
local var_0_6 = 1000

var_0_2[2] = var_0_2[2] + var_0_5 + var_0_3[2] * 2

local var_0_7 = {
	change_widget_height = function (arg_1_0)
		var_0_5 = math.min(var_0_4, arg_1_0)
	end
}
local var_0_8 = {
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
	pivot = {
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
	theme_icon = {
		vertical_alignment = "center",
		parent = "title_text",
		horizontal_alignment = "center",
		position = {
			0,
			30,
			1
		},
		size = {
			50,
			50
		}
	},
	curse_name = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			-75,
			1
		},
		size = {
			1000,
			50
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "curse_name",
		horizontal_alignment = "center",
		position = {
			0,
			25,
			1
		},
		size = {
			1000,
			30
		}
	},
	description_pivot = {
		vertical_alignment = "top",
		parent = "curse_name",
		horizontal_alignment = "center",
		position = {
			0,
			-var_0_5 - 25,
			1
		},
		size = {
			0,
			0
		}
	},
	description_widget = {
		vertical_alignment = "top",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			var_0_2[1],
			var_0_2[2]
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "description_pivot",
		horizontal_alignment = "center",
		size = {
			var_0_6,
			var_0_5 + var_0_3[2]
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
			var_0_6,
			var_0_5
		},
		position = {
			0,
			0,
			0
		}
	},
	top_center = {
		vertical_alignment = "center",
		parent = "description_pivot",
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
			var_0_6 / 2,
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
			var_0_6 / 2,
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
			54
		},
		position = {
			0,
			0,
			8
		}
	},
	bottom_center = {
		vertical_alignment = "center",
		parent = "description_pivot",
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
			var_0_6 / 2,
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
			var_0_6 / 2,
			6
		},
		position = {
			31,
			-3,
			-1
		}
	},
	frame_top_right = {
		vertical_alignment = "top",
		parent = "description_widget",
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
		parent = "description_widget",
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
		parent = "description_widget",
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
		parent = "description_widget",
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

if not IS_WINDOWS then
	var_0_8.screen.scale = "hud_fit"
end

table.clone(Colors.color_definitions.white)[1] = 0

local var_0_9 = {
	description_widget = {
		scenegraph_id = "description_pivot",
		element = {
			passes = {
				{
					texture_id = "theme_icon",
					style_id = "theme_icon",
					pass_type = "texture",
					content_check_function = function (arg_2_0)
						return arg_2_0.theme_icon ~= nil
					end
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
					style_id = "curse_name",
					pass_type = "text",
					text_id = "curse_name"
				},
				{
					style_id = "curse_name_shadow",
					pass_type = "text",
					text_id = "curse_name"
				},
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
					dynamic_function = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
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
				}
			}
		},
		content = {
			title_text = "",
			bottom_edge_glow = "curse_description_glow_01",
			fraction = 1,
			background_texture = "hud_difficulty_notification_bg_center",
			area_text_content = "n/a",
			top_detail_glow = "curse_description_glow_02",
			top_center = "mission_objective_04",
			frame_texture = "infoslate_frame_horizontal",
			curse_name = "",
			bottom_center = "mission_objective_02",
			top_detail = "curse_description_01",
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
				texture_id = "mission_objective_white_top",
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
				texture_id = "mission_objective_white_bottom",
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
				texture_id = "curse_description_glow_01",
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
			theme_icon = {
				scenegraph_id = "theme_icon",
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
					var_0_6 + 44,
					90
				},
				default_size = {
					var_0_6 + 44,
					90
				},
				offset = {
					27 - (var_0_6 + 44) / 2,
					-80,
					-4
				},
				default_offset = {
					27 - (var_0_6 + 44) / 2,
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
					var_0_6 + 44,
					16
				},
				default_size = {
					var_0_6 + 44,
					16
				},
				offset = {
					27 - (var_0_6 + 44) / 2,
					-6,
					-4
				},
				default_offset = {
					27 - (var_0_6 + 44) / 2,
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
					4,
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
					var_0_6 + 44,
					90
				},
				default_size = {
					var_0_6 + 44,
					90
				},
				offset = {
					27 - (var_0_6 + 44) / 2,
					10,
					-4
				},
				default_offset = {
					27 - (var_0_6 + 44) / 2,
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
					var_0_6 + 44,
					16
				},
				default_size = {
					var_0_6 + 44,
					16
				},
				offset = {
					27 - (var_0_6 + 44) / 2,
					10,
					-4
				},
				default_offset = {
					27 - (var_0_6 + 44) / 2,
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
			title_text = {
				upper_case = true,
				localize = false,
				font_size = 16,
				word_wrap = true,
				horizontal_alignment = "center",
				scenegraph_id = "title_text",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-1,
					11
				}
			},
			title_text_shadow = {
				upper_case = true,
				localize = false,
				font_size = 16,
				word_wrap = true,
				horizontal_alignment = "center",
				scenegraph_id = "title_text",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-3,
					10
				}
			},
			curse_name = {
				upper_case = true,
				localize = false,
				font_size = 32,
				word_wrap = true,
				horizontal_alignment = "center",
				scenegraph_id = "curse_name",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-1,
					11
				}
			},
			curse_name_shadow = {
				upper_case = true,
				localize = false,
				font_size = 32,
				word_wrap = true,
				horizontal_alignment = "center",
				scenegraph_id = "curse_name",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-3,
					10
				}
			},
			area_text_style = {
				min_font_size = 12,
				upper_case = true,
				localize = false,
				dynamic_font_size_word_wrap = true,
				default_font_size = 30,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_size = 30,
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
				min_font_size = 12,
				upper_case = true,
				localize = false,
				dynamic_font_size_word_wrap = true,
				default_font_size = 30,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_size = 30,
				scenegraph_id = "area_text_background",
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
local var_0_10 = {
	description_start = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 0
				arg_4_3.render_settings.snap_pixel_positions = false
				arg_4_2.style.top_edge_glow.color[1] = 0
				arg_4_2.style.bottom_edge_glow.color[1] = 0

				local var_4_0 = arg_4_1.description_pivot.position

				arg_4_0.description_pivot.local_position[2] = var_4_0[2]

				local var_4_1 = arg_4_2.style
				local var_4_2 = var_4_1.area_text_style
				local var_4_3 = var_4_1.area_text_shadow_style

				var_4_2.font_size = var_4_2.default_font_size
				var_4_3.font_size = var_4_2.default_font_size
				var_4_2.text_color[1] = 0
				var_4_3.text_color[1] = 0

				local var_4_4 = arg_4_0.background
				local var_4_5 = arg_4_1.background

				var_4_4.size[2] = var_4_5.size[2]
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = var_5_0
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		},
		{
			name = "unfold",
			start_progress = 0.3,
			end_progress = 0.8,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				local var_7_0 = 0.1
				local var_7_1 = arg_7_2.content
				local var_7_2 = var_7_1.top_left.uvs
				local var_7_3 = arg_7_0.top_left
				local var_7_4 = arg_7_1.top_left

				var_7_3.size[1] = var_7_4.size[1] * var_7_0
				var_7_2[2][1] = var_7_0

				local var_7_5 = var_7_1.bottom_left.uvs
				local var_7_6 = arg_7_0.bottom_left
				local var_7_7 = arg_7_1.bottom_left

				var_7_6.size[1] = var_7_7.size[1] * var_7_0
				var_7_5[2][1] = var_7_0

				local var_7_8 = var_7_1.top_right.uvs
				local var_7_9 = arg_7_0.top_right
				local var_7_10 = arg_7_1.top_right

				var_7_9.size[1] = var_7_10.size[1] * var_7_0
				var_7_8[1][1] = 1 - var_7_0

				local var_7_11 = var_7_1.bottom_right.uvs
				local var_7_12 = arg_7_0.bottom_right
				local var_7_13 = arg_7_1.bottom_right

				var_7_12.size[1] = var_7_13.size[1] * var_7_0
				var_7_11[1][1] = 1 - var_7_0
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = math.min(0.1 + math.easeInCubic(arg_8_3), 1)
				local var_8_1 = arg_8_2.content
				local var_8_2 = var_8_1.top_left.uvs
				local var_8_3 = arg_8_0.top_left
				local var_8_4 = arg_8_1.top_left

				var_8_3.size[1] = var_8_4.size[1] * var_8_0
				var_8_2[2][1] = var_8_0

				local var_8_5 = var_8_1.bottom_left.uvs
				local var_8_6 = arg_8_0.bottom_left
				local var_8_7 = arg_8_1.bottom_left

				var_8_6.size[1] = var_8_7.size[1] * var_8_0
				var_8_5[2][1] = var_8_0

				local var_8_8 = var_8_1.top_right.uvs
				local var_8_9 = arg_8_0.top_right
				local var_8_10 = arg_8_1.top_right

				var_8_9.size[1] = var_8_10.size[1] * var_8_0
				var_8_8[1][1] = 1 - var_8_0

				local var_8_11 = var_8_1.bottom_right.uvs
				local var_8_12 = arg_8_0.bottom_right
				local var_8_13 = arg_8_1.bottom_right

				var_8_12.size[1] = var_8_13.size[1] * var_8_0
				var_8_11[1][1] = 1 - var_8_0
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		},
		{
			name = "open",
			start_progress = 0.8,
			end_progress = 1.5,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				local var_10_0 = arg_10_2.style
				local var_10_1 = arg_10_2.content
				local var_10_2 = var_10_0.top_glow
				local var_10_3 = var_10_0.bottom_glow
				local var_10_4 = var_10_0.background

				var_10_1.top_glow.uvs[1][2] = 0
				var_10_1.bottom_glow.uvs[2][2] = 1
				var_10_2.size[2] = 0
				var_10_3.size[2] = 0
				var_10_4.color[1] = 0
				arg_10_0.top_center.local_position[2] = arg_10_1.top_center.position[2]
				arg_10_0.bottom_center.local_position[2] = arg_10_1.bottom_center.position[2]
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				local var_11_0 = math.easeOutCubic(arg_11_3)

				arg_11_0.top_center.local_position[2] = arg_11_1.top_center.position[2] + (var_0_5 + var_0_3[2]) / 2 * var_11_0
				arg_11_0.bottom_center.local_position[2] = arg_11_1.bottom_center.position[2] + -((var_0_5 + var_0_3[2]) / 2) * var_11_0

				local var_11_1 = arg_11_2.style
				local var_11_2 = arg_11_2.content
				local var_11_3 = var_11_2.top_glow
				local var_11_4 = var_11_2.bottom_glow
				local var_11_5 = var_11_3.uvs
				local var_11_6 = var_11_4.uvs

				var_11_5[2][2] = var_11_0
				var_11_6[1][2] = 1 - var_11_0

				local var_11_7 = var_11_1.top_glow
				local var_11_8 = var_11_1.bottom_glow

				var_11_8.size[2] = var_11_8.default_size[2] * var_11_0

				local var_11_9 = var_11_7.size
				local var_11_10 = var_11_7.default_size
				local var_11_11 = var_11_7.offset

				var_11_9[2] = var_11_10[2] * var_11_0
				var_11_11[2] = 10 - var_11_9[2]

				local var_11_12 = var_11_2.background
				local var_11_13 = var_11_1.background
				local var_11_14 = var_11_12.uvs

				arg_11_0.background.size[2] = ({
					var_0_6,
					var_0_5 + var_0_3[2]
				})[2] * var_11_0
				var_11_14[1][2] = 0.5 - 0.5 * var_11_0
				var_11_14[2][2] = 0.5 + 0.5 * var_11_0
				var_11_13.color[1] = 255
				arg_11_2.style.top_edge_glow.color[1] = 255 * var_11_0
				arg_11_2.style.bottom_edge_glow.color[1] = 255 * var_11_0
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end
		},
		{
			name = "text_entry",
			start_progress = 0.9,
			end_progress = 1.5,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				local var_14_0 = math.easeCubic(arg_14_3)
				local var_14_1 = arg_14_2.style
				local var_14_2 = var_14_1.area_text_style
				local var_14_3 = var_14_1.area_text_shadow_style
				local var_14_4 = 255 * var_14_0

				var_14_2.text_color[1] = var_14_4
				var_14_3.text_color[1] = var_14_4
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				arg_15_3.render_settings.snap_pixel_positions = false
			end
		}
	},
	description_end = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				local var_17_0 = math.easeOutCubic(arg_17_3)

				arg_17_4.render_settings.alpha_multiplier = 1 - var_17_0
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				arg_18_0.description_pivot.local_position[2] = 0
			end
		}
	}
}

return {
	animation_definitions = var_0_10,
	scenegraph_definition = var_0_8,
	widget_definitions = var_0_9,
	scenegraph_methods = var_0_7,
	text_background_width = var_0_6
}
