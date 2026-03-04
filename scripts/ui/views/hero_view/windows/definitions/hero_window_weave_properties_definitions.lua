-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_weave_properties_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.size
local var_0_2 = var_0_0.spacing
local var_0_3 = var_0_0.large_window_frame
local var_0_4 = UIFrameSettings[var_0_3].texture_sizes.vertical[1]
local var_0_5 = {
	var_0_1[1] * 3 + var_0_2 * 2 + var_0_4 * 2,
	var_0_1[2] + 80
}
local var_0_6 = {
	var_0_5[1] + 50,
	var_0_5[2]
}
local var_0_7 = "menu_frame_11"
local var_0_8 = UIFrameSettings[var_0_7].texture_sizes.vertical[1]
local var_0_9 = UISettings.game_start_windows
local var_0_10 = 85
local var_0_11 = 85
local var_0_12 = {
	16,
	var_0_6[2] - (var_0_8 * 2 + 220)
}
local var_0_13 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	screen_center = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = var_0_6,
		position = {
			0,
			0,
			1
		}
	},
	window_overlay = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = var_0_6,
		position = {
			0,
			0,
			5
		}
	},
	viewport = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_6[1] - var_0_8 * 2,
			var_0_6[2] - var_0_8 * 2
		},
		position = {
			0,
			var_0_8,
			3
		}
	},
	viewport_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			560,
			var_0_6[2] - var_0_8 * 2
		},
		position = {
			var_0_8,
			var_0_8,
			3
		}
	},
	viewport_background = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			300,
			var_0_6[2] - var_0_8 * 2
		},
		position = {
			var_0_8,
			var_0_8,
			2
		}
	},
	viewport_background_fade = {
		vertical_alignment = "bottom",
		parent = "viewport_background",
		horizontal_alignment = "right",
		size = {
			var_0_6[2] - var_0_8 * 2,
			300
		},
		position = {
			-2,
			0,
			0
		}
	},
	viewport_panel = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			450,
			100
		},
		position = {
			-545,
			90,
			3
		}
	},
	viewport_panel_divider = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			68,
			19
		},
		position = {
			0,
			0,
			1
		}
	},
	viewport_panel_divider_left = {
		vertical_alignment = "center",
		parent = "viewport_panel_divider",
		horizontal_alignment = "left",
		size = {
			55,
			19
		},
		position = {
			-166,
			0,
			0
		}
	},
	viewport_panel_divider_right = {
		vertical_alignment = "center",
		parent = "viewport_panel_divider",
		horizontal_alignment = "right",
		size = {
			55,
			19
		},
		position = {
			166,
			0,
			0
		}
	},
	viewport_title = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			450,
			50
		},
		position = {
			0,
			70,
			3
		}
	},
	viewport_sub_title = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			450,
			50
		},
		position = {
			0,
			40,
			3
		}
	},
	panel_level_title = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			-90,
			0,
			2
		}
	},
	panel_level_value = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			-90,
			-30,
			2
		}
	},
	panel_power_title = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			90,
			0,
			2
		}
	},
	panel_power_value = {
		vertical_alignment = "top",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			110,
			20
		},
		position = {
			90,
			-30,
			2
		}
	},
	bottom_left_corner = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			var_0_8,
			var_0_8,
			12
		}
	},
	upgrade_button = {
		vertical_alignment = "bottom",
		parent = "viewport_panel",
		horizontal_alignment = "center",
		size = {
			452,
			112
		},
		position = {
			0,
			-60,
			2
		}
	},
	upgrade_essence_warning = {
		vertical_alignment = "bottom",
		parent = "upgrade_button",
		horizontal_alignment = "center",
		size = {
			296,
			30
		},
		position = {
			3,
			-10,
			3
		}
	},
	slot_root = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			-180,
			0,
			0
		}
	},
	slot_cluster = {
		vertical_alignment = "center",
		parent = "slot_root",
		horizontal_alignment = "center",
		size = {
			273,
			273
		},
		position = {
			0,
			0,
			4
		}
	},
	mastery_text = {
		vertical_alignment = "center",
		parent = "slot_root",
		horizontal_alignment = "center",
		size = {
			430,
			50
		},
		position = {
			0,
			0,
			10
		}
	},
	mastery_tooltip = {
		vertical_alignment = "center",
		parent = "slot_root",
		horizontal_alignment = "center",
		size = {
			160,
			160
		},
		position = {
			0,
			0,
			10
		}
	},
	mastery_title_text = {
		vertical_alignment = "center",
		parent = "mastery_text",
		horizontal_alignment = "center",
		size = {
			430,
			50
		},
		position = {
			0,
			40,
			0
		}
	},
	mastery_icon = {
		vertical_alignment = "center",
		parent = "mastery_text",
		horizontal_alignment = "center",
		size = {
			55,
			55
		},
		position = {
			0,
			-45,
			0
		}
	},
	background_wheel = {
		vertical_alignment = "center",
		parent = "slot_root",
		horizontal_alignment = "center",
		size = {
			1022,
			1022
		},
		position = {
			0,
			0,
			1
		}
	},
	wheel_ring_1 = {
		vertical_alignment = "center",
		parent = "slot_root",
		horizontal_alignment = "center",
		size = {
			188,
			188
		},
		position = {
			0,
			0,
			1
		}
	},
	wheel_ring_2 = {
		vertical_alignment = "center",
		parent = "slot_root",
		horizontal_alignment = "center",
		size = {
			461,
			461
		},
		position = {
			0,
			0,
			1
		}
	},
	wheel_ring_3 = {
		vertical_alignment = "center",
		parent = "slot_root",
		horizontal_alignment = "center",
		size = {
			1074,
			1074
		},
		position = {
			0,
			0,
			1
		}
	},
	options_background_mask = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			900,
			900
		},
		position = {
			0,
			0,
			0
		}
	},
	options_background = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			900,
			900
		},
		position = {
			0,
			0,
			0
		}
	},
	options_window_edge = {
		vertical_alignment = "center",
		parent = "options_background",
		horizontal_alignment = "right",
		size = {
			0,
			900
		},
		position = {
			0,
			0,
			0
		}
	},
	options_scroll_field = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			520,
			706
		},
		position = {
			0,
			0,
			20
		}
	},
	title_background = {
		vertical_alignment = "top",
		parent = "options_window_edge",
		horizontal_alignment = "right",
		size = {
			541,
			111
		},
		position = {
			-var_0_8,
			-var_0_8,
			10
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "title_background",
		horizontal_alignment = "center",
		size = {
			320,
			30
		},
		position = {
			3,
			-5,
			1
		}
	},
	sub_title_text = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			320,
			30
		},
		position = {
			0,
			-31,
			0
		}
	},
	clear_background = {
		vertical_alignment = "bottom",
		parent = "options_window_edge",
		horizontal_alignment = "right",
		size = {
			541,
			111
		},
		position = {
			-var_0_8,
			var_0_8,
			10
		}
	},
	clear_button = {
		vertical_alignment = "bottom",
		parent = "clear_background",
		horizontal_alignment = "center",
		size = {
			300,
			60
		},
		position = {
			0,
			5,
			1
		}
	},
	options_list_scrollbar = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = var_0_12,
		position = {
			-(var_0_8 + 20),
			0,
			10
		}
	},
	options_background_edge = {
		vertical_alignment = "center",
		parent = "options_window_edge",
		horizontal_alignment = "right",
		size = {
			126,
			900
		},
		position = {
			-443,
			0,
			1
		}
	},
	options_root = {
		vertical_alignment = "center",
		parent = "options_background_edge",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	option_trait = {
		vertical_alignment = "center",
		parent = "options_root",
		horizontal_alignment = "left",
		size = {
			378,
			194
		},
		position = {
			6,
			0,
			0
		}
	},
	option_talent = {
		vertical_alignment = "center",
		parent = "options_root",
		horizontal_alignment = "left",
		size = {
			377,
			230
		},
		position = {
			6,
			0,
			0
		}
	},
	option_propery = {
		vertical_alignment = "center",
		parent = "options_root",
		horizontal_alignment = "left",
		size = {
			381,
			124
		},
		position = {
			6,
			0,
			0
		}
	},
	upgrade_bg = {
		vertical_alignment = "center",
		parent = "upgrade_button",
		horizontal_alignment = "center",
		size = {
			900,
			400
		},
		position = {
			0,
			410,
			11
		}
	},
	upgrade_text = {
		vertical_alignment = "center",
		parent = "upgrade_button",
		horizontal_alignment = "center",
		size = {
			500,
			50
		},
		position = {
			0,
			400,
			12
		}
	}
}
local var_0_14 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = false,
	font_size = 52,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = {
		180,
		0,
		0,
		0
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_15 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header_masked",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_16 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header_masked",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_17 = {
	font_size = 58,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = {
		255,
		121,
		193,
		229
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_18 = {
	font_size = 20,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = {
		255,
		121,
		193,
		229
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_19 = {
	font_size = 22,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		2,
		2
	}
}
local var_0_20 = {
	font_size = 22,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		2,
		2
	}
}
local var_0_21 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 18,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = {
		255,
		120,
		120,
		120
	},
	offset = {
		0,
		0,
		2
	}
}
local var_0_22 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 38,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_23 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_24 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 22,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}

local function var_0_25(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = {
		{
			style_id = "icon",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			style_id = "tooltip",
			additional_option_id = "tooltip",
			pass_type = "additional_option_tooltip",
			content_passes = {
				"weave_progression_slot_titles"
			},
			content_check_function = function (arg_2_0)
				return arg_2_0.tooltip and arg_2_0.button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (arg_3_0)
				return arg_3_0.icon and not arg_3_0.highlight
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_highlight",
			texture_id = "icon",
			content_check_function = function (arg_4_0)
				return arg_4_0.icon and arg_4_0.highlight and not arg_4_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "slot",
			texture_id = "slot",
			content_check_function = function (arg_5_0)
				return not arg_5_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "slot_locked",
			texture_id = "slot_locked",
			content_check_function = function (arg_6_0)
				return arg_6_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "fill_effect",
			texture_id = "slot",
			content_check_function = function (arg_7_0)
				return not arg_7_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "hover",
			texture_id = "hover",
			content_check_function = function (arg_8_0)
				return not arg_8_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "highlight_texture",
			texture_id = "highlight_texture",
			content_check_function = function (arg_9_0)
				return not arg_9_0.locked
			end
		},
		{
			style_id = "new_effect",
			pass_type = "texture",
			texture_id = "highlight_texture",
			content_change_function = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				local var_10_0 = arg_10_0.new_effect_timer

				if var_10_0 then
					local var_10_1 = 1
					local var_10_2 = math.min(var_10_0 + arg_10_3, var_10_1)
					local var_10_3 = var_10_2 / var_10_1
					local var_10_4 = math.easeInCubic(var_10_3)
					local var_10_5 = math.ease_pulse(var_10_3)
					local var_10_6 = arg_10_1.texture_size
					local var_10_7 = arg_10_1.default_texture_size

					var_10_6[1] = var_10_7[1] + var_10_7[1] * var_10_4
					var_10_6[2] = var_10_7[2] + var_10_7[2] * var_10_4
					arg_10_1.color[1] = 255 * var_10_5

					if var_10_3 == 1 then
						arg_10_0.new_effect_timer = nil
					else
						arg_10_0.new_effect_timer = var_10_2
					end
				end
			end,
			content_check_function = function (arg_11_0)
				return arg_11_0.new_effect_timer
			end
		}
	}
	local var_1_1 = {
		text = "-",
		slot = "athanor_skilltree_slot_property_unlocked",
		hover = "athanor_skilltree_slot_property_hover",
		highlight_texture = "athanor_skilltree_slot_property_active",
		slot_locked = "athanor_skilltree_slot_property_locked",
		button_hotspot = {},
		size = arg_1_1
	}
	local var_1_2 = {
		tooltip = {
			vertical_alignment = "top",
			max_width = 300,
			horizontal_alignment = "center",
			offset = {
				0,
				arg_1_1[2] / 2,
				0
			}
		},
		icon = {
			masked = arg_1_2,
			color = {
				255,
				143,
				216,
				255
			},
			offset = {
				-arg_1_1[1] / 2,
				-arg_1_1[2] / 2,
				3
			},
			size = arg_1_1
		},
		icon_highlight = {
			masked = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-arg_1_1[1] / 2,
				-arg_1_1[2] / 2,
				3
			},
			size = arg_1_1
		},
		slot = {
			masked = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-35,
				-35,
				2
			},
			size = {
				70,
				70
			}
		},
		slot_locked = {
			masked = arg_1_2,
			color = {
				255,
				120,
				120,
				120
			},
			default_color = {
				255,
				120,
				120,
				120
			},
			hover_color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-35,
				-35,
				2
			},
			size = {
				70,
				70
			}
		},
		fill_effect = {
			masked = arg_1_2,
			color = {
				0,
				255,
				255,
				255
			},
			default_offset = {
				-35,
				-35,
				2
			},
			default_size = {
				70,
				70
			},
			offset = {
				-35,
				-35,
				1
			},
			size = {
				70,
				70
			}
		},
		hover = {
			masked = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-64,
				-64,
				5
			},
			size = {
				128,
				128
			}
		},
		highlight_texture = {
			masked = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-64,
				-64,
				4
			},
			size = {
				128,
				128
			}
		},
		new_effect = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_1_2,
			texture_size = {
				128,
				128
			},
			default_texture_size = {
				128,
				128
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
		text = {
			vertical_alignment = "center",
			font_size = 20,
			horizontal_alignment = "center",
			font_type = arg_1_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-arg_1_1[1] / 2,
				-arg_1_1[2] / 2,
				5
			},
			size = arg_1_1
		}
	}

	return {
		element = {
			passes = var_1_0
		},
		content = var_1_1,
		style = var_1_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local function var_0_26(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = {
		{
			style_id = "icon",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "slot",
			texture_id = "slot",
			content_check_function = function (arg_13_0)
				return not arg_13_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "slot_locked",
			texture_id = "slot_locked",
			content_check_function = function (arg_14_0)
				return arg_14_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "fill_effect",
			texture_id = "slot",
			content_check_function = function (arg_15_0)
				return not arg_15_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (arg_16_0)
				return arg_16_0.icon
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_mask",
			texture_id = "icon_mask",
			content_check_function = function (arg_17_0)
				return arg_17_0.icon
			end
		},
		{
			additional_option_id = "tooltip",
			style_id = "tooltip",
			pass_type = "additional_option_tooltip",
			content_passes = {
				"weave_progression_slot_titles"
			},
			content_check_function = function (arg_18_0)
				return arg_18_0.tooltip and arg_18_0.button_hotspot.is_hover
			end
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text",
			content_check_function = function (arg_19_0)
				return not arg_19_0.locked and not arg_19_0.icon
			end
		},
		{
			pass_type = "texture",
			style_id = "hover",
			texture_id = "hover",
			content_check_function = function (arg_20_0)
				return not arg_20_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "highlight_texture",
			texture_id = "highlight_texture",
			content_check_function = function (arg_21_0)
				return not arg_21_0.locked
			end
		},
		{
			style_id = "new_effect",
			texture_id = "highlight_texture",
			pass_type = "texture",
			content_change_function = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				local var_22_0 = arg_22_0.new_effect_timer

				if var_22_0 then
					local var_22_1 = 1
					local var_22_2 = math.min(var_22_0 + arg_22_3, var_22_1)
					local var_22_3 = var_22_2 / var_22_1
					local var_22_4 = math.easeInCubic(var_22_3)
					local var_22_5 = math.ease_pulse(var_22_3)
					local var_22_6 = arg_22_1.texture_size
					local var_22_7 = arg_22_1.default_texture_size

					var_22_6[1] = var_22_7[1] + var_22_7[1] * var_22_4
					var_22_6[2] = var_22_7[2] + var_22_7[2] * var_22_4
					arg_22_1.color[1] = 255 * var_22_5

					if var_22_3 == 1 then
						arg_22_0.new_effect_timer = nil
					else
						arg_22_0.new_effect_timer = var_22_2
					end
				end
			end
		}
	}
	local var_12_1 = {
		text = "",
		slot = "athanor_skilltree_slot_talent",
		slot_locked = "athanor_skilltree_slot_talent_locked",
		highlight_texture = "athanor_skilltree_slot_talent_active",
		icon_mask = "mask_circular",
		hover = "athanor_skilltree_slot_talent_hover",
		button_hotspot = {},
		size = arg_12_1
	}
	local var_12_2 = {
		tooltip = {
			vertical_alignment = "top",
			max_width = 300,
			horizontal_alignment = "center",
			offset = {
				0,
				arg_12_1[2] / 2,
				0
			}
		},
		icon_mask = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-35,
				-35,
				3
			},
			size = {
				70,
				70
			}
		},
		icon = {
			masked = true,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-40,
				-40,
				3
			},
			size = {
				80,
				80
			}
		},
		slot = {
			masked = arg_12_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-50,
				-50,
				2
			},
			size = {
				100,
				100
			}
		},
		slot_locked = {
			masked = arg_12_2,
			color = {
				255,
				120,
				120,
				120
			},
			default_color = {
				255,
				120,
				120,
				120
			},
			hover_color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-64,
				-64,
				2
			},
			size = {
				128,
				128
			}
		},
		fill_effect = {
			masked = arg_12_2,
			color = {
				0,
				255,
				255,
				255
			},
			default_offset = {
				-50,
				-50,
				2
			},
			default_size = {
				100,
				100
			},
			offset = {
				-50,
				-50,
				1
			},
			size = {
				100,
				100
			}
		},
		hover = {
			masked = arg_12_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-64,
				-64,
				5
			},
			size = {
				128,
				128
			}
		},
		highlight_texture = {
			masked = arg_12_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-64,
				-64,
				4
			},
			size = {
				128,
				128
			}
		},
		new_effect = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_12_2,
			texture_size = {
				128,
				128
			},
			default_texture_size = {
				128,
				128
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
		text = {
			horizontal_alignment = "center",
			font_size = 38,
			word_wrap = true,
			vertical_alignment = "center",
			font_type = arg_12_2 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				87,
				39,
				141
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-arg_12_1[1] / 2,
				-arg_12_1[2] / 2 + 14,
				3
			},
			size = arg_12_1
		}
	}

	return {
		element = {
			passes = var_12_0
		},
		content = var_12_1,
		style = var_12_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_12_0
	}
