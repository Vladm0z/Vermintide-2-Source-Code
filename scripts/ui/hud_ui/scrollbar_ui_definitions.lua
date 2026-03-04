-- chunkname: @scripts/ui/hud_ui/scrollbar_ui_definitions.lua

local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	return {
		element = {
			passes = {
				{
					style_id = "scroller_hotspot",
					pass_type = "hotspot",
					content_id = "scroller_hotspot"
				},
				{
					style_id = "scrollbar_hotspot",
					pass_type = "hotspot",
					content_id = "scrollbar_hotspot"
				},
				{
					pass_type = "rounded_background",
					style_id = "scrollbar_bg"
				},
				{
					pass_type = "rounded_background",
					style_id = "scrollbar_bg_bg"
				},
				{
					style_id = "scroller",
					pass_type = "rounded_background",
					content_change_function = function (arg_2_0, arg_2_1)
						if arg_2_0.horizontal_scrollbar then
							local var_2_0 = arg_2_1.rect_size[1]
							local var_2_1 = arg_2_1.parent.scrollbar_bg.rect_size[1]
							local var_2_2 = arg_2_0.progress * (var_2_1 - var_2_0) * -1

							arg_2_1.offset[1] = -var_2_2
							arg_2_1.parent.scroller_hotspot.offset[1] = -var_2_2
						else
							local var_2_3 = arg_2_1.rect_size[2]
							local var_2_4 = arg_2_1.parent.scrollbar_bg.rect_size[2]
							local var_2_5 = arg_2_0.progress * (var_2_4 - var_2_3) * -1

							arg_2_1.offset[2] = var_2_5
							arg_2_1.parent.scroller_hotspot.offset[2] = var_2_5
						end
					end
				},
				{
					style_id = "gamepad_input",
					texture_id = "xbox_input",
					pass_type = "texture",
					content_check_function = function (arg_3_0, arg_3_1)
						local var_3_0 = Managers.input:is_device_active("gamepad")
						local var_3_1 = UISettings.use_ps4_input_icons

						var_3_1 = Managers.input:get_most_recent_device().type() == "sce_pad" or var_3_1

						return var_3_0 and not var_3_1 and not arg_3_0.gamepad_input_disabled
					end,
					content_change_function = function (arg_4_0, arg_4_1)
						if arg_4_0.horizontal_scrollbar then
							local var_4_0 = arg_4_1.parent.scroller
							local var_4_1 = var_4_0.rect_size[1]
							local var_4_2 = var_4_0.offset[1]

							arg_4_1.offset[1] = var_4_2 + var_4_1 * 0.5 - arg_4_1.texture_size[1] * 0.5
						else
							local var_4_3 = arg_4_1.parent.scroller
							local var_4_4 = var_4_3.rect_size[2]
							local var_4_5 = var_4_3.offset[2]

							arg_4_1.offset[2] = var_4_5 - var_4_4 * 0.5 + arg_4_1.texture_size[2] * 0.5
						end
					end
				},
				{
					style_id = "gamepad_input",
					texture_id = "ps_input",
					pass_type = "texture",
					content_check_function = function (arg_5_0, arg_5_1)
						local var_5_0 = Managers.input:is_device_active("gamepad")
						local var_5_1 = UISettings.use_ps4_input_icons

						var_5_1 = Managers.input:get_most_recent_device().type() == "sce_pad" or var_5_1

						return var_5_0 and var_5_1 and not arg_5_0.gamepad_input_disabled
					end,
					content_change_function = function (arg_6_0, arg_6_1)
						if arg_6_0.horizontal_scrollbar then
							local var_6_0 = arg_6_1.parent.scroller
							local var_6_1 = var_6_0.rect_size[1]
							local var_6_2 = var_6_0.offset[1]

							arg_6_1.offset[1] = var_6_2 + var_6_1 * 0.5 - arg_6_1.texture_size[1] * 0.5
						else
							local var_6_3 = arg_6_1.parent.scroller
							local var_6_4 = var_6_3.rect_size[2]
							local var_6_5 = var_6_3.offset[2]

							arg_6_1.offset[2] = var_6_5 - var_6_4 * 0.5 + arg_6_1.texture_size[2] * 0.5
						end
					end
				}
			}
		},
		content = {
			ps_input = "ps4_button_icon_right_stick",
			xbox_input = "xbone_button_icon_right_stick",
			gamepad_input_disabled = false,
			scroller_hotspot = {},
			scrollbar_hotspot = {},
			horizontal_scrollbar = arg_1_3
		},
		style = {
			gamepad_input = {
				texture_size = {
					32,
					33
				},
				horizontal_alignment = arg_1_3 and "left" or arg_1_4 or "right",
				vertical_alignment = arg_1_3 and "bottom" or "top",
				offset = arg_1_3 and {
					0,
					16.5,
					103
				} or {
					(arg_1_4 and -1 or 1) * 16,
					0,
					103
				}
			},
			scroller_hotspot = {
				area_size = arg_1_3 and {
					math.max((1 - arg_1_2 / (arg_1_2 + arg_1_1[1])) * arg_1_1[1], 40),
					18
				} or {
					18,
					math.max((1 - arg_1_2 / (arg_1_2 + arg_1_1[2])) * arg_1_1[2], 40)
				},
				vertical_alignment = arg_1_3 and "bottom" or "top",
				horizontal_alignment = arg_1_3 and "left" or arg_1_4 or "right",
				offset = arg_1_3 and {
					0,
					-1,
					102
				} or {
					(arg_1_4 and -1 or 1) * 9,
					0,
					102
				}
			},
			scrollbar_hotspot = {
				vertical_alignment = "bottom",
				area_size = arg_1_3 and {
					arg_1_1[1] + 2,
					22
				} or {
					22,
					arg_1_1[2] + 2
				},
				horizontal_alignment = arg_1_3 and "left" or arg_1_4 or "right",
				offset = arg_1_3 and {
					-1,
					1,
					101
				} or {
					(arg_1_4 and -1 or 1) * 11,
					-1,
					101
				}
			},
			scroller = {
				corner_radius = 4,
				rect_size = arg_1_3 and {
					math.max((1 - arg_1_2 / (arg_1_2 + arg_1_1[1])) * arg_1_1[1], 40),
					8
				} or {
					8,
					math.max((1 - arg_1_2 / (arg_1_2 + arg_1_1[2])) * arg_1_1[2], 40)
				},
				vertical_alignment = arg_1_3 and "bottom" or "top",
				horizontal_alignment = arg_1_3 and "left" or arg_1_4 or "right",
				color = {
					128,
					255,
					255,
					255
				},
				offset = arg_1_3 and {
					0,
					6,
					102
				} or {
					(arg_1_4 and -1 or 1) * 4,
					0,
					102
				}
			},
			scrollbar_bg = {
				vertical_alignment = "bottom",
				corner_radius = 4,
				rect_size = arg_1_3 and {
					arg_1_1[1],
					10
				} or {
					10,
					arg_1_1[2]
				},
				horizontal_alignment = arg_1_3 and "left" or arg_1_4 or "right",
				color = {
					255,
					0,
					0,
					0
				},
				offset = arg_1_3 and {
					0,
					5,
					101
				} or {
					(arg_1_4 and -1 or 1) * 5,
					0,
					101
				}
			},
			scrollbar_bg_bg = {
				vertical_alignment = "bottom",
				corner_radius = 4,
				rect_size = arg_1_3 and {
					arg_1_1[1] + 2,
					12
				} or {
					12,
					arg_1_1[2] + 2
				},
				horizontal_alignment = arg_1_3 and "left" or arg_1_4 or "right",
				color = {
					128,
					255,
					255,
					255
				},
				offset = arg_1_3 and {
					-1,
					4,
					100
				} or {
					(arg_1_4 and -1 or 1) * 6,
					-1,
					100
				}
			}
		},
		offset = {
			0,
			0,
			100
		},
		scenegraph_id = arg_1_0
	}
end

local var_0_1 = {
	scrollbar = var_0_0
}

local function var_0_2(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = {}
	local var_7_1 = {}
	local var_7_2 = arg_7_0[arg_7_1].size

	for iter_7_0, iter_7_1 in pairs(var_0_1) do
		local var_7_3 = iter_7_1(arg_7_1, var_7_2, arg_7_2, arg_7_3, arg_7_4)
		local var_7_4 = UIWidget.init(var_7_3)

		var_7_0[#var_7_0 + 1] = var_7_4
		var_7_1[iter_7_0] = var_7_4
	end

	return var_7_0, var_7_1
end

return {
	setup_func = var_0_2
}
