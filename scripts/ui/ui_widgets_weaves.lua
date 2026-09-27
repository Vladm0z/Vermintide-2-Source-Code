-- chunkname: @scripts/ui/ui_widgets_weaves.lua

local UIWidgets = UIWidgets

UIWidgets = UIWidgets or {}
UIWidgets = UIWidgets

UIWidgets.create_leaderboard_entry_definition = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local num = 8
	local num_2 = 4
	local tbl = {
		math.floor(arg_1_1[1] * 0.18),
		arg_1_1[2]
	}
	local tbl_2 = {
		math.floor(arg_1_1[1] * 0.1),
		arg_1_1[2]
	}
	local tbl_3 = {
		math.floor(arg_1_1[1] * 0.15),
		arg_1_1[2]
	}
	local num_3 = tbl[2] - num
	local tbl_4 = {
		num_3,
		num_3
	}
	local num_4 = arg_1_1[1] - (tbl[1] + tbl_2[1] + tbl_3[1] + num_2 * 3)
	local tbl_5 = {
		math.floor(num_4),
		arg_1_1[2]
	}
	local tbl_6 = {
		0,
		0,
		0
	}
	local tbl_7 = {
		tbl_6[2] + tbl[1] + num_2,
		0,
		0
	}
	local tbl_8 = {
		tbl_7[1] + tbl_5[1] + num_2,
		0,
		0
	}
	local tbl_9 = {
		tbl_8[1] + tbl_2[1] + num_2,
		0,
		0
	}
	local str = "menu_frame_17"
	local var_1_14 = UIFrameSettings[str]
	local tbl_10 = {
		50,
		100,
		65,
		164
	}
	local tbl_11 = {
		{
			style_id = "name_frame",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "ranking_background_local_player",
			texture_id = "background",
			content_check_function = function (self)
				-- function 2
				return self.local_player
			end
		},
		{
			style_id = "ranking_background",
			texture_id = "background",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 3
				return not self.local_player
			end,
			content_change_function = function (self, arg_4_1)
				-- function 4
				if not IS_WINDOWS then
					return
				end

				local selected_color

				if not self.button_hotspot.is_hover then
					selected_color = arg_4_1.selected_color

					if not selected_color then
						-- Nothing
					end
				end

				selected_color = arg_4_1.base_color

				::label_4_0::

				arg_4_1.color = selected_color
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
			content_check_function = function (self)
				-- function 5
				return self.local_player
			end
		},
		{
			style_id = "name_background",
			texture_id = "background",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 6
				return not self.local_player
			end,
			content_change_function = function (self, arg_7_1)
				-- function 7
				if not IS_WINDOWS then
					return
				end

				local selected_color

				if not self.button_hotspot.is_hover then
					selected_color = arg_7_1.selected_color

					if not selected_color then
						-- Nothing
					end
				end

				selected_color = arg_7_1.base_color

				::label_7_0::

				arg_7_1.color = selected_color
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
			content_check_function = function (self)
				-- function 8
				return self.career_icon
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
			content_check_function = function (self)
				-- function 9
				return self.local_player
			end
		},
		{
			style_id = "weave_background",
			texture_id = "background",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 10
				return not self.local_player
			end,
			content_change_function = function (self, arg_11_1)
				-- function 11
				if not IS_WINDOWS then
					return
				end

				local selected_color

				if not self.button_hotspot.is_hover then
					selected_color = arg_11_1.selected_color

					if not selected_color then
						-- Nothing
					end
				end

				selected_color = arg_11_1.base_color

				::label_11_0::

				arg_11_1.color = selected_color
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
			content_check_function = function (self)
				-- function 12
				return self.local_player
			end
		},
		{
			style_id = "score_background",
			texture_id = "background",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 13
				return not self.local_player
			end,
			content_change_function = function (self, arg_14_1)
				-- function 14
				if not IS_WINDOWS then
					return
				end

				local selected_color

				if not self.button_hotspot.is_hover then
					selected_color = arg_14_1.selected_color

					if not selected_color then
						-- Nothing
					end
				end

				selected_color = arg_14_1.base_color

				::label_14_0::

				arg_14_1.color = selected_color
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
	local tbl_12 = {
		score = "000",
		name = "Unassigned",
		weave = "000",
		career_icon = "icons_placeholder",
		ranking = "000",
		local_player = false,
		button_hotspot = {
			allow_multi_hover = false
		}
	}
	local flag

	flag = not arg_1_2 and "rect_masked" and "simple_rect_texture"
	tbl_12.background = flag
	tbl_12.frame = var_1_14.texture
	tbl_12.size = arg_1_1

	local tbl_13 = {}
	local tbl_14 = {
		font_size = 22,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_2

	flag_2 = not arg_1_2 and "hell_shark_masked" and "hell_shark"
	tbl_14.font_type = flag_2
	tbl_14.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_14.size = tbl
	tbl_14.offset = {
		tbl_6[1],
		tbl_6[2],
		tbl_6[3] + 2
	}
	tbl_13.ranking = tbl_14

	local tbl_15 = {
		font_size = 22,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_3

	flag_3 = not arg_1_2 and "hell_shark_masked" and "hell_shark"
	tbl_15.font_type = flag_3
	tbl_15.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_15.size = tbl
	tbl_15.offset = {
		tbl_6[1] + 2,
		tbl_6[2] - 2,
		tbl_6[3] + 1
	}
	tbl_13.ranking_shadow = tbl_15
	tbl_13.ranking_frame = {
		masked = arg_1_2,
		texture_size = var_1_14.texture_size,
		texture_sizes = var_1_14.texture_sizes,
		color = {
			255,
			255,
			255,
			255
		},
		offset = tbl_6,
		size = tbl
	}
	tbl_13.ranking_background = {
		masked = arg_1_2,
		size = {
			tbl[1] - num,
			tbl[2] - num
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
			tbl_6[1] + num / 2,
			tbl_6[2] + num / 2,
			tbl_6[3]
		}
	}
	tbl_13.ranking_background_local_player = {
		masked = arg_1_2,
		size = {
			tbl[1] - num,
			tbl[2] - num
		},
		color = tbl_10,
		offset = {
			tbl_6[1] + num / 2,
			tbl_6[2] + num / 2,
			tbl_6[3]
		}
	}

	local tbl_16 = {
		font_size = 22,
		upper_case = false,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_4

	flag_4 = not arg_1_2 and "arial_masked" and "arial"
	tbl_16.font_type = flag_4
	tbl_16.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_16.size = {
		tbl_5[1] - (tbl_4[1] + 30),
		tbl_5[2]
	}
	tbl_16.offset = {
		tbl_7[1] + tbl_4[1] + 15,
		tbl_7[2],
		tbl_7[3] + 2
	}
	tbl_13.name = tbl_16

	local tbl_17 = {
		font_size = 22,
		upper_case = false,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_5

	flag_5 = not arg_1_2 and "arial_masked" and "arial"
	tbl_17.font_type = flag_5
	tbl_17.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_17.size = {
		tbl_5[1] - (tbl_4[2] + 30),
		tbl_5[2]
	}
	tbl_17.offset = {
		tbl_7[1] + tbl_4[1] + 17,
		tbl_7[2] - 2,
		tbl_7[3] + 1
	}
	tbl_13.name_shadow = tbl_17
	tbl_13.name_frame = {
		masked = arg_1_2,
		texture_size = var_1_14.texture_size,
		texture_sizes = var_1_14.texture_sizes,
		color = {
			255,
			255,
			255,
			255
		},
		offset = tbl_7,
		size = tbl_5
	}
	tbl_13.name_background = {
		masked = arg_1_2,
		size = {
			tbl_5[1] - num,
			tbl_5[2] - num
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
			tbl_7[1] + num / 2,
			tbl_7[2] + num / 2,
			tbl_7[3]
		}
	}
	tbl_13.name_background_local_player = {
		masked = arg_1_2,
		size = {
			tbl_5[1] - num,
			tbl_5[2] - num
		},
		color = tbl_10,
		offset = {
			tbl_7[1] + num / 2,
			tbl_7[2] + num / 2,
			tbl_7[3]
		}
	}
	tbl_13.career_icon = {
		masked = arg_1_2,
		size = tbl_4,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_7[1] + num / 2,
			tbl_7[2] + num / 2,
			tbl_7[3]
		}
	}

	local tbl_18 = {
		font_size = 22,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_6

	flag_6 = not arg_1_2 and "hell_shark_masked" and "hell_shark"
	tbl_18.font_type = flag_6
	tbl_18.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_18.size = tbl_2
	tbl_18.offset = {
		tbl_8[1],
		tbl_8[2],
		tbl_8[3] + 2
	}
	tbl_13.weave = tbl_18

	local tbl_19 = {
		font_size = 22,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_7

	flag_7 = not arg_1_2 and "hell_shark_masked" and "hell_shark"
	tbl_19.font_type = flag_7
	tbl_19.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_19.size = tbl_2
	tbl_19.offset = {
		tbl_8[1] + 2,
		tbl_8[2] - 2,
		tbl_8[3] + 1
	}
	tbl_13.weave_shadow = tbl_19
	tbl_13.weave_frame = {
		masked = arg_1_2,
		texture_size = var_1_14.texture_size,
		texture_sizes = var_1_14.texture_sizes,
		color = {
			255,
			255,
			255,
			255
		},
		offset = tbl_8,
		size = tbl_2
	}
	tbl_13.weave_background = {
		masked = arg_1_2,
		size = {
			tbl_2[1] - num,
			tbl_2[2] - num
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
			tbl_8[1] + num / 2,
			tbl_8[2] + num / 2,
			tbl_8[3]
		}
	}
	tbl_13.weave_background_local_player = {
		masked = arg_1_2,
		size = {
			tbl_2[1] - num,
			tbl_2[2] - num
		},
		color = tbl_10,
		offset = {
			tbl_8[1] + num / 2,
			tbl_8[2] + num / 2,
			tbl_8[3]
		}
	}

	local tbl_20 = {
		font_size = 22,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_8

	flag_8 = not arg_1_2 and "hell_shark_masked" and "hell_shark"
	tbl_20.font_type = flag_8
	tbl_20.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_20.size = tbl_3
	tbl_20.offset = {
		tbl_9[1],
		tbl_9[2],
		tbl_9[3] + 2
	}
	tbl_13.score = tbl_20

	local tbl_21 = {
		font_size = 22,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_9

	flag_9 = not arg_1_2 and "hell_shark_masked" and "hell_shark"
	tbl_21.font_type = flag_9
	tbl_21.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_21.size = tbl_3
	tbl_21.offset = {
		tbl_9[1] + 2,
		tbl_9[2] - 2,
		tbl_9[3] + 1
	}
	tbl_13.score_shadow = tbl_21
	tbl_13.score_frame = {
		masked = arg_1_2,
		texture_size = var_1_14.texture_size,
		texture_sizes = var_1_14.texture_sizes,
		color = {
			255,
			255,
			255,
			255
		},
		offset = tbl_9,
		size = tbl_3
	}
	tbl_13.score_background = {
		masked = arg_1_2,
		size = {
			tbl_3[1] - num,
			tbl_3[2] - num
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
			tbl_9[1] + num / 2,
			tbl_9[2] + num / 2,
			tbl_9[3]
		}
	}
	tbl_13.score_background_local_player = {
		masked = arg_1_2,
		size = {
			tbl_3[1] - num,
			tbl_3[2] - num
		},
		color = tbl_10,
		offset = {
			tbl_9[1] + num / 2,
			tbl_9[2] + num / 2,
			tbl_9[3]
		}
	}

	return {
		element = {
			passes = tbl_11
		},
		content = tbl_12,
		style = tbl_13,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

UIWidgets.create_leaderboard_loading_icon = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local flag = arg_15_2 or "loot_loading"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(flag).size
	local tbl = {
		{
			style_id = "texture_id",
			pass_type = "rotated_texture",
			texture_id = "texture_id",
			content_change_function = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				local progress = arg_16_1.progress

				progress = progress or 0

				local num = (progress + arg_16_3) % 1

				arg_16_1.angle = math.pow(2, math.smoothstep(num, 0, 1)) * (math.pi * 2)
				arg_16_1.progress = num
			end
		}
	}
	local tbl_2 = {
		texture_id = flag
	}
	local tbl_3 = {
		texture_id = {
			vertical_alignment = "center",
			angle = 0,
			horizontal_alignment = "center",
			texture_size = {
				size[1],
				size[2]
			},
			pivot = {
				size[1] / 2,
				size[2] / 2
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

	if not arg_15_1 then
		for i = 1, #arg_15_1 do
			local str = "overlay_" .. i
			local var_15_6 = arg_15_1[i]
			local tbl_4 = {
				pass_type = "rect",
				style_id = str
			}

			table.insert(tbl, tbl_4)

			tbl_3[str] = {
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
			passes = tbl
		},
		content = tbl_2,
		style = tbl_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_15_0
	}
end

UIWidgets.create_leaderboard_error_icon = function (arg_17_0, arg_17_1)
	-- function 17
	local tbl = {
		{
			texture_id = "texture_id",
			style_id = "texture_id",
			pass_type = "texture"
		}
	}
	local tbl_2 = {
		texture_id = "icon_connection_lost"
	}
	local tbl_3 = {
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

	for i = 1, #arg_17_1 do
		local str = "overlay_" .. i
		local var_17_4 = arg_17_1[i]
		local tbl_4 = {
			pass_type = "rect",
			style_id = str
		}

		table.insert(tbl, tbl_4)

		tbl_3[str] = {
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
			passes = tbl
		},
		content = tbl_2,
		style = tbl_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_17_0
	}
end
