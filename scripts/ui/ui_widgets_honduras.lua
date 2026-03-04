-- chunkname: @scripts/ui/ui_widgets_honduras.lua

require("scripts/settings/ui_frame_settings")
require("scripts/settings/ui_player_portrait_frame_settings")

UIWidgets = UIWidgets or {}

UIWidgets.create_talent_slot = function (arg_1_0, arg_1_1)
	local var_1_0 = {
		50,
		-10
	}
	local var_1_1 = UIFrameSettings.menu_frame_01
	local var_1_2 = UIFrameSettings.menu_frame_03

	return {
		element = {
			passes = {
				{
					style_id = "icon",
					pass_type = "hotspot",
					content_id = "hotspot",
					content_check_function = function (arg_2_0)
						return arg_2_0.parent.icon
					end
				},
				{
					style_id = "available_rect",
					pass_type = "rect",
					content_check_function = function (arg_3_0)
						return not arg_3_0.unavailable and arg_3_0.num_ranks and arg_3_0.num_ranks > arg_3_0.rank
					end
				},
				{
					style_id = "filled_rect",
					pass_type = "rect",
					content_check_function = function (arg_4_0)
						return not arg_4_0.unavailable and arg_4_0.num_ranks and arg_4_0.num_ranks == arg_4_0.rank
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
					content_check_function = function (arg_5_0)
						return not arg_5_0.unavailable
					end
				},
				{
					style_id = "counter_rect",
					pass_type = "rect",
					content_check_function = function (arg_6_0)
						return not arg_6_0.unavailable
					end
				},
				{
					style_id = "counter_text",
					pass_type = "text",
					text_id = "counter_text",
					content_check_function = function (arg_7_0)
						return not arg_7_0.unavailable and arg_7_0.num_ranks and arg_7_0.num_ranks > arg_7_0.rank
					end
				},
				{
					style_id = "counter_text_complete",
					pass_type = "text",
					text_id = "counter_text",
					content_check_function = function (arg_8_0)
						return not arg_8_0.unavailable and arg_8_0.num_ranks and arg_8_0.num_ranks == arg_8_0.rank
					end
				},
				{
					style_id = "rect_rotated",
					pass_type = "rect_rotated",
					content_check_function = function (arg_9_0)
						return arg_9_0.has_connection
					end
				},
				{
					texture_id = "connection_arrow",
					style_id = "connection_arrow",
					pass_type = "rotated_texture",
					content_check_function = function (arg_10_0)
						return arg_10_0.has_connection
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
					content_check_function = function (arg_11_0)
						return arg_11_0.talent_id and arg_11_0.hotspot.is_hover
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
			frame = var_1_1.texture,
			counter_frame = var_1_2.texture
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
				texture_size = var_1_2.texture_size,
				texture_sizes = var_1_2.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_1_0[1],
					var_1_0[2],
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
					var_1_0[1],
					var_1_0[2],
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
					var_1_0[1],
					var_1_0[2],
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
					var_1_0[1],
					var_1_0[2],
					7
				}
			},
			frame = {
				texture_size = var_1_1.texture_size,
				texture_sizes = var_1_1.texture_sizes,
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
	return {
		element = {
			passes = {
				{
					item_id = "item",
					style_id = "item",
					pass_type = "item_tooltip",
					content_passes = arg_12_1,
					content_check_function = function (arg_13_0)
						return arg_13_0.item
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
	return {
		element = {
			passes = {
				{
					item_id = "item",
					style_id = "item",
					pass_type = "item_presentation",
					content_passes = arg_14_1,
					disable_unsupported = arg_14_4,
					content_check_function = function (arg_15_0)
						return arg_15_0.item
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
					content_check_function = function (arg_17_0)
						return arg_17_0.hotspot.is_hover and arg_17_0.hotspot.tooltip
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
	local var_18_0 = Colors.get_color_table_with_alpha("black", 220)
	local var_18_1 = Colors.get_color_table_with_alpha("gray", 50)
	local var_18_2 = {
		element = {}
	}
	local var_18_3 = {
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
	local var_18_4 = {
		title_text = Localize(arg_18_2)
	}
	local var_18_5 = {
		background = {
			corner_radius = 5,
			color = var_18_0,
			offset = {
				0,
				0,
				0
			}
		},
		inner_background = {
			color = var_18_1,
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
			color = var_18_1,
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
			color = var_18_0,
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
			color = var_18_1,
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

	var_18_2.element.passes = var_18_3
	var_18_2.content = var_18_4
	var_18_2.style = var_18_5
	var_18_2.offset = {
		0,
		-40,
		0
	}
	var_18_2.scenegraph_id = arg_18_0

	return var_18_2
end

UIWidgets.create_hero_frame = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_3 = arg_19_3 or "menu_frame_bg_01"

	local var_19_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_19_3)
	local var_19_1 = arg_19_2 and UIFrameSettings[arg_19_2] or UIFrameSettings.menu_frame_02

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
						math.min(arg_19_1[1] / var_19_0.size[1], 1),
						math.min(arg_19_1[2] / var_19_0.size[2], 1)
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
	local var_20_0 = {
		255,
		255,
		255,
		255
	}
	local var_20_1 = {
		255,
		255,
		255,
		255
	}
	local var_20_2 = Colors.get_color_table_with_alpha("dim_gray", 40)
	local var_20_3 = Colors.get_color_table_with_alpha("white", 150)
	local var_20_4 = {
		80,
		80
	}
	local var_20_5 = {
		80,
		80
	}

	arg_20_4 = arg_20_4 or 8
	arg_20_5 = arg_20_5 or 8

	local var_20_6 = {
		element = {}
	}
	local var_20_7 = {}
	local var_20_8 = {
		rows = arg_20_2,
		columns = arg_20_3,
		slots = arg_20_2 * arg_20_3
	}
	local var_20_9 = {}
	local var_20_10 = arg_20_3 * var_20_5[1] + arg_20_4 * (arg_20_3 - 1)
	local var_20_11 = arg_20_1[1] - var_20_10
	local var_20_12 = arg_20_2 * var_20_5[2] + arg_20_5 * (arg_20_2 - 1)
	local var_20_13 = arg_20_1[2] - var_20_12
	local var_20_14 = {
		var_20_11 / 2,
		arg_20_1[2] - var_20_13 / 2 - var_20_5[2]
	}
	local var_20_15 = 3

	for iter_20_0 = 1, arg_20_2 do
		for iter_20_1 = 1, arg_20_3 do
			local var_20_16 = "_" .. tostring(iter_20_0) .. "_" .. tostring(iter_20_1)
			local var_20_17 = iter_20_0 - 1
			local var_20_18 = iter_20_1 - 1
			local var_20_19 = {
				var_20_14[1] + var_20_18 * (var_20_5[1] + arg_20_4),
				var_20_14[2] - var_20_17 * (var_20_5[2] + arg_20_5),
				var_20_15
			}
			local var_20_20 = "item" .. var_20_16
			local var_20_21 = "hotspot" .. var_20_16

			var_20_7[#var_20_7 + 1] = {
				pass_type = "hotspot",
				content_id = var_20_21,
				style_id = var_20_21
			}
			var_20_9[var_20_21] = {
				size = var_20_5,
				offset = var_20_19
			}
			var_20_8[var_20_21] = {
				drag_texture_size = var_20_5
			}

			local var_20_22 = "item_icon" .. var_20_16

			var_20_7[#var_20_7 + 1] = {
				pass_type = "texture",
				content_id = var_20_21,
				texture_id = var_20_22,
				style_id = var_20_22,
				content_check_function = function (arg_21_0)
					return arg_21_0[var_20_22]
				end
			}
			var_20_9[var_20_22] = {
				size = var_20_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_20_19[1],
					var_20_19[2],
					1
				}
			}

			local var_20_23 = "item_frame" .. var_20_16

			var_20_7[#var_20_7 + 1] = {
				pass_type = "texture",
				content_id = var_20_21,
				texture_id = var_20_23,
				style_id = var_20_23,
				content_check_function = function (arg_22_0)
					return arg_22_0[var_20_22]
				end
			}
			var_20_9[var_20_23] = {
				size = var_20_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_20_19[1],
					var_20_19[2],
					4
				}
			}
			var_20_8[var_20_21][var_20_23] = "item_frame"

			local var_20_24 = "item_craft_frame" .. var_20_16

			var_20_7[#var_20_7 + 1] = {
				pass_type = "texture",
				content_id = var_20_21,
				texture_id = var_20_24,
				style_id = var_20_24,
				content_check_function = function (arg_23_0)
					return arg_23_0[var_20_22]
				end
			}
			var_20_9[var_20_24] = {
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
					var_20_19[1] - 9,
					var_20_19[2] - 9,
					6
				}
			}
			var_20_8[var_20_21][var_20_24] = "crafting_bg_03"

			local var_20_25 = "rarity_texture" .. var_20_16

			var_20_7[#var_20_7 + 1] = {
				pass_type = "texture",
				texture_id = var_20_25,
				style_id = var_20_25,
				content_check_function = function (arg_24_0)
					return arg_24_0[var_20_21][var_20_22] and arg_24_0[var_20_20]
				end
			}
			var_20_9[var_20_25] = {
				size = var_20_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_20_19[1],
					var_20_19[2],
					0
				}
			}
			var_20_8[var_20_25] = "icon_bg_default"

			local var_20_26 = "item_tooltip" .. var_20_16

			var_20_7[#var_20_7 + 1] = {
				pass_type = "item_tooltip",
				text_id = var_20_26,
				style_id = var_20_26,
				item_id = "item" .. var_20_16,
				content_check_function = function (arg_25_0)
					return arg_25_0[var_20_21].is_hover and arg_25_0[var_20_20]
				end
			}
			var_20_9[var_20_26] = {
				font_type = "hell_shark",
				localize = true,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				max_width = 500,
				size = var_20_5,
				offset = var_20_19,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("white", 255)
				},
				offset = var_20_19
			}
			var_20_8[var_20_26] = "tooltip_text"

			local var_20_27 = "slot" .. var_20_16

			var_20_7[#var_20_7 + 1] = {
				pass_type = "texture",
				content_id = var_20_21,
				texture_id = var_20_27,
				style_id = var_20_27,
				content_check_function = function (arg_26_0)
					return not arg_26_0[var_20_22] and not arg_26_0.hide_slot
				end
			}
			var_20_9[var_20_27] = {
				size = var_20_5,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_20_19[1],
					var_20_19[2],
					0
				}
			}
			var_20_8[var_20_21][var_20_27] = "menu_slot_frame_01"

			local var_20_28 = "amount_text" .. var_20_16

			var_20_7[#var_20_7 + 1] = {
				pass_type = "text",
				text_id = var_20_28,
				style_id = var_20_28,
				content_id = var_20_21,
				content_check_function = function (arg_27_0)
					return not arg_27_0.hide_slot
				end
			}
			var_20_9[var_20_28] = {
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				font_size = 28,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				size = var_20_4,
				offset = {
					var_20_19[1],
					var_20_19[2] - 44,
					3
				}
			}
			var_20_8[var_20_21][var_20_28] = "0/0"

			local var_20_29 = "amount_text_shadow" .. var_20_16

			var_20_7[#var_20_7 + 1] = {
				pass_type = "text",
				text_id = var_20_28,
				style_id = var_20_29,
				content_id = var_20_21
			}
			var_20_9[var_20_29] = {
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				font_size = 28,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				size = var_20_4,
				offset = {
					var_20_19[1] + 2,
					var_20_19[2] - 44 - 2,
					2
				}
			}
		end
	end

	var_20_6.element.passes = var_20_7
	var_20_6.content = var_20_8
	var_20_6.style = var_20_9
	var_20_6.offset = {
		0,
		0,
		0
	}
	var_20_6.scenegraph_id = arg_20_0

	return var_20_6
end

UIWidgets.create_grid = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, arg_28_6, arg_28_7, arg_28_8)
	local var_28_0 = {
		255,
		255,
		255,
		255
	}
	local var_28_1 = {
		255,
		255,
		255,
		255
	}
	local var_28_2 = Colors.get_color_table_with_alpha("dim_gray", 40)
	local var_28_3 = Colors.get_color_table_with_alpha("white", 150)
	local var_28_4 = {
		80,
		80
	}
	local var_28_5 = {
		80,
		80
	}

	arg_28_4 = arg_28_4 or 8
	arg_28_5 = arg_28_5 or 8

	local var_28_6 = {
		element = {}
	}
	local var_28_7 = {}
	local var_28_8 = {
		rows = arg_28_2,
		columns = arg_28_3,
		slots = arg_28_2 * arg_28_3,
		disable_mouse_tooltips = arg_28_8
	}
	local var_28_9 = {}

	if arg_28_6 then
		var_28_7[#var_28_7 + 1] = {
			style_id = "page_text",
			pass_type = "text",
			text_id = "page_text",
			content_check_function = function (arg_29_0)
				local var_29_0 = arg_29_0.page_hotspot_left
				local var_29_1 = arg_29_0.page_hotspot_right

				return not (var_29_0.disable_button and var_29_1.disable_button)
			end
		}
		var_28_7[#var_28_7 + 1] = {
			style_id = "page_arrow_left",
			pass_type = "hotspot",
			content_id = "page_hotspot_left"
		}
		var_28_7[#var_28_7 + 1] = {
			style_id = "page_arrow_right",
			pass_type = "hotspot",
			content_id = "page_hotspot_right"
		}
		var_28_7[#var_28_7 + 1] = {
			pass_type = "texture",
			style_id = "page_arrow_left",
			texture_id = "texture_id",
			content_id = "stepper_arrow_normal",
			content_check_function = function (arg_30_0)
				local var_30_0 = arg_30_0.parent.page_hotspot_left

				return not var_30_0.disable_button and not var_30_0.is_hover
			end
		}
		var_28_7[#var_28_7 + 1] = {
			style_id = "page_arrow_right",
			pass_type = "texture_uv",
			content_id = "stepper_arrow_normal",
			content_check_function = function (arg_31_0)
				local var_31_0 = arg_31_0.parent.page_hotspot_right

				return not var_31_0.disable_button and not var_31_0.is_hover
			end
		}
		var_28_7[#var_28_7 + 1] = {
			pass_type = "texture",
			style_id = "page_arrow_left",
			texture_id = "texture_id",
			content_id = "stepper_arrow_hover",
			content_check_function = function (arg_32_0)
				local var_32_0 = arg_32_0.parent.page_hotspot_left

				return not var_32_0.disable_button and var_32_0.is_hover
			end
		}
		var_28_7[#var_28_7 + 1] = {
			style_id = "page_arrow_right",
			pass_type = "texture_uv",
			content_id = "stepper_arrow_hover",
			content_check_function = function (arg_33_0)
				local var_33_0 = arg_33_0.parent.page_hotspot_right

				return not var_33_0.disable_button and var_33_0.is_hover
			end
		}
		var_28_8.page_hotspot_left = {}
		var_28_8.page_hotspot_right = {}
		var_28_8.page_text = "n/a"
		var_28_8.stepper_arrow_normal = {
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
		var_28_8.stepper_arrow_hover = {
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
		var_28_9.page_arrow_left = {
			color = var_28_0,
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
		var_28_9.page_arrow_right = {
			color = var_28_0,
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
		var_28_9.page_text = {
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

	local var_28_10 = arg_28_3 * var_28_5[1] + arg_28_4 * (arg_28_3 - 1)
	local var_28_11 = arg_28_1[1] - var_28_10
	local var_28_12 = arg_28_2 * var_28_5[2] + arg_28_5 * (arg_28_2 - 1)
	local var_28_13 = arg_28_1[2] - var_28_12
	local var_28_14 = {
		var_28_11 / 2,
		arg_28_1[2] - var_28_13 / 2 - var_28_5[2]
	}
	local var_28_15 = 3

	for iter_28_0 = 1, arg_28_2 do
		for iter_28_1 = 1, arg_28_3 do
			local var_28_16 = "_" .. tostring(iter_28_0) .. "_" .. tostring(iter_28_1)
			local var_28_17 = iter_28_0 - 1
			local var_28_18 = iter_28_1 - 1
			local var_28_19 = {
				var_28_14[1] + var_28_18 * (var_28_5[1] + arg_28_4),
				var_28_14[2] - var_28_17 * (var_28_5[2] + arg_28_5),
				var_28_15
			}
			local var_28_20 = "item" .. var_28_16
			local var_28_21 = "hotspot" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "hotspot",
				content_id = var_28_21,
				style_id = var_28_21
			}
			var_28_9[var_28_21] = {
				size = var_28_5,
				offset = var_28_19
			}
			var_28_8[var_28_21] = {
				drag_texture_size = var_28_5
			}

			local var_28_22 = "item_icon" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture",
				content_id = var_28_21,
				texture_id = var_28_22,
				style_id = var_28_22,
				content_check_function = function (arg_34_0)
					return arg_34_0[var_28_22]
				end
			}
			var_28_9[var_28_22] = {
				size = var_28_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_28_19[1],
					var_28_19[2],
					2
				}
			}

			local var_28_23 = "illusion_icon" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture",
				texture_id = var_28_23,
				style_id = var_28_23,
				content_check_function = function (arg_35_0)
					local var_35_0 = arg_35_0[var_28_20]

					if var_35_0 and var_35_0.skin then
						return var_35_0.data.item_type == "weapon_skin"
					end
				end
			}
			var_28_9[var_28_23] = {
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
					var_28_19[1],
					var_28_19[2],
					3
				}
			}
			var_28_8[var_28_23] = "item_frame_illusion"

			local var_28_24 = "favorite_icon" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture",
				texture_id = var_28_24,
				style_id = var_28_24,
				content_check_function = function (arg_36_0)
					local var_36_0 = arg_36_0[var_28_20]
					local var_36_1 = var_36_0 and var_36_0.backend_id

					if var_36_1 then
						return ItemHelper.is_favorite_backend_id(var_36_1, var_36_0)
					end
				end
			}
			var_28_9[var_28_24] = {
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
					var_28_19[1] + 8,
					var_28_19[2] + var_28_4[2] - 30,
					3
				}
			}
			var_28_8[var_28_24] = "item_favorite_icon"

			local var_28_25 = "skin_icon" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture",
				texture_id = var_28_25,
				style_id = var_28_25,
				content_check_function = function (arg_37_0)
					local var_37_0 = arg_37_0[var_28_20]
					local var_37_1 = var_37_0 and var_37_0.skin

					if var_37_1 then
						local var_37_2 = var_37_0.ItemId or var_37_0.item_id
						local var_37_3 = var_37_2 and string.gsub(var_37_2, "^vs_", "")

						return var_37_0.data.item_type ~= "weapon_skin" and WeaponSkins.default_skins[var_37_3] ~= var_37_1
					end
				end
			}
			var_28_9[var_28_25] = {
				size = {
					20,
					20
				},
				color = Colors.get_color_table_with_alpha("promo", 255),
				offset = {
					var_28_19[1] + var_28_4[1] - 28,
					var_28_19[2] + 8,
					3
				}
			}
			var_28_8[var_28_25] = "item_applied_illusion_icon"

			local var_28_26 = "equipped_other_career_icon" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture",
				texture_id = var_28_26,
				style_id = var_28_26,
				content_check_function = function (arg_38_0)
					local var_38_0 = arg_38_0[var_28_20]

					if var_38_0 then
						local var_38_1 = var_38_0.data
						local var_38_2

						if CosmeticUtils.is_cosmetic_item(var_38_1.slot_type) then
							var_38_2 = var_38_0.ItemId
						else
							var_38_2 = var_38_0.backend_id
						end

						if var_38_2 then
							local var_38_3 = Managers.player:local_player()

							if not var_38_3 then
								return false
							end

							local var_38_4 = var_38_3:career_index()
							local var_38_5 = var_38_3:profile_index()
							local var_38_6 = SPProfiles[var_38_5].careers[var_38_4].name
							local var_38_7 = Managers.backend:get_interface("items"):equipped_by(var_38_2)

							if #var_38_7 == 1 and table.contains(var_38_7, var_38_6) then
								return false
							end

							return #var_38_7 ~= 0
						end
					end
				end
			}
			var_28_9[var_28_26] = {
				size = {
					20,
					20
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_28_19[1] + 8,
					var_28_19[2] + 8,
					3
				}
			}
			var_28_8[var_28_26] = "equip_multiple_careers_stroke"

			local var_28_27 = "remove_marked_deed" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture",
				texture_id = var_28_27,
				style_id = var_28_27,
				content_check_function = function (arg_39_0)
					local var_39_0 = arg_39_0[var_28_20]

					return var_39_0 and var_39_0.marked_for_deletion
				end
			}
			var_28_9[var_28_27] = {
				size = {
					30,
					60
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_28_19[1] + (var_28_4[1] / 2 - 15),
					var_28_19[2] + 10,
					5
				}
			}
			var_28_8[var_28_27] = "salvage_item_icon"

			local var_28_28 = "item_frame" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture",
				content_id = var_28_21,
				texture_id = var_28_28,
				style_id = var_28_28,
				content_check_function = function (arg_40_0)
					return arg_40_0[var_28_22]
				end
			}
			var_28_9[var_28_28] = {
				size = var_28_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_28_19[1],
					var_28_19[2],
					5
				}
			}
			var_28_8[var_28_21][var_28_28] = "item_frame"

			local var_28_29 = "rarity_texture" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture",
				texture_id = var_28_29,
				style_id = var_28_29,
				content_check_function = function (arg_41_0)
					return arg_41_0[var_28_21][var_28_22] and arg_41_0[var_28_20]
				end
			}
			var_28_9[var_28_29] = {
				size = var_28_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_28_19[1],
					var_28_19[2],
					0
				}
			}
			var_28_8[var_28_29] = "icon_bg_default"

			local var_28_30 = "item_tooltip" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "item_tooltip",
				text_id = var_28_30,
				style_id = var_28_30,
				item_id = "item" .. var_28_16,
				content_check_function = function (arg_42_0)
					return arg_42_0[var_28_21].is_hover and arg_42_0[var_28_20] and not arg_42_0.disable_mouse_tooltips
				end
			}
			var_28_9[var_28_30] = {
				font_type = "hell_shark",
				localize = true,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				max_width = 500,
				size = var_28_5,
				offset = var_28_19,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("white", 255)
				},
				offset = var_28_19
			}
			var_28_8[var_28_30] = "tooltip_text"

			local var_28_31 = "slot" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture",
				content_id = var_28_21,
				texture_id = var_28_31,
				style_id = var_28_31,
				content_check_function = function (arg_43_0)
					return not arg_43_0[var_28_22] and not arg_43_0.hide_slot
				end
			}
			var_28_9[var_28_31] = {
				size = var_28_5,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_28_19[1],
					var_28_19[2],
					0
				}
			}
			var_28_8[var_28_21][var_28_31] = "menu_slot_frame_01"

			local var_28_32 = "slot_hover" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture",
				content_id = var_28_21,
				texture_id = var_28_32,
				style_id = var_28_32,
				content_check_function = function (arg_44_0)
					return arg_44_0.highlight or arg_44_0.is_hover or arg_44_0.is_selected
				end
			}
			var_28_9[var_28_32] = {
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
					var_28_19[1] - (128 - var_28_5[1]) / 2,
					var_28_19[2] - (128 - var_28_5[2]) / 2,
					0
				}
			}
			var_28_8[var_28_21][var_28_32] = "item_icon_hover"

			local var_28_33 = "slot_equipped" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture",
				content_id = var_28_21,
				texture_id = var_28_33,
				style_id = var_28_33,
				content_check_function = function (arg_45_0)
					return arg_45_0.equipped
				end
			}
			var_28_9[var_28_33] = {
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
					var_28_19[1] - (80 - var_28_5[1]) / 2,
					var_28_19[2] - (80 - var_28_5[2]) / 2,
					7
				}
			}
			var_28_8[var_28_21][var_28_33] = "item_icon_selection"

			local var_28_34 = "amount_text" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "text",
				text_id = var_28_34,
				style_id = var_28_34,
				content_id = var_28_21,
				content_check_function = function (arg_46_0)
					return arg_46_0[var_28_22]
				end
			}
			var_28_9[var_28_34] = {
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				font_size = 32,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 255),
				size = var_28_4,
				offset = {
					var_28_19[1] - 7,
					var_28_19[2] - 1,
					4
				}
			}
			var_28_8[var_28_21][var_28_34] = ""

			local var_28_35 = "amount_text_shadow" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "text",
				text_id = var_28_34,
				style_id = var_28_35,
				content_id = var_28_21,
				content_check_function = function (arg_47_0)
					return arg_47_0[var_28_22]
				end
			}
			var_28_9[var_28_35] = {
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				font_size = 32,
				horizontal_alignment = "right",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				size = var_28_4,
				offset = {
					var_28_19[1] - 7 + 2,
					var_28_19[2] - 1 - 2,
					3
				}
			}

			local var_28_36 = "disabled_rect" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "rect",
				content_id = var_28_21,
				style_id = var_28_36,
				content_check_function = function (arg_48_0)
					return arg_48_0[var_28_22] and (arg_48_0.reserved or arg_48_0.unwieldable)
				end
			}
			var_28_9[var_28_36] = {
				size = var_28_4,
				color = {
					210,
					10,
					10,
					10
				},
				offset = {
					var_28_19[1],
					var_28_19[2],
					4
				}
			}

			local var_28_37 = "unwieldable_icon" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture",
				texture_id = var_28_37,
				content_id = var_28_21,
				style_id = var_28_37,
				content_check_function = function (arg_49_0)
					return arg_49_0[var_28_22] and arg_49_0.unwieldable
				end
			}
			var_28_9[var_28_37] = {
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
					var_28_19[1] + var_28_4[1] / 2 - 20,
					var_28_19[2] + var_28_4[2] / 2 - 20,
					5
				}
			}
			var_28_8[var_28_21][var_28_37] = "tab_menu_icon_03"

			local var_28_38 = "locked_icon" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture",
				texture_id = var_28_38,
				content_id = var_28_21,
				style_id = var_28_38,
				content_check_function = function (arg_50_0)
					return arg_50_0.reserved and arg_50_0[var_28_38]
				end
			}
			var_28_9[var_28_38] = {
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
					var_28_19[1] + var_28_4[1] / 2 - 15,
					var_28_19[2] + var_28_4[2] / 2 - 30,
					5
				}
			}
			var_28_8[var_28_21][var_28_38] = nil
			var_28_7[#var_28_7 + 1] = {
				pass_type = "drag",
				content_id = var_28_21,
				texture_id = var_28_22,
				style_id = var_28_22,
				content_check_function = function (arg_51_0)
					return arg_51_0[var_28_22]
				end
			}

			local var_28_39 = UIFrameSettings.frame_outer_glow_01
			local var_28_40 = var_28_39.texture_sizes.corner[1]
			local var_28_41 = "new_icon" .. var_28_16

			var_28_7[#var_28_7 + 1] = {
				pass_type = "texture_frame",
				texture_id = var_28_41,
				style_id = var_28_41,
				content_check_function = function (arg_52_0)
					local var_52_0 = arg_52_0["item" .. var_28_16]

					return arg_52_0[var_28_41] and var_52_0 and ItemHelper.is_new_backend_id(var_52_0.backend_id)
				end,
				content_change_function = function (arg_53_0, arg_53_1)
					local var_53_0 = arg_53_0["item" .. var_28_16]
					local var_53_1 = var_53_0 and var_53_0.backend_id

					if var_53_0 and ItemHelper.is_new_backend_id(var_53_1) then
						local var_53_2 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

						arg_53_1.color[1] = 55 + var_53_2 * 200

						local var_53_3 = arg_53_0[var_28_21]

						if (var_53_3.on_hover_enter or var_53_3.is_selected) and ItemHelper.is_new_backend_id(var_53_1) then
							ItemHelper.unmark_backend_id_as_new(var_53_1)
						end
					end
				end
			}
			var_28_9[var_28_41] = {
				size = {
					var_28_4[1] + var_28_40 * 2,
					var_28_4[2] + var_28_40 * 2
				},
				color = var_28_0,
				texture_size = var_28_39.texture_size,
				texture_sizes = var_28_39.texture_sizes,
				offset = {
					var_28_19[1] - var_28_40,
					var_28_19[2] - var_28_40,
					10
				}
			}
			var_28_8[var_28_41] = var_28_39.texture
		end
	end

	var_28_6.element.passes = var_28_7
	var_28_6.content = var_28_8
	var_28_6.style = var_28_9
	var_28_6.offset = arg_28_7 and {
		arg_28_7[1] or 0,
		arg_28_7[2] or 0,
		arg_28_7[3] or 0
	} or {
		0,
		0,
		0
	}
	var_28_6.scenegraph_id = arg_28_0

	return var_28_6
end

UIWidgets.create_simple_inventory_item = function (arg_54_0, arg_54_1)
	local var_54_0 = {
		element = {}
	}
	local var_54_1 = {}
	local var_54_2 = {}
	local var_54_3 = {}
	local var_54_4 = "button_hotspot"

	var_54_1[#var_54_1 + 1] = {
		pass_type = "hotspot",
		content_id = var_54_4,
		style_id = var_54_4
	}
	var_54_3[var_54_4] = {
		size = arg_54_1,
		offset = {
			0,
			0,
			0
		}
	}
	var_54_2[var_54_4] = {
		is_selected = false,
		drag_texture_size = arg_54_1
	}

	local var_54_5 = "item_icon"

	var_54_1[#var_54_1 + 1] = {
		pass_type = "texture",
		texture_id = var_54_5,
		style_id = var_54_5,
		content_check_function = function (arg_55_0)
			return arg_55_0[var_54_5]
		end
	}
	var_54_3[var_54_5] = {
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

	local var_54_6 = "item_frame"

	var_54_1[#var_54_1 + 1] = {
		pass_type = "texture",
		texture_id = var_54_6,
		style_id = var_54_6,
		content_check_function = function (arg_56_0)
			return arg_56_0[var_54_5]
		end
	}
	var_54_3[var_54_6] = {
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
			4
		}
	}
	var_54_2[var_54_6] = "item_frame"

	local var_54_7 = "rarity_texture"

	var_54_1[#var_54_1 + 1] = {
		pass_type = "texture",
		texture_id = var_54_7,
		style_id = var_54_7,
		content_check_function = function (arg_57_0)
			return arg_57_0[var_54_5]
		end
	}
	var_54_3[var_54_7] = {
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
	var_54_2[var_54_7] = "icon_bg_default"

	local var_54_8 = "item_tooltip"

	var_54_1[#var_54_1 + 1] = {
		item_id = "item",
		pass_type = "item_tooltip",
		text_id = var_54_8,
		style_id = var_54_8,
		content_check_function = function (arg_58_0)
			return arg_58_0[var_54_4].is_hover and arg_58_0[var_54_5]
		end
	}
	var_54_3[var_54_8] = {
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
	var_54_2[var_54_8] = "tooltip_text"
	var_54_0.element.passes = var_54_1
	var_54_0.content = var_54_2
	var_54_0.style = var_54_3
	var_54_0.offset = {
		0,
		0,
		0
	}
	var_54_0.scenegraph_id = arg_54_0

	return var_54_0
end

UIWidgets.create_loadout_grid = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	local var_59_0 = {
		255,
		255,
		255,
		255
	}
	local var_59_1 = {
		255,
		255,
		255,
		255
	}
	local var_59_2 = Colors.get_color_table_with_alpha("dim_gray", 40)
	local var_59_3 = Colors.get_color_table_with_alpha("white", 150)
	local var_59_4 = {
		80,
		80
	}
	local var_59_5 = {
		80,
		80
	}
	local var_59_6 = 1

	if arg_59_4 then
		var_59_6 = arg_59_2
		arg_59_2 = 1
	end

	local var_59_7 = arg_59_3 or 30
	local var_59_8 = arg_59_3 or 30
	local var_59_9 = arg_59_1[1]
	local var_59_10 = arg_59_1[2]
	local var_59_11 = {
		element = {}
	}
	local var_59_12 = {}
	local var_59_13 = {}
	local var_59_14 = {
		rows = arg_59_2,
		columns = var_59_6,
		slots = arg_59_2 * var_59_6
	}
	local var_59_15 = var_59_9 - (var_59_6 * var_59_5[1] + var_59_7 * (var_59_6 - 1))
	local var_59_16 = var_59_10 - (arg_59_2 * var_59_5[2] + var_59_8 * (arg_59_2 - 1))
	local var_59_17 = {
		arg_59_4 and var_59_15 / 2 or var_59_15 / 2,
		var_59_10 - var_59_16 / 2 - var_59_5[2]
	}
	local var_59_18 = 0

	for iter_59_0 = 1, arg_59_2 do
		for iter_59_1 = 1, var_59_6 do
			local var_59_19 = "_" .. tostring(iter_59_0) .. "_" .. tostring(iter_59_1)
			local var_59_20 = iter_59_0 - 1
			local var_59_21 = iter_59_1 - 1
			local var_59_22 = {
				var_59_17[1] + var_59_21 * (var_59_5[1] + var_59_7),
				var_59_17[2] - var_59_20 * (var_59_5[2] + var_59_8),
				var_59_18
			}
			local var_59_23 = "hotspot" .. var_59_19

			var_59_12[#var_59_12 + 1] = {
				pass_type = "hotspot",
				content_id = var_59_23,
				style_id = var_59_23
			}
			var_59_13[var_59_23] = {
				size = var_59_5,
				offset = var_59_22
			}
			var_59_14[var_59_23] = {
				drag_texture_size = var_59_5
			}

			local var_59_24 = "item_icon" .. var_59_19

			var_59_12[#var_59_12 + 1] = {
				pass_type = "texture",
				content_id = var_59_23,
				texture_id = var_59_24,
				style_id = var_59_24,
				content_check_function = function (arg_60_0)
					return arg_60_0[var_59_24]
				end
			}
			var_59_13[var_59_24] = {
				size = var_59_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_59_22[1],
					var_59_22[2],
					3
				}
			}

			local var_59_25 = "item_frame" .. var_59_19

			var_59_12[#var_59_12 + 1] = {
				pass_type = "texture",
				content_id = var_59_23,
				texture_id = var_59_25,
				style_id = var_59_25,
				content_check_function = function (arg_61_0)
					return arg_61_0[var_59_24]
				end
			}
			var_59_13[var_59_25] = {
				size = var_59_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_59_22[1],
					var_59_22[2],
					4
				}
			}
			var_59_14[var_59_23][var_59_25] = "item_frame"

			local var_59_26 = "rarity_texture" .. var_59_19

			var_59_12[#var_59_12 + 1] = {
				pass_type = "texture",
				texture_id = var_59_26,
				style_id = var_59_26,
				content_check_function = function (arg_62_0)
					return arg_62_0[var_59_23][var_59_24]
				end
			}
			var_59_13[var_59_26] = {
				size = var_59_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_59_22[1],
					var_59_22[2],
					0
				}
			}
			var_59_14[var_59_26] = "icon_bg_default"

			local var_59_27 = "item_tooltip" .. var_59_19

			var_59_12[#var_59_12 + 1] = {
				pass_type = "item_tooltip",
				text_id = var_59_27,
				style_id = var_59_27,
				item_id = "item" .. var_59_19,
				content_check_function = function (arg_63_0)
					return arg_63_0[var_59_23].is_hover and arg_63_0[var_59_23][var_59_24]
				end
			}
			var_59_13[var_59_27] = {
				font_type = "hell_shark",
				localize = true,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				max_width = 500,
				size = var_59_5,
				offset = var_59_22,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("white", 255)
				},
				offset = var_59_22
			}
			var_59_14[var_59_27] = "tooltip_text"

			local var_59_28 = "slot" .. var_59_19

			var_59_12[#var_59_12 + 1] = {
				pass_type = "texture",
				content_id = var_59_23,
				texture_id = var_59_28,
				style_id = var_59_28,
				content_check_function = function (arg_64_0)
					return not arg_64_0[var_59_24]
				end
			}
			var_59_13[var_59_28] = {
				size = var_59_5,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_59_22[1],
					var_59_22[2],
					0
				}
			}
			var_59_14[var_59_23][var_59_28] = "menu_slot_frame_01"

			local var_59_29 = "slot_icon" .. var_59_19

			var_59_12[#var_59_12 + 1] = {
				pass_type = "texture",
				texture_id = var_59_29,
				style_id = var_59_29,
				content_check_function = function (arg_65_0)
					return not arg_65_0[var_59_23][var_59_24]
				end
			}
			var_59_13[var_59_29] = {
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
					var_59_22[1] + (var_59_5[1] - 34) / 2,
					var_59_22[2] + (var_59_5[2] - 34) - (var_59_5[1] - 34) / 2,
					2
				}
			}
			var_59_14[var_59_29] = "tabs_icon_all_selected"

			local var_59_30 = "slot_hover" .. var_59_19

			var_59_12[#var_59_12 + 1] = {
				pass_type = "texture",
				content_id = var_59_23,
				texture_id = var_59_30,
				style_id = var_59_30,
				content_check_function = function (arg_66_0)
					return arg_66_0.highlight or arg_66_0.is_hover
				end
			}
			var_59_13[var_59_30] = {
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
					var_59_22[1] - (128 - var_59_5[1]) / 2,
					var_59_22[2] - (128 - var_59_5[2]) / 2,
					0
				}
			}
			var_59_14[var_59_23][var_59_30] = "item_icon_hover"

			local var_59_31 = "slot_selected" .. var_59_19

			var_59_12[#var_59_12 + 1] = {
				pass_type = "texture",
				content_id = var_59_23,
				texture_id = var_59_31,
				style_id = var_59_31,
				content_check_function = function (arg_67_0)
					return arg_67_0.is_selected
				end
			}
			var_59_13[var_59_31] = {
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
					var_59_22[1] - (80 - var_59_5[1]) / 2,
					var_59_22[2] - (80 - var_59_5[2]) / 2,
					8
				}
			}
			var_59_14[var_59_23][var_59_31] = "item_icon_selection"
		end
	end

	var_59_11.element.passes = var_59_12
	var_59_11.content = var_59_14
	var_59_11.style = var_59_13
	var_59_11.offset = {
		0,
		0,
		0
	}
	var_59_11.scenegraph_id = arg_59_0

	return var_59_11
