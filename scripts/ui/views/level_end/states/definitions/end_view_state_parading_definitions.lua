-- chunkname: @scripts/ui/views/level_end/states/definitions/end_view_state_parading_definitions.lua

local tbl = {
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
local flag = true
local tbl_2 = {
	continue_button = UIWidgets.create_default_button("continue_button", tbl.continue_button.size, nil, nil, Localize("continue_menu_button_name"), 25, nil, nil, nil, flag)
}
local tbl_3 = {
	animate_continue_button = {
		{
			name = "translate",
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
				arg_2_2.continue_button.offset[2] = math.lerp(-200, 280, easeOutCubic)
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		}
	}
}
local tbl_4 = {
	default = {
		{
			input_action = "confirm",
			priority = 1,
			description_text = "continue_menu_button_name"
		}
	}
}

return {
	scenegraph_definitions = tbl,
	widget_definitions = tbl_2,
	animation_definitions = tbl_3,
	generic_input_actions = tbl_4
}
