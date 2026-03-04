-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_loadout_selection_console_definitions.lua

local var_0_0 = UISettings.game_start_windows.size
local var_0_1 = UISettings.console_menu_scenegraphs
local var_0_2 = {
	48,
	48
}
local var_0_3 = 5
local var_0_4 = 400
local var_0_5 = {
	screen = var_0_1.screen,
	area = var_0_1.area,
	area_left = var_0_1.area_left,
	area_right = var_0_1.area_right,
	area_divider = var_0_1.area_divider,
	background = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		scale = "fit",
		position = {
			0,
			0,
			550
		},
		size = {
			1920,
			1080
		}
	},
	anchor = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		}
	},
	add_loadout_button = {
		vertical_alignment = "bottom",
		parent = "anchor",
		horizontal_alignment = "right",
		position = {
			-180,
			150,
			100
		},
		size = var_0_2
	},
	button = {
		vertical_alignment = "bottom",
		parent = "add_loadout_button",
		horizontal_alignment = "left",
		position = {
			-var_0_2[1] - var_0_3,
			0,
			-5
		},
		size = var_0_2,
		offset = {
			0,
			0,
			0
		}
	},
	context_menu = {
		vertical_alignment = "bottom",
		parent = "button",
		horizontal_alignment = "right",
		position = {
			0,
			var_0_2[2],
			-10
		},
		size = {
			var_0_4,
			475
		},
		offset = {
			0,
			0,
			0
		}
	},
	context_menu_anchor = {
		vertical_alignment = "top",
		parent = "context_menu",
		horizontal_alignment = "left",
		position = {
			10,
			-10,
			1
		},
		size = {
			0,
			0
		}
	},
	icon = {
		vertical_alignment = "top",
		parent = "context_menu_anchor",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			15
		},
		size = var_0_2
	},
	header = {
		vertical_alignment = "top",
		parent = "context_menu_anchor",
		horizontal_alignment = "left",
		position = {
			var_0_2[1] + var_0_3,
			-5,
			15
		}
	},
	equipment_header = {
		vertical_alignment = "top",
		parent = "icon",
		horizontal_alignment = "left",
		position = {
			0,
			-55,
			15
		}
	},
	equipment = {
		vertical_alignment = "top",
		parent = "equipment_header",
		horizontal_alignment = "left",
		position = {
			10,
			-45,
			15
		}
	},
	talents_header = {
		vertical_alignment = "top",
		parent = "equipment",
		horizontal_alignment = "left",
		position = {
			-10,
			-70,
			15
		}
	},
	talents = {
		vertical_alignment = "top",
		parent = "talents_header",
		horizontal_alignment = "left",
		position = {
			5,
			-35,
			15
		}
	},
	cosmetics_header = {
		vertical_alignment = "top",
		parent = "talents",
		horizontal_alignment = "left",
		position = {
			0,
			-60,
			15
		}
	},
	cosmetics = {
		vertical_alignment = "top",
		parent = "cosmetics_header",
		horizontal_alignment = "left",
		position = {
			10,
			-40,
			15
		}
	},
	right_divider = {
		vertical_alignment = "bottom",
		parent = "context_menu",
		horizontal_alignment = "right",
		position = {
			0,
			77,
			15
		},
		size = {
			var_0_4 * 0.5,
			4
		}
	},
	left_divider = {
		vertical_alignment = "bottom",
		parent = "context_menu",
		horizontal_alignment = "left",
		position = {
			0,
			77,
			15
		},
		size = {
			var_0_4 * 0.5,
			4
		}
	},
	bot_checkbox = {
		vertical_alignment = "bottom",
		parent = "context_menu",
		horizontal_alignment = "left",
		size = {
			200,
			50
		},
		position = {
			10,
			10,
			20
		}
	},
	delete_button = {
		vertical_alignment = "bottom",
		parent = "context_menu",
		horizontal_alignment = "right",
		position = {
			-10,
			10,
			15
		},
		size = {
			180,
			50
		}
	},
	delete_button_bar = {
		vertical_alignment = "bottom",
		parent = "delete_button",
		horizontal_alignment = "left",
		size = {
			180,
			50
		},
		position = {
			0,
			0,
			3
		}
	},
	delete_button_bar_edge = {
		vertical_alignment = "center",
		parent = "delete_button_bar",
		horizontal_alignment = "right",
		size = {
			8,
			50
		},
		position = {
			8,
			0,
			4
		}
	},
	talent_tooltip = {
		vertical_alignment = "center",
		parent = "context_menu",
		horizontal_alignment = "left",
		position = {
			-20 - var_0_4,
			170,
			15
		}
	},
	weapon_tooltip = {
		vertical_alignment = "center",
		parent = "context_menu",
		horizontal_alignment = "center",
		position = {
			-20,
			40,
			15
		}
	}
}
local var_0_6 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	area_size = {
		400 - var_0_2[1] - var_0_3 - 10,
		50
	},
	offset = {
		0,
		0,
		0
	}
}
local var_0_7 = {
	font_size = 26,
	upper_case = false,
	localize = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	area_size = {
		400 - var_0_3 - 10,
		50
	},
	offset = {
		0,
		0,
		0
	}
}
local var_0_8 = {
	58,
	58
}
local var_0_9 = 6
local var_0_10 = {
	46.25,
	45.5
}
local var_0_11 = {
	111,
	109.2
}
local var_0_12 = 32
local var_0_13 = {
	"slot_melee",
	"slot_ranged",
	"slot_necklace",
	"slot_ring",
	"slot_trinket_1"
}
local var_0_14 = {
	"slot_hat",
	"slot_skin",
	"slot_frame",
	"slot_pose"
}

