-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_prestige_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = var_0_0.spacing
local var_0_5 = UIFrameSettings[var_0_2].texture_sizes.vertical[1]
local var_0_6 = UIFrameSettings[var_0_2].texture_sizes.horizontal[2]
local var_0_7 = var_0_3[1] * 2 + var_0_4 * 2
local var_0_8 = var_0_3[1] - (var_0_5 * 2 + 60)
local var_0_9 = {
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
		size = var_0_3,
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
			var_0_3[1] * 2 + var_0_4,
			var_0_3[2]
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
			var_0_3[1],
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
			var_0_3[1] * 2 + var_0_4,
			35
		},
		position = {
			0,
			-5,
			2
		}
	}
}
local var_0_10 = {
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
local var_0_11 = {
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
local var_0_12 = {
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
local var_0_13 = {
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
local var_0_14 = {
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

local function var_0_15(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0

	if arg_1_5 then
		var_1_0 = "button_" .. arg_1_5
	else
		var_1_0 = "button_normal"
	end

	local var_1_1 = Colors.get_color_table_with_alpha(var_1_0, 255)
	local var_1_2 = "button_bg_01"
	local var_1_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_1_2)

	return {
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
					content_check_function = function (arg_2_0)
						local var_2_0 = arg_2_0.button_hotspot

						return not var_2_0.disable_button and (var_2_0.is_selected or var_2_0.is_hover)
					end
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (arg_3_0)
						return not arg_3_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (arg_4_0)
						return arg_4_0.button_hotspot.disable_button
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
					content_check_function = function (arg_5_0)
						local var_5_0 = arg_5_0.button_hotspot.is_clicked

						return not var_5_0 or var_5_0 == 0
					end
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (arg_6_0)
						return arg_6_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture",
					content_check_function = function (arg_7_0)
						return arg_7_0.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture",
					content_check_function = function (arg_8_0)
						return arg_8_0.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture",
					content_check_function = function (arg_9_0)
						return arg_9_0.use_bottom_edge
					end
				}
			}
		},
		content = {
			edge_holder_left = "menu_frame_09_divider_left",
			edge_holder_right = "menu_frame_09_divider_right",
			glass_top = "button_glass_01",
			bottom_edge = "menu_frame_09_divider",
			use_bottom_edge = arg_1_4,
			button_hotspot = {},
			button_text = arg_1_2 or "n/a",
			hover_glow = arg_1_5 and "button_state_hover_" .. arg_1_5 or "button_state_hover",
			glow = arg_1_5 and "button_state_normal_" .. arg_1_5 or "button_state_normal",
			button_background = {
				uvs = {
					{
						0,
						1 - math.min(arg_1_1[2] / var_1_3.size[2], 1)
					},
					{
						math.min(arg_1_1[1] / var_1_3.size[1], 1),
						1
					}
				},
				texture_id = var_1_2
			}
		},
		style = {
			button_background = {
				color = var_1_1,
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
		},
		scenegraph_id = arg_1_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_16(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0

	if arg_10_3 then
		var_10_0 = "button_" .. arg_10_3
	else
		var_10_0 = "button_normal"
	end

	local var_10_1 = Colors.get_color_table_with_alpha(var_10_0, 255)
	local var_10_2 = "talent_slot_bg"
	local var_10_3 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_10_2)
	local var_10_4 = {
		255,
		255,
		255,
		255
	}
	local var_10_5 = Colors.get_color_table_with_alpha("font_title", 255)
	local var_10_6 = {
		element = {}
	}
	local var_10_7 = {}
	local var_10_8 = {
		amount = arg_10_2
	}
	local var_10_9 = {}
	local var_10_10 = 0
	local var_10_11 = 0
	local var_10_12 = -var_10_10
	local var_10_13 = (arg_10_1[1] - var_10_10 * (arg_10_2 - 1)) / arg_10_2
	local var_10_14 = {
		var_10_13,
		arg_10_1[2]
	}
	local var_10_15 = {
		80,
		80
	}
	local var_10_16 = 0

	for iter_10_0 = 1, arg_10_2 do
		local var_10_17 = "_" .. tostring(iter_10_0)
		local var_10_18 = iter_10_0 - 1

		var_10_12 = var_10_12 + var_10_14[1] + var_10_10

		local var_10_19 = {
			var_10_16,
			0,
			var_10_11
		}
		local var_10_20 = "hotspot" .. var_10_17

		var_10_7[#var_10_7 + 1] = {
			pass_type = "hotspot",
			content_id = var_10_20,
			style_id = var_10_20
		}
		var_10_9[var_10_20] = {
			size = var_10_14,
			offset = var_10_19
		}
		var_10_8[var_10_20] = {}

		local var_10_21 = var_10_8[var_10_20]
		local var_10_22 = "background" .. var_10_17

		var_10_7[#var_10_7 + 1] = {
			pass_type = "texture_uv",
			content_id = var_10_22,
			style_id = var_10_22
		}
		var_10_9[var_10_22] = {
			size = var_10_14,
			color = var_10_4,
			offset = {
				var_10_19[1],
				var_10_19[2],
				0
			}
		}
		var_10_8[var_10_22] = {
			uvs = {
				{
					0,
					1 - math.min(var_10_14[2] / var_10_3.size[2], 1)
				},
				{
					math.min(var_10_14[1] / var_10_3.size[1], 1),
					1
				}
			},
			texture_id = var_10_2
		}

		local var_10_23 = "title_text" .. var_10_17

		var_10_7[#var_10_7 + 1] = {
			pass_type = "text",
			text_id = var_10_23,
			style_id = var_10_23
		}
		var_10_9[var_10_23] = {
			word_wrap = true,
			font_size = 18,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			size = {
				var_10_14[1] - 100,
				var_10_14[2]
			},
			offset = {
				var_10_19[1] + 100,
				var_10_19[2],
				2
			}
		}
		var_10_8[var_10_23] = "n/a"

		local var_10_24 = "title_text_shadow" .. var_10_17

		var_10_7[#var_10_7 + 1] = {
			pass_type = "text",
			text_id = var_10_23,
			style_id = var_10_24
		}
		var_10_9[var_10_24] = {
			word_wrap = true,
			font_size = 18,
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				var_10_14[1] - 100,
				var_10_14[2]
			},
			offset = {
				var_10_19[1] + 100 + 2,
				var_10_19[2] - 2,
				1
			}
		}

		local var_10_25 = "background_glow" .. var_10_17

		var_10_7[#var_10_7 + 1] = {
			pass_type = "texture",
			texture_id = var_10_25,
			style_id = var_10_25,
			content_check_function = function (arg_11_0)
				local var_11_0 = arg_11_0[var_10_20]

				return var_11_0.is_selected or var_11_0.is_hover
			end
		}
		var_10_9[var_10_25] = {
			size = {
				var_10_14[1],
				var_10_14[2]
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_10_19[1],
				var_10_19[2] + 5,
				2
			}
		}
		var_10_8[var_10_25] = "button_state_normal"

		local var_10_26 = "glass_top" .. var_10_17

		var_10_7[#var_10_7 + 1] = {
			pass_type = "texture",
			texture_id = var_10_26,
			style_id = var_10_26
		}
		var_10_9[var_10_26] = {
			size = {
				var_10_14[1],
				3
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				var_10_19[1],
				var_10_19[2] + var_10_14[2] - 3,
				1
			}
		}
		var_10_8[var_10_26] = "button_glass_01"

		local var_10_27 = "icon" .. var_10_17

		var_10_7[#var_10_7 + 1] = {
			pass_type = "texture",
			texture_id = var_10_27,
			style_id = var_10_27
		}
		var_10_9[var_10_27] = {
			size = var_10_15,
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				var_10_19[1] + 10,
				var_10_19[2] + var_10_14[2] / 2 - var_10_15[2] / 2,
				2
			}
		}
		var_10_8[var_10_27] = "talent_damage_dwarf"

		local var_10_28 = "icon_frame" .. var_10_17

		var_10_7[#var_10_7 + 1] = {
			pass_type = "texture",
			texture_id = var_10_28,
			style_id = var_10_28
		}
		var_10_9[var_10_28] = {
			size = var_10_15,
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				var_10_19[1] + 10,
				var_10_19[2] + var_10_14[2] / 2 - var_10_15[2] / 2,
				3
			}
		}
		var_10_8[var_10_28] = "icon_talent_frame"

		local var_10_29 = "tooltip" .. var_10_17

		var_10_7[#var_10_7 + 1] = {
			talent_id = "talent",
			pass_type = "talent_tooltip",
			content_id = var_10_20,
			style_id = var_10_29,
			content_check_function = function (arg_12_0)
				return arg_12_0.talent and arg_12_0.is_hover
			end
		}
		var_10_9[var_10_29] = {
			size = var_10_14,
			offset = {
				var_10_19[1],
				var_10_19[2],
				var_10_19[3] + 10
			}
		}
		var_10_8[var_10_29] = nil
		var_10_16 = var_10_16 + var_10_13 + var_10_10
	end

	var_10_6.element.passes = var_10_7
	var_10_6.content = var_10_8
	var_10_6.style = var_10_9
	var_10_6.offset = {
		0,
		0,
		0
	}
	var_10_6.scenegraph_id = arg_10_0

	return var_10_6
end

local function var_0_17(arg_13_0, arg_13_1)
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

local function var_0_18(arg_14_0, arg_14_1)
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
local var_0_24 = "586020/600000"
local var_0_25 = Localize("hero_view_prestige_current_prestige_level")
local var_0_26 = {
	warning_popup_accept_button = UIWidgets.create_default_button("warning_popup_accept_button", var_0_9.warning_popup_accept_button.size, nil, nil, "Accept"),
	warning_popup_decline_button = UIWidgets.create_default_button("warning_popup_decline_button", var_0_9.warning_popup_decline_button.size, nil, nil, "Decline"),
	warning_popup_background = UIWidgets.create_background_with_frame("warning_popup_background", var_0_9.warning_popup_background.size),
	warning_popup_title_text = UIWidgets.create_title_widget("warning_popup_title_text", var_0_9.warning_popup_title_text.size, "WARNING", true),
	warning_popup_desc = UIWidgets.create_simple_text("Increasing your Prestige level will: \n - Reset character level", "warning_popup_desc", nil, nil, var_0_12)
}
local var_0_27 = {
	window_frame = UIWidgets.create_frame("window_frame", var_0_9.window_frame.size, var_0_2, 10),
	window = UIWidgets.create_background("window_frame", var_0_9.window_frame.size, "talent_tree_bg_01"),
	prestige_button = UIWidgets.create_default_button("prestige_button", var_0_9.prestige_button.size, nil, nil, Localize("hero_view_prestige"), 32),
	info_window_frame = UIWidgets.create_frame("info_window", var_0_9.info_window.size, "menu_frame_06"),
	info_window = UIWidgets.create_simple_rect("info_window", {
		100,
		0,
		0,
		0
	}),
	info_title_text = UIWidgets.create_title_widget("info_title_text", var_0_9.info_title_text.size, Localize("hero_view_prestige_information"), true, true),
	info_description_text = UIWidgets.create_simple_text(var_0_19, "info_description_text", nil, nil, var_0_12),
	impact_title_text = UIWidgets.create_simple_text(Localize("hero_view_impact"), "impact_title_text", nil, nil, var_0_13),
	impact_description_text = UIWidgets.create_simple_text(var_0_20, "impact_description_text", nil, nil, var_0_12),
	reward_window_frame = UIWidgets.create_frame("reward_window", var_0_9.reward_window.size, "menu_frame_06"),
	reward_window = UIWidgets.create_simple_rect("reward_window", {
		100,
		0,
		0,
		0
	}),
	reward_title_text = UIWidgets.create_title_widget("reward_title_text", var_0_9.reward_title_text.size, Localize("hero_view_prestige_reward"), true, true),
	reward_description_text = UIWidgets.create_simple_text(var_0_21, "reward_description_text", nil, nil, var_0_12),
	reward_item_text = UIWidgets.create_simple_text("n/a", "reward_item_text", nil, nil, var_0_11),
	reward_item_text_detail = UIWidgets.create_simple_texture("divider_01_top", "reward_item_text_detail"),
	unable_description_text = UIWidgets.create_simple_text(var_0_22, "unable_description_text", nil, nil, var_0_14),
	debug_level_up_button = var_0_15("debug_level_up_button", var_0_9.debug_level_up_button.size, "DEBUG: Get Max Experience", 18, true)
}
local var_0_28 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
				arg_15_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
				local var_16_0 = math.easeOutCubic(arg_16_3)

				arg_16_4.render_settings.alpha_multiplier = var_16_0
			end,
			on_complete = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
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
				arg_18_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				local var_19_0 = math.easeOutCubic(arg_19_3)

				arg_19_4.render_settings.alpha_multiplier = 1 - var_19_0
			end,
			on_complete = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end
		}
	}
}

return {
	widgets = var_0_27,
	warning_widgets = var_0_26,
	scenegraph_definition = var_0_9,
	animation_definitions = var_0_28
}
