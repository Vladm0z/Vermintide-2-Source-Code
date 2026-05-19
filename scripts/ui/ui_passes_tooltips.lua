-- chunkname: @scripts/ui/ui_passes_tooltips.lua

UITooltipPasses = UITooltipPasses or {}

local var_0_0 = UIRenderer
local var_0_1 = var_0_0.draw_texture
local var_0_2 = var_0_0.draw_texture_uv
local var_0_3 = 994
local var_0_4 = 1.4
local var_0_5 = "???"

local function var_0_6(arg_1_0)
	if not IS_WINDOWS then
		return math.floor(arg_1_0 * var_0_4)
	end

	return arg_1_0
end

UITooltipPasses = {
	background = {
		setup_data = function()
			return {
				frame_margin = 10,
				frame_name = "item_tooltip_frame_01",
				background_color = {
					255,
					3,
					3,
					3
				},
				frame_color = {
					255,
					255,
					255,
					255
				}
			}
		end,
		draw = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9, arg_3_10, arg_3_11, arg_3_12)
			local var_3_0 = 255 * arg_3_4.alpha_multiplier
			local var_3_1 = arg_3_4.start_layer or var_0_3
			local var_3_2 = arg_3_0.frame_name
			local var_3_3 = UIFrameSettings[var_3_2]
			local var_3_4 = var_3_3.texture_sizes.horizontal[2]

			if arg_3_1 then
				if arg_3_2 then
					arg_3_9[2] = arg_3_9[2] - arg_3_10[2] - var_3_4 * 2
				end

				arg_3_10[2] = arg_3_10[2] + var_3_4 * 2
				arg_3_9[3] = var_3_1

				local var_3_5 = arg_3_0.background_color

				var_3_5[1] = var_3_0

				var_0_0.draw_rect(arg_3_3, arg_3_9, arg_3_10, var_3_5)

				arg_3_9[3] = var_3_1 + 5

				local var_3_6 = arg_3_0.frame_color

				var_3_6[1] = var_3_0

				var_0_0.draw_texture_frame(arg_3_3, arg_3_9, arg_3_10, var_3_3.texture, var_3_3.texture_size, var_3_3.texture_sizes, var_3_6)
			end

			return var_3_4 * 2
		end
	},
	item_background = {
		setup_data = function()
			local var_4_0 = "item_tooltip_frame_01"
			local var_4_1 = UIFrameSettings[var_4_0].texture_sizes.horizontal[2]

			return {
				background_texture = "item_tooltip_background",
				frame_name = var_4_0,
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
				background_texture_size = {
					300,
					300
				},
				background_color = {
					255,
					255,
					255,
					255
				},
				frame_color = {
					255,
					255,
					255,
					255
				},
				frame_margin = var_4_1 * 2
			}
		end,
		draw = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13)
			local var_5_0 = 255 * arg_5_4.alpha_multiplier
			local var_5_1 = arg_5_4.start_layer or var_0_3
			local var_5_2 = arg_5_0.frame_name
			local var_5_3 = UIFrameSettings[var_5_2]
			local var_5_4 = var_5_3.texture_sizes.horizontal[2]

			if arg_5_1 then
				local var_5_5 = arg_5_13.data
				local var_5_6 = arg_5_13.rarity or var_5_5.rarity
				local var_5_7 = Colors.get_table(var_5_6)

				arg_5_9[2] = arg_5_9[2] - arg_5_10[2] - var_5_4 * 2
				arg_5_10[2] = arg_5_10[2] + var_5_4 * 2 - 2
				arg_5_9[3] = var_5_1

				local var_5_8 = arg_5_0.background_texture
				local var_5_9 = arg_5_0.background_texture_size

				var_5_9[1] = arg_5_10[1]

				local var_5_10 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_5_8).size
				local var_5_11 = arg_5_0.uvs

				var_5_11[2][1] = math.min(arg_5_10[1] / var_5_10[1], 1)
				var_5_11[2][2] = math.min(arg_5_10[2] / var_5_10[2], 1)

				local var_5_12 = arg_5_0.background_color

				var_0_0.draw_tiled_texture(arg_5_3, var_5_8, arg_5_9, arg_5_10, var_5_9, var_5_12)

				arg_5_10[2] = arg_5_10[2] + 2
				arg_5_9[3] = var_5_1 + 5

				local var_5_13 = arg_5_0.frame_color

				var_5_13[1] = var_5_0

				var_0_0.draw_texture_frame(arg_5_3, arg_5_9, arg_5_10, var_5_3.texture, var_5_3.texture_size, var_5_3.texture_sizes, var_5_13)
			end

			return var_5_4 * 2
		end
	},
	console_item_background = {
		setup_data = function()
			local var_6_0 = "frame_outer_fade_02"

			return {
				background_texture = "item_tooltip_background",
				frame_name = var_6_0,
				color = table.clone(UISettings.console_menu_rect_color)
			}
		end,
		draw = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9, arg_7_10, arg_7_11, arg_7_12, arg_7_13)
			local var_7_0 = 210 * arg_7_4.alpha_multiplier
			local var_7_1 = arg_7_4.start_layer or var_0_3
			local var_7_2 = arg_7_0.frame_name
			local var_7_3 = UIFrameSettings[var_7_2]
			local var_7_4 = var_7_3.texture_sizes.horizontal[2]

			if arg_7_1 then
				arg_7_9[3] = var_7_1

				local var_7_5 = arg_7_0.color

				var_7_5[1] = var_7_0

				var_0_0.draw_rect(arg_7_3, arg_7_9, arg_7_10, var_7_5)

				local var_7_6 = var_7_4 * 2

				arg_7_10[1] = arg_7_10[1] + var_7_6
				arg_7_10[2] = arg_7_10[2] + var_7_6
				arg_7_9[1] = arg_7_9[1] - var_7_4
				arg_7_9[2] = arg_7_9[2] - var_7_4
				arg_7_9[3] = var_7_1 + 5

				var_0_0.draw_texture_frame(arg_7_3, arg_7_9, arg_7_10, var_7_3.texture, var_7_3.texture_size, var_7_3.texture_sizes, var_7_5)
			end

			return var_7_4 * 2
		end
	},
	craft_item_background = {
		setup_data = function()
			local var_8_0 = "menu_frame_15"
			local var_8_1 = UIFrameSettings[var_8_0].texture_sizes.horizontal[2]

			return {
				background_texture = "menu_frame_bg_06",
				frame_name = var_8_0,
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
				background_texture_size = {
					300,
					300
				},
				background_color = {
					255,
					255,
					255,
					255
				},
				frame_color = {
					255,
					255,
					255,
					255
				},
				frame_margin = var_8_1 * 2
			}
		end,
		draw = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_11, arg_9_12, arg_9_13)
			local var_9_0 = 255 * arg_9_4.alpha_multiplier
			local var_9_1 = arg_9_4.start_layer or var_0_3
			local var_9_2 = arg_9_0.frame_name
			local var_9_3 = UIFrameSettings[var_9_2]
			local var_9_4 = var_9_3.texture_sizes.horizontal[2]
			local var_9_5 = 0

			if arg_9_1 then
				local var_9_6 = arg_9_13.data
				local var_9_7 = arg_9_13.rarity or var_9_6.rarity
				local var_9_8 = Colors.get_table(var_9_7)

				arg_9_9[2] = arg_9_9[2] + var_9_4
				arg_9_10[2] = arg_9_10[2] + var_9_4 + var_9_5
				arg_9_9[3] = var_9_1 - 2

				local var_9_9 = arg_9_0.background_texture
				local var_9_10 = arg_9_0.background_texture_size
				local var_9_11 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_9_9).size
				local var_9_12 = arg_9_0.uvs

				var_9_12[2][1] = math.min(arg_9_10[1] / var_9_11[1], 1)
				var_9_12[2][2] = math.min(arg_9_10[2] / var_9_11[2], 1)

				local var_9_13 = arg_9_0.background_color

				var_0_0.draw_tiled_texture(arg_9_3, var_9_9, arg_9_9, arg_9_10, var_9_10, var_9_13)

				arg_9_10[2] = arg_9_10[2]
				arg_9_9[3] = var_9_1 + 5

				local var_9_14 = arg_9_0.frame_color

				var_9_14[1] = var_9_0

				var_0_0.draw_texture_frame(arg_9_3, arg_9_9, arg_9_10, var_9_3.texture, var_9_3.texture_size, var_9_3.texture_sizes, var_9_14)
			end

			return 0
		end
	},
	craft_item_new_frame = {
		setup_data = function()
			local var_10_0 = "frame_outer_glow_01"
			local var_10_1 = UIFrameSettings[var_10_0].texture_sizes.horizontal[2]

			return {
				frame_name = var_10_0,
				frame_color = {
					255,
					255,
					255,
					255
				},
				frame_margin = var_10_1 * 2
			}
		end,
		draw = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13)
			local var_11_0 = arg_11_4.alpha_multiplier
			local var_11_1 = (55 + 200 * (0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5)) * var_11_0

			if not arg_11_4.start_layer then
				local var_11_2 = var_0_3
			end

			local var_11_3 = arg_11_0.frame_name
			local var_11_4 = UIFrameSettings[var_11_3]
			local var_11_5 = var_11_4.texture_sizes.horizontal[2]

			if arg_11_1 then
				local var_11_6 = arg_11_13.data
				local var_11_7 = arg_11_13.rarity or var_11_6.rarity
				local var_11_8 = Colors.get_table(var_11_7)

				arg_11_9[1] = arg_11_9[1] - var_11_5
				arg_11_9[2] = arg_11_9[2] - var_11_5
				arg_11_10[1] = arg_11_10[1] + var_11_5 * 2
				arg_11_10[2] = arg_11_10[2] + var_11_5 * 2

				local var_11_9 = arg_11_0.frame_color

				var_11_9[1] = var_11_1

				var_0_0.draw_texture_frame(arg_11_3, arg_11_9, arg_11_10, var_11_4.texture, var_11_4.texture_size, var_11_4.texture_sizes, var_11_9)
			end

			return var_11_5 * 2
		end
	},
	craft_item_reward_title = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {
					0,
					50
				},
				background_size = {
					0,
					50
				},
				texture_size = {
					264,
					32
				},
				texture_color = {
					255,
					255,
					255,
					255
				},
				header_glow_size = {
					0,
					80
				},
				content = {
					texture = "divider_01_top",
					text = Localize("hero_view_crafting_result")
				},
				style = {
					title_text = {
						vertical_alignment = "center",
						upper_case = true,
						word_wrap = true,
						horizontal_alignment = "center",
						font_type = "hell_shark_header",
						font_size = var_0_6(36),
						text_color = Colors.get_color_table_with_alpha("font_title", 255),
						offset = {
							0,
							0,
							0
						}
					},
					title_text_shadow = {
						vertical_alignment = "center",
						upper_case = true,
						word_wrap = true,
						horizontal_alignment = "center",
						font_type = "hell_shark_header",
						font_size = var_0_6(36),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9, arg_13_10, arg_13_11, arg_13_12, arg_13_13)
			local var_13_0 = 255 * arg_13_4.alpha_multiplier
			local var_13_1 = arg_13_4.start_layer or var_0_3
			local var_13_2 = arg_13_0.frame_margin or 0
			local var_13_3 = arg_13_13.data
			local var_13_4 = arg_13_13.rarity or var_13_3.rarity
			local var_13_5 = Colors.get_table(var_13_4)
			local var_13_6 = arg_13_0.style
			local var_13_7 = arg_13_0.content
			local var_13_8 = arg_13_9[1]
			local var_13_9 = arg_13_9[2]
			local var_13_10 = arg_13_9[3]
			local var_13_11 = var_13_7.text
			local var_13_12 = var_13_6.title_text
			local var_13_13 = var_13_6.title_text_shadow
			local var_13_14 = arg_13_0.text_pass_data
			local var_13_15 = arg_13_0.text_size

			var_13_15[1] = arg_13_10[1] - var_13_2 * 2
			var_13_15[2] = 0
			var_13_15[2], var_13_15[1] = UIUtils.get_text_height(arg_13_3, var_13_15, var_13_12, var_13_11), arg_13_10[1]

			local var_13_16 = arg_13_0.texture_color
			local var_13_17 = arg_13_0.texture_size

			if arg_13_1 then
				arg_13_9[2] = arg_13_9[2] + arg_13_10[2] - (80 + var_13_17[2])
				arg_13_9[3] = var_13_1 + 3

				local var_13_18 = arg_13_9[1]
				local var_13_19 = arg_13_9[2]

				var_13_16[1] = var_13_0
				arg_13_9[1] = var_13_8 + arg_13_10[1] / 2 - var_13_17[1] / 2

				local var_13_20 = var_13_7.texture

				var_0_0.draw_texture(arg_13_3, var_13_20, arg_13_9, var_13_17, var_13_16)

				local var_13_21 = 30

				arg_13_9[1] = var_13_18 + var_13_12.offset[1]
				arg_13_9[2] = var_13_19 + var_13_21 + var_13_12.offset[2]
				arg_13_9[3] = var_13_1 + 6 + var_13_12.offset[3]
				var_13_12.text_color[1] = var_13_0
				var_13_13.text_color[1] = var_13_0

				UIPasses.text.draw(arg_13_3, var_13_14, arg_13_5, arg_13_6, var_13_12, var_13_7, arg_13_9, var_13_15, arg_13_11, arg_13_12)

				arg_13_9[1] = var_13_18 + var_13_13.offset[1]
				arg_13_9[2] = var_13_19 + var_13_21 + var_13_13.offset[2]
				arg_13_9[3] = var_13_1 + 6 + var_13_13.offset[3]

				UIPasses.text.draw(arg_13_3, var_13_14, arg_13_5, arg_13_6, var_13_13, var_13_7, arg_13_9, var_13_15, arg_13_11, arg_13_12)
			end

			arg_13_9[1] = var_13_8
			arg_13_9[2] = var_13_9
			arg_13_9[3] = var_13_10

			return 0
		end
	},
	weapon_stats = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				text_pass_data = {},
				text_size = {},
				content = {
					slot_star = {
						"stats_star",
						"stats_star",
						"stats_star",
						"stats_star",
						"stats_star"
					},
					left_star = {
						"stats_star_left",
						"stats_star_left",
						"stats_star_left",
						"stats_star_left",
						"stats_star_left"
					},
					right_star = {
						"stats_star_right",
						"stats_star_right",
						"stats_star_right",
						"stats_star_right",
						"stats_star_right"
					}
				},
				style = {
					attack_stars = {
						direction = 1,
						axis = 1,
						draw_count = 0,
						texture_size = {
							20,
							20
						},
						spacing = {
							2,
							0
						},
						color = {
							255,
							255,
							255,
							255
						},
						slot_color = {
							200,
							50,
							50,
							50
						},
						offset = {
							0,
							0,
							0
						}
					},
					stat_title = {
						vertical_alignment = "top",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					title_1 = {
						text = "item_compare_attack_title_light",
						word_wrap = true,
						vertical_alignment = "bottom",
						horizontal_alignment = "left",
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					title_2 = {
						text = "item_compare_attack_title_heavy",
						word_wrap = true,
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					}
				}
			}
		end,
		draw = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9, arg_15_10, arg_15_11, arg_15_12, arg_15_13)
			local var_15_0 = 255 * arg_15_4.alpha_multiplier
			local var_15_1 = arg_15_4.start_layer or var_0_3
			local var_15_2 = arg_15_0.frame_margin or 0
			local var_15_3 = arg_15_13.data
			local var_15_4 = var_15_3.slot_type

			if not (var_15_4 == "melee" or var_15_4 == "ranged") then
				return 0
			end

			local var_15_5 = arg_15_13.backend_id
			local var_15_6

			if not arg_15_0.stats_data then
				var_15_6 = ItemHelper.retrieve_weapon_item_statistics(var_15_3, var_15_5)
				arg_15_0.stats_data = var_15_6
			else
				var_15_6 = arg_15_0.stats_data
			end

			local var_15_7 = arg_15_0.style
			local var_15_8 = arg_15_0.content
			local var_15_9 = arg_15_9[1]
			local var_15_10 = arg_15_9[2]
			local var_15_11 = arg_15_9[3]
			local var_15_12 = var_15_7.attack_stars.texture_size
			local var_15_13 = var_15_12[1]
			local var_15_14 = var_15_12[2]
			local var_15_15 = #var_15_6
			local var_15_16 = var_15_13 * 5
			local var_15_17 = var_15_14 * var_15_15
			local var_15_18 = var_15_2

			if arg_15_2 then
				arg_15_9[2] = arg_15_9[2] - var_15_2 * 2
			else
				arg_15_9[2] = arg_15_9[2] + var_15_17
			end

			arg_15_9[3] = var_15_1 + 2

			if arg_15_1 then
				for iter_15_0 = 1, 2 do
					local var_15_19 = "title_" .. iter_15_0
					local var_15_20 = var_15_7[var_15_19]
					local var_15_21 = arg_15_0.text_size

					var_15_21[1] = arg_15_10[1]
					var_15_21[2] = var_15_14

					local var_15_22 = arg_15_0.text_pass_data

					var_15_22.text_id = var_15_19

					local var_15_23 = Localize(var_15_20.text)

					var_15_8[var_15_19] = var_15_23

					local var_15_24 = UIUtils.get_text_height(arg_15_3, var_15_21, var_15_20, var_15_23)

					if iter_15_0 == 2 then
						arg_15_9[1] = var_15_9 - var_15_2 + var_15_2 / 4
					else
						arg_15_9[1] = var_15_9 + var_15_2
					end

					local var_15_25 = UIUtils.get_text_height(arg_15_3, var_15_21, var_15_20, var_15_23)

					if iter_15_0 == 1 then
						var_15_18 = var_15_18 + var_15_25
						arg_15_9[2] = arg_15_9[2] - var_15_25
					end

					var_15_20.text_color[1] = var_15_0

					UIPasses.text.draw(arg_15_3, var_15_22, arg_15_5, arg_15_6, var_15_20, var_15_8, arg_15_9, var_15_21, arg_15_11, arg_15_12)

					if iter_15_0 == 2 then
						arg_15_9[2] = arg_15_9[2] - var_15_25
					end
				end
			end

			arg_15_9[1] = var_15_9

			for iter_15_1, iter_15_2 in ipairs(var_15_6) do
				for iter_15_3, iter_15_4 in ipairs(iter_15_2) do
					local var_15_26 = iter_15_4.title or "n/a"
					local var_15_27 = iter_15_4.value or 0
					local var_15_28 = iter_15_4.key

					if iter_15_3 == 1 then
						arg_15_9[1] = var_15_9 + var_15_2 / 2

						local var_15_29 = "stat_title"
						local var_15_30 = var_15_7[var_15_29]
						local var_15_31 = arg_15_0.text_size

						var_15_31[1] = arg_15_10[1] - var_15_2
						var_15_31[2] = var_15_14

						local var_15_32 = arg_15_0.text_pass_data

						var_15_32.text_id = var_15_29
						var_15_8[var_15_29] = var_15_26

						local var_15_33 = UIUtils.get_text_height(arg_15_3, var_15_31, var_15_30, var_15_26)

						if arg_15_1 then
							var_15_30.text_color[1] = var_15_0

							UIPasses.text.draw(arg_15_3, var_15_32, arg_15_5, arg_15_6, var_15_30, var_15_8, arg_15_9, var_15_31, arg_15_11, arg_15_12)
						end
					end

					if iter_15_3 == 1 then
						arg_15_9[1] = var_15_9 + var_15_2
					else
						arg_15_9[1] = var_15_9 + arg_15_10[1] - var_15_16 - var_15_13 - var_15_2 / 4
					end

					local var_15_34 = math.round(var_15_27 * 10)
					local var_15_35 = 0
					local var_15_36 = 0

					for iter_15_5 = 1, var_15_34 do
						if iter_15_5 % 2 == 1 then
							var_15_35 = var_15_35 + 1
						else
							var_15_36 = var_15_36 + 1
						end
					end

					local var_15_37 = var_15_7.attack_stars

					if arg_15_1 then
						for iter_15_6 = 1, 2 do
							local var_15_38
							local var_15_39 = 0

							if iter_15_6 == 1 then
								var_15_38 = "left_star"
								var_15_39 = var_15_35
							else
								var_15_38 = "right_star"
								var_15_39 = var_15_36
							end

							local var_15_40 = var_15_37.texture_size
							local var_15_41 = var_15_37.axis
							local var_15_42 = var_15_37.spacing
							local var_15_43 = var_15_37.direction
							local var_15_44 = var_15_37.texture_colors
							local var_15_45 = var_15_37.color

							var_15_45[1] = var_15_0

							if var_15_44 then
								for iter_15_7 = 1, #var_15_44 do
									var_15_44[iter_15_7][1] = var_15_0
								end
							end

							var_0_0.draw_multi_texture(arg_15_3, var_15_8[var_15_38], arg_15_9, var_15_40, nil, nil, nil, var_15_41, var_15_42, var_15_43, var_15_39, var_15_44, var_15_45, nil, nil, nil)

							if iter_15_6 == 1 then
								local var_15_46 = var_15_37.slot_color

								var_15_46[1] = var_15_0
								arg_15_9[3] = arg_15_9[3] - 1

								var_0_0.draw_multi_texture(arg_15_3, var_15_8.slot_star, arg_15_9, var_15_40, nil, nil, nil, var_15_41, var_15_42, var_15_43, 5, nil, var_15_46, nil, nil, nil)

								arg_15_9[3] = arg_15_9[3] + 1
							end
						end
					end
				end

				var_15_18 = var_15_18 + var_15_14
				arg_15_9[2] = arg_15_9[2] - var_15_14
			end

			arg_15_9[2] = arg_15_9[2] + var_15_18 + var_15_14
			arg_15_9[1] = var_15_9
			arg_15_9[2] = var_15_10
			arg_15_9[3] = var_15_11

			return var_15_18
		end
	},
	old_keywords = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				text_pass_data = {},
				text_size = {},
				entry_texture_size = {
					20,
					20
				},
				entry_texture_pass_data = {},
				entry_texture_pass_definition = {
					texture_id = "entry_texture",
					style_id = "entry_texture"
				},
				content = {
					entry_texture = "stats_icon_yes"
				},
				style = {
					text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(24),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					entry_texture = {
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
					}
				}
			}
		end,
		draw = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10, arg_17_11, arg_17_12, arg_17_13)
			local var_17_0 = 255 * arg_17_4.alpha_multiplier
			local var_17_1 = arg_17_4.start_layer or var_0_3
			local var_17_2 = 20
			local var_17_3 = arg_17_0.frame_margin or 0
			local var_17_4 = arg_17_13.backend_id
			local var_17_5 = arg_17_13.data
			local var_17_6 = var_17_5.slot_type

			if not (var_17_6 == "melee" or var_17_6 == "ranged") then
				return 0
			end

			local var_17_7 = BackendUtils.get_item_template(var_17_5, var_17_4).tooltip_keywords
			local var_17_8 = arg_17_0.style
			local var_17_9 = arg_17_0.content
			local var_17_10 = arg_17_9[1]
			local var_17_11 = arg_17_9[2]
			local var_17_12 = arg_17_9[3]
			local var_17_13 = 0
			local var_17_14 = arg_17_0.entry_texture_size

			arg_17_9[3] = var_17_1 + 2
			arg_17_9[2] = arg_17_9[2] + 100 + var_17_2
			arg_17_9[1] = arg_17_9[1] + var_17_3 + 100 + var_17_14[1]

			local var_17_15 = ipairs

			arg_17_0.text_size[1] = arg_17_10[1] - (var_17_3 * 2 + 100) - var_17_14[1]

			if var_17_7 then
				for iter_17_0, iter_17_1 in var_17_15(var_17_7) do
					local var_17_16 = "keyword_title_" .. iter_17_0
					local var_17_17 = var_17_8.text
					local var_17_18 = arg_17_0.text_pass_data

					var_17_18.text_id = var_17_16

					local var_17_19 = Localize(iter_17_1)
					local var_17_20 = arg_17_0.text_size

					var_17_20[2] = 0

					local var_17_21 = UIUtils.get_text_height(arg_17_3, var_17_20, var_17_17, var_17_19)

					var_17_20[2] = var_17_21
					arg_17_9[2] = arg_17_9[2] - var_17_21

					local var_17_22 = arg_17_9[2]

					var_17_9[var_17_16] = var_17_19

					if arg_17_1 then
						local var_17_23 = arg_17_0.entry_texture_size
						local var_17_24 = arg_17_0.style.entry_texture
						local var_17_25 = arg_17_0.entry_texture_pass_data
						local var_17_26 = arg_17_0.entry_texture_pass_definition

						arg_17_9[1] = arg_17_9[1] - var_17_23[1]
						arg_17_9[2] = arg_17_9[2] + var_17_21 / 2 - var_17_23[2] / 2
						var_17_24.color[1] = var_17_0

						UIPasses.texture.draw(arg_17_3, var_17_25, arg_17_5, var_17_26, var_17_24, var_17_9, arg_17_9, var_17_23, arg_17_11, arg_17_12)

						arg_17_9[1] = arg_17_9[1] + var_17_23[1]
						arg_17_9[2] = var_17_22
						var_17_17.text_color[1] = var_17_0

						UIPasses.text.draw(arg_17_3, var_17_18, arg_17_5, arg_17_6, var_17_17, var_17_9, arg_17_9, arg_17_0.text_size, arg_17_11, arg_17_12)
					end

					var_17_13 = var_17_13 + var_17_21
					arg_17_9[2] = var_17_22
				end
			end

			arg_17_9[1] = var_17_10
			arg_17_9[2] = var_17_11
			arg_17_9[3] = var_17_12

			return 0
		end
	},
	properties = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				title_text_pass_data = {
					text_id = "title"
				},
				text_pass_data = {},
				text_size = {
					0,
					0
				},
				icon_pass_data = {},
				icon_pass_definition = {
					texture_id = "icon",
					style_id = "icon"
				},
				icon_size = {
					13,
					13
				},
				content = {
					icon = "tooltip_marker",
					title = Localize("tooltips_properties") .. ":"
				},
				style = {
					property_title = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					property_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
						color_override = {},
						color_override_table = {
							start_index = 0,
							end_index = 0,
							color = Colors.get_color_table_with_alpha("font_default", 255)
						}
					},
					property_advanced_description = {
						vertical_alignment = "top",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					icon = {
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
					}
				}
			}
		end,
		draw = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13)
			if Development.parameter("enable_detailed_tooltips") and (arg_19_11:get("item_compare") or arg_19_11:get("item_detail")) then
				local var_19_0 = arg_19_13.data.slot_type

				if var_19_0 == "melee" or var_19_0 == "ranged" then
					return 0
				end
			end

			local var_19_1 = 255 * arg_19_4.alpha_multiplier
			local var_19_2 = arg_19_4.start_layer or var_0_3
			local var_19_3 = 20
			local var_19_4 = arg_19_0.frame_margin or 0
			local var_19_5 = arg_19_13.properties
			local var_19_6 = arg_19_0.style
			local var_19_7 = arg_19_0.content
			local var_19_8 = arg_19_9[1]
			local var_19_9 = arg_19_9[2]
			local var_19_10 = arg_19_9[3]
			local var_19_11 = 0

			arg_19_9[3] = var_19_2 + 2
			arg_19_9[2] = arg_19_9[2]

			local var_19_12 = pairs

			if not arg_19_11:get("item_compare") then
				local var_19_13 = arg_19_11:get("item_detail")
			end

			if var_19_5 then
				arg_19_9[1] = arg_19_9[1] + var_19_4

				local var_19_14 = var_19_6.property_title
				local var_19_15 = arg_19_0.title_text_pass_data
				local var_19_16 = var_19_7.title
				local var_19_17 = arg_19_0.text_size

				var_19_17[1] = arg_19_10[1] - (var_19_4 * 2 + var_19_4)
				var_19_17[2] = 0

				local var_19_18 = UIUtils.get_text_height(arg_19_3, var_19_17, var_19_14, var_19_16)

				var_19_17[2] = var_19_18
				arg_19_9[2] = arg_19_9[2] - var_19_18
				var_19_11 = var_19_11 + var_19_18

				if arg_19_1 then
					var_19_14.text_color[1] = var_19_1

					UIPasses.text.draw(arg_19_3, var_19_15, arg_19_5, arg_19_6, var_19_14, var_19_7, arg_19_9, var_19_17, arg_19_11, arg_19_12)
				end

				local var_19_19 = 1

				for iter_19_0, iter_19_1 in var_19_12(var_19_5) do
					local var_19_20 = WeaponProperties.properties[iter_19_0]

					if var_19_20 then
						local var_19_21 = var_19_20.buff_name
						local var_19_22

						var_19_22 = BuffUtils.get_buff_template(var_19_21).buffs[1].variable_multiplier ~= nil

						local var_19_23 = "property_title_" .. var_19_19
						local var_19_24 = var_19_6.property_text
						local var_19_25 = arg_19_0.text_pass_data

						var_19_25.text_id = var_19_23

						local var_19_26

						if arg_19_13.hidden_description then
							var_19_26 = var_0_5
						else
							local var_19_27, var_19_28 = UIUtils.get_property_description(iter_19_0, iter_19_1)
							local var_19_29 = var_19_28 and UTF8Utils.string_length(var_19_28) or 0
							local var_19_30 = var_19_26 and UTF8Utils.string_length(var_19_26) or 0

							var_19_26 = var_19_27 .. var_19_28

							local var_19_31 = var_19_24.color_override_table

							var_19_31.start_index = var_19_30 + 1
							var_19_31.end_index = var_19_30 + var_19_29
							var_19_24.color_override[1] = var_19_31
						end

						local var_19_32 = arg_19_0.text_size

						var_19_32[2] = 0

						local var_19_33, var_19_34 = UIUtils.get_text_height(arg_19_3, var_19_32, var_19_24, var_19_26)

						var_19_32[2] = var_19_33
						arg_19_9[2] = arg_19_9[2] - var_19_33

						local var_19_35 = arg_19_9[2]

						var_19_7[var_19_23] = var_19_26

						if arg_19_1 then
							local var_19_36 = arg_19_0.icon_pass_definition
							local var_19_37 = arg_19_0.icon_pass_data
							local var_19_38 = var_19_6.icon
							local var_19_39 = arg_19_0.icon_size

							var_19_38.color[1] = var_19_1
							arg_19_9[2] = arg_19_9[2] + var_19_33 - var_19_33 / var_19_34 * 0.5 - (var_19_39[2] * 0.5 + 2)

							UIPasses.texture.draw(arg_19_3, var_19_37, arg_19_5, var_19_36, var_19_38, var_19_7, arg_19_9, var_19_39, arg_19_11, arg_19_12)

							arg_19_9[2] = var_19_35
							arg_19_9[1] = arg_19_9[1] + var_19_39[1]
							var_19_24.text_color[1] = var_19_1

							UIPasses.text.draw(arg_19_3, var_19_25, arg_19_5, arg_19_6, var_19_24, var_19_7, arg_19_9, arg_19_0.text_size, arg_19_11, arg_19_12)

							arg_19_9[1] = arg_19_9[1] - var_19_39[1]
						end

						var_19_11 = var_19_11 + var_19_33
						arg_19_9[2] = var_19_35
					end
				end

				local var_19_40 = var_19_19 + 1

				var_19_11 = var_19_11 + var_19_3
			end

			arg_19_9[1] = var_19_8
			arg_19_9[2] = var_19_9
			arg_19_9[3] = var_19_10

			return var_19_11
		end
	},
	traits = {
		setup_data = function()
			local var_20_0 = "item_tooltip_frame_01"
			local var_20_1 = UIFrameSettings[var_20_0]

			return {
				default_icon = "icons_placeholder",
				frame_name = var_20_0,
				background_color = {
					240,
					3,
					3,
					3
				},
				text_pass_data = {},
				text_size = {
					0,
					0
				},
				icon_pass_data = {},
				icon_pass_definition = {
					texture_id = "icon",
					style_id = "icon"
				},
				icon_size = {
					40,
					40
				},
				frame_pass_data = {},
				frame_pass_definition = {
					texture_id = "frame",
					style_id = "frame"
				},
				frame_size = {
					0,
					0
				},
				content = {
					icon = "icons_placeholder",
					frame = var_20_1.texture
				},
				style = {
					trait_title = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						line_colors = {
							Colors.get_color_table_with_alpha("font_title", 255),
							Colors.get_color_table_with_alpha("font_default", 255)
						}
					},
					trait_advanced_description = {
						vertical_alignment = "top",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					frame = {
						texture_size = var_20_1.texture_size,
						texture_sizes = var_20_1.texture_sizes,
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
					icon = {
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
					background = {
						color = {
							255,
							10,
							10,
							10
						},
						offset = {
							0,
							0,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8, arg_21_9, arg_21_10, arg_21_11, arg_21_12, arg_21_13)
			if Development.parameter("enable_detailed_tooltips") and (arg_21_11:get("item_compare") or arg_21_11:get("item_detail")) then
				local var_21_0 = arg_21_13.data.slot_type

				if var_21_0 == "melee" or var_21_0 == "ranged" then
					return 0
				end
			end

			local var_21_1 = 255 * arg_21_4.alpha_multiplier
			local var_21_2 = arg_21_4.start_layer or var_0_3
			local var_21_3 = 20
			local var_21_4 = 20
			local var_21_5 = arg_21_0.frame_margin or 0
			local var_21_6 = arg_21_13.traits
			local var_21_7 = 0

			if var_21_6 then
				local var_21_8 = arg_21_0.style
				local var_21_9 = arg_21_0.content
				local var_21_10 = arg_21_9[1]
				local var_21_11 = arg_21_9[2]
				local var_21_12 = arg_21_9[3]

				arg_21_9[1] = arg_21_9[1] + var_21_5
				arg_21_9[2] = arg_21_9[2]
				arg_21_9[3] = var_21_2 + 2

				local var_21_13 = 10

				for iter_21_0, iter_21_1 in (arg_21_2 and ipairs or ripairs)(var_21_6) do
					local var_21_14 = WeaponTraits.traits[iter_21_1]

					if var_21_14 then
						local var_21_15 = "trait_title_" .. iter_21_0
						local var_21_16 = var_21_8.trait_title
						local var_21_17 = arg_21_0.text_pass_data

						var_21_17.text_id = var_21_15

						local var_21_18 = var_21_14.display_name
						local var_21_19 = var_21_14.advanced_description
						local var_21_20 = var_21_14.icon
						local var_21_21 = Localize(var_21_18)
						local var_21_22 = ""
						local var_21_23 = arg_21_0.icon_pass_definition
						local var_21_24 = arg_21_0.icon_pass_data
						local var_21_25 = arg_21_0.style.icon
						local var_21_26 = arg_21_0.icon_size

						var_21_9.icon = var_21_20 or arg_21_0.default_icon

						if var_21_19 then
							var_21_22 = UIUtils.get_trait_description(iter_21_1)
						end

						local var_21_27

						if arg_21_13.hidden_description then
							var_21_27 = string.format("%s\n%s\n%s", var_0_5, var_0_5, var_0_5)
							var_21_9.icon = arg_21_0.default_icon
						else
							var_21_27 = var_21_21 .. "\n" .. var_21_22
						end

						local var_21_28 = arg_21_0.text_size

						var_21_28[1] = arg_21_10[1] - var_21_5 * 3 - var_21_26[1]
						var_21_28[2] = 0

						local var_21_29 = UIUtils.get_text_height(arg_21_3, var_21_28, var_21_16, var_21_27)

						var_21_28[2] = var_21_29

						local var_21_30 = arg_21_9[1]
						local var_21_31 = arg_21_9[2]

						var_21_9[var_21_15] = var_21_27

						if arg_21_1 then
							var_21_25.color[1] = var_21_1
							arg_21_9[2] = var_21_31 - var_21_26[2]
							arg_21_9[1] = var_21_30

							UIPasses.texture.draw(arg_21_3, var_21_24, arg_21_5, var_21_23, var_21_25, var_21_9, arg_21_9, var_21_26, arg_21_11, arg_21_12)

							arg_21_9[2] = var_21_31 - var_21_29
							arg_21_9[1] = var_21_30 + var_21_26[1] + var_21_5

							local var_21_32 = var_21_16.text_color
							local var_21_33 = var_21_16.line_colors

							var_21_32[1] = var_21_1
							var_21_33[1][1] = var_21_1
							var_21_33[2][1] = var_21_1

							UIPasses.text.draw(arg_21_3, var_21_17, arg_21_5, arg_21_6, var_21_16, var_21_9, arg_21_9, var_21_28, arg_21_11, arg_21_12)
						end

						var_21_7 = var_21_7 + var_21_29

						if iter_21_0 ~= #var_21_6 then
							var_21_7 = var_21_7 + var_21_13
							arg_21_9[2] = var_21_31 - (var_21_29 + var_21_13)
							arg_21_9[1] = var_21_30
						end
					end
				end

				arg_21_9[1] = var_21_10
				arg_21_9[2] = var_21_11
				arg_21_9[3] = var_21_12
				var_21_7 = var_21_7 + var_21_3
			end

			return var_21_7
		end
	},
	advanced_input_helper = {
		setup_data = function()
			local var_22_0 = "item_tooltip_frame_01"
			local var_22_1 = UIFrameSettings[var_22_0]
			local var_22_2 = Managers.input:is_device_active("gamepad")
			local var_22_3 = "       "
			local var_22_4 = string.gsub(Localize("item_advanced_information_tooltip_input"), "%[%a*%]", var_22_3)

			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				texture_pass_data = {},
				texture_pass_definition = {
					texture_id = "texture_id",
					style_id = "input_button"
				},
				texture_size = {
					0,
					0
				},
				macro_replacement = var_22_3,
				frame_pass_data = {},
				frame_pass_definition = {
					texture_id = "frame",
					style_id = "frame"
				},
				frame_size = {
					0,
					0
				},
				content = {
					text = "",
					default_text = Localize("item_advanced_information_tooltip_input"),
					text_gamepad = var_22_4,
					frame = var_22_1.texture,
					texture_id = var_22_1.texture,
					input_button_visible = var_22_2
				},
				style = {
					frame = {
						texture_size = var_22_1.texture_size,
						texture_sizes = var_22_1.texture_sizes,
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
					text = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					input_button = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						texture_size = {
							0,
							0
						},
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
					background = {
						color = {
							255,
							10,
							10,
							10
						},
						offset = {
							0,
							0,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9, arg_23_10, arg_23_11, arg_23_12, arg_23_13)
			if not arg_23_11:get("item_compare") and not arg_23_11:get("item_detail") then
				local var_23_0 = arg_23_13.data.slot_type

				if not (var_23_0 == "melee" or var_23_0 == "ranged") then
					return 0
				end
			else
				return 0
			end

			local var_23_1 = 255 * arg_23_4.alpha_multiplier
			local var_23_2 = arg_23_4.start_layer or var_0_3
			local var_23_3 = arg_23_0.frame_margin or 0
			local var_23_4 = arg_23_13.properties
			local var_23_5 = arg_23_0.style
			local var_23_6 = arg_23_0.content
			local var_23_7 = arg_23_9[1]
			local var_23_8 = arg_23_9[2]
			local var_23_9 = arg_23_9[3]
			local var_23_10 = 0

			arg_23_9[3] = var_23_2 - 6

			if var_23_4 and next(var_23_4) then
				local var_23_11 = var_23_5.text
				local var_23_12 = arg_23_0.text_pass_data
				local var_23_13 = Managers.input:is_device_active("gamepad")

				if var_23_13 then
					var_23_6.text = var_23_6.text_gamepad
				else
					var_23_6.text = var_23_6.default_text
				end

				local var_23_14 = var_23_6.text
				local var_23_15 = arg_23_0.text_size

				var_23_15[1] = arg_23_10[1] - var_23_3 * 2
				var_23_15[2] = 0

				local var_23_16 = UIUtils.get_text_height(arg_23_3, var_23_15, var_23_11, var_23_14)
				local var_23_17 = var_23_10 + var_23_16

				var_23_15[2] = var_23_16

				local var_23_18 = arg_23_0.frame_size
				local var_23_19 = arg_23_0.frame_pass_data
				local var_23_20 = arg_23_0.frame_pass_definition
				local var_23_21 = arg_23_0.content
				local var_23_22 = arg_23_0.style.frame

				var_23_18[1] = var_23_15[1]
				var_23_18[2] = var_23_15[2] + var_23_3 / 2

				local var_23_23 = var_23_17 + var_23_18[2]

				arg_23_9[2] = arg_23_9[2] - var_23_18[2] - var_23_3 / 2
				arg_23_9[1] = arg_23_9[1] + var_23_3

				local var_23_24 = arg_23_9[2]

				if arg_23_1 then
					var_23_22.color[1] = var_23_1

					UIPasses.texture_frame.draw(arg_23_3, var_23_19, arg_23_5, var_23_20, var_23_22, var_23_21, arg_23_9, var_23_18, arg_23_11, arg_23_12)

					local var_23_25 = arg_23_0.style.background.color

					var_23_25[1] = var_23_1
					arg_23_9[3] = arg_23_9[3] - 1

					var_0_0.draw_rect(arg_23_3, arg_23_9, var_23_18, var_23_25)

					arg_23_9[3] = arg_23_9[3] + 1
				end

				arg_23_9[2] = var_23_24 + var_23_3 / 4
				var_23_15[1] = var_23_18[1]

				if arg_23_1 then
					var_23_11.text_color[1] = var_23_1

					UIPasses.text.draw(arg_23_3, var_23_12, arg_23_5, arg_23_6, var_23_11, var_23_6, arg_23_9, var_23_15, arg_23_11, arg_23_12)
				end

				if arg_23_1 then
					local var_23_26 = var_23_5.input_button
					local var_23_27 = arg_23_0.texture_pass_data
					local var_23_28 = arg_23_0.texture_pass_definition
					local var_23_29 = arg_23_0.texture_size
					local var_23_30 = arg_23_0.macro_replacement

					if var_23_13 then
						local var_23_31 = UISettings.get_gamepad_input_texture_data(arg_23_11, "debug_pixeldistance_1", true)

						var_23_26.texture_size[1] = var_23_31.size[1] * 0.8
						var_23_26.texture_size[2] = var_23_31.size[2] * 0.8
						var_23_6.texture_id = var_23_31.texture

						local var_23_32 = arg_23_9
						local var_23_33 = var_23_6.text
						local var_23_34, var_23_35 = string.find(var_23_33, var_23_30)
						local var_23_36 = string.sub(var_23_33, 1, (var_23_34 or 1) + 1)
						local var_23_37, var_23_38 = UIFontByResolution(var_23_11)
						local var_23_39 = var_0_0.text_size(arg_23_3, var_23_33, var_23_37[1], var_23_38)
						local var_23_40 = var_0_0.text_size(arg_23_3, var_23_36, var_23_37[1], var_23_38)

						var_23_32[1] = var_23_32[1] - var_23_39 * 0.5 + var_23_40 + var_23_31.size[1] * 0.5
						var_23_32[2] = var_23_32[2] - var_23_3 * 0.5

						UIPasses.texture.draw(arg_23_3, var_23_27, arg_23_5, var_23_28, var_23_26, var_23_6, var_23_32, var_23_15, arg_23_11, arg_23_12)
					end
				end
			end

			arg_23_9[1] = var_23_7
			arg_23_9[2] = var_23_8
			arg_23_9[3] = var_23_9

			return 0
		end
	},
	equipped_item_title = {
		setup_data = function()
			local var_24_0 = "item_tooltip_frame_01"
			local var_24_1 = UIFrameSettings[var_24_0]

			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				frame_pass_data = {},
				frame_pass_definition = {
					texture_id = "frame",
					style_id = "frame"
				},
				frame_size = {
					0,
					0
				},
				content = {
					text = Localize("equipped_item"),
					frame = var_24_1.texture
				},
				style = {
					frame = {
						texture_size = var_24_1.texture_size,
						texture_sizes = var_24_1.texture_sizes,
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
					text = {
						vertical_alignment = "center",
						upper_case = true,
						word_wrap = true,
						horizontal_alignment = "center",
						font_type = "hell_shark",
						font_size = var_0_6(20),
						text_color = Colors.get_color_table_with_alpha("green", 255)
					},
					background = {
						color = {
							255,
							10,
							10,
							10
						},
						offset = {
							0,
							0,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8, arg_25_9, arg_25_10, arg_25_11, arg_25_12, arg_25_13)
			local var_25_0 = arg_25_13.backend_id
			local var_25_1 = arg_25_13 and arg_25_13.data and arg_25_13.data.slot_type

			if not arg_25_4.force_equipped then
				if var_25_1 then
					local var_25_2 = InventorySettings.slot_names_by_type[var_25_1]

					if var_25_2 then
						local var_25_3 = var_25_2[1]

						if arg_25_4.player then
							local var_25_4 = arg_25_4.equipped_items

							if not var_25_4 then
								return 0
							end

							local var_25_5 = false

							for iter_25_0, iter_25_1 in ipairs(var_25_4) do
								if iter_25_1.backend_id == var_25_0 then
									var_25_5 = true

									break
								end
							end

							if not var_25_5 then
								return 0
							end
						else
							return 0
						end
					else
						return 0
					end
				else
					return 0
				end
			end

			local var_25_6 = 255 * arg_25_4.alpha_multiplier
			local var_25_7 = arg_25_4.start_layer or var_0_3
			local var_25_8 = arg_25_0.frame_margin or 0
			local var_25_9 = arg_25_0.style
			local var_25_10 = arg_25_0.content
			local var_25_11 = arg_25_9[1]
			local var_25_12 = arg_25_9[2]
			local var_25_13 = arg_25_9[3]
			local var_25_14 = 0

			arg_25_9[3] = var_25_7 - 6

			local var_25_15 = var_25_9.text
			local var_25_16 = arg_25_0.text_pass_data
			local var_25_17 = var_25_10.text
			local var_25_18 = arg_25_0.text_size

			var_25_18[1] = arg_25_10[1] - var_25_8 * 2
			var_25_18[2] = 0
			var_25_18[2] = UIUtils.get_text_height(arg_25_3, var_25_18, var_25_15, var_25_17)

			local var_25_19 = arg_25_0.frame_size
			local var_25_20 = arg_25_0.frame_pass_data
			local var_25_21 = arg_25_0.frame_pass_definition
			local var_25_22 = arg_25_0.content
			local var_25_23 = arg_25_0.style.frame

			var_25_19[1] = var_25_18[1]
			var_25_19[2] = var_25_18[2] + var_25_8 / 2

			local var_25_24 = var_25_19[2]

			arg_25_9[2] = arg_25_9[2] + var_25_8 / 2
			arg_25_9[1] = arg_25_9[1] + var_25_8

			local var_25_25 = arg_25_9[2]

			if arg_25_1 then
				var_25_23.color[1] = var_25_6

				UIPasses.texture_frame.draw(arg_25_3, var_25_20, arg_25_5, var_25_21, var_25_23, var_25_22, arg_25_9, var_25_19, arg_25_11, arg_25_12)

				local var_25_26 = arg_25_0.style.background.color

				var_25_26[1] = var_25_6
				arg_25_9[3] = arg_25_9[3] - 1

				var_0_0.draw_rect(arg_25_3, arg_25_9, var_25_19, var_25_26)

				arg_25_9[3] = arg_25_9[3] + 1
			end

			arg_25_9[2] = var_25_25 + var_25_8 / 3
			var_25_18[1] = var_25_19[1]

			if arg_25_1 then
				var_25_15.text_color[1] = var_25_6

				UIPasses.text.draw(arg_25_3, var_25_16, arg_25_5, arg_25_6, var_25_15, var_25_10, arg_25_9, var_25_18, arg_25_11, arg_25_12)
			end

			arg_25_9[1] = var_25_11
			arg_25_9[2] = var_25_12
			arg_25_9[3] = var_25_13

			return 0
		end
	},
	fatigue = {
		setup_data = function()
			return {
				background_color = {
					240,
					3,
					3,
					3
				},
				title_text_pass_data = {
					text_id = "title"
				},
				title_text_size = {
					0,
					0
				},
				text_pass_data = {
					text_id = "text"
				},
				text_size = {
					0,
					0
				},
				icon_pass_data = {},
				icon_pass_definition = {
					texture_id = "icon",
					style_id = "icon"
				},
				block_arc_pass_data = {},
				block_arc_pass_definition = {
					texture_id = "block_arc",
					style_id = "block_arc"
				},
				icon_size = {
					10,
					14
				},
				block_arc_size = {
					30,
					30
				},
				content = {
					text = "",
					icon = "tooltip_block_arch_icon",
					title = Localize("tooltips_stamina"),
					block_arc = {
						block_arc = "block_arch_symbol",
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
				},
				style = {
					icon = {
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
					block_arc = {
						color = {
							255,
							255,
							255,
							255
						},
						background_color = {
							255,
							20,
							20,
							20
						},
						offset = {
							0,
							0,
							2
						}
					},
					title = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					text = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("white", 255)
					}
				}
			}
		end,
		draw = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7, arg_27_8, arg_27_9, arg_27_10, arg_27_11, arg_27_12, arg_27_13)
			if Development.parameter("enable_detailed_tooltips") and (arg_27_11:get("item_compare") or arg_27_11:get("item_detail")) then
				local var_27_0 = arg_27_13.data.slot_type

				if var_27_0 == "melee" or var_27_0 == "ranged" then
					return 0
				end
			end

			if arg_27_13.hidden_description then
				return 0
			end

			local var_27_1 = arg_27_4.alpha_multiplier
			local var_27_2 = 255 * var_27_1
			local var_27_3 = arg_27_4.start_layer or var_0_3
			local var_27_4 = arg_27_0.frame_margin or 0
			local var_27_5 = arg_27_13.data

			if var_27_5.slot_type ~= ItemType.MELEE or not arg_27_1 then
				return 0
			end

			local var_27_6 = arg_27_0.content
			local var_27_7 = arg_27_0.style
			local var_27_8 = arg_27_9[1]
			local var_27_9 = arg_27_9[2]
			local var_27_10 = arg_27_9[3]
			local var_27_11 = arg_27_13.backend_id
			local var_27_12 = BackendUtils.get_item_template(var_27_5, var_27_11)
			local var_27_13 = var_27_12.max_fatigue_points

			var_27_6.text = tostring(var_27_13 / 2)
			arg_27_9[3] = var_27_3 + 2
			arg_27_9[1] = var_27_8 + var_27_4

			local var_27_14 = var_27_7.title
			local var_27_15 = arg_27_0.title_text_pass_data
			local var_27_16 = var_27_6.title
			local var_27_17 = arg_27_0.title_text_size

			var_27_17[1] = arg_27_10[1] - var_27_4 * 2
			var_27_17[2] = 0

			local var_27_18 = UIUtils.get_text_height(arg_27_3, var_27_17, var_27_14, var_27_16)

			var_27_17[2] = var_27_18
			arg_27_9[2] = arg_27_9[2] - var_27_18
			var_27_14.text_color[1] = var_27_2

			UIPasses.text.draw(arg_27_3, var_27_15, arg_27_5, arg_27_6, var_27_14, var_27_6, arg_27_9, var_27_17, arg_27_11, arg_27_12)

			local var_27_19 = var_27_7.text
			local var_27_20 = arg_27_0.text_pass_data
			local var_27_21 = var_27_6.text
			local var_27_22 = arg_27_0.text_size

			var_27_22[1] = arg_27_10[1] - var_27_4 * 2
			var_27_22[2] = 0

			local var_27_23 = UIUtils.get_text_height(arg_27_3, var_27_22, var_27_19, var_27_21)
			local var_27_24, var_27_25 = UIFontByResolution(var_27_19)
			local var_27_26 = var_27_24[1]
			local var_27_27 = var_27_24[2]
			local var_27_28 = var_27_24[3]
			local var_27_29, var_27_30, var_27_31 = var_0_0.text_size(arg_27_3, var_27_6.text, var_27_26, var_27_25, var_27_28)

			var_27_22[2] = var_27_23
			arg_27_9[2] = arg_27_9[2] - var_27_23

			if arg_27_1 then
				var_27_19.text_color[1] = var_27_2

				UIPasses.text.draw(arg_27_3, var_27_20, arg_27_5, arg_27_6, var_27_19, var_27_6, arg_27_9, var_27_22, arg_27_11, arg_27_12)
			end

			arg_27_9[2] = var_27_9 - var_27_18

			local var_27_32 = var_27_12.block_angle / 360
			local var_27_33 = 10
			local var_27_34 = 1 / var_27_33
			local var_27_35 = math.ceil(var_27_32 / var_27_34) * var_27_34 * 0.5
			local var_27_36 = arg_27_0.block_arc_pass_definition
			local var_27_37 = arg_27_0.block_arc_pass_data
			local var_27_38 = arg_27_0.block_arc_size
			local var_27_39 = var_27_7.block_arc
			local var_27_40 = var_27_7.block_arc.color
			local var_27_41 = var_27_39.background_color

			var_27_40[1] = 255 * var_27_35 * var_27_1
			arg_27_9[1] = math.ceil(var_27_8 + (arg_27_10[1] - var_27_38[1]) - var_27_4 * 2 - var_27_29)
			arg_27_9[2] = math.ceil(arg_27_9[2] - var_27_38[2])

			if arg_27_1 then
				var_27_41[1] = var_27_2

				var_0_0.draw_rounded_rect(arg_27_3, arg_27_9, var_27_38, var_27_38[1] * 0.5, var_27_41)
			end

			arg_27_9[3] = arg_27_9[3] + 1

			UIPasses.texture.draw(arg_27_3, var_27_37, arg_27_5, var_27_36, var_27_39, var_27_6.block_arc, arg_27_9, var_27_38, arg_27_11, arg_27_12)
			UIPasses.texture_uv.draw(arg_27_3, var_27_37, arg_27_5, var_27_36, var_27_39, var_27_6.block_arc, arg_27_9, var_27_38, arg_27_11, arg_27_12)

			arg_27_9[3] = arg_27_9[3] + 1

			local var_27_42 = var_27_7.icon
			local var_27_43 = arg_27_0.icon_size
			local var_27_44 = arg_27_0.icon_pass_data
			local var_27_45 = arg_27_0.icon_pass_definition

			var_27_42.color[1] = var_27_2
			arg_27_9[1] = arg_27_9[1] + var_27_38[1] / 2 - var_27_43[1] / 2
			arg_27_9[2] = arg_27_9[2] + var_27_38[2] / 2 - var_27_43[2] / 2

			if arg_27_1 then
				UIPasses.texture.draw(arg_27_3, var_27_44, arg_27_5, var_27_45, var_27_42, var_27_6, arg_27_9, var_27_43, arg_27_11, arg_27_12)
			end

			arg_27_9[1] = var_27_8
			arg_27_9[2] = var_27_9
			arg_27_9[3] = var_27_10

			return 0
		end
	},
	ammunition = {
		setup_data = function()
			return {
				background_color = {
					240,
					3,
					3,
					3
				},
				title_text_pass_data = {
					text_id = "title"
				},
				title_text_size = {
					0,
					0
				},
				text_pass_data = {
					text_id = "text"
				},
				text_size = {
					0,
					0
				},
				icon_pass_data = {},
				icon_pass_definition = {
					texture_id = "icon",
					style_id = "icon"
				},
				icon_size = {
					44,
					44
				},
				content = {
					text = "",
					icon = "tooltip_icon_overheat",
					title = Localize("tooltips_ammunition")
				},
				style = {
					icon = {
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
					title = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					text = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("white", 255)
					}
				}
			}
		end,
		draw = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, arg_29_9, arg_29_10, arg_29_11, arg_29_12, arg_29_13)
			if Development.parameter("enable_detailed_tooltips") and (arg_29_11:get("item_compare") or arg_29_11:get("item_detail")) then
				local var_29_0 = arg_29_13.data.slot_type

				if var_29_0 == "melee" or var_29_0 == "ranged" then
					return 0
				end
			end

			if arg_29_13.hidden_description then
				return 0
			end

			local var_29_1 = 255 * arg_29_4.alpha_multiplier
			local var_29_2 = arg_29_4.start_layer or var_0_3
			local var_29_3 = arg_29_0.frame_margin or 0
			local var_29_4 = arg_29_13.data

			if var_29_4.slot_type ~= ItemType.RANGED or not arg_29_1 then
				return 0
			end

			local var_29_5 = arg_29_0.content
			local var_29_6 = arg_29_0.style
			local var_29_7 = arg_29_9[1]
			local var_29_8 = arg_29_9[2]
			local var_29_9 = arg_29_9[3]
			local var_29_10 = arg_29_13.backend_id
			local var_29_11 = BackendUtils.get_item_template(var_29_4, var_29_10).ammo_data

			if var_29_11 and not var_29_11.hide_ammo_ui then
				local var_29_12 = var_29_11.single_clip
				local var_29_13 = var_29_11.reload_time
				local var_29_14 = var_29_11.max_ammo
				local var_29_15 = var_29_11.ammo_per_clip
				local var_29_16

				if var_29_12 then
					var_29_16 = tostring(var_29_14) .. "/0"
				else
					var_29_16 = tostring(var_29_15) .. "/" .. tostring(var_29_14 - var_29_15)
				end

				var_29_5.text = var_29_16
			else
				var_29_5.text = ""
			end

			local var_29_17 = arg_29_0.content
			local var_29_18 = arg_29_0.style

			arg_29_9[3] = var_29_2 + 2
			arg_29_9[1] = var_29_7 + var_29_3

			local var_29_19 = var_29_18.title
			local var_29_20 = arg_29_0.title_text_pass_data
			local var_29_21 = var_29_17.title
			local var_29_22 = arg_29_0.title_text_size

			var_29_22[1] = arg_29_10[1] - var_29_3 * 2
			var_29_22[2] = 0

			local var_29_23 = UIUtils.get_text_height(arg_29_3, var_29_22, var_29_19, var_29_21)

			var_29_22[2] = var_29_23
			arg_29_9[2] = arg_29_9[2] - var_29_23
			var_29_19.text_color[1] = var_29_1

			UIPasses.text.draw(arg_29_3, var_29_20, arg_29_5, arg_29_6, var_29_19, var_29_17, arg_29_9, var_29_22, arg_29_11, arg_29_12)

			if var_29_11 and not var_29_11.hide_ammo_ui then
				local var_29_24 = var_29_18.text
				local var_29_25 = arg_29_0.text_pass_data
				local var_29_26 = var_29_17.text
				local var_29_27 = arg_29_0.text_size

				var_29_27[1] = arg_29_10[1] - var_29_3 * 2
				var_29_27[2] = 0

				local var_29_28 = UIUtils.get_text_height(arg_29_3, var_29_27, var_29_24, var_29_26)

				var_29_27[2] = var_29_28
				arg_29_9[2] = arg_29_9[2] - var_29_28

				if arg_29_1 then
					var_29_24.text_color[1] = var_29_1

					UIPasses.text.draw(arg_29_3, var_29_25, arg_29_5, arg_29_6, var_29_24, var_29_17, arg_29_9, var_29_27, arg_29_11, arg_29_12)
				end

				arg_29_9[2] = var_29_8 - var_29_23
			else
				local var_29_29 = var_29_18.icon
				local var_29_30 = arg_29_0.icon_size
				local var_29_31 = arg_29_0.icon_pass_data
				local var_29_32 = arg_29_0.icon_pass_definition

				arg_29_9[1] = var_29_7 + (arg_29_10[1] - var_29_30[1]) - var_29_3
				arg_29_9[2] = arg_29_9[2] - var_29_30[2]
				var_29_29.color[1] = var_29_1

				UIPasses.texture.draw(arg_29_3, var_29_31, arg_29_5, var_29_32, var_29_29, var_29_17, arg_29_9, var_29_30, arg_29_11, arg_29_12)
			end

			arg_29_9[1] = var_29_7
			arg_29_9[2] = var_29_8
			arg_29_9[3] = var_29_9

			return 0
		end
	},
	item_power_level = {
		setup_data = function()
			local var_30_0 = {
				{
					vertical_alignment = "center",
					name = "title",
					localize = false,
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					font_size = var_0_6(18),
					text_color = Colors.get_color_table_with_alpha("font_default", 255)
				},
				{
					vertical_alignment = "center",
					name = "power",
					localize = false,
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark_header",
					font_size = var_0_6(52),
					text_color = Colors.get_color_table_with_alpha("white", 255)
				}
			}

			return {
				text_styles = var_30_0,
				text_content = {},
				text_pass_data = {},
				text_pass_size = {}
			}
		end,
		draw = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8, arg_31_9, arg_31_10, arg_31_11, arg_31_12, arg_31_13)
			if Development.parameter("enable_detailed_tooltips") and (arg_31_11:get("item_compare") or arg_31_11:get("item_detail")) then
				local var_31_0 = arg_31_13.data.slot_type

				if var_31_0 == "melee" or var_31_0 == "ranged" then
					return 0
				end
			end

			local var_31_1 = 255 * arg_31_4.alpha_multiplier
			local var_31_2 = arg_31_4.start_layer or var_0_3
			local var_31_3 = arg_31_0.frame_margin or 0
			local var_31_4 = arg_31_0.text_styles
			local var_31_5 = arg_31_0.text_content

			table.clear(var_31_5)

			local var_31_6 = arg_31_13.power_level

			if not var_31_6 then
				return 0
			end

			var_31_5.title = Localize("tooltips_power")
			var_31_5.power = tostring(var_31_6)

			local var_31_7 = ipairs
			local var_31_8 = arg_31_9[1]
			local var_31_9 = arg_31_9[2]
			local var_31_10 = arg_31_9[3]

			arg_31_9[1] = arg_31_9[1] + var_31_3
			arg_31_9[3] = var_31_2 + 2

			local var_31_11 = arg_31_0.text_pass_data
			local var_31_12 = arg_31_0.text_pass_size

			var_31_12[1] = arg_31_10[1] - var_31_3 * 2
			var_31_12[2] = 0

			local var_31_13 = 0

			for iter_31_0, iter_31_1 in var_31_7(var_31_4) do
				local var_31_14 = iter_31_1.name
				local var_31_15 = var_31_5[var_31_14]

				if var_31_15 == true then
					var_31_15 = iter_31_1.text
					var_31_5[var_31_14] = var_31_15
				end

				if var_31_15 then
					var_31_11.text_id = var_31_14
					var_31_12[2] = 0

					local var_31_16 = UIUtils.get_text_height(arg_31_3, var_31_12, iter_31_1, var_31_15)

					arg_31_9[2] = arg_31_9[2] - var_31_16
					var_31_13 = var_31_13 + var_31_16

					if arg_31_1 then
						local var_31_17
						local var_31_18
						local var_31_19
						local var_31_20 = Vector2(20, 20)

						if arg_31_4.items and #arg_31_4.items > 1 and var_31_14 == "power" then
							local var_31_21 = 0

							for iter_31_2, iter_31_3 in ipairs(arg_31_4.items) do
								if iter_31_3.backend_id ~= arg_31_13.backend_id and var_31_21 < (iter_31_3.power_level or -1) then
									var_31_21 = iter_31_3.power_level
								end
							end

							if var_31_21 < var_31_6 then
								var_31_17 = "small_arrow"
								var_31_18 = Colors.get_color_table_with_alpha("green", 255)
								var_31_19 = {
									{
										0,
										0
									},
									{
										1,
										1
									}
								}
							elseif var_31_6 < var_31_21 then
								var_31_17 = "small_arrow"
								var_31_18 = Colors.get_color_table_with_alpha("red", 255)
								var_31_19 = {
									{
										0,
										1
									},
									{
										1,
										0
									}
								}
							end
						end

						var_31_12[2] = var_31_16
						iter_31_1.text_color[1] = var_31_1

						UIPasses.text.draw(arg_31_3, var_31_11, arg_31_5, arg_31_6, iter_31_1, var_31_5, arg_31_9, var_31_12, arg_31_11, arg_31_12)

						if arg_31_1 and var_31_17 and var_31_14 == "power" then
							local var_31_22 = UIUtils.get_text_width(arg_31_3, iter_31_1, var_31_5.power)
							local var_31_23 = Vector3(arg_31_9[1] + var_31_22 + 5, arg_31_9[2] + 15, arg_31_9[3])

							var_0_0.draw_texture_uv(arg_31_3, var_31_17, var_31_23, var_31_20, var_31_19, var_31_18)
						end
					end
				end
			end

			arg_31_9[1] = var_31_8
			arg_31_9[2] = var_31_9
			arg_31_9[3] = var_31_10

			return var_31_13
		end
	},
	item_titles = {
		setup_data = function()
			local var_32_0 = "item_tooltip_frame_01"
			local var_32_1 = UIFrameSettings[var_32_0]

			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				frame_pass_data = {},
				frame_pass_definition = {
					texture_id = "frame",
					style_id = "frame"
				},
				background_size = {
					0,
					50
				},
				edge_size = {
					0,
					5
				},
				edge_holder_size = {
					9,
					17
				},
				header_glow_size = {
					0,
					50
				},
				content = {
					edge_texture = "menu_frame_12_divider",
					edge_holder_left = "menu_frame_12_divider_left",
					header_glow_texture = "tooltip_power_level_header_glow",
					edge_holder_right = "menu_frame_12_divider_right",
					frame = var_32_1.texture
				},
				style = {
					edge = {
						texture_size = {
							1,
							5
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
					},
					edge_holder = {
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
					frame = {
						texture_size = var_32_1.texture_size,
						texture_sizes = var_32_1.texture_sizes,
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
					title_text = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("font_title", 255),
						offset = {
							0,
							0,
							0
						}
					},
					title_text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					},
					text = {
						word_wrap = true,
						horizontal_alignment = "center",
						vertical_alignment = "center",
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
						disabled_text_color = Colors.get_color_table_with_alpha("red", 255),
						offset = {
							0,
							0,
							0
						}
					},
					text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					},
					background = {
						color = {
							150,
							0,
							0,
							0
						},
						offset = {
							0,
							0,
							-1
						}
					},
					header = {
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
			}
		end,
		draw = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_8, arg_33_9, arg_33_10, arg_33_11, arg_33_12, arg_33_13)
			local var_33_0 = 255 * arg_33_4.alpha_multiplier
			local var_33_1 = arg_33_4.start_layer or var_0_3
			local var_33_2 = arg_33_0.frame_margin or 0
			local var_33_3 = arg_33_13.data
			local var_33_4 = arg_33_13.rarity or var_33_3.rarity
			local var_33_5 = Colors.get_table(var_33_4)
			local var_33_6 = arg_33_0.style
			local var_33_7 = arg_33_0.content
			local var_33_8 = arg_33_9[1]
			local var_33_9 = arg_33_9[2]
			local var_33_10 = arg_33_9[3]
			local var_33_11 = 0
			local var_33_12 = var_33_3.item_type
			local var_33_13, var_33_14, var_33_15 = UIUtils.get_ui_information_from_item(arg_33_13)
			local var_33_16 = arg_33_13.hidden_description and var_0_5 or Localize(var_33_14)
			local var_33_17 = arg_33_13.hidden_description and var_0_5 or Localize(var_33_12)
			local var_33_18 = var_33_6.text
			local var_33_19 = var_33_6.text_shadow
			local var_33_20 = arg_33_4.player

			if var_33_20 then
				local var_33_21 = var_33_20:career_name()
				local var_33_22 = arg_33_8.profile_index
				local var_33_23 = arg_33_8.career_index

				if var_33_22 and var_33_23 then
					var_33_21 = SPProfiles[var_33_22].careers[var_33_23].name
				end

				local var_33_24 = var_33_3 and var_33_3.can_wield

				if not (var_33_24 and table.contains(var_33_24, var_33_21) or arg_33_6.disable_unsupported) then
					var_33_18.text_color = var_33_18.disabled_text_color
				else
					var_33_18.text_color = var_33_18.default_text_color
				end
			else
				var_33_18.text_color = var_33_18.default_text_color
			end

			local var_33_25 = var_33_6.title_text
			local var_33_26 = var_33_6.title_text_shadow
			local var_33_27 = arg_33_0.text_pass_data

			var_33_25.text_color = var_33_5

			local var_33_28 = arg_33_0.text_size

			var_33_28[1] = arg_33_10[1] - var_33_2 * 2
			var_33_28[2] = 0

			local var_33_29 = UIUtils.get_text_height(arg_33_3, var_33_28, var_33_25, var_33_16)
			local var_33_30 = UIUtils.get_text_height(arg_33_3, var_33_28, var_33_18, var_33_17)
			local var_33_31 = var_33_29 + var_33_30

			var_33_28[2] = var_33_31

			local var_33_32 = arg_33_0.background_size
			local var_33_33 = arg_33_0.style.edge

			var_33_32[1] = arg_33_10[1]
			var_33_32[2] = var_33_31 + var_33_2

			local var_33_34 = var_33_11 + var_33_32[2]

			if arg_33_1 then
				arg_33_9[2] = arg_33_9[2] - var_33_32[2] + var_33_2 / 2
				arg_33_9[1] = arg_33_9[1] + arg_33_10[1] / 2 - var_33_32[1] / 2

				local var_33_35 = arg_33_9[1]
				local var_33_36 = arg_33_0.edge_size

				var_33_36[1] = arg_33_10[1]

				local var_33_37 = var_33_33.color
				local var_33_38 = var_33_33.texture_size

				var_33_38[1] = arg_33_10[1]

				local var_33_39 = var_33_7.edge_texture

				arg_33_9[3] = var_33_1 + 4
				var_33_37[1] = var_33_0

				var_0_0.draw_tiled_texture(arg_33_3, var_33_39, arg_33_9, var_33_36, var_33_38, var_33_37)

				local var_33_40 = var_33_6.edge_holder
				local var_33_41 = arg_33_0.edge_holder_size
				local var_33_42 = var_33_40.color
				local var_33_43 = var_33_7.edge_holder_left
				local var_33_44 = var_33_7.edge_holder_right

				var_33_42[1] = var_33_0
				arg_33_9[1] = arg_33_9[1] + 3
				arg_33_9[2] = arg_33_9[2] - 6
				arg_33_9[3] = var_33_1 + 6

				var_0_0.draw_texture(arg_33_3, var_33_43, arg_33_9, var_33_41, var_33_42)

				arg_33_9[1] = arg_33_9[1] + var_33_36[1] - (var_33_41[1] + 6)

				var_0_0.draw_texture(arg_33_3, var_33_44, arg_33_9, var_33_41, var_33_42)

				arg_33_9[2] = arg_33_9[2] + 6

				local var_33_45 = var_33_6.background.color

				var_33_45[1] = var_33_0
				arg_33_9[1] = var_33_8
				arg_33_9[3] = var_33_1 + 2

				var_0_0.draw_rect(arg_33_3, arg_33_9, var_33_32, var_33_45)

				arg_33_9[3] = var_33_1 + 3

				local var_33_46 = var_33_7.header_glow_texture

				var_33_5[1] = var_33_0

				var_0_0.draw_texture(arg_33_3, var_33_46, arg_33_9, var_33_32, var_33_5)

				var_33_28[2] = var_33_29
				arg_33_9[1] = var_33_35 + var_33_2 + var_33_25.offset[1]
				arg_33_9[2] = var_33_9 + var_33_2 * 0.5 - var_33_29 + var_33_25.offset[2]
				arg_33_9[3] = var_33_1 + 6 + var_33_25.offset[3]
				var_33_7.text = var_33_16
				var_33_25.text_color[1] = var_33_0
				var_33_26.text_color[1] = var_33_0

				UIPasses.text.draw(arg_33_3, var_33_27, arg_33_5, arg_33_6, var_33_25, var_33_7, arg_33_9, var_33_28, arg_33_11, arg_33_12)

				arg_33_9[1] = var_33_35 + var_33_2 + var_33_26.offset[1]
				arg_33_9[2] = var_33_9 + var_33_2 * 0.5 - var_33_29 + var_33_26.offset[2]
				arg_33_9[3] = var_33_1 + 6 + var_33_26.offset[3]

				UIPasses.text.draw(arg_33_3, var_33_27, arg_33_5, arg_33_6, var_33_26, var_33_7, arg_33_9, var_33_28, arg_33_11, arg_33_12)

				var_33_28[2] = var_33_30
				arg_33_9[1] = var_33_35 + var_33_2 + var_33_18.offset[1]
				arg_33_9[2] = var_33_9 + var_33_2 * 0.5 - (var_33_29 + var_33_30) + var_33_18.offset[2]
				arg_33_9[3] = var_33_1 + 6 + var_33_18.offset[3]
				var_33_7.text = var_33_17
				var_33_18.text_color[1] = var_33_0
				var_33_19.text_color[1] = var_33_0

				UIPasses.text.draw(arg_33_3, var_33_27, arg_33_5, arg_33_6, var_33_18, var_33_7, arg_33_9, var_33_28, arg_33_11, arg_33_12)

				arg_33_9[1] = var_33_35 + var_33_2 + var_33_19.offset[1]
				arg_33_9[2] = var_33_9 + var_33_2 * 0.5 - (var_33_29 + var_33_30) + var_33_19.offset[2]
				arg_33_9[3] = var_33_1 + 6 + var_33_19.offset[3]

				UIPasses.text.draw(arg_33_3, var_33_27, arg_33_5, arg_33_6, var_33_19, var_33_7, arg_33_9, var_33_28, arg_33_11, arg_33_12)
			end

			arg_33_9[1] = var_33_8
			arg_33_9[2] = var_33_9
			arg_33_9[3] = var_33_10

			return var_33_34
		end
	},
	console_item_titles = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				background_size = {
					0,
					50
				},
				header_glow_size = {
					0,
					80
				},
				content = {
					header_glow_texture = "tooltip_power_level_header_glow_faded"
				},
				style = {
					title_text = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("font_title", 255),
						offset = {
							0,
							0,
							0
						}
					},
					title_text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					},
					text = {
						word_wrap = true,
						horizontal_alignment = "center",
						vertical_alignment = "center",
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
						disabled_text_color = Colors.get_color_table_with_alpha("red", 255),
						offset = {
							0,
							0,
							0
						}
					},
					text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					},
					background = {
						color = {
							150,
							0,
							0,
							0
						},
						offset = {
							0,
							0,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7, arg_35_8, arg_35_9, arg_35_10, arg_35_11, arg_35_12, arg_35_13)
			local var_35_0 = 255 * arg_35_4.alpha_multiplier
			local var_35_1 = arg_35_4.start_layer or var_0_3
			local var_35_2 = arg_35_0.frame_margin or 0
			local var_35_3 = arg_35_13.data
			local var_35_4 = arg_35_13.rarity or var_35_3.rarity
			local var_35_5 = Colors.get_table(var_35_4)
			local var_35_6 = arg_35_0.style
			local var_35_7 = arg_35_0.content
			local var_35_8 = arg_35_9[1]
			local var_35_9 = arg_35_9[2]
			local var_35_10 = arg_35_9[3]
			local var_35_11 = 0
			local var_35_12 = var_35_3.item_type
			local var_35_13 = ""
			local var_35_14 = ""
			local var_35_15 = ""
			local var_35_16, var_35_17, var_35_18 = UIUtils.get_ui_information_from_item(arg_35_13)
			local var_35_19 = Localize(var_35_17)
			local var_35_20 = Localize(var_35_12)
			local var_35_21 = var_35_19 .. "\n" .. var_35_20
			local var_35_22 = var_35_6.text
			local var_35_23 = var_35_6.text_shadow
			local var_35_24 = arg_35_4.player

			if var_35_24 then
				local var_35_25 = var_35_24:career_name()
				local var_35_26 = arg_35_8.profile_index
				local var_35_27 = arg_35_8.career_index

				if var_35_26 and var_35_27 then
					var_35_25 = SPProfiles[var_35_26].careers[var_35_27].name
				end

				local var_35_28 = var_35_3 and var_35_3.can_wield

				if not (var_35_28 and table.contains(var_35_28, var_35_25) or arg_35_6.disable_unsupported) then
					var_35_22.text_color = var_35_22.disabled_text_color
				else
					var_35_22.text_color = var_35_22.default_text_color
				end
			else
				var_35_22.text_color = var_35_22.default_text_color
			end

			local var_35_29 = var_35_6.title_text
			local var_35_30 = var_35_6.title_text_shadow
			local var_35_31 = arg_35_0.text_pass_data

			var_35_29.text_color = var_35_5

			local var_35_32 = arg_35_0.text_size

			var_35_32[1] = arg_35_10[1] - var_35_2 * 2
			var_35_32[2] = 0

			local var_35_33 = UIUtils.get_text_height(arg_35_3, var_35_32, var_35_29, var_35_19)
			local var_35_34 = UIUtils.get_text_height(arg_35_3, var_35_32, var_35_22, var_35_20)
			local var_35_35 = var_35_33 + var_35_34

			var_35_32[2] = var_35_35

			local var_35_36 = arg_35_0.background_size

			var_35_36[1] = arg_35_10[1]
			var_35_36[2] = var_35_35 + var_35_2

			local var_35_37 = var_35_11 + var_35_36[2]

			if arg_35_1 then
				arg_35_9[2] = arg_35_9[2] - var_35_36[2] + var_35_2 / 2
				arg_35_9[1] = arg_35_9[1] + arg_35_10[1] / 2 - var_35_36[1] / 2

				local var_35_38 = arg_35_9[1]
				local var_35_39 = arg_35_9[2]

				arg_35_9[1] = var_35_8
				arg_35_9[3] = var_35_1 + 3

				local var_35_40 = arg_35_0.header_glow_size

				var_35_40[1] = var_35_36[1]
				var_35_40[2] = var_35_36[2]

				local var_35_41 = var_35_7.header_glow_texture

				var_35_5[1] = var_35_0
				arg_35_9[2] = arg_35_9[2] - 5

				var_0_0.draw_texture(arg_35_3, var_35_41, arg_35_9, var_35_40, var_35_5)

				var_35_32[2] = var_35_33
				arg_35_9[1] = var_35_38 + var_35_2 + var_35_29.offset[1]
				arg_35_9[2] = var_35_9 + var_35_2 * 0.5 - var_35_33 + var_35_29.offset[2]
				arg_35_9[3] = var_35_1 + 6 + var_35_29.offset[3]
				var_35_7.text = var_35_19
				var_35_29.text_color[1] = var_35_0
				var_35_30.text_color[1] = var_35_0

				UIPasses.text.draw(arg_35_3, var_35_31, arg_35_5, arg_35_6, var_35_29, var_35_7, arg_35_9, var_35_32, arg_35_11, arg_35_12)

				arg_35_9[1] = var_35_38 + var_35_2 + var_35_30.offset[1]
				arg_35_9[2] = var_35_9 + var_35_2 * 0.5 - var_35_33 + var_35_30.offset[2]
				arg_35_9[3] = var_35_1 + 6 + var_35_30.offset[3]

				UIPasses.text.draw(arg_35_3, var_35_31, arg_35_5, arg_35_6, var_35_30, var_35_7, arg_35_9, var_35_32, arg_35_11, arg_35_12)

				var_35_32[2] = var_35_34
				arg_35_9[1] = var_35_38 + var_35_2 + var_35_22.offset[1]
				arg_35_9[2] = var_35_9 + var_35_2 * 0.5 - (var_35_33 + var_35_34) + var_35_22.offset[2]
				arg_35_9[3] = var_35_1 + 6 + var_35_22.offset[3]
				var_35_7.text = var_35_20
				var_35_22.text_color[1] = var_35_0
				var_35_23.text_color[1] = var_35_0

				UIPasses.text.draw(arg_35_3, var_35_31, arg_35_5, arg_35_6, var_35_22, var_35_7, arg_35_9, var_35_32, arg_35_11, arg_35_12)

				arg_35_9[1] = var_35_38 + var_35_2 + var_35_23.offset[1]
				arg_35_9[2] = var_35_9 + var_35_2 * 0.5 - (var_35_33 + var_35_34) + var_35_23.offset[2]
				arg_35_9[3] = var_35_1 + 6 + var_35_23.offset[3]

				UIPasses.text.draw(arg_35_3, var_35_31, arg_35_5, arg_35_6, var_35_23, var_35_7, arg_35_9, var_35_32, arg_35_11, arg_35_12)
			end

			arg_35_9[1] = var_35_8
			arg_35_9[2] = var_35_9
			arg_35_9[3] = var_35_10

			return var_35_37
		end
	},
	item_text = {
		setup_data = function()
			local var_36_0 = {
				{
					vertical_alignment = "bottom",
					name = "stat",
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					prefix_text = "Stamina:",
					font_size = var_0_6(20),
					text_color = Colors.get_color_table_with_alpha("green", 255)
				},
				{
					vertical_alignment = "bottom",
					name = "properties",
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					prefix_text = "Properties:",
					font_size = var_0_6(16),
					text_color = Colors.get_color_table_with_alpha("green", 255)
				},
				{
					word_wrap = true,
					name = "tooltip_stat_attack_title_1",
					localize = false,
					horizontal_alignment = "left",
					ignore_line_change = true,
					vertical_alignment = "bottom",
					font_type = "hell_shark",
					text = Localize("item_compare_attack_title_light"),
					font_size = var_0_6(16),
					text_color = Colors.get_color_table_with_alpha("font_title", 255)
				},
				{
					word_wrap = true,
					name = "tooltip_stat_attack_title_2",
					localize = false,
					horizontal_alignment = "right",
					vertical_alignment = "bottom",
					font_type = "hell_shark",
					text = Localize("item_compare_attack_title_heavy"),
					font_size = var_0_6(16),
					text_color = Colors.get_color_table_with_alpha("font_title", 255)
				}
			}

			for iter_36_0 = 1, 4 do
				var_36_0[#var_36_0 + 1] = {
					vertical_alignment = "bottom",
					localize = false,
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					name = "tooltip_title_" .. iter_36_0,
					font_size = var_0_6(16),
					text_color = Colors.get_color_table_with_alpha("font_title", 255)
				}
				var_36_0[#var_36_0 + 1] = {
					vertical_alignment = "bottom",
					localize = false,
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					name = "tooltip_description_" .. iter_36_0,
					font_size = var_0_6(16),
					text_color = Colors.get_color_table_with_alpha("font_default", 255)
				}
				var_36_0[#var_36_0 + 1] = {
					vertical_alignment = "bottom",
					localize = false,
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					name = "tooltip_warning_" .. iter_36_0,
					font_size = var_0_6(16),
					text_color = Colors.get_color_table_with_alpha("red", 255)
				}
			end

			return {
				text_styles = var_36_0,
				text_content = {},
				text_pass_data = {},
				text_pass_size = {}
			}
		end,
		draw = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7, arg_37_8, arg_37_9, arg_37_10, arg_37_11, arg_37_12, arg_37_13)
			if Development.parameter("enable_detailed_tooltips") and (arg_37_11:get("item_compare") or arg_37_11:get("item_detail")) then
				local var_37_0 = arg_37_13.data.slot_type

				if var_37_0 == "melee" or var_37_0 == "ranged" then
					return 0
				end
			end

			local var_37_1 = 255 * arg_37_4.alpha_multiplier
			local var_37_2 = arg_37_4.start_layer or var_0_3
			local var_37_3 = arg_37_0.frame_margin or 0
			local var_37_4 = arg_37_0.text_styles
			local var_37_5 = arg_37_0.text_content

			table.clear(var_37_5)

			local var_37_6 = arg_37_13.backend_id
			local var_37_7 = arg_37_13.data
			local var_37_8 = arg_37_13.rarity or var_37_7.rarity
			local var_37_9 = Colors.get_table(var_37_8)
			local var_37_10 = var_37_7.slot_type
			local var_37_11 = var_37_10 ~= ItemType.LOOT_CHEST and BackendUtils.get_item_template(var_37_7, var_37_6)
			local var_37_12 = var_37_10 == ItemType.MELEE and var_37_11.max_fatigue_points

			if var_37_12 then
				var_37_5.stat = "+" .. var_37_12 .. Localize("tooltip_stamina") or "n/a"
			end

			if var_37_11 and var_37_11.buffs and var_37_11.buffs[1] then
				local var_37_13 = BuffUtils.get_buff_template(var_37_11.buffs[1].name)

				if var_37_13 then
					local var_37_14 = var_37_13.buffs[1]
					local var_37_15 = var_37_14.bonus

					if var_37_14 then
						if var_37_14.multiplier then
							var_37_15 = var_37_14.multiplier
							var_37_5.stat = "+" .. var_37_15 * 100 .. "% " .. var_37_14.description
						else
							var_37_5.stat = "+" .. var_37_15 .. " " .. var_37_14.description
						end
					end
				end
			end

			local var_37_16 = arg_37_2 and ipairs or ripairs
			local var_37_17 = arg_37_9[1]
			local var_37_18 = arg_37_9[2]
			local var_37_19 = arg_37_9[3]

			arg_37_9[1] = arg_37_9[1] + var_37_3
			arg_37_9[2] = arg_37_2 and arg_37_9[2] - arg_37_10[2] - var_37_3 or arg_37_9[2] + var_37_3
			arg_37_9[3] = var_37_2 + 5

			local var_37_20 = arg_37_0.text_pass_data
			local var_37_21 = arg_37_0.text_pass_size

			var_37_21[1] = arg_37_10[1] - var_37_3 * 2
			var_37_21[2] = arg_37_10[2]

			local var_37_22 = 0

			for iter_37_0, iter_37_1 in var_37_16(var_37_4) do
				local var_37_23 = iter_37_1.ignore_line_change

				iter_37_1.vertical_alignment = arg_37_2 and "top" or "bottom"

				local var_37_24 = iter_37_1.name
				local var_37_25 = var_37_5[var_37_24]

				if var_37_25 == true then
					var_37_25 = iter_37_1.text
					var_37_5[var_37_24] = var_37_25
				end

				if var_37_25 then
					var_37_20.text_id = var_37_24

					local var_37_26 = UIUtils.get_text_height(arg_37_3, var_37_21, iter_37_1, var_37_25)

					if arg_37_1 then
						iter_37_1.text_color[1] = var_37_1

						UIPasses.text.draw(arg_37_3, var_37_20, arg_37_5, arg_37_6, iter_37_1, var_37_5, arg_37_9, var_37_21, arg_37_11, arg_37_12)
					end

					if not var_37_23 then
						if arg_37_2 then
							arg_37_9[2] = arg_37_9[2] - var_37_26
						else
							arg_37_9[2] = arg_37_9[2] + var_37_26
						end

						var_37_22 = var_37_22 + var_37_26
					end
				end
			end

			arg_37_9[1] = var_37_17
			arg_37_9[2] = var_37_18
			arg_37_9[3] = var_37_19

			return var_37_22
		end
	},
	unwieldable = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {},
				style = {
					text = {
						vertical_alignment = "center",
						name = "description",
						localize = false,
						word_wrap = true,
						horizontal_alignment = "center",
						font_type = "hell_shark",
						font_size = var_0_6(24),
						text_color = Colors.get_color_table_with_alpha("red", 255)
					}
				}
			}
		end,
		draw = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9, arg_39_10, arg_39_11, arg_39_12, arg_39_13)
			if Development.parameter("enable_detailed_tooltips") and (arg_39_11:get("item_compare") or arg_39_11:get("item_detail")) then
				local var_39_0 = arg_39_13.data.slot_type

				if var_39_0 == "melee" or var_39_0 == "ranged" then
					return 0
				end
			end

			local var_39_1 = 255 * arg_39_4.alpha_multiplier
			local var_39_2 = arg_39_4.start_layer or var_0_3
			local var_39_3 = arg_39_0.frame_margin or 0
			local var_39_4 = arg_39_0.content
			local var_39_5 = arg_39_0.style
			local var_39_6 = arg_39_13.data
			local var_39_7 = arg_39_4.player

			if var_39_7 then
				local var_39_8 = var_39_7:career_name()
				local var_39_9 = arg_39_8.profile_index
				local var_39_10 = arg_39_8.career_index

				if var_39_9 and var_39_10 then
					var_39_8 = SPProfiles[var_39_9].careers[var_39_10].name
				end

				local var_39_11 = var_39_6 and var_39_6.can_wield

				if not (var_39_11 and table.contains(var_39_11, var_39_8) or arg_39_6.disable_unsupported) then
					local var_39_12 = ""
					local var_39_13 = #var_39_11, (table.contains(var_39_11, var_39_8))

					for iter_39_0, iter_39_1 in ipairs(var_39_11) do
						local var_39_14 = CareerSettings[iter_39_1].display_name

						var_39_12 = var_39_12 .. Localize(var_39_14)
						var_39_13 = var_39_13 - 1

						if var_39_13 > 0 then
							var_39_12 = var_39_12 .. ", "
						end
					end

					var_39_4.text = var_39_12

					local var_39_15 = arg_39_9[1]
					local var_39_16 = arg_39_9[2]
					local var_39_17 = arg_39_9[3]

					arg_39_9[3] = var_39_2 + 5

					local var_39_18 = var_39_5.text
					local var_39_19 = arg_39_0.text_pass_data
					local var_39_20 = arg_39_0.text_size

					var_39_20[1] = arg_39_10[1] - var_39_3 * 2
					var_39_20[2] = 0

					local var_39_21 = UIUtils.get_text_height(arg_39_3, var_39_20, var_39_18, var_39_12)

					var_39_20[2] = var_39_21

					if arg_39_1 then
						arg_39_9[1] = var_39_15 + var_39_3
						arg_39_9[2] = arg_39_9[2] - var_39_21 + var_39_3 * 0.5
						var_39_18.text_color[1] = var_39_1

						UIPasses.text.draw(arg_39_3, var_39_19, arg_39_5, arg_39_6, var_39_18, var_39_4, arg_39_9, var_39_20, arg_39_11, arg_39_12)
					end

					arg_39_9[1] = var_39_15
					arg_39_9[2] = var_39_16
					arg_39_9[3] = var_39_17

					return var_39_21
				else
					return 0
				end
			else
				return 0
			end
		end
	},
	skin_applied = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {
					prefix_text = Localize("item_skin_applied_prefix")
				},
				style = {
					text = {
						vertical_alignment = "center",
						name = "description",
						localize = false,
						word_wrap = true,
						horizontal_alignment = "center",
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("promo", 255)
					}
				}
			}
		end,
		draw = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7, arg_41_8, arg_41_9, arg_41_10, arg_41_11, arg_41_12, arg_41_13)
			if Development.parameter("enable_detailed_tooltips") and (arg_41_11:get("item_compare") or arg_41_11:get("item_detail")) then
				local var_41_0 = arg_41_13.data.slot_type

				if var_41_0 == "melee" or var_41_0 == "ranged" then
					return 0
				end
			end

			local var_41_1 = 255 * arg_41_4.alpha_multiplier
			local var_41_2 = arg_41_4.start_layer or var_0_3
			local var_41_3 = arg_41_0.frame_margin or 0
			local var_41_4 = arg_41_0.content
			local var_41_5 = arg_41_0.style
			local var_41_6 = arg_41_13.data
			local var_41_7 = arg_41_13.skin
			local var_41_8 = var_41_6.item_type
			local var_41_9 = arg_41_13.ItemId or arg_41_13.item_id
			local var_41_10 = var_41_9 and string.gsub(var_41_9, "^vs_", "")

			if var_41_7 and var_41_8 ~= "weapon_skin" and WeaponSkins.default_skins[var_41_10] ~= var_41_7 then
				var_41_4.text = arg_41_13.hidden_description and var_0_5 or var_41_4.prefix_text

				local var_41_11 = arg_41_9[1]
				local var_41_12 = arg_41_9[2]
				local var_41_13 = arg_41_9[3]

				arg_41_9[3] = var_41_2 + 5

				local var_41_14 = var_41_5.text
				local var_41_15 = arg_41_0.text_pass_data
				local var_41_16 = arg_41_0.text_size

				var_41_16[1] = arg_41_10[1] - var_41_3 * 2
				var_41_16[2] = 0

				local var_41_17 = UIUtils.get_text_height(arg_41_3, var_41_16, var_41_14, var_41_4.text)

				var_41_16[2] = var_41_17

				if arg_41_1 then
					arg_41_9[1] = var_41_11 + var_41_3
					arg_41_9[2] = arg_41_9[2] - var_41_17
					var_41_14.text_color[1] = var_41_1

					UIPasses.text.draw(arg_41_3, var_41_15, arg_41_5, arg_41_6, var_41_14, var_41_4, arg_41_9, var_41_16, arg_41_11, arg_41_12)
				end

				arg_41_9[1] = var_41_11
				arg_41_9[2] = var_41_12
				arg_41_9[3] = var_41_13

				return var_41_17
			else
				return 0
			end
		end
	},
	console_item_description = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {},
				style = {
					text = {
						vertical_alignment = "center",
						name = "description",
						localize = false,
						word_wrap = true,
						horizontal_alignment = "left",
						font_type = "hell_shark",
						font_size = var_0_6(14),
						text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
					}
				}
			}
		end,
		draw = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6, arg_43_7, arg_43_8, arg_43_9, arg_43_10, arg_43_11, arg_43_12, arg_43_13)
			if Development.parameter("enable_detailed_tooltips") and (arg_43_11:get("item_compare") or arg_43_11:get("item_detail")) then
				local var_43_0 = arg_43_13.data.slot_type

				if var_43_0 == "melee" or var_43_0 == "ranged" then
					return 0
				end
			end

			local var_43_1 = 255 * arg_43_4.alpha_multiplier
			local var_43_2 = arg_43_4.start_layer or var_0_3
			local var_43_3 = arg_43_0.frame_margin or 0
			local var_43_4 = arg_43_0.content
			local var_43_5 = arg_43_0.style
			local var_43_6
			local var_43_7 = arg_43_13.data.slot_type
			local var_43_8, var_43_9, var_43_10 = UIUtils.get_ui_information_from_item(arg_43_13)

			if var_43_10 and Localize(var_43_10) ~= "" then
				var_43_6 = Localize(var_43_10)
			end

			if not var_43_6 then
				return 0
			end

			var_43_4.text = var_43_6

			local var_43_11 = arg_43_9[1]
			local var_43_12 = arg_43_9[2]
			local var_43_13 = arg_43_9[3]

			arg_43_9[3] = var_43_2 + 5

			local var_43_14 = var_43_5.text
			local var_43_15 = arg_43_0.text_pass_data
			local var_43_16 = arg_43_0.text_size

			var_43_16[1] = arg_43_10[1] - var_43_3 * 2
			var_43_16[2] = 0

			local var_43_17 = UIUtils.get_text_height(arg_43_3, var_43_16, var_43_14, var_43_6)

			var_43_16[2] = var_43_17

			local var_43_18 = var_43_17 + var_43_3 * 0.5

			if arg_43_1 then
				arg_43_9[1] = var_43_11 + var_43_3
				arg_43_9[2] = arg_43_9[2] - var_43_18
				var_43_14.text_color[1] = var_43_1

				UIPasses.text.draw(arg_43_3, var_43_15, arg_43_5, arg_43_6, var_43_14, var_43_4, arg_43_9, var_43_16, arg_43_11, arg_43_12)
			end

			arg_43_9[1] = var_43_11
			arg_43_9[2] = var_43_12
			arg_43_9[3] = var_43_13

			return var_43_18
		end
	},
	item_description = {
		setup_data = function()
			return {
				background_color = {
					240,
					3,
					3,
					3
				},
				background_size = {
					0,
					50
				},
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				edge_size = {
					0,
					5
				},
				edge_holder_size = {
					9,
					17
				},
				content = {
					edge_holder_right = "menu_frame_12_divider_right",
					edge_texture = "menu_frame_12_divider",
					edge_holder_left = "menu_frame_12_divider_left"
				},
				style = {
					edge = {
						texture_size = {
							1,
							5
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
					},
					edge_holder = {
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
					text = {
						vertical_alignment = "center",
						name = "description",
						localize = false,
						word_wrap = true,
						horizontal_alignment = "left",
						font_type = "hell_shark",
						font_size = var_0_6(14),
						text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
					},
					background = {
						color = {
							150,
							0,
							0,
							0
						},
						offset = {
							0,
							0,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9, arg_45_10, arg_45_11, arg_45_12, arg_45_13)
			if Development.parameter("enable_detailed_tooltips") and (arg_45_11:get("item_compare") or arg_45_11:get("item_detail")) then
				local var_45_0 = arg_45_13.data.slot_type

				if var_45_0 == "melee" or var_45_0 == "ranged" then
					return 0
				end
			end

			local var_45_1 = 255 * arg_45_4.alpha_multiplier
			local var_45_2 = arg_45_4.start_layer or var_0_3
			local var_45_3 = arg_45_0.frame_margin or 0
			local var_45_4 = arg_45_0.content
			local var_45_5 = arg_45_0.style
			local var_45_6
			local var_45_7 = arg_45_13.data.slot_type
			local var_45_8, var_45_9, var_45_10 = UIUtils.get_ui_information_from_item(arg_45_13)

			if var_45_10 and Localize(var_45_10) ~= "" then
				var_45_6 = Localize(var_45_10)
			end

			if not var_45_6 then
				return 0
			end

			var_45_4.text = var_45_6

			local var_45_11 = arg_45_9[1]
			local var_45_12 = arg_45_9[2]
			local var_45_13 = arg_45_9[3]

			arg_45_9[3] = var_45_2 + 5

			local var_45_14 = var_45_5.text
			local var_45_15 = arg_45_0.text_pass_data
			local var_45_16 = arg_45_0.text_size

			var_45_16[1] = arg_45_10[1] - var_45_3 * 2
			var_45_16[2] = 0

			local var_45_17 = UIUtils.get_text_height(arg_45_3, var_45_16, var_45_14, var_45_6)

			var_45_16[2] = var_45_17

			local var_45_18 = RESOLUTION_LOOKUP.inv_scale
			local var_45_19 = var_45_17 + var_45_3

			if arg_45_1 then
				local var_45_20 = arg_45_0.background_size
				local var_45_21 = var_45_5.background.color

				var_45_21[1] = var_45_1
				var_45_20[1] = arg_45_10[1]
				var_45_20[2] = var_45_19
				arg_45_9[2] = var_45_12 - var_45_20[2]
				arg_45_9[3] = var_45_2 + 3

				var_0_0.draw_rect(arg_45_3, arg_45_9, var_45_20, var_45_21)

				arg_45_9[1] = var_45_11
				arg_45_9[2] = var_45_12

				local var_45_22 = arg_45_0.edge_size

				var_45_22[1] = arg_45_10[1]

				local var_45_23 = var_45_5.edge
				local var_45_24 = var_45_23.color
				local var_45_25 = var_45_23.texture_size

				var_45_25[1] = arg_45_10[1]

				local var_45_26 = var_45_4.edge_texture

				var_45_24[1] = var_45_1

				local var_45_27 = arg_45_9[2] - var_45_3 * 0.5 * var_45_18

				arg_45_9[2] = var_45_27
				arg_45_9[3] = var_45_2 + 4

				var_0_0.draw_tiled_texture(arg_45_3, var_45_26, arg_45_9, var_45_22, var_45_25, var_45_24)

				local var_45_28 = var_45_5.edge_holder
				local var_45_29 = arg_45_0.edge_holder_size
				local var_45_30 = var_45_28.color
				local var_45_31 = var_45_4.edge_holder_left
				local var_45_32 = var_45_4.edge_holder_right

				var_45_30[1] = var_45_1
				arg_45_9[1] = arg_45_9[1] + 3
				arg_45_9[2] = var_45_27 - 6
				arg_45_9[3] = var_45_2 + 6

				var_0_0.draw_texture(arg_45_3, var_45_31, arg_45_9, var_45_29, var_45_30)

				arg_45_9[1] = arg_45_9[1] + var_45_22[1] - (var_45_29[1] + 6)

				var_0_0.draw_texture(arg_45_3, var_45_32, arg_45_9, var_45_29, var_45_30)

				arg_45_9[1] = var_45_11 + var_45_3
				arg_45_9[2] = var_45_27 - var_45_17
				var_45_14.text_color[1] = var_45_1

				UIPasses.text.draw(arg_45_3, var_45_15, arg_45_5, arg_45_6, var_45_14, var_45_4, arg_45_9, var_45_16, arg_45_11, arg_45_12)
			end

			arg_45_9[1] = var_45_11
			arg_45_9[2] = var_45_12
			arg_45_9[3] = var_45_13

			return var_45_19
		end
	},
	talent_text = {
		setup_data = function()
			local var_46_0 = {
				{
					word_wrap = true,
					name = "title",
					localize = true,
					use_shadow = true,
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					font_type = "hell_shark",
					font_size = var_0_6(24),
					text_color = Colors.get_color_table_with_alpha("font_title", 255)
				},
				{
					vertical_alignment = "bottom",
					name = "description",
					localize = false,
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					font_size = var_0_6(20),
					text_color = Colors.get_color_table_with_alpha("font_default", 255)
				},
				{
					word_wrap = true,
					name = "requirement",
					localize = false,
					use_shadow = true,
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					font_type = "hell_shark",
					font_size = var_0_6(16),
					text_color = Colors.get_color_table_with_alpha("red", 255)
				},
				{
					word_wrap = true,
					name = "information",
					localize = false,
					use_shadow = true,
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					font_type = "hell_shark",
					font_size = var_0_6(16),
					text_color = Colors.get_color_table_with_alpha("green", 255)
				}
			}
			local var_46_1 = {
				information = {
					vertical_alignment = "center",
					horizontal_alignment = "left",
					texture_size = {
						0,
						0
					},
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
				}
			}
			local var_46_2 = {
				text_styles = var_46_0,
				texture_styles = var_46_1
			}
			local var_46_3 = Managers.input:is_device_active("gamepad")

			var_46_2.text_content = {}
			var_46_2.text_pass_data = {}
			var_46_2.text_pass_size = {}
			var_46_2.texture_pass_data = {}
			var_46_2.texture_pass_definition = {
				texture_id = "texture_id",
				style_id = "information"
			}

			return var_46_2
		end,
		draw = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5, arg_47_6, arg_47_7, arg_47_8, arg_47_9, arg_47_10, arg_47_11, arg_47_12, arg_47_13)
			local var_47_0 = 255 * arg_47_4.alpha_multiplier
			local var_47_1 = arg_47_4.start_layer or var_0_3
			local var_47_2 = arg_47_0.frame_margin or 0
			local var_47_3 = arg_47_0.text_styles
			local var_47_4 = arg_47_0.text_content

			table.clear(var_47_4)

			local var_47_5 = arg_47_8.disabled
			local var_47_6 = arg_47_8.is_selected

			var_47_4.title = arg_47_13.display_name or arg_47_13.name or "n/a"

			local var_47_7
			local var_47_8

			if var_47_5 then
				var_47_7 = Localize("talent_locked_desc")
			elseif not var_47_6 then
				var_47_8 = arg_47_8.gamepad_active and Localize("menu_select") or Localize("talent_can_select_desc")
			end

			var_47_4.requirement = var_47_7
			var_47_4.information = var_47_8
			var_47_4.description = UIUtils.get_talent_description(arg_47_13)

			local var_47_9 = arg_47_2 and ipairs or ripairs
			local var_47_10 = arg_47_9[1]
			local var_47_11 = arg_47_9[2]
			local var_47_12 = arg_47_9[3]

			arg_47_9[1] = arg_47_9[1] + var_47_2
			arg_47_9[2] = arg_47_2 and arg_47_9[2] - arg_47_10[2] - var_47_2 or arg_47_9[2] + var_47_2
			arg_47_9[3] = var_47_1 + 5

			local var_47_13 = arg_47_0.text_pass_data
			local var_47_14 = arg_47_0.text_pass_size

			var_47_14[1] = arg_47_10[1] - var_47_2 * 2
			var_47_14[2] = arg_47_10[2]

			local var_47_15 = var_47_2

			for iter_47_0, iter_47_1 in var_47_9(var_47_3) do
				local var_47_16 = iter_47_1.ignore_line_change

				iter_47_1.vertical_alignment = arg_47_2 and "top" or "bottom"

				local var_47_17 = iter_47_1.name
				local var_47_18 = var_47_4[var_47_17]
				local var_47_19 = arg_47_0.texture_styles[var_47_17]

				if arg_47_1 and var_47_18 and var_47_19 and arg_47_8.gamepad_active then
					local var_47_20 = arg_47_0.texture_pass_data
					local var_47_21 = arg_47_0.texture_size
					local var_47_22 = arg_47_0.texture_pass_definition
					local var_47_23 = UISettings.get_gamepad_input_texture_data(arg_47_11, "confirm", true)

					var_47_19.texture_size[1] = var_47_23.size[1] * 0.8
					var_47_19.texture_size[2] = var_47_23.size[2] * 0.8
					var_47_19.color[1] = var_47_0
					arg_47_8.texture_id = var_47_23.texture

					local var_47_24 = arg_47_9[2]

					arg_47_9[2] = arg_47_9[2] - var_47_2

					UIPasses.texture.draw(arg_47_3, var_47_20, arg_47_5, var_47_22, var_47_19, arg_47_8, arg_47_9, var_47_14, arg_47_11, arg_47_12)

					arg_47_9[1] = arg_47_9[1] + var_47_19.texture_size[1] + var_47_2 * 0.5
					arg_47_9[2] = var_47_24
				end

				if var_47_18 == true then
					var_47_18 = iter_47_1.text
					var_47_4[var_47_17] = var_47_18
				end

				if var_47_18 then
					var_47_13.text_id = var_47_17

					if arg_47_1 then
						iter_47_1.text_color[1] = var_47_0

						UIPasses.text.draw(arg_47_3, var_47_13, arg_47_5, arg_47_6, iter_47_1, var_47_4, arg_47_9, var_47_14, arg_47_11, arg_47_12)
					end

					local var_47_25 = UIUtils.get_text_height(arg_47_3, var_47_14, iter_47_1, var_47_18)

					if not var_47_16 then
						if arg_47_2 then
							arg_47_9[2] = arg_47_9[2] - var_47_25
						else
							arg_47_9[2] = arg_47_9[2] + var_47_25
						end

						var_47_15 = var_47_15 + var_47_25
					end
				end
			end

			arg_47_9[1] = var_47_10
			arg_47_9[2] = var_47_11
			arg_47_9[3] = var_47_12

			return var_47_15
		end
	},
	generic_text = {
		setup_data = function()
			return {
				text_pass_data = {},
				text_size = {},
				content = {
					text_content = {}
				},
				style = {
					title_text = {
						word_wrap = true,
						localize = true,
						horizontal_alignment = "left",
						vertical_alignment = "center",
						font_type = "hell_shark",
						font_size = var_0_6(20),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						line_colors = {
							Colors.get_color_table_with_alpha("font_title", 255)
						},
						offset = {
							0,
							0,
							0
						}
					},
					title_text_shadow = {
						vertical_alignment = "center",
						localize = true,
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(20),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5, arg_49_6, arg_49_7, arg_49_8, arg_49_9, arg_49_10, arg_49_11, arg_49_12)
			local var_49_0 = arg_49_6.text_id
			local var_49_1 = var_49_0 and arg_49_8[var_49_0]

			if not var_49_1 then
				return 0
			end

			local var_49_2 = arg_49_6.style_id
			local var_49_3 = 255 * arg_49_4.alpha_multiplier
			local var_49_4 = arg_49_4.start_layer or var_0_3
			local var_49_5 = arg_49_0.frame_margin or 0
			local var_49_6 = arg_49_0.style
			local var_49_7 = arg_49_0.content
			local var_49_8 = arg_49_9[1]
			local var_49_9 = arg_49_9[2]
			local var_49_10 = arg_49_9[3]
			local var_49_11 = var_49_5
			local var_49_12 = var_49_6.title_text
			local var_49_13 = var_49_6.title_text_shadow
			local var_49_14 = arg_49_0.text_pass_data

			var_49_14.text_id = var_49_0

			local var_49_15 = not var_49_2 or arg_49_7.localize

			var_49_12.localize = var_49_15
			var_49_13.localize = var_49_15

			local var_49_16 = arg_49_0.text_size
			local var_49_17 = arg_49_10[1] - var_49_5 * 2

			var_49_16[1] = var_49_17
			var_49_16[2] = 0

			local var_49_18 = UIUtils.get_text_height(arg_49_3, var_49_16, var_49_12, var_49_1)
			local var_49_19 = var_49_11 + var_49_18

			var_49_16[2] = var_49_18

			if arg_49_1 then
				local var_49_20 = arg_49_9[1] + var_49_5
				local var_49_21 = arg_49_9[2] - var_49_19 + var_49_5

				arg_49_9[1] = var_49_20 + var_49_12.offset[1]
				arg_49_9[2] = var_49_21 - var_49_5 + var_49_12.offset[2]
				arg_49_9[3] = var_49_4 + 6 + var_49_12.offset[3]
				var_49_16[1] = var_49_17

				local var_49_22 = var_49_12.line_colors

				for iter_49_0, iter_49_1 in ipairs(var_49_22) do
					iter_49_1[1] = var_49_3
				end

				var_49_12.text_color[1] = var_49_3
				var_49_13.text_color[1] = var_49_3

				UIPasses.text.draw(arg_49_3, var_49_14, arg_49_5, arg_49_6, var_49_12, arg_49_8, arg_49_9, var_49_16, arg_49_11, arg_49_12)

				arg_49_9[1] = var_49_20 + var_49_13.offset[1]
				arg_49_9[2] = var_49_21 - var_49_5 + var_49_13.offset[2]
				arg_49_9[3] = var_49_4 + 6 + var_49_13.offset[3]

				UIPasses.text.draw(arg_49_3, var_49_14, arg_49_5, arg_49_6, var_49_13, arg_49_8, arg_49_9, var_49_16, arg_49_11, arg_49_12)
			end

			arg_49_9[1] = var_49_8
			arg_49_9[2] = var_49_9
			arg_49_9[3] = var_49_10

			return var_49_19
		end
	},
	level_info = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					255,
					0,
					0,
					0
				},
				text_pass_data = {},
				text_size = {},
				content = {
					text_content = {}
				},
				style = {
					image_edge_fade = {
						color = {
							255,
							255,
							255,
							255
						},
						size = {
							280,
							15
						}
					},
					text_styles = {
						{
							vertical_alignment = "center",
							name = "title",
							word_wrap = true,
							horizontal_alignment = "center",
							font_type = "hell_shark_header",
							font_size = var_0_6(28),
							text_color = Colors.get_color_table_with_alpha("font_title", 255)
						},
						{
							vertical_alignment = "center",
							name = "description",
							word_wrap = true,
							horizontal_alignment = "center",
							font_type = "hell_shark",
							font_size = var_0_6(18),
							text_color = Colors.get_color_table_with_alpha("font_default", 255)
						}
					}
				}
			}
		end,
		draw = function(arg_51_0, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8, arg_51_9, arg_51_10, arg_51_11, arg_51_12, arg_51_13)
			local var_51_0 = 255 * arg_51_4.alpha_multiplier
			local var_51_1 = arg_51_4.start_layer or var_0_3
			local var_51_2 = arg_51_0.frame_margin or 0
			local var_51_3 = arg_51_0.style
			local var_51_4 = arg_51_0.content
			local var_51_5 = var_51_3.text_styles
			local var_51_6 = var_51_4.text_content
			local var_51_7 = arg_51_13.display_name
			local var_51_8 = var_51_2 * 0.5
			local var_51_9 = arg_51_9[1]
			local var_51_10 = arg_51_9[2]
			local var_51_11 = arg_51_9[3]
			local var_51_12 = arg_51_0.frame_name
			local var_51_13 = UIFrameSettings[var_51_12].texture_sizes.horizontal[2]

			var_51_6.title = Localize(var_51_7)
			arg_51_9[1] = arg_51_9[1] + var_51_2
			arg_51_9[2] = arg_51_2 and arg_51_9[2] - var_51_8 or arg_51_9[2] + var_51_13
			arg_51_9[3] = var_51_1 + 5

			local var_51_14 = arg_51_0.text_size

			var_51_14[1] = arg_51_10[1] - var_51_2 * 2
			var_51_14[2] = 0

			local var_51_15 = -var_51_13
			local var_51_16 = arg_51_0.text_pass_data

			for iter_51_0, iter_51_1 in (arg_51_2 and ipairs or ripairs)(var_51_5) do
				local var_51_17 = iter_51_1.ignore_line_change

				iter_51_1.vertical_alignment = arg_51_2 and "top" or "top"

				local var_51_18 = iter_51_1.name
				local var_51_19 = var_51_6[var_51_18]

				if var_51_19 == true then
					var_51_19 = iter_51_1.text
					var_51_6[var_51_18] = var_51_19
				end

				if var_51_19 then
					var_51_16.text_id = var_51_18

					local var_51_20 = UIUtils.get_text_height(arg_51_3, var_51_14, iter_51_1, var_51_19)

					if not var_51_17 and not arg_51_2 then
						arg_51_9[2] = arg_51_9[2] + var_51_20
					end

					if arg_51_1 then
						iter_51_1.text_color[1] = var_51_0

						UIPasses.text.draw(arg_51_3, var_51_16, arg_51_5, arg_51_6, iter_51_1, var_51_6, arg_51_9, var_51_14, arg_51_11, arg_51_12)
					end

					if not var_51_17 then
						if arg_51_2 then
							arg_51_9[2] = arg_51_9[2] - var_51_20
						end

						var_51_15 = var_51_15 + var_51_20
					end
				end
			end

			local var_51_21 = var_51_8 + var_51_15

			arg_51_9[1] = var_51_9
			arg_51_9[2] = var_51_10
			arg_51_9[3] = var_51_11

			return var_51_21
		end
	},
	additional_option_info = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					255,
					0,
					0,
					0
				},
				text_pass_data = {},
				text_size = {},
				content = {
					text_content = {}
				},
				style = {
					image_edge_fade = {
						color = {
							255,
							255,
							255,
							255
						},
						size = {
							280,
							15
						}
					},
					text_styles = {
						{
							vertical_alignment = "center",
							name = "title",
							word_wrap = true,
							horizontal_alignment = "center",
							font_type = "hell_shark_header",
							font_size = var_0_6(28),
							text_color = Colors.get_color_table_with_alpha("font_title", 255)
						},
						{
							vertical_alignment = "center",
							name = "description",
							word_wrap = true,
							horizontal_alignment = "center",
							font_type = "hell_shark",
							font_size = var_0_6(18),
							text_color = Colors.get_color_table_with_alpha("font_default", 255)
						}
					}
				}
			}
		end,
		draw = function(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5, arg_53_6, arg_53_7, arg_53_8, arg_53_9, arg_53_10, arg_53_11, arg_53_12, arg_53_13)
			local var_53_0 = 255 * arg_53_4.alpha_multiplier
			local var_53_1 = arg_53_4.start_layer or var_0_3
			local var_53_2 = arg_53_0.frame_margin or 0
			local var_53_3 = arg_53_0.style
			local var_53_4 = arg_53_0.content
			local var_53_5 = var_53_3.text_styles
			local var_53_6 = var_53_4.text_content
			local var_53_7 = arg_53_13.title or arg_53_13.display_name
			local var_53_8 = arg_53_13.description

			if arg_53_7 and arg_53_7.localize then
				var_53_7 = Localize(var_53_7)

				local var_53_9 = arg_53_13.description_values

				var_53_8 = UIUtils.format_localized_description(var_53_8, var_53_9)
			end

			local var_53_10 = var_53_2 * 0.5
			local var_53_11 = arg_53_9[1]
			local var_53_12 = arg_53_9[2]
			local var_53_13 = arg_53_9[3]
			local var_53_14 = arg_53_0.frame_name
			local var_53_15 = UIFrameSettings[var_53_14].texture_sizes.horizontal[2]

			var_53_6.title = var_53_7
			var_53_6.description = var_53_8
			arg_53_9[1] = arg_53_9[1] + var_53_2
			arg_53_9[2] = arg_53_2 and arg_53_9[2] - var_53_10 or arg_53_9[2] + var_53_15
			arg_53_9[3] = var_53_1 + 5

			local var_53_16 = arg_53_0.text_size

			var_53_16[1] = arg_53_10[1] - var_53_2 * 2
			var_53_16[2] = 0

			local var_53_17 = -var_53_15
			local var_53_18 = arg_53_0.text_pass_data

			for iter_53_0, iter_53_1 in (arg_53_2 and ipairs or ripairs)(var_53_5) do
				local var_53_19 = iter_53_1.ignore_line_change

				iter_53_1.vertical_alignment = arg_53_2 and "top" or "top"

				local var_53_20 = iter_53_1.name
				local var_53_21 = var_53_6[var_53_20]

				if var_53_21 == true then
					var_53_21 = iter_53_1.text
					var_53_6[var_53_20] = var_53_21
				end

				if var_53_21 then
					var_53_18.text_id = var_53_20

					local var_53_22 = UIUtils.get_text_height(arg_53_3, var_53_16, iter_53_1, var_53_21)

					if not var_53_19 and not arg_53_2 then
						arg_53_9[2] = arg_53_9[2] + var_53_22
					end

					if arg_53_1 then
						iter_53_1.text_color[1] = var_53_0

						UIPasses.text.draw(arg_53_3, var_53_18, arg_53_5, arg_53_6, iter_53_1, var_53_6, arg_53_9, var_53_16, arg_53_11, arg_53_12)
					end

					if not var_53_19 then
						if arg_53_2 then
							arg_53_9[2] = arg_53_9[2] - var_53_22
						end

						var_53_17 = var_53_17 + var_53_22
					end
				end
			end

			local var_53_23 = var_53_10 + var_53_17

			arg_53_9[1] = var_53_11
			arg_53_9[2] = var_53_12
			arg_53_9[3] = var_53_13

			return var_53_23
		end
	},
	deed_mission = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {},
				style = {
					title_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("font_title", 255),
						offset = {
							0,
							0,
							0
						}
					},
					title_text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					},
					text = {
						word_wrap = true,
						horizontal_alignment = "left",
						vertical_alignment = "center",
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
						disabled_text_color = Colors.get_color_table_with_alpha("red", 255),
						offset = {
							0,
							0,
							0
						}
					},
					text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6, arg_55_7, arg_55_8, arg_55_9, arg_55_10, arg_55_11, arg_55_12, arg_55_13)
			local var_55_0 = arg_55_13.level_key

			if var_55_0 == nil then
				return 0
			end

			local var_55_1 = 255 * arg_55_4.alpha_multiplier
			local var_55_2 = arg_55_4.start_layer or var_0_3
			local var_55_3 = arg_55_0.frame_margin or 0
			local var_55_4 = arg_55_0.style
			local var_55_5 = arg_55_0.content
			local var_55_6 = arg_55_9[1]
			local var_55_7 = arg_55_9[2]
			local var_55_8 = arg_55_9[3]
			local var_55_9 = Localize("start_game_window_mission")
			local var_55_10 = LevelSettings[var_55_0].display_name
			local var_55_11 = Localize(var_55_10)
			local var_55_12 = var_55_4.text
			local var_55_13 = var_55_4.text_shadow
			local var_55_14 = var_55_4.title_text
			local var_55_15 = var_55_4.title_text_shadow
			local var_55_16 = arg_55_0.text_pass_data
			local var_55_17 = arg_55_0.text_size

			var_55_17[1] = arg_55_10[1] - var_55_3 * 2
			var_55_17[2] = 0

			local var_55_18 = UIUtils.get_text_height(arg_55_3, var_55_17, var_55_14, var_55_9)
			local var_55_19 = UIUtils.get_text_height(arg_55_3, var_55_17, var_55_12, var_55_11)
			local var_55_20 = var_55_18 + var_55_19

			var_55_17[2] = var_55_20

			if arg_55_1 then
				local var_55_21 = arg_55_9[1] + var_55_3

				arg_55_9[1] = var_55_21 + var_55_14.offset[1]
				arg_55_9[2] = var_55_7 - var_55_3 - var_55_18 + var_55_14.offset[2]
				arg_55_9[3] = var_55_2 + 6 + var_55_14.offset[3]
				var_55_17[1] = arg_55_10[1]
				var_55_5.text = var_55_9
				var_55_14.text_color[1] = var_55_1
				var_55_15.text_color[1] = var_55_1

				UIPasses.text.draw(arg_55_3, var_55_16, arg_55_5, arg_55_6, var_55_14, var_55_5, arg_55_9, var_55_17, arg_55_11, arg_55_12)

				arg_55_9[1] = var_55_21 + var_55_15.offset[1]
				arg_55_9[2] = var_55_7 - var_55_3 - var_55_18 + var_55_15.offset[2]
				arg_55_9[3] = var_55_2 + 6 + var_55_15.offset[3]

				UIPasses.text.draw(arg_55_3, var_55_16, arg_55_5, arg_55_6, var_55_15, var_55_5, arg_55_9, var_55_17, arg_55_11, arg_55_12)

				arg_55_9[1] = var_55_21 + var_55_12.offset[1]
				arg_55_9[2] = var_55_7 - var_55_3 * 1.5 - (var_55_18 + var_55_19) + var_55_12.offset[2]
				arg_55_9[3] = var_55_2 + 6 + var_55_12.offset[3]
				var_55_17[1] = arg_55_10[1]
				var_55_5.text = var_55_11
				var_55_12.text_color[1] = var_55_1
				var_55_13.text_color[1] = var_55_1

				UIPasses.text.draw(arg_55_3, var_55_16, arg_55_5, arg_55_6, var_55_12, var_55_5, arg_55_9, var_55_17, arg_55_11, arg_55_12)

				arg_55_9[1] = var_55_21 + var_55_13.offset[1]
				arg_55_9[2] = var_55_7 - var_55_3 * 1.5 - (var_55_18 + var_55_19) + var_55_13.offset[2]
				arg_55_9[3] = var_55_2 + 6 + var_55_13.offset[3]

				UIPasses.text.draw(arg_55_3, var_55_16, arg_55_5, arg_55_6, var_55_13, var_55_5, arg_55_9, var_55_17, arg_55_11, arg_55_12)
			end

			arg_55_9[1] = var_55_6
			arg_55_9[2] = var_55_7
			arg_55_9[3] = var_55_8

			return var_55_20
		end
	},
	deed_difficulty = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {},
				style = {
					title_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("font_title", 255),
						offset = {
							0,
							0,
							0
						}
					},
					title_text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					},
					text = {
						word_wrap = true,
						horizontal_alignment = "left",
						vertical_alignment = "center",
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
						disabled_text_color = Colors.get_color_table_with_alpha("red", 255),
						offset = {
							0,
							0,
							0
						}
					},
					text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_57_0, arg_57_1, arg_57_2, arg_57_3, arg_57_4, arg_57_5, arg_57_6, arg_57_7, arg_57_8, arg_57_9, arg_57_10, arg_57_11, arg_57_12, arg_57_13)
			local var_57_0 = 255 * arg_57_4.alpha_multiplier
			local var_57_1 = arg_57_4.start_layer or var_0_3
			local var_57_2 = arg_57_0.frame_margin or 0

			if arg_57_13.data.item_type ~= "deed" then
				return 0
			end

			local var_57_3 = arg_57_0.style
			local var_57_4 = arg_57_0.content
			local var_57_5 = arg_57_9[1]
			local var_57_6 = arg_57_9[2]
			local var_57_7 = arg_57_9[3]
			local var_57_8 = Localize("start_game_window_difficulty")
			local var_57_9 = arg_57_13.difficulty or "normal"
			local var_57_10 = DifficultySettings[var_57_9].display_name
			local var_57_11 = Localize(var_57_10)
			local var_57_12 = var_57_3.text
			local var_57_13 = var_57_3.text_shadow
			local var_57_14 = var_57_3.title_text
			local var_57_15 = var_57_3.title_text_shadow
			local var_57_16 = arg_57_0.text_pass_data
			local var_57_17 = arg_57_0.text_size

			var_57_17[1] = arg_57_10[1] - var_57_2 * 2
			var_57_17[2] = 0

			local var_57_18 = UIUtils.get_text_height(arg_57_3, var_57_17, var_57_14, var_57_8)
			local var_57_19 = UIUtils.get_text_height(arg_57_3, var_57_17, var_57_12, var_57_11)
			local var_57_20 = var_57_18 + var_57_19

			var_57_17[2] = var_57_20

			if arg_57_1 then
				local var_57_21 = arg_57_9[1] + var_57_2

				arg_57_9[1] = var_57_21 + var_57_14.offset[1]
				arg_57_9[2] = var_57_6 - var_57_2 - var_57_18 + var_57_14.offset[2]
				arg_57_9[3] = var_57_1 + 6 + var_57_14.offset[3]
				var_57_17[1] = arg_57_10[1]
				var_57_4.text = var_57_8
				var_57_14.text_color[1] = var_57_0
				var_57_15.text_color[1] = var_57_0

				UIPasses.text.draw(arg_57_3, var_57_16, arg_57_5, arg_57_6, var_57_14, var_57_4, arg_57_9, var_57_17, arg_57_11, arg_57_12)

				arg_57_9[1] = var_57_21 + var_57_15.offset[1]
				arg_57_9[2] = var_57_6 - var_57_2 - var_57_18 + var_57_15.offset[2]
				arg_57_9[3] = var_57_1 + 6 + var_57_15.offset[3]

				UIPasses.text.draw(arg_57_3, var_57_16, arg_57_5, arg_57_6, var_57_15, var_57_4, arg_57_9, var_57_17, arg_57_11, arg_57_12)

				arg_57_9[1] = var_57_21 + var_57_12.offset[1]
				arg_57_9[2] = var_57_6 - var_57_2 * 1.5 - (var_57_18 + var_57_19) + var_57_12.offset[2]
				arg_57_9[3] = var_57_1 + 6 + var_57_12.offset[3]
				var_57_17[1] = arg_57_10[1]
				var_57_4.text = var_57_11
				var_57_12.text_color[1] = var_57_0
				var_57_13.text_color[1] = var_57_0

				UIPasses.text.draw(arg_57_3, var_57_16, arg_57_5, arg_57_6, var_57_12, var_57_4, arg_57_9, var_57_17, arg_57_11, arg_57_12)

				arg_57_9[1] = var_57_21 + var_57_13.offset[1]
				arg_57_9[2] = var_57_6 - var_57_2 * 1.5 - (var_57_18 + var_57_19) + var_57_13.offset[2]
				arg_57_9[3] = var_57_1 + 6 + var_57_13.offset[3]

				UIPasses.text.draw(arg_57_3, var_57_16, arg_57_5, arg_57_6, var_57_13, var_57_4, arg_57_9, var_57_17, arg_57_11, arg_57_12)
			end

			arg_57_9[1] = var_57_5
			arg_57_9[2] = var_57_6
			arg_57_9[3] = var_57_7

			return var_57_20
		end
	},
	mutators = {
		setup_data = function(arg_58_0)
			return {
				default_icon = "icons_placeholder",
				text_pass_data = {},
				text_size = {
					0,
					0
				},
				icon_pass_data = {},
				icon_pass_definition = {
					texture_id = "icon",
					style_id = "icon"
				},
				icon_size = {
					40,
					40
				},
				content = {
					icon = "icons_placeholder"
				},
				style = {
					text = arg_58_0 and arg_58_0.text or {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						line_colors = {
							Colors.get_color_table_with_alpha("font_title", 255),
							Colors.get_color_table_with_alpha("font_default", 255)
						}
					},
					text_shadow = arg_58_0 and arg_58_0.text_shadow or {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					},
					icon = arg_58_0 and arg_58_0.icon or {
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
					}
				}
			}
		end,
		draw = function(arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4, arg_59_5, arg_59_6, arg_59_7, arg_59_8, arg_59_9, arg_59_10, arg_59_11, arg_59_12, arg_59_13)
			local var_59_0 = arg_59_13.data
			local var_59_1 = arg_59_13.mutators or var_59_0 and var_59_0.mutators

			if var_59_1 == nil then
				return 0
			end

			local var_59_2 = 255 * arg_59_4.alpha_multiplier
			local var_59_3, var_59_4 = 20, 20
			local var_59_5 = arg_59_4.start_layer or var_0_3
			local var_59_6 = arg_59_0.frame_margin or 0
			local var_59_7 = arg_59_0.style
			local var_59_8 = arg_59_0.content
			local var_59_9 = arg_59_9[1]
			local var_59_10 = arg_59_9[2]
			local var_59_11 = arg_59_9[3]

			arg_59_9[1] = arg_59_9[1] + var_59_6
			arg_59_9[2] = arg_59_9[2] - var_59_3
			arg_59_9[3] = var_59_5 + 2

			local var_59_12 = 10

			for iter_59_0, iter_59_1 in (arg_59_2 and ipairs or ripairs)(var_59_1) do
				local var_59_13 = MutatorTemplates[iter_59_1]
				local var_59_14 = var_59_13.display_name
				local var_59_15 = var_59_13.description
				local var_59_16 = var_59_13.icon
				local var_59_17 = "mutator_text_" .. iter_59_0
				local var_59_18 = var_59_7.text
				local var_59_19 = var_59_7.text_shadow
				local var_59_20 = arg_59_0.text_pass_data

				var_59_20.text_id = var_59_17

				local var_59_21 = Localize(var_59_14)
				local var_59_22 = Localize(var_59_15)
				local var_59_23 = arg_59_0.icon_pass_definition
				local var_59_24 = arg_59_0.icon_pass_data
				local var_59_25 = arg_59_0.style.icon
				local var_59_26 = arg_59_0.icon_size

				var_59_8.icon = var_59_16 or arg_59_0.default_icon

				local var_59_27 = var_59_21 .. "\n" .. var_59_22
				local var_59_28 = arg_59_0.text_size

				var_59_28[1] = arg_59_10[1] - var_59_6 * 3 - var_59_26[1]
				var_59_28[2] = 0

				local var_59_29 = UIUtils.get_text_height(arg_59_3, var_59_28, var_59_18, var_59_27)

				var_59_28[2] = var_59_29

				local var_59_30 = arg_59_9[1]
				local var_59_31 = arg_59_9[2]

				var_59_8[var_59_17] = var_59_27

				if arg_59_1 then
					var_59_25.color[1] = var_59_2
					arg_59_9[1] = var_59_30
					arg_59_9[2] = var_59_31 - var_59_26[2]

					UIPasses.texture.draw(arg_59_3, var_59_24, arg_59_5, var_59_23, var_59_25, var_59_8, arg_59_9, var_59_26, arg_59_11, arg_59_12)

					var_59_19.text_color[1] = var_59_2
					arg_59_9[1] = var_59_30 + var_59_26[1] + var_59_6 + var_59_19.offset[1]
					arg_59_9[2] = var_59_31 - var_59_29 + var_59_19.offset[2]
					arg_59_9[3] = var_59_5 + 2 + var_59_19.offset[3]

					UIPasses.text.draw(arg_59_3, var_59_20, arg_59_5, arg_59_6, var_59_19, var_59_8, arg_59_9, arg_59_0.text_size, arg_59_11, arg_59_12)

					var_59_18.text_color[1] = var_59_2

					local var_59_32 = var_59_18.line_colors

					var_59_32[1][1] = var_59_2
					var_59_32[2][1] = var_59_2
					arg_59_9[1] = var_59_30 + var_59_26[1] + var_59_6
					arg_59_9[2] = var_59_31 - var_59_29
					arg_59_9[3] = var_59_5 + 2

					UIPasses.text.draw(arg_59_3, var_59_20, arg_59_5, arg_59_6, var_59_18, var_59_8, arg_59_9, arg_59_0.text_size, arg_59_11, arg_59_12)
				end

				var_59_3 = var_59_3 + var_59_29

				if iter_59_0 ~= #var_59_1 then
					var_59_3 = var_59_3 + var_59_12
					arg_59_9[2] = var_59_31 - (var_59_29 + var_59_12)
					arg_59_9[1] = var_59_30
				end
			end

			arg_59_9[1] = var_59_9
			arg_59_9[2] = var_59_10
			arg_59_9[3] = var_59_11

			return var_59_3 + var_59_4
		end
	},
	deed_rewards = {
		setup_data = function()
			return {
				default_item_frame_texture = "item_frame",
				default_item_texture = "icons_placeholder",
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				divider_size = {
					264,
					32
				},
				item_size = {
					80,
					80
				},
				tooltip_pass_definition = {
					item_id = "item"
				},
				hotspot = {},
				content = {
					divider_texture = "divider_01_top",
					item_texture = "icons_placeholder"
				},
				style = {
					title_text = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("font_title", 255),
						offset = {
							0,
							0,
							0
						}
					},
					title_text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					},
					divider = {
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
					item = {
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
					item_frame = {
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
			}
		end,
		draw = function(arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4, arg_61_5, arg_61_6, arg_61_7, arg_61_8, arg_61_9, arg_61_10, arg_61_11, arg_61_12, arg_61_13)
			local var_61_0 = 255 * arg_61_4.alpha_multiplier
			local var_61_1 = arg_61_4.start_layer or var_0_3
			local var_61_2 = arg_61_0.frame_margin or 0
			local var_61_3 = arg_61_13.data

			if var_61_3.item_type ~= "deed" then
				return 0
			end

			local var_61_4 = arg_61_0.style
			local var_61_5 = arg_61_0.content
			local var_61_6 = arg_61_9[1]
			local var_61_7 = arg_61_9[2]
			local var_61_8 = arg_61_9[3]
			local var_61_9 = var_61_2 * 4
			local var_61_10 = Localize("deed_reward_title")
			local var_61_11 = var_61_4.title_text
			local var_61_12 = var_61_4.title_text_shadow
			local var_61_13 = arg_61_0.text_pass_data
			local var_61_14 = arg_61_0.text_size

			var_61_14[1] = arg_61_10[1] - var_61_2 * 2
			var_61_14[2] = 0

			local var_61_15 = UIUtils.get_text_height(arg_61_3, var_61_14, var_61_11, var_61_10)

			var_61_14[2] = var_61_15

			local var_61_16 = arg_61_0.divider_size
			local var_61_17 = arg_61_0.item_size

			if arg_61_1 then
				arg_61_9[1] = arg_61_9[1]

				local var_61_18 = arg_61_9[1]
				local var_61_19 = arg_61_9[2] - var_61_9

				arg_61_9[1] = var_61_18 + var_61_11.offset[1]
				arg_61_9[2] = var_61_19 + var_61_11.offset[2]
				arg_61_9[3] = var_61_1 + 6 + var_61_11.offset[3]
				var_61_14[1] = arg_61_10[1]
				var_61_5.text = var_61_10
				var_61_11.text_color[1] = var_61_0
				var_61_12.text_color[1] = var_61_0

				UIPasses.text.draw(arg_61_3, var_61_13, arg_61_5, arg_61_6, var_61_11, var_61_5, arg_61_9, var_61_14, arg_61_11, arg_61_12)

				arg_61_9[1] = var_61_18 + var_61_12.offset[1]
				arg_61_9[2] = var_61_19 + var_61_11.offset[2]
				arg_61_9[3] = var_61_1 + 6 + var_61_12.offset[3]

				UIPasses.text.draw(arg_61_3, var_61_13, arg_61_5, arg_61_6, var_61_12, var_61_5, arg_61_9, var_61_14, arg_61_11, arg_61_12)

				local var_61_20 = var_61_5.divider_texture
				local var_61_21 = var_61_4.divider.color

				var_61_21[1] = var_61_0
				arg_61_9[3] = var_61_1 + 6
				arg_61_9[2] = var_61_19 - var_61_15
				arg_61_9[1] = var_61_18 + (arg_61_10[1] / 2 - var_61_16[1] / 2)

				var_0_0.draw_texture(arg_61_3, var_61_20, arg_61_9, var_61_16, var_61_21)

				local var_61_22 = var_61_3.rewards
				local var_61_23 = #var_61_22
				local var_61_24 = 20
				local var_61_25 = -(var_61_23 - 1) * (40 + var_61_24 * 0.5)

				for iter_61_0 = 1, var_61_23 do
					local var_61_26 = var_61_22[iter_61_0]
					local var_61_27 = ItemMasterList[var_61_26]
					local var_61_28 = var_61_27.inventory_icon or arg_61_0.default_item_texture
					local var_61_29 = var_61_4.item
					local var_61_30 = var_61_29.color

					var_61_30[1] = var_61_0

					local var_61_31 = var_61_18 + (arg_61_10[1] / 2 - var_61_17[1] / 2) + var_61_25
					local var_61_32 = var_61_19 - (var_61_15 + var_61_17[2] + var_61_16[2] / 2)

					arg_61_9[1] = var_61_31
					arg_61_9[2] = var_61_32
					arg_61_9[3] = var_61_1 + 4

					local var_61_33 = arg_61_0.hotspot

					UIPasses.hover.draw(arg_61_3, var_61_13, arg_61_5, arg_61_6, var_61_29, var_61_33, arg_61_9, var_61_17, arg_61_11, arg_61_12)

					if var_61_33.is_hover then
						if not var_61_5.item then
							var_61_5.item = {
								data = var_61_27
							}
						else
							var_61_5.item.data = var_61_27
						end

						local var_61_34 = arg_61_0.tooltip_pass_definition

						if not arg_61_0.tooltip_pass_data then
							arg_61_0.tooltip_pass_data = UIPasses.item_tooltip.init(var_61_34, var_61_5, var_61_4)
						end

						local var_61_35 = arg_61_0.tooltip_pass_data

						UIPasses.item_tooltip.draw(arg_61_3, var_61_35, arg_61_5, var_61_34, var_61_4, var_61_5, arg_61_9, var_61_17, arg_61_11, arg_61_12)
					end

					arg_61_9[2] = var_61_32
					arg_61_9[1] = var_61_31
					arg_61_9[3] = var_61_1 + 4

					var_0_0.draw_texture(arg_61_3, var_61_28, arg_61_9, var_61_17, var_61_30)

					local var_61_36 = arg_61_0.default_item_frame_texture

					arg_61_9[3] = var_61_1 + 5

					var_0_0.draw_texture(arg_61_3, var_61_36, arg_61_9, var_61_17, var_61_30)

					var_61_25 = var_61_25 + var_61_17[1] + var_61_24
				end
			end

			local var_61_37 = var_61_9 + var_61_15 + var_61_16[2] + var_61_17[2]

			arg_61_9[1] = var_61_6
			arg_61_9[2] = var_61_7
			arg_61_9[3] = var_61_8

			return var_61_37
		end
	},
	event_mission = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {},
				style = {
					title_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("font_title", 255),
						offset = {
							0,
							0,
							0
						}
					},
					title_text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					},
					text = {
						word_wrap = true,
						horizontal_alignment = "left",
						vertical_alignment = "center",
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
						disabled_text_color = Colors.get_color_table_with_alpha("red", 255),
						offset = {
							0,
							0,
							0
						}
					},
					text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4, arg_63_5, arg_63_6, arg_63_7, arg_63_8, arg_63_9, arg_63_10, arg_63_11, arg_63_12, arg_63_13)
			local var_63_0 = 255 * arg_63_4.alpha_multiplier
			local var_63_1 = arg_63_4.start_layer or var_0_3
			local var_63_2 = arg_63_0.frame_margin or 0
			local var_63_3 = arg_63_0.style
			local var_63_4 = arg_63_0.content
			local var_63_5 = arg_63_9[1]
			local var_63_6 = arg_63_9[2]
			local var_63_7 = arg_63_9[3]
			local var_63_8 = Localize("start_game_window_mission")
			local var_63_9
			local var_63_10 = arg_63_13.level_key

			if var_63_10 then
				local var_63_11 = LevelSettings[var_63_10].display_name

				var_63_9 = Localize(var_63_11)
			else
				var_63_9 = Localize("random_level")
			end

			local var_63_12 = var_63_3.text
			local var_63_13 = var_63_3.text_shadow
			local var_63_14 = var_63_3.title_text
			local var_63_15 = var_63_3.title_text_shadow
			local var_63_16 = arg_63_0.text_pass_data
			local var_63_17 = arg_63_0.text_size

			var_63_17[1] = arg_63_10[1] - var_63_2 * 2
			var_63_17[2] = 0

			local var_63_18 = UIUtils.get_text_height(arg_63_3, var_63_17, var_63_14, var_63_8)
			local var_63_19 = UIUtils.get_text_height(arg_63_3, var_63_17, var_63_12, var_63_9)
			local var_63_20 = var_63_18 + var_63_19

			var_63_17[2] = var_63_20

			if arg_63_1 then
				local var_63_21 = arg_63_9[1] + var_63_2

				arg_63_9[1] = var_63_21 + var_63_14.offset[1]
				arg_63_9[2] = var_63_6 - var_63_2 - var_63_18 + var_63_14.offset[2]
				arg_63_9[3] = var_63_1 + 6 + var_63_14.offset[3]
				var_63_17[1] = arg_63_10[1]
				var_63_4.text = var_63_8
				var_63_14.text_color[1] = var_63_0
				var_63_15.text_color[1] = var_63_0

				UIPasses.text.draw(arg_63_3, var_63_16, arg_63_5, arg_63_6, var_63_14, var_63_4, arg_63_9, var_63_17, arg_63_11, arg_63_12)

				arg_63_9[1] = var_63_21 + var_63_15.offset[1]
				arg_63_9[2] = var_63_6 - var_63_2 - var_63_18 + var_63_15.offset[2]
				arg_63_9[3] = var_63_1 + 6 + var_63_15.offset[3]

				UIPasses.text.draw(arg_63_3, var_63_16, arg_63_5, arg_63_6, var_63_15, var_63_4, arg_63_9, var_63_17, arg_63_11, arg_63_12)

				arg_63_9[1] = var_63_21 + var_63_12.offset[1]
				arg_63_9[2] = var_63_6 - var_63_2 * 1.5 - (var_63_18 + var_63_19) + var_63_12.offset[2]
				arg_63_9[3] = var_63_1 + 6 + var_63_12.offset[3]
				var_63_17[1] = arg_63_10[1]
				var_63_4.text = var_63_9
				var_63_12.text_color[1] = var_63_0
				var_63_13.text_color[1] = var_63_0

				UIPasses.text.draw(arg_63_3, var_63_16, arg_63_5, arg_63_6, var_63_12, var_63_4, arg_63_9, var_63_17, arg_63_11, arg_63_12)

				arg_63_9[1] = var_63_21 + var_63_13.offset[1]
				arg_63_9[2] = var_63_6 - var_63_2 * 1.5 - (var_63_18 + var_63_19) + var_63_13.offset[2]
				arg_63_9[3] = var_63_1 + 6 + var_63_13.offset[3]

				UIPasses.text.draw(arg_63_3, var_63_16, arg_63_5, arg_63_6, var_63_13, var_63_4, arg_63_9, var_63_17, arg_63_11, arg_63_12)
			end

			arg_63_9[1] = var_63_5
			arg_63_9[2] = var_63_6
			arg_63_9[3] = var_63_7

			return var_63_20
		end
	},
	loot_chest_description = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {
					prefix = Localize("loot_chest_item_description")
				},
				style = {
					title_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(20),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						offset = {
							0,
							0,
							0
						}
					},
					title_text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(20),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6, arg_65_7, arg_65_8, arg_65_9, arg_65_10, arg_65_11, arg_65_12, arg_65_13)
			local var_65_0 = 255 * arg_65_4.alpha_multiplier
			local var_65_1 = arg_65_4.start_layer or var_0_3
			local var_65_2 = arg_65_0.frame_margin or 0

			if arg_65_13.data.item_type ~= "loot_chest" then
				return 0
			end

			local var_65_3 = arg_65_0.style
			local var_65_4 = arg_65_0.content
			local var_65_5 = arg_65_9[1]
			local var_65_6 = arg_65_9[2]
			local var_65_7 = arg_65_9[3]
			local var_65_8 = var_65_2
			local var_65_9 = var_65_4.prefix
			local var_65_10 = var_65_3.title_text
			local var_65_11 = var_65_3.title_text_shadow
			local var_65_12 = arg_65_0.text_pass_data
			local var_65_13 = arg_65_0.text_size
			local var_65_14 = arg_65_10[1] - var_65_2 * 2

			var_65_13[1] = var_65_14
			var_65_13[2] = 0

			local var_65_15 = UIUtils.get_text_height(arg_65_3, var_65_13, var_65_10, var_65_9)
			local var_65_16

			var_65_13[2], var_65_16 = var_65_15, var_65_8 + var_65_15

			if arg_65_1 then
				local var_65_17 = arg_65_9[1] + var_65_2
				local var_65_18 = arg_65_9[2] - var_65_16 + var_65_2 * 2

				arg_65_9[1] = var_65_17 + var_65_10.offset[1]
				arg_65_9[2] = var_65_18 - var_65_2 + var_65_10.offset[2]
				arg_65_9[3] = var_65_1 + 6 + var_65_10.offset[3]
				var_65_13[1] = var_65_14
				var_65_4.text = var_65_9
				var_65_10.text_color[1] = var_65_0
				var_65_11.text_color[1] = var_65_0

				UIPasses.text.draw(arg_65_3, var_65_12, arg_65_5, arg_65_6, var_65_10, var_65_4, arg_65_9, var_65_13, arg_65_11, arg_65_12)

				arg_65_9[1] = var_65_17 + var_65_11.offset[1]
				arg_65_9[2] = var_65_18 - var_65_2 + var_65_11.offset[2]
				arg_65_9[3] = var_65_1 + 6 + var_65_11.offset[3]

				UIPasses.text.draw(arg_65_3, var_65_12, arg_65_5, arg_65_6, var_65_11, var_65_4, arg_65_9, var_65_13, arg_65_11, arg_65_12)
			end

			arg_65_9[1] = var_65_5
			arg_65_9[2] = var_65_6
			arg_65_9[3] = var_65_7

			return var_65_16
		end
	},
	loot_chest_difficulty = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {
					prefix = Localize("loot_chest_obtained_at_difficulty") .. " "
				},
				style = {
					title_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(20),
						text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
						offset = {
							0,
							0,
							0
						}
					},
					title_text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(20),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5, arg_67_6, arg_67_7, arg_67_8, arg_67_9, arg_67_10, arg_67_11, arg_67_12, arg_67_13)
			local var_67_0 = 255 * arg_67_4.alpha_multiplier
			local var_67_1 = arg_67_4.start_layer or var_0_3
			local var_67_2 = arg_67_0.frame_margin or 0
			local var_67_3 = arg_67_13.data

			if var_67_3.item_type ~= "loot_chest" then
				return 0
			end

			if Managers.backend:get_interface("loot"):get_rarity_tables()[var_67_3.name] then
				arg_67_0.style.title_text.text_color = Colors.get_color_table_with_alpha("font_default", 255)
			else
				arg_67_0.style.title_text.text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255)
			end

			local var_67_4 = arg_67_0.style
			local var_67_5 = arg_67_0.content
			local var_67_6 = arg_67_9[1]
			local var_67_7 = arg_67_9[2]
			local var_67_8 = arg_67_9[3]
			local var_67_9 = var_67_2
			local var_67_10 = var_67_3.chest_categories

			if not var_67_10 then
				return 0
			end

			local var_67_11 = table.select_array(var_67_10, function(arg_68_0, arg_68_1)
				return DifficultySettings[arg_68_1] and Localize(DifficultySettings[arg_68_1].display_name)
			end)

			if table.is_empty(var_67_11) then
				return 0
			end

			local var_67_12 = table.concat(var_67_11, ", ")
			local var_67_13 = var_67_5.prefix .. var_67_12
			local var_67_14 = var_67_4.title_text
			local var_67_15 = var_67_4.title_text_shadow
			local var_67_16 = arg_67_0.text_pass_data
			local var_67_17 = arg_67_0.text_size
			local var_67_18 = arg_67_10[1] - var_67_2 * 2

			var_67_17[1] = var_67_18
			var_67_17[2] = 0

			local var_67_19 = UIUtils.get_text_height(arg_67_3, var_67_17, var_67_14, var_67_13)
			local var_67_20

			var_67_17[2], var_67_20 = var_67_19, var_67_9 + var_67_19

			if arg_67_1 then
				local var_67_21 = arg_67_9[1] + var_67_2
				local var_67_22 = arg_67_9[2] - var_67_20 + var_67_2 * 2

				arg_67_9[1] = var_67_21 + var_67_14.offset[1]
				arg_67_9[2] = var_67_22 - var_67_2 + var_67_14.offset[2]
				arg_67_9[3] = var_67_1 + 6 + var_67_14.offset[3]
				var_67_17[1] = var_67_18
				var_67_5.text = var_67_13
				var_67_14.text_color[1] = var_67_0
				var_67_15.text_color[1] = var_67_0

				UIPasses.text.draw(arg_67_3, var_67_16, arg_67_5, arg_67_6, var_67_14, var_67_5, arg_67_9, var_67_17, arg_67_11, arg_67_12)

				arg_67_9[1] = var_67_21 + var_67_15.offset[1]
				arg_67_9[2] = var_67_22 - var_67_2 + var_67_15.offset[2]
				arg_67_9[3] = var_67_1 + 6 + var_67_15.offset[3]

				UIPasses.text.draw(arg_67_3, var_67_16, arg_67_5, arg_67_6, var_67_15, var_67_5, arg_67_9, var_67_17, arg_67_11, arg_67_12)
			end

			arg_67_9[1] = var_67_6
			arg_67_9[2] = var_67_7
			arg_67_9[3] = var_67_8

			return var_67_20
		end
	},
	loot_chest_power_range = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {
					prefix = Localize("tooltips_power")
				},
				style = {
					title_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(20),
						text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
						offset = {
							0,
							0,
							0
						}
					},
					title_text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(20),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5, arg_70_6, arg_70_7, arg_70_8, arg_70_9, arg_70_10, arg_70_11, arg_70_12, arg_70_13)
			local var_70_0 = 255 * arg_70_4.alpha_multiplier
			local var_70_1 = arg_70_4.start_layer or var_0_3
			local var_70_2 = arg_70_0.frame_margin or 0
			local var_70_3 = arg_70_13.data

			if var_70_3.item_type ~= "loot_chest" then
				return 0
			end

			local var_70_4 = arg_70_0.style
			local var_70_5 = arg_70_0.content
			local var_70_6 = arg_70_9[1]
			local var_70_7 = arg_70_9[2]
			local var_70_8 = arg_70_9[3]
			local var_70_9 = var_70_2

			if not var_70_3.power_level_key then
				return 0
			end

			local var_70_10 = Managers.backend:get_interface("loot")
			local var_70_11 = var_70_10:get_rarity_tables()
			local var_70_12 = var_70_3.name

			if var_70_11[var_70_12] then
				var_70_4.title_text.text_color = Colors.get_color_table_with_alpha("font_default", 255)
			else
				var_70_4.title_text.text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255)
			end

			local var_70_13 = var_70_10:get_power_level_settings()
			local var_70_14 = var_70_13.power_level_tables[var_70_12]
			local var_70_15 = var_70_13.pivots[var_70_14]

			if not var_70_15 then
				return 0
			end

			local var_70_16
			local var_70_17 = arg_70_8.achievement_id

			if var_70_17 then
				if AchievementManager.STORE_COMPLETED_LEVEL then
					if arg_70_8.completed and not arg_70_8.claimed then
						local var_70_18 = Managers.backend:get_interface("statistics"):get_achievement_reward_level(var_70_17)

						var_70_16 = var_70_18 and math.min(var_70_18, LootChestData.LEVEL_USED_FOR_POOL_LEVELS)
					else
						return 0
					end
				elseif arg_70_8.claimed then
					return 0
				end
			elseif arg_70_8.difficulty_key then
				var_70_16 = ExperienceSettings.get_reward_level()
			else
				var_70_16 = var_70_10:get_highest_chest_level(var_70_12)
			end

			var_70_16 = var_70_16 or ExperienceSettings.get_reward_level()

			local var_70_19, var_70_20, var_70_21 = LootChestData.calculate_power_level(var_70_16, var_70_15)
			local var_70_22 = math.min(var_70_20, var_70_21)
			local var_70_23 = var_70_3.chest_tier or 1
			local var_70_24 = var_70_13.bonus_min_power_level_per_tier
			local var_70_25 = math.min(var_70_19 + (var_70_23 - 1) * var_70_24, var_70_22)
			local var_70_26 = string.format("%s: %d - %d", var_70_5.prefix, math.round(var_70_25), math.round(var_70_22))
			local var_70_27 = var_70_4.title_text
			local var_70_28 = var_70_4.title_text_shadow
			local var_70_29 = arg_70_0.text_pass_data
			local var_70_30 = arg_70_0.text_size
			local var_70_31 = arg_70_10[1] - var_70_2 * 2

			var_70_30[1] = var_70_31
			var_70_30[2] = 0

			local var_70_32 = UIUtils.get_text_height(arg_70_3, var_70_30, var_70_27, var_70_26)
			local var_70_33

			var_70_30[2], var_70_33 = var_70_32, var_70_9 + var_70_32

			if arg_70_1 then
				local var_70_34 = arg_70_9[1] + var_70_2
				local var_70_35 = arg_70_9[2] - var_70_33 + var_70_2 * 2

				arg_70_9[1] = var_70_34 + var_70_27.offset[1]
				arg_70_9[2] = var_70_35 - var_70_2 + var_70_27.offset[2]
				arg_70_9[3] = var_70_1 + 6 + var_70_27.offset[3]
				var_70_30[1] = var_70_31
				var_70_5.text = var_70_26
				var_70_27.text_color[1] = var_70_0
				var_70_28.text_color[1] = var_70_0

				UIPasses.text.draw(arg_70_3, var_70_29, arg_70_5, arg_70_6, var_70_27, var_70_5, arg_70_9, var_70_30, arg_70_11, arg_70_12)

				arg_70_9[1] = var_70_34 + var_70_28.offset[1]
				arg_70_9[2] = var_70_35 - var_70_2 + var_70_28.offset[2]
				arg_70_9[3] = var_70_1 + 6 + var_70_28.offset[3]

				UIPasses.text.draw(arg_70_3, var_70_29, arg_70_5, arg_70_6, var_70_28, var_70_5, arg_70_9, var_70_30, arg_70_11, arg_70_12)
			end

			arg_70_9[1] = var_70_6
			arg_70_9[2] = var_70_7
			arg_70_9[3] = var_70_8

			return var_70_33
		end
	},
	item_rarity_rate = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {
					prefix = Localize("loot_chest_rarity_rates") .. " "
				},
				style = {
					title_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(20),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						offset = {
							0,
							0,
							0
						}
					}
				},
				format_rarity_rate = function(arg_72_0, arg_72_1)
					local var_72_0 = arg_72_0[arg_72_1]
					local var_72_1
					local var_72_2 = var_72_0 == 0 and "0" or var_72_0 < 1 and "<1" or math.round(var_72_0)
					local var_72_3 = Colors.color_definitions[arg_72_1]

					return string.format("{#color(%d,%d,%d,%d)}%s%%{#reset()}", var_72_3[2], var_72_3[3], var_72_3[4], var_72_3[1], var_72_2)
				end
			}
		end,
		draw = function(arg_73_0, arg_73_1, arg_73_2, arg_73_3, arg_73_4, arg_73_5, arg_73_6, arg_73_7, arg_73_8, arg_73_9, arg_73_10, arg_73_11, arg_73_12, arg_73_13)
			local var_73_0 = arg_73_13.data

			if var_73_0.item_type ~= "loot_chest" then
				return 0
			end

			local var_73_1 = var_73_0.name

			if not var_73_1 then
				return 0
			end

			local var_73_2 = 255 * arg_73_4.alpha_multiplier
			local var_73_3 = arg_73_4.start_layer or var_0_3
			local var_73_4 = arg_73_0.frame_margin or 0
			local var_73_5 = arg_73_0.style
			local var_73_6 = arg_73_0.content
			local var_73_7 = arg_73_9[1]
			local var_73_8 = arg_73_9[2]
			local var_73_9 = arg_73_9[3]
			local var_73_10 = var_73_4
			local var_73_11 = Managers.backend:get_interface("loot"):get_formatted_rarity_tables()[var_73_1]

			if not var_73_11 then
				return 0
			end

			local var_73_12 = arg_73_0.format_rarity_rate(var_73_11, "plentiful")
			local var_73_13 = arg_73_0.format_rarity_rate(var_73_11, "common")
			local var_73_14 = arg_73_0.format_rarity_rate(var_73_11, "rare")
			local var_73_15 = arg_73_0.format_rarity_rate(var_73_11, "exotic")
			local var_73_16 = arg_73_0.format_rarity_rate(var_73_11, "unique")
			local var_73_17 = string.format("%s | %s | %s | %s | %s", var_73_12, var_73_13, var_73_14, var_73_15, var_73_16)
			local var_73_18 = var_73_6.prefix .. var_73_17
			local var_73_19 = var_73_5.title_text
			local var_73_20 = arg_73_0.text_pass_data
			local var_73_21 = arg_73_0.text_size
			local var_73_22 = arg_73_10[1] - var_73_4 * 2

			var_73_21[1] = var_73_22
			var_73_21[2] = 0

			local var_73_23 = UIUtils.get_text_height(arg_73_3, var_73_21, var_73_19, var_73_18)
			local var_73_24

			var_73_21[2], var_73_24 = var_73_23, var_73_10 + var_73_23

			if arg_73_1 then
				local var_73_25 = arg_73_9[1] + var_73_4
				local var_73_26 = arg_73_9[2] - var_73_24 + var_73_4 * 2

				arg_73_9[1] = var_73_25 + var_73_19.offset[1]
				arg_73_9[2] = var_73_26 - var_73_4 + var_73_19.offset[2]
				arg_73_9[3] = var_73_3 + 6 + var_73_19.offset[3]
				var_73_21[1] = var_73_22
				var_73_6.text = var_73_18
				var_73_19.text_color[1] = var_73_2

				UIPasses.text.draw(arg_73_3, var_73_20, arg_73_5, arg_73_6, var_73_19, var_73_6, arg_73_9, var_73_21, arg_73_11, arg_73_12)
			end

			arg_73_9[1] = var_73_7
			arg_73_9[2] = var_73_8
			arg_73_9[3] = var_73_9

			return var_73_24
		end
	},
	item_information_text = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {
					prefix = Localize("weapon_skin_item_description")
				},
				style = {
					title_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(20),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						offset = {
							0,
							0,
							0
						}
					},
					title_text_shadow = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(20),
						text_color = Colors.get_color_table_with_alpha("black", 255),
						offset = {
							1,
							-1,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_75_0, arg_75_1, arg_75_2, arg_75_3, arg_75_4, arg_75_5, arg_75_6, arg_75_7, arg_75_8, arg_75_9, arg_75_10, arg_75_11, arg_75_12, arg_75_13)
			local var_75_0 = 255 * arg_75_4.alpha_multiplier
			local var_75_1 = arg_75_4.start_layer or var_0_3
			local var_75_2 = arg_75_0.frame_margin or 0
			local var_75_3 = arg_75_13.data
			local var_75_4 = var_75_3.item_type

			if var_75_4 == "crafting_material" or var_75_4 == "weapon_skin" or var_75_4 == "keep_decoration_painting" or CosmeticUtils.is_cosmetic_item(var_75_4) then
				local var_75_5 = arg_75_0.style
				local var_75_6 = arg_75_0.content
				local var_75_7 = arg_75_9[1]
				local var_75_8 = arg_75_9[2]
				local var_75_9 = arg_75_9[3]
				local var_75_10 = var_75_2
				local var_75_11 = var_75_3.information_text
				local var_75_12 = var_75_11 and Localize(var_75_11) or "n/a"
				local var_75_13 = var_75_5.title_text
				local var_75_14 = var_75_5.title_text_shadow
				local var_75_15 = arg_75_0.text_pass_data
				local var_75_16 = arg_75_0.text_size
				local var_75_17 = arg_75_10[1] - var_75_2 * 2

				var_75_16[1] = var_75_17
				var_75_16[2] = 0

				local var_75_18 = UIUtils.get_text_height(arg_75_3, var_75_16, var_75_13, var_75_12)
				local var_75_19 = var_75_10 + var_75_18

				var_75_16[2] = var_75_18

				if arg_75_1 then
					local var_75_20 = arg_75_9[1] + var_75_2
					local var_75_21 = arg_75_9[2] - var_75_19 + var_75_2 * 2

					arg_75_9[1] = var_75_20 + var_75_13.offset[1]
					arg_75_9[2] = var_75_21 - var_75_2 + var_75_13.offset[2]
					arg_75_9[3] = var_75_1 + 6 + var_75_13.offset[3]
					var_75_16[1] = var_75_17
					var_75_6.text = var_75_12
					var_75_13.text_color[1] = var_75_0
					var_75_14.text_color[1] = var_75_0

					UIPasses.text.draw(arg_75_3, var_75_15, arg_75_5, arg_75_6, var_75_13, var_75_6, arg_75_9, var_75_16, arg_75_11, arg_75_12)

					arg_75_9[1] = var_75_20 + var_75_14.offset[1]
					arg_75_9[2] = var_75_21 - var_75_2 + var_75_14.offset[2]
					arg_75_9[3] = var_75_1 + 6 + var_75_14.offset[3]

					UIPasses.text.draw(arg_75_3, var_75_15, arg_75_5, arg_75_6, var_75_14, var_75_6, arg_75_9, var_75_16, arg_75_11, arg_75_12)
				end

				arg_75_9[1] = var_75_7
				arg_75_9[2] = var_75_8
				arg_75_9[3] = var_75_9

				return var_75_19
			end

			return 0
		end
	},
	weapon_skin_title = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {
					sufix_text = " " .. Localize("item_skin_applied_prefix")
				},
				style = {
					text = {
						vertical_alignment = "center",
						name = "description",
						localize = false,
						word_wrap = true,
						horizontal_alignment = "center",
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("promo", 255)
					}
				}
			}
		end,
		draw = function(arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4, arg_77_5, arg_77_6, arg_77_7, arg_77_8, arg_77_9, arg_77_10, arg_77_11, arg_77_12, arg_77_13)
			if Development.parameter("enable_detailed_tooltips") and (arg_77_11:get("item_compare") or arg_77_11:get("item_detail")) then
				local var_77_0 = arg_77_13.data.slot_type

				if var_77_0 == "melee" or var_77_0 == "ranged" then
					return 0
				end
			end

			local var_77_1 = 255 * arg_77_4.alpha_multiplier
			local var_77_2 = arg_77_4.start_layer or var_0_3
			local var_77_3 = arg_77_0.frame_margin or 0
			local var_77_4 = arg_77_0.content
			local var_77_5 = arg_77_0.style
			local var_77_6 = arg_77_13.data
			local var_77_7 = arg_77_13.skin

			if var_77_6.item_type ~= "weapon_skin" then
				return 0
			end

			if var_77_7 then
				local var_77_8 = WeaponSkins.matching_weapon_skin_item_key(var_77_7)
				local var_77_9 = var_77_8 and string.match(var_77_8, "^([%w_]+)_skin$")
				local var_77_10 = rawget(ItemMasterList, var_77_9)
				local var_77_11 = var_77_10 and var_77_10.item_type or "lb_unknown"

				var_77_4.text = Localize(var_77_11) .. var_77_4.sufix_text

				local var_77_12 = arg_77_9[1]
				local var_77_13 = arg_77_9[2]
				local var_77_14 = arg_77_9[3]

				arg_77_9[3] = var_77_2 + 5

				local var_77_15 = var_77_5.text
				local var_77_16 = arg_77_0.text_pass_data
				local var_77_17 = arg_77_0.text_size

				var_77_17[1] = arg_77_10[1] - var_77_3 * 2
				var_77_17[2] = 0

				local var_77_18 = UIUtils.get_text_height(arg_77_3, var_77_17, var_77_15, var_77_4.text)

				var_77_17[2] = var_77_18

				if arg_77_1 then
					arg_77_9[1] = var_77_12 + var_77_3
					arg_77_9[2] = arg_77_9[2] - var_77_18
					var_77_15.text_color[1] = var_77_1

					UIPasses.text.draw(arg_77_3, var_77_16, arg_77_5, arg_77_6, var_77_15, var_77_4, arg_77_9, var_77_17, arg_77_11, arg_77_12)
				end

				arg_77_9[1] = var_77_12
				arg_77_9[2] = var_77_13
				arg_77_9[3] = var_77_14

				return var_77_18
			else
				return 0
			end
		end
	},
	console_keywords = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {},
				style = {
					text = {
						vertical_alignment = "center",
						name = "description",
						localize = false,
						word_wrap = true,
						horizontal_alignment = "center",
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("forest_green", 255)
					}
				}
			}
		end,
		draw = function(arg_79_0, arg_79_1, arg_79_2, arg_79_3, arg_79_4, arg_79_5, arg_79_6, arg_79_7, arg_79_8, arg_79_9, arg_79_10, arg_79_11, arg_79_12, arg_79_13)
			if Development.parameter("enable_detailed_tooltips") and (arg_79_11:get("item_compare") or arg_79_11:get("item_detail")) then
				local var_79_0 = arg_79_13.data.slot_type

				if var_79_0 == "melee" or var_79_0 == "ranged" then
					return 0
				end
			end

			local var_79_1 = 255 * arg_79_4.alpha_multiplier
			local var_79_2 = arg_79_4.start_layer or var_0_3
			local var_79_3 = arg_79_0.frame_margin or 0
			local var_79_4 = arg_79_0.content
			local var_79_5 = arg_79_0.style
			local var_79_6 = arg_79_13.backend_id
			local var_79_7 = arg_79_13.data
			local var_79_8 = var_79_7.slot_type

			if not (var_79_8 == "melee" or var_79_8 == "ranged") then
				return 0
			end

			local var_79_9 = BackendUtils.get_item_template(var_79_7, var_79_6).tooltip_keywords

			if var_79_9 then
				local var_79_10 = ""
				local var_79_11 = #var_79_9

				for iter_79_0, iter_79_1 in ipairs(var_79_9) do
					var_79_10 = var_79_10 .. Localize(iter_79_1)
					var_79_11 = var_79_11 - 1

					if var_79_11 > 0 then
						var_79_10 = var_79_10 .. ", "
					end
				end

				var_79_4.text = var_79_10

				local var_79_12 = arg_79_9[1]
				local var_79_13 = arg_79_9[2]
				local var_79_14 = arg_79_9[3]

				arg_79_9[3] = var_79_2 + 5

				local var_79_15 = var_79_5.text
				local var_79_16 = arg_79_0.text_pass_data
				local var_79_17 = arg_79_0.text_size

				var_79_17[1] = arg_79_10[1] - var_79_3 * 2
				var_79_17[2] = 0

				local var_79_18 = UIUtils.get_text_height(arg_79_3, var_79_17, var_79_15, var_79_10)

				var_79_17[2] = var_79_18

				local var_79_19 = var_79_18 + var_79_3 * 0.5

				if arg_79_1 then
					arg_79_9[1] = var_79_12
					arg_79_9[2] = var_79_13
					arg_79_9[1] = var_79_12 + var_79_3
					arg_79_9[2] = arg_79_9[2] - var_79_19 + var_79_3
					var_79_15.text_color[1] = var_79_1

					UIPasses.text.draw(arg_79_3, var_79_16, arg_79_5, arg_79_6, var_79_15, var_79_4, arg_79_9, var_79_17, arg_79_11, arg_79_12)
				end

				arg_79_9[1] = var_79_12
				arg_79_9[2] = var_79_13
				arg_79_9[3] = var_79_14

				return var_79_19
			end

			return 0
		end
	},
	keywords = {
		setup_data = function()
			return {
				background_color = {
					240,
					3,
					3,
					3
				},
				background_size = {
					0,
					50
				},
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				edge_size = {
					0,
					5
				},
				edge_holder_size = {
					9,
					17
				},
				content = {
					edge_holder_right = "menu_frame_12_divider_right",
					edge_texture = "menu_frame_12_divider",
					edge_holder_left = "menu_frame_12_divider_left"
				},
				style = {
					edge = {
						texture_size = {
							1,
							5
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
					},
					edge_holder = {
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
					text = {
						vertical_alignment = "top",
						name = "description",
						localize = false,
						word_wrap = true,
						horizontal_alignment = "center",
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("forest_green", 255)
					},
					background = {
						color = {
							150,
							0,
							0,
							0
						},
						offset = {
							0,
							0,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4, arg_81_5, arg_81_6, arg_81_7, arg_81_8, arg_81_9, arg_81_10, arg_81_11, arg_81_12, arg_81_13)
			if Development.parameter("enable_detailed_tooltips") and (arg_81_11:get("item_compare") or arg_81_11:get("item_detail")) then
				local var_81_0 = arg_81_13.data.slot_type

				if var_81_0 == "melee" or var_81_0 == "ranged" then
					return 0
				end
			end

			local var_81_1 = 255 * arg_81_4.alpha_multiplier
			local var_81_2 = arg_81_4.start_layer or var_0_3
			local var_81_3 = arg_81_0.frame_margin or 0
			local var_81_4 = arg_81_0.content
			local var_81_5 = arg_81_0.style
			local var_81_6 = arg_81_13.backend_id
			local var_81_7 = arg_81_13.data
			local var_81_8 = var_81_7.slot_type

			if not (var_81_8 == "melee" or var_81_8 == "ranged") then
				return 0
			end

			local var_81_9 = BackendUtils.get_item_template(var_81_7, var_81_6).tooltip_keywords

			if var_81_9 then
				local var_81_10 = ""

				if arg_81_13.hidden_description then
					local var_81_11 = #var_81_9

					for iter_81_0, iter_81_1 in ipairs(var_81_9) do
						var_81_10 = var_81_10 .. var_0_5
						var_81_11 = var_81_11 - 1

						if var_81_11 > 0 then
							var_81_10 = var_81_10 .. ", "
						end
					end
				else
					local var_81_12 = #var_81_9

					for iter_81_2, iter_81_3 in ipairs(var_81_9) do
						var_81_10 = var_81_10 .. Localize(iter_81_3)
						var_81_12 = var_81_12 - 1

						if var_81_12 > 0 then
							var_81_10 = var_81_10 .. ", "
						end
					end
				end

				var_81_4.text = var_81_10

				local var_81_13 = arg_81_9[1]
				local var_81_14 = arg_81_9[2]
				local var_81_15 = arg_81_9[3]

				arg_81_9[3] = var_81_2 + 5

				local var_81_16 = var_81_5.text
				local var_81_17 = arg_81_0.text_pass_data
				local var_81_18 = arg_81_0.text_size

				var_81_18[1] = arg_81_10[1] - var_81_3 * 2
				var_81_18[2] = 0

				local var_81_19 = UIUtils.get_text_height(arg_81_3, var_81_18, var_81_16, var_81_10)

				var_81_18[2] = var_81_19

				local var_81_20 = var_81_19 + var_81_3 * 0.5

				if arg_81_1 then
					local var_81_21 = arg_81_0.background_size
					local var_81_22 = var_81_5.background.color

					var_81_22[1] = var_81_1
					var_81_21[2] = var_81_20
					var_81_21[1] = arg_81_10[1]
					arg_81_9[2] = var_81_14 - var_81_21[2]
					arg_81_9[3] = var_81_2 + 3

					var_0_0.draw_rect(arg_81_3, arg_81_9, var_81_21, var_81_22)

					arg_81_9[1] = var_81_13
					arg_81_9[2] = var_81_14

					local var_81_23 = arg_81_0.edge_size

					var_81_23[1] = arg_81_10[1]

					local var_81_24 = var_81_5.edge
					local var_81_25 = var_81_24.color
					local var_81_26 = var_81_24.texture_size

					var_81_26[1] = arg_81_10[1]

					local var_81_27 = var_81_4.edge_texture

					var_81_25[1] = var_81_1
					arg_81_9[3] = var_81_2 + 4

					var_0_0.draw_tiled_texture(arg_81_3, var_81_27, arg_81_9, var_81_23, var_81_26, var_81_25)

					local var_81_28 = var_81_5.edge_holder
					local var_81_29 = arg_81_0.edge_holder_size
					local var_81_30 = var_81_28.color
					local var_81_31 = var_81_4.edge_holder_left
					local var_81_32 = var_81_4.edge_holder_right

					var_81_30[1] = var_81_1
					arg_81_9[1] = arg_81_9[1] + 3
					arg_81_9[2] = arg_81_9[2] - 6
					arg_81_9[3] = var_81_2 + 6

					var_0_0.draw_texture(arg_81_3, var_81_31, arg_81_9, var_81_29, var_81_30)

					arg_81_9[1] = arg_81_9[1] + var_81_23[1] - (var_81_29[1] + 6)

					var_0_0.draw_texture(arg_81_3, var_81_32, arg_81_9, var_81_29, var_81_30)

					arg_81_9[1] = var_81_13 + var_81_3
					arg_81_9[2] = arg_81_9[2] - var_81_20 + var_81_3
					var_81_16.text_color[1] = var_81_1

					UIPasses.text.draw(arg_81_3, var_81_17, arg_81_5, arg_81_6, var_81_16, var_81_4, arg_81_9, var_81_18, arg_81_11, arg_81_12)
				end

				arg_81_9[1] = var_81_13
				arg_81_9[2] = var_81_14
				arg_81_9[3] = var_81_15

				return var_81_20
			end

			return 0
		end
	},
	hero_power_gained = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				title_text_pass_data = {
					text_id = "title"
				},
				text_pass_data = {},
				text_size = {
					0,
					0
				},
				icon_pass_data = {},
				icon_pass_definition = {
					texture_id = "icon",
					style_id = "icon"
				},
				icon_size = {
					13,
					13
				},
				content = {
					icon = "tooltip_marker",
					title = Localize("tooltip_hero_power_calculation_header") .. ":",
					entry_list = {
						{
							power_level_key = "hero",
							text = Localize("tooltip_hero_power_description_level")
						},
						{
							power_level_key = "item",
							text = Localize("tooltip_hero_power_description_equipment")
						}
					},
					power_level_list = {}
				},
				style = {
					property_title = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					entry_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						color_override = {},
						color_override_table = {
							start_index = 0,
							end_index = 0,
							color = Colors.get_color_table_with_alpha("white", 255)
						}
					},
					icon = {
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
					}
				}
			}
		end,
		draw = function(arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4, arg_83_5, arg_83_6, arg_83_7, arg_83_8, arg_83_9, arg_83_10, arg_83_11, arg_83_12)
			local var_83_0 = arg_83_4.player
			local var_83_1
			local var_83_2

			if var_83_0 then
				var_83_1 = var_83_0:profile_display_name()
				var_83_2 = var_83_0:career_name()

				if not var_83_1 or not var_83_2 then
					return 0
				end
			end

			local var_83_3 = arg_83_8.profile_index
			local var_83_4 = arg_83_8.career_index

			if var_83_3 and var_83_4 then
				local var_83_5 = SPProfiles[var_83_3]

				var_83_1 = var_83_5.display_name
				var_83_2 = var_83_5.careers[var_83_4].name
			end

			local var_83_6 = arg_83_4.start_layer or var_0_3
			local var_83_7 = 0
			local var_83_8 = arg_83_0.frame_margin or 0
			local var_83_9 = arg_83_0.style
			local var_83_10 = arg_83_0.content
			local var_83_11 = BackendUtils.get_total_power_level(var_83_1, var_83_2)
			local var_83_12 = UIUtils.presentable_hero_power_level(var_83_11)
			local var_83_13 = BackendUtils.get_average_item_power_level(var_83_2)
			local var_83_14 = BackendUtils.get_hero_power_level_from_level(var_83_1)
			local var_83_15 = var_83_10.power_level_list

			var_83_15.hero = math.floor(var_83_14)
			var_83_15.item = math.floor(var_83_13)

			local var_83_16 = 255 * arg_83_4.alpha_multiplier
			local var_83_17 = arg_83_9[1]
			local var_83_18 = arg_83_9[2]
			local var_83_19 = arg_83_9[3]
			local var_83_20 = 0

			arg_83_9[3] = var_83_6 + 2
			arg_83_9[1] = arg_83_9[1] + var_83_8

			local var_83_21 = var_83_9.property_title
			local var_83_22 = arg_83_0.title_text_pass_data
			local var_83_23 = var_83_10.title
			local var_83_24 = arg_83_0.text_size

			var_83_24[1] = arg_83_10[1] - (var_83_8 * 2 + var_83_8)
			var_83_24[2] = 0

			local var_83_25 = UIUtils.get_text_height(arg_83_3, var_83_24, var_83_21, var_83_23)

			var_83_24[2] = var_83_25
			arg_83_9[2] = arg_83_9[2] - var_83_25

			local var_83_26 = var_83_20 + var_83_25

			if arg_83_1 then
				var_83_21.text_color[1] = var_83_16

				UIPasses.text.draw(arg_83_3, var_83_22, arg_83_5, arg_83_6, var_83_21, var_83_10, arg_83_9, var_83_24, arg_83_11, arg_83_12)
			end

			local var_83_27 = var_83_26 + var_83_8 * 0.5

			arg_83_9[2] = arg_83_9[2] - var_83_8 * 0.5

			local var_83_28 = 1
			local var_83_29 = var_83_10.entry_list

			for iter_83_0, iter_83_1 in ipairs(var_83_29) do
				local var_83_30 = var_83_15[iter_83_1.power_level_key]
				local var_83_31 = iter_83_1.text .. " "
				local var_83_32 = tostring(var_83_30)
				local var_83_33 = var_83_31 .. var_83_32
				local var_83_34 = UTF8Utils.string_length(var_83_32) or 0
				local var_83_35 = UTF8Utils.string_length(var_83_31) or 0
				local var_83_36 = var_83_9.entry_text
				local var_83_37 = var_83_36.color_override_table

				var_83_37.start_index = var_83_35 + 1
				var_83_37.end_index = var_83_35 + var_83_34
				var_83_36.color_override[1] = var_83_37

				local var_83_38 = "entry_" .. var_83_28
				local var_83_39 = arg_83_0.text_pass_data

				var_83_39.text_id = var_83_38

				local var_83_40 = arg_83_0.text_size

				var_83_40[2] = 0

				local var_83_41 = UIUtils.get_text_height(arg_83_3, var_83_40, var_83_36, var_83_33)

				var_83_40[2] = var_83_41
				arg_83_9[2] = arg_83_9[2] - var_83_41

				local var_83_42 = arg_83_9[2]

				var_83_10[var_83_38] = var_83_33

				if arg_83_1 then
					local var_83_43 = arg_83_0.icon_pass_definition
					local var_83_44 = arg_83_0.icon_pass_data
					local var_83_45 = var_83_9.icon
					local var_83_46 = arg_83_0.icon_size

					var_83_45.color[1] = var_83_16
					arg_83_9[2] = arg_83_9[2] + var_83_41 / 2 - var_83_46[2] / 2 - 2

					UIPasses.texture.draw(arg_83_3, var_83_44, arg_83_5, var_83_43, var_83_45, var_83_10, arg_83_9, var_83_46, arg_83_11, arg_83_12)

					arg_83_9[2] = var_83_42
					arg_83_9[1] = arg_83_9[1] + var_83_46[1]
					var_83_36.text_color[1] = var_83_16

					UIPasses.text.draw(arg_83_3, var_83_39, arg_83_5, arg_83_6, var_83_36, var_83_10, arg_83_9, arg_83_0.text_size, arg_83_11, arg_83_12)

					arg_83_9[1] = arg_83_9[1] - var_83_46[1]
				end

				var_83_27 = var_83_27 + var_83_41
				arg_83_9[2] = var_83_42
			end

			local var_83_47 = var_83_28 + 1
			local var_83_48 = var_83_27 + var_83_7

			arg_83_9[1] = var_83_17
			arg_83_9[2] = var_83_18
			arg_83_9[3] = var_83_19

			return var_83_48
		end
	},
	hero_power_perks = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				title_text_pass_data = {
					text_id = "title"
				},
				text_pass_data = {},
				text_size = {
					0,
					0
				},
				icon_pass_data = {},
				icon_pass_definition = {
					texture_id = "icon",
					style_id = "icon"
				},
				icon_size = {
					13,
					13
				},
				content = {
					icon = "tooltip_marker",
					title = Localize("tooltip_hero_power_affects_header") .. ":",
					entry_list = {
						{
							text = Localize("tooltip_hero_power_description_affects_damage")
						},
						{
							text = Localize("tooltip_hero_power_description_affects_cleave")
						},
						{
							text = Localize("tooltip_hero_power_description_affects_stagger")
						}
					}
				},
				style = {
					property_title = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					entry_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						color_override = {},
						color_override_table = {
							start_index = 0,
							end_index = 0,
							color = Colors.get_color_table_with_alpha("font_default", 255)
						}
					},
					icon = {
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
					}
				}
			}
		end,
		draw = function(arg_85_0, arg_85_1, arg_85_2, arg_85_3, arg_85_4, arg_85_5, arg_85_6, arg_85_7, arg_85_8, arg_85_9, arg_85_10, arg_85_11, arg_85_12)
			local var_85_0 = arg_85_4.start_layer or var_0_3
			local var_85_1 = 0
			local var_85_2 = arg_85_0.frame_margin or 0
			local var_85_3 = arg_85_0.style
			local var_85_4 = arg_85_0.content
			local var_85_5 = 255 * arg_85_4.alpha_multiplier
			local var_85_6 = arg_85_9[1]
			local var_85_7 = arg_85_9[2]
			local var_85_8 = arg_85_9[3]
			local var_85_9 = 0

			arg_85_9[3] = var_85_0 + 2
			arg_85_9[2] = arg_85_9[2]
			arg_85_9[1] = arg_85_9[1] + var_85_2

			local var_85_10 = var_85_3.property_title
			local var_85_11 = arg_85_0.title_text_pass_data
			local var_85_12 = var_85_4.title
			local var_85_13 = arg_85_0.text_size

			var_85_13[1] = arg_85_10[1] - (var_85_2 * 2 + var_85_2)
			var_85_13[2] = 0

			local var_85_14 = UIUtils.get_text_height(arg_85_3, var_85_13, var_85_10, var_85_12)

			var_85_13[2] = var_85_14
			arg_85_9[2] = arg_85_9[2] - var_85_14

			local var_85_15 = var_85_9 + var_85_14

			if arg_85_1 then
				var_85_10.text_color[1] = var_85_5

				UIPasses.text.draw(arg_85_3, var_85_11, arg_85_5, arg_85_6, var_85_10, var_85_4, arg_85_9, var_85_13, arg_85_11, arg_85_12)
			end

			local var_85_16 = var_85_15 + var_85_2 * 0.5

			arg_85_9[2] = arg_85_9[2] - var_85_2 * 0.5

			local var_85_17 = 1
			local var_85_18 = var_85_4.entry_list

			for iter_85_0, iter_85_1 in ipairs(var_85_18) do
				local var_85_19 = iter_85_1.text
				local var_85_20 = "entry_" .. var_85_17
				local var_85_21 = var_85_3.entry_text
				local var_85_22 = arg_85_0.text_pass_data

				var_85_22.text_id = var_85_20

				local var_85_23 = arg_85_0.text_size

				var_85_23[2] = 0

				local var_85_24 = UIUtils.get_text_height(arg_85_3, var_85_23, var_85_21, var_85_19)

				var_85_23[2] = var_85_24
				arg_85_9[2] = arg_85_9[2] - var_85_24

				local var_85_25 = arg_85_9[2]

				var_85_4[var_85_20] = var_85_19

				if arg_85_1 then
					local var_85_26 = arg_85_0.icon_pass_definition
					local var_85_27 = arg_85_0.icon_pass_data
					local var_85_28 = var_85_3.icon
					local var_85_29 = arg_85_0.icon_size

					var_85_28.color[1] = var_85_5
					arg_85_9[2] = arg_85_9[2] + var_85_24 / 2 - var_85_29[2] / 2 - 2

					UIPasses.texture.draw(arg_85_3, var_85_27, arg_85_5, var_85_26, var_85_28, var_85_4, arg_85_9, var_85_29, arg_85_11, arg_85_12)

					arg_85_9[2] = var_85_25
					arg_85_9[1] = arg_85_9[1] + var_85_29[1]
					var_85_21.text_color[1] = var_85_5

					UIPasses.text.draw(arg_85_3, var_85_22, arg_85_5, arg_85_6, var_85_21, var_85_4, arg_85_9, arg_85_0.text_size, arg_85_11, arg_85_12)

					arg_85_9[1] = arg_85_9[1] - var_85_29[1]
				end

				var_85_16 = var_85_16 + var_85_24
				arg_85_9[2] = var_85_25
			end

			local var_85_30 = var_85_17 + 1
			local var_85_31 = var_85_16 + var_85_1

			arg_85_9[1] = var_85_6
			arg_85_9[2] = var_85_7
			arg_85_9[3] = var_85_8

			return var_85_31
		end
	},
	hero_power_description = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				edge_size = {
					0,
					5
				},
				edge_holder_size = {
					9,
					17
				},
				content = {
					edge_texture = "menu_frame_12_divider",
					edge_holder_left = "menu_frame_12_divider_left",
					edge_holder_right = "menu_frame_12_divider_right",
					text = Localize("tooltip_hero_power_description_calculation")
				},
				style = {
					edge = {
						texture_size = {
							1,
							5
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
					},
					edge_holder = {
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
					text = {
						vertical_alignment = "center",
						name = "description",
						localize = false,
						word_wrap = true,
						horizontal_alignment = "left",
						font_type = "hell_shark",
						font_size = var_0_6(14),
						text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
					}
				}
			}
		end,
		draw = function(arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6, arg_87_7, arg_87_8, arg_87_9, arg_87_10, arg_87_11, arg_87_12)
			local var_87_0 = 255 * arg_87_4.alpha_multiplier
			local var_87_1 = arg_87_4.start_layer or var_0_3
			local var_87_2 = arg_87_0.frame_margin or 0
			local var_87_3 = arg_87_0.content
			local var_87_4 = arg_87_0.style
			local var_87_5 = arg_87_9[1]
			local var_87_6 = arg_87_9[2]
			local var_87_7 = arg_87_9[3]

			arg_87_9[3] = var_87_1 + 5

			local var_87_8 = var_87_4.text
			local var_87_9 = arg_87_0.text_pass_data
			local var_87_10 = arg_87_0.text_size

			var_87_10[1] = arg_87_10[1] - var_87_2 * 2
			var_87_10[2] = 0

			local var_87_11 = UIUtils.get_text_height(arg_87_3, var_87_10, var_87_8, var_87_3.text)

			var_87_10[2] = var_87_11

			local var_87_12 = var_87_11 + var_87_2 * 0.5

			if arg_87_1 then
				local var_87_13 = arg_87_0.edge_size

				var_87_13[1] = arg_87_10[1]

				local var_87_14 = var_87_4.edge
				local var_87_15 = var_87_14.color
				local var_87_16 = var_87_14.texture_size

				var_87_16[1] = arg_87_10[1]

				local var_87_17 = var_87_3.edge_texture

				var_87_15[1] = var_87_0

				local var_87_18 = arg_87_9[2] - var_87_2 * 0.5

				arg_87_9[2] = var_87_18
				arg_87_9[3] = var_87_1 + 4

				var_0_0.draw_tiled_texture(arg_87_3, var_87_17, arg_87_9, var_87_13, var_87_16, var_87_15)

				local var_87_19 = var_87_4.edge_holder
				local var_87_20 = arg_87_0.edge_holder_size
				local var_87_21 = var_87_19.color
				local var_87_22 = var_87_3.edge_holder_left
				local var_87_23 = var_87_3.edge_holder_right

				var_87_21[1] = var_87_0
				arg_87_9[1] = arg_87_9[1] + 3
				arg_87_9[2] = var_87_18 - 6
				arg_87_9[3] = var_87_1 + 6

				var_0_0.draw_texture(arg_87_3, var_87_22, arg_87_9, var_87_20, var_87_21)

				arg_87_9[1] = arg_87_9[1] + var_87_13[1] - (var_87_20[1] + 6)

				var_0_0.draw_texture(arg_87_3, var_87_23, arg_87_9, var_87_20, var_87_21)

				arg_87_9[1] = var_87_5 + var_87_2
				arg_87_9[2] = var_87_18 - var_87_12 + var_87_2 * 0.5
				var_87_8.text_color[1] = var_87_0

				UIPasses.text.draw(arg_87_3, var_87_9, arg_87_5, arg_87_6, var_87_8, var_87_3, arg_87_9, var_87_10, arg_87_11, arg_87_12)
			end

			arg_87_9[1] = var_87_5
			arg_87_9[2] = var_87_6
			arg_87_9[3] = var_87_7

			return var_87_12
		end
	},
	hero_power_title = {
		setup_data = function()
			return {
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {
					prefix_text = Localize("hero_power_header")
				},
				style = {
					text = {
						vertical_alignment = "center",
						name = "description",
						localize = false,
						word_wrap = true,
						horizontal_alignment = "center",
						font_type = "hell_shark_header",
						font_size = var_0_6(28),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					}
				}
			}
		end,
		draw = function(arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4, arg_89_5, arg_89_6, arg_89_7, arg_89_8, arg_89_9, arg_89_10, arg_89_11, arg_89_12)
			local var_89_0 = 255 * arg_89_4.alpha_multiplier
			local var_89_1 = arg_89_4.start_layer or var_0_3
			local var_89_2 = arg_89_0.frame_margin or 0
			local var_89_3 = arg_89_0.content
			local var_89_4 = arg_89_0.style

			var_89_3.text = var_89_3.prefix_text

			local var_89_5 = arg_89_9[1]
			local var_89_6 = arg_89_9[2]
			local var_89_7 = arg_89_9[3]

			arg_89_9[3] = var_89_1 + 5

			local var_89_8 = var_89_4.text
			local var_89_9 = arg_89_0.text_pass_data
			local var_89_10 = arg_89_0.text_size

			var_89_10[1] = arg_89_10[1] - var_89_2 * 2
			var_89_10[2] = 0

			local var_89_11 = UIUtils.get_text_height(arg_89_3, var_89_10, var_89_8, var_89_3.text)

			var_89_10[2] = var_89_11

			if arg_89_1 then
				arg_89_9[1] = var_89_5 + var_89_2
				arg_89_9[2] = arg_89_9[2] - var_89_11
				var_89_8.text_color[1] = var_89_0

				UIPasses.text.draw(arg_89_3, var_89_9, arg_89_5, arg_89_6, var_89_8, var_89_3, arg_89_9, var_89_10, arg_89_11, arg_89_12)
			end

			arg_89_9[1] = var_89_5
			arg_89_9[2] = var_89_6
			arg_89_9[3] = var_89_7

			return var_89_11
		end
	},
	light_attack_stats = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				background_size = {
					0,
					50
				},
				title_text_pass_data = {
					text_id = "title"
				},
				text_pass_data = {},
				text_size = {
					0,
					0
				},
				content = {
					icon = "tooltip_marker",
					title = Localize("tutorial_tooltip_normal_attack")
				},
				style = {
					title = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					background = {
						color = {
							150,
							20,
							20,
							20
						},
						offset = {
							0,
							0,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_91_0, arg_91_1, arg_91_2, arg_91_3, arg_91_4, arg_91_5, arg_91_6, arg_91_7, arg_91_8, arg_91_9, arg_91_10, arg_91_11, arg_91_12, arg_91_13)
			if Development.parameter("enable_detailed_tooltips") and arg_91_11:get("item_compare") then
				local var_91_0 = arg_91_13.data.slot_type

				if not (var_91_0 == "melee" or var_91_0 == "ranged") then
					return 0
				end
			else
				return 0
			end

			local var_91_1 = 255 * arg_91_4.alpha_multiplier
			local var_91_2 = arg_91_4.start_layer or var_0_3
			local var_91_3 = 20
			local var_91_4 = arg_91_0.frame_margin or 0
			local var_91_5 = arg_91_0.style
			local var_91_6 = arg_91_0.content
			local var_91_7 = arg_91_9[1]
			local var_91_8 = arg_91_9[2]
			local var_91_9 = arg_91_9[3]
			local var_91_10 = 0

			arg_91_9[3] = var_91_2 + 2
			arg_91_9[2] = arg_91_9[2]

			local var_91_11 = {
				{
					format_function_name = "get_chain_damages",
					charge_type = "light",
					format_type = "damage",
					description = Localize("tooltip_item_damage"),
					armor_types = {
						1
					}
				},
				{
					format_function_name = "get_chain_damages",
					charge_type = "light",
					format_type = "damage",
					description = Localize("tooltip_item_damage_armor"),
					armor_types = {
						2
					}
				},
				{
					empty = true
				},
				{
					format_function_name = "get_chain_max_targets",
					charge_type = "light",
					format_type = "max_targets",
					description = Localize("tooltip_item_cleave")
				},
				{
					format_function_name = "get_chain_stagger_strengths",
					charge_type = "light",
					format_type = "stagger_strength",
					description = Localize("tooltip_item_stagger_strength")
				},
				{
					empty = true
				},
				{
					format_function_name = "get_chain_critical_hit_chances",
					charge_type = "light",
					format_type = "crit",
					description = Localize("tooltip_item_crit_hit_chance")
				},
				{
					format_function_name = "get_chain_boost_coefficients",
					charge_type = "light",
					format_type = "boost",
					description = Localize("tooltip_item_boost")
				},
				{
					format_function_name = "get_chain_headshot_boost_coefficients",
					charge_type = "light",
					format_type = "boost",
					description = Localize("tooltip_item_boost_headshot")
				}
			}

			if var_91_11 then
				local var_91_12 = var_91_5.title
				local var_91_13 = arg_91_0.title_text_pass_data
				local var_91_14 = var_91_6.title
				local var_91_15 = arg_91_0.text_size

				var_91_15[1] = arg_91_10[1] / 2 - var_91_4 * 2
				var_91_15[2] = 0

				local var_91_16 = UIUtils.get_text_height(arg_91_3, var_91_15, var_91_12, var_91_14)

				var_91_15[2] = var_91_16
				arg_91_9[2] = arg_91_9[2] - var_91_16

				local var_91_17 = var_91_10 + var_91_16

				if arg_91_1 then
					var_91_12.text_color[1] = var_91_1
					arg_91_9[1] = arg_91_9[1] + var_91_4

					UIPasses.text.draw(arg_91_3, var_91_13, arg_91_5, arg_91_6, var_91_12, var_91_6, arg_91_9, var_91_15, arg_91_11, arg_91_12)

					arg_91_9[1] = arg_91_9[1] - var_91_4
				end

				local var_91_18 = 10

				arg_91_9[2] = arg_91_9[2] - var_91_18

				local var_91_19 = var_91_17 + var_91_18
				local var_91_20 = 1
				local var_91_21 = var_91_5.stat_text
				local var_91_22 = var_91_5.stat_value

				for iter_91_0, iter_91_1 in pairs(var_91_11) do
					local var_91_23 = not iter_91_1.empty and iter_91_1.description or ""
					local var_91_24 = Managers.player:local_player().player_unit
					local var_91_25 = not iter_91_1.empty and UIUtils.get_item_tooltip_value(var_91_24, arg_91_13, iter_91_1) or ""
					local var_91_26 = arg_91_0.text_size
					local var_91_27

					if not iter_91_1.empty then
						var_91_27 = UIUtils.get_text_height(arg_91_3, var_91_26, var_91_21, var_91_23)
					else
						var_91_27 = var_91_21.font_size
					end

					var_91_26[2] = var_91_27
					arg_91_9[2] = arg_91_9[2] - var_91_27

					local var_91_28 = arg_91_9[2]
					local var_91_29 = arg_91_9[1]

					if arg_91_1 then
						local var_91_30 = "stat_" .. var_91_20

						arg_91_9[2] = var_91_28

						if var_91_20 % 2 == 0 then
							local var_91_31 = arg_91_0.background_size
							local var_91_32 = var_91_5.background.color

							var_91_32[1] = var_91_1
							var_91_31[2] = var_91_27
							var_91_31[1] = arg_91_10[1] / 2
							arg_91_9[2] = var_91_28

							var_0_0.draw_rect(arg_91_3, arg_91_9, var_91_31, var_91_32)
						end

						arg_91_9[1] = var_91_29 + var_91_4
						arg_91_9[2] = var_91_28
						arg_91_9[3] = var_91_2 + 3

						local var_91_33 = arg_91_0.text_pass_data

						var_91_6[var_91_30] = var_91_23
						var_91_33.text_id = var_91_30
						var_91_21.text_color[1] = var_91_1

						UIPasses.text.draw(arg_91_3, var_91_33, arg_91_5, arg_91_6, var_91_21, var_91_6, arg_91_9, arg_91_0.text_size, arg_91_11, arg_91_12)

						var_91_6[var_91_30] = var_91_25
						var_91_22.text_color[1] = var_91_1
						arg_91_9[1] = arg_91_9[1] + var_91_4 / 3
						arg_91_9[2] = var_91_28

						UIPasses.text.draw(arg_91_3, var_91_33, arg_91_5, arg_91_6, var_91_22, var_91_6, arg_91_9, arg_91_0.text_size, arg_91_11, arg_91_12)

						arg_91_9[3] = var_91_2 + 2
						arg_91_9[1] = var_91_29
					end

					var_91_19 = var_91_19 + var_91_27
					arg_91_9[2] = var_91_28

					if not iter_91_1.empty then
						var_91_20 = var_91_20 + 1
					end
				end

				local var_91_34 = var_91_19 + var_91_3
			end

			arg_91_9[1] = var_91_7
			arg_91_9[2] = var_91_8
			arg_91_9[3] = var_91_9

			return 0
		end
	},
	heavy_attack_stats = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				background_size = {
					0,
					50
				},
				title_text_pass_data = {
					text_id = "title"
				},
				text_pass_data = {},
				text_size = {
					0,
					0
				},
				edge_size = {
					5,
					0
				},
				edge_holder_size = {
					17,
					9
				},
				content = {
					edge_texture = "menu_frame_12_divider_vertical",
					edge_holder_bottom = "menu_frame_12_divider_bottom",
					edge_holder_top = "menu_frame_12_divider_top",
					title = Localize("tutorial_tooltip_alternative_attack")
				},
				style = {
					title = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					background = {
						color = {
							150,
							20,
							20,
							20
						},
						offset = {
							0,
							0,
							-1
						}
					},
					edge = {
						texture_size = {
							5,
							1
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
					},
					edge_holder = {
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
			}
		end,
		draw = function(arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, arg_93_7, arg_93_8, arg_93_9, arg_93_10, arg_93_11, arg_93_12, arg_93_13)
			if Development.parameter("enable_detailed_tooltips") and arg_93_11:get("item_compare") then
				local var_93_0 = arg_93_13.data.slot_type

				if not (var_93_0 == "melee" or var_93_0 == "ranged") then
					return 0
				end
			else
				return 0
			end

			local var_93_1 = 255 * arg_93_4.alpha_multiplier
			local var_93_2 = arg_93_4.start_layer or var_0_3
			local var_93_3 = 20
			local var_93_4 = arg_93_0.frame_margin or 0
			local var_93_5 = arg_93_0.style
			local var_93_6 = arg_93_0.content
			local var_93_7 = arg_93_9[1]
			local var_93_8 = arg_93_9[2]
			local var_93_9 = arg_93_9[3]
			local var_93_10 = 0

			arg_93_9[3] = var_93_2 + 2
			arg_93_9[2] = arg_93_9[2]

			local var_93_11 = {
				{
					format_function_name = "get_chain_damages",
					charge_type = "heavy",
					format_type = "damage",
					description = Localize("tooltip_item_damage"),
					armor_types = {
						1
					}
				},
				{
					format_function_name = "get_chain_damages",
					charge_type = "heavy",
					format_type = "damage",
					description = Localize("tooltip_item_damage_armor"),
					armor_types = {
						2
					}
				},
				{
					empty = true
				},
				{
					format_function_name = "get_chain_max_targets",
					charge_type = "heavy",
					format_type = "max_targets",
					description = Localize("tooltip_item_cleave")
				},
				{
					format_function_name = "get_chain_stagger_strengths",
					charge_type = "heavy",
					format_type = "stagger_strength",
					description = Localize("tooltip_item_stagger_strength")
				},
				{
					empty = true
				},
				{
					format_function_name = "get_chain_critical_hit_chances",
					charge_type = "heavy",
					format_type = "crit",
					description = Localize("tooltip_item_crit_hit_chance")
				},
				{
					format_function_name = "get_chain_boost_coefficients",
					charge_type = "heavy",
					format_type = "boost",
					description = Localize("tooltip_item_boost")
				},
				{
					format_function_name = "get_chain_headshot_boost_coefficients",
					charge_type = "heavy",
					format_type = "boost",
					description = Localize("tooltip_item_boost_headshot")
				}
			}

			if var_93_11 then
				local var_93_12 = var_93_5.title
				local var_93_13 = arg_93_0.title_text_pass_data
				local var_93_14 = var_93_6.title
				local var_93_15 = arg_93_0.text_size

				var_93_15[1] = arg_93_10[1] / 2 - var_93_4 * 2
				var_93_15[2] = 0

				local var_93_16 = UIUtils.get_text_height(arg_93_3, var_93_15, var_93_12, var_93_14)

				var_93_15[2] = var_93_16
				arg_93_9[1] = arg_93_9[1] + arg_93_10[1] / 2
				arg_93_9[2] = arg_93_9[2] - var_93_16
				var_93_10 = var_93_10 + var_93_16

				if arg_93_1 then
					var_93_12.text_color[1] = var_93_1
					arg_93_9[1] = arg_93_9[1] + var_93_4

					UIPasses.text.draw(arg_93_3, var_93_13, arg_93_5, arg_93_6, var_93_12, var_93_6, arg_93_9, var_93_15, arg_93_11, arg_93_12)

					arg_93_9[1] = arg_93_9[1] - var_93_4
				end

				local var_93_17 = 10

				arg_93_9[2] = arg_93_9[2] - var_93_17
				var_93_10 = var_93_10 + var_93_17

				local var_93_18 = 1
				local var_93_19 = var_93_5.stat_text
				local var_93_20 = var_93_5.stat_value

				for iter_93_0, iter_93_1 in pairs(var_93_11) do
					local var_93_21 = not iter_93_1.empty and iter_93_1.description or ""
					local var_93_22 = Managers.player:local_player().player_unit
					local var_93_23 = not iter_93_1.empty and UIUtils.get_item_tooltip_value(var_93_22, arg_93_13, iter_93_1) or ""
					local var_93_24 = arg_93_0.text_size
					local var_93_25

					if not iter_93_1.empty then
						var_93_25 = UIUtils.get_text_height(arg_93_3, var_93_24, var_93_19, var_93_21)
					else
						var_93_25 = var_93_19.font_size
					end

					var_93_24[2] = var_93_25
					arg_93_9[2] = arg_93_9[2] - var_93_25

					local var_93_26 = arg_93_9[2]
					local var_93_27 = arg_93_9[1]

					if arg_93_1 then
						local var_93_28 = "stat_" .. var_93_18

						arg_93_9[2] = var_93_26

						if var_93_18 % 2 == 0 then
							local var_93_29 = arg_93_0.background_size
							local var_93_30 = var_93_5.background.color

							var_93_30[1] = var_93_1
							var_93_29[2] = var_93_25
							var_93_29[1] = arg_93_10[1] / 2
							arg_93_9[2] = var_93_26

							var_0_0.draw_rect(arg_93_3, arg_93_9, var_93_29, var_93_30)
						end

						arg_93_9[1] = var_93_27 + var_93_4
						arg_93_9[2] = var_93_26
						arg_93_9[3] = var_93_2 + 3

						local var_93_31 = arg_93_0.text_pass_data

						var_93_6[var_93_28] = var_93_21
						var_93_31.text_id = var_93_28
						var_93_19.text_color[1] = var_93_1

						UIPasses.text.draw(arg_93_3, var_93_31, arg_93_5, arg_93_6, var_93_19, var_93_6, arg_93_9, arg_93_0.text_size, arg_93_11, arg_93_12)

						var_93_6[var_93_28] = var_93_23
						var_93_20.text_color[1] = var_93_1
						arg_93_9[2] = var_93_26

						UIPasses.text.draw(arg_93_3, var_93_31, arg_93_5, arg_93_6, var_93_20, var_93_6, arg_93_9, arg_93_0.text_size, arg_93_11, arg_93_12)

						arg_93_9[3] = var_93_2 + 2
						arg_93_9[1] = var_93_27
					end

					var_93_10 = var_93_10 + var_93_25
					arg_93_9[2] = var_93_26

					if not iter_93_1.empty then
						var_93_18 = var_93_18 + 1
					end
				end

				if arg_93_1 then
					arg_93_9[1] = var_93_7 + arg_93_10[1] / 2

					local var_93_32 = arg_93_0.edge_size

					var_93_32[2] = var_93_10

					local var_93_33 = var_93_6.edge_texture
					local var_93_34 = var_93_5.edge
					local var_93_35 = var_93_34.color
					local var_93_36 = var_93_34.texture_size

					var_93_36[2] = var_93_10
					var_93_35[1] = var_93_1
					arg_93_9[1] = arg_93_9[1] - var_93_36[1] / 2
					arg_93_9[2] = arg_93_9[2] - var_93_4 * 0.5
					arg_93_9[3] = var_93_2 + 4

					var_0_0.draw_tiled_texture(arg_93_3, var_93_33, arg_93_9, var_93_32, var_93_36, var_93_35)

					local var_93_37 = var_93_5.edge_holder
					local var_93_38 = arg_93_0.edge_holder_size
					local var_93_39 = var_93_37.color
					local var_93_40 = var_93_6.edge_holder_top
					local var_93_41 = var_93_6.edge_holder_bottom

					var_93_39[1] = var_93_1
					arg_93_9[1] = arg_93_9[1] - var_93_38[1] / 2 + 3
					arg_93_9[3] = var_93_2 + 6
					arg_93_9[2] = arg_93_9[2] - 2

					var_0_0.draw_texture(arg_93_3, var_93_41, arg_93_9, var_93_38, var_93_39)

					arg_93_9[2] = arg_93_9[2] + var_93_10

					var_0_0.draw_texture(arg_93_3, var_93_40, arg_93_9, var_93_38, var_93_39)
				end
			end

			arg_93_9[1] = var_93_7
			arg_93_9[2] = var_93_8
			arg_93_9[3] = var_93_9

			return var_93_10
		end
	},
	detailed_stats_light = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				background_size = {
					0,
					50
				},
				title_text_pass_data = {
					text_id = "title"
				},
				text_pass_data = {},
				text_size = {
					0,
					0
				},
				content = {
					icon = "tooltip_marker",
					title = Localize("tutorial_tooltip_normal_attack")
				},
				style = {
					title = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					background = {
						color = {
							150,
							20,
							20,
							20
						},
						offset = {
							0,
							0,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4, arg_95_5, arg_95_6, arg_95_7, arg_95_8, arg_95_9, arg_95_10, arg_95_11, arg_95_12, arg_95_13)
			if Development.parameter("enable_detailed_tooltips") and arg_95_11:get("item_detail") then
				if not (arg_95_13.data.slot_type == "melee") then
					return 0
				end
			else
				return 0
			end

			local var_95_0 = 255 * arg_95_4.alpha_multiplier
			local var_95_1 = arg_95_4.start_layer or var_0_3
			local var_95_2 = 20
			local var_95_3 = arg_95_0.frame_margin or 0
			local var_95_4 = arg_95_0.style
			local var_95_5 = arg_95_0.content
			local var_95_6 = arg_95_9[1]
			local var_95_7 = arg_95_9[2]
			local var_95_8 = arg_95_9[3]
			local var_95_9 = 0

			arg_95_9[3] = var_95_1 + 2
			arg_95_9[2] = arg_95_9[2]

			local var_95_10 = {
				{
					format_function_name = "get_chain_damages",
					detailed = true,
					charge_type = "light",
					format_type = "damage",
					description = Localize("tooltip_item_damage"),
					armor_types = {
						1
					}
				},
				{
					format_function_name = "get_chain_damages",
					detailed = true,
					charge_type = "light",
					format_type = "damage",
					description = Localize("tooltip_item_damage_armor"),
					armor_types = {
						2
					}
				},
				{
					empty = true
				},
				{
					charge_type = "light",
					detailed = true,
					format_function_name = "get_chain_max_targets",
					format_type = "max_targets",
					description = Localize("tooltip_item_cleave")
				},
				{
					charge_type = "light",
					detailed = true,
					format_function_name = "get_chain_stagger_strengths",
					format_type = "stagger_strength",
					description = Localize("tooltip_item_stagger_strength")
				},
				{
					charge_type = "light",
					detailed = true,
					format_function_name = "get_time_between_damage",
					format_type = "time_between_damage",
					description = Localize("tooltip_item_time_between_damage")
				},
				{
					empty = true
				},
				{
					charge_type = "light",
					detailed = true,
					format_function_name = "get_chain_critical_hit_chances",
					format_type = "crit",
					description = Localize("tooltip_item_crit_hit_chance")
				},
				{
					charge_type = "light",
					detailed = true,
					format_function_name = "get_chain_boost_coefficients",
					format_type = "boost",
					description = Localize("tooltip_item_boost")
				},
				{
					charge_type = "light",
					detailed = true,
					format_function_name = "get_chain_headshot_boost_coefficients",
					format_type = "boost",
					description = Localize("tooltip_item_boost_headshot")
				}
			}

			if var_95_10 then
				local var_95_11 = var_95_4.title
				local var_95_12 = arg_95_0.title_text_pass_data
				local var_95_13 = var_95_5.title
				local var_95_14 = arg_95_0.text_size

				var_95_14[1] = arg_95_10[1] - var_95_3 * 2
				var_95_14[2] = 0

				local var_95_15 = UIUtils.get_text_height(arg_95_3, var_95_14, var_95_11, var_95_13)

				var_95_14[2] = var_95_15
				arg_95_9[2] = arg_95_9[2] - var_95_15
				var_95_9 = var_95_9 + var_95_15

				if arg_95_1 then
					var_95_11.text_color[1] = var_95_0
					arg_95_9[1] = arg_95_9[1] + var_95_3

					UIPasses.text.draw(arg_95_3, var_95_12, arg_95_5, arg_95_6, var_95_11, var_95_5, arg_95_9, var_95_14, arg_95_11, arg_95_12)

					arg_95_9[1] = arg_95_9[1] - var_95_3
				end

				local var_95_16 = 10

				arg_95_9[2] = arg_95_9[2] - var_95_16
				var_95_9 = var_95_9 + var_95_16

				local var_95_17 = 1
				local var_95_18 = var_95_4.stat_text
				local var_95_19 = var_95_4.stat_value

				for iter_95_0, iter_95_1 in pairs(var_95_10) do
					local var_95_20 = not iter_95_1.empty and iter_95_1.description or ""
					local var_95_21 = Managers.player:local_player().player_unit
					local var_95_22 = not iter_95_1.empty and UIUtils.get_item_tooltip_value(var_95_21, arg_95_13, iter_95_1) or ""
					local var_95_23 = arg_95_0.text_size
					local var_95_24

					if not iter_95_1.empty then
						var_95_24 = UIUtils.get_text_height(arg_95_3, var_95_23, var_95_18, var_95_20)
					else
						var_95_24 = var_95_18.font_size
					end

					var_95_23[2] = var_95_24
					arg_95_9[2] = arg_95_9[2] - var_95_24

					local var_95_25 = arg_95_9[2]
					local var_95_26 = arg_95_9[1]

					if arg_95_1 then
						local var_95_27 = "stat_" .. var_95_17

						arg_95_9[2] = var_95_25

						if var_95_17 % 2 == 0 then
							local var_95_28 = arg_95_0.background_size
							local var_95_29 = var_95_4.background.color

							var_95_29[1] = var_95_0
							var_95_28[2] = var_95_24
							var_95_28[1] = arg_95_10[1]
							arg_95_9[2] = var_95_25

							var_0_0.draw_rect(arg_95_3, arg_95_9, var_95_28, var_95_29)
						end

						arg_95_9[1] = var_95_26 + var_95_3
						arg_95_9[2] = var_95_25
						arg_95_9[3] = var_95_1 + 3

						local var_95_30 = arg_95_0.text_pass_data

						var_95_5[var_95_27] = var_95_20
						var_95_30.text_id = var_95_27
						var_95_18.text_color[1] = var_95_0

						UIPasses.text.draw(arg_95_3, var_95_30, arg_95_5, arg_95_6, var_95_18, var_95_5, arg_95_9, arg_95_0.text_size, arg_95_11, arg_95_12)

						var_95_5[var_95_27] = var_95_22
						var_95_19.text_color[1] = var_95_0
						arg_95_9[1] = arg_95_9[1] + var_95_3 / 3
						arg_95_9[2] = var_95_25

						UIPasses.text.draw(arg_95_3, var_95_30, arg_95_5, arg_95_6, var_95_19, var_95_5, arg_95_9, arg_95_0.text_size, arg_95_11, arg_95_12)

						arg_95_9[3] = var_95_1 + 2
						arg_95_9[1] = var_95_26
					end

					var_95_9 = var_95_9 + var_95_24
					arg_95_9[2] = var_95_25

					if not iter_95_1.empty then
						var_95_17 = var_95_17 + 1
					end
				end
			end

			arg_95_9[1] = var_95_6
			arg_95_9[2] = var_95_7
			arg_95_9[3] = var_95_8

			return var_95_9
		end
	},
	detailed_stats_heavy = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				background_size = {
					0,
					50
				},
				title_text_pass_data = {
					text_id = "title"
				},
				text_pass_data = {},
				text_size = {
					0,
					0
				},
				content = {
					icon = "tooltip_marker",
					title = Localize("tutorial_tooltip_alternative_attack")
				},
				style = {
					title = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					background = {
						color = {
							150,
							20,
							20,
							20
						},
						offset = {
							0,
							0,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4, arg_97_5, arg_97_6, arg_97_7, arg_97_8, arg_97_9, arg_97_10, arg_97_11, arg_97_12, arg_97_13)
			if Development.parameter("enable_detailed_tooltips") and arg_97_11:get("item_detail") then
				if not (arg_97_13.data.slot_type == "melee") then
					return 0
				end
			else
				return 0
			end

			local var_97_0 = 255 * arg_97_4.alpha_multiplier
			local var_97_1 = arg_97_4.start_layer or var_0_3
			local var_97_2 = 20
			local var_97_3 = arg_97_0.frame_margin or 0
			local var_97_4 = arg_97_0.style
			local var_97_5 = arg_97_0.content
			local var_97_6 = arg_97_9[1]
			local var_97_7 = arg_97_9[2]
			local var_97_8 = arg_97_9[3]
			local var_97_9 = 0

			arg_97_9[3] = var_97_1 + 2
			arg_97_9[2] = arg_97_9[2]

			local var_97_10 = {
				{
					format_function_name = "get_chain_damages",
					detailed = true,
					charge_type = "heavy",
					format_type = "damage",
					description = Localize("tooltip_item_damage"),
					armor_types = {
						1
					}
				},
				{
					format_function_name = "get_chain_damages",
					detailed = true,
					charge_type = "heavy",
					format_type = "damage",
					description = Localize("tooltip_item_damage_armor"),
					armor_types = {
						2
					}
				},
				{
					empty = true
				},
				{
					charge_type = "heavy",
					detailed = true,
					format_function_name = "get_chain_max_targets",
					format_type = "max_targets",
					description = Localize("tooltip_item_cleave")
				},
				{
					charge_type = "heavy",
					detailed = true,
					format_function_name = "get_chain_stagger_strengths",
					format_type = "stagger_strength",
					description = Localize("tooltip_item_stagger_strength")
				},
				{
					charge_type = "heavy",
					detailed = true,
					format_function_name = "get_time_between_damage",
					format_type = "time_between_damage",
					description = Localize("tooltip_item_time_between_damage")
				},
				{
					empty = true
				},
				{
					charge_type = "heavy",
					detailed = true,
					format_function_name = "get_chain_critical_hit_chances",
					format_type = "crit",
					description = Localize("tooltip_item_crit_hit_chance")
				},
				{
					charge_type = "heavy",
					detailed = true,
					format_function_name = "get_chain_boost_coefficients",
					format_type = "boost",
					description = Localize("tooltip_item_boost")
				},
				{
					charge_type = "heavy",
					detailed = true,
					format_function_name = "get_chain_headshot_boost_coefficients",
					format_type = "boost",
					description = Localize("tooltip_item_boost_headshot")
				}
			}

			if var_97_10 then
				local var_97_11 = var_97_4.title
				local var_97_12 = arg_97_0.title_text_pass_data
				local var_97_13 = var_97_5.title
				local var_97_14 = arg_97_0.text_size

				var_97_14[1] = arg_97_10[1] - var_97_3 * 2
				var_97_14[2] = 0

				local var_97_15 = UIUtils.get_text_height(arg_97_3, var_97_14, var_97_11, var_97_13)

				var_97_14[2] = var_97_15
				arg_97_9[2] = arg_97_9[2] - var_97_15
				var_97_9 = var_97_9 + var_97_15

				if arg_97_1 then
					var_97_11.text_color[1] = var_97_0
					arg_97_9[1] = arg_97_9[1] + var_97_3

					UIPasses.text.draw(arg_97_3, var_97_12, arg_97_5, arg_97_6, var_97_11, var_97_5, arg_97_9, var_97_14, arg_97_11, arg_97_12)

					arg_97_9[1] = arg_97_9[1] - var_97_3
				end

				local var_97_16 = 10

				arg_97_9[2] = arg_97_9[2] - var_97_16
				var_97_9 = var_97_9 + var_97_16

				local var_97_17 = 1
				local var_97_18 = var_97_4.stat_text
				local var_97_19 = var_97_4.stat_value

				for iter_97_0, iter_97_1 in pairs(var_97_10) do
					local var_97_20 = not iter_97_1.empty and iter_97_1.description or ""
					local var_97_21 = Managers.player:local_player().player_unit
					local var_97_22 = not iter_97_1.empty and UIUtils.get_item_tooltip_value(var_97_21, arg_97_13, iter_97_1) or ""
					local var_97_23 = arg_97_0.text_size
					local var_97_24

					if not iter_97_1.empty then
						var_97_24 = UIUtils.get_text_height(arg_97_3, var_97_23, var_97_18, var_97_20)
					else
						var_97_24 = var_97_18.font_size
					end

					var_97_23[2] = var_97_24
					arg_97_9[2] = arg_97_9[2] - var_97_24

					local var_97_25 = arg_97_9[2]
					local var_97_26 = arg_97_9[1]

					if arg_97_1 then
						local var_97_27 = "stat_" .. var_97_17

						arg_97_9[2] = var_97_25

						if var_97_17 % 2 == 0 then
							local var_97_28 = arg_97_0.background_size
							local var_97_29 = var_97_4.background.color

							var_97_29[1] = var_97_0
							var_97_28[2] = var_97_24
							var_97_28[1] = arg_97_10[1]
							arg_97_9[2] = var_97_25

							var_0_0.draw_rect(arg_97_3, arg_97_9, var_97_28, var_97_29)
						end

						arg_97_9[1] = var_97_26 + var_97_3
						arg_97_9[2] = var_97_25
						arg_97_9[3] = var_97_1 + 3

						local var_97_30 = arg_97_0.text_pass_data

						var_97_5[var_97_27] = var_97_20
						var_97_30.text_id = var_97_27
						var_97_18.text_color[1] = var_97_0

						UIPasses.text.draw(arg_97_3, var_97_30, arg_97_5, arg_97_6, var_97_18, var_97_5, arg_97_9, arg_97_0.text_size, arg_97_11, arg_97_12)

						var_97_5[var_97_27] = var_97_22
						var_97_19.text_color[1] = var_97_0
						arg_97_9[1] = arg_97_9[1] + var_97_3 / 3
						arg_97_9[2] = var_97_25

						UIPasses.text.draw(arg_97_3, var_97_30, arg_97_5, arg_97_6, var_97_19, var_97_5, arg_97_9, arg_97_0.text_size, arg_97_11, arg_97_12)

						arg_97_9[3] = var_97_1 + 2
						arg_97_9[1] = var_97_26
					end

					var_97_9 = var_97_9 + var_97_24
					arg_97_9[2] = var_97_25

					if not iter_97_1.empty then
						var_97_17 = var_97_17 + 1
					end
				end
			end

			arg_97_9[1] = var_97_6
			arg_97_9[2] = var_97_7
			arg_97_9[3] = var_97_8

			return var_97_9
		end
	},
	detailed_stats_push = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				background_size = {
					0,
					50
				},
				title_text_pass_data = {
					text_id = "title"
				},
				text_pass_data = {},
				text_size = {
					0,
					0
				},
				content = {
					icon = "tooltip_marker",
					title = Localize("tutorial_tooltip_push")
				},
				style = {
					title = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					background = {
						color = {
							150,
							20,
							20,
							20
						},
						offset = {
							0,
							0,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6, arg_99_7, arg_99_8, arg_99_9, arg_99_10, arg_99_11, arg_99_12, arg_99_13)
			if Development.parameter("enable_detailed_tooltips") and arg_99_11:get("item_detail") then
				if not (arg_99_13.data.slot_type == "melee") then
					return 0
				end
			else
				return 0
			end

			local var_99_0 = 255 * arg_99_4.alpha_multiplier
			local var_99_1 = arg_99_4.start_layer or var_0_3
			local var_99_2 = 20
			local var_99_3 = arg_99_0.frame_margin or 0
			local var_99_4 = arg_99_0.style
			local var_99_5 = arg_99_0.content
			local var_99_6 = arg_99_9[1]
			local var_99_7 = arg_99_9[2]
			local var_99_8 = arg_99_9[3]
			local var_99_9 = 0

			arg_99_9[3] = var_99_1 + 2
			arg_99_9[2] = arg_99_9[2]

			local var_99_10 = {
				{
					charge_type = "push",
					detailed = true,
					format_function_name = "get_push_angles",
					format_type = "push_angle",
					description = Localize("tooltip_item_push_angles")
				},
				{
					charge_type = "push",
					detailed = true,
					format_function_name = "get_push_strengths",
					format_type = "push_strength",
					description = Localize("tooltip_item_stagger_strength")
				}
			}

			if var_99_10 then
				local var_99_11 = var_99_4.title
				local var_99_12 = arg_99_0.title_text_pass_data
				local var_99_13 = var_99_5.title
				local var_99_14 = arg_99_0.text_size

				var_99_14[1] = arg_99_10[1] - var_99_3 * 2
				var_99_14[2] = 0

				local var_99_15 = UIUtils.get_text_height(arg_99_3, var_99_14, var_99_11, var_99_13)

				var_99_14[2] = var_99_15
				arg_99_9[2] = arg_99_9[2] - var_99_15
				var_99_9 = var_99_9 + var_99_15

				if arg_99_1 then
					var_99_11.text_color[1] = var_99_0
					arg_99_9[1] = arg_99_9[1] + var_99_3

					UIPasses.text.draw(arg_99_3, var_99_12, arg_99_5, arg_99_6, var_99_11, var_99_5, arg_99_9, var_99_14, arg_99_11, arg_99_12)

					arg_99_9[1] = arg_99_9[1] - var_99_3
				end

				local var_99_16 = 10

				arg_99_9[2] = arg_99_9[2] - var_99_16
				var_99_9 = var_99_9 + var_99_16

				local var_99_17 = 1
				local var_99_18 = var_99_4.stat_text
				local var_99_19 = var_99_4.stat_value

				for iter_99_0, iter_99_1 in pairs(var_99_10) do
					local var_99_20 = not iter_99_1.empty and iter_99_1.description or ""
					local var_99_21 = Managers.player:local_player().player_unit
					local var_99_22 = not iter_99_1.empty and UIUtils.get_item_tooltip_value(var_99_21, arg_99_13, iter_99_1) or ""
					local var_99_23 = arg_99_0.text_size
					local var_99_24

					if not iter_99_1.empty then
						var_99_24 = UIUtils.get_text_height(arg_99_3, var_99_23, var_99_18, var_99_20)
					else
						var_99_24 = var_99_18.font_size
					end

					var_99_23[2] = var_99_24
					arg_99_9[2] = arg_99_9[2] - var_99_24

					local var_99_25 = arg_99_9[2]
					local var_99_26 = arg_99_9[1]

					if arg_99_1 then
						local var_99_27 = "stat_" .. var_99_17

						arg_99_9[2] = var_99_25

						if var_99_17 % 2 == 0 then
							local var_99_28 = arg_99_0.background_size
							local var_99_29 = var_99_4.background.color

							var_99_29[1] = var_99_0
							var_99_28[2] = var_99_24
							var_99_28[1] = arg_99_10[1]
							arg_99_9[2] = var_99_25

							var_0_0.draw_rect(arg_99_3, arg_99_9, var_99_28, var_99_29)
						end

						arg_99_9[1] = var_99_26 + var_99_3
						arg_99_9[2] = var_99_25
						arg_99_9[3] = var_99_1 + 3

						local var_99_30 = arg_99_0.text_pass_data

						var_99_5[var_99_27] = var_99_20
						var_99_30.text_id = var_99_27
						var_99_18.text_color[1] = var_99_0

						UIPasses.text.draw(arg_99_3, var_99_30, arg_99_5, arg_99_6, var_99_18, var_99_5, arg_99_9, arg_99_0.text_size, arg_99_11, arg_99_12)

						var_99_5[var_99_27] = var_99_22
						var_99_19.text_color[1] = var_99_0
						arg_99_9[1] = arg_99_9[1] + var_99_3 / 3
						arg_99_9[2] = var_99_25

						UIPasses.text.draw(arg_99_3, var_99_30, arg_99_5, arg_99_6, var_99_19, var_99_5, arg_99_9, arg_99_0.text_size, arg_99_11, arg_99_12)

						arg_99_9[3] = var_99_1 + 2
						arg_99_9[1] = var_99_26
					end

					var_99_9 = var_99_9 + var_99_24
					arg_99_9[2] = var_99_25

					if not iter_99_1.empty then
						var_99_17 = var_99_17 + 1
					end
				end
			end

			arg_99_9[1] = var_99_6
			arg_99_9[2] = var_99_7
			arg_99_9[3] = var_99_8

			return var_99_9
		end
	},
	detailed_stats_ranged_light = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				background_size = {
					0,
					50
				},
				title_text_pass_data = {
					text_id = "title"
				},
				text_pass_data = {},
				text_size = {
					0,
					0
				},
				content = {
					icon = "tooltip_marker",
					title = Localize("tutorial_tooltip_normal_attack")
				},
				style = {
					title = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					background = {
						color = {
							150,
							20,
							20,
							20
						},
						offset = {
							0,
							0,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4, arg_101_5, arg_101_6, arg_101_7, arg_101_8, arg_101_9, arg_101_10, arg_101_11, arg_101_12, arg_101_13)
			if Development.parameter("enable_detailed_tooltips") and arg_101_11:get("item_detail") then
				if not (arg_101_13.data.slot_type == "ranged") then
					return 0
				end
			else
				return 0
			end

			local var_101_0 = 255 * arg_101_4.alpha_multiplier
			local var_101_1 = arg_101_4.start_layer or var_0_3
			local var_101_2 = 20
			local var_101_3 = arg_101_0.frame_margin or 0
			local var_101_4 = arg_101_0.style
			local var_101_5 = arg_101_0.content
			local var_101_6 = arg_101_9[1]
			local var_101_7 = arg_101_9[2]
			local var_101_8 = arg_101_9[3]
			local var_101_9 = 0

			arg_101_9[3] = var_101_1 + 2
			arg_101_9[2] = arg_101_9[2]

			local var_101_10 = {
				{
					format_function_name = "get_chain_damages",
					detailed = true,
					charge_type = "light",
					format_type = "damage",
					description = Localize("tooltip_item_damage"),
					armor_types = {
						1
					}
				},
				{
					format_function_name = "get_chain_damages",
					detailed = true,
					charge_type = "light",
					format_type = "damage",
					description = Localize("tooltip_item_damage_armor"),
					armor_types = {
						2
					}
				},
				{
					empty = true
				},
				{
					charge_type = "light",
					detailed = true,
					format_function_name = "get_chain_max_targets",
					format_type = "max_targets",
					description = Localize("tooltip_item_cleave")
				},
				{
					charge_type = "light",
					detailed = true,
					format_function_name = "get_chain_stagger_strengths",
					format_type = "stagger_strength",
					description = Localize("tooltip_item_stagger_strength")
				},
				{
					charge_type = "light",
					detailed = true,
					format_function_name = "get_time_between_damage",
					format_type = "time_between_damage",
					description = Localize("tooltip_item_time_between_damage")
				},
				{
					empty = true
				},
				{
					charge_type = "light",
					detailed = true,
					format_function_name = "get_chain_critical_hit_chances",
					format_type = "crit",
					description = Localize("tooltip_item_crit_hit_chance")
				},
				{
					charge_type = "light",
					detailed = true,
					format_function_name = "get_chain_boost_coefficients",
					format_type = "boost",
					description = Localize("tooltip_item_boost")
				},
				{
					charge_type = "light",
					detailed = true,
					format_function_name = "get_chain_headshot_boost_coefficients",
					format_type = "boost",
					description = Localize("tooltip_item_boost_headshot")
				}
			}

			if var_101_10 then
				local var_101_11 = var_101_4.title
				local var_101_12 = arg_101_0.title_text_pass_data
				local var_101_13 = var_101_5.title
				local var_101_14 = arg_101_0.text_size

				var_101_14[1] = arg_101_10[1] - var_101_3 * 2
				var_101_14[2] = 0

				local var_101_15 = UIUtils.get_text_height(arg_101_3, var_101_14, var_101_11, var_101_13)

				var_101_14[2] = var_101_15
				arg_101_9[2] = arg_101_9[2] - var_101_15
				var_101_9 = var_101_9 + var_101_15

				if arg_101_1 then
					var_101_11.text_color[1] = var_101_0
					arg_101_9[1] = arg_101_9[1] + var_101_3

					UIPasses.text.draw(arg_101_3, var_101_12, arg_101_5, arg_101_6, var_101_11, var_101_5, arg_101_9, var_101_14, arg_101_11, arg_101_12)

					arg_101_9[1] = arg_101_9[1] - var_101_3
				end

				local var_101_16 = 10

				arg_101_9[2] = arg_101_9[2] - var_101_16
				var_101_9 = var_101_9 + var_101_16

				local var_101_17 = 1
				local var_101_18 = var_101_4.stat_text
				local var_101_19 = var_101_4.stat_value

				for iter_101_0, iter_101_1 in pairs(var_101_10) do
					local var_101_20 = not iter_101_1.empty and iter_101_1.description or ""
					local var_101_21 = Managers.player:local_player().player_unit
					local var_101_22 = not iter_101_1.empty and UIUtils.get_item_tooltip_value(var_101_21, arg_101_13, iter_101_1) or ""
					local var_101_23 = arg_101_0.text_size
					local var_101_24

					if not iter_101_1.empty then
						var_101_24 = UIUtils.get_text_height(arg_101_3, var_101_23, var_101_18, var_101_20)
					else
						var_101_24 = var_101_18.font_size
					end

					var_101_23[2] = var_101_24
					arg_101_9[2] = arg_101_9[2] - var_101_24

					local var_101_25 = arg_101_9[2]
					local var_101_26 = arg_101_9[1]

					if arg_101_1 then
						local var_101_27 = "stat_" .. var_101_17

						arg_101_9[2] = var_101_25

						if var_101_17 % 2 == 0 then
							local var_101_28 = arg_101_0.background_size
							local var_101_29 = var_101_4.background.color

							var_101_29[1] = var_101_0
							var_101_28[2] = var_101_24
							var_101_28[1] = arg_101_10[1]
							arg_101_9[2] = var_101_25

							var_0_0.draw_rect(arg_101_3, arg_101_9, var_101_28, var_101_29)
						end

						arg_101_9[1] = var_101_26 + var_101_3
						arg_101_9[2] = var_101_25
						arg_101_9[3] = var_101_1 + 3

						local var_101_30 = arg_101_0.text_pass_data

						var_101_5[var_101_27] = var_101_20
						var_101_30.text_id = var_101_27
						var_101_18.text_color[1] = var_101_0

						UIPasses.text.draw(arg_101_3, var_101_30, arg_101_5, arg_101_6, var_101_18, var_101_5, arg_101_9, arg_101_0.text_size, arg_101_11, arg_101_12)

						var_101_5[var_101_27] = var_101_22
						var_101_19.text_color[1] = var_101_0
						arg_101_9[1] = arg_101_9[1] + var_101_3 / 3
						arg_101_9[2] = var_101_25

						UIPasses.text.draw(arg_101_3, var_101_30, arg_101_5, arg_101_6, var_101_19, var_101_5, arg_101_9, arg_101_0.text_size, arg_101_11, arg_101_12)

						arg_101_9[3] = var_101_1 + 2
						arg_101_9[1] = var_101_26
					end

					var_101_9 = var_101_9 + var_101_24
					arg_101_9[2] = var_101_25

					if not iter_101_1.empty then
						var_101_17 = var_101_17 + 1
					end
				end
			end

			arg_101_9[1] = var_101_6
			arg_101_9[2] = var_101_7
			arg_101_9[3] = var_101_8

			return var_101_9
		end
	},
	detailed_stats_ranged_heavy = {
		setup_data = function()
			return {
				frame_name = "item_tooltip_frame_01",
				background_color = {
					240,
					3,
					3,
					3
				},
				background_size = {
					0,
					50
				},
				title_text_pass_data = {
					text_id = "title"
				},
				text_pass_data = {},
				text_size = {
					0,
					0
				},
				content = {
					icon = "tooltip_marker",
					title = Localize("tutorial_tooltip_alternative_attack")
				},
				style = {
					title = {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = var_0_6(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					background = {
						color = {
							150,
							20,
							20,
							20
						},
						offset = {
							0,
							0,
							-1
						}
					}
				}
			}
		end,
		draw = function(arg_103_0, arg_103_1, arg_103_2, arg_103_3, arg_103_4, arg_103_5, arg_103_6, arg_103_7, arg_103_8, arg_103_9, arg_103_10, arg_103_11, arg_103_12, arg_103_13)
			if Development.parameter("enable_detailed_tooltips") and arg_103_11:get("item_detail") then
				if not (arg_103_13.data.slot_type == "ranged") then
					return 0
				end
			else
				return 0
			end

			local var_103_0 = 255 * arg_103_4.alpha_multiplier
			local var_103_1 = arg_103_4.start_layer or var_0_3
			local var_103_2 = 20
			local var_103_3 = arg_103_0.frame_margin or 0
			local var_103_4 = arg_103_0.style
			local var_103_5 = arg_103_0.content
			local var_103_6 = arg_103_9[1]
			local var_103_7 = arg_103_9[2]
			local var_103_8 = arg_103_9[3]
			local var_103_9 = 0

			arg_103_9[3] = var_103_1 + 2
			arg_103_9[2] = arg_103_9[2]

			local var_103_10 = {
				{
					format_function_name = "get_chain_damages",
					detailed = true,
					charge_type = "heavy",
					format_type = "damage",
					description = Localize("tooltip_item_damage"),
					armor_types = {
						1
					}
				},
				{
					format_function_name = "get_chain_damages",
					detailed = true,
					charge_type = "heavy",
					format_type = "damage",
					description = Localize("tooltip_item_damage_armor"),
					armor_types = {
						2
					}
				},
				{
					empty = true
				},
				{
					charge_type = "heavy",
					detailed = true,
					format_function_name = "get_chain_max_targets",
					format_type = "max_targets",
					description = Localize("tooltip_item_cleave")
				},
				{
					charge_type = "heavy",
					detailed = true,
					format_function_name = "get_chain_stagger_strengths",
					format_type = "stagger_strength",
					description = Localize("tooltip_item_stagger_strength")
				},
				{
					charge_type = "heavy",
					detailed = true,
					format_function_name = "get_time_between_damage",
					format_type = "time_between_damage",
					description = Localize("tooltip_item_time_between_damage")
				},
				{
					empty = true
				},
				{
					charge_type = "heavy",
					detailed = true,
					format_function_name = "get_chain_critical_hit_chances",
					format_type = "crit",
					description = Localize("tooltip_item_crit_hit_chance")
				},
				{
					charge_type = "heavy",
					detailed = true,
					format_function_name = "get_chain_boost_coefficients",
					format_type = "boost",
					description = Localize("tooltip_item_boost")
				},
				{
					charge_type = "heavy",
					detailed = true,
					format_function_name = "get_chain_headshot_boost_coefficients",
					format_type = "boost",
					description = Localize("tooltip_item_boost_headshot")
				}
			}

			if var_103_10 then
				local var_103_11 = var_103_4.title
				local var_103_12 = arg_103_0.title_text_pass_data
				local var_103_13 = var_103_5.title
				local var_103_14 = arg_103_0.text_size

				var_103_14[1] = arg_103_10[1] - var_103_3 * 2
				var_103_14[2] = 0

				local var_103_15 = UIUtils.get_text_height(arg_103_3, var_103_14, var_103_11, var_103_13)

				var_103_14[2] = var_103_15
				arg_103_9[2] = arg_103_9[2] - var_103_15
				var_103_9 = var_103_9 + var_103_15

				if arg_103_1 then
					var_103_11.text_color[1] = var_103_0
					arg_103_9[1] = arg_103_9[1] + var_103_3

					UIPasses.text.draw(arg_103_3, var_103_12, arg_103_5, arg_103_6, var_103_11, var_103_5, arg_103_9, var_103_14, arg_103_11, arg_103_12)

					arg_103_9[1] = arg_103_9[1] - var_103_3
				end

				local var_103_16 = 10

				arg_103_9[2] = arg_103_9[2] - var_103_16
				var_103_9 = var_103_9 + var_103_16

				local var_103_17 = 1
				local var_103_18 = var_103_4.stat_text
				local var_103_19 = var_103_4.stat_value

				for iter_103_0, iter_103_1 in pairs(var_103_10) do
					local var_103_20 = not iter_103_1.empty and iter_103_1.description or ""
					local var_103_21 = Managers.player:local_player().player_unit
					local var_103_22 = not iter_103_1.empty and UIUtils.get_item_tooltip_value(var_103_21, arg_103_13, iter_103_1) or ""
					local var_103_23 = arg_103_0.text_size
					local var_103_24

					if not iter_103_1.empty then
						var_103_24 = UIUtils.get_text_height(arg_103_3, var_103_23, var_103_18, var_103_20)
					else
						var_103_24 = var_103_18.font_size
					end

					var_103_23[2] = var_103_24
					arg_103_9[2] = arg_103_9[2] - var_103_24

					local var_103_25 = arg_103_9[2]
					local var_103_26 = arg_103_9[1]

					if arg_103_1 then
						local var_103_27 = "stat_" .. var_103_17

						arg_103_9[2] = var_103_25

						if var_103_17 % 2 == 0 then
							local var_103_28 = arg_103_0.background_size
							local var_103_29 = var_103_4.background.color

							var_103_29[1] = var_103_0
							var_103_28[2] = var_103_24
							var_103_28[1] = arg_103_10[1]
							arg_103_9[2] = var_103_25

							var_0_0.draw_rect(arg_103_3, arg_103_9, var_103_28, var_103_29)
						end

						arg_103_9[1] = var_103_26 + var_103_3
						arg_103_9[2] = var_103_25
						arg_103_9[3] = var_103_1 + 3

						local var_103_30 = arg_103_0.text_pass_data

						var_103_5[var_103_27] = var_103_20
						var_103_30.text_id = var_103_27
						var_103_18.text_color[1] = var_103_0

						UIPasses.text.draw(arg_103_3, var_103_30, arg_103_5, arg_103_6, var_103_18, var_103_5, arg_103_9, arg_103_0.text_size, arg_103_11, arg_103_12)

						var_103_5[var_103_27] = var_103_22
						var_103_19.text_color[1] = var_103_0
						arg_103_9[1] = arg_103_9[1] + var_103_3 / 3
						arg_103_9[2] = var_103_25

						UIPasses.text.draw(arg_103_3, var_103_30, arg_103_5, arg_103_6, var_103_19, var_103_5, arg_103_9, arg_103_0.text_size, arg_103_11, arg_103_12)

						arg_103_9[3] = var_103_1 + 2
						arg_103_9[1] = var_103_26
					end

					var_103_9 = var_103_9 + var_103_24
					arg_103_9[2] = var_103_25

					if not iter_103_1.empty then
						var_103_17 = var_103_17 + 1
					end
				end
			end

			arg_103_9[1] = var_103_6
			arg_103_9[2] = var_103_7
			arg_103_9[3] = var_103_8

			return var_103_9
		end
	},
	weave_progression_slot_titles = {
		setup_data = function()
			local var_104_0 = {
				{
					name = "talent_title",
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_6(18),
					text_color = {
						255,
						87,
						39,
						141
					},
					offset = {
						0,
						0,
						0
					}
				},
				{
					name = "trait_title",
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_6(18),
					text_color = Colors.get_color_table_with_alpha("font_title", 255),
					offset = {
						0,
						0,
						0
					}
				},
				{
					name = "title",
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					font_type = "hell_shark_header",
					font_size = var_0_6(28),
					text_color = Colors.get_color_table_with_alpha("font_title", 255),
					offset = {
						0,
						0,
						0
					}
				},
				{
					name = "property_title",
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_6(18),
					text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
					offset = {
						0,
						0,
						0
					}
				},
				{
					name = "sub_title",
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_6(18),
					text_color = {
						255,
						120,
						120,
						120
					},
					offset = {
						0,
						0,
						0
					}
				},
				{
					name = "description",
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_6(18),
					text_color = Colors.get_color_table_with_alpha("font_default", 255),
					offset = {
						0,
						0,
						0
					}
				},
				{
					texture = "weave_forge_slot_divider_tooltip",
					name = "divider",
					pass_type = "texture",
					horizontal_alignment = "center",
					height_margin = 5,
					vertical_alignment = "center",
					texture_size = {
						264,
						3
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
						0
					}
				},
				{
					name = "divider_description",
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_6(18),
					text_color = {
						255,
						120,
						120,
						120
					},
					offset = {
						0,
						0,
						0
					}
				},
				{
					texture = "weave_forge_slot_divider_tooltip",
					name = "description_divider",
					pass_type = "texture",
					horizontal_alignment = "center",
					required_pass_style = "divider_description",
					height_spacing = 5,
					height_margin = 5,
					vertical_alignment = "center",
					texture_size = {
						264,
						3
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
						0
					}
				},
				{
					name = "input",
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_6(18),
					text_color = {
						255,
						120,
						120,
						120
					},
					offset = {
						0,
						0,
						0
					}
				},
				{
					name = "essence_title",
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					font_type = "hell_shark_header",
					font_size = var_0_6(24),
					text_color = Colors.get_color_table_with_alpha("font_title", 255),
					offset = {
						0,
						0,
						0
					}
				},
				{
					name = "input_highlight",
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_6(18),
					text_color = Colors.get_color_table_with_alpha("font_default", 255),
					offset = {
						0,
						0,
						0
					}
				},
				{
					name = "upgrade_effect_title",
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_6(18),
					text_color = {
						255,
						120,
						120,
						120
					},
					offset = {
						0,
						0,
						0
					}
				},
				{
					name = "value",
					localize = false,
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					font_type = "hell_shark",
					font_size = var_0_6(18),
					text_color = {
						255,
						121,
						193,
						229
					},
					offset = {
						-35,
						0,
						0
					}
				},
				{
					texture = "icon_mastery_small",
					name = "mastery_icon",
					pass_type = "texture",
					ignore_line_change = true,
					required_pass_style = "value",
					horizontal_alignment = "center",
					height_margin = 0,
					vertical_alignment = "center",
					align_after_previous_width = true,
					texture_size = {
						35,
						35
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
						0
					}
				},
				{
					minimum_height = 50,
					name = "upgrade_power_text",
					localize = false,
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					height_spacing = 4,
					font_type = "hell_shark",
					font_size = var_0_6(20),
					text_color = Colors.get_color_table_with_alpha("font_default", 255),
					offset = {
						60,
						0,
						0
					}
				},
				{
					texture = "reinforcement_kill",
					name = "mastery_upgrade_icon",
					pass_type = "texture",
					ignore_line_change = true,
					required_pass_style = "upgrade_power_text",
					horizontal_alignment = "left",
					height_margin = 0,
					vertical_alignment = "center",
					texture_size = {
						26,
						26
					},
					color = {
						255,
						255,
						255,
						255
					},
					offset = {
						21,
						0,
						0
					}
				},
				{
					minimum_height = 50,
					name = "upgrade_mastery_text",
					localize = false,
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					height_spacing = 4,
					font_type = "hell_shark",
					font_size = var_0_6(20),
					text_color = Colors.get_color_table_with_alpha("font_default", 255),
					offset = {
						60,
						0,
						0
					}
				},
				{
					texture = "icon_mastery_big",
					name = "mastery_upgrade_icon",
					pass_type = "texture",
					ignore_line_change = true,
					required_pass_style = "upgrade_mastery_text",
					horizontal_alignment = "left",
					height_margin = 0,
					vertical_alignment = "center",
					texture_size = {
						38,
						38
					},
					color = {
						255,
						255,
						255,
						255
					},
					offset = {
						16,
						0,
						0
					}
				},
				{
					minimum_height = 50,
					name = "upgrade_property_text",
					localize = false,
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					height_spacing = 4,
					font_type = "hell_shark",
					font_size = var_0_6(20),
					text_color = Colors.get_color_table_with_alpha("font_default", 255),
					offset = {
						60,
						0,
						0
					}
				},
				{
					texture = "athanor_tooltip_icon_property",
					name = "property_slot_icon",
					pass_type = "texture",
					ignore_line_change = true,
					required_pass_style = "upgrade_property_text",
					horizontal_alignment = "left",
					height_margin = 0,
					vertical_alignment = "center",
					texture_size = {
						48,
						48
					},
					color = {
						255,
						255,
						255,
						255
					},
					offset = {
						10,
						0,
						0
					}
				},
				{
					minimum_height = 50,
					name = "upgrade_trait_text",
					localize = false,
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					height_spacing = 4,
					font_type = "hell_shark",
					font_size = var_0_6(20),
					text_color = Colors.get_color_table_with_alpha("font_default", 255),
					offset = {
						60,
						0,
						0
					}
				},
				{
					texture = "athanor_tooltip_icon_trait",
					name = "trait_slot_icon",
					pass_type = "texture",
					ignore_line_change = true,
					required_pass_style = "upgrade_trait_text",
					horizontal_alignment = "left",
					height_margin = 0,
					vertical_alignment = "center",
					texture_size = {
						48,
						48
					},
					color = {
						255,
						255,
						255,
						255
					},
					offset = {
						10,
						0,
						0
					}
				},
				{
					minimum_height = 50,
					name = "upgrade_talent_text",
					localize = false,
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "left",
					vertical_alignment = "center",
					height_spacing = 4,
					font_type = "hell_shark",
					font_size = var_0_6(20),
					text_color = Colors.get_color_table_with_alpha("font_default", 255),
					offset = {
						60,
						0,
						0
					}
				},
				{
					texture = "athanor_tooltip_icon_talent",
					name = "talent_slot_icon",
					pass_type = "texture",
					ignore_line_change = true,
					required_pass_style = "upgrade_talent_text",
					horizontal_alignment = "left",
					height_margin = 0,
					vertical_alignment = "center",
					texture_size = {
						48,
						48
					},
					color = {
						255,
						255,
						255,
						255
					},
					offset = {
						10,
						0,
						0
					}
				}
			}

			return {
				styles = var_104_0,
				pass_content = {},
				texture_pass_data = {},
				texture_pass_definition = {},
				text_pass_data = {},
				text_pass_size = {}
			}
		end,
		draw = function(arg_105_0, arg_105_1, arg_105_2, arg_105_3, arg_105_4, arg_105_5, arg_105_6, arg_105_7, arg_105_8, arg_105_9, arg_105_10, arg_105_11, arg_105_12, arg_105_13)
			local var_105_0 = 255 * arg_105_4.alpha_multiplier
			local var_105_1 = arg_105_4.start_layer or var_0_3
			local var_105_2 = 20
			local var_105_3 = arg_105_0.frame_margin or 0
			local var_105_4 = arg_105_0.styles
			local var_105_5 = arg_105_0.pass_content

			table.clear(var_105_5)

			local var_105_6 = arg_105_10[1]
			local var_105_7 = arg_105_10[2]
			local var_105_8 = arg_105_9[1]
			local var_105_9 = arg_105_9[2]
			local var_105_10 = arg_105_9[3]

			arg_105_9[1] = arg_105_9[1] + var_105_3
			arg_105_9[3] = var_105_1 + 2

			local var_105_11 = arg_105_0.texture_pass_definition
			local var_105_12 = arg_105_0.texture_pass_data
			local var_105_13 = arg_105_0.text_pass_data
			local var_105_14 = arg_105_0.text_pass_size

			arg_105_10[1] = arg_105_10[1] - var_105_3 * 2
			var_105_14[1] = arg_105_10[1]
			var_105_14[2] = 0

			local var_105_15 = 5
			local var_105_16 = 0
			local var_105_17 = 0

			for iter_105_0, iter_105_1 in ipairs(var_105_4) do
				local var_105_18 = iter_105_1.pass_type
				local var_105_19 = iter_105_1.name
				local var_105_20 = iter_105_1.ignore_line_change
				local var_105_21 = iter_105_1.minimum_height or 0
				local var_105_22 = iter_105_1.height_spacing
				local var_105_23 = iter_105_1.offset

				if var_105_18 == "text" then
					var_105_5[var_105_19] = arg_105_13[var_105_19] or iter_105_1.text
				elseif var_105_18 == "texture" then
					var_105_5[var_105_19] = iter_105_1.texture
				end

				local var_105_24 = iter_105_1.required_pass_style

				if var_105_5[var_105_19] and (not var_105_24 or var_105_5[var_105_24] ~= nil) then
					if var_105_22 then
						arg_105_9[2] = arg_105_9[2] + var_105_22
						var_105_15 = var_105_15 + var_105_22
					end

					arg_105_9[1] = var_105_8 + var_105_3

					if var_105_18 == "text" then
						local var_105_25 = var_105_5[var_105_19]

						if var_105_25 then
							var_105_13.text_id = var_105_19
							var_105_14[1] = arg_105_10[1] - var_105_23[1]
							var_105_14[2] = 0

							local var_105_26, var_105_27 = UIUtils.get_text_height(arg_105_3, var_105_14, iter_105_1, var_105_25)
							local var_105_28 = UIUtils.get_text_width(arg_105_3, iter_105_1, var_105_25)

							if var_105_26 < var_105_21 then
								var_105_26 = var_105_21
							end

							var_105_16 = var_105_28
							var_105_17 = var_105_26

							if var_105_20 then
								arg_105_9[2] = var_105_9 - var_105_15
							else
								arg_105_9[2] = var_105_9 - (var_105_15 + var_105_26)
								var_105_15 = var_105_15 + var_105_26
							end

							arg_105_9[1] = arg_105_9[1] + var_105_23[1]
							arg_105_9[2] = arg_105_9[2] + var_105_23[2]

							if arg_105_1 then
								var_105_14[2] = var_105_26
								iter_105_1.text_color[1] = var_105_0

								UIPasses.text.draw(arg_105_3, var_105_13, arg_105_5, arg_105_6, iter_105_1, var_105_5, arg_105_9, var_105_14, arg_105_11, arg_105_12)
							end
						end
					elseif var_105_18 == "texture" then
						var_105_11.texture_id = var_105_19
						iter_105_1.color[1] = var_105_0

						local var_105_29 = iter_105_1.texture_size
						local var_105_30 = var_105_29[1]
						local var_105_31 = var_105_29[2]
						local var_105_32 = iter_105_1.height_margin or 0

						if not iter_105_1.width_margin then
							local var_105_33 = 0
						end

						if var_105_31 < var_105_21 then
							var_105_31 = var_105_21
						end

						if var_105_20 then
							arg_105_9[2] = var_105_9 - var_105_15 + var_105_17 / 2
						else
							arg_105_9[2] = var_105_9 - (var_105_15 + var_105_31 / 2 + var_105_32)
							var_105_15 = var_105_15 + var_105_31 + var_105_32 * 2
						end

						if iter_105_1.align_after_previous_width then
							var_105_23[1] = (var_105_16 + var_105_30) / 2 - var_105_30 / 2
						end

						arg_105_9[1] = math.round(arg_105_9[1] + var_105_23[1])
						arg_105_9[2] = math.round(arg_105_9[2] + var_105_23[2])

						if arg_105_1 then
							UIPasses.texture.draw(arg_105_3, var_105_12, arg_105_5, var_105_11, iter_105_1, var_105_5, arg_105_9, arg_105_10, arg_105_11, arg_105_12)
						end
					end
				end
			end

			arg_105_10[1] = var_105_6
			arg_105_10[2] = var_105_7
			arg_105_9[1] = var_105_8
			arg_105_9[2] = var_105_9
			arg_105_9[3] = var_105_10

			return var_105_15
		end
	},
	athanor_upgrade_tooltip = {
		setup_data = function()
			local var_106_0 = {
				upgrade_property_text = {
					minimum_height = 35,
					localize = false,
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					font_type = "hell_shark",
					font_size = var_0_6(20),
					text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
					offset = {
						60,
						0,
						0
					}
				},
				property_slot_icon = {
					vertical_alignment = "bottom",
					height_spacing = 25,
					pass_type = "texture",
					horizontal_alignment = "left",
					ignore_line_change = true,
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
						10,
						0,
						0
					}
				},
				upgrade_trait_text = {
					minimum_height = 35,
					localize = false,
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					font_type = "hell_shark",
					font_size = var_0_6(20),
					text_color = Colors.get_color_table_with_alpha("font_title", 255),
					offset = {
						60,
						0,
						0
					}
				},
				trait_slot_icon = {
					vertical_alignment = "bottom",
					height_spacing = 25,
					pass_type = "texture",
					horizontal_alignment = "left",
					ignore_line_change = true,
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
						10,
						0,
						0
					}
				}
			}

			return {
				styles = var_106_0,
				pass_content = {},
				texture_pass_data = {},
				texture_pass_definition = {},
				text_pass_data = {},
				text_pass_size = {}
			}
		end,
		draw = function(arg_107_0, arg_107_1, arg_107_2, arg_107_3, arg_107_4, arg_107_5, arg_107_6, arg_107_7, arg_107_8, arg_107_9, arg_107_10, arg_107_11, arg_107_12, arg_107_13)
			local var_107_0 = 255 * arg_107_4.alpha_multiplier
			local var_107_1 = arg_107_4.start_layer or var_0_3
			local var_107_2 = 20
			local var_107_3 = arg_107_0.frame_margin or 0
			local var_107_4 = arg_107_0.styles
			local var_107_5 = arg_107_0.pass_content

			table.clear(var_107_5)

			local var_107_6 = arg_107_10[1]
			local var_107_7 = arg_107_10[2]
			local var_107_8 = arg_107_9[1]
			local var_107_9 = arg_107_9[2]
			local var_107_10 = arg_107_9[3]

			arg_107_9[1] = arg_107_9[1] + var_107_3
			arg_107_9[3] = var_107_1 + 2

			local var_107_11 = arg_107_0.texture_pass_definition
			local var_107_12 = arg_107_0.texture_pass_data
			local var_107_13 = arg_107_0.text_pass_data
			local var_107_14 = arg_107_0.text_pass_size

			arg_107_10[1] = arg_107_10[1] - var_107_3 * 2
			var_107_14[1] = arg_107_10[1]
			var_107_14[2] = 0

			local var_107_15 = 5
			local var_107_16 = 0
			local var_107_17 = 0
			local var_107_18 = arg_107_13.property_unlocks
			local var_107_19 = arg_107_13.trait_unlocks
			local var_107_20 = {}

			for iter_107_0, iter_107_1 in pairs(arg_107_13) do
				if type(iter_107_1) == "table" then
					if iter_107_0 == "property_unlock_table" then
						for iter_107_2, iter_107_3 in ipairs(iter_107_1) do
							var_107_20[#var_107_20 + 1] = {
								style_name = "property_slot_icon",
								value = iter_107_3.icon
							}
							var_107_20[#var_107_20 + 1] = {
								style_name = "upgrade_property_text",
								value = iter_107_3.text
							}
						end
					elseif iter_107_0 == "trait_unlock_table" then
						for iter_107_4, iter_107_5 in ipairs(iter_107_1) do
							var_107_20[#var_107_20 + 1] = {
								style_name = "trait_slot_icon",
								value = iter_107_5.icon
							}
							var_107_20[#var_107_20 + 1] = {
								style_name = "upgrade_trait_text",
								value = iter_107_5.text
							}
						end
					end
				end
			end

			for iter_107_6, iter_107_7 in ipairs(var_107_20) do
				local var_107_21 = iter_107_7.style_name
				local var_107_22 = var_107_4[var_107_21]

				var_107_5[var_107_21] = iter_107_7.value

				local var_107_23 = var_107_22.pass_type
				local var_107_24 = var_107_22.ignore_line_change
				local var_107_25 = var_107_22.minimum_height or 0
				local var_107_26 = var_107_22.height_spacing
				local var_107_27 = var_107_22.offset
				local var_107_28 = var_107_27[1]
				local var_107_29 = var_107_27[2]

				if var_107_26 then
					arg_107_9[2] = arg_107_9[2] + var_107_26
					var_107_15 = var_107_15 + var_107_26
				end

				arg_107_9[1] = var_107_8 + var_107_3

				if var_107_23 == "text" then
					local var_107_30 = var_107_5[var_107_21]

					if var_107_30 then
						var_107_13.text_id = var_107_21
						var_107_14[1] = arg_107_10[1] - var_107_27[1]
						var_107_14[2] = 0

						local var_107_31, var_107_32 = UIUtils.get_text_height(arg_107_3, var_107_14, var_107_22, var_107_30)
						local var_107_33 = UIUtils.get_text_width(arg_107_3, var_107_22, var_107_30)

						if var_107_31 < var_107_25 then
							var_107_31 = var_107_25
						end

						var_107_16 = var_107_33

						local var_107_34 = var_107_31

						if var_107_24 then
							arg_107_9[2] = var_107_9 - var_107_15
						else
							arg_107_9[2] = var_107_9 - (var_107_15 + var_107_31)
							var_107_15 = var_107_15 + var_107_31
						end

						arg_107_9[1] = arg_107_9[1] + var_107_27[1]
						arg_107_9[2] = arg_107_9[2] + var_107_27[2]

						if arg_107_1 then
							var_107_14[2] = var_107_31
							var_107_22.text_color[1] = var_107_0

							UIPasses.text.draw(arg_107_3, var_107_13, arg_107_5, arg_107_6, var_107_22, var_107_5, arg_107_9, var_107_14, arg_107_11, arg_107_12)
						end
					end
				elseif var_107_23 == "texture" then
					var_107_11.texture_id = var_107_21
					var_107_22.color[1] = var_107_0

					local var_107_35 = var_107_22.texture_size
					local var_107_36 = var_107_35[1]
					local var_107_37 = var_107_35[2]
					local var_107_38 = var_107_22.height_margin or 0

					if not var_107_22.width_margin then
						local var_107_39 = 0
					end

					if var_107_37 < var_107_25 then
						var_107_37 = var_107_25
					end

					if var_107_24 then
						arg_107_9[2] = var_107_9 - (var_107_15 + var_107_37 + var_107_38)
					else
						arg_107_9[2] = var_107_9 - (var_107_15 + var_107_37 / 2 + var_107_38)
						var_107_15 = var_107_15 + var_107_37 + var_107_38 * 2
					end

					if var_107_22.align_after_previous_width then
						var_107_27[1] = (var_107_16 + var_107_36) / 2 - var_107_36 / 2
					end

					arg_107_9[1] = math.round(arg_107_9[1] + var_107_27[1])
					arg_107_9[2] = math.round(arg_107_9[2] + var_107_27[2])

					if arg_107_1 then
						UIPasses.texture.draw(arg_107_3, var_107_12, arg_107_5, var_107_11, var_107_22, var_107_5, arg_107_9, arg_107_10, arg_107_11, arg_107_12)
					end
				end

				var_107_27[1] = var_107_28
				var_107_27[2] = var_107_29
			end

			arg_107_10[1] = var_107_6
			arg_107_10[2] = var_107_7
			arg_107_9[1] = var_107_8
			arg_107_9[2] = var_107_9
			arg_107_9[3] = var_107_10

			return var_107_15 + var_107_2
		end
	},
	special_action_tooltip = {
		setup_data = function()
			return {
				frame_margin = 0,
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {},
				style_text = {
					vertical_alignment = "center",
					localize = false,
					horizontal_alignment = "center",
					word_wrap = true,
					font_type = "hell_shark",
					font_size = var_0_6(16),
					text_color = Colors.get_color_table_with_alpha("font_default", 255),
					offset = {
						0,
						-5,
						0
					}
				},
				style_background = {
					color = {
						255,
						0,
						0,
						0
					},
					texture_size = {
						0,
						0
					},
					offset = {
						0,
						0,
						9
					}
				}
			}
		end,
		draw = function(arg_109_0, arg_109_1, arg_109_2, arg_109_3, arg_109_4, arg_109_5, arg_109_6, arg_109_7, arg_109_8, arg_109_9, arg_109_10, arg_109_11, arg_109_12, arg_109_13)
			local var_109_0 = arg_109_13.data
			local var_109_1 = var_109_0.temporary_template or var_109_0.template
			local var_109_2 = WeaponUtils.get_weapon_template(var_109_1)
			local var_109_3 = var_109_2 and var_109_2.tooltip_special_action_description

			if not var_109_3 then
				return 0
			end

			local var_109_4 = 255 * arg_109_4.alpha_multiplier
			local var_109_5 = arg_109_4.start_layer or var_0_3
			local var_109_6 = arg_109_0.frame_margin
			local var_109_7 = arg_109_0.text_pass_data
			local var_109_8 = arg_109_0.content
			local var_109_9 = Colors.color_definitions.font_title
			local var_109_10 = string.format("{#color(%d,%d,%d)}%s:{#reset()} %s", var_109_9[2], var_109_9[3], var_109_9[4], Localize("action_three"), Localize(var_109_3))

			var_109_8.text = var_109_10

			local var_109_11 = arg_109_9[1]
			local var_109_12 = arg_109_9[2]
			local var_109_13 = arg_109_9[3]
			local var_109_14 = arg_109_0.style_text
			local var_109_15 = arg_109_0.text_size
			local var_109_16 = arg_109_10[1] - var_109_6 * 2

			var_109_15[1] = var_109_16
			var_109_15[2] = 0

			local var_109_17 = UIUtils.get_text_height(arg_109_3, var_109_15, var_109_14, var_109_10)
			local var_109_18 = var_109_6 + var_109_17

			var_109_15[1] = var_109_16
			var_109_15[2] = var_109_17

			if arg_109_1 then
				local var_109_19 = arg_109_0.style_background
				local var_109_20 = var_109_19.texture_size
				local var_109_21 = var_109_19.color

				var_109_21[1] = var_109_4
				var_109_20[1] = arg_109_10[1]
				var_109_20[2] = var_109_18
				arg_109_9[2] = var_109_12 - var_109_20[2]
				arg_109_9[3] = var_109_5 + 1

				var_0_0.draw_rect(arg_109_3, arg_109_9, var_109_20, var_109_21)

				arg_109_9[2] = var_109_12
				arg_109_9[3] = var_109_13
				arg_109_9[1] = arg_109_9[1] + var_109_6 + var_109_14.offset[1]
				arg_109_9[2] = arg_109_9[2] + var_109_6 + var_109_14.offset[2] - var_109_18
				arg_109_9[3] = var_109_5 + 2 + var_109_14.offset[3]
				var_109_14.text_color[1] = var_109_4

				UIPasses.text.draw(arg_109_3, var_109_7, arg_109_5, arg_109_6, var_109_14, var_109_8, arg_109_9, var_109_15, arg_109_11, arg_109_12)
			end

			arg_109_9[1] = var_109_11
			arg_109_9[2] = var_109_12
			arg_109_9[3] = var_109_13

			return var_109_18
		end
	},
	console_special_action_tooltip = {
		setup_data = function()
			return {
				frame_margin = 0,
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {},
				style_text = {
					vertical_alignment = "center",
					localize = false,
					horizontal_alignment = "center",
					word_wrap = true,
					font_type = "hell_shark",
					font_size = var_0_6(16),
					text_color = Colors.get_color_table_with_alpha("font_default", 255),
					offset = {
						0,
						0,
						0
					}
				}
			}
		end,
		draw = function(arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4, arg_111_5, arg_111_6, arg_111_7, arg_111_8, arg_111_9, arg_111_10, arg_111_11, arg_111_12, arg_111_13)
			local var_111_0 = arg_111_13.data
			local var_111_1 = var_111_0.temporary_template or var_111_0.template
			local var_111_2 = WeaponUtils.get_weapon_template(var_111_1)
			local var_111_3 = var_111_2 and var_111_2.tooltip_special_action_description

			if not var_111_3 then
				return 0
			end

			local var_111_4 = 255 * arg_111_4.alpha_multiplier
			local var_111_5 = arg_111_4.start_layer or var_0_3
			local var_111_6 = arg_111_0.frame_margin
			local var_111_7 = arg_111_0.text_pass_data
			local var_111_8 = arg_111_0.content
			local var_111_9 = Colors.color_definitions.font_title
			local var_111_10 = string.format("{#color(%d,%d,%d)}%s:{#reset()} %s", var_111_9[2], var_111_9[3], var_111_9[4], Localize("action_three"), Localize(var_111_3))

			var_111_8.text = var_111_10

			local var_111_11 = arg_111_9[1]
			local var_111_12 = arg_111_9[2]
			local var_111_13 = arg_111_9[3]
			local var_111_14 = arg_111_0.style_text
			local var_111_15 = arg_111_0.text_size

			var_111_15[1] = arg_111_10[1] - var_111_6 * 2
			var_111_15[2] = 0

			local var_111_16 = UIUtils.get_text_height(arg_111_3, var_111_15, var_111_14, var_111_10)
			local var_111_17 = var_111_6 + var_111_16

			var_111_15[2] = var_111_16

			if arg_111_1 then
				arg_111_9[1] = arg_111_9[1] + var_111_6 + var_111_14.offset[1]
				arg_111_9[2] = arg_111_9[2] + var_111_6 + var_111_14.offset[2] - var_111_17
				arg_111_9[3] = var_111_5 + 2 + var_111_14.offset[3]
				var_111_14.text_color[1] = var_111_4

				UIPasses.text.draw(arg_111_3, var_111_7, arg_111_5, arg_111_6, var_111_14, var_111_8, arg_111_9, var_111_15, arg_111_11, arg_111_12)
			end

			arg_111_9[1] = var_111_11
			arg_111_9[2] = var_111_12
			arg_111_9[3] = var_111_13

			return var_111_17
		end
	},
	other_equipped_careers_tooltip = {
		setup_data = function()
			local var_112_0 = Colors.color_definitions.font_title

			return {
				frame_margin = 0,
				prefix = string.format("{#color(%d,%d,%d)}%s:{#reset()} ", var_112_0[2], var_112_0[3], var_112_0[4], Localize("equipped_on_other_career")),
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				edge_size = {
					0,
					5
				},
				edge_holder_size = {
					9,
					17
				},
				content = {
					edge_holder_right = "menu_frame_12_divider_right",
					edge_texture = "menu_frame_12_divider",
					edge_holder_left = "menu_frame_12_divider_left"
				},
				edge = {
					texture_size = {
						1,
						5
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
				},
				edge_holder = {
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
				style_text = {
					vertical_alignment = "center",
					localize = false,
					horizontal_alignment = "center",
					word_wrap = true,
					font_type = "hell_shark",
					font_size = var_0_6(16),
					text_color = Colors.get_color_table_with_alpha("font_default", 255),
					offset = {
						0,
						0,
						0
					}
				},
				style_background = {
					color = {
						255,
						0,
						0,
						0
					},
					texture_size = {
						0,
						0
					},
					offset = {
						0,
						0,
						9
					}
				}
			}
		end,
		draw = function(arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4, arg_113_5, arg_113_6, arg_113_7, arg_113_8, arg_113_9, arg_113_10, arg_113_11, arg_113_12, arg_113_13)
			local var_113_0

			if arg_113_13.data and CosmeticUtils.is_cosmetic_item(arg_113_13.data.slot_type) then
				var_113_0 = arg_113_13.ItemId
			else
				var_113_0 = arg_113_13.backend_id
			end

			if not var_113_0 then
				return 0
			end

			local var_113_1 = Managers.backend:get_interface("items"):equipped_by_loadout(var_113_0)

			if table.is_empty(var_113_1) then
				return 0
			end

			local var_113_2 = FrameTable.alloc_table()
			local var_113_3 = FrameTable.alloc_table()

			for iter_113_0, iter_113_1 in pairs(var_113_1) do
				local var_113_4 = Localize(iter_113_0)
				local var_113_5 = iter_113_1.num_loadouts

				for iter_113_2 = 1, #iter_113_1 do
					local var_113_6 = iter_113_1[iter_113_2]
					local var_113_7 = var_113_4 .. (var_113_5 > 1 and string.format("{#color(193,91,36)} (%d){#reset()}", var_113_6) or "")

					if not var_113_2[var_113_7] then
						var_113_2[var_113_7] = true
						var_113_3[#var_113_3 + 1] = var_113_7
					end
				end
			end

			local var_113_8 = table.concat(var_113_3, ", ")
			local var_113_9 = 255 * arg_113_4.alpha_multiplier
			local var_113_10 = arg_113_4.start_layer or var_0_3
			local var_113_11 = arg_113_0.frame_margin
			local var_113_12 = arg_113_0.text_pass_data
			local var_113_13 = arg_113_0.content
			local var_113_14 = arg_113_0.prefix .. var_113_8

			var_113_13.text = var_113_14

			local var_113_15 = arg_113_9[1]
			local var_113_16 = arg_113_9[2]
			local var_113_17 = arg_113_9[3]
			local var_113_18 = arg_113_0.style_text
			local var_113_19 = arg_113_0.text_size
			local var_113_20 = arg_113_10[1] - var_113_11 * 2

			var_113_19[1] = var_113_20
			var_113_19[2] = 0

			local var_113_21 = UIUtils.get_text_height(arg_113_3, var_113_19, var_113_18, var_113_14)
			local var_113_22 = var_113_11 + var_113_21

			var_113_19[1] = var_113_20
			var_113_19[2] = var_113_21

			local var_113_23 = RESOLUTION_LOOKUP.inv_scale

			if arg_113_1 then
				local var_113_24 = arg_113_0.style_background
				local var_113_25 = var_113_24.texture_size
				local var_113_26 = var_113_24.color

				var_113_26[1] = var_113_9
				var_113_25[1] = arg_113_10[1]
				var_113_25[2] = var_113_22
				arg_113_9[2] = var_113_16 - var_113_25[2]
				arg_113_9[3] = var_113_10 + 1

				var_0_0.draw_rect(arg_113_3, arg_113_9, var_113_25, var_113_26)

				arg_113_9[2] = var_113_16
				arg_113_9[3] = var_113_17

				local var_113_27 = arg_113_0.edge_size

				var_113_27[1] = arg_113_10[1]

				local var_113_28 = arg_113_0.edge.color
				local var_113_29 = arg_113_0.edge.texture_size

				var_113_29[1] = arg_113_10[1]

				local var_113_30 = var_113_13.edge_texture

				var_113_28[1] = var_113_9

				local var_113_31 = arg_113_9[2] - var_113_11 * 0.5 * var_113_23

				arg_113_9[2] = var_113_31
				arg_113_9[3] = var_113_10 + 4

				var_0_0.draw_tiled_texture(arg_113_3, var_113_30, arg_113_9, var_113_27, var_113_29, var_113_28)

				local var_113_32 = arg_113_0.edge_holder
				local var_113_33 = arg_113_0.edge_holder_size
				local var_113_34 = var_113_32.color
				local var_113_35 = var_113_13.edge_holder_left
				local var_113_36 = var_113_13.edge_holder_right

				var_113_34[1] = var_113_9
				arg_113_9[1] = arg_113_9[1] + 3
				arg_113_9[2] = var_113_31 - 6
				arg_113_9[3] = var_113_10 + 6

				var_0_0.draw_texture(arg_113_3, var_113_35, arg_113_9, var_113_33, var_113_34)

				arg_113_9[1] = arg_113_9[1] + var_113_27[1] - (var_113_33[1] + 6)

				var_0_0.draw_texture(arg_113_3, var_113_36, arg_113_9, var_113_33, var_113_34)

				arg_113_9[1] = var_113_15 + var_113_11 + var_113_18.offset[1]
				arg_113_9[2] = var_113_31 + var_113_11 + var_113_18.offset[2] - var_113_22
				arg_113_9[3] = var_113_10 + 2 + var_113_18.offset[3]
				var_113_18.text_color[1] = var_113_9

				UIPasses.text.draw(arg_113_3, var_113_12, arg_113_5, arg_113_6, var_113_18, var_113_13, arg_113_9, var_113_19, arg_113_11, arg_113_12)
			end

			arg_113_9[1] = var_113_15
			arg_113_9[2] = var_113_16
			arg_113_9[3] = var_113_17

			return var_113_22
		end
	},
	console_other_equipped_careers_tooltip = {
		setup_data = function()
			local var_114_0 = Colors.color_definitions.font_title

			return {
				frame_margin = 0,
				prefix = string.format("{#color(%d,%d,%d)}%s:{#reset()} ", var_114_0[2], var_114_0[3], var_114_0[4], Localize("equipped_on_other_career")),
				text_pass_data = {
					text_id = "text"
				},
				text_size = {},
				content = {},
				style_text = {
					vertical_alignment = "center",
					localize = false,
					horizontal_alignment = "center",
					word_wrap = true,
					font_type = "hell_shark",
					font_size = var_0_6(16),
					text_color = Colors.get_color_table_with_alpha("font_default", 255),
					offset = {
						0,
						0,
						0
					}
				}
			}
		end,
		draw = function(arg_115_0, arg_115_1, arg_115_2, arg_115_3, arg_115_4, arg_115_5, arg_115_6, arg_115_7, arg_115_8, arg_115_9, arg_115_10, arg_115_11, arg_115_12, arg_115_13)
			local var_115_0

			if arg_115_13.data and CosmeticUtils.is_cosmetic_item(arg_115_13.data.slot_type) then
				var_115_0 = arg_115_13.ItemId
			else
				var_115_0 = arg_115_13.backend_id
			end

			if not var_115_0 then
				return 0
			end

			local var_115_1 = Managers.backend:get_interface("items"):equipped_by_loadout(var_115_0)

			if table.is_empty(var_115_1) then
				return 0
			end

			local var_115_2 = FrameTable.alloc_table()
			local var_115_3 = FrameTable.alloc_table()

			for iter_115_0, iter_115_1 in pairs(var_115_1) do
				local var_115_4 = Localize(iter_115_0)
				local var_115_5 = iter_115_1.num_loadouts

				for iter_115_2 = 1, #iter_115_1 do
					local var_115_6 = iter_115_1[iter_115_2]
					local var_115_7 = var_115_4 .. (var_115_5 > 1 and string.format("{#color(193,91,36)} (%d){#reset()}", var_115_6) or "")

					if not var_115_2[var_115_7] then
						var_115_2[var_115_7] = true
						var_115_3[#var_115_3 + 1] = var_115_7
					end
				end
			end

			local var_115_8 = table.concat(var_115_3, ", ")
			local var_115_9 = 255 * arg_115_4.alpha_multiplier
			local var_115_10 = arg_115_4.start_layer or var_0_3
			local var_115_11 = arg_115_0.frame_margin
			local var_115_12 = arg_115_0.text_pass_data
			local var_115_13 = arg_115_0.content
			local var_115_14 = arg_115_0.prefix .. var_115_8

			var_115_13.text = var_115_14

			local var_115_15 = arg_115_9[1]
			local var_115_16 = arg_115_9[2]
			local var_115_17 = arg_115_9[3]
			local var_115_18 = arg_115_0.style_text
			local var_115_19 = arg_115_0.text_size

			var_115_19[1] = arg_115_10[1] - var_115_11 * 2
			var_115_19[2] = 0

			local var_115_20 = UIUtils.get_text_height(arg_115_3, var_115_19, var_115_18, var_115_14)
			local var_115_21 = var_115_11 * 0.5 + var_115_20

			var_115_19[2] = var_115_20

			if arg_115_1 then
				arg_115_9[1] = var_115_15 + var_115_11
				arg_115_9[2] = var_115_16 - var_115_21 + 5
				arg_115_9[3] = var_115_10 + 2 + var_115_18.offset[3]
				var_115_18.text_color[1] = var_115_9

				UIPasses.text.draw(arg_115_3, var_115_12, arg_115_5, arg_115_6, var_115_18, var_115_13, arg_115_9, var_115_19, arg_115_11, arg_115_12)
			end

			arg_115_9[1] = var_115_15
			arg_115_9[2] = var_115_16
			arg_115_9[3] = var_115_17

			return var_115_21
		end
	}
}
