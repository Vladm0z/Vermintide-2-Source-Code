-- chunkname: @scripts/ui/views/hero_view/craft_pages/definitions/craft_page_convert_dust_console_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing

NUM_CRAFT_SLOTS_X = 1
NUM_CRAFT_SLOTS_Y = 1
NUM_CRAFT_SLOTS = NUM_CRAFT_SLOTS_X * NUM_CRAFT_SLOTS_Y

local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl = {
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	area_left = console_menu_scenegraphs.area_left,
	area_right = console_menu_scenegraphs.area_right,
	area_divider = console_menu_scenegraphs.area_divider,
	craft_bg_root = console_menu_scenegraphs.craft_bg_root,
	craft_button = console_menu_scenegraphs.craft_button,
	item_grid = {
		vertical_alignment = "center",
		parent = "craft_bg_root",
		horizontal_alignment = "center",
		size = {
			185,
			182
		},
		position = {
			0,
			0,
			6
		}
	},
	item_grid_icon = {
		vertical_alignment = "center",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			72,
			62
		},
		position = {
			0,
			0,
			0
		}
	},
	material_bg = {
		vertical_alignment = "top",
		parent = "craft_bg_root",
		horizontal_alignment = "center",
		size = {
			232,
			107
		},
		position = {
			0,
			-80,
			2
		}
	},
	material_text_1 = {
		vertical_alignment = "top",
		parent = "craft_bg_root",
		horizontal_alignment = "center",
		size = {
			60,
			100
		},
		position = {
			0,
			-90,
			2
		}
	},
	material_text_2 = {
		vertical_alignment = "top",
		parent = "craft_bg_root",
		horizontal_alignment = "center",
		size = {
			60,
			100
		},
		position = {
			0,
			-90,
			2
		}
	}
}
local flag = true
local tbl_2 = {
	item_grid_bg = UIWidgets.create_simple_texture("console_crafting_slot_01", "item_grid", nil, nil, nil, -1),
	item_grid = UIWidgets.create_grid("item_grid", tbl.item_grid.size, NUM_CRAFT_SLOTS_Y, NUM_CRAFT_SLOTS_X, 20, 20),
	item_grid_icon = UIWidgets.create_simple_texture("crafting_icon_dust", "item_grid_icon"),
	craft_button = UIWidgets.create_console_craft_button("craft_button", "console_crafting_recipe_icon_dust"),
	material_bg = UIWidgets.create_simple_texture("console_crafting_bg_conversion_disc", "material_bg"),
	material_text_1 = UIWidgets.create_craft_material_widget("material_text_1"),
	material_text_2 = UIWidgets.create_craft_material_widget("material_text_2")
}
local tbl_3 = {
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
	widgets = tbl_2,
	scenegraph_definition = tbl,
	animation_definitions = tbl_3
}
