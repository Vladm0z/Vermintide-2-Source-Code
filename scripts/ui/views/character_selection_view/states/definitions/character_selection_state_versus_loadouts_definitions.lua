-- chunkname: @scripts/ui/views/character_selection_view/states/definitions/character_selection_state_versus_loadouts_definitions.lua

local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local num = 426
local num_2 = 240
local tbl = {
	450,
	170
}
local tbl_2 = {
	60,
	60
}
local tbl_3 = {
	40,
	40
}
local num_3 = 10
local tbl_4 = {
	20,
	10
}
local tbl_5 = {
	138.75,
	136.5
}
local num_4 = -30
local tbl_6 = {
	"slot_melee",
	"slot_ranged"
}
local tbl_7 = {
	48,
	48
}
local num_5 = 6
local tbl_8 = {
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	area_left = console_menu_scenegraphs.area_left,
	area_right = console_menu_scenegraphs.area_right,
	area_divider = console_menu_scenegraphs.area_divider,
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
			UILayer.default + 1
		}
	},
	hero_info_panel = {
		vertical_alignment = "top",
		parent = "area_left",
		horizontal_alignment = "left",
		size = {
			441,
			118
		},
		position = {
			50,
			50,
			1
		}
	},
	hero_info_level_bg = {
		vertical_alignment = "center",
		parent = "hero_info_panel",
		horizontal_alignment = "left",
		size = {
			124,
			138
		},
		position = {
			-62,
			0,
			2
		}
	},
	hero_info_divider = {
		vertical_alignment = "top",
		parent = "hero_info_level_bg",
		horizontal_alignment = "center",
		size = {
			14,
			775
		},
		position = {
			0,
			-126,
			200
		}
	},
	hero_info_divider_edge = {
		vertical_alignment = "bottom",
		parent = "hero_info_divider",
		horizontal_alignment = "center",
		size = {
			28,
			22
		},
		position = {
			0,
			-22,
			1
		}
	},
	info_career_name = {
		vertical_alignment = "top",
		parent = "hero_info_panel",
		horizontal_alignment = "center",
		size = {
			450,
			25
		},
		position = {
			76,
			-16,
			1
		}
	},
	info_hero_name = {
		vertical_alignment = "top",
		parent = "info_career_name",
		horizontal_alignment = "center",
		size = {
			450,
			25
		},
		position = {
			0,
			-40,
			1
		}
	},
	info_hero_level = {
		vertical_alignment = "center",
		parent = "hero_info_level_bg",
		horizontal_alignment = "center",
		size = {
			450,
			25
		},
		position = {
			0,
			0,
			1
		}
	},
	hero_root = {
		vertical_alignment = "center",
		parent = "hero_info_level_bg",
		horizontal_alignment = "center",
		size = {
			110,
			130
		},
		position = {
			80,
			-200,
			100
		}
	},
	hero_icon_root = {
		vertical_alignment = "center",
		parent = "hero_root",
		horizontal_alignment = "left",
		size = {
			48,
			144
		},
		position = {
			-59,
			0,
			100
		}
	},
	loadout_window_anchor = {
		vertical_alignment = "bottom",
		parent = "hero_icon_root",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			20,
			-30,
			0
		}
	},
	loadout_window = {
		vertical_alignment = "top",
		parent = "loadout_window_anchor",
		horizontal_alignment = "left",
		size = {
			534,
			600
		},
		position = {
			40,
			0,
			0
		}
	},
	loadout_window_bg = {
		vertical_alignment = "top",
		parent = "loadout_window_anchor",
		horizontal_alignment = "left",
		size = {
			534,
			525
		},
		position = {
			20,
			0,
			-1
		}
	},
	button_anchor = {
		vertical_alignment = "top",
		parent = "loadout_window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-50,
			1
		}
	},
	button = {
		vertical_alignment = "top",
		parent = "loadout_window",
		horizontal_alignment = "left",
		size = tbl_7,
		position = {
			-80,
			-5,
			1
		}
	},
	default_button_header = {
		vertical_alignment = "top",
		parent = "button",
		horizontal_alignment = "left",
		size = tbl_7,
		position = {
			51.5,
			50,
			1
		}
	},
	custom_button_header = {
		vertical_alignment = "top",
		parent = "button",
		horizontal_alignment = "left",
		size = tbl_7,
		position = {
			329,
			50,
			1
		}
	},
	loadout_anchor = {
		parent = "loadout_window",
		position = {
			0,
			0,
			0
		}
	},
	inventory_anchor = {
		parent = "loadout_anchor",
		position = {
			0,
			-200,
			0
		}
	},
	back_button = {
		vertical_alignment = "top",
		parent = "loadout_window",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			0,
			-200,
			3
		}
	},
	tag = {
		vertical_alignment = "top",
		parent = "loadout_window",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-170,
			0
		}
	},
	loadout_info_divider = {
		vertical_alignment = "top",
		parent = "loadout_window",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			-200,
			10
		}
	},
	selected_loadout_header = {
		vertical_alignment = "bottom",
		parent = "loadout_window",
		horizontal_alignment = "left",
		size = {
			464,
			150
		},
		position = {
			0,
			440,
			1
		}
	},
	selected_loadout_icon = {
		vertical_alignment = "top",
		parent = "loadout_window",
		horizontal_alignment = "left",
		size = tbl_7,
		position = {
			0,
			-5,
			1
		}
	},
	item_grid = {
		vertical_alignment = "top",
		parent = "inventory_anchor",
		horizontal_alignment = "left",
		size = {
			520,
			690
		},
		position = {
			-10,
			160,
			10
		}
	},
	talent_grid = {
		parent = "inventory_anchor",
		position = {
			0,
			-20,
			10
		}
	},
	talent_grid_tooltip = {
		vertical_alignment = "top",
		parent = "talent_grid",
		horizontal_alignment = "right",
		size = {
			400,
			0
		},
		position = {
			400,
			-30,
			1
		},
		offset = {
			0,
			-5,
			0
		}
	},
	weapons_header = {
		vertical_alignment = "top",
		parent = "inventory_anchor",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			-40,
			1
		}
	},
	weapons = {
		vertical_alignment = "top",
		parent = "weapons_header",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			45,
			-75,
			0
		}
	},
	talents_header = {
		vertical_alignment = "top",
		parent = "weapons",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			-45,
			-80,
			1
		}
	},
	talents = {
		vertical_alignment = "top",
		parent = "talents_header",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			30,
			-60,
			0
		}
	},
	weapon_tooltip = {
		vertical_alignment = "bottom",
		parent = "talents",
		horizontal_alignment = "right",
		size = {
			400,
			0
		},
		position = {
			500,
			0,
			1
		},
		offset = {
			0,
			-5,
			0
		}
	},
	talent_tooltip = {
		vertical_alignment = "center",
		parent = "loadout_window",
		horizontal_alignment = "right",
		size = {
			400,
			0
		},
		position = {
			400,
			-220,
			1
		},
		offset = {
			0,
			-5,
			0
		}
	},
	locked_info_text = {
		vertical_alignment = "top",
		parent = "hero_root",
		horizontal_alignment = "left",
		size = {
			641,
			50
		},
		position = {
			0,
			60,
			1
		}
	},
	info_window = {
		vertical_alignment = "top",
		parent = "area_right",
		horizontal_alignment = "right",
		size = {
			tbl[1] + 20,
			885
		},
		position = {
			0,
			50,
			1
		}
	},
	info_window_video = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			num,
			num_2
		},
		position = {
			0,
			-10,
			1
		}
	},
	info_video_edge_left = {
		vertical_alignment = "top",
		parent = "info_window_video",
		horizontal_alignment = "right",
		size = {
			230,
			59
		},
		position = {
			-213,
			12,
			13
		}
	},
	info_video_edge_right = {
		vertical_alignment = "top",
		parent = "info_window_video",
		horizontal_alignment = "left",
		size = {
			230,
			59
		},
		position = {
			213,
			12,
			13
		}
	},
	scrollbar_anchor = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			tbl[1] + 20,
			625
		},
		position = {
			0,
			-260,
			1
		}
	},
	scrollbar_window = {
		parent = "scrollbar_anchor"
	},
	passive_window = {
		vertical_alignment = "top",
		parent = "scrollbar_window",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			0,
			0,
			1
		}
	},
	passive_icon = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "left",
		size = {
			80,
			80
		},
		position = {
			10,
			-50,
			5
		}
	},
	passive_icon_frame = {
		vertical_alignment = "center",
		parent = "passive_icon",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	passive_title_text = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "left",
		size = {
			tbl[1] * 0.65,
			50
		},
		position = {
			10,
			-5,
			1
		}
	},
	passive_title_divider = {
		vertical_alignment = "bottom",
		parent = "passive_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	passive_type_title = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "right",
		size = {
			tbl[1] * 0.3,
			50
		},
		position = {
			-10,
			-5,
			1
		}
	},
	passive_description_text = {
		vertical_alignment = "top",
		parent = "passive_icon",
		horizontal_alignment = "left",
		size = {
			tbl[1] - 110,
			tbl[2] - 90
		},
		position = {
			90,
			0,
			1
		}
	},
	active_window = {
		vertical_alignment = "top",
		parent = "passive_window",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			0,
			-tbl[2],
			1
		}
	},
	active_icon = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "left",
		size = {
			80,
			80
		},
		position = {
			10,
			-50,
			5
		}
	},
	active_icon_frame = {
		vertical_alignment = "center",
		parent = "active_icon",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	active_title_text = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "left",
		size = {
			tbl[1] * 0.6,
			50
		},
		position = {
			10,
			-5,
			1
		}
	},
	active_title_divider = {
		vertical_alignment = "bottom",
		parent = "active_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	active_type_title = {
		vertical_alignment = "top",
		parent = "active_window",
		horizontal_alignment = "right",
		size = {
			tbl[1] * 0.3,
			50
		},
		position = {
			-10,
			-5,
			1
		}
	},
	active_description_text = {
		vertical_alignment = "top",
		parent = "active_icon",
		horizontal_alignment = "left",
		size = {
			tbl[1] - 110,
			tbl[2] - 90
		},
		position = {
			90,
			0,
			1
		}
	},
	perk_title_text = {
		vertical_alignment = "bottom",
		parent = "active_window",
		horizontal_alignment = "left",
		size = {
			tbl[1] * 0.6,
			50
		},
		position = {
			10,
			-50,
			1
		}
	},
	perk_title_divider = {
		vertical_alignment = "bottom",
		parent = "perk_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	career_perk_anchor = {
		vertical_alignment = "bottom",
		parent = "perk_title_divider",
		horizontal_alignment = "left",
		size = {
			0,
			1
		},
		position = {
			10,
			-30,
			1
		}
	},
	confirm_button = {
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
	console_cursor = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			-10
		}
	}
}

