-- chunkname: @scripts/ui/views/hero_view/states/definitions/hero_view_state_loot_definitions.lua

local var_0_0 = UISettings.hero_panel_height
local var_0_1 = UISettings.console_menu_scenegraphs
local var_0_2 = UISettings.console_menu_rect_color
local var_0_3 = {
	520,
	600
}
local var_0_4 = IS_CONSOLE and 5 or 5
local var_0_5 = true
local var_0_6 = {
	screen = var_0_1.screen,
	area = var_0_1.area,
	area_left = var_0_1.area_left,
	area_right = var_0_1.area_right,
	area_divider = var_0_1.area_divider,
	bottom_panel = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			1920,
			79
		},
		position = {
			0,
			0,
			UILayer.default + 1
		}
	},
	dead_space_filler = {
		scale = "fit",
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
	chest_title = {
		vertical_alignment = "top",
		parent = "dead_space_filler",
		horizontal_alignment = "center",
		size = {
			1200,
			50
		},
		position = {
			0,
			-80,
			1
		}
	},
	chest_sub_title = {
		vertical_alignment = "top",
		parent = "chest_title",
		horizontal_alignment = "center",
		size = {
			1200,
			50
		},
		position = {
			0,
			-40,
			1
		}
	},
	chest_indicator_root = {
		vertical_alignment = "top",
		parent = "dead_space_filler",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			200,
			0
		}
	},
	arrow_root = {
		vertical_alignment = "top",
		parent = "dead_space_filler",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			200,
			0
		}
	},
	info_root = {
		vertical_alignment = "center",
		parent = "dead_space_filler",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	info_window = {
		vertical_alignment = "center",
		parent = "info_root",
		horizontal_alignment = "right",
		size = {
			300,
			576
		},
		position = {
			-70,
			0,
			1
		}
	},
	info_text_box = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			270,
			430
		},
		position = {
			0,
			-140,
			1
		}
	},
	info_title_text = {
		vertical_alignment = "top",
		parent = "info_text_box",
		horizontal_alignment = "center",
		size = {
			320,
			50
		},
		position = {
			0,
			70,
			1
		}
	},
	info_portrait_root = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	item_grid_root = {
		vertical_alignment = "center",
		parent = "dead_space_filler",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	item_window = {
		vertical_alignment = "center",
		parent = "item_grid_root",
		horizontal_alignment = "left",
		size = var_0_3,
		position = {
			50,
			0,
			10
		}
	},
	item_grid = {
		vertical_alignment = "center",
		parent = "item_window",
		horizontal_alignment = "center",
		size = {
			520,
			600
		},
		position = {
			0,
			0,
			1
		}
	},
	item_grid_title = {
		vertical_alignment = "top",
		parent = "item_window",
		horizontal_alignment = "center",
		size = {
			260,
			32
		},
		position = {
			0,
			-15,
			1
		}
	},
	page_text_area = {
		vertical_alignment = "bottom",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			334,
			60
		},
		position = {
			0,
			-25,
			3
		}
	},
	input_icon_previous = {
		vertical_alignment = "center",
		parent = "page_text_area",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-60,
			0,
			1
		}
	},
	input_icon_next = {
		vertical_alignment = "center",
		parent = "page_text_area",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			60,
			0,
			1
		}
	},
	input_arrow_next = {
		vertical_alignment = "center",
		parent = "input_icon_next",
		horizontal_alignment = "center",
		size = {
			19,
			27
		},
		position = {
			40,
			0,
			1
		}
	},
	input_arrow_previous = {
		vertical_alignment = "center",
		parent = "input_icon_previous",
		horizontal_alignment = "center",
		size = {
			19,
			27
		},
		position = {
			-40,
			0,
			1
		}
	},
	page_button_next = {
		vertical_alignment = "center",
		parent = "input_icon_next",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			20,
			0,
			1
		}
	},
	page_button_previous = {
		vertical_alignment = "center",
		parent = "input_icon_previous",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-20,
			0,
			1
		}
	},
	item_window_1 = {
		vertical_alignment = "center",
		parent = "item_grid_root",
		horizontal_alignment = "left",
		size = {
			270,
			180
		},
		position = {
			50,
			300,
			1
		}
	},
	item_grid_1 = {
		vertical_alignment = "center",
		parent = "item_window_1",
		horizontal_alignment = "center",
		size = {
			270,
			180
		},
		position = {
			0,
			0,
			1
		}
	},
	difficulty_icon_left_1 = {
		vertical_alignment = "center",
		parent = "item_window_1",
		horizontal_alignment = "left",
		size = {
			100,
			200
		},
		position = {
			-100,
			0,
			1
		}
	},
	difficulty_icon_right_1 = {
		vertical_alignment = "center",
		parent = "item_window_1",
		horizontal_alignment = "right",
		size = {
			100,
			200
		},
		position = {
			100,
			0,
			1
		}
	},
	item_window_2 = {
		vertical_alignment = "center",
		parent = "item_grid_root",
		horizontal_alignment = "left",
		size = {
			270,
			180
		},
		position = {
			50,
			100,
			1
		}
	},
	item_grid_2 = {
		vertical_alignment = "center",
		parent = "item_window_2",
		horizontal_alignment = "center",
		size = {
			270,
			180
		},
		position = {
			0,
			0,
			1
		}
	},
	difficulty_icon_left_2 = {
		vertical_alignment = "center",
		parent = "item_window_2",
		horizontal_alignment = "left",
		size = {
			100,
			200
		},
		position = {
			-100,
			0,
			1
		}
	},
	difficulty_icon_right_2 = {
		vertical_alignment = "center",
		parent = "item_window_2",
		horizontal_alignment = "right",
		size = {
			100,
			200
		},
		position = {
			100,
			0,
			1
		}
	},
	item_window_3 = {
		vertical_alignment = "center",
		parent = "item_grid_root",
		horizontal_alignment = "left",
		size = {
			270,
			180
		},
		position = {
			50,
			-100,
			1
		}
	},
	item_grid_3 = {
		vertical_alignment = "center",
		parent = "item_window_3",
		horizontal_alignment = "center",
		size = {
			270,
			180
		},
		position = {
			0,
			0,
			1
		}
	},
	difficulty_icon_left_3 = {
		vertical_alignment = "center",
		parent = "item_window_3",
		horizontal_alignment = "left",
		size = {
			100,
			200
		},
		position = {
			-100,
			0,
			1
		}
	},
	difficulty_icon_right_3 = {
		vertical_alignment = "center",
		parent = "item_window_3",
		horizontal_alignment = "right",
		size = {
			100,
			200
		},
		position = {
			100,
			0,
			1
		}
	},
	item_window_4 = {
		vertical_alignment = "center",
		parent = "item_grid_root",
		horizontal_alignment = "left",
		size = {
			270,
			180
		},
		position = {
			50,
			-300,
			1
		}
	},
	item_grid_4 = {
		vertical_alignment = "center",
		parent = "item_window_4",
		horizontal_alignment = "center",
		size = {
			270,
			180
		},
		position = {
			0,
			0,
			1
		}
	},
	difficulty_icon_left_4 = {
		vertical_alignment = "center",
		parent = "item_window_4",
		horizontal_alignment = "left",
		size = {
			100,
			200
		},
		position = {
			-100,
			0,
			1
		}
	},
	difficulty_icon_right_4 = {
		vertical_alignment = "center",
		parent = "item_window_4",
		horizontal_alignment = "right",
		size = {
			100,
			200
		},
		position = {
			100,
			0,
			1
		}
	},
	item_cap_warning_text = {
		vertical_alignment = "bottom",
		parent = "bottom_panel",
		horizontal_alignment = "center",
		size = {
			900,
			72
		},
		position = {
			0,
			235,
			10
		}
	},
	open_buttons_pivot = {
		vertical_alignment = "bottom",
		parent = "dead_space_filler",
		horizontal_alignment = "center",
		size = {
			0,
			70
		},
		position = {
			0,
			30,
			10
		}
	},
	open_button = {
		vertical_alignment = "bottom",
		parent = "open_buttons_pivot",
		horizontal_alignment = "right",
		size = {
			380,
			70
		},
		position = {
			-10,
			0,
			0
		}
	},
	open_multiple_button = {
		vertical_alignment = "bottom",
		parent = "open_buttons_pivot",
		horizontal_alignment = "left",
		size = {
			380,
			70
		},
		position = {
			10,
			0,
			0
		}
	},
	continue_button = {
		vertical_alignment = "bottom",
		parent = "dead_space_filler",
		horizontal_alignment = "center",
		size = {
			380,
			70
		},
		position = {
			0,
			-230,
			10
		}
	},
	close_button = {
		vertical_alignment = "bottom",
		parent = "dead_space_filler",
		horizontal_alignment = "right",
		size = {
			300,
			70
		},
		position = {
			-80,
			30,
			10
		}
	},
	debug_add_chest_5 = {
		vertical_alignment = "bottom",
		parent = "dead_space_filler",
		horizontal_alignment = "right",
		size = {
			450,
			70
		},
		position = {
			-20,
			480,
			2
		}
	},
	debug_add_chest_4 = {
		vertical_alignment = "bottom",
		parent = "dead_space_filler",
		horizontal_alignment = "right",
		size = {
			450,
			70
		},
		position = {
			-20,
			400,
			2
		}
	},
	debug_add_chest_3 = {
		vertical_alignment = "bottom",
		parent = "dead_space_filler",
		horizontal_alignment = "right",
		size = {
			450,
			70
		},
		position = {
			-20,
			320,
			2
		}
	},
	debug_add_chest_2 = {
		vertical_alignment = "bottom",
		parent = "dead_space_filler",
		horizontal_alignment = "right",
		size = {
			450,
			70
		},
		position = {
			-20,
			240,
			2
		}
	},
	debug_add_chest_1 = {
		vertical_alignment = "bottom",
		parent = "dead_space_filler",
		horizontal_alignment = "right",
		size = {
			450,
			70
		},
		position = {
			-20,
			160,
			2
		}
	},
	loot_options_root = {
		vertical_alignment = "center",
		parent = "dead_space_filler",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-30,
			1
		}
	},
	gamepad_chest_tooltip = {
		vertical_alignment = "top",
		parent = "item_window",
		horizontal_alignment = "left",
		size = {
			450,
			0
		},
		position = {
			475,
			-75,
			0
		}
	}
}