end

UIWidgets.create_loadout_grid_console = function (arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4, arg_68_5)
	local var_68_0 = {
		255,
		255,
		255,
		255
	}
	local var_68_1 = {
		255,
		255,
		255,
		255
	}
	local var_68_2 = Colors.get_color_table_with_alpha("dim_gray", 40)
	local var_68_3 = Colors.get_color_table_with_alpha("white", 150)
	local var_68_4 = {
		80,
		80
	}
	local var_68_5 = {
		80,
		80
	}
	local var_68_6 = 1

	if arg_68_4 then
		var_68_6 = arg_68_2
		arg_68_2 = 1
	end

	local var_68_7 = arg_68_3 or 30
	local var_68_8 = arg_68_3 or 30
	local var_68_9 = arg_68_1[1]
	local var_68_10 = arg_68_1[2]
	local var_68_11 = {
		element = {}
	}
	local var_68_12 = {}
	local var_68_13 = {}
	local var_68_14 = {
		rows = arg_68_2,
		columns = var_68_6,
		slots = arg_68_2 * var_68_6
	}
	local var_68_15 = var_68_9 - (var_68_6 * var_68_5[1] + var_68_7 * (var_68_6 - 1))
	local var_68_16 = var_68_10 - (arg_68_2 * var_68_5[2] + var_68_8 * (arg_68_2 - 1))
	local var_68_17 = {
		arg_68_4 and var_68_15 / 2 or var_68_15 / 2,
		var_68_10 - var_68_16 / 2 - var_68_5[2]
	}
	local var_68_18 = 0

	for iter_68_0 = 1, arg_68_2 do
		for iter_68_1 = 1, var_68_6 do
			local var_68_19 = "_" .. tostring(iter_68_0) .. "_" .. tostring(iter_68_1)
			local var_68_20 = iter_68_0 - 1
			local var_68_21 = iter_68_1 - 1
			local var_68_22 = {
				var_68_17[1] + var_68_21 * (var_68_5[1] + var_68_7),
				var_68_17[2] - var_68_20 * (var_68_5[2] + var_68_8),
				var_68_18
			}
			local var_68_23 = "hotspot" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "hotspot",
				content_id = var_68_23,
				style_id = var_68_23
			}
			var_68_13[var_68_23] = {
				size = {
					var_68_5[1] + 414,
					var_68_5[2] + 40
				},
				offset = {
					var_68_22[1] - 20,
					var_68_22[2] - 20
				}
			}
			var_68_14[var_68_23] = {
				drag_texture_size = var_68_5
			}

			if arg_68_5 then
				local var_68_24 = {
					58,
					58
				}
				local var_68_25 = "customize_hotspot" .. var_68_19

				var_68_12[#var_68_12 + 1] = {
					pass_type = "hotspot",
					content_id = var_68_25,
					style_id = var_68_25,
					content_check_function = function (arg_69_0)
						local var_69_0 = Managers.mechanism:current_mechanism_name()
						local var_69_1 = InventorySettings.customize_default_slot_types_allowed[var_69_0] or InventorySettings.customize_default_slot_types_allowed.default
						local var_69_2 = "item" .. var_68_19
						local var_69_3 = arg_69_0.parent
						local var_69_4 = var_69_3[var_69_2]

						if not var_69_4 then
							var_69_3[var_69_2 .. "_disabled"] = true

							return false
						end

						local var_69_5 = var_69_4.data
						local var_69_6 = var_69_5.slot_type
						local var_69_7 = var_69_4.rarity or var_69_5.rarity or "default"

						if (var_69_7 == "default" or var_69_7 == "promo") and not var_69_1[var_69_6] then
							var_69_3[var_69_2 .. "_disabled"] = true

							return false
						end

						return true
					end
				}
				var_68_13[var_68_25] = {
					vertical_alignment = "center",
					horizontal_alignment = "left",
					color = {
						255,
						96,
						96,
						96
					},
					size = var_68_24,
					texture_size = var_68_24,
					offset = {
						var_68_22[1] - var_68_24[1] - 25,
						var_68_22[2] + var_68_5[2] * 0.5 - var_68_24[2] * 0.5,
						30
					}
				}
				var_68_14[var_68_25] = {
					drag_texture_size = var_68_5
				}

				local var_68_26 = "customize_item" .. var_68_19

				var_68_12[#var_68_12 + 1] = {
					pass_type = "texture",
					texture_id = "customize_id",
					style_id = var_68_25,
					content_check_function = function (arg_70_0)
						if arg_70_0["item" .. var_68_19 .. "_disabled"] then
							return false
						end

						return not arg_70_0[var_68_25].is_hover
					end
				}
				var_68_14.customize_id = "cog_icon"

				local var_68_27 = "customize_item_hover" .. var_68_19

				var_68_12[#var_68_12 + 1] = {
					pass_type = "texture",
					texture_id = "customize_hover_id",
					style_id = var_68_27,
					content_check_function = function (arg_71_0)
						if arg_71_0["item" .. var_68_19 .. "_disabled"] then
							return false
						end

						if arg_71_0.is_gamepad_active then
							return arg_71_0["hotspot" .. var_68_19].is_selected
						else
							return arg_71_0[var_68_25].is_hover
						end
					end
				}
				var_68_14.customize_hover_id = "cog_icon_selected"
				var_68_13[var_68_27] = {
					vertical_alignment = "center",
					horizontal_alignment = "left",
					color = {
						255,
						255,
						255,
						255
					},
					size = var_68_24,
					texture_size = var_68_24,
					offset = {
						var_68_22[1] - var_68_24[1] - 25,
						var_68_22[2] + var_68_5[2] * 0.5 - var_68_24[2] * 0.5,
						30
					}
				}
			end

			local var_68_28 = "tooltip_hotspot" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "hotspot",
				content_id = var_68_28,
				style_id = var_68_28
			}
			var_68_13[var_68_28] = {
				size = var_68_5,
				offset = var_68_22
			}
			var_68_14[var_68_28] = {
				drag_texture_size = var_68_5
			}

			local var_68_29 = "item_icon" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "texture",
				content_id = var_68_23,
				texture_id = var_68_29,
				style_id = var_68_29,
				content_check_function = function (arg_72_0)
					return arg_72_0[var_68_29]
				end
			}
			var_68_13[var_68_29] = {
				size = var_68_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_68_22[1],
					var_68_22[2],
					3
				}
			}

			local var_68_30 = "item_frame" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "texture",
				content_id = var_68_23,
				texture_id = var_68_30,
				style_id = var_68_30,
				content_check_function = function (arg_73_0)
					return arg_73_0[var_68_29]
				end
			}
			var_68_13[var_68_30] = {
				size = var_68_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_68_22[1],
					var_68_22[2],
					4
				}
			}
			var_68_14[var_68_23][var_68_30] = "item_frame"

			local var_68_31 = "rarity_texture" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "texture",
				texture_id = var_68_31,
				style_id = var_68_31,
				content_check_function = function (arg_74_0)
					return arg_74_0[var_68_23][var_68_29]
				end
			}
			var_68_13[var_68_31] = {
				size = var_68_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_68_22[1],
					var_68_22[2],
					0
				}
			}
			var_68_14[var_68_31] = "icon_bg_default"

			local var_68_32 = "item" .. var_68_19
			local var_68_33 = "item_tooltip" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "item_tooltip",
				text_id = var_68_33,
				style_id = var_68_33,
				item_id = var_68_32,
				content_check_function = function (arg_75_0)
					return arg_75_0[var_68_28].is_hover and arg_75_0[var_68_23][var_68_29]
				end
			}
			var_68_13[var_68_33] = {
				font_type = "hell_shark",
				localize = true,
				font_size = 18,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				max_width = 500,
				size = var_68_5,
				offset = var_68_22,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("white", 255)
				},
				offset = var_68_22
			}
			var_68_14[var_68_33] = "tooltip_text"

			local var_68_34 = "slot" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "texture",
				content_id = var_68_23,
				texture_id = var_68_34,
				style_id = var_68_34
			}
			var_68_13[var_68_34] = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = var_68_5,
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
					var_68_22[1],
					var_68_22[2],
					-2
				}
			}
			var_68_14[var_68_23][var_68_34] = "loadout_item_slot_console"

			local var_68_35 = "title_bg" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "texture_uv",
				content_id = var_68_35,
				style_id = var_68_35
			}
			var_68_13[var_68_35] = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = var_68_5,
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
					var_68_22[1] + var_68_5[1] / 2,
					var_68_22[2],
					-5
				}
			}
			var_68_14[var_68_35] = {
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

			local var_68_36 = "title_bg_effect" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "texture",
				texture_id = var_68_36,
				style_id = var_68_36,
				content_check_function = function (arg_76_0)
					local var_76_0 = arg_76_0[var_68_23]

					return var_76_0.highlight or var_76_0.is_hover
				end
			}
			var_68_13[var_68_36] = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				size = var_68_5,
				texture_size = {
					414,
					126
				},
				color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_68_22[1] + var_68_5[1] / 2,
					var_68_22[2],
					-4
				}
			}
			var_68_14[var_68_36] = "item_slot_side_effect"

			local var_68_37 = "title_text" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "text",
				text_id = var_68_37,
				style_id = var_68_37,
				content_check_function = function (arg_77_0)
					local var_77_0 = arg_77_0[var_68_23]

					return arg_77_0[var_68_32] and not var_77_0.highlight and not var_77_0.is_hover
				end,
				content_change_function = function (arg_78_0, arg_78_1)
					local var_78_0 = arg_78_0[var_68_32].data.item_type

					arg_78_0[var_68_37] = var_78_0
				end
			}
			var_68_13[var_68_37] = {
				font_size = 32,
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				size = var_68_5,
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_68_22[1] + 130,
					var_68_22[2] - 6,
					5
				}
			}
			var_68_14[var_68_37] = Localize("not_assigned")

			local var_68_38 = "title_text_selected" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "text",
				text_id = var_68_37,
				style_id = var_68_38,
				content_check_function = function (arg_79_0)
					local var_79_0 = arg_79_0[var_68_23]

					return arg_79_0[var_68_32] and (var_79_0.highlight or var_79_0.is_hover)
				end,
				content_change_function = function (arg_80_0, arg_80_1)
					local var_80_0 = arg_80_0[var_68_32].data.item_type

					arg_80_0[var_68_37] = var_80_0
				end
			}
			var_68_13[var_68_38] = {
				font_size = 32,
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				size = var_68_5,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_68_22[1] + 130,
					var_68_22[2] - 6,
					5
				}
			}

			local var_68_39 = "title_shadow_text" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "text",
				text_id = var_68_37,
				style_id = var_68_39,
				content_check_function = function (arg_81_0)
					return arg_81_0[var_68_32]
				end
			}
			var_68_13[var_68_39] = {
				font_size = 32,
				upper_case = true,
				localize = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				size = var_68_5,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_68_22[1] + 130 + 2,
					var_68_22[2] - 8,
					4
				}
			}

			local var_68_40 = "sub_title_text" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "text",
				text_id = var_68_40,
				style_id = var_68_40,
				content_check_function = function (arg_82_0)
					return arg_82_0[var_68_32]
				end,
				content_change_function = function (arg_83_0, arg_83_1)
					local var_83_0 = arg_83_0[var_68_32]
					local var_83_1, var_83_2 = UIUtils.get_ui_information_from_item(var_83_0)

					arg_83_0[var_68_40] = var_83_2
				end
			}
			var_68_13[var_68_40] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				localize = true,
				font_size = 22,
				font_type = "hell_shark",
				size = var_68_5,
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					var_68_22[1] + 130,
					var_68_22[2] - 46,
					5
				}
			}
			var_68_14[var_68_23][var_68_40] = Localize("not_assigned")

			local var_68_41 = "sub_title_shadow_text" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "text",
				text_id = var_68_40,
				style_id = var_68_41,
				content_check_function = function (arg_84_0)
					return arg_84_0[var_68_32]
				end
			}
			var_68_13[var_68_41] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				localize = true,
				font_size = 22,
				font_type = "hell_shark",
				size = var_68_5,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_68_22[1] + 130 + 2,
					var_68_22[2] - 48,
					4
				}
			}

			local var_68_42 = "slot_icon" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "texture",
				texture_id = var_68_42,
				style_id = var_68_42,
				content_check_function = function (arg_85_0)
					return not arg_85_0[var_68_23][var_68_29]
				end
			}
			var_68_13[var_68_42] = {
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
					var_68_22[1] + (var_68_5[1] - 34) / 2,
					var_68_22[2] + (var_68_5[2] - 34) - (var_68_5[1] - 34) / 2,
					2
				}
			}
			var_68_14[var_68_42] = "tabs_icon_all_selected"

			local var_68_43 = "slot_hover" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "texture",
				content_id = var_68_23,
				texture_id = var_68_43,
				style_id = var_68_43,
				content_check_function = function (arg_86_0)
					return arg_86_0.highlight or arg_86_0.is_hover
				end
			}
			var_68_13[var_68_43] = {
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
					var_68_22[1] - (185 - var_68_5[1]) / 2,
					var_68_22[2] - (182 - var_68_5[2]) / 2,
					4
				}
			}
			var_68_14[var_68_23][var_68_43] = "loadout_item_slot_glow_console"

			local var_68_44 = "slot_selected" .. var_68_19

			var_68_12[#var_68_12 + 1] = {
				pass_type = "texture",
				content_id = var_68_23,
				texture_id = var_68_44,
				style_id = var_68_44,
				content_check_function = function (arg_87_0)
					return arg_87_0.is_selected
				end
			}
			var_68_13[var_68_44] = {
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
					var_68_22[1] - (80 - var_68_5[1]) / 2,
					var_68_22[2] - (80 - var_68_5[2]) / 2,
					8
				}
			}
			var_68_14[var_68_23][var_68_44] = "item_icon_selection"
		end
	end

	var_68_11.element.passes = var_68_12
	var_68_11.content = var_68_14
	var_68_11.style = var_68_13
	var_68_11.offset = {
		0,
		0,
		0
	}
	var_68_11.scenegraph_id = arg_68_0

	return var_68_11
end

UIWidgets.create_inventory_statistics = function (arg_88_0, arg_88_1, arg_88_2)
	local var_88_0 = Colors.get_color_table_with_alpha("black", 220)
	local var_88_1 = Colors.get_color_table_with_alpha("gray", 50)

	arg_88_2 = arg_88_2 or "menu_frame_bg_01"

	local var_88_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_88_2)
	local var_88_3 = UIFrameSettings.menu_frame_02
	local var_88_4 = {
		element = {}
	}
	local var_88_5 = {
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
	local var_88_6 = {
		value_title_text = "n/a",
		value_text = "n/a",
		divider = "summary_screen_line_breaker",
		frame = var_88_3.texture,
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					arg_88_1[1] / var_88_2.size[1],
					arg_88_1[2] / var_88_2.size[2]
				}
			},
			texture_id = arg_88_2
		},
		title_text = Localize("lorebook_statistics")
	}
	local var_88_7 = {
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
			texture_size = var_88_3.texture_size,
			texture_sizes = var_88_3.texture_sizes,
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
			color = var_88_1,
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

	var_88_4.element.passes = var_88_5
	var_88_4.content = var_88_6
	var_88_4.style = var_88_7
	var_88_4.offset = {
		0,
		0,
		0
	}
	var_88_4.scenegraph_id = arg_88_0

	return var_88_4
end

UIWidgets.create_weapon_statistics = function (arg_89_0, arg_89_1)
	local var_89_0 = Colors.get_color_table_with_alpha("font_default", 255)
	local var_89_1 = Colors.get_color_table_with_alpha("font_title", 255)
	local var_89_2 = {
		element = {}
	}
	local var_89_3 = {
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
	local var_89_4 = {
		title_text_left = "n/a",
		title_text = "n/a",
		divider_right = "journal_marker_left",
		title_text_right = "n/a",
		divider_left = "journal_marker_right"
	}
	local var_89_5 = {
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
			text_color = var_89_1,
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
			text_color = var_89_1,
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
			text_color = var_89_1,
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

	for iter_89_0 = 1, 5 do
		local var_89_6 = arg_89_1[2] - 20 * iter_89_0 - 50
		local var_89_7 = {
			2,
			0
		}
		local var_89_8 = {
			20,
			20
		}
		local var_89_9 = "value_title_text_" .. iter_89_0

		var_89_3[#var_89_3 + 1] = {
			pass_type = "text",
			style_id = var_89_9,
			text_id = var_89_9,
			content_check_function = function (arg_90_0)
				return arg_90_0[var_89_9]
			end
		}
		var_89_5[var_89_9] = {
			vertical_alignment = "center",
			word_wrap = true,
			horizontal_alignment = "center",
			font_size = 18,
			font_type = "hell_shark",
			text_color = var_89_0,
			offset = {
				0,
				var_89_6,
				0
			},
			size = {
				arg_89_1[1],
				20
			}
		}

		local var_89_10 = "stars_left_bg_" .. iter_89_0

		var_89_3[#var_89_3 + 1] = {
			pass_type = "multi_texture",
			style_id = var_89_10,
			texture_id = var_89_10,
			content_check_function = function (arg_91_0)
				return arg_91_0[var_89_9]
			end
		}
		var_89_5[var_89_10] = {
			direction = 1,
			axis = 1,
			draw_count = 5,
			texture_size = var_89_8,
			spacing = var_89_7,
			color = {
				255,
				50,
				50,
				50
			},
			offset = {
				5,
				var_89_6,
				3
			}
		}
		var_89_4[var_89_10] = {
			"stats_star",
			"stats_star",
			"stats_star",
			"stats_star",
			"stats_star"
		}

		local var_89_11 = "stars_left_1_" .. iter_89_0

		var_89_3[#var_89_3 + 1] = {
			pass_type = "multi_texture",
			style_id = var_89_11,
			texture_id = var_89_11,
			content_check_function = function (arg_92_0)
				return arg_92_0[var_89_9]
			end
		}
		var_89_5[var_89_11] = {
			direction = 1,
			axis = 1,
			draw_count = 0,
			texture_size = var_89_8,
			spacing = var_89_7,
			color = var_89_0,
			offset = {
				5,
				var_89_6,
				3
			}
		}
		var_89_4[var_89_11] = {
			"stats_star_left",
			"stats_star_left",
			"stats_star_left",
			"stats_star_left",
			"stats_star_left"
		}

		local var_89_12 = "stars_left_2_" .. iter_89_0

		var_89_3[#var_89_3 + 1] = {
			pass_type = "multi_texture",
			style_id = var_89_12,
			texture_id = var_89_12,
			content_check_function = function (arg_93_0)
				return arg_93_0[var_89_9]
			end
		}
		var_89_5[var_89_12] = {
			direction = 1,
			axis = 1,
			draw_count = 0,
			texture_size = var_89_8,
			spacing = var_89_7,
			color = var_89_0,
			offset = {
				5,
				var_89_6,
				3
			}
		}
		var_89_4[var_89_12] = {
			"stats_star_right",
			"stats_star_right",
			"stats_star_right",
			"stats_star_right",
			"stats_star_right"
		}

		local var_89_13 = arg_89_1[1] - 5 - (var_89_8[1] * 5 + var_89_7[1] * 4)
		local var_89_14 = "stars_right_bg_" .. iter_89_0

		var_89_3[#var_89_3 + 1] = {
			pass_type = "multi_texture",
			style_id = var_89_14,
			texture_id = var_89_14,
			content_check_function = function (arg_94_0)
				return arg_94_0[var_89_9]
			end
		}
		var_89_5[var_89_14] = {
			direction = 1,
			axis = 1,
			draw_count = 5,
			texture_size = var_89_8,
			spacing = var_89_7,
			color = {
				255,
				50,
				50,
				50
			},
			offset = {
				var_89_13,
				var_89_6,
				3
			}
		}
		var_89_4[var_89_14] = {
			"stats_star",
			"stats_star",
			"stats_star",
			"stats_star",
			"stats_star"
		}

		local var_89_15 = "stars_right_1_" .. iter_89_0

		var_89_3[#var_89_3 + 1] = {
			pass_type = "multi_texture",
			style_id = var_89_15,
			texture_id = var_89_15,
			content_check_function = function (arg_95_0)
				return arg_95_0[var_89_9]
			end
		}
		var_89_5[var_89_15] = {
			direction = 1,
			axis = 1,
			draw_count = 0,
			texture_size = var_89_8,
			spacing = var_89_7,
			color = var_89_0,
			offset = {
				var_89_13,
				var_89_6,
				3
			}
		}
		var_89_4[var_89_15] = {
			"stats_star_left",
			"stats_star_left",
			"stats_star_left",
			"stats_star_left",
			"stats_star_left"
		}

		local var_89_16 = "stars_right_2_" .. iter_89_0

		var_89_3[#var_89_3 + 1] = {
			pass_type = "multi_texture",
			style_id = var_89_16,
			texture_id = var_89_16,
			content_check_function = function (arg_96_0)
				return arg_96_0[var_89_9]
			end
		}
		var_89_5[var_89_16] = {
			direction = 1,
			axis = 1,
			draw_count = 0,
			texture_size = var_89_8,
			spacing = var_89_7,
			color = var_89_0,
			offset = {
				var_89_13,
				var_89_6,
				3
			}
		}
		var_89_4[var_89_16] = {
			"stats_star_right",
			"stats_star_right",
			"stats_star_right",
			"stats_star_right",
			"stats_star_right"
		}
	end

	var_89_2.element.passes = var_89_3
	var_89_2.content = var_89_4
	var_89_2.style = var_89_5
	var_89_2.offset = {
		0,
		0,
		0
	}
	var_89_2.scenegraph_id = arg_89_0

	return var_89_2
end

UIWidgets.create_background_with_frame = function (arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4, arg_97_5)
	arg_97_2 = arg_97_2 or "menu_frame_bg_01"

	local var_97_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_97_2)
	local var_97_1 = var_97_0 and var_97_0.size or arg_97_1
	local var_97_2 = arg_97_3 and UIFrameSettings[arg_97_3] or UIFrameSettings.menu_frame_02
	local var_97_3

	if arg_97_4 then
		var_97_3 = {
			{
				1 - math.min(arg_97_1[1] / var_97_1[1], 1),
				1 - math.min(arg_97_1[2] / var_97_1[2], 1)
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
				math.min(arg_97_1[1] / var_97_1[1], 1),
				math.min(arg_97_1[2] / var_97_1[2], 1)
			}
		}
	end

	local var_97_4 = {
		element = {}
	}
	local var_97_5 = {
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
	local var_97_6 = {
		frame = var_97_2.texture,
		background = {
			uvs = var_97_3,
			texture_id = arg_97_2
		}
	}
	local var_97_7 = {
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

	var_97_4.element.passes = var_97_5
	var_97_4.content = var_97_6
	var_97_4.style = var_97_7
	var_97_4.offset = {
		0,
		0,
		0
	}
	var_97_4.scenegraph_id = arg_97_0

	return var_97_4
end

UIWidgets.create_rect_with_frame = function (arg_98_0, arg_98_1, arg_98_2, arg_98_3)
	local var_98_0 = arg_98_3 and UIFrameSettings[arg_98_3] or UIFrameSettings.menu_frame_02
	local var_98_1 = {
		element = {}
	}
	local var_98_2 = {
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
	local var_98_3 = {
		frame = var_98_0.texture
	}
	local var_98_4 = {
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

	var_98_1.element.passes = var_98_2
	var_98_1.content = var_98_3
	var_98_1.style = var_98_4
	var_98_1.offset = {
		0,
		0,
		0
	}
	var_98_1.scenegraph_id = arg_98_0

	return var_98_1
end

UIWidgets.create_rect_with_inner_rect_frame = function (arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4)
	local var_99_0 = 1
	local var_99_1 = 1
	local var_99_2 = {
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
	local var_99_3 = {}
	local var_99_4 = {
		background = {
			color = arg_99_2
		},
		bot_rect = {
			color = arg_99_3,
			size = {
				arg_99_1[1],
				var_99_0
			},
			offset = {
				0,
				0,
				var_99_1
			}
		},
		top_rect = {
			color = arg_99_3,
			size = {
				arg_99_1[1],
				var_99_0
			},
			offset = {
				0,
				arg_99_1[2] - var_99_0,
				var_99_1
			}
		},
		left_rect = {
			color = arg_99_3,
			size = {
				var_99_0,
				arg_99_1[2]
			},
			offset = {
				0,
				0,
				var_99_1
			}
		},
		right_rect = {
			color = arg_99_3,
			size = {
				var_99_0,
				arg_99_1[2]
			},
			offset = {
				arg_99_1[1] - var_99_0,
				0,
				var_99_1
			}
		}
	}

	return {
		element = {
			passes = var_99_2
		},
		content = var_99_3,
		style = var_99_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_99_0
	}
end

UIWidgets.create_background = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3)
	arg_100_2 = arg_100_2 or "menu_frame_bg_01"

	local var_100_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_100_2)
	local var_100_1 = {
		element = {}
	}
	local var_100_2 = {
		{
			style_id = "background",
			pass_type = "texture_uv",
			content_id = "background"
		}
	}
	local var_100_3 = {
		background = {
			uvs = {
				{
					0,
					0
				},
				{
					math.min(arg_100_1[1] / var_100_0.size[1], 1),
					math.min(arg_100_1[2] / var_100_0.size[2], 1)
				}
			},
			texture_id = arg_100_2
		}
	}
	local var_100_4 = {
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

	var_100_1.element.passes = var_100_2
	var_100_1.content = var_100_3
	var_100_1.style = var_100_4
	var_100_1.offset = {
		0,
		0,
		0
	}
	var_100_1.scenegraph_id = arg_100_0

	return var_100_1
end

UIWidgets.create_frame = function (arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4, arg_101_5, arg_101_6, arg_101_7, arg_101_8, arg_101_9)
	local var_101_0 = arg_101_2 and UIFrameSettings[arg_101_2] or UIFrameSettings.menu_frame_02
	local var_101_1 = {
		element = {}
	}
	local var_101_2 = {
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local var_101_3 = {
		frame = var_101_0.texture
	}
	local var_101_4 = {
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

	var_101_1.element.passes = var_101_2
	var_101_1.content = var_101_3
	var_101_1.style = var_101_4
	var_101_1.offset = {
		0,
		0,
		0
	}
	var_101_1.scenegraph_id = arg_101_0

	return var_101_1
end

UIWidgets.create_rect_with_outer_frame = function (arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4, arg_102_5, arg_102_6)
	arg_102_4 = arg_102_4 or {
		255,
		255,
		255,
		255
	}

	local var_102_0 = arg_102_2 and UIFrameSettings[arg_102_2] or UIFrameSettings.frame_outer_fade_02
	local var_102_1 = var_102_0.texture_sizes.horizontal[2]
	local var_102_2 = {
		arg_102_1[1] + var_102_1 * 2,
		arg_102_1[2] + var_102_1 * 2
	}
	local var_102_3 = {
		element = {}
	}
	local var_102_4 = {
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
	local var_102_5 = {
		frame = var_102_0.texture
	}
	local var_102_6 = {
		frame = {
			color = arg_102_5 or arg_102_4,
			size = var_102_2,
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

	var_102_3.element.passes = var_102_4
	var_102_3.content = var_102_5
	var_102_3.style = var_102_6
	var_102_3.offset = {
		0,
		0,
		0
	}
	var_102_3.scenegraph_id = arg_102_0

	return var_102_3
end

UIWidgets.create_craft_recipe_window = function (arg_103_0, arg_103_1, arg_103_2, arg_103_3)
	local var_103_0 = Colors.get_color_table_with_alpha("white", 255)
	local var_103_1 = arg_103_3 or "menu_frame_bg_01"
	local var_103_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_103_1)
	local var_103_3 = arg_103_1[1] * 0.3
	local var_103_4 = {
		element = {}
	}
	local var_103_5 = {
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
	local var_103_6 = {
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
					arg_103_1[1] / var_103_2.size[1],
					arg_103_1[2] / var_103_2.size[2]
				}
			},
			texture_id = var_103_1
		}
	}
	local var_103_7 = {
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
			color = var_103_0
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
	local var_103_8 = {
		50,
		50
	}
	local var_103_9 = {
		20,
		arg_103_1[2] - var_103_8[1] - 230,
		3
	}
	local var_103_10 = var_103_8[2]
	local var_103_11 = 20

	var_103_6.component_amount = arg_103_2

	for iter_103_0 = 1, arg_103_2 do
		local var_103_12 = iter_103_0 - 1
		local var_103_13 = "_" .. tostring(iter_103_0)
		local var_103_14 = {
			var_103_9[1],
			var_103_9[2] - (var_103_12 * var_103_10 + var_103_12 * var_103_11),
			var_103_9[3]
		}
		local var_103_15 = "component_active" .. var_103_13

		var_103_6[var_103_15] = false

		local var_103_16 = "component_icon" .. var_103_13

		var_103_5[#var_103_5 + 1] = {
			pass_type = "texture",
			texture_id = var_103_16,
			style_id = var_103_16,
			content_check_function = function (arg_104_0)
				return arg_104_0[var_103_15]
			end
		}
		var_103_7[var_103_16] = {
			size = var_103_8,
			offset = var_103_14,
			color = var_103_0
		}
		var_103_6[var_103_16] = "icons_placeholder"

		local var_103_17 = "component_text" .. var_103_13

		var_103_5[#var_103_5 + 1] = {
			pass_type = "text",
			text_id = var_103_17,
			style_id = var_103_17,
			content_check_function = function (arg_105_0)
				return arg_105_0[var_103_15]
			end
		}
		var_103_7[var_103_17] = {
			horizontal_alignment = "left",
			font_size = 24,
			word_wrap = true,
			vertical_alignment = "center",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("loading_screen_stone", 255),
			size = {
				arg_103_1[1] - var_103_9[1] * 2 - var_103_8[1] - 5,
				var_103_8[2]
			},
			offset = {
				var_103_14[1] + var_103_8[1] + 5,
				var_103_14[2],
				var_103_14[3]
			},
			color = var_103_0
		}
		var_103_6[var_103_17] = Localize("not_assigned")
	end

	var_103_4.element.passes = var_103_5
	var_103_4.content = var_103_6
	var_103_4.style = var_103_7
	var_103_4.offset = {
		0,
		0,
		0
	}
	var_103_4.scenegraph_id = arg_103_0

	return var_103_4
end

UIWidgets.create_hero_view_button = function (arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4)
	arg_106_3 = arg_106_3 or "button_frame_bg_01"

	local var_106_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_106_3)
	local var_106_1 = UIFrameSettings.menu_frame_glass_01
	local var_106_2 = UIFrameSettings.menu_frame_04

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (arg_107_0)
						return not arg_107_0.disabled
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
					content_check_function = function (arg_108_0)
						return not arg_108_0.button_hotspot.disabled and arg_108_0.button_hotspot.is_clicked > 0
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "glas_frame_pressed",
					texture_id = "glas_frame",
					content_check_function = function (arg_109_0)
						return arg_109_0.button_hotspot.disabled or arg_109_0.button_hotspot.is_clicked == 0
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_110_0)
						return not arg_110_0.button_hotspot.disabled
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_111_0)
						return arg_111_0.button_hotspot.disabled
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
						arg_106_1[1] / var_106_0.size[1],
						arg_106_1[2] / var_106_0.size[2]
					}
				},
				texture_id = arg_106_3
			},
			text = arg_106_2 or "n/a",
			frame = var_106_2.texture,
			glas_frame = var_106_1.texture
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
					arg_106_1[1] - var_106_2.texture_sizes.horizontal[2] * 2,
					arg_106_1[2] - var_106_2.texture_sizes.vertical[1] * 2
				},
				offset = {
					var_106_2.texture_sizes.horizontal[2],
					var_106_2.texture_sizes.vertical[1],
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
					arg_106_1[1] - var_106_2.texture_sizes.horizontal[2] * 2,
					arg_106_1[2] - var_106_2.texture_sizes.vertical[1] * 2
				},
				offset = {
					var_106_2.texture_sizes.horizontal[2],
					var_106_2.texture_sizes.vertical[1],
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
				texture_size = var_106_2.texture_size,
				texture_sizes = var_106_2.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				}
			},
			glas_frame = {
				size = {
					arg_106_1[1] - var_106_2.texture_sizes.horizontal[2] * 2,
					arg_106_1[2] - var_106_2.texture_sizes.vertical[1] * 2
				},
				texture_size = var_106_1.texture_size,
				texture_sizes = var_106_1.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_106_2.texture_sizes.horizontal[2],
					var_106_2.texture_sizes.vertical[1],
					3
				}
			},
			glas_frame_pressed = {
				size = {
					arg_106_1[1] - var_106_2.texture_sizes.horizontal[2] * 2,
					arg_106_1[2] - var_106_2.texture_sizes.vertical[1] * 2
				},
				texture_size = var_106_1.texture_size,
				texture_sizes = var_106_1.texture_sizes,
				color = {
					150,
					255,
					255,
					255
				},
				offset = {
					var_106_2.texture_sizes.horizontal[2],
					var_106_2.texture_sizes.vertical[1],
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
	local var_112_0 = {
		255,
		255,
		255,
		255
	}
	local var_112_1 = Colors.get_color_table_with_alpha("dim_gray", 50)
	local var_112_2 = Colors.get_color_table_with_alpha("gray", 50)
	local var_112_3 = Colors.get_color_table_with_alpha("font_title", 50)
	local var_112_4 = Colors.get_color_table_with_alpha("white", 150)
	local var_112_5 = 10
	local var_112_6 = 10
	local var_112_7 = arg_112_1[1]
	local var_112_8 = arg_112_1[2]
	local var_112_9 = var_112_7 - (arg_112_5 * arg_112_2[1] + var_112_5 * (arg_112_5 - 1))
	local var_112_10 = var_112_8 - (arg_112_4 * arg_112_2[2] + var_112_6 * (arg_112_4 - 1))
	local var_112_11 = {
		var_112_9 / 2 + arg_112_3[1],
		var_112_8 - var_112_10 / 2 - arg_112_2[2] + arg_112_3[2]
	}
	local var_112_12 = {
		element = {}
	}
	local var_112_13 = {}
	local var_112_14 = {
		rows = arg_112_4,
		columns = arg_112_5,
		slots = arg_112_4 * arg_112_5
	}
	local var_112_15 = {}
	local var_112_16 = 0

	for iter_112_0 = 1, arg_112_4 do
		for iter_112_1 = 1, arg_112_5 do
			local var_112_17 = "_" .. tostring(iter_112_0) .. "_" .. tostring(iter_112_1)
			local var_112_18 = iter_112_0 - 1
			local var_112_19 = iter_112_1 - 1
			local var_112_20 = {
				var_112_11[1] + var_112_19 * (arg_112_2[1] + var_112_5),
				var_112_11[2] - var_112_18 * (arg_112_2[2] + var_112_6),
				var_112_16
			}
			local var_112_21 = "hotspot" .. var_112_17

			var_112_13[#var_112_13 + 1] = {
				pass_type = "hotspot",
				content_id = var_112_21,
				style_id = var_112_21
			}
			var_112_15[var_112_21] = {
				size = arg_112_2,
				offset = var_112_20
			}
			var_112_14[var_112_21] = {
				drag_texture_size = arg_112_2
			}

			local var_112_22 = "item_icon" .. var_112_17

			var_112_13[#var_112_13 + 1] = {
				pass_type = "texture",
				content_id = var_112_21,
				texture_id = var_112_22,
				style_id = var_112_22,
				content_check_function = function (arg_113_0)
					return arg_113_0[var_112_22]
				end
			}
			var_112_15[var_112_22] = {
				size = arg_112_2,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_112_20[1] + (arg_112_2[1] - arg_112_2[1]) / 2,
					var_112_20[2] + (arg_112_2[2] - arg_112_2[2]) - (arg_112_2[1] - arg_112_2[1]) / 2,
					4
				}
			}

			local var_112_23 = "slot_bg" .. var_112_17

			var_112_13[#var_112_13 + 1] = {
				pass_type = "rounded_background",
				style_id = var_112_23
			}
			var_112_15[var_112_23] = {
				corner_radius = 0,
				size = arg_112_2,
				color = var_112_1,
				offset = {
					var_112_20[1] + (arg_112_2[1] - arg_112_2[1]) / 2,
					var_112_20[2] + (arg_112_2[2] - arg_112_2[2]) - (arg_112_2[1] - arg_112_2[1]) / 2,
					2
				}
			}

			local var_112_24 = "slot_border" .. var_112_17

			var_112_13[#var_112_13 + 1] = {
				pass_type = "texture_frame",
				content_id = var_112_21,
				texture_id = var_112_24,
				style_id = var_112_24
			}

			local var_112_25 = UIFrameSettings.menu_frame_01

			var_112_15[var_112_24] = {
				size = arg_112_2,
				texture_size = var_112_25.texture_size,
				texture_sizes = var_112_25.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_112_20[1],
					var_112_20[2],
					5
				}
			}
			var_112_14[var_112_21][var_112_24] = var_112_25.texture

			local var_112_26 = "slot_glow_hover" .. var_112_17

			var_112_13[#var_112_13 + 1] = {
				pass_type = "rounded_background",
				content_id = var_112_21,
				style_id = var_112_26,
				content_check_function = function (arg_114_0)
					return arg_114_0.is_hover
				end
			}
			var_112_15[var_112_26] = {
				corner_radius = 0,
				size = arg_112_2,
				color = var_112_2,
				offset = {
					var_112_20[1] + (arg_112_2[1] - arg_112_2[1]) / 2,
					var_112_20[2] + (arg_112_2[2] - arg_112_2[2]) - (arg_112_2[1] - arg_112_2[1]) / 2,
					2
				}
			}

			local var_112_27 = "slot_glow_selected" .. var_112_17

			var_112_13[#var_112_13 + 1] = {
				pass_type = "rounded_background",
				content_id = var_112_21,
				style_id = var_112_27,
				content_check_function = function (arg_115_0)
					return arg_115_0.is_selected
				end
			}
			var_112_15[var_112_27] = {
				corner_radius = 0,
				size = arg_112_2,
				color = var_112_3,
				offset = {
					var_112_20[1] + (arg_112_2[1] - arg_112_2[1]) / 2,
					var_112_20[2] + (arg_112_2[2] - arg_112_2[2]) - (arg_112_2[1] - arg_112_2[1]) / 2,
					2
				}
			}

			local var_112_28 = "item_tooltip" .. var_112_17

			var_112_14[var_112_28] = {}
			var_112_13[#var_112_13 + 1] = {
				pass_type = "generic_tooltip",
				style_id = var_112_28,
				content_id = var_112_21,
				content_check_function = function (arg_116_0)
					return arg_116_0.is_hover and arg_116_0[var_112_28]
				end
			}
			var_112_15[var_112_28] = {
				font_size = 18,
				font_type = "hell_shark",
				horizontal_alignment = "left",
				vertical_alignment = "top",
				max_width = 500,
				size = arg_112_2,
				offset = {
					var_112_20[1] + (arg_112_2[1] - arg_112_2[1]) / 2,
					var_112_20[2] + (arg_112_2[2] - arg_112_2[2]) - (arg_112_2[1] - arg_112_2[1]) / 2,
					2
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				text_styles = {},
				value_styles = {}
			}
		end
	end

	var_112_12.element.passes = var_112_13
	var_112_12.content = var_112_14
	var_112_12.style = var_112_15
	var_112_12.offset = {
		0,
		0,
		0
	}
	var_112_12.scenegraph_id = arg_112_0

	return var_112_12
end

UIWidgets.create_reward_card = function (arg_117_0, arg_117_1)
	local var_117_0 = {
		255,
		255,
		255,
		255
	}
	local var_117_1 = {
		220,
		20,
		15,
		15
	}
	local var_117_2 = Colors.get_color_table_with_alpha("dim_gray", 40)
	local var_117_3 = Colors.get_color_table_with_alpha("white", 150)
	local var_117_4 = {
		300,
		300
	}
	local var_117_5 = {
		arg_117_1[1] / 2 - var_117_4[1] / 2,
		arg_117_1[2] - var_117_4[2] - math.floor(arg_117_1[2] * 0.1),
		3
	}
	local var_117_6 = {
		element = {}
	}
	local var_117_7 = {}
	local var_117_8 = {}
	local var_117_9 = {}
	local var_117_10 = "button_hotspot"

	var_117_7[#var_117_7 + 1] = {
		pass_type = "hotspot",
		content_id = var_117_10,
		style_id = var_117_10
	}
	var_117_9[var_117_10] = {
		size = arg_117_1,
		offset = {
			0,
			0,
			0
		}
	}
	var_117_8[var_117_10] = {
		disable_button = true,
		is_selected = false,
		drag_texture_size = arg_117_1
	}

	local var_117_11 = "item_icon"

	var_117_7[#var_117_7 + 1] = {
		pass_type = "texture",
		content_id = var_117_10,
		texture_id = var_117_11,
		style_id = var_117_11,
		content_check_function = function (arg_118_0)
			return not arg_118_0.disable_button and arg_118_0[var_117_11]
		end
	}
	var_117_9[var_117_11] = {
		size = var_117_4,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_117_5[1],
			var_117_5[2],
			var_117_5[3] + 3
		}
	}
	var_117_8[var_117_10][var_117_11] = "icons_placeholder"

	local var_117_12 = "can_use_texture"

	var_117_7[#var_117_7 + 1] = {
		pass_type = "centered_texture_amount",
		texture_id = var_117_12,
		style_id = var_117_12,
		content_check_function = function (arg_119_0)
			return arg_119_0[var_117_10][var_117_11]
		end
	}
	var_117_9[var_117_12] = {
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
	var_117_8[var_117_12] = {
		"stats_star",
		"stats_star",
		"stats_star",
		"stats_star",
		"stats_star"
	}

	local var_117_13 = "item_title_text"

	var_117_7[#var_117_7 + 1] = {
		pass_type = "text",
		text_id = var_117_13,
		style_id = var_117_13
	}
	var_117_9[var_117_13] = {
		vertical_alignment = "bottom",
		font_size = 32,
		horizontal_alignment = "center",
		word_wrap = true,
		font_type = "hell_shark",
		size = {
			arg_117_1[1] - 20,
			var_117_5[2] - 40
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			10,
			var_117_5[2] - 40,
			var_117_5[3] + 4
		}
	}
	var_117_8[var_117_13] = Localize("not_assigned")

	local var_117_14 = "item_type_text"

	var_117_7[#var_117_7 + 1] = {
		pass_type = "text",
		text_id = var_117_14,
		style_id = var_117_14
	}
	var_117_9[var_117_14] = {
		vertical_alignment = "top",
		font_size = 24,
		horizontal_alignment = "center",
		word_wrap = true,
		font_type = "hell_shark",
		size = {
			arg_117_1[1] - 20,
			var_117_5[2] - 40
		},
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			10,
			0,
			var_117_5[3] + 4
		}
	}
	var_117_8[var_117_14] = Localize("not_assigned")
	var_117_6.element.passes = var_117_7
	var_117_6.content = var_117_8
	var_117_6.style = var_117_9
	var_117_6.offset = {
		0,
		0,
		0
	}
	var_117_6.scenegraph_id = arg_117_0

	return var_117_6
