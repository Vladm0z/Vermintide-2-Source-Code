-- chunkname: @scripts/ui/hud_ui/scrollbar_ui_definitions.lua

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	local tbl = {
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
					content_change_function = function (self, arg_2_1)
						-- function 2
						if not self.horizontal_scrollbar then
							local var_2_0 = arg_2_1.rect_size[1]
							local var_2_1 = arg_2_1.parent.scrollbar_bg.rect_size[1]
							local num = self.progress * (var_2_1 - var_2_0) * -1

							arg_2_1.offset[1] = -num
							arg_2_1.parent.scroller_hotspot.offset[1] = -num
						else
							local var_2_3 = arg_2_1.rect_size[2]
							local var_2_4 = arg_2_1.parent.scrollbar_bg.rect_size[2]
							local num_2 = self.progress * (var_2_4 - var_2_3) * -1

							arg_2_1.offset[2] = num_2
							arg_2_1.parent.scroller_hotspot.offset[2] = num_2
						end
					end
				},
				{
					style_id = "gamepad_input",
					texture_id = "xbox_input",
					pass_type = "texture",
					content_check_function = function (self, arg_3_1)
						-- function 3
						local is_device_active = Managers.input:is_device_active("gamepad")
						local use_ps4_input_icons = UISettings.use_ps4_input_icons

						use_ps4_input_icons = Managers.input:get_most_recent_device().type() == "sce_pad" or use_ps4_input_icons

						return not is_device_active and not not use_ps4_input_icons or not self.gamepad_input_disabled
					end,
					content_change_function = function (self, arg_4_1)
						-- function 4
						if not self.horizontal_scrollbar then
							local scroller = arg_4_1.parent.scroller
							local var_4_1 = scroller.rect_size[1]
							local var_4_2 = scroller.offset[1]

							arg_4_1.offset[1] = var_4_2 + var_4_1 * 0.5 - arg_4_1.texture_size[1] * 0.5
						else
							local scroller_2 = arg_4_1.parent.scroller
							local var_4_4 = scroller_2.rect_size[2]
							local var_4_5 = scroller_2.offset[2]

							arg_4_1.offset[2] = var_4_5 - var_4_4 * 0.5 + arg_4_1.texture_size[2] * 0.5
						end
					end
				},
				{
					style_id = "gamepad_input",
					texture_id = "ps_input",
					pass_type = "texture",
					content_check_function = function (self, arg_5_1)
						-- function 5
						local is_device_active = Managers.input:is_device_active("gamepad")
						local use_ps4_input_icons = UISettings.use_ps4_input_icons

						use_ps4_input_icons = Managers.input:get_most_recent_device().type() == "sce_pad" or use_ps4_input_icons

						return not is_device_active and not use_ps4_input_icons and not self.gamepad_input_disabled
					end,
					content_change_function = function (self, arg_6_1)
						-- function 6
						if not self.horizontal_scrollbar then
							local scroller = arg_6_1.parent.scroller
							local var_6_1 = scroller.rect_size[1]
							local var_6_2 = scroller.offset[1]

							arg_6_1.offset[1] = var_6_2 + var_6_1 * 0.5 - arg_6_1.texture_size[1] * 0.5
						else
							local scroller_2 = arg_6_1.parent.scroller
							local var_6_4 = scroller_2.rect_size[2]
							local var_6_5 = scroller_2.offset[2]

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
		}
	}
	local tbl_2 = {}
	local tbl_3 = {
		texture_size = {
			32,
			33
		}
	}
	local flag

	flag = not arg_1_3 and "left" and arg_1_4 or "right"
	tbl_3.horizontal_alignment = flag

	local flag_2

	flag_2 = not arg_1_3 and "bottom" and "top"
	tbl_3.vertical_alignment = flag_2

	local tbl_4

	if not arg_1_3 then
		tbl_4 = {
			0,
			16.5,
			103
		}

		if not tbl_4 then
			-- Nothing
		end
	end

	tbl_4 = {
		nil,
		0,
		103
	}

	do
		local flag_3

		flag_3 = not arg_1_4 and -1 and 1
		tbl_4[1] = flag_3 * 16
	end

	::label_1_0::

	tbl_3.offset = tbl_4
	tbl_2.gamepad_input = tbl_3

	local tbl_5 = {}
	local tbl_6

	if not arg_1_3 then
		tbl_6 = {
			math.max((1 - arg_1_2 / (arg_1_2 + arg_1_1[1])) * arg_1_1[1], 40),
			18
		}

		if not tbl_6 then
			-- Nothing
		end
	end

	tbl_6 = {
		18,
		math.max((1 - arg_1_2 / (arg_1_2 + arg_1_1[2])) * arg_1_1[2], 40)
	}

	::label_1_1::

	tbl_5.area_size = tbl_6

	local flag_4

	flag_4 = not arg_1_3 and "bottom" and "top"
	tbl_5.vertical_alignment = flag_4

	local flag_5

	flag_5 = not arg_1_3 and "left" and arg_1_4 or "right"
	tbl_5.horizontal_alignment = flag_5

	local tbl_7

	if not arg_1_3 then
		tbl_7 = {
			0,
			-1,
			102
		}

		if not tbl_7 then
			-- Nothing
		end
	end

	tbl_7 = {
		nil,
		0,
		102
	}

	do
		local flag_6

		flag_6 = not arg_1_4 and -1 and 1
		tbl_7[1] = flag_6 * 9
	end

	::label_1_2::

	tbl_5.offset = tbl_7
	tbl_2.scroller_hotspot = tbl_5

	local tbl_8 = {
		vertical_alignment = "bottom"
	}
	local tbl_9

	if not arg_1_3 then
		tbl_9 = {
			arg_1_1[1] + 2,
			22
		}

		if not tbl_9 then
			-- Nothing
		end
	end

	tbl_9 = {
		22,
		arg_1_1[2] + 2
	}

	::label_1_3::

	tbl_8.area_size = tbl_9

	local flag_7

	flag_7 = not arg_1_3 and "left" and arg_1_4 or "right"
	tbl_8.horizontal_alignment = flag_7

	local tbl_10

	if not arg_1_3 then
		tbl_10 = {
			-1,
			1,
			101
		}

		if not tbl_10 then
			-- Nothing
		end
	end

	tbl_10 = {
		nil,
		-1,
		101
	}

	do
		local flag_8

		flag_8 = not arg_1_4 and -1 and 1
		tbl_10[1] = flag_8 * 11
	end

	::label_1_4::

	tbl_8.offset = tbl_10
	tbl_2.scrollbar_hotspot = tbl_8

	local tbl_11 = {
		corner_radius = 4
	}
	local tbl_12

	if not arg_1_3 then
		tbl_12 = {
			math.max((1 - arg_1_2 / (arg_1_2 + arg_1_1[1])) * arg_1_1[1], 40),
			8
		}

		if not tbl_12 then
			-- Nothing
		end
	end

	tbl_12 = {
		8,
		math.max((1 - arg_1_2 / (arg_1_2 + arg_1_1[2])) * arg_1_1[2], 40)
	}

	::label_1_5::

	tbl_11.rect_size = tbl_12

	local flag_9

	flag_9 = not arg_1_3 and "bottom" and "top"
	tbl_11.vertical_alignment = flag_9

	local flag_10

	flag_10 = not arg_1_3 and "left" and arg_1_4 or "right"
	tbl_11.horizontal_alignment = flag_10
	tbl_11.color = {
		128,
		255,
		255,
		255
	}

	local tbl_13

	if not arg_1_3 then
		tbl_13 = {
			0,
			6,
			102
		}

		if not tbl_13 then
			-- Nothing
		end
	end

	tbl_13 = {
		nil,
		0,
		102
	}

	do
		local flag_11

		flag_11 = not arg_1_4 and -1 and 1
		tbl_13[1] = flag_11 * 4
	end

	::label_1_6::

	tbl_11.offset = tbl_13
	tbl_2.scroller = tbl_11

	local tbl_14 = {
		vertical_alignment = "bottom",
		corner_radius = 4
	}
	local tbl_15

	if not arg_1_3 then
		tbl_15 = {
			arg_1_1[1],
			10
		}

		if not tbl_15 then
			-- Nothing
		end
	end

	tbl_15 = {
		10,
		arg_1_1[2]
	}

	::label_1_7::

	tbl_14.rect_size = tbl_15

	local flag_12

	flag_12 = not arg_1_3 and "left" and arg_1_4 or "right"
	tbl_14.horizontal_alignment = flag_12
	tbl_14.color = {
		255,
		0,
		0,
		0
	}

	local tbl_16

	if not arg_1_3 then
		tbl_16 = {
			0,
			5,
			101
		}

		if not tbl_16 then
			-- Nothing
		end
	end

	tbl_16 = {
		nil,
		0,
		101
	}

	do
		local flag_13

		flag_13 = not arg_1_4 and -1 and 1
		tbl_16[1] = flag_13 * 5
	end

	::label_1_8::

	tbl_14.offset = tbl_16
	tbl_2.scrollbar_bg = tbl_14

	local tbl_17 = {
		vertical_alignment = "bottom",
		corner_radius = 4
	}
	local tbl_18

	if not arg_1_3 then
		tbl_18 = {
			arg_1_1[1] + 2,
			12
		}

		if not tbl_18 then
			-- Nothing
		end
	end

	tbl_18 = {
		12,
		arg_1_1[2] + 2
	}

	::label_1_9::

	tbl_17.rect_size = tbl_18

	local flag_14

	flag_14 = not arg_1_3 and "left" and arg_1_4 or "right"
	tbl_17.horizontal_alignment = flag_14
	tbl_17.color = {
		128,
		255,
		255,
		255
	}

	local tbl_19

	if not arg_1_3 then
		tbl_19 = {
			-1,
			4,
			100
		}

		if not tbl_19 then
			-- Nothing
		end
	end

	tbl_19 = {
		nil,
		-1,
		100
	}

	do
		local flag_15

		flag_15 = not arg_1_4 and -1 and 1
		tbl_19[1] = flag_15 * 6
	end

	::label_1_10::

	tbl_17.offset = tbl_19
	tbl_2.scrollbar_bg_bg = tbl_17
	tbl.style = tbl_2
	tbl.offset = {
		0,
		0,
		100
	}
	tbl.scenegraph_id = arg_1_0

	return tbl
end

local tbl = {
	scrollbar = fn
}

local function fn_2(self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local tbl_2 = {}
	local tbl_3 = {}
	local size = self[arg_7_1].size

	for k, v in pairs(tbl) do
		local var_7_3 = v(arg_7_1, size, arg_7_2, arg_7_3, arg_7_4)
		local var_7_4 = UIWidget.init(var_7_3)

		tbl_2[#tbl_2 + 1] = var_7_4
		tbl_3[k] = var_7_4
	end

	return tbl_2, tbl_3
end

return {
	setup_func = fn_2
}
