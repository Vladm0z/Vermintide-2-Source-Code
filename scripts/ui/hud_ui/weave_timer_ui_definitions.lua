-- chunkname: @scripts/ui/hud_ui/weave_timer_ui_definitions.lua

local num = 1920
local num_2 = 1080
local num_3 = 1.5
local tbl = {
	250 * num_3,
	21 * num_3
}
local tbl_2 = {
	21 * num_3,
	21 * num_3
}
local tbl_3 = {
	70,
	50
}
local tbl_4 = {
	325 * num_3,
	40 * num_3
}
local tbl_5 = {
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
			-20 - tbl_4[2],
			0
		},
		size = tbl_4
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
		size = tbl_3
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
		size = tbl
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
			tbl[1] + 26,
			tbl[2] + 26
		}
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local button_frame_02 = UIFrameSettings.button_frame_02
	local frame_outer_glow_02 = UIFrameSettings.frame_outer_glow_02

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
					content_change_function = function (self, arg_2_1)
						-- function 2
						arg_2_1.texture_size[1] = tbl[1] - self.parent.progress * tbl[1]
						self.uvs[1][1] = self.parent.progress
						self.uvs[2][1] = 1
						arg_2_1.offset[1] = self.parent.progress * tbl[1]
					end
				},
				{
					style_id = "progress_bar_tip",
					pass_type = "texture_uv",
					content_id = "progress_bar_tip",
					content_change_function = function (self, arg_3_1)
						-- function 3
						arg_3_1.offset[1] = self.parent.progress * tbl[1]
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
					content_check_function = function (self)
						-- function 4
						return self.progress > 0.9
					end,
					content_change_function = function (self, arg_5_1, arg_5_2, arg_5_3)
						-- function 5
						if self.progress >= 0.9 then
							local num = 192 + math.sin(self.timer) * 64

							arg_5_1.color[1] = num
							self.timer = self.timer + arg_5_3 * 7
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
			frame_id = button_frame_02.texture,
			outer_frame_id = frame_outer_glow_02.texture,
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
					tbl[1],
					tbl[2]
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
					tbl[1],
					tbl[2] - 1
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
					tbl_2[1],
					tbl_2[2] - 1
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
				texture_size = button_frame_02.texture_size,
				texture_sizes = button_frame_02.texture_sizes
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
				texture_size = frame_outer_glow_02.texture_size,
				texture_sizes = frame_outer_glow_02.texture_sizes
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
					17 * num_3,
					21 * num_3
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
					17 * num_3,
					21 * num_3
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

local function fn_2(arg_6_0, arg_6_1)
	-- function 6
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_6_0)

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
					content_check_function = function (self)
						-- function 7
						return self.progress >= self.progress_cutoff
					end,
					content_change_function = function (self, arg_8_1)
						-- function 8
						if self.progress >= self.progress_cutoff then
							local time = Managers.time:time("game")
							local cos

							if self.progress < 1 then
								cos = math.cos(time * math.pi * 2)

								if not cos then
									-- Nothing
								end
							end

							cos = 1

							::label_8_0::

							arg_8_1.color[1] = 192 + cos * 64
							arg_8_1.texture_size[1] = math.lerp(get_atlas_settings_by_texture_name.size[1], get_atlas_settings_by_texture_name.size[1] * 1.25, cos)
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
				texture_size = get_atlas_settings_by_texture_name.size,
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

local tbl_6 = {
	timer = fn_2("weaves_timer_highlight", "timer_bg")
}

return {
	scenegraph_definition = tbl_5,
	widgets = tbl_6
}