local function var_0_15(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = {
		element = {}
	}
	local var_1_1 = {}
	local var_1_2 = {}
	local var_1_3 = {}
	local var_1_4 = arg_1_1 or {
		0,
		0,
		0
	}

	for iter_1_0, iter_1_1 in ipairs(arg_1_2) do
		var_1_1[#var_1_1 + 1] = {
			pass_type = "hotspot",
			style_id = iter_1_1 .. "_hotspot",
			content_id = iter_1_1,
			content_check_function = function(arg_2_0)
				return true
			end
		}
		var_1_1[#var_1_1 + 1] = {
			texture_id = "weapon_frame",
			pass_type = "texture",
			style_id = iter_1_1 .. "_frame"
		}
		var_1_1[#var_1_1 + 1] = {
			texture_id = "equipment_hover_frame",
			pass_type = "texture",
			style_id = iter_1_1 .. "_frame",
			content_check_function = function(arg_3_0, arg_3_1)
				return arg_3_0[iter_1_1].is_hover or arg_3_0[iter_1_1].is_selected
			end
		}
		var_1_1[#var_1_1 + 1] = {
			texture_id = "icon",
			pass_type = "texture",
			style_id = iter_1_1 .. "_icon",
			content_id = iter_1_1,
			content_check_function = function(arg_4_0)
				return arg_4_0.item and arg_4_0.icon
			end
		}
		var_1_1[#var_1_1 + 1] = {
			texture_id = "mask",
			pass_type = "texture",
			style_id = iter_1_1 .. "_mask"
		}
		var_1_1[#var_1_1 + 1] = {
			texture_id = "rarity",
			pass_type = "texture",
			style_id = iter_1_1 .. "_mask",
			content_id = iter_1_1
		}
		var_1_1[#var_1_1 + 1] = {
			style_id = "weapon_tooltip",
			scenegraph_id = "weapon_tooltip",
			pass_type = "item_tooltip",
			item_id = "item",
			content_id = iter_1_1,
			content_check_function = function(arg_5_0)
				return arg_5_0.item and (arg_5_0.is_hover or arg_5_0.is_selected)
			end
		}
		var_1_2[iter_1_1] = {
			rarity = "icon_bg_default",
			no_equipped_item = true,
			is_selected = false
		}
		var_1_3[iter_1_1] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = var_0_10,
			texture_size = var_0_10,
			offset = {
				(iter_1_0 - 1) * (var_0_10[1] + var_0_12),
				0,
				0
			}
		}
		var_1_3[iter_1_1 .. "_hotspot"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = {
				var_0_11[1] * 0.7,
				var_0_11[2] * 0.7
			},
			offset = {
				(iter_1_0 - 1) * (var_0_10[1] + var_0_12),
				0,
				10
			}
		}
		var_1_3[iter_1_1 .. "_icon"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = true,
			area_size = {
				54,
				54
			},
			texture_size = {
				54,
				54
			},
			offset = {
				(iter_1_0 - 1) * (var_0_10[1] + var_0_12),
				0,
				2
			}
		}
		var_1_3[iter_1_1 .. "_mask"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = var_0_10,
			texture_size = var_0_10,
			offset = {
				(iter_1_0 - 1) * (var_0_10[1] + var_0_12),
				0,
				1
			}
		}
		var_1_3[iter_1_1 .. "_frame"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = var_0_11,
			offset = {
				(iter_1_0 - 1) * (var_0_10[1] + var_0_12),
				0,
				1
			}
		}
		var_1_3[iter_1_1 .. "_hover_frame"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = var_0_11,
			offset = {
				(iter_1_0 - 1) * (var_0_10[1] + var_0_12),
				0,
				10
			}
		}
	end

	var_1_2.equipment_hover_frame = "loadout_item_slot_glow_console"
	var_1_2.background = "icon_bg_default"
	var_1_2.mask = "mask_rect"
	var_1_2.weapon_frame = "loadout_item_slot_console"
	var_1_3.weapon_tooltip = {
		draw_downwards = false
	}
	var_1_0.element.passes = var_1_1
	var_1_0.content = var_1_2
	var_1_0.style = var_1_3
	var_1_0.scenegraph_id = arg_1_0
	var_1_0.offset = var_1_4

	return var_1_0
