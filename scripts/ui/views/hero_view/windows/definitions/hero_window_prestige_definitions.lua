-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_prestige_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local var_0_5 = UIFrameSettings[frame].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[frame].texture_sizes.horizontal[2]
local num = size[1] * 2 + spacing * 2
local num_2 = size[1] - (var_0_5 * 2 + 60)
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
	window_frame = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			size[1] * 2 + spacing,
			size[2]
		},
		position = {
			0,
			0,
			1
		}
	},
	title_text_glow = {
		vertical_alignment = "top",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			544,
			16
		},
		position = {
			0,
			15,
			-1
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "title_text_glow",
		horizontal_alignment = "center",
		size = {
			size[1],
			50
		},
		position = {
			0,
			15,
			1
		}
	},
	reward_window = {
		vertical_alignment = "top",
		parent = "window_frame",
		horizontal_alignment = "right",
		size = {
			450,
			500
		},
		position = {
			-50,
			-100,
			1
		}
	},
	reward_title_text = {
		vertical_alignment = "top",
		parent = "reward_window",
		horizontal_alignment = "center",
		size = {
			450,
			50
		},
		position = {
			0,
			0,
			1
		}
	},
	reward_description_text = {
		vertical_alignment = "top",
		parent = "reward_window",
		horizontal_alignment = "center",
		size = {
			400,
			225
		},
		position = {
			0,
			-50,
			1
		}
	},
	reward_portrait_root = {
		vertical_alignment = "center",
		parent = "reward_window",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			5
		}
	},
	reward_item_text_detail = {
		vertical_alignment = "top",
		parent = "reward_portrait_root",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			-120,
			10
		}
	},
	reward_item_text = {
		vertical_alignment = "center",
		parent = "reward_item_text_detail",
		horizontal_alignment = "center",
		size = {
			400,
			0
		},
		position = {
			0,
			30,
			1
		}
	},
	info_window = {
		vertical_alignment = "top",
		parent = "window_frame",
		horizontal_alignment = "left",
		size = {
			450,
			500
		},
		position = {
			50,
			-100,
			1
		}
	},
	info_title_text = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			450,
			50
		},
		position = {
			0,
			0,
			1
		}
	},
	info_description_text = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			400,
			225
		},
		position = {
			0,
			-50,
			1
		}
	},
	prestige_button = {
		vertical_alignment = "bottom",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			370,
			70
		},
		position = {
			0,
			30,
			1
		}
	},
	impact_title_text = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			0,
			200,
			1
		}
	},
	impact_description_text = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			0,
			150,
			1
		}
	},
	unable_description_text = {
		vertical_alignment = "bottom",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			800,
			50
		},
		position = {
			0,
			130,
			1
		}
	},
	warning_popup_background = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = {
			800,
			700
		},
		position = {
			0,
			0,
			25
		}
	},
	warning_popup_title_text = {
		vertical_alignment = "top",
		parent = "warning_popup_background",
		horizontal_alignment = "center",
		size = {
			800,
			50
		},
		position = {
			0,
			0,
			2
		}
	},
	warning_popup_desc = {
		vertical_alignment = "top",
		parent = "warning_popup_background",
		horizontal_alignment = "center",
		size = {
			750,
			650
		},
		position = {
			0,
			-100,
			2
		}
	},
	warning_popup_accept_button = {
		vertical_alignment = "bottom",
		parent = "warning_popup_background",
		horizontal_alignment = "center",
		size = {
			280,
			70
		},
		position = {
			-200,
			50,
			2
		}
	},
	warning_popup_decline_button = {
		vertical_alignment = "bottom",
		parent = "warning_popup_background",
		horizontal_alignment = "center",
		size = {
			280,
			70
		},
		position = {
			200,
			50,
			2
		}
	},
	debug_level_up_button = {
		vertical_alignment = "top",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			size[1] * 2 + spacing,
			35
		},
		position = {
			0,
			-5,
			2
		}
	}
}
local tbl_2 = {
	vertical_alignment = "bottom",
	upper_case = true,
	localize = false,
	horizontal_alignment = "center",
	font_size = 42,
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
	upper_case = true,
	localize = false,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_4 = {
	vertical_alignment = "top",
	font_size = 18,
	localize = false,
	horizontal_alignment = "center",
	word_wrap = true,
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
	upper_case = true,
	localize = false,
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_6 = {
	word_wrap = true,
	upper_case = true,
	localize = false,
	font_size = 24,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("red", 255),
	offset = {
		0,
		0,
		2
	}
}

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	local var_1_0

	if not arg_1_5 then
		var_1_0 = "button_" .. arg_1_5
	else
		var_1_0 = "button_normal"
	end

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(var_1_0, 255)
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
						-- function 2
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
						-- function 3
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 4
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
						-- function 5
						local is_clicked = self.button_hotspot.is_clicked

						return not is_clicked and is_clicked == 0
					end
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 6
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture",
					content_check_function = function (self)
						-- function 7
						return self.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 8
						return self.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 9
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
		use_bottom_edge = arg_1_4,
		button_hotspot = {},
		button_text = arg_1_2 or "n/a"
	}
	local str_2

	if not arg_1_5 then
		str_2 = "button_state_hover_" .. arg_1_5

		if not str_2 then
			-- Nothing
		end
	end

	str_2 = "button_state_hover"

	::label_1_0::

	tbl_2.hover_glow = str_2

	local str_3

	if not arg_1_5 then
		str_3 = "button_state_normal_" .. arg_1_5

		if not str_3 then
			-- Nothing
		end
	end

	str_3 = "button_state_normal"

	::label_1_1::

	tbl_2.glow = str_3
	tbl_2.button_background = {
		uvs = {
			{
				0,
				1 - math.min(arg_1_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
			},
			{
				math.min(arg_1_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
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
			size = arg_1_1
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
				arg_1_1[2],
				3
			},
			size = {
				arg_1_1[1],
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
				arg_1_1[2] - 4,
				3
			},
			size = {
				arg_1_1[1],
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
				arg_1_1[1],
				arg_1_1[2] - 5
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
				arg_1_1[1],
				arg_1_1[2] - 5
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
		},
		button_text = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_1_3 or 24,
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				0,
				5,
				4
			},
			size = arg_1_1
		},
		button_text_disabled = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_1_3 or 24,
			text_color = Colors.get_color_table_with_alpha("gray", 255),
			offset = {
				0,
				5,
				4
			},
			size = arg_1_1
		},
		button_text_shadow = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = arg_1_3 or 24,
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				3,
				3
			},
			size = arg_1_1
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
				arg_1_1[1] - 10,
				arg_1_1[2]
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
				arg_1_1[1] - 10,
				arg_1_1[2]
			}
		}
	}
	tbl.scenegraph_id = arg_1_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