for i = 1, num_5 do
	local num_6 = i - 1

	if i == 1 then
		num_6 = "anchor"
	end

	tbl_8["career_perk_" .. i] = {
		vertical_alignment = "bottom",
		horizontal_alignment = "left",
		parent = "career_perk_" .. num_6,
		size = {
			410,
			1
		},
		position = {
			0,
			0,
			1
		}
	}
end

local tbl_9 = {
	font_size = 40,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_10 = {
	word_wrap = true,
	font_size = 30,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_11 = {
	word_wrap = true,
	font_size = 52,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_12 = {
	word_wrap = true,
	use_shadow = true,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 18,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_13 = {
	word_wrap = true,
	use_shadow = true,
	localize = false,
	font_size = 18,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("gray", 200),
	offset = {
		0,
		0,
		2
	}
}
local tbl_14 = {
	font_size = 32,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header_masked",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_15 = {
	vertical_alignment = "top",
	upper_case = true,
	localize = true,
	horizontal_alignment = "left",
	font_size = 22,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_16 = {
	vertical_alignment = "center",
	upper_case = true,
	localize = false,
	horizontal_alignment = "center",
	font_size = 22,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_17 = {
	font_size = 35,
	upper_case = true,
	localize = false,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		60,
		0,
		2
	}
}
local tbl_18 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 20,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		-55,
		2
	},
	area_size = {
		tbl_8.selected_loadout_header.size[1] - 20,
		90
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_change_function = function (self, arg_2_1)
						-- function 2
						local locked_text_color

						if not self.locked then
							locked_text_color = arg_2_1.locked_text_color

							if not locked_text_color then
								-- Nothing
							end
						end

						locked_text_color = arg_2_1.default_text_color

						::label_2_0::

						arg_2_1.text_color = locked_text_color
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 3
						return self.use_shadow
					end
				}
			}
		},
		content = {
			use_shadow = true,
			disable_with_gamepad = true,
			text = arg_1_0,
			original_text = arg_1_0
		},
		style = {
			text = {
				word_wrap = true,
				font_size = 26,
				localize = false,
				use_shadow = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("red", 255),
				default_text_color = Colors.get_color_table_with_alpha("light_blue", 255),
				locked_text_color = Colors.get_color_table_with_alpha("red", 255),
				offset = {
					0,
					0,
					2
				}
			},
			text_shadow = {
				word_wrap = true,
				font_size = 26,
				localize = false,
				font_type = "hell_shark",
				horizontal_alignment = "left",
				vertical_alignment = "top",
				skip_button_rendering = true,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					2,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_1
	}
end

local function fn_2(arg_4_0, arg_4_1)
	-- function 4
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local flag = arg_4_1 or {
		0,
		0,
		0
	}

	for i, v in ipairs(tbl_6) do
		tbl_2[#tbl_2 + 1] = {
			pass_type = "hotspot",
			style_id = v .. "_hotspot",
			content_id = v,
			content_check_function = function (self)
				-- function 5
				return self.item
			end
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "weapon_frame",
			pass_type = "texture",
			style_id = v .. "_frame"
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "equipment_hover_frame",
			pass_type = "texture",
			style_id = v .. "_frame",
			content_check_function = function (self, arg_6_1)
				-- function 6
				return self[v].is_hover
			end
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "lock",
			pass_type = "texture",
			style_id = v .. "_lock",
			content_check_function = function (self, arg_7_1)
				-- function 7
				local is_hover = self[v].is_hover

				is_hover = not is_hover and self[v].locked

				return is_hover
			end
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "lock",
			pass_type = "texture",
			style_id = v .. "_lock_shadow",
			content_check_function = function (self, arg_8_1)
				-- function 8
				local is_hover = self[v].is_hover

				is_hover = not is_hover and self[v].locked

				return is_hover
			end
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "icon",
			pass_type = "texture",
			style_id = v .. "_icon",
			content_id = v,
			content_check_function = function (self)
				-- function 9
				local item = self.item

				item = not item and self.icon

				return item
			end
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "mask",
			pass_type = "texture",
			style_id = v .. "_mask"
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "background",
			pass_type = "texture",
			style_id = v .. "_mask"
		}
		tbl_2[#tbl_2 + 1] = {
			style_id = "weapon_tooltip",
			scenegraph_id = "weapon_tooltip",
			pass_type = "item_tooltip",
			item_id = "item",
			content_id = v,
			content_check_function = function (self)
				-- function 10
				local item = self.item

				item = not item and self.is_hover

				return item
			end
		}
		tbl_3[v] = {
			no_equipped_item = true,
			is_selected = true
		}
		tbl_4[v] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = tbl_5,
			texture_size = tbl_5,
			offset = {
				(i - 1) * (tbl_5[1] + num_4),
				0,
				0
			}
		}
		tbl_4[v .. "_hotspot"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = {
				tbl_5[1] * 0.75,
				tbl_5[2] * 0.75
			},
			offset = {
				(i - 1) * (tbl_5[1] + num_4),
				0,
				10
			}
		}
		tbl_4[v .. "_icon"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = true,
			area_size = {
				65,
				65
			},
			texture_size = {
				65,
				65
			},
			offset = {
				(i - 1) * (tbl_5[1] + num_4),
				0,
				3
			}
		}
		tbl_4[v .. "_mask"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = {
				55,
				55
			},
			texture_size = {
				55,
				55
			},
			offset = {
				(i - 1) * (tbl_5[1] + num_4),
				0,
				2
			}
		}
		tbl_4[v .. "_frame"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = tbl_5,
			offset = {
				(i - 1) * (tbl_5[1] + num_4),
				0,
				1
			}
		}
		tbl_4[v .. "_hover_frame"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = tbl_5,
			offset = {
				(i - 1) * (tbl_5[1] + num_4),
				0,
				1
			}
		}
		tbl_4[v .. "_lock"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			offset = {
				(i - 1) * (tbl_5[1] + num_4),
				0,
				5
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			texture_size = {
				33,
				46
			}
		}
		tbl_4[v .. "_lock_shadow"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			offset = {
				(i - 1) * (tbl_5[1] + num_4) + 2,
				-2,
				4
			},
			color = Colors.get_color_table_with_alpha("black", 255),
			texture_size = {
				33,
				46
			}
		}
	end

	tbl_3.equipment_hover_frame = "loadout_item_slot_glow_console"
	tbl_3.background = "icon_bg_default"
	tbl_3.mask = "mask_rect"
	tbl_3.weapon_frame = "loadout_item_slot_console"
	tbl_3.lock = "lobby_icon_lock"
	tbl_4.weapon_tooltip = {
		draw_downwards = false
	}
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.scenegraph_id = arg_4_0
	tbl.offset = flag

	return tbl
end

local function fn_3(arg_11_0, arg_11_1)
	-- function 11
	local tbl = {
		element = {}
	}
	local tbl_3 = {}
	local tbl_4 = {}
	local tbl_5 = {}
	local flag = arg_11_1 or {
		0,
		0,
		0
	}
	local str = "frame_outer_glow_01"
	local var_11_6 = UIFrameSettings[str]

	for i = 1, MaxTalentPoints do
		local str_2 = "talent_" .. i

		tbl_3[#tbl_3 + 1] = {
			texture_id = "talent_frame",
			pass_type = "texture",
			style_id = str_2 .. "_frame"
		}
		tbl_3[#tbl_3 + 1] = {
			texture_id = "talent_hover_frame",
			pass_type = "texture_frame",
			style_id = str_2 .. "_hover_frame",
			content_check_function = function (self, arg_12_1)
				-- function 12
				return self[str_2].is_hover
			end
		}
		tbl_3[#tbl_3 + 1] = {
			pass_type = "hotspot",
			style_id = str_2,
			content_id = str_2
		}
		tbl_3[#tbl_3 + 1] = {
			texture_id = "icon",
			pass_type = "texture",
			style_id = str_2,
			content_id = str_2,
			content_check_function = function (self)
				-- function 13
				local talent = self.talent

				talent = not talent and self.icon

				return talent
			end
		}
		tbl_3[#tbl_3 + 1] = {
			texture_id = "lock_icon",
			pass_type = "texture",
			style_id = str_2 .. "_lock",
			content_check_function = function (self)
				-- function 14
				local talent = self[str_2].talent

				if not talent then
					talent = self[str_2].is_hover
					talent = not talent and self.locked
				end

				return talent
			end
		}
		tbl_3[#tbl_3 + 1] = {
			texture_id = "lock_icon",
			pass_type = "texture",
			style_id = str_2 .. "_lock_shadow",
			content_check_function = function (self)
				-- function 15
				local talent = self[str_2].talent

				if not talent then
					talent = self[str_2].is_hover
					talent = not talent and self.locked
				end

				return talent
			end
		}
		tbl_3[#tbl_3 + 1] = {
			style_id = "talent_tooltip",
			scenegraph_id = "talent_tooltip",
			pass_type = "talent_tooltip",
			talent_id = "talent",
			content_id = str_2,
			content_check_function = function (self)
				-- function 16
				local talent = self.talent

				talent = not talent and self.is_hover

				return talent
			end
		}
		tbl_4[str_2] = {
			is_selected = true
		}
		tbl_5[str_2] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = tbl_2,
			texture_size = tbl_2,
			offset = {
				(i - 1) * (tbl_2[1] + num_3),
				0,
				0
			}
		}
		tbl_5[str_2 .. "_frame"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = tbl_2,
			offset = {
				(i - 1) * (tbl_2[1] + num_3),
				0,
				1
			}
		}
		tbl_5[str_2 .. "_hover_frame"] = {
			horizontal_alignment = "center",
			vertical_alignment = "center",
			texture_size = var_11_6.texture_size,
			texture_sizes = var_11_6.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				(i - 1) * (tbl_2[1] + num_3),
				0,
				0
			},
			area_size = {
				85,
				85
			}
		}
		tbl_5[str_2 .. "_lock"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				33,
				46
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				(i - 1) * (tbl_2[1] + num_3),
				0,
				5
			}
		}
		tbl_5[str_2 .. "_lock_shadow"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				33,
				46
			},
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				(i - 1) * (tbl_2[1] + num_3) + 2,
				-2,
				4
			}
		}
	end

	tbl_4.talent_hover_frame = var_11_6.texture
	tbl_4.talent_frame = "talent_frame"
	tbl_4.lock_icon = "lobby_icon_lock"
	tbl_5.talent_tooltip = {
		draw_downwards = false
	}
	tbl.element.passes = tbl_3
	tbl.content = tbl_4
	tbl.style = tbl_5
	tbl.scenegraph_id = arg_11_0
	tbl.offset = flag

	return tbl
