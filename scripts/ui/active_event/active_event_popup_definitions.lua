-- chunkname: @scripts/ui/active_event/active_event_popup_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = 50
local var_0_3 = 600
local var_0_4 = 900

local_require("scripts/ui/views/deus_menu/ui_widgets_deus")

local var_0_5 = var_0_3 - var_0_2 * 2
local var_0_6 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.item_display_popup
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			var_0_3,
			var_0_4
		}
	},
	logo = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			-40,
			2
		},
		size = {
			0,
			0
		}
	},
	window_top_detail = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			6
		},
		size = {
			45,
			12
		}
	},
	window_mask = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			10
		},
		size = {
			var_0_3,
			var_0_4
		}
	},
	body_text = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			540,
			300
		}
	},
	close_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			-16,
			10
		},
		size = {
			480,
			42
		}
	},
	action_buttons_anchor = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			80,
			10
		},
		size = {
			0,
			0
		}
	}
}
local var_0_7 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 36,
	font_type = "hell_shark_header",
	horizontal_alignment = "center",
	vertical_alignment = "center",
	use_shadow = true,
	size = {
		540,
		300
	},
	area_size = {
		540,
		300
	},
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_8 = true
local var_0_9 = true
local var_0_10 = {
	logo = UIWidgets.create_simple_texture("hero_view_home_logo", "logo", nil, nil, nil, {
		-234,
		-236.39999999999998,
		1
	}, {
		468,
		236.39999999999998
	}),
	window_mask = UIWidgets.create_simple_texture("mask_rect", "window_mask"),
	window_background = UIWidgets.create_simple_texture("icons_placeholder", "screen", true, nil, nil, nil, {
		1920,
		1080
	}),
	background_fade = UIWidgets.create_simple_texture("event_upsell_background_fade", "window", nil, nil, {
		160,
		255,
		255,
		255
	}),
	window_top_detail = UIWidgets.create_simple_texture("tab_selection_01_bottom", "window_top_detail"),
	window_frame = UIWidgets.create_frame("window", {
		var_0_6.window.size[1] + 50,
		var_0_6.window.size[2] + 50
	}, "menu_frame_02", 5),
	screen_background = UIWidgets.create_simple_rect("screen", {
		50,
		0,
		0,
		0
	}),
	body_text = UIWidgets.create_simple_text("not_assigned", "body_text", nil, nil, var_0_7),
	close_button = UIWidgets.create_default_button("close_button", var_0_6.close_button.size, nil, nil, "n/a", nil, nil, nil, 34, var_0_8, var_0_9)
}

