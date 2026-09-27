-- chunkname: @scripts/ui/views/hero_view/craft_pages/definitions/craft_page_convert_dust_definitions.lua

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
		vertical_alignment = "bottom",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			284,
			146
		},
		position = {
			0,
			-160,
			2
		}
	},
	material_text_1 = {
		vertical_alignment = "center",
		parent = "material_bg",
		horizontal_alignment = "center",
		size = {
			60,
			100
		},
		position = {
			0,
			-10,
			2
		}
	},
	material_text_2 = {
		vertical_alignment = "center",
		parent = "material_bg",
		horizontal_alignment = "center",
		size = {
			60,
			100
		},
		position = {
			0,
			-10,
			2
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
					style_id = "text_bg",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 4
						return self.draw_background
					end
				},
				{
					style_id = "text_bg_2",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 5
						return self.draw_background
					end
				},
				{
					item_id = "item",
					pass_type = "item_tooltip",
					content_check_function = function (self)
						-- function 6
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
			draw_background = true,
			icon = "icon_crafting_dust_01_small",
			warning = false,
			button_hotspot = {}
		},
		style = {
			text_bg = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					60,
					80
				},
				color = {
					0,
					10,
					10,
					10
				},
				offset = {
					2,
					10,
					1
				}
			},
			text_bg_2 = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				texture_size = {
					60,
					25
				},
				color = {
					180,
					5,
					5,
					5
				},
				offset = {
					0,
					12,
					0
				}
			},
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
				font_size = 20,
				localize = false,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					10,
					3
				}
			},
			text_warning = {
				vertical_alignment = "bottom",
				font_size = 20,
				localize = false,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("red", 255),
				offset = {
					0,
					10,
					3
				}
			},
			text_shadow = {
				vertical_alignment = "bottom",
				font_size = 20,
				localize = false,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					8,
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

local flag = true
local tbl_2 = {
	item_grid_bg = UIWidgets.create_simple_texture("crafting_bg_02", "item_grid", nil, nil, nil, -1),
	item_grid = UIWidgets.create_grid("item_grid", tbl.item_grid.size, NUM_CRAFT_SLOTS_Y, NUM_CRAFT_SLOTS_X, 20, 20),
	item_grid_icon = UIWidgets.create_simple_texture("crafting_icon_dust", "item_grid_icon"),
	craft_button = UIWidgets.create_default_button("craft_button", tbl.craft_button.size, nil, nil, Localize("hero_view_crafting_convert"), 24, nil, "button_detail_02", nil, flag),
	craft_bar_fg = UIWidgets.create_simple_texture("crafting_bar_fg", "craft_bar_fg"),
	craft_bar_bg = UIWidgets.create_simple_rect("craft_bar_bg", {
		255,
		0,
		0,
		0
	}),
	craft_bar = UIWidgets.create_simple_texture("crafting_bar", "craft_bar", nil, nil, nil, 2),
	material_text_1 = fn("material_text_1"),
	material_text_2 = fn("material_text_2"),
	material_bg = UIWidgets.create_simple_texture("crafting_bg_conversion", "material_bg")
}
local tbl_3 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				-- function 7
				arg_7_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				-- function 8
				local easeOutCubic = math.easeOutCubic(arg_8_3)

				arg_8_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				-- function 10
				arg_10_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				-- function 11
				local easeOutCubic = math.easeOutCubic(arg_11_3)

				arg_11_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
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