end

local function fn_4(arg_17_0, arg_17_1)
	-- function 17
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_5 = {}
	local tbl_6 = {}
	local flag = arg_17_1 or {
		0,
		0,
		0
	}
	local num = 25
	local str = "frame_outer_glow_01"
	local var_17_7 = UIFrameSettings[str]

	for i = 1, MaxTalentPoints do
		local str_2 = "talent_row_" .. i

		tbl_2[#tbl_2 + 1] = {
			texture_id = "talent_frame",
			pass_type = "text",
			text_id = str_2 .. "_header",
			style_id = str_2 .. "_header"
		}
		tbl_2[#tbl_2 + 1] = {
			texture_id = "talent_frame",
			pass_type = "text",
			text_id = str_2 .. "_name",
			style_id = str_2 .. "_name"
		}
		tbl_5[str_2 .. "_header"] = tostring(i)
		tbl_5[str_2 .. "_name"] = " "
		tbl_6[str_2 .. "_header"] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			localize = false,
			font_size = 28,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				0,
				-(i - 1) * (tbl_3[2] + tbl_4[2]) - tbl_3[2] * 0.125,
				2
			}
		}
		tbl_6[str_2 .. "_name"] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			localize = false,
			font_size = 28,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				num + 3 * (tbl_3[1] + tbl_4[1]),
				-(i - 1) * (tbl_3[2] + tbl_4[2]) - tbl_3[2] * 0.125,
				2
			}
		}
		tbl_6["talent_tooltip_" .. i] = {
			offset = {
				0,
				-(i - 1) * (tbl_3[2] + tbl_4[2]),
				0
			}
		}

		for j = 1, 3 do
			local str_3 = "talent_" .. i .. "_" .. j

			tbl_2[#tbl_2 + 1] = {
				texture_id = "talent_frame",
				pass_type = "texture",
				style_id = str_3 .. "_frame"
			}
			tbl_2[#tbl_2 + 1] = {
				texture_id = "talent_hover_frame",
				pass_type = "texture_frame",
				style_id = str_3 .. "_hover_frame",
				content_check_function = function (self, arg_18_1)
					-- function 18
					return self[str_3].is_hover
				end
			}
			tbl_2[#tbl_2 + 1] = {
				pass_type = "hotspot",
				style_id = str_3,
				content_id = str_3,
				content_check_function = function (self)
					-- function 19
					return self.talent
				end
			}
			tbl_2[#tbl_2 + 1] = {
				texture_id = "icon",
				pass_type = "texture",
				style_id = str_3,
				content_id = str_3,
				content_check_function = function (self)
					-- function 20
					local talent = self.talent

					talent = not talent and self.icon

					return talent
				end
			}
			tbl_2[#tbl_2 + 1] = {
				scenegraph_id = "talent_grid_tooltip",
				pass_type = "talent_tooltip",
				talent_id = "talent",
				style_id = "talent_tooltip_" .. i,
				content_id = str_3,
				content_check_function = function (self)
					-- function 21
					local talent = self.talent

					talent = not talent and self.is_hover

					return talent
				end
			}
			tbl_5[str_3] = {
				is_selected = true
			}
			tbl_6[str_3] = {
				vertical_alignment = "top",
				saturated = true,
				horizontal_alignment = "left",
				area_size = tbl_3,
				texture_size = tbl_3,
				offset = {
					num + (j - 1) * (tbl_3[1] + tbl_4[1]),
					-(i - 1) * (tbl_3[2] + tbl_4[2]),
					0
				}
			}
			tbl_6[str_3 .. "_frame"] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = tbl_3,
				offset = {
					num + (j - 1) * (tbl_3[1] + tbl_4[1]),
					-(i - 1) * (tbl_3[2] + tbl_4[2]),
					1
				}
			}
			tbl_6[str_3 .. "_hover_frame"] = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				texture_size = var_17_7.texture_size,
				texture_sizes = var_17_7.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-12.5 + num + (j - 1) * (tbl_3[1] + tbl_4[1]),
					12.5 - (i - 1) * (tbl_3[2] + tbl_4[2]),
					0
				},
				area_size = {
					65,
					65
				}
			}
		end
	end

	tbl_5.talent_hover_frame = var_17_7.texture
	tbl_5.talent_frame = "talent_frame"
	tbl_5.lock_icon = "lobby_icon_lock"
	tbl.element.passes = tbl_2
	tbl.content = tbl_5
	tbl.style = tbl_6
	tbl.scenegraph_id = arg_17_0
	tbl.offset = flag

	return tbl
