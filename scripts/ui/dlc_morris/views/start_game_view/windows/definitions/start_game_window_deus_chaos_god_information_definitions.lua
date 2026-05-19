-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_chaos_god_information_definitions.lua

local var_0_0 = {
	380,
	200
}
local var_0_1 = {
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
			var_0_0[1],
			var_0_0[2]
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
			var_0_0[1],
			var_0_0[2]
		},
		position = {
			600,
			-170,
			1
		}
	}
}

local function var_0_2(arg_1_0)
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
					var_0_0[1] - 30,
					var_0_0[2]
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
					var_0_0[1],
					var_0_0[2]
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
					var_0_0[1] - 80,
					var_0_0[2] - 40 - 64
				}
			}
		}
	}
end

local var_0_3 = {
	god_info_widget = var_0_2("window"),
	belakor_info_widget = var_0_2("extra_curse")
}
local var_0_4 = {
	on_enter = {
		{
			name = "fade_in",
			duration = 0.3,
			init = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				arg_3_4.render_settings.alpha_multiplier = math.easeOutCubic(arg_3_3)
			end,
			on_complete = NOP
		}
	},
	on_exit = {
		{
			name = "fade_out",
			duration = 0.3,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
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
			init = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				local var_6_0 = arg_6_3.theme_settings
				local var_6_1 = var_6_0.curse_description_color
				local var_6_2 = arg_6_2.style

				var_6_2.glow_top.color[1] = 0
				var_6_2.glow_bottom.color[1] = 0
				var_6_2.glow_icon.color[1] = 0

				Colors.copy_no_alpha_to(var_6_2.glow_top.color, var_6_1)
				Colors.copy_no_alpha_to(var_6_2.glow_bottom.color, var_6_1)
				Colors.copy_no_alpha_to(var_6_2.glow_icon.color, var_6_1)
				Colors.copy_no_alpha_to(var_6_2.title.text_color, var_6_1)

				local var_6_3 = arg_6_2.content

				var_6_3.icon = var_6_0.icon
				var_6_3.title = var_6_0.journey_title

				local var_6_4 = Localize(var_6_0.deity_name or "lb_unknown")

				var_6_3.body = string.format(Localize("gaze_information"), var_6_4)
			end,
			update = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				local var_7_0 = arg_7_2.style

				arg_7_3 = math.easeInCubic(arg_7_3)

				local var_7_1 = 255 * arg_7_3

				var_7_0.glow_top.color[1] = var_7_1
				var_7_0.glow_bottom.color[1] = var_7_1
				var_7_0.glow_icon.color[1] = var_7_1
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_icon",
			delay = 0,
			duration = 0.25,
			init = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				arg_8_2.style.icon.color[1] = 0
			end,
			update = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
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
			init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				local var_10_0 = arg_10_3.theme_settings
				local var_10_1 = var_10_0.curse_description_color
				local var_10_2 = arg_10_2.style

				var_10_2.glow_top.color[1] = 0
				var_10_2.glow_bottom.color[1] = 0
				var_10_2.glow_icon.color[1] = 0

				Colors.copy_no_alpha_to(var_10_2.glow_top.color, var_10_1)
				Colors.copy_no_alpha_to(var_10_2.glow_bottom.color, var_10_1)
				Colors.copy_no_alpha_to(var_10_2.glow_icon.color, var_10_1)
				Colors.copy_no_alpha_to(var_10_2.title.text_color, var_10_1)

				local var_10_3 = arg_10_2.content

				var_10_3.icon = var_10_0.icon
				var_10_3.title = var_10_0.journey_title

				local var_10_4 = Localize(var_10_0.deity_name or "lb_unknown")

				var_10_3.body = string.format(Localize("gaze_information"), var_10_4)
			end,
			update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				local var_11_0 = arg_11_2.style

				arg_11_3 = math.easeInCubic(arg_11_3)

				local var_11_1 = 255 * arg_11_3

				var_11_0.glow_top.color[1] = var_11_1
				var_11_0.glow_bottom.color[1] = var_11_1
				var_11_0.glow_icon.color[1] = var_11_1
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_icon",
			delay = 0,
			duration = 0.25,
			init = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				arg_12_2.style.icon.color[1] = 0
			end,
			update = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				arg_13_3 = math.easeInCubic(arg_13_3)
				arg_13_2.style.icon.color[1] = 255 * arg_13_3
			end,
			on_complete = NOP
		}
	}
}

return {
	scenegraph_definition = var_0_1,
	widgets = var_0_3,
	animation_definitions = var_0_4
}
