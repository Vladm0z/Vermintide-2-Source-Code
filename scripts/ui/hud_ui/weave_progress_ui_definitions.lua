-- chunkname: @scripts/ui/hud_ui/weave_progress_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = 1.5
local var_0_3 = {
	250 * var_0_2,
	22 * var_0_2
}
local var_0_4 = {
	21 * var_0_2,
	21 * var_0_2
}
local var_0_5 = {
	42.5,
	42.5
}
local var_0_6 = {
	325 * var_0_2,
	50 * var_0_2
}
local var_0_7 = 1
local var_0_8 = {
	325 * var_0_7,
	50 * var_0_7
}
local var_0_9 = {
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
	progress_ui = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			0,
			-25,
			0
		},
		size = var_0_8
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
		size = var_0_6
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
		size = var_0_5
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
		size = var_0_3
	}
}

local function var_0_10(arg_1_0, arg_1_1)
	local var_1_0 = UIFrameSettings.button_frame_02

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
					content_change_function = function(arg_2_0, arg_2_1)
						arg_2_1.texture_size[1] = arg_2_0.parent.bar_progress * var_0_3[1]
						arg_2_0.uvs[2][1] = arg_2_0.parent.bar_progress
					end
				},
				{
					style_id = "progress_bar_tip",
					texture_id = "progress_bar_tip_id",
					pass_type = "texture",
					content_change_function = function(arg_3_0, arg_3_1)
						arg_3_1.offset[1] = arg_3_0.bar_progress * var_0_3[1] - 4
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
					content_check_function = function(arg_4_0, arg_4_1)
						return arg_4_0.parent.bar_progress < arg_4_0.parent.progress
					end,
					content_change_function = function(arg_5_0, arg_5_1)
						arg_5_1.texture_size[1] = arg_5_0.parent.progress * var_0_3[1]
						arg_5_0.uvs[2][1] = arg_5_0.parent.progress
					end
				},
				{
					style_id = "glow",
					pass_type = "texture_uv",
					content_id = "glow_id",
					content_check_function = function(arg_6_0, arg_6_1)
						return arg_6_0.parent.bar_progress < arg_6_0.parent.progress or arg_6_0.parent.bar_progress == 1
					end,
					content_change_function = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
						if arg_7_0.parent.bar_progress == 1 then
							arg_7_0.timer = arg_7_0.timer + arg_7_3 * 3
							arg_7_1.color[1] = 96 + math.cos(arg_7_0.timer) * 96
							arg_7_1.texture_size[1] = var_0_3[1]
							arg_7_1.offset[1] = 0
						else
							arg_7_0.uvs[1][1] = 1 - (arg_7_0.parent.progress - arg_7_0.parent.bar_progress)
							arg_7_0.uvs[2][1] = 1
							arg_7_1.offset[1] = arg_7_0.parent.bar_progress * var_0_3[1]
							arg_7_1.texture_size[1] = (arg_7_0.parent.progress - arg_7_0.parent.bar_progress) * var_0_3[1]
						end
					end
				},
				{
					style_id = "progress_bar_glow_tip",
					texture_id = "progress_bar_tip_id",
					pass_type = "texture",
					content_check_function = function(arg_8_0, arg_8_1)
						return arg_8_0.bar_progress < arg_8_0.progress
					end,
					content_change_function = function(arg_9_0, arg_9_1)
						arg_9_1.offset[1] = arg_9_0.progress * var_0_3[1] - 4
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
			frame_id = var_1_0.texture,
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
					var_0_3[1] + 15,
					var_0_3[2] + 18
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
					var_0_3[2] * 0.25,
					10
				},
				texture_size = {
					var_0_3[1] - 17 * var_0_2 * 2,
					var_0_3[2] * 0.4
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
					-var_0_3[2] * 0.25,
					10
				},
				texture_size = {
					var_0_3[1] - 17 * var_0_2 * 2,
					var_0_3[2] * 0.4
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
					var_0_3[1],
					var_0_3[2]
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
					var_0_3[1],
					var_0_3[2] + 22
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
				texture_size = var_0_4,
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
				texture_size = var_1_0.texture_size,
				texture_sizes = var_1_0.texture_sizes
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
					5
				},
				texture_size = {
					17 * var_0_2,
					21 * var_0_2
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
					var_0_3[2] + 22
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
					var_0_3[1],
					var_0_3[2] + 16
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
				texture_size = var_0_4,
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

local function var_0_11(arg_10_0)
	local var_10_0 = "weaves_essence_bar_backdrop"
	local var_10_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_10_0)
	local var_10_2 = "weaves_essence_bar_fill"
	local var_10_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_10_2)
	local var_10_4 = "weaves_essence_bar_bg"
	local var_10_5 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_10_4)
	local var_10_6 = "weaves_essence_bar_edge_glow"
	local var_10_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_10_6)
	local var_10_8 = "weaves_essence_bar_backdrop_highlight"
	local var_10_9 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_10_8)
	local var_10_10 = "icon_essence_small"
	local var_10_11 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_10_10)
	local var_10_12 = "weaves_icon_boss"
	local var_10_13 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_10_12)
	local var_10_14 = "weaves_icon_boss_greyscale"
	local var_10_15 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_10_14)
	local var_10_16 = WeaveSettings.score[#WeaveSettings.score].essence

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
					content_change_function = function(arg_11_0, arg_11_1)
						local var_11_0 = arg_11_0.parent.bar_progress

						arg_11_0.uvs[2][1] = var_11_0

						local var_11_1 = arg_11_1.base_offset_x

						arg_11_1.texture_size[1] = var_11_0 * var_10_3.size[1]
					end
				},
				{
					style_id = "bar_glow",
					pass_type = "rect",
					content_change_function = function(arg_12_0, arg_12_1)
						local var_12_0 = arg_12_0.progress

						arg_12_1.texture_size[1] = var_12_0 * var_10_3.size[1]
					end
				},
				{
					style_id = "bar_edge_glow",
					texture_id = "bar_edge_glow_id",
					pass_type = "texture",
					content_change_function = function(arg_13_0, arg_13_1)
						local var_13_0 = var_10_3.size[1]
						local var_13_1 = arg_13_0.bar_progress
						local var_13_2 = arg_13_1.base_offset_x

						arg_13_1.offset[1] = var_13_2 + var_13_1 * var_13_0

						local var_13_3 = Managers.time:time("main")

						arg_13_1.color[1] = 192 + 63 * math.sin(var_13_3 * 4)
					end
				},
				{
					pass_type = "texture",
					style_id = "bubble_icon",
					texture_id = "bubble_icon_id",
					content_check_function = function(arg_14_0)
						local var_14_0 = arg_14_0.bar_cutoff
						local var_14_1 = Managers.weave:current_bar_score()

						return var_14_0 < 100 and var_14_0 <= var_14_1
					end
				},
				{
					pass_type = "texture",
					style_id = "bubble_icon",
					texture_id = "bubble_icon_grayscale_id",
					content_check_function = function(arg_15_0)
						local var_15_0 = arg_15_0.bar_cutoff
						local var_15_1 = Managers.weave:current_bar_score()

						return var_15_0 < 100 and var_15_1 < var_15_0
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
			bubble_icon_id = var_10_12,
			bubble_icon_grayscale_id = var_10_14,
			essence_icon_id = var_10_10,
			background_id = var_10_0,
			background_filled_id = var_10_8,
			bar_content = {
				texture_id = var_10_2,
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
			bar_edge_glow_id = var_10_6,
			bar_bg_id = var_10_4,
			essence_amount_id = var_10_16 .. "/" .. var_10_16
		},
		style = {
			background = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = var_10_1.size,
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
				texture_size = var_10_9.size,
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
				texture_size = var_10_11.size,
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
				texture_size = var_10_3.size,
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
				texture_size = var_10_7.size,
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
				texture_size = var_10_13.size,
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
				base_offset_x = 53 + var_10_13.size[1] * 0.5
			},
			bar_bg = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = var_10_5.size,
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
					var_0_8[1] - 80,
					var_0_8[2]
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
					var_0_8[1] - 80,
					var_0_8[2]
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

local function var_0_12()
	local var_16_0 = "progress_ui"

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
		scenegraph_id = var_16_0
	}