end

local function fn_5(arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_change_function = function (self, arg_23_1)
						-- function 23
						local offset = arg_23_1.offset
						local flag

						flag = not self.default_loadout and 25 and 0
						offset[1] = flag
					end
				},
				{
					pass_type = "texture",
					style_id = "lock_icon",
					texture_id = "lock_icon",
					content_check_function = function (self, arg_24_1)
						-- function 24
						return self.default_loadout
					end
				}
			}
		},
		content = {
			lock_icon = "lobby_icon_lock",
			default_loadout = false,
			text = arg_22_0
		},
		style = {
			text = arg_22_2,
			lock_icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = Colors.get_color_table_with_alpha("font_default", 255),
				texture_size = {
					16.5,
					23
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_22_1
	}
end

local function fn_6(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	-- function 25
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_25_1)
	local tbl

	if not arg_25_4 then
		tbl = {
			get_atlas_settings_by_texture_name.size[1] * arg_25_4,
			get_atlas_settings_by_texture_name.size[2] * arg_25_4
		}

		if not tbl then
			-- Nothing
		end
	end

	tbl = get_atlas_settings_by_texture_name.size

	::label_25_0::

	return {
		element = {
			passes = {
				{
					style_id = "button_hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					pass_type = "texture",
					style_id = "texture_shadow_id",
					texture_id = "texture_id"
				},
				{
					pass_type = "texture",
					style_id = "texture_hover_id",
					texture_id = "texture_id"
				},
				{
					pass_type = "texture",
					style_id = "selected_texture",
					texture_id = "selected_texture"
				}
			}
		},
		content = {
			button_hotspot = {},
			texture_id = arg_25_1,
			selected_texture = arg_25_2
		},
		style = {
			button_hotspot = {
				size = {
					60,
					60
				},
				offset = {
					-30,
					-30,
					0
				}
			},
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					tbl[1],
					tbl[2]
				},
				color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					1
				}
			},
			texture_shadow_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					tbl[1],
					tbl[2]
				},
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					2,
					-2,
					0
				}
			},
			texture_hover_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					tbl[1],
					tbl[2]
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					2
				}
			},
			selected_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					tbl[1],
					tbl[2]
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
					3
				}
			}
		},
		offset = arg_25_3 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_25_0
	}
