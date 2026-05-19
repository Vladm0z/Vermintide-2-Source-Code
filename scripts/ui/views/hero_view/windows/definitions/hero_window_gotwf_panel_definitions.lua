-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_panel_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = UIFrameSettings[var_0_2].texture_sizes.vertical[1]
local var_0_5 = UIFrameSettings[var_0_2].texture_sizes.horizontal[2]
local var_0_6 = {
	var_0_3[1] - var_0_4 * 2,
	(var_0_3[2] - var_0_5 * 2) / 3.5
}
local var_0_7 = UISettings.console_menu_scenegraphs
local var_0_8 = {
	screen = var_0_7.screen,
	panel = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			1920,
			60
		},
		position = {
			0,
			0,
			UILayer.default + 1
		}
	},
	panel_fade = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			1920,
			30
		},
		position = {
			0,
			-60,
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
	close_button = {
		vertical_alignment = "top",
		parent = "panel",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			50,
			-40,
			3
		}
	}
}
local var_0_9 = UISettings.console_menu_rect_color
local var_0_10 = {
	panel = UIWidgets.create_simple_rect("panel", {
		255,
		0,
		0,
		0
	}),
	panel_fade = UIWidgets.create_simple_uv_texture("vertical_gradient", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "panel_fade", false, false, {
		255,
		0,
		0,
		0
	}),
	close_button = UIWidgets.create_layout_button("close_button", "layout_button_back", "layout_button_back_glow")
}
local var_0_11 = {
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

return {
	widgets = var_0_10,
	scenegraph_definition = var_0_8,
	animation_definitions = var_0_11
}
