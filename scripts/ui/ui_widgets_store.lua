-- chunkname: @scripts/ui/ui_widgets_store.lua

require("scripts/settings/ui_frame_settings")
require("scripts/settings/ui_player_portrait_frame_settings")

local UIWidgets = UIWidgets

UIWidgets = UIWidgets or {}
UIWidgets = UIWidgets

UIWidgets.create_store_category_entry_definition = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local str = "button_frame_02_gold"
	local var_1_1 = UIFrameSettings[str]
	local var_1_2 = var_1_1.texture_sizes.horizontal[2]
	local str_2 = "frame_outer_glow_04"
	local var_1_4 = UIFrameSettings[str_2]
	local var_1_5 = var_1_4.texture_sizes.horizontal[2]
	local str_3 = "frame_outer_glow_04_big"
	local var_1_7 = UIFrameSettings[str_3]
	local var_1_8 = var_1_7.texture_sizes.horizontal[2]
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self)
				-- function 2
				return self.category_texture
			end
		}
	}
	local tbl_3 = {
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
	local tbl_4 = {
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
		}
	}
	local tbl_5 = {
		word_wrap = true,
		upper_case = false,
		localize = false,
		font_size = 42,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag

	flag = not arg_1_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_5.font_type = flag
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_5.default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_5.select_text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_5.offset = {
		30,
		0,
		5
	}
	tbl_5.size = {
		arg_1_1[1] - 40,
		arg_1_1[2]
	}
	tbl_4.title = tbl_5

	local tbl_6 = {
		word_wrap = true,
		upper_case = false,
		localize = false,
		font_size = 42,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_2

	flag_2 = not arg_1_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_6.font_type = flag_2
	tbl_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.normal_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.offset = {
		32,
		-2,
		4
	}
	tbl_6.size = {
		arg_1_1[1] - 40,
		arg_1_1[2]
	}
	tbl_4.title_shadow = tbl_6
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_1_0

	return tbl
end

UIWidgets.create_store_collection_entry_definition = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local str = "button_frame_02_gold"
	local var_3_1 = UIFrameSettings[str]
	local var_3_2 = var_3_1.texture_sizes.horizontal[2]
	local str_2 = "frame_outer_glow_04"
	local var_3_4 = UIFrameSettings[str_2]
	local var_3_5 = var_3_4.texture_sizes.horizontal[2]
	local str_3 = "frame_outer_glow_04_big"
	local var_3_7 = UIFrameSettings[str_3]
	local var_3_8 = var_3_7.texture_sizes.horizontal[2]
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self)
				-- function 4
				return self.texture_id
			end
		},
		{
			pass_type = "texture",
			style_id = "owned_icon",
			texture_id = "owned_icon",
			content_check_function = function (self)
				-- function 5
				return self.owned
			end
		},
		{
			pass_type = "texture",
			style_id = "owned_icon_bg",
			texture_id = "owned_icon_bg",
			content_check_function = function (self)
				-- function 6
				return self.owned
			end
		}
	}
	local tbl_3 = {
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
	local tbl_4 = {
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
		}
	}
	local tbl_5 = {
		word_wrap = false,
		upper_case = false,
		localize = false,
		font_size = 42,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag

	flag = not arg_3_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_5.font_type = flag
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_5.default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_5.select_text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_5.offset = {
		30,
		0,
		5
	}
	tbl_5.size = {
		arg_3_1[1] - 170,
		arg_3_1[2]
	}
	tbl_4.title = tbl_5

	local tbl_6 = {
		word_wrap = false,
		upper_case = false,
		localize = false,
		font_size = 42,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true
	}
	local flag_2

	flag_2 = not arg_3_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_6.font_type = flag_2
	tbl_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.normal_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.offset = {
		32,
		-2,
		4
	}
	tbl_6.size = {
		arg_3_1[1] - 170,
		arg_3_1[2]
	}
	tbl_4.title_shadow = tbl_6
	tbl_4.owned_icon = {
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
	}
	tbl_4.owned_icon_bg = {
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
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_3_0

	return tbl
end

local tbl = {}

UIWidgets.create_store_item_definition = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local str = "menu_frame_16"
	local var_7_1 = UIFrameSettings[str]
	local str_2 = "frame_outer_glow_04"
	local var_7_3 = UIFrameSettings[str_2]
	local var_7_4 = var_7_3.texture_sizes.horizontal[2]
	local str_3 = "frame_outer_glow_04_big"
	local var_7_6 = UIFrameSettings[str_3]
	local var_7_7 = var_7_6.texture_sizes.horizontal[2]

	if not arg_7_4 then
		-- Nothing
	end

	::label_7_0::

	local parent_settings = arg_7_3.parent_settings

	if not parent_settings then
		parent_settings = arg_7_3.settings
		parent_settings = parent_settings or tbl
	end

	::label_7_1::

	local dlc_settings = arg_7_3.dlc_settings

	dlc_settings = dlc_settings or tbl

	local icon_size = parent_settings.icon_size
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
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
			content_check_function = function (self)
				-- function 8
				return self.background
			end
		},
		{
			pass_type = "texture",
			style_id = "expire_time_icon",
			texture_id = "expire_time_icon",
			content_check_function = function (self)
				-- function 9
				return self.discount
			end
		},
		{
			pass_type = "texture",
			style_id = "background_price",
			texture_id = "background_price",
			content_check_function = function (self)
				-- function 10
				return (not not self.owned or IS_WINDOWS or not self.real_currency) and not not self.hide_price or not self.old_price
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "background_price_center",
			texture_id = "background_price_center",
			content_check_function = function (self)
				-- function 11
				return (not not self.owned or IS_WINDOWS or not self.real_currency) and not not self.hide_price or not self.old_price
			end
		},
		{
			pass_type = "texture",
			style_id = "background_price_right",
			texture_id = "background_price_right",
			content_check_function = function (self)
				-- function 12
				return (not not self.owned or IS_WINDOWS or not self.real_currency) and not not self.hide_price or not self.old_price
			end
		},
		{
			pass_type = "texture",
			style_id = "price_gradient",
			texture_id = "price_gradient",
			content_check_function = function (self)
				-- function 13
				return (not not self.owned or IS_WINDOWS or not self.real_currency) and not not self.hide_price or self.old_price
			end
		},
		{
			texture_id = "price_strike_through",
			style_id = "price_strike_through",
			pass_type = "rotated_texture",
			content_check_function = function (self)
				-- function 14
				local old_price

				if not ((self.owned or IS_WINDOWS or not self.real_currency) and self.hide_price) then
					old_price = self.old_price

					if not old_price then
						old_price = self.discount
					end
				else
					old_price = false
				end

				if false then
					old_price = true
				end

				return old_price
			end
		},
		{
			pass_type = "texture",
			style_id = "price_icon",
			texture_id = "price_icon",
			content_check_function = function (self)
				-- function 15
				return not not self.owned or self.draw_price_icon
			end
		},
		{
			style_id = "optional_item_name",
			pass_type = "text",
			text_id = "optional_item_name",
			content_check_function = function (self)
				-- function 16
				return self.optional_item_name ~= ""
			end
		},
		{
			style_id = "optional_subtitle",
			pass_type = "text",
			text_id = "optional_subtitle",
			content_check_function = function (self)
				-- function 17
				return self.optional_item_name ~= ""
			end
		},
		{
			style_id = "price_text",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (self)
				-- function 18
				return (not not self.owned or IS_WINDOWS or not self.real_currency) and not not self.hide_price or not self.old_price
			end
		},
		{
			style_id = "price_text_now",
			pass_type = "text",
			text_id = "price_text_now",
			content_check_function = function (self)
				-- function 19
				return (not not self.owned or IS_WINDOWS or not self.real_currency) and not not self.hide_price or self.old_price
			end
		},
		{
			style_id = "price_text_before",
			pass_type = "text",
			text_id = "price_text_before",
			content_check_function = function (self)
				-- function 20
				local old_price

				if not ((self.owned or IS_WINDOWS or not self.real_currency) and self.hide_price) then
					old_price = self.old_price

					if not old_price then
						old_price = self.discount
					end
				else
					old_price = false
				end

				if false then
					old_price = true
				end

				return old_price
			end
		},
		{
			pass_type = "texture",
			style_id = "owned_icon",
			texture_id = "owned_icon",
			content_check_function = function (self)
				-- function 21
				return self.owned
			end
		},
		{
			pass_type = "texture",
			style_id = "owned_icon_bg",
			texture_id = "owned_icon_bg",
			content_check_function = function (self)
				-- function 22
				return self.owned
			end
		},
		{
			pass_type = "texture",
			style_id = "discount_bg",
			texture_id = "discount_bg",
			content_check_function = function (self)
				-- function 23
				local discount = self.discount

				discount = not discount and not self.hide_price

				return discount
			end
		},
		{
			pass_type = "multi_texture",
			style_id = "discont_number_icons",
			texture_id = "discont_number_icons",
			content_check_function = function (self)
				-- function 24
				local discount = self.discount

				discount = not discount and not self.hide_price

				return discount
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
			content_check_function = function (self)
				-- function 25
				return not self.icon
			end,
			content_change_function = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				local progress = arg_26_1.progress

				progress = progress or 0

				local num = (progress + arg_26_3) % 1

				arg_26_1.angle = math.pow(2, math.smoothstep(num, 0, 1)) * (math.pi * 2)
				arg_26_1.progress = num
			end
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (self)
				-- function 27
				local icon = self.icon

				icon = not icon and not self.rendering_loading_icon

				return icon
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
			content_check_function = function (self, arg_28_1)
				-- function 28
				return self.type_tag_icon
			end
		},
		{
			pass_type = "texture",
			style_id = "psplus_icon",
			texture_id = "psplus_icon",
			content_check_function = function (self)
				-- function 29
				local show_ps4_plus = self.show_ps4_plus

				if not show_ps4_plus then
					show_ps4_plus = IS_PS4
					show_ps4_plus = not show_ps4_plus and self.real_currency
				end

				return show_ps4_plus
			end
		},
		{
			pass_type = "texture",
			style_id = "console_background_rect_bottom",
			texture_id = "console_background_rect",
			content_check_function = function (self)
				-- function 30
				return not not IS_WINDOWS or self.real_currency
			end
		},
		{
			pass_type = "texture",
			style_id = "console_background_rect_top",
			texture_id = "console_background_rect",
			content_check_function = function (self)
				-- function 31
				local real_currency

				if not IS_WINDOWS then
					real_currency = self.real_currency

					if not real_currency then
						-- Nothing
					end

					if self.console_secondary_price_text == "" then
						-- Nothing
					end
				end

				real_currency = false

				goto label_31_1

				::label_31_0::

				real_currency = true

				::label_31_1::

				return real_currency
			end
		},
		{
			texture_id = "console_secondary_price_stroke",
			style_id = "console_secondary_price_stroke",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 32
				local show_secondary_stroke = self.show_secondary_stroke

				show_secondary_stroke = not show_secondary_stroke and not not IS_WINDOWS or self.real_currency

				return show_secondary_stroke
			end
		},
		{
			texture_id = "console_third_price_stroke",
			style_id = "console_third_price_stroke",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 33
				local show_third_stroke = self.show_third_stroke

				if not show_third_stroke then
					show_third_stroke = IS_PS4
					show_third_stroke = not show_third_stroke and self.real_currency
				end

				return show_third_stroke
			end
		},
		{
			style_id = "console_first_price_text",
			pass_type = "text",
			text_id = "console_first_price_text",
			content_check_function = function (self)
				-- function 34
				return not not IS_WINDOWS or self.real_currency
			end,
			content_change_function = function (self, arg_35_1)
				-- function 35
				local ps_plus_color

				if not self.show_ps4_plus then
					ps_plus_color = arg_35_1.ps_plus_color

					if not ps_plus_color then
						-- Nothing
					end
				end

				ps_plus_color = arg_35_1.base_color

				::label_35_0::

				arg_35_1.text_color = ps_plus_color
			end
		},
		{
			style_id = "console_secondary_price_text",
			pass_type = "text",
			text_id = "console_secondary_price_text",
			content_check_function = function (self)
				-- function 36
				return self.console_secondary_price_text == "" or not not IS_WINDOWS or self.real_currency
			end
		},
		{
			style_id = "console_third_price_text",
			pass_type = "text",
			text_id = "console_third_price_text",
			content_check_function = function (self)
				-- function 37
				local IS_PS4

				if self.console_third_price_text ~= "" then
					IS_PS4 = IS_PS4

					if not IS_PS4 then
						IS_PS4 = self.real_currency
					end
				else
					IS_PS4 = false
				end

				if false then
					IS_PS4 = true
				end

				return IS_PS4
			end
		},
		{
			style_id = "new_marker",
			pass_type = "texture",
			texture_id = "new_marker",
			content_check_function = function (self)
				-- function 38
				if not self.discount then
					return false
				end

				return not not PlayerData.seen_shop_items[self.item_key] or not self.hide_new
			end,
			content_change_function = function (self, arg_39_1)
				-- function 39
				if not PlayerData.seen_shop_items[self.item_key] then
					local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

					arg_39_1.color[1] = 100 + 155 * num
				end
			end
		},
		{
			style_id = "additional_content_added",
			pass_type = "text",
			text_id = "additional_content_added",
			content_check_function = function (self)
				-- function 40
				local IS_CONSOLE = IS_CONSOLE

				if not IS_CONSOLE then
					IS_CONSOLE = dlc_settings.additional_content_added
					IS_CONSOLE = not IS_CONSOLE and not self.owned
				end

				return IS_CONSOLE
			end,
			content_change_function = function (arg_41_0, arg_41_1)
				-- function 41
				local time_since_launch = Application.time_since_launch()
				local num = 0.5 + math.sin(time_since_launch * 3) * 0.5

				arg_41_1.text_color[2] = math.lerp(arg_41_1.base_text_color[2], 225, num)
				arg_41_1.text_color[3] = math.lerp(arg_41_1.base_text_color[3], 225, num)
				arg_41_1.text_color[4] = math.lerp(arg_41_1.base_text_color[4], 225, num)
			end
		},
		{
			style_id = "additional_content_added_shadow",
			pass_type = "text",
			text_id = "additional_content_added",
			content_check_function = function (self)
				-- function 42
				local IS_CONSOLE = IS_CONSOLE

				if not IS_CONSOLE then
					IS_CONSOLE = dlc_settings.additional_content_added
					IS_CONSOLE = not IS_CONSOLE and not self.owned
				end

				return IS_CONSOLE
			end
		},
		{
			style_id = "additional_disclaimer",
			pass_type = "text",
			text_id = "additional_disclaimer",
			content_check_function = function (self, arg_43_1)
				-- function 43
				return self.has_disclamer
			end
		},
		{
			pass_type = "texture",
			style_id = "disclaimer_marker",
			texture_id = "disclaimer_marker",
			content_check_function = function (self, arg_44_1)
				-- function 44
				return self.has_disclamer
			end
		}
	}
	local tbl_4 = {
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
		hide_new = parent_settings.hide_new,
		item_key = arg_7_3.product_id,
		hotspot = {},
		hide_price = parent_settings.hide_price,
		masked_price_strike_through = not parent_settings.mask_price_strike_through_hack,
		draw_price_icon = not parent_settings.hide_price,
		discont_number_icons = {}
	}
	local flag

	flag = not arg_7_2 and "rect_masked" and "simple_rect_texture"
	tbl_4.rect = flag
	tbl_4.frame = var_7_1.texture
	tbl_4.hover_frame = var_7_3.texture
	tbl_4.pulse_frame = var_7_6.texture
	tbl_4.size = arg_7_1

	local flag_2

	flag_2 = not arg_7_2 and "rect_masked" and "simple_rect_texture"
	tbl_4.console_background_rect = flag_2

	local flag_3

	flag_3 = not arg_7_2 and "rect_masked" and "simple_rect_texture"
	tbl_4.console_secondary_price_stroke = flag_3

	local flag_4

	flag_4 = not arg_7_2 and "rect_masked" and "simple_rect_texture"
	tbl_4.console_third_price_stroke = flag_4
	tbl_4.additional_content_added = Localize("title_screen_store_new_additional_content")

	local tbl_5 = {
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
		}
	}
	local tbl_6 = {
		upper_case = false,
		localize = false,
		font_size = 28,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = false,
		size = {
			45,
			40
		}
	}
	local flag_5

	flag_5 = not arg_7_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_6.font_type = flag_5
	tbl_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.offset = {
		50,
		-(arg_7_1[2] + 4),
		12
	}
	tbl_5.price_text = tbl_6

	local tbl_7 = {
		upper_case = false,
		localize = false,
		font_size = 40,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true,
		size = {
			320,
			60
		}
	}
	local flag_6

	flag_6 = not arg_7_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_7.font_type = flag_6
	tbl_7.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_7.offset = {
		40,
		-100,
		12
	}
	tbl_5.optional_item_name = tbl_7

	local tbl_8 = {
		upper_case = false,
		localize = false,
		font_size = 28,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = true,
		size = {
			320,
			60
		}
	}
	local flag_7

	flag_7 = not arg_7_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_8.font_type = flag_7
	tbl_8.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_8.offset = {
		40,
		-150,
		12
	}
	tbl_5.optional_subtitle = tbl_8

	local tbl_9 = {
		upper_case = false,
		localize = false,
		font_size = 28,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = false,
		size = {
			45,
			40
		}
	}
	local flag_8

	flag_8 = not arg_7_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_9.font_type = flag_8
	tbl_9.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_9.offset = {
		50,
		-(arg_7_1[2] + 0),
		12
	}
	tbl_5.price_text_now = tbl_9

	local tbl_10 = {
		upper_case = false,
		localize = false,
		font_size = 24,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = false,
		size = {
			45,
			40
		}
	}
	local flag_9

	flag_9 = not arg_7_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_10.font_type = flag_9
	tbl_10.text_color = Colors.get_color_table_with_alpha("slate_gray", 255)
	tbl_10.offset = {
		50,
		-(arg_7_1[2] - 1),
		12
	}
	tbl_5.price_text_before = tbl_10
	tbl_5.price_strike_through = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		angle = -0.17,
		masked = tbl_4.masked_price_strike_through,
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
	}
	tbl_5.background_rect = {
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
	}
	tbl_5.background = {
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
	}
	tbl_5.expire_time_icon = {
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
	}
	tbl_5.overlay = {
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
	}

	local tbl_11 = {
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
		}
	}
	local flag_10

	flag_10 = not arg_7_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_11.font_type = flag_10
	tbl_11.text_color = {
		255,
		255,
		116,
		246
	}
	tbl_11.offset = {
		arg_7_1[1] - 80,
		-44,
		12
	}
	tbl_5.bundle_content_amount_text = tbl_11
	tbl_5.type_tag_icon = {
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
	}
	tbl_5.background_price = {
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
	}
	tbl_5.background_price_center = {
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
	}
	tbl_5.background_price_right = {
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
	}
	tbl_5.price_gradient = {
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
	}
	tbl_5.price_icon = {
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
	}
	tbl_5.owned_icon = {
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
	}
	tbl_5.owned_icon_bg = {
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
	}
	tbl_5.discount_bg = {
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
	}
	tbl_5.discont_number_icons = {
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
	}

	local tbl_12 = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		masked = arg_7_2,
		texture_size = icon_size or arg_7_1,
		color = {
			255,
			255,
			255,
			255
		}
	}
	local tbl_13 = {
		nil,
		nil,
		7
	}
	local num

	if not icon_size then
		num = (arg_7_1[1] - icon_size[1]) * 0.5

		if not num then
			-- Nothing
		end
	end

	num = 0

	::label_7_2::

	tbl_13[1] = num

	local num_2

	if not icon_size then
		num_2 = -(arg_7_1[2] - icon_size[2]) * 0.5

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = 0

	::label_7_3::

	tbl_13[2] = num_2
	tbl_12.offset = tbl_13
	tbl_5.icon = tbl_12
	tbl_5.frame = {
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
	}
	tbl_5.hover_frame = {
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
	}
	tbl_5.pulse_frame = {
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
	}

	local tbl_14 = {
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
	}

	tbl_5.console_background_rect_bottom = tbl_14

	local tbl_15 = {
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
	}

	tbl_5.console_background_rect_top = tbl_15

	local tbl_16 = {
		upper_case = false,
		localize = false,
		font_size = 28,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = false,
		size = {
			45,
			40
		}
	}
	local flag_11

	flag_11 = not arg_7_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_16.font_type = flag_11
	tbl_16.text_color = Colors.get_color_table_with_alpha("white", 255)

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha("white", 255)

	tbl_16.base_color = get_color_table_with_alpha

	local tbl_17 = {
		255,
		255,
		205,
		0
	}

	tbl_16.ps_plus_color = tbl_17
	tbl_16.offset = {
		arg_7_1[1],
		-(arg_7_1[2] - 4),
		12
	}
	tbl_5.console_first_price_text = tbl_16

	local tbl_18 = {
		upper_case = false,
		localize = false,
		font_size = 28,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = false,
		size = {
			45,
			40
		}
	}
	local flag_12

	flag_12 = not arg_7_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_18.font_type = flag_12
	tbl_18.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_18.offset = {
		arg_7_1[1],
		-(arg_7_1[2] - 4 - 30),
		12
	}
	tbl_5.console_secondary_price_text = tbl_18

	local tbl_19 = {
		upper_case = false,
		localize = false,
		font_size = 20,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = false,
		size = {
			45,
			40
		}
	}
	local flag_13

	flag_13 = not arg_7_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_19.font_type = flag_13
	tbl_19.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_19.offset = {
		arg_7_1[1],
		-(arg_7_1[2] - 4 - 30),
		12
	}
	tbl_5.console_third_price_text = tbl_19
	tbl_5.console_secondary_price_stroke = {
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
	}
	tbl_5.console_third_price_stroke = {
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
	}

	local tbl_20 = {
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
	}

	tbl_5.psplus_icon = tbl_20

	local tbl_21 = {
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
	}

	tbl_5.new_marker = tbl_21

	local tbl_22 = {
		font_size = 24,
		upper_case = true,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = false
	}
	local flag_14

	flag_14 = not arg_7_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_22.font_type = flag_14
	tbl_22.text_color = {
		255,
		159,
		144,
		101
	}

	local tbl_23 = {
		255,
		159,
		144,
		101
	}

	tbl_22.base_text_color = tbl_23
	tbl_22.offset = {
		20,
		-180,
		12
	}
	tbl_5.additional_content_added = tbl_22

	local tbl_24 = {
		font_size = 24,
		upper_case = true,
		localize = false,
		horizontal_alignment = "left",
		vertical_alignment = "bottom",
		dynamic_font_size = false
	}
	local flag_15

	flag_15 = not arg_7_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_24.font_type = flag_15
	tbl_24.text_color = {
		255,
		0,
		0,
		0
	}
	tbl_24.offset = {
		22,
		-182,
		11
	}
	tbl_5.additional_content_added_shadow = tbl_24

	local tbl_25 = {
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
	}

	tbl_5.disclaimer_marker = tbl_25

	local tbl_26 = {
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
		}
	}
	local flag_16

	flag_16 = not arg_7_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_26.font_type = flag_16
	tbl_26.text_color = Colors.get_color_table_with_alpha("white", 180)
	tbl_26.offset = {
		62,
		70,
		15
	}
	tbl_5.additional_disclaimer = tbl_26
	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		5
	}
	tbl_2.scenegraph_id = arg_7_0

	return tbl_2
