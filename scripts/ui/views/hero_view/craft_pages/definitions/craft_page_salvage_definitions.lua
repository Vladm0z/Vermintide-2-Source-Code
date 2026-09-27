-- chunkname: @scripts/ui/views/hero_view/craft_pages/definitions/craft_page_salvage_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local var_0_5 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local num = size[1] - (var_0_5 * 2 + 60)
local tbl = {
	60,
	60
}
local num_2 = tbl[2] + 10

NUM_CRAFT_SLOTS_X = 3
NUM_CRAFT_SLOTS_Y = 3
NUM_CRAFT_SLOTS = NUM_CRAFT_SLOTS_X * NUM_CRAFT_SLOTS_Y

local tbl_2 = {
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
	},
	auto_fill_buttons = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = tbl,
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
		size = tbl,
		position = {
			0,
			-num_2 * 0,
			1
		}
	},
	auto_fill_common = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			0,
			-num_2 * 1,
			1
		}
	},
	auto_fill_rare = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			0,
			-num_2 * 2,
			1
		}
	},
	auto_fill_exotic = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			0,
			-num_2 * 3,
			1
		}
	},
	auto_fill_clear = {
		vertical_alignment = "top",
		parent = "auto_fill_buttons",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			0,
			-num_2 * 4,
			1
		}
	}
}

local function fn(self)
	-- function 1
	local button_hotspot = self.button_hotspot

	return true
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local var_2_0 = tbl
	local str = "menu_frame_bg_04"
	local num = 7
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)

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
					content_check_function = fn
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
						var_2_0[1] / get_atlas_settings_by_texture_name.size[1],
						var_2_0[2] / get_atlas_settings_by_texture_name.size[2]
					}
				},
				texture_id = str
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
					num,
					num - 2,
					1
				},
				size = {
					var_2_0[1] - num * 2,
					var_2_0[2] - num * 2
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
		scenegraph_id = arg_2_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local flag = true
local tbl_3 = {
	item_grid_bg = UIWidgets.create_simple_texture("crafting_bg_01", "item_grid", nil, nil, nil, -1),
	item_grid = UIWidgets.create_grid("item_grid", tbl_2.item_grid.size, NUM_CRAFT_SLOTS_X, NUM_CRAFT_SLOTS_Y, 20, 20),
	craft_button = UIWidgets.create_default_button("craft_button", tbl_2.craft_button.size, nil, nil, Localize("hero_view_crafting_salvage"), 24, nil, "button_detail_02", nil, flag),
	craft_bar_fg = UIWidgets.create_simple_texture("crafting_bar_fg", "craft_bar_fg"),
	craft_bar_bg = UIWidgets.create_simple_rect("craft_bar_bg", {
		255,
		0,
		0,
		0
	}),
	craft_bar = UIWidgets.create_simple_texture("crafting_bar", "craft_bar", nil, nil, nil, 2),
	auto_fill_plentiful = fn_2("auto_fill_plentiful", "store_tag_icon_weapon_plentiful", Colors.get_table("plentiful")),
	auto_fill_common = fn_2("auto_fill_common", "store_tag_icon_weapon_common", Colors.get_table("common")),
	auto_fill_rare = fn_2("auto_fill_rare", "store_tag_icon_weapon_rare", Colors.get_table("rare")),
	auto_fill_exotic = fn_2("auto_fill_exotic", "store_tag_icon_weapon_exotic", Colors.get_table("exotic")),
	auto_fill_clear = fn_2("auto_fill_clear", "layout_button_back", {
		100,
		255,
		100,
		100
	}, "button_state_default")
}
local tbl_4 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				arg_3_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
				-- function 4
				local easeOutCubic = math.easeOutCubic(arg_4_3)

				arg_4_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				arg_6_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
				-- function 7
				local easeOutCubic = math.easeOutCubic(arg_7_3)

				arg_7_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
				-- function 8
				return
			end
		}
	}
}

return {
	widgets = tbl_3,
	scenegraph_definition = tbl_2,
	animation_definitions = tbl_4
}