end

local function var_0_13(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = "progress_ui"
	local var_17_1 = "matchmaking_checkbox"
	local var_17_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_17_1)
	local var_17_3 = "weaves_objective_bullet"
	local var_17_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_17_3)
	local var_17_5 = "icon_essence_small"
	local var_17_6 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_17_5)

	return {
		element = {
			passes = {
				{
					style_id = "stroke",
					pass_type = "rect",
					content_check_function = function(arg_18_0)
						return arg_18_0.is_done
					end
				},
				{
					pass_type = "texture",
					style_id = "bullet",
					texture_id = "bullet_id",
					content_check_function = function(arg_19_0)
						return not arg_19_0.is_done
					end
				},
				{
					pass_type = "texture",
					style_id = "checkmark",
					texture_id = "checkmark_id",
					content_check_function = function(arg_20_0)
						return arg_20_0.is_done
					end
				},
				{
					pass_type = "texture",
					style_id = "checkmark_shadow",
					texture_id = "checkmark_id",
					content_check_function = function(arg_21_0)
						return arg_21_0.is_done
					end
				},
				{
					style_id = "objective_name",
					pass_type = "text",
					text_id = "objective_name_id",
					content_change_function = function(arg_22_0)
						if not arg_22_0.stack then
							return
						end

						arg_22_0.objective_name_id = arg_22_0.base_objective_name_id

						local var_22_0 = arg_22_0.stack
						local var_22_1 = arg_22_0.done_stack

						arg_22_0.objective_name_id = arg_22_0.objective_name_id .. " " .. table.size(var_22_1) .. "/" .. table.size(var_22_0)
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
			essence_icon_id = var_17_5,
			checkmark_id = var_17_1,
			bullet_id = var_17_3,
			base_objective_name_id = Localize(arg_17_0),
			objective_name_id = Localize(arg_17_0),
			stack = arg_17_3 and {
				arg_17_3
			},
			done_stack = {},
			stack_name = arg_17_2,
			is_done_func = function(arg_23_0, arg_23_1)
				if arg_23_0.is_done or arg_23_0.stack == false then
					return true
				end

				return table.find(arg_23_0.done_stack, arg_23_1)
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
				texture_size = var_17_4.size,
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
					var_17_2.size[1] * 0.5,
					var_17_2.size[2] * 0.5
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
					var_17_2.size[1],
					var_17_2.size[2]
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
					var_17_6.size[1] * 0.75,
					var_17_6.size[2] * 0.75
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					80,
					-82,
					1
				}
			}
		},
		scenegraph_id = var_17_0,
		offset = {
			0,
			-50 + arg_17_1 * -25,
			5
		}
	}
end

local var_0_14 = {
	progress_ui = var_0_11("progress_ui")
}

return {
	scenegraph_definition = var_0_9,
	create_bonus_objective_header_func = var_0_12,
	create_bonus_objective_func = var_0_13,
	widgets = var_0_14
}
