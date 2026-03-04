-- chunkname: @scripts/ui/views/level_end/states/definitions/end_view_state_score_vs_definitions.lua

local var_0_0 = 20
local var_0_1 = {
	{
		class_name = "EndViewStateScoreVSTabReport",
		name = "end_view_state_score_vs_tab_report",
		display_name = "end_view_state_score_vs_tab_report_display_name",
		condition_func = function ()
			return not script_data["eac-untrusted"]
		end
	},
	{
		class_name = "EndViewStateScoreVSTabDetails",
		name = "end_view_state_score_vs_tab_details",
		display_name = "end_view_state_score_vs_tab_details_display_name"
	}
}
local var_0_2 = {
	210,
	48
}
local var_0_3 = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.end_screen
		}
	},
	panel = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			1920,
			200
		},
		position = {
			0,
			0,
			UILayer.default + 1
		}
	},
	panel_edge = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			1920,
			4
		},
		position = {
			0,
			0,
			UILayer.default + 10
		}
	},
	bottom_panel = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			1920,
			79
		},
		position = {
			0,
			0,
			UILayer.default + 1
		}
	},
	fit_panel = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "center",
		size = {
			1920,
			160
		},
		position = {
			0,
			0,
			0
		}
	},
	back_button = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			40,
			-120,
			3
		}
	},
	close_button = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			40,
			-34,
			3
		}
	},
	panel_entry_area = {
		vertical_alignment = "bottom",
		parent = "panel",
		horizontal_alignment = "center",
		size = {
			1600,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	tab = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "right",
		size = {
			0,
			var_0_2[2]
		},
		position = {
			-300,
			-110 + var_0_2[2] * 0.5,
			14
		}
	},
	tab_selection = {
		vertical_alignment = "bottom",
		parent = "tab",
		horizontal_alignment = "center",
		size = {
			var_0_2[1],
			2
		},
		position = {
			0,
			-5,
			0
		}
	},
	level = {
		vertical_alignment = "top",
		parent = "fit_panel",
		horizontal_alignment = "left",
		size = {
			180,
			180
		},
		position = {
			230,
			-12,
			50
		}
	},
	team_icon_local = {
		vertical_alignment = "center",
		parent = "fit_panel",
		horizontal_alignment = "left",
		size = {
			180,
			180
		},
		position = {
			75,
			35,
			50
		}
	},
	team_icon_opponent = {
		parent = "team_icon_local",
		size = {
			180,
			180
		},
		position = {
			0,
			-70,
			0
		}
	},
	level_text = {
		vertical_alignment = "top",
		parent = "level",
		horizontal_alignment = "left",
		size = {
			1920,
			180
		},
		position = {
			200,
			80,
			0
		}
	},
	match_finished_text = {
		vertical_alignment = "top",
		parent = "level_text",
		horizontal_alignment = "left",
		size = {
			1920,
			180
		},
		position = {
			0,
			-30,
			0
		}
	},
	back_to_keep_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			300,
			75
		},
		position = {
			0,
			50,
			0
		}
	}
}
local var_0_4 = {
	255,
	197,
	188,
	175
}
local var_0_5 = Colors.get_color_table_with_alpha("local_player_team", 255)
local var_0_6 = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)
local var_0_7 = Colors.get_color_table_with_alpha("local_player_team_darker", 255)
local var_0_8 = Colors.get_color_table_with_alpha("opponent_team", 255)
local var_0_9 = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
local var_0_10 = Colors.get_color_table_with_alpha("opponent_team_darkened", 255)
local var_0_11 = {
	word_wrap = true,
	font_size = 150,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_12 = {
	word_wrap = true,
	font_size = 52,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "top",
	vertical_alignment = "left",
	font_type = "hell_shark_header",
	text_color = var_0_4,
	offset = {
		0,
		0,
		2
	}
}
local var_0_13 = {
	word_wrap = true,
	font_size = 28,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "top",
	vertical_alignment = "left",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_14 = {
	word_wrap = true,
	font_size = 24,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = var_0_4,
	hover_color = var_0_4,
	base_color = {
		255,
		128,
		128,
		128
	},
	offset = {
		0,
		30,
		2
	}
}
local var_0_15 = {
	word_wrap = false,
	upper_case = true,
	localize = false,
	font_size = 28,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		-2,
		1
	},
	size = {
		0,
		0
	}
}

local function var_0_16(arg_2_0, arg_2_1)
	local var_2_0 = var_0_3[arg_2_0].size

	return {
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "rect"
				}
			}
		},
		content = {},
		style = {
			rect = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				color = arg_2_1 or {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				},
				texture_size = var_2_0
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_2_0
	}
