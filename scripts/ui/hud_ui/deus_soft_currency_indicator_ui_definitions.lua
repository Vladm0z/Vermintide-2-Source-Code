-- chunkname: @scripts/ui/hud_ui/deus_soft_currency_indicator_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = 1
local var_0_3 = {
	325 * var_0_2,
	50 * var_0_2
}
local var_0_4 = {
	screen = {
		scale = "fit",
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
	coin_ui = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			0,
			-25,
			0
		},
		size = var_0_3
	}
}

local function var_0_5()
	local var_1_0 = "weaves_essence_bar_backdrop"
	local var_1_1 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_0)
	local var_1_2 = var_1_1.size[2] * 0.5
	local var_1_3 = var_1_1.size[1] * 0.5
	local var_1_4 = -2
	local var_1_5 = {
		var_1_2,
		var_1_2
	}

	return {
		scenegraph_id = "coin_ui",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background",
					content_check_function = function(arg_2_0)
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
			background = var_1_0
		},
		style = {
			background = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = var_1_1.size,
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
				texture_size = var_1_1.size,
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
					var_1_5[1],
					var_1_5[2]
				},
				base_size = {
					var_1_5[1],
					var_1_5[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_1_3 - 155,
					var_1_4,
					10
				}
			},
			coin_icon_mask = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					var_1_5[1],
					var_1_5[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_1_3 - 155,
					var_1_4,
					11
				}
			},
			coin_icon_fx = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					var_1_5[1],
					var_1_5[2]
				},
				color = {
					0,
					255,
					255,
					255
				},
				base_offset = {
					var_1_3 - 155,
					var_1_4,
					12
				},
				offset = {
					var_1_3 - 155,
					var_1_4,
					11
				}
			},
			coin_icon_highlight = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					var_1_5[1] * 2,
					var_1_5[2] * 2
				},
				color = {
					0,
					74,
					243,
					255
				},
				offset = {
					var_1_3 - 155,
					var_1_4,
					13
				}
			},
			coin_icon_bloom = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					var_1_5[1] * 1.75,
					var_1_5[2] * 1.75
				},
				base_texture_size = {
					var_1_5[1] * 1.75,
					var_1_5[2] * 1.75
				},
				color = {
					0,
					74,
					243,
					255
				},
				offset = {
					var_1_3 - 155,
					var_1_4,
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
					var_0_3[1] - 80,
					var_0_3[2]
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
					var_0_3[1] - 80,
					var_0_3[2]
				}
			},
			coin_count = {
				word_wrap = false,
				upper_case = false,
				localize = false,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				base_font_size = var_1_2,
				font_size = var_1_2,
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_1_3 + var_1_5[1] + 5,
					var_1_4 - 2,
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
				font_size = var_1_2,
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					var_1_3 + var_1_5[1] + 5 - 2,
					var_1_4 - 2 - 2,
					0
				}
			},
			coin_delta = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				localize = false,
				font_type = "hell_shark_header",
				font_size = var_1_2,
				text_color = {
					255,
					200,
					200,
					200
				},
				base_offset = {
					var_1_3 + var_1_5[1] + 5 - 2 + 60,
					var_1_4 - 2 - 2,
					3
				},
				offset = {
					var_1_3 + var_1_5[1] + 5 - 2 + 60,
					var_1_4 - 2 - 2,
					3
				}
			}
		}
	}
end

