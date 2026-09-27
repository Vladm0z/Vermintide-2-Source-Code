-- chunkname: @scripts/ui/hud_ui/deus_soft_currency_indicator_ui_definitions.lua

local num = 1920
local num_2 = 1080
local num_3 = 1
local tbl = {
	325 * num_3,
	50 * num_3
}
local tbl_2 = {
	screen = {
		scale = "fit",
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
	coin_ui = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			0,
			-25,
			0
		},
		size = tbl
	}
}

local function fn()
	-- function 1
	local str = "weaves_essence_bar_backdrop"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local num = get_atlas_settings_by_texture_name.size[2] * 0.5
	local num_2 = get_atlas_settings_by_texture_name.size[1] * 0.5
	local num_3 = -2
	local tbl_2 = {
		num,
		num
	}

	return {
		scenegraph_id = "coin_ui",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background",
					content_check_function = function (arg_2_0)
						-- function 2
						return Managers.mechanism:get_state() ~= "map_deus"
					end
				},
				{
					pass_type = "texture",
					style_id = "background_glow",
					texture_id = "background_glow"
				},
				{
					pass_type = "texture",
					style_id = "coin_icon",
					texture_id = "coin_icon"
				},
				{
					pass_type = "texture",
					style_id = "coin_icon_mask",
					texture_id = "coin_icon_mask"
				},
				{
					pass_type = "texture",
					style_id = "coin_icon_fx",
					texture_id = "coin_icon_fx"
				},
				{
					pass_type = "texture",
					style_id = "coin_icon_highlight",
					texture_id = "coin_icon_highlight"
				},
				{
					pass_type = "texture",
					style_id = "coin_icon_bloom",
					texture_id = "coin_icon_bloom"
				},
				{
					style_id = "coins_label",
					pass_type = "text",
					text_id = "coins_label"
				},
				{
					style_id = "coins_label_shadow",
					pass_type = "text",
					text_id = "coins_label"
				},
				{
					style_id = "coin_count",
					pass_type = "text",
					text_id = "coin_count_text"
				},
				{
					style_id = "coin_count_shadow",
					pass_type = "text",
					text_id = "coin_count_text"
				},
				{
					style_id = "coin_delta",
					pass_type = "text",
					text_id = "coin_delta"
				}
			}
		},
		content = {
			coin_count_text = "NaN",
			coin_icon = "deus_icons_coin",
			coin_icon_mask = "deus_icons_coin_mask",
			coin_icon_fx = "deus_icons_coin_fx",
			coin_delta = "",
			coin_icon_bloom = "quest_glow",
			background_glow = "horizontal_gradient",
			coin_icon_highlight = "deus_icons_coin_highlight",
			coins_label = "deus_collect_coins_text",
			background = str
		},
		style = {
			background = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = get_atlas_settings_by_texture_name.size,
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
			background_glow = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = get_atlas_settings_by_texture_name.size,
				color = {
					0,
					74,
					243,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			coin_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					tbl_2[1],
					tbl_2[2]
				},
				base_size = {
					tbl_2[1],
					tbl_2[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					num_2 - 155,
					num_3,
					10
				}
			},
			coin_icon_mask = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					tbl_2[1],
					tbl_2[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					num_2 - 155,
					num_3,
					11
				}
			},
			coin_icon_fx = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					tbl_2[1],
					tbl_2[2]
				},
				color = {
					0,
					255,
					255,
					255
				},
				base_offset = {
					num_2 - 155,
					num_3,
					12
				},
				offset = {
					num_2 - 155,
					num_3,
					11
				}
			},
			coin_icon_highlight = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					tbl_2[1] * 2,
					tbl_2[2] * 2
				},
				color = {
					0,
					74,
					243,
					255
				},
				offset = {
					num_2 - 155,
					num_3,
					13
				}
			},
			coin_icon_bloom = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					tbl_2[1] * 1.75,
					tbl_2[2] * 1.75
				},
				base_texture_size = {
					tbl_2[1] * 1.75,
					tbl_2[2] * 1.75
				},
				color = {
					0,
					74,
					243,
					255
				},
				offset = {
					num_2 - 155,
					num_3,
					13
				}
			},
			coins_label = {
				word_wrap = false,
				upper_case = false,
				localize = true,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					80,
					-48,
					1
				},
				size = {
					tbl[1] - 80,
					tbl[2]
				}
			},
			coins_label_shadow = {
				word_wrap = false,
				upper_case = false,
				localize = true,
				font_size = 22,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					82,
					-50,
					0
				},
				size = {
					tbl[1] - 80,
					tbl[2]
				}
			},
			coin_count = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				base_font_size = num,
				font_size = num,
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					num_2 + tbl_2[1] + 5,
					num_3 - 2,
					1
				}
			},
			coin_count_shadow = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				font_size = num,
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					num_2 + tbl_2[1] + 5 - 2,
					num_3 - 2 - 2,
					0
				}
			},
			coin_delta = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				localize = false,
				font_type = "hell_shark_header",
				font_size = num,
				text_color = {
					255,
					200,
					200,
					200
				},
				base_offset = {
					num_2 + tbl_2[1] + 5 - 2 + 60,
					num_3 - 2 - 2,
					3
				},
				offset = {
					num_2 + tbl_2[1] + 5 - 2 + 60,
					num_3 - 2 - 2,
					3
				}
			}
		}
	}