end

UIWidgets.create_store_pose_item_definition = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	local settings = arg_45_3.settings

	return UIWidgets.create_store_item_definition(arg_45_0, arg_45_1, arg_45_2, arg_45_3, settings)
end

UIWidgets.create_store_header_text_definition = function (arg_46_0, arg_46_1, arg_46_2)
	-- function 46
	local num = -arg_46_1[2]
	local num_2 = 25
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
	local tbl_3 = {
		text = "n/a",
		size = arg_46_1
	}
	local tbl_4 = {}
	local tbl_5 = {
		font_size = 32,
		upper_case = false,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		size = {
			arg_46_1[1] - num_2 * 2,
			arg_46_1[2]
		}
	}
	local flag

	flag = not arg_46_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_5.font_type = flag
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_5.offset = {
		num_2,
		num,
		9
	}
	tbl_4.text = tbl_5

	local tbl_6 = {
		font_size = 32,
		upper_case = false,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		size = {
			arg_46_1[1] - num_2 * 2,
			arg_46_1[2]
		}
	}
	local flag_2

	flag_2 = not arg_46_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_6.font_type = flag_2
	tbl_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.offset = {
		num_2 + 2,
		num - 2,
		8
	}
	tbl_4.text_shadow = tbl_6
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_46_0

	return tbl