for iter_0_0 = 1, var_0_4 do
	local var_0_7 = (iter_0_0 - 1) * 3 + 1
	local var_0_8 = "loot_option_" .. var_0_7

	var_0_6[var_0_8] = {
		vertical_alignment = "center",
		parent = "loot_options_root",
		horizontal_alignment = "center",
		size = {
			364,
			0
		},
		position = {
			-600 + 1920 * (iter_0_0 - 1),
			0,
			1
		}
	}
	var_0_6[var_0_8 .. "_center"] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		parent = var_0_8,
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	}
	var_0_6["gamepad_tooltip_option_" .. var_0_7] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		parent = var_0_8,
		size = {
			450,
			0
		},
		position = {
			0,
			380,
			100
		}
	}

	local var_0_9 = (iter_0_0 - 1) * 3 + 2
	local var_0_10 = "loot_option_" .. var_0_9

	var_0_6[var_0_10] = {
		vertical_alignment = "center",
		parent = "loot_options_root",
		horizontal_alignment = "center",
		size = {
			364,
			0
		},
		position = {
			0 + 1920 * (iter_0_0 - 1),
			0,
			1
		}
	}
	var_0_6[var_0_10 .. "_center"] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		parent = var_0_10,
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	}
	var_0_6["gamepad_tooltip_option_" .. var_0_9] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		parent = var_0_10,
		size = {
			450,
			0
		},
		position = {
			0,
			380,
			100
		}
	}

	local var_0_11 = (iter_0_0 - 1) * 3 + 3
	local var_0_12 = "loot_option_" .. var_0_11

	var_0_6[var_0_12] = {
		vertical_alignment = "center",
		parent = "loot_options_root",
		horizontal_alignment = "center",
		size = {
			364,
			0
		},
		position = {
			600 + 1920 * (iter_0_0 - 1),
			0,
			1
		}
	}
	var_0_6[var_0_12 .. "_center"] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		parent = var_0_12,
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	}
	var_0_6["gamepad_tooltip_option_" .. var_0_11] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		parent = var_0_12,
		size = {
			450,
			0
		},
		position = {
			0,
			380,
			100
		}
	}
end

local var_0_13 = {
	{
		{
			0,
			0
		},
		{
			0,
			0
		},
		{
			0,
			0
		}
	},
	{
		{
			-300,
			0
		},
		{
			300,
			0
		},
		{
			0,
			0
		}
	},
	{
		{
			-600,
			0
		},
		{
			0,
			0
		},
		{
			600,
			0
		}
	}
}
local var_0_14 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 42,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_15 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_16 = {
	font_size = 36,
	upper_case = false,
	localize = false,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_17 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	use_shadow = true,
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_18 = {
	word_wrap = true,
	upper_case = false,
	localize = true,
	use_shadow = true,
	font_size = 18,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_19 = {
	word_wrap = true,
	font_size = 26,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		-172,
		4,
		2
	}
}
local var_0_20 = {
	word_wrap = true,
	font_size = 26,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		171,
		4,
		2
	}
}
local var_0_21 = {
	word_wrap = true,
	font_size = 26,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		4,
		2
	}
}
local var_0_22 = {
	word_wrap = false,
	font_size = 56,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		75,
		2
	}
}
local var_0_23 = {
	{
		description = "n/a",
		name = "loot",
		hero_specific_filter = true,
		display_name = Localize("hero_view_crafting_tokens"),
		icons = {
			selected = "tabs_icon_equipment_glow",
			normal = "tabs_icon_equipment"
		},
		contains_new_content = function ()
			return false
		end,
		slot_type = ItemType.LOOT_CHEST,
		item_filter = "slot_type == " .. ItemType.LOOT_CHEST
	}
}
local var_0_24 = {}

