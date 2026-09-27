-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_dark_pact_character_selection_console_definitions.lua

local tbl = {
	1920,
	1080
}
local tbl_2 = {
	screen = {
		scale = "fit",
		size = tbl,
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
local tbl_3 = {
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
local tbl_4 = {
	55.5,
	54.6
}
local tbl_5 = {
	148,
	145.6
}
local tbl_6 = {
	331.20000000000005,
	94.4
}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_7 = {}
	local flag = arg_1_1 or {
		0,
		0,
		0
	}

	tbl_2[#tbl_2 + 1] = {
		pass_type = "hotspot",
		style_id = arg_1_2 .. "_hotspot",
		content_id = arg_1_2,
		content_check_function = function (arg_2_0)
			-- function 2
			return true
		end
	}
	tbl_2[#tbl_2 + 1] = {
		texture_id = "weapon_frame",
		pass_type = "texture",
		style_id = arg_1_2 .. "_frame"
	}
	tbl_2[#tbl_2 + 1] = {
		texture_id = "equipment_hover_frame",
		pass_type = "texture",
		style_id = arg_1_2 .. "_frame",
		content_check_function = function (self, arg_3_1)
			-- function 3
			local var_3_0 = self[arg_1_2]
			local highlight = var_3_0.highlight

			highlight = highlight or var_3_0.is_hover

			return highlight
		end
	}
	tbl_2[#tbl_2 + 1] = {
		texture_id = "icon",
		pass_type = "texture",
		style_id = arg_1_2 .. "_icon",
		content_id = arg_1_2,
		content_check_function = function (self)
			-- function 4
			local item = self.item

			item = not item and self.icon

			return item
		end
	}
	tbl_2[#tbl_2 + 1] = {
		texture_id = "mask",
		pass_type = "texture",
		style_id = arg_1_2 .. "_mask"
	}
	tbl_2[#tbl_2 + 1] = {
		texture_id = "rarity",
		pass_type = "texture",
		style_id = arg_1_2 .. "_mask",
		content_id = arg_1_2
	}
	tbl_2[#tbl_2 + 1] = {
		style_id = "weapon_tooltip",
		scenegraph_id = "weapon_tooltip",
		pass_type = "item_tooltip",
		item_id = "item",
		content_id = arg_1_2,
		content_check_function = function (self)
			-- function 5
			local item = self.item

			if not item then
				item = self.is_hover
				item = item or self.is_selected
			end

			return item
		end
	}

	local str = "title_bg" .. arg_1_2

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture_uv",
		content_id = str,
		style_id = str
	}

	local str_2 = "title_bg_effect" .. arg_1_2

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		texture_id = str_2,
		style_id = str_2,
		content_check_function = function (self)
			-- function 6
			local var_6_0 = self[arg_1_2]
			local highlight = var_6_0.highlight

			highlight = highlight or var_6_0.is_hover

			return highlight
		end
	}

	local str_3 = "title_text" .. arg_1_2

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		text_id = str_3,
		style_id = str_3,
		content_check_function = function (self)
			-- function 7
			local var_7_0 = self[arg_1_2]
			local item = var_7_0.item

			item = not item and not not var_7_0.highlight or not var_7_0.is_hover

			return item
		end,
		content_change_function = function (self, arg_8_1)
			-- function 8
			local item_type = self[arg_1_2].item.data.item_type
			local var_8_1 = str_3
			local str

			if not self.is_dark_pact then
				str = "dark_pact_" .. item_type

				if not str then
					-- Nothing
				end
			end

			str = item_type

			::label_8_0::

			self[var_8_1] = str
		end
	}

	local str_4 = "title_text_selected" .. arg_1_2

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		text_id = str_3,
		style_id = str_4,
		content_check_function = function (self)
			-- function 9
			local var_9_0 = self[arg_1_2]
			local item = var_9_0.item

			if not item then
				item = var_9_0.highlight
				item = item or var_9_0.is_hover
			end

			return item
		end,
		content_change_function = function (self, arg_10_1)
			-- function 10
			local item_type = self[arg_1_2].item.data.item_type
			local var_10_1 = str_3
			local str

			if not self.is_dark_pact then
				str = "dark_pact_" .. item_type

				if not str then
					-- Nothing
				end
			end

			str = item_type

			::label_10_0::

			self[var_10_1] = str
		end
	}

	local str_5 = "title_shadow_text" .. arg_1_2

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		text_id = str_3,
		style_id = str_5,
		content_check_function = function (self)
			-- function 11
			return self[arg_1_2].item
		end
	}

	local str_6 = "sub_title_text" .. arg_1_2

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		text_id = str_6,
		style_id = str_6,
		content_check_function = function (self)
			-- function 12
			return self[arg_1_2].item
		end,
		content_change_function = function (self, arg_13_1)
			-- function 13
			local item = self[arg_1_2].item
			local get_ui_information_from_item, var_13_2 = UIUtils.get_ui_information_from_item(item)

			self[str_6] = var_13_2
		end
	}

	local str_7 = "sub_title_shadow_text" .. arg_1_2

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		text_id = str_6,
		style_id = str_7,
		content_check_function = function (self)
			-- function 14
			return self[arg_1_2].item
		end
	}
	tbl_3[arg_1_2] = {
		rarity = "icon_bg_default",
		no_equipped_item = true,
		is_selected = false
	}
	tbl_3[str] = {
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
	tbl_3[str_2] = "item_slot_side_effect"
	tbl_3[str_3] = Localize("not_assigned")
	tbl_3[str_6] = Localize("not_assigned")
	tbl_3.slot_name = arg_1_2
	tbl_7[arg_1_2] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		area_size = tbl_4,
		texture_size = tbl_4,
		offset = {
			0,
			0,
			0
		}
	}
	tbl_7[arg_1_2 .. "_hotspot"] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		area_size = {
			tbl_5[1] * 0.7,
			tbl_5[2] * 0.7
		},
		offset = {
			0,
			0,
			10
		}
	}
	tbl_7[arg_1_2 .. "_icon"] = {
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
	tbl_7[arg_1_2 .. "_mask"] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		area_size = tbl_4,
		texture_size = tbl_4,
		offset = {
			0,
			0,
			1
		}
	}
	tbl_7[arg_1_2 .. "_frame"] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = tbl_5,
		offset = {
			0,
			0,
			1
		}
	}
	tbl_7[arg_1_2 .. "_hover_frame"] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = tbl_5,
		offset = {
			0,
			0,
			10
		}
	}
	tbl_7[str] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		size = tbl_6,
		texture_size = tbl_6,
		color = {
			255,
			0,
			0,
			0
		},
		offset = {
			0,
			-tbl_6[2] / 2,
			-5
		}
	}
	tbl_7[str_2] = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		size = tbl_6,
		texture_size = tbl_6,
		color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			0,
			-tbl_6[2] / 2,
			-4
		}
	}
	tbl_7[str_3] = {
		font_size = 30,
		upper_case = true,
		localize = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		font_type = "hell_shark_header",
		size = tbl_6,
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			tbl_5[1] * 0.5 - 14,
			-tbl_6[2] * 0.5 - 16,
			5
		}
	}
	tbl_7[str_4] = {
		font_size = 30,
		upper_case = true,
		localize = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		font_type = "hell_shark_header",
		size = tbl_6,
		text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			tbl_5[1] * 0.5 - 14,
			-tbl_6[2] * 0.5 - 16,
			5
		}
	}
	tbl_7[str_5] = {
		font_size = 30,
		upper_case = true,
		localize = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		font_type = "hell_shark_header",
		size = tbl_6,
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			tbl_5[1] * 0.5 - 14 + 2,
			-tbl_6[2] * 0.5 - 16 - 2,
			4
		}
	}
	tbl_7[str_6] = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		localize = true,
		font_size = 20,
		font_type = "hell_shark",
		size = tbl_6,
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = {
			tbl_5[1] * 0.5 - 14,
			-tbl_6[2] * 0.5 - 50,
			5
		}
	}
	tbl_7[str_7] = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		localize = true,
		font_size = 20,
		font_type = "hell_shark",
		size = tbl_6,
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			tbl_5[1] * 0.5 - 14 + 2,
			-tbl_6[2] * 0.5 - 52,
			4
		}
	}
	tbl_3.equipment_hover_frame = "loadout_item_slot_glow_console"
	tbl_3.background = "icon_bg_default"
	tbl_3.mask = "mask_rect"
	tbl_3.weapon_frame = "loadout_item_slot_console"
	tbl_7.weapon_tooltip = {
		draw_downwards = false
	}
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_7
	tbl.scenegraph_id = arg_1_0
	tbl.offset = flag

	return tbl
