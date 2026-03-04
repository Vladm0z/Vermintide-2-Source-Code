-- chunkname: @scripts/ui/views/menu_information_slate_ui_definitions.lua

local var_0_0 = 590
local var_0_1 = {
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
local var_0_2 = {
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
local var_0_3 = {
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
local var_0_4 = {
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
local var_0_5 = {
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
local var_0_6 = {
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
local var_0_7 = {
	text = {
		spacing = 25,
		default_text_style = var_0_6
	},
	image = {
		spacing = 25
	}
}

function create_hotspot_text(arg_1_0, arg_1_1, arg_1_2)
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
					content_change_function = function(arg_2_0, arg_2_1)
						if arg_2_0.hotspot.is_hover then
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
	return {
		element = {
			passes = {
				{
					texture_id = "xb_input",
					style_id = "texture_id",
					pass_type = "texture",
					content_check_function = function(arg_4_0, arg_4_1)
						local var_4_0 = Managers.input:is_device_active("gamepad")
						local var_4_1 = UISettings.use_ps4_input_icons

						var_4_1 = Managers.input:get_most_recent_device().type() == "sce_pad" or var_4_1

						return var_4_0 and not var_4_1
					end
				},
				{
					texture_id = "ps_input",
					style_id = "texture_id",
					pass_type = "texture",
					content_check_function = function(arg_5_0, arg_5_1)
						local var_5_0 = Managers.input:is_device_active("gamepad")
						local var_5_1 = UISettings.use_ps4_input_icons

						var_5_1 = Managers.input:get_most_recent_device().type() == "sce_pad" or var_5_1

						return var_5_0 and var_5_1
					end
				}
			}
		},
		content = {
			xb_input = IS_CONSOLE and "xbone_button_icon_menu_large" or "xbone_button_icon_x",
			ps_input = IS_CONSOLE and "ps4_button_icon_options" or "ps4_button_icon_square"
		},
		style = {
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
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_3_0
	}
end

local function var_0_8(arg_6_0)
	local var_6_0 = #arg_6_0
	local var_6_1 = {}
	local var_6_2 = {
		passes = {}
	}
	local var_6_3 = var_6_2.passes
	local var_6_4 = {}
	local var_6_5 = {}

	var_6_3[#var_6_3 + 1] = {
		style_id = "right_arrow",
		pass_type = "texture_uv",
		content_id = "right_arrow",
		content_check_function = function(arg_7_0, arg_7_1)
			return not Managers.input:is_device_active("gamepad")
		end,
		content_change_function = function(arg_8_0, arg_8_1)
			local var_8_0 = arg_8_0.parent.right_arrow_hotspot.is_hover and 1 or 0.6

			arg_8_1.color[2] = 255 * var_8_0
			arg_8_1.color[3] = 255 * var_8_0
			arg_8_1.color[4] = 255 * var_8_0
		end
	}
	var_6_3[#var_6_3 + 1] = {
		style_id = "right_arrow",
		pass_type = "hotspot",
		content_id = "right_arrow_hotspot"
	}
	var_6_3[#var_6_3 + 1] = {
		style_id = "right_shoulder",
		texture_id = "right_shoulder",
		pass_type = "texture",
		content_check_function = function(arg_9_0, arg_9_1)
			return (Managers.input:is_device_active("gamepad"))
		end,
		content_change_function = function(arg_10_0, arg_10_1)
			if IS_PS4 or IS_XB1 then
				return
			end

			local var_10_0 = UISettings.use_ps4_input_icons
			local var_10_1 = Managers.input and Managers.input:get_most_recent_device()

			var_10_0 = var_10_1 and var_10_1.type() == "sce_pad" or var_10_0
			arg_10_0.right_shoulder = var_10_0 and "ps4_button_icon_r1" or "xbone_button_icon_rb"
		end
	}
	var_6_5.right_arrow = {
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
	var_6_5.right_shoulder = {
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
	var_6_4.right_arrow_hotspot = {}
	var_6_4.right_arrow = {
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
	var_6_4.right_shoulder = IS_PS4 and "ps4_button_icon_r1" or "xbone_button_icon_rb"
	var_6_4.current_index = nil

	local var_6_6 = {
		16,
		16
	}
	local var_6_7 = 8
	local var_6_8 = -28

	for iter_6_0 = var_6_0, 1, -1 do
		local var_6_9 = arg_6_0[iter_6_0]
		local var_6_10 = "slate_" .. iter_6_0

		var_6_3[#var_6_3 + 1] = {
			pass_type = "rect",
			content_id = var_6_10,
			style_id = var_6_10,
			content_change_function = function(arg_11_0, arg_11_1)
				local var_11_0 = arg_11_1.alert_color
				local var_11_1 = arg_11_0.parent[var_6_10 .. "_hotspot"]
				local var_11_2 = var_11_1.is_hover or arg_11_0.index == arg_11_0.parent.current_index
				local var_11_3 = var_11_1.is_hover and 1 or 0.8

				arg_11_1.color[1] = 255
				arg_11_1.color[2] = (var_11_2 and var_11_0[2] or 255) * var_11_3
				arg_11_1.color[3] = (var_11_2 and var_11_0[3] or 255) * var_11_3
				arg_11_1.color[4] = (var_11_2 and var_11_0[4] or 255) * var_11_3
			end
		}
		var_6_3[#var_6_3 + 1] = {
			pass_type = "hotspot",
			content_id = var_6_10 .. "_hotspot",
			style_id = var_6_10
		}
		var_6_4[var_6_10 .. "_hotspot"] = {}
		var_6_4[var_6_10] = {
			index = iter_6_0
		}
		var_6_5[var_6_10] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			alert_color = var_6_9.alert_color,
			texture_size = var_6_6,
			area_size = {
				var_6_6[1] * 1.5,
				var_6_6[2] * 1.5
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_6_8,
				0,
				0
			}
		}
		var_6_8 = var_6_8 - var_6_6[1] - var_6_7
	end

	local var_6_11 = var_6_8 - 4

	var_6_3[#var_6_3 + 1] = {
		style_id = "left_arrow",
		texture_id = "left_arrow",
		pass_type = "texture",
		content_check_function = function(arg_12_0, arg_12_1)
			return not Managers.input:is_device_active("gamepad")
		end,
		content_change_function = function(arg_13_0, arg_13_1)
			local var_13_0 = arg_13_0.left_arrow_hotspot.is_hover and 1 or 0.6

			arg_13_1.color[2] = 255 * var_13_0
			arg_13_1.color[3] = 255 * var_13_0
			arg_13_1.color[4] = 255 * var_13_0
		end
	}
	var_6_3[#var_6_3 + 1] = {
		style_id = "left_shoulder",
		texture_id = "left_shoulder",
		pass_type = "texture",
		content_check_function = function(arg_14_0, arg_14_1)
			return (Managers.input:is_device_active("gamepad"))
		end,
		content_change_function = function(arg_15_0, arg_15_1)
			if IS_PS4 or IS_XB1 then
				return
			end

			local var_15_0 = UISettings.use_ps4_input_icons
			local var_15_1 = Managers.input and Managers.input:get_most_recent_device()

			var_15_0 = var_15_1 and var_15_1.type() == "sce_pad" or var_15_0
			arg_15_0.left_shoulder = var_15_0 and "ps4_button_icon_l1" or "xbone_button_icon_lb"
		end
	}
	var_6_3[#var_6_3 + 1] = {
		style_id = "left_arrow",
		pass_type = "hotspot",
		content_id = "left_arrow_hotspot"
	}
	var_6_5.left_arrow = {
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
			var_6_11,
			0,
			0
		}
	}
	var_6_5.left_shoulder = {
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
			var_6_11,
			0,
			0
		}
	}
	var_6_4.left_arrow_hotspot = {}
	var_6_4.left_arrow = "info_slate_arrow"
	var_6_4.left_shoulder = IS_PS4 and "ps4_button_icon_l1" or "xbone_button_icon_lb"
	var_6_1.element = var_6_2
	var_6_1.content = var_6_4
	var_6_1.style = var_6_5
	var_6_1.scenegraph_id = "switch_panel"
	var_6_1.offset = {
		-5,
		0,
		0
	}

	return var_6_1
end

local var_0_9 = true
local var_0_10 = {
	panel = UIWidgets.create_simple_rect("panel", {
		192,
		0,
		0,
		0
	}, nil, nil, var_0_1.top_panel.size),
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
	}, var_0_2),
	header = UIWidgets.create_simple_text("Header", "header", 25, {
		255,
		255,
		255,
		255
	}, var_0_3),
	sub_header = UIWidgets.create_simple_text("Sub Header", "sub_header", 25, {
		255,
		255,
		255,
		255
	}, var_0_4),
	more_information = create_hotspot_text(Managers.localizer:exists("info_slate_more_information") and Localize("info_slate_more_information") or "More Information", "information", var_0_5),
	less_information = create_hotspot_text(Managers.localizer:exists("info_slate_less_information") and Localize("info_slate_less_information") or "Less Information", "information", var_0_5),
	triangle_right = UIWidgets.create_simple_triangle("triangle", {
		255,
		255,
		255,
		255
	}, "right", {
		10,
		10
	}, var_0_9),
	triangle_down = UIWidgets.create_simple_triangle("triangle", {
		255,
		255,
		255,
		255
	}, "down", {
		10,
		10
	}, var_0_9),
	input = create_gamepad_input("triangle", {
		255,
		255,
		255,
		255
	})
}
local var_0_11 = {
	animate_switch_panel_in = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				arg_16_0.switch_panel.position[1] = 200
			end,
			update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				local var_17_0 = math.easeOutCubic(arg_17_3)

				arg_17_0.switch_panel.position[1] = 200 - 250 * var_17_0

				local var_17_1 = arg_17_2.switch_panel

				if var_17_1 then
					var_17_1.content.alpha_value = var_17_0 * var_17_0
				end
			end,
			on_complete = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end
		}
	},
	animate_switch_panel_out = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				arg_19_0.switch_panel.position[1] = 0
			end,
			update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				local var_20_0 = math.easeOutCubic(arg_20_3)

				arg_20_0.switch_panel.position[1] = 250 * var_20_0

				local var_20_1 = arg_20_2.switch_panel

				if var_20_1 then
					var_20_1.content.alpha_value = 1 - var_20_0 * var_20_0
				end
			end,
			on_complete = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				return
			end
		}
	},
	animate_in = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				arg_22_3.render_settings.alpha_multiplier = 0
				arg_22_0.panel.position[1] = 200
				arg_22_2.more_information.content.visible = true
				arg_22_2.less_information.content.visible = false
				arg_22_2.triangle_right.content.visible = true
				arg_22_2.triangle_down.content.visible = false
			end,
			update = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				local var_23_0 = math.easeOutCubic(arg_23_3)

				arg_23_4.render_settings.alpha_multiplier = var_23_0 * var_23_0
				arg_23_0.panel.position[1] = 200 - 250 * var_23_0
			end,
			on_complete = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				return
			end
		}
	},
	animate_out = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.25,
			init = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				arg_25_3.render_settings.alpha_multiplier = 1
				arg_25_3.render_settings.scrollbar_alpha = 0
			end,
			update = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				local var_26_0 = math.easeOutCubic(arg_26_3)

				arg_26_4.render_settings.alpha_multiplier = 1 - var_26_0 * var_26_0
				arg_26_0.panel.position[1] = 250 * var_26_0

				local var_26_1 = arg_26_2.switch_panel

				if var_26_1 then
					var_26_1.content.alpha_value = arg_26_4.render_settings.alpha_multiplier
				end
			end,
			on_complete = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
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
			init = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				arg_28_0.panel_mask.size[2] = 0
				arg_28_2.more_information.content.visible = false
				arg_28_2.less_information.content.visible = true
				arg_28_2.triangle_right.content.visible = false
				arg_28_2.triangle_down.content.visible = true
				arg_28_3.render_settings.scrollbar_alpha = 0
			end,
			update = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				local var_29_0 = math.easeOutCubic(arg_29_3)

				arg_29_0.panel_mask.size[2] = 590 * var_29_0
				arg_29_2.panel.style.rect.texture_size[2] = math.lerp(arg_29_1.top_panel.size[2], arg_29_1.panel.size[2], var_29_0)
			end,
			on_complete = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				return
			end
		},
		{
			name = "fade_scrollbar",
			start_progress = 0.5,
			end_progress = 0.75,
			init = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end,
			update = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				local var_32_0 = math.easeOutCubic(arg_32_3)

				arg_32_4.render_settings.scrollbar_alpha = var_32_0
			end,
			on_complete = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				return
			end
		}
	},
	expand_instantly = {
		{
			name = "expand",
			start_progress = 0,
			end_progress = 0,
			init = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				arg_34_0.panel_mask.size[2] = 0
				arg_34_2.more_information.content.visible = false
				arg_34_2.less_information.content.visible = true
				arg_34_2.triangle_right.content.visible = false
				arg_34_2.triangle_down.content.visible = true
				arg_34_3.render_settings.scrollbar_alpha = 1
			end,
			update = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				arg_35_0.panel_mask.size[2] = 590
				arg_35_2.panel.style.rect.texture_size[2] = arg_35_1.panel.size[2]
			end,
			on_complete = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				return
			end
		}
	},
	collapse = {
		{
			name = "collapse",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				arg_37_0.panel_mask.size[2] = 590
				arg_37_2.more_information.content.visible = true
				arg_37_2.less_information.content.visible = false
				arg_37_2.triangle_right.content.visible = true
				arg_37_2.triangle_down.content.visible = false
			end,
			update = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				local var_38_0 = math.easeOutCubic(arg_38_3)

				arg_38_0.panel_mask.size[2] = 590 * (1 - var_38_0)
				arg_38_2.panel.style.rect.texture_size[2] = math.lerp(arg_38_1.panel.size[2], arg_38_1.top_panel.size[2], var_38_0)
			end,
			on_complete = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				return
			end
		}
	},
	collapse_instantly = {
		{
			name = "collapse",
			start_progress = 0,
			end_progress = 0,
			init = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				arg_40_0.panel_mask.size[2] = 590
				arg_40_2.more_information.content.visible = true
				arg_40_2.less_information.content.visible = false
				arg_40_2.triangle_right.content.visible = true
				arg_40_2.triangle_down.content.visible = false
			end,
			update = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				local var_41_0 = math.easeOutCubic(arg_41_3)

				arg_41_0.panel_mask.size[2] = 590 * (1 - var_41_0)
				arg_41_2.panel.style.rect.texture_size[2] = math.lerp(arg_41_1.panel.size[2], arg_41_1.top_panel.size[2], var_41_0)
			end,
			on_complete = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				return
			end
		}
	}
}

return {
	widget_definitions = var_0_10,
	body_parsing_data = var_0_7,
	animation_definitions = var_0_11,
	scenegraph_definition = var_0_1,
	panel_scroll_area = var_0_0,
	create_switch_panel_func = var_0_8
}