function create_simple_action_button(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_4 = arg_1_4 or "menu_frame_bg_06"

	local var_1_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_1_4)
	local var_1_1 = arg_1_3 and UIFrameSettings[arg_1_3] or UIFrameSettings.menu_frame_02
	local var_1_2 = var_1_1.texture_sizes.corner[1]

	local function var_1_3(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = arg_2_2.hover_progress or 0
		local var_2_1 = arg_2_2.press_progress or 1

		if arg_2_1.color then
			arg_2_1.color[1] = 255 * var_2_0

			if arg_2_2.is_hover then
				arg_2_1.color[1] = 255 * var_2_1
			end
		elseif arg_2_1.text_color then
			arg_2_1.text_color[1] = 255 * var_2_0

			if arg_2_2.is_hover then
				arg_2_1.text_color[1] = 255 * var_2_1
			end
		end
	end

	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_change_function = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
						local var_3_0 = arg_3_0.parent
						local var_3_1 = arg_3_0.hover_progress or 0
						local var_3_2 = 15

						if arg_3_0.is_hover or var_3_0.is_gamepad_active and arg_3_0.is_selected then
							var_3_1 = math.min(var_3_1 + arg_3_3 * var_3_2, 1)
						else
							var_3_1 = math.max(var_3_1 - arg_3_3 * var_3_2, 0)
						end

						arg_3_0.hover_progress = var_3_1

						local var_3_3 = arg_3_0.press_progress or 1
						local var_3_4 = 25

						if arg_3_0.is_held then
							var_3_3 = math.max(var_3_3 - arg_3_3 * var_3_4, 0.5)
						else
							var_3_3 = math.min(var_3_3 + arg_3_3 * var_3_4, 1)
						end

						arg_3_0.press_progress = var_3_3
					end
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
				},
				{
					texture_id = "glass_top",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass_bottom",
					style_id = "glass_bottom",
					pass_type = "texture"
				},
				{
					style_id = "texture_hover",
					pass_type = "texture",
					texture_id = "texture_hover",
					content_change_function = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
						local var_4_0 = arg_4_0.button_hotspot

						var_1_3(arg_4_0, arg_4_1, var_4_0, arg_4_3)
					end
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function(arg_5_0)
						local var_5_0 = arg_5_0.button_hotspot

						return not var_5_0.disable_button and (not var_5_0.is_selected or not var_5_0.is_hover)
					end
				},
				{
					style_id = "button_text_hovered",
					pass_type = "text",
					text_id = "button_text",
					content_change_function = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
						local var_6_0 = arg_6_0.button_hotspot

						var_1_3(arg_6_0, arg_6_1, var_6_0, arg_6_3)
					end
				}
			}
		},
		content = {
			texture_hover = "button_state_default",
			background_fade = "button_bg_fade",
			glass_top = "tabs_glass_top",
			glass_bottom = "tabs_glass_bottom",
			button_hotspot = {
				allow_multi_hover = true
			},
			frame = var_1_1.texture,
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						1,
						arg_1_1[2] / var_1_0.size[2]
					}
				},
				texture_id = arg_1_4
			},
			button_text = arg_1_2 or "n/a"
		},
		style = {
			button_hotspot = {
				size = arg_1_1,
				offset = {
					0,
					0,
					1
				}
			},
			background = {
				color = {
					255,
					150,
					150,
					150
				},
				offset = {
					0,
					0,
					0
				},
				size = arg_1_1,
				texture_size = arg_1_1
			},
			background_fade = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				},
				texture_size = arg_1_1
			},
			frame = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					arg_1_1[1] - 4,
					arg_1_1[2] - 4
				},
				frame_margins = {
					-4,
					-4
				},
				texture_size = var_1_1.texture_size,
				texture_sizes = var_1_1.texture_sizes,
				offset = {
					0,
					2,
					10
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			texture_hover = {
				color = {
					0,
					255,
					255,
					255
				},
				default_color = {
					0,
					255,
					255,
					255
				},
				hover_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					3
				},
				size = {
					arg_1_1[1],
					math.min(arg_1_1[2] - 5, 80)
				}
			},
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_1_1[2] - 3,
					5
				},
				size = {
					arg_1_1[1],
					3
				}
			},
			glass_bottom = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					5
				},
				size = {
					arg_1_1[1],
					3
				}
			},
			button_text = {
				word_wrap = false,
				upper_case = false,
				localize = true,
				font_type = "hell_shark_header",
				font_size = 28,
				vertical_alignment = "center",
				horizontal_alignment = "center",
				use_shadow = true,
				dynamic_font_size = true,
				size = arg_1_1,
				area_size = arg_1_1,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					2
				}
			},
			button_text_hovered = {
				word_wrap = false,
				upper_case = false,
				localize = true,
				font_type = "hell_shark_header",
				font_size = 28,
				vertical_alignment = "center",
				horizontal_alignment = "center",
				use_shadow = true,
				dynamic_font_size = true,
				size = arg_1_1,
				area_size = arg_1_1,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					3
				}
			}
		},
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_11 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				arg_7_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				arg_8_4.render_settings.alpha_multiplier = math.easeOutCubic(arg_8_3)
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.15,
			init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end,
			update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				arg_11_4.render_settings.alpha_multiplier = 1 - math.easeOutCubic(arg_11_3)
			end,
			on_complete = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				if arg_12_3.on_exit_func then
					arg_12_3.on_exit_func()
				end
			end
		}
	}
}
local var_0_12 = {
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
			description = "button_ok",
			priority = 3,
			input_action = "back"
		}
	}
}

return {
	scenegraph_definition = var_0_6,
	widget_definitions = var_0_10,
	animation_definitions = var_0_11,
	generic_input_actions = var_0_12,
	create_simple_action_button = create_simple_action_button
}