end

local function var_0_27(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = {
		{
			style_id = "icon",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			additional_option_id = "tooltip",
			style_id = "tooltip",
			pass_type = "additional_option_tooltip",
			content_passes = {
				"weave_progression_slot_titles"
			},
			content_check_function = function (arg_24_0)
				return arg_24_0.tooltip and arg_24_0.button_hotspot.is_hover
			end
		},
		{
			pass_type = "texture",
			style_id = "slot",
			texture_id = "slot",
			content_check_function = function (arg_25_0)
				return not arg_25_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "slot_locked",
			texture_id = "slot_locked",
			content_check_function = function (arg_26_0)
				return arg_26_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "fill_effect",
			texture_id = "slot",
			content_check_function = function (arg_27_0)
				return not arg_27_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (arg_28_0)
				return arg_28_0.icon
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_mask",
			texture_id = "icon_mask",
			content_check_function = function (arg_29_0)
				return arg_29_0.icon
			end
		},
		{
			pass_type = "texture",
			style_id = "hover",
			texture_id = "hover",
			content_check_function = function (arg_30_0)
				return not arg_30_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "highlight_texture",
			texture_id = "highlight_texture",
			content_check_function = function (arg_31_0)
				return not arg_31_0.locked
			end
		},
		{
			style_id = "new_effect",
			texture_id = "highlight_texture",
			pass_type = "texture",
			content_change_function = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
				local var_32_0 = arg_32_0.new_effect_timer

				if var_32_0 then
					local var_32_1 = 1
					local var_32_2 = math.min(var_32_0 + arg_32_3, var_32_1)
					local var_32_3 = var_32_2 / var_32_1
					local var_32_4 = math.easeInCubic(var_32_3)
					local var_32_5 = math.ease_pulse(var_32_3)
					local var_32_6 = arg_32_1.texture_size
					local var_32_7 = arg_32_1.default_texture_size

					var_32_6[1] = var_32_7[1] + var_32_7[1] * var_32_4
					var_32_6[2] = var_32_7[2] + var_32_7[2] * var_32_4
					arg_32_1.color[1] = 255 * var_32_5

					if var_32_3 == 1 then
						arg_32_0.new_effect_timer = nil
					else
						arg_32_0.new_effect_timer = var_32_2
					end
				end
			end
		}
	}
	local var_23_1 = {
		text = "-",
		slot = "athanor_skilltree_slot_trait_unlocked",
		slot_locked = "athanor_skilltree_slot_trait_locked",
		highlight_texture = "athanor_skilltree_slot_trait_active",
		icon_mask = "mask_circular",
		hover = "athanor_skilltree_slot_trait_hover",
		button_hotspot = {},
		size = arg_23_1
	}
	local var_23_2 = {
		tooltip = {
			vertical_alignment = "top",
			max_width = 300,
			horizontal_alignment = "center",
			offset = {
				0,
				arg_23_1[2] / 2,
				0
			}
		},
		icon = {
			masked = false,
			color = {
				255,
				255,
				200,
				150
			},
			offset = {
				-25,
				-25,
				3
			},
			size = {
				50,
				50
			}
		},
		icon_mask = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-20,
				-20,
				3
			},
			size = {
				40,
				40
			}
		},
		slot = {
			masked = arg_23_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-42.5,
				-42.5,
				2
			},
			size = {
				85,
				85
			}
		},
		slot_locked = {
			masked = arg_23_2,
			color = {
				255,
				120,
				120,
				120
			},
			default_color = {
				255,
				120,
				120,
				120
			},
			hover_color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-42.5,
				-42.5,
				2
			},
			size = {
				85,
				85
			}
		},
		fill_effect = {
			masked = arg_23_2,
			color = {
				0,
				255,
				255,
				255
			},
			default_offset = {
				-42.5,
				-42.5,
				2
			},
			default_size = {
				85,
				85
			},
			offset = {
				-42.5,
				-42.5,
				1
			},
			size = {
				85,
				85
			}
		},
		hover = {
			masked = arg_23_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-64,
				-64,
				4
			},
			size = {
				128,
				128
			}
		},
		highlight_texture = {
			masked = arg_23_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-64,
				-64,
				4
			},
			size = {
				128,
				128
			}
		},
		new_effect = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_23_2,
			texture_size = {
				128,
				128
			},
			default_texture_size = {
				128,
				128
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
		text = {
			vertical_alignment = "center",
			font_size = 20,
			horizontal_alignment = "center",
			font_type = arg_23_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-arg_23_1[1] / 2,
				-arg_23_1[2] / 2,
				5
			},
			size = arg_23_1
		}
	}

	return {
		element = {
			passes = var_23_0
		},
		content = var_23_1,
		style = var_23_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_23_0
	}
