-- chunkname: @scripts/ui/views/player_inventory_ui_definitions.lua

require("scripts/settings/inventory_settings")

local flag = true
local tbl = {
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
local tbl_2 = {
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
local tbl_3 = {}
local weapon_slots = InventorySettings.weapon_slots
local tbl_4 = {
	slot_healthkit = 1,
	slot_grenade = 3,
	slot_potion = 2
}

local function fn(arg_1_0)
	-- function 1
	local tbl_2 = {}

	for i = 1, arg_1_0 do
		local name = weapon_slots[i].name
		local flag_2

		flag_2 = not tbl_4[name] and true and false

		local str = "inventory_entry_" .. i
		local str_2 = "inventory_entry_root_" .. i
		local str_3 = "inventory_entry_background_" .. i
		local str_4 = "inventory_entry_default_icon_" .. i
		local str_5 = "inventory_entry_icon_" .. i
		local str_6 = "inventory_entry_stance_bar_" .. i
		local str_7 = "inventory_entry_stance_bar_fill_" .. i
		local str_8 = "inventory_entry_stance_bar_glow_" .. i
		local str_9 = "inventory_entry_ammo_text_root_" .. i
		local str_10 = "inventory_entry_ammo_text_1_" .. i
		local str_11 = "inventory_entry_ammo_text_2_" .. i

		tbl[str_2] = {
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
		tbl[str] = {
			horizontal_alignment = "right",
			parent = str_2,
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

		if not flag_2 then
			tbl[str_3] = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				parent = str,
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
			tbl[str_5] = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				parent = str_3,
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
		elseif name == "slot_healthkit" then
			tbl[str_3] = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				parent = str,
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
			tbl[str_5] = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				parent = str_3,
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
			tbl[str_3] = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				parent = str,
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
			tbl[str_5] = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				parent = str_3,
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

		if name == "slot_healthkit" then
			tbl[str_4] = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				parent = str,
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
			tbl[str_4] = {
				vertical_alignment = "center",
				horizontal_alignment = "right",
				parent = str,
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

		tbl[str_6] = {
			horizontal_alignment = "right",
			parent = str_3,
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
		tbl[str_7] = {
			parent = str_6,
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
		tbl[str_8] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			parent = str_7,
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
		tbl[str_9] = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			parent = str_5,
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
		tbl[str_10] = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			parent = str_9,
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
		tbl[str_11] = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			parent = str_9,
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

		local tbl_3 = {
			element = {
				passes = {
					{
						pass_type = "texture",
						style_id = "background",
						texture_id = "background",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 2
							return self.has_data
						end
					},
					{
						pass_type = "texture",
						style_id = "background_lit",
						texture_id = "background_lit",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 3
							return self.has_data
						end
					},
					{
						pass_type = "texture",
						style_id = "default_icon",
						texture_id = "default_icon",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 4
							return not self.has_data
						end
					},
					{
						pass_type = "texture",
						style_id = "icon",
						texture_id = "icon",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 5
							return self.has_data
						end
					},
					{
						pass_type = "texture",
						style_id = "icon_lit",
						texture_id = "icon_lit",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 6
							return self.has_data
						end
					},
					{
						pass_type = "texture",
						style_id = "stance_bar_fg",
						texture_id = "stance_bar_fg",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 7
							return self.stance_bar.active
						end
					},
					{
						pass_type = "texture",
						style_id = "stance_bar_lit",
						texture_id = "stance_bar_lit",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 8
							return self.stance_bar.active
						end
					},
					{
						pass_type = "texture",
						style_id = "stance_bar_glow",
						texture_id = "stance_bar_glow",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 9
							return self.stance_bar.active
						end
					},
					{
						style_id = "stance_bar",
						pass_type = "texture_uv_dynamic_color_uvs_size_offset",
						content_id = "stance_bar",
						content_check_function = function (self)
							-- function 10
							return self.active
						end,
						dynamic_function = function (self, arg_11_1, arg_11_2, arg_11_3)
							-- function 11
							local bar_value = self.bar_value
							local uv_start_pixels = arg_11_1.uv_start_pixels
							local uv_scale_pixels = arg_11_1.uv_scale_pixels
							local num = uv_start_pixels + uv_scale_pixels * bar_value
							local uvs = arg_11_1.uvs
							local scale_axis = arg_11_1.scale_axis
							local offset_scale = arg_11_1.offset_scale
							local offset = arg_11_1.offset

							uvs[1][scale_axis] = 1 - num / (uv_start_pixels + uv_scale_pixels)
							arg_11_2[scale_axis] = num

							return self.color, uvs, arg_11_2, offset
						end
					},
					{
						style_id = "ammo_text_1",
						pass_type = "text",
						text_id = "ammo_text_1",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 12
							return not not self.stance_bar.active or self.has_data
						end
					},
					{
						style_id = "ammo_text_2",
						pass_type = "text",
						text_id = "ammo_text_2",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 13
							return not not self.stance_bar.active or self.has_data
						end
					},
					{
						pass_type = "texture",
						style_id = "ammo_divider",
						texture_id = "ammo_divider",
						retained_mode = flag,
						content_check_function = function (self)
							-- function 14
							return self.ammo_text_1 == "" or self.ammo_text_2 ~= "" or not not self.stance_bar.active or not self.has_data
						end
					}
				}
			}
		}
		local tbl_5 = {
			ammo_divider = "weapon_generic_icons_ammodivider",
			stance_bar_fg = "stance_bar_frame",
			selected = false,
			ammo_text_1 = "ammo_text",
			icon_lit = "weapon_icon_empty",
			stance_bar_glow = "stance_bar_glow_orange",
			default_icon = "consumables_frame_bg_lit",
			stance_bar_lit = "stance_bar_frame_lit",
			icon = "weapon_icon_empty",
			ammo_text_2 = "ammo_text"
		}
		local flag_3

		flag_3 = not flag_2 and "consumables_frame_bg_lit" and "weapon_generic_icons_bg"
		tbl_5.background = flag_3

		local flag_4

		flag_4 = not flag_2 and "consumables_frame_lit" and "weapon_generic_icons_bg_lit"
		tbl_5.background_lit = flag_4
		tbl_5.stance_bar = {
			bar_value = 0,
			active = false,
			texture_id = "stance_bar_orange"
		}
		tbl_3.content = tbl_5
		tbl_3.style = {
			ammo_divider = {
				color = {
					255,
					255,
					255,
					255
				},
				scenegraph_id = str_9
			},
			background = {
				color = {
					255,
					255,
					255,
					255
				},
				scenegraph_id = str_3
			},
			background_lit = {
				color = {
					0,
					255,
					255,
					255
				},
				scenegraph_id = str_3
			},
			icon = {
				color = {
					255,
					255,
					255,
					255
				},
				scenegraph_id = str_5
			},
			icon_lit = {
				color = {
					0,
					255,
					255,
					255
				},
				scenegraph_id = str_5
			},
			default_icon = {
				color = {
					150,
					255,
					255,
					255
				},
				scenegraph_id = str_4
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
				scenegraph_id = str_6
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
				scenegraph_id = str_6
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
				scenegraph_id = str_8
			},
			stance_bar = {
				uv_start_pixels = 0,
				uv_scale_pixels = 67,
				offset_scale = 1,
				scale_axis = 2,
				scenegraph_id = str_7,
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
				scenegraph_id = str_10
			},
			ammo_text_2 = {
				vertical_alignment = "center",
				dynamic_font = true,
				horizontal_alignment = "left",
				font_size = 26,
				pixel_perfect = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 150),
				scenegraph_id = str_11
			}
		}
		tbl_3.scenegraph_id = str
		tbl_2[i] = tbl_3
	end

	return tbl_2
end

return {
	scenegraph_definition = tbl,
	inventory_entry_definitions = fn(#weapon_slots),
	widget_definitions = tbl_3,
	bar_textures = tbl_2
}
