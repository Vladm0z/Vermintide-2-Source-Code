-- chunkname: @scripts/ui/views/telemetry_survey_view_definitions.lua

local var_0_0 = {
	15,
	15
}
local var_0_1 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.default
		},
		size = {
			1920,
			1080
		}
	},
	background_1 = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			80
		},
		size = {
			1920,
			1080
		}
	},
	background_2 = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			100
		},
		size = {
			680,
			512
		}
	},
	headers = {
		vertical_alignment = "top",
		parent = "background_2",
		horizontal_alignment = "center",
		position = {
			0,
			-110,
			5
		},
		size = {
			640,
			45
		}
	},
	survey_rating_buttons = {
		vertical_alignment = "top",
		parent = "background_2",
		horizontal_alignment = "center",
		size = {
			58,
			58
		},
		position = {
			0,
			-(275 + var_0_0[2] - 58),
			2
		}
	},
	survey_window_button = {
		vertical_alignment = "top",
		parent = "background_2",
		horizontal_alignment = "center",
		size = {
			220,
			58
		},
		position = {
			0,
			-(450 + var_0_0[2] - 58),
			2
		}
	}
}
local var_0_2 = {
	background_1 = {
		scenegraph_id = "background_1",
		element = UIElements.SimpleTexture,
		content = {
			texture_id = "gradient_playerlist"
		},
		style = {
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	background_2 = {
		scenegraph_id = "background_2",
		element = UIElements.SimpleTexture,
		content = {
			texture_id = "large_frame_01"
		},
		style = {
			color = {
				255,
				255,
				255,
				255
			}
		}
	},
	headers = {
		scenegraph_id = "headers",
		element = {
			passes = {
				{
					style_id = "survey_header",
					pass_type = "text",
					text_id = "survey_header"
				},
				{
					style_id = "time_left",
					pass_type = "text",
					text_id = "time_left"
				}
			}
		},
		content = {
			time_left = "",
			survey_header = "telemetry_survey_header"
		},
		style = {
			survey_header = {
				font_type = "hell_shark",
				dynamic_font = true,
				localize = true,
				font_size = 42,
				horizontal_alignment = "center",
				word_wrap = true,
				offset = {
					0,
					0,
					0
				},
				text_color = Colors.get_table("antique_white")
			},
			time_left = {
				font_type = "hell_shark",
				dynamic_font = true,
				horizontal_alignment = "center",
				font_size = 28,
				offset = {
					0,
					-40,
					0
				},
				text_color = Colors.get_table("antique_white")
			}
		}
	},
	continue_button = {
		scenegraph_id = "survey_window_button",
		element = UIElements.Button4States,
		content = {
			text_field = "telemetry_survey_submit_button",
			texture_click_id = "small_button_02_gold_selected",
			texture_id = "small_button_02_gold_normal",
			disabled = false,
			texture_hover_id = "small_button_02_gold_hover",
			texture_disabled_id = "small_button_02_gold_disabled",
			button_hotspot = {}
		},
		style = {
			text = {
				localize = true,
				font_size = 24,
				pixel_perfect = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font = true,
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_table("antique_white"),
				base_color = Colors.get_table("antique_white"),
				disabled_color = Colors.get_table("dim_gray"),
				offset = {
					0,
					5,
					2
				}
			}
		}
	}
}
local var_0_3 = 4

local function var_0_4(arg_1_0)
	local var_1_0 = arg_1_0 - 1
	local var_1_1 = (var_0_3 + 58) * var_1_0 + 29 - (58 + var_0_3) * 2.5

	return {
		scenegraph_id = "survey_rating_buttons",
		element = {
			passes = {
				{
					style_id = "style_normal",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "style_normal",
					texture_id = "texture_id",
					content_check_function = function(arg_2_0)
						return not arg_2_0.button_hotspot.is_hover and arg_2_0.button_hotspot.is_clicked > 0
					end
				},
				{
					pass_type = "texture",
					style_id = "style_hover",
					texture_id = "texture_hover_id",
					content_check_function = function(arg_3_0)
						return arg_3_0.button_hotspot.is_hover and arg_3_0.button_hotspot.is_clicked > 0
					end
				},
				{
					pass_type = "texture",
					style_id = "style_click",
					texture_id = "texture_click_id",
					content_check_function = function(arg_4_0)
						return arg_4_0.button_hotspot.is_clicked == 0 or arg_4_0.button_hotspot.is_selected
					end
				},
				{
					pass_type = "on_click",
					click_check_content_id = "button_hotspot",
					click_function = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
						arg_5_2.button_hotspot.is_selected = true
					end
				}
			}
		},
		content = {
			texture_hover_id = "sun_icon_selected",
			texture_click_id = "sun_icon",
			texture_id = "sun_icon",
			button_hotspot = {}
		},
		style = {
			style_normal = {
				horizontal_alignment = "center",
				color = {
					50,
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
			style_hover = {
				horizontal_alignment = "center",
				offset = {
					var_1_1,
					0,
					0
				}
			},
			style_click = {
				horizontal_alignment = "center",
				offset = {
					var_1_1,
					0,
					0
				}
			}
		}
	}
end

return {
	scenegraph_definition = var_0_1,
	widget_definitions = var_0_2,
	survey_rating_definitions = var_0_4
}