end

local function var_0_16(arg_6_0, arg_6_1)
	local var_6_0 = {
		element = {}
	}
	local var_6_1 = {}
	local var_6_2 = {}
	local var_6_3 = {}
	local var_6_4 = arg_6_1 or {
		0,
		0,
		0
	}
	local var_6_5 = "frame_outer_glow_01"
	local var_6_6 = UIFrameSettings[var_6_5]

	for iter_6_0 = 1, MaxTalentPoints do
		local var_6_7 = "talent_" .. iter_6_0

		var_6_1[#var_6_1 + 1] = {
			texture_id = "talent_frame",
			pass_type = "texture",
			style_id = var_6_7 .. "_frame"
		}
		var_6_1[#var_6_1 + 1] = {
			texture_id = "talent_hover_frame",
			pass_type = "texture_frame",
			style_id = var_6_7 .. "_hover_frame",
			content_check_function = function(arg_7_0, arg_7_1)
				return arg_7_0[var_6_7].is_hover or arg_7_0[var_6_7].is_selected
			end
		}
		var_6_1[#var_6_1 + 1] = {
			pass_type = "hotspot",
			style_id = var_6_7,
			content_id = var_6_7,
			content_check_function = function(arg_8_0)
				return arg_8_0.talent
			end
		}
		var_6_1[#var_6_1 + 1] = {
			texture_id = "icon",
			pass_type = "texture",
			style_id = var_6_7,
			content_id = var_6_7,
			content_check_function = function(arg_9_0)
				return arg_9_0.talent and arg_9_0.icon
			end
		}
		var_6_1[#var_6_1 + 1] = {
			style_id = "talent_tooltip",
			scenegraph_id = "talent_tooltip",
			pass_type = "talent_tooltip",
			talent_id = "talent",
			content_id = var_6_7,
			content_check_function = function(arg_10_0)
				return arg_10_0.talent and (arg_10_0.is_hover or arg_10_0.is_selected)
			end
		}
		var_6_2[var_6_7] = {
			is_selected = false
		}
		var_6_3[var_6_7] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = var_0_8,
			texture_size = var_0_8,
			offset = {
				(iter_6_0 - 1) * (var_0_8[1] + var_0_9),
				0,
				0
			}
		}
		var_6_3[var_6_7 .. "_frame"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = var_0_8,
			offset = {
				(iter_6_0 - 1) * (var_0_8[1] + var_0_9),
				0,
				1
			}
		}
		var_6_3[var_6_7 .. "_hover_frame"] = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			texture_size = var_6_6.texture_size,
			texture_sizes = var_6_6.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				(iter_6_0 - 1) * (var_0_8[1] + var_0_9),
				0,
				0
			},
			area_size = {
				var_0_8[1] * 1.55,
				var_0_8[2] * 1.55
			}
		}
	end

	var_6_2.talent_hover_frame = var_6_6.texture
	var_6_2.talent_frame = "talent_frame"
	var_6_3.talent_tooltip = {
		draw_downwards = false
	}
	var_6_0.element.passes = var_6_1
	var_6_0.content = var_6_2
	var_6_0.style = var_6_3
	var_6_0.scenegraph_id = arg_6_0
	var_6_0.offset = var_6_4

	return var_6_0
