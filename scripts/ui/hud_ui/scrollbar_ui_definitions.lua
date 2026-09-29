-- chunkname: @scripts/ui/hud_ui/scrollbar_ui_definitions.lua

local function create_scrollbar(scenegraph_id, area_size, scroll_size, horizontal_scrollbar, left_aligned)
	-- function 1
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
		},
		style = {
			gamepad_input = {
				texture_size = {
					32,
					33
				},
				horizontal_alignment = horizontal_scrollbar and not not "left" or not horizontal_scrollbar and (not not left_aligned or not not "right"),
				vertical_alignment = horizontal_scrollbar and not not "bottom" or not horizontal_scrollbar and not not "top",
				offset = horizontal_scrollbar and not not {
					0,
					16.5,
					103
				} or not horizontal_scrollbar and not not {
					(left_aligned and not not -1 or not left_aligned and not not 1) * 16,
					0,
					103
				}
			},
			scroller_hotspot = {
				area_size = horizontal_scrollbar and not not {
					math.max((1 - scroll_size / (scroll_size + area_size[1])) * area_size[1], 40),
					18
				} or not horizontal_scrollbar and not not {
					18,
					math.max((1 - scroll_size / (scroll_size + area_size[2])) * area_size[2], 40)
				},
				vertical_alignment = horizontal_scrollbar and not not "bottom" or not horizontal_scrollbar and not not "top",
				horizontal_alignment = horizontal_scrollbar and not not "left" or not horizontal_scrollbar and (not not left_aligned or not not "right"),
				offset = horizontal_scrollbar and not not {
					0,
					-1,
					102
				} or not horizontal_scrollbar and not not {
					(left_aligned and not not -1 or not left_aligned and not not 1) * 9,
					0,
					102
				}
			},
			scrollbar_hotspot = {
				vertical_alignment = "bottom",
				area_size = horizontal_scrollbar and not not {
					area_size[1] + 2,
					22
				} or not horizontal_scrollbar and not not {
					22,
					area_size[2] + 2
				},
				horizontal_alignment = horizontal_scrollbar and not not "left" or not horizontal_scrollbar and (not not left_aligned or not not "right"),
				offset = horizontal_scrollbar and not not {
					-1,
					1,
					101
				} or not horizontal_scrollbar and not not {
					(left_aligned and not not -1 or not left_aligned and not not 1) * 11,
					-1,
					101
				}
			},
			scroller = {
				corner_radius = 4,
				rect_size = horizontal_scrollbar and not not {
					math.max((1 - scroll_size / (scroll_size + area_size[1])) * area_size[1], 40),
					8
				} or not horizontal_scrollbar and not not {
					8,
					math.max((1 - scroll_size / (scroll_size + area_size[2])) * area_size[2], 40)
				},
				vertical_alignment = horizontal_scrollbar and not not "bottom" or not horizontal_scrollbar and not not "top",
				horizontal_alignment = horizontal_scrollbar and not not "left" or not horizontal_scrollbar and (not not left_aligned or not not "right"),
				color = {
					128,
					255,
					255,
					255
				},
				offset = horizontal_scrollbar and not not {
					0,
					6,
					102
				} or not horizontal_scrollbar and not not {
					(left_aligned and not not -1 or not left_aligned and not not 1) * 4,
					0,
					102
				}
			},
			scrollbar_bg = {
				vertical_alignment = "bottom",
				corner_radius = 4,
				rect_size = horizontal_scrollbar and not not {
					area_size[1],
					10
				} or not horizontal_scrollbar and not not {
					10,
					area_size[2]
				},
				horizontal_alignment = horizontal_scrollbar and not not "left" or not horizontal_scrollbar and (not not left_aligned or not not "right"),
				color = {
					255,
					0,
					0,
					0
				},
				offset = horizontal_scrollbar and not not {
					0,
					5,
					101
				} or not horizontal_scrollbar and not not {
					(left_aligned and not not -1 or not left_aligned and not not 1) * 5,
					0,
					101
				}
			},
			scrollbar_bg_bg = {
				vertical_alignment = "bottom",
				corner_radius = 4,
				rect_size = horizontal_scrollbar and not not {
					area_size[1] + 2,
					12
				} or not horizontal_scrollbar and not not {
					12,
					area_size[2] + 2
				},
				horizontal_alignment = horizontal_scrollbar and not not "left" or not horizontal_scrollbar and (not not left_aligned or not not "right"),
				color = {
					128,
					255,
					255,
					255
				},
				offset = horizontal_scrollbar and not not {
					-1,
					4,
					100
				} or not horizontal_scrollbar and not not {
					(left_aligned and not not -1 or not left_aligned and not not 1) * 6,
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
		scenegraph_id = scenegraph_id
	}
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
