-- chunkname: @scripts/ui/views/player_inventory_ui_definitions.lua

require("scripts/settings/inventory_settings")

local var_0_0 = true
local var_0_1 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud_inventory
		},
		size = {
			1920,
			1080
		}
	},
	inventory_entry_base = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			-10,
			420,
			1
		},
		size = {
			1,
			1
		}
	}
}
local var_0_2 = {
	stance_bar = {
		bar = "stance_bar_blue",
		glow = "stance_bar_glow_blue"
	},
	charge_bar = {
		bar = "stance_bar_orange",
		glow = "stance_bar_glow_orange"
	},
	attention_bar = {
		stance_bar = {
			bar = "hud_stance_bar_2",
			lit = "hud_stance_bar_2_lit"
		},
		charge_bar = {
			bar = "hud_charge_bar_2",
			lit = "hud_charge_bar_2_lit"
		}
	}
}
local var_0_3 = {}
local var_0_4 = InventorySettings.weapon_slots
local var_0_5 = {
	slot_healthkit = 1,
	slot_grenade = 3,
	slot_potion = 2
}

local function var_0_6(arg_1_0)
	local var_1_0 = {}

	for iter_1_0 = 1, arg_1_0 do
		local var_1_1 = var_0_4[iter_1_0].name
		local var_1_2 = var_0_5[var_1_1] and true or false
		local var_1_3 = "inventory_entry_" .. iter_1_0
		local var_1_4 = "inventory_entry_root_" .. iter_1_0
		local var_1_5 = "inventory_entry_background_" .. iter_1_0
		local var_1_6 = "inventory_entry_default_icon_" .. iter_1_0
		local var_1_7 = "inventory_entry_icon_" .. iter_1_0
		local var_1_8 = "inventory_entry_stance_bar_" .. iter_1_0
		local var_1_9 = "inventory_entry_stance_bar_fill_" .. iter_1_0
		local var_1_10 = "inventory_entry_stance_bar_glow_" .. iter_1_0
		local var_1_11 = "inventory_entry_ammo_text_root_" .. iter_1_0
		local var_1_12 = "inventory_entry_ammo_text_1_" .. iter_1_0
		local var_1_13 = "inventory_entry_ammo_text_2_" .. iter_1_0

		var_0_1[var_1_4] = {
			vertical_alignment = "center",
			parent = "inventory_entry_base",
			horizontal_alignment = "right",
			position = {
				-5,
				0,
				1
			},
			size = {
				512,
				128
			}
		}
		var_0_1[var_1_3] = {
			horizontal_alignment = "right",
			parent = var_1_4,
			position = {
				0,
				0,
				1
			},
			size = {
				512,
				128
			}
		}

		if not var_1_2 then
			var_0_1[var_1_5] = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				parent = var_1_3,
				position = {
					0,
					0,
					1
				},
				size = {
					256,
					128
				}
			}
			var_0_1[var_1_7] = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				parent = var_1_5,
				position = {
					-20,
					0,
					1
				},
				size = {
					256,
					64
				}
			}
		elseif var_1_1 == "slot_healthkit" then
			var_0_1[var_1_5] = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				parent = var_1_3,
				position = {
					1,
					0,
					1
				},
				size = {
					96,
					96
				}
			}
			var_0_1[var_1_7] = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				parent = var_1_5,
				position = {
					0,
					0,
					1
				},
				size = {
					96,
					96
				}
			}
		else
			var_0_1[var_1_5] = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				parent = var_1_3,
				position = {
					1,
					0,
					1
				},
				size = {
					64,
					64
				}
			}
			var_0_1[var_1_7] = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				parent = var_1_5,
				position = {
					0,
					0,
					1
				},
				size = {
					64,
					64
				}
			}
		end

		if var_1_1 == "slot_healthkit" then
			var_0_1[var_1_6] = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				parent = var_1_3,
				position = {
					1,
					0,
					1
				},
				size = {
					76.8,
					76.8
				}
			}
		else
			var_0_1[var_1_6] = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				parent = var_1_3,
				position = {
					1,
					0,
					1
				},
				size = {
					51.2,
					51.2
				}
			}
		end

		var_0_1[var_1_8] = {
			horizontal_alignment = "right",
			parent = var_1_5,
			position = {
				18,
				0,
				1
			},
			size = {
				32,
				128
			}
		}
		var_0_1[var_1_9] = {
			parent = var_1_8,
			position = {
				18,
				31,
				1
			},
			size = {
				9,
				67
			}
		}
		var_0_1[var_1_10] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = var_1_9,
			position = {
				0,
				0,
				5
			},
			size = {
				32,
				128
			}
		}
		var_0_1[var_1_11] = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			parent = var_1_7,
			position = {
				55,
				-6,
				1
			},
			size = {
				8,
				32
			}
		}
		var_0_1[var_1_12] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = var_1_11,
			position = {
				-61,
				0,
				1
			},
			size = {
				60,
				60
			}
		}
		var_0_1[var_1_13] = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			parent = var_1_11,
			position = {
				61,
				0,
				1
			},
			size = {
				60,
				60
			}
		}
		var_1_0[iter_1_0] = {
			element = {
				passes = {
					{
						pass_type = "texture",
						style_id = "background",
						texture_id = "background",
						retained_mode = var_0_0,
						content_check_function = function (arg_2_0)
							return arg_2_0.has_data
						end
					},
					{
						pass_type = "texture",
						style_id = "background_lit",
						texture_id = "background_lit",
						retained_mode = var_0_0,
						content_check_function = function (arg_3_0)
							return arg_3_0.has_data
						end
					},
					{
						pass_type = "texture",
						style_id = "default_icon",
						texture_id = "default_icon",
						retained_mode = var_0_0,
						content_check_function = function (arg_4_0)
							return not arg_4_0.has_data
						end
					},
					{
						pass_type = "texture",
						style_id = "icon",
						texture_id = "icon",
						retained_mode = var_0_0,
						content_check_function = function (arg_5_0)
							return arg_5_0.has_data
						end
					},
					{
						pass_type = "texture",
						style_id = "icon_lit",
						texture_id = "icon_lit",
						retained_mode = var_0_0,
						content_check_function = function (arg_6_0)
							return arg_6_0.has_data
						end
					},
					{
						pass_type = "texture",
						style_id = "stance_bar_fg",
						texture_id = "stance_bar_fg",
						retained_mode = var_0_0,
						content_check_function = function (arg_7_0)
							return arg_7_0.stance_bar.active
						end
					},
					{
						pass_type = "texture",
						style_id = "stance_bar_lit",
						texture_id = "stance_bar_lit",
						retained_mode = var_0_0,
						content_check_function = function (arg_8_0)
							return arg_8_0.stance_bar.active
						end
					},
					{
						pass_type = "texture",
						style_id = "stance_bar_glow",
						texture_id = "stance_bar_glow",
						retained_mode = var_0_0,
						content_check_function = function (arg_9_0)
							return arg_9_0.stance_bar.active
						end
					},
					{
						style_id = "stance_bar",
						pass_type = "texture_uv_dynamic_color_uvs_size_offset",
						content_id = "stance_bar",
						content_check_function = function (arg_10_0)
							return arg_10_0.active
						end,
						dynamic_function = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
							local var_11_0 = arg_11_0.bar_value
							local var_11_1 = arg_11_1.uv_start_pixels
							local var_11_2 = arg_11_1.uv_scale_pixels
							local var_11_3 = var_11_1 + var_11_2 * var_11_0
							local var_11_4 = arg_11_1.uvs
							local var_11_5 = arg_11_1.scale_axis
							local var_11_6 = arg_11_1.offset_scale
							local var_11_7 = arg_11_1.offset

							var_11_4[1][var_11_5] = 1 - var_11_3 / (var_11_1 + var_11_2)
							arg_11_2[var_11_5] = var_11_3

							return arg_11_0.color, var_11_4, arg_11_2, var_11_7
						end
					},
					{
						style_id = "ammo_text_1",
						pass_type = "text",
						text_id = "ammo_text_1",
						retained_mode = var_0_0,
						content_check_function = function (arg_12_0)
							return not arg_12_0.stance_bar.active and arg_12_0.has_data
						end
					},
					{
						style_id = "ammo_text_2",
						pass_type = "text",
						text_id = "ammo_text_2",
						retained_mode = var_0_0,
						content_check_function = function (arg_13_0)
							return not arg_13_0.stance_bar.active and arg_13_0.has_data
						end
					},
					{
						pass_type = "texture",
						style_id = "ammo_divider",
						texture_id = "ammo_divider",
						retained_mode = var_0_0,
						content_check_function = function (arg_14_0)
							return not arg_14_0.stance_bar.active and arg_14_0.has_data and arg_14_0.ammo_text_1 ~= "" and arg_14_0.ammo_text_2 ~= ""
						end
					}
				}
			},
			content = {
				ammo_divider = "weapon_generic_icons_ammodivider",
				stance_bar_fg = "stance_bar_frame",
				selected = false,
				ammo_text_1 = "ammo_text",
				icon_lit = "weapon_icon_empty",
				stance_bar_glow = "stance_bar_glow_orange",
				default_icon = "consumables_frame_bg_lit",
				stance_bar_lit = "stance_bar_frame_lit",
				icon = "weapon_icon_empty",
				ammo_text_2 = "ammo_text",
				background = var_1_2 and "consumables_frame_bg_lit" or "weapon_generic_icons_bg",
				background_lit = var_1_2 and "consumables_frame_lit" or "weapon_generic_icons_bg_lit",
				stance_bar = {
					bar_value = 0,
					active = false,
					texture_id = "stance_bar_orange"
				}
			},
			style = {
				ammo_divider = {
					color = {
						255,
						255,
						255,
						255
					},
					scenegraph_id = var_1_11
				},
				background = {
					color = {
						255,
						255,
						255,
						255
					},
					scenegraph_id = var_1_5
				},
				background_lit = {
					color = {
						0,
						255,
						255,
						255
					},
					scenegraph_id = var_1_5
				},
				icon = {
					color = {
						255,
						255,
						255,
						255
					},
					scenegraph_id = var_1_7
				},
				icon_lit = {
					color = {
						0,
						255,
						255,
						255
					},
					scenegraph_id = var_1_7
				},
				default_icon = {
					color = {
						150,
						255,
						255,
						255
					},
					scenegraph_id = var_1_6
				},
				stance_bar_fg = {
					offset = {
						0,
						0,
						3
					},
					color = {
						255,
						255,
						255,
						255
					},
					scenegraph_id = var_1_8
				},
				stance_bar_lit = {
					offset = {
						0,
						0,
						4
					},
					color = {
						0,
						255,
						255,
						255
					},
					scenegraph_id = var_1_8
				},
				stance_bar_glow = {
					offset = {
						0,
						0,
						0
					},
					color = {
						0,
						255,
						255,
						255
					},
					scenegraph_id = var_1_10
				},
				stance_bar = {
					uv_start_pixels = 0,
					uv_scale_pixels = 67,
					offset_scale = 1,
					scale_axis = 2,
					scenegraph_id = var_1_9,
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
					uvs = {
						{
							0,
							0
						},
						{
							1,
							1
						}
					}
				},
				ammo_text_1 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "right",
					font_size = 26,
					pixel_perfect = false,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("white", 255),
					scenegraph_id = var_1_12
				},
				ammo_text_2 = {
					vertical_alignment = "center",
					dynamic_font = true,
					horizontal_alignment = "left",
					font_size = 26,
					pixel_perfect = false,
					font_type = "hell_shark",
					text_color = Colors.get_color_table_with_alpha("white", 150),
					scenegraph_id = var_1_13
				}
			},
			scenegraph_id = var_1_3
		}
	end

	return var_1_0
end

return {
	scenegraph_definition = var_0_1,
	inventory_entry_definitions = var_0_6(#var_0_4),
	widget_definitions = var_0_3,
	bar_textures = var_0_2
}
