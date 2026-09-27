-- chunkname: @scripts/ui/hud_ui/weave_progress_ui_definitions.lua

local num = 1920
local num_2 = 1080
local num_3 = 1.5
local tbl = {
	250 * num_3,
	22 * num_3
}
local tbl_2 = {
	21 * num_3,
	21 * num_3
}
local tbl_3 = {
	42.5,
	42.5
}
local tbl_4 = {
	325 * num_3,
	50 * num_3
}
local num_4 = 1
local tbl_5 = {
	325 * num_4,
	50 * num_4
}
local tbl_6 = {
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
	progress_ui = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			0,
			-25,
			0
		},
		size = tbl_5
	},
	progress_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			-20,
			-20,
			0
		},
		size = tbl_4
	},
	progress_icon = {
		vertical_alignment = "center",
		parent = "progress_window",
		horizontal_alignment = "left",
		position = {
			60,
			0,
			1
		},
		size = tbl_3
	},
	progress_bar = {
		vertical_alignment = "center",
		parent = "progress_window",
		horizontal_alignment = "right",
		position = {
			0,
			0,
			1
		},
		size = tbl
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local button_frame_02 = UIFrameSettings.button_frame_02

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
						arg_2_1.texture_size[1] = self.parent.bar_progress * tbl[1]
						self.uvs[2][1] = self.parent.bar_progress
					end
				},
				{
					style_id = "progress_bar_tip",
					texture_id = "progress_bar_tip_id",
					pass_type = "texture",
					content_change_function = function (self, arg_3_1)
						-- function 3
						arg_3_1.offset[1] = self.bar_progress * tbl[1] - 4
					end
				},
				{
					texture_id = "frame_id",
					style_id = "frame",
					pass_type = "texture_frame"
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
					style_id = "progress_bar_fill_bg",
					pass_type = "texture_uv",
					content_id = "progress_bar_fill_bg_id",
					content_check_function = function (self, arg_4_1)
						-- function 4
						return self.parent.bar_progress < self.parent.progress
					end,
					content_change_function = function (self, arg_5_1)
						-- function 5
						arg_5_1.texture_size[1] = self.parent.progress * tbl[1]
						self.uvs[2][1] = self.parent.progress
					end
				},
				{
					style_id = "glow",
					pass_type = "texture_uv",
					content_id = "glow_id",
					content_check_function = function (self, arg_6_1)
						-- function 6
						return self.parent.bar_progress < self.parent.progress or self.parent.bar_progress == 1
					end,
					content_change_function = function (self, arg_7_1, arg_7_2, arg_7_3)
						-- function 7
						if self.parent.bar_progress == 1 then
							self.timer = self.timer + arg_7_3 * 3
							arg_7_1.color[1] = 96 + math.cos(self.timer) * 96
							arg_7_1.texture_size[1] = tbl[1]
							arg_7_1.offset[1] = 0
						else
							self.uvs[1][1] = 1 - (self.parent.progress - self.parent.bar_progress)
							self.uvs[2][1] = 1
							arg_7_1.offset[1] = self.parent.bar_progress * tbl[1]
							arg_7_1.texture_size[1] = (self.parent.progress - self.parent.bar_progress) * tbl[1]
						end
					end
				},
				{
					style_id = "progress_bar_glow_tip",
					texture_id = "progress_bar_tip_id",
					pass_type = "texture",
					content_check_function = function (self, arg_8_1)
						-- function 8
						return self.bar_progress < self.progress
					end,
					content_change_function = function (self, arg_9_1)
						-- function 9
						arg_9_1.offset[1] = self.progress * tbl[1] - 4
					end
				},
				{
					scenegraph_id = "progress_icon",
					style_id = "progress_icon_effect",
					pass_type = "texture_uv",
					content_id = "progress_icon_effect"
				},
				{
					texture_id = "mask_texture",
					style_id = "mask_top",
					pass_type = "texture"
				},
				{
					texture_id = "mask_texture",
					style_id = "mask_bottom",
					pass_type = "texture"
				}
			}
		},
		content = {
			progress_bar_end_id = "weave_bar_end",
			progress = 0,
			progress_bar_tip_id = "weave_bar_fill_gain_glow_progress_end",
			test = "weave_bar_fill_gain_progress_glow",
			glass_id = "button_glass_01",
			mask_id = "bar_blur",
			bar_progress = 0,
			mask_texture = "mask_rect",
			progress_bar_fill_id = {
				texture_id = "weave_bar_fill_progress",
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
			progress_bar_fill_bg_id = {
				texture_id = "weave_bar_fill_progress",
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
			glow_id = {
				timer = 0,
				texture_id = "weave_bar_fill_gain_progress_glow",
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
			progress_icon_effect = {
				texture_id = "weave_progress_effect",
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
			progress_icon_effect = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					67.5,
					87.5
				},
				offset = {
					-0,
					-2,
					50
				},
				color = {
					255,
					255,
					131,
					0
				}
			},
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
				vertical_alignment = "center",
				horizontal_alignment = "center",
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
				},
				texture_size = {
					tbl[1] + 15,
					tbl[2] + 18
				}
			},
			mask_top = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					tbl[2] * 0.25,
					10
				},
				texture_size = {
					tbl[1] - 17 * num_3 * 2,
					tbl[2] * 0.4
				}
			},
			mask_bottom = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-tbl[2] * 0.25,
					10
				},
				texture_size = {
					tbl[1] - 17 * num_3 * 2,
					tbl[2] * 0.4
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
					4
				},
				texture_size = {
					tbl[1],
					tbl[2]
				}
			},
			progress_bar_fill = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					3
				},
				texture_size = {
					tbl[1],
					tbl[2] + 22
				}
			},
			progress_bar_tip = {
				masked = true,
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = tbl_2,
				offset = {
					0,
					0,
					3
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
					5
				},
				texture_size = button_frame_02.texture_size,
				texture_sizes = button_frame_02.texture_sizes
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
					5
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
					5
				},
				texture_size = {
					17 * num_3,
					21 * num_3
				}
			},
			progress_bar_fill_bg = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					2
				},
				texture_size = {
					0,
					tbl[2] + 22
				}
			},
			glow = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					12,
					0,
					6
				},
				texture_size = {
					tbl[1],
					tbl[2] + 16
				}
			},
			progress_bar_glow_tip = {
				masked = true,
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = tbl_2,
				offset = {
					0,
					0,
					3
				}
			}
		},
		scenegraph_id = arg_1_0
	}
