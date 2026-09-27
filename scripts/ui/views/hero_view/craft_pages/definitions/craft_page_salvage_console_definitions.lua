-- chunkname: @scripts/ui/views/hero_view/craft_pages/definitions/craft_page_salvage_console_definitions.lua

local num = 3
local num_2 = num * 3
local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local tbl = {
	80,
	80
}
local num_3 = tbl[2] + 16
local tbl_2 = {
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	area_left = console_menu_scenegraphs.area_left,
	area_right = console_menu_scenegraphs.area_right,
	area_divider = console_menu_scenegraphs.area_divider,
	craft_bg_root = console_menu_scenegraphs.craft_bg_root,
	craft_button = console_menu_scenegraphs.craft_button,
	counter_text_root = {
		vertical_alignment = "center",
		parent = "craft_bg_root",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			6
		}
	},
	counter_text = {
		vertical_alignment = "center",
		parent = "counter_text_root",
		horizontal_alignment = "center",
		size = {
			200,
			200
		},
		position = {
			-16,
			0,
			1
		}
	},
	max_counter_text = {
		vertical_alignment = "center",
		parent = "counter_text_root",
		horizontal_alignment = "left",
		size = {
			200,
			200
		},
		position = {
			0,
			58,
			1
		}
	},
	material_holder = {
		vertical_alignment = "center",
		parent = "craft_bg_root",
		horizontal_alignment = "center",
		size = {
			251,
			277
		},
		position = {
			0,
			4,
			4
		}
	},
	material_circle = {
		vertical_alignment = "center",
		parent = "material_holder",
		horizontal_alignment = "center",
		size = {
			136,
			136
		},
		position = {
			0,
			0,
			1
		}
	},
	material_cross = {
		vertical_alignment = "center",
		parent = "material_holder",
		horizontal_alignment = "center",
		size = {
			108,
			108
		},
		position = {
			0,
			0,
			1
		}
	},
	material_text_1 = {
		vertical_alignment = "center",
		parent = "material_holder",
		horizontal_alignment = "center",
		size = {
			60,
			100
		},
		position = {
			-90,
			30,
			2
		}
	},
	material_text_2 = {
		vertical_alignment = "center",
		parent = "material_holder",
		horizontal_alignment = "center",
		size = {
			60,
			100
		},
		position = {
			-38,
			75,
			2
		}
	},
	material_text_3 = {
		vertical_alignment = "center",
		parent = "material_holder",
		horizontal_alignment = "center",
		size = {
			60,
			100
		},
		position = {
			38,
			75,
			2
		}
	},
	material_text_4 = {
		vertical_alignment = "center",
		parent = "material_holder",
		horizontal_alignment = "center",
		size = {
			60,
			100
		},
		position = {
			90,
			30,
			2
		}
	},
	material_text_5 = {
		vertical_alignment = "center",
		parent = "material_holder",
		horizontal_alignment = "center",
		size = {
			60,
			100
		},
		position = {
			70,
			-80,
			2
		}
	},
	material_text_6 = {
		vertical_alignment = "center",
		parent = "material_holder",
		horizontal_alignment = "center",
		size = {
			60,
			100
		},
		position = {
			0,
			-105,
			2
		}
	},
	material_text_7 = {
		vertical_alignment = "center",
		parent = "material_holder",
		horizontal_alignment = "center",
		size = {
			60,
			100
		},
		position = {
			-70,
			-80,
			2
		}
	},
	auto_fill_area = {
		parent = "area_left",
		position = {
			0,
			0,
			0
		},
		size = {
			0,
			0
		}
	},
	auto_fill_buttons = {
		vertical_alignment = "bottom",
		parent = "auto_fill_area",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			-42,
			93,
			6
		}
	},
	auto_fill_plentiful = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			80 + num_3 * 0,
			-125,
			1
		}
	},
	auto_fill_common = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			80 + num_3 * 1,
			-125,
			1
		}
	},
	auto_fill_rare = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			80 + num_3 * 2,
			-125,
			1
		}
	},
	auto_fill_exotic = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			80 + num_3 * 3,
			-125,
			1
		}
	},
	auto_fill_clear = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			80 + num_3 * 4,
			-125,
			1
		}
	}
}
local tbl_3 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 72,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_4 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 42,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}

