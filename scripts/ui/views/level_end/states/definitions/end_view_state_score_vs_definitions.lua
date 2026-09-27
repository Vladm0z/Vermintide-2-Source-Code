-- chunkname: @scripts/ui/views/level_end/states/definitions/end_view_state_score_vs_definitions.lua

local num = 20
local tbl = {
	{
		class_name = "EndViewStateScoreVSTabReport",
		name = "end_view_state_score_vs_tab_report",
		display_name = "end_view_state_score_vs_tab_report_display_name",
		condition_func = function ()
			-- function 1
			return not GameSettingsDevelopment.read_only_backend
		end
	},
	{
		class_name = "EndViewStateScoreVSTabDetails",
		name = "end_view_state_score_vs_tab_details",
		display_name = "end_view_state_score_vs_tab_details_display_name"
	}
}
local tbl_2 = {
	210,
	48
}
local tbl_3 = {
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
			tbl_2[2]
		},
		position = {
			-300,
			-110 + tbl_2[2] * 0.5,
			14
		}
	},
	tab_selection = {
		vertical_alignment = "bottom",
		parent = "tab",
		horizontal_alignment = "center",
		size = {
			tbl_2[1],
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
local tbl_4 = {
	255,
	197,
	188,
	175
}
local get_color_table_with_alpha = Colors.get_color_table_with_alpha("local_player_team", 255)
local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)
local get_color_table_with_alpha_3 = Colors.get_color_table_with_alpha("local_player_team_darker", 255)
local get_color_table_with_alpha_4 = Colors.get_color_table_with_alpha("opponent_team", 255)
local get_color_table_with_alpha_5 = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
local get_color_table_with_alpha_6 = Colors.get_color_table_with_alpha("opponent_team_darkened", 255)
local tbl_5 = {
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
local tbl_6 = {
	word_wrap = true,
	font_size = 52,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "top",
	vertical_alignment = "left",
	font_type = "hell_shark_header",
	text_color = tbl_4,
	offset = {
		0,
		0,
		2
	}
}
local tbl_7 = {
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
local tbl_8 = {
	word_wrap = true,
	font_size = 24,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = tbl_4,
	hover_color = tbl_4,
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
local tbl_9 = {
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

local function fn(arg_2_0, arg_2_1)
	-- function 2
	local size = tbl_3[arg_2_0].size

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
				texture_size = size
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

local function fn_2(arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local flag = arg_3_0 == "local_team"
	local flag_2

	flag_2 = not flag and "team_icon_local" and "team_icon_opponent"

	local var_3_2 = tbl_3[flag_2]
	local clone = table.clone(var_3_2.size)

	clone[1] = 140

	local var_3_4 = UISettings.teams_ui_assets[arg_3_1]
	local get_color_table_with_alpha

	if not flag then
		get_color_table_with_alpha = Colors.get_color_table_with_alpha("local_player_team_lighter", 255)

		if not get_color_table_with_alpha then
			-- Nothing
		end
	end

	get_color_table_with_alpha = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)

	::label_3_0::

	local clone_2 = table.clone(tbl_9)

	clone_2.size = clone
	clone_2.text_color = get_color_table_with_alpha
	clone_2.offset = {
		70,
		0,
		0
	}

	local tbl = {
		element = {
			passes = {}
		},
		content = {},
		style = {},
		scenegraph_id = flag_2,
		offset = {
			0,
			0,
			0
		}
	}
	local passes = tbl.element.passes
	local content = tbl.content
	local style = tbl.style

	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "icon",
		texture_id = "icon"
	}
	passes[#passes + 1] = {
		pass_type = "texture",
		style_id = "icon_bg",
		texture_id = "icon_bg"
	}
	content.icon = var_3_4.team_icon
	content.icon_bg = var_3_4.background_texture
	style.icon = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			80,
			80
		},
		color = get_color_table_with_alpha,
		offset = {
			-70,
			0,
			2
		}
	}
	style.icon_bg = table.clone(style.icon)
	style.icon_bg.texture_size = {
		80,
		80
	}
	style.icon_bg.offset[3] = 0
	style.icon_bg.color = get_color_table_with_alpha
	passes[#passes + 1] = {
		style_id = "score",
		pass_type = "text",
		text_id = "score"
	}
	passes[#passes + 1] = {
		style_id = "score_shadow",
		pass_type = "text",
		text_id = "score"
	}
	content.score = tostring(arg_3_2)
	style.score = clone_2
	style.score_shadow = table.clone(clone_2)
	style.score_shadow.text_color = {
		255,
		0,
		0,
		0
	}
	style.score_shadow.offset = {
		style.score_shadow.offset[1] + 1,
		-1,
		-1
	}

	return tbl
end

local function fn_3(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local offset

	if not arg_4_3 then
		offset = arg_4_3.offset

		if not offset then
			-- Nothing
		end
	end

	offset = {
		0,
		0,
		2
	}

	do
		local text_color
	end

	::label_4_0::

	if not arg_4_3 then
		text_color = arg_4_3.text_color

		if not text_color then
			-- Nothing
		end
	end

	text_color = {
		255,
		255,
		255,
		255
	}

	::label_4_1::

	local clone = table.clone(arg_4_3)
	local shadow_color = arg_4_3.shadow_color

	shadow_color = shadow_color or {
		255,
		0,
		0,
		0
	}

	local shadow_offset = arg_4_3.shadow_offset

	shadow_offset = shadow_offset or {
		2,
		2,
		0
	}
	shadow_color[1] = text_color[1]
	clone.text_color = shadow_color
	clone.offset = {
		offset[1] + shadow_offset[1],
		offset[2] - shadow_offset[2],
		offset[3] - 1
	}
	clone.skip_button_rendering = true

	local clone_2 = table.clone(arg_4_3)

	clone_2.offset[1] = clone_2.font_size * 0.75

	local tbl = {
		element = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot",
					content_check_function = function (arg_5_0, arg_5_1)
						-- function 5
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_6_0, arg_6_1)
						-- function 6
						return not Managers.input:is_device_active("gamepad")
					end,
					content_change_function = function (self, arg_7_1)
						-- function 7
						local hover_color

						if not self.hotspot.is_hover then
							hover_color = arg_7_1.hover_color

							if not hover_color then
								-- Nothing
							end
						end

						hover_color = arg_7_1.base_color

						::label_7_0::

						arg_7_1.text_color = hover_color
					end
				},
				{
					style_id = "gamepad_text",
					pass_type = "text",
					text_id = "gamepad_text",
					content_check_function = function (arg_8_0, arg_8_1)
						-- function 8
						return Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_9_0, arg_9_1)
						-- function 9
						return not Managers.input:is_device_active("gamepad")
					end
				}
			}
		}
	}
	local tbl_2 = {
		text = arg_4_0,
		gamepad_text = arg_4_1,
		original_text = arg_4_0,
		color = text_color
	}
	local use_shadow

	if not arg_4_3 then
		use_shadow = arg_4_3.use_shadow

		if not use_shadow then
			-- Nothing
		end
	end

	use_shadow = false

	::label_4_2::

	tbl_2.use_shadow = use_shadow
	tbl_2.hotspot = {}
	tbl.content = tbl_2
	tbl.style = {
		hotspot = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			area_size = {
				60,
				60
			}
		},
		text = arg_4_3,
		gamepad_text = clone_2,
		text_shadow = clone
	}
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_4_2

	return tbl