end

local function fn_2(arg_10_0)
	-- function 10
	local str = "weaves_essence_bar_backdrop"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local str_2 = "weaves_essence_bar_fill"
	local get_atlas_settings_by_texture_name_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)
	local str_3 = "weaves_essence_bar_bg"
	local get_atlas_settings_by_texture_name_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_3)
	local str_4 = "weaves_essence_bar_edge_glow"
	local get_atlas_settings_by_texture_name_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_4)
	local str_5 = "weaves_essence_bar_backdrop_highlight"
	local get_atlas_settings_by_texture_name_5 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_5)
	local str_6 = "icon_essence_small"
	local get_atlas_settings_by_texture_name_6 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_6)
	local str_7 = "weaves_icon_boss"
	local get_atlas_settings_by_texture_name_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_7)
	local str_8 = "weaves_icon_boss_greyscale"
	local get_atlas_settings_by_texture_name_8 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_8)
	local essence = WeaveSettings.score[#WeaveSettings.score].essence

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background_id"
				},
				{
					pass_type = "texture",
					style_id = "background_filled",
					texture_id = "background_filled_id"
				},
				{
					pass_type = "texture",
					style_id = "essence_icon",
					texture_id = "essence_icon_id"
				},
				{
					style_id = "bar",
					pass_type = "texture_uv",
					content_id = "bar_content",
					content_change_function = function (self, arg_11_1)
						-- function 11
						local bar_progress = self.parent.bar_progress

						self.uvs[2][1] = bar_progress

						local base_offset_x = arg_11_1.base_offset_x

						arg_11_1.texture_size[1] = bar_progress * get_atlas_settings_by_texture_name_2.size[1]
					end
				},
				{
					style_id = "bar_glow",
					pass_type = "rect",
					content_change_function = function (self, arg_12_1)
						-- function 12
						local progress = self.progress

						arg_12_1.texture_size[1] = progress * get_atlas_settings_by_texture_name_2.size[1]
					end
				},
				{
					style_id = "bar_edge_glow",
					texture_id = "bar_edge_glow_id",
					pass_type = "texture",
					content_change_function = function (self, arg_13_1)
						-- function 13
						local var_13_0 = get_atlas_settings_by_texture_name_2.size[1]
						local bar_progress = self.bar_progress
						local base_offset_x = arg_13_1.base_offset_x

						arg_13_1.offset[1] = base_offset_x + bar_progress * var_13_0

						local time = Managers.time:time("main")

						arg_13_1.color[1] = 192 + 63 * math.sin(time * 4)
					end
				},
				{
					pass_type = "texture",
					style_id = "bubble_icon",
					texture_id = "bubble_icon_id",
					content_check_function = function (self)
						-- function 14
						local bar_cutoff = self.bar_cutoff
						local current_bar_score = Managers.weave:current_bar_score()

						return not (bar_cutoff < 100) or bar_cutoff <= current_bar_score
					end
				},
				{
					pass_type = "texture",
					style_id = "bubble_icon",
					texture_id = "bubble_icon_grayscale_id",
					content_check_function = function (self)
						-- function 15
						local bar_cutoff = self.bar_cutoff
						local current_bar_score = Managers.weave:current_bar_score()

						return not (bar_cutoff < 100) or current_bar_score < bar_cutoff
					end
				},
				{
					pass_type = "texture",
					style_id = "bar_bg",
					texture_id = "bar_bg_id"
				},
				{
					style_id = "standard_objective",
					pass_type = "text",
					text_id = "standard_objective_text_id"
				},
				{
					style_id = "standard_objective_shadow",
					pass_type = "text",
					text_id = "standard_objective_text_id"
				},
				{
					style_id = "bonus_time",
					pass_type = "text",
					text_id = "bonus_time"
				},
				{
					style_id = "bonus_time_shadow",
					pass_type = "text",
					text_id = "bonus_time"
				}
			}
		},
		content = {
			progress = 0,
			bar_cutoff = 100,
			bonus_time = "+ 0:00",
			essence_id = "Essence:",
			bar_progress = 0,
			standard_objective_text_id = "objective_kill_enemies",
			bubble_icon_id = str_7,
			bubble_icon_grayscale_id = str_8,
			essence_icon_id = str_6,
			background_id = str,
			background_filled_id = str_5,
			bar_content = {
				texture_id = str_2,
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
			bar_edge_glow_id = str_4,
			bar_bg_id = str_3,
			essence_amount_id = essence .. "/" .. essence
		},
		style = {
			background = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = get_atlas_settings_by_texture_name.size,
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
			background_filled = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = get_atlas_settings_by_texture_name_5.size,
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					26,
					1
				}
			},
			essence_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = get_atlas_settings_by_texture_name_6.size,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					45,
					3,
					10
				}
			},
			bar = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = get_atlas_settings_by_texture_name_2.size,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					80,
					0,
					10
				}
			},
			bar_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					0,
					6
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					80,
					0,
					9
				}
			},
			bar_edge_glow = {
				vertical_alignment = "center",
				base_offset_x = 57,
				horizontal_alignment = "left",
				texture_size = get_atlas_settings_by_texture_name_4.size,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					57,
					0,
					7
				}
			},
			bubble_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = get_atlas_settings_by_texture_name_7.size,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					200,
					5,
					10
				},
				base_offset_x = 53 + get_atlas_settings_by_texture_name_7.size[1] * 0.5
			},
			bar_bg = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = get_atlas_settings_by_texture_name_3.size,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					15,
					0,
					5
				}
			},
			essence = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 16,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = {
					255,
					231,
					99,
					253
				},
				offset = {
					80,
					-3,
					5
				}
			},
			essence_shadow = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 16,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					82,
					-5,
					4
				}
			},
			essence_amount = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 16,
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-120,
					-3,
					5
				}
			},
			essence_amount_shadow = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 16,
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-118,
					-5,
					4
				}
			},
			standard_objective = {
				word_wrap = false,
				upper_case = false,
				localize = true,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					80,
					-48,
					1
				},
				size = {
					tbl_5[1] - 80,
					tbl_5[2]
				}
			},
			standard_objective_shadow = {
				word_wrap = false,
				upper_case = false,
				localize = true,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					82,
					-50,
					0
				},
				size = {
					tbl_5[1] - 80,
					tbl_5[2]
				}
			},
			bonus_time = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 16,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					62,
					-19,
					1
				}
			},
			bonus_time_shadow = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 16,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					64,
					-21,
					0
				}
			}
		},
		scenegraph_id = arg_10_0
	}
