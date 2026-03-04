-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_character_selection_console_definitions.lua

local var_0_0 = 426
local var_0_1 = 240
local var_0_2 = {
	450,
	170
}
local var_0_3 = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default + 100
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
	hero_info_panel = {
		vertical_alignment = "top",
		parent = "left_side_root",
		horizontal_alignment = "left",
		size = {
			441,
			118
		},
		position = {
			150,
			-100,
			1
		}
	},
	info_text = {
		vertical_alignment = "top",
		parent = "hero_info_panel",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			0
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
			790
		},
		position = {
			0,
			-126,
			-1
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
	locked_info_text = {
		vertical_alignment = "top",
		parent = "hero_root",
		horizontal_alignment = "left",
		size = {
			441,
			50
		},
		position = {
			0,
			60,
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
			1
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
			1
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
	}
}
local var_0_4 = {
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
local var_0_5 = {
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
local var_0_6 = {
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
local var_0_7 = {
	word_wrap = true,
	font_size = 26,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}

local function var_0_8(arg_1_0, arg_1_1)
	local var_1_0 = UIFrameSettings.menu_frame_12
	local var_1_1 = UIFrameSettings.frame_corner_detail_01_gold
	local var_1_2 = UIFrameSettings.frame_outer_glow_01
	local var_1_3 = var_1_2.texture_sizes.horizontal[2]
	local var_1_4 = UIFrameSettings.frame_outer_glow_01_white
	local var_1_5 = var_1_4.texture_sizes.horizontal[2]
	local var_1_6 = "frame_inner_glow_03"
	local var_1_7 = UIFrameSettings[var_1_6]

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "portrait",
					style_id = "portrait",
					pass_type = "texture"
				},
				{
					pass_type = "rect",
					style_id = "rect"
				},
				{
					texture_id = "lock_texture",
					style_id = "lock_texture",
					pass_type = "texture",
					content_check_function = function(arg_2_0)
						return arg_2_0.locked
					end
				},
				{
					texture_id = "taken_texture",
					style_id = "taken_texture",
					pass_type = "texture",
					content_check_function = function(arg_3_0)
						return arg_3_0.taken and not arg_3_0.locked
					end
				},
				{
					texture_id = "bot_frame",
					style_id = "bot_frame",
					pass_type = "texture_frame",
					content_check_function = function(arg_4_0)
						return arg_4_0.bot_selected
					end
				},
				{
					texture_id = "bot_texture",
					style_id = "bot_texture",
					pass_type = "texture",
					content_check_function = function(arg_5_0)
						return arg_5_0.bot_selected
					end
				},
				{
					style_id = "bot_text",
					pass_type = "text",
					text_id = "bot_priority",
					content_check_function = function(arg_6_0)
						return arg_6_0.bot_priority
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					pass_type = "texture_frame",
					style_id = "frame_premium",
					texture_id = "frame_premium",
					content_check_function = function(arg_7_0)
						return arg_7_0.is_premium
					end
				},
				{
					style_id = "overlay",
					pass_type = "rect",
					content_check_function = function(arg_8_0)
						local var_8_0 = arg_8_0.button_hotspot

						return not var_8_0.is_hover and not var_8_0.is_selected and not arg_8_0.locked
					end
				},
				{
					style_id = "overlay_locked",
					pass_type = "rect",
					content_check_function = function(arg_9_0)
						if arg_9_0.dlc_name then
							local var_9_0 = arg_9_0.button_hotspot

							return not var_9_0.is_hover and not var_9_0.is_selected and arg_9_0.locked
						else
							return arg_9_0.locked
						end
					end
				},
				{
					style_id = "overlay_dlc_selected",
					pass_type = "rect",
					content_check_function = function(arg_10_0)
						local var_10_0 = arg_10_0.button_hotspot

						return arg_10_0.dlc_name and (var_10_0.is_hover or var_10_0.is_selected) and arg_10_0.locked
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "hover_frame",
					texture_id = "hover_frame",
					content_check_function = function(arg_11_0)
						return arg_11_0.button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "currently_selected_frame",
					texture_id = "currently_selected_frame",
					content_check_function = function(arg_12_0)
						return not arg_12_0.button_hotspot.is_selected and arg_12_0.is_currently_selected_character
					end
				}
			}
		},
		content = {
			portrait = "icons_placeholder",
			locked = false,
			lock_texture = "hero_icon_locked",
			taken_texture = "hero_icon_unavailable",
			taken = false,
			is_currently_selected_character = false,
			bot_texture = "bot_selected_icon",
			button_hotspot = {},
			bot_frame = var_1_7.texture,
			frame = var_1_0.texture,
			frame_premium = var_1_1.texture,
			hover_frame = var_1_2.texture,
			currently_selected_frame = var_1_4.texture
		},
		style = {
			rect = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_1_1,
				color = {
					200,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					0
				}
			},
			portrait = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_1_1,
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
				}
			},
			lock_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					76,
					87
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
					5
				}
			},
			taken_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					112,
					112
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
					6
				}
			},
			bot_frame = {
				texture_size = var_1_7.texture_size,
				texture_sizes = var_1_7.texture_sizes,
				color = {
					255,
					244,
					171,
					135
				},
				offset = {
					0,
					0,
					3
				}
			},
			bot_texture = {
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
					10,
					10,
					6
				}
			},
			bot_text = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				localize = false,
				font_size = 24,
				font_type = "hell_shark_header",
				text_color = {
					255,
					200,
					255,
					255
				},
				offset = {
					35,
					0,
					6
				}
			},
			overlay = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_1_1,
				color = {
					80,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					2
				}
			},
			overlay_locked = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_1_1,
				color = {
					200,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					2
				}
			},
			overlay_dlc_selected = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_1_1,
				color = {
					90,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					2
				}
			},
			frame = {
				texture_size = var_1_0.texture_size,
				texture_sizes = var_1_0.texture_sizes,
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
				}
			},
			frame_premium = {
				texture_size = var_1_1.texture_size,
				texture_sizes = var_1_1.texture_sizes,
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
				}
			},
			hover_frame = {
				size = {
					arg_1_1[1] + var_1_3 * 2,
					arg_1_1[2] + var_1_3 * 2
				},
				texture_size = var_1_2.texture_size,
				texture_sizes = var_1_2.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-var_1_3,
					-var_1_3,
					0
				}
			},
			currently_selected_frame = {
				size = {
					arg_1_1[1] + var_1_5 * 2,
					arg_1_1[2] + var_1_5 * 2
				},
				texture_size = var_1_4.texture_size,
				texture_sizes = var_1_4.texture_sizes,
				color = {
					255,
					50,
					205,
					50
				},
				offset = {
					-var_1_5,
					-var_1_5,
					0
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

local function var_0_9(arg_13_0, arg_13_1)
	local var_13_0 = {
		80,
		80
	}

	return {
		element = {
			passes = {
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function(arg_14_0)
						return not arg_14_0.selected
					end
				},
				{
					texture_id = "icon_selected",
					style_id = "icon_selected",
					pass_type = "texture",
					content_check_function = function(arg_15_0)
						return arg_15_0.selected
					end
				},
				{
					texture_id = "holder",
					style_id = "holder",
					pass_type = "texture"
				}
			}
		},
		content = {
			icon = "hero_icon_large_bright_wizard",
			holder = "divider_vertical_hero_decoration",
			icon_selected = "hero_icon_large_bright_wizard"
		},
		style = {
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = var_13_0,
				color = {
					200,
					80,
					80,
					80
				},
				offset = {
					-40,
					0,
					1
				}
			},
			icon_selected = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = var_13_0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-40,
					0,
					1
				}
			},
			holder = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_13_1,
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
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_13_0
	}
