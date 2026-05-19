-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_background_console_definitions.lua

local var_0_0 = UISettings.game_start_windows.size
local var_0_1 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - var_5_0
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}
local var_0_2 = {
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
	window = {
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
	preview = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_0[1],
			var_0_0[2] - 120
		},
		position = {
			0,
			0,
			8
		}
	},
	detailed_button = {
		vertical_alignment = "top",
		parent = "preview",
		horizontal_alignment = "right",
		size = {
			50,
			50
		},
		position = {
			0,
			0,
			1
		}
	},
	detailed_list = {
		vertical_alignment = "top",
		parent = "detailed_button",
		horizontal_alignment = "right",
		size = {
			var_0_0[1],
			var_0_0[2] - 120 - 50
		},
		position = {
			0,
			-40,
			1
		}
	},
	loading_overlay = {
		vertical_alignment = "center",
		parent = "root_fit",
		horizontal_alignment = "center",
		size = {
			314,
			33
		},
		position = {
			0,
			0,
			1
		}
	}
}
local var_0_3 = {
	loading_overlay = UIWidgets.create_simple_rect("root_fit", {
		255,
		12,
		12,
		12
	}),
	loading_overlay_loading_glow = UIWidgets.create_simple_texture("loading_title_divider", "loading_overlay", nil, nil, nil, 1),
	loading_overlay_loading_frame = UIWidgets.create_simple_texture("loading_title_divider_background", "loading_overlay")
}
local var_0_4 = {
	witch_hunter = {
		z = 0.4,
		x = 1,
		y = -0.4
	},
	bright_wizard = {
		z = 0.2,
		x = 1,
		y = -0.7
	},
	dwarf_ranger = {
		z = 0,
		x = 1,
		y = -0.6
	},
	wood_elf = {
		z = 0.16,
		x = 1,
		y = -0.5
	},
	empire_soldier = {
		z = 0.2,
		x = 1,
		y = -0.6
	},
	empire_soldier_tutorial = {
		z = 0.2,
		x = 1,
		y = -0.6
	}
}

return {
	scenegraph_definition = var_0_2,
	animation_definitions = var_0_1,
	camera_position_by_character = var_0_4,
	loading_overlay_widgets = var_0_3
}