end

UIWidgets.create_store_body_text_definition = function (arg_47_0, arg_47_1, arg_47_2)
	-- function 47
	local num = -arg_47_1[2]
	local num_2 = 25
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
	local tbl_3 = {
		text = "n/a",
		size = arg_47_1
	}
	local tbl_4 = {}
	local tbl_5 = {
		font_size = 20,
		upper_case = false,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		size = {
			arg_47_1[1] - num_2 * 2,
			arg_47_1[2]
		}
	}
	local flag

	flag = not arg_47_2 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_5.offset = {
		num_2,
		num,
		9
	}
	tbl_4.text = tbl_5

	local tbl_6 = {
		font_size = 20,
		upper_case = false,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		size = {
			arg_47_1[1] - num_2 * 2,
			arg_47_1[2]
		}
	}
	local flag_2

	flag_2 = not arg_47_2 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_2
	tbl_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.offset = {
		num_2 + 2,
		num - 2,
		8
	}
	tbl_4.text_shadow = tbl_6
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_47_0

	return tbl
end

UIWidgets.create_store_currency_summary_title_definition = function (arg_48_0, arg_48_1, arg_48_2)
	-- function 48
	local num = -arg_48_1[2]
	local num_2 = 25
	local tbl = {
		255,
		120,
		120,
		120
	}
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
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
	local tbl_4 = {
		text = "n/a",
		text2 = "n/a",
		size = arg_48_1
	}
	local flag

	flag = not arg_48_2 and "rect_masked" and "simple_rect_texture"
	tbl_4.rect = flag

	local tbl_5 = {}
	local tbl_6 = {
		font_size = 16,
		upper_case = true,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		size = {
			arg_48_1[1] - num_2 * 2,
			arg_48_1[2]
		}
	}
	local flag_2

	flag_2 = not arg_48_2 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_2
	tbl_6.text_color = tbl
	tbl_6.offset = {
		num_2,
		num,
		9
	}
	tbl_5.text = tbl_6

	local tbl_7 = {
		font_size = 16,
		upper_case = true,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		size = {
			arg_48_1[1] - num_2 * 2,
			arg_48_1[2]
		}
	}
	local flag_3

	flag_3 = not arg_48_2 and "hell_shark_masked" and "hell_shark"
	tbl_7.font_type = flag_3
	tbl_7.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_7.offset = {
		num_2 + 2,
		num - 2,
		8
	}
	tbl_5.text_shadow = tbl_7

	local tbl_8 = {
		font_size = 16,
		upper_case = true,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "right",
		vertical_alignment = "top",
		dynamic_font_size = false,
		size = {
			arg_48_1[1] - num_2 * 2,
			arg_48_1[2]
		}
	}
	local flag_4

	flag_4 = not arg_48_2 and "hell_shark_masked" and "hell_shark"
	tbl_8.font_type = flag_4
	tbl_8.text_color = tbl
	tbl_8.offset = {
		num_2,
		num,
		9
	}
	tbl_5.text2 = tbl_8

	local tbl_9 = {
		font_size = 16,
		upper_case = true,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "right",
		vertical_alignment = "top",
		dynamic_font_size = false,
		size = {
			arg_48_1[1] - num_2 * 2,
			arg_48_1[2]
		}
	}
	local flag_5

	flag_5 = not arg_48_2 and "hell_shark_masked" and "hell_shark"
	tbl_9.font_type = flag_5
	tbl_9.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_9.offset = {
		num_2 + 2,
		num - 2,
		8
	}
	tbl_5.text2_shadow = tbl_9
	tbl_5.divider = {
		vertical_alignment = "bottom",
		horizontal_alignment = "left",
		masked = arg_48_2,
		texture_size = {
			arg_48_1[1] - num_2 * 2,
			2
		},
		color = tbl,
		offset = {
			num_2,
			0,
			8
		}
	}
	tbl_5.divider_shadow = {
		vertical_alignment = "bottom",
		horizontal_alignment = "left",
		masked = arg_48_2,
		texture_size = {
			arg_48_1[1] - num_2 * 2,
			2
		},
		color = {
			255,
			0,
			0,
			0
		},
		offset = {
			num_2 + 2,
			0,
			7
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
	tbl_2.scenegraph_id = arg_48_0

	return tbl_2
end

UIWidgets.create_store_currency_summary_entry_definition = function (arg_49_0, arg_49_1, arg_49_2)
	-- function 49
	local num = -arg_49_1[2]
	local num_2 = 25
	local tbl = {
		255,
		120,
		120,
		120
	}
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
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
	local tbl_4 = {
		text = "n/a",
		text2 = "n/a",
		size = arg_49_1
	}
	local tbl_5 = {}
	local tbl_6 = {
		font_size = 20,
		upper_case = false,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		size = {
			arg_49_1[1] - num_2 * 2,
			arg_49_1[2]
		}
	}
	local flag

	flag = not arg_49_2 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag
	tbl_6.text_color = tbl
	tbl_6.offset = {
		num_2,
		num,
		9
	}
	tbl_5.text = tbl_6

	local tbl_7 = {
		font_size = 20,
		upper_case = false,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		dynamic_font_size = false,
		size = {
			arg_49_1[1] - num_2 * 2,
			arg_49_1[2]
		}
	}
	local flag_2

	flag_2 = not arg_49_2 and "hell_shark_masked" and "hell_shark"
	tbl_7.font_type = flag_2
	tbl_7.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_7.offset = {
		num_2 + 2,
		num - 2,
		8
	}
	tbl_5.text_shadow = tbl_7

	local tbl_8 = {
		font_size = 20,
		upper_case = false,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "right",
		vertical_alignment = "top",
		dynamic_font_size = false,
		size = {
			arg_49_1[1] - num_2 * 2,
			arg_49_1[2]
		}
	}
	local flag_3

	flag_3 = not arg_49_2 and "hell_shark_masked" and "hell_shark"
	tbl_8.font_type = flag_3
	tbl_8.text_color = tbl
	tbl_8.offset = {
		num_2,
		num,
		9
	}
	tbl_5.text2 = tbl_8

	local tbl_9 = {
		font_size = 20,
		upper_case = false,
		localize = false,
		word_wrap = true,
		horizontal_alignment = "right",
		vertical_alignment = "top",
		dynamic_font_size = false,
		size = {
			arg_49_1[1] - num_2 * 2,
			arg_49_1[2]
		}
	}
	local flag_4

	flag_4 = not arg_49_2 and "hell_shark_masked" and "hell_shark"
	tbl_9.font_type = flag_4
	tbl_9.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_9.offset = {
		num_2 + 2,
		num - 2,
		8
	}
	tbl_5.text2_shadow = tbl_9
	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = arg_49_0

	return tbl_2
end

UIWidgets.create_store_dlc_feature_vertical_definition = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	-- function 50
	local str = "menu_frame_16"
	local var_50_1 = UIFrameSettings[str]
	local tbl_2 = {
		arg_50_1[1],
		220
	}
	local num = -arg_50_1[2]
	local num_2 = 5
	local settings = arg_50_3.settings

	settings = settings or tbl

	local add_frame = settings.add_frame
	local tbl_3 = {
		element = {}
	}
	local tbl_4 = {
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
			content_check_function = function (self)
				-- function 51
				return self.add_frame
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame",
			content_check_function = function (self)
				-- function 52
				return self.add_frame
			end
		}
	}
	local tbl_5 = {
		text = "n/a",
		background = "store_thumbnail_bg_promo"
	}
	local flag

	flag = not arg_50_2 and "rect_masked" and "simple_rect_texture"
	tbl_5.image = flag
	tbl_5.size = arg_50_1
	tbl_5.frame = var_50_1.texture
	tbl_5.add_frame = add_frame

	local tbl_6 = {}
	local tbl_7 = {
		upper_case = false,
		localize = false,
		dynamic_font_size_word_wrap = true,
		word_wrap = true,
		font_size = 20,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		size = {
			tbl_2[1] - num_2,
			arg_50_1[2] - tbl_2[2]
		},
		area_size = {
			tbl_2[1] - num_2,
			arg_50_1[2] - tbl_2[2]
		}
	}
	local flag_2

	flag_2 = not arg_50_2 and "hell_shark_masked" and "hell_shark"
	tbl_7.font_type = flag_2
	tbl_7.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_7.offset = {
		num_2,
		num - 0,
		9
	}
	tbl_6.text = tbl_7

	local tbl_8 = {
		upper_case = false,
		localize = false,
		dynamic_font_size_word_wrap = true,
		word_wrap = true,
		font_size = 20,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		size = {
			tbl_2[1] - num_2,
			arg_50_1[2] - tbl_2[2]
		},
		area_size = {
			tbl_2[1] - num_2,
			arg_50_1[2] - tbl_2[2]
		}
	}
	local flag_3

	flag_3 = not arg_50_2 and "hell_shark_masked" and "hell_shark"
	tbl_8.font_type = flag_3
	tbl_8.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_8.offset = {
		num_2 + 2,
		num - 0 - 2,
		8
	}
	tbl_6.text_shadow = tbl_8
	tbl_6.image = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		masked = arg_50_2,
		texture_size = tbl_2,
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
	}
	tbl_6.background = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		masked = arg_50_2,
		texture_size = tbl_2,
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
	tbl_6.frame = {
		horizontal_alignment = "left",
		vertical_alignment = "top",
		masked = arg_50_2,
		area_size = tbl_2,
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
	tbl_3.element.passes = tbl_4
	tbl_3.content = tbl_5
	tbl_3.style = tbl_6
	tbl_3.offset = {
		0,
		0,
		0
	}
	tbl_3.scenegraph_id = arg_50_0

	return tbl_3
end

UIWidgets.create_store_dlc_feature_horizontal_definition = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	-- function 53
	local var_53_0
	local var_53_1
	local settings = arg_53_3.settings

	if not settings then
		var_53_0 = settings.image_size
		var_53_1 = settings.frame_name
	end

	var_53_0 = var_53_0 or {
		260,
		arg_53_1[2]
	}

	local flag = var_53_1 or "menu_frame_16"
	local flag_2 = not flag and UIFrameSettings[flag]
	local num = -arg_53_1[2]
	local num_2 = 20
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
			content_check_function = function (self)
				-- function 54
				return self.show_frame
			end
		}
	}
	local tbl_3 = {
		text = "n/a"
	}
	local flag_3

	flag_3 = not arg_53_2 and "rect_masked" and "simple_rect_texture"
	tbl_3.image = flag_3
	tbl_3.size = arg_53_1
	tbl_3.show_frame = settings.show_frame
	tbl_3.frame = flag_2.texture

	local tbl_4 = {}
	local tbl_5 = {
		font_size = 20,
		upper_case = false,
		localize = false,
		dynamic_font_size_word_wrap = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		size = {
			arg_53_1[1] - var_53_0[1] - num_2,
			arg_53_1[2]
		}
	}
	local flag_4

	flag_4 = not arg_53_2 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag_4
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_5.offset = {
		var_53_0[1] + num_2,
		num - 0,
		9
	}
	tbl_4.text = tbl_5

	local tbl_6 = {
		font_size = 20,
		upper_case = false,
		localize = false,
		dynamic_font_size_word_wrap = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		size = {
			arg_53_1[1] - var_53_0[1] - num_2,
			arg_53_1[2]
		}
	}
	local flag_5

	flag_5 = not arg_53_2 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_5
	tbl_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.offset = {
		var_53_0[1] + num_2 + 2,
		num - 0 - 2,
		8
	}
	tbl_4.text_shadow = tbl_6
	tbl_4.image = {
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
	}
	tbl_4.frame = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		masked = arg_53_2,
		texture_size = flag_2.texture_size,
		texture_sizes = flag_2.texture_sizes,
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
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_53_0

	return tbl
