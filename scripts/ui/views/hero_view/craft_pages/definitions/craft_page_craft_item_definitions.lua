-- chunkname: @scripts/ui/views/hero_view/craft_pages/definitions/craft_page_craft_item_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local var_0_5 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local num = size[1] - (var_0_5 * 2 + 60)

NUM_CRAFT_SLOTS_X = 1
NUM_CRAFT_SLOTS_Y = 1
NUM_CRAFT_SLOTS = NUM_CRAFT_SLOTS_X * NUM_CRAFT_SLOTS_Y
NUM_RECIPE_SLOTS_X = 2
NUM_RECIPE_SLOTS_Y = 1
NUM_RECIPE_SLOTS = NUM_RECIPE_SLOTS_X * NUM_RECIPE_SLOTS_Y

local tbl = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	root_fit = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	menu_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = size,
		position = {
			0,
			0,
			1
		}
	},
	item_grid = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			186,
			186
		},
		position = {
			0,
			28,
			6
		}
	},
	item_grid_random_icon = {
		vertical_alignment = "center",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			37,
			62
		},
		position = {
			0,
			0,
			0
		}
	},
	recipe_grid = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1],
			80
		},
		position = {
			0,
			-160,
			6
		}
	},
	craft_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1] - 100,
			60
		},
		position = {
			0,
			20,
			35
		}
	},
	craft_bar_bg = {
		vertical_alignment = "top",
		parent = "craft_button",
		horizontal_alignment = "center",
		size = {
			400,
			6
		},
		position = {
			0,
			28,
			5
		}
	},
	craft_bar_fg = {
		vertical_alignment = "center",
		parent = "craft_bar_bg",
		horizontal_alignment = "center",
		size = {
			424,
			30
		},
		position = {
			4,
			-4,
			2
		}
	},
	craft_bar = {
		vertical_alignment = "center",
		parent = "craft_bar_bg",
		horizontal_alignment = "left",
		size = {
			400,
			6
		},
		position = {
			0,
			0,
			1
		}
	}
}
local flag = true
local tbl_2 = {
	item_grid_bg = UIWidgets.create_simple_texture("crafting_bg_02", "item_grid", nil, nil, nil, -1),
	item_grid_random_icon = UIWidgets.create_simple_texture("crafting_random", "item_grid_random_icon"),
	item_grid = UIWidgets.create_grid("item_grid", tbl.item_grid.size, NUM_CRAFT_SLOTS_Y, NUM_CRAFT_SLOTS_X, 20, 20),
	recipe_grid = UIWidgets.create_recipe_grid("recipe_grid", tbl.recipe_grid.size, NUM_RECIPE_SLOTS_Y, NUM_RECIPE_SLOTS_X, 30, 30),
	craft_button = UIWidgets.create_default_button("craft_button", tbl.craft_button.size, nil, nil, Localize("hero_view_crafting_craft"), 24, nil, "button_detail_02", nil, flag),
	craft_bar_fg = UIWidgets.create_simple_texture("crafting_bar_fg", "craft_bar_fg"),
	craft_bar_bg = UIWidgets.create_simple_rect("craft_bar_bg", {
		255,
		0,
		0,
		0
	}),
	craft_bar = UIWidgets.create_simple_texture("crafting_bar", "craft_bar", nil, nil, nil, 2)
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
