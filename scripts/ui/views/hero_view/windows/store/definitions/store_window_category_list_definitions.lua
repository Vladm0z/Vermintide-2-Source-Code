-- chunkname: @scripts/ui/views/hero_view/windows/store/definitions/store_window_category_list_definitions.lua

local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl = {
	550,
	700
}
local tbl_2 = {
	550,
	80
}
local tbl_3 = {
	16,
	tbl[2]
}
local tbl_4 = {
	screen = console_menu_scenegraphs.screen,
	list_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			130,
			-215,
			10
		}
	},
	list = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			0,
			-tbl[2],
			0
		}
	},
	list_scrollbar = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "left",
		size = tbl_3,
		position = {
			-58,
			0,
			10
		}
	},
	item_root = {
		vertical_alignment = "top",
		parent = "list",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	}
}

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local var_1_0 = UIFrameSettings.frame_outer_glow_04_big.texture_sizes.horizontal[2]
	local tbl = {
		passes = {
			{
				style_id = "hotspot",
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				style_id = "list_hotspot",
				pass_type = "hotspot",
				content_id = "list_hotspot"
			},
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_texture"
			},
			{
				pass_type = "texture",
				style_id = "mask_top",
				texture_id = "mask_edge"
			},
			{
				pass_type = "rotated_texture",
				style_id = "mask_bottom",
				texture_id = "mask_edge"
			}
		}
	}
	local tbl_2 = {
		mask_edge = "mask_rect_edge_fade",
		mask_texture = "mask_rect",
		list_hotspot = {},
		button_hotspot = {},
		scrollbar = {
			scroll_amount = 0.1,
			percentage = 0.1,
			scroll_value = 1
		}
	}
	local tbl_3 = {
		hotspot = {
			size = {
				arg_1_2[1],
				arg_1_2[2]
			},
			offset = {
				0,
				0,
				0
			}
		},
		list_hotspot = {
			size = {
				arg_1_2[1] + var_1_0 * 2,
				arg_1_2[2] + var_1_0 * 2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-var_1_0,
				-var_1_0,
				0
			}
		},
		mask = {
			size = {
				arg_1_2[1] + var_1_0 * 2,
				arg_1_2[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-var_1_0,
				0,
				0
			}
		},
		mask_top = {
			size = {
				arg_1_2[1] + var_1_0 * 2,
				var_1_0
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-var_1_0,
				arg_1_2[2],
				0
			}
		},
		mask_bottom = {
			size = {
				arg_1_2[1] + var_1_0 * 2,
				var_1_0
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-var_1_0,
				-var_1_0,
				0
			},
			angle = math.pi,
			pivot = {
				(arg_1_2[1] + var_1_0 * 2) / 2,
				var_1_0 / 2
			}
		}
	}

	return {
		element = tbl,
		content = tbl_2,
		style = tbl_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local tbl_5 = {
	list = fn("list_window", "list", tbl, tbl_2),
	list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "list_window", tbl_4.list_scrollbar.size, "gold", true)
}
local tbl_6 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				arg_2_3.render_settings.alpha_multiplier = 0
				arg_2_3.mask_default_width = arg_2_2.widgets_by_name.list.style.mask.size[1]
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				local easeOutCubic = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = easeOutCubic

				local widgets_by_name = arg_3_2.widgets_by_name
				local list_widgets = arg_3_2.list_widgets
				local num = 0

				for i, v in ipairs(list_widgets) do
					local content = v.content
					local offset = v.offset
					local default_offset = v.default_offset
					local row = content.row
					local column = content.column
					local min = math.min(row * 50 + column * 20, 300)

					offset[1] = math.floor(default_offset[1] + min - min * easeOutCubic)
					num = math.max(num, min)
				end

				local mask_default_width = arg_3_4.mask_default_width
				local floor = math.floor(mask_default_width + num - num * easeOutCubic)
				local style = widgets_by_name.list.style

				style.mask.size[1] = floor
				style.mask_top.size[1] = floor
				style.mask_bottom.size[1] = floor
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				local easeOutCubic = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end
		}
	}
}

return {
	widgets = tbl_5,
	title_button_definitions = title_button_definitions,
	scenegraph_definition = tbl_4,
	animation_definitions = tbl_6
}