end

local function var_0_28(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "connect_texture",
			texture_id = "connect_texture"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (arg_34_0)
				return not arg_34_0.button_hotspot.disable_button
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_disabled",
			texture_id = "icon",
			content_check_function = function (arg_35_0)
				return arg_35_0.button_hotspot.disable_button
			end
		},
		{
			pass_type = "texture",
			style_id = "value_glow",
			texture_id = "value_glow"
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (arg_36_0)
				return not arg_36_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "title_text_disabled",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (arg_37_0)
				return arg_37_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "price_text",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (arg_38_0)
				return not arg_38_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "price_text_disabled",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (arg_39_0)
				return arg_39_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "price_text_shadow",
			pass_type = "text",
			text_id = "price_text"
		},
		{
			pass_type = "texture",
			style_id = "price_icon",
			texture_id = "price_icon",
			content_check_function = function (arg_40_0)
				return not arg_40_0.button_hotspot.disable_button and arg_40_0.used_amount < arg_40_0.total_uses
			end
		},
		{
			pass_type = "texture",
			style_id = "lock_icon",
			texture_id = "lock_icon",
			content_check_function = function (arg_41_0)
				return arg_41_0.button_hotspot.disable_button
			end
		},
		{
			pass_type = "texture",
			style_id = "hover",
			texture_id = "hover"
		},
		{
			style_id = "total_value_text",
			pass_type = "text",
			text_id = "total_value_text",
			content_check_function = function (arg_42_0)
				return arg_42_0.used_amount >= 1
			end
		},
		{
			style_id = "total_value_text_shadow",
			pass_type = "text",
			text_id = "total_value_text",
			content_check_function = function (arg_43_0)
				return arg_43_0.used_amount >= 1
			end
		},
		{
			pass_type = "texture",
			style_id = "amount_dot_1",
			texture_id = "amount_dot",
			content_check_function = function (arg_44_0)
				return 1 <= arg_44_0.total_uses - arg_44_0.used_amount
			end
		},
		{
			pass_type = "texture",
			style_id = "amount_dot_2",
			texture_id = "amount_dot",
			content_check_function = function (arg_45_0)
				return 2 <= arg_45_0.total_uses - arg_45_0.used_amount
			end
		},
		{
			pass_type = "texture",
			style_id = "amount_dot_3",
			texture_id = "amount_dot",
			content_check_function = function (arg_46_0)
				return 3 <= arg_46_0.total_uses - arg_46_0.used_amount
			end
		},
		{
			pass_type = "texture",
			style_id = "amount_dot_4",
			texture_id = "amount_dot",
			content_check_function = function (arg_47_0)
				return 4 <= arg_47_0.total_uses - arg_47_0.used_amount
			end
		},
		{
			pass_type = "texture",
			style_id = "amount_dot_5",
			texture_id = "amount_dot",
			content_check_function = function (arg_48_0)
				return 5 <= arg_48_0.total_uses - arg_48_0.used_amount
			end
		},
		{
			pass_type = "texture",
			style_id = "amount_dot_locked_1",
			texture_id = "amount_dot_locked",
			content_check_function = function (arg_49_0)
				return arg_49_0.total_uses < 1
			end
		},
		{
			pass_type = "texture",
			style_id = "amount_dot_locked_2",
			texture_id = "amount_dot_locked",
			content_check_function = function (arg_50_0)
				return arg_50_0.total_uses < 2
			end
		},
		{
			pass_type = "texture",
			style_id = "amount_dot_locked_3",
			texture_id = "amount_dot_locked",
			content_check_function = function (arg_51_0)
				return arg_51_0.total_uses < 3
			end
		},
		{
			pass_type = "texture",
			style_id = "amount_dot_locked_4",
			texture_id = "amount_dot_locked",
			content_check_function = function (arg_52_0)
				return arg_52_0.total_uses < 4
			end
		},
		{
			pass_type = "texture",
			style_id = "amount_dot_locked_5",
			texture_id = "amount_dot_locked",
			content_check_function = function (arg_53_0)
				return arg_53_0.total_uses < 5
			end
		}
	}
	local var_33_1 = {
		price_icon = "icon_mastery_small",
		title_text = "",
		value_glow = "athanor_entry_property_glow",
		frame = "athanor_entry_property_frame",
		total_uses = 0,
		lock_icon = "athanor_level_lock",
		amount_dot_locked = "athanor_entry_property_locked",
		icon = "icons_placeholder",
		price_text = "",
		hover = "athanor_entry_property_bg_hover",
		amount_dot = "athanor_entry_property_filled",
		used_amount = 0,
		total_value_text = "",
		connect_texture = "athanor_entry_connector",
		background = "athanor_entry_property_bg",
		button_hotspot = {},
		size = arg_33_1
	}
	local var_33_2 = {
		amount_dot_5 = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_33_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				62,
				24,
				5
			},
			texture_size = {
				16,
				16
			}
		},
		amount_dot_4 = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_33_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				69,
				13,
				5
			},
			texture_size = {
				16,
				16
			}
		},
		amount_dot_3 = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_33_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				72,
				0,
				5
			},
			texture_size = {
				16,
				16
			}
		},
		amount_dot_2 = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_33_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				69,
				-13,
				5
			},
			texture_size = {
				16,
				16
			}
		},
		amount_dot_1 = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_33_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				62,
				-25,
				5
			},
			texture_size = {
				16,
				16
			}
		},
		amount_dot_locked_5 = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_33_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				65,
				24,
				5
			},
			texture_size = {
				10,
				10
			}
		},
		amount_dot_locked_4 = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_33_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				72,
				13,
				5
			},
			texture_size = {
				10,
				10
			}
		},
		amount_dot_locked_3 = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_33_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				75,
				0,
				5
			},
			texture_size = {
				10,
				10
			}
		},
		amount_dot_locked_2 = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_33_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				72,
				-13,
				5
			},
			texture_size = {
				10,
				10
			}
		},
		amount_dot_locked_1 = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_33_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				65,
				-25,
				5
			},
			texture_size = {
				10,
				10
			}
		},
		debug = {
			masked = arg_33_2,
			color = {
				255,
				255,
				0,
				0
			},
			offset = {
				-1,
				-1,
				8
			},
			size = {
				3,
				3
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_33_2,
			color = {
				255,
				143,
				216,
				255
			},
			offset = {
				26,
				0,
				6
			},
			texture_size = {
				40,
				40
			}
		},
		icon_disabled = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_33_2,
			color = {
				255,
				80,
				80,
				80
			},
			offset = {
				26,
				0,
				6
			},
			texture_size = {
				40,
				40
			}
		},
		value_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = arg_33_2,
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				-4,
				0,
				6
			},
			texture_size = {
				84,
				110
			}
		},
		connect_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_33_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-20,
				0,
				0
			},
			texture_size = {
				58,
				18
			}
		},
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_33_2,
			color = {
				255,
				200,
				200,
				200
			},
			offset = {
				0,
				0,
				0
			},
			texture_size = arg_33_1
		},
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_33_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				4
			},
			texture_size = arg_33_1
		},
		hover = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_33_2,
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
			},
			texture_size = arg_33_1
		},
		lock_icon = {
			masked = arg_33_2,
			color = {
				255,
				80,
				80,
				80
			},
			offset = {
				100 + (arg_33_1[1] - 185) / 2 - 17.5,
				8.5,
				6
			},
			default_offset = {
				100 + (arg_33_1[1] - 185) / 2 - 17.5,
				8.5,
				6
			},
			size = {
				35,
				35
			}
		},
		price_icon = {
			masked = arg_33_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				100 + (arg_33_1[1] - 185) / 2 - 17.5,
				8.5,
				6
			},
			default_offset = {
				100 + (arg_33_1[1] - 185) / 2 - 17.5,
				8.5,
				6
			},
			size = {
				35,
				35
			}
		},
		price_text_disabled = {
			font_size = 18,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_33_2 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				80,
				80,
				80
			},
			offset = {
				100,
				17,
				3
			},
			default_offset = {
				100,
				17,
				3
			},
			size = {
				arg_33_1[1] - 185,
				20
			},
			color_override = {},
			color_override_table = {
				start_index = 0,
				end_index = 0,
				color = {
					255,
					121,
					193,
					229
				}
			}
		},
		price_text = {
			font_size = 18,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_33_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				100,
				17,
				3
			},
			default_offset = {
				100,
				17,
				3
			},
			size = {
				arg_33_1[1] - 185,
				20
			},
			color_override = {},
			color_override_table = {
				start_index = 0,
				end_index = 0,
				color = {
					255,
					121,
					193,
					229
				}
			}
		},
		price_text_shadow = {
			font_size = 18,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_33_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				102,
				15,
				2
			},
			default_offset = {
				102,
				15,
				2
			},
			size = {
				arg_33_1[1] - 185,
				20
			}
		},
		title_text_disabled = {
			font_size = 18,
			word_wrap = true,
			dynamic_font_size_word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_33_2 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				80,
				80,
				80
			},
			offset = {
				100,
				arg_33_1[2] - 80,
				3
			},
			size = {
				arg_33_1[1] - 190,
				70
			},
			color_override = {},
			color_override_table = {
				start_index = 0,
				end_index = 0,
				color = {
					255,
					80,
					80,
					80
				}
			}
		},
		title_text = {
			font_size = 18,
			word_wrap = true,
			dynamic_font_size_word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_33_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				100,
				arg_33_1[2] - 80,
				3
			},
			size = {
				arg_33_1[1] - 190,
				70
			},
			color_override = {},
			color_override_table = {
				start_index = 0,
				end_index = 0,
				color = Colors.get_color_table_with_alpha("corn_flower_blue", 255)
			}
		},
		title_text_shadow = {
			font_size = 18,
			word_wrap = true,
			dynamic_font_size_word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_33_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				102,
				arg_33_1[2] - 80 - 2,
				2
			},
			size = {
				arg_33_1[1] - 190,
				70
			}
		},
		total_value_text = {
			font_size = 24,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_33_2 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				17,
				50,
				157
			},
			color = {
				100,
				255,
				255,
				255
			},
			offset = {
				arg_33_1[1] - 75,
				arg_33_1[2] / 2 - 13,
				7
			},
			size = {
				60,
				30
			}
		},
		total_value_text_shadow = {
			font_size = 24,
			horizontal_alignment = "center",
			word_wrap = true,
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_33_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 0),
			offset = {
				arg_33_1[1] - 75 + 2,
				arg_33_1[2] / 2 - 13 - 2,
				6
			},
			size = {
				60,
				30
			}
		}
	}

	return {
		element = {
			passes = var_33_0
		},
		content = var_33_1,
		style = var_33_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_33_0
	}