end

UIWidgets.create_score_topic = function (arg_120_0, arg_120_1)
	local var_120_0 = "menu_frame_bg_04"
	local var_120_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_120_0)
	local var_120_2 = "menu_frame_bg_02"
	local var_120_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_120_2)
	local var_120_4 = {
		148,
		163
	}
	local var_120_5 = {
		arg_120_1[1] / 2 - var_120_4[1] / 2,
		arg_120_1[2] / 2 - var_120_4[2] / 2,
		3
	}
	local var_120_6 = UIFrameSettings.menu_frame_03

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
					content_check_function = function (arg_121_0)
						return arg_121_0.icon
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
			frame = var_120_6.texture,
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						arg_120_1[1] / var_120_1.size[1],
						arg_120_1[2] / var_120_1.size[2]
					}
				},
				texture_id = var_120_0
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
				texture_size = var_120_6.texture_size,
				texture_sizes = var_120_6.texture_sizes,
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
				size = var_120_4,
				default_size = var_120_4,
				offset = {
					var_120_5[1],
					var_120_5[2],
					var_120_5[3] + 1
				},
				default_offset = {
					var_120_5[1],
					var_120_5[2],
					var_120_5[3] + 1
				},
				color = Colors.get_color_table_with_alpha("white", 0)
			},
			icon_bg = {
				size = var_120_4,
				offset = var_120_5,
				default_size = var_120_4,
				default_offset = var_120_5,
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
	arg_123_3 = arg_123_3 or "reward_pop_up_item_bg"

	local var_123_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_123_3)

	return {
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
		},
		content = {
			text = arg_123_2,
			color = arg_123_6 and arg_123_6.text_color or arg_123_5,
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						math.min(arg_123_1[1] / var_123_0.size[1], 1),
						math.min(arg_123_1[2] / var_123_0.size[2], 1)
					}
				},
				texture_id = arg_123_3
			}
		},
		style = {
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
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_123_0
	}
end

UIWidgets.create_summary_entry = function (arg_124_0, arg_124_1, arg_124_2)
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
	local var_126_0 = "menu_frame_bg_01"
	local var_126_1 = "scoreboard_bg"
	local var_126_2 = "scoreboard_bg_top"
	local var_126_3 = "scoreboard_topic_bg"
	local var_126_4 = "scoreboard_divider_01"
	local var_126_5 = "scoreboard_divider_02"
	local var_126_6 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_126_0)
	local var_126_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_126_1)
	local var_126_8 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_126_2)
	local var_126_9 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_126_3)
	local var_126_10 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_126_4)
	local var_126_11 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_126_5)
	local var_126_12 = UIFrameSettings.menu_frame_06
	local var_126_13 = 24
	local var_126_14 = 39
	local var_126_15 = 0
	local var_126_16 = {
		arg_126_1[1],
		var_126_14 + var_126_15
	}
	local var_126_17 = {
		arg_126_1[1],
		var_126_11.size[2]
	}
	local var_126_18 = -100
	local var_126_19 = -120
	local var_126_20 = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		}
	}
	local var_126_21 = {
		button_hotspot = {},
		frame = var_126_12.texture,
		rows = arg_126_2
	}
	local var_126_22 = {
		frame = {
			texture_size = var_126_12.texture_size,
			texture_sizes = var_126_12.texture_sizes,
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

	for iter_126_0 = 1, arg_126_2 do
		local var_126_23 = "_" .. tostring(iter_126_0)
		local var_126_24 = {
			0,
			arg_126_1[2] - (var_126_14 + var_126_15) * iter_126_0 + var_126_19,
			0
		}
		local var_126_25 = "hotspot" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			pass_type = "hotspot",
			content_id = var_126_25,
			style_id = var_126_25
		}
		var_126_21[var_126_25] = {
			hover_texture_size = var_126_16,
			vertical_divider_texture_id = var_126_4
		}
		var_126_22[var_126_25] = {
			size = var_126_16,
			offset = {
				var_126_24[1],
				var_126_24[2],
				var_126_24[3]
			}
		}

		local var_126_26 = "row_bg" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			texture_id = "hover_texture_id",
			pass_type = "tiled_texture",
			content_id = var_126_26,
			style_id = var_126_26,
			content_check_function = function (arg_127_0)
				return arg_127_0.has_background
			end
		}
		var_126_21[var_126_26] = {
			hover_texture_id = "scoreboard_topic_bg",
			has_background = false
		}
		var_126_22[var_126_26] = {
			size = var_126_16,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_126_24[1],
				var_126_24[2],
				var_126_24[3] + 10
			},
			texture_tiling_size = var_126_9.size
		}

		local var_126_27 = "horizontal_divider" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			texture_id = "horizontal_divider_texture_id",
			pass_type = "tiled_texture",
			content_id = var_126_27,
			style_id = var_126_27,
			content_check_function = function (arg_128_0)
				return arg_128_0.has_horizontal_divider
			end
		}
		var_126_21[var_126_27] = {
			has_horizontal_divider = false,
			horizontal_divider_texture_id = var_126_5
		}
		var_126_22[var_126_27] = {
			size = var_126_17,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_126_24[1],
				var_126_24[2] - var_126_11.size[2] * 0.5,
				var_126_24[3]
			},
			texture_tiling_size = var_126_11.size
		}

		local var_126_28 = "title_text" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			pass_type = "text",
			text_id = "text",
			content_id = var_126_28,
			style_id = var_126_28,
			content_check_function = function (arg_129_0)
				return arg_129_0.text ~= nil
			end
		}
		var_126_21[var_126_28] = {}
		var_126_22[var_126_28] = {
			vertical_alignment = "bottom",
			word_wrap = true,
			horizontal_alignment = "left",
			font_type = "hell_shark",
			font_size = var_126_13,
			text_color = Colors.get_color_table_with_alpha("white", 200),
			offset = {
				var_126_24[1] + 20,
				var_126_24[2],
				var_126_24[3] + 2
			}
		}

		local var_126_29 = "score_player_1" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			pass_type = "text",
			text_id = "text",
			content_id = var_126_29,
			style_id = var_126_29,
			content_check_function = function (arg_130_0)
				return arg_130_0.text ~= nil
			end
		}
		var_126_21[var_126_29] = {}
		var_126_22[var_126_29] = {
			vertical_alignment = "bottom",
			word_wrap = true,
			horizontal_alignment = "center",
			font_type = "hell_shark",
			font_size = var_126_13,
			text_color = Colors.get_color_table_with_alpha("white", 200),
			offset = {
				var_126_24[1] - 450,
				var_126_24[2],
				var_126_24[3] + 2
			}
		}

		local var_126_30 = "score_player_2" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			pass_type = "text",
			text_id = "text",
			content_id = var_126_30,
			style_id = var_126_30,
			content_check_function = function (arg_131_0)
				return arg_131_0.text ~= nil
			end
		}
		var_126_21[var_126_30] = {}
		var_126_22[var_126_30] = {
			vertical_alignment = "bottom",
			word_wrap = true,
			horizontal_alignment = "center",
			font_type = "hell_shark",
			font_size = var_126_13,
			text_color = Colors.get_color_table_with_alpha("white", 200),
			offset = {
				var_126_24[1] - 150,
				var_126_24[2],
				var_126_24[3] + 2
			}
		}

		local var_126_31 = "score_player_3" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			pass_type = "text",
			text_id = "text",
			content_id = var_126_31,
			style_id = var_126_31,
			content_check_function = function (arg_132_0)
				return arg_132_0.text ~= nil
			end
		}
		var_126_21[var_126_31] = {}
		var_126_22[var_126_31] = {
			vertical_alignment = "bottom",
			word_wrap = true,
			horizontal_alignment = "center",
			font_type = "hell_shark",
			font_size = var_126_13,
			text_color = Colors.get_color_table_with_alpha("white", 200),
			offset = {
				var_126_24[1] + 150,
				var_126_24[2],
				var_126_24[3] + 2
			}
		}

		local var_126_32 = "score_player_4" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			pass_type = "text",
			text_id = "text",
			content_id = var_126_32,
			style_id = var_126_32,
			content_check_function = function (arg_133_0)
				return arg_133_0.text ~= nil
			end
		}
		var_126_21[var_126_32] = {}
		var_126_22[var_126_32] = {
			vertical_alignment = "bottom",
			word_wrap = true,
			horizontal_alignment = "center",
			font_type = "hell_shark",
			font_size = var_126_13,
			text_color = Colors.get_color_table_with_alpha("white", 200),
			offset = {
				var_126_24[1] + 450,
				var_126_24[2],
				var_126_24[3] + 2
			}
		}

		local var_126_33 = "high_score_marker_1" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			texture_id = "high_score_marker_texture_id",
			pass_type = "texture",
			content_id = var_126_33,
			style_id = var_126_33,
			content_check_function = function (arg_134_0)
				return arg_134_0.parent["title_text" .. var_126_23].text ~= nil and arg_134_0.parent["score_player_1" .. var_126_23].text ~= nil and arg_134_0.has_highscore
			end
		}
		var_126_21[var_126_33] = {
			high_score_marker_texture_id = "scoreboard_marker",
			has_highscore = false
		}
		var_126_22[var_126_33] = {
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
				var_126_24[1] - 450 + 800 + 120,
				var_126_24[2],
				var_126_24[3]
			}
		}

		local var_126_34 = "high_score_marker_2" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			texture_id = "high_score_marker_texture_id",
			pass_type = "texture",
			content_id = var_126_34,
			style_id = var_126_34,
			content_check_function = function (arg_135_0)
				return arg_135_0.parent["title_text" .. var_126_23].text ~= nil and arg_135_0.parent["score_player_1" .. var_126_23].text ~= nil and arg_135_0.has_highscore
			end
		}
		var_126_21[var_126_34] = {
			high_score_marker_texture_id = "scoreboard_marker",
			has_highscore = false
		}
		var_126_22[var_126_34] = {
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
				var_126_24[1] - 150 + 800 + 120,
				var_126_24[2],
				var_126_24[3]
			}
		}

		local var_126_35 = "high_score_marker_3" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			texture_id = "high_score_marker_texture_id",
			pass_type = "texture",
			content_id = var_126_35,
			style_id = var_126_35,
			content_check_function = function (arg_136_0)
				return arg_136_0.parent["title_text" .. var_126_23].text ~= nil and arg_136_0.parent["score_player_1" .. var_126_23].text ~= nil and arg_136_0.has_highscore
			end
		}
		var_126_21[var_126_35] = {
			high_score_marker_texture_id = "scoreboard_marker",
			has_highscore = false
		}
		var_126_22[var_126_35] = {
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
				var_126_24[1] + 150 + 800 + 120,
				var_126_24[2],
				var_126_24[3]
			}
		}

		local var_126_36 = "high_score_marker_4" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			texture_id = "high_score_marker_texture_id",
			pass_type = "texture",
			content_id = var_126_36,
			style_id = var_126_36,
			content_check_function = function (arg_137_0)
				return arg_137_0.parent["title_text" .. var_126_23].text ~= nil and arg_137_0.parent["score_player_1" .. var_126_23].text ~= nil and arg_137_0.has_highscore
			end
		}
		var_126_21[var_126_36] = {
			high_score_marker_texture_id = "scoreboard_marker",
			has_highscore = false
		}
		var_126_22[var_126_36] = {
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
				var_126_24[1] + 450 + 800 + 120,
				var_126_24[2],
				var_126_24[3]
			}
		}

		local var_126_37 = "line_divider_1" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			texture_id = "vertical_divider_texture_id",
			pass_type = "texture",
			content_id = var_126_25,
			style_id = var_126_37,
			content_check_function = function (arg_138_0)
				return arg_138_0.parent["title_text" .. var_126_23].text ~= nil and arg_138_0.parent["score_player_1" .. var_126_23].text ~= nil
			end
		}
		var_126_22[var_126_37] = {
			size = {
				4,
				var_126_14
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_126_24[1] - 450 + 800,
				var_126_24[2],
				var_126_24[3]
			}
		}

		local var_126_38 = "line_divider_2" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			texture_id = "vertical_divider_texture_id",
			pass_type = "texture",
			content_id = var_126_25,
			style_id = var_126_38,
			content_check_function = function (arg_139_0)
				return arg_139_0.parent["title_text" .. var_126_23].text ~= nil and arg_139_0.parent["score_player_1" .. var_126_23].text ~= nil
			end
		}
		var_126_22[var_126_38] = {
			size = {
				4,
				var_126_14
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_126_24[1] - 150 + 800,
				var_126_24[2],
				var_126_24[3]
			}
		}

		local var_126_39 = "line_divider_3" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			texture_id = "vertical_divider_texture_id",
			pass_type = "texture",
			content_id = var_126_25,
			style_id = var_126_39,
			content_check_function = function (arg_140_0)
				return arg_140_0.parent["title_text" .. var_126_23].text ~= nil and arg_140_0.parent["score_player_1" .. var_126_23].text ~= nil
			end
		}
		var_126_22[var_126_39] = {
			size = {
				4,
				var_126_14
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_126_24[1] + 150 + 800,
				var_126_24[2],
				var_126_24[3]
			}
		}

		local var_126_40 = "line_divider_4" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			texture_id = "vertical_divider_texture_id",
			pass_type = "texture",
			content_id = var_126_25,
			style_id = var_126_40,
			content_check_function = function (arg_141_0)
				return arg_141_0.parent["title_text" .. var_126_23].text ~= nil and arg_141_0.parent["score_player_1" .. var_126_23].text ~= nil
			end
		}
		var_126_22[var_126_40] = {
			size = {
				4,
				var_126_14
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_126_24[1] + 450 + 800,
				var_126_24[2],
				var_126_24[3]
			}
		}

		local var_126_41 = "line_divider_5" .. var_126_23

		var_126_20[#var_126_20 + 1] = {
			texture_id = "vertical_divider_texture_id",
			pass_type = "texture",
			content_id = var_126_25,
			style_id = var_126_41,
			content_check_function = function (arg_142_0)
				return arg_142_0.parent["title_text" .. var_126_23].text ~= nil and arg_142_0.parent["score_player_1" .. var_126_23].text ~= nil
			end
		}
		var_126_22[var_126_41] = {
			size = {
				4,
				var_126_14
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_126_24[1] + 750 + 800,
				var_126_24[2],
				var_126_24[3]
			}
		}
	end

	return {
		element = {
			passes = var_126_20
		},
		content = var_126_21,
		style = var_126_22,
		scenegraph_id = arg_126_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_level_up_widget = function (arg_143_0, arg_143_1)
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
	local var_144_0 = UIFrameSettings.menu_frame_06

	return {
		element = {
			passes = {
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame",
					content_check_function = function (arg_145_0)
						return arg_145_0.draw_frame
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
			frame = var_144_0.texture
		},
		style = {
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
					arg_144_1[1] - var_144_0.texture_sizes.horizontal[2] * 2,
					arg_144_1[2] - var_144_0.texture_sizes.vertical[1] * 2
				},
				offset = {
					var_144_0.texture_sizes.horizontal[2],
					var_144_0.texture_sizes.vertical[1],
					0
				}
			},
			experience_bar = {
				masked = arg_144_2,
				color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_144_1[1] - var_144_0.texture_sizes.horizontal[2] * 2,
					arg_144_1[2] - var_144_0.texture_sizes.vertical[1] * 2
				},
				default_size = {
					arg_144_1[1] - var_144_0.texture_sizes.horizontal[2],
					arg_144_1[2] - var_144_0.texture_sizes.vertical[1] * 2
				},
				offset = {
					var_144_0.texture_sizes.horizontal[2],
					var_144_0.texture_sizes.vertical[1],
					2
				}
			},
			glass = {
				masked = arg_144_2,
				color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_144_1[1] - var_144_0.texture_sizes.horizontal[2] * 2,
					arg_144_1[2] - var_144_0.texture_sizes.vertical[1] * 2
				},
				offset = {
					var_144_0.texture_sizes.horizontal[2],
					var_144_0.texture_sizes.vertical[1],
					4
				}
			},
			frame = {
				masked = arg_144_2,
				texture_size = var_144_0.texture_size,
				texture_sizes = var_144_0.texture_sizes,
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
			counter_text = {
				vertical_alignment = "top",
				font_size = 28,
				horizontal_alignment = "center",
				font_type = arg_144_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					-arg_144_1[2] - 5,
					0
				}
			},
			level_text_from = {
				vertical_alignment = "center",
				font_size = 36,
				horizontal_alignment = "right",
				font_type = arg_144_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					-arg_144_1[1] - 10,
					0,
					0
				}
			},
			level_text_to = {
				vertical_alignment = "center",
				font_size = 36,
				horizontal_alignment = "left",
				font_type = arg_144_2 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					arg_144_1[1] + 10,
					0,
					0
				}
			}
		},
		scenegraph_id = arg_144_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_statistics_bar = function (arg_146_0, arg_146_1, arg_146_2, arg_146_3)
	local var_146_0 = UIFrameSettings.menu_frame_06
	local var_146_1 = UIFrameSettings.frame_outer_glow_02
	local var_146_2 = var_146_1.texture_sizes.horizontal[2]
	local var_146_3 = arg_146_2 or "button_detail_03"
	local var_146_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_146_3).size

	return {
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
					content_check_function = function (arg_147_0)
						return arg_147_0.hotspot.is_hover
					end
				},
				{
					texture_id = "star",
					style_id = "star",
					pass_type = "texture",
					content_check_function = function (arg_148_0)
						return arg_148_0.has_star
					end
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame",
					content_check_function = function (arg_149_0)
						return arg_149_0.draw_frame
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
						local var_150_0 = arg_150_1.parent.experience_bar
						local var_150_1 = var_150_0.offset[1]

						arg_150_1.offset[1] = math.floor(var_150_0.size[1] + var_150_1)
						arg_150_1.size[1] = math.min(40, var_150_0.default_size[1] - (arg_150_1.offset[1] - var_150_1))
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
			hover_frame = var_146_1.texture,
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
				texture_id = var_146_3
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
			frame = var_146_0.texture
		},
		style = {
			background = {
				color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_146_1[1] - var_146_0.texture_sizes.horizontal[2] * 2,
					arg_146_1[2] - var_146_0.texture_sizes.vertical[1] * 2
				},
				offset = {
					var_146_0.texture_sizes.horizontal[2],
					var_146_0.texture_sizes.vertical[1],
					0
				}
			},
			experience_bar = {
				color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_146_1[1] - var_146_0.texture_sizes.horizontal[2] * 2,
					arg_146_1[2] - var_146_0.texture_sizes.vertical[1] * 2
				},
				default_size = {
					arg_146_1[1] - var_146_0.texture_sizes.horizontal[2],
					arg_146_1[2] - var_146_0.texture_sizes.vertical[1] * 2
				},
				offset = {
					var_146_0.texture_sizes.horizontal[2],
					var_146_0.texture_sizes.vertical[1],
					2
				}
			},
			experience_bar_edge = {
				color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					40,
					arg_146_1[2] - var_146_0.texture_sizes.vertical[1] * 2
				},
				offset = {
					0,
					var_146_0.texture_sizes.vertical[1],
					2
				}
			},
			glass = {
				color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_146_1[1] - var_146_0.texture_sizes.horizontal[2] * 2,
					arg_146_1[2] - var_146_0.texture_sizes.vertical[1] * 2
				},
				offset = {
					var_146_0.texture_sizes.horizontal[2],
					var_146_0.texture_sizes.vertical[1],
					3
				}
			},
			frame = {
				texture_size = var_146_0.texture_size,
				texture_sizes = var_146_0.texture_sizes,
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
				texture_size = var_146_1.texture_size,
				texture_sizes = var_146_1.texture_sizes,
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
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_146_3 and -arg_146_3 or -9,
					arg_146_1[2] / 2 - var_146_4[2] / 2,
					5
				},
				size = {
					var_146_4[1],
					var_146_4[2]
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
					arg_146_1[1] - var_146_4[1] + (arg_146_3 or 9),
					arg_146_1[2] / 2 - var_146_4[2] / 2,
					5
				},
				size = {
					var_146_4[1],
					var_146_4[2]
				}
			}
		},
		scenegraph_id = arg_146_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_0(arg_151_0)
	return arg_151_0.has_locked
end

local function var_0_1(arg_152_0)
	return arg_152_0.has_available
end

local function var_0_2(arg_153_0)
	return arg_153_0.has_completed
end

local function var_0_3(arg_154_0)
	return arg_154_0.is_hover
end

