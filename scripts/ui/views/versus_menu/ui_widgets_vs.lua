-- chunkname: @scripts/ui/views/versus_menu/ui_widgets_vs.lua

local UIWidgets = UIWidgets

UIWidgets = UIWidgets or {}
UIWidgets = UIWidgets

UIWidgets.create_new_widget_definition = function (arg_1_0, arg_1_1)
	-- function 1
	return {
		element = {
			passes = {}
		},
		content = {},
		style = {},
		offset = arg_1_1 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

UIWidgets.add_portrait_frame = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	-- function 2
	local passes = self.element.passes
	local tbl = {}
	local style = self.style
	local str = "portrait_frame"

	self.content[str] = tbl
	arg_2_4 = arg_2_4 or 1

	local var_2_4 = UIPlayerPortraitFrameSettings[arg_2_2]
	local tbl_2 = {
		255,
		255,
		255,
		255
	}
	local tbl_3 = {
		0,
		-60,
		0
	}

	for i, v in ipairs(var_2_4) do
		local str_2 = "frame_texture_" .. i
		local texture = v.texture

		texture = texture or "icons_placeholder"

		local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(texture)
		local size = v.size

		size = size or get_atlas_settings_by_texture_name.size

		local flag

		flag = not size and table.clone(size) and {
			0,
			0
		}
		flag[1] = flag[1] * arg_2_4
		flag[2] = flag[2] * arg_2_4

		local clone = table.clone
		local offset = v.offset

		offset = offset or tbl_3

		local var_2_14 = clone(offset)

		var_2_14[1] = -(flag[1] / 2) + var_2_14[1] * arg_2_4
		var_2_14[2] = var_2_14[2] * arg_2_4

		local layer = v.layer

		layer = layer or 0
		var_2_14[3] = layer
		passes[#passes + 1] = {
			pass_type = "texture",
			texture_id = str_2,
			style_id = str_2,
			content_id = str,
			retained_mode = arg_2_5
		}
		tbl[str_2] = texture

		local tbl_4 = {}
		local color = v.color

		color = color or tbl_2
		tbl_4.color = color
		tbl_4.offset = var_2_14
		tbl_4.size = flag
		tbl_4.scenegraph_id = arg_2_1
		style[str_2] = tbl_4
	end

	local tbl_5 = {
		86,
		108
	}

	tbl_5[1] = tbl_5[1] * arg_2_4
	tbl_5[2] = tbl_5[2] * arg_2_4

	if not arg_2_6 then
		local tbl_6 = {
			0,
			0,
			0
		}

		tbl_6[1] = -(tbl_5[1] / 2) + tbl_6[1] * arg_2_4
		tbl_6[2] = -(tbl_5[2] / 2) + tbl_6[2] * arg_2_4
		tbl_6[3] = 1

		local str_3 = "portrait"

		passes[#passes + 1] = {
			pass_type = "texture",
			texture_id = str_3,
			style_id = str_3,
			content_id = str,
			retained_mode = arg_2_5
		}
		tbl[str_3] = arg_2_6
		style[str_3] = {
			color = tbl_2,
			offset = tbl_6,
			size = tbl_5,
			scenegraph_id = arg_2_1
		}
	end

	local tbl_7 = {
		22,
		15
	}
	local tbl_8 = {
		0,
		0,
		0
	}

	tbl_8[1] = tbl_8[1] * arg_2_4 - tbl_7[1] / 2 - 1
	tbl_8[2] = -(tbl_5[2] / 2) + tbl_8[2] * arg_2_4 - 4
	tbl_8[3] = 15

	local str_4 = "level"

	passes[#passes + 1] = {
		pass_type = "text",
		text_id = str_4,
		style_id = str_4,
		content_id = str,
		retained_mode = arg_2_5
	}
	tbl[str_4] = arg_2_3
	style[str_4] = {
		vertical_alignment = "center",
		font_size = 12,
		horizontal_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = tbl_8,
		size = tbl_7,
		scenegraph_id = arg_2_1
	}
end

UIWidgets.add_hotspot = function (self, arg_3_1, arg_3_2)
	-- function 3
	local passes = self.element.passes
	local tbl = {}
	local style = self.style

	self.content[arg_3_1] = tbl
	passes[#passes + 1] = {
		pass_type = "hotspot",
		content_id = arg_3_1,
		style_id = arg_3_2
	}
end

UIWidgets.add_hover_glow = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local passes = self.element.passes
	local content = self.content
	local style = self.style

	passes[#passes + 1] = {
		pass_type = "texture",
		texture_id = arg_4_2,
		style_id = arg_4_4,
		content_check_function = function (self)
			-- function 5
			local is_hover = self[arg_4_3].is_hover

			is_hover = is_hover or self.force_hover

			return is_hover
		end
	}
	content[arg_4_2] = arg_4_1
end

UIWidgets.add_simple_text = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8)
	-- function 6
	local passes = self.element.passes
	local content = self.content
	local style = self.style

	passes[#passes + 1] = {
		pass_type = "text",
		text_id = arg_6_1,
		style_id = arg_6_1,
		retained_mode = arg_6_8,
		content_check_function = function (self)
			-- function 7
			return self[arg_6_1]
		end
	}
	passes[#passes + 1] = {
		pass_type = "text",
		text_id = arg_6_1,
		style_id = arg_6_1,
		retained_mode = arg_6_8,
		content_check_function = function (self)
			-- function 8
			return self[arg_6_1]
		end
	}
	content[arg_6_1] = arg_6_3

	local offset

	if not arg_6_6 then
		offset = arg_6_6.offset

		if not offset then
			-- Nothing
		end
	end

	offset = {
		0,
		0,
		0
	}

	do
		local text_color
	end

	::label_6_0::

	if not arg_6_6 then
		text_color = arg_6_6.text_color

		if not text_color then
			-- Nothing
		end
	end

	text_color = arg_6_5 or {
		255,
		255,
		255,
		255
	}

	::label_6_1::

	arg_6_6 = arg_6_6 or {
		vertical_alignment = "center",
		localize = true,
		horizontal_alignment = "center",
		word_wrap = true,
		font_size = arg_6_4,
		font_type = arg_6_7 or "hell_shark",
		text_color = text_color,
		offset = offset
	}
	arg_6_6.scenegraph_id = arg_6_2

	local clone = table.clone(arg_6_6)
	local shadow_color = arg_6_6.shadow_color

	shadow_color = shadow_color or {
		255,
		0,
		0,
		0
	}
	shadow_color[1] = text_color[1]
	clone.text_color = shadow_color
	clone.offset = {
		offset[1] + 2,
		offset[2] - 2,
		offset[3] - 1
	}
	style[arg_6_1] = arg_6_6
	style[arg_6_1 .. "_shadow"] = clone
end

UIWidgets.add_ready_icon = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local passes = self.element.passes
	local tbl = {}
	local style = self.style

	self.content[arg_9_1] = tbl
	tbl.ready = false
	tbl.ready_texture = "matchmaking_checkbox"

	local tbl_2 = {
		37,
		31
	}
	local str = "not_ready"

	passes[#passes + 1] = {
		texture_id = "ready_texture",
		pass_type = "texture",
		content_id = arg_9_1,
		style_id = str,
		content_check_function = function (self)
			-- function 10
			local slot_taken = self.slot_taken

			slot_taken = not slot_taken and not self.ready

			return slot_taken
		end
	}
	style[str] = {
		size = table.clone(tbl_2),
		offset = arg_9_3 or {
			0,
			0,
			0
		},
		color = {
			255,
			255,
			0,
			0
		},
		scenegraph_id = arg_9_2
	}

	local str_2 = "ready"

	passes[#passes + 1] = {
		texture_id = "ready_texture",
		pass_type = "texture",
		content_id = arg_9_1,
		style_id = str_2,
		content_check_function = function (self)
			-- function 11
			local slot_taken = self.slot_taken

			slot_taken = not slot_taken and self.ready

			return slot_taken
		end
	}
	style[str_2] = {
		size = table.clone(tbl_2),
		offset = arg_9_3 or {
			0,
			0,
			0
		},
		color = {
			255,
			0,
			255,
			0
		},
		scenegraph_id = arg_9_2
	}
end

UIWidgets.add_loadout_grid = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
	-- function 12
	local passes = self.element.passes
	local content = self.content
	local style = self.style
	local tbl = {
		255,
		255,
		255,
		255
	}
	local tbl_2 = {
		255,
		255,
		255,
		255
	}
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("dim_gray", 40)
	local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("white", 150)
	local tbl_3 = {
		60,
		60
	}
	local tbl_4 = {
		60,
		60
	}
	local num = 1

	if not arg_12_6 then
		num = arg_12_4
		arg_12_4 = 1
	end

	local flag = arg_12_5 or 30
	local flag_2 = arg_12_5 or 30
	local var_12_12 = arg_12_3[1]
	local var_12_13 = arg_12_3[2]

	content.rows = arg_12_4
	content.columns = num
	content.slots = arg_12_4 * num

	local num_2 = var_12_12 - (num * tbl_4[1] + flag * (num - 1))
	local num_3 = var_12_13 - (arg_12_4 * tbl_4[2] + flag_2 * (arg_12_4 - 1))
	local tbl_5 = {}
	local num_4

	if not arg_12_6 then
		num_4 = num_2 / 2

		if not num_4 then
			-- Nothing
		end
	end

	num_4 = num_2 / 2

	::label_12_0::

	tbl_5[1] = num_4
	tbl_5[2] = var_12_13 - num_3 / 2 - tbl_4[2]
	arg_12_7 = arg_12_7 or {
		0,
		0,
		0
	}

	local num_5 = 0

	for i = 1, arg_12_4 do
		for j = 1, num do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local num_6 = i - 1
			local num_7 = j - 1
			local str_2 = arg_12_1 .. str
			local tbl_6 = {}

			self.content[str_2] = tbl_6

			local tbl_7 = {
				arg_12_7[1] + tbl_5[1] + num_7 * (tbl_4[1] + flag),
				arg_12_7[2] + tbl_5[2] - num_6 * (tbl_4[2] + flag_2),
				arg_12_7[3] + num_5
			}
			local str_3 = arg_12_1 .. "_hotspot" .. str

			passes[#passes + 1] = {
				pass_type = "hotspot",
				content_id = str_2,
				style_id = str_3
			}
			style[str_3] = {
				size = tbl_4,
				offset = tbl_7,
				scenegraph_id = arg_12_2
			}
			tbl_6.drag_texture_size = tbl_4

			local str_4 = "item_icon" .. str

			passes[#passes + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_4,
				style_id = str_4,
				content_check_function = function (self)
					-- function 13
					return self[str_4]
				end
			}
			style[str_4] = {
				size = tbl_3,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_7[1],
					tbl_7[2],
					3
				},
				scenegraph_id = arg_12_2
			}

			UIWidgets.append_item_frame_pass("item_frame" .. str, passes, content, style, tbl_3, {
				tbl_7[1],
				tbl_7[2],
				4
			}, false, str_2, {
				horizontal_alignment = "center",
				vertical_alignment = "center"
			}, arg_12_2, function (self)
				-- function 14
				return self[str_4]
			end)

			local str_5 = "rarity_texture" .. str

			passes[#passes + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_5,
				style_id = str_5,
				content_check_function = function (self)
					-- function 15
					return self[str_4]
				end
			}
			style[str_5] = {
				size = tbl_3,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_7[1],
					tbl_7[2],
					0
				},
				scenegraph_id = arg_12_2
			}
			tbl_6[str_5] = "icon_bg_default"

			local str_6 = "slot" .. str

			passes[#passes + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_6,
				style_id = str_6,
				content_check_function = function (self)
					-- function 16
					return not self[str_4]
				end
			}
			style[str_6] = {
				size = tbl_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_7[1],
					tbl_7[2],
					0
				},
				scenegraph_id = arg_12_2
			}
			tbl_6[str_6] = "menu_slot_frame_01"

			local str_7 = "slot_icon" .. str

			passes[#passes + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_7,
				style_id = str_7,
				content_check_function = function (self)
					-- function 17
					return not self[str_4]
				end
			}
			style[str_7] = {
				size = {
					34,
					34
				},
				color = {
					200,
					100,
					100,
					100
				},
				offset = {
					tbl_7[1] + (tbl_4[1] - 34) / 2,
					tbl_7[2] + (tbl_4[2] - 34) - (tbl_4[1] - 34) / 2,
					2
				},
				scenegraph_id = arg_12_2
			}
			tbl_6[str_7] = "tabs_icon_all_selected"

			local str_8 = "slot_hover" .. str

			passes[#passes + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_8,
				style_id = str_8,
				content_check_function = function (self)
					-- function 18
					local highlight = self.highlight

					highlight = highlight or self.is_hover

					return highlight
				end
			}
			style[str_8] = {
				size = {
					96,
					96
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_7[1] - (96 - tbl_4[1]) / 2,
					tbl_7[2] - (96 - tbl_4[2]) / 2,
					0
				},
				scenegraph_id = arg_12_2
			}
			tbl_6[str_8] = "item_icon_hover"

			local str_9 = "slot_selected" .. str

			passes[#passes + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_9,
				style_id = str_9,
				content_check_function = function (self)
					-- function 19
					return self.is_selected
				end
			}
			style[str_9] = {
				size = {
					80,
					80
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_7[1] - (80 - tbl_4[1]) / 2,
					tbl_7[2] - (80 - tbl_4[2]) / 2,
					8
				},
				scenegraph_id = arg_12_2
			}
			tbl_6[str_9] = "item_icon_selection"
		end
	end
end

UIWidgets.create_player_panel_widget = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	local str = "talent_tree_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local str_2 = "button_frame_02"
	local var_20_3 = UIFrameSettings[str_2]
	local str_3 = "shadow_frame_02"
	local var_20_5 = UIFrameSettings[str_3]
	local str_4 = "frame_outer_glow_04"
	local var_20_7 = UIFrameSettings[str_4]
	local str_5 = "frame_outer_glow_01"
	local var_20_9 = UIFrameSettings[str_5]
	local str_6 = "frame_bevel_01"
	local var_20_11 = UIFrameSettings[str_6]
	local num = 5
	local num_2 = 4
	local tbl = {
		arg_20_1[2] / 2 - num_2,
		arg_20_1[2] / 2 - num_2
	}
	local tbl_2 = {
		nil,
		nil,
		0
	}
	local num_3

	if not arg_20_2 then
		num_3 = arg_20_1[1] + num

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = -(tbl[1] + num)

	::label_20_0::

	tbl_2[1] = num_3
	tbl_2[2] = arg_20_1[2] - tbl[2]

	local tbl_3 = {
		nil,
		0,
		0
	}
	local num_4

	if not arg_20_2 then
		num_4 = arg_20_1[1] + num

		if not num_4 then
			-- Nothing
		end
	end

	num_4 = -(tbl[1] + num)

	::label_20_1::

	tbl_3[1] = num_4

	local tbl_4 = {
		element = {}
	}
	local tbl_5 = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			style_id = "background",
			pass_type = "texture_uv",
			content_id = "background",
			content_check_function = function (self)
				-- function 21
				return not self.parent.empty
			end
		},
		{
			pass_type = "texture",
			style_id = "ready_texture",
			texture_id = "ready_texture",
			content_check_function = function (self)
				-- function 22
				return self.ready
			end
		},
		{
			pass_type = "texture",
			style_id = "unready_texture",
			texture_id = "unready_texture",
			content_check_function = function (self)
				-- function 23
				return not not self.ready or not self.empty
			end
		},
		{
			style_id = "empty_background",
			pass_type = "rect",
			content_check_function = function (self)
				-- function 24
				return self.empty
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "hover_frame",
			texture_id = "hover_frame",
			content_check_function = function (self)
				-- function 25
				local button_hotspot = self.button_hotspot
				local is_local_player

				if not self.empty then
					is_local_player = self.is_local_player

					if not is_local_player then
						is_local_player = button_hotspot.is_hover
					end
				else
					is_local_player = false
				end

				if false then
					is_local_player = true
				end

				return is_local_player
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "empty_hover_frame",
			texture_id = "empty_hover_frame",
			content_check_function = function (self)
				-- function 26
				local button_hotspot = self.button_hotspot
				local empty = self.empty

				empty = not empty and button_hotspot.is_hover

				return empty
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "empty_frame",
			texture_id = "empty_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame",
			content_check_function = function (self)
				-- function 27
				return not self.empty
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "shadow_frame",
			texture_id = "shadow_frame",
			content_check_function = function (self)
				-- function 28
				return not self.empty
			end
		},
		{
			style_id = "open_slot_text",
			pass_type = "text",
			text_id = "open_slot_text",
			content_check_function = function (self)
				-- function 29
				return self.empty
			end
		},
		{
			style_id = "open_slot_text_shadow",
			pass_type = "text",
			text_id = "open_slot_text",
			content_check_function = function (self)
				-- function 30
				return self.empty
			end
		},
		{
			style_id = "player_name",
			pass_type = "text",
			text_id = "player_name",
			content_check_function = function (self)
				-- function 31
				return not self.empty
			end
		},
		{
			style_id = "career_name",
			pass_type = "text",
			text_id = "career_name",
			content_check_function = function (self)
				-- function 32
				return not self.empty
			end
		},
		{
			style_id = "item_slot_bg_1",
			pass_type = "hotspot",
			content_id = "item_hotspot_1",
			content_check_function = function (self)
				-- function 33
				return self.parent.is_local_player
			end
		},
		{
			style_id = "item_slot_bg_2",
			pass_type = "hotspot",
			content_id = "item_hotspot_2",
			content_check_function = function (self)
				-- function 34
				return self.parent.is_local_player
			end
		},
		{
			style_id = "item_slot_bg_1",
			pass_type = "rect",
			content_check_function = function (self)
				-- function 35
				return self.is_local_player
			end
		},
		{
			pass_type = "texture",
			style_id = "item_icon_1",
			texture_id = "item_icon_1",
			content_check_function = function (self)
				-- function 36
				return self.is_local_player
			end
		},
		{
			pass_type = "texture",
			style_id = "item_icon_2",
			texture_id = "item_icon_2",
			content_check_function = function (self)
				-- function 37
				return self.is_local_player
			end
		},
		{
			style_id = "item_slot_bg_2",
			pass_type = "rect",
			content_check_function = function (self)
				-- function 38
				return self.is_local_player
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "item_slot_hover_1",
			texture_id = "hover_frame",
			content_check_function = function (self)
				-- function 39
				local item_hotspot_1 = self.item_hotspot_1
				local is_local_player = self.is_local_player

				is_local_player = not is_local_player and item_hotspot_1.is_hover

				return is_local_player
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "item_slot_hover_2",
			texture_id = "hover_frame",
			content_check_function = function (self)
				-- function 40
				local item_hotspot_2 = self.item_hotspot_2
				local is_local_player = self.is_local_player

				is_local_player = not is_local_player and item_hotspot_2.is_hover

				return is_local_player
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "item_slot_frame_1",
			texture_id = "frame",
			content_check_function = function (self)
				-- function 41
				return self.is_local_player
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "item_slot_frame_2",
			texture_id = "frame",
			content_check_function = function (self)
				-- function 42
				return self.is_local_player
			end
		}
	}
	local tbl_6 = {
		unready_texture = "ping_icon_03",
		item_icon_2 = "ping_icon_01",
		empty = true,
		player_name = "player_name",
		is_local_player = false,
		ready_texture = "ping_icon_01",
		item_icon_1 = "ping_icon_01",
		career_name = "career_name",
		button_hotspot = {},
		item_hotspot_1 = {},
		item_hotspot_2 = {},
		frame = var_20_3.texture,
		shadow_frame = var_20_5.texture,
		hover_frame = var_20_7.texture,
		empty_hover_frame = var_20_9.texture,
		empty_frame = var_20_11.texture,
		background = {
			uvs = {
				{
					0.5,
					1
				},
				{
					0.5 - math.min(arg_20_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
					1 - math.min(arg_20_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
				}
			},
			texture_id = str
		},
		open_slot_text = Localize("vs_lobby_slot_available")
	}
	local tbl_7 = {
		empty_background = {
			color = {
				80,
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
		item_icon_1 = {
			color = {
				255,
				255,
				255,
				255
			},
			size = tbl,
			offset = {
				tbl_2[1],
				tbl_2[2],
				1
			}
		},
		item_icon_2 = {
			color = {
				255,
				255,
				255,
				255
			},
			size = tbl,
			offset = {
				tbl_3[1],
				tbl_3[2],
				1
			}
		},
		item_slot_bg_1 = {
			color = {
				80,
				0,
				0,
				0
			},
			size = tbl,
			offset = tbl_2
		},
		item_slot_bg_2 = {
			color = {
				80,
				0,
				0,
				0
			},
			size = tbl,
			offset = tbl_3
		},
		item_slot_hover_1 = {
			size = tbl,
			frame_margins = {
				-14,
				-14
			},
			texture_size = var_20_3.texture_size,
			texture_sizes = var_20_3.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_2[1],
				tbl_2[2],
				2
			}
		},
		item_slot_hover_2 = {
			size = tbl,
			frame_margins = {
				-14,
				-14
			},
			texture_size = var_20_3.texture_size,
			texture_sizes = var_20_3.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_3[1],
				tbl_3[2],
				2
			}
		},
		item_slot_frame_1 = {
			size = tbl,
			texture_size = var_20_11.texture_size,
			texture_sizes = var_20_11.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_3[1],
				tbl_2[2],
				4
			}
		},
		item_slot_frame_2 = {
			size = tbl,
			texture_size = var_20_11.texture_size,
			texture_sizes = var_20_11.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_3[1],
				tbl_3[2],
				4
			}
		},
		frame = {
			texture_size = var_20_3.texture_size,
			texture_sizes = var_20_3.texture_sizes,
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
			}
		},
		empty_frame = {
			texture_size = var_20_11.texture_size,
			texture_sizes = var_20_11.texture_sizes,
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
			}
		},
		shadow_frame = {
			frame_margins = {
				-14,
				-14
			},
			texture_size = var_20_5.texture_size,
			texture_sizes = var_20_5.texture_sizes,
			color = {
				255,
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
		hover_frame = {
			frame_margins = {
				-14,
				-14
			},
			texture_size = var_20_7.texture_size,
			texture_sizes = var_20_7.texture_sizes,
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
			}
		},
		empty_hover_frame = {
			frame_margins = {
				-14,
				-14
			},
			texture_size = var_20_9.texture_size,
			texture_sizes = var_20_9.texture_sizes,
			color = {
				255,
				100,
				100,
				100
			},
			offset = {
				0,
				0,
				2
			}
		}
	}
	local tbl_8 = {
		vertical_alignment = "center",
		texture_size = {
			54,
			50
		}
	}
	local flag

	flag = not arg_20_2 and "left" and "right"
	tbl_8.horizontal_alignment = flag
	tbl_8.color = {
		255,
		255,
		255,
		255
	}

	local tbl_9 = {
		nil,
		0,
		1
	}
	local flag_2

	flag_2 = not arg_20_2 and -55 and 55
	tbl_9[1] = flag_2
	tbl_8.offset = tbl_9
	tbl_7.ready_texture = tbl_8

	local tbl_10 = {
		vertical_alignment = "center",
		texture_size = {
			54,
			50
		}
	}
	local flag_3

	flag_3 = not arg_20_2 and "left" and "right"
	tbl_10.horizontal_alignment = flag_3
	tbl_10.color = {
		255,
		255,
		255,
		255
	}

	local tbl_11 = {
		nil,
		0,
		1
	}
	local flag_4

	flag_4 = not arg_20_2 and -55 and 55
	tbl_11[1] = flag_4
	tbl_10.offset = tbl_11
	tbl_7.unready_texture = tbl_10
	tbl_7.background = {
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
	}
	tbl_7.open_slot_text = {
		word_wrap = true,
		upper_case = true,
		font_size = 24,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		font_type = "hell_shark_header",
		size = {
			arg_20_1[1],
			arg_20_1[2]
		},
		text_color = {
			255,
			60,
			60,
			60
		},
		offset = {
			0,
			0,
			2
		}
	}
	tbl_7.open_slot_text_shadow = {
		word_wrap = true,
		upper_case = true,
		font_size = 24,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		font_type = "hell_shark_header",
		size = {
			arg_20_1[1],
			arg_20_1[2]
		},
		text_color = {
			255,
			0,
			0,
			0
		},
		offset = {
			2,
			-2,
			1
		}
	}
	tbl_7.career_name = {
		word_wrap = true,
		upper_case = false,
		localize = false,
		font_size = 36,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		size = {
			arg_20_1[1] - 138,
			arg_20_1[2]
		},
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			130,
			15,
			2
		}
	}
	tbl_7.player_name = {
		word_wrap = true,
		upper_case = false,
		localize = false,
		font_size = 20,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_type = "arial",
		size = {
			arg_20_1[1] - 138,
			arg_20_1[2]
		},
		text_color = {
			255,
			160,
			160,
			160
		},
		offset = {
			130,
			-20,
			2
		}
	}
	tbl_4.element.passes = tbl_5
	tbl_4.content = tbl_6
	tbl_4.style = tbl_7
	tbl_4.offset = {
		0,
		0,
		0
	}
	tbl_4.scenegraph_id = arg_20_0

	return tbl_4
