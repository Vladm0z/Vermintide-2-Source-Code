-- chunkname: @scripts/ui/views/menu_information_slate_ui_definitions.lua

local num = 590
local tbl = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default + 1
		}
	},
	area = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	switch_panel = {
		vertical_alignment = "top",
		parent = "area",
		horizontal_alignment = "right",
		size = {
			0,
			64
		},
		position = {
			-50,
			-50,
			0
		}
	},
	panel = {
		vertical_alignment = "top",
		parent = "area",
		horizontal_alignment = "right",
		size = {
			475,
			800
		},
		position = {
			-50,
			-50,
			0
		}
	},
	top_panel = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			475,
			210
		},
		position = {
			0,
			0,
			0
		}
	},
	panel_mask = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "right",
		size = {
			475,
			0
		},
		position = {
			0,
			-210,
			0
		}
	},
	top_banner = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			475,
			3
		},
		position = {
			0,
			0,
			1
		}
	},
	dot = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			44,
			44
		},
		position = {
			10,
			-20,
			1
		}
	},
	alert_name = {
		vertical_alignment = "center",
		parent = "dot",
		horizontal_alignment = "right",
		position = {
			0,
			0,
			0
		},
		size = {
			0,
			28
		}
	},
	header = {
		vertical_alignment = "bottom",
		parent = "top_panel",
		horizontal_alignment = "left",
		position = {
			20,
			85,
			1
		},
		size = {
			440,
			300
		}
	},
	sub_header = {
		vertical_alignment = "bottom",
		parent = "header",
		horizontal_alignment = "left",
		position = {
			0,
			-15,
			0
		},
		size = {
			440,
			25
		}
	},
	information = {
		vertical_alignment = "bottom",
		parent = "top_panel",
		horizontal_alignment = "left",
		position = {
			20,
			50,
			1
		},
		size = {
			0,
			0
		}
	},
	triangle = {
		vertical_alignment = "bottom",
		parent = "top_panel",
		horizontal_alignment = "left",
		position = {
			180,
			33,
			1
		},
		size = {
			0,
			0
		}
	},
	body = {
		vertical_alignment = "top",
		parent = "top_panel",
		horizontal_alignment = "left",
		position = {
			20,
			-210,
			1
		},
		size = {
			425,
			0
		}
	},
	body_anchor = {
		parent = "body"
	},
	scrollbar_anchor = {
		vertical_alignment = "top",
		parent = "top_panel",
		horizontal_alignment = "left",
		position = {
			20,
			-210,
			1
		},
		size = {
			435,
			550
		}
	},
	scrolbar_window = {
		parent = "scrollbar_anchor",
		size = {
			435,
			550
		}
	}
}
local tbl_2 = {
	vertical_alignment = "top",
	upper_case = true,
	localize = false,
	horizontal_alignment = "left",
	font_size = 25,
	font_type = "hell_shark_header",
	text_color = {
		255,
		164,
		164,
		164
	},
	offset = {
		0,
		0,
		0
	}
}
local tbl_3 = {
	font_size = 56,
	upper_case = true,
	localize = false,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = {
		255,
		192,
		192,
		192
	},
	offset = {
		0,
		0,
		0
	}
}
local tbl_4 = {
	font_size = 25,
	upper_case = false,
	localize = false,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = {
		255,
		192,
		192,
		192
	},
	offset = {
		0,
		0,
		0
	}
}
local tbl_5 = {
	font_size = 25,
	upper_case = false,
	localize = false,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = {
		255,
		128,
		128,
		128
	},
	base_color = {
		255,
		128,
		128,
		128
	},
	hover_color = {
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
}
local tbl_6 = {
	font_size = 25,
	upper_case = false,
	localize = false,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_masked",
	text_color = {
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
}
local tbl_7 = {
	text = {
		spacing = 25,
		default_text_style = tbl_6
	},
	image = {
		spacing = 25
	}
}

function create_hotspot_text(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	return {
		element = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_change_function = function (self, arg_2_1)
						-- function 2
						if not self.hotspot.is_hover then
							arg_2_1.text_color = arg_2_1.hover_color
						else
							arg_2_1.text_color = arg_2_1.base_color
						end
					end
				}
			}
		},
		content = {
			hotspot = {},
			text = arg_1_0
		},
		style = {
			text = arg_1_2,
			hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				area_size = {
					435,
					60
				},
				offset = {
					0,
					-50,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_1
	}
end

function create_gamepad_input(arg_3_0, arg_3_1)
	-- function 3
	local tbl = {
		element = {
			passes = {
				{
					texture_id = "xb_input",
					style_id = "texture_id",
					pass_type = "texture",
					content_check_function = function (arg_4_0, arg_4_1)
						-- function 4
						local is_device_active = Managers.input:is_device_active("gamepad")
						local use_ps4_input_icons = UISettings.use_ps4_input_icons

						use_ps4_input_icons = Managers.input:get_most_recent_device().type() == "sce_pad" or use_ps4_input_icons

						return not is_device_active and not use_ps4_input_icons
					end
				},
				{
					texture_id = "ps_input",
					style_id = "texture_id",
					pass_type = "texture",
					content_check_function = function (arg_5_0, arg_5_1)
						-- function 5
						local is_device_active = Managers.input:is_device_active("gamepad")
						local use_ps4_input_icons = UISettings.use_ps4_input_icons

						use_ps4_input_icons = Managers.input:get_most_recent_device().type() == "sce_pad" or use_ps4_input_icons

						return not is_device_active and use_ps4_input_icons
					end
				}
			}
		}
	}
	local tbl_2 = {}
	local flag

	flag = not IS_CONSOLE and "xbone_button_icon_menu_large" and "xbone_button_icon_x"
	tbl_2.xb_input = flag

	local flag_2

	flag_2 = not IS_CONSOLE and "ps4_button_icon_options" and "ps4_button_icon_square"
	tbl_2.ps_input = flag_2
	tbl.content = tbl_2
	tbl.style = {
		texture_id = {
			texture_size = {
				34,
				34
			},
			color = arg_3_1 or {
				255,
				255,
				255,
				255
			},
			offset = {
				-12,
				-17,
				1
			}
		}
	}
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_3_0

	return tbl
end

local function fn(self)
	-- function 6
	local count = #self
	local tbl = {}
	local tbl_2 = {
		passes = {}
	}
	local passes = tbl_2.passes
	local tbl_3 = {}
	local tbl_4 = {}

	passes[#passes + 1] = {
		style_id = "right_arrow",
		pass_type = "texture_uv",
		content_id = "right_arrow",
		content_check_function = function (arg_7_0, arg_7_1)
			-- function 7
			return not Managers.input:is_device_active("gamepad")
		end,
		content_change_function = function (self, arg_8_1)
			-- function 8
			local flag

			flag = not self.parent.right_arrow_hotspot.is_hover and 1 and 0.6
			arg_8_1.color[2] = 255 * flag
			arg_8_1.color[3] = 255 * flag
			arg_8_1.color[4] = 255 * flag
		end
	}
	passes[#passes + 1] = {
		style_id = "right_arrow",
		pass_type = "hotspot",
		content_id = "right_arrow_hotspot"
	}
	passes[#passes + 1] = {
		style_id = "right_shoulder",
		texture_id = "right_shoulder",
		pass_type = "texture",
		content_check_function = function (arg_9_0, arg_9_1)
			-- function 9
			return (Managers.input:is_device_active("gamepad"))
		end,
		content_change_function = function (self, arg_10_1)
			-- function 10
			if IS_PS4 or not IS_XB1 then
				return
			end

			local use_ps4_input_icons = UISettings.use_ps4_input_icons
			local input = Managers.input

			input = not input and Managers.input:get_most_recent_device()
			use_ps4_input_icons = not input and input.type() == "sce_pad" and use_ps4_input_icons

			local flag

			flag = not use_ps4_input_icons and "ps4_button_icon_r1" and "xbone_button_icon_rb"
			self.right_shoulder = flag
		end
	}
	tbl_4.right_arrow = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		area_size = {
			30,
			30
		},
		texture_size = {
			12,
			16
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_4.right_shoulder = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			36,
			26
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_3.right_arrow_hotspot = {}
	tbl_3.right_arrow = {
		texture_id = "info_slate_arrow",
		uvs = {
			{
				1,
				0
			},
			{
				0,
				1
			}
		}
	}

	local flag

	flag = not IS_PS4 and "ps4_button_icon_r1" and "xbone_button_icon_rb"
	tbl_3.right_shoulder = flag
	tbl_3.current_index = nil

	local tbl_5 = {
		16,
		16
	}
	local num = 8
	local num_2 = -28

	for i = count, 1, -1 do
		local var_6_10 = self[i]
		local str = "slate_" .. i

		passes[#passes + 1] = {
			pass_type = "rect",
			content_id = str,
			style_id = str,
			content_change_function = function (self, arg_11_1)
				-- function 11
				local alert_color = arg_11_1.alert_color
				local var_11_1 = self.parent[str .. "_hotspot"]
				local is_hover = var_11_1.is_hover

				is_hover = is_hover or self.index == self.parent.current_index

				local flag

				flag = not var_11_1.is_hover and 1 and 0.8
				arg_11_1.color[1] = 255

				local color = arg_11_1.color
				local var_11_5

				if not is_hover then
					var_11_5 = alert_color[2]

					if not var_11_5 then
						-- Nothing
					end
				end

				var_11_5 = 255

				::label_11_0::

				color[2] = var_11_5 * flag

				local color_2 = arg_11_1.color
				local var_11_7

				if not is_hover then
					var_11_7 = alert_color[3]

					if not var_11_7 then
						-- Nothing
					end
				end

				var_11_7 = 255

				::label_11_1::

				color_2[3] = var_11_7 * flag

				local color_3 = arg_11_1.color
				local var_11_9

				if not is_hover then
					var_11_9 = alert_color[4]

					if not var_11_9 then
						-- Nothing
					end
				end

				var_11_9 = 255

				::label_11_2::

				color_3[4] = var_11_9 * flag
			end
		}
		passes[#passes + 1] = {
			pass_type = "hotspot",
			content_id = str .. "_hotspot",
			style_id = str
		}
		tbl_3[str .. "_hotspot"] = {}
		tbl_3[str] = {
			index = i
		}
		tbl_4[str] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			alert_color = var_6_10.alert_color,
			texture_size = tbl_5,
			area_size = {
				tbl_5[1] * 1.5,
				tbl_5[2] * 1.5
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				num_2,
				0,
				0
			}
		}
		num_2 = num_2 - tbl_5[1] - num
	end

	local num_3 = num_2 - 4

	passes[#passes + 1] = {
		style_id = "left_arrow",
		texture_id = "left_arrow",
		pass_type = "texture",
		content_check_function = function (arg_12_0, arg_12_1)
			-- function 12
			return not Managers.input:is_device_active("gamepad")
		end,
		content_change_function = function (self, arg_13_1)
			-- function 13
			local flag

			flag = not self.left_arrow_hotspot.is_hover and 1 and 0.6
			arg_13_1.color[2] = 255 * flag
			arg_13_1.color[3] = 255 * flag
			arg_13_1.color[4] = 255 * flag
		end
	}
	passes[#passes + 1] = {
		style_id = "left_shoulder",
		texture_id = "left_shoulder",
		pass_type = "texture",
		content_check_function = function (arg_14_0, arg_14_1)
			-- function 14
			return (Managers.input:is_device_active("gamepad"))
		end,
		content_change_function = function (self, arg_15_1)
			-- function 15
			if IS_PS4 or not IS_XB1 then
				return
			end

			local use_ps4_input_icons = UISettings.use_ps4_input_icons
			local input = Managers.input

			input = not input and Managers.input:get_most_recent_device()
			use_ps4_input_icons = not input and input.type() == "sce_pad" and use_ps4_input_icons

			local flag

			flag = not use_ps4_input_icons and "ps4_button_icon_l1" and "xbone_button_icon_lb"
			self.left_shoulder = flag
		end
	}
	passes[#passes + 1] = {
		style_id = "left_arrow",
		pass_type = "hotspot",
		content_id = "left_arrow_hotspot"
	}
	tbl_4.left_arrow = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		area_size = {
			30,
			30
		},
		texture_size = {
			12,
			16
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			num_3,
			0,
			0
		}
	}
	tbl_4.left_shoulder = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			36,
			26
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			num_3,
			0,
			0
		}
	}
	tbl_3.left_arrow_hotspot = {}
	tbl_3.left_arrow = "info_slate_arrow"

	local flag_2

	flag_2 = not IS_PS4 and "ps4_button_icon_l1" and "xbone_button_icon_lb"
	tbl_3.left_shoulder = flag_2
	tbl.element = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.scenegraph_id = "switch_panel"
	tbl.offset = {
		-5,
		0,
		0
	}

	return tbl