UIWidgets.create_quest_bar = function (arg_155_0, arg_155_1)
	local var_155_0 = "chain_end"
	local var_155_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_155_0).size
	local var_155_2 = 20
	local var_155_3 = 30
	local var_155_4 = 135
	local var_155_5 = -31
	local var_155_6 = {
		95 + var_155_2,
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
					content_check_function = var_0_0
				},
				{
					pass_type = "texture",
					style_id = "locked_icon_cooldown",
					texture_id = "icon_cooldown",
					content_check_function = function (arg_156_0)
						return arg_156_0.has_locked and arg_156_0.cooldown_lock
					end
				},
				{
					pass_type = "texture",
					style_id = "locked_icon_locked",
					texture_id = "icon_locked",
					content_check_function = function (arg_157_0)
						return arg_157_0.has_locked and not arg_157_0.cooldown_lock
					end
				},
				{
					pass_type = "tiled_texture",
					style_id = "locked_count_bg_center",
					texture_id = "count_bg_center",
					content_check_function = var_0_0
				},
				{
					pass_type = "texture",
					style_id = "locked_count_bg_right",
					texture_id = "count_bg_right",
					content_check_function = var_0_0
				},
				{
					style_id = "locked_text",
					pass_type = "text",
					text_id = "locked_text",
					content_check_function = var_0_0
				},
				{
					style_id = "locked_tooltip",
					pass_type = "hover",
					content_id = "locked_tooltip",
					content_check_function = function (arg_158_0)
						return arg_158_0.parent.has_locked
					end
				},
				{
					style_id = "locked_tooltip",
					pass_type = "tooltip_text",
					text_id = "text_id",
					content_id = "locked_tooltip",
					content_check_function = var_0_3
				},
				{
					pass_type = "texture",
					style_id = "available_slot",
					texture_id = "slot",
					content_check_function = var_0_1
				},
				{
					pass_type = "texture",
					style_id = "available_slot_frame",
					texture_id = "slot_frame",
					content_check_function = var_0_1
				},
				{
					pass_type = "texture",
					style_id = "available_icon_available",
					texture_id = "icon_available",
					content_check_function = var_0_1
				},
				{
					pass_type = "tiled_texture",
					style_id = "available_count_bg_center",
					texture_id = "count_bg_center",
					content_check_function = var_0_1
				},
				{
					pass_type = "texture",
					style_id = "available_count_bg_right",
					texture_id = "count_bg_right",
					content_check_function = var_0_1
				},
				{
					style_id = "available_text",
					pass_type = "text",
					text_id = "available_text",
					content_check_function = var_0_1
				},
				{
					style_id = "available_tooltip",
					pass_type = "hover",
					content_id = "available_tooltip",
					content_check_function = function (arg_159_0)
						return arg_159_0.parent.has_available
					end
				},
				{
					style_id = "available_tooltip",
					pass_type = "tooltip_text",
					text_id = "text_id",
					content_id = "available_tooltip",
					content_check_function = var_0_3
				},
				{
					pass_type = "texture",
					style_id = "completed_slot",
					texture_id = "slot",
					content_check_function = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "completed_slot_frame",
					texture_id = "slot_frame",
					content_check_function = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "completed_icon_loot",
					texture_id = "icon_loot",
					content_check_function = var_0_2
				},
				{
					pass_type = "tiled_texture",
					style_id = "completed_count_bg_center",
					texture_id = "count_bg_center",
					content_check_function = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "completed_count_bg_right",
					texture_id = "count_bg_right",
					content_check_function = var_0_2
				},
				{
					style_id = "completed_text",
					pass_type = "text",
					text_id = "completed_text",
					content_check_function = var_0_2
				},
				{
					style_id = "completed_tooltip",
					pass_type = "hover",
					content_id = "completed_tooltip",
					content_check_function = function (arg_160_0)
						return arg_160_0.parent.has_completed
					end
				},
				{
					style_id = "completed_tooltip",
					pass_type = "tooltip_text",
					text_id = "text_id",
					content_id = "completed_tooltip",
					content_check_function = var_0_3
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
				texture_id = var_155_0
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
					var_155_5 - var_155_4,
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
					var_155_5 - var_155_4,
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
					var_155_5 - var_155_4,
					0,
					3
				}
			},
			locked_count_bg_center = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					var_155_2,
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
					var_155_5 - var_155_4 + var_155_3,
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
					var_155_5 - var_155_4 + var_155_3 + var_155_2,
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
					var_155_5 - var_155_4 + var_155_3 + 12,
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
					-var_155_4,
					0,
					50
				},
				area_size = var_155_6
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
					var_155_5,
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
					var_155_5,
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
					var_155_5,
					0,
					3
				}
			},
			available_count_bg_center = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					var_155_2,
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
					var_155_5 + var_155_3,
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
					var_155_5 + var_155_3 + var_155_2,
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
					var_155_5 + var_155_3 + 12,
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
				area_size = var_155_6
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
					var_155_5 + var_155_4,
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
					var_155_5 + var_155_4,
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
					var_155_5 + var_155_4,
					0,
					3
				}
			},
			completed_count_bg_center = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					var_155_2,
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
					var_155_5 + var_155_4 + var_155_3,
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
					var_155_5 + var_155_4 + var_155_3 + var_155_2,
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
					var_155_5 + var_155_4 + var_155_3 + 12,
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
					var_155_4,
					0,
					50
				},
				area_size = var_155_6
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-var_155_1[1],
					arg_155_1[2] / 2 - var_155_1[2] / 2,
					5
				},
				size = {
					var_155_1[1],
					var_155_1[2]
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
					arg_155_1[2] / 2 - var_155_1[2] / 2,
					5
				},
				size = {
					var_155_1[1],
					var_155_1[2]
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
	local var_162_0 = "menu_frame_bg_01"
	local var_162_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_162_0)
	local var_162_2 = UIFrameSettings.menu_frame_06
	local var_162_3 = {
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
			frame = var_162_2.texture,
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						arg_162_1[1] / var_162_1.size[1],
						arg_162_1[2] / var_162_1.size[2]
					}
				},
				texture_id = var_162_0
			}
		},
		style = {
			frame = {
				texture_size = var_162_2.texture_size,
				texture_sizes = var_162_2.texture_sizes,
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
				size = var_162_3,
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
					var_162_3[1] + 40,
					arg_162_1[2] - 300,
					2
				},
				size = {
					arg_162_1[1] - (var_162_3[1] + 60),
					var_162_3[2]
				}
			},
			passive_ability_title_text = {
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				font_size = 22,
				horizontal_alignment = "left",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_162_3[1] + 40,
					arg_162_1[2] - 500,
					2
				},
				size = {
					arg_162_1[1] - (var_162_3[1] + 60),
					var_162_3[2]
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
	arg_163_3 = arg_163_3 or "button_bg_01"

	local var_163_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_163_3)
	local var_163_1 = arg_163_2 and UIFrameSettings[arg_163_2] or UIFrameSettings.button_frame_01
	local var_163_2 = var_163_1.texture_sizes.corner[1]
	local var_163_3 = arg_163_7 or "button_detail_01"
	local var_163_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_163_3).size
	local var_163_5
	local var_163_6

	if arg_163_8 then
		if type(arg_163_8) == "table" then
			var_163_5 = arg_163_8[1]
			var_163_6 = arg_163_8[2]
		else
			var_163_5 = arg_163_8
		end
	end

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
					pass_type = "texture_frame",
					content_check_function = function (arg_164_0)
						return arg_164_0.draw_frame
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
					content_check_function = function (arg_165_0)
						return arg_165_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function (arg_166_0)
						return not arg_166_0.skip_side_detail
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function (arg_167_0)
						return not arg_167_0.skip_side_detail
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_168_0)
						return not arg_168_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_169_0)
						return arg_169_0.button_hotspot.disable_button
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
				texture_id = var_163_3,
				skip_side_detail = arg_163_10
			},
			button_hotspot = {},
			title_text = arg_163_4 or "n/a",
			frame = var_163_1.texture,
			background = {
				uvs = {
					{
						0,
						1 - (arg_163_13 and 1 or arg_163_1[2] / var_163_0.size[2])
					},
					{
						arg_163_13 and 1 or arg_163_1[1] / var_163_0.size[1],
						1
					}
				},
				texture_id = arg_163_3
			},
			disable_with_gamepad = arg_163_9
		},
		style = {
			background = {
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
				masked = arg_163_11,
				texture_size = arg_163_13 and {
					arg_163_1[1] * 0.7,
					arg_163_1[2] * 0.7
				} or nil
			},
			background_fade = {
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
					var_163_2 - 2,
					3
				},
				size = {
					arg_163_1[1],
					math.min(arg_163_1[2] - 5, 80)
				},
				masked = arg_163_11
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
				word_wrap = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_size = arg_163_5 or 24,
				font_type = arg_163_11 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_163_1[1] - 40,
					arg_163_1[2]
				},
				area_size = arg_163_14,
				offset = {
					20,
					0,
					6
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_size = arg_163_5 or 24,
				font_type = arg_163_11 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				size = {
					arg_163_1[1] - 40,
					arg_163_1[2]
				},
				area_size = arg_163_14,
				offset = {
					20,
					0,
					6
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_size = arg_163_5 or 24,
				font_type = arg_163_11 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					arg_163_1[1] - 40,
					arg_163_1[2]
				},
				area_size = arg_163_14,
				offset = {
					22,
					-2,
					5
				}
			},
			frame = {
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
					arg_163_1[2] - (var_163_2 + 11),
					4
				},
				size = {
					arg_163_1[1],
					11
				},
				masked = arg_163_11
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
					var_163_2 - 9,
					4
				},
				size = {
					arg_163_1[1],
					11
				},
				masked = arg_163_11
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_163_5 and -var_163_5 or -9,
					arg_163_1[2] / 2 - var_163_4[2] / 2 + (var_163_6 or 0),
					9
				},
				size = {
					var_163_4[1],
					var_163_4[2]
				},
				masked = arg_163_11
			},
			side_detail_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_163_1[1] - var_163_4[1] + (var_163_5 or 9),
					arg_163_1[2] / 2 - var_163_4[2] / 2 + (var_163_6 or 0),
					9
				},
				size = {
					var_163_4[1],
					var_163_4[2]
				},
				masked = arg_163_11
			}
		},
		scenegraph_id = arg_163_0,
		offset = arg_163_12 or {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_default_image_button = function (arg_170_0, arg_170_1, arg_170_2, arg_170_3, arg_170_4, arg_170_5, arg_170_6, arg_170_7, arg_170_8, arg_170_9)
	arg_170_3 = arg_170_3 or "button_bg_01"

	local var_170_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_170_3)
	local var_170_1 = arg_170_2 and UIFrameSettings[arg_170_2] or UIFrameSettings.button_frame_01
	local var_170_2 = var_170_1.texture_sizes.corner[1]
	local var_170_3 = arg_170_8 or "button_detail_01"
	local var_170_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_170_3).size

	arg_170_6 = arg_170_6 or "loot_chest_icon"

	local var_170_5 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_170_6)
	local var_170_6 = var_170_5 and var_170_5.size or {
		200,
		200
	}
	local var_170_7 = 1 - math.min(arg_170_1[2] / var_170_6[2], 1)
	local var_170_8 = 0.9
	local var_170_9 = {
		var_170_6[1] * var_170_8,
		arg_170_1[2]
	}

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
					content_check_function = function (arg_171_0)
						return arg_171_0.button_hotspot.disable_button
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
					content_check_function = function (arg_172_0)
						return not arg_172_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_173_0)
						return arg_173_0.button_hotspot.disable_button
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
					content_check_function = function (arg_174_0)
						return arg_174_0.new
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
				texture_id = var_170_3
			},
			button_hotspot = {},
			title_text = arg_170_4 or "n/a",
			frame = var_170_1.texture,
			background_icon = {
				uvs = {
					{
						0,
						0.5 * var_170_7
					},
					{
						var_170_8,
						1 - var_170_7 / 2
					}
				},
				texture_id = arg_170_6
			},
			background = {
				uvs = {
					{
						0,
						1 - arg_170_1[2] / var_170_0.size[2]
					},
					{
						arg_170_1[1] / var_170_0.size[1],
						1
					}
				},
				texture_id = arg_170_3
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
			background_icon = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					arg_170_1[1] - var_170_9[1],
					arg_170_1[2] / 2 - var_170_9[2] / 2,
					1
				},
				size = var_170_9
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
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_170_9 and -arg_170_9 or -9,
					arg_170_1[2] / 2 - var_170_4[2] / 2,
					10
				},
				size = {
					var_170_4[1],
					var_170_4[2]
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
					arg_170_1[1] - var_170_4[1] + (arg_170_9 or 9),
					arg_170_1[2] / 2 - var_170_4[2] / 2,
					10
				},
				size = {
					var_170_4[1],
					var_170_4[2]
				}
			}
		},
		scenegraph_id = arg_170_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_default_icon_tabs = function (arg_175_0, arg_175_1, arg_175_2)
	local var_175_0 = "button_bg_01"
	local var_175_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_175_0)
	local var_175_2 = {
		element = {}
	}
	local var_175_3 = {}
	local var_175_4 = {
		amount = arg_175_2
	}
	local var_175_5 = {}
	local var_175_6 = 0
	local var_175_7 = 0
	local var_175_8 = -var_175_6
	local var_175_9 = (arg_175_1[1] - var_175_6 * (arg_175_2 - 1)) / arg_175_2
	local var_175_10 = {
		var_175_9,
		arg_175_1[2]
	}
	local var_175_11 = {
		34,
		34
	}
	local var_175_12 = 0

	for iter_175_0 = 1, arg_175_2 do
		local var_175_13 = "_" .. tostring(iter_175_0)
		local var_175_14 = iter_175_0 - 1

		var_175_8 = var_175_8 + var_175_10[1] + var_175_6

		local var_175_15 = {
			var_175_12,
			0,
			var_175_7
		}
		local var_175_16 = "hotspot" .. var_175_13

		var_175_3[#var_175_3 + 1] = {
			pass_type = "hotspot",
			content_id = var_175_16,
			style_id = var_175_16
		}
		var_175_5[var_175_16] = {
			size = var_175_10,
			offset = var_175_15
		}
		var_175_4[var_175_16] = {}

		local var_175_17 = var_175_4[var_175_16]
		local var_175_18 = "background" .. var_175_13

		var_175_3[#var_175_3 + 1] = {
			pass_type = "texture_uv",
			content_id = var_175_18,
			style_id = var_175_18
		}
		var_175_5[var_175_18] = {
			size = var_175_10,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_175_15[1],
				var_175_15[2],
				0
			}
		}
		var_175_4[var_175_18] = {
			uvs = {
				{
					0,
					1 - math.min(var_175_10[2] / var_175_1.size[2], 1)
				},
				{
					math.min(var_175_10[1] / var_175_1.size[1], 1),
					1
				}
			},
			texture_id = var_175_0
		}

		local var_175_19 = "background_fade" .. var_175_13

		var_175_3[#var_175_3 + 1] = {
			pass_type = "texture",
			content_id = var_175_16,
			texture_id = var_175_19,
			style_id = var_175_19
		}
		var_175_5[var_175_19] = {
			size = {
				var_175_10[1],
				var_175_10[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_175_15[1],
				var_175_15[2],
				1
			}
		}
		var_175_17[var_175_19] = "button_bg_fade"

		local var_175_20 = "hover_glow" .. var_175_13

		var_175_3[#var_175_3 + 1] = {
			pass_type = "texture",
			content_id = var_175_16,
			texture_id = var_175_20,
			style_id = var_175_20
		}
		var_175_5[var_175_20] = {
			size = {
				var_175_10[1],
				math.min(var_175_10[2] - 5, 80)
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_175_15[1],
				var_175_15[2] + 5,
				2
			}
		}
		var_175_17[var_175_20] = "button_state_default"

		local var_175_21 = "clicked_rect" .. var_175_13

		var_175_3[#var_175_3 + 1] = {
			pass_type = "rect",
			content_id = var_175_16,
			style_id = var_175_21
		}
		var_175_5[var_175_21] = {
			size = var_175_10,
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				var_175_15[1],
				var_175_15[2],
				6
			}
		}

		local var_175_22 = "glass_top" .. var_175_13

		var_175_3[#var_175_3 + 1] = {
			pass_type = "texture",
			content_id = var_175_16,
			texture_id = var_175_22,
			style_id = var_175_22
		}
		var_175_5[var_175_22] = {
			size = {
				var_175_10[1],
				11
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_175_15[1],
				var_175_15[2] + var_175_10[2] - 11,
				5
			}
		}
		var_175_17[var_175_22] = "button_glass_02"

		local var_175_23 = "glass_bottom" .. var_175_13

		var_175_3[#var_175_3 + 1] = {
			pass_type = "texture",
			content_id = var_175_16,
			texture_id = var_175_23,
			style_id = var_175_23
		}
		var_175_5[var_175_23] = {
			size = {
				var_175_10[1],
				11
			},
			color = {
				100,
				255,
				255,
				255
			},
			offset = {
				var_175_15[1],
				var_175_15[2] - 3,
				5
			}
		}
		var_175_17[var_175_23] = "button_glass_02"

		local var_175_24 = "icon" .. var_175_13

		var_175_3[#var_175_3 + 1] = {
			pass_type = "texture",
			content_id = var_175_16,
			texture_id = var_175_24,
			style_id = var_175_24
		}
		var_175_5[var_175_24] = {
			size = var_175_11,
			color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			select_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				var_175_15[1] + var_175_10[1] / 2 - var_175_11[1] / 2,
				var_175_15[2] + var_175_10[2] / 2 - var_175_11[1] / 2 + 4,
				4
			}
		}
		var_175_17[var_175_24] = "tabs_inventory_icon_trinkets_selected"

		local var_175_25 = "icon_shadow" .. var_175_13

		var_175_3[#var_175_3 + 1] = {
			pass_type = "texture",
			content_id = var_175_16,
			texture_id = var_175_24,
			style_id = var_175_25
		}
		var_175_5[var_175_25] = {
			size = var_175_11,
			color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_175_15[1] + var_175_10[1] / 2 - var_175_11[1] / 2 + 2,
				var_175_15[2] + var_175_10[2] / 2 - var_175_11[1] / 2 + 2,
				3
			}
		}
		var_175_12 = var_175_12 + var_175_9 + var_175_6
	end

	var_175_2.element.passes = var_175_3
	var_175_2.content = var_175_4
	var_175_2.style = var_175_5
	var_175_2.offset = {
		0,
		0,
		0
	}
	var_175_2.scenegraph_id = arg_175_0

	return var_175_2
end

UIWidgets.create_default_checkbox_button = function (arg_176_0, arg_176_1, arg_176_2, arg_176_3, arg_176_4, arg_176_5, arg_176_6)
	local var_176_0 = "button_bg_01"
	local var_176_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_176_0)
	local var_176_2 = {
		element = {}
	}
	local var_176_3 = {}
	local var_176_4 = {}
	local var_176_5 = {}
	local var_176_6 = {
		0,
		0,
		0
	}
	local var_176_7 = "button_hotspot"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "hotspot",
		content_id = var_176_7,
		style_id = var_176_7
	}
	var_176_5[var_176_7] = {
		size = arg_176_1,
		offset = var_176_6
	}
	var_176_4[var_176_7] = {}

	local var_176_8 = var_176_4[var_176_7]
	local var_176_9 = "background"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "texture_uv",
		content_id = var_176_9,
		style_id = var_176_9
	}
	var_176_5[var_176_9] = {
		size = arg_176_1,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_176_6[1],
			var_176_6[2],
			0
		}
	}
	var_176_4[var_176_9] = {
		uvs = {
			{
				0,
				1 - math.min(arg_176_1[2] / var_176_1.size[2], 1)
			},
			{
				math.min(arg_176_1[1] / var_176_1.size[1], 1),
				1
			}
		},
		texture_id = var_176_0
	}

	local var_176_10 = "background_fade"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "texture",
		content_id = var_176_7,
		texture_id = var_176_10,
		style_id = var_176_10
	}
	var_176_5[var_176_10] = {
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
			var_176_6[1],
			var_176_6[2],
			1
		}
	}
	var_176_8[var_176_10] = "button_bg_fade"

	local var_176_11 = "hover_glow"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "texture",
		content_id = var_176_7,
		texture_id = var_176_11,
		style_id = var_176_11
	}
	var_176_5[var_176_11] = {
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
			var_176_6[1],
			var_176_6[2] + 5,
			2
		}
	}
	var_176_8[var_176_11] = "button_state_default"

	local var_176_12 = "clicked_rect"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "rect",
		content_id = var_176_7,
		style_id = var_176_12
	}
	var_176_5[var_176_12] = {
		size = arg_176_1,
		color = {
			100,
			0,
			0,
			0
		},
		offset = {
			var_176_6[1],
			var_176_6[2],
			6
		}
	}

	local var_176_13 = "glass_top"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "texture",
		content_id = var_176_7,
		texture_id = var_176_13,
		style_id = var_176_13
	}
	var_176_5[var_176_13] = {
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
			var_176_6[1],
			var_176_6[2] + arg_176_1[2] - 11,
			5
		}
	}
	var_176_8[var_176_13] = "button_glass_02"

	local var_176_14 = "glass_bottom"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "texture",
		content_id = var_176_7,
		texture_id = var_176_14,
		style_id = var_176_14
	}
	var_176_5[var_176_14] = {
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
			var_176_6[1],
			var_176_6[2] - 3,
			5
		}
	}
	var_176_8[var_176_14] = "button_glass_02"

	if arg_176_4 then
		local var_176_15 = "additional_option_info"

		var_176_3[#var_176_3 + 1] = {
			pass_type = "additional_option_tooltip",
			content_id = var_176_7,
			style_id = var_176_15,
			additional_option_id = var_176_15,
			content_check_function = function (arg_177_0)
				return arg_177_0.is_hover
			end
		}
		var_176_8[var_176_15] = arg_176_4
		var_176_5[var_176_15] = {
			grow_downwards = false,
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			offset = {
				arg_176_5 and arg_176_1[1] or 0,
				arg_176_5 and arg_176_1[2] or 0,
				0
			}
		}
	end

	local var_176_16 = "text"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "text",
		content_id = var_176_7,
		text_id = var_176_16,
		style_id = var_176_16,
		content_check_function = function (arg_178_0)
			return not arg_178_0.disable_button
		end
	}
	var_176_5[var_176_16] = {
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
			var_176_6[1] + 10,
			var_176_6[2] + 3,
			4
		},
		size = arg_176_1
	}
	var_176_8[var_176_16] = arg_176_2

	local var_176_17 = "text_disabled"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "text",
		content_id = var_176_7,
		text_id = var_176_16,
		style_id = var_176_17,
		content_check_function = function (arg_179_0)
			return arg_179_0.disable_button
		end
	}
	var_176_5[var_176_17] = {
		upper_case = true,
		font_size = 24,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("gray", 255),
		default_text_color = Colors.get_color_table_with_alpha("gray", 255),
		offset = {
			var_176_6[1] + 10,
			var_176_6[2] + 3,
			4
		},
		size = arg_176_1
	}

	local var_176_18 = "text_shadow"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "text",
		content_id = var_176_7,
		text_id = var_176_16,
		style_id = var_176_18
	}
	var_176_5[var_176_18] = {
		font_size = 24,
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			var_176_6[1] + 10 + 2,
			var_176_6[2] + 1,
			3
		},
		size = arg_176_1
	}

	local var_176_19 = "checkbox_background"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "rect",
		style_id = var_176_19
	}

	local var_176_20 = {
		25,
		25
	}
	local var_176_21 = {
		arg_176_1[1] - var_176_20[1] + var_176_6[1] - 20,
		var_176_6[2] + arg_176_1[2] / 2 - var_176_20[2] / 2 + 2,
		3
	}

	var_176_5[var_176_19] = {
		size = {
			var_176_20[1],
			var_176_20[2]
		},
		offset = var_176_21,
		color = {
			255,
			0,
			0,
			0
		}
	}

	local var_176_22 = "checkbox_frame"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "texture_frame",
		content_id = var_176_7,
		texture_id = var_176_22,
		style_id = var_176_22,
		content_check_function = function (arg_180_0)
			return not arg_180_0.is_disabled
		end
	}
	arg_176_6 = arg_176_6 or "menu_frame_06"

	local var_176_23 = UIFrameSettings[arg_176_6]

	var_176_8[var_176_22] = var_176_23.texture
	var_176_5[var_176_22] = {
		size = {
			var_176_20[1],
			var_176_20[2]
		},
		texture_size = var_176_23.texture_size,
		texture_sizes = var_176_23.texture_sizes,
		offset = {
			var_176_21[1],
			var_176_21[2],
			var_176_21[3] + 1
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	local var_176_24 = "checkbox_frame_disabled"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "texture_frame",
		content_id = var_176_7,
		texture_id = var_176_22,
		style_id = var_176_24,
		content_check_function = function (arg_181_0)
			return not arg_181_0.is_disabled
		end
	}
	var_176_5[var_176_24] = {
		size = {
			var_176_20[1],
			var_176_20[2]
		},
		texture_size = var_176_23.texture_size,
		texture_sizes = var_176_23.texture_sizes,
		offset = {
			var_176_21[1],
			var_176_21[2],
			var_176_21[3] + 1
		},
		color = {
			96,
			255,
			255,
			255
		}
	}

	local var_176_25 = "checkbox_marker"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "texture",
		content_id = var_176_7,
		texture_id = var_176_25,
		style_id = var_176_25,
		content_check_function = function (arg_182_0)
			return arg_182_0.is_selected and not arg_182_0.disable_button
		end
	}
	var_176_8[var_176_25] = "matchmaking_checkbox"

	local var_176_26 = {
		22,
		16
	}
	local var_176_27 = {
		var_176_21[1] + 4,
		var_176_21[2] + var_176_26[2] / 2 - 1,
		var_176_21[3] + 2
	}

	var_176_5[var_176_25] = {
		size = var_176_26,
		offset = var_176_27,
		color = Colors.get_color_table_with_alpha("white", 255)
	}

	local var_176_28 = "checkbox_marker_disabled"

	var_176_3[#var_176_3 + 1] = {
		pass_type = "texture",
		content_id = var_176_7,
		texture_id = var_176_25,
		style_id = var_176_28,
		content_check_function = function (arg_183_0)
			return arg_183_0.is_selected and arg_183_0.disable_button
		end
	}
	var_176_5[var_176_28] = {
		size = var_176_26,
		offset = var_176_27,
		color = Colors.get_color_table_with_alpha("gray", 255)
	}
	var_176_2.element.passes = var_176_3
	var_176_2.content = var_176_4
	var_176_2.style = var_176_5
	var_176_2.offset = {
		0,
		0,
		0
	}
	var_176_2.scenegraph_id = arg_176_0

	return var_176_2
end

UIWidgets.create_default_checkbox_button_console = function (arg_184_0, arg_184_1, arg_184_2, arg_184_3, arg_184_4, arg_184_5, arg_184_6)
	local var_184_0 = "button_bg_01"
	local var_184_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_184_0)
	local var_184_2 = {
		element = {}
	}
	local var_184_3 = {}
	local var_184_4 = {}
	local var_184_5 = {}
	local var_184_6 = {
		0,
		0,
		0
	}
	local var_184_7 = "button_hotspot"

	var_184_3[#var_184_3 + 1] = {
		pass_type = "hotspot",
		content_id = var_184_7,
		style_id = var_184_7
	}
	var_184_5[var_184_7] = {
		size = arg_184_1,
		offset = var_184_6
	}
	var_184_4[var_184_7] = {}

	local var_184_8 = var_184_4[var_184_7]
	local var_184_9 = "hover_glow"

	if not arg_184_6 then
		var_184_3[#var_184_3 + 1] = {
			pass_type = "texture",
			content_id = var_184_7,
			texture_id = var_184_9,
			style_id = var_184_9
		}
	end

	var_184_5[var_184_9] = {
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
			var_184_6[1],
			var_184_6[2] + 5,
			2
		}
	}
	var_184_8[var_184_9] = "button_state_default"

	local var_184_10 = "clicked_rect"

	var_184_3[#var_184_3 + 1] = {
		pass_type = "rect",
		content_id = var_184_7,
		style_id = var_184_10
	}
	var_184_5[var_184_10] = {
		size = arg_184_1,
		color = {
			100,
			0,
			0,
			0
		},
		offset = {
			var_184_6[1],
			var_184_6[2],
			6
		}
	}

	if arg_184_4 then
		var_184_4.tooltip_info = arg_184_4
	end

	local var_184_11 = {
		25,
		25
	}
	local var_184_12 = {
		var_184_6[1] + var_184_11[1] + 15,
		var_184_6[2] + 4,
		4
	}
	local var_184_13 = "text"

	var_184_3[#var_184_3 + 1] = {
		pass_type = "text",
		content_id = var_184_7,
		text_id = var_184_13,
		style_id = var_184_13,
		content_check_function = function (arg_185_0)
			return not arg_185_0.disable_button
		end
	}
	var_184_5[var_184_13] = {
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
			var_184_12[1],
			var_184_12[2],
			var_184_12[3]
		},
		size = arg_184_1
	}
	var_184_8[var_184_13] = arg_184_2

	local var_184_14 = "text_disabled"

	var_184_3[#var_184_3 + 1] = {
		pass_type = "text",
		content_id = var_184_7,
		text_id = var_184_13,
		style_id = var_184_14,
		content_check_function = function (arg_186_0)
			return arg_186_0.disable_button
		end
	}
	var_184_5[var_184_14] = {
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = arg_184_3 or 24,
		text_color = Colors.get_color_table_with_alpha("gray", 255),
		default_text_color = Colors.get_color_table_with_alpha("gray", 255),
		offset = {
			var_184_12[1],
			var_184_12[2],
			var_184_12[3]
		},
		size = arg_184_1
	}

	local var_184_15 = "text_shadow"

	var_184_3[#var_184_3 + 1] = {
		pass_type = "text",
		content_id = var_184_7,
		text_id = var_184_13,
		style_id = var_184_15
	}
	var_184_5[var_184_15] = {
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = arg_184_3 or 24,
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			var_184_12[1] + 2,
			var_184_12[2] - 2,
			var_184_12[3] - 1
		},
		size = arg_184_1
	}

	local var_184_16 = "checkbox_background"

	var_184_3[#var_184_3 + 1] = {
		pass_type = "rect",
		style_id = var_184_16
	}

	local var_184_17 = {
		var_184_6[1] + 10,
		var_184_6[2] + arg_184_1[2] / 2 - var_184_11[2] / 2 + 2,
		3
	}

	var_184_5[var_184_16] = {
		size = {
			var_184_11[1],
			var_184_11[2]
		},
		offset = var_184_17,
		color = {
			255,
			0,
			0,
			0
		}
	}

	local var_184_18 = "checkbox_frame"

	var_184_3[#var_184_3 + 1] = {
		pass_type = "texture_frame",
		content_id = var_184_7,
		texture_id = var_184_18,
		style_id = var_184_18,
		content_check_function = function (arg_187_0)
			return not arg_187_0.is_disabled
		end
	}
	arg_184_5 = arg_184_5 or "menu_frame_06"

	local var_184_19 = UIFrameSettings[arg_184_5]

	var_184_8[var_184_18] = var_184_19.texture
	var_184_5[var_184_18] = {
		size = {
			var_184_11[1],
			var_184_11[2]
		},
		texture_size = var_184_19.texture_size,
		texture_sizes = var_184_19.texture_sizes,
		offset = {
			var_184_17[1],
			var_184_17[2],
			var_184_17[3] + 1
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	local var_184_20 = "checkbox_frame_disabled"

	var_184_3[#var_184_3 + 1] = {
		pass_type = "texture_frame",
		content_id = var_184_7,
		texture_id = var_184_18,
		style_id = var_184_20,
		content_check_function = function (arg_188_0)
			return not arg_188_0.is_disabled
		end
	}
	var_184_5[var_184_20] = {
		size = {
			var_184_11[1],
			var_184_11[2]
		},
		texture_size = var_184_19.texture_size,
		texture_sizes = var_184_19.texture_sizes,
		offset = {
			var_184_17[1],
			var_184_17[2],
			var_184_17[3] + 1
		},
		color = {
			96,
			255,
			255,
			255
		}
	}

	local var_184_21 = "checkbox_marker"

	var_184_3[#var_184_3 + 1] = {
		pass_type = "texture",
		content_id = var_184_7,
		texture_id = var_184_21,
		style_id = var_184_21,
		content_check_function = function (arg_189_0)
			return arg_189_0.is_selected and not arg_189_0.disable_button
		end
	}
	var_184_8[var_184_21] = "matchmaking_checkbox"

	local var_184_22 = {
		22,
		16
	}
	local var_184_23 = {
		var_184_17[1] + 4,
		var_184_17[2] + var_184_22[2] / 2 - 1,
		var_184_17[3] + 2
	}

	var_184_5[var_184_21] = {
		size = var_184_22,
		offset = var_184_23,
		color = Colors.get_color_table_with_alpha("white", 255)
	}

	local var_184_24 = "checkbox_marker_disabled"

	var_184_3[#var_184_3 + 1] = {
		pass_type = "texture",
		content_id = var_184_7,
		texture_id = var_184_21,
		style_id = var_184_24,
		content_check_function = function (arg_190_0)
			return arg_190_0.is_selected and arg_190_0.disable_button
		end
	}
	var_184_5[var_184_24] = {
		size = var_184_22,
		offset = var_184_23,
		color = Colors.get_color_table_with_alpha("gray", 255)
	}
	var_184_2.element.passes = var_184_3
	var_184_2.content = var_184_4
	var_184_2.style = var_184_5
	var_184_2.offset = {
		0,
		0,
		0
	}
	var_184_2.scenegraph_id = arg_184_0

	return var_184_2
end

UIWidgets.create_default_text_tabs = function (arg_191_0, arg_191_1, arg_191_2)
	local var_191_0 = "button_bg_01"
	local var_191_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_191_0)
	local var_191_2 = {
		element = {}
	}
	local var_191_3 = {}
	local var_191_4 = {
		amount = arg_191_2
	}
	local var_191_5 = {}
	local var_191_6 = 0
	local var_191_7 = 0
	local var_191_8 = -var_191_6
	local var_191_9 = (arg_191_1[1] - var_191_6 * (arg_191_2 - 1)) / arg_191_2
	local var_191_10 = {
		var_191_9,
		arg_191_1[2]
	}
	local var_191_11 = {
		34,
		34
	}
	local var_191_12 = 0

	for iter_191_0 = 1, arg_191_2 do
		local var_191_13 = "_" .. tostring(iter_191_0)
		local var_191_14 = iter_191_0 - 1

		var_191_8 = var_191_8 + var_191_10[1] + var_191_6

		local var_191_15 = {
			var_191_12,
			0,
			var_191_7
		}
		local var_191_16 = "hotspot" .. var_191_13

		var_191_3[#var_191_3 + 1] = {
			pass_type = "hotspot",
			content_id = var_191_16,
			style_id = var_191_16
		}
		var_191_5[var_191_16] = {
			size = var_191_10,
			offset = var_191_15
		}
		var_191_4[var_191_16] = {}

		local var_191_17 = var_191_4[var_191_16]
		local var_191_18 = "background" .. var_191_13

		var_191_3[#var_191_3 + 1] = {
			pass_type = "texture_uv",
			content_id = var_191_18,
			style_id = var_191_18
		}
		var_191_5[var_191_18] = {
			size = var_191_10,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_191_15[1],
				var_191_15[2],
				0
			}
		}
		var_191_4[var_191_18] = {
			uvs = {
				{
					0,
					1 - math.min(var_191_10[2] / var_191_1.size[2], 1)
				},
				{
					math.min(var_191_10[1] / var_191_1.size[1], 1),
					1
				}
			},
			texture_id = var_191_0
		}

		local var_191_19 = "background_fade" .. var_191_13

		var_191_3[#var_191_3 + 1] = {
			pass_type = "texture",
			content_id = var_191_16,
			texture_id = var_191_19,
			style_id = var_191_19
		}
		var_191_5[var_191_19] = {
			size = {
				var_191_10[1],
				var_191_10[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_191_15[1],
				var_191_15[2],
				1
			}
		}
		var_191_17[var_191_19] = "button_bg_fade"

		local var_191_20 = "hover_glow" .. var_191_13

		var_191_3[#var_191_3 + 1] = {
			pass_type = "texture",
			content_id = var_191_16,
			texture_id = var_191_20,
			style_id = var_191_20
		}
		var_191_5[var_191_20] = {
			size = {
				var_191_10[1],
				math.min(var_191_10[2] - 5, 80)
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_191_15[1],
				var_191_15[2] + 5,
				2
			}
		}
		var_191_17[var_191_20] = "button_state_default"

		local var_191_21 = "clicked_rect" .. var_191_13

		var_191_3[#var_191_3 + 1] = {
			pass_type = "rect",
			content_id = var_191_16,
			style_id = var_191_21
		}
		var_191_5[var_191_21] = {
			size = var_191_10,
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				var_191_15[1],
				var_191_15[2],
				6
			}
		}

		local var_191_22 = "glass_top" .. var_191_13

		var_191_3[#var_191_3 + 1] = {
			pass_type = "texture",
			content_id = var_191_16,
			texture_id = var_191_22,
			style_id = var_191_22
		}
		var_191_5[var_191_22] = {
			size = {
				var_191_10[1],
				11
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_191_15[1],
				var_191_15[2] + var_191_10[2] - 11,
				5
			}
		}
		var_191_17[var_191_22] = "button_glass_02"

		local var_191_23 = "glass_bottom" .. var_191_13

		var_191_3[#var_191_3 + 1] = {
			pass_type = "texture",
			content_id = var_191_16,
			texture_id = var_191_23,
			style_id = var_191_23
		}
		var_191_5[var_191_23] = {
			size = {
				var_191_10[1],
				11
			},
			color = {
				100,
				255,
				255,
				255
			},
			offset = {
				var_191_15[1],
				var_191_15[2] - 3,
				5
			}
		}
		var_191_17[var_191_23] = "button_glass_02"

		local var_191_24 = "text" .. var_191_13

		var_191_3[#var_191_3 + 1] = {
			pass_type = "text",
			content_id = var_191_16,
			text_id = var_191_24,
			style_id = var_191_24,
			content_check_function = function (arg_192_0)
				return not arg_192_0.disable_button
			end
		}
		var_191_5[var_191_24] = {
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
				var_191_15[1],
				var_191_15[2] + 3,
				4
			},
			size = var_191_10
		}
		var_191_17[var_191_24] = Localize("not_assigned")

		local var_191_25 = "text_disabled" .. var_191_13

		var_191_3[#var_191_3 + 1] = {
			pass_type = "text",
			content_id = var_191_16,
			text_id = var_191_24,
			style_id = var_191_25,
			content_check_function = function (arg_193_0)
				return arg_193_0.disable_button
			end
		}
		var_191_5[var_191_25] = {
			upper_case = true,
			font_size = 24,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("gray", 255),
			default_text_color = Colors.get_color_table_with_alpha("gray", 255),
			offset = {
				var_191_15[1],
				var_191_15[2] + 3,
				4
			},
			size = var_191_10
		}

		local var_191_26 = "text_shadow" .. var_191_13

		var_191_3[#var_191_3 + 1] = {
			pass_type = "text",
			content_id = var_191_16,
			text_id = var_191_24,
			style_id = var_191_26
		}
		var_191_5[var_191_26] = {
			font_size = 24,
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_191_15[1] + 2,
				var_191_15[2] + 1,
				3
			},
			size = var_191_10
		}
		var_191_12 = var_191_12 + var_191_9 + var_191_6
	end

	var_191_2.element.passes = var_191_3
	var_191_2.content = var_191_4
	var_191_2.style = var_191_5
	var_191_2.offset = {
		0,
		0,
		0
	}
	var_191_2.scenegraph_id = arg_191_0

	return var_191_2
