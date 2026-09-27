-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_cosmetics_loadout_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local var_0_5 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local num = size[1] - (var_0_5 * 2 + 60)
local num_2 = 50
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
	loadout_background = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			size[1],
			120
		},
		position = {
			0,
			0,
			1
		}
	},
	loadout_divider = {
		vertical_alignment = "top",
		parent = "loadout_background",
		horizontal_alignment = "center",
		size = {
			size[1],
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	loadout_grid = {
		vertical_alignment = "center",
		parent = "loadout_background",
		horizontal_alignment = "center",
		size = {
			size[1],
			80
		},
		position = {
			0,
			0,
			1
		}
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
					1,
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

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local var_2_0

	if not arg_2_5 then
		var_2_0 = "button_" .. arg_2_5
	else
		var_2_0 = "button_normal"
	end

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(var_2_0, 255)
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
						-- function 3
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
						-- function 4
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 5
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
						-- function 6
						local is_clicked = self.button_hotspot.is_clicked

						return not is_clicked and is_clicked == 0
					end
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 7
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture",
					content_check_function = function (self)
						-- function 8
						return self.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 9
						return self.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 10
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
		use_bottom_edge = arg_2_4,
		button_hotspot = {},
		button_text = arg_2_2 or "n/a"
	}
	local str_2

	if not arg_2_5 then
		str_2 = "button_state_hover_" .. arg_2_5

		if not str_2 then
			-- Nothing
		end
	end

	str_2 = "button_state_hover"

	::label_2_0::

	tbl_2.hover_glow = str_2

	local str_3

	if not arg_2_5 then
		str_3 = "button_state_normal_" .. arg_2_5

		if not str_3 then
			-- Nothing
		end
	end

	str_3 = "button_state_normal"

	::label_2_1::

	tbl_2.glow = str_3
	tbl_2.button_background = {
		uvs = {
			{
				0,
				1 - math.min(arg_2_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
			},
			{
				math.min(arg_2_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
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
			size = arg_2_1
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
				arg_2_1[2],
				3
			},
			size = {
				arg_2_1[1],
				5
			},
			texture_tiling_size = {
				1,
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
				arg_2_1[2] - 4,
				3
			},
			size = {
				arg_2_1[1],
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
				arg_2_1[1],
				arg_2_1[2] - 5
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
				arg_2_1[1],
				arg_2_1[2] - 5
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
				arg_2_1[1] - 10,
				5
			},
			texture_tiling_size = {
				1,
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
				arg_2_1[1] - 12,
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
			font_size = arg_2_3 or 24,
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				0,
				5,
				4
			},
			size = arg_2_1
		},
		button_text_disabled = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_2_3 or 24,
			text_color = Colors.get_color_table_with_alpha("gray", 255),
			offset = {
				0,
				5,
				4
			},
			size = arg_2_1
		},
		button_text_shadow = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_2_3 or 24,
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				3,
				3
			},
			size = arg_2_1
		},
		button_clicked_rect = {
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				5,
				0,
				5
			},
			size = {
				arg_2_1[1] - 10,
				arg_2_1[2]
			}
		},
		button_disabled_rect = {
			color = {
				150,
				5,
				5,
				5
			},
			offset = {
				5,
				0,
				5
			},
			size = {
				arg_2_1[1] - 10,
				arg_2_1[2]
			}
		}
	}
	tbl.scenegraph_id = arg_2_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

local tbl_2 = {
	loadout_background = UIWidgets.create_background("loadout_background", tbl.loadout_background.size, "crafting_bg_top"),
	loadout_grid = UIWidgets.create_loadout_grid("loadout_grid", tbl.loadout_grid.size, 4, num_2, true),
	loadout_divider = fn("loadout_divider", tbl.loadout_divider.size)
}
local tbl_3 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
				-- function 11
				arg_11_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
				-- function 12
				local easeOutCubic = math.easeOutCubic(arg_12_3)

				arg_12_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
				-- function 13
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				-- function 14
				arg_14_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
				-- function 15
				local easeOutCubic = math.easeOutCubic(arg_15_3)

				arg_15_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				-- function 16
				return
			end
		}
	}
}

return {
	widgets = tbl_2,
	node_widgets = node_widgets,
	scenegraph_definition = tbl,
	animation_definitions = tbl_3
}
