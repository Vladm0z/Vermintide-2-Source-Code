-- chunkname: @scripts/ui/views/end_screen_ui_definitions.lua

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
	}
}
local tbl_2 = {
	background_rect = {
		scenegraph_id = "screen",
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "rect"
				}
			}
		},
		content = {},
		style = {
			rect = {
				color = {
					0,
					0,
					0,
					0
				}
			}
		}
	}
}
local tbl_3 = {
	fade_in_background = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.2,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				arg_1_3.draw_background = Managers.mechanism:current_mechanism_name() ~= "versus"
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeOutCubic = math.easeOutCubic(arg_2_3)

				arg_2_2[1].style.rect.color[1] = 255 * easeOutCubic
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		}
	},
	fade_out_background = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeOutCubic = math.easeOutCubic(arg_5_3)

				arg_5_2[1].style.rect.color[1] = 255 - easeOutCubic * 255
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				arg_6_3.draw_background = false
			end
		}
	},
	auto_display_text = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				arg_8_4.draw_flags.draw_text = true

				local easeOutCubic = math.easeOutCubic(arg_8_3)
				local var_8_1 = arg_8_2[1]

				var_8_1.style.banner_effect_texture.color[1] = easeOutCubic * 255
				var_8_1.style.banner_texture.color[1] = easeOutCubic * 255
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 4,
			end_progress = 4.5,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local easeOutCubic = math.easeOutCubic(arg_11_3)
				local var_11_1 = arg_11_2[1]

				var_11_1.style.banner_effect_texture.color[1] = (1 - easeOutCubic) * 255
				var_11_1.style.banner_texture.color[1] = (1 - easeOutCubic) * 255
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				arg_12_3.draw_text = false
			end
		}
	}
}
local tbl_4 = {
	victory = {
		file_name = "scripts/ui/views/end_screens/victory_end_screen_ui",
		class_name = "VictoryEndScreenUI"
	},
	defeat = {
		file_name = "scripts/ui/views/end_screens/defeat_end_screen_ui",
		class_name = "DefeatEndScreenUI"
	},
	draw = {
		file_name = "scripts/ui/views/end_screens/draw_end_screen_ui",
		class_name = "DrawEndScreenUI"
	},
	none = {
		file_name = "scripts/ui/views/end_screens/none_end_screen_ui",
		class_name = "NoneEndScreenUI"
	}
}

DLCUtils.merge("ui_end_screens", tbl_4)

for k, v in pairs(tbl_4) do
	fassert(v.file_name, "end screen (%s) needs a file name", k)
	fassert(v.class_name, "end screen (%s) needs a class name", k)
end

return {
	scenegraph_definition = tbl,
	widgets = tbl_2,
	animations = tbl_3,
	screens = tbl_4
}
