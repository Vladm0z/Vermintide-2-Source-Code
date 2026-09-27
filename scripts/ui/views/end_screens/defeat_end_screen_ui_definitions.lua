-- chunkname: @scripts/ui/views/end_screens/defeat_end_screen_ui_definitions.lua

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
	end_screen_banner_defeat = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			680,
			240
		}
	},
	defeat_effect_1 = {
		vertical_alignment = "center",
		parent = "end_screen_banner_defeat",
		horizontal_alignment = "center",
		position = {
			50,
			-100,
			-2
		},
		size = {
			1080,
			600
		}
	},
	defeat_effect_2 = {
		vertical_alignment = "center",
		parent = "end_screen_banner_defeat",
		horizontal_alignment = "center",
		position = {
			-50,
			-200,
			-1
		},
		size = {
			230,
			400
		}
	},
	title_text_defeat = {
		vertical_alignment = "top",
		parent = "end_screen_banner_defeat",
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
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_3 = {
	title_text = UIWidgets.create_simple_text(Localize("end_screen_loss"), "title_text_defeat", nil, nil, tbl_2),
	banner = UIWidgets.create_simple_texture("end_screen_banner_defeat", "end_screen_banner_defeat"),
	effect_1 = UIWidgets.create_simple_texture("end_screen_effect_defeat_1", "defeat_effect_1"),
	effect_2 = UIWidgets.create_simple_texture("end_screen_effect_defeat_2", "defeat_effect_2")
}
local tbl_4 = {
	defeat = {
		{
			name = "entry",
			start_progress = 1.4,
			end_progress = 1.8,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				arg_1_2.banner.style.texture_id.color[1] = 0
				arg_1_2.effect_1.style.texture_id.color[1] = 0
				arg_1_2.effect_2.style.texture_id.color[1] = 0
				arg_1_2.title_text.style.text.text_color[1] = 0
				arg_1_2.title_text.style.text_shadow.text_color[1] = 0
				arg_1_3.draw_flags.alpha_multiplier = 1
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeCubic = math.easeCubic(arg_2_3)
				local easeCubic_2 = math.easeCubic(1 - arg_2_3)
				local catmullrom = math.catmullrom(easeCubic_2, 1.8, 0, 1, -1)

				arg_2_2.banner.style.texture_id.color[1] = 255 * easeCubic

				local size = arg_2_1.end_screen_banner_defeat.size

				arg_2_0.end_screen_banner_defeat.size[1] = size[1] + size[1] * 3 * catmullrom
				arg_2_0.end_screen_banner_defeat.size[2] = size[2] + size[2] * 3 * catmullrom
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		},
		{
			name = "text",
			start_progress = 1.8,
			end_progress = 2.2,
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
			name = "effect_1",
			start_progress = 1,
			end_progress = 1.5,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local num = 255 * math.easeCubic(arg_8_3)

				arg_8_2.effect_1.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		},
		{
			name = "effect_2",
			start_progress = 1.7,
			end_progress = 3,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local num = 255 * math.ease_out_quad(arg_11_3)

				arg_11_2.effect_2.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 6,
			end_progress = 6.5,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				local easeInCubic = math.easeInCubic(arg_14_3)

				arg_14_4.draw_flags.alpha_multiplier = 1 - easeInCubic
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
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