end

local function var_0_17(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0 == "local_team"
	local var_3_1 = var_3_0 and "team_icon_local" or "team_icon_opponent"
	local var_3_2 = var_0_3[var_3_1]
	local var_3_3 = table.clone(var_3_2.size)

	var_3_3[1] = 140

	local var_3_4 = UISettings.teams_ui_assets[arg_3_1]
	local var_3_5 = var_3_0 and Colors.get_color_table_with_alpha("local_player_team_lighter", 255) or Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
	local var_3_6 = table.clone(var_0_15)

	var_3_6.size = var_3_3
	var_3_6.text_color = var_3_5
	var_3_6.offset = {
		70,
		0,
		0
	}

	local var_3_7 = {
		element = {
			passes = {}
		},
		content = {},
		style = {},
		scenegraph_id = var_3_1,
		offset = {
			0,
			0,
			0
		}
	}
	local var_3_8 = var_3_7.element.passes
	local var_3_9 = var_3_7.content
	local var_3_10 = var_3_7.style

	var_3_8[#var_3_8 + 1] = {
		pass_type = "texture",
		style_id = "icon",
		texture_id = "icon"
	}
	var_3_8[#var_3_8 + 1] = {
		pass_type = "texture",
		style_id = "icon_bg",
		texture_id = "icon_bg"
	}
	var_3_9.icon = var_3_4.team_icon
	var_3_9.icon_bg = var_3_4.background_texture
	var_3_10.icon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			80,
			80
		},
		color = var_3_5,
		offset = {
			-70,
			0,
			2
		}
	}
	var_3_10.icon_bg = table.clone(var_3_10.icon)
	var_3_10.icon_bg.texture_size = {
		80,
		80
	}
	var_3_10.icon_bg.offset[3] = 0
	var_3_10.icon_bg.color = var_3_5
	var_3_8[#var_3_8 + 1] = {
		style_id = "score",
		pass_type = "text",
		text_id = "score"
	}
	var_3_8[#var_3_8 + 1] = {
		style_id = "score_shadow",
		pass_type = "text",
		text_id = "score"
	}
	var_3_9.score = tostring(arg_3_2)
	var_3_10.score = var_3_6
	var_3_10.score_shadow = table.clone(var_3_6)
	var_3_10.score_shadow.text_color = {
		255,
		0,
		0,
		0
	}
	var_3_10.score_shadow.offset = {
		var_3_10.score_shadow.offset[1] + 1,
		-1,
		-1
	}

	return var_3_7
end

local function var_0_18(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_3 and arg_4_3.offset or {
		0,
		0,
		2
	}
	local var_4_1 = arg_4_3 and arg_4_3.text_color or {
		255,
		255,
		255,
		255
	}
	local var_4_2 = table.clone(arg_4_3)
	local var_4_3 = arg_4_3.shadow_color or {
		255,
		0,
		0,
		0
	}
	local var_4_4 = arg_4_3.shadow_offset or {
		2,
		2,
		0
	}

	var_4_3[1] = var_4_1[1]
	var_4_2.text_color = var_4_3
	var_4_2.offset = {
		var_4_0[1] + var_4_4[1],
		var_4_0[2] - var_4_4[2],
		var_4_0[3] - 1
	}
	var_4_2.skip_button_rendering = true

	local var_4_5 = table.clone(arg_4_3)

	var_4_5.offset[1] = var_4_5.font_size * 0.75

	return {
		element = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot",
					content_check_function = function (arg_5_0, arg_5_1)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_6_0, arg_6_1)
						return not Managers.input:is_device_active("gamepad")
					end,
					content_change_function = function (arg_7_0, arg_7_1)
						arg_7_1.text_color = arg_7_0.hotspot.is_hover and arg_7_1.hover_color or arg_7_1.base_color
					end
				},
				{
					style_id = "gamepad_text",
					pass_type = "text",
					text_id = "gamepad_text",
					content_check_function = function (arg_8_0, arg_8_1)
						return Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_9_0, arg_9_1)
						return not Managers.input:is_device_active("gamepad")
					end
				}
			}
		},
		content = {
			text = arg_4_0,
			gamepad_text = arg_4_1,
			original_text = arg_4_0,
			color = var_4_1,
			use_shadow = arg_4_3 and arg_4_3.use_shadow or false,
			hotspot = {}
		},
		style = {
			hotspot = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				area_size = {
					60,
					60
				}
			},
			text = arg_4_3,
			gamepad_text = var_4_5,
			text_shadow = var_4_2
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_4_2
	}
