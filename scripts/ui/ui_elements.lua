-- chunkname: @scripts/ui/ui_elements.lua

require("scripts/ui/ui_layer")

UIElements = {}
UIElements.ButtonMenuSteps = {
	passes = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function (arg_1_0)
				return not arg_1_0.disabled
			end
		},
		{
			texture_id = "texture_id",
			style_id = "texture",
			pass_type = "texture",
			content_check_function = function (arg_2_0)
				local var_2_0 = arg_2_0.button_hotspot

				return not var_2_0.disabled and not var_2_0.is_hover and var_2_0.is_clicked > 0 and not var_2_0.is_selected
			end
		},
		{
			texture_id = "texture_hover_id",
			style_id = "texture",
			pass_type = "texture",
			content_check_function = function (arg_3_0)
				local var_3_0 = arg_3_0.button_hotspot

				return not var_3_0.disabled and not var_3_0.is_selected and var_3_0.is_hover and var_3_0.is_clicked > 0
			end
		},
		{
			texture_id = "texture_click_id",
			style_id = "texture",
			pass_type = "texture",
			content_check_function = function (arg_4_0)
				local var_4_0 = arg_4_0.button_hotspot

				return not var_4_0.disabled and var_4_0.is_clicked == 0
			end
		},
		{
			texture_id = "texture_selected_id",
			style_id = "texture",
			pass_type = "texture",
			content_check_function = function (arg_5_0)
				local var_5_0 = arg_5_0.button_hotspot

				return not var_5_0.disabled and var_5_0.is_selected and var_5_0.is_clicked > 0
			end
		},
		{
			texture_id = "texture_disabled_id",
			style_id = "texture",
			pass_type = "texture",
			content_check_function = function (arg_6_0)
				return arg_6_0.button_hotspot.disabled
			end
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (arg_7_0)
				local var_7_0 = arg_7_0.button_hotspot

				return not var_7_0.disabled and not var_7_0.is_hover and not var_7_0.is_selected and var_7_0.is_clicked > 0
			end
		},
		{
			style_id = "text_hover",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (arg_8_0)
				local var_8_0 = arg_8_0.button_hotspot

				return not var_8_0.disabled and not var_8_0.is_selected and var_8_0.is_hover and var_8_0.is_clicked > 0
			end
		},
		{
			style_id = "text_selected",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (arg_9_0)
				local var_9_0 = arg_9_0.button_hotspot

				return not var_9_0.disabled and (var_9_0.is_selected or var_9_0.is_clicked == 0)
			end
		},
		{
			style_id = "text_disabled",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (arg_10_0)
				return arg_10_0.button_hotspot.disabled
			end
		}
	}
}
UIElements.ButtonMenuStepsWithTimer = {
	passes = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function (arg_11_0)
				return not arg_11_0.disabled
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_id",
			content_check_function = function (arg_12_0)
				local var_12_0 = arg_12_0.button_hotspot

				return not var_12_0.disabled and not var_12_0.is_hover and var_12_0.is_clicked > 0 and not var_12_0.is_selected
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_hover_id",
			content_check_function = function (arg_13_0)
				local var_13_0 = arg_13_0.button_hotspot

				return not var_13_0.disabled and not var_13_0.is_selected and var_13_0.is_hover and var_13_0.is_clicked > 0
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_click_id",
			content_check_function = function (arg_14_0)
				local var_14_0 = arg_14_0.button_hotspot

				return not var_14_0.disabled and var_14_0.is_clicked == 0
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_selected_id",
			content_check_function = function (arg_15_0)
				local var_15_0 = arg_15_0.button_hotspot

				return not var_15_0.disabled and var_15_0.is_selected and var_15_0.is_clicked > 0
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_disabled_id",
			content_check_function = function (arg_16_0)
				return arg_16_0.button_hotspot.disabled
			end
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (arg_17_0)
				local var_17_0 = arg_17_0.button_hotspot

				return not var_17_0.disabled and not var_17_0.is_hover and not var_17_0.is_selected and var_17_0.is_clicked > 0
			end
		},
		{
			style_id = "text_hover",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (arg_18_0)
				local var_18_0 = arg_18_0.button_hotspot

				return not var_18_0.disabled and not var_18_0.is_selected and var_18_0.is_hover and var_18_0.is_clicked > 0
			end
		},
		{
			style_id = "text_selected",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (arg_19_0)
				local var_19_0 = arg_19_0.button_hotspot

				return not var_19_0.disabled and (var_19_0.is_selected or var_19_0.is_clicked == 0)
			end
		},
		{
			style_id = "text_disabled",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (arg_20_0)
				return arg_20_0.button_hotspot.disabled
			end
		},
		{
			style_id = "timer_text_field",
			pass_type = "text",
			text_id = "timer_text_field",
			content_check_function = function (arg_21_0)
				local var_21_0 = arg_21_0.button_hotspot

				return not var_21_0.disabled and not var_21_0.is_hover and not var_21_0.is_selected and var_21_0.is_clicked > 0
			end
		},
		{
			style_id = "timer_text_field_hover",
			pass_type = "text",
			text_id = "timer_text_field",
			content_check_function = function (arg_22_0)
				local var_22_0 = arg_22_0.button_hotspot

				return not var_22_0.disabled and not var_22_0.is_selected and var_22_0.is_hover and var_22_0.is_clicked > 0
			end
		},
		{
			style_id = "timer_text_field_selected",
			pass_type = "text",
			text_id = "timer_text_field",
			content_check_function = function (arg_23_0)
				local var_23_0 = arg_23_0.button_hotspot

				return not var_23_0.disabled and (var_23_0.is_selected or var_23_0.is_clicked == 0)
			end
		},
		{
			style_id = "timer_text_field_disabled",
			pass_type = "text",
			text_id = "timer_text_field",
			content_check_function = function (arg_24_0)
				return arg_24_0.button_hotspot.disabled
			end
		}
	}
}
UIElements.ToggleIconButton = {
	passes = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "normal_texture",
			texture_id = "normal_texture",
			content_check_function = function (arg_25_0)
				return not arg_25_0.button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "hover_texture",
			texture_id = "hover_texture",
			content_check_function = function (arg_26_0)
				local var_26_0 = arg_26_0.button_hotspot

				return var_26_0.is_hover and var_26_0.is_clicked ~= 0
			end
		},
		{
			pass_type = "texture",
			style_id = "click_texture",
			texture_id = "click_texture",
			content_check_function = function (arg_27_0)
				local var_27_0 = arg_27_0.button_hotspot

				return var_27_0.is_hover and var_27_0.is_clicked == 0
			end
		},
		{
			pass_type = "texture",
			style_id = "toggle_texture",
			texture_id = "toggle_texture",
			content_check_function = function (arg_28_0)
				local var_28_0 = arg_28_0.button_hotspot

				return arg_28_0.toggled and not var_28_0.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "toggle_hover_texture",
			texture_id = "toggle_hover_texture",
			content_check_function = function (arg_29_0)
				local var_29_0 = arg_29_0.button_hotspot

				return arg_29_0.toggled and var_29_0.is_hover and var_29_0.is_clicked ~= 0
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_texture",
			texture_id = "icon_texture",
			content_check_function = function (arg_30_0)
				return not arg_30_0.button_hotspot.is_hover and not arg_30_0.toggled
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_hover_texture",
			texture_id = "icon_hover_texture",
			content_check_function = function (arg_31_0)
				local var_31_0 = arg_31_0.button_hotspot

				return (var_31_0.is_hover or arg_31_0.toggled) and var_31_0.is_clicked ~= 0
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_click_texture",
			texture_id = "icon_texture",
			content_check_function = function (arg_32_0)
				local var_32_0 = arg_32_0.button_hotspot

				return var_32_0.is_hover and var_32_0.is_clicked == 0
			end
		},
		{
			style_id = "tooltip_text",
			pass_type = "tooltip_text",
			text_id = "tooltip_text",
			content_check_function = function (arg_33_0)
				local var_33_0 = arg_33_0.button_hotspot

				return not arg_33_0.toggled and var_33_0.is_hover and var_33_0.is_clicked ~= 0
			end
		},
		{
			style_id = "tooltip_text",
			pass_type = "tooltip_text",
			text_id = "toggled_tooltip_text",
			content_check_function = function (arg_34_0)
				local var_34_0 = arg_34_0.button_hotspot

				return arg_34_0.toggled and var_34_0.is_hover and var_34_0.is_clicked == 0
			end
		}
	}
}
UIElements.SimpleTexture = {
	passes = {
		{
			pass_type = "texture",
			texture_id = "texture_id"
		}
	}
}
UIElements.SimpleRotatedTexture = {
	passes = {
		{
			pass_type = "rotated_texture",
			texture_id = "texture_id"
		}
	}
}
UIElements.SimpleButton = {
	passes = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			texture_id = "texture_id",
			content_check_function = function (arg_35_0)
				return not arg_35_0.button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_hover_id",
			content_check_function = function (arg_36_0)
				return arg_36_0.button_hotspot.is_hover
			end
		}
	}
}
UIElements.Button = {
	passes = {
		{
			pass_type = "hover",
			content_id = "button_hotspot"
		},
		{
			pass_type = "click",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			texture_id = "texture_id",
			content_check_function = function (arg_37_0)
				return not arg_37_0.button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_hover_id",
			content_check_function = function (arg_38_0)
				return arg_38_0.button_hotspot.is_hover
			end
		},
		{
			localize = true,
			style_id = "text",
			pass_type = "text",
			text_id = "text_field"
		}
	}
}
UIElements.StandardWindow = {
	passes = {
		{
			style_id = "background",
			pass_type = "rounded_background",
			content_id = "background"
		},
		{
			style_id = "background_border",
			pass_type = "border",
			content_id = "background_border"
		},
		{
			scenegraph_id = "top_drag_bar",
			pass_type = "hover",
			content_id = "top_drag_bar"
		},
		{
			scenegraph_id = "right_drag_bar",
			pass_type = "hover",
			content_id = "right_drag_bar"
		},
		{
			scenegraph_id = "left_drag_bar",
			pass_type = "hover",
			content_id = "left_drag_bar"
		},
		{
			scenegraph_id = "right_drag_bar",
			pass_type = "hover",
			content_id = "right_drag_bar"
		}
	}
}
UIElements.ScrollBar = {
	passes = {
		{
			pass_type = "rounded_background",
			style_id = "background"
		},
		{
			style_id = "bg_up",
			pass_type = "hover",
			content_id = "scrollbar_up_hotspot"
		},
		{
			style_id = "bg_up",
			pass_type = "click",
			content_id = "scrollbar_up_hotspot"
		},
		{
			pass_type = "rounded_background",
			style_id = "bg_up"
		},
		{
			style_id = "bg_down",
			pass_type = "hover",
			content_id = "scrollbar_down_hotspot"
		},
		{
			style_id = "bg_down",
			pass_type = "click",
			content_id = "scrollbar_down_hotspot"
		},
		{
			pass_type = "rounded_background",
			style_id = "bg_down"
		},
		{
			pass_type = "on_click",
			click_check_content_id = "scrollbar_down_hotspot",
			click_function = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				arg_39_2.internal_scroll_value = math.max(0, arg_39_2.internal_scroll_value - arg_39_2.scroll_step_size)
			end
		},
		{
			pass_type = "on_click",
			click_check_content_id = "scrollbar_up_hotspot",
			click_function = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				arg_40_2.internal_scroll_value = math.min(1, arg_40_2.internal_scroll_value + arg_40_2.scroll_step_size)
			end
		},
		{
			style_id = "scrollbar",
			pass_type = "local_offset",
			offset_function = function (arg_41_0, arg_41_1, arg_41_2)
				local var_41_0 = UISceneGraph.get_local_position(arg_41_0, arg_41_1.scenegraph_id)
				local var_41_1 = arg_41_2.scroll_bar_height
				local var_41_2 = var_41_1 / 2
				local var_41_3 = arg_41_2.scroll_offset_min
				local var_41_4 = arg_41_2.scroll_offset_max
				local var_41_5 = math.min(var_41_3 + (var_41_4 - var_41_3) * arg_41_2.internal_scroll_value, var_41_4 - var_41_1)

				var_41_0[2] = var_41_5
				arg_41_2.scroll_value = (var_41_5 - var_41_3) / (var_41_4 - var_41_1 - var_41_3)
			end
		},
		{
			pass_type = "rounded_background",
			style_id = "scrollbar"
		},
		{
			pass_type = "hover",
			style_id = "background"
		},
		{
			style_id = "background",
			pass_type = "held",
			held_function = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				local var_42_0 = UIInverseScaleVectorToResolution(arg_42_3:get("cursor"))
				local var_42_1 = arg_42_1.scenegraph_id
				local var_42_2 = UISceneGraph.get_world_position(arg_42_0, var_42_1)
				local var_42_3 = arg_42_2.scroll_bar_height / 2
				local var_42_4 = var_42_3
				local var_42_5 = var_42_0[2] - var_42_4
				local var_42_6 = UISceneGraph.get_size(arg_42_0, var_42_1)
				local var_42_7 = var_42_5 - var_42_2[2]
				local var_42_8 = var_42_2[2] + var_42_3
				local var_42_9 = arg_42_2.scroll_offset_max
				local var_42_10 = var_42_2[2] + var_42_9 - var_42_3 - arg_42_2.scroll_offset_min
				local var_42_11 = math.clamp(var_42_7, 0, var_42_6[2])

				arg_42_2.internal_scroll_value = math.min(var_42_11 / var_42_6[2], 1)
			end
		}
	}
}
UIElements.StaticTextField = {
	passes = {
		{
			pass_type = "rounded_background",
			style_id = "background"
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text_field"
		}
	}
}
UIElements.TextAreaChat = {
	passes = {
		{
			pass_type = "rounded_background",
			style_id = "background"
		},
		{
			style_id = "text",
			pass_type = "text_area_chat",
			text_id = "text_field"
		}
	}
}
UIElements.StaticText = {
	passes = {
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text_field"
		}
	}
}
UIElements.StaticTextWrappedAroundFields = {
	passes = {
		{
			style_id = "text",
			pass_type = "wrapped_text_around_fields",
			text_id = "text_field"
		}
	}
}
UIElements.LorebookMultipleTexts = {
	passes = {
		{
			style_id = "text",
			pass_type = "lorebook_multiple_texts",
			text_id = "text_field"
		}
	}
}
UIElements.TextButton = {
	passes = {
		{
			pass_type = "hover",
			content_id = "button_text"
		},
		{
			pass_type = "click",
			content_id = "button_text"
		},
		{
			style_id = "text_hover",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (arg_43_0)
				return arg_43_0.button_text.is_hover
			end
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (arg_44_0)
				return not arg_44_0.button_text.is_hover
			end
		}
	}
}
UIElements.RotatedTexture = {
	passes = {
		{
			pass_type = "rotated_texture",
			style_id = "rotating_texture"
		}
	}
}
UIElements.Viewport = {
	passes = {
		{
			pass_type = "viewport",
			style_id = "viewport"
		},
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		}
	}
}
UIElements.Button3States = {
	passes = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			texture_id = "texture_id",
			content_check_function = function (arg_45_0)
				return not arg_45_0.button_hotspot.is_hover and arg_45_0.button_hotspot.is_clicked > 0
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_hover_id",
			content_check_function = function (arg_46_0)
				return arg_46_0.button_hotspot.is_hover and arg_46_0.button_hotspot.is_clicked > 0
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_click_id",
			content_check_function = function (arg_47_0)
				return arg_47_0.button_hotspot.is_clicked == 0 or arg_47_0.button_hotspot.is_selected
			end
		},
		{
			localize = true,
			style_id = "text",
			pass_type = "text",
			text_id = "text_field"
		}
	}
}
UIElements.Button4States = {
	passes = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function (arg_48_0)
				return not arg_48_0.disabled
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_id",
			content_check_function = function (arg_49_0)
				return not arg_49_0.disabled and not arg_49_0.button_hotspot.is_hover and arg_49_0.button_hotspot.is_clicked > 0
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_hover_id",
			content_check_function = function (arg_50_0)
				return not arg_50_0.disabled and arg_50_0.button_hotspot.is_hover and arg_50_0.button_hotspot.is_clicked > 0
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_click_id",
			content_check_function = function (arg_51_0)
				return not arg_51_0.disabled and arg_51_0.button_hotspot.is_clicked == 0 or arg_51_0.button_hotspot.is_selected
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_disabled_id",
			content_check_function = function (arg_52_0)
				return arg_52_0.disabled
			end
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (arg_53_0, arg_53_1)
				if arg_53_1.text_color_disabled and arg_53_1.text_color_enabled then
					if arg_53_0.disabled then
						arg_53_1.text_color = arg_53_1.text_color_disabled
					else
						arg_53_1.text_color = arg_53_1.text_color_enabled
					end
				end

				return true
			end
		}
	}
}
UIElements.Button3StatesNoText = {
	passes = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			texture_id = "texture_id",
			content_check_function = function (arg_54_0)
				return not arg_54_0.button_hotspot.is_hover and arg_54_0.button_hotspot.is_clicked > 0
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_hover_id",
			content_check_function = function (arg_55_0)
				return arg_55_0.button_hotspot.is_hover and arg_55_0.button_hotspot.is_clicked > 0
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_click_id",
			content_check_function = function (arg_56_0)
				return arg_56_0.button_hotspot.is_clicked == 0 or arg_56_0.button_hotspot.is_selected
			end
		}
	}
}

