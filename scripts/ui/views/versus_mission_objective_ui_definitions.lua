-- chunkname: @scripts/ui/views/versus_mission_objective_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	819,
	60
}
local tbl_2 = {
	64,
	64
}
local tbl_3 = {
	tbl[1],
	tbl[2]
}
local tbl_4 = {}
local tbl_5 = {
	size = {
		num,
		num_2
	},
	position = {
		0,
		0,
		UILayer.hud
	}
}
local flag

flag = IS_WINDOWS or not "hud_fit" or "fit"
tbl_5.scale = flag
tbl_4.screen = tbl_5
tbl_4.pivot = {
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
}
tbl_4.objective_detail = {
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
}
tbl_4.objective_text = {
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
}
tbl_4.objective = {
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
}
tbl_4.mission_pivot = {
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
}
tbl_4.mission_widget = {
	vertical_alignment = "top",
	parent = "pivot",
	horizontal_alignment = "center",
	size = tbl_3,
	position = {
		0,
		0,
		0
	}
}
tbl_4.background = {
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
}
tbl_4.area_text_background = {
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
}
tbl_4.duration_text_background = {
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
}
tbl_4.top_center = {
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
}
tbl_4.top_left = {
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
}
tbl_4.top_right = {
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
}
tbl_4.top_detail = {
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
}
tbl_4.bottom_center = {
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
}
tbl_4.bottom_left = {
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
}
tbl_4.bottom_right = {
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
}
tbl_4.mission_icon_left = {
	vertical_alignment = "center",
	parent = "mission_widget",
	horizontal_alignment = "center",
	size = {
		tbl_2[1],
		tbl_2[2]
	},
	position = {
		0,
		0,
		1
	}
}
tbl_4.mission_icon_right = {
	vertical_alignment = "center",
	parent = "mission_widget",
	horizontal_alignment = "center",
	size = {
		tbl_2[1],
		tbl_2[2]
	},
	position = {
		0,
		0,
		1
	}
}
tbl_4.frame_top_right = {
	vertical_alignment = "top",
	parent = "mission_widget",
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
}
tbl_4.frame_top_left = {
	vertical_alignment = "top",
	parent = "mission_widget",
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
}
tbl_4.frame_bottom_right = {
	vertical_alignment = "bottom",
	parent = "mission_widget",
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
}
tbl_4.frame_bottom_left = {
	vertical_alignment = "bottom",
	parent = "mission_widget",
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

local tbl_6 = {
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
local clone = table.clone(tbl_6)

clone.font_size = 38
clone.offset = {
	0,
	-20,
	2
}
clone.text_color = Colors.get_color_table_with_alpha("white_smoke", 255)
clone.size = {
	50,
	50
}
clone.dynamic_font_size = true

local clone_2 = table.clone(tbl_6)

clone_2.font_size = 24
clone_2.dynamic_font_size = true
clone_2.word_wrap = false
clone_2.offset = {
	0,
	-75,
	2
}
clone_2.text_color = Colors.get_color_table_with_alpha("white_smoke", 255)
clone_2.size = {
	50,
	50
}

local tbl_7 = {
	255,
	144,
	144,
	144
}

local function fn(arg_1_0)
	-- function 1
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
					content_check_function = function (self, arg_2_1)
						-- function 2
						return self.duration_text_content
					end
				},
				{
					style_id = "duration_text_shadow_style",
					pass_type = "text",
					text_id = "duration_text_content",
					content_check_function = function (self, arg_3_1)
						-- function 3
						return self.duration_text_content
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

						return color, uvs, arg_4_2, arg_4_1.offset
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
			}
		},
		scenegraph_id = arg_1_0
	}
end

