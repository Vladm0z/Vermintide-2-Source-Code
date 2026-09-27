-- chunkname: @scripts/ui/views/mission_objective_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	64,
	64
}
local tbl_2 = {
	819,
	60
}
local tbl_3 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			num,
			num_2
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
			tbl_2[1],
			tbl_2[2]
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
			tbl[1],
			tbl[2]
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
			tbl[1],
			tbl[2]
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
			tbl_2[1] / 2,
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
			-tbl_2[1] / 2,
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
			tbl_2[1] / 2,
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
			-tbl_2[1] / 2,
			-2,
			3
		}
	}
}

if not IS_WINDOWS then
	tbl_3.screen.scale = "hud_fit"
end

table.clone(Colors.color_definitions.white)[1] = 0

local tbl_4 = {
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
					content_check_function = function (self, arg_1_1)
						-- function 1
						return self.duration_text_content
					end
				},
				{
					style_id = "duration_text_shadow_style",
					pass_type = "text",
					text_id = "duration_text_content",
					content_check_function = function (self, arg_2_1)
						-- function 2
						return self.duration_text_content
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
					dynamic_function = function (self, arg_3_1, arg_3_2, arg_3_3)
						-- function 3
						local fraction = self.fraction
						local color = arg_3_1.color
						local uv_start_pixels = arg_3_1.uv_start_pixels
						local uv_scale_pixels = arg_3_1.uv_scale_pixels
						local num = uv_start_pixels + uv_scale_pixels * fraction
						local uvs = arg_3_1.uvs
						local scale_axis = arg_3_1.scale_axis
						local num_2 = (1 - num / (uv_start_pixels + uv_scale_pixels)) * 0.5

						uvs[1][scale_axis] = num_2
						uvs[2][scale_axis] = 1 - num_2

						return color, uvs, arg_3_2, arg_3_1.offset
					end
				},
				{
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					style_id = "mission_icon_left",
					texture_id = "mission_icon_left",
					dynamic_function = function (self, arg_4_1, arg_4_2, arg_4_3)
						-- function 4
						local fraction = self.fraction
						local color = arg_4_1.color
						local uv_start_pixels = arg_4_1.uv_start_pixels
						local uv_scale_pixels = arg_4_1.uv_scale_pixels
						local num = uv_start_pixels + uv_scale_pixels * fraction
						local uvs = arg_4_1.uvs
						local scale_axis = arg_4_1.scale_axis
						local num_2 = (1 - num / (uv_start_pixels + uv_scale_pixels)) * 0.5

						uvs[1][scale_axis] = num_2
						uvs[2][scale_axis] = 1 - num_2
						arg_4_2[2] = 64 * fraction

						local offset = arg_4_1.offset

						offset[2] = (64 - arg_4_2[2]) / 4

						return color, uvs, arg_4_2, offset
					end
				},
				{
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					style_id = "mission_icon_right",
					texture_id = "mission_icon_right",
					dynamic_function = function (self, arg_5_1, arg_5_2, arg_5_3)
						-- function 5
						local fraction = self.fraction
						local color = arg_5_1.color
						local uv_start_pixels = arg_5_1.uv_start_pixels
						local uv_scale_pixels = arg_5_1.uv_scale_pixels
						local num = uv_start_pixels + uv_scale_pixels * fraction
						local uvs = arg_5_1.uvs
						local scale_axis = arg_5_1.scale_axis
						local num_2 = (1 - num / (uv_start_pixels + uv_scale_pixels)) * 0.5

						uvs[1][scale_axis] = num_2
						uvs[2][scale_axis] = 1 - num_2
						arg_5_2[2] = 64 * fraction

						local offset = arg_5_1.offset

						offset[2] = (64 - arg_5_2[2]) / 4

						return color, uvs, arg_5_2, offset
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
				uv_scale_pixels = tbl_2[2],
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
local tbl_5 = {
	mission_start = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				arg_6_3.render_settings.alpha_multiplier = 0
				arg_6_3.render_settings.snap_pixel_positions = false
				arg_6_2.style.top_edge_glow.color[1] = 0
				arg_6_2.style.bottom_edge_glow.color[1] = 0
				arg_6_0.mission_pivot.local_position[2] = arg_6_1.mission_pivot.position[2]

				local style = arg_6_2.style
				local content = arg_6_2.content
				local area_text_style = style.area_text_style
				local area_text_shadow_style = style.area_text_shadow_style

				area_text_style.font_size = area_text_style.default_font_size
				area_text_shadow_style.font_size = area_text_style.default_font_size
				area_text_style.text_color[1] = 0
				area_text_shadow_style.text_color[1] = 0

				local duration_text_style = style.duration_text_style
				local duration_text_shadow_style = style.duration_text_shadow_style

				duration_text_style.font_size = duration_text_style.default_font_size
				duration_text_shadow_style.font_size = duration_text_style.default_font_size
				duration_text_style.text_color[1] = 0
				duration_text_shadow_style.text_color[1] = 0
			end,
			update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				-- function 7
				local easeOutCubic = math.easeOutCubic(arg_7_3)

				arg_7_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				return
			end
		},
		{
			name = "unfold",
			start_progress = 0.3,
			end_progress = 0.8,
			init = function (self, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				local num = 0.1
				local style = arg_9_2.style
				local content = arg_9_2.content
				local top_left = content.top_left
				local top_left_2 = style.top_left
				local uvs = top_left.uvs
				local top_left_3 = self.top_left
				local top_left_4 = arg_9_1.top_left

				top_left_3.size[1] = top_left_4.size[1] * num
				uvs[2][1] = num

				local bottom_left = content.bottom_left
				local bottom_left_2 = style.bottom_left
				local uvs_2 = bottom_left.uvs
				local bottom_left_3 = self.bottom_left
				local bottom_left_4 = arg_9_1.bottom_left

				bottom_left_3.size[1] = bottom_left_4.size[1] * num
				uvs_2[2][1] = num

				local top_right = content.top_right
				local top_right_2 = style.top_right
				local uvs_3 = top_right.uvs
				local top_right_3 = self.top_right
				local top_right_4 = arg_9_1.top_right

				top_right_3.size[1] = top_right_4.size[1] * num
				uvs_3[1][1] = 1 - num

				local bottom_right = content.bottom_right
				local bottom_right_2 = style.bottom_right
				local uvs_4 = bottom_right.uvs
				local bottom_right_3 = self.bottom_right
				local bottom_right_4 = arg_9_1.bottom_right

				bottom_right_3.size[1] = bottom_right_4.size[1] * num
				uvs_4[1][1] = 1 - num
			end,
			update = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				-- function 10
				local min = math.min(0.1 + math.easeInCubic(arg_10_3), 1)
				local style = arg_10_2.style
				local content = arg_10_2.content
				local top_left = content.top_left
				local top_left_2 = style.top_left
				local uvs = top_left.uvs
				local top_left_3 = self.top_left
				local top_left_4 = arg_10_1.top_left

				top_left_3.size[1] = top_left_4.size[1] * min
				uvs[2][1] = min

				local bottom_left = content.bottom_left
				local bottom_left_2 = style.bottom_left
				local uvs_2 = bottom_left.uvs
				local bottom_left_3 = self.bottom_left
				local bottom_left_4 = arg_10_1.bottom_left

				bottom_left_3.size[1] = bottom_left_4.size[1] * min
				uvs_2[2][1] = min

				local top_right = content.top_right
				local top_right_2 = style.top_right
				local uvs_3 = top_right.uvs
				local top_right_3 = self.top_right
				local top_right_4 = arg_10_1.top_right

				top_right_3.size[1] = top_right_4.size[1] * min
				uvs_3[1][1] = 1 - min

				local bottom_right = content.bottom_right
				local bottom_right_2 = style.bottom_right
				local uvs_4 = bottom_right.uvs
				local bottom_right_3 = self.bottom_right
				local bottom_right_4 = arg_10_1.bottom_right

				bottom_right_3.size[1] = bottom_right_4.size[1] * min
				uvs_4[1][1] = 1 - min
			end,
			on_complete = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				return
			end
		},
		{
			name = "open",
			start_progress = 0.8,
			end_progress = 1.5,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				local style = arg_12_2.style
				local content = arg_12_2.content
				local top_glow = style.top_glow
				local bottom_glow = style.bottom_glow
				local background = style.background

				content.top_glow.uvs[1][2] = 0
				content.bottom_glow.uvs[2][2] = 1
				top_glow.size[2] = 0
				bottom_glow.size[2] = 0
				background.color[1] = 0
				arg_12_0.top_center.local_position[2] = arg_12_1.top_center.position[2]
				arg_12_0.bottom_center.local_position[2] = arg_12_1.bottom_center.position[2]
			end,
			update = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				-- function 13
				local easeOutCubic = math.easeOutCubic(arg_13_3)

				self.top_center.local_position[2] = arg_13_1.top_center.position[2] + 45 * easeOutCubic
				self.bottom_center.local_position[2] = arg_13_1.bottom_center.position[2] + -45 * easeOutCubic

				local style = arg_13_2.style
				local content = arg_13_2.content
				local top_glow = content.top_glow
				local bottom_glow = content.bottom_glow
				local uvs = top_glow.uvs
				local uvs_2 = bottom_glow.uvs

				uvs[2][2] = easeOutCubic
				uvs_2[1][2] = 1 - easeOutCubic

				local top_glow_2 = style.top_glow
				local bottom_glow_2 = style.bottom_glow
				local size = bottom_glow_2.size
				local default_size = bottom_glow_2.default_size
				local offset = bottom_glow_2.offset
				local default_offset = bottom_glow_2.default_offset

				size[2] = default_size[2] * easeOutCubic

				local size_2 = top_glow_2.size
				local default_size_2 = top_glow_2.default_size
				local offset_2 = top_glow_2.offset
				local default_offset_2 = top_glow_2.default_offset

				size_2[2] = default_size_2[2] * easeOutCubic
				offset_2[2] = 10 - size_2[2]

				local background = content.background
				local background_2 = style.background
				local uvs_3 = background.uvs
				local background_3 = self.background
				local background_4 = arg_13_1.background

				background_3.size[2] = background_4.size[2] * easeOutCubic
				uvs_3[1][2] = 0.5 - 0.5 * easeOutCubic
				uvs_3[2][2] = 0.5 + 0.5 * easeOutCubic
				background_2.color[1] = 255
				arg_13_2.style.top_edge_glow.color[1] = 255 * easeOutCubic
				arg_13_2.style.bottom_edge_glow.color[1] = 255 * easeOutCubic
			end,
			on_complete = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				return
			end
		},
		{
			name = "text_entry",
			start_progress = 0.9,
			end_progress = 1.5,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				local style = arg_15_2.style
				local content = arg_15_2.content
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				-- function 16
				local easeCubic = math.easeCubic(arg_16_3)
				local style = arg_16_2.style
				local content = arg_16_2.content
				local area_text_style = style.area_text_style
				local area_text_shadow_style = style.area_text_shadow_style
				local num = 255 * easeCubic

				area_text_style.text_color[1] = num
				area_text_shadow_style.text_color[1] = num

				local duration_text_style = style.duration_text_style
				local duration_text_shadow_style = style.duration_text_shadow_style

				duration_text_style.text_color[1] = num
				duration_text_shadow_style.text_color[1] = num

				local ease_pulse = math.ease_pulse(math.easeInCubic(arg_16_3))
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				arg_17_3.render_settings.snap_pixel_positions = false
			end
		},
		{
			name = "text_minimize",
			start_progress = 5,
			end_progress = 5.3,
			init = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				local style = arg_18_2.style
				local content = arg_18_2.content
			end,
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				-- function 19
				local easeOutCubic = math.easeOutCubic(arg_19_3)
				local style = arg_19_2.style
				local content = arg_19_2.content
				local area_text_style = style.area_text_style
				local area_text_shadow_style = style.area_text_shadow_style
				local duration_text_style = style.duration_text_style
				local duration_text_shadow_style = style.duration_text_shadow_style
				local min_font_size = area_text_style.min_font_size
				local default_font_size = area_text_style.default_font_size
				local num = default_font_size - (default_font_size - min_font_size) * easeOutCubic

				area_text_style.font_size = num
				area_text_shadow_style.font_size = num
				duration_text_style.font_size = num
				duration_text_shadow_style.font_size = num
			end,
			on_complete = function (self, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				local style = arg_20_2.style
				local content = arg_20_2.content
				local area_text_content = content.area_text_content
				local duration_text_content = content.duration_text_content

				if not duration_text_content then
					local ui_renderer = arg_20_3.ui_renderer
					local var_20_5, var_20_6 = UIFontByResolution(style.area_text_style)
					local var_20_7 = var_20_5[1]
					local var_20_8 = var_20_6
					local upper = string.upper(content.area_text_content)
					local text_size = UIRenderer.text_size(ui_renderer, upper, var_20_7, var_20_8)
					local var_20_11 = duration_text_content
					local text_size_2 = UIRenderer.text_size(ui_renderer, var_20_11, var_20_7, var_20_8)
					local var_20_13 = self.area_text_background.size[1]
					local var_20_14 = self.duration_text_background.size[1]

					self.area_text_background.position[1] = text_size_2 * 0.5
					self.duration_text_background.position[1] = -text_size * 0.5
				end
			end
		},
		{
			name = "collapse",
			start_progress = 5,
			end_progress = 5.3,
			init = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				local style = arg_21_2.style
				local content = arg_21_2.content
				local top_glow = style.top_glow
				local bottom_glow = style.bottom_glow
				local background = style.background

				top_glow.size[2] = 0
				bottom_glow.size[2] = 0
				background.color[1] = 0
			end,
			update = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				-- function 22
				local easeOutCubic = math.easeOutCubic(arg_22_3)
				local num = 1 - math.easeOutCubic(arg_22_3)
				local style = arg_22_2.style
				local content = arg_22_2.content
				local text_height = content.text_height
				local num_2 = (90 - text_height) / 2

				self.top_center.local_position[2] = arg_22_1.top_center.position[2] + 45 - num_2 * easeOutCubic
				self.bottom_center.local_position[2] = arg_22_1.bottom_center.position[2] - 45 + num_2 * easeOutCubic

				local top_glow = content.top_glow
				local bottom_glow = content.bottom_glow
				local uvs = top_glow.uvs

				bottom_glow.uvs[2][2] = num
				uvs[1][2] = 1 - num

				local top_glow_2 = style.top_glow
				local bottom_glow_2 = style.bottom_glow
				local size = bottom_glow_2.size
				local default_size = bottom_glow_2.default_size
				local offset = bottom_glow_2.offset
				local default_offset = bottom_glow_2.default_offset

				size[2] = default_size[2] * num

				local size_2 = top_glow_2.size
				local default_size_2 = top_glow_2.default_size
				local offset_2 = top_glow_2.offset
				local default_offset_2 = top_glow_2.default_offset

				size_2[2] = default_size_2[2] * num
				offset_2[2] = 10 - size_2[2]

				local background = content.background
				local background_2 = style.background
				local uvs_2 = background.uvs
				local background_3 = self.background
				local background_4 = arg_22_1.background
				local size_3 = background_3.size
				local size_4 = background_4.size

				size_3[2] = size_4[2] - (size_4[2] - text_height) * easeOutCubic

				local num_3 = text_height / size_4[2] * easeOutCubic

				uvs_2[1][2] = 0.5 * num_3
				uvs_2[2][2] = 1 - num_3 / 2
			end,
			on_complete = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				-- function 23
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 5,
			end_progress = 5.3,
			init = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				-- function 24
				return
			end,
			update = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				-- function 25
				local easeOutCubic = math.easeOutCubic(arg_25_3)

				arg_25_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				arg_26_0.mission_pivot.local_position[2] = 0
			end
		},
		{
			name = "fade_in",
			start_progress = 5.3,
			end_progress = 5.6,
			init = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				return
			end,
			update = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				-- function 28
				if Managers.state.game_mode:game_mode_key() ~= "weave" then
					local easeOutCubic = math.easeOutCubic(arg_28_3)

					arg_28_4.render_settings.alpha_multiplier = easeOutCubic
				end
			end,
			on_complete = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				arg_29_3.render_settings.snap_pixel_positions = true
			end
		}
	},
	mission_end = {
		{
			name = "exit",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				-- function 30
				arg_30_3.render_settings.alpha_multiplier = 0
				arg_30_3.render_settings.snap_pixel_positions = false
			end,
			update = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
				-- function 31
				if Managers.state.game_mode:game_mode_key() ~= "weave" then
					local easeOutCubic = math.easeOutCubic(arg_31_3)

					arg_31_4.render_settings.alpha_multiplier = 1 - easeOutCubic
				end
			end,
			on_complete = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				-- function 32
				local style = arg_32_2.style
				local content = arg_32_2.content
				local area_text_style = style.area_text_style
				local area_text_shadow_style = style.area_text_shadow_style

				area_text_style.font_size = area_text_style.default_font_size
				area_text_shadow_style.font_size = area_text_style.default_font_size

				local duration_text_style = style.duration_text_style
				local duration_text_shadow_style = style.duration_text_shadow_style

				duration_text_style.font_size = duration_text_style.default_font_size
				duration_text_shadow_style.font_size = duration_text_style.default_font_size
			end
		}
	}
}

return {
	animation_definitions = tbl_5,
	scenegraph_definition = tbl_3,
	widget_definitions = tbl_4
}
