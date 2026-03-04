-- chunkname: @scripts/ui/views/ui_calibration_view.lua

local var_0_0 = 48
local var_0_1 = 4
local var_0_2 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			900
		},
		size = {
			1920,
			1080
		}
	},
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			900
		},
		size = {
			1920,
			1080
		}
	},
	top_left_reticule = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "left",
		position = {
			-var_0_0 / 2,
			var_0_0 / 2,
			1
		},
		size = {
			var_0_0,
			var_0_0
		}
	},
	bottom_right_reticule = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			var_0_0 / 2,
			-var_0_0 / 2,
			1
		},
		size = {
			var_0_0,
			var_0_0
		}
	},
	reset_button = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			220,
			62
		}
	}
}
local var_0_3 = {
	top_left_reticule = {
		scenegraph_id = "top_left_reticule",
		element = {
			passes = {
				{
					pass_type = "hotspot"
				},
				{
					pass_type = "rect",
					style_id = "horizontal"
				},
				{
					pass_type = "rect",
					style_id = "vertical"
				}
			}
		},
		content = {},
		style = {
			horizontal = {
				color = {
					255,
					0,
					255,
					0
				},
				size = {
					var_0_0,
					var_0_1
				},
				offset = {
					0,
					var_0_0 / 2 - var_0_1 / 2
				}
			},
			vertical = {
				color = {
					255,
					0,
					255,
					0
				},
				size = {
					var_0_1,
					var_0_0
				},
				offset = {
					var_0_0 / 2 - var_0_1 / 2,
					0
				}
			}
		}
	},
	bottom_right_reticule = {
		scenegraph_id = "bottom_right_reticule",
		element = {
			passes = {
				{
					pass_type = "hotspot"
				},
				{
					pass_type = "rect",
					style_id = "horizontal"
				},
				{
					pass_type = "rect",
					style_id = "vertical"
				}
			}
		},
		content = {},
		style = {
			horizontal = {
				color = {
					255,
					255,
					0,
					0
				},
				size = {
					var_0_0,
					var_0_1
				},
				offset = {
					0,
					var_0_0 / 2 - var_0_1 / 2
				}
			},
			vertical = {
				color = {
					255,
					255,
					0,
					0
				},
				size = {
					var_0_1,
					var_0_0
				},
				offset = {
					var_0_0 / 2 - var_0_1 / 2,
					0
				}
			}
		}
	},
	background = {
		scenegraph_id = "screen",
		element = {
			passes = {
				{
					pass_type = "rect"
				}
			}
		},
		content = {},
		style = {
			color = {
				255,
				0,
				0,
				0
			}
		}
	}
}
local var_0_4 = {
	"reset"
}
local var_0_5 = {
	{
		scenegraph_id = "reset_button",
		element = UIElements.Button3States,
		content = {
			texture_click_id = "small_button_selected",
			texture_id = "small_button_normal",
			texture_hover_id = "small_button_hover",
			text_field = Localize("menu_settings_reset_to_default"),
			button_hotspot = {}
		},
		style = {
			text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("cheeseburger", 255),
				offset = {
					0,
					0,
					2
				}
			}
		}
	}
}

UICalibrationView = class(UICalibrationView)

UICalibrationView.init = function (arg_1_0)
	arg_1_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_1_0.background = UIWidget.init(var_0_3.background)
	arg_1_0.top_left_reticule = UIWidget.init(var_0_3.top_left_reticule)
	arg_1_0.bottom_right_reticule = UIWidget.init(var_0_3.bottom_right_reticule)

	local var_1_0 = {}

	for iter_1_0 = 1, #var_0_5 do
		var_1_0[iter_1_0] = UIWidget.init(var_0_5[iter_1_0])
	end

	arg_1_0.buttons = var_1_0
end

UICalibrationView.destroy = function (arg_2_0)
	return
end

