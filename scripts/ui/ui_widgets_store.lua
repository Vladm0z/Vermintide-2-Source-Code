-- chunkname: @scripts/ui/ui_widgets_store.lua

require("scripts/settings/ui_frame_settings")
require("scripts/settings/ui_player_portrait_frame_settings")

UIWidgets = UIWidgets or {}

UIWidgets.create_store_category_entry_definition = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = "button_frame_02_gold"
	local var_1_1 = UIFrameSettings[var_1_0]
	local var_1_2 = var_1_1.texture_sizes.horizontal[2]
	local var_1_3 = "frame_outer_glow_04"
	local var_1_4 = UIFrameSettings[var_1_3]
	local var_1_5 = var_1_4.texture_sizes.horizontal[2]
	local var_1_6 = "frame_outer_glow_04_big"
	local var_1_7 = UIFrameSettings[var_1_6]
	local var_1_8 = var_1_7.texture_sizes.horizontal[2]
	local var_1_9 = {
		element = {}
	}
	local var_1_10 = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "background_fade",
			texture_id = "background_fade"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
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
			style_id = "title",
			pass_type = "text",
			text_id = "title"
		},
		{
			style_id = "title_shadow",
			pass_type = "text",
			text_id = "title"
		},
		{
			pass_type = "texture",
			style_id = "category_texture",
			texture_id = "category_texture",
			content_check_function = function (arg_2_0)
				return arg_2_0.category_texture
			end
		}
	}
	local var_1_11 = {
		title = "n/a",
		background_fade = "options_window_fade_01",
		background = "menu_frame_bg_03",
		category_texture = "store_category_icon_hats",
		hotspot = {},
		hover_frame = var_1_4.texture,
		pulse_frame = var_1_7.texture,
		frame = var_1_1.texture,
		size = arg_1_1
	}
	local var_1_12 = {
		hotspot = {
			size = arg_1_1,
			offset = {
				0,
				0,
				0
			}
		},
		background = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			masked = arg_1_2,
			color = {
				255,
				100,
				100,
				100
			},
			texture_tiling_size = {
				256,
				256
			},
			texture_size = arg_1_1,
			offset = {
				0,
				0,
				0
			}
		},
		background_fade = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			masked = arg_1_2,
			texture_size = {
				arg_1_1[1] - var_1_2 * 2,
				arg_1_1[2] - var_1_2 * 2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_1_2,
				var_1_2,
				1
			}
		},
		frame = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			masked = arg_1_2,
			area_size = arg_1_1,
			texture_size = var_1_1.texture_size,
			texture_sizes = var_1_1.texture_sizes,
			frame_margins = {
				0,
				0
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
		hover_frame = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			masked = arg_1_2,
			area_size = arg_1_1,
			texture_size = var_1_4.texture_size,
			texture_sizes = var_1_4.texture_sizes,
			frame_margins = {
				-var_1_5,
				-var_1_5
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
			masked = arg_1_2,
			area_size = arg_1_1,
			texture_size = var_1_7.texture_size,
			texture_sizes = var_1_7.texture_sizes,
			frame_margins = {
				-var_1_8,
				-var_1_8
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
		category_texture = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			masked = arg_1_2,
			size = {
				arg_1_1[1],
				arg_1_1[2]
			},
			texture_size = {
				258,
				80
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				0,
				3
			}
		},
		title = {
			word_wrap = true,
			upper_case = false,
			localize = false,
			font_size = 42,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_1_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				30,
				0,
				5
			},
			size = {
				arg_1_1[1] - 40,
				arg_1_1[2]
			}
		},
		title_shadow = {
			word_wrap = true,
			upper_case = false,
			localize = false,
			font_size = 42,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_1_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			normal_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				32,
				-2,
				4
			},
			size = {
				arg_1_1[1] - 40,
				arg_1_1[2]
			}
		}
	}

	var_1_9.element.passes = var_1_10
	var_1_9.content = var_1_11
	var_1_9.style = var_1_12
	var_1_9.offset = {
		0,
		0,
		0
	}
	var_1_9.scenegraph_id = arg_1_0

	return var_1_9
end

UIWidgets.create_store_collection_entry_definition = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = "button_frame_02_gold"
	local var_3_1 = UIFrameSettings[var_3_0]
	local var_3_2 = var_3_1.texture_sizes.horizontal[2]
	local var_3_3 = "frame_outer_glow_04"
	local var_3_4 = UIFrameSettings[var_3_3]
	local var_3_5 = var_3_4.texture_sizes.horizontal[2]
	local var_3_6 = "frame_outer_glow_04_big"
	local var_3_7 = UIFrameSettings[var_3_6]
	local var_3_8 = var_3_7.texture_sizes.horizontal[2]
	local var_3_9 = {
		element = {}
	}
	local var_3_10 = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "tiled_texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "background_fade",
			texture_id = "background_fade"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
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
			style_id = "title",
			pass_type = "text",
			text_id = "title"
		},
		{
			style_id = "title_shadow",
			pass_type = "text",
			text_id = "title"
		},
		{
			style_id = "category_texture",
			pass_type = "texture_uv",
			content_id = "category_texture",
			content_check_function = function (arg_4_0)
				return arg_4_0.texture_id
			end
		},
		{
			pass_type = "texture",
			style_id = "owned_icon",
			texture_id = "owned_icon",
			content_check_function = function (arg_5_0)
				return arg_5_0.owned
			end
		},
		{
			pass_type = "texture",
			style_id = "owned_icon_bg",
			texture_id = "owned_icon_bg",
			content_check_function = function (arg_6_0)
				return arg_6_0.owned
			end
		}
	}
	local var_3_11 = {
		owned_icon_bg = "store_owned_ribbon",
		owned_icon = "store_owned_sigil",
		title = "n/a",
		background_fade = "options_window_fade_01",
		background = "menu_frame_bg_03",
		hotspot = {},
		hover_frame = var_3_4.texture,
		pulse_frame = var_3_7.texture,
		frame = var_3_1.texture,
		category_texture = {
			texture_id = "icons_placeholder",
			uvs = {
				{
					0,
					arg_3_1[2] / 220 * 0.5
				},
				{
					1,
					1 - arg_3_1[2] / 220 * 0.5
				}
			}
		},
		size = arg_3_1
	}
	local var_3_12 = {
		hotspot = {
			size = arg_3_1,
			offset = {
				0,
				0,
				0
			}
		},
		background = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			masked = arg_3_2,
			color = {
				255,
				100,
				100,
				100
			},
			texture_tiling_size = {
				256,
				256
			},
			texture_size = arg_3_1,
			offset = {
				0,
				0,
				0
			}
		},
		background_fade = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			masked = arg_3_2,
			texture_size = {
				arg_3_1[1] - var_3_2 * 2,
				arg_3_1[2] - var_3_2 * 2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_3_2,
				var_3_2,
				1
			}
		},
		frame = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			masked = arg_3_2,
			area_size = arg_3_1,
			texture_size = var_3_1.texture_size,
			texture_sizes = var_3_1.texture_sizes,
			frame_margins = {
				0,
				0
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
		hover_frame = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			masked = arg_3_2,
			area_size = arg_3_1,
			texture_size = var_3_4.texture_size,
			texture_sizes = var_3_4.texture_sizes,
			frame_margins = {
				-var_3_5,
				-var_3_5
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
			masked = arg_3_2,
			area_size = arg_3_1,
			texture_size = var_3_7.texture_size,
			texture_sizes = var_3_7.texture_sizes,
			frame_margins = {
				-var_3_8,
				-var_3_8
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
		category_texture = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			masked = arg_3_2,
			size = {
				arg_3_1[1],
				arg_3_1[2]
			},
			texture_size = {
				130,
				80
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				0,
				3
			}
		},
		title = {
			word_wrap = false,
			upper_case = false,
			localize = false,
			font_size = 42,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_3_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				30,
				0,
				5
			},
			size = {
				arg_3_1[1] - 170,
				arg_3_1[2]
			}
		},
		title_shadow = {
			word_wrap = false,
			upper_case = false,
			localize = false,
			font_size = 42,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_3_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			normal_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				32,
				-2,
				4
			},
			size = {
				arg_3_1[1] - 170,
				arg_3_1[2]
			}
		},
		owned_icon = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			masked = arg_3_2,
			texture_size = {
				53,
				53
			},
			default_texture_size = {
				53,
				53
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_3_1[1] - 45,
				0,
				12
			}
		},
		owned_icon_bg = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			masked = arg_3_2,
			texture_size = {
				34,
				50
			},
			default_texture_size = {
				34,
				50
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_3_1[1] - 35,
				-15,
				11
			}
		}
	}

	var_3_9.element.passes = var_3_10
	var_3_9.content = var_3_11
	var_3_9.style = var_3_12
	var_3_9.offset = {
		0,
		0,
		0
	}
	var_3_9.scenegraph_id = arg_3_0

	return var_3_9