end

local tbl_7 = {
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
local clone = table.clone(tbl_7)

clone.offset = {
	2,
	-2,
	9
}
clone.text_color = Colors.get_color_table_with_alpha("black", 255)

local clone_2 = table.clone(tbl_7)

clone_2.dynamic_font_size_word_wrap = true
clone_2.word_wrap = true
clone_2.use_shadow = true

local flag = true
local tbl_8 = {
	pactsworn_name = UIWidgets.create_simple_text("PACTSWORN NAME", "pactsworn_name", nil, nil, tbl_3),
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
		tbl_2.pactsworn_name.size[1],
		4
	}),
	equipment_skin = fn("equipment_skin", nil, "slot_skin"),
	pactsworn_stat_1 = UIWidgets.create_simple_text("stat_1", "pactsworn_stat_1", nil, nil, tbl_7),
	pactsworn_stat_shadow_1 = UIWidgets.create_simple_text("stat_1", "pactsworn_stat_1", nil, nil, clone),
	pactsworn_stat_1_icon = UIWidgets.create_simple_texture("icons_placeholder", "pactsworn_stat_1_icon"),
	pactsworn_stat_2 = UIWidgets.create_simple_text("stat_2", "pactsworn_stat_2", nil, nil, tbl_7),
	pactsworn_stat_shadow_2 = UIWidgets.create_simple_text("stat_2", "pactsworn_stat_2", nil, nil, clone),
	pactsworn_stat_2_icon = UIWidgets.create_simple_texture("icons_placeholder", "pactsworn_stat_2_icon"),
	pactsworn_description = UIWidgets.create_simple_text("pactsworn_description", "pactsworn_description", nil, nil, clone_2)
}
local tbl_9 = {
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
local tbl_10 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				arg_15_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				-- function 16
				local easeOutCubic = math.easeOutCubic(arg_16_3)

				arg_16_4.render_settings.alpha_multiplier = easeOutCubic
				arg_16_0.left_side_root.local_position[1] = arg_16_1.left_side_root.position[1] + -100 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				arg_18_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				-- function 19
				local easeOutCubic = math.easeOutCubic(arg_19_3)

				arg_19_4.render_settings.alpha_multiplier = 1 - easeOutCubic
				arg_19_0.left_side_root.local_position[1] = arg_19_1.left_side_root.position[1] + -100 * easeOutCubic
			end,
			on_complete = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				return
			end
		}
	}
}

return {
	scenegraph_definition = tbl_2,
	widget_definitions = tbl_8,
	generic_input_actions = tbl_9,
	animation_definitions = tbl_10
}
