-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_panel_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.size
local var_0_2 = var_0_0.spacing
local var_0_3 = var_0_0.large_window_frame
local var_0_4 = UIFrameSettings[var_0_3].texture_sizes.vertical[1]
local var_0_5 = {
	var_0_1[1] * 3 + var_0_2 * 2 + var_0_4 * 2,
	var_0_1[2] + 80
}
local var_0_6 = {
	var_0_5[1] + 50,
	var_0_5[2]
}
local var_0_7 = "menu_frame_11"
local var_0_8 = UIFrameSettings[var_0_7].texture_sizes.vertical[1]
local var_0_9 = 1.5
local var_0_10 = {
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
	screen_center = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = var_0_6,
		position = {
			0,
			0,
			1
		}
	},
	essence_panel = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			327,
			48
		},
		position = {
			var_0_8,
			-var_0_8,
			8
		}
	},
	essence_text = {
		vertical_alignment = "bottom",
		parent = "essence_panel",
		horizontal_alignment = "left",
		size = {
			296,
			30
		},
		position = {
			50,
			15,
			3
		}
	},
	essence_icon = {
		vertical_alignment = "center",
		parent = "essence_text",
		horizontal_alignment = "center",
		size = {
			32,
			32
		},
		position = {
			0,
			0,
			1
		}
	},
	top_corner_left = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			var_0_8,
			-var_0_8,
			12
		}
	},
	top_corner_right = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			110,
			110
		},
		position = {
			-var_0_8,
			-var_0_8,
			12
		}
	},
	bottom_corner_left = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			var_0_8,
			var_0_8,
			12
		}
	},
	bottom_corner_right = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			110,
			110
		},
		position = {
			-var_0_8,
			var_0_8,
			12
		}
	},
	loadout_power_title = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			300,
			20
		},
		position = {
			0,
			var_0_8 + 33,
			12
		}
	},
	loadout_power_text = {
		vertical_alignment = "bottom",
		parent = "loadout_power_title",
		horizontal_alignment = "center",
		size = {
			150,
			40
		},
		position = {
			0,
			-32,
			0
		}
	},
	bottom_panel_left = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			634,
			80
		},
		position = {
			-317,
			var_0_8,
			9
		}
	},
	bottom_panel_right = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			634,
			80
		},
		position = {
			317,
			var_0_8,
			9
		}
	},
	upgrade_button = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			532,
			126
		},
		position = {
			-var_0_8,
			-var_0_8,
			4
		}
	},
	forge_level_title = {
		vertical_alignment = "center",
		parent = "upgrade_button",
		horizontal_alignment = "center",
		size = {
			300,
			20
		},
		position = {
			20,
			35,
			3
		}
	},
	forge_level_text = {
		vertical_alignment = "center",
		parent = "forge_level_title",
		horizontal_alignment = "center",
		size = {
			150,
			40
		},
		position = {
			0,
			0,
			0
		}
	},
	background_wheel = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			math.floor(1022 * var_0_9),
			math.floor(1022 * var_0_9)
		},
		position = {
			0,
			0,
			1
		}
	},
	wheel_ring_1 = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			math.floor(188 * var_0_9),
			math.floor(188 * var_0_9)
		},
		position = {
			0,
			0,
			1
		}
	},
	wheel_ring_2 = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			math.floor(461 * var_0_9),
			math.floor(461 * var_0_9)
		},
		position = {
			0,
			0,
			1
		}
	},
	wheel_ring_3 = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			math.floor(1074 * var_0_9),
			math.floor(1074 * var_0_9)
		},
		position = {
			0,
			0,
			1
		}
	},
	top_glow = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_6[1],
			500
		},
		position = {
			0,
			-(var_0_8 - 1),
			0
		}
	}
}
local var_0_11 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_12 = {
	font_size = 26,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
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
local var_0_13 = {
	font_size = 18,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_14 = {
	font_size = 32,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_15 = {
	font_size = 62,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_16 = {
	font_size = 20,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
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
local var_0_17 = {
	font_size = 20,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
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
local var_0_18 = {
	200,
	138,
	0,
	147
}
local var_0_19 = {
	255,
	138,
	0,
	147
}
local var_0_20 = true
local var_0_21 = {
	hdr_background_write_mask = UIWidgets.create_simple_texture("ui_write_mask", "window"),
	hdr_background_wheel_1 = UIWidgets.create_simple_texture("athanor_skilltree_background_effect", "background_wheel", nil, nil, var_0_19, 5),
	hdr_wheel_ring_1_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_1", 0, {
		math.floor(188 * var_0_9) / 2,
		math.floor(188 * var_0_9) / 2
	}, "wheel_ring_1", nil, nil, var_0_19),
	hdr_wheel_ring_1_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_2", 0, {
		math.floor(461 * var_0_9) / 2,
		math.floor(461 * var_0_9) / 2
	}, "wheel_ring_2", nil, nil, var_0_19),
	hdr_wheel_ring_1_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_3", 0, {
		math.floor(1074 * var_0_9) / 2,
		math.floor(1074 * var_0_9) / 2
	}, "wheel_ring_3", nil, nil, var_0_19),
	hdr_wheel_ring_2_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_1", 0, {
		math.floor(188 * var_0_9) / 2,
		math.floor(188 * var_0_9) / 2
	}, "wheel_ring_1", nil, nil, var_0_19),
	hdr_wheel_ring_2_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_2", 0, {
		math.floor(461 * var_0_9) / 2,
		math.floor(461 * var_0_9) / 2
	}, "wheel_ring_2", nil, nil, var_0_19),
	hdr_wheel_ring_2_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_3", 0, {
		math.floor(1074 * var_0_9) / 2,
		math.floor(1074 * var_0_9) / 2
	}, "wheel_ring_3", nil, nil, var_0_19)
}
local var_0_22 = {
	background_write_mask = UIWidgets.create_simple_texture("athanor_background_write_mask", "window"),
	background_wheel_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_background", 0, {
		math.floor(1022 * var_0_9) / 2,
		math.floor(1022 * var_0_9) / 2
	}, "background_wheel", nil, nil, var_0_19),
	wheel_ring_1_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_1", 0, {
		math.floor(188 * var_0_9) / 2,
		math.floor(188 * var_0_9) / 2
	}, "wheel_ring_1", nil, nil, var_0_19),
	wheel_ring_1_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_2", 0, {
		math.floor(461 * var_0_9) / 2,
		math.floor(461 * var_0_9) / 2
	}, "wheel_ring_2", nil, nil, var_0_19),
	wheel_ring_1_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_3", 0, {
		math.floor(1074 * var_0_9) / 2,
		math.floor(1074 * var_0_9) / 2
	}, "wheel_ring_3", nil, nil, var_0_19),
	wheel_ring_2_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_1", 0, {
		math.floor(188 * var_0_9) / 2,
		math.floor(188 * var_0_9) / 2
	}, "wheel_ring_1", nil, nil, var_0_19),
	wheel_ring_2_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_2", 0, {
		math.floor(461 * var_0_9) / 2,
		math.floor(461 * var_0_9) / 2
	}, "wheel_ring_2", nil, nil, var_0_19),
	wheel_ring_2_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_3", 0, {
		math.floor(1074 * var_0_9) / 2,
		math.floor(1074 * var_0_9) / 2
	}, "wheel_ring_3", nil, nil, var_0_19),
	top_glow_smoke_1 = UIWidgets.create_simple_uv_texture("forge_overview_top_glow_effect_smoke_1", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "top_glow", nil, nil, var_0_18, 0)
}
local var_0_23 = {
	bottom_panel_left = UIWidgets.create_simple_texture("athanor_power_bg", "bottom_panel_left"),
	bottom_panel_right = UIWidgets.create_simple_uv_texture("athanor_power_bg", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "bottom_panel_right"),
	top_corner_left = UIWidgets.create_simple_texture("athanor_decoration_corner", "top_corner_left"),
	top_corner_right = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "top_corner_right"),
	bottom_corner_left = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_corner_left"),
	bottom_corner_right = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			1,
			1
		},
		{
			0,
			0
		}
	}, "bottom_corner_right"),
	essence_icon = UIWidgets.create_simple_texture("icon_crafting_essence_small", "essence_icon"),
	essence_panel = UIWidgets.create_simple_texture("athanor_panel_front", "essence_panel"),
	essence_text = UIWidgets.create_simple_text("", "essence_text", nil, nil, var_0_12),
	loadout_power_title = UIWidgets.create_simple_text(Localize("menu_weave_forge_power_level_title"), "loadout_power_title", nil, nil, var_0_13),
	loadout_power_text = UIWidgets.create_simple_text("0", "loadout_power_text", nil, nil, var_0_14),
	loadout_power_tooltip = UIWidgets.create_additional_option_tooltip("loadout_power_text", var_0_10.loadout_power_text.size, {
		"additional_option_info",
		"hero_power_perks"
	}, {
		title = Localize("menu_weave_forge_tooltip_weave_power_title"),
		description = Localize("menu_weave_forge_tooltip_weave_power_description")
	}, 400, nil, "top", nil, {
		0,
		22,
		0
	})
}
local var_0_24 = {
	on_enter = {
		{
			name = "top panel fade in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)
				local var_2_1 = arg_2_2.top_glow_smoke_1

				if var_2_1 then
					local var_2_2 = var_2_1.scenegraph_id

					var_2_1.content.texture_id.uvs[1][2] = 1 - var_2_0
					arg_2_0[var_2_2].size[2] = arg_2_1[var_2_2].size[2] * var_2_0
				end

				local var_2_3 = arg_2_2.top_glow_smoke_2

				if var_2_3 then
					local var_2_4 = var_2_3.scenegraph_id

					var_2_3.content.texture_id.uvs[1][2] = 1 - var_2_0
					arg_2_0[var_2_4].size[2] = arg_2_1[var_2_4].size[2] * var_2_0
				end
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		},
		{
			name = "upgrade_button_fade_in",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)
				local var_5_1 = arg_5_2.upgrade_button

				if var_5_1 then
					local var_5_2 = var_5_1.scenegraph_id

					arg_5_0[var_5_2].local_position[2] = arg_5_1[var_5_2].position[2] + 0 * var_5_0
				end
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	},
	show_panel = {
		{
			name = "top panel fade in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				arg_7_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = math.easeOutCubic(arg_8_3)
				local var_8_1 = arg_8_2.top_glow_smoke_1

				if var_8_1 then
					local var_8_2 = var_8_1.scenegraph_id

					var_8_1.content.texture_id.uvs[1][2] = 1 - var_8_0
					arg_8_0[var_8_2].size[2] = arg_8_1[var_8_2].size[2] * var_8_0
				end

				local var_8_3 = arg_8_2.top_glow_smoke_2

				if var_8_3 then
					local var_8_4 = var_8_3.scenegraph_id

					var_8_3.content.texture_id.uvs[1][2] = 1 - var_8_0
					arg_8_0[var_8_4].size[2] = arg_8_1[var_8_4].size[2] * var_8_0
				end
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		},
		{
			name = "upgrade_button_fade_in",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				arg_10_2.upgrade_button.alpha_multiplier = 0
				arg_10_2.forge_level_title.alpha_multiplier = 0
				arg_10_2.forge_level_text.alpha_multiplier = 0
				arg_10_2.loadout_power_title.alpha_multiplier = 0
				arg_10_2.loadout_power_text.alpha_multiplier = 0
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				local var_11_0 = math.easeOutCubic(arg_11_3)

				arg_11_2.upgrade_button.alpha_multiplier = math.max(arg_11_2.upgrade_button.alpha_multiplier, var_11_0)
				arg_11_2.forge_level_title.alpha_multiplier = math.max(arg_11_2.forge_level_title.alpha_multiplier, var_11_0)
				arg_11_2.forge_level_text.alpha_multiplier = math.max(arg_11_2.forge_level_text.alpha_multiplier, var_11_0)
				arg_11_2.loadout_power_title.alpha_multiplier = math.max(arg_11_2.loadout_power_title.alpha_multiplier, var_11_0)
				arg_11_2.loadout_power_text.alpha_multiplier = math.max(arg_11_2.loadout_power_text.alpha_multiplier, var_11_0)
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				return
			end
		}
	},
	hide_panel = {
		{
			name = "top panel fade in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				arg_13_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				local var_14_0 = math.easeOutCubic(1 - arg_14_3)
				local var_14_1 = arg_14_2.top_glow_smoke_1

				if var_14_1 then
					local var_14_2 = var_14_1.scenegraph_id

					var_14_1.content.texture_id.uvs[1][2] = 1 - var_14_0
					arg_14_0[var_14_2].size[2] = arg_14_1[var_14_2].size[2] * var_14_0
				end

				local var_14_3 = arg_14_2.top_glow_smoke_2

				if var_14_3 then
					local var_14_4 = var_14_3.scenegraph_id

					var_14_3.content.texture_id.uvs[1][2] = 1 - var_14_0
					arg_14_0[var_14_4].size[2] = arg_14_1[var_14_4].size[2] * var_14_0
				end
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				return
			end
		},
		{
			name = "upgrade_button_fade_in",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				arg_16_2.upgrade_button.alpha_multiplier = 0
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				local var_17_0 = math.easeOutCubic(1 - arg_17_3)

				arg_17_2.upgrade_button.alpha_multiplier = math.min(arg_17_2.upgrade_button.alpha_multiplier, var_17_0)
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				arg_19_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				local var_20_0 = math.easeOutCubic(arg_20_3)

				arg_20_4.render_settings.alpha_multiplier = 1 - var_20_0
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				return
			end
		}
	}
}

return {
	top_widgets = var_0_23,
	bottom_widgets = var_0_22,
	bottom_hdr_widgets = var_0_21,
	scenegraph_definition = var_0_10,
	animation_definitions = var_0_24
}
