-- chunkname: @scripts/ui/views/skip_input_ui_definitions.lua

local var_0_0 = {
	1920,
	1080
}
local var_0_1 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.popup
		},
		size = var_0_0
	},
	screen = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			0,
			0,
			0
		},
		size = var_0_0
	},
	skip_input = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		position = {
			20,
			20,
			1
		}
	}
}
local var_0_2 = {
	vertical_alignment = "bottom",
	dynamic_font = true,
	font_size = 36,
	horizontal_alignment = "left",
	pixel_perfect = true,
	font_type = "hell_shark",
	word_wrap = false,
	text_color = Colors.get_color_table_with_alpha("white", 255)
}

local function var_0_3(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = true
	local var_1_1, var_1_2, var_1_3, var_1_4 = UISettings.get_gamepad_input_texture_data(arg_1_2, "cancel_video_1", var_1_0)
	local var_1_5, var_1_6, var_1_7, var_1_8 = UISettings.get_gamepad_input_texture_data(arg_1_2, "cancel_video_1", not var_1_0)
	local var_1_9 = Localize("input_hold")
	local var_1_10 = Localize("to_skip")
	local var_1_11, var_1_12 = UIFontByResolution(var_0_2)
	local var_1_13, var_1_14, var_1_15 = UIRenderer.text_size(arg_1_1, var_1_9, var_1_11[1], var_1_12)
	local var_1_16 = var_1_13 + 10
	local var_1_17 = var_1_16 + var_1_1.size[1] + 10
	local var_1_18, var_1_19, var_1_20 = UIRenderer.text_size(arg_1_1, var_1_6, var_1_11[1], var_1_12)
	local var_1_21 = var_1_16 + var_1_5[1].size[1]
	local var_1_22 = var_1_21 + var_1_18
	local var_1_23 = var_1_22 + var_1_5[3].size[1] + 10

	return {
		scenegraph_id = "skip_input",
		element = {
			passes = {
				{
					style_id = "input_text_1",
					pass_type = "text",
					text_id = "input_text_1",
					content_change_function = function (arg_2_0, arg_2_1)
						arg_2_0.gamepad_active = Managers.input:is_device_active("gamepad")

						local var_2_0 = 2
						local var_2_1, var_2_2 = Managers.time:time_and_delta("main")
						local var_2_3 = arg_1_2:get("cancel_video")
						local var_2_4 = var_2_3 and 1 or -1

						arg_2_0.progress = math.clamp(arg_2_0.progress + var_2_2 * var_2_0 * var_2_4, 0, 1)

						if var_2_3 ~= arg_2_0.input and var_2_3 then
							arg_2_0.progress = UISettings.double_click_threshold * 2 >= math.abs(arg_2_0.input_time - var_2_1) and 1 or arg_2_0.progress
							arg_2_0.input_time = var_2_1
						end

						arg_2_0.input = var_2_3

						if arg_2_0.progress >= 1 then
							arg_1_0:skip()
						end
					end
				},
				{
					style_id = "gamepad_input_text_2",
					pass_type = "text",
					text_id = "input_text_2",
					content_check_function = function (arg_3_0)
						return arg_3_0.gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "gamepad_input_icon",
					texture_id = "gamepad_input_icon",
					content_check_function = function (arg_4_0)
						return arg_4_0.gamepad_input_icon and arg_4_0.gamepad_active
					end
				},
				{
					style_id = "kbm_input_text_2",
					pass_type = "text",
					text_id = "input_text_2",
					content_check_function = function (arg_5_0)
						return not arg_5_0.gamepad_active
					end
				},
				{
					style_id = "kbm_input_text",
					pass_type = "text",
					text_id = "kbm_input_text",
					content_check_function = function (arg_6_0)
						return not arg_6_0.gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "kbm_input_icon_left",
					texture_id = "kbm_input_icon_left",
					content_check_function = function (arg_7_0)
						return arg_7_0.kbm_input_icon_left and not arg_7_0.gamepad_active
					end
				},
				{
					pass_type = "tiled_texture",
					style_id = "kbm_input_icon_middle",
					texture_id = "kbm_input_icon_middle",
					content_check_function = function (arg_8_0)
						return arg_8_0.kbm_input_icon_middle and not arg_8_0.gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "kbm_input_icon_right",
					texture_id = "kbm_input_icon_right",
					content_check_function = function (arg_9_0)
						return arg_9_0.kbm_input_icon_right and not arg_9_0.gamepad_active
					end
				},
				{
					style_id = "hold_bar",
					pass_type = "rect",
					content_check_function = function (arg_10_0)
						return not arg_10_0.gamepad_active and arg_10_0.progress > 0
					end,
					content_change_function = function (arg_11_0, arg_11_1)
						arg_11_1.size[1] = arg_11_0.progress * (var_1_18 + var_1_5[1].size[1] + var_1_5[3].size[1])
					end
				},
				{
					style_id = "hold_bar_bg",
					pass_type = "rect",
					content_check_function = function (arg_12_0)
						return not arg_12_0.gamepad_active and arg_12_0.progress > 0
					end,
					content_change_function = function (arg_13_0, arg_13_1)
						arg_13_1.size[1] = arg_13_0.progress * (var_1_18 + var_1_5[1].size[1] + var_1_5[3].size[1]) + 4
					end
				},
				{
					style_id = "input_icon_bar",
					texture_id = "input_icon_bar",
					pass_type = "gradient_mask_texture",
					content_check_function = function (arg_14_0)
						return arg_14_0.gamepad_active and arg_14_0.gamepad_input_icon
					end,
					content_change_function = function (arg_15_0, arg_15_1)
						arg_15_1.gradient_threshold = arg_15_0.progress
					end
				}
			}
		},
		content = {
			input_time = 0,
			progress = 0,
			input_icon_bar = "controller_hold_bar",
			input_text_1 = var_1_9,
			input_text_2 = var_1_10,
			gamepad_input_icon = var_1_1.texture,
			kbm_input_text = var_1_6,
			kbm_input_icon_left = var_1_5[1].texture,
			kbm_input_icon_middle = var_1_5[2].texture,
			kbm_input_icon_right = var_1_5[3].texture,
			parent = arg_1_0
		},
		style = {
			hold_bar = {
				color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					var_1_16,
					-10,
					1
				},
				size = {
					0,
					8
				}
			},
			hold_bar_bg = {
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					var_1_16 - 2,
					-12,
					0
				},
				size = {
					0,
					12
				}
			},
			gamepad_input_icon = {
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = var_1_1.size,
				offset = {
					var_1_16,
					5,
					1
				}
			},
			input_icon_bar = {
				gradient_threshold = 0,
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					var_1_1.size[1] + 4,
					var_1_1.size[1] + 4
				},
				offset = {
					var_1_16 - 2,
					3,
					0
				}
			},
			input_text_1 = var_0_2,
			gamepad_input_text_2 = {
				word_wrap = var_0_2.word_wrap,
				dynamic_font = var_0_2.dynamic_font,
				pixel_perfect = var_0_2.pixel_perfect,
				text_color = var_0_2.text_color,
				font_type = var_0_2.font_type,
				font_size = var_0_2.font_size,
				horizontal_alignment = var_0_2.horizontal_alignment,
				vertical_alignment = var_0_2.vertical_alignment,
				offset = {
					var_1_17,
					0,
					0
				}
			},
			kbm_input_text = {
				word_wrap = var_0_2.word_wrap,
				dynamic_font = var_0_2.dynamic_font,
				pixel_perfect = var_0_2.pixel_perfect,
				text_color = var_0_2.text_color,
				font_type = var_0_2.font_type,
				font_size = var_0_2.font_size,
				horizontal_alignment = var_0_2.horizontal_alignment,
				vertical_alignment = var_0_2.vertical_alignment,
				offset = {
					var_1_21,
					0,
					2
				}
			},
			kbm_input_icon_left = {
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = var_1_5[1].size,
				offset = {
					var_1_16,
					5,
					1
				}
			},
			kbm_input_icon_middle = {
				color = {
					255,
					255,
					255,
					255
				},
				texture_tiling_size = var_1_5[2].size,
				texture_size = {
					var_1_18,
					var_1_5[2].size[2]
				},
				offset = {
					var_1_21,
					5,
					1
				}
			},
			kbm_input_icon_right = {
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = var_1_5[3].size,
				offset = {
					var_1_22,
					5,
					1
				}
			},
			kbm_input_text_2 = {
				word_wrap = var_0_2.word_wrap,
				dynamic_font = var_0_2.dynamic_font,
				pixel_perfect = var_0_2.pixel_perfect,
				text_color = var_0_2.text_color,
				font_type = var_0_2.font_type,
				font_size = var_0_2.font_size,
				horizontal_alignment = var_0_2.horizontal_alignment,
				vertical_alignment = var_0_2.vertical_alignment,
				offset = {
					var_1_23,
					0,
					0
				}
			}
		}
	}
end

return {
	create_skip_widget = var_0_3,
	scenegraph_definition = var_0_1
}