local function fn(arg_1_0)
	-- function 1
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon"
				},
				{
					pass_type = "rotated_texture",
					style_id = "effect",
					texture_id = "effect"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 2
						return not self.warning
					end
				},
				{
					style_id = "text_warning",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 3
						return self.warning
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				},
				{
					item_id = "item",
					pass_type = "item_tooltip",
					content_check_function = function (self)
						-- function 4
						local is_hover = self.button_hotspot.is_hover

						is_hover = not is_hover and self.item

						return is_hover
					end
				}
			}
		},
		content = {
			text = "0",
			effect = "sparkle_effect",
			icon = "icon_crafting_dust_01_small",
			warning = false,
			button_hotspot = {}
		},
		style = {
			icon = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				texture_size = {
					50,
					50
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
					3
				}
			},
			effect = {
				vertical_alignment = "top",
				angle = 0,
				horizontal_alignment = "right",
				offset = {
					110,
					120,
					4
				},
				pivot = {
					128,
					128
				},
				texture_size = {
					256,
					256
				},
				color = Colors.get_color_table_with_alpha("white", 0)
			},
			text = {
				vertical_alignment = "bottom",
				font_size = 24,
				localize = false,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					26,
					3
				}
			},
			text_warning = {
				vertical_alignment = "bottom",
				font_size = 24,
				localize = false,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("red", 255),
				offset = {
					0,
					26,
					3
				}
			},
			text_shadow = {
				vertical_alignment = "bottom",
				font_size = 24,
				localize = false,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					24,
					2
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

local function fn_2(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local var_5_0 = tbl
	local str = "menu_frame_bg_04"
	local num = 7
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "border",
					pass_type = "texture_uv",
					content_id = "border"
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
					texture_id = "texture_hover",
					style_id = "texture_hover",
					pass_type = "texture"
				},
				{
					style_id = "texture_icon",
					pass_type = "texture_uv",
					content_id = "texture_icon"
				}
			}
		},
		content = {
			background_fade = "button_bg_fade",
			button_hotspot = {},
			border = {
				texture_id = "crafting_bg_03",
				uvs = {
					{
						0.08974358974358974,
						0.09183673469387756
					},
					{
						0.9183673469387755,
						0.9183673469387755
					}
				}
			},
			background = {
				uvs = {
					{
						0,
						0
					},
					{
						var_5_0[1] / get_atlas_settings_by_texture_name.size[1],
						var_5_0[2] / get_atlas_settings_by_texture_name.size[2]
					}
				},
				texture_id = str
			},
			texture_hover = arg_5_3 or "crafting_icon_hover",
			texture_icon = {
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
				texture_id = arg_5_1
			},
			disable_with_gamepad = arg_5_4
		},
		style = {
			frame = {},
			border = {
				offset = {
					0,
					0,
					6
				}
			},
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
					num,
					num - 2,
					1
				},
				size = {
					var_5_0[1] - num * 2,
					var_5_0[2] - num * 2
				}
			},
			texture_hover = {
				color = {
					0,
					0,
					0,
					0
				},
				default_color = {
					127,
					arg_5_2[2],
					arg_5_2[3],
					arg_5_2[4]
				},
				hover_color = arg_5_2,
				offset = {
					0,
					num - 2,
					3
				}
			},
			texture_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					0,
					0,
					0,
					0
				},
				default_color = {
					200,
					255,
					255,
					255
				},
				hover_color = {
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
			}
		},
		scenegraph_id = arg_5_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local flag = true
local tbl_5 = {
	craft_button = UIWidgets.create_console_craft_button("craft_button", "console_crafting_recipe_icon_salvage"),
	counter_text = UIWidgets.create_simple_text("", "counter_text", nil, nil, tbl_3),
	max_counter_text = UIWidgets.create_simple_text("", "max_counter_text", nil, nil, tbl_4),
	material_holder = UIWidgets.create_simple_texture("console_crafting_salvage_bg", "material_holder"),
	material_circle = UIWidgets.create_simple_texture("console_crafting_salvage_ring", "material_circle"),
	material_cross = UIWidgets.create_simple_texture("console_crafting_salvage_cross", "material_cross"),
	material_text_1 = fn("material_text_1"),
	material_text_2 = fn("material_text_2"),
	material_text_3 = fn("material_text_3"),
	material_text_4 = fn("material_text_4"),
	material_text_5 = fn("material_text_5"),
	material_text_6 = fn("material_text_6"),
	material_text_7 = fn("material_text_7"),
	auto_fill_plentiful = fn_2("auto_fill_plentiful", "store_tag_icon_weapon_plentiful", Colors.get_table("plentiful"), nil, flag),
	auto_fill_common = fn_2("auto_fill_common", "store_tag_icon_weapon_common", Colors.get_table("common"), nil, flag),
	auto_fill_rare = fn_2("auto_fill_rare", "store_tag_icon_weapon_rare", Colors.get_table("rare"), nil, flag),
	auto_fill_exotic = fn_2("auto_fill_exotic", "store_tag_icon_weapon_exotic", Colors.get_table("exotic"), nil, flag),
	auto_fill_clear = fn_2("auto_fill_clear", "layout_button_back", {
		100,
		255,
		100,
		100
	}, "button_state_default", flag)
}
local tbl_6 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				arg_6_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				-- function 7
				local easeOutCubic = math.easeOutCubic(arg_7_3)

				arg_7_4.render_settings.alpha_multiplier = easeOutCubic
				arg_7_0.auto_fill_area.local_position[1] = arg_7_1.auto_fill_area.position[1] + -100 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				arg_9_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
				-- function 10
				local easeOutCubic = math.easeOutCubic(arg_10_3)

				arg_10_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				return
			end
		}
	}
}

return {
	widgets = tbl_5,
	scenegraph_definition = tbl_2,
	animation_definitions = tbl_6,
	NUM_CRAFT_SLOTS = num_2
}