local var_0_6 = {
	coin_change = {
		{
			name = "count",
			duration = 1.2,
			init = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				arg_3_2.content.coin_delta = string.format("%+d", arg_3_3.coin_delta)
				arg_3_3.delta_dir = math.sign(arg_3_3.coin_delta)
				arg_3_2.style.coin_delta.text_color[2] = arg_3_3.delta_dir <= 0 and 255 or 200
			end,
			update = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
				local var_4_0 = 1 - (1 - arg_4_3)^2
				local var_4_1 = math.lerp(arg_4_4.from_coin_count or 0, arg_4_4.to_coin_count or 100, var_4_0)

				arg_4_2.content.coin_count_text = string.format("%d", var_4_1)
			end,
			on_complete = NOP
		},
		{
			name = "delta",
			duration = 2,
			init = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				arg_5_3.delta_dir = math.sign(arg_5_3.coin_delta)
				arg_5_2.content.coin_delta = string.format("%+d", arg_5_3.coin_delta)
			end,
			update = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = arg_6_2.style.coin_delta

				var_6_0.offset[2] = var_6_0.base_offset[2] + arg_6_4.delta_dir * (arg_6_3 - 0.5) * 40
				var_6_0.text_color[1] = math.clamp(255 * (1 - arg_6_3) / 0.8, 0, 255)
			end,
			on_complete = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				arg_7_2.style.coin_delta.text_color[1] = 0
			end
		},
		{
			name = "grow",
			delay = 0.2,
			duration = 0.2,
			init = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				arg_8_3.icon_size_x = arg_8_2.style.coin_icon.texture_size[1]
				arg_8_3.icon_size_y = arg_8_2.style.coin_icon.texture_size[2]
			end,
			update = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				local var_9_0 = 1 + 0.5 * (1 - (1 - arg_9_3) * (1 - arg_9_3))
				local var_9_1 = arg_9_2.style
				local var_9_2 = var_9_1.coin_count
				local var_9_3 = var_9_1.coin_icon
				local var_9_4 = var_9_1.coin_icon_mask
				local var_9_5 = var_9_1.coin_icon_bloom
				local var_9_6 = var_9_0 * arg_9_4.icon_size_x
				local var_9_7 = var_9_0 * arg_9_4.icon_size_y

				var_9_3.texture_size[1] = var_9_6
				var_9_3.texture_size[2] = var_9_7
				var_9_4.texture_size[1] = var_9_6
				var_9_4.texture_size[2] = var_9_7
				var_9_5.texture_size[1] = var_9_0 * var_9_5.base_texture_size[1]
				var_9_5.texture_size[2] = var_9_0 * var_9_5.base_texture_size[2]
			end,
			on_complete = NOP
		},
		{
			name = "shrink",
			delay = 0.4,
			duration = 0.4,
			init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				arg_10_3.icon_size_x = arg_10_2.style.coin_icon.texture_size[1]
				arg_10_3.icon_size_y = arg_10_2.style.coin_icon.texture_size[2]
			end,
			update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				local var_11_0 = 1 + 0.5 * (1 - arg_11_3 * arg_11_3)
				local var_11_1 = arg_11_2.style
				local var_11_2 = var_11_1.coin_count
				local var_11_3 = var_11_1.coin_icon
				local var_11_4 = var_11_1.coin_icon_mask
				local var_11_5 = var_11_1.coin_icon_bloom
				local var_11_6 = var_11_0 * arg_11_4.icon_size_x
				local var_11_7 = var_11_0 * arg_11_4.icon_size_y

				var_11_3.texture_size[1] = var_11_6
				var_11_3.texture_size[2] = var_11_7
				var_11_4.texture_size[1] = var_11_6
				var_11_4.texture_size[2] = var_11_7
				var_11_5.texture_size[1] = var_11_0 * var_11_5.base_texture_size[1]
				var_11_5.texture_size[2] = var_11_0 * var_11_5.base_texture_size[2]
			end,
			on_complete = NOP
		},
		{
			name = "background_glow",
			delay = 0,
			duration = 0.8,
			init = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end,
			update = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				local var_13_0 = 4 * arg_13_3 * (1 - arg_13_3)

				arg_13_2.style.background_glow.color[1] = 96 * var_13_0
			end,
			on_complete = NOP
		},
		{
			name = "glow",
			delay = 0.3,
			duration = 0.4,
			init = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				return
			end,
			update = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				local var_15_0 = 4 * arg_15_3 * (1 - arg_15_3)

				arg_15_2.style.coin_icon_highlight.color[1] = 0
				arg_15_2.style.coin_icon_bloom.color[1] = 127 * var_15_0
			end,
			on_complete = NOP
		},
		{
			name = "reflection",
			delay = 0.5,
			duration = 0.5,
			init = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end,
			update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				local var_17_0 = arg_17_2.style.coin_icon_fx

				var_17_0.offset[1] = var_17_0.base_offset[1] + (2 * arg_17_3 - 1) * var_17_0.texture_size[1]
				var_17_0.color[1] = 255
			end,
			on_complete = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				arg_18_2.style.coin_icon_fx.color[1] = 0
			end
		}
	}
}

return {
	scenegraph_definition = var_0_4,
	coin_widget_definition = var_0_5(),
	animation_definitions = var_0_6
}
