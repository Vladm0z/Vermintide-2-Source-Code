-- chunkname: @scripts/ui/hud_ui/gamepad_equipment_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = true
local var_0_3 = {
	70,
	64
}
local var_0_4 = {
	55,
	55
}
local var_0_5 = {
	root = {
		scale = "hud_scale_fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	hud_base = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			0,
			60,
			0
		}
	},
	gamepad_icon_base = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "right",
		size = {
			119,
			137
		},
		position = {
			0,
			60,
			10
		}
	},
	hud_brush = {
		parent = "hud_base",
		position = {
			-25,
			-60,
			0
		}
	},
	health_bar_frame = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			20,
			10
		},
		size = {
			576,
			36
		}
	},
	health_bar_frame_bg = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			32,
			-10
		},
		size = {
			560,
			19
		}
	},
	screen_bottom_pivot = {
		parent = "root",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	pivot = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			69,
			4
		},
		size = {
			0,
			0
		}
	},
	background_panel = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			624,
			139
		}
	},
	background_panel_bg = {
		vertical_alignment = "bottom",
		parent = "background_panel",
		horizontal_alignment = "center",
		position = {
			0,
			10,
			-5
		},
		size = {
			464,
			29
		}
	},
	crosshair_pivot = {
		vertical_alignment = "center",
		parent = "screen_bottom_pivot",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	weapon_slot = {
		vertical_alignment = "bottom",
		parent = "hud_base",
		horizontal_alignment = "right",
		position = {
			-50,
			0,
			100
		},
		size = {
			240,
			60
		}
	},
	slot = {
		vertical_alignment = "bottom",
		parent = "hud_base",
		horizontal_alignment = "right",
		position = {
			-270,
			70,
			100
		},
		size = var_0_3
	},
	ammo_background = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			-90,
			40,
			10
		},
		size = {
			383,
			86
		}
	},
	ammo_text_center = {
		vertical_alignment = "bottom",
		parent = "ammo_background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			5
		},
		size = {
			0,
			20
		}
	},
	ammo_text_clip = {
		vertical_alignment = "bottom",
		parent = "ammo_text_center",
		horizontal_alignment = "right",
		position = {
			-5,
			0,
			1
		},
		size = {
			20,
			20
		}
	},
	ammo_text_remaining = {
		vertical_alignment = "bottom",
		parent = "ammo_text_center",
		horizontal_alignment = "left",
		position = {
			10,
			0,
			1
		},
		size = {
			20,
			20
		}
	},
	overcharge_background = {
		vertical_alignment = "center",
		parent = "ammo_background",
		horizontal_alignment = "center",
		position = {
			15,
			0,
			1
		},
		size = {
			80,
			26
		}
	},
	overcharge = {
		vertical_alignment = "center",
		parent = "overcharge_background",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			1
		},
		size = {
			80,
			26
		}
	},
	reload_ui = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			-220,
			3
		},
		size = {
			0,
			0
		}
	}
}

if not IS_WINDOWS then
	var_0_5.root.scale = "hud_fit"
	var_0_5.root.is_root = nil
	var_0_5.screen.scale = "hud_fit"
end