end

local var_0_31
local str = "icons_placeholder"
local var_0_33
local str_2 = ""
local var_0_35
local var_0_36
local var_0_37
local flag = false
local flag_2 = true
local flag_3 = false
local flag_4 = true
local tbl_19 = {
	locked_info_text = fn("", "locked_info_text"),
	hero_info_panel = UIWidgets.create_simple_texture("item_slot_side_fade", "hero_info_panel", nil, nil, {
		255,
		0,
		0,
		0
	}),
	hero_info_panel_glow = UIWidgets.create_simple_texture("item_slot_side_effect", "hero_info_panel", nil, nil, Colors.get_color_table_with_alpha("font_title", 255), 1),
	hero_info_level_bg = UIWidgets.create_simple_texture("hero_level_bg", "hero_info_level_bg"),
	hero_info_divider = UIWidgets.create_simple_texture("divider_vertical_hero_middle", "hero_info_divider"),
	hero_info_divider_edge = UIWidgets.create_simple_texture("divider_vertical_hero_end", "hero_info_divider_edge"),
	info_career_name = UIWidgets.create_simple_text("n/a", "info_career_name", nil, nil, tbl_9),
	info_hero_name = UIWidgets.create_simple_text("n/a", "info_hero_name", nil, nil, tbl_10),
	info_hero_level = UIWidgets.create_simple_text("n/a", "info_hero_level", nil, nil, tbl_11),
	loadout_window_background = UIWidgets.create_rect_with_outer_frame("loadout_window_bg", tbl_8.loadout_window_bg.size, "frame_outer_fade_02", 0, Colors.get_color_table_with_alpha("console_menu_rect", 192)),
	loadout_frame = UIWidgets.create_rect_with_outer_frame("button", tbl_7, "frame_outer_glow_01", nil, {
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
	confirm_button = UIWidgets.create_default_button("confirm_button", tbl_8.confirm_button.size, nil, nil, Localize("input_description_confirm"), nil, nil, nil, nil, true),
	loadout_info_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "loadout_info_divider"),
	selected_loadout_header = UIWidgets.create_simple_text("DEFAULT LOADOUT", "selected_loadout_header", nil, nil, tbl_17),
	selected_loadout_desc = UIWidgets.create_simple_text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean dolor justo, maximus sit amet tristique eget, laoreet non erat.", "selected_loadout_header", nil, nil, tbl_18),
	selected_loadout_icon = UIWidgets.create_simple_texture("icons_placeholder", "selected_loadout_icon")
}
local tbl_20 = {
	weapons_header = fn_5("hero_window_equipment", "weapons_header", tbl_15),
	loadout_weapons = fn_2("weapons", {
		0,
		0,
		10
	}),
	talents_header = fn_5("hero_window_talents", "talents_header", tbl_15),
	loadout_talents = fn_3("talents", {
		0,
		0,
		10
	})
}
local tbl_21 = {
	item_grid = UIWidgets.create_grid("item_grid", tbl_8.item_grid.size, 3, 5, 25, 10, false, nil, false),
	talent_grid = fn_4("talent_grid"),
	back_button = fn_6("back_button", "layout_button_back", "layout_button_back_glow", {
		-60,
		-20,
		100
	}, 0.5)
}
local tbl_22 = {}

for i_2, v in ipairs(InventorySettings.loadouts) do
	local flag_5

	flag_5 = v.loadout_type ~= "custom" or not -20 or 0
	tbl_22[#tbl_22 + 1] = UIWidgets.create_default_button("button", tbl_7, var_0_31, str, str_2, var_0_33, var_0_35, var_0_36, var_0_37, flag, flag_2, flag_3, {
		0,
		flag_5 - (tbl_7[1] + 5) * (i_2 - 1),
		0
	}, flag_4)