for iter_0_1, iter_0_2 in ipairs(var_0_23) do
	var_0_24[#var_0_24 + 1] = "tabs_icon_all_selected"
end

local var_0_25 = {
	scenegraph_id = "dead_space_filler",
	element = {
		passes = {
			{
				pass_type = "viewport",
				style_id = "viewport"
			},
			{
				pass_type = "hotspot",
				content_id = "button_hotspot"
			}
		}
	},
	style = {
		viewport = {
			scenegraph_id = "dead_space_filler",
			viewport_name = "chest_opening_viewport",
			level_name = "levels/end_screen/world",
			enable_sub_gui = false,
			fov = 120,
			world_name = "chest_opening",
			world_flags = {
				Application.DISABLE_SOUND,
				Application.DISABLE_ESRAM,
				Application.ENABLE_VOLUMETRICS
			},
			object_sets = {
				"flow_victory"
			},
			layer = UILayer.default,
			camera_position = {
				0,
				0,
				0
			},
			camera_lookat = {
				0,
				0,
				0
			}
		}
	},
	content = {
		button_hotspot = {}
	}
}
local var_0_26 = {
	scenegraph_id = "arrow_root",
	element = {
		passes = {
			{
				style_id = "button_hotspot",
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				pass_type = "texture",
				style_id = "arrow_lit",
				texture_id = "arrow_lit"
			},
			{
				pass_type = "texture",
				style_id = "arrow_unlit",
				texture_id = "arrow_unlit"
			}
		}
	},
	content = {
		arrow_unlit = "arrow_off_01",
		disable_with_gamepad = true,
		arrow_lit = "arrow_on",
		button_hotspot = {}
	},
	style = {
		button_hotspot = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = {
				58,
				62
			},
			offset = {
				0,
				0,
				0
			}
		},
		arrow_lit = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				58,
				62
			},
			offset = {
				0,
				0,
				1
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		arrow_unlit = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				58,
				62
			},
			offset = {
				0,
				0,
				0
			},
			color = {
				128,
				255,
				255,
				255
			}
		}
	},
	offset = {
		0,
		5,
		0
	}
}
local var_0_27 = {
	scenegraph_id = "arrow_root",
	element = {
		passes = {
			{
				style_id = "button_hotspot",
				pass_type = "hotspot",
				content_id = "button_hotspot"
			},
			{
				style_id = "arrow_lit",
				pass_type = "texture_uv",
				content_id = "arrow_lit"
			},
			{
				style_id = "arrow_unlit",
				pass_type = "texture_uv",
				content_id = "arrow_unlit"
			}
		}
	},
	content = {
		disable_with_gamepad = true,
		button_hotspot = {},
		arrow_lit = {
			texture_id = "arrow_on",
			uvs = {
				{
					1,
					0
				},
				{
					0,
					1
				}
			}
		},
		arrow_unlit = {
			texture_id = "arrow_off_01",
			uvs = {
				{
					1,
					0
				},
				{
					0,
					1
				}
			}
		}
	},
	style = {
		button_hotspot = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = {
				58,
				62
			},
			offset = {
				0,
				0,
				0
			}
		},
		arrow_lit = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				58,
				62
			},
			offset = {
				0,
				0,
				1
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		arrow_unlit = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				58,
				62
			},
			offset = {
				0,
				0,
				0
			},
			color = {
				128,
				255,
				255,
				255
			}
		}
	},
	offset = {
		0,
		5,
		0
	}
}

local function var_0_28(arg_2_0, arg_2_1)
	local var_2_0 = {
		element = {}
	}
	local var_2_1 = {
		{
			pass_type = "viewport",
			style_id = "viewport"
		},
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		}
	}
	local var_2_2 = {
		activated = true,
		button_hotspot = {}
	}
	local var_2_3 = {
		viewport = {
			layer = 990,
			shading_environment = "environment/blank_offscreen_chest_item",
			viewport_type = "default_forward",
			enable_sub_gui = false,
			fov = 65,
			world_name = arg_2_0,
			viewport_name = arg_2_0,
			camera_position = {
				0,
				0,
				0
			},
			camera_lookat = {
				0,
				0,
				0
			}
		}
	}

	var_2_0.element.passes = var_2_1
	var_2_0.content = var_2_2
	var_2_0.style = var_2_3
	var_2_0.offset = {
		0,
		0,
		0
	}
	var_2_0.scenegraph_id = arg_2_0

	return var_2_0
end

