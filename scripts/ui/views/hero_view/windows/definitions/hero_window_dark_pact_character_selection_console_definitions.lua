-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_dark_pact_character_selection_console_definitions.lua

local var_0_0 = {
	1920,
	1080
}
local var_0_1 = {
	screen = {
		scale = "fit",
		size = var_0_0,
		position = {
			0,
			0,
			UILayer.default + 100
		}
	},
	bottom_panel = {
		vertical_alignment = "bottom",
		scale = "fit_width",
		size = {
			1920,
			79
		},
		position = {
			0,
			0,
			UILayer.default + 101
		}
	},
	left_side_root = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			1080
		},
		position = {
			0,
			0,
			1
		}
	},
	selection_anchor = {
		vertical_alignment = "top",
		parent = "left_side_root",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-40,
			-140,
			2
		}
	},
	select_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			370,
			70
		},
		position = {
			0,
			25,
			3
		}
	},
	pactsworn_name = {
		vertical_alignment = "center",
		parent = "left_side_root",
		horizontal_alignment = "left",
		size = {
			768,
			50
		},
		position = {
			110,
			0,
			1
		}
	},
	pactsworn_stat_1 = {
		vertical_alignment = "center",
		parent = "pactsworn_name",
		horizontal_alignment = "left",
		size = {
			768,
			50
		},
		position = {
			50,
			-85,
			2
		}
	},
	pactsworn_stat_1_icon = {
		vertical_alignment = "center",
		parent = "pactsworn_stat_1",
		horizontal_alignment = "left",
		size = {
			32,
			32
		},
		position = {
			-42,
			10,
			2
		}
	},
	pactsworn_stat_2 = {
		vertical_alignment = "center",
		parent = "pactsworn_name",
		horizontal_alignment = "left",
		size = {
			768,
			50
		},
		position = {
			50,
			-115,
			2
		}
	},
	pactsworn_stat_2_icon = {
		vertical_alignment = "center",
		parent = "pactsworn_stat_2",
		horizontal_alignment = "left",
		size = {
			32,
			32
		},
		position = {
			-42,
			10,
			2
		}
	},
	pactsworn_description = {
		vertical_alignment = "center",
		parent = "pactsworn_name",
		horizontal_alignment = "left",
		size = {
			576,
			80
		},
		position = {
			0,
			-175,
			2
		}
	},
	equipment_skin = {
		vertical_alignment = "center",
		parent = "left_side_root",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			160,
			-280,
			2
		}
	},
	weapon_tooltip = {
		vertical_alignment = "center",
		parent = "equipment_skin",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			15
		}
	}
}
local var_0_2 = {
	font_size = 52,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		10
	}
}
local var_0_3 = {
	55.5,
	54.6
}
local var_0_4 = {
	148,
	145.6
}
local var_0_5 = {
	331.20000000000005,
	94.4
}