local function var_0_6(arg_1_0)
	local var_1_0 = UIFrameSettings.menu_frame_06

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "melee_weapon_texture",
					texture_id = "melee_weapon_texture_id",
					retained_mode = var_0_2,
					content_check_function = function (arg_2_0, arg_2_1)
						return arg_2_0.wielded_slot == "melee"
					end
				},
				{
					pass_type = "texture",
					style_id = "melee_weapon_texture_glow",
					texture_id = "melee_weapon_texture_glow_id",
					retained_mode = var_0_2,
					content_check_function = function (arg_3_0, arg_3_1)
						return arg_3_0.wielded_slot == "melee"
					end
				},
				{
					pass_type = "texture",
					style_id = "deselected_weapon",
					texture_id = "deselected_weapon_texture_id",
					retained_mode = var_0_2,
					content_check_function = function (arg_4_0, arg_4_1)
						return arg_4_0.wielded_slot ~= "melee" and arg_4_0.wielded_slot ~= "ranged"
					end
				},
				{
					pass_type = "texture",
					style_id = "ranged_weapon_texture",
					texture_id = "ranged_weapon_texture_id",
					retained_mode = var_0_2,
					content_check_function = function (arg_5_0, arg_5_1)
						return arg_5_0.wielded_slot == "ranged"
					end
				},
				{
					pass_type = "texture",
					style_id = "ranged_weapon_texture_glow",
					texture_id = "ranged_weapon_texture_glow_id",
					retained_mode = var_0_2,
					content_check_function = function (arg_6_0, arg_6_1)
						return arg_6_0.wielded_slot == "ranged"
					end
				},
				{
					pass_type = "texture",
					style_id = "switch",
					texture_id = "switch_id",
					retained_mode = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "wield_switch",
					texture_id = "wield_switch_id",
					retained_mode = var_0_2,
					content_check_function = function (arg_7_0, arg_7_1)
						return arg_7_0.wield_switch_id
					end
				},
				{
					style_id = "input_text",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_8_0, arg_8_1)
						arg_8_0.gamepad_active = Managers.input:is_device_active("gamepad")

						return not arg_8_0.gamepad_active
					end
				},
				{
					style_id = "input_text_shadow",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_9_0, arg_9_1)
						return not arg_9_0.gamepad_active
					end
				}
			}
		},
		content = {
			melee_weapon_texture_id = "hud_icon_melee",
			is_expired = false,
			visible = true,
			input_text = "",
			selected = false,
			deselected_weapon_texture_id = "hud_icon_melee",
			ranged_weapon_texture_glow_id = "hud_icon_ranged_glow",
			melee_weapon_texture_glow_id = "hud_icon_melee_glow",
			highlight_weapon_texture_id = "hud_inventory_slot_selection",
			background_texture_id = "hud_inventory_slot_bg_01",
			ranged_weapon_texture_id = "hud_icon_ranged",
			switch_id = "button_y",
			weapon_frame = var_1_0.texture
		},
		style = {
			weapon_frame = {
				texture_size = var_1_0.texture_size,
				texture_sizes = var_1_0.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				size = {
					300,
					60
				},
				offset = {
					0,
					0,
					-31
				}
			},
			background = {
				color = {
					255,
					30,
					30,
					30
				},
				offset = {
					0,
					0,
					-33
				},
				size = {
					240,
					60
				}
			},
			melee_weapon_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					58,
					49
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					10,
					-20,
					1
				}
			},
			melee_weapon_texture_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					68,
					59
				},
				color = {
					255,
					243,
					159,
					0
				},
				offset = {
					10,
					-20,
					0
				}
			},
			ranged_weapon_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					57,
					58
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					10,
					-20,
					1
				}
			},
			ranged_weapon_texture_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					67,
					68
				},
				color = {
					255,
					243,
					159,
					0
				},
				offset = {
					10,
					-20,
					0
				}
			},
			switch = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					58,
					40
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					40,
					-50,
					1
				}
			},
			highlight_weapon_texture = {
				vertical_alignment = "bottom",
				angle = 0,
				horizontal_alignment = "center",
				pivot = {
					18,
					23
				},
				color = {
					192,
					255,
					255,
					255
				},
				texture_size = {
					277,
					20
				},
				offset = {
					14,
					4,
					-32
				}
			},
			deselected_weapon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					58,
					49
				},
				color = {
					255,
					63,
					63,
					63
				},
				offset = {
					10,
					-20,
					1
				}
			},
			wield_switch = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					40,
					-50,
					1
				}
			},
			input_text = {
				word_wrap = false,
				font_size = 24,
				localize = false,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					22,
					18
				},
				offset = {
					170,
					-40,
					4
				}
			},
			input_text_shadow = {
				word_wrap = false,
				font_size = 24,
				localize = false,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					22,
					18
				},
				offset = {
					172,
					-42,
					3
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local function var_0_7(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0 - 1
	local var_10_1 = 0
	local var_10_2 = var_0_3[1]
	local var_10_3 = var_10_2 * arg_10_1 + var_10_1 * (arg_10_1 - 1)
	local var_10_4 = {
		(var_10_0 - 1) * (var_10_2 + var_10_1),
		0,
		-30
	}
	local var_10_5 = {
		255,
		36,
		215,
		231
	}
	local var_10_6 = {
		slot_healthkit = "hud_icon_heal_01",
		slot_grenade = "hud_icon_bomb_01",
		slot_potion = "hud_icon_heal_02"
	}

	return {
		scenegraph_id = "slot",
		element = {
			passes = {
				{
					style_id = "input_text",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_11_0, arg_11_1)
						return not Managers.input:is_device_active("gamepad") and arg_11_0.is_filled
					end
				},
				{
					style_id = "input_text_shadow",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_12_0, arg_12_1)
						return not Managers.input:is_device_active("gamepad") and arg_12_0.is_filled
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_icon",
					texture_id = "texture_icon",
					retained_mode = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "secondary_texture_icon",
					texture_id = "secondary_texture_icon",
					retained_mode = var_0_2,
					content_check_function = function (arg_13_0, arg_13_1)
						return arg_13_0.secondary_texture_icon
					end
				},
				{
					pass_type = "texture",
					style_id = "secondary_texture_icon_glow",
					texture_id = "secondary_texture_icon_glow",
					retained_mode = var_0_2,
					content_check_function = function (arg_14_0, arg_14_1)
						return arg_14_0.secondary_texture_icon
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_selected",
					texture_id = "texture_selected",
					retained_mode = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "texture_selected_up_arrow",
					texture_id = "texture_selected_up_arrow",
					retained_mode = var_0_2,
					content_check_function = function (arg_15_0, arg_15_1)
						return arg_15_0.texture_arrow_up_enabled and arg_15_0.is_filled
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_selected_left_arrow",
					texture_id = "texture_selected_left_arrow",
					retained_mode = var_0_2,
					content_check_function = function (arg_16_0, arg_16_1)
						return arg_16_0.texture_arrow_left_enabled and arg_16_0.is_filled
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_selected_right_arrow",
					texture_id = "texture_selected_right_arrow",
					retained_mode = var_0_2,
					content_check_function = function (arg_17_0, arg_17_1)
						return arg_17_0.texture_arrow_right_enabled and arg_17_0.is_filled
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_selected_up_arrow_glow",
					texture_id = "texture_selected_up_arrow_glow",
					retained_mode = var_0_2,
					content_check_function = function (arg_18_0, arg_18_1)
						return arg_18_0.texture_arrow_up_enabled and arg_18_0.selected
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_selected_left_arrow_glow",
					texture_id = "texture_selected_left_arrow_glow",
					retained_mode = var_0_2,
					content_check_function = function (arg_19_0, arg_19_1)
						return arg_19_0.texture_arrow_left_enabled and arg_19_0.selected
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_selected_right_arrow_glow",
					texture_id = "texture_selected_right_arrow_glow",
					retained_mode = var_0_2,
					content_check_function = function (arg_20_0, arg_20_1)
						return arg_20_0.texture_arrow_right_enabled and arg_20_0.selected
					end
				},
				{
					style_id = "use_count_text",
					pass_type = "text",
					text_id = "use_count_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_21_0, arg_21_1)
						return arg_21_0.is_filled and arg_21_0.has_additional_slots
					end
				},
				{
					style_id = "use_count_text_shadow",
					pass_type = "text",
					text_id = "use_count_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_22_0, arg_22_1)
						return arg_22_0.is_filled and arg_22_0.has_additional_slots
					end
				},
				{
					style_id = "can_swap_text",
					pass_type = "text",
					text_id = "can_swap_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_23_0, arg_23_1)
						return arg_23_0.is_filled and arg_23_0.can_swap
					end
				},
				{
					style_id = "can_swap_text_shadow",
					pass_type = "text",
					text_id = "can_swap_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_24_0, arg_24_1)
						return arg_24_0.is_filled and arg_24_0.can_swap
					end
				}
			}
		},
		content = {
			texture_selected_left_arrow = "hud_icon_left",
			is_expired = false,
			texture_selected_right_arrow = "hud_icon_right",
			input_text = "-",
			selected = false,
			texture_selected_up_arrow_glow = "hud_icon_up_glow",
			texture_background = "hud_inventory_slot_bg_01",
			use_count_text = "",
			texture_selected = "hud_inventory_slot_selection",
			texture_selected_up_arrow = "hud_icon_up",
			texture_selected_right_arrow_glow = "hud_icon_right_glow",
			visible = true,
			has_additional_slots = false,
			texture_frame = "hud_inventory_slot",
			can_swap_text = "+",
			texture_icon = "journal_icon_02",
			is_filled = false,
			texture_arrow = "console_consumable_icon_arrow_02",
			texture_selected_left_arrow_glow = "hud_icon_left_glow",
			texture_highlight = "hud_inventory_slot_small_pickup",
			console_hud_index = arg_10_0,
			empty_slot_texture = var_10_6[InventorySettings.slots_by_console_hud_index[arg_10_0].name],
			texture_arrow_left_enabled = arg_10_0 == 2,
			texture_arrow_up_enabled = arg_10_0 == 3,
			texture_arrow_right_enabled = arg_10_0 == 4
		},
		style = {
			input_text = {
				vertical_alignment = "top",
				font_size = 18,
				localize = false,
				horizontal_alignment = "center",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-2,
					24,
					12
				}
			},
			input_text_shadow = {
				vertical_alignment = "top",
				font_size = 18,
				localize = false,
				horizontal_alignment = "center",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					0,
					22,
					11
				}
			},
			use_count_text = {
				vertical_alignment = "bottom",
				font_size = 18,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-4,
					0,
					12
				}
			},
			use_count_text_shadow = {
				vertical_alignment = "bottom",
				font_size = 18,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-2,
					-2,
					11
				}
			},
			can_swap_text = {
				vertical_alignment = "bottom",
				font_size = 18,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-4,
					20,
					12
				}
			},
			can_swap_text_shadow = {
				vertical_alignment = "bottom",
				font_size = 18,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-2,
					18,
					11
				}
			},
			texture_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = var_0_4,
				color = {
					0,
					128,
					128,
					128
				},
				offset = {
					0,
					0,
					5
				}
			},
			secondary_texture_icon = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					var_0_4[1] * 0.6,
					var_0_4[2] * 0.6
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					5,
					0,
					5
				}
			},
			secondary_texture_icon_glow = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					var_0_4[1] * 0.6,
					var_0_4[2] * 0.6
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					5,
					0,
					4
				}
			},
			texture_selected_left_arrow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					32,
					32
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					0,
					-32,
					5
				}
			},
			texture_selected_up_arrow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					32,
					32
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					0,
					-32,
					5
				}
			},
			texture_selected_right_arrow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					32,
					32
				},
				color = {
					255,
					128,
					128,
					128
				},
				offset = {
					0,
					-32,
					5
				}
			},
			texture_selected_left_arrow_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					32,
					32
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					-32,
					6
				}
			},
			texture_selected_up_arrow_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					32,
					32
				},
				color = {
					128,
					255,
					255,
					255
				},
				offset = {
					0,
					-32,
					6
				}
			},
			texture_selected_right_arrow_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					32,
					32
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					-32,
					6
				}
			},
			texture_frame = {
				size = {
					var_0_3[1],
					var_0_3[2]
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
			texture_highlight = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				angle = math.pi,
				pivot = {
					18,
					23
				},
				texture_size = {
					36,
					46
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					6
				}
			},
			texture_arrow_left = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					15,
					40
				},
				color = {
					0,
					128,
					128,
					128
				},
				offset = {
					-37,
					0,
					1
				}
			},
			texture_arrow_up = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = math.pi * 0.5,
				pivot = {
					7.5,
					20
				},
				texture_size = {
					15,
					40
				},
				color = {
					0,
					128,
					128,
					128
				},
				offset = {
					0,
					37,
					1
				}
			},
			texture_arrow_right = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = math.pi,
				pivot = {
					7.5,
					20
				},
				texture_size = {
					15,
					40
				},
				color = {
					0,
					128,
					128,
					128
				},
				offset = {
					37,
					0,
					1
				}
			},
			texture_arrow_selected_left = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					15,
					40
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					-37,
					0,
					2
				}
			},
			texture_arrow_selected_up = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					15,
					40
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					37,
					2
				}
			},
			texture_arrow_selected_right = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					15,
					40
				},
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					37,
					0,
					2
				}
			},
			texture_arrow_selected = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				angle = math.pi,
				pivot = {
					18,
					23
				},
				texture_size = {
					36,
					46
				},
				color = {
					0,
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
			texture_selected = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					6
				},
				texture_size = {
					55,
					55
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			texture_background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = var_0_4,
				color = {
					0,
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
			rect_background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				rect_size = var_0_4,
				color = {
					255,
					0,
					0,
					0
				}
			},
			texture_empty_slot = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = var_0_4,
				color = {
					128,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		offset = var_10_4
	}
end

local var_0_8 = {
	word_wrap = false,
	font_size = 65,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	default_text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		-5,
		0,
		2
	}
}
local var_0_9 = {
	word_wrap = false,
	font_size = 40,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	default_text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		3,
		-12,
		2
	}
}
local var_0_10 = {
	word_wrap = false,
	font_size = 40,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	default_text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		-12,
		2
	}
}

