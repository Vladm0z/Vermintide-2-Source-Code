-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_loadout_pose_inventory_console_definitions.lua

local var_0_0 = UISettings.console_menu_scenegraphs
local var_0_1 = {
	screen = var_0_0.screen,
	area = var_0_0.area,
	area_left = var_0_0.area_left,
	area_right = var_0_0.area_right,
	area_divider = var_0_0.area_divider,
	item_tooltip = {
		vertical_alignment = "top",
		parent = "area_right",
		horizontal_alignment = "left",
		size = {
			400,
			0
		},
		position = {
			-60,
			-90,
			0
		}
	},
	item_tooltip_compare = {
		vertical_alignment = "top",
		parent = "item_tooltip",
		horizontal_alignment = "left",
		size = {
			400,
			0
		},
		position = {
			440,
			0,
			0
		}
	},
	item_grid = {
		vertical_alignment = "top",
		parent = "area_left",
		horizontal_alignment = "center",
		size = {
			520,
			690
		},
		position = {
			-9,
			-100,
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
			0,
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
	illusions_divider = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			700,
			21
		},
		position = {
			0,
			236,
			2
		}
	},
	illusions_title = {
		vertical_alignment = "bottom",
		parent = "illusions_divider",
		horizontal_alignment = "center",
		size = {
			650,
			40
		},
		position = {
			0,
			0,
			2
		}
	},
	illusions_name = {
		vertical_alignment = "bottom",
		parent = "illusions_divider",
		horizontal_alignment = "center",
		size = {
			650,
			40
		},
		position = {
			0,
			-90,
			2
		}
	},
	illusions_root = {
		vertical_alignment = "bottom",
		parent = "illusions_divider",
		horizontal_alignment = "center",
		size = {
			51,
			45
		},
		position = {
			0,
			-50,
			2
		}
	},
	apply_illusion_button_anchor = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			400,
			72
		},
		position = {
			0,
			70,
			5
		}
	},
	apply_illusion_button = {
		vertical_alignment = "bottom",
		parent = "apply_illusion_button_anchor",
		horizontal_alignment = "center",
		size = {
			400,
			72
		},
		position = {
			0,
			0,
			0
		}
	},
	button_remove = {
		vertical_alignment = "bottom",
		parent = "item_grid",
		horizontal_alignment = "left",
		size = {
			214,
			60
		},
		position = {
			153,
			-80,
			0
		}
	}
}
local var_0_2 = {
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
local var_0_3 = {
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
local var_0_4 = {
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
local var_0_5 = {
	font_size = 28,
	upper_case = true,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_6 = {
	font_size = 28,
	upper_case = false,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_7 = {
	font_size = 32,
	upper_case = false,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_8 = {
	{
		wield = true,
		name = "hats",
		item_filter = "slot_type == hat",
		hero_specific_filter = true,
		display_name = Localize("inventory_screen_hats_title"),
		item_types = {
			"hat"
		},
		icon = UISettings.slot_icons.hat
	},
	{
		wield = true,
		name = "skin",
		item_filter = "slot_type == skin",
		hero_specific_filter = true,
		display_name = Localize("inventory_screen_skins_title"),
		item_types = {
			"skin"
		},
		icon = UISettings.slot_icons.skins
	},
	{
		name = "frames",
		item_filter = "slot_type == frame",
		hero_specific_filter = true,
		display_name = Localize("inventory_screen_frames_title"),
		item_types = {
			"frame"
		},
		icon = UISettings.slot_icons.portrait_frame
	},
	{
		name = "poses",
		item_filter = "gather_weapon_pose_blueprints",
		hero_specific_filter = true,
		display_name = Localize("inventory_screen_poses_title"),
		item_types = {
			"weapon_pose"
		},
		icon = UISettings.slot_icons.portrait_frame
	}
}

function create_button(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9, arg_1_10)
	arg_1_3 = arg_1_3 or "button_bg_01"

	local var_1_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_1_3)
	local var_1_1 = arg_1_2 and UIFrameSettings[arg_1_2] or UIFrameSettings.button_frame_01
	local var_1_2 = var_1_1.texture_sizes.corner[1]
	local var_1_3 = arg_1_7 or "button_detail_01"
	local var_1_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_3).size
	local var_1_5
	local var_1_6

	if arg_1_8 then
		if type(arg_1_8) == "table" then
			var_1_5 = arg_1_8[1]
			var_1_6 = arg_1_8[2]
		else
			var_1_5 = arg_1_8
		end
	end

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame",
					content_check_function = function (arg_2_0)
						return arg_2_0.draw_frame
					end
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (arg_3_0)
						return arg_3_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function (arg_4_0)
						return not arg_4_0.skip_side_detail
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function (arg_5_0)
						return not arg_5_0.skip_side_detail
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_6_0)
						return not arg_6_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_7_0)
						return arg_7_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				}
			}
		},
		content = {
			draw_frame = true,
			hover_glow = "button_state_default",
			glass = "button_glass_02",
			background_fade = "button_bg_fade",
			side_detail = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = var_1_3,
				skip_side_detail = arg_1_10
			},
			button_hotspot = {},
			title_text = arg_1_4 or "n/a",
			frame = var_1_1.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_1_1[2] / var_1_0.size[2]
					},
					{
						arg_1_1[1] / var_1_0.size[1],
						1
					}
				},
				texture_id = arg_1_3
			},
			disable_with_gamepad = arg_1_9
		},
		style = {
			background = {
				color = {
					255,
					150,
					150,
					150
				},
				offset = {
					0,
					0,
					0
				}
			},
			background_fade = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					var_1_2,
					var_1_2 - 2,
					2
				},
				size = {
					arg_1_1[1] - var_1_2 * 2,
					arg_1_1[2] - var_1_2 * 2
				}
			},
			hover_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					var_1_2 - 2,
					3
				},
				size = {
					arg_1_1[1],
					math.min(arg_1_1[2] - 5, 80)
				}
			},
			clicked_rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				}
			},
			disabled_rect = {
				color = {
					150,
					20,
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			},
			title_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_1_5 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_1_1[1] - 40,
					arg_1_1[2]
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_1_5 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				size = {
					arg_1_1[1] - 40,
					arg_1_1[2]
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_1_5 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					arg_1_1[1] - 40,
					arg_1_1[2]
				},
				offset = {
					22,
					-2,
					5
				}
			},
			frame = {
				texture_size = var_1_1.texture_size,
				texture_sizes = var_1_1.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					8
				}
			},
			glass_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_1_1[2] - (var_1_2 + 11),
					4
				},
				size = {
					arg_1_1[1],
					11
				}
			},
			glass_bottom = {
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					0,
					var_1_2 - 9,
					4
				},
				size = {
					arg_1_1[1],
					11
				}
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_1_5 and -var_1_5 or -9,
					arg_1_1[2] / 2 - var_1_4[2] / 2 + (var_1_6 or 0),
					9
				},
				size = {
					var_1_4[1],
					var_1_4[2]
				}
			},
			side_detail_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_1_1[1] - var_1_4[1] + (var_1_5 or 9),
					arg_1_1[2] / 2 - var_1_4[2] / 2 + (var_1_6 or 0),
					9
				},
				size = {
					var_1_4[1],
					var_1_4[2]
				}
			}
		},
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_9()
	return {
		scenegraph_id = "illusions_root",
		element = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "icon_texture",
					texture_id = "icon_texture"
				},
				{
					pass_type = "texture",
					style_id = "hover_texture",
					texture_id = "hover_texture",
					content_check_function = function (arg_9_0)
						local var_9_0 = arg_9_0.button_hotspot

						return (var_9_0.is_hover or var_9_0.is_selected) and not arg_9_0.equipped
					end
				},
				{
					pass_type = "texture",
					style_id = "equipped_texture",
					texture_id = "equipped_texture",
					content_check_function = function (arg_10_0)
						return arg_10_0.equipped
					end
				}
			}
		},
		content = {
			hover_texture = "button_illusion_glow_white",
			locked = false,
			lock_texture = "hero_icon_locked",
			icon_texture = "icons_placeholder",
			equipped_texture = "button_illusion_glow",
			frame_texture = "item_frame",
			selection_texture = "button_illusion_glow",
			background_texture = "icons_placeholder",
			button_hotspot = {}
		},
		style = {
			hotspot = {
				size = {
					41,
					45
				},
				offset = {
					0,
					0,
					0
				}
			},
			background_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					80,
					80
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			icon_texture = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				}
			},
			frame_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					80,
					80
				},
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
			equipped_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					63,
					57
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					5
				}
			},
			lock_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					53.199999999999996,
					60.9
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					4
				}
			},
			hover_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					63,
					57
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					5
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_10 = true
local var_0_11 = {
	item_grid = UIWidgets.create_grid("item_grid", var_0_1.item_grid.size, 6, 5, 16, 10, false),
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
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, var_0_4),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_2),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, var_0_3),
	page_text_area = UIWidgets.create_simple_texture("tab_menu_bg_03", "page_text_area"),
	item_tooltip = UIWidgets.create_simple_item_presentation("item_tooltip", UISettings.console_tooltip_pass_definitions),
	item_tooltip_compare = UIWidgets.create_simple_item_presentation("item_tooltip_compare", UISettings.console_tooltip_pass_definitions),
	button_remove = UIWidgets.create_default_button("button_remove", var_0_1.button_remove.size, nil, nil, Localize("input_description_remove"), 32, nil, nil, nil, var_0_10, true)
}
local var_0_12 = {
	illusions_divider = UIWidgets.create_simple_texture("divider_01_bottom", "illusions_divider"),
	illusions_title = UIWidgets.create_simple_text(Localize("inventory_screen_weapon_skins_title"), "illusions_title", nil, nil, var_0_5),
	illusions_counter = UIWidgets.create_simple_text(Localize("inventory_screen_weapon_skins_title"), "illusions_title", nil, nil, var_0_6),
	illusions_name = UIWidgets.create_simple_text("", "illusions_name", nil, nil, var_0_7),
	apply_illusion_button = UIWidgets.create_default_button("apply_illusion_button", var_0_1.apply_illusion_button.size, nil, nil, Localize("crafting_recipe_apply_weapon_skin"), 32, nil, nil, nil, false)
}
local var_0_13 = {
	default = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "right",
			priority = 2,
			description_text = "input_description_rotate_hero",
			ignore_keybinding = true
		},
		{
			input_action = "show_gamercard",
			priority = 3,
			description_text = "start_menu_switch_hero"
		},
		{
			input_action = "confirm",
			priority = 4,
			description_text = "input_description_select"
		},
		{
			input_action = "refresh",
			priority = 5,
			description_text = "input_description_remove"
		},
		{
			input_action = "back",
			priority = 5,
			description_text = "input_description_back"
		}
	},
	pose_selection = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "right",
			priority = 2,
			description_text = "input_description_rotate_hero",
			ignore_keybinding = true
		},
		{
			input_action = "show_gamercard",
			priority = 3,
			description_text = "start_menu_switch_hero"
		},
		{
			input_action = "special_1",
			priority = 4,
			description_text = "input_description_toggle_illusions"
		},
		{
			input_action = "confirm",
			priority = 5,
			description_text = "input_description_equip"
		},
		{
			input_action = "refresh",
			priority = 6,
			description_text = "input_description_remove"
		},
		{
			input_action = "back",
			priority = 7,
			description_text = "input_description_back"
		}
	},
	weapon_skin = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "right",
			priority = 2,
			description_text = "input_description_rotate_hero",
			ignore_keybinding = true
		},
		{
			input_action = "show_gamercard",
			priority = 3,
			description_text = "start_menu_switch_hero"
		},
		{
			input_action = "special_1",
			priority = 4,
			description_text = "input_description_toggle_illusions"
		},
		{
			input_action = "back",
			priority = 5,
			description_text = "input_description_back"
		}
	},
	apply_weapon_skin = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "right",
			priority = 2,
			description_text = "input_description_rotate_hero",
			ignore_keybinding = true
		},
		{
			input_action = "show_gamercard",
			priority = 3,
			description_text = "start_menu_switch_hero"
		},
		{
			input_action = "special_1",
			priority = 4,
			description_text = "input_description_toggle_illusions"
		},
		{
			input_action = "confirm",
			priority = 5,
			description_text = "crafting_recipe_apply_weapon_skin"
		},
		{
			input_action = "back",
			priority = 6,
			description_text = "input_description_back"
		}
	}
}
local var_0_14 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				arg_11_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				local var_12_0 = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.alpha_multiplier = var_12_0
				arg_12_0.area_left.local_position[1] = arg_12_1.area_left.position[1] + math.floor(-100 * (1 - var_12_0))
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				arg_14_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				local var_15_0 = math.easeOutCubic(arg_15_3)

				arg_15_4.render_settings.alpha_multiplier = 1 - var_15_0
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end
		}
	},
	animate_illusion_widgets = {
		{
			name = "animate_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				local var_17_0 = arg_17_1.apply_illusion_button_anchor.position[2] - 100

				arg_17_0.apply_illusion_button_anchor.local_position[2] = var_17_0

				local var_17_1 = arg_17_1.illusions_divider.position[2] - 100

				arg_17_0.illusions_divider.local_position[2] = var_17_1
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				local var_18_0 = math.easeOutCubic(arg_18_3)
				local var_18_1 = arg_18_1.apply_illusion_button_anchor.position[2]
				local var_18_2 = var_18_1 - 100

				arg_18_0.apply_illusion_button_anchor.local_position[2] = math.lerp(var_18_2, var_18_1, var_18_0)

				local var_18_3 = arg_18_1.illusions_divider.position[2]
				local var_18_4 = var_18_3 - 100

				arg_18_0.illusions_divider.local_position[2] = math.lerp(var_18_4, var_18_3, var_18_0)
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_11,
	category_settings = var_0_8,
	scenegraph_definition = var_0_1,
	animation_definitions = var_0_14,
	generic_input_actions = var_0_13,
	create_illusion_button = var_0_9,
	weapon_illusion_base_widgets = var_0_12
}