end

local function var_0_29(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = {
		255,
		255,
		255,
		255
	}
	local var_54_1 = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "connect_texture",
			texture_id = "connect_texture"
		},
		{
			pass_type = "texture",
			style_id = "icon_equipped_frame",
			texture_id = "icon_equipped_frame",
			content_check_function = function (arg_55_0)
				return arg_55_0.used_amount > 0
			end
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (arg_56_0)
				return not arg_56_0.button_hotspot.disable_button
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_disabled",
			texture_id = "icon",
			content_check_function = function (arg_57_0)
				return arg_57_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "text_disabled",
			pass_type = "text",
			text_id = "text",
			content_check_function = function (arg_58_0)
				return arg_58_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text",
			content_check_function = function (arg_59_0)
				return not arg_59_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text"
		},
		{
			style_id = "title_text_disabled",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (arg_60_0)
				return arg_60_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (arg_61_0)
				return not arg_61_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "price_text_disabled",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (arg_62_0)
				return arg_62_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "price_text",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (arg_63_0)
				return not arg_63_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "price_text_shadow",
			pass_type = "text",
			text_id = "price_text"
		},
		{
			pass_type = "texture",
			style_id = "price_icon",
			texture_id = "price_icon",
			content_check_function = function (arg_64_0)
				return not arg_64_0.button_hotspot.disable_button and arg_64_0.used_amount < arg_64_0.total_uses
			end
		},
		{
			pass_type = "texture",
			style_id = "value_glow",
			texture_id = "value_glow"
		},
		{
			pass_type = "texture",
			style_id = "lock_icon",
			texture_id = "lock_icon",
			content_check_function = function (arg_65_0)
				return arg_65_0.button_hotspot.disable_button
			end
		},
		{
			pass_type = "texture",
			style_id = "hover",
			texture_id = "hover"
		}
	}
	local var_54_2 = {
		price_text = "0",
		price_icon = "icon_mastery_small",
		hover = "athanor_entry_trait_bg_hover",
		value_glow = "athanor_entry_trait_glow",
		frame = "athanor_entry_trait_frame",
		used_amount = 0,
		total_uses = 0,
		text = "-",
		connect_texture = "athanor_entry_connector",
		background = "athanor_entry_trait_bg",
		title_text = "n/a",
		lock_icon = "athanor_level_lock",
		icon = "icons_placeholder",
		icon_equipped_frame = "athanor_skilltree_slot_trait_active",
		button_hotspot = {},
		size = arg_54_1
	}
	local var_54_3 = {
		debug = {
			masked = arg_54_2,
			color = {
				255,
				255,
				0,
				0
			},
			offset = {
				-1,
				-1,
				8
			},
			size = {
				3,
				3
			}
		},
		icon_equipped_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_54_2,
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				-18,
				0,
				4
			},
			texture_size = {
				128,
				128
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_54_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				26,
				0,
				3
			},
			texture_size = {
				40,
				40
			}
		},
		value_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = arg_54_2,
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				-22,
				0,
				3
			},
			texture_size = {
				54,
				165
			}
		},
		icon_disabled = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_54_2,
			color = {
				255,
				80,
				80,
				80
			},
			offset = {
				26,
				0,
				3
			},
			texture_size = {
				40,
				40
			}
		},
		connect_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_54_2,
			color = var_54_0,
			offset = {
				-20,
				0,
				0
			},
			texture_size = {
				58,
				18
			}
		},
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_54_2,
			color = var_54_0,
			offset = {
				0,
				0,
				0
			},
			texture_size = arg_54_1
		},
		hover = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_54_2,
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
			},
			texture_size = arg_54_1
		},
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_54_2,
			color = var_54_0,
			offset = {
				0,
				0,
				2
			},
			texture_size = arg_54_1
		},
		lock_icon = {
			masked = arg_54_2,
			color = {
				255,
				80,
				80,
				80
			},
			offset = {
				100 + (arg_54_1[1] - 160) / 2 - 17.5,
				12.5,
				6
			},
			default_offset = {
				100 + (arg_54_1[1] - 160) / 2 - 17.5,
				12.5,
				6
			},
			size = {
				35,
				35
			}
		},
		price_icon = {
			masked = arg_54_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				100 + (arg_54_1[1] - 160) / 2 - 17.5,
				12.5,
				6
			},
			default_offset = {
				100 + (arg_54_1[1] - 160) / 2 - 17.5,
				12.5,
				6
			},
			size = {
				35,
				35
			}
		},
		price_text_disabled = {
			font_size = 18,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_54_2 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				80,
				80,
				80
			},
			offset = {
				100,
				20,
				3
			},
			default_offset = {
				100,
				20,
				3
			},
			size = {
				arg_54_1[1] - 160,
				20
			},
			color_override = {},
			color_override_table = {
				start_index = 0,
				end_index = 0,
				color = {
					255,
					121,
					193,
					229
				}
			}
		},
		price_text = {
			font_size = 18,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_54_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				100,
				20,
				3
			},
			default_offset = {
				100,
				20,
				3
			},
			size = {
				arg_54_1[1] - 160,
				20
			},
			color_override = {},
			color_override_table = {
				start_index = 0,
				end_index = 0,
				color = {
					255,
					121,
					193,
					229
				}
			}
		},
		price_text_shadow = {
			font_size = 18,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_54_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				102,
				18,
				2
			},
			default_offset = {
				102,
				18,
				2
			},
			size = {
				arg_54_1[1] - 160,
				20
			}
		},
		title_text_disabled = {
			font_size = 20,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_54_2 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				100,
				100,
				100
			},
			offset = {
				100,
				arg_54_1[2] - 53,
				3
			},
			size = {
				arg_54_1[1] - 160,
				30
			}
		},
		title_text = {
			font_size = 20,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_54_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				100,
				arg_54_1[2] - 53,
				3
			},
			size = {
				arg_54_1[1] - 160,
				30
			}
		},
		title_text_shadow = {
			font_size = 20,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_54_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				102,
				arg_54_1[2] - 53 - 2,
				2
			},
			size = {
				arg_54_1[1] - 160,
				30
			}
		},
		text_disabled = {
			font_size = 18,
			word_wrap = true,
			dynamic_font_size_word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			color = {
				150,
				0,
				255,
				0
			},
			font_type = arg_54_2 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				80,
				80,
				80
			},
			offset = {
				90,
				arg_54_1[2] - 150,
				3
			},
			size = {
				arg_54_1[1] - 140,
				95
			}
		},
		text = {
			font_size = 18,
			word_wrap = true,
			dynamic_font_size_word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			color = {
				150,
				0,
				255,
				0
			},
			font_type = arg_54_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				90,
				arg_54_1[2] - 150,
				3
			},
			size = {
				arg_54_1[1] - 140,
				95
			}
		},
		text_shadow = {
			font_size = 18,
			word_wrap = true,
			dynamic_font_size_word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			color = {
				150,
				0,
				255,
				0
			},
			font_type = arg_54_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				92,
				arg_54_1[2] - 150 - 2,
				2
			},
			size = {
				arg_54_1[1] - 140,
				95
			}
		}
	}

	return {
		element = {
			passes = var_54_1
		},
		content = var_54_2,
		style = var_54_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_54_0
	}