local function var_0_11(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6, arg_25_7, arg_25_8)
	local var_25_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_25_0)

	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					retained_mode = arg_25_3,
					content_check_function = arg_25_8
				}
			}
		},
		content = {
			texture_id = arg_25_0
		},
		style = {
			texture_id = {
				texture_size = var_25_0.size,
				color = arg_25_4 or {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				},
				masked = arg_25_2,
				horizontal_alignment = arg_25_6,
				vertical_alignment = arg_25_7
			}
		},
		offset = {
			0,
			0,
			arg_25_5 or 0
		},
		scenegraph_id = arg_25_1
	}
end

local function var_0_12(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = ButtonTextureByName("x", "xb1")
	local var_26_1 = var_26_0.texture
	local var_26_2 = var_26_0.size

	return {
		element = {
			passes = {
				{
					texture_id = "minigun_id",
					style_id = "minigun",
					pass_type = "texture",
					retained_mode = arg_26_2,
					content_check_function = function (arg_27_0, arg_27_1)
						arg_27_0.using_career_skill_weapon = false
						arg_27_0.visible = false

						local var_27_0 = Managers.player:local_player()
						local var_27_1 = var_27_0 and var_27_0.player_unit

						if not ALIVE[var_27_1] then
							return false
						end

						local var_27_2 = ScriptUnit.extension(var_27_1, "career_system")

						arg_27_0.visible = (var_27_2 and var_27_2:career_name()) == "dr_engineer"

						local var_27_3, var_27_4 = var_27_2:current_ability_cooldown()

						arg_27_0.on_cooldown = var_27_3 / var_27_4 ~= 0

						local var_27_5 = ScriptUnit.extension(var_27_1, "inventory_system")

						arg_27_0.using_career_skill_weapon = var_27_5 and var_27_5:get_wielded_slot_name() == "slot_career_skill_weapon"

						local var_27_6 = ScriptUnit.extension(var_27_1, "buff_system")

						arg_27_0.is_reloading = var_27_6 and var_27_6:has_buff_type("bardin_engineer_pump_buff")

						local var_27_7, var_27_8 = Managers.time:time_and_delta("game")
						local var_27_9 = arg_27_0.time + var_27_8

						arg_27_0.time = arg_27_0.is_reloading and var_27_9 or 0
						arg_27_0.using_gamepad = Managers.input:is_device_active("gamepad")

						return not arg_27_0.using_career_skill_weapon and arg_27_0.visible
					end
				},
				{
					pass_type = "texture",
					style_id = "reload_button",
					texture_id = "reload_button_id",
					retained_mode = arg_26_2,
					content_check_function = function (arg_28_0, arg_28_1)
						return arg_28_0.on_cooldown and arg_28_0.reload_button_id and arg_28_0.using_career_skill_weapon and arg_28_0.using_gamepad
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_effect",
					texture_id = "ability_effect",
					content_check_function = function (arg_29_0, arg_29_1)
						return not arg_29_0.on_cooldown and arg_29_0.using_career_skill_weapon and arg_29_0.visible
					end
				},
				{
					texture_id = "reload_icon_frame_id",
					style_id = "reload_icon_frame",
					pass_type = "texture",
					retained_mode = arg_26_2,
					content_check_function = function (arg_30_0, arg_30_1)
						return not arg_30_0.on_cooldown and arg_30_0.using_career_skill_weapon and arg_30_0.visible
					end
				},
				{
					texture_id = "reload_id",
					style_id = "reload",
					pass_type = "texture",
					retained_mode = arg_26_2,
					content_check_function = function (arg_31_0, arg_31_1)
						return arg_31_0.using_career_skill_weapon and arg_31_0.visible
					end
				},
				{
					style_id = "reload_icon",
					pass_type = "texture",
					texture_id = "reload_icon_id",
					retained_mode = arg_26_2,
					content_check_function = function (arg_32_0, arg_32_1)
						return arg_32_0.using_career_skill_weapon and arg_32_0.visible and arg_32_0.is_reloading
					end,
					content_change_function = function (arg_33_0, arg_33_1)
						arg_33_1.color[1] = 160 + -math.cos(arg_33_0.time * 2 * math.pi) * 95
					end
				},
				{
					style_id = "reload_mask",
					pass_type = "texture",
					texture_id = "reload_mask_id",
					retained_mode = arg_26_2,
					content_check_function = function (arg_34_0, arg_34_1)
						return arg_34_0.visible and arg_34_0.is_reloading
					end,
					content_change_function = function (arg_35_0, arg_35_1)
						arg_35_0.reload_mask_id = arg_35_0.using_career_skill_weapon and "reload_icon_mask" or "minigun_icon_mask"
					end
				},
				{
					style_id = "reload_overlay",
					pass_type = "texture",
					texture_id = "reload_overlay_id",
					retained_mode = arg_26_2,
					content_check_function = function (arg_36_0, arg_36_1)
						return arg_36_0.visible and arg_36_0.is_reloading
					end,
					content_change_function = function (arg_37_0, arg_37_1)
						local var_37_0 = arg_37_0.time % 1

						arg_37_1.offset[2] = math.lerp(-137, 137, var_37_0)
					end
				},
				{
					style_id = "input_text",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_38_0)
						return arg_38_0.on_cooldown and arg_38_0.visible and not arg_38_0.using_gamepad and arg_38_0.using_career_skill_weapon
					end,
					content_change_function = function (arg_39_0, arg_39_1)
						local var_39_0 = Managers.input:get_service("Player"):get_keymapping("weapon_reload", "win32")

						if not var_39_0 then
							arg_39_0.input_text = ""

							return
						end

						local var_39_1 = var_39_0[1]
						local var_39_2 = var_39_0[2]
						local var_39_3 = ""

						if var_39_2 ~= UNASSIGNED_KEY then
							local var_39_4 = var_39_1 == "mouse" and Mouse or Keyboard

							var_39_3 = var_39_4.button_locale_name(var_39_2) or var_39_4.button_name(var_39_2) or Localize("lb_unknown")
							var_39_3 = Utf8.upper(var_39_3)
						end

						arg_39_0.input_text = var_39_3
					end
				},
				{
					style_id = "input_text_shadow",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_40_0)
						return arg_40_0.on_cooldown and arg_40_0.visible and not arg_40_0.using_gamepad and arg_40_0.using_career_skill_weapon
					end
				}
			}
		},
		content = {
			time = 0,
			reload_icon_frame_id = "lit_frame_engineer",
			minigun_id = "rotarygun_bg",
			reload_overlay_id = "glowtexture_mask_red",
			input_text = "",
			reload_mask_id = "minigun_icon_mask",
			ability_effect = "gamepad_ability_effect_cog",
			reload_icon_id = "icon_reload",
			reload_id = "reload_bg",
			reload_button_id = var_26_1
		},
		style = {
			input_text = {
				word_wrap = false,
				font_size = 24,
				localize = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					22,
					18
				},
				offset = {
					48,
					150,
					105
				}
			},
			input_text_shadow = {
				word_wrap = false,
				font_size = 24,
				localize = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					22,
					18
				},
				offset = {
					46,
					148,
					104
				}
			},
			minigun = {
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
				texture_size = {
					119,
					137
				}
			},
			ability_effect = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					152,
					240
				},
				offset = {
					15,
					-10,
					100
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			reload = {
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
					0
				},
				texture_size = {
					119,
					137
				}
			},
			reload_button = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					140,
					20
				},
				texture_size = var_26_2
			},
			reload_icon = {
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
					0
				},
				texture_size = {
					119,
					137
				}
			},
			reload_icon_frame = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-1,
					2,
					101
				},
				texture_size = {
					118,
					136
				}
			},
			reload_mask = {
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
					0
				},
				texture_size = {
					119,
					137
				}
			},
			reload_overlay = {
				vertical_alignment = "center",
				masked = true,
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
					10
				},
				texture_size = {
					119,
					137
				}
			}
		},
		offset = {
			-2,
			0,
			arg_26_1 or 0
		},
		scenegraph_id = arg_26_0
	}
