-- chunkname: @scripts/ui/hud_ui/versus_onboarding_ui_definitions.lua

require("scripts/ui/views/versus_menu/ui_widgets_vs")

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = false
local var_0_3 = {
	screen = {
		scale = "hud_scale_fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	side_pivot_dark_pact = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			400,
			260
		}
	},
	side_pivot_heroes = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			400,
			360
		}
	}
}
local var_0_4 = {}
local var_0_5 = {
	enter = {
		{
			name = "slide_and_fade_in",
			start_progress = 0,
			end_progress = 0.75,
			init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				local var_1_0 = arg_1_3.self

				var_1_0._render_settings.alpha_multiplier = 0
				var_1_0._should_draw = true
			end,
			update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				if not arg_2_2 then
					return
				end

				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.self._render_settings.alpha_multiplier = arg_2_3
				arg_2_2.offset[1] = 400 * (1 - var_2_0)
			end,
			on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	exit = {
		{
			name = "slide_and_fade_out",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				if not arg_5_2 then
					return
				end

				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.self._render_settings.alpha_multiplier = 1 - arg_5_3
				arg_5_2.offset[1] = 400 * var_5_0
				arg_5_2.element.dirty = true
			end,
			on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				arg_6_3.self._should_draw = false
			end
		}
	}
}

return {
	animations_definitions = var_0_5,
	scenegraph = var_0_3,
	widgets = var_0_4
}