local function var_0_29(arg_3_0, arg_3_1)
	local var_3_0 = UIFrameSettings.menu_frame_09
	local var_3_1 = {
		element = {}
	}
	local var_3_2 = {
		{
			style_id = "button_hotspot",
			pass_type = "hotspot",
			content_id = "button_hotspot",
			content_check_function = function (arg_4_0)
				return not arg_4_0.parent.presentation_complete
			end
		},
		{
			style_id = "item_icon",
			pass_type = "hotspot",
			content_id = "item_hotspot",
			content_check_function = function (arg_5_0)
				return arg_5_0.parent.presentation_complete
			end
		},
		{
			pass_type = "hotspot",
			content_id = "item_hotspot_2",
			content_check_function = function (arg_6_0)
				return arg_6_0.parent.presentation_complete
			end
		},
		{
			style_id = "item_name",
			pass_type = "text",
			text_id = "item_name"
		},
		{
			style_id = "item_type",
			pass_type = "text",
			text_id = "item_type"
		},
		{
			style_id = "item_name_shadow",
			pass_type = "text",
			text_id = "item_name"
		},
		{
			style_id = "item_type_shadow",
			pass_type = "text",
			text_id = "item_type"
		},
		{
			item_id = "item",
			style_id = "item_tooltip",
			pass_type = "item_tooltip",
			content_check_function = function (arg_7_0)
				return (arg_7_0.item_hotspot.is_hover or arg_7_0.item_hotspot_2.is_hover) and arg_7_0.item
			end
		},
		{
			pass_type = "texture",
			style_id = "item_icon",
			texture_id = "item_icon"
		},
		{
			pass_type = "texture",
			style_id = "item_icon_frame",
			texture_id = "item_icon_frame"
		},
		{
			pass_type = "texture",
			style_id = "item_icon_rarity",
			texture_id = "item_icon_rarity"
		},
		{
			pass_type = "texture",
			style_id = "illusion_overlay",
			texture_id = "illusion_overlay",
			content_check_function = function (arg_8_0)
				local var_8_0 = arg_8_0.item

				if var_8_0 and var_8_0.skin then
					return var_8_0.data.item_type == "weapon_skin"
				end
			end
		},
		{
			pass_type = "texture",
			style_id = "illusion_icon",
			texture_id = "illusion_icon",
			content_check_function = function (arg_9_0)
				local var_9_0 = arg_9_0.item
				local var_9_1 = var_9_0 and var_9_0.skin

				if var_9_1 then
					return var_9_0.data.item_type ~= "weapon_skin" and WeaponSkins.default_skins[var_9_0.key] ~= var_9_1
				end
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame",
			content_check_function = function (arg_10_0)
				return arg_10_0.draw_frame
			end
		},
		{
			pass_type = "texture",
			style_id = "lock_bottom",
			texture_id = "lock_bottom"
		},
		{
			pass_type = "texture",
			style_id = "lock_top",
			texture_id = "lock_top"
		},
		{
			pass_type = "texture",
			style_id = "lock_top_shadow",
			texture_id = "lock_top_shadow"
		},
		{
			pass_type = "texture",
			style_id = "lock_bottom_shadow",
			texture_id = "lock_bottom_shadow"
		},
		{
			pass_type = "texture",
			style_id = "lock_bottom_glow",
			texture_id = "lock_bottom_glow"
		},
		{
			pass_type = "texture",
			style_id = "lock_bottom_glow_2",
			texture_id = "lock_bottom_glow_2"
		},
		{
			pass_type = "texture",
			style_id = "lock_glow",
			texture_id = "lock_glow"
		},
		{
			pass_type = "texture",
			style_id = "lock_glow_1",
			texture_id = "lock_glow_1"
		},
		{
			pass_type = "texture",
			style_id = "lock_glow_2",
			texture_id = "lock_glow_2"
		},
		{
			pass_type = "texture",
			style_id = "final_glow",
			texture_id = "final_glow"
		},
		{
			pass_type = "texture",
			style_id = "final_glow_1",
			texture_id = "final_glow_1"
		},
		{
			pass_type = "texture",
			style_id = "final_glow_2",
			texture_id = "final_glow_2"
		},
		{
			pass_type = "texture",
			style_id = "image",
			texture_id = "image",
			content_check_function = function (arg_11_0)
				return arg_11_0.image
			end
		},
		{
			style_id = "loading_icon",
			texture_id = "loading_icon",
			pass_type = "rotated_texture",
			content_check_function = function (arg_12_0)
				return arg_12_0.is_loading
			end,
			content_change_function = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				local var_13_0 = ((arg_13_1.progress or 0) + arg_13_3) % 1

				arg_13_1.angle = math.pow(2, math.smoothstep(var_13_0, 0, 1)) * (math.pi * 2)
				arg_13_1.progress = var_13_0
			end
		},
		{
			style_id = "amount_text",
			pass_type = "text",
			text_id = "amount_text",
			content_check_function = function (arg_14_0)
				return arg_14_0.amount_text
			end
		},
		{
			style_id = "amount_text_shadow",
			pass_type = "text",
			text_id = "amount_text",
			content_check_function = function (arg_15_0)
				return arg_15_0.amount_text
			end
		}
	}
	local var_3_3 = {
		loading_icon = "loot_loading",
		draw_frame = false,
		lock_glow_1 = "loot_presentation_glow_04",
		lock_glow = "loot_presentation_circle_glow_plentiful",
		final_glow_2 = "loot_presentation_glow_05",
		item_type = "n/a",
		lock_top = "loot_presentation_fg_01",
		lock_top_shadow = "loot_presentation_fg_01_fade",
		lock_bottom_shadow = "loot_presentation_fg_02_fade",
		illusion_overlay = "item_frame_illusion",
		lock_bottom = "loot_presentation_fg_02",
		item_icon = "icons_placeholder",
		illusion_icon = "item_applied_illusion_icon",
		lock_bottom_glow_2 = "loot_presentation_glow_01",
		item_icon_rarity = "icon_bg_plentiful",
		amount_text = "",
		final_glow_1 = "loot_presentation_glow_06",
		lock_bottom_glow = "loot_presentation_glow_02",
		item_icon_frame = "item_frame",
		final_glow = "loot_presentation_circle_glow_plentiful_large",
		item_name = "n/a",
		lock_glow_2 = "loot_presentation_glow_03",
		frame = var_3_0.texture,
		item_hotspot = {},
		item_hotspot_2 = {
			allow_multi_hover = true
		},
		button_hotspot = {
			hover_type = "circle"
		}
	}
	local var_3_4 = {
		button_hotspot = {
			size = {
				400,
				400
			},
			offset = {
				arg_3_1[1] / 2 - 200,
				arg_3_1[2] / 2 - 200,
				0
			}
		},
		frame = {
			size = {
				[2] = arg_3_1[2]
			},
			texture_size = var_3_0.texture_size,
			texture_sizes = var_3_0.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				2
			}
		},
		loading_icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			angle = 0,
			texture_size = {
				150,
				150
			},
			offset = {
				0,
				0,
				1
			},
			color = {
				255,
				255,
				255,
				255
			},
			scenegraph_id = "loot_option_" .. arg_3_0 .. "_center",
			pivot = {
				75,
				75
			}
		},
		image = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				364,
				364
			},
			offset = {
				0,
				0,
				1
			},
			color = {
				255,
				255,
				255,
				255
			},
			scenegraph_id = "loot_option_" .. arg_3_0 .. "_center"
		},
		amount_text = {
			font_size = 42,
			upper_case = false,
			localize = false,
			word_wrap = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				0,
				-100,
				3
			},
			scenegraph_id = "loot_option_" .. arg_3_0 .. "_center"
		},
		amount_text_shadow = {
			font_size = 42,
			upper_case = false,
			localize = false,
			word_wrap = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-102,
				2
			},
			scenegraph_id = "loot_option_" .. arg_3_0 .. "_center"
		},
		lock_top = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				364,
				364
			},
			offset = {
				0,
				182,
				13
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock_top_shadow = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				364,
				95
			},
			offset = {
				0,
				0,
				1
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock_bottom = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				364,
				364
			},
			offset = {
				0,
				-182,
				18
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock_bottom_shadow = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				364,
				95
			},
			offset = {
				0,
				0,
				1
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		lock_bottom_glow = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				93,
				88
			},
			offset = {
				0,
				-40,
				19
			},
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
				0,
				255,
				255,
				255
			}
		},
		lock_bottom_glow_2 = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				93,
				88
			},
			offset = {
				0,
				-40,
				20
			},
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
				0,
				255,
				255,
				255
			}
		},
		lock_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				600,
				600
			},
			offset = {
				0,
				0,
				21
			},
			color = {
				0,
				255,
				255,
				255
			},
			default_color = {
				0,
				255,
				255,
				255
			}
		},
		lock_glow_1 = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				408,
				408
			},
			offset = {
				0,
				0,
				22
			},
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
				0,
				255,
				255,
				255
			}
		},
		lock_glow_2 = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				408,
				408
			},
			offset = {
				0,
				0,
				23
			},
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
				0,
				255,
				255,
				255
			}
		},
		final_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				600,
				1000
			},
			offset = {
				0,
				0,
				21
			},
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
				0,
				255,
				255,
				255
			}
		},
		final_glow_1 = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				600,
				1000
			},
			offset = {
				0,
				0,
				22
			},
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
				0,
				255,
				255,
				255
			}
		},
		final_glow_2 = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				600,
				1000
			},
			offset = {
				0,
				0,
				23
			},
			color = {
				255,
				255,
				255,
				255
			},
			default_color = {
				0,
				255,
				255,
				255
			}
		},
		illusion_overlay = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				80,
				80
			},
			offset = {
				0,
				40,
				16
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		illusion_icon = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				20,
				20
			},
			offset = {
				22,
				-12,
				16
			},
			color = Colors.get_color_table_with_alpha("promo", 255)
		},
		item_icon_frame = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				80,
				80
			},
			offset = {
				0,
				40,
				17
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		item_icon = {
			size = {
				80,
				80
			},
			offset = {
				arg_3_1[1] / 2 - 40,
				-40,
				15
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		item_icon_rarity = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				80,
				80
			},
			offset = {
				0,
				40,
				14
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		item_name = {
			font_size = 30,
			upper_case = true,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("white", 0),
			size = {
				arg_3_1[1],
				50
			},
			offset = {
				0,
				arg_3_1[2] + 182 + 70,
				30
			}
		},
		item_name_shadow = {
			font_size = 30,
			upper_case = true,
			localize = false,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 0),
			size = {
				arg_3_1[1],
				50
			},
			offset = {
				2,
				arg_3_1[2] + 182 + 70 - 2,
				29
			}
		},
		item_type = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			localize = false,
			font_size = 26,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 0),
			size = {
				arg_3_1[1],
				50
			},
			offset = {
				0,
				arg_3_1[2] + 182,
				30
			}
		},
		item_type_shadow = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			localize = false,
			font_size = 26,
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 0),
			size = {
				arg_3_1[1],
				50
			},
			offset = {
				2,
				arg_3_1[2] + 182 - 2,
				29
			}
		},
		item_tooltip = {
			font_size = 18,
			max_width = 500,
			localize = true,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			line_colors = {
				Colors.get_color_table_with_alpha("font_title", 255),
				Colors.get_color_table_with_alpha("white", 255)
			},
			size = {
				80,
				80
			},
			offset = {
				arg_3_1[1] / 2 - 40,
				-40,
				4
			}
		}
	}

	var_3_1.element.passes = var_3_2
	var_3_1.content = var_3_3
	var_3_1.style = var_3_4
	var_3_1.offset = {
		0,
		0,
		0
	}
	var_3_1.scenegraph_id = "loot_option_" .. arg_3_0

	return var_3_1
