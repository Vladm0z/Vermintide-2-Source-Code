-- chunkname: @scripts/ui/views/contract_presentation_screen_ui_definitions.lua

local num = 1920
local num_2 = 1080
local var_0_2
local tbl = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.end_screen + 2
		},
		size = {
			num,
			num_2
		}
	},
	screen = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			num,
			num_2
		}
	},
	pivot = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0.5,
			-300,
			1
		},
		size = {
			0,
			0
		}
	},
	entry_1 = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			899,
			259
		}
	},
	entry_2 = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			899,
			259
		}
	},
	entry_3 = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			899,
			259
		}
	},
	input_description_text = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			80,
			1
		},
		size = {
			1200,
			50
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			-80,
			1
		},
		size = {
			1200,
			50
		}
	}
}

local function fn(arg_1_0)
	-- function 1
	local num = 899
	local num_2 = 259
	local num_3 = 860
	local num_4 = 127

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_bg",
					texture_id = "texture_bg",
					retained_mode = var_0_2
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					retained_mode = var_0_2
				},
				{
					style_id = "bar_text",
					pass_type = "text",
					text_id = "bar_text",
					retained_mode = var_0_2
				},
				{
					style_id = "progress_bar",
					pass_type = "texture_uv",
					content_id = "progress_bar",
					retained_mode = var_0_2
				},
				{
					pass_type = "centered_texture_amount",
					style_id = "texture_divider",
					texture_id = "texture_divider",
					retained_mode = var_0_2,
					content_check_function = function (arg_2_0, arg_2_1)
						-- function 2
						return arg_2_1.texture_amount > 0
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_completed",
					texture_id = "texture_completed",
					retained_mode = var_0_2
				},
				{
					texture_id = "overlay_mask",
					style_id = "overlay",
					pass_type = "texture",
					retained_mode = var_0_2
				},
				{
					texture_id = "overlay",
					style_id = "overlay",
					pass_type = "texture",
					retained_mode = var_0_2
				},
				{
					style_id = "task_text_1",
					pass_type = "text",
					text_id = "task_text_1",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_3_1)
						-- function 3
						return not (self.task_amount > 0) or not self.texture_task_icon_1
					end
				},
				{
					style_id = "task_value_1",
					pass_type = "text",
					text_id = "task_value_1",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_4_1)
						-- function 4
						return self.task_amount > 0
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_task_icon_1",
					texture_id = "texture_task_icon_1",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_5_1)
						-- function 5
						local texture_task_icon_1 = self.texture_task_icon_1

						texture_task_icon_1 = not texture_task_icon_1 and self.task_amount > 0

						return texture_task_icon_1
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "texture_task_marker_1",
					texture_id = "texture_task_marker_1",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_6_1)
						-- function 6
						local task_completed_1 = self.task_completed_1

						task_completed_1 = not task_completed_1 and self.task_amount > 0

						return task_completed_1
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_task_glow_1",
					texture_id = "texture_task_glow",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_7_1)
						-- function 7
						return self.task_amount > 0
					end
				},
				{
					style_id = "task_text_2",
					pass_type = "text",
					text_id = "task_text_2",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_8_1)
						-- function 8
						return not (self.task_amount > 1) or not self.texture_task_icon_2
					end
				},
				{
					style_id = "task_value_2",
					pass_type = "text",
					text_id = "task_value_2",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_9_1)
						-- function 9
						return self.task_amount > 1
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_task_icon_2",
					texture_id = "texture_task_icon_2",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_10_1)
						-- function 10
						local texture_task_icon_2 = self.texture_task_icon_2

						texture_task_icon_2 = not texture_task_icon_2 and self.task_amount > 1

						return texture_task_icon_2
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "texture_task_marker_2",
					texture_id = "texture_task_marker_2",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_11_1)
						-- function 11
						local task_amount = self.task_amount
						local task_completed_2 = self.task_completed_2

						task_completed_2 = not task_completed_2 and task_amount > 1

						return task_completed_2
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_task_glow_2",
					texture_id = "texture_task_glow",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_12_1)
						-- function 12
						return self.task_amount > 1
					end
				},
				{
					style_id = "task_text_3",
					pass_type = "text",
					text_id = "task_text_3",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_13_1)
						-- function 13
						return not (self.task_amount > 2) or not self.texture_task_icon_3
					end
				},
				{
					style_id = "task_value_3",
					pass_type = "text",
					text_id = "task_value_3",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_14_1)
						-- function 14
						return self.task_amount > 2
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_task_icon_3",
					texture_id = "texture_task_icon_3",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_15_1)
						-- function 15
						local texture_task_icon_3 = self.texture_task_icon_3

						texture_task_icon_3 = not texture_task_icon_3 and self.task_amount > 2

						return texture_task_icon_3
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "texture_task_marker_3",
					texture_id = "texture_task_marker_3",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_16_1)
						-- function 16
						local task_amount = self.task_amount
						local task_completed_3 = self.task_completed_3

						task_completed_3 = not task_completed_3 and task_amount > 2

						return task_completed_3
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_task_glow_3",
					texture_id = "texture_task_glow",
					retained_mode = var_0_2,
					content_check_function = function (self, arg_17_1)
						-- function 17
						return self.task_amount > 2
					end
				}
			}
		},
		content = {
			texture_bg = "contract_progress_bg",
			title_text = "n/a",
			texture_completed = "contract_progress_completed",
			task_value_2 = "n/a",
			task_amount = 1,
			task_text_3 = "n/a",
			overlay = "rect_masked",
			task_value_1 = "n/a",
			visible = false,
			overlay_mask = "contract_masked_overlay",
			task_text_2 = "n/a",
			texture_divider = "contract_progress_divider",
			task_text_1 = "n/a",
			bar_text = "Contract Progress: 80%",
			task_value_3 = "n/a",
			texture_task_glow = "quest_endscreen_glow",
			texture_task_marker_1 = "quest_contract_checkmark_" .. arg_1_0 .. "_1",
			texture_task_marker_2 = "quest_contract_checkmark_" .. arg_1_0 .. "_2",
			texture_task_marker_3 = "quest_contract_checkmark_" .. arg_1_0 .. "_3",
			progress_bar = {
				bar_value_position = 0,
				bar_value_size = 0,
				texture_id = "contract_progress_bar",
				internal_bar_value_position = 0,
				bar_value = 0,
				bar_value_offset = 0,
				internal_bar_value = 0,
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
			}
		},
		style = {
			task_start_offset = 20,
			task_bg_size = {
				num_3,
				num_4
			},
			overlay = {
				size = {
					880,
					235
				},
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					23,
					7
				}
			},
			texture_bg = {
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
			texture_completed = {
				size = {
					408,
					179
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
					0
				}
			},
			title_text = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				font_type = "hell_shark",
				font_size = 32,
				offset = {
					0,
					-15,
					4
				},
				text_color = {
					150,
					0,
					0,
					0
				}
			},
			bar_text = {
				vertical_alignment = "center",
				font_size = 16,
				horizontal_alignment = "left",
				debug_draw_box = false,
				font_type = "hell_shark",
				size = {
					num_3,
					20
				},
				offset = {
					20,
					35,
					4
				},
				text_color = {
					150,
					0,
					0,
					0
				}
			},
			progress_bar = {
				uv_start_pixels = 0,
				uv_scale_pixels = 859,
				scale_axis = 1,
				size = {
					859,
					17
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					11,
					58,
					1
				}
			},
			texture_divider = {
				texture_amount = 2,
				texture_axis = 1,
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					num_3,
					num_4
				},
				offset = {
					20,
					73,
					2
				},
				texture_size = {
					11,
					132
				}
			},
			task_text_1 = {
				vertical_alignment = "top",
				font_size = 18,
				horizontal_alignment = "center",
				debug_draw_box = false,
				font_type = "hell_shark",
				size = {
					num_3,
					75
				},
				offset = {
					20,
					113,
					4
				},
				text_color = {
					150,
					0,
					0,
					0
				}
			},
			task_value_1 = {
				vertical_alignment = "center",
				font_size = 32,
				horizontal_alignment = "center",
				debug_draw_box = false,
				font_type = "hell_shark",
				size = {
					num_3,
					37
				},
				offset = {
					20,
					76,
					4
				},
				text_color = {
					150,
					0,
					0,
					0
				}
			},
			texture_task_marker_1 = {
				gradient_threshold = 0,
				size = {
					164,
					108
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					20,
					80,
					2
				}
			},
			texture_task_icon_1 = {
				size = {
					80,
					80
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					20,
					115,
					5
				}
			},
			texture_task_glow_1 = {
				size = {
					300,
					104
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					20,
					76,
					3
				}
			},
			task_text_2 = {
				vertical_alignment = "top",
				font_size = 18,
				horizontal_alignment = "center",
				debug_draw_box = false,
				font_type = "hell_shark",
				size = {
					num_3,
					75
				},
				offset = {
					20,
					113,
					4
				},
				text_color = {
					150,
					0,
					0,
					0
				}
			},
			task_value_2 = {
				vertical_alignment = "center",
				font_size = 32,
				horizontal_alignment = "center",
				debug_draw_box = false,
				font_type = "hell_shark",
				size = {
					num_3,
					37
				},
				offset = {
					20,
					76,
					4
				},
				text_color = {
					150,
					0,
					0,
					0
				}
			},
			texture_task_marker_2 = {
				gradient_threshold = 0,
				size = {
					164,
					108
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					20,
					80,
					2
				}
			},
			texture_task_icon_2 = {
				size = {
					80,
					80
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					20,
					115,
					5
				}
			},
			texture_task_glow_2 = {
				size = {
					300,
					104
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					20,
					76,
					3
				}
			},
			task_text_3 = {
				vertical_alignment = "top",
				font_size = 18,
				horizontal_alignment = "center",
				debug_draw_box = false,
				font_type = "hell_shark",
				size = {
					num_3,
					75
				},
				offset = {
					20,
					113,
					4
				},
				text_color = {
					150,
					0,
					0,
					0
				}
			},
			task_value_3 = {
				vertical_alignment = "center",
				font_size = 32,
				horizontal_alignment = "center",
				debug_draw_box = false,
				font_type = "hell_shark",
				size = {
					num_3,
					37
				},
				offset = {
					20,
					76,
					4
				},
				text_color = {
					150,
					0,
					0,
					0
				}
			},
			texture_task_marker_3 = {
				gradient_threshold = 0,
				size = {
					164,
					108
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					20,
					80,
					2
				}
			},
			texture_task_icon_3 = {
				size = {
					80,
					80
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					20,
					115,
					5
				}
			},
			texture_task_glow_3 = {
				size = {
					300,
					104
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					20,
					76,
					3
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = "entry_" .. arg_1_0
	}
end

local tbl_2 = {}

for i = 1, 3 do
	tbl_2[i] = fn(i)
end

local tbl_3 = {
	input_description_text = UIWidgets.create_simple_text("press_any_key_to_continue", "input_description_text", 18, Colors.get_color_table_with_alpha("white", 255)),
	title_text = UIWidgets.create_simple_text("dlc1_3_1_contract_presentation_title", "title_text", 36, Colors.get_color_table_with_alpha("cheeseburger", 255))
}
local tbl_4 = {
	contract_entry = {
		{
			name = "reset",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				local num = 0
				local widget_index = arg_18_3.widget_index
				local var_18_2 = arg_18_2[widget_index]
				local style = var_18_2.style
				local content = var_18_2.content

				style.texture_divider.color[1] = num
				style.progress_bar.color[1] = num
				style.texture_bg.color[1] = num
				style.bar_text.text_color[1] = num
				style.title_text.text_color[1] = num
				style.texture_task_marker_1.color[1] = num
				style.texture_task_marker_2.color[1] = num
				style.texture_task_marker_3.color[1] = num
				style.task_text_1.text_color[1] = num
				style.task_text_2.text_color[1] = num
				style.task_text_3.text_color[1] = num
				style.task_value_1.text_color[1] = num
				style.task_value_2.text_color[1] = num
				style.task_value_3.text_color[1] = num
				style.texture_task_icon_1.color[1] = num
				style.texture_task_icon_2.color[1] = num
				style.texture_task_icon_3.color[1] = num

				local str = "entry_" .. widget_index

				arg_18_0[str].local_position[2] = arg_18_1[str].position[2]
			end,
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				-- function 19
				return
			end,
			on_complete = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				return
			end
		},
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				WwiseWorld.trigger_event(arg_21_3.wwise_world, "Play_hud_quest_menu_select_quest")
			end,
			update = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				-- function 22
				local num = math.easeCubic(arg_22_3) * 255
				local num_2 = math.easeCubic(arg_22_3) * 150
				local style = arg_22_2[arg_22_4.widget_index].style

				style.texture_divider.color[1] = num
				style.progress_bar.color[1] = num
				style.texture_bg.color[1] = num
				style.bar_text.text_color[1] = num_2
				style.title_text.text_color[1] = num_2
				style.texture_task_marker_1.color[1] = num
				style.texture_task_marker_2.color[1] = num
				style.texture_task_marker_3.color[1] = num
				style.texture_task_icon_1.color[1] = num
				style.texture_task_icon_2.color[1] = num
				style.texture_task_icon_3.color[1] = num
				style.task_text_1.text_color[1] = num_2
				style.task_text_2.text_color[1] = num_2
				style.task_text_3.text_color[1] = num_2
				style.task_value_1.text_color[1] = num_2
				style.task_value_2.text_color[1] = num_2
				style.task_value_3.text_color[1] = num_2
			end,
			on_complete = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				-- function 23
				return
			end
		}
	},
	contract_move = {
		{
			name = "move",
			start_progress = 0,
			end_progress = 0.3,
			init = function (self, arg_24_1, arg_24_2, arg_24_3)
				-- function 24
				local tbl = {}
				local widget_index = arg_24_3.widget_index
				local num_widgets = arg_24_3.num_widgets

				for i = 1, widget_index do
					tbl[i] = self["entry_" .. i].local_position[2]
				end

				arg_24_3.start_heights = tbl

				WwiseWorld.trigger_event(arg_24_3.wwise_world, "Play_hud_shift")
			end,
			update = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				-- function 25
				local widget_index = arg_25_4.widget_index
				local num_widgets = arg_25_4.num_widgets
				local start_heights = arg_25_4.start_heights

				for i = 1, widget_index do
					local str = "entry_" .. i
					local position = arg_25_1[str].position

					arg_25_0[str].local_position[2] = start_heights[i] - 260 * math.easeOutCubic(arg_25_3)
				end
			end,
			on_complete = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				return
			end
		}
	},
	contract_task_progress = {
		{
			name = "fade_in_selection",
			start_progress = 0,
			end_progress = 0.15,
			init = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				return
			end,
			update = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				-- function 28
				local num = math.easeOutCubic(arg_28_3) * 255
				local widget_index = arg_28_4.widget_index
				local task_index = arg_28_4.task_index

				arg_28_2[widget_index].style["texture_task_glow_" .. task_index].color[1] = num
			end,
			on_complete = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				return
			end
		},
		{
			name = "font_size",
			start_progress = 0.1,
			end_progress = 0.5,
			init = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				-- function 30
				return
			end,
			update = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
				-- function 31
				local widget_index = arg_31_4.widget_index
				local task_index = arg_31_4.task_index
				local var_31_2 = arg_31_4.task_data[task_index]

				if not var_31_2 and not var_31_2.session_value then
					arg_31_2[widget_index].style["task_value_" .. task_index].font_size = 32 * math.catmullrom(arg_31_3, -0.5, 1, 1, -0.5)
				end
			end,
			on_complete = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				-- function 32
				return
			end
		},
		{
			name = "set_new_value",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				-- function 33
				return
			end,
			update = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
				-- function 34
				local widget_index = arg_34_4.widget_index
				local task_index = arg_34_4.task_index
				local var_34_2 = arg_34_4.task_data[task_index]

				if not var_34_2 and not var_34_2.session_value then
					local var_34_3 = arg_34_2[widget_index]
					local style = var_34_3.style
					local content = var_34_3.content
					local value = var_34_2.value
					local session_value = var_34_2.session_value
					local end_value = var_34_2.end_value
					local floor = math.floor(session_value * arg_34_3)

					content["task_value_" .. task_index] = tostring(value + floor) .. "/" .. tostring(end_value)

					if end_value <= value + session_value then
						arg_34_4.task_completed = true
					end
				end
			end,
			on_complete = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				-- function 35
				return
			end
		},
		{
			name = "set_completed",
			start_progress = 0.45,
			end_progress = 0.6,
			init = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				-- function 36
				if not arg_36_3.task_completed then
					WwiseWorld.trigger_event(arg_36_3.wwise_world, "Play_hud_quest_menu_finish_quest_end_screen")
				end
			end,
			update = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
				-- function 37
				if not arg_37_4.task_completed then
					local var_37_0 = arg_37_2[arg_37_4.widget_index]
					local content = var_37_0.content
					local style = var_37_0.style
					local task_index = arg_37_4.task_index
					local easeOutCubic = math.easeOutCubic(arg_37_3)

					content["task_completed_" .. task_index] = true

					local var_37_5 = style["texture_task_marker_" .. task_index]

					var_37_5.color[1] = 255
					var_37_5.gradient_threshold = easeOutCubic
				end
			end,
			on_complete = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				-- function 38
				return
			end
		},
		{
			name = "fade_out_selection",
			start_progress = 0.6,
			end_progress = 0.75,
			init = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				-- function 39
				return
			end,
			update = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
				-- function 40
				local num = 255 - math.easeOutCubic(arg_40_3) * 255
				local widget_index = arg_40_4.widget_index
				local task_index = arg_40_4.task_index

				arg_40_2[widget_index].style["texture_task_glow_" .. task_index].color[1] = num
			end,
			on_complete = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				-- function 41
				return
			end
		}
	},
	contract_summary = {
		{
			name = "bar_progress",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				-- function 42
				WwiseWorld.trigger_event(arg_42_3.wwise_world, "Play_hud_quest_menu_finish_quest_end_screen_progress")
			end,
			update = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
				-- function 43
				local var_43_0 = arg_43_2[arg_43_4.widget_index]
				local content = var_43_0.content
				local style = var_43_0.style
				local contract_start_progress = arg_43_4.contract_start_progress
				local contract_session_progress = arg_43_4.contract_session_progress
				local progress_bar = style.progress_bar
				local progress_bar_2 = content.progress_bar
				local min = math.min(contract_start_progress + contract_session_progress * math.easeCubic(arg_43_3), 1)

				progress_bar.size[1] = progress_bar.uv_scale_pixels * min
				progress_bar_2.uvs[2][progress_bar.scale_axis] = min

				if not (arg_43_3 ~= 1 or min ~= 1) then
					arg_43_4.play_completed = true
				end

				local floor = math.floor(min * 100, 0)

				content.bar_text = Localize("dlc1_3_1_contract_presentation_progress_prefix") .. ": " .. tostring(floor) .. "%"
			end,
			on_complete = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				-- function 44
				return
			end
		},
		{
			name = "completed_stamp",
			start_progress = 0.5,
			end_progress = 0.7,
			init = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				-- function 45
				WwiseWorld.trigger_event(arg_45_3.wwise_world, "Play_hud_quest_menu_finish_quest_end_screen_completed")
			end,
			update = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
				-- function 46
				if not arg_46_4.play_completed then
					local var_46_0 = arg_46_2[arg_46_4.widget_index]
					local content = var_46_0.content
					local style = var_46_0.style
					local easeInCubic = math.easeInCubic(arg_46_3)
					local min = math.min(20 + easeInCubic * 120, 120)
					local texture_completed = style.texture_completed

					texture_completed.color[1] = min

					local offset = texture_completed.offset
					local size = texture_completed.size
					local catmullrom = math.catmullrom(easeInCubic, 1.8, 1.8, 1.2, 1.2)
					local num = 408
					local num_2 = 179

					size[1] = math.floor(num * catmullrom)
					size[2] = math.floor(num_2 * catmullrom)

					local num_3 = 250
					local num_4 = 40

					offset[1] = num_3 - (size[1] - num) * 0.5
					offset[2] = num_4 - (size[2] - num_2) * 0.5
				end
			end,
			on_complete = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
				-- function 47
				return
			end
		},
		{
			name = "delay",
			start_progress = 0.7,
			end_progress = 0.8,
			init = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
				-- function 48
				return
			end,
			update = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
				-- function 49
				return
			end,
			on_complete = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
				-- function 50
				return
			end
		}
	},
	no_progress = {
		{
			name = "overlay_fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
				-- function 51
				return
			end,
			update = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
				-- function 52
				local num = math.easeOutCubic(arg_52_3) * 50
				local widget_index = arg_52_4.widget_index
				local task_index = arg_52_4.task_index

				arg_52_2[widget_index].style.overlay.color[1] = num
			end,
			on_complete = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3)
				-- function 53
				return
			end
		}
	},
	contracts_exit = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.6,
			init = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
				-- function 54
				return
			end,
			update = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
				-- function 55
				local num = 255 - math.easeCubic(arg_55_3) * 255
				local num_2 = 150 - math.easeCubic(arg_55_3) * 150
				local num_3 = 50 - math.easeCubic(arg_55_3) * 50
				local num_4 = 120 - math.easeCubic(arg_55_3) * 120
				local num_widgets = arg_55_4.num_widgets

				for i = 1, num_widgets do
					local style = arg_55_2[i].style

					if num_3 < style.overlay.color[1] then
						style.overlay.color[1] = num_3
					end

					if num_4 < style.texture_completed.color[1] then
						style.texture_completed.color[1] = num_4
					end

					style.texture_divider.color[1] = num
					style.progress_bar.color[1] = num
					style.texture_bg.color[1] = num
					style.bar_text.text_color[1] = num_2
					style.title_text.text_color[1] = num_2
					style.texture_task_marker_1.color[1] = num
					style.texture_task_marker_2.color[1] = num
					style.texture_task_marker_3.color[1] = num
					style.texture_task_icon_1.color[1] = num
					style.texture_task_icon_2.color[1] = num
					style.texture_task_icon_3.color[1] = num
					style.task_text_1.text_color[1] = num_2
					style.task_text_2.text_color[1] = num_2
					style.task_text_3.text_color[1] = num_2
					style.task_value_1.text_color[1] = num_2
					style.task_value_2.text_color[1] = num_2
					style.task_value_3.text_color[1] = num_2
				end
			end,
			on_complete = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
				-- function 56
				return
			end
		}
	}
}

return {
	scenegraph_definition = tbl,
	entry_widget_definitions = tbl_2,
	widget_definitions = tbl_3,
	animation_definitions = tbl_4
}
