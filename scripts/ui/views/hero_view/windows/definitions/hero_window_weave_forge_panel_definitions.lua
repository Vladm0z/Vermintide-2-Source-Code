-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_weave_forge_panel_definitions.lua

local game_start_windows = UISettings.game_start_windows
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local large_window_frame = game_start_windows.large_window_frame
local var_0_4 = UIFrameSettings[large_window_frame].texture_sizes.vertical[1]
local tbl = {
	size[1] * 3 + spacing * 2 + var_0_4 * 2,
	size[2] + 80
}
local tbl_2 = {
	tbl[1] + 50,
	tbl[2]
}
local str = "menu_frame_11"
local var_0_8 = UIFrameSettings[str].texture_sizes.vertical[1]
local num = 1.5
local tbl_3 = {
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
		size = tbl_2,
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
			math.floor(1022 * num),
			math.floor(1022 * num)
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
			math.floor(188 * num),
			math.floor(188 * num)
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
			math.floor(461 * num),
			math.floor(461 * num)
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
			math.floor(1074 * num),
			math.floor(1074 * num)
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
			tbl_2[1],
			500
		},
		position = {
			0,
			-(var_0_8 - 1),
			0
		}
	}
}
local tbl_4 = {
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
local tbl_5 = {
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
local tbl_6 = {
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
local tbl_7 = {
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
local tbl_8 = {
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
local tbl_9 = {
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
local tbl_10 = {
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
local tbl_11 = {
	200,
	138,
	0,
	147
}
local tbl_12 = {
	255,
	138,
	0,
	147
}
local flag = true
local tbl_13 = {
	hdr_background_write_mask = UIWidgets.create_simple_texture("ui_write_mask", "window"),
	hdr_background_wheel_1 = UIWidgets.create_simple_texture("athanor_skilltree_background_effect", "background_wheel", nil, nil, tbl_12, 5),
	hdr_wheel_ring_1_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_1", 0, {
		math.floor(188 * num) / 2,
		math.floor(188 * num) / 2
	}, "wheel_ring_1", nil, nil, tbl_12),
	hdr_wheel_ring_1_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_2", 0, {
		math.floor(461 * num) / 2,
		math.floor(461 * num) / 2
	}, "wheel_ring_2", nil, nil, tbl_12),
	hdr_wheel_ring_1_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_3", 0, {
		math.floor(1074 * num) / 2,
		math.floor(1074 * num) / 2
	}, "wheel_ring_3", nil, nil, tbl_12),
	hdr_wheel_ring_2_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_1", 0, {
		math.floor(188 * num) / 2,
		math.floor(188 * num) / 2
	}, "wheel_ring_1", nil, nil, tbl_12),
	hdr_wheel_ring_2_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_2", 0, {
		math.floor(461 * num) / 2,
		math.floor(461 * num) / 2
	}, "wheel_ring_2", nil, nil, tbl_12),
	hdr_wheel_ring_2_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_3", 0, {
		math.floor(1074 * num) / 2,
		math.floor(1074 * num) / 2
	}, "wheel_ring_3", nil, nil, tbl_12)
}
local tbl_14 = {
	background_write_mask = UIWidgets.create_simple_texture("athanor_background_write_mask", "window"),
	background_wheel_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_background", 0, {
		math.floor(1022 * num) / 2,
		math.floor(1022 * num) / 2
	}, "background_wheel", nil, nil, tbl_12),
	wheel_ring_1_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_1", 0, {
		math.floor(188 * num) / 2,
		math.floor(188 * num) / 2
	}, "wheel_ring_1", nil, nil, tbl_12),
	wheel_ring_1_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_2", 0, {
		math.floor(461 * num) / 2,
		math.floor(461 * num) / 2
	}, "wheel_ring_2", nil, nil, tbl_12),
	wheel_ring_1_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_3", 0, {
		math.floor(1074 * num) / 2,
		math.floor(1074 * num) / 2
	}, "wheel_ring_3", nil, nil, tbl_12),
	wheel_ring_2_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_1", 0, {
		math.floor(188 * num) / 2,
		math.floor(188 * num) / 2
	}, "wheel_ring_1", nil, nil, tbl_12),
	wheel_ring_2_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_2", 0, {
		math.floor(461 * num) / 2,
		math.floor(461 * num) / 2
	}, "wheel_ring_2", nil, nil, tbl_12),
	wheel_ring_2_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_3", 0, {
		math.floor(1074 * num) / 2,
		math.floor(1074 * num) / 2
	}, "wheel_ring_3", nil, nil, tbl_12),
	top_glow_smoke_1 = UIWidgets.create_simple_uv_texture("forge_overview_top_glow_effect_smoke_1", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "top_glow", nil, nil, tbl_11, 0)
}
local tbl_15 = {
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
	essence_text = UIWidgets.create_simple_text("", "essence_text", nil, nil, tbl_5),
	loadout_power_title = UIWidgets.create_simple_text(Localize("menu_weave_forge_power_level_title"), "loadout_power_title", nil, nil, tbl_6),
	loadout_power_text = UIWidgets.create_simple_text("0", "loadout_power_text", nil, nil, tbl_7),
	loadout_power_tooltip = UIWidgets.create_additional_option_tooltip("loadout_power_text", tbl_3.loadout_power_text.size, {
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
local tbl_16 = {
	on_enter = {
		{
			name = "top panel fade in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				arg_1_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeOutCubic = math.easeOutCubic(arg_2_3)
				local top_glow_smoke_1 = arg_2_2.top_glow_smoke_1

				if not top_glow_smoke_1 then
					local scenegraph_id = top_glow_smoke_1.scenegraph_id

					top_glow_smoke_1.content.texture_id.uvs[1][2] = 1 - easeOutCubic
					arg_2_0[scenegraph_id].size[2] = arg_2_1[scenegraph_id].size[2] * easeOutCubic
				end

				local top_glow_smoke_2 = arg_2_2.top_glow_smoke_2

				if not top_glow_smoke_2 then
					local scenegraph_id_2 = top_glow_smoke_2.scenegraph_id

					top_glow_smoke_2.content.texture_id.uvs[1][2] = 1 - easeOutCubic
					arg_2_0[scenegraph_id_2].size[2] = arg_2_1[scenegraph_id_2].size[2] * easeOutCubic
				end
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		},
		{
			name = "upgrade_button_fade_in",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeOutCubic = math.easeOutCubic(arg_5_3)
				local upgrade_button = arg_5_2.upgrade_button

				if not upgrade_button then
					local scenegraph_id = upgrade_button.scenegraph_id

					arg_5_0[scenegraph_id].local_position[2] = arg_5_1[scenegraph_id].position[2] + 0 * easeOutCubic
				end
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
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
				-- function 7
				arg_7_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local easeOutCubic = math.easeOutCubic(arg_8_3)
				local top_glow_smoke_1 = arg_8_2.top_glow_smoke_1

				if not top_glow_smoke_1 then
					local scenegraph_id = top_glow_smoke_1.scenegraph_id

					top_glow_smoke_1.content.texture_id.uvs[1][2] = 1 - easeOutCubic
					arg_8_0[scenegraph_id].size[2] = arg_8_1[scenegraph_id].size[2] * easeOutCubic
				end

				local top_glow_smoke_2 = arg_8_2.top_glow_smoke_2

				if not top_glow_smoke_2 then
					local scenegraph_id_2 = top_glow_smoke_2.scenegraph_id

					top_glow_smoke_2.content.texture_id.uvs[1][2] = 1 - easeOutCubic
					arg_8_0[scenegraph_id_2].size[2] = arg_8_1[scenegraph_id_2].size[2] * easeOutCubic
				end
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		},
		{
			name = "upgrade_button_fade_in",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				arg_10_2.upgrade_button.alpha_multiplier = 0
				arg_10_2.forge_level_title.alpha_multiplier = 0
				arg_10_2.forge_level_text.alpha_multiplier = 0
				arg_10_2.loadout_power_title.alpha_multiplier = 0
				arg_10_2.loadout_power_text.alpha_multiplier = 0
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local easeOutCubic = math.easeOutCubic(arg_11_3)

				arg_11_2.upgrade_button.alpha_multiplier = math.max(arg_11_2.upgrade_button.alpha_multiplier, easeOutCubic)
				arg_11_2.forge_level_title.alpha_multiplier = math.max(arg_11_2.forge_level_title.alpha_multiplier, easeOutCubic)
				arg_11_2.forge_level_text.alpha_multiplier = math.max(arg_11_2.forge_level_text.alpha_multiplier, easeOutCubic)
				arg_11_2.loadout_power_title.alpha_multiplier = math.max(arg_11_2.loadout_power_title.alpha_multiplier, easeOutCubic)
				arg_11_2.loadout_power_text.alpha_multiplier = math.max(arg_11_2.loadout_power_text.alpha_multiplier, easeOutCubic)
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
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
				-- function 13
				arg_13_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
				-- function 14
				local easeOutCubic = math.easeOutCubic(1 - arg_14_3)
				local top_glow_smoke_1 = arg_14_2.top_glow_smoke_1

				if not top_glow_smoke_1 then
					local scenegraph_id = top_glow_smoke_1.scenegraph_id

					top_glow_smoke_1.content.texture_id.uvs[1][2] = 1 - easeOutCubic
					arg_14_0[scenegraph_id].size[2] = arg_14_1[scenegraph_id].size[2] * easeOutCubic
				end

				local top_glow_smoke_2 = arg_14_2.top_glow_smoke_2

				if not top_glow_smoke_2 then
					local scenegraph_id_2 = top_glow_smoke_2.scenegraph_id

					top_glow_smoke_2.content.texture_id.uvs[1][2] = 1 - easeOutCubic
					arg_14_0[scenegraph_id_2].size[2] = arg_14_1[scenegraph_id_2].size[2] * easeOutCubic
				end
			end,
			on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				return
			end
		},
		{
			name = "upgrade_button_fade_in",
			start_progress = 0.2,
			end_progress = 0.4,
			init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				arg_16_2.upgrade_button.alpha_multiplier = 0
			end,
			update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				local easeOutCubic = math.easeOutCubic(1 - arg_17_3)

				arg_17_2.upgrade_button.alpha_multiplier = math.min(arg_17_2.upgrade_button.alpha_multiplier, easeOutCubic)
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
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
				-- function 19
				arg_19_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				local easeOutCubic = math.easeOutCubic(arg_20_3)

				arg_20_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				return
			end
		}
	}
}

return {
	top_widgets = tbl_15,
	bottom_widgets = tbl_14,
	bottom_hdr_widgets = tbl_13,
	scenegraph_definition = tbl_3,
	animation_definitions = tbl_16
}