end

local function var_0_17(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13, arg_11_14)
	arg_11_3 = arg_11_3 or "button_bg_01"

	local var_11_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_11_3)
	local var_11_1 = arg_11_2 and UIFrameSettings[arg_11_2] or UIFrameSettings.button_frame_01
	local var_11_2 = var_11_1.texture_sizes.corner[1]
	local var_11_3 = arg_11_7 or "button_detail_01"
	local var_11_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_11_3).size
	local var_11_5
	local var_11_6

	if arg_11_8 then
		if type(arg_11_8) == "table" then
			var_11_5 = arg_11_8[1]
			var_11_6 = arg_11_8[2]
		else
			var_11_5 = arg_11_8
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
					content_check_function = function(arg_12_0)
						return arg_12_0.draw_frame
					end
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					pass_type = "rect",
					style_id = "background_rect"
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
					pass_type = "rect",
					style_id = "clicked_rect"
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function(arg_13_0)
						return arg_13_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function(arg_14_0)
						return not arg_14_0.skip_side_detail
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function(arg_15_0)
						return not arg_15_0.skip_side_detail
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_16_0)
						return not arg_16_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_17_0)
						return arg_17_0.button_hotspot.disable_button
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
				},
				{
					texture_id = "bot_equipped_icon",
					style_id = "bot_equipped_icon",
					pass_type = "texture",
					content_check_function = function(arg_18_0, arg_18_1)
						local var_18_0 = Managers.state.game_mode:game_mode_key()

						if not InventorySettings.bot_loadout_allowed_game_modes[var_18_0] then
							return false
						end

						local var_18_1 = arg_18_0.career_name

						return PlayerData.loadout_selection.bot_equipment[var_18_1] == arg_18_0.loadout_index
					end
				}
			}
		},
		content = {
			draw_frame = true,
			hover_glow = "button_state_default",
			background_fade = "button_bg_fade",
			glass = "button_glass_02",
			bot_equipped_icon = "bot_selected_icon",
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
				texture_id = var_11_3,
				skip_side_detail = arg_11_10
			},
			button_hotspot = {},
			title_text = arg_11_4 or "n/a",
			frame = var_11_1.texture,
			background = {
				uvs = {
					{
						0,
						1 - (arg_11_13 and 1 or arg_11_1[2] / var_11_0.size[2])
					},
					{
						arg_11_13 and 1 or arg_11_1[1] / var_11_0.size[1],
						1
					}
				},
				texture_id = arg_11_3
			},
			disable_with_gamepad = arg_11_9
		},
		style = {
			background = {
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
					1
				},
				masked = arg_11_11,
				texture_size = arg_11_13 and {
					arg_11_1[1] * 0.7,
					arg_11_1[2] * 0.7
				} or nil
			},
			background_rect = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				},
				masked = arg_11_11,
				texture_size = arg_11_1
			},
			background_fade = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					var_11_2,
					var_11_2 - 2,
					2
				},
				size = {
					arg_11_1[1] - var_11_2 * 2,
					arg_11_1[2] - var_11_2 * 2
				},
				masked = arg_11_11
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
					var_11_2 - 2,
					3
				},
				size = {
					arg_11_1[1],
					math.min(arg_11_1[2] - 5, 80)
				},
				masked = arg_11_11
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
				font_size = arg_11_5 or 24,
				font_type = arg_11_11 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_11_1[1] - 40,
					arg_11_1[2]
				},
				area_size = arg_11_14,
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
				font_size = arg_11_5 or 24,
				font_type = arg_11_11 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				size = {
					arg_11_1[1] - 40,
					arg_11_1[2]
				},
				area_size = arg_11_14,
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
				font_size = arg_11_5 or 24,
				font_type = arg_11_11 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					arg_11_1[1] - 40,
					arg_11_1[2]
				},
				area_size = arg_11_14,
				offset = {
					22,
					-2,
					5
				}
			},
			frame = {
				texture_size = var_11_1.texture_size,
				texture_sizes = var_11_1.texture_sizes,
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
				},
				masked = arg_11_11
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
					arg_11_1[2] - (var_11_2 + 11),
					4
				},
				size = {
					arg_11_1[1],
					11
				},
				masked = arg_11_11
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
					var_11_2 - 9,
					4
				},
				size = {
					arg_11_1[1],
					11
				},
				masked = arg_11_11
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_11_5 and -var_11_5 or -9,
					arg_11_1[2] / 2 - var_11_4[2] / 2 + (var_11_6 or 0),
					9
				},
				size = {
					var_11_4[1],
					var_11_4[2]
				},
				masked = arg_11_11
			},
			side_detail_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_11_1[1] - var_11_4[1] + (var_11_5 or 9),
					arg_11_1[2] / 2 - var_11_4[2] / 2 + (var_11_6 or 0),
					9
				},
				size = {
					var_11_4[1],
					var_11_4[2]
				},
				masked = arg_11_11
			},
			bot_equipped_icon = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					20,
					20
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
					10
				}
			}
		},
		scenegraph_id = arg_11_0,
		offset = arg_11_12 or {
			0,
			0,
			0
		}
	}
