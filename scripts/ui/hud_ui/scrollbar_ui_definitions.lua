-- chunkname: @scripts/ui/hud_ui/scrollbar_ui_definitions.lua

local function create_scrollbar(scenegraph_id, area_size, scroll_size, horizontal_scrollbar, left_aligned)
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
					content_change_function = function (content, style)
						-- function 2
						if content.horizontal_scrollbar then
							local scroller_height = style.rect_size[1]
							local scrollbar_height = style.parent.scrollbar_bg.rect_size[1]
							local height_offset = content.progress * (scrollbar_height - scroller_height) * -1

							style.offset[1] = -height_offset
							style.parent.scroller_hotspot.offset[1] = -height_offset
						else
							local scroller_height = style.rect_size[2]
							local scrollbar_height = style.parent.scrollbar_bg.rect_size[2]
							local height_offset = content.progress * (scrollbar_height - scroller_height) * -1

							style.offset[2] = height_offset
							style.parent.scroller_hotspot.offset[2] = height_offset
						end
					end
				},
				{
					style_id = "gamepad_input",
					texture_id = "xbox_input",
					pass_type = "texture",
					content_check_function = function (content, style)
						-- function 3
						local gamepad_active = Managers.input:is_device_active("gamepad")
						local use_ps4_input_icons = UISettings.use_ps4_input_icons
						local input_device = Managers.input:get_most_recent_device()
						local device_type = input_device.type()
						local is_ps_pad = device_type == "sce_pad"

						use_ps4_input_icons = not not is_ps_pad or not not use_ps4_input_icons

						return not not gamepad_active and not use_ps4_input_icons and not not not content.gamepad_input_disabled
					end,
					content_change_function = function (content, style)
						-- function 4
						if content.horizontal_scrollbar then
							local scroller_style = style.parent.scroller
							local scroller_width = scroller_style.rect_size[1]
							local scroller_offset = scroller_style.offset[1]

							style.offset[1] = scroller_offset + scroller_width * 0.5 - style.texture_size[1] * 0.5
						else
							local scroller_style = style.parent.scroller
							local scroller_height = scroller_style.rect_size[2]
							local scroller_offset = scroller_style.offset[2]

							style.offset[2] = scroller_offset - scroller_height * 0.5 + style.texture_size[2] * 0.5
						end
					end
				},
				{
					style_id = "gamepad_input",
					texture_id = "ps_input",
					pass_type = "texture",
					content_check_function = function (content, style)
						-- function 5
						local gamepad_active = Managers.input:is_device_active("gamepad")
						local use_ps4_input_icons = UISettings.use_ps4_input_icons
						local input_device = Managers.input:get_most_recent_device()
						local device_type = input_device.type()
						local is_ps_pad = device_type == "sce_pad"

						use_ps4_input_icons = not not is_ps_pad or not not use_ps4_input_icons

						return not not gamepad_active and not not use_ps4_input_icons and not not not content.gamepad_input_disabled
					end,
					content_change_function = function (content, style)
						-- function 6
						if content.horizontal_scrollbar then
							local scroller_style = style.parent.scroller
							local scroller_width = scroller_style.rect_size[1]
							local scroller_offset = scroller_style.offset[1]

							style.offset[1] = scroller_offset + scroller_width * 0.5 - style.texture_size[1] * 0.5
						else
							local scroller_style = style.parent.scroller
							local scroller_height = scroller_style.rect_size[2]
							local scroller_offset = scroller_style.offset[2]

							style.offset[2] = scroller_offset - scroller_height * 0.5 + style.texture_size[2] * 0.5
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
			horizontal_scrollbar = horizontal_scrollbar
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

	flag = (not horizontal_scrollbar or not "left") and not not left_aligned or not not "right"
	tbl_3.horizontal_alignment = flag

	local flag_2

	flag_2 = (not horizontal_scrollbar or not "bottom") and not not "top"
	tbl_3.vertical_alignment = flag_2

	local tbl_4

	if horizontal_scrollbar then
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

		flag_3 = (not left_aligned or not -1) and not not 1
		tbl_4[1] = flag_3 * 16
	end

	::label_1_0::

	tbl_3.offset = tbl_4
	tbl_2.gamepad_input = tbl_3

	local tbl_5 = {}
	local tbl_6

	if horizontal_scrollbar then
		tbl_6 = {
			math.max((1 - scroll_size / (scroll_size + area_size[1])) * area_size[1], 40),
			18
		}

		if not tbl_6 then
			-- Nothing
		end
	end

	tbl_6 = {
		18,
		math.max((1 - scroll_size / (scroll_size + area_size[2])) * area_size[2], 40)
	}

	::label_1_1::

	tbl_5.area_size = tbl_6

	local flag_4

	flag_4 = (not horizontal_scrollbar or not "bottom") and not not "top"
	tbl_5.vertical_alignment = flag_4

	local flag_5

	flag_5 = (not horizontal_scrollbar or not "left") and not not left_aligned or not not "right"
	tbl_5.horizontal_alignment = flag_5

	local tbl_7

	if horizontal_scrollbar then
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

		flag_6 = (not left_aligned or not -1) and not not 1
		tbl_7[1] = flag_6 * 9
	end

	::label_1_2::

	tbl_5.offset = tbl_7
	tbl_2.scroller_hotspot = tbl_5

	local tbl_8 = {
		vertical_alignment = "bottom"
	}
	local tbl_9

	if horizontal_scrollbar then
		tbl_9 = {
			area_size[1] + 2,
			22
		}

		if not tbl_9 then
			-- Nothing
		end
	end

	tbl_9 = {
		22,
		area_size[2] + 2
	}

	::label_1_3::

	tbl_8.area_size = tbl_9

	local flag_7

	flag_7 = (not horizontal_scrollbar or not "left") and not not left_aligned or not not "right"
	tbl_8.horizontal_alignment = flag_7

	local tbl_10

	if horizontal_scrollbar then
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

		flag_8 = (not left_aligned or not -1) and not not 1
		tbl_10[1] = flag_8 * 11
	end

	::label_1_4::

	tbl_8.offset = tbl_10
	tbl_2.scrollbar_hotspot = tbl_8

	local tbl_11 = {
		corner_radius = 4
	}
	local tbl_12

	if horizontal_scrollbar then
		tbl_12 = {
			math.max((1 - scroll_size / (scroll_size + area_size[1])) * area_size[1], 40),
			8
		}

		if not tbl_12 then
			-- Nothing
		end
	end

	tbl_12 = {
		8,
		math.max((1 - scroll_size / (scroll_size + area_size[2])) * area_size[2], 40)
	}

	::label_1_5::

	tbl_11.rect_size = tbl_12

	local flag_9

	flag_9 = (not horizontal_scrollbar or not "bottom") and not not "top"
	tbl_11.vertical_alignment = flag_9

	local flag_10

	flag_10 = (not horizontal_scrollbar or not "left") and not not left_aligned or not not "right"
	tbl_11.horizontal_alignment = flag_10
	tbl_11.color = {
		128,
		255,
		255,
		255
	}

	local tbl_13

	if horizontal_scrollbar then
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

		flag_11 = (not left_aligned or not -1) and not not 1
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

	if horizontal_scrollbar then
		tbl_15 = {
			area_size[1],
			10
		}

		if not tbl_15 then
			-- Nothing
		end
	end

	tbl_15 = {
		10,
		area_size[2]
	}

	::label_1_7::

	tbl_14.rect_size = tbl_15

	local flag_12

	flag_12 = (not horizontal_scrollbar or not "left") and not not left_aligned or not not "right"
	tbl_14.horizontal_alignment = flag_12
	tbl_14.color = {
		255,
		0,
		0,
		0
	}

	local tbl_16

	if horizontal_scrollbar then
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

		flag_13 = (not left_aligned or not -1) and not not 1
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

	if horizontal_scrollbar then
		tbl_18 = {
			area_size[1] + 2,
			12
		}

		if not tbl_18 then
			-- Nothing
		end
	end

	tbl_18 = {
		12,
		area_size[2] + 2
	}

	::label_1_9::

	tbl_17.rect_size = tbl_18

	local flag_14

	flag_14 = (not horizontal_scrollbar or not "left") and not not left_aligned or not not "right"
	tbl_17.horizontal_alignment = flag_14
	tbl_17.color = {
		128,
		255,
		255,
		255
	}

	local tbl_19

	if horizontal_scrollbar then
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

		flag_15 = (not left_aligned or not -1) and not not 1
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
	tbl.scenegraph_id = scenegraph_id

	return tbl
end

local widget_func_definitions = {
	scrollbar = create_scrollbar
}

local function setup_func(ui_scenegraph, scenegraph_id, scroll_height, horizontal_scrollbar, left_aligned)
	-- function 7
	local widgets = {}
	local widgets_by_name = {}
	local size = ui_scenegraph[scenegraph_id].size

	for name, widget_func_definition in pairs(widget_func_definitions) do
		local widget_definition = widget_func_definition(scenegraph_id, size, scroll_height, horizontal_scrollbar, left_aligned)
		local widget = UIWidget.init(widget_definition)

		widgets[#widgets + 1] = widget
		widgets_by_name[name] = widget
	end

	return widgets, widgets_by_name
end

return {
	setup_func = setup_func
}