end

local var_0_19 = true
local var_0_20 = {
	level = UIWidgets.create_level_widget("level"),
	level_text = UIWidgets.create_simple_text("Righteous Stand", "level_text", nil, nil, var_0_12),
	match_finsihed_text = UIWidgets.create_simple_text(Localize("vs_match_completed"), "match_finished_text", nil, nil, var_0_13),
	banner = UIWidgets.create_shader_tiled_texture("panel", "carousel_end_screen_panel", {
		512,
		200
	}),
	banner_mask = UIWidgets.create_shader_tiled_texture("panel", "carousel_end_screen_panel_mask", {
		512,
		200
	}),
	banner_gradient = UIWidgets.create_simple_texture("end_screen_banner_gradient", "panel", nil, nil, {
		76.8,
		255,
		255,
		255
	}, {
		0,
		0,
		10
	}),
	tab_selection = var_0_16("tab_selection", {
		255,
		201,
		201,
		201
	}),
	prev_tab = var_0_18("$KEY;ingame_menu__cycle_prev_raw:", "$KEY;ingame_menu__cycle_prev_raw:", "tab_selection", var_0_14),
	next_tab = var_0_18("$KEY;ingame_menu__cycle_next_alt_raw:", "$KEY;ingame_menu__cycle_next_alt_raw:", "tab_selection", var_0_14),
	back_to_keep_button = UIWidgets.create_default_button("back_to_keep_button", var_0_3.back_to_keep_button.size, nil, nil, Localize("return_to_inn"), 25, nil, nil, nil, var_0_19)
}
local var_0_21 = {
	transition_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				arg_10_3.render_settings.alpha_multiplier = 0
				arg_10_0.panel.local_position[2] = arg_10_1.panel.position[2] + 200
				arg_10_0.back_to_keep_button.local_position[2] = arg_10_1.back_to_keep_button.position[2] - 200
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				local var_11_0 = math.easeOutCubic(arg_11_3)

				arg_11_4.render_settings.alpha_multiplier = var_11_0
				arg_11_0.panel.local_position[2] = math.lerp(arg_11_1.panel.position[2] + 200, arg_11_1.panel.position[2], var_11_0)
				arg_11_0.back_to_keep_button.local_position[2] = math.lerp(arg_11_1.back_to_keep_button.position[2] - 200, arg_11_1.back_to_keep_button.position[2], var_11_0)
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end
		}
	},
	transition_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				arg_13_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				local var_14_0 = math.easeInCubic(arg_14_3)

				arg_14_4.render_settings.alpha_multiplier = 1 - var_14_0
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				return
			end
		}
	}
}

local function var_0_22(arg_16_0, arg_16_1)
	return {
		element = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_17_0, arg_17_1)
						return not arg_17_0.hotspot.is_hover and not arg_17_0.hotspot.is_selected
					end
				},
				{
					style_id = "hover_text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_18_0)
						return arg_18_0.hotspot.is_hover or arg_18_0.hotspot.is_selected
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				}
			}
		},
		content = {
			text = arg_16_1,
			hotspot = {}
		},
		style = {
			hotspot = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				area_size = {
					0,
					var_0_2[2]
				}
			},
			text = {
				font_size = 24,
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				line_colors = {},
				offset = {
					0,
					0,
					2
				}
			},
			hover_text = {
				font_size = 24,
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = var_0_4,
				line_colors = {},
				offset = {
					0,
					0,
					2
				}
			},
			text_shadow = {
				font_size = 24,
				upper_case = true,
				localize = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				line_colors = {},
				offset = {
					2,
					-2,
					1
				}
			}
		},
		scenegraph_id = arg_16_0,
		offset = {
			0,
			0,
			0
		}
	}
end

return {
	widgets = var_0_20,
	tab_layouts = var_0_1,
	scenegraph_definition = var_0_3,
	animation_definitions = var_0_21,
	create_tab = var_0_22,
	tab_size = var_0_2,
	create_team_score_func = var_0_17
}
