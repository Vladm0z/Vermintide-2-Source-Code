-- chunkname: @scripts/ui/hud_ui/difficulty_unlock_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	root = {
		is_root = true,
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

local function var_0_3(arg_1_0, arg_1_1)
	local var_1_0 = "icon_root"
	local var_1_1 = "icon_" .. arg_1_0
	local var_1_2 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		parent = var_1_0,
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

	var_0_2[var_1_1] = var_1_2

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
		scenegraph_id = var_1_1
	}
end

local var_0_4 = {
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
local var_0_5 = {
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
	difficulty_icon_1 = var_0_3(1),
	difficulty_icon_2 = var_0_3(2),
	difficulty_icon_3 = var_0_3(3),
	difficulty_icon_4 = var_0_3(4),
	difficulty_icon_5 = var_0_3(5)
}
local var_0_6 = {
	presentation = {
		{
			name = "reset",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				local var_2_0 = arg_2_2.icons

				for iter_2_0, iter_2_1 in ipairs(var_2_0) do
					local var_2_1 = iter_2_1.style

					var_2_1.icon.color[1] = 255

					for iter_2_2 = 1, 6 do
						local var_2_2 = var_2_1["part_" .. iter_2_2]
						local var_2_3 = var_2_2.offset
						local var_2_4 = var_2_2.color

						var_2_3[1] = 0
						var_2_3[2] = 0
						var_2_4[1] = 255
						var_2_2.angle = 0
					end
				end

				arg_2_2.difficulty_text.style.text.text_color[1] = 0

				local var_2_5 = arg_2_2.background_top
				local var_2_6 = arg_2_2.background_glow
				local var_2_7 = arg_2_2.background_bottom
				local var_2_8 = arg_2_2.background_center

				arg_2_0[var_2_8.scenegraph_id].size[2] = 0
				var_2_5.style.texture_id.color[1] = 0
				var_2_7.style.texture_id.color[1] = 0
				var_2_8.style.texture_id.color[1] = 255
				var_2_6.style.texture_id.color[1] = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				return
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end
		},
		{
			name = "background_entry",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				if not arg_5_3.played_start_sound then
					arg_5_3.played_start_sound = true

					WwiseWorld.trigger_event(arg_5_3.wwise_world, "hud_difficulty_increased_start")
				end
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeOutCubic(arg_6_3)
				local var_6_1 = arg_6_2.background_top
				local var_6_2 = arg_6_0[var_6_1.scenegraph_id].local_position
				local var_6_3 = arg_6_2.background_bottom
				local var_6_4 = arg_6_0[var_6_3.scenegraph_id].local_position
				local var_6_5 = 2000
				local var_6_6 = -2000

				var_6_2[2] = var_6_5 - var_6_5 * var_6_0
				var_6_4[2] = var_6_6 - var_6_6 * var_6_0

				local var_6_7 = 255 * arg_6_3

				var_6_1.style.texture_id.color[1] = var_6_7
				var_6_3.style.texture_id.color[1] = var_6_7
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		},
		{
			name = "background_expand",
			start_progress = 0.7,
			end_progress = 0.8,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				return
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				local var_9_0 = math.easeInCubic(arg_9_3)
				local var_9_1 = arg_9_0[arg_9_2.background_top.scenegraph_id].local_position
				local var_9_2 = arg_9_0[arg_9_2.background_bottom.scenegraph_id].local_position
				local var_9_3 = arg_9_2.background_center
				local var_9_4 = var_9_3.scenegraph_id
				local var_9_5 = arg_9_0[var_9_4].size
				local var_9_6 = arg_9_1[var_9_4].size
				local var_9_7 = var_9_3.content.texture_id.uvs
				local var_9_8 = 0.5 * var_9_0

				var_9_7[1][2] = var_9_8
				var_9_7[2][2] = 1 - var_9_8
				var_9_5[2] = var_9_6[2] * var_9_0

				local var_9_9 = var_9_6[2] / 2

				var_9_1[2] = var_9_9 * var_9_0
				var_9_2[2] = -(var_9_9 * var_9_0)
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
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
				local var_11_0 = arg_11_2.icons
				local var_11_1 = {}

				for iter_11_0, iter_11_1 in ipairs(var_11_0) do
					local var_11_2 = {}

					for iter_11_2 = 1, 6 do
						var_11_2[iter_11_2] = {
							x = Math.random_range(-150, 150),
							y = Math.random_range(-150, 150),
							alpha_fade_multiplier = Math.random_range(1, 2),
							angle = math.degrees_to_radians(Math.random_range(-90, 90))
						}
					end

					var_11_1[iter_11_0] = var_11_2
				end

				arg_11_3.icons_end_values = var_11_1
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				if not arg_12_4.played_explode_sound_1 then
					arg_12_4.played_explode_sound_1 = true

					WwiseWorld.trigger_event(arg_12_4.wwise_world, "hud_difficulty_increased_stone")
				end

				local var_12_0

				var_12_0 = arg_12_3 == 1 and 1 or math.catmullrom(arg_12_3, 8, 0, 1, -1)

				local var_12_1 = math.easeOutCubic(arg_12_3)
				local var_12_2 = arg_12_2.icons
				local var_12_3 = 0.5
				local var_12_4 = math.max(arg_12_3 - var_12_3, 0) / var_12_3
				local var_12_5 = arg_12_4.icons_end_values

				for iter_12_0, iter_12_1 in ipairs(var_12_2) do
					if iter_12_0 == 3 then
						local var_12_6 = iter_12_1.style
						local var_12_7 = var_12_5[iter_12_0]

						for iter_12_2 = 1, 6 do
							local var_12_8 = var_12_6["part_" .. iter_12_2]
							local var_12_9 = var_12_8.offset
							local var_12_10 = var_12_8.color
							local var_12_11 = var_12_7[iter_12_2]
							local var_12_12 = var_12_11.x
							local var_12_13 = var_12_11.y
							local var_12_14 = var_12_11.alpha_fade_multiplier
							local var_12_15 = var_12_11.angle

							var_12_9[1] = var_12_12 * var_12_1
							var_12_9[2] = var_12_13 * var_12_1
							var_12_10[1] = 255 - math.min(255 * (var_12_4 * var_12_14), 255)
							var_12_8.angle = var_12_15 * var_12_1
						end
					end
				end
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		},
		{
			name = "rumble_1",
			start_progress = 0,
			end_progress = 0.1,
			init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				return
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				local var_15_0 = arg_15_0.background.local_position
				local var_15_1 = arg_15_1.background.position

				var_15_0[1] = var_15_1[1] + 10 - 10 * math.catmullrom(arg_15_3, 5, 1, 1, -1)
				var_15_0[2] = var_15_1[2] + 10 - 10 * math.catmullrom(arg_15_3, -1, 1, 1, 5)
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end
		},
		{
			name = "explode_parts_2_4",
			start_progress = 0.4,
			end_progress = 0.7,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				if not arg_18_4.played_explode_sound_2 then
					arg_18_4.played_explode_sound_2 = true

					WwiseWorld.trigger_event(arg_18_4.wwise_world, "hud_difficulty_increased_stone")
				end

				local var_18_0

				var_18_0 = arg_18_3 == 1 and 1 or math.catmullrom(arg_18_3, 8, 0, 1, -1)

				local var_18_1 = math.easeOutCubic(arg_18_3)
				local var_18_2 = arg_18_2.icons
				local var_18_3 = 0.5
				local var_18_4 = math.max(arg_18_3 - var_18_3, 0) / var_18_3
				local var_18_5 = arg_18_4.icons_end_values

				for iter_18_0, iter_18_1 in ipairs(var_18_2) do
					if iter_18_0 == 2 or iter_18_0 == 4 then
						local var_18_6 = iter_18_1.style
						local var_18_7 = var_18_5[iter_18_0]

						for iter_18_2 = 1, 6 do
							local var_18_8 = var_18_6["part_" .. iter_18_2]
							local var_18_9 = var_18_8.offset
							local var_18_10 = var_18_8.color
							local var_18_11 = var_18_7[iter_18_2]
							local var_18_12 = var_18_11.x
							local var_18_13 = var_18_11.y
							local var_18_14 = var_18_11.alpha_fade_multiplier
							local var_18_15 = var_18_11.angle

							var_18_9[1] = var_18_12 * var_18_1
							var_18_9[2] = var_18_13 * var_18_1
							var_18_10[1] = 255 - math.min(255 * (var_18_4 * var_18_14), 255)
							var_18_8.angle = var_18_15 * var_18_1
						end
					end
				end
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end
		},
		{
			name = "rumble_2",
			start_progress = 0.4,
			end_progress = 0.5,
			init = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end,
			update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				local var_21_0 = arg_21_0.background.local_position
				local var_21_1 = arg_21_1.background.position

				var_21_0[1] = var_21_1[1] + (10 - 10 * math.catmullrom(arg_21_3, -1, 1, 1, 5))
				var_21_0[2] = var_21_1[2] + (10 - 10 * math.catmullrom(arg_21_3, -5, 1, 1, 1))
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				return
			end
		},
		{
			name = "explode_parts_1_5",
			start_progress = 0.7,
			end_progress = 1,
			init = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				return
			end,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				if not arg_24_4.played_explode_sound_3 then
					arg_24_4.played_explode_sound_3 = true

					WwiseWorld.trigger_event(arg_24_4.wwise_world, "hud_difficulty_increased_stone")
				end

				local var_24_0

				var_24_0 = arg_24_3 == 1 and 1 or math.catmullrom(arg_24_3, 8, 0, 1, -1)

				local var_24_1 = math.easeOutCubic(arg_24_3)
				local var_24_2 = arg_24_2.icons
				local var_24_3 = 0.5
				local var_24_4 = math.max(arg_24_3 - var_24_3, 0) / var_24_3
				local var_24_5 = arg_24_4.icons_end_values

				for iter_24_0, iter_24_1 in ipairs(var_24_2) do
					local var_24_6 = iter_24_1.style
					local var_24_7 = var_24_5[iter_24_0]

					if iter_24_0 == 1 or iter_24_0 == 5 then
						for iter_24_2 = 1, 6 do
							local var_24_8 = var_24_6["part_" .. iter_24_2]
							local var_24_9 = var_24_8.offset
							local var_24_10 = var_24_8.color
							local var_24_11 = var_24_7[iter_24_2]
							local var_24_12 = var_24_11.x
							local var_24_13 = var_24_11.y
							local var_24_14 = var_24_11.alpha_fade_multiplier
							local var_24_15 = var_24_11.angle

							var_24_9[1] = var_24_12 * var_24_1
							var_24_9[2] = var_24_13 * var_24_1
							var_24_10[1] = 255 - math.min(255 * (var_24_4 * var_24_14), 255)
							var_24_8.angle = var_24_15 * var_24_1
						end
					end
				end
			end,
			on_complete = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				return
			end
		},
		{
			name = "rumble_3",
			start_progress = 0.7,
			end_progress = 0.8,
			init = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				return
			end,
			update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				local var_27_0 = arg_27_0.background.local_position
				local var_27_1 = arg_27_1.background.position

				var_27_0[1] = var_27_1[1] + 10 - 10 * math.catmullrom(arg_27_3, 5, 1, 1, 1)
				var_27_0[2] = var_27_1[2] + 10 - 10 * math.catmullrom(arg_27_3, 1, 1, 1, 5)
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				return
			end
		},
		{
			name = "fade_in_title_text",
			start_progress = 0.9,
			end_progress = 1.2,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				return
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				local var_30_0 = math.easeOutCubic(arg_30_3)
				local var_30_1 = arg_30_2.difficulty_title_text.style.text

				var_30_1.text_color[1] = 255 * var_30_0
				var_30_1.font_size = 28 * math.catmullrom(math.easeOutCubic(arg_30_3), -0.5, 1, 1, -0.5)
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end
		},
		{
			name = "fade_in_text",
			start_progress = 1,
			end_progress = 1.3,
			init = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				return
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				if not arg_33_4.played_text_reveal_sound then
					arg_33_4.played_text_reveal_sound = true

					WwiseWorld.trigger_event(arg_33_4.wwise_world, "hud_text_reveal")
				end

				local var_33_0 = math.easeOutCubic(arg_33_3)
				local var_33_1 = arg_33_2.difficulty_text.style.text

				var_33_1.text_color[1] = 255 * var_33_0
				var_33_1.font_size = 40 * math.catmullrom(math.easeOutCubic(arg_33_3), -0.5, 1, 1, -0.5)
			end,
			on_complete = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end
		},
		{
			name = "fade_in_glow",
			start_progress = 0.75,
			end_progress = 1.1,
			init = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				return
			end,
			update = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				local var_36_0 = math.easeInCubic(arg_36_3)

				arg_36_2.background_glow.style.texture_id.color[1] = 255 * var_36_0
			end,
			on_complete = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				return
			end
		},
		{
			name = "fade_out_glow",
			start_progress = 2.5,
			end_progress = 3.1,
			init = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				return
			end,
			update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				local var_39_0 = 255 - 255 * arg_39_3

				arg_39_2.background_glow.style.texture_id.color[1] = var_39_0
			end,
			on_complete = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				return
			end
		},
		{
			name = "fade_out_background",
			start_progress = 2.8,
			end_progress = 3.3,
			init = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				return
			end,
			update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
				local var_42_0 = arg_42_2.background_top
				local var_42_1 = arg_42_2.background_center
				local var_42_2 = arg_42_2.background_bottom
				local var_42_3 = 255 - 255 * arg_42_3

				var_42_0.style.texture_id.color[1] = var_42_3
				var_42_2.style.texture_id.color[1] = var_42_3
				var_42_1.style.texture_id.color[1] = var_42_3
			end,
			on_complete = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				return
			end
		},
		{
			name = "fade_out_icons",
			start_progress = 2.8,
			end_progress = 3.3,
			init = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				return
			end,
			update = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
				local var_45_0 = 255 - 255 * arg_45_3
				local var_45_1 = arg_45_2.icons

				for iter_45_0, iter_45_1 in ipairs(var_45_1) do
					iter_45_1.style.icon.color[1] = var_45_0
				end
			end,
			on_complete = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				return
			end
		},
		{
			name = "fade_out_title_text",
			start_progress = 3,
			end_progress = 3.5,
			init = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
				return
			end,
			update = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
				local var_48_0 = math.easeOutCubic(arg_48_3)

				arg_48_2.difficulty_title_text.style.text.text_color[1] = 255 - 255 * var_48_0
			end,
			on_complete = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
				return
			end
		},
		{
			name = "fade_out_text",
			start_progress = 3,
			end_progress = 4,
			init = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
				return
			end,
			update = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4)
				local var_51_0 = math.easeOutCubic(arg_51_3)

				arg_51_2.difficulty_text.style.text.text_color[1] = 255 - 255 * var_51_0
			end,
			on_complete = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
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
				local var_53_0 = arg_53_2.icons
				local var_53_1 = {}

				for iter_53_0, iter_53_1 in ipairs(var_53_0) do
					local var_53_2 = {}

					for iter_53_2 = 1, 6 do
						var_53_2[iter_53_2] = {
							x = Math.random_range(-150, 150),
							y = Math.random_range(-150, 150),
							alpha_fade_multiplier = Math.random_range(1, 2),
							angle = math.degrees_to_radians(Math.random_range(-90, 90))
						}
					end

					var_53_1[iter_53_0] = var_53_2
				end

				arg_53_3.icons_end_values = var_53_1
			end,
			update = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4)
				if not arg_54_4.played_explode_sound_1 then
					arg_54_4.played_explode_sound_1 = true

					WwiseWorld.trigger_event(arg_54_4.wwise_world, "hud_difficulty_increased_stone")
				end

				local var_54_0

				var_54_0 = arg_54_3 == 1 and 1 or math.catmullrom(arg_54_3, 8, 0, 1, -1)

				local var_54_1 = math.easeOutCubic(arg_54_3)
				local var_54_2 = arg_54_2.icons
				local var_54_3 = 0.5
				local var_54_4 = math.max(arg_54_3 - var_54_3, 0) / var_54_3
				local var_54_5 = arg_54_4.icons_end_values

				for iter_54_0, iter_54_1 in ipairs(var_54_2) do
					if iter_54_0 == 2 or iter_54_0 == 3 then
						local var_54_6 = iter_54_1.style
						local var_54_7 = var_54_5[iter_54_0]

						for iter_54_2 = 1, 6 do
							local var_54_8 = var_54_6["part_" .. iter_54_2]
							local var_54_9 = var_54_8.offset
							local var_54_10 = var_54_8.color
							local var_54_11 = var_54_7[iter_54_2]
							local var_54_12 = var_54_11.x
							local var_54_13 = var_54_11.y
							local var_54_14 = var_54_11.alpha_fade_multiplier
							local var_54_15 = var_54_11.angle

							var_54_9[1] = var_54_12 * var_54_1
							var_54_9[2] = var_54_13 * var_54_1
							var_54_10[1] = 255 - math.min(255 * (var_54_4 * var_54_14), 255)
							var_54_8.angle = var_54_15 * var_54_1
						end
					end
				end
			end,
			on_complete = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
				return
			end
		},
		{
			name = "rumble_1",
			start_progress = 0,
			end_progress = 0.1,
			init = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
				return
			end,
			update = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4)
				local var_57_0 = arg_57_0.background.local_position
				local var_57_1 = arg_57_1.background.position

				var_57_0[1] = var_57_1[1] + 10 - 10 * math.catmullrom(arg_57_3, 5, 1, 1, -1)
				var_57_0[2] = var_57_1[2] + 10 - 10 * math.catmullrom(arg_57_3, -1, 1, 1, 5)
			end,
			on_complete = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
				return
			end
		},
		{
			name = "explode_parts_1_4",
			start_progress = 0.4,
			end_progress = 0.7,
			init = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3)
				return
			end,
			update = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4)
				if not arg_60_4.played_explode_sound_2 then
					arg_60_4.played_explode_sound_2 = true

					WwiseWorld.trigger_event(arg_60_4.wwise_world, "hud_difficulty_increased_stone")
				end

				local var_60_0

				var_60_0 = arg_60_3 == 1 and 1 or math.catmullrom(arg_60_3, 8, 0, 1, -1)

				local var_60_1 = math.easeOutCubic(arg_60_3)
				local var_60_2 = arg_60_2.icons
				local var_60_3 = 0.5
				local var_60_4 = math.max(arg_60_3 - var_60_3, 0) / var_60_3
				local var_60_5 = arg_60_4.icons_end_values

				for iter_60_0, iter_60_1 in ipairs(var_60_2) do
					if iter_60_0 == 1 or iter_60_0 == 4 then
						local var_60_6 = iter_60_1.style
						local var_60_7 = var_60_5[iter_60_0]

						for iter_60_2 = 1, 6 do
							local var_60_8 = var_60_6["part_" .. iter_60_2]
							local var_60_9 = var_60_8.offset
							local var_60_10 = var_60_8.color
							local var_60_11 = var_60_7[iter_60_2]
							local var_60_12 = var_60_11.x
							local var_60_13 = var_60_11.y
							local var_60_14 = var_60_11.alpha_fade_multiplier
							local var_60_15 = var_60_11.angle

							var_60_9[1] = var_60_12 * var_60_1
							var_60_9[2] = var_60_13 * var_60_1
							var_60_10[1] = 255 - math.min(255 * (var_60_4 * var_60_14), 255)
							var_60_8.angle = var_60_15 * var_60_1
						end
					end
				end
			end,
			on_complete = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
				return
			end
		},
		{
			name = "rumble_2",
			start_progress = 0.4,
			end_progress = 0.5,
			init = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
				return
			end,
			update = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4)
				local var_63_0 = arg_63_0.background.local_position
				local var_63_1 = arg_63_1.background.position

				var_63_0[1] = var_63_1[1] + (10 - 10 * math.catmullrom(arg_63_3, -1, 1, 1, 5))
				var_63_0[2] = var_63_1[2] + (10 - 10 * math.catmullrom(arg_63_3, -5, 1, 1, 1))
			end,
			on_complete = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
				return
			end
		},
		{
			name = "fade_in_title_text",
			start_progress = 0.6,
			end_progress = 0.9,
			init = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
				return
			end,
			update = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4)
				local var_66_0 = math.easeOutCubic(arg_66_3)
				local var_66_1 = arg_66_2.difficulty_title_text.style.text

				var_66_1.text_color[1] = 255 * var_66_0
				var_66_1.font_size = 28 * math.catmullrom(math.easeOutCubic(arg_66_3), -0.5, 1, 1, -0.5)
			end,
			on_complete = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
				return
			end
		},
		{
			name = "fade_in_text",
			start_progress = 0.7,
			end_progress = 1,
			init = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3)
				return
			end,
			update = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
				if not arg_69_4.played_text_reveal_sound then
					arg_69_4.played_text_reveal_sound = true

					WwiseWorld.trigger_event(arg_69_4.wwise_world, "hud_text_reveal")
				end

				local var_69_0 = math.easeOutCubic(arg_69_3)
				local var_69_1 = arg_69_2.difficulty_text.style.text

				var_69_1.text_color[1] = 255 * var_69_0
				var_69_1.font_size = 40 * math.catmullrom(math.easeOutCubic(arg_69_3), -0.5, 1, 1, -0.5)
			end,
			on_complete = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
				return
			end
		},
		{
			name = "fade_in_glow",
			start_progress = 0.45,
			end_progress = 0.8,
			init = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
				return
			end,
			update = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3, arg_72_4)
				local var_72_0 = math.easeInCubic(arg_72_3)

				arg_72_2.background_glow.style.texture_id.color[1] = 255 * var_72_0
			end,
			on_complete = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
				return
			end
		},
		{
			name = "fade_out_glow",
			start_progress = 2.2,
			end_progress = 2.8,
			init = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3)
				return
			end,
			update = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3, arg_75_4)
				local var_75_0 = 255 - 255 * arg_75_3

				arg_75_2.background_glow.style.texture_id.color[1] = var_75_0
			end,
			on_complete = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
				return
			end
		},
		{
			name = "fade_out_background",
			start_progress = 2.5,
			end_progress = 3,
			init = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3)
				return
			end,
			update = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3, arg_78_4)
				local var_78_0 = arg_78_2.background_top
				local var_78_1 = arg_78_2.background_center
				local var_78_2 = arg_78_2.background_bottom
				local var_78_3 = 255 - 255 * arg_78_3

				var_78_0.style.texture_id.color[1] = var_78_3
				var_78_2.style.texture_id.color[1] = var_78_3
				var_78_1.style.texture_id.color[1] = var_78_3
			end,
			on_complete = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3)
				return
			end
		},
		{
			name = "fade_out_icons",
			start_progress = 2.5,
			end_progress = 3,
			init = function (arg_80_0, arg_80_1, arg_80_2, arg_80_3)
				return
			end,
			update = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4)
				local var_81_0 = 255 - 255 * arg_81_3
				local var_81_1 = arg_81_2.icons

				for iter_81_0, iter_81_1 in ipairs(var_81_1) do
					iter_81_1.style.icon.color[1] = var_81_0
				end
			end,
			on_complete = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3)
				return
			end
		},
		{
			name = "fade_out_title_text",
			start_progress = 2.7,
			end_progress = 3.2,
			init = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3)
				return
			end,
			update = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4)
				local var_84_0 = math.easeOutCubic(arg_84_3)

				arg_84_2.difficulty_title_text.style.text.text_color[1] = 255 - 255 * var_84_0
			end,
			on_complete = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
				return
			end
		},
		{
			name = "fade_out_text",
			start_progress = 2.7,
			end_progress = 3.7,
			init = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3)
				return
			end,
			update = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4)
				local var_87_0 = math.easeOutCubic(arg_87_3)

				arg_87_2.difficulty_text.style.text.text_color[1] = 255 - 255 * var_87_0
			end,
			on_complete = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3)
				return
			end
		}
	}
}

return {
	animations = var_0_6,
	mission_names = mission_names,
	scenegraph_definition = var_0_2,
	widget_definitions = var_0_5
}
