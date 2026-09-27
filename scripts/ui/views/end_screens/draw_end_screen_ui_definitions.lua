-- chunkname: @scripts/ui/views/end_screens/draw_end_screen_ui_definitions.lua

local tbl = {
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
	end_screen_banner_draw = {
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
	draw_effect_1 = {
		vertical_alignment = "center",
		parent = "end_screen_banner_draw",
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
	draw_effect_2 = {
		vertical_alignment = "center",
		parent = "end_screen_banner_draw",
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
	draw_effect_shine_1 = {
		vertical_alignment = "center",
		parent = "end_screen_banner_draw",
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
	draw_effect_shine_2 = {
		vertical_alignment = "center",
		parent = "end_screen_banner_draw",
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
	title_text_draw = {
		vertical_alignment = "top",
		parent = "end_screen_banner_draw",
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
local tbl_2 = {
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
local tbl_3 = {
	title_text = UIWidgets.create_simple_text(Localize("carousel_draw"), "title_text_draw", nil, nil, tbl_2),
	banner = UIWidgets.create_simple_texture("end_screen_banner_victory", "end_screen_banner_draw"),
	effect_1 = UIWidgets.create_simple_texture("end_screen_effect_draw_1", "draw_effect_1"),
	effect_2 = UIWidgets.create_simple_texture("end_screen_effect_draw_2", "draw_effect_2"),
	shine_1 = UIWidgets.create_simple_rotated_texture("sparkle_effect", 0, {
		128,
		128
	}, "draw_effect_shine_1"),
	shine_2 = UIWidgets.create_simple_rotated_texture("sparkle_effect", math.degrees_to_radians(75), {
		100,
		100
	}, "draw_effect_shine_2")
}
local tbl_4 = {
	draw = {
		{
			name = "entry",
			start_progress = 1,
			end_progress = 1.5,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				arg_1_2.banner.style.texture_id.color[1] = 0
				arg_1_2.effect_1.style.texture_id.color[1] = 0
				arg_1_2.effect_2.style.texture_id.color[1] = 0
				arg_1_2.title_text.style.text.text_color[1] = 0
				arg_1_2.title_text.style.text_shadow.text_color[1] = 0
				arg_1_2.shine_1.style.texture_id.color[1] = 0
				arg_1_2.shine_2.style.texture_id.color[1] = 0
				arg_1_3.draw_flags.alpha_multiplier = 1
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeInCubic = math.easeInCubic(arg_2_3)
				local easeCubic = math.easeCubic(1 - arg_2_3)
				local catmullrom = math.catmullrom(easeCubic, 1.8, 0, 1, -1)

				arg_2_2.banner.style.texture_id.color[1] = 255 * easeInCubic

				local size = arg_2_1.end_screen_banner_draw.size

				arg_2_0.end_screen_banner_draw.size[1] = size[1] + size[1] * 3 * catmullrom
				arg_2_0.end_screen_banner_draw.size[2] = size[2] + size[2] * 3 * catmullrom
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		},
		{
			name = "text",
			start_progress = 1.4,
			end_progress = 1.6,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeCubic = math.easeCubic(arg_5_3)
				local ease_in_exp = math.ease_in_exp(1 - arg_5_3)
				local num = 255 * easeCubic
				local text = arg_5_2.title_text.style.text
				local text_shadow = arg_5_2.title_text.style.text_shadow

				text.text_color[1] = num
				text_shadow.text_color[1] = num

				local num_2 = 100 + 100 * ease_in_exp

				text.font_size = num_2
				text_shadow.font_size = num_2
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		},
		{
			name = "shine_1",
			start_progress = 1.5,
			end_progress = 2.2,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local easeOutCubic = math.easeOutCubic(arg_8_3)
				local num = 255 * math.ease_pulse(easeOutCubic)

				arg_8_2.shine_1.style.texture_id.color[1] = num

				local num_2 = 90

				arg_8_2.shine_1.style.texture_id.angle = math.degrees_to_radians(num_2 * easeOutCubic)
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		},
		{
			name = "shine_2",
			start_progress = 1.4,
			end_progress = 1.8,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local easeOutCubic = math.easeOutCubic(arg_11_3)
				local num = 255 * math.ease_pulse(easeOutCubic)

				arg_11_2.shine_2.style.texture_id.color[1] = num

				local num_2 = -90

				arg_11_2.shine_2.style.texture_id.angle = math.degrees_to_radians(75 + num_2 * easeOutCubic)
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				return
			end
		},
		{
			name = "glow",
			start_progress = 1.4,
			end_progress = 2,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				local num = 255 * math.easeOutCubic(arg_14_3)

				arg_14_2.effect_1.style.texture_id.color[1] = num
				arg_14_2.effect_2.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 6,
			end_progress = 6.5,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				return
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				local easeInCubic = math.easeInCubic(arg_17_3)

				arg_17_4.draw_flags.alpha_multiplier = 1 - easeInCubic
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				return
			end
		}
	}
}

return {
	scenegraph_definition = tbl,
	widget_definitions = tbl_3,
	animation_definitions = tbl_4
}
