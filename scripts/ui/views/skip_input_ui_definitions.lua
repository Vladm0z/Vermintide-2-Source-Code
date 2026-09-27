-- chunkname: @scripts/ui/views/skip_input_ui_definitions.lua

local tbl = {
	1920,
	1080
}
local tbl_2 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.popup
		},
		size = tbl
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
		size = tbl
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
local tbl_3 = {
	vertical_alignment = "bottom",
	dynamic_font = true,
	font_size = 36,
	horizontal_alignment = "left",
	pixel_perfect = true,
	font_type = "hell_shark",
	word_wrap = false,
	text_color = Colors.get_color_table_with_alpha("white", 255)
}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local flag = true
	local get_gamepad_input_texture_data, var_1_2, var_1_3, var_1_4 = UISettings.get_gamepad_input_texture_data(arg_1_2, "cancel_video_1", flag)
	local get_gamepad_input_texture_data_2, var_1_6, var_1_7, var_1_8 = UISettings.get_gamepad_input_texture_data(arg_1_2, "cancel_video_1", not flag)
	local var_1_9 = Localize("input_hold")
	local var_1_10 = Localize("to_skip")
	local var_1_11, var_1_12 = UIFontByResolution(tbl_3)
	local text_size, var_1_14, var_1_15 = UIRenderer.text_size(arg_1_1, var_1_9, var_1_11[1], var_1_12)
	local num = text_size + 10
	local num_2 = num + get_gamepad_input_texture_data.size[1] + 10
	local text_size_2, var_1_19, var_1_20 = UIRenderer.text_size(arg_1_1, var_1_6, var_1_11[1], var_1_12)
	local num_3 = num + get_gamepad_input_texture_data_2[1].size[1]
	local num_4 = num_3 + text_size_2
	local num_5 = num_4 + get_gamepad_input_texture_data_2[3].size[1] + 10

	return {
		scenegraph_id = "skip_input",
		element = {
			passes = {
				{
					style_id = "input_text_1",
					pass_type = "text",
					text_id = "input_text_1",
					content_change_function = function (self, arg_2_1)
						-- function 2
						self.gamepad_active = Managers.input:is_device_active("gamepad")

						local num = 2
						local time_and_delta, var_2_2 = Managers.time:time_and_delta("main")
						local get = arg_1_2:get("cancel_video")
						local flag

						flag = not get and 1 and -1
						self.progress = math.clamp(self.progress + var_2_2 * num * flag, 0, 1)

						if get == self.input or not get then
							local flag_2

							flag_2 = not (UISettings.double_click_threshold * 2 >= math.abs(self.input_time - time_and_delta)) or not 1 or self.progress
							self.progress = flag_2
							self.input_time = time_and_delta
						end

						self.input = get

						if self.progress >= 1 then
							arg_1_0:skip()
						end
					end
				},
				{
					style_id = "gamepad_input_text_2",
					pass_type = "text",
					text_id = "input_text_2",
					content_check_function = function (self)
						-- function 3
						return self.gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "gamepad_input_icon",
					texture_id = "gamepad_input_icon",
					content_check_function = function (self)
						-- function 4
						local gamepad_input_icon = self.gamepad_input_icon

						gamepad_input_icon = not gamepad_input_icon and self.gamepad_active

						return gamepad_input_icon
					end
				},
				{
					style_id = "kbm_input_text_2",
					pass_type = "text",
					text_id = "input_text_2",
					content_check_function = function (self)
						-- function 5
						return not self.gamepad_active
					end
				},
				{
					style_id = "kbm_input_text",
					pass_type = "text",
					text_id = "kbm_input_text",
					content_check_function = function (self)
						-- function 6
						return not self.gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "kbm_input_icon_left",
					texture_id = "kbm_input_icon_left",
					content_check_function = function (self)
						-- function 7
						local kbm_input_icon_left = self.kbm_input_icon_left

						kbm_input_icon_left = not kbm_input_icon_left and not self.gamepad_active

						return kbm_input_icon_left
					end
				},
				{
					pass_type = "tiled_texture",
					style_id = "kbm_input_icon_middle",
					texture_id = "kbm_input_icon_middle",
					content_check_function = function (self)
						-- function 8
						local kbm_input_icon_middle = self.kbm_input_icon_middle

						kbm_input_icon_middle = not kbm_input_icon_middle and not self.gamepad_active

						return kbm_input_icon_middle
					end
				},
				{
					pass_type = "texture",
					style_id = "kbm_input_icon_right",
					texture_id = "kbm_input_icon_right",
					content_check_function = function (self)
						-- function 9
						local kbm_input_icon_right = self.kbm_input_icon_right

						kbm_input_icon_right = not kbm_input_icon_right and not self.gamepad_active

						return kbm_input_icon_right
					end
				},
				{
					style_id = "hold_bar",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 10
						return not not self.gamepad_active or self.progress > 0
					end,
					content_change_function = function (self, arg_11_1)
						-- function 11
						arg_11_1.size[1] = self.progress * (text_size_2 + get_gamepad_input_texture_data_2[1].size[1] + get_gamepad_input_texture_data_2[3].size[1])
					end
				},
				{
					style_id = "hold_bar_bg",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 12
						return not not self.gamepad_active or self.progress > 0
					end,
					content_change_function = function (self, arg_13_1)
						-- function 13
						arg_13_1.size[1] = self.progress * (text_size_2 + get_gamepad_input_texture_data_2[1].size[1] + get_gamepad_input_texture_data_2[3].size[1]) + 4
					end
				},
				{
					style_id = "input_icon_bar",
					texture_id = "input_icon_bar",
					pass_type = "gradient_mask_texture",
					content_check_function = function (self)
						-- function 14
						local gamepad_active = self.gamepad_active

						gamepad_active = not gamepad_active and self.gamepad_input_icon

						return gamepad_active
					end,
					content_change_function = function (self, arg_15_1)
						-- function 15
						arg_15_1.gradient_threshold = self.progress
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
			gamepad_input_icon = get_gamepad_input_texture_data.texture,
			kbm_input_text = var_1_6,
			kbm_input_icon_left = get_gamepad_input_texture_data_2[1].texture,
			kbm_input_icon_middle = get_gamepad_input_texture_data_2[2].texture,
			kbm_input_icon_right = get_gamepad_input_texture_data_2[3].texture,
			parent = arg_1_0
		},
		style = {
			hold_bar = {
				color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					num,
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
					num - 2,
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
				texture_size = get_gamepad_input_texture_data.size,
				offset = {
					num,
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
					get_gamepad_input_texture_data.size[1] + 4,
					get_gamepad_input_texture_data.size[1] + 4
				},
				offset = {
					num - 2,
					3,
					0
				}
			},
			input_text_1 = tbl_3,
			gamepad_input_text_2 = {
				word_wrap = tbl_3.word_wrap,
				dynamic_font = tbl_3.dynamic_font,
				pixel_perfect = tbl_3.pixel_perfect,
				text_color = tbl_3.text_color,
				font_type = tbl_3.font_type,
				font_size = tbl_3.font_size,
				horizontal_alignment = tbl_3.horizontal_alignment,
				vertical_alignment = tbl_3.vertical_alignment,
				offset = {
					num_2,
					0,
					0
				}
			},
			kbm_input_text = {
				word_wrap = tbl_3.word_wrap,
				dynamic_font = tbl_3.dynamic_font,
				pixel_perfect = tbl_3.pixel_perfect,
				text_color = tbl_3.text_color,
				font_type = tbl_3.font_type,
				font_size = tbl_3.font_size,
				horizontal_alignment = tbl_3.horizontal_alignment,
				vertical_alignment = tbl_3.vertical_alignment,
				offset = {
					num_3,
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
				texture_size = get_gamepad_input_texture_data_2[1].size,
				offset = {
					num,
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
				texture_tiling_size = get_gamepad_input_texture_data_2[2].size,
				texture_size = {
					text_size_2,
					get_gamepad_input_texture_data_2[2].size[2]
				},
				offset = {
					num_3,
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
				texture_size = get_gamepad_input_texture_data_2[3].size,
				offset = {
					num_4,
					5,
					1
				}
			},
			kbm_input_text_2 = {
				word_wrap = tbl_3.word_wrap,
				dynamic_font = tbl_3.dynamic_font,
				pixel_perfect = tbl_3.pixel_perfect,
				text_color = tbl_3.text_color,
				font_type = tbl_3.font_type,
				font_size = tbl_3.font_size,
				horizontal_alignment = tbl_3.horizontal_alignment,
				vertical_alignment = tbl_3.vertical_alignment,
				offset = {
					num_5,
					0,
					0
				}
			}
		}
	}
end

return {
	create_skip_widget = fn,
	scenegraph_definition = tbl_2
}
