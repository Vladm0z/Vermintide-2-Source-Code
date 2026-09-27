-- chunkname: @scripts/ui/views/hero_view/windows/store/definitions/store_window_path_title_definitions.lua

local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl = {
	screen = console_menu_scenegraphs.screen,
	panel = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			1920,
			80
		},
		position = {
			0,
			-90,
			UILayer.default + 1
		}
	},
	breadcrumbs = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			64,
			48
		},
		position = {
			100,
			-90,
			100
		}
	}
}

local function fn()
	-- function 1
	return {
		scenegraph_id = "breadcrumbs",
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				}
			}
		},
		content = {
			text = "store_icon_breadcrumb",
			texture_id = "store_icon_breadcrumb",
			button_hotspot = {}
		},
		style = {
			button_hotspot = {
				size = {
					200,
					48
				},
				color = {
					150,
					255,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				}
			},
			texture_id = {
				color = {
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
			},
			text = {
				font_size = 28,
				upper_case = false,
				localize = false,
				horizontal_alignment = "left",
				use_shadow = true,
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					70,
					0,
					1
				}
			},
			text_shadow = {
				font_size = 28,
				upper_case = false,
				localize = false,
				use_shadow = true,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					72,
					-2,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local tbl_2 = {}
local tbl_3 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
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
	widgets = tbl_2,
	create_breadcrumbs_definition = fn,
	scenegraph_definition = tbl,
	animation_definitions = tbl_3
}