end

local var_0_0 = {}

UIWidgets.create_store_item_definition = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = "menu_frame_16"
	local var_7_1 = UIFrameSettings[var_7_0]
	local var_7_2 = "frame_outer_glow_04"
	local var_7_3 = UIFrameSettings[var_7_2]
	local var_7_4 = var_7_3.texture_sizes.horizontal[2]
	local var_7_5 = "frame_outer_glow_04_big"
	local var_7_6 = UIFrameSettings[var_7_5]
	local var_7_7 = var_7_6.texture_sizes.horizontal[2]
	local var_7_8 = arg_7_4 or arg_7_3.parent_settings or arg_7_3.settings or var_0_0
	local var_7_9 = arg_7_3.dlc_settings or var_0_0
	local var_7_10 = var_7_8.icon_size
	local var_7_11 = {
		element = {}
	}
	local var_7_12 = {
		{
			style_id = "hotspot",
			pass_type = "hotspot",
			content_id = "hotspot"
		},
		{
			pass_type = "texture",
			style_id = "overlay",
			texture_id = "rect"
		},
		{
			pass_type = "texture",
			style_id = "background_rect",
			texture_id = "rect"
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background",
			content_check_function = function (arg_8_0)
				return arg_8_0.background
			end
		},
		{
			pass_type = "texture",
			style_id = "expire_time_icon",
			texture_id = "expire_time_icon",
			content_check_function = function (arg_9_0)
				return arg_9_0.discount
			end
		},
		{
			pass_type = "texture",
			style_id = "background_price",
			texture_id = "background_price",
			content_check_function = function (arg_10_0)
				return not arg_10_0.owned and (IS_WINDOWS or not arg_10_0.real_currency) and not arg_10_0.hide_price and not arg_10_0.old_price
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "background_price_center",
			texture_id = "background_price_center",
			content_check_function = function (arg_11_0)
				return not arg_11_0.owned and (IS_WINDOWS or not arg_11_0.real_currency) and not arg_11_0.hide_price and not arg_11_0.old_price
			end
		},
		{
			pass_type = "texture",
			style_id = "background_price_right",
			texture_id = "background_price_right",
			content_check_function = function (arg_12_0)
				return not arg_12_0.owned and (IS_WINDOWS or not arg_12_0.real_currency) and not arg_12_0.hide_price and not arg_12_0.old_price
			end
		},
		{
			pass_type = "texture",
			style_id = "price_gradient",
			texture_id = "price_gradient",
			content_check_function = function (arg_13_0)
				return not arg_13_0.owned and (IS_WINDOWS or not arg_13_0.real_currency) and not arg_13_0.hide_price and arg_13_0.old_price
			end
		},
		{
			texture_id = "price_strike_through",
			style_id = "price_strike_through",
			pass_type = "rotated_texture",
			content_check_function = function (arg_14_0)
				return not arg_14_0.owned and (IS_WINDOWS or not arg_14_0.real_currency) and not arg_14_0.hide_price and arg_14_0.old_price and arg_14_0.discount
			end
		},
		{
			pass_type = "texture",
			style_id = "price_icon",
			texture_id = "price_icon",
			content_check_function = function (arg_15_0)
				return not arg_15_0.owned and arg_15_0.draw_price_icon
			end
		},
		{
			style_id = "optional_item_name",
			pass_type = "text",
			text_id = "optional_item_name",
			content_check_function = function (arg_16_0)
				return arg_16_0.optional_item_name ~= ""
			end
		},
		{
			style_id = "optional_subtitle",
			pass_type = "text",
			text_id = "optional_subtitle",
			content_check_function = function (arg_17_0)
				return arg_17_0.optional_item_name ~= ""
			end
		},
		{
			style_id = "price_text",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (arg_18_0)
				return not arg_18_0.owned and (IS_WINDOWS or not arg_18_0.real_currency) and not arg_18_0.hide_price and not arg_18_0.old_price
			end
		},
		{
			style_id = "price_text_now",
			pass_type = "text",
			text_id = "price_text_now",
			content_check_function = function (arg_19_0)
				return not arg_19_0.owned and (IS_WINDOWS or not arg_19_0.real_currency) and not arg_19_0.hide_price and arg_19_0.old_price
			end
		},
		{
			style_id = "price_text_before",
			pass_type = "text",
			text_id = "price_text_before",
			content_check_function = function (arg_20_0)
				return not arg_20_0.owned and (IS_WINDOWS or not arg_20_0.real_currency) and not arg_20_0.hide_price and arg_20_0.old_price and arg_20_0.discount
			end
		},
		{
			pass_type = "texture",
			style_id = "owned_icon",
			texture_id = "owned_icon",
			content_check_function = function (arg_21_0)
				return arg_21_0.owned
			end
		},
		{
			pass_type = "texture",
			style_id = "owned_icon_bg",
			texture_id = "owned_icon_bg",
			content_check_function = function (arg_22_0)
				return arg_22_0.owned
			end
		},
		{
			pass_type = "texture",
			style_id = "discount_bg",
			texture_id = "discount_bg",
			content_check_function = function (arg_23_0)
				return arg_23_0.discount and not arg_23_0.hide_price
			end
		},
		{
			pass_type = "multi_texture",
			style_id = "discont_number_icons",
			texture_id = "discont_number_icons",
			content_check_function = function (arg_24_0)
				return arg_24_0.discount and not arg_24_0.hide_price
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
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
			style_id = "loading_icon",
			pass_type = "rotated_texture",
			texture_id = "loading_icon",
			content_check_function = function (arg_25_0)
				return not arg_25_0.icon
			end,
			content_change_function = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				local var_26_0 = ((arg_26_1.progress or 0) + arg_26_3) % 1

				arg_26_1.angle = math.pow(2, math.smoothstep(var_26_0, 0, 1)) * (math.pi * 2)
				arg_26_1.progress = var_26_0
			end
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (arg_27_0)
				return arg_27_0.icon and not arg_27_0.rendering_loading_icon
			end
		},
		{
			style_id = "bundle_content_amount_text",
			pass_type = "text",
			text_id = "bundle_content_amount_text"
		},
		{
			pass_type = "texture",
			style_id = "type_tag_icon",
			texture_id = "type_tag_icon",
			content_check_function = function (arg_28_0, arg_28_1)
				return arg_28_0.type_tag_icon
			end
		},
		{
			pass_type = "texture",
			style_id = "psplus_icon",
			texture_id = "psplus_icon",
			content_check_function = function (arg_29_0)
				return arg_29_0.show_ps4_plus and IS_PS4 and arg_29_0.real_currency
			end
		},
		{
			pass_type = "texture",
			style_id = "console_background_rect_bottom",
			texture_id = "console_background_rect",
			content_check_function = function (arg_30_0)
				return not IS_WINDOWS and arg_30_0.real_currency
			end
		},
		{
			pass_type = "texture",
			style_id = "console_background_rect_top",
			texture_id = "console_background_rect",
			content_check_function = function (arg_31_0)
				return not IS_WINDOWS and arg_31_0.real_currency and arg_31_0.console_secondary_price_text ~= ""
			end
		},
		{
			texture_id = "console_secondary_price_stroke",
			style_id = "console_secondary_price_stroke",
			pass_type = "texture",
			content_check_function = function (arg_32_0)
				return arg_32_0.show_secondary_stroke and not IS_WINDOWS and arg_32_0.real_currency
			end
		},
		{
			texture_id = "console_third_price_stroke",
			style_id = "console_third_price_stroke",
			pass_type = "texture",
			content_check_function = function (arg_33_0)
				return arg_33_0.show_third_stroke and IS_PS4 and arg_33_0.real_currency
			end
		},
		{
			style_id = "console_first_price_text",
			pass_type = "text",
			text_id = "console_first_price_text",
			content_check_function = function (arg_34_0)
				return not IS_WINDOWS and arg_34_0.real_currency
			end,
			content_change_function = function (arg_35_0, arg_35_1)
				arg_35_1.text_color = arg_35_0.show_ps4_plus and arg_35_1.ps_plus_color or arg_35_1.base_color
			end
		},
		{
			style_id = "console_secondary_price_text",
			pass_type = "text",
			text_id = "console_secondary_price_text",
			content_check_function = function (arg_36_0)
				return arg_36_0.console_secondary_price_text ~= "" and not IS_WINDOWS and arg_36_0.real_currency
			end
		},
		{
			style_id = "console_third_price_text",
			pass_type = "text",
			text_id = "console_third_price_text",
			content_check_function = function (arg_37_0)
				return arg_37_0.console_third_price_text ~= "" and IS_PS4 and arg_37_0.real_currency
			end
		},
		{
			style_id = "new_marker",
			pass_type = "texture",
			texture_id = "new_marker",
			content_check_function = function (arg_38_0)
				if arg_38_0.discount then
					return false
				end

				return not PlayerData.seen_shop_items[arg_38_0.item_key] and not arg_38_0.hide_new
			end,
			content_change_function = function (arg_39_0, arg_39_1)
				if not PlayerData.seen_shop_items[arg_39_0.item_key] then
					local var_39_0 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

					arg_39_1.color[1] = 100 + 155 * var_39_0
				end
			end
		},
		{
			style_id = "additional_content_added",
			pass_type = "text",
			text_id = "additional_content_added",
			content_check_function = function (arg_40_0)
				return IS_CONSOLE and var_7_9.additional_content_added and not arg_40_0.owned
			end,
			content_change_function = function (arg_41_0, arg_41_1)
				local var_41_0 = Application.time_since_launch()
				local var_41_1 = 0.5 + math.sin(var_41_0 * 3) * 0.5

				arg_41_1.text_color[2] = math.lerp(arg_41_1.base_text_color[2], 225, var_41_1)
				arg_41_1.text_color[3] = math.lerp(arg_41_1.base_text_color[3], 225, var_41_1)
				arg_41_1.text_color[4] = math.lerp(arg_41_1.base_text_color[4], 225, var_41_1)
			end
		},
		{
			style_id = "additional_content_added_shadow",
			pass_type = "text",
			text_id = "additional_content_added",
			content_check_function = function (arg_42_0)
				return IS_CONSOLE and var_7_9.additional_content_added and not arg_42_0.owned
			end
		},
		{
			style_id = "additional_disclaimer",
			pass_type = "text",
			text_id = "additional_disclaimer",
			content_check_function = function (arg_43_0, arg_43_1)
				return arg_43_0.has_disclamer
			end
		},
		{
			pass_type = "texture",
			style_id = "disclaimer_marker",
			texture_id = "disclaimer_marker",
			content_check_function = function (arg_44_0, arg_44_1)
				return arg_44_0.has_disclamer
			end
		}
	}
	local var_7_13 = {
		expire_time_icon = "icon_store_timer",
		old_price = false,
		price_strike_through = "shop_bundle_line",
		background_price_center = "store_thumbnail_pricetag_middle",
		optional_subtitle = "",
		psplus_icon = "psplus_logo",
		price_text_now = "-",
		bundle_content_amount_text = "",
		owned_icon = "store_owned_sigil",
		optional_item_name = "",
		price_icon = "store_icon_currency_ingame",
		price_text = "-",
		console_third_price_text = "",
		show_ps4_plus = false,
		price_text_before = "-",
		show_third_stroke = false,
		discount = false,
		loading_icon = "loot_loading",
		new_marker = "list_item_tag_new",
		show_secondary_stroke = false,
		additional_disclaimer = "",
		background_price = "store_thumbnail_pricetag_left",
		has_disclamer = false,
		price_gradient = "gradient",
		real_currency = false,
		owned = false,
		console_secondary_price_text = "",
		disclaimer_marker = "tooltip_marker_gold",
		owned_icon_bg = "store_owned_ribbon",
		background_price_right = "store_thumbnail_pricetag_right",
		discount_bg = "store_thumbnail_sale",
		console_first_price_text = "",
		hide_new = var_7_8.hide_new,
		item_key = arg_7_3.product_id,
		hotspot = {},
		hide_price = var_7_8.hide_price,
		masked_price_strike_through = not var_7_8.mask_price_strike_through_hack,
		draw_price_icon = not var_7_8.hide_price,
		discont_number_icons = {},
		rect = arg_7_2 and "rect_masked" or "simple_rect_texture",
		frame = var_7_1.texture,
		hover_frame = var_7_3.texture,
		pulse_frame = var_7_6.texture,
		size = arg_7_1,
		console_background_rect = arg_7_2 and "rect_masked" or "simple_rect_texture",
		console_secondary_price_stroke = arg_7_2 and "rect_masked" or "simple_rect_texture",
		console_third_price_stroke = arg_7_2 and "rect_masked" or "simple_rect_texture",
		additional_content_added = Localize("title_screen_store_new_additional_content")
	}
	local var_7_14 = {
		hotspot = {
			size = arg_7_1,
			offset = {
				0,
				-arg_7_1[2],
				0
			}
		},
		loading_icon = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = true,
			angle = 0,
			pivot = {
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
				arg_7_1[1] * 0.5 - 50,
				-50,
				6
			},
			texture_size = {
				100,
				100
			}
		},
		price_text = {
			upper_case = false,
			localize = false,
			font_size = 28,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = false,
			size = {
				45,
				40
			},
			font_type = arg_7_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				50,
				-(arg_7_1[2] + 4),
				12
			}
		},
		optional_item_name = {
			upper_case = false,
			localize = false,
			font_size = 40,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			size = {
				320,
				60
			},
			font_type = arg_7_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				40,
				-100,
				12
			}
		},
		optional_subtitle = {
			upper_case = false,
			localize = false,
			font_size = 28,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = true,
			size = {
				320,
				60
			},
			font_type = arg_7_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				40,
				-150,
				12
			}
		},
		price_text_now = {
			upper_case = false,
			localize = false,
			font_size = 28,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = false,
			size = {
				45,
				40
			},
			font_type = arg_7_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				50,
				-(arg_7_1[2] + 0),
				12
			}
		},
		price_text_before = {
			upper_case = false,
			localize = false,
			font_size = 24,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = false,
			size = {
				45,
				40
			},
			font_type = arg_7_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("slate_gray", 255),
			offset = {
				50,
				-(arg_7_1[2] - 1),
				12
			}
		},
		price_strike_through = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			angle = -0.17,
			masked = var_7_13.masked_price_strike_through,
			pivot = {
				0,
				0
			},
			color = {
				255,
				255,
				0,
				0
			},
			offset = {
				50,
				-(arg_7_1[2] - 12),
				13
			},
			texture_size = {
				110,
				3
			}
		},
		background_rect = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = arg_7_1,
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
		background = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = arg_7_1,
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
		expire_time_icon = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
				49.5,
				58.5
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				3,
				9,
				10
			}
		},
		overlay = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = arg_7_1,
			color = {
				0,
				5,
				5,
				5
			},
			offset = {
				0,
				0,
				8
			}
		},
		bundle_content_amount_text = {
			upper_case = false,
			localize = false,
			font_size = 28,
			horizontal_alignment = "left",
			text_horizontal_alignment = "right",
			vertical_alignment = "top",
			dynamic_font_size = false,
			size = {
				30,
				30
			},
			font_type = arg_7_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = {
				255,
				255,
				116,
				246
			},
			offset = {
				arg_7_1[1] - 80,
				-44,
				12
			}
		},
		type_tag_icon = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
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
				arg_7_1[1] - 56,
				0,
				9
			}
		},
		background_price = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
				64,
				92
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-6,
				-(arg_7_1[2] - 90),
				11
			}
		},
		background_price_center = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
				0,
				36
			},
			texture_tiling_size = {
				12,
				36
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				58,
				-(arg_7_1[2] - 34),
				11
			}
		},
		background_price_right = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
				32,
				40
			},
			default_size = {
				32,
				40
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				58,
				-(arg_7_1[2] - 38),
				11
			},
			default_offset = {
				58,
				-(arg_7_1[2] - 38),
				11
			}
		},
		price_gradient = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
				313,
				34
			},
			color = {
				255,
				255,
				0,
				0
			},
			offset = {
				6,
				-(arg_7_1[2] - 40),
				10
			}
		},
		price_icon = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
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
				3,
				-(arg_7_1[2] - 47),
				11
			}
		},
		owned_icon = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
				53,
				53
			},
			default_texture_size = {
				53,
				53
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				5,
				-(arg_7_1[2] - 5),
				12
			},
			default_offset = {
				5,
				-(arg_7_1[2] - 5),
				12
			}
		},
		owned_icon_bg = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
				34,
				50
			},
			default_texture_size = {
				34,
				50
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				15,
				-(arg_7_1[2] + 8),
				11
			},
			default_offset = {
				15,
				-(arg_7_1[2] + 8),
				11
			}
		},
		discount_bg = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
				124,
				112
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-3,
				4,
				11
			}
		},
		discont_number_icons = {
			axis = 1,
			direction = 1,
			masked = arg_7_2,
			texture_sizes = {},
			texture_offsets = {},
			spacing = {
				0,
				0,
				0
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				25,
				-82,
				12
			},
			default_offset = {
				25,
				-82,
				12
			}
		},
		icon = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = var_7_10 or arg_7_1,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_7_10 and (arg_7_1[1] - var_7_10[1]) * 0.5 or 0,
				var_7_10 and -(arg_7_1[2] - var_7_10[2]) * 0.5 or 0,
				7
			}
		},
		frame = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			masked = arg_7_2,
			area_size = arg_7_1,
			texture_size = var_7_1.texture_size,
			texture_sizes = var_7_1.texture_sizes,
			frame_margins = {
				0,
				0
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
				10
			}
		},
		hover_frame = {
			horizontal_alignment = "left",
			vertical_alignment = "top",
			masked = arg_7_2,
			area_size = arg_7_1,
			texture_size = var_7_3.texture_size,
			texture_sizes = var_7_3.texture_sizes,
			frame_margins = {
				-var_7_4,
				-var_7_4
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
			vertical_alignment = "top",
			masked = arg_7_2,
			area_size = arg_7_1,
			texture_size = var_7_6.texture_size,
			texture_sizes = var_7_6.texture_sizes,
			frame_margins = {
				-var_7_7,
				-var_7_7
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
		console_background_rect_bottom = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
				arg_7_1[1],
				-42.5
			},
			color = {
				192,
				0,
				0,
				0
			},
			offset = {
				0,
				-arg_7_1[2],
				9
			}
		},
		console_background_rect_top = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
				arg_7_1[1],
				-32.5
			},
			color = {
				192,
				0,
				0,
				0
			},
			offset = {
				0,
				-arg_7_1[2] + 42.5,
				9
			}
		},
		console_first_price_text = {
			upper_case = false,
			localize = false,
			font_size = 28,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = false,
			size = {
				45,
				40
			},
			font_type = arg_7_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			base_color = Colors.get_color_table_with_alpha("white", 255),
			ps_plus_color = {
				255,
				255,
				205,
				0
			},
			offset = {
				arg_7_1[1],
				-(arg_7_1[2] - 4),
				12
			}
		},
		console_secondary_price_text = {
			upper_case = false,
			localize = false,
			font_size = 28,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = false,
			size = {
				45,
				40
			},
			font_type = arg_7_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				arg_7_1[1],
				-(arg_7_1[2] - 4 - 30),
				12
			}
		},
		console_third_price_text = {
			upper_case = false,
			localize = false,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			dynamic_font_size = false,
			size = {
				45,
				40
			},
			font_type = arg_7_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				arg_7_1[1],
				-(arg_7_1[2] - 4 - 30),
				12
			}
		},
		console_secondary_price_stroke = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
				0,
				2
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				arg_7_1[1],
				-(arg_7_1[2] - 4 - 50),
				13
			}
		},
		console_third_price_stroke = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
				0,
				2
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				arg_7_1[1],
				-(arg_7_1[2] - 4 - 50),
				13
			}
		},
		psplus_icon = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_7_2,
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
				arg_7_1[1],
				-arg_7_1[2] + 25,
				10
			}
		},
		new_marker = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_7_2,
			texture_size = {
				math.floor(88.19999999999999),
				math.floor(35.699999999999996)
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				-35,
				-arg_7_1[2] - 5,
				10
			},
			size = arg_7_1
		},
		additional_content_added = {
			font_size = 24,
			upper_case = true,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			dynamic_font_size = false,
			font_type = arg_7_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = {
				255,
				159,
				144,
				101
			},
			base_text_color = {
				255,
				159,
				144,
				101
			},
			offset = {
				20,
				-180,
				12
			}
		},
		additional_content_added_shadow = {
			font_size = 24,
			upper_case = true,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			dynamic_font_size = false,
			font_type = arg_7_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = {
				255,
				0,
				0,
				0
			},
			offset = {
				22,
				-182,
				11
			}
		},
		disclaimer_marker = {
			masked = true,
			texture_size = {
				20,
				20
			},
			offset = {
				40,
				76,
				15
			},
			color = Colors.get_color_table_with_alpha("white", 255)
		},
		additional_disclaimer = {
			upper_case = false,
			localize = false,
			use_shadow = true,
			font_size = 24,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			size = {
				arg_7_1[1] - 80,
				30
			},
			area_size = {
				arg_7_1[1] - 80,
				30
			},
			font_type = arg_7_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 180),
			offset = {
				62,
				70,
				15
			}
		}
	}

	var_7_11.element.passes = var_7_12
	var_7_11.content = var_7_13
	var_7_11.style = var_7_14
	var_7_11.offset = {
		0,
		0,
		5
	}
	var_7_11.scenegraph_id = arg_7_0

	return var_7_11
