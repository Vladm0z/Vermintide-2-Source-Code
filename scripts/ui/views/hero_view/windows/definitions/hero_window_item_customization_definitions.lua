-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_item_customization_definitions.lua

local var_0_0 = {
	500,
	800
}
local var_0_1 = {
	var_0_0[1],
	100
}
local var_0_2 = UISettings.console_menu_scenegraphs
local var_0_3 = {
	item_preview = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default + 1
		}
	},
	screen = var_0_2.screen,
	area = var_0_2.area,
	window = {
		vertical_alignment = "top",
		parent = "area",
		horizontal_alignment = "left",
		size = var_0_0,
		position = {
			25,
			0,
			1
		}
	},
	info_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = var_0_0,
		position = {
			-75,
			-120,
			1
		}
	},
	option_1 = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			var_0_0[1],
			150
		},
		position = {
			0,
			0,
			1
		}
	},
	option_2 = {
		vertical_alignment = "bottom",
		parent = "option_1",
		horizontal_alignment = "left",
		size = {
			var_0_0[1],
			140
		},
		position = {
			0,
			-140,
			0
		}
	},
	option_3 = {
		vertical_alignment = "bottom",
		parent = "option_2",
		horizontal_alignment = "left",
		size = {
			var_0_0[1],
			140
		},
		position = {
			0,
			0,
			0
		}
	},
	option_4 = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			var_0_0[1],
			110
		},
		position = {
			0,
			0,
			1
		}
	},
	sword_left = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			161,
			47
		},
		position = {
			-81,
			-21,
			15
		}
	},
	sword_right = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			161,
			47
		},
		position = {
			81,
			-21,
			15
		}
	},
	rarity_display = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			37,
			50
		},
		position = {
			-74,
			-23,
			16
		}
	},
	info_title = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "left",
		size = {
			var_0_0[1],
			40
		},
		position = {
			0,
			-10,
			3
		}
	},
	item_feature = {
		vertical_alignment = "bottom",
		parent = "info_title",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] / 3,
			100
		},
		position = {
			0,
			-110,
			2
		}
	},
	weapon_stats_diagram = {
		vertical_alignment = "bottom",
		parent = "item_feature",
		horizontal_alignment = "left",
		size = {
			var_0_0[1],
			360
		},
		position = {
			0,
			-370,
			1
		}
	},
	keyword_divider_top = {
		vertical_alignment = "bottom",
		parent = "weapon_stats_diagram",
		horizontal_alignment = "center",
		size = {
			264,
			21
		},
		position = {
			0,
			-20,
			2
		}
	},
	info_keyword_text = {
		vertical_alignment = "top",
		parent = "keyword_divider_top",
		horizontal_alignment = "center",
		size = {
			var_0_0[1] - 20,
			300
		},
		position = {
			0,
			-20,
			2
		}
	},
	keyword_divider_bottom = {
		vertical_alignment = "bottom",
		parent = "info_keyword_text",
		horizontal_alignment = "center",
		size = {
			264,
			21
		},
		position = {
			0,
			-10,
			2
		}
	},
	info_description_text = {
		vertical_alignment = "bottom",
		parent = "keyword_divider_bottom",
		horizontal_alignment = "center",
		size = {
			var_0_0[1] - 20,
			300
		},
		position = {
			0,
			0,
			2
		}
	},
	info_description_text_2 = {
		vertical_alignment = "bottom",
		parent = "info_title",
		horizontal_alignment = "center",
		size = {
			var_0_0[1] - 20,
			300
		},
		position = {
			0,
			0,
			1
		}
	},
	description_2_divider = {
		vertical_alignment = "bottom",
		parent = "info_description_text_2",
		horizontal_alignment = "center",
		size = {
			264,
			21
		},
		position = {
			0,
			-30,
			2
		}
	},
	upgrade_icons = {
		vertical_alignment = "bottom",
		parent = "info_description_text_2",
		horizontal_alignment = "center",
		size = {
			650,
			217
		},
		position = {
			0,
			-267,
			1
		}
	},
	upgrade_title = {
		vertical_alignment = "bottom",
		parent = "upgrade_icons",
		horizontal_alignment = "center",
		size = {
			100,
			40
		},
		position = {
			0,
			-50,
			1
		}
	},
	upgrade_rarity_name = {
		vertical_alignment = "bottom",
		parent = "upgrade_title",
		horizontal_alignment = "center",
		size = {
			100,
			40
		},
		position = {
			0,
			-40,
			1
		}
	},
	upgrade_description_text = {
		vertical_alignment = "top",
		parent = "upgrade_rarity_name",
		horizontal_alignment = "center",
		size = {
			var_0_0[1] - 20,
			300
		},
		position = {
			0,
			-110,
			1
		}
	},
	property_options_title = {
		vertical_alignment = "bottom",
		parent = "info_description_text_2",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] - 20,
			20
		},
		position = {
			0,
			-80,
			1
		}
	},
	property_options = {
		vertical_alignment = "bottom",
		parent = "scroll_root",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			10,
			0,
			1
		}
	},
	scroll_root = {
		vertical_alignment = "top",
		parent = "property_options_title",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			0
		}
	},
	scroll_area = {
		vertical_alignment = "top",
		parent = "property_options_title",
		horizontal_alignment = "left",
		size = {
			var_0_0[1],
			300
		},
		position = {
			-10,
			-20,
			0
		}
	},
	scrollbar = {
		vertical_alignment = "top",
		parent = "scroll_area",
		horizontal_alignment = "right",
		size = {
			6,
			610
		},
		position = {
			-16,
			0,
			1
		}
	},
	trait_options = {
		vertical_alignment = "bottom",
		parent = "scroll_root",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			25,
			0,
			1
		}
	},
	craft_button_anchor = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			400,
			72
		},
		position = {
			0,
			100,
			5
		}
	},
	craft_button = {
		vertical_alignment = "bottom",
		parent = "craft_button_anchor",
		horizontal_alignment = "center",
		size = {
			400,
			72
		},
		position = {
			0,
			0,
			0
		}
	},
	button_top_edge = {
		vertical_alignment = "top",
		parent = "craft_button",
		horizontal_alignment = "center",
		size = {
			55,
			28
		},
		position = {
			0,
			24,
			-1
		}
	},
	button_top_edge_glow = {
		vertical_alignment = "top",
		parent = "craft_button",
		horizontal_alignment = "center",
		size = {
			55,
			28
		},
		position = {
			0,
			24,
			-2
		}
	},
	experience_bar = {
		vertical_alignment = "bottom",
		parent = "craft_button",
		horizontal_alignment = "left",
		size = {
			400,
			72
		},
		position = {
			0,
			0,
			3
		}
	},
	experience_bar_edge = {
		vertical_alignment = "center",
		parent = "experience_bar",
		horizontal_alignment = "right",
		size = {
			8,
			72
		},
		position = {
			8,
			0,
			3
		}
	},
	material_root = {
		vertical_alignment = "top",
		parent = "craft_button",
		horizontal_alignment = "center",
		size = {
			60,
			100
		},
		position = {
			0,
			100,
			1
		}
	},
	illusions_divider = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			700,
			21
		},
		position = {
			0,
			236,
			2
		}
	},
	illusions_title = {
		vertical_alignment = "bottom",
		parent = "illusions_divider",
		horizontal_alignment = "center",
		size = {
			650,
			40
		},
		position = {
			0,
			0,
			2
		}
	},
	illusions_name = {
		vertical_alignment = "bottom",
		parent = "illusions_divider",
		horizontal_alignment = "center",
		size = {
			650,
			40
		},
		position = {
			0,
			-90,
			2
		}
	},
	illusions_root = {
		vertical_alignment = "bottom",
		parent = "illusions_divider",
		horizontal_alignment = "center",
		size = {
			51,
			45
		},
		position = {
			0,
			-50,
			2
		}
	},
	loading_icon = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			150,
			150
		},
		position = {
			0,
			200,
			10
		}
	}
}
local var_0_4 = {
	font_size = 42,
	upper_case = true,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_5 = {
	font_size = 28,
	upper_case = false,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_6 = {
	font_size = 28,
	upper_case = true,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_7 = {
	font_size = 28,
	upper_case = false,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_8 = {
	font_size = 32,
	upper_case = false,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_9 = {
	font_size = 28,
	upper_case = false,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_10 = {
	word_wrap = true,
	font_size = 20,
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

local function var_0_11()
	return {
		scenegraph_id = "illusions_root",
		element = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					pass_type = "texture",
					style_id = "icon_texture",
					texture_id = "icon_texture"
				},
				{
					pass_type = "texture",
					style_id = "hover_texture",
					texture_id = "hover_texture",
					content_check_function = function(arg_2_0)
						local var_2_0 = arg_2_0.button_hotspot

						return (var_2_0.is_hover or var_2_0.is_selected) and not arg_2_0.equipped
					end
				},
				{
					pass_type = "texture",
					style_id = "equipped_texture",
					texture_id = "equipped_texture",
					content_check_function = function(arg_3_0)
						return arg_3_0.equipped
					end
				}
			}
		},
		content = {
			hover_texture = "button_illusion_glow_white",
			locked = false,
			lock_texture = "hero_icon_locked",
			icon_texture = "icons_placeholder",
			equipped_texture = "button_illusion_glow",
			frame_texture = "item_frame",
			selection_texture = "button_illusion_glow",
			background_texture = "icons_placeholder",
			button_hotspot = {}
		},
		style = {
			hotspot = {
				size = {
					41,
					45
				},
				offset = {
					0,
					0,
					0
				}
			},
			background_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					80,
					80
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
			icon_texture = {
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
			frame_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					80,
					80
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
					2
				}
			},
			equipped_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					63,
					57
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
			lock_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					53.199999999999996,
					60.9
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
					4
				}
			},
			hover_texture = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					63,
					57
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
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_12(arg_4_0, arg_4_1)
	local var_4_0 = true

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text"
				}
			}
		},
		content = {
			texture_id = "icon_list_dot",
			text = arg_4_1
		},
		style = {
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				masked = var_4_0,
				texture_size = {
					13,
					13
				},
				color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
				offset = {
					0,
					0,
					1
				}
			},
			text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					450,
					50
				},
				font_type = var_4_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255),
				color_override = {},
				color_override_table = {
					start_index = 0,
					end_index = 0,
					color = Colors.get_color_table_with_alpha("font_default", 255)
				},
				offset = {
					15,
					-23,
					3
				}
			},
			text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				size = {
					450,
					50
				},
				font_type = var_4_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					16,
					-24,
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_4_0
	}