end

local var_0_10 = {
	110,
	130
}
local var_0_11 = {
	scenegraph_id = "hero_root",
	offset = {
		0,
		0,
		0
	},
	element = {
		passes = {
			{
				pass_type = "hover"
			},
			{
				pass_type = "texture",
				style_id = "bg",
				texture_id = "bg"
			},
			{
				style_id = "icon",
				texture_id = "icon",
				pass_type = "texture",
				content_change_function = function(arg_16_0, arg_16_1)
					local var_16_0 = arg_16_0.is_hover and 255 or 184

					arg_16_1.color[1] = math.ceil(arg_16_1.color[1] + 0.1 * (var_16_0 - arg_16_1.color[1]))
				end
			}
		}
	},
	content = {
		icon = "icon_hourglass",
		bg = "character_slot_empty"
	},
	style = {
		bg = {
			texture_size = var_0_10,
			offset = {
				0,
				0,
				0
			}
		},
		icon = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = UIAtlasHelper.get_atlas_settings_by_texture_name("icon_hourglass").size,
			color = {
				184,
				255,
				255,
				255
			}
		}
	}
}
local var_0_12 = true
local var_0_13 = {
	background = UIWidgets.create_simple_rect("screen", {
		128,
		0,
		0,
		0
	}, 4),
	select_button = UIWidgets.create_default_button("select_button", var_0_3.select_button.size, nil, nil, Localize("input_description_confirm"), nil, nil, nil, nil, var_0_12),
	info_text = UIWidgets.create_simple_text(Localize("manage_inventory_select"), "locked_info_text", nil, nil, var_0_7),
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
	info_career_name = UIWidgets.create_simple_text("n/a", "info_career_name", nil, nil, var_0_4),
	info_hero_name = UIWidgets.create_simple_text("n/a", "info_hero_name", nil, nil, var_0_5),
	info_hero_level = UIWidgets.create_simple_text("n/a", "info_hero_level", nil, nil, var_0_6),
	bottom_panel = UIWidgets.create_simple_uv_texture("menu_panel_bg", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_panel", nil, nil, UISettings.console_menu_rect_color)
}
local var_0_14 = {
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
			description_text = "input_description_select_inventory"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
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
local var_0_15 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				arg_17_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				local var_18_0 = math.easeOutCubic(arg_18_3)

				arg_18_4.render_settings.alpha_multiplier = var_18_0
				arg_18_0.left_side_root.local_position[1] = arg_18_1.left_side_root.position[1] + -100 * (1 - var_18_0)
			end,
			on_complete = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 1,
			init = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				arg_20_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				local var_21_0 = math.easeOutCubic(arg_21_3)

				arg_21_4.render_settings.alpha_multiplier = 1 - var_21_0
				arg_21_0.left_side_root.local_position[1] = arg_21_1.left_side_root.position[1] + -100 * var_21_0
			end,
			on_complete = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_13,
	hero_widget = var_0_8("hero_root", var_0_3.hero_root.size),
	empty_hero_widget = var_0_11,
	hero_icon_widget = var_0_9("hero_icon_root", var_0_3.hero_icon_root.size),
	generic_input_actions = var_0_14,
	scenegraph_definition = var_0_3,
	animation_definitions = var_0_15
}
