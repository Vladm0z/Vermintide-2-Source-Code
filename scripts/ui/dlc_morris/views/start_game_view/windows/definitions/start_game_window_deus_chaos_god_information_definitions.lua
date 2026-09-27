-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_chaos_god_information_definitions.lua

local tbl = {
	380,
	200
}
local tbl_2 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	root_fit = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	menu_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	window = {
		vertical_alignment = "top",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			tbl[2]
		},
		position = {
			150,
			-170,
			1
		}
	},
	extra_curse = {
		vertical_alignment = "top",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			tbl[1],
			tbl[2]
		},
		position = {
			600,
			-170,
			1
		}
	}
}

local function fn(arg_1_0)
	-- function 1
	return {
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		},
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					style_id = "glow_top",
					pass_type = "texture_uv",
					content_id = "glow_top"
				},
				{
					pass_type = "texture",
					style_id = "glow_bottom",
					texture_id = "glow_bottom"
				},
				{
					pass_type = "texture",
					style_id = "header",
					texture_id = "header"
				},
				{
					pass_type = "texture",
					style_id = "glow_icon",
					texture_id = "glow_icon"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					style_id = "title",
					pass_type = "text",
					text_id = "title"
				},
				{
					style_id = "subtitle",
					pass_type = "text",
					text_id = "subtitle"
				},
				{
					style_id = "body",
					pass_type = "text",
					text_id = "body"
				}
			}
		},
		content = {
			glow_bottom = "morris_gaze_glow",
			subtitle = "n/a",
			body = "n/a",
			header = "morris_gaze_header",
			glow_icon = "circular_gradient",
			title = "n/a",
			theme = "khorne",
			background = "morris_gaze_background",
			icon = "icons_placeholder",
			glow_top = {
				texture_id = "morris_gaze_glow",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			}
		},
		style = {
			background = {},
			glow_top = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = {
					315,
					42
				},
				color = Colors.get_color_table_with_alpha("tzeentch", 0),
				offset = {
					-3,
					-5,
					1
				}
			},
			glow_bottom = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = {
					315,
					42
				},
				color = Colors.get_color_table_with_alpha("tzeentch", 0),
				offset = {
					-3,
					-25,
					2
				}
			},
			header = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = {
					387,
					157
				},
				offset = {
					-3,
					70,
					3
				}
			},
			glow_icon = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = Colors.get_color_table_with_alpha("tzeentch", 0),
				texture_size = {
					120,
					120
				},
				offset = {
					-3,
					95,
					4
				}
			},
			icon = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = Colors.get_color_table_with_alpha("white", 0),
				texture_size = {
					102,
					106
				},
				offset = {
					-3,
					100,
					5
				}
			},
			title = {
				use_shadow = true,
				upper_case = false,
				localize = true,
				font_size = 32,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("tzeentch", 255),
				offset = {
					15,
					-6,
					6
				},
				size = {
					tbl[1] - 30,
					tbl[2]
				}
			},
			subtitle = {
				use_shadow = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					-40,
					7
				},
				size = {
					tbl[1],
					tbl[2]
				}
			},
			body = {
				font_size = 20,
				horizontal_alignment = "left",
				localize = false,
				word_wrap = true,
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					40,
					20,
					8
				},
				size = {
					tbl[1] - 80,
					tbl[2] - 40 - 64
				}
			}
		}
	}
end

local tbl_3 = {
	god_info_widget = fn("window"),
	belakor_info_widget = fn("extra_curse")
}
local tbl_4 = {
	on_enter = {
		{
			name = "fade_in",
			duration = 0.3,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				arg_3_4.render_settings.alpha_multiplier = math.easeOutCubic(arg_3_3)
			end,
			on_complete = NOP
		}
	},
	on_exit = {
		{
			name = "fade_out",
			duration = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				arg_5_4.render_settings.alpha_multiplier = 1
			end,
			on_complete = NOP
		}
	},
	set_theme = {
		{
			name = "fade_in",
			delay = 0,
			duration = 0.5,
			init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				local theme_settings = arg_6_3.theme_settings
				local curse_description_color = theme_settings.curse_description_color
				local style = arg_6_2.style

				style.glow_top.color[1] = 0
				style.glow_bottom.color[1] = 0
				style.glow_icon.color[1] = 0

				Colors.copy_no_alpha_to(style.glow_top.color, curse_description_color)
				Colors.copy_no_alpha_to(style.glow_bottom.color, curse_description_color)
				Colors.copy_no_alpha_to(style.glow_icon.color, curse_description_color)
				Colors.copy_no_alpha_to(style.title.text_color, curse_description_color)

				local content = arg_6_2.content

				content.icon = theme_settings.icon
				content.title = theme_settings.journey_title

				local Localize = Localize
				local deity_name = theme_settings.deity_name

				deity_name = deity_name or "lb_unknown"

				local var_6_6 = Localize(deity_name)

				content.body = string.format(Localize("gaze_information"), var_6_6)
			end,
			update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				-- function 7
				local style = arg_7_2.style

				arg_7_3 = math.easeInCubic(arg_7_3)

				local num = 255 * arg_7_3

				style.glow_top.color[1] = num
				style.glow_bottom.color[1] = num
				style.glow_icon.color[1] = num
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_icon",
			delay = 0,
			duration = 0.25,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				arg_8_2.style.icon.color[1] = 0
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				-- function 9
				arg_9_3 = math.easeInCubic(arg_9_3)
				arg_9_2.style.icon.color[1] = 255 * arg_9_3
			end,
			on_complete = NOP
		}
	},
	set_theme_belakor = {
		{
			name = "fade_in",
			delay = 0,
			duration = 0.5,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				local theme_settings = arg_10_3.theme_settings
				local curse_description_color = theme_settings.curse_description_color
				local style = arg_10_2.style

				style.glow_top.color[1] = 0
				style.glow_bottom.color[1] = 0
				style.glow_icon.color[1] = 0

				Colors.copy_no_alpha_to(style.glow_top.color, curse_description_color)
				Colors.copy_no_alpha_to(style.glow_bottom.color, curse_description_color)
				Colors.copy_no_alpha_to(style.glow_icon.color, curse_description_color)
				Colors.copy_no_alpha_to(style.title.text_color, curse_description_color)

				local content = arg_10_2.content

				content.icon = theme_settings.icon
				content.title = theme_settings.journey_title

				local Localize = Localize
				local deity_name = theme_settings.deity_name

				deity_name = deity_name or "lb_unknown"

				local var_10_6 = Localize(deity_name)

				content.body = string.format(Localize("gaze_information"), var_10_6)
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local style = arg_11_2.style

				arg_11_3 = math.easeInCubic(arg_11_3)

				local num = 255 * arg_11_3

				style.glow_top.color[1] = num
				style.glow_bottom.color[1] = num
				style.glow_icon.color[1] = num
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_icon",
			delay = 0,
			duration = 0.25,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				arg_12_2.style.icon.color[1] = 0
			end,
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				-- function 13
				arg_13_3 = math.easeInCubic(arg_13_3)
				arg_13_2.style.icon.color[1] = 255 * arg_13_3
			end,
			on_complete = NOP
		}
	}
}

return {
	scenegraph_definition = tbl_2,
	widgets = tbl_3,
	animation_definitions = tbl_4
}
