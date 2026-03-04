-- chunkname: @scripts/ui/views/hero_view/craft_pages/definitions/craft_page_salvage_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = var_0_0.spacing
local var_0_5 = UIFrameSettings[var_0_2].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[var_0_2].texture_sizes.horizontal[2]
local var_0_7 = var_0_3[1] - (var_0_5 * 2 + 60)
local var_0_8 = {
	60,
	60
}
local var_0_9 = var_0_8[2] + 10

NUM_CRAFT_SLOTS_X = 3
NUM_CRAFT_SLOTS_Y = 3
NUM_CRAFT_SLOTS = NUM_CRAFT_SLOTS_X * NUM_CRAFT_SLOTS_Y

local var_0_10 = {
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
		size = var_0_3,
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
			362,
			362
		},
		position = {
			-25,
			-66,
			6
		}
	},
	craft_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_3[1] - 100,
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
	},
	auto_fill_buttons = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = var_0_8,
		position = {
			-42,
			74,
			6
		}
	},
	auto_fill_plentiful = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = var_0_8,
		position = {
			0,
			-var_0_9 * 0,
			1
		}
	},
	auto_fill_common = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = var_0_8,
		position = {
			0,
			-var_0_9 * 1,
			1
		}
	},
	auto_fill_rare = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = var_0_8,
		position = {
			0,
			-var_0_9 * 2,
			1
		}
	},
	auto_fill_exotic = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = var_0_8,
		position = {
			0,
			-var_0_9 * 3,
			1
		}
	},
	auto_fill_clear = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = var_0_8,
		position = {
			0,
			-var_0_9 * 4,
			1
		}
	}
}

local function var_0_11(arg_1_0)
	local var_1_0 = arg_1_0.button_hotspot

	return true
end

local function var_0_12(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = var_0_8
	local var_2_1 = "menu_frame_bg_04"
	local var_2_2 = 7
	local var_2_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_2_1)

	return {
		element = {
			passes = {
				{
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
					pass_type = "texture",
					content_check_function = var_0_11
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
						var_2_0[1] / var_2_3.size[1],
						var_2_0[2] / var_2_3.size[2]
					}
				},
				texture_id = var_2_1
			},
			texture_hover = arg_2_3 or "crafting_icon_hover",
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
				texture_id = arg_2_1
			}
		},
		style = {
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
					var_2_2,
					var_2_2 - 2,
					1
				},
				size = {
					var_2_0[1] - var_2_2 * 2,
					var_2_0[2] - var_2_2 * 2
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
					arg_2_2[2],
					arg_2_2[3],
					arg_2_2[4]
				},
				hover_color = arg_2_2,
				offset = {
					0,
					var_2_2 - 2,
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
		scenegraph_id = arg_2_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_13 = true
local var_0_14 = {
	item_grid_bg = UIWidgets.create_simple_texture("crafting_bg_01", "item_grid", nil, nil, nil, -1),
	item_grid = UIWidgets.create_grid("item_grid", var_0_10.item_grid.size, NUM_CRAFT_SLOTS_X, NUM_CRAFT_SLOTS_Y, 20, 20),
	craft_button = UIWidgets.create_default_button("craft_button", var_0_10.craft_button.size, nil, nil, Localize("hero_view_crafting_salvage"), 24, nil, "button_detail_02", nil, var_0_13),
	craft_bar_fg = UIWidgets.create_simple_texture("crafting_bar_fg", "craft_bar_fg"),
	craft_bar_bg = UIWidgets.create_simple_rect("craft_bar_bg", {
		255,
		0,
		0,
		0
	}),
	craft_bar = UIWidgets.create_simple_texture("crafting_bar", "craft_bar", nil, nil, nil, 2),
	auto_fill_plentiful = var_0_12("auto_fill_plentiful", "store_tag_icon_weapon_plentiful", Colors.get_table("plentiful")),
	auto_fill_common = var_0_12("auto_fill_common", "store_tag_icon_weapon_common", Colors.get_table("common")),
	auto_fill_rare = var_0_12("auto_fill_rare", "store_tag_icon_weapon_rare", Colors.get_table("rare")),
	auto_fill_exotic = var_0_12("auto_fill_exotic", "store_tag_icon_weapon_exotic", Colors.get_table("exotic")),
	auto_fill_clear = var_0_12("auto_fill_clear", "layout_button_back", {
		100,
		255,
		100,
		100
	}, "button_state_default")
}
local var_0_15 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				arg_3_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
				local var_4_0 = math.easeOutCubic(arg_4_3)

				arg_4_4.render_settings.alpha_multiplier = var_4_0
			end,
			on_complete = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				arg_6_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				local var_7_0 = math.easeOutCubic(arg_7_3)

				arg_7_4.render_settings.alpha_multiplier = 1 - var_7_0
			end,
			on_complete = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_14,
	scenegraph_definition = var_0_10,
	animation_definitions = var_0_15
}
