-- chunkname: @scripts/ui/views/hero_view/windows/store/definitions/store_window_background_definitions.lua

local var_0_0 = UISettings.console_menu_scenegraphs
local var_0_1 = {
	screen = var_0_0.screen,
	top_panel_fade = {
		vertical_alignment = "top",
		scale = "fit_width",
		size = {
			1920,
			400
		},
		position = {
			0,
			-69,
			UILayer.default + 3
		}
	},
	bottom_panel_fade = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			1920,
			400
		},
		position = {
			0,
			69,
			UILayer.default + 3
		}
	}
}
local var_0_2 = {
	screen_shadow = UIWidgets.create_simple_texture("gradient_store_menu", "screen", nil, nil, {
		50,
		255,
		255,
		255
	}, 1),
	top_panel_fade = UIWidgets.create_simple_texture("loot_presentation_fg_01_fade", "top_panel_fade", nil, nil, {
		50,
		255,
		255,
		255
	}),
	bottom_panel_fade = UIWidgets.create_simple_texture("loot_presentation_fg_02_fade", "bottom_panel_fade", nil, nil, {
		50,
		255,
		255,
		255
	}),
	background_rect = UIWidgets.create_simple_rect("screen", {
		100,
		26,
		26,
		26
	})
}
local var_0_3 = {
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
	widgets = var_0_2,
	scenegraph_definition = var_0_1,
	animation_definitions = var_0_3
}