end

local function var_0_30(arg_66_0, arg_66_1, arg_66_2)
	local var_66_0 = {
		255,
		255,
		255,
		255
	}
	local var_66_1 = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "frame",
			texture_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "connect_texture",
			texture_id = "connect_texture"
		},
		{
			pass_type = "texture",
			style_id = "icon_equipped_frame",
			texture_id = "icon_equipped_frame",
			content_check_function = function (arg_67_0)
				return arg_67_0.used_amount > 0
			end
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (arg_68_0)
				return not arg_68_0.button_hotspot.disable_button
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_disabled",
			texture_id = "icon",
			content_check_function = function (arg_69_0)
				return arg_69_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "text_disabled",
			pass_type = "text",
			text_id = "text",
			content_check_function = function (arg_70_0)
				return arg_70_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "text",
			pass_type = "text",
			text_id = "text",
			content_check_function = function (arg_71_0)
				return not arg_71_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "text_shadow",
			pass_type = "text",
			text_id = "text"
		},
		{
			style_id = "title_text_disabled",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (arg_72_0)
				return arg_72_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "title_text_disabled",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (arg_73_0)
				return arg_73_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (arg_74_0)
				return not arg_74_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "price_text_disabled",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (arg_75_0)
				return arg_75_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "price_text",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (arg_76_0)
				return not arg_76_0.button_hotspot.disable_button
			end
		},
		{
			style_id = "price_text_shadow",
			pass_type = "text",
			text_id = "price_text"
		},
		{
			pass_type = "texture",
			style_id = "price_icon",
			texture_id = "price_icon",
			content_check_function = function (arg_77_0)
				return not arg_77_0.button_hotspot.disable_button and arg_77_0.used_amount < arg_77_0.total_uses
			end
		},
		{
			pass_type = "texture",
			style_id = "value_glow",
			texture_id = "value_glow"
		},
		{
			pass_type = "texture",
			style_id = "lock_icon",
			texture_id = "lock_icon",
			content_check_function = function (arg_78_0)
				return arg_78_0.button_hotspot.disable_button
			end
		},
		{
			pass_type = "texture",
			style_id = "hover",
			texture_id = "hover"
		}
	}
	local var_66_2 = {
		price_text = "0",
		price_icon = "icon_mastery_small",
		hover = "athanor_entry_talent_bg_hover",
		value_glow = "athanor_entry_talent_glow",
		frame = "athanor_entry_talent_frame",
		used_amount = 0,
		total_uses = 0,
		text = "-",
		connect_texture = "athanor_entry_connector",
		background = "athanor_entry_talent_bg",
		title_text = "n/a",
		lock_icon = "athanor_level_lock",
		icon = "icons_placeholder",
		icon_equipped_frame = "athanor_skilltree_slot_talent_active",
		button_hotspot = {
			allow_multi_hover = true
		},
		size = arg_66_1
	}
	local var_66_3 = {
		debug = {
			masked = arg_66_2,
			color = {
				255,
				255,
				0,
				0
			},
			offset = {
				-1,
				-1,
				8
			},
			size = {
				3,
				3
			}
		},
		icon_equipped_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_66_2,
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				-13,
				0,
				4
			},
			texture_size = {
				128,
				128
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_66_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				11,
				0,
				0
			},
			texture_size = {
				80,
				80
			}
		},
		icon_disabled = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_66_2,
			color = {
				255,
				80,
				80,
				80
			},
			offset = {
				11,
				0,
				0
			},
			texture_size = {
				80,
				80
			}
		},
		value_glow = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = arg_66_2,
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				5,
				3
			},
			texture_size = {
				72,
				162
			}
		},
		connect_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_66_2,
			color = var_66_0,
			offset = {
				-20,
				0,
				0
			},
			texture_size = {
				58,
				18
			}
		},
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_66_2,
			color = var_66_0,
			offset = {
				0,
				0,
				1
			},
			texture_size = arg_66_1
		},
		hover = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_66_2,
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				2
			},
			texture_size = arg_66_1
		},
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_66_2,
			color = var_66_0,
			offset = {
				0,
				0,
				3
			},
			texture_size = arg_66_1
		},
		hover = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_66_2,
			color = var_66_0,
			offset = {
				0,
				0,
				2
			},
			texture_size = arg_66_1
		},
		lock_icon = {
			masked = arg_66_2,
			color = {
				255,
				80,
				80,
				80
			},
			offset = {
				110 + (arg_66_1[1] - 170) / 2 - 17.5,
				12.5,
				6
			},
			default_offset = {
				110 + (arg_66_1[1] - 170) / 2 - 17.5,
				12.5,
				6
			},
			size = {
				35,
				35
			}
		},
		price_icon = {
			masked = arg_66_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				110 + (arg_66_1[1] - 170) / 2 - 17.5,
				12.5,
				6
			},
			default_offset = {
				110 + (arg_66_1[1] - 170) / 2 - 17.5,
				12.5,
				6
			},
			size = {
				35,
				35
			}
		},
		price_text_disabled = {
			font_size = 18,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_66_2 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				80,
				80,
				80
			},
			offset = {
				110,
				20,
				5
			},
			default_offset = {
				110,
				20,
				5
			},
			size = {
				arg_66_1[1] - 170,
				20
			},
			color_override = {},
			color_override_table = {
				start_index = 0,
				end_index = 0,
				color = {
					255,
					121,
					193,
					229
				}
			}
		},
		price_text = {
			font_size = 18,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_66_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				110,
				20,
				5
			},
			default_offset = {
				110,
				20,
				5
			},
			size = {
				arg_66_1[1] - 170,
				20
			},
			color_override = {},
			color_override_table = {
				start_index = 0,
				end_index = 0,
				color = {
					255,
					121,
					193,
					229
				}
			}
		},
		price_text_shadow = {
			font_size = 18,
			horizontal_alignment = "center",
			word_wrap = true,
			vertical_alignment = "center",
			dynamic_font_size = true,
			font_type = arg_66_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				112,
				18,
				4
			},
			default_offset = {
				112,
				18,
				4
			},
			size = {
				arg_66_1[1] - 170,
				20
			}
		},
		title_text_disabled = {
			font_size = 20,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_66_2 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				100,
				100,
				100
			},
			offset = {
				110,
				arg_66_1[2] - 53,
				5
			},
			size = {
				arg_66_1[1] - 170,
				30
			}
		},
		title_text = {
			font_size = 20,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_66_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				110,
				arg_66_1[2] - 53,
				5
			},
			size = {
				arg_66_1[1] - 170,
				30
			}
		},
		title_text_shadow = {
			font_size = 20,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			dynamic_font_size = true,
			color = {
				150,
				255,
				0,
				0
			},
			font_type = arg_66_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				112,
				arg_66_1[2] - 53 - 2,
				4
			},
			size = {
				arg_66_1[1] - 170,
				30
			}
		},
		text_disabled = {
			font_size = 18,
			word_wrap = true,
			dynamic_font_size_word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			color = {
				150,
				0,
				255,
				0
			},
			font_type = arg_66_2 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				80,
				80,
				80
			},
			offset = {
				100,
				arg_66_1[2] - 185,
				5
			},
			size = {
				arg_66_1[1] - 150,
				125
			}
		},
		text = {
			font_size = 17,
			word_wrap = true,
			dynamic_font_size_word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			color = {
				150,
				0,
				255,
				0
			},
			font_type = arg_66_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				100,
				arg_66_1[2] - 185 + 10,
				5
			},
			size = {
				arg_66_1[1] - 150,
				125
			}
		},
		text_shadow = {
			font_size = 17,
			word_wrap = true,
			dynamic_font_size_word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			color = {
				150,
				0,
				255,
				0
			},
			font_type = arg_66_2 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				102,
				arg_66_1[2] - 185 - 2 + 10,
				4
			},
			size = {
				arg_66_1[1] - 150,
				125
			}
		}
	}

	return {
		element = {
			passes = var_66_1
		},
		content = var_66_2,
		style = var_66_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_66_0
	}
