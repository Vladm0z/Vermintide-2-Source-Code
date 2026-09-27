-- chunkname: @scripts/ui/views/hero_view/windows/store/definitions/store_window_category_item_list_definitions.lua

local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl = {
	800,
	700
}
local tbl_2 = {
	800,
	220
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
		horizontal_alignment = "right",
		size = tbl,
		position = {
			-130,
			-215,
			10
		}
	},
	list = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "right",
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
		horizontal_alignment = "right",
		size = tbl_3,
		position = {
			58,
			0,
			10
		}
	},
	list_detail_top_left = {
		vertical_alignment = "top",
		parent = "list_scrollbar",
		horizontal_alignment = "right",
		size = {
			157,
			97
		},
		position = {
			45,
			60,
			2
		}
	},
	list_detail_bottom_left = {
		vertical_alignment = "bottom",
		parent = "list_scrollbar",
		horizontal_alignment = "right",
		size = {
			157,
			97
		},
		position = {
			45,
			-60,
			2
		}
	},
	list_detail_top_center = {
		vertical_alignment = "top",
		parent = "list_detail_top_left",
		horizontal_alignment = "right",
		size = {
			750,
			97
		},
		position = {
			-157,
			0,
			0
		}
	},
	list_detail_bottom_center = {
		vertical_alignment = "bottom",
		parent = "list_detail_bottom_left",
		horizontal_alignment = "right",
		size = {
			750,
			97
		},
		position = {
			-157,
			0,
			0
		}
	},
	list_detail_top_right = {
		vertical_alignment = "top",
		parent = "list_detail_top_center",
		horizontal_alignment = "left",
		size = {
			23,
			97
		},
		position = {
			-23,
			0,
			0
		}
	},
	list_detail_bottom_right = {
		vertical_alignment = "bottom",
		parent = "list_detail_bottom_center",
		horizontal_alignment = "left",
		size = {
			23,
			97
		},
		position = {
			-23,
			0,
			0
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "list_detail_top_center",
		horizontal_alignment = "left",
		size = {
			780,
			60
		},
		position = {
			5,
			20,
			1
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
local tbl_5 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 64,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local flag = true
	local var_1_1 = UIFrameSettings.frame_outer_glow_04_big.texture_sizes.horizontal[2]
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
				arg_1_2[1] + var_1_1 * 2,
				arg_1_2[2] + var_1_1 * 2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-var_1_1,
				-var_1_1,
				0
			}
		},
		mask = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			texture_size = {
				arg_1_2[1] + var_1_1 * 2,
				arg_1_2[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_1_1,
				0,
				0
			}
		},
		mask_top = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			texture_size = {
				arg_1_2[1] + var_1_1 * 2,
				var_1_1
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_1_1,
				arg_1_2[2],
				0
			}
		},
		mask_bottom = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			texture_size = {
				arg_1_2[1] + var_1_1 * 2,
				var_1_1
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_1_1,
				-var_1_1,
				0
			},
			angle = math.pi,
			pivot = {
				(arg_1_2[1] + var_1_1 * 2) / 2,
				var_1_1 / 2
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

local tbl_6 = {
	title_text = UIWidgets.create_simple_text("n/a", "title_text", nil, nil, tbl_5),
	list = fn("list_window", "list", tbl, tbl_2),
	list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "list_window", tbl_4.list_scrollbar.size, "gold"),
	list_detail_top_left = UIWidgets.create_simple_uv_texture("divider_skull_left", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "list_detail_top_left"),
	list_detail_bottom_left = UIWidgets.create_simple_uv_texture("divider_skull_left", {
		{
			1,
			1
		},
		{
			0,
			0
		}
	}, "list_detail_bottom_left"),
	list_detail_top_center = UIWidgets.create_tiled_texture("list_detail_top_center", "divider_skull_middle", {
		64,
		97
	}),
	list_detail_bottom_center = UIWidgets.create_tiled_texture("list_detail_bottom_center", "divider_skull_middle_down", {
		64,
		97
	}),
	list_detail_top_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "list_detail_top_right"),
	list_detail_bottom_right = UIWidgets.create_simple_uv_texture("divider_skull_right", {
		{
			1,
			1
		},
		{
			0,
			0
		}
	}, "list_detail_bottom_right")
}
local tbl_7 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				local easeOutCubic = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end
		}
	},
	on_item_list_initialized = {
		{
			name = "delay",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				return
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				return
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end
		},
		{
			name = "fade_in",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				arg_8_3.render_settings.list_alpha_multiplier = 0
				arg_8_3.mask_default_width = arg_8_2.widgets_by_name.list.style.mask.texture_size[1]
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				-- function 9
				local easeOutCubic = math.easeOutCubic(arg_9_3)

				arg_9_4.render_settings.list_alpha_multiplier = easeOutCubic

				local widgets_by_name = arg_9_2.widgets_by_name
				local list_widgets = arg_9_2.list_widgets
				local num = 0

				for i, v in ipairs(list_widgets) do
					local content = v.content
					local offset = v.offset
					local default_offset = v.default_offset
					local row = content.row
					local column = content.column
					local min = math.min(row * 50 + (4 - column) * 20, 300)

					offset[1] = math.floor(default_offset[1] - min + min * easeOutCubic)
					num = math.max(num, min)
				end

				local mask_default_width = arg_9_4.mask_default_width
				local floor = math.floor(mask_default_width + num - num * easeOutCubic)
				local style = widgets_by_name.list.style

				style.mask.texture_size[1] = floor
				style.mask_top.texture_size[1] = floor
				style.mask_bottom.texture_size[1] = floor
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end
		}
	},
	on_item_list_updated = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				arg_11_3.render_settings.list_alpha_multiplier = 0
				arg_11_3.mask_default_width = arg_11_2.widgets_by_name.list.style.mask.texture_size[1]
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				-- function 12
				local easeOutCubic = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.list_alpha_multiplier = easeOutCubic

				local widgets_by_name = arg_12_2.widgets_by_name
				local list_widgets = arg_12_2.list_widgets
				local num = 0

				for i, v in ipairs(list_widgets) do
					local content = v.content
					local offset = v.offset
					local default_offset = v.default_offset
					local row = content.row
					local column = content.column
					local min = math.min(row * 50 + (4 - column) * 20, 300)

					offset[1] = math.floor(default_offset[1] - min + min * easeOutCubic)
					num = math.max(num, min)
				end

				local mask_default_width = arg_12_4.mask_default_width
				local floor = math.floor(mask_default_width + num - num * easeOutCubic)
				local style = widgets_by_name.list.style

				style.mask.texture_size[1] = floor
				style.mask_top.texture_size[1] = floor
				style.mask_bottom.texture_size[1] = floor
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end
		}
	}
}

return {
	widgets = tbl_6,
	title_button_definitions = title_button_definitions,
	scenegraph_definition = tbl_4,
	animation_definitions = tbl_7
}