end

UIWidgets.create_round_end_score_widget = function (arg_43_0, arg_43_1, arg_43_2)
	-- function 43
	local flag = arg_43_1 or {
		500,
		80
	}
	local tbl = {
		350,
		20
	}
	local frame_inner_glow_03 = UIFrameSettings.frame_inner_glow_03
	local button_frame_02_gold = UIFrameSettings.button_frame_02_gold

	return {
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "background"
				},
				{
					pass_type = "texture_frame",
					style_id = "highlight_glow",
					texture_id = "highlight_glow",
					content_check_function = function (self)
						-- function 44
						return self.highlight
					end
				},
				{
					pass_type = "rect",
					style_id = "progress_bar_bg"
				},
				{
					pass_type = "texture_frame",
					style_id = "progress_bar_frame",
					texture_id = "progress_bar_frame"
				},
				{
					style_id = "score_progress_bar",
					pass_type = "texture_uv",
					content_id = "score_progress_bar",
					content_change_function = function (self, arg_45_1)
						-- function 45
						local score_progress = self.parent.score_progress
						local progress_bar_max_size = self.parent.progress_bar_max_size
						local min = math.min(progress_bar_max_size * score_progress / progress_bar_max_size, 1)

						self.uvs = {
							{
								0,
								0
							},
							{
								min,
								1
							}
						}
						arg_45_1.texture_size[1] = progress_bar_max_size * min
					end,
					content_check_function = function (self)
						-- function 46
						return self.parent.score_progress ~= 0
					end
				},
				{
					pass_type = "texture",
					style_id = "current_score_icon",
					texture_id = "current_score_icon"
				},
				{
					style_id = "current_score_text",
					pass_type = "text",
					text_id = "current_score_text"
				},
				{
					style_id = "round_text",
					pass_type = "text",
					text_id = "round_text"
				},
				{
					pass_type = "rect",
					style_id = "max_points"
				},
				{
					style_id = "max_points_text",
					pass_type = "text",
					text_id = "max_points_text"
				},
				{
					pass_type = "rect",
					style_id = "top_detail_rect"
				}
			}
		},
		content = {
			round_text = "Round 1",
			current_score_icon = "round_end_score_bar_slider",
			current_score_text = "0",
			current_score = 0,
			highlight = false,
			max_score = 0,
			unclaimed_points = 0,
			score_progress = 0,
			max_points_text = "0",
			highlight_glow = frame_inner_glow_03.texture,
			progress_bar_frame = button_frame_02_gold.texture,
			progress_bar_max_size = tbl[1],
			score_progress_bar = {
				texture_id = "score_bar_fill",
				uvs = {
					{
						0,
						0
					},
					{
						0,
						1
					}
				}
			}
		},
		style = {
			background = {
				size = flag,
				color = {
					255,
					90,
					90,
					90
				},
				offset = {
					0,
					0,
					1
				}
			},
			highlight_glow = {
				frame_margins = {
					2,
					2
				},
				texture_size = frame_inner_glow_03.texture_size,
				texture_sizes = frame_inner_glow_03.texture_sizes,
				color = Colors.get_color_table_with_alpha("gold", 255),
				offset = {
					0,
					0,
					15
				}
			},
			progress_bar_bg = {
				size = tbl,
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					75,
					15,
					3
				}
			},
			score_progress_bar = {
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					350,
					20
				},
				offset = {
					75,
					15,
					6
				}
			},
			progress_bar_frame = {
				size = {
					tbl[1] + 4,
					tbl[2] + 4
				},
				default_size = tbl,
				texture_size = button_frame_02_gold.texture_size,
				texture_sizes = button_frame_02_gold.texture_sizes,
				frame_margins = {
					0,
					0
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					73,
					13,
					7
				},
				default_offset = {
					73,
					13,
					20
				}
			},
			max_points = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				size = {
					34,
					30
				},
				color = {
					255,
					58,
					58,
					58
				},
				offset = {
					flag[1] - 75,
					10,
					10
				}
			},
			current_score_icon = {
				horizontal_alignment = "left",
				size = {
					32,
					24
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					43,
					13,
					10
				}
			},
			round_text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				use_shadow = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				size = {
					flag[1] - 90,
					flag[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					70,
					-5,
					4
				}
			},
			current_score_text = {
				font_size = 24,
				upper_case = false,
				localize = false,
				use_shadow = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				font_type = "hell_shark",
				size = {
					32,
					24
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					43,
					15,
					11
				}
			},
			max_points_text = {
				font_size = 24,
				upper_case = true,
				localize = false,
				use_shadow = true,
				word_wrap = false,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				size = {
					15,
					30
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					flag[1] - 72,
					8,
					11
				}
			},
			top_detail_rect = {
				size = {
					flag[1],
					4
				},
				color = {
					255,
					145,
					145,
					145
				},
				offset = {
					0,
					flag[2] - 4,
					12
				}
			}
		},
		scenegraph_id = arg_43_0,
		offset = arg_43_2 or {
			0,
			0,
			10
		}
	}
end