end

UIWidgets.create_store_dlc_feature_pullet_point_definition = function (arg_55_0, arg_55_1, arg_55_2)
	-- function 55
	local tbl = {
		26,
		28
	}
	local num = -arg_55_1[2]
	local num_2 = 50
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
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
	local tbl_4 = {
		text = "n/a",
		image = "chain_link_horizontal_01_end",
		size = arg_55_1
	}
	local tbl_5 = {}
	local tbl_6 = {
		font_size = 20,
		upper_case = false,
		localize = false,
		dynamic_font_size_word_wrap = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		size = {
			arg_55_1[1] - tbl[1] - num_2,
			arg_55_1[2]
		}
	}
	local flag

	flag = not arg_55_2 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag
	tbl_6.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_6.offset = {
		tbl[1] + num_2,
		num - 0,
		9
	}
	tbl_5.text = tbl_6

	local tbl_7 = {
		font_size = 20,
		upper_case = false,
		localize = false,
		dynamic_font_size_word_wrap = false,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		size = {
			arg_55_1[1] - tbl[1] - num_2,
			arg_55_1[2]
		}
	}
	local flag_2

	flag_2 = not arg_55_2 and "hell_shark_masked" and "hell_shark"
	tbl_7.font_type = flag_2
	tbl_7.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_7.offset = {
		tbl[1] + num_2 + 2,
		num - 0 - 2,
		8
	}
	tbl_5.text_shadow = tbl_7
	tbl_5.image = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		masked = arg_55_2,
		texture_size = tbl,
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			num_2 / 2,
			0,
			8
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
	tbl_2.scenegraph_id = arg_55_0

	return tbl_2