end

UIWidgets.create_store_pose_item_definition = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0 = arg_45_3.settings

	return UIWidgets.create_store_item_definition(arg_45_0, arg_45_1, arg_45_2, arg_45_3, var_45_0)
end

UIWidgets.create_store_header_text_definition = function (arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = -arg_46_1[2]
	local var_46_1 = 25
	local var_46_2 = {
		element = {}
	}
	local var_46_3 = {
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text"
		},
		{
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text"
		}
	}
	local var_46_4 = {
		text = "n/a",
		size = arg_46_1
	}
	local var_46_5 = {
		text = {
			font_size = 32,
			upper_case = false,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = false,
			size = {
				arg_46_1[1] - var_46_1 * 2,
				arg_46_1[2]
			},
			font_type = arg_46_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				var_46_1,
				var_46_0,
				9
			}
		},
		text_shadow = {
			font_size = 32,
			upper_case = false,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = false,
			size = {
				arg_46_1[1] - var_46_1 * 2,
				arg_46_1[2]
			},
			font_type = arg_46_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_46_1 + 2,
				var_46_0 - 2,
				8
			}
		}
	}

	var_46_2.element.passes = var_46_3
	var_46_2.content = var_46_4
	var_46_2.style = var_46_5
	var_46_2.offset = {
		0,
		0,
		0
	}
	var_46_2.scenegraph_id = arg_46_0

	return var_46_2
