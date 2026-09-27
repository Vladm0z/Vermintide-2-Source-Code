-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_character_selection_console_definitions.lua

local num = 426
local num_2 = 240
local tbl = {
	450,
	170
}
local tbl_2 = {
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
local tbl_3 = {
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
local tbl_4 = {
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
local tbl_5 = {
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
local tbl_6 = {
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

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local menu_frame_12 = UIFrameSettings.menu_frame_12
	local frame_corner_detail_01_gold = UIFrameSettings.frame_corner_detail_01_gold
	local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
	local var_1_3 = frame_outer_glow_01.texture_sizes.horizontal[2]
	local frame_outer_glow_01_white = UIFrameSettings.frame_outer_glow_01_white
	local var_1_5 = frame_outer_glow_01_white.texture_sizes.horizontal[2]
	local str = "frame_inner_glow_03"
	local var_1_7 = UIFrameSettings[str]

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
					content_check_function = function (self)
						-- function 2
						return self.locked
					end
				},
				{
					texture_id = "taken_texture",
					style_id = "taken_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 3
						local taken = self.taken

						taken = not taken and not self.locked

						return taken
					end
				},
				{
					texture_id = "bot_frame",
					style_id = "bot_frame",
					pass_type = "texture_frame",
					content_check_function = function (self)
						-- function 4
						return self.bot_selected
					end
				},
				{
					texture_id = "bot_texture",
					style_id = "bot_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 5
						return self.bot_selected
					end
				},
				{
					style_id = "bot_text",
					pass_type = "text",
					text_id = "bot_priority",
					content_check_function = function (self)
						-- function 6
						return self.bot_priority
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
					content_check_function = function (self)
						-- function 7
						return self.is_premium
					end
				},
				{
					style_id = "overlay",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 8
						local button_hotspot = self.button_hotspot

						return not not button_hotspot.is_hover or not not button_hotspot.is_selected or not self.locked
					end
				},
				{
					style_id = "overlay_locked",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 9
						if not self.dlc_name then
							local button_hotspot = self.button_hotspot

							return not not button_hotspot.is_hover or not not button_hotspot.is_selected or self.locked
						else
							return self.locked
						end
					end
				},
				{
					style_id = "overlay_dlc_selected",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 10
						local button_hotspot = self.button_hotspot
						local dlc_name = self.dlc_name

						if not dlc_name then
							if not button_hotspot.is_hover then
								dlc_name = button_hotspot.is_selected

								if not dlc_name then
									-- Nothing
								end
							end

							dlc_name = self.locked
						end

						::label_10_0::

						return dlc_name
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "hover_frame",
					texture_id = "hover_frame",
					content_check_function = function (self)
						-- function 11
						return self.button_hotspot.is_selected
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "currently_selected_frame",
					texture_id = "currently_selected_frame",
					content_check_function = function (self)
						-- function 12
						return not not self.button_hotspot.is_selected or self.is_currently_selected_character
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
			frame = menu_frame_12.texture,
			frame_premium = frame_corner_detail_01_gold.texture,
			hover_frame = frame_outer_glow_01.texture,
			currently_selected_frame = frame_outer_glow_01_white.texture
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
				texture_size = menu_frame_12.texture_size,
				texture_sizes = menu_frame_12.texture_sizes,
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
				texture_size = frame_corner_detail_01_gold.texture_size,
				texture_sizes = frame_corner_detail_01_gold.texture_sizes,
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
				texture_size = frame_outer_glow_01.texture_size,
				texture_sizes = frame_outer_glow_01.texture_sizes,
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
				texture_size = frame_outer_glow_01_white.texture_size,
				texture_sizes = frame_outer_glow_01_white.texture_sizes,
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

local function fn_2(arg_13_0, arg_13_1)
	-- function 13
	local tbl = {
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
					content_check_function = function (self)
						-- function 14
						return not self.selected
					end
				},
				{
					texture_id = "icon_selected",
					style_id = "icon_selected",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 15
						return self.selected
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
				texture_size = tbl,
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
				texture_size = tbl,
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

local tbl_7 = {
	110,
	130
}
local tbl_8 = {
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
				content_change_function = function (self, arg_16_1)
					-- function 16
					local flag

					flag = not self.is_hover and 255 and 184
					arg_16_1.color[1] = math.ceil(arg_16_1.color[1] + 0.1 * (flag - arg_16_1.color[1]))
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
			texture_size = tbl_7,
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
local flag = true
local tbl_9 = {
	background = UIWidgets.create_simple_rect("screen", {
		128,
		0,
		0,
		0
	}, 4),
	select_button = UIWidgets.create_default_button("select_button", tbl_2.select_button.size, nil, nil, Localize("input_description_confirm"), nil, nil, nil, nil, flag),
	info_text = UIWidgets.create_simple_text(Localize("manage_inventory_select"), "locked_info_text", nil, nil, tbl_6),
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
	info_career_name = UIWidgets.create_simple_text("n/a", "info_career_name", nil, nil, tbl_3),
	info_hero_name = UIWidgets.create_simple_text("n/a", "info_hero_name", nil, nil, tbl_4),
	info_hero_level = UIWidgets.create_simple_text("n/a", "info_hero_level", nil, nil, tbl_5),
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
local tbl_10 = {
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
local tbl_11 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				-- function 17
				arg_17_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
				-- function 18
				local easeOutCubic = math.easeOutCubic(arg_18_3)

				arg_18_4.render_settings.alpha_multiplier = easeOutCubic
				arg_18_0.left_side_root.local_position[1] = arg_18_1.left_side_root.position[1] + -100 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				arg_20_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
				-- function 21
				local easeOutCubic = math.easeOutCubic(arg_21_3)

				arg_21_4.render_settings.alpha_multiplier = 1 - easeOutCubic
				arg_21_0.left_side_root.local_position[1] = arg_21_1.left_side_root.position[1] + -100 * easeOutCubic
			end,
			on_complete = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				return
			end
		}
	}
}

return {
	widgets = tbl_9,
	hero_widget = fn("hero_root", tbl_2.hero_root.size),
	empty_hero_widget = tbl_8,
	hero_icon_widget = fn_2("hero_icon_root", tbl_2.hero_icon_root.size),
	generic_input_actions = tbl_10,
	scenegraph_definition = tbl_2,
	animation_definitions = tbl_11
}