end

UIWidgets.create_store_list_spacing_definition = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	-- function 56
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {
		size = arg_56_1
	}
	local tbl_4 = {}

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_56_0

	return tbl
end

UIWidgets.create_store_dlc_logo_definition = function (arg_57_0, arg_57_1, arg_57_2)
	-- function 57
	local tbl = {
		440,
		64
	}
	local num = -arg_57_1[2]
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
		{
			pass_type = "texture",
			style_id = "image",
			texture_id = "image"
		}
	}
	local tbl_4 = {}
	local flag

	flag = not arg_57_2 and "rect_masked" and "simple_rect_texture"
	tbl_4.image = flag
	tbl_4.size = arg_57_1

	local tbl_5 = {
		image = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_57_2,
			texture_size = tbl,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_57_1[1] / 2 - tbl[1] / 2,
				tbl[2],
				8
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
	tbl_2.scenegraph_id = arg_57_0

	return tbl_2
end

UIWidgets.create_store_list_divider_definition = function (arg_58_0, arg_58_1, arg_58_2)
	-- function 58
	local tbl = {
		618,
		32
	}
	local num = -arg_58_1[2]
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
		{
			pass_type = "texture",
			style_id = "image",
			texture_id = "image"
		}
	}
	local tbl_4 = {
		image = "store_divider",
		size = arg_58_1
	}
	local tbl_5 = {
		image = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_58_2,
			texture_size = tbl,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_58_1[1] / 2 - tbl[1] / 2,
				-(arg_58_1[2] / 2 - tbl[2] / 2),
				8
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
	tbl_2.scenegraph_id = arg_58_0

	return tbl_2
end

UIWidgets.create_store_header_video_definition = function (arg_59_0, arg_59_1, arg_59_2)
	-- function 59
	local num = 0.6
	local num_2 = 0.2
	local num_3 = -(arg_59_1[2] * 0.6)
	local num_4 = -arg_59_1[2]
	local tbl = {
		element = {}
	}
	local tbl_2 = {
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
	local tbl_3 = {
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
		}
	}
	local flag

	flag = not arg_59_2 and "rect_masked" and "simple_rect_texture"
	tbl_3.rect = flag
	tbl_3.size = arg_59_1

	local tbl_4 = {
		button_hotspot = {
			size = arg_59_1,
			offset = {
				0,
				num_4,
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
				num_4,
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
				num_4 + arg_59_1[2] / 2 + arg_59_1[2] * num / 2 + num_3 * 0.5,
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
				arg_59_1[2] * num
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				0,
				num_4 + arg_59_1[2] * num - 1 + num_3,
				3
			}
		},
		bottom_fade = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_59_2,
			texture_size = {
				arg_59_1[1],
				arg_59_1[2] * num_2
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				0,
				num_4 + num_3,
				3
			}
		},
		top_fade = {
			vertical_alignment = "top",
			masked = false,
			horizontal_alignment = "left",
			texture_size = {
				arg_59_1[1],
				arg_59_1[2] * num_2
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				0,
				num_4 + (arg_59_1[2] * num + arg_59_1[2] * num_2 - 2) + num_3,
				3
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
	tbl.scenegraph_id = arg_59_0

	return tbl
end

UIWidgets.create_store_purchase_button = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4)
	-- function 60
	local str = "menu_frame_bg_07"
	local var_60_1

	if not UIAtlasHelper.has_atlas_settings_by_texture_name(str) then
		local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)

		var_60_1 = {
			get_atlas_settings_by_texture_name.size[1],
			get_atlas_settings_by_texture_name.size[2]
		}
	else
		var_60_1 = {
			512,
			256
		}
	end

	local str_2 = "button_frame_01_gold"
	local var_60_4

	if not str_2 then
		var_60_4 = UIFrameSettings[str_2]

		if not var_60_4 then
			-- Nothing
		end
	end

	var_60_4 = UIFrameSettings.button_frame_01

	::label_60_0::

	local var_60_5 = var_60_4.texture_sizes.corner[1]
	local str_3 = "button_detail_09_gold"
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
					content_check_function = function (self)
						-- function 61
						local disable_button = self.button_hotspot.disable_button

						disable_button = not disable_button and not self.owned

						return disable_button
					end
				},
				{
					style_id = "owned_overlay",
					pass_type = "texture_uv",
					content_id = "owned_overlay",
					content_check_function = function (self)
						-- function 62
						return self.parent.owned
					end
				},
				{
					style_id = "owned_text_write_mask",
					pass_type = "text",
					text_id = "owned_text",
					content_check_function = function (self)
						-- function 63
						return self.owned
					end
				},
				{
					texture_id = "owned_text_gradient",
					style_id = "owned_text_gradient",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 64
						return self.owned
					end
				},
				{
					pass_type = "texture",
					style_id = "owned_icon",
					texture_id = "owned_icon",
					content_check_function = function (self)
						-- function 65
						return self.owned
					end
				},
				{
					pass_type = "texture",
					style_id = "owned_icon_bg",
					texture_id = "owned_icon_bg",
					content_check_function = function (self)
						-- function 66
						return self.owned
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
					content_check_function = function (self)
						-- function 67
						return not not self.button_hotspot.disable_button or not not self.owned or self.present_currency
					end
				},
				{
					style_id = "currency_text_disabled",
					pass_type = "text",
					text_id = "currency_text",
					content_check_function = function (self)
						-- function 68
						local button_hotspot = self.button_hotspot
						local present_currency

						if not self.owned then
							present_currency = self.present_currency

							if not present_currency then
								present_currency = button_hotspot.disable_button
							end
						else
							present_currency = false
						end

						if false then
							present_currency = true
						end

						return present_currency
					end
				},
				{
					style_id = "currency_text_shadow",
					pass_type = "text",
					text_id = "currency_text",
					content_check_function = function (self)
						-- function 69
						return not not self.owned or self.present_currency
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 70
						local title_text

						if not self.button_hotspot.disable_button then
							title_text = self.title_text

							if not title_text then
								title_text = IS_WINDOWS

								if not title_text then
									title_text = not self.real_currency
								end
							end
						else
							title_text = false
						end

						if false then
							title_text = true
						end

						return title_text
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 71
						local disable_button = self.button_hotspot.disable_button

						if not disable_button then
							if not self.owned then
								disable_button = self.title_text

								if not disable_button then
									disable_button = IS_WINDOWS

									if not disable_button then
										disable_button = not self.real_currency
									end
								end
							else
								disable_button = false
							end
						end

						if false then
							disable_button = true
						end

						return disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 72
						local title_text

						if not self.owned then
							title_text = self.title_text

							if not title_text then
								title_text = IS_WINDOWS

								if not title_text then
									title_text = not self.real_currency
								end
							end
						else
							title_text = false
						end

						if false then
							title_text = true
						end

						return title_text
					end
				},
				{
					style_id = "title_text_write_mask",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 73
						local title_text

						if not self.button_hotspot.disable_button then
							title_text = self.title_text

							if not title_text then
								title_text = IS_WINDOWS

								if not title_text then
									title_text = not self.real_currency
								end
							end
						else
							title_text = false
						end

						if false then
							title_text = true
						end

						return title_text
					end
				},
				{
					texture_id = "title_text_gradient",
					style_id = "title_text_gradient",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 74
						local IS_WINDOWS

						if not self.button_hotspot.disable_button then
							IS_WINDOWS = IS_WINDOWS

							if not IS_WINDOWS then
								IS_WINDOWS = not self.real_currency
							end
						else
							IS_WINDOWS = false
						end

						if false then
							IS_WINDOWS = true
						end

						return IS_WINDOWS
					end
				},
				{
					texture_id = "glass",
					style_id = "glass",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 75
						return not self.owned
					end
				},
				{
					texture_id = "glass_top",
					style_id = "glass_top",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 76
						return not self.owned
					end
				},
				{
					texture_id = "currency_icon",
					style_id = "currency_icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 77
						local button_hotspot = self.button_hotspot

						return not not self.owned or not not button_hotspot.disable_button or self.present_currency
					end
				},
				{
					texture_id = "currency_icon",
					style_id = "currency_icon_disabled",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 78
						local button_hotspot = self.button_hotspot
						local present_currency

						if not self.owned then
							present_currency = self.present_currency

							if not present_currency then
								present_currency = button_hotspot.disable_button
							end
						else
							present_currency = false
						end

						if false then
							present_currency = true
						end

						return present_currency
					end
				},
				{
					pass_type = "texture",
					style_id = "psplus_icon",
					texture_id = "psplus_icon",
					content_check_function = function (self)
						-- function 79
						local show_ps4_plus = self.show_ps4_plus

						if not show_ps4_plus then
							show_ps4_plus = IS_PS4
							show_ps4_plus = not show_ps4_plus and self.real_currency
						end

						return show_ps4_plus
					end
				},
				{
					pass_type = "texture",
					style_id = "console_background_rect",
					texture_id = "console_background_rect",
					content_check_function = function (self)
						-- function 80
						return not not IS_WINDOWS or self.real_currency
					end
				},
				{
					texture_id = "console_secondary_price_stroke",
					style_id = "console_secondary_price_stroke",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 81
						local show_secondary_stroke = self.show_secondary_stroke

						show_secondary_stroke = not show_secondary_stroke and not not IS_WINDOWS or self.real_currency

						return show_secondary_stroke
					end
				},
				{
					texture_id = "console_third_price_stroke",
					style_id = "console_third_price_stroke",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 82
						local show_third_stroke = self.show_third_stroke

						if not show_third_stroke then
							show_third_stroke = IS_PS4
							show_third_stroke = not show_third_stroke and self.real_currency
						end

						return show_third_stroke
					end
				},
				{
					style_id = "console_first_price_text",
					pass_type = "text",
					text_id = "console_first_price_text",
					content_check_function = function (self)
						-- function 83
						return not not IS_WINDOWS or self.real_currency
					end,
					content_change_function = function (self, arg_84_1)
						-- function 84
						local ps_plus_color

						if not self.show_ps4_plus then
							ps_plus_color = arg_84_1.ps_plus_color

							if not ps_plus_color then
								-- Nothing
							end
						end

						ps_plus_color = arg_84_1.base_color

						::label_84_0::

						arg_84_1.text_color = ps_plus_color
					end
				},
				{
					style_id = "console_secondary_price_text",
					pass_type = "text",
					text_id = "console_secondary_price_text",
					content_check_function = function (self)
						-- function 85
						return self.console_secondary_price_text == "" or not not IS_WINDOWS or self.real_currency
					end
				},
				{
					style_id = "console_third_price_text",
					pass_type = "text",
					text_id = "console_third_price_text",
					content_check_function = function (self)
						-- function 86
						local IS_PS4

						if self.console_third_price_text ~= "" then
							IS_PS4 = IS_PS4

							if not IS_PS4 then
								IS_PS4 = self.real_currency
							end
						else
							IS_PS4 = false
						end

						if false then
							IS_PS4 = true
						end

						return IS_PS4
					end
				},
				{
					texture_id = "lock",
					style_id = "lock",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 87
						return not self.owns_required_dlc
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
				texture_id = str_3
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
				texture_id = str
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
					size[1],
					size[2]
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
					size[1],
					size[2]
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
	-- function 88
	local tbl = {
		-55,
		2,
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
						-- function 89
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
						-- function 90
						return not not self.button_hotspot.disable_button or not not self.button_hotspot.is_hover or not self.button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 91
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "new_marker",
					style_id = "new_marker",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 92
						local new = self.new

						new = not new and not self.timer

						return new
					end
				},
				{
					style_id = "timer_marker",
					pass_type = "texture",
					texture_id = "timer_marker",
					content_check_function = function (self)
						-- function 93
						return self.timer
					end,
					content_change_function = function (arg_94_0, arg_94_1)
						-- function 94
						local num = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

						arg_94_1.color[1] = 100 + 155 * num
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
				default_offset = tbl_3,
				offset = tbl_3,
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
					tbl[1],
					tbl[2],
					tbl[3]
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
					tbl[1] + 42,
					tbl[2] - 2,
					tbl[3]
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
	-- function 95
	local var_95_0

	if not arg_95_1 then
		var_95_0 = UIFrameSettings[arg_95_1]

		if not var_95_0 then
			-- Nothing
		end
	end

	var_95_0 = UIFrameSettings.button_frame_01_gold

	::label_95_0::

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