end

UIWidgets.create_store_body_text_definition = function (arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = -arg_47_1[2]
	local var_47_1 = 25
	local var_47_2 = {
		element = {}
	}
	local var_47_3 = {
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text"
		},
		{
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text"
		}
	}
	local var_47_4 = {
		text = "n/a",
		size = arg_47_1
	}
	local var_47_5 = {
		text = {
			font_size = 20,
			upper_case = false,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = false,
			size = {
				arg_47_1[1] - var_47_1 * 2,
				arg_47_1[2]
			},
			font_type = arg_47_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				var_47_1,
				var_47_0,
				9
			}
		},
		text_shadow = {
			font_size = 20,
			upper_case = false,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = false,
			size = {
				arg_47_1[1] - var_47_1 * 2,
				arg_47_1[2]
			},
			font_type = arg_47_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_47_1 + 2,
				var_47_0 - 2,
				8
			}
		}
	}

	var_47_2.element.passes = var_47_3
	var_47_2.content = var_47_4
	var_47_2.style = var_47_5
	var_47_2.offset = {
		0,
		0,
		0
	}
	var_47_2.scenegraph_id = arg_47_0

	return var_47_2
end

UIWidgets.create_store_currency_summary_title_definition = function (arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = -arg_48_1[2]
	local var_48_1 = 25
	local var_48_2 = {
		255,
		120,
		120,
		120
	}
	local var_48_3 = {
		element = {}
	}
	local var_48_4 = {
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text"
		},
		{
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text"
		},
		{
			style_id = "text2",
			pass_type = "text",
			text_id = "text2"
		},
		{
			style_id = "text2_shadow",
			pass_type = "text",
			text_id = "text2"
		},
		{
			pass_type = "texture",
			style_id = "divider",
			texture_id = "rect"
		},
		{
			pass_type = "texture",
			style_id = "divider_shadow",
			texture_id = "rect"
		}
	}
	local var_48_5 = {
		text = "n/a",
		text2 = "n/a",
		size = arg_48_1,
		rect = arg_48_2 and "rect_masked" or "simple_rect_texture"
	}
	local var_48_6 = {
		text = {
			font_size = 16,
			upper_case = true,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = false,
			size = {
				arg_48_1[1] - var_48_1 * 2,
				arg_48_1[2]
			},
			font_type = arg_48_2 and "hell_shark_masked" or "hell_shark",
			text_color = var_48_2,
			offset = {
				var_48_1,
				var_48_0,
				9
			}
		},
		text_shadow = {
			font_size = 16,
			upper_case = true,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = false,
			size = {
				arg_48_1[1] - var_48_1 * 2,
				arg_48_1[2]
			},
			font_type = arg_48_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_48_1 + 2,
				var_48_0 - 2,
				8
			}
		},
		text2 = {
			font_size = 16,
			upper_case = true,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "right",
			vertical_alignment = "top",
			dynamic_font_size = false,
			size = {
				arg_48_1[1] - var_48_1 * 2,
				arg_48_1[2]
			},
			font_type = arg_48_2 and "hell_shark_masked" or "hell_shark",
			text_color = var_48_2,
			offset = {
				var_48_1,
				var_48_0,
				9
			}
		},
		text2_shadow = {
			font_size = 16,
			upper_case = true,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "right",
			vertical_alignment = "top",
			dynamic_font_size = false,
			size = {
				arg_48_1[1] - var_48_1 * 2,
				arg_48_1[2]
			},
			font_type = arg_48_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_48_1 + 2,
				var_48_0 - 2,
				8
			}
		},
		divider = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			masked = arg_48_2,
			texture_size = {
				arg_48_1[1] - var_48_1 * 2,
				2
			},
			color = var_48_2,
			offset = {
				var_48_1,
				0,
				8
			}
		},
		divider_shadow = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			masked = arg_48_2,
			texture_size = {
				arg_48_1[1] - var_48_1 * 2,
				2
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				var_48_1 + 2,
				0,
				7
			}
		}
	}

	var_48_3.element.passes = var_48_4
	var_48_3.content = var_48_5
	var_48_3.style = var_48_6
	var_48_3.offset = {
		0,
		0,
		0
	}
	var_48_3.scenegraph_id = arg_48_0

	return var_48_3