end

local function fn_3()
	-- function 16
	local str = "progress_ui"

	return {
		element = {
			passes = {
				{
					style_id = "bonus_objective",
					pass_type = "text",
					text_id = "bonus_objective_text_id"
				},
				{
					style_id = "bonus_objective_shadow",
					pass_type = "text",
					text_id = "bonus_objective_text_id"
				}
			}
		},
		content = {
			bonus_objective_text_id = "weave_bonus_essence_header"
		},
		style = {
			bonus_objective = {
				word_wrap = false,
				upper_case = false,
				localize = true,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					80,
					-90,
					1
				}
			},
			bonus_objective_shadow = {
				word_wrap = false,
				upper_case = false,
				localize = true,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					82,
					-92,
					0
				}
			}
		},
		scenegraph_id = str
	}
end

local function fn_4(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local str = "progress_ui"
	local str_2 = "matchmaking_checkbox"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)
	local str_3 = "weaves_objective_bullet"
	local get_atlas_settings_by_texture_name_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_3)
	local str_4 = "icon_essence_small"
	local get_atlas_settings_by_texture_name_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_4)

	return {
		element = {
			passes = {
				{
					style_id = "stroke",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 18
						return self.is_done
					end
				},
				{
					pass_type = "texture",
					style_id = "bullet",
					texture_id = "bullet_id",
					content_check_function = function (self)
						-- function 19
						return not self.is_done
					end
				},
				{
					pass_type = "texture",
					style_id = "checkmark",
					texture_id = "checkmark_id",
					content_check_function = function (self)
						-- function 20
						return self.is_done
					end
				},
				{
					pass_type = "texture",
					style_id = "checkmark_shadow",
					texture_id = "checkmark_id",
					content_check_function = function (self)
						-- function 21
						return self.is_done
					end
				},
				{
					style_id = "objective_name",
					pass_type = "text",
					text_id = "objective_name_id",
					content_change_function = function (self)
						-- function 22
						if not self.stack then
							return
						end

						self.objective_name_id = self.base_objective_name_id

						local stack = self.stack
						local done_stack = self.done_stack

						self.objective_name_id = self.objective_name_id .. " " .. table.size(done_stack) .. "/" .. table.size(stack)
					end
				},
				{
					style_id = "objective_name_shadow",
					pass_type = "text",
					text_id = "objective_name_id"
				}
			}
		},
		content = {
			is_done = false,
			show_marker = false,
			essence_icon_id = str_4,
			checkmark_id = str_2,
			bullet_id = str_3,
			base_objective_name_id = Localize(arg_17_0),
			objective_name_id = Localize(arg_17_0),
			stack = not arg_17_3 and {
				arg_17_3
			},
			done_stack = {},
			stack_name = arg_17_2,
			is_done_func = function (self, arg_23_1)
				-- function 23
				if not (self.is_done or self.stack ~= false) then
					return true
				end

				return table.find(self.done_stack, arg_23_1)
			end
		},
		style = {
			stroke = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					0,
					2
				},
				color = Colors.get_color_table_with_alpha("black", 128),
				offset = {
					80,
					-97,
					1
				}
			},
			bullet = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = get_atlas_settings_by_texture_name_2.size,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					65,
					-90,
					1
				}
			},
			checkmark = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					get_atlas_settings_by_texture_name.size[1] * 0.5,
					get_atlas_settings_by_texture_name.size[2] * 0.5
				},
				color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					-90,
					-72,
					1
				}
			},
			checkmark_shadow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					get_atlas_settings_by_texture_name.size[1],
					get_atlas_settings_by_texture_name.size[2]
				},
				color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-88,
					-74,
					0
				}
			},
			objective_name = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					80,
					-85,
					1
				}
			},
			objective_name_shadow = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					82,
					-87,
					0
				}
			},
			essence_icon = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = {
					get_atlas_settings_by_texture_name_3.size[1] * 0.75,
					get_atlas_settings_by_texture_name_3.size[2] * 0.75
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					80,
					-82,
					1
				}
			}
		},
		scenegraph_id = str,
		offset = {
			0,
			-50 + arg_17_1 * -25,
			5
		}
	}
end

local tbl_7 = {
	progress_ui = fn_2("progress_ui")
}

return {
	scenegraph_definition = tbl_6,
	create_bonus_objective_header_func = fn_3,
	create_bonus_objective_func = fn_4,
	widgets = tbl_7
}