end

local function var_0_30(arg_16_0, arg_16_1)
	return {
		element = {
			passes = {
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge_holder_right = "menu_frame_09_divider_right",
			edge_holder_left = "menu_frame_09_divider_left",
			bottom_edge = "menu_frame_09_divider"
		},
		style = {
			bottom_edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					5,
					0,
					6
				},
				size = {
					arg_16_1[1] - 10,
					5
				},
				texture_tiling_size = {
					arg_16_1[1] - 10,
					5
				}
			},
			edge_holder_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					3,
					-6,
					10
				},
				size = {
					9,
					17
				}
			},
			edge_holder_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_16_1[1] - 12,
					-6,
					10
				},
				size = {
					9,
					17
				}
			}
		},
		scenegraph_id = arg_16_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_31(arg_17_0, arg_17_1)
	return {
		element = {
			passes = {
				{
					texture_id = "edge",
					style_id = "edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_top",
					style_id = "edge_holder_top",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_bottom",
					style_id = "edge_holder_bottom",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge = "menu_frame_09_divider_vertical",
			edge_holder_top = "menu_frame_09_divider_top",
			edge_holder_bottom = "menu_frame_09_divider_bottom"
		},
		style = {
			edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					6,
					6
				},
				size = {
					5,
					arg_17_1[2] - 9
				},
				texture_tiling_size = {
					5,
					arg_17_1[2] - 9
				}
			},
			edge_holder_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-6,
					arg_17_1[2] - 7,
					10
				},
				size = {
					17,
					9
				}
			},
			edge_holder_bottom = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-6,
					3,
					10
				},
				size = {
					17,
					9
				}
			}
		},
		scenegraph_id = arg_17_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_32(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = 20
	local var_18_1 = 40
	local var_18_2 = var_18_1 / 5
	local var_18_3 = RaritySettings[arg_18_2].color
	local var_18_4 = RaritySettings[arg_18_3]
	local var_18_5 = var_18_4 and var_18_4.color
	local var_18_6 = RaritySettings[arg_18_4]
	local var_18_7 = var_18_6 and var_18_6.color
	local var_18_8 = arg_18_0 == arg_18_1

	return {
		scenegraph_id = "chest_indicator_root",
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "indicator_selected",
					texture_id = "dot_lit",
					content_check_function = function (arg_19_0)
						return arg_19_0.selected
					end
				},
				{
					pass_type = "texture",
					style_id = "indicator_unselected",
					texture_id = "dot_unlit",
					content_check_function = function (arg_20_0)
						return not arg_20_0.selected
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_hover_id",
					texture_id = "dot_lit",
					content_check_function = function (arg_21_0)
						return not arg_21_0.selected
					end
				},
				{
					pass_type = "texture",
					style_id = "rarity_a",
					texture_id = "rarity_icon"
				},
				{
					pass_type = "texture",
					style_id = "rarity_b",
					texture_id = "rarity_icon",
					content_check_function = function (arg_22_0)
						return var_18_4
					end
				},
				{
					pass_type = "texture",
					style_id = "rarity_c",
					texture_id = "rarity_icon",
					content_check_function = function (arg_23_0)
						return var_18_6
					end
				}
			}
		},
		content = {
			dot_unlit = "dot_off_01",
			dot_lit = "dot_on",
			rarity_icon = "loot_indicator_rarity",
			button_hotspot = {},
			index = arg_18_0,
			selected = var_18_8
		},
		style = {
			button_hotspot = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				area_size = {
					60,
					60
				},
				offset = {
					0,
					-5,
					0
				}
			},
			indicator_selected = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					6
				},
				texture_size = {
					60,
					60
				}
			},
			indicator_unselected = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					128,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					6
				},
				texture_size = {
					60,
					60
				}
			},
			texture_hover_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					6
				},
				texture_size = {
					60,
					60
				}
			},
			rarity_a = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				color = var_18_3,
				offset = {
					-var_18_2 * 2,
					-var_18_1,
					6
				},
				texture_size = {
					18,
					18
				}
			},
			rarity_b = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				color = var_18_5,
				offset = {
					0,
					-var_18_1,
					6
				},
				texture_size = {
					18,
					18
				}
			},
			rarity_c = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				color = var_18_7,
				offset = {
					var_18_2 * 2,
					-var_18_1,
					6
				},
				texture_size = {
					18,
					18
				}
			}
		},
		offset = {
			(arg_18_0 - 1) * (var_18_0 + var_18_1),
			0,
			0
		}
	}