end

UIWidgets.create_store_currency_summary_entry_definition = function (arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = -arg_49_1[2]
	local var_49_1 = 25
	local var_49_2 = {
		255,
		120,
		120,
		120
	}
	local var_49_3 = {
		element = {}
	}
	local var_49_4 = {
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text"
		},
		{
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text"
		},
		{
			style_id = "text2",
			pass_type = "text",
			text_id = "text2"
		},
		{
			style_id = "text2_shadow",
			pass_type = "text",
			text_id = "text2"
		}
	}
	local var_49_5 = {
		text = "n/a",
		text2 = "n/a",
		size = arg_49_1
	}
	local var_49_6 = {
		text = {
			font_size = 20,
			upper_case = false,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = false,
			size = {
				arg_49_1[1] - var_49_1 * 2,
				arg_49_1[2]
			},
			font_type = arg_49_2 and "hell_shark_masked" or "hell_shark",
			text_color = var_49_2,
			offset = {
				var_49_1,
				var_49_0,
				9
			}
		},
		text_shadow = {
			font_size = 20,
			upper_case = false,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			dynamic_font_size = false,
			size = {
				arg_49_1[1] - var_49_1 * 2,
				arg_49_1[2]
			},
			font_type = arg_49_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_49_1 + 2,
				var_49_0 - 2,
				8
			}
		},
		text2 = {
			font_size = 20,
			upper_case = false,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "right",
			vertical_alignment = "top",
			dynamic_font_size = false,
			size = {
				arg_49_1[1] - var_49_1 * 2,
				arg_49_1[2]
			},
			font_type = arg_49_2 and "hell_shark_masked" or "hell_shark",
			text_color = var_49_2,
			offset = {
				var_49_1,
				var_49_0,
				9
			}
		},
		text2_shadow = {
			font_size = 20,
			upper_case = false,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "right",
			vertical_alignment = "top",
			dynamic_font_size = false,
			size = {
				arg_49_1[1] - var_49_1 * 2,
				arg_49_1[2]
			},
			font_type = arg_49_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_49_1 + 2,
				var_49_0 - 2,
				8
			}
		}
	}

	var_49_3.element.passes = var_49_4
	var_49_3.content = var_49_5
	var_49_3.style = var_49_6
	var_49_3.offset = {
		0,
		0,
		0
	}
	var_49_3.scenegraph_id = arg_49_0

	return var_49_3
end

UIWidgets.create_store_dlc_feature_vertical_definition = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	local var_50_0 = "menu_frame_16"
	local var_50_1 = UIFrameSettings[var_50_0]
	local var_50_2 = {
		arg_50_1[1],
		220
	}
	local var_50_3 = -arg_50_1[2]
	local var_50_4 = 5
	local var_50_5 = (arg_50_3.settings or var_0_0).add_frame
	local var_50_6 = {
		element = {}
	}
	local var_50_7 = {
		{
			pass_type = "texture",
			style_id = "image",
			texture_id = "image"
		},
		{
			style_id = "text",
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
			style_id = "background",
			texture_id = "background",
			content_check_function = function (arg_51_0)
				return arg_51_0.add_frame
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame",
			content_check_function = function (arg_52_0)
				return arg_52_0.add_frame
			end
		}
	}
	local var_50_8 = {
		text = "n/a",
		background = "store_thumbnail_bg_promo",
		image = arg_50_2 and "rect_masked" or "simple_rect_texture",
		size = arg_50_1,
		frame = var_50_1.texture,
		add_frame = var_50_5
	}
	local var_50_9 = {
		text = {
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = true,
			word_wrap = true,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			size = {
				var_50_2[1] - var_50_4,
				arg_50_1[2] - var_50_2[2]
			},
			area_size = {
				var_50_2[1] - var_50_4,
				arg_50_1[2] - var_50_2[2]
			},
			font_type = arg_50_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				var_50_4,
				var_50_3 - 0,
				9
			}
		},
		text_shadow = {
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = true,
			word_wrap = true,
			font_size = 20,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			size = {
				var_50_2[1] - var_50_4,
				arg_50_1[2] - var_50_2[2]
			},
			area_size = {
				var_50_2[1] - var_50_4,
				arg_50_1[2] - var_50_2[2]
			},
			font_type = arg_50_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_50_4 + 2,
				var_50_3 - 0 - 2,
				8
			}
		},
		image = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_50_2,
			texture_size = var_50_2,
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
			}
		},
		background = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_50_2,
			texture_size = var_50_2,
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
			horizontal_alignment = "left",
			vertical_alignment = "top",
			masked = arg_50_2,
			area_size = var_50_2,
			texture_size = var_50_1.texture_size,
			texture_sizes = var_50_1.texture_sizes,
			frame_margins = {
				0,
				0
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
				9
			}
		}
	}

	var_50_6.element.passes = var_50_7
	var_50_6.content = var_50_8
	var_50_6.style = var_50_9
	var_50_6.offset = {
		0,
		0,
		0
	}
	var_50_6.scenegraph_id = arg_50_0

	return var_50_6
end

