-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_inventory_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local var_0_5 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local num = size[1] - (var_0_5 * 2 + 60)
local tbl = {
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
	root_fit = {
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
	menu_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = size,
		position = {
			0,
			0,
			1
		}
	},
	item_grid = {
		vertical_alignment = "bottom",
		parent = "page_button_divider",
		horizontal_alignment = "center",
		size = {
			size[1],
			size[2] - 130
		},
		position = {
			0,
			-5,
			-10
		}
	},
	item_grid_divider = {
		vertical_alignment = "top",
		parent = "item_grid",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			15,
			7
		}
	},
	item_grid_header_fade = {
		vertical_alignment = "top",
		parent = "item_tabs_divider",
		horizontal_alignment = "center",
		size = {
			size[1],
			60
		},
		position = {
			0,
			0,
			-1
		}
	},
	item_grid_header = {
		vertical_alignment = "center",
		parent = "item_grid_divider",
		horizontal_alignment = "center",
		size = {
			size[1] - 20,
			40
		},
		position = {
			0,
			8,
			1
		}
	},
	item_grid_header_detail = {
		vertical_alignment = "bottom",
		parent = "item_grid_header",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-30,
			0
		}
	},
	item_tabs = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1],
			40
		},
		position = {
			0,
			-5,
			1
		}
	},
	item_tabs_segments = {
		vertical_alignment = "bottom",
		parent = "item_tabs",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			5,
			10
		}
	},
	item_tabs_segments_top = {
		vertical_alignment = "top",
		parent = "item_tabs",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			-7,
			20
		}
	},
	item_tabs_segments_bottom = {
		vertical_alignment = "bottom",
		parent = "item_tabs",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			3,
			20
		}
	},
	item_tabs_divider = {
		vertical_alignment = "bottom",
		parent = "item_tabs",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			0,
			7
		}
	},
	page_button_next = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			size[1] * 0.4,
			42
		},
		position = {
			0,
			0,
			1
		}
	},
	page_button_edge_right = {
		vertical_alignment = "center",
		parent = "page_button_next",
		horizontal_alignment = "left",
		size = {
			0,
			42
		},
		position = {
			0,
			0,
			10
		}
	},
	page_button_previous = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			size[1] * 0.4,
			42
		},
		position = {
			0,
			0,
			1
		}
	},
	page_button_edge_left = {
		vertical_alignment = "center",
		parent = "page_button_previous",
		horizontal_alignment = "right",
		size = {
			0,
			42
		},
		position = {
			0,
			0,
			10
		}
	},
	page_button_divider = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			42,
			14
		}
	},
	page_text_area = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1] * 0.2,
			42
		},
		position = {
			0,
			0,
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
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		-(size[1] * 0.1 + 5),
		4,
		2
	}
}
local tbl_4 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		size[1] * 0.1 + 4,
		4,
		2
	}
}
local tbl_5 = {
	word_wrap = true,
	font_size = 20,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		4,
		2
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	return {
		element = {
			passes = {
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge_holder_right = "menu_frame_09_divider_right",
			edge_holder_left = "menu_frame_09_divider_left",
			bottom_edge = "menu_frame_09_divider"
		},
		style = {
			bottom_edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					5,
					0,
					6
				},
				size = {
					arg_1_1[1] - 10,
					5
				},
				texture_tiling_size = {
					arg_1_1[1] - 10,
					5
				}
			},
			edge_holder_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					3,
					-6,
					10
				},
				size = {
					9,
					17
				}
			},
			edge_holder_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_1_1[1] - 12,
					-6,
					10
				},
				size = {
					9,
					17
				}
			}
		},
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	return {
		element = {
			passes = {
				{
					texture_id = "edge",
					style_id = "edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_top",
					style_id = "edge_holder_top",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_bottom",
					style_id = "edge_holder_bottom",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge = "menu_frame_09_divider_vertical",
			edge_holder_top = "menu_frame_09_divider_top",
			edge_holder_bottom = "menu_frame_09_divider_bottom"
		},
		style = {
			edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					6,
					6
				},
				size = {
					5,
					arg_2_1[2] - 9
				},
				texture_tiling_size = {
					5,
					arg_2_1[2] - 9
				}
			},
			edge_holder_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-6,
					arg_2_1[2] - 7,
					10
				},
				size = {
					17,
					9
				}
			},
			edge_holder_bottom = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-6,
					3,
					10
				},
				size = {
					17,
					9
				}
			}
		},
		scenegraph_id = arg_2_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local var_3_0

	if not arg_3_5 then
		var_3_0 = "button_" .. arg_3_5
	else
		var_3_0 = "button_normal"
	end

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(var_3_0, 255)
	local str = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl = {
		element = {
			passes = {
				{
					style_id = "button_background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "button_background",
					pass_type = "texture_uv",
					content_id = "button_background"
				},
				{
					texture_id = "bottom_edge",
					style_id = "button_edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "glass_top",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 4
						local button_hotspot = self.button_hotspot
						local is_selected

						if not button_hotspot.disable_button then
							is_selected = button_hotspot.is_selected

							if not is_selected then
								is_selected = button_hotspot.is_hover
							end
						else
							is_selected = false
						end

						if false then
							is_selected = true
						end

						return is_selected
					end
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 5
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 6
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_shadow",
					pass_type = "text",
					text_id = "button_text"
				},
				{
					style_id = "button_clicked_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 7
						local is_clicked = self.button_hotspot.is_clicked

						return not is_clicked and is_clicked == 0
					end
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 8
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture",
					content_check_function = function (self)
						-- function 9
						return self.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 10
						return self.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 11
						return self.use_bottom_edge
					end
				}
			}
		}
	}
	local tbl_2 = {
		edge_holder_left = "menu_frame_09_divider_left",
		edge_holder_right = "menu_frame_09_divider_right",
		glass_top = "button_glass_01",
		bottom_edge = "menu_frame_09_divider",
		use_bottom_edge = arg_3_4,
		button_hotspot = {},
		button_text = arg_3_2 or "n/a"
	}
	local str_2

	if not arg_3_5 then
		str_2 = "button_state_hover_" .. arg_3_5

		if not str_2 then
			-- Nothing
		end
	end

	str_2 = "button_state_hover"

	::label_3_0::

	tbl_2.hover_glow = str_2

	local str_3

	if not arg_3_5 then
		str_3 = "button_state_normal_" .. arg_3_5

		if not str_3 then
			-- Nothing
		end
	end

	str_3 = "button_state_normal"

	::label_3_1::

	tbl_2.glow = str_3
	tbl_2.button_background = {
		uvs = {
			{
				0,
				1 - math.min(arg_3_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
			},
			{
				math.min(arg_3_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
				1
			}
		},
		texture_id = str
	}
	tbl.content = tbl_2
	tbl.style = {
		button_background = {
			color = get_color_table_with_alpha,
			offset = {
				0,
				0,
				2
			},
			size = arg_3_1
		},
		button_edge = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				arg_3_1[2],
				3
			},
			size = {
				arg_3_1[1],
				5
			},
			texture_tiling_size = {
				arg_3_1[1],
				5
			}
		},
		glass_top = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				arg_3_1[2] - 4,
				3
			},
			size = {
				arg_3_1[1],
				5
			}
		},
		glow = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				5,
				3
			},
			size = {
				arg_3_1[1],
				arg_3_1[2] - 5
			}
		},
		hover_glow = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				5,
				2
			},
			size = {
				arg_3_1[1],
				arg_3_1[2] - 5
			}
		},
		bottom_edge = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				5,
				0,
				6
			},
			size = {
				arg_3_1[1] - 10,
				5
			},
			texture_tiling_size = {
				arg_3_1[1] - 10,
				5
			}
		},
		edge_holder_left = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				3,
				-6,
				10
			},
			size = {
				9,
				17
			}
		},
		edge_holder_right = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_3_1[1] - 12,
				-6,
				10
			},
			size = {
				9,
				17
			}
		},
		button_text = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_3_3 or 24,
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				0,
				5,
				4
			},
			size = arg_3_1
		},
		button_text_disabled = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_3_3 or 24,
			text_color = Colors.get_color_table_with_alpha("gray", 255),
			offset = {
				0,
				5,
				4
			},
			size = arg_3_1
		},
		button_text_shadow = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_3_3 or 24,
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				3,
				3
			},
			size = arg_3_1
		},
		button_clicked_rect = {
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				5
			},
			size = arg_3_1
		},
		button_disabled_rect = {
			color = {
				150,
				5,
				5,
				5
			},
			offset = {
				0,
				0,
				5
			},
			size = arg_3_1
		}
	}
	tbl.scenegraph_id = arg_3_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