local tbl_8 = {
	round_start_timer = UIWidgets.create_simple_text("", "objective", nil, nil, clone),
	round_starting_text = UIWidgets.create_simple_text("", "objective", nil, nil, clone_2),
	objective = UIWidgets.create_objective_score_widget("objective", tbl_4.objective.size)
}
local num_3 = 1.5
local tbl_9 = {
	announcement = {
		{
			name = "fade_in_header",
			start_progress = 0 * num_3,
			end_progress = 0.5 * num_3,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				return
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				local easeOutCubic = math.easeOutCubic(arg_6_3)
				local ease_pulse = math.ease_pulse(easeOutCubic)
				local style = widget.style
				local text = style.text
				local text_shadow = style.text_shadow
				local default_font_size = text.default_font_size

				text.font_size = default_font_size + math.floor(default_font_size * 1) * (1 - easeOutCubic)
				text_shadow.font_size = text.font_size
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end
		},
		{
			name = "fade_in_value",
			start_progress = 0.5 * num_3,
			end_progress = 1 * num_3,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				return
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				-- function 9
				local easeOutCubic = math.easeOutCubic(arg_9_3)
				local ease_pulse = math.ease_pulse(easeOutCubic)
				local announcement_value_text = arg_9_2.announcement_value_text

				announcement_value_text.alpha_multiplier = math.easeCubic(arg_9_3)

				local style = announcement_value_text.style
				local num = -70 * (1 - math.ease_out_exp(arg_9_3))

				announcement_value_text.offset[2] = num
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end
		},
		{
			name = "fade_out_header",
			start_progress = 2 * num_3,
			end_progress = 2.5 * num_3,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				return
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				-- function 12
				local easeOutCubic = math.easeOutCubic(arg_12_3)
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end
		},
		{
			name = "fade_out_value",
			start_progress = 1.7 * num_3,
			end_progress = 2.5 * num_3,
			init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				return
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				-- function 15
				local easeOutCubic = math.easeOutCubic(arg_15_3)

				arg_15_2.announcement_value_text.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				return
			end
		}
	},
	mission_start = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				arg_17_2.alpha_multiplier = 0
				arg_17_3.render_settings.snap_pixel_positions = false
				arg_17_2.style.top_edge_glow.color[1] = 0
				arg_17_2.style.bottom_edge_glow.color[1] = 0
				arg_17_0.mission_pivot.local_position[2] = arg_17_1.mission_pivot.position[2]

				local style = arg_17_2.style
				local content = arg_17_2.content
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
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				-- function 18
				arg_18_2.alpha_multiplier = math.easeOutCubic(arg_18_3)
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end
		},
		{
			name = "unfold",
			start_progress = 0.3,
			end_progress = 0.8,
			init = function (self, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				local num = 0.1
				local style = arg_20_2.style
				local content = arg_20_2.content
				local top_left = content.top_left
				local top_left_2 = style.top_left
				local uvs = top_left.uvs
				local top_left_3 = self.top_left
				local top_left_4 = arg_20_1.top_left

				top_left_3.size[1] = top_left_4.size[1] * num
				uvs[2][1] = num

				local bottom_left = content.bottom_left
				local bottom_left_2 = style.bottom_left
				local uvs_2 = bottom_left.uvs
				local bottom_left_3 = self.bottom_left
				local bottom_left_4 = arg_20_1.bottom_left

				bottom_left_3.size[1] = bottom_left_4.size[1] * num
				uvs_2[2][1] = num

				local top_right = content.top_right
				local top_right_2 = style.top_right
				local uvs_3 = top_right.uvs
				local top_right_3 = self.top_right
				local top_right_4 = arg_20_1.top_right

				top_right_3.size[1] = top_right_4.size[1] * num
				uvs_3[1][1] = 1 - num

				local bottom_right = content.bottom_right
				local bottom_right_2 = style.bottom_right
				local uvs_4 = bottom_right.uvs
				local bottom_right_3 = self.bottom_right
				local bottom_right_4 = arg_20_1.bottom_right

				bottom_right_3.size[1] = bottom_right_4.size[1] * num
				uvs_4[1][1] = 1 - num
			end,
			update = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				-- function 21
				local min = math.min(0.1 + math.easeInCubic(arg_21_3), 1)
				local style = arg_21_2.style
				local content = arg_21_2.content
				local top_left = content.top_left
				local top_left_2 = style.top_left
				local uvs = top_left.uvs
				local top_left_3 = self.top_left
				local top_left_4 = arg_21_1.top_left

				top_left_3.size[1] = top_left_4.size[1] * min
				uvs[2][1] = min

				local bottom_left = content.bottom_left
				local bottom_left_2 = style.bottom_left
				local uvs_2 = bottom_left.uvs
				local bottom_left_3 = self.bottom_left
				local bottom_left_4 = arg_21_1.bottom_left

				bottom_left_3.size[1] = bottom_left_4.size[1] * min
				uvs_2[2][1] = min

				local top_right = content.top_right
				local top_right_2 = style.top_right
				local uvs_3 = top_right.uvs
				local top_right_3 = self.top_right
				local top_right_4 = arg_21_1.top_right

				top_right_3.size[1] = top_right_4.size[1] * min
				uvs_3[1][1] = 1 - min

				local bottom_right = content.bottom_right
				local bottom_right_2 = style.bottom_right
				local uvs_4 = bottom_right.uvs
				local bottom_right_3 = self.bottom_right
				local bottom_right_4 = arg_21_1.bottom_right

				bottom_right_3.size[1] = bottom_right_4.size[1] * min
				uvs_4[1][1] = 1 - min
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				return
			end
		},
		{
			name = "open",
			start_progress = 0.8,
			end_progress = 1.5,
			init = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				-- function 23
				local style = arg_23_2.style
				local content = arg_23_2.content
				local top_glow = style.top_glow
				local bottom_glow = style.bottom_glow
				local background = style.background

				content.top_glow.uvs[1][2] = 0
				content.bottom_glow.uvs[2][2] = 1
				top_glow.size[2] = 0
				bottom_glow.size[2] = 0
				background.color[1] = 0
				arg_23_0.top_center.local_position[2] = arg_23_1.top_center.position[2]
				arg_23_0.bottom_center.local_position[2] = arg_23_1.bottom_center.position[2]
			end,
			update = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				-- function 24
				local easeOutCubic = math.easeOutCubic(arg_24_3)

				self.top_center.local_position[2] = arg_24_1.top_center.position[2] + 45 * easeOutCubic
				self.bottom_center.local_position[2] = arg_24_1.bottom_center.position[2] + -45 * easeOutCubic

				local style = arg_24_2.style
				local content = arg_24_2.content
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
				local background_4 = arg_24_1.background

				background_3.size[2] = background_4.size[2] * easeOutCubic
				uvs_3[1][2] = 0.5 - 0.5 * easeOutCubic
				uvs_3[2][2] = 0.5 + 0.5 * easeOutCubic
				background_2.color[1] = 255
				arg_24_2.style.top_edge_glow.color[1] = 255 * easeOutCubic
				arg_24_2.style.bottom_edge_glow.color[1] = 255 * easeOutCubic
			end,
			on_complete = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				return
			end
		},
		{
			name = "text_entry",
			start_progress = 0.9,
			end_progress = 1.5,
			init = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				local style = arg_26_2.style
				local content = arg_26_2.content
			end,
			update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				-- function 27
				local easeCubic = math.easeCubic(arg_27_3)
				local style = arg_27_2.style
				local content = arg_27_2.content
				local area_text_style = style.area_text_style
				local area_text_shadow_style = style.area_text_shadow_style
				local num = 255 * easeCubic

				area_text_style.text_color[1] = num
				area_text_shadow_style.text_color[1] = num

				local duration_text_style = style.duration_text_style
				local duration_text_shadow_style = style.duration_text_shadow_style

				duration_text_style.text_color[1] = num
				duration_text_shadow_style.text_color[1] = num

				local ease_pulse = math.ease_pulse(math.easeInCubic(arg_27_3))
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				arg_28_3.render_settings.snap_pixel_positions = false
			end
		},
		{
			name = "text_minimize",
			start_progress = 5,
			end_progress = 5.3,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				local style = arg_29_2.style
				local content = arg_29_2.content
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				-- function 30
				local easeOutCubic = math.easeOutCubic(arg_30_3)
				local style = arg_30_2.style
				local content = arg_30_2.content
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
			on_complete = function (self, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				local style = arg_31_2.style
				local content = arg_31_2.content
				local area_text_content = content.area_text_content
				local duration_text_content = content.duration_text_content

				if not duration_text_content then
					local ui_renderer = arg_31_3.ui_renderer
					local var_31_5, var_31_6 = UIFontByResolution(style.area_text_style)
					local var_31_7 = var_31_5[1]
					local var_31_8 = var_31_6
					local upper = string.upper(content.area_text_content)
					local text_size = UIRenderer.text_size(ui_renderer, upper, var_31_7, var_31_8)
					local var_31_11 = duration_text_content
					local text_size_2 = UIRenderer.text_size(ui_renderer, var_31_11, var_31_7, var_31_8)
					local var_31_13 = self.area_text_background.size[1]
					local var_31_14 = self.duration_text_background.size[1]

					self.area_text_background.position[1] = text_size_2 * 0.5
					self.duration_text_background.position[1] = -text_size * 0.5
				end
			end
		},
		{
			name = "collapse",
			start_progress = 5,
			end_progress = 5.3,
			init = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				-- function 32
				local style = arg_32_2.style
				local content = arg_32_2.content
				local top_glow = style.top_glow
				local bottom_glow = style.bottom_glow
				local background = style.background

				top_glow.size[2] = 0
				bottom_glow.size[2] = 0
				background.color[1] = 0
			end,
			update = function (self, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				-- function 33
				local easeOutCubic = math.easeOutCubic(arg_33_3)
				local num = 1 - math.easeOutCubic(arg_33_3)
				local style = arg_33_2.style
				local content = arg_33_2.content
				local text_height = content.text_height

				text_height = text_height or 45

				local num_2 = (90 - text_height) / 2

				self.top_center.local_position[2] = arg_33_1.top_center.position[2] + 45 - num_2 * easeOutCubic
				self.bottom_center.local_position[2] = arg_33_1.bottom_center.position[2] - 45 + num_2 * easeOutCubic

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
				local background_4 = arg_33_1.background
				local size_3 = background_3.size
				local size_4 = background_4.size

				size_3[2] = size_4[2] - (size_4[2] - text_height) * easeOutCubic

				local num_3 = text_height / size_4[2] * easeOutCubic

				uvs_2[1][2] = 0.5 * num_3
				uvs_2[2][2] = 1 - num_3 / 2
			end,
			on_complete = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 5,
			end_progress = 5.3,
			init = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				-- function 35
				return
			end,
			update = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				-- function 36
				arg_36_2.alpha_multiplier = 1 - math.easeOutCubic(arg_36_3)
			end,
			on_complete = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
				arg_37_0.mission_pivot.local_position[2] = -30
			end
		},
		{
			name = "fade_in",
			start_progress = 5.3,
			end_progress = 5.6,
			init = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				-- function 38
				return
			end,
			update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				-- function 39
				if Managers.state.game_mode:game_mode_key() ~= "weave" then
					arg_39_2.alpha_multiplier = math.easeOutCubic(arg_39_3)
				end
			end,
			on_complete = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				arg_40_3.render_settings.snap_pixel_positions = true
			end
		}
	}
}

return {
	animation_definitions = tbl_9,
	scenegraph_definition = tbl_4,
	widget_definitions = tbl_8,
	objective_text = fn("mission_pivot")
}