end

local function var_0_31(arg_79_0, arg_79_1, arg_79_2)
	arg_79_2 = arg_79_2 or 20

	local var_79_0 = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
			{
				pass_type = "texture",
				style_id = "mask",
				texture_id = "mask_texture"
			},
			{
				pass_type = "texture",
				style_id = "mask_top",
				texture_id = "mask_edge"
			},
			{
				pass_type = "rotated_texture",
				style_id = "mask_bottom",
				texture_id = "mask_edge"
			}
		}
	}
	local var_79_1 = {
		mask_texture = "mask_rect",
		mask_edge = "mask_rect_edge_fade",
		hotspot = {
			allow_multi_hover = true
		}
	}
	local var_79_2 = {
		debug = {
			size = arg_79_1,
			color = {
				100,
				255,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		},
		mask = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				arg_79_1[1],
				arg_79_1[2] - arg_79_2 * 2
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
				0
			}
		},
		mask_top = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			texture_size = {
				arg_79_1[1],
				arg_79_2
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
				0
			}
		},
		mask_bottom = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				arg_79_1[1],
				arg_79_2
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
				0
			},
			angle = math.pi,
			pivot = {
				arg_79_1[1] / 2,
				arg_79_2 / 2
			}
		}
	}

	return {
		element = var_79_0,
		content = var_79_1,
		style = var_79_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_79_0
	}