end

UIWidgets.create_simple_window_button = function (arg_194_0, arg_194_1, arg_194_2, arg_194_3, arg_194_4)
	arg_194_4 = arg_194_4 or "button_bg_01"

	local var_194_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_194_4)

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
					content_check_function = function (arg_195_0)
						return arg_195_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_196_0)
						return not arg_196_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_197_0)
						return arg_197_0.button_hotspot.disable_button
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
						1 - arg_194_1[2] / var_194_0.size[2]
					},
					{
						arg_194_1[1] / var_194_0.size[1],
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
	arg_198_3 = arg_198_3 or "options_button_icon_quickplay"

	local var_198_0 = arg_198_3 .. "_glow"
	local var_198_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_198_3).size
	local var_198_2 = "button_bg_01"
	local var_198_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_198_2)
	local var_198_4 = "menu_frame_08"
	local var_198_5 = UIFrameSettings[var_198_4]
	local var_198_6 = var_198_5.texture_sizes.corner[1]
	local var_198_7 = "frame_outer_glow_01"
	local var_198_8 = UIFrameSettings[var_198_7].texture_sizes.corner[1]

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
					content_check_function = function (arg_199_0)
						return arg_199_0.background_icon
					end,
					content_change_function = function (arg_200_0, arg_200_1)
						local var_200_0 = arg_200_0.button_hotspot

						if not var_200_0.disable_button and not var_200_0.is_selected then
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
					content_check_function = function (arg_201_0)
						return arg_201_0.new
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (arg_202_0)
						return not arg_202_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "icon",
					style_id = "icon_disabled",
					pass_type = "texture",
					content_check_function = function (arg_203_0)
						return arg_203_0.button_hotspot.disable_button
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
					content_check_function = function (arg_204_0)
						return not arg_204_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (arg_205_0)
						return arg_205_0.button_hotspot.disable_button
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
					content_check_function = function (arg_206_0)
						return arg_206_0.button_hotspot.disable_button
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
			icon_selected = var_198_0,
			frame = var_198_5.texture,
			button_hotspot = {},
			button_text = arg_198_2 or "n/a",
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_198_1[2] / var_198_3.size[2], 1)
					},
					{
						math.min(arg_198_1[1] / var_198_3.size[1], 1),
						1
					}
				},
				texture_id = var_198_2
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
				texture_size = var_198_1,
				offset = {
					54 - var_198_1[1] / 2,
					54 - var_198_1[2] / 2,
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
				texture_size = var_198_1,
				offset = {
					54 - var_198_1[1] / 2,
					54 - var_198_1[2] / 2,
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
				texture_size = var_198_1,
				offset = {
					54 - var_198_1[1] / 2,
					54 - var_198_1[2] / 2,
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
	arg_207_3 = arg_207_3 or "options_button_icon_quickplay"

	local var_207_0 = arg_207_3 .. "_glow"
	local var_207_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_207_3).size
	local var_207_2 = "button_bg_01"
	local var_207_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_207_2)
	local var_207_4 = "menu_frame_08"
	local var_207_5 = UIFrameSettings[var_207_4]
	local var_207_6 = var_207_5.texture_sizes.corner[1]
	local var_207_7 = "frame_outer_glow_01"
	local var_207_8 = UIFrameSettings[var_207_7].texture_sizes.corner[1]

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
					content_check_function = function (arg_208_0)
						return arg_208_0.texture_id
					end,
					content_change_function = function (arg_209_0, arg_209_1)
						local var_209_0 = arg_209_0.parent.button_hotspot

						if not var_209_0.disable_button and not var_209_0.is_selected then
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
					content_check_function = function (arg_210_0)
						return arg_210_0.parent.new
					end
				},
				{
					style_id = "icon",
					pass_type = "texture_uv",
					content_id = "icon",
					content_check_function = function (arg_211_0)
						return not arg_211_0.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "icon_disabled",
					pass_type = "texture_uv",
					content_id = "icon",
					content_check_function = function (arg_212_0)
						return arg_212_0.parent.button_hotspot.disable_button
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
					content_check_function = function (arg_213_0)
						return not arg_213_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (arg_214_0)
						return arg_214_0.button_hotspot.disable_button
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
					content_check_function = function (arg_215_0)
						return arg_215_0.button_hotspot.disable_button
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
			icon_selected = var_207_0,
			frame = var_207_5.texture,
			button_hotspot = {},
			button_text = arg_207_2 or "n/a",
			background = {
				uvs = {
					{
						0,
						1 - math.min(arg_207_1[2] / var_207_3.size[2], 1)
					},
					{
						math.min(arg_207_1[1] / var_207_3.size[1], 1),
						1
					}
				},
				texture_id = var_207_2
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
				texture_size = var_207_1,
				offset = {
					arg_207_1[1] - var_207_1[1] - (54 - var_207_1[1] / 2),
					54 - var_207_1[2] / 2,
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
				texture_size = var_207_1,
				offset = {
					arg_207_1[1] - var_207_1[1] - (54 - var_207_1[1] / 2),
					54 - var_207_1[2] / 2,
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
				texture_size = var_207_1,
				offset = {
					arg_207_1[1] - var_207_1[1] - (54 - var_207_1[1] / 2),
					54 - var_207_1[2] / 2,
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
	local var_216_0
	local var_216_1 = "green"

	if var_216_1 then
		var_216_0 = "button_" .. var_216_1
	else
		var_216_0 = "button_normal"
	end

	local var_216_2 = Colors.get_color_table_with_alpha(var_216_0, 255)
	local var_216_3 = "button_bg_01"
	local var_216_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_216_3)
	local var_216_5 = UIFrameSettings.menu_frame_08
	local var_216_6 = "button_detail_05_glow"
	local var_216_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_216_6).size

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
					content_check_function = function (arg_217_0)
						local var_217_0 = arg_217_0.button_hotspot.is_clicked

						return not var_217_0 or var_217_0 == 0
					end
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (arg_218_0)
						return arg_218_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_right",
					style_id = "side_detail_right",
					pass_type = "texture",
					content_check_function = function (arg_219_0)
						return not arg_219_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_left",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_check_function = function (arg_220_0)
						return not arg_220_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_right",
					style_id = "side_detail_right_disabled",
					pass_type = "texture",
					content_check_function = function (arg_221_0)
						return arg_221_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_left",
					style_id = "side_detail_left_disabled",
					pass_type = "texture",
					content_check_function = function (arg_222_0)
						return arg_222_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_glow_right",
					pass_type = "texture_uv",
					content_id = "side_detail_glow",
					content_check_function = function (arg_223_0)
						return not arg_223_0.parent.button_hotspot.disable_button
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_glow_left",
					pass_type = "texture",
					content_id = "side_detail_glow",
					content_check_function = function (arg_224_0)
						return not arg_224_0.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_225_0)
						return not arg_225_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_226_0)
						return arg_226_0.button_hotspot.disable_button
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
					content_check_function = function (arg_227_0)
						return not arg_227_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (arg_228_0)
						local var_228_0 = arg_228_0.button_hotspot

						return not var_228_0.disable_button and (var_228_0.is_selected or var_228_0.is_hover)
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
				texture_id = var_216_6
			},
			button_hotspot = {},
			title_text = arg_216_2 or "n/a",
			frame = var_216_5.texture,
			disable_with_gamepad = arg_216_4,
			background = {
				uvs = {
					{
						0,
						1 - arg_216_1[2] / var_216_4.size[2]
					},
					{
						arg_216_1[1] / var_216_4.size[1],
						1
					}
				},
				texture_id = var_216_3
			}
		},
		style = {
			background = {
				color = var_216_2,
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
				texture_size = var_216_5.texture_size,
				texture_sizes = var_216_5.texture_sizes,
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
					var_216_5.texture_sizes.horizontal[2],
					1
				},
				size = {
					arg_216_1[1],
					math.min(60, arg_216_1[2] - var_216_5.texture_sizes.horizontal[2] * 2)
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
					arg_216_1[2] - var_216_5.texture_sizes.horizontal[2] - 4,
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
					var_216_5.texture_sizes.horizontal[2] - 1,
					3
				},
				size = {
					arg_216_1[1],
					math.min(60, arg_216_1[2] - var_216_5.texture_sizes.horizontal[2] * 2)
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
					arg_216_1[2] / 2 - var_216_7[2] / 2,
					10
				},
				size = {
					var_216_7[1],
					var_216_7[2]
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
					arg_216_1[1] - var_216_7[1],
					arg_216_1[2] / 2 - var_216_7[2] / 2,
					10
				},
				size = {
					var_216_7[1],
					var_216_7[2]
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
	arg_229_3 = arg_229_3 or "menu_frame_bg_06"

	local var_229_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_229_3)
	local var_229_1 = arg_229_2 and UIFrameSettings[arg_229_2] or UIFrameSettings.menu_frame_06
	local var_229_2 = var_229_1.texture_sizes.corner[1]
	local var_229_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_229_4).size

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
					content_check_function = function (arg_230_0)
						local var_230_0 = arg_230_0.button_hotspot

						return not var_230_0.disable_button and (var_230_0.is_selected or var_230_0.is_hover)
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
						arg_229_1[1] / var_229_0.size[1],
						arg_229_1[2] / var_229_0.size[2]
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
				texture_size = var_229_3,
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
	arg_231_3 = arg_231_3 or "menu_frame_bg_06"

	local var_231_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_231_3)
	local var_231_1 = var_231_0 and var_231_0.size or arg_231_1
	local var_231_2 = arg_231_2 and UIFrameSettings[arg_231_2] or UIFrameSettings.menu_frame_06
	local var_231_3 = {
		28,
		34
	}
	local var_231_4 = {
		50,
		arg_231_1[2]
	}
	local var_231_5 = {
		-var_231_4[1],
		0,
		0
	}
	local var_231_6 = {
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
					content_check_function = function (arg_232_0)
						local var_232_0 = arg_232_0.button_hotspot_left
						local var_232_1 = arg_232_0.button_hotspot_right

						return not var_232_0.disable_button and not var_232_1.disable_button
					end
				},
				{
					style_id = "setting_text_disabled",
					pass_type = "text",
					text_id = "setting_text",
					content_check_function = function (arg_233_0)
						local var_233_0 = arg_233_0.button_hotspot_left
						local var_233_1 = arg_233_0.button_hotspot_right

						return var_233_0.disable_button and var_233_1.disable_button
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
					content_check_function = function (arg_234_0)
						local var_234_0 = arg_234_0.button_hotspot_left

						return not var_234_0.disable_button and (var_234_0.is_selected or var_234_0.is_hover)
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
					content_check_function = function (arg_235_0)
						local var_235_0 = arg_235_0.button_hotspot_right

						return not var_235_0.disable_button and (var_235_0.is_selected or var_235_0.is_hover)
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
						arg_231_1[1] / var_231_1[1],
						arg_231_1[2] / var_231_1[2]
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
						var_231_4[1] / var_231_1[1],
						var_231_4[2] / var_231_1[2]
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
					var_231_5[1],
					var_231_4[2] - var_231_2.texture_sizes.horizontal[2] - 3,
					4
				},
				size = {
					var_231_4[1],
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
					var_231_5[1],
					var_231_2.texture_sizes.horizontal[2],
					4
				},
				size = {
					var_231_4[1],
					3
				}
			},
			left_glow = {
				size = var_231_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_231_5[1],
					var_231_5[2],
					1
				}
			},
			left_frame = {
				size = var_231_4,
				texture_size = var_231_2.texture_size,
				texture_sizes = var_231_2.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_231_5[1],
					var_231_5[2],
					5
				}
			},
			left_background = {
				size = var_231_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = var_231_5
			},
			left_button_icon = {
				size = var_231_3,
				offset = {
					var_231_5[1] + (var_231_4[1] / 2 - var_231_3[1] / 2),
					var_231_5[2] + (var_231_4[2] / 2 - var_231_3[2] / 2),
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
				size = var_231_3,
				offset = {
					var_231_5[1] + (var_231_4[1] / 2 - var_231_3[1] / 2),
					var_231_5[2] + (var_231_4[2] / 2 - var_231_3[2] / 2),
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
					var_231_6[1],
					var_231_4[2] - var_231_2.texture_sizes.horizontal[2] - 3,
					4
				},
				size = {
					var_231_4[1],
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
					var_231_6[1],
					var_231_2.texture_sizes.horizontal[2],
					4
				},
				size = {
					var_231_4[1],
					3
				}
			},
			right_glow = {
				size = var_231_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_231_6[1],
					var_231_6[2],
					1
				}
			},
			right_frame = {
				size = var_231_4,
				texture_size = var_231_2.texture_size,
				texture_sizes = var_231_2.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_231_6[1],
					var_231_6[2],
					5
				}
			},
			right_background = {
				size = var_231_4,
				color = {
					255,
					255,
					255,
					255
				},
				offset = var_231_6
			},
			right_button_icon = {
				angle = math.degrees_to_radians(180),
				pivot = {
					14,
					17
				},
				size = var_231_3,
				offset = {
					var_231_6[1] + (var_231_4[1] / 2 - var_231_3[1] / 2),
					var_231_6[2] + (var_231_4[2] / 2 - var_231_3[2] / 2),
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
				size = var_231_3,
				offset = {
					var_231_6[1] + (var_231_4[1] / 2 - var_231_3[1] / 2),
					var_231_6[2] + (var_231_4[2] / 2 - var_231_3[2] / 2),
					3
				}
			}
		},
		scenegraph_id = arg_231_0
	}
end

UIWidgets.create_title_and_tooltip = function (arg_236_0, arg_236_1, arg_236_2, arg_236_3, arg_236_4, arg_236_5)
	local var_236_0

	if arg_236_4 then
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
					content_check_function = function (arg_237_0)
						return not arg_237_0.disabled
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_238_0)
						return arg_238_0.disabled
					end
				},
				{
					pass_type = "hotspot",
					content_id = "tooltip_hotspot",
					content_check_function = function (arg_239_0)
						return not arg_239_0.disabled
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "tooltip_text",
					text_id = "tooltip_text",
					content_check_function = function (arg_240_0)
						return not arg_240_0.disabled and arg_240_0.tooltip_hotspot.is_hover
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
	local var_241_0 = {
		255,
		255,
		255,
		255
	}
	local var_241_1 = Colors.get_color_table_with_alpha("font_title", 255)
	local var_241_2 = #arg_241_2
	local var_241_3 = {
		element = {}
	}
	local var_241_4 = {}
	local var_241_5 = {
		amount = var_241_2,
		disable_cross = arg_241_7
	}
	local var_241_6 = {}
	local var_241_7 = arg_241_3 or 0
	local var_241_8 = 0
	local var_241_9 = -var_241_7
	local var_241_10 = 0
	local var_241_11 = UIPlayerPortraitFrameSettings.default

	for iter_241_0 = 1, var_241_2 do
		local var_241_12 = "_" .. tostring(iter_241_0)
		local var_241_13 = iter_241_0 - 1

		var_241_9 = var_241_9 + arg_241_1[1] + var_241_7

		local var_241_14 = {
			var_241_10,
			0,
			var_241_8
		}
		local var_241_15 = "hotspot" .. var_241_12

		var_241_4[#var_241_4 + 1] = {
			pass_type = "hotspot",
			content_id = var_241_15,
			style_id = var_241_15
		}
		var_241_6[var_241_15] = {
			size = arg_241_1,
			offset = var_241_14
		}
		var_241_5[var_241_15] = {
			allow_multi_hover = arg_241_6
		}

		local var_241_16 = var_241_5[var_241_15]
		local var_241_17 = arg_241_2[iter_241_0]
		local var_241_18 = "icon" .. var_241_12

		var_241_4[#var_241_4 + 1] = {
			pass_type = "texture",
			content_id = var_241_15,
			texture_id = var_241_18,
			style_id = var_241_18,
			content_check_function = function (arg_242_0)
				return not arg_242_0.disable_button
			end
		}
		var_241_6[var_241_18] = {
			size = arg_241_1,
			color = var_241_0,
			offset = {
				var_241_14[1],
				var_241_14[2],
				var_241_14[3] + 2
			}
		}
		var_241_16[var_241_18] = var_241_17

		local var_241_19 = arg_241_2[iter_241_0]
		local var_241_20 = "icon" .. var_241_12 .. "_saturated"

		var_241_4[#var_241_4 + 1] = {
			pass_type = "texture",
			content_id = var_241_15,
			texture_id = var_241_20,
			style_id = var_241_20,
			content_check_function = function (arg_243_0)
				return arg_243_0.disable_button
			end
		}
		var_241_6[var_241_20] = {
			size = arg_241_1,
			color = var_241_0,
			default_color = var_241_0,
			disabled_color = {
				255,
				30,
				30,
				30
			},
			offset = {
				var_241_14[1],
				var_241_14[2],
				var_241_14[3] + 2
			}
		}
		var_241_16[var_241_20] = var_241_19 .. "_saturated"

		local var_241_21 = "selection_icon" .. var_241_12

		var_241_4[#var_241_4 + 1] = {
			pass_type = "texture",
			content_id = var_241_15,
			texture_id = var_241_21,
			style_id = var_241_21,
			content_check_function = function (arg_244_0)
				return arg_244_0[var_241_21] and arg_244_0.is_selected
			end
		}
		var_241_6[var_241_21] = {
			size = arg_241_1,
			color = var_241_0,
			offset = {
				var_241_14[1],
				var_241_14[2],
				var_241_14[3] + 3
			},
			default_offset = {
				var_241_14[1],
				var_241_14[2],
				var_241_14[3] + 4
			}
		}

		local var_241_22 = "disabled" .. var_241_12

		var_241_4[#var_241_4 + 1] = {
			pass_type = "texture",
			content_id = var_241_15,
			texture_id = var_241_22,
			style_id = var_241_22,
			content_check_function = function (arg_245_0)
				return arg_245_0.disable_button and not arg_245_0.locked and not arg_245_0.parent.disable_cross
			end
		}
		var_241_6[var_241_22] = {
			saturated = true,
			size = arg_241_1,
			color = var_241_0,
			offset = {
				var_241_14[1],
				var_241_14[2],
				var_241_14[3] + 4
			}
		}
		var_241_16[var_241_22] = "kick_player_icon"

		local var_241_23 = "locked" .. var_241_12

		var_241_4[#var_241_4 + 1] = {
			pass_type = "texture",
			content_id = var_241_15,
			texture_id = var_241_23,
			style_id = var_241_23,
			content_check_function = function (arg_246_0)
				return arg_246_0.locked
			end
		}
		var_241_6[var_241_23] = {
			size = {
				30,
				38
			},
			color = var_241_0,
			offset = {
				var_241_14[1] + arg_241_1[1] / 2 - 15,
				var_241_14[2] + arg_241_1[2] / 2 - 19,
				var_241_14[3] + 5
			}
		}
		var_241_16[var_241_23] = "locked_icon_01"

		if arg_241_4 then
			local var_241_24 = "frame" .. var_241_12

			var_241_4[#var_241_4 + 1] = {
				pass_type = "texture",
				content_id = var_241_15,
				texture_id = var_241_24,
				style_id = var_241_24
			}

			local var_241_25 = arg_241_5 and table.clone(arg_241_5) or {
				86,
				108
			}

			var_241_6[var_241_24] = {
				size = {
					var_241_25[1],
					var_241_25[2]
				},
				color = var_241_0,
				offset = {
					var_241_14[1] + arg_241_1[1] / 2 - var_241_25[1] / 2,
					var_241_14[2] + arg_241_1[2] / 2 - var_241_25[2] / 2,
					var_241_14[3] + 3
				}
			}
			var_241_16[var_241_24] = "portrait_frame_hero_selection"
		end

		var_241_10 = var_241_10 + arg_241_1[1] + var_241_7
	end

	var_241_3.element.passes = var_241_4
	var_241_3.content = var_241_5
	var_241_3.style = var_241_6
	var_241_3.offset = {
		-var_241_9 / 2,
		0,
		0
	}
	var_241_3.scenegraph_id = arg_241_0

	return var_241_3
end

UIWidgets.create_title_widget = function (arg_247_0, arg_247_1, arg_247_2, arg_247_3, arg_247_4, arg_247_5, arg_247_6)
	local var_247_0 = {
		element = {}
	}
	local var_247_1 = {
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text"
		}
	}
	local var_247_2 = {
		title_text = arg_247_2 or "n/a"
	}
	local var_247_3 = {
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
		local var_247_4 = arg_247_1[1] * 0.3

		var_247_1[#var_247_1 + 1] = {
			texture_id = "title_detail_center",
			style_id = "title_detail_center",
			pass_type = "texture"
		}
		var_247_1[#var_247_1 + 1] = {
			texture_id = "title_detail_line",
			style_id = "title_detail_line",
			pass_type = "texture"
		}
		var_247_1[#var_247_1 + 1] = {
			texture_id = "title_detail_left",
			style_id = "title_detail_left",
			pass_type = "texture"
		}
		var_247_1[#var_247_1 + 1] = {
			texture_id = "title_detail_right",
			style_id = "title_detail_right",
			pass_type = "texture"
		}
		var_247_3.title_detail_center = {
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
		var_247_3.title_detail_line = {
			size = {
				var_247_4,
				17
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_247_1[1] / 2 - var_247_4 / 2,
				arg_247_1[2] - 60,
				3
			}
		}
		var_247_3.title_detail_left = {
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
				arg_247_1[1] / 2 - var_247_4 / 2 - 7,
				arg_247_1[2] - 60,
				3
			}
		}
		var_247_3.title_detail_right = {
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
				arg_247_1[1] / 2 + var_247_4 / 2,
				arg_247_1[2] - 60,
				3
			}
		}
		var_247_2.title_detail_center = "title_detail_01_middle"
		var_247_2.title_detail_line = "title_detail_01_tile"
		var_247_2.title_detail_left = "title_detail_01_left"
		var_247_2.title_detail_right = "title_detail_01_right"
	end

	if arg_247_3 then
		var_247_1[#var_247_1 + 1] = {
			texture_id = "title_bg_fade",
			style_id = "title_bg_fade",
			pass_type = "rotated_texture"
		}
		var_247_2.title_bg_fade = "edge_fade_small"

		if arg_247_5 then
			var_247_3.title_bg_fade = {
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
			var_247_3.title_bg_fade = {
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

	var_247_0.element.passes = var_247_1
	var_247_0.content = var_247_2
	var_247_0.style = var_247_3
	var_247_0.offset = {
		0,
		0,
		0
	}
	var_247_0.scenegraph_id = arg_247_0

	return var_247_0
end

UIWidgets.create_large_window_title = function (arg_248_0, arg_248_1, arg_248_2, arg_248_3)
	local var_248_0 = "menu_frame_bg_01"
	local var_248_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_248_0)
	local var_248_2 = UIFrameSettings.button_frame_01
	local var_248_3 = "frame_title_detail_06"
	local var_248_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_248_3).size

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
					content_check_function = function (arg_249_0)
						return not arg_249_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_250_0)
						return arg_250_0.button_hotspot.disable_button
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
				texture_id = var_248_3
			},
			button_hotspot = {},
			title_text = arg_248_2 or "n/a",
			frame = var_248_2.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_248_1[2] / var_248_1.size[2]
					},
					{
						arg_248_1[1] / var_248_1.size[1],
						1
					}
				},
				texture_id = var_248_0
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
					var_248_2.texture_sizes.horizontal[2] - 1,
					2
				},
				size = {
					arg_248_1[1],
					math.min(60, arg_248_1[2] - var_248_2.texture_sizes.horizontal[2] * 2)
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
				texture_size = var_248_2.texture_size,
				texture_sizes = var_248_2.texture_sizes,
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
					var_248_4[1],
					var_248_4[2]
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
					var_248_4[1],
					var_248_4[2]
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
	local var_251_0 = {
		element = {}
	}
	local var_251_1 = {
		{
			pass_type = "gamepad_cursor",
			style_id = "cursor",
			texture_id = "cursor",
			content_check_function = function (arg_252_0, arg_252_1)
				return not Managers.popup:has_popup()
			end
		}
	}
	local var_251_2 = {
		cursor = "console_cursor"
	}
	local var_251_3 = {
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

	var_251_0.element.passes = var_251_1
	var_251_0.content = var_251_2
	var_251_0.style = var_251_3
	var_251_0.offset = {
		0,
		0,
		0
	}
	var_251_0.scenegraph_id = arg_251_0

	return var_251_0
end

UIWidgets.create_difficulty_selector = function (arg_253_0, arg_253_1, arg_253_2, arg_253_3, arg_253_4)
	local var_253_0 = {
		255,
		255,
		255,
		255
	}
	local var_253_1 = Colors.get_color_table_with_alpha("font_title", 255)
	local var_253_2 = {
		element = {}
	}
	local var_253_3 = {}
	local var_253_4 = {
		amount = arg_253_3
	}
	local var_253_5 = {
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
	local var_253_6 = arg_253_2 or 0
	local var_253_7 = 0
	local var_253_8 = -var_253_6
	local var_253_9 = (arg_253_1[1] - var_253_6 * (arg_253_3 - 1)) / arg_253_3

	arg_253_4 = arg_253_4 or {
		194,
		190
	}

	local var_253_10 = {
		var_253_9,
		arg_253_1[2]
	}
	local var_253_11 = 0
	local var_253_12 = UIFrameSettings.menu_frame_06

	for iter_253_0 = 1, arg_253_3 do
		local var_253_13 = "_" .. tostring(iter_253_0)
		local var_253_14 = iter_253_0 - 1

		var_253_8 = var_253_8 + var_253_10[1] + var_253_6

		local var_253_15 = {
			var_253_11,
			0,
			var_253_7
		}
		local var_253_16 = "hotspot" .. var_253_13

		var_253_3[#var_253_3 + 1] = {
			pass_type = "hotspot",
			content_id = var_253_16,
			style_id = var_253_16
		}
		var_253_5[var_253_16] = {
			size = var_253_10,
			offset = var_253_15
		}
		var_253_4[var_253_16] = {}

		local var_253_17 = var_253_4[var_253_16]
		local var_253_18 = "background_image" .. var_253_13

		var_253_3[#var_253_3 + 1] = {
			pass_type = "texture",
			content_id = var_253_16,
			texture_id = var_253_18,
			style_id = var_253_18
		}
		var_253_5[var_253_18] = {
			size = arg_253_4,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_253_15[1] + var_253_10[1] / 2 - arg_253_4[1] / 2,
				var_253_15[2] + var_253_10[2] - arg_253_4[2],
				2
			}
		}
		var_253_17[var_253_18] = "difficulty_option_" .. iter_253_0

		local var_253_19 = "background_glow" .. var_253_13

		var_253_5[var_253_19] = {
			size = {
				var_253_10[1],
				var_253_10[2]
			},
			color = {
				200,
				255,
				255,
				255
			},
			offset = {
				var_253_15[1],
				var_253_15[2],
				1
			}
		}
		var_253_17[var_253_19] = "tabs_glow"

		local var_253_20 = "background_glow_select" .. var_253_13

		var_253_5[var_253_20] = {
			size = {
				var_253_10[1],
				var_253_10[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_253_15[1],
				var_253_15[2],
				2
			}
		}
		var_253_17[var_253_20] = "tabs_glow_animated"

		local var_253_21 = "title_text" .. var_253_13

		var_253_3[#var_253_3 + 1] = {
			pass_type = "text",
			text_id = var_253_21,
			style_id = var_253_21
		}
		var_253_5[var_253_21] = {
			upper_case = false,
			font_size = 32,
			word_wrap = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				var_253_10[1],
				var_253_10[2] * 0.2 - var_253_12.texture_sizes.vertical[1]
			},
			offset = {
				var_253_15[1],
				var_253_15[2],
				7
			}
		}
		var_253_17[var_253_21] = "title_text"
		var_253_11 = var_253_11 + var_253_9 + var_253_6
	end

	var_253_2.element.passes = var_253_3
	var_253_2.content = var_253_4
	var_253_2.style = var_253_5
	var_253_2.offset = {
		0,
		0,
		0
	}
	var_253_2.scenegraph_id = arg_253_0

	return var_253_2
end

UIWidgets.create_base_portrait_frame = function (arg_254_0, arg_254_1, arg_254_2, arg_254_3, arg_254_4, arg_254_5)
	arg_254_2 = arg_254_2 or 1

	local var_254_0 = arg_254_1 or "default"
	local var_254_1 = UIPlayerPortraitFrameSettings[var_254_0]
	local var_254_2 = {
		255,
		255,
		255,
		255
	}
	local var_254_3 = {
		0,
		0,
		0
	}
	local var_254_4 = {
		element = {}
	}
	local var_254_5 = {}
	local var_254_6 = {
		scale = arg_254_2,
		frame_settings_name = var_254_0
	}
	local var_254_7 = {}

	for iter_254_0, iter_254_1 in ipairs(var_254_1) do
		local var_254_8 = "texture_" .. iter_254_0
		local var_254_9 = iter_254_1.texture or "icons_placeholder"
		local var_254_10 = iter_254_1.size

		if UIAtlasHelper.has_atlas_settings_by_texture_name(var_254_9) then
			var_254_10 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_254_9).size
		else
			var_254_10 = iter_254_1.size
		end

		local var_254_11

		var_254_11 = var_254_10 and table.clone(var_254_10) or {
			0,
			0
		}
		var_254_11[1] = var_254_11[1] * arg_254_2
		var_254_11[2] = var_254_11[2] * arg_254_2

		local var_254_12 = table.clone(not arg_254_5 and iter_254_1.offset or var_254_3)

		var_254_12[1] = var_254_12[1] * arg_254_2
		var_254_12[2] = var_254_12[2] * arg_254_2
		var_254_12[3] = iter_254_1.layer or 0
		var_254_5[#var_254_5 + 1] = {
			pass_type = "texture",
			texture_id = var_254_8,
			style_id = var_254_8
		}
		var_254_6[var_254_8] = var_254_9
		var_254_7[var_254_8] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_254_4,
			color = iter_254_1.color or var_254_2,
			offset = var_254_12,
			texture_size = var_254_11
		}
	end

	var_254_4.element.passes = var_254_5
	var_254_4.content = var_254_6
	var_254_4.style = var_254_7
	var_254_4.offset = arg_254_3 or {
		0,
		0,
		0
	}
	var_254_4.scenegraph_id = arg_254_0

	return var_254_4
end

