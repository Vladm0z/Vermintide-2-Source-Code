-- chunkname: @scripts/ui/views/ui_calibration_view.lua

local num = 48
local num_2 = 4
local tbl = {
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
			-num / 2,
			num / 2,
			1
		},
		size = {
			num,
			num
		}
	},
	bottom_right_reticule = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			num / 2,
			-num / 2,
			1
		},
		size = {
			num,
			num
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
local tbl_2 = {
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
					num,
					num_2
				},
				offset = {
					0,
					num / 2 - num_2 / 2
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
					num_2,
					num
				},
				offset = {
					num / 2 - num_2 / 2,
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
					num,
					num_2
				},
				offset = {
					0,
					num / 2 - num_2 / 2
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
					num_2,
					num
				},
				offset = {
					num / 2 - num_2 / 2,
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
local tbl_3 = {
	"reset"
}
local tbl_4 = {
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

UICalibrationView.init = function (self)
	-- function 1
	self.ui_scenegraph = UISceneGraph.init_scenegraph(tbl)
	self.background = UIWidget.init(tbl_2.background)
	self.top_left_reticule = UIWidget.init(tbl_2.top_left_reticule)
	self.bottom_right_reticule = UIWidget.init(tbl_2.bottom_right_reticule)

	local tbl_3 = {}

	for i = 1, #tbl_4 do
		tbl_3[i] = UIWidget.init(tbl_4[i])
	end

	self.buttons = tbl_3
end

UICalibrationView.destroy = function (arg_2_0)
	-- function 2
	return
end

UICalibrationView.update = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local ui_scenegraph = self.ui_scenegraph
	local top_left_reticule = self.top_left_reticule
	local bottom_right_reticule = self.bottom_right_reticule

	UIRenderer.begin_pass(arg_3_1, ui_scenegraph, arg_3_2, arg_3_3)
	UIRenderer.draw_widget(arg_3_1, self.background)
	UIRenderer.draw_widget(arg_3_1, top_left_reticule)
	UIRenderer.draw_widget(arg_3_1, bottom_right_reticule)

	for i, v in ipairs(self.buttons) do
		v.content.button_hotspot.disable_button = self.cursor_start_pos ~= nil

		UIRenderer.draw_widget(arg_3_1, v)
	end

	UIRenderer.end_pass(arg_3_1)

	if not top_left_reticule.content.on_pressed then
		local get = arg_3_2:get("cursor")

		self.cursor_start_pos = {
			get.x,
			get.y
		}
		self.start_root = table.clone(UISettings.root_scale)
		self.modifying_retucile = "top_left"
	end

	if not bottom_right_reticule.content.on_pressed then
		local get_2 = arg_3_2:get("cursor")

		self.cursor_start_pos = {
			get_2.x,
			get_2.y
		}
		self.start_root = table.clone(UISettings.root_scale)
		self.modifying_retucile = "bottom_right"
	end

	if not (not self.cursor_start_pos and arg_3_2:get("left_hold")) then
		self:evaluate_new_root_scale(UISettings.root_scale)
		self:save_new_root_scale(UISettings.root_scale)

		self.cursor_start_pos = nil
		self.start_root = nil
		self.modifying_retucile = nil
	end

	if not self.cursor_start_pos then
		local cursor_start_pos = self.cursor_start_pos
		local get_3 = arg_3_2:get("cursor")
		local var_3_7 = cursor_start_pos[1]
		local var_3_8 = get_3[1]
		local res_w = RESOLUTION_LOOKUP.res_w
		local res_h = RESOLUTION_LOOKUP.res_h
		local num = (var_3_8 - var_3_7) / 1920 * 2
		local var_3_12 = cursor_start_pos[2]
		local num_2 = (get_3[2] - var_3_12) / res_h * 2

		if self.modifying_retucile == "bottom_right" then
			num = -1 * num
			num_2 = -1 * num_2
		end

		local num_3 = self.start_root[1] - num
		local num_4 = self.start_root[2] + num_2

		UISettings.root_scale[1] = self.start_root[1] - num
		UISettings.root_scale[2] = self.start_root[2] + num_2
	end

	for i_2, v_2 in ipairs(self.buttons) do
		if not (not v_2.content.button_hotspot.on_release and tbl_3[i_2] ~= "reset") then
			self:reset_root_scale()
		end
	end
end

UICalibrationView.reset_root_scale = function (self)
	-- function 4
	UISettings.root_scale[1] = 1
	UISettings.root_scale[2] = 1

	self:save_new_root_scale(UISettings.root_scale)
end

UICalibrationView.evaluate_new_root_scale = function (arg_5_0, arg_5_1)
	-- function 5
	local resolution, var_5_1 = Application.resolution()
	local var_5_2 = arg_5_1[1]

	if var_5_2 > 1 then
		local num = 1920 * var_5_2

		if resolution < num then
			var_5_2 = var_5_2 - (num - resolution) / resolution
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
	-- function 6
	Application.set_user_setting("root_scale_x", arg_6_1[1])
	Application.set_user_setting("root_scale_y", arg_6_1[2])
	Application.save_user_settings()
end
