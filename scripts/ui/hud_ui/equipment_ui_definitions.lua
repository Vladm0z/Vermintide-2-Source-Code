-- chunkname: @scripts/ui/hud_ui/equipment_ui_definitions.lua

local num = 1920
local num_2 = 1080
local flag = true
local tbl = {
	46,
	46
}
local tbl_2 = {
	40,
	40
}
local tbl_3 = {
	root_parent = {
		scale = "hud_scale_fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			num,
			num_2
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
			num,
			num_2
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
			num,
			num_2
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
		size = tbl
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

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local num = arg_1_0 - 1
	local num_2 = 24
	local var_1_2 = tbl[1]
	local num_3 = var_1_2 * arg_1_1 + num_2 * (arg_1_1 - 1)
	local tbl_3 = {
		num * (var_1_2 + num_2),
		0,
		-30
	}
	local tbl_4 = {
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
					retained_mode = flag
				},
				{
					pass_type = "rotated_texture",
					style_id = "secondary_texture_icon",
					texture_id = "secondary_texture_icon",
					retained_mode = flag,
					content_check_function = function (self, arg_2_1)
						-- function 2
						return self.secondary_texture_icon
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "secondary_texture_icon_glow",
					texture_id = "secondary_texture_icon_glow",
					retained_mode = flag,
					content_check_function = function (self, arg_3_1)
						-- function 3
						return self.secondary_texture_icon
					end
				},
				{
					pass_type = "texture",
					style_id = "secondary_texture_bg",
					texture_id = "secondary_texture_bg",
					retained_mode = flag,
					content_check_function = function (self, arg_4_1)
						-- function 4
						return self.secondary_texture_icon
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_frame",
					texture_id = "texture_frame",
					retained_mode = flag
				},
				{
					pass_type = "texture",
					style_id = "texture_background",
					texture_id = "texture_background",
					retained_mode = flag
				},
				{
					pass_type = "texture",
					style_id = "texture_selected",
					texture_id = "texture_selected",
					retained_mode = flag,
					content_check_function = function (self, arg_5_1)
						-- function 5
						return self.selected
					end
				},
				{
					pass_type = "rotated_texture",
					style_id = "texture_highlight",
					texture_id = "texture_highlight",
					retained_mode = flag
				},
				{
					style_id = "input_text",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = flag
				},
				{
					style_id = "input_text_shadow",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = flag
				},
				{
					style_id = "use_count_text",
					pass_type = "text",
					text_id = "use_count_text",
					retained_mode = flag,
					content_check_function = function (self, arg_6_1)
						-- function 6
						return self.has_additional_slots
					end
				},
				{
					style_id = "use_count_text_shadow",
					pass_type = "text",
					text_id = "use_count_text",
					retained_mode = flag,
					content_check_function = function (self, arg_7_1)
						-- function 7
						return self.has_additional_slots
					end
				},
				{
					style_id = "can_swap_text",
					pass_type = "text",
					text_id = "can_swap_text",
					retained_mode = flag,
					content_check_function = function (self, arg_8_1)
						-- function 8
						return self.can_swap
					end
				},
				{
					style_id = "can_swap_text_shadow",
					pass_type = "text",
					text_id = "can_swap_text",
					retained_mode = flag,
					content_check_function = function (self, arg_9_1)
						-- function 9
						return self.can_swap
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
				texture_size = tbl_2,
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
					tbl_2[1] * 0.75,
					tbl_2[2] * 0.75
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
					tbl_2[1] * 0.75 * 0.5,
					tbl_2[2] * 0.75 * 0.5
				}
			},
			secondary_texture_icon_glow = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				texture_size = {
					tbl_2[1] * 0.75,
					tbl_2[2] * 0.75
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
					tbl_2[1] * 0.75 * 0.5,
					tbl_2[2] * 0.75 * 0.5
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
					tbl[1],
					tbl[2]
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
				texture_size = tbl_2,
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
		offset = tbl_3
	}
end

local tbl_4 = {
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
local tbl_5 = {
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
local tbl_6 = {
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
local tbl_7 = {
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
local num_3 = 4 * (tbl[1] + 24)

function create_inventory_panel(arg_10_0, arg_10_1)
	-- function 10
	local size = tbl_3[arg_10_1].size
	local tbl = {
		0,
		0,
		1
	}
	local var_10_2
	local var_10_3 = flag

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
				texture_size = size
			}
		},
		offset = tbl,
		scenegraph_id = arg_10_1
	}
end

local tbl_8 = {
	background_panel = create_inventory_panel("hud_inventory_panel", "background_panel"),
	background_panel_bg = UIWidgets.create_simple_texture("hud_inventory_panel_bg", "background_panel_bg", nil, flag),
	extra_storage_bg = {
		scenegraph_id = "slot",
		offset = {
			num_3,
			22,
			-31
		},
		element = {
			passes = {
				{
					pass_type = "rotated_texture",
					style_id = "texture",
					texture_id = "texture",
					retained_mode = flag
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
local tbl_9 = {
	ammo_text_clip = UIWidgets.create_simple_text("-", "ammo_text_clip", nil, nil, tbl_4, nil, flag),
	ammo_text_remaining = UIWidgets.create_simple_text("-", "ammo_text_remaining", nil, nil, tbl_5, nil, flag),
	ammo_text_center = UIWidgets.create_simple_text("/", "ammo_text_center", nil, nil, tbl_6, nil, flag),
	ammo_background = UIWidgets.create_simple_texture("loot_objective_bg", "ammo_background", nil, flag, {
		200,
		255,
		255,
		255
	}),
	overcharge_background = UIWidgets.create_simple_texture("hud_inventory_charge_icon", "overcharge_background", nil, flag),
	overcharge = UIWidgets.create_simple_uv_texture("hud_inventory_charge_icon", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "overcharge", nil, flag),
	reload_tip_text = UIWidgets.create_simple_text("", "reload_ui", nil, Colors.get_color_table_with_alpha("white", 0), tbl_7, nil, false, true)
}
local slots = InventorySettings.slots
local tbl_10 = {}
local tbl_11 = {
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
				retained_mode = flag
			},
			{
				pass_type = "texture",
				style_id = "texture_selected",
				texture_id = "texture_selected",
				retained_mode = flag
			},
			{
				style_id = "input_text",
				pass_type = "text",
				text_id = "input_text",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 11
					return self.can_reload
				end
			},
			{
				style_id = "input_text_shadow",
				pass_type = "text",
				text_id = "input_text",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 12
					return self.can_reload
				end
			},
			{
				pass_type = "texture",
				style_id = "reload_icon",
				texture_id = "reload_icon",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 13
					local can_reload = self.can_reload

					can_reload = can_reload or self.is_exhausted

					return can_reload
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

for i = 1, #slots do
	local var_0_17 = slots[i]
	local hud_index = var_0_17.hud_index

	if not hud_index then
		local var_0_19

		if var_0_17.name == "slot_career_skill_weapon" then
			var_0_19 = tbl_11
		else
			var_0_19 = fn(hud_index, 6)
		end

		tbl_10[#tbl_10 + 1] = var_0_19
	end
end

local num_4 = 2
local tbl_12 = {}

for j = 1, num_4 do
	tbl_12[j] = {
		scenegraph_id = "slot",
		offset = {
			num_3,
			30 + j * (tbl_2[2] + 4),
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
				texture_size = tbl_2,
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
				-- function 14
				arg_14_2.content.visible = true
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				-- function 15
				local num = 255 * math.easeOutCubic(arg_15_3)

				arg_15_2.style.text.text_color[1] = num
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 2.3,
			end_progress = 2.6,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				return
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				-- function 18
				local num = 255 * (1 - math.easeOutCubic(arg_18_3))

				arg_18_2.style.text.text_color[1] = num
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				arg_19_2.content.visible = false
			end
		}
	}
}

return {
	slot_size = tbl,
	NUM_SLOTS = #tbl_10,
	scenegraph_definition = tbl_3,
	widget_definitions = tbl_8,
	ammo_widget_definitions = tbl_9,
	slot_widget_definitions = tbl_10,
	extra_storage_icon_definitions = tbl_12,
	animations_definitions = animations_definitions
}
