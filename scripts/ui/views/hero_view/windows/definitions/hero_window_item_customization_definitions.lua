-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_item_customization_definitions.lua

local window_size = {
	500,
	800
}
local game_option_size = {
	window_size[1],
	100
}
local console_menu_scenegraphs = UISettings.console_menu_scenegraphs
local scenegraph_definition = {
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
	screen = console_menu_scenegraphs.screen,
	area = console_menu_scenegraphs.area,
	window = {
		vertical_alignment = "top",
		parent = "area",
		horizontal_alignment = "left",
		size = window_size,
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
		size = window_size,
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
			window_size[1],
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
			window_size[1],
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
			window_size[1],
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
			window_size[1],
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
			window_size[1],
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
			window_size[1] / 3,
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
			window_size[1],
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
			window_size[1] - 20,
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
			window_size[1] - 20,
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
			window_size[1] - 20,
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
			window_size[1] - 20,
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
			window_size[1] - 20,
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
			window_size[1],
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
local upgrade_rarity_name_style = {
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
local upgrade_title_style = {
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
local illusion_title_style = {
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
local illusion_counter_style = {
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
local illusion_name_style = {
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
local property_options_title_style = {
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
local description_text_style = {
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

local function create_illusion_button()
	-- function 1
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
					content_check_function = function (content)
						-- function 2
						local hotspot = content.button_hotspot
						local is_selected

						if not hotspot.is_hover then
							is_selected = hotspot.is_selected

							if is_selected then
								-- Nothing
							end
						end

						is_selected = not content.equipped

						::label_2_0::

						return is_selected
					end
				},
				{
					pass_type = "texture",
					style_id = "equipped_texture",
					texture_id = "equipped_texture",
					content_check_function = function (content)
						-- function 3
						return content.equipped
					end
				}
			}
		},
		content = {
			selection_texture = "button_illusion_glow",
			locked = false,
			hover_texture = "button_illusion_glow_white",
			lock_texture = "hero_icon_locked",
			icon_texture = "icons_placeholder",
			equipped_texture = "button_illusion_glow",
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

local function create_property_option(scenegraph_id, text)
	-- function 4
	local masked = true
	local tbl = {
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
			text = text
		}
	}
	local tbl_2 = {
		texture_id = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = masked,
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
		}
	}
	local tbl_3 = {
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
		}
	}
	local flag

	flag = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("corn_flower_blue", 255)
	tbl_3.color_override = {}
	tbl_3.color_override_table = {
		start_index = 0,
		end_index = 0,
		color = Colors.get_color_table_with_alpha("font_default", 255)
	}
	tbl_3.offset = {
		15,
		-23,
		3
	}
	tbl_2.text = tbl_3

	local tbl_4 = {
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
		}
	}
	local flag_2

	flag_2 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_4.offset = {
		16,
		-24,
		2
	}
	tbl_2.text_shadow = tbl_4
	tbl.style = tbl_2
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = scenegraph_id

	return tbl
end

local function create_trait_option(scenegraph_id, title_text, description_text, icon)
	-- function 5
	local masked = true
	local tbl = {
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
			title_text = title_text,
			description_text = description_text,
			texture_id = icon
		}
	}
	local tbl_2 = {
		texture_id = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = masked,
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
		}
	}
	local tbl_3 = {
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
		}
	}
	local flag

	flag = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_3.offset = {
		30,
		-5,
		3
	}
	tbl_2.title_text = tbl_3

	local tbl_4 = {
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
		}
	}
	local flag_2

	flag_2 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_4.offset = {
		31,
		-6,
		2
	}
	tbl_2.title_text_shadow = tbl_4

	local tbl_5 = {
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
		}
	}
	local flag_3

	flag_3 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_5.font_type = flag_3
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_5.offset = {
		30,
		-47,
		3
	}
	tbl_2.description_text = tbl_5

	local tbl_6 = {
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
		}
	}
	local flag_4

	flag_4 = (not masked or not "hell_shark_masked") and not not "hell_shark"
	tbl_6.font_type = flag_4
	tbl_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_6.offset = {
		31,
		-48,
		2
	}
	tbl_2.description_text_shadow = tbl_6
	tbl.style = tbl_2
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = scenegraph_id

	return tbl
