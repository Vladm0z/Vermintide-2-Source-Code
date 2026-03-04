-- chunkname: @scripts/ui/views/hero_view/craft_pages/definitions/craft_page_roll_properties_console_definitions.lua

local var_0_0 = 1
local var_0_1 = 1
local var_0_2 = var_0_0 * var_0_1
local var_0_3 = UISettings.console_menu_scenegraphs
local var_0_4 = {
	screen = var_0_3.screen,
	area = var_0_3.area,
	area_left = var_0_3.area_left,
	area_right = var_0_3.area_right,
	area_divider = var_0_3.area_divider,
	craft_bg_root = var_0_3.craft_bg_root,
	craft_button = var_0_3.craft_button,
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
	},
	material_text_3 = {
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
	material_text_4 = {
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
	material_text_5 = {
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
	material_text_6 = {
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
	material_text_7 = {
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
local var_0_5 = true
local var_0_6 = {
	item_grid_bg = UIWidgets.create_simple_texture("console_crafting_slot_01", "item_grid", nil, nil, nil, -1),
	item_grid = UIWidgets.create_grid("item_grid", var_0_4.item_grid.size, var_0_1, var_0_0, 20, 20),
	craft_button = UIWidgets.create_console_craft_button("craft_button", "console_crafting_recipe_icon_properties"),
	material_text_1 = UIWidgets.create_craft_material_widget("material_text_1"),
	material_text_2 = UIWidgets.create_craft_material_widget("material_text_2"),
	material_text_3 = UIWidgets.create_craft_material_widget("material_text_3"),
	material_text_4 = UIWidgets.create_craft_material_widget("material_text_4"),
	material_text_5 = UIWidgets.create_craft_material_widget("material_text_5"),
	material_text_6 = UIWidgets.create_craft_material_widget("material_text_6"),
	material_text_7 = UIWidgets.create_craft_material_widget("material_text_7")
}
local var_0_7 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				local var_2_0 = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = var_2_0
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
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
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - var_5_0
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_6,
	scenegraph_definition = var_0_4,
	animation_definitions = var_0_7
}
