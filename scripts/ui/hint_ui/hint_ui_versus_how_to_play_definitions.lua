-- chunkname: @scripts/ui/hint_ui/hint_ui_versus_how_to_play_definitions.lua

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
			UILayer.popup
		}
	},
	hint_anchor = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-400,
			0,
			1
		}
	}
}
local var_0_1 = {}
local var_0_2 = {
	enter = {
		{
			name = "slide_and_fade_in",
			start_progress = 0,
			end_progress = 0.75,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0

				local var_1_0 = arg_1_3.wwise_world

				WwiseWorld.trigger_event(var_1_0, "Play_hud_gameplay_hint")
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				if not arg_2_2 then
					return
				end

				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = arg_2_3
				arg_2_2.offset[1] = 400 * (1 - var_2_0)
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	},
	exit = {
		{
			name = "slide_and_fade_out",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				if not arg_5_2 then
					return
				end

				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - arg_5_3
				arg_5_2.offset[1] = 400 * var_5_0
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				arg_6_3.self:hide()
			end
		}
	}
}

return {
	scenegraph_definition = var_0_0,
	widget_definitions = var_0_1,
	animation_definitions = var_0_2
}