local function var_0_6(arg_1_0, arg_1_1, arg_1_2)
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

	var_1_1[#var_1_1 + 1] = {
		pass_type = "hotspot",
		style_id = arg_1_2 .. "_hotspot",
		content_id = arg_1_2,
		content_check_function = function(arg_2_0)
			return true
		end
	}
	var_1_1[#var_1_1 + 1] = {
		texture_id = "weapon_frame",
		pass_type = "texture",
		style_id = arg_1_2 .. "_frame"
	}
	var_1_1[#var_1_1 + 1] = {
		texture_id = "equipment_hover_frame",
		pass_type = "texture",
		style_id = arg_1_2 .. "_frame",
		content_check_function = function(arg_3_0, arg_3_1)
			local var_3_0 = arg_3_0[arg_1_2]

			return var_3_0.highlight or var_3_0.is_hover
		end
	}
	var_1_1[#var_1_1 + 1] = {
		texture_id = "icon",
		pass_type = "texture",
		style_id = arg_1_2 .. "_icon",
		content_id = arg_1_2,
		content_check_function = function(arg_4_0)
			return arg_4_0.item and arg_4_0.icon
		end
	}
	var_1_1[#var_1_1 + 1] = {
		texture_id = "mask",
		pass_type = "texture",
		style_id = arg_1_2 .. "_mask"
	}
	var_1_1[#var_1_1 + 1] = {
		texture_id = "rarity",
		pass_type = "texture",
		style_id = arg_1_2 .. "_mask",
		content_id = arg_1_2
	}
	var_1_1[#var_1_1 + 1] = {
		style_id = "weapon_tooltip",
		scenegraph_id = "weapon_tooltip",
		pass_type = "item_tooltip",
		item_id = "item",
		content_id = arg_1_2,
		content_check_function = function(arg_5_0)
			return arg_5_0.item and (arg_5_0.is_hover or arg_5_0.is_selected)
		end
	}

	local var_1_5 = "title_bg" .. arg_1_2

	var_1_1[#var_1_1 + 1] = {
		pass_type = "texture_uv",
		content_id = var_1_5,
		style_id = var_1_5
	}

	local var_1_6 = "title_bg_effect" .. arg_1_2

	var_1_1[#var_1_1 + 1] = {
		pass_type = "texture",
		texture_id = var_1_6,
		style_id = var_1_6,
		content_check_function = function(arg_6_0)
			local var_6_0 = arg_6_0[arg_1_2]

			return var_6_0.highlight or var_6_0.is_hover
		end
	}

	local var_1_7 = "title_text" .. arg_1_2

	var_1_1[#var_1_1 + 1] = {
		pass_type = "text",
		text_id = var_1_7,
		style_id = var_1_7,
		content_check_function = function(arg_7_0)
			local var_7_0 = arg_7_0[arg_1_2]

			return var_7_0.item and not var_7_0.highlight and not var_7_0.is_hover
		end,
		content_change_function = function(arg_8_0, arg_8_1)
			local var_8_0 = arg_8_0[arg_1_2].item.data.item_type

			arg_8_0[var_1_7] = arg_8_0.is_dark_pact and "dark_pact_" .. var_8_0 or var_8_0
		end
	}

	local var_1_8 = "title_text_selected" .. arg_1_2

	var_1_1[#var_1_1 + 1] = {
		pass_type = "text",
		text_id = var_1_7,
		style_id = var_1_8,
		content_check_function = function(arg_9_0)
			local var_9_0 = arg_9_0[arg_1_2]

			return var_9_0.item and (var_9_0.highlight or var_9_0.is_hover)
		end,
		content_change_function = function(arg_10_0, arg_10_1)
			local var_10_0 = arg_10_0[arg_1_2].item.data.item_type

			arg_10_0[var_1_7] = arg_10_0.is_dark_pact and "dark_pact_" .. var_10_0 or var_10_0
		end
	}

	local var_1_9 = "title_shadow_text" .. arg_1_2

	var_1_1[#var_1_1 + 1] = {
		pass_type = "text",
		text_id = var_1_7,
		style_id = var_1_9,
		content_check_function = function(arg_11_0)
			return arg_11_0[arg_1_2].item
		end
	}

	local var_1_10 = "sub_title_text" .. arg_1_2

	var_1_1[#var_1_1 + 1] = {
		pass_type = "text",
		text_id = var_1_10,
		style_id = var_1_10,
		content_check_function = function(arg_12_0)
			return arg_12_0[arg_1_2].item
		end,
		content_change_function = function(arg_13_0, arg_13_1)
			local var_13_0 = arg_13_0[arg_1_2].item
			local var_13_1, var_13_2 = UIUtils.get_ui_information_from_item(var_13_0)

			arg_13_0[var_1_10] = var_13_2
		end
	}

	local var_1_11 = "sub_title_shadow_text" .. arg_1_2

	var_1_1[#var_1_1 + 1] = {
		pass_type = "text",
		text_id = var_1_10,
		style_id = var_1_11,
		content_check_function = function(arg_14_0)
			return arg_14_0[arg_1_2].item
		end
	}
	var_1_2[arg_1_2] = {
		rarity = "icon_bg_default",
		no_equipped_item = true,
		is_selected = false
	}
	var_1_2[var_1_5] = {
		texture_id = "item_slot_side_fade",
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
	}
	var_1_2[var_1_6] = "item_slot_side_effect"
	var_1_2[var_1_7] = Localize("not_assigned")
	var_1_2[var_1_10] = Localize("not_assigned")
	var_1_2.slot_name = arg_1_2
	var_1_3[arg_1_2] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		area_size = var_0_3,
		texture_size = var_0_3,
		offset = {
			0,
			0,
			0
		}
	}
	var_1_3[arg_1_2 .. "_hotspot"] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		area_size = {
			var_0_4[1] * 0.7,
			var_0_4[2] * 0.7
		},
		offset = {
			0,
			0,
			10
		}
	}
	var_1_3[arg_1_2 .. "_icon"] = {
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
			0,
			0,
			2
		}
	}
	var_1_3[arg_1_2 .. "_mask"] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		area_size = var_0_3,
		texture_size = var_0_3,
		offset = {
			0,
			0,
			1
		}
	}
	var_1_3[arg_1_2 .. "_frame"] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_0_4,
		offset = {
			0,
			0,
			1
		}
	}
	var_1_3[arg_1_2 .. "_hover_frame"] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = var_0_4,
		offset = {
			0,
			0,
			10
		}
	}
	var_1_3[var_1_5] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		size = var_0_5,
		texture_size = var_0_5,
		color = {
			255,
			0,
			0,
			0
		},
		offset = {
			0,
			-var_0_5[2] / 2,
			-5
		}
	}
	var_1_3[var_1_6] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		size = var_0_5,
		texture_size = var_0_5,
		color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			0,
			-var_0_5[2] / 2,
			-4
		}
	}
	var_1_3[var_1_7] = {
		font_size = 30,
		upper_case = true,
		localize = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		font_type = "hell_shark_header",
		size = var_0_5,
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			var_0_4[1] * 0.5 - 14,
			-var_0_5[2] * 0.5 - 16,
			5
		}
	}
	var_1_3[var_1_8] = {
		font_size = 30,
		upper_case = true,
		localize = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		font_type = "hell_shark_header",
		size = var_0_5,
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			var_0_4[1] * 0.5 - 14,
			-var_0_5[2] * 0.5 - 16,
			5
		}
	}
	var_1_3[var_1_9] = {
		font_size = 30,
		upper_case = true,
		localize = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		font_type = "hell_shark_header",
		size = var_0_5,
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			var_0_4[1] * 0.5 - 14 + 2,
			-var_0_5[2] * 0.5 - 16 - 2,
			4
		}
	}
	var_1_3[var_1_10] = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		localize = true,
		font_size = 20,
		font_type = "hell_shark",
		size = var_0_5,
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			var_0_4[1] * 0.5 - 14,
			-var_0_5[2] * 0.5 - 50,
			5
		}
	}
	var_1_3[var_1_11] = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		localize = true,
		font_size = 20,
		font_type = "hell_shark",
		size = var_0_5,
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			var_0_4[1] * 0.5 - 14 + 2,
			-var_0_5[2] * 0.5 - 52,
			4
		}
	}
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