end

local var_0_13 = {
	ability_base = var_0_11("ability_base", "hud_base", nil, var_0_2, nil, 5, "right", "bottom"),
	hud_brushstroke = UIWidgets.create_simple_atlas_texture("hud_brushstroke", "hud_brush", nil, var_0_2, nil, nil, "right", "bottom"),
	weapon_slot = var_0_6("weapon_slot"),
	extra_storage_bg = {
		scenegraph_id = "slot",
		offset = {
			1 * (var_0_3[1] + 0),
			22,
			-100
		},
		element = {
			passes = {
				{
					pass_type = "rotated_texture",
					style_id = "texture",
					texture_id = "texture",
					retained_mode = var_0_2
				}
			}
		},
		content = {
			texture = "loot_objective_bg"
		},
		style = {
			texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				pivot = {
					191.5,
					31.5
				},
				angle = math.pi / 2,
				texture_size = {
					383,
					63
				},
				color = {
					0,
					255,
					255,
					255
				}
			}
		}
	}
}
local var_0_14 = {
	word_wrap = false,
	localize = false,
	font_size = 30,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 0),
	default_text_color = Colors.get_color_table_with_alpha("white", 0),
	offset = {
		0,
		0,
		2
	}
}
local var_0_15 = {
	engineer_base = var_0_12("gamepad_icon_base", 10)
}
local var_0_16 = {
	health_bar_frame = UIWidgets.create_simple_texture("console_hp_bar_frame", "health_bar_frame", nil, var_0_2),
	background_panel_bg = UIWidgets.create_simple_texture("console_hp_bar_background", "health_bar_frame_bg", nil, var_0_2)
}
local var_0_17 = {
	ammo_text_clip = UIWidgets.create_simple_text("-", "ammo_text_clip", nil, nil, var_0_8, nil, var_0_2),
	ammo_text_remaining = UIWidgets.create_simple_text("-", "ammo_text_remaining", nil, nil, var_0_9, nil, var_0_2),
	ammo_text_center = UIWidgets.create_simple_text("/", "ammo_text_center", nil, nil, var_0_10, nil, var_0_2),
	overcharge_background = UIWidgets.create_simple_texture("hud_inventory_charge_icon", "overcharge_background", nil, var_0_2),
	overcharge = UIWidgets.create_simple_uv_texture("hud_inventory_charge_icon", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "overcharge", nil, var_0_2),
	reload_tip_text = UIWidgets.create_simple_text("", "reload_ui", nil, Colors.get_color_table_with_alpha("white", 0), var_0_14, nil, var_0_2, false)
}
local var_0_18 = InventorySettings.slots
local var_0_19 = {}