end

local function var_0_13(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = true

	return {
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "texture_id",
					texture_id = "texture_id"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					style_id = "description_text",
					pass_type = "text",
					text_id = "description_text"
				},
				{
					style_id = "description_text_shadow",
					pass_type = "text",
					text_id = "description_text"
				}
			}
		},
		content = {
			title_text = arg_5_1,
			description_text = arg_5_2,
			texture_id = arg_5_3
		},
		style = {
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				masked = var_5_0,
				texture_size = {
					40,
					40
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
					1
				}
			},
			title_text = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					400,
					50
				},
				font_type = var_5_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					30,
					-5,
					3
				}
			},
			title_text_shadow = {
				word_wrap = true,
				upper_case = true,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				dynamic_font_size = true,
				size = {
					400,
					50
				},
				font_type = var_5_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					31,
					-6,
					2
				}
			},
			description_text = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					400,
					50
				},
				font_type = var_5_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					30,
					-47,
					3
				}
			},
			description_text_shadow = {
				word_wrap = true,
				upper_case = false,
				localize = false,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = false,
				size = {
					400,
					50
				},
				font_type = var_5_0 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					31,
					-48,
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_5_0
	}
end

local function var_0_14(arg_6_0, arg_6_1)
	local var_6_0 = 10
	local var_6_1 = {
		passes = {
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
	local var_6_2 = {
		mask_edge = "mask_rect_edge_fade",
		mask_texture = "mask_rect"
	}
	local var_6_3 = {
		mask = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				arg_6_1[1],
				arg_6_1[2] - var_6_0 * 2
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
				arg_6_1[1],
				var_6_0
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
				arg_6_1[1],
				var_6_0
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
				arg_6_1[1] / 2,
				var_6_0 / 2
			}
		}
	}

	return {
		element = var_6_1,
		content = var_6_2,
		style = var_6_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_6_0
	}