local var_0_7 = {
	font_size = 24,
	upper_case = false,
	localize = false,
	use_shadow = false,
	word_wrap = false,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = false,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("light_gray", 255),
	offset = {
		0,
		0,
		10
	}
}
local var_0_8 = table.clone(var_0_7)

var_0_8.offset = {
	2,
	-2,
	9
}
var_0_8.text_color = Colors.get_color_table_with_alpha("black", 255)

local var_0_9 = table.clone(var_0_7)

var_0_9.dynamic_font_size_word_wrap = true
var_0_9.word_wrap = true
var_0_9.use_shadow = true

local var_0_10 = true
local var_0_11 = {
	pactsworn_name = UIWidgets.create_simple_text("PACTSWORN NAME", "pactsworn_name", nil, nil, var_0_2),
	name_separator = UIWidgets.create_simple_uv_texture("radial_chat_bg_line_horz", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "pactsworn_name", nil, nil, Colors.get_color_table_with_alpha("font_button_normal", 255), {
		0,
		-14,
		2
	}, nil, {
		var_0_1.pactsworn_name.size[1],
		4
	}),
	equipment_skin = var_0_6("equipment_skin", nil, "slot_skin"),
	pactsworn_stat_1 = UIWidgets.create_simple_text("stat_1", "pactsworn_stat_1", nil, nil, var_0_7),
	pactsworn_stat_shadow_1 = UIWidgets.create_simple_text("stat_1", "pactsworn_stat_1", nil, nil, var_0_8),
	pactsworn_stat_1_icon = UIWidgets.create_simple_texture("icons_placeholder", "pactsworn_stat_1_icon"),
	pactsworn_stat_2 = UIWidgets.create_simple_text("stat_2", "pactsworn_stat_2", nil, nil, var_0_7),
	pactsworn_stat_shadow_2 = UIWidgets.create_simple_text("stat_2", "pactsworn_stat_2", nil, nil, var_0_8),
	pactsworn_stat_2_icon = UIWidgets.create_simple_texture("icons_placeholder", "pactsworn_stat_2_icon"),
	pactsworn_description = UIWidgets.create_simple_text("pactsworn_description", "pactsworn_description", nil, nil, var_0_9)
}
local var_0_12 = {
	default = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select_pactsworn"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	},
	select_inventory = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select_inventory"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_back"
		}
	},
	hero_unavailable = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 2,
			description_text = "input_description_close"
		}
	},
	dlc_unavailable = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "menu_store_purchase_button_unlock"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_back"
		}
	}
}
local var_0_13 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				arg_15_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				local var_16_0 = math.easeOutCubic(arg_16_3)

				arg_16_4.render_settings.alpha_multiplier = var_16_0
				arg_16_0.left_side_root.local_position[1] = arg_16_1.left_side_root.position[1] + -100 * (1 - var_16_0)
			end,
			on_complete = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 1,
			init = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				arg_18_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				local var_19_0 = math.easeOutCubic(arg_19_3)

				arg_19_4.render_settings.alpha_multiplier = 1 - var_19_0
				arg_19_0.left_side_root.local_position[1] = arg_19_1.left_side_root.position[1] + -100 * var_19_0
			end,
			on_complete = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end
		}
	}
}

return {
	scenegraph_definition = var_0_1,
	widget_definitions = var_0_11,
	generic_input_actions = var_0_12,
	animation_definitions = var_0_13
}
