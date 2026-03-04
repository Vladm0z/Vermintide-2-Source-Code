-- chunkname: @scripts/ui/views/hero_view/windows/store/definitions/store_window_category_list_definitions.lua

local var_0_0 = UISettings.console_menu_scenegraphs
local var_0_1 = {
	550,
	700
}
local var_0_2 = {
	550,
	80
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
		horizontal_alignment = "left",
		size = var_0_1,
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
		horizontal_alignment = "left",
		size = var_0_3,
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

local function var_0_5(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = UIFrameSettings.frame_outer_glow_04_big.texture_sizes.horizontal[2]
	local var_1_1 = {
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
	local var_1_2 = {
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
	local var_1_3 = {
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
		element = var_1_1,
		content = var_1_2,
		style = var_1_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local var_0_6 = {
	list = var_0_5("list_window", "list", var_0_1, var_0_2),
	list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "list_window", var_0_4.list_scrollbar.size, "gold", true)
}
local var_0_7 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				arg_2_3.render_settings.alpha_multiplier = 0
				arg_2_3.mask_default_width = arg_2_2.widgets_by_name.list.style.mask.size[1]
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				local var_3_0 = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = var_3_0

				local var_3_1 = arg_3_2.widgets_by_name
				local var_3_2 = arg_3_2.list_widgets
				local var_3_3 = 0

				for iter_3_0, iter_3_1 in ipairs(var_3_2) do
					local var_3_4 = iter_3_1.content
					local var_3_5 = iter_3_1.offset
					local var_3_6 = iter_3_1.default_offset
					local var_3_7 = var_3_4.row
					local var_3_8 = var_3_4.column
					local var_3_9 = math.min(var_3_7 * 50 + var_3_8 * 20, 300)

					var_3_5[1] = math.floor(var_3_6[1] + var_3_9 - var_3_9 * var_3_0)
					var_3_3 = math.max(var_3_3, var_3_9)
				end

				local var_3_10 = arg_3_4.mask_default_width
				local var_3_11 = math.floor(var_3_10 + var_3_3 - var_3_3 * var_3_0)
				local var_3_12 = var_3_1.list.style

				var_3_12.mask.size[1] = var_3_11
				var_3_12.mask_top.size[1] = var_3_11
				var_3_12.mask_bottom.size[1] = var_3_11
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
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
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = 1 - var_6_0
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_6,
	title_button_definitions = title_button_definitions,
	scenegraph_definition = var_0_4,
	animation_definitions = var_0_7
}
