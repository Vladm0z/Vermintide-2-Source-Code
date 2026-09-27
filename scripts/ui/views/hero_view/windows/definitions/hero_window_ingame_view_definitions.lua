-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_ingame_view_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local var_0_4 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_5 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local tbl = {
	size[1] - var_0_4 * 2,
	(size[2] - var_0_5 * 2) / 3.5
}
local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl_2 = {
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	area_left = console_menu_scenegraphs.area_left,
	area_right = console_menu_scenegraphs.area_right,
	area_divider = console_menu_scenegraphs.area_divider,
	top_banner = {
		vertical_alignment = "bottom",
		parent = "divider",
		horizontal_alignment = "center",
		size = {
			600,
			180
		},
		position = {
			0,
			40,
			2
		}
	},
	description_text = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			600,
			180
		},
		position = {
			0,
			-220,
			2
		}
	},
	divider = {
		vertical_alignment = "bottom",
		parent = "description_text",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-40,
			1
		}
	},
	divider_bottom = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-20,
			1
		}
	},
	background = {
		vertical_alignment = "top",
		parent = "divider",
		horizontal_alignment = "center",
		size = {
			574,
			90
		},
		position = {
			0,
			-12,
			-1
		}
	},
	title_entry = {
		vertical_alignment = "top",
		parent = "divider",
		horizontal_alignment = "center",
		size = {
			800,
			50
		},
		position = {
			0,
			-20,
			1
		}
	},
	logo = {
		vertical_alignment = "bottom",
		parent = "divider",
		horizontal_alignment = "center",
		size = {
			390,
			197
		},
		position = {
			0,
			80,
			1
		}
	}
}
local tbl_3 = {
	default = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	}
}

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	local tbl = {
		2,
		-2,
		3
	}

	if not arg_1_3 then
		tbl[1] = tbl[1] + arg_1_3[1]
		tbl[2] = tbl[2] + arg_1_3[2]
		tbl[3] = arg_1_3[3] - 1
	end

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text_field"
				},
				{
					style_id = "text_hover",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 2
						local is_hover

						if not self.button_hotspot.disable_button then
							is_hover = self.button_hotspot.is_hover

							if not is_hover then
								is_hover = self.button_hotspot.is_selected
							end
						else
							is_hover = false
						end

						if false then
							is_hover = true
						end

						return is_hover
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 3
						return not not self.button_hotspot.disable_button or not not self.button_hotspot.is_hover or not self.button_hotspot.is_selected
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 4
						return self.button_hotspot.disable_button
					end
				}
			}
		},
		content = {
			button_hotspot = {},
			text_field = arg_1_1,
			default_font_size = arg_1_2
		},
		style = {
			text = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_1_2,
				horizontal_alignment = arg_1_4 or "left",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = arg_1_3 or {
					0,
					0,
					4
				}
			},
			text_shadow = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_1_2,
				horizontal_alignment = arg_1_4 or "left",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = tbl
			},
			text_hover = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_1_2,
				horizontal_alignment = arg_1_4 or "left",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = arg_1_3 or {
					0,
					0,
					4
				}
			},
			text_disabled = {
				word_wrap = false,
				upper_case = true,
				localize = true,
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				font_size = arg_1_2,
				horizontal_alignment = arg_1_4 or "left",
				text_color = Colors.get_color_table_with_alpha("gray", 50),
				offset = arg_1_3 or {
					0,
					0,
					4
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local tbl_4 = {}
local num = 11

for i = 1, num do
	tbl_4[i] = fn("title_entry", "n/a", 52, {
		0,
		-6,
		4
	}, "center")
end

local tbl_5 = {
	divider = UIWidgets.create_simple_texture("divider_01_top", "divider"),
	divider_bottom = UIWidgets.create_simple_texture("divider_01_top", "divider_bottom"),
	background = UIWidgets.create_simple_texture("ingame_view_background_console", "background", nil, nil, {
		255,
		0,
		0,
		0
	}),
	logo = UIWidgets.create_simple_texture("hero_view_home_logo", "logo")
}
local tbl_6 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				arg_5_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				local easeOutCubic = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = easeOutCubic
				arg_6_0.area_left.local_position[1] = arg_6_1.area_left.position[1] + -100 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				arg_8_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				-- function 9
				local easeOutCubic = math.easeOutCubic(arg_9_3)

				arg_9_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				return
			end
		}
	}
}

return {
	widgets = tbl_5,
	generic_input_actions = tbl_3,
	title_button_definitions = tbl_4,
	scenegraph_definition = tbl_2,
	animation_definitions = tbl_6
}
