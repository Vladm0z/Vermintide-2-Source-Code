-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_loadout_console_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local var_0_5 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local num = size[1] - (var_0_5 * 2 + 60)
local num_2 = 60
local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl = {
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	area_left = console_menu_scenegraphs.area_left,
	area_right = console_menu_scenegraphs.area_right,
	area_divider = console_menu_scenegraphs.area_divider,
	loadout_grid = {
		vertical_alignment = "top",
		parent = "area_left",
		horizontal_alignment = "left",
		size = {
			80,
			size[1]
		},
		position = {
			90,
			-180,
			1
		}
	}
}
local tbl_2 = {
	loadout_grid = UIWidgets.create_loadout_grid_console("loadout_grid", tbl.loadout_grid.size, 4, num_2)
}
local tbl_3 = {
	default = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "l2_r2",
			priority = 2,
			description_text = "input_description_select_loadout",
			ignore_keybinding = true
		},
		{
			input_action = "right_stick_press",
			priority = 3,
			description_text = "input_description_manage_loadouts",
			ignore_keybinding = false
		},
		{
			input_action = "show_gamercard",
			priority = 4,
			description_text = "start_menu_switch_hero"
		},
		{
			input_action = "confirm",
			priority = 5,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 6,
			description_text = "input_description_close"
		}
	},
	details = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "right_stick",
			priority = 2,
			description_text = "input_description_scroll_details",
			ignore_keybinding = true
		},
		{
			input_action = "right_thumb",
			priority = 3,
			description_text = "input_description_toggle_hero_details",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 4,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 5,
			description_text = "input_description_close"
		}
	}
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
				arg_2_0.area_left.local_position[1] = arg_2_1.area_left.position[1] + math.floor(-100 * (1 - easeOutCubic))
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
	widgets = tbl_2,
	generic_input_actions = tbl_3,
	scenegraph_definition = tbl,
	animation_definitions = tbl_4
}
