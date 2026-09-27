-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_panel_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local var_0_4 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_5 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local tbl = {
	size[1] - var_0_4 * 2,
	(size[2] - var_0_5 * 2) / 3.5
}
local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl_2 = {
	screen = console_menu_scenegraphs.screen,
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
local console_menu_rect_color = UISettings.console_menu_rect_color
local tbl_3 = {
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
local tbl_4 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeOutCubic = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
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
				-- function 4
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeOutCubic = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		}
	}
}

return {
	widgets = tbl_3,
	scenegraph_definition = tbl_2,
	animation_definitions = tbl_4
}