UICalibrationView.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_0.ui_scenegraph
	local var_3_1 = arg_3_0.top_left_reticule
	local var_3_2 = arg_3_0.bottom_right_reticule

	UIRenderer.begin_pass(arg_3_1, var_3_0, arg_3_2, arg_3_3)
	UIRenderer.draw_widget(arg_3_1, arg_3_0.background)
	UIRenderer.draw_widget(arg_3_1, var_3_1)
	UIRenderer.draw_widget(arg_3_1, var_3_2)

	for iter_3_0, iter_3_1 in ipairs(arg_3_0.buttons) do
		iter_3_1.content.button_hotspot.disable_button = arg_3_0.cursor_start_pos ~= nil

		UIRenderer.draw_widget(arg_3_1, iter_3_1)
	end

	UIRenderer.end_pass(arg_3_1)

	if var_3_1.content.on_pressed then
		local var_3_3 = arg_3_2:get("cursor")

		arg_3_0.cursor_start_pos = {
			var_3_3.x,
			var_3_3.y
		}
		arg_3_0.start_root = table.clone(UISettings.root_scale)
		arg_3_0.modifying_retucile = "top_left"
	end

	if var_3_2.content.on_pressed then
		local var_3_4 = arg_3_2:get("cursor")

		arg_3_0.cursor_start_pos = {
			var_3_4.x,
			var_3_4.y
		}
		arg_3_0.start_root = table.clone(UISettings.root_scale)
		arg_3_0.modifying_retucile = "bottom_right"
	end

	if arg_3_0.cursor_start_pos and not arg_3_2:get("left_hold") then
		arg_3_0:evaluate_new_root_scale(UISettings.root_scale)
		arg_3_0:save_new_root_scale(UISettings.root_scale)

		arg_3_0.cursor_start_pos = nil
		arg_3_0.start_root = nil
		arg_3_0.modifying_retucile = nil
	end

	if arg_3_0.cursor_start_pos then
		local var_3_5 = arg_3_0.cursor_start_pos
		local var_3_6 = arg_3_2:get("cursor")
		local var_3_7 = var_3_5[1]
		local var_3_8 = var_3_6[1]
		local var_3_9 = RESOLUTION_LOOKUP.res_w
		local var_3_10 = RESOLUTION_LOOKUP.res_h
		local var_3_11 = (var_3_8 - var_3_7) / 1920 * 2
		local var_3_12 = var_3_5[2]
		local var_3_13 = (var_3_6[2] - var_3_12) / var_3_10 * 2

		if arg_3_0.modifying_retucile == "bottom_right" then
			var_3_11 = -1 * var_3_11
			var_3_13 = -1 * var_3_13
		end

		local var_3_14 = arg_3_0.start_root[1] - var_3_11
		local var_3_15 = arg_3_0.start_root[2] + var_3_13

		UISettings.root_scale[1] = arg_3_0.start_root[1] - var_3_11
		UISettings.root_scale[2] = arg_3_0.start_root[2] + var_3_13
	end

	for iter_3_2, iter_3_3 in ipairs(arg_3_0.buttons) do
		if iter_3_3.content.button_hotspot.on_release and var_0_4[iter_3_2] == "reset" then
			arg_3_0:reset_root_scale()
		end
	end
end

UICalibrationView.reset_root_scale = function (arg_4_0)
	UISettings.root_scale[1] = 1
	UISettings.root_scale[2] = 1

	arg_4_0:save_new_root_scale(UISettings.root_scale)
end

UICalibrationView.evaluate_new_root_scale = function (arg_5_0, arg_5_1)
	local var_5_0, var_5_1 = Application.resolution()
	local var_5_2 = arg_5_1[1]

	if var_5_2 > 1 then
		local var_5_3 = 1920 * var_5_2

		if var_5_0 < var_5_3 then
			var_5_2 = var_5_2 - (var_5_3 - var_5_0) / var_5_0
		end
	elseif var_5_2 < 0.2 then
		var_5_2 = 0.2
	end

	local var_5_4 = arg_5_1[2]

	if var_5_4 > 1 then
		var_5_4 = 1
	elseif var_5_4 < 0.2 then
		var_5_4 = 0.2
	end

	arg_5_1[1] = var_5_2
	arg_5_1[2] = var_5_4
end

UICalibrationView.save_new_root_scale = function (arg_6_0, arg_6_1)
	Application.set_user_setting("root_scale_x", arg_6_1[1])
	Application.set_user_setting("root_scale_y", arg_6_1[2])
	Application.save_user_settings()
end
