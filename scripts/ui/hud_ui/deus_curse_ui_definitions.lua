-- chunkname: @scripts/ui/hud_ui/deus_curse_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	819,
	60
}
local tbl_2 = {
	0,
	20
}
local num_3 = 100
local var_0_5 = num_3
local num_4 = 1000

tbl[2] = tbl[2] + var_0_5 + tbl_2[2] * 2

local tbl_3 = {
	change_widget_height = function (arg_1_0)
		-- function 1
		var_0_5 = math.min(num_3, arg_1_0)
	end
}
local tbl_4 = {
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
			tbl[1],
			tbl[2]
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "description_pivot",
		horizontal_alignment = "center",
		size = {
			num_4,
			var_0_5 + tbl_2[2]
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
			num_4,
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
			num_4 / 2,
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
			num_4 / 2,
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
			num_4 / 2,
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
			num_4 / 2,
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
			tbl[1] / 2,
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
			-tbl[1] / 2,
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
			tbl[1] / 2,
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
			-tbl[1] / 2,
			-2,
			3
		}
	}
}

if not IS_WINDOWS then
	tbl_4.screen.scale = "hud_fit"
end

table.clone(Colors.color_definitions.white)[1] = 0

local tbl_5 = {
	description_widget = {
		scenegraph_id = "description_pivot",
		element = {
			passes = {
				{
					texture_id = "theme_icon",
					style_id = "theme_icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 2
						return self.theme_icon ~= nil
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
					num_4 + 44,
					90
				},
				default_size = {
					num_4 + 44,
					90
				},
				offset = {
					27 - (num_4 + 44) / 2,
					-80,
					-4
				},
				default_offset = {
					27 - (num_4 + 44) / 2,
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
					num_4 + 44,
					16
				},
				default_size = {
					num_4 + 44,
					16
				},
				offset = {
					27 - (num_4 + 44) / 2,
					-6,
					-4
				},
				default_offset = {
					27 - (num_4 + 44) / 2,
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
					num_4 + 44,
					90
				},
				default_size = {
					num_4 + 44,
					90
				},
				offset = {
					27 - (num_4 + 44) / 2,
					10,
					-4
				},
				default_offset = {
					27 - (num_4 + 44) / 2,
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
					num_4 + 44,
					16
				},
				default_size = {
					num_4 + 44,
					16
				},
				offset = {
					27 - (num_4 + 44) / 2,
					10,
					-4
				},
				default_offset = {
					27 - (num_4 + 44) / 2,
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
				uv_scale_pixels = tbl[2],
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
local tbl_6 = {
	description_start = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function (self, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				arg_4_3.render_settings.alpha_multiplier = 0
				arg_4_3.render_settings.snap_pixel_positions = false
				arg_4_2.style.top_edge_glow.color[1] = 0
				arg_4_2.style.bottom_edge_glow.color[1] = 0

				local position = arg_4_1.description_pivot.position

				self.description_pivot.local_position[2] = position[2]

				local style = arg_4_2.style
				local area_text_style = style.area_text_style
				local area_text_shadow_style = style.area_text_shadow_style

				area_text_style.font_size = area_text_style.default_font_size
				area_text_shadow_style.font_size = area_text_style.default_font_size
				area_text_style.text_color[1] = 0
				area_text_shadow_style.text_color[1] = 0

				local background = self.background
				local background_2 = arg_4_1.background

				background.size[2] = background_2.size[2]
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeOutCubic = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		},
		{
			name = "unfold",
			start_progress = 0.3,
			end_progress = 0.8,
			init = function (self, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				local num = 0.1
				local content = arg_7_2.content
				local uvs = content.top_left.uvs
				local top_left = self.top_left
				local top_left_2 = arg_7_1.top_left

				top_left.size[1] = top_left_2.size[1] * num
				uvs[2][1] = num

				local uvs_2 = content.bottom_left.uvs
				local bottom_left = self.bottom_left
				local bottom_left_2 = arg_7_1.bottom_left

				bottom_left.size[1] = bottom_left_2.size[1] * num
				uvs_2[2][1] = num

				local uvs_3 = content.top_right.uvs
				local top_right = self.top_right
				local top_right_2 = arg_7_1.top_right

				top_right.size[1] = top_right_2.size[1] * num
				uvs_3[1][1] = 1 - num

				local uvs_4 = content.bottom_right.uvs
				local bottom_right = self.bottom_right
				local bottom_right_2 = arg_7_1.bottom_right

				bottom_right.size[1] = bottom_right_2.size[1] * num
				uvs_4[1][1] = 1 - num
			end,
			update = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local min = math.min(0.1 + math.easeInCubic(arg_8_3), 1)
				local content = arg_8_2.content
				local uvs = content.top_left.uvs
				local top_left = self.top_left
				local top_left_2 = arg_8_1.top_left

				top_left.size[1] = top_left_2.size[1] * min
				uvs[2][1] = min

				local uvs_2 = content.bottom_left.uvs
				local bottom_left = self.bottom_left
				local bottom_left_2 = arg_8_1.bottom_left

				bottom_left.size[1] = bottom_left_2.size[1] * min
				uvs_2[2][1] = min

				local uvs_3 = content.top_right.uvs
				local top_right = self.top_right
				local top_right_2 = arg_8_1.top_right

				top_right.size[1] = top_right_2.size[1] * min
				uvs_3[1][1] = 1 - min

				local uvs_4 = content.bottom_right.uvs
				local bottom_right = self.bottom_right
				local bottom_right_2 = arg_8_1.bottom_right

				bottom_right.size[1] = bottom_right_2.size[1] * min
				uvs_4[1][1] = 1 - min
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		},
		{
			name = "open",
			start_progress = 0.8,
			end_progress = 1.5,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				local style = arg_10_2.style
				local content = arg_10_2.content
				local top_glow = style.top_glow
				local bottom_glow = style.bottom_glow
				local background = style.background

				content.top_glow.uvs[1][2] = 0
				content.bottom_glow.uvs[2][2] = 1
				top_glow.size[2] = 0
				bottom_glow.size[2] = 0
				background.color[1] = 0
				arg_10_0.top_center.local_position[2] = arg_10_1.top_center.position[2]
				arg_10_0.bottom_center.local_position[2] = arg_10_1.bottom_center.position[2]
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local easeOutCubic = math.easeOutCubic(arg_11_3)

				arg_11_0.top_center.local_position[2] = arg_11_1.top_center.position[2] + (var_0_5 + tbl_2[2]) / 2 * easeOutCubic
				arg_11_0.bottom_center.local_position[2] = arg_11_1.bottom_center.position[2] + -((var_0_5 + tbl_2[2]) / 2) * easeOutCubic

				local style = arg_11_2.style
				local content = arg_11_2.content
				local top_glow = content.top_glow
				local bottom_glow = content.bottom_glow
				local uvs = top_glow.uvs
				local uvs_2 = bottom_glow.uvs

				uvs[2][2] = easeOutCubic
				uvs_2[1][2] = 1 - easeOutCubic

				local top_glow_2 = style.top_glow
				local bottom_glow_2 = style.bottom_glow

				bottom_glow_2.size[2] = bottom_glow_2.default_size[2] * easeOutCubic

				local size = top_glow_2.size
				local default_size = top_glow_2.default_size
				local offset = top_glow_2.offset

				size[2] = default_size[2] * easeOutCubic
				offset[2] = 10 - size[2]

				local background = content.background
				local background_2 = style.background
				local uvs_3 = background.uvs

				arg_11_0.background.size[2] = ({
					num_4,
					var_0_5 + tbl_2[2]
				})[2] * easeOutCubic
				uvs_3[1][2] = 0.5 - 0.5 * easeOutCubic
				uvs_3[2][2] = 0.5 + 0.5 * easeOutCubic
				background_2.color[1] = 255
				arg_11_2.style.top_edge_glow.color[1] = 255 * easeOutCubic
				arg_11_2.style.bottom_edge_glow.color[1] = 255 * easeOutCubic
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				return
			end
		},
		{
			name = "text_entry",
			start_progress = 0.9,
			end_progress = 1.5,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				local easeCubic = math.easeCubic(arg_14_3)
				local style = arg_14_2.style
				local area_text_style = style.area_text_style
				local area_text_shadow_style = style.area_text_shadow_style
				local num = 255 * easeCubic

				area_text_style.text_color[1] = num
				area_text_shadow_style.text_color[1] = num
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
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
				-- function 16
				return
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				local easeOutCubic = math.easeOutCubic(arg_17_3)

				arg_17_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				arg_18_0.description_pivot.local_position[2] = 0
			end
		}
	}
}

return {
	animation_definitions = tbl_6,
	scenegraph_definition = tbl_4,
	widget_definitions = tbl_5,
	scenegraph_methods = tbl_3,
	text_background_width = num_4
}
