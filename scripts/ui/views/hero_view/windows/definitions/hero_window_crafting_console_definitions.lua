-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_crafting_console_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = var_0_0.spacing
local var_0_5 = UIFrameSettings[var_0_2].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[var_0_2].texture_sizes.horizontal[2]
local var_0_7 = var_0_3[1] - (var_0_5 * 2 + 60)
local var_0_8 = UISettings.console_menu_scenegraphs
local var_0_9 = {
	screen = var_0_8.screen,
	craft_bg_root = var_0_8.craft_bg_root,
	area = var_0_8.area,
	area_left = var_0_8.area_left,
	area_right = var_0_8.area_right,
	area_divider = var_0_8.area_divider,
	craft_bar = {
		vertical_alignment = "center",
		parent = "craft_bg_root",
		horizontal_alignment = "center",
		size = {
			376,
			370
		},
		position = {
			0,
			0,
			7
		}
	},
	craft_bar_spark = {
		vertical_alignment = "center",
		parent = "craft_bg_root",
		horizontal_alignment = "center",
		size = {
			80,
			20
		},
		position = {
			-1,
			155,
			8
		}
	},
	item_tooltip = {
		vertical_alignment = "top",
		parent = "area_right",
		horizontal_alignment = "right",
		size = {
			400,
			0
		},
		position = {
			-60,
			-150,
			20
		}
	},
	item_tooltip_result = {
		vertical_alignment = "top",
		parent = "area_right",
		horizontal_alignment = "right",
		size = {
			400,
			0
		},
		position = {
			-60,
			-100,
			20
		}
	},
	craft_bg = {
		vertical_alignment = "center",
		parent = "craft_bg_root",
		horizontal_alignment = "center",
		size = {
			394,
			394
		},
		position = {
			0,
			0,
			1
		}
	},
	crafting_mask = {
		vertical_alignment = "center",
		parent = "craft_bg",
		horizontal_alignment = "center",
		size = {
			394,
			394
		},
		position = {
			0,
			0,
			1
		}
	},
	craft_lock_shadow = {
		vertical_alignment = "center",
		parent = "craft_bg",
		horizontal_alignment = "center",
		size = {
			394,
			394
		},
		position = {
			0,
			0,
			15
		}
	},
	craft_lock_top_left = {
		vertical_alignment = "top",
		parent = "craft_bg",
		horizontal_alignment = "right",
		size = {
			208,
			312
		},
		position = {
			-197,
			0,
			16
		}
	},
	craft_lock_top_right = {
		vertical_alignment = "top",
		parent = "craft_bg",
		horizontal_alignment = "left",
		size = {
			208,
			312
		},
		position = {
			197,
			0,
			16
		}
	},
	craft_lock_top_effect = {
		vertical_alignment = "top",
		parent = "craft_bg",
		horizontal_alignment = "center",
		size = {
			39,
			189
		},
		position = {
			0,
			-100,
			17
		}
	},
	craft_lock_bottom_left = {
		vertical_alignment = "bottom",
		parent = "craft_bg",
		horizontal_alignment = "right",
		size = {
			180,
			208
		},
		position = {
			-197,
			-22,
			16
		}
	},
	craft_lock_bottom_right = {
		vertical_alignment = "bottom",
		parent = "craft_bg",
		horizontal_alignment = "left",
		size = {
			180,
			208
		},
		position = {
			197,
			-22,
			16
		}
	},
	craft_effect_bottom_left = {
		vertical_alignment = "center",
		parent = "craft_bg",
		horizontal_alignment = "center",
		size = {
			39,
			189
		},
		position = {
			-130,
			-80,
			18
		}
	},
	craft_effect_bottom_right = {
		vertical_alignment = "center",
		parent = "craft_bg",
		horizontal_alignment = "center",
		size = {
			39,
			189
		},
		position = {
			130,
			-80,
			18
		}
	},
	craft_lock_eye_left = {
		vertical_alignment = "bottom",
		parent = "craft_lock_top_left",
		horizontal_alignment = "right",
		size = {
			224,
			217
		},
		position = {
			56,
			-20,
			1
		}
	},
	craft_lock_eye_right = {
		vertical_alignment = "bottom",
		parent = "craft_lock_top_right",
		horizontal_alignment = "left",
		size = {
			224,
			217
		},
		position = {
			-56,
			-20,
			1
		}
	},
	crafting_glow = {
		vertical_alignment = "center",
		parent = "craft_bg",
		horizontal_alignment = "center",
		size = {
			800,
			800
		},
		position = {
			0,
			0,
			10
		}
	},
	craft_bg_detail = {
		vertical_alignment = "center",
		parent = "craft_bg",
		horizontal_alignment = "center",
		size = {
			522,
			522
		},
		position = {
			0,
			0,
			20
		}
	},
	craft_icon_connection = {
		vertical_alignment = "bottom",
		parent = "craft_bg",
		horizontal_alignment = "center",
		size = {
			135,
			102
		},
		position = {
			0,
			-68,
			31
		}
	},
	description_bg = {
		vertical_alignment = "top",
		parent = "craft_bg_root",
		horizontal_alignment = "center",
		size = {
			600,
			200
		},
		position = {
			0,
			142,
			30
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "description_bg",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] - 40,
			50
		},
		position = {
			0,
			-10,
			1
		}
	},
	title_text_divider = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-28,
			1
		}
	},
	description_text = {
		vertical_alignment = "top",
		parent = "title_text_divider",
		horizontal_alignment = "center",
		size = {
			500,
			50
		},
		position = {
			0,
			-36,
			2
		}
	},
	item_grid_fg = {
		vertical_alignment = "center",
		parent = "craft_bg_root",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			440
		},
		position = {
			0,
			0,
			20
		}
	}
}
local var_0_10 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_11 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_12 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		-(var_0_3[1] * 0.1 + 5),
		4,
		2
	}
}
local var_0_13 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		var_0_3[1] * 0.1 + 4,
		4,
		2
	}
}
local var_0_14 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		4,
		2
	}
}
local var_0_15 = table.clone(UISettings.console_tooltip_pass_definitions)