for iter_0_0 = 1, #var_0_18 do
	local var_0_20 = var_0_18[iter_0_0].console_hud_index

	if var_0_20 then
		var_0_19[#var_0_19 + 1] = var_0_7(var_0_20, 6)
	end
end

local var_0_21 = 2
local var_0_22 = {}

for iter_0_1 = 1, var_0_21 do
	local var_0_23 = 2
	local var_0_24 = 0
	local var_0_25 = var_0_3[1]

	var_0_22[iter_0_1] = {
		scenegraph_id = "slot",
		offset = {
			(var_0_23 - 1) * (var_0_25 + var_0_24),
			55 + iter_0_1 * (var_0_4[2] - 10),
			5
		},
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_icon",
					texture_id = "texture_icon"
				},
				{
					pass_type = "texture",
					style_id = "texture_glow",
					texture_id = "texture_glow"
				}
			}
		},
		content = {
			t_until_fade = 0,
			visible = true,
			texture_glow = "hud_icon_bomb_01_glow",
			texture_icon = "hud_icon_bomb_01"
		},
		style = {
			texture_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					6
				},
				texture_size = var_0_4,
				color = {
					0,
					255,
					255,
					255
				}
			},
			texture_glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					5
				},
				texture_size = var_0_4,
				color = {
					0,
					255,
					255,
					255
				}
			}
		}
	}
end

animations_definitions = {
	show_reload_tip = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
				arg_41_2.content.visible = true
			end,
			update = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
				local var_42_0 = 255 * math.easeOutCubic(arg_42_3)

				arg_42_2.style.text.text_color[1] = var_42_0
			end,
			on_complete = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 2.3,
			end_progress = 2.6,
			init = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
				return
			end,
			update = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
				local var_45_0 = 255 * (1 - math.easeOutCubic(arg_45_3))

				arg_45_2.style.text.text_color[1] = var_45_0
			end,
			on_complete = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				arg_46_2.content.visible = false
			end
		}
	}
}

return {
	slot_size = var_0_3,
	NUM_SLOTS = #var_0_19,
	scenegraph_definition = var_0_5,
	widget_definitions = var_0_13,
	career_widget_definitions = var_0_15,
	frame_definitions = var_0_16,
	ammo_widget_definitions = var_0_17,
	slot_widget_definitions = var_0_19,
	extra_storage_icon_definitions = var_0_22,
	animations_definitions = animations_definitions
}
