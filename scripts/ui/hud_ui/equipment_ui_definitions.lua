-- chunkname: @scripts/ui/hud_ui/equipment_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = true
local var_0_3 = {
	46,
	46
}
local var_0_4 = {
	40,
	40
}
local var_0_5 = {
	root_parent = {
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
	root = {
		parent = "root_parent",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			var_0_0,
			var_0_1
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
			66
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
	slot = {
		vertical_alignment = "bottom",
		parent = "background_panel",
		horizontal_alignment = "left",
		position = {
			149,
			44,
			-8
		},
		size = var_0_3
	},
	ammo_background_parent = {
		vertical_alignment = "bottom",
		parent = "root_parent",
		horizontal_alignment = "right",
		position = {
			-50,
			100,
			10
		},
		size = {
			383,
			86
		}
	},
	ammo_background = {
		vertical_alignment = "bottom",
		parent = "ammo_background_parent",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			0
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

local function var_0_6(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0 - 1
	local var_1_1 = 24
	local var_1_2 = var_0_3[1]
	local var_1_3 = var_1_2 * arg_1_1 + var_1_1 * (arg_1_1 - 1)
	local var_1_4 = {
		var_1_0 * (var_1_2 + var_1_1),
		0,
		-30
	}
	local var_1_5 = {
		255,
		36,
		215,
		231
	}

	return {
		scenegraph_id = "slot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_icon",
					texture_id = "texture_icon",
					retained_mode = var_0_2
				},
				{
					pass_type = "rotated_texture",
					style_id = "secondary_texture_icon",
					texture_id = "secondary_texture_icon",
					retained_mode = var_0_2,
					content_check_function = function (arg_2_0, arg_2_1)
						return arg_2_0.secondary_texture_icon
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "secondary_texture_icon_glow",
					texture_id = "secondary_texture_icon_glow",
					retained_mode = var_0_2,
					content_check_function = function (arg_3_0, arg_3_1)
						return arg_3_0.secondary_texture_icon
					end
				},
				{
					pass_type = "texture",
					style_id = "secondary_texture_bg",
					texture_id = "secondary_texture_bg",
					retained_mode = var_0_2,
					content_check_function = function (arg_4_0, arg_4_1)
						return arg_4_0.secondary_texture_icon
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_frame",
					texture_id = "texture_frame",
					retained_mode = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "texture_background",
					texture_id = "texture_background",
					retained_mode = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "texture_selected",
					texture_id = "texture_selected",
					retained_mode = var_0_2,
					content_check_function = function (arg_5_0, arg_5_1)
						return arg_5_0.selected
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "texture_highlight",
					texture_id = "texture_highlight",
					retained_mode = var_0_2
				},
				{
					style_id = "input_text",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = var_0_2
				},
				{
					style_id = "input_text_shadow",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = var_0_2
				},
				{
					style_id = "use_count_text",
					pass_type = "text",
					text_id = "use_count_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_6_0, arg_6_1)
						return arg_6_0.has_additional_slots
					end
				},
				{
					style_id = "use_count_text_shadow",
					pass_type = "text",
					text_id = "use_count_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_7_0, arg_7_1)
						return arg_7_0.has_additional_slots
					end
				},
				{
					style_id = "can_swap_text",
					pass_type = "text",
					text_id = "can_swap_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_8_0, arg_8_1)
						return arg_8_0.can_swap
					end
				},
				{
					style_id = "can_swap_text_shadow",
					pass_type = "text",
					text_id = "can_swap_text",
					retained_mode = var_0_2,
					content_check_function = function (arg_9_0, arg_9_1)
						return arg_9_0.can_swap
					end
				}
			}
		},
		content = {
			texture_selected = "hud_inventory_slot_selection",
			texture_frame = "hud_inventory_slot",
			can_swap_text = "+",
			input_text = "-",
			selected = false,
			is_expired = false,
			texture_background = "hud_inventory_slot_bg_01",
			texture_icon = "journal_icon_02",
			use_count_text = "",
			visible = false,
			can_swap = false,
			has_additional_slots = false,
			secondary_texture_bg = "hud_inventory_slot_circle",
			use_count = 0,
			texture_highlight = "hud_inventory_slot_small_pickup",
			hud_index = arg_1_0
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
				vertical_alignment = "top",
				font_size = 18,
				localize = false,
				horizontal_alignment = "left",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					1,
					0,
					12
				}
			},
			can_swap_text_shadow = {
				vertical_alignment = "top",
				font_size = 18,
				localize = false,
				horizontal_alignment = "left",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					3,
					-2,
					11
				}
			},
			texture_icon = {
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
					5
				}
			},
			secondary_texture_icon = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					var_0_4[1] * 0.75,
					var_0_4[2] * 0.75
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					10,
					10,
					205
				},
				angle = math.degrees_to_radians(-45),
				pivot = {
					var_0_4[1] * 0.75 * 0.5,
					var_0_4[2] * 0.75 * 0.5
				}
			},
			secondary_texture_icon_glow = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					var_0_4[1] * 0.75,
					var_0_4[2] * 0.75
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					10,
					10,
					204
				},
				angle = math.degrees_to_radians(-45),
				pivot = {
					var_0_4[1] * 0.75 * 0.5,
					var_0_4[2] * 0.75 * 0.5
				}
			},
			secondary_texture_bg = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					30,
					30
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					10,
					10,
					202
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
					4
				}
			},
			texture_selected = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				offset = {
					0,
					4,
					4
				},
				texture_size = {
					38,
					22
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
			}
		},
		offset = var_1_4
	}
end