UIWidgets.create_store_dlc_feature_horizontal_definition = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	local var_53_0
	local var_53_1
	local var_53_2 = arg_53_3.settings

	if var_53_2 then
		var_53_0 = var_53_2.image_size
		var_53_1 = var_53_2.frame_name
	end

	var_53_0 = var_53_0 or {
		260,
		arg_53_1[2]
	}

	local var_53_3 = var_53_1 or "menu_frame_16"
	local var_53_4 = var_53_3 and UIFrameSettings[var_53_3]
	local var_53_5 = -arg_53_1[2]
	local var_53_6 = 20
	local var_53_7 = {
		element = {}
	}
	local var_53_8 = {
		{
			pass_type = "texture",
			style_id = "image",
			texture_id = "image"
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text"
		},
		{
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text"
		},
		{
			texture_id = "frame",
			style_id = "frame",
			pass_type = "texture_frame",
			content_check_function = function (arg_54_0)
				return arg_54_0.show_frame
			end
		}
	}
	local var_53_9 = {
		text = "n/a",
		image = arg_53_2 and "rect_masked" or "simple_rect_texture",
		size = arg_53_1,
		show_frame = var_53_2.show_frame,
		frame = var_53_4.texture
	}
	local var_53_10 = {
		text = {
			font_size = 20,
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			size = {
				arg_53_1[1] - var_53_0[1] - var_53_6,
				arg_53_1[2]
			},
			font_type = arg_53_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				var_53_0[1] + var_53_6,
				var_53_5 - 0,
				9
			}
		},
		text_shadow = {
			font_size = 20,
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			size = {
				arg_53_1[1] - var_53_0[1] - var_53_6,
				arg_53_1[2]
			},
			font_type = arg_53_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_53_0[1] + var_53_6 + 2,
				var_53_5 - 0 - 2,
				8
			}
		},
		image = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_53_2,
			texture_size = var_53_0,
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
			}
		},
		frame = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_53_2,
			texture_size = var_53_4.texture_size,
			texture_sizes = var_53_4.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			size = var_53_0,
			offset = {
				0,
				-var_53_0[2],
				9
			}
		}
	}

	var_53_7.element.passes = var_53_8
	var_53_7.content = var_53_9
	var_53_7.style = var_53_10
	var_53_7.offset = {
		0,
		0,
		0
	}
	var_53_7.scenegraph_id = arg_53_0

	return var_53_7
end

UIWidgets.create_store_dlc_feature_pullet_point_definition = function (arg_55_0, arg_55_1, arg_55_2)
	local var_55_0 = {
		26,
		28
	}
	local var_55_1 = -arg_55_1[2]
	local var_55_2 = 50
	local var_55_3 = {
		element = {}
	}
	local var_55_4 = {
		{
			pass_type = "texture",
			style_id = "image",
			texture_id = "image"
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text"
		},
		{
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text"
		}
	}
	local var_55_5 = {
		text = "n/a",
		image = "chain_link_horizontal_01_end",
		size = arg_55_1
	}
	local var_55_6 = {
		text = {
			font_size = 20,
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			size = {
				arg_55_1[1] - var_55_0[1] - var_55_2,
				arg_55_1[2]
			},
			font_type = arg_55_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				var_55_0[1] + var_55_2,
				var_55_1 - 0,
				9
			}
		},
		text_shadow = {
			font_size = 20,
			upper_case = false,
			localize = false,
			dynamic_font_size_word_wrap = false,
			word_wrap = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			size = {
				arg_55_1[1] - var_55_0[1] - var_55_2,
				arg_55_1[2]
			},
			font_type = arg_55_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_55_0[1] + var_55_2 + 2,
				var_55_1 - 0 - 2,
				8
			}
		},
		image = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_55_2,
			texture_size = var_55_0,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_55_2 / 2,
				0,
				8
			}
		}
	}

	var_55_3.element.passes = var_55_4
	var_55_3.content = var_55_5
	var_55_3.style = var_55_6
	var_55_3.offset = {
		0,
		0,
		0
	}
	var_55_3.scenegraph_id = arg_55_0

	return var_55_3
end

UIWidgets.create_store_list_spacing_definition = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	local var_56_0 = {
		element = {}
	}
	local var_56_1 = {}
	local var_56_2 = {
		size = arg_56_1
	}
	local var_56_3 = {}

	var_56_0.element.passes = var_56_1
	var_56_0.content = var_56_2
	var_56_0.style = var_56_3
	var_56_0.offset = {
		0,
		0,
		0
	}
	var_56_0.scenegraph_id = arg_56_0

	return var_56_0
end

UIWidgets.create_store_dlc_logo_definition = function (arg_57_0, arg_57_1, arg_57_2)
	local var_57_0 = {
		440,
		64
	}
	local var_57_1 = -arg_57_1[2]
	local var_57_2 = {
		element = {}
	}
	local var_57_3 = {
		{
			pass_type = "texture",
			style_id = "image",
			texture_id = "image"
		}
	}
	local var_57_4 = {
		image = arg_57_2 and "rect_masked" or "simple_rect_texture",
		size = arg_57_1
	}
	local var_57_5 = {
		image = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_57_2,
			texture_size = var_57_0,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_57_1[1] / 2 - var_57_0[1] / 2,
				var_57_0[2],
				8
			}
		}
	}

	var_57_2.element.passes = var_57_3
	var_57_2.content = var_57_4
	var_57_2.style = var_57_5
	var_57_2.offset = {
		0,
		0,
		0
	}
	var_57_2.scenegraph_id = arg_57_0

	return var_57_2
end

UIWidgets.create_store_list_divider_definition = function (arg_58_0, arg_58_1, arg_58_2)
	local var_58_0 = {
		618,
		32
	}
	local var_58_1 = -arg_58_1[2]
	local var_58_2 = {
		element = {}
	}
	local var_58_3 = {
		{
			pass_type = "texture",
			style_id = "image",
			texture_id = "image"
		}
	}
	local var_58_4 = {
		image = "store_divider",
		size = arg_58_1
	}
	local var_58_5 = {
		image = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_58_2,
			texture_size = var_58_0,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_58_1[1] / 2 - var_58_0[1] / 2,
				-(arg_58_1[2] / 2 - var_58_0[2] / 2),
				8
			}
		}
	}

	var_58_2.element.passes = var_58_3
	var_58_2.content = var_58_4
	var_58_2.style = var_58_5
	var_58_2.offset = {
		0,
		0,
		0
	}
	var_58_2.scenegraph_id = arg_58_0

	return var_58_2
end

UIWidgets.create_store_header_video_definition = function (arg_59_0, arg_59_1, arg_59_2)
	local var_59_0 = 0.6
	local var_59_1 = 0.2
	local var_59_2 = -(arg_59_1[2] * 0.6)
	local var_59_3 = -arg_59_1[2]
	local var_59_4 = {
		element = {}
	}
	local var_59_5 = {
		{
			style_id = "button_hotspot",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			style_id = "video_style",
			pass_type = "video",
			content_id = "video_content"
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "rect"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon"
		},
		{
			pass_type = "texture",
			style_id = "bottom_rect",
			texture_id = "rect"
		},
		{
			style_id = "bottom_fade",
			pass_type = "texture_uv",
			content_id = "bottom_fade"
		},
		{
			pass_type = "texture",
			style_id = "top_fade",
			texture_id = "top_fade"
		}
	}
	local var_59_6 = {
		top_fade = "edge_fade_small",
		icon = "expand_video_icon",
		button_hotspot = {},
		bottom_fade = {
			texture_id = "edge_fade_small",
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
		video_content = {
			video_completed = false
		},
		rect = arg_59_2 and "rect_masked" or "simple_rect_texture",
		size = arg_59_1
	}
	local var_59_7 = {
		button_hotspot = {
			size = arg_59_1,
			offset = {
				0,
				var_59_3,
				0
			}
		},
		video_style = {
			size = arg_59_1,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				var_59_3,
				1
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_59_2,
			texture_size = {
				85,
				84
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_59_1[1] / 2,
				var_59_3 + arg_59_1[2] / 2 + arg_59_1[2] * var_59_0 / 2 + var_59_2 * 0.5,
				5
			}
		},
		background = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_59_2,
			texture_size = arg_59_1,
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
		bottom_rect = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_59_2,
			texture_size = {
				arg_59_1[1],
				arg_59_1[2] * var_59_0
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				0,
				var_59_3 + arg_59_1[2] * var_59_0 - 1 + var_59_2,
				3
			}
		},
		bottom_fade = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_59_2,
			texture_size = {
				arg_59_1[1],
				arg_59_1[2] * var_59_1
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				0,
				var_59_3 + var_59_2,
				3
			}
		},
		top_fade = {
			vertical_alignment = "top",
			masked = false,
			horizontal_alignment = "left",
			texture_size = {
				arg_59_1[1],
				arg_59_1[2] * var_59_1
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				0,
				var_59_3 + (arg_59_1[2] * var_59_0 + arg_59_1[2] * var_59_1 - 2) + var_59_2,
				3
			}
		}
	}

	var_59_4.element.passes = var_59_5
	var_59_4.content = var_59_6
	var_59_4.style = var_59_7
	var_59_4.offset = {
		0,
		0,
		0
	}
	var_59_4.scenegraph_id = arg_59_0

	return var_59_4