end

local function var_0_32(arg_80_0, arg_80_1)
	local var_80_0 = {
		passes = {
			{
				pass_type = "texture",
				style_id = "icon",
				texture_id = "icon"
			},
			{
				style_id = "title_text",
				pass_type = "text",
				text_id = "title_text"
			},
			{
				style_id = "sub_title_text",
				pass_type = "text",
				text_id = "sub_title_text"
			},
			{
				style_id = "description_text",
				pass_type = "text",
				text_id = "description_text"
			}
		}
	}
	local var_80_1 = {
		title_text = "title_text",
		icon = "icon_trait",
		description_text = "description_text",
		sub_title_text = "sub_title_text"
	}
	local var_80_2 = {
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				50,
				50
			},
			color = {
				255,
				180,
				180,
				180
			},
			offset = {
				30,
				120,
				1
			}
		},
		title_text = {
			font_size = 32,
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			text_color = {
				255,
				180,
				180,
				180
			},
			size = {
				arg_80_1[1] - 150,
				30
			},
			color = {
				100,
				80,
				80,
				200
			},
			offset = {
				105,
				arg_80_1[2] / 2 + 50,
				1
			}
		},
		sub_title_text = {
			word_wrap = true,
			font_size = 20,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			font_type = "hell_shark",
			text_color = {
				255,
				160,
				160,
				160
			},
			size = {
				arg_80_1[1] - 150,
				30
			},
			color = {
				100,
				80,
				200,
				80
			},
			offset = {
				105,
				arg_80_1[2] / 2 + 10,
				1
			}
		},
		description_text = {
			word_wrap = true,
			font_size = 18,
			horizontal_alignment = "center",
			vertical_alignment = "top",
			font_type = "hell_shark",
			text_color = {
				255,
				120,
				120,
				120
			},
			color = {
				100,
				200,
				80,
				80
			},
			size = {
				arg_80_1[1] - 150,
				arg_80_1[2] / 2 - 60
			},
			offset = {
				105,
				50,
				1
			}
		}
	}

	return {
		element = var_80_0,
		content = var_80_1,
		style = var_80_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_80_0
	}
end

local function var_0_33(arg_81_0)
	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "hotspot"
				}
			}
		},
		content = {
			hotspot = {
				allow_multi_hover = true
			}
		},
		style = {},
		scenegraph_id = arg_81_0
	}
end

local var_0_34 = true
local var_0_35 = {
	top_hdr_background_write_mask = UIWidgets.create_simple_texture("ui_write_mask", "window"),
	upgrade_bg = UIWidgets.create_simple_texture("weave_menu_athanor_upgrade_bg", "upgrade_bg")
}
local var_0_36 = {
	255,
	138,
	0,
	147
}
local var_0_37 = {
	hdr_background_wheel = UIWidgets.create_simple_texture("athanor_skilltree_background_effect", "background_wheel", nil, nil, var_0_36, 5),
	hdr_wheel_ring_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_1", 0, {
		94,
		94
	}, "wheel_ring_1", nil, nil, var_0_36, 1),
	hdr_wheel_ring_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_2", 0, {
		230.5,
		230.5
	}, "wheel_ring_2", nil, nil, var_0_36, 1),
	hdr_wheel_ring_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_effect_3", 0, {
		537,
		537
	}, "wheel_ring_3", nil, nil, var_0_36, 1)
}
local var_0_38 = {
	background_write_mask = UIWidgets.create_simple_texture("athanor_background_write_mask", "window"),
	background_wheel = UIWidgets.create_simple_texture("athanor_skilltree_background", "background_wheel"),
	viewport_background = UIWidgets.create_simple_rect("viewport_background", {
		255,
		0,
		0,
		0
	}),
	viewport_background_fade = UIWidgets.create_simple_rotated_texture("edge_fade_small", math.pi / 2, {
		var_0_13.viewport_background_fade.size[1],
		0
	}, "viewport_background_fade"),
	wheel_ring_1 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_1", 0, {
		94,
		94
	}, "wheel_ring_1"),
	wheel_ring_2 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_2", 0, {
		230.5,
		230.5
	}, "wheel_ring_2"),
	wheel_ring_3 = UIWidgets.create_simple_rotated_texture("athanor_skilltree_ring_3", 0, {
		537,
		537
	}, "wheel_ring_3")
}

var_0_37.hdr_wheel_ring_1.content.snap_pixel_positions = false
var_0_37.hdr_wheel_ring_2.content.snap_pixel_positions = false
var_0_37.hdr_wheel_ring_3.content.snap_pixel_positions = false
var_0_38.wheel_ring_1.content.snap_pixel_positions = false
var_0_38.wheel_ring_2.content.snap_pixel_positions = false
var_0_38.wheel_ring_3.content.snap_pixel_positions = false

