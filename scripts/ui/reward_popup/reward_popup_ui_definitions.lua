-- chunkname: @scripts/ui/reward_popup/reward_popup_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = {
	370,
	70
}
local var_0_3 = 9
local var_0_4 = 7
local var_0_5 = 5
local var_0_6 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.end_screen_banner
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	background = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	background_top = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			518,
			55
		}
	},
	deus_background_top = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			10
		},
		size = {
			518,
			122
		}
	},
	background_top_glow = {
		vertical_alignment = "bottom",
		parent = "background_top",
		horizontal_alignment = "center",
		position = {
			0,
			-0,
			1
		},
		size = {
			518,
			0
		}
	},
	deus_background_top_glow = {
		vertical_alignment = "bottom",
		parent = "deus_background_top",
		horizontal_alignment = "center",
		position = {
			0,
			-0,
			9
		},
		size = {
			518,
			0
		}
	},
	background_bottom = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			2
		},
		size = {
			518,
			55
		}
	},
	deus_background_bottom = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			10
		},
		size = {
			518,
			122
		}
	},
	background_bottom_glow = {
		vertical_alignment = "top",
		parent = "background_bottom",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			9
		},
		size = {
			518,
			0
		}
	},
	deus_background_bottom_glow = {
		vertical_alignment = "top",
		parent = "deus_background_bottom",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			518,
			0
		}
	},
	background_center = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			472,
			0
		}
	},
	entry_root = {
		vertical_alignment = "center",
		parent = "background_center",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			5
		},
		size = {
			1500,
			0
		}
	},
	deus_item_tooltip = {
		vertical_alignment = "bottom",
		parent = "deus_background_top",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			-2
		},
		size = {
			400,
			0
		},
		offset = {
			0,
			-5,
			0
		}
	},
	deus_power_up = {
		vertical_alignment = "top",
		parent = "deus_background_top",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			-2
		},
		size = {
			330,
			194
		},
		offset = {
			-60,
			-120,
			0
		}
	},
	item_tooltip = {
		vertical_alignment = "bottom",
		parent = "background_top",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			-5
		},
		size = {
			400,
			0
		},
		offset = {
			0,
			-5,
			0
		}
	},
	title_root = {
		vertical_alignment = "center",
		parent = "background_top",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			1500,
			0
		},
		offset = {
			0,
			-80,
			0
		}
	},
	level_root = {
		vertical_alignment = "center",
		parent = "entry_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			1500,
			0
		}
	},
	reward_root = {
		vertical_alignment = "center",
		parent = "background_bottom",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			5
		},
		size = {
			0,
			0
		}
	},
	deus_reward_root = {
		vertical_alignment = "center",
		parent = "deus_background_top",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			5
		},
		size = {
			0,
			0
		}
	},
	texture_root = {
		vertical_alignment = "center",
		parent = "reward_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	item_root = {
		vertical_alignment = "center",
		parent = "reward_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			10
		},
		size = {
			80,
			80
		}
	},
	item_list_root = {
		vertical_alignment = "center",
		parent = "reward_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			10
		},
		offset = {
			0.5 * var_0_5,
			0.5 * var_0_5 + 80 + 15,
			0
		},
		size = {
			(80 + var_0_5) * var_0_3,
			80
		}
	},
	deus_item_root = {
		vertical_alignment = "center",
		parent = "deus_reward_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			80,
			80
		},
		offset = {
			0,
			-10,
			0
		}
	},
	deus_icon = {
		vertical_alignment = "center",
		parent = "deus_reward_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			74,
			74
		},
		offset = {
			0,
			-10,
			0
		}
	},
	career_root = {
		vertical_alignment = "center",
		parent = "reward_root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			1
		},
		size = {
			60,
			70
		}
	},
	claim_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			100,
			1
		},
		size = var_0_2
	}
}
local var_0_7 = {
	word_wrap = true,
	font_size = 46,
	localize = false,
	use_shadow = true,
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
local var_0_8 = {
	word_wrap = true,
	font_size = 46,
	localize = false,
	use_shadow = true,
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

local function var_0_9(arg_1_0, arg_1_1)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				},
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture"
				}
			}
		},
		content = {
			frame = "reward_pop_up_item_frame",
			background = "reward_pop_up_item_bg",
			texture_id = arg_1_0
		},
		style = {
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
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
			frame = {
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
			background = {
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
		},
		scenegraph_id = arg_1_1
	}
end

local function var_0_10(arg_2_0, arg_2_1)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture"
				},
				{
					texture_id = "rarity_texture",
					style_id = "rarity_texture",
					pass_type = "texture"
				}
			}
		},
		content = {
			frame = "reward_pop_up_item_frame",
			rarity_texture = "icon_bg_plentiful",
			texture_id = arg_2_0
		},
		style = {
			texture_id = {
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
			frame = {
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
			rarity_texture = {
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
		},
		scenegraph_id = arg_2_1
	}
end

local function var_0_11(arg_3_0)
	local var_3_0 = {}
	local var_3_1 = {
		frame = "reward_pop_up_item_frame",
		illusion = "item_frame_illusion",
		no_equipped_item = true
	}
	local var_3_2 = {}

	for iter_3_0 = 1, var_0_3 * var_0_4 do
		local var_3_3 = "rarity" .. iter_3_0
		local var_3_4 = "icon" .. iter_3_0
		local var_3_5 = "illusion" .. iter_3_0
		local var_3_6 = "frame" .. iter_3_0
		local var_3_7 = "tooltip" .. iter_3_0
		local var_3_8 = "item" .. iter_3_0

		local function var_3_9(arg_4_0)
			return arg_4_0[var_3_8]
		end

		var_3_0[#var_3_0 + 1] = {
			pass_type = "texture",
			style_id = var_3_3,
			texture_id = var_3_3,
			content_check_function = var_3_9
		}
		var_3_0[#var_3_0 + 1] = {
			pass_type = "texture",
			style_id = var_3_4,
			texture_id = var_3_4,
			content_check_function = var_3_9
		}
		var_3_0[#var_3_0 + 1] = {
			texture_id = "illusion",
			pass_type = "texture",
			style_id = var_3_5,
			content_check_function = function(arg_5_0)
				return arg_5_0[var_3_8] and arg_5_0[var_3_5]
			end
		}
		var_3_0[#var_3_0 + 1] = {
			texture_id = "frame",
			pass_type = "texture",
			style_id = var_3_6,
			content_check_function = var_3_9
		}
		var_3_0[#var_3_0 + 1] = {
			pass_type = "hover",
			style_id = var_3_7,
			content_check_function = var_3_9
		}
		var_3_0[#var_3_0 + 1] = {
			pass_type = "item_tooltip",
			item_id = var_3_8,
			style_id = var_3_7,
			content_check_function = function(arg_6_0)
				if not arg_6_0[var_3_8] then
					return false
				end

				local var_6_0 = arg_6_0.selected_i

				if var_6_0 then
					return var_6_0 == iter_3_0
				else
					return arg_6_0.is_hover
				end
			end
		}
		var_3_1[var_3_3] = "icons_placeholder"
		var_3_1[var_3_4] = "icons_placeholder"
		var_3_1[var_3_5] = false
		var_3_2[var_3_3] = {
			offset = {
				0,
				0,
				0
			},
			size = {
				80,
				80
			}
		}
		var_3_2[var_3_4] = {
			offset = {
				0,
				0,
				1
			},
			size = {
				80,
				80
			}
		}
		var_3_2[var_3_5] = {
			offset = {
				0,
				0,
				3
			},
			size = {
				80,
				80
			}
		}
		var_3_2[var_3_6] = {
			offset = {
				0,
				0,
				4
			},
			size = {
				80,
				80
			}
		}
		var_3_2[var_3_7] = {
			font_type = "hell_shark",
			localize = true,
			font_size = 18,
			horizontal_alignment = "left",
			vertical_alignment = "top",
			max_width = 500,
			offset = {
				0,
				0,
				5
			},
			size = {
				80,
				80
			},
			text_color = Colors.get_color_table_with_alpha("white", 255),
			line_colors = {
				Colors.get_color_table_with_alpha("font_title", 255),
				Colors.get_color_table_with_alpha("white", 255)
			}
		}
	end

	local var_3_10 = UIFrameSettings.frame_outer_glow_04_big

	var_3_0[#var_3_0 + 1] = {
		pass_type = "texture_frame",
		style_id = "cursor",
		texture_id = "cursor",
		content_check_function = function(arg_7_0)
			return arg_7_0.selected_i
		end
	}
	var_3_1.cursor = var_3_10.texture
	var_3_2.cursor = {
		size = {
			80,
			80
		},
		texture_size = var_3_10.texture_size,
		texture_sizes = var_3_10.texture_sizes,
		frame_margins = {
			-22,
			-22
		},
		offset = {
			0,
			0,
			4
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	return {
		scenegraph_id = arg_3_0,
		offset = {
			0,
			0,
			0
		},
		element = {
			passes = var_3_0
		},
		content = var_3_1,
		style = var_3_2
	}
end

local function var_0_12(arg_8_0, arg_8_1)
	return {
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture"
				},
				{
					texture_id = "rarity_texture",
					style_id = "rarity_texture",
					pass_type = "texture"
				},
				{
					texture_id = "illusion_overlay",
					style_id = "illusion_overlay",
					pass_type = "texture"
				}
			}
		},
		content = {
			frame = "reward_pop_up_item_frame",
			rarity_texture = "icon_bg_plentiful",
			illusion_overlay = "item_frame_illusion",
			texture_id = arg_8_0
		},
		style = {
			texture_id = {
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
			frame = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					3
				}
			},
			illusion_overlay = {
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
			rarity_texture = {
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
		},
		scenegraph_id = arg_8_1
	}
end

local function var_0_13(arg_9_0, arg_9_1)
	local var_9_0 = {
		0,
		6,
		2
	}
	local var_9_1 = {
		vertical_alignment = "bottom",
		word_wrap = true,
		horizontal_alignment = "center",
		font_size = 28,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = var_9_0
	}
	local var_9_2 = table.clone(var_9_1)

	var_9_2.text_color = {
		255,
		0,
		0,
		1
	}
	var_9_2.offset = {
		var_9_0[1] + 2,
		var_9_0[2] - 2,
		var_9_0[3] - 1
	}

	local var_9_3 = {
		0,
		0,
		2
	}
	local var_9_4 = {
		vertical_alignment = "top",
		word_wrap = true,
		horizontal_alignment = "center",
		font_size = 46,
		font_type = "hell_shark_header",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = var_9_3
	}
	local var_9_5 = table.clone(var_9_4)

	var_9_5.text_color = {
		255,
		0,
		0,
		1
	}
	var_9_5.offset = {
		var_9_3[1] + 2,
		var_9_3[2] - 2,
		var_9_3[3] - 1
	}

	return {
		element = {
			passes = {
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
			text = arg_9_0,
			title_text = arg_9_0
		},
		style = {
			title_text = var_9_4,
			title_text_shadow = var_9_5,
			text = var_9_1,
			text_shadow = var_9_2
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_9_1
	}
end

local function var_0_14(arg_10_0)
	return {
		element = {
			passes = {
				{
					texture_id = "shrine_bg",
					style_id = "shrine_bg",
					pass_type = "texture"
				},
				{
					style_id = "shrine_bg_frame_left",
					pass_type = "texture_uv",
					content_id = "shrine_bg_frame_left"
				},
				{
					style_id = "shrine_bg_frame_right",
					pass_type = "texture_uv",
					content_id = "shrine_bg_frame_right"
				},
				{
					texture_id = "icon_glow",
					style_id = "icon_glow",
					pass_type = "texture"
				},
				{
					texture_id = "icon_frame",
					style_id = "icon_frame",
					pass_type = "texture"
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
					style_id = "rarity_text",
					pass_type = "text",
					text_id = "rarity_text"
				},
				{
					style_id = "rarity_text_shadow",
					pass_type = "text",
					text_id = "rarity_text"
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
				},
				{
					style_id = "set_progression",
					pass_type = "text",
					text_id = "set_progression",
					content_check_function = function(arg_11_0)
						return arg_11_0.is_part_of_set
					end
				}
			}
		},
		content = {
			title_text = "",
			set_progression = "%d/%d",
			icon_frame = "weapon_icon_glow_white",
			rarity_text = "",
			shrine_bg = "shrine_blessing_bg_hover",
			visible = true,
			description_text = "",
			icon_glow = "popup_icon_glow_white",
			shrine_bg_frame_left = {
				texture_id = "shrine_blessing_frame",
				uvs = {
					{
						0,
						0
					},
					{
						0.5,
						1
					}
				}
			},
			shrine_bg_frame_right = {
				texture_id = "shrine_blessing_frame",
				uvs = {
					{
						0.5,
						0
					},
					{
						0,
						1
					}
				}
			}
		},
		style = {
			shrine_bg = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
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
				texture_size = {
					484,
					194
				}
			},
			shrine_bg_frame_left = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					242,
					var_0_6.deus_power_up.size[2]
				},
				offset = {
					0,
					0,
					1
				}
			},
			shrine_bg_frame_right = {
				vertical_alignment = "top",
				horizontal_alignment = "right",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					242,
					var_0_6.deus_power_up.size[2]
				},
				offset = {
					114,
					0,
					1
				}
			},
			icon_glow = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					60,
					127,
					15
				},
				texture_size = {
					180,
					180
				}
			},
			icon_frame = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					60,
					83,
					20
				},
				texture_size = {
					82,
					82
				}
			},
			title_text = {
				font_type = "hell_shark_header",
				upper_case = true,
				localize = false,
				word_wrap = false,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				area_size = {
					240,
					var_0_6.deus_power_up.size[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					60,
					-30,
					3
				}
			},
			rarity_text = {
				vertical_alignment = "top",
				font_size = 22,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					50,
					-30,
					3
				}
			},
			description_text = {
				word_wrap = true,
				font_type = "hell_shark",
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				area_size = {
					320,
					110
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					60,
					-60,
					3
				}
			},
			title_text_shadow = {
				font_type = "hell_shark_header",
				upper_case = true,
				localize = false,
				word_wrap = false,
				font_size = 28,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				area_size = {
					240,
					var_0_6.deus_power_up.size[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					62,
					-32,
					2
				}
			},
			rarity_text_shadow = {
				vertical_alignment = "top",
				font_size = 22,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					52,
					-32,
					2
				}
			},
			description_text_shadow = {
				word_wrap = true,
				font_type = "hell_shark",
				localize = false,
				dynamic_font_size_word_wrap = true,
				font_size = 20,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				area_size = {
					320,
					110
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					62,
					-62,
					2
				}
			},
			set_progression = {
				word_wrap = false,
				upper_case = false,
				font_size = 20,
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				font_type = "hell_shark",
				progression_colors = {
					incomplete = Colors.get_color_table_with_alpha("font_default", 255),
					complete = Colors.get_color_table_with_alpha("lime_green", 255)
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					52,
					14,
					5
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_10_0
	}
end

local function var_0_15(arg_12_0)
	return {
		element = {
			passes = {
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function(arg_13_0)
						return arg_13_0.icon
					end
				},
				{
					texture_id = "icon_bg",
					style_id = "icon_bg",
					pass_type = "texture",
					content_check_function = function(arg_14_0)
						return arg_14_0.icon
					end
				},
				{
					style_id = "rectangular_bg",
					pass_type = "rect",
					content_check_function = function(arg_15_0)
						return arg_15_0.icon
					end
				}
			}
		},
		content = {
			icon_bg = "button_frame_01"
		},
		style = {
			icon = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
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
				},
				texture_size = {
					58,
					58
				},
				default_texture_size = {
					58,
					58
				}
			},
			icon_bg = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-6,
					0
				},
				texture_size = {
					70,
					70
				},
				default_texture_size = {
					70,
					70
				}
			},
			rectangular_bg = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				color = {
					255,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					1
				},
				texture_size = {
					58,
					58
				},
				default_texture_size = {
					58,
					58
				}
			}
		},
		offset = {
			0,
			0,
			10
		},
		scenegraph_id = arg_12_0
	}
