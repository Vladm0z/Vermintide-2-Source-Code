-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_loadout_console_definitions.lua

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
			0,
			1
		}
	},
	disclaimer_text_background = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			520,
			60
		},
		position = {
			-20,
			-80,
			9
		}
	},
	disclaimer_text = {
		vertical_alignment = "center",
		parent = "disclaimer_text_background",
		horizontal_alignment = "center",
		size = {
			520,
			50
		},
		position = {
			0,
			0,
			10
		}
	}
}
local tbl_2 = {
	vertical_alignment = "bottom",
	font_size = 20,
	localize = false,
	horizontal_alignment = "center",
	word_wrap = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	arg_1_1.loadout_grid.local_position[2] = -arg_1_0 * 50

	return UIWidgets.create_loadout_grid_console("loadout_grid", tbl.loadout_grid.size, arg_1_0, num_2, nil, true)
end

local tbl_3 = {
	disclaimer_text = UIWidgets.create_simple_text(Localize("inventory_morris_note"), "disclaimer_text", tbl.disclaimer_text.size, nil, tbl_2),
	disclaimer_text_background = UIWidgets.create_rect_with_outer_frame("disclaimer_text_background", tbl.disclaimer_text_background.size, "frame_outer_fade_02", nil, Colors.get_color_table_with_alpha("black", 125))
}
local tbl_4 = {
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
			description_text = "start_menu_swap_inventory"
		},
		{
			input_action = "refresh",
			priority = 5,
			description_text = "start_menu_customize_item"
		},
		{
			input_action = "confirm",
			priority = 6,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 7,
			description_text = "input_description_close"
		}
	},
	default_no_customization = {
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
			description_text = "start_menu_swap_inventory"
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
			input_action = "right_stick_press",
			priority = 3,
			description_text = "input_description_toggle_hero_details",
			ignore_keybinding = false
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
local tbl_5 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				arg_2_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
				-- function 3
				local easeOutCubic = math.easeOutCubic(arg_3_3)

				arg_3_4.render_settings.alpha_multiplier = easeOutCubic
				arg_3_0.area_left.local_position[1] = arg_3_1.area_left.position[1] + math.floor(-100 * (1 - easeOutCubic))
			end,
			on_complete = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				arg_5_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
				-- function 6
				local easeOutCubic = math.easeOutCubic(arg_6_3)

				arg_6_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				return
			end
		}
	}
}

return {
	widgets = tbl_3,
	generic_input_actions = tbl_4,
	scenegraph_definition = tbl,
	animation_definitions = tbl_5,
	create_loadout_grid_func = fn
}