local var_0_39 = {
	upgrade_text = UIWidgets.create_simple_text(Localize("menu_weave_item_upgraded_effect_title"), "upgrade_text", nil, nil, var_0_14),
	viewport_panel_divider = UIWidgets.create_simple_texture("athanor_item_divider_middle", "viewport_panel_divider"),
	viewport_panel_divider_left = UIWidgets.create_simple_uv_texture("athanor_item_divider_edge", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "viewport_panel_divider_left"),
	viewport_panel_divider_right = UIWidgets.create_simple_texture("athanor_item_divider_edge", "viewport_panel_divider_right"),
	viewport_level_title = UIWidgets.create_simple_text(Localize("menu_weave_forge_magic_level_title"), "panel_level_title", nil, nil, var_0_21),
	viewport_level_value = UIWidgets.create_simple_text("0", "panel_level_value", nil, nil, var_0_22),
	viewport_power_title = UIWidgets.create_simple_text(Localize("menu_weave_forge_loadout_power_title"), "panel_power_title", nil, nil, var_0_21),
	viewport_power_value = UIWidgets.create_simple_text("0", "panel_power_value", nil, nil, var_0_22),
	viewport_button = UIWidgets.create_simple_hotspot("viewport_button", true),
	viewport_title = UIWidgets.create_simple_text("", "viewport_title", nil, nil, var_0_23),
	viewport_sub_title = UIWidgets.create_simple_text("", "viewport_sub_title", nil, nil, var_0_24),
	upgrade_essence_warning = UIWidgets.create_simple_text(Localize("menu_weave_forge_level_too_low"), "upgrade_essence_warning", nil, nil, var_0_20),
	upgrade_button = UIWidgets.create_athanor_upgrade_button("upgrade_button", var_0_13.upgrade_button.size, "athanor_icon_upgrade", Localize("menu_weave_forge_upgrade_loadout_button"), 24),
	options_background_edge = UIWidgets.create_simple_texture("athanor_categories_background", "options_background_edge"),
	options_list_button = var_0_33("options_scroll_field"),
	options_background = UIWidgets.create_tiled_texture("options_background", "menu_frame_bg_01", {
		960,
		1080
	}, nil, var_0_34, {
		255,
		120,
		120,
		120
	}),
	options_background_mask = UIWidgets.create_simple_uv_texture("athanor_list_mask_write_mask", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "options_background_mask"),
	clear_background = UIWidgets.create_simple_uv_texture("athanor_decoration_headline", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "clear_background"),
	clear_button = UIWidgets.create_default_button("clear_button", var_0_13.clear_button.size, nil, nil, Localize("menu_weave_forge_reset_options_button"), 26, nil, "button_detail_02"),
	mastery_icon = UIWidgets.create_simple_texture("icon_mastery_big", "mastery_icon"),
	mastery_text = UIWidgets.create_simple_text("", "mastery_text", nil, nil, var_0_17),
	mastery_title_text = UIWidgets.create_simple_text(Localize("menu_weave_forge_mastery_title"), "mastery_title_text", nil, nil, var_0_18),
	mastery_tooltip = UIWidgets.create_additional_option_tooltip("mastery_tooltip", var_0_13.mastery_tooltip.size, {
		"additional_option_info"
	}, {
		title = Localize("menu_weave_forge_tooltip_mastery_title"),
		description = Localize("menu_weave_forge_tooltip_mastery_description")
	}, 400, nil, nil, true),
	title_text = UIWidgets.create_simple_text("", "title_text", nil, nil, var_0_15),
	sub_title_text = UIWidgets.create_simple_text("", "sub_title_text", nil, nil, var_0_16),
	title_background = UIWidgets.create_simple_texture("athanor_decoration_headline", "title_background"),
	window_overlay = UIWidgets.create_simple_rect("window_overlay", {
		0,
		10,
		10,
		10
	}),
	locked_slot_description = var_0_32("options_scroll_field", var_0_13.options_scroll_field.size)
}
local var_0_40 = {
	upgrade = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3)
				local var_82_0 = arg_82_2.upgrade_bg
				local var_82_1 = arg_82_2.upgrade_text

				var_82_0.alpha_multiplier = 0
				var_82_1.alpha_multiplier = 0
			end,
			update = function (arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
				local var_83_0 = math.easeOutCubic(arg_83_3)
				local var_83_1 = arg_83_2.upgrade_bg
				local var_83_2 = arg_83_2.upgrade_text

				var_83_1.alpha_multiplier = var_83_0
				var_83_2.alpha_multiplier = var_83_0
			end,
			on_complete = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3)
				return
			end
		},
		{
			name = "fade_out",
			start_progress = 1,
			end_progress = 2,
			init = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
				return
			end,
			update = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
				local var_86_0 = math.easeInCubic(1 - arg_86_3)
				local var_86_1 = arg_86_2.upgrade_bg
				local var_86_2 = arg_86_2.upgrade_text

				var_86_1.alpha_multiplier = var_86_0
				var_86_2.alpha_multiplier = var_86_0
			end,
			on_complete = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3)
				return
			end
		},
		{
			name = "text_offset",
			start_progress = 0,
			end_progress = 2,
			init = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3)
				return
			end,
			update = function (arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4)
				local var_89_0 = math.easeOutCubic(arg_89_3)

				arg_89_2.upgrade_text.offset[2] = -40 + 50 * var_89_0
			end,
			on_complete = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3)
				return
			end
		},
		{
			name = "size_increase",
			start_progress = 0,
			end_progress = 4,
			init = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3)
				local var_91_0 = arg_91_2.upgrade_bg.scenegraph_id
				local var_91_1 = arg_91_1[var_91_0].size
				local var_91_2 = arg_91_0[var_91_0].size

				var_91_2[1] = var_91_1[1]
				var_91_2[2] = var_91_1[2]
			end,
			update = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4)
				local var_92_0 = math.easeOutCubic(arg_92_3)
				local var_92_1 = arg_92_2.upgrade_bg.scenegraph_id
				local var_92_2 = arg_92_1[var_92_1].size
				local var_92_3 = arg_92_0[var_92_1].size

				var_92_3[1] = var_92_2[1] + 200 * (1 - var_92_0)
				var_92_3[2] = var_92_2[2] + 200 * (1 - var_92_0)
			end,
			on_complete = function (arg_93_0, arg_93_1, arg_93_2, arg_93_3)
				return
			end
		}
	},
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_94_0, arg_94_1, arg_94_2, arg_94_3)
				arg_94_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4)
				local var_95_0 = math.easeOutCubic(arg_95_3)

				arg_95_4.render_settings.alpha_multiplier = var_95_0
				arg_95_0.viewport_panel.local_position[2] = arg_95_1.viewport_panel.position[2] + (-50 + 50 * var_95_0)
				arg_95_0.slot_root.local_position[1] = arg_95_1.slot_root.position[1] + (-150 + 150 * var_95_0)
			end,
			on_complete = function (arg_96_0, arg_96_1, arg_96_2, arg_96_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_97_0, arg_97_1, arg_97_2, arg_97_3)
				arg_97_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_98_0, arg_98_1, arg_98_2, arg_98_3, arg_98_4)
				local var_98_0 = math.easeOutCubic(arg_98_3)

				arg_98_4.render_settings.alpha_multiplier = 1 - var_98_0
			end,
			on_complete = function (arg_99_0, arg_99_1, arg_99_2, arg_99_3)
				return
			end
		}
	}
}

return {
	scrollbar_widget = UIWidgets.create_chain_scrollbar("options_list_scrollbar", "options_scroll_field", var_0_13.options_list_scrollbar.size),
	top_widgets = var_0_39,
	bottom_widgets = var_0_38,
	top_hdr_widgets = var_0_35,
	bottom_hdr_widgets = var_0_37,
	options_mask_margin = var_0_11,
	options_mask_offset = var_0_10,
	scenegraph_definition = var_0_13,
	animation_definitions = var_0_40,
	create_trait_slot_definition = var_0_27,
	create_menu_option_trait_definition = var_0_29,
	create_menu_option_talent_definition = var_0_30,
	create_menu_option_property_definition = var_0_28,
	create_talent_slot_definition = var_0_26,
	create_property_slot_definition = var_0_25
}
