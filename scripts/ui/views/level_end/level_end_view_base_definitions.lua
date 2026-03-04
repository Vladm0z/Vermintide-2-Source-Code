-- chunkname: @scripts/ui/views/level_end/level_end_view_base_definitions.lua

local var_0_0 = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.end_screen
		}
	}
}
local var_0_1 = {
	transition_fade = UIWidgets.create_simple_rect("screen", {
		255,
		0,
		0,
		0
	})
}
local var_0_2 = {
	transition = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				if arg_3_3.parent.game_won then
					arg_3_3.parent:play_sound("Stop_parading_screen_amb")
				end
			end
		},
		{
			name = "position_camera",
			start_progress = 1,
			end_progress = 1,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				return
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				local var_6_0 = arg_6_3.parent

				var_6_0:transition_camera(arg_6_3.transition_data)

				local var_6_1 = var_6_0._world

				World.get_data(var_6_1, "shading_settings")[1] = "default"
			end
		},
		{
			name = "fade_in",
			start_progress = 1,
			end_progress = 2,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				local var_8_0 = math.easeInCubic(arg_8_3)

				arg_8_4.render_settings.alpha_multiplier = 1 - var_8_0
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				return
			end
		}
	},
	default = {
		name = "default",
		start_progress = 0,
		end_progress = 0,
		init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			return
		end,
		update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
			return
		end,
		on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			return
		end
	}
}

return {
	transition_scenegraph_definition = var_0_0,
	transition_widget_definition = var_0_1,
	transition_animations = var_0_2
}