local var_0_7 = {
	word_wrap = false,
	font_size = 72,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	default_text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		-5,
		-8,
		2
	}
}
local var_0_8 = {
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
		0,
		2
	}
}
local var_0_9 = {
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
		0,
		2
	}
}
local var_0_10 = {
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
local var_0_11 = 4 * (var_0_3[1] + 24)

function create_inventory_panel(arg_10_0, arg_10_1)
	local var_10_0 = var_0_5[arg_10_1].size
	local var_10_1 = {
		0,
		0,
		1
	}
	local var_10_2
	local var_10_3 = var_0_2

	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture",
					retained_mode = var_10_3
				}
			}
		},
		content = {
			texture_id = arg_10_0
		},
		style = {
			texture_id = {
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
				masked = var_10_2,
				texture_size = var_10_0
			}
		},
		offset = var_10_1,
		scenegraph_id = arg_10_1
	}
end

local var_0_12 = {
	background_panel = create_inventory_panel("hud_inventory_panel", "background_panel"),
	background_panel_bg = UIWidgets.create_simple_texture("hud_inventory_panel_bg", "background_panel_bg", nil, var_0_2),
	extra_storage_bg = {
		scenegraph_id = "slot",
		offset = {
			var_0_11,
			22,
			-31
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
local var_0_13 = {
	ammo_text_clip = UIWidgets.create_simple_text("-", "ammo_text_clip", nil, nil, var_0_7, nil, var_0_2),
	ammo_text_remaining = UIWidgets.create_simple_text("-", "ammo_text_remaining", nil, nil, var_0_8, nil, var_0_2),
	ammo_text_center = UIWidgets.create_simple_text("/", "ammo_text_center", nil, nil, var_0_9, nil, var_0_2),
	ammo_background = UIWidgets.create_simple_texture("loot_objective_bg", "ammo_background", nil, var_0_2, {
		200,
		255,
		255,
		255
	}),
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
	reload_tip_text = UIWidgets.create_simple_text("", "reload_ui", nil, Colors.get_color_table_with_alpha("white", 0), var_0_10, nil, false, true)
}
local var_0_14 = InventorySettings.slots
local var_0_15 = {}
local var_0_16 = {
	scenegraph_id = "background_panel",
	offset = {
		0,
		0,
		1
	},
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "texture_icon",
				texture_id = "texture_icon",
				retained_mode = var_0_2
			},
			{
				pass_type = "texture",
				style_id = "texture_selected",
				texture_id = "texture_selected",
				retained_mode = var_0_2
			},
			{
				style_id = "input_text",
				pass_type = "text",
				text_id = "input_text",
				retained_mode = var_0_2,
				content_check_function = function (arg_11_0)
					return arg_11_0.can_reload
				end
			},
			{
				style_id = "input_text_shadow",
				pass_type = "text",
				text_id = "input_text",
				retained_mode = var_0_2,
				content_check_function = function (arg_12_0)
					return arg_12_0.can_reload
				end
			},
			{
				pass_type = "texture",
				style_id = "reload_icon",
				texture_id = "reload_icon",
				retained_mode = var_0_2,
				content_check_function = function (arg_13_0)
					return arg_13_0.can_reload or arg_13_0.is_exhausted
				end
			}
		}
	},
	content = {
		reload_icon = "hud_ability_cog_reload",
		visible = false,
		input_text = "-",
		selected = false,
		texture_selected = "hud_ability_cog_selected",
		can_reload = false,
		texture_icon = "hud_ability_cog_icon",
		hud_index = InventorySettings.slots_by_name.slot_career_skill_weapon.hud_index
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
				263.5,
				25,
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
				263.5,
				25,
				11
			}
		},
		texture_icon = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			offset = {
				28,
				19.5,
				3
			},
			texture_size = {
				33,
				32
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		texture_selected = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			offset = {
				18,
				9,
				2
			},
			texture_size = {
				53,
				53
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		reload_icon = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			offset = {
				-31,
				21,
				0
			},
			texture_size = {
				29,
				29
			},
			color = {
				255,
				255,
				255,
				255
			}
		}
	}
}

for iter_0_0 = 1, #var_0_14 do
	local var_0_17 = var_0_14[iter_0_0]
	local var_0_18 = var_0_17.hud_index

	if var_0_18 then
		local var_0_19

		if var_0_17.name == "slot_career_skill_weapon" then
			var_0_19 = var_0_16
		else
			var_0_19 = var_0_6(var_0_18, 6)
		end

		var_0_15[#var_0_15 + 1] = var_0_19
	end
end

local var_0_20 = 2
local var_0_21 = {}

for iter_0_1 = 1, var_0_20 do
	var_0_21[iter_0_1] = {
		scenegraph_id = "slot",
		offset = {
			var_0_11,
			30 + iter_0_1 * (var_0_4[2] + 4),
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
			init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				arg_14_2.content.visible = true
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				local var_15_0 = 255 * math.easeOutCubic(arg_15_3)

				arg_15_2.style.text.text_color[1] = var_15_0
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 2.3,
			end_progress = 2.6,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				local var_18_0 = 255 * (1 - math.easeOutCubic(arg_18_3))

				arg_18_2.style.text.text_color[1] = var_18_0
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				arg_19_2.content.visible = false
			end
		}
	}
}

return {
	slot_size = var_0_3,
	NUM_SLOTS = #var_0_15,
	scenegraph_definition = var_0_5,
	widget_definitions = var_0_12,
	ammo_widget_definitions = var_0_13,
	slot_widget_definitions = var_0_15,
	extra_storage_icon_definitions = var_0_21,
	animations_definitions = animations_definitions
}
