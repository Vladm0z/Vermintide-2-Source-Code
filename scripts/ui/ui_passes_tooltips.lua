-- chunkname: @scripts/ui/ui_passes_tooltips.lua

local UITooltipPasses = UITooltipPasses

UITooltipPasses = UITooltipPasses or {}
UITooltipPasses = UITooltipPasses

local UIRenderer = UIRenderer
local draw_texture = UIRenderer.draw_texture
local draw_texture_uv = UIRenderer.draw_texture_uv
local num = 994
local num_2 = 1.4
local str = "???"

local function fn(arg_1_0)
	-- function 1
	if not IS_WINDOWS then
		return math.floor(arg_1_0 * num_2)
	end

	return arg_1_0
end

UITooltipPasses = {
	background = {
		setup_data = function ()
			-- function 2
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
		draw = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9, arg_3_10, arg_3_11, arg_3_12)
			-- function 3
			local num_2 = 255 * arg_3_4.alpha_multiplier
			local start_layer = arg_3_4.start_layer

			start_layer = start_layer or num

			local frame_name = self.frame_name
			local var_3_3 = UIFrameSettings[frame_name]
			local var_3_4 = var_3_3.texture_sizes.horizontal[2]

			if not arg_3_1 then
				if not arg_3_2 then
					arg_3_9[2] = arg_3_9[2] - arg_3_10[2] - var_3_4 * 2
				end

				arg_3_10[2] = arg_3_10[2] + var_3_4 * 2
				arg_3_9[3] = start_layer

				local background_color = self.background_color

				background_color[1] = num_2

				UIRenderer.draw_rect(arg_3_3, arg_3_9, arg_3_10, background_color)

				arg_3_9[3] = start_layer + 5

				local frame_color = self.frame_color

				frame_color[1] = num_2

				UIRenderer.draw_texture_frame(arg_3_3, arg_3_9, arg_3_10, var_3_3.texture, var_3_3.texture_size, var_3_3.texture_sizes, frame_color)
			end

			return var_3_4 * 2
		end
	},
	item_background = {
		setup_data = function ()
			-- function 4
			local str = "item_tooltip_frame_01"
			local var_4_1 = UIFrameSettings[str].texture_sizes.horizontal[2]

			return {
				background_texture = "item_tooltip_background",
				frame_name = str,
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
		draw = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10, arg_5_11, arg_5_12, arg_5_13)
			-- function 5
			local num_2 = 255 * arg_5_4.alpha_multiplier
			local start_layer = arg_5_4.start_layer

			start_layer = start_layer or num

			local frame_name = self.frame_name
			local var_5_3 = UIFrameSettings[frame_name]
			local var_5_4 = var_5_3.texture_sizes.horizontal[2]

			if not arg_5_1 then
				local data = arg_5_13.data
				local rarity = arg_5_13.rarity

				rarity = rarity or data.rarity

				local get_table = Colors.get_table(rarity)

				arg_5_9[2] = arg_5_9[2] - arg_5_10[2] - var_5_4 * 2
				arg_5_10[2] = arg_5_10[2] + var_5_4 * 2 - 2
				arg_5_9[3] = start_layer

				local background_texture = self.background_texture
				local background_texture_size = self.background_texture_size

				background_texture_size[1] = arg_5_10[1]

				local size = UIAtlasHelper.get_atlas_settings_by_texture_name(background_texture).size
				local uvs = self.uvs

				uvs[2][1] = math.min(arg_5_10[1] / size[1], 1)
				uvs[2][2] = math.min(arg_5_10[2] / size[2], 1)

				local background_color = self.background_color

				UIRenderer.draw_tiled_texture(arg_5_3, background_texture, arg_5_9, arg_5_10, background_texture_size, background_color)

				arg_5_10[2] = arg_5_10[2] + 2
				arg_5_9[3] = start_layer + 5

				local frame_color = self.frame_color

				frame_color[1] = num_2

				UIRenderer.draw_texture_frame(arg_5_3, arg_5_9, arg_5_10, var_5_3.texture, var_5_3.texture_size, var_5_3.texture_sizes, frame_color)
			end

			return var_5_4 * 2
		end
	},
	console_item_background = {
		setup_data = function ()
			-- function 6
			local str = "frame_outer_fade_02"

			return {
				background_texture = "item_tooltip_background",
				frame_name = str,
				color = table.clone(UISettings.console_menu_rect_color)
			}
		end,
		draw = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7, arg_7_8, arg_7_9, arg_7_10, arg_7_11, arg_7_12, arg_7_13)
			-- function 7
			local num_2 = 210 * arg_7_4.alpha_multiplier
			local start_layer = arg_7_4.start_layer

			start_layer = start_layer or num

			local frame_name = self.frame_name
			local var_7_3 = UIFrameSettings[frame_name]
			local var_7_4 = var_7_3.texture_sizes.horizontal[2]

			if not arg_7_1 then
				arg_7_9[3] = start_layer

				local color = self.color

				color[1] = num_2

				UIRenderer.draw_rect(arg_7_3, arg_7_9, arg_7_10, color)

				local num_3 = var_7_4 * 2

				arg_7_10[1] = arg_7_10[1] + num_3
				arg_7_10[2] = arg_7_10[2] + num_3
				arg_7_9[1] = arg_7_9[1] - var_7_4
				arg_7_9[2] = arg_7_9[2] - var_7_4
				arg_7_9[3] = start_layer + 5

				UIRenderer.draw_texture_frame(arg_7_3, arg_7_9, arg_7_10, var_7_3.texture, var_7_3.texture_size, var_7_3.texture_sizes, color)
			end

			return var_7_4 * 2
		end
	},
	craft_item_background = {
		setup_data = function ()
			-- function 8
			local str = "menu_frame_15"
			local var_8_1 = UIFrameSettings[str].texture_sizes.horizontal[2]

			return {
				background_texture = "menu_frame_bg_06",
				frame_name = str,
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
		draw = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_11, arg_9_12, arg_9_13)
			-- function 9
			local num_2 = 255 * arg_9_4.alpha_multiplier
			local start_layer = arg_9_4.start_layer

			start_layer = start_layer or num

			local frame_name = self.frame_name
			local var_9_3 = UIFrameSettings[frame_name]
			local var_9_4 = var_9_3.texture_sizes.horizontal[2]
			local num_3 = 0

			if not arg_9_1 then
				local data = arg_9_13.data
				local rarity = arg_9_13.rarity

				rarity = rarity or data.rarity

				local get_table = Colors.get_table(rarity)

				arg_9_9[2] = arg_9_9[2] + var_9_4
				arg_9_10[2] = arg_9_10[2] + var_9_4 + num_3
				arg_9_9[3] = start_layer - 2

				local background_texture = self.background_texture
				local background_texture_size = self.background_texture_size
				local size = UIAtlasHelper.get_atlas_settings_by_texture_name(background_texture).size
				local uvs = self.uvs

				uvs[2][1] = math.min(arg_9_10[1] / size[1], 1)
				uvs[2][2] = math.min(arg_9_10[2] / size[2], 1)

				local background_color = self.background_color

				UIRenderer.draw_tiled_texture(arg_9_3, background_texture, arg_9_9, arg_9_10, background_texture_size, background_color)

				arg_9_10[2] = arg_9_10[2]
				arg_9_9[3] = start_layer + 5

				local frame_color = self.frame_color

				frame_color[1] = num_2

				UIRenderer.draw_texture_frame(arg_9_3, arg_9_9, arg_9_10, var_9_3.texture, var_9_3.texture_size, var_9_3.texture_sizes, frame_color)
			end

			return 0
		end
	},
	craft_item_new_frame = {
		setup_data = function ()
			-- function 10
			local str = "frame_outer_glow_01"
			local var_10_1 = UIFrameSettings[str].texture_sizes.horizontal[2]

			return {
				frame_name = str,
				frame_color = {
					255,
					255,
					255,
					255
				},
				frame_margin = var_10_1 * 2
			}
		end,
		draw = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13)
			-- function 11
			local alpha_multiplier = arg_11_4.alpha_multiplier
			local num_2 = (55 + 200 * (0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5)) * alpha_multiplier

			if not arg_11_4.start_layer then
				local var_11_2 = num
			end

			local frame_name = self.frame_name
			local var_11_4 = UIFrameSettings[frame_name]
			local var_11_5 = var_11_4.texture_sizes.horizontal[2]

			if not arg_11_1 then
				local data = arg_11_13.data
				local rarity = arg_11_13.rarity

				rarity = rarity or data.rarity

				local get_table = Colors.get_table(rarity)

				arg_11_9[1] = arg_11_9[1] - var_11_5
				arg_11_9[2] = arg_11_9[2] - var_11_5
				arg_11_10[1] = arg_11_10[1] + var_11_5 * 2
				arg_11_10[2] = arg_11_10[2] + var_11_5 * 2

				local frame_color = self.frame_color

				frame_color[1] = num_2

				UIRenderer.draw_texture_frame(arg_11_3, arg_11_9, arg_11_10, var_11_4.texture, var_11_4.texture_size, var_11_4.texture_sizes, frame_color)
			end

			return var_11_5 * 2
		end
	},
	craft_item_reward_title = {
		setup_data = function ()
			-- function 12
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
						font_size = fn(36),
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
						font_size = fn(36),
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
		draw = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9, arg_13_10, arg_13_11, arg_13_12, arg_13_13)
			-- function 13
			local num_2 = 255 * arg_13_4.alpha_multiplier
			local start_layer = arg_13_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local data = arg_13_13.data
			local rarity = arg_13_13.rarity

			rarity = rarity or data.rarity

			local get_table = Colors.get_table(rarity)
			local style = self.style
			local content = self.content
			local var_13_8 = arg_13_9[1]
			local var_13_9 = arg_13_9[2]
			local var_13_10 = arg_13_9[3]
			local text = content.text
			local title_text = style.title_text
			local title_text_shadow = style.title_text_shadow
			local text_pass_data = self.text_pass_data
			local text_size = self.text_size

			text_size[1] = arg_13_10[1] - frame_margin * 2
			text_size[2] = 0
			text_size[2], text_size[1] = UIUtils.get_text_height(arg_13_3, text_size, title_text, text), arg_13_10[1]

			local texture_color = self.texture_color
			local texture_size = self.texture_size

			if not arg_13_1 then
				arg_13_9[2] = arg_13_9[2] + arg_13_10[2] - (80 + texture_size[2])
				arg_13_9[3] = start_layer + 3

				local var_13_18 = arg_13_9[1]
				local var_13_19 = arg_13_9[2]

				texture_color[1] = num_2
				arg_13_9[1] = var_13_8 + arg_13_10[1] / 2 - texture_size[1] / 2

				local texture = content.texture

				UIRenderer.draw_texture(arg_13_3, texture, arg_13_9, texture_size, texture_color)

				local num_3 = 30

				arg_13_9[1] = var_13_18 + title_text.offset[1]
				arg_13_9[2] = var_13_19 + num_3 + title_text.offset[2]
				arg_13_9[3] = start_layer + 6 + title_text.offset[3]
				title_text.text_color[1] = num_2
				title_text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_13_3, text_pass_data, arg_13_5, arg_13_6, title_text, content, arg_13_9, text_size, arg_13_11, arg_13_12)

				arg_13_9[1] = var_13_18 + title_text_shadow.offset[1]
				arg_13_9[2] = var_13_19 + num_3 + title_text_shadow.offset[2]
				arg_13_9[3] = start_layer + 6 + title_text_shadow.offset[3]

				UIPasses.text.draw(arg_13_3, text_pass_data, arg_13_5, arg_13_6, title_text_shadow, content, arg_13_9, text_size, arg_13_11, arg_13_12)
			end

			arg_13_9[1] = var_13_8
			arg_13_9[2] = var_13_9
			arg_13_9[3] = var_13_10

			return 0
		end
	},
	weapon_stats = {
		setup_data = function ()
			-- function 14
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					title_1 = {
						text = "item_compare_attack_title_light",
						word_wrap = true,
						vertical_alignment = "bottom",
						horizontal_alignment = "left",
						font_type = "hell_shark",
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					title_2 = {
						text = "item_compare_attack_title_heavy",
						word_wrap = true,
						vertical_alignment = "bottom",
						horizontal_alignment = "right",
						font_type = "hell_shark",
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					}
				}
			}
		end,
		draw = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9, arg_15_10, arg_15_11, arg_15_12, arg_15_13)
			-- function 15
			local num_2 = 255 * arg_15_4.alpha_multiplier
			local start_layer = arg_15_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local data = arg_15_13.data
			local slot_type = data.slot_type

			if not (slot_type == "melee" or slot_type == "ranged") then
				return 0
			end

			local backend_id = arg_15_13.backend_id
			local var_15_6

			if not self.stats_data then
				var_15_6 = ItemHelper.retrieve_weapon_item_statistics(data, backend_id)
				self.stats_data = var_15_6
			else
				var_15_6 = self.stats_data
			end

			local style = self.style
			local content = self.content
			local var_15_9 = arg_15_9[1]
			local var_15_10 = arg_15_9[2]
			local var_15_11 = arg_15_9[3]
			local texture_size = style.attack_stars.texture_size
			local var_15_13 = texture_size[1]
			local var_15_14 = texture_size[2]
			local count = #var_15_6
			local num_3 = var_15_13 * 5
			local num_4 = var_15_14 * count
			local var_15_18 = frame_margin

			if not arg_15_2 then
				arg_15_9[2] = arg_15_9[2] - frame_margin * 2
			else
				arg_15_9[2] = arg_15_9[2] + num_4
			end

			arg_15_9[3] = start_layer + 2

			if not arg_15_1 then
				for i = 1, 2 do
					local str = "title_" .. i
					local var_15_20 = style[str]
					local text_size = self.text_size

					text_size[1] = arg_15_10[1]
					text_size[2] = var_15_14

					local text_pass_data = self.text_pass_data

					text_pass_data.text_id = str

					local var_15_23 = Localize(var_15_20.text)

					content[str] = var_15_23

					local get_text_height = UIUtils.get_text_height(arg_15_3, text_size, var_15_20, var_15_23)

					if i == 2 then
						arg_15_9[1] = var_15_9 - frame_margin + frame_margin / 4
					else
						arg_15_9[1] = var_15_9 + frame_margin
					end

					local get_text_height_2 = UIUtils.get_text_height(arg_15_3, text_size, var_15_20, var_15_23)

					if i == 1 then
						var_15_18 = var_15_18 + get_text_height_2
						arg_15_9[2] = arg_15_9[2] - get_text_height_2
					end

					var_15_20.text_color[1] = num_2

					UIPasses.text.draw(arg_15_3, text_pass_data, arg_15_5, arg_15_6, var_15_20, content, arg_15_9, text_size, arg_15_11, arg_15_12)

					if i == 2 then
						arg_15_9[2] = arg_15_9[2] - get_text_height_2
					end
				end
			end

			arg_15_9[1] = var_15_9

			for i_2, v in ipairs(var_15_6) do
				for i_3, v_2 in ipairs(v) do
					local title = v_2.title

					title = title or "n/a"

					local value = v_2.value

					value = value or 0

					local key = v_2.key

					if i_3 == 1 then
						arg_15_9[1] = var_15_9 + frame_margin / 2

						local str_2 = "stat_title"
						local var_15_30 = style[str_2]
						local text_size_2 = self.text_size

						text_size_2[1] = arg_15_10[1] - frame_margin
						text_size_2[2] = var_15_14

						local text_pass_data_2 = self.text_pass_data

						text_pass_data_2.text_id = str_2
						content[str_2] = title

						local get_text_height_3 = UIUtils.get_text_height(arg_15_3, text_size_2, var_15_30, title)

						if not arg_15_1 then
							var_15_30.text_color[1] = num_2

							UIPasses.text.draw(arg_15_3, text_pass_data_2, arg_15_5, arg_15_6, var_15_30, content, arg_15_9, text_size_2, arg_15_11, arg_15_12)
						end
					end

					if i_3 == 1 then
						arg_15_9[1] = var_15_9 + frame_margin
					else
						arg_15_9[1] = var_15_9 + arg_15_10[1] - num_3 - var_15_13 - frame_margin / 4
					end

					local round = math.round(value * 10)
					local num_5 = 0
					local num_6 = 0

					for i5 = 1, round do
						if i5 % 2 == 1 then
							num_5 = num_5 + 1
						else
							num_6 = num_6 + 1
						end
					end

					local attack_stars = style.attack_stars

					if not arg_15_1 then
						for i6 = 1, 2 do
							local var_15_38
							local num_7 = 0

							if i6 == 1 then
								var_15_38 = "left_star"
								num_7 = num_5
							else
								var_15_38 = "right_star"
								num_7 = num_6
							end

							local texture_size_2 = attack_stars.texture_size
							local axis = attack_stars.axis
							local spacing = attack_stars.spacing
							local direction = attack_stars.direction
							local texture_colors = attack_stars.texture_colors
							local color = attack_stars.color

							color[1] = num_2

							if not texture_colors then
								for i7 = 1, #texture_colors do
									texture_colors[i7][1] = num_2
								end
							end

							UIRenderer.draw_multi_texture(arg_15_3, content[var_15_38], arg_15_9, texture_size_2, nil, nil, nil, axis, spacing, direction, num_7, texture_colors, color, nil, nil, nil)

							if i6 == 1 then
								local slot_color = attack_stars.slot_color

								slot_color[1] = num_2
								arg_15_9[3] = arg_15_9[3] - 1

								UIRenderer.draw_multi_texture(arg_15_3, content.slot_star, arg_15_9, texture_size_2, nil, nil, nil, axis, spacing, direction, 5, nil, slot_color, nil, nil, nil)

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
		setup_data = function ()
			-- function 16
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
						font_size = fn(24),
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
		draw = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10, arg_17_11, arg_17_12, arg_17_13)
			-- function 17
			local num_2 = 255 * arg_17_4.alpha_multiplier
			local start_layer = arg_17_4.start_layer

			start_layer = start_layer or num

			local num_3 = 20
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local backend_id = arg_17_13.backend_id
			local data = arg_17_13.data
			local slot_type = data.slot_type

			if not (slot_type == "melee" or slot_type == "ranged") then
				return 0
			end

			local tooltip_keywords = BackendUtils.get_item_template(data, backend_id).tooltip_keywords
			local style = self.style
			local content = self.content
			local var_17_10 = arg_17_9[1]
			local var_17_11 = arg_17_9[2]
			local var_17_12 = arg_17_9[3]
			local num_4 = 0
			local entry_texture_size = self.entry_texture_size

			arg_17_9[3] = start_layer + 2
			arg_17_9[2] = arg_17_9[2] + 100 + num_3
			arg_17_9[1] = arg_17_9[1] + frame_margin + 100 + entry_texture_size[1]

			local ipairs = ipairs

			self.text_size[1] = arg_17_10[1] - (frame_margin * 2 + 100) - entry_texture_size[1]

			if not tooltip_keywords then
				for iter_17_0, iter_17_1 in ipairs(tooltip_keywords) do
					local str = "keyword_title_" .. iter_17_0
					local text = style.text
					local text_pass_data = self.text_pass_data

					text_pass_data.text_id = str

					local var_17_19 = Localize(iter_17_1)
					local text_size = self.text_size

					text_size[2] = 0

					local get_text_height = UIUtils.get_text_height(arg_17_3, text_size, text, var_17_19)

					text_size[2] = get_text_height
					arg_17_9[2] = arg_17_9[2] - get_text_height

					local var_17_22 = arg_17_9[2]

					content[str] = var_17_19

					if not arg_17_1 then
						local entry_texture_size_2 = self.entry_texture_size
						local entry_texture = self.style.entry_texture
						local entry_texture_pass_data = self.entry_texture_pass_data
						local entry_texture_pass_definition = self.entry_texture_pass_definition

						arg_17_9[1] = arg_17_9[1] - entry_texture_size_2[1]
						arg_17_9[2] = arg_17_9[2] + get_text_height / 2 - entry_texture_size_2[2] / 2
						entry_texture.color[1] = num_2

						UIPasses.texture.draw(arg_17_3, entry_texture_pass_data, arg_17_5, entry_texture_pass_definition, entry_texture, content, arg_17_9, entry_texture_size_2, arg_17_11, arg_17_12)

						arg_17_9[1] = arg_17_9[1] + entry_texture_size_2[1]
						arg_17_9[2] = var_17_22
						text.text_color[1] = num_2

						UIPasses.text.draw(arg_17_3, text_pass_data, arg_17_5, arg_17_6, text, content, arg_17_9, self.text_size, arg_17_11, arg_17_12)
					end

					num_4 = num_4 + get_text_height
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
		setup_data = function ()
			-- function 18
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					property_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
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
						font_size = fn(16),
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
		draw = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13)
			-- function 19
			if not Development.parameter("enable_detailed_tooltips") and arg_19_11:get("item_compare") and not arg_19_11:get("item_detail") then
				local slot_type = arg_19_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			end

			local num_2 = 255 * arg_19_4.alpha_multiplier
			local start_layer = arg_19_4.start_layer

			start_layer = start_layer or num

			local num_3 = 20
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local properties = arg_19_13.properties
			local style = self.style
			local content = self.content
			local var_19_8 = arg_19_9[1]
			local var_19_9 = arg_19_9[2]
			local var_19_10 = arg_19_9[3]
			local num_4 = 0

			arg_19_9[3] = start_layer + 2
			arg_19_9[2] = arg_19_9[2]

			local pairs = pairs

			if not arg_19_11:get("item_compare") then
				local get = arg_19_11:get("item_detail")
			end

			if not properties then
				arg_19_9[1] = arg_19_9[1] + frame_margin

				local property_title = style.property_title
				local title_text_pass_data = self.title_text_pass_data
				local title = content.title
				local text_size = self.text_size

				text_size[1] = arg_19_10[1] - (frame_margin * 2 + frame_margin)
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_19_3, text_size, property_title, title)

				text_size[2] = get_text_height
				arg_19_9[2] = arg_19_9[2] - get_text_height
				num_4 = num_4 + get_text_height

				if not arg_19_1 then
					property_title.text_color[1] = num_2

					UIPasses.text.draw(arg_19_3, title_text_pass_data, arg_19_5, arg_19_6, property_title, content, arg_19_9, text_size, arg_19_11, arg_19_12)
				end

				local num_5 = 1

				for iter_19_0, iter_19_1 in pairs(properties) do
					local var_19_20 = WeaponProperties.properties[iter_19_0]

					if not var_19_20 then
						local buff_name = var_19_20.buff_name
						local flag

						flag = BuffUtils.get_buff_template(buff_name).buffs[1].variable_multiplier ~= nil

						local str_2 = "property_title_" .. num_5
						local property_text = style.property_text
						local text_pass_data = self.text_pass_data

						text_pass_data.text_id = str_2

						local var_19_26

						if not arg_19_13.hidden_description then
							var_19_26 = str
						else
							local get_property_description, var_19_28 = UIUtils.get_property_description(iter_19_0, iter_19_1)
							local length

							if not var_19_28 then
								length = Utf8.length(var_19_28)

								if not length then
									-- Nothing
								end
							end

							length = 0

							do
								local length_2
							end

							::label_19_0::

							if not var_19_26 then
								length_2 = Utf8.length(var_19_26)

								if not length_2 then
									-- Nothing
								end
							end

							length_2 = 0

							::label_19_1::

							var_19_26 = get_property_description .. var_19_28

							local color_override_table = property_text.color_override_table

							color_override_table.start_index = length_2 + 1
							color_override_table.end_index = length_2 + length
							property_text.color_override[1] = color_override_table
						end

						local text_size_2 = self.text_size

						text_size_2[2] = 0

						local get_text_height_2, var_19_34 = UIUtils.get_text_height(arg_19_3, text_size_2, property_text, var_19_26)

						text_size_2[2] = get_text_height_2
						arg_19_9[2] = arg_19_9[2] - get_text_height_2

						local var_19_35 = arg_19_9[2]

						content[str_2] = var_19_26

						if not arg_19_1 then
							local icon_pass_definition = self.icon_pass_definition
							local icon_pass_data = self.icon_pass_data
							local icon = style.icon
							local icon_size = self.icon_size

							icon.color[1] = num_2
							arg_19_9[2] = arg_19_9[2] + get_text_height_2 - get_text_height_2 / var_19_34 * 0.5 - (icon_size[2] * 0.5 + 2)

							UIPasses.texture.draw(arg_19_3, icon_pass_data, arg_19_5, icon_pass_definition, icon, content, arg_19_9, icon_size, arg_19_11, arg_19_12)

							arg_19_9[2] = var_19_35
							arg_19_9[1] = arg_19_9[1] + icon_size[1]
							property_text.text_color[1] = num_2

							UIPasses.text.draw(arg_19_3, text_pass_data, arg_19_5, arg_19_6, property_text, content, arg_19_9, self.text_size, arg_19_11, arg_19_12)

							arg_19_9[1] = arg_19_9[1] - icon_size[1]
						end

						num_4 = num_4 + get_text_height_2
						arg_19_9[2] = var_19_35
					end
				end

				local num_6 = num_5 + 1

				num_4 = num_4 + num_3
			end

			arg_19_9[1] = var_19_8
			arg_19_9[2] = var_19_9
			arg_19_9[3] = var_19_10

			return num_4
		end
	},
	traits = {
		setup_data = function ()
			-- function 20
			local str = "item_tooltip_frame_01"
			local var_20_1 = UIFrameSettings[str]

			return {
				default_icon = "icons_placeholder",
				frame_name = str,
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
						font_size = fn(16),
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
						font_size = fn(16),
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
		draw = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8, arg_21_9, arg_21_10, arg_21_11, arg_21_12, arg_21_13)
			-- function 21
			if not Development.parameter("enable_detailed_tooltips") and arg_21_11:get("item_compare") and not arg_21_11:get("item_detail") then
				local slot_type = arg_21_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			end

			local num_2 = 255 * arg_21_4.alpha_multiplier
			local start_layer = arg_21_4.start_layer

			start_layer = start_layer or num

			local num_3 = 20
			local num_4 = 20
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local traits = arg_21_13.traits
			local num_5 = 0

			if not traits then
				local style = self.style
				local content = self.content
				local var_21_10 = arg_21_9[1]
				local var_21_11 = arg_21_9[2]
				local var_21_12 = arg_21_9[3]

				arg_21_9[1] = arg_21_9[1] + frame_margin
				arg_21_9[2] = arg_21_9[2]
				arg_21_9[3] = start_layer + 2

				local num_6 = 10
				local ipairs

				if not arg_21_2 then
					ipairs = ipairs

					if not ipairs then
						-- Nothing
					end
				end

				ipairs = ripairs

				::label_21_0::

				for iter_21_0, iter_21_1 in ipairs(traits) do
					local var_21_15 = WeaponTraits.traits[iter_21_1]

					if not var_21_15 then
						local str_2 = "trait_title_" .. iter_21_0
						local trait_title = style.trait_title
						local text_pass_data = self.text_pass_data

						text_pass_data.text_id = str_2

						local display_name = var_21_15.display_name
						local advanced_description = var_21_15.advanced_description
						local icon = var_21_15.icon
						local var_21_22 = Localize(display_name)
						local str_3 = ""
						local icon_pass_definition = self.icon_pass_definition
						local icon_pass_data = self.icon_pass_data
						local icon_2 = self.style.icon
						local icon_size = self.icon_size

						content.icon = icon or self.default_icon

						if not advanced_description then
							str_3 = UIUtils.get_trait_description(iter_21_1)
						end

						local var_21_28

						if not arg_21_13.hidden_description then
							var_21_28 = string.format("%s\n%s\n%s", str, str, str)
							content.icon = self.default_icon
						else
							var_21_28 = var_21_22 .. "\n" .. str_3
						end

						local text_size = self.text_size

						text_size[1] = arg_21_10[1] - frame_margin * 3 - icon_size[1]
						text_size[2] = 0

						local get_text_height = UIUtils.get_text_height(arg_21_3, text_size, trait_title, var_21_28)

						text_size[2] = get_text_height

						local var_21_31 = arg_21_9[1]
						local var_21_32 = arg_21_9[2]

						content[str_2] = var_21_28

						if not arg_21_1 then
							icon_2.color[1] = num_2
							arg_21_9[2] = var_21_32 - icon_size[2]
							arg_21_9[1] = var_21_31

							UIPasses.texture.draw(arg_21_3, icon_pass_data, arg_21_5, icon_pass_definition, icon_2, content, arg_21_9, icon_size, arg_21_11, arg_21_12)

							arg_21_9[2] = var_21_32 - get_text_height
							arg_21_9[1] = var_21_31 + icon_size[1] + frame_margin

							local text_color = trait_title.text_color
							local line_colors = trait_title.line_colors

							text_color[1] = num_2
							line_colors[1][1] = num_2
							line_colors[2][1] = num_2

							UIPasses.text.draw(arg_21_3, text_pass_data, arg_21_5, arg_21_6, trait_title, content, arg_21_9, text_size, arg_21_11, arg_21_12)
						end

						num_5 = num_5 + get_text_height

						if iter_21_0 ~= #traits then
							num_5 = num_5 + num_6
							arg_21_9[2] = var_21_32 - (get_text_height + num_6)
							arg_21_9[1] = var_21_31
						end
					end
				end

				arg_21_9[1] = var_21_10
				arg_21_9[2] = var_21_11
				arg_21_9[3] = var_21_12
				num_5 = num_5 + num_3
			end

			return num_5
		end
	},
	advanced_input_helper = {
		setup_data = function ()
			-- function 22
			local str = "item_tooltip_frame_01"
			local var_22_1 = UIFrameSettings[str]
			local is_device_active = Managers.input:is_device_active("gamepad")
			local str_2 = "       "
			local gsub = string.gsub(Localize("item_advanced_information_tooltip_input"), "%[%a*%]", str_2)

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
				macro_replacement = str_2,
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
					text_gamepad = gsub,
					frame = var_22_1.texture,
					texture_id = var_22_1.texture,
					input_button_visible = is_device_active
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
						font_size = fn(16),
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
		draw = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9, arg_23_10, arg_23_11, arg_23_12, arg_23_13)
			-- function 23
			if not (arg_23_11:get("item_compare") or arg_23_11:get("item_detail")) then
				local slot_type = arg_23_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			else
				return 0
			end

			local num_2 = 255 * arg_23_4.alpha_multiplier
			local start_layer = arg_23_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local properties = arg_23_13.properties
			local style = self.style
			local content = self.content
			local var_23_7 = arg_23_9[1]
			local var_23_8 = arg_23_9[2]
			local var_23_9 = arg_23_9[3]
			local num_3 = 0

			arg_23_9[3] = start_layer - 6

			if not properties and not next(properties) then
				local text = style.text
				local text_pass_data = self.text_pass_data
				local is_device_active = Managers.input:is_device_active("gamepad")

				if not is_device_active then
					content.text = content.text_gamepad
				else
					content.text = content.default_text
				end

				local text_2 = content.text
				local text_size = self.text_size

				text_size[1] = arg_23_10[1] - frame_margin * 2
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_23_3, text_size, text, text_2)
				local num_4 = num_3 + get_text_height

				text_size[2] = get_text_height

				local frame_size = self.frame_size
				local frame_pass_data = self.frame_pass_data
				local frame_pass_definition = self.frame_pass_definition
				local content_2 = self.content
				local frame = self.style.frame

				frame_size[1] = text_size[1]
				frame_size[2] = text_size[2] + frame_margin / 2

				local num_5 = num_4 + frame_size[2]

				arg_23_9[2] = arg_23_9[2] - frame_size[2] - frame_margin / 2
				arg_23_9[1] = arg_23_9[1] + frame_margin

				local var_23_24 = arg_23_9[2]

				if not arg_23_1 then
					frame.color[1] = num_2

					UIPasses.texture_frame.draw(arg_23_3, frame_pass_data, arg_23_5, frame_pass_definition, frame, content_2, arg_23_9, frame_size, arg_23_11, arg_23_12)

					local color = self.style.background.color

					color[1] = num_2
					arg_23_9[3] = arg_23_9[3] - 1

					UIRenderer.draw_rect(arg_23_3, arg_23_9, frame_size, color)

					arg_23_9[3] = arg_23_9[3] + 1
				end

				arg_23_9[2] = var_23_24 + frame_margin / 4
				text_size[1] = frame_size[1]

				if not arg_23_1 then
					text.text_color[1] = num_2

					UIPasses.text.draw(arg_23_3, text_pass_data, arg_23_5, arg_23_6, text, content, arg_23_9, text_size, arg_23_11, arg_23_12)
				end

				if not arg_23_1 then
					local input_button = style.input_button
					local texture_pass_data = self.texture_pass_data
					local texture_pass_definition = self.texture_pass_definition
					local texture_size = self.texture_size
					local macro_replacement = self.macro_replacement

					if not is_device_active then
						local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(arg_23_11, "debug_pixeldistance_1", true)

						input_button.texture_size[1] = get_gamepad_input_texture_data.size[1] * 0.8
						input_button.texture_size[2] = get_gamepad_input_texture_data.size[2] * 0.8
						content.texture_id = get_gamepad_input_texture_data.texture

						local var_23_32 = arg_23_9
						local text_3 = content.text
						local find, var_23_35 = string.find(text_3, macro_replacement)
						local sub = string.sub(text_3, 1, (find or 1) + 1)
						local var_23_37, var_23_38 = UIFontByResolution(text)
						local text_size_2 = UIRenderer.text_size(arg_23_3, text_3, var_23_37[1], var_23_38)
						local text_size_3 = UIRenderer.text_size(arg_23_3, sub, var_23_37[1], var_23_38)

						var_23_32[1] = var_23_32[1] - text_size_2 * 0.5 + text_size_3 + get_gamepad_input_texture_data.size[1] * 0.5
						var_23_32[2] = var_23_32[2] - frame_margin * 0.5

						UIPasses.texture.draw(arg_23_3, texture_pass_data, arg_23_5, texture_pass_definition, input_button, content, var_23_32, text_size, arg_23_11, arg_23_12)
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
		setup_data = function ()
			-- function 24
			local str = "item_tooltip_frame_01"
			local var_24_1 = UIFrameSettings[str]

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
						font_size = fn(20),
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
		draw = function (self, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8, arg_25_9, arg_25_10, arg_25_11, arg_25_12, arg_25_13)
			-- function 25
			local backend_id = arg_25_13.backend_id

			if not arg_25_13 then
				-- Nothing
			end

			::label_25_0::

			local data = arg_25_13.data

			data = not data and arg_25_13.data.slot_type

			::label_25_1::

			if not arg_25_4.force_equipped then
				if not data then
					local var_25_2 = InventorySettings.slot_names_by_type[data]

					if not var_25_2 then
						local var_25_3 = var_25_2[1]

						if not arg_25_4.player then
							local equipped_items = arg_25_4.equipped_items

							if not equipped_items then
								return 0
							end

							local flag = false

							for i, v in ipairs(equipped_items) do
								if v.backend_id == backend_id then
									flag = true

									break
								end
							end

							if not flag then
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

			local num_2 = 255 * arg_25_4.alpha_multiplier
			local start_layer = arg_25_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local var_25_11 = arg_25_9[1]
			local var_25_12 = arg_25_9[2]
			local var_25_13 = arg_25_9[3]
			local num_3 = 0

			arg_25_9[3] = start_layer - 6

			local text = style.text
			local text_pass_data = self.text_pass_data
			local text_2 = content.text
			local text_size = self.text_size

			text_size[1] = arg_25_10[1] - frame_margin * 2
			text_size[2] = 0
			text_size[2] = UIUtils.get_text_height(arg_25_3, text_size, text, text_2)

			local frame_size = self.frame_size
			local frame_pass_data = self.frame_pass_data
			local frame_pass_definition = self.frame_pass_definition
			local content_2 = self.content
			local frame = self.style.frame

			frame_size[1] = text_size[1]
			frame_size[2] = text_size[2] + frame_margin / 2

			local var_25_24 = frame_size[2]

			arg_25_9[2] = arg_25_9[2] + frame_margin / 2
			arg_25_9[1] = arg_25_9[1] + frame_margin

			local var_25_25 = arg_25_9[2]

			if not arg_25_1 then
				frame.color[1] = num_2

				UIPasses.texture_frame.draw(arg_25_3, frame_pass_data, arg_25_5, frame_pass_definition, frame, content_2, arg_25_9, frame_size, arg_25_11, arg_25_12)

				local color = self.style.background.color

				color[1] = num_2
				arg_25_9[3] = arg_25_9[3] - 1

				UIRenderer.draw_rect(arg_25_3, arg_25_9, frame_size, color)

				arg_25_9[3] = arg_25_9[3] + 1
			end

			arg_25_9[2] = var_25_25 + frame_margin / 3
			text_size[1] = frame_size[1]

			if not arg_25_1 then
				text.text_color[1] = num_2

				UIPasses.text.draw(arg_25_3, text_pass_data, arg_25_5, arg_25_6, text, content, arg_25_9, text_size, arg_25_11, arg_25_12)
			end

			arg_25_9[1] = var_25_11
			arg_25_9[2] = var_25_12
			arg_25_9[3] = var_25_13

			return 0
		end
	},
	fatigue = {
		setup_data = function ()
			-- function 26
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					text = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = fn(28),
						text_color = Colors.get_color_table_with_alpha("white", 255)
					}
				}
			}
		end,
		draw = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7, arg_27_8, arg_27_9, arg_27_10, arg_27_11, arg_27_12, arg_27_13)
			-- function 27
			if not Development.parameter("enable_detailed_tooltips") and arg_27_11:get("item_compare") and not arg_27_11:get("item_detail") then
				local slot_type = arg_27_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			end

			if not arg_27_13.hidden_description then
				return 0
			end

			local alpha_multiplier = arg_27_4.alpha_multiplier
			local num_2 = 255 * alpha_multiplier
			local start_layer = arg_27_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local data = arg_27_13.data

			if not (data.slot_type ~= ItemType.MELEE or arg_27_1) then
				return 0
			end

			local content = self.content
			local style = self.style
			local var_27_8 = arg_27_9[1]
			local var_27_9 = arg_27_9[2]
			local var_27_10 = arg_27_9[3]
			local backend_id = arg_27_13.backend_id
			local get_item_template = BackendUtils.get_item_template(data, backend_id)
			local max_fatigue_points = get_item_template.max_fatigue_points

			content.text = tostring(max_fatigue_points / 2)
			arg_27_9[3] = start_layer + 2
			arg_27_9[1] = var_27_8 + frame_margin

			local title = style.title
			local title_text_pass_data = self.title_text_pass_data
			local title_2 = content.title
			local title_text_size = self.title_text_size

			title_text_size[1] = arg_27_10[1] - frame_margin * 2
			title_text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_27_3, title_text_size, title, title_2)

			title_text_size[2] = get_text_height
			arg_27_9[2] = arg_27_9[2] - get_text_height
			title.text_color[1] = num_2

			UIPasses.text.draw(arg_27_3, title_text_pass_data, arg_27_5, arg_27_6, title, content, arg_27_9, title_text_size, arg_27_11, arg_27_12)

			local text = style.text
			local text_pass_data = self.text_pass_data
			local text_2 = content.text
			local text_size = self.text_size

			text_size[1] = arg_27_10[1] - frame_margin * 2
			text_size[2] = 0

			local get_text_height_2 = UIUtils.get_text_height(arg_27_3, text_size, text, text_2)
			local var_27_24, var_27_25 = UIFontByResolution(text)
			local var_27_26 = var_27_24[1]
			local var_27_27 = var_27_24[2]
			local var_27_28 = var_27_24[3]
			local text_size_2, var_27_30, var_27_31 = UIRenderer.text_size(arg_27_3, content.text, var_27_26, var_27_25, var_27_28)

			text_size[2] = get_text_height_2
			arg_27_9[2] = arg_27_9[2] - get_text_height_2

			if not arg_27_1 then
				text.text_color[1] = num_2

				UIPasses.text.draw(arg_27_3, text_pass_data, arg_27_5, arg_27_6, text, content, arg_27_9, text_size, arg_27_11, arg_27_12)
			end

			arg_27_9[2] = var_27_9 - get_text_height

			local num_3 = get_item_template.block_angle / 360
			local num_4 = 10
			local num_5 = 1 / num_4
			local num_6 = math.ceil(num_3 / num_5) * num_5 * 0.5
			local block_arc_pass_definition = self.block_arc_pass_definition
			local block_arc_pass_data = self.block_arc_pass_data
			local block_arc_size = self.block_arc_size
			local block_arc = style.block_arc
			local color = style.block_arc.color
			local background_color = block_arc.background_color

			color[1] = 255 * num_6 * alpha_multiplier
			arg_27_9[1] = math.ceil(var_27_8 + (arg_27_10[1] - block_arc_size[1]) - frame_margin * 2 - text_size_2)
			arg_27_9[2] = math.ceil(arg_27_9[2] - block_arc_size[2])

			if not arg_27_1 then
				background_color[1] = num_2

				UIRenderer.draw_rounded_rect(arg_27_3, arg_27_9, block_arc_size, block_arc_size[1] * 0.5, background_color)
			end

			arg_27_9[3] = arg_27_9[3] + 1

			UIPasses.texture.draw(arg_27_3, block_arc_pass_data, arg_27_5, block_arc_pass_definition, block_arc, content.block_arc, arg_27_9, block_arc_size, arg_27_11, arg_27_12)
			UIPasses.texture_uv.draw(arg_27_3, block_arc_pass_data, arg_27_5, block_arc_pass_definition, block_arc, content.block_arc, arg_27_9, block_arc_size, arg_27_11, arg_27_12)

			arg_27_9[3] = arg_27_9[3] + 1

			local icon = style.icon
			local icon_size = self.icon_size
			local icon_pass_data = self.icon_pass_data
			local icon_pass_definition = self.icon_pass_definition

			icon.color[1] = num_2
			arg_27_9[1] = arg_27_9[1] + block_arc_size[1] / 2 - icon_size[1] / 2
			arg_27_9[2] = arg_27_9[2] + block_arc_size[2] / 2 - icon_size[2] / 2

			if not arg_27_1 then
				UIPasses.texture.draw(arg_27_3, icon_pass_data, arg_27_5, icon_pass_definition, icon, content, arg_27_9, icon_size, arg_27_11, arg_27_12)
			end

			arg_27_9[1] = var_27_8
			arg_27_9[2] = var_27_9
			arg_27_9[3] = var_27_10

			return 0
		end
	},
	ammunition = {
		setup_data = function ()
			-- function 28
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
						font_size = fn(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					text = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark_header",
						font_size = fn(28),
						text_color = Colors.get_color_table_with_alpha("white", 255)
					}
				}
			}
		end,
		draw = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8, arg_29_9, arg_29_10, arg_29_11, arg_29_12, arg_29_13)
			-- function 29
			if not Development.parameter("enable_detailed_tooltips") and arg_29_11:get("item_compare") and not arg_29_11:get("item_detail") then
				local slot_type = arg_29_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			end

			if not arg_29_13.hidden_description then
				return 0
			end

			local num_2 = 255 * arg_29_4.alpha_multiplier
			local start_layer = arg_29_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local data = arg_29_13.data

			if not (data.slot_type ~= ItemType.RANGED or arg_29_1) then
				return 0
			end

			local content = self.content
			local style = self.style
			local var_29_7 = arg_29_9[1]
			local var_29_8 = arg_29_9[2]
			local var_29_9 = arg_29_9[3]
			local backend_id = arg_29_13.backend_id
			local ammo_data = BackendUtils.get_item_template(data, backend_id).ammo_data

			if not (not ammo_data and ammo_data.hide_ammo_ui) then
				local single_clip = ammo_data.single_clip
				local reload_time = ammo_data.reload_time
				local max_ammo = ammo_data.max_ammo
				local ammo_per_clip = ammo_data.ammo_per_clip
				local var_29_16

				if not single_clip then
					var_29_16 = tostring(max_ammo) .. "/0"
				else
					var_29_16 = tostring(ammo_per_clip) .. "/" .. tostring(max_ammo - ammo_per_clip)
				end

				content.text = var_29_16
			else
				content.text = ""
			end

			local content_2 = self.content
			local style_2 = self.style

			arg_29_9[3] = start_layer + 2
			arg_29_9[1] = var_29_7 + frame_margin

			local title = style_2.title
			local title_text_pass_data = self.title_text_pass_data
			local title_2 = content_2.title
			local title_text_size = self.title_text_size

			title_text_size[1] = arg_29_10[1] - frame_margin * 2
			title_text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_29_3, title_text_size, title, title_2)

			title_text_size[2] = get_text_height
			arg_29_9[2] = arg_29_9[2] - get_text_height
			title.text_color[1] = num_2

			UIPasses.text.draw(arg_29_3, title_text_pass_data, arg_29_5, arg_29_6, title, content_2, arg_29_9, title_text_size, arg_29_11, arg_29_12)

			if not (not ammo_data and ammo_data.hide_ammo_ui) then
				local text = style_2.text
				local text_pass_data = self.text_pass_data
				local text_2 = content_2.text
				local text_size = self.text_size

				text_size[1] = arg_29_10[1] - frame_margin * 2
				text_size[2] = 0

				local get_text_height_2 = UIUtils.get_text_height(arg_29_3, text_size, text, text_2)

				text_size[2] = get_text_height_2
				arg_29_9[2] = arg_29_9[2] - get_text_height_2

				if not arg_29_1 then
					text.text_color[1] = num_2

					UIPasses.text.draw(arg_29_3, text_pass_data, arg_29_5, arg_29_6, text, content_2, arg_29_9, text_size, arg_29_11, arg_29_12)
				end

				arg_29_9[2] = var_29_8 - get_text_height
			else
				local icon = style_2.icon
				local icon_size = self.icon_size
				local icon_pass_data = self.icon_pass_data
				local icon_pass_definition = self.icon_pass_definition

				arg_29_9[1] = var_29_7 + (arg_29_10[1] - icon_size[1]) - frame_margin
				arg_29_9[2] = arg_29_9[2] - icon_size[2]
				icon.color[1] = num_2

				UIPasses.texture.draw(arg_29_3, icon_pass_data, arg_29_5, icon_pass_definition, icon, content_2, arg_29_9, icon_size, arg_29_11, arg_29_12)
			end

			arg_29_9[1] = var_29_7
			arg_29_9[2] = var_29_8
			arg_29_9[3] = var_29_9

			return 0
		end
	},
	item_power_level = {
		setup_data = function ()
			-- function 30
			local tbl = {
				{
					vertical_alignment = "center",
					name = "title",
					localize = false,
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					font_size = fn(18),
					text_color = Colors.get_color_table_with_alpha("font_default", 255)
				},
				{
					vertical_alignment = "center",
					name = "power",
					localize = false,
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark_header",
					font_size = fn(52),
					text_color = Colors.get_color_table_with_alpha("white", 255)
				}
			}

			return {
				text_styles = tbl,
				text_content = {},
				text_pass_data = {},
				text_pass_size = {}
			}
		end,
		draw = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8, arg_31_9, arg_31_10, arg_31_11, arg_31_12, arg_31_13)
			-- function 31
			if not Development.parameter("enable_detailed_tooltips") and arg_31_11:get("item_compare") and not arg_31_11:get("item_detail") then
				local slot_type = arg_31_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			end

			local num_2 = 255 * arg_31_4.alpha_multiplier
			local start_layer = arg_31_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local text_styles = self.text_styles
			local text_content = self.text_content

			table.clear(text_content)

			local power_level = arg_31_13.power_level

			if not power_level then
				return 0
			end

			text_content.title = Localize("tooltips_power")
			text_content.power = tostring(power_level)

			local ipairs = ipairs
			local var_31_8 = arg_31_9[1]
			local var_31_9 = arg_31_9[2]
			local var_31_10 = arg_31_9[3]

			arg_31_9[1] = arg_31_9[1] + frame_margin
			arg_31_9[3] = start_layer + 2

			local text_pass_data = self.text_pass_data
			local text_pass_size = self.text_pass_size

			text_pass_size[1] = arg_31_10[1] - frame_margin * 2
			text_pass_size[2] = 0

			local num_3 = 0

			for iter_31_0, iter_31_1 in ipairs(text_styles) do
				local name = iter_31_1.name
				local var_31_15 = text_content[name]

				if var_31_15 == true then
					var_31_15 = iter_31_1.text
					text_content[name] = var_31_15
				end

				if not var_31_15 then
					text_pass_data.text_id = name
					text_pass_size[2] = 0

					local get_text_height = UIUtils.get_text_height(arg_31_3, text_pass_size, iter_31_1, var_31_15)

					arg_31_9[2] = arg_31_9[2] - get_text_height
					num_3 = num_3 + get_text_height

					if not arg_31_1 then
						local var_31_17
						local var_31_18
						local var_31_19
						local var_31_20 = Vector2(20, 20)

						if not (not arg_31_4.items and not (#arg_31_4.items > 1) or name ~= "power") then
							local num_4 = 0

							for i, v in ipairs(arg_31_4.items) do
								if v.backend_id ~= arg_31_13.backend_id then
									local power_level_2 = v.power_level

									power_level_2 = power_level_2 or -1

									if num_4 < power_level_2 then
										num_4 = v.power_level
									end
								end
							end

							if num_4 < power_level then
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
							elseif power_level < num_4 then
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

						text_pass_size[2] = get_text_height
						iter_31_1.text_color[1] = num_2

						UIPasses.text.draw(arg_31_3, text_pass_data, arg_31_5, arg_31_6, iter_31_1, text_content, arg_31_9, text_pass_size, arg_31_11, arg_31_12)

						if not (not arg_31_1 and not var_31_17 and name ~= "power") then
							local get_text_width = UIUtils.get_text_width(arg_31_3, iter_31_1, text_content.power)
							local var_31_24 = Vector3(arg_31_9[1] + get_text_width + 5, arg_31_9[2] + 15, arg_31_9[3])

							UIRenderer.draw_texture_uv(arg_31_3, var_31_17, var_31_24, var_31_20, var_31_19, var_31_18)
						end
					end
				end
			end

			arg_31_9[1] = var_31_8
			arg_31_9[2] = var_31_9
			arg_31_9[3] = var_31_10

			return num_3
		end
	},
	item_titles = {
		setup_data = function ()
			-- function 32
			local str = "item_tooltip_frame_01"
			local var_32_1 = UIFrameSettings[str]

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
						font_size = fn(28),
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
						font_size = fn(28),
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
						font_size = fn(18),
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
						font_size = fn(18),
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
		draw = function (self, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6, arg_33_7, arg_33_8, arg_33_9, arg_33_10, arg_33_11, arg_33_12, arg_33_13)
			-- function 33
			local num_2 = 255 * arg_33_4.alpha_multiplier
			local start_layer = arg_33_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local data = arg_33_13.data
			local rarity = arg_33_13.rarity

			rarity = rarity or data.rarity

			local get_table = Colors.get_table(rarity)
			local style = self.style
			local content = self.content
			local var_33_8 = arg_33_9[1]
			local var_33_9 = arg_33_9[2]
			local var_33_10 = arg_33_9[3]
			local num_3 = 0
			local item_type = data.item_type
			local get_ui_information_from_item, var_33_14, var_33_15 = UIUtils.get_ui_information_from_item(arg_33_13)
			local var_33_16

			if not arg_33_13.hidden_description then
				var_33_16 = str

				if not var_33_16 then
					-- Nothing
				end
			end

			var_33_16 = Localize(var_33_14)

			do
				local var_33_17
			end

			::label_33_0::

			if not arg_33_13.hidden_description then
				var_33_17 = str

				if not var_33_17 then
					-- Nothing
				end
			end

			var_33_17 = Localize(item_type)

			::label_33_1::

			local text = style.text
			local text_shadow = style.text_shadow
			local player = arg_33_4.player

			if not player then
				local career_name = player:career_name()
				local profile_index = arg_33_8.profile_index
				local career_index = arg_33_8.career_index

				if not profile_index and not career_index then
					career_name = SPProfiles[profile_index].careers[career_index].name
				end

				local flag = not data and data.can_wield
				local contains

				if not flag then
					contains = table.contains(flag, career_name)

					if not contains then
						-- Nothing
					end
				end

				contains = arg_33_6.disable_unsupported

				::label_33_2::

				if not contains then
					text.text_color = text.disabled_text_color
				else
					text.text_color = text.default_text_color
				end
			else
				text.text_color = text.default_text_color
			end

			local title_text = style.title_text
			local title_text_shadow = style.title_text_shadow
			local text_pass_data = self.text_pass_data

			title_text.text_color = get_table

			local text_size = self.text_size

			text_size[1] = arg_33_10[1] - frame_margin * 2
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_33_3, text_size, title_text, var_33_16)
			local get_text_height_2 = UIUtils.get_text_height(arg_33_3, text_size, text, var_33_17)
			local num_4 = get_text_height + get_text_height_2

			text_size[2] = num_4

			local background_size = self.background_size
			local edge = self.style.edge

			background_size[1] = arg_33_10[1]
			background_size[2] = num_4 + frame_margin

			local num_5 = num_3 + background_size[2]

			if not arg_33_1 then
				arg_33_9[2] = arg_33_9[2] - background_size[2] + frame_margin / 2
				arg_33_9[1] = arg_33_9[1] + arg_33_10[1] / 2 - background_size[1] / 2

				local var_33_36 = arg_33_9[1]
				local edge_size = self.edge_size

				edge_size[1] = arg_33_10[1]

				local color = edge.color
				local texture_size = edge.texture_size

				texture_size[1] = arg_33_10[1]

				local edge_texture = content.edge_texture

				arg_33_9[3] = start_layer + 4
				color[1] = num_2

				UIRenderer.draw_tiled_texture(arg_33_3, edge_texture, arg_33_9, edge_size, texture_size, color)

				local edge_holder = style.edge_holder
				local edge_holder_size = self.edge_holder_size
				local color_2 = edge_holder.color
				local edge_holder_left = content.edge_holder_left
				local edge_holder_right = content.edge_holder_right

				color_2[1] = num_2
				arg_33_9[1] = arg_33_9[1] + 3
				arg_33_9[2] = arg_33_9[2] - 6
				arg_33_9[3] = start_layer + 6

				UIRenderer.draw_texture(arg_33_3, edge_holder_left, arg_33_9, edge_holder_size, color_2)

				arg_33_9[1] = arg_33_9[1] + edge_size[1] - (edge_holder_size[1] + 6)

				UIRenderer.draw_texture(arg_33_3, edge_holder_right, arg_33_9, edge_holder_size, color_2)

				arg_33_9[2] = arg_33_9[2] + 6

				local color_3 = style.background.color

				color_3[1] = num_2
				arg_33_9[1] = var_33_8
				arg_33_9[3] = start_layer + 2

				UIRenderer.draw_rect(arg_33_3, arg_33_9, background_size, color_3)

				arg_33_9[3] = start_layer + 3

				local header_glow_texture = content.header_glow_texture

				get_table[1] = num_2

				UIRenderer.draw_texture(arg_33_3, header_glow_texture, arg_33_9, background_size, get_table)

				text_size[2] = get_text_height
				arg_33_9[1] = var_33_36 + frame_margin + title_text.offset[1]
				arg_33_9[2] = var_33_9 + frame_margin * 0.5 - get_text_height + title_text.offset[2]
				arg_33_9[3] = start_layer + 6 + title_text.offset[3]
				content.text = var_33_16
				title_text.text_color[1] = num_2
				title_text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_33_3, text_pass_data, arg_33_5, arg_33_6, title_text, content, arg_33_9, text_size, arg_33_11, arg_33_12)

				arg_33_9[1] = var_33_36 + frame_margin + title_text_shadow.offset[1]
				arg_33_9[2] = var_33_9 + frame_margin * 0.5 - get_text_height + title_text_shadow.offset[2]
				arg_33_9[3] = start_layer + 6 + title_text_shadow.offset[3]

				UIPasses.text.draw(arg_33_3, text_pass_data, arg_33_5, arg_33_6, title_text_shadow, content, arg_33_9, text_size, arg_33_11, arg_33_12)

				text_size[2] = get_text_height_2
				arg_33_9[1] = var_33_36 + frame_margin + text.offset[1]
				arg_33_9[2] = var_33_9 + frame_margin * 0.5 - (get_text_height + get_text_height_2) + text.offset[2]
				arg_33_9[3] = start_layer + 6 + text.offset[3]
				content.text = var_33_17
				text.text_color[1] = num_2
				text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_33_3, text_pass_data, arg_33_5, arg_33_6, text, content, arg_33_9, text_size, arg_33_11, arg_33_12)

				arg_33_9[1] = var_33_36 + frame_margin + text_shadow.offset[1]
				arg_33_9[2] = var_33_9 + frame_margin * 0.5 - (get_text_height + get_text_height_2) + text_shadow.offset[2]
				arg_33_9[3] = start_layer + 6 + text_shadow.offset[3]

				UIPasses.text.draw(arg_33_3, text_pass_data, arg_33_5, arg_33_6, text_shadow, content, arg_33_9, text_size, arg_33_11, arg_33_12)
			end

			arg_33_9[1] = var_33_8
			arg_33_9[2] = var_33_9
			arg_33_9[3] = var_33_10

			return num_5
		end
	},
	console_item_titles = {
		setup_data = function ()
			-- function 34
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
						font_size = fn(28),
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
						font_size = fn(28),
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
						font_size = fn(18),
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
						font_size = fn(18),
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
		draw = function (self, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7, arg_35_8, arg_35_9, arg_35_10, arg_35_11, arg_35_12, arg_35_13)
			-- function 35
			local num_2 = 255 * arg_35_4.alpha_multiplier
			local start_layer = arg_35_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local data = arg_35_13.data
			local rarity = arg_35_13.rarity

			rarity = rarity or data.rarity

			local get_table = Colors.get_table(rarity)
			local style = self.style
			local content = self.content
			local var_35_8 = arg_35_9[1]
			local var_35_9 = arg_35_9[2]
			local var_35_10 = arg_35_9[3]
			local num_3 = 0
			local item_type = data.item_type
			local str = ""
			local str_2 = ""
			local str_3 = ""
			local get_ui_information_from_item, var_35_17, var_35_18 = UIUtils.get_ui_information_from_item(arg_35_13)
			local var_35_19 = Localize(var_35_17)
			local var_35_20 = Localize(item_type)
			local str_4 = var_35_19 .. "\n" .. var_35_20
			local text = style.text
			local text_shadow = style.text_shadow
			local player = arg_35_4.player

			if not player then
				local career_name = player:career_name()
				local profile_index = arg_35_8.profile_index
				local career_index = arg_35_8.career_index

				if not profile_index and not career_index then
					career_name = SPProfiles[profile_index].careers[career_index].name
				end

				local flag = not data and data.can_wield
				local contains

				if not flag then
					contains = table.contains(flag, career_name)

					if not contains then
						-- Nothing
					end
				end

				contains = arg_35_6.disable_unsupported

				::label_35_0::

				if not contains then
					text.text_color = text.disabled_text_color
				else
					text.text_color = text.default_text_color
				end
			else
				text.text_color = text.default_text_color
			end

			local title_text = style.title_text
			local title_text_shadow = style.title_text_shadow
			local text_pass_data = self.text_pass_data

			title_text.text_color = get_table

			local text_size = self.text_size

			text_size[1] = arg_35_10[1] - frame_margin * 2
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_35_3, text_size, title_text, var_35_19)
			local get_text_height_2 = UIUtils.get_text_height(arg_35_3, text_size, text, var_35_20)
			local num_4 = get_text_height + get_text_height_2

			text_size[2] = num_4

			local background_size = self.background_size

			background_size[1] = arg_35_10[1]
			background_size[2] = num_4 + frame_margin

			local num_5 = num_3 + background_size[2]

			if not arg_35_1 then
				arg_35_9[2] = arg_35_9[2] - background_size[2] + frame_margin / 2
				arg_35_9[1] = arg_35_9[1] + arg_35_10[1] / 2 - background_size[1] / 2

				local var_35_39 = arg_35_9[1]
				local var_35_40 = arg_35_9[2]

				arg_35_9[1] = var_35_8
				arg_35_9[3] = start_layer + 3

				local header_glow_size = self.header_glow_size

				header_glow_size[1] = background_size[1]
				header_glow_size[2] = background_size[2]

				local header_glow_texture = content.header_glow_texture

				get_table[1] = num_2
				arg_35_9[2] = arg_35_9[2] - 5

				UIRenderer.draw_texture(arg_35_3, header_glow_texture, arg_35_9, header_glow_size, get_table)

				text_size[2] = get_text_height
				arg_35_9[1] = var_35_39 + frame_margin + title_text.offset[1]
				arg_35_9[2] = var_35_9 + frame_margin * 0.5 - get_text_height + title_text.offset[2]
				arg_35_9[3] = start_layer + 6 + title_text.offset[3]
				content.text = var_35_19
				title_text.text_color[1] = num_2
				title_text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_35_3, text_pass_data, arg_35_5, arg_35_6, title_text, content, arg_35_9, text_size, arg_35_11, arg_35_12)

				arg_35_9[1] = var_35_39 + frame_margin + title_text_shadow.offset[1]
				arg_35_9[2] = var_35_9 + frame_margin * 0.5 - get_text_height + title_text_shadow.offset[2]
				arg_35_9[3] = start_layer + 6 + title_text_shadow.offset[3]

				UIPasses.text.draw(arg_35_3, text_pass_data, arg_35_5, arg_35_6, title_text_shadow, content, arg_35_9, text_size, arg_35_11, arg_35_12)

				text_size[2] = get_text_height_2
				arg_35_9[1] = var_35_39 + frame_margin + text.offset[1]
				arg_35_9[2] = var_35_9 + frame_margin * 0.5 - (get_text_height + get_text_height_2) + text.offset[2]
				arg_35_9[3] = start_layer + 6 + text.offset[3]
				content.text = var_35_20
				text.text_color[1] = num_2
				text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_35_3, text_pass_data, arg_35_5, arg_35_6, text, content, arg_35_9, text_size, arg_35_11, arg_35_12)

				arg_35_9[1] = var_35_39 + frame_margin + text_shadow.offset[1]
				arg_35_9[2] = var_35_9 + frame_margin * 0.5 - (get_text_height + get_text_height_2) + text_shadow.offset[2]
				arg_35_9[3] = start_layer + 6 + text_shadow.offset[3]

				UIPasses.text.draw(arg_35_3, text_pass_data, arg_35_5, arg_35_6, text_shadow, content, arg_35_9, text_size, arg_35_11, arg_35_12)
			end

			arg_35_9[1] = var_35_8
			arg_35_9[2] = var_35_9
			arg_35_9[3] = var_35_10

			return num_5
		end
	},
	item_text = {
		setup_data = function ()
			-- function 36
			local tbl = {
				{
					vertical_alignment = "bottom",
					name = "stat",
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					prefix_text = "Stamina:",
					font_size = fn(20),
					text_color = Colors.get_color_table_with_alpha("green", 255)
				},
				{
					vertical_alignment = "bottom",
					name = "properties",
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					prefix_text = "Properties:",
					font_size = fn(16),
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
					font_size = fn(16),
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
					font_size = fn(16),
					text_color = Colors.get_color_table_with_alpha("font_title", 255)
				}
			}

			for i = 1, 4 do
				tbl[#tbl + 1] = {
					vertical_alignment = "bottom",
					localize = false,
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					name = "tooltip_title_" .. i,
					font_size = fn(16),
					text_color = Colors.get_color_table_with_alpha("font_title", 255)
				}
				tbl[#tbl + 1] = {
					vertical_alignment = "bottom",
					localize = false,
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					name = "tooltip_description_" .. i,
					font_size = fn(16),
					text_color = Colors.get_color_table_with_alpha("font_default", 255)
				}
				tbl[#tbl + 1] = {
					vertical_alignment = "bottom",
					localize = false,
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					name = "tooltip_warning_" .. i,
					font_size = fn(16),
					text_color = Colors.get_color_table_with_alpha("red", 255)
				}
			end

			return {
				text_styles = tbl,
				text_content = {},
				text_pass_data = {},
				text_pass_size = {}
			}
		end,
		draw = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7, arg_37_8, arg_37_9, arg_37_10, arg_37_11, arg_37_12, arg_37_13)
			-- function 37
			if not Development.parameter("enable_detailed_tooltips") and arg_37_11:get("item_compare") and not arg_37_11:get("item_detail") then
				local slot_type = arg_37_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			end

			local num_2 = 255 * arg_37_4.alpha_multiplier
			local start_layer = arg_37_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local text_styles = self.text_styles
			local text_content = self.text_content

			table.clear(text_content)

			local backend_id = arg_37_13.backend_id
			local data = arg_37_13.data
			local rarity = arg_37_13.rarity

			rarity = rarity or data.rarity

			local get_table = Colors.get_table(rarity)
			local slot_type_2 = data.slot_type
			local flag = slot_type_2 == ItemType.LOOT_CHEST or BackendUtils.get_item_template(data, backend_id)
			local flag_2 = slot_type_2 ~= ItemType.MELEE or flag.max_fatigue_points

			if not flag_2 then
				local str = "+" .. flag_2 .. Localize("tooltip_stamina")

				str = str or "n/a"
				text_content.stat = str
			end

			if not flag and not flag.buffs and not flag.buffs[1] then
				local get_buff_template = BuffUtils.get_buff_template(flag.buffs[1].name)

				if not get_buff_template then
					local var_37_15 = get_buff_template.buffs[1]
					local bonus = var_37_15.bonus

					if not var_37_15 then
						if not var_37_15.multiplier then
							bonus = var_37_15.multiplier
							text_content.stat = "+" .. bonus * 100 .. "% " .. var_37_15.description
						else
							text_content.stat = "+" .. bonus .. " " .. var_37_15.description
						end
					end
				end
			end

			local ipairs

			if not arg_37_2 then
				ipairs = ipairs

				if not ipairs then
					-- Nothing
				end
			end

			ipairs = ripairs

			::label_37_0::

			local var_37_18 = arg_37_9[1]
			local var_37_19 = arg_37_9[2]
			local var_37_20 = arg_37_9[3]

			arg_37_9[1] = arg_37_9[1] + frame_margin

			local num_3

			if not arg_37_2 then
				num_3 = arg_37_9[2] - arg_37_10[2] - frame_margin

				if not num_3 then
					-- Nothing
				end
			end

			num_3 = arg_37_9[2] + frame_margin

			::label_37_1::

			arg_37_9[2] = num_3
			arg_37_9[3] = start_layer + 5

			local text_pass_data = self.text_pass_data
			local text_pass_size = self.text_pass_size

			text_pass_size[1] = arg_37_10[1] - frame_margin * 2
			text_pass_size[2] = arg_37_10[2]

			local num_4 = 0

			for iter_37_0, iter_37_1 in ipairs(text_styles) do
				local ignore_line_change = iter_37_1.ignore_line_change
				local flag_3

				flag_3 = not arg_37_2 and "top" and "bottom"
				iter_37_1.vertical_alignment = flag_3

				local name = iter_37_1.name
				local var_37_28 = text_content[name]

				if var_37_28 == true then
					var_37_28 = iter_37_1.text
					text_content[name] = var_37_28
				end

				if not var_37_28 then
					text_pass_data.text_id = name

					local get_text_height = UIUtils.get_text_height(arg_37_3, text_pass_size, iter_37_1, var_37_28)

					if not arg_37_1 then
						iter_37_1.text_color[1] = num_2

						UIPasses.text.draw(arg_37_3, text_pass_data, arg_37_5, arg_37_6, iter_37_1, text_content, arg_37_9, text_pass_size, arg_37_11, arg_37_12)
					end

					if not ignore_line_change then
						if not arg_37_2 then
							arg_37_9[2] = arg_37_9[2] - get_text_height
						else
							arg_37_9[2] = arg_37_9[2] + get_text_height
						end

						num_4 = num_4 + get_text_height
					end
				end
			end

			arg_37_9[1] = var_37_18
			arg_37_9[2] = var_37_19
			arg_37_9[3] = var_37_20

			return num_4
		end
	},
	unwieldable = {
		setup_data = function ()
			-- function 38
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
						font_size = fn(24),
						text_color = Colors.get_color_table_with_alpha("red", 255)
					}
				}
			}
		end,
		draw = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9, arg_39_10, arg_39_11, arg_39_12, arg_39_13)
			-- function 39
			if not Development.parameter("enable_detailed_tooltips") and arg_39_11:get("item_compare") and not arg_39_11:get("item_detail") then
				local slot_type = arg_39_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			end

			local num_2 = 255 * arg_39_4.alpha_multiplier
			local start_layer = arg_39_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local content = self.content
			local style = self.style
			local data = arg_39_13.data
			local player = arg_39_4.player

			if not player then
				local career_name = player:career_name()
				local profile_index = arg_39_8.profile_index
				local career_index = arg_39_8.career_index

				if not profile_index and not career_index then
					career_name = SPProfiles[profile_index].careers[career_index].name
				end

				local flag = not data and data.can_wield
				local contains

				if not flag then
					contains = table.contains(flag, career_name)

					if not contains then
						-- Nothing
					end
				end

				contains = arg_39_6.disable_unsupported

				::label_39_0::

				if not contains then
					local str = ""
					local count = #flag, (table.contains(flag, career_name))

					for i, v in ipairs(flag) do
						local display_name = CareerSettings[v].display_name

						str = str .. Localize(display_name)
						count = count - 1

						if count > 0 then
							str = str .. ", "
						end
					end

					content.text = str

					local var_39_16 = arg_39_9[1]
					local var_39_17 = arg_39_9[2]
					local var_39_18 = arg_39_9[3]

					arg_39_9[3] = start_layer + 5

					local text = style.text
					local text_pass_data = self.text_pass_data
					local text_size = self.text_size

					text_size[1] = arg_39_10[1] - frame_margin * 2
					text_size[2] = 0

					local get_text_height = UIUtils.get_text_height(arg_39_3, text_size, text, str)

					text_size[2] = get_text_height

					if not arg_39_1 then
						arg_39_9[1] = var_39_16 + frame_margin
						arg_39_9[2] = arg_39_9[2] - get_text_height + frame_margin * 0.5
						text.text_color[1] = num_2

						UIPasses.text.draw(arg_39_3, text_pass_data, arg_39_5, arg_39_6, text, content, arg_39_9, text_size, arg_39_11, arg_39_12)
					end

					arg_39_9[1] = var_39_16
					arg_39_9[2] = var_39_17
					arg_39_9[3] = var_39_18

					return get_text_height
				else
					return 0
				end
			else
				return 0
			end
		end
	},
	skin_applied = {
		setup_data = function ()
			-- function 40
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("promo", 255)
					}
				}
			}
		end,
		draw = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5, arg_41_6, arg_41_7, arg_41_8, arg_41_9, arg_41_10, arg_41_11, arg_41_12, arg_41_13)
			-- function 41
			if not Development.parameter("enable_detailed_tooltips") and arg_41_11:get("item_compare") and not arg_41_11:get("item_detail") then
				local slot_type = arg_41_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			end

			local num_2 = 255 * arg_41_4.alpha_multiplier
			local start_layer = arg_41_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local content = self.content
			local style = self.style
			local data = arg_41_13.data
			local skin = arg_41_13.skin
			local item_type = data.item_type
			local ItemId = arg_41_13.ItemId

			ItemId = ItemId or arg_41_13.item_id

			local flag = not ItemId and string.gsub(ItemId, "^vs_", "")

			if not (not skin and item_type == "weapon_skin" or WeaponSkins.default_skins[flag] == skin) then
				local var_41_11

				if not arg_41_13.hidden_description then
					var_41_11 = str

					if not var_41_11 then
						-- Nothing
					end
				end

				var_41_11 = content.prefix_text

				::label_41_0::

				content.text = var_41_11

				local var_41_12 = arg_41_9[1]
				local var_41_13 = arg_41_9[2]
				local var_41_14 = arg_41_9[3]

				arg_41_9[3] = start_layer + 5

				local text = style.text
				local text_pass_data = self.text_pass_data
				local text_size = self.text_size

				text_size[1] = arg_41_10[1] - frame_margin * 2
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_41_3, text_size, text, content.text)

				text_size[2] = get_text_height

				if not arg_41_1 then
					arg_41_9[1] = var_41_12 + frame_margin
					arg_41_9[2] = arg_41_9[2] - get_text_height
					text.text_color[1] = num_2

					UIPasses.text.draw(arg_41_3, text_pass_data, arg_41_5, arg_41_6, text, content, arg_41_9, text_size, arg_41_11, arg_41_12)
				end

				arg_41_9[1] = var_41_12
				arg_41_9[2] = var_41_13
				arg_41_9[3] = var_41_14

				return get_text_height
			else
				return 0
			end
		end
	},
	console_item_description = {
		setup_data = function ()
			-- function 42
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
						font_size = fn(14),
						text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
					}
				}
			}
		end,
		draw = function (self, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6, arg_43_7, arg_43_8, arg_43_9, arg_43_10, arg_43_11, arg_43_12, arg_43_13)
			-- function 43
			if not Development.parameter("enable_detailed_tooltips") and arg_43_11:get("item_compare") and not arg_43_11:get("item_detail") then
				local slot_type = arg_43_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			end

			local num_2 = 255 * arg_43_4.alpha_multiplier
			local start_layer = arg_43_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local content = self.content
			local style = self.style
			local var_43_6
			local slot_type_2 = arg_43_13.data.slot_type
			local get_ui_information_from_item, var_43_9, var_43_10 = UIUtils.get_ui_information_from_item(arg_43_13)

			if not (not var_43_10 and Localize(var_43_10) == "") then
				var_43_6 = Localize(var_43_10)
			end

			if not var_43_6 then
				return 0
			end

			content.text = var_43_6

			local var_43_11 = arg_43_9[1]
			local var_43_12 = arg_43_9[2]
			local var_43_13 = arg_43_9[3]

			arg_43_9[3] = start_layer + 5

			local text = style.text
			local text_pass_data = self.text_pass_data
			local text_size = self.text_size

			text_size[1] = arg_43_10[1] - frame_margin * 2
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_43_3, text_size, text, var_43_6)

			text_size[2] = get_text_height

			local num_3 = get_text_height + frame_margin * 0.5

			if not arg_43_1 then
				arg_43_9[1] = var_43_11 + frame_margin
				arg_43_9[2] = arg_43_9[2] - num_3
				text.text_color[1] = num_2

				UIPasses.text.draw(arg_43_3, text_pass_data, arg_43_5, arg_43_6, text, content, arg_43_9, text_size, arg_43_11, arg_43_12)
			end

			arg_43_9[1] = var_43_11
			arg_43_9[2] = var_43_12
			arg_43_9[3] = var_43_13

			return num_3
		end
	},
	item_description = {
		setup_data = function ()
			-- function 44
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
						font_size = fn(14),
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
		draw = function (self, arg_45_1, arg_45_2, arg_45_3, arg_45_4, arg_45_5, arg_45_6, arg_45_7, arg_45_8, arg_45_9, arg_45_10, arg_45_11, arg_45_12, arg_45_13)
			-- function 45
			if not Development.parameter("enable_detailed_tooltips") and arg_45_11:get("item_compare") and not arg_45_11:get("item_detail") then
				local slot_type = arg_45_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			end

			local num_2 = 255 * arg_45_4.alpha_multiplier
			local start_layer = arg_45_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local content = self.content
			local style = self.style
			local var_45_6
			local slot_type_2 = arg_45_13.data.slot_type
			local get_ui_information_from_item, var_45_9, var_45_10 = UIUtils.get_ui_information_from_item(arg_45_13)

			if not (not var_45_10 and Localize(var_45_10) == "") then
				var_45_6 = Localize(var_45_10)
			end

			if not var_45_6 then
				return 0
			end

			content.text = var_45_6

			local var_45_11 = arg_45_9[1]
			local var_45_12 = arg_45_9[2]
			local var_45_13 = arg_45_9[3]

			arg_45_9[3] = start_layer + 5

			local text = style.text
			local text_pass_data = self.text_pass_data
			local text_size = self.text_size

			text_size[1] = arg_45_10[1] - frame_margin * 2
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_45_3, text_size, text, var_45_6)

			text_size[2] = get_text_height

			local inv_scale = RESOLUTION_LOOKUP.inv_scale
			local num_3 = get_text_height + frame_margin

			if not arg_45_1 then
				local background_size = self.background_size
				local color = style.background.color

				color[1] = num_2
				background_size[1] = arg_45_10[1]
				background_size[2] = num_3
				arg_45_9[2] = var_45_12 - background_size[2]
				arg_45_9[3] = start_layer + 3

				UIRenderer.draw_rect(arg_45_3, arg_45_9, background_size, color)

				arg_45_9[1] = var_45_11
				arg_45_9[2] = var_45_12

				local edge_size = self.edge_size

				edge_size[1] = arg_45_10[1]

				local edge = style.edge
				local color_2 = edge.color
				local texture_size = edge.texture_size

				texture_size[1] = arg_45_10[1]

				local edge_texture = content.edge_texture

				color_2[1] = num_2

				local num_4 = arg_45_9[2] - frame_margin * 0.5 * inv_scale

				arg_45_9[2] = num_4
				arg_45_9[3] = start_layer + 4

				UIRenderer.draw_tiled_texture(arg_45_3, edge_texture, arg_45_9, edge_size, texture_size, color_2)

				local edge_holder = style.edge_holder
				local edge_holder_size = self.edge_holder_size
				local color_3 = edge_holder.color
				local edge_holder_left = content.edge_holder_left
				local edge_holder_right = content.edge_holder_right

				color_3[1] = num_2
				arg_45_9[1] = arg_45_9[1] + 3
				arg_45_9[2] = num_4 - 6
				arg_45_9[3] = start_layer + 6

				UIRenderer.draw_texture(arg_45_3, edge_holder_left, arg_45_9, edge_holder_size, color_3)

				arg_45_9[1] = arg_45_9[1] + edge_size[1] - (edge_holder_size[1] + 6)

				UIRenderer.draw_texture(arg_45_3, edge_holder_right, arg_45_9, edge_holder_size, color_3)

				arg_45_9[1] = var_45_11 + frame_margin
				arg_45_9[2] = num_4 - get_text_height
				text.text_color[1] = num_2

				UIPasses.text.draw(arg_45_3, text_pass_data, arg_45_5, arg_45_6, text, content, arg_45_9, text_size, arg_45_11, arg_45_12)
			end

			arg_45_9[1] = var_45_11
			arg_45_9[2] = var_45_12
			arg_45_9[3] = var_45_13

			return num_3
		end
	},
	talent_text = {
		setup_data = function ()
			-- function 46
			local tbl = {
				{
					word_wrap = true,
					name = "title",
					localize = true,
					use_shadow = true,
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					font_type = "hell_shark",
					font_size = fn(24),
					text_color = Colors.get_color_table_with_alpha("font_title", 255)
				},
				{
					vertical_alignment = "bottom",
					name = "description",
					localize = false,
					word_wrap = true,
					horizontal_alignment = "left",
					font_type = "hell_shark",
					font_size = fn(20),
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
					font_size = fn(16),
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
					font_size = fn(16),
					text_color = Colors.get_color_table_with_alpha("green", 255)
				}
			}
			local tbl_2 = {
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
			local tbl_3 = {
				text_styles = tbl,
				texture_styles = tbl_2
			}
			local is_device_active = Managers.input:is_device_active("gamepad")

			tbl_3.text_content = {}
			tbl_3.text_pass_data = {}
			tbl_3.text_pass_size = {}
			tbl_3.texture_pass_data = {}
			tbl_3.texture_pass_definition = {
				texture_id = "texture_id",
				style_id = "information"
			}

			return tbl_3
		end,
		draw = function (self, arg_47_1, arg_47_2, arg_47_3, arg_47_4, arg_47_5, arg_47_6, arg_47_7, arg_47_8, arg_47_9, arg_47_10, arg_47_11, arg_47_12, arg_47_13)
			-- function 47
			local num_2 = 255 * arg_47_4.alpha_multiplier
			local start_layer = arg_47_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local text_styles = self.text_styles
			local text_content = self.text_content

			table.clear(text_content)

			local disabled = arg_47_8.disabled
			local is_selected = arg_47_8.is_selected
			local display_name = arg_47_13.display_name

			if not display_name then
				display_name = arg_47_13.name
				display_name = display_name or "n/a"
			end

			text_content.title = display_name

			local var_47_8
			local var_47_9

			if not disabled then
				var_47_8 = Localize("talent_locked_desc")
			elseif not is_selected then
				var_47_9 = not arg_47_8.gamepad_active and Localize("menu_select") and Localize("talent_can_select_desc")
			end

			text_content.requirement = var_47_8
			text_content.information = var_47_9
			text_content.description = UIUtils.get_talent_description(arg_47_13)

			local ipairs

			if not arg_47_2 then
				ipairs = ipairs

				if not ipairs then
					-- Nothing
				end
			end

			ipairs = ripairs

			::label_47_0::

			local var_47_11 = arg_47_9[1]
			local var_47_12 = arg_47_9[2]
			local var_47_13 = arg_47_9[3]

			arg_47_9[1] = arg_47_9[1] + frame_margin

			local num_3

			if not arg_47_2 then
				num_3 = arg_47_9[2] - arg_47_10[2] - frame_margin

				if not num_3 then
					-- Nothing
				end
			end

			num_3 = arg_47_9[2] + frame_margin

			::label_47_1::

			arg_47_9[2] = num_3
			arg_47_9[3] = start_layer + 5

			local text_pass_data = self.text_pass_data
			local text_pass_size = self.text_pass_size

			text_pass_size[1] = arg_47_10[1] - frame_margin * 2
			text_pass_size[2] = arg_47_10[2]

			local var_47_17 = frame_margin

			for iter_47_0, iter_47_1 in ipairs(text_styles) do
				local ignore_line_change = iter_47_1.ignore_line_change
				local flag

				flag = not arg_47_2 and "top" and "bottom"
				iter_47_1.vertical_alignment = flag

				local name = iter_47_1.name
				local var_47_21 = text_content[name]
				local var_47_22 = self.texture_styles[name]

				if not arg_47_1 and not var_47_21 and not var_47_22 and not arg_47_8.gamepad_active then
					local texture_pass_data = self.texture_pass_data
					local texture_size = self.texture_size
					local texture_pass_definition = self.texture_pass_definition
					local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(arg_47_11, "confirm", true)

					var_47_22.texture_size[1] = get_gamepad_input_texture_data.size[1] * 0.8
					var_47_22.texture_size[2] = get_gamepad_input_texture_data.size[2] * 0.8
					var_47_22.color[1] = num_2
					arg_47_8.texture_id = get_gamepad_input_texture_data.texture

					local var_47_27 = arg_47_9[2]

					arg_47_9[2] = arg_47_9[2] - frame_margin

					UIPasses.texture.draw(arg_47_3, texture_pass_data, arg_47_5, texture_pass_definition, var_47_22, arg_47_8, arg_47_9, text_pass_size, arg_47_11, arg_47_12)

					arg_47_9[1] = arg_47_9[1] + var_47_22.texture_size[1] + frame_margin * 0.5
					arg_47_9[2] = var_47_27
				end

				if var_47_21 == true then
					var_47_21 = iter_47_1.text
					text_content[name] = var_47_21
				end

				if not var_47_21 then
					text_pass_data.text_id = name

					if not arg_47_1 then
						iter_47_1.text_color[1] = num_2

						UIPasses.text.draw(arg_47_3, text_pass_data, arg_47_5, arg_47_6, iter_47_1, text_content, arg_47_9, text_pass_size, arg_47_11, arg_47_12)
					end

					local get_text_height = UIUtils.get_text_height(arg_47_3, text_pass_size, iter_47_1, var_47_21)

					if not ignore_line_change then
						if not arg_47_2 then
							arg_47_9[2] = arg_47_9[2] - get_text_height
						else
							arg_47_9[2] = arg_47_9[2] + get_text_height
						end

						var_47_17 = var_47_17 + get_text_height
					end
				end
			end

			arg_47_9[1] = var_47_11
			arg_47_9[2] = var_47_12
			arg_47_9[3] = var_47_13

			return var_47_17
		end
	},
	generic_text = {
		setup_data = function ()
			-- function 48
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
						font_size = fn(20),
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
						font_size = fn(20),
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
		draw = function (self, arg_49_1, arg_49_2, arg_49_3, arg_49_4, arg_49_5, arg_49_6, arg_49_7, arg_49_8, arg_49_9, arg_49_10, arg_49_11, arg_49_12)
			-- function 49
			local text_id = arg_49_6.text_id
			local flag = not text_id and arg_49_8[text_id]

			if not flag then
				return 0
			end

			local style_id = arg_49_6.style_id
			local num_2 = 255 * arg_49_4.alpha_multiplier
			local start_layer = arg_49_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local var_49_8 = arg_49_9[1]
			local var_49_9 = arg_49_9[2]
			local var_49_10 = arg_49_9[3]
			local var_49_11 = frame_margin
			local title_text = style.title_text
			local title_text_shadow = style.title_text_shadow
			local text_pass_data = self.text_pass_data

			text_pass_data.text_id = text_id

			local flag_2 = not style_id and arg_49_7.localize

			title_text.localize = flag_2
			title_text_shadow.localize = flag_2

			local text_size = self.text_size
			local num_3 = arg_49_10[1] - frame_margin * 2

			text_size[1] = num_3
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_49_3, text_size, title_text, flag)
			local num_4 = var_49_11 + get_text_height

			text_size[2] = get_text_height

			if not arg_49_1 then
				local num_5 = arg_49_9[1] + frame_margin
				local num_6 = arg_49_9[2] - num_4 + frame_margin

				arg_49_9[1] = num_5 + title_text.offset[1]
				arg_49_9[2] = num_6 - frame_margin + title_text.offset[2]
				arg_49_9[3] = start_layer + 6 + title_text.offset[3]
				text_size[1] = num_3

				local line_colors = title_text.line_colors

				for i, v in ipairs(line_colors) do
					v[1] = num_2
				end

				title_text.text_color[1] = num_2
				title_text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_49_3, text_pass_data, arg_49_5, arg_49_6, title_text, arg_49_8, arg_49_9, text_size, arg_49_11, arg_49_12)

				arg_49_9[1] = num_5 + title_text_shadow.offset[1]
				arg_49_9[2] = num_6 - frame_margin + title_text_shadow.offset[2]
				arg_49_9[3] = start_layer + 6 + title_text_shadow.offset[3]

				UIPasses.text.draw(arg_49_3, text_pass_data, arg_49_5, arg_49_6, title_text_shadow, arg_49_8, arg_49_9, text_size, arg_49_11, arg_49_12)
			end

			arg_49_9[1] = var_49_8
			arg_49_9[2] = var_49_9
			arg_49_9[3] = var_49_10

			return num_4
		end
	},
	level_info = {
		setup_data = function ()
			-- function 50
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
							font_size = fn(28),
							text_color = Colors.get_color_table_with_alpha("font_title", 255)
						},
						{
							vertical_alignment = "center",
							name = "description",
							word_wrap = true,
							horizontal_alignment = "center",
							font_type = "hell_shark",
							font_size = fn(18),
							text_color = Colors.get_color_table_with_alpha("font_default", 255)
						}
					}
				}
			}
		end,
		draw = function (self, arg_51_1, arg_51_2, arg_51_3, arg_51_4, arg_51_5, arg_51_6, arg_51_7, arg_51_8, arg_51_9, arg_51_10, arg_51_11, arg_51_12, arg_51_13)
			-- function 51
			local num_2 = 255 * arg_51_4.alpha_multiplier
			local start_layer = arg_51_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local text_styles = style.text_styles
			local text_content = content.text_content
			local display_name = arg_51_13.display_name
			local num_3 = frame_margin * 0.5
			local var_51_9 = arg_51_9[1]
			local var_51_10 = arg_51_9[2]
			local var_51_11 = arg_51_9[3]
			local frame_name = self.frame_name
			local var_51_13 = UIFrameSettings[frame_name].texture_sizes.horizontal[2]

			text_content.title = Localize(display_name)
			arg_51_9[1] = arg_51_9[1] + frame_margin

			local num_4

			if not arg_51_2 then
				num_4 = arg_51_9[2] - num_3

				if not num_4 then
					-- Nothing
				end
			end

			num_4 = arg_51_9[2] + var_51_13

			::label_51_0::

			arg_51_9[2] = num_4
			arg_51_9[3] = start_layer + 5

			local text_size = self.text_size

			text_size[1] = arg_51_10[1] - frame_margin * 2
			text_size[2] = 0

			local num_5 = -var_51_13
			local text_pass_data = self.text_pass_data
			local ipairs

			if not arg_51_2 then
				ipairs = ipairs

				if not ipairs then
					-- Nothing
				end
			end

			ipairs = ripairs

			::label_51_1::

			for iter_51_0, iter_51_1 in ipairs(text_styles) do
				local ignore_line_change = iter_51_1.ignore_line_change
				local flag

				flag = not arg_51_2 and "top" and "top"
				iter_51_1.vertical_alignment = flag

				local name = iter_51_1.name
				local var_51_22 = text_content[name]

				if var_51_22 == true then
					var_51_22 = iter_51_1.text
					text_content[name] = var_51_22
				end

				if not var_51_22 then
					text_pass_data.text_id = name

					local get_text_height = UIUtils.get_text_height(arg_51_3, text_size, iter_51_1, var_51_22)

					if not (ignore_line_change or arg_51_2) then
						arg_51_9[2] = arg_51_9[2] + get_text_height
					end

					if not arg_51_1 then
						iter_51_1.text_color[1] = num_2

						UIPasses.text.draw(arg_51_3, text_pass_data, arg_51_5, arg_51_6, iter_51_1, text_content, arg_51_9, text_size, arg_51_11, arg_51_12)
					end

					if not ignore_line_change then
						if not arg_51_2 then
							arg_51_9[2] = arg_51_9[2] - get_text_height
						end

						num_5 = num_5 + get_text_height
					end
				end
			end

			local num_6 = num_3 + num_5

			arg_51_9[1] = var_51_9
			arg_51_9[2] = var_51_10
			arg_51_9[3] = var_51_11

			return num_6
		end
	},
	additional_option_info = {
		setup_data = function ()
			-- function 52
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
							font_size = fn(28),
							text_color = Colors.get_color_table_with_alpha("font_title", 255)
						},
						{
							vertical_alignment = "center",
							name = "description",
							word_wrap = true,
							horizontal_alignment = "center",
							font_type = "hell_shark",
							font_size = fn(18),
							text_color = Colors.get_color_table_with_alpha("font_default", 255)
						}
					}
				}
			}
		end,
		draw = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5, arg_53_6, arg_53_7, arg_53_8, arg_53_9, arg_53_10, arg_53_11, arg_53_12, arg_53_13)
			-- function 53
			local num_2 = 255 * arg_53_4.alpha_multiplier
			local start_layer = arg_53_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local text_styles = style.text_styles
			local text_content = content.text_content
			local title = arg_53_13.title

			title = title or arg_53_13.display_name

			local description = arg_53_13.description

			if not arg_53_7 and not arg_53_7.localize then
				title = Localize(title)

				local description_values = arg_53_13.description_values

				description = UIUtils.format_localized_description(description, description_values)
			end

			local num_3 = frame_margin * 0.5
			local var_53_11 = arg_53_9[1]
			local var_53_12 = arg_53_9[2]
			local var_53_13 = arg_53_9[3]
			local frame_name = self.frame_name
			local var_53_15 = UIFrameSettings[frame_name].texture_sizes.horizontal[2]

			text_content.title = title
			text_content.description = description
			arg_53_9[1] = arg_53_9[1] + frame_margin

			local num_4

			if not arg_53_2 then
				num_4 = arg_53_9[2] - num_3

				if not num_4 then
					-- Nothing
				end
			end

			num_4 = arg_53_9[2] + var_53_15

			::label_53_0::

			arg_53_9[2] = num_4
			arg_53_9[3] = start_layer + 5

			local text_size = self.text_size

			text_size[1] = arg_53_10[1] - frame_margin * 2
			text_size[2] = 0

			local num_5 = -var_53_15
			local text_pass_data = self.text_pass_data
			local ipairs

			if not arg_53_2 then
				ipairs = ipairs

				if not ipairs then
					-- Nothing
				end
			end

			ipairs = ripairs

			::label_53_1::

			for iter_53_0, iter_53_1 in ipairs(text_styles) do
				local ignore_line_change = iter_53_1.ignore_line_change
				local flag

				flag = not arg_53_2 and "top" and "top"
				iter_53_1.vertical_alignment = flag

				local name = iter_53_1.name
				local var_53_24 = text_content[name]

				if var_53_24 == true then
					var_53_24 = iter_53_1.text
					text_content[name] = var_53_24
				end

				if not var_53_24 then
					text_pass_data.text_id = name

					local get_text_height = UIUtils.get_text_height(arg_53_3, text_size, iter_53_1, var_53_24)

					if not (ignore_line_change or arg_53_2) then
						arg_53_9[2] = arg_53_9[2] + get_text_height
					end

					if not arg_53_1 then
						iter_53_1.text_color[1] = num_2

						UIPasses.text.draw(arg_53_3, text_pass_data, arg_53_5, arg_53_6, iter_53_1, text_content, arg_53_9, text_size, arg_53_11, arg_53_12)
					end

					if not ignore_line_change then
						if not arg_53_2 then
							arg_53_9[2] = arg_53_9[2] - get_text_height
						end

						num_5 = num_5 + get_text_height
					end
				end
			end

			local num_6 = num_3 + num_5

			arg_53_9[1] = var_53_11
			arg_53_9[2] = var_53_12
			arg_53_9[3] = var_53_13

			return num_6
		end
	},
	deed_mission = {
		setup_data = function ()
			-- function 54
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
						font_size = fn(28),
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
						font_size = fn(28),
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
						font_size = fn(18),
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
						font_size = fn(18),
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
		draw = function (self, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, arg_55_6, arg_55_7, arg_55_8, arg_55_9, arg_55_10, arg_55_11, arg_55_12, arg_55_13)
			-- function 55
			local level_key = arg_55_13.level_key

			if level_key == nil then
				return 0
			end

			local num_2 = 255 * arg_55_4.alpha_multiplier
			local start_layer = arg_55_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local var_55_6 = arg_55_9[1]
			local var_55_7 = arg_55_9[2]
			local var_55_8 = arg_55_9[3]
			local var_55_9 = Localize("start_game_window_mission")
			local display_name = LevelSettings[level_key].display_name
			local var_55_11 = Localize(display_name)
			local text = style.text
			local text_shadow = style.text_shadow
			local title_text = style.title_text
			local title_text_shadow = style.title_text_shadow
			local text_pass_data = self.text_pass_data
			local text_size = self.text_size

			text_size[1] = arg_55_10[1] - frame_margin * 2
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_55_3, text_size, title_text, var_55_9)
			local get_text_height_2 = UIUtils.get_text_height(arg_55_3, text_size, text, var_55_11)
			local num_3 = get_text_height + get_text_height_2

			text_size[2] = num_3

			if not arg_55_1 then
				local num_4 = arg_55_9[1] + frame_margin

				arg_55_9[1] = num_4 + title_text.offset[1]
				arg_55_9[2] = var_55_7 - frame_margin - get_text_height + title_text.offset[2]
				arg_55_9[3] = start_layer + 6 + title_text.offset[3]
				text_size[1] = arg_55_10[1]
				content.text = var_55_9
				title_text.text_color[1] = num_2
				title_text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_55_3, text_pass_data, arg_55_5, arg_55_6, title_text, content, arg_55_9, text_size, arg_55_11, arg_55_12)

				arg_55_9[1] = num_4 + title_text_shadow.offset[1]
				arg_55_9[2] = var_55_7 - frame_margin - get_text_height + title_text_shadow.offset[2]
				arg_55_9[3] = start_layer + 6 + title_text_shadow.offset[3]

				UIPasses.text.draw(arg_55_3, text_pass_data, arg_55_5, arg_55_6, title_text_shadow, content, arg_55_9, text_size, arg_55_11, arg_55_12)

				arg_55_9[1] = num_4 + text.offset[1]
				arg_55_9[2] = var_55_7 - frame_margin * 1.5 - (get_text_height + get_text_height_2) + text.offset[2]
				arg_55_9[3] = start_layer + 6 + text.offset[3]
				text_size[1] = arg_55_10[1]
				content.text = var_55_11
				text.text_color[1] = num_2
				text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_55_3, text_pass_data, arg_55_5, arg_55_6, text, content, arg_55_9, text_size, arg_55_11, arg_55_12)

				arg_55_9[1] = num_4 + text_shadow.offset[1]
				arg_55_9[2] = var_55_7 - frame_margin * 1.5 - (get_text_height + get_text_height_2) + text_shadow.offset[2]
				arg_55_9[3] = start_layer + 6 + text_shadow.offset[3]

				UIPasses.text.draw(arg_55_3, text_pass_data, arg_55_5, arg_55_6, text_shadow, content, arg_55_9, text_size, arg_55_11, arg_55_12)
			end

			arg_55_9[1] = var_55_6
			arg_55_9[2] = var_55_7
			arg_55_9[3] = var_55_8

			return num_3
		end
	},
	deed_difficulty = {
		setup_data = function ()
			-- function 56
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
						font_size = fn(28),
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
						font_size = fn(28),
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
						font_size = fn(18),
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
						font_size = fn(18),
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
		draw = function (self, arg_57_1, arg_57_2, arg_57_3, arg_57_4, arg_57_5, arg_57_6, arg_57_7, arg_57_8, arg_57_9, arg_57_10, arg_57_11, arg_57_12, arg_57_13)
			-- function 57
			local num_2 = 255 * arg_57_4.alpha_multiplier
			local start_layer = arg_57_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			if arg_57_13.data.item_type ~= "deed" then
				return 0
			end

			local style = self.style
			local content = self.content
			local var_57_5 = arg_57_9[1]
			local var_57_6 = arg_57_9[2]
			local var_57_7 = arg_57_9[3]
			local var_57_8 = Localize("start_game_window_difficulty")
			local difficulty = arg_57_13.difficulty

			difficulty = difficulty or "normal"

			local display_name = DifficultySettings[difficulty].display_name
			local var_57_11 = Localize(display_name)
			local text = style.text
			local text_shadow = style.text_shadow
			local title_text = style.title_text
			local title_text_shadow = style.title_text_shadow
			local text_pass_data = self.text_pass_data
			local text_size = self.text_size

			text_size[1] = arg_57_10[1] - frame_margin * 2
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_57_3, text_size, title_text, var_57_8)
			local get_text_height_2 = UIUtils.get_text_height(arg_57_3, text_size, text, var_57_11)
			local num_3 = get_text_height + get_text_height_2

			text_size[2] = num_3

			if not arg_57_1 then
				local num_4 = arg_57_9[1] + frame_margin

				arg_57_9[1] = num_4 + title_text.offset[1]
				arg_57_9[2] = var_57_6 - frame_margin - get_text_height + title_text.offset[2]
				arg_57_9[3] = start_layer + 6 + title_text.offset[3]
				text_size[1] = arg_57_10[1]
				content.text = var_57_8
				title_text.text_color[1] = num_2
				title_text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_57_3, text_pass_data, arg_57_5, arg_57_6, title_text, content, arg_57_9, text_size, arg_57_11, arg_57_12)

				arg_57_9[1] = num_4 + title_text_shadow.offset[1]
				arg_57_9[2] = var_57_6 - frame_margin - get_text_height + title_text_shadow.offset[2]
				arg_57_9[3] = start_layer + 6 + title_text_shadow.offset[3]

				UIPasses.text.draw(arg_57_3, text_pass_data, arg_57_5, arg_57_6, title_text_shadow, content, arg_57_9, text_size, arg_57_11, arg_57_12)

				arg_57_9[1] = num_4 + text.offset[1]
				arg_57_9[2] = var_57_6 - frame_margin * 1.5 - (get_text_height + get_text_height_2) + text.offset[2]
				arg_57_9[3] = start_layer + 6 + text.offset[3]
				text_size[1] = arg_57_10[1]
				content.text = var_57_11
				text.text_color[1] = num_2
				text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_57_3, text_pass_data, arg_57_5, arg_57_6, text, content, arg_57_9, text_size, arg_57_11, arg_57_12)

				arg_57_9[1] = num_4 + text_shadow.offset[1]
				arg_57_9[2] = var_57_6 - frame_margin * 1.5 - (get_text_height + get_text_height_2) + text_shadow.offset[2]
				arg_57_9[3] = start_layer + 6 + text_shadow.offset[3]

				UIPasses.text.draw(arg_57_3, text_pass_data, arg_57_5, arg_57_6, text_shadow, content, arg_57_9, text_size, arg_57_11, arg_57_12)
			end

			arg_57_9[1] = var_57_5
			arg_57_9[2] = var_57_6
			arg_57_9[3] = var_57_7

			return num_3
		end
	},
	mutators = {
		setup_data = function (self)
			-- function 58
			local tbl = {
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
				}
			}
			local tbl_2 = {}
			local text

			if not self then
				text = self.text

				if not text then
					-- Nothing
				end
			end

			text = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = "hell_shark",
				font_size = fn(16),
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("font_default", 255)
				}
			}

			::label_58_0::

			tbl_2.text = text

			local text_shadow

			if not self then
				text_shadow = self.text_shadow

				if not text_shadow then
					-- Nothing
				end
			end

			text_shadow = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = "hell_shark",
				font_size = fn(16),
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					1,
					-1,
					-1
				}
			}

			::label_58_1::

			tbl_2.text_shadow = text_shadow

			local icon

			if not self then
				icon = self.icon

				if not icon then
					-- Nothing
				end
			end

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

			::label_58_2::

			tbl_2.icon = icon
			tbl.style = tbl_2

			return tbl
		end,
		draw = function (self, arg_59_1, arg_59_2, arg_59_3, arg_59_4, arg_59_5, arg_59_6, arg_59_7, arg_59_8, arg_59_9, arg_59_10, arg_59_11, arg_59_12, arg_59_13)
			-- function 59
			local data = arg_59_13.data
			local flag = not data and data.mutators and arg_59_13.mutators

			if flag == nil then
				return 0
			end

			local num_2 = 255 * arg_59_4.alpha_multiplier
			local num_3, num_4 = 20, 20
			local start_layer = arg_59_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local var_59_9 = arg_59_9[1]
			local var_59_10 = arg_59_9[2]
			local var_59_11 = arg_59_9[3]

			arg_59_9[1] = arg_59_9[1] + frame_margin
			arg_59_9[2] = arg_59_9[2] - num_3
			arg_59_9[3] = start_layer + 2

			local num_5 = 10
			local ipairs

			if not arg_59_2 then
				ipairs = ipairs

				if not ipairs then
					-- Nothing
				end
			end

			ipairs = ripairs

			::label_59_0::

			for iter_59_0, iter_59_1 in ipairs(flag) do
				local var_59_14 = MutatorTemplates[iter_59_1]
				local display_name = var_59_14.display_name
				local description = var_59_14.description
				local icon = var_59_14.icon
				local str = "mutator_text_" .. iter_59_0
				local text = style.text
				local text_shadow = style.text_shadow
				local text_pass_data = self.text_pass_data

				text_pass_data.text_id = str

				local var_59_22 = Localize(display_name)
				local var_59_23 = Localize(description)
				local icon_pass_definition = self.icon_pass_definition
				local icon_pass_data = self.icon_pass_data
				local icon_2 = self.style.icon
				local icon_size = self.icon_size

				content.icon = icon or self.default_icon

				local str_2 = var_59_22 .. "\n" .. var_59_23
				local text_size = self.text_size

				text_size[1] = arg_59_10[1] - frame_margin * 3 - icon_size[1]
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_59_3, text_size, text, str_2)

				text_size[2] = get_text_height

				local var_59_31 = arg_59_9[1]
				local var_59_32 = arg_59_9[2]

				content[str] = str_2

				if not arg_59_1 then
					icon_2.color[1] = num_2
					arg_59_9[1] = var_59_31
					arg_59_9[2] = var_59_32 - icon_size[2]

					UIPasses.texture.draw(arg_59_3, icon_pass_data, arg_59_5, icon_pass_definition, icon_2, content, arg_59_9, icon_size, arg_59_11, arg_59_12)

					text_shadow.text_color[1] = num_2
					arg_59_9[1] = var_59_31 + icon_size[1] + frame_margin + text_shadow.offset[1]
					arg_59_9[2] = var_59_32 - get_text_height + text_shadow.offset[2]
					arg_59_9[3] = start_layer + 2 + text_shadow.offset[3]

					UIPasses.text.draw(arg_59_3, text_pass_data, arg_59_5, arg_59_6, text_shadow, content, arg_59_9, self.text_size, arg_59_11, arg_59_12)

					text.text_color[1] = num_2

					local line_colors = text.line_colors

					line_colors[1][1] = num_2
					line_colors[2][1] = num_2
					arg_59_9[1] = var_59_31 + icon_size[1] + frame_margin
					arg_59_9[2] = var_59_32 - get_text_height
					arg_59_9[3] = start_layer + 2

					UIPasses.text.draw(arg_59_3, text_pass_data, arg_59_5, arg_59_6, text, content, arg_59_9, self.text_size, arg_59_11, arg_59_12)
				end

				num_3 = num_3 + get_text_height

				if iter_59_0 ~= #flag then
					num_3 = num_3 + num_5
					arg_59_9[2] = var_59_32 - (get_text_height + num_5)
					arg_59_9[1] = var_59_31
				end
			end

			arg_59_9[1] = var_59_9
			arg_59_9[2] = var_59_10
			arg_59_9[3] = var_59_11

			return num_3 + num_4
		end
	},
	deed_rewards = {
		setup_data = function ()
			-- function 60
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
						font_size = fn(28),
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
						font_size = fn(28),
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
		draw = function (self, arg_61_1, arg_61_2, arg_61_3, arg_61_4, arg_61_5, arg_61_6, arg_61_7, arg_61_8, arg_61_9, arg_61_10, arg_61_11, arg_61_12, arg_61_13)
			-- function 61
			local num_2 = 255 * arg_61_4.alpha_multiplier
			local start_layer = arg_61_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local data = arg_61_13.data

			if data.item_type ~= "deed" then
				return 0
			end

			local style = self.style
			local content = self.content
			local var_61_6 = arg_61_9[1]
			local var_61_7 = arg_61_9[2]
			local var_61_8 = arg_61_9[3]
			local num_3 = frame_margin * 4
			local var_61_10 = Localize("deed_reward_title")
			local title_text = style.title_text
			local title_text_shadow = style.title_text_shadow
			local text_pass_data = self.text_pass_data
			local text_size = self.text_size

			text_size[1] = arg_61_10[1] - frame_margin * 2
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_61_3, text_size, title_text, var_61_10)

			text_size[2] = get_text_height

			local divider_size = self.divider_size
			local item_size = self.item_size

			if not arg_61_1 then
				arg_61_9[1] = arg_61_9[1]

				local var_61_18 = arg_61_9[1]
				local num_4 = arg_61_9[2] - num_3

				arg_61_9[1] = var_61_18 + title_text.offset[1]
				arg_61_9[2] = num_4 + title_text.offset[2]
				arg_61_9[3] = start_layer + 6 + title_text.offset[3]
				text_size[1] = arg_61_10[1]
				content.text = var_61_10
				title_text.text_color[1] = num_2
				title_text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_61_3, text_pass_data, arg_61_5, arg_61_6, title_text, content, arg_61_9, text_size, arg_61_11, arg_61_12)

				arg_61_9[1] = var_61_18 + title_text_shadow.offset[1]
				arg_61_9[2] = num_4 + title_text.offset[2]
				arg_61_9[3] = start_layer + 6 + title_text_shadow.offset[3]

				UIPasses.text.draw(arg_61_3, text_pass_data, arg_61_5, arg_61_6, title_text_shadow, content, arg_61_9, text_size, arg_61_11, arg_61_12)

				local divider_texture = content.divider_texture
				local color = style.divider.color

				color[1] = num_2
				arg_61_9[3] = start_layer + 6
				arg_61_9[2] = num_4 - get_text_height
				arg_61_9[1] = var_61_18 + (arg_61_10[1] / 2 - divider_size[1] / 2)

				UIRenderer.draw_texture(arg_61_3, divider_texture, arg_61_9, divider_size, color)

				local rewards = data.rewards
				local count = #rewards
				local num_5 = 20
				local num_6 = -(count - 1) * (40 + num_5 * 0.5)

				for i = 1, count do
					local var_61_26 = rewards[i]
					local var_61_27 = ItemMasterList[var_61_26]
					local flag = var_61_27.inventory_icon or self.default_item_texture
					local item = style.item
					local color_2 = item.color

					color_2[1] = num_2

					local num_7 = var_61_18 + (arg_61_10[1] / 2 - item_size[1] / 2) + num_6
					local num_8 = num_4 - (get_text_height + item_size[2] + divider_size[2] / 2)

					arg_61_9[1] = num_7
					arg_61_9[2] = num_8
					arg_61_9[3] = start_layer + 4

					local hotspot = self.hotspot

					UIPasses.hover.draw(arg_61_3, text_pass_data, arg_61_5, arg_61_6, item, hotspot, arg_61_9, item_size, arg_61_11, arg_61_12)

					if not hotspot.is_hover then
						if not content.item then
							content.item = {
								data = var_61_27
							}
						else
							content.item.data = var_61_27
						end

						local tooltip_pass_definition = self.tooltip_pass_definition

						if not self.tooltip_pass_data then
							self.tooltip_pass_data = UIPasses.item_tooltip.init(tooltip_pass_definition, content, style)
						end

						local tooltip_pass_data = self.tooltip_pass_data

						UIPasses.item_tooltip.draw(arg_61_3, tooltip_pass_data, arg_61_5, tooltip_pass_definition, style, content, arg_61_9, item_size, arg_61_11, arg_61_12)
					end

					arg_61_9[2] = num_8
					arg_61_9[1] = num_7
					arg_61_9[3] = start_layer + 4

					UIRenderer.draw_texture(arg_61_3, flag, arg_61_9, item_size, color_2)

					local default_item_frame_texture = self.default_item_frame_texture

					arg_61_9[3] = start_layer + 5

					UIRenderer.draw_texture(arg_61_3, default_item_frame_texture, arg_61_9, item_size, color_2)

					num_6 = num_6 + item_size[1] + num_5
				end
			end

			local num_9 = num_3 + get_text_height + divider_size[2] + item_size[2]

			arg_61_9[1] = var_61_6
			arg_61_9[2] = var_61_7
			arg_61_9[3] = var_61_8

			return num_9
		end
	},
	event_mission = {
		setup_data = function ()
			-- function 62
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
						font_size = fn(28),
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
						font_size = fn(28),
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
						font_size = fn(18),
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
						font_size = fn(18),
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
		draw = function (self, arg_63_1, arg_63_2, arg_63_3, arg_63_4, arg_63_5, arg_63_6, arg_63_7, arg_63_8, arg_63_9, arg_63_10, arg_63_11, arg_63_12, arg_63_13)
			-- function 63
			local num_2 = 255 * arg_63_4.alpha_multiplier
			local start_layer = arg_63_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local var_63_5 = arg_63_9[1]
			local var_63_6 = arg_63_9[2]
			local var_63_7 = arg_63_9[3]
			local var_63_8 = Localize("start_game_window_mission")
			local var_63_9
			local level_key = arg_63_13.level_key

			if not level_key then
				local display_name = LevelSettings[level_key].display_name

				var_63_9 = Localize(display_name)
			else
				var_63_9 = Localize("random_level")
			end

			local text = style.text
			local text_shadow = style.text_shadow
			local title_text = style.title_text
			local title_text_shadow = style.title_text_shadow
			local text_pass_data = self.text_pass_data
			local text_size = self.text_size

			text_size[1] = arg_63_10[1] - frame_margin * 2
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_63_3, text_size, title_text, var_63_8)
			local get_text_height_2 = UIUtils.get_text_height(arg_63_3, text_size, text, var_63_9)
			local num_3 = get_text_height + get_text_height_2

			text_size[2] = num_3

			if not arg_63_1 then
				local num_4 = arg_63_9[1] + frame_margin

				arg_63_9[1] = num_4 + title_text.offset[1]
				arg_63_9[2] = var_63_6 - frame_margin - get_text_height + title_text.offset[2]
				arg_63_9[3] = start_layer + 6 + title_text.offset[3]
				text_size[1] = arg_63_10[1]
				content.text = var_63_8
				title_text.text_color[1] = num_2
				title_text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_63_3, text_pass_data, arg_63_5, arg_63_6, title_text, content, arg_63_9, text_size, arg_63_11, arg_63_12)

				arg_63_9[1] = num_4 + title_text_shadow.offset[1]
				arg_63_9[2] = var_63_6 - frame_margin - get_text_height + title_text_shadow.offset[2]
				arg_63_9[3] = start_layer + 6 + title_text_shadow.offset[3]

				UIPasses.text.draw(arg_63_3, text_pass_data, arg_63_5, arg_63_6, title_text_shadow, content, arg_63_9, text_size, arg_63_11, arg_63_12)

				arg_63_9[1] = num_4 + text.offset[1]
				arg_63_9[2] = var_63_6 - frame_margin * 1.5 - (get_text_height + get_text_height_2) + text.offset[2]
				arg_63_9[3] = start_layer + 6 + text.offset[3]
				text_size[1] = arg_63_10[1]
				content.text = var_63_9
				text.text_color[1] = num_2
				text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_63_3, text_pass_data, arg_63_5, arg_63_6, text, content, arg_63_9, text_size, arg_63_11, arg_63_12)

				arg_63_9[1] = num_4 + text_shadow.offset[1]
				arg_63_9[2] = var_63_6 - frame_margin * 1.5 - (get_text_height + get_text_height_2) + text_shadow.offset[2]
				arg_63_9[3] = start_layer + 6 + text_shadow.offset[3]

				UIPasses.text.draw(arg_63_3, text_pass_data, arg_63_5, arg_63_6, text_shadow, content, arg_63_9, text_size, arg_63_11, arg_63_12)
			end

			arg_63_9[1] = var_63_5
			arg_63_9[2] = var_63_6
			arg_63_9[3] = var_63_7

			return num_3
		end
	},
	loot_chest_description = {
		setup_data = function ()
			-- function 64
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
						font_size = fn(20),
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
						font_size = fn(20),
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
		draw = function (self, arg_65_1, arg_65_2, arg_65_3, arg_65_4, arg_65_5, arg_65_6, arg_65_7, arg_65_8, arg_65_9, arg_65_10, arg_65_11, arg_65_12, arg_65_13)
			-- function 65
			local num_2 = 255 * arg_65_4.alpha_multiplier
			local start_layer = arg_65_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			if arg_65_13.data.item_type ~= "loot_chest" then
				return 0
			end

			local style = self.style
			local content = self.content
			local var_65_5 = arg_65_9[1]
			local var_65_6 = arg_65_9[2]
			local var_65_7 = arg_65_9[3]
			local var_65_8 = frame_margin
			local prefix = content.prefix
			local title_text = style.title_text
			local title_text_shadow = style.title_text_shadow
			local text_pass_data = self.text_pass_data
			local text_size = self.text_size
			local num_3 = arg_65_10[1] - frame_margin * 2

			text_size[1] = num_3
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_65_3, text_size, title_text, prefix)
			local num_4

			text_size[2], num_4 = get_text_height, var_65_8 + get_text_height

			if not arg_65_1 then
				local num_5 = arg_65_9[1] + frame_margin
				local num_6 = arg_65_9[2] - num_4 + frame_margin * 2

				arg_65_9[1] = num_5 + title_text.offset[1]
				arg_65_9[2] = num_6 - frame_margin + title_text.offset[2]
				arg_65_9[3] = start_layer + 6 + title_text.offset[3]
				text_size[1] = num_3
				content.text = prefix
				title_text.text_color[1] = num_2
				title_text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_65_3, text_pass_data, arg_65_5, arg_65_6, title_text, content, arg_65_9, text_size, arg_65_11, arg_65_12)

				arg_65_9[1] = num_5 + title_text_shadow.offset[1]
				arg_65_9[2] = num_6 - frame_margin + title_text_shadow.offset[2]
				arg_65_9[3] = start_layer + 6 + title_text_shadow.offset[3]

				UIPasses.text.draw(arg_65_3, text_pass_data, arg_65_5, arg_65_6, title_text_shadow, content, arg_65_9, text_size, arg_65_11, arg_65_12)
			end

			arg_65_9[1] = var_65_5
			arg_65_9[2] = var_65_6
			arg_65_9[3] = var_65_7

			return num_4
		end
	},
	loot_chest_difficulty = {
		setup_data = function ()
			-- function 66
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
						font_size = fn(20),
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
						font_size = fn(20),
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
		draw = function (self, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5, arg_67_6, arg_67_7, arg_67_8, arg_67_9, arg_67_10, arg_67_11, arg_67_12, arg_67_13)
			-- function 67
			local num_2 = 255 * arg_67_4.alpha_multiplier
			local start_layer = arg_67_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local data = arg_67_13.data

			if data.item_type ~= "loot_chest" then
				return 0
			end

			if not Managers.backend:get_interface("loot"):get_rarity_tables()[data.name] then
				self.style.title_text.text_color = Colors.get_color_table_with_alpha("font_default", 255)
			else
				self.style.title_text.text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255)
			end

			local style = self.style
			local content = self.content
			local var_67_6 = arg_67_9[1]
			local var_67_7 = arg_67_9[2]
			local var_67_8 = arg_67_9[3]
			local var_67_9 = frame_margin
			local chest_categories = data.chest_categories

			if not chest_categories then
				return 0
			end

			local select_array = table.select_array(chest_categories, function (arg_68_0, arg_68_1)
				-- function 68
				local var_68_0 = DifficultySettings[arg_68_1]

				var_68_0 = not var_68_0 and Localize(DifficultySettings[arg_68_1].display_name)

				return var_68_0
			end)

			if not table.is_empty(select_array) then
				return 0
			end

			local concat = table.concat(select_array, ", ")
			local str = content.prefix .. concat
			local title_text = style.title_text
			local title_text_shadow = style.title_text_shadow
			local text_pass_data = self.text_pass_data
			local text_size = self.text_size
			local num_3 = arg_67_10[1] - frame_margin * 2

			text_size[1] = num_3
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_67_3, text_size, title_text, str)
			local num_4

			text_size[2], num_4 = get_text_height, var_67_9 + get_text_height

			if not arg_67_1 then
				local num_5 = arg_67_9[1] + frame_margin
				local num_6 = arg_67_9[2] - num_4 + frame_margin * 2

				arg_67_9[1] = num_5 + title_text.offset[1]
				arg_67_9[2] = num_6 - frame_margin + title_text.offset[2]
				arg_67_9[3] = start_layer + 6 + title_text.offset[3]
				text_size[1] = num_3
				content.text = str
				title_text.text_color[1] = num_2
				title_text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_67_3, text_pass_data, arg_67_5, arg_67_6, title_text, content, arg_67_9, text_size, arg_67_11, arg_67_12)

				arg_67_9[1] = num_5 + title_text_shadow.offset[1]
				arg_67_9[2] = num_6 - frame_margin + title_text_shadow.offset[2]
				arg_67_9[3] = start_layer + 6 + title_text_shadow.offset[3]

				UIPasses.text.draw(arg_67_3, text_pass_data, arg_67_5, arg_67_6, title_text_shadow, content, arg_67_9, text_size, arg_67_11, arg_67_12)
			end

			arg_67_9[1] = var_67_6
			arg_67_9[2] = var_67_7
			arg_67_9[3] = var_67_8

			return num_4
		end
	},
	loot_chest_power_range = {
		setup_data = function ()
			-- function 69
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
						font_size = fn(20),
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
						font_size = fn(20),
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
		draw = function (self, arg_70_1, arg_70_2, arg_70_3, arg_70_4, arg_70_5, arg_70_6, arg_70_7, arg_70_8, arg_70_9, arg_70_10, arg_70_11, arg_70_12, arg_70_13)
			-- function 70
			local num_2 = 255 * arg_70_4.alpha_multiplier
			local start_layer = arg_70_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local data = arg_70_13.data

			if data.item_type ~= "loot_chest" then
				return 0
			end

			local style = self.style
			local content = self.content
			local var_70_6 = arg_70_9[1]
			local var_70_7 = arg_70_9[2]
			local var_70_8 = arg_70_9[3]
			local var_70_9 = frame_margin

			if not data.power_level_key then
				return 0
			end

			local get_interface = Managers.backend:get_interface("loot")
			local get_rarity_tables = get_interface:get_rarity_tables()
			local name = data.name

			if not get_rarity_tables[name] then
				style.title_text.text_color = Colors.get_color_table_with_alpha("font_default", 255)
			else
				style.title_text.text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255)
			end

			local get_power_level_settings = get_interface:get_power_level_settings()
			local var_70_14 = get_power_level_settings.power_level_tables[name]
			local var_70_15 = get_power_level_settings.pivots[var_70_14]

			if not var_70_15 then
				return 0
			end

			local var_70_16
			local achievement_id = arg_70_8.achievement_id

			if not achievement_id then
				if not AchievementManager.STORE_COMPLETED_LEVEL then
					if not (not arg_70_8.completed and arg_70_8.claimed) then
						local get_achievement_reward_level = Managers.backend:get_interface("statistics"):get_achievement_reward_level(achievement_id)

						var_70_16 = not get_achievement_reward_level and math.min(get_achievement_reward_level, LootChestData.LEVEL_USED_FOR_POOL_LEVELS)
					else
						return 0
					end
				elseif not arg_70_8.claimed then
					return 0
				end
			elseif not arg_70_8.difficulty_key then
				var_70_16 = ExperienceSettings.get_reward_level()
			else
				var_70_16 = get_interface:get_highest_chest_level(name)
			end

			var_70_16 = var_70_16 or ExperienceSettings.get_reward_level()

			local calculate_power_level, var_70_20, var_70_21 = LootChestData.calculate_power_level(var_70_16, var_70_15)
			local min = math.min(var_70_20, var_70_21)
			local chest_tier = data.chest_tier

			chest_tier = chest_tier or 1

			local bonus_min_power_level_per_tier = get_power_level_settings.bonus_min_power_level_per_tier
			local min_2 = math.min(calculate_power_level + (chest_tier - 1) * bonus_min_power_level_per_tier, min)
			local format = string.format("%s: %d - %d", content.prefix, math.round(min_2), math.round(min))
			local title_text = style.title_text
			local title_text_shadow = style.title_text_shadow
			local text_pass_data = self.text_pass_data
			local text_size = self.text_size
			local num_3 = arg_70_10[1] - frame_margin * 2

			text_size[1] = num_3
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_70_3, text_size, title_text, format)
			local num_4

			text_size[2], num_4 = get_text_height, var_70_9 + get_text_height

			if not arg_70_1 then
				local num_5 = arg_70_9[1] + frame_margin
				local num_6 = arg_70_9[2] - num_4 + frame_margin * 2

				arg_70_9[1] = num_5 + title_text.offset[1]
				arg_70_9[2] = num_6 - frame_margin + title_text.offset[2]
				arg_70_9[3] = start_layer + 6 + title_text.offset[3]
				text_size[1] = num_3
				content.text = format
				title_text.text_color[1] = num_2
				title_text_shadow.text_color[1] = num_2

				UIPasses.text.draw(arg_70_3, text_pass_data, arg_70_5, arg_70_6, title_text, content, arg_70_9, text_size, arg_70_11, arg_70_12)

				arg_70_9[1] = num_5 + title_text_shadow.offset[1]
				arg_70_9[2] = num_6 - frame_margin + title_text_shadow.offset[2]
				arg_70_9[3] = start_layer + 6 + title_text_shadow.offset[3]

				UIPasses.text.draw(arg_70_3, text_pass_data, arg_70_5, arg_70_6, title_text_shadow, content, arg_70_9, text_size, arg_70_11, arg_70_12)
			end

			arg_70_9[1] = var_70_6
			arg_70_9[2] = var_70_7
			arg_70_9[3] = var_70_8

			return num_4
		end
	},
	item_rarity_rate = {
		setup_data = function ()
			-- function 71
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
						font_size = fn(20),
						text_color = Colors.get_color_table_with_alpha("font_default", 255),
						offset = {
							0,
							0,
							0
						}
					}
				},
				format_rarity_rate = function (self, arg_72_1)
					-- function 72
					local var_72_0 = self[arg_72_1]
					local var_72_1
					local flag

					flag = (var_72_0 ~= 0 or not "0" or not (var_72_0 < 1)) and (not "<1" or math.round(var_72_0))

					local var_72_3 = Colors.color_definitions[arg_72_1]

					return string.format("{#color(%d,%d,%d,%d)}%s%%{#reset()}", var_72_3[2], var_72_3[3], var_72_3[4], var_72_3[1], flag)
				end
			}
		end,
		draw = function (self, arg_73_1, arg_73_2, arg_73_3, arg_73_4, arg_73_5, arg_73_6, arg_73_7, arg_73_8, arg_73_9, arg_73_10, arg_73_11, arg_73_12, arg_73_13)
			-- function 73
			local data = arg_73_13.data

			if data.item_type ~= "loot_chest" then
				return 0
			end

			local name = data.name

			if not name then
				return 0
			end

			local num_2 = 255 * arg_73_4.alpha_multiplier
			local start_layer = arg_73_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local var_73_7 = arg_73_9[1]
			local var_73_8 = arg_73_9[2]
			local var_73_9 = arg_73_9[3]
			local var_73_10 = frame_margin
			local var_73_11 = Managers.backend:get_interface("loot"):get_formatted_rarity_tables()[name]

			if not var_73_11 then
				return 0
			end

			local format_rarity_rate = self.format_rarity_rate(var_73_11, "plentiful")
			local format_rarity_rate_2 = self.format_rarity_rate(var_73_11, "common")
			local format_rarity_rate_3 = self.format_rarity_rate(var_73_11, "rare")
			local format_rarity_rate_4 = self.format_rarity_rate(var_73_11, "exotic")
			local format_rarity_rate_5 = self.format_rarity_rate(var_73_11, "unique")
			local format = string.format("%s | %s | %s | %s | %s", format_rarity_rate, format_rarity_rate_2, format_rarity_rate_3, format_rarity_rate_4, format_rarity_rate_5)
			local str = content.prefix .. format
			local title_text = style.title_text
			local text_pass_data = self.text_pass_data
			local text_size = self.text_size
			local num_3 = arg_73_10[1] - frame_margin * 2

			text_size[1] = num_3
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_73_3, text_size, title_text, str)
			local num_4

			text_size[2], num_4 = get_text_height, var_73_10 + get_text_height

			if not arg_73_1 then
				local num_5 = arg_73_9[1] + frame_margin
				local num_6 = arg_73_9[2] - num_4 + frame_margin * 2

				arg_73_9[1] = num_5 + title_text.offset[1]
				arg_73_9[2] = num_6 - frame_margin + title_text.offset[2]
				arg_73_9[3] = start_layer + 6 + title_text.offset[3]
				text_size[1] = num_3
				content.text = str
				title_text.text_color[1] = num_2

				UIPasses.text.draw(arg_73_3, text_pass_data, arg_73_5, arg_73_6, title_text, content, arg_73_9, text_size, arg_73_11, arg_73_12)
			end

			arg_73_9[1] = var_73_7
			arg_73_9[2] = var_73_8
			arg_73_9[3] = var_73_9

			return num_4
		end
	},
	item_information_text = {
		setup_data = function ()
			-- function 74
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
						font_size = fn(20),
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
						font_size = fn(20),
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
		draw = function (self, arg_75_1, arg_75_2, arg_75_3, arg_75_4, arg_75_5, arg_75_6, arg_75_7, arg_75_8, arg_75_9, arg_75_10, arg_75_11, arg_75_12, arg_75_13)
			-- function 75
			local num_2 = 255 * arg_75_4.alpha_multiplier
			local start_layer = arg_75_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local data = arg_75_13.data
			local item_type = data.item_type

			if item_type == "crafting_material" or item_type == "weapon_skin" or item_type == "keep_decoration_painting" or not CosmeticUtils.is_cosmetic_item(item_type) then
				local style = self.style
				local content = self.content
				local var_75_7 = arg_75_9[1]
				local var_75_8 = arg_75_9[2]
				local var_75_9 = arg_75_9[3]
				local var_75_10 = frame_margin
				local information_text = data.information_text
				local var_75_12

				if not information_text then
					var_75_12 = Localize(information_text)

					if not var_75_12 then
						-- Nothing
					end
				end

				var_75_12 = "n/a"

				::label_75_0::

				local title_text = style.title_text
				local title_text_shadow = style.title_text_shadow
				local text_pass_data = self.text_pass_data
				local text_size = self.text_size
				local num_3 = arg_75_10[1] - frame_margin * 2

				text_size[1] = num_3
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_75_3, text_size, title_text, var_75_12)
				local num_4 = var_75_10 + get_text_height

				text_size[2] = get_text_height

				if not arg_75_1 then
					local num_5 = arg_75_9[1] + frame_margin
					local num_6 = arg_75_9[2] - num_4 + frame_margin * 2

					arg_75_9[1] = num_5 + title_text.offset[1]
					arg_75_9[2] = num_6 - frame_margin + title_text.offset[2]
					arg_75_9[3] = start_layer + 6 + title_text.offset[3]
					text_size[1] = num_3
					content.text = var_75_12
					title_text.text_color[1] = num_2
					title_text_shadow.text_color[1] = num_2

					UIPasses.text.draw(arg_75_3, text_pass_data, arg_75_5, arg_75_6, title_text, content, arg_75_9, text_size, arg_75_11, arg_75_12)

					arg_75_9[1] = num_5 + title_text_shadow.offset[1]
					arg_75_9[2] = num_6 - frame_margin + title_text_shadow.offset[2]
					arg_75_9[3] = start_layer + 6 + title_text_shadow.offset[3]

					UIPasses.text.draw(arg_75_3, text_pass_data, arg_75_5, arg_75_6, title_text_shadow, content, arg_75_9, text_size, arg_75_11, arg_75_12)
				end

				arg_75_9[1] = var_75_7
				arg_75_9[2] = var_75_8
				arg_75_9[3] = var_75_9

				return num_4
			end

			return 0
		end
	},
	weapon_skin_title = {
		setup_data = function ()
			-- function 76
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("promo", 255)
					}
				}
			}
		end,
		draw = function (self, arg_77_1, arg_77_2, arg_77_3, arg_77_4, arg_77_5, arg_77_6, arg_77_7, arg_77_8, arg_77_9, arg_77_10, arg_77_11, arg_77_12, arg_77_13)
			-- function 77
			if not Development.parameter("enable_detailed_tooltips") and arg_77_11:get("item_compare") and not arg_77_11:get("item_detail") then
				local slot_type = arg_77_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			end

			local num_2 = 255 * arg_77_4.alpha_multiplier
			local start_layer = arg_77_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local content = self.content
			local style = self.style
			local data = arg_77_13.data
			local skin = arg_77_13.skin

			if data.item_type ~= "weapon_skin" then
				return 0
			end

			if not skin then
				local matching_weapon_skin_item_key = WeaponSkins.matching_weapon_skin_item_key(skin)
				local flag = not matching_weapon_skin_item_key and string.match(matching_weapon_skin_item_key, "^([%w_]+)_skin$")
				local var_77_10 = rawget(ItemMasterList, flag)
				local item_type

				if not var_77_10 then
					item_type = var_77_10.item_type

					if not item_type then
						-- Nothing
					end
				end

				item_type = "lb_unknown"

				::label_77_0::

				content.text = Localize(item_type) .. content.sufix_text

				local var_77_12 = arg_77_9[1]
				local var_77_13 = arg_77_9[2]
				local var_77_14 = arg_77_9[3]

				arg_77_9[3] = start_layer + 5

				local text = style.text
				local text_pass_data = self.text_pass_data
				local text_size = self.text_size

				text_size[1] = arg_77_10[1] - frame_margin * 2
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_77_3, text_size, text, content.text)

				text_size[2] = get_text_height

				if not arg_77_1 then
					arg_77_9[1] = var_77_12 + frame_margin
					arg_77_9[2] = arg_77_9[2] - get_text_height
					text.text_color[1] = num_2

					UIPasses.text.draw(arg_77_3, text_pass_data, arg_77_5, arg_77_6, text, content, arg_77_9, text_size, arg_77_11, arg_77_12)
				end

				arg_77_9[1] = var_77_12
				arg_77_9[2] = var_77_13
				arg_77_9[3] = var_77_14

				return get_text_height
			else
				return 0
			end
		end
	},
	console_keywords = {
		setup_data = function ()
			-- function 78
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
						font_size = fn(16),
						text_color = Colors.get_color_table_with_alpha("forest_green", 255)
					}
				}
			}
		end,
		draw = function (self, arg_79_1, arg_79_2, arg_79_3, arg_79_4, arg_79_5, arg_79_6, arg_79_7, arg_79_8, arg_79_9, arg_79_10, arg_79_11, arg_79_12, arg_79_13)
			-- function 79
			if not Development.parameter("enable_detailed_tooltips") and arg_79_11:get("item_compare") and not arg_79_11:get("item_detail") then
				local slot_type = arg_79_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			end

			local num_2 = 255 * arg_79_4.alpha_multiplier
			local start_layer = arg_79_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local content = self.content
			local style = self.style
			local backend_id = arg_79_13.backend_id
			local data = arg_79_13.data
			local slot_type_2 = data.slot_type

			if not (slot_type_2 == "melee" or slot_type_2 == "ranged") then
				return 0
			end

			local tooltip_keywords = BackendUtils.get_item_template(data, backend_id).tooltip_keywords

			if not tooltip_keywords then
				local str = ""
				local count = #tooltip_keywords

				for i, v in ipairs(tooltip_keywords) do
					str = str .. Localize(v)
					count = count - 1

					if count > 0 then
						str = str .. ", "
					end
				end

				content.text = str

				local var_79_12 = arg_79_9[1]
				local var_79_13 = arg_79_9[2]
				local var_79_14 = arg_79_9[3]

				arg_79_9[3] = start_layer + 5

				local text = style.text
				local text_pass_data = self.text_pass_data
				local text_size = self.text_size

				text_size[1] = arg_79_10[1] - frame_margin * 2
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_79_3, text_size, text, str)

				text_size[2] = get_text_height

				local num_3 = get_text_height + frame_margin * 0.5

				if not arg_79_1 then
					arg_79_9[1] = var_79_12
					arg_79_9[2] = var_79_13
					arg_79_9[1] = var_79_12 + frame_margin
					arg_79_9[2] = arg_79_9[2] - num_3 + frame_margin
					text.text_color[1] = num_2

					UIPasses.text.draw(arg_79_3, text_pass_data, arg_79_5, arg_79_6, text, content, arg_79_9, text_size, arg_79_11, arg_79_12)
				end

				arg_79_9[1] = var_79_12
				arg_79_9[2] = var_79_13
				arg_79_9[3] = var_79_14

				return num_3
			end

			return 0
		end
	},
	keywords = {
		setup_data = function ()
			-- function 80
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
						font_size = fn(16),
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
		draw = function (self, arg_81_1, arg_81_2, arg_81_3, arg_81_4, arg_81_5, arg_81_6, arg_81_7, arg_81_8, arg_81_9, arg_81_10, arg_81_11, arg_81_12, arg_81_13)
			-- function 81
			if not Development.parameter("enable_detailed_tooltips") and arg_81_11:get("item_compare") and not arg_81_11:get("item_detail") then
				local slot_type = arg_81_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			end

			local num_2 = 255 * arg_81_4.alpha_multiplier
			local start_layer = arg_81_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local content = self.content
			local style = self.style
			local backend_id = arg_81_13.backend_id
			local data = arg_81_13.data
			local slot_type_2 = data.slot_type

			if not (slot_type_2 == "melee" or slot_type_2 == "ranged") then
				return 0
			end

			local tooltip_keywords = BackendUtils.get_item_template(data, backend_id).tooltip_keywords

			if not tooltip_keywords then
				local str_2 = ""

				if not arg_81_13.hidden_description then
					local count = #tooltip_keywords

					for i, v in ipairs(tooltip_keywords) do
						str_2 = str_2 .. str
						count = count - 1

						if count > 0 then
							str_2 = str_2 .. ", "
						end
					end
				else
					local count_2 = #tooltip_keywords

					for i_2, v_2 in ipairs(tooltip_keywords) do
						str_2 = str_2 .. Localize(v_2)
						count_2 = count_2 - 1

						if count_2 > 0 then
							str_2 = str_2 .. ", "
						end
					end
				end

				content.text = str_2

				local var_81_13 = arg_81_9[1]
				local var_81_14 = arg_81_9[2]
				local var_81_15 = arg_81_9[3]

				arg_81_9[3] = start_layer + 5

				local text = style.text
				local text_pass_data = self.text_pass_data
				local text_size = self.text_size

				text_size[1] = arg_81_10[1] - frame_margin * 2
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_81_3, text_size, text, str_2)

				text_size[2] = get_text_height

				local num_3 = get_text_height + frame_margin * 0.5

				if not arg_81_1 then
					local background_size = self.background_size
					local color = style.background.color

					color[1] = num_2
					background_size[2] = num_3
					background_size[1] = arg_81_10[1]
					arg_81_9[2] = var_81_14 - background_size[2]
					arg_81_9[3] = start_layer + 3

					UIRenderer.draw_rect(arg_81_3, arg_81_9, background_size, color)

					arg_81_9[1] = var_81_13
					arg_81_9[2] = var_81_14

					local edge_size = self.edge_size

					edge_size[1] = arg_81_10[1]

					local edge = style.edge
					local color_2 = edge.color
					local texture_size = edge.texture_size

					texture_size[1] = arg_81_10[1]

					local edge_texture = content.edge_texture

					color_2[1] = num_2
					arg_81_9[3] = start_layer + 4

					UIRenderer.draw_tiled_texture(arg_81_3, edge_texture, arg_81_9, edge_size, texture_size, color_2)

					local edge_holder = style.edge_holder
					local edge_holder_size = self.edge_holder_size
					local color_3 = edge_holder.color
					local edge_holder_left = content.edge_holder_left
					local edge_holder_right = content.edge_holder_right

					color_3[1] = num_2
					arg_81_9[1] = arg_81_9[1] + 3
					arg_81_9[2] = arg_81_9[2] - 6
					arg_81_9[3] = start_layer + 6

					UIRenderer.draw_texture(arg_81_3, edge_holder_left, arg_81_9, edge_holder_size, color_3)

					arg_81_9[1] = arg_81_9[1] + edge_size[1] - (edge_holder_size[1] + 6)

					UIRenderer.draw_texture(arg_81_3, edge_holder_right, arg_81_9, edge_holder_size, color_3)

					arg_81_9[1] = var_81_13 + frame_margin
					arg_81_9[2] = arg_81_9[2] - num_3 + frame_margin
					text.text_color[1] = num_2

					UIPasses.text.draw(arg_81_3, text_pass_data, arg_81_5, arg_81_6, text, content, arg_81_9, text_size, arg_81_11, arg_81_12)
				end

				arg_81_9[1] = var_81_13
				arg_81_9[2] = var_81_14
				arg_81_9[3] = var_81_15

				return num_3
			end

			return 0
		end
	},
	hero_power_gained = {
		setup_data = function ()
			-- function 82
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					entry_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
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
		draw = function (self, arg_83_1, arg_83_2, arg_83_3, arg_83_4, arg_83_5, arg_83_6, arg_83_7, arg_83_8, arg_83_9, arg_83_10, arg_83_11, arg_83_12)
			-- function 83
			local player = arg_83_4.player
			local var_83_1
			local var_83_2

			if not player then
				var_83_1 = player:profile_display_name()
				var_83_2 = player:career_name()

				if not (not var_83_1 and var_83_2) then
					return 0
				end
			end

			local profile_index = arg_83_8.profile_index
			local career_index = arg_83_8.career_index

			if not profile_index and not career_index then
				local var_83_5 = SPProfiles[profile_index]

				var_83_1 = var_83_5.display_name
				var_83_2 = var_83_5.careers[career_index].name
			end

			local start_layer = arg_83_4.start_layer

			start_layer = start_layer or num

			local num_2 = 0
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local get_total_power_level = BackendUtils.get_total_power_level(var_83_1, var_83_2)
			local presentable_hero_power_level = UIUtils.presentable_hero_power_level(get_total_power_level)
			local get_average_item_power_level = BackendUtils.get_average_item_power_level(var_83_2)
			local get_hero_power_level_from_level = BackendUtils.get_hero_power_level_from_level(var_83_1)
			local power_level_list = content.power_level_list

			power_level_list.hero = math.floor(get_hero_power_level_from_level)
			power_level_list.item = math.floor(get_average_item_power_level)

			local num_3 = 255 * arg_83_4.alpha_multiplier
			local var_83_17 = arg_83_9[1]
			local var_83_18 = arg_83_9[2]
			local var_83_19 = arg_83_9[3]
			local num_4 = 0

			arg_83_9[3] = start_layer + 2
			arg_83_9[1] = arg_83_9[1] + frame_margin

			local property_title = style.property_title
			local title_text_pass_data = self.title_text_pass_data
			local title = content.title
			local text_size = self.text_size

			text_size[1] = arg_83_10[1] - (frame_margin * 2 + frame_margin)
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_83_3, text_size, property_title, title)

			text_size[2] = get_text_height
			arg_83_9[2] = arg_83_9[2] - get_text_height

			local num_5 = num_4 + get_text_height

			if not arg_83_1 then
				property_title.text_color[1] = num_3

				UIPasses.text.draw(arg_83_3, title_text_pass_data, arg_83_5, arg_83_6, property_title, content, arg_83_9, text_size, arg_83_11, arg_83_12)
			end

			local num_6 = num_5 + frame_margin * 0.5

			arg_83_9[2] = arg_83_9[2] - frame_margin * 0.5

			local num_7 = 1
			local entry_list = content.entry_list

			for i, v in ipairs(entry_list) do
				local var_83_30 = power_level_list[v.power_level_key]
				local str = v.text .. " "
				local var_83_32 = tostring(var_83_30)
				local str_2 = str .. var_83_32
				local length = Utf8.length(var_83_32)

				length = length or 0

				local length_2 = Utf8.length(str)

				length_2 = length_2 or 0

				local entry_text = style.entry_text
				local color_override_table = entry_text.color_override_table

				color_override_table.start_index = length_2 + 1
				color_override_table.end_index = length_2 + length
				entry_text.color_override[1] = color_override_table

				local str_3 = "entry_" .. num_7
				local text_pass_data = self.text_pass_data

				text_pass_data.text_id = str_3

				local text_size_2 = self.text_size

				text_size_2[2] = 0

				local get_text_height_2 = UIUtils.get_text_height(arg_83_3, text_size_2, entry_text, str_2)

				text_size_2[2] = get_text_height_2
				arg_83_9[2] = arg_83_9[2] - get_text_height_2

				local var_83_42 = arg_83_9[2]

				content[str_3] = str_2

				if not arg_83_1 then
					local icon_pass_definition = self.icon_pass_definition
					local icon_pass_data = self.icon_pass_data
					local icon = style.icon
					local icon_size = self.icon_size

					icon.color[1] = num_3
					arg_83_9[2] = arg_83_9[2] + get_text_height_2 / 2 - icon_size[2] / 2 - 2

					UIPasses.texture.draw(arg_83_3, icon_pass_data, arg_83_5, icon_pass_definition, icon, content, arg_83_9, icon_size, arg_83_11, arg_83_12)

					arg_83_9[2] = var_83_42
					arg_83_9[1] = arg_83_9[1] + icon_size[1]
					entry_text.text_color[1] = num_3

					UIPasses.text.draw(arg_83_3, text_pass_data, arg_83_5, arg_83_6, entry_text, content, arg_83_9, self.text_size, arg_83_11, arg_83_12)

					arg_83_9[1] = arg_83_9[1] - icon_size[1]
				end

				num_6 = num_6 + get_text_height_2
				arg_83_9[2] = var_83_42
			end

			local num_8 = num_7 + 1
			local num_9 = num_6 + num_2

			arg_83_9[1] = var_83_17
			arg_83_9[2] = var_83_18
			arg_83_9[3] = var_83_19

			return num_9
		end
	},
	hero_power_perks = {
		setup_data = function ()
			-- function 84
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					entry_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
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
		draw = function (self, arg_85_1, arg_85_2, arg_85_3, arg_85_4, arg_85_5, arg_85_6, arg_85_7, arg_85_8, arg_85_9, arg_85_10, arg_85_11, arg_85_12)
			-- function 85
			local start_layer = arg_85_4.start_layer

			start_layer = start_layer or num

			local num_2 = 0
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local num_3 = 255 * arg_85_4.alpha_multiplier
			local var_85_6 = arg_85_9[1]
			local var_85_7 = arg_85_9[2]
			local var_85_8 = arg_85_9[3]
			local num_4 = 0

			arg_85_9[3] = start_layer + 2
			arg_85_9[2] = arg_85_9[2]
			arg_85_9[1] = arg_85_9[1] + frame_margin

			local property_title = style.property_title
			local title_text_pass_data = self.title_text_pass_data
			local title = content.title
			local text_size = self.text_size

			text_size[1] = arg_85_10[1] - (frame_margin * 2 + frame_margin)
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_85_3, text_size, property_title, title)

			text_size[2] = get_text_height
			arg_85_9[2] = arg_85_9[2] - get_text_height

			local num_5 = num_4 + get_text_height

			if not arg_85_1 then
				property_title.text_color[1] = num_3

				UIPasses.text.draw(arg_85_3, title_text_pass_data, arg_85_5, arg_85_6, property_title, content, arg_85_9, text_size, arg_85_11, arg_85_12)
			end

			local num_6 = num_5 + frame_margin * 0.5

			arg_85_9[2] = arg_85_9[2] - frame_margin * 0.5

			local num_7 = 1
			local entry_list = content.entry_list

			for i, v in ipairs(entry_list) do
				local text = v.text
				local str = "entry_" .. num_7
				local entry_text = style.entry_text
				local text_pass_data = self.text_pass_data

				text_pass_data.text_id = str

				local text_size_2 = self.text_size

				text_size_2[2] = 0

				local get_text_height_2 = UIUtils.get_text_height(arg_85_3, text_size_2, entry_text, text)

				text_size_2[2] = get_text_height_2
				arg_85_9[2] = arg_85_9[2] - get_text_height_2

				local var_85_25 = arg_85_9[2]

				content[str] = text

				if not arg_85_1 then
					local icon_pass_definition = self.icon_pass_definition
					local icon_pass_data = self.icon_pass_data
					local icon = style.icon
					local icon_size = self.icon_size

					icon.color[1] = num_3
					arg_85_9[2] = arg_85_9[2] + get_text_height_2 / 2 - icon_size[2] / 2 - 2

					UIPasses.texture.draw(arg_85_3, icon_pass_data, arg_85_5, icon_pass_definition, icon, content, arg_85_9, icon_size, arg_85_11, arg_85_12)

					arg_85_9[2] = var_85_25
					arg_85_9[1] = arg_85_9[1] + icon_size[1]
					entry_text.text_color[1] = num_3

					UIPasses.text.draw(arg_85_3, text_pass_data, arg_85_5, arg_85_6, entry_text, content, arg_85_9, self.text_size, arg_85_11, arg_85_12)

					arg_85_9[1] = arg_85_9[1] - icon_size[1]
				end

				num_6 = num_6 + get_text_height_2
				arg_85_9[2] = var_85_25
			end

			local num_8 = num_7 + 1
			local num_9 = num_6 + num_2

			arg_85_9[1] = var_85_6
			arg_85_9[2] = var_85_7
			arg_85_9[3] = var_85_8

			return num_9
		end
	},
	hero_power_description = {
		setup_data = function ()
			-- function 86
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
						font_size = fn(14),
						text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
					}
				}
			}
		end,
		draw = function (self, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6, arg_87_7, arg_87_8, arg_87_9, arg_87_10, arg_87_11, arg_87_12)
			-- function 87
			local num_2 = 255 * arg_87_4.alpha_multiplier
			local start_layer = arg_87_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local content = self.content
			local style = self.style
			local var_87_5 = arg_87_9[1]
			local var_87_6 = arg_87_9[2]
			local var_87_7 = arg_87_9[3]

			arg_87_9[3] = start_layer + 5

			local text = style.text
			local text_pass_data = self.text_pass_data
			local text_size = self.text_size

			text_size[1] = arg_87_10[1] - frame_margin * 2
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_87_3, text_size, text, content.text)

			text_size[2] = get_text_height

			local num_3 = get_text_height + frame_margin * 0.5

			if not arg_87_1 then
				local edge_size = self.edge_size

				edge_size[1] = arg_87_10[1]

				local edge = style.edge
				local color = edge.color
				local texture_size = edge.texture_size

				texture_size[1] = arg_87_10[1]

				local edge_texture = content.edge_texture

				color[1] = num_2

				local num_4 = arg_87_9[2] - frame_margin * 0.5

				arg_87_9[2] = num_4
				arg_87_9[3] = start_layer + 4

				UIRenderer.draw_tiled_texture(arg_87_3, edge_texture, arg_87_9, edge_size, texture_size, color)

				local edge_holder = style.edge_holder
				local edge_holder_size = self.edge_holder_size
				local color_2 = edge_holder.color
				local edge_holder_left = content.edge_holder_left
				local edge_holder_right = content.edge_holder_right

				color_2[1] = num_2
				arg_87_9[1] = arg_87_9[1] + 3
				arg_87_9[2] = num_4 - 6
				arg_87_9[3] = start_layer + 6

				UIRenderer.draw_texture(arg_87_3, edge_holder_left, arg_87_9, edge_holder_size, color_2)

				arg_87_9[1] = arg_87_9[1] + edge_size[1] - (edge_holder_size[1] + 6)

				UIRenderer.draw_texture(arg_87_3, edge_holder_right, arg_87_9, edge_holder_size, color_2)

				arg_87_9[1] = var_87_5 + frame_margin
				arg_87_9[2] = num_4 - num_3 + frame_margin * 0.5
				text.text_color[1] = num_2

				UIPasses.text.draw(arg_87_3, text_pass_data, arg_87_5, arg_87_6, text, content, arg_87_9, text_size, arg_87_11, arg_87_12)
			end

			arg_87_9[1] = var_87_5
			arg_87_9[2] = var_87_6
			arg_87_9[3] = var_87_7

			return num_3
		end
	},
	hero_power_title = {
		setup_data = function ()
			-- function 88
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
						font_size = fn(28),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					}
				}
			}
		end,
		draw = function (self, arg_89_1, arg_89_2, arg_89_3, arg_89_4, arg_89_5, arg_89_6, arg_89_7, arg_89_8, arg_89_9, arg_89_10, arg_89_11, arg_89_12)
			-- function 89
			local num_2 = 255 * arg_89_4.alpha_multiplier
			local start_layer = arg_89_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local content = self.content
			local style = self.style

			content.text = content.prefix_text

			local var_89_5 = arg_89_9[1]
			local var_89_6 = arg_89_9[2]
			local var_89_7 = arg_89_9[3]

			arg_89_9[3] = start_layer + 5

			local text = style.text
			local text_pass_data = self.text_pass_data
			local text_size = self.text_size

			text_size[1] = arg_89_10[1] - frame_margin * 2
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_89_3, text_size, text, content.text)

			text_size[2] = get_text_height

			if not arg_89_1 then
				arg_89_9[1] = var_89_5 + frame_margin
				arg_89_9[2] = arg_89_9[2] - get_text_height
				text.text_color[1] = num_2

				UIPasses.text.draw(arg_89_3, text_pass_data, arg_89_5, arg_89_6, text, content, arg_89_9, text_size, arg_89_11, arg_89_12)
			end

			arg_89_9[1] = var_89_5
			arg_89_9[2] = var_89_6
			arg_89_9[3] = var_89_7

			return get_text_height
		end
	},
	light_attack_stats = {
		setup_data = function ()
			-- function 90
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
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
		draw = function (self, arg_91_1, arg_91_2, arg_91_3, arg_91_4, arg_91_5, arg_91_6, arg_91_7, arg_91_8, arg_91_9, arg_91_10, arg_91_11, arg_91_12, arg_91_13)
			-- function 91
			if not Development.parameter("enable_detailed_tooltips") and not arg_91_11:get("item_compare") then
				local slot_type = arg_91_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			else
				return 0
			end

			local num_2 = 255 * arg_91_4.alpha_multiplier
			local start_layer = arg_91_4.start_layer

			start_layer = start_layer or num

			local num_3 = 20
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local var_91_7 = arg_91_9[1]
			local var_91_8 = arg_91_9[2]
			local var_91_9 = arg_91_9[3]
			local num_4 = 0

			arg_91_9[3] = start_layer + 2
			arg_91_9[2] = arg_91_9[2]

			local tbl = {
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

			if not tbl then
				local title = style.title
				local title_text_pass_data = self.title_text_pass_data
				local title_2 = content.title
				local text_size = self.text_size

				text_size[1] = arg_91_10[1] / 2 - frame_margin * 2
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_91_3, text_size, title, title_2)

				text_size[2] = get_text_height
				arg_91_9[2] = arg_91_9[2] - get_text_height

				local num_5 = num_4 + get_text_height

				if not arg_91_1 then
					title.text_color[1] = num_2
					arg_91_9[1] = arg_91_9[1] + frame_margin

					UIPasses.text.draw(arg_91_3, title_text_pass_data, arg_91_5, arg_91_6, title, content, arg_91_9, text_size, arg_91_11, arg_91_12)

					arg_91_9[1] = arg_91_9[1] - frame_margin
				end

				local num_6 = 10

				arg_91_9[2] = arg_91_9[2] - num_6

				local num_7 = num_5 + num_6
				local num_8 = 1
				local stat_text = style.stat_text
				local stat_value = style.stat_value

				for k, v in pairs(tbl) do
					local description

					if not v.empty then
						description = v.description

						if not description then
							-- Nothing
						end
					end

					description = ""

					::label_91_0::

					local player_unit = Managers.player:local_player().player_unit
					local get_item_tooltip_value

					if not v.empty then
						get_item_tooltip_value = UIUtils.get_item_tooltip_value(player_unit, arg_91_13, v)

						if not get_item_tooltip_value then
							-- Nothing
						end
					end

					get_item_tooltip_value = ""

					::label_91_1::

					local text_size_2 = self.text_size
					local var_91_27

					if not v.empty then
						var_91_27 = UIUtils.get_text_height(arg_91_3, text_size_2, stat_text, description)
					else
						var_91_27 = stat_text.font_size
					end

					text_size_2[2] = var_91_27
					arg_91_9[2] = arg_91_9[2] - var_91_27

					local var_91_28 = arg_91_9[2]
					local var_91_29 = arg_91_9[1]

					if not arg_91_1 then
						local str = "stat_" .. num_8

						arg_91_9[2] = var_91_28

						if num_8 % 2 == 0 then
							local background_size = self.background_size
							local color = style.background.color

							color[1] = num_2
							background_size[2] = var_91_27
							background_size[1] = arg_91_10[1] / 2
							arg_91_9[2] = var_91_28

							UIRenderer.draw_rect(arg_91_3, arg_91_9, background_size, color)
						end

						arg_91_9[1] = var_91_29 + frame_margin
						arg_91_9[2] = var_91_28
						arg_91_9[3] = start_layer + 3

						local text_pass_data = self.text_pass_data

						content[str] = description
						text_pass_data.text_id = str
						stat_text.text_color[1] = num_2

						UIPasses.text.draw(arg_91_3, text_pass_data, arg_91_5, arg_91_6, stat_text, content, arg_91_9, self.text_size, arg_91_11, arg_91_12)

						content[str] = get_item_tooltip_value
						stat_value.text_color[1] = num_2
						arg_91_9[1] = arg_91_9[1] + frame_margin / 3
						arg_91_9[2] = var_91_28

						UIPasses.text.draw(arg_91_3, text_pass_data, arg_91_5, arg_91_6, stat_value, content, arg_91_9, self.text_size, arg_91_11, arg_91_12)

						arg_91_9[3] = start_layer + 2
						arg_91_9[1] = var_91_29
					end

					num_7 = num_7 + var_91_27
					arg_91_9[2] = var_91_28

					if not v.empty then
						num_8 = num_8 + 1
					end
				end

				local num_9 = num_7 + num_3
			end

			arg_91_9[1] = var_91_7
			arg_91_9[2] = var_91_8
			arg_91_9[3] = var_91_9

			return 0
		end
	},
	heavy_attack_stats = {
		setup_data = function ()
			-- function 92
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
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
		draw = function (self, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, arg_93_7, arg_93_8, arg_93_9, arg_93_10, arg_93_11, arg_93_12, arg_93_13)
			-- function 93
			if not Development.parameter("enable_detailed_tooltips") and not arg_93_11:get("item_compare") then
				local slot_type = arg_93_13.data.slot_type

				if not (slot_type == "melee" or slot_type == "ranged") then
					return 0
				end
			else
				return 0
			end

			local num_2 = 255 * arg_93_4.alpha_multiplier
			local start_layer = arg_93_4.start_layer

			start_layer = start_layer or num

			local num_3 = 20
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local var_93_7 = arg_93_9[1]
			local var_93_8 = arg_93_9[2]
			local var_93_9 = arg_93_9[3]
			local num_4 = 0

			arg_93_9[3] = start_layer + 2
			arg_93_9[2] = arg_93_9[2]

			local tbl = {
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

			if not tbl then
				local title = style.title
				local title_text_pass_data = self.title_text_pass_data
				local title_2 = content.title
				local text_size = self.text_size

				text_size[1] = arg_93_10[1] / 2 - frame_margin * 2
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_93_3, text_size, title, title_2)

				text_size[2] = get_text_height
				arg_93_9[1] = arg_93_9[1] + arg_93_10[1] / 2
				arg_93_9[2] = arg_93_9[2] - get_text_height
				num_4 = num_4 + get_text_height

				if not arg_93_1 then
					title.text_color[1] = num_2
					arg_93_9[1] = arg_93_9[1] + frame_margin

					UIPasses.text.draw(arg_93_3, title_text_pass_data, arg_93_5, arg_93_6, title, content, arg_93_9, text_size, arg_93_11, arg_93_12)

					arg_93_9[1] = arg_93_9[1] - frame_margin
				end

				local num_5 = 10

				arg_93_9[2] = arg_93_9[2] - num_5
				num_4 = num_4 + num_5

				local num_6 = 1
				local stat_text = style.stat_text
				local stat_value = style.stat_value

				for k, v in pairs(tbl) do
					local description

					if not v.empty then
						description = v.description

						if not description then
							-- Nothing
						end
					end

					description = ""

					::label_93_0::

					local player_unit = Managers.player:local_player().player_unit
					local get_item_tooltip_value

					if not v.empty then
						get_item_tooltip_value = UIUtils.get_item_tooltip_value(player_unit, arg_93_13, v)

						if not get_item_tooltip_value then
							-- Nothing
						end
					end

					get_item_tooltip_value = ""

					::label_93_1::

					local text_size_2 = self.text_size
					local var_93_25

					if not v.empty then
						var_93_25 = UIUtils.get_text_height(arg_93_3, text_size_2, stat_text, description)
					else
						var_93_25 = stat_text.font_size
					end

					text_size_2[2] = var_93_25
					arg_93_9[2] = arg_93_9[2] - var_93_25

					local var_93_26 = arg_93_9[2]
					local var_93_27 = arg_93_9[1]

					if not arg_93_1 then
						local str = "stat_" .. num_6

						arg_93_9[2] = var_93_26

						if num_6 % 2 == 0 then
							local background_size = self.background_size
							local color = style.background.color

							color[1] = num_2
							background_size[2] = var_93_25
							background_size[1] = arg_93_10[1] / 2
							arg_93_9[2] = var_93_26

							UIRenderer.draw_rect(arg_93_3, arg_93_9, background_size, color)
						end

						arg_93_9[1] = var_93_27 + frame_margin
						arg_93_9[2] = var_93_26
						arg_93_9[3] = start_layer + 3

						local text_pass_data = self.text_pass_data

						content[str] = description
						text_pass_data.text_id = str
						stat_text.text_color[1] = num_2

						UIPasses.text.draw(arg_93_3, text_pass_data, arg_93_5, arg_93_6, stat_text, content, arg_93_9, self.text_size, arg_93_11, arg_93_12)

						content[str] = get_item_tooltip_value
						stat_value.text_color[1] = num_2
						arg_93_9[2] = var_93_26

						UIPasses.text.draw(arg_93_3, text_pass_data, arg_93_5, arg_93_6, stat_value, content, arg_93_9, self.text_size, arg_93_11, arg_93_12)

						arg_93_9[3] = start_layer + 2
						arg_93_9[1] = var_93_27
					end

					num_4 = num_4 + var_93_25
					arg_93_9[2] = var_93_26

					if not v.empty then
						num_6 = num_6 + 1
					end
				end

				if not arg_93_1 then
					arg_93_9[1] = var_93_7 + arg_93_10[1] / 2

					local edge_size = self.edge_size

					edge_size[2] = num_4

					local edge_texture = content.edge_texture
					local edge = style.edge
					local color_2 = edge.color
					local texture_size = edge.texture_size

					texture_size[2] = num_4
					color_2[1] = num_2
					arg_93_9[1] = arg_93_9[1] - texture_size[1] / 2
					arg_93_9[2] = arg_93_9[2] - frame_margin * 0.5
					arg_93_9[3] = start_layer + 4

					UIRenderer.draw_tiled_texture(arg_93_3, edge_texture, arg_93_9, edge_size, texture_size, color_2)

					local edge_holder = style.edge_holder
					local edge_holder_size = self.edge_holder_size
					local color_3 = edge_holder.color
					local edge_holder_top = content.edge_holder_top
					local edge_holder_bottom = content.edge_holder_bottom

					color_3[1] = num_2
					arg_93_9[1] = arg_93_9[1] - edge_holder_size[1] / 2 + 3
					arg_93_9[3] = start_layer + 6
					arg_93_9[2] = arg_93_9[2] - 2

					UIRenderer.draw_texture(arg_93_3, edge_holder_bottom, arg_93_9, edge_holder_size, color_3)

					arg_93_9[2] = arg_93_9[2] + num_4

					UIRenderer.draw_texture(arg_93_3, edge_holder_top, arg_93_9, edge_holder_size, color_3)
				end
			end

			arg_93_9[1] = var_93_7
			arg_93_9[2] = var_93_8
			arg_93_9[3] = var_93_9

			return num_4
		end
	},
	detailed_stats_light = {
		setup_data = function ()
			-- function 94
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
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
		draw = function (self, arg_95_1, arg_95_2, arg_95_3, arg_95_4, arg_95_5, arg_95_6, arg_95_7, arg_95_8, arg_95_9, arg_95_10, arg_95_11, arg_95_12, arg_95_13)
			-- function 95
			if not Development.parameter("enable_detailed_tooltips") and not arg_95_11:get("item_detail") then
				if not (arg_95_13.data.slot_type == "melee") then
					return 0
				end
			else
				return 0
			end

			local num_2 = 255 * arg_95_4.alpha_multiplier
			local start_layer = arg_95_4.start_layer

			start_layer = start_layer or num

			local num_3 = 20
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local var_95_6 = arg_95_9[1]
			local var_95_7 = arg_95_9[2]
			local var_95_8 = arg_95_9[3]
			local num_4 = 0

			arg_95_9[3] = start_layer + 2
			arg_95_9[2] = arg_95_9[2]

			local tbl = {
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

			if not tbl then
				local title = style.title
				local title_text_pass_data = self.title_text_pass_data
				local title_2 = content.title
				local text_size = self.text_size

				text_size[1] = arg_95_10[1] - frame_margin * 2
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_95_3, text_size, title, title_2)

				text_size[2] = get_text_height
				arg_95_9[2] = arg_95_9[2] - get_text_height
				num_4 = num_4 + get_text_height

				if not arg_95_1 then
					title.text_color[1] = num_2
					arg_95_9[1] = arg_95_9[1] + frame_margin

					UIPasses.text.draw(arg_95_3, title_text_pass_data, arg_95_5, arg_95_6, title, content, arg_95_9, text_size, arg_95_11, arg_95_12)

					arg_95_9[1] = arg_95_9[1] - frame_margin
				end

				local num_5 = 10

				arg_95_9[2] = arg_95_9[2] - num_5
				num_4 = num_4 + num_5

				local num_6 = 1
				local stat_text = style.stat_text
				local stat_value = style.stat_value

				for k, v in pairs(tbl) do
					local description

					if not v.empty then
						description = v.description

						if not description then
							-- Nothing
						end
					end

					description = ""

					::label_95_0::

					local player_unit = Managers.player:local_player().player_unit
					local get_item_tooltip_value

					if not v.empty then
						get_item_tooltip_value = UIUtils.get_item_tooltip_value(player_unit, arg_95_13, v)

						if not get_item_tooltip_value then
							-- Nothing
						end
					end

					get_item_tooltip_value = ""

					::label_95_1::

					local text_size_2 = self.text_size
					local var_95_24

					if not v.empty then
						var_95_24 = UIUtils.get_text_height(arg_95_3, text_size_2, stat_text, description)
					else
						var_95_24 = stat_text.font_size
					end

					text_size_2[2] = var_95_24
					arg_95_9[2] = arg_95_9[2] - var_95_24

					local var_95_25 = arg_95_9[2]
					local var_95_26 = arg_95_9[1]

					if not arg_95_1 then
						local str = "stat_" .. num_6

						arg_95_9[2] = var_95_25

						if num_6 % 2 == 0 then
							local background_size = self.background_size
							local color = style.background.color

							color[1] = num_2
							background_size[2] = var_95_24
							background_size[1] = arg_95_10[1]
							arg_95_9[2] = var_95_25

							UIRenderer.draw_rect(arg_95_3, arg_95_9, background_size, color)
						end

						arg_95_9[1] = var_95_26 + frame_margin
						arg_95_9[2] = var_95_25
						arg_95_9[3] = start_layer + 3

						local text_pass_data = self.text_pass_data

						content[str] = description
						text_pass_data.text_id = str
						stat_text.text_color[1] = num_2

						UIPasses.text.draw(arg_95_3, text_pass_data, arg_95_5, arg_95_6, stat_text, content, arg_95_9, self.text_size, arg_95_11, arg_95_12)

						content[str] = get_item_tooltip_value
						stat_value.text_color[1] = num_2
						arg_95_9[1] = arg_95_9[1] + frame_margin / 3
						arg_95_9[2] = var_95_25

						UIPasses.text.draw(arg_95_3, text_pass_data, arg_95_5, arg_95_6, stat_value, content, arg_95_9, self.text_size, arg_95_11, arg_95_12)

						arg_95_9[3] = start_layer + 2
						arg_95_9[1] = var_95_26
					end

					num_4 = num_4 + var_95_24
					arg_95_9[2] = var_95_25

					if not v.empty then
						num_6 = num_6 + 1
					end
				end
			end

			arg_95_9[1] = var_95_6
			arg_95_9[2] = var_95_7
			arg_95_9[3] = var_95_8

			return num_4
		end
	},
	detailed_stats_heavy = {
		setup_data = function ()
			-- function 96
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
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
		draw = function (self, arg_97_1, arg_97_2, arg_97_3, arg_97_4, arg_97_5, arg_97_6, arg_97_7, arg_97_8, arg_97_9, arg_97_10, arg_97_11, arg_97_12, arg_97_13)
			-- function 97
			if not Development.parameter("enable_detailed_tooltips") and not arg_97_11:get("item_detail") then
				if not (arg_97_13.data.slot_type == "melee") then
					return 0
				end
			else
				return 0
			end

			local num_2 = 255 * arg_97_4.alpha_multiplier
			local start_layer = arg_97_4.start_layer

			start_layer = start_layer or num

			local num_3 = 20
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local var_97_6 = arg_97_9[1]
			local var_97_7 = arg_97_9[2]
			local var_97_8 = arg_97_9[3]
			local num_4 = 0

			arg_97_9[3] = start_layer + 2
			arg_97_9[2] = arg_97_9[2]

			local tbl = {
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

			if not tbl then
				local title = style.title
				local title_text_pass_data = self.title_text_pass_data
				local title_2 = content.title
				local text_size = self.text_size

				text_size[1] = arg_97_10[1] - frame_margin * 2
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_97_3, text_size, title, title_2)

				text_size[2] = get_text_height
				arg_97_9[2] = arg_97_9[2] - get_text_height
				num_4 = num_4 + get_text_height

				if not arg_97_1 then
					title.text_color[1] = num_2
					arg_97_9[1] = arg_97_9[1] + frame_margin

					UIPasses.text.draw(arg_97_3, title_text_pass_data, arg_97_5, arg_97_6, title, content, arg_97_9, text_size, arg_97_11, arg_97_12)

					arg_97_9[1] = arg_97_9[1] - frame_margin
				end

				local num_5 = 10

				arg_97_9[2] = arg_97_9[2] - num_5
				num_4 = num_4 + num_5

				local num_6 = 1
				local stat_text = style.stat_text
				local stat_value = style.stat_value

				for k, v in pairs(tbl) do
					local description

					if not v.empty then
						description = v.description

						if not description then
							-- Nothing
						end
					end

					description = ""

					::label_97_0::

					local player_unit = Managers.player:local_player().player_unit
					local get_item_tooltip_value

					if not v.empty then
						get_item_tooltip_value = UIUtils.get_item_tooltip_value(player_unit, arg_97_13, v)

						if not get_item_tooltip_value then
							-- Nothing
						end
					end

					get_item_tooltip_value = ""

					::label_97_1::

					local text_size_2 = self.text_size
					local var_97_24

					if not v.empty then
						var_97_24 = UIUtils.get_text_height(arg_97_3, text_size_2, stat_text, description)
					else
						var_97_24 = stat_text.font_size
					end

					text_size_2[2] = var_97_24
					arg_97_9[2] = arg_97_9[2] - var_97_24

					local var_97_25 = arg_97_9[2]
					local var_97_26 = arg_97_9[1]

					if not arg_97_1 then
						local str = "stat_" .. num_6

						arg_97_9[2] = var_97_25

						if num_6 % 2 == 0 then
							local background_size = self.background_size
							local color = style.background.color

							color[1] = num_2
							background_size[2] = var_97_24
							background_size[1] = arg_97_10[1]
							arg_97_9[2] = var_97_25

							UIRenderer.draw_rect(arg_97_3, arg_97_9, background_size, color)
						end

						arg_97_9[1] = var_97_26 + frame_margin
						arg_97_9[2] = var_97_25
						arg_97_9[3] = start_layer + 3

						local text_pass_data = self.text_pass_data

						content[str] = description
						text_pass_data.text_id = str
						stat_text.text_color[1] = num_2

						UIPasses.text.draw(arg_97_3, text_pass_data, arg_97_5, arg_97_6, stat_text, content, arg_97_9, self.text_size, arg_97_11, arg_97_12)

						content[str] = get_item_tooltip_value
						stat_value.text_color[1] = num_2
						arg_97_9[1] = arg_97_9[1] + frame_margin / 3
						arg_97_9[2] = var_97_25

						UIPasses.text.draw(arg_97_3, text_pass_data, arg_97_5, arg_97_6, stat_value, content, arg_97_9, self.text_size, arg_97_11, arg_97_12)

						arg_97_9[3] = start_layer + 2
						arg_97_9[1] = var_97_26
					end

					num_4 = num_4 + var_97_24
					arg_97_9[2] = var_97_25

					if not v.empty then
						num_6 = num_6 + 1
					end
				end
			end

			arg_97_9[1] = var_97_6
			arg_97_9[2] = var_97_7
			arg_97_9[3] = var_97_8

			return num_4
		end
	},
	detailed_stats_push = {
		setup_data = function ()
			-- function 98
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
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
		draw = function (self, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5, arg_99_6, arg_99_7, arg_99_8, arg_99_9, arg_99_10, arg_99_11, arg_99_12, arg_99_13)
			-- function 99
			if not Development.parameter("enable_detailed_tooltips") and not arg_99_11:get("item_detail") then
				if not (arg_99_13.data.slot_type == "melee") then
					return 0
				end
			else
				return 0
			end

			local num_2 = 255 * arg_99_4.alpha_multiplier
			local start_layer = arg_99_4.start_layer

			start_layer = start_layer or num

			local num_3 = 20
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local var_99_6 = arg_99_9[1]
			local var_99_7 = arg_99_9[2]
			local var_99_8 = arg_99_9[3]
			local num_4 = 0

			arg_99_9[3] = start_layer + 2
			arg_99_9[2] = arg_99_9[2]

			local tbl = {
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

			if not tbl then
				local title = style.title
				local title_text_pass_data = self.title_text_pass_data
				local title_2 = content.title
				local text_size = self.text_size

				text_size[1] = arg_99_10[1] - frame_margin * 2
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_99_3, text_size, title, title_2)

				text_size[2] = get_text_height
				arg_99_9[2] = arg_99_9[2] - get_text_height
				num_4 = num_4 + get_text_height

				if not arg_99_1 then
					title.text_color[1] = num_2
					arg_99_9[1] = arg_99_9[1] + frame_margin

					UIPasses.text.draw(arg_99_3, title_text_pass_data, arg_99_5, arg_99_6, title, content, arg_99_9, text_size, arg_99_11, arg_99_12)

					arg_99_9[1] = arg_99_9[1] - frame_margin
				end

				local num_5 = 10

				arg_99_9[2] = arg_99_9[2] - num_5
				num_4 = num_4 + num_5

				local num_6 = 1
				local stat_text = style.stat_text
				local stat_value = style.stat_value

				for k, v in pairs(tbl) do
					local description

					if not v.empty then
						description = v.description

						if not description then
							-- Nothing
						end
					end

					description = ""

					::label_99_0::

					local player_unit = Managers.player:local_player().player_unit
					local get_item_tooltip_value

					if not v.empty then
						get_item_tooltip_value = UIUtils.get_item_tooltip_value(player_unit, arg_99_13, v)

						if not get_item_tooltip_value then
							-- Nothing
						end
					end

					get_item_tooltip_value = ""

					::label_99_1::

					local text_size_2 = self.text_size
					local var_99_24

					if not v.empty then
						var_99_24 = UIUtils.get_text_height(arg_99_3, text_size_2, stat_text, description)
					else
						var_99_24 = stat_text.font_size
					end

					text_size_2[2] = var_99_24
					arg_99_9[2] = arg_99_9[2] - var_99_24

					local var_99_25 = arg_99_9[2]
					local var_99_26 = arg_99_9[1]

					if not arg_99_1 then
						local str = "stat_" .. num_6

						arg_99_9[2] = var_99_25

						if num_6 % 2 == 0 then
							local background_size = self.background_size
							local color = style.background.color

							color[1] = num_2
							background_size[2] = var_99_24
							background_size[1] = arg_99_10[1]
							arg_99_9[2] = var_99_25

							UIRenderer.draw_rect(arg_99_3, arg_99_9, background_size, color)
						end

						arg_99_9[1] = var_99_26 + frame_margin
						arg_99_9[2] = var_99_25
						arg_99_9[3] = start_layer + 3

						local text_pass_data = self.text_pass_data

						content[str] = description
						text_pass_data.text_id = str
						stat_text.text_color[1] = num_2

						UIPasses.text.draw(arg_99_3, text_pass_data, arg_99_5, arg_99_6, stat_text, content, arg_99_9, self.text_size, arg_99_11, arg_99_12)

						content[str] = get_item_tooltip_value
						stat_value.text_color[1] = num_2
						arg_99_9[1] = arg_99_9[1] + frame_margin / 3
						arg_99_9[2] = var_99_25

						UIPasses.text.draw(arg_99_3, text_pass_data, arg_99_5, arg_99_6, stat_value, content, arg_99_9, self.text_size, arg_99_11, arg_99_12)

						arg_99_9[3] = start_layer + 2
						arg_99_9[1] = var_99_26
					end

					num_4 = num_4 + var_99_24
					arg_99_9[2] = var_99_25

					if not v.empty then
						num_6 = num_6 + 1
					end
				end
			end

			arg_99_9[1] = var_99_6
			arg_99_9[2] = var_99_7
			arg_99_9[3] = var_99_8

			return num_4
		end
	},
	detailed_stats_ranged_light = {
		setup_data = function ()
			-- function 100
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
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
		draw = function (self, arg_101_1, arg_101_2, arg_101_3, arg_101_4, arg_101_5, arg_101_6, arg_101_7, arg_101_8, arg_101_9, arg_101_10, arg_101_11, arg_101_12, arg_101_13)
			-- function 101
			if not Development.parameter("enable_detailed_tooltips") and not arg_101_11:get("item_detail") then
				if not (arg_101_13.data.slot_type == "ranged") then
					return 0
				end
			else
				return 0
			end

			local num_2 = 255 * arg_101_4.alpha_multiplier
			local start_layer = arg_101_4.start_layer

			start_layer = start_layer or num

			local num_3 = 20
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local var_101_6 = arg_101_9[1]
			local var_101_7 = arg_101_9[2]
			local var_101_8 = arg_101_9[3]
			local num_4 = 0

			arg_101_9[3] = start_layer + 2
			arg_101_9[2] = arg_101_9[2]

			local tbl = {
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

			if not tbl then
				local title = style.title
				local title_text_pass_data = self.title_text_pass_data
				local title_2 = content.title
				local text_size = self.text_size

				text_size[1] = arg_101_10[1] - frame_margin * 2
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_101_3, text_size, title, title_2)

				text_size[2] = get_text_height
				arg_101_9[2] = arg_101_9[2] - get_text_height
				num_4 = num_4 + get_text_height

				if not arg_101_1 then
					title.text_color[1] = num_2
					arg_101_9[1] = arg_101_9[1] + frame_margin

					UIPasses.text.draw(arg_101_3, title_text_pass_data, arg_101_5, arg_101_6, title, content, arg_101_9, text_size, arg_101_11, arg_101_12)

					arg_101_9[1] = arg_101_9[1] - frame_margin
				end

				local num_5 = 10

				arg_101_9[2] = arg_101_9[2] - num_5
				num_4 = num_4 + num_5

				local num_6 = 1
				local stat_text = style.stat_text
				local stat_value = style.stat_value

				for k, v in pairs(tbl) do
					local description

					if not v.empty then
						description = v.description

						if not description then
							-- Nothing
						end
					end

					description = ""

					::label_101_0::

					local player_unit = Managers.player:local_player().player_unit
					local get_item_tooltip_value

					if not v.empty then
						get_item_tooltip_value = UIUtils.get_item_tooltip_value(player_unit, arg_101_13, v)

						if not get_item_tooltip_value then
							-- Nothing
						end
					end

					get_item_tooltip_value = ""

					::label_101_1::

					local text_size_2 = self.text_size
					local var_101_24

					if not v.empty then
						var_101_24 = UIUtils.get_text_height(arg_101_3, text_size_2, stat_text, description)
					else
						var_101_24 = stat_text.font_size
					end

					text_size_2[2] = var_101_24
					arg_101_9[2] = arg_101_9[2] - var_101_24

					local var_101_25 = arg_101_9[2]
					local var_101_26 = arg_101_9[1]

					if not arg_101_1 then
						local str = "stat_" .. num_6

						arg_101_9[2] = var_101_25

						if num_6 % 2 == 0 then
							local background_size = self.background_size
							local color = style.background.color

							color[1] = num_2
							background_size[2] = var_101_24
							background_size[1] = arg_101_10[1]
							arg_101_9[2] = var_101_25

							UIRenderer.draw_rect(arg_101_3, arg_101_9, background_size, color)
						end

						arg_101_9[1] = var_101_26 + frame_margin
						arg_101_9[2] = var_101_25
						arg_101_9[3] = start_layer + 3

						local text_pass_data = self.text_pass_data

						content[str] = description
						text_pass_data.text_id = str
						stat_text.text_color[1] = num_2

						UIPasses.text.draw(arg_101_3, text_pass_data, arg_101_5, arg_101_6, stat_text, content, arg_101_9, self.text_size, arg_101_11, arg_101_12)

						content[str] = get_item_tooltip_value
						stat_value.text_color[1] = num_2
						arg_101_9[1] = arg_101_9[1] + frame_margin / 3
						arg_101_9[2] = var_101_25

						UIPasses.text.draw(arg_101_3, text_pass_data, arg_101_5, arg_101_6, stat_value, content, arg_101_9, self.text_size, arg_101_11, arg_101_12)

						arg_101_9[3] = start_layer + 2
						arg_101_9[1] = var_101_26
					end

					num_4 = num_4 + var_101_24
					arg_101_9[2] = var_101_25

					if not v.empty then
						num_6 = num_6 + 1
					end
				end
			end

			arg_101_9[1] = var_101_6
			arg_101_9[2] = var_101_7
			arg_101_9[3] = var_101_8

			return num_4
		end
	},
	detailed_stats_ranged_heavy = {
		setup_data = function ()
			-- function 102
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
						font_size = fn(18),
						text_color = Colors.get_color_table_with_alpha("font_title", 255)
					},
					stat_text = {
						vertical_alignment = "center",
						horizontal_alignment = "left",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
						text_color = Colors.get_color_table_with_alpha("font_default", 255)
					},
					stat_value = {
						vertical_alignment = "center",
						horizontal_alignment = "right",
						word_wrap = true,
						font_type = "hell_shark",
						font_size = fn(16),
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
		draw = function (self, arg_103_1, arg_103_2, arg_103_3, arg_103_4, arg_103_5, arg_103_6, arg_103_7, arg_103_8, arg_103_9, arg_103_10, arg_103_11, arg_103_12, arg_103_13)
			-- function 103
			if not Development.parameter("enable_detailed_tooltips") and not arg_103_11:get("item_detail") then
				if not (arg_103_13.data.slot_type == "ranged") then
					return 0
				end
			else
				return 0
			end

			local num_2 = 255 * arg_103_4.alpha_multiplier
			local start_layer = arg_103_4.start_layer

			start_layer = start_layer or num

			local num_3 = 20
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local style = self.style
			local content = self.content
			local var_103_6 = arg_103_9[1]
			local var_103_7 = arg_103_9[2]
			local var_103_8 = arg_103_9[3]
			local num_4 = 0

			arg_103_9[3] = start_layer + 2
			arg_103_9[2] = arg_103_9[2]

			local tbl = {
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

			if not tbl then
				local title = style.title
				local title_text_pass_data = self.title_text_pass_data
				local title_2 = content.title
				local text_size = self.text_size

				text_size[1] = arg_103_10[1] - frame_margin * 2
				text_size[2] = 0

				local get_text_height = UIUtils.get_text_height(arg_103_3, text_size, title, title_2)

				text_size[2] = get_text_height
				arg_103_9[2] = arg_103_9[2] - get_text_height
				num_4 = num_4 + get_text_height

				if not arg_103_1 then
					title.text_color[1] = num_2
					arg_103_9[1] = arg_103_9[1] + frame_margin

					UIPasses.text.draw(arg_103_3, title_text_pass_data, arg_103_5, arg_103_6, title, content, arg_103_9, text_size, arg_103_11, arg_103_12)

					arg_103_9[1] = arg_103_9[1] - frame_margin
				end

				local num_5 = 10

				arg_103_9[2] = arg_103_9[2] - num_5
				num_4 = num_4 + num_5

				local num_6 = 1
				local stat_text = style.stat_text
				local stat_value = style.stat_value

				for k, v in pairs(tbl) do
					local description

					if not v.empty then
						description = v.description

						if not description then
							-- Nothing
						end
					end

					description = ""

					::label_103_0::

					local player_unit = Managers.player:local_player().player_unit
					local get_item_tooltip_value

					if not v.empty then
						get_item_tooltip_value = UIUtils.get_item_tooltip_value(player_unit, arg_103_13, v)

						if not get_item_tooltip_value then
							-- Nothing
						end
					end

					get_item_tooltip_value = ""

					::label_103_1::

					local text_size_2 = self.text_size
					local var_103_24

					if not v.empty then
						var_103_24 = UIUtils.get_text_height(arg_103_3, text_size_2, stat_text, description)
					else
						var_103_24 = stat_text.font_size
					end

					text_size_2[2] = var_103_24
					arg_103_9[2] = arg_103_9[2] - var_103_24

					local var_103_25 = arg_103_9[2]
					local var_103_26 = arg_103_9[1]

					if not arg_103_1 then
						local str = "stat_" .. num_6

						arg_103_9[2] = var_103_25

						if num_6 % 2 == 0 then
							local background_size = self.background_size
							local color = style.background.color

							color[1] = num_2
							background_size[2] = var_103_24
							background_size[1] = arg_103_10[1]
							arg_103_9[2] = var_103_25

							UIRenderer.draw_rect(arg_103_3, arg_103_9, background_size, color)
						end

						arg_103_9[1] = var_103_26 + frame_margin
						arg_103_9[2] = var_103_25
						arg_103_9[3] = start_layer + 3

						local text_pass_data = self.text_pass_data

						content[str] = description
						text_pass_data.text_id = str
						stat_text.text_color[1] = num_2

						UIPasses.text.draw(arg_103_3, text_pass_data, arg_103_5, arg_103_6, stat_text, content, arg_103_9, self.text_size, arg_103_11, arg_103_12)

						content[str] = get_item_tooltip_value
						stat_value.text_color[1] = num_2
						arg_103_9[1] = arg_103_9[1] + frame_margin / 3
						arg_103_9[2] = var_103_25

						UIPasses.text.draw(arg_103_3, text_pass_data, arg_103_5, arg_103_6, stat_value, content, arg_103_9, self.text_size, arg_103_11, arg_103_12)

						arg_103_9[3] = start_layer + 2
						arg_103_9[1] = var_103_26
					end

					num_4 = num_4 + var_103_24
					arg_103_9[2] = var_103_25

					if not v.empty then
						num_6 = num_6 + 1
					end
				end
			end

			arg_103_9[1] = var_103_6
			arg_103_9[2] = var_103_7
			arg_103_9[3] = var_103_8

			return num_4
		end
	},
	weave_progression_slot_titles = {
		setup_data = function ()
			-- function 104
			local tbl = {
				{
					name = "talent_title",
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					font_type = "hell_shark",
					font_size = fn(18),
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
					font_size = fn(18),
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
					font_size = fn(28),
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
					font_size = fn(18),
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
					font_size = fn(18),
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
					font_size = fn(18),
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
					font_size = fn(18),
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
					font_size = fn(18),
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
					font_size = fn(24),
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
					font_size = fn(18),
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
					font_size = fn(18),
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
					font_size = fn(18),
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
					font_size = fn(20),
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
					font_size = fn(20),
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
					font_size = fn(20),
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
					font_size = fn(20),
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
					font_size = fn(20),
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
				styles = tbl,
				pass_content = {},
				texture_pass_data = {},
				texture_pass_definition = {},
				text_pass_data = {},
				text_pass_size = {}
			}
		end,
		draw = function (self, arg_105_1, arg_105_2, arg_105_3, arg_105_4, arg_105_5, arg_105_6, arg_105_7, arg_105_8, arg_105_9, arg_105_10, arg_105_11, arg_105_12, arg_105_13)
			-- function 105
			local num_2 = 255 * arg_105_4.alpha_multiplier
			local start_layer = arg_105_4.start_layer

			start_layer = start_layer or num

			local num_3 = 20
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local styles = self.styles
			local pass_content = self.pass_content

			table.clear(pass_content)

			local var_105_6 = arg_105_10[1]
			local var_105_7 = arg_105_10[2]
			local var_105_8 = arg_105_9[1]
			local var_105_9 = arg_105_9[2]
			local var_105_10 = arg_105_9[3]

			arg_105_9[1] = arg_105_9[1] + frame_margin
			arg_105_9[3] = start_layer + 2

			local texture_pass_definition = self.texture_pass_definition
			local texture_pass_data = self.texture_pass_data
			local text_pass_data = self.text_pass_data
			local text_pass_size = self.text_pass_size

			arg_105_10[1] = arg_105_10[1] - frame_margin * 2
			text_pass_size[1] = arg_105_10[1]
			text_pass_size[2] = 0

			local num_4 = 5
			local num_5 = 0
			local num_6 = 0

			for i, v in ipairs(styles) do
				local pass_type = v.pass_type
				local name = v.name
				local ignore_line_change = v.ignore_line_change
				local minimum_height = v.minimum_height

				minimum_height = minimum_height or 0

				local height_spacing = v.height_spacing
				local offset = v.offset

				if pass_type == "text" then
					local var_105_24 = arg_105_13[name]

					var_105_24 = var_105_24 or v.text
					pass_content[name] = var_105_24
				elseif pass_type == "texture" then
					pass_content[name] = v.texture
				end

				local required_pass_style = v.required_pass_style

				if not (not pass_content[name] and not required_pass_style and pass_content[required_pass_style] == nil) then
					if not height_spacing then
						arg_105_9[2] = arg_105_9[2] + height_spacing
						num_4 = num_4 + height_spacing
					end

					arg_105_9[1] = var_105_8 + frame_margin

					if pass_type == "text" then
						local var_105_26 = pass_content[name]

						if not var_105_26 then
							text_pass_data.text_id = name
							text_pass_size[1] = arg_105_10[1] - offset[1]
							text_pass_size[2] = 0

							local get_text_height, var_105_28 = UIUtils.get_text_height(arg_105_3, text_pass_size, v, var_105_26)
							local get_text_width = UIUtils.get_text_width(arg_105_3, v, var_105_26)

							if get_text_height < minimum_height then
								get_text_height = minimum_height
							end

							num_5 = get_text_width
							num_6 = get_text_height

							if not ignore_line_change then
								arg_105_9[2] = var_105_9 - num_4
							else
								arg_105_9[2] = var_105_9 - (num_4 + get_text_height)
								num_4 = num_4 + get_text_height
							end

							arg_105_9[1] = arg_105_9[1] + offset[1]
							arg_105_9[2] = arg_105_9[2] + offset[2]

							if not arg_105_1 then
								text_pass_size[2] = get_text_height
								v.text_color[1] = num_2

								UIPasses.text.draw(arg_105_3, text_pass_data, arg_105_5, arg_105_6, v, pass_content, arg_105_9, text_pass_size, arg_105_11, arg_105_12)
							end
						end
					elseif pass_type == "texture" then
						texture_pass_definition.texture_id = name
						v.color[1] = num_2

						local texture_size = v.texture_size
						local var_105_31 = texture_size[1]
						local var_105_32 = texture_size[2]
						local height_margin = v.height_margin

						height_margin = height_margin or 0

						if not v.width_margin then
							local num_7 = 0
						end

						if var_105_32 < minimum_height then
							var_105_32 = minimum_height
						end

						if not ignore_line_change then
							arg_105_9[2] = var_105_9 - num_4 + num_6 / 2
						else
							arg_105_9[2] = var_105_9 - (num_4 + var_105_32 / 2 + height_margin)
							num_4 = num_4 + var_105_32 + height_margin * 2
						end

						if not v.align_after_previous_width then
							offset[1] = (num_5 + var_105_31) / 2 - var_105_31 / 2
						end

						arg_105_9[1] = math.round(arg_105_9[1] + offset[1])
						arg_105_9[2] = math.round(arg_105_9[2] + offset[2])

						if not arg_105_1 then
							UIPasses.texture.draw(arg_105_3, texture_pass_data, arg_105_5, texture_pass_definition, v, pass_content, arg_105_9, arg_105_10, arg_105_11, arg_105_12)
						end
					end
				end
			end

			arg_105_10[1] = var_105_6
			arg_105_10[2] = var_105_7
			arg_105_9[1] = var_105_8
			arg_105_9[2] = var_105_9
			arg_105_9[3] = var_105_10

			return num_4
		end
	},
	athanor_upgrade_tooltip = {
		setup_data = function ()
			-- function 106
			local tbl = {
				upgrade_property_text = {
					minimum_height = 35,
					localize = false,
					pass_type = "text",
					word_wrap = true,
					horizontal_alignment = "left",
					vertical_alignment = "bottom",
					font_type = "hell_shark",
					font_size = fn(20),
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
					font_size = fn(20),
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
				styles = tbl,
				pass_content = {},
				texture_pass_data = {},
				texture_pass_definition = {},
				text_pass_data = {},
				text_pass_size = {}
			}
		end,
		draw = function (self, arg_107_1, arg_107_2, arg_107_3, arg_107_4, arg_107_5, arg_107_6, arg_107_7, arg_107_8, arg_107_9, arg_107_10, arg_107_11, arg_107_12, arg_107_13)
			-- function 107
			local num_2 = 255 * arg_107_4.alpha_multiplier
			local start_layer = arg_107_4.start_layer

			start_layer = start_layer or num

			local num_3 = 20
			local frame_margin = self.frame_margin

			frame_margin = frame_margin or 0

			local styles = self.styles
			local pass_content = self.pass_content

			table.clear(pass_content)

			local var_107_6 = arg_107_10[1]
			local var_107_7 = arg_107_10[2]
			local var_107_8 = arg_107_9[1]
			local var_107_9 = arg_107_9[2]
			local var_107_10 = arg_107_9[3]

			arg_107_9[1] = arg_107_9[1] + frame_margin
			arg_107_9[3] = start_layer + 2

			local texture_pass_definition = self.texture_pass_definition
			local texture_pass_data = self.texture_pass_data
			local text_pass_data = self.text_pass_data
			local text_pass_size = self.text_pass_size

			arg_107_10[1] = arg_107_10[1] - frame_margin * 2
			text_pass_size[1] = arg_107_10[1]
			text_pass_size[2] = 0

			local num_4 = 5
			local num_5 = 0
			local num_6 = 0
			local property_unlocks = arg_107_13.property_unlocks
			local trait_unlocks = arg_107_13.trait_unlocks
			local tbl = {}

			for k, v in pairs(arg_107_13) do
				if type(v) == "table" then
					if k == "property_unlock_table" then
						for i, v_2 in ipairs(v) do
							tbl[#tbl + 1] = {
								style_name = "property_slot_icon",
								value = v_2.icon
							}
							tbl[#tbl + 1] = {
								style_name = "upgrade_property_text",
								value = v_2.text
							}
						end
					elseif k == "trait_unlock_table" then
						for i_2, v_3 in ipairs(v) do
							tbl[#tbl + 1] = {
								style_name = "trait_slot_icon",
								value = v_3.icon
							}
							tbl[#tbl + 1] = {
								style_name = "upgrade_trait_text",
								value = v_3.text
							}
						end
					end
				end
			end

			for i_3, v_4 in ipairs(tbl) do
				local style_name = v_4.style_name
				local var_107_22 = styles[style_name]

				pass_content[style_name] = v_4.value

				local pass_type = var_107_22.pass_type
				local ignore_line_change = var_107_22.ignore_line_change
				local minimum_height = var_107_22.minimum_height

				minimum_height = minimum_height or 0

				local height_spacing = var_107_22.height_spacing
				local offset = var_107_22.offset
				local var_107_28 = offset[1]
				local var_107_29 = offset[2]

				if not height_spacing then
					arg_107_9[2] = arg_107_9[2] + height_spacing
					num_4 = num_4 + height_spacing
				end

				arg_107_9[1] = var_107_8 + frame_margin

				if pass_type == "text" then
					local var_107_30 = pass_content[style_name]

					if not var_107_30 then
						text_pass_data.text_id = style_name
						text_pass_size[1] = arg_107_10[1] - offset[1]
						text_pass_size[2] = 0

						local get_text_height, var_107_32 = UIUtils.get_text_height(arg_107_3, text_pass_size, var_107_22, var_107_30)
						local get_text_width = UIUtils.get_text_width(arg_107_3, var_107_22, var_107_30)

						if get_text_height < minimum_height then
							get_text_height = minimum_height
						end

						num_5 = get_text_width

						local var_107_34 = get_text_height

						if not ignore_line_change then
							arg_107_9[2] = var_107_9 - num_4
						else
							arg_107_9[2] = var_107_9 - (num_4 + get_text_height)
							num_4 = num_4 + get_text_height
						end

						arg_107_9[1] = arg_107_9[1] + offset[1]
						arg_107_9[2] = arg_107_9[2] + offset[2]

						if not arg_107_1 then
							text_pass_size[2] = get_text_height
							var_107_22.text_color[1] = num_2

							UIPasses.text.draw(arg_107_3, text_pass_data, arg_107_5, arg_107_6, var_107_22, pass_content, arg_107_9, text_pass_size, arg_107_11, arg_107_12)
						end
					end
				elseif pass_type == "texture" then
					texture_pass_definition.texture_id = style_name
					var_107_22.color[1] = num_2

					local texture_size = var_107_22.texture_size
					local var_107_36 = texture_size[1]
					local var_107_37 = texture_size[2]
					local height_margin = var_107_22.height_margin

					height_margin = height_margin or 0

					if not var_107_22.width_margin then
						local num_7 = 0
					end

					if var_107_37 < minimum_height then
						var_107_37 = minimum_height
					end

					if not ignore_line_change then
						arg_107_9[2] = var_107_9 - (num_4 + var_107_37 + height_margin)
					else
						arg_107_9[2] = var_107_9 - (num_4 + var_107_37 / 2 + height_margin)
						num_4 = num_4 + var_107_37 + height_margin * 2
					end

					if not var_107_22.align_after_previous_width then
						offset[1] = (num_5 + var_107_36) / 2 - var_107_36 / 2
					end

					arg_107_9[1] = math.round(arg_107_9[1] + offset[1])
					arg_107_9[2] = math.round(arg_107_9[2] + offset[2])

					if not arg_107_1 then
						UIPasses.texture.draw(arg_107_3, texture_pass_data, arg_107_5, texture_pass_definition, var_107_22, pass_content, arg_107_9, arg_107_10, arg_107_11, arg_107_12)
					end
				end

				offset[1] = var_107_28
				offset[2] = var_107_29
			end

			arg_107_10[1] = var_107_6
			arg_107_10[2] = var_107_7
			arg_107_9[1] = var_107_8
			arg_107_9[2] = var_107_9
			arg_107_9[3] = var_107_10

			return num_4 + num_3
		end
	},
	special_action_tooltip = {
		setup_data = function ()
			-- function 108
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
					font_size = fn(16),
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
		draw = function (self, arg_109_1, arg_109_2, arg_109_3, arg_109_4, arg_109_5, arg_109_6, arg_109_7, arg_109_8, arg_109_9, arg_109_10, arg_109_11, arg_109_12, arg_109_13)
			-- function 109
			local data = arg_109_13.data
			local temporary_template = data.temporary_template

			temporary_template = temporary_template or data.template

			local get_weapon_template = WeaponUtils.get_weapon_template(temporary_template)
			local flag = not get_weapon_template and get_weapon_template.tooltip_special_action_description

			if not flag then
				return 0
			end

			local num_2 = 255 * arg_109_4.alpha_multiplier
			local start_layer = arg_109_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin
			local text_pass_data = self.text_pass_data
			local content = self.content
			local font_title = Colors.color_definitions.font_title
			local format = string.format("{#color(%d,%d,%d)}%s:{#reset()} %s", font_title[2], font_title[3], font_title[4], Localize("action_three"), Localize(flag))

			content.text = format

			local var_109_11 = arg_109_9[1]
			local var_109_12 = arg_109_9[2]
			local var_109_13 = arg_109_9[3]
			local style_text = self.style_text
			local text_size = self.text_size
			local num_3 = arg_109_10[1] - frame_margin * 2

			text_size[1] = num_3
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_109_3, text_size, style_text, format)
			local num_4 = frame_margin + get_text_height

			text_size[1] = num_3
			text_size[2] = get_text_height

			if not arg_109_1 then
				local style_background = self.style_background
				local texture_size = style_background.texture_size
				local color = style_background.color

				color[1] = num_2
				texture_size[1] = arg_109_10[1]
				texture_size[2] = num_4
				arg_109_9[2] = var_109_12 - texture_size[2]
				arg_109_9[3] = start_layer + 1

				UIRenderer.draw_rect(arg_109_3, arg_109_9, texture_size, color)

				arg_109_9[2] = var_109_12
				arg_109_9[3] = var_109_13
				arg_109_9[1] = arg_109_9[1] + frame_margin + style_text.offset[1]
				arg_109_9[2] = arg_109_9[2] + frame_margin + style_text.offset[2] - num_4
				arg_109_9[3] = start_layer + 2 + style_text.offset[3]
				style_text.text_color[1] = num_2

				UIPasses.text.draw(arg_109_3, text_pass_data, arg_109_5, arg_109_6, style_text, content, arg_109_9, text_size, arg_109_11, arg_109_12)
			end

			arg_109_9[1] = var_109_11
			arg_109_9[2] = var_109_12
			arg_109_9[3] = var_109_13

			return num_4
		end
	},
	console_special_action_tooltip = {
		setup_data = function ()
			-- function 110
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
					font_size = fn(16),
					text_color = Colors.get_color_table_with_alpha("font_default", 255),
					offset = {
						0,
						0,
						0
					}
				}
			}
		end,
		draw = function (self, arg_111_1, arg_111_2, arg_111_3, arg_111_4, arg_111_5, arg_111_6, arg_111_7, arg_111_8, arg_111_9, arg_111_10, arg_111_11, arg_111_12, arg_111_13)
			-- function 111
			local data = arg_111_13.data
			local temporary_template = data.temporary_template

			temporary_template = temporary_template or data.template

			local get_weapon_template = WeaponUtils.get_weapon_template(temporary_template)
			local flag = not get_weapon_template and get_weapon_template.tooltip_special_action_description

			if not flag then
				return 0
			end

			local num_2 = 255 * arg_111_4.alpha_multiplier
			local start_layer = arg_111_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin
			local text_pass_data = self.text_pass_data
			local content = self.content
			local font_title = Colors.color_definitions.font_title
			local format = string.format("{#color(%d,%d,%d)}%s:{#reset()} %s", font_title[2], font_title[3], font_title[4], Localize("action_three"), Localize(flag))

			content.text = format

			local var_111_11 = arg_111_9[1]
			local var_111_12 = arg_111_9[2]
			local var_111_13 = arg_111_9[3]
			local style_text = self.style_text
			local text_size = self.text_size

			text_size[1] = arg_111_10[1] - frame_margin * 2
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_111_3, text_size, style_text, format)
			local num_3 = frame_margin + get_text_height

			text_size[2] = get_text_height

			if not arg_111_1 then
				arg_111_9[1] = arg_111_9[1] + frame_margin + style_text.offset[1]
				arg_111_9[2] = arg_111_9[2] + frame_margin + style_text.offset[2] - num_3
				arg_111_9[3] = start_layer + 2 + style_text.offset[3]
				style_text.text_color[1] = num_2

				UIPasses.text.draw(arg_111_3, text_pass_data, arg_111_5, arg_111_6, style_text, content, arg_111_9, text_size, arg_111_11, arg_111_12)
			end

			arg_111_9[1] = var_111_11
			arg_111_9[2] = var_111_12
			arg_111_9[3] = var_111_13

			return num_3
		end
	},
	other_equipped_careers_tooltip = {
		setup_data = function ()
			-- function 112
			local font_title = Colors.color_definitions.font_title

			return {
				frame_margin = 0,
				prefix = string.format("{#color(%d,%d,%d)}%s:{#reset()} ", font_title[2], font_title[3], font_title[4], Localize("equipped_on_other_career")),
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
					font_size = fn(16),
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
		draw = function (self, arg_113_1, arg_113_2, arg_113_3, arg_113_4, arg_113_5, arg_113_6, arg_113_7, arg_113_8, arg_113_9, arg_113_10, arg_113_11, arg_113_12, arg_113_13)
			-- function 113
			local var_113_0

			if not arg_113_13.data and not CosmeticUtils.is_cosmetic_item(arg_113_13.data.slot_type) then
				var_113_0 = arg_113_13.ItemId
			else
				var_113_0 = arg_113_13.backend_id
			end

			if not var_113_0 then
				return 0
			end

			local equipped_by_loadout = Managers.backend:get_interface("items"):equipped_by_loadout(var_113_0)

			if not table.is_empty(equipped_by_loadout) then
				return 0
			end

			local alloc_table = FrameTable.alloc_table()
			local alloc_table_2 = FrameTable.alloc_table()

			for k, v in pairs(equipped_by_loadout) do
				local var_113_4 = Localize(k)
				local num_loadouts = v.num_loadouts

				for k_2 = 1, #v do
					local var_113_6 = v[k_2]
					local var_113_7 = var_113_4
					local format

					if num_loadouts > 1 then
						format = string.format("{#color(193,91,36)} (%d){#reset()}", var_113_6)

						if not format then
							-- Nothing
						end
					end

					format = ""

					::label_113_0::

					local str = var_113_7 .. format

					if not alloc_table[str] then
						alloc_table[str] = true
						alloc_table_2[#alloc_table_2 + 1] = str
					end
				end
			end

			local concat = table.concat(alloc_table_2, ", ")
			local num_2 = 255 * arg_113_4.alpha_multiplier
			local start_layer = arg_113_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin
			local text_pass_data = self.text_pass_data
			local content = self.content
			local str_2 = self.prefix .. concat

			content.text = str_2

			local var_113_17 = arg_113_9[1]
			local var_113_18 = arg_113_9[2]
			local var_113_19 = arg_113_9[3]
			local style_text = self.style_text
			local text_size = self.text_size
			local num_3 = arg_113_10[1] - frame_margin * 2

			text_size[1] = num_3
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_113_3, text_size, style_text, str_2)
			local num_4 = frame_margin + get_text_height

			text_size[1] = num_3
			text_size[2] = get_text_height

			local inv_scale = RESOLUTION_LOOKUP.inv_scale

			if not arg_113_1 then
				local style_background = self.style_background
				local texture_size = style_background.texture_size
				local color = style_background.color

				color[1] = num_2
				texture_size[1] = arg_113_10[1]
				texture_size[2] = num_4
				arg_113_9[2] = var_113_18 - texture_size[2]
				arg_113_9[3] = start_layer + 1

				UIRenderer.draw_rect(arg_113_3, arg_113_9, texture_size, color)

				arg_113_9[2] = var_113_18
				arg_113_9[3] = var_113_19

				local edge_size = self.edge_size

				edge_size[1] = arg_113_10[1]

				local color_2 = self.edge.color
				local texture_size_2 = self.edge.texture_size

				texture_size_2[1] = arg_113_10[1]

				local edge_texture = content.edge_texture

				color_2[1] = num_2

				local num_5 = arg_113_9[2] - frame_margin * 0.5 * inv_scale

				arg_113_9[2] = num_5
				arg_113_9[3] = start_layer + 4

				UIRenderer.draw_tiled_texture(arg_113_3, edge_texture, arg_113_9, edge_size, texture_size_2, color_2)

				local edge_holder = self.edge_holder
				local edge_holder_size = self.edge_holder_size
				local color_3 = edge_holder.color
				local edge_holder_left = content.edge_holder_left
				local edge_holder_right = content.edge_holder_right

				color_3[1] = num_2
				arg_113_9[1] = arg_113_9[1] + 3
				arg_113_9[2] = num_5 - 6
				arg_113_9[3] = start_layer + 6

				UIRenderer.draw_texture(arg_113_3, edge_holder_left, arg_113_9, edge_holder_size, color_3)

				arg_113_9[1] = arg_113_9[1] + edge_size[1] - (edge_holder_size[1] + 6)

				UIRenderer.draw_texture(arg_113_3, edge_holder_right, arg_113_9, edge_holder_size, color_3)

				arg_113_9[1] = var_113_17 + frame_margin + style_text.offset[1]
				arg_113_9[2] = num_5 + frame_margin + style_text.offset[2] - num_4
				arg_113_9[3] = start_layer + 2 + style_text.offset[3]
				style_text.text_color[1] = num_2

				UIPasses.text.draw(arg_113_3, text_pass_data, arg_113_5, arg_113_6, style_text, content, arg_113_9, text_size, arg_113_11, arg_113_12)
			end

			arg_113_9[1] = var_113_17
			arg_113_9[2] = var_113_18
			arg_113_9[3] = var_113_19

			return num_4
		end
	},
	console_other_equipped_careers_tooltip = {
		setup_data = function ()
			-- function 114
			local font_title = Colors.color_definitions.font_title

			return {
				frame_margin = 0,
				prefix = string.format("{#color(%d,%d,%d)}%s:{#reset()} ", font_title[2], font_title[3], font_title[4], Localize("equipped_on_other_career")),
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
					font_size = fn(16),
					text_color = Colors.get_color_table_with_alpha("font_default", 255),
					offset = {
						0,
						0,
						0
					}
				}
			}
		end,
		draw = function (self, arg_115_1, arg_115_2, arg_115_3, arg_115_4, arg_115_5, arg_115_6, arg_115_7, arg_115_8, arg_115_9, arg_115_10, arg_115_11, arg_115_12, arg_115_13)
			-- function 115
			local var_115_0

			if not arg_115_13.data and not CosmeticUtils.is_cosmetic_item(arg_115_13.data.slot_type) then
				var_115_0 = arg_115_13.ItemId
			else
				var_115_0 = arg_115_13.backend_id
			end

			if not var_115_0 then
				return 0
			end

			local equipped_by_loadout = Managers.backend:get_interface("items"):equipped_by_loadout(var_115_0)

			if not table.is_empty(equipped_by_loadout) then
				return 0
			end

			local alloc_table = FrameTable.alloc_table()
			local alloc_table_2 = FrameTable.alloc_table()

			for k, v in pairs(equipped_by_loadout) do
				local var_115_4 = Localize(k)
				local num_loadouts = v.num_loadouts

				for k_2 = 1, #v do
					local var_115_6 = v[k_2]
					local var_115_7 = var_115_4
					local format

					if num_loadouts > 1 then
						format = string.format("{#color(193,91,36)} (%d){#reset()}", var_115_6)

						if not format then
							-- Nothing
						end
					end

					format = ""

					::label_115_0::

					local str = var_115_7 .. format

					if not alloc_table[str] then
						alloc_table[str] = true
						alloc_table_2[#alloc_table_2 + 1] = str
					end
				end
			end

			local concat = table.concat(alloc_table_2, ", ")
			local num_2 = 255 * arg_115_4.alpha_multiplier
			local start_layer = arg_115_4.start_layer

			start_layer = start_layer or num

			local frame_margin = self.frame_margin
			local text_pass_data = self.text_pass_data
			local content = self.content
			local str_2 = self.prefix .. concat

			content.text = str_2

			local var_115_17 = arg_115_9[1]
			local var_115_18 = arg_115_9[2]
			local var_115_19 = arg_115_9[3]
			local style_text = self.style_text
			local text_size = self.text_size

			text_size[1] = arg_115_10[1] - frame_margin * 2
			text_size[2] = 0

			local get_text_height = UIUtils.get_text_height(arg_115_3, text_size, style_text, str_2)
			local num_3 = frame_margin * 0.5 + get_text_height

			text_size[2] = get_text_height

			if not arg_115_1 then
				arg_115_9[1] = var_115_17 + frame_margin
				arg_115_9[2] = var_115_18 - num_3 + 5
				arg_115_9[3] = start_layer + 2 + style_text.offset[3]
				style_text.text_color[1] = num_2

				UIPasses.text.draw(arg_115_3, text_pass_data, arg_115_5, arg_115_6, style_text, content, arg_115_9, text_size, arg_115_11, arg_115_12)
			end

			arg_115_9[1] = var_115_17
			arg_115_9[2] = var_115_18
			arg_115_9[3] = var_115_19

			return num_3
		end
	}
}