UIWidgets.create_portrait_frame = function (arg_255_0, arg_255_1, arg_255_2, arg_255_3, arg_255_4, arg_255_5)
	arg_255_3 = arg_255_3 or 1

	local var_255_0 = arg_255_1 or "default"
	local var_255_1 = UIPlayerPortraitFrameSettings[var_255_0]
	local var_255_2 = {
		255,
		255,
		255,
		255
	}
	local var_255_3 = {
		0,
		-60,
		0
	}
	local var_255_4 = {
		element = {}
	}
	local var_255_5 = {}
	local var_255_6 = {
		scale = arg_255_3,
		frame_settings_name = var_255_0
	}
	local var_255_7 = {}
	local var_255_8 = {
		level = arg_255_2
	}

	for iter_255_0, iter_255_1 in ipairs(var_255_1) do
		local var_255_9 = "texture_" .. iter_255_0
		local var_255_10 = iter_255_1.texture or "icons_placeholder"
		local var_255_11 = iter_255_1.size

		if UIAtlasHelper.has_atlas_settings_by_texture_name(var_255_10) then
			var_255_11 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_255_10).size
		else
			var_255_11 = iter_255_1.size
		end

		local var_255_12

		var_255_12 = var_255_11 and table.clone(var_255_11) or {
			0,
			0
		}
		var_255_12[1] = var_255_12[1] * arg_255_3
		var_255_12[2] = var_255_12[2] * arg_255_3

		local var_255_13 = table.clone(iter_255_1.offset or var_255_3)

		var_255_13[1] = -(var_255_12[1] / 2) + var_255_13[1] * arg_255_3
		var_255_13[2] = var_255_13[2] * arg_255_3
		var_255_13[3] = iter_255_1.layer or 0
		var_255_5[#var_255_5 + 1] = {
			pass_type = "texture",
			texture_id = var_255_9,
			style_id = var_255_9,
			retained_mode = arg_255_4,
			context = var_255_8,
			clone = iter_255_1.clone,
			material_func = iter_255_1.material_func
		}
		var_255_6[var_255_9] = var_255_10
		var_255_7[var_255_9] = {
			color = iter_255_1.color or var_255_2,
			offset = var_255_13,
			size = var_255_12
		}
	end

	if arg_255_5 then
		local var_255_14 = {
			86,
			108
		}

		var_255_14[1] = var_255_14[1] * arg_255_3
		var_255_14[2] = var_255_14[2] * arg_255_3

		local var_255_15 = {
			0,
			0,
			0
		}

		var_255_15[1] = -(var_255_14[1] / 2) + var_255_15[1] * arg_255_3
		var_255_15[2] = -(var_255_14[2] / 2) + var_255_15[2] * arg_255_3
		var_255_15[3] = 1

		local var_255_16 = "portrait"

		var_255_5[#var_255_5 + 1] = {
			pass_type = "texture",
			texture_id = var_255_16,
			style_id = var_255_16,
			retained_mode = arg_255_4
		}
		var_255_6[var_255_16] = arg_255_5
		var_255_7[var_255_16] = {
			color = var_255_2,
			offset = var_255_15,
			size = var_255_14
		}
	end

	local var_255_17 = {
		86,
		108
	}

	var_255_17[1] = var_255_17[1] * arg_255_3
	var_255_17[2] = var_255_17[2] * arg_255_3

	local var_255_18 = {
		22,
		15
	}
	local var_255_19 = {
		0,
		0,
		0
	}

	var_255_19[1] = var_255_19[1] * arg_255_3 - var_255_18[1] / 2 - 1
	var_255_19[2] = -(var_255_17[2] / 2) + var_255_19[2] * arg_255_3 - 4
	var_255_19[3] = 15

	local var_255_20 = "level"

	var_255_5[#var_255_5 + 1] = {
		pass_type = "text",
		text_id = var_255_20,
		style_id = var_255_20,
		retained_mode = arg_255_4
	}
	var_255_6[var_255_20] = arg_255_2
	var_255_7[var_255_20] = {
		vertical_alignment = "center",
		font_type = "hell_shark",
		font_size = 12,
		horizontal_alignment = "center",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = var_255_19,
		size = var_255_18
	}
	var_255_4.element.passes = var_255_5
	var_255_4.content = var_255_6
	var_255_4.style = var_255_7
	var_255_4.offset = {
		0,
		0,
		0
	}
	var_255_4.scenegraph_id = arg_255_0

	return var_255_4
end

UIWidgets.create_portrait_frame_button = function (arg_256_0, arg_256_1, arg_256_2, arg_256_3, arg_256_4)
	arg_256_2 = arg_256_2 or 1

	local var_256_0 = UIPlayerPortraitFrameSettings[arg_256_1]
	local var_256_1 = {
		255,
		255,
		255,
		255
	}
	local var_256_2 = {
		0,
		0,
		0
	}
	local var_256_3 = {
		element = {}
	}
	local var_256_4 = {}
	local var_256_5 = {
		scale = arg_256_2,
		frame_settings_name = arg_256_1
	}
	local var_256_6 = {}

	for iter_256_0, iter_256_1 in ipairs(var_256_0) do
		local var_256_7 = "texture_" .. iter_256_0
		local var_256_8 = iter_256_1.texture or "icons_placeholder"
		local var_256_9 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_256_8)
		local var_256_10 = iter_256_1.size or var_256_9.size
		local var_256_11

		var_256_11 = var_256_10 and table.clone(var_256_10) or {
			0,
			0
		}
		var_256_11[1] = var_256_11[1] * arg_256_2
		var_256_11[2] = var_256_11[2] * arg_256_2

		local var_256_12 = table.clone(iter_256_1.offset or var_256_2)

		var_256_12[1] = -(var_256_11[1] / 2) + var_256_12[1] * arg_256_2
		var_256_12[2] = -(var_256_11[2] / 2) + var_256_12[2] * arg_256_2
		var_256_12[3] = iter_256_1.layer or 0
		var_256_4[#var_256_4 + 1] = {
			pass_type = "texture",
			texture_id = var_256_7,
			style_id = var_256_7,
			retained_mode = arg_256_3
		}
		var_256_5[var_256_7] = var_256_8
		var_256_6[var_256_7] = {
			color = iter_256_1.color or var_256_1,
			offset = var_256_12,
			size = var_256_11
		}
	end

	local var_256_13 = {
		86,
		108
	}

	var_256_13[1] = var_256_13[1] * arg_256_2
	var_256_13[2] = var_256_13[2] * arg_256_2

	local var_256_14 = table.clone(var_256_2)

	var_256_14[1] = -(var_256_13[1] / 2) + var_256_14[1] * arg_256_2
	var_256_14[2] = -(var_256_13[2] / 2) + 25 * arg_256_2
	var_256_14[3] = 20

	local var_256_15 = "portrait"

	var_256_4[#var_256_4 + 1] = {
		pass_type = "texture",
		texture_id = var_256_15,
		style_id = var_256_15,
		retained_mode = arg_256_3
	}
	var_256_5[var_256_15] = arg_256_4
	var_256_6[var_256_15] = {
		color = var_256_1,
		offset = var_256_14,
		size = var_256_13
	}

	local var_256_16 = "button_hotspot"

	var_256_4[#var_256_4 + 1] = {
		pass_type = "hotspot",
		content_id = var_256_16,
		style_id = var_256_16,
		retained_mode = arg_256_3
	}
	var_256_5[var_256_16] = {}
	var_256_6[var_256_16] = {
		size = var_256_13,
		offset = var_256_14
	}

	local var_256_17 = "hover_texture"

	var_256_4[#var_256_4 + 1] = {
		pass_type = "texture",
		texture_id = var_256_17,
		style_id = var_256_17,
		retained_mode = arg_256_3,
		content_check_function = function (arg_257_0)
			return arg_257_0.button_hotspot.is_hover
		end
	}
	var_256_5[var_256_17] = "ability_inner_effect_1"
	var_256_6[var_256_17] = {
		color = var_256_1,
		offset = {
			var_256_14[1],
			var_256_14[2],
			-2
		},
		size = var_256_13
	}
	var_256_3.element.passes = var_256_4
	var_256_3.content = var_256_5
	var_256_3.style = var_256_6
	var_256_3.offset = {
		0,
		0,
		0
	}
	var_256_3.scenegraph_id = arg_256_0

	return var_256_3
end

UIWidgets.create_score_entry = function (arg_258_0, arg_258_1, arg_258_2, arg_258_3)
	local var_258_0 = {
		255,
		255,
		255,
		255
	}
	local var_258_1 = Colors.get_color_table_with_alpha("font_title", 255)
	local var_258_2 = "menu_frame_bg_01"
	local var_258_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_258_2)
	local var_258_4 = {
		element = {}
	}
	local var_258_5 = {}
	local var_258_6 = {
		num_rows = arg_258_2
	}
	local var_258_7 = {}
	local var_258_8 = UIFrameSettings.menu_frame_09
	local var_258_9 = "scoreboard_topic_bg"
	local var_258_10 = "scoreboard_topic_bg_highlight"
	local var_258_11 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_258_9)
	local var_258_12 = {
		arg_258_1[1],
		var_258_11.size[2]
	}
	local var_258_13 = {
		0,
		0,
		0
	}
	local var_258_14 = "hotspot"

	var_258_5[#var_258_5 + 1] = {
		pass_type = "hotspot",
		content_id = var_258_14,
		style_id = var_258_14
	}
	var_258_7[var_258_14] = {
		size = arg_258_1,
		offset = var_258_13
	}
	var_258_6[var_258_14] = {
		allow_multi_hover = true
	}

	local var_258_15 = var_258_6[var_258_14]
	local var_258_16 = "background"

	var_258_5[#var_258_5 + 1] = {
		pass_type = "rect",
		style_id = var_258_16
	}
	var_258_7[var_258_16] = {
		size = arg_258_1,
		color = {
			200,
			0,
			0,
			0
		},
		offset = {
			var_258_13[1],
			var_258_13[2],
			0
		}
	}

	local var_258_17 = "background_left_glow"

	var_258_5[#var_258_5 + 1] = {
		pass_type = "texture_uv",
		content_id = var_258_17,
		style_id = var_258_17
	}
	var_258_7[var_258_17] = {
		size = {
			arg_258_1[1] / 2,
			arg_258_1[2]
		},
		color = Colors.get_color_table_with_alpha("blue", 255),
		offset = {
			var_258_13[1],
			var_258_13[2],
			1
		}
	}
	var_258_6[var_258_17] = {
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

	local var_258_18 = "background_right_glow"

	var_258_5[#var_258_5 + 1] = {
		pass_type = "texture_uv",
		content_id = var_258_18,
		style_id = var_258_18
	}
	var_258_7[var_258_18] = {
		size = {
			arg_258_1[1] / 2,
			arg_258_1[2]
		},
		color = Colors.get_color_table_with_alpha("blue", 255),
		offset = {
			var_258_13[1] + arg_258_1[1] / 2,
			var_258_13[2],
			1
		}
	}
	var_258_6[var_258_18] = {
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

	local var_258_19 = "glass_bottom"

	var_258_5[#var_258_5 + 1] = {
		pass_type = "texture",
		content_id = var_258_14,
		texture_id = var_258_19,
		style_id = var_258_19
	}
	var_258_7[var_258_19] = {
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
			var_258_13[1],
			var_258_13[2] + var_258_8.texture_sizes.vertical[1],
			2
		}
	}
	var_258_15[var_258_19] = "tabs_glass_bottom"

	local var_258_20 = "glass_top"

	var_258_5[#var_258_5 + 1] = {
		pass_type = "texture",
		content_id = var_258_14,
		texture_id = var_258_20,
		style_id = var_258_20
	}
	var_258_7[var_258_20] = {
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
			var_258_13[1],
			var_258_13[2] + arg_258_1[2] - (var_258_8.texture_sizes.vertical[1] + 3),
			2
		}
	}
	var_258_15[var_258_20] = "tabs_glass_top"

	local var_258_21 = "frame"

	var_258_5[#var_258_5 + 1] = {
		pass_type = "texture_frame",
		content_id = var_258_14,
		texture_id = var_258_21,
		style_id = var_258_21
	}
	var_258_7[var_258_21] = {
		size = arg_258_1,
		texture_size = var_258_8.texture_size,
		texture_sizes = var_258_8.texture_sizes,
		color = var_258_0,
		offset = {
			var_258_13[1],
			var_258_13[2],
			10
		}
	}
	var_258_15[var_258_21] = var_258_8.texture

	local var_258_22 = "edge_fade"

	var_258_5[#var_258_5 + 1] = {
		pass_type = "texture",
		content_id = var_258_14,
		texture_id = var_258_22,
		style_id = var_258_22,
		content_check_function = function (arg_259_0)
			return not arg_259_0.is_selected
		end
	}
	var_258_7[var_258_22] = {
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
			var_258_13[1],
			var_258_13[2] + var_258_8.texture_sizes.vertical[1],
			5
		}
	}
	var_258_15[var_258_22] = "edge_fade_small"

	for iter_258_0 = 1, arg_258_2 do
		local var_258_23 = "_" .. iter_258_0
		local var_258_24 = -(iter_258_0 * var_258_12[2])
		local var_258_25 = {
			var_258_13[1],
			var_258_13[2] + arg_258_1[2] - 80 + var_258_24,
			var_258_13[3] + 5
		}
		local var_258_26 = "row_bg" .. var_258_23

		var_258_5[#var_258_5 + 1] = {
			texture_id = "texture_id",
			pass_type = "tiled_texture",
			content_id = var_258_26,
			style_id = var_258_26,
			content_check_function = function (arg_260_0)
				local var_260_0 = arg_260_0.parent.hover_index

				if var_260_0 and var_260_0 == iter_258_0 then
					return false
				end

				return arg_260_0.has_background
			end
		}
		var_258_6[var_258_26] = {
			has_background = false,
			texture_id = var_258_9
		}
		var_258_7[var_258_26] = {
			size = var_258_12,
			color = {
				150,
				255,
				255,
				255
			},
			offset = var_258_25,
			texture_tiling_size = var_258_11.size
		}

		if iter_258_0 ~= 1 then
			local var_258_27 = "highlight_row_bg" .. var_258_23

			var_258_5[#var_258_5 + 1] = {
				texture_id = "texture_id",
				pass_type = "tiled_texture",
				content_id = var_258_27,
				style_id = var_258_27,
				content_check_function = function (arg_261_0)
					local var_261_0 = arg_261_0.parent.hover_index

					return var_261_0 and var_261_0 == iter_258_0
				end
			}
			var_258_7[var_258_27] = {
				size = var_258_12,
				color = Colors.get_color_table_with_alpha("white", 20),
				offset = {
					var_258_25[1],
					var_258_25[2],
					var_258_25[3] + 1
				},
				texture_tiling_size = var_258_11.size
			}
			var_258_6[var_258_27] = {
				has_background = false,
				texture_id = var_258_10
			}
		end

		local var_258_28 = "score_text" .. var_258_23

		var_258_5[#var_258_5 + 1] = {
			pass_type = "text",
			content_id = var_258_26,
			text_id = var_258_28,
			style_id = var_258_28
		}
		var_258_7[var_258_28] = {
			vertical_alignment = "center",
			font_size = 22,
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "arial",
			text_color = iter_258_0 == 1 and var_258_1 or Colors.get_color_table_with_alpha("font_default", 255),
			size = var_258_12,
			offset = {
				var_258_25[1],
				var_258_25[2],
				var_258_25[3] + 20
			}
		}
		var_258_6[var_258_26][var_258_28] = ""

		local var_258_29 = "score_text_shadow" .. var_258_23

		var_258_5[#var_258_5 + 1] = {
			pass_type = "text",
			content_id = var_258_26,
			text_id = var_258_28,
			style_id = var_258_29
		}
		var_258_7[var_258_29] = {
			vertical_alignment = "center",
			font_size = 22,
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "arial",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = var_258_12,
			offset = {
				var_258_25[1] + 2,
				var_258_25[2] - 2,
				var_258_25[3] + 19
			}
		}

		if iter_258_0 ~= 1 then
			local var_258_30 = "score_text_highlight" .. var_258_23

			var_258_5[#var_258_5 + 1] = {
				pass_type = "text",
				content_id = var_258_26,
				text_id = var_258_28,
				style_id = var_258_30,
				content_check_function = function (arg_262_0)
					local var_262_0 = arg_262_0.parent.hover_index

					return var_262_0 and var_262_0 == iter_258_0
				end
			}
			var_258_7[var_258_30] = {
				vertical_alignment = "center",
				font_size = 22,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "arial",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				size = var_258_12,
				offset = {
					var_258_25[1],
					var_258_25[2],
					var_258_25[3] + 30
				}
			}
		end

		local var_258_31 = "marker" .. var_258_23

		var_258_5[#var_258_5 + 1] = {
			pass_type = "texture",
			texture_id = var_258_31,
			style_id = var_258_31,
			content_check_function = function (arg_263_0)
				return arg_263_0[var_258_26].has_highscore
			end
		}
		var_258_7[var_258_31] = {
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
				var_258_25[1] + var_258_12[1] / 2 - 35.5,
				var_258_25[2] + var_258_12[2] / 2 - 19.5,
				var_258_25[3] + 4
			}
		}
		var_258_6[var_258_31] = "scoreboard_marker"
	end

	var_258_4.element.passes = var_258_5
	var_258_4.content = var_258_6
	var_258_4.style = var_258_7
	var_258_4.offset = {
		0,
		0,
		0
	}
	var_258_4.scenegraph_id = arg_258_0

	return var_258_4
end

UIWidgets.create_score_topics = function (arg_264_0, arg_264_1, arg_264_2, arg_264_3)
	local var_264_0 = {
		255,
		255,
		255,
		255
	}
	local var_264_1 = Colors.get_color_table_with_alpha("font_title", 255)
	local var_264_2 = "menu_frame_bg_01"
	local var_264_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_264_2)
	local var_264_4 = {
		element = {}
	}
	local var_264_5 = {}
	local var_264_6 = {
		num_rows = arg_264_3
	}
	local var_264_7 = {}
	local var_264_8 = UIFrameSettings.menu_frame_09
	local var_264_9 = "scoreboard_topic_bg"
	local var_264_10 = "scoreboard_topic_bg_highlight"
	local var_264_11 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_264_9)
	local var_264_12 = {
		arg_264_1[1],
		var_264_11.size[2]
	}
	local var_264_13 = 80
	local var_264_14 = {
		0,
		0,
		0
	}
	local var_264_15 = {
		arg_264_1[1],
		arg_264_1[2] - var_264_13
	}
	local var_264_16 = "hotspot"

	var_264_5[#var_264_5 + 1] = {
		pass_type = "hotspot",
		content_id = var_264_16,
		style_id = var_264_16
	}
	var_264_7[var_264_16] = {
		size = arg_264_1,
		offset = var_264_14
	}
	var_264_6[var_264_16] = {
		allow_multi_hover = true
	}

	local var_264_17 = var_264_6[var_264_16]
	local var_264_18 = "background"

	var_264_5[#var_264_5 + 1] = {
		pass_type = "texture_uv",
		content_id = var_264_18,
		style_id = var_264_18
	}

	local var_264_19 = 0.8

	var_264_7[var_264_18] = {
		size = var_264_15,
		color = {
			200,
			0,
			0,
			0
		},
		offset = {
			var_264_14[1],
			var_264_14[2],
			0
		}
	}
	var_264_6[var_264_18] = {
		uvs = {
			{
				0,
				0
			},
			{
				math.min(var_264_15[1] / var_264_3.size[1], 1),
				math.min(var_264_15[2] / var_264_3.size[2], 1)
			}
		},
		texture_id = var_264_2
	}

	local var_264_20 = "glass_bottom"

	var_264_5[#var_264_5 + 1] = {
		pass_type = "texture",
		content_id = var_264_16,
		texture_id = var_264_20,
		style_id = var_264_20
	}
	var_264_7[var_264_20] = {
		size = {
			var_264_15[1],
			3
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_264_14[1],
			var_264_14[2] + var_264_8.texture_sizes.vertical[1],
			1
		}
	}
	var_264_17[var_264_20] = "tabs_glass_bottom"

	local var_264_21 = "glass_top"

	var_264_5[#var_264_5 + 1] = {
		pass_type = "texture",
		content_id = var_264_16,
		texture_id = var_264_21,
		style_id = var_264_21
	}
	var_264_7[var_264_21] = {
		size = {
			var_264_15[1],
			3
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			var_264_14[1],
			var_264_14[2] + var_264_15[2] - (var_264_8.texture_sizes.vertical[1] + 3),
			1
		}
	}
	var_264_17[var_264_21] = "tabs_glass_top"

	local var_264_22 = "frame"

	var_264_5[#var_264_5 + 1] = {
		pass_type = "texture_frame",
		content_id = var_264_16,
		texture_id = var_264_22,
		style_id = var_264_22
	}
	var_264_7[var_264_22] = {
		size = var_264_15,
		texture_size = var_264_8.texture_size,
		texture_sizes = var_264_8.texture_sizes,
		color = var_264_0,
		offset = {
			var_264_14[1],
			var_264_14[2],
			10
		}
	}
	var_264_17[var_264_22] = var_264_8.texture

	local var_264_23 = "edge_fade"

	var_264_5[#var_264_5 + 1] = {
		pass_type = "texture",
		content_id = var_264_16,
		texture_id = var_264_23,
		style_id = var_264_23,
		content_check_function = function (arg_265_0)
			return not arg_265_0.is_selected
		end
	}
	var_264_7[var_264_23] = {
		size = {
			var_264_15[1],
			15
		},
		color = {
			200,
			255,
			255,
			255
		},
		offset = {
			var_264_14[1],
			var_264_14[2] + var_264_8.texture_sizes.vertical[1],
			5
		}
	}
	var_264_17[var_264_23] = "edge_fade_small"

	for iter_264_0 = 1, arg_264_3 do
		local var_264_24 = "_" .. iter_264_0
		local var_264_25 = "row_bg" .. var_264_24
		local var_264_26 = -(iter_264_0 * var_264_12[2])
		local var_264_27 = {
			var_264_14[1],
			var_264_14[2] + arg_264_1[2] - var_264_13 + var_264_26,
			var_264_14[3] + 5
		}

		var_264_5[#var_264_5 + 1] = {
			texture_id = "texture_id",
			pass_type = "tiled_texture",
			content_id = var_264_25,
			style_id = var_264_25,
			content_check_function = function (arg_266_0)
				local var_266_0 = arg_266_0.parent.hover_index

				if var_266_0 and var_266_0 == iter_264_0 then
					return false
				end

				return arg_266_0.has_background
			end
		}
		var_264_6[var_264_25] = {
			has_background = false,
			texture_id = var_264_9
		}

		if iter_264_0 ~= 1 then
			local var_264_28 = "hotspot" .. var_264_24

			var_264_5[#var_264_5 + 1] = {
				pass_type = "hotspot",
				content_id = var_264_28,
				style_id = var_264_28
			}
			var_264_6[var_264_28] = {
				allow_multi_hover = true
			}
			var_264_7[var_264_28] = {
				size = {
					arg_264_2,
					var_264_12[2]
				},
				color = {
					150,
					255,
					255,
					255
				},
				offset = {
					var_264_27[1] - arg_264_2 / 2 + var_264_12[1] / 2,
					var_264_27[2],
					var_264_27[3]
				}
			}

			local var_264_29 = "highlight_row_bg" .. var_264_24

			var_264_5[#var_264_5 + 1] = {
				texture_id = "texture_id",
				pass_type = "tiled_texture",
				content_id = var_264_29,
				style_id = var_264_29,
				content_check_function = function (arg_267_0)
					local var_267_0 = arg_267_0.parent.hover_index

					return var_267_0 and var_267_0 == iter_264_0
				end
			}
			var_264_7[var_264_29] = {
				size = var_264_12,
				color = Colors.get_color_table_with_alpha("white", 20),
				offset = {
					var_264_27[1],
					var_264_27[2],
					var_264_27[3] + 1
				},
				texture_tiling_size = var_264_11.size
			}
			var_264_6[var_264_29] = {
				has_background = false,
				texture_id = var_264_10
			}
		end

		var_264_7[var_264_25] = {
			size = var_264_12,
			color = {
				150,
				255,
				255,
				255
			},
			offset = var_264_27,
			texture_tiling_size = var_264_11.size
		}

		local var_264_30 = "score_text" .. var_264_24

		var_264_5[#var_264_5 + 1] = {
			pass_type = "text",
			content_id = var_264_25,
			text_id = var_264_30,
			style_id = var_264_30
		}
		var_264_7[var_264_30] = {
			vertical_alignment = "center",
			font_size = 24,
			horizontal_alignment = "center",
			word_wrap = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = var_264_12,
			offset = {
				var_264_27[1],
				var_264_27[2],
				var_264_27[3] + 3
			}
		}
		var_264_6[var_264_25][var_264_30] = ""

		local var_264_31 = "score_text_shadow" .. var_264_24

		var_264_5[#var_264_5 + 1] = {
			pass_type = "text",
			content_id = var_264_25,
			text_id = var_264_30,
			style_id = var_264_31
		}
		var_264_7[var_264_31] = {
			font_size = 24,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = var_264_12,
			offset = {
				var_264_27[1] + 2,
				var_264_27[2] - 2,
				var_264_27[3] + 2
			}
		}

		if iter_264_0 ~= 1 then
			local var_264_32 = "score_text_highlight" .. var_264_24

			var_264_5[#var_264_5 + 1] = {
				pass_type = "text",
				content_id = var_264_25,
				text_id = var_264_30,
				style_id = var_264_32,
				content_check_function = function (arg_268_0)
					local var_268_0 = arg_268_0.parent.hover_index

					return var_268_0 and var_268_0 == iter_264_0
				end
			}
			var_264_7[var_264_32] = {
				font_size = 24,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				size = var_264_12,
				offset = {
					var_264_27[1],
					var_264_27[2],
					var_264_27[3] + 4
				}
			}
		end

		local var_264_33 = "marker" .. var_264_24

		var_264_5[#var_264_5 + 1] = {
			pass_type = "texture",
			texture_id = var_264_33,
			style_id = var_264_33,
			content_check_function = function (arg_269_0)
				return arg_269_0[var_264_25].has_highscore
			end
		}
		var_264_7[var_264_33] = {
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
				var_264_27[1] + var_264_12[1] / 2 - 35.5,
				var_264_27[2] + var_264_12[2] / 2 - 19.5,
				var_264_27[3] + 2
			}
		}
		var_264_6[var_264_33] = "scoreboard_marker"
	end

	var_264_4.element.passes = var_264_5
	var_264_4.content = var_264_6
	var_264_4.style = var_264_7
	var_264_4.offset = {
		0,
		0,
		0
	}
	var_264_4.scenegraph_id = arg_264_0

	return var_264_4
end

UIWidgets.create_page_dot_selector = function (arg_270_0, arg_270_1)
	local var_270_0 = {
		255,
		255,
		255,
		255
	}
	local var_270_1 = {
		element = {}
	}
	local var_270_2 = {}
	local var_270_3 = {
		amount = arg_270_1
	}
	local var_270_4 = {}
	local var_270_5 = {
		20,
		20
	}
	local var_270_6 = 40
	local var_270_7 = 0
	local var_270_8 = 0
	local var_270_9 = var_270_5[1] * arg_270_1 + var_270_6 * (arg_270_1 - 1)
	local var_270_10 = var_270_9 / arg_270_1
	local var_270_11 = -var_270_9 / 2

	for iter_270_0 = 1, arg_270_1 do
		local var_270_12 = "_" .. tostring(iter_270_0)
		local var_270_13 = iter_270_0 - 1

		var_270_8 = var_270_8 + var_270_5[1] + var_270_6

		local var_270_14 = {
			var_270_11,
			0,
			var_270_7
		}
		local var_270_15 = "hotspot" .. var_270_12

		var_270_2[#var_270_2 + 1] = {
			pass_type = "hotspot",
			content_id = var_270_15,
			style_id = var_270_15
		}
		var_270_4[var_270_15] = {
			size = var_270_5,
			offset = var_270_14
		}
		var_270_3[var_270_15] = {}

		local var_270_16 = var_270_3[var_270_15]
		local var_270_17 = "selection_texture" .. var_270_12

		var_270_2[#var_270_2 + 1] = {
			pass_type = "texture",
			texture_id = var_270_17,
			style_id = var_270_17,
			content_check_function = function (arg_271_0)
				return arg_271_0[var_270_15].is_selected or arg_271_0[var_270_15].is_hover
			end
		}
		var_270_4[var_270_17] = {
			size = var_270_5,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_270_14[1],
				var_270_14[2],
				1
			}
		}
		var_270_3[var_270_17] = "page_indicator_selection"

		local var_270_18 = "background_texture" .. var_270_12

		var_270_2[#var_270_2 + 1] = {
			pass_type = "texture",
			texture_id = var_270_18,
			style_id = var_270_18
		}
		var_270_4[var_270_18] = {
			size = var_270_5,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_270_14[1],
				var_270_14[2],
				0
			}
		}
		var_270_3[var_270_18] = "page_indicator"
		var_270_11 = var_270_11 + var_270_5[1] + var_270_6
	end

	var_270_1.element.passes = var_270_2
	var_270_1.content = var_270_3
	var_270_1.style = var_270_4
	var_270_1.offset = {
		0,
		0,
		0
	}
	var_270_1.scenegraph_id = arg_270_0

	return var_270_1
end

UIWidgets.create_text_input_rect = function (arg_272_0, arg_272_1, arg_272_2, arg_272_3)
	local var_272_0 = {
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
	local var_272_1 = {
		input_mode = "insert",
		caret_index = 1,
		text_index = 1,
		input = "",
		max_length = arg_272_3
	}
	local var_272_2 = {
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
			passes = var_272_0
		},
		content = var_272_1,
		style = var_272_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_272_0
	}
end

UIWidgets.create_craft_material_widget = function (arg_273_0)
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
					content_check_function = function (arg_274_0)
						return not arg_274_0.warning
					end
				},
				{
					style_id = "text_warning",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_275_0)
						return arg_275_0.warning
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
					content_check_function = function (arg_276_0)
						return arg_276_0.draw_background
					end
				},
				{
					style_id = "text_bg_2",
					pass_type = "rect",
					content_check_function = function (arg_277_0)
						return arg_277_0.draw_background
					end
				},
				{
					item_id = "item",
					pass_type = "item_tooltip",
					content_check_function = function (arg_278_0)
						return arg_278_0.button_hotspot.is_hover and arg_278_0.item
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
					content_check_function = function (arg_280_0)
						return not arg_280_0.button_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_hover",
					texture_id = "icon",
					content_check_function = function (arg_281_0)
						return arg_281_0.button_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_glow",
					texture_id = "icon_glow",
					content_check_function = function (arg_282_0)
						return not arg_282_0.button_hotspot.disable_button
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
					content_check_function = function (arg_283_0)
						return not arg_283_0.button_hotspot.disable_button
					end,
					content_change_function = function (arg_284_0, arg_284_1)
						local var_284_0 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

						arg_284_1.color[1] = 55 + var_284_0 * 200
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
	arg_285_3 = arg_285_3 or "level_icon_01"

	local var_285_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_285_3)
	local var_285_1 = var_285_0 and var_285_0.size or {
		150,
		150
	}
	local var_285_2 = {}
	local var_285_3 = {}
	local var_285_4 = {}
	local var_285_5 = "button_hotspot"

	var_285_2[#var_285_2 + 1] = {
		pass_type = "hotspot",
		content_id = var_285_5
	}
	var_285_3[var_285_5] = {}

	local var_285_6 = "selection_background"

	var_285_2[#var_285_2 + 1] = {
		pass_type = "texture_uv",
		content_id = var_285_6,
		style_id = var_285_6
	}
	var_285_3[var_285_6] = {
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

	local var_285_7 = {
		168,
		0,
		-2
	}

	var_285_4[var_285_6] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			414,
			118
		},
		color = UISettings.console_start_game_menu_rect_color,
		offset = var_285_7
	}

	local var_285_8 = "bg_effect"

	var_285_2[#var_285_2 + 1] = {
		pass_type = "texture",
		texture_id = var_285_8,
		style_id = var_285_8
	}
	var_285_4[var_285_8] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		texture_size = {
			414,
			126
		},
		color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			var_285_7[1],
			var_285_7[2],
			var_285_7[3] + 1
		}
	}
	var_285_3[var_285_8] = "item_slot_side_effect"

	local var_285_9 = "text_title"
	local var_285_10 = var_285_9 .. "_shadow"

	var_285_2[#var_285_2 + 1] = {
		pass_type = "text",
		text_id = var_285_9,
		style_id = var_285_9,
		content_change_function = function (arg_286_0, arg_286_1)
			if arg_286_0.is_selected then
				arg_286_1.text_color = arg_286_1.selected_color
			else
				arg_286_1.text_color = arg_286_1.default_color
			end
		end
	}
	var_285_2[#var_285_2 + 1] = {
		pass_type = "text",
		text_id = var_285_9,
		style_id = var_285_10
	}
	var_285_3[var_285_9] = arg_285_1

	local var_285_11 = {
		225,
		16,
		5
	}
	local var_285_12 = {
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
			var_285_11[1],
			var_285_11[2],
			var_285_11[3]
		}
	}
	local var_285_13 = table.clone(var_285_12)

	var_285_13.text_color = {
		255,
		0,
		0,
		0
	}
	var_285_13.offset = {
		var_285_11[1] + 2,
		var_285_11[2] - 2,
		var_285_11[3] - 1
	}
	var_285_4[var_285_9] = var_285_12
	var_285_4[var_285_10] = var_285_13

	local var_285_14 = "input_text"
	local var_285_15 = var_285_14 .. "shadow"

	var_285_2[#var_285_2 + 1] = {
		pass_type = "text",
		text_id = var_285_14,
		style_id = var_285_14
	}
	var_285_2[#var_285_2 + 1] = {
		pass_type = "text",
		text_id = var_285_14,
		style_id = var_285_15
	}
	var_285_3[var_285_14] = arg_285_2 or Localize("not_assigned")

	local var_285_16 = {
		vertical_alignment = "center",
		font_size = 22,
		localize = false,
		horizontal_alignment = "left",
		word_wrap = false,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			var_285_11[1],
			-18,
			var_285_11[3]
		}
	}
	local var_285_17 = var_285_16.offset
	local var_285_18 = table.clone(var_285_16)

	var_285_18.text_color = {
		255,
		0,
		0,
		0
	}
	var_285_18.offset = {
		var_285_17[1] + 2,
		var_285_17[2] - 2,
		var_285_17[3] - 1
	}
	var_285_4[var_285_14] = var_285_16
	var_285_4[var_285_15] = var_285_18

	local var_285_19 = {
		-(arg_285_5[1] / 2) + 108,
		0,
		5
	}
	local var_285_20 = {
		var_285_19[1],
		var_285_19[2],
		var_285_19[3] - 1
	}
	local var_285_21 = {
		var_285_19[1],
		var_285_19[2],
		var_285_19[3] + 2
	}
	local var_285_22 = {
		var_285_19[1],
		var_285_19[2],
		var_285_19[3] + 1
	}

	if arg_285_6 then
		var_285_20[3] = var_285_19[3] - 2
		var_285_22[3] = var_285_19[3] - 1
	end

	local var_285_23 = "icon_texture"

	var_285_2[#var_285_2 + 1] = {
		pass_type = "texture",
		style_id = var_285_23,
		texture_id = var_285_23,
		content_check_function = function (arg_287_0, arg_287_1)
			return arg_287_0[var_285_23]
		end,
		content_change_function = function (arg_288_0, arg_288_1)
			if arg_288_0.button_hotspot.disable_button then
				arg_288_1.saturated = true
			else
				arg_288_1.saturated = false
			end
		end
	}
	var_285_3[var_285_23] = arg_285_3
	var_285_4[var_285_23] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_285_1,
		color = {
			255,
			255,
			255,
			255
		},
		offset = var_285_19
	}

	local var_285_24 = "icon_background"

	var_285_2[#var_285_2 + 1] = {
		pass_type = "texture",
		texture_id = var_285_24,
		style_id = var_285_24
	}
	var_285_3[var_285_24] = "level_icon_09"
	var_285_4[var_285_24] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_285_1,
		color = UISettings.console_start_game_menu_rect_color,
		offset = var_285_20
	}

	local var_285_25 = "icon_frame_texture"

	var_285_2[#var_285_2 + 1] = {
		pass_type = "texture",
		style_id = var_285_25,
		texture_id = var_285_25,
		content_check_function = function (arg_289_0, arg_289_1)
			return arg_289_0[var_285_23]
		end,
		content_change_function = function (arg_290_0, arg_290_1)
			if arg_290_0.button_hotspot.disable_button then
				arg_290_1.saturated = true
			else
				arg_290_1.saturated = false
			end
		end
	}
	var_285_3[var_285_25] = arg_285_4 or "map_frame_00"
	var_285_4[var_285_25] = {
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
		offset = var_285_21
	}

	local var_285_26 = "icon_texture_glow"

	var_285_2[#var_285_2 + 1] = {
		pass_type = "texture",
		style_id = var_285_26,
		texture_id = var_285_26,
		content_check_function = function (arg_291_0)
			return arg_291_0.is_selected
		end
	}
	var_285_3[var_285_26] = "map_frame_glow_02"
	var_285_4[var_285_26] = {
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
		offset = var_285_22
	}

	return {
		element = {
			passes = var_285_2
		},
		content = var_285_3,
		style = var_285_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_285_0
	}
