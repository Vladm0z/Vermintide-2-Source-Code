-- chunkname: @scripts/ui/ui_widgets_honduras.lua

require("scripts/settings/ui_frame_settings")
require("scripts/settings/ui_player_portrait_frame_settings")

local UIWidgets = UIWidgets

UIWidgets = UIWidgets or {}
UIWidgets = UIWidgets

UIWidgets.create_talent_slot = function (arg_1_0, arg_1_1)
	-- function 1
	local tbl = {
		50,
		-10
	}
	local menu_frame_01 = UIFrameSettings.menu_frame_01
	local menu_frame_03 = UIFrameSettings.menu_frame_03

	return {
		element = {
			passes = {
				{
					style_id = "icon",
					pass_type = "hotspot",
					content_id = "hotspot",
					content_check_function = function (self)
						-- function 2
						return self.parent.icon
					end
				},
				{
					style_id = "available_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 3
						local num_ranks

						if not self.unavailable then
							num_ranks = self.num_ranks

							if not num_ranks then
								-- Nothing
							end

							if not (self.num_ranks > self.rank) then
								-- Nothing
							end
						end

						num_ranks = false

						goto label_3_1

						::label_3_0::

						num_ranks = true

						::label_3_1::

						return num_ranks
					end
				},
				{
					style_id = "filled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 4
						local num_ranks

						if not self.unavailable then
							num_ranks = self.num_ranks

							if not num_ranks then
								-- Nothing
							end

							if self.num_ranks ~= self.rank then
								-- Nothing
							end
						end

						num_ranks = false

						goto label_4_1

						::label_4_0::

						num_ranks = true

						::label_4_1::

						return num_ranks
					end
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					texture_id = "counter_frame",
					style_id = "counter_frame",
					pass_type = "texture_frame",
					content_check_function = function (self)
						-- function 5
						return not self.unavailable
					end
				},
				{
					style_id = "counter_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 6
						return not self.unavailable
					end
				},
				{
					style_id = "counter_text",
					pass_type = "text",
					text_id = "counter_text",
					content_check_function = function (self)
						-- function 7
						local num_ranks

						if not self.unavailable then
							num_ranks = self.num_ranks

							if not num_ranks then
								-- Nothing
							end

							if not (self.num_ranks > self.rank) then
								-- Nothing
							end
						end

						num_ranks = false

						goto label_7_1

						::label_7_0::

						num_ranks = true

						::label_7_1::

						return num_ranks
					end
				},
				{
					style_id = "counter_text_complete",
					pass_type = "text",
					text_id = "counter_text",
					content_check_function = function (self)
						-- function 8
						local num_ranks

						if not self.unavailable then
							num_ranks = self.num_ranks

							if not num_ranks then
								-- Nothing
							end

							if self.num_ranks ~= self.rank then
								-- Nothing
							end
						end

						num_ranks = false

						goto label_8_1

						::label_8_0::

						num_ranks = true

						::label_8_1::

						return num_ranks
					end
				},
				{
					style_id = "rect_rotated",
					pass_type = "rect_rotated",
					content_check_function = function (self)
						-- function 9
						return self.has_connection
					end
				},
				{
					texture_id = "connection_arrow",
					style_id = "connection_arrow",
					pass_type = "rotated_texture",
					content_check_function = function (self)
						-- function 10
						return self.has_connection
					end
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					talent_id = "tooltip",
					style_id = "tooltip",
					pass_type = "talent_tooltip",
					content_check_function = function (self)
						-- function 11
						local talent_id = self.talent_id

						talent_id = not talent_id and self.hotspot.is_hover

						return talent_id
					end
				}
			}
		},
		content = {
			num_ranks = 0,
			connection_arrow = "drop_down_menu_arrow",
			counter_text = "0",
			rank = 0,
			unavailable = true,
			icon = "icon_trophy_skull_encased_t2_03",
			tooltip_text = "n/a",
			hotspot = {},
			frame = menu_frame_01.texture,
			counter_frame = menu_frame_03.texture
		},
		style = {
			tooltip = {
				draw_side = "right",
				size = {
					64,
					64
				},
				offset = {
					2,
					65,
					50
				}
			},
			tooltip_text = {
				font_size = 24,
				max_width = 500,
				localize = false,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255)
				},
				offset = {
					0,
					0,
					50
				}
			},
			rect_rotated = {
				angle = 0,
				size = {
					5,
					100
				},
				pivot = {
					2.5,
					0
				},
				color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					32,
					32,
					0
				}
			},
			connection_arrow = {
				angle = 0,
				size = {
					28,
					34
				},
				pivot = {
					14,
					0
				},
				color = Colors.get_color_table_with_alpha("yellow", 255),
				offset = {
					20,
					45,
					4
				}
			},
			counter_frame = {
				texture_size = menu_frame_03.texture_size,
				texture_sizes = menu_frame_03.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl[1],
					tbl[2],
					6
				},
				size = {
					25,
					25
				}
			},
			counter_rect = {
				size = {
					25,
					25
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					tbl[1],
					tbl[2],
					5
				}
			},
			available_rect = {
				size = {
					66,
					66
				},
				color = {
					255,
					0,
					255,
					0
				},
				offset = {
					-1,
					-1,
					0
				}
			},
			filled_rect = {
				size = {
					66,
					66
				},
				color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					-1,
					-1,
					0
				}
			},
			counter_text = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				font_size = 15,
				font_type = "hell_shark",
				size = {
					25,
					25
				},
				text_color = Colors.get_color_table_with_alpha("green", 255),
				offset = {
					tbl[1],
					tbl[2],
					7
				}
			},
			counter_text_complete = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				font_size = 15,
				font_type = "hell_shark",
				size = {
					25,
					25
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					tbl[1],
					tbl[2],
					7
				}
			},
			frame = {
				texture_size = menu_frame_01.texture_size,
				texture_sizes = menu_frame_01.texture_sizes,
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
				},
				size = {
					64,
					64
				}
			},
			icon = {
				saturated = true,
				size = {
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
					0,
					1
				}
			}
		},
		offset = arg_1_1 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

UIWidgets.create_simple_item_tooltip = function (arg_12_0, arg_12_1)
	-- function 12
	return {
		element = {
			passes = {
				{
					item_id = "item",
					style_id = "item",
					pass_type = "item_tooltip",
					content_passes = arg_12_1,
					content_check_function = function (self)
						-- function 13
						return self.item
					end
				}
			}
		},
		content = {},
		style = {
			item = {
				font_size = 18,
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("white", 255)
				},
				offset = {
					0,
					0,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_12_0
	}
end

UIWidgets.create_simple_item_presentation = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	-- function 14
	return {
		element = {
			passes = {
				{
					item_id = "item",
					style_id = "item",
					pass_type = "item_presentation",
					content_passes = arg_14_1,
					disable_unsupported = arg_14_4,
					content_check_function = function (self)
						-- function 15
						return self.item
					end
				}
			}
		},
		content = {
			force_equipped = arg_14_2
		},
		style = {
			pass_styles = arg_14_3,
			item = {
				font_size = 18,
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("white", 255)
				},
				offset = {
					0,
					0,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_14_0
	}
end

UIWidgets.create_reward_slot = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					retained_mode = arg_16_4
				},
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					style_id = "tooltip",
					pass_type = "item_tooltip",
					text_id = "tooltip",
					content_check_function = function (self)
						-- function 17
						local is_hover = self.hotspot.is_hover

						is_hover = not is_hover and self.hotspot.tooltip

						return is_hover
					end
				}
			}
		},
		content = {
			tooltip = "tooltip_text",
			texture_id = arg_16_0,
			hotspot = {}
		},
		style = {
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
					0
				},
				masked = arg_16_3,
				size = arg_16_2
			},
			hotspot = {
				size = arg_16_2,
				offset = {
					0,
					0,
					0
				}
			},
			tooltip = {
				draw_side = "right",
				font_type = "hell_shark",
				localize = true,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				max_width = 500,
				size = arg_16_2,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("white", 255)
				},
				offset = {
					0,
					0,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_16_1
	}
end

UIWidgets.create_talent_tree_background = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("black", 220)
	local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("gray", 50)
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			pass_type = "rounded_background",
			style_id = "background"
		},
		{
			pass_type = "rect",
			style_id = "inner_background"
		},
		{
			pass_type = "border",
			style_id = "inner_background_broder"
		},
		{
			pass_type = "rounded_background",
			style_id = "title_background"
		},
		{
			pass_type = "rounded_background",
			style_id = "title_inner_background"
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text"
		}
	}
	local tbl_3 = {
		title_text = Localize(arg_18_2)
	}
	local tbl_4 = {
		background = {
			corner_radius = 5,
			color = get_color_table_with_alpha,
			offset = {
				0,
				0,
				0
			}
		},
		inner_background = {
			color = get_color_table_with_alpha_2,
			offset = {
				5,
				5,
				1
			},
			size = {
				arg_18_1[1] - 10,
				arg_18_1[2] - 10
			}
		},
		inner_background_broder = {
			thickness = 1,
			color = get_color_table_with_alpha_2,
			offset = {
				5,
				5,
				2
			},
			size = {
				arg_18_1[1] - 10,
				arg_18_1[2] - 10
			}
		},
		title_background = {
			corner_radius = 5,
			color = get_color_table_with_alpha,
			offset = {
				0,
				arg_18_1[2] + 5,
				0
			},
			size = {
				arg_18_1[1],
				40
			}
		},
		title_inner_background = {
			corner_radius = 5,
			color = get_color_table_with_alpha_2,
			offset = {
				5,
				arg_18_1[2] + 10,
				1
			},
			size = {
				arg_18_1[1] - 10,
				30
			}
		},
		title_text = {
			vertical_alignment = "top",
			font_type = "hell_shark",
			font_size = 18,
			horizontal_alignment = "center",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				0,
				arg_18_1[2] + 5,
				2
			},
			size = {
				arg_18_1[1],
				30
			}
		},
		text = {
			vertical_alignment = "top",
			font_size = 18,
			horizontal_alignment = "left",
			word_wrap = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				20,
				20,
				3
			},
			size = {
				arg_18_1[1] - 40,
				arg_18_1[2] - 40
			}
		}
	}

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		-40,
		0
	}
	tbl.scenegraph_id = arg_18_0

	return tbl
end

UIWidgets.create_hero_frame = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	arg_19_3 = arg_19_3 or "menu_frame_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_19_3)
	local var_19_1

	if not arg_19_2 then
		var_19_1 = UIFrameSettings[arg_19_2]

		if not var_19_1 then
			-- Nothing
		end
	end

	var_19_1 = UIFrameSettings.menu_frame_02

	::label_19_0::

	return {
		element = {
			passes = {
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				}
			}
		},
		content = {
			frame = var_19_1.texture,
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						math.min(arg_19_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
						math.min(arg_19_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
					}
				},
				texture_id = arg_19_3
			}
		},
		style = {
			frame = {
				texture_size = var_19_1.texture_size,
				texture_sizes = var_19_1.texture_sizes,
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
		},
		scenegraph_id = arg_19_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_recipe_grid = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
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
		80,
		80
	}
	local tbl_4 = {
		80,
		80
	}

	arg_20_4 = arg_20_4 or 8
	arg_20_5 = arg_20_5 or 8

	local tbl_5 = {
		element = {}
	}
	local tbl_6 = {}
	local tbl_7 = {
		rows = arg_20_2,
		columns = arg_20_3,
		slots = arg_20_2 * arg_20_3
	}
	local tbl_8 = {}
	local num = arg_20_3 * tbl_4[1] + arg_20_4 * (arg_20_3 - 1)
	local num_2 = arg_20_1[1] - num
	local num_3 = arg_20_2 * tbl_4[2] + arg_20_5 * (arg_20_2 - 1)
	local num_4 = arg_20_1[2] - num_3
	local tbl_9 = {
		num_2 / 2,
		arg_20_1[2] - num_4 / 2 - tbl_4[2]
	}
	local num_5 = 3

	for i = 1, arg_20_2 do
		for j = 1, arg_20_3 do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local num_6 = i - 1
			local num_7 = j - 1
			local tbl_10 = {
				tbl_9[1] + num_7 * (tbl_4[1] + arg_20_4),
				tbl_9[2] - num_6 * (tbl_4[2] + arg_20_5),
				num_5
			}
			local str_2 = "item" .. str
			local str_3 = "hotspot" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "hotspot",
				content_id = str_3,
				style_id = str_3
			}
			tbl_8[str_3] = {
				size = tbl_4,
				offset = tbl_10
			}
			tbl_7[str_3] = {
				drag_texture_size = tbl_4
			}

			local str_4 = "item_icon" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_3,
				texture_id = str_4,
				style_id = str_4,
				content_check_function = function (self)
					-- function 21
					return self[str_4]
				end
			}
			tbl_8[str_4] = {
				size = tbl_3,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1],
					tbl_10[2],
					1
				}
			}

			UIWidgets.append_item_frame_pass("item_frame" .. str, tbl_6, tbl_7, tbl_8, tbl_3, {
				tbl_10[1],
				tbl_10[2],
				4
			}, false, str_3, nil, nil, function (self)
				-- function 22
				return self[str_4]
			end)

			local str_5 = "item_craft_frame" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_3,
				texture_id = str_5,
				style_id = str_5,
				content_check_function = function (self)
					-- function 23
					return self[str_4]
				end
			}
			tbl_8[str_5] = {
				size = {
					98,
					98
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1] - 9,
					tbl_10[2] - 9,
					6
				}
			}
			tbl_7[str_3][str_5] = "crafting_bg_03"

			local str_6 = "rarity_texture" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_6,
				style_id = str_6,
				content_check_function = function (self)
					-- function 24
					local var_24_0 = self[str_3][str_4]

					var_24_0 = not var_24_0 and self[str_2]

					return var_24_0
				end
			}
			tbl_8[str_6] = {
				size = tbl_3,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1],
					tbl_10[2],
					0
				}
			}
			tbl_7[str_6] = "icon_bg_default"

			local str_7 = "item_tooltip" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "item_tooltip",
				text_id = str_7,
				style_id = str_7,
				item_id = "item" .. str,
				content_check_function = function (self)
					-- function 25
					local is_hover = self[str_3].is_hover

					is_hover = not is_hover and self[str_2]

					return is_hover
				end
			}
			tbl_8[str_7] = {
				font_type = "hell_shark",
				localize = true,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				max_width = 500,
				size = tbl_4,
				offset = tbl_10,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("white", 255)
				},
				offset = tbl_10
			}
			tbl_7[str_7] = "tooltip_text"

			local str_8 = "slot" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_3,
				texture_id = str_8,
				style_id = str_8,
				content_check_function = function (self)
					-- function 26
					return not not self[str_4] or not self.hide_slot
				end
			}
			tbl_8[str_8] = {
				size = tbl_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1],
					tbl_10[2],
					0
				}
			}
			tbl_7[str_3][str_8] = "menu_slot_frame_01"

			local str_9 = "amount_text" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "text",
				text_id = str_9,
				style_id = str_9,
				content_id = str_3,
				content_check_function = function (self)
					-- function 27
					return not self.hide_slot
				end
			}
			tbl_8[str_9] = {
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				font_size = 28,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				size = tbl_3,
				offset = {
					tbl_10[1],
					tbl_10[2] - 44,
					3
				}
			}
			tbl_7[str_3][str_9] = "0/0"

			local str_10 = "amount_text_shadow" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "text",
				text_id = str_9,
				style_id = str_10,
				content_id = str_3
			}
			tbl_8[str_10] = {
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				font_size = 28,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				size = tbl_3,
				offset = {
					tbl_10[1] + 2,
					tbl_10[2] - 44 - 2,
					2
				}
			}
		end
	end

	tbl_5.element.passes = tbl_6
	tbl_5.content = tbl_7
	tbl_5.style = tbl_8
	tbl_5.offset = {
		0,
		0,
		0
	}
	tbl_5.scenegraph_id = arg_20_0

	return tbl_5
end

UIWidgets.create_grid = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, arg_28_8)
	-- function 28
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
		80,
		80
	}
	local tbl_4 = {
		80,
		80
	}

	arg_28_4 = arg_28_4 or 8
	arg_28_5 = arg_28_5 or 8

	local tbl_5 = {
		element = {}
	}
	local tbl_6 = {}
	local tbl_7 = {
		rows = arg_28_2,
		columns = arg_28_3,
		slots = arg_28_2 * arg_28_3,
		disable_mouse_tooltips = arg_28_8
	}
	local tbl_8 = {}

	if not arg_28_6 then
		tbl_6[#tbl_6 + 1] = {
			style_id = "page_text",
			pass_type = "text",
			text_id = "page_text",
			content_check_function = function (self)
				-- function 29
				local page_hotspot_left = self.page_hotspot_left
				local page_hotspot_right = self.page_hotspot_right
				local disable_button = page_hotspot_left.disable_button

				disable_button = not disable_button and page_hotspot_right.disable_button

				return not disable_button
			end
		}
		tbl_6[#tbl_6 + 1] = {
			style_id = "page_arrow_left",
			pass_type = "hotspot",
			content_id = "page_hotspot_left"
		}
		tbl_6[#tbl_6 + 1] = {
			style_id = "page_arrow_right",
			pass_type = "hotspot",
			content_id = "page_hotspot_right"
		}
		tbl_6[#tbl_6 + 1] = {
			pass_type = "texture",
			style_id = "page_arrow_left",
			texture_id = "texture_id",
			content_id = "stepper_arrow_normal",
			content_check_function = function (self)
				-- function 30
				local page_hotspot_left = self.parent.page_hotspot_left

				return not not page_hotspot_left.disable_button or not page_hotspot_left.is_hover
			end
		}
		tbl_6[#tbl_6 + 1] = {
			style_id = "page_arrow_right",
			pass_type = "texture_uv",
			content_id = "stepper_arrow_normal",
			content_check_function = function (self)
				-- function 31
				local page_hotspot_right = self.parent.page_hotspot_right

				return not not page_hotspot_right.disable_button or not page_hotspot_right.is_hover
			end
		}
		tbl_6[#tbl_6 + 1] = {
			pass_type = "texture",
			style_id = "page_arrow_left",
			texture_id = "texture_id",
			content_id = "stepper_arrow_hover",
			content_check_function = function (self)
				-- function 32
				local page_hotspot_left = self.parent.page_hotspot_left

				return not not page_hotspot_left.disable_button or page_hotspot_left.is_hover
			end
		}
		tbl_6[#tbl_6 + 1] = {
			style_id = "page_arrow_right",
			pass_type = "texture_uv",
			content_id = "stepper_arrow_hover",
			content_check_function = function (self)
				-- function 33
				local page_hotspot_right = self.parent.page_hotspot_right

				return not not page_hotspot_right.disable_button or page_hotspot_right.is_hover
			end
		}
		tbl_7.page_hotspot_left = {}
		tbl_7.page_hotspot_right = {}
		tbl_7.page_text = "n/a"
		tbl_7.stepper_arrow_normal = {
			texture_id = "settings_arrow_normal",
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
		tbl_7.stepper_arrow_hover = {
			texture_id = "settings_arrow_clicked",
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
		tbl_8.page_arrow_left = {
			color = tbl,
			offset = {
				arg_28_1[1] * 0.4 - 40,
				23,
				1
			},
			size = {
				28,
				34
			}
		}
		tbl_8.page_arrow_right = {
			color = tbl,
			offset = {
				arg_28_1[1] * 0.6 + 12,
				23,
				1
			},
			size = {
				28,
				34
			}
		}
		tbl_8.page_text = {
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = 18,
			horizontal_alignment = "center",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				arg_28_1[1] * 0.4,
				25,
				2
			},
			size = {
				arg_28_1[1] * 0.2,
				30
			}
		}
	end

	local num = arg_28_3 * tbl_4[1] + arg_28_4 * (arg_28_3 - 1)
	local num_2 = arg_28_1[1] - num
	local num_3 = arg_28_2 * tbl_4[2] + arg_28_5 * (arg_28_2 - 1)
	local num_4 = arg_28_1[2] - num_3
	local tbl_9 = {
		num_2 / 2,
		arg_28_1[2] - num_4 / 2 - tbl_4[2]
	}
	local num_5 = 3

	for i = 1, arg_28_2 do
		for j = 1, arg_28_3 do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local num_6 = i - 1
			local num_7 = j - 1
			local tbl_10 = {
				tbl_9[1] + num_7 * (tbl_4[1] + arg_28_4),
				tbl_9[2] - num_6 * (tbl_4[2] + arg_28_5),
				num_5
			}
			local str_2 = "item" .. str
			local str_3 = "hotspot" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "hotspot",
				content_id = str_3,
				style_id = str_3
			}
			tbl_8[str_3] = {
				size = tbl_4,
				offset = tbl_10
			}
			tbl_7[str_3] = {
				drag_texture_size = tbl_4
			}

			local str_4 = "item_icon" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_3,
				texture_id = str_4,
				style_id = str_4,
				content_check_function = function (self)
					-- function 34
					return self[str_4]
				end
			}
			tbl_8[str_4] = {
				size = tbl_3,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1],
					tbl_10[2],
					2
				}
			}

			local str_5 = "illusion_icon" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_5,
				style_id = str_5,
				content_check_function = function (self)
					-- function 35
					local var_35_0 = self[str_2]

					if not (not var_35_0 and var_35_0.skin) then
						return var_35_0.data.item_type == "weapon_skin"
					end
				end
			}
			tbl_8[str_5] = {
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
					tbl_10[1],
					tbl_10[2],
					3
				}
			}
			tbl_7[str_5] = "item_frame_illusion"

			local str_6 = "favorite_icon" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_6,
				style_id = str_6,
				content_check_function = function (self)
					-- function 36
					local var_36_0 = self[str_2]
					local flag = not var_36_0 and var_36_0.backend_id

					if not flag then
						return ItemHelper.is_favorite_backend_id(flag, var_36_0)
					end
				end
			}
			tbl_8[str_6] = {
				size = {
					20,
					20
				},
				color = {
					255,
					0,
					150,
					0
				},
				offset = {
					tbl_10[1] + 8,
					tbl_10[2] + tbl_3[2] - 30,
					3
				}
			}
			tbl_7[str_6] = "item_favorite_icon"

			local str_7 = "skin_icon" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_7,
				style_id = str_7,
				content_check_function = function (self)
					-- function 37
					local var_37_0 = self[str_2]
					local flag = not var_37_0 and var_37_0.skin

					if not flag then
						local ItemId = var_37_0.ItemId

						ItemId = ItemId or var_37_0.item_id

						local flag_2 = not ItemId and string.gsub(ItemId, "^vs_", "")

						return var_37_0.data.item_type == "weapon_skin" or WeaponSkins.default_skins[flag_2] ~= flag
					end
				end
			}
			tbl_8[str_7] = {
				size = {
					20,
					20
				},
				color = Colors.get_color_table_with_alpha("promo", 255),
				offset = {
					tbl_10[1] + tbl_3[1] - 28,
					tbl_10[2] + 8,
					3
				}
			}
			tbl_7[str_7] = "item_applied_illusion_icon"

			local str_8 = "equipped_other_career_icon" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_8,
				style_id = str_8,
				content_check_function = function (self)
					-- function 38
					local var_38_0 = self[str_2]

					if not var_38_0 then
						local data = var_38_0.data
						local var_38_2

						if not CosmeticUtils.is_cosmetic_item(data.slot_type) then
							var_38_2 = var_38_0.ItemId
						else
							var_38_2 = var_38_0.backend_id
						end

						if not var_38_2 then
							local local_player = Managers.player:local_player()

							if not local_player then
								return false
							end

							local career_index = local_player:career_index()
							local profile_index = local_player:profile_index()
							local name = SPProfiles[profile_index].careers[career_index].name
							local equipped_by = Managers.backend:get_interface("items"):equipped_by(var_38_2)

							if #equipped_by ~= 1 or not table.contains(equipped_by, name) then
								return false
							end

							return #equipped_by ~= 0
						end
					end
				end
			}
			tbl_8[str_8] = {
				size = {
					20,
					20
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					tbl_10[1] + 8,
					tbl_10[2] + 8,
					3
				}
			}
			tbl_7[str_8] = "equip_multiple_careers_stroke"

			local str_9 = "remove_marked_deed" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_9,
				style_id = str_9,
				content_check_function = function (self)
					-- function 39
					local var_39_0 = self[str_2]

					return not var_39_0 and var_39_0.marked_for_deletion
				end
			}
			tbl_8[str_9] = {
				size = {
					30,
					60
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					tbl_10[1] + (tbl_3[1] / 2 - 15),
					tbl_10[2] + 10,
					5
				}
			}
			tbl_7[str_9] = "salvage_item_icon"

			UIWidgets.append_item_frame_pass("item_frame" .. str, tbl_6, tbl_7, tbl_8, tbl_3, {
				tbl_10[1],
				tbl_10[2],
				5
			}, false, str_3, nil, nil, function (self)
				-- function 40
				return self[str_4]
			end)

			local str_10 = "rarity_texture" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_10,
				style_id = str_10,
				content_check_function = function (self)
					-- function 41
					local var_41_0 = self[str_3][str_4]

					var_41_0 = not var_41_0 and self[str_2]

					return var_41_0
				end
			}
			tbl_8[str_10] = {
				size = tbl_3,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1],
					tbl_10[2],
					0
				}
			}
			tbl_7[str_10] = "icon_bg_default"

			local str_11 = "item_tooltip" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "item_tooltip",
				text_id = str_11,
				style_id = str_11,
				item_id = "item" .. str,
				content_check_function = function (self)
					-- function 42
					local is_hover = self[str_3].is_hover

					if not is_hover then
						is_hover = self[str_2]
						is_hover = not is_hover and not self.disable_mouse_tooltips
					end

					return is_hover
				end
			}
			tbl_8[str_11] = {
				font_type = "hell_shark",
				localize = true,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				max_width = 500,
				size = tbl_4,
				offset = tbl_10,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("white", 255)
				},
				offset = tbl_10
			}
			tbl_7[str_11] = "tooltip_text"

			local str_12 = "slot" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_3,
				texture_id = str_12,
				style_id = str_12,
				content_check_function = function (self)
					-- function 43
					return not not self[str_4] or not self.hide_slot
				end
			}
			tbl_8[str_12] = {
				size = tbl_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1],
					tbl_10[2],
					0
				}
			}
			tbl_7[str_3][str_12] = "menu_slot_frame_01"

			local str_13 = "slot_hover" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_3,
				texture_id = str_13,
				style_id = str_13,
				content_check_function = function (self)
					-- function 44
					local highlight = self.highlight

					if not highlight then
						highlight = self.is_hover
						highlight = highlight or self.is_selected
					end

					return highlight
				end
			}
			tbl_8[str_13] = {
				size = {
					128,
					128
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1] - (128 - tbl_4[1]) / 2,
					tbl_10[2] - (128 - tbl_4[2]) / 2,
					0
				}
			}
			tbl_7[str_3][str_13] = "item_icon_hover"

			local str_14 = "slot_equipped" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_3,
				texture_id = str_14,
				style_id = str_14,
				content_check_function = function (self)
					-- function 45
					return self.equipped
				end
			}
			tbl_8[str_14] = {
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
					tbl_10[1] - (80 - tbl_4[1]) / 2,
					tbl_10[2] - (80 - tbl_4[2]) / 2,
					7
				}
			}
			tbl_7[str_3][str_14] = "item_icon_selection"

			local str_15 = "amount_text" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "text",
				text_id = str_15,
				style_id = str_15,
				content_id = str_3,
				content_check_function = function (self)
					-- function 46
					return self[str_4]
				end
			}
			tbl_8[str_15] = {
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				font_size = 32,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				size = tbl_3,
				offset = {
					tbl_10[1] - 7,
					tbl_10[2] - 1,
					4
				}
			}
			tbl_7[str_3][str_15] = ""

			local str_16 = "amount_text_shadow" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "text",
				text_id = str_15,
				style_id = str_16,
				content_id = str_3,
				content_check_function = function (self)
					-- function 47
					return self[str_4]
				end
			}
			tbl_8[str_16] = {
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				font_size = 32,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				size = tbl_3,
				offset = {
					tbl_10[1] - 7 + 2,
					tbl_10[2] - 1 - 2,
					3
				}
			}

			local str_17 = "disabled_rect" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "rect",
				content_id = str_3,
				style_id = str_17,
				content_check_function = function (self)
					-- function 48
					local var_48_0 = self[str_4]

					if not var_48_0 then
						var_48_0 = self.reserved
						var_48_0 = var_48_0 or self.unwieldable
					end

					return var_48_0
				end
			}
			tbl_8[str_17] = {
				size = tbl_3,
				color = {
					210,
					10,
					10,
					10
				},
				offset = {
					tbl_10[1],
					tbl_10[2],
					4
				}
			}

			local str_18 = "unwieldable_icon" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_18,
				content_id = str_3,
				style_id = str_18,
				content_check_function = function (self)
					-- function 49
					local var_49_0 = self[str_4]

					var_49_0 = not var_49_0 and self.unwieldable

					return var_49_0
				end
			}
			tbl_8[str_18] = {
				size = {
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
					tbl_10[1] + tbl_3[1] / 2 - 20,
					tbl_10[2] + tbl_3[2] / 2 - 20,
					5
				}
			}
			tbl_7[str_3][str_18] = "tab_menu_icon_03"

			local str_19 = "locked_icon" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_19,
				content_id = str_3,
				style_id = str_19,
				content_check_function = function (self)
					-- function 50
					local reserved = self.reserved

					reserved = not reserved and self[str_19]

					return reserved
				end
			}
			tbl_8[str_19] = {
				size = {
					30,
					60
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1] + tbl_3[1] / 2 - 15,
					tbl_10[2] + tbl_3[2] / 2 - 30,
					5
				}
			}
			tbl_7[str_3][str_19] = nil
			tbl_6[#tbl_6 + 1] = {
				pass_type = "drag",
				content_id = str_3,
				texture_id = str_4,
				style_id = str_4,
				content_check_function = function (self)
					-- function 51
					return self[str_4]
				end
			}

			local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
			local var_28_39 = frame_outer_glow_01.texture_sizes.corner[1]
			local str_20 = "new_icon" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture_frame",
				texture_id = str_20,
				style_id = str_20,
				content_check_function = function (self)
					-- function 52
					local var_52_0 = self["item" .. str]
					local var_52_1 = self[str_20]

					var_52_1 = not var_52_1 and not var_52_0 and ItemHelper.is_new_backend_id(var_52_0.backend_id)

					return var_52_1
				end,
				content_change_function = function (self, arg_53_1)
					-- function 53
					local var_53_0 = self["item" .. str]
					local flag = not var_53_0 and var_53_0.backend_id

					if not var_53_0 and not ItemHelper.is_new_backend_id(flag) then
						local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

						arg_53_1.color[1] = 55 + num * 200

						local var_53_3 = self[str_3]

						if var_53_3.on_hover_enter or not var_53_3.is_selected or not ItemHelper.is_new_backend_id(flag) then
							ItemHelper.unmark_backend_id_as_new(flag)
						end
					end
				end
			}
			tbl_8[str_20] = {
				size = {
					tbl_3[1] + var_28_39 * 2,
					tbl_3[2] + var_28_39 * 2
				},
				color = tbl,
				texture_size = frame_outer_glow_01.texture_size,
				texture_sizes = frame_outer_glow_01.texture_sizes,
				offset = {
					tbl_10[1] - var_28_39,
					tbl_10[2] - var_28_39,
					10
				}
			}
			tbl_7[str_20] = frame_outer_glow_01.texture
		end
	end

	tbl_5.element.passes = tbl_6
	tbl_5.content = tbl_7
	tbl_5.style = tbl_8

	local tbl_11

	if not arg_28_7 then
		tbl_11 = {}

		local var_28_42 = arg_28_7[1]

		var_28_42 = var_28_42 or 0
		tbl_11[1] = var_28_42

		local var_28_43 = arg_28_7[2]

		var_28_43 = var_28_43 or 0
		tbl_11[2] = var_28_43

		local var_28_44 = arg_28_7[3]

		var_28_44 = var_28_44 or 0
		tbl_11[3] = var_28_44

		if not tbl_11 then
			-- Nothing
		end
	end

	tbl_11 = {
		0,
		0,
		0
	}

	::label_28_0::

	tbl_5.offset = tbl_11
	tbl_5.scenegraph_id = arg_28_0

	return tbl_5
end

UIWidgets.create_simple_inventory_item = function (arg_54_0, arg_54_1)
	-- function 54
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local str = "button_hotspot"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "hotspot",
		content_id = str,
		style_id = str
	}
	tbl_4[str] = {
		size = arg_54_1,
		offset = {
			0,
			0,
			0
		}
	}
	tbl_3[str] = {
		is_selected = false,
		drag_texture_size = arg_54_1
	}

	local str_2 = "item_icon"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		texture_id = str_2,
		style_id = str_2,
		content_check_function = function (self)
			-- function 55
			return self[str_2]
		end
	}
	tbl_4[str_2] = {
		size = arg_54_1,
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

	UIWidgets.append_item_frame_pass("item_frame", tbl_2, tbl_3, tbl_4, arg_54_1, {
		0,
		0,
		4
	}, false, nil, nil, nil, function (self)
		-- function 56
		return self[str_2]
	end)

	local str_3 = "rarity_texture"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		texture_id = str_3,
		style_id = str_3,
		content_check_function = function (self)
			-- function 57
			return self[str_2]
		end
	}
	tbl_4[str_3] = {
		size = arg_54_1,
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
	tbl_3[str_3] = "icon_bg_default"

	local str_4 = "item_tooltip"

	tbl_2[#tbl_2 + 1] = {
		item_id = "item",
		pass_type = "item_tooltip",
		text_id = str_4,
		style_id = str_4,
		content_check_function = function (self)
			-- function 58
			local is_hover = self[str].is_hover

			is_hover = not is_hover and self[str_2]

			return is_hover
		end
	}
	tbl_4[str_4] = {
		font_size = 18,
		font_type = "hell_shark",
		localize = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		max_width = 500,
		size = arg_54_1,
		text_color = Colors.get_color_table_with_alpha("white", 255),
		line_colors = {
			Colors.get_color_table_with_alpha("font_title", 255),
			Colors.get_color_table_with_alpha("white", 255)
		},
		offset = {
			0,
			0,
			0
		}
	}
	tbl_3[str_4] = "tooltip_text"
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_54_0

	return tbl
end

UIWidgets.create_loadout_grid = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	-- function 59
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
		80,
		80
	}
	local tbl_4 = {
		80,
		80
	}
	local num = 1

	if not arg_59_4 then
		num = arg_59_2
		arg_59_2 = 1
	end

	local flag = arg_59_3 or 30
	local flag_2 = arg_59_3 or 30
	local var_59_9 = arg_59_1[1]
	local var_59_10 = arg_59_1[2]
	local tbl_5 = {
		element = {}
	}
	local tbl_6 = {}
	local tbl_7 = {}
	local tbl_8 = {
		rows = arg_59_2,
		columns = num,
		slots = arg_59_2 * num
	}
	local num_2 = var_59_9 - (num * tbl_4[1] + flag * (num - 1))
	local num_3 = var_59_10 - (arg_59_2 * tbl_4[2] + flag_2 * (arg_59_2 - 1))
	local tbl_9 = {}
	local num_4

	if not arg_59_4 then
		num_4 = num_2 / 2

		if not num_4 then
			-- Nothing
		end
	end

	num_4 = num_2 / 2

	::label_59_0::

	tbl_9[1] = num_4
	tbl_9[2] = var_59_10 - num_3 / 2 - tbl_4[2]

	local num_5 = 0

	for i = 1, arg_59_2 do
		for j = 1, num do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local num_6 = i - 1
			local num_7 = j - 1
			local tbl_10 = {
				tbl_9[1] + num_7 * (tbl_4[1] + flag),
				tbl_9[2] - num_6 * (tbl_4[2] + flag_2),
				num_5
			}
			local str_2 = "hotspot" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "hotspot",
				content_id = str_2,
				style_id = str_2
			}
			tbl_7[str_2] = {
				size = tbl_4,
				offset = tbl_10
			}
			tbl_8[str_2] = {
				drag_texture_size = tbl_4
			}

			local str_3 = "item_icon" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_3,
				style_id = str_3,
				content_check_function = function (self)
					-- function 60
					return self[str_3]
				end
			}
			tbl_7[str_3] = {
				size = tbl_3,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1],
					tbl_10[2],
					3
				}
			}

			UIWidgets.append_item_frame_pass("item_frame" .. str, tbl_6, tbl_8, tbl_7, tbl_3, {
				tbl_10[1],
				tbl_10[2],
				4
			}, false, str_2, nil, nil, function (self)
				-- function 61
				return self[str_3]
			end)

			local str_4 = "rarity_texture" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_4,
				style_id = str_4,
				content_check_function = function (self)
					-- function 62
					return self[str_2][str_3]
				end
			}
			tbl_7[str_4] = {
				size = tbl_3,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1],
					tbl_10[2],
					0
				}
			}
			tbl_8[str_4] = "icon_bg_default"

			local str_5 = "item_tooltip" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "item_tooltip",
				text_id = str_5,
				style_id = str_5,
				item_id = "item" .. str,
				content_check_function = function (self)
					-- function 63
					local is_hover = self[str_2].is_hover

					is_hover = not is_hover and self[str_2][str_3]

					return is_hover
				end
			}
			tbl_7[str_5] = {
				font_type = "hell_shark",
				localize = true,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				max_width = 500,
				size = tbl_4,
				offset = tbl_10,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("white", 255)
				},
				offset = tbl_10
			}
			tbl_8[str_5] = "tooltip_text"

			local str_6 = "slot" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_6,
				style_id = str_6,
				content_check_function = function (self)
					-- function 64
					return not self[str_3]
				end
			}
			tbl_7[str_6] = {
				size = tbl_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1],
					tbl_10[2],
					0
				}
			}
			tbl_8[str_2][str_6] = "menu_slot_frame_01"

			local str_7 = "slot_icon" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_7,
				style_id = str_7,
				content_check_function = function (self)
					-- function 65
					return not self[str_2][str_3]
				end
			}
			tbl_7[str_7] = {
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
					tbl_10[1] + (tbl_4[1] - 34) / 2,
					tbl_10[2] + (tbl_4[2] - 34) - (tbl_4[1] - 34) / 2,
					2
				}
			}
			tbl_8[str_7] = "tabs_icon_all_selected"

			local str_8 = "slot_hover" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_8,
				style_id = str_8,
				content_check_function = function (self)
					-- function 66
					local highlight = self.highlight

					highlight = highlight or self.is_hover

					return highlight
				end
			}
			tbl_7[str_8] = {
				size = {
					128,
					128
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1] - (128 - tbl_4[1]) / 2,
					tbl_10[2] - (128 - tbl_4[2]) / 2,
					0
				}
			}
			tbl_8[str_2][str_8] = "item_icon_hover"

			local str_9 = "slot_selected" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_9,
				style_id = str_9,
				content_check_function = function (self)
					-- function 67
					return self.is_selected
				end
			}
			tbl_7[str_9] = {
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
					tbl_10[1] - (80 - tbl_4[1]) / 2,
					tbl_10[2] - (80 - tbl_4[2]) / 2,
					8
				}
			}
			tbl_8[str_2][str_9] = "item_icon_selection"
		end
	end

	tbl_5.element.passes = tbl_6
	tbl_5.content = tbl_8
	tbl_5.style = tbl_7
	tbl_5.offset = {
		0,
		0,
		0
	}
	tbl_5.scenegraph_id = arg_59_0

	return tbl_5
end

UIWidgets.create_loadout_grid_console = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4, arg_68_5)
	-- function 68
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
		80,
		80
	}
	local tbl_4 = {
		80,
		80
	}
	local num = 1

	if not arg_68_4 then
		num = arg_68_2
		arg_68_2 = 1
	end

	local flag = arg_68_3 or 30
	local flag_2 = arg_68_3 or 30
	local var_68_9 = arg_68_1[1]
	local var_68_10 = arg_68_1[2]
	local tbl_5 = {
		element = {}
	}
	local tbl_6 = {}
	local tbl_7 = {}
	local tbl_8 = {
		rows = arg_68_2,
		columns = num,
		slots = arg_68_2 * num
	}
	local num_2 = var_68_9 - (num * tbl_4[1] + flag * (num - 1))
	local num_3 = var_68_10 - (arg_68_2 * tbl_4[2] + flag_2 * (arg_68_2 - 1))
	local tbl_9 = {}
	local num_4

	if not arg_68_4 then
		num_4 = num_2 / 2

		if not num_4 then
			-- Nothing
		end
	end

	num_4 = num_2 / 2

	::label_68_0::

	tbl_9[1] = num_4
	tbl_9[2] = var_68_10 - num_3 / 2 - tbl_4[2]

	local num_5 = 0

	for i = 1, arg_68_2 do
		for j = 1, num do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local num_6 = i - 1
			local num_7 = j - 1
			local tbl_10 = {
				tbl_9[1] + num_7 * (tbl_4[1] + flag),
				tbl_9[2] - num_6 * (tbl_4[2] + flag_2),
				num_5
			}
			local str_2 = "hotspot" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "hotspot",
				content_id = str_2,
				style_id = str_2
			}
			tbl_7[str_2] = {
				size = {
					tbl_4[1] + 414,
					tbl_4[2] + 40
				},
				offset = {
					tbl_10[1] - 20,
					tbl_10[2] - 20
				}
			}
			tbl_8[str_2] = {
				drag_texture_size = tbl_4
			}

			if not arg_68_5 then
				local tbl_11 = {
					58,
					58
				}
				local str_3 = "customize_hotspot" .. str

				tbl_6[#tbl_6 + 1] = {
					pass_type = "hotspot",
					content_id = str_3,
					style_id = str_3,
					content_check_function = function (self)
						-- function 69
						local current_mechanism_name = Managers.mechanism:current_mechanism_name()
						local var_69_1 = InventorySettings.customize_default_slot_types_allowed[current_mechanism_name]

						var_69_1 = var_69_1 or InventorySettings.customize_default_slot_types_allowed.default

						local str_2 = "item" .. str
						local parent = self.parent
						local var_69_4 = parent[str_2]

						if not var_69_4 then
							parent[str_2 .. "_disabled"] = true

							return false
						end

						local data = var_69_4.data
						local slot_type = data.slot_type
						local rarity = var_69_4.rarity

						if not rarity then
							rarity = data.rarity
							rarity = rarity or "default"
						end

						if not ((rarity == "default" or rarity == "promo") and var_69_1[slot_type]) then
							parent[str_2 .. "_disabled"] = true

							return false
						end

						return true
					end
				}
				tbl_7[str_3] = {
					vertical_alignment = "center",
					horizontal_alignment = "left",
					color = {
						255,
						96,
						96,
						96
					},
					size = tbl_11,
					texture_size = tbl_11,
					offset = {
						tbl_10[1] - tbl_11[1] - 25,
						tbl_10[2] + tbl_4[2] * 0.5 - tbl_11[2] * 0.5,
						30
					}
				}
				tbl_8[str_3] = {
					drag_texture_size = tbl_4
				}

				local str_4 = "customize_item" .. str

				tbl_6[#tbl_6 + 1] = {
					pass_type = "texture",
					texture_id = "customize_id",
					style_id = str_3,
					content_check_function = function (self)
						-- function 70
						if not self["item" .. str .. "_disabled"] then
							return false
						end

						return not self[str_3].is_hover
					end
				}
				tbl_8.customize_id = "cog_icon"

				local str_5 = "customize_item_hover" .. str

				tbl_6[#tbl_6 + 1] = {
					pass_type = "texture",
					texture_id = "customize_hover_id",
					style_id = str_5,
					content_check_function = function (self)
						-- function 71
						if not self["item" .. str .. "_disabled"] then
							return false
						end

						if not self.is_gamepad_active then
							return self["hotspot" .. str].is_selected
						else
							return self[str_3].is_hover
						end
					end
				}
				tbl_8.customize_hover_id = "cog_icon_selected"
				tbl_7[str_5] = {
					vertical_alignment = "center",
					horizontal_alignment = "left",
					color = {
						255,
						255,
						255,
						255
					},
					size = tbl_11,
					texture_size = tbl_11,
					offset = {
						tbl_10[1] - tbl_11[1] - 25,
						tbl_10[2] + tbl_4[2] * 0.5 - tbl_11[2] * 0.5,
						30
					}
				}
			end

			local str_6 = "tooltip_hotspot" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "hotspot",
				content_id = str_6,
				style_id = str_6
			}
			tbl_7[str_6] = {
				size = tbl_4,
				offset = tbl_10
			}
			tbl_8[str_6] = {
				drag_texture_size = tbl_4
			}

			local str_7 = "item_icon" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_7,
				style_id = str_7,
				content_check_function = function (self)
					-- function 72
					return self[str_7]
				end
			}
			tbl_7[str_7] = {
				size = tbl_3,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1],
					tbl_10[2],
					3
				}
			}

			UIWidgets.append_item_frame_pass("item_frame" .. str, tbl_6, tbl_8, tbl_7, tbl_3, {
				tbl_10[1],
				tbl_10[2],
				4
			}, false, str_2, nil, nil, function (self)
				-- function 73
				return self[str_7]
			end)

			local str_8 = "rarity_texture" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_8,
				style_id = str_8,
				content_check_function = function (self)
					-- function 74
					return self[str_2][str_7]
				end
			}
			tbl_7[str_8] = {
				size = tbl_3,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1],
					tbl_10[2],
					0
				}
			}
			tbl_8[str_8] = "icon_bg_default"

			local str_9 = "item" .. str
			local str_10 = "item_tooltip" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "item_tooltip",
				text_id = str_10,
				style_id = str_10,
				item_id = str_9,
				content_check_function = function (self)
					-- function 75
					local is_hover = self[str_6].is_hover

					is_hover = not is_hover and self[str_2][str_7]

					return is_hover
				end
			}
			tbl_7[str_10] = {
				font_type = "hell_shark",
				localize = true,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				max_width = 500,
				size = tbl_4,
				offset = tbl_10,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("white", 255)
				},
				offset = tbl_10
			}
			tbl_8[str_10] = "tooltip_text"

			local str_11 = "slot" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_11,
				style_id = str_11
			}
			tbl_7[str_11] = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = tbl_4,
				texture_size = {
					185,
					182
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1],
					tbl_10[2],
					-2
				}
			}
			tbl_8[str_2][str_11] = "loadout_item_slot_console"

			local str_12 = "title_bg" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture_uv",
				content_id = str_12,
				style_id = str_12
			}
			tbl_7[str_12] = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = tbl_4,
				texture_size = {
					414,
					118
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					tbl_10[1] + tbl_4[1] / 2,
					tbl_10[2],
					-5
				}
			}
			tbl_8[str_12] = {
				texture_id = "item_slot_side_fade",
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

			local str_13 = "title_bg_effect" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_13,
				style_id = str_13,
				content_check_function = function (self)
					-- function 76
					local var_76_0 = self[str_2]
					local highlight = var_76_0.highlight

					highlight = highlight or var_76_0.is_hover

					return highlight
				end
			}
			tbl_7[str_13] = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = tbl_4,
				texture_size = {
					414,
					126
				},
				color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					tbl_10[1] + tbl_4[1] / 2,
					tbl_10[2],
					-4
				}
			}
			tbl_8[str_13] = "item_slot_side_effect"

			local str_14 = "title_text" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "text",
				text_id = str_14,
				style_id = str_14,
				content_check_function = function (self)
					-- function 77
					local var_77_0 = self[str_2]
					local var_77_1 = self[str_9]

					var_77_1 = not var_77_1 and not not var_77_0.highlight or not var_77_0.is_hover

					return var_77_1
				end,
				content_change_function = function (self, arg_78_1)
					-- function 78
					local item_type = self[str_9].data.item_type

					self[str_14] = item_type
				end
			}
			tbl_7[str_14] = {
				font_size = 32,
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				size = tbl_4,
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					tbl_10[1] + 130,
					tbl_10[2] - 6,
					5
				}
			}
			tbl_8[str_14] = Localize("not_assigned")

			local str_15 = "title_text_selected" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "text",
				text_id = str_14,
				style_id = str_15,
				content_check_function = function (self)
					-- function 79
					local var_79_0 = self[str_2]
					local var_79_1 = self[str_9]

					if not var_79_1 then
						var_79_1 = var_79_0.highlight
						var_79_1 = var_79_1 or var_79_0.is_hover
					end

					return var_79_1
				end,
				content_change_function = function (self, arg_80_1)
					-- function 80
					local item_type = self[str_9].data.item_type

					self[str_14] = item_type
				end
			}
			tbl_7[str_15] = {
				font_size = 32,
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				size = tbl_4,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					tbl_10[1] + 130,
					tbl_10[2] - 6,
					5
				}
			}

			local str_16 = "title_shadow_text" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "text",
				text_id = str_14,
				style_id = str_16,
				content_check_function = function (self)
					-- function 81
					return self[str_9]
				end
			}
			tbl_7[str_16] = {
				font_size = 32,
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				size = tbl_4,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					tbl_10[1] + 130 + 2,
					tbl_10[2] - 8,
					4
				}
			}

			local str_17 = "sub_title_text" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "text",
				text_id = str_17,
				style_id = str_17,
				content_check_function = function (self)
					-- function 82
					return self[str_9]
				end,
				content_change_function = function (self, arg_83_1)
					-- function 83
					local var_83_0 = self[str_9]
					local get_ui_information_from_item, var_83_2 = UIUtils.get_ui_information_from_item(var_83_0)

					self[str_17] = var_83_2
				end
			}
			tbl_7[str_17] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				localize = true,
				font_size = 22,
				font_type = "hell_shark",
				size = tbl_4,
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					tbl_10[1] + 130,
					tbl_10[2] - 46,
					5
				}
			}
			tbl_8[str_2][str_17] = Localize("not_assigned")

			local str_18 = "sub_title_shadow_text" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "text",
				text_id = str_17,
				style_id = str_18,
				content_check_function = function (self)
					-- function 84
					return self[str_9]
				end
			}
			tbl_7[str_18] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				localize = true,
				font_size = 22,
				font_type = "hell_shark",
				size = tbl_4,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					tbl_10[1] + 130 + 2,
					tbl_10[2] - 48,
					4
				}
			}

			local str_19 = "slot_icon" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				texture_id = str_19,
				style_id = str_19,
				content_check_function = function (self)
					-- function 85
					return not self[str_2][str_7]
				end
			}
			tbl_7[str_19] = {
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
					tbl_10[1] + (tbl_4[1] - 34) / 2,
					tbl_10[2] + (tbl_4[2] - 34) - (tbl_4[1] - 34) / 2,
					2
				}
			}
			tbl_8[str_19] = "tabs_icon_all_selected"

			local str_20 = "slot_hover" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_20,
				style_id = str_20,
				content_check_function = function (self)
					-- function 86
					local highlight = self.highlight

					highlight = highlight or self.is_hover

					return highlight
				end
			}
			tbl_7[str_20] = {
				size = {
					185,
					182
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1] - (185 - tbl_4[1]) / 2,
					tbl_10[2] - (182 - tbl_4[2]) / 2,
					4
				}
			}
			tbl_8[str_2][str_20] = "loadout_item_slot_glow_console"

			local str_21 = "slot_selected" .. str

			tbl_6[#tbl_6 + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_21,
				style_id = str_21,
				content_check_function = function (self)
					-- function 87
					return self.is_selected
				end
			}
			tbl_7[str_21] = {
				size = {
					80,
					80
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					tbl_10[1] - (80 - tbl_4[1]) / 2,
					tbl_10[2] - (80 - tbl_4[2]) / 2,
					8
				}
			}
			tbl_8[str_2][str_21] = "item_icon_selection"
		end
	end

	tbl_5.element.passes = tbl_6
	tbl_5.content = tbl_8
	tbl_5.style = tbl_7
	tbl_5.offset = {
		0,
		0,
		0
	}
	tbl_5.scenegraph_id = arg_68_0

	return tbl_5
end

UIWidgets.create_inventory_statistics = function (arg_88_0, arg_88_1, arg_88_2)
	-- function 88
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("black", 220)
	local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("gray", 50)

	arg_88_2 = arg_88_2 or "menu_frame_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_88_2)
	local menu_frame_02 = UIFrameSettings.menu_frame_02
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			style_id = "background",
			pass_type = "texture_uv",
			content_id = "background"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "divider",
			texture_id = "divider"
		},
		{
			pass_type = "border",
			style_id = "inner_background_broder"
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "value_text",
			pass_type = "text",
			text_id = "value_text"
		},
		{
			style_id = "value_title_text",
			pass_type = "text",
			text_id = "value_title_text"
		}
	}
	local tbl_3 = {
		value_title_text = "n/a",
		value_text = "n/a",
		divider = "summary_screen_line_breaker",
		frame = menu_frame_02.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					arg_88_1[1] / get_atlas_settings_by_texture_name.size[1],
					arg_88_1[2] / get_atlas_settings_by_texture_name.size[2]
				}
			},
			texture_id = arg_88_2
		},
		title_text = Localize("lorebook_statistics")
	}
	local tbl_4 = {
		divider = {
			size = {
				350,
				22
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_88_1[1] / 2 - 175,
				arg_88_1[2] - 90,
				1
			}
		},
		background = {
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
		frame = {
			texture_size = menu_frame_02.texture_size,
			texture_sizes = menu_frame_02.texture_sizes,
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
		inner_background_broder = {
			thickness = 1,
			color = get_color_table_with_alpha_2,
			offset = {
				5,
				5,
				2
			},
			size = {
				arg_88_1[1] - 10,
				arg_88_1[2] - 10
			}
		},
		title_text = {
			vertical_alignment = "top",
			font_type = "hell_shark",
			font_size = 24,
			horizontal_alignment = "center",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				0,
				arg_88_1[2] - 55,
				2
			},
			size = {
				arg_88_1[1],
				30
			}
		},
		value_title_text = {
			vertical_alignment = "top",
			font_size = 18,
			horizontal_alignment = "left",
			word_wrap = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				15,
				0,
				3
			},
			size = {
				arg_88_1[1],
				arg_88_1[2] - 105
			}
		},
		value_text = {
			vertical_alignment = "top",
			font_size = 18,
			horizontal_alignment = "right",
			word_wrap = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				-15,
				0,
				3
			},
			size = {
				arg_88_1[1],
				arg_88_1[2] - 105
			}
		}
	}

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_88_0

	return tbl
end

UIWidgets.create_weapon_statistics = function (arg_89_0, arg_89_1)
	-- function 89
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_default", 255)
	local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("font_title", 255)
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			texture_id = "divider_right",
			style_id = "divider_left",
			pass_type = "texture"
		},
		{
			texture_id = "divider_left",
			style_id = "divider_right",
			pass_type = "texture"
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "title_text_left",
			pass_type = "text",
			text_id = "title_text_left"
		},
		{
			style_id = "title_text_right",
			pass_type = "text",
			text_id = "title_text_right"
		}
	}
	local tbl_3 = {
		title_text_left = "n/a",
		title_text = "n/a",
		divider_right = "journal_marker_left",
		title_text_right = "n/a",
		divider_left = "journal_marker_right"
	}
	local tbl_4 = {
		divider_left = {
			size = {
				124,
				13
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				arg_89_1[2] - 13,
				0
			}
		},
		divider_right = {
			size = {
				124,
				13
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				arg_89_1[1] - 124,
				arg_89_1[2] - 13,
				0
			}
		},
		background = {
			color = Colors.get_color_table_with_alpha("red", 10),
			offset = {
				0,
				0,
				0
			}
		},
		title_text = {
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = 18,
			horizontal_alignment = "center",
			text_color = get_color_table_with_alpha_2,
			offset = {
				0,
				arg_89_1[2] - 13,
				0
			},
			size = {
				arg_89_1[1],
				13
			}
		},
		title_text_left = {
			vertical_alignment = "bottom",
			font_type = "hell_shark",
			font_size = 18,
			horizontal_alignment = "left",
			text_color = get_color_table_with_alpha_2,
			offset = {
				5,
				arg_89_1[2] - 50,
				0
			},
			size = {
				arg_89_1[1],
				20
			}
		},
		title_text_right = {
			vertical_alignment = "bottom",
			font_type = "hell_shark",
			font_size = 18,
			horizontal_alignment = "right",
			text_color = get_color_table_with_alpha_2,
			offset = {
				-5,
				arg_89_1[2] - 50,
				0
			},
			size = {
				arg_89_1[1],
				20
			}
		}
	}

	for i = 1, 5 do
		local num = arg_89_1[2] - 20 * i - 50
		local tbl_5 = {
			2,
			0
		}
		local tbl_6 = {
			20,
			20
		}
		local str = "value_title_text_" .. i

		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			style_id = str,
			text_id = str,
			content_check_function = function (self)
				-- function 90
				return self[str]
			end
		}
		tbl_4[str] = {
			vertical_alignment = "center",
			word_wrap = true,
			horizontal_alignment = "center",
			font_size = 18,
			font_type = "hell_shark",
			text_color = get_color_table_with_alpha,
			offset = {
				0,
				num,
				0
			},
			size = {
				arg_89_1[1],
				20
			}
		}

		local str_2 = "stars_left_bg_" .. i

		tbl_2[#tbl_2 + 1] = {
			pass_type = "multi_texture",
			style_id = str_2,
			texture_id = str_2,
			content_check_function = function (self)
				-- function 91
				return self[str]
			end
		}
		tbl_4[str_2] = {
			direction = 1,
			axis = 1,
			draw_count = 5,
			texture_size = tbl_6,
			spacing = tbl_5,
			color = {
				255,
				50,
				50,
				50
			},
			offset = {
				5,
				num,
				3
			}
		}
		tbl_3[str_2] = {
			"stats_star",
			"stats_star",
			"stats_star",
			"stats_star",
			"stats_star"
		}

		local str_3 = "stars_left_1_" .. i

		tbl_2[#tbl_2 + 1] = {
			pass_type = "multi_texture",
			style_id = str_3,
			texture_id = str_3,
			content_check_function = function (self)
				-- function 92
				return self[str]
			end
		}
		tbl_4[str_3] = {
			direction = 1,
			axis = 1,
			draw_count = 0,
			texture_size = tbl_6,
			spacing = tbl_5,
			color = get_color_table_with_alpha,
			offset = {
				5,
				num,
				3
			}
		}
		tbl_3[str_3] = {
			"stats_star_left",
			"stats_star_left",
			"stats_star_left",
			"stats_star_left",
			"stats_star_left"
		}

		local str_4 = "stars_left_2_" .. i

		tbl_2[#tbl_2 + 1] = {
			pass_type = "multi_texture",
			style_id = str_4,
			texture_id = str_4,
			content_check_function = function (self)
				-- function 93
				return self[str]
			end
		}
		tbl_4[str_4] = {
			direction = 1,
			axis = 1,
			draw_count = 0,
			texture_size = tbl_6,
			spacing = tbl_5,
			color = get_color_table_with_alpha,
			offset = {
				5,
				num,
				3
			}
		}
		tbl_3[str_4] = {
			"stats_star_right",
			"stats_star_right",
			"stats_star_right",
			"stats_star_right",
			"stats_star_right"
		}

		local num_2 = arg_89_1[1] - 5 - (tbl_6[1] * 5 + tbl_5[1] * 4)
		local str_5 = "stars_right_bg_" .. i

		tbl_2[#tbl_2 + 1] = {
			pass_type = "multi_texture",
			style_id = str_5,
			texture_id = str_5,
			content_check_function = function (self)
				-- function 94
				return self[str]
			end
		}
		tbl_4[str_5] = {
			direction = 1,
			axis = 1,
			draw_count = 5,
			texture_size = tbl_6,
			spacing = tbl_5,
			color = {
				255,
				50,
				50,
				50
			},
			offset = {
				num_2,
				num,
				3
			}
		}
		tbl_3[str_5] = {
			"stats_star",
			"stats_star",
			"stats_star",
			"stats_star",
			"stats_star"
		}

		local str_6 = "stars_right_1_" .. i

		tbl_2[#tbl_2 + 1] = {
			pass_type = "multi_texture",
			style_id = str_6,
			texture_id = str_6,
			content_check_function = function (self)
				-- function 95
				return self[str]
			end
		}
		tbl_4[str_6] = {
			direction = 1,
			axis = 1,
			draw_count = 0,
			texture_size = tbl_6,
			spacing = tbl_5,
			color = get_color_table_with_alpha,
			offset = {
				num_2,
				num,
				3
			}
		}
		tbl_3[str_6] = {
			"stats_star_left",
			"stats_star_left",
			"stats_star_left",
			"stats_star_left",
			"stats_star_left"
		}

		local str_7 = "stars_right_2_" .. i

		tbl_2[#tbl_2 + 1] = {
			pass_type = "multi_texture",
			style_id = str_7,
			texture_id = str_7,
			content_check_function = function (self)
				-- function 96
				return self[str]
			end
		}
		tbl_4[str_7] = {
			direction = 1,
			axis = 1,
			draw_count = 0,
			texture_size = tbl_6,
			spacing = tbl_5,
			color = get_color_table_with_alpha,
			offset = {
				num_2,
				num,
				3
			}
		}
		tbl_3[str_7] = {
			"stats_star_right",
			"stats_star_right",
			"stats_star_right",
			"stats_star_right",
			"stats_star_right"
		}
	end

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_89_0

	return tbl
end

UIWidgets.create_background_with_frame = function (arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4, arg_97_5)
	-- function 97
	arg_97_2 = arg_97_2 or "menu_frame_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_97_2)
	local size

	if not get_atlas_settings_by_texture_name then
		size = get_atlas_settings_by_texture_name.size

		if not size then
			-- Nothing
		end
	end

	size = arg_97_1

	do
		local var_97_2
	end

	::label_97_0::

	if not arg_97_3 then
		var_97_2 = UIFrameSettings[arg_97_3]

		if not var_97_2 then
			-- Nothing
		end
	end

	var_97_2 = UIFrameSettings.menu_frame_02

	::label_97_1::

	local var_97_3

	if not arg_97_4 then
		var_97_3 = {
			{
				1 - math.min(arg_97_1[1] / size[1], 1),
				1 - math.min(arg_97_1[2] / size[2], 1)
			},
			{
				1,
				1
			}
		}
	else
		var_97_3 = {
			{
				0,
				0
			},
			{
				math.min(arg_97_1[1] / size[1], 1),
				math.min(arg_97_1[2] / size[2], 1)
			}
		}
	end

	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			style_id = "background",
			pass_type = "texture_uv",
			content_id = "background"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local tbl_3 = {
		frame = var_97_2.texture,
		background = {
			uvs = var_97_3,
			texture_id = arg_97_2
		}
	}
	local tbl_4 = {
		background = {
			color = arg_97_5 or {
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
		frame = {
			texture_size = var_97_2.texture_size,
			texture_sizes = var_97_2.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				10
			}
		}
	}

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_97_0

	return tbl
end

UIWidgets.create_rect_with_frame = function (arg_98_0, arg_98_1, arg_98_2, arg_98_3)
	-- function 98
	local var_98_0

	if not arg_98_3 then
		var_98_0 = UIFrameSettings[arg_98_3]

		if not var_98_0 then
			-- Nothing
		end
	end

	var_98_0 = UIFrameSettings.menu_frame_02

	::label_98_0::

	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local tbl_3 = {
		frame = var_98_0.texture
	}
	local tbl_4 = {
		background = {
			color = arg_98_2 or {
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
		frame = {
			texture_size = var_98_0.texture_size,
			texture_sizes = var_98_0.texture_sizes,
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
			}
		}
	}

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_98_0

	return tbl
end

UIWidgets.create_rect_with_inner_rect_frame = function (arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4)
	-- function 99
	local num = 1
	local num_2 = 1
	local tbl = {
		{
			style_id = "background",
			pass_type = "rect",
			retained_mode = arg_99_4
		},
		{
			style_id = "bot_rect",
			pass_type = "rect",
			retained_mode = arg_99_4
		},
		{
			style_id = "top_rect",
			pass_type = "rect",
			retained_mode = arg_99_4
		},
		{
			style_id = "left_rect",
			pass_type = "rect",
			retained_mode = arg_99_4
		},
		{
			style_id = "right_rect",
			pass_type = "rect",
			retained_mode = arg_99_4
		}
	}
	local tbl_2 = {}
	local tbl_3 = {
		background = {
			color = arg_99_2
		},
		bot_rect = {
			color = arg_99_3,
			size = {
				arg_99_1[1],
				num
			},
			offset = {
				0,
				0,
				num_2
			}
		},
		top_rect = {
			color = arg_99_3,
			size = {
				arg_99_1[1],
				num
			},
			offset = {
				0,
				arg_99_1[2] - num,
				num_2
			}
		},
		left_rect = {
			color = arg_99_3,
			size = {
				num,
				arg_99_1[2]
			},
			offset = {
				0,
				0,
				num_2
			}
		},
		right_rect = {
			color = arg_99_3,
			size = {
				num,
				arg_99_1[2]
			},
			offset = {
				arg_99_1[1] - num,
				0,
				num_2
			}
		}
	}

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
		scenegraph_id = arg_99_0
	}
end

UIWidgets.create_background = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3)
	-- function 100
	arg_100_2 = arg_100_2 or "menu_frame_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_100_2)
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			style_id = "background",
			pass_type = "texture_uv",
			content_id = "background"
		}
	}
	local tbl_3 = {
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_100_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
					math.min(arg_100_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
				}
			},
			texture_id = arg_100_2
		}
	}
	local tbl_4 = {
		background = {
			color = arg_100_3 or {
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
	}

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_100_0

	return tbl
end

UIWidgets.create_frame = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4, arg_101_5, arg_101_6, arg_101_7, arg_101_8, arg_101_9)
	-- function 101
	local var_101_0

	if not arg_101_2 then
		var_101_0 = UIFrameSettings[arg_101_2]

		if not var_101_0 then
			-- Nothing
		end
	end

	var_101_0 = UIFrameSettings.menu_frame_02

	::label_101_0::

	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local tbl_3 = {
		frame = var_101_0.texture
	}
	local tbl_4 = {
		frame = {
			masked = arg_101_6,
			frame_margins = arg_101_5,
			texture_size = var_101_0.texture_size,
			texture_sizes = var_101_0.texture_sizes,
			color = arg_101_4 or {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				arg_101_3 or 5
			},
			skip_background = arg_101_9,
			use_tiling = arg_101_7,
			mirrored_tiling = arg_101_8
		}
	}

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_101_0

	return tbl
end

UIWidgets.create_rect_with_outer_frame = function (arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6)
	-- function 102
	arg_102_4 = arg_102_4 or {
		255,
		255,
		255,
		255
	}

	local var_102_0

	if not arg_102_2 then
		var_102_0 = UIFrameSettings[arg_102_2]

		if not var_102_0 then
			-- Nothing
		end
	end

	var_102_0 = UIFrameSettings.frame_outer_fade_02

	::label_102_0::

	local var_102_1 = var_102_0.texture_sizes.horizontal[2]
	local tbl = {
		arg_102_1[1] + var_102_1 * 2,
		arg_102_1[2] + var_102_1 * 2
	}
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "rect",
			style_id = "rect"
		}
	}
	local tbl_4 = {
		frame = var_102_0.texture
	}
	local tbl_5 = {
		frame = {
			color = arg_102_5 or arg_102_4,
			size = tbl,
			texture_size = var_102_0.texture_size,
			texture_sizes = var_102_0.texture_sizes,
			offset = {
				-var_102_1,
				-var_102_1,
				arg_102_6 or arg_102_3 or 0
			}
		},
		rect = {
			color = arg_102_4,
			offset = {
				0,
				0,
				arg_102_3 or 0
			}
		}
	}

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = arg_102_0

	return tbl_2
end

UIWidgets.create_craft_recipe_window = function (arg_103_0, arg_103_1, arg_103_2, arg_103_3)
	-- function 103
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("white", 255)
	local flag = arg_103_3 or "menu_frame_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(flag)
	local num = arg_103_1[1] * 0.3
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			style_id = "background",
			pass_type = "texture_uv",
			content_id = "background"
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "sub_title_text",
			pass_type = "text",
			text_id = "sub_title_text"
		},
		{
			style_id = "description_text",
			pass_type = "text",
			text_id = "description_text"
		},
		{
			texture_id = "component_divider",
			style_id = "component_divider_top",
			pass_type = "texture"
		}
	}
	local tbl_3 = {
		component_divider = "journal_page_divider_01_large",
		title_text = "n/a",
		sub_title_text = "n/a",
		description_text = "n/a",
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					arg_103_1[1] / get_atlas_settings_by_texture_name.size[1],
					arg_103_1[2] / get_atlas_settings_by_texture_name.size[2]
				}
			},
			texture_id = flag
		}
	}
	local tbl_4 = {
		component_divider_top = {
			size = {
				430,
				20
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_103_1[1] / 2 - 215,
				arg_103_1[2] - 110,
				1
			}
		},
		background = {
			color = get_color_table_with_alpha
		},
		title_text = {
			vertical_alignment = "top",
			font_type = "hell_shark_header",
			font_size = 32,
			horizontal_alignment = "center",
			text_color = Colors.get_color_table_with_alpha("loading_screen_stone", 255),
			offset = {
				20,
				arg_103_1[2] - 35,
				3
			},
			size = {
				arg_103_1[1] - 40,
				30
			}
		},
		sub_title_text = {
			vertical_alignment = "center",
			font_size = 20,
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("loading_screen_stone", 255),
			offset = {
				20,
				arg_103_1[2] - 75,
				3
			},
			size = {
				arg_103_1[1] - 40,
				30
			}
		},
		description_text = {
			vertical_alignment = "top",
			font_size = 18,
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("loading_screen_stone", 255),
			offset = {
				20,
				arg_103_1[2] - 130,
				2
			},
			size = {
				arg_103_1[1] - 40,
				30
			}
		}
	}
	local tbl_5 = {
		50,
		50
	}
	local tbl_6 = {
		20,
		arg_103_1[2] - tbl_5[1] - 230,
		3
	}
	local var_103_10 = tbl_5[2]
	local num_2 = 20

	tbl_3.component_amount = arg_103_2

	for i = 1, arg_103_2 do
		local num_3 = i - 1
		local str = "_" .. tostring(i)
		local tbl_7 = {
			tbl_6[1],
			tbl_6[2] - (num_3 * var_103_10 + num_3 * num_2),
			tbl_6[3]
		}
		local str_2 = "component_active" .. str

		tbl_3[str_2] = false

		local str_3 = "component_icon" .. str

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			texture_id = str_3,
			style_id = str_3,
			content_check_function = function (self)
				-- function 104
				return self[str_2]
			end
		}
		tbl_4[str_3] = {
			size = tbl_5,
			offset = tbl_7,
			color = get_color_table_with_alpha
		}
		tbl_3[str_3] = "icons_placeholder"

		local str_4 = "component_text" .. str

		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			text_id = str_4,
			style_id = str_4,
			content_check_function = function (self)
				-- function 105
				return self[str_2]
			end
		}
		tbl_4[str_4] = {
			horizontal_alignment = "left",
			font_size = 24,
			word_wrap = true,
			vertical_alignment = "center",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("loading_screen_stone", 255),
			size = {
				arg_103_1[1] - tbl_6[1] * 2 - tbl_5[1] - 5,
				tbl_5[2]
			},
			offset = {
				tbl_7[1] + tbl_5[1] + 5,
				tbl_7[2],
				tbl_7[3]
			},
			color = get_color_table_with_alpha
		}
		tbl_3[str_4] = Localize("not_assigned")
	end

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_103_0

	return tbl
end

UIWidgets.create_hero_view_button = function (arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4)
	-- function 106
	arg_106_3 = arg_106_3 or "button_frame_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_106_3)
	local menu_frame_glass_01 = UIFrameSettings.menu_frame_glass_01
	local menu_frame_04 = UIFrameSettings.menu_frame_04

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (self)
						-- function 107
						return not self.disabled
					end
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					pass_type = "texture_frame",
					style_id = "glas_frame",
					texture_id = "glas_frame",
					content_check_function = function (self)
						-- function 108
						return not not self.button_hotspot.disabled or self.button_hotspot.is_clicked > 0
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "glas_frame_pressed",
					texture_id = "glas_frame",
					content_check_function = function (self)
						-- function 109
						local disabled = self.button_hotspot.disabled

						disabled = disabled or self.button_hotspot.is_clicked == 0

						return disabled
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 110
						return not self.button_hotspot.disabled
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 111
						return self.button_hotspot.disabled
					end
				},
				{
					pass_type = "texture",
					style_id = "arrow_left",
					texture_id = "arrow_left"
				},
				{
					pass_type = "texture",
					style_id = "arrow_right",
					texture_id = "arrow_right"
				},
				{
					pass_type = "texture",
					style_id = "arrow_top",
					texture_id = "arrow_top"
				},
				{
					pass_type = "texture",
					style_id = "arrow_bottom",
					texture_id = "arrow_bottom"
				}
			}
		},
		content = {
			arrow_bottom = "menu_frame_04_bottom",
			arrow_right = "menu_frame_04_right",
			arrow_left = "menu_frame_04_left",
			arrow_top = "menu_frame_04_top",
			button_hotspot = {},
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						arg_106_1[1] / get_atlas_settings_by_texture_name.size[1],
						arg_106_1[2] / get_atlas_settings_by_texture_name.size[2]
					}
				},
				texture_id = arg_106_3
			},
			text = arg_106_2 or "n/a",
			frame = menu_frame_04.texture,
			glas_frame = menu_frame_glass_01.texture
		},
		style = {
			arrow_left = {
				size = {
					17,
					21
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-9,
					arg_106_1[2] / 2 - 10.5,
					5
				}
			},
			arrow_right = {
				size = {
					17,
					21
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_106_1[1] - 8,
					arg_106_1[2] / 2 - 10.5,
					5
				}
			},
			arrow_top = {
				size = {
					21,
					17
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_106_1[1] / 2 - 8.5,
					arg_106_1[2] - 8,
					5
				}
			},
			arrow_bottom = {
				size = {
					21,
					17
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_106_1[1] / 2 - 8.5,
					-9,
					5
				}
			},
			text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				size = {
					arg_106_1[1] - menu_frame_04.texture_sizes.horizontal[2] * 2,
					arg_106_1[2] - menu_frame_04.texture_sizes.vertical[1] * 2
				},
				offset = {
					menu_frame_04.texture_sizes.horizontal[2],
					menu_frame_04.texture_sizes.vertical[1],
					2
				}
			},
			text_disabled = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				size = {
					arg_106_1[1] - menu_frame_04.texture_sizes.horizontal[2] * 2,
					arg_106_1[2] - menu_frame_04.texture_sizes.vertical[1] * 2
				},
				offset = {
					menu_frame_04.texture_sizes.horizontal[2],
					menu_frame_04.texture_sizes.vertical[1],
					2
				}
			},
			frame = {
				offset = {
					0,
					0,
					4
				},
				size = arg_106_1,
				texture_size = menu_frame_04.texture_size,
				texture_sizes = menu_frame_04.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				}
			},
			glas_frame = {
				size = {
					arg_106_1[1] - menu_frame_04.texture_sizes.horizontal[2] * 2,
					arg_106_1[2] - menu_frame_04.texture_sizes.vertical[1] * 2
				},
				texture_size = menu_frame_glass_01.texture_size,
				texture_sizes = menu_frame_glass_01.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					menu_frame_04.texture_sizes.horizontal[2],
					menu_frame_04.texture_sizes.vertical[1],
					3
				}
			},
			glas_frame_pressed = {
				size = {
					arg_106_1[1] - menu_frame_04.texture_sizes.horizontal[2] * 2,
					arg_106_1[2] - menu_frame_04.texture_sizes.vertical[1] * 2
				},
				texture_size = menu_frame_glass_01.texture_size,
				texture_sizes = menu_frame_glass_01.texture_sizes,
				color = {
					150,
					255,
					255,
					255
				},
				offset = {
					menu_frame_04.texture_sizes.horizontal[2],
					menu_frame_04.texture_sizes.vertical[1],
					3
				}
			},
			background = {
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
				masked = arg_106_4
			},
			texture_id = {
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
				},
				masked = arg_106_4
			},
			texture_hover_id = {
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
				masked = arg_106_4
			},
			texture_selected_id = {
				size = {
					100,
					100
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-25,
					-25,
					0
				},
				masked = arg_106_4
			}
		},
		scenegraph_id = arg_106_0
	}
end

UIWidgets.create_reward_slot_grid = function (arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4, arg_112_5, arg_112_6)
	-- function 112
	local tbl = {
		255,
		255,
		255,
		255
	}
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("dim_gray", 50)
	local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("gray", 50)
	local get_color_table_with_alpha_3 = Colors.get_color_table_with_alpha("font_title", 50)
	local get_color_table_with_alpha_4 = Colors.get_color_table_with_alpha("white", 150)
	local num = 10
	local num_2 = 10
	local var_112_7 = arg_112_1[1]
	local var_112_8 = arg_112_1[2]
	local num_3 = var_112_7 - (arg_112_5 * arg_112_2[1] + num * (arg_112_5 - 1))
	local num_4 = var_112_8 - (arg_112_4 * arg_112_2[2] + num_2 * (arg_112_4 - 1))
	local tbl_2 = {
		num_3 / 2 + arg_112_3[1],
		var_112_8 - num_4 / 2 - arg_112_2[2] + arg_112_3[2]
	}
	local tbl_3 = {
		element = {}
	}
	local tbl_4 = {}
	local tbl_5 = {
		rows = arg_112_4,
		columns = arg_112_5,
		slots = arg_112_4 * arg_112_5
	}
	local tbl_6 = {}
	local num_5 = 0

	for i = 1, arg_112_4 do
		for j = 1, arg_112_5 do
			local str = "_" .. tostring(i) .. "_" .. tostring(j)
			local num_6 = i - 1
			local num_7 = j - 1
			local tbl_7 = {
				tbl_2[1] + num_7 * (arg_112_2[1] + num),
				tbl_2[2] - num_6 * (arg_112_2[2] + num_2),
				num_5
			}
			local str_2 = "hotspot" .. str

			tbl_4[#tbl_4 + 1] = {
				pass_type = "hotspot",
				content_id = str_2,
				style_id = str_2
			}
			tbl_6[str_2] = {
				size = arg_112_2,
				offset = tbl_7
			}
			tbl_5[str_2] = {
				drag_texture_size = arg_112_2
			}

			local str_3 = "item_icon" .. str

			tbl_4[#tbl_4 + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_3,
				style_id = str_3,
				content_check_function = function (self)
					-- function 113
					return self[str_3]
				end
			}
			tbl_6[str_3] = {
				size = arg_112_2,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_7[1] + (arg_112_2[1] - arg_112_2[1]) / 2,
					tbl_7[2] + (arg_112_2[2] - arg_112_2[2]) - (arg_112_2[1] - arg_112_2[1]) / 2,
					4
				}
			}

			local str_4 = "slot_bg" .. str

			tbl_4[#tbl_4 + 1] = {
				pass_type = "rounded_background",
				style_id = str_4
			}
			tbl_6[str_4] = {
				corner_radius = 0,
				size = arg_112_2,
				color = get_color_table_with_alpha,
				offset = {
					tbl_7[1] + (arg_112_2[1] - arg_112_2[1]) / 2,
					tbl_7[2] + (arg_112_2[2] - arg_112_2[2]) - (arg_112_2[1] - arg_112_2[1]) / 2,
					2
				}
			}

			local str_5 = "slot_border" .. str

			tbl_4[#tbl_4 + 1] = {
				pass_type = "texture_frame",
				content_id = str_2,
				texture_id = str_5,
				style_id = str_5
			}

			local menu_frame_01 = UIFrameSettings.menu_frame_01

			tbl_6[str_5] = {
				size = arg_112_2,
				texture_size = menu_frame_01.texture_size,
				texture_sizes = menu_frame_01.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_7[1],
					tbl_7[2],
					5
				}
			}
			tbl_5[str_2][str_5] = menu_frame_01.texture

			local str_6 = "slot_glow_hover" .. str

			tbl_4[#tbl_4 + 1] = {
				pass_type = "rounded_background",
				content_id = str_2,
				style_id = str_6,
				content_check_function = function (self)
					-- function 114
					return self.is_hover
				end
			}
			tbl_6[str_6] = {
				corner_radius = 0,
				size = arg_112_2,
				color = get_color_table_with_alpha_2,
				offset = {
					tbl_7[1] + (arg_112_2[1] - arg_112_2[1]) / 2,
					tbl_7[2] + (arg_112_2[2] - arg_112_2[2]) - (arg_112_2[1] - arg_112_2[1]) / 2,
					2
				}
			}

			local str_7 = "slot_glow_selected" .. str

			tbl_4[#tbl_4 + 1] = {
				pass_type = "rounded_background",
				content_id = str_2,
				style_id = str_7,
				content_check_function = function (self)
					-- function 115
					return self.is_selected
				end
			}
			tbl_6[str_7] = {
				corner_radius = 0,
				size = arg_112_2,
				color = get_color_table_with_alpha_3,
				offset = {
					tbl_7[1] + (arg_112_2[1] - arg_112_2[1]) / 2,
					tbl_7[2] + (arg_112_2[2] - arg_112_2[2]) - (arg_112_2[1] - arg_112_2[1]) / 2,
					2
				}
			}

			local str_8 = "item_tooltip" .. str

			tbl_5[str_8] = {}
			tbl_4[#tbl_4 + 1] = {
				pass_type = "generic_tooltip",
				style_id = str_8,
				content_id = str_2,
				content_check_function = function (self)
					-- function 116
					local is_hover = self.is_hover

					is_hover = not is_hover and self[str_8]

					return is_hover
				end
			}
			tbl_6[str_8] = {
				font_size = 18,
				font_type = "hell_shark",
				horizontal_alignment = "left",
				vertical_alignment = "top",
				max_width = 500,
				size = arg_112_2,
				offset = {
					tbl_7[1] + (arg_112_2[1] - arg_112_2[1]) / 2,
					tbl_7[2] + (arg_112_2[2] - arg_112_2[2]) - (arg_112_2[1] - arg_112_2[1]) / 2,
					2
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				text_styles = {},
				value_styles = {}
			}
		end
	end

	tbl_3.element.passes = tbl_4
	tbl_3.content = tbl_5
	tbl_3.style = tbl_6
	tbl_3.offset = {
		0,
		0,
		0
	}
	tbl_3.scenegraph_id = arg_112_0

	return tbl_3
end

UIWidgets.create_reward_card = function (arg_117_0, arg_117_1)
	-- function 117
	local tbl = {
		255,
		255,
		255,
		255
	}
	local tbl_2 = {
		220,
		20,
		15,
		15
	}
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("dim_gray", 40)
	local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("white", 150)
	local tbl_3 = {
		300,
		300
	}
	local tbl_4 = {
		arg_117_1[1] / 2 - tbl_3[1] / 2,
		arg_117_1[2] - tbl_3[2] - math.floor(arg_117_1[2] * 0.1),
		3
	}
	local tbl_5 = {
		element = {}
	}
	local tbl_6 = {}
	local tbl_7 = {}
	local tbl_8 = {}
	local str = "button_hotspot"

	tbl_6[#tbl_6 + 1] = {
		pass_type = "hotspot",
		content_id = str,
		style_id = str
	}
	tbl_8[str] = {
		size = arg_117_1,
		offset = {
			0,
			0,
			0
		}
	}
	tbl_7[str] = {
		disable_button = true,
		is_selected = false,
		drag_texture_size = arg_117_1
	}

	local str_2 = "item_icon"

	tbl_6[#tbl_6 + 1] = {
		pass_type = "texture",
		content_id = str,
		texture_id = str_2,
		style_id = str_2,
		content_check_function = function (self)
			-- function 118
			return not not self.disable_button or self[str_2]
		end
	}
	tbl_8[str_2] = {
		size = tbl_3,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_4[1],
			tbl_4[2],
			tbl_4[3] + 3
		}
	}
	tbl_7[str][str_2] = "icons_placeholder"

	local str_3 = "can_use_texture"

	tbl_6[#tbl_6 + 1] = {
		pass_type = "centered_texture_amount",
		texture_id = str_3,
		style_id = str_3,
		content_check_function = function (self)
			-- function 119
			return self[str][str_2]
		end
	}
	tbl_8[str_3] = {
		texture_axis = 1,
		spacing = 5,
		texture_amount = 0,
		texture_size = {
			40,
			40
		},
		size = {
			arg_117_1[1],
			20
		},
		color = {
			255,
			0,
			0,
			0
		},
		offset = {
			0,
			60,
			4
		}
	}
	tbl_7[str_3] = {
		"stats_star",
		"stats_star",
		"stats_star",
		"stats_star",
		"stats_star"
	}

	local str_4 = "item_title_text"

	tbl_6[#tbl_6 + 1] = {
		pass_type = "text",
		text_id = str_4,
		style_id = str_4
	}
	tbl_8[str_4] = {
		vertical_alignment = "bottom",
		font_size = 32,
		horizontal_alignment = "center",
		word_wrap = true,
		font_type = "hell_shark",
		size = {
			arg_117_1[1] - 20,
			tbl_4[2] - 40
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			10,
			tbl_4[2] - 40,
			tbl_4[3] + 4
		}
	}
	tbl_7[str_4] = Localize("not_assigned")

	local str_5 = "item_type_text"

	tbl_6[#tbl_6 + 1] = {
		pass_type = "text",
		text_id = str_5,
		style_id = str_5
	}
	tbl_8[str_5] = {
		vertical_alignment = "top",
		font_size = 24,
		horizontal_alignment = "center",
		word_wrap = true,
		font_type = "hell_shark",
		size = {
			arg_117_1[1] - 20,
			tbl_4[2] - 40
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			10,
			0,
			tbl_4[3] + 4
		}
	}
	tbl_7[str_5] = Localize("not_assigned")
	tbl_5.element.passes = tbl_6
	tbl_5.content = tbl_7
	tbl_5.style = tbl_8
	tbl_5.offset = {
		0,
		0,
		0
	}
	tbl_5.scenegraph_id = arg_117_0

	return tbl_5
end

UIWidgets.create_score_topic = function (arg_120_0, arg_120_1)
	-- function 120
	local str = "menu_frame_bg_04"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local str_2 = "menu_frame_bg_02"
	local get_atlas_settings_by_texture_name_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)
	local tbl = {
		148,
		163
	}
	local tbl_2 = {
		arg_120_1[1] / 2 - tbl[1] / 2,
		arg_120_1[2] / 2 - tbl[2] / 2,
		3
	}
	local menu_frame_03 = UIFrameSettings.menu_frame_03

	return {
		element = {
			passes = {
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 121
						return self.icon
					end
				},
				{
					texture_id = "icon_bg",
					style_id = "icon_bg",
					pass_type = "texture"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				}
			}
		},
		content = {
			title_text = "n/a",
			icon_bg = "scoreboard_topic_01",
			description_text = "n/a",
			frame = menu_frame_03.texture,
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						arg_120_1[1] / get_atlas_settings_by_texture_name.size[1],
						arg_120_1[2] / get_atlas_settings_by_texture_name.size[2]
					}
				},
				texture_id = str
			}
		},
		style = {
			description_text = {
				default_font_size = 48,
				word_wrap = true,
				font_size = 48,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 0),
				size = {
					arg_120_1[1] * 0.8,
					arg_120_1[2] / 2
				},
				offset = {
					arg_120_1[1] * 0.1,
					10,
					5
				},
				default_offset = {
					arg_120_1[1] * 0.1,
					10,
					5
				}
			},
			title_text = {
				default_font_size = 24,
				word_wrap = true,
				font_size = 24,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 0),
				size = {
					arg_120_1[1] * 0.8,
					arg_120_1[2] * 0.3
				},
				offset = {
					arg_120_1[1] * 0.1,
					arg_120_1[2] * 0.72,
					5
				},
				default_offset = {
					arg_120_1[1] * 0.1,
					arg_120_1[2] * 0.72,
					5
				}
			},
			frame = {
				texture_size = menu_frame_03.texture_size,
				texture_sizes = menu_frame_03.texture_sizes,
				color = {
					0,
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
				size = arg_120_1,
				color = {
					0,
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
			icon = {
				size = tbl,
				default_size = tbl,
				offset = {
					tbl_2[1],
					tbl_2[2],
					tbl_2[3] + 1
				},
				default_offset = {
					tbl_2[1],
					tbl_2[2],
					tbl_2[3] + 1
				},
				color = Colors.get_color_table_with_alpha("white", 0)
			},
			icon_bg = {
				size = tbl,
				offset = tbl_2,
				default_size = tbl,
				default_offset = tbl_2,
				color = {
					0,
					40,
					40,
					40
				}
			}
		},
		scenegraph_id = arg_120_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_experience_entry = function (arg_122_0, arg_122_1)
	-- function 122
	return {
		element = {
			passes = {
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				}
			}
		},
		content = {
			description_text = "n/a",
			title_text = "n/a"
		},
		style = {
			title_text = {
				vertical_alignment = "bottom",
				font_size = 24,
				horizontal_alignment = "center",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 0),
				offset = {
					0,
					0,
					0
				}
			},
			description_text = {
				vertical_alignment = "top",
				font_type = "hell_shark",
				font_size = 20,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("font_title", 0),
				offset = {
					0,
					-arg_122_1[2],
					0
				}
			}
		},
		scenegraph_id = arg_122_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_background_masked_text = function (arg_123_0, arg_123_1, arg_123_2, arg_123_3, arg_123_4, arg_123_5, arg_123_6, arg_123_7, arg_123_8)
	-- function 123
	arg_123_3 = arg_123_3 or "reward_pop_up_item_bg"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_123_3)
	local tbl = {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					retained_mode = arg_123_8
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background",
					retained_mode = arg_123_8
				}
			}
		}
	}
	local tbl_2 = {
		text = arg_123_2
	}
	local text_color

	if not arg_123_6 then
		text_color = arg_123_6.text_color

		if not text_color then
			-- Nothing
		end
	end

	text_color = arg_123_5

	::label_123_0::

	tbl_2.color = text_color
	tbl_2.background = {
		uvs = {
			{
				0,
				0
			},
			{
				math.min(arg_123_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
				math.min(arg_123_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
			}
		},
		texture_id = arg_123_3
	}
	tbl.content = tbl_2
	tbl.style = {
		text = arg_123_6 or {
			vertical_alignment = "center",
			localize = true,
			horizontal_alignment = "center",
			word_wrap = true,
			font_size = arg_123_4 or 24,
			font_type = arg_123_7 or "hell_shark_write_mask",
			text_color = arg_123_5,
			offset = {
				0,
				0,
				2
			}
		},
		background = {
			masked = true,
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
	}
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_123_0

	return tbl
end

UIWidgets.create_summary_entry = function (arg_124_0, arg_124_1, arg_124_2)
	-- function 124
	return {
		element = {
			passes = {
				{
					style_id = "summary_text",
					pass_type = "text",
					text_id = "summary_text"
				},
				{
					style_id = "summary_text_shadow",
					pass_type = "text",
					text_id = "summary_text"
				},
				{
					style_id = "xp_text",
					pass_type = "text",
					text_id = "xp_text"
				},
				{
					style_id = "xp_text_shadow",
					pass_type = "text",
					text_id = "xp_text"
				}
			}
		},
		content = {
			xp_text = "n/a",
			summary_text = "n/a"
		},
		style = {
			summary_text = {
				vertical_alignment = "center",
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				font_size = 26,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 0),
				offset = {
					0,
					0,
					2
				}
			},
			summary_text_shadow = {
				vertical_alignment = "center",
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				font_size = 26,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 0),
				offset = {
					2,
					-2,
					1
				}
			},
			xp_text = {
				vertical_alignment = "center",
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "right",
				font_size = 26,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 0),
				offset = {
					0,
					0,
					2
				}
			},
			xp_text_shadow = {
				vertical_alignment = "center",
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "right",
				font_size = 26,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 0),
				offset = {
					2,
					-2,
					1
				}
			}
		},
		scenegraph_id = arg_124_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_chest_score_entry = function (arg_125_0, arg_125_1, arg_125_2)
	-- function 125
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					pass_type = "texture",
					style_id = "texture_id_saturated",
					texture_id = "texture_id"
				},
				{
					pass_type = "texture",
					style_id = "texture_id_glow",
					texture_id = "texture_id_glow"
				},
				{
					pass_type = "texture",
					style_id = "checkbox",
					texture_id = "checkbox"
				},
				{
					pass_type = "texture",
					style_id = "checkbox_shadow",
					texture_id = "checkbox"
				},
				{
					pass_type = "texture",
					style_id = "marker",
					texture_id = "marker"
				}
			}
		},
		content = {
			text = "n/a",
			texture_id_glow = "icons_placeholder",
			texture_id = "icons_placeholder",
			marker = "tooltip_marker",
			checkbox = "matchmaking_checkbox"
		},
		style = {
			marker = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					13,
					13
				},
				default_size = {
					13,
					13
				},
				color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					-10,
					0,
					1
				}
			},
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					80,
					90
				},
				default_size = {
					80,
					90
				},
				color = {
					0,
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
			texture_id_saturated = {
				vertical_alignment = "center",
				saturated = true,
				horizontal_alignment = "left",
				texture_size = {
					80,
					90
				},
				default_size = {
					80,
					90
				},
				color = {
					255,
					100,
					100,
					100
				},
				offset = {
					0,
					0,
					0
				}
			},
			checkbox = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					37,
					31
				},
				default_size = {
					37,
					31
				},
				color = Colors.get_color_table_with_alpha("green", 0),
				offset = {
					-18,
					4,
					7
				}
			},
			checkbox_shadow = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					37,
					31
				},
				default_size = {
					37,
					31
				},
				color = Colors.get_color_table_with_alpha("black", 0),
				offset = {
					-16,
					2,
					6
				}
			},
			texture_id_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					80,
					90
				},
				default_size = {
					80,
					90
				},
				color = Colors.get_color_table_with_alpha("font_title", 0),
				offset = {
					0,
					0,
					2
				}
			},
			text = {
				font_size = 20,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 0),
				offset = {
					80,
					0,
					2
				},
				size = {
					arg_125_1[1] - 80,
					arg_125_1[2]
				}
			},
			text_disabled = {
				font_size = 20,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = false,
				font_type = "hell_shark",
				text_color = {
					255,
					50,
					50,
					50
				},
				offset = {
					80,
					0,
					2
				},
				size = {
					arg_125_1[1] - 80,
					arg_125_1[2]
				}
			},
			text_shadow = {
				font_size = 20,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					82,
					-2,
					1
				},
				size = {
					arg_125_1[1] - 80,
					arg_125_1[2]
				}
			}
		},
		scenegraph_id = arg_125_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_score_list = function (arg_126_0, arg_126_1, arg_126_2)
	-- function 126
	local str = "menu_frame_bg_01"
	local str_2 = "scoreboard_bg"
	local str_3 = "scoreboard_bg_top"
	local str_4 = "scoreboard_topic_bg"
	local str_5 = "scoreboard_divider_01"
	local str_6 = "scoreboard_divider_02"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local get_atlas_settings_by_texture_name_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)
	local get_atlas_settings_by_texture_name_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_3)
	local get_atlas_settings_by_texture_name_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_4)
	local get_atlas_settings_by_texture_name_5 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_5)
	local get_atlas_settings_by_texture_name_6 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_6)
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local num = 24
	local num_2 = 39
	local num_3 = 0
	local tbl = {
		arg_126_1[1],
		num_2 + num_3
	}
	local tbl_2 = {
		arg_126_1[1],
		get_atlas_settings_by_texture_name_6.size[2]
	}
	local num_4 = -100
	local num_5 = -120
	local tbl_3 = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		}
	}
	local tbl_4 = {
		button_hotspot = {},
		frame = menu_frame_06.texture,
		rows = arg_126_2
	}
	local tbl_5 = {
		frame = {
			texture_size = menu_frame_06.texture_size,
			texture_sizes = menu_frame_06.texture_sizes,
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

	for i = 1, arg_126_2 do
		local str_7 = "_" .. tostring(i)
		local tbl_6 = {
			0,
			arg_126_1[2] - (num_2 + num_3) * i + num_5,
			0
		}
		local str_8 = "hotspot" .. str_7

		tbl_3[#tbl_3 + 1] = {
			pass_type = "hotspot",
			content_id = str_8,
			style_id = str_8
		}
		tbl_4[str_8] = {
			hover_texture_size = tbl,
			vertical_divider_texture_id = str_5
		}
		tbl_5[str_8] = {
			size = tbl,
			offset = {
				tbl_6[1],
				tbl_6[2],
				tbl_6[3]
			}
		}

		local str_9 = "row_bg" .. str_7

		tbl_3[#tbl_3 + 1] = {
			texture_id = "hover_texture_id",
			pass_type = "tiled_texture",
			content_id = str_9,
			style_id = str_9,
			content_check_function = function (self)
				-- function 127
				return self.has_background
			end
		}
		tbl_4[str_9] = {
			hover_texture_id = "scoreboard_topic_bg",
			has_background = false
		}
		tbl_5[str_9] = {
			size = tbl,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1],
				tbl_6[2],
				tbl_6[3] + 10
			},
			texture_tiling_size = get_atlas_settings_by_texture_name_4.size
		}

		local str_10 = "horizontal_divider" .. str_7

		tbl_3[#tbl_3 + 1] = {
			texture_id = "horizontal_divider_texture_id",
			pass_type = "tiled_texture",
			content_id = str_10,
			style_id = str_10,
			content_check_function = function (self)
				-- function 128
				return self.has_horizontal_divider
			end
		}
		tbl_4[str_10] = {
			has_horizontal_divider = false,
			horizontal_divider_texture_id = str_6
		}
		tbl_5[str_10] = {
			size = tbl_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1],
				tbl_6[2] - get_atlas_settings_by_texture_name_6.size[2] * 0.5,
				tbl_6[3]
			},
			texture_tiling_size = get_atlas_settings_by_texture_name_6.size
		}

		local str_11 = "title_text" .. str_7

		tbl_3[#tbl_3 + 1] = {
			pass_type = "text",
			text_id = "text",
			content_id = str_11,
			style_id = str_11,
			content_check_function = function (self)
				-- function 129
				return self.text ~= nil
			end
		}
		tbl_4[str_11] = {}
		tbl_5[str_11] = {
			vertical_alignment = "bottom",
			word_wrap = true,
			horizontal_alignment = "left",
			font_type = "hell_shark",
			font_size = num,
			text_color = Colors.get_color_table_with_alpha("white", 200),
			offset = {
				tbl_6[1] + 20,
				tbl_6[2],
				tbl_6[3] + 2
			}
		}

		local str_12 = "score_player_1" .. str_7

		tbl_3[#tbl_3 + 1] = {
			pass_type = "text",
			text_id = "text",
			content_id = str_12,
			style_id = str_12,
			content_check_function = function (self)
				-- function 130
				return self.text ~= nil
			end
		}
		tbl_4[str_12] = {}
		tbl_5[str_12] = {
			vertical_alignment = "bottom",
			word_wrap = true,
			horizontal_alignment = "center",
			font_type = "hell_shark",
			font_size = num,
			text_color = Colors.get_color_table_with_alpha("white", 200),
			offset = {
				tbl_6[1] - 450,
				tbl_6[2],
				tbl_6[3] + 2
			}
		}

		local str_13 = "score_player_2" .. str_7

		tbl_3[#tbl_3 + 1] = {
			pass_type = "text",
			text_id = "text",
			content_id = str_13,
			style_id = str_13,
			content_check_function = function (self)
				-- function 131
				return self.text ~= nil
			end
		}
		tbl_4[str_13] = {}
		tbl_5[str_13] = {
			vertical_alignment = "bottom",
			word_wrap = true,
			horizontal_alignment = "center",
			font_type = "hell_shark",
			font_size = num,
			text_color = Colors.get_color_table_with_alpha("white", 200),
			offset = {
				tbl_6[1] - 150,
				tbl_6[2],
				tbl_6[3] + 2
			}
		}

		local str_14 = "score_player_3" .. str_7

		tbl_3[#tbl_3 + 1] = {
			pass_type = "text",
			text_id = "text",
			content_id = str_14,
			style_id = str_14,
			content_check_function = function (self)
				-- function 132
				return self.text ~= nil
			end
		}
		tbl_4[str_14] = {}
		tbl_5[str_14] = {
			vertical_alignment = "bottom",
			word_wrap = true,
			horizontal_alignment = "center",
			font_type = "hell_shark",
			font_size = num,
			text_color = Colors.get_color_table_with_alpha("white", 200),
			offset = {
				tbl_6[1] + 150,
				tbl_6[2],
				tbl_6[3] + 2
			}
		}

		local str_15 = "score_player_4" .. str_7

		tbl_3[#tbl_3 + 1] = {
			pass_type = "text",
			text_id = "text",
			content_id = str_15,
			style_id = str_15,
			content_check_function = function (self)
				-- function 133
				return self.text ~= nil
			end
		}
		tbl_4[str_15] = {}
		tbl_5[str_15] = {
			vertical_alignment = "bottom",
			word_wrap = true,
			horizontal_alignment = "center",
			font_type = "hell_shark",
			font_size = num,
			text_color = Colors.get_color_table_with_alpha("white", 200),
			offset = {
				tbl_6[1] + 450,
				tbl_6[2],
				tbl_6[3] + 2
			}
		}

		local str_16 = "high_score_marker_1" .. str_7

		tbl_3[#tbl_3 + 1] = {
			texture_id = "high_score_marker_texture_id",
			pass_type = "texture",
			content_id = str_16,
			style_id = str_16,
			content_check_function = function (self)
				-- function 134
				return self.parent["title_text" .. str_7].text == nil or self.parent["score_player_1" .. str_7].text == nil or self.has_highscore
			end
		}
		tbl_4[str_16] = {
			high_score_marker_texture_id = "scoreboard_marker",
			has_highscore = false
		}
		tbl_5[str_16] = {
			size = {
				71,
				39
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1] - 450 + 800 + 120,
				tbl_6[2],
				tbl_6[3]
			}
		}

		local str_17 = "high_score_marker_2" .. str_7

		tbl_3[#tbl_3 + 1] = {
			texture_id = "high_score_marker_texture_id",
			pass_type = "texture",
			content_id = str_17,
			style_id = str_17,
			content_check_function = function (self)
				-- function 135
				return self.parent["title_text" .. str_7].text == nil or self.parent["score_player_1" .. str_7].text == nil or self.has_highscore
			end
		}
		tbl_4[str_17] = {
			high_score_marker_texture_id = "scoreboard_marker",
			has_highscore = false
		}
		tbl_5[str_17] = {
			size = {
				71,
				39
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1] - 150 + 800 + 120,
				tbl_6[2],
				tbl_6[3]
			}
		}

		local str_18 = "high_score_marker_3" .. str_7

		tbl_3[#tbl_3 + 1] = {
			texture_id = "high_score_marker_texture_id",
			pass_type = "texture",
			content_id = str_18,
			style_id = str_18,
			content_check_function = function (self)
				-- function 136
				return self.parent["title_text" .. str_7].text == nil or self.parent["score_player_1" .. str_7].text == nil or self.has_highscore
			end
		}
		tbl_4[str_18] = {
			high_score_marker_texture_id = "scoreboard_marker",
			has_highscore = false
		}
		tbl_5[str_18] = {
			size = {
				71,
				39
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1] + 150 + 800 + 120,
				tbl_6[2],
				tbl_6[3]
			}
		}

		local str_19 = "high_score_marker_4" .. str_7

		tbl_3[#tbl_3 + 1] = {
			texture_id = "high_score_marker_texture_id",
			pass_type = "texture",
			content_id = str_19,
			style_id = str_19,
			content_check_function = function (self)
				-- function 137
				return self.parent["title_text" .. str_7].text == nil or self.parent["score_player_1" .. str_7].text == nil or self.has_highscore
			end
		}
		tbl_4[str_19] = {
			high_score_marker_texture_id = "scoreboard_marker",
			has_highscore = false
		}
		tbl_5[str_19] = {
			size = {
				71,
				39
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1] + 450 + 800 + 120,
				tbl_6[2],
				tbl_6[3]
			}
		}

		local str_20 = "line_divider_1" .. str_7

		tbl_3[#tbl_3 + 1] = {
			texture_id = "vertical_divider_texture_id",
			pass_type = "texture",
			content_id = str_8,
			style_id = str_20,
			content_check_function = function (self)
				-- function 138
				return self.parent["title_text" .. str_7].text == nil or self.parent["score_player_1" .. str_7].text ~= nil
			end
		}
		tbl_5[str_20] = {
			size = {
				4,
				num_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1] - 450 + 800,
				tbl_6[2],
				tbl_6[3]
			}
		}

		local str_21 = "line_divider_2" .. str_7

		tbl_3[#tbl_3 + 1] = {
			texture_id = "vertical_divider_texture_id",
			pass_type = "texture",
			content_id = str_8,
			style_id = str_21,
			content_check_function = function (self)
				-- function 139
				return self.parent["title_text" .. str_7].text == nil or self.parent["score_player_1" .. str_7].text ~= nil
			end
		}
		tbl_5[str_21] = {
			size = {
				4,
				num_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1] - 150 + 800,
				tbl_6[2],
				tbl_6[3]
			}
		}

		local str_22 = "line_divider_3" .. str_7

		tbl_3[#tbl_3 + 1] = {
			texture_id = "vertical_divider_texture_id",
			pass_type = "texture",
			content_id = str_8,
			style_id = str_22,
			content_check_function = function (self)
				-- function 140
				return self.parent["title_text" .. str_7].text == nil or self.parent["score_player_1" .. str_7].text ~= nil
			end
		}
		tbl_5[str_22] = {
			size = {
				4,
				num_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1] + 150 + 800,
				tbl_6[2],
				tbl_6[3]
			}
		}

		local str_23 = "line_divider_4" .. str_7

		tbl_3[#tbl_3 + 1] = {
			texture_id = "vertical_divider_texture_id",
			pass_type = "texture",
			content_id = str_8,
			style_id = str_23,
			content_check_function = function (self)
				-- function 141
				return self.parent["title_text" .. str_7].text == nil or self.parent["score_player_1" .. str_7].text ~= nil
			end
		}
		tbl_5[str_23] = {
			size = {
				4,
				num_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1] + 450 + 800,
				tbl_6[2],
				tbl_6[3]
			}
		}

		local str_24 = "line_divider_5" .. str_7

		tbl_3[#tbl_3 + 1] = {
			texture_id = "vertical_divider_texture_id",
			pass_type = "texture",
			content_id = str_8,
			style_id = str_24,
			content_check_function = function (self)
				-- function 142
				return self.parent["title_text" .. str_7].text == nil or self.parent["score_player_1" .. str_7].text ~= nil
			end
		}
		tbl_5[str_24] = {
			size = {
				4,
				num_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_6[1] + 750 + 800,
				tbl_6[2],
				tbl_6[3]
			}
		}
	end

	return {
		element = {
			passes = tbl_3
		},
		content = tbl_4,
		style = tbl_5,
		scenegraph_id = arg_126_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_level_up_widget = function (arg_143_0, arg_143_1)
	-- function 143
	return {
		element = {
			passes = {
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "level_text",
					pass_type = "text",
					text_id = "level_text"
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				}
			}
		},
		content = {
			background = "level_up_bg",
			title_text = "Level up",
			level_text = "9999"
		},
		style = {
			title_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 36,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("font_title", 0),
				offset = {
					0,
					35,
					1
				}
			},
			level_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 40,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("font_default", 0),
				offset = {
					0,
					-35,
					1
				}
			},
			background = {
				offset = {
					-10,
					0,
					0
				},
				color = {
					0,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_143_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_experience_bar = function (arg_144_0, arg_144_1, arg_144_2)
	-- function 144
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local tbl = {
		element = {
			passes = {
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame",
					content_check_function = function (self)
						-- function 145
						return self.draw_frame
					end
				},
				{
					texture_id = "glass",
					style_id = "glass",
					pass_type = "texture"
				},
				{
					style_id = "level_text_from",
					pass_type = "text",
					text_id = "level_text_from"
				},
				{
					style_id = "level_text_to",
					pass_type = "text",
					text_id = "level_text_to"
				},
				{
					style_id = "counter_text",
					pass_type = "text",
					text_id = "counter_text"
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					style_id = "experience_bar",
					pass_type = "texture_uv",
					content_id = "experience_bar"
				},
				{
					pass_type = "texture",
					style_id = "mask_rect",
					texture_id = "mask_rect"
				}
			}
		},
		content = {
			counter_text = "",
			level_text_to = "",
			mask_rect = "mask_rect",
			glass = "xp_bar_glass",
			level_text_from = "",
			background = "xp_bar_bg",
			draw_frame = true,
			experience_bar = {
				texture_id = "end_screen_experience_bar",
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
			frame = menu_frame_06.texture
		}
	}
	local tbl_2 = {
		mask_rect = {
			size = {
				arg_144_1[1],
				arg_144_1[2] + 100,
				arg_144_1[3]
			},
			offset = {
				0,
				-50,
				0
			}
		},
		background = {
			masked = arg_144_2,
			color = Colors.get_color_table_with_alpha("white", 255),
			size = {
				arg_144_1[1] - menu_frame_06.texture_sizes.horizontal[2] * 2,
				arg_144_1[2] - menu_frame_06.texture_sizes.vertical[1] * 2
			},
			offset = {
				menu_frame_06.texture_sizes.horizontal[2],
				menu_frame_06.texture_sizes.vertical[1],
				0
			}
		},
		experience_bar = {
			masked = arg_144_2,
			color = Colors.get_color_table_with_alpha("white", 255),
			size = {
				arg_144_1[1] - menu_frame_06.texture_sizes.horizontal[2] * 2,
				arg_144_1[2] - menu_frame_06.texture_sizes.vertical[1] * 2
			},
			default_size = {
				arg_144_1[1] - menu_frame_06.texture_sizes.horizontal[2],
				arg_144_1[2] - menu_frame_06.texture_sizes.vertical[1] * 2
			},
			offset = {
				menu_frame_06.texture_sizes.horizontal[2],
				menu_frame_06.texture_sizes.vertical[1],
				2
			}
		},
		glass = {
			masked = arg_144_2,
			color = Colors.get_color_table_with_alpha("white", 255),
			size = {
				arg_144_1[1] - menu_frame_06.texture_sizes.horizontal[2] * 2,
				arg_144_1[2] - menu_frame_06.texture_sizes.vertical[1] * 2
			},
			offset = {
				menu_frame_06.texture_sizes.horizontal[2],
				menu_frame_06.texture_sizes.vertical[1],
				4
			}
		},
		frame = {
			masked = arg_144_2,
			texture_size = menu_frame_06.texture_size,
			texture_sizes = menu_frame_06.texture_sizes,
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
		}
	}
	local tbl_3 = {
		vertical_alignment = "top",
		font_size = 28,
		horizontal_alignment = "center"
	}
	local flag

	flag = not arg_144_2 and "hell_shark_masked" and "hell_shark"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_3.offset = {
		0,
		-arg_144_1[2] - 5,
		0
	}
	tbl_2.counter_text = tbl_3

	local tbl_4 = {
		vertical_alignment = "center",
		font_size = 36,
		horizontal_alignment = "right"
	}
	local flag_2

	flag_2 = not arg_144_2 and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_4.offset = {
		-arg_144_1[1] - 10,
		0,
		0
	}
	tbl_2.level_text_from = tbl_4

	local tbl_5 = {
		vertical_alignment = "center",
		font_size = 36,
		horizontal_alignment = "left"
	}
	local flag_3

	flag_3 = not arg_144_2 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag_3
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_5.offset = {
		arg_144_1[1] + 10,
		0,
		0
	}
	tbl_2.level_text_to = tbl_5
	tbl.style = tbl_2
	tbl.scenegraph_id = arg_144_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

UIWidgets.create_statistics_bar = function (arg_146_0, arg_146_1, arg_146_2, arg_146_3)
	-- function 146
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local frame_outer_glow_02 = UIFrameSettings.frame_outer_glow_02
	local var_146_2 = frame_outer_glow_02.texture_sizes.horizontal[2]
	local flag = arg_146_2 or "button_detail_03"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(flag).size
	local tbl = {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "texture_frame",
					style_id = "hover_frame",
					texture_id = "hover_frame",
					content_check_function = function (self)
						-- function 147
						return self.hotspot.is_hover
					end
				},
				{
					texture_id = "star",
					style_id = "star",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 148
						return self.has_star
					end
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame",
					content_check_function = function (self)
						-- function 149
						return self.draw_frame
					end
				},
				{
					texture_id = "glass",
					style_id = "glass",
					pass_type = "texture"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "value_text",
					pass_type = "text",
					text_id = "value_text"
				},
				{
					style_id = "value_text_shadow",
					pass_type = "text",
					text_id = "value_text"
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					style_id = "experience_bar_edge",
					texture_id = "experience_bar_edge",
					pass_type = "texture",
					content_change_function = function (arg_150_0, arg_150_1)
						-- function 150
						local experience_bar = arg_150_1.parent.experience_bar
						local var_150_1 = experience_bar.offset[1]

						arg_150_1.offset[1] = math.floor(experience_bar.size[1] + var_150_1)
						arg_150_1.size[1] = math.min(40, experience_bar.default_size[1] - (arg_150_1.offset[1] - var_150_1))
					end
				},
				{
					style_id = "experience_bar",
					pass_type = "texture_uv",
					content_id = "experience_bar"
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail"
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail"
				}
			}
		},
		content = {
			title_text = "n/a",
			experience_bar_edge = "experience_bar_edge_glow",
			draw_frame = true,
			glass = "xp_bar_glass",
			background = "xp_bar_bg",
			value_text = "n/a",
			star = "list_item_tag_new",
			hotspot = {},
			hover_frame = frame_outer_glow_02.texture,
			side_detail = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = flag
			},
			experience_bar = {
				texture_id = "experience_bar_fill",
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
			frame = menu_frame_06.texture
		}
	}
	local tbl_2 = {
		background = {
			color = Colors.get_color_table_with_alpha("white", 255),
			size = {
				arg_146_1[1] - menu_frame_06.texture_sizes.horizontal[2] * 2,
				arg_146_1[2] - menu_frame_06.texture_sizes.vertical[1] * 2
			},
			offset = {
				menu_frame_06.texture_sizes.horizontal[2],
				menu_frame_06.texture_sizes.vertical[1],
				0
			}
		},
		experience_bar = {
			color = Colors.get_color_table_with_alpha("white", 255),
			size = {
				arg_146_1[1] - menu_frame_06.texture_sizes.horizontal[2] * 2,
				arg_146_1[2] - menu_frame_06.texture_sizes.vertical[1] * 2
			},
			default_size = {
				arg_146_1[1] - menu_frame_06.texture_sizes.horizontal[2],
				arg_146_1[2] - menu_frame_06.texture_sizes.vertical[1] * 2
			},
			offset = {
				menu_frame_06.texture_sizes.horizontal[2],
				menu_frame_06.texture_sizes.vertical[1],
				2
			}
		},
		experience_bar_edge = {
			color = Colors.get_color_table_with_alpha("white", 255),
			size = {
				40,
				arg_146_1[2] - menu_frame_06.texture_sizes.vertical[1] * 2
			},
			offset = {
				0,
				menu_frame_06.texture_sizes.vertical[1],
				2
			}
		},
		glass = {
			color = Colors.get_color_table_with_alpha("white", 255),
			size = {
				arg_146_1[1] - menu_frame_06.texture_sizes.horizontal[2] * 2,
				arg_146_1[2] - menu_frame_06.texture_sizes.vertical[1] * 2
			},
			offset = {
				menu_frame_06.texture_sizes.horizontal[2],
				menu_frame_06.texture_sizes.vertical[1],
				3
			}
		},
		frame = {
			texture_size = menu_frame_06.texture_size,
			texture_sizes = menu_frame_06.texture_sizes,
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
		hover_frame = {
			texture_size = frame_outer_glow_02.texture_size,
			texture_sizes = frame_outer_glow_02.texture_sizes,
			frame_margins = {
				-var_146_2,
				-var_146_2
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
				6
			}
		},
		star = {
			horizontal_alignment = "right",
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-100,
				-4,
				6
			},
			texture_size = {
				126,
				51
			}
		},
		title_text = {
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = 26,
			horizontal_alignment = "left",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				20,
				0,
				6
			}
		},
		title_text_shadow = {
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = 26,
			horizontal_alignment = "left",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				22,
				-2,
				5
			}
		},
		value_text = {
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = 26,
			horizontal_alignment = "right",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				-20,
				0,
				6
			}
		},
		value_text_shadow = {
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = 26,
			horizontal_alignment = "right",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				-18,
				-2,
				5
			}
		}
	}
	local tbl_3 = {
		color = {
			255,
			255,
			255,
			255
		}
	}
	local tbl_4 = {
		nil,
		nil,
		5
	}
	local num

	if not arg_146_3 then
		num = -arg_146_3

		if not num then
			-- Nothing
		end
	end

	num = -9

	::label_146_0::

	tbl_4[1] = num
	tbl_4[2] = arg_146_1[2] / 2 - size[2] / 2
	tbl_3.offset = tbl_4
	tbl_3.size = {
		size[1],
		size[2]
	}
	tbl_2.side_detail_left = tbl_3
	tbl_2.side_detail_right = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			arg_146_1[1] - size[1] + (arg_146_3 or 9),
			arg_146_1[2] / 2 - size[2] / 2,
			5
		},
		size = {
			size[1],
			size[2]
		}
	}
	tbl.style = tbl_2
	tbl.scenegraph_id = arg_146_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

local function fn(self)
	-- function 151
	return self.has_locked
end

local function fn_2(self)
	-- function 152
	return self.has_available
end

local function fn_3(self)
	-- function 153
	return self.has_completed
end

local function fn_4(self)
	-- function 154
	return self.is_hover
end

UIWidgets.create_quest_bar = function (arg_155_0, arg_155_1)
	-- function 155
	local str = "chain_end"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(str).size
	local num = 20
	local num_2 = 30
	local num_3 = 135
	local num_4 = -31
	local tbl = {
		95 + num,
		58
	}

	return {
		scenegraph_id = arg_155_0,
		offset = {
			0,
			0,
			0
		},
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "locked_slot",
					texture_id = "slot",
					content_check_function = fn
				},
				{
					pass_type = "texture",
					style_id = "locked_icon_cooldown",
					texture_id = "icon_cooldown",
					content_check_function = function (self)
						-- function 156
						local has_locked = self.has_locked

						has_locked = not has_locked and self.cooldown_lock

						return has_locked
					end
				},
				{
					pass_type = "texture",
					style_id = "locked_icon_locked",
					texture_id = "icon_locked",
					content_check_function = function (self)
						-- function 157
						local has_locked = self.has_locked

						has_locked = not has_locked and not self.cooldown_lock

						return has_locked
					end
				},
				{
					pass_type = "tiled_texture",
					style_id = "locked_count_bg_center",
					texture_id = "count_bg_center",
					content_check_function = fn
				},
				{
					pass_type = "texture",
					style_id = "locked_count_bg_right",
					texture_id = "count_bg_right",
					content_check_function = fn
				},
				{
					style_id = "locked_text",
					pass_type = "text",
					text_id = "locked_text",
					content_check_function = fn
				},
				{
					style_id = "locked_tooltip",
					pass_type = "hover",
					content_id = "locked_tooltip",
					content_check_function = function (self)
						-- function 158
						return self.parent.has_locked
					end
				},
				{
					style_id = "locked_tooltip",
					pass_type = "tooltip_text",
					text_id = "text_id",
					content_id = "locked_tooltip",
					content_check_function = fn_4
				},
				{
					pass_type = "texture",
					style_id = "available_slot",
					texture_id = "slot",
					content_check_function = fn_2
				},
				{
					pass_type = "texture",
					style_id = "available_slot_frame",
					texture_id = "slot_frame",
					content_check_function = fn_2
				},
				{
					pass_type = "texture",
					style_id = "available_icon_available",
					texture_id = "icon_available",
					content_check_function = fn_2
				},
				{
					pass_type = "tiled_texture",
					style_id = "available_count_bg_center",
					texture_id = "count_bg_center",
					content_check_function = fn_2
				},
				{
					pass_type = "texture",
					style_id = "available_count_bg_right",
					texture_id = "count_bg_right",
					content_check_function = fn_2
				},
				{
					style_id = "available_text",
					pass_type = "text",
					text_id = "available_text",
					content_check_function = fn_2
				},
				{
					style_id = "available_tooltip",
					pass_type = "hover",
					content_id = "available_tooltip",
					content_check_function = function (self)
						-- function 159
						return self.parent.has_available
					end
				},
				{
					style_id = "available_tooltip",
					pass_type = "tooltip_text",
					text_id = "text_id",
					content_id = "available_tooltip",
					content_check_function = fn_4
				},
				{
					pass_type = "texture",
					style_id = "completed_slot",
					texture_id = "slot",
					content_check_function = fn_3
				},
				{
					pass_type = "texture",
					style_id = "completed_slot_frame",
					texture_id = "slot_frame",
					content_check_function = fn_3
				},
				{
					pass_type = "texture",
					style_id = "completed_icon_loot",
					texture_id = "icon_loot",
					content_check_function = fn_3
				},
				{
					pass_type = "tiled_texture",
					style_id = "completed_count_bg_center",
					texture_id = "count_bg_center",
					content_check_function = fn_3
				},
				{
					pass_type = "texture",
					style_id = "completed_count_bg_right",
					texture_id = "count_bg_right",
					content_check_function = fn_3
				},
				{
					style_id = "completed_text",
					pass_type = "text",
					text_id = "completed_text",
					content_check_function = fn_3
				},
				{
					style_id = "completed_tooltip",
					pass_type = "hover",
					content_id = "completed_tooltip",
					content_check_function = function (self)
						-- function 160
						return self.parent.has_completed
					end
				},
				{
					style_id = "completed_tooltip",
					pass_type = "tooltip_text",
					text_id = "text_id",
					content_id = "completed_tooltip",
					content_check_function = fn_4
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail"
				},
				{
					texture_id = "refresh_icon",
					style_id = "refresh_icon",
					pass_type = "texture"
				},
				{
					texture_id = "refresh_icon_bg",
					style_id = "refresh_icon_bg",
					pass_type = "texture"
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail"
				},
				{
					pass_type = "tiled_texture",
					style_id = "background",
					texture_id = "background"
				}
			}
		},
		content = {
			count_bg_right = "store_thumbnail_pricetag_right",
			count_bg_center = "store_thumbnail_pricetag_middle",
			slot_frame = "achievement_symbol_book_glow_1",
			has_available = true,
			has_completed = true,
			has_locked = true,
			icon_cooldown = "achievement_symbol_hourglass",
			icon_loot = "achievement_symbol_loot",
			slot_flames = "achievement_small_book_glow",
			icon_locked = "achievement_symbol_lock",
			refresh_icon_bg = "achievement_refresh_off",
			icon_available = "achievement_symbol_skull",
			available_text = "n/a",
			completed_text = "n/a",
			slot = "achievement_symbol_book",
			background = "chain_link_horizontal_01",
			refresh_icon = "achievement_refresh_on",
			locked_text = "n/a",
			locked_tooltip = {
				text_id = "achv_menu_summary_locked_quests"
			},
			available_tooltip = {
				text_id = "achv_menu_summary_available_quests"
			},
			completed_tooltip = {
				text_id = "achv_menu_summary_completed_quests"
			},
			side_detail = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = str
			}
		},
		style = {
			background = {
				offset = {
					0,
					0,
					0
				},
				texture_tiling_size = {
					19,
					16
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			locked_slot = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					63,
					58
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					num_4 - num_3,
					0,
					2
				}
			},
			locked_icon_cooldown = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					56,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					num_4 - num_3,
					0,
					3
				}
			},
			locked_icon_locked = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					56,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					num_4 - num_3,
					0,
					3
				}
			},
			locked_count_bg_center = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					num,
					36
				},
				texture_tiling_size = {
					10,
					36
				},
				color = {
					255,
					230,
					230,
					230
				},
				offset = {
					num_4 - num_3 + num_2,
					0,
					1
				}
			},
			locked_count_bg_right = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					32,
					40
				},
				color = {
					255,
					230,
					230,
					230
				},
				offset = {
					num_4 - num_3 + num_2 + num,
					0,
					1
				}
			},
			locked_text = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				localize = false,
				dynamic_font_size = true,
				font_size = 24,
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					num_4 - num_3 + num_2 + 12,
					0,
					2
				}
			},
			locked_tooltip = {
				font_size = 18,
				max_width = 500,
				localize = true,
				cursor_side = "right",
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_table("white"),
				line_colors = {
					Colors.get_table("orange_red")
				},
				cursor_offset = {
					20,
					-57
				},
				offset = {
					-num_3,
					0,
					50
				},
				area_size = tbl
			},
			available_slot = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					63,
					58
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					num_4,
					0,
					2
				}
			},
			available_slot_frame = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					63,
					58
				},
				color = {
					255,
					238,
					122,
					20
				},
				offset = {
					num_4,
					0,
					0
				}
			},
			available_icon_available = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					34,
					34
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					num_4,
					0,
					3
				}
			},
			available_count_bg_center = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					num,
					36
				},
				texture_tiling_size = {
					10,
					36
				},
				color = {
					255,
					230,
					230,
					230
				},
				offset = {
					num_4 + num_2,
					0,
					1
				}
			},
			available_count_bg_right = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					32,
					40
				},
				color = {
					255,
					230,
					230,
					230
				},
				offset = {
					num_4 + num_2 + num,
					0,
					1
				}
			},
			available_text = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				localize = false,
				dynamic_font_size = true,
				font_size = 24,
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					num_4 + num_2 + 12,
					0,
					2
				}
			},
			available_tooltip = {
				font_size = 18,
				max_width = 500,
				localize = true,
				cursor_side = "right",
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_table("white"),
				line_colors = {
					Colors.get_table("orange_red")
				},
				cursor_offset = {
					15,
					-55
				},
				offset = {
					0,
					0,
					50
				},
				area_size = tbl
			},
			completed_slot = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					63,
					58
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					num_4 + num_3,
					0,
					2
				}
			},
			completed_slot_frame = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					63,
					58
				},
				color = {
					255,
					238,
					122,
					20
				},
				offset = {
					num_4 + num_3,
					0,
					0
				}
			},
			completed_icon_loot = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					42,
					29
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					num_4 + num_3,
					0,
					3
				}
			},
			completed_count_bg_center = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					num,
					36
				},
				texture_tiling_size = {
					10,
					36
				},
				color = {
					255,
					230,
					230,
					230
				},
				offset = {
					num_4 + num_3 + num_2,
					0,
					1
				}
			},
			completed_count_bg_right = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					32,
					40
				},
				color = {
					255,
					230,
					230,
					230
				},
				offset = {
					num_4 + num_3 + num_2 + num,
					0,
					1
				}
			},
			completed_text = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				localize = false,
				dynamic_font_size = true,
				font_size = 24,
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					num_4 + num_3 + num_2 + 12,
					0,
					2
				}
			},
			completed_tooltip = {
				font_size = 18,
				max_width = 500,
				localize = true,
				cursor_side = "right",
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_table("white"),
				line_colors = {
					Colors.get_table("orange_red")
				},
				cursor_offset = {
					20,
					27
				},
				offset = {
					num_3,
					0,
					50
				},
				area_size = tbl
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-size[1],
					arg_155_1[2] / 2 - size[2] / 2,
					5
				},
				size = {
					size[1],
					size[2]
				}
			},
			side_detail_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_155_1[1],
					arg_155_1[2] / 2 - size[2] / 2,
					5
				},
				size = {
					size[1],
					size[2]
				}
			},
			refresh_icon_bg = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_155_1[1] - 10,
					arg_155_1[2] / 2 - 12.5,
					6
				},
				size = {
					25,
					25
				}
			},
			refresh_icon = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_155_1[1] - 10,
					arg_155_1[2] / 2 - 12.5,
					7
				},
				size = {
					25,
					25
				}
			}
		}
	}
end

UIWidgets.create_summary_experience_bar = function (arg_161_0, arg_161_1, arg_161_2, arg_161_3)
	-- function 161
	return {
		element = {
			passes = {
				{
					style_id = "counter_text",
					pass_type = "text",
					text_id = "counter_text"
				},
				{
					style_id = "counter_text_shadow",
					pass_type = "text",
					text_id = "counter_text"
				},
				{
					texture_id = "experience_bar",
					style_id = "experience_bar",
					pass_type = "texture"
				},
				{
					texture_id = "experience_bar_end",
					style_id = "experience_bar_end",
					pass_type = "texture"
				}
			}
		},
		content = {
			experience_bar = "summary_screen_fill",
			level_text_from = "",
			level_text_to = "",
			counter_text = "",
			experience_bar_end = "summary_screen_fill_glow"
		},
		style = {
			experience_bar = {
				color = Colors.get_color_table_with_alpha("white", 255),
				size = arg_161_1,
				masked = arg_161_2,
				default_size = arg_161_1,
				offset = {
					0,
					0,
					2
				}
			},
			experience_bar_end = {
				color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_161_3 or 132,
					arg_161_1[2]
				},
				masked = arg_161_2,
				offset = {
					0,
					0,
					2
				}
			},
			counter_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 28,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					0,
					4
				}
			},
			counter_text_shadow = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 28,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					3
				}
			}
		},
		scenegraph_id = arg_161_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_career_summary_window = function (arg_162_0, arg_162_1)
	-- function 162
	local str = "menu_frame_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local menu_frame_06 = UIFrameSettings.menu_frame_06
	local tbl = {
		60,
		60
	}

	return {
		element = {
			passes = {
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					style_id = "active_ability_title_text",
					pass_type = "text",
					text_id = "active_ability_title_text"
				},
				{
					style_id = "passive_ability_title_text",
					pass_type = "text",
					text_id = "passive_ability_title_text"
				},
				{
					style_id = "active_ability_description_text",
					pass_type = "text",
					text_id = "active_ability_description_text"
				},
				{
					style_id = "passive_ability_description_text",
					pass_type = "text",
					text_id = "passive_ability_description_text"
				},
				{
					texture_id = "active_ability",
					style_id = "active_ability",
					pass_type = "texture"
				},
				{
					texture_id = "passive_ability",
					style_id = "passive_ability",
					pass_type = "texture"
				}
			}
		},
		content = {
			passive_ability_description_text = "n/a",
			title_text = "n/a",
			passive_ability_title_text = "n/a",
			active_ability_title_text = "n/a",
			passive_ability = "icons_placeholder",
			active_ability = "icons_placeholder",
			active_ability_description_text = "n/a",
			description_text = "n/a",
			frame = menu_frame_06.texture,
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						arg_162_1[1] / get_atlas_settings_by_texture_name.size[1],
						arg_162_1[2] / get_atlas_settings_by_texture_name.size[2]
					}
				},
				texture_id = str
			}
		},
		style = {
			frame = {
				texture_size = menu_frame_06.texture_size,
				texture_sizes = menu_frame_06.texture_sizes,
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
			title_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					0,
					arg_162_1[2] - 55,
					2
				},
				size = {
					arg_162_1[1],
					30
				}
			},
			description_text = {
				vertical_alignment = "top",
				font_size = 20,
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					20,
					arg_162_1[2] - 100,
					2
				},
				size = {
					arg_162_1[1] - 40,
					30
				}
			},
			active_ability = {
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					60,
					60
				},
				offset = {
					20,
					arg_162_1[2] - 300,
					3
				}
			},
			passive_ability = {
				color = {
					255,
					255,
					255,
					255
				},
				size = tbl,
				offset = {
					20,
					arg_162_1[2] - 500,
					3
				}
			},
			active_ability_title_text = {
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				font_size = 22,
				horizontal_alignment = "left",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					tbl[1] + 40,
					arg_162_1[2] - 300,
					2
				},
				size = {
					arg_162_1[1] - (tbl[1] + 60),
					tbl[2]
				}
			},
			passive_ability_title_text = {
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				font_size = 22,
				horizontal_alignment = "left",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					tbl[1] + 40,
					arg_162_1[2] - 500,
					2
				},
				size = {
					arg_162_1[1] - (tbl[1] + 60),
					tbl[2]
				}
			},
			active_ability_description_text = {
				vertical_alignment = "top",
				font_type = "hell_shark",
				font_size = 20,
				horizontal_alignment = "left",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					20,
					0,
					2
				},
				size = {
					arg_162_1[1] - 40,
					arg_162_1[2] - (arg_162_1[2] - 300) - 20
				}
			},
			passive_ability_description_text = {
				vertical_alignment = "top",
				font_type = "hell_shark",
				font_size = 20,
				horizontal_alignment = "left",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					20,
					0,
					2
				},
				size = {
					arg_162_1[1] - 40,
					arg_162_1[2] - (arg_162_1[2] - 500) - 20
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_162_0
	}
end

UIWidgets.create_default_button = function (arg_163_0, arg_163_1, arg_163_2, arg_163_3, arg_163_4, arg_163_5, arg_163_6, arg_163_7, arg_163_8, arg_163_9, arg_163_10, arg_163_11, arg_163_12, arg_163_13, arg_163_14)
	-- function 163
	arg_163_3 = arg_163_3 or "button_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_163_3)
	local var_163_1

	if not arg_163_2 then
		var_163_1 = UIFrameSettings[arg_163_2]

		if not var_163_1 then
			-- Nothing
		end
	end

	var_163_1 = UIFrameSettings.button_frame_01

	::label_163_0::

	local var_163_2 = var_163_1.texture_sizes.corner[1]
	local flag = arg_163_7 or "button_detail_01"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(flag).size
	local var_163_5
	local var_163_6

	if not arg_163_8 then
		if type(arg_163_8) == "table" then
			var_163_5 = arg_163_8[1]
			var_163_6 = arg_163_8[2]
		else
			var_163_5 = arg_163_8
		end
	end

	local tbl = {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame",
					content_check_function = function (self)
						-- function 164
						return self.draw_frame
					end
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					pass_type = "rect",
					style_id = "clicked_rect"
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 165
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function (self)
						-- function 166
						return not self.skip_side_detail
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function (self)
						-- function 167
						return not self.skip_side_detail
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 168
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 169
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				}
			}
		}
	}
	local tbl_2 = {
		draw_frame = true,
		hover_glow = "button_state_default",
		glass = "button_glass_02",
		background_fade = "button_bg_fade",
		side_detail = {
			uvs = {
				{
					1,
					0
				},
				{
					0,
					1
				}
			},
			texture_id = flag,
			skip_side_detail = arg_163_10
		},
		button_hotspot = {},
		title_text = arg_163_4 or "n/a",
		frame = var_163_1.texture
	}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {
		0
	}
	local flag_2

	flag_2 = not arg_163_13 and 1 and arg_163_1[2] / get_atlas_settings_by_texture_name.size[2]
	tbl_5[2] = 1 - flag_2
	tbl_4[1] = tbl_5

	local tbl_6 = {
		nil,
		1
	}
	local flag_3

	flag_3 = not arg_163_13 and 1 and arg_163_1[1] / get_atlas_settings_by_texture_name.size[1]
	tbl_6[1] = flag_3
	tbl_4[2] = tbl_6
	tbl_3.uvs = tbl_4
	tbl_3.texture_id = arg_163_3
	tbl_2.background = tbl_3
	tbl_2.disable_with_gamepad = arg_163_9
	tbl.content = tbl_2

	local tbl_7 = {}
	local tbl_8 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = {
			255,
			150,
			150,
			150
		},
		offset = {
			0,
			0,
			0
		},
		masked = arg_163_11
	}
	local tbl_9

	if not arg_163_13 then
		tbl_9 = {
			arg_163_1[1] * 0.7,
			arg_163_1[2] * 0.7
		}

		if not tbl_9 then
			-- Nothing
		end
	end

	tbl_9 = nil

	::label_163_1::

	tbl_8.texture_size = tbl_9
	tbl_7.background = tbl_8
	tbl_7.background_fade = {
		color = {
			200,
			255,
			255,
			255
		},
		offset = {
			var_163_2,
			var_163_2 - 2,
			2
		},
		size = {
			arg_163_1[1] - var_163_2 * 2,
			arg_163_1[2] - var_163_2 * 2
		},
		masked = arg_163_11
	}
	tbl_7.hover_glow = {
		color = {
			0,
			255,
			255,
			255
		},
		offset = {
			0,
			var_163_2 - 2,
			3
		},
		size = {
			arg_163_1[1],
			math.min(arg_163_1[2] - 5, 80)
		},
		masked = arg_163_11
	}
	tbl_7.clicked_rect = {
		color = {
			0,
			0,
			0,
			0
		},
		offset = {
			0,
			0,
			7
		}
	}
	tbl_7.disabled_rect = {
		color = {
			150,
			20,
			20,
			20
		},
		offset = {
			0,
			0,
			1
		}
	}

	local tbl_10 = {
		upper_case = true,
		word_wrap = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_size = arg_163_5 or 24
	}
	local flag_4

	flag_4 = not arg_163_11 and "hell_shark_masked" and "hell_shark"
	tbl_10.font_type = flag_4
	tbl_10.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_10.default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_10.select_text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_10.size = {
		arg_163_1[1] - 40,
		arg_163_1[2]
	}
	tbl_10.area_size = arg_163_14
	tbl_10.offset = {
		20,
		0,
		6
	}
	tbl_7.title_text = tbl_10

	local tbl_11 = {
		upper_case = true,
		word_wrap = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_size = arg_163_5 or 24
	}
	local flag_5

	flag_5 = not arg_163_11 and "hell_shark_masked" and "hell_shark"
	tbl_11.font_type = flag_5
	tbl_11.text_color = Colors.get_color_table_with_alpha("gray", 255)
	tbl_11.default_text_color = Colors.get_color_table_with_alpha("gray", 255)
	tbl_11.size = {
		arg_163_1[1] - 40,
		arg_163_1[2]
	}
	tbl_11.area_size = arg_163_14
	tbl_11.offset = {
		20,
		0,
		6
	}
	tbl_7.title_text_disabled = tbl_11

	local tbl_12 = {
		upper_case = true,
		word_wrap = false,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_size = arg_163_5 or 24
	}
	local flag_6

	flag_6 = not arg_163_11 and "hell_shark_masked" and "hell_shark"
	tbl_12.font_type = flag_6
	tbl_12.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_12.default_text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_12.size = {
		arg_163_1[1] - 40,
		arg_163_1[2]
	}
	tbl_12.area_size = arg_163_14
	tbl_12.offset = {
		22,
		-2,
		5
	}
	tbl_7.title_text_shadow = tbl_12
	tbl_7.frame = {
		texture_size = var_163_1.texture_size,
		texture_sizes = var_163_1.texture_sizes,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			0,
			8
		},
		masked = arg_163_11
	}
	tbl_7.glass_top = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			arg_163_1[2] - (var_163_2 + 11),
			4
		},
		size = {
			arg_163_1[1],
			11
		},
		masked = arg_163_11
	}
	tbl_7.glass_bottom = {
		color = {
			100,
			255,
			255,
			255
		},
		offset = {
			0,
			var_163_2 - 9,
			4
		},
		size = {
			arg_163_1[1],
			11
		},
		masked = arg_163_11
	}

	local tbl_13 = {
		color = {
			255,
			255,
			255,
			255
		}
	}
	local tbl_14 = {
		nil,
		nil,
		9
	}
	local num

	if not var_163_5 then
		num = -var_163_5

		if not num then
			-- Nothing
		end
	end

	num = -9

	::label_163_2::

	tbl_14[1] = num
	tbl_14[2] = arg_163_1[2] / 2 - size[2] / 2 + (var_163_6 or 0)
	tbl_13.offset = tbl_14
	tbl_13.size = {
		size[1],
		size[2]
	}
	tbl_13.masked = arg_163_11
	tbl_7.side_detail_left = tbl_13
	tbl_7.side_detail_right = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			arg_163_1[1] - size[1] + (var_163_5 or 9),
			arg_163_1[2] / 2 - size[2] / 2 + (var_163_6 or 0),
			9
		},
		size = {
			size[1],
			size[2]
		},
		masked = arg_163_11
	}
	tbl.style = tbl_7
	tbl.scenegraph_id = arg_163_0
	tbl.offset = arg_163_12 or {
		0,
		0,
		0
	}

	return tbl
end

UIWidgets.create_default_image_button = function (arg_170_0, arg_170_1, arg_170_2, arg_170_3, arg_170_4, arg_170_5, arg_170_6, arg_170_7, arg_170_8, arg_170_9)
	-- function 170
	arg_170_3 = arg_170_3 or "button_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_170_3)
	local var_170_1

	if not arg_170_2 then
		var_170_1 = UIFrameSettings[arg_170_2]

		if not var_170_1 then
			-- Nothing
		end
	end

	var_170_1 = UIFrameSettings.button_frame_01

	::label_170_0::

	local var_170_2 = var_170_1.texture_sizes.corner[1]
	local flag = arg_170_8 or "button_detail_01"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(flag).size

	arg_170_6 = arg_170_6 or "loot_chest_icon"

	local get_atlas_settings_by_texture_name_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_170_6)
	local size_2

	if not get_atlas_settings_by_texture_name_2 then
		size_2 = get_atlas_settings_by_texture_name_2.size

		if not size_2 then
			-- Nothing
		end
	end

	size_2 = {
		200,
		200
	}

	::label_170_1::

	local num = 1 - math.min(arg_170_1[2] / size_2[2], 1)
	local num_2 = 0.9
	local tbl = {
		size_2[1] * num_2,
		arg_170_1[2]
	}
	local tbl_2 = {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					pass_type = "rect",
					style_id = "clicked_rect"
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 171
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail"
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 172
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 173
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				},
				{
					style_id = "background_icon",
					pass_type = "texture_uv",
					content_id = "background_icon"
				},
				{
					texture_id = "new_texture",
					style_id = "new_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 174
						return self.new
					end
				}
			}
		},
		content = {
			hover_glow = "button_state_default",
			glass = "button_glass_02",
			background_fade = "button_bg_fade",
			new_texture = "list_item_tag_new",
			side_detail = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = flag
			},
			button_hotspot = {},
			title_text = arg_170_4 or "n/a",
			frame = var_170_1.texture,
			background_icon = {
				uvs = {
					{
						0,
						0.5 * num
					},
					{
						num_2,
						1 - num / 2
					}
				},
				texture_id = arg_170_6
			},
			background = {
				uvs = {
					{
						0,
						1 - arg_170_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_170_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = arg_170_3
			}
		}
	}
	local tbl_3 = {
		background = {
			color = {
				255,
				150,
				150,
				150
			},
			offset = {
				0,
				0,
				0
			}
		},
		background_icon = {
			color = {
				200,
				255,
				255,
				255
			},
			offset = {
				arg_170_1[1] - tbl[1],
				arg_170_1[2] / 2 - tbl[2] / 2,
				1
			},
			size = tbl
		},
		background_fade = {
			color = {
				200,
				255,
				255,
				255
			},
			offset = {
				var_170_2,
				var_170_2 - 2,
				3
			},
			size = {
				arg_170_1[1] - var_170_2 * 2,
				arg_170_1[2] - var_170_2 * 2
			}
		},
		hover_glow = {
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				var_170_2 - 2,
				4
			},
			size = {
				arg_170_1[1],
				math.min(arg_170_1[2] - 5, 80)
			}
		},
		clicked_rect = {
			color = {
				0,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				8
			}
		},
		disabled_rect = {
			color = {
				150,
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
		new_texture = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_170_1[1] - 126,
				arg_170_1[2] / 2 - 25.5,
				7
			},
			size = {
				126,
				51
			}
		},
		title_text = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_170_5 or 24,
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				30,
				0,
				7
			}
		},
		title_text_disabled = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_170_5 or 24,
			text_color = Colors.get_color_table_with_alpha("gray", 255),
			default_text_color = Colors.get_color_table_with_alpha("gray", 255),
			offset = {
				30,
				0,
				7
			}
		},
		title_text_shadow = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_170_5 or 24,
			text_color = Colors.get_color_table_with_alpha("black", 255),
			default_text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				32,
				-2,
				6
			}
		},
		frame = {
			texture_size = var_170_1.texture_size,
			texture_sizes = var_170_1.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				9
			}
		},
		glass_top = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				arg_170_1[2] - (var_170_2 + 11),
				5
			},
			size = {
				arg_170_1[1],
				11
			}
		},
		glass_bottom = {
			color = {
				100,
				255,
				255,
				255
			},
			offset = {
				0,
				var_170_2 - 9,
				5
			},
			size = {
				arg_170_1[1],
				11
			}
		}
	}
	local tbl_4 = {
		color = {
			255,
			255,
			255,
			255
		}
	}
	local tbl_5 = {
		nil,
		nil,
		10
	}
	local num_3

	if not arg_170_9 then
		num_3 = -arg_170_9

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = -9

	::label_170_2::

	tbl_5[1] = num_3
	tbl_5[2] = arg_170_1[2] / 2 - size[2] / 2
	tbl_4.offset = tbl_5
	tbl_4.size = {
		size[1],
		size[2]
	}
	tbl_3.side_detail_left = tbl_4
	tbl_3.side_detail_right = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			arg_170_1[1] - size[1] + (arg_170_9 or 9),
			arg_170_1[2] / 2 - size[2] / 2,
			10
		},
		size = {
			size[1],
			size[2]
		}
	}
	tbl_2.style = tbl_3
	tbl_2.scenegraph_id = arg_170_0
	tbl_2.offset = {
		0,
		0,
		0
	}

	return tbl_2
end

UIWidgets.create_default_icon_tabs = function (arg_175_0, arg_175_1, arg_175_2)
	-- function 175
	local str = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {
		amount = arg_175_2
	}
	local tbl_4 = {}
	local num = 0
	local num_2 = 0
	local num_3 = -num
	local num_4 = (arg_175_1[1] - num * (arg_175_2 - 1)) / arg_175_2
	local tbl_5 = {
		num_4,
		arg_175_1[2]
	}
	local tbl_6 = {
		34,
		34
	}
	local num_5 = 0

	for i = 1, arg_175_2 do
		local str_2 = "_" .. tostring(i)
		local num_6 = i - 1

		num_3 = num_3 + tbl_5[1] + num

		local tbl_7 = {
			num_5,
			0,
			num_2
		}
		local str_3 = "hotspot" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "hotspot",
			content_id = str_3,
			style_id = str_3
		}
		tbl_4[str_3] = {
			size = tbl_5,
			offset = tbl_7
		}
		tbl_3[str_3] = {}

		local var_175_17 = tbl_3[str_3]
		local str_4 = "background" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture_uv",
			content_id = str_4,
			style_id = str_4
		}
		tbl_4[str_4] = {
			size = tbl_5,
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
			}
		}
		tbl_3[str_4] = {
			uvs = {
				{
					0,
					1 - math.min(tbl_5[2] / get_atlas_settings_by_texture_name.size[2], 1)
				},
				{
					math.min(tbl_5[1] / get_atlas_settings_by_texture_name.size[1], 1),
					1
				}
			},
			texture_id = str
		}

		local str_5 = "background_fade" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			content_id = str_3,
			texture_id = str_5,
			style_id = str_5
		}
		tbl_4[str_5] = {
			size = {
				tbl_5[1],
				tbl_5[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2],
				1
			}
		}
		var_175_17[str_5] = "button_bg_fade"

		local str_6 = "hover_glow" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			content_id = str_3,
			texture_id = str_6,
			style_id = str_6
		}
		tbl_4[str_6] = {
			size = {
				tbl_5[1],
				math.min(tbl_5[2] - 5, 80)
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2] + 5,
				2
			}
		}
		var_175_17[str_6] = "button_state_default"

		local str_7 = "clicked_rect" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "rect",
			content_id = str_3,
			style_id = str_7
		}
		tbl_4[str_7] = {
			size = tbl_5,
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				tbl_7[1],
				tbl_7[2],
				6
			}
		}

		local str_8 = "glass_top" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			content_id = str_3,
			texture_id = str_8,
			style_id = str_8
		}
		tbl_4[str_8] = {
			size = {
				tbl_5[1],
				11
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2] + tbl_5[2] - 11,
				5
			}
		}
		var_175_17[str_8] = "button_glass_02"

		local str_9 = "glass_bottom" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			content_id = str_3,
			texture_id = str_9,
			style_id = str_9
		}
		tbl_4[str_9] = {
			size = {
				tbl_5[1],
				11
			},
			color = {
				100,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2] - 3,
				5
			}
		}
		var_175_17[str_9] = "button_glass_02"

		local str_10 = "icon" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			content_id = str_3,
			texture_id = str_10,
			style_id = str_10
		}
		tbl_4[str_10] = {
			size = tbl_6,
			color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			select_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				tbl_7[1] + tbl_5[1] / 2 - tbl_6[1] / 2,
				tbl_7[2] + tbl_5[2] / 2 - tbl_6[1] / 2 + 4,
				4
			}
		}
		var_175_17[str_10] = "tabs_inventory_icon_trinkets_selected"

		local str_11 = "icon_shadow" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			content_id = str_3,
			texture_id = str_10,
			style_id = str_11
		}
		tbl_4[str_11] = {
			size = tbl_6,
			color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				tbl_7[1] + tbl_5[1] / 2 - tbl_6[1] / 2 + 2,
				tbl_7[2] + tbl_5[2] / 2 - tbl_6[1] / 2 + 2,
				3
			}
		}
		num_5 = num_5 + num_4 + num
	end

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_175_0

	return tbl
end

UIWidgets.create_default_checkbox_button = function (arg_176_0, arg_176_1, arg_176_2, arg_176_3, arg_176_4, arg_176_5, arg_176_6)
	-- function 176
	local str = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {
		0,
		0,
		0
	}
	local str_2 = "button_hotspot"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "hotspot",
		content_id = str_2,
		style_id = str_2
	}
	tbl_4[str_2] = {
		size = arg_176_1,
		offset = tbl_5
	}
	tbl_3[str_2] = {}

	local var_176_8 = tbl_3[str_2]
	local str_3 = "background"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture_uv",
		content_id = str_3,
		style_id = str_3
	}
	tbl_4[str_3] = {
		size = arg_176_1,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_5[1],
			tbl_5[2],
			0
		}
	}
	tbl_3[str_3] = {
		uvs = {
			{
				0,
				1 - math.min(arg_176_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
			},
			{
				math.min(arg_176_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
				1
			}
		},
		texture_id = str
	}

	local str_4 = "background_fade"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_4,
		style_id = str_4
	}
	tbl_4[str_4] = {
		size = {
			arg_176_1[1],
			arg_176_1[2]
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_5[1],
			tbl_5[2],
			1
		}
	}
	var_176_8[str_4] = "button_bg_fade"

	local str_5 = "hover_glow"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_5,
		style_id = str_5
	}
	tbl_4[str_5] = {
		size = {
			arg_176_1[1],
			math.min(arg_176_1[2] - 5, 80)
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_5[1],
			tbl_5[2] + 5,
			2
		}
	}
	var_176_8[str_5] = "button_state_default"

	local str_6 = "clicked_rect"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "rect",
		content_id = str_2,
		style_id = str_6
	}
	tbl_4[str_6] = {
		size = arg_176_1,
		color = {
			100,
			0,
			0,
			0
		},
		offset = {
			tbl_5[1],
			tbl_5[2],
			6
		}
	}

	local str_7 = "glass_top"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_7,
		style_id = str_7
	}
	tbl_4[str_7] = {
		size = {
			arg_176_1[1],
			11
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_5[1],
			tbl_5[2] + arg_176_1[2] - 11,
			5
		}
	}
	var_176_8[str_7] = "button_glass_02"

	local str_8 = "glass_bottom"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_8,
		style_id = str_8
	}
	tbl_4[str_8] = {
		size = {
			arg_176_1[1],
			11
		},
		color = {
			100,
			255,
			255,
			255
		},
		offset = {
			tbl_5[1],
			tbl_5[2] - 3,
			5
		}
	}
	var_176_8[str_8] = "button_glass_02"

	if not arg_176_4 then
		local str_9 = "additional_option_info"

		tbl_2[#tbl_2 + 1] = {
			pass_type = "additional_option_tooltip",
			content_id = str_2,
			style_id = str_9,
			additional_option_id = str_9,
			content_check_function = function (self)
				-- function 177
				return self.is_hover
			end
		}
		var_176_8[str_9] = arg_176_4

		local tbl_6 = {
			grow_downwards = false,
			vertical_alignment = "bottom",
			horizontal_alignment = "left"
		}
		local tbl_7 = {
			nil,
			nil,
			0
		}
		local var_176_18

		if not arg_176_5 then
			var_176_18 = arg_176_1[1]

			if not var_176_18 then
				-- Nothing
			end
		end

		var_176_18 = 0

		::label_176_0::

		tbl_7[1] = var_176_18

		local var_176_19

		if not arg_176_5 then
			var_176_19 = arg_176_1[2]

			if not var_176_19 then
				-- Nothing
			end
		end

		var_176_19 = 0

		::label_176_1::

		tbl_7[2] = var_176_19
		tbl_6.offset = tbl_7
		tbl_4[str_9] = tbl_6
	end

	local str_10 = "text"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str_2,
		text_id = str_10,
		style_id = str_10,
		content_check_function = function (self)
			-- function 178
			return not self.disable_button
		end
	}
	tbl_4[str_10] = {
		upper_case = true,
		word_wrap = true,
		font_size = 24,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		select_text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			tbl_5[1] + 10,
			tbl_5[2] + 3,
			4
		},
		size = arg_176_1
	}
	var_176_8[str_10] = arg_176_2

	local str_11 = "text_disabled"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str_2,
		text_id = str_10,
		style_id = str_11,
		content_check_function = function (self)
			-- function 179
			return self.disable_button
		end
	}
	tbl_4[str_11] = {
		upper_case = true,
		font_size = 24,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("gray", 255),
		default_text_color = Colors.get_color_table_with_alpha("gray", 255),
		offset = {
			tbl_5[1] + 10,
			tbl_5[2] + 3,
			4
		},
		size = arg_176_1
	}

	local str_12 = "text_shadow"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str_2,
		text_id = str_10,
		style_id = str_12
	}
	tbl_4[str_12] = {
		font_size = 24,
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			tbl_5[1] + 10 + 2,
			tbl_5[2] + 1,
			3
		},
		size = arg_176_1
	}

	local str_13 = "checkbox_background"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "rect",
		style_id = str_13
	}

	local tbl_8 = {
		25,
		25
	}
	local tbl_9 = {
		arg_176_1[1] - tbl_8[1] + tbl_5[1] - 20,
		tbl_5[2] + arg_176_1[2] / 2 - tbl_8[2] / 2 + 2,
		3
	}

	tbl_4[str_13] = {
		size = {
			tbl_8[1],
			tbl_8[2]
		},
		offset = tbl_9,
		color = {
			255,
			0,
			0,
			0
		}
	}

	local str_14 = "checkbox_frame"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture_frame",
		content_id = str_2,
		texture_id = str_14,
		style_id = str_14,
		content_check_function = function (self)
			-- function 180
			return not self.is_disabled
		end
	}
	arg_176_6 = arg_176_6 or "menu_frame_06"

	local var_176_27 = UIFrameSettings[arg_176_6]

	var_176_8[str_14] = var_176_27.texture
	tbl_4[str_14] = {
		size = {
			tbl_8[1],
			tbl_8[2]
		},
		texture_size = var_176_27.texture_size,
		texture_sizes = var_176_27.texture_sizes,
		offset = {
			tbl_9[1],
			tbl_9[2],
			tbl_9[3] + 1
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	local str_15 = "checkbox_frame_disabled"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture_frame",
		content_id = str_2,
		texture_id = str_14,
		style_id = str_15,
		content_check_function = function (self)
			-- function 181
			return not self.is_disabled
		end
	}
	tbl_4[str_15] = {
		size = {
			tbl_8[1],
			tbl_8[2]
		},
		texture_size = var_176_27.texture_size,
		texture_sizes = var_176_27.texture_sizes,
		offset = {
			tbl_9[1],
			tbl_9[2],
			tbl_9[3] + 1
		},
		color = {
			96,
			255,
			255,
			255
		}
	}

	local str_16 = "checkbox_marker"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_16,
		style_id = str_16,
		content_check_function = function (self)
			-- function 182
			local is_selected = self.is_selected

			is_selected = not is_selected and not self.disable_button

			return is_selected
		end
	}
	var_176_8[str_16] = "matchmaking_checkbox"

	local tbl_10 = {
		22,
		16
	}
	local tbl_11 = {
		tbl_9[1] + 4,
		tbl_9[2] + tbl_10[2] / 2 - 1,
		tbl_9[3] + 2
	}

	tbl_4[str_16] = {
		size = tbl_10,
		offset = tbl_11,
		color = Colors.get_color_table_with_alpha("white", 255)
	}

	local str_17 = "checkbox_marker_disabled"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_16,
		style_id = str_17,
		content_check_function = function (self)
			-- function 183
			local is_selected = self.is_selected

			is_selected = not is_selected and self.disable_button

			return is_selected
		end
	}
	tbl_4[str_17] = {
		size = tbl_10,
		offset = tbl_11,
		color = Colors.get_color_table_with_alpha("gray", 255)
	}
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_176_0

	return tbl
end

UIWidgets.create_default_checkbox_button_console = function (arg_184_0, arg_184_1, arg_184_2, arg_184_3, arg_184_4, arg_184_5, arg_184_6)
	-- function 184
	local str = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {
		0,
		0,
		0
	}
	local str_2 = "button_hotspot"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "hotspot",
		content_id = str_2,
		style_id = str_2
	}
	tbl_4[str_2] = {
		size = arg_184_1,
		offset = tbl_5
	}
	tbl_3[str_2] = {}

	local var_184_8 = tbl_3[str_2]
	local str_3 = "hover_glow"

	if not arg_184_6 then
		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			content_id = str_2,
			texture_id = str_3,
			style_id = str_3
		}
	end

	tbl_4[str_3] = {
		size = {
			arg_184_1[1],
			math.min(arg_184_1[2] - 5, 80)
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_5[1],
			tbl_5[2] + 5,
			2
		}
	}
	var_184_8[str_3] = "button_state_default"

	local str_4 = "clicked_rect"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "rect",
		content_id = str_2,
		style_id = str_4
	}
	tbl_4[str_4] = {
		size = arg_184_1,
		color = {
			100,
			0,
			0,
			0
		},
		offset = {
			tbl_5[1],
			tbl_5[2],
			6
		}
	}

	if not arg_184_4 then
		tbl_3.tooltip_info = arg_184_4
	end

	local tbl_6 = {
		25,
		25
	}
	local tbl_7 = {
		tbl_5[1] + tbl_6[1] + 15,
		tbl_5[2] + 4,
		4
	}
	local str_5 = "text"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str_2,
		text_id = str_5,
		style_id = str_5,
		content_check_function = function (self)
			-- function 185
			return not self.disable_button
		end
	}
	tbl_4[str_5] = {
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = arg_184_3 or 24,
		text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		select_text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			tbl_7[1],
			tbl_7[2],
			tbl_7[3]
		},
		size = arg_184_1
	}
	var_184_8[str_5] = arg_184_2

	local str_6 = "text_disabled"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str_2,
		text_id = str_5,
		style_id = str_6,
		content_check_function = function (self)
			-- function 186
			return self.disable_button
		end
	}
	tbl_4[str_6] = {
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = arg_184_3 or 24,
		text_color = Colors.get_color_table_with_alpha("gray", 255),
		default_text_color = Colors.get_color_table_with_alpha("gray", 255),
		offset = {
			tbl_7[1],
			tbl_7[2],
			tbl_7[3]
		},
		size = arg_184_1
	}

	local str_7 = "text_shadow"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str_2,
		text_id = str_5,
		style_id = str_7
	}
	tbl_4[str_7] = {
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = arg_184_3 or 24,
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			tbl_7[1] + 2,
			tbl_7[2] - 2,
			tbl_7[3] - 1
		},
		size = arg_184_1
	}

	local str_8 = "checkbox_background"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "rect",
		style_id = str_8
	}

	local tbl_8 = {
		tbl_5[1] + 10,
		tbl_5[2] + arg_184_1[2] / 2 - tbl_6[2] / 2 + 2,
		3
	}

	tbl_4[str_8] = {
		size = {
			tbl_6[1],
			tbl_6[2]
		},
		offset = tbl_8,
		color = {
			255,
			0,
			0,
			0
		}
	}

	local str_9 = "checkbox_frame"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture_frame",
		content_id = str_2,
		texture_id = str_9,
		style_id = str_9,
		content_check_function = function (self)
			-- function 187
			return not self.is_disabled
		end
	}
	arg_184_5 = arg_184_5 or "menu_frame_06"

	local var_184_19 = UIFrameSettings[arg_184_5]

	var_184_8[str_9] = var_184_19.texture
	tbl_4[str_9] = {
		size = {
			tbl_6[1],
			tbl_6[2]
		},
		texture_size = var_184_19.texture_size,
		texture_sizes = var_184_19.texture_sizes,
		offset = {
			tbl_8[1],
			tbl_8[2],
			tbl_8[3] + 1
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	local str_10 = "checkbox_frame_disabled"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture_frame",
		content_id = str_2,
		texture_id = str_9,
		style_id = str_10,
		content_check_function = function (self)
			-- function 188
			return not self.is_disabled
		end
	}
	tbl_4[str_10] = {
		size = {
			tbl_6[1],
			tbl_6[2]
		},
		texture_size = var_184_19.texture_size,
		texture_sizes = var_184_19.texture_sizes,
		offset = {
			tbl_8[1],
			tbl_8[2],
			tbl_8[3] + 1
		},
		color = {
			96,
			255,
			255,
			255
		}
	}

	local str_11 = "checkbox_marker"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_11,
		style_id = str_11,
		content_check_function = function (self)
			-- function 189
			local is_selected = self.is_selected

			is_selected = not is_selected and not self.disable_button

			return is_selected
		end
	}
	var_184_8[str_11] = "matchmaking_checkbox"

	local tbl_9 = {
		22,
		16
	}
	local tbl_10 = {
		tbl_8[1] + 4,
		tbl_8[2] + tbl_9[2] / 2 - 1,
		tbl_8[3] + 2
	}

	tbl_4[str_11] = {
		size = tbl_9,
		offset = tbl_10,
		color = Colors.get_color_table_with_alpha("white", 255)
	}

	local str_12 = "checkbox_marker_disabled"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str_2,
		texture_id = str_11,
		style_id = str_12,
		content_check_function = function (self)
			-- function 190
			local is_selected = self.is_selected

			is_selected = not is_selected and self.disable_button

			return is_selected
		end
	}
	tbl_4[str_12] = {
		size = tbl_9,
		offset = tbl_10,
		color = Colors.get_color_table_with_alpha("gray", 255)
	}
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_184_0

	return tbl
end

UIWidgets.create_default_text_tabs = function (arg_191_0, arg_191_1, arg_191_2)
	-- function 191
	local str = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {
		amount = arg_191_2
	}
	local tbl_4 = {}
	local num = 0
	local num_2 = 0
	local num_3 = -num
	local num_4 = (arg_191_1[1] - num * (arg_191_2 - 1)) / arg_191_2
	local tbl_5 = {
		num_4,
		arg_191_1[2]
	}
	local tbl_6 = {
		34,
		34
	}
	local num_5 = 0

	for i = 1, arg_191_2 do
		local str_2 = "_" .. tostring(i)
		local num_6 = i - 1

		num_3 = num_3 + tbl_5[1] + num

		local tbl_7 = {
			num_5,
			0,
			num_2
		}
		local str_3 = "hotspot" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "hotspot",
			content_id = str_3,
			style_id = str_3
		}
		tbl_4[str_3] = {
			size = tbl_5,
			offset = tbl_7
		}
		tbl_3[str_3] = {}

		local var_191_17 = tbl_3[str_3]
		local str_4 = "background" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture_uv",
			content_id = str_4,
			style_id = str_4
		}
		tbl_4[str_4] = {
			size = tbl_5,
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
			}
		}
		tbl_3[str_4] = {
			uvs = {
				{
					0,
					1 - math.min(tbl_5[2] / get_atlas_settings_by_texture_name.size[2], 1)
				},
				{
					math.min(tbl_5[1] / get_atlas_settings_by_texture_name.size[1], 1),
					1
				}
			},
			texture_id = str
		}

		local str_5 = "background_fade" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			content_id = str_3,
			texture_id = str_5,
			style_id = str_5
		}
		tbl_4[str_5] = {
			size = {
				tbl_5[1],
				tbl_5[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2],
				1
			}
		}
		var_191_17[str_5] = "button_bg_fade"

		local str_6 = "hover_glow" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			content_id = str_3,
			texture_id = str_6,
			style_id = str_6
		}
		tbl_4[str_6] = {
			size = {
				tbl_5[1],
				math.min(tbl_5[2] - 5, 80)
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2] + 5,
				2
			}
		}
		var_191_17[str_6] = "button_state_default"

		local str_7 = "clicked_rect" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "rect",
			content_id = str_3,
			style_id = str_7
		}
		tbl_4[str_7] = {
			size = tbl_5,
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				tbl_7[1],
				tbl_7[2],
				6
			}
		}

		local str_8 = "glass_top" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			content_id = str_3,
			texture_id = str_8,
			style_id = str_8
		}
		tbl_4[str_8] = {
			size = {
				tbl_5[1],
				11
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2] + tbl_5[2] - 11,
				5
			}
		}
		var_191_17[str_8] = "button_glass_02"

		local str_9 = "glass_bottom" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			content_id = str_3,
			texture_id = str_9,
			style_id = str_9
		}
		tbl_4[str_9] = {
			size = {
				tbl_5[1],
				11
			},
			color = {
				100,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2] - 3,
				5
			}
		}
		var_191_17[str_9] = "button_glass_02"

		local str_10 = "text" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			content_id = str_3,
			text_id = str_10,
			style_id = str_10,
			content_check_function = function (self)
				-- function 192
				return not self.disable_button
			end
		}
		tbl_4[str_10] = {
			upper_case = true,
			word_wrap = true,
			font_size = 24,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				tbl_7[1],
				tbl_7[2] + 3,
				4
			},
			size = tbl_5
		}
		var_191_17[str_10] = Localize("not_assigned")

		local str_11 = "text_disabled" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			content_id = str_3,
			text_id = str_10,
			style_id = str_11,
			content_check_function = function (self)
				-- function 193
				return self.disable_button
			end
		}
		tbl_4[str_11] = {
			upper_case = true,
			font_size = 24,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("gray", 255),
			default_text_color = Colors.get_color_table_with_alpha("gray", 255),
			offset = {
				tbl_7[1],
				tbl_7[2] + 3,
				4
			},
			size = tbl_5
		}

		local str_12 = "text_shadow" .. str_2

		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			content_id = str_3,
			text_id = str_10,
			style_id = str_12
		}
		tbl_4[str_12] = {
			font_size = 24,
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				tbl_7[1] + 2,
				tbl_7[2] + 1,
				3
			},
			size = tbl_5
		}
		num_5 = num_5 + num_4 + num
	end

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_191_0

	return tbl
end

UIWidgets.create_simple_window_button = function (arg_194_0, arg_194_1, arg_194_2, arg_194_3, arg_194_4)
	-- function 194
	arg_194_4 = arg_194_4 or "button_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_194_4)

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					pass_type = "rect",
					style_id = "clicked_rect"
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 195
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 196
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 197
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				}
			}
		},
		content = {
			glass = "button_glass_02",
			hover_glow = "button_state_default",
			background_fade = "button_bg_fade",
			button_hotspot = {},
			title_text = arg_194_2 or "n/a",
			background = {
				uvs = {
					{
						0,
						1 - arg_194_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_194_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = arg_194_4
			}
		},
		style = {
			background = {
				color = {
					255,
					150,
					150,
					150
				},
				offset = {
					0,
					0,
					0
				}
			},
			background_fade = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					2
				},
				size = {
					arg_194_1[1],
					arg_194_1[2]
				}
			},
			hover_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					3
				},
				size = {
					arg_194_1[1],
					math.min(arg_194_1[2] - 5, 80)
				}
			},
			clicked_rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				}
			},
			disabled_rect = {
				color = {
					150,
					20,
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			},
			title_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_194_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					3,
					6
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_194_3 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					3,
					6
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_194_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					1,
					5
				}
			},
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_194_1[2] - 11,
					4
				},
				size = {
					arg_194_1[1],
					11
				}
			},
			glass_bottom = {
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					0,
					-3,
					4
				},
				size = {
					arg_194_1[1],
					11
				}
			}
		},
		scenegraph_id = arg_194_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_window_category_button = function (arg_198_0, arg_198_1, arg_198_2, arg_198_3, arg_198_4, arg_198_5)
	-- function 198
	arg_198_3 = arg_198_3 or "options_button_icon_quickplay"

	local str = arg_198_3 .. "_glow"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_198_3).size
	local str_2 = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)
	local str_3 = "menu_frame_08"
	local var_198_5 = UIFrameSettings[str_3]
	local var_198_6 = var_198_5.texture_sizes.corner[1]
	local str_4 = "frame_outer_glow_01"
	local var_198_8 = UIFrameSettings[str_4].texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
				},
				{
					style_id = "background_icon",
					pass_type = "texture",
					texture_id = "background_icon",
					content_check_function = function (self)
						-- function 199
						return self.background_icon
					end,
					content_change_function = function (self, arg_200_1)
						-- function 200
						local button_hotspot = self.button_hotspot

						if not (button_hotspot.disable_button or button_hotspot.is_selected) then
							-- Nothing
						end
					end
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					texture_id = "new_texture",
					style_id = "new_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 201
						return self.new
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 202
						return not self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "icon",
					style_id = "icon_disabled",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 203
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "icon_selected",
					style_id = "icon_selected",
					pass_type = "texture"
				},
				{
					texture_id = "icon_frame",
					style_id = "icon_frame",
					pass_type = "texture"
				},
				{
					texture_id = "icon_glass",
					style_id = "icon_glass",
					pass_type = "texture"
				},
				{
					texture_id = "icon_bg_glow",
					style_id = "icon_bg_glow",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					texture_id = "select_glow",
					style_id = "select_glow",
					pass_type = "texture"
				},
				{
					texture_id = "skull_select_glow",
					style_id = "skull_select_glow",
					pass_type = "texture"
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 204
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 205
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_shadow",
					pass_type = "text",
					text_id = "button_text"
				},
				{
					pass_type = "rect",
					style_id = "button_clicked_rect"
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 206
						return self.button_hotspot.disable_button
					end
				}
			}
		},
		content = {
			icon_glass = "menu_options_button_fg",
			hover_glow = "button_state_default",
			icon_frame = "menu_options_button_bg",
			skull_select_glow = "menu_options_button_glow_03",
			select_glow = "button_state_default_2",
			glass = "button_glass_02",
			background_fade = "button_bg_fade",
			icon_bg_glow = "menu_options_button_glow_01",
			new_texture = "list_item_tag_new",
			background_icon = arg_198_4,
			icon = arg_198_3,
			icon_selected = str,
			frame = var_198_5.texture,
			button_hotspot = {},
			button_text = arg_198_2 or "n/a",
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_198_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
					},
					{
						math.min(arg_198_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
						1
					}
				},
				texture_id = str_2
			}
		},
		style = {
			background = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					0,
					0,
					0
				},
				size = arg_198_1
			},
			background_fade = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_198_6,
					var_198_6,
					1
				},
				size = {
					arg_198_1[1] - var_198_6 * 2,
					arg_198_1[2] - var_198_6 * 2
				}
			},
			background_icon = {
				vertical_alignment = "center",
				saturated = false,
				horizontal_alignment = "right",
				color = {
					150,
					100,
					100,
					100
				},
				default_color = {
					150,
					100,
					100,
					100
				},
				texture_size = {
					350,
					108
				},
				offset = {
					0,
					0,
					3
				}
			},
			hover_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					5,
					2
				},
				size = {
					arg_198_1[1],
					math.min(arg_198_1[2] - 5, 80)
				}
			},
			select_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					5,
					3
				},
				size = {
					arg_198_1[1],
					math.min(arg_198_1[2] - 5, 80)
				}
			},
			button_text = {
				font_size = 32,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				dynamic_font_size = arg_198_5,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					130,
					0,
					6
				},
				size = {
					arg_198_1[1] - 140,
					arg_198_1[2]
				}
			},
			button_text_disabled = {
				font_size = 32,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				dynamic_font_size = arg_198_5,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					130,
					0,
					6
				},
				size = {
					arg_198_1[1] - 140,
					arg_198_1[2]
				}
			},
			button_text_shadow = {
				font_size = 32,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				dynamic_font_size = arg_198_5,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					132,
					-2,
					5
				},
				size = {
					arg_198_1[1] - 140,
					arg_198_1[2]
				}
			},
			button_clicked_rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				},
				size = arg_198_1
			},
			button_disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					0,
					0,
					5
				},
				size = arg_198_1
			},
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_198_1[2] - (var_198_6 + 9),
					6
				},
				size = {
					arg_198_1[1],
					11
				}
			},
			glass_bottom = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					0,
					var_198_6 - 11,
					6
				},
				size = {
					arg_198_1[1],
					11
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
					10
				},
				size = arg_198_1,
				texture_size = var_198_5.texture_size,
				texture_sizes = var_198_5.texture_sizes
			},
			new_texture = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_198_1[1] - 126,
					arg_198_1[2] - 56,
					6
				},
				size = {
					126,
					51
				}
			},
			icon_frame = {
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					116,
					108
				},
				offset = {
					0,
					0,
					11
				}
			},
			icon_glass = {
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					116,
					108
				},
				offset = {
					0,
					0,
					15
				}
			},
			icon_bg_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				texture_size = {
					116,
					108
				},
				offset = {
					0,
					0,
					14
				}
			},
			icon = {
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_color = Colors.get_color_table_with_alpha("white", 255),
				texture_size = size,
				offset = {
					54 - size[1] / 2,
					54 - size[2] / 2,
					12
				}
			},
			icon_disabled = {
				color = {
					255,
					40,
					40,
					40
				},
				default_color = {
					255,
					40,
					40,
					40
				},
				select_color = {
					255,
					40,
					40,
					40
				},
				texture_size = size,
				offset = {
					54 - size[1] / 2,
					54 - size[2] / 2,
					12
				}
			},
			icon_selected = {
				color = {
					0,
					255,
					255,
					255
				},
				texture_size = size,
				offset = {
					54 - size[1] / 2,
					54 - size[2] / 2,
					13
				}
			},
			skull_select_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					12
				},
				size = {
					28,
					arg_198_1[2]
				}
			}
		},
		scenegraph_id = arg_198_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_window_category_button_mirrored = function (arg_207_0, arg_207_1, arg_207_2, arg_207_3, arg_207_4, arg_207_5)
	-- function 207
	arg_207_3 = arg_207_3 or "options_button_icon_quickplay"

	local str = arg_207_3 .. "_glow"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_207_3).size
	local str_2 = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)
	local str_3 = "menu_frame_08"
	local var_207_5 = UIFrameSettings[str_3]
	local var_207_6 = var_207_5.texture_sizes.corner[1]
	local str_4 = "frame_outer_glow_01"
	local var_207_8 = UIFrameSettings[str_4].texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
				},
				{
					style_id = "background_icon",
					pass_type = "texture_uv",
					content_id = "background_icon",
					content_check_function = function (self)
						-- function 208
						return self.texture_id
					end,
					content_change_function = function (self, arg_209_1)
						-- function 209
						local button_hotspot = self.parent.button_hotspot

						if not (button_hotspot.disable_button or button_hotspot.is_selected) then
							-- Nothing
						end
					end
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "new_texture",
					pass_type = "texture_uv",
					content_id = "new_texture",
					content_check_function = function (self)
						-- function 210
						return self.parent.new
					end
				},
				{
					style_id = "icon",
					pass_type = "texture_uv",
					content_id = "icon",
					content_check_function = function (self)
						-- function 211
						return not self.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "icon_disabled",
					pass_type = "texture_uv",
					content_id = "icon",
					content_check_function = function (self)
						-- function 212
						return self.parent.button_hotspot.disable_button
					end
				},
				{
					texture_id = "icon_selected",
					style_id = "icon_selected",
					pass_type = "texture"
				},
				{
					style_id = "icon_frame",
					pass_type = "texture_uv",
					content_id = "icon_frame"
				},
				{
					texture_id = "icon_glass",
					style_id = "icon_glass",
					pass_type = "texture"
				},
				{
					texture_id = "icon_bg_glow",
					style_id = "icon_bg_glow",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					texture_id = "select_glow",
					style_id = "select_glow",
					pass_type = "texture"
				},
				{
					style_id = "skull_select_glow",
					pass_type = "texture_uv",
					content_id = "skull_select_glow"
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 213
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 214
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_shadow",
					pass_type = "text",
					text_id = "button_text"
				},
				{
					pass_type = "rect",
					style_id = "button_clicked_rect"
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 215
						return self.button_hotspot.disable_button
					end
				}
			}
		},
		content = {
			hover_glow = "button_state_default",
			icon_glass = "menu_options_button_fg",
			select_glow = "button_state_default_2",
			glass = "button_glass_02",
			background_fade = "button_bg_fade",
			icon_bg_glow = "menu_options_button_glow_01",
			background_icon = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = arg_207_4
			},
			icon = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = arg_207_3
			},
			icon_frame = {
				texture_id = "menu_options_button_bg",
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
			new_texture = {
				texture_id = "list_item_tag_new",
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
			skull_select_glow = {
				texture_id = "menu_options_button_glow_03",
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
			icon_selected = str,
			frame = var_207_5.texture,
			button_hotspot = {},
			button_text = arg_207_2 or "n/a",
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_207_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
					},
					{
						math.min(arg_207_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
						1
					}
				},
				texture_id = str_2
			}
		},
		style = {
			background = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					0,
					0,
					0
				},
				size = arg_207_1
			},
			background_fade = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_207_6,
					var_207_6,
					1
				},
				size = {
					arg_207_1[1] - var_207_6 * 2,
					arg_207_1[2] - var_207_6 * 2
				}
			},
			background_icon = {
				vertical_alignment = "center",
				saturated = false,
				horizontal_alignment = "left",
				color = {
					150,
					100,
					100,
					100
				},
				default_color = {
					150,
					100,
					100,
					100
				},
				texture_size = {
					350,
					108
				},
				offset = {
					0,
					0,
					3
				}
			},
			hover_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					5,
					2
				},
				size = {
					arg_207_1[1],
					math.min(arg_207_1[2] - 5, 80)
				}
			},
			select_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					5,
					3
				},
				size = {
					arg_207_1[1],
					math.min(arg_207_1[2] - 5, 80)
				}
			},
			button_text = {
				font_size = 32,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				dynamic_font_size = arg_207_5,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					10,
					0,
					6
				},
				size = {
					arg_207_1[1] - 140,
					arg_207_1[2]
				}
			},
			button_text_disabled = {
				font_size = 32,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				dynamic_font_size = arg_207_5,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					10,
					0,
					6
				},
				size = {
					arg_207_1[1] - 140,
					arg_207_1[2]
				}
			},
			button_text_shadow = {
				font_size = 32,
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				dynamic_font_size = arg_207_5,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					12,
					-2,
					5
				},
				size = {
					arg_207_1[1] - 140,
					arg_207_1[2]
				}
			},
			button_clicked_rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				},
				size = arg_207_1
			},
			button_disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					0,
					0,
					5
				},
				size = arg_207_1
			},
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_207_1[2] - (var_207_6 + 9),
					6
				},
				size = {
					arg_207_1[1],
					11
				}
			},
			glass_bottom = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					0,
					var_207_6 - 11,
					6
				},
				size = {
					arg_207_1[1],
					11
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
					10
				},
				size = arg_207_1,
				texture_size = var_207_5.texture_size,
				texture_sizes = var_207_5.texture_sizes
			},
			new_texture = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_207_1[2] - 56,
					6
				},
				size = {
					126,
					51
				}
			},
			icon_frame = {
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					116,
					108
				},
				offset = {
					arg_207_1[1] - 116,
					0,
					11
				}
			},
			icon_glass = {
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					116,
					108
				},
				offset = {
					arg_207_1[1] - 108,
					0,
					15
				}
			},
			icon_bg_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				texture_size = {
					116,
					108
				},
				offset = {
					arg_207_1[1] - 108,
					0,
					14
				}
			},
			icon = {
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_color = Colors.get_color_table_with_alpha("white", 255),
				texture_size = size,
				offset = {
					arg_207_1[1] - size[1] - (54 - size[1] / 2),
					54 - size[2] / 2,
					12
				}
			},
			icon_disabled = {
				color = {
					255,
					40,
					40,
					40
				},
				default_color = {
					255,
					40,
					40,
					40
				},
				select_color = {
					255,
					40,
					40,
					40
				},
				texture_size = size,
				offset = {
					arg_207_1[1] - size[1] - (54 - size[1] / 2),
					54 - size[2] / 2,
					12
				}
			},
			icon_selected = {
				color = {
					0,
					255,
					255,
					255
				},
				texture_size = size,
				offset = {
					arg_207_1[1] - size[1] - (54 - size[1] / 2),
					54 - size[2] / 2,
					13
				}
			},
			skull_select_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					arg_207_1[1] - 28,
					0,
					12
				},
				size = {
					28,
					arg_207_1[2]
				}
			}
		},
		scenegraph_id = arg_207_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_play_button = function (arg_216_0, arg_216_1, arg_216_2, arg_216_3, arg_216_4)
	-- function 216
	local var_216_0
	local str = "green"

	if not str then
		var_216_0 = "button_" .. str
	else
		var_216_0 = "button_normal"
	end

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(var_216_0, 255)
	local str_2 = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)
	local menu_frame_08 = UIFrameSettings.menu_frame_08
	local str_3 = "button_detail_05_glow"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(str_3).size

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					style_id = "clicked_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 217
						local is_clicked = self.button_hotspot.is_clicked

						return not is_clicked and is_clicked == 0
					end
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 218
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_right",
					style_id = "side_detail_right",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 219
						return not self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_left",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 220
						return not self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_right",
					style_id = "side_detail_right_disabled",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 221
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_left",
					style_id = "side_detail_left_disabled",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 222
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_glow_right",
					pass_type = "texture_uv",
					content_id = "side_detail_glow",
					content_check_function = function (self)
						-- function 223
						return not self.parent.button_hotspot.disable_button
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_glow_left",
					pass_type = "texture",
					content_id = "side_detail_glow",
					content_check_function = function (self)
						-- function 224
						return not self.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 225
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 226
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass_top",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture"
				},
				{
					texture_id = "effect",
					style_id = "effect",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 227
						return not self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 228
						local button_hotspot = self.button_hotspot
						local is_selected

						if not button_hotspot.disable_button then
							is_selected = button_hotspot.is_selected

							if not is_selected then
								is_selected = button_hotspot.is_hover
							end
						else
							is_selected = false
						end

						if false then
							is_selected = true
						end

						return is_selected
					end
				}
			}
		},
		content = {
			side_detail_right = "button_detail_05_right",
			effect = "play_button_passive_glow",
			hover_glow = "button_state_hover_green",
			side_detail_left = "button_detail_05_left",
			glow = "button_state_normal_green",
			glass_top = "button_glass_01",
			side_detail_glow = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = str_3
			},
			button_hotspot = {},
			title_text = arg_216_2 or "n/a",
			frame = menu_frame_08.texture,
			disable_with_gamepad = arg_216_4,
			background = {
				uvs = {
					{
						0,
						1 - arg_216_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_216_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = str_2
			}
		},
		style = {
			background = {
				color = get_color_table_with_alpha,
				offset = {
					0,
					0,
					0
				},
				size = {
					arg_216_1[1],
					arg_216_1[2]
				}
			},
			clicked_rect = {
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				},
				size = {
					arg_216_1[1],
					arg_216_1[2]
				}
			},
			disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					0,
					0,
					7
				},
				size = {
					arg_216_1[1],
					arg_216_1[2]
				}
			},
			title_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_216_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					9
				},
				size = {
					arg_216_1[1],
					arg_216_1[2]
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_216_3 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					0,
					9
				},
				size = {
					arg_216_1[1],
					arg_216_1[2]
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_216_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					8
				},
				size = {
					arg_216_1[1],
					arg_216_1[2]
				}
			},
			frame = {
				texture_size = menu_frame_08.texture_size,
				texture_sizes = menu_frame_08.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					8
				},
				size = {
					arg_216_1[1],
					arg_216_1[2]
				}
			},
			hover_glow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					menu_frame_08.texture_sizes.horizontal[2],
					1
				},
				size = {
					arg_216_1[1],
					math.min(60, arg_216_1[2] - menu_frame_08.texture_sizes.horizontal[2] * 2)
				}
			},
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_216_1[2] - menu_frame_08.texture_sizes.horizontal[2] - 4,
					6
				},
				size = {
					arg_216_1[1],
					5
				}
			},
			glow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					menu_frame_08.texture_sizes.horizontal[2] - 1,
					3
				},
				size = {
					arg_216_1[1],
					math.min(60, arg_216_1[2] - menu_frame_08.texture_sizes.horizontal[2] * 2)
				}
			},
			effect = {
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
				size = {
					arg_216_1[1],
					arg_216_1[2]
				}
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_216_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_216_1[1] - 88,
					arg_216_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_left_disabled = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					0,
					arg_216_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_right_disabled = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					arg_216_1[1] - 88,
					arg_216_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_glow_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_216_1[2] / 2 - size[2] / 2,
					10
				},
				size = {
					size[1],
					size[2]
				}
			},
			side_detail_glow_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_216_1[1] - size[1],
					arg_216_1[2] / 2 - size[2] / 2,
					10
				},
				size = {
					size[1],
					size[2]
				}
			}
		},
		scenegraph_id = arg_216_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_icon_button = function (arg_229_0, arg_229_1, arg_229_2, arg_229_3, arg_229_4)
	-- function 229
	arg_229_3 = arg_229_3 or "menu_frame_bg_06"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_229_3)
	local var_229_1

	if not arg_229_2 then
		var_229_1 = UIFrameSettings[arg_229_2]

		if not var_229_1 then
			-- Nothing
		end
	end

	var_229_1 = UIFrameSettings.menu_frame_06

	::label_229_0::

	local var_229_2 = var_229_1.texture_sizes.corner[1]
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_229_4).size

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
				},
				{
					texture_id = "glass_top",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass_bottom",
					style_id = "glass_bottom",
					pass_type = "texture"
				},
				{
					texture_id = "texture_hover",
					style_id = "texture_hover",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 230
						local button_hotspot = self.button_hotspot
						local is_selected

						if not button_hotspot.disable_button then
							is_selected = button_hotspot.is_selected

							if not is_selected then
								is_selected = button_hotspot.is_hover
							end
						else
							is_selected = false
						end

						if false then
							is_selected = true
						end

						return is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_icon",
					texture_id = "texture_icon"
				}
			}
		},
		content = {
			background_fade = "button_bg_fade",
			texture_hover = "button_state_default",
			glass_top = "tabs_glass_top",
			glass_bottom = "tabs_glass_bottom",
			texture_icon = arg_229_4,
			button_hotspot = {},
			frame = var_229_1.texture,
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						arg_229_1[1] / get_atlas_settings_by_texture_name.size[1],
						arg_229_1[2] / get_atlas_settings_by_texture_name.size[2]
					}
				},
				texture_id = arg_229_3
			}
		},
		style = {
			background = {
				color = {
					255,
					150,
					150,
					150
				},
				offset = {
					0,
					0,
					0
				}
			},
			background_fade = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					var_229_2,
					var_229_2 - 2,
					1
				},
				size = {
					arg_229_1[1] - var_229_2 * 2,
					arg_229_1[2] - var_229_2 * 2
				}
			},
			frame = {
				texture_size = var_229_1.texture_size,
				texture_sizes = var_229_1.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					6
				}
			},
			texture_hover = {
				color = {
					0,
					255,
					255,
					255
				},
				default_color = {
					0,
					255,
					255,
					255
				},
				hover_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_229_2 - 2,
					3
				},
				size = {
					arg_229_1[1],
					math.min(arg_229_1[2] - 5, 80)
				}
			},
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_229_1[2] - var_229_1.texture_sizes.horizontal[2] - 3,
					5
				},
				size = {
					arg_229_1[1],
					3
				}
			},
			glass_bottom = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_229_1.texture_sizes.horizontal[2],
					5
				},
				size = {
					arg_229_1[1],
					3
				}
			},
			texture_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = size,
				color = {
					200,
					255,
					255,
					255
				},
				default_color = {
					200,
					255,
					255,
					255
				},
				hover_color = {
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
			}
		},
		scenegraph_id = arg_229_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_stepper = function (arg_231_0, arg_231_1, arg_231_2, arg_231_3, arg_231_4)
	-- function 231
	arg_231_3 = arg_231_3 or "menu_frame_bg_06"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_231_3)
	local size

	if not get_atlas_settings_by_texture_name then
		size = get_atlas_settings_by_texture_name.size

		if not size then
			-- Nothing
		end
	end

	size = arg_231_1

	do
		local var_231_2
	end

	::label_231_0::

	if not arg_231_2 then
		var_231_2 = UIFrameSettings[arg_231_2]

		if not var_231_2 then
			-- Nothing
		end
	end

	var_231_2 = UIFrameSettings.menu_frame_06

	::label_231_1::

	local tbl = {
		28,
		34
	}
	local tbl_2 = {
		50,
		arg_231_1[2]
	}
	local tbl_3 = {
		-tbl_2[1],
		0,
		0
	}
	local tbl_4 = {
		arg_231_1[1],
		0,
		0
	}

	return {
		element = {
			passes = {
				{
					style_id = "setting_text",
					pass_type = "text",
					text_id = "setting_text",
					content_check_function = function (self)
						-- function 232
						local button_hotspot_left = self.button_hotspot_left
						local button_hotspot_right = self.button_hotspot_right

						return not not button_hotspot_left.disable_button or not button_hotspot_right.disable_button
					end
				},
				{
					style_id = "setting_text_disabled",
					pass_type = "text",
					text_id = "setting_text",
					content_check_function = function (self)
						-- function 233
						local button_hotspot_left = self.button_hotspot_left
						local button_hotspot_right = self.button_hotspot_right
						local disable_button = button_hotspot_left.disable_button

						disable_button = not disable_button and button_hotspot_right.disable_button

						return disable_button
					end
				},
				{
					style_id = "left_frame",
					pass_type = "hotspot",
					content_id = "button_hotspot_left"
				},
				{
					pass_type = "texture_frame",
					style_id = "left_frame",
					texture_id = "frame"
				},
				{
					style_id = "left_background",
					pass_type = "texture_uv",
					content_id = "arrow_background"
				},
				{
					texture_id = "glow",
					style_id = "left_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 234
						local button_hotspot_left = self.button_hotspot_left
						local is_selected

						if not button_hotspot_left.disable_button then
							is_selected = button_hotspot_left.is_selected

							if not is_selected then
								is_selected = button_hotspot_left.is_hover
							end
						else
							is_selected = false
						end

						if false then
							is_selected = true
						end

						return is_selected
					end
				},
				{
					texture_id = "glass_top",
					style_id = "left_glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass_bottom",
					style_id = "left_glass_bottom",
					pass_type = "texture"
				},
				{
					pass_type = "texture",
					style_id = "left_button_icon",
					texture_id = "button_icon"
				},
				{
					pass_type = "texture",
					style_id = "left_button_icon_clicked",
					texture_id = "button_icon_clicked"
				},
				{
					style_id = "right_frame",
					pass_type = "hotspot",
					content_id = "button_hotspot_right"
				},
				{
					pass_type = "texture_frame",
					style_id = "right_frame",
					texture_id = "frame"
				},
				{
					style_id = "right_background",
					pass_type = "texture_uv",
					content_id = "arrow_background"
				},
				{
					texture_id = "glow",
					style_id = "right_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 235
						local button_hotspot_right = self.button_hotspot_right
						local is_selected

						if not button_hotspot_right.disable_button then
							is_selected = button_hotspot_right.is_selected

							if not is_selected then
								is_selected = button_hotspot_right.is_hover
							end
						else
							is_selected = false
						end

						if false then
							is_selected = true
						end

						return is_selected
					end
				},
				{
					texture_id = "glass_top",
					style_id = "right_glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass_bottom",
					style_id = "right_glass_bottom",
					pass_type = "texture"
				},
				{
					pass_type = "rotated_texture",
					style_id = "right_button_icon",
					texture_id = "button_icon"
				},
				{
					pass_type = "rotated_texture",
					style_id = "right_button_icon_clicked",
					texture_id = "button_icon_clicked"
				}
			}
		},
		content = {
			button_icon = "settings_arrow_normal",
			button_icon_clicked = "settings_arrow_clicked",
			glow = "tabs_glow",
			glass_top = "tabs_glass_top",
			glass_bottom = "tabs_glass_bottom",
			frame = var_231_2.texture,
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						arg_231_1[1] / size[1],
						arg_231_1[2] / size[2]
					}
				},
				texture_id = arg_231_3
			},
			arrow_background = {
				uvs = {
					{
						0,
						0
					},
					{
						tbl_2[1] / size[1],
						tbl_2[2] / size[2]
					}
				},
				texture_id = arg_231_3
			},
			button_hotspot = {},
			setting_text = arg_231_4 or "test_text",
			button_hotspot_left = {},
			button_hotspot_right = {}
		},
		style = {
			frame = {
				texture_size = var_231_2.texture_size,
				texture_sizes = var_231_2.texture_sizes,
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
			glow = {
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
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_231_1[2] - var_231_2.texture_sizes.horizontal[2] - 3,
					3
				},
				size = {
					arg_231_1[1],
					3
				}
			},
			glass_bottom = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					var_231_2.texture_sizes.horizontal[2],
					3
				},
				size = {
					arg_231_1[1],
					3
				}
			},
			background = {
				size = arg_231_1,
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
			setting_text = {
				font_size = 22,
				word_wrap = true,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					0,
					0,
					4
				}
			},
			setting_text_disabled = {
				font_size = 22,
				word_wrap = true,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("gray", 128),
				offset = {
					0,
					0,
					4
				}
			},
			left_glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_3[1],
					tbl_2[2] - var_231_2.texture_sizes.horizontal[2] - 3,
					4
				},
				size = {
					tbl_2[1],
					3
				}
			},
			left_glass_bottom = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_3[1],
					var_231_2.texture_sizes.horizontal[2],
					4
				},
				size = {
					tbl_2[1],
					3
				}
			},
			left_glow = {
				size = tbl_2,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_3[1],
					tbl_3[2],
					1
				}
			},
			left_frame = {
				size = tbl_2,
				texture_size = var_231_2.texture_size,
				texture_sizes = var_231_2.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_3[1],
					tbl_3[2],
					5
				}
			},
			left_background = {
				size = tbl_2,
				color = {
					255,
					255,
					255,
					255
				},
				offset = tbl_3
			},
			left_button_icon = {
				size = tbl,
				offset = {
					tbl_3[1] + (tbl_2[1] / 2 - tbl[1] / 2),
					tbl_3[2] + (tbl_2[2] / 2 - tbl[2] / 2),
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			left_button_icon_clicked = {
				color = {
					0,
					255,
					255,
					255
				},
				size = tbl,
				offset = {
					tbl_3[1] + (tbl_2[1] / 2 - tbl[1] / 2),
					tbl_3[2] + (tbl_2[2] / 2 - tbl[2] / 2),
					3
				}
			},
			right_glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_4[1],
					tbl_2[2] - var_231_2.texture_sizes.horizontal[2] - 3,
					4
				},
				size = {
					tbl_2[1],
					3
				}
			},
			right_glass_bottom = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_4[1],
					var_231_2.texture_sizes.horizontal[2],
					4
				},
				size = {
					tbl_2[1],
					3
				}
			},
			right_glow = {
				size = tbl_2,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_4[1],
					tbl_4[2],
					1
				}
			},
			right_frame = {
				size = tbl_2,
				texture_size = var_231_2.texture_size,
				texture_sizes = var_231_2.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_4[1],
					tbl_4[2],
					5
				}
			},
			right_background = {
				size = tbl_2,
				color = {
					255,
					255,
					255,
					255
				},
				offset = tbl_4
			},
			right_button_icon = {
				angle = math.degrees_to_radians(180),
				pivot = {
					14,
					17
				},
				size = tbl,
				offset = {
					tbl_4[1] + (tbl_2[1] / 2 - tbl[1] / 2),
					tbl_4[2] + (tbl_2[2] / 2 - tbl[2] / 2),
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			right_button_icon_clicked = {
				angle = math.degrees_to_radians(180),
				color = {
					0,
					255,
					255,
					255
				},
				pivot = {
					14,
					17
				},
				size = tbl,
				offset = {
					tbl_4[1] + (tbl_2[1] / 2 - tbl[1] / 2),
					tbl_4[2] + (tbl_2[2] / 2 - tbl[2] / 2),
					3
				}
			}
		},
		scenegraph_id = arg_231_0
	}
end

UIWidgets.create_title_and_tooltip = function (arg_236_0, arg_236_1, arg_236_2, arg_236_3, arg_236_4, arg_236_5)
	-- function 236
	local var_236_0

	if not arg_236_4 then
		var_236_0 = table.clone(arg_236_4)
		var_236_0.text_color = Colors.get_color_table_with_alpha("gray", 128)
	end

	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 237
						return not self.disabled
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 238
						return self.disabled
					end
				},
				{
					pass_type = "hotspot",
					content_id = "tooltip_hotspot",
					content_check_function = function (self)
						-- function 239
						return not self.disabled
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text",
					content_check_function = function (self)
						-- function 240
						return not not self.disabled or self.tooltip_hotspot.is_hover
					end
				}
			}
		},
		content = {
			tooltip_hotspot = {
				allow_multi_hover = true
			},
			tooltip_text = arg_236_3,
			text = arg_236_2
		},
		style = {
			text = arg_236_4 or {
				vertical_alignment = "center",
				font_size = 20,
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255)
			},
			text_disabled = var_236_0 or {
				vertical_alignment = "center",
				font_size = 20,
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("gray", 128)
			},
			tooltip_text = arg_236_5 or {
				font_size = 24,
				max_width = 500,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {},
				offset = {
					0,
					0,
					50
				}
			}
		},
		scenegraph_id = arg_236_0
	}
end

UIWidgets.create_icon_selector = function (arg_241_0, arg_241_1, arg_241_2, arg_241_3, arg_241_4, arg_241_5, arg_241_6, arg_241_7)
	-- function 241
	local tbl = {
		255,
		255,
		255,
		255
	}
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_title", 255)
	local count = #arg_241_2
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {}
	local tbl_4 = {
		amount = count,
		disable_cross = arg_241_7
	}
	local tbl_5 = {}
	local flag = arg_241_3 or 0
	local num = 0
	local num_2 = -flag
	local num_3 = 0
	local default = UIPlayerPortraitFrameSettings.default

	for i = 1, count do
		local str = "_" .. tostring(i)
		local num_4 = i - 1

		num_2 = num_2 + arg_241_1[1] + flag

		local tbl_6 = {
			num_3,
			0,
			num
		}
		local str_2 = "hotspot" .. str

		tbl_3[#tbl_3 + 1] = {
			pass_type = "hotspot",
			content_id = str_2,
			style_id = str_2
		}
		tbl_5[str_2] = {
			size = arg_241_1,
			offset = tbl_6
		}
		tbl_4[str_2] = {
			allow_multi_hover = arg_241_6
		}

		local var_241_16 = tbl_4[str_2]
		local var_241_17 = arg_241_2[i]
		local str_3 = "icon" .. str

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			content_id = str_2,
			texture_id = str_3,
			style_id = str_3,
			content_check_function = function (self)
				-- function 242
				return not self.disable_button
			end
		}
		tbl_5[str_3] = {
			size = arg_241_1,
			color = tbl,
			offset = {
				tbl_6[1],
				tbl_6[2],
				tbl_6[3] + 2
			}
		}
		var_241_16[str_3] = var_241_17

		local var_241_19 = arg_241_2[i]
		local str_4 = "icon" .. str .. "_saturated"

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			content_id = str_2,
			texture_id = str_4,
			style_id = str_4,
			content_check_function = function (self)
				-- function 243
				return self.disable_button
			end
		}
		tbl_5[str_4] = {
			size = arg_241_1,
			color = tbl,
			default_color = tbl,
			disabled_color = {
				255,
				30,
				30,
				30
			},
			offset = {
				tbl_6[1],
				tbl_6[2],
				tbl_6[3] + 2
			}
		}
		var_241_16[str_4] = var_241_19 .. "_saturated"

		local str_5 = "selection_icon" .. str

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			content_id = str_2,
			texture_id = str_5,
			style_id = str_5,
			content_check_function = function (self)
				-- function 244
				local var_244_0 = self[str_5]

				var_244_0 = not var_244_0 and self.is_selected

				return var_244_0
			end
		}
		tbl_5[str_5] = {
			size = arg_241_1,
			color = tbl,
			offset = {
				tbl_6[1],
				tbl_6[2],
				tbl_6[3] + 3
			},
			default_offset = {
				tbl_6[1],
				tbl_6[2],
				tbl_6[3] + 4
			}
		}

		local str_6 = "disabled" .. str

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			content_id = str_2,
			texture_id = str_6,
			style_id = str_6,
			content_check_function = function (self)
				-- function 245
				local disable_button = self.disable_button

				disable_button = not disable_button and not not self.locked or not self.parent.disable_cross

				return disable_button
			end
		}
		tbl_5[str_6] = {
			saturated = true,
			size = arg_241_1,
			color = tbl,
			offset = {
				tbl_6[1],
				tbl_6[2],
				tbl_6[3] + 4
			}
		}
		var_241_16[str_6] = "kick_player_icon"

		local str_7 = "locked" .. str

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			content_id = str_2,
			texture_id = str_7,
			style_id = str_7,
			content_check_function = function (self)
				-- function 246
				return self.locked
			end
		}
		tbl_5[str_7] = {
			size = {
				30,
				38
			},
			color = tbl,
			offset = {
				tbl_6[1] + arg_241_1[1] / 2 - 15,
				tbl_6[2] + arg_241_1[2] / 2 - 19,
				tbl_6[3] + 5
			}
		}
		var_241_16[str_7] = "locked_icon_01"

		if not arg_241_4 then
			local str_8 = "frame" .. str

			tbl_3[#tbl_3 + 1] = {
				pass_type = "texture",
				content_id = str_2,
				texture_id = str_8,
				style_id = str_8
			}

			local clone

			if not arg_241_5 then
				clone = table.clone(arg_241_5)

				if not clone then
					-- Nothing
				end
			end

			clone = {
				86,
				108
			}

			::label_241_0::

			tbl_5[str_8] = {
				size = {
					clone[1],
					clone[2]
				},
				color = tbl,
				offset = {
					tbl_6[1] + arg_241_1[1] / 2 - clone[1] / 2,
					tbl_6[2] + arg_241_1[2] / 2 - clone[2] / 2,
					tbl_6[3] + 3
				}
			}
			var_241_16[str_8] = "portrait_frame_hero_selection"
		end

		num_3 = num_3 + arg_241_1[1] + flag
	end

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		-num_2 / 2,
		0,
		0
	}
	tbl_2.scenegraph_id = arg_241_0

	return tbl_2
end

UIWidgets.create_title_widget = function (arg_247_0, arg_247_1, arg_247_2, arg_247_3, arg_247_4, arg_247_5, arg_247_6)
	-- function 247
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text"
		}
	}
	local tbl_3 = {
		title_text = arg_247_2 or "n/a"
	}
	local tbl_4 = {
		title_text = {
			vertical_alignment = "center",
			upper_case = true,
			horizontal_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_247_6 or 24,
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				0,
				arg_247_1[2] - 40,
				3
			},
			size = {
				arg_247_1[1],
				30
			}
		}
	}

	if not arg_247_4 then
		local num = arg_247_1[1] * 0.3

		tbl_2[#tbl_2 + 1] = {
			texture_id = "title_detail_center",
			style_id = "title_detail_center",
			pass_type = "texture"
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "title_detail_line",
			style_id = "title_detail_line",
			pass_type = "texture"
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "title_detail_left",
			style_id = "title_detail_left",
			pass_type = "texture"
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "title_detail_right",
			style_id = "title_detail_right",
			pass_type = "texture"
		}
		tbl_4.title_detail_center = {
			size = {
				85,
				17
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_247_1[1] / 2 - 42.5,
				arg_247_1[2] - 60,
				4
			}
		}
		tbl_4.title_detail_line = {
			size = {
				num,
				17
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_247_1[1] / 2 - num / 2,
				arg_247_1[2] - 60,
				3
			}
		}
		tbl_4.title_detail_left = {
			size = {
				7,
				17
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_247_1[1] / 2 - num / 2 - 7,
				arg_247_1[2] - 60,
				3
			}
		}
		tbl_4.title_detail_right = {
			size = {
				7,
				17
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_247_1[1] / 2 + num / 2,
				arg_247_1[2] - 60,
				3
			}
		}
		tbl_3.title_detail_center = "title_detail_01_middle"
		tbl_3.title_detail_line = "title_detail_01_tile"
		tbl_3.title_detail_left = "title_detail_01_left"
		tbl_3.title_detail_right = "title_detail_01_right"
	end

	if not arg_247_3 then
		tbl_2[#tbl_2 + 1] = {
			texture_id = "title_bg_fade",
			style_id = "title_bg_fade",
			pass_type = "rotated_texture"
		}
		tbl_3.title_bg_fade = "edge_fade_small"

		if not arg_247_5 then
			tbl_4.title_bg_fade = {
				angle = 0,
				pivot = {
					arg_247_1[1] / 2,
					40
				},
				size = {
					arg_247_1[1],
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
					arg_247_1[2] - 80,
					1
				}
			}
		else
			tbl_4.title_bg_fade = {
				pivot = {
					arg_247_1[1] / 2,
					40
				},
				angle = math.degrees_to_radians(180),
				size = {
					arg_247_1[1],
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
					arg_247_1[2] - 80,
					1
				}
			}
		end
	end

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_247_0

	return tbl
end

UIWidgets.create_large_window_title = function (arg_248_0, arg_248_1, arg_248_2, arg_248_3)
	-- function 248
	local str = "menu_frame_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local button_frame_01 = UIFrameSettings.button_frame_01
	local str_2 = "frame_title_detail_06"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2).size

	return {
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail"
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 249
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 250
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				}
			}
		},
		content = {
			glow = "button_state_normal",
			side_detail = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = str_2
			},
			button_hotspot = {},
			title_text = arg_248_2 or "n/a",
			frame = button_frame_01.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_248_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_248_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = str
			}
		},
		style = {
			background = {
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
			glow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					button_frame_01.texture_sizes.horizontal[2] - 1,
					2
				},
				size = {
					arg_248_1[1],
					math.min(60, arg_248_1[2] - button_frame_01.texture_sizes.horizontal[2] * 2)
				}
			},
			title_text = {
				vertical_alignment = "center",
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_248_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					5
				}
			},
			title_text_disabled = {
				vertical_alignment = "center",
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_248_3 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					0,
					5
				}
			},
			title_text_shadow = {
				vertical_alignment = "center",
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_248_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					4
				}
			},
			frame = {
				texture_size = button_frame_01.texture_size,
				texture_sizes = button_frame_01.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					7
				}
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-32,
					0,
					8
				},
				size = {
					size[1],
					size[2]
				}
			},
			side_detail_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_248_1[1] - 48,
					0,
					8
				},
				size = {
					size[1],
					size[2]
				}
			}
		},
		scenegraph_id = arg_248_0,
		offset = {
			0,
			0,
			0
		}
	}
end

GAMEPAD_CURSOR_SIZE = 64

UIWidgets.create_console_cursor = function (arg_251_0)
	-- function 251
	local tbl = {
		element = {}
	}
	local tbl_2 = {
		{
			pass_type = "gamepad_cursor",
			style_id = "cursor",
			texture_id = "cursor",
			content_check_function = function (arg_252_0, arg_252_1)
				-- function 252
				return not Managers.popup:has_popup()
			end
		}
	}
	local tbl_3 = {
		cursor = "console_cursor"
	}
	local tbl_4 = {
		cursor = {
			size = {
				GAMEPAD_CURSOR_SIZE,
				GAMEPAD_CURSOR_SIZE
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-GAMEPAD_CURSOR_SIZE * 0.5,
				-GAMEPAD_CURSOR_SIZE * 0.5,
				1000
			}
		}
	}

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_251_0

	return tbl
end

UIWidgets.create_difficulty_selector = function (arg_253_0, arg_253_1, arg_253_2, arg_253_3, arg_253_4)
	-- function 253
	local tbl = {
		255,
		255,
		255,
		255
	}
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_title", 255)
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {}
	local tbl_4 = {
		amount = arg_253_3
	}
	local tbl_5 = {
		background = {
			color = {
				255,
				5,
				5,
				5
			},
			offset = {
				0,
				0,
				0
			}
		},
		background_top = {
			size = {
				arg_253_1[1] - 2,
				arg_253_1[2] - 2
			},
			color = {
				255,
				15,
				15,
				15
			},
			offset = {
				2,
				0,
				1
			}
		}
	}
	local flag = arg_253_2 or 0
	local num = 0
	local num_2 = -flag
	local num_3 = (arg_253_1[1] - flag * (arg_253_3 - 1)) / arg_253_3

	arg_253_4 = arg_253_4 or {
		194,
		190
	}

	local tbl_6 = {
		num_3,
		arg_253_1[2]
	}
	local num_4 = 0
	local menu_frame_06 = UIFrameSettings.menu_frame_06

	for i = 1, arg_253_3 do
		local str = "_" .. tostring(i)
		local num_5 = i - 1

		num_2 = num_2 + tbl_6[1] + flag

		local tbl_7 = {
			num_4,
			0,
			num
		}
		local str_2 = "hotspot" .. str

		tbl_3[#tbl_3 + 1] = {
			pass_type = "hotspot",
			content_id = str_2,
			style_id = str_2
		}
		tbl_5[str_2] = {
			size = tbl_6,
			offset = tbl_7
		}
		tbl_4[str_2] = {}

		local var_253_17 = tbl_4[str_2]
		local str_3 = "background_image" .. str

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			content_id = str_2,
			texture_id = str_3,
			style_id = str_3
		}
		tbl_5[str_3] = {
			size = arg_253_4,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1] + tbl_6[1] / 2 - arg_253_4[1] / 2,
				tbl_7[2] + tbl_6[2] - arg_253_4[2],
				2
			}
		}
		var_253_17[str_3] = "difficulty_option_" .. i

		local str_4 = "background_glow" .. str

		tbl_5[str_4] = {
			size = {
				tbl_6[1],
				tbl_6[2]
			},
			color = {
				200,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2],
				1
			}
		}
		var_253_17[str_4] = "tabs_glow"

		local str_5 = "background_glow_select" .. str

		tbl_5[str_5] = {
			size = {
				tbl_6[1],
				tbl_6[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2],
				2
			}
		}
		var_253_17[str_5] = "tabs_glow_animated"

		local str_6 = "title_text" .. str

		tbl_3[#tbl_3 + 1] = {
			pass_type = "text",
			text_id = str_6,
			style_id = str_6
		}
		tbl_5[str_6] = {
			upper_case = false,
			font_size = 32,
			word_wrap = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				tbl_6[1],
				tbl_6[2] * 0.2 - menu_frame_06.texture_sizes.vertical[1]
			},
			offset = {
				tbl_7[1],
				tbl_7[2],
				7
			}
		}
		var_253_17[str_6] = "title_text"
		num_4 = num_4 + num_3 + flag
	end

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = arg_253_0

	return tbl_2
end

UIWidgets.create_base_portrait_frame = function (arg_254_0, arg_254_1, arg_254_2, arg_254_3, arg_254_4, arg_254_5)
	-- function 254
	arg_254_2 = arg_254_2 or 1

	local flag = arg_254_1 or "default"
	local var_254_1 = UIPlayerPortraitFrameSettings[flag]
	local tbl = {
		255,
		255,
		255,
		255
	}
	local tbl_2 = {
		0,
		0,
		0
	}
	local tbl_3 = {
		element = {}
	}
	local tbl_4 = {}
	local tbl_5 = {
		scale = arg_254_2,
		frame_settings_name = flag
	}
	local tbl_6 = {}

	for i, v in ipairs(var_254_1) do
		local str = "texture_" .. i
		local texture = v.texture

		texture = texture or "icons_placeholder"

		local size = v.size

		if not UIAtlasHelper.has_atlas_settings_by_texture_name(texture) then
			size = UIAtlasHelper.get_atlas_settings_by_texture_name(texture).size
		else
			size = v.size
		end

		local flag_2

		flag_2 = not size and table.clone(size) and {
			0,
			0
		}
		flag_2[1] = flag_2[1] * arg_254_2
		flag_2[2] = flag_2[2] * arg_254_2

		local clone = table.clone
		local offset

		if not arg_254_5 then
			offset = v.offset

			if not offset then
				-- Nothing
			end
		end

		offset = tbl_2

		::label_254_0::

		local var_254_14 = clone(offset)

		var_254_14[1] = var_254_14[1] * arg_254_2
		var_254_14[2] = var_254_14[2] * arg_254_2

		local layer = v.layer

		layer = layer or 0
		var_254_14[3] = layer
		tbl_4[#tbl_4 + 1] = {
			pass_type = "texture",
			texture_id = str,
			style_id = str
		}
		tbl_5[str] = texture

		local tbl_7 = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_254_4
		}
		local color = v.color

		color = color or tbl
		tbl_7.color = color
		tbl_7.offset = var_254_14
		tbl_7.texture_size = flag_2
		tbl_6[str] = tbl_7
	end

	tbl_3.element.passes = tbl_4
	tbl_3.content = tbl_5
	tbl_3.style = tbl_6
	tbl_3.offset = arg_254_3 or {
		0,
		0,
		0
	}
	tbl_3.scenegraph_id = arg_254_0

	return tbl_3
end

UIWidgets.create_portrait_frame = function (arg_255_0, arg_255_1, arg_255_2, arg_255_3, arg_255_4, arg_255_5)
	-- function 255
	arg_255_3 = arg_255_3 or 1

	local flag = arg_255_1 or "default"
	local var_255_1 = UIPlayerPortraitFrameSettings[flag]
	local tbl = {
		255,
		255,
		255,
		255
	}
	local tbl_2 = {
		0,
		-60,
		0
	}
	local tbl_3 = {
		element = {}
	}
	local tbl_4 = {}
	local tbl_5 = {
		scale = arg_255_3,
		frame_settings_name = flag
	}
	local tbl_6 = {}
	local tbl_7 = {
		level = arg_255_2
	}

	for i, v in ipairs(var_255_1) do
		local str = "texture_" .. i
		local texture = v.texture

		texture = texture or "icons_placeholder"

		local size = v.size

		if not UIAtlasHelper.has_atlas_settings_by_texture_name(texture) then
			size = UIAtlasHelper.get_atlas_settings_by_texture_name(texture).size
		else
			size = v.size
		end

		local flag_2

		flag_2 = not size and table.clone(size) and {
			0,
			0
		}
		flag_2[1] = flag_2[1] * arg_255_3
		flag_2[2] = flag_2[2] * arg_255_3

		local clone = table.clone
		local offset = v.offset

		offset = offset or tbl_2

		local var_255_15 = clone(offset)

		var_255_15[1] = -(flag_2[1] / 2) + var_255_15[1] * arg_255_3
		var_255_15[2] = var_255_15[2] * arg_255_3

		local layer = v.layer

		layer = layer or 0
		var_255_15[3] = layer
		tbl_4[#tbl_4 + 1] = {
			pass_type = "texture",
			texture_id = str,
			style_id = str,
			retained_mode = arg_255_4,
			context = tbl_7,
			clone = v.clone,
			material_func = v.material_func
		}
		tbl_5[str] = texture

		local tbl_8 = {}
		local color = v.color

		color = color or tbl
		tbl_8.color = color
		tbl_8.offset = var_255_15
		tbl_8.size = flag_2
		tbl_6[str] = tbl_8
	end

	if not arg_255_5 then
		local tbl_9 = {
			86,
			108
		}

		tbl_9[1] = tbl_9[1] * arg_255_3
		tbl_9[2] = tbl_9[2] * arg_255_3

		local tbl_10 = {
			0,
			0,
			0
		}

		tbl_10[1] = -(tbl_9[1] / 2) + tbl_10[1] * arg_255_3
		tbl_10[2] = -(tbl_9[2] / 2) + tbl_10[2] * arg_255_3
		tbl_10[3] = 1

		local str_2 = "portrait"

		tbl_4[#tbl_4 + 1] = {
			pass_type = "texture",
			texture_id = str_2,
			style_id = str_2,
			retained_mode = arg_255_4
		}
		tbl_5[str_2] = arg_255_5
		tbl_6[str_2] = {
			color = tbl,
			offset = tbl_10,
			size = tbl_9
		}
	end

	local tbl_11 = {
		86,
		108
	}

	tbl_11[1] = tbl_11[1] * arg_255_3
	tbl_11[2] = tbl_11[2] * arg_255_3

	local tbl_12 = {
		22,
		15
	}
	local tbl_13 = {
		0,
		0,
		0
	}

	tbl_13[1] = tbl_13[1] * arg_255_3 - tbl_12[1] / 2 - 1
	tbl_13[2] = -(tbl_11[2] / 2) + tbl_13[2] * arg_255_3 - 4
	tbl_13[3] = 15

	local str_3 = "level"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "text",
		text_id = str_3,
		style_id = str_3,
		retained_mode = arg_255_4
	}
	tbl_5[str_3] = arg_255_2
	tbl_6[str_3] = {
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = 12,
		horizontal_alignment = "center",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = tbl_13,
		size = tbl_12
	}
	tbl_3.element.passes = tbl_4
	tbl_3.content = tbl_5
	tbl_3.style = tbl_6
	tbl_3.offset = {
		0,
		0,
		0
	}
	tbl_3.scenegraph_id = arg_255_0

	return tbl_3
end

UIWidgets.create_portrait_frame_button = function (arg_256_0, arg_256_1, arg_256_2, arg_256_3, arg_256_4)
	-- function 256
	arg_256_2 = arg_256_2 or 1

	local var_256_0 = UIPlayerPortraitFrameSettings[arg_256_1]
	local tbl = {
		255,
		255,
		255,
		255
	}
	local tbl_2 = {
		0,
		0,
		0
	}
	local tbl_3 = {
		element = {}
	}
	local tbl_4 = {}
	local tbl_5 = {
		scale = arg_256_2,
		frame_settings_name = arg_256_1
	}
	local tbl_6 = {}

	for i, v in ipairs(var_256_0) do
		local str = "texture_" .. i
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
		flag[1] = flag[1] * arg_256_2
		flag[2] = flag[2] * arg_256_2

		local clone = table.clone
		local offset = v.offset

		offset = offset or tbl_2

		local var_256_14 = clone(offset)

		var_256_14[1] = -(flag[1] / 2) + var_256_14[1] * arg_256_2
		var_256_14[2] = -(flag[2] / 2) + var_256_14[2] * arg_256_2

		local layer = v.layer

		layer = layer or 0
		var_256_14[3] = layer
		tbl_4[#tbl_4 + 1] = {
			pass_type = "texture",
			texture_id = str,
			style_id = str,
			retained_mode = arg_256_3
		}
		tbl_5[str] = texture

		local tbl_7 = {}
		local color = v.color

		color = color or tbl
		tbl_7.color = color
		tbl_7.offset = var_256_14
		tbl_7.size = flag
		tbl_6[str] = tbl_7
	end

	local tbl_8 = {
		86,
		108
	}

	tbl_8[1] = tbl_8[1] * arg_256_2
	tbl_8[2] = tbl_8[2] * arg_256_2

	local clone_2 = table.clone(tbl_2)

	clone_2[1] = -(tbl_8[1] / 2) + clone_2[1] * arg_256_2
	clone_2[2] = -(tbl_8[2] / 2) + 25 * arg_256_2
	clone_2[3] = 20

	local str_2 = "portrait"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		texture_id = str_2,
		style_id = str_2,
		retained_mode = arg_256_3
	}
	tbl_5[str_2] = arg_256_4
	tbl_6[str_2] = {
		color = tbl,
		offset = clone_2,
		size = tbl_8
	}

	local str_3 = "button_hotspot"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "hotspot",
		content_id = str_3,
		style_id = str_3,
		retained_mode = arg_256_3
	}
	tbl_5[str_3] = {}
	tbl_6[str_3] = {
		size = tbl_8,
		offset = clone_2
	}

	local str_4 = "hover_texture"

	tbl_4[#tbl_4 + 1] = {
		pass_type = "texture",
		texture_id = str_4,
		style_id = str_4,
		retained_mode = arg_256_3,
		content_check_function = function (self)
			-- function 257
			return self.button_hotspot.is_hover
		end
	}
	tbl_5[str_4] = "ability_inner_effect_1"
	tbl_6[str_4] = {
		color = tbl,
		offset = {
			clone_2[1],
			clone_2[2],
			-2
		},
		size = tbl_8
	}
	tbl_3.element.passes = tbl_4
	tbl_3.content = tbl_5
	tbl_3.style = tbl_6
	tbl_3.offset = {
		0,
		0,
		0
	}
	tbl_3.scenegraph_id = arg_256_0

	return tbl_3
end

UIWidgets.create_score_entry = function (arg_258_0, arg_258_1, arg_258_2, arg_258_3)
	-- function 258
	local tbl = {
		255,
		255,
		255,
		255
	}
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_title", 255)
	local str = "menu_frame_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {}
	local tbl_4 = {
		num_rows = arg_258_2
	}
	local tbl_5 = {}
	local menu_frame_09 = UIFrameSettings.menu_frame_09
	local str_2 = "scoreboard_topic_bg"
	local str_3 = "scoreboard_topic_bg_highlight"
	local get_atlas_settings_by_texture_name_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)
	local tbl_6 = {
		arg_258_1[1],
		get_atlas_settings_by_texture_name_2.size[2]
	}
	local tbl_7 = {
		0,
		0,
		0
	}
	local str_4 = "hotspot"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "hotspot",
		content_id = str_4,
		style_id = str_4
	}
	tbl_5[str_4] = {
		size = arg_258_1,
		offset = tbl_7
	}
	tbl_4[str_4] = {
		allow_multi_hover = true
	}

	local var_258_15 = tbl_4[str_4]
	local str_5 = "background"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "rect",
		style_id = str_5
	}
	tbl_5[str_5] = {
		size = arg_258_1,
		color = {
			200,
			0,
			0,
			0
		},
		offset = {
			tbl_7[1],
			tbl_7[2],
			0
		}
	}

	local str_6 = "background_left_glow"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture_uv",
		content_id = str_6,
		style_id = str_6
	}
	tbl_5[str_6] = {
		size = {
			arg_258_1[1] / 2,
			arg_258_1[2]
		},
		color = Colors.get_color_table_with_alpha("blue", 255),
		offset = {
			tbl_7[1],
			tbl_7[2],
			1
		}
	}
	tbl_4[str_6] = {
		texture_id = "talent_bg_glow_01",
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

	local str_7 = "background_right_glow"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture_uv",
		content_id = str_7,
		style_id = str_7
	}
	tbl_5[str_7] = {
		size = {
			arg_258_1[1] / 2,
			arg_258_1[2]
		},
		color = Colors.get_color_table_with_alpha("blue", 255),
		offset = {
			tbl_7[1] + arg_258_1[1] / 2,
			tbl_7[2],
			1
		}
	}
	tbl_4[str_7] = {
		texture_id = "talent_bg_glow_01",
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

	local str_8 = "glass_bottom"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		content_id = str_4,
		texture_id = str_8,
		style_id = str_8
	}
	tbl_5[str_8] = {
		size = {
			arg_258_1[1],
			3
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_7[1],
			tbl_7[2] + menu_frame_09.texture_sizes.vertical[1],
			2
		}
	}
	var_258_15[str_8] = "tabs_glass_bottom"

	local str_9 = "glass_top"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		content_id = str_4,
		texture_id = str_9,
		style_id = str_9
	}
	tbl_5[str_9] = {
		size = {
			arg_258_1[1],
			3
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_7[1],
			tbl_7[2] + arg_258_1[2] - (menu_frame_09.texture_sizes.vertical[1] + 3),
			2
		}
	}
	var_258_15[str_9] = "tabs_glass_top"

	local str_10 = "frame"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture_frame",
		content_id = str_4,
		texture_id = str_10,
		style_id = str_10
	}
	tbl_5[str_10] = {
		size = arg_258_1,
		texture_size = menu_frame_09.texture_size,
		texture_sizes = menu_frame_09.texture_sizes,
		color = tbl,
		offset = {
			tbl_7[1],
			tbl_7[2],
			10
		}
	}
	var_258_15[str_10] = menu_frame_09.texture

	local str_11 = "edge_fade"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		content_id = str_4,
		texture_id = str_11,
		style_id = str_11,
		content_check_function = function (self)
			-- function 259
			return not self.is_selected
		end
	}
	tbl_5[str_11] = {
		size = {
			arg_258_1[1],
			15
		},
		color = {
			200,
			255,
			255,
			255
		},
		offset = {
			tbl_7[1],
			tbl_7[2] + menu_frame_09.texture_sizes.vertical[1],
			5
		}
	}
	var_258_15[str_11] = "edge_fade_small"

	for i = 1, arg_258_2 do
		local str_12 = "_" .. i
		local num = -(i * tbl_6[2])
		local tbl_8 = {
			tbl_7[1],
			tbl_7[2] + arg_258_1[2] - 80 + num,
			tbl_7[3] + 5
		}
		local str_13 = "row_bg" .. str_12

		tbl_3[#tbl_3 + 1] = {
			texture_id = "texture_id",
			pass_type = "tiled_texture",
			content_id = str_13,
			style_id = str_13,
			content_check_function = function (self)
				-- function 260
				local hover_index = self.parent.hover_index

				if not (not hover_index and hover_index ~= i) then
					return false
				end

				return self.has_background
			end
		}
		tbl_4[str_13] = {
			has_background = false,
			texture_id = str_2
		}
		tbl_5[str_13] = {
			size = tbl_6,
			color = {
				150,
				255,
				255,
				255
			},
			offset = tbl_8,
			texture_tiling_size = get_atlas_settings_by_texture_name_2.size
		}

		if i ~= 1 then
			local str_14 = "highlight_row_bg" .. str_12

			tbl_3[#tbl_3 + 1] = {
				texture_id = "texture_id",
				pass_type = "tiled_texture",
				content_id = str_14,
				style_id = str_14,
				content_check_function = function (self)
					-- function 261
					local hover_index = self.parent.hover_index

					return not hover_index and hover_index == i
				end
			}
			tbl_5[str_14] = {
				size = tbl_6,
				color = Colors.get_color_table_with_alpha("white", 20),
				offset = {
					tbl_8[1],
					tbl_8[2],
					tbl_8[3] + 1
				},
				texture_tiling_size = get_atlas_settings_by_texture_name_2.size
			}
			tbl_4[str_14] = {
				has_background = false,
				texture_id = str_3
			}
		end

		local str_15 = "score_text" .. str_12

		tbl_3[#tbl_3 + 1] = {
			pass_type = "text",
			content_id = str_13,
			text_id = str_15,
			style_id = str_15
		}
		tbl_5[str_15] = {
			vertical_alignment = "center",
			font_size = 22,
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "arial",
			text_color = i ~= 1 or not get_color_table_with_alpha or Colors.get_color_table_with_alpha("font_default", 255),
			size = tbl_6,
			offset = {
				tbl_8[1],
				tbl_8[2],
				tbl_8[3] + 20
			}
		}
		tbl_4[str_13][str_15] = ""

		local str_16 = "score_text_shadow" .. str_12

		tbl_3[#tbl_3 + 1] = {
			pass_type = "text",
			content_id = str_13,
			text_id = str_15,
			style_id = str_16
		}
		tbl_5[str_16] = {
			vertical_alignment = "center",
			font_size = 22,
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "arial",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = tbl_6,
			offset = {
				tbl_8[1] + 2,
				tbl_8[2] - 2,
				tbl_8[3] + 19
			}
		}

		if i ~= 1 then
			local str_17 = "score_text_highlight" .. str_12

			tbl_3[#tbl_3 + 1] = {
				pass_type = "text",
				content_id = str_13,
				text_id = str_15,
				style_id = str_17,
				content_check_function = function (self)
					-- function 262
					local hover_index = self.parent.hover_index

					return not hover_index and hover_index == i
				end
			}
			tbl_5[str_17] = {
				vertical_alignment = "center",
				font_size = 22,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "arial",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				size = tbl_6,
				offset = {
					tbl_8[1],
					tbl_8[2],
					tbl_8[3] + 30
				}
			}
		end

		local str_18 = "marker" .. str_12

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			texture_id = str_18,
			style_id = str_18,
			content_check_function = function (self)
				-- function 263
				return self[str_13].has_highscore
			end
		}
		tbl_5[str_18] = {
			size = {
				71,
				39
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_8[1] + tbl_6[1] / 2 - 35.5,
				tbl_8[2] + tbl_6[2] / 2 - 19.5,
				tbl_8[3] + 4
			}
		}
		tbl_4[str_18] = "scoreboard_marker"
	end

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = arg_258_0

	return tbl_2
end

UIWidgets.create_score_topics = function (arg_264_0, arg_264_1, arg_264_2, arg_264_3)
	-- function 264
	local tbl = {
		255,
		255,
		255,
		255
	}
	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_title", 255)
	local str = "menu_frame_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {}
	local tbl_4 = {
		num_rows = arg_264_3
	}
	local tbl_5 = {}
	local menu_frame_09 = UIFrameSettings.menu_frame_09
	local str_2 = "scoreboard_topic_bg"
	local str_3 = "scoreboard_topic_bg_highlight"
	local get_atlas_settings_by_texture_name_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)
	local tbl_6 = {
		arg_264_1[1],
		get_atlas_settings_by_texture_name_2.size[2]
	}
	local num = 80
	local tbl_7 = {
		0,
		0,
		0
	}
	local tbl_8 = {
		arg_264_1[1],
		arg_264_1[2] - num
	}
	local str_4 = "hotspot"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "hotspot",
		content_id = str_4,
		style_id = str_4
	}
	tbl_5[str_4] = {
		size = arg_264_1,
		offset = tbl_7
	}
	tbl_4[str_4] = {
		allow_multi_hover = true
	}

	local var_264_17 = tbl_4[str_4]
	local str_5 = "background"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture_uv",
		content_id = str_5,
		style_id = str_5
	}

	local num_2 = 0.8

	tbl_5[str_5] = {
		size = tbl_8,
		color = {
			200,
			0,
			0,
			0
		},
		offset = {
			tbl_7[1],
			tbl_7[2],
			0
		}
	}
	tbl_4[str_5] = {
		uvs = {
			{
				0,
				0
			},
			{
				math.min(tbl_8[1] / get_atlas_settings_by_texture_name.size[1], 1),
				math.min(tbl_8[2] / get_atlas_settings_by_texture_name.size[2], 1)
			}
		},
		texture_id = str
	}

	local str_6 = "glass_bottom"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		content_id = str_4,
		texture_id = str_6,
		style_id = str_6
	}
	tbl_5[str_6] = {
		size = {
			tbl_8[1],
			3
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_7[1],
			tbl_7[2] + menu_frame_09.texture_sizes.vertical[1],
			1
		}
	}
	var_264_17[str_6] = "tabs_glass_bottom"

	local str_7 = "glass_top"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		content_id = str_4,
		texture_id = str_7,
		style_id = str_7
	}
	tbl_5[str_7] = {
		size = {
			tbl_8[1],
			3
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			tbl_7[1],
			tbl_7[2] + tbl_8[2] - (menu_frame_09.texture_sizes.vertical[1] + 3),
			1
		}
	}
	var_264_17[str_7] = "tabs_glass_top"

	local str_8 = "frame"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture_frame",
		content_id = str_4,
		texture_id = str_8,
		style_id = str_8
	}
	tbl_5[str_8] = {
		size = tbl_8,
		texture_size = menu_frame_09.texture_size,
		texture_sizes = menu_frame_09.texture_sizes,
		color = tbl,
		offset = {
			tbl_7[1],
			tbl_7[2],
			10
		}
	}
	var_264_17[str_8] = menu_frame_09.texture

	local str_9 = "edge_fade"

	tbl_3[#tbl_3 + 1] = {
		pass_type = "texture",
		content_id = str_4,
		texture_id = str_9,
		style_id = str_9,
		content_check_function = function (self)
			-- function 265
			return not self.is_selected
		end
	}
	tbl_5[str_9] = {
		size = {
			tbl_8[1],
			15
		},
		color = {
			200,
			255,
			255,
			255
		},
		offset = {
			tbl_7[1],
			tbl_7[2] + menu_frame_09.texture_sizes.vertical[1],
			5
		}
	}
	var_264_17[str_9] = "edge_fade_small"

	for i = 1, arg_264_3 do
		local str_10 = "_" .. i
		local str_11 = "row_bg" .. str_10
		local num_3 = -(i * tbl_6[2])
		local tbl_9 = {
			tbl_7[1],
			tbl_7[2] + arg_264_1[2] - num + num_3,
			tbl_7[3] + 5
		}

		tbl_3[#tbl_3 + 1] = {
			texture_id = "texture_id",
			pass_type = "tiled_texture",
			content_id = str_11,
			style_id = str_11,
			content_check_function = function (self)
				-- function 266
				local hover_index = self.parent.hover_index

				if not (not hover_index and hover_index ~= i) then
					return false
				end

				return self.has_background
			end
		}
		tbl_4[str_11] = {
			has_background = false,
			texture_id = str_2
		}

		if i ~= 1 then
			local str_12 = "hotspot" .. str_10

			tbl_3[#tbl_3 + 1] = {
				pass_type = "hotspot",
				content_id = str_12,
				style_id = str_12
			}
			tbl_4[str_12] = {
				allow_multi_hover = true
			}
			tbl_5[str_12] = {
				size = {
					arg_264_2,
					tbl_6[2]
				},
				color = {
					150,
					255,
					255,
					255
				},
				offset = {
					tbl_9[1] - arg_264_2 / 2 + tbl_6[1] / 2,
					tbl_9[2],
					tbl_9[3]
				}
			}

			local str_13 = "highlight_row_bg" .. str_10

			tbl_3[#tbl_3 + 1] = {
				texture_id = "texture_id",
				pass_type = "tiled_texture",
				content_id = str_13,
				style_id = str_13,
				content_check_function = function (self)
					-- function 267
					local hover_index = self.parent.hover_index

					return not hover_index and hover_index == i
				end
			}
			tbl_5[str_13] = {
				size = tbl_6,
				color = Colors.get_color_table_with_alpha("white", 20),
				offset = {
					tbl_9[1],
					tbl_9[2],
					tbl_9[3] + 1
				},
				texture_tiling_size = get_atlas_settings_by_texture_name_2.size
			}
			tbl_4[str_13] = {
				has_background = false,
				texture_id = str_3
			}
		end

		tbl_5[str_11] = {
			size = tbl_6,
			color = {
				150,
				255,
				255,
				255
			},
			offset = tbl_9,
			texture_tiling_size = get_atlas_settings_by_texture_name_2.size
		}

		local str_14 = "score_text" .. str_10

		tbl_3[#tbl_3 + 1] = {
			pass_type = "text",
			content_id = str_11,
			text_id = str_14,
			style_id = str_14
		}
		tbl_5[str_14] = {
			vertical_alignment = "center",
			font_size = 24,
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = tbl_6,
			offset = {
				tbl_9[1],
				tbl_9[2],
				tbl_9[3] + 3
			}
		}
		tbl_4[str_11][str_14] = ""

		local str_15 = "score_text_shadow" .. str_10

		tbl_3[#tbl_3 + 1] = {
			pass_type = "text",
			content_id = str_11,
			text_id = str_14,
			style_id = str_15
		}
		tbl_5[str_15] = {
			font_size = 24,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = tbl_6,
			offset = {
				tbl_9[1] + 2,
				tbl_9[2] - 2,
				tbl_9[3] + 2
			}
		}

		if i ~= 1 then
			local str_16 = "score_text_highlight" .. str_10

			tbl_3[#tbl_3 + 1] = {
				pass_type = "text",
				content_id = str_11,
				text_id = str_14,
				style_id = str_16,
				content_check_function = function (self)
					-- function 268
					local hover_index = self.parent.hover_index

					return not hover_index and hover_index == i
				end
			}
			tbl_5[str_16] = {
				font_size = 24,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				size = tbl_6,
				offset = {
					tbl_9[1],
					tbl_9[2],
					tbl_9[3] + 4
				}
			}
		end

		local str_17 = "marker" .. str_10

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			texture_id = str_17,
			style_id = str_17,
			content_check_function = function (self)
				-- function 269
				return self[str_11].has_highscore
			end
		}
		tbl_5[str_17] = {
			size = {
				71,
				39
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_9[1] + tbl_6[1] / 2 - 35.5,
				tbl_9[2] + tbl_6[2] / 2 - 19.5,
				tbl_9[3] + 2
			}
		}
		tbl_4[str_17] = "scoreboard_marker"
	end

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = arg_264_0

	return tbl_2
end

UIWidgets.create_page_dot_selector = function (arg_270_0, arg_270_1)
	-- function 270
	local tbl = {
		255,
		255,
		255,
		255
	}
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {}
	local tbl_4 = {
		amount = arg_270_1
	}
	local tbl_5 = {}
	local tbl_6 = {
		20,
		20
	}
	local num = 40
	local num_2 = 0
	local num_3 = 0
	local num_4 = tbl_6[1] * arg_270_1 + num * (arg_270_1 - 1)
	local num_5 = num_4 / arg_270_1
	local num_6 = -num_4 / 2

	for i = 1, arg_270_1 do
		local str = "_" .. tostring(i)
		local num_7 = i - 1

		num_3 = num_3 + tbl_6[1] + num

		local tbl_7 = {
			num_6,
			0,
			num_2
		}
		local str_2 = "hotspot" .. str

		tbl_3[#tbl_3 + 1] = {
			pass_type = "hotspot",
			content_id = str_2,
			style_id = str_2
		}
		tbl_5[str_2] = {
			size = tbl_6,
			offset = tbl_7
		}
		tbl_4[str_2] = {}

		local var_270_16 = tbl_4[str_2]
		local str_3 = "selection_texture" .. str

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			texture_id = str_3,
			style_id = str_3,
			content_check_function = function (self)
				-- function 271
				local is_selected = self[str_2].is_selected

				is_selected = is_selected or self[str_2].is_hover

				return is_selected
			end
		}
		tbl_5[str_3] = {
			size = tbl_6,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_7[1],
				tbl_7[2],
				1
			}
		}
		tbl_4[str_3] = "page_indicator_selection"

		local str_4 = "background_texture" .. str

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			texture_id = str_4,
			style_id = str_4
		}
		tbl_5[str_4] = {
			size = tbl_6,
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
			}
		}
		tbl_4[str_4] = "page_indicator"
		num_6 = num_6 + tbl_6[1] + num
	end

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = arg_270_0

	return tbl_2
end

UIWidgets.create_text_input_rect = function (arg_272_0, arg_272_1, arg_272_2, arg_272_3)
	-- function 272
	local tbl = {
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			pass_type = "border",
			style_id = "background_border"
		},
		{
			pass_type = "hotspot",
			style_id = "background"
		},
		{
			pass_type = "keystrokes",
			input_text_id = "input"
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "input"
		}
	}
	local tbl_2 = {
		input_mode = "insert",
		caret_index = 1,
		text_index = 1,
		input = "",
		max_length = arg_272_3
	}
	local tbl_3 = {
		background = {
			color = {
				255,
				0,
				0,
				0
			},
			size = table.clone(arg_272_1)
		},
		background_border = {
			thickness = 2,
			color = {
				255,
				255,
				255,
				255
			},
			size = table.clone(arg_272_1)
		},
		text = {
			font_size = 36,
			horizontal_scroll = true,
			font_type = "hell_shark",
			size = table.clone(arg_272_1),
			text_color = Colors.get_color_table_with_alpha("white", 255),
			caret_size = {
				4,
				30
			},
			caret_offset = {
				-5,
				-5,
				0
			},
			caret_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				arg_272_2[1],
				arg_272_2[2],
				arg_272_2[3] + 1
			}
		}
	}

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
		scenegraph_id = arg_272_0
	}
end

UIWidgets.create_craft_material_widget = function (arg_273_0)
	-- function 273
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					pass_type = "rotated_texture",
					style_id = "effect",
					texture_id = "effect"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 274
						return not self.warning
					end
				},
				{
					style_id = "text_warning",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 275
						return self.warning
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "text_bg",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 276
						return self.draw_background
					end
				},
				{
					style_id = "text_bg_2",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 277
						return self.draw_background
					end
				},
				{
					item_id = "item",
					pass_type = "item_tooltip",
					content_check_function = function (self)
						-- function 278
						local is_hover = self.button_hotspot.is_hover

						is_hover = not is_hover and self.item

						return is_hover
					end
				}
			}
		},
		content = {
			text = "0",
			effect = "sparkle_effect",
			draw_background = true,
			icon = "icon_crafting_dust_01_small",
			warning = false,
			button_hotspot = {}
		},
		style = {
			text_bg = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					60,
					80
				},
				color = {
					0,
					10,
					10,
					10
				},
				offset = {
					2,
					10,
					1
				}
			},
			text_bg_2 = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					60,
					25
				},
				color = {
					180,
					5,
					5,
					5
				},
				offset = {
					0,
					12,
					0
				}
			},
			icon = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = {
					50,
					50
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
					3
				}
			},
			effect = {
				vertical_alignment = "top",
				angle = 0,
				horizontal_alignment = "right",
				offset = {
					110,
					120,
					4
				},
				pivot = {
					128,
					128
				},
				texture_size = {
					256,
					256
				},
				color = Colors.get_color_table_with_alpha("white", 0)
			},
			text = {
				word_wrap = true,
				font_size = 20,
				localize = false,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					10,
					3
				}
			},
			text_warning = {
				word_wrap = true,
				font_size = 20,
				localize = false,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("red", 255),
				offset = {
					0,
					10,
					3
				}
			},
			text_shadow = {
				word_wrap = true,
				font_size = 20,
				localize = false,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					8,
					2
				}
			}
		},
		scenegraph_id = arg_273_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_console_craft_button = function (arg_279_0, arg_279_1)
	-- function 279
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (self)
						-- function 280
						return not self.button_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_hover",
					texture_id = "icon",
					content_check_function = function (self)
						-- function 281
						return self.button_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_glow",
					texture_id = "icon_glow",
					content_check_function = function (self)
						-- function 282
						return not self.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					style_id = "background_glow",
					texture_id = "background_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 283
						return not self.button_hotspot.disable_button
					end,
					content_change_function = function (arg_284_0, arg_284_1)
						-- function 284
						local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

						arg_284_1.color[1] = 55 + num * 200
					end
				}
			}
		},
		content = {
			background_glow = "console_crafting_disc_small_outer_glow",
			background = "console_crafting_disc_small",
			icon_glow = "console_crafting_disc_small_inner_glow",
			button_hotspot = {
				hover_type = "circle"
			},
			icon = arg_279_1
		},
		style = {
			button_hotspot = {
				size = {
					128,
					128
				},
				offset = {
					-64,
					-64,
					0
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					128,
					128
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
					3
				}
			},
			icon_hover = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					128,
					128
				},
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					3
				}
			},
			icon_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					126,
					126
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
					2
				}
			},
			background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					128,
					128
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
			background_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					213,
					213
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
			}
		},
		scenegraph_id = arg_279_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_start_game_console_setting_button = function (arg_285_0, arg_285_1, arg_285_2, arg_285_3, arg_285_4, arg_285_5, arg_285_6)
	-- function 285
	arg_285_3 = arg_285_3 or "level_icon_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_285_3)
	local size

	if not get_atlas_settings_by_texture_name then
		size = get_atlas_settings_by_texture_name.size

		if not size then
			-- Nothing
		end
	end

	size = {
		150,
		150
	}

	::label_285_0::

	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local str = "button_hotspot"

	tbl[#tbl + 1] = {
		pass_type = "hotspot",
		content_id = str
	}
	tbl_2[str] = {}

	local str_2 = "selection_background"

	tbl[#tbl + 1] = {
		pass_type = "texture_uv",
		content_id = str_2,
		style_id = str_2
	}
	tbl_2[str_2] = {
		texture_id = "item_slot_side_fade",
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

	local tbl_4 = {
		168,
		0,
		-2
	}

	tbl_3[str_2] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			414,
			118
		},
		color = UISettings.console_start_game_menu_rect_color,
		offset = tbl_4
	}

	local str_3 = "bg_effect"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_3,
		style_id = str_3
	}
	tbl_3[str_3] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			414,
			126
		},
		color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			tbl_4[1],
			tbl_4[2],
			tbl_4[3] + 1
		}
	}
	tbl_2[str_3] = "item_slot_side_effect"

	local str_4 = "text_title"
	local str_5 = str_4 .. "_shadow"

	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str_4,
		style_id = str_4,
		content_change_function = function (self, arg_286_1)
			-- function 286
			if not self.is_selected then
				arg_286_1.text_color = arg_286_1.selected_color
			else
				arg_286_1.text_color = arg_286_1.default_color
			end
		end
	}
	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str_4,
		style_id = str_5
	}
	tbl_2[str_4] = arg_285_1

	local tbl_5 = {
		225,
		16,
		5
	}
	local tbl_6 = {
		word_wrap = false,
		upper_case = true,
		localize = false,
		font_size = 32,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark_header",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		selected_color = Colors.get_color_table_with_alpha("white", 255),
		default_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			tbl_5[1],
			tbl_5[2],
			tbl_5[3]
		}
	}
	local clone = table.clone(tbl_6)

	clone.text_color = {
		255,
		0,
		0,
		0
	}
	clone.offset = {
		tbl_5[1] + 2,
		tbl_5[2] - 2,
		tbl_5[3] - 1
	}
	tbl_3[str_4] = tbl_6
	tbl_3[str_5] = clone

	local str_6 = "input_text"
	local str_7 = str_6 .. "shadow"

	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str_6,
		style_id = str_6
	}
	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str_6,
		style_id = str_7
	}
	tbl_2[str_6] = arg_285_2 or Localize("not_assigned")

	local tbl_7 = {
		vertical_alignment = "center",
		font_size = 22,
		localize = false,
		horizontal_alignment = "left",
		word_wrap = false,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			tbl_5[1],
			-18,
			tbl_5[3]
		}
	}
	local offset = tbl_7.offset
	local clone_2 = table.clone(tbl_7)

	clone_2.text_color = {
		255,
		0,
		0,
		0
	}
	clone_2.offset = {
		offset[1] + 2,
		offset[2] - 2,
		offset[3] - 1
	}
	tbl_3[str_6] = tbl_7
	tbl_3[str_7] = clone_2

	local tbl_8 = {
		-(arg_285_5[1] / 2) + 108,
		0,
		5
	}
	local tbl_9 = {
		tbl_8[1],
		tbl_8[2],
		tbl_8[3] - 1
	}
	local tbl_10 = {
		tbl_8[1],
		tbl_8[2],
		tbl_8[3] + 2
	}
	local tbl_11 = {
		tbl_8[1],
		tbl_8[2],
		tbl_8[3] + 1
	}

	if not arg_285_6 then
		tbl_9[3] = tbl_8[3] - 2
		tbl_11[3] = tbl_8[3] - 1
	end

	local str_8 = "icon_texture"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		style_id = str_8,
		texture_id = str_8,
		content_check_function = function (self, arg_287_1)
			-- function 287
			return self[str_8]
		end,
		content_change_function = function (self, arg_288_1)
			-- function 288
			if not self.button_hotspot.disable_button then
				arg_288_1.saturated = true
			else
				arg_288_1.saturated = false
			end
		end
	}
	tbl_2[str_8] = arg_285_3
	tbl_3[str_8] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = size,
		color = {
			255,
			255,
			255,
			255
		},
		offset = tbl_8
	}

	local str_9 = "icon_background"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_9,
		style_id = str_9
	}
	tbl_2[str_9] = "level_icon_09"
	tbl_3[str_9] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = size,
		color = UISettings.console_start_game_menu_rect_color,
		offset = tbl_9
	}

	local str_10 = "icon_frame_texture"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		style_id = str_10,
		texture_id = str_10,
		content_check_function = function (self, arg_289_1)
			-- function 289
			return self[str_8]
		end,
		content_change_function = function (self, arg_290_1)
			-- function 290
			if not self.button_hotspot.disable_button then
				arg_290_1.saturated = true
			else
				arg_290_1.saturated = false
			end
		end
	}
	tbl_2[str_10] = arg_285_4 or "map_frame_00"
	tbl_3[str_10] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			180,
			180
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = tbl_10
	}

	local str_11 = "icon_texture_glow"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		style_id = str_11,
		texture_id = str_11,
		content_check_function = function (self)
			-- function 291
			return self.is_selected
		end
	}
	tbl_2[str_11] = "map_frame_glow_02"
	tbl_3[str_11] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			270,
			270
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = tbl_11
	}

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
		scenegraph_id = arg_285_0
	}
end

UIWidgets.create_start_game_console_play_button = function (arg_292_0)
	-- function 292
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local str = "text"
	local str_2 = str .. "_shadow"

	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str,
		style_id = str,
		content_change_function = function (self, arg_293_1)
			-- function 293
			if not self.locked then
				arg_293_1.text_color = arg_293_1.disabled_color
			else
				arg_293_1.text_color = arg_293_1.normal_color
			end
		end
	}
	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str,
		style_id = str_2
	}
	tbl_2[str] = Localize("start_game_window_play")

	local tbl_4 = {
		0,
		6,
		1
	}
	local tbl_5 = {
		word_wrap = false,
		upper_case = true,
		localize = false,
		font_size = 80,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		disabled_color = Colors.get_color_table_with_alpha("dark_gray", 255),
		normal_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			tbl_4[1],
			tbl_4[2],
			tbl_4[3]
		}
	}
	local clone = table.clone(tbl_5)

	clone.text_color = {
		255,
		0,
		0,
		0
	}
	clone.offset = {
		tbl_4[1] + 2,
		tbl_4[2] - 2,
		tbl_4[3] - 1
	}
	tbl_3[str] = tbl_5
	tbl_3[str_2] = clone

	local str_3 = "divider"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_3,
		style_id = str_3
	}
	tbl_2[str_3] = "divider_01_top"
	tbl_3[str_3] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			264,
			32
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			-36,
			1
		}
	}

	local str_4 = "input_texture"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_4,
		style_id = str_4,
		content_change_function = function (self, arg_294_1)
			-- function 294
			if not self.locked then
				arg_294_1.saturated = true
			else
				arg_294_1.saturated = false
			end
		end
	}
	tbl_2[str_4] = ""
	tbl_3[str_4] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
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
			-34,
			2
		}
	}

	local str_5 = "glow"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_5,
		style_id = str_5,
		content_check_function = function (self)
			-- function 295
			return not self.locked
		end
	}
	tbl_2[str_5] = "play_glow_mask"
	tbl_3[str_5] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			256,
			126
		},
		color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			0,
			33,
			-1
		}
	}

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
		scenegraph_id = arg_292_0
	}
end

UIWidgets.create_arrow_button = function (arg_296_0, arg_296_1)
	-- function 296
	return {
		element = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "rotated_texture",
					style_id = "texture_id",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 297
						return not not self.is_gamepad_active or not self.hotspot.disable_button
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "texture_disabled_id",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 298
						return not not self.is_gamepad_active or self.hotspot.disable_button
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "texture_hover_id",
					texture_id = "texture_hover_id",
					content_check_function = function (self)
						-- function 299
						return not self.is_gamepad_active
					end
				}
			}
		},
		content = {
			texture_hover_id = "page_button_arrow_glow",
			texture_id = "page_button_arrow",
			hotspot = {}
		},
		style = {
			hotspot = {
				size = {
					81,
					33
				},
				offset = {
					-40.5,
					-16.5,
					0
				}
			},
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					81,
					33
				},
				pivot = {
					40.5,
					16.5
				},
				angle = arg_296_1 or 0,
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
			texture_disabled_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					81,
					33
				},
				pivot = {
					40.5,
					16.5
				},
				angle = arg_296_1 or 0,
				color = {
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
			texture_hover_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					43,
					48
				},
				pivot = {
					50.5,
					24
				},
				angle = arg_296_1 or 0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-29,
					0,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_296_0
	}
end

UIWidgets.create_icon_and_name_button = function (arg_300_0, arg_300_1, arg_300_2)
	-- function 300
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 301
						return not self.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_disabled_id",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 302
						return self.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_hover_id",
					texture_id = "texture_hover_id",
					content_check_function = function (self)
						-- function 303
						return not self.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_icon_id",
					texture_id = "texture_icon_id",
					content_check_function = function (self)
						-- function 304
						return not self.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_icon_hover_id",
					texture_id = "texture_icon_id",
					content_check_function = function (self)
						-- function 305
						return not self.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_icon_disabled_id",
					texture_id = "texture_icon_id",
					content_check_function = function (self)
						-- function 306
						return self.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_text_bg_id",
					texture_id = "texture_text_bg_id"
				},
				{
					pass_type = "texture",
					style_id = "texture_text_bg_effect_id",
					texture_id = "texture_text_bg_effect_id"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 307
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 308
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 309
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				}
			}
		},
		content = {
			texture_id = "button_small",
			texture_text_bg_id = "item_slot_side_fade",
			texture_hover_id = "button_small_glow",
			texture_text_bg_effect_id = "item_slot_side_effect",
			text = arg_300_2 or "n/a",
			texture_icon_id = arg_300_1 or "icons_placeholder",
			button_hotspot = {}
		},
		style = {
			button_hotspot = {
				size = {
					350,
					114
				},
				offset = {
					-50,
					-57,
					0
				}
			},
			texture_icon_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					50,
					50
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					5,
					3
				}
			},
			texture_icon_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					50,
					50
				},
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					5,
					3
				}
			},
			texture_icon_hover_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					50,
					50
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					5,
					4
				}
			},
			texture_icon_disabled_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					50,
					50
				},
				color = {
					255,
					70,
					70,
					70
				},
				offset = {
					0,
					5,
					4
				}
			},
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					113,
					114
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
					2
				}
			},
			texture_disabled_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					113,
					114
				},
				color = {
					255,
					120,
					120,
					120
				},
				offset = {
					0,
					0,
					2
				}
			},
			texture_hover_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					113,
					114
				},
				color = {
					0,
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
			texture_text_bg_id = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					400,
					72
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					5,
					0
				}
			},
			texture_text_bg_effect_id = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					400,
					76
				},
				color = Colors.get_color_table_with_alpha("font_title", 0),
				offset = {
					0,
					5,
					1
				}
			},
			text = {
				font_size = 52,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				size = {
					400,
					50
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					60,
					-28,
					3
				}
			},
			text_hover = {
				font_size = 52,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				size = {
					400,
					50
				},
				text_color = Colors.get_color_table_with_alpha("white", 0),
				offset = {
					60,
					-28,
					4
				}
			},
			text_disabled = {
				font_size = 52,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				size = {
					400,
					50
				},
				text_color = {
					255,
					70,
					70,
					70
				},
				offset = {
					60,
					-28,
					3
				}
			},
			text_shadow = {
				font_size = 52,
				upper_case = true,
				localize = false,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				size = {
					400,
					50
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					62,
					-30,
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_300_0
	}
end

UIWidgets.create_layout_button = function (arg_310_0, arg_310_1, arg_310_2, arg_310_3)
	-- function 310
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_310_1).size

	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					pass_type = "texture",
					style_id = "texture_shadow_id",
					texture_id = "texture_id"
				},
				{
					pass_type = "texture",
					style_id = "texture_hover_id",
					texture_id = "texture_id"
				},
				{
					pass_type = "texture",
					style_id = "selected_texture",
					texture_id = "selected_texture"
				}
			}
		},
		content = {
			button_hotspot = {},
			texture_id = arg_310_1,
			selected_texture = arg_310_2
		},
		style = {
			button_hotspot = {
				size = {
					60,
					60
				},
				offset = {
					-30,
					-30,
					0
				}
			},
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					size[1],
					size[2]
				},
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					1
				}
			},
			texture_shadow_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					size[1],
					size[2]
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					2,
					-2,
					0
				}
			},
			texture_hover_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					size[1],
					size[2]
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					2
				}
			},
			selected_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					size[1],
					size[2]
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		offset = arg_310_3 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_310_0
	}
end

UIWidgets.create_weave_equipment_button = function (arg_311_0)
	-- function 311
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "texture_background",
					texture_id = "texture_background"
				},
				{
					pass_type = "texture",
					style_id = "texture_icon",
					texture_id = "texture_icon"
				},
				{
					pass_type = "texture",
					style_id = "texture_hover",
					texture_id = "texture_hover"
				},
				{
					pass_type = "texture",
					style_id = "texture_highlight",
					texture_id = "texture_highlight",
					content_check_function = function (self)
						-- function 312
						return self.highlighted
					end
				}
			}
		},
		content = {
			texture_hover = "button_round_highlight",
			texture_background = "button_round_bg",
			highlighted = false,
			texture_highlight = "tutorial_overlay_round",
			texture_icon = "icon_switch",
			button_hotspot = {
				allow_multi_hover = false
			}
		},
		style = {
			texture_background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					74,
					74
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
			texture_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					50,
					45
				},
				color = {
					255,
					255,
					255,
					255
				},
				default_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				hover_color = {
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
			texture_hover = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					96,
					96
				},
				color = {
					0,
					0,
					0,
					0
				},
				default_color = {
					0,
					255,
					255,
					255
				},
				hover_color = {
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
			texture_highlight = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
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
					0,
					0,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_311_0
	}
end

UIWidgets.create_athanor_upgrade_button = function (arg_313_0, arg_313_1, arg_313_2, arg_313_3, arg_313_4, arg_313_5)
	-- function 313
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_313_2).size
	local str = "athanor_icon_loading"
	local size_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(str).size

	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "tooltip",
					additional_option_id = "tooltip",
					pass_type = "additional_option_tooltip",
					content_passes = {
						"weave_progression_slot_titles"
					},
					content_check_function = function (self)
						-- function 314
						local tooltip = self.tooltip

						tooltip = not tooltip and self.button_hotspot.is_hover

						return tooltip
					end
				},
				{
					pass_type = "texture",
					style_id = "price_icon",
					texture_id = "price_icon",
					content_check_function = function (self)
						-- function 315
						return not self.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "price_icon_disabled",
					texture_id = "price_icon",
					content_check_function = function (self)
						-- function 316
						return self.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (self)
						-- function 317
						local button_hotspot = self.button_hotspot
						local icon = self.icon

						icon = not icon and not not button_hotspot.disable_button or not self.upgrading

						return icon
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_disabled",
					texture_id = "icon",
					content_check_function = function (self)
						-- function 318
						local disable_button = self.button_hotspot.disable_button

						if not disable_button then
							disable_button = self.icon
							disable_button = not disable_button and not self.upgrading
						end

						return disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "hover_glow",
					texture_id = "hover_glow"
				},
				{
					pass_type = "texture",
					style_id = "texture_highlight",
					texture_id = "texture_highlight",
					content_check_function = function (self)
						-- function 319
						return self.highlighted
					end
				},
				{
					pass_type = "texture",
					style_id = "clicked_rect",
					texture_id = "overlay"
				},
				{
					pass_type = "texture",
					style_id = "disabled_rect",
					texture_id = "overlay",
					content_check_function = function (self)
						-- function 320
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 321
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 322
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "loading_icon",
					texture_id = "loading_icon",
					pass_type = "rotated_texture",
					content_check_function = function (self)
						-- function 323
						return self.upgrading
					end,
					content_change_function = function (arg_324_0, arg_324_1, arg_324_2, arg_324_3)
						-- function 324
						local progress = arg_324_1.progress

						progress = progress or 0

						local num = (progress + arg_324_3) % 1

						arg_324_1.angle = math.pow(2, math.smoothstep(num, 0, 1)) * (math.pi * 2)
						arg_324_1.progress = num
					end
				}
			}
		},
		content = {
			price_icon = "icon_crafting_essence_small",
			hover_glow = "athanor_button_upgrade_highlight",
			overlay = "athanor_button_upgrade_overlay",
			highlighted = false,
			background = "athanor_button_upgrade",
			texture_highlight = "tutorial_overlay_round",
			icon = arg_313_2,
			loading_icon = str,
			button_hotspot = {},
			title_text = arg_313_3 or "n/a",
			disable_with_gamepad = arg_313_5
		},
		style = {
			tooltip = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				grow_downwards = false,
				max_width = 325,
				offset = {
					0,
					-10,
					0
				}
			},
			button_hotspot = {
				size = {
					arg_313_1[1] - 80,
					arg_313_1[2] - 50
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					30,
					25,
					0
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					size[1],
					size[2]
				},
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					45,
					2,
					6
				}
			},
			loading_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				angle = 0,
				pivot = {
					size_2[1] / 2,
					size_2[2] / 2
				},
				texture_size = {
					size_2[1],
					size_2[2]
				},
				color = {
					255,
					80,
					80,
					80
				},
				offset = {
					42,
					0,
					6
				}
			},
			icon_disabled = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					size[1],
					size[2]
				},
				color = {
					255,
					80,
					80,
					80
				},
				offset = {
					45,
					2,
					6
				}
			},
			price_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					32,
					32
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
					6
				}
			},
			price_icon_disabled = {
				vertical_alignment = "center",
				saturated = true,
				horizontal_alignment = "center",
				texture_size = {
					32,
					32
				},
				color = {
					255,
					120,
					120,
					120
				},
				offset = {
					0,
					0,
					6
				}
			},
			background = {
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
			hover_glow = {
				color = {
					0,
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
			texture_highlight = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					arg_313_1[2] - 30,
					arg_313_1[2] - 30
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					18,
					0,
					7
				}
			},
			clicked_rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				}
			},
			disabled_rect = {
				color = {
					150,
					20,
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			},
			title_text = {
				upper_case = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_313_4 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_313_1[1] - 40,
					arg_313_1[2]
				},
				default_offset = {
					20,
					0,
					6
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_disabled = {
				upper_case = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_313_4 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				size = {
					arg_313_1[1] - 40,
					arg_313_1[2]
				},
				default_offset = {
					20,
					0,
					6
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_shadow = {
				upper_case = false,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_313_4 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					arg_313_1[1] - 40,
					arg_313_1[2]
				},
				default_offset = {
					22,
					-2,
					5
				},
				offset = {
					22,
					-2,
					5
				}
			}
		},
		scenegraph_id = arg_313_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_weave_panel_button = function (arg_325_0, arg_325_1, arg_325_2, arg_325_3, arg_325_4, arg_325_5)
	-- function 325
	local tbl = {
		-19,
		-25,
		10
	}
	local tbl_2 = {
		0,
		-8,
		0
	}
	local tbl_3 = {
		2,
		3,
		3
	}
	local tbl_4 = {
		0,
		0,
		2
	}

	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_field"
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 326
						local is_hover

						if not self.button_hotspot.disable_button then
							is_hover = self.button_hotspot.is_hover

							if not is_hover then
								is_hover = self.button_hotspot.is_selected
							end
						else
							is_hover = false
						end

						if false then
							is_hover = true
						end

						return is_hover
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 327
						return not not self.button_hotspot.disable_button or not not self.button_hotspot.is_hover or not self.button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 328
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "new_marker",
					style_id = "new_marker",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 329
						return self.new
					end
				}
			}
		},
		content = {
			new_marker = "list_item_tag_new",
			button_hotspot = {},
			text_field = arg_325_2,
			default_font_size = arg_325_3,
			size = arg_325_1
		},
		style = {
			button_hotspot = {
				size = arg_325_1
			},
			text = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_325_3,
				horizontal_alignment = arg_325_5 or "left",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_offset = {
					0,
					10,
					4
				},
				offset = {
					0,
					5,
					4
				},
				size = arg_325_1
			},
			text_shadow = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_325_3,
				horizontal_alignment = arg_325_5 or "left",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_offset = tbl_3,
				offset = tbl_3,
				size = arg_325_1
			},
			text_hover = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_325_3,
				horizontal_alignment = arg_325_5 or "left",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				default_offset = {
					0,
					10,
					4
				},
				offset = {
					0,
					5,
					4
				},
				size = arg_325_1
			},
			text_disabled = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_325_3,
				horizontal_alignment = arg_325_5 or "left",
				text_color = Colors.get_color_table_with_alpha("gray", 50),
				default_offset = {
					0,
					10,
					4
				},
				offset = {
					0,
					5,
					4
				},
				size = arg_325_1
			},
			new_marker = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					math.floor(88.19999999999999),
					math.floor(35.699999999999996)
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					tbl[1],
					tbl[2],
					tbl[3]
				},
				size = arg_325_1
			}
		},
		offset = arg_325_4 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_325_0
	}
end

UIWidgets.create_game_option_mission_preview = function (arg_330_0, arg_330_1)
	-- function 330
	local tbl = {
		{
			pass_type = "texture",
			style_id = "icon_texture",
			texture_id = "icon_texture"
		},
		{
			pass_type = "texture",
			style_id = "level_frame",
			texture_id = "level_frame"
		},
		{
			pass_type = "texture",
			style_id = "boss_texture",
			texture_id = "boss_texture",
			content_check_function = function (self)
				-- function 331
				return self.boss_level
			end
		},
		{
			pass_type = "texture",
			style_id = "difficulty_texture",
			texture_id = "difficulty_texture",
			content_check_function = function (self)
				-- function 332
				return self.difficulty_texture
			end
		},
		{
			pass_type = "texture",
			style_id = "divider",
			texture_id = "divider"
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "description_text",
			pass_type = "text",
			text_id = "description_text"
		},
		{
			style_id = "description_text_shadow",
			pass_type = "text",
			text_id = "description_text"
		},
		{
			style_id = "requirement_title",
			pass_type = "text",
			text_id = "requirement_title",
			content_check_function = function (self)
				-- function 333
				return self.requirement_text
			end
		},
		{
			style_id = "requirement_title_shadow",
			pass_type = "text",
			text_id = "requirement_title",
			content_check_function = function (self)
				-- function 334
				return self.requirement_text
			end
		},
		{
			style_id = "requirement_text",
			pass_type = "text",
			text_id = "requirement_text",
			content_check_function = function (self)
				-- function 335
				return self.requirement_text
			end
		},
		{
			style_id = "requirement_text_shadow",
			pass_type = "text",
			text_id = "requirement_text",
			content_check_function = function (self)
				-- function 336
				return self.requirement_text
			end
		}
	}
	local tbl_2 = {
		level_frame = "map_frame_00",
		boss_texture = "boss_icon",
		requirement_title = "[localize this] Required completed missions:",
		icon_texture = "level_image_any",
		boss_level = false,
		difficulty_texture = "icon_difficulty_1",
		divider = "divider_01_bottom",
		size = arg_330_1,
		title_text = Localize("map_screen_quickplay_button"),
		description_text = Localize("map_screen_quickmatch_description")
	}
	local tbl_3 = {
		icon_texture = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				168,
				168
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-36,
				4
			}
		},
		level_frame = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				180,
				180
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-30,
				5
			}
		},
		boss_texture = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				68,
				68
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-150,
				6
			}
		},
		difficulty_texture = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				50,
				50
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-16,
				6
			}
		},
		divider = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				264,
				21
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-270,
				5
			}
		},
		title_text = {
			word_wrap = true,
			upper_case = true,
			localize = false,
			font_size = 52,
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			size = {
				arg_330_1[1] - 20,
				50
			},
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				10,
				arg_330_1[2] - 280,
				5
			}
		},
		title_text_shadow = {
			word_wrap = true,
			upper_case = true,
			localize = false,
			font_size = 52,
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			size = {
				arg_330_1[1] - 20,
				50
			},
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				12,
				arg_330_1[2] - 280 - 2,
				4
			}
		},
		description_text = {
			font_size = 28,
			localize = false,
			dynamic_font_size_word_wrap = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			font_type = "hell_shark_header",
			size = {
				arg_330_1[1] - 20,
				arg_330_1[2] - 310
			},
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				10,
				0,
				5
			}
		},
		description_text_shadow = {
			font_size = 28,
			localize = false,
			dynamic_font_size_word_wrap = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			font_type = "hell_shark_header",
			size = {
				arg_330_1[1] - 20,
				arg_330_1[2] - 310
			},
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				12,
				-2,
				4
			}
		},
		requirement_title = {
			font_size = 22,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			dynamic_font_size = true,
			font_type = "hell_shark",
			size = {
				arg_330_1[1] - 20,
				40
			},
			text_color = Colors.get_color_table_with_alpha("red", 255),
			offset = {
				10,
				60,
				5
			}
		},
		requirement_title_shadow = {
			font_size = 22,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			dynamic_font_size = true,
			font_type = "hell_shark",
			size = {
				arg_330_1[1] - 20,
				40
			},
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				12,
				58,
				4
			}
		},
		requirement_text = {
			word_wrap = true,
			font_size = 22,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			font_type = "hell_shark",
			size = {
				arg_330_1[1] - 20,
				40
			},
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				10,
				20,
				5
			}
		},
		requirement_text_shadow = {
			font_size = 22,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark",
			size = {
				arg_330_1[1] - 20,
				40
			},
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				12,
				18,
				4
			}
		}
	}

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
		scenegraph_id = arg_330_0
	}
end

UIWidgets.create_game_option_window = function (arg_337_0, arg_337_1, arg_337_2)
	-- function 337
	local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
	local var_337_1 = frame_outer_glow_01.texture_sizes.horizontal[2]
	local tbl = {
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			pass_type = "tiled_texture",
			style_id = "pattern",
			texture_id = "pattern"
		},
		{
			pass_type = "texture",
			style_id = "pattern_mask",
			texture_id = "pattern_mask"
		},
		{
			pass_type = "tiled_texture",
			style_id = "top_edge",
			texture_id = "edge"
		},
		{
			pass_type = "tiled_texture",
			style_id = "bottom_edge",
			texture_id = "edge"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			style_id = "top_corner_right",
			pass_type = "texture_uv",
			content_id = "top_corner_right"
		},
		{
			style_id = "top_corner_left",
			pass_type = "texture_uv",
			content_id = "top_corner_left"
		},
		{
			style_id = "bottom_corner_right",
			pass_type = "texture_uv",
			content_id = "bottom_corner_right"
		},
		{
			style_id = "bottom_corner_left",
			pass_type = "texture_uv",
			content_id = "bottom_corner_left"
		},
		{
			pass_type = "texture",
			style_id = "detail_top",
			texture_id = "detail"
		},
		{
			pass_type = "texture",
			style_id = "detail_bottom",
			texture_id = "detail"
		}
	}
	local tbl_2 = {
		pattern_mask = "background_pattern_fade_write_mask",
		edge = "edge_divider_01_horizontal",
		pattern = "background_pattern_01_transparent",
		background = "headline_bg_40",
		detail = "divider_01_top",
		top_corner_right = {
			texture_id = "divider_corner_01",
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
		top_corner_left = {
			texture_id = "divider_corner_01",
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
		bottom_corner_right = {
			texture_id = "divider_corner_01",
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
		bottom_corner_left = {
			texture_id = "divider_corner_01",
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
		},
		frame = frame_outer_glow_01.texture,
		size = arg_337_1
	}
	local tbl_3 = {
		background = {
			color = arg_337_2 or {
				0,
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
		frame = {
			frame_margins = {
				-var_337_1,
				-var_337_1
			},
			color = {
				150,
				0,
				0,
				0
			},
			default_color = {
				150,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			},
			texture_size = frame_outer_glow_01.texture_size,
			texture_sizes = frame_outer_glow_01.texture_sizes
		},
		pattern = {
			texture_tiling_size = {
				256,
				256
			},
			color = {
				255,
				10,
				10,
				10
			},
			default_color = {
				255,
				10,
				10,
				10
			},
			offset = {
				0,
				0,
				3
			}
		},
		pattern_mask = {
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
				0,
				1
			}
		},
		top_edge = {
			horizontal_alignment = "left",
			use_parent_width = true,
			vertical_alignment = "top",
			use_parent_height = false,
			texture_size = {
				64,
				4
			},
			texture_tiling_size = {
				64,
				4
			},
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
				0,
				8
			}
		},
		bottom_edge = {
			horizontal_alignment = "left",
			use_parent_width = true,
			vertical_alignment = "bottom",
			use_parent_height = false,
			texture_size = {
				64,
				4
			},
			texture_tiling_size = {
				64,
				4
			},
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
				0,
				8
			}
		},
		top_corner_right = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = {
				28,
				28
			},
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
				0,
				9
			}
		},
		top_corner_left = {
			vertical_alignment = "top",
			horizontal_alignment = "right",
			texture_size = {
				28,
				28
			},
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
				0,
				9
			}
		},
		bottom_corner_right = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				28,
				28
			},
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
				0,
				9
			}
		},
		bottom_corner_left = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			texture_size = {
				28,
				28
			},
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
				0,
				9
			}
		},
		detail_top = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				264,
				32
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				11,
				12
			}
		},
		detail_bottom = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				264,
				32
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-17,
				12
			}
		}
	}

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
		scenegraph_id = arg_337_0
	}
end

UIWidgets.create_item_option_overview = function (arg_338_0, arg_338_1)
	-- function 338
	local num = 10
	local tbl = {
		arg_338_1[1] - 20,
		40
	}
	local tbl_2 = {
		80,
		80
	}
	local num_2 = 20
	local str = "frame_outer_glow_01"
	local var_338_5 = UIFrameSettings[str]
	local var_338_6 = var_338_5.texture_sizes.horizontal[2]
	local str_2 = "frame_inner_glow_01"
	local var_338_8 = UIFrameSettings[str_2]
	local var_338_9 = var_338_8.texture_sizes.horizontal[2]
	local str_3 = "frame_outer_glow_04"
	local var_338_11 = UIFrameSettings[str_3]
	local var_338_12 = var_338_11.texture_sizes.horizontal[2]
	local str_4 = "frame_outer_glow_04_big"
	local var_338_14 = UIFrameSettings[str_4]
	local var_338_15 = var_338_14.texture_sizes.horizontal[2]
	local tbl_3 = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "inner_frame",
			texture_id = "inner_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "hover_frame",
			texture_id = "hover_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "pulse_frame",
			texture_id = "pulse_frame"
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "bottom_edge_bright",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "bottom_edge_dark",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "title_background",
			texture_id = "title_background"
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			pass_type = "texture",
			style_id = "icon_texture",
			texture_id = "icon_texture"
		},
		{
			pass_type = "texture",
			style_id = "illusion_texture",
			texture_id = "illusion_texture",
			content_check_function = function (self)
				-- function 339
				local item = self.item

				if not item then
					return false
				end

				local key = item.key
				local gsub = string.gsub(key, "^vs_", "")
				local var_339_3 = WeaponSkins.default_skins[gsub]
				local skin = item.skin

				return not skin and skin ~= var_339_3
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_bg",
			texture_id = "icon_bg"
		},
		{
			style_id = "input_text",
			pass_type = "text",
			text_id = "input_text"
		},
		{
			style_id = "input_text_shadow",
			pass_type = "text",
			text_id = "input_text"
		},
		{
			style_id = "sub_title",
			pass_type = "text",
			text_id = "sub_title"
		},
		{
			style_id = "sub_title_shadow",
			pass_type = "text",
			text_id = "sub_title"
		}
	}
	local tbl_4 = {
		title_background = "headline_bg_40",
		title_text = "achv_menu_summary_category_title",
		input_text = "Title Text",
		icon_texture = "icons_placeholder",
		locked = false,
		unavailable = false,
		illusion_texture = "item_applied_illusion_icon",
		icon_bg = "icons_placeholder",
		sub_title = "Sub Text",
		background = "gradient_straight",
		button_hotspot = {},
		hover_frame = var_338_11.texture,
		pulse_frame = var_338_14.texture,
		inner_frame = var_338_8.texture,
		frame = var_338_5.texture,
		size = arg_338_1,
		text_spacing = num
	}
	local tbl_5 = {
		background = {
			size = {
				arg_338_1[1],
				arg_338_1[2] - 2
			},
			color = {
				50,
				255,
				255,
				255
			},
			offset = {
				0,
				2,
				0
			}
		},
		inner_frame = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			size = arg_338_1,
			area_size = arg_338_1,
			texture_size = var_338_8.texture_size,
			texture_sizes = var_338_8.texture_sizes,
			color = {
				0,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				2
			}
		},
		hover_frame = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			size = arg_338_1,
			area_size = arg_338_1,
			texture_size = var_338_11.texture_size,
			texture_sizes = var_338_11.texture_sizes,
			frame_margins = {
				-var_338_12,
				-var_338_12
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				6
			}
		},
		pulse_frame = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			size = arg_338_1,
			area_size = arg_338_1,
			texture_size = var_338_14.texture_size,
			texture_sizes = var_338_14.texture_sizes,
			frame_margins = {
				-var_338_15,
				-var_338_15
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				12
			}
		},
		bottom_edge_dark = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				arg_338_1[1],
				2
			},
			color = {
				100,
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
		bottom_edge_bright = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				arg_338_1[1],
				2
			},
			color = {
				50,
				255,
				255,
				255
			},
			offset = {
				0,
				-2,
				1
			}
		},
		title_background = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = tbl,
			color = {
				120,
				255,
				255,
				255
			},
			offset = {
				0,
				-12,
				1
			}
		},
		title_text = {
			font_size = 34,
			upper_case = true,
			localize = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				num,
				-14,
				3
			},
			size = {
				tbl[1] - num * 2,
				arg_338_1[2]
			}
		},
		title_text_shadow = {
			font_size = 34,
			upper_case = true,
			localize = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				num + 2,
				-16,
				2
			},
			size = {
				tbl[1] - num,
				arg_338_1[2]
			}
		},
		frame = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			size = arg_338_1,
			area_size = tbl_2,
			texture_size = var_338_5.texture_size,
			texture_sizes = var_338_5.texture_sizes,
			frame_margins = {
				-var_338_6,
				-var_338_6
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				10,
				10,
				4
			}
		},
		icon_texture = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = tbl_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				10,
				-60,
				5
			}
		},
		illusion_texture = {
			size = {
				20,
				20
			},
			color = Colors.get_color_table_with_alpha("promo", 255),
			offset = {
				10 + tbl_2[1] - 28,
				17,
				10
			}
		},
		icon_bg = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = tbl_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				10,
				-60,
				4
			}
		},
		input_text = {
			word_wrap = true,
			font_size = 36,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				16 + tbl_2[1] + num,
				-63,
				3
			},
			size = {
				tbl[1] - (num * 2 + tbl_2[1]),
				arg_338_1[2]
			}
		},
		input_text_shadow = {
			word_wrap = true,
			horizontal_alignment = "left",
			font_size = 36,
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				16 + tbl_2[1] + num + 2,
				-65,
				2
			},
			size = {
				tbl[1] - (num * 2 + tbl_2[1]),
				arg_338_1[2]
			}
		},
		sub_title = {
			word_wrap = true,
			font_size = 26,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				16 + tbl_2[1] + num,
				-103,
				3
			},
			size = {
				tbl[1] - (num + tbl_2[1]),
				arg_338_1[2]
			}
		},
		sub_title_shadow = {
			vertical_alignment = "top",
			font_size = 26,
			horizontal_alignment = "left",
			word_wrap = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				16 + tbl_2[1] + num + 2,
				-105,
				2
			},
			size = {
				tbl[1] - (num * 2 + tbl_2[1]),
				arg_338_1[2]
			}
		}
	}

	UIWidgets.append_item_frame_pass("item_frame", tbl_3, tbl_4, tbl_5, tbl_2, {
		10,
		-60,
		6
	}, false, nil, {
		horizontal_alignment = "left",
		vertical_alignment = "top"
	}, nil, nil)

	return {
		element = {
			passes = tbl_3
		},
		content = tbl_4,
		style = tbl_5,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_338_0
	}
end

UIWidgets.create_item_option_properties = function (arg_340_0, arg_340_1)
	-- function 340
	local num = 10
	local tbl = {
		arg_340_1[1] - 20,
		40
	}
	local num_2 = 20
	local str = "frame_inner_glow_01"
	local var_340_4 = UIFrameSettings[str]
	local var_340_5 = var_340_4.texture_sizes.horizontal[2]
	local str_2 = "frame_outer_glow_04"
	local var_340_7 = UIFrameSettings[str_2]
	local var_340_8 = var_340_7.texture_sizes.horizontal[2]
	local str_3 = "frame_outer_glow_04_big"
	local var_340_10 = UIFrameSettings[str_3]
	local var_340_11 = var_340_10.texture_sizes.horizontal[2]
	local tbl_2 = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture_frame",
			style_id = "inner_frame",
			texture_id = "inner_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "hover_frame",
			texture_id = "hover_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "pulse_frame",
			texture_id = "pulse_frame"
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "bottom_edge_bright",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "bottom_edge_dark",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "title_background",
			texture_id = "title_background"
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text"
		}
	}
	local tbl_3 = {
		title_background = "headline_bg_40",
		background = "gradient_straight",
		button_hotspot = {},
		hover_frame = var_340_7.texture,
		pulse_frame = var_340_10.texture,
		inner_frame = var_340_4.texture,
		size = arg_340_1,
		title_text = Localize("tooltips_properties"),
		text_spacing = num
	}
	local tbl_4 = {
		background = {
			size = {
				arg_340_1[1],
				arg_340_1[2] - 2
			},
			color = {
				50,
				255,
				255,
				255
			},
			offset = {
				0,
				2,
				0
			}
		},
		inner_frame = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			size = arg_340_1,
			area_size = arg_340_1,
			texture_size = var_340_4.texture_size,
			texture_sizes = var_340_4.texture_sizes,
			color = {
				0,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				2
			}
		},
		hover_frame = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			size = arg_340_1,
			area_size = arg_340_1,
			texture_size = var_340_7.texture_size,
			texture_sizes = var_340_7.texture_sizes,
			frame_margins = {
				-var_340_8,
				-var_340_8
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				6
			}
		},
		pulse_frame = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			size = arg_340_1,
			area_size = arg_340_1,
			texture_size = var_340_10.texture_size,
			texture_sizes = var_340_10.texture_sizes,
			frame_margins = {
				-var_340_11,
				-var_340_11
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				12
			}
		},
		bottom_edge_dark = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				arg_340_1[1],
				2
			},
			color = {
				100,
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
		bottom_edge_bright = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				arg_340_1[1],
				2
			},
			color = {
				50,
				255,
				255,
				255
			},
			offset = {
				0,
				-2,
				1
			}
		},
		title_background = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = tbl,
			color = {
				120,
				255,
				255,
				255
			},
			offset = {
				0,
				-7,
				1
			}
		},
		title_text = {
			font_size = 34,
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			disabled_text_color = {
				255,
				120,
				120,
				120
			},
			offset = {
				num,
				-9,
				3
			},
			size = {
				tbl[1] - num * 2,
				arg_340_1[2]
			}
		},
		title_text_shadow = {
			font_size = 34,
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				num + 2,
				-11,
				2
			},
			size = {
				tbl[1] - num,
				arg_340_1[2]
			}
		}
	}
	local num_3 = 2
	local tbl_5 = {
		arg_340_1[1],
		40
	}
	local tbl_6 = {
		13,
		13
	}
	local tbl_7 = {
		26,
		26
	}
	local tbl_8 = {
		46,
		46
	}
	local num_4 = 0
	local num_5 = 10
	local num_6 = arg_340_1[2] - (tbl[2] + tbl_5[2] + 14)

	tbl_3.num_options = num_3

	for i = 1, num_3 do
		local str_4 = "button_hotspot_" .. i
		local str_5 = "icon_" .. i
		local str_6 = "icon_disabled_" .. i
		local str_7 = "option_text_" .. i
		local str_8 = "option_text_shadow_" .. i
		local str_9 = "option_text_disabled_" .. i
		local str_10 = "option_text_disabled_shadow_" .. i

		tbl_2[#tbl_2 + 1] = {
			pass_type = "hotspot",
			content_id = str_4,
			style_id = str_4
		}
		tbl_3[str_4] = {
			disable_button = true
		}
		tbl_4[str_4] = {
			size = arg_340_1,
			offset = {
				0,
				0,
				1
			}
		}
		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			texture_id = str_5,
			style_id = str_5,
			content_check_function = function (self)
				-- function 341
				return not self[str_4].disable_button
			end
		}
		tbl_3[str_5] = "icon_list_dot"
		tbl_4[str_5] = {
			color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
			size = tbl_6,
			offset = {
				num_5 + 6,
				num_6 + tbl_5[2] / 2 - tbl_6[2] / 2,
				5
			}
		}
		tbl_2[#tbl_2 + 1] = {
			pass_type = "texture",
			texture_id = str_5,
			style_id = str_6,
			content_check_function = function (self)
				-- function 342
				return self[str_4].disable_button
			end
		}
		tbl_4[str_6] = {
			color = {
				255,
				80,
				80,
				80
			},
			size = tbl_6,
			offset = {
				num_5 + 6,
				num_6 + tbl_5[2] / 2 - tbl_6[2] / 2,
				5
			}
		}
		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			text_id = str_7,
			style_id = str_7,
			content_check_function = function (self)
				-- function 343
				return not self[str_4].disable_button
			end
		}
		tbl_3[str_7] = "n/a"

		local num_7 = 0.8

		tbl_4[str_7] = {
			word_wrap = true,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
			default_text_color = {
				255,
				math.floor(100 * num_7),
				math.floor(149 * num_7),
				math.floor(237 * num_7)
			},
			select_text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
			offset = {
				num_5 + tbl_7[1] + num,
				num_6 + 2,
				5
			},
			size = {
				tbl_5[1] - (num * 2 + num_5 + tbl_7[1]),
				tbl_5[2]
			}
		}
		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			text_id = str_7,
			style_id = str_8,
			content_check_function = function (self)
				-- function 344
				return not self[str_4].disable_button
			end
		}
		tbl_4[str_8] = {
			word_wrap = true,
			horizontal_alignment = "left",
			font_size = 20,
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				num_5 + tbl_7[1] + num + 2,
				num_6,
				4
			},
			size = {
				tbl_5[1] - (num * 2 + num_5 + tbl_7[1]),
				tbl_5[2]
			}
		}
		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			text_id = str_9,
			style_id = str_9,
			content_check_function = function (self)
				-- function 345
				return self[str_4].disable_button
			end
		}
		tbl_3[str_9] = "search_filter_locked"
		tbl_4[str_9] = {
			font_size = 20,
			upper_case = true,
			localize = true,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = {
				255,
				80,
				80,
				80
			},
			offset = {
				num_5 + tbl_7[1] + num,
				num_6 + 2,
				5
			},
			size = {
				tbl_5[1] - (num * 2 + num_5 + tbl_7[1]),
				tbl_5[2]
			}
		}
		tbl_2[#tbl_2 + 1] = {
			pass_type = "text",
			text_id = str_9,
			style_id = str_10,
			content_check_function = function (self)
				-- function 346
				return self[str_4].disable_button
			end
		}
		tbl_4[str_10] = {
			font_size = 20,
			upper_case = true,
			localize = true,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				num_5 + tbl_7[1] + num + 2,
				num_6,
				4
			},
			size = {
				tbl_5[1] - (num * 2 + num_5 + tbl_7[1]),
				tbl_5[2]
			}
		}
		num_6 = num_6 - (tbl_5[2] + num_4)
	end

	return {
		element = {
			passes = tbl_2
		},
		content = tbl_3,
		style = tbl_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_340_0
	}
end

UIWidgets.create_item_option_trait = function (arg_347_0, arg_347_1)
	-- function 347
	local num = 10
	local tbl = {
		40,
		40
	}
	local tbl_2 = {
		arg_347_1[1] - 20,
		40
	}
	local num_2 = 20
	local str = "frame_inner_glow_01"
	local var_347_5 = UIFrameSettings[str]
	local var_347_6 = var_347_5.texture_sizes.horizontal[2]
	local str_2 = "frame_outer_glow_04"
	local var_347_8 = UIFrameSettings[str_2]
	local var_347_9 = var_347_8.texture_sizes.horizontal[2]
	local str_3 = "frame_outer_glow_04_big"
	local var_347_11 = UIFrameSettings[str_3]
	local var_347_12 = var_347_11.texture_sizes.horizontal[2]
	local num_3 = 0.8
	local tbl_3 = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture_frame",
			style_id = "inner_frame",
			texture_id = "inner_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "hover_frame",
			texture_id = "hover_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "pulse_frame",
			texture_id = "pulse_frame"
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "bottom_edge_bright",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "bottom_edge_dark",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "title_background",
			texture_id = "title_background"
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			pass_type = "texture",
			style_id = "icon_texture",
			texture_id = "icon_texture",
			content_check_function = function (self)
				-- function 348
				return self.icon_texture
			end
		},
		{
			style_id = "input_text",
			pass_type = "text",
			text_id = "input_text",
			content_check_function = function (self)
				-- function 349
				return not self.locked
			end
		},
		{
			style_id = "input_text_shadow",
			pass_type = "text",
			text_id = "input_text",
			content_check_function = function (self)
				-- function 350
				return not self.locked
			end
		},
		{
			style_id = "input_text_locked",
			pass_type = "text",
			text_id = "input_text_locked",
			content_check_function = function (self)
				-- function 351
				return self.locked
			end
		},
		{
			style_id = "input_text_locked_shadow",
			pass_type = "text",
			text_id = "input_text_locked",
			content_check_function = function (self)
				-- function 352
				return self.locked
			end
		},
		{
			style_id = "sub_title",
			pass_type = "text",
			text_id = "sub_title",
			content_check_function = function (self)
				-- function 353
				return not self.locked
			end
		},
		{
			style_id = "sub_title_shadow",
			pass_type = "text",
			text_id = "sub_title",
			content_check_function = function (self)
				-- function 354
				return not self.locked
			end
		}
	}
	local tbl_4 = {
		locked = true,
		title_text = "search_filter_trait",
		input_text = "n/a",
		title_background = "headline_bg_40",
		input_text_locked = "search_filter_locked",
		sub_title = "n/a",
		background = "gradient_straight",
		button_hotspot = {},
		hover_frame = var_347_8.texture,
		pulse_frame = var_347_11.texture,
		inner_frame = var_347_5.texture,
		size = arg_347_1,
		text_spacing = num
	}
	local tbl_5 = {
		background = {
			color = {
				50,
				255,
				255,
				255
			},
			offset = {
				0,
				2,
				0
			}
		},
		inner_frame = {
			texture_size = var_347_5.texture_size,
			texture_sizes = var_347_5.texture_sizes,
			color = {
				0,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				2
			}
		},
		hover_frame = {
			texture_size = var_347_8.texture_size,
			texture_sizes = var_347_8.texture_sizes,
			frame_margins = {
				-var_347_9,
				-var_347_9
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				6
			}
		},
		pulse_frame = {
			texture_size = var_347_11.texture_size,
			texture_sizes = var_347_11.texture_sizes,
			frame_margins = {
				-var_347_12,
				-var_347_12
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				12
			}
		},
		bottom_edge_dark = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				arg_347_1[1],
				2
			},
			color = {
				100,
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
		bottom_edge_bright = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				arg_347_1[1],
				2
			},
			color = {
				50,
				255,
				255,
				255
			},
			offset = {
				0,
				-2,
				1
			}
		},
		title_background = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = tbl_2,
			color = {
				120,
				255,
				255,
				255
			},
			offset = {
				0,
				-7,
				1
			}
		},
		title_text = {
			font_size = 34,
			upper_case = true,
			localize = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				num,
				-9,
				3
			},
			size = {
				tbl_2[1] - num * 2,
				arg_347_1[2]
			}
		},
		title_text_shadow = {
			font_size = 34,
			upper_case = true,
			localize = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				num + 2,
				-11,
				2
			},
			size = {
				tbl_2[1] - num,
				arg_347_1[2]
			}
		},
		icon_texture = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = tbl,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				10,
				-55,
				5
			}
		},
		input_text = {
			word_wrap = true,
			font_size = 36,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			default_text_color = {
				255,
				math.floor(193 * num_3),
				math.floor(91 * num_3),
				math.floor(36 * num_3)
			},
			select_text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				16 + tbl[1] + num,
				-58,
				3
			},
			size = {
				tbl_2[1] - (num + tbl[1]),
				arg_347_1[2]
			}
		},
		input_text_shadow = {
			word_wrap = true,
			horizontal_alignment = "left",
			font_size = 36,
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				16 + tbl[1] + num + 2,
				-60,
				2
			},
			size = {
				tbl_2[1] - (num * 2 + tbl[1]),
				arg_347_1[2]
			}
		},
		input_text_locked = {
			font_size = 36,
			upper_case = true,
			localize = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = {
				255,
				80,
				80,
				80
			},
			default_text_color = {
				255,
				80,
				80,
				80
			},
			select_text_color = {
				255,
				120,
				120,
				120
			},
			offset = {
				16,
				-58,
				3
			},
			size = {
				tbl_2[1] - (num * 2 + tbl[1]),
				arg_347_1[2]
			}
		},
		input_text_locked_shadow = {
			font_size = 36,
			upper_case = true,
			localize = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				18,
				-60,
				2
			},
			size = {
				tbl_2[1] - (num * 2 + tbl[1]),
				arg_347_1[2]
			}
		},
		sub_title = {
			word_wrap = true,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				16 + tbl[1] + num,
				-98,
				3
			},
			size = {
				tbl_2[1] - (num * 2 + tbl[1]),
				arg_347_1[2]
			}
		},
		sub_title_shadow = {
			vertical_alignment = "top",
			font_size = 20,
			horizontal_alignment = "left",
			word_wrap = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				16 + tbl[1] + num + 2,
				-100,
				2
			},
			size = {
				tbl_2[1] - (num * 2 + tbl[1]),
				arg_347_1[2]
			}
		}
	}

	return {
		element = {
			passes = tbl_3
		},
		content = tbl_4,
		style = tbl_5,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_347_0
	}
end

UIWidgets.create_item_option_upgrade = function (arg_355_0, arg_355_1)
	-- function 355
	local num = 10
	local tbl = {
		13,
		13
	}
	local tbl_2 = {
		arg_355_1[1] - 20,
		40
	}
	local num_2 = 20
	local str = "frame_inner_glow_01"
	local var_355_5 = UIFrameSettings[str]
	local var_355_6 = var_355_5.texture_sizes.horizontal[2]
	local str_2 = "frame_outer_glow_04"
	local var_355_8 = UIFrameSettings[str_2]
	local var_355_9 = var_355_8.texture_sizes.horizontal[2]
	local str_3 = "frame_outer_glow_04_big"
	local var_355_11 = UIFrameSettings[str_3]
	local var_355_12 = var_355_11.texture_sizes.horizontal[2]
	local num_3 = 0.8
	local tbl_3 = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture_frame",
			style_id = "inner_frame",
			texture_id = "inner_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "hover_frame",
			texture_id = "hover_frame"
		},
		{
			pass_type = "texture_frame",
			style_id = "pulse_frame",
			texture_id = "pulse_frame"
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "bottom_edge_bright",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "bottom_edge_dark",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "title_background",
			texture_id = "title_background"
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			pass_type = "texture",
			style_id = "icon_texture",
			texture_id = "icon_texture",
			content_check_function = function (self)
				-- function 356
				return not self.locked
			end
		},
		{
			style_id = "input_text",
			pass_type = "text",
			text_id = "input_text",
			content_check_function = function (self)
				-- function 357
				return not self.locked
			end
		},
		{
			style_id = "input_text_shadow",
			pass_type = "text",
			text_id = "input_text",
			content_check_function = function (self)
				-- function 358
				return not self.locked
			end
		},
		{
			style_id = "input_text_locked",
			pass_type = "text",
			text_id = "input_text_locked",
			content_check_function = function (self)
				-- function 359
				return self.locked
			end
		},
		{
			style_id = "input_text_locked_shadow",
			pass_type = "text",
			text_id = "input_text_locked",
			content_check_function = function (self)
				-- function 360
				return self.locked
			end
		},
		{
			style_id = "sub_title",
			pass_type = "text",
			text_id = "sub_title",
			content_check_function = function (self)
				-- function 361
				return not self.locked
			end
		},
		{
			style_id = "sub_title_shadow",
			pass_type = "text",
			text_id = "sub_title",
			content_check_function = function (self)
				-- function 362
				return not self.locked
			end
		}
	}
	local tbl_4 = {
		locked = false,
		title_background = "headline_bg_40",
		icon_texture = "icon_list_dot",
		sub_title = "n/a",
		background = "gradient_straight",
		button_hotspot = {},
		hover_frame = var_355_8.texture,
		pulse_frame = var_355_11.texture,
		inner_frame = var_355_5.texture,
		size = arg_355_1,
		title_text = Localize("hero_view_crafting_upgrade"),
		text_spacing = num,
		input_text_locked = string.upper(Localize("menu_weave_forge_upgrade_loadout_button_cap")),
		input_text = Localize("next_upgrade_desc")
	}
	local tbl_5 = {
		background = {
			color = {
				50,
				255,
				255,
				255
			},
			offset = {
				0,
				2,
				0
			}
		},
		inner_frame = {
			texture_size = var_355_5.texture_size,
			texture_sizes = var_355_5.texture_sizes,
			color = {
				0,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				2
			}
		},
		hover_frame = {
			texture_size = var_355_8.texture_size,
			texture_sizes = var_355_8.texture_sizes,
			frame_margins = {
				-var_355_9,
				-var_355_9
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				6
			}
		},
		pulse_frame = {
			texture_size = var_355_11.texture_size,
			texture_sizes = var_355_11.texture_sizes,
			frame_margins = {
				-var_355_12,
				-var_355_12
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				12
			}
		},
		bottom_edge_dark = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = {
				arg_355_1[1],
				2
			},
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				0,
				2,
				0
			}
		},
		bottom_edge_bright = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = {
				arg_355_1[1],
				2
			},
			color = {
				50,
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
		title_background = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = tbl_2,
			color = {
				120,
				255,
				255,
				255
			},
			offset = {
				0,
				-7,
				1
			}
		},
		title_text = {
			font_size = 34,
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				num,
				-9,
				3
			},
			size = {
				tbl_2[1] - num * 2,
				arg_355_1[2]
			}
		},
		title_text_shadow = {
			font_size = 34,
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				num + 2,
				-11,
				2
			},
			size = {
				tbl_2[1] - num,
				arg_355_1[2]
			}
		},
		icon_texture = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = tbl,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				16,
				-70,
				5
			}
		},
		input_text = {
			word_wrap = true,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				16 + tbl[1] + num,
				-64,
				3
			},
			size = {
				tbl_2[1] - (num + tbl[1]),
				arg_355_1[2]
			}
		},
		input_text_shadow = {
			word_wrap = true,
			horizontal_alignment = "left",
			font_size = 20,
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				16 + tbl[1] + num + 2,
				-66,
				2
			},
			size = {
				tbl_2[1] - (num * 2 + tbl[1]),
				arg_355_1[2]
			}
		},
		input_text_locked = {
			word_wrap = true,
			font_size = 36,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = false,
			font_type = "hell_shark",
			text_color = {
				255,
				80,
				80,
				80
			},
			default_text_color = {
				255,
				80,
				80,
				80
			},
			select_text_color = {
				255,
				120,
				120,
				120
			},
			offset = {
				tbl[1],
				-64,
				3
			},
			size = {
				tbl_2[1] - (num * 2 + tbl[1]),
				arg_355_1[2]
			}
		},
		input_text_locked_shadow = {
			word_wrap = true,
			horizontal_alignment = "left",
			font_size = 36,
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				tbl[1] + 2,
				-66,
				2
			},
			size = {
				tbl_2[1] - (num * 2 + tbl[1]),
				arg_355_1[2]
			}
		},
		sub_title = {
			word_wrap = true,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				16 + tbl[1] + num,
				-98,
				3
			},
			size = {
				tbl_2[1] - (num * 2 + tbl[1]),
				arg_355_1[2]
			}
		},
		sub_title_shadow = {
			vertical_alignment = "top",
			font_size = 20,
			horizontal_alignment = "left",
			word_wrap = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				16 + tbl[1] + num + 2,
				-100,
				2
			},
			size = {
				tbl_2[1] - (num * 2 + tbl[1]),
				arg_355_1[2]
			}
		}
	}

	return {
		element = {
			passes = tbl_3
		},
		content = tbl_4,
		style = tbl_5,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_355_0
	}
end

UIWidgets.create_item_feature = function (arg_363_0, arg_363_1, arg_363_2, arg_363_3, arg_363_4, arg_363_5)
	-- function 363
	local flag = not arg_363_4 and UIAtlasHelper.get_atlas_settings_by_texture_name(arg_363_4)
	local flag_2 = not flag and flag.size
	local tbl = {
		{
			pass_type = "texture",
			style_id = "value_texture",
			texture_id = "value_texture",
			content_check_function = function (self)
				-- function 364
				return self.value_texture
			end
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (self)
				-- function 365
				return self.title_text
			end
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (self)
				-- function 366
				return self.title_text
			end
		},
		{
			style_id = "value_text",
			pass_type = "text",
			text_id = "value_text",
			content_check_function = function (self)
				-- function 367
				return self.value_text
			end
		},
		{
			style_id = "value_text_shadow",
			pass_type = "text",
			text_id = "value_text",
			content_check_function = function (self)
				-- function 368
				return self.value_text
			end
		}
	}
	local tbl_2 = {
		size = arg_363_1,
		value_texture = arg_363_4,
		value_text = arg_363_3,
		title_text = arg_363_2
	}
	local tbl_3 = {
		value_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_363_5,
			texture_size = flag_2 or {
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
				-15,
				0
			}
		}
	}
	local tbl_4 = {
		word_wrap = true,
		font_size = 28,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "bottom",
		dynamic_font_size = true
	}
	local flag_3

	flag_3 = not arg_363_5 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_4.font_type = flag_3
	tbl_4.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_4.size = {
		arg_363_1[1] - 10,
		20
	}
	tbl_4.offset = {
		5,
		arg_363_1[2] - 40,
		1
	}
	tbl_3.title_text = tbl_4

	local tbl_5 = {
		word_wrap = true,
		font_size = 28,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "bottom",
		dynamic_font_size = true
	}
	local flag_4

	flag_4 = not arg_363_5 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_5.font_type = flag_4
	tbl_5.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_5.size = {
		arg_363_1[1] - 10,
		20
	}
	tbl_5.offset = {
		7,
		arg_363_1[2] - 40 - 2,
		0
	}
	tbl_3.title_text_shadow = tbl_5

	local tbl_6 = {
		word_wrap = true,
		font_size = 72,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "top",
		dynamic_font_size = true
	}
	local flag_5

	flag_5 = not arg_363_5 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_6.font_type = flag_5
	tbl_6.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_6.size = {
		arg_363_1[1] - 10,
		arg_363_1[2] - 20
	}
	tbl_6.offset = {
		5,
		-10,
		1
	}
	tbl_3.value_text = tbl_6

	local tbl_7 = {
		word_wrap = true,
		font_size = 72,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "top",
		dynamic_font_size = true
	}
	local flag_6

	flag_6 = not arg_363_5 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_7.font_type = flag_6
	tbl_7.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_7.size = {
		arg_363_1[1] - 10,
		arg_363_1[2] - 20
	}
	tbl_7.offset = {
		7,
		-12,
		0
	}
	tbl_3.value_text_shadow = tbl_7

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
		scenegraph_id = arg_363_0
	}
end

UIWidgets.create_weapon_diagram_widget = function (arg_369_0, arg_369_1, arg_369_2, arg_369_3, arg_369_4)
	-- function 369
	local tbl = {
		0,
		13,
		0
	}
	local tbl_2 = {
		arg_369_1[1] / 2,
		arg_369_1[2] / 2
	}
	local tbl_3 = {
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			style_id = "node_icon_1",
			pass_type = "hotspot",
			content_id = "icon_hotspot_1"
		},
		{
			style_id = "node_icon_2",
			pass_type = "hotspot",
			content_id = "icon_hotspot_2"
		},
		{
			style_id = "node_icon_3",
			pass_type = "hotspot",
			content_id = "icon_hotspot_3"
		},
		{
			style_id = "node_icon_4",
			pass_type = "hotspot",
			content_id = "icon_hotspot_4"
		},
		{
			style_id = "node_icon_5",
			pass_type = "hotspot",
			content_id = "icon_hotspot_5"
		},
		{
			style_id = "node_icon_info_1",
			pass_type = "text",
			text_id = "icon_info_1",
			content_check_function = function (self)
				-- function 370
				local is_hover = self.icon_hotspot_1.is_hover

				is_hover = is_hover or self.show_info

				return is_hover
			end
		},
		{
			style_id = "node_icon_info_2",
			pass_type = "text",
			text_id = "icon_info_2",
			content_check_function = function (self)
				-- function 371
				local is_hover = self.icon_hotspot_2.is_hover

				is_hover = is_hover or self.show_info

				return is_hover
			end
		},
		{
			style_id = "node_icon_info_3",
			pass_type = "text",
			text_id = "icon_info_3",
			content_check_function = function (self)
				-- function 372
				local is_hover = self.icon_hotspot_3.is_hover

				is_hover = is_hover or self.show_info

				return is_hover
			end
		},
		{
			style_id = "node_icon_info_4",
			pass_type = "text",
			text_id = "icon_info_4",
			content_check_function = function (self)
				-- function 373
				local is_hover = self.icon_hotspot_4.is_hover

				is_hover = is_hover or self.show_info

				return is_hover
			end
		},
		{
			style_id = "node_icon_info_5",
			pass_type = "text",
			text_id = "icon_info_5",
			content_check_function = function (self)
				-- function 374
				local is_hover = self.icon_hotspot_5.is_hover

				is_hover = is_hover or self.show_info

				return is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "node_icon_1",
			texture_id = "node_icon_1"
		},
		{
			pass_type = "texture",
			style_id = "node_icon_2",
			texture_id = "node_icon_2"
		},
		{
			pass_type = "texture",
			style_id = "node_icon_3",
			texture_id = "node_icon_3"
		},
		{
			pass_type = "texture",
			style_id = "node_icon_4",
			texture_id = "node_icon_4"
		},
		{
			pass_type = "texture",
			style_id = "node_icon_5",
			texture_id = "node_icon_5"
		},
		{
			pass_type = "texture",
			style_id = "tutorial_node_1",
			texture_id = "node_dot_1",
			content_check_function = function (self)
				-- function 375
				return self.available_actions[1]
			end
		},
		{
			style_id = "tutorial_text_1",
			pass_type = "text",
			text_id = "tutorial_text_1",
			content_check_function = function (self)
				-- function 376
				return self.available_actions[1]
			end
		},
		{
			style_id = "tutorial_text_1_shadow",
			pass_type = "text",
			text_id = "tutorial_text_1",
			content_check_function = function (self)
				-- function 377
				return self.available_actions[1]
			end
		},
		{
			pass_type = "texture",
			style_id = "tutorial_node_2",
			texture_id = "node_dot_2",
			content_check_function = function (self)
				-- function 378
				return self.available_actions[2]
			end
		},
		{
			style_id = "tutorial_text_2",
			pass_type = "text",
			text_id = "tutorial_text_2",
			content_check_function = function (self)
				-- function 379
				return self.available_actions[2]
			end
		},
		{
			style_id = "tutorial_text_2_shadow",
			pass_type = "text",
			text_id = "tutorial_text_2",
			content_check_function = function (self)
				-- function 380
				return self.available_actions[2]
			end
		}
	}
	local tbl_4 = {
		node_dot_1 = "ping_icon_02",
		node_line = "diagram_line",
		node_icon_4 = "icon_stagger",
		node_dot_2 = "ping_icon_03",
		node_icon_3 = "icon_speed",
		show_info = false,
		node_icon_2 = "icon_targets",
		node_icon_1 = "icon_damage_vs_armor",
		background = "diagram_bg",
		node_icon_5 = "icon_damage",
		icon_hotspot_1 = {},
		icon_hotspot_2 = {},
		icon_hotspot_3 = {},
		icon_hotspot_4 = {},
		icon_hotspot_5 = {},
		icon_info_1 = Localize("weapon_keyword_armour_piercing"),
		icon_info_2 = Localize("tooltip_item_cleave"),
		icon_info_3 = Localize("properties_attack_speed_plain"),
		icon_info_4 = Localize("markus_knight_power_level_impact"),
		icon_info_5 = Localize("inventory_screen_compare_damage_tooltip"),
		tutorial_text_1 = Localize("tutorial_tooltip_light_attack"),
		tutorial_text_2 = Localize("tutorial_tooltip_heavy_attack")
	}
	local tbl_5 = {
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_369_3,
			texture_size = {
				268,
				255
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
		node_icon_1 = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_369_3,
			texture_size = {
				64,
				58
			},
			area_size = {
				64,
				58
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl[1] + 110,
				tbl[2] + 142,
				1
			}
		},
		node_icon_2 = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_369_3,
			texture_size = {
				67,
				59
			},
			area_size = {
				67,
				59
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl[1] + 162,
				tbl[2] - 44,
				1
			}
		},
		node_icon_3 = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_369_3,
			texture_size = {
				60,
				61
			},
			area_size = {
				60,
				61
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl[1] - 5,
				tbl[2] - 168,
				1
			}
		},
		node_icon_4 = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_369_3,
			texture_size = {
				82,
				69
			},
			area_size = {
				82,
				69
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl[1] - 172,
				tbl[2] - 44,
				1
			}
		},
		node_icon_5 = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_369_3,
			texture_size = {
				55,
				50
			},
			area_size = {
				55,
				50
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl[1] - 110,
				tbl[2] + 137,
				1
			}
		}
	}
	local tbl_6 = {
		draw_rect_border = true,
		word_wrap = true,
		font_size = 28,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		draw_text_rect = true,
		masked = arg_369_3,
		rect_color = {
			255,
			0,
			0,
			0
		}
	}
	local flag

	flag = not arg_369_3 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag
	tbl_6.texture_size = {
		50,
		50
	}
	tbl_6.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_6.offset = {
		tbl[1] + 110,
		tbl[2] + 142 + 40,
		10
	}
	tbl_5.node_icon_info_1 = tbl_6

	local tbl_7 = {
		draw_rect_border = true,
		word_wrap = true,
		font_size = 28,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		draw_text_rect = true,
		masked = arg_369_3,
		rect_color = {
			255,
			0,
			0,
			0
		}
	}
	local flag_2

	flag_2 = not arg_369_3 and "hell_shark_masked" and "hell_shark"
	tbl_7.font_type = flag_2
	tbl_7.texture_size = {
		50,
		50
	}
	tbl_7.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_7.offset = {
		tbl[1] + 162,
		tbl[2] - 44 + 40,
		10
	}
	tbl_5.node_icon_info_2 = tbl_7

	local tbl_8 = {
		draw_rect_border = true,
		word_wrap = true,
		font_size = 28,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		draw_text_rect = true,
		masked = arg_369_3,
		rect_color = {
			255,
			0,
			0,
			0
		}
	}
	local flag_3

	flag_3 = not arg_369_3 and "hell_shark_masked" and "hell_shark"
	tbl_8.font_type = flag_3
	tbl_8.texture_size = {
		50,
		50
	}
	tbl_8.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_8.offset = {
		tbl[1] - 5,
		tbl[2] - 168 + 40,
		10
	}
	tbl_5.node_icon_info_3 = tbl_8

	local tbl_9 = {
		draw_rect_border = true,
		word_wrap = true,
		font_size = 28,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		draw_text_rect = true,
		masked = arg_369_3,
		rect_color = {
			255,
			0,
			0,
			0
		}
	}
	local flag_4

	flag_4 = not arg_369_3 and "hell_shark_masked" and "hell_shark"
	tbl_9.font_type = flag_4
	tbl_9.texture_size = {
		50,
		50
	}
	tbl_9.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_9.offset = {
		tbl[1] - 172,
		tbl[2] - 44 + 40,
		10
	}
	tbl_5.node_icon_info_4 = tbl_9

	local tbl_10 = {
		draw_rect_border = true,
		word_wrap = true,
		font_size = 28,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		draw_text_rect = true,
		masked = arg_369_3,
		rect_color = {
			255,
			0,
			0,
			0
		}
	}
	local flag_5

	flag_5 = not arg_369_3 and "hell_shark_masked" and "hell_shark"
	tbl_10.font_type = flag_5
	tbl_10.texture_size = {
		50,
		50
	}
	tbl_10.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_10.offset = {
		tbl[1] - 110,
		tbl[2] + 137 + 40,
		10
	}
	tbl_5.node_icon_info_5 = tbl_10
	tbl_5.tutorial_node_1 = {
		vertical_alignment = "bottom",
		horizontal_alignment = "left",
		masked = arg_369_3,
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
			arg_369_1[1] - (arg_369_1[1] / 3 + 60),
			35,
			1
		}
	}
	tbl_5.tutorial_node_2 = {
		vertical_alignment = "bottom",
		horizontal_alignment = "left",
		masked = arg_369_3,
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
			arg_369_1[1] - (arg_369_1[1] / 3 + 60),
			-5,
			1
		}
	}

	local tbl_11 = {
		font_size = 28,
		use_shadow = true,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_6

	flag_6 = not arg_369_3 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_11.font_type = flag_6
	tbl_11.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_11.size = {
		arg_369_1[1] / 3,
		20
	}
	tbl_11.offset = {
		arg_369_1[1] - (arg_369_1[1] / 3 + 10),
		50,
		3
	}
	tbl_5.tutorial_text_1 = tbl_11

	local tbl_12 = {
		font_size = 28,
		use_shadow = true,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_7

	flag_7 = not arg_369_3 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_12.font_type = flag_7
	tbl_12.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_12.size = {
		arg_369_1[1] / 3,
		20
	}
	tbl_12.offset = {
		arg_369_1[1] - (arg_369_1[1] / 3 + 10) + 2,
		48,
		2
	}
	tbl_5.tutorial_text_1_shadow = tbl_12

	local tbl_13 = {
		font_size = 28,
		use_shadow = true,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_8

	flag_8 = not arg_369_3 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_13.font_type = flag_8
	tbl_13.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_13.size = {
		arg_369_1[1] / 3,
		20
	}
	tbl_13.offset = {
		arg_369_1[1] - (arg_369_1[1] / 3 + 10),
		10,
		3
	}
	tbl_5.tutorial_text_2 = tbl_13

	local tbl_14 = {
		font_size = 28,
		use_shadow = true,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_9

	flag_9 = not arg_369_3 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_14.font_type = flag_9
	tbl_14.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_14.size = {
		arg_369_1[1] / 3,
		20
	}
	tbl_14.offset = {
		arg_369_1[1] - (arg_369_1[1] / 3 + 10) + 2,
		8,
		2
	}
	tbl_5.tutorial_text_2_shadow = tbl_14

	local tbl_15 = {
		{
			82,
			112,
			1
		},
		{
			132,
			-44,
			1
		},
		{
			0,
			-138,
			1
		},
		{
			-132,
			-44,
			1
		},
		{
			-82,
			112,
			1
		}
	}
	local tbl_16 = {}
	local count = #tbl_15

	for i = 1, 2 do
		local get_color_table_with_alpha

		if i == 1 then
			get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_title", 255)

			if not get_color_table_with_alpha then
				-- Nothing
			end
		end

		get_color_table_with_alpha = {
			255,
			255,
			0,
			0
		}

		::label_369_0::

		local num = count * (i - 1)
		local var_369_28 = i

		for j = 1, count do
			local num_2 = num + j
			local var_369_30 = arg_369_2[num_2]
			local var_369_31 = tbl_15[j]
			local num_3 = var_369_31[1] * var_369_30
			local num_4 = var_369_31[2] * var_369_30
			local var_369_34

			if not (var_369_30 > (arg_369_4 or 0)) then
				var_369_34 = tbl_16[i]

				if not var_369_34 then
					var_369_34 = false
				end

				if false then
					var_369_34 = false
				end
			else
				var_369_34 = true
			end

			tbl_16[i] = var_369_34

			local str = "node_dot_" .. num_2

			tbl_3[#tbl_3 + 1] = {
				pass_type = "texture",
				texture_id = "node_dot_" .. i,
				style_id = str,
				content_check_function = function (self)
					-- function 381
					return self.available_actions[i]
				end
			}
			tbl_5[str] = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
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
					tbl[1] + num_3,
					tbl[2] + num_4,
					var_369_28 + 3
				},
				content_check_function = function (self)
					-- function 382
					return self.available_actions[i]
				end
			}

			local str_2 = "node_line_" .. num_2

			tbl_3[#tbl_3 + 1] = {
				pass_type = "rotated_texture",
				texture_id = "node_line",
				style_id = str_2,
				content_check_function = function (self)
					-- function 383
					return self.available_actions[i]
				end
			}

			local num_5 = j % count + 1
			local num_6 = num + num_5
			local var_369_39 = tbl_15[num_5]
			local var_369_40 = arg_369_2[num_6]
			local num_7 = var_369_39[1] * var_369_40
			local num_8 = var_369_39[2] * var_369_40
			local angle = math.angle(num_3, num_4, num_7, num_8)

			angle = not (num_8 < num_4) or not math.abs(angle) or -angle

			local distance_2d = math.distance_2d(num_3, num_4, num_7, num_8)

			tbl_5[str_2] = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					distance_2d,
					6
				},
				angle = angle,
				pivot = {
					0,
					3
				},
				color = get_color_table_with_alpha,
				offset = {
					tbl[1] + tbl_2[1] + num_3,
					tbl[2] + num_4,
					var_369_28
				}
			}
		end
	end

	tbl_4.nodes_progress = arg_369_2
	tbl_4.node_positions = tbl_15
	tbl_4.available_actions = tbl_16

	return {
		element = {
			passes = tbl_3
		},
		content = tbl_4,
		style = tbl_5,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_369_0
	}
end

UIWidgets.create_level_widget = function (arg_384_0)
	-- function 384
	return {
		scenegraph_id = arg_384_0,
		offset = {
			0,
			0,
			0
		},
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					pass_type = "texture",
					style_id = "glass",
					texture_id = "glass"
				},
				{
					pass_type = "texture",
					style_id = "frame_glow",
					texture_id = "frame_glow"
				}
			}
		},
		content = {
			glass = "act_presentation_fg_glass",
			icon = "level_icon_01",
			frame = "map_frame_00",
			frame_glow = "map_frame_glow_02"
		},
		style = {
			frame_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					270,
					270
				},
				offset = {
					0,
					0,
					4
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			glass = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					216,
					216
				},
				offset = {
					0,
					0,
					3
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			frame = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					2
				},
				texture_size = {
					180,
					180
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					168,
					168
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
			}
		}
	}
end

UIWidgets.create_bot_cusomization_button = function (self)
	-- function 385
	local num = 350
	local gui = self.gui
	local num_2 = 50
	local tbl = {
		font_size = 22,
		font_type = "hell_shark_masked"
	}
	local var_385_4, var_385_5 = UIFontByResolution(tbl)
	local var_385_6 = var_385_4[1]
	local var_385_7 = var_385_4[2]
	local var_385_8 = var_385_4[3]
	local str = "MANAGING: "
	local text_extents, var_385_11 = Gui.text_extents(gui, str, var_385_6, var_385_7)
	local num_3 = var_385_11.x - text_extents.x
	local str_2 = string.upper(Localize("lb_playing")) .. ": "
	local text_extents_2, var_385_15 = Gui.text_extents(gui, str_2, var_385_6, var_385_7)
	local num_4 = var_385_15.x - text_extents_2.x
	local num_5 = num_2 + (not (num_4 < num_3) or not num_3 or num_4)
	local num_6 = num_2 + math.max(num_4 - num_3, 0)
	local num_7 = num_2 + math.max(num_3 - num_4, 0)

	return {
		scenegraph_id = "bot_customization_button",
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_change_function = function (self, arg_386_1)
						-- function 386
						local parent = self.parent

						arg_386_1.area_size[1] = 250 + parent.progress * num
					end
				},
				{
					style_id = "left_texture_id",
					texture_id = "left_texture_id",
					pass_type = "texture",
					content_change_function = function (self, arg_387_1)
						-- function 387
						arg_387_1.offset[1] = self.progress * -num
					end
				},
				{
					style_id = "right_texture_id",
					pass_type = "texture_uv",
					content_id = "right_texture_id"
				},
				{
					style_id = "middle_texture_id",
					texture_id = "middle_texture_id",
					pass_type = "texture",
					content_change_function = function (self, arg_388_1)
						-- function 388
						arg_388_1.texture_size[1] = 100 + self.progress * num
					end
				},
				{
					style_id = "left_texture_id",
					texture_id = "mask_id",
					pass_type = "texture",
					content_change_function = function (self, arg_389_1)
						-- function 389
						arg_389_1.offset[1] = self.progress * -num
					end,
					content_change_function = function (self, arg_390_1)
						-- function 390
						arg_390_1.offset[1] = self.progress * -num
					end
				},
				{
					style_id = "right_texture_id",
					pass_type = "texture_uv",
					content_id = "right_mask"
				},
				{
					style_id = "middle_mask",
					texture_id = "middle_mask_id",
					pass_type = "texture",
					content_change_function = function (self, arg_391_1)
						-- function 391
						arg_391_1.texture_size[1] = 100 + self.progress * num
					end
				},
				{
					pass_type = "tiled_texture",
					style_id = "background",
					texture_id = "background_id"
				},
				{
					style_id = "icon",
					texture_id = "icon_id",
					pass_type = "texture",
					content_change_function = function (self, arg_392_1)
						-- function 392
						local hover_progress = self.button_hotspot.hover_progress

						arg_392_1.color = Colors.lerp_color_tables(arg_392_1.unselected_color, arg_392_1.selected_color, hover_progress)
					end
				},
				{
					style_id = "icon_unselected",
					texture_id = "icon_selected_id",
					pass_type = "texture",
					content_change_function = function (self, arg_393_1)
						-- function 393
						local button_hotspot = self.button_hotspot

						arg_393_1.color[1] = 128 * (1 - button_hotspot.hover_progress)
					end
				},
				{
					style_id = "icon_selected",
					texture_id = "icon_selected_id",
					pass_type = "texture",
					content_change_function = function (self, arg_394_1)
						-- function 394
						local button_hotspot = self.button_hotspot

						arg_394_1.color[1] = 255 * button_hotspot.hover_progress
					end
				},
				{
					style_id = "left_side_unselected",
					texture_id = "left_side_selected_id",
					pass_type = "texture",
					content_change_function = function (self, arg_395_1)
						-- function 395
						local button_hotspot = self.button_hotspot

						arg_395_1.color[1] = 128 * (1 - button_hotspot.hover_progress)
						arg_395_1.offset[1] = self.progress * -num
					end
				},
				{
					style_id = "left_side_selected",
					texture_id = "left_side_selected_id",
					pass_type = "texture",
					content_change_function = function (self, arg_396_1)
						-- function 396
						local button_hotspot = self.button_hotspot

						arg_396_1.color[1] = 255 * button_hotspot.hover_progress
						arg_396_1.offset[1] = self.progress * -num
					end
				},
				{
					style_id = "right_side_unselected",
					pass_type = "texture_uv",
					content_id = "right_side_selected_id",
					content_change_function = function (self, arg_397_1)
						-- function 397
						local button_hotspot = self.parent.button_hotspot

						arg_397_1.color[1] = 128 * (1 - button_hotspot.hover_progress)
					end
				},
				{
					style_id = "right_side_selected",
					pass_type = "texture_uv",
					content_id = "right_side_selected_id",
					content_change_function = function (self, arg_398_1)
						-- function 398
						local button_hotspot = self.parent.button_hotspot

						arg_398_1.color[1] = 255 * button_hotspot.hover_progress
					end
				},
				{
					style_id = "middle_unselected",
					texture_id = "middle_selected_id",
					pass_type = "texture",
					content_change_function = function (self, arg_399_1)
						-- function 399
						local button_hotspot = self.button_hotspot

						arg_399_1.color[1] = 128 * (1 - button_hotspot.hover_progress)
						arg_399_1.texture_size[1] = 100 + self.progress * num
					end
				},
				{
					style_id = "middle_selected",
					texture_id = "middle_selected_id",
					pass_type = "texture",
					content_change_function = function (self, arg_400_1)
						-- function 400
						local button_hotspot = self.button_hotspot

						arg_400_1.color[1] = 255 * button_hotspot.hover_progress
						arg_400_1.texture_size[1] = 100 + self.progress * num
					end
				},
				{
					style_id = "managing_header",
					pass_type = "text",
					text_id = "managing_header"
				},
				{
					style_id = "managing_header_shadow",
					pass_type = "text",
					text_id = "managing_header"
				},
				{
					style_id = "playing_header",
					pass_type = "text",
					text_id = "playing_header"
				},
				{
					style_id = "playing_header_shadow",
					pass_type = "text",
					text_id = "playing_header"
				},
				{
					style_id = "managing_career",
					pass_type = "text",
					text_id = "managing_career_name"
				},
				{
					style_id = "managing_career_shadow",
					pass_type = "text",
					text_id = "managing_career_name"
				},
				{
					style_id = "playing_career",
					pass_type = "text",
					text_id = "playing_career_name"
				},
				{
					style_id = "playing_career_shadow",
					pass_type = "text",
					text_id = "playing_career_name"
				}
			}
		},
		content = {
			middle_texture_id = "character_customization_expandable_border",
			texture_id = "console_menu_bot_cusomization",
			middle_selected_id = "character_customization_expandable_border_selected",
			progress = 0,
			background_id = "character_customization_bg",
			icon_selected_id = "character_customization_bag_icon_selected",
			left_side_selected_id = "character_customization_side_decoration_selected",
			visible = true,
			left_texture_id = "character_customization_side_decoration",
			middle_mask_id = "mask_rect",
			selected_texture = "console_menu_bot_cusomization_highlight",
			managing_career_name = "",
			playing_career_name = "",
			icon_id = "character_customization_bag_icon_unselected",
			mask_id = "character_customization_side_decoration_mask",
			button_hotspot = {},
			right_texture_id = {
				texture_id = "character_customization_side_decoration",
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
			right_mask = {
				texture_id = "character_customization_side_decoration_mask",
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
			right_side_selected_id = {
				texture_id = "character_customization_side_decoration_selected",
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
			managing_header = str,
			playing_header = str_2
		},
		style = {
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					76.8,
					76.8
				},
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				selected_color = Colors.get_color_table_with_alpha("white", 255),
				unselected_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					5,
					1
				}
			},
			icon_selected = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					76.8,
					76.8
				},
				color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					0,
					5,
					0
				}
			},
			icon_unselected = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					76.8,
					76.8
				},
				color = Colors.get_color_table_with_alpha("black", 128),
				offset = {
					0,
					5,
					0
				}
			},
			button_hotspot = {
				horizontal_alignment = "right",
				area_size = {
					250,
					90
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					17,
					24,
					0
				}
			},
			left_texture_id = {
				horizontal_alignment = "left",
				texture_size = {
					103,
					105
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
					5
				}
			},
			left_side_unselected = {
				horizontal_alignment = "left",
				texture_size = {
					103,
					105
				},
				color = Colors.get_color_table_with_alpha("black", 128),
				offset = {
					0,
					0,
					0
				}
			},
			left_side_selected = {
				horizontal_alignment = "left",
				texture_size = {
					103,
					105
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
			right_texture_id = {
				horizontal_alignment = "right",
				texture_size = {
					103,
					105
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
					5
				}
			},
			right_side_unselected = {
				horizontal_alignment = "right",
				texture_size = {
					103,
					105
				},
				color = Colors.get_color_table_with_alpha("black", 128),
				offset = {
					0,
					0,
					0
				}
			},
			right_side_selected = {
				horizontal_alignment = "right",
				texture_size = {
					103,
					105
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
			middle_mask = {
				horizontal_alignment = "right",
				texture_size = {
					50,
					105
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-103,
					21,
					0
				}
			},
			middle_texture_id = {
				point_sample = true,
				horizontal_alignment = "right",
				texture_size = {
					125,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-75,
					13,
					3
				}
			},
			middle_unselected = {
				point_sample = true,
				horizontal_alignment = "right",
				texture_size = {
					125,
					18
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-75,
					13,
					4
				}
			},
			middle_selected = {
				point_sample = true,
				horizontal_alignment = "right",
				texture_size = {
					125,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-75,
					13,
					4
				}
			},
			background = {
				masked = true,
				horizontal_alignment = "right",
				texture_size = {
					num + 250,
					105
				},
				texture_tiling_size = {
					68,
					105
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-2,
					-10
				}
			},
			selected_texture = {
				color = {
					0,
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
			managing_header = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					num_6 - num,
					-17,
					4
				}
			},
			managing_header_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					num_6 + 2 - num,
					-19,
					3
				}
			},
			playing_header = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					num_7 - num,
					-47,
					4
				}
			},
			playing_header_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					num_7 + 2 - num,
					-49,
					3
				}
			},
			managing_career = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					num_5 + 5 - num,
					-17,
					4
				}
			},
			managing_career_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					num_5 + 5 + 2 - num,
					-19,
					3
				}
			},
			playing_career = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					num_5 + 5 - num,
					-47,
					4
				}
			},
			playing_career_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					num_5 + 5 + 2 - num,
					-49,
					3
				}
			}
		},
		offset = {
			0,
			3,
			1
		}
	}
end

UIWidgets.create_system_button = function (arg_401_0)
	-- function 401
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					pass_type = "texture",
					style_id = "selected_texture",
					texture_id = "selected_texture"
				}
			}
		},
		content = {
			selected_texture = "console_menu_system_highlight",
			texture_id = "console_menu_system",
			button_hotspot = {}
		},
		style = {
			button_hotspot = {
				size = {
					220,
					90
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					17,
					24,
					0
				}
			},
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
					0
				}
			},
			selected_texture = {
				color = {
					0,
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
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_401_0
	}
end

UIWidgets.create_hero_icon_widget = function (arg_402_0, arg_402_1)
	-- function 402
	local tbl = {
		80,
		80
	}

	return {
		element = {
			passes = {
				{
					pass_type = "hover",
					style_id = "hourglass_icon"
				},
				{
					pass_type = "texture",
					style_id = "bg",
					texture_id = "bg",
					content_check_function = function (self, arg_403_1)
						-- function 403
						return self.use_empty_icon
					end
				},
				{
					style_id = "hourglass_icon",
					texture_id = "hourglass_icon",
					pass_type = "texture",
					content_check_function = function (self, arg_404_1)
						-- function 404
						return self.use_empty_icon
					end,
					content_change_function = function (self, arg_405_1)
						-- function 405
						local flag

						flag = not self.is_hover and 255 and 184
						arg_405_1.color[1] = math.ceil(arg_405_1.color[1] + 0.1 * (flag - arg_405_1.color[1]))
					end
				},
				{
					pass_type = "texture",
					style_id = "bot_order_texture",
					texture_id = "bot_order_texture_id",
					content_check_function = function (self, arg_406_1)
						-- function 406
						return self.bot_selection_active
					end
				},
				{
					pass_type = "texture",
					style_id = "bot_order_bg",
					texture_id = "bot_order_bg_id",
					content_check_function = function (self, arg_407_1)
						-- function 407
						return self.bot_selection_active
					end
				},
				{
					style_id = "bot_order_hotspot",
					pass_type = "hotspot",
					content_id = "bot_order_hotspot",
					content_check_function = function (arg_408_0, arg_408_1)
						-- function 408
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "bot_order_button",
					texture_id = "bot_order_button",
					pass_type = "texture",
					content_check_function = function (self, arg_409_1)
						-- function 409
						local bot_change_order_hotspot = self.bot_change_order_hotspot

						return not not Managers.input:is_device_active("gamepad") or not not bot_change_order_hotspot.is_hover or not not self.bot_change_order_active or self.bot_selection_active
					end,
					content_change_function = function (arg_410_0, arg_410_1)
						-- function 410
						arg_410_1.color[1] = 128
					end
				},
				{
					style_id = "bot_order_button",
					texture_id = "bot_order_highlight_button",
					pass_type = "texture",
					content_check_function = function (self, arg_411_1)
						-- function 411
						local bot_change_order_hotspot = self.bot_change_order_hotspot

						return not not self.bot_change_order_active or self.bot_selection_active or not not Managers.input:is_device_active("gamepad") or not bot_change_order_hotspot.is_hover
					end,
					content_change_function = function (arg_412_0, arg_412_1)
						-- function 412
						arg_412_1.color[1] = 255
					end
				},
				{
					style_id = "bot_change_order_hotspot",
					pass_type = "hotspot",
					content_id = "bot_change_order_hotspot",
					content_check_function = function (arg_413_0, arg_413_1)
						-- function 413
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "bot_change_order_button",
					texture_id = "bot_change_order_button",
					pass_type = "texture",
					content_check_function = function (self, arg_414_1)
						-- function 414
						local bot_change_order_active

						if not Managers.input:is_device_active("gamepad") then
							bot_change_order_active = self.bot_change_order_active

							if not bot_change_order_active then
								bot_change_order_active = self.bot_selection_active

								if not bot_change_order_active then
									bot_change_order_active = not self.bot_change_order_hotspot.is_hover
								end
							end
						else
							bot_change_order_active = false
						end

						if false then
							bot_change_order_active = true
						end

						return bot_change_order_active
					end,
					content_change_function = function (self, arg_415_1)
						-- function 415
						local bot_change_order_hotspot = self.bot_change_order_hotspot
						local color = arg_415_1.color
						local flag

						flag = not bot_change_order_hotspot.is_hover and 255 and 128
						color[1] = flag
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 416
						return not not self.selected or not self.bot_selection_active
					end
				},
				{
					texture_id = "icon_selected",
					style_id = "icon_selected",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 417
						local selected = self.selected

						selected = not selected and not self.bot_selection_active

						return selected
					end
				},
				{
					texture_id = "holder",
					style_id = "holder",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 418
						return not self.bot_selection_active
					end
				}
			}
		},
		content = {
			bot_order_bg_id = "bot_order_base",
			holder = "divider_vertical_hero_decoration",
			bot_order_highlight_button = "cog_icon_selected",
			bot_selection_active = false,
			bg = "character_slot_empty",
			bot_change_order_active = false,
			hourglass_icon = "icon_hourglass",
			use_empty_icon = false,
			bot_order_button = "cog_icon",
			bot_change_order_button = "athanor_icon_loading",
			icon = "hero_icon_large_bright_wizard",
			bot_order_texture_id = "bot_order_1",
			icon_selected = "hero_icon_large_bright_wizard",
			bot_order_hotspot = {},
			bot_change_order_hotspot = {}
		},
		style = {
			bg = {
				size = {
					110,
					130
				},
				offset = {
					58,
					7,
					0
				}
			},
			hourglass_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					110,
					130
				},
				texture_size = UIAtlasHelper.get_atlas_settings_by_texture_name("icon_hourglass").size,
				color = {
					184,
					255,
					255,
					255
				},
				offset = {
					58,
					7,
					0
				}
			},
			bot_order_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					110,
					130
				},
				offset = {
					0,
					0,
					1
				}
			},
			bot_order_bg = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					110,
					130
				}
			},
			bot_order_hotspot = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				area_size = {
					58,
					58
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					550,
					0,
					100
				}
			},
			bot_order_button = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				texture_size = {
					58,
					58
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					550,
					0,
					0
				}
			},
			bot_change_order_button = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				texture_size = {
					29,
					30.16
				},
				color = {
					255,
					249,
					239,
					222
				},
				offset = {
					536.25,
					0,
					0
				}
			},
			bot_change_order_hotspot = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				area_size = {
					1920,
					144
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
					100
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = tbl,
				color = {
					200,
					80,
					80,
					80
				},
				offset = {
					-40,
					0,
					1
				}
			},
			icon_selected = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = tbl,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-40,
					0,
					1
				}
			},
			holder = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_402_1,
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
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_402_0
	}
end

UIWidgets.create_hero_widget = function (arg_419_0, arg_419_1)
	-- function 419
	local menu_frame_12 = UIFrameSettings.menu_frame_12
	local frame_corner_detail_01_gold = UIFrameSettings.frame_corner_detail_01_gold
	local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
	local var_419_3 = frame_outer_glow_01.texture_sizes.horizontal[2]
	local str = "frame_inner_glow_03"
	local var_419_5 = UIFrameSettings[str]

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "portrait",
					style_id = "portrait",
					pass_type = "texture"
				},
				{
					pass_type = "rect",
					style_id = "rect"
				},
				{
					texture_id = "lock_texture",
					style_id = "lock_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 420
						return self.locked
					end
				},
				{
					texture_id = "taken_texture",
					style_id = "taken_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 421
						local taken = self.taken

						taken = not taken and not self.locked

						return taken
					end
				},
				{
					texture_id = "bot_frame",
					style_id = "bot_frame",
					pass_type = "texture_frame",
					content_check_function = function (self)
						-- function 422
						return self.bot_selected
					end
				},
				{
					texture_id = "bot_texture",
					style_id = "bot_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 423
						return self.bot_selected
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					pass_type = "texture_frame",
					style_id = "frame_premium",
					texture_id = "frame_premium",
					content_check_function = function (self)
						-- function 424
						return self.is_premium
					end
				},
				{
					style_id = "overlay",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 425
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.is_hover or not not button_hotspot.is_selected or not self.locked
					end
				},
				{
					style_id = "overlay_locked",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 426
						local button_hotspot = self.button_hotspot

						return self.locked
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "hover_frame",
					texture_id = "hover_frame",
					content_check_function = function (self)
						-- function 427
						local is_device_active = Managers.input:is_device_active("mouse")
						local is_selected = self.button_hotspot.is_selected

						is_selected = not is_selected and not self.bot_selection_active and not is_device_active

						return is_selected
					end
				}
			}
		},
		content = {
			portrait = "icons_placeholder",
			locked = false,
			lock_texture = "hero_icon_locked",
			taken_texture = "hero_icon_unavailable",
			taken = false,
			bot_selection_active = false,
			bot_texture = "bot_selected_icon",
			button_hotspot = {},
			bot_frame = var_419_5.texture,
			frame = menu_frame_12.texture,
			frame_premium = frame_corner_detail_01_gold.texture,
			hover_frame = frame_outer_glow_01.texture
		},
		style = {
			rect = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_419_1,
				color = {
					200,
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
			portrait = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_419_1,
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
			lock_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					76,
					87
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
					5
				}
			},
			taken_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					112,
					112
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
					6
				}
			},
			bot_frame = {
				texture_size = var_419_5.texture_size,
				texture_sizes = var_419_5.texture_sizes,
				color = {
					255,
					244,
					171,
					135
				},
				offset = {
					0,
					0,
					3
				}
			},
			bot_texture = {
				texture_size = {
					20,
					20
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					10,
					10,
					6
				}
			},
			bot_text = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				localize = false,
				font_size = 24,
				font_type = "hell_shark_header",
				text_color = {
					255,
					200,
					255,
					255
				},
				offset = {
					35,
					0,
					6
				}
			},
			overlay = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_419_1,
				color = {
					80,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					2
				}
			},
			overlay_locked = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_419_1,
				color = {
					200,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					2
				}
			},
			frame = {
				texture_size = menu_frame_12.texture_size,
				texture_sizes = menu_frame_12.texture_sizes,
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
			frame_premium = {
				texture_size = frame_corner_detail_01_gold.texture_size,
				texture_sizes = frame_corner_detail_01_gold.texture_sizes,
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
			hover_frame = {
				size = {
					arg_419_1[1] + var_419_3 * 2,
					arg_419_1[2] + var_419_3 * 2
				},
				texture_size = frame_outer_glow_01.texture_size,
				texture_sizes = frame_outer_glow_01.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-var_419_3,
					-var_419_3,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_419_0
	}
end

UIWidgets.create_career_perk_text = function (arg_428_0)
	-- function 428
	return {
		element = {
			passes = {
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					style_id = "description_text_shadow",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				}
			}
		},
		content = {
			icon = "tooltip_marker",
			title_text = "n/a",
			description_text = "n/a"
		},
		style = {
			icon = {
				vertical_alignment = "bottom",
				masked = true,
				horizontal_alignment = "left",
				texture_size = {
					13,
					13
				},
				offset = {
					0,
					6,
					2
				}
			},
			title_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					20,
					-5,
					2
				}
			},
			title_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					22,
					-7,
					0
				}
			},
			description_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					20,
					0,
					2
				}
			},
			description_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark_masked",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					22,
					-2,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_428_0
	}
end

UIWidgets.create_bot_cusomization_button = function (self)
	-- function 429
	local num = 350
	local gui = self.gui
	local num_2 = 50
	local tbl = {
		font_size = 22,
		font_type = "hell_shark_masked"
	}
	local var_429_4, var_429_5 = UIFontByResolution(tbl)
	local var_429_6 = var_429_4[1]
	local var_429_7 = var_429_4[2]
	local var_429_8 = var_429_4[3]
	local str = "MANAGING: "
	local text_extents, var_429_11 = Gui.text_extents(gui, str, var_429_6, var_429_7)
	local num_3 = var_429_11.x - text_extents.x
	local str_2 = string.upper(Localize("lb_playing")) .. ": "
	local text_extents_2, var_429_15 = Gui.text_extents(gui, str_2, var_429_6, var_429_7)
	local num_4 = var_429_15.x - text_extents_2.x
	local num_5 = num_2 + (not (num_4 < num_3) or not num_3 or num_4)
	local num_6 = num_2 + math.max(num_4 - num_3, 0)
	local num_7 = num_2 + math.max(num_3 - num_4, 0)

	return {
		scenegraph_id = "bot_customization_button",
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_change_function = function (self, arg_430_1)
						-- function 430
						local parent = self.parent

						arg_430_1.area_size[1] = 250 + parent.progress * num
					end
				},
				{
					style_id = "left_texture_id",
					texture_id = "left_texture_id",
					pass_type = "texture",
					content_change_function = function (self, arg_431_1)
						-- function 431
						arg_431_1.offset[1] = self.progress * -num
					end
				},
				{
					style_id = "right_texture_id",
					pass_type = "texture_uv",
					content_id = "right_texture_id"
				},
				{
					style_id = "middle_texture_id",
					texture_id = "middle_texture_id",
					pass_type = "texture",
					content_change_function = function (self, arg_432_1)
						-- function 432
						arg_432_1.texture_size[1] = 100 + self.progress * num
					end
				},
				{
					style_id = "left_texture_id",
					texture_id = "mask_id",
					pass_type = "texture",
					content_change_function = function (self, arg_433_1)
						-- function 433
						arg_433_1.offset[1] = self.progress * -num
					end,
					content_change_function = function (self, arg_434_1)
						-- function 434
						arg_434_1.offset[1] = self.progress * -num
					end
				},
				{
					style_id = "right_texture_id",
					pass_type = "texture_uv",
					content_id = "right_mask"
				},
				{
					style_id = "middle_mask",
					texture_id = "middle_mask_id",
					pass_type = "texture",
					content_change_function = function (self, arg_435_1)
						-- function 435
						arg_435_1.texture_size[1] = 100 + self.progress * num
					end
				},
				{
					pass_type = "tiled_texture",
					style_id = "background",
					texture_id = "background_id"
				},
				{
					style_id = "icon",
					texture_id = "icon_id",
					pass_type = "texture",
					content_change_function = function (self, arg_436_1)
						-- function 436
						local hover_progress = self.button_hotspot.hover_progress

						arg_436_1.color = Colors.lerp_color_tables(arg_436_1.unselected_color, arg_436_1.selected_color, hover_progress)
					end
				},
				{
					style_id = "icon_unselected",
					texture_id = "icon_selected_id",
					pass_type = "texture",
					content_change_function = function (self, arg_437_1)
						-- function 437
						local button_hotspot = self.button_hotspot

						arg_437_1.color[1] = 128 * (1 - button_hotspot.hover_progress)
					end
				},
				{
					style_id = "icon_selected",
					texture_id = "icon_selected_id",
					pass_type = "texture",
					content_change_function = function (self, arg_438_1)
						-- function 438
						local button_hotspot = self.button_hotspot

						arg_438_1.color[1] = 255 * button_hotspot.hover_progress
					end
				},
				{
					style_id = "left_side_unselected",
					texture_id = "left_side_selected_id",
					pass_type = "texture",
					content_change_function = function (self, arg_439_1)
						-- function 439
						local button_hotspot = self.button_hotspot

						arg_439_1.color[1] = 128 * (1 - button_hotspot.hover_progress)
						arg_439_1.offset[1] = self.progress * -num
					end
				},
				{
					style_id = "left_side_selected",
					texture_id = "left_side_selected_id",
					pass_type = "texture",
					content_change_function = function (self, arg_440_1)
						-- function 440
						local button_hotspot = self.button_hotspot

						arg_440_1.color[1] = 255 * button_hotspot.hover_progress
						arg_440_1.offset[1] = self.progress * -num
					end
				},
				{
					style_id = "right_side_unselected",
					pass_type = "texture_uv",
					content_id = "right_side_selected_id",
					content_change_function = function (self, arg_441_1)
						-- function 441
						local button_hotspot = self.parent.button_hotspot

						arg_441_1.color[1] = 128 * (1 - button_hotspot.hover_progress)
					end
				},
				{
					style_id = "right_side_selected",
					pass_type = "texture_uv",
					content_id = "right_side_selected_id",
					content_change_function = function (self, arg_442_1)
						-- function 442
						local button_hotspot = self.parent.button_hotspot

						arg_442_1.color[1] = 255 * button_hotspot.hover_progress
					end
				},
				{
					style_id = "middle_unselected",
					texture_id = "middle_selected_id",
					pass_type = "texture",
					content_change_function = function (self, arg_443_1)
						-- function 443
						local button_hotspot = self.button_hotspot

						arg_443_1.color[1] = 128 * (1 - button_hotspot.hover_progress)
						arg_443_1.texture_size[1] = 100 + self.progress * num
					end
				},
				{
					style_id = "middle_selected",
					texture_id = "middle_selected_id",
					pass_type = "texture",
					content_change_function = function (self, arg_444_1)
						-- function 444
						local button_hotspot = self.button_hotspot

						arg_444_1.color[1] = 255 * button_hotspot.hover_progress
						arg_444_1.texture_size[1] = 100 + self.progress * num
					end
				},
				{
					style_id = "managing_header",
					pass_type = "text",
					text_id = "managing_header"
				},
				{
					style_id = "managing_header_shadow",
					pass_type = "text",
					text_id = "managing_header"
				},
				{
					style_id = "playing_header",
					pass_type = "text",
					text_id = "playing_header"
				},
				{
					style_id = "playing_header_shadow",
					pass_type = "text",
					text_id = "playing_header"
				},
				{
					style_id = "managing_career",
					pass_type = "text",
					text_id = "managing_career_name"
				},
				{
					style_id = "managing_career_shadow",
					pass_type = "text",
					text_id = "managing_career_name"
				},
				{
					style_id = "playing_career",
					pass_type = "text",
					text_id = "playing_career_name"
				},
				{
					style_id = "playing_career_shadow",
					pass_type = "text",
					text_id = "playing_career_name"
				}
			}
		},
		content = {
			middle_texture_id = "character_customization_expandable_border",
			texture_id = "console_menu_bot_cusomization",
			middle_selected_id = "character_customization_expandable_border_selected",
			progress = 0,
			background_id = "character_customization_bg",
			icon_selected_id = "character_customization_bag_icon_selected",
			left_side_selected_id = "character_customization_side_decoration_selected",
			visible = true,
			left_texture_id = "character_customization_side_decoration",
			middle_mask_id = "mask_rect",
			selected_texture = "console_menu_bot_cusomization_highlight",
			managing_career_name = "",
			playing_career_name = "",
			icon_id = "character_customization_bag_icon_unselected",
			mask_id = "character_customization_side_decoration_mask",
			button_hotspot = {},
			right_texture_id = {
				texture_id = "character_customization_side_decoration",
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
			right_mask = {
				texture_id = "character_customization_side_decoration_mask",
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
			right_side_selected_id = {
				texture_id = "character_customization_side_decoration_selected",
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
			managing_header = str,
			playing_header = str_2
		},
		style = {
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					76.8,
					76.8
				},
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				selected_color = Colors.get_color_table_with_alpha("white", 255),
				unselected_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					5,
					1
				}
			},
			icon_selected = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					76.8,
					76.8
				},
				color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					0,
					5,
					0
				}
			},
			icon_unselected = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					76.8,
					76.8
				},
				color = Colors.get_color_table_with_alpha("black", 128),
				offset = {
					0,
					5,
					0
				}
			},
			button_hotspot = {
				horizontal_alignment = "right",
				area_size = {
					250,
					90
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					17,
					24,
					0
				}
			},
			left_texture_id = {
				horizontal_alignment = "left",
				texture_size = {
					103,
					105
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
					5
				}
			},
			left_side_unselected = {
				horizontal_alignment = "left",
				texture_size = {
					103,
					105
				},
				color = Colors.get_color_table_with_alpha("black", 128),
				offset = {
					0,
					0,
					0
				}
			},
			left_side_selected = {
				horizontal_alignment = "left",
				texture_size = {
					103,
					105
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
			right_texture_id = {
				horizontal_alignment = "right",
				texture_size = {
					103,
					105
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
					5
				}
			},
			right_side_unselected = {
				horizontal_alignment = "right",
				texture_size = {
					103,
					105
				},
				color = Colors.get_color_table_with_alpha("black", 128),
				offset = {
					0,
					0,
					0
				}
			},
			right_side_selected = {
				horizontal_alignment = "right",
				texture_size = {
					103,
					105
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
			middle_mask = {
				horizontal_alignment = "right",
				texture_size = {
					50,
					105
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-103,
					21,
					0
				}
			},
			middle_texture_id = {
				point_sample = true,
				horizontal_alignment = "right",
				texture_size = {
					125,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-75,
					13,
					3
				}
			},
			middle_unselected = {
				point_sample = true,
				horizontal_alignment = "right",
				texture_size = {
					125,
					18
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-75,
					13,
					4
				}
			},
			middle_selected = {
				point_sample = true,
				horizontal_alignment = "right",
				texture_size = {
					125,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-75,
					13,
					4
				}
			},
			background = {
				masked = true,
				horizontal_alignment = "right",
				texture_size = {
					num + 250,
					105
				},
				texture_tiling_size = {
					68,
					105
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-2,
					-10
				}
			},
			selected_texture = {
				color = {
					0,
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
			managing_header = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					num_6 - num,
					-17,
					4
				}
			},
			managing_header_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					num_6 + 2 - num,
					-19,
					3
				}
			},
			playing_header = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					num_7 - num,
					-47,
					4
				}
			},
			playing_header_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					num_7 + 2 - num,
					-49,
					3
				}
			},
			managing_career = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					num_5 + 5 - num,
					-17,
					4
				}
			},
			managing_career_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					num_5 + 5 + 2 - num,
					-19,
					3
				}
			},
			playing_career = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					num_5 + 5 - num,
					-47,
					4
				}
			},
			playing_career_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = tbl.font_size,
				font_type = tbl.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					num_5 + 5 + 2 - num,
					-49,
					3
				}
			}
		},
		offset = {
			0,
			3,
			1
		}
	}
end

UIWidgets.create_system_button = function (arg_445_0)
	-- function 445
	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					pass_type = "texture",
					style_id = "selected_texture",
					texture_id = "selected_texture"
				}
			}
		},
		content = {
			selected_texture = "console_menu_system_highlight",
			texture_id = "console_menu_system",
			button_hotspot = {}
		},
		style = {
			button_hotspot = {
				size = {
					220,
					90
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					17,
					24,
					0
				}
			},
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
					0
				}
			},
			selected_texture = {
				color = {
					0,
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
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_445_0
	}
end

UIWidgets.create_rounded_rect_with_text = function (arg_446_0, arg_446_1, arg_446_2, arg_446_3, arg_446_4, arg_446_5)
	-- function 446
	arg_446_2 = arg_446_2 or {
		word_wrap = false,
		font_size = 22,
		localize = false,
		vertical_alignment = "center",
		horizontal_alignment = "center",
		use_shadow = false,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			0,
			0,
			2
		}
	}

	local clone = table.clone(arg_446_2)

	clone.text_color = {
		255,
		0,
		0,
		0
	}
	clone.offset = {
		2,
		-2,
		1
	}

	local ui_renderer = Managers.ui:ingame_ui().ui_renderer
	local var_446_2, var_446_3 = UIFontByResolution(arg_446_2)
	local text_size, var_446_5, var_446_6 = UIRenderer.text_size(ui_renderer, arg_446_1, var_446_2[1], var_446_3)
	local tbl = {}
	local tbl_2 = {
		passes = {}
	}
	local passes = tbl_2.passes
	local tbl_3 = {}
	local tbl_4 = {}

	passes[#passes + 1] = {
		pass_type = "rounded_background",
		style_id = "background"
	}
	passes[#passes + 1] = {
		style_id = "text",
		pass_type = "text",
		text_id = "text"
	}
	passes[#passes + 1] = {
		style_id = "text_shadow",
		pass_type = "text",
		text_id = "text",
		content_check_function = function (arg_447_0, arg_447_1)
			-- function 447
			return arg_447_1.use_shadow
		end
	}
	tbl_3.text = arg_446_1

	local tbl_5 = {}
	local var_446_13 = arg_446_5[1]

	var_446_13 = var_446_13 or text_size + var_446_3 * 0.5
	tbl_5[1] = var_446_13

	local var_446_14 = arg_446_5[2]

	var_446_14 = var_446_14 or var_446_5 + var_446_3 * 0.5
	tbl_5[2] = var_446_14
	tbl_3.size = tbl_5

	local tbl_6 = {
		vertical_alignment = "center",
		corner_radius = 10,
		horizontal_alignment = "center",
		color = arg_446_3 or {
			255,
			71,
			71,
			71
		}
	}
	local tbl_7 = {}
	local var_446_17 = arg_446_5[1]

	var_446_17 = var_446_17 or text_size + var_446_3 * 0.5
	tbl_7[1] = var_446_17

	local var_446_18 = arg_446_5[2]

	var_446_18 = var_446_18 or var_446_5 + var_446_3 * 0.5
	tbl_7[2] = var_446_18
	tbl_6.rect_size = tbl_7
	tbl_6.offset = {
		0,
		var_446_3 * 0.05,
		0
	}
	tbl_4.background = tbl_6
	tbl_4.text = arg_446_2
	tbl_4.text_shadow = clone
	tbl.element = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.scenegraph_id = arg_446_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

UIWidgets.create_simple_triangle = function (arg_448_0, arg_448_1, arg_448_2, arg_448_3, arg_448_4)
	-- function 448
	local tbl = {}
	local tbl_2 = {
		passes = {}
	}
	local passes = tbl_2.passes
	local tbl_3 = {}
	local tbl_4 = {}

	passes[#passes + 1] = {
		pass_type = "triangle",
		style_id = "triangle"
	}
	tbl_4.triangle = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		triangle_alignment = arg_448_2,
		texture_size = arg_448_3,
		color = arg_448_1
	}
	tbl_3.disable_with_gamepad = arg_448_4
	tbl.element = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.scenegraph_id = arg_448_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

UIWidgets.create_overcharge_bar_widget = function (arg_449_0, arg_449_1, arg_449_2, arg_449_3, arg_449_4, arg_449_5, arg_449_6)
	-- function 449
	local flag = arg_449_5 or {
		250,
		16
	}
	local var_449_1

	if not arg_449_3 then
		var_449_1 = UIFrameSettings[arg_449_3]

		if not var_449_1 then
			-- Nothing
		end
	end

	var_449_1 = UIFrameSettings.frame_outer_glow_01

	::label_449_0::

	local var_449_2 = var_449_1.texture_sizes.corner[1]

	return {
		element = {
			passes = {
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
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
					pass_type = "rect",
					style_id = "bar_bg"
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "bar_1",
					texture_id = "bar_1"
				},
				{
					pass_type = "rect",
					style_id = "min_threshold"
				},
				{
					pass_type = "rect",
					style_id = "max_threshold"
				}
			}
		},
		content = {
			icon = arg_449_4 or "tabs_icon_all_selected",
			bar_1 = arg_449_1 or "overcharge_bar",
			bar_fg = arg_449_2 or "overcharge_frame",
			size = {
				flag[1] - 6,
				flag[2]
			},
			frame = var_449_1.texture
		},
		style = {
			frame = {
				frame_margins = {
					-(var_449_2 - 1),
					-(var_449_2 - 1)
				},
				texture_size = var_449_1.texture_size,
				texture_sizes = var_449_1.texture_sizes,
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
				size = flag
			},
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
					3,
					3
				},
				size = {
					flag[1] - 6,
					flag[2] - 6
				}
			},
			icon = {
				size = {
					34,
					34
				},
				offset = {
					flag[1],
					flag[2] / 2 - 17,
					5
				},
				color = {
					100,
					0,
					0,
					1
				}
			},
			icon_shadow = {
				size = {
					34,
					34
				},
				offset = {
					flag[1] + 2,
					flag[2] / 2 - 17 - 2,
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
					204,
					255,
					255,
					255
				},
				size = flag
			},
			bar_bg = {
				size = {
					flag[1] - 6,
					flag[2] - 5
				},
				offset = {
					3,
					3,
					0
				},
				color = {
					100,
					0,
					0,
					0
				}
			},
			min_threshold = {
				pivot = {
					0,
					0
				},
				offset = {
					0,
					3,
					4
				},
				color = {
					204,
					0,
					0,
					0
				},
				size = {
					2,
					flag[2] - 6
				}
			},
			max_threshold = {
				pivot = {
					0,
					0
				},
				offset = {
					0,
					3,
					4
				},
				color = {
					204,
					0,
					0,
					0
				},
				size = {
					2,
					flag[2] - 6
				}
			}
		},
		offset = arg_449_6 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_449_0
	}
end

UIWidgets.create_tag = function (arg_450_0, arg_450_1, arg_450_2)
	-- function 450
	local tbl = {
		word_wrap = false,
		font_size = 22,
		localize = false,
		vertical_alignment = "center",
		horizontal_alignment = "center",
		use_shadow = false,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			0,
			0,
			2
		}
	}
	local clone = table.clone(tbl)

	clone.text_color = {
		255,
		0,
		0,
		0
	}
	clone.offset = {
		2,
		-2,
		1
	}

	local ui_renderer = Managers.ui:ingame_ui().ui_renderer
	local var_450_3, var_450_4 = UIFontByResolution(tbl)
	local text_size, var_450_6, var_450_7 = UIRenderer.text_size(ui_renderer, arg_450_1, var_450_3[1], var_450_4)
	local tbl_2 = {}
	local tbl_3 = {
		passes = {}
	}
	local passes = tbl_3.passes
	local tbl_4 = {}
	local tbl_5 = {}

	passes[#passes + 1] = {
		style_id = "background",
		pass_type = "rect",
		content_check_function = function (arg_451_0, arg_451_1)
			-- function 451
			return true
		end
	}
	passes[#passes + 1] = {
		texture_id = "fade",
		style_id = "fade",
		pass_type = "texture"
	}
	passes[#passes + 1] = {
		texture_id = "vignette",
		style_id = "vignette",
		pass_type = "texture"
	}
	passes[#passes + 1] = {
		texture_id = "frame",
		style_id = "frame",
		pass_type = "texture"
	}
	passes[#passes + 1] = {
		style_id = "text",
		pass_type = "text",
		text_id = "text"
	}
	passes[#passes + 1] = {
		style_id = "text_shadow",
		pass_type = "text",
		text_id = "text",
		content_check_function = function (arg_452_0, arg_452_1)
			-- function 452
			return arg_452_1.use_shadow
		end
	}
	tbl_4.text = arg_450_1

	local tbl_6 = {}
	local var_450_14 = arg_450_2[1]

	var_450_14 = var_450_14 or text_size + var_450_4 * 0.5
	tbl_6[1] = var_450_14

	local var_450_15 = arg_450_2[2]

	var_450_15 = var_450_15 or var_450_6 + var_450_4 * 0.5
	tbl_6[2] = var_450_15
	tbl_4.size = tbl_6
	tbl_4.fade = "button_state_default"
	tbl_4.vignette = "button_bg_fade"
	tbl_4.frame = "menu_frame_glass_01"

	local tbl_7 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = {
			255,
			30,
			30,
			30
		}
	}
	local tbl_8 = {}
	local var_450_18 = arg_450_2[1]

	var_450_18 = var_450_18 or text_size + var_450_4 * 0.5
	tbl_8[1] = var_450_18

	local var_450_19 = arg_450_2[2]

	var_450_19 = var_450_19 or var_450_6 + var_450_4 * 0.5
	tbl_8[2] = var_450_19
	tbl_7.texture_size = tbl_8
	tbl_7.offset = {
		0,
		var_450_4 * 0.05,
		0
	}
	tbl_5.background = tbl_7

	local tbl_9 = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = {
			100,
			255,
			255,
			255
		}
	}
	local tbl_10 = {}
	local var_450_22 = arg_450_2[1]

	var_450_22 = var_450_22 or text_size + var_450_4 * 0.5
	tbl_10[1] = var_450_22

	local var_450_23 = arg_450_2[2]

	var_450_23 = var_450_23 or var_450_6 + var_450_4 * 0.5
	tbl_10[2] = var_450_23
	tbl_9.texture_size = tbl_10
	tbl_9.offset = {
		0,
		var_450_4 * 0.05,
		1
	}
	tbl_5.vignette = tbl_9

	local tbl_11 = {
		vertical_alignment = "center",
		horizontal_alignment = "center"
	}
	local tbl_12 = {}
	local var_450_26 = arg_450_2[1]

	var_450_26 = var_450_26 or text_size + var_450_4 * 0.5
	tbl_12[1] = var_450_26

	local var_450_27 = arg_450_2[2]

	var_450_27 = var_450_27 or var_450_6 + var_450_4 * 0.5
	tbl_12[2] = var_450_27
	tbl_11.texture_size = tbl_12
	tbl_11.offset = {
		0,
		var_450_4 * 0.05,
		2
	}
	tbl_5.fade = tbl_11

	local tbl_13 = {
		vertical_alignment = "center",
		horizontal_alignment = "center"
	}
	local tbl_14 = {}
	local var_450_30 = arg_450_2[1]

	var_450_30 = var_450_30 or text_size + var_450_4 * 0.5
	tbl_14[1] = var_450_30

	local var_450_31 = arg_450_2[2]

	var_450_31 = var_450_31 or var_450_6 + var_450_4 * 0.5
	tbl_14[2] = var_450_31
	tbl_13.texture_size = tbl_14
	tbl_13.offset = {
		0,
		var_450_4 * 0.05,
		3
	}
	tbl_5.frame = tbl_13
	tbl_5.text = tbl
	tbl_5.text_shadow = clone
	tbl_2.element = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.scenegraph_id = arg_450_0
	tbl_2.offset = {
		0,
		0,
		0
	}

	return tbl_2
end

UIWidgets.create_loading_spinner = function (arg_453_0)
	-- function 453
	return {
		scenegraph_id = arg_453_0,
		element = {
			passes = {
				{
					style_id = "loading_icon",
					texture_id = "loading_icon",
					pass_type = "rotated_texture",
					content_change_function = function (self, arg_454_1, arg_454_2, arg_454_3)
						-- function 454
						local num = (self.loading_progress + arg_454_3) % 1

						arg_454_1.angle = 2^math.smoothstep(num, 0, 1) * math.tau
						self.loading_progress = num
					end
				}
			}
		},
		content = {
			loading_icon = "loot_loading",
			loading_progress = 0
		},
		style = {
			loading_icon = {
				vertical_alignment = "center",
				angle = 0,
				horizontal_alignment = "center",
				texture_size = {
					150,
					150
				},
				pivot = {
					75,
					75
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
end

UIWidgets.append_item_frame_pass = function (arg_455_0, arg_455_1, arg_455_2, arg_455_3, arg_455_4, arg_455_5, arg_455_6, arg_455_7, arg_455_8, arg_455_9, arg_455_10)
	-- function 455
	assert(type(arg_455_0) == "string", "pass_id needs to be a string")
	assert(type(arg_455_1) == "table", "passes needs to be a table")
	assert(type(arg_455_2) == "table", "content needs to be a table")
	assert(type(arg_455_3) == "table", "style needs to be a table")
	assert(type(arg_455_4) == "table", "icon_size needs to be a table")
	assert(type(arg_455_5) == "table", "offset needs to be a table")
	assert(arg_455_7 == nil or type(arg_455_7) == "string", "optional_content_id needs to be a string or nil")
	assert(arg_455_8 == nil or type(arg_455_8) == "table", "optional_alignment needs to be a table or nil")
	assert(arg_455_6 == nil or type(arg_455_6) == "boolean", "masked needs to be a boolean or nil")
	assert(arg_455_9 == nil or type(arg_455_9) == "string", "optional_scenegraph_id needs to be a string or nil")
	assert(arg_455_10 == nil or type(arg_455_10) == "function", "optional_content_check_function needs to be a function or nil")
	table.append(arg_455_1, {
		{
			pass_type = "texture",
			content_id = arg_455_7,
			texture_id = arg_455_0,
			style_id = arg_455_0,
			content_check_function = arg_455_10
		}
	})

	arg_455_2 = arg_455_2[arg_455_7] or arg_455_2

	table.merge(arg_455_2, {
		[arg_455_0] = "item_frame"
	})

	local merge = table.merge
	local var_455_1 = arg_455_3
	local tbl = {}
	local tbl_2 = {
		masked = arg_455_6
	}
	local horizontal_alignment

	if not arg_455_8 then
		horizontal_alignment = arg_455_8.horizontal_alignment

		if not horizontal_alignment then
			-- Nothing
		end
	end

	horizontal_alignment = nil

	::label_455_0::

	tbl_2.horizontal_alignment = horizontal_alignment

	local vertical_alignment

	if not arg_455_8 then
		vertical_alignment = arg_455_8.vertical_alignment

		if not vertical_alignment then
			-- Nothing
		end
	end

	vertical_alignment = nil

	::label_455_1::

	tbl_2.vertical_alignment = vertical_alignment
	tbl_2.offset = arg_455_5
	tbl_2.color = {
		255,
		255,
		255,
		255
	}
	tbl_2.texture_size = arg_455_4
	tbl_2.scenegraph_id = arg_455_9
	tbl[arg_455_0] = tbl_2

	merge(var_455_1, tbl)
end
