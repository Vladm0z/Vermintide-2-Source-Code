-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_background_definitions.lua

local var_0_0 = UISettings.game_start_windows.large_window_size
local var_0_1 = "menu_frame_11"
local var_0_2 = UIFrameSettings[var_0_1].texture_sizes.vertical[1]
local var_0_3 = {
	var_0_0[1] - var_0_2 * 2,
	var_0_0[2] - var_0_2 * 2
}
local var_0_4 = 1.5
local var_0_5 = {
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
	parent_window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = var_0_0,
		position = {
			0,
			0,
			1
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "parent_window",
		horizontal_alignment = "right",
		size = var_0_3,
		position = {
			-var_0_2,
			0,
			1
		}
	},
	top_panel = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			84
		},
		position = {
			0,
			0,
			6
		}
	},
	top_glow = {
		vertical_alignment = "top",
		parent = "top_panel",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			500
		},
		position = {
			0,
			1,
			-1
		}
	},
	background_wheel = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			math.floor(1022 * var_0_4),
			math.floor(1022 * var_0_4)
		},
		position = {
			0,
			220,
			1
		}
	},
	wheel_ring_1 = {
		vertical_alignment = "center",
		parent = "background_wheel",
		horizontal_alignment = "center",
		size = {
			math.floor(188 * var_0_4),
			math.floor(188 * var_0_4)
		},
		position = {
			0,
			0,
			0
		}
	},
	wheel_ring_2 = {
		vertical_alignment = "center",
		parent = "background_wheel",
		horizontal_alignment = "center",
		size = {
			math.floor(461 * var_0_4),
			math.floor(461 * var_0_4)
		},
		position = {
			0,
			0,
			0
		}
	},
	wheel_ring_3 = {
		vertical_alignment = "center",
		parent = "background_wheel",
		horizontal_alignment = "center",
		size = {
			math.floor(1074 * var_0_4),
			math.floor(1074 * var_0_4)
		},
		position = {
			0,
			0,
			0
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
			0,
			0,
			15
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
			0,
			0,
			15
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
			0,
			0,
			15
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
			0,
			0,
			15
		}
	},
	bottom_glow = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			var_0_3[2]
		},
		position = {
			0,
			0,
			3
		}
	},
	bottom_glow_short = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			500
		},
		position = {
			0,
			0,
			4
		}
	},
	bottom_glow_shortest = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			200
		},
		position = {
			0,
			0,
			5
		}
	}
}
local var_0_6 = {
	255,
	0,
	0,
	0
}
local var_0_7 = {
	200,
	138,
	0,
	147
}
local var_0_8 = {
	255,
	138,
	0,
	187
}
local var_0_9 = {
	200,
	128,
	0,
	217
}
local var_0_10 = {
	130,
	255,
	255,
	255
}
local var_0_11 = {
	200,
	138,
	0,
	147
}
local var_0_12 = {
	255,
	138,
	0,
	147
}
local var_0_13 = {
	hdr_background_write_mask = UIWidgets.create_simple_texture("ui_write_mask", "window"),
	hdr_background_wheel_1 = UIWidgets.create_simple_texture("athanor_skilltree_background_effect", "background_wheel", nil, nil, var_0_12, 5),
	hdr_wheel_ring_1_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_1", 0, {
		math.floor(188 * var_0_4) / 2,
		math.floor(188 * var_0_4) / 2
	}, "wheel_ring_1", nil, nil, var_0_12),
	hdr_wheel_ring_1_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_2", 0, {
		math.floor(461 * var_0_4) / 2,
		math.floor(461 * var_0_4) / 2
	}, "wheel_ring_2", nil, nil, var_0_12),
	hdr_wheel_ring_1_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_3", 0, {
		math.floor(1074 * var_0_4) / 2,
		math.floor(1074 * var_0_4) / 2
	}, "wheel_ring_3", nil, nil, var_0_12),
	hdr_wheel_ring_2_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_1", 0, {
		math.floor(188 * var_0_4) / 2,
		math.floor(188 * var_0_4) / 2
	}, "wheel_ring_1", nil, nil, var_0_12),
	hdr_wheel_ring_2_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_2", 0, {
		math.floor(461 * var_0_4) / 2,
		math.floor(461 * var_0_4) / 2
	}, "wheel_ring_2", nil, nil, var_0_12),
	hdr_wheel_ring_2_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_3", 0, {
		math.floor(1074 * var_0_4) / 2,
		math.floor(1074 * var_0_4) / 2
	}, "wheel_ring_3", nil, nil, var_0_12),
	top_glow_smoke_1 = UIWidgets.create_simple_uv_texture("forge_overview_top_glow_effect_smoke_1", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "top_glow", nil, nil, var_0_11, 0)
}
local var_0_14 = {
	background_write_mask = UIWidgets.create_simple_texture("athanor_background_write_mask", "window"),
	background_wheel_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_background", 0, {
		math.floor(1022 * var_0_4) / 2,
		math.floor(1022 * var_0_4) / 2
	}, "background_wheel", nil, nil, var_0_12),
	wheel_ring_1_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_1", 0, {
		math.floor(188 * var_0_4) / 2,
		math.floor(188 * var_0_4) / 2
	}, "wheel_ring_1", nil, nil, var_0_12),
	wheel_ring_1_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_2", 0, {
		math.floor(461 * var_0_4) / 2,
		math.floor(461 * var_0_4) / 2
	}, "wheel_ring_2", nil, nil, var_0_12),
	wheel_ring_1_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_3", 0, {
		math.floor(1074 * var_0_4) / 2,
		math.floor(1074 * var_0_4) / 2
	}, "wheel_ring_3", nil, nil, var_0_12),
	wheel_ring_2_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_1", 0, {
		math.floor(188 * var_0_4) / 2,
		math.floor(188 * var_0_4) / 2
	}, "wheel_ring_1", nil, nil, var_0_12),
	wheel_ring_2_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_2", 0, {
		math.floor(461 * var_0_4) / 2,
		math.floor(461 * var_0_4) / 2
	}, "wheel_ring_2", nil, nil, var_0_12),
	wheel_ring_2_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_3", 0, {
		math.floor(1074 * var_0_4) / 2,
		math.floor(1074 * var_0_4) / 2
	}, "wheel_ring_3", nil, nil, var_0_12),
	window_background = UIWidgets.create_simple_rect("window", var_0_6),
	bottom_glow_smoke_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, var_0_7),
	bottom_glow_smoke_2 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, var_0_8),
	bottom_glow_smoke_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_shortest", nil, nil, var_0_9),
	bottom_glow_embers_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, var_0_10, 1),
	bottom_glow_embers_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_3", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, var_0_10, 1)
}
local var_0_15 = {
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
	}, "bottom_corner_right")
}
local var_0_16 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - var_5_0
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}

return {
	top_widgets = var_0_15,
	bottom_widgets = var_0_14,
	bottom_hdr_widgets = var_0_13,
	scenegraph_definition = var_0_5,
	animation_definitions = var_0_16
}