local tbl_6 = {
	{
		wield = true,
		name = "hats",
		item_filter = "slot_type == hat",
		hero_specific_filter = true,
		display_name = Localize("inventory_screen_hats_title"),
		item_types = {
			"hat"
		},
		icon = UISettings.slot_icons.hat
	},
	{
		wield = true,
		name = "skin",
		item_filter = "slot_type == skin",
		hero_specific_filter = true,
		display_name = Localize("inventory_screen_skins_title"),
		item_types = {
			"skin"
		},
		icon = UISettings.slot_icons.skins
	},
	{
		name = "frames",
		item_filter = "slot_type == frame",
		hero_specific_filter = true,
		display_name = Localize("inventory_screen_frames_title"),
		item_types = {
			"frame"
		},
		icon = UISettings.slot_icons.portrait_frame
	},
	{
		name = "poses",
		item_filter = "item_type == weapon_pose",
		hero_specific_filter = true,
		display_name = Localize("inventory_screen_poses_title"),
		item_types = {
			"weapon_pose"
		},
		icon = UISettings.slot_icons.pose
	}
}
local count = #tbl_6
local tbl_7 = {
	item_grid = UIWidgets.create_grid("item_grid", tbl.item_grid.size, 7, 5, 16, 10, false),
	item_tabs_divider = fn("item_tabs_divider", tbl.item_tabs_divider.size),
	item_grid_header = UIWidgets.create_simple_text(Localize("hero_view_inventory"), "item_grid_header", nil, nil, tbl_2),
	item_grid_header_fade = UIWidgets.create_simple_uv_texture("edge_fade_small", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "item_grid_header_fade"),
	item_grid_header_detail = UIWidgets.create_simple_texture("divider_01_top", "item_grid_header_detail"),
	window_frame = UIWidgets.create_frame("window", tbl.window.size, frame, 10),
	window = UIWidgets.create_background("window", tbl.window.size, "background_leather_02"),
	window_background_fade = UIWidgets.create_simple_texture("options_window_fade_01", "window", nil, nil, nil, 1),
	item_tabs = UIWidgets.create_default_icon_tabs("item_tabs", tbl.item_tabs.size, count),
	item_tabs_segments = UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_vertical", {
		5,
		35
	}, "item_tabs_segments", count - 1),
	item_tabs_segments_top = UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_top", {
		17,
		9
	}, "item_tabs_segments_top", count - 1),
	item_tabs_segments_bottom = UIWidgets.create_simple_centered_texture_amount("menu_frame_09_divider_bottom", {
		17,
		9
	}, "item_tabs_segments_bottom", count - 1),
	page_button_next = UIWidgets.create_simple_window_button("page_button_next", tbl.page_button_next.size, Localize("menu_next"), 16),
	page_button_previous = UIWidgets.create_simple_window_button("page_button_previous", tbl.page_button_previous.size, Localize("menu_previous"), 16),
	page_button_divider = fn("page_button_divider", tbl.page_button_divider.size),
	page_button_edge_left = fn_2("page_button_edge_left", tbl.page_button_edge_left.size),
	page_button_edge_right = fn_2("page_button_edge_right", tbl.page_button_edge_right.size),
	page_text_center = UIWidgets.create_simple_text("/", "page_text_area", nil, nil, tbl_5),
	page_text_left = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_3),
	page_text_right = UIWidgets.create_simple_text("0", "page_text_area", nil, nil, tbl_4),
	page_text_area = UIWidgets.create_simple_rect("page_text_area", {
		255,
		0,
		0,
		0
	})
}
local tbl_8 = {
	default = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "l1_r1",
			priority = 2,
			description_text = "input_description_change_tab",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 3,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 4,
			description_text = "input_description_close"
		}
	}
}
local tbl_9 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				-- function 12
				arg_12_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
				-- function 13
				local easeOutCubic = math.easeOutCubic(arg_13_3)

				arg_13_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				-- function 15
				arg_15_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				-- function 16
				local easeOutCubic = math.easeOutCubic(arg_16_3)

				arg_16_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				return
			end
		}
	}
}

return {
	widgets = tbl_7,
	category_settings = tbl_6,
	scenegraph_definition = tbl,
	animation_definitions = tbl_9,
	generic_input_actions = tbl_8
}