local function fn_2(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local var_10_0

	if not arg_10_3 then
		var_10_0 = "button_" .. arg_10_3
	else
		var_10_0 = "button_normal"
	end

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(var_10_0, 255)
	local str = "talent_slot_bg"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl = {
		255,
		255,
		255,
		255
	}
	local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("font_title", 255)
	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {}
	local tbl_4 = {
		amount = arg_10_2
	}
	local tbl_5 = {}
	local num = 0
	local num_2 = 0
	local num_3 = -num
	local num_4 = (arg_10_1[1] - num * (arg_10_2 - 1)) / arg_10_2
	local tbl_6 = {
		num_4,
		arg_10_1[2]
	}
	local tbl_7 = {
		80,
		80
	}
	local num_5 = 0

	for i = 1, arg_10_2 do
		local str_2 = "_" .. tostring(i)
		local num_6 = i - 1

		num_3 = num_3 + tbl_6[1] + num

		local tbl_8 = {
			num_5,
			0,
			num_2
		}
		local str_3 = "hotspot" .. str_2

		tbl_3[#tbl_3 + 1] = {
			pass_type = "hotspot",
			content_id = str_3,
			style_id = str_3
		}
		tbl_5[str_3] = {
			size = tbl_6,
			offset = tbl_8
		}
		tbl_4[str_3] = {}

		local var_10_21 = tbl_4[str_3]
		local str_4 = "background" .. str_2

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture_uv",
			content_id = str_4,
			style_id = str_4
		}
		tbl_5[str_4] = {
			size = tbl_6,
			color = tbl,
			offset = {
				tbl_8[1],
				tbl_8[2],
				0
			}
		}
		tbl_4[str_4] = {
			uvs = {
				{
					0,
					1 - math.min(tbl_6[2] / get_atlas_settings_by_texture_name.size[2], 1)
				},
				{
					math.min(tbl_6[1] / get_atlas_settings_by_texture_name.size[1], 1),
					1
				}
			},
			texture_id = str
		}

		local str_5 = "title_text" .. str_2

		tbl_3[#tbl_3 + 1] = {
			pass_type = "text",
			text_id = str_5,
			style_id = str_5
		}
		tbl_5[str_5] = {
			word_wrap = true,
			font_size = 18,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				tbl_6[1] - 100,
				tbl_6[2]
			},
			offset = {
				tbl_8[1] + 100,
				tbl_8[2],
				2
			}
		}
		tbl_4[str_5] = "n/a"

		local str_6 = "title_text_shadow" .. str_2

		tbl_3[#tbl_3 + 1] = {
			pass_type = "text",
			text_id = str_5,
			style_id = str_6
		}
		tbl_5[str_6] = {
			word_wrap = true,
			font_size = 18,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				tbl_6[1] - 100,
				tbl_6[2]
			},
			offset = {
				tbl_8[1] + 100 + 2,
				tbl_8[2] - 2,
				1
			}
		}

		local str_7 = "background_glow" .. str_2

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			texture_id = str_7,
			style_id = str_7,
			content_check_function = function (self)
				-- function 11
				local var_11_0 = self[str_3]
				local is_selected = var_11_0.is_selected

				is_selected = is_selected or var_11_0.is_hover

				return is_selected
			end
		}
		tbl_5[str_7] = {
			size = {
				tbl_6[1],
				tbl_6[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_8[1],
				tbl_8[2] + 5,
				2
			}
		}
		tbl_4[str_7] = "button_state_normal"

		local str_8 = "glass_top" .. str_2

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			texture_id = str_8,
			style_id = str_8
		}
		tbl_5[str_8] = {
			size = {
				tbl_6[1],
				3
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				tbl_8[1],
				tbl_8[2] + tbl_6[2] - 3,
				1
			}
		}
		tbl_4[str_8] = "button_glass_01"

		local str_9 = "icon" .. str_2

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			texture_id = str_9,
			style_id = str_9
		}
		tbl_5[str_9] = {
			size = tbl_7,
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				tbl_8[1] + 10,
				tbl_8[2] + tbl_6[2] / 2 - tbl_7[2] / 2,
				2
			}
		}
		tbl_4[str_9] = "talent_damage_dwarf"

		local str_10 = "icon_frame" .. str_2

		tbl_3[#tbl_3 + 1] = {
			pass_type = "texture",
			texture_id = str_10,
			style_id = str_10
		}
		tbl_5[str_10] = {
			size = tbl_7,
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				tbl_8[1] + 10,
				tbl_8[2] + tbl_6[2] / 2 - tbl_7[2] / 2,
				3
			}
		}
		tbl_4[str_10] = "icon_talent_frame"

		local str_11 = "tooltip" .. str_2

		tbl_3[#tbl_3 + 1] = {
			talent_id = "talent",
			pass_type = "talent_tooltip",
			content_id = str_3,
			style_id = str_11,
			content_check_function = function (self)
				-- function 12
				local talent = self.talent

				talent = not talent and self.is_hover

				return talent
			end
		}
		tbl_5[str_11] = {
			size = tbl_6,
			offset = {
				tbl_8[1],
				tbl_8[2],
				tbl_8[3] + 10
			}
		}
		tbl_4[str_11] = nil
		num_5 = num_5 + num_4 + num
	end

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = arg_10_0

	return tbl_2