end

local flag = true
local tbl_8 = {
	panel = UIWidgets.create_simple_rect("panel", {
		192,
		0,
		0,
		0
	}, nil, nil, tbl.top_panel.size),
	panel_mask = UIWidgets.create_simple_texture("mask_rect", "panel_mask", nil, nil, {
		255,
		255,
		255,
		255
	}),
	top_banner = UIWidgets.create_simple_rect("top_banner", {
		255,
		255,
		255,
		255
	}, 0, {
		0,
		0,
		0
	}),
	dot_glow = UIWidgets.create_simple_texture("dot_glow", "dot", nil, nil, {
		255,
		255,
		255,
		255
	}),
	dot = UIWidgets.create_simple_texture("dot", "dot", nil, nil, {
		255,
		255,
		255,
		255
	}, {
		0,
		0,
		10
	}),
	alert_name = UIWidgets.create_simple_text("ALERT NAME", "alert_name", 25, {
		255,
		255,
		255,
		255
	}, tbl_2),
	header = UIWidgets.create_simple_text("Header", "header", 25, {
		255,
		255,
		255,
		255
	}, tbl_3),
	sub_header = UIWidgets.create_simple_text("Sub Header", "sub_header", 25, {
		255,
		255,
		255,
		255
	}, tbl_4)
}
local create_hotspot_text = create_hotspot_text
local var_0_12