end

local function var_0_15(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = {}

	for iter_7_0 = 1, #arg_7_0 do
		var_7_0[iter_7_0] = {
			255,
			255,
			255,
			255
		}
	end

	return {
		element = {
			passes = {
				{
					pass_type = "centered_texture_amount",
					style_id = "texture_id",
					texture_id = "texture_id"
				}
			}
		},
		content = {
			texture_id = arg_7_0
		},
		style = {
			texture_id = {
				texture_axis = 1,
				spacing = arg_7_3 or 8,
				texture_size = arg_7_1,
				texture_amount = #arg_7_0,
				color = {
					255,
					255,
					255,
					255
				},
				texture_colors = var_7_0,
				offset = {
					0,
					0,
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_7_2
	}
end

local function var_0_16(arg_8_0, arg_8_1)
	local var_8_0 = var_0_3[arg_8_0].size
	local var_8_1 = 10
	local var_8_2 = {
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text"
		},
		{
			style_id = "title_text_shadow",
			pass_type = "text",
			text_id = "title_text"
		}
	}
	local var_8_3 = {
		default_title_text = arg_8_1,
		title_text = arg_8_1,
		size = var_8_0,
		text_spacing = var_8_1
	}
	local var_8_4 = {
		title_text = {
			vertical_alignment = "center",
			upper_case = true,
			horizontal_alignment = "left",
			font_size = 34,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				var_8_1,
				-3,
				2
			},
			size = {
				var_8_0[1] - var_8_1,
				var_8_0[2]
			}
		},
		title_text_shadow = {
			vertical_alignment = "center",
			upper_case = true,
			horizontal_alignment = "left",
			font_size = 34,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				var_8_1 + 2,
				-5,
				1
			},
			size = {
				var_8_0[1] - var_8_1,
				var_8_0[2]
			}
		}
	}

	return {
		element = {
			passes = var_8_2
		},
		content = var_8_3,
		style = var_8_4,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_8_0
	}
end

local var_0_17 = {
	mission_setting_preview = UIWidgets.create_game_option_mission_preview("info_window", var_0_3.info_window.size)
}
local var_0_18 = {}
local var_0_19 = {}

for iter_0_0 = 1, 5 do
	var_0_18[iter_0_0] = "item_tier_empty"
	var_0_19[iter_0_0] = {
		37,
		50
	}
end

local var_0_20 = {
	window = UIWidgets.create_game_option_window("window", var_0_3.window.size, {
		128,
		0,
		0,
		0
	}),
	info_window = UIWidgets.create_game_option_window("info_window", var_0_3.info_window.size, {
		128,
		0,
		0,
		0
	}),
	info_title_background = UIWidgets.create_simple_texture("headline_bg_40", "info_title", nil, nil, {
		120,
		10,
		10,
		10
	}),
	item_setting = UIWidgets.create_item_option_overview("option_1", var_0_3.option_1.size),
	item_properties = UIWidgets.create_item_option_properties("option_2", var_0_3.option_2.size),
	item_trait = UIWidgets.create_item_option_trait("option_3", var_0_3.option_3.size),
	item_upgrade = UIWidgets.create_item_option_upgrade("option_4", var_0_3.option_4.size),
	scroll_area = var_0_14("scroll_area", var_0_3.scroll_area.size),
	scrollbar = UIWidgets.create_scrollbar("scrollbar", var_0_3.scrollbar.size, "scroll_area"),
	rarity_display = UIWidgets.create_simple_multi_texture(var_0_18, var_0_19, 1, 1, {
		0,
		0
	}, "rarity_display"),
	sword_left = UIWidgets.create_simple_texture("frame_detail_sword", "sword_left"),
	sword_right = UIWidgets.create_simple_uv_texture("frame_detail_sword", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "sword_right"),
	loading_icon = {
		scenegraph_id = "loading_icon",
		element = {
			passes = {
				{
					style_id = "texture_id",
					pass_type = "rotated_texture",
					texture_id = "texture_id",
					content_check_function = function(arg_9_0, arg_9_1)
						return arg_9_0.active
					end,
					content_change_function = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
						local var_10_0 = ((arg_10_1.progress or 0) + arg_10_3) % 1

						arg_10_1.angle = math.pow(2, math.smoothstep(var_10_0, 0, 1)) * (math.pi * 2)
						arg_10_1.progress = var_10_0
					end
				}
			}
		},
		content = {
			texture_id = "loot_loading",
			active = false
		},
		style = {
			texture_id = {
				angle = 0,
				pivot = {
					75,
					75
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
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
}

function create_button(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10)
	arg_11_3 = arg_11_3 or "button_bg_01"

	local var_11_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_11_3)
	local var_11_1 = arg_11_2 and UIFrameSettings[arg_11_2] or UIFrameSettings.button_frame_01
	local var_11_2 = var_11_1.texture_sizes.corner[1]
	local var_11_3 = arg_11_7 or "button_detail_01"
	local var_11_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_11_3).size
	local var_11_5
	local var_11_6

	if arg_11_8 then
		if type(arg_11_8) == "table" then
			var_11_5 = arg_11_8[1]
			var_11_6 = arg_11_8[2]
		else
			var_11_5 = arg_11_8
		end
	end

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame",
					content_check_function = function(arg_12_0)
						return arg_12_0.draw_frame
					end
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					texture_id = "background_fade",
					style_id = "background_fade",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture"
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function(arg_13_0)
						return arg_13_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function(arg_14_0)
						return not arg_14_0.skip_side_detail
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function(arg_15_0)
						return not arg_15_0.skip_side_detail
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_16_0)
						return not arg_16_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_17_0)
						return arg_17_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
				},
				{
					texture_id = "glass",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glass",
					style_id = "glass_bottom",
					pass_type = "texture"
				}
			}
		},
		content = {
			draw_frame = true,
			hover_glow = "button_state_default",
			glass = "button_glass_02",
			background_fade = "button_bg_fade",
			side_detail = {
				uvs = {
					{
						1,
						0
					},
					{
						0,
						1
					}
				},
				texture_id = var_11_3,
				skip_side_detail = arg_11_10
			},
			button_hotspot = {},
			title_text = arg_11_4 or "n/a",
			frame = var_11_1.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_11_1[2] / var_11_0.size[2]
					},
					{
						arg_11_1[1] / var_11_0.size[1],
						1
					}
				},
				texture_id = arg_11_3
			},
			disable_with_gamepad = arg_11_9
		},
		style = {
			background = {
				color = {
					255,
					150,
					150,
					150
				},
				offset = {
					0,
					0,
					0
				}
			},
			background_fade = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					var_11_2,
					var_11_2 - 2,
					2
				},
				size = {
					arg_11_1[1] - var_11_2 * 2,
					arg_11_1[2] - var_11_2 * 2
				}
			},
			hover_glow = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					var_11_2 - 2,
					3
				},
				size = {
					arg_11_1[1],
					math.min(arg_11_1[2] - 5, 80)
				}
			},
			clicked_rect = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				}
			},
			disabled_rect = {
				color = {
					150,
					20,
					20,
					20
				},
				offset = {
					0,
					0,
					1
				}
			},
			title_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_11_5 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_11_1[1] - 40,
					arg_11_1[2]
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_11_5 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				size = {
					arg_11_1[1] - 40,
					arg_11_1[2]
				},
				offset = {
					20,
					0,
					6
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				font_size = arg_11_5 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					arg_11_1[1] - 40,
					arg_11_1[2]
				},
				offset = {
					22,
					-2,
					5
				}
			},
			frame = {
				texture_size = var_11_1.texture_size,
				texture_sizes = var_11_1.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					8
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
					arg_11_1[2] - (var_11_2 + 11),
					4
				},
				size = {
					arg_11_1[1],
					11
				}
			},
			glass_bottom = {
				color = {
					100,
					255,
					255,
					255
				},
				offset = {
					0,
					var_11_2 - 9,
					4
				},
				size = {
					arg_11_1[1],
					11
				}
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_11_5 and -var_11_5 or -9,
					arg_11_1[2] / 2 - var_11_4[2] / 2 + (var_11_6 or 0),
					9
				},
				size = {
					var_11_4[1],
					var_11_4[2]
				}
			},
			side_detail_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_11_1[1] - var_11_4[1] + (var_11_5 or 9),
					arg_11_1[2] / 2 - var_11_4[2] / 2 + (var_11_6 or 0),
					9
				},
				size = {
					var_11_4[1],
					var_11_4[2]
				}
			}
		},
		scenegraph_id = arg_11_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_21 = false