end

UIWidgets.create_store_purchase_button = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4)
	local var_60_0 = "menu_frame_bg_07"
	local var_60_1

	if UIAtlasHelper.has_atlas_settings_by_texture_name(var_60_0) then
		local var_60_2 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_60_0)

		var_60_1 = {
			var_60_2.size[1],
			var_60_2.size[2]
		}
	else
		var_60_1 = {
			512,
			256
		}
	end

	local var_60_3 = "button_frame_01_gold"
	local var_60_4 = var_60_3 and UIFrameSettings[var_60_3] or UIFrameSettings.button_frame_01
	local var_60_5 = var_60_4.texture_sizes.corner[1]
	local var_60_6 = "button_detail_09_gold"
	local var_60_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_60_6).size

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
					style_id = "disabled_overlay",
					pass_type = "rect",
					content_check_function = function (arg_61_0)
						return arg_61_0.button_hotspot.disable_button and not arg_61_0.owned
					end
				},
				{
					style_id = "owned_overlay",
					pass_type = "texture_uv",
					content_id = "owned_overlay",
					content_check_function = function (arg_62_0)
						return arg_62_0.parent.owned
					end
				},
				{
					style_id = "owned_text_write_mask",
					pass_type = "text",
					text_id = "owned_text",
					content_check_function = function (arg_63_0)
						return arg_63_0.owned
					end
				},
				{
					texture_id = "owned_text_gradient",
					style_id = "owned_text_gradient",
					pass_type = "texture",
					content_check_function = function (arg_64_0)
						return arg_64_0.owned
					end
				},
				{
					pass_type = "texture",
					style_id = "owned_icon",
					texture_id = "owned_icon",
					content_check_function = function (arg_65_0)
						return arg_65_0.owned
					end
				},
				{
					pass_type = "texture",
					style_id = "owned_icon_bg",
					texture_id = "owned_icon_bg",
					content_check_function = function (arg_66_0)
						return arg_66_0.owned
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
					style_id = "currency_text",
					pass_type = "text",
					text_id = "currency_text",
					content_check_function = function (arg_67_0)
						return not arg_67_0.button_hotspot.disable_button and not arg_67_0.owned and arg_67_0.present_currency
					end
				},
				{
					style_id = "currency_text_disabled",
					pass_type = "text",
					text_id = "currency_text",
					content_check_function = function (arg_68_0)
						local var_68_0 = arg_68_0.button_hotspot

						return not arg_68_0.owned and arg_68_0.present_currency and var_68_0.disable_button
					end
				},
				{
					style_id = "currency_text_shadow",
					pass_type = "text",
					text_id = "currency_text",
					content_check_function = function (arg_69_0)
						return not arg_69_0.owned and arg_69_0.present_currency
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_70_0)
						return not arg_70_0.button_hotspot.disable_button and arg_70_0.title_text and (IS_WINDOWS or not arg_70_0.real_currency)
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_71_0)
						return arg_71_0.button_hotspot.disable_button and not arg_71_0.owned and arg_71_0.title_text and (IS_WINDOWS or not arg_71_0.real_currency)
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_72_0)
						return not arg_72_0.owned and arg_72_0.title_text and (IS_WINDOWS or not arg_72_0.real_currency)
					end
				},
				{
					style_id = "title_text_write_mask",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_73_0)
						return not arg_73_0.button_hotspot.disable_button and arg_73_0.title_text and (IS_WINDOWS or not arg_73_0.real_currency)
					end
				},
				{
					texture_id = "title_text_gradient",
					style_id = "title_text_gradient",
					pass_type = "texture",
					content_check_function = function (arg_74_0)
						return not arg_74_0.button_hotspot.disable_button and (IS_WINDOWS or not arg_74_0.real_currency)
					end
				},
				{
					texture_id = "glass",
					style_id = "glass",
					pass_type = "texture",
					content_check_function = function (arg_75_0)
						return not arg_75_0.owned
					end
				},
				{
					texture_id = "glass_top",
					style_id = "glass_top",
					pass_type = "texture",
					content_check_function = function (arg_76_0)
						return not arg_76_0.owned
					end
				},
				{
					texture_id = "currency_icon",
					style_id = "currency_icon",
					pass_type = "texture",
					content_check_function = function (arg_77_0)
						local var_77_0 = arg_77_0.button_hotspot

						return not arg_77_0.owned and not var_77_0.disable_button and arg_77_0.present_currency
					end
				},
				{
					texture_id = "currency_icon",
					style_id = "currency_icon_disabled",
					pass_type = "texture",
					content_check_function = function (arg_78_0)
						local var_78_0 = arg_78_0.button_hotspot

						return not arg_78_0.owned and arg_78_0.present_currency and var_78_0.disable_button
					end
				},
				{
					pass_type = "texture",
					style_id = "psplus_icon",
					texture_id = "psplus_icon",
					content_check_function = function (arg_79_0)
						return arg_79_0.show_ps4_plus and IS_PS4 and arg_79_0.real_currency
					end
				},
				{
					pass_type = "texture",
					style_id = "console_background_rect",
					texture_id = "console_background_rect",
					content_check_function = function (arg_80_0)
						return not IS_WINDOWS and arg_80_0.real_currency
					end
				},
				{
					texture_id = "console_secondary_price_stroke",
					style_id = "console_secondary_price_stroke",
					pass_type = "texture",
					content_check_function = function (arg_81_0)
						return arg_81_0.show_secondary_stroke and not IS_WINDOWS and arg_81_0.real_currency
					end
				},
				{
					texture_id = "console_third_price_stroke",
					style_id = "console_third_price_stroke",
					pass_type = "texture",
					content_check_function = function (arg_82_0)
						return arg_82_0.show_third_stroke and IS_PS4 and arg_82_0.real_currency
					end
				},
				{
					style_id = "console_first_price_text",
					pass_type = "text",
					text_id = "console_first_price_text",
					content_check_function = function (arg_83_0)
						return not IS_WINDOWS and arg_83_0.real_currency
					end,
					content_change_function = function (arg_84_0, arg_84_1)
						arg_84_1.text_color = arg_84_0.show_ps4_plus and arg_84_1.ps_plus_color or arg_84_1.base_color
					end
				},
				{
					style_id = "console_secondary_price_text",
					pass_type = "text",
					text_id = "console_secondary_price_text",
					content_check_function = function (arg_85_0)
						return arg_85_0.console_secondary_price_text ~= "" and not IS_WINDOWS and arg_85_0.real_currency
					end
				},
				{
					style_id = "console_third_price_text",
					pass_type = "text",
					text_id = "console_third_price_text",
					content_check_function = function (arg_86_0)
						return arg_86_0.console_third_price_text ~= "" and IS_PS4 and arg_86_0.real_currency
					end
				},
				{
					texture_id = "lock",
					style_id = "lock",
					pass_type = "texture",
					content_check_function = function (arg_87_0)
						return not arg_87_0.owns_required_dlc
					end
				}
			}
		},
		content = {
			owned_icon = "store_owned_sigil",
			console_third_price_stroke = "simple_rect_texture",
			glass_top = "button_glass_02",
			glass = "game_options_fg",
			owned_text_gradient = "store_button_bg_02",
			show_third_stroke = false,
			owned_text = "menu_store_purchase_button_owned",
			console_third_price_text = "",
			present_currency = false,
			show_ps4_plus = false,
			show_secondary_stroke = false,
			background_fade = "button_bg_fade",
			currency_icon = "store_icon_currency_ingame_big",
			console_secondary_price_stroke = "simple_rect_texture",
			hover_glow = "button_state_default",
			real_currency = false,
			owns_required_dlc = true,
			owned = false,
			console_background_rect = "simple_rect_texture",
			console_secondary_price_text = "",
			lock = "hero_icon_locked_gold",
			owned_icon_bg = "store_owned_ribbon",
			title_text_gradient = "text_gradient",
			console_first_price_text = "",
			psplus_icon = "psplus_logo",
			currency_text = "",
			button_hotspot = {
				disable_button = false
			},
			owned_overlay = {
				texture_id = "store_button_bg_01",
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
				texture_id = var_60_6
			},
			title_text = arg_60_2,
			frame = var_60_4.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_60_1[2] / var_60_1[2]
					},
					{
						arg_60_1[1] / var_60_1[1],
						1
					}
				},
				texture_id = var_60_0
			},
			disable_with_gamepad = arg_60_4,
			frame_width = var_60_5,
			size = arg_60_1
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
			background_fade = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					var_60_5,
					var_60_5 - 2,
					2
				},
				size = {
					arg_60_1[1] - var_60_5 * 2,
					arg_60_1[2] - var_60_5 * 2
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
					var_60_5 - 2,
					3
				},
				size = {
					arg_60_1[1],
					math.min(arg_60_1[2] - 5, 80)
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
			disabled_overlay = {
				color = {
					180,
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
			currency_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
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
					0,
					4
				}
			},
			currency_icon_disabled = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					64,
					64
				},
				color = {
					255,
					90,
					90,
					90
				},
				offset = {
					0,
					0,
					4
				}
			},
			currency_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_60_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					20,
					0,
					4
				}
			},
			currency_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_60_3 or 24,
				text_color = {
					255,
					100,
					0,
					0
				},
				default_text_color = {
					255,
					100,
					0,
					0
				},
				offset = {
					20,
					0,
					4
				}
			},
			currency_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_60_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					20,
					-2,
					3
				}
			},
			title_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_60_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					20,
					0,
					4
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_60_3 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					20,
					0,
					4
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_60_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					22,
					-2,
					3
				}
			},
			title_text_write_mask = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header_write_mask",
				font_size = arg_60_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					20,
					0,
					6
				}
			},
			owned_text_write_mask = {
				word_wrap = true,
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header_write_mask",
				font_size = arg_60_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					9
				}
			},
			title_text_gradient = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				masked = true,
				color = {
					255,
					97,
					180,
					141
				},
				offset = {
					0,
					0,
					5
				},
				texture_size = {
					arg_60_1[1],
					arg_60_1[2] * 0.5
				}
			},
			owned_text_gradient = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
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
					8
				},
				texture_size = {
					arg_60_1[1],
					62
				}
			},
			owned_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					53,
					53
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-4,
					11
				}
			},
			owned_icon_bg = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					34,
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
					-24,
					10
				}
			},
			frame = {
				texture_size = var_60_4.texture_size,
				texture_sizes = var_60_4.texture_sizes,
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
					arg_60_1[2] - (var_60_5 + 11),
					4
				},
				size = {
					arg_60_1[1],
					11
				}
			},
			glass = {
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
			owned_overlay = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
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
				},
				texture_size = {
					arg_60_1[1],
					62
				}
			},
			side_detail_left = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-55,
					0,
					9
				},
				texture_size = {
					var_60_7[1],
					var_60_7[2]
				}
			},
			side_detail_right = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					55,
					0,
					9
				},
				texture_size = {
					var_60_7[1],
					var_60_7[2]
				}
			},
			console_background_rect = {
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					1
				}
			},
			console_first_price_text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				dynamic_font_size = false,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				base_color = Colors.get_color_table_with_alpha("white", 255),
				ps_plus_color = {
					255,
					255,
					205,
					0
				},
				offset = {
					-45,
					-2,
					2
				}
			},
			console_secondary_price_text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				dynamic_font_size = false,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-45,
					24,
					2
				}
			},
			console_third_price_text = {
				font_size = 20,
				upper_case = false,
				localize = false,
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				dynamic_font_size = false,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					29,
					2
				}
			},
			console_secondary_price_stroke = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					0,
					2
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					44,
					3
				}
			},
			console_third_price_stroke = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					0,
					2
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					44,
					3
				}
			},
			psplus_icon = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
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
					0,
					10,
					50
				}
			},
			lock = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					83.60000000000001,
					95.7
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-20,
					50
				}
			}
		},
		scenegraph_id = arg_60_0,
		offset = {
			0,
			0,
			0
		}
	}