end

local flag_6 = true
local tbl_23 = {
	background = UIWidgets.create_simple_rect("screen", {
		0,
		0,
		0,
		0
	}, 100),
	info_window_background = UIWidgets.create_rect_with_outer_frame("info_window", tbl_8.info_window.size, "frame_outer_fade_02", 0, Colors.get_color_table_with_alpha("console_menu_rect", 192)),
	mask = UIWidgets.create_simple_texture("mask_rect", "scrollbar_anchor"),
	info_window_video = UIWidgets.create_frame("info_window_video", tbl_8.info_window_video.size, "menu_frame_06"),
	info_video_edge_left = UIWidgets.create_simple_texture("frame_detail_03", "info_video_edge_left"),
	info_video_edge_right = UIWidgets.create_simple_uv_texture("frame_detail_03", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "info_video_edge_right"),
	perk_title_text = UIWidgets.create_simple_text(Localize("hero_view_perk_title"), "perk_title_text", nil, nil, tbl_14),
	perk_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "perk_title_divider", true),
	passive_title_text = UIWidgets.create_simple_text("n/a", "passive_title_text", nil, nil, tbl_14),
	passive_type_title = UIWidgets.create_simple_text(Localize("hero_view_passive_ability"), "passive_type_title", nil, nil, tbl_13),
	passive_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "passive_title_divider", true),
	passive_description_text = UIWidgets.create_simple_text("n/a", "passive_description_text", nil, nil, tbl_12),
	passive_icon = UIWidgets.create_simple_texture("icons_placeholder", "passive_icon", true),
	passive_icon_frame = UIWidgets.create_simple_texture("talent_frame", "passive_icon_frame", true),
	active_title_text = UIWidgets.create_simple_text("n/a", "active_title_text", nil, nil, tbl_14),
	active_type_title = UIWidgets.create_simple_text(Localize("hero_view_activated_ability"), "active_type_title", nil, nil, tbl_13),
	active_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "active_title_divider", true),
	active_description_text = UIWidgets.create_simple_text("n/a", "active_description_text", nil, nil, tbl_12),
	active_icon = UIWidgets.create_simple_texture("icons_placeholder", "active_icon", true),
	active_icon_frame = UIWidgets.create_simple_texture("talent_frame", "active_icon_frame", true)
}

