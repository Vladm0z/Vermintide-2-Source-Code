-- chunkname: @scripts/ui/hud_ui/versus_tab_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	620,
	160
}
local var_0_3 = {
	screen = {
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
		},
		scale = not IS_WINDOWS and "hud_fit" or "fit"
	},
	level_name = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			400,
			60
		},
		position = {
			0,
			-200,
			10
		}
	},
	title_divider = {
		vertical_alignment = "center",
		parent = "level_name",
		horizontal_alignment = "center",
		size = {
			264,
			21
		},
		position = {
			0,
			-40,
			0
		}
	},
	sub_title = {
		vertical_alignment = "center",
		parent = "title_divider",
		horizontal_alignment = "center",
		size = {
			1600,
			60
		},
		position = {
			0,
			-40,
			0
		}
	},
	privacy_text = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			1900,
			30
		},
		position = {
			-10,
			-10,
			10
		}
	},
	player_list_input_description = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1900,
			60
		},
		position = {
			0,
			60,
			10
		}
	},
	vs_text = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			500,
			50
		},
		position = {
			0,
			0,
			10
		}
	},
	talent_tooltip = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			400,
			0
		},
		position = {
			0,
			0,
			20
		}
	},
	item_tooltip = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			400,
			0
		},
		position = {
			0,
			0,
			20
		}
	},
	objective = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			544,
			55
		},
		position = {
			0,
			-4,
			2
		}
	},
	score = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			302.4,
			117.6
		},
		position = {
			0,
			-60,
			10
		}
	},
	console_cursor = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			-10
		}
	},
	team_1 = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			20,
			210,
			10
		}
	},
	team_1_icon = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			232,
			196
		},
		position = {
			-320,
			0,
			20
		}
	},
	team_1_name = {
		vertical_alignment = "top",
		parent = "team_1",
		horizontal_alignment = "left",
		size = {
			500,
			50
		},
		position = {
			28,
			105,
			3
		}
	},
	team_1_text = {
		vertical_alignment = "top",
		parent = "team_1",
		horizontal_alignment = "left",
		size = {
			500,
			40
		},
		position = {
			28,
			160,
			3
		}
	},
	team_1_side_text = {
		vertical_alignment = "top",
		parent = "team_1",
		horizontal_alignment = "left",
		size = {
			500,
			40
		},
		position = {
			28,
			40,
			3
		}
	},
	team_1_score = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			200,
			120
		},
		position = {
			-320,
			-60,
			3
		}
	},
	team_1_player_panel_1 = {
		vertical_alignment = "top",
		parent = "team_1",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			0,
			0,
			10
		}
	},
	team_1_player_panel_2 = {
		vertical_alignment = "top",
		parent = "team_1",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			0,
			-170,
			10
		}
	},
	team_1_player_panel_3 = {
		vertical_alignment = "top",
		parent = "team_1",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			0,
			-340,
			10
		}
	},
	team_1_player_panel_4 = {
		vertical_alignment = "top",
		parent = "team_1",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			0,
			-510,
			10
		}
	},
	team_1_player_frame_1 = {
		vertical_alignment = "bottom",
		parent = "team_1_player_panel_1",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			128,
			69,
			3
		}
	},
	team_1_player_frame_2 = {
		vertical_alignment = "bottom",
		parent = "team_1_player_panel_2",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			128,
			69,
			3
		}
	},
	team_1_player_frame_3 = {
		vertical_alignment = "bottom",
		parent = "team_1_player_panel_3",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			128,
			69,
			3
		}
	},
	team_1_player_frame_4 = {
		vertical_alignment = "bottom",
		parent = "team_1_player_panel_4",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			128,
			69,
			3
		}
	},
	team_1_player_insignia_1 = {
		vertical_alignment = "bottom",
		parent = "team_1_player_panel_1",
		horizontal_alignment = "left",
		position = {
			-275,
			0,
			3
		}
	},
	team_1_player_insignia_2 = {
		vertical_alignment = "bottom",
		parent = "team_1_player_panel_2",
		horizontal_alignment = "left",
		position = {
			-275,
			0,
			3
		}
	},
	team_1_player_insignia_3 = {
		vertical_alignment = "bottom",
		parent = "team_1_player_panel_3",
		horizontal_alignment = "left",
		position = {
			-275,
			0,
			3
		}
	},
	team_1_player_insignia_4 = {
		vertical_alignment = "bottom",
		parent = "team_1_player_panel_4",
		horizontal_alignment = "left",
		position = {
			-275,
			0,
			3
		}
	},
	team_1_player_ready_1 = {
		vertical_alignment = "center",
		parent = "team_1_player_panel_1",
		horizontal_alignment = "left",
		size = {
			50,
			55
		},
		position = {
			-80,
			0,
			1
		}
	},
	team_1_player_ready_2 = {
		vertical_alignment = "center",
		parent = "team_1_player_panel_2",
		horizontal_alignment = "left",
		size = {
			50,
			55
		},
		position = {
			-80,
			0,
			1
		}
	},
	team_1_player_ready_3 = {
		vertical_alignment = "center",
		parent = "team_1_player_panel_3",
		horizontal_alignment = "left",
		size = {
			50,
			55
		},
		position = {
			-80,
			0,
			1
		}
	},
	team_1_player_ready_4 = {
		vertical_alignment = "center",
		parent = "team_1_player_panel_4",
		horizontal_alignment = "left",
		size = {
			50,
			55
		},
		position = {
			-80,
			0,
			1
		}
	},
	team_2 = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-20,
			210,
			10
		}
	},
	team_2_icon = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			232,
			196
		},
		position = {
			320,
			0,
			20
		}
	},
	team_2_name = {
		vertical_alignment = "top",
		parent = "team_2",
		horizontal_alignment = "right",
		size = {
			500,
			50
		},
		position = {
			-28,
			105,
			3
		}
	},
	team_2_text = {
		vertical_alignment = "top",
		parent = "team_2",
		horizontal_alignment = "right",
		size = {
			500,
			40
		},
		position = {
			-28,
			160,
			3
		}
	},
	team_2_side_text = {
		vertical_alignment = "top",
		parent = "team_2",
		horizontal_alignment = "right",
		size = {
			500,
			40
		},
		position = {
			-28,
			40,
			3
		}
	},
	team_2_score = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			200,
			120
		},
		position = {
			320,
			-60,
			3
		}
	},
	team_2_player_panel_1 = {
		vertical_alignment = "top",
		parent = "team_2",
		horizontal_alignment = "right",
		size = var_0_2,
		position = {
			0,
			0,
			10
		}
	},
	team_2_player_panel_2 = {
		vertical_alignment = "top",
		parent = "team_2",
		horizontal_alignment = "right",
		size = var_0_2,
		position = {
			0,
			-170,
			10
		}
	},
	team_2_player_panel_3 = {
		vertical_alignment = "top",
		parent = "team_2",
		horizontal_alignment = "right",
		size = var_0_2,
		position = {
			0,
			-340,
			10
		}
	},
	team_2_player_panel_4 = {
		vertical_alignment = "top",
		parent = "team_2",
		horizontal_alignment = "right",
		size = var_0_2,
		position = {
			0,
			-510,
			10
		}
	},
	team_2_player_frame_1 = {
		vertical_alignment = "bottom",
		parent = "team_2_player_panel_1",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			128,
			69,
			3
		}
	},
	team_2_player_frame_2 = {
		vertical_alignment = "bottom",
		parent = "team_2_player_panel_2",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			128,
			69,
			3
		}
	},
	team_2_player_frame_3 = {
		vertical_alignment = "bottom",
		parent = "team_2_player_panel_3",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			128,
			69,
			3
		}
	},
	team_2_player_frame_4 = {
		vertical_alignment = "bottom",
		parent = "team_2_player_panel_4",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			128,
			69,
			3
		}
	},
	team_2_player_insignia_1 = {
		vertical_alignment = "bottom",
		parent = "team_2_player_panel_1",
		horizontal_alignment = "left",
		position = {
			-275,
			0,
			3
		}
	},
	team_2_player_insignia_2 = {
		vertical_alignment = "bottom",
		parent = "team_2_player_panel_2",
		horizontal_alignment = "left",
		position = {
			-275,
			0,
			3
		}
	},
	team_2_player_insignia_3 = {
		vertical_alignment = "bottom",
		parent = "team_2_player_panel_3",
		horizontal_alignment = "left",
		position = {
			-275,
			0,
			3
		}
	},
	team_2_player_insignia_4 = {
		vertical_alignment = "bottom",
		parent = "team_2_player_panel_4",
		horizontal_alignment = "left",
		position = {
			-275,
			0,
			3
		}
	},
	team_2_player_ready_1 = {
		vertical_alignment = "center",
		parent = "team_2_player_panel_1",
		horizontal_alignment = "right",
		size = {
			50,
			55
		},
		position = {
			80,
			0,
			1
		}
	},
	team_2_player_ready_2 = {
		vertical_alignment = "center",
		parent = "team_2_player_panel_2",
		horizontal_alignment = "right",
		size = {
			50,
			55
		},
		position = {
			80,
			0,
			1
		}
	},
	team_2_player_ready_3 = {
		vertical_alignment = "center",
		parent = "team_2_player_panel_3",
		horizontal_alignment = "right",
		size = {
			50,
			55
		},
		position = {
			80,
			0,
			1
		}
	},
	team_2_player_ready_4 = {
		vertical_alignment = "center",
		parent = "team_2_player_panel_4",
		horizontal_alignment = "right",
		size = {
			50,
			55
		},
		position = {
			80,
			0,
			1
		}
	},
	settings_container = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			480,
			560
		},
		position = {
			0,
			-140,
			10
		}
	},
	settings_anchor = {
		vertical_alignment = "top",
		parent = "settings_container",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-10,
			100
		}
	},
	custom_ruleset_text = {
		vertical_alignment = "top",
		parent = "settings_container",
		horizontal_alignment = "center",
		size = {
			480,
			30
		},
		position = {
			0,
			40,
			1
		}
	}
}
local var_0_4 = {
	word_wrap = false,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 50,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_5 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 36,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_6 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	font_size = 98,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("local_player_team_lighter", 255),
	offset = {
		0,
		0,
		0
	}
}
local var_0_7 = table.clone(var_0_6)