end

local var_0_16 = {
	"item_titles",
	"skin_applied",
	"fatigue",
	"item_power_level",
	"properties",
	"traits",
	"keywords"
}
local var_0_17 = {
	title = UIWidgets.create_simple_text("n/a", "title_root", nil, nil, var_0_7),
	level = UIWidgets.create_simple_text("n/a", "level_root", nil, nil, var_0_8),
	description = var_0_13("n/a", "title_root"),
	texture = {
		scenegraph_id = "item_root",
		element = {
			passes = {
				{
					texture_id = "texture_id",
					style_id = "texture_id",
					pass_type = "texture"
				}
			}
		},
		content = {
			texture_id = "icons_placeholder"
		},
		style = {
			texture_id = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
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
					0
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	},
	icon = var_0_9("icons_placeholder", "item_root"),
	item = var_0_10("icons_placeholder", "item_root"),
	frame = var_0_10("icons_placeholder", "item_root"),
	weapon_skin = var_0_12("icons_placeholder", "item_root"),
	keep_decoration_painting = var_0_12("icons_placeholder", "item_root"),
	skin = var_0_12("icons_placeholder", "item_root"),
	loot_chest = var_0_10("icons_placeholder", "item_root"),
	career = UIWidgets.create_simple_texture("icons_placeholder", "career_root"),
	item_list = var_0_11("item_list_root"),
	background_top = UIWidgets.create_simple_texture("reward_popup_panel", "background_top"),
	background_center = UIWidgets.create_simple_uv_texture("reward_pop_up_01_bg", {
		{
			0,
			0.5
		},
		{
			1,
			0.5
		}
	}, "background_center"),
	background_bottom = UIWidgets.create_simple_uv_texture("reward_popup_panel", {
		{
			1,
			1
		},
		{
			0,
			0
		}
	}, "background_bottom"),
	background_bottom_glow = UIWidgets.create_simple_uv_texture("mission_objective_bottom", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "background_bottom_glow"),
	background_top_glow = UIWidgets.create_simple_uv_texture("mission_objective_top", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "background_top_glow"),
	screen_background = UIWidgets.create_simple_rect("screen", {
		100,
		0,
		0,
		0
	}),
	claim_button = UIWidgets.create_default_button("claim_button", var_0_2, nil, nil, Localize("welcome_currency_popup_button_claim"), nil, nil, nil, nil, true),
	deus_background_top = UIWidgets.create_simple_texture("reward_popup_panel_morris", "deus_background_top"),
	deus_background_bottom = UIWidgets.create_simple_uv_texture("reward_popup_panel_morris", {
		{
			1,
			1
		},
		{
			0,
			0
		}
	}, "deus_background_bottom"),
	deus_background_top_glow = UIWidgets.create_simple_uv_texture("mission_objective_top", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "deus_background_top_glow"),
	deus_background_bottom_glow = UIWidgets.create_simple_uv_texture("mission_objective_bottom", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "deus_background_bottom_glow"),
	deus_item = var_0_10("icons_placeholder", "deus_item_root"),
	deus_item_tooltip = UIWidgets.create_simple_item_presentation("deus_item_tooltip", var_0_16),
	item_tooltip = UIWidgets.create_simple_item_presentation("item_tooltip", var_0_16),
	deus_power_up = var_0_14("deus_power_up"),
	deus_icon = var_0_15("deus_icon")
}

local function var_0_18(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.texture_size
	local var_16_1 = arg_16_0.default_texture_size

	var_16_0[1] = var_16_1[1] * (2 - arg_16_1)
	var_16_0[2] = var_16_1[2] * (2 - arg_16_1)
end

local var_0_19 = {
	entry_enter = {
		{
			name = "fade_in_title_text",
			duration = 0.2,
			init = NOP,
			update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				if not arg_17_4.played_text_reveal_sound_1 then
					arg_17_4.played_text_reveal_sound_1 = true

					WwiseWorld.trigger_event(arg_17_4.wwise_world, "hud_compleation_ver2")
				end

				local var_17_0 = math.easeOutCubic(arg_17_3)

				for iter_17_0, iter_17_1 in pairs(arg_17_2) do
					local var_17_1 = iter_17_1.widget
					local var_17_2 = iter_17_1.widget_type

					iter_17_1.alpha_multiplier = var_17_0

					if var_17_2 == "level" then
						var_17_1.style.text.font_size = var_0_8.font_size * math.catmullrom(var_17_0, -0.5, 1, 1, -0.5)
					elseif var_17_2 == "item" then
						local var_17_3 = var_17_1.scenegraph_id
						local var_17_4 = arg_17_1[var_17_3].size
						local var_17_5 = arg_17_0[var_17_3].size
						local var_17_6 = math.ease_out_exp(arg_17_3)

						var_17_5[1] = var_17_4[1] + var_17_4[1] * (1 - var_17_6)
						var_17_5[2] = var_17_4[2] + var_17_4[2] * (1 - var_17_6)
					elseif var_17_2 == "deus_item" then
						local var_17_7 = var_17_1.scenegraph_id
						local var_17_8 = arg_17_1[var_17_7].size
						local var_17_9 = arg_17_0[var_17_7].size
						local var_17_10 = math.ease_out_exp(arg_17_3)

						var_17_9[1] = var_17_8[1] + var_17_8[1] * (1 - var_17_10) * 3
						var_17_9[2] = var_17_8[2] + var_17_8[2] * (1 - var_17_10) * 3
					elseif var_17_2 == "deus_icon" then
						local var_17_11 = math.ease_out_exp(arg_17_3)

						var_0_18(var_17_1.style.icon, 2 - var_17_11)
						var_0_18(var_17_1.style.icon_bg, 2 - var_17_11)
						var_0_18(var_17_1.style.rectangular_bg, 2 - var_17_11)
					end
				end
			end,
			on_complete = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end
		}
	},
	entry_exit = {
		{
			name = "fade_out_title_text",
			duration = 0.2,
			init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				return
			end,
			update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				local var_20_0 = 1 - math.easeOutCubic(arg_20_3)

				for iter_20_0, iter_20_1 in pairs(arg_20_2) do
					iter_20_1.alpha_multiplier = var_20_0
				end
			end,
			on_complete = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				return
			end
		}
	},
	open = {
		{
			name = "reset",
			start_progress = 0,
			end_progress = 0,
			init = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				local var_22_0 = arg_22_2.deus_background_top
				local var_22_1 = arg_22_2.deus_background_bottom
				local var_22_2 = arg_22_2.background_top
				local var_22_3 = arg_22_2.background_bottom
				local var_22_4 = arg_22_2.background_center

				arg_22_0[var_22_4.scenegraph_id].size[2] = 0
				var_22_2.style.texture_id.color[1] = 0
				var_22_3.style.texture_id.color[1] = 0
				var_22_0.style.texture_id.color[1] = 0
				var_22_1.style.texture_id.color[1] = 0
				var_22_4.style.texture_id.color[1] = 255

				local var_22_5 = var_22_2.scenegraph_id
				local var_22_6 = arg_22_1[var_22_5].position

				arg_22_0[var_22_5].local_position[2] = var_22_6[2]

				local var_22_7 = var_22_3.scenegraph_id
				local var_22_8 = arg_22_1[var_22_7].position

				arg_22_0[var_22_7].local_position[2] = var_22_8[2]
				arg_22_2.claim_button.alpha_multiplier = 0
			end,
			update = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				return
			end,
			on_complete = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				return
			end
		},
		{
			name = "fade_in_blur",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				return
			end,
			update = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				arg_26_4.blur_progress = math.easeOutCubic(arg_26_3)
			end,
			on_complete = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				return
			end
		},
		{
			name = "background_fade_in",
			start_progress = 0.3,
			end_progress = 0.5,
			init = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				if not arg_28_3.played_start_sound then
					arg_28_3.played_start_sound = true

					WwiseWorld.trigger_event(arg_28_3.wwise_world, "hud_difficulty_increased_start")
				end
			end,
			update = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				local var_29_0 = math.easeInCubic(arg_29_3)
				local var_29_1 = arg_29_2.background_top
				local var_29_2 = arg_29_2.background_bottom
				local var_29_3 = 255 * var_29_0

				var_29_1.style.texture_id.color[1] = var_29_3
				var_29_2.style.texture_id.color[1] = var_29_3
			end,
			on_complete = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				return
			end
		},
		{
			name = "background_entry",
			start_progress = 0,
			end_progress = 0.4,
			init = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				return
			end,
			update = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				local var_32_0 = math.easeOutCubic(arg_32_3)
				local var_32_1 = arg_32_2.background_top.scenegraph_id
				local var_32_2 = arg_32_1[var_32_1].size
				local var_32_3 = arg_32_0[var_32_1].size
				local var_32_4 = arg_32_2.background_bottom.scenegraph_id
				local var_32_5 = arg_32_1[var_32_4].size
				local var_32_6 = arg_32_0[var_32_4].size
				local var_32_7 = math.catmullrom(arg_32_3, -4, 1, 1, -1)

				var_32_3[1] = var_32_2[1] * var_32_7
				var_32_3[2] = var_32_2[2] * var_32_7
				var_32_6[1] = var_32_5[1] * var_32_7
				var_32_6[2] = var_32_5[2] * var_32_7
				arg_32_2.claim_button.content.alpha_multiplier = arg_32_3
			end,
			on_complete = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				return
			end
		},
		{
			name = "background_expand",
			start_progress = 0.4,
			end_progress = 0.5,
			init = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				return
			end,
			update = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				local var_35_0 = math.easeOutCubic(arg_35_3)
				local var_35_1 = arg_35_2.background_top.scenegraph_id
				local var_35_2 = arg_35_1[var_35_1].position
				local var_35_3 = arg_35_0[var_35_1].local_position
				local var_35_4 = arg_35_2.background_bottom.scenegraph_id
				local var_35_5 = arg_35_1[var_35_4].position
				local var_35_6 = arg_35_0[var_35_4].local_position
				local var_35_7 = arg_35_2.background_center
				local var_35_8 = var_35_7.scenegraph_id
				local var_35_9 = arg_35_0[var_35_8].size
				local var_35_10 = arg_35_1[var_35_8].size

				var_35_9[2] = math.ceil(var_35_10[2] * var_35_0)

				local var_35_11 = var_35_10[2] / 2
				local var_35_12 = var_35_10[2] / 82
				local var_35_13 = var_35_7.content.texture_id.uvs
				local var_35_14 = var_35_12 * var_35_0

				var_35_13[1][2] = math.min(0.5 + var_35_14, 1)
				var_35_13[2][2] = math.max(0.5 - var_35_14, 0)
				var_35_3[2] = var_35_2[2] + var_35_11 * var_35_0
				var_35_6[2] = var_35_5[2] - var_35_11 * var_35_0
				arg_35_2.background_top_glow.content.texture_id.uvs[2][2] = var_35_0

				local var_35_15 = 55 * var_35_0

				arg_35_0.background_top_glow.size[2] = var_35_15
				arg_35_0.background_top_glow.local_position[2] = -var_35_15
				arg_35_2.background_bottom_glow.content.texture_id.uvs[2][2] = var_35_0

				local var_35_16 = 55 * var_35_0

				arg_35_0.background_bottom_glow.size[2] = var_35_16
				arg_35_0.background_bottom_glow.local_position[2] = var_35_16
			end,
			on_complete = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				return
			end
		}
	},
	close = {
		{
			name = "background_collapse",
			start_progress = 0,
			end_progress = 0.15,
			init = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				return
			end,
			update = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				local var_38_0 = math.easeInCubic(arg_38_3)
				local var_38_1 = 1 - math.easeInCubic(arg_38_3)
				local var_38_2 = arg_38_2.background_top.scenegraph_id
				local var_38_3 = arg_38_1[var_38_2].position
				local var_38_4 = arg_38_0[var_38_2].local_position
				local var_38_5 = arg_38_2.background_bottom.scenegraph_id
				local var_38_6 = arg_38_1[var_38_5].position
				local var_38_7 = arg_38_0[var_38_5].local_position
				local var_38_8 = arg_38_2.background_center
				local var_38_9 = var_38_8.scenegraph_id
				local var_38_10 = arg_38_0[var_38_9].size
				local var_38_11 = arg_38_1[var_38_9].size

				var_38_10[2] = math.ceil(var_38_11[2] - var_38_11[2] * var_38_0)

				local var_38_12 = var_38_11[2] / 2
				local var_38_13 = var_38_11[2] / 82
				local var_38_14 = var_38_8.content.texture_id.uvs
				local var_38_15 = var_38_13 * var_38_1

				var_38_14[1][2] = math.min(0.5 + var_38_15, 1)
				var_38_14[2][2] = math.max(0.5 - var_38_15, 0)
				var_38_4[2] = var_38_3[2] + var_38_12 - var_38_12 * var_38_0
				var_38_7[2] = var_38_6[2] - var_38_12 + var_38_12 * var_38_0
				arg_38_2.background_top_glow.content.texture_id.uvs[2][2] = var_38_1

				local var_38_16 = 55 * var_38_1

				arg_38_0.background_top_glow.size[2] = var_38_16
				arg_38_0.background_top_glow.local_position[2] = -var_38_16
				arg_38_2.background_bottom_glow.content.texture_id.uvs[2][2] = var_38_1

				local var_38_17 = 55 * var_38_1

				arg_38_0.background_bottom_glow.size[2] = var_38_17
				arg_38_0.background_bottom_glow.local_position[2] = var_38_17
			end,
			on_complete = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				if not arg_39_3.played_end_sound then
					arg_39_3.played_end_sound = true

					WwiseWorld.trigger_event(arg_39_3.wwise_world, "hud_difficulty_increased_end")
				end
			end
		},
		{
			name = "fade_out_background",
			start_progress = 0.15,
			end_progress = 0.4,
			init = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				return
			end,
			update = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				local var_41_0 = arg_41_2.background_top
				local var_41_1 = arg_41_2.background_center
				local var_41_2 = arg_41_2.background_bottom
				local var_41_3 = 255 - 255 * math.easeOutCubic(arg_41_3)

				var_41_0.style.texture_id.color[1] = var_41_3
				var_41_2.style.texture_id.color[1] = var_41_3
				var_41_1.style.texture_id.color[1] = var_41_3
			end,
			on_complete = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				return
			end
		},
		{
			name = "fade_out_blur",
			start_progress = 0.4,
			end_progress = 0.5,
			init = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				return
			end,
			update = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				arg_44_4.blur_progress = math.easeOutCubic(1 - arg_44_3)
			end,
			on_complete = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				return
			end
		}
	},
	deus_open = {
		{
			name = "reset",
			start_progress = 0,
			end_progress = 0,
			init = function(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				local var_46_0 = arg_46_2.background_top
				local var_46_1 = arg_46_2.background_bottom
				local var_46_2 = arg_46_2.deus_background_top
				local var_46_3 = arg_46_2.deus_background_bottom
				local var_46_4 = arg_46_2.background_center

				arg_46_0[var_46_4.scenegraph_id].size[2] = 0
				var_46_0.style.texture_id.color[1] = 0
				var_46_1.style.texture_id.color[1] = 0
				var_46_2.style.texture_id.color[1] = 0
				var_46_3.style.texture_id.color[1] = 0
				var_46_4.style.texture_id.color[1] = 0

				local var_46_5 = var_46_2.scenegraph_id
				local var_46_6 = arg_46_1[var_46_5].position

				arg_46_0[var_46_5].local_position[2] = var_46_6[2]

				local var_46_7 = var_46_3.scenegraph_id
				local var_46_8 = arg_46_1[var_46_7].position

				arg_46_0[var_46_7].local_position[2] = var_46_8[2]
				arg_46_3.skip_blur = true
			end,
			update = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
				return
			end,
			on_complete = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
				return
			end
		},
		{
			name = "background_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
				if not arg_49_3.played_start_sound then
					arg_49_3.played_start_sound = true

					WwiseWorld.trigger_event(arg_49_3.wwise_world, "hud_difficulty_increased_start")
				end
			end,
			update = function(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
				local var_50_0 = math.easeInCubic(arg_50_3)
				local var_50_1 = arg_50_2.deus_background_top
				local var_50_2 = arg_50_2.deus_background_bottom
				local var_50_3 = 255 * var_50_0

				var_50_1.style.texture_id.color[1] = var_50_3
				var_50_2.style.texture_id.color[1] = var_50_3
			end,
			on_complete = function(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
				return
			end
		},
		{
			name = "background_entry",
			start_progress = 0,
			end_progress = 0.4,
			init = function(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
				return
			end,
			update = function(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
				local var_53_0 = math.easeOutCubic(arg_53_3)
				local var_53_1 = arg_53_2.deus_background_top.scenegraph_id
				local var_53_2 = arg_53_1[var_53_1].size
				local var_53_3 = arg_53_0[var_53_1].size
				local var_53_4 = arg_53_2.deus_background_bottom.scenegraph_id
				local var_53_5 = arg_53_1[var_53_4].size
				local var_53_6 = arg_53_0[var_53_4].size
				local var_53_7 = math.ease_in_exp(arg_53_3)

				var_53_3[2] = var_53_2[2] * var_53_7
				var_53_6[2] = var_53_5[2] * var_53_7
			end,
			on_complete = function(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
				return
			end
		},
		{
			name = "background_expand",
			start_progress = 0.3,
			end_progress = 0.4,
			init = function(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
				return
			end,
			update = function(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
				local var_56_0 = math.easeOutCubic(arg_56_3)
				local var_56_1 = arg_56_2.deus_background_top.scenegraph_id
				local var_56_2 = arg_56_1[var_56_1].position
				local var_56_3 = arg_56_0[var_56_1].local_position
				local var_56_4 = arg_56_2.deus_background_bottom.scenegraph_id
				local var_56_5 = arg_56_1[var_56_4].position
				local var_56_6 = arg_56_0[var_56_4].local_position
				local var_56_7 = arg_56_2.background_center
				local var_56_8 = var_56_7.scenegraph_id
				local var_56_9 = arg_56_0[var_56_8].size
				local var_56_10 = arg_56_1[var_56_8].size

				var_56_9[2] = math.ceil(var_56_10[2] * var_56_0)

				local var_56_11 = var_56_10[2] / 2
				local var_56_12 = var_56_10[2] / 82
				local var_56_13 = var_56_7.content.texture_id.uvs
				local var_56_14 = var_56_12 * var_56_0

				var_56_13[1][2] = math.min(0.5 + var_56_14, 1)
				var_56_13[2][2] = math.max(0.5 - var_56_14, 0)
				var_56_3[2] = var_56_2[2] + var_56_11 * var_56_0
				var_56_6[2] = var_56_5[2] - var_56_11 * var_56_0
				arg_56_2.deus_background_top_glow.content.texture_id.uvs[2][2] = var_56_0

				local var_56_15 = 55 * var_56_0

				arg_56_0.deus_background_top_glow.size[2] = var_56_15
				arg_56_0.deus_background_top_glow.local_position[2] = -var_56_15
				arg_56_2.deus_background_bottom_glow.content.texture_id.uvs[2][2] = var_56_0

				local var_56_16 = 55 * var_56_0

				arg_56_0.deus_background_bottom_glow.size[2] = var_56_16
				arg_56_0.deus_background_bottom_glow.local_position[2] = var_56_16
			end,
			on_complete = function(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
				return
			end
		}
	},
	deus_close = {
		{
			name = "background_collapse",
			start_progress = 0,
			end_progress = 0.15,
			init = function(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
				return
			end,
			update = function(arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
				local var_59_0 = math.easeInCubic(arg_59_3)
				local var_59_1 = 1 - math.easeInCubic(arg_59_3)
				local var_59_2 = arg_59_2.deus_background_top.scenegraph_id
				local var_59_3 = arg_59_1[var_59_2].position
				local var_59_4 = arg_59_0[var_59_2].local_position
				local var_59_5 = arg_59_2.deus_background_bottom.scenegraph_id
				local var_59_6 = arg_59_1[var_59_5].position
				local var_59_7 = arg_59_0[var_59_5].local_position
				local var_59_8 = arg_59_2.background_center
				local var_59_9 = var_59_8.scenegraph_id
				local var_59_10 = arg_59_0[var_59_9].size
				local var_59_11 = arg_59_1[var_59_9].size

				var_59_10[2] = math.ceil(var_59_11[2] - var_59_11[2] * var_59_0)

				local var_59_12 = var_59_11[2] / 2
				local var_59_13 = var_59_11[2] / 82
				local var_59_14 = var_59_8.content.texture_id.uvs
				local var_59_15 = var_59_13 * var_59_1

				var_59_14[1][2] = math.min(0.5 + var_59_15, 1)
				var_59_14[2][2] = math.max(0.5 - var_59_15, 0)
				var_59_4[2] = var_59_3[2] + var_59_12 - var_59_12 * var_59_0
				var_59_7[2] = var_59_6[2] - var_59_12 + var_59_12 * var_59_0
				arg_59_2.deus_background_top_glow.content.texture_id.uvs[2][2] = var_59_1

				local var_59_16 = 55 * var_59_1

				arg_59_0.deus_background_top_glow.size[2] = var_59_16
				arg_59_0.deus_background_top_glow.local_position[2] = -var_59_16
				arg_59_2.deus_background_bottom_glow.content.texture_id.uvs[2][2] = var_59_1

				local var_59_17 = 55 * var_59_1

				arg_59_0.deus_background_bottom_glow.size[2] = var_59_17
				arg_59_0.deus_background_bottom_glow.local_position[2] = var_59_17
			end,
			on_complete = function(arg_60_0, arg_60_1, arg_60_2, arg_60_3)
				if not arg_60_3.played_end_sound then
					arg_60_3.played_end_sound = true

					WwiseWorld.trigger_event(arg_60_3.wwise_world, "hud_difficulty_increased_end")
				end
			end
		},
		{
			name = "fade_out_background",
			start_progress = 0.15,
			end_progress = 0.4,
			init = function(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
				return
			end,
			update = function(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
				local var_62_0 = arg_62_2.deus_background_top
				local var_62_1 = arg_62_2.deus_background_bottom
				local var_62_2 = arg_62_2.background_center
				local var_62_3 = 255 - 255 * math.easeOutCubic(arg_62_3)

				var_62_0.style.texture_id.color[1] = var_62_3
				var_62_1.style.texture_id.color[1] = var_62_3
				var_62_2.style.texture_id.color[1] = var_62_3
			end,
			on_complete = function(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
				return
			end
		}
	}
}
local var_0_20 = {
	default = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "welcome_currency_popup_button_claim"
		},
		{
			input_action = "d_pad",
			priority = 2,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "right_stick_press",
			priority = 3,
			description_text = "input_description_tooltip"
		}
	}
}

return {
	animations = var_0_19,
	scenegraph_definition = var_0_6,
	widget_definitions = var_0_17,
	item_list_max_columns = var_0_3,
	item_list_max_rows = var_0_4,
	item_list_padding = var_0_5,
	generic_input_actions = var_0_20
}
