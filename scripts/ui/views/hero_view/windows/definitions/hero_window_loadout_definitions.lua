-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_loadout_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = var_0_0.spacing
local var_0_5 = UIFrameSettings[var_0_2].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[var_0_2].texture_sizes.horizontal[2]
local var_0_7 = var_0_3[1] - (var_0_5 * 2 + 60)
local var_0_8 = 18
local var_0_9 = {
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
	loadout_background = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			120
		},
		position = {
			0,
			0,
			1
		}
	},
	loadout_divider = {
		vertical_alignment = "top",
		parent = "loadout_background",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			0
		},
		position = {
			0,
			0,
			10
		}
	},
	loadout_grid = {
		vertical_alignment = "center",
		parent = "loadout_background",
		horizontal_alignment = "center",
		size = {
			var_0_3[1],
			80
		},
		position = {
			0,
			0,
			1
		}
	}
}

local function var_0_10(arg_1_0, arg_1_1)
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
					arg_1_1[1] - 10,
					5
				},
				texture_tiling_size = {
					1,
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
					arg_1_1[1] - 12,
					-6,
					10
				},
				size = {
					9,
					17
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

local function var_0_11(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0

	if arg_2_5 then
		var_2_0 = "button_" .. arg_2_5
	else
		var_2_0 = "button_normal"
	end

	local var_2_1 = Colors.get_color_table_with_alpha(var_2_0, 255)
	local var_2_2 = "button_bg_01"
	local var_2_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_2_2)

	return {
		element = {
			passes = {
				{
					style_id = "button_background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "button_background",
					pass_type = "texture_uv",
					content_id = "button_background"
				},
				{
					texture_id = "bottom_edge",
					style_id = "button_edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "glass_top",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (arg_3_0)
						local var_3_0 = arg_3_0.button_hotspot

						return not var_3_0.disable_button and (var_3_0.is_selected or var_3_0.is_hover)
					end
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (arg_4_0)
						return not arg_4_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (arg_5_0)
						return arg_5_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_shadow",
					pass_type = "text",
					text_id = "button_text"
				},
				{
					style_id = "button_clicked_rect",
					pass_type = "rect",
					content_check_function = function (arg_6_0)
						local var_6_0 = arg_6_0.button_hotspot.is_clicked

						return not var_6_0 or var_6_0 == 0
					end
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (arg_7_0)
						return arg_7_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture",
					content_check_function = function (arg_8_0)
						return arg_8_0.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture",
					content_check_function = function (arg_9_0)
						return arg_9_0.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture",
					content_check_function = function (arg_10_0)
						return arg_10_0.use_bottom_edge
					end
				}
			}
		},
		content = {
			edge_holder_left = "menu_frame_09_divider_left",
			edge_holder_right = "menu_frame_09_divider_right",
			glass_top = "button_glass_01",
			bottom_edge = "menu_frame_09_divider",
			use_bottom_edge = arg_2_4,
			button_hotspot = {},
			button_text = arg_2_2 or "n/a",
			hover_glow = arg_2_5 and "button_state_hover_" .. arg_2_5 or "button_state_hover",
			glow = arg_2_5 and "button_state_normal_" .. arg_2_5 or "button_state_normal",
			button_background = {
				uvs = {
					{
						0,
						1 - math.min(arg_2_1[2] / var_2_3.size[2], 1)
					},
					{
						math.min(arg_2_1[1] / var_2_3.size[1], 1),
						1
					}
				},
				texture_id = var_2_2
			}
		},
		style = {
			button_background = {
				color = var_2_1,
				offset = {
					0,
					0,
					2
				},
				size = arg_2_1
			},
			button_edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_2_1[2],
					3
				},
				size = {
					arg_2_1[1],
					5
				},
				texture_tiling_size = {
					1,
					5
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
					arg_2_1[2] - 4,
					3
				},
				size = {
					arg_2_1[1],
					5
				}
			},
			glow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					5,
					3
				},
				size = {
					arg_2_1[1],
					arg_2_1[2] - 5
				}
			},
			hover_glow = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					5,
					2
				},
				size = {
					arg_2_1[1],
					arg_2_1[2] - 5
				}
			},
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
					arg_2_1[1] - 10,
					5
				},
				texture_tiling_size = {
					1,
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
					arg_2_1[1] - 12,
					-6,
					10
				},
				size = {
					9,
					17
				}
			},
			button_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_2_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					5,
					4
				},
				size = arg_2_1
			},
			button_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_2_3 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					5,
					4
				},
				size = arg_2_1
			},
			button_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_2_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					3,
					3
				},
				size = arg_2_1
			},
			button_clicked_rect = {
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					5,
					0,
					5
				},
				size = {
					arg_2_1[1] - 10,
					arg_2_1[2]
				}
			},
			button_disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					5,
					0,
					5
				},
				size = {
					arg_2_1[1] - 10,
					arg_2_1[2]
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

local var_0_12 = #InventorySettings.equipment_slots
local var_0_13 = {
	loadout_background = UIWidgets.create_background("loadout_background", var_0_9.loadout_background.size, "crafting_bg_top"),
	loadout_grid = UIWidgets.create_loadout_grid("loadout_grid", var_0_9.loadout_grid.size, var_0_12, var_0_8, true),
	loadout_divider = var_0_10("loadout_divider", var_0_9.loadout_divider.size)
}
local var_0_14 = {
	{
		wield = true,
		name = "melee",
		display_name = "Melee Weapons",
		item_filter = "slot_type == melee and item_rarity ~= magic",
		hero_specific_filter = true,
		item_types = {
			"melee"
		},
		icon = UISettings.slot_icons.melee
	},
	{
		wield = true,
		name = "ranged",
		display_name = "Ranged Weapons",
		item_filter = "slot_type == ranged and item_rarity ~= magic",
		hero_specific_filter = true,
		item_types = {
			"ranged"
		},
		icon = UISettings.slot_icons.ranged
	},
	{
		display_name = "Jewellery",
		name = "jewellery",
		item_filter = "slot_type == trinket or slot_type == ring or slot_type == necklace",
		hero_specific_filter = true,
		item_types = {
			"ring",
			"necklace",
			"trinket"
		},
		icon = UISettings.slot_icons.trinket
	}
}
local var_0_15 = {
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
	}
}

return {
	widgets = var_0_13,
	node_widgets = node_widgets,
	category_settings = var_0_14,
	scenegraph_definition = var_0_9,
	animation_definitions = var_0_15
}
