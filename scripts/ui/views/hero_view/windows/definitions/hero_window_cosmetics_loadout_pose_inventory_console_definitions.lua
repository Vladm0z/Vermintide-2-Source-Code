-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_loadout_pose_inventory_console_definitions.lua

local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl = {
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	area_left = console_menu_scenegraphs.area_left,
	area_right = console_menu_scenegraphs.area_right,
	area_divider = console_menu_scenegraphs.area_divider,
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
local tbl_2 = {
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
local tbl_3 = {
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
local tbl_4 = {
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
local tbl_5 = {
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
local tbl_6 = {
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
local tbl_7 = {
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
local tbl_8 = {
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
	-- function 1
	arg_1_3 = arg_1_3 or "button_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_1_3)
	local var_1_1

	if not arg_1_2 then
		var_1_1 = UIFrameSettings[arg_1_2]

		if not var_1_1 then
			-- Nothing
		end
	end

	var_1_1 = UIFrameSettings.button_frame_01

	::label_1_0::

	local var_1_2 = var_1_1.texture_sizes.corner[1]
	local flag = arg_1_7 or "button_detail_01"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(flag).size
	local var_1_5
	local var_1_6

	if not arg_1_8 then
		if type(arg_1_8) == "table" then
			var_1_5 = arg_1_8[1]
			var_1_6 = arg_1_8[2]
		else
			var_1_5 = arg_1_8
		end
	end

	local tbl = {
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
					content_check_function = function (self)
						-- function 2
						return self.draw_frame
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
					content_check_function = function (self)
						-- function 3
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function (self)
						-- function 4
						return not self.skip_side_detail
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function (self)
						-- function 5
						return not self.skip_side_detail
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 6
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 7
						return self.button_hotspot.disable_button
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
				texture_id = flag,
				skip_side_detail = arg_1_10
			},
			button_hotspot = {},
			title_text = arg_1_4 or "n/a",
			frame = var_1_1.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_1_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_1_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = arg_1_3
			},
			disable_with_gamepad = arg_1_9
		}
	}
	local tbl_2 = {
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
		}
	}
	local tbl_3 = {
		color = {
			255,
			255,
			255,
			255
		}
	}
	local tbl_4 = {
		nil,
		nil,
		9
	}
	local num

	if not var_1_5 then
		num = -var_1_5

		if not num then
			-- Nothing
		end
	end

	num = -9

	::label_1_1::

	tbl_4[1] = num
	tbl_4[2] = arg_1_1[2] / 2 - size[2] / 2 + (var_1_6 or 0)
	tbl_3.offset = tbl_4
	tbl_3.size = {
		size[1],
		size[2]
	}
	tbl_2.side_detail_left = tbl_3
	tbl_2.side_detail_right = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			arg_1_1[1] - size[1] + (var_1_5 or 9),
			arg_1_1[2] / 2 - size[2] / 2 + (var_1_6 or 0),
			9
		},
		size = {
			size[1],
			size[2]
		}
	}
	tbl.style = tbl_2
	tbl.scenegraph_id = arg_1_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

local function fn()
	-- function 8
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
					content_check_function = function (self)
						-- function 9
						local button_hotspot = self.button_hotspot
						local is_selected

						if not button_hotspot.is_hover then
							is_selected = button_hotspot.is_selected

							if not is_selected then
								-- Nothing
							end
						end

						is_selected = not self.equipped

						::label_9_0::

						return is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "equipped_texture",
					texture_id = "equipped_texture",
					content_check_function = function (self)
						-- function 10
						return self.equipped
					end
				}
			}
		},
		content = {
			selection_texture = "button_illusion_glow",
			locked = false,
			hover_texture = "button_illusion_glow_white",
			lock_texture = "hero_icon_locked",
			icon_texture = "icons_placeholder",
			equipped_texture = "button_illusion_glow",
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

local flag = true
local tbl_9 = {
	item_grid = UIWidgets.create_grid("item_grid", tbl.item_grid.size, 6, 5, 16, 10, false),
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
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, tbl_4),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_2),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_3),
	page_text_area = UIWidgets.create_simple_texture("tab_menu_bg_03", "page_text_area"),
	item_tooltip = UIWidgets.create_simple_item_presentation("item_tooltip", UISettings.console_tooltip_pass_definitions),
	item_tooltip_compare = UIWidgets.create_simple_item_presentation("item_tooltip_compare", UISettings.console_tooltip_pass_definitions),
	button_remove = UIWidgets.create_default_button("button_remove", tbl.button_remove.size, nil, nil, Localize("input_description_remove"), 32, nil, nil, nil, flag, true)
}
local tbl_10 = {
	illusions_divider = UIWidgets.create_simple_texture("divider_01_bottom", "illusions_divider"),
	illusions_title = UIWidgets.create_simple_text(Localize("inventory_screen_weapon_skins_title"), "illusions_title", nil, nil, tbl_5),
	illusions_counter = UIWidgets.create_simple_text(Localize("inventory_screen_weapon_skins_title"), "illusions_title", nil, nil, tbl_6),
	illusions_name = UIWidgets.create_simple_text("", "illusions_name", nil, nil, tbl_7),
	apply_illusion_button = UIWidgets.create_default_button("apply_illusion_button", tbl.apply_illusion_button.size, nil, nil, Localize("crafting_recipe_apply_weapon_skin"), 32, nil, nil, nil, false)
}
local tbl_11 = {
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
local tbl_12 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				arg_11_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				-- function 12
				local easeOutCubic = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.alpha_multiplier = easeOutCubic
				arg_12_0.area_left.local_position[1] = arg_12_1.area_left.position[1] + math.floor(-100 * (1 - easeOutCubic))
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
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
				-- function 14
				arg_14_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				-- function 15
				local easeOutCubic = math.easeOutCubic(arg_15_3)

				arg_15_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
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
				-- function 17
				local num = arg_17_1.apply_illusion_button_anchor.position[2] - 100

				arg_17_0.apply_illusion_button_anchor.local_position[2] = num

				local num_2 = arg_17_1.illusions_divider.position[2] - 100

				arg_17_0.illusions_divider.local_position[2] = num_2
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				-- function 18
				local easeOutCubic = math.easeOutCubic(arg_18_3)
				local var_18_1 = arg_18_1.apply_illusion_button_anchor.position[2]
				local num = var_18_1 - 100

				arg_18_0.apply_illusion_button_anchor.local_position[2] = math.lerp(num, var_18_1, easeOutCubic)

				local var_18_3 = arg_18_1.illusions_divider.position[2]
				local num_2 = var_18_3 - 100

				arg_18_0.illusions_divider.local_position[2] = math.lerp(num_2, var_18_3, easeOutCubic)
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end
		}
	}
}

return {
	widgets = tbl_9,
	category_settings = tbl_8,
	scenegraph_definition = tbl,
	animation_definitions = tbl_12,
	generic_input_actions = tbl_11,
	create_illusion_button = fn,
	weapon_illusion_base_widgets = tbl_10
}
