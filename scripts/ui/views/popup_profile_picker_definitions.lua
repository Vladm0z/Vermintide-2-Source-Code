-- chunkname: @scripts/ui/views/popup_profile_picker_definitions.lua

local tbl = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.matchmaking
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			900,
			670
		},
		position = {
			0,
			10,
			1
		}
	},
	inner_window = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			606,
			250
		},
		position = {
			0,
			60,
			3
		}
	},
	title = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			658,
			60
		},
		position = {
			0,
			34,
			22
		}
	},
	title_bg = {
		vertical_alignment = "top",
		parent = "title",
		horizontal_alignment = "center",
		size = {
			410,
			40
		},
		position = {
			0,
			-15,
			-1
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "title",
		horizontal_alignment = "center",
		size = {
			350,
			50
		},
		position = {
			0,
			-3,
			2
		}
	},
	window_sub_title = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			500,
			50
		},
		position = {
			0,
			-75,
			3
		}
	},
	hero_info_panel = {
		vertical_alignment = "bottom",
		parent = "inner_window",
		horizontal_alignment = "left",
		size = {
			441,
			118
		},
		position = {
			205,
			-130,
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
	info_career_name = {
		vertical_alignment = "top",
		parent = "hero_info_panel",
		horizontal_alignment = "left",
		size = {
			480,
			25
		},
		position = {
			76,
			-40,
			1
		}
	},
	info_hero_name = {
		vertical_alignment = "top",
		parent = "info_career_name",
		horizontal_alignment = "left",
		size = {
			480,
			25
		},
		position = {
			0,
			-16,
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
		vertical_alignment = "top",
		parent = "inner_window",
		horizontal_alignment = "left",
		size = {
			110,
			130
		},
		position = {
			0,
			-100,
			1
		}
	},
	hero_icon_root = {
		vertical_alignment = "top",
		parent = "hero_root",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			100,
			1
		}
	},
	timer_title_text = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			500,
			20
		},
		position = {
			-30,
			-20,
			1
		}
	},
	timer_text = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			500,
			20
		},
		position = {
			-30,
			-50,
			1
		}
	},
	select_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			300,
			70
		},
		position = {
			-170,
			40,
			3
		}
	},
	cancel_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			300,
			70
		},
		position = {
			170,
			40,
			3
		}
	},
	center_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			300,
			70
		},
		position = {
			0,
			40,
			3
		}
	}
}
local tbl_2 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 28,
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
local tbl_3 = {
	font_size = 24,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		1
	}
}
local tbl_4 = {
	font_size = 40,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_5 = {
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
local tbl_6 = {
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
local tbl_7 = {
	font_size = 46,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		1
	}
}
local tbl_8 = {
	font_size = 28,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		1
	}
}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 2
						return self.is_gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (self)
						-- function 3
						return self.is_gamepad_active
					end
				}
			}
		},
		content = {
			input_action = arg_1_0,
			text = arg_1_1 or ""
		},
		style = {
			text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 28,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					1
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					34,
					34
				},
				offset = {
					0,
					0,
					1
				}
			}
		},
		scenegraph_id = arg_1_2
	}
end

local function fn_2(arg_4_0, arg_4_1)
	-- function 4
	arg_4_1 = arg_4_1 or {
		108,
		108
	}

	return {
		scenegraph_id = arg_4_0,
		offset = {
			0,
			0,
			0
		},
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "taken_texture",
					texture_id = "taken_texture",
					content_check_function = function (self)
						-- function 5
						return self.taken
					end
				},
				{
					pass_type = "texture",
					style_id = "glow",
					texture_id = "glow",
					content_check_function = function (self)
						-- function 6
						return self.button_hotspot.is_selected
					end
				},
				{
					style_id = "icon",
					texture_id = "icon",
					pass_type = "texture",
					content_change_function = function (self, arg_7_1)
						-- function 7
						local is_hover = self.button_hotspot.is_hover
						local color = arg_7_1.color
						local flag

						flag = not is_hover and 255 and 230
						color[1] = flag
					end
				}
			}
		},
		content = {
			taken = false,
			glow = "hero_icon_glow",
			icon = "hero_icon_es",
			taken_texture = "hero_icon_unavailable",
			button_hotspot = {
				is_selected = false
			}
		},
		style = {
			taken_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					3
				},
				texture_size = {
					100,
					100
				}
			},
			glow = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					1
				},
				texture_size = {
					1.9074074074074074 * arg_4_1[1],
					1.9074074074074074 * arg_4_1[1]
				}
			},
			icon = {
				offset = {
					0,
					0,
					2
				},
				color = {
					230,
					255,
					255,
					255
				}
			}
		}
	}
end

