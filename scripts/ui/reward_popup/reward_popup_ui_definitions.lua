-- chunkname: @scripts/ui/reward_popup/reward_popup_ui_definitions.lua

local num = 1920
local num_2 = 1080
local tbl = {
	370,
	70
}
local num_3 = 9
local num_4 = 7
local num_5 = 5
local tbl_2 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.end_screen_banner
		},
		size = {
			num,
			num_2
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
			0.5 * num_5,
			0.5 * num_5 + 80 + 15,
			0
		},
		size = {
			(80 + num_5) * num_3,
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
		size = tbl
	}
}
local tbl_3 = {
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
local tbl_4 = {
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

local function fn(arg_1_0, arg_1_1)
	-- function 1
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

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
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

local function fn_3(arg_3_0)
	-- function 3
	local tbl = {}
	local tbl_2 = {
		frame = "reward_pop_up_item_frame",
		illusion = "item_frame_illusion",
		no_equipped_item = true
	}
	local tbl_3 = {}

	for i = 1, num_3 * num_4 do
		local str = "rarity" .. i
		local str_2 = "icon" .. i
		local str_3 = "illusion" .. i
		local str_4 = "frame" .. i
		local str_5 = "tooltip" .. i
		local str_6 = "item" .. i

		local function fn(self)
			-- function 4
			return self[str_6]
		end

		tbl[#tbl + 1] = {
			pass_type = "texture",
			style_id = str,
			texture_id = str,
			content_check_function = fn
		}
		tbl[#tbl + 1] = {
			pass_type = "texture",
			style_id = str_2,
			texture_id = str_2,
			content_check_function = fn
		}
		tbl[#tbl + 1] = {
			texture_id = "illusion",
			pass_type = "texture",
			style_id = str_3,
			content_check_function = function (self)
				-- function 5
				local var_5_0 = self[str_6]

				var_5_0 = not var_5_0 and self[str_3]

				return var_5_0
			end
		}
		tbl[#tbl + 1] = {
			texture_id = "frame",
			pass_type = "texture",
			style_id = str_4,
			content_check_function = fn
		}
		tbl[#tbl + 1] = {
			pass_type = "hover",
			style_id = str_5,
			content_check_function = fn
		}
		tbl[#tbl + 1] = {
			pass_type = "item_tooltip",
			item_id = str_6,
			style_id = str_5,
			content_check_function = function (self)
				-- function 6
				if not self[str_6] then
					return false
				end

				local selected_i = self.selected_i

				if not selected_i then
					return selected_i == i
				else
					return self.is_hover
				end
			end
		}
		tbl_2[str] = "icons_placeholder"
		tbl_2[str_2] = "icons_placeholder"
		tbl_2[str_3] = false
		tbl_3[str] = {
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
		tbl_3[str_2] = {
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
		tbl_3[str_3] = {
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
		tbl_3[str_4] = {
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
		tbl_3[str_5] = {
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

	local frame_outer_glow_04_big = UIFrameSettings.frame_outer_glow_04_big

	tbl[#tbl + 1] = {
		pass_type = "texture_frame",
		style_id = "cursor",
		texture_id = "cursor",
		content_check_function = function (self)
			-- function 7
			return self.selected_i
		end
	}
	tbl_2.cursor = frame_outer_glow_04_big.texture
	tbl_3.cursor = {
		size = {
			80,
			80
		},
		texture_size = frame_outer_glow_04_big.texture_size,
		texture_sizes = frame_outer_glow_04_big.texture_sizes,
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
			passes = tbl
		},
		content = tbl_2,
		style = tbl_3
	}
end

local function fn_4(arg_8_0, arg_8_1)
	-- function 8
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

local function fn_5(arg_9_0, arg_9_1)
	-- function 9
	local tbl = {
		0,
		6,
		2
	}
	local tbl_2 = {
		vertical_alignment = "bottom",
		word_wrap = true,
		horizontal_alignment = "center",
		font_size = 28,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		offset = tbl
	}
	local clone = table.clone(tbl_2)

	clone.text_color = {
		255,
		0,
		0,
		1
	}
	clone.offset = {
		tbl[1] + 2,
		tbl[2] - 2,
		tbl[3] - 1
	}

	local tbl_3 = {
		0,
		0,
		2
	}
	local tbl_4 = {
		vertical_alignment = "top",
		word_wrap = true,
		horizontal_alignment = "center",
		font_size = 46,
		font_type = "hell_shark_header",
		text_color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = tbl_3
	}
	local clone_2 = table.clone(tbl_4)

	clone_2.text_color = {
		255,
		0,
		0,
		1
	}
	clone_2.offset = {
		tbl_3[1] + 2,
		tbl_3[2] - 2,
		tbl_3[3] - 1
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
			title_text = tbl_4,
			title_text_shadow = clone_2,
			text = tbl_2,
			text_shadow = clone
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_9_1
	}
end

local function fn_6(arg_10_0)
	-- function 10
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
					content_check_function = function (self)
						-- function 11
						return self.is_part_of_set
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
					tbl_2.deus_power_up.size[2]
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
					tbl_2.deus_power_up.size[2]
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
					tbl_2.deus_power_up.size[2]
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
					tbl_2.deus_power_up.size[2]
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

local function fn_7(arg_12_0)
	-- function 12
	return {
		element = {
			passes = {
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 13
						return self.icon
					end
				},
				{
					texture_id = "icon_bg",
					style_id = "icon_bg",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 14
						return self.icon
					end
				},
				{
					style_id = "rectangular_bg",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 15
						return self.icon
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

local tbl_5 = {
	"item_titles",
	"skin_applied",
	"fatigue",
	"item_power_level",
	"properties",
	"traits",
	"keywords"
}
local tbl_6 = {
	title = UIWidgets.create_simple_text("n/a", "title_root", nil, nil, tbl_3),
	level = UIWidgets.create_simple_text("n/a", "level_root", nil, nil, tbl_4),
	description = fn_5("n/a", "title_root"),
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
	icon = fn("icons_placeholder", "item_root"),
	item = fn_2("icons_placeholder", "item_root"),
	frame = fn_2("icons_placeholder", "item_root"),
	weapon_skin = fn_4("icons_placeholder", "item_root"),
	keep_decoration_painting = fn_4("icons_placeholder", "item_root"),
	skin = fn_4("icons_placeholder", "item_root"),
	loot_chest = fn_2("icons_placeholder", "item_root"),
	career = UIWidgets.create_simple_texture("icons_placeholder", "career_root"),
	item_list = fn_3("item_list_root"),
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
	claim_button = UIWidgets.create_default_button("claim_button", tbl, nil, nil, Localize("welcome_currency_popup_button_claim"), nil, nil, nil, nil, true),
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
	deus_item = fn_2("icons_placeholder", "deus_item_root"),
	deus_item_tooltip = UIWidgets.create_simple_item_presentation("deus_item_tooltip", tbl_5),
	item_tooltip = UIWidgets.create_simple_item_presentation("item_tooltip", tbl_5),
	deus_power_up = fn_6("deus_power_up"),
	deus_icon = fn_7("deus_icon")
}

local function fn_8(self, arg_16_1)
	-- function 16
	local texture_size = self.texture_size
	local default_texture_size = self.default_texture_size

	texture_size[1] = default_texture_size[1] * (2 - arg_16_1)
	texture_size[2] = default_texture_size[2] * (2 - arg_16_1)
end

local tbl_7 = {
	entry_enter = {
		{
			name = "fade_in_title_text",
			duration = 0.2,
			init = NOP,
			update = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				-- function 17
				if not arg_17_4.played_text_reveal_sound_1 then
					arg_17_4.played_text_reveal_sound_1 = true

					WwiseWorld.trigger_event(arg_17_4.wwise_world, "hud_compleation_ver2")
				end

				local easeOutCubic = math.easeOutCubic(arg_17_3)

				for k, v in pairs(arg_17_2) do
					local widget = v.widget
					local widget_type = v.widget_type

					v.alpha_multiplier = easeOutCubic

					if widget_type == "level" then
						widget.style.text.font_size = tbl_4.font_size * math.catmullrom(easeOutCubic, -0.5, 1, 1, -0.5)
					elseif widget_type == "item" then
						local scenegraph_id = widget.scenegraph_id
						local size = arg_17_1[scenegraph_id].size
						local size_2 = self[scenegraph_id].size
						local ease_out_exp = math.ease_out_exp(arg_17_3)

						size_2[1] = size[1] + size[1] * (1 - ease_out_exp)
						size_2[2] = size[2] + size[2] * (1 - ease_out_exp)
					elseif widget_type == "deus_item" then
						local scenegraph_id_2 = widget.scenegraph_id
						local size_3 = arg_17_1[scenegraph_id_2].size
						local size_4 = self[scenegraph_id_2].size
						local ease_out_exp_2 = math.ease_out_exp(arg_17_3)

						size_4[1] = size_3[1] + size_3[1] * (1 - ease_out_exp_2) * 3
						size_4[2] = size_3[2] + size_3[2] * (1 - ease_out_exp_2) * 3
					elseif widget_type == "deus_icon" then
						local ease_out_exp_3 = math.ease_out_exp(arg_17_3)

						fn_8(widget.style.icon, 2 - ease_out_exp_3)
						fn_8(widget.style.icon_bg, 2 - ease_out_exp_3)
						fn_8(widget.style.rectangular_bg, 2 - ease_out_exp_3)
					end
				end
			end,
			on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				-- function 18
				return
			end
		}
	},
	entry_exit = {
		{
			name = "fade_out_title_text",
			duration = 0.2,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				return
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				local num = 1 - math.easeOutCubic(arg_20_3)

				for k, v in pairs(arg_20_2) do
					v.alpha_multiplier = num
				end
			end,
			on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				return
			end
		}
	},
	open = {
		{
			name = "reset",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
				-- function 22
				local deus_background_top = arg_22_2.deus_background_top
				local deus_background_bottom = arg_22_2.deus_background_bottom
				local background_top = arg_22_2.background_top
				local background_bottom = arg_22_2.background_bottom
				local background_center = arg_22_2.background_center

				arg_22_0[background_center.scenegraph_id].size[2] = 0
				background_top.style.texture_id.color[1] = 0
				background_bottom.style.texture_id.color[1] = 0
				deus_background_top.style.texture_id.color[1] = 0
				deus_background_bottom.style.texture_id.color[1] = 0
				background_center.style.texture_id.color[1] = 255

				local scenegraph_id = background_top.scenegraph_id
				local position = arg_22_1[scenegraph_id].position

				arg_22_0[scenegraph_id].local_position[2] = position[2]

				local scenegraph_id_2 = background_bottom.scenegraph_id
				local position_2 = arg_22_1[scenegraph_id_2].position

				arg_22_0[scenegraph_id_2].local_position[2] = position_2[2]
				arg_22_2.claim_button.alpha_multiplier = 0
			end,
			update = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
				-- function 23
				return
			end,
			on_complete = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				-- function 24
				return
			end
		},
		{
			name = "fade_in_blur",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				return
			end,
			update = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				-- function 26
				arg_26_4.blur_progress = math.easeOutCubic(arg_26_3)
			end,
			on_complete = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				return
			end
		},
		{
			name = "background_fade_in",
			start_progress = 0.3,
			end_progress = 0.5,
			init = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				if not arg_28_3.played_start_sound then
					arg_28_3.played_start_sound = true

					WwiseWorld.trigger_event(arg_28_3.wwise_world, "hud_difficulty_increased_start")
				end
			end,
			update = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				-- function 29
				local easeInCubic = math.easeInCubic(arg_29_3)
				local background_top = arg_29_2.background_top
				local background_bottom = arg_29_2.background_bottom
				local num = 255 * easeInCubic

				background_top.style.texture_id.color[1] = num
				background_bottom.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				-- function 30
				return
			end
		},
		{
			name = "background_entry",
			start_progress = 0,
			end_progress = 0.4,
			init = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				return
			end,
			update = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				-- function 32
				local easeOutCubic = math.easeOutCubic(arg_32_3)
				local scenegraph_id = arg_32_2.background_top.scenegraph_id
				local size = arg_32_1[scenegraph_id].size
				local size_2 = self[scenegraph_id].size
				local scenegraph_id_2 = arg_32_2.background_bottom.scenegraph_id
				local size_3 = arg_32_1[scenegraph_id_2].size
				local size_4 = self[scenegraph_id_2].size
				local catmullrom = math.catmullrom(arg_32_3, -4, 1, 1, -1)

				size_2[1] = size[1] * catmullrom
				size_2[2] = size[2] * catmullrom
				size_4[1] = size_3[1] * catmullrom
				size_4[2] = size_3[2] * catmullrom
				arg_32_2.claim_button.content.alpha_multiplier = arg_32_3
			end,
			on_complete = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				-- function 33
				return
			end
		},
		{
			name = "background_expand",
			start_progress = 0.4,
			end_progress = 0.5,
			init = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				return
			end,
			update = function (self, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				-- function 35
				local easeOutCubic = math.easeOutCubic(arg_35_3)
				local scenegraph_id = arg_35_2.background_top.scenegraph_id
				local position = arg_35_1[scenegraph_id].position
				local local_position = self[scenegraph_id].local_position
				local scenegraph_id_2 = arg_35_2.background_bottom.scenegraph_id
				local position_2 = arg_35_1[scenegraph_id_2].position
				local local_position_2 = self[scenegraph_id_2].local_position
				local background_center = arg_35_2.background_center
				local scenegraph_id_3 = background_center.scenegraph_id
				local size = self[scenegraph_id_3].size
				local size_2 = arg_35_1[scenegraph_id_3].size

				size[2] = math.ceil(size_2[2] * easeOutCubic)

				local num = size_2[2] / 2
				local num_2 = size_2[2] / 82
				local uvs = background_center.content.texture_id.uvs
				local num_3 = num_2 * easeOutCubic

				uvs[1][2] = math.min(0.5 + num_3, 1)
				uvs[2][2] = math.max(0.5 - num_3, 0)
				local_position[2] = position[2] + num * easeOutCubic
				local_position_2[2] = position_2[2] - num * easeOutCubic
				arg_35_2.background_top_glow.content.texture_id.uvs[2][2] = easeOutCubic

				local num_4 = 55 * easeOutCubic

				self.background_top_glow.size[2] = num_4
				self.background_top_glow.local_position[2] = -num_4
				arg_35_2.background_bottom_glow.content.texture_id.uvs[2][2] = easeOutCubic

				local num_5 = 55 * easeOutCubic

				self.background_bottom_glow.size[2] = num_5
				self.background_bottom_glow.local_position[2] = num_5
			end,
			on_complete = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				-- function 36
				return
			end
		}
	},
	close = {
		{
			name = "background_collapse",
			start_progress = 0,
			end_progress = 0.15,
			init = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
				return
			end,
			update = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				-- function 38
				local easeInCubic = math.easeInCubic(arg_38_3)
				local num = 1 - math.easeInCubic(arg_38_3)
				local scenegraph_id = arg_38_2.background_top.scenegraph_id
				local position = arg_38_1[scenegraph_id].position
				local local_position = self[scenegraph_id].local_position
				local scenegraph_id_2 = arg_38_2.background_bottom.scenegraph_id
				local position_2 = arg_38_1[scenegraph_id_2].position
				local local_position_2 = self[scenegraph_id_2].local_position
				local background_center = arg_38_2.background_center
				local scenegraph_id_3 = background_center.scenegraph_id
				local size = self[scenegraph_id_3].size
				local size_2 = arg_38_1[scenegraph_id_3].size

				size[2] = math.ceil(size_2[2] - size_2[2] * easeInCubic)

				local num_2 = size_2[2] / 2
				local num_3 = size_2[2] / 82
				local uvs = background_center.content.texture_id.uvs
				local num_4 = num_3 * num

				uvs[1][2] = math.min(0.5 + num_4, 1)
				uvs[2][2] = math.max(0.5 - num_4, 0)
				local_position[2] = position[2] + num_2 - num_2 * easeInCubic
				local_position_2[2] = position_2[2] - num_2 + num_2 * easeInCubic
				arg_38_2.background_top_glow.content.texture_id.uvs[2][2] = num

				local num_5 = 55 * num

				self.background_top_glow.size[2] = num_5
				self.background_top_glow.local_position[2] = -num_5
				arg_38_2.background_bottom_glow.content.texture_id.uvs[2][2] = num

				local num_6 = 55 * num

				self.background_bottom_glow.size[2] = num_6
				self.background_bottom_glow.local_position[2] = num_6
			end,
			on_complete = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				-- function 39
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
			init = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				return
			end,
			update = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				-- function 41
				local background_top = arg_41_2.background_top
				local background_center = arg_41_2.background_center
				local background_bottom = arg_41_2.background_bottom
				local num = 255 - 255 * math.easeOutCubic(arg_41_3)

				background_top.style.texture_id.color[1] = num
				background_bottom.style.texture_id.color[1] = num
				background_center.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				-- function 42
				return
			end
		},
		{
			name = "fade_out_blur",
			start_progress = 0.4,
			end_progress = 0.5,
			init = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				-- function 43
				return
			end,
			update = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				-- function 44
				arg_44_4.blur_progress = math.easeOutCubic(1 - arg_44_3)
			end,
			on_complete = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				-- function 45
				return
			end
		}
	},
	deus_open = {
		{
			name = "reset",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				-- function 46
				local background_top = arg_46_2.background_top
				local background_bottom = arg_46_2.background_bottom
				local deus_background_top = arg_46_2.deus_background_top
				local deus_background_bottom = arg_46_2.deus_background_bottom
				local background_center = arg_46_2.background_center

				arg_46_0[background_center.scenegraph_id].size[2] = 0
				background_top.style.texture_id.color[1] = 0
				background_bottom.style.texture_id.color[1] = 0
				deus_background_top.style.texture_id.color[1] = 0
				deus_background_bottom.style.texture_id.color[1] = 0
				background_center.style.texture_id.color[1] = 0

				local scenegraph_id = deus_background_top.scenegraph_id
				local position = arg_46_1[scenegraph_id].position

				arg_46_0[scenegraph_id].local_position[2] = position[2]

				local scenegraph_id_2 = deus_background_bottom.scenegraph_id
				local position_2 = arg_46_1[scenegraph_id_2].position

				arg_46_0[scenegraph_id_2].local_position[2] = position_2[2]
				arg_46_3.skip_blur = true
			end,
			update = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
				-- function 47
				return
			end,
			on_complete = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
				-- function 48
				return
			end
		},
		{
			name = "background_fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
				-- function 49
				if not arg_49_3.played_start_sound then
					arg_49_3.played_start_sound = true

					WwiseWorld.trigger_event(arg_49_3.wwise_world, "hud_difficulty_increased_start")
				end
			end,
			update = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
				-- function 50
				local easeInCubic = math.easeInCubic(arg_50_3)
				local deus_background_top = arg_50_2.deus_background_top
				local deus_background_bottom = arg_50_2.deus_background_bottom
				local num = 255 * easeInCubic

				deus_background_top.style.texture_id.color[1] = num
				deus_background_bottom.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
				-- function 51
				return
			end
		},
		{
			name = "background_entry",
			start_progress = 0,
			end_progress = 0.4,
			init = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
				-- function 52
				return
			end,
			update = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
				-- function 53
				local easeOutCubic = math.easeOutCubic(arg_53_3)
				local scenegraph_id = arg_53_2.deus_background_top.scenegraph_id
				local size = arg_53_1[scenegraph_id].size
				local size_2 = self[scenegraph_id].size
				local scenegraph_id_2 = arg_53_2.deus_background_bottom.scenegraph_id
				local size_3 = arg_53_1[scenegraph_id_2].size
				local size_4 = self[scenegraph_id_2].size
				local ease_in_exp = math.ease_in_exp(arg_53_3)

				size_2[2] = size[2] * ease_in_exp
				size_4[2] = size_3[2] * ease_in_exp
			end,
			on_complete = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
				-- function 54
				return
			end
		},
		{
			name = "background_expand",
			start_progress = 0.3,
			end_progress = 0.4,
			init = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
				-- function 55
				return
			end,
			update = function (self, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
				-- function 56
				local easeOutCubic = math.easeOutCubic(arg_56_3)
				local scenegraph_id = arg_56_2.deus_background_top.scenegraph_id
				local position = arg_56_1[scenegraph_id].position
				local local_position = self[scenegraph_id].local_position
				local scenegraph_id_2 = arg_56_2.deus_background_bottom.scenegraph_id
				local position_2 = arg_56_1[scenegraph_id_2].position
				local local_position_2 = self[scenegraph_id_2].local_position
				local background_center = arg_56_2.background_center
				local scenegraph_id_3 = background_center.scenegraph_id
				local size = self[scenegraph_id_3].size
				local size_2 = arg_56_1[scenegraph_id_3].size

				size[2] = math.ceil(size_2[2] * easeOutCubic)

				local num = size_2[2] / 2
				local num_2 = size_2[2] / 82
				local uvs = background_center.content.texture_id.uvs
				local num_3 = num_2 * easeOutCubic

				uvs[1][2] = math.min(0.5 + num_3, 1)
				uvs[2][2] = math.max(0.5 - num_3, 0)
				local_position[2] = position[2] + num * easeOutCubic
				local_position_2[2] = position_2[2] - num * easeOutCubic
				arg_56_2.deus_background_top_glow.content.texture_id.uvs[2][2] = easeOutCubic

				local num_4 = 55 * easeOutCubic

				self.deus_background_top_glow.size[2] = num_4
				self.deus_background_top_glow.local_position[2] = -num_4
				arg_56_2.deus_background_bottom_glow.content.texture_id.uvs[2][2] = easeOutCubic

				local num_5 = 55 * easeOutCubic

				self.deus_background_bottom_glow.size[2] = num_5
				self.deus_background_bottom_glow.local_position[2] = num_5
			end,
			on_complete = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
				-- function 57
				return
			end
		}
	},
	deus_close = {
		{
			name = "background_collapse",
			start_progress = 0,
			end_progress = 0.15,
			init = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
				-- function 58
				return
			end,
			update = function (self, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
				-- function 59
				local easeInCubic = math.easeInCubic(arg_59_3)
				local num = 1 - math.easeInCubic(arg_59_3)
				local scenegraph_id = arg_59_2.deus_background_top.scenegraph_id
				local position = arg_59_1[scenegraph_id].position
				local local_position = self[scenegraph_id].local_position
				local scenegraph_id_2 = arg_59_2.deus_background_bottom.scenegraph_id
				local position_2 = arg_59_1[scenegraph_id_2].position
				local local_position_2 = self[scenegraph_id_2].local_position
				local background_center = arg_59_2.background_center
				local scenegraph_id_3 = background_center.scenegraph_id
				local size = self[scenegraph_id_3].size
				local size_2 = arg_59_1[scenegraph_id_3].size

				size[2] = math.ceil(size_2[2] - size_2[2] * easeInCubic)

				local num_2 = size_2[2] / 2
				local num_3 = size_2[2] / 82
				local uvs = background_center.content.texture_id.uvs
				local num_4 = num_3 * num

				uvs[1][2] = math.min(0.5 + num_4, 1)
				uvs[2][2] = math.max(0.5 - num_4, 0)
				local_position[2] = position[2] + num_2 - num_2 * easeInCubic
				local_position_2[2] = position_2[2] - num_2 + num_2 * easeInCubic
				arg_59_2.deus_background_top_glow.content.texture_id.uvs[2][2] = num

				local num_5 = 55 * num

				self.deus_background_top_glow.size[2] = num_5
				self.deus_background_top_glow.local_position[2] = -num_5
				arg_59_2.deus_background_bottom_glow.content.texture_id.uvs[2][2] = num

				local num_6 = 55 * num

				self.deus_background_bottom_glow.size[2] = num_6
				self.deus_background_bottom_glow.local_position[2] = num_6
			end,
			on_complete = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
				-- function 60
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
			init = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
				-- function 61
				return
			end,
			update = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
				-- function 62
				local deus_background_top = arg_62_2.deus_background_top
				local deus_background_bottom = arg_62_2.deus_background_bottom
				local background_center = arg_62_2.background_center
				local num = 255 - 255 * math.easeOutCubic(arg_62_3)

				deus_background_top.style.texture_id.color[1] = num
				deus_background_bottom.style.texture_id.color[1] = num
				background_center.style.texture_id.color[1] = num
			end,
			on_complete = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
				-- function 63
				return
			end
		}
	}
}
local tbl_8 = {
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
	animations = tbl_7,
	scenegraph_definition = tbl_2,
	widget_definitions = tbl_6,
	item_list_max_columns = num_3,
	item_list_max_rows = num_4,
	item_list_padding = num_5,
	generic_input_actions = tbl_8
}
