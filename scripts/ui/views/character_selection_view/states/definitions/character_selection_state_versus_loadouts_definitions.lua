-- chunkname: @scripts/ui/views/character_selection_view/states/definitions/character_selection_state_versus_loadouts_definitions.lua

local var_0_0 = UISettings.console_menu_scenegraphs
local var_0_1 = 426
local var_0_2 = 240
local var_0_3 = {
	450,
	170
}
local var_0_4 = {
	60,
	60
}
local var_0_5 = {
	40,
	40
}
local var_0_6 = 10
local var_0_7 = {
	20,
	10
}
local var_0_8 = {
	138.75,
	136.5
}
local var_0_9 = -30
local var_0_10 = {
	"slot_melee",
	"slot_ranged"
}
local var_0_11 = {
	48,
	48
}
local var_0_12 = {
	screen = var_0_0.screen,
	area = var_0_0.area,
	area_left = var_0_0.area_left,
	area_right = var_0_0.area_right,
	area_divider = var_0_0.area_divider,
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
		size = var_0_11,
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
		size = var_0_11,
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
		size = var_0_11,
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
		size = var_0_11,
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
			var_0_3[1] + 20,
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
			var_0_1,
			var_0_2
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
			var_0_3[1] + 20,
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
		size = var_0_3,
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
			var_0_3[1] * 0.65,
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
			var_0_3[1] * 0.3,
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
			var_0_3[1] - 110,
			var_0_3[2] - 90
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
		size = var_0_3,
		position = {
			0,
			-var_0_3[2],
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
			var_0_3[1] * 0.6,
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
			var_0_3[1] * 0.3,
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
			var_0_3[1] - 110,
			var_0_3[2] - 90
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
			var_0_3[1] * 0.6,
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
	career_perk_1 = {
		vertical_alignment = "bottom",
		parent = "perk_title_divider",
		horizontal_alignment = "left",
		size = {
			420,
			1
		},
		position = {
			10,
			-30,
			1
		}
	},
	career_perk_2 = {
		vertical_alignment = "center",
		parent = "career_perk_1",
		horizontal_alignment = "left",
		size = {
			420,
			1
		},
		position = {
			0,
			0,
			1
		}
	},
	career_perk_3 = {
		vertical_alignment = "center",
		parent = "career_perk_2",
		horizontal_alignment = "left",
		size = {
			420,
			1
		},
		position = {
			0,
			0,
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
local var_0_13 = {
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
local var_0_14 = {
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
local var_0_15 = {
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
local var_0_16 = {
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
local var_0_17 = {
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
local var_0_18 = {
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
local var_0_19 = {
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
local var_0_20 = {
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
local var_0_21 = {
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
local var_0_22 = {
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
		var_0_12.selected_loadout_header.size[1] - 20,
		90
	}
}

local function var_0_23(arg_1_0, arg_1_1)
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_change_function = function(arg_2_0, arg_2_1)
						arg_2_1.text_color = arg_2_0.locked and arg_2_1.locked_text_color or arg_2_1.default_text_color
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function(arg_3_0)
						return arg_3_0.use_shadow
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

local function var_0_24(arg_4_0, arg_4_1)
	local var_4_0 = {
		element = {}
	}
	local var_4_1 = {}
	local var_4_2 = {}
	local var_4_3 = {}
	local var_4_4 = arg_4_1 or {
		0,
		0,
		0
	}

	for iter_4_0, iter_4_1 in ipairs(var_0_10) do
		var_4_1[#var_4_1 + 1] = {
			pass_type = "hotspot",
			style_id = iter_4_1 .. "_hotspot",
			content_id = iter_4_1,
			content_check_function = function(arg_5_0)
				return arg_5_0.item
			end
		}
		var_4_1[#var_4_1 + 1] = {
			texture_id = "weapon_frame",
			pass_type = "texture",
			style_id = iter_4_1 .. "_frame"
		}
		var_4_1[#var_4_1 + 1] = {
			texture_id = "equipment_hover_frame",
			pass_type = "texture",
			style_id = iter_4_1 .. "_frame",
			content_check_function = function(arg_6_0, arg_6_1)
				return arg_6_0[iter_4_1].is_hover
			end
		}
		var_4_1[#var_4_1 + 1] = {
			texture_id = "lock",
			pass_type = "texture",
			style_id = iter_4_1 .. "_lock",
			content_check_function = function(arg_7_0, arg_7_1)
				return arg_7_0[iter_4_1].is_hover and arg_7_0[iter_4_1].locked
			end
		}
		var_4_1[#var_4_1 + 1] = {
			texture_id = "lock",
			pass_type = "texture",
			style_id = iter_4_1 .. "_lock_shadow",
			content_check_function = function(arg_8_0, arg_8_1)
				return arg_8_0[iter_4_1].is_hover and arg_8_0[iter_4_1].locked
			end
		}
		var_4_1[#var_4_1 + 1] = {
			texture_id = "icon",
			pass_type = "texture",
			style_id = iter_4_1 .. "_icon",
			content_id = iter_4_1,
			content_check_function = function(arg_9_0)
				return arg_9_0.item and arg_9_0.icon
			end
		}
		var_4_1[#var_4_1 + 1] = {
			texture_id = "mask",
			pass_type = "texture",
			style_id = iter_4_1 .. "_mask"
		}
		var_4_1[#var_4_1 + 1] = {
			texture_id = "background",
			pass_type = "texture",
			style_id = iter_4_1 .. "_mask"
		}
		var_4_1[#var_4_1 + 1] = {
			style_id = "weapon_tooltip",
			scenegraph_id = "weapon_tooltip",
			pass_type = "item_tooltip",
			item_id = "item",
			content_id = iter_4_1,
			content_check_function = function(arg_10_0)
				return arg_10_0.item and arg_10_0.is_hover
			end
		}
		var_4_2[iter_4_1] = {
			no_equipped_item = true,
			is_selected = true
		}
		var_4_3[iter_4_1] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = var_0_8,
			texture_size = var_0_8,
			offset = {
				(iter_4_0 - 1) * (var_0_8[1] + var_0_9),
				0,
				0
			}
		}
		var_4_3[iter_4_1 .. "_hotspot"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = {
				var_0_8[1] * 0.75,
				var_0_8[2] * 0.75
			},
			offset = {
				(iter_4_0 - 1) * (var_0_8[1] + var_0_9),
				0,
				10
			}
		}
		var_4_3[iter_4_1 .. "_icon"] = {
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
				(iter_4_0 - 1) * (var_0_8[1] + var_0_9),
				0,
				3
			}
		}
		var_4_3[iter_4_1 .. "_mask"] = {
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
				(iter_4_0 - 1) * (var_0_8[1] + var_0_9),
				0,
				2
			}
		}
		var_4_3[iter_4_1 .. "_frame"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = var_0_8,
			offset = {
				(iter_4_0 - 1) * (var_0_8[1] + var_0_9),
				0,
				1
			}
		}
		var_4_3[iter_4_1 .. "_hover_frame"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = var_0_8,
			offset = {
				(iter_4_0 - 1) * (var_0_8[1] + var_0_9),
				0,
				1
			}
		}
		var_4_3[iter_4_1 .. "_lock"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			offset = {
				(iter_4_0 - 1) * (var_0_8[1] + var_0_9),
				0,
				5
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			texture_size = {
				33,
				46
			}
		}
		var_4_3[iter_4_1 .. "_lock_shadow"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			offset = {
				(iter_4_0 - 1) * (var_0_8[1] + var_0_9) + 2,
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

	var_4_2.equipment_hover_frame = "loadout_item_slot_glow_console"
	var_4_2.background = "icon_bg_default"
	var_4_2.mask = "mask_rect"
	var_4_2.weapon_frame = "loadout_item_slot_console"
	var_4_2.lock = "lobby_icon_lock"
	var_4_3.weapon_tooltip = {
		draw_downwards = false
	}
	var_4_0.element.passes = var_4_1
	var_4_0.content = var_4_2
	var_4_0.style = var_4_3
	var_4_0.scenegraph_id = arg_4_0
	var_4_0.offset = var_4_4

	return var_4_0
end

local function var_0_25(arg_11_0, arg_11_1)
	local var_11_0 = {
		element = {}
	}
	local var_11_1 = {}
	local var_11_2 = {}
	local var_11_3 = {}
	local var_11_4 = arg_11_1 or {
		0,
		0,
		0
	}
	local var_11_5 = "frame_outer_glow_01"
	local var_11_6 = UIFrameSettings[var_11_5]

	for iter_11_0 = 1, MaxTalentPoints do
		local var_11_7 = "talent_" .. iter_11_0

		var_11_1[#var_11_1 + 1] = {
			texture_id = "talent_frame",
			pass_type = "texture",
			style_id = var_11_7 .. "_frame"
		}
		var_11_1[#var_11_1 + 1] = {
			texture_id = "talent_hover_frame",
			pass_type = "texture_frame",
			style_id = var_11_7 .. "_hover_frame",
			content_check_function = function(arg_12_0, arg_12_1)
				return arg_12_0[var_11_7].is_hover
			end
		}
		var_11_1[#var_11_1 + 1] = {
			pass_type = "hotspot",
			style_id = var_11_7,
			content_id = var_11_7
		}
		var_11_1[#var_11_1 + 1] = {
			texture_id = "icon",
			pass_type = "texture",
			style_id = var_11_7,
			content_id = var_11_7,
			content_check_function = function(arg_13_0)
				return arg_13_0.talent and arg_13_0.icon
			end
		}
		var_11_1[#var_11_1 + 1] = {
			texture_id = "lock_icon",
			pass_type = "texture",
			style_id = var_11_7 .. "_lock",
			content_check_function = function(arg_14_0)
				return arg_14_0[var_11_7].talent and arg_14_0[var_11_7].is_hover and arg_14_0.locked
			end
		}
		var_11_1[#var_11_1 + 1] = {
			texture_id = "lock_icon",
			pass_type = "texture",
			style_id = var_11_7 .. "_lock_shadow",
			content_check_function = function(arg_15_0)
				return arg_15_0[var_11_7].talent and arg_15_0[var_11_7].is_hover and arg_15_0.locked
			end
		}
		var_11_1[#var_11_1 + 1] = {
			style_id = "talent_tooltip",
			scenegraph_id = "talent_tooltip",
			pass_type = "talent_tooltip",
			talent_id = "talent",
			content_id = var_11_7,
			content_check_function = function(arg_16_0)
				return arg_16_0.talent and arg_16_0.is_hover
			end
		}
		var_11_2[var_11_7] = {
			is_selected = true
		}
		var_11_3[var_11_7] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = var_0_4,
			texture_size = var_0_4,
			offset = {
				(iter_11_0 - 1) * (var_0_4[1] + var_0_6),
				0,
				0
			}
		}
		var_11_3[var_11_7 .. "_frame"] = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = var_0_4,
			offset = {
				(iter_11_0 - 1) * (var_0_4[1] + var_0_6),
				0,
				1
			}
		}
		var_11_3[var_11_7 .. "_hover_frame"] = {
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
				(iter_11_0 - 1) * (var_0_4[1] + var_0_6),
				0,
				0
			},
			area_size = {
				85,
				85
			}
		}
		var_11_3[var_11_7 .. "_lock"] = {
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
				(iter_11_0 - 1) * (var_0_4[1] + var_0_6),
				0,
				5
			}
		}
		var_11_3[var_11_7 .. "_lock_shadow"] = {
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
				(iter_11_0 - 1) * (var_0_4[1] + var_0_6) + 2,
				-2,
				4
			}
		}
	end

	var_11_2.talent_hover_frame = var_11_6.texture
	var_11_2.talent_frame = "talent_frame"
	var_11_2.lock_icon = "lobby_icon_lock"
	var_11_3.talent_tooltip = {
		draw_downwards = false
	}
	var_11_0.element.passes = var_11_1
	var_11_0.content = var_11_2
	var_11_0.style = var_11_3
	var_11_0.scenegraph_id = arg_11_0
	var_11_0.offset = var_11_4

	return var_11_0
end

local function var_0_26(arg_17_0, arg_17_1)
	local var_17_0 = {
		element = {}
	}
	local var_17_1 = {}
	local var_17_2 = {}
	local var_17_3 = {}
	local var_17_4 = arg_17_1 or {
		0,
		0,
		0
	}
	local var_17_5 = 25
	local var_17_6 = "frame_outer_glow_01"
	local var_17_7 = UIFrameSettings[var_17_6]

	for iter_17_0 = 1, MaxTalentPoints do
		local var_17_8 = "talent_row_" .. iter_17_0

		var_17_1[#var_17_1 + 1] = {
			texture_id = "talent_frame",
			pass_type = "text",
			text_id = var_17_8 .. "_header",
			style_id = var_17_8 .. "_header"
		}
		var_17_1[#var_17_1 + 1] = {
			texture_id = "talent_frame",
			pass_type = "text",
			text_id = var_17_8 .. "_name",
			style_id = var_17_8 .. "_name"
		}
		var_17_2[var_17_8 .. "_header"] = tostring(iter_17_0)
		var_17_2[var_17_8 .. "_name"] = " "
		var_17_3[var_17_8 .. "_header"] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			localize = false,
			font_size = 28,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				0,
				-(iter_17_0 - 1) * (var_0_5[2] + var_0_7[2]) - var_0_5[2] * 0.125,
				2
			}
		}
		var_17_3[var_17_8 .. "_name"] = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			localize = false,
			font_size = 28,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				var_17_5 + 3 * (var_0_5[1] + var_0_7[1]),
				-(iter_17_0 - 1) * (var_0_5[2] + var_0_7[2]) - var_0_5[2] * 0.125,
				2
			}
		}
		var_17_3["talent_tooltip_" .. iter_17_0] = {
			offset = {
				0,
				-(iter_17_0 - 1) * (var_0_5[2] + var_0_7[2]),
				0
			}
		}

		for iter_17_1 = 1, 3 do
			local var_17_9 = "talent_" .. iter_17_0 .. "_" .. iter_17_1

			var_17_1[#var_17_1 + 1] = {
				texture_id = "talent_frame",
				pass_type = "texture",
				style_id = var_17_9 .. "_frame"
			}
			var_17_1[#var_17_1 + 1] = {
				texture_id = "talent_hover_frame",
				pass_type = "texture_frame",
				style_id = var_17_9 .. "_hover_frame",
				content_check_function = function(arg_18_0, arg_18_1)
					return arg_18_0[var_17_9].is_hover
				end
			}
			var_17_1[#var_17_1 + 1] = {
				pass_type = "hotspot",
				style_id = var_17_9,
				content_id = var_17_9,
				content_check_function = function(arg_19_0)
					return arg_19_0.talent
				end
			}
			var_17_1[#var_17_1 + 1] = {
				texture_id = "icon",
				pass_type = "texture",
				style_id = var_17_9,
				content_id = var_17_9,
				content_check_function = function(arg_20_0)
					return arg_20_0.talent and arg_20_0.icon
				end
			}
			var_17_1[#var_17_1 + 1] = {
				scenegraph_id = "talent_grid_tooltip",
				pass_type = "talent_tooltip",
				talent_id = "talent",
				style_id = "talent_tooltip_" .. iter_17_0,
				content_id = var_17_9,
				content_check_function = function(arg_21_0)
					return arg_21_0.talent and arg_21_0.is_hover
				end
			}
			var_17_2[var_17_9] = {
				is_selected = true
			}
			var_17_3[var_17_9] = {
				vertical_alignment = "top",
				saturated = true,
				horizontal_alignment = "left",
				area_size = var_0_5,
				texture_size = var_0_5,
				offset = {
					var_17_5 + (iter_17_1 - 1) * (var_0_5[1] + var_0_7[1]),
					-(iter_17_0 - 1) * (var_0_5[2] + var_0_7[2]),
					0
				}
			}
			var_17_3[var_17_9 .. "_frame"] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = var_0_5,
				offset = {
					var_17_5 + (iter_17_1 - 1) * (var_0_5[1] + var_0_7[1]),
					-(iter_17_0 - 1) * (var_0_5[2] + var_0_7[2]),
					1
				}
			}
			var_17_3[var_17_9 .. "_hover_frame"] = {
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
					-12.5 + var_17_5 + (iter_17_1 - 1) * (var_0_5[1] + var_0_7[1]),
					12.5 - (iter_17_0 - 1) * (var_0_5[2] + var_0_7[2]),
					0
				},
				area_size = {
					65,
					65
				}
			}
		end
	end

	var_17_2.talent_hover_frame = var_17_7.texture
	var_17_2.talent_frame = "talent_frame"
	var_17_2.lock_icon = "lobby_icon_lock"
	var_17_0.element.passes = var_17_1
	var_17_0.content = var_17_2
	var_17_0.style = var_17_3
	var_17_0.scenegraph_id = arg_17_0
	var_17_0.offset = var_17_4

	return var_17_0
end

local function var_0_27(arg_22_0, arg_22_1, arg_22_2)
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_change_function = function(arg_23_0, arg_23_1)
						arg_23_1.offset[1] = arg_23_0.default_loadout and 25 or 0
					end
				},
				{
					pass_type = "texture",
					style_id = "lock_icon",
					texture_id = "lock_icon",
					content_check_function = function(arg_24_0, arg_24_1)
						return arg_24_0.default_loadout
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

local function var_0_28(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
	local var_25_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_25_1)
	local var_25_1 = arg_25_4 and {
		var_25_0.size[1] * arg_25_4,
		var_25_0.size[2] * arg_25_4
	} or var_25_0.size

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
					var_25_1[1],
					var_25_1[2]
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
					var_25_1[1],
					var_25_1[2]
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
					var_25_1[1],
					var_25_1[2]
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
					var_25_1[1],
					var_25_1[2]
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

local var_0_29
local var_0_30 = "icons_placeholder"
local var_0_31
local var_0_32 = ""
local var_0_33
local var_0_34
local var_0_35
local var_0_36 = false
local var_0_37 = true
local var_0_38 = false
local var_0_39 = true
local var_0_40 = {
	locked_info_text = var_0_23("", "locked_info_text"),
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
	info_career_name = UIWidgets.create_simple_text("n/a", "info_career_name", nil, nil, var_0_13),
	info_hero_name = UIWidgets.create_simple_text("n/a", "info_hero_name", nil, nil, var_0_14),
	info_hero_level = UIWidgets.create_simple_text("n/a", "info_hero_level", nil, nil, var_0_15),
	loadout_window_background = UIWidgets.create_rect_with_outer_frame("loadout_window_bg", var_0_12.loadout_window_bg.size, "frame_outer_fade_02", 0, Colors.get_color_table_with_alpha("console_menu_rect", 192)),
	loadout_frame = UIWidgets.create_rect_with_outer_frame("button", var_0_11, "frame_outer_glow_01", nil, {
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
	confirm_button = UIWidgets.create_default_button("confirm_button", var_0_12.confirm_button.size, nil, nil, Localize("input_description_confirm"), nil, nil, nil, nil, true),
	loadout_info_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "loadout_info_divider"),
	selected_loadout_header = UIWidgets.create_simple_text("DEFAULT LOADOUT", "selected_loadout_header", nil, nil, var_0_21),
	selected_loadout_desc = UIWidgets.create_simple_text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean dolor justo, maximus sit amet tristique eget, laoreet non erat.", "selected_loadout_header", nil, nil, var_0_22),
	selected_loadout_icon = UIWidgets.create_simple_texture("icons_placeholder", "selected_loadout_icon")
}
local var_0_41 = {
	weapons_header = var_0_27("hero_window_equipment", "weapons_header", var_0_19),
	loadout_weapons = var_0_24("weapons", {
		0,
		0,
		10
	}),
	talents_header = var_0_27("hero_window_talents", "talents_header", var_0_19),
	loadout_talents = var_0_25("talents", {
		0,
		0,
		10
	})
}
local var_0_42 = {
	item_grid = UIWidgets.create_grid("item_grid", var_0_12.item_grid.size, 3, 5, 25, 10, false, nil, false),
	talent_grid = var_0_26("talent_grid"),
	back_button = var_0_28("back_button", "layout_button_back", "layout_button_back_glow", {
		-60,
		-20,
		100
	}, 0.5)
}
local var_0_43 = {}

for iter_0_0, iter_0_1 in ipairs(InventorySettings.loadouts) do
	local var_0_44 = iter_0_1.loadout_type == "custom" and -20 or 0

	var_0_43[#var_0_43 + 1] = UIWidgets.create_default_button("button", var_0_11, var_0_29, var_0_30, var_0_32, var_0_31, var_0_33, var_0_34, var_0_35, var_0_36, var_0_37, var_0_38, {
		0,
		var_0_44 - (var_0_11[1] + 5) * (iter_0_0 - 1),
		0
	}, var_0_39)
end

local var_0_45 = true
local var_0_46 = {
	background = UIWidgets.create_simple_rect("screen", {
		0,
		0,
		0,
		0
	}, 100),
	info_window_background = UIWidgets.create_rect_with_outer_frame("info_window", var_0_12.info_window.size, "frame_outer_fade_02", 0, Colors.get_color_table_with_alpha("console_menu_rect", 192)),
	mask = UIWidgets.create_simple_texture("mask_rect", "scrollbar_anchor"),
	info_window_video = UIWidgets.create_frame("info_window_video", var_0_12.info_window_video.size, "menu_frame_06"),
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
	perk_title_text = UIWidgets.create_simple_text(Localize("hero_view_perk_title"), "perk_title_text", nil, nil, var_0_18),
	perk_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "perk_title_divider", true),
	career_perk_1 = UIWidgets.create_career_perk_text("career_perk_1"),
	career_perk_2 = UIWidgets.create_career_perk_text("career_perk_2"),
	career_perk_3 = UIWidgets.create_career_perk_text("career_perk_3"),
	passive_title_text = UIWidgets.create_simple_text("n/a", "passive_title_text", nil, nil, var_0_18),
	passive_type_title = UIWidgets.create_simple_text(Localize("hero_view_passive_ability"), "passive_type_title", nil, nil, var_0_17),
	passive_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "passive_title_divider", true),
	passive_description_text = UIWidgets.create_simple_text("n/a", "passive_description_text", nil, nil, var_0_16),
	passive_icon = UIWidgets.create_simple_texture("icons_placeholder", "passive_icon", true),
	passive_icon_frame = UIWidgets.create_simple_texture("talent_frame", "passive_icon_frame", true),
	active_title_text = UIWidgets.create_simple_text("n/a", "active_title_text", nil, nil, var_0_18),
	active_type_title = UIWidgets.create_simple_text(Localize("hero_view_activated_ability"), "active_type_title", nil, nil, var_0_17),
	active_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "active_title_divider", true),
	active_description_text = UIWidgets.create_simple_text("n/a", "active_description_text", nil, nil, var_0_16),
	active_icon = UIWidgets.create_simple_texture("icons_placeholder", "active_icon", true),
	active_icon_frame = UIWidgets.create_simple_texture("talent_frame", "active_icon_frame", true)
}
local var_0_47 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				arg_26_3.render_settings.alpha_multiplier = 0
				arg_26_0.area_left.local_position[1] = arg_26_1.area_left.position[1] - 200
				arg_26_0.area_right.local_position[1] = arg_26_1.area_right.position[1] + 200
			end,
			update = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
				local var_27_0 = math.easeOutCubic(arg_27_3)

				arg_27_4.render_settings.alpha_multiplier = var_27_0 * var_27_0 * var_27_0
				arg_27_0.area_left.local_position[1] = math.lerp(arg_27_1.area_left.position[1] - 200, arg_27_1.area_left.position[1], var_27_0)
				arg_27_0.area_right.local_position[1] = math.lerp(arg_27_1.area_right.position[1] + 400, arg_27_1.area_right.position[1], var_27_0)
			end,
			on_complete = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				return
			end
		}
	},
	open_equipment_inventory = {
		{
			name = "slide_and_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				arg_29_3.render_settings.alpha_multiplier = 0
				arg_29_0.loadout_anchor.local_position[1] = arg_29_1.loadout_anchor.position[1] - 75
			end,
			update = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				local var_30_0 = math.easeOutCubic(arg_30_3)

				arg_30_4.render_settings.alpha_multiplier = var_30_0 * var_30_0 * var_30_0
				arg_30_0.loadout_anchor.local_position[1] = math.lerp(arg_30_1.loadout_anchor.position[1] - 75, arg_30_1.loadout_anchor.position[1], var_30_0)
			end,
			on_complete = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end
		}
	},
	show_loadout = {
		{
			name = "slide_and_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				arg_32_3.render_settings.alpha_multiplier = 0
				arg_32_0.loadout_anchor.local_position[1] = arg_32_1.loadout_anchor.position[1] + 75
			end,
			update = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
				local var_33_0 = math.easeOutCubic(arg_33_3)

				arg_33_4.render_settings.alpha_multiplier = var_33_0 * var_33_0 * var_33_0
				arg_33_0.loadout_anchor.local_position[1] = math.lerp(arg_33_1.loadout_anchor.position[1] + 75, arg_33_1.loadout_anchor.position[1], var_33_0)
			end,
			on_complete = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end
		}
	}
}
local var_0_48 = {
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
	scenegraph_definition = var_0_12,
	widget_definitions = var_0_40,
	loadout_widgets_definitions = var_0_41,
	loadout_selection_widget_definitions = var_0_42,
	loadout_button_widget_definitions = var_0_43,
	info_window_widgets_definitions = var_0_46,
	animation_definitions = var_0_47,
	console_cursor_definition = UIWidgets.create_console_cursor("console_cursor"),
	hero_icon_widget = UIWidgets.create_hero_icon_widget("hero_icon_root", var_0_12.hero_icon_root.size),
	hero_widget = UIWidgets.create_hero_widget("hero_root", var_0_12.hero_root.size),
	weapon_slots = var_0_10,
	tag_widget_func = UIWidgets.create_tag,
	generic_input_actions = var_0_48
}