UIElements.GamepadButton = function (arg_57_0)
	return {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				pass_type = "game_pad_connected",
				content_id = "gamepad_button"
			},
			{
				content_id = "gamepad_button",
				pass_type = "gamepad_button_click_" .. arg_57_0,
				content_check_function = function (arg_58_0)
					return arg_58_0.gamepad_connected
				end
			},
			{
				pass_type = "texture",
				texture_id = "texture_id",
				content_check_function = function (arg_59_0)
					return not arg_59_0.button_hotspot.is_hover and arg_59_0.button_hotspot.is_clicked > 0 and arg_59_0.gamepad_button.is_clicked > 0
				end
			},
			{
				pass_type = "texture",
				texture_id = "texture_hover_id",
				content_check_function = function (arg_60_0)
					return arg_60_0.button_hotspot.is_hover and arg_60_0.button_hotspot.is_clicked > 0
				end
			},
			{
				pass_type = "texture",
				texture_id = "texture_click_id",
				content_check_function = function (arg_61_0)
					return arg_61_0.button_hotspot.is_clicked == 0 or arg_61_0.gamepad_button.is_clicked == 0 or arg_61_0.button_hotspot.is_selected
				end
			},
			{
				localize = true,
				style_id = "text",
				pass_type = "text",
				text_id = "text_field"
			},
			{
				localize = false,
				style_id = "button_type_text",
				pass_type = "text",
				text_id = "button_type_text_field",
				content_check_function = function (arg_62_0)
					return arg_62_0.gamepad_button.gamepad_connected
				end
			}
		}
	}
end
