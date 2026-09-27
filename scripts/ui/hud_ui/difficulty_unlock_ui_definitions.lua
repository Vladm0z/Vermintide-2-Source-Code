-- chunkname: @scripts/ui/hud_ui/difficulty_unlock_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	root = {
		is_root = true,
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
	background = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			340,
			1
		},
		size = {
			522,
			108
		}
	},
	background_top = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0.5,
			0,
			2
		},
		size = {
			477,
			52
		}
	},
	background_bottom = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			522,
			56
		}
	},
	background_center = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			2,
			1
		},
		size = {
			481,
			80
		}
	},
	background_glow = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			14,
			4
		},
		size = {
			380,
			80
		}
	},
	difficulty_title_text = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			25,
			5
		},
		size = {
			1500,
			50
		}
	},
	difficulty_text = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			-12,
			5
		},
		size = {
			1500,
			50
		}
	},
	icon_root = {
		vertical_alignment = "bottom",
		parent = "background_bottom",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local str = "icon_root"
	local str_2 = "icon_" .. arg_1_0
	local tbl_2 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		parent = str,
		position = {
			0,
			26,
			1
		},
		size = {
			50,
			50
		}
	}

	tbl[str_2] = tbl_2

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					retained_mode = true
				},
				{
					pass_type = "rotated_texture",
					style_id = "part_1",
					texture_id = "part_1",
					retained_mode = true
				},
				{
					pass_type = "rotated_texture",
					style_id = "part_2",
					texture_id = "part_2",
					retained_mode = true
				},
				{
					pass_type = "rotated_texture",
					style_id = "part_3",
					texture_id = "part_3",
					retained_mode = true
				},
				{
					pass_type = "rotated_texture",
					style_id = "part_4",
					texture_id = "part_4",
					retained_mode = true
				},
				{
					pass_type = "rotated_texture",
					style_id = "part_5",
					texture_id = "part_5",
					retained_mode = true
				},
				{
					pass_type = "rotated_texture",
					style_id = "part_6",
					texture_id = "part_6",
					retained_mode = true
				}
			}
		},
		content = {
			part_3 = "hud_difficulty_unlocked_part_03",
			part_5 = "hud_difficulty_unlocked_part_05",
			part_4 = "hud_difficulty_unlocked_part_04",
			part_6 = "hud_difficulty_unlocked_part_06",
			part_1 = "hud_difficulty_unlocked_part_01",
			icon = "hud_difficulty_unlocked_icon",
			part_2 = "hud_difficulty_unlocked_part_02"
		},
		style = {
			icon = {
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
			part_1 = {
				angle = 0,
				pivot = {
					25,
					25
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
			part_2 = {
				angle = 0,
				pivot = {
					25,
					25
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
			part_3 = {
				angle = 0,
				pivot = {
					25,
					25
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
			part_4 = {
				angle = 0,
				pivot = {
					25,
					25
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
			part_5 = {
				angle = 0,
				pivot = {
					25,
					25
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
			part_6 = {
				angle = 0,
				pivot = {
					25,
					25
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
			}
		},
		scenegraph_id = str_2
	}
end

local tbl_2 = {
	vertical_alignment = "center",
	word_wrap = false,
	horizontal_alignment = "center",
	font_type = "hell_shark",
	font_size = 26,
	offset = {
		0,
		0,
		1
	}
}
local tbl_3 = {
	background_glow = UIWidgets.create_simple_texture("hud_difficulty_unlocked_glow", "background_glow"),
	background_top = UIWidgets.create_simple_texture("hud_difficulty_unlocked_bg_top", "background_top"),
	background_center = UIWidgets.create_simple_uv_texture("hud_difficulty_unlocked_bg_fade", {
		{
			0,
			0.5
		},
		{
			1,
			0.5
		}
	}, "background_center"),
	background_bottom = UIWidgets.create_simple_texture("hud_difficulty_unlocked_bg_bottom", "background_bottom"),
	difficulty_title_text = UIWidgets.create_simple_text("dlc1_2_difficulty_unlocked_title", "difficulty_title_text", 28, Colors.get_color_table_with_alpha("cheeseburger", 0)),
	difficulty_text = UIWidgets.create_simple_text("n/a", "difficulty_text", 40, Colors.get_color_table_with_alpha("white", 0)),
	difficulty_icon_1 = fn(1),
	difficulty_icon_2 = fn(2),
	difficulty_icon_3 = fn(3),
	difficulty_icon_4 = fn(4),
	difficulty_icon_5 = fn(5)
}
local tbl_4 = {
	presentation = {
		{
			name = "reset",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				local icons = arg_2_2.icons

				for i, v in ipairs(icons) do
					local style = v.style

					style.icon.color[1] = 255

					for k = 1, 6 do
						local var_2_2 = style["part_" .. k]
						local offset = var_2_2.offset
						local color = var_2_2.color

						offset[1] = 0
						offset[2] = 0
						color[1] = 255
						var_2_2.angle = 0
					end
				end

				arg_2_2.difficulty_text.style.text.text_color[1] = 0

				local background_top = arg_2_2.background_top
				local background_glow = arg_2_2.background_glow
				local background_bottom = arg_2_2.background_bottom
				local background_center = arg_2_2.background_center

				arg_2_0[background_center.scenegraph_id].size[2] = 0
				background_top.style.texture_id.color[1] = 0
				background_bottom.style.texture_id.color[1] = 0
				background_center.style.texture_id.color[1] = 255
				background_glow.style.texture_id.color[1] = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				return
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end
		},
		{
			name = "background_entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				if not arg_5_3.played_start_sound then
					arg_5_3.played_start_sound = true

					WwiseWorld.trigger_event(arg_5_3.wwise_world, "hud_difficulty_increased_start")
				end
			end,
			update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				local easeOutCubic = math.easeOutCubic(arg_6_3)
				local background_top = arg_6_2.background_top
				local local_position = self[background_top.scenegraph_id].local_position
				local background_bottom = arg_6_2.background_bottom
				local local_position_2 = self[background_bottom.scenegraph_id].local_position
				local num = 2000
				local num_2 = -2000

				local_position[2] = num - num * easeOutCubic
				local_position_2[2] = num_2 - num_2 * easeOutCubic

				local num_3 = 255 * arg_6_3

				background_top.style.texture_id.color[1] = num_3
				background_bottom.style.texture_id.color[1] = num_3
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end
		},
		{
			name = "background_expand",
			start_progress = 0.7,
			end_progress = 0.8,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				return
			end,
			update = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				-- function 9
				local easeInCubic = math.easeInCubic(arg_9_3)
				local local_position = self[arg_9_2.background_top.scenegraph_id].local_position
				local local_position_2 = self[arg_9_2.background_bottom.scenegraph_id].local_position
				local background_center = arg_9_2.background_center
				local scenegraph_id = background_center.scenegraph_id
				local size = self[scenegraph_id].size
				local size_2 = arg_9_1[scenegraph_id].size
				local uvs = background_center.content.texture_id.uvs
				local num = 0.5 * easeInCubic

				uvs[1][2] = num
				uvs[2][2] = 1 - num
				size[2] = size_2[2] * easeInCubic

				local num_2 = size_2[2] / 2

				local_position[2] = num_2 * easeInCubic
				local_position_2[2] = -(num_2 * easeInCubic)
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end
		}
	},
	explode_parts_5 = {
		{
			name = "explode_parts_3",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				local icons = arg_11_2.icons
				local tbl = {}

				for i, v in ipairs(icons) do
					local tbl_2 = {}

					for k = 1, 6 do
						tbl_2[k] = {
							x = Math.random_range(-150, 150),
							y = Math.random_range(-150, 150),
							alpha_fade_multiplier = Math.random_range(1, 2),
							angle = math.degrees_to_radians(Math.random_range(-90, 90))
						}
					end

					tbl[i] = tbl_2
				end

				arg_11_3.icons_end_values = tbl
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				-- function 12
				if not arg_12_4.played_explode_sound_1 then
					arg_12_4.played_explode_sound_1 = true

					WwiseWorld.trigger_event(arg_12_4.wwise_world, "hud_difficulty_increased_stone")
				end

				local flag

				flag = arg_12_3 ~= 1 or not 1 or math.catmullrom(arg_12_3, 8, 0, 1, -1)

				local easeOutCubic = math.easeOutCubic(arg_12_3)
				local icons = arg_12_2.icons
				local num = 0.5
				local num_2 = math.max(arg_12_3 - num, 0) / num
				local icons_end_values = arg_12_4.icons_end_values

				for i, v in ipairs(icons) do
					if i == 3 then
						local style = v.style
						local var_12_7 = icons_end_values[i]

						for k = 1, 6 do
							local var_12_8 = style["part_" .. k]
							local offset = var_12_8.offset
							local color = var_12_8.color
							local var_12_11 = var_12_7[k]
							local x = var_12_11.x
							local y = var_12_11.y
							local alpha_fade_multiplier = var_12_11.alpha_fade_multiplier
							local angle = var_12_11.angle

							offset[1] = x * easeOutCubic
							offset[2] = y * easeOutCubic
							color[1] = 255 - math.min(255 * (num_2 * alpha_fade_multiplier), 255)
							var_12_8.angle = angle * easeOutCubic
						end
					end
				end
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end
		},
		{
			name = "rumble_1",
			start_progress = 0,
			end_progress = 0.1,
			init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				return
			end,
			update = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				-- function 15
				local local_position = self.background.local_position
				local position = arg_15_1.background.position

				local_position[1] = position[1] + 10 - 10 * math.catmullrom(arg_15_3, 5, 1, 1, -1)
				local_position[2] = position[2] + 10 - 10 * math.catmullrom(arg_15_3, -1, 1, 1, 5)
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				return
			end
		},
		{
			name = "explode_parts_2_4",
			start_progress = 0.4,
			end_progress = 0.7,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				return
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				-- function 18
				if not arg_18_4.played_explode_sound_2 then
					arg_18_4.played_explode_sound_2 = true

					WwiseWorld.trigger_event(arg_18_4.wwise_world, "hud_difficulty_increased_stone")
				end

				local flag

				flag = arg_18_3 ~= 1 or not 1 or math.catmullrom(arg_18_3, 8, 0, 1, -1)

				local easeOutCubic = math.easeOutCubic(arg_18_3)
				local icons = arg_18_2.icons
				local num = 0.5
				local num_2 = math.max(arg_18_3 - num, 0) / num
				local icons_end_values = arg_18_4.icons_end_values

				for i, v in ipairs(icons) do
					if not (i == 2 or i ~= 4) then
						local style = v.style
						local var_18_7 = icons_end_values[i]

						for k = 1, 6 do
							local var_18_8 = style["part_" .. k]
							local offset = var_18_8.offset
							local color = var_18_8.color
							local var_18_11 = var_18_7[k]
							local x = var_18_11.x
							local y = var_18_11.y
							local alpha_fade_multiplier = var_18_11.alpha_fade_multiplier
							local angle = var_18_11.angle

							offset[1] = x * easeOutCubic
							offset[2] = y * easeOutCubic
							color[1] = 255 - math.min(255 * (num_2 * alpha_fade_multiplier), 255)
							var_18_8.angle = angle * easeOutCubic
						end
					end
				end
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end
		},
		{
			name = "rumble_2",
			start_progress = 0.4,
			end_progress = 0.5,
			init = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				return
			end,
			update = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				-- function 21
				local local_position = self.background.local_position
				local position = arg_21_1.background.position

				local_position[1] = position[1] + (10 - 10 * math.catmullrom(arg_21_3, -1, 1, 1, 5))
				local_position[2] = position[2] + (10 - 10 * math.catmullrom(arg_21_3, -5, 1, 1, 1))
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				return
			end
		},
		{
			name = "explode_parts_1_5",
			start_progress = 0.7,
			end_progress = 1,
			init = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				-- function 23
				return
			end,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				-- function 24
				if not arg_24_4.played_explode_sound_3 then
					arg_24_4.played_explode_sound_3 = true

					WwiseWorld.trigger_event(arg_24_4.wwise_world, "hud_difficulty_increased_stone")
				end

				local flag

				flag = arg_24_3 ~= 1 or not 1 or math.catmullrom(arg_24_3, 8, 0, 1, -1)

				local easeOutCubic = math.easeOutCubic(arg_24_3)
				local icons = arg_24_2.icons
				local num = 0.5
				local num_2 = math.max(arg_24_3 - num, 0) / num
				local icons_end_values = arg_24_4.icons_end_values

				for i, v in ipairs(icons) do
					local style = v.style
					local var_24_7 = icons_end_values[i]

					if not (i == 1 or i ~= 5) then
						for k = 1, 6 do
							local var_24_8 = style["part_" .. k]
							local offset = var_24_8.offset
							local color = var_24_8.color
							local var_24_11 = var_24_7[k]
							local x = var_24_11.x
							local y = var_24_11.y
							local alpha_fade_multiplier = var_24_11.alpha_fade_multiplier
							local angle = var_24_11.angle

							offset[1] = x * easeOutCubic
							offset[2] = y * easeOutCubic
							color[1] = 255 - math.min(255 * (num_2 * alpha_fade_multiplier), 255)
							var_24_8.angle = angle * easeOutCubic
						end
					end
				end
			end,
			on_complete = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				return
			end
		},
		{
			name = "rumble_3",
			start_progress = 0.7,
			end_progress = 0.8,
			init = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				return
			end,
			update = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				-- function 27
				local local_position = self.background.local_position
				local position = arg_27_1.background.position

				local_position[1] = position[1] + 10 - 10 * math.catmullrom(arg_27_3, 5, 1, 1, 1)
				local_position[2] = position[2] + 10 - 10 * math.catmullrom(arg_27_3, 1, 1, 1, 5)
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				return
			end
		},
		{
			name = "fade_in_title_text",
			start_progress = 0.9,
			end_progress = 1.2,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				return
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				-- function 30
				local easeOutCubic = math.easeOutCubic(arg_30_3)
				local text = arg_30_2.difficulty_title_text.style.text

				text.text_color[1] = 255 * easeOutCubic
				text.font_size = 28 * math.catmullrom(math.easeOutCubic(arg_30_3), -0.5, 1, 1, -0.5)
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				return
			end
		},
		{
			name = "fade_in_text",
			start_progress = 1,
			end_progress = 1.3,
			init = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				-- function 32
				return
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				-- function 33
				if not arg_33_4.played_text_reveal_sound then
					arg_33_4.played_text_reveal_sound = true

					WwiseWorld.trigger_event(arg_33_4.wwise_world, "hud_text_reveal")
				end

				local easeOutCubic = math.easeOutCubic(arg_33_3)
				local text = arg_33_2.difficulty_text.style.text

				text.text_color[1] = 255 * easeOutCubic
				text.font_size = 40 * math.catmullrom(math.easeOutCubic(arg_33_3), -0.5, 1, 1, -0.5)
			end,
			on_complete = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				return
			end
		},
		{
			name = "fade_in_glow",
			start_progress = 0.75,
			end_progress = 1.1,
			init = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				-- function 35
				return
			end,
			update = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				-- function 36
				local easeInCubic = math.easeInCubic(arg_36_3)

				arg_36_2.background_glow.style.texture_id.color[1] = 255 * easeInCubic
			end,
			on_complete = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
				return
			end
		},
		{
			name = "fade_out_glow",
			start_progress = 2.5,
			end_progress = 3.1,
			init = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				-- function 38
				return
			end,
			update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				-- function 39
				local num = 255 - 255 * arg_39_3

				arg_39_2.background_glow.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				return
			end
		},
		{
			name = "fade_out_background",
			start_progress = 2.8,
			end_progress = 3.3,
			init = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				-- function 41
				return
			end,
			update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
				-- function 42
				local background_top = arg_42_2.background_top
				local background_center = arg_42_2.background_center
				local background_bottom = arg_42_2.background_bottom
				local num = 255 - 255 * arg_42_3

				background_top.style.texture_id.color[1] = num
				background_bottom.style.texture_id.color[1] = num
				background_center.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				-- function 43
				return
			end
		},
		{
			name = "fade_out_icons",
			start_progress = 2.8,
			end_progress = 3.3,
			init = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				-- function 44
				return
			end,
			update = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
				-- function 45
				local num = 255 - 255 * arg_45_3
				local icons = arg_45_2.icons

				for i, v in ipairs(icons) do
					v.style.icon.color[1] = num
				end
			end,
			on_complete = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				-- function 46
				return
			end
		},
		{
			name = "fade_out_title_text",
			start_progress = 3,
			end_progress = 3.5,
			init = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
				-- function 47
				return
			end,
			update = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
				-- function 48
				local easeOutCubic = math.easeOutCubic(arg_48_3)

				arg_48_2.difficulty_title_text.style.text.text_color[1] = 255 - 255 * easeOutCubic
			end,
			on_complete = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
				-- function 49
				return
			end
		},
		{
			name = "fade_out_text",
			start_progress = 3,
			end_progress = 4,
			init = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
				-- function 50
				return
			end,
			update = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
				-- function 51
				local easeOutCubic = math.easeOutCubic(arg_51_3)

				arg_51_2.difficulty_text.style.text.text_color[1] = 255 - 255 * easeOutCubic
			end,
			on_complete = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
				-- function 52
				return
			end
		}
	},
	explode_parts_4 = {
		{
			name = "explode_parts_2_3",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
				-- function 53
				local icons = arg_53_2.icons
				local tbl = {}

				for i, v in ipairs(icons) do
					local tbl_2 = {}

					for k = 1, 6 do
						tbl_2[k] = {
							x = Math.random_range(-150, 150),
							y = Math.random_range(-150, 150),
							alpha_fade_multiplier = Math.random_range(1, 2),
							angle = math.degrees_to_radians(Math.random_range(-90, 90))
						}
					end

					tbl[i] = tbl_2
				end

				arg_53_3.icons_end_values = tbl
			end,
			update = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
				-- function 54
				if not arg_54_4.played_explode_sound_1 then
					arg_54_4.played_explode_sound_1 = true

					WwiseWorld.trigger_event(arg_54_4.wwise_world, "hud_difficulty_increased_stone")
				end

				local flag

				flag = arg_54_3 ~= 1 or not 1 or math.catmullrom(arg_54_3, 8, 0, 1, -1)

				local easeOutCubic = math.easeOutCubic(arg_54_3)
				local icons = arg_54_2.icons
				local num = 0.5
				local num_2 = math.max(arg_54_3 - num, 0) / num
				local icons_end_values = arg_54_4.icons_end_values

				for i, v in ipairs(icons) do
					if not (i == 2 or i ~= 3) then
						local style = v.style
						local var_54_7 = icons_end_values[i]

						for k = 1, 6 do
							local var_54_8 = style["part_" .. k]
							local offset = var_54_8.offset
							local color = var_54_8.color
							local var_54_11 = var_54_7[k]
							local x = var_54_11.x
							local y = var_54_11.y
							local alpha_fade_multiplier = var_54_11.alpha_fade_multiplier
							local angle = var_54_11.angle

							offset[1] = x * easeOutCubic
							offset[2] = y * easeOutCubic
							color[1] = 255 - math.min(255 * (num_2 * alpha_fade_multiplier), 255)
							var_54_8.angle = angle * easeOutCubic
						end
					end
				end
			end,
			on_complete = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
				-- function 55
				return
			end
		},
		{
			name = "rumble_1",
			start_progress = 0,
			end_progress = 0.1,
			init = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
				-- function 56
				return
			end,
			update = function (self, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
				-- function 57
				local local_position = self.background.local_position
				local position = arg_57_1.background.position

				local_position[1] = position[1] + 10 - 10 * math.catmullrom(arg_57_3, 5, 1, 1, -1)
				local_position[2] = position[2] + 10 - 10 * math.catmullrom(arg_57_3, -1, 1, 1, 5)
			end,
			on_complete = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
				-- function 58
				return
			end
		},
		{
			name = "explode_parts_1_4",
			start_progress = 0.4,
			end_progress = 0.7,
			init = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3)
				-- function 59
				return
			end,
			update = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4)
				-- function 60
				if not arg_60_4.played_explode_sound_2 then
					arg_60_4.played_explode_sound_2 = true

					WwiseWorld.trigger_event(arg_60_4.wwise_world, "hud_difficulty_increased_stone")
				end

				local flag

				flag = arg_60_3 ~= 1 or not 1 or math.catmullrom(arg_60_3, 8, 0, 1, -1)

				local easeOutCubic = math.easeOutCubic(arg_60_3)
				local icons = arg_60_2.icons
				local num = 0.5
				local num_2 = math.max(arg_60_3 - num, 0) / num
				local icons_end_values = arg_60_4.icons_end_values

				for i, v in ipairs(icons) do
					if not (i == 1 or i ~= 4) then
						local style = v.style
						local var_60_7 = icons_end_values[i]

						for k = 1, 6 do
							local var_60_8 = style["part_" .. k]
							local offset = var_60_8.offset
							local color = var_60_8.color
							local var_60_11 = var_60_7[k]
							local x = var_60_11.x
							local y = var_60_11.y
							local alpha_fade_multiplier = var_60_11.alpha_fade_multiplier
							local angle = var_60_11.angle

							offset[1] = x * easeOutCubic
							offset[2] = y * easeOutCubic
							color[1] = 255 - math.min(255 * (num_2 * alpha_fade_multiplier), 255)
							var_60_8.angle = angle * easeOutCubic
						end
					end
				end
			end,
			on_complete = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
				-- function 61
				return
			end
		},
		{
			name = "rumble_2",
			start_progress = 0.4,
			end_progress = 0.5,
			init = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
				-- function 62
				return
			end,
			update = function (self, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
				-- function 63
				local local_position = self.background.local_position
				local position = arg_63_1.background.position

				local_position[1] = position[1] + (10 - 10 * math.catmullrom(arg_63_3, -1, 1, 1, 5))
				local_position[2] = position[2] + (10 - 10 * math.catmullrom(arg_63_3, -5, 1, 1, 1))
			end,
			on_complete = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
				-- function 64
				return
			end
		},
		{
			name = "fade_in_title_text",
			start_progress = 0.6,
			end_progress = 0.9,
			init = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
				-- function 65
				return
			end,
			update = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4)
				-- function 66
				local easeOutCubic = math.easeOutCubic(arg_66_3)
				local text = arg_66_2.difficulty_title_text.style.text

				text.text_color[1] = 255 * easeOutCubic
				text.font_size = 28 * math.catmullrom(math.easeOutCubic(arg_66_3), -0.5, 1, 1, -0.5)
			end,
			on_complete = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
				-- function 67
				return
			end
		},
		{
			name = "fade_in_text",
			start_progress = 0.7,
			end_progress = 1,
			init = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3)
				-- function 68
				return
			end,
			update = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
				-- function 69
				if not arg_69_4.played_text_reveal_sound then
					arg_69_4.played_text_reveal_sound = true

					WwiseWorld.trigger_event(arg_69_4.wwise_world, "hud_text_reveal")
				end

				local easeOutCubic = math.easeOutCubic(arg_69_3)
				local text = arg_69_2.difficulty_text.style.text

				text.text_color[1] = 255 * easeOutCubic
				text.font_size = 40 * math.catmullrom(math.easeOutCubic(arg_69_3), -0.5, 1, 1, -0.5)
			end,
			on_complete = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
				-- function 70
				return
			end
		},
		{
			name = "fade_in_glow",
			start_progress = 0.45,
			end_progress = 0.8,
			init = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
				-- function 71
				return
			end,
			update = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4)
				-- function 72
				local easeInCubic = math.easeInCubic(arg_72_3)

				arg_72_2.background_glow.style.texture_id.color[1] = 255 * easeInCubic
			end,
			on_complete = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
				-- function 73
				return
			end
		},
		{
			name = "fade_out_glow",
			start_progress = 2.2,
			end_progress = 2.8,
			init = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3)
				-- function 74
				return
			end,
			update = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3, arg_75_4)
				-- function 75
				local num = 255 - 255 * arg_75_3

				arg_75_2.background_glow.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
				-- function 76
				return
			end
		},
		{
			name = "fade_out_background",
			start_progress = 2.5,
			end_progress = 3,
			init = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3)
				-- function 77
				return
			end,
			update = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4)
				-- function 78
				local background_top = arg_78_2.background_top
				local background_center = arg_78_2.background_center
				local background_bottom = arg_78_2.background_bottom
				local num = 255 - 255 * arg_78_3

				background_top.style.texture_id.color[1] = num
				background_bottom.style.texture_id.color[1] = num
				background_center.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3)
				-- function 79
				return
			end
		},
		{
			name = "fade_out_icons",
			start_progress = 2.5,
			end_progress = 3,
			init = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3)
				-- function 80
				return
			end,
			update = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4)
				-- function 81
				local num = 255 - 255 * arg_81_3
				local icons = arg_81_2.icons

				for i, v in ipairs(icons) do
					v.style.icon.color[1] = num
				end
			end,
			on_complete = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3)
				-- function 82
				return
			end
		},
		{
			name = "fade_out_title_text",
			start_progress = 2.7,
			end_progress = 3.2,
			init = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3)
				-- function 83
				return
			end,
			update = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4)
				-- function 84
				local easeOutCubic = math.easeOutCubic(arg_84_3)

				arg_84_2.difficulty_title_text.style.text.text_color[1] = 255 - 255 * easeOutCubic
			end,
			on_complete = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
				-- function 85
				return
			end
		},
		{
			name = "fade_out_text",
			start_progress = 2.7,
			end_progress = 3.7,
			init = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3)
				-- function 86
				return
			end,
			update = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
				-- function 87
				local easeOutCubic = math.easeOutCubic(arg_87_3)

				arg_87_2.difficulty_text.style.text.text_color[1] = 255 - 255 * easeOutCubic
			end,
			on_complete = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3)
				-- function 88
				return
			end
		}
	}
}

return {
	animations = tbl_4,
	mission_names = mission_names,
	scenegraph_definition = tbl,
	widget_definitions = tbl_3
}
