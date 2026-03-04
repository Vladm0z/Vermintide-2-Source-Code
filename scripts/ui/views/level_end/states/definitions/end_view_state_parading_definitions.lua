-- chunkname: @scripts/ui/views/level_end/states/definitions/end_view_state_parading_definitions.lua

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
	},
	continue_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			300,
			75
		},
		position = {
			0,
			-200,
			0
		}
	}
}
local var_0_1 = true
local var_0_2 = {
	continue_button = UIWidgets.create_default_button("continue_button", var_0_0.continue_button.size, nil, nil, Localize("continue_menu_button_name"), 25, nil, nil, nil, var_0_1)
}
local var_0_3 = {
	animate_continue_button = {
		{
			name = "translate",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
				arg_2_2.continue_button.offset[2] = math.lerp(-200, 280, var_2_0)
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				return
			end
		}
	}
}
local var_0_4 = {
	default = {
		{
			input_action = "confirm",
			priority = 1,
			description_text = "continue_menu_button_name"
		}
	}
}

return {
	scenegraph_definitions = var_0_0,
	widget_definitions = var_0_2,
	animation_definitions = var_0_3,
	generic_input_actions = var_0_4
}