end

UIWidgets.create_store_panel_button = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3, arg_88_4, arg_88_5)
	local var_88_0 = {
		-55,
		2,
		10
	}
	local var_88_1 = {
		0,
		-8,
		0
	}
	local var_88_2 = {
		2,
		3,
		3
	}
	local var_88_3 = {
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
					content_check_function = function (arg_89_0)
						return not arg_89_0.button_hotspot.disable_button and (arg_89_0.button_hotspot.is_hover or arg_89_0.button_hotspot.is_selected)
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (arg_90_0)
						return not arg_90_0.button_hotspot.disable_button and not arg_90_0.button_hotspot.is_hover and not arg_90_0.button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (arg_91_0)
						return arg_91_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "new_marker",
					style_id = "new_marker",
					pass_type = "texture",
					content_check_function = function (arg_92_0)
						return arg_92_0.new and not arg_92_0.timer
					end
				},
				{
					style_id = "timer_marker",
					pass_type = "texture",
					texture_id = "timer_marker",
					content_check_function = function (arg_93_0)
						return arg_93_0.timer
					end,
					content_change_function = function (arg_94_0, arg_94_1)
						local var_94_0 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

						arg_94_1.color[1] = 100 + 155 * var_94_0
					end
				}
			}
		},
		content = {
			timer_marker = "icon_store_timer",
			timer = false,
			new_marker = "list_item_tag_new",
			button_hotspot = {},
			text_field = arg_88_2,
			default_font_size = arg_88_3,
			size = arg_88_1
		},
		style = {
			button_hotspot = {
				size = arg_88_1
			},
			text = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_88_3,
				horizontal_alignment = arg_88_5 or "left",
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
				size = arg_88_1
			},
			text_shadow = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_88_3,
				horizontal_alignment = arg_88_5 or "left",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_offset = var_88_2,
				offset = var_88_2,
				size = arg_88_1
			},
			text_hover = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_88_3,
				horizontal_alignment = arg_88_5 or "left",
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
				size = arg_88_1
			},
			text_disabled = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_88_3,
				horizontal_alignment = arg_88_5 or "left",
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
				size = arg_88_1
			},
			new_marker = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					math.floor(88.19999999999999),
					math.floor(35.699999999999996)
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_88_0[1],
					var_88_0[2],
					var_88_0[3]
				},
				size = arg_88_1
			},
			timer_marker = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					44,
					46
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					var_88_0[1] + 42,
					var_88_0[2] - 2,
					var_88_0[3]
				},
				size = arg_88_1
			}
		},
		offset = arg_88_4 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_88_0
	}
end

UIWidgets.create_store_panel_currency_widget = function (arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4)
	local var_95_0 = arg_95_1 and UIFrameSettings[arg_95_1] or UIFrameSettings.button_frame_01_gold

	return {
		element = {
			passes = {
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					pass_type = "tiled_texture",
					style_id = "background_texture",
					texture_id = "background_texture"
				},
				{
					pass_type = "texture",
					style_id = "currency_icon",
					texture_id = "currency_icon"
				},
				{
					style_id = "currency_text",
					pass_type = "text",
					text_id = "currency_text"
				}
			}
		},
		content = {
			currency_text = "-",
			frame = var_95_0.texture,
			background_texture = arg_95_3 or "menu_frame_bg_07",
			currency_icon = arg_95_2 or "store_icon_currency_ingame_big"
		},
		style = {
			frame = {
				texture_size = var_95_0.texture_size,
				texture_sizes = var_95_0.texture_sizes,
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
			background_texture = {
				offset = {
					0,
					0,
					0
				},
				texture_tiling_size = arg_95_4 or {
					512,
					256
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			currency_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					30,
					0,
					1
				},
				texture_size = {
					64,
					64
				}
			},
			currency_text = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				use_shadow = true,
				font_size = 32,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = false,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					99,
					0,
					2
				}
			}
		},
		scenegraph_id = arg_95_0,
		offset = {
			0,
			0,
			1
		}
	}
end