local var_0_22 = {
	craft_button = create_button("craft_button", var_0_3.craft_button.size, nil, nil, "n/a", 32, nil, nil, nil, var_0_21),
	button_top_edge_left = UIWidgets.create_simple_uv_texture("frame_detail_04", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "button_top_edge", nil, nil, nil, nil, var_0_21),
	button_top_edge_right = UIWidgets.create_simple_uv_texture("frame_detail_04", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "button_top_edge", nil, nil, nil, nil, var_0_21),
	button_top_edge_glow = UIWidgets.create_simple_uv_texture("hero_panel_selection_glow", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "button_top_edge_glow", nil, nil, nil, nil, var_0_21),
	experience_bar_edge = UIWidgets.create_simple_texture("experience_bar_edge_glow", "experience_bar_edge"),
	experience_bar = UIWidgets.create_simple_uv_texture("experience_bar_fill", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "experience_bar")
}
local var_0_23 = {
	info_title = var_0_16("info_title", Localize("input_description_information")),
	keyword_divider_top = UIWidgets.create_simple_texture("divider_01_bottom", "keyword_divider_top"),
	keyword_divider_bottom = UIWidgets.create_simple_texture("divider_01_bottom", "keyword_divider_bottom")
}
local var_0_24 = {
	illusions_divider = UIWidgets.create_simple_texture("divider_01_bottom", "illusions_divider"),
	illusions_title = UIWidgets.create_simple_text(Localize("inventory_screen_weapon_skins_title"), "illusions_title", nil, nil, var_0_6),
	illusions_counter = UIWidgets.create_simple_text(Localize("inventory_screen_weapon_skins_title"), "illusions_title", nil, nil, var_0_7),
	illusions_name = UIWidgets.create_simple_text("", "illusions_name", nil, nil, var_0_8)
}
local var_0_25 = {
	info_title = var_0_16("info_title", Localize("hero_view_crafting_properties")),
	description_2_divider = UIWidgets.create_simple_texture("divider_01_bottom", "description_2_divider"),
	property_options_title = UIWidgets.create_simple_text(Localize("available_properties"), "property_options_title", nil, nil, var_0_9)
}
local var_0_26 = {
	info_title = var_0_16("info_title", Localize("crafting_recipe_weapon_reroll_traits")),
	description_2_divider = UIWidgets.create_simple_texture("divider_01_bottom", "description_2_divider"),
	property_options_title = UIWidgets.create_simple_text(Localize("avilable_traits"), "property_options_title", nil, nil, var_0_9)
}
local var_0_27 = {
	info_title = var_0_16("info_title", Localize("crafting_recipe_upgrade_item_rarity_common")),
	upgrade_title = UIWidgets.create_simple_text(Localize("next_upgrade_tier"), "upgrade_title", nil, nil, var_0_5),
	upgrade_rarity_name = UIWidgets.create_simple_text(Localize("difficulty_veteran"), "upgrade_rarity_name", nil, nil, var_0_4),
	upgrade_description_text = UIWidgets.create_simple_text(Localize("description_crafting_upgrade_item_rarity_common"), "upgrade_description_text", nil, nil, var_0_10),
	upgrade_icons = var_0_15({
		"icon_add_property",
		"icon_add_property"
	}, {
		217,
		217
	}, "upgrade_icons", 1)
}
local var_0_28 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				arg_18_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
				local var_19_0 = math.easeOutCubic(arg_19_3)

				arg_19_4.render_settings.alpha_multiplier = var_19_0
				arg_19_0.window.local_position[1] = arg_19_1.window.position[1] + math.floor(-100 * (1 - var_19_0))
				arg_19_0.info_window.local_position[1] = arg_19_1.info_window.position[1] + math.floor(100 * (1 - var_19_0))
			end,
			on_complete = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				arg_21_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				local var_22_0 = math.easeOutCubic(arg_22_3)

				arg_22_4.render_settings.alpha_multiplier = 1 - var_22_0
			end,
			on_complete = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				return
			end
		}
	},
	on_crafting_enter = {
		{
			name = "crafting_fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				arg_24_3.state_render_settings.alpha_multiplier = 1
			end,
			update = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				local var_25_0 = math.easeOutCubic(arg_25_3)

				arg_25_4.state_render_settings.alpha_multiplier = 1 - var_25_0
			end,
			on_complete = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				return
			end
		}
	},
	on_crafting_exit = {
		{
			name = "crafting_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				arg_27_3.state_render_settings.alpha_multiplier = 0
			end,
			update = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				local var_28_0 = math.easeOutCubic(arg_28_3)

				arg_28_4.state_render_settings.alpha_multiplier = var_28_0
			end,
			on_complete = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				return
			end
		}
	}
}
local var_0_29 = {
	default = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "d_horizontal",
			priority = 2,
			description_text = "input_description_select",
			ignore_keybinding = true
		},
		{
			priority = 3,
			description_text = "input_description_information",
			ignore_keybinding = true,
			input_action = IS_PS4 and "l2" or "left_trigger"
		},
		{
			input_action = "back",
			priority = 4,
			description_text = "input_description_close"
		}
	},
	item_setting = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "d_horizontal",
			priority = 2,
			description_text = "input_description_select",
			ignore_keybinding = true
		},
		{
			input_action = "refresh",
			priority = 3,
			description_text = "crafting_recipe_apply_weapon_skin"
		},
		{
			priority = 4,
			description_text = "input_description_information",
			ignore_keybinding = true,
			input_action = IS_PS4 and "l2" or "left_trigger"
		},
		{
			input_action = "back",
			priority = 5,
			description_text = "input_description_close"
		}
	},
	item_properties = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "refresh",
			priority = 2,
			description_text = "crafting_recipe_weapon_reroll_properties"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	},
	item_trait = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "right_stick",
			priority = 2,
			description_text = "input_description_scroll_details",
			ignore_keybinding = true
		},
		{
			input_action = "refresh",
			priority = 3,
			description_text = "crafting_recipe_weapon_reroll_traits"
		},
		{
			input_action = "back",
			priority = 4,
			description_text = "input_description_close"
		}
	},
	item_upgrade = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "refresh",
			priority = 2,
			description_text = "hero_view_crafting_upgrade"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	}
}

return {
	crafting_widgets = var_0_22,
	widgets = var_0_20,
	preview_widgets = var_0_17,
	info_widgets = var_0_23,
	weapon_illusion_base_widgets = var_0_24,
	trait_reroll_widgets = var_0_26,
	property_reroll_widgets = var_0_25,
	upgrade_widgets = var_0_27,
	scenegraph_definition = var_0_3,
	animation_definitions = var_0_28,
	create_property_option = var_0_12,
	create_trait_option = var_0_13,
	create_illusion_button = var_0_11,
	background_rect = UIWidgets.create_simple_rect("screen", {
		150,
		0,
		0,
		0
	}),
	generic_input_actions = var_0_29
}
