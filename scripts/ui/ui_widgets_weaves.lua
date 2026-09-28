-- chunkname: @scripts/ui/ui_widgets_weaves.lua

local UIWidgets = UIWidgets

UIWidgets = not not UIWidgets or not not {}
UIWidgets = UIWidgets

UIWidgets.create_leaderboard_entry_definition = function (scenegraph_id, size, masked)
	-- function 1
	local background_spacing = 8
	local width_spacing = 4
	local ranking_size = {
		math.floor(size[1] * 0.18),
		size[2]
	}
	local weave_size = {
		math.floor(size[1] * 0.1),
		size[2]
	}
	local score_size = {
		math.floor(size[1] * 0.15),
		size[2]
	}
	local background_height = ranking_size[2] - background_spacing
	local career_icon_size = {
		background_height,
		background_height
	}
	local spare_width = size[1] - (ranking_size[1] + weave_size[1] + score_size[1] + width_spacing * 3)
	local name_size = {
		math.floor(spare_width),
		size[2]
	}
	local ranking_offset = {
		0,
		0,
		0
	}
	local name_offset = {
		ranking_offset[2] + ranking_size[1] + width_spacing,
		0,
		0
	}
	local weave_offset = {
		name_offset[1] + name_size[1] + width_spacing,
		0,
		0
	}
	local score_offset = {
		weave_offset[1] + weave_size[1] + width_spacing,
		0,
		0
	}
	local frame_name = "menu_frame_17"
	local frame_settings = UIFrameSettings[frame_name]
	local local_player_color = {
		50,
		100,
		65,
		164
	}
	local passes = {
		{
			style_id = "name_frame",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "ranking_background_local_player",
			texture_id = "background",
			content_check_function = function (content)
				-- function 2
				return content.local_player
			end
		},
		{
			style_id = "ranking_background",
			texture_id = "background",
			pass_type = "texture",
			content_check_function = function (content)
				-- function 3
				return not content.local_player
			end,
			content_change_function = function (content, style)
				-- function 4
				if IS_WINDOWS then
					return
				end

				local selected_color

				if content.button_hotspot.is_hover then
					selected_color = style.selected_color

					if not selected_color then
						-- Nothing
					end
				end

				selected_color = style.base_color

				::label_4_0::

				style.color = selected_color
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
			content_check_function = function (content)
				-- function 5
				return content.local_player
			end
		},
		{
			style_id = "name_background",
			texture_id = "background",
			pass_type = "texture",
			content_check_function = function (content)
				-- function 6
				return not content.local_player
			end,
			content_change_function = function (content, style)
				-- function 7
				if IS_WINDOWS then
					return
				end

				local selected_color

				if content.button_hotspot.is_hover then
					selected_color = style.selected_color

					if not selected_color then
						-- Nothing
					end
				end

				selected_color = style.base_color

				::label_7_0::

				style.color = selected_color
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
			content_check_function = function (content)
				-- function 8
				return content.career_icon
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
			content_check_function = function (content)
				-- function 9
				return content.local_player
			end
		},
		{
			style_id = "weave_background",
			texture_id = "background",
			pass_type = "texture",
			content_check_function = function (content)
				-- function 10
				return not content.local_player
			end,
			content_change_function = function (content, style)
				-- function 11
				if IS_WINDOWS then
					return
				end

				local selected_color

				if content.button_hotspot.is_hover then
					selected_color = style.selected_color

					if not selected_color then
						-- Nothing
					end
				end

				selected_color = style.base_color

				::label_11_0::

				style.color = selected_color
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
			content_check_function = function (content)
				-- function 12
				return content.local_player
			end
		},
		{
			style_id = "score_background",
			texture_id = "background",
			pass_type = "texture",
			content_check_function = function (content)
				-- function 13
				return not content.local_player
			end,
			content_change_function = function (content, style)
				-- function 14
				if IS_WINDOWS then
					return
				end

				local selected_color

				if content.button_hotspot.is_hover then
					selected_color = style.selected_color

					if not selected_color then
						-- Nothing
					end
				end

				selected_color = style.base_color

				::label_14_0::

				style.color = selected_color
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
	local tbl = {
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

	flag = (not masked or not "rect_masked") and not not "simple_rect_texture"
	tbl.background = flag
	tbl.frame = frame_settings.texture
	tbl.size = size

	local content = tbl
	local tbl_2 = {}
	local tbl_3 = {
		font_size = 22,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_2

	flag_2 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_3.font_type = flag_2
	tbl_3.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_3.size = ranking_size
	tbl_3.offset = {
		ranking_offset[1],
		ranking_offset[2],
		ranking_offset[3] + 2
	}
	tbl_2.ranking = tbl_3

	local tbl_4 = {
		font_size = 22,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_3

	flag_3 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_4.font_type = flag_3
	tbl_4.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_4.size = ranking_size
	tbl_4.offset = {
		ranking_offset[1] + 2,
		ranking_offset[2] - 2,
		ranking_offset[3] + 1
	}
	tbl_2.ranking_shadow = tbl_4
	tbl_2.ranking_frame = {
		masked = masked,
		texture_size = frame_settings.texture_size,
		texture_sizes = frame_settings.texture_sizes,
		color = {
			255,
			255,
			255,
			255
		},
		offset = ranking_offset,
		size = ranking_size
	}
	tbl_2.ranking_background = {
		masked = masked,
		size = {
			ranking_size[1] - background_spacing,
			ranking_size[2] - background_spacing
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
			ranking_offset[1] + background_spacing / 2,
			ranking_offset[2] + background_spacing / 2,
			ranking_offset[3]
		}
	}
	tbl_2.ranking_background_local_player = {
		masked = masked,
		size = {
			ranking_size[1] - background_spacing,
			ranking_size[2] - background_spacing
		},
		color = local_player_color,
		offset = {
			ranking_offset[1] + background_spacing / 2,
			ranking_offset[2] + background_spacing / 2,
			ranking_offset[3]
		}
	}

	local tbl_5 = {
		font_size = 22,
		upper_case = false,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_4

	flag_4 = (not masked or not "arial_masked") and not not "arial"
	tbl_5.font_type = flag_4
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_5.size = {
		name_size[1] - (career_icon_size[1] + 30),
		name_size[2]
	}
	tbl_5.offset = {
		name_offset[1] + career_icon_size[1] + 15,
		name_offset[2],
		name_offset[3] + 2
	}
	tbl_2.name = tbl_5

	local tbl_6 = {
		font_size = 22,
		upper_case = false,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_5

	flag_5 = (not masked or not "arial_masked") and not not "arial"
	tbl_6.font_type = flag_5
	tbl_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.size = {
		name_size[1] - (career_icon_size[2] + 30),
		name_size[2]
	}
	tbl_6.offset = {
		name_offset[1] + career_icon_size[1] + 17,
		name_offset[2] - 2,
		name_offset[3] + 1
	}
	tbl_2.name_shadow = tbl_6
	tbl_2.name_frame = {
		masked = masked,
		texture_size = frame_settings.texture_size,
		texture_sizes = frame_settings.texture_sizes,
		color = {
			255,
			255,
			255,
			255
		},
		offset = name_offset,
		size = name_size
	}
	tbl_2.name_background = {
		masked = masked,
		size = {
			name_size[1] - background_spacing,
			name_size[2] - background_spacing
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
			name_offset[1] + background_spacing / 2,
			name_offset[2] + background_spacing / 2,
			name_offset[3]
		}
	}
	tbl_2.name_background_local_player = {
		masked = masked,
		size = {
			name_size[1] - background_spacing,
			name_size[2] - background_spacing
		},
		color = local_player_color,
		offset = {
			name_offset[1] + background_spacing / 2,
			name_offset[2] + background_spacing / 2,
			name_offset[3]
		}
	}
	tbl_2.career_icon = {
		masked = masked,
		size = career_icon_size,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			name_offset[1] + background_spacing / 2,
			name_offset[2] + background_spacing / 2,
			name_offset[3]
		}
	}

	local tbl_7 = {
		font_size = 22,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_6

	flag_6 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_7.font_type = flag_6
	tbl_7.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_7.size = weave_size
	tbl_7.offset = {
		weave_offset[1],
		weave_offset[2],
		weave_offset[3] + 2
	}
	tbl_2.weave = tbl_7

	local tbl_8 = {
		font_size = 22,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_7

	flag_7 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_8.font_type = flag_7
	tbl_8.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_8.size = weave_size
	tbl_8.offset = {
		weave_offset[1] + 2,
		weave_offset[2] - 2,
		weave_offset[3] + 1
	}
	tbl_2.weave_shadow = tbl_8
	tbl_2.weave_frame = {
		masked = masked,
		texture_size = frame_settings.texture_size,
		texture_sizes = frame_settings.texture_sizes,
		color = {
			255,
			255,
			255,
			255
		},
		offset = weave_offset,
		size = weave_size
	}
	tbl_2.weave_background = {
		masked = masked,
		size = {
			weave_size[1] - background_spacing,
			weave_size[2] - background_spacing
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
			weave_offset[1] + background_spacing / 2,
			weave_offset[2] + background_spacing / 2,
			weave_offset[3]
		}
	}
	tbl_2.weave_background_local_player = {
		masked = masked,
		size = {
			weave_size[1] - background_spacing,
			weave_size[2] - background_spacing
		},
		color = local_player_color,
		offset = {
			weave_offset[1] + background_spacing / 2,
			weave_offset[2] + background_spacing / 2,
			weave_offset[3]
		}
	}

	local tbl_9 = {
		font_size = 22,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_8

	flag_8 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_9.font_type = flag_8
	tbl_9.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_9.size = score_size
	tbl_9.offset = {
		score_offset[1],
		score_offset[2],
		score_offset[3] + 2
	}
	tbl_2.score = tbl_9

	local tbl_10 = {
		font_size = 22,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_9

	flag_9 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_10.font_type = flag_9
	tbl_10.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_10.size = score_size
	tbl_10.offset = {
		score_offset[1] + 2,
		score_offset[2] - 2,
		score_offset[3] + 1
	}
	tbl_2.score_shadow = tbl_10
	tbl_2.score_frame = {
		masked = masked,
		texture_size = frame_settings.texture_size,
		texture_sizes = frame_settings.texture_sizes,
		color = {
			255,
			255,
			255,
			255
		},
		offset = score_offset,
		size = score_size
	}
	tbl_2.score_background = {
		masked = masked,
		size = {
			score_size[1] - background_spacing,
			score_size[2] - background_spacing
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
			score_offset[1] + background_spacing / 2,
			score_offset[2] + background_spacing / 2,
			score_offset[3]
		}
	}
	tbl_2.score_background_local_player = {
		masked = masked,
		size = {
			score_size[1] - background_spacing,
			score_size[2] - background_spacing
		},
		color = local_player_color,
		offset = {
			score_offset[1] + background_spacing / 2,
			score_offset[2] + background_spacing / 2,
			score_offset[3]
		}
	}

	local style = tbl_2
	local widget = {}
	local element = {}

	element.passes = passes
	widget.element = element
	widget.content = content
	widget.style = style
	widget.offset = {
		0,
		0,
		0
	}
	widget.scenegraph_id = scenegraph_id

	return widget
end

UIWidgets.create_leaderboard_loading_icon = function (scenegraph_id, overlay_scenegraph_ids, optional_loading_texture)
	-- function 15
	local loading_texture = not not optional_loading_texture or not not "loot_loading"
	local loading_texture_settings = UIAtlasHelper.get_atlas_settings_by_texture_name(loading_texture)
	local loading_texture_size = loading_texture_settings.size
	local passes = {
		{
			style_id = "texture_id",
			pass_type = "rotated_texture",
			texture_id = "texture_id",
			content_change_function = function (content, style, _, dt)
				-- function 16
				local progress_2 = style.progress

				if not progress_2 then
					-- Nothing
				end

				progress_2 = 0

				local progress = progress_2

				::label_16_0::

				progress = (progress + dt) % 1

				local angle = math.pow(2, math.smoothstep(progress, 0, 1)) * (math.pi * 2)

				style.angle = angle
				style.progress = progress
			end
		}
	}
	local content = {
		texture_id = loading_texture
	}
	local style = {
		texture_id = {
			vertical_alignment = "center",
			angle = 0,
			horizontal_alignment = "center",
			texture_size = {
				loading_texture_size[1],
				loading_texture_size[2]
			},
			pivot = {
				loading_texture_size[1] / 2,
				loading_texture_size[2] / 2
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

	if overlay_scenegraph_ids then
		for i = 1, #overlay_scenegraph_ids do
			local style_id = "overlay_" .. i
			local overlay_scenegraph_id = overlay_scenegraph_ids[i]
			local pass = {
				pass_type = "rect",
				style_id = style_id
			}

			table.insert(passes, pass)

			style[style_id] = {
				scenegraph_id = overlay_scenegraph_id,
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

	local widget = {}
	local element = {}

	element.passes = passes
	widget.element = element
	widget.content = content
	widget.style = style
	widget.offset = {
		0,
		0,
		0
	}
	widget.scenegraph_id = scenegraph_id

	return widget
end

UIWidgets.create_leaderboard_error_icon = function (scenegraph_id, overlay_scenegraph_ids)
	-- function 17
	local passes = {
		{
			texture_id = "texture_id",
			style_id = "texture_id",
			pass_type = "texture"
		}
	}
	local content = {
		texture_id = "icon_connection_lost"
	}
	local style = {
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

	for i = 1, #overlay_scenegraph_ids do
		local style_id = "overlay_" .. i
		local overlay_scenegraph_id = overlay_scenegraph_ids[i]
		local pass = {
			pass_type = "rect",
			style_id = style_id
		}

		table.insert(passes, pass)

		style[style_id] = {
			scenegraph_id = overlay_scenegraph_id,
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

	local widget = {}
	local element = {}

	element.passes = passes
	widget.element = element
	widget.content = content
	widget.style = style
	widget.offset = {
		0,
		0,
		0
	}
	widget.scenegraph_id = scenegraph_id

	return widget
end