local var_0_10 = (function (arg_8_0, arg_8_1)
	-- function 8
	local str = "menu_frame_12"
	local var_8_1 = UIFrameSettings[str]
	local str_2 = "frame_outer_glow_01"
	local var_8_3 = UIFrameSettings[str_2]
	local var_8_4 = var_8_3.texture_sizes.horizontal[2]

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_hotspot",
					content_check_function = function (self)
						-- function 9
						return self.parent.exists
					end
				},
				{
					texture_id = "portrait",
					style_id = "portrait",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 10
						return self.exists
					end
				},
				{
					style_id = "rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 11
						return self.exists
					end
				},
				{
					texture_id = "lock_texture",
					style_id = "lock_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 12
						local locked = self.locked

						locked = not locked and self.exists

						return locked
					end
				},
				{
					texture_id = "taken_texture",
					style_id = "taken_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 13
						local taken = self.taken

						taken = not taken and not not self.locked or self.exists

						return taken
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame",
					content_check_function = function (self)
						-- function 14
						return self.exists
					end
				},
				{
					style_id = "overlay",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 15
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.is_hover or not not button_hotspot.is_selected or not not self.locked or self.exists
					end
				},
				{
					style_id = "overlay_locked",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 16
						local locked = self.locked

						locked = not locked and self.exists

						return locked
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "hover_frame",
					texture_id = "hover_frame",
					content_check_function = function (self)
						-- function 17
						local is_selected = self.button_hotspot.is_selected

						is_selected = not is_selected and self.exists

						return is_selected
					end
				},
				{
					pass_type = "hover",
					content_id = "hover_hotspot",
					content_check_function = function (self)
						-- function 18
						return not self.parent.exists
					end
				},
				{
					pass_type = "texture",
					style_id = "empty_slot",
					texture_id = "empty_slot",
					content_check_function = function (self)
						-- function 19
						return not self.exists
					end
				},
				{
					style_id = "hourglass",
					texture_id = "hourglass",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 20
						return not self.exists
					end,
					content_change_function = function (self, arg_21_1)
						-- function 21
						local flag

						flag = not self.is_hover and 255 and 184
						arg_21_1.color[1] = math.ceil(arg_21_1.color[1] + 0.1 * (flag - arg_21_1.color[1]))
					end
				}
			}
		},
		content = {
			portrait = "icons_placeholder",
			locked = false,
			lock_texture = "hero_icon_locked",
			empty_slot = "character_slot_empty",
			taken_texture = "hero_icon_unavailable",
			hourglass = "icon_hourglass",
			taken = false,
			exists = false,
			button_hotspot = {},
			frame = var_8_1.texture,
			hover_frame = var_8_3.texture,
			hover_hotspot = {}
		},
		style = {
			rect = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_8_1,
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
				texture_size = arg_8_1,
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
			overlay = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_8_1,
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
				texture_size = arg_8_1,
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
			frame = {
				texture_size = var_8_1.texture_size,
				texture_sizes = var_8_1.texture_sizes,
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
					arg_8_1[1] + var_8_4 * 2,
					arg_8_1[2] + var_8_4 * 2
				},
				texture_size = var_8_3.texture_size,
				texture_sizes = var_8_3.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-var_8_4,
					-var_8_4,
					0
				}
			},
			empty_slot = {
				texture_size = arg_8_1,
				offset = {
					0,
					0,
					0
				}
			},
			hourglass = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					76,
					87
				},
				color = {
					184,
					255,
					255,
					255
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_8_0
	}
end)("hero_root", tbl.hero_root.size)
local var_0_11 = fn_2("hero_icon_root", tbl.hero_icon_root.size)
local flag = true
local tbl_9 = {
	window = UIWidgets.create_background_with_frame("window", tbl.window.size, "menu_frame_bg_02", "menu_frame_11"),
	window_shadow = UIWidgets.create_simple_texture("options_window_fade_01", "window", nil, nil, nil, 1),
	title = UIWidgets.create_simple_texture("frame_title_bg", "title"),
	title_bg = UIWidgets.create_background("title_bg", tbl.title_bg.size, "menu_frame_bg_02"),
	title_text = UIWidgets.create_simple_text(Localize("join_popup_title"), "title_text", nil, nil, tbl_2),
	window_sub_title = UIWidgets.create_simple_text(Localize("join_popup_sub_title"), "window_sub_title", nil, nil, tbl_3),
	select_button = UIWidgets.create_default_button("select_button", tbl.select_button.size, nil, nil, Localize("input_description_confirm"), nil, nil, nil, nil, flag),
	cancel_button = UIWidgets.create_default_button("cancel_button", tbl.cancel_button.size, nil, nil, Localize("input_description_cancel"), nil, nil, nil, nil, flag),
	hero_info_panel = UIWidgets.create_simple_texture("item_slot_side_fade", "hero_info_panel", nil, nil, {
		255,
		0,
		0,
		0
	}),
	hero_info_panel_glow = UIWidgets.create_simple_texture("item_slot_side_effect", "hero_info_panel", nil, nil, Colors.get_color_table_with_alpha("font_title", 255), 1),
	hero_info_level_bg = UIWidgets.create_simple_texture("hero_level_bg", "hero_info_level_bg"),
	info_career_name = UIWidgets.create_simple_text("n/a", "info_career_name", nil, nil, tbl_4),
	info_hero_name = UIWidgets.create_simple_text("n/a", "info_hero_name", nil, nil, tbl_5),
	info_hero_level = UIWidgets.create_simple_text("n/a", "info_hero_level", nil, nil, tbl_6),
	timer_text = UIWidgets.create_simple_text("00:00", "timer_text", nil, nil, tbl_7),
	timer_title_text = UIWidgets.create_simple_text(Localize("join_popup_timer_title"), "timer_title_text", nil, nil, tbl_8)
}
local tbl_10 = {
	default = {
		{
			input_action = "l1_r1",
			priority = 1,
			description_text = "menu_select_profile",
			ignore_keybinding = true
		},
		{
			input_action = "left_stick",
			priority = 2,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 4,
			description_text = "input_description_close"
		}
	},
	confirm_available = {
		actions = {
			{
				input_action = "confirm",
				priority = 3,
				description_text = "menu_accept"
			}
		}
	}
}

return {
	scenegraph_definition = tbl,
	widget_definitions = tbl_9,
	hero_widget_definition = var_0_10,
	hero_icon_widget_definition = var_0_11,
	generic_input_actions = tbl_10
}