end

local var_0_33 = true
local var_0_34 = {
	chest_title = UIWidgets.create_simple_text("chest_title", "chest_title", nil, nil, var_0_14),
	chest_sub_title = UIWidgets.create_simple_text("chest_sub_title", "chest_sub_title", nil, nil, var_0_15),
	info_text_title = UIWidgets.create_simple_text("n/a", "info_title_text", nil, nil, var_0_17),
	info_text_box = UIWidgets.create_simple_text("loot_opening_screen_desc", "info_text_box", nil, nil, var_0_18),
	info_window = UIWidgets.create_rect_with_outer_frame("info_window", var_0_6.info_window.size, nil, nil, Colors.get_color_table_with_alpha("console_menu_rect", 210)),
	item_grid_title = UIWidgets.create_simple_text(string.upper(Localize("hero_window_loot_crates")), "item_grid_title", nil, nil, var_0_22),
	title_top_divider = UIWidgets.create_simple_texture("divider_01_top", "item_grid_title"),
	item_grid = UIWidgets.create_grid("item_grid", var_0_6.item_grid.size, 5, 4, 16, 16, false),
	page_button_next = UIWidgets.create_arrow_button("page_button_next", math.pi),
	page_button_previous = UIWidgets.create_arrow_button("page_button_previous"),
	input_icon_next = UIWidgets.create_simple_texture("xbone_button_icon_a", "input_icon_next"),
	input_icon_previous = UIWidgets.create_simple_texture("xbone_button_icon_a", "input_icon_previous"),
	input_arrow_next = UIWidgets.create_simple_uv_texture("settings_arrow_normal", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "input_arrow_next"),
	input_arrow_previous = UIWidgets.create_simple_texture("settings_arrow_normal", "input_arrow_previous"),
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, var_0_21),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_19),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_20),
	page_text_area = UIWidgets.create_simple_texture("tab_menu_bg_03", "page_text_area"),
	open_button = UIWidgets.create_default_button("open_button", var_0_6.open_button.size, nil, nil, Localize("interaction_action_open") .. " 1", 32, "green", nil, nil, var_0_33, false),
	open_multiple_button = UIWidgets.create_default_button("open_multiple_button", var_0_6.open_multiple_button.size, nil, nil, Localize("interaction_action_open") .. " 5", 32, "green", nil, nil, var_0_33, true),
	close_button = UIWidgets.create_default_button("close_button", var_0_6.close_button.size, nil, nil, Localize("interaction_action_close"), 32, nil, nil, nil, var_0_33, true),
	item_cap_warning_text = {
		scenegraph_id = "item_cap_warning_text",
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "background"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				}
			}
		},
		content = {
			text = Localize("item_cap_warning_text")
		},
		style = {
			background = {
				color = {
					200,
					0,
					0,
					0
				}
			},
			text = var_0_16
		}
	}
}
local var_0_35 = {
	bottom_panel = UIWidgets.create_simple_uv_texture("menu_panel_bg", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_panel", nil, nil, var_0_2)
}
local var_0_36 = {
	"skin_applied",
	"deed_mission",
	"deed_difficulty",
	"mutators",
	"deed_rewards",
	"ammunition",
	"fatigue",
	"item_power_level",
	"properties",
	"traits",
	"weapon_skin_title",
	"item_information_text",
	"loot_chest_difficulty",
	"loot_chest_power_range",
	"unwieldable",
	"console_keywords",
	"console_item_description",
	"light_attack_stats",
	"heavy_attack_stats",
	"detailed_stats_light",
	"detailed_stats_heavy",
	"detailed_stats_push",
	"detailed_stats_ranged_light",
	"detailed_stats_ranged_heavy",
	"console_item_background"
}
local var_0_37 = {}

for iter_0_3 = 1, var_0_4 do
	var_0_37["item_tooltip_" .. (iter_0_3 - 1) * 3 + 1] = UIWidgets.create_simple_item_presentation("gamepad_tooltip_option_" .. (iter_0_3 - 1) * 3 + 1, var_0_36)
	var_0_37["item_tooltip_" .. (iter_0_3 - 1) * 3 + 2] = UIWidgets.create_simple_item_presentation("gamepad_tooltip_option_" .. (iter_0_3 - 1) * 3 + 2, var_0_36)
	var_0_37["item_tooltip_" .. (iter_0_3 - 1) * 3 + 3] = UIWidgets.create_simple_item_presentation("gamepad_tooltip_option_" .. (iter_0_3 - 1) * 3 + 3, var_0_36)
end

local var_0_38 = {
	"console_item_titles",
	"item_information_text",
	"loot_chest_difficulty",
	"loot_chest_power_range",
	"item_rarity_rate",
	"console_keywords",
	"console_item_description",
	"console_item_background"
}

var_0_37.chest_tooltip = UIWidgets.create_simple_item_presentation("gamepad_chest_tooltip", var_0_38)

local var_0_39 = {}

for iter_0_4 = 1, var_0_4 do
	var_0_39["loot_background_" .. (iter_0_4 - 1) * 3 + 1] = UIWidgets.create_background("loot_option_" .. (iter_0_4 - 1) * 3 + 1, var_0_6["loot_option_" .. (iter_0_4 - 1) * 3 + 1].size, "item_tooltip_background_old")
	var_0_39["loot_background_" .. (iter_0_4 - 1) * 3 + 2] = UIWidgets.create_background("loot_option_" .. (iter_0_4 - 1) * 3 + 2, var_0_6["loot_option_" .. (iter_0_4 - 1) * 3 + 2].size, "item_tooltip_background_old")
	var_0_39["loot_background_" .. (iter_0_4 - 1) * 3 + 3] = UIWidgets.create_background("loot_option_" .. (iter_0_4 - 1) * 3 + 3, var_0_6["loot_option_" .. (iter_0_4 - 1) * 3 + 3].size, "item_tooltip_background_old")
end

local var_0_40 = {}

for iter_0_5 = 1, var_0_4 do
	var_0_40["loot_option_" .. (iter_0_5 - 1) * 3 + 1] = var_0_29((iter_0_5 - 1) * 3 + 1, var_0_6["loot_option_" .. (iter_0_5 - 1) * 3 + 1].size)
	var_0_40["loot_option_" .. (iter_0_5 - 1) * 3 + 2] = var_0_29((iter_0_5 - 1) * 3 + 2, var_0_6["loot_option_" .. (iter_0_5 - 1) * 3 + 2].size)
	var_0_40["loot_option_" .. (iter_0_5 - 1) * 3 + 3] = var_0_29((iter_0_5 - 1) * 3 + 3, var_0_6["loot_option_" .. (iter_0_5 - 1) * 3 + 3].size)
end

local var_0_41 = {}

if var_0_5 then
	var_0_41.loot_option_1 = var_0_28("loot_option_1", var_0_6.loot_option_1.size)
	var_0_41.loot_option_2 = var_0_28("loot_option_2", var_0_6.loot_option_2.size)
	var_0_41.loot_option_3 = var_0_28("loot_option_3", var_0_6.loot_option_3.size)
else
	for iter_0_6 = 1, var_0_4 do
		var_0_41["loot_option_" .. (iter_0_6 - 1) * 3 + 1] = var_0_28("loot_option_" .. (iter_0_6 - 1) * 3 + 1, var_0_6["loot_option_" .. (iter_0_6 - 1) * 3 + 1].size)
		var_0_41["loot_option_" .. (iter_0_6 - 1) * 3 + 2] = var_0_28("loot_option_" .. (iter_0_6 - 1) * 3 + 2, var_0_6["loot_option_" .. (iter_0_6 - 1) * 3 + 2].size)
		var_0_41["loot_option_" .. (iter_0_6 - 1) * 3 + 3] = var_0_28("loot_option_" .. (iter_0_6 - 1) * 3 + 3, var_0_6["loot_option_" .. (iter_0_6 - 1) * 3 + 3].size)
	end
end

local var_0_42 = {
	arrow_right = var_0_26,
	arrow_left = var_0_27
}
local var_0_43 = UIWidgets.create_default_button("continue_button", var_0_6.continue_button.size, nil, nil, Localize("continue"), 32, nil, nil, nil, var_0_33)
local var_0_44 = {
	debug_add_chest_1 = UIWidgets.create_default_button("debug_add_chest_1", var_0_6.debug_add_chest_1.size, nil, nil, "DEBUG: Normal Chest", nil, "green"),
	debug_add_chest_2 = UIWidgets.create_default_button("debug_add_chest_2", var_0_6.debug_add_chest_2.size, nil, nil, "DEBUG: Hard Chest", nil, "green"),
	debug_add_chest_3 = UIWidgets.create_default_button("debug_add_chest_3", var_0_6.debug_add_chest_3.size, nil, nil, "DEBUG: Nightmare Chest", nil, "green"),
	debug_add_chest_4 = UIWidgets.create_default_button("debug_add_chest_4", var_0_6.debug_add_chest_4.size, nil, nil, "DEBUG: Cataclysm Chest", nil, "green")
}
local var_0_45 = {
	default = {},
	chest_selected_single_use = {
		actions = {
			{
				input_action = "d_pad",
				priority = 1,
				description_text = "input_description_navigate",
				ignore_keybinding = true
			},
			{
				input_action = "confirm",
				priority = 2,
				ignore_localization = true,
				description_text = Localize("interaction_action_open")
			},
			{
				input_action = "special_1",
				priority = 3,
				description_text = "input_description_tooltip"
			},
			{
				input_action = "back",
				priority = 4,
				description_text = "input_description_close"
			}
		}
	},
	chest_selected = {
		actions = {
			{
				input_action = "d_pad",
				priority = 1,
				description_text = "input_description_navigate",
				ignore_keybinding = true
			},
			{
				input_action = "confirm",
				priority = 2,
				ignore_localization = true,
				description_text = Localize("interaction_action_open") .. " 1"
			},
			{
				input_action = "refresh",
				priority = 3,
				ignore_localization = true,
				description_text = Localize("interaction_action_open") .. " 5"
			},
			{
				input_action = "special_1",
				priority = 4,
				description_text = "input_description_tooltip"
			},
			{
				input_action = "back",
				priority = 5,
				description_text = "input_description_close"
			}
		}
	},
	chest_not_selected = {
		actions = {
			{
				input_action = "d_pad",
				priority = 1,
				description_text = "input_description_navigate",
				ignore_keybinding = true
			},
			{
				input_action = "back",
				priority = 2,
				description_text = "input_description_close"
			}
		}
	},
	chest_not_selected = {
		actions = {
			{
				input_action = "d_pad",
				priority = 1,
				description_text = "input_description_navigate",
				ignore_keybinding = true
			},
			{
				input_action = "back",
				priority = 2,
				description_text = "input_description_close"
			}
		}
	},
	chest_opened = {
		actions = {
			{
				input_action = "d_horizontal",
				priority = 1,
				description_text = "input_description_select",
				ignore_keybinding = true
			},
			{
				input_action = "confirm",
				priority = 1,
				description_text = "input_description_open"
			},
			{
				input_action = "special_1",
				priority = 2,
				description_text = "input_description_tooltip"
			},
			{
				input_action = "back",
				priority = 3,
				description_text = "input_description_back"
			}
		}
	},
	chest_opened_pages = {
		actions = {
			{
				input_action = "d_horizontal",
				priority = 1,
				description_text = "input_description_select",
				ignore_keybinding = true
			},
			{
				input_action = "confirm",
				priority = 1,
				description_text = "input_description_open"
			},
			{
				input_action = "special_1",
				priority = 2,
				description_text = "input_description_tooltip"
			},
			{
				input_action = "trigger_cycle_previous",
				priority = 3,
				description_text = "input_description_prev_page"
			},
			{
				input_action = "trigger_cycle_next",
				priority = 4,
				description_text = "input_description_next_page"
			},
			{
				input_action = "back",
				priority = 5,
				description_text = "input_description_back"
			}
		}
	},
	loot_presented = {
		actions = {
			{
				input_action = "special_1",
				priority = 1,
				description_text = "input_description_tooltip"
			},
			{
				input_action = "back",
				priority = 2,
				description_text = "input_description_back"
			}
		}
	},
	loot_presented_pages = {
		actions = {
			{
				input_action = "special_1",
				priority = 1,
				description_text = "input_description_tooltip"
			},
			{
				input_action = "trigger_cycle_previous",
				priority = 2,
				description_text = "input_description_prev_page"
			},
			{
				input_action = "trigger_cycle_next",
				priority = 3,
				description_text = "input_description_next_page"
			},
			{
				input_action = "back",
				priority = 4,
				description_text = "input_description_back"
			}
		}
	}
}
local var_0_46 = {
	open_loot_widget = {
		{
			name = "rumble",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				local var_24_0 = arg_24_3.wwise_world

				WwiseWorld.trigger_event(var_24_0, "play_gui_chest_reward_rumble")
			end,
			update = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				local var_25_0 = math.easeOutCubic(arg_25_3)
				local var_25_1 = math.bounce(arg_25_3)
				local var_25_2 = arg_25_2.content
				local var_25_3 = arg_25_2.style
				local var_25_4 = arg_25_2.offset
				local var_25_5 = arg_25_1[arg_25_2.scenegraph_id].size

				var_25_4[1] = 5 - 5 * math.catmullrom(var_25_1, 10, 1, 1, -1)
				var_25_4[2] = 5 - 5 * math.catmullrom(var_25_1, -1, 1, 1, 10)
			end,
			on_complete = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				return
			end
		},
		{
			name = "glow_exit",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				return
			end,
			update = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				local var_28_0 = math.easeOutCubic(arg_28_3)
				local var_28_1 = arg_28_2.content
				local var_28_2 = arg_28_2.style

				var_28_2.lock_bottom_glow.color[1] = math.max(var_28_2.lock_bottom_glow.color[1], var_28_2.lock_bottom_glow.default_color[1] * var_28_0)
				var_28_2.lock_bottom_glow_2.color[1] = math.max(var_28_2.lock_bottom_glow_2.color[1], var_28_2.lock_bottom_glow_2.default_color[1] * var_28_0)
				var_28_2.lock_glow.color[1] = math.min(var_28_2.lock_glow.color[1], var_28_2.lock_glow.default_color[1] * (1 - var_28_0))
				var_28_2.lock_glow_1.color[1] = math.min(var_28_2.lock_glow_1.color[1], var_28_2.lock_glow_1.default_color[1] * (1 - var_28_0))
				var_28_2.lock_glow_2.color[1] = math.min(var_28_2.lock_glow_2.color[1], var_28_2.lock_glow_2.default_color[1] * (1 - var_28_0))
			end,
			on_complete = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				return
			end
		},
		{
			name = "open",
			start_progress = 0.3,
			end_progress = 0.6,
			init = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				return
			end,
			update = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
				if not arg_31_4.played_open_sound then
					local var_31_0 = arg_31_4.wwise_world

					WwiseWorld.trigger_event(var_31_0, "play_gui_chest_reward_open")

					arg_31_4.played_open_sound = true
				end

				local var_31_1 = math.easeInCubic(arg_31_3)
				local var_31_2 = arg_31_2.content
				local var_31_3 = arg_31_2.style
				local var_31_4 = arg_31_2.scenegraph_id
				local var_31_5 = arg_31_1[var_31_4].size
				local var_31_6 = var_31_1 * 400

				arg_31_0[var_31_4].size[2] = var_31_6

				local var_31_7 = arg_31_4.reward_option
				local var_31_8 = var_31_7.background_widget.content.background
				local var_31_9 = var_31_8.uvs
				local var_31_10 = var_31_8.texture_id
				local var_31_11 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_31_10)

				var_31_9[2][2] = math.min(var_31_6 / var_31_11.size[2], 1)
				var_31_3.item_name.offset[2] = var_31_6 + 182 + 35
				var_31_3.item_name_shadow.offset[2] = var_31_3.item_name.offset[2] - 2
				var_31_3.item_type.offset[2] = var_31_6 + 182 - 5
				var_31_3.item_type_shadow.offset[2] = var_31_3.item_type.offset[2] - 2
				var_31_3.item_icon.offset[2] = var_31_6 - 40
				var_31_3.item_tooltip.offset[2] = var_31_6 - 40
				var_31_2.draw_frame = true

				local var_31_12 = var_31_3.frame

				var_31_12.size[2] = var_31_6 + 20
				var_31_12.offset[2] = -10
				var_31_7.opened = true
			end,
			on_complete = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				local var_32_0 = true
				local var_32_1 = arg_32_3.reward_option
				local var_32_2 = var_32_1.item_previewer
				local var_32_3 = var_32_1.reward_key

				if var_32_2 and var_32_3 then
					var_32_2:present_item(var_32_3)
				end

				local var_32_4 = var_32_1.world_previewer

				if var_32_4 then
					var_32_4:force_unhide_character()
				end

				var_32_1.presentation_complete = var_32_0
				arg_32_2.content.presentation_complete = var_32_0

				if not arg_32_3.played_opened_sound then
					local var_32_5 = arg_32_3.wwise_world

					WwiseWorld.trigger_event(var_32_5, "play_gui_chest_reward_opened")

					arg_32_3.played_opened_sound = true
				end
			end
		},
		{
			name = "glow_enter",
			start_progress = 0.6,
			end_progress = 0.8,
			init = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				return
			end,
			update = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
				local var_34_0 = math.easeOutCubic(arg_34_3)
				local var_34_1 = arg_34_2.content
				local var_34_2 = arg_34_2.style

				var_34_2.final_glow.color[1] = math.max(var_34_2.final_glow.color[1], var_34_2.final_glow.default_color[1] * var_34_0)
				var_34_2.final_glow_1.color[1] = math.max(var_34_2.final_glow_1.color[1], var_34_2.final_glow_1.default_color[1] * var_34_0)
				var_34_2.final_glow_2.color[1] = math.max(var_34_2.final_glow_2.color[1], var_34_2.final_glow_2.default_color[1] * var_34_0)
			end,
			on_complete = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
				return
			end
		},
		{
			name = "fade_in_text",
			start_progress = 0.8,
			end_progress = 1.2,
			init = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				return
			end,
			update = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
				local var_37_0 = math.easeOutCubic(arg_37_3)
				local var_37_1 = arg_37_2.content
				local var_37_2 = arg_37_2.style
				local var_37_3 = 255 * var_37_0

				var_37_2.item_name.text_color[1] = var_37_3
				var_37_2.item_name_shadow.text_color[1] = var_37_3
				var_37_2.item_type.text_color[1] = var_37_3
				var_37_2.item_type_shadow.text_color[1] = var_37_3
			end,
			on_complete = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3)
				return
			end
		}
	},
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				arg_39_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
				local var_40_0 = math.easeOutCubic(arg_40_3)

				arg_40_4.render_settings.alpha_multiplier = var_40_0
			end,
			on_complete = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				arg_42_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
				local var_43_0 = math.easeOutCubic(arg_43_3)

				arg_43_4.render_settings.alpha_multiplier = 1 - var_43_0
			end,
			on_complete = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				return
			end
		}
	}
}

return {
	USE_DELAYED_SPAWN = var_0_5,
	arrow_widgets = var_0_42,
	create_chest_indicator_func = var_0_32,
	num_loot_options = var_0_4,
	loot_option_positions_by_amount = var_0_13,
	gamepad_tooltip_widgets = var_0_37,
	input_description_widgets = var_0_35,
	widgets = var_0_34,
	option_widgets = var_0_40,
	debug_button_widgets = var_0_44,
	option_background_widgets = var_0_39,
	preview_widgets = var_0_41,
	viewport_widget = var_0_25,
	continue_button = var_0_43,
	settings_by_screen = var_0_23,
	generic_input_actions = var_0_45,
	scenegraph_definition = var_0_6,
	animation_definitions = var_0_46,
	background_fade_definition = UIWidgets.create_simple_rect("dead_space_filler", {
		0,
		5,
		5,
		5
	})
}
