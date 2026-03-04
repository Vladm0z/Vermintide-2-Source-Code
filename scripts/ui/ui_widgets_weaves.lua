-- chunkname: @scripts/ui/ui_widgets_weaves.lua

UIWidgets = UIWidgets or {}

UIWidgets.create_leaderboard_entry_definition = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = 8
	local var_1_1 = 4
	local var_1_2 = {
		math.floor(arg_1_1[1] * 0.18),
		arg_1_1[2]
	}
	local var_1_3 = {
		math.floor(arg_1_1[1] * 0.1),
		arg_1_1[2]
	}
	local var_1_4 = {
		math.floor(arg_1_1[1] * 0.15),
		arg_1_1[2]
	}
	local var_1_5 = var_1_2[2] - var_1_0
	local var_1_6 = {
		var_1_5,
		var_1_5
	}
	local var_1_7 = arg_1_1[1] - (var_1_2[1] + var_1_3[1] + var_1_4[1] + var_1_1 * 3)
	local var_1_8 = {
		math.floor(var_1_7),
		arg_1_1[2]
	}
	local var_1_9 = {
		0,
		0,
		0
	}
	local var_1_10 = {
		var_1_9[2] + var_1_2[1] + var_1_1,
		0,
		0
	}
	local var_1_11 = {
		var_1_10[1] + var_1_8[1] + var_1_1,
		0,
		0
	}
	local var_1_12 = {
		var_1_11[1] + var_1_3[1] + var_1_1,
		0,
		0
	}
	local var_1_13 = "menu_frame_17"
	local var_1_14 = UIFrameSettings[var_1_13]
	local var_1_15 = {
		50,
		100,
		65,
		164
	}
	local var_1_16 = {
		{
			style_id = "name_frame",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "ranking_background_local_player",
			texture_id = "background",
			content_check_function = function (arg_2_0)
				return arg_2_0.local_player
			end
		},
		{
			style_id = "ranking_background",
			texture_id = "background",
			pass_type = "texture",
			content_check_function = function (arg_3_0)
				return not arg_3_0.local_player
			end,
			content_change_function = function (arg_4_0, arg_4_1)
				if IS_WINDOWS then
					return
				end

				arg_4_1.color = arg_4_0.button_hotspot.is_hover and arg_4_1.selected_color or arg_4_1.base_color
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "ranking_frame",
			texture_id = "frame"
		},
		{
			style_id = "ranking",
			pass_type = "text",
			text_id = "ranking"
		},
		{
			style_id = "ranking_shadow",
			pass_type = "text",
			text_id = "ranking"
		},
		{
			pass_type = "texture",
			style_id = "name_background_local_player",
			texture_id = "background",
			content_check_function = function (arg_5_0)
				return arg_5_0.local_player
			end
		},
		{
			style_id = "name_background",
			texture_id = "background",
			pass_type = "texture",
			content_check_function = function (arg_6_0)
				return not arg_6_0.local_player
			end,
			content_change_function = function (arg_7_0, arg_7_1)
				if IS_WINDOWS then
					return
				end

				arg_7_1.color = arg_7_0.button_hotspot.is_hover and arg_7_1.selected_color or arg_7_1.base_color
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "name_frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "career_icon",
			texture_id = "career_icon",
			content_check_function = function (arg_8_0)
				return arg_8_0.career_icon
			end
		},
		{
			style_id = "name",
			pass_type = "text",
			text_id = "name"
		},
		{
			style_id = "name_shadow",
			pass_type = "text",
			text_id = "name"
		},
		{
			pass_type = "texture",
			style_id = "weave_background_local_player",
			texture_id = "background",
			content_check_function = function (arg_9_0)
				return arg_9_0.local_player
			end
		},
		{
			style_id = "weave_background",
			texture_id = "background",
			pass_type = "texture",
			content_check_function = function (arg_10_0)
				return not arg_10_0.local_player
			end,
			content_change_function = function (arg_11_0, arg_11_1)
				if IS_WINDOWS then
					return
				end

				arg_11_1.color = arg_11_0.button_hotspot.is_hover and arg_11_1.selected_color or arg_11_1.base_color
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "weave_frame",
			texture_id = "frame"
		},
		{
			style_id = "weave",
			pass_type = "text",
			text_id = "weave"
		},
		{
			style_id = "weave_shadow",
			pass_type = "text",
			text_id = "weave"
		},
		{
			pass_type = "texture",
			style_id = "score_background_local_player",
			texture_id = "background",
			content_check_function = function (arg_12_0)
				return arg_12_0.local_player
			end
		},
		{
			style_id = "score_background",
			texture_id = "background",
			pass_type = "texture",
			content_check_function = function (arg_13_0)
				return not arg_13_0.local_player
			end,
			content_change_function = function (arg_14_0, arg_14_1)
				if IS_WINDOWS then
					return
				end

				arg_14_1.color = arg_14_0.button_hotspot.is_hover and arg_14_1.selected_color or arg_14_1.base_color
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "score_frame",
			texture_id = "frame"
		},
		{
			style_id = "score",
			pass_type = "text",
			text_id = "score"
		},
		{
			style_id = "score_shadow",
			pass_type = "text",
			text_id = "score"
		}
	}
	local var_1_17 = {
		score = "000",
		name = "Unassigned",
		weave = "000",
		career_icon = "icons_placeholder",
		ranking = "000",
		local_player = false,
		button_hotspot = {
			allow_multi_hover = false
		},
		background = arg_1_2 and "rect_masked" or "simple_rect_texture",
		frame = var_1_14.texture,
		size = arg_1_1
	}
	local var_1_18 = {
		ranking = {
			font_size = 22,
			upper_case = true,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = var_1_2,
			offset = {
				var_1_9[1],
				var_1_9[2],
				var_1_9[3] + 2
			}
		},
		ranking_shadow = {
			font_size = 22,
			upper_case = true,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = var_1_2,
			offset = {
				var_1_9[1] + 2,
				var_1_9[2] - 2,
				var_1_9[3] + 1
			}
		},
		ranking_frame = {
			masked = arg_1_2,
			texture_size = var_1_14.texture_size,
			texture_sizes = var_1_14.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = var_1_9,
			size = var_1_2
		},
		ranking_background = {
			masked = arg_1_2,
			size = {
				var_1_2[1] - var_1_0,
				var_1_2[2] - var_1_0
			},
			base_color = {
				120,
				0,
				0,
				0
			},
			selected_color = {
				120,
				128,
				128,
				128
			},
			color = {
				120,
				0,
				0,
				0
			},
			offset = {
				var_1_9[1] + var_1_0 / 2,
				var_1_9[2] + var_1_0 / 2,
				var_1_9[3]
			}
		},
		ranking_background_local_player = {
			masked = arg_1_2,
			size = {
				var_1_2[1] - var_1_0,
				var_1_2[2] - var_1_0
			},
			color = var_1_15,
			offset = {
				var_1_9[1] + var_1_0 / 2,
				var_1_9[2] + var_1_0 / 2,
				var_1_9[3]
			}
		},
		name = {
			font_size = 22,
			upper_case = false,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_1_2 and "arial_masked" or "arial",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				var_1_8[1] - (var_1_6[1] + 30),
				var_1_8[2]
			},
			offset = {
				var_1_10[1] + var_1_6[1] + 15,
				var_1_10[2],
				var_1_10[3] + 2
			}
		},
		name_shadow = {
			font_size = 22,
			upper_case = false,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_1_2 and "arial_masked" or "arial",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				var_1_8[1] - (var_1_6[2] + 30),
				var_1_8[2]
			},
			offset = {
				var_1_10[1] + var_1_6[1] + 17,
				var_1_10[2] - 2,
				var_1_10[3] + 1
			}
		},
		name_frame = {
			masked = arg_1_2,
			texture_size = var_1_14.texture_size,
			texture_sizes = var_1_14.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = var_1_10,
			size = var_1_8
		},
		name_background = {
			masked = arg_1_2,
			size = {
				var_1_8[1] - var_1_0,
				var_1_8[2] - var_1_0
			},
			base_color = {
				120,
				0,
				0,
				0
			},
			selected_color = {
				120,
				128,
				128,
				128
			},
			color = {
				120,
				0,
				0,
				0
			},
			offset = {
				var_1_10[1] + var_1_0 / 2,
				var_1_10[2] + var_1_0 / 2,
				var_1_10[3]
			}
		},
		name_background_local_player = {
			masked = arg_1_2,
			size = {
				var_1_8[1] - var_1_0,
				var_1_8[2] - var_1_0
			},
			color = var_1_15,
			offset = {
				var_1_10[1] + var_1_0 / 2,
				var_1_10[2] + var_1_0 / 2,
				var_1_10[3]
			}
		},
		career_icon = {
			masked = arg_1_2,
			size = var_1_6,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_1_10[1] + var_1_0 / 2,
				var_1_10[2] + var_1_0 / 2,
				var_1_10[3]
			}
		},
		weave = {
			font_size = 22,
			upper_case = true,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = var_1_3,
			offset = {
				var_1_11[1],
				var_1_11[2],
				var_1_11[3] + 2
			}
		},
		weave_shadow = {
			font_size = 22,
			upper_case = true,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = var_1_3,
			offset = {
				var_1_11[1] + 2,
				var_1_11[2] - 2,
				var_1_11[3] + 1
			}
		},
		weave_frame = {
			masked = arg_1_2,
			texture_size = var_1_14.texture_size,
			texture_sizes = var_1_14.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = var_1_11,
			size = var_1_3
		},
		weave_background = {
			masked = arg_1_2,
			size = {
				var_1_3[1] - var_1_0,
				var_1_3[2] - var_1_0
			},
			base_color = {
				120,
				0,
				0,
				0
			},
			selected_color = {
				120,
				128,
				128,
				128
			},
			color = {
				120,
				0,
				0,
				0
			},
			offset = {
				var_1_11[1] + var_1_0 / 2,
				var_1_11[2] + var_1_0 / 2,
				var_1_11[3]
			}
		},
		weave_background_local_player = {
			masked = arg_1_2,
			size = {
				var_1_3[1] - var_1_0,
				var_1_3[2] - var_1_0
			},
			color = var_1_15,
			offset = {
				var_1_11[1] + var_1_0 / 2,
				var_1_11[2] + var_1_0 / 2,
				var_1_11[3]
			}
		},
		score = {
			font_size = 22,
			upper_case = true,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = var_1_4,
			offset = {
				var_1_12[1],
				var_1_12[2],
				var_1_12[3] + 2
			}
		},
		score_shadow = {
			font_size = 22,
			upper_case = true,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = var_1_4,
			offset = {
				var_1_12[1] + 2,
				var_1_12[2] - 2,
				var_1_12[3] + 1
			}
		},
		score_frame = {
			masked = arg_1_2,
			texture_size = var_1_14.texture_size,
			texture_sizes = var_1_14.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = var_1_12,
			size = var_1_4
		},
		score_background = {
			masked = arg_1_2,
			size = {
				var_1_4[1] - var_1_0,
				var_1_4[2] - var_1_0
			},
			base_color = {
				120,
				0,
				0,
				0
			},
			selected_color = {
				120,
				128,
				128,
				128
			},
			color = {
				120,
				0,
				0,
				0
			},
			offset = {
				var_1_12[1] + var_1_0 / 2,
				var_1_12[2] + var_1_0 / 2,
				var_1_12[3]
			}
		},
		score_background_local_player = {
			masked = arg_1_2,
			size = {
				var_1_4[1] - var_1_0,
				var_1_4[2] - var_1_0
			},
			color = var_1_15,
			offset = {
				var_1_12[1] + var_1_0 / 2,
				var_1_12[2] + var_1_0 / 2,
				var_1_12[3]
			}
		}
	}

	return {
		element = {
			passes = var_1_16
		},
		content = var_1_17,
		style = var_1_18,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

UIWidgets.create_leaderboard_loading_icon = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_2 or "loot_loading"
	local var_15_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_15_0).size
	local var_15_2 = {
		{
			style_id = "texture_id",
			pass_type = "rotated_texture",
			texture_id = "texture_id",
			content_change_function = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				local var_16_0 = ((arg_16_1.progress or 0) + arg_16_3) % 1

				arg_16_1.angle = math.pow(2, math.smoothstep(var_16_0, 0, 1)) * (math.pi * 2)
				arg_16_1.progress = var_16_0
			end
		}
	}
	local var_15_3 = {
		texture_id = var_15_0
	}
	local var_15_4 = {
		texture_id = {
			vertical_alignment = "center",
			angle = 0,
			horizontal_alignment = "center",
			texture_size = {
				var_15_1[1],
				var_15_1[2]
			},
			pivot = {
				var_15_1[1] / 2,
				var_15_1[2] / 2
			},
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
			}
		}
	}

	if arg_15_1 then
		for iter_15_0 = 1, #arg_15_1 do
			local var_15_5 = "overlay_" .. iter_15_0
			local var_15_6 = arg_15_1[iter_15_0]
			local var_15_7 = {
				pass_type = "rect",
				style_id = var_15_5
			}

			table.insert(var_15_2, var_15_7)

			var_15_4[var_15_5] = {
				scenegraph_id = var_15_6,
				color = {
					200,
					10,
					10,
					10
				},
				offset = {
					0,
					0,
					19
				}
			}
		end
	end

	return {
		element = {
			passes = var_15_2
		},
		content = var_15_3,
		style = var_15_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_15_0
	}
end

UIWidgets.create_leaderboard_error_icon = function (arg_17_0, arg_17_1)
	local var_17_0 = {
		{
			texture_id = "texture_id",
			style_id = "texture_id",
			pass_type = "texture"
		}
	}
	local var_17_1 = {
		texture_id = "icon_connection_lost"
	}
	local var_17_2 = {
		texture_id = {
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
			}
		}
	}

	for iter_17_0 = 1, #arg_17_1 do
		local var_17_3 = "overlay_" .. iter_17_0
		local var_17_4 = arg_17_1[iter_17_0]
		local var_17_5 = {
			pass_type = "rect",
			style_id = var_17_3
		}

		table.insert(var_17_0, var_17_5)

		var_17_2[var_17_3] = {
			scenegraph_id = var_17_4,
			color = {
				200,
				10,
				10,
				10
			},
			offset = {
				0,
				0,
				19
			}
		}
	end

	return {
		element = {
			passes = var_17_0
		},
		content = var_17_1,
		style = var_17_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_17_0
	}
end
