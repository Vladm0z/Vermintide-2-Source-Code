-- chunkname: @scripts/ui/views/character_selection_view/states/definitions/character_selection_state_character_definitions.lua

local var_0_0 = 426
local var_0_1 = 240
local var_0_2 = {
	450,
	170
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
			UILayer.default
		}
	},
	right_side_root = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			1080
		},
		position = {
			0,
			0,
			1
		}
	},
	left_side_root = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			1080
		},
		position = {
			0,
			0,
			1
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
	hero_info_panel = {
		vertical_alignment = "top",
		parent = "left_side_root",
		horizontal_alignment = "left",
		size = {
			441,
			118
		},
		position = {
			112,
			-62,
			1
		}
	},
	hero_info_level_bg = {
		vertical_alignment = "center",
		parent = "hero_info_panel",
		horizontal_alignment = "left",
		size = {
			124,
			138
		},
		position = {
			-62,
			0,
			2
		}
	},
	hero_info_divider = {
		vertical_alignment = "top",
		parent = "hero_info_level_bg",
		horizontal_alignment = "center",
		size = {
			14,
			790
		},
		position = {
			0,
			-126,
			-1
		}
	},
	hero_info_divider_edge = {
		vertical_alignment = "bottom",
		parent = "hero_info_divider",
		horizontal_alignment = "center",
		size = {
			28,
			22
		},
		position = {
			0,
			-22,
			1
		}
	},
	info_career_name = {
		vertical_alignment = "top",
		parent = "hero_info_panel",
		horizontal_alignment = "center",
		size = {
			450,
			25
		},
		position = {
			76,
			-16,
			1
		}
	},
	info_hero_name = {
		vertical_alignment = "top",
		parent = "info_career_name",
		horizontal_alignment = "center",
		size = {
			450,
			25
		},
		position = {
			0,
			-40,
			1
		}
	},
	info_hero_level = {
		vertical_alignment = "center",
		parent = "hero_info_level_bg",
		horizontal_alignment = "center",
		size = {
			450,
			25
		},
		position = {
			0,
			0,
			1
		}
	},
	locked_info_text = {
		vertical_alignment = "top",
		parent = "hero_root",
		horizontal_alignment = "left",
		size = {
			641,
			50
		},
		position = {
			0,
			60,
			1
		}
	},
	hero_root = {
		vertical_alignment = "center",
		parent = "hero_info_level_bg",
		horizontal_alignment = "center",
		size = {
			110,
			130
		},
		position = {
			80,
			-200,
			100
		}
	},
	hero_icon_root = {
		vertical_alignment = "center",
		parent = "hero_root",
		horizontal_alignment = "left",
		size = {
			48,
			144
		},
		position = {
			-59,
			0,
			100
		}
	},
	info_window = {
		vertical_alignment = "top",
		parent = "right_side_root",
		horizontal_alignment = "right",
		size = {
			var_0_2[1] + 20,
			885
		},
		position = {
			-50,
			-75,
			1
		}
	},
	info_window_video = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			var_0_0,
			var_0_1
		},
		position = {
			0,
			-10,
			1
		}
	},
	info_video_edge_left = {
		vertical_alignment = "top",
		parent = "info_window_video",
		horizontal_alignment = "right",
		size = {
			230,
			59
		},
		position = {
			-213,
			12,
			13
		}
	},
	info_video_edge_right = {
		vertical_alignment = "top",
		parent = "info_window_video",
		horizontal_alignment = "left",
		size = {
			230,
			59
		},
		position = {
			213,
			12,
			13
		}
	},
	scrollbar_anchor = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] + 20,
			625
		},
		position = {
			0,
			-260,
			1
		}
	},
	scrollbar_window = {
		parent = "scrollbar_anchor"
	},
	passive_window = {
		vertical_alignment = "top",
		parent = "scrollbar_window",
		horizontal_alignment = "center",
		size = var_0_2,
		position = {
			0,
			0,
			1
		}
	},
	passive_icon = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "left",
		size = {
			80,
			80
		},
		position = {
			10,
			-50,
			5
		}
	},
	passive_icon_frame = {
		vertical_alignment = "center",
		parent = "passive_icon",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	passive_title_text = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "left",
		size = {
			var_0_2[1] * 0.65,
			50
		},
		position = {
			10,
			-5,
			1
		}
	},
	passive_title_divider = {
		vertical_alignment = "bottom",
		parent = "passive_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	passive_type_title = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "right",
		size = {
			var_0_2[1] * 0.3,
			50
		},
		position = {
			-10,
			-5,
			1
		}
	},
	passive_description_text = {
		vertical_alignment = "top",
		parent = "passive_icon",
		horizontal_alignment = "left",
		size = {
			var_0_2[1] - 110,
			var_0_2[2] - 90
		},
		position = {
			90,
			0,
			1
		}
	},
	active_window = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "left",
		size = var_0_2,
		position = {
			0,
			-var_0_2[2],
			1
		}
	},
	active_icon = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "left",
		size = {
			80,
			80
		},
		position = {
			10,
			-50,
			5
		}
	},
	active_icon_frame = {
		vertical_alignment = "center",
		parent = "active_icon",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	active_title_text = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "left",
		size = {
			var_0_2[1] * 0.6,
			50
		},
		position = {
			10,
			-5,
			1
		}
	},
	active_title_divider = {
		vertical_alignment = "bottom",
		parent = "active_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	active_type_title = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "right",
		size = {
			var_0_2[1] * 0.3,
			50
		},
		position = {
			-10,
			-5,
			1
		}
	},
	active_description_text = {
		vertical_alignment = "top",
		parent = "active_icon",
		horizontal_alignment = "left",
		size = {
			var_0_2[1] - 110,
			var_0_2[2] - 90
		},
		position = {
			90,
			0,
			1
		}
	},
	perk_title_text = {
		vertical_alignment = "bottom",
		parent = "active_window",
		horizontal_alignment = "left",
		size = {
			var_0_2[1] * 0.6,
			50
		},
		position = {
			10,
			-50,
			1
		}
	},
	perk_title_divider = {
		vertical_alignment = "bottom",
		parent = "perk_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	career_perk_1 = {
		vertical_alignment = "bottom",
		parent = "perk_title_divider",
		horizontal_alignment = "left",
		size = {
			410,
			1
		},
		position = {
			10,
			-30,
			1
		}
	},
	career_perk_2 = {
		vertical_alignment = "center",
		parent = "career_perk_1",
		horizontal_alignment = "left",
		size = {
			410,
			1
		},
		position = {
			0,
			0,
			1
		}
	},
	career_perk_3 = {
		vertical_alignment = "center",
		parent = "career_perk_2",
		horizontal_alignment = "left",
		size = {
			410,
			1
		},
		position = {
			0,
			0,
			1
		}
	},
	select_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			370,
			70
		},
		position = {
			0,
			25,
			3
		}
	},
	bot_priority_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			370,
			70
		},
		position = {
			135,
			25,
			103
		}
	},
	back_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			200,
			70
		},
		position = {
			135,
			25,
			103
		}
	}
}
local var_0_4 = {
	word_wrap = true,
	use_shadow = true,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 18,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_5 = {
	word_wrap = true,
	use_shadow = true,
	localize = false,
	font_size = 18,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("gray", 200),
	offset = {
		0,
		0,
		2
	}
}
local var_0_6 = {
	font_size = 32,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header_masked",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_7 = {
	font_size = 40,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_8 = {
	word_wrap = true,
	font_size = 30,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_9 = {
	word_wrap = true,
	font_size = 52,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_10 = {
	word_wrap = false,
	upper_case = true,
	localize = true,
	use_shadow = true,
	font_size = 65,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		100,
		20
	}
}
local var_0_11 = {
	110,
	130
}
local var_0_12 = {
	scenegraph_id = "hero_root",
	offset = {
		0,
		0,
		0
	},
	element = {
		passes = {
			{
				pass_type = "hover"
			},
			{
				pass_type = "texture",
				style_id = "bg",
				texture_id = "bg"
			},
			{
				style_id = "icon",
				texture_id = "icon",
				pass_type = "texture",
				content_change_function = function(arg_1_0, arg_1_1)
					local var_1_0 = arg_1_0.is_hover and 255 or 184

					arg_1_1.color[1] = math.ceil(arg_1_1.color[1] + 0.1 * (var_1_0 - arg_1_1.color[1]))
				end
			}
		}
	},
	content = {
		icon = "icon_hourglass",
		bg = "character_slot_empty"
	},
	style = {
		bg = {
			texture_size = var_0_11,
			offset = {
				0,
				0,
				0
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = UIAtlasHelper.get_atlas_settings_by_texture_name("icon_hourglass").size,
			color = {
				184,
				255,
				255,
				255
			}
		}
	}
}

local function var_0_13(arg_2_0, arg_2_1)
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_change_function = function(arg_3_0, arg_3_1)
						arg_3_1.text_color = arg_3_0.locked and arg_3_1.locked_text_color or arg_3_1.default_text_color
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_4_0)
						return arg_4_0.use_shadow
					end
				}
			}
		},
		content = {
			use_shadow = true,
			disable_with_gamepad = true,
			text = arg_2_0,
			original_text = arg_2_0
		},
		style = {
			text = {
				word_wrap = true,
				font_size = 26,
				localize = false,
				use_shadow = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("red", 255),
				default_text_color = Colors.get_color_table_with_alpha("light_blue", 255),
				locked_text_color = Colors.get_color_table_with_alpha("red", 255),
				offset = {
					0,
					0,
					2
				}
			},
			text_shadow = {
				word_wrap = true,
				font_size = 26,
				localize = false,
				font_type = "hell_shark",
				horizontal_alignment = "left",
				vertical_alignment = "top",
				skip_button_rendering = true,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					2,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_2_1
	}
end

local var_0_14 = true
local var_0_15 = {
	background = UIWidgets.create_simple_rect("screen", {
		0,
		0,
		0,
		0
	}, 100),
	bottom_panel = UIWidgets.create_simple_uv_texture("menu_panel_bg", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_panel", nil, nil, UISettings.console_menu_rect_color),
	info_window_background = UIWidgets.create_rect_with_outer_frame("info_window", var_0_3.info_window.size, "frame_outer_fade_02", 0, UISettings.console_menu_rect_color),
	mask = UIWidgets.create_simple_texture("mask_rect", "scrollbar_anchor"),
	info_window_video = UIWidgets.create_frame("info_window_video", var_0_3.info_window_video.size, "menu_frame_06"),
	info_video_edge_left = UIWidgets.create_simple_texture("frame_detail_03", "info_video_edge_left"),
	info_video_edge_right = UIWidgets.create_simple_uv_texture("frame_detail_03", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "info_video_edge_right"),
	perk_title_text = UIWidgets.create_simple_text(Localize("hero_view_perk_title"), "perk_title_text", nil, nil, var_0_6),
	perk_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "perk_title_divider", true),
	career_perk_1 = UIWidgets.create_career_perk_text("career_perk_1"),
	career_perk_2 = UIWidgets.create_career_perk_text("career_perk_2"),
	career_perk_3 = UIWidgets.create_career_perk_text("career_perk_3"),
	passive_title_text = UIWidgets.create_simple_text("n/a", "passive_title_text", nil, nil, var_0_6),
	passive_type_title = UIWidgets.create_simple_text(Localize("hero_view_passive_ability"), "passive_type_title", nil, nil, var_0_5),
	passive_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "passive_title_divider", true),
	passive_description_text = UIWidgets.create_simple_text("n/a", "passive_description_text", nil, nil, var_0_4),
	passive_icon = UIWidgets.create_simple_texture("icons_placeholder", "passive_icon", true),
	passive_icon_frame = UIWidgets.create_simple_texture("talent_frame", "passive_icon_frame", true),
	active_title_text = UIWidgets.create_simple_text("n/a", "active_title_text", nil, nil, var_0_6),
	active_type_title = UIWidgets.create_simple_text(Localize("hero_view_activated_ability"), "active_type_title", nil, nil, var_0_5),
	active_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "active_title_divider", true),
	active_description_text = UIWidgets.create_simple_text("n/a", "active_description_text", nil, nil, var_0_4),
	active_icon = UIWidgets.create_simple_texture("icons_placeholder", "active_icon", true),
	active_icon_frame = UIWidgets.create_simple_texture("talent_frame", "active_icon_frame", true)
}
local var_0_16 = {
	locked_info_text = var_0_13(Localize("career_locked_info"), "locked_info_text"),
	hero_info_panel = UIWidgets.create_simple_texture("item_slot_side_fade", "hero_info_panel", nil, nil, {
		255,
		0,
		0,
		0
	}),
	hero_info_panel_glow = UIWidgets.create_simple_texture("item_slot_side_effect", "hero_info_panel", nil, nil, Colors.get_color_table_with_alpha("font_title", 255), 1),
	hero_info_level_bg = UIWidgets.create_simple_texture("hero_level_bg", "hero_info_level_bg"),
	hero_info_divider = UIWidgets.create_simple_texture("divider_vertical_hero_middle", "hero_info_divider"),
	hero_info_divider_edge = UIWidgets.create_simple_texture("divider_vertical_hero_end", "hero_info_divider_edge"),
	info_career_name = UIWidgets.create_simple_text("n/a", "info_career_name", nil, nil, var_0_7),
	info_hero_name = UIWidgets.create_simple_text("n/a", "info_hero_name", nil, nil, var_0_8),
	info_hero_level = UIWidgets.create_simple_text("n/a", "info_hero_level", nil, nil, var_0_9),
	select_button = UIWidgets.create_default_button("select_button", var_0_3.select_button.size, nil, nil, Localize("input_description_confirm"), nil, nil, nil, nil, var_0_14),
	bot_priority_button = UIWidgets.create_default_button("bot_priority_button", var_0_3.bot_priority_button.size, nil, nil, Localize("input_description_prio_bot"), nil, nil, nil, nil, var_0_14)
}
local var_0_17 = {
	bot_header_text = UIWidgets.create_simple_text("input_description_prio_bot", "locked_info_text", nil, nil, var_0_10),
	bot_info_text = var_0_13(Localize("assign_career_tooltip"), "locked_info_text"),
	back_button = UIWidgets.create_default_button("back_button", var_0_3.back_button.size, nil, nil, Localize("back_menu_button_name"), nil, nil, nil, nil, var_0_14)
}
local var_0_18 = {
	default = {
		{
			input_action = "refresh",
			priority = 1,
			description_text = "input_description_prio_bot"
		}
	},
	default_back = {
		{
			input_action = "refresh",
			priority = 1,
			description_text = "input_description_prio_bot"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	},
	available = {
		actions = {
			{
				input_action = "confirm",
				priority = 2,
				description_text = "input_description_select"
			}
		}
	},
	purchase = {
		actions = {
			{
				input_action = "confirm",
				priority = 2,
				description_text = "buy_now"
			}
		}
	},
	prioritize_bots = {
		{
			input_action = "refresh",
			priority = 1,
			description_text = "input_description_change_bot_prio"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_back"
		}
	},
	bot_selection_available = {
		actions = {
			{
				input_action = "confirm",
				priority = 2,
				description_text = "input_description_assign_bot"
			}
		}
	}
}
local var_0_19 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				arg_5_3.render_settings.main_alpha_multiplier = 0
				arg_5_3.render_settings.info_alpha_multiplier = 0
				arg_5_3.render_settings.bot_selection_window_multiplier = 0
			end,
			update = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.main_alpha_multiplier = var_6_0
				arg_6_4.render_settings.info_alpha_multiplier = var_6_0
				arg_6_4.render_settings.bot_selection_alpha_multiplier = 0
				arg_6_0.left_side_root.local_position[1] = arg_6_1.left_side_root.position[1] + -100 * (1 - var_6_0)
				arg_6_0.right_side_root.local_position[1] = arg_6_1.right_side_root.position[1] + 100 * (1 - var_6_0)
			end,
			on_complete = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 1,
			init = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				arg_8_3.render_settings.main_alpha_multiplier = 1
				arg_8_3.render_settings.info_alpha_multiplier = 1
				arg_8_3.render_settings.bot_selection_alpha_multiplier = 0
			end,
			update = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				local var_9_0 = math.easeOutCubic(arg_9_3)

				arg_9_4.render_settings.main_alpha_multiplier = 1 - var_9_0
				arg_9_4.render_settings.info_alpha_multiplier = 1 - var_9_0
				arg_9_4.render_settings.bot_selection_alpha_multiplier = 0
				arg_9_0.left_side_root.local_position[1] = arg_9_1.left_side_root.position[1] + -100 * var_9_0
				arg_9_0.right_side_root.local_position[1] = arg_9_1.right_side_root.position[1] + 100 * var_9_0
			end,
			on_complete = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end
		}
	},
	on_enter_bot_selection = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				arg_11_3.render_settings.info_alpha_multiplier = 0
				arg_11_3.render_settings.bot_selection_alpha_multiplier = 0
			end,
			update = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				local var_12_0 = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.bot_selection_alpha_multiplier = var_12_0
				arg_12_4.render_settings.info_alpha_multiplier = 0
				arg_12_0.left_side_root.local_position[1] = arg_12_1.left_side_root.position[1] + -100 * (1 - var_12_0)
			end,
			on_complete = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		}
	},
	on_exit_bot_selection = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				arg_14_3.render_settings.info_alpha_multiplier = 0
				arg_14_3.render_settings.bot_selection_alpha_multiplier = 0
			end,
			update = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				local var_15_0 = math.easeOutCubic(arg_15_3)

				arg_15_4.render_settings.info_alpha_multiplier = var_15_0
				arg_15_4.render_settings.bot_selection_alpha_multiplier = 0
				arg_15_0.left_side_root.local_position[1] = arg_15_1.left_side_root.position[1] + -100 * (1 - var_15_0)
			end,
			on_complete = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_15,
	info_widgets = var_0_16,
	bot_selection_widgets = var_0_17,
	hero_widget = UIWidgets.create_hero_widget("hero_root", var_0_3.hero_root.size),
	empty_hero_widget = var_0_12,
	hero_icon_widget = UIWidgets.create_hero_icon_widget("hero_icon_root", var_0_3.hero_icon_root.size),
	character_selection_widgets = var_0_15,
	generic_input_actions = var_0_18,
	scenegraph_definition = var_0_3,
	animation_definitions = var_0_19
}
