-- chunkname: @scripts/ui/views/end_screens/victory_end_screen_ui_definitions.lua

local var_0_0 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.end_screen_banner
		},
		size = {
			1920,
			1080
		}
	},
	end_screen_banner_victory = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			50,
			2
		},
		size = {
			680,
			240
		}
	},
	victory_effect_1 = {
		vertical_alignment = "center",
		parent = "end_screen_banner_victory",
		horizontal_alignment = "center",
		position = {
			4,
			90,
			1
		},
		size = {
			900,
			530
		}
	},
	victory_effect_2 = {
		vertical_alignment = "center",
		parent = "end_screen_banner_victory",
		horizontal_alignment = "center",
		position = {
			4,
			90,
			2
		},
		size = {
			900,
			530
		}
	},
	victory_effect_shine_1 = {
		vertical_alignment = "center",
		parent = "end_screen_banner_victory",
		horizontal_alignment = "center",
		position = {
			46,
			28,
			5
		},
		size = {
			256,
			256
		}
	},
	victory_effect_shine_2 = {
		vertical_alignment = "center",
		parent = "end_screen_banner_victory",
		horizontal_alignment = "center",
		position = {
			-190,
			84,
			5
		},
		size = {
			200,
			200
		}
	},
	title_text_victory = {
		vertical_alignment = "top",
		parent = "end_screen_banner_victory",
		horizontal_alignment = "center",
		position = {
			0,
			90,
			3
		},
		size = {
			1200,
			100
		}
	}
}
local var_0_1 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 100,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_2 = {
	title_text = UIWidgets.create_simple_text(Localize("end_screen_win"), "title_text_victory", nil, nil, var_0_1),
	banner = UIWidgets.create_simple_texture("end_screen_banner_victory", "end_screen_banner_victory"),
	effect_1 = UIWidgets.create_simple_texture("end_screen_effect_victory_1", "victory_effect_1"),
	effect_2 = UIWidgets.create_simple_texture("end_screen_effect_victory_2", "victory_effect_2"),
	shine_1 = UIWidgets.create_simple_rotated_texture("sparkle_effect", 0, {
		128,
		128
	}, "victory_effect_shine_1"),
	shine_2 = UIWidgets.create_simple_rotated_texture("sparkle_effect", math.degrees_to_radians(75), {
		100,
		100
	}, "victory_effect_shine_2")
}
local var_0_3 = {
	victory = {
		{
			name = "entry",
			start_progress = 1,
			end_progress = 1.5,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_2.banner.style.texture_id.color[1] = 0
				arg_1_2.effect_1.style.texture_id.color[1] = 0
				arg_1_2.effect_2.style.texture_id.color[1] = 0
				arg_1_2.title_text.style.text.text_color[1] = 0
				arg_1_2.title_text.style.text_shadow.text_color[1] = 0
				arg_1_2.shine_1.style.texture_id.color[1] = 0
				arg_1_2.shine_2.style.texture_id.color[1] = 0
				arg_1_3.draw_flags.alpha_multiplier = 1
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeInCubic(arg_2_3)
				local var_2_1 = math.easeCubic(1 - arg_2_3)
				local var_2_2 = math.catmullrom(var_2_1, 1.8, 0, 1, -1)

				arg_2_2.banner.style.texture_id.color[1] = 255 * var_2_0

				local var_2_3 = arg_2_1.end_screen_banner_victory.size

				arg_2_0.end_screen_banner_victory.size[1] = var_2_3[1] + var_2_3[1] * 3 * var_2_2
				arg_2_0.end_screen_banner_victory.size[2] = var_2_3[2] + var_2_3[2] * 3 * var_2_2
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		},
		{
			name = "text",
			start_progress = 1.4,
			end_progress = 1.6,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeCubic(arg_5_3)
				local var_5_1 = math.ease_in_exp(1 - arg_5_3)
				local var_5_2 = 255 * var_5_0
				local var_5_3 = arg_5_2.title_text.style.text
				local var_5_4 = arg_5_2.title_text.style.text_shadow

				var_5_3.text_color[1] = var_5_2
				var_5_4.text_color[1] = var_5_2

				local var_5_5 = 100 + 100 * var_5_1

				var_5_3.font_size = var_5_5
				var_5_4.font_size = var_5_5
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		},
		{
			name = "shine_1",
			start_progress = 1.5,
			end_progress = 2.2,
			init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end,
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = math.easeOutCubic(arg_8_3)
				local var_8_1 = 255 * math.ease_pulse(var_8_0)

				arg_8_2.shine_1.style.texture_id.color[1] = var_8_1

				local var_8_2 = 90

				arg_8_2.shine_1.style.texture_id.angle = math.degrees_to_radians(var_8_2 * var_8_0)
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		},
		{
			name = "shine_2",
			start_progress = 1.4,
			end_progress = 1.8,
			init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end,
			update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				local var_11_0 = math.easeOutCubic(arg_11_3)
				local var_11_1 = 255 * math.ease_pulse(var_11_0)

				arg_11_2.shine_2.style.texture_id.color[1] = var_11_1

				local var_11_2 = -90

				arg_11_2.shine_2.style.texture_id.angle = math.degrees_to_radians(75 + var_11_2 * var_11_0)
			end,
			on_complete = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end
		},
		{
			name = "glow",
			start_progress = 1.4,
			end_progress = 2,
			init = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end,
			update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				local var_14_0 = 255 * math.easeOutCubic(arg_14_3)

				arg_14_2.effect_1.style.texture_id.color[1] = var_14_0
				arg_14_2.effect_2.style.texture_id.color[1] = var_14_0
			end,
			on_complete = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 6,
			end_progress = 6.5,
			init = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end,
			update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				local var_17_0 = math.easeInCubic(arg_17_3)

				arg_17_4.draw_flags.alpha_multiplier = 1 - var_17_0
			end,
			on_complete = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end
		}
	}
}

return {
	scenegraph_definition = var_0_0,
	widget_definitions = var_0_2,
	animation_definitions = var_0_3
}