end

local function fn_3(arg_13_0, arg_13_1)
	-- function 13
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
					arg_13_1[1] - 10,
					5
				},
				texture_tiling_size = {
					arg_13_1[1] - 10,
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
					arg_13_1[1] - 12,
					-6,
					10
				},
				size = {
					9,
					17
				}
			}
		},
		scenegraph_id = arg_13_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_4(arg_14_0, arg_14_1)
	-- function 14
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
					arg_14_1[2] - 9
				},
				texture_tiling_size = {
					5,
					arg_14_1[2] - 9
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
					arg_14_1[2] - 7,
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
		scenegraph_id = arg_14_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_19 = Localize("hero_view_prestige_information_description")
local var_0_20 = Localize("hero_view_prestige_impact_description")
local var_0_21 = Localize("hero_view_prestige_reward_description")
local var_0_22 = Localize("hero_view_prestige_unable_description")
local var_0_23 = Localize("hero_view_prestige_experience_required")
local str = "586020/600000"
local var_0_25 = Localize("hero_view_prestige_current_prestige_level")
local tbl_7 = {
	warning_popup_accept_button = UIWidgets.create_default_button("warning_popup_accept_button", tbl.warning_popup_accept_button.size, nil, nil, "Accept"),
	warning_popup_decline_button = UIWidgets.create_default_button("warning_popup_decline_button", tbl.warning_popup_decline_button.size, nil, nil, "Decline"),
	warning_popup_background = UIWidgets.create_background_with_frame("warning_popup_background", tbl.warning_popup_background.size),
	warning_popup_title_text = UIWidgets.create_title_widget("warning_popup_title_text", tbl.warning_popup_title_text.size, "WARNING", true),
	warning_popup_desc = UIWidgets.create_simple_text("Increasing your Prestige level will: \n - Reset character level", "warning_popup_desc", nil, nil, tbl_4)
}
local tbl_8 = {
	window_frame = UIWidgets.create_frame("window_frame", tbl.window_frame.size, frame, 10),
	window = UIWidgets.create_background("window_frame", tbl.window_frame.size, "talent_tree_bg_01"),
	prestige_button = UIWidgets.create_default_button("prestige_button", tbl.prestige_button.size, nil, nil, Localize("hero_view_prestige"), 32),
	info_window_frame = UIWidgets.create_frame("info_window", tbl.info_window.size, "menu_frame_06"),
	info_window = UIWidgets.create_simple_rect("info_window", {
		100,
		0,
		0,
		0
	}),
	info_title_text = UIWidgets.create_title_widget("info_title_text", tbl.info_title_text.size, Localize("hero_view_prestige_information"), true, true),
	info_description_text = UIWidgets.create_simple_text(var_0_19, "info_description_text", nil, nil, tbl_4),
	impact_title_text = UIWidgets.create_simple_text(Localize("hero_view_impact"), "impact_title_text", nil, nil, tbl_5),
	impact_description_text = UIWidgets.create_simple_text(var_0_20, "impact_description_text", nil, nil, tbl_4),
	reward_window_frame = UIWidgets.create_frame("reward_window", tbl.reward_window.size, "menu_frame_06"),
	reward_window = UIWidgets.create_simple_rect("reward_window", {
		100,
		0,
		0,
		0
	}),
	reward_title_text = UIWidgets.create_title_widget("reward_title_text", tbl.reward_title_text.size, Localize("hero_view_prestige_reward"), true, true),
	reward_description_text = UIWidgets.create_simple_text(var_0_21, "reward_description_text", nil, nil, tbl_4),
	reward_item_text = UIWidgets.create_simple_text("n/a", "reward_item_text", nil, nil, tbl_3),
	reward_item_text_detail = UIWidgets.create_simple_texture("divider_01_top", "reward_item_text_detail"),
	unable_description_text = UIWidgets.create_simple_text(var_0_22, "unable_description_text", nil, nil, tbl_6),
	debug_level_up_button = fn("debug_level_up_button", tbl.debug_level_up_button.size, "DEBUG: Get Max Experience", 18, true)
}
local tbl_9 = {
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
			end_progress = 0.3,
			init = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				arg_18_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				-- function 19
				local easeOutCubic = math.easeOutCubic(arg_19_3)

				arg_19_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				-- function 20
				return
			end
		}
	}
}

return {
	widgets = tbl_8,
	warning_widgets = tbl_7,
	scenegraph_definition = tbl,
	animation_definitions = tbl_9
}