for l = 1, num_5 do
	tbl_23["career_perk_" .. l] = UIWidgets.create_career_perk_text("career_perk_" .. l)
end

local tbl_24 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				arg_26_3.render_settings.alpha_multiplier = 0
				arg_26_0.area_left.local_position[1] = arg_26_1.area_left.position[1] - 200
				arg_26_0.area_right.local_position[1] = arg_26_1.area_right.position[1] + 200
			end,
			update = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				-- function 27
				local easeOutCubic = math.easeOutCubic(arg_27_3)

				arg_27_4.render_settings.alpha_multiplier = easeOutCubic * easeOutCubic * easeOutCubic
				arg_27_0.area_left.local_position[1] = math.lerp(arg_27_1.area_left.position[1] - 200, arg_27_1.area_left.position[1], easeOutCubic)
				arg_27_0.area_right.local_position[1] = math.lerp(arg_27_1.area_right.position[1] + 400, arg_27_1.area_right.position[1], easeOutCubic)
			end,
			on_complete = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				return
			end
		}
	},
	open_equipment_inventory = {
		{
			name = "slide_and_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				arg_29_3.render_settings.alpha_multiplier = 0
				arg_29_0.loadout_anchor.local_position[1] = arg_29_1.loadout_anchor.position[1] - 75
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				-- function 30
				local easeOutCubic = math.easeOutCubic(arg_30_3)

				arg_30_4.render_settings.alpha_multiplier = easeOutCubic * easeOutCubic * easeOutCubic
				arg_30_0.loadout_anchor.local_position[1] = math.lerp(arg_30_1.loadout_anchor.position[1] - 75, arg_30_1.loadout_anchor.position[1], easeOutCubic)
			end,
			on_complete = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				return
			end
		}
	},
	show_loadout = {
		{
			name = "slide_and_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				-- function 32
				arg_32_3.render_settings.alpha_multiplier = 0
				arg_32_0.loadout_anchor.local_position[1] = arg_32_1.loadout_anchor.position[1] + 75
			end,
			update = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				-- function 33
				local easeOutCubic = math.easeOutCubic(arg_33_3)

				arg_33_4.render_settings.alpha_multiplier = easeOutCubic * easeOutCubic * easeOutCubic
				arg_33_0.loadout_anchor.local_position[1] = math.lerp(arg_33_1.loadout_anchor.position[1] + 75, arg_33_1.loadout_anchor.position[1], easeOutCubic)
			end,
			on_complete = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				return
			end
		}
	}
}
local tbl_25 = {
	default = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_select_loadout",
			ignore_keybinding = true
		},
		{
			input_action = "refresh_press",
			priority = 3,
			description_text = "input_description_confirm"
		},
		{
			input_action = "back",
			priority = 4,
			description_text = "input_description_close"
		}
	}
}

return {
	tag_scenegraph_id = "tag",
	scenegraph_definition = tbl_8,
	widget_definitions = tbl_19,
	loadout_widgets_definitions = tbl_20,
	loadout_selection_widget_definitions = tbl_21,
	loadout_button_widget_definitions = tbl_22,
	info_window_widgets_definitions = tbl_23,
	animation_definitions = tbl_24,
	console_cursor_definition = UIWidgets.create_console_cursor("console_cursor"),
	hero_icon_widget = UIWidgets.create_hero_icon_widget("hero_icon_root", tbl_8.hero_icon_root.size),
	hero_widget = UIWidgets.create_hero_widget("hero_root", tbl_8.hero_root.size),
	weapon_slots = tbl_6,
	tag_widget_func = UIWidgets.create_tag,
	generic_input_actions = tbl_25,
	NUM_PERKS = num_5
}