end

local var_0_18
local var_0_19
local var_0_20
local var_0_21
local var_0_22
local var_0_23 = false
local var_0_24 = true
local var_0_25 = false
local var_0_26 = true
local var_0_27 = false
local var_0_28 = {}

for iter_0_0, iter_0_1 in ipairs(InventorySettings.loadouts) do
	if iter_0_1.loadout_type == "custom" then
		var_0_28[#var_0_28 + 1] = var_0_17("button", var_0_2, var_0_18, iter_0_1.loadout_icon, "", var_0_19, var_0_20, var_0_21, var_0_22, var_0_23, var_0_24, var_0_25, {
			(var_0_2[1] + var_0_3) * (iter_0_1.loadout_index - 1),
			0,
			0
		}, var_0_26)
	end
end

local var_0_29 = {
	loadout_frame = UIWidgets.create_rect_with_outer_frame("button", var_0_2, "frame_outer_glow_01", nil, {
		0,
		255,
		255,
		255
	}, {
		220,
		255,
		255,
		255
	}),
	hover_loadout_frame = UIWidgets.create_rect_with_outer_frame("button", var_0_2, "frame_outer_glow_01_white", nil, {
		0,
		255,
		255,
		255
	}, {
		220,
		255,
		255,
		255
	}),
	add_loadout_button = UIWidgets.create_default_button("add_loadout_button", var_0_2, var_0_18, nil, "+", 32, var_0_20, var_0_21, var_0_22, var_0_23, var_0_24, nil, nil, nil, var_0_2)
}
local var_0_30 = {
	context_menu_hotspot = UIWidgets.create_simple_hotspot("context_menu"),
	context_menu_background = UIWidgets.create_simple_texture("button_bg_01", "context_menu", nil, nil, {
		255,
		128,
		128,
		128
	}, {
		0,
		0,
		1
	}),
	context_menu_bg = UIWidgets.create_rect_with_outer_frame("context_menu", var_0_5.context_menu.size, "frame_outer_glow_01", -10, {
		255,
		0,
		0,
		0
	}, {
		220,
		255,
		255,
		255
	}, -20),
	context_menu_bg_white = UIWidgets.create_rect_with_outer_frame("context_menu", var_0_5.context_menu.size, "frame_outer_glow_01_white", -10, {
		255,
		0,
		0,
		0
	}, {
		220,
		255,
		255,
		255
	}, -20),
	icon = UIWidgets.create_simple_texture("icons_placeholder", "icon"),
	header = UIWidgets.create_simple_text("", "header", nil, nil, var_0_6),
	equipment_header = UIWidgets.create_simple_text("hero_window_equipment", "equipment_header", nil, nil, var_0_7),
	equipment = var_0_15("equipment", nil, var_0_13),
	talents_header = UIWidgets.create_simple_text("hero_window_talents", "talents_header", nil, nil, var_0_7),
	talents = var_0_16("talents", nil),
	cosmetics_header = UIWidgets.create_simple_text("hero_window_cosmetics", "cosmetics_header", nil, nil, var_0_7),
	cosmetics = var_0_15("cosmetics", nil, var_0_14),
	right_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "right_divider"),
	left_divider = UIWidgets.create_simple_uv_texture("infoslate_frame_02_horizontal", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "left_divider"),
	bot_checkbox = UIWidgets.create_default_checkbox_button_console("bot_checkbox", var_0_5.bot_checkbox.size, Localize("input_description_equip_for_bot"), 16, {
		description = "This is a descirption",
		title = Localize("input_description_equip_for_bot")
	}, "menu_frame_03_morris", true),
	delete_button = UIWidgets.create_default_button("delete_button", var_0_5.delete_button.size, nil, nil, Localize("input_description_delete_loadout"), nil, nil, nil, nil, var_0_27, var_0_24),
	delete_button_bar_edge = UIWidgets.create_simple_texture("experience_bar_edge_glow", "delete_button_bar_edge"),
	delete_button_bar = UIWidgets.create_simple_uv_texture("experience_bar_fill", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "delete_button_bar")
}
local var_0_31 = {
	background = UIWidgets.create_simple_rect("background", {
		128,
		0,
		0,
		0
	})
}
local var_0_32 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				arg_19_3.render_settings.alpha_multiplier = 0
				arg_19_0.anchor.position[1] = 50
			end,
			update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				local var_20_0 = math.easeOutCubic(arg_20_3)

				arg_20_4.render_settings.alpha_multiplier = var_20_0 * var_20_0
				arg_20_0.anchor.position[1] = 50 - 50 * var_20_0
			end,
			on_complete = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				return
			end
		}
	}
}
local var_0_33 = {
	default = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "special_1",
			priority = 2,
			description_text = "input_description_toggle_loadout_details"
		},
		{
			input_action = "confirm",
			priority = 3,
			description_text = "input_description_select"
		},
		{
			input_action = "refresh",
			priority = 4,
			description_text = "input_description_delete_loadout"
		},
		{
			input_action = "left_stick_press",
			priority = 5,
			description_text = "input_description_equip_for_bot",
			content_check_function = function()
				local var_22_0 = Managers.state.game_mode:game_mode_key()

				return InventorySettings.bot_loadout_allowed_game_modes[var_22_0]
			end
		},
		{
			input_action = "back",
			priority = 6,
			description_text = "input_description_close"
		}
	},
	default_no_delete = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "special_1",
			priority = 2,
			description_text = "input_description_toggle_loadout_details"
		},
		{
			input_action = "confirm",
			priority = 3,
			description_text = "input_description_select"
		},
		{
			input_action = "left_stick_press",
			priority = 4,
			description_text = "input_description_equip_for_bot",
			content_check_function = function()
				local var_23_0 = Managers.state.game_mode:game_mode_key()

				return InventorySettings.bot_loadout_allowed_game_modes[var_23_0]
			end
		},
		{
			input_action = "back",
			priority = 5,
			description_text = "input_description_close"
		}
	},
	details = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "refresh",
			priority = 2,
			description_text = "input_description_delete_loadout"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "menu_back"
		}
	},
	add_loadout = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_add_loadout"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "menu_back"
		}
	},
	add_loadout_no_add = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "menu_back"
		}
	}
}

return {
	widgets = var_0_29,
	loadout_button_widgets = var_0_28,
	gamepad_specific_widgets = var_0_31,
	context_menu_widgets = var_0_30,
	scenegraph_definition = var_0_5,
	animation_definitions = var_0_32,
	button_size = var_0_2,
	button_spacing = var_0_3,
	equipment_slots = var_0_13,
	cosmetic_slots = var_0_14,
	generic_input_actions = var_0_33
}