end

local flag = true
local tbl_10 = {
	level = UIWidgets.create_level_widget("level"),
	level_text = UIWidgets.create_simple_text("Righteous Stand", "level_text", nil, nil, tbl_6),
	match_finsihed_text = UIWidgets.create_simple_text(Localize("vs_match_completed"), "match_finished_text", nil, nil, tbl_7),
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
	tab_selection = fn("tab_selection", {
		255,
		201,
		201,
		201
	}),
	prev_tab = fn_3("$KEY;ingame_menu__cycle_prev_raw:", "$KEY;ingame_menu__cycle_prev_raw:", "tab_selection", tbl_8),
	next_tab = fn_3("$KEY;ingame_menu__cycle_next_alt_raw:", "$KEY;ingame_menu__cycle_next_alt_raw:", "tab_selection", tbl_8),
	back_to_keep_button = UIWidgets.create_default_button("back_to_keep_button", tbl_3.back_to_keep_button.size, nil, nil, Localize("return_to_inn"), 25, nil, nil, nil, flag)
}
local tbl_11 = {
	transition_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				arg_10_3.render_settings.alpha_multiplier = 0
				arg_10_0.panel.local_position[2] = arg_10_1.panel.position[2] + 200
				arg_10_0.back_to_keep_button.local_position[2] = arg_10_1.back_to_keep_button.position[2] - 200
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local easeOutCubic = math.easeOutCubic(arg_11_3)

				arg_11_4.render_settings.alpha_multiplier = easeOutCubic
				arg_11_0.panel.local_position[2] = math.lerp(arg_11_1.panel.position[2] + 200, arg_11_1.panel.position[2], easeOutCubic)
				arg_11_0.back_to_keep_button.local_position[2] = math.lerp(arg_11_1.back_to_keep_button.position[2] - 200, arg_11_1.back_to_keep_button.position[2], easeOutCubic)
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
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
				-- function 13
				arg_13_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				local easeInCubic = math.easeInCubic(arg_14_3)

				arg_14_4.render_settings.alpha_multiplier = 1 - easeInCubic
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				return
			end
		}
	}
}

local function fn_4(arg_16_0, arg_16_1)
	-- function 16
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
					content_check_function = function (self, arg_17_1)
						-- function 17
						return not not self.hotspot.is_hover or not self.hotspot.is_selected
					end
				},
				{
					style_id = "hover_text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 18
						local is_hover = self.hotspot.is_hover

						is_hover = is_hover or self.hotspot.is_selected

						return is_hover
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
					tbl_2[2]
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
				text_color = tbl_4,
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
	widgets = tbl_10,
	tab_layouts = tbl,
	scenegraph_definition = tbl_3,
	animation_definitions = tbl_11,
	create_tab = fn_4,
	tab_size = tbl_2,
	create_team_score_func = fn_2
}