end

UIWidgets.create_start_game_console_play_button = function (arg_292_0)
	local var_292_0 = {}
	local var_292_1 = {}
	local var_292_2 = {}
	local var_292_3 = "text"
	local var_292_4 = var_292_3 .. "_shadow"

	var_292_0[#var_292_0 + 1] = {
		pass_type = "text",
		text_id = var_292_3,
		style_id = var_292_3,
		content_change_function = function (arg_293_0, arg_293_1)
			if arg_293_0.locked then
				arg_293_1.text_color = arg_293_1.disabled_color
			else
				arg_293_1.text_color = arg_293_1.normal_color
			end
		end
	}
	var_292_0[#var_292_0 + 1] = {
		pass_type = "text",
		text_id = var_292_3,
		style_id = var_292_4
	}
	var_292_1[var_292_3] = Localize("start_game_window_play")

	local var_292_5 = {
		0,
		6,
		1
	}
	local var_292_6 = {
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
			var_292_5[1],
			var_292_5[2],
			var_292_5[3]
		}
	}
	local var_292_7 = table.clone(var_292_6)

	var_292_7.text_color = {
		255,
		0,
		0,
		0
	}
	var_292_7.offset = {
		var_292_5[1] + 2,
		var_292_5[2] - 2,
		var_292_5[3] - 1
	}
	var_292_2[var_292_3] = var_292_6
	var_292_2[var_292_4] = var_292_7

	local var_292_8 = "divider"

	var_292_0[#var_292_0 + 1] = {
		pass_type = "texture",
		texture_id = var_292_8,
		style_id = var_292_8
	}
	var_292_1[var_292_8] = "divider_01_top"
	var_292_2[var_292_8] = {
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

	local var_292_9 = "input_texture"

	var_292_0[#var_292_0 + 1] = {
		pass_type = "texture",
		texture_id = var_292_9,
		style_id = var_292_9,
		content_change_function = function (arg_294_0, arg_294_1)
			if arg_294_0.locked then
				arg_294_1.saturated = true
			else
				arg_294_1.saturated = false
			end
		end
	}
	var_292_1[var_292_9] = ""
	var_292_2[var_292_9] = {
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

	local var_292_10 = "glow"

	var_292_0[#var_292_0 + 1] = {
		pass_type = "texture",
		texture_id = var_292_10,
		style_id = var_292_10,
		content_check_function = function (arg_295_0)
			return not arg_295_0.locked
		end
	}
	var_292_1[var_292_10] = "play_glow_mask"
	var_292_2[var_292_10] = {
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
			passes = var_292_0
		},
		content = var_292_1,
		style = var_292_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_292_0
	}
end

UIWidgets.create_arrow_button = function (arg_296_0, arg_296_1)
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
					content_check_function = function (arg_297_0)
						return not arg_297_0.is_gamepad_active and not arg_297_0.hotspot.disable_button
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "texture_disabled_id",
					texture_id = "texture_id",
					content_check_function = function (arg_298_0)
						return not arg_298_0.is_gamepad_active and arg_298_0.hotspot.disable_button
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "texture_hover_id",
					texture_id = "texture_hover_id",
					content_check_function = function (arg_299_0)
						return not arg_299_0.is_gamepad_active
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
					content_check_function = function (arg_301_0)
						return not arg_301_0.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_disabled_id",
					texture_id = "texture_id",
					content_check_function = function (arg_302_0)
						return arg_302_0.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_hover_id",
					texture_id = "texture_hover_id",
					content_check_function = function (arg_303_0)
						return not arg_303_0.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_icon_id",
					texture_id = "texture_icon_id",
					content_check_function = function (arg_304_0)
						return not arg_304_0.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_icon_hover_id",
					texture_id = "texture_icon_id",
					content_check_function = function (arg_305_0)
						return not arg_305_0.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_icon_disabled_id",
					texture_id = "texture_icon_id",
					content_check_function = function (arg_306_0)
						return arg_306_0.button_hotspot.disable_button
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
					content_check_function = function (arg_307_0)
						return not arg_307_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_308_0)
						return not arg_308_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_309_0)
						return arg_309_0.button_hotspot.disable_button
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
	local var_310_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_310_1).size

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
					var_310_0[1],
					var_310_0[2]
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
					var_310_0[1],
					var_310_0[2]
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
					var_310_0[1],
					var_310_0[2]
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
					var_310_0[1],
					var_310_0[2]
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
					content_check_function = function (arg_312_0)
						return arg_312_0.highlighted
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
	local var_313_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_313_2).size
	local var_313_1 = "athanor_icon_loading"
	local var_313_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_313_1).size

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
					content_check_function = function (arg_314_0)
						return arg_314_0.tooltip and arg_314_0.button_hotspot.is_hover
					end
				},
				{
					pass_type = "texture",
					style_id = "price_icon",
					texture_id = "price_icon",
					content_check_function = function (arg_315_0)
						return not arg_315_0.button_hotspot.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "price_icon_disabled",
					texture_id = "price_icon",
					content_check_function = function (arg_316_0)
						return arg_316_0.button_hotspot.disable_button
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
					content_check_function = function (arg_317_0)
						local var_317_0 = arg_317_0.button_hotspot

						return arg_317_0.icon and not var_317_0.disable_button and not arg_317_0.upgrading
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_disabled",
					texture_id = "icon",
					content_check_function = function (arg_318_0)
						return arg_318_0.button_hotspot.disable_button and arg_318_0.icon and not arg_318_0.upgrading
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
					content_check_function = function (arg_319_0)
						return arg_319_0.highlighted
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
					content_check_function = function (arg_320_0)
						return arg_320_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_321_0)
						return not arg_321_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_322_0)
						return arg_322_0.button_hotspot.disable_button
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
					content_check_function = function (arg_323_0)
						return arg_323_0.upgrading
					end,
					content_change_function = function (arg_324_0, arg_324_1, arg_324_2, arg_324_3)
						local var_324_0 = ((arg_324_1.progress or 0) + arg_324_3) % 1

						arg_324_1.angle = math.pow(2, math.smoothstep(var_324_0, 0, 1)) * (math.pi * 2)
						arg_324_1.progress = var_324_0
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
			loading_icon = var_313_1,
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
					var_313_0[1],
					var_313_0[2]
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
					var_313_2[1] / 2,
					var_313_2[2] / 2
				},
				texture_size = {
					var_313_2[1],
					var_313_2[2]
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
					var_313_0[1],
					var_313_0[2]
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
	local var_325_0 = {
		-19,
		-25,
		10
	}
	local var_325_1 = {
		0,
		-8,
		0
	}
	local var_325_2 = {
		2,
		3,
		3
	}
	local var_325_3 = {
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
					content_check_function = function (arg_326_0)
						return not arg_326_0.button_hotspot.disable_button and (arg_326_0.button_hotspot.is_hover or arg_326_0.button_hotspot.is_selected)
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (arg_327_0)
						return not arg_327_0.button_hotspot.disable_button and not arg_327_0.button_hotspot.is_hover and not arg_327_0.button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (arg_328_0)
						return arg_328_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "new_marker",
					style_id = "new_marker",
					pass_type = "texture",
					content_check_function = function (arg_329_0)
						return arg_329_0.new
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
				default_offset = var_325_2,
				offset = var_325_2,
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
					var_325_0[1],
					var_325_0[2],
					var_325_0[3]
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
	local var_330_0 = {
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
			content_check_function = function (arg_331_0)
				return arg_331_0.boss_level
			end
		},
		{
			pass_type = "texture",
			style_id = "difficulty_texture",
			texture_id = "difficulty_texture",
			content_check_function = function (arg_332_0)
				return arg_332_0.difficulty_texture
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
			content_check_function = function (arg_333_0)
				return arg_333_0.requirement_text
			end
		},
		{
			style_id = "requirement_title_shadow",
			pass_type = "text",
			text_id = "requirement_title",
			content_check_function = function (arg_334_0)
				return arg_334_0.requirement_text
			end
		},
		{
			style_id = "requirement_text",
			pass_type = "text",
			text_id = "requirement_text",
			content_check_function = function (arg_335_0)
				return arg_335_0.requirement_text
			end
		},
		{
			style_id = "requirement_text_shadow",
			pass_type = "text",
			text_id = "requirement_text",
			content_check_function = function (arg_336_0)
				return arg_336_0.requirement_text
			end
		}
	}
	local var_330_1 = {
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
	local var_330_2 = {
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
			passes = var_330_0
		},
		content = var_330_1,
		style = var_330_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_330_0
	}
end

UIWidgets.create_game_option_window = function (arg_337_0, arg_337_1, arg_337_2)
	local var_337_0 = UIFrameSettings.frame_outer_glow_01
	local var_337_1 = var_337_0.texture_sizes.horizontal[2]
	local var_337_2 = {
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
	local var_337_3 = {
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
		frame = var_337_0.texture,
		size = arg_337_1
	}
	local var_337_4 = {
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
			texture_size = var_337_0.texture_size,
			texture_sizes = var_337_0.texture_sizes
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
			passes = var_337_2
		},
		content = var_337_3,
		style = var_337_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_337_0
	}
end

UIWidgets.create_item_option_overview = function (arg_338_0, arg_338_1)
	local var_338_0 = 10
	local var_338_1 = {
		arg_338_1[1] - 20,
		40
	}
	local var_338_2 = {
		80,
		80
	}
	local var_338_3 = 20
	local var_338_4 = "frame_outer_glow_01"
	local var_338_5 = UIFrameSettings[var_338_4]
	local var_338_6 = var_338_5.texture_sizes.horizontal[2]
	local var_338_7 = "frame_inner_glow_01"
	local var_338_8 = UIFrameSettings[var_338_7]
	local var_338_9 = var_338_8.texture_sizes.horizontal[2]
	local var_338_10 = "frame_outer_glow_04"
	local var_338_11 = UIFrameSettings[var_338_10]
	local var_338_12 = var_338_11.texture_sizes.horizontal[2]
	local var_338_13 = "frame_outer_glow_04_big"
	local var_338_14 = UIFrameSettings[var_338_13]
	local var_338_15 = var_338_14.texture_sizes.horizontal[2]
	local var_338_16 = {
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
			content_check_function = function (arg_339_0)
				local var_339_0 = arg_339_0.item

				if not var_339_0 then
					return false
				end

				local var_339_1 = var_339_0.key
				local var_339_2 = string.gsub(var_339_1, "^vs_", "")
				local var_339_3 = WeaponSkins.default_skins[var_339_2]
				local var_339_4 = var_339_0.skin

				return var_339_4 and var_339_4 ~= var_339_3
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
	local var_338_17 = {
		title_background = "headline_bg_40",
		title_text = "overview",
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
		text_spacing = var_338_0
	}
	local var_338_18 = {
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
			texture_size = var_338_1,
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
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				var_338_0,
				-14,
				3
			},
			size = {
				var_338_1[1] - var_338_0 * 2,
				arg_338_1[2]
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
				var_338_0 + 2,
				-16,
				2
			},
			size = {
				var_338_1[1] - var_338_0,
				arg_338_1[2]
			}
		},
		frame = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			size = arg_338_1,
			area_size = var_338_2,
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
			texture_size = var_338_2,
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
				10 + var_338_2[1] - 28,
				13,
				10
			}
		},
		icon_bg = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = var_338_2,
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
				16 + var_338_2[1] + var_338_0,
				-63,
				3
			},
			size = {
				var_338_1[1] - (var_338_0 * 2 + var_338_2[1]),
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
				16 + var_338_2[1] + var_338_0 + 2,
				-65,
				2
			},
			size = {
				var_338_1[1] - (var_338_0 * 2 + var_338_2[1]),
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
				16 + var_338_2[1] + var_338_0,
				-103,
				3
			},
			size = {
				var_338_1[1] - (var_338_0 + var_338_2[1]),
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
				16 + var_338_2[1] + var_338_0 + 2,
				-105,
				2
			},
			size = {
				var_338_1[1] - (var_338_0 * 2 + var_338_2[1]),
				arg_338_1[2]
			}
		}
	}

	return {
		element = {
			passes = var_338_16
		},
		content = var_338_17,
		style = var_338_18,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_338_0
	}
end

UIWidgets.create_item_option_properties = function (arg_340_0, arg_340_1)
	local var_340_0 = 10
	local var_340_1 = {
		arg_340_1[1] - 20,
		40
	}
	local var_340_2 = 20
	local var_340_3 = "frame_inner_glow_01"
	local var_340_4 = UIFrameSettings[var_340_3]
	local var_340_5 = var_340_4.texture_sizes.horizontal[2]
	local var_340_6 = "frame_outer_glow_04"
	local var_340_7 = UIFrameSettings[var_340_6]
	local var_340_8 = var_340_7.texture_sizes.horizontal[2]
	local var_340_9 = "frame_outer_glow_04_big"
	local var_340_10 = UIFrameSettings[var_340_9]
	local var_340_11 = var_340_10.texture_sizes.horizontal[2]
	local var_340_12 = {
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
	local var_340_13 = {
		title_background = "headline_bg_40",
		background = "gradient_straight",
		button_hotspot = {},
		hover_frame = var_340_7.texture,
		pulse_frame = var_340_10.texture,
		inner_frame = var_340_4.texture,
		size = arg_340_1,
		title_text = Localize("tooltips_properties"),
		text_spacing = var_340_0
	}
	local var_340_14 = {
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
			texture_size = var_340_1,
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
				var_340_0,
				-9,
				3
			},
			size = {
				var_340_1[1] - var_340_0 * 2,
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
				var_340_0 + 2,
				-11,
				2
			},
			size = {
				var_340_1[1] - var_340_0,
				arg_340_1[2]
			}
		}
	}
	local var_340_15 = 2
	local var_340_16 = {
		arg_340_1[1],
		40
	}
	local var_340_17 = {
		13,
		13
	}
	local var_340_18 = {
		26,
		26
	}
	local var_340_19 = {
		46,
		46
	}
	local var_340_20 = 0
	local var_340_21 = 10
	local var_340_22 = arg_340_1[2] - (var_340_1[2] + var_340_16[2] + 14)

	var_340_13.num_options = var_340_15

	for iter_340_0 = 1, var_340_15 do
		local var_340_23 = "button_hotspot_" .. iter_340_0
		local var_340_24 = "icon_" .. iter_340_0
		local var_340_25 = "icon_disabled_" .. iter_340_0
		local var_340_26 = "option_text_" .. iter_340_0
		local var_340_27 = "option_text_shadow_" .. iter_340_0
		local var_340_28 = "option_text_disabled_" .. iter_340_0
		local var_340_29 = "option_text_disabled_shadow_" .. iter_340_0

		var_340_12[#var_340_12 + 1] = {
			pass_type = "hotspot",
			content_id = var_340_23,
			style_id = var_340_23
		}
		var_340_13[var_340_23] = {
			disable_button = true
		}
		var_340_14[var_340_23] = {
			size = arg_340_1,
			offset = {
				0,
				0,
				1
			}
		}
		var_340_12[#var_340_12 + 1] = {
			pass_type = "texture",
			texture_id = var_340_24,
			style_id = var_340_24,
			content_check_function = function (arg_341_0)
				return not arg_341_0[var_340_23].disable_button
			end
		}
		var_340_13[var_340_24] = "icon_list_dot"
		var_340_14[var_340_24] = {
			color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
			size = var_340_17,
			offset = {
				var_340_21 + 6,
				var_340_22 + var_340_16[2] / 2 - var_340_17[2] / 2,
				5
			}
		}
		var_340_12[#var_340_12 + 1] = {
			pass_type = "texture",
			texture_id = var_340_24,
			style_id = var_340_25,
			content_check_function = function (arg_342_0)
				return arg_342_0[var_340_23].disable_button
			end
		}
		var_340_14[var_340_25] = {
			color = {
				255,
				80,
				80,
				80
			},
			size = var_340_17,
			offset = {
				var_340_21 + 6,
				var_340_22 + var_340_16[2] / 2 - var_340_17[2] / 2,
				5
			}
		}
		var_340_12[#var_340_12 + 1] = {
			pass_type = "text",
			text_id = var_340_26,
			style_id = var_340_26,
			content_check_function = function (arg_343_0)
				return not arg_343_0[var_340_23].disable_button
			end
		}
		var_340_13[var_340_26] = "n/a"

		local var_340_30 = 0.8

		var_340_14[var_340_26] = {
			word_wrap = true,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
			default_text_color = {
				255,
				math.floor(100 * var_340_30),
				math.floor(149 * var_340_30),
				math.floor(237 * var_340_30)
			},
			select_text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
			offset = {
				var_340_21 + var_340_18[1] + var_340_0,
				var_340_22 + 2,
				5
			},
			size = {
				var_340_16[1] - (var_340_0 * 2 + var_340_21 + var_340_18[1]),
				var_340_16[2]
			}
		}
		var_340_12[#var_340_12 + 1] = {
			pass_type = "text",
			text_id = var_340_26,
			style_id = var_340_27,
			content_check_function = function (arg_344_0)
				return not arg_344_0[var_340_23].disable_button
			end
		}
		var_340_14[var_340_27] = {
			word_wrap = true,
			horizontal_alignment = "left",
			font_size = 20,
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_340_21 + var_340_18[1] + var_340_0 + 2,
				var_340_22,
				4
			},
			size = {
				var_340_16[1] - (var_340_0 * 2 + var_340_21 + var_340_18[1]),
				var_340_16[2]
			}
		}
		var_340_12[#var_340_12 + 1] = {
			pass_type = "text",
			text_id = var_340_28,
			style_id = var_340_28,
			content_check_function = function (arg_345_0)
				return arg_345_0[var_340_23].disable_button
			end
		}
		var_340_13[var_340_28] = "Locked"
		var_340_14[var_340_28] = {
			word_wrap = true,
			horizontal_alignment = "left",
			font_size = 20,
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
				var_340_21 + var_340_18[1] + var_340_0,
				var_340_22 + 2,
				5
			},
			size = {
				var_340_16[1] - (var_340_0 * 2 + var_340_21 + var_340_18[1]),
				var_340_16[2]
			}
		}
		var_340_12[#var_340_12 + 1] = {
			pass_type = "text",
			text_id = var_340_28,
			style_id = var_340_29,
			content_check_function = function (arg_346_0)
				return arg_346_0[var_340_23].disable_button
			end
		}
		var_340_14[var_340_29] = {
			word_wrap = true,
			horizontal_alignment = "left",
			font_size = 20,
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_340_21 + var_340_18[1] + var_340_0 + 2,
				var_340_22,
				4
			},
			size = {
				var_340_16[1] - (var_340_0 * 2 + var_340_21 + var_340_18[1]),
				var_340_16[2]
			}
		}
		var_340_22 = var_340_22 - (var_340_16[2] + var_340_20)
	end

	return {
		element = {
			passes = var_340_12
		},
		content = var_340_13,
		style = var_340_14,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_340_0
	}
end

UIWidgets.create_item_option_trait = function (arg_347_0, arg_347_1)
	local var_347_0 = 10
	local var_347_1 = {
		40,
		40
	}
	local var_347_2 = {
		arg_347_1[1] - 20,
		40
	}
	local var_347_3 = 20
	local var_347_4 = "frame_inner_glow_01"
	local var_347_5 = UIFrameSettings[var_347_4]
	local var_347_6 = var_347_5.texture_sizes.horizontal[2]
	local var_347_7 = "frame_outer_glow_04"
	local var_347_8 = UIFrameSettings[var_347_7]
	local var_347_9 = var_347_8.texture_sizes.horizontal[2]
	local var_347_10 = "frame_outer_glow_04_big"
	local var_347_11 = UIFrameSettings[var_347_10]
	local var_347_12 = var_347_11.texture_sizes.horizontal[2]
	local var_347_13 = 0.8
	local var_347_14 = {
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
			content_check_function = function (arg_348_0)
				return arg_348_0.icon_texture
			end
		},
		{
			style_id = "input_text",
			pass_type = "text",
			text_id = "input_text",
			content_check_function = function (arg_349_0)
				return not arg_349_0.locked
			end
		},
		{
			style_id = "input_text_shadow",
			pass_type = "text",
			text_id = "input_text",
			content_check_function = function (arg_350_0)
				return not arg_350_0.locked
			end
		},
		{
			style_id = "input_text_locked",
			pass_type = "text",
			text_id = "input_text_locked",
			content_check_function = function (arg_351_0)
				return arg_351_0.locked
			end
		},
		{
			style_id = "input_text_locked_shadow",
			pass_type = "text",
			text_id = "input_text_locked",
			content_check_function = function (arg_352_0)
				return arg_352_0.locked
			end
		},
		{
			style_id = "sub_title",
			pass_type = "text",
			text_id = "sub_title",
			content_check_function = function (arg_353_0)
				return not arg_353_0.locked
			end
		},
		{
			style_id = "sub_title_shadow",
			pass_type = "text",
			text_id = "sub_title",
			content_check_function = function (arg_354_0)
				return not arg_354_0.locked
			end
		}
	}
	local var_347_15 = {
		locked = true,
		title_text = "trait",
		input_text = "n/a",
		title_background = "headline_bg_40",
		input_text_locked = "Locked",
		sub_title = "n/a",
		background = "gradient_straight",
		button_hotspot = {},
		hover_frame = var_347_8.texture,
		pulse_frame = var_347_11.texture,
		inner_frame = var_347_5.texture,
		size = arg_347_1,
		text_spacing = var_347_0
	}
	local var_347_16 = {
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
			texture_size = var_347_2,
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
				var_347_0,
				-9,
				3
			},
			size = {
				var_347_2[1] - var_347_0 * 2,
				arg_347_1[2]
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
				var_347_0 + 2,
				-11,
				2
			},
			size = {
				var_347_2[1] - var_347_0,
				arg_347_1[2]
			}
		},
		icon_texture = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = var_347_1,
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
				math.floor(193 * var_347_13),
				math.floor(91 * var_347_13),
				math.floor(36 * var_347_13)
			},
			select_text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				16 + var_347_1[1] + var_347_0,
				-58,
				3
			},
			size = {
				var_347_2[1] - (var_347_0 + var_347_1[1]),
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
				16 + var_347_1[1] + var_347_0 + 2,
				-60,
				2
			},
			size = {
				var_347_2[1] - (var_347_0 * 2 + var_347_1[1]),
				arg_347_1[2]
			}
		},
		input_text_locked = {
			word_wrap = true,
			font_size = 36,
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
				var_347_2[1] - (var_347_0 * 2 + var_347_1[1]),
				arg_347_1[2]
			}
		},
		input_text_locked_shadow = {
			word_wrap = true,
			horizontal_alignment = "left",
			font_size = 36,
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
				var_347_2[1] - (var_347_0 * 2 + var_347_1[1]),
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
				16 + var_347_1[1] + var_347_0,
				-98,
				3
			},
			size = {
				var_347_2[1] - (var_347_0 * 2 + var_347_1[1]),
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
				16 + var_347_1[1] + var_347_0 + 2,
				-100,
				2
			},
			size = {
				var_347_2[1] - (var_347_0 * 2 + var_347_1[1]),
				arg_347_1[2]
			}
		}
	}

	return {
		element = {
			passes = var_347_14
		},
		content = var_347_15,
		style = var_347_16,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_347_0
	}
end

UIWidgets.create_item_option_upgrade = function (arg_355_0, arg_355_1)
	local var_355_0 = 10
	local var_355_1 = {
		13,
		13
	}
	local var_355_2 = {
		arg_355_1[1] - 20,
		40
	}
	local var_355_3 = 20
	local var_355_4 = "frame_inner_glow_01"
	local var_355_5 = UIFrameSettings[var_355_4]
	local var_355_6 = var_355_5.texture_sizes.horizontal[2]
	local var_355_7 = "frame_outer_glow_04"
	local var_355_8 = UIFrameSettings[var_355_7]
	local var_355_9 = var_355_8.texture_sizes.horizontal[2]
	local var_355_10 = "frame_outer_glow_04_big"
	local var_355_11 = UIFrameSettings[var_355_10]
	local var_355_12 = var_355_11.texture_sizes.horizontal[2]
	local var_355_13 = 0.8
	local var_355_14 = {
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
			content_check_function = function (arg_356_0)
				return not arg_356_0.locked
			end
		},
		{
			style_id = "input_text",
			pass_type = "text",
			text_id = "input_text",
			content_check_function = function (arg_357_0)
				return not arg_357_0.locked
			end
		},
		{
			style_id = "input_text_shadow",
			pass_type = "text",
			text_id = "input_text",
			content_check_function = function (arg_358_0)
				return not arg_358_0.locked
			end
		},
		{
			style_id = "input_text_locked",
			pass_type = "text",
			text_id = "input_text_locked",
			content_check_function = function (arg_359_0)
				return arg_359_0.locked
			end
		},
		{
			style_id = "input_text_locked_shadow",
			pass_type = "text",
			text_id = "input_text_locked",
			content_check_function = function (arg_360_0)
				return arg_360_0.locked
			end
		},
		{
			style_id = "sub_title",
			pass_type = "text",
			text_id = "sub_title",
			content_check_function = function (arg_361_0)
				return not arg_361_0.locked
			end
		},
		{
			style_id = "sub_title_shadow",
			pass_type = "text",
			text_id = "sub_title",
			content_check_function = function (arg_362_0)
				return not arg_362_0.locked
			end
		}
	}
	local var_355_15 = {
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
		text_spacing = var_355_0,
		input_text_locked = string.upper(Localize("menu_weave_forge_upgrade_loadout_button_cap")),
		input_text = Localize("next_upgrade_desc")
	}
	local var_355_16 = {
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
			texture_size = var_355_2,
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
				var_355_0,
				-9,
				3
			},
			size = {
				var_355_2[1] - var_355_0 * 2,
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
				var_355_0 + 2,
				-11,
				2
			},
			size = {
				var_355_2[1] - var_355_0,
				arg_355_1[2]
			}
		},
		icon_texture = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = var_355_1,
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
				16 + var_355_1[1] + var_355_0,
				-64,
				3
			},
			size = {
				var_355_2[1] - (var_355_0 + var_355_1[1]),
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
				16 + var_355_1[1] + var_355_0 + 2,
				-66,
				2
			},
			size = {
				var_355_2[1] - (var_355_0 * 2 + var_355_1[1]),
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
				var_355_1[1],
				-64,
				3
			},
			size = {
				var_355_2[1] - (var_355_0 * 2 + var_355_1[1]),
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
				var_355_1[1] + 2,
				-66,
				2
			},
			size = {
				var_355_2[1] - (var_355_0 * 2 + var_355_1[1]),
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
				16 + var_355_1[1] + var_355_0,
				-98,
				3
			},
			size = {
				var_355_2[1] - (var_355_0 * 2 + var_355_1[1]),
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
				16 + var_355_1[1] + var_355_0 + 2,
				-100,
				2
			},
			size = {
				var_355_2[1] - (var_355_0 * 2 + var_355_1[1]),
				arg_355_1[2]
			}
		}
	}

	return {
		element = {
			passes = var_355_14
		},
		content = var_355_15,
		style = var_355_16,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_355_0
	}
end

UIWidgets.create_item_feature = function (arg_363_0, arg_363_1, arg_363_2, arg_363_3, arg_363_4, arg_363_5)
	local var_363_0 = arg_363_4 and UIAtlasHelper.get_atlas_settings_by_texture_name(arg_363_4)
	local var_363_1 = var_363_0 and var_363_0.size
	local var_363_2 = {
		{
			pass_type = "texture",
			style_id = "value_texture",
			texture_id = "value_texture",
			content_check_function = function (arg_364_0)
				return arg_364_0.value_texture
			end
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (arg_365_0)
				return arg_365_0.title_text
			end
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (arg_366_0)
				return arg_366_0.title_text
			end
		},
		{
			style_id = "value_text",
			pass_type = "text",
			text_id = "value_text",
			content_check_function = function (arg_367_0)
				return arg_367_0.value_text
			end
		},
		{
			style_id = "value_text_shadow",
			pass_type = "text",
			text_id = "value_text",
			content_check_function = function (arg_368_0)
				return arg_368_0.value_text
			end
		}
	}
	local var_363_3 = {
		size = arg_363_1,
		value_texture = arg_363_4,
		value_text = arg_363_3,
		title_text = arg_363_2
	}
	local var_363_4 = {
		value_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_363_5,
			texture_size = var_363_1 or {
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
		},
		title_text = {
			word_wrap = true,
			font_size = 28,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			dynamic_font_size = true,
			font_type = arg_363_5 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				arg_363_1[1] - 10,
				20
			},
			offset = {
				5,
				arg_363_1[2] - 40,
				1
			}
		},
		title_text_shadow = {
			word_wrap = true,
			font_size = 28,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			dynamic_font_size = true,
			font_type = arg_363_5 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				arg_363_1[1] - 10,
				20
			},
			offset = {
				7,
				arg_363_1[2] - 40 - 2,
				0
			}
		},
		value_text = {
			word_wrap = true,
			font_size = 72,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = arg_363_5 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			size = {
				arg_363_1[1] - 10,
				arg_363_1[2] - 20
			},
			offset = {
				5,
				-10,
				1
			}
		},
		value_text_shadow = {
			word_wrap = true,
			font_size = 72,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			dynamic_font_size = true,
			font_type = arg_363_5 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				arg_363_1[1] - 10,
				arg_363_1[2] - 20
			},
			offset = {
				7,
				-12,
				0
			}
		}
	}

	return {
		element = {
			passes = var_363_2
		},
		content = var_363_3,
		style = var_363_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_363_0
	}
end