end

local function create_scroll_mask(scenegraph_id, size)
	-- function 6
	local edge_height = 10
	local element = {
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
	local content = {
		mask_edge = "mask_rect_edge_fade",
		mask_texture = "mask_rect"
	}
	local style = {
		mask = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			size = {
				size[1],
				size[2] - edge_height * 2
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
				size[1],
				edge_height
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
				size[1],
				edge_height
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
				size[1] / 2,
				edge_height / 2
			}
		}
	}
	local widget = {}

	widget.element = element
	widget.content = content
	widget.style = style
	widget.offset = {
		0,
		0,
		0
	}
	widget.scenegraph_id = scenegraph_id

	return widget
end

local function create_simple_centered_textures(textures, texture_size, scenegraph_id, spacing)
	-- function 7
	local texture_colors = {}

	for i = 1, #textures do
		texture_colors[i] = {
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
			texture_id = textures
		},
		style = {
			texture_id = {
				texture_axis = 1,
				spacing = not not spacing or not not 8,
				texture_size = texture_size,
				texture_amount = #textures,
				color = {
					255,
					255,
					255,
					255
				},
				texture_colors = texture_colors,
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
		scenegraph_id = scenegraph_id
	}
end

local function create_title_widget(scenegraph_id, title_text)
	-- function 8
	local size = scenegraph_definition[scenegraph_id].size
	local text_spacing = 10
	local passes = {
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
	local content = {
		default_title_text = title_text,
		title_text = title_text,
		size = size,
		text_spacing = text_spacing
	}
	local style = {
		title_text = {
			vertical_alignment = "center",
			upper_case = true,
			horizontal_alignment = "left",
			font_size = 34,
			font_type = "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("font_title", 255),
			offset = {
				text_spacing,
				-3,
				2
			},
			size = {
				size[1] - text_spacing,
				size[2]
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
				text_spacing + 2,
				-5,
				1
			},
			size = {
				size[1] - text_spacing,
				size[2]
			}
		}
	}
	local widget = {}
	local element = {}

	element.passes = passes
	widget.element = element
	widget.content = content
	widget.style = style
	widget.offset = {
		0,
		0,
		0
	}
	widget.scenegraph_id = scenegraph_id

	return widget
end

local preview_widgets = {
	mission_setting_preview = UIWidgets.create_game_option_mission_preview("info_window", scenegraph_definition.info_window.size)
}
local rarity_display_textures = {}
local rarity_display_sizes = {}

for i = 1, 5 do
	rarity_display_textures[i] = "item_tier_empty"
	rarity_display_sizes[i] = {
		37,
		50
	}
end

local widgets = {
	window = UIWidgets.create_game_option_window("window", scenegraph_definition.window.size, {
		128,
		0,
		0,
		0
	}),
	info_window = UIWidgets.create_game_option_window("info_window", scenegraph_definition.info_window.size, {
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
	item_setting = UIWidgets.create_item_option_overview("option_1", scenegraph_definition.option_1.size),
	item_properties = UIWidgets.create_item_option_properties("option_2", scenegraph_definition.option_2.size),
	item_trait = UIWidgets.create_item_option_trait("option_3", scenegraph_definition.option_3.size),
	item_upgrade = UIWidgets.create_item_option_upgrade("option_4", scenegraph_definition.option_4.size),
	scroll_area = create_scroll_mask("scroll_area", scenegraph_definition.scroll_area.size),
	scrollbar = UIWidgets.create_scrollbar("scrollbar", scenegraph_definition.scrollbar.size, "scroll_area"),
	rarity_display = UIWidgets.create_simple_multi_texture(rarity_display_textures, rarity_display_sizes, 1, 1, {
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
					content_check_function = function (content, style)
						-- function 9
						return content.active
					end,
					content_change_function = function (content, style, _, dt)
						-- function 10
						local progress_2 = style.progress

						if not progress_2 then
							-- Nothing
						end

						progress_2 = 0

						local progress = progress_2

						::label_10_0::

						progress = (progress + dt) % 1

						local angle = math.pow(2, math.smoothstep(progress, 0, 1)) * (math.pi * 2)

						style.angle = angle
						style.progress = progress
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

function create_button(scenegraph_id, size, frame_name, background_texture, text, font_size, optional_color_name, optional_detail_texture, optional_detail_offset, disable_with_gamepad, skip_side_detail)
	-- function 11
	background_texture = not not background_texture or not not "button_bg_01"

	local background_texture_settings = UIAtlasHelper.get_atlas_settings_by_texture_name(background_texture)
	local var_11_0

	if frame_name then
		var_11_0 = UIFrameSettings[frame_name]

		if not var_11_0 then
			-- Nothing
		end
	end

	var_11_0 = UIFrameSettings.button_frame_01

	local frame_settings = var_11_0

	::label_11_0::

	local frame_width = frame_settings.texture_sizes.corner[1]
	local side_detail_texture = not not optional_detail_texture or not not "button_detail_01"
	local side_detail_texture_settings = UIAtlasHelper.get_atlas_settings_by_texture_name(side_detail_texture)
	local side_detail_texture_size = side_detail_texture_settings.size
	local extra_detail_offset_x, extra_detail_offset_y

	if optional_detail_offset then
		if type(optional_detail_offset) == "table" then
			extra_detail_offset_x = optional_detail_offset[1]
			extra_detail_offset_y = optional_detail_offset[2]
		else
			extra_detail_offset_x = optional_detail_offset
		end
	end

	local tbl = {
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
					content_check_function = function (content)
						-- function 12
						return content.draw_frame
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
					content_check_function = function (content)
						-- function 13
						local button_hotspot = content.button_hotspot

						return button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function (content)
						-- function 14
						return not content.skip_side_detail
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function (content)
						-- function 15
						return not content.skip_side_detail
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (content)
						-- function 16
						local button_hotspot = content.button_hotspot

						return not button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (content)
						-- function 17
						local button_hotspot = content.button_hotspot

						return button_hotspot.disable_button
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
				texture_id = side_detail_texture,
				skip_side_detail = skip_side_detail
			},
			button_hotspot = {},
			title_text = not not text or not not "n/a",
			frame = frame_settings.texture,
			background = {
				uvs = {
					{
						0,
						1 - size[2] / background_texture_settings.size[2]
					},
					{
						size[1] / background_texture_settings.size[1],
						1
					}
				},
				texture_id = background_texture
			},
			disable_with_gamepad = disable_with_gamepad
		}
	}
	local tbl_2 = {
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
				frame_width,
				frame_width - 2,
				2
			},
			size = {
				size[1] - frame_width * 2,
				size[2] - frame_width * 2
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
				frame_width - 2,
				3
			},
			size = {
				size[1],
				math.min(size[2] - 5, 80)
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
			font_size = not not font_size or not not 24,
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			select_text_color = Colors.get_color_table_with_alpha("white", 255),
			size = {
				size[1] - 40,
				size[2]
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
			font_size = not not font_size or not not 24,
			text_color = Colors.get_color_table_with_alpha("gray", 255),
			default_text_color = Colors.get_color_table_with_alpha("gray", 255),
			size = {
				size[1] - 40,
				size[2]
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
			font_size = not not font_size or not not 24,
			text_color = Colors.get_color_table_with_alpha("black", 255),
			default_text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				size[1] - 40,
				size[2]
			},
			offset = {
				22,
				-2,
				5
			}
		},
		frame = {
			texture_size = frame_settings.texture_size,
			texture_sizes = frame_settings.texture_sizes,
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
				size[2] - (frame_width + 11),
				4
			},
			size = {
				size[1],
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
				frame_width - 9,
				4
			},
			size = {
				size[1],
				11
			}
		}
	}
	local tbl_3 = {
		color = {
			255,
			255,
			255,
			255
		}
	}
	local tbl_4 = {
		nil,
		nil,
		9
	}
	local num

	if extra_detail_offset_x then
		num = -extra_detail_offset_x

		if not num then
			-- Nothing
		end
	end

	num = -9

	::label_11_1::

	tbl_4[1] = num
	tbl_4[2] = size[2] / 2 - side_detail_texture_size[2] / 2 + (not not extra_detail_offset_y or not not 0)
	tbl_3.offset = tbl_4
	tbl_3.size = {
		side_detail_texture_size[1],
		side_detail_texture_size[2]
	}
	tbl_2.side_detail_left = tbl_3
	tbl_2.side_detail_right = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			size[1] - side_detail_texture_size[1] + (not not extra_detail_offset_x or not not 9),
			size[2] / 2 - side_detail_texture_size[2] / 2 + (not not extra_detail_offset_y or not not 0),
			9
		},
		size = {
			side_detail_texture_size[1],
			side_detail_texture_size[2]
		}
	}
	tbl.style = tbl_2
	tbl.scenegraph_id = scenegraph_id
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

local disable_with_gamepad = false
local crafting_widgets = {
	craft_button = create_button("craft_button", scenegraph_definition.craft_button.size, nil, nil, "n/a", 32, nil, nil, nil, disable_with_gamepad),
	button_top_edge_left = UIWidgets.create_simple_uv_texture("frame_detail_04", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "button_top_edge", nil, nil, nil, nil, disable_with_gamepad),
	button_top_edge_right = UIWidgets.create_simple_uv_texture("frame_detail_04", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "button_top_edge", nil, nil, nil, nil, disable_with_gamepad),
	button_top_edge_glow = UIWidgets.create_simple_uv_texture("hero_panel_selection_glow", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "button_top_edge_glow", nil, nil, nil, nil, disable_with_gamepad),
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
local info_widgets = {
	info_title = create_title_widget("info_title", Localize("input_description_information")),
	keyword_divider_top = UIWidgets.create_simple_texture("divider_01_bottom", "keyword_divider_top"),
	keyword_divider_bottom = UIWidgets.create_simple_texture("divider_01_bottom", "keyword_divider_bottom")
}
local weapon_illusion_base_widgets = {
	illusions_divider = UIWidgets.create_simple_texture("divider_01_bottom", "illusions_divider"),
	illusions_title = UIWidgets.create_simple_text(Localize("inventory_screen_weapon_skins_title"), "illusions_title", nil, nil, illusion_title_style),
	illusions_counter = UIWidgets.create_simple_text(Localize("inventory_screen_weapon_skins_title"), "illusions_title", nil, nil, illusion_counter_style),
	illusions_name = UIWidgets.create_simple_text("", "illusions_name", nil, nil, illusion_name_style)
}
local property_reroll_widgets = {
	info_title = create_title_widget("info_title", Localize("hero_view_crafting_properties")),
	description_2_divider = UIWidgets.create_simple_texture("divider_01_bottom", "description_2_divider"),
	property_options_title = UIWidgets.create_simple_text(Localize("available_properties"), "property_options_title", nil, nil, property_options_title_style)
}
local trait_reroll_widgets = {
	info_title = create_title_widget("info_title", Localize("crafting_recipe_weapon_reroll_traits")),
	description_2_divider = UIWidgets.create_simple_texture("divider_01_bottom", "description_2_divider"),
	property_options_title = UIWidgets.create_simple_text(Localize("avilable_traits"), "property_options_title", nil, nil, property_options_title_style)
}
local upgrade_widgets = {
	info_title = create_title_widget("info_title", Localize("crafting_recipe_upgrade_item_rarity_common")),
	upgrade_title = UIWidgets.create_simple_text(Localize("next_upgrade_tier"), "upgrade_title", nil, nil, upgrade_title_style),
	upgrade_rarity_name = UIWidgets.create_simple_text(Localize("difficulty_veteran"), "upgrade_rarity_name", nil, nil, upgrade_rarity_name_style),
	upgrade_description_text = UIWidgets.create_simple_text(Localize("description_crafting_upgrade_item_rarity_common"), "upgrade_description_text", nil, nil, description_text_style),
	upgrade_icons = create_simple_centered_textures({
		"icon_add_property",
		"icon_add_property"
	}, {
		217,
		217
	}, "upgrade_icons", 1)
}
local animation_definitions = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (ui_scenegraph, scenegraph_definition, widgets, params)
				-- function 18
				params.render_settings.alpha_multiplier = 0
			end,
			update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
				-- function 19
				local anim_progress = math.easeOutCubic(progress)

				params.render_settings.alpha_multiplier = anim_progress
				ui_scenegraph.window.local_position[1] = scenegraph_definition.window.position[1] + math.floor(-100 * (1 - anim_progress))
				ui_scenegraph.info_window.local_position[1] = scenegraph_definition.info_window.position[1] + math.floor(100 * (1 - anim_progress))
			end,
			on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
				-- function 20
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (ui_scenegraph, scenegraph_definition, widgets, params)
				-- function 21
				params.render_settings.alpha_multiplier = 1
			end,
			update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
				-- function 22
				local anim_progress = math.easeOutCubic(progress)

				params.render_settings.alpha_multiplier = 1 - anim_progress
			end,
			on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
				-- function 23
				return
			end
		}
	},
	on_crafting_enter = {
		{
			name = "crafting_fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (ui_scenegraph, scenegraph_definition, widgets, params)
				-- function 24
				params.state_render_settings.alpha_multiplier = 1
			end,
			update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
				-- function 25
				local anim_progress = math.easeOutCubic(progress)

				params.state_render_settings.alpha_multiplier = 1 - anim_progress
			end,
			on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
				-- function 26
				return
			end
		}
	},
	on_crafting_exit = {
		{
			name = "crafting_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (ui_scenegraph, scenegraph_definition, widgets, params)
				-- function 27
				params.state_render_settings.alpha_multiplier = 0
			end,
			update = function (ui_scenegraph, scenegraph_definition, widgets, progress, params)
				-- function 28
				local anim_progress = math.easeOutCubic(progress)

				params.state_render_settings.alpha_multiplier = anim_progress
			end,
			on_complete = function (ui_scenegraph, scenegraph_definition, widgets, params)
				-- function 29
				return
			end
		}
	}
}
local tbl = {}
local tbl_2 = {
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
	}
}
local tbl_3 = {
	priority = 3,
	description_text = "input_description_information",
	ignore_keybinding = true
}
local flag