if not Managers.localizer:exists("info_slate_more_information") then
	var_0_12 = Localize("info_slate_more_information")

	if not var_0_12 then
		-- Nothing
	end
end

var_0_12 = "More Information"

::label_0_0::

tbl_8.more_information = create_hotspot_text(var_0_12, "information", tbl_5)

local create_hotspot_text_2 = create_hotspot_text
local var_0_14

if not Managers.localizer:exists("info_slate_less_information") then
	var_0_14 = Localize("info_slate_less_information")

	if not var_0_14 then
		-- Nothing
	end
end

var_0_14 = "Less Information"

::label_0_1::

tbl_8.less_information = create_hotspot_text_2(var_0_14, "information", tbl_5)
tbl_8.triangle_right = UIWidgets.create_simple_triangle("triangle", {
	255,
	255,
	255,
	255
}, "right", {
	10,
	10
}, flag)
tbl_8.triangle_down = UIWidgets.create_simple_triangle("triangle", {
	255,
	255,
	255,
	255
}, "down", {
	10,
	10
}, flag)
tbl_8.input = create_gamepad_input("triangle", {
	255,
	255,
	255,
	255
})

local tbl_9 = {
	animate_switch_panel_in = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				arg_16_0.switch_panel.position[1] = 200
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				local easeOutCubic = math.easeOutCubic(arg_17_3)

				arg_17_0.switch_panel.position[1] = 200 - 250 * easeOutCubic

				local switch_panel = arg_17_2.switch_panel

				if not switch_panel then
					switch_panel.content.alpha_value = easeOutCubic * easeOutCubic
				end
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				return
			end
		}
	},
	animate_switch_panel_out = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				arg_19_0.switch_panel.position[1] = 0
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				local easeOutCubic = math.easeOutCubic(arg_20_3)

				arg_20_0.switch_panel.position[1] = 250 * easeOutCubic

				local switch_panel = arg_20_2.switch_panel

				if not switch_panel then
					switch_panel.content.alpha_value = 1 - easeOutCubic * easeOutCubic
				end
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				return
			end
		}
	},
	animate_in = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				arg_22_3.render_settings.alpha_multiplier = 0
				arg_22_0.panel.position[1] = 200
				arg_22_2.more_information.content.visible = true
				arg_22_2.less_information.content.visible = false
				arg_22_2.triangle_right.content.visible = true
				arg_22_2.triangle_down.content.visible = false
			end,
			update = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				-- function 23
				local easeOutCubic = math.easeOutCubic(arg_23_3)

				arg_23_4.render_settings.alpha_multiplier = easeOutCubic * easeOutCubic
				arg_23_0.panel.position[1] = 200 - 250 * easeOutCubic
			end,
			on_complete = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				-- function 24
				return
			end
		}
	},
	animate_out = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.25,
			init = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				arg_25_3.render_settings.alpha_multiplier = 1
				arg_25_3.render_settings.scrollbar_alpha = 0
			end,
			update = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				-- function 26
				local easeOutCubic = math.easeOutCubic(arg_26_3)

				arg_26_4.render_settings.alpha_multiplier = 1 - easeOutCubic * easeOutCubic
				arg_26_0.panel.position[1] = 250 * easeOutCubic

				local switch_panel = arg_26_2.switch_panel

				if not switch_panel then
					switch_panel.content.alpha_value = arg_26_4.render_settings.alpha_multiplier
				end
			end,
			on_complete = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				arg_27_0.panel_mask.size[2] = 0
				arg_27_2.panel.style.rect.texture_size[2] = arg_27_1.top_panel.size[2]
			end
		}
	},
	expand = {
		{
			name = "expand",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				arg_28_0.panel_mask.size[2] = 0
				arg_28_2.more_information.content.visible = false
				arg_28_2.less_information.content.visible = true
				arg_28_2.triangle_right.content.visible = false
				arg_28_2.triangle_down.content.visible = true
				arg_28_3.render_settings.scrollbar_alpha = 0
			end,
			update = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				-- function 29
				local easeOutCubic = math.easeOutCubic(arg_29_3)

				arg_29_0.panel_mask.size[2] = 590 * easeOutCubic
				arg_29_2.panel.style.rect.texture_size[2] = math.lerp(arg_29_1.top_panel.size[2], arg_29_1.panel.size[2], easeOutCubic)
			end,
			on_complete = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				-- function 30
				return
			end
		},
		{
			name = "fade_scrollbar",
			start_progress = 0.5,
			end_progress = 0.75,
			init = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				return
			end,
			update = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				-- function 32
				local easeOutCubic = math.easeOutCubic(arg_32_3)

				arg_32_4.render_settings.scrollbar_alpha = easeOutCubic
			end,
			on_complete = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				-- function 33
				return
			end
		}
	},
	expand_instantly = {
		{
			name = "expand",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				arg_34_0.panel_mask.size[2] = 0
				arg_34_2.more_information.content.visible = false
				arg_34_2.less_information.content.visible = true
				arg_34_2.triangle_right.content.visible = false
				arg_34_2.triangle_down.content.visible = true
				arg_34_3.render_settings.scrollbar_alpha = 1
			end,
			update = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				-- function 35
				arg_35_0.panel_mask.size[2] = 590
				arg_35_2.panel.style.rect.texture_size[2] = arg_35_1.panel.size[2]
			end,
			on_complete = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				-- function 36
				return
			end
		}
	},
	collapse = {
		{
			name = "collapse",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
				arg_37_0.panel_mask.size[2] = 590
				arg_37_2.more_information.content.visible = true
				arg_37_2.less_information.content.visible = false
				arg_37_2.triangle_right.content.visible = true
				arg_37_2.triangle_down.content.visible = false
			end,
			update = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				-- function 38
				local easeOutCubic = math.easeOutCubic(arg_38_3)

				arg_38_0.panel_mask.size[2] = 590 * (1 - easeOutCubic)
				arg_38_2.panel.style.rect.texture_size[2] = math.lerp(arg_38_1.panel.size[2], arg_38_1.top_panel.size[2], easeOutCubic)
			end,
			on_complete = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				-- function 39
				return
			end
		}
	},
	collapse_instantly = {
		{
			name = "collapse",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				arg_40_0.panel_mask.size[2] = 590
				arg_40_2.more_information.content.visible = true
				arg_40_2.less_information.content.visible = false
				arg_40_2.triangle_right.content.visible = true
				arg_40_2.triangle_down.content.visible = false
			end,
			update = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				-- function 41
				local easeOutCubic = math.easeOutCubic(arg_41_3)

				arg_41_0.panel_mask.size[2] = 590 * (1 - easeOutCubic)
				arg_41_2.panel.style.rect.texture_size[2] = math.lerp(arg_41_1.panel.size[2], arg_41_1.top_panel.size[2], easeOutCubic)
			end,
			on_complete = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				-- function 42
				return
			end
		}
	}
}

return {
	widget_definitions = tbl_8,
	body_parsing_data = tbl_7,
	animation_definitions = tbl_9,
	scenegraph_definition = tbl,
	panel_scroll_area = num,
	create_switch_panel_func = fn
}