var_0_15[#var_0_15 + 1] = "craft_item_background"
var_0_15[#var_0_15 + 1] = "craft_item_new_frame"
var_0_15[#var_0_15 + 1] = "craft_item_reward_title"

local var_0_16 = true
local var_0_17 = {
	craft_bar_bg = UIWidgets.create_simple_texture("console_crafting_bar_bg", "craft_bar", nil, nil, nil, -2),
	craft_bar = UIWidgets.create_simple_gradient_mask_texture("gamepad_crafting_bar_mask", "craft_bar"),
	craft_lock_shadow = UIWidgets.create_simple_texture("console_crafting_disc_big_bg", "craft_lock_shadow", nil, nil, {
		0,
		0,
		0,
		0
	}),
	craft_lock_top_left = UIWidgets.create_simple_rotated_texture("console_crafting_animation_slice_upper", 0, {
		208,
		312
	}, "craft_lock_top_left", var_0_16),
	craft_lock_top_right = UIWidgets.create_simple_uv_rotated_texture("console_crafting_animation_slice_upper", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, 0, {
		0,
		312
	}, "craft_lock_top_right", var_0_16),
	craft_lock_top_effect = UIWidgets.create_simple_texture("console_crafting_animation_dust", "craft_lock_top_effect", var_0_16),
	craft_lock_bottom_left = UIWidgets.create_simple_uv_texture("console_crafting_animation_slice_lower", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "craft_lock_bottom_left", var_0_16),
	craft_lock_bottom_right = UIWidgets.create_simple_texture("console_crafting_animation_slice_lower", "craft_lock_bottom_right", var_0_16),
	craft_effect_bottom_left = UIWidgets.create_simple_rotated_texture("console_crafting_animation_dust", math.pi / 3, {
		19.5,
		94.5
	}, "craft_effect_bottom_left", var_0_16),
	craft_effect_bottom_right = UIWidgets.create_simple_uv_rotated_texture("console_crafting_animation_dust", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, math.pi * 2 - math.pi / 3, {
		19.5,
		94.5
	}, "craft_effect_bottom_right", var_0_16),
	craft_lock_eye_left = UIWidgets.create_simple_texture("console_crafting_animation_eye", "craft_lock_eye_left", var_0_16),
	craft_lock_eye_right = UIWidgets.create_simple_uv_texture("console_crafting_animation_eye", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "craft_lock_eye_right", var_0_16),
	crafting_mask = UIWidgets.create_simple_texture("mask_circular", "crafting_mask"),
	craft_bg = UIWidgets.create_simple_rotated_texture("console_crafting_disc_big_bg", 0, {
		197,
		197
	}, "craft_bg"),
	craft_bg_detail = UIWidgets.create_simple_rotated_texture("console_crafting_disc_big_decorations", 0, {
		261,
		261
	}, "craft_bg_detail"),
	crafting_glow = UIWidgets.create_simple_texture("console_crafting_disc_small_outer_glow", "crafting_glow"),
	craft_icon_connection = UIWidgets.create_simple_texture("console_crafting_disc_connector", "craft_icon_connection"),
	description_bg = UIWidgets.create_rect_with_outer_frame("description_bg", var_0_9.description_bg.size, "frame_outer_fade_02", 0, UISettings.console_menu_rect_color),
	title_text = UIWidgets.create_simple_text("n/a", "title_text", nil, nil, var_0_10),
	description_text = UIWidgets.create_simple_text("n/a", "description_text", nil, nil, var_0_11),
	title_text_divider = UIWidgets.create_simple_texture("divider_01_top", "title_text_divider"),
	item_tooltip = UIWidgets.create_simple_item_presentation("item_tooltip_result", var_0_15)
}
local var_0_18 = {
	default = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "show_gamercard",
			priority = 2,
			description_text = "start_menu_switch_hero"
		},
		{
			input_action = "confirm",
			priority = 6,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 7,
			description_text = "input_description_back"
		}
	},
	filter_selected = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "show_gamercard",
			priority = 2,
			description_text = "start_menu_switch_hero"
		},
		{
			input_action = "special_1",
			priority = 3,
			description_text = "lb_reset_filters"
		},
		{
			input_action = "confirm",
			priority = 4,
			description_text = "input_description_filter"
		},
		{
			input_action = "refresh",
			priority = 5,
			description_text = "lb_search",
			content_check_function = function ()
				return not IS_WINDOWS
			end
		},
		{
			input_action = "back",
			priority = 6,
			description_text = "input_description_back"
		}
	},
	filter_active = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "special_1",
			priority = 3,
			description_text = "lb_reset_filters"
		},
		{
			input_action = "confirm",
			priority = 6,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 7,
			description_text = "input_description_back"
		}
	}
}
local var_0_19 = {
	salvage = {
		actions = {
			{
				input_action = "special_1",
				priority = 3,
				description_text = "input_description_reset"
			},
			{
				input_action = "refresh",
				priority = 4,
				description_text = "hero_view_crafting_salvage"
			}
		}
	},
	salvage_auto = {
		actions = {
			{
				input_action = "special_1",
				priority = 3,
				description_text = "input_description_reset"
			},
			{
				input_action = "right_stick_press",
				priority = 4,
				description_text = "hero_view_crafting_salvage_auto_fill"
			},
			{
				input_action = "refresh",
				priority = 5,
				description_text = "hero_view_crafting_salvage"
			}
		}
	},
	craft_random_item = {
		actions = {
			{
				input_action = "special_1",
				priority = 3,
				description_text = "input_description_reset"
			},
			{
				input_action = "refresh",
				priority = 4,
				description_text = "hero_view_crafting_craft"
			}
		}
	},
	reroll_weapon_properties = {
		actions = {
			{
				input_action = "special_1",
				priority = 3,
				description_text = "input_description_reset"
			},
			{
				input_action = "refresh",
				priority = 4,
				description_text = "hero_view_crafting_properties"
			}
		}
	},
	reroll_weapon_traits = {
		actions = {
			{
				input_action = "special_1",
				priority = 3,
				description_text = "input_description_reset"
			},
			{
				input_action = "refresh",
				priority = 4,
				description_text = "hero_view_crafting_trait"
			}
		}
	},
	upgrade_item_rarity_common = {
		actions = {
			{
				input_action = "special_1",
				priority = 3,
				description_text = "input_description_reset"
			},
			{
				input_action = "refresh",
				priority = 4,
				description_text = "hero_view_crafting_upgrade"
			}
		}
	},
	apply_weapon_skin = {
		actions = {
			{
				input_action = "special_1",
				priority = 3,
				description_text = "input_description_reset"
			},
			{
				input_action = "refresh",
				priority = 4,
				description_text = "hero_view_crafting_apply_skin"
			}
		}
	},
	convert_blue_dust = {
		actions = {
			{
				input_action = "special_1",
				priority = 3,
				description_text = "input_description_reset"
			},
			{
				input_action = "refresh",
				priority = 4,
				description_text = "hero_view_crafting_convert"
			}
		}
	},
	disabled = {
		actions = {
			{
				input_action = "special_1",
				priority = 3,
				description_text = "input_description_reset"
			}
		}
	},
	disabled_auto = {
		actions = {
			{
				input_action = "special_1",
				priority = 3,
				description_text = "input_description_reset"
			},
			{
				input_action = "right_stick_press",
				priority = 4,
				description_text = "hero_view_crafting_salvage_auto_fill"
			}
		}
	}
}
local var_0_20 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				local var_3_0 = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = var_3_0
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
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
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				local var_6_0 = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = 1 - var_6_0
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end
		}
	},
	reset_crafting = {
		{
			name = "reset",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				local var_8_0 = arg_8_2.craft_lock_top_left
				local var_8_1 = arg_8_2.craft_lock_top_right
				local var_8_2 = math.pi / 2

				var_8_0.style.texture_id.angle = var_8_2
				var_8_1.style.texture_id.angle = -var_8_2

				local var_8_3 = arg_8_2.craft_lock_bottom_left
				local var_8_4 = arg_8_2.craft_lock_bottom_right

				var_8_3.offset[2] = -208
				var_8_4.offset[2] = -208

				local var_8_5 = arg_8_2.craft_lock_eye_left
				local var_8_6 = arg_8_2.craft_lock_eye_right
				local var_8_7 = var_8_5.style.texture_id
				local var_8_8 = var_8_6.style.texture_id
				local var_8_9 = 224
				local var_8_10 = 217

				var_8_7.color[1] = 0
				var_8_7.horizontal_alignment = "center"
				var_8_7.vertical_alignment = "center"
				var_8_7.texture_size = var_8_7.texture_size or {
					var_8_9,
					var_8_10
				}
				var_8_8.color[1] = 0
				var_8_8.horizontal_alignment = "center"
				var_8_8.vertical_alignment = "center"
				var_8_8.texture_size = var_8_8.texture_size or {
					var_8_9,
					var_8_10
				}

				local var_8_11 = 39
				local var_8_12 = 189
				local var_8_13 = arg_8_2.craft_lock_top_effect.style.texture_id

				var_8_13.color[1] = 0
				var_8_13.horizontal_alignment = "center"
				var_8_13.vertical_alignment = "center"
				var_8_13.texture_size = var_8_13.texture_size or {
					var_8_11,
					var_8_12
				}

				local var_8_14 = arg_8_2.craft_effect_bottom_left.style.texture_id

				var_8_14.color[1] = 0
				var_8_14.horizontal_alignment = "center"
				var_8_14.vertical_alignment = "center"
				var_8_14.texture_size = var_8_14.texture_size or {
					var_8_11,
					var_8_12
				}

				local var_8_15 = arg_8_2.craft_effect_bottom_right.style.texture_id

				var_8_15.color[1] = 0
				var_8_15.horizontal_alignment = "center"
				var_8_15.vertical_alignment = "center"
				var_8_15.texture_size = var_8_15.texture_size or {
					var_8_11,
					var_8_12
				}
			end,
			update = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
				return
			end,
			on_complete = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end
		}
	},
	craft_enter = {
		{
			name = "reset",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				local var_11_0 = arg_11_2.craft_lock_top_left
				local var_11_1 = arg_11_2.craft_lock_top_right
				local var_11_2 = math.pi / 2

				var_11_0.style.texture_id.angle = var_11_2
				var_11_1.style.texture_id.angle = -var_11_2

				local var_11_3 = arg_11_2.craft_lock_bottom_left
				local var_11_4 = arg_11_2.craft_lock_bottom_right

				var_11_3.offset[2] = -208
				var_11_4.offset[2] = -208

				local var_11_5 = arg_11_2.craft_lock_eye_left
				local var_11_6 = arg_11_2.craft_lock_eye_right
				local var_11_7 = var_11_5.style.texture_id
				local var_11_8 = var_11_6.style.texture_id
				local var_11_9 = 224
				local var_11_10 = 217

				var_11_7.color[1] = 0
				var_11_7.horizontal_alignment = "center"
				var_11_7.vertical_alignment = "center"
				var_11_7.texture_size = var_11_7.texture_size or {
					var_11_9,
					var_11_10
				}
				var_11_8.color[1] = 0
				var_11_8.horizontal_alignment = "center"
				var_11_8.vertical_alignment = "center"
				var_11_8.texture_size = var_11_8.texture_size or {
					var_11_9,
					var_11_10
				}

				local var_11_11 = 39
				local var_11_12 = 189
				local var_11_13 = arg_11_2.craft_lock_top_effect.style.texture_id

				var_11_13.color[1] = 0
				var_11_13.horizontal_alignment = "center"
				var_11_13.vertical_alignment = "top"
				var_11_13.texture_size = var_11_13.texture_size or {
					var_11_11,
					var_11_12
				}

				local var_11_14 = arg_11_2.craft_effect_bottom_left.style.texture_id

				var_11_14.color[1] = 0
				var_11_14.horizontal_alignment = "center"
				var_11_14.vertical_alignment = "center"
				var_11_14.texture_size = var_11_14.texture_size or {
					var_11_11,
					var_11_12
				}

				local var_11_15 = arg_11_2.craft_effect_bottom_right.style.texture_id

				var_11_15.color[1] = 0
				var_11_15.horizontal_alignment = "center"
				var_11_15.vertical_alignment = "center"
				var_11_15.texture_size = var_11_15.texture_size or {
					var_11_11,
					var_11_12
				}
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				return
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		},
		{
			name = "shadow",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				return
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				arg_15_2.craft_lock_shadow.style.texture_id.color[1] = 200 * arg_15_3
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end
		},
		{
			name = "top",
			start_progress = 0,
			end_progress = 0.4,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				local var_18_0 = arg_18_2.craft_lock_top_left
				local var_18_1 = arg_18_2.craft_lock_top_right
				local var_18_2 = math.pi / 2
				local var_18_3 = math.easeInCubic(arg_18_3)
				local var_18_4 = math.catmullrom(var_18_3, -7.4, 0, 1, 0.7)

				var_18_0.style.texture_id.angle = var_18_2 - var_18_2 * var_18_4
				var_18_1.style.texture_id.angle = -var_18_2 + var_18_2 * var_18_4
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end
		},
		{
			name = "top_effect",
			start_progress = 0.3,
			end_progress = 0.8,
			init = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end,
			update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				local var_21_0 = arg_21_2.craft_lock_top_effect
				local var_21_1 = var_21_0.style.texture_id
				local var_21_2 = var_21_0.offset

				var_21_1.color[1] = 150 - 150 * math.easeInCubic(arg_21_3)
				var_21_2[2] = -50 * math.easeOutCubic(arg_21_3)

				local var_21_3 = 78
				local var_21_4 = 378

				var_21_1.texture_size[1] = var_21_3 * arg_21_3
				var_21_1.texture_size[2] = var_21_4 * arg_21_3
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				return
			end
		},
		{
			name = "bottom",
			start_progress = 0.5,
			end_progress = 0.8,
			init = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				return
			end,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				local var_24_0 = arg_24_2.craft_lock_bottom_left
				local var_24_1 = arg_24_2.craft_lock_bottom_right
				local var_24_2 = math.catmullrom(arg_24_3, -7.4, 0, 1, 0.7)
				local var_24_3 = 208

				var_24_0.offset[2] = -var_24_3 + var_24_2 * var_24_3
				var_24_1.offset[2] = -var_24_3 + var_24_2 * var_24_3
			end,
			on_complete = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				return
			end
		},
		{
			name = "bottom_effect_left",
			start_progress = 0.7,
			end_progress = 1.1,
			init = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				return
			end,
			update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				local var_27_0 = arg_27_2.craft_effect_bottom_left
				local var_27_1 = var_27_0.style.texture_id
				local var_27_2 = var_27_0.offset
				local var_27_3 = math.easeOutCubic(arg_27_3)

				var_27_1.color[1] = 80 - 80 * math.easeInCubic(arg_27_3)

				local var_27_4 = 27.299999999999997
				local var_27_5 = 132.29999999999998
				local var_27_6 = var_27_1.pivot
				local var_27_7 = var_27_1.texture_size

				var_27_7[1] = var_27_4 + var_27_4 * var_27_3
				var_27_7[2] = var_27_5 * var_27_3
				var_27_6[1] = var_27_7[1] / 2
				var_27_6[2] = var_27_7[2] / 2

				local var_27_8 = (var_27_4 - var_27_7[1]) * 0.5

				var_27_2[1] = var_27_8
				var_27_2[2] = var_27_8 * 0.5
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				return
			end
		},
		{
			name = "bottom_effect_right",
			start_progress = 0.7,
			end_progress = 1.1,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				return
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				local var_30_0 = arg_30_2.craft_effect_bottom_right
				local var_30_1 = var_30_0.style.texture_id
				local var_30_2 = var_30_0.offset
				local var_30_3 = math.easeOutCubic(arg_30_3)

				var_30_1.color[1] = 80 - 80 * math.easeInCubic(arg_30_3)

				local var_30_4 = 27.299999999999997
				local var_30_5 = 132.29999999999998
				local var_30_6 = var_30_1.pivot
				local var_30_7 = var_30_1.texture_size

				var_30_7[1] = var_30_4 + var_30_4 * var_30_3
				var_30_7[2] = var_30_5 * var_30_3
				var_30_6[1] = var_30_7[1] / 2
				var_30_6[2] = var_30_7[2] / 2

				local var_30_8 = (var_30_4 - var_30_7[1]) * 0.5

				var_30_2[1] = -var_30_8
				var_30_2[2] = var_30_8 * 0.5
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end
		},
		{
			name = "eyes",
			start_progress = 0.5,
			end_progress = 0.8,
			init = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				return
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				local var_33_0 = arg_33_2.craft_lock_eye_left
				local var_33_1 = arg_33_2.craft_lock_eye_right
				local var_33_2 = var_33_0.style.texture_id
				local var_33_3 = var_33_1.style.texture_id
				local var_33_4 = 255 * arg_33_3

				var_33_2.color[1] = var_33_4
				var_33_3.color[1] = var_33_4

				local var_33_5 = 224
				local var_33_6 = 217

				var_33_2.texture_size[1] = var_33_5 * arg_33_3
				var_33_2.texture_size[2] = var_33_6 * arg_33_3
				var_33_3.texture_size[1] = var_33_5 * arg_33_3
				var_33_3.texture_size[2] = var_33_6 * arg_33_3
			end,
			on_complete = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end
		}
	},
	craft_exit = {
		{
			name = "eyes",
			start_progress = 0,
			end_progress = 0.15,
			init = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				return
			end,
			update = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
				local var_36_0 = arg_36_2.craft_lock_eye_left
				local var_36_1 = arg_36_2.craft_lock_eye_right
				local var_36_2 = var_36_0.style.texture_id
				local var_36_3 = var_36_1.style.texture_id

				arg_36_3 = 1 - arg_36_3

				local var_36_4 = 255 * arg_36_3

				var_36_2.color[1] = var_36_4
				var_36_3.color[1] = var_36_4

				local var_36_5 = 224
				local var_36_6 = 217

				var_36_2.texture_size[1] = var_36_5 * arg_36_3
				var_36_2.texture_size[2] = var_36_6 * arg_36_3
				var_36_3.texture_size[1] = var_36_5 * arg_36_3
				var_36_3.texture_size[2] = var_36_6 * arg_36_3
			end,
			on_complete = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				return
			end
		},
		{
			name = "shadow",
			start_progress = 0.2,
			end_progress = 0.5,
			init = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				return
			end,
			update = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
				arg_39_2.craft_lock_shadow.style.texture_id.color[1] = 200 - 200 * arg_39_3
			end,
			on_complete = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				return
			end
		},
		{
			name = "top",
			start_progress = 0.2,
			end_progress = 0.5,
			init = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				return
			end,
			update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
				arg_42_3 = 1 - arg_42_3

				local var_42_0 = arg_42_2.craft_lock_top_left
				local var_42_1 = arg_42_2.craft_lock_top_right
				local var_42_2 = math.pi / 2

				var_42_0.style.texture_id.angle = var_42_2 - var_42_2 * arg_42_3
				var_42_1.style.texture_id.angle = -var_42_2 + var_42_2 * arg_42_3
			end,
			on_complete = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				return
			end
		},
		{
			name = "bottom",
			start_progress = 0.2,
			end_progress = 0.5,
			init = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				return
			end,
			update = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
				arg_45_3 = 1 - arg_45_3

				local var_45_0 = arg_45_2.craft_lock_bottom_left
				local var_45_1 = arg_45_2.craft_lock_bottom_right
				local var_45_2 = 208

				var_45_0.offset[2] = -var_45_2 + arg_45_3 * var_45_2
				var_45_1.offset[2] = -var_45_2 + arg_45_3 * var_45_2
			end,
			on_complete = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_17,
	node_widgets = node_widgets,
	scenegraph_definition = var_0_9,
	animation_definitions = var_0_20,
	generic_input_actions = var_0_18,
	input_actions = var_0_19
}