end

local tbl_3 = {
	coin_change = {
		{
			name = "count",
			duration = 1.2,
			init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				arg_3_2.content.coin_delta = string.format("%+d", arg_3_3.coin_delta)
				arg_3_3.delta_dir = math.sign(arg_3_3.coin_delta)

				local text_color = arg_3_2.style.coin_delta.text_color
				local flag

				flag = not (arg_3_3.delta_dir <= 0) or not 255 or 200
				text_color[2] = flag
			end,
			update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
				-- function 4
				local num = 1 - (1 - arg_4_3)^2
				local lerp = math.lerp
				local from_coin_count = arg_4_4.from_coin_count

				from_coin_count = from_coin_count or 0

				local to_coin_count = arg_4_4.to_coin_count

				to_coin_count = to_coin_count or 100

				local var_4_4 = lerp(from_coin_count, to_coin_count, num)

				arg_4_2.content.coin_count_text = string.format("%d", var_4_4)
			end,
			on_complete = NOP
		},
		{
			name = "delta",
			duration = 2,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				arg_5_3.delta_dir = math.sign(arg_5_3.coin_delta)
				arg_5_2.content.coin_delta = string.format("%+d", arg_5_3.coin_delta)
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				local coin_delta = arg_6_2.style.coin_delta

				coin_delta.offset[2] = coin_delta.base_offset[2] + arg_6_4.delta_dir * (arg_6_3 - 0.5) * 40
				coin_delta.text_color[1] = math.clamp(255 * (1 - arg_6_3) / 0.8, 0, 255)
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				arg_7_2.style.coin_delta.text_color[1] = 0
			end
		},
		{
			name = "grow",
			delay = 0.2,
			duration = 0.2,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				arg_8_3.icon_size_x = arg_8_2.style.coin_icon.texture_size[1]
				arg_8_3.icon_size_y = arg_8_2.style.coin_icon.texture_size[2]
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				-- function 9
				local num = 1 + 0.5 * (1 - (1 - arg_9_3) * (1 - arg_9_3))
				local style = arg_9_2.style
				local coin_count = style.coin_count
				local coin_icon = style.coin_icon
				local coin_icon_mask = style.coin_icon_mask
				local coin_icon_bloom = style.coin_icon_bloom
				local num_2 = num * arg_9_4.icon_size_x
				local num_3 = num * arg_9_4.icon_size_y

				coin_icon.texture_size[1] = num_2
				coin_icon.texture_size[2] = num_3
				coin_icon_mask.texture_size[1] = num_2
				coin_icon_mask.texture_size[2] = num_3
				coin_icon_bloom.texture_size[1] = num * coin_icon_bloom.base_texture_size[1]
				coin_icon_bloom.texture_size[2] = num * coin_icon_bloom.base_texture_size[2]
			end,
			on_complete = NOP
		},
		{
			name = "shrink",
			delay = 0.4,
			duration = 0.4,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				arg_10_3.icon_size_x = arg_10_2.style.coin_icon.texture_size[1]
				arg_10_3.icon_size_y = arg_10_2.style.coin_icon.texture_size[2]
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local num = 1 + 0.5 * (1 - arg_11_3 * arg_11_3)
				local style = arg_11_2.style
				local coin_count = style.coin_count
				local coin_icon = style.coin_icon
				local coin_icon_mask = style.coin_icon_mask
				local coin_icon_bloom = style.coin_icon_bloom
				local num_2 = num * arg_11_4.icon_size_x
				local num_3 = num * arg_11_4.icon_size_y

				coin_icon.texture_size[1] = num_2
				coin_icon.texture_size[2] = num_3
				coin_icon_mask.texture_size[1] = num_2
				coin_icon_mask.texture_size[2] = num_3
				coin_icon_bloom.texture_size[1] = num * coin_icon_bloom.base_texture_size[1]
				coin_icon_bloom.texture_size[2] = num * coin_icon_bloom.base_texture_size[2]
			end,
			on_complete = NOP
		},
		{
			name = "background_glow",
			delay = 0,
			duration = 0.8,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				return
			end,
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				-- function 13
				local num = 4 * arg_13_3 * (1 - arg_13_3)

				arg_13_2.style.background_glow.color[1] = 96 * num
			end,
			on_complete = NOP
		},
		{
			name = "glow",
			delay = 0.3,
			duration = 0.4,
			init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				return
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				-- function 15
				local num = 4 * arg_15_3 * (1 - arg_15_3)

				arg_15_2.style.coin_icon_highlight.color[1] = 0
				arg_15_2.style.coin_icon_bloom.color[1] = 127 * num
			end,
			on_complete = NOP
		},
		{
			name = "reflection",
			delay = 0.5,
			duration = 0.5,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				return
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				local coin_icon_fx = arg_17_2.style.coin_icon_fx

				coin_icon_fx.offset[1] = coin_icon_fx.base_offset[1] + (2 * arg_17_3 - 1) * coin_icon_fx.texture_size[1]
				coin_icon_fx.color[1] = 255
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				arg_18_2.style.coin_icon_fx.color[1] = 0
			end
		}
	}
}

return {
	scenegraph_definition = tbl_2,
	coin_widget_definition = fn(),
	animation_definitions = tbl_3
}