UIWidgets.create_round_end_total_score_widget = function (arg_47_0, arg_47_1, arg_47_2)
	-- function 47
	local flag = arg_47_1 or {
		1180,
		120
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background_left",
					texture_id = "background_left"
				},
				{
					style_id = "background_right",
					pass_type = "texture_uv",
					content_id = "background_right"
				},
				{
					pass_type = "texture",
					style_id = "left_detail",
					texture_id = "left_detail"
				},
				{
					style_id = "right_detail",
					pass_type = "texture_uv",
					content_id = "right_detail"
				},
				{
					pass_type = "texture",
					style_id = "team_1_frame",
					texture_id = "team_1_frame"
				},
				{
					pass_type = "texture",
					style_id = "team_1_icon",
					texture_id = "team_1_icon"
				},
				{
					pass_type = "texture",
					style_id = "team_2_frame",
					texture_id = "team_2_frame"
				},
				{
					pass_type = "texture",
					style_id = "team_2_icon",
					texture_id = "team_2_icon"
				}
			}
		},
		content = {
			team_2_frame = "team_icon_background",
			team_1_frame = "team_icon_background",
			team_1_icon = "team_icon_hammers",
			team_2_icon = "team_icon_skulls",
			left_detail = "button_detail_12",
			background_left = "headline_bg_60",
			background_right = {
				texture_id = "headline_bg_60",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			},
			right_detail = {
				texture_id = "button_detail_12",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			}
		},
		style = {
			background_left = {
				size = {
					flag[1] * 0.5,
					flag[2]
				},
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				}
			},
			background_right = {
				size = {
					flag[1] * 0.5,
					flag[2]
				},
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					flag[1] * 0.5,
					0,
					1
				}
			},
			left_detail = {
				size = {
					40,
					180
				},
				offset = {
					-10,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			right_detail = {
				size = {
					40,
					180
				},
				offset = {
					flag[1] - 30,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			team_1_frame = {
				size = {
					80,
					80
				},
				color = Colors.get_color_table_with_alpha("local_player_team_lighter", 255),
				offset = {
					30,
					90,
					2
				}
			},
			team_1_icon = {
				size = {
					80,
					80
				},
				color = Colors.get_color_table_with_alpha("local_player_team_lighter", 255),
				offset = {
					30,
					90,
					3
				}
			},
			team_2_frame = {
				size = {
					80,
					80
				},
				color = Colors.get_color_table_with_alpha("opponent_team_lighter", 255),
				offset = {
					30,
					10,
					2
				}
			},
			team_2_icon = {
				size = {
					80,
					80
				},
				color = Colors.get_color_table_with_alpha("opponent_team_lighter", 255),
				offset = {
					30,
					10,
					3
				}
			}
		},
		offset = arg_47_2 or {
			0,
			0,
			1
		},
		scenegraph_id = arg_47_0
	}
end

UIWidgets.create_player_panel = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	-- function 48
	fassert(arg_48_1, "[UIWidgets.create_player_panel], A talent tooltip scenegraph id must be provided")

	local flag = arg_48_3 or {
		620,
		160
	}
	local menu_frame_09 = UIFrameSettings.menu_frame_09
	local str = "talent_tree_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local INSIGNIA_OFFSET = UISettings.INSIGNIA_OFFSET

	return {
		element = {
			passes = {
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "host_texture",
					texture_id = "host_texture",
					content_check_function = function (self)
						-- function 49
						return self.show_host
					end
				},
				{
					pass_type = "texture",
					style_id = "ping_texture",
					texture_id = "ping_texture",
					content_check_function = function (self)
						-- function 50
						return self.show_ping
					end
				},
				{
					style_id = "ping_text",
					pass_type = "text",
					text_id = "ping_text",
					content_check_function = function (self, arg_51_1)
						-- function 51
						local show_ping = self.show_ping

						show_ping = not show_ping and Application.user_setting("show_numerical_latency")

						return show_ping
					end
				},
				{
					style_id = "build_private_text",
					pass_type = "text",
					text_id = "build_private_text",
					content_check_function = function (self, arg_52_1)
						-- function 52
						return not self.is_build_visible
					end
				},
				{
					pass_type = "rect",
					style_id = "chat_button_background",
					texture_id = "chat_button_texture"
				},
				{
					texture_id = "button_frame",
					style_id = "chat_button_frame",
					pass_type = "texture"
				},
				{
					style_id = "chat_button_hotspot",
					texture_id = "chat_button_texture",
					pass_type = "texture",
					content_change_function = function (self, arg_53_1)
						-- function 53
						local color = arg_53_1.color
						local flag

						flag = not self.show_chat_button and 255 and 60
						color[1] = flag
					end
				},
				{
					pass_type = "texture",
					style_id = "chat_button_disabled",
					texture_id = "disabled_texture",
					content_check_function = function (self)
						-- function 54
						local show_chat_button = self.show_chat_button

						show_chat_button = not show_chat_button and self.chat_button_hotspot.is_selected

						return show_chat_button
					end
				},
				{
					style_id = "chat_button_hotspot",
					pass_type = "hotspot",
					content_id = "chat_button_hotspot",
					content_check_function = function (self)
						-- function 55
						return not self.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "chat_tooltip_text_mute",
					content_check_function = function (self)
						-- function 56
						local show_chat_button = self.show_chat_button

						show_chat_button = not show_chat_button and not not self.chat_button_hotspot.is_selected or self.chat_button_hotspot.is_hover

						return show_chat_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "chat_tooltip_text_unmute",
					content_check_function = function (self)
						-- function 57
						local show_chat_button = self.show_chat_button

						if not show_chat_button then
							show_chat_button = self.chat_button_hotspot.is_selected
							show_chat_button = not show_chat_button and self.chat_button_hotspot.is_hover
						end

						return show_chat_button
					end
				},
				{
					pass_type = "rect",
					style_id = "voice_button_background",
					texture_id = "voice_button_texture"
				},
				{
					texture_id = "button_frame",
					style_id = "voice_chat_button_frame",
					pass_type = "texture"
				},
				{
					style_id = "voice_button_hotspot",
					texture_id = "voice_button_texture",
					pass_type = "texture",
					content_change_function = function (self, arg_58_1)
						-- function 58
						local color = arg_58_1.color
						local flag

						flag = not self.show_voice_button and 255 and 60
						color[1] = flag
					end
				},
				{
					pass_type = "texture",
					style_id = "voice_button_disabled",
					texture_id = "disabled_texture",
					content_check_function = function (self)
						-- function 59
						local show_voice_button = self.show_voice_button

						show_voice_button = not show_voice_button and self.voice_button_hotspot.is_selected

						return show_voice_button
					end
				},
				{
					style_id = "voice_button_hotspot",
					pass_type = "hotspot",
					content_id = "voice_button_hotspot",
					content_check_function = function (self)
						-- function 60
						return not self.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "voice_tooltip_text_mute",
					content_check_function = function (self)
						-- function 61
						local show_voice_button = self.show_voice_button

						show_voice_button = not show_voice_button and not not self.voice_button_hotspot.is_selected or self.voice_button_hotspot.is_hover

						return show_voice_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "voice_tooltip_text_unmute",
					content_check_function = function (self)
						-- function 62
						local show_voice_button = self.show_voice_button

						if not show_voice_button then
							show_voice_button = self.voice_button_hotspot.is_selected
							show_voice_button = not show_voice_button and self.voice_button_hotspot.is_hover
						end

						return show_voice_button
					end
				},
				{
					pass_type = "rect",
					style_id = "kick_button_background",
					texture_id = "kick_button_texture"
				},
				{
					pass_type = "texture",
					style_id = "kick_button_frame",
					texture_id = "button_frame"
				},
				{
					style_id = "kick_button_hotspot",
					texture_id = "kick_button_texture",
					pass_type = "texture",
					content_change_function = function (self, arg_63_1)
						-- function 63
						local color = arg_63_1.color
						local flag

						flag = not self.show_kick_button and 255 and 60
						color[1] = flag
					end
				},
				{
					style_id = "kick_button_hotspot",
					pass_type = "hotspot",
					content_id = "kick_button_hotspot",
					content_check_function = function (self)
						-- function 64
						return not self.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "kick_tooltip_text",
					content_check_function = function (self)
						-- function 65
						local show_kick_button = self.show_kick_button

						show_kick_button = not show_kick_button and self.kick_button_hotspot.is_hover

						return show_kick_button
					end
				},
				{
					pass_type = "rect",
					style_id = "profile_button_background",
					texture_id = "profile_button_texture"
				},
				{
					pass_type = "texture",
					style_id = "profile_button_frame",
					texture_id = "button_frame"
				},
				{
					style_id = "profile_button_hotspot",
					texture_id = "profile_button_texture",
					pass_type = "texture",
					content_change_function = function (self, arg_66_1)
						-- function 66
						local color = arg_66_1.color
						local flag

						flag = not self.show_profile_button and 255 and 60
						color[1] = flag
					end
				},
				{
					style_id = "profile_button_hotspot",
					pass_type = "hotspot",
					content_id = "profile_button_hotspot",
					content_check_function = function (self)
						-- function 67
						return not self.disable_button
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "profile_tooltip_text",
					content_check_function = function (self)
						-- function 68
						local show_profile_button = self.show_profile_button

						show_profile_button = not show_profile_button and self.profile_button_hotspot.is_hover

						return show_profile_button
					end
				},
				{
					style_id = "name",
					pass_type = "text",
					text_id = "name",
					content_check_function = function (self, arg_69_1)
						-- function 69
						if self.button_hotspot.is_selected or not self.controller_button_hotspot.is_hover then
							arg_69_1.text_color = arg_69_1.hover_color
						else
							arg_69_1.text_color = arg_69_1.color
						end

						return true
					end
				},
				{
					style_id = "name_shadow",
					pass_type = "text",
					text_id = "name"
				},
				{
					style_id = "hero",
					pass_type = "text",
					text_id = "hero",
					content_check_function = function (self, arg_70_1)
						-- function 70
						if self.button_hotspot.is_selected or not self.controller_button_hotspot.is_hover then
							arg_70_1.text_color = arg_70_1.hover_color
						else
							arg_70_1.text_color = arg_70_1.color
						end

						return true
					end
				},
				{
					style_id = "hero_shadow",
					pass_type = "text",
					text_id = "hero"
				},
				{
					style_id = "hp_bar_bg",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 71
						return not self.is_dark_pact and self.is_in_local_player_party
					end
				},
				{
					style_id = "hp_bar_fg_start",
					pass_type = "texture_uv",
					content_id = "hp_bar_fg_start",
					content_check_function = function (self)
						-- function 72
						return not self.parent.is_dark_pact and self.parent.is_in_local_player_party
					end
				},
				{
					style_id = "hp_bar_fg_middle",
					pass_type = "texture_uv",
					content_id = "hp_bar_fg_middle",
					content_check_function = function (self)
						-- function 73
						return not self.parent.is_dark_pact and self.parent.is_in_local_player_party
					end
				},
				{
					style_id = "hp_bar_fg_end",
					pass_type = "texture_uv",
					content_id = "hp_bar_fg_end",
					content_check_function = function (self)
						-- function 74
						return not self.parent.is_dark_pact and self.parent.is_in_local_player_party
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "health_bar",
					texture_id = "texture_id",
					content_id = "health_bar",
					content_check_function = function (self)
						-- function 75
						return not self.parent.is_dark_pact and self.parent.is_in_local_player_party
					end
				},
				{
					style_id = "total_health_bar",
					texture_id = "texture_id",
					pass_type = "gradient_mask_texture",
					content_id = "total_health_bar",
					content_change_function = function (self, arg_76_1)
						-- function 76
						if not self.parent.is_knocked_down then
							arg_76_1.color = Colors.get_color_table_with_alpha("red", 255)
						else
							arg_76_1.color = Colors.get_color_table_with_alpha("white", 255)
						end
					end,
					content_check_function = function (self)
						-- function 77
						local is_local_player = self.parent.is_local_player

						is_local_player = not is_local_player and not not self.parent.is_dark_pact or self.parent.is_in_local_player_party

						return is_local_player
					end
				},
				{
					style_id = "ability_bar",
					pass_type = "texture_uv",
					content_id = "ability_bar",
					content_change_function = function (self, arg_78_1)
						-- function 78
						local bar_value = self.bar_value
						local texture_size = arg_78_1.texture_size
						local uvs = self.uvs
						local var_78_3 = arg_78_1.full_size[1]

						uvs[2][2] = bar_value
						texture_size[1] = var_78_3 * bar_value
					end,
					content_check_function = function (self)
						-- function 79
						local is_local_player = self.parent.is_local_player

						is_local_player = not is_local_player and not not self.parent.is_dark_pact or self.parent.is_in_local_player_party

						return is_local_player
					end
				},
				{
					pass_type = "texture",
					style_id = "slot_melee",
					texture_id = "slot_melee",
					content_check_function = function (self)
						-- function 80
						return self.slot_melee
					end
				},
				{
					style_id = "slot_melee",
					pass_type = "hotspot",
					content_id = "slot_melee_hotspot",
					content_check_function = function (self)
						-- function 81
						return self.parent.slot_melee
					end
				},
				{
					pass_type = "texture",
					style_id = "slot_melee_frame",
					texture_id = "slot_melee_frame",
					content_check_function = function (self)
						-- function 82
						return self.slot_melee
					end
				},
				{
					pass_type = "texture",
					style_id = "slot_melee_rarity_texture",
					texture_id = "slot_melee_rarity_texture",
					content_check_function = function (self)
						-- function 83
						return self.slot_melee
					end
				},
				{
					pass_type = "texture",
					style_id = "slot_ranged",
					texture_id = "slot_ranged",
					content_check_function = function (self)
						-- function 84
						return self.slot_ranged
					end
				},
				{
					style_id = "slot_ranged",
					pass_type = "hotspot",
					content_id = "slot_ranged_hotspot",
					content_check_function = function (self)
						-- function 85
						return self.parent.slot_ranged
					end
				},
				{
					pass_type = "texture",
					style_id = "slot_ranged_frame",
					texture_id = "slot_ranged_frame",
					content_check_function = function (self)
						-- function 86
						return self.slot_ranged
					end
				},
				{
					pass_type = "texture",
					style_id = "slot_ranged_rarity_texture",
					texture_id = "slot_ranged_rarity_texture",
					content_check_function = function (self)
						-- function 87
						return self.slot_ranged
					end
				},
				{
					pass_type = "texture",
					style_id = "talent_1_frame",
					texture_id = "talent_frame",
					content_check_function = function (self)
						-- function 88
						return self.talent_1.talent
					end
				},
				{
					style_id = "talent_1",
					pass_type = "hotspot",
					content_id = "talent_1"
				},
				{
					texture_id = "icon",
					style_id = "talent_1",
					pass_type = "texture",
					content_id = "talent_1",
					content_check_function = function (self)
						-- function 89
						return self.talent
					end
				},
				{
					style_id = "talent_tooltip",
					talent_id = "talent",
					pass_type = "talent_tooltip",
					content_id = "talent_1",
					scenegraph_id = arg_48_1,
					content_check_function = function (self)
						-- function 90
						local talent = self.talent

						talent = not talent and self.is_hover

						return talent
					end
				},
				{
					pass_type = "texture",
					style_id = "talent_2_frame",
					texture_id = "talent_frame",
					content_check_function = function (self)
						-- function 91
						return self.talent_2.talent
					end
				},
				{
					style_id = "talent_2",
					pass_type = "hotspot",
					content_id = "talent_2"
				},
				{
					texture_id = "icon",
					style_id = "talent_2",
					pass_type = "texture",
					content_id = "talent_2",
					content_check_function = function (self)
						-- function 92
						return self.talent
					end
				},
				{
					style_id = "talent_tooltip",
					talent_id = "talent",
					pass_type = "talent_tooltip",
					content_id = "talent_2",
					scenegraph_id = arg_48_1,
					content_check_function = function (self)
						-- function 93
						local talent = self.talent

						talent = not talent and self.is_hover

						return talent
					end
				},
				{
					pass_type = "texture",
					style_id = "talent_3_frame",
					texture_id = "talent_frame",
					content_check_function = function (self)
						-- function 94
						return self.talent_3.talent
					end
				},
				{
					style_id = "talent_3",
					pass_type = "hotspot",
					content_id = "talent_3"
				},
				{
					texture_id = "icon",
					style_id = "talent_3",
					pass_type = "texture",
					content_id = "talent_3",
					content_check_function = function (self)
						-- function 95
						return self.talent
					end
				},
				{
					style_id = "talent_tooltip",
					talent_id = "talent",
					pass_type = "talent_tooltip",
					content_id = "talent_3",
					scenegraph_id = arg_48_1,
					content_check_function = function (self)
						-- function 96
						local talent = self.talent

						talent = not talent and self.is_hover

						return talent
					end
				},
				{
					pass_type = "texture",
					style_id = "talent_4_frame",
					texture_id = "talent_frame",
					content_check_function = function (self)
						-- function 97
						return self.talent_4.talent
					end
				},
				{
					style_id = "talent_4",
					pass_type = "hotspot",
					content_id = "talent_4"
				},
				{
					texture_id = "icon",
					style_id = "talent_4",
					pass_type = "texture",
					content_id = "talent_4",
					content_check_function = function (self)
						-- function 98
						return self.talent
					end
				},
				{
					style_id = "talent_tooltip",
					talent_id = "talent",
					pass_type = "talent_tooltip",
					content_id = "talent_4",
					scenegraph_id = arg_48_1,
					content_check_function = function (self)
						-- function 99
						local talent = self.talent

						talent = not talent and self.is_hover

						return talent
					end
				},
				{
					pass_type = "texture",
					style_id = "talent_5_frame",
					texture_id = "talent_frame",
					content_check_function = function (self)
						-- function 100
						return self.talent_5.talent
					end
				},
				{
					style_id = "talent_5",
					pass_type = "hotspot",
					content_id = "talent_5"
				},
				{
					texture_id = "icon",
					style_id = "talent_5",
					pass_type = "texture",
					content_id = "talent_5",
					content_check_function = function (self)
						-- function 101
						return self.talent
					end
				},
				{
					style_id = "talent_tooltip",
					talent_id = "talent",
					pass_type = "talent_tooltip",
					content_id = "talent_5",
					scenegraph_id = arg_48_1,
					content_check_function = function (self)
						-- function 102
						local talent = self.talent

						talent = not talent and self.is_hover

						return talent
					end
				},
				{
					pass_type = "texture",
					style_id = "talent_6_frame",
					texture_id = "talent_frame",
					content_check_function = function (self)
						-- function 103
						return self.talent_6.talent
					end
				},
				{
					style_id = "talent_6",
					pass_type = "hotspot",
					content_id = "talent_6"
				},
				{
					texture_id = "icon",
					style_id = "talent_6",
					pass_type = "texture",
					content_id = "talent_6",
					content_check_function = function (self)
						-- function 104
						return self.talent
					end
				},
				{
					style_id = "talent_tooltip",
					talent_id = "talent",
					pass_type = "talent_tooltip",
					content_id = "talent_6",
					scenegraph_id = arg_48_1,
					content_check_function = function (self)
						-- function 105
						local talent = self.talent

						talent = not talent and self.is_hover

						return talent
					end
				},
				{
					style_id = "respawn_text",
					pass_type = "text",
					text_id = "respawn_text",
					content_check_function = function (self)
						-- function 106
						local is_dark_pact = self.is_dark_pact

						is_dark_pact = not is_dark_pact and self.respawning

						return is_dark_pact
					end
				},
				content_id = "slot_ranged_hotspot"
			}
		},
		content = {
			name = "n/a",
			show_chat_button = false,
			profile_button_texture = "tab_menu_icon_05",
			show_kick_button = false,
			voice_button_texture = "tab_menu_icon_01",
			hero = "wh_captain",
			host_texture = "host_icon",
			slot_melee_frame = "reward_pop_up_item_frame",
			ping_texture = "ping_icon_03",
			disabled_texture = "tab_menu_icon_03",
			kick_tooltip_text = "input_description_vote_kick_player",
			voice_tooltip_text_unmute = "input_description_unmute_voice",
			talent_frame = "talent_frame",
			profile_tooltip_text = "input_description_show_profile",
			voice_tooltip_text_mute = "input_description_mute_voice",
			chat_button_texture = "tab_menu_icon_02",
			build_private_text = "visibility_private",
			button_frame = "reward_pop_up_item_frame",
			chat_tooltip_text_unmute = "input_description_unmute_chat",
			ping_text = "150",
			slot_melee_rarity_texture = "icon_bg_plentiful",
			chat_tooltip_text_mute = "input_description_mute_chat",
			show_ping = false,
			respawn_text = "0",
			hp_bar_bg = "hud_teammate_hp_bar_bg",
			kick_button_texture = "tab_menu_icon_04",
			show_profile_button = false,
			show_voice_button = false,
			slot_ranged_rarity_texture = "icon_bg_plentiful",
			slot_ranged_frame = "reward_pop_up_item_frame",
			frame = menu_frame_09.texture,
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						math.min(flag[1] / get_atlas_settings_by_texture_name.size[1], 1),
						math.min((flag[2] - 50) / get_atlas_settings_by_texture_name.size[2], 1)
					}
				},
				texture_id = str
			},
			button_hotspot = {
				allow_multi_hover = true
			},
			chat_button_hotspot = {},
			kick_button_hotspot = {},
			voice_button_hotspot = {},
			profile_button_hotspot = {},
			controller_button_hotspot = {},
			hp_bar_fg_start = {
				texture_id = "hud_teammate_hp_bar_frame",
				uvs = {
					{
						0,
						0
					},
					{
						0.2,
						1
					}
				}
			},
			hp_bar_fg_middle = {
				texture_id = "hud_teammate_hp_bar_frame",
				uvs = {
					{
						0.2,
						0
					},
					{
						0.8,
						1
					}
				}
			},
			hp_bar_fg_end = {
				texture_id = "hud_teammate_hp_bar_frame",
				uvs = {
					{
						0.8,
						0
					},
					{
						1,
						1
					}
				}
			},
			health_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				draw_health_bar = true,
				texture_id = "teammate_hp_bar_color_tint_" .. math.min(arg_48_2, 8)
			},
			total_health_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				draw_health_bar = true,
				texture_id = "teammate_hp_bar_" .. math.min(arg_48_2, 8)
			},
			ability_bar = {
				bar_value = 1,
				texture_id = "hud_teammate_ability_bar_fill",
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
			slot_melee_hotspot = {},
			slot_ranged_hotspot = {},
			talent_1 = {
				is_selected = true
			},
			talent_2 = {
				is_selected = true
			},
			talent_3 = {
				is_selected = true
			},
			talent_4 = {
				is_selected = true
			},
			talent_5 = {
				is_selected = true
			},
			talent_6 = {
				is_selected = true
			}
		},
		style = {
			slot_melee = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-215,
					-10,
					1
				}
			},
			slot_melee_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-215,
					-10,
					2
				}
			},
			slot_melee_rarity_texture = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-215,
					-10,
					0
				}
			},
			slot_ranged = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-165,
					-10,
					1
				}
			},
			slot_ranged_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-165,
					-10,
					2
				}
			},
			slot_ranged_rarity_texture = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-165,
					-10,
					0
				}
			},
			talent_tooltip = {
				draw_downwards = false
			},
			talent_1 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-215,
					-60,
					1
				}
			},
			talent_1_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-215,
					-60,
					2
				}
			},
			talent_2 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-175,
					-60,
					1
				}
			},
			talent_2_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-175,
					-60,
					2
				}
			},
			talent_3 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-135,
					-60,
					1
				}
			},
			talent_3_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-135,
					-60,
					2
				}
			},
			talent_4 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-95,
					-60,
					1
				}
			},
			talent_4_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-95,
					-60,
					2
				}
			},
			talent_5 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-55,
					-60,
					1
				}
			},
			talent_5_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-55,
					-60,
					2
				}
			},
			talent_6 = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				draw_right = true,
				draw_downwards = false,
				area_size = {
					40,
					40
				},
				texture_size = {
					40,
					40
				},
				offset = {
					-15 + 0 * -40,
					-60,
					1
				}
			},
			talent_6_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				offset = {
					-15 + 0 * -40,
					-60,
					2
				}
			},
			health_bar = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				gradient_threshold = 1,
				texture_size = {
					200 - INSIGNIA_OFFSET,
					18
				},
				color = {
					255,
					0,
					255,
					0
				},
				offset = {
					150 + INSIGNIA_OFFSET,
					-82,
					14
				}
			},
			total_health_bar = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				gradient_threshold = 1,
				texture_size = {
					200 - INSIGNIA_OFFSET,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					150 + INSIGNIA_OFFSET,
					-82,
					13
				}
			},
			ability_bar = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				full_size = {
					194 - INSIGNIA_OFFSET,
					10
				},
				texture_size = {
					200,
					12
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					153 + INSIGNIA_OFFSET,
					-100,
					13
				}
			},
			hp_bar_bg = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_tiling_size = {
					100,
					20
				},
				texture_size = {
					200 - INSIGNIA_OFFSET,
					30
				},
				tile_offset = {
					true,
					false
				},
				offset = {
					150 + INSIGNIA_OFFSET,
					-82,
					10
				},
				color = {
					255,
					30,
					30,
					30
				}
			},
			hp_bar_fg_start = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					20,
					35
				},
				offset = {
					150 + INSIGNIA_OFFSET,
					-80,
					15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			hp_bar_fg_middle = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					160 - INSIGNIA_OFFSET,
					35
				},
				offset = {
					170 + INSIGNIA_OFFSET,
					-80,
					15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			hp_bar_fg_end = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					20,
					35
				},
				offset = {
					330,
					-80,
					15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			frame = {
				texture_size = menu_frame_09.texture_size,
				texture_sizes = menu_frame_09.texture_sizes,
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
			},
			background = {
				size = {
					flag[1],
					flag[2]
				},
				color = {
					200,
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
			tooltip_text = {
				vertical_alignment = "top",
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				font_size = 18,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			},
			profile_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-170,
					10,
					1
				}
			},
			profile_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-170,
					10,
					3
				}
			},
			profile_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-170,
					10,
					2
				}
			},
			voice_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-120,
					10,
					3
				}
			},
			voice_chat_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-120,
					10,
					6
				}
			},
			voice_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-120,
					10,
					4
				}
			},
			voice_button_disabled = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					0,
					0
				},
				offset = {
					-120,
					10,
					5
				}
			},
			chat_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-70,
					10,
					1
				}
			},
			chat_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-70,
					10,
					6
				}
			},
			chat_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-70,
					10,
					4
				}
			},
			chat_button_disabled = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					255,
					0,
					0
				},
				offset = {
					-70,
					10,
					5
				}
			},
			kick_button_background = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-20 + 0 * -50,
					10,
					3
				}
			},
			kick_button_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					-20 + 0 * -50,
					10,
					6
				}
			},
			kick_button_hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					40,
					40
				},
				area_size = {
					40,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-20 + 0 * -50,
					10,
					4
				}
			},
			ping_texture = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					54,
					50
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-210,
					5,
					5
				}
			},
			ping_text = {
				horizontal_alignment = "right",
				font_size = 20,
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "arial",
				offset = {
					-255,
					13,
					3
				},
				text_color = Colors.get_table("font_default"),
				high_ping_color = Colors.get_table("crimson"),
				medium_ping_color = Colors.get_table("gold"),
				low_ping_color = Colors.get_table("lime_green")
			},
			build_private_text = {
				vertical_alignment = "top",
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				font_type = "hell_shark_header",
				font_size = 24,
				offset = {
					200,
					-20,
					1
				},
				text_color = {
					255,
					128,
					128,
					128
				}
			},
			host_texture = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-509,
					1,
					14
				},
				texture_size = {
					40,
					40
				}
			},
			name = {
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "arial",
				size = {
					210 - INSIGNIA_OFFSET,
					30
				},
				offset = {
					150 + INSIGNIA_OFFSET,
					121,
					3
				},
				color = Colors.get_table("font_default"),
				hover_color = Colors.get_table("font_default"),
				text_color = Colors.get_table("font_default")
			},
			name_shadow = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				font_type = "arial",
				dynamic_font_size = true,
				font_size = 20,
				size = {
					210 - INSIGNIA_OFFSET,
					30
				},
				offset = {
					152 + INSIGNIA_OFFSET,
					119,
					2
				},
				text_color = Colors.get_table("black")
			},
			hero = {
				upper_case = true,
				localize = true,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					210 - INSIGNIA_OFFSET,
					30
				},
				offset = {
					150 + INSIGNIA_OFFSET,
					90,
					3
				},
				color = Colors.get_table("font_title"),
				hover_color = Colors.get_table("font_title"),
				text_color = Colors.get_table("font_title")
			},
			hero_shadow = {
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				font_size = 28,
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					210 - INSIGNIA_OFFSET,
					30
				},
				offset = {
					152 + INSIGNIA_OFFSET,
					88,
					2
				},
				text_color = Colors.get_table("black")
			},
			respawn_text = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				localize = false,
				font_size = 80,
				font_type = "hell_shark_header",
				size = {
					100,
					120
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					14,
					0,
					20
				}
			}
		},
		scenegraph_id = arg_48_0,
		offset = arg_48_4 or {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_objective_score_widget = function (arg_107_0, arg_107_1, arg_107_2)
	-- function 107
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "progress_background",
					texture_id = "progress_background"
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "progress_bar",
					texture_id = "progress_bar"
				},
				{
					style_id = "team_1_score",
					pass_type = "text",
					text_id = "team_1_score",
					content_change_function = function (self, arg_108_1)
						-- function 108
						if not self.is_hero then
							arg_108_1.text_color = Colors.get_color_table_with_alpha("white_smoke", 255)
						else
							arg_108_1.text_color = Colors.get_color_table_with_alpha("very_dark_gray", 255)
						end
					end
				},
				{
					style_id = "team_2_score",
					pass_type = "text",
					text_id = "team_2_score",
					content_change_function = function (self, arg_109_1)
						-- function 109
						if not self.is_hero then
							arg_109_1.text_color = Colors.get_color_table_with_alpha("very_dark_gray", 255)
						else
							arg_109_1.text_color = Colors.get_color_table_with_alpha("white_smoke", 255)
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "objective_icon",
					texture_id = "objective_icon",
					content_check_function = function (self)
						-- function 110
						return self.pre_round_timer_done
					end
				},
				{
					style_id = "pre_round_timer",
					pass_type = "text",
					text_id = "pre_round_timer",
					content_check_function = function (self)
						-- function 111
						return not self.pre_round_timer_done
					end
				}
			}
		},
		content = {
			progress_bar = "versus_objective_progress_bar",
			background = "frame_front",
			progress_background = "frame_back",
			pre_round_timer = " ",
			team_2_score = " ",
			team_1_score = " ",
			objective_icon = "icons_placeholder",
			pre_round_timer_done = false
		},
		style = {
			background = {
				texture_size = arg_107_1,
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					3
				}
			},
			progress_background = {
				texture_size = arg_107_1,
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			},
			progress_bar = {
				vertical_alignment = "center",
				gradient_threshold = 0,
				horizontal_alignment = "center",
				texture_size = {
					128,
					128
				},
				offset = {
					0,
					0,
					2
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			objective_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					64,
					64
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					6
				}
			},
			team_1_score = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				vertical_alignment = "center",
				font_size = 46,
				horizontal_alignment = "center",
				use_shadow = true,
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					100,
					50
				},
				text_color = Colors.get_color_table_with_alpha("white_smoke", 255),
				shadow_offset = {
					1,
					1,
					4
				},
				offset = {
					8,
					50,
					4
				}
			},
			team_2_score = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				vertical_alignment = "center",
				font_size = 46,
				horizontal_alignment = "center",
				use_shadow = true,
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					100,
					50
				},
				text_color = Colors.get_color_table_with_alpha("white_smoke", 255),
				shadow_offset = {
					1,
					1,
					4
				},
				offset = {
					195,
					50,
					4
				}
			},
			pre_round_timer = {
				font_size = 50,
				upper_case = false,
				localize = false,
				use_shadow = true,
				word_wrap = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				size = {
					54,
					50
				},
				text_color = Colors.get_color_table_with_alpha("white_smoke", 255),
				shadow_offset = {
					1,
					1,
					4
				},
				offset = {
					arg_107_1[1] * 0.5 - 27,
					arg_107_1[2] * 0.25 + 4 - 2,
					5
				}
			}
		},
		scenegraph_id = arg_107_0,
		offset = arg_107_2 or {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_mission_objective_text_widget_still = function (arg_112_0)
	-- function 112
	local num = 55

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
					pass_type = "texture",
					style_id = "top",
					texture_id = "top"
				},
				{
					pass_type = "texture",
					style_id = "bottom",
					texture_id = "top"
				},
				{
					pass_type = "texture",
					style_id = "bottom_center",
					texture_id = "bottom_center"
				},
				{
					pass_type = "texture",
					style_id = "bottom_edge_glow",
					texture_id = "bottom_edge_glow"
				}
			}
		},
		content = {
			bottom_edge_glow = "mission_objective_glow_01",
			area_text_content = "n/a",
			top = "mission_objective_05",
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
			}
		},
		style = {
			background = {
				size = {
					544,
					num
				},
				offset = {
					0,
					0,
					0
				},
				color = {
					100,
					255,
					255,
					255
				}
			},
			top_center = {
				size = {
					54,
					22
				},
				offset = {
					245,
					num - 11 - 3,
					11
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			top_edge_glow = {
				size = {
					544,
					16
				},
				default_size = {
					544,
					16
				},
				offset = {
					0,
					num - 16 - 3,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			top_detail = {
				size = {
					54,
					22
				},
				offset = {
					245,
					num - 11 - 3,
					12
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			top_detail_glow = {
				horizontal_alignment = "center",
				size = {
					54,
					22
				},
				offset = {
					245,
					num - 11 - 3,
					13
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			top = {
				size = {
					544,
					5
				},
				offset = {
					0,
					num - 5,
					10
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			bottom = {
				size = {
					544,
					5
				},
				offset = {
					0,
					0,
					10
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			bottom_center = {
				size = {
					54,
					22
				},
				offset = {
					245,
					-6,
					11
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			bottom_edge_glow = {
				size = {
					544,
					16
				},
				default_size = {
					544,
					16
				},
				offset = {
					0,
					3,
					1
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
				font_size = 20,
				default_font_size = 30,
				horizontal_alignment = "center",
				word_wrap = true,
				vertical_alignment = "center",
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
				font_size = 20,
				default_font_size = 30,
				horizontal_alignment = "center",
				word_wrap = true,
				vertical_alignment = "center",
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
				font_size = 20,
				default_font_size = 30,
				horizontal_alignment = "center",
				word_wrap = true,
				vertical_alignment = "center",
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
				font_size = 20,
				default_font_size = 30,
				horizontal_alignment = "center",
				word_wrap = true,
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-3,
					10
				}
			}
		},
		scenegraph_id = arg_112_0
	}
end

UIWidgets.create_total_score_progress_bar = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4)
	-- function 113
	local num = 1.5
	local tbl = {
		130,
		60
	}
	local tbl_2 = {
		50,
		30
	}
	local str = "bar_frame_01_back"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local bar_frame_01 = UIFrameSettings.bar_frame_01
	local bar_frame_01_2 = UIFrameSettings.bar_frame_01
	local button_frame_02_gold = UIFrameSettings.button_frame_02_gold
	local button_frame_01 = UIFrameSettings.button_frame_01
	local tbl_3 = {}
	local tbl_4 = {}

	local function fn(self, arg_114_1)
		-- function 114
		if not self.parent then
			return self.parent.is_winning
		else
			return self.is_winning
		end
	end

	local function fn_2(self, arg_115_1)
		-- function 115
		if not self.parent then
			return not self.parent.is_winning
		else
			return not self.is_winning
		end
	end

	local num_2 = arg_113_2 / 25
	local num_3 = arg_113_1[1] / num_2
	local str_2 = "bar_frame_01_divider"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2).size
	local num_4 = size[1] * num_2
	local num_5 = num_3 * (num_2 - 1)
	local tbl_5 = {}
	local tbl_6 = {}
	local tbl_7 = {}

	for i = 1, num_2 - 1 do
		tbl_5[i] = str_2
		tbl_6[i] = size
		tbl_7[i] = {
			255,
			255,
			255,
			255
		}
	end

	tbl_4.passes = {
		{
			pass_type = "tiled_texture",
			style_id = "bar_background",
			texture_id = "bar_background"
		},
		{
			pass_type = "texture_frame",
			style_id = "bar_frame",
			texture_id = "bar_frame"
		},
		{
			style_id = "bar_fill",
			texture_id = "bar_fill",
			pass_type = "gradient_mask_texture",
			content_change_function = function (self, arg_116_1)
				-- function 116
				arg_116_1.gradient_threshold = self.current_bar_fil_threshold
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "max_score_detail_frame",
			texture_id = "max_score_detail_frame"
		},
		{
			style_id = "max_score",
			pass_type = "text",
			text_id = "max_score"
		},
		{
			pass_type = "tiled_texture",
			style_id = "current_score_background",
			texture_id = "current_score_background"
		},
		{
			pass_type = "texture_frame",
			style_id = "gold_frame",
			texture_id = "gold_frame",
			content_check_function = fn
		},
		{
			pass_type = "texture",
			style_id = "left_detail_w",
			texture_id = "left_detail_w",
			content_check_function = fn
		},
		{
			style_id = "right_detail_w",
			pass_type = "texture_uv",
			content_id = "right_detail_w",
			content_check_function = fn
		},
		{
			pass_type = "texture_frame",
			style_id = "bronze_frame",
			texture_id = "bronze_frame",
			content_check_function = fn_2
		},
		{
			pass_type = "texture",
			style_id = "left_detail_l",
			texture_id = "left_detail_l",
			content_check_function = fn_2
		},
		{
			style_id = "right_detail_l",
			pass_type = "texture_uv",
			content_id = "right_detail_l",
			content_check_function = fn_2
		},
		{
			style_id = "current_score",
			pass_type = "text",
			text_id = "current_score_text"
		},
		{
			pass_type = "multi_texture",
			style_id = "score_separators",
			texture_id = "score_separators"
		}
	}

	local tbl_8 = {
		current_score_background = "bar_frame_01_back",
		bar_fill_threashold = 0,
		current_score_text = "0",
		left_detail_w = "button_detail_01_gold",
		is_winning = true,
		current_bar_fil_threshold = 0,
		left_detail_l = "button_detail_01",
		bar_size = arg_113_1,
		current_score_size = tbl,
		local_player_team = arg_113_4,
		bar_background = str,
		bar_frame = bar_frame_01.texture
	}
	local flag

	flag = not arg_113_4 and "local_player_score_bar" and "opponent_score_bar"
	tbl_8.bar_fill = flag
	tbl_8.max_score_detail_frame = bar_frame_01_2.texture
	tbl_8.max_score = arg_113_2
	tbl_8.gold_frame = button_frame_02_gold.texture
	tbl_8.right_detail_w = {
		texture_id = "button_detail_01_gold",
		uvs = {
			{
				1,
				1
			},
			{
				0,
				0
			}
		}
	}
	tbl_8.bronze_frame = button_frame_01.texture
	tbl_8.right_detail_l = {
		texture_id = "button_detail_01",
		uvs = {
			{
				1,
				1
			},
			{
				0,
				0
			}
		}
	}
	tbl_8.current_score = arg_113_3
	tbl_8.score_separators = tbl_5

	local tbl_9 = {
		bar_background = {
			texture_size = arg_113_1,
			texture_tiling_size = get_atlas_settings_by_texture_name.size,
			color = {
				255,
				255,
				255,
				255
			},
			default_offset = {
				0,
				0,
				1
			},
			offset = {
				0,
				0,
				1
			}
		},
		bar_frame = {
			size = {
				arg_113_1[1] + 4,
				arg_113_1[2] + 4
			},
			texture_size = bar_frame_01.texture_size,
			texture_sizes = bar_frame_01.texture_sizes,
			default_offset = {
				0,
				-2,
				10
			},
			offset = {
				0,
				-2,
				10
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		bar_fill = {
			gradient_threshold = 0.3,
			size = {
				arg_113_1[1] - tbl_2[1] + 4,
				arg_113_1[2]
			},
			default_offset = {
				0,
				0,
				9
			},
			offset = {
				0,
				0,
				9
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		max_score_detail_frame = {
			size = {
				tbl_2[1] + 4,
				tbl_2[2] + 4
			},
			texture_size = bar_frame_01_2.texture_size,
			texture_sizes = bar_frame_01_2.texture_sizes,
			default_offset = {
				arg_113_1[1] - 50,
				-2,
				10
			},
			offset = {
				arg_113_1[1] - 50,
				-2,
				10
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		max_score = {
			font_size = 20,
			upper_case = false,
			localize = false,
			use_shadow = true,
			word_wrap = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark",
			size = {
				tbl_2[1] - 10,
				arg_113_1[2]
			},
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_offset = {
				arg_113_1[1] - 40,
				0,
				5
			},
			offset = {
				arg_113_1[1] - 40,
				0,
				5
			}
		},
		current_score_background = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			texture_size = tbl,
			texture_tiling_size = {
				128,
				128
			},
			color = {
				255,
				255,
				255,
				255
			},
			default_offset = {
				20,
				0,
				11
			},
			offset = {
				20,
				0,
				11
			}
		},
		gold_frame = {
			size = tbl,
			texture_size = button_frame_02_gold.texture_size,
			texture_sizes = button_frame_02_gold.texture_sizes,
			default_offset = {
				20,
				-15,
				12
			},
			offset = {
				20,
				-15,
				12
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		left_detail_w = {
			size = {
				40,
				tbl[2]
			},
			default_offset = {
				10,
				-15,
				13
			},
			offset = {
				10,
				-15,
				13
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		right_detail_w = {
			size = {
				40,
				tbl[2]
			},
			default_offset = {
				tbl[1] - 10,
				-15,
				13
			},
			offset = {
				tbl[1] - 10,
				-15,
				13
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		bronze_frame = {
			size = tbl,
			texture_size = button_frame_01.texture_size,
			texture_sizes = button_frame_01.texture_sizes,
			default_offset = {
				20,
				-15,
				12
			},
			offset = {
				20,
				-15,
				12
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		left_detail_l = {
			size = {
				40,
				tbl[2]
			},
			default_offset = {
				10,
				-15,
				13
			},
			offset = {
				10,
				-15,
				13
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		right_detail_l = {
			size = {
				40,
				tbl[2]
			},
			default_offset = {
				tbl[1] - 10,
				-15,
				13
			},
			offset = {
				tbl[1] - 10,
				-15,
				13
			},
			color = {
				255,
				255,
				255,
				255
			}
		}
	}
	local tbl_10 = {
		font_size = 50,
		upper_case = false,
		localize = false,
		use_shadow = true,
		word_wrap = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		font_type = "hell_shark_header",
		size = tbl
	}
	local get_color_table_with_alpha

	if not arg_113_4 then
		get_color_table_with_alpha = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)

		if not get_color_table_with_alpha then
			-- Nothing
		end
	end

	get_color_table_with_alpha = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)

	::label_113_0::

	tbl_10.text_color = get_color_table_with_alpha
	tbl_10.default_offset = {
		20,
		-20,
		13
	}
	tbl_10.offset = {
		20,
		-20,
		13
	}
	tbl_9.current_score = tbl_10
	tbl_9.score_separators = {
		direction = 1,
		axis = 1,
		size = arg_113_1,
		spacing = {
			num_3 - 1,
			0
		},
		texture_sizes = tbl_6,
		texture_colors = tbl_7,
		color = {
			255,
			255,
			255,
			255
		},
		default_color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			5,
			3
		},
		draw_count = num_2 - 1
	}
	tbl_3.element = tbl_4
	tbl_3.content = tbl_8
	tbl_3.style = tbl_9
	tbl_3.scenegraph_id = arg_113_0
	tbl_3.offset = {
		0,
		0,
		0
	}

	return tbl_3
end

UIWidgets.create_team_banner_info = function (arg_117_0, arg_117_1)
	-- function 117
	local flag

	flag = not arg_117_1 and "left" and "right"

	local tbl

	if not arg_117_1 then
		tbl = {
			{
				0,
				0
			},
			{
				1,
				1
			}
		}

		if not tbl then
			-- Nothing
		end
	end

	tbl = {
		{
			1,
			1
		},
		{
			0,
			0
		}
	}

	do
		local flag_2
	end

	::label_117_0::

	flag_2 = not arg_117_1 and 45 and -45

	local tbl_2 = {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					style_id = "team_side",
					pass_type = "text",
					text_id = "team_side"
				},
				{
					style_id = "team_name",
					pass_type = "text",
					text_id = "team_name"
				}
			}
		}
	}
	local tbl_3 = {
		team_name = "**Hammers",
		background = {
			texture_id = "headline_bg_40",
			uvs = tbl
		}
	}
	local flag_3

	flag_3 = not arg_117_1 and "**Your Team" and "**Enemy"
	tbl_3.team_side = flag_3
	tbl_2.content = tbl_3

	local tbl_4 = {
		background = {
			color = {
				100,
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
	local tbl_5 = {
		word_wrap = true,
		upper_case = false,
		localize = false,
		use_shadow = true,
		font_size = 22,
		vertical_alignment = "top",
		font_type = "hell_shark",
		horizontal_alignment = flag
	}
	local get_color_table_with_alpha

	if not arg_117_1 then
		get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_button_normal", 255)

		if not get_color_table_with_alpha then
			-- Nothing
		end
	end

	get_color_table_with_alpha = Colors.get_color_table_with_alpha("opponent_team", 255)

	::label_117_1::

	tbl_5.text_color = get_color_table_with_alpha
	tbl_5.offset = {
		flag_2,
		-5,
		4
	}
	tbl_4.team_side = tbl_5

	local tbl_6 = {
		word_wrap = true,
		upper_case = true,
		localize = false,
		use_shadow = true,
		font_size = 60,
		vertical_alignment = "bottom",
		font_type = "hell_shark_header",
		horizontal_alignment = flag
	}
	local get_color_table_with_alpha_2

	if not arg_117_1 then
		get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)

		if not get_color_table_with_alpha_2 then
			-- Nothing
		end
	end

	get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)

	::label_117_2::

	tbl_6.text_color = get_color_table_with_alpha_2
	tbl_6.offset = {
		flag_2,
		-5,
		5
	}
	tbl_4.team_name = tbl_6
	tbl_2.style = tbl_4
	tbl_2.scenegraph_id = arg_117_0
	tbl_2.offset = {
		0,
		0,
		0
	}

	return tbl_2
end

UIWidgets.create_round_score_progress_bar = function (arg_118_0, arg_118_1, arg_118_2, arg_118_3, arg_118_4, arg_118_5)
	-- function 118
	local str = "bar_frame_01_back"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local bar_frame_01 = UIFrameSettings.bar_frame_01
	local bar_frame_01_2 = UIFrameSettings.bar_frame_01
	local bar_frame_01_3 = UIFrameSettings.bar_frame_01
	local tbl = {
		50,
		30
	}
	local tbl_2 = {
		element = {
			passes = {
				{
					pass_type = "tiled_texture",
					style_id = "bar_background",
					texture_id = "bar_background"
				},
				{
					pass_type = "texture_frame",
					style_id = "bar_frame",
					texture_id = "bar_frame"
				},
				{
					pass_type = "texture_frame",
					style_id = "current_score_frame",
					texture_id = "current_score_frame"
				},
				{
					pass_type = "tiled_texture",
					style_id = "current_score_bg",
					texture_id = "current_score_bg"
				},
				{
					pass_type = "texture_frame",
					style_id = "max_score_frame",
					texture_id = "max_score_frame"
				},
				{
					pass_type = "tiled_texture",
					style_id = "max_score_bg",
					texture_id = "max_score_bg"
				},
				{
					style_id = "bar_fill",
					pass_type = "gradient_mask_texture",
					texture_id = "bar_fill",
					clone = true,
					content_change_function = function (self, arg_119_1)
						-- function 119
						arg_119_1.gradient_threshold = self.current_bar_fil_threshold
					end
				},
				{
					style_id = "current_score",
					pass_type = "text",
					text_id = "current_score"
				},
				{
					style_id = "max_score",
					pass_type = "text",
					text_id = "max_score"
				}
			}
		}
	}
	local tbl_3 = {
		bar_fill_threashold = 0,
		current_bar_fil_threshold = 0,
		bar_size = arg_118_1,
		score_size = tbl,
		local_player_team = arg_118_3,
		bar_background = str,
		bar_frame = bar_frame_01.texture
	}
	local flag

	flag = not arg_118_3 and "local_player_score_bar" and "opponent_score_bar"
	tbl_3.bar_fill = flag
	tbl_3.max_score_detail_frame = bar_frame_01_2.texture
	tbl_3.current_score = arg_118_5
	tbl_3.max_score = arg_118_4
	tbl_3.current_score_frame = bar_frame_01_2.texture
	tbl_3.current_score_bg = str
	tbl_3.max_score_frame = bar_frame_01_2.texture
	tbl_3.max_score_bg = str
	tbl_2.content = tbl_3

	local tbl_4 = {
		bar_background = {
			texture_size = arg_118_1,
			texture_tiling_size = get_atlas_settings_by_texture_name.size,
			color = {
				255,
				255,
				255,
				255
			},
			default_offset = {
				0,
				0,
				1
			},
			offset = {
				0,
				0,
				1
			}
		},
		bar_frame = {
			size = {
				arg_118_1[1] + 4,
				arg_118_1[2] + 4
			},
			texture_size = bar_frame_01_2.texture_size,
			texture_sizes = bar_frame_01_2.texture_sizes,
			default_offset = {
				0,
				-2,
				10
			},
			offset = {
				0,
				-2,
				10
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		bar_fill = {
			gradient_threshold = 0.3,
			size = {
				arg_118_1[1] - 50,
				arg_118_1[2]
			},
			default_offset = {
				0,
				0,
				9
			},
			offset = {
				0,
				0,
				9
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		current_score_frame = {
			size = {
				tbl[1] + 4,
				tbl[2] + 4
			},
			texture_size = bar_frame_01_2.texture_size,
			texture_sizes = bar_frame_01_2.texture_sizes,
			default_offset = {
				0,
				-10,
				13
			},
			offset = {
				0,
				-10,
				13
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		current_score_bg = {
			texture_size = tbl,
			texture_tiling_size = get_atlas_settings_by_texture_name.size,
			color = {
				255,
				255,
				255,
				255
			},
			default_offset = {
				0,
				-10,
				11
			},
			offset = {
				0,
				-10,
				11
			}
		},
		max_score_frame = {
			size = {
				tbl[1] + 4,
				tbl[2] + 4
			},
			texture_size = bar_frame_01_2.texture_size,
			texture_sizes = bar_frame_01_2.texture_sizes,
			default_offset = {
				arg_118_1[1] - 50,
				-10,
				13
			},
			offset = {
				arg_118_1[1] - 50,
				-10,
				13
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		max_score_bg = {
			texture_size = tbl,
			texture_tiling_size = get_atlas_settings_by_texture_name.size,
			color = {
				255,
				255,
				255,
				255
			},
			default_offset = {
				arg_118_1[1] - 50,
				-10,
				10
			},
			offset = {
				arg_118_1[1] - 50,
				-10,
				10
			}
		},
		max_score = {
			font_size = 20,
			upper_case = false,
			localize = false,
			use_shadow = true,
			word_wrap = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark",
			size = {
				tbl[1],
				tbl[2]
			},
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_offset = {
				arg_118_1[1] - 40,
				-10,
				12
			},
			offset = {
				arg_118_1[1] - 40,
				-10,
				12
			}
		}
	}
	local tbl_5 = {
		font_size = 20,
		upper_case = false,
		localize = false,
		use_shadow = true,
		word_wrap = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		font_type = "hell_shark",
		size = {
			tbl[1],
			tbl[2]
		}
	}
	local get_color_table_with_alpha

	if not arg_118_3 then
		get_color_table_with_alpha = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)

		if not get_color_table_with_alpha then
			-- Nothing
		end
	end

	get_color_table_with_alpha = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)

	::label_118_0::

	tbl_5.text_color = get_color_table_with_alpha
	tbl_5.default_offset = {
		0,
		-10,
		12
	}
	tbl_5.offset = {
		0,
		-10,
		12
	}
	tbl_4.current_score = tbl_5
	tbl_2.style = tbl_4
	tbl_2.scenegraph_id = arg_118_0
	tbl_2.offset = {
		0,
		0,
		0
	}

	return tbl_2
end

UIWidgets.create_round_end_round_score_bg_widget = function (arg_120_0, arg_120_1, arg_120_2)
	-- function 120
	local flag = arg_120_1 or {
		920,
		100
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background_left",
					texture_id = "background_left"
				},
				{
					style_id = "background_right",
					pass_type = "texture_uv",
					content_id = "background_right"
				},
				{
					pass_type = "texture",
					style_id = "left_detail",
					texture_id = "left_detail"
				},
				{
					style_id = "right_detail",
					pass_type = "texture_uv",
					content_id = "right_detail"
				}
			}
		},
		content = {
			left_detail = "button_detail_12",
			background_left = "headline_bg_40",
			background_right = {
				texture_id = "headline_bg_40",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			},
			right_detail = {
				texture_id = "button_detail_12",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			}
		},
		style = {
			background_left = {
				size = {
					flag[1] * 0.5,
					flag[2]
				},
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				}
			},
			background_right = {
				size = {
					flag[1] * 0.5,
					flag[2]
				},
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					flag[1] * 0.5,
					0,
					1
				}
			},
			left_detail = {
				size = {
					40,
					100
				},
				offset = {
					-10,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			right_detail = {
				size = {
					40,
					100
				},
				offset = {
					flag[1] - 30,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		offset = arg_120_2 or {
			0,
			0,
			1
		},
		scenegraph_id = arg_120_0
	}
end

UIWidgets.create_parading_screen_divider = function (arg_121_0, arg_121_1, arg_121_2)
	-- function 121
	local str = "divider_horizontal_hero_middle_blue"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "divider_edge_left",
					texture_id = "divider_edge_left"
				},
				{
					pass_type = "tiled_texture",
					style_id = "divider_mid",
					texture_id = "divider_mid"
				},
				{
					style_id = "divider_edge_right",
					pass_type = "texture_uv",
					content_id = "divider_edge_right"
				}
			}
		},
		content = {
			divider_edge_left = "divider_horizontal_hero_end_blue",
			divider_mid = str,
			divider_edge_right = {
				texture_id = "divider_horizontal_hero_end_blue",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			}
		},
		style = {
			divider_edge_left = {
				vertical_alignment = "center",
				size = {
					22,
					28
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-22,
					-7,
					1
				}
			},
			divider_mid = {
				vertical_alignment = "center",
				texture_size = arg_121_1,
				texture_tiling_size = get_atlas_settings_by_texture_name.size,
				color = Colors.get_color_table_with_alpha("white", 255),
				default_offset = {
					0,
					0,
					1
				},
				offset = {
					0,
					0,
					1
				}
			},
			divider_edge_right = {
				vertical_alignment = "center",
				size = {
					22,
					28
				},
				offset = {
					arg_121_1[1],
					-7,
					2
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			}
		},
		scenegraph_id = arg_121_0,
		offset = arg_121_2 or {
			0,
			0,
			1
		}
	}
end

UIWidgets.create_dark_pact_onboarding_tutorial_widget = function (arg_122_0, arg_122_1, arg_122_2)
	-- function 122
	local flag = arg_122_1 or {
		400,
		300
	}

	return {
		element = {
			passes = {
				{
					pass_type = "rotated_texture",
					style_id = "top_detail",
					texture_id = "detail"
				},
				{
					pass_type = "rotated_texture",
					style_id = "bottom_detail",
					texture_id = "detail"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					style_id = "hero_text",
					pass_type = "text",
					text_id = "hero_text"
				},
				{
					style_id = "description",
					pass_type = "text",
					text_id = "description"
				},
				{
					style_id = "abilities_tooltip",
					pass_type = "text",
					text_id = "abilities_tooltip"
				}
			}
		},
		content = {
			description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
			abilities_tooltip = "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
			hero_text = "RATLING GUNNER",
			detail = "radial_chat_bg_line",
			background = {
				texture_id = "headline_bg_60",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			}
		},
		style = {
			top_detail = {
				angle = math.degrees_to_radians(-90),
				offset = {
					200,
					60,
					4
				},
				pivot = {
					2,
					200
				},
				texture_size = {
					4,
					400
				},
				color = Colors.get_color_table_with_alpha("black", 255)
			},
			bottom_detail = {
				angle = math.degrees_to_radians(-90),
				offset = {
					200,
					-flag[2] + 60,
					4
				},
				pivot = {
					2,
					200
				},
				texture_size = {
					4,
					400
				},
				color = Colors.get_color_table_with_alpha("black", 255)
			},
			background = {
				vertical_alignment = "center",
				size = {
					flag[1] + 20,
					flag[2]
				},
				offset = {
					-20,
					0,
					1
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			hero_text = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				use_shadow = false,
				font_size = 40,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-10,
					4
				}
			},
			description = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 18,
				vertical_alignment = "top",
				horizontal_alignment = "left",
				use_shadow = false,
				font_type = "hell_shark",
				size = {
					380,
					120
				},
				text_color = Colors.get_color_table_with_alpha("light_gray", 255),
				offset = {
					0,
					92,
					4
				}
			},
			abilities_tooltip = {
				font_size = 20,
				word_wrap = true,
				dynamic_font_size_word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				size = {
					380,
					120
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					8,
					4
				}
			}
		},
		scenegraph_id = arg_122_0,
		offset = arg_122_2 or {
			0,
			0,
			1
		}
	}
end

UIWidgets.create_hero_onboarding_tutorial_widget = function (arg_123_0, arg_123_1, arg_123_2)
	-- function 123
	local flag = arg_123_1 or {
		400,
		300
	}
	local num = 1.25

	return {
		element = {
			passes = {
				{
					pass_type = "rotated_texture",
					style_id = "top_detail",
					texture_id = "detail"
				},
				{
					pass_type = "rotated_texture",
					style_id = "bottom_detail",
					texture_id = "detail"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					style_id = "hero_text",
					pass_type = "text",
					text_id = "hero_text"
				},
				{
					pass_type = "texture",
					style_id = "career_icon",
					texture_id = "career_icon"
				},
				{
					pass_type = "texture",
					style_id = "ability_1_icon",
					texture_id = "ability_1_icon"
				},
				{
					pass_type = "texture",
					style_id = "ability_1_icon_frame",
					texture_id = "icon_frame"
				},
				{
					style_id = "ability_1_name",
					pass_type = "text",
					text_id = "ability_1_name"
				},
				{
					style_id = "ability_1_description",
					pass_type = "text",
					text_id = "ability_1_description"
				},
				{
					pass_type = "texture",
					style_id = "ability_2_icon",
					texture_id = "ability_2_icon"
				},
				{
					pass_type = "texture",
					style_id = "ability_2_icon_frame",
					texture_id = "icon_frame"
				},
				{
					style_id = "ability_2_name",
					pass_type = "text",
					text_id = "ability_2_name"
				},
				{
					style_id = "ability_2_description",
					pass_type = "text",
					text_id = "ability_2_description"
				}
			}
		},
		content = {
			career_icon = "simple_rect_texture",
			icon_frame = "icon_talent_frame",
			ability_2_icon = "icons_placeholder",
			ability_1_description = "n/a",
			ability_2_name = "n/a",
			ability_2_description = "n/a",
			ability_1_name = "n/a",
			ability_1_icon = "icons_placeholder",
			hero_text = "HERO_TEXT",
			detail = "radial_chat_bg_line",
			background = {
				texture_id = "headline_bg_60",
				uvs = {
					{
						1,
						1
					},
					{
						0,
						0
					}
				}
			}
		},
		style = {
			top_detail = {
				angle = math.degrees_to_radians(-90),
				offset = {
					200,
					160,
					4
				},
				pivot = {
					2,
					200
				},
				texture_size = {
					4,
					400
				},
				color = Colors.get_color_table_with_alpha("black", 255)
			},
			bottom_detail = {
				angle = math.degrees_to_radians(-90),
				offset = {
					200,
					-flag[2] + 160,
					4
				},
				pivot = {
					2,
					200
				},
				texture_size = {
					4,
					400
				},
				color = Colors.get_color_table_with_alpha("black", 255)
			},
			background = {
				vertical_alignment = "center",
				size = {
					flag[1] + 20,
					flag[2]
				},
				offset = {
					-20,
					0,
					1
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			hero_text = {
				word_wrap = false,
				upper_case = true,
				localize = false,
				vertical_alignment = "center",
				font_size = 40,
				horizontal_alignment = "right",
				use_shadow = false,
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					flag[1],
					50
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-25,
					flag[2] - 65,
					4
				}
			},
			career_icon = {
				size = {
					64,
					64
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					flag[2] - 70,
					5
				}
			},
			ability_1_icon = {
				size = {
					64 * num,
					64 * num
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					flag[1] - (64 * num + 20),
					flag[2] - (64 * num + 80),
					5
				}
			},
			ability_1_icon_frame = {
				size = {
					64 * num,
					64 * num
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					flag[1] - (64 * num + 20),
					flag[2] - (64 * num + 80),
					6
				}
			},
			ability_1_name = {
				font_size = 24,
				upper_case = true,
				localize = false,
				word_wrap = false,
				use_shadow = true,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				font_type = "hell_shark",
				size = {
					flag[1] - (64 * num + 25),
					25
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					-10,
					flag[2] - 110,
					2
				}
			},
			ability_1_description = {
				font_size = 20,
				localize = false,
				dynamic_font_size_word_wrap = true,
				word_wrap = true,
				use_shadow = true,
				horizontal_alignment = "right",
				vertical_alignment = "top",
				font_type = "hell_shark",
				size = {
					flag[1] - (64 * num + 25),
					80
				},
				text_color = Colors.get_color_table_with_alpha("light_gray", 255),
				offset = {
					-10,
					flag[2] - (64 * num + 60 + 50),
					2
				}
			},
			ability_2_icon = {
				size = {
					64 * num,
					64 * num
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					flag[1] - (64 * num + 20),
					flag[2] - (64 * num + 220),
					5
				}
			},
			ability_2_icon_frame = {
				size = {
					64 * num,
					64 * num
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					flag[1] - (64 * num + 20),
					flag[2] - (64 * num + 220),
					6
				}
			},
			ability_2_name = {
				font_size = 24,
				upper_case = true,
				localize = false,
				word_wrap = false,
				use_shadow = true,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				font_type = "hell_shark",
				size = {
					flag[1] - (64 * num + 25),
					25
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					-10,
					flag[2] - 245,
					2
				}
			},
			ability_2_description = {
				font_size = 20,
				localize = false,
				dynamic_font_size_word_wrap = true,
				word_wrap = true,
				use_shadow = true,
				horizontal_alignment = "right",
				vertical_alignment = "top",
				font_type = "hell_shark",
				size = {
					flag[1] - (64 * num + 25),
					80
				},
				text_color = Colors.get_color_table_with_alpha("light_gray", 255),
				offset = {
					-10,
					30,
					2
				}
			}
		},
		scenegraph_id = arg_123_0,
		offset = arg_123_2 or {
			0,
			0,
			1
		}
	}
end

UIWidgets.create_dark_pact_overcharge_bar_widget = function (arg_124_0, arg_124_1, arg_124_2, arg_124_3, arg_124_4, arg_124_5, arg_124_6)
	-- function 124
	local flag = arg_124_5 or {
		250,
		56
	}

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "icon_shadow",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "bar_fg",
					texture_id = "bar_fg"
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "bar_1",
					texture_id = "bar_1"
				}
			}
		},
		content = {
			icon = arg_124_4 or "tabs_icon_all_selected",
			bar_1 = arg_124_1 or "dark_pact_overcharge_bar",
			bar_fg = arg_124_2 or "circular_bar_background",
			size = {
				flag[1] - 6,
				flag[2]
			}
		},
		style = {
			bar_1 = {
				gradient_threshold = 0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					3,
					-1,
					4
				},
				size = {
					flag[1],
					flag[2]
				}
			},
			icon = {
				size = {
					0,
					0
				},
				offset = {
					flag[1],
					flag[2] / 2,
					5
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			icon_shadow = {
				size = {
					0,
					0
				},
				offset = {
					flag[1] + 2,
					flag[2] / 2 - 2,
					5
				},
				color = {
					0,
					0,
					0,
					0
				}
			},
			bar_fg = {
				offset = {
					0,
					0,
					5
				},
				color = {
					255,
					255,
					255,
					255
				},
				size = flag
			}
		},
		offset = arg_124_6 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_124_0
	}
end

UIWidgets.create_versus_gameplay_hint_widget = function (arg_125_0, arg_125_1, arg_125_2, arg_125_3)
	-- function 125
	local close_input = arg_125_1.close_input
	local flag = arg_125_3 or {
		400,
		360
	}
	local input_data = arg_125_1.input_data
	local var_125_3

	if not arg_125_1.foot_text then
		if not input_data then
			local str = "$KEY;" .. input_data.input_service_name .. "__" .. input_data.input_action .. ":"

			var_125_3 = string.format(Localize(arg_125_1.foot_text), str)
		else
			var_125_3 = Localize(arg_125_1.foot_text)
		end
	end

	local var_125_5 = Localize(arg_125_1.title_text)
	local var_125_6 = Localize(arg_125_1.body_text)
	local tbl = {
		passes = {
			{
				pass_type = "texture",
				style_id = "detail_bottom",
				texture_id = "detail"
			},
			{
				style_id = "detail_top",
				texture_id = "detail",
				pass_type = "texture",
				content_change_function = function (self, arg_126_1)
					-- function 126
					arg_126_1.offset[2] = self.size[2] - 4
				end
			},
			{
				style_id = "background",
				texture_id = "background",
				pass_type = "texture",
				content_change_function = function (self, arg_127_1)
					-- function 127
					arg_127_1.size[2] = self.size[2]
				end
			},
			{
				style_id = "title_text",
				pass_type = "text",
				text_id = "title_text",
				content_change_function = function (self, arg_128_1)
					-- function 128
					arg_128_1.offset[2] = self.size[2] - 40 - 12
				end
			},
			{
				style_id = "body_text",
				pass_type = "text",
				text_id = "body_text",
				content_change_function = function (self, arg_129_1)
					-- function 129
					arg_129_1.size = {
						self.size[1] - 20,
						self.size[2]
					}
					arg_129_1.area_size = {
						self.size[1] - 24,
						self.size[2]
					}
				end
			}
		}
	}
	local tbl_2 = {
		background = "simple_rect_texture",
		detail = "radial_chat_bg_line_horz",
		title_text = var_125_5,
		body_text = var_125_6,
		size = flag
	}
	local tbl_3 = {
		detail_top = {
			offset = {
				0,
				flag[2] - 4,
				4
			},
			texture_size = {
				400,
				4
			},
			color = Colors.get_color_table_with_alpha("black", 255)
		},
		detail_bottom = {
			offset = {
				0,
				0,
				4
			},
			texture_size = {
				400,
				4
			},
			color = Colors.get_color_table_with_alpha("black", 255)
		},
		background = {
			size = flag,
			offset = {
				0,
				0,
				1
			},
			color = Colors.get_color_table_with_alpha("black", 165)
		},
		title_text = {
			word_wrap = false,
			upper_case = true,
			localize = false,
			use_shadow = false,
			font_size = 40,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			size = {
				flag[1] - 20,
				40
			},
			offset = {
				20,
				flag[2] - 40 - 12,
				4
			}
		},
		body_text = {
			word_wrap = true,
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = true,
			font_size = 18,
			font_type = "hell_shark",
			horizontal_alignment = "left",
			vertical_alignment = "top",
			use_shadow = false,
			size = {
				flag[1] - 20,
				flag[2]
			},
			area_size = {
				flag[1] - 20,
				flag[2]
			},
			text_color = Colors.get_color_table_with_alpha("light_gray", 255),
			offset = {
				20,
				-52,
				4
			}
		}
	}

	if not arg_125_1.duration then
		local str_2 = "duration_bar"
		local tbl_4 = {
			pass_type = "texture_uv",
			content_id = str_2,
			style_id = str_2
		}
		local tbl_5 = {
			texture_id = "crafting_bar",
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
		local tbl_6 = {
			vertical_alignment = "left",
			offset = {
				0,
				6,
				8
			},
			texture_size = {
				400,
				8
			},
			color = Colors.get_color_table_with_alpha("local_player_picking", 255)
		}

		tbl.passes[#tbl.passes + 1] = tbl_4
		tbl_2[str_2] = tbl_5
		tbl_3[str_2] = tbl_6
	end

	if not arg_125_1.foot_text then
		local str_3 = "foot_text"
		local tbl_7 = {
			pass_type = "text",
			text_id = str_3,
			style_id = str_3
		}
		local var_125_16 = var_125_3
		local tbl_8 = {
			word_wrap = true,
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = true,
			font_size = 20,
			font_type = "hell_shark",
			horizontal_alignment = "left",
			vertical_alignment = "center",
			use_shadow = false,
			size = {
				flag[1] - 88,
				48
			},
			area_size = {
				flag[1] - 88,
				48
			},
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				88,
				30,
				4
			}
		}

		tbl.passes[#tbl.passes + 1] = tbl_7
		tbl_2[str_3] = var_125_16
		tbl_3[str_3] = tbl_8
	end

	if not arg_125_1.icon then
		local str_4 = "foot_icon"
		local tbl_9 = {
			pass_type = "texture",
			texture_id = str_4,
			style_id = str_4
		}
		local icon = arg_125_1.icon
		local tbl_10 = {
			vertical_alignment = "left",
			offset = {
				20,
				20,
				8
			},
			texture_size = {
				60,
				60
			},
			color = Colors.get_color_table_with_alpha("white", 255)
		}

		tbl.passes[#tbl.passes + 1] = tbl_9
		tbl_2[str_4] = icon
		tbl_3[str_4] = tbl_10
	end

	return {
		element = tbl,
		content = tbl_2,
		style = tbl_3,
		scenegraph_id = arg_125_0,
		offset = arg_125_2 or {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_large_insignia = function (arg_130_0, arg_130_1, arg_130_2, arg_130_3, arg_130_4, arg_130_5, arg_130_6)
	-- function 130
	local tbl = {}
	local tbl_2 = {
		passes = {}
	}
	local passes = tbl_2.passes
	local tbl_3 = {}
	local tbl_4 = {}
	local flag = arg_130_1 or ExperienceSettings.get_versus_level()
	local get_insignia_texture_settings_from_level, var_130_7 = UIAtlasHelper.get_insignia_texture_settings_from_level(flag)
	local flag_2 = arg_130_4 or {
		100,
		276
	}

	passes[#passes + 1] = {
		style_id = "insignia_main",
		pass_type = "texture_uv",
		content_id = "insignia_main",
		retained_mode = arg_130_6
	}
	passes[#passes + 1] = {
		style_id = "insignia_addon",
		pass_type = "texture_uv",
		content_id = "insignia_addon",
		content_check_function = function (self, arg_131_1)
			-- function 131
			return self.uvs
		end,
		retained_mode = arg_130_6
	}
	tbl_4.insignia_main = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = flag_2,
		color = arg_130_3,
		offset = {
			0,
			0,
			1
		},
		retained_mode = arg_130_6
	}
	tbl_4.insignia_addon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = flag_2,
		color = arg_130_3,
		retained_mode = arg_130_6
	}

	local tbl_5 = {
		uvs = get_insignia_texture_settings_from_level
	}
	local flag_3

	flag_3 = not arg_130_2 and "insignias_main_masked" and "insignias_main"
	tbl_5.texture_id = flag_3
	tbl_3.insignia_main = tbl_5

	local tbl_6 = {
		uvs = var_130_7
	}
	local flag_4

	flag_4 = not arg_130_2 and "insignias_addon_masked" and "insignias_addon"
	tbl_6.texture_id = flag_4
	tbl_3.insignia_addon = tbl_6
	tbl_3.level = flag
	tbl.element = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.scenegraph_id = arg_130_0
	tbl.offset = arg_130_5 or {
		0,
		0,
		0
	}

	return tbl
end

UIWidgets.create_small_insignia = function (arg_132_0, arg_132_1, arg_132_2, arg_132_3, arg_132_4, arg_132_5)
	-- function 132
	local tbl = {}
	local tbl_2 = {
		passes = {}
	}
	local passes = tbl_2.passes
	local tbl_3 = {}
	local tbl_4 = {}
	local flag = arg_132_1 or ExperienceSettings.get_versus_level()
	local get_insignia_texture_settings_from_level, var_132_7 = UIAtlasHelper.get_insignia_texture_settings_from_level(flag)
	local tbl_5 = {
		50,
		138
	}

	passes[#passes + 1] = {
		style_id = "insignia_main",
		pass_type = "texture_uv",
		content_id = "insignia_main",
		retained_mode = arg_132_5
	}
	passes[#passes + 1] = {
		style_id = "insignia_addon",
		pass_type = "texture_uv",
		content_id = "insignia_addon",
		content_check_function = function (self, arg_133_1)
			-- function 133
			return self.uvs
		end,
		retained_mode = arg_132_5
	}
	tbl_4.insignia_main = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = tbl_5,
		color = arg_132_3 or {
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
	tbl_4.insignia_addon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = tbl_5,
		color = arg_132_3 or {
			255,
			255,
			255,
			255
		}
	}

	local tbl_6 = {
		uvs = get_insignia_texture_settings_from_level
	}
	local flag_2

	flag_2 = not arg_132_2 and "insignias_main_small_masked" and "insignias_main_small"
	tbl_6.texture_id = flag_2
	tbl_3.insignia_main = tbl_6

	local tbl_7 = {
		uvs = var_132_7
	}
	local flag_3

	flag_3 = not arg_132_2 and "insignias_addon_small_masked" and "insignias_addon_small"
	tbl_7.texture_id = flag_3
	tbl_3.insignia_addon = tbl_7
	tbl_3.level = flag
	tbl_3.visible = flag > 0
	tbl.element = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.scenegraph_id = arg_132_0
	tbl.offset = arg_132_4 or {
		0,
		0,
		0
	}

	return tbl
end

UIWidgets.create_ceremony_award = function (arg_134_0, arg_134_1, arg_134_2)
	-- function 134
	local tbl = {}
	local tbl_2 = {
		passes = {}
	}
	local passes = tbl_2.passes
	local tbl_3 = {}
	local tbl_4 = {}
	local player_name = arg_134_1.player_name
	local level = arg_134_1.level
	local flag = arg_134_1.peer_id == Network.peer_id()
	local is_mvp = arg_134_1.is_mvp
	local header = arg_134_1.header
	local sub_header = arg_134_1.sub_header
	local team_color = arg_134_1.team_color
	local get_insignia_texture_settings_from_level, var_134_13 = UIAtlasHelper.get_insignia_texture_settings_from_level(level)
	local tbl_5 = {
		50,
		138
	}

	passes[#passes + 1] = {
		style_id = "mvp",
		pass_type = "text",
		text_id = "mvp",
		content_check_function = function (self, arg_135_1)
			-- function 135
			return self.is_mvp
		end
	}
	passes[#passes + 1] = {
		style_id = "mvp_masked",
		pass_type = "text",
		text_id = "mvp",
		content_check_function = function (self, arg_136_1)
			-- function 136
			return self.is_mvp
		end
	}
	passes[#passes + 1] = {
		style_id = "shine",
		texture_id = "shine",
		pass_type = "texture",
		content_check_function = function (self, arg_137_1)
			-- function 137
			return self.is_mvp
		end,
		content_change_function = function (arg_138_0, arg_138_1)
			-- function 138
			local num = Application.time_since_launch() % 2 / 2

			arg_138_1.offset[1] = math.lerp(-393, 393, num)
		end
	}
	passes[#passes + 1] = {
		style_id = "mvp_shadow",
		pass_type = "text",
		text_id = "mvp",
		content_check_function = function (self, arg_139_1)
			-- function 139
			return self.is_mvp
		end
	}
	passes[#passes + 1] = {
		style_id = "sparkle",
		pass_type = "rotated_texture",
		texture_id = "sparkle",
		content_check_function = function (self, arg_140_1)
			-- function 140
			return self.is_mvp
		end,
		content_change_function = function (arg_141_0, arg_141_1)
			-- function 141
			local num = Application.time_since_launch() % 2 / 2

			arg_141_1.angle = math.pi * 2 * num
			arg_141_1.color[1] = math.sin(num * math.pi) * 255
		end
	}
	passes[#passes + 1] = {
		style_id = "sparkle_2",
		pass_type = "rotated_texture",
		texture_id = "sparkle",
		content_check_function = function (self, arg_142_1)
			-- function 142
			return self.is_mvp
		end,
		content_change_function = function (arg_143_0, arg_143_1)
			-- function 143
			local num = (Application.time_since_launch() + 1.5) % 2 / 2

			arg_143_1.angle = math.pi * 2 * num
			arg_143_1.color[1] = math.sin(num * math.pi) * 255
		end
	}
	passes[#passes + 1] = {
		style_id = "header",
		pass_type = "text",
		text_id = "header",
		content_check_function = function (self, arg_144_1)
			-- function 144
			return not self.is_mvp
		end
	}
	passes[#passes + 1] = {
		style_id = "header_shadow",
		pass_type = "text",
		text_id = "header",
		content_check_function = function (self, arg_145_1)
			-- function 145
			return not self.is_mvp
		end
	}
	passes[#passes + 1] = {
		style_id = "sub_header",
		pass_type = "text",
		text_id = "sub_header",
		content_check_function = function (self, arg_146_1)
			-- function 146
			return not self.is_mvp
		end
	}
	passes[#passes + 1] = {
		style_id = "sub_header_shadow",
		pass_type = "text",
		text_id = "sub_header",
		content_check_function = function (self, arg_147_1)
			-- function 147
			return not self.is_mvp
		end
	}
	passes[#passes + 1] = {
		style_id = "player_name",
		pass_type = "text",
		text_id = "player_name",
		content_change_function = function (self)
			-- function 148
			local widget_offset = self.widget_offset

			if not widget_offset then
				return
			end

			local camera = arg_134_1.camera
			local world_pos = arg_134_1.world_pos
			local world_to_screen = Camera.world_to_screen(camera, Vector3(world_pos[1], world_pos[2], world_pos[3]))

			widget_offset[1] = UIInverseScaleVectorToResolution(world_to_screen, true)[1] - 145
		end
	}
	passes[#passes + 1] = {
		style_id = "player_name_shadow",
		pass_type = "text",
		text_id = "player_name_shadow",
		content_change_function = function (self)
			-- function 149
			local widget_offset = self.widget_offset

			if not widget_offset then
				return
			end

			local camera = arg_134_1.camera
			local world_pos = arg_134_1.world_pos
			local world_to_screen = Camera.world_to_screen(camera, Vector3(world_pos[1], world_pos[2], world_pos[3]))

			widget_offset[1] = UIInverseScaleVectorToResolution(world_to_screen, true)[1] - 145
		end
	}
	passes[#passes + 1] = {
		style_id = "insignia_main",
		pass_type = "texture_uv",
		content_id = "insignia_main",
		content_check_function = function (self, arg_150_1)
			-- function 150
			return self.parent.level > 0
		end
	}
	passes[#passes + 1] = {
		style_id = "divider",
		pass_type = "texture_uv",
		content_id = "divider"
	}
	passes[#passes + 1] = {
		style_id = "insignia_addon",
		pass_type = "texture_uv",
		content_id = "insignia_addon",
		content_check_function = function (self, arg_151_1)
			-- function 151
			local uvs = self.uvs

			uvs = not uvs and self.parent.level > 0

			return uvs
		end
	}
	tbl_4.mvp = {
		upper_case = true,
		localize = false,
		font_size = 80,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("dark_golden_rod", 255),
		offset = {
			60,
			-25,
			1
		}
	}
	tbl_4.mvp_masked = {
		upper_case = true,
		localize = false,
		font_size = 80,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true,
		font_type = "hell_shark_header_masked",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			60,
			-25,
			2
		}
	}
	tbl_4.mvp_shadow = {
		upper_case = true,
		localize = false,
		font_size = 80,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			62,
			-27,
			0
		}
	}
	tbl_4.shine = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			393,
			256
		},
		offset = {
			-393,
			0,
			10
		}
	}
	tbl_4.sparkle = {
		vertical_alignment = "bottom",
		angle = 0,
		horizontal_alignment = "left",
		texture_size = {
			128,
			128
		},
		pivot = {
			64,
			64
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			-10,
			5
		}
	}
	tbl_4.sparkle_2 = {
		vertical_alignment = "bottom",
		angle = 0,
		horizontal_alignment = "left",
		texture_size = {
			128,
			128
		},
		pivot = {
			64,
			64
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			130,
			15,
			5
		}
	}
	tbl_4.header = {
		upper_case = true,
		localize = false,
		font_size = 48,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			60,
			-25,
			1
		}
	}
	tbl_4.header_shadow = {
		upper_case = true,
		localize = false,
		font_size = 48,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			62,
			-27,
			0
		}
	}
	tbl_4.sub_header = {
		font_size = 22,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			60,
			45,
			1
		}
	}
	tbl_4.sub_header_shadow = {
		font_size = 22,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark",
		area_size = {
			200,
			100
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			62,
			43,
			0
		}
	}
	tbl_4.player_name = {
		font_size = 26,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark",
		area_size = {
			200,
			100
		},
		text_color = {
			255,
			255,
			255,
			255
		},
		offset = {
			60,
			5,
			1
		}
	}
	tbl_4.player_name_shadow = {
		font_size = 26,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark",
		area_size = {
			200,
			100
		},
		text_color = {
			255,
			0,
			0,
			0
		},
		offset = {
			62,
			3,
			0
		}
	}
	tbl_4.insignia_main = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = tbl_5,
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
	tbl_4.divider = {
		vertical_alignment = "bottom",
		horizontal_alignment = "left",
		texture_size = {
			152,
			2
		},
		color = team_color or {
			255,
			255,
			255,
			255
		},
		offset = {
			60,
			40,
			1
		}
	}
	tbl_4.insignia_addon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = tbl_5,
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_3.insignia_main = {
		texture_id = "insignias_main_small",
		uvs = get_insignia_texture_settings_from_level
	}
	tbl_3.insignia_addon = {
		texture_id = "insignias_addon_small",
		uvs = var_134_13
	}
	tbl_3.level = level
	tbl_3.award_data = arg_134_1
	tbl_3.divider = {
		texture_id = "horizontal_gradient",
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
	}
	tbl_3.is_mvp = is_mvp
	tbl_3.mvp = Localize("vs_award_mvp_name")
	tbl_3.header = header
	tbl_3.sub_header = sub_header

	local str

	if not flag then
		str = "{#color(255,255,255)}(" .. Localize("versus_hero_selection_view_you") .. ") {#reset()}"

		if not str then
			-- Nothing
		end
	end

	str = ""

	::label_134_0::

	local format = string.format
	local str_2 = "{#color(%d,%d,%d)}%s{#reset()}"
	local var_134_18 = team_color[2]
	local var_134_19 = team_color[3]
	local var_134_20 = team_color[4]
	local crop_text = UIRenderer.crop_text
	local var_134_22 = player_name
	local flag_2

	flag_2 = not flag and 10 and 17
	tbl_3.player_name = str .. format(str_2, var_134_18, var_134_19, var_134_20, crop_text(var_134_22, flag_2))

	local str_3

	if not flag then
		str_3 = "(" .. Localize("versus_hero_selection_view_you") .. ") "

		if not str_3 then
			-- Nothing
		end
	end

	str_3 = ""

	::label_134_1::

	local format_2 = string.format
	local str_4 = "%s"
	local crop_text_2 = UIRenderer.crop_text
	local var_134_28 = player_name
	local flag_3

	flag_3 = not flag and 10 and 17
	tbl_3.player_name_shadow = str_3 .. format_2(str_4, crop_text_2(var_134_28, flag_3))
	tbl_3.shine = "diagonal_shine"
	tbl_3.sparkle = "sparkle_effect"
	tbl.element = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.scenegraph_id = arg_134_0
	tbl.offset = arg_134_2 or {
		0,
		0,
		0
	}

	return tbl
end

local tbl = {
	upper_case = true,
	localize = false,
	font_size = 130,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	area_size = {
		500,
		200
	},
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		20,
		-130,
		1
	}
}

UIWidgets.create_screen_ceremony_award = function (arg_152_0, arg_152_1, arg_152_2, arg_152_3)
	-- function 152
	local tbl_2 = {}
	local tbl_3 = {
		passes = {}
	}
	local passes = tbl_3.passes
	local tbl_4 = {}
	local tbl_5 = {}
	local player_name = arg_152_1.player_name
	local level = arg_152_1.level
	local amount = arg_152_1.amount
	local flag = arg_152_1.peer_id == Network.peer_id()
	local is_mvp = arg_152_1.is_mvp
	local is_local = arg_152_1.is_local
	local header = arg_152_1.header
	local award_material = arg_152_1.award_material

	award_material = award_material or "circle"

	local award_mask_material = arg_152_1.award_mask_material

	award_mask_material = award_mask_material or nil

	local var_152_14

	if not is_mvp then
		var_152_14 = Localize("vs_award_mvp_sub_header")

		if not var_152_14 then
			-- Nothing
		end
	end

	var_152_14 = arg_152_1.sub_header

	::label_152_0::

	local team_color = arg_152_1.team_color
	local get_insignia_texture_settings_from_level, var_152_17 = UIAtlasHelper.get_insignia_texture_settings_from_level(level)
	local tbl_6 = {
		50,
		138
	}
	local get_text_width = UIUtils.get_text_width(arg_152_3, tbl, amount)

	passes[#passes + 1] = {
		style_id = "mvp",
		pass_type = "text",
		text_id = "mvp",
		content_check_function = function (self, arg_153_1)
			-- function 153
			return self.is_mvp
		end
	}
	passes[#passes + 1] = {
		style_id = "mvp_masked",
		pass_type = "text",
		text_id = "mvp",
		content_check_function = function (self, arg_154_1)
			-- function 154
			return self.is_mvp
		end
	}
	passes[#passes + 1] = {
		style_id = "shine",
		texture_id = "shine",
		pass_type = "texture",
		content_check_function = function (self, arg_155_1)
			-- function 155
			return self.is_mvp
		end,
		content_change_function = function (self, arg_156_1)
			-- function 156
			local num = self.shine_timer % 2 / 2

			arg_156_1.offset[1] = math.lerp(-393, 393, num)
		end
	}
	passes[#passes + 1] = {
		style_id = "mvp_shadow",
		pass_type = "text",
		text_id = "mvp",
		content_check_function = function (self, arg_157_1)
			-- function 157
			return self.is_mvp
		end
	}
	passes[#passes + 1] = {
		style_id = "sparkle",
		pass_type = "rotated_texture",
		texture_id = "sparkle",
		content_check_function = function (self, arg_158_1)
			-- function 158
			return self.is_mvp
		end,
		content_change_function = function (arg_159_0, arg_159_1)
			-- function 159
			local num = Application.time_since_launch() % 2 / 2

			arg_159_1.angle = math.pi * 2 * num
			arg_159_1.color[1] = math.sin(num * math.pi) * 255
		end
	}
	passes[#passes + 1] = {
		style_id = "sparkle_2",
		pass_type = "rotated_texture",
		texture_id = "sparkle",
		content_check_function = function (self, arg_160_1)
			-- function 160
			return self.is_mvp
		end,
		content_change_function = function (arg_161_0, arg_161_1)
			-- function 161
			local num = (Application.time_since_launch() + 1) % 2 / 2

			arg_161_1.angle = math.pi * 2 * num
			arg_161_1.color[1] = math.sin(num * math.pi) * 255
		end
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "background",
		texture_id = "background"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "award",
		texture_id = "award_texture"
	}
	passes[#passes + 1] = {
		style_id = "award_shine_mask",
		texture_id = "award_shine_mask",
		pass_type = "texture",
		content_change_function = function (self, arg_162_1)
			-- function 162
			local num = self.shine_timer % 2 / 2

			arg_162_1.offset[1] = math.lerp(-393, 393, num)

			local time_and_delta, var_162_2 = Managers.time:time_and_delta("main")

			self.shine_timer = self.shine_timer + var_162_2
		end
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "award_shine",
		texture_id = "award_shine",
		content_check_function = function (self)
			-- function 163
			return self.award_shine
		end
	}
	passes[#passes + 1] = {
		style_id = "team_bg",
		pass_type = "texture_uv",
		content_id = "team_bg"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "frame_top",
		texture_id = "frame"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "frame_bottom",
		texture_id = "frame"
	}
	passes[#passes + 1] = {
		pass_type = "rotated_texture",
		style_id = "frame_right",
		texture_id = "frame"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "frame_middle",
		texture_id = "frame"
	}
	passes[#passes + 1] = {
		style_id = "insignia_main",
		pass_type = "texture_uv",
		content_id = "insignia_main",
		content_check_function = function (self, arg_164_1)
			-- function 164
			return self.parent.level > 0
		end
	}
	passes[#passes + 1] = {
		style_id = "insignia_addon",
		pass_type = "texture_uv",
		content_id = "insignia_addon",
		content_check_function = function (self, arg_165_1)
			-- function 165
			local uvs = self.uvs

			uvs = not uvs and self.parent.level > 0

			return uvs
		end
	}
	passes[#passes + 1] = {
		style_id = "header",
		pass_type = "text",
		text_id = "header",
		content_check_function = function (self, arg_166_1)
			-- function 166
			return not self.is_mvp
		end
	}
	passes[#passes + 1] = {
		style_id = "header_shadow",
		pass_type = "text",
		text_id = "header",
		content_check_function = function (self, arg_167_1)
			-- function 167
			return not self.is_mvp
		end
	}
	passes[#passes + 1] = {
		style_id = "sub_header",
		pass_type = "text",
		text_id = "sub_header"
	}
	passes[#passes + 1] = {
		style_id = "sub_header_shadow",
		pass_type = "text",
		text_id = "sub_header"
	}
	passes[#passes + 1] = {
		style_id = "player_name",
		pass_type = "text",
		text_id = "player_name"
	}
	passes[#passes + 1] = {
		style_id = "player_name_shadow",
		pass_type = "text",
		text_id = "player_name_shadow"
	}
	tbl_5.mvp = {
		upper_case = true,
		localize = false,
		font_size = 100,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		font_type = "hell_shark_header",
		area_size = {
			500,
			200
		},
		text_color = Colors.get_color_table_with_alpha("dark_golden_rod", 255),
		offset = {
			210,
			-70,
			1
		}
	}
	tbl_5.mvp_masked = {
		upper_case = true,
		localize = false,
		font_size = 100,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		font_type = "hell_shark_header_masked",
		area_size = {
			500,
			200
		},
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			210,
			-70,
			2
		}
	}
	tbl_5.mvp_shadow = {
		upper_case = true,
		localize = false,
		font_size = 100,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		font_type = "hell_shark_header",
		area_size = {
			500,
			200
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			212,
			-72,
			0
		}
	}
	tbl_5.shine = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			393,
			256
		},
		offset = {
			-183,
			-70,
			10
		}
	}
	tbl_5.sparkle = {
		vertical_alignment = "bottom",
		angle = 0,
		horizontal_alignment = "left",
		texture_size = {
			128,
			128
		},
		pivot = {
			64,
			64
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			160,
			95,
			5
		}
	}
	tbl_5.sparkle_2 = {
		vertical_alignment = "top",
		angle = 0,
		horizontal_alignment = "left",
		texture_size = {
			128,
			128
		},
		pivot = {
			64,
			64
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			310,
			-20,
			5
		}
	}
	tbl_5.background = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			450,
			160
		},
		offset = {
			110,
			-70,
			0
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_5.award = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			225,
			230
		},
		offset = {
			-15,
			-35,
			10
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_5.award_shine = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			225,
			230
		},
		offset = {
			-15,
			-35,
			11
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_5.award_shine_mask = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			393,
			256
		},
		offset = {
			-15,
			-22,
			12
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_5.team_bg = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			450,
			50
		},
		offset = {
			110,
			-180,
			1
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	local num = 20

	tbl_5.frame_top = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			450,
			num
		},
		offset = {
			110,
			-70 + num,
			3
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_5.frame_bottom = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			450,
			num
		},
		offset = {
			110,
			-230 + num,
			3
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_5.frame_right = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			156,
			num
		},
		offset = {
			404,
			-70 + num,
			4
		},
		angle = -math.pi * 0.5,
		pivot = {
			156,
			0
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_5.frame_middle = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		texture_size = {
			446,
			num
		},
		offset = {
			110,
			-180 + num,
			3
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_5.insignia_main = {
		vertical_alignment = "top",
		horizontal_alignment = "right",
		texture_size = {
			50,
			138
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			50,
			-70,
			10
		}
	}
	tbl_5.insignia_addon = {
		vertical_alignment = "top",
		horizontal_alignment = "right",
		texture_size = {
			50,
			138
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			50,
			-70,
			9
		}
	}

	local flag_2

	flag_2 = not (Utf8.length(header) > 10) or not 15 or 0
	tbl_5.header = {
		upper_case = true,
		localize = false,
		font_size = 65,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		area_size = {
			255,
			200
		},
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			215,
			140 + flag_2,
			3
		}
	}
	tbl_5.header_shadow = {
		upper_case = true,
		localize = false,
		font_size = 65,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark_header",
		area_size = {
			255,
			200
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			213,
			138 + flag_2,
			2
		}
	}
	tbl_5.sub_header = {
		word_wrap = false,
		upper_case = true,
		localize = false,
		font_type = "hell_shark_header",
		font_size = 30,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		area_size = {
			255,
			200
		},
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			220,
			120 + flag_2 * 0.5,
			3
		}
	}
	tbl_5.sub_header_shadow = {
		word_wrap = false,
		upper_case = true,
		localize = false,
		font_type = "hell_shark_header",
		font_size = 30,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		area_size = {
			255,
			200
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			222,
			118 + flag_2 * 0.5,
			2
		}
	}
	tbl_5.player_name = {
		font_size = 30,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark",
		area_size = {
			500,
			100
		},
		text_color = {
			255,
			255,
			255,
			255
		},
		offset = {
			220,
			80,
			3
		}
	}
	tbl_5.player_name_shadow = {
		font_size = 30,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = true,
		font_type = "hell_shark",
		area_size = {
			500,
			200
		},
		text_color = {
			255,
			0,
			0,
			0
		},
		offset = {
			222,
			78,
			2
		}
	}
	tbl_4.insignia_main = {
		texture_id = "insignias_main_small",
		uvs = get_insignia_texture_settings_from_level
	}
	tbl_4.insignia_addon = {
		texture_id = "insignias_addon_small",
		uvs = var_152_17
	}
	tbl_4.level = level
	tbl_4.award_data = arg_152_1
	tbl_4.divider = {
		texture_id = "horizontal_gradient",
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
	}
	tbl_4.is_mvp = is_mvp
	tbl_4.mvp = Localize("vs_award_mvp_name")
	tbl_4.header = header
	tbl_4.sub_header = var_152_14

	local str

	if not flag then
		str = "{#color(128,128,128)}(" .. Localize("versus_hero_selection_view_you") .. ") {#reset()}"

		if not str then
			-- Nothing
		end
	end

	str = ""

	::label_152_1::

	local format = string.format
	local str_2 = "{#color(%d,%d,%d)}%s{#reset()}"
	local var_152_25 = team_color[2]
	local var_152_26 = team_color[3]
	local var_152_27 = team_color[4]
	local crop_text = UIRenderer.crop_text
	local var_152_29 = player_name
	local flag_3

	flag_3 = not flag and 10 and 17
	tbl_4.player_name = str .. format(str_2, var_152_25, var_152_26, var_152_27, crop_text(var_152_29, flag_3))

	local str_3

	if not flag then
		str_3 = "(" .. Localize("versus_hero_selection_view_you") .. ") "

		if not str_3 then
			-- Nothing
		end
	end

	str_3 = ""

	::label_152_2::

	local format_2 = string.format
	local str_4 = "%s"
	local crop_text_2 = UIRenderer.crop_text
	local var_152_35 = player_name
	local flag_4

	flag_4 = not flag and 10 and 17
	tbl_4.player_name_shadow = str_3 .. format_2(str_4, crop_text_2(var_152_35, flag_4))
	tbl_4.shine = "diagonal_shine"
	tbl_4.award_shine_mask = "diagonal_shine_write_mask"
	tbl_4.award_shine = award_mask_material
	tbl_4.amount = amount
	tbl_4.sparkle = "sparkle_effect"
	tbl_4.shine_timer = 0
	tbl_4.background = "award_bg"
	tbl_4.award_texture = award_material

	local tbl_7 = {
		uvs = {
			{
				0,
				0.3125
			},
			{
				0.9,
				1
			}
		}
	}
	local flag_5

	flag_5 = not is_local and "award_bg_local_team" and "award_bg_opponent_team"
	tbl_7.texture_id = flag_5
	tbl_4.team_bg = tbl_7
	tbl_4.frame = "divider_01_bottom"
	tbl_2.element = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.scenegraph_id = arg_152_0
	tbl_2.offset = arg_152_2 or {
		0,
		0,
		0
	}

	return tbl_2
end

UIWidgets.create_dark_pact_hud_ability_icon_widget = function (arg_168_0, arg_168_1)
	-- function 168
	local tbl = {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_icon_bg",
					texture_id = "texture_icon"
				},
				{
					pass_type = "texture",
					style_id = "texture_icon",
					texture_id = "texture_icon",
					content_check_function = function (self)
						-- function 169
						return self.is_cooldown
					end
				},
				{
					style_id = "icon_mask",
					texture_id = "icon_mask",
					pass_type = "texture",
					content_change_function = function (arg_170_0, arg_170_1, arg_170_2, arg_170_3)
						-- function 170
						arg_170_1.color[1] = 255 * math.abs(math.sin(Managers.time:time("ui") * 2.5))
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_frame",
					texture_id = "texture_frame"
				},
				{
					style_id = "texture_cooldown",
					texture_id = "texture_cooldown",
					pass_type = "gradient_mask_texture",
					content_check_function = function (self)
						-- function 171
						return self.is_cooldown
					end,
					content_change_function = function (arg_172_0, arg_172_1, arg_172_2, arg_172_3)
						-- function 172
						arg_172_1.color[1] = 255 * math.abs(math.sin(Managers.time:time("ui") * 2.5))
					end
				},
				{
					style_id = "input",
					pass_type = "text",
					text_id = "input",
					content_change_function = function (self, arg_173_1)
						-- function 173
						local is_device_active = Managers.input:is_device_active("gamepad")
						local gamepad_input

						if not is_device_active then
							gamepad_input = self.settings.gamepad_input

							if not gamepad_input then
								-- Nothing
							end
						end

						gamepad_input = self.settings.input_action

						::label_173_0::

						if self.current_input_action ~= gamepad_input then
							self.current_input_action = gamepad_input

							local get_service = Managers.input:get_service("Player")
							local get_gamepad_input_texture_data, var_173_4, var_173_5 = UISettings.get_gamepad_input_texture_data(get_service, gamepad_input, is_device_active)

							if not var_173_5 and var_173_5[1] == "mouse" and not is_device_active then
								self.input = string.format("$KEY;Player__%s:", gamepad_input)
								arg_173_1.offset[1] = 68
							else
								self.input = var_173_4
								arg_173_1.offset[1] = 40
							end
						end
					end
				}
			}
		}
	}
	local tbl_2 = {
		set_unsaturated = false,
		is_cooldown = false,
		texture_cooldown = "dark_pact_ability_icon_cooldown_gradient",
		progress = 0,
		texture_frame = "health_bar_ability_icon_frame",
		gris = "rect_masked",
		icon_mask = "dark_pact_ability_icon_gradient_mask",
		input = "n/a"
	}
	local icon

	if not arg_168_1 then
		icon = arg_168_1.icon

		if not icon then
			-- Nothing
		end
	end

	icon = "icons_placeholder"

	::label_168_0::

	tbl_2.texture_icon = icon
	tbl_2.settings = arg_168_1 or {}
	tbl.content = tbl_2
	tbl.style = {
		texture_icon_bg = {
			saturated = false,
			size = {
				56,
				56
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				12,
				14,
				1
			}
		},
		texture_icon = {
			saturated = false,
			masked = true,
			size = {
				56,
				56
			},
			color = {
				255,
				100,
				100,
				100
			},
			offset = {
				12,
				14,
				2
			}
		},
		icon_mask = {
			size = {
				56,
				56
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				12,
				14,
				2
			}
		},
		texture_cooldown = {
			size = {
				56,
				56
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				12,
				14,
				3
			}
		},
		texture_frame = {
			size = {
				80,
				80
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
				4
			}
		},
		input = {
			font_type = "hell_shark",
			upper_case = false,
			localize = false,
			use_shadow = true,
			font_size = 26,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			size = {
				0,
				0
			},
			area_size = {
				20,
				20
			},
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				68,
				100,
				6
			}
		}
	}
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_168_0

	return tbl
end

UIWidgets.create_dark_pact_selection_widget = function (arg_174_0)
	-- function 174
	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "portrait_frame",
					texture_id = "portrait_frame"
				},
				{
					pass_type = "texture",
					style_id = "portrait",
					texture_id = "portrait"
				},
				{
					pass_type = "texture",
					style_id = "portrait_frame_selected",
					texture_id = "portrait_frame_selected"
				},
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot"
				}
			}
		},
		content = {
			portrait = "icons_placeholder",
			portrait_frame_selected = "pactsworn_frame_highlight",
			portrait_frame = "pactsworn_frame_iron",
			selected = false,
			hotspot = {}
		},
		style = {
			portrait = {
				texture_size = {
					140,
					140
				},
				default_size = {
					140,
					140
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					3
				},
				default_offset = {
					0,
					0,
					3
				}
			},
			portrait_frame = {
				texture_size = {
					140,
					140
				},
				default_size = {
					140,
					140
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					5
				},
				default_offset = {
					0,
					0,
					5
				}
			},
			hotspot = {
				size = {
					140,
					140
				},
				default_size = {
					140,
					140
				},
				offset = {
					0,
					0,
					3
				},
				default_offset = {
					0,
					0,
					3
				}
			},
			portrait_frame_selected = {
				texture_size = {
					168,
					168
				},
				default_size = {
					168,
					168
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-14,
					-14,
					10
				},
				default_offset = {
					-14,
					-14,
					10
				}
			}
		},
		scenegraph_id = arg_174_0,
		offset = {
			0,
			0,
			1
		}
	}
end

UIWidgets.create_settings_stepper_widget = function (arg_175_0, arg_175_1, arg_175_2, arg_175_3, arg_175_4, arg_175_5, arg_175_6)
	-- function 175
	local values = arg_175_1.values

	values = values or {}

	local count = #values

	count = count or 0

	local str = "menu_settings_" .. arg_175_1.setting_name
	local str_2 = "tooltip_" .. arg_175_1.setting_name
	local tbl = {
		24,
		24
	}
	local tbl_2 = {
		32,
		32
	}

	local function fn(self, arg_176_1, arg_176_2)
		-- function 176
		local parent = self.parent
		local hover_progress = self.hover_progress

		hover_progress = hover_progress or 0

		local num = 15

		if not parent.can_hover and not self.is_hover then
			hover_progress = math.min(hover_progress + arg_176_2 * num, 1)
		else
			hover_progress = math.max(hover_progress - arg_176_2 * num, 0)
		end

		self.hover_progress = hover_progress

		local press_progress = self.press_progress

		press_progress = press_progress or 1

		local num_2 = 25

		if not parent.can_hover and not self.is_held then
			press_progress = math.max(press_progress - arg_176_2 * num_2, 0.5)
		else
			press_progress = math.min(press_progress + arg_176_2 * num_2, 1)
		end

		self.press_progress = press_progress
	end

	local function fn_2(self, arg_177_1, arg_177_2, arg_177_3)
		-- function 177
		local hover_progress = arg_177_2.hover_progress

		hover_progress = hover_progress or 0

		local press_progress = arg_177_2.press_progress

		press_progress = press_progress or 1
		arg_177_1.color[1] = 255 * hover_progress

		if not self.can_hover and not arg_177_2.is_hover then
			arg_177_1.color[1] = 255 * press_progress
		end
	end

	return {
		element = {
			passes = {
				{
					style_id = "setting_name",
					pass_type = "text",
					text_id = "setting_name",
					content_change_function = function (self, arg_178_1, arg_178_2, arg_178_3)
						-- function 178
						local fade_progress = self.fade_progress

						fade_progress = fade_progress or 0
						arg_178_1.text_color[1] = 100 + 155 * fade_progress
					end
				},
				{
					style_id = "left_arrow",
					pass_type = "texture_uv",
					content_id = "left_arrow",
					content_change_function = function (self, arg_179_1, arg_179_2, arg_179_3)
						-- function 179
						local fade_progress = self.parent.fade_progress

						fade_progress = fade_progress or 0
						arg_179_1.color[1] = 100 + 155 * fade_progress
					end
				},
				{
					style_id = "left_arrow_hover",
					pass_type = "texture_uv",
					content_id = "left_arrow_hover",
					content_check_function = function (self, arg_180_1)
						-- function 180
						return self.parent.is_server
					end,
					content_change_function = function (self, arg_181_1, arg_181_2, arg_181_3)
						-- function 181
						local left_arrow_hotspot = self.parent.left_arrow_hotspot

						fn_2(self, arg_181_1, left_arrow_hotspot)
					end
				},
				{
					style_id = "left_arrow_hotspot",
					pass_type = "hotspot",
					content_id = "left_arrow_hotspot",
					content_check_function = function (self, arg_182_1)
						-- function 182
						local is_server = self.parent.is_server

						is_server = not is_server and self.parent.focused

						return is_server
					end,
					content_change_function = function (self, arg_183_1, arg_183_2, arg_183_3)
						-- function 183
						local parent = self.parent

						fn(self, arg_183_1, arg_183_3)
					end
				},
				{
					pass_type = "texture",
					style_id = "setting_value_bg",
					texture_id = "setting_value_bg"
				},
				{
					style_id = "setting_value",
					pass_type = "text",
					text_id = "setting_value",
					content_change_function = function (self, arg_184_1, arg_184_2, arg_184_3)
						-- function 184
						local values = self.data.values
						local ui_data = self.ui_data
						local var_184_2 = values[self.setting_idx]

						if self.value ~= var_184_2 then
							self.value = var_184_2

							local flag = not ui_data and ui_data.localization_options
							local str = ""

							if not flag and not flag[var_184_2] then
								local var_184_5 = flag[var_184_2]

								str = Localize(var_184_5)
							else
								str = string.format("%s", self.value)
							end

							if (not flag and flag[var_184_2] or not ui_data) and not ui_data.setting_type then
								local carousel = DLCSettings.carousel

								carousel = not carousel and DLCSettings.carousel.custom_game_settigns_values_suffix

								if not carousel and not carousel[ui_data.setting_type] then
									str = str .. carousel[ui_data.setting_type]
								end
							end

							self.setting_value = str
						end

						if self.value ~= self.default_value then
							arg_184_1.text_color = arg_184_1.modified_color
						else
							arg_184_1.text_color = arg_184_1.default_color
						end

						local fade_progress = self.fade_progress

						fade_progress = fade_progress or 0
						arg_184_1.text_color[1] = 100 + 155 * fade_progress
					end
				},
				{
					style_id = "right_arrow",
					texture_id = "right_arrow",
					pass_type = "texture",
					content_change_function = function (self, arg_185_1, arg_185_2, arg_185_3)
						-- function 185
						local fade_progress = self.fade_progress

						fade_progress = fade_progress or 0
						arg_185_1.color[1] = 100 + 155 * fade_progress
					end
				},
				{
					style_id = "right_arrow_hover",
					texture_id = "right_arrow_hover",
					pass_type = "texture",
					content_check_function = function (self, arg_186_1)
						-- function 186
						return self.is_server
					end,
					content_change_function = function (self, arg_187_1, arg_187_2, arg_187_3)
						-- function 187
						local right_arrow_hotspot = self.right_arrow_hotspot

						fn_2(self, arg_187_1, right_arrow_hotspot)
					end
				},
				{
					style_id = "right_arrow_hotspot",
					pass_type = "hotspot",
					content_id = "right_arrow_hotspot",
					content_check_function = function (self, arg_188_1)
						-- function 188
						local is_server = self.parent.is_server

						is_server = not is_server and self.parent.focused

						return is_server
					end,
					content_change_function = function (self, arg_189_1, arg_189_2, arg_189_3)
						-- function 189
						local parent = self.parent

						fn(self, arg_189_1, arg_189_3)
					end
				},
				{
					pass_type = "texture",
					style_id = "divider",
					texture_id = "divider"
				},
				{
					style_id = "setting_highlight_hotspot",
					pass_type = "hotspot",
					content_id = "setting_highlight_hotspot",
					content_change_function = function (self, arg_190_1, arg_190_2, arg_190_3)
						-- function 190
						local hover_progress = self.hover_progress

						hover_progress = hover_progress or 0

						local num = 15

						if not self.parent.can_hover and self.is_hover and not self.parent.is_gamepad_active or not self.parent.focused and not self.parent.is_selected then
							hover_progress = math.min(hover_progress + arg_190_3 * num, 1)
						else
							hover_progress = math.max(hover_progress - arg_190_3 * num, 0)
						end

						self.hover_progress = hover_progress
					end
				},
				{
					style_id = "setting_highlight",
					texture_id = "setting_highlight",
					pass_type = "texture",
					content_change_function = function (self, arg_191_1, arg_191_2, arg_191_3)
						-- function 191
						local hover_progress = self.setting_highlight_hotspot.hover_progress

						hover_progress = hover_progress or 0
						arg_191_1.color[1] = 255 * hover_progress
					end
				},
				{
					pass_type = "texture",
					style_id = "reset_setting_button",
					texture_id = "reset_setting_button",
					content_check_function = function (self, arg_192_1)
						-- function 192
						local values = self.data.values
						local ui_data = self.ui_data

						if not (self.value ~= self.default_value) then
							-- Nothing
						end

						::label_192_0::

						local is_server = self.is_server

						is_server = not is_server and not self.is_gamepad_active

						::label_192_1::

						return is_server
					end
				},
				{
					style_id = "reset_setting_button_hovered",
					texture_id = "reset_setting_button_hovered",
					pass_type = "texture",
					content_check_function = function (self, arg_193_1)
						-- function 193
						local values = self.data.values
						local ui_data = self.ui_data

						if not (self.value ~= self.default_value) then
							-- Nothing
						end

						::label_193_0::

						local is_server = self.is_server

						is_server = not is_server and not not self.is_gamepad_active or self.focused

						::label_193_1::

						return is_server
					end,
					content_change_function = function (self, arg_194_1, arg_194_2, arg_194_3)
						-- function 194
						local reset_setting_button_hotspot = self.reset_setting_button_hotspot

						fn_2(self, arg_194_1, reset_setting_button_hotspot)
					end
				},
				{
					style_id = "reset_setting_button_hotspot",
					pass_type = "hotspot",
					content_id = "reset_setting_button_hotspot",
					content_check_function = function (self, arg_195_1)
						-- function 195
						local parent = self.parent
						local values = parent.data.values
						local ui_data = parent.ui_data
						local setting_idx = parent.setting_idx
						local default_idx = parent.default_idx

						if not (parent.value ~= parent.default_value) then
							-- Nothing
						end

						::label_195_0::

						local is_server = parent.is_server

						is_server = not is_server and not parent.is_gamepad_active

						::label_195_1::

						return is_server
					end,
					content_change_function = function (self, arg_196_1, arg_196_2, arg_196_3)
						-- function 196
						local parent = self.parent

						fn(self, arg_196_1, arg_196_3)
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function (self, arg_197_1)
						-- function 197
						local can_hover = self.can_hover

						can_hover = not can_hover and self.setting_highlight_hotspot.is_hover

						return can_hover
					end
				}
			}
		},
		content = {
			reset_setting_button_hovered = "achievement_refresh_on",
			right_arrow_hover = "arrow_on",
			default_idx = 1,
			default_value = 0,
			setting_highlight = "party_selection_glow",
			reset_setting_button = "achievement_refresh_off",
			setting_value_bg = "rect_masked",
			right_arrow = "arrow_off_01",
			divider = "rect_masked",
			data = arg_175_1,
			ui_data = arg_175_2,
			id = arg_175_5,
			name = arg_175_1.setting_name,
			on_setting_changed_cb = arg_175_6,
			settings = values,
			num_settings = count,
			setting_idx = arg_175_4,
			setting_value = tostring(arg_175_3),
			setting_name = str,
			left_arrow = {
				texture_id = "arrow_off_01",
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
			left_arrow_hover = {
				texture_id = "arrow_on",
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
			left_arrow_hotspot = {
				allow_multi_hover = true
			},
			right_arrow_hotspot = {
				allow_multi_hover = true
			},
			setting_highlight_hotspot = {
				allow_multi_hover = true
			},
			reset_setting_button_hotspot = {
				allow_multi_hover = true
			},
			tooltip_text = str_2
		},
		style = {
			setting_name = {
				upper_case = false,
				localize = true,
				vertical_alignment = "center",
				font_size = 20,
				horizontal_alignment = "left",
				use_shadow = true,
				masked = true,
				font_type = "hell_shark_masked",
				size = {
					380,
					30
				},
				area_size = {
					380,
					30
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					3
				}
			},
			left_arrow = {
				masked = true,
				texture_size = tbl_2,
				offset = {
					398,
					0,
					3
				},
				color = Colors.get_color_table_with_alpha("white", 120)
			},
			left_arrow_hover = {
				masked = true,
				texture_size = tbl_2,
				offset = {
					398,
					0,
					5
				},
				color = Colors.get_color_table_with_alpha("white", 120)
			},
			left_arrow_hotspot = {
				size = tbl_2,
				offset = {
					398,
					0,
					3
				}
			},
			setting_value_bg = {
				masked = true,
				size = {
					128,
					30
				},
				offset = {
					430,
					0,
					4
				},
				color = Colors.get_color_table_with_alpha("black", 120)
			},
			setting_value = {
				masked = true,
				upper_case = false,
				localize = false,
				font_type = "hell_shark_masked",
				font_size = 22,
				vertical_alignment = "center",
				horizontal_alignment = "center",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					128,
					30
				},
				area_size = {
					128,
					30
				},
				modified_color = Colors.get_color_table_with_alpha("pale_golden_rod", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 180),
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					430,
					0,
					5
				}
			},
			right_arrow = {
				masked = true,
				texture_size = tbl_2,
				offset = {
					560,
					0,
					3
				},
				color = Colors.get_color_table_with_alpha("white", 120)
			},
			right_arrow_hover = {
				masked = true,
				texture_size = tbl_2,
				offset = {
					560,
					0,
					4
				},
				color = Colors.get_color_table_with_alpha("white", 120)
			},
			right_arrow_hotspot = {
				size = tbl_2,
				offset = {
					560,
					0,
					3
				}
			},
			divider = {
				masked = true,
				size = {
					620,
					2
				},
				offset = {
					0,
					-2,
					1
				},
				color = Colors.get_color_table_with_alpha("gray", 100)
			},
			setting_highlight_hotspot = {
				size = {
					640,
					34
				},
				offset = {
					0,
					0,
					1
				}
			},
			setting_highlight = {
				masked = true,
				texture_size = {
					640,
					34
				},
				offset = {
					0,
					0,
					1
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			reset_setting_button = {
				masked = true,
				texture_size = tbl,
				offset = {
					594,
					4,
					3
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			reset_setting_button_hovered = {
				masked = true,
				texture_size = tbl,
				offset = {
					594,
					4,
					4
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			reset_setting_button_hotspot = {
				size = tbl,
				offset = {
					594,
					4,
					1
				}
			},
			tooltip_text = {
				font_type = "hell_shark_masked",
				upper_case = false,
				localize = true,
				use_shadow = true,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					180,
					30
				},
				area_size = {
					180,
					30
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			}
		},
		offset = {
			0,
			0,
			1
		},
		scenegraph_id = arg_175_0
	}
end

UIWidgets.create_settings_slider_widget = function (arg_198_0, arg_198_1, arg_198_2, arg_198_3, arg_198_4, arg_198_5, arg_198_6)
	-- function 198
	local values = arg_198_1.values

	values = values or {}

	local count = #values

	count = count or 1

	local str = "menu_settings_" .. arg_198_1.setting_name
	local str_2 = "tooltip_" .. arg_198_1.setting_name
	local tbl = {
		24,
		24
	}
	local tbl_2 = {
		100,
		30
	}
	local tbl_3 = {
		200,
		8
	}
	local num = 640 - tbl_3[1] - 138 + 8
	local num_2 = num + tbl_3[1]
	local button_frame_02 = UIFrameSettings.button_frame_02
	local tbl_4 = {
		11.9,
		22.95
	}
	local tbl_5 = {
		28.9,
		21.25
	}
	local var_198_12 = arg_198_4
	local clamp = math.clamp(var_198_12 / count, 0, 1)

	local function fn(self, arg_199_1, arg_199_2)
		-- function 199
		local parent = self.parent
		local hover_progress = self.hover_progress

		hover_progress = hover_progress or 0

		local num = 15

		if not parent.can_hover and not self.is_hover then
			hover_progress = math.min(hover_progress + arg_199_2 * num, 1)
		else
			hover_progress = math.max(hover_progress - arg_199_2 * num, 0)
		end

		self.hover_progress = hover_progress

		local press_progress = self.press_progress

		press_progress = press_progress or 1

		local num_2 = 25

		if not parent.can_hover and not self.is_held then
			press_progress = math.max(press_progress - arg_199_2 * num_2, 0.5)
		else
			press_progress = math.min(press_progress + arg_199_2 * num_2, 1)
		end

		self.press_progress = press_progress
	end

	local function fn_2(self, arg_200_1, arg_200_2, arg_200_3)
		-- function 200
		local hover_progress = arg_200_2.hover_progress

		hover_progress = hover_progress or 0

		local press_progress = arg_200_2.press_progress

		press_progress = press_progress or 1
		arg_200_1.color[1] = 255 * hover_progress

		if not self.can_hover and not arg_200_2.is_hover then
			arg_200_1.color[1] = 255 * press_progress
		end
	end

	return {
		element = {
			passes = {
				{
					style_id = "setting_name",
					pass_type = "text",
					text_id = "setting_name",
					content_change_function = function (self, arg_201_1, arg_201_2, arg_201_3)
						-- function 201
						local fade_progress = self.fade_progress

						fade_progress = fade_progress or 0
						arg_201_1.text_color[1] = 100 + 155 * fade_progress
					end
				},
				{
					pass_type = "texture",
					style_id = "setting_value_bg",
					texture_id = "setting_value_bg"
				},
				{
					style_id = "setting_value",
					pass_type = "text",
					text_id = "setting_value",
					content_change_function = function (self, arg_202_1, arg_202_2, arg_202_3)
						-- function 202
						local values = self.data.values
						local ui_data = self.ui_data
						local var_202_2 = values[self.setting_idx]

						if self.value ~= var_202_2 then
							self.value = var_202_2

							local flag = not ui_data and ui_data.localization_options
							local str = ""

							if not flag and not flag[var_202_2] then
								local var_202_5 = flag[var_202_2]

								str = Localize(var_202_5)
							elseif not ((type(self.value) ~= "number" or not ui_data) and ui_data.setting_type ~= "multiplier") then
								str = string.format("%.2f", self.value)
							else
								str = string.format("%s", self.value)
							end

							if (not flag and flag[var_202_2] or not ui_data) and not ui_data.setting_type then
								local carousel = DLCSettings.carousel

								carousel = not carousel and DLCSettings.carousel.custom_game_settigns_values_suffix

								if not carousel and not carousel[ui_data.setting_type] then
									str = str .. carousel[ui_data.setting_type]
								end
							end

							self.setting_value = str
						end

						if self.value ~= self.default_value then
							arg_202_1.text_color = arg_202_1.modified_color
						else
							arg_202_1.text_color = arg_202_1.default_color
						end

						local fade_progress = self.fade_progress

						fade_progress = fade_progress or 0
						arg_202_1.text_color[1] = 100 + 155 * fade_progress
					end
				},
				{
					pass_type = "texture",
					style_id = "divider",
					texture_id = "divider"
				},
				{
					style_id = "setting_highlight_hotspot",
					pass_type = "hotspot",
					content_id = "setting_highlight_hotspot",
					content_change_function = function (self, arg_203_1, arg_203_2, arg_203_3)
						-- function 203
						local hover_progress = self.hover_progress

						hover_progress = hover_progress or 0

						local num = 15

						if not self.parent.can_hover and self.is_hover and not self.parent.is_gamepad_active or not self.parent.focused and not self.parent.is_selected then
							hover_progress = math.min(hover_progress + arg_203_3 * num, 1)
						else
							hover_progress = math.max(hover_progress - arg_203_3 * num, 0)
						end

						self.hover_progress = hover_progress
					end
				},
				{
					style_id = "setting_highlight",
					texture_id = "setting_highlight",
					pass_type = "texture",
					content_change_function = function (self, arg_204_1, arg_204_2, arg_204_3)
						-- function 204
						local hover_progress = self.setting_highlight_hotspot.hover_progress

						hover_progress = hover_progress or 0
						arg_204_1.color[1] = 255 * hover_progress
					end
				},
				{
					pass_type = "texture",
					style_id = "reset_setting_button",
					texture_id = "reset_setting_button",
					content_check_function = function (self, arg_205_1)
						-- function 205
						local values = self.data.values
						local ui_data = self.ui_data

						if not (self.value ~= self.default_value) then
							-- Nothing
						end

						::label_205_0::

						local is_server = self.is_server

						is_server = not is_server and not self.is_gamepad_active

						::label_205_1::

						return is_server
					end
				},
				{
					style_id = "reset_setting_button_hovered",
					texture_id = "reset_setting_button_hovered",
					pass_type = "texture",
					content_check_function = function (self, arg_206_1)
						-- function 206
						local values = self.data.values
						local ui_data = self.ui_data

						if not (self.value ~= self.default_value) then
							-- Nothing
						end

						::label_206_0::

						local is_server = self.is_server

						is_server = not is_server and not not self.is_gamepad_active or self.focused

						::label_206_1::

						return is_server
					end,
					content_change_function = function (self, arg_207_1, arg_207_2, arg_207_3)
						-- function 207
						local reset_setting_button_hotspot = self.reset_setting_button_hotspot

						fn_2(self, arg_207_1, reset_setting_button_hotspot)
					end
				},
				{
					style_id = "reset_setting_button_hotspot",
					pass_type = "hotspot",
					content_id = "reset_setting_button_hotspot",
					content_check_function = function (self, arg_208_1)
						-- function 208
						local parent = self.parent
						local values = parent.data.values
						local ui_data = parent.ui_data
						local setting_idx = parent.setting_idx
						local default_idx = parent.default_idx

						if not (parent.value ~= parent.default_value) then
							-- Nothing
						end

						::label_208_0::

						local is_server = parent.is_server

						is_server = not is_server and not parent.is_gamepad_active

						::label_208_1::

						return is_server
					end,
					content_change_function = function (self, arg_209_1, arg_209_2, arg_209_3)
						-- function 209
						local parent = self.parent

						fn(self, arg_209_1, arg_209_3)
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function (self, arg_210_1)
						-- function 210
						local can_hover = self.can_hover

						can_hover = not can_hover and self.setting_highlight_hotspot.is_hover

						return can_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "slider_background",
					texture_id = "slider_background"
				},
				{
					pass_type = "texture_frame",
					style_id = "background_frame",
					texture_id = "background_frame"
				},
				{
					pass_type = "texture",
					style_id = "slider_button",
					texture_id = "slider_button",
					content_check_function = function (arg_211_0, arg_211_1)
						-- function 211
						return true
					end
				},
				{
					pass_type = "texture",
					style_id = "slider_button_hovered",
					texture_id = "slider_button_hovered",
					content_check_function = function (self, arg_212_1)
						-- function 212
						local can_hover = self.can_hover

						can_hover = not can_hover and self.slider_button_hotspot.is_hover

						return can_hover
					end
				},
				{
					content_check_hover = "slider_button_hotspot",
					pass_type = "held",
					style_id = "slider_background",
					held_function = function (arg_213_0, arg_213_1, arg_213_2, arg_213_3)
						-- function 213
						if not Managers.input:is_device_active("gamepad") then
							return
						end

						if not arg_213_2.can_hover then
							return
						end

						local var_213_0 = UIInverseScaleVectorToResolution(arg_213_3:get("cursor"))
						local scenegraph_id = arg_213_2.scenegraph_id
						local get_world_position = UISceneGraph.get_world_position(arg_213_0, scenegraph_id)
						local var_213_3 = arg_213_1.size[1]
						local num = var_213_0[1] - (get_world_position[1] + arg_213_1.offset[1] + 20)

						arg_213_2.current_slider_value = math.clamp(num / var_213_3, 0, 1)
					end,
					release_function = function (arg_214_0, arg_214_1, arg_214_2, arg_214_3)
						-- function 214
						local id = arg_214_2.id
						local setting_idx = arg_214_2.setting_idx

						arg_214_2.on_setting_changed_cb(id, setting_idx)
					end
				},
				{
					style_id = "slider_button_hotspot",
					pass_type = "hotspot",
					content_id = "slider_button_hotspot",
					content_check_function = function (self, arg_215_1)
						-- function 215
						local can_hover = self.parent.can_hover

						if not can_hover then
							can_hover = self.parent.is_server
							can_hover = not can_hover and self.parent.focused
						end

						return can_hover
					end
				},
				{
					pass_type = "local_offset",
					offset_function = function (arg_216_0, arg_216_1, arg_216_2)
						-- function 216
						local current_slider_value = arg_216_2.current_slider_value
						local num = 1
						local num_settings = arg_216_2.num_settings

						if not arg_216_2.is_gamepad_active then
							arg_216_2.setting_idx = math.clamp(math.round(num_settings * current_slider_value), num, num_settings)
						end

						local slider_background = arg_216_1.slider_background
						local size = slider_background.size
						local var_216_5 = slider_background.offset[1]
						local num_2 = size[1] * current_slider_value
						local slider_button = arg_216_1.slider_button
						local slider_button_hovered = arg_216_1.slider_button_hovered
						local slider_button_hotspot = arg_216_1.slider_button_hotspot
						local offset = slider_button.offset
						local texture_size = slider_button.texture_size
						local max = math.max(0, math.min(num_2 - texture_size[1], size[1] - texture_size[1]))

						slider_button.offset[1] = var_216_5 + num_2 - texture_size[1] / 2
						slider_button_hovered.offset[1] = slider_button.offset[1] + texture_size[1] / 2 - slider_button_hovered.texture_size[1] / 2
						slider_button_hotspot.offset[1] = slider_button.offset[1] + texture_size[1] / 2 - slider_button_hotspot.size[1] / 2
					end
				}
			}
		},
		content = {
			reset_setting_button_hovered = "achievement_refresh_on",
			reset_setting_button = "achievement_refresh_off",
			setting_highlight = "party_selection_glow",
			default_value = 0,
			slider_button = "slider_thumb",
			slider_background = "rect_masked",
			setting_value_bg = "rect_masked",
			divider = "rect_masked",
			slider_button_hovered = "slider_thumb_hover",
			default_idx = 1,
			data = arg_198_1,
			ui_data = arg_198_2,
			id = arg_198_5,
			name = arg_198_1.setting_name,
			on_setting_changed_cb = arg_198_6,
			settings = values,
			num_settings = count,
			setting_idx = arg_198_4,
			setting_value = tostring(arg_198_3),
			setting_name = str,
			setting_highlight_hotspot = {
				allow_multi_hover = true
			},
			reset_setting_button_hotspot = {
				allow_multi_hover = true
			},
			tooltip_text = str_2,
			background_frame = button_frame_02.texture,
			slider_button_hotspot = {
				allow_multi_hover = true
			},
			current_slider_value = clamp,
			min_offset = num,
			max_offset = num_2,
			scenegraph_id = arg_198_0
		},
		style = {
			setting_name = {
				masked = true,
				upper_case = false,
				localize = true,
				font_type = "hell_shark_masked",
				font_size = 20,
				vertical_alignment = "center",
				horizontal_alignment = "left",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					300,
					30
				},
				area_size = {
					300,
					30
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					2,
					3
				}
			},
			setting_value_bg = {
				masked = true,
				size = {
					tbl_2[1] - 32,
					tbl_2[2]
				},
				offset = {
					640 - tbl_2[1] - 20,
					2,
					4
				},
				color = Colors.get_color_table_with_alpha("black", 120)
			},
			setting_value = {
				masked = true,
				upper_case = false,
				localize = false,
				font_type = "hell_shark_masked",
				font_size = 22,
				vertical_alignment = "center",
				horizontal_alignment = "center",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					tbl_2[1] - 32,
					tbl_2[2]
				},
				area_size = {
					tbl_2[1] - 36,
					tbl_2[2]
				},
				modified_color = Colors.get_color_table_with_alpha("pale_golden_rod", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 180),
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					640 - tbl_2[1] - 20,
					2,
					5
				}
			},
			divider = {
				masked = true,
				size = {
					620,
					2
				},
				offset = {
					0,
					-2,
					1
				},
				color = Colors.get_color_table_with_alpha("gray", 100)
			},
			setting_highlight_hotspot = {
				size = {
					640,
					34
				},
				offset = {
					0,
					0,
					1
				}
			},
			setting_highlight = {
				masked = true,
				texture_size = {
					640,
					34
				},
				offset = {
					0,
					0,
					1
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			reset_setting_button = {
				masked = true,
				texture_size = tbl,
				offset = {
					594,
					4,
					3
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			reset_setting_button_hovered = {
				masked = true,
				texture_size = tbl,
				offset = {
					594,
					4,
					4
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			reset_setting_button_hotspot = {
				size = tbl,
				offset = {
					594,
					4,
					1
				}
			},
			tooltip_text = {
				font_type = "hell_shark_masked",
				upper_case = false,
				localize = true,
				use_shadow = true,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					180,
					30
				},
				area_size = {
					180,
					30
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					4,
					1
				}
			},
			slider_background = {
				masked = true,
				size = tbl_3,
				offset = {
					num,
					8,
					5
				},
				color = Colors.get_color_table_with_alpha("black", 255)
			},
			background_frame = {
				masked = true,
				frame_margins = {
					-3,
					-3
				},
				size = tbl_3,
				texture_size = button_frame_02.texture_size,
				texture_sizes = button_frame_02.texture_sizes,
				offset = {
					num,
					8,
					6
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			slider_button = {
				masked = true,
				texture_size = tbl_4,
				offset = {
					0,
					2,
					7
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			slider_button_hovered = {
				masked = true,
				texture_size = tbl_5,
				offset = {
					0,
					2,
					8
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			slider_button_hotspot = {
				size = tbl_5,
				offset = {
					0,
					2,
					9
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			}
		},
		offset = {
			0,
			0,
			1
		},
		scenegraph_id = arg_198_0
	}
end