UIWidgets.create_weapon_diagram_widget = function (arg_369_0, arg_369_1, arg_369_2, arg_369_3, arg_369_4)
	local var_369_0 = {
		0,
		13,
		0
	}
	local var_369_1 = {
		arg_369_1[1] / 2,
		arg_369_1[2] / 2
	}
	local var_369_2 = {
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
			content_check_function = function (arg_370_0)
				return arg_370_0.icon_hotspot_1.is_hover or arg_370_0.show_info
			end
		},
		{
			style_id = "node_icon_info_2",
			pass_type = "text",
			text_id = "icon_info_2",
			content_check_function = function (arg_371_0)
				return arg_371_0.icon_hotspot_2.is_hover or arg_371_0.show_info
			end
		},
		{
			style_id = "node_icon_info_3",
			pass_type = "text",
			text_id = "icon_info_3",
			content_check_function = function (arg_372_0)
				return arg_372_0.icon_hotspot_3.is_hover or arg_372_0.show_info
			end
		},
		{
			style_id = "node_icon_info_4",
			pass_type = "text",
			text_id = "icon_info_4",
			content_check_function = function (arg_373_0)
				return arg_373_0.icon_hotspot_4.is_hover or arg_373_0.show_info
			end
		},
		{
			style_id = "node_icon_info_5",
			pass_type = "text",
			text_id = "icon_info_5",
			content_check_function = function (arg_374_0)
				return arg_374_0.icon_hotspot_5.is_hover or arg_374_0.show_info
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
			content_check_function = function (arg_375_0)
				return arg_375_0.available_actions[1]
			end
		},
		{
			style_id = "tutorial_text_1",
			pass_type = "text",
			text_id = "tutorial_text_1",
			content_check_function = function (arg_376_0)
				return arg_376_0.available_actions[1]
			end
		},
		{
			style_id = "tutorial_text_1_shadow",
			pass_type = "text",
			text_id = "tutorial_text_1",
			content_check_function = function (arg_377_0)
				return arg_377_0.available_actions[1]
			end
		},
		{
			pass_type = "texture",
			style_id = "tutorial_node_2",
			texture_id = "node_dot_2",
			content_check_function = function (arg_378_0)
				return arg_378_0.available_actions[2]
			end
		},
		{
			style_id = "tutorial_text_2",
			pass_type = "text",
			text_id = "tutorial_text_2",
			content_check_function = function (arg_379_0)
				return arg_379_0.available_actions[2]
			end
		},
		{
			style_id = "tutorial_text_2_shadow",
			pass_type = "text",
			text_id = "tutorial_text_2",
			content_check_function = function (arg_380_0)
				return arg_380_0.available_actions[2]
			end
		}
	}
	local var_369_3 = {
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
	local var_369_4 = {
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
				var_369_0[1] + 110,
				var_369_0[2] + 142,
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
				var_369_0[1] + 162,
				var_369_0[2] - 44,
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
				var_369_0[1] - 5,
				var_369_0[2] - 168,
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
				var_369_0[1] - 172,
				var_369_0[2] - 44,
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
				var_369_0[1] - 110,
				var_369_0[2] + 137,
				1
			}
		},
		node_icon_info_1 = {
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
			},
			font_type = arg_369_3 and "hell_shark_masked" or "hell_shark",
			texture_size = {
				50,
				50
			},
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				var_369_0[1] + 110,
				var_369_0[2] + 142 + 40,
				10
			}
		},
		node_icon_info_2 = {
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
			},
			font_type = arg_369_3 and "hell_shark_masked" or "hell_shark",
			texture_size = {
				50,
				50
			},
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				var_369_0[1] + 162,
				var_369_0[2] - 44 + 40,
				10
			}
		},
		node_icon_info_3 = {
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
			},
			font_type = arg_369_3 and "hell_shark_masked" or "hell_shark",
			texture_size = {
				50,
				50
			},
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				var_369_0[1] - 5,
				var_369_0[2] - 168 + 40,
				10
			}
		},
		node_icon_info_4 = {
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
			},
			font_type = arg_369_3 and "hell_shark_masked" or "hell_shark",
			texture_size = {
				50,
				50
			},
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				var_369_0[1] - 172,
				var_369_0[2] - 44 + 40,
				10
			}
		},
		node_icon_info_5 = {
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
			},
			font_type = arg_369_3 and "hell_shark_masked" or "hell_shark",
			texture_size = {
				50,
				50
			},
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				var_369_0[1] - 110,
				var_369_0[2] + 137 + 40,
				10
			}
		},
		tutorial_node_1 = {
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
		},
		tutorial_node_2 = {
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
		},
		tutorial_text_1 = {
			font_size = 28,
			use_shadow = true,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_369_3 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				arg_369_1[1] / 3,
				20
			},
			offset = {
				arg_369_1[1] - (arg_369_1[1] / 3 + 10),
				50,
				3
			}
		},
		tutorial_text_1_shadow = {
			font_size = 28,
			use_shadow = true,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_369_3 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				arg_369_1[1] / 3,
				20
			},
			offset = {
				arg_369_1[1] - (arg_369_1[1] / 3 + 10) + 2,
				48,
				2
			}
		},
		tutorial_text_2 = {
			font_size = 28,
			use_shadow = true,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_369_3 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				arg_369_1[1] / 3,
				20
			},
			offset = {
				arg_369_1[1] - (arg_369_1[1] / 3 + 10),
				10,
				3
			}
		},
		tutorial_text_2_shadow = {
			font_size = 28,
			use_shadow = true,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_369_3 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				arg_369_1[1] / 3,
				20
			},
			offset = {
				arg_369_1[1] - (arg_369_1[1] / 3 + 10) + 2,
				8,
				2
			}
		}
	}
	local var_369_5 = {
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
	local var_369_6 = {}
	local var_369_7 = #var_369_5

	for iter_369_0 = 1, 2 do
		local var_369_8 = iter_369_0 == 1 and Colors.get_color_table_with_alpha("font_title", 255) or {
			255,
			255,
			0,
			0
		}
		local var_369_9 = var_369_7 * (iter_369_0 - 1)
		local var_369_10 = iter_369_0

		for iter_369_1 = 1, var_369_7 do
			local var_369_11 = var_369_9 + iter_369_1
			local var_369_12 = arg_369_2[var_369_11]
			local var_369_13 = var_369_5[iter_369_1]
			local var_369_14 = var_369_13[1] * var_369_12
			local var_369_15 = var_369_13[2] * var_369_12

			var_369_6[iter_369_0] = var_369_12 > (arg_369_4 or 0) or var_369_6[iter_369_0] or false

			local var_369_16 = "node_dot_" .. var_369_11

			var_369_2[#var_369_2 + 1] = {
				pass_type = "texture",
				texture_id = "node_dot_" .. iter_369_0,
				style_id = var_369_16,
				content_check_function = function (arg_381_0)
					return arg_381_0.available_actions[iter_369_0]
				end
			}
			var_369_4[var_369_16] = {
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
					var_369_0[1] + var_369_14,
					var_369_0[2] + var_369_15,
					var_369_10 + 3
				},
				content_check_function = function (arg_382_0)
					return arg_382_0.available_actions[iter_369_0]
				end
			}

			local var_369_17 = "node_line_" .. var_369_11

			var_369_2[#var_369_2 + 1] = {
				pass_type = "rotated_texture",
				texture_id = "node_line",
				style_id = var_369_17,
				content_check_function = function (arg_383_0)
					return arg_383_0.available_actions[iter_369_0]
				end
			}

			local var_369_18 = iter_369_1 % var_369_7 + 1
			local var_369_19 = var_369_9 + var_369_18
			local var_369_20 = var_369_5[var_369_18]
			local var_369_21 = arg_369_2[var_369_19]
			local var_369_22 = var_369_20[1] * var_369_21
			local var_369_23 = var_369_20[2] * var_369_21
			local var_369_24 = math.angle(var_369_14, var_369_15, var_369_22, var_369_23)

			var_369_24 = var_369_23 < var_369_15 and math.abs(var_369_24) or -var_369_24

			local var_369_25 = math.distance_2d(var_369_14, var_369_15, var_369_22, var_369_23)

			var_369_4[var_369_17] = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					var_369_25,
					6
				},
				angle = var_369_24,
				pivot = {
					0,
					3
				},
				color = var_369_8,
				offset = {
					var_369_0[1] + var_369_1[1] + var_369_14,
					var_369_0[2] + var_369_15,
					var_369_10
				}
			}
		end
	end

	var_369_3.nodes_progress = arg_369_2
	var_369_3.node_positions = var_369_5
	var_369_3.available_actions = var_369_6

	return {
		element = {
			passes = var_369_2
		},
		content = var_369_3,
		style = var_369_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_369_0
	}
end

UIWidgets.create_level_widget = function (arg_384_0)
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

UIWidgets.create_bot_cusomization_button = function (arg_385_0)
	local var_385_0 = 350
	local var_385_1 = arg_385_0.gui
	local var_385_2 = 50
	local var_385_3 = {
		font_size = 22,
		font_type = "hell_shark_masked"
	}
	local var_385_4, var_385_5 = UIFontByResolution(var_385_3)
	local var_385_6 = var_385_4[1]
	local var_385_7 = var_385_4[2]
	local var_385_8 = var_385_4[3]
	local var_385_9 = "MANAGING: "
	local var_385_10, var_385_11 = Gui.text_extents(var_385_1, var_385_9, var_385_6, var_385_7)
	local var_385_12 = var_385_11.x - var_385_10.x
	local var_385_13 = string.upper(Localize("lb_playing")) .. ": "
	local var_385_14, var_385_15 = Gui.text_extents(var_385_1, var_385_13, var_385_6, var_385_7)
	local var_385_16 = var_385_15.x - var_385_14.x
	local var_385_17 = var_385_2 + (var_385_16 < var_385_12 and var_385_12 or var_385_16)
	local var_385_18 = var_385_2 + math.max(var_385_16 - var_385_12, 0)
	local var_385_19 = var_385_2 + math.max(var_385_12 - var_385_16, 0)

	return {
		scenegraph_id = "bot_customization_button",
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_change_function = function (arg_386_0, arg_386_1)
						local var_386_0 = arg_386_0.parent

						arg_386_1.area_size[1] = 250 + var_386_0.progress * var_385_0
					end
				},
				{
					style_id = "left_texture_id",
					texture_id = "left_texture_id",
					pass_type = "texture",
					content_change_function = function (arg_387_0, arg_387_1)
						arg_387_1.offset[1] = arg_387_0.progress * -var_385_0
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
					content_change_function = function (arg_388_0, arg_388_1)
						arg_388_1.texture_size[1] = 100 + arg_388_0.progress * var_385_0
					end
				},
				{
					style_id = "left_texture_id",
					texture_id = "mask_id",
					pass_type = "texture",
					content_change_function = function (arg_389_0, arg_389_1)
						arg_389_1.offset[1] = arg_389_0.progress * -var_385_0
					end,
					content_change_function = function (arg_390_0, arg_390_1)
						arg_390_1.offset[1] = arg_390_0.progress * -var_385_0
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
					content_change_function = function (arg_391_0, arg_391_1)
						arg_391_1.texture_size[1] = 100 + arg_391_0.progress * var_385_0
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
					content_change_function = function (arg_392_0, arg_392_1)
						local var_392_0 = arg_392_0.button_hotspot.hover_progress

						arg_392_1.color = Colors.lerp_color_tables(arg_392_1.unselected_color, arg_392_1.selected_color, var_392_0)
					end
				},
				{
					style_id = "icon_unselected",
					texture_id = "icon_selected_id",
					pass_type = "texture",
					content_change_function = function (arg_393_0, arg_393_1)
						local var_393_0 = arg_393_0.button_hotspot

						arg_393_1.color[1] = 128 * (1 - var_393_0.hover_progress)
					end
				},
				{
					style_id = "icon_selected",
					texture_id = "icon_selected_id",
					pass_type = "texture",
					content_change_function = function (arg_394_0, arg_394_1)
						local var_394_0 = arg_394_0.button_hotspot

						arg_394_1.color[1] = 255 * var_394_0.hover_progress
					end
				},
				{
					style_id = "left_side_unselected",
					texture_id = "left_side_selected_id",
					pass_type = "texture",
					content_change_function = function (arg_395_0, arg_395_1)
						local var_395_0 = arg_395_0.button_hotspot

						arg_395_1.color[1] = 128 * (1 - var_395_0.hover_progress)
						arg_395_1.offset[1] = arg_395_0.progress * -var_385_0
					end
				},
				{
					style_id = "left_side_selected",
					texture_id = "left_side_selected_id",
					pass_type = "texture",
					content_change_function = function (arg_396_0, arg_396_1)
						local var_396_0 = arg_396_0.button_hotspot

						arg_396_1.color[1] = 255 * var_396_0.hover_progress
						arg_396_1.offset[1] = arg_396_0.progress * -var_385_0
					end
				},
				{
					style_id = "right_side_unselected",
					pass_type = "texture_uv",
					content_id = "right_side_selected_id",
					content_change_function = function (arg_397_0, arg_397_1)
						local var_397_0 = arg_397_0.parent.button_hotspot

						arg_397_1.color[1] = 128 * (1 - var_397_0.hover_progress)
					end
				},
				{
					style_id = "right_side_selected",
					pass_type = "texture_uv",
					content_id = "right_side_selected_id",
					content_change_function = function (arg_398_0, arg_398_1)
						local var_398_0 = arg_398_0.parent.button_hotspot

						arg_398_1.color[1] = 255 * var_398_0.hover_progress
					end
				},
				{
					style_id = "middle_unselected",
					texture_id = "middle_selected_id",
					pass_type = "texture",
					content_change_function = function (arg_399_0, arg_399_1)
						local var_399_0 = arg_399_0.button_hotspot

						arg_399_1.color[1] = 128 * (1 - var_399_0.hover_progress)
						arg_399_1.texture_size[1] = 100 + arg_399_0.progress * var_385_0
					end
				},
				{
					style_id = "middle_selected",
					texture_id = "middle_selected_id",
					pass_type = "texture",
					content_change_function = function (arg_400_0, arg_400_1)
						local var_400_0 = arg_400_0.button_hotspot

						arg_400_1.color[1] = 255 * var_400_0.hover_progress
						arg_400_1.texture_size[1] = 100 + arg_400_0.progress * var_385_0
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
			managing_header = var_385_9,
			playing_header = var_385_13
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
					var_385_0 + 250,
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
				font_size = var_385_3.font_size,
				font_type = var_385_3.font_type,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					var_385_18 - var_385_0,
					-17,
					4
				}
			},
			managing_header_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_385_3.font_size,
				font_type = var_385_3.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_385_18 + 2 - var_385_0,
					-19,
					3
				}
			},
			playing_header = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_385_3.font_size,
				font_type = var_385_3.font_type,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_385_19 - var_385_0,
					-47,
					4
				}
			},
			playing_header_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_385_3.font_size,
				font_type = var_385_3.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_385_19 + 2 - var_385_0,
					-49,
					3
				}
			},
			managing_career = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_385_3.font_size,
				font_type = var_385_3.font_type,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					var_385_17 + 5 - var_385_0,
					-17,
					4
				}
			},
			managing_career_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_385_3.font_size,
				font_type = var_385_3.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_385_17 + 5 + 2 - var_385_0,
					-19,
					3
				}
			},
			playing_career = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_385_3.font_size,
				font_type = var_385_3.font_type,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_385_17 + 5 - var_385_0,
					-47,
					4
				}
			},
			playing_career_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_385_3.font_size,
				font_type = var_385_3.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_385_17 + 5 + 2 - var_385_0,
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
	local var_402_0 = {
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
					content_check_function = function (arg_403_0, arg_403_1)
						return arg_403_0.use_empty_icon
					end
				},
				{
					style_id = "hourglass_icon",
					texture_id = "hourglass_icon",
					pass_type = "texture",
					content_check_function = function (arg_404_0, arg_404_1)
						return arg_404_0.use_empty_icon
					end,
					content_change_function = function (arg_405_0, arg_405_1)
						local var_405_0 = arg_405_0.is_hover and 255 or 184

						arg_405_1.color[1] = math.ceil(arg_405_1.color[1] + 0.1 * (var_405_0 - arg_405_1.color[1]))
					end
				},
				{
					pass_type = "texture",
					style_id = "bot_order_texture",
					texture_id = "bot_order_texture_id",
					content_check_function = function (arg_406_0, arg_406_1)
						return arg_406_0.bot_selection_active
					end
				},
				{
					pass_type = "texture",
					style_id = "bot_order_bg",
					texture_id = "bot_order_bg_id",
					content_check_function = function (arg_407_0, arg_407_1)
						return arg_407_0.bot_selection_active
					end
				},
				{
					style_id = "bot_order_hotspot",
					pass_type = "hotspot",
					content_id = "bot_order_hotspot",
					content_check_function = function (arg_408_0, arg_408_1)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "bot_order_button",
					texture_id = "bot_order_button",
					pass_type = "texture",
					content_check_function = function (arg_409_0, arg_409_1)
						local var_409_0 = arg_409_0.bot_change_order_hotspot

						return not Managers.input:is_device_active("gamepad") and not var_409_0.is_hover and not arg_409_0.bot_change_order_active and arg_409_0.bot_selection_active
					end,
					content_change_function = function (arg_410_0, arg_410_1)
						arg_410_1.color[1] = 128
					end
				},
				{
					style_id = "bot_order_button",
					texture_id = "bot_order_highlight_button",
					pass_type = "texture",
					content_check_function = function (arg_411_0, arg_411_1)
						local var_411_0 = arg_411_0.bot_change_order_hotspot

						return not Managers.input:is_device_active("gamepad") and var_411_0.is_hover and not arg_411_0.bot_change_order_active and arg_411_0.bot_selection_active
					end,
					content_change_function = function (arg_412_0, arg_412_1)
						arg_412_1.color[1] = 255
					end
				},
				{
					style_id = "bot_change_order_hotspot",
					pass_type = "hotspot",
					content_id = "bot_change_order_hotspot",
					content_check_function = function (arg_413_0, arg_413_1)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "bot_change_order_button",
					texture_id = "bot_change_order_button",
					pass_type = "texture",
					content_check_function = function (arg_414_0, arg_414_1)
						return not Managers.input:is_device_active("gamepad") and arg_414_0.bot_change_order_active and arg_414_0.bot_selection_active and not arg_414_0.bot_change_order_hotspot.is_hover
					end,
					content_change_function = function (arg_415_0, arg_415_1)
						local var_415_0 = arg_415_0.bot_change_order_hotspot

						arg_415_1.color[1] = var_415_0.is_hover and 255 or 128
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (arg_416_0)
						return not arg_416_0.selected and not arg_416_0.bot_selection_active
					end
				},
				{
					texture_id = "icon_selected",
					style_id = "icon_selected",
					pass_type = "texture",
					content_check_function = function (arg_417_0)
						return arg_417_0.selected and not arg_417_0.bot_selection_active
					end
				},
				{
					texture_id = "holder",
					style_id = "holder",
					pass_type = "texture",
					content_check_function = function (arg_418_0)
						return not arg_418_0.bot_selection_active
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
				texture_size = var_402_0,
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
				texture_size = var_402_0,
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
	local var_419_0 = UIFrameSettings.menu_frame_12
	local var_419_1 = UIFrameSettings.frame_corner_detail_01_gold
	local var_419_2 = UIFrameSettings.frame_outer_glow_01
	local var_419_3 = var_419_2.texture_sizes.horizontal[2]
	local var_419_4 = "frame_inner_glow_03"
	local var_419_5 = UIFrameSettings[var_419_4]

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
					content_check_function = function (arg_420_0)
						return arg_420_0.locked
					end
				},
				{
					texture_id = "taken_texture",
					style_id = "taken_texture",
					pass_type = "texture",
					content_check_function = function (arg_421_0)
						return arg_421_0.taken and not arg_421_0.locked
					end
				},
				{
					texture_id = "bot_frame",
					style_id = "bot_frame",
					pass_type = "texture_frame",
					content_check_function = function (arg_422_0)
						return arg_422_0.bot_selected
					end
				},
				{
					texture_id = "bot_texture",
					style_id = "bot_texture",
					pass_type = "texture",
					content_check_function = function (arg_423_0)
						return arg_423_0.bot_selected
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
					content_check_function = function (arg_424_0)
						return arg_424_0.is_premium
					end
				},
				{
					style_id = "overlay",
					pass_type = "rect",
					content_check_function = function (arg_425_0)
						local var_425_0 = arg_425_0.button_hotspot

						return not var_425_0.is_hover and not var_425_0.is_selected and not arg_425_0.locked
					end
				},
				{
					style_id = "overlay_locked",
					pass_type = "rect",
					content_check_function = function (arg_426_0)
						local var_426_0 = arg_426_0.button_hotspot

						return arg_426_0.locked
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "hover_frame",
					texture_id = "hover_frame",
					content_check_function = function (arg_427_0)
						local var_427_0 = Managers.input:is_device_active("mouse")

						return arg_427_0.button_hotspot.is_selected and (not arg_427_0.bot_selection_active or not var_427_0)
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
			frame = var_419_0.texture,
			frame_premium = var_419_1.texture,
			hover_frame = var_419_2.texture
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
				texture_size = var_419_0.texture_size,
				texture_sizes = var_419_0.texture_sizes,
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
				texture_size = var_419_1.texture_size,
				texture_sizes = var_419_1.texture_sizes,
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
				texture_size = var_419_2.texture_size,
				texture_sizes = var_419_2.texture_sizes,
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

UIWidgets.create_bot_cusomization_button = function (arg_429_0)
	local var_429_0 = 350
	local var_429_1 = arg_429_0.gui
	local var_429_2 = 50
	local var_429_3 = {
		font_size = 22,
		font_type = "hell_shark_masked"
	}
	local var_429_4, var_429_5 = UIFontByResolution(var_429_3)
	local var_429_6 = var_429_4[1]
	local var_429_7 = var_429_4[2]
	local var_429_8 = var_429_4[3]
	local var_429_9 = "MANAGING: "
	local var_429_10, var_429_11 = Gui.text_extents(var_429_1, var_429_9, var_429_6, var_429_7)
	local var_429_12 = var_429_11.x - var_429_10.x
	local var_429_13 = string.upper(Localize("lb_playing")) .. ": "
	local var_429_14, var_429_15 = Gui.text_extents(var_429_1, var_429_13, var_429_6, var_429_7)
	local var_429_16 = var_429_15.x - var_429_14.x
	local var_429_17 = var_429_2 + (var_429_16 < var_429_12 and var_429_12 or var_429_16)
	local var_429_18 = var_429_2 + math.max(var_429_16 - var_429_12, 0)
	local var_429_19 = var_429_2 + math.max(var_429_12 - var_429_16, 0)

	return {
		scenegraph_id = "bot_customization_button",
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_change_function = function (arg_430_0, arg_430_1)
						local var_430_0 = arg_430_0.parent

						arg_430_1.area_size[1] = 250 + var_430_0.progress * var_429_0
					end
				},
				{
					style_id = "left_texture_id",
					texture_id = "left_texture_id",
					pass_type = "texture",
					content_change_function = function (arg_431_0, arg_431_1)
						arg_431_1.offset[1] = arg_431_0.progress * -var_429_0
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
					content_change_function = function (arg_432_0, arg_432_1)
						arg_432_1.texture_size[1] = 100 + arg_432_0.progress * var_429_0
					end
				},
				{
					style_id = "left_texture_id",
					texture_id = "mask_id",
					pass_type = "texture",
					content_change_function = function (arg_433_0, arg_433_1)
						arg_433_1.offset[1] = arg_433_0.progress * -var_429_0
					end,
					content_change_function = function (arg_434_0, arg_434_1)
						arg_434_1.offset[1] = arg_434_0.progress * -var_429_0
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
					content_change_function = function (arg_435_0, arg_435_1)
						arg_435_1.texture_size[1] = 100 + arg_435_0.progress * var_429_0
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
					content_change_function = function (arg_436_0, arg_436_1)
						local var_436_0 = arg_436_0.button_hotspot.hover_progress

						arg_436_1.color = Colors.lerp_color_tables(arg_436_1.unselected_color, arg_436_1.selected_color, var_436_0)
					end
				},
				{
					style_id = "icon_unselected",
					texture_id = "icon_selected_id",
					pass_type = "texture",
					content_change_function = function (arg_437_0, arg_437_1)
						local var_437_0 = arg_437_0.button_hotspot

						arg_437_1.color[1] = 128 * (1 - var_437_0.hover_progress)
					end
				},
				{
					style_id = "icon_selected",
					texture_id = "icon_selected_id",
					pass_type = "texture",
					content_change_function = function (arg_438_0, arg_438_1)
						local var_438_0 = arg_438_0.button_hotspot

						arg_438_1.color[1] = 255 * var_438_0.hover_progress
					end
				},
				{
					style_id = "left_side_unselected",
					texture_id = "left_side_selected_id",
					pass_type = "texture",
					content_change_function = function (arg_439_0, arg_439_1)
						local var_439_0 = arg_439_0.button_hotspot

						arg_439_1.color[1] = 128 * (1 - var_439_0.hover_progress)
						arg_439_1.offset[1] = arg_439_0.progress * -var_429_0
					end
				},
				{
					style_id = "left_side_selected",
					texture_id = "left_side_selected_id",
					pass_type = "texture",
					content_change_function = function (arg_440_0, arg_440_1)
						local var_440_0 = arg_440_0.button_hotspot

						arg_440_1.color[1] = 255 * var_440_0.hover_progress
						arg_440_1.offset[1] = arg_440_0.progress * -var_429_0
					end
				},
				{
					style_id = "right_side_unselected",
					pass_type = "texture_uv",
					content_id = "right_side_selected_id",
					content_change_function = function (arg_441_0, arg_441_1)
						local var_441_0 = arg_441_0.parent.button_hotspot

						arg_441_1.color[1] = 128 * (1 - var_441_0.hover_progress)
					end
				},
				{
					style_id = "right_side_selected",
					pass_type = "texture_uv",
					content_id = "right_side_selected_id",
					content_change_function = function (arg_442_0, arg_442_1)
						local var_442_0 = arg_442_0.parent.button_hotspot

						arg_442_1.color[1] = 255 * var_442_0.hover_progress
					end
				},
				{
					style_id = "middle_unselected",
					texture_id = "middle_selected_id",
					pass_type = "texture",
					content_change_function = function (arg_443_0, arg_443_1)
						local var_443_0 = arg_443_0.button_hotspot

						arg_443_1.color[1] = 128 * (1 - var_443_0.hover_progress)
						arg_443_1.texture_size[1] = 100 + arg_443_0.progress * var_429_0
					end
				},
				{
					style_id = "middle_selected",
					texture_id = "middle_selected_id",
					pass_type = "texture",
					content_change_function = function (arg_444_0, arg_444_1)
						local var_444_0 = arg_444_0.button_hotspot

						arg_444_1.color[1] = 255 * var_444_0.hover_progress
						arg_444_1.texture_size[1] = 100 + arg_444_0.progress * var_429_0
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
			managing_header = var_429_9,
			playing_header = var_429_13
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
					var_429_0 + 250,
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
				font_size = var_429_3.font_size,
				font_type = var_429_3.font_type,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					var_429_18 - var_429_0,
					-17,
					4
				}
			},
			managing_header_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_429_3.font_size,
				font_type = var_429_3.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_429_18 + 2 - var_429_0,
					-19,
					3
				}
			},
			playing_header = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_429_3.font_size,
				font_type = var_429_3.font_type,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_429_19 - var_429_0,
					-47,
					4
				}
			},
			playing_header_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_429_3.font_size,
				font_type = var_429_3.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_429_19 + 2 - var_429_0,
					-49,
					3
				}
			},
			managing_career = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_429_3.font_size,
				font_type = var_429_3.font_type,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					var_429_17 + 5 - var_429_0,
					-17,
					4
				}
			},
			managing_career_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_429_3.font_size,
				font_type = var_429_3.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_429_17 + 5 + 2 - var_429_0,
					-19,
					3
				}
			},
			playing_career = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_429_3.font_size,
				font_type = var_429_3.font_type,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_429_17 + 5 - var_429_0,
					-47,
					4
				}
			},
			playing_career_shadow = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				font_size = var_429_3.font_size,
				font_type = var_429_3.font_type,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					var_429_17 + 5 + 2 - var_429_0,
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

	local var_446_0 = table.clone(arg_446_2)

	var_446_0.text_color = {
		255,
		0,
		0,
		0
	}
	var_446_0.offset = {
		2,
		-2,
		1
	}

	local var_446_1 = Managers.ui:ingame_ui().ui_renderer
	local var_446_2, var_446_3 = UIFontByResolution(arg_446_2)
	local var_446_4, var_446_5, var_446_6 = UIRenderer.text_size(var_446_1, arg_446_1, var_446_2[1], var_446_3)
	local var_446_7 = {}
	local var_446_8 = {
		passes = {}
	}
	local var_446_9 = var_446_8.passes
	local var_446_10 = {}
	local var_446_11 = {}

	var_446_9[#var_446_9 + 1] = {
		pass_type = "rounded_background",
		style_id = "background"
	}
	var_446_9[#var_446_9 + 1] = {
		style_id = "text",
		pass_type = "text",
		text_id = "text"
	}
	var_446_9[#var_446_9 + 1] = {
		style_id = "text_shadow",
		pass_type = "text",
		text_id = "text",
		content_check_function = function (arg_447_0, arg_447_1)
			return arg_447_1.use_shadow
		end
	}
	var_446_10.text = arg_446_1
	var_446_10.size = {
		arg_446_5[1] or var_446_4 + var_446_3 * 0.5,
		arg_446_5[2] or var_446_5 + var_446_3 * 0.5
	}
	var_446_11.background = {
		vertical_alignment = "center",
		corner_radius = 10,
		horizontal_alignment = "center",
		color = arg_446_3 or {
			255,
			71,
			71,
			71
		},
		rect_size = {
			arg_446_5[1] or var_446_4 + var_446_3 * 0.5,
			arg_446_5[2] or var_446_5 + var_446_3 * 0.5
		},
		offset = {
			0,
			var_446_3 * 0.05,
			0
		}
	}
	var_446_11.text = arg_446_2
	var_446_11.text_shadow = var_446_0
	var_446_7.element = var_446_8
	var_446_7.content = var_446_10
	var_446_7.style = var_446_11
	var_446_7.scenegraph_id = arg_446_0
	var_446_7.offset = {
		0,
		0,
		0
	}

	return var_446_7
end

UIWidgets.create_simple_triangle = function (arg_448_0, arg_448_1, arg_448_2, arg_448_3, arg_448_4)
	local var_448_0 = {}
	local var_448_1 = {
		passes = {}
	}
	local var_448_2 = var_448_1.passes
	local var_448_3 = {}
	local var_448_4 = {}

	var_448_2[#var_448_2 + 1] = {
		pass_type = "triangle",
		style_id = "triangle"
	}
	var_448_4.triangle = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		triangle_alignment = arg_448_2,
		texture_size = arg_448_3,
		color = arg_448_1
	}
	var_448_3.disable_with_gamepad = arg_448_4
	var_448_0.element = var_448_1
	var_448_0.content = var_448_3
	var_448_0.style = var_448_4
	var_448_0.scenegraph_id = arg_448_0
	var_448_0.offset = {
		0,
		0,
		0
	}

	return var_448_0
end

UIWidgets.create_overcharge_bar_widget = function (arg_449_0, arg_449_1, arg_449_2, arg_449_3, arg_449_4, arg_449_5, arg_449_6)
	local var_449_0 = arg_449_5 or {
		250,
		16
	}
	local var_449_1 = arg_449_3 and UIFrameSettings[arg_449_3] or UIFrameSettings.frame_outer_glow_01
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
				var_449_0[1] - 6,
				var_449_0[2]
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
				size = var_449_0
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
					var_449_0[1] - 6,
					var_449_0[2] - 6
				}
			},
			icon = {
				size = {
					34,
					34
				},
				offset = {
					var_449_0[1],
					var_449_0[2] / 2 - 17,
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
					var_449_0[1] + 2,
					var_449_0[2] / 2 - 17 - 2,
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
				size = var_449_0
			},
			bar_bg = {
				size = {
					var_449_0[1] - 6,
					var_449_0[2] - 5
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
					var_449_0[2] - 6
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
					var_449_0[2] - 6
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
	local var_450_0 = {
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
	local var_450_1 = table.clone(var_450_0)

	var_450_1.text_color = {
		255,
		0,
		0,
		0
	}
	var_450_1.offset = {
		2,
		-2,
		1
	}

	local var_450_2 = Managers.ui:ingame_ui().ui_renderer
	local var_450_3, var_450_4 = UIFontByResolution(var_450_0)
	local var_450_5, var_450_6, var_450_7 = UIRenderer.text_size(var_450_2, arg_450_1, var_450_3[1], var_450_4)
	local var_450_8 = {}
	local var_450_9 = {
		passes = {}
	}
	local var_450_10 = var_450_9.passes
	local var_450_11 = {}
	local var_450_12 = {}

	var_450_10[#var_450_10 + 1] = {
		style_id = "background",
		pass_type = "rect",
		content_check_function = function (arg_451_0, arg_451_1)
			return true
		end
	}
	var_450_10[#var_450_10 + 1] = {
		texture_id = "fade",
		style_id = "fade",
		pass_type = "texture"
	}
	var_450_10[#var_450_10 + 1] = {
		texture_id = "vignette",
		style_id = "vignette",
		pass_type = "texture"
	}
	var_450_10[#var_450_10 + 1] = {
		texture_id = "frame",
		style_id = "frame",
		pass_type = "texture"
	}
	var_450_10[#var_450_10 + 1] = {
		style_id = "text",
		pass_type = "text",
		text_id = "text"
	}
	var_450_10[#var_450_10 + 1] = {
		style_id = "text_shadow",
		pass_type = "text",
		text_id = "text",
		content_check_function = function (arg_452_0, arg_452_1)
			return arg_452_1.use_shadow
		end
	}
	var_450_11.text = arg_450_1
	var_450_11.size = {
		arg_450_2[1] or var_450_5 + var_450_4 * 0.5,
		arg_450_2[2] or var_450_6 + var_450_4 * 0.5
	}
	var_450_11.fade = "button_state_default"
	var_450_11.vignette = "button_bg_fade"
	var_450_11.frame = "menu_frame_glass_01"
	var_450_12.background = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = {
			255,
			30,
			30,
			30
		},
		texture_size = {
			arg_450_2[1] or var_450_5 + var_450_4 * 0.5,
			arg_450_2[2] or var_450_6 + var_450_4 * 0.5
		},
		offset = {
			0,
			var_450_4 * 0.05,
			0
		}
	}
	var_450_12.vignette = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		color = {
			100,
			255,
			255,
			255
		},
		texture_size = {
			arg_450_2[1] or var_450_5 + var_450_4 * 0.5,
			arg_450_2[2] or var_450_6 + var_450_4 * 0.5
		},
		offset = {
			0,
			var_450_4 * 0.05,
			1
		}
	}
	var_450_12.fade = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			arg_450_2[1] or var_450_5 + var_450_4 * 0.5,
			arg_450_2[2] or var_450_6 + var_450_4 * 0.5
		},
		offset = {
			0,
			var_450_4 * 0.05,
			2
		}
	}
	var_450_12.frame = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			arg_450_2[1] or var_450_5 + var_450_4 * 0.5,
			arg_450_2[2] or var_450_6 + var_450_4 * 0.5
		},
		offset = {
			0,
			var_450_4 * 0.05,
			3
		}
	}
	var_450_12.text = var_450_0
	var_450_12.text_shadow = var_450_1
	var_450_8.element = var_450_9
	var_450_8.content = var_450_11
	var_450_8.style = var_450_12
	var_450_8.scenegraph_id = arg_450_0
	var_450_8.offset = {
		0,
		0,
		0
	}

	return var_450_8
end

UIWidgets.create_loading_spinner = function (arg_453_0)
	return {
		scenegraph_id = arg_453_0,
		element = {
			passes = {
				{
					style_id = "loading_icon",
					texture_id = "loading_icon",
					pass_type = "rotated_texture",
					content_change_function = function (arg_454_0, arg_454_1, arg_454_2, arg_454_3)
						local var_454_0 = (arg_454_0.loading_progress + arg_454_3) % 1

						arg_454_1.angle = 2^math.smoothstep(var_454_0, 0, 1) * math.tau
						arg_454_0.loading_progress = var_454_0
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