var_0_7.horizontal_alignment = "right"
var_0_7.text_color = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)

local var_0_8 = {
	font_size = 24,
	upper_case = true,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_table("white"),
	offset = {
		0,
		0,
		1
	}
}
local var_0_9 = {
	word_wrap = true,
	font_size = 82,
	localize = false,
	vertical_alignment = "center",
	horizontal_alignment = "center",
	use_shadow = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_10 = {
	word_wrap = true,
	font_size = 32,
	localize = false,
	vertical_alignment = "center",
	horizontal_alignment = "left",
	use_shadow = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("local_player_picking", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_11 = table.clone(var_0_10)

var_0_11.horizontal_alignment = "right"
var_0_11.text_color = Colors.get_color_table_with_alpha("opponent_team", 255)

local var_0_12 = {
	word_wrap = false,
	upper_case = true,
	localize = false,
	font_size = 38,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_13 = table.clone(var_0_12)

var_0_13.horizontal_alignment = "right"

local function var_0_14(arg_1_0)
	local var_1_0 = "shadow_frame_02"
	local var_1_1 = UIFrameSettings[var_1_0]
	local var_1_2 = "frame_outer_glow_04"
	local var_1_3 = UIFrameSettings[var_1_2]
	local var_1_4 = "frame_outer_glow_01"
	local var_1_5 = UIFrameSettings[var_1_4]
	local var_1_6 = "frame_bevel_01"
	local var_1_7 = UIFrameSettings[var_1_6]

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "texture_frame",
					style_id = "shadow_frame",
					texture_id = "shadow_frame",
					content_check_function = function(arg_2_0)
						return arg_2_0.empty
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "hover_frame",
					texture_id = "hover_frame",
					content_check_function = function(arg_3_0)
						return not arg_3_0.empty and arg_3_0.hotspot.is_hover
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "empty_hover",
					texture_id = "empty_hover",
					content_check_function = function(arg_4_0)
						return arg_4_0.empty and arg_4_0.hotspot.is_hover
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "empty_frame",
					texture_id = "empty_frame",
					content_check_function = function(arg_5_0)
						return arg_5_0.empty
					end
				}
			}
		},
		content = {
			empty = false,
			hotspot = {
				allow_multi_hover = true
			},
			shadow_frame = var_1_1.texture,
			hover_frame = var_1_3.texture,
			empty_hover = var_1_5.texture,
			empty_frame = var_1_7.texture
		},
		style = {
			empty_frame = {
				texture_size = var_1_7.texture_size,
				texture_sizes = var_1_7.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					2
				}
			},
			shadow_frame = {
				frame_margins = {
					-14,
					-14
				},
				texture_size = var_1_1.texture_size,
				texture_sizes = var_1_1.texture_sizes,
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
			hover_frame = {
				frame_margins = {
					-14,
					-14
				},
				texture_size = var_1_3.texture_size,
				texture_sizes = var_1_3.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					2
				}
			},
			empty_hover = {
				frame_margins = {
					-14,
					-14
				},
				texture_size = var_1_5.texture_size,
				texture_sizes = var_1_5.texture_sizes,
				color = {
					255,
					151,
					151,
					151
				},
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

local function var_0_15(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	local var_6_0 = arg_6_1.values or {}
	local var_6_1 = #var_6_0 or 0
	local var_6_2 = "menu_settings_" .. arg_6_1.setting_name
	local var_6_3 = "tooltip_" .. arg_6_1.setting_name

	local function var_6_4(arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = arg_7_0.parent
		local var_7_1 = arg_7_0.hover_progress or 0
		local var_7_2 = 15

		if arg_7_0.is_hover then
			var_7_1 = math.min(var_7_1 + arg_7_2 * var_7_2, 1)
		else
			var_7_1 = math.max(var_7_1 - arg_7_2 * var_7_2, 0)
		end

		arg_7_0.hover_progress = var_7_1

		local var_7_3 = arg_7_0.press_progress or 1
		local var_7_4 = 25

		if arg_7_0.is_held then
			var_7_3 = math.max(var_7_3 - arg_7_2 * var_7_4, 0.5)
		else
			var_7_3 = math.min(var_7_3 + arg_7_2 * var_7_4, 1)
		end

		arg_7_0.press_progress = var_7_3
	end

	local function var_6_5(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		local var_8_0 = arg_8_2.hover_progress or 0
		local var_8_1 = arg_8_2.press_progress or 1

		arg_8_1.color[1] = 255 * var_8_0

		if arg_8_2.is_hover then
			arg_8_1.color[1] = 255 * var_8_1
		end
	end

	return {
		element = {
			passes = {
				{
					style_id = "setting_name",
					pass_type = "text",
					text_id = "setting_name"
				},
				{
					pass_type = "texture",
					style_id = "setting_value_bg",
					texture_id = "setting_value_bg"
				},
				{
					style_id = "setting_value",
					pass_type = "text",
					text_id = "setting_value",
					content_change_function = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
						local var_9_0 = arg_9_0.data.values
						local var_9_1 = arg_9_0.ui_data
						local var_9_2 = var_9_0[arg_9_0.setting_idx]

						if arg_9_0.value ~= var_9_2 then
							arg_9_0.value = var_9_2

							local var_9_3 = var_9_1 and var_9_1.localization_options
							local var_9_4 = ""

							if var_9_3 and var_9_3[var_9_2] then
								local var_9_5 = var_9_3[var_9_2]

								var_9_4 = Localize(var_9_5)
							elseif type(arg_9_0.value) == "number" and var_9_1 and var_9_1.setting_type == "multiplier" then
								var_9_4 = string.format("%.2f", arg_9_0.value)
							else
								var_9_4 = string.format("%s", arg_9_0.value)
							end

							if (not var_9_3 or not var_9_3[var_9_2]) and var_9_1 and var_9_1.setting_type then
								local var_9_6 = DLCSettings.carousel and DLCSettings.carousel.custom_game_settigns_values_suffix

								if var_9_1 and var_9_6 and var_9_6[var_9_1.setting_type] then
									var_9_4 = var_9_4 .. var_9_6[var_9_1.setting_type]
								end
							end

							arg_9_0.setting_value = var_9_4
						end

						if arg_9_0.value ~= arg_9_0.default_value then
							arg_9_1.text_color = arg_9_1.modified_color
						else
							arg_9_1.text_color = arg_9_1.default_color
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "divider",
					texture_id = "divider"
				},
				{
					style_id = "setting_highlight_hotspot",
					pass_type = "hotspot",
					content_id = "setting_highlight_hotspot",
					content_change_function = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
						local var_10_0 = arg_10_0.hover_progress or 0
						local var_10_1 = 15

						if arg_10_0.is_hover or arg_10_0.parent.is_gamepad_active and arg_10_0.parent.focused and arg_10_0.parent.is_selected then
							var_10_0 = math.min(var_10_0 + arg_10_3 * var_10_1, 1)
						else
							var_10_0 = math.max(var_10_0 - arg_10_3 * var_10_1, 0)
						end

						arg_10_0.hover_progress = var_10_0
					end
				},
				{
					style_id = "setting_highlight",
					texture_id = "setting_highlight",
					pass_type = "texture",
					content_change_function = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
						local var_11_0 = arg_11_0.setting_highlight_hotspot.hover_progress or 0

						arg_11_1.color[1] = 255 * var_11_0
					end
				},
				{
					style_id = "tooltip_text",
					pass_type = "option_tooltip",
					text_id = "tooltip_text",
					content_check_function = function(arg_12_0, arg_12_1)
						return arg_12_0.setting_highlight_hotspot.is_hover
					end
				}
			}
		},
		content = {
			default_idx = 1,
			setting_highlight = "party_selection_glow",
			default_value = 0,
			setting_value_bg = "rect_masked",
			divider = "rect_masked",
			data = arg_6_1,
			ui_data = arg_6_2,
			id = arg_6_5,
			name = arg_6_1.setting_name,
			on_setting_changed_cb = arg_6_6,
			settings = var_6_0,
			num_settings = var_6_1,
			setting_idx = arg_6_4,
			setting_value = tostring(arg_6_3),
			setting_name = var_6_2,
			setting_highlight_hotspot = {
				allow_multi_hover = true
			},
			tooltip_text = var_6_3
		},
		style = {
			setting_name = {
				upper_case = false,
				localize = true,
				vertical_alignment = "center",
				font_size = 20,
				horizontal_alignment = "left",
				use_shadow = true,
				masked = true,
				font_type = "hell_shark_masked",
				size = {
					380,
					30
				},
				area_size = {
					380,
					30
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					3
				}
			},
			setting_value_bg = {
				masked = true,
				size = {
					128,
					30
				},
				offset = {
					320,
					0,
					4
				},
				color = Colors.get_color_table_with_alpha("black", 120)
			},
			setting_value = {
				masked = true,
				upper_case = false,
				localize = false,
				font_type = "hell_shark_masked",
				font_size = 22,
				vertical_alignment = "center",
				horizontal_alignment = "center",
				use_shadow = true,
				dynamic_font_size = true,
				size = {
					128,
					30
				},
				area_size = {
					128,
					30
				},
				modified_color = Colors.get_color_table_with_alpha("pale_golden_rod", 255),
				default_color = Colors.get_color_table_with_alpha("font_default", 180),
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					320,
					0,
					5
				}
			},
			divider = {
				masked = true,
				size = {
					440,
					2
				},
				offset = {
					0,
					-2,
					1
				},
				color = Colors.get_color_table_with_alpha("gray", 100)
			},
			setting_highlight_hotspot = {
				size = {
					440,
					34
				},
				offset = {
					0,
					0,
					1
				}
			},
			setting_highlight = {
				masked = true,
				texture_size = {
					440,
					34
				},
				offset = {
					0,
					0,
					1
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			tooltip_text = {
				font_type = "hell_shark_masked",
				upper_case = false,
				localize = true,
				use_shadow = true,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				size = {
					180,
					30
				},
				area_size = {
					180,
					30
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			}
		},
		offset = {
			0,
			0,
			1
		},
		scenegraph_id = arg_6_0
	}
end

local var_0_16 = {
	level_name = UIWidgets.create_simple_text("level_name", "level_name", nil, nil, var_0_4),
	sub_title = UIWidgets.create_simple_text("sub_title", "sub_title", nil, nil, var_0_5),
	background = UIWidgets.create_simple_rect("screen", {
		176,
		0,
		0,
		0
	}),
	title_divider = UIWidgets.create_simple_texture("divider_01_top", "title_divider"),
	objective_text = UIWidgets.create_mission_objective_text_widget_still("objective"),
	score = UIWidgets.create_objective_score_widget("score", var_0_3.score.size),
	team_1_name = UIWidgets.create_simple_text("", "team_1_name", nil, nil, var_0_6),
	team_1_icon = UIWidgets.create_simple_texture("banner_hammers_local", "team_1_icon"),
	team_1_text = UIWidgets.create_simple_text(Localize("vs_lobby_your_team"), "team_1_text", nil, nil, var_0_10),
	team_1_side_text = UIWidgets.create_simple_text("", "team_1_side_text", nil, nil, var_0_12),
	team_2_name = UIWidgets.create_simple_text("", "team_2_name", nil, nil, var_0_7),
	team_2_icon = UIWidgets.create_simple_texture("banner_skulls_opponent", "team_2_icon"),
	team_2_text = UIWidgets.create_simple_text(Localize("vs_lobby_enemy_team"), "team_2_text", nil, nil, var_0_11),
	team_2_side_text = UIWidgets.create_simple_text("", "team_2_side_text", nil, nil, var_0_13),
	input_description_text = UIWidgets.create_simple_text("player_list_show_mouse_description", "player_list_input_description", nil, nil, var_0_8)
}
local var_0_17 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = false,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_18 = {
	settings_background = UIWidgets.create_rect_with_outer_frame("settings_container", var_0_3.settings_container.size, "frame_outer_fade_02", nil, UISettings.console_start_game_menu_rect_color, Colors.get_color_table_with_alpha("font_default", 125)),
	settings_mask = UIWidgets.create_simple_texture("mask_rect", "settings_container"),
	custom_ruleset_text = UIWidgets.create_simple_text(Localize("versus_custom_game_custom_ruleset"), "custom_ruleset_text", nil, nil, var_0_17)
}
local var_0_19 = {
	on_enter = {
		{
			name = "entry",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				arg_13_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				local var_14_0 = math.easeCubic(arg_14_3)

				arg_14_4.render_settings.alpha_multiplier = var_14_0
				arg_14_0.team_1.position[1] = arg_14_1.team_1.position[1] - (1 - var_14_0) * 100
				arg_14_0.team_2.position[1] = arg_14_1.team_2.position[1] + (1 - var_14_0) * 100
			end,
			on_complete = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				return
			end
		}
	}
}

return {
	create_empty_frame_widget = var_0_14,
	animation_definitions = var_0_19,
	scenegraph_definition = var_0_3,
	widget_definitions = var_0_16,
	custom_game_settings_widgets = var_0_18,
	create_settings_widget = var_0_15,
	console_cursor_definition = UIWidgets.create_console_cursor("console_cursor"),
	item_tooltip = UIWidgets.create_simple_item_presentation("item_tooltip", UISettings.console_tooltip_pass_definitions)
}