flag = (not IS_PS4 or not "l2") and not not "left_trigger"
tbl_3.input_action = flag
tbl_2[3] = tbl_3
tbl_2[4] = {
	input_action = "back",
	priority = 4,
	description_text = "input_description_close"
}
tbl.default = tbl_2

local tbl_4 = {
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
	}
}
local tbl_5 = {
	priority = 4,
	description_text = "input_description_information",
	ignore_keybinding = true
}
local flag_2

flag_2 = (not IS_PS4 or not "l2") and not not "left_trigger"
tbl_5.input_action = flag_2
tbl_4[4] = tbl_5
tbl_4[5] = {
	input_action = "back",
	priority = 5,
	description_text = "input_description_close"
}
tbl.item_setting = tbl_4
tbl.item_properties = {
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
}
tbl.item_trait = {
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
}
tbl.item_upgrade = {
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

local generic_input_actions = tbl

return {
	crafting_widgets = crafting_widgets,
	widgets = widgets,
	preview_widgets = preview_widgets,
	info_widgets = info_widgets,
	weapon_illusion_base_widgets = weapon_illusion_base_widgets,
	trait_reroll_widgets = trait_reroll_widgets,
	property_reroll_widgets = property_reroll_widgets,
	upgrade_widgets = upgrade_widgets,
	scenegraph_definition = scenegraph_definition,
	animation_definitions = animation_definitions,
	create_property_option = create_property_option,
	create_trait_option = create_trait_option,
	create_illusion_button = create_illusion_button,
	background_rect = UIWidgets.create_simple_rect("screen", {
		150,
		0,
		0,
		0
	}),
	generic_input_actions = generic_input_actions
}
