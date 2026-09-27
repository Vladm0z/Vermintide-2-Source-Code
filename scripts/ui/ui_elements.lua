-- chunkname: @scripts/ui/ui_elements.lua

require("scripts/ui/ui_layer")

UIElements = {}
UIElements.ButtonMenuSteps = {
	passes = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function (self)
				-- function 1
				return not self.disabled
			end
		},
		{
			texture_id = "texture_id",
			style_id = "texture",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 2
				local button_hotspot = self.button_hotspot

				return not not button_hotspot.disabled or not not button_hotspot.is_hover or not (button_hotspot.is_clicked > 0) or not button_hotspot.is_selected
			end
		},
		{
			texture_id = "texture_hover_id",
			style_id = "texture",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 3
				local button_hotspot = self.button_hotspot
				local is_hover

				if not (button_hotspot.disabled or button_hotspot.is_selected) then
					is_hover = button_hotspot.is_hover

					if not is_hover then
						-- Nothing
					end

					if not (button_hotspot.is_clicked > 0) then
						-- Nothing
					end
				end

				is_hover = false

				goto label_3_1

				::label_3_0::

				is_hover = true

				::label_3_1::

				return is_hover
			end
		},
		{
			texture_id = "texture_click_id",
			style_id = "texture",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 4
				local button_hotspot = self.button_hotspot

				return not not button_hotspot.disabled or button_hotspot.is_clicked == 0
			end
		},
		{
			texture_id = "texture_selected_id",
			style_id = "texture",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 5
				local button_hotspot = self.button_hotspot
				local is_selected

				if not button_hotspot.disabled then
					is_selected = button_hotspot.is_selected

					if not is_selected then
						-- Nothing
					end

					if not (button_hotspot.is_clicked > 0) then
						-- Nothing
					end
				end

				is_selected = false

				goto label_5_1

				::label_5_0::

				is_selected = true

				::label_5_1::

				return is_selected
			end
		},
		{
			texture_id = "texture_disabled_id",
			style_id = "texture",
			pass_type = "texture",
			content_check_function = function (self)
				-- function 6
				return self.button_hotspot.disabled
			end
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (self)
				-- function 7
				local button_hotspot = self.button_hotspot

				return not not button_hotspot.disabled or not not button_hotspot.is_hover or not not button_hotspot.is_selected or button_hotspot.is_clicked > 0
			end
		},
		{
			style_id = "text_hover",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (self)
				-- function 8
				local button_hotspot = self.button_hotspot
				local is_hover

				if not (button_hotspot.disabled or button_hotspot.is_selected) then
					is_hover = button_hotspot.is_hover

					if not is_hover then
						-- Nothing
					end

					if not (button_hotspot.is_clicked > 0) then
						-- Nothing
					end
				end

				is_hover = false

				goto label_8_1

				::label_8_0::

				is_hover = true

				::label_8_1::

				return is_hover
			end
		},
		{
			style_id = "text_selected",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (self)
				-- function 9
				local button_hotspot = self.button_hotspot
				local is_selected

				if not button_hotspot.disabled then
					is_selected = button_hotspot.is_selected

					if not is_selected then
						-- Nothing
					end

					if button_hotspot.is_clicked ~= 0 then
						-- Nothing
					end
				end

				is_selected = false

				goto label_9_1

				::label_9_0::

				is_selected = true

				::label_9_1::

				return is_selected
			end
		},
		{
			style_id = "text_disabled",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (self)
				-- function 10
				return self.button_hotspot.disabled
			end
		}
	}
}
UIElements.ButtonMenuStepsWithTimer = {
	passes = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function (self)
				-- function 11
				return not self.disabled
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_id",
			content_check_function = function (self)
				-- function 12
				local button_hotspot = self.button_hotspot

				return not not button_hotspot.disabled or not not button_hotspot.is_hover or not (button_hotspot.is_clicked > 0) or not button_hotspot.is_selected
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_hover_id",
			content_check_function = function (self)
				-- function 13
				local button_hotspot = self.button_hotspot
				local is_hover

				if not (button_hotspot.disabled or button_hotspot.is_selected) then
					is_hover = button_hotspot.is_hover

					if not is_hover then
						-- Nothing
					end

					if not (button_hotspot.is_clicked > 0) then
						-- Nothing
					end
				end

				is_hover = false

				goto label_13_1

				::label_13_0::

				is_hover = true

				::label_13_1::

				return is_hover
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_click_id",
			content_check_function = function (self)
				-- function 14
				local button_hotspot = self.button_hotspot

				return not not button_hotspot.disabled or button_hotspot.is_clicked == 0
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_selected_id",
			content_check_function = function (self)
				-- function 15
				local button_hotspot = self.button_hotspot
				local is_selected

				if not button_hotspot.disabled then
					is_selected = button_hotspot.is_selected

					if not is_selected then
						-- Nothing
					end

					if not (button_hotspot.is_clicked > 0) then
						-- Nothing
					end
				end

				is_selected = false

				goto label_15_1

				::label_15_0::

				is_selected = true

				::label_15_1::

				return is_selected
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_disabled_id",
			content_check_function = function (self)
				-- function 16
				return self.button_hotspot.disabled
			end
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (self)
				-- function 17
				local button_hotspot = self.button_hotspot

				return not not button_hotspot.disabled or not not button_hotspot.is_hover or not not button_hotspot.is_selected or button_hotspot.is_clicked > 0
			end
		},
		{
			style_id = "text_hover",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (self)
				-- function 18
				local button_hotspot = self.button_hotspot
				local is_hover

				if not (button_hotspot.disabled or button_hotspot.is_selected) then
					is_hover = button_hotspot.is_hover

					if not is_hover then
						-- Nothing
					end

					if not (button_hotspot.is_clicked > 0) then
						-- Nothing
					end
				end

				is_hover = false

				goto label_18_1

				::label_18_0::

				is_hover = true

				::label_18_1::

				return is_hover
			end
		},
		{
			style_id = "text_selected",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (self)
				-- function 19
				local button_hotspot = self.button_hotspot
				local is_selected

				if not button_hotspot.disabled then
					is_selected = button_hotspot.is_selected

					if not is_selected then
						-- Nothing
					end

					if button_hotspot.is_clicked ~= 0 then
						-- Nothing
					end
				end

				is_selected = false

				goto label_19_1

				::label_19_0::

				is_selected = true

				::label_19_1::

				return is_selected
			end
		},
		{
			style_id = "text_disabled",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (self)
				-- function 20
				return self.button_hotspot.disabled
			end
		},
		{
			style_id = "timer_text_field",
			pass_type = "text",
			text_id = "timer_text_field",
			content_check_function = function (self)
				-- function 21
				local button_hotspot = self.button_hotspot

				return not not button_hotspot.disabled or not not button_hotspot.is_hover or not not button_hotspot.is_selected or button_hotspot.is_clicked > 0
			end
		},
		{
			style_id = "timer_text_field_hover",
			pass_type = "text",
			text_id = "timer_text_field",
			content_check_function = function (self)
				-- function 22
				local button_hotspot = self.button_hotspot
				local is_hover

				if not (button_hotspot.disabled or button_hotspot.is_selected) then
					is_hover = button_hotspot.is_hover

					if not is_hover then
						-- Nothing
					end

					if not (button_hotspot.is_clicked > 0) then
						-- Nothing
					end
				end

				is_hover = false

				goto label_22_1

				::label_22_0::

				is_hover = true

				::label_22_1::

				return is_hover
			end
		},
		{
			style_id = "timer_text_field_selected",
			pass_type = "text",
			text_id = "timer_text_field",
			content_check_function = function (self)
				-- function 23
				local button_hotspot = self.button_hotspot
				local is_selected

				if not button_hotspot.disabled then
					is_selected = button_hotspot.is_selected

					if not is_selected then
						-- Nothing
					end

					if button_hotspot.is_clicked ~= 0 then
						-- Nothing
					end
				end

				is_selected = false

				goto label_23_1

				::label_23_0::

				is_selected = true

				::label_23_1::

				return is_selected
			end
		},
		{
			style_id = "timer_text_field_disabled",
			pass_type = "text",
			text_id = "timer_text_field",
			content_check_function = function (self)
				-- function 24
				return self.button_hotspot.disabled
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
			content_check_function = function (self)
				-- function 25
				return not self.button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "hover_texture",
			texture_id = "hover_texture",
			content_check_function = function (self)
				-- function 26
				local button_hotspot = self.button_hotspot
				local is_hover = button_hotspot.is_hover

				is_hover = not is_hover and button_hotspot.is_clicked ~= 0

				return is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "click_texture",
			texture_id = "click_texture",
			content_check_function = function (self)
				-- function 27
				local button_hotspot = self.button_hotspot
				local is_hover = button_hotspot.is_hover

				is_hover = not is_hover and button_hotspot.is_clicked == 0

				return is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "toggle_texture",
			texture_id = "toggle_texture",
			content_check_function = function (self)
				-- function 28
				local button_hotspot = self.button_hotspot
				local toggled = self.toggled

				toggled = not toggled and not button_hotspot.is_hover

				return toggled
			end
		},
		{
			pass_type = "texture",
			style_id = "toggle_hover_texture",
			texture_id = "toggle_hover_texture",
			content_check_function = function (self)
				-- function 29
				local button_hotspot = self.button_hotspot
				local toggled = self.toggled

				if not toggled then
					toggled = button_hotspot.is_hover
					toggled = not toggled and button_hotspot.is_clicked ~= 0
				end

				return toggled
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_texture",
			texture_id = "icon_texture",
			content_check_function = function (self)
				-- function 30
				return not not self.button_hotspot.is_hover or not self.toggled
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_hover_texture",
			texture_id = "icon_hover_texture",
			content_check_function = function (self)
				-- function 31
				local button_hotspot = self.button_hotspot
				local toggled

				if not button_hotspot.is_hover then
					toggled = self.toggled

					if not toggled then
						-- Nothing
					end
				end

				toggled = button_hotspot.is_clicked ~= 0

				::label_31_0::

				return toggled
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_click_texture",
			texture_id = "icon_texture",
			content_check_function = function (self)
				-- function 32
				local button_hotspot = self.button_hotspot
				local is_hover = button_hotspot.is_hover

				is_hover = not is_hover and button_hotspot.is_clicked == 0

				return is_hover
			end
		},
		{
			style_id = "tooltip_text",
			pass_type = "tooltip_text",
			text_id = "tooltip_text",
			content_check_function = function (self)
				-- function 33
				local button_hotspot = self.button_hotspot
				local is_hover

				if not self.toggled then
					is_hover = button_hotspot.is_hover

					if not is_hover then
						-- Nothing
					end

					if button_hotspot.is_clicked == 0 then
						-- Nothing
					end
				end

				is_hover = false

				goto label_33_1

				::label_33_0::

				is_hover = true

				::label_33_1::

				return is_hover
			end
		},
		{
			style_id = "tooltip_text",
			pass_type = "tooltip_text",
			text_id = "toggled_tooltip_text",
			content_check_function = function (self)
				-- function 34
				local button_hotspot = self.button_hotspot
				local toggled = self.toggled

				if not toggled then
					toggled = button_hotspot.is_hover
					toggled = not toggled and button_hotspot.is_clicked == 0
				end

				return toggled
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
			content_check_function = function (self)
				-- function 35
				return not self.button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_hover_id",
			content_check_function = function (self)
				-- function 36
				return self.button_hotspot.is_hover
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
			content_check_function = function (self)
				-- function 37
				return not self.button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_hover_id",
			content_check_function = function (self)
				-- function 38
				return self.button_hotspot.is_hover
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
				-- function 39
				arg_39_2.internal_scroll_value = math.max(0, arg_39_2.internal_scroll_value - arg_39_2.scroll_step_size)
			end
		},
		{
			pass_type = "on_click",
			click_check_content_id = "scrollbar_up_hotspot",
			click_function = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				arg_40_2.internal_scroll_value = math.min(1, arg_40_2.internal_scroll_value + arg_40_2.scroll_step_size)
			end
		},
		{
			style_id = "scrollbar",
			pass_type = "local_offset",
			offset_function = function (arg_41_0, arg_41_1, arg_41_2)
				-- function 41
				local get_local_position = UISceneGraph.get_local_position(arg_41_0, arg_41_1.scenegraph_id)
				local scroll_bar_height = arg_41_2.scroll_bar_height
				local num = scroll_bar_height / 2
				local scroll_offset_min = arg_41_2.scroll_offset_min
				local scroll_offset_max = arg_41_2.scroll_offset_max
				local min = math.min(scroll_offset_min + (scroll_offset_max - scroll_offset_min) * arg_41_2.internal_scroll_value, scroll_offset_max - scroll_bar_height)

				get_local_position[2] = min
				arg_41_2.scroll_value = (min - scroll_offset_min) / (scroll_offset_max - scroll_bar_height - scroll_offset_min)
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
				-- function 42
				local var_42_0 = UIInverseScaleVectorToResolution(arg_42_3:get("cursor"))
				local scenegraph_id = arg_42_1.scenegraph_id
				local get_world_position = UISceneGraph.get_world_position(arg_42_0, scenegraph_id)
				local num = arg_42_2.scroll_bar_height / 2
				local var_42_4 = num
				local num_2 = var_42_0[2] - var_42_4
				local get_size = UISceneGraph.get_size(arg_42_0, scenegraph_id)
				local num_3 = num_2 - get_world_position[2]
				local num_4 = get_world_position[2] + num
				local scroll_offset_max = arg_42_2.scroll_offset_max
				local num_5 = get_world_position[2] + scroll_offset_max - num - arg_42_2.scroll_offset_min
				local clamp = math.clamp(num_3, 0, get_size[2])

				arg_42_2.internal_scroll_value = math.min(clamp / get_size[2], 1)
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
			content_check_function = function (self)
				-- function 43
				return self.button_text.is_hover
			end
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (self)
				-- function 44
				return not self.button_text.is_hover
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
			content_check_function = function (self)
				-- function 45
				return not not self.button_hotspot.is_hover or self.button_hotspot.is_clicked > 0
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_hover_id",
			content_check_function = function (self)
				-- function 46
				local is_hover = self.button_hotspot.is_hover

				is_hover = not is_hover and self.button_hotspot.is_clicked > 0

				return is_hover
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_click_id",
			content_check_function = function (self)
				-- function 47
				return self.button_hotspot.is_clicked == 0 or self.button_hotspot.is_selected
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
			content_check_function = function (self)
				-- function 48
				return not self.disabled
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_id",
			content_check_function = function (self)
				-- function 49
				return not not self.disabled or not not self.button_hotspot.is_hover or self.button_hotspot.is_clicked > 0
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_hover_id",
			content_check_function = function (self)
				-- function 50
				local is_hover

				if not self.disabled then
					is_hover = self.button_hotspot.is_hover

					if not is_hover then
						-- Nothing
					end

					if not (self.button_hotspot.is_clicked > 0) then
						-- Nothing
					end
				end

				is_hover = false

				goto label_50_1

				::label_50_0::

				is_hover = true

				::label_50_1::

				return is_hover
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_click_id",
			content_check_function = function (self)
				-- function 51
				return (self.disabled or self.button_hotspot.is_clicked ~= 0) and self.button_hotspot.is_selected
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_disabled_id",
			content_check_function = function (self)
				-- function 52
				return self.disabled
			end
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text_field",
			content_check_function = function (self, arg_53_1)
				-- function 53
				if not arg_53_1.text_color_disabled and not arg_53_1.text_color_enabled then
					if not self.disabled then
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
			content_check_function = function (self)
				-- function 54
				return not not self.button_hotspot.is_hover or self.button_hotspot.is_clicked > 0
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_hover_id",
			content_check_function = function (self)
				-- function 55
				local is_hover = self.button_hotspot.is_hover

				is_hover = not is_hover and self.button_hotspot.is_clicked > 0

				return is_hover
			end
		},
		{
			pass_type = "texture",
			texture_id = "texture_click_id",
			content_check_function = function (self)
				-- function 56
				return self.button_hotspot.is_clicked == 0 or self.button_hotspot.is_selected
			end
		}
	}
}

UIElements.GamepadButton = function (arg_57_0)
	-- function 57
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
				content_check_function = function (self)
					-- function 58
					return self.gamepad_connected
				end
			},
			{
				pass_type = "texture",
				texture_id = "texture_id",
				content_check_function = function (self)
					-- function 59
					return not not self.button_hotspot.is_hover or not (self.button_hotspot.is_clicked > 0) or self.gamepad_button.is_clicked > 0
				end
			},
			{
				pass_type = "texture",
				texture_id = "texture_hover_id",
				content_check_function = function (self)
					-- function 60
					local is_hover = self.button_hotspot.is_hover

					is_hover = not is_hover and self.button_hotspot.is_clicked > 0

					return is_hover
				end
			},
			{
				pass_type = "texture",
				texture_id = "texture_click_id",
				content_check_function = function (self)
					-- function 61
					return self.button_hotspot.is_clicked == 0 or self.gamepad_button.is_clicked == 0 or self.button_hotspot.is_selected
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
				content_check_function = function (self)
					-- function 62
					return self.gamepad_button.gamepad_connected
				end
			}
		}
	}
end
