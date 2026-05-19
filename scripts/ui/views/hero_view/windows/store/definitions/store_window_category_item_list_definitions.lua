-- chunkname: @scripts/ui/views/hero_view/windows/store/definitions/store_window_category_item_list_definitions.lua

local var_0_0 = UISettings.console_menu_scenegraphs
local var_0_1 = {
	800,
	700
}
local var_0_2 = {
	800,
	220
}
local var_0_3 = {
	16,
	var_0_1[2]
}
local var_0_4 = {
	screen = var_0_0.screen,
	list_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = var_0_1,
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
		size = var_0_1,
		position = {
			0,
			-var_0_1[2],
			0
		}
	},
	list_scrollbar = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "right",
		size = var_0_3,
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
local var_0_5 = {
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

local function var_0_6(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = true
	local var_1_1 = UIFrameSettings.frame_outer_glow_04_big.texture_sizes.horizontal[2]
	local var_1_2 = {
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
	local var_1_3 = {
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
	local var_1_4 = {
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
		element = var_1_2,
		content = var_1_3,
		style = var_1_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local var_0_7 = {
	title_text = UIWidgets.create_simple_text("n/a", "title_text", nil, nil, var_0_5),
	list = var_0_6("list_window", "list", var_0_1, var_0_2),
	list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "list_window", var_0_4.list_scrollbar.size, "gold"),
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
local var_0_8 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				local var_3_0 = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = var_3_0
			end,
			on_complete = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end
		}
	},
	on_item_list_initialized = {
		{
			name = "delay",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				return
			end,
			update = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				return
			end,
			on_complete = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		},
		{
			name = "fade_in",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				arg_8_3.render_settings.list_alpha_multiplier = 0
				arg_8_3.mask_default_width = arg_8_2.widgets_by_name.list.style.mask.texture_size[1]
			end,
			update = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				local var_9_0 = math.easeOutCubic(arg_9_3)

				arg_9_4.render_settings.list_alpha_multiplier = var_9_0

				local var_9_1 = arg_9_2.widgets_by_name
				local var_9_2 = arg_9_2.list_widgets
				local var_9_3 = 0

				for iter_9_0, iter_9_1 in ipairs(var_9_2) do
					local var_9_4 = iter_9_1.content
					local var_9_5 = iter_9_1.offset
					local var_9_6 = iter_9_1.default_offset
					local var_9_7 = var_9_4.row
					local var_9_8 = var_9_4.column
					local var_9_9 = math.min(var_9_7 * 50 + (4 - var_9_8) * 20, 300)

					var_9_5[1] = math.floor(var_9_6[1] - var_9_9 + var_9_9 * var_9_0)
					var_9_3 = math.max(var_9_3, var_9_9)
				end

				local var_9_10 = arg_9_4.mask_default_width
				local var_9_11 = math.floor(var_9_10 + var_9_3 - var_9_3 * var_9_0)
				local var_9_12 = var_9_1.list.style

				var_9_12.mask.texture_size[1] = var_9_11
				var_9_12.mask_top.texture_size[1] = var_9_11
				var_9_12.mask_bottom.texture_size[1] = var_9_11
			end,
			on_complete = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end
		}
	},
	on_item_list_updated = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				arg_11_3.render_settings.list_alpha_multiplier = 0
				arg_11_3.mask_default_width = arg_11_2.widgets_by_name.list.style.mask.texture_size[1]
			end,
			update = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				local var_12_0 = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.list_alpha_multiplier = var_12_0

				local var_12_1 = arg_12_2.widgets_by_name
				local var_12_2 = arg_12_2.list_widgets
				local var_12_3 = 0

				for iter_12_0, iter_12_1 in ipairs(var_12_2) do
					local var_12_4 = iter_12_1.content
					local var_12_5 = iter_12_1.offset
					local var_12_6 = iter_12_1.default_offset
					local var_12_7 = var_12_4.row
					local var_12_8 = var_12_4.column
					local var_12_9 = math.min(var_12_7 * 50 + (4 - var_12_8) * 20, 300)

					var_12_5[1] = math.floor(var_12_6[1] - var_12_9 + var_12_9 * var_12_0)
					var_12_3 = math.max(var_12_3, var_12_9)
				end

				local var_12_10 = arg_12_4.mask_default_width
				local var_12_11 = math.floor(var_12_10 + var_12_3 - var_12_3 * var_12_0)
				local var_12_12 = var_12_1.list.style

				var_12_12.mask.texture_size[1] = var_12_11
				var_12_12.mask_top.texture_size[1] = var_12_11
				var_12_12.mask_bottom.texture_size[1] = var_12_11
			end,
			on_complete = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_7,
	title_button_definitions = title_button_definitions,
	scenegraph_definition = var_0_4,
	animation_definitions = var_0_8
}
