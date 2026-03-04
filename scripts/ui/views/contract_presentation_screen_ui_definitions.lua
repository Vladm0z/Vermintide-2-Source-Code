-- chunkname: @scripts/ui/views/contract_presentation_screen_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2
local var_0_3 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.end_screen + 2
		},
		size = {
			var_0_0,
			var_0_1
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
			var_0_0,
			var_0_1
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

local function var_0_4(arg_1_0)
	local var_1_0 = 899
	local var_1_1 = 259
	local var_1_2 = 860
	local var_1_3 = 127

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
					content_check_function = function(arg_2_0, arg_2_1)
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
					content_check_function = function(arg_3_0, arg_3_1)
						return arg_3_0.task_amount > 0 and not arg_3_0.texture_task_icon_1
					end
				},
				{
					style_id = "task_value_1",
					pass_type = "text",
					text_id = "task_value_1",
					retained_mode = var_0_2,
					content_check_function = function(arg_4_0, arg_4_1)
						return arg_4_0.task_amount > 0
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_task_icon_1",
					texture_id = "texture_task_icon_1",
					retained_mode = var_0_2,
					content_check_function = function(arg_5_0, arg_5_1)
						return arg_5_0.texture_task_icon_1 and arg_5_0.task_amount > 0
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "texture_task_marker_1",
					texture_id = "texture_task_marker_1",
					retained_mode = var_0_2,
					content_check_function = function(arg_6_0, arg_6_1)
						return arg_6_0.task_completed_1 and arg_6_0.task_amount > 0
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_task_glow_1",
					texture_id = "texture_task_glow",
					retained_mode = var_0_2,
					content_check_function = function(arg_7_0, arg_7_1)
						return arg_7_0.task_amount > 0
					end
				},
				{
					style_id = "task_text_2",
					pass_type = "text",
					text_id = "task_text_2",
					retained_mode = var_0_2,
					content_check_function = function(arg_8_0, arg_8_1)
						return arg_8_0.task_amount > 1 and not arg_8_0.texture_task_icon_2
					end
				},
				{
					style_id = "task_value_2",
					pass_type = "text",
					text_id = "task_value_2",
					retained_mode = var_0_2,
					content_check_function = function(arg_9_0, arg_9_1)
						return arg_9_0.task_amount > 1
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_task_icon_2",
					texture_id = "texture_task_icon_2",
					retained_mode = var_0_2,
					content_check_function = function(arg_10_0, arg_10_1)
						return arg_10_0.texture_task_icon_2 and arg_10_0.task_amount > 1
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "texture_task_marker_2",
					texture_id = "texture_task_marker_2",
					retained_mode = var_0_2,
					content_check_function = function(arg_11_0, arg_11_1)
						local var_11_0 = arg_11_0.task_amount

						return arg_11_0.task_completed_2 and var_11_0 > 1
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_task_glow_2",
					texture_id = "texture_task_glow",
					retained_mode = var_0_2,
					content_check_function = function(arg_12_0, arg_12_1)
						return arg_12_0.task_amount > 1
					end
				},
				{
					style_id = "task_text_3",
					pass_type = "text",
					text_id = "task_text_3",
					retained_mode = var_0_2,
					content_check_function = function(arg_13_0, arg_13_1)
						return arg_13_0.task_amount > 2 and not arg_13_0.texture_task_icon_3
					end
				},
				{
					style_id = "task_value_3",
					pass_type = "text",
					text_id = "task_value_3",
					retained_mode = var_0_2,
					content_check_function = function(arg_14_0, arg_14_1)
						return arg_14_0.task_amount > 2
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_task_icon_3",
					texture_id = "texture_task_icon_3",
					retained_mode = var_0_2,
					content_check_function = function(arg_15_0, arg_15_1)
						return arg_15_0.texture_task_icon_3 and arg_15_0.task_amount > 2
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "texture_task_marker_3",
					texture_id = "texture_task_marker_3",
					retained_mode = var_0_2,
					content_check_function = function(arg_16_0, arg_16_1)
						local var_16_0 = arg_16_0.task_amount

						return arg_16_0.task_completed_3 and var_16_0 > 2
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_task_glow_3",
					texture_id = "texture_task_glow",
					retained_mode = var_0_2,
					content_check_function = function(arg_17_0, arg_17_1)
						return arg_17_0.task_amount > 2
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
				var_1_2,
				var_1_3
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
					var_1_2,
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
					var_1_2,
					var_1_3
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
					var_1_2,
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
					var_1_2,
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
					var_1_2,
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
					var_1_2,
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
					var_1_2,
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
					var_1_2,
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

local var_0_5 = {}

for iter_0_0 = 1, 3 do
	var_0_5[iter_0_0] = var_0_4(iter_0_0)
end

local var_0_6 = {
	input_description_text = UIWidgets.create_simple_text("press_any_key_to_continue", "input_description_text", 18, Colors.get_color_table_with_alpha("white", 255)),
	title_text = UIWidgets.create_simple_text("dlc1_3_1_contract_presentation_title", "title_text", 36, Colors.get_color_table_with_alpha("cheeseburger", 255))
}
local var_0_7 = {
	contract_entry = {
		{
			name = "reset",
			start_progress = 0,
			end_progress = 0,
			init = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				local var_18_0 = 0
				local var_18_1 = arg_18_3.widget_index
				local var_18_2 = arg_18_2[var_18_1]
				local var_18_3 = var_18_2.style
				local var_18_4 = var_18_2.content

				var_18_3.texture_divider.color[1] = var_18_0
				var_18_3.progress_bar.color[1] = var_18_0
				var_18_3.texture_bg.color[1] = var_18_0
				var_18_3.bar_text.text_color[1] = var_18_0
				var_18_3.title_text.text_color[1] = var_18_0
				var_18_3.texture_task_marker_1.color[1] = var_18_0
				var_18_3.texture_task_marker_2.color[1] = var_18_0
				var_18_3.texture_task_marker_3.color[1] = var_18_0
				var_18_3.task_text_1.text_color[1] = var_18_0
				var_18_3.task_text_2.text_color[1] = var_18_0
				var_18_3.task_text_3.text_color[1] = var_18_0
				var_18_3.task_value_1.text_color[1] = var_18_0
				var_18_3.task_value_2.text_color[1] = var_18_0
				var_18_3.task_value_3.text_color[1] = var_18_0
				var_18_3.texture_task_icon_1.color[1] = var_18_0
				var_18_3.texture_task_icon_2.color[1] = var_18_0
				var_18_3.texture_task_icon_3.color[1] = var_18_0

				local var_18_5 = "entry_" .. var_18_1

				arg_18_0[var_18_5].local_position[2] = arg_18_1[var_18_5].position[2]
			end,
			update = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				return
			end,
			on_complete = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end
		},
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				WwiseWorld.trigger_event(arg_21_3.wwise_world, "Play_hud_quest_menu_select_quest")
			end,
			update = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				local var_22_0 = math.easeCubic(arg_22_3) * 255
				local var_22_1 = math.easeCubic(arg_22_3) * 150
				local var_22_2 = arg_22_2[arg_22_4.widget_index].style

				var_22_2.texture_divider.color[1] = var_22_0
				var_22_2.progress_bar.color[1] = var_22_0
				var_22_2.texture_bg.color[1] = var_22_0
				var_22_2.bar_text.text_color[1] = var_22_1
				var_22_2.title_text.text_color[1] = var_22_1
				var_22_2.texture_task_marker_1.color[1] = var_22_0
				var_22_2.texture_task_marker_2.color[1] = var_22_0
				var_22_2.texture_task_marker_3.color[1] = var_22_0
				var_22_2.texture_task_icon_1.color[1] = var_22_0
				var_22_2.texture_task_icon_2.color[1] = var_22_0
				var_22_2.texture_task_icon_3.color[1] = var_22_0
				var_22_2.task_text_1.text_color[1] = var_22_1
				var_22_2.task_text_2.text_color[1] = var_22_1
				var_22_2.task_text_3.text_color[1] = var_22_1
				var_22_2.task_value_1.text_color[1] = var_22_1
				var_22_2.task_value_2.text_color[1] = var_22_1
				var_22_2.task_value_3.text_color[1] = var_22_1
			end,
			on_complete = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				return
			end
		}
	},
	contract_move = {
		{
			name = "move",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				local var_24_0 = {}
				local var_24_1 = arg_24_3.widget_index
				local var_24_2 = arg_24_3.num_widgets

				for iter_24_0 = 1, var_24_1 do
					var_24_0[iter_24_0] = arg_24_0["entry_" .. iter_24_0].local_position[2]
				end

				arg_24_3.start_heights = var_24_0

				WwiseWorld.trigger_event(arg_24_3.wwise_world, "Play_hud_shift")
			end,
			update = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				local var_25_0 = arg_25_4.widget_index
				local var_25_1 = arg_25_4.num_widgets
				local var_25_2 = arg_25_4.start_heights

				for iter_25_0 = 1, var_25_0 do
					local var_25_3 = "entry_" .. iter_25_0
					local var_25_4 = arg_25_1[var_25_3].position

					arg_25_0[var_25_3].local_position[2] = var_25_2[iter_25_0] - 260 * math.easeOutCubic(arg_25_3)
				end
			end,
			on_complete = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				return
			end
		}
	},
	contract_task_progress = {
		{
			name = "fade_in_selection",
			start_progress = 0,
			end_progress = 0.15,
			init = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				return
			end,
			update = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				local var_28_0 = math.easeOutCubic(arg_28_3) * 255
				local var_28_1 = arg_28_4.widget_index
				local var_28_2 = arg_28_4.task_index

				arg_28_2[var_28_1].style["texture_task_glow_" .. var_28_2].color[1] = var_28_0
			end,
			on_complete = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				return
			end
		},
		{
			name = "font_size",
			start_progress = 0.1,
			end_progress = 0.5,
			init = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				return
			end,
			update = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
				local var_31_0 = arg_31_4.widget_index
				local var_31_1 = arg_31_4.task_index
				local var_31_2 = arg_31_4.task_data[var_31_1]

				if var_31_2 and var_31_2.session_value then
					arg_31_2[var_31_0].style["task_value_" .. var_31_1].font_size = 32 * math.catmullrom(arg_31_3, -0.5, 1, 1, -0.5)
				end
			end,
			on_complete = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				return
			end
		},
		{
			name = "set_new_value",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				return
			end,
			update = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
				local var_34_0 = arg_34_4.widget_index
				local var_34_1 = arg_34_4.task_index
				local var_34_2 = arg_34_4.task_data[var_34_1]

				if var_34_2 and var_34_2.session_value then
					local var_34_3 = arg_34_2[var_34_0]
					local var_34_4 = var_34_3.style
					local var_34_5 = var_34_3.content
					local var_34_6 = var_34_2.value
					local var_34_7 = var_34_2.session_value
					local var_34_8 = var_34_2.end_value
					local var_34_9 = math.floor(var_34_7 * arg_34_3)

					var_34_5["task_value_" .. var_34_1] = tostring(var_34_6 + var_34_9) .. "/" .. tostring(var_34_8)

					if var_34_8 <= var_34_6 + var_34_7 then
						arg_34_4.task_completed = true
					end
				end
			end,
			on_complete = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				return
			end
		},
		{
			name = "set_completed",
			start_progress = 0.45,
			end_progress = 0.6,
			init = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				if arg_36_3.task_completed then
					WwiseWorld.trigger_event(arg_36_3.wwise_world, "Play_hud_quest_menu_finish_quest_end_screen")
				end
			end,
			update = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
				if arg_37_4.task_completed then
					local var_37_0 = arg_37_2[arg_37_4.widget_index]
					local var_37_1 = var_37_0.content
					local var_37_2 = var_37_0.style
					local var_37_3 = arg_37_4.task_index
					local var_37_4 = math.easeOutCubic(arg_37_3)

					var_37_1["task_completed_" .. var_37_3] = true

					local var_37_5 = var_37_2["texture_task_marker_" .. var_37_3]

					var_37_5.color[1] = 255
					var_37_5.gradient_threshold = var_37_4
				end
			end,
			on_complete = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				return
			end
		},
		{
			name = "fade_out_selection",
			start_progress = 0.6,
			end_progress = 0.75,
			init = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				return
			end,
			update = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
				local var_40_0 = 255 - math.easeOutCubic(arg_40_3) * 255
				local var_40_1 = arg_40_4.widget_index
				local var_40_2 = arg_40_4.task_index

				arg_40_2[var_40_1].style["texture_task_glow_" .. var_40_2].color[1] = var_40_0
			end,
			on_complete = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				return
			end
		}
	},
	contract_summary = {
		{
			name = "bar_progress",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				WwiseWorld.trigger_event(arg_42_3.wwise_world, "Play_hud_quest_menu_finish_quest_end_screen_progress")
			end,
			update = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
				local var_43_0 = arg_43_2[arg_43_4.widget_index]
				local var_43_1 = var_43_0.content
				local var_43_2 = var_43_0.style
				local var_43_3 = arg_43_4.contract_start_progress
				local var_43_4 = arg_43_4.contract_session_progress
				local var_43_5 = var_43_2.progress_bar
				local var_43_6 = var_43_1.progress_bar
				local var_43_7 = math.min(var_43_3 + var_43_4 * math.easeCubic(arg_43_3), 1)

				var_43_5.size[1] = var_43_5.uv_scale_pixels * var_43_7
				var_43_6.uvs[2][var_43_5.scale_axis] = var_43_7

				if arg_43_3 == 1 and var_43_7 == 1 then
					arg_43_4.play_completed = true
				end

				local var_43_8 = math.floor(var_43_7 * 100, 0)

				var_43_1.bar_text = Localize("dlc1_3_1_contract_presentation_progress_prefix") .. ": " .. tostring(var_43_8) .. "%"
			end,
			on_complete = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				return
			end
		},
		{
			name = "completed_stamp",
			start_progress = 0.5,
			end_progress = 0.7,
			init = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				WwiseWorld.trigger_event(arg_45_3.wwise_world, "Play_hud_quest_menu_finish_quest_end_screen_completed")
			end,
			update = function(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
				if arg_46_4.play_completed then
					local var_46_0 = arg_46_2[arg_46_4.widget_index]
					local var_46_1 = var_46_0.content
					local var_46_2 = var_46_0.style
					local var_46_3 = math.easeInCubic(arg_46_3)
					local var_46_4 = math.min(20 + var_46_3 * 120, 120)
					local var_46_5 = var_46_2.texture_completed

					var_46_5.color[1] = var_46_4

					local var_46_6 = var_46_5.offset
					local var_46_7 = var_46_5.size
					local var_46_8 = math.catmullrom(var_46_3, 1.8, 1.8, 1.2, 1.2)
					local var_46_9 = 408
					local var_46_10 = 179

					var_46_7[1] = math.floor(var_46_9 * var_46_8)
					var_46_7[2] = math.floor(var_46_10 * var_46_8)

					local var_46_11 = 250
					local var_46_12 = 40

					var_46_6[1] = var_46_11 - (var_46_7[1] - var_46_9) * 0.5
					var_46_6[2] = var_46_12 - (var_46_7[2] - var_46_10) * 0.5
				end
			end,
			on_complete = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
				return
			end
		},
		{
			name = "delay",
			start_progress = 0.7,
			end_progress = 0.8,
			init = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
				return
			end,
			update = function(arg_49_0, arg_49_1, arg_49_2, arg_49_3, arg_49_4)
				return
			end,
			on_complete = function(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
				return
			end
		}
	},
	no_progress = {
		{
			name = "overlay_fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
				return
			end,
			update = function(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
				local var_52_0 = math.easeOutCubic(arg_52_3) * 50
				local var_52_1 = arg_52_4.widget_index
				local var_52_2 = arg_52_4.task_index

				arg_52_2[var_52_1].style.overlay.color[1] = var_52_0
			end,
			on_complete = function(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
				return
			end
		}
	},
	contracts_exit = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.6,
			init = function(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
				return
			end,
			update = function(arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4)
				local var_55_0 = 255 - math.easeCubic(arg_55_3) * 255
				local var_55_1 = 150 - math.easeCubic(arg_55_3) * 150
				local var_55_2 = 50 - math.easeCubic(arg_55_3) * 50
				local var_55_3 = 120 - math.easeCubic(arg_55_3) * 120
				local var_55_4 = arg_55_4.num_widgets

				for iter_55_0 = 1, var_55_4 do
					local var_55_5 = arg_55_2[iter_55_0].style

					if var_55_2 < var_55_5.overlay.color[1] then
						var_55_5.overlay.color[1] = var_55_2
					end

					if var_55_3 < var_55_5.texture_completed.color[1] then
						var_55_5.texture_completed.color[1] = var_55_3
					end

					var_55_5.texture_divider.color[1] = var_55_0
					var_55_5.progress_bar.color[1] = var_55_0
					var_55_5.texture_bg.color[1] = var_55_0
					var_55_5.bar_text.text_color[1] = var_55_1
					var_55_5.title_text.text_color[1] = var_55_1
					var_55_5.texture_task_marker_1.color[1] = var_55_0
					var_55_5.texture_task_marker_2.color[1] = var_55_0
					var_55_5.texture_task_marker_3.color[1] = var_55_0
					var_55_5.texture_task_icon_1.color[1] = var_55_0
					var_55_5.texture_task_icon_2.color[1] = var_55_0
					var_55_5.texture_task_icon_3.color[1] = var_55_0
					var_55_5.task_text_1.text_color[1] = var_55_1
					var_55_5.task_text_2.text_color[1] = var_55_1
					var_55_5.task_text_3.text_color[1] = var_55_1
					var_55_5.task_value_1.text_color[1] = var_55_1
					var_55_5.task_value_2.text_color[1] = var_55_1
					var_55_5.task_value_3.text_color[1] = var_55_1
				end
			end,
			on_complete = function(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
				return
			end
		}
	}
}

return {
	scenegraph_definition = var_0_3,
	entry_widget_definitions = var_0_5,
	widget_definitions = var_0_6,
	animation_definitions = var_0_7
}
