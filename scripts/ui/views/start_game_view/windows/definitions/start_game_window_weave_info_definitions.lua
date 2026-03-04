-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_info_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.background
local var_0_2 = var_0_0.frame
local var_0_3 = var_0_0.size
local var_0_4 = var_0_0.large_window_size
local var_0_5 = "menu_frame_11"
local var_0_6 = UIFrameSettings[var_0_5].texture_sizes.vertical[1]
local var_0_7 = {
	var_0_4[1] - (600 + var_0_6 * 2),
	var_0_4[2] - var_0_6 * 2
}
local var_0_8 = var_0_7[1] - var_0_6 * 2
local var_0_9 = var_0_7[1] - 20
local var_0_10 = {
	var_0_7[1],
	194
}
local var_0_11 = 1.5
local var_0_12 = {
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
	parent_window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = var_0_4,
		position = {
			0,
			0,
			1
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "parent_window",
		horizontal_alignment = "right",
		size = var_0_7,
		position = {
			-var_0_6,
			0,
			1
		}
	},
	top_panel = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_7[1],
			84
		},
		position = {
			0,
			0,
			6
		}
	},
	title = {
		vertical_alignment = "bottom",
		parent = "top_panel",
		horizontal_alignment = "center",
		size = {
			var_0_8,
			50
		},
		position = {
			0,
			-75,
			6
		}
	},
	wind_title = {
		vertical_alignment = "bottom",
		parent = "title",
		horizontal_alignment = "center",
		size = {
			var_0_8 - 10,
			40
		},
		position = {
			0,
			-35,
			3
		}
	},
	level_title = {
		vertical_alignment = "bottom",
		parent = "wind_title",
		horizontal_alignment = "center",
		size = {
			var_0_8 - 10,
			40
		},
		position = {
			0,
			-40,
			2
		}
	},
	wind_icon = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			200,
			200
		},
		position = {
			0,
			120,
			2
		}
	},
	wind_icon_bg_glow = {
		vertical_alignment = "center",
		parent = "wind_icon",
		horizontal_alignment = "center",
		size = {
			250,
			250
		},
		position = {
			0,
			0,
			-1
		}
	},
	mutator_window = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			350,
			300
		},
		position = {
			130,
			140,
			8
		}
	},
	mutator_title_text = {
		vertical_alignment = "top",
		parent = "mutator_window",
		horizontal_alignment = "left",
		size = {
			350,
			50
		},
		position = {
			0,
			-5,
			1
		}
	},
	mutator_description_text = {
		vertical_alignment = "top",
		parent = "mutator_title_text",
		horizontal_alignment = "left",
		size = {
			350,
			255
		},
		position = {
			0,
			-40,
			1
		}
	},
	mutator_icon = {
		vertical_alignment = "top",
		parent = "mutator_description_text",
		horizontal_alignment = "left",
		size = {
			40,
			40
		},
		position = {
			-50,
			0,
			5
		}
	},
	objective_window = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			350,
			300
		},
		position = {
			-70,
			140,
			8
		}
	},
	objective_title_text = {
		vertical_alignment = "top",
		parent = "objective_window",
		horizontal_alignment = "left",
		size = {
			350,
			50
		},
		position = {
			0,
			-5,
			1
		}
	},
	objective_description_text = {
		vertical_alignment = "top",
		parent = "objective_title_text",
		horizontal_alignment = "left",
		size = {
			350,
			50
		},
		position = {
			0,
			-40,
			1
		}
	},
	objective = {
		vertical_alignment = "bottom",
		parent = "objective_description_text",
		horizontal_alignment = "center",
		size = {
			350,
			30
		},
		position = {
			0,
			-35,
			3
		}
	},
	play_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			400,
			72
		},
		position = {
			0,
			18,
			20
		}
	},
	play_button_console = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_10[1],
			var_0_10[2]
		},
		position = {
			0,
			-0,
			1
		}
	},
	private_checkbox = {
		vertical_alignment = "top",
		parent = "play_button",
		horizontal_alignment = "left",
		size = {
			400,
			40
		},
		position = {
			200,
			45,
			0
		}
	}
}
local var_0_13 = {
	word_wrap = true,
	upper_case = true,
	localize = true,
	use_shadow = true,
	font_size = 42,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_14 = {
	font_size = 36,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		10,
		0,
		2
	}
}
local var_0_15 = {
	font_size = 32,
	upper_case = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_16 = {
	font_size = 26,
	upper_case = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_17 = {
	font_size = 28,
	upper_case = true,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		-10,
		0,
		2
	}
}
local var_0_18 = {
	font_size = 26,
	upper_case = false,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_19 = {
	font_size = 32,
	upper_case = false,
	localize = true,
	use_shadow = true,
	word_wrap = true,
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
local var_0_20 = {
	font_size = 32,
	upper_case = false,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_21 = {
	font_size = 20,
	use_shadow = true,
	localize = true,
	dynamic_font_size_word_wrap = true,
	word_wrap = true,
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

local function var_0_22(arg_1_0, arg_1_1)
	return {
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture"
				},
				{
					texture_id = "icon",
					style_id = "icon",
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
			text = "-",
			title_text = "title_text",
			background = "chest_upgrade_fill_glow",
			icon = "trial_gem"
		},
		style = {
			background = {
				color = {
					0,
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
			icon = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				texture_size = {
					49,
					44
				},
				color = Colors.get_color_table_with_alpha("white", 255),
				default_offset = {
					-25,
					-2,
					1
				},
				offset = {
					0,
					0,
					1
				}
			},
			title_text = {
				word_wrap = true,
				localize = true,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					arg_1_1[1] - 50,
					arg_1_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				offset = {
					0,
					0,
					2
				}
			},
			title_text_shadow = {
				word_wrap = true,
				localize = true,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font_size = true,
				font_type = "hell_shark_header",
				size = {
					arg_1_1[1] - 50,
					arg_1_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					1
				}
			},
			text = {
				word_wrap = true,
				font_size = 26,
				localize = true,
				dynamic_font_size_word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					-30,
					2
				}
			},
			text_shadow = {
				word_wrap = true,
				font_size = 26,
				localize = true,
				dynamic_font_size_word_wrap = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-32,
					1
				}
			}
		},
		offset = {
			50,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local function var_0_23(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = {
		element = {}
	}
	local var_2_1 = {}
	local var_2_2 = {}
	local var_2_3 = {}
	local var_2_4 = "button_hotspot"

	var_2_1[#var_2_1 + 1] = {
		pass_type = "hotspot",
		content_id = var_2_4,
		style_id = var_2_4
	}
	var_2_3[var_2_4] = {
		size = arg_2_1,
		offset = {
			0,
			0,
			0
		}
	}
	var_2_2.disable_with_gamepad = arg_2_5
	var_2_2[var_2_4] = {}

	local var_2_5 = var_2_2[var_2_4]

	if arg_2_4 then
		local var_2_6 = "additional_option_info"

		var_2_1[#var_2_1 + 1] = {
			pass_type = "additional_option_tooltip",
			content_id = var_2_4,
			style_id = var_2_6,
			additional_option_id = var_2_6,
			content_check_function = function (arg_3_0)
				return arg_3_0.is_hover
			end
		}
		var_2_3[var_2_6] = {
			vertical_alignment = "top",
			max_width = 400,
			horizontal_alignment = "center",
			offset = {
				0,
				0,
				0
			}
		}
		var_2_5[var_2_6] = arg_2_4
	end

	local var_2_7 = "text"

	var_2_1[#var_2_1 + 1] = {
		pass_type = "text",
		content_id = var_2_4,
		text_id = var_2_7,
		style_id = var_2_7,
		content_check_function = function (arg_4_0)
			return not arg_4_0.disable_button
		end
	}

	local var_2_8 = 40

	var_2_3[var_2_7] = {
		word_wrap = true,
		font_size = 22,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		select_text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			var_2_8,
			3,
			4
		},
		size = arg_2_1
	}
	var_2_5[var_2_7] = arg_2_2

	local var_2_9 = "text_disabled"

	var_2_1[#var_2_1 + 1] = {
		pass_type = "text",
		content_id = var_2_4,
		text_id = var_2_7,
		style_id = var_2_9,
		content_check_function = function (arg_5_0)
			return arg_5_0.disable_button
		end
	}
	var_2_3[var_2_9] = {
		horizontal_alignment = "left",
		font_size = 22,
		word_wrap = true,
		vertical_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("gray", 255),
		default_text_color = Colors.get_color_table_with_alpha("gray", 255),
		offset = {
			var_2_8,
			3,
			4
		},
		size = arg_2_1
	}

	local var_2_10 = "text_shadow"

	var_2_1[#var_2_1 + 1] = {
		pass_type = "text",
		content_id = var_2_4,
		text_id = var_2_7,
		style_id = var_2_10
	}
	var_2_3[var_2_10] = {
		vertical_alignment = "center",
		font_size = 22,
		horizontal_alignment = "left",
		word_wrap = true,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			var_2_8 + 2,
			1,
			3
		},
		size = arg_2_1
	}

	local var_2_11 = "checkbox_background"

	var_2_1[#var_2_1 + 1] = {
		pass_type = "rect",
		style_id = var_2_11
	}

	local var_2_12 = {
		25,
		25
	}
	local var_2_13 = {
		0,
		arg_2_1[2] / 2 - var_2_12[2] / 2 + 2,
		3
	}

	var_2_3[var_2_11] = {
		size = {
			var_2_12[1],
			var_2_12[2]
		},
		offset = var_2_13,
		color = {
			255,
			0,
			0,
			0
		}
	}

	local var_2_14 = "checkbox_frame"

	var_2_1[#var_2_1 + 1] = {
		pass_type = "texture_frame",
		content_id = var_2_4,
		texture_id = var_2_14,
		style_id = var_2_14,
		content_check_function = function (arg_6_0)
			return not arg_6_0.is_disabled
		end
	}

	local var_2_15 = UIFrameSettings.menu_frame_06

	var_2_5[var_2_14] = var_2_15.texture
	var_2_3[var_2_14] = {
		size = {
			var_2_12[1],
			var_2_12[2]
		},
		texture_size = var_2_15.texture_size,
		texture_sizes = var_2_15.texture_sizes,
		offset = {
			var_2_13[1],
			var_2_13[2],
			var_2_13[3] + 1
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	local var_2_16 = "checkbox_frame_disabled"

	var_2_1[#var_2_1 + 1] = {
		pass_type = "texture_frame",
		content_id = var_2_4,
		texture_id = var_2_14,
		style_id = var_2_16,
		content_check_function = function (arg_7_0)
			return not arg_7_0.is_disabled
		end
	}
	var_2_3[var_2_16] = {
		size = {
			var_2_12[1],
			var_2_12[2]
		},
		texture_size = var_2_15.texture_size,
		texture_sizes = var_2_15.texture_sizes,
		offset = {
			var_2_13[1],
			var_2_13[2],
			var_2_13[3] + 1
		},
		color = {
			96,
			255,
			255,
			255
		}
	}

	local var_2_17 = "checkbox_marker"

	var_2_1[#var_2_1 + 1] = {
		pass_type = "texture",
		content_id = var_2_4,
		texture_id = var_2_17,
		style_id = var_2_17,
		content_check_function = function (arg_8_0)
			return arg_8_0.is_selected and not arg_8_0.disable_button
		end
	}
	var_2_5[var_2_17] = "matchmaking_checkbox"

	local var_2_18 = {
		22,
		16
	}
	local var_2_19 = {
		var_2_13[1] + 4,
		var_2_13[2] + var_2_18[2] / 2 - 1,
		var_2_13[3] + 2
	}

	var_2_3[var_2_17] = {
		size = var_2_18,
		offset = var_2_19,
		color = Colors.get_color_table_with_alpha("white", 255)
	}

	local var_2_20 = "checkbox_marker_disabled"

	var_2_1[#var_2_1 + 1] = {
		pass_type = "texture",
		content_id = var_2_4,
		texture_id = var_2_17,
		style_id = var_2_20,
		content_check_function = function (arg_9_0)
			return arg_9_0.is_selected and arg_9_0.disable_button
		end
	}
	var_2_3[var_2_20] = {
		size = var_2_18,
		offset = var_2_19,
		color = Colors.get_color_table_with_alpha("gray", 255)
	}
	var_2_0.element.passes = var_2_1
	var_2_0.content = var_2_2
	var_2_0.style = var_2_3
	var_2_0.offset = {
		0,
		0,
		0
	}
	var_2_0.scenegraph_id = arg_2_0

	return var_2_0
end

local function var_0_24(arg_10_0, arg_10_1)
	return {
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture",
					content_check_function = function (arg_11_0)
						return not arg_11_0.occupied
					end
				},
				{
					texture_id = "player_icon",
					style_id = "player_icon",
					pass_type = "texture",
					content_check_function = function (arg_12_0)
						return arg_12_0.occupied
					end
				},
				{
					style_id = "search_icon",
					pass_type = "rotated_texture",
					texture_id = "search_icon",
					content_check_function = function (arg_13_0)
						return not arg_13_0.occupied and arg_13_0.searching
					end,
					content_change_function = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
						local var_14_0 = ((arg_14_1.progress or 0) + arg_14_3) % 1

						arg_14_1.angle = math.pow(2, math.smoothstep(var_14_0, 0, 1)) * (math.pi * 2)
						arg_14_1.progress = var_14_0
					end
				},
				{
					texture_id = "empty_icon",
					style_id = "empty_icon",
					pass_type = "texture",
					content_check_function = function (arg_15_0)
						return not arg_15_0.occupied and not arg_15_0.searching
					end
				}
			}
		},
		content = {
			searching = false,
			empty_icon = "friends_icon_profile",
			occupied = false,
			search_icon = "friends_icon_refresh",
			background = "small_unit_frame_portrait_default",
			player_icon = "small_unit_frame_portrait_default"
		},
		style = {
			background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_10_1,
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					0
				}
			},
			player_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = arg_10_1,
				color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					2
				}
			},
			empty_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					32,
					32
				},
				color = {
					255,
					120,
					120,
					120
				},
				offset = {
					0,
					5,
					1
				}
			},
			search_icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				angle = 0,
				pivot = {
					16,
					16
				},
				texture_size = {
					32,
					32
				},
				color = {
					255,
					120,
					120,
					120
				},
				offset = {
					0,
					0,
					3
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

function create_tooltip_button(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9, arg_16_10, arg_16_11)
	arg_16_3 = arg_16_3 or "button_bg_01"

	local var_16_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_16_3)
	local var_16_1 = arg_16_2 and UIFrameSettings[arg_16_2] or UIFrameSettings.button_frame_01
	local var_16_2 = var_16_1.texture_sizes.corner[1]
	local var_16_3 = arg_16_7 or "button_detail_01"
	local var_16_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_16_3).size

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "hover_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
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
					pass_type = "rect",
					style_id = "clicked_rect"
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (arg_17_0)
						return arg_17_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail"
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail"
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_18_0)
						return not arg_18_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_19_0)
						return arg_19_0.button_hotspot.disable_button
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
				},
				{
					additional_option_id = "find_party_tooltip",
					style_id = "find_party_tooltip",
					pass_type = "additional_option_tooltip",
					content_id = "hover_hotspot",
					content_check_function = function (arg_20_0)
						local var_20_0 = arg_20_0.parent.button_hotspot

						return arg_20_0.is_hover and not var_20_0.disable_button and not Managers.matchmaking:is_game_matchmaking()
					end
				},
				{
					additional_option_id = "find_party_disabled_tooltip",
					style_id = "find_party_disabled_tooltip",
					pass_type = "additional_option_tooltip",
					content_id = "hover_hotspot",
					content_check_function = function (arg_21_0)
						local var_21_0 = arg_21_0.parent.button_hotspot

						return arg_21_0.is_hover and var_21_0.disable_button
					end
				}
			}
		},
		content = {
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
				texture_id = var_16_3
			},
			button_hotspot = {},
			hover_hotspot = {
				find_party_disabled_tooltip = arg_16_11,
				find_party_tooltip = arg_16_10
			},
			title_text = arg_16_4 or "n/a",
			frame = var_16_1.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_16_1[2] / var_16_0.size[2]
					},
					{
						arg_16_1[1] / var_16_0.size[1],
						1
					}
				},
				texture_id = arg_16_3
			},
			disable_with_gamepad = arg_16_9
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
					var_16_2,
					var_16_2 - 2,
					2
				},
				size = {
					arg_16_1[1] - var_16_2 * 2,
					arg_16_1[2] - var_16_2 * 2
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
					var_16_2 - 2,
					3
				},
				size = {
					arg_16_1[1],
					math.min(arg_16_1[2] - 5, 80)
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
				font_size = arg_16_5 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_16_1[1] - 40,
					arg_16_1[2]
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
				font_size = arg_16_5 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				size = {
					arg_16_1[1] - 40,
					arg_16_1[2]
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
				font_size = arg_16_5 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					arg_16_1[1] - 40,
					arg_16_1[2]
				},
				offset = {
					22,
					-2,
					5
				}
			},
			frame = {
				texture_size = var_16_1.texture_size,
				texture_sizes = var_16_1.texture_sizes,
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
					arg_16_1[2] - (var_16_2 + 11),
					4
				},
				size = {
					arg_16_1[1],
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
					var_16_2 - 9,
					4
				},
				size = {
					arg_16_1[1],
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
					arg_16_8 and -arg_16_8 or -9,
					arg_16_1[2] / 2 - var_16_4[2] / 2,
					9
				},
				size = {
					var_16_4[1],
					var_16_4[2]
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
					arg_16_1[1] - var_16_4[1] + (arg_16_8 or 9),
					arg_16_1[2] / 2 - var_16_4[2] / 2,
					9
				},
				size = {
					var_16_4[1],
					var_16_4[2]
				}
			},
			find_party_tooltip = {
				grow_downwards = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				max_width = 400,
				offset = {
					0,
					-14,
					0
				}
			},
			find_party_disabled_tooltip = {
				grow_downwards = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				max_width = 400,
				offset = {
					0,
					-14,
					0
				}
			}
		},
		scenegraph_id = arg_16_0,
		offset = {
			0,
			0,
			0
		}
	}
end

function create_play_button(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	local var_22_0
	local var_22_1 = "green"

	if var_22_1 then
		var_22_0 = "button_" .. var_22_1
	else
		var_22_0 = "button_normal"
	end

	local var_22_2 = Colors.get_color_table_with_alpha(var_22_0, 255)
	local var_22_3 = "button_bg_01"
	local var_22_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_22_3)
	local var_22_5 = UIFrameSettings.menu_frame_08
	local var_22_6 = "button_detail_05_glow"
	local var_22_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_22_6).size

	return {
		element = {
			passes = {
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "frame",
					pass_type = "hotspot",
					content_id = "hover_hotspot"
				},
				{
					texture_id = "frame",
					style_id = "frame",
					pass_type = "texture_frame"
				},
				{
					style_id = "background",
					pass_type = "texture_uv",
					content_id = "background"
				},
				{
					style_id = "clicked_rect",
					pass_type = "rect",
					content_check_function = function (arg_23_0)
						local var_23_0 = arg_23_0.button_hotspot.is_clicked

						return not var_23_0 or var_23_0 == 0
					end
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (arg_24_0)
						return arg_24_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_right",
					style_id = "side_detail_right",
					pass_type = "texture",
					content_check_function = function (arg_25_0)
						return not arg_25_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_left",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_check_function = function (arg_26_0)
						return not arg_26_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_right",
					style_id = "side_detail_right_disabled",
					pass_type = "texture",
					content_check_function = function (arg_27_0)
						return arg_27_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_left",
					style_id = "side_detail_left_disabled",
					pass_type = "texture",
					content_check_function = function (arg_28_0)
						return arg_28_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_glow_right",
					pass_type = "texture_uv",
					content_id = "side_detail_glow",
					content_check_function = function (arg_29_0)
						return not arg_29_0.parent.button_hotspot.disable_button
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_glow_left",
					pass_type = "texture",
					content_id = "side_detail_glow",
					content_check_function = function (arg_30_0)
						return not arg_30_0.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_31_0)
						return not arg_31_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (arg_32_0)
						return arg_32_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_shadow",
					pass_type = "text",
					text_id = "title_text"
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
					texture_id = "effect",
					style_id = "effect",
					pass_type = "texture",
					content_check_function = function (arg_33_0)
						return not arg_33_0.button_hotspot.disable_button
					end
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (arg_34_0)
						local var_34_0 = arg_34_0.button_hotspot

						return not var_34_0.disable_button and (var_34_0.is_selected or var_34_0.is_hover)
					end
				},
				{
					additional_option_id = "cancel_matchmaking_tooltip",
					style_id = "cancel_matchmaking_tooltip",
					pass_type = "additional_option_tooltip",
					content_id = "hover_hotspot",
					content_check_function = function (arg_35_0)
						local var_35_0 = arg_35_0.parent.button_hotspot

						return arg_35_0.is_hover and var_35_0.disable_button
					end
				}
			}
		},
		content = {
			side_detail_right = "button_detail_05_right",
			effect = "play_button_passive_glow",
			hover_glow = "button_state_hover_green",
			side_detail_left = "button_detail_05_left",
			glow = "button_state_normal_green",
			glass_top = "button_glass_01",
			side_detail_glow = {
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
				texture_id = var_22_6
			},
			button_hotspot = {},
			hover_hotspot = {
				cancel_matchmaking_tooltip = arg_22_5
			},
			title_text = arg_22_2 or "n/a",
			frame = var_22_5.texture,
			disable_with_gamepad = arg_22_4,
			background = {
				uvs = {
					{
						0,
						1 - arg_22_1[2] / var_22_4.size[2]
					},
					{
						arg_22_1[1] / var_22_4.size[1],
						1
					}
				},
				texture_id = var_22_3
			}
		},
		style = {
			background = {
				color = var_22_2,
				offset = {
					0,
					0,
					0
				},
				size = {
					arg_22_1[1],
					arg_22_1[2]
				}
			},
			clicked_rect = {
				color = {
					100,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					7
				},
				size = {
					arg_22_1[1],
					arg_22_1[2]
				}
			},
			disabled_rect = {
				color = {
					150,
					5,
					5,
					5
				},
				offset = {
					0,
					0,
					7
				},
				size = {
					arg_22_1[1],
					arg_22_1[2]
				}
			},
			title_text = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_22_3 or 24,
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					9
				},
				size = {
					arg_22_1[1],
					arg_22_1[2]
				}
			},
			title_text_disabled = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_22_3 or 24,
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				offset = {
					0,
					0,
					9
				},
				size = {
					arg_22_1[1],
					arg_22_1[2]
				}
			},
			title_text_shadow = {
				upper_case = true,
				word_wrap = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = arg_22_3 or 24,
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					2,
					-2,
					8
				},
				size = {
					arg_22_1[1],
					arg_22_1[2]
				}
			},
			frame = {
				texture_size = var_22_5.texture_size,
				texture_sizes = var_22_5.texture_sizes,
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
				},
				size = {
					arg_22_1[1],
					arg_22_1[2]
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
					var_22_5.texture_sizes.horizontal[2],
					1
				},
				size = {
					arg_22_1[1],
					math.min(60, arg_22_1[2] - var_22_5.texture_sizes.horizontal[2] * 2)
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
					arg_22_1[2] - var_22_5.texture_sizes.horizontal[2] - 4,
					6
				},
				size = {
					arg_22_1[1],
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
					var_22_5.texture_sizes.horizontal[2] - 1,
					3
				},
				size = {
					arg_22_1[1],
					math.min(60, arg_22_1[2] - var_22_5.texture_sizes.horizontal[2] * 2)
				}
			},
			effect = {
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
				},
				size = {
					arg_22_1[1],
					arg_22_1[2]
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
					0,
					arg_22_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
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
					arg_22_1[1] - 88,
					arg_22_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_left_disabled = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					0,
					arg_22_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_right_disabled = {
				color = {
					255,
					200,
					200,
					200
				},
				offset = {
					arg_22_1[1] - 88,
					arg_22_1[2] / 2 - 36,
					9
				},
				size = {
					88,
					72
				}
			},
			side_detail_glow_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_22_1[2] / 2 - var_22_7[2] / 2,
					10
				},
				size = {
					var_22_7[1],
					var_22_7[2]
				}
			},
			side_detail_glow_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_22_1[1] - var_22_7[1],
					arg_22_1[2] / 2 - var_22_7[2] / 2,
					10
				},
				size = {
					var_22_7[1],
					var_22_7[2]
				}
			},
			cancel_matchmaking_tooltip = {
				vertical_alignment = "top",
				max_width = 400,
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					0
				}
			}
		},
		scenegraph_id = arg_22_0,
		offset = {
			0,
			0,
			0
		}
	}
end

function create_start_game_console_play_button(arg_36_0, arg_36_1)
	local var_36_0 = {}
	local var_36_1 = {}
	local var_36_2 = {}
	local var_36_3 = "text"
	local var_36_4 = var_36_3 .. "_shadow"

	var_36_0[#var_36_0 + 1] = {
		pass_type = "text",
		text_id = var_36_3,
		style_id = var_36_3,
		content_change_function = function (arg_37_0, arg_37_1)
			if arg_37_0.locked then
				arg_37_1.text_color = arg_37_1.disabled_color
			else
				arg_37_1.text_color = arg_37_1.normal_color
			end
		end
	}
	var_36_0[#var_36_0 + 1] = {
		pass_type = "text",
		text_id = var_36_3,
		style_id = var_36_4
	}
	var_36_1[var_36_3] = arg_36_1

	local var_36_5 = {
		0,
		6,
		1
	}
	local var_36_6 = {
		word_wrap = false,
		upper_case = true,
		localize = false,
		font_size = 48,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("white", 255),
		disabled_color = Colors.get_color_table_with_alpha("dark_gray", 255),
		normal_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			var_36_5[1],
			var_36_5[2],
			var_36_5[3]
		}
	}
	local var_36_7 = table.clone(var_36_6)

	var_36_7.text_color = {
		255,
		0,
		0,
		0
	}
	var_36_7.offset = {
		var_36_5[1] + 2,
		var_36_5[2] - 2,
		var_36_5[3] - 1
	}
	var_36_2[var_36_3] = var_36_6
	var_36_2[var_36_4] = var_36_7

	local var_36_8 = "divider"

	var_36_0[#var_36_0 + 1] = {
		pass_type = "texture",
		texture_id = var_36_8,
		style_id = var_36_8
	}
	var_36_1[var_36_8] = "divider_01_top"
	var_36_2[var_36_8] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			264,
			32
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			-36,
			1
		}
	}

	local var_36_9 = "input_texture"

	var_36_0[#var_36_0 + 1] = {
		pass_type = "texture",
		texture_id = var_36_9,
		style_id = var_36_9,
		content_change_function = function (arg_38_0, arg_38_1)
			if arg_38_0.locked then
				arg_38_1.saturated = true
			else
				arg_38_1.saturated = false
			end
		end
	}
	var_36_1[var_36_9] = ""
	var_36_2[var_36_9] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			64,
			64
		},
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			0,
			-34,
			2
		}
	}

	local var_36_10 = "glow"

	var_36_0[#var_36_0 + 1] = {
		pass_type = "texture",
		texture_id = var_36_10,
		style_id = var_36_10,
		content_check_function = function (arg_39_0)
			return not arg_39_0.locked
		end
	}
	var_36_1[var_36_10] = "play_glow_mask"
	var_36_2[var_36_10] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		texture_size = {
			256,
			126
		},
		color = Colors.get_color_table_with_alpha("font_title", 255),
		offset = {
			0,
			33,
			-1
		}
	}

	return {
		element = {
			passes = var_36_0
		},
		content = var_36_1,
		style = var_36_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_36_0
	}
end

local var_0_25 = true
local var_0_26 = {
	difficulty_title = UIWidgets.create_simple_text("n/a", "difficulty_title", nil, nil, difficulty_title_text_style),
	difficulty_description = UIWidgets.create_simple_text("n/a", "difficulty_description", nil, nil, difficulty_description_text_style),
	difficulty_selected = UIWidgets.create_simple_texture("icons_placeholder", "difficulty_selected"),
	difficulty_selected_effect = UIWidgets.create_simple_texture("weave_difficulty_highlight_effect", "difficulty_selected_effect", nil, nil, {
		255,
		138,
		0,
		187
	}),
	play_button = create_play_button("play_button", var_0_12.play_button.size, Localize("start_game_window_play"), 34, var_0_25, {
		title = Localize("start_game_weave_disabled_tooltip_title"),
		description = Localize("start_game_weave_disabled_tooltip_description")
	}, var_0_25),
	play_button_console = create_start_game_console_play_button("play_button_console", Localize("start_game_window_play"))
}
local var_0_27 = {
	wind_icon = UIWidgets.create_simple_texture("weave_menu_wind_icon", "wind_icon")
}
local var_0_28 = {}
local var_0_29 = true
local var_0_30 = {
	play_button = create_play_button("play_button", var_0_12.play_button.size, Localize("start_game_window_play"), 34, var_0_29, {
		title = Localize("start_game_weave_disabled_tooltip_title"),
		description = Localize("start_game_weave_disabled_tooltip_description")
	}),
	play_button_console = create_start_game_console_play_button("play_button_console", Localize("start_game_window_play")),
	title = UIWidgets.create_simple_text("n/a", "title", nil, nil, var_0_13),
	mutator_icon = UIWidgets.create_simple_texture("icons_placeholder", "mutator_icon"),
	mutator_title_text = UIWidgets.create_simple_text("n/a", "mutator_title_text", nil, nil, var_0_20),
	mutator_description_text = UIWidgets.create_simple_text("n/a", "mutator_description_text", nil, nil, var_0_21),
	wind_title = UIWidgets.create_simple_text("n/a", "wind_title", nil, nil, var_0_19),
	level_title = UIWidgets.create_simple_text("n/a", "level_title", nil, nil, var_0_18),
	private_checkbox = var_0_23("private_checkbox", var_0_12.private_checkbox.size, Localize("start_game_window_disallow_join"), 24, {
		title = Localize("start_game_window_disallow_join"),
		description = Localize("start_game_window_disallow_join_description")
	}),
	objective_title_text = UIWidgets.create_simple_text(Localize("weave_objective_title"), "objective_title_text", nil, nil, var_0_15),
	objective_description_text = UIWidgets.create_simple_text(Localize("menu_weave_play_objective_sub_title"), "objective_description_text", nil, nil, var_0_16)
}
local var_0_31 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				arg_40_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				local var_41_0 = math.easeInCubic(arg_41_3)

				arg_41_4.render_settings.alpha_multiplier = var_41_0
			end,
			on_complete = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				arg_43_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				local var_44_0 = math.easeOutCubic(arg_44_3)

				arg_44_4.render_settings.alpha_multiplier = 1 - var_44_0
			end,
			on_complete = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				return
			end
		}
	}
}

return {
	top_widgets = var_0_30,
	bottom_widgets = var_0_28,
	bottom_hdr_widgets = var_0_27,
	create_objective_widget = var_0_22,
	scenegraph_definition = var_0_12,
	animation_definitions = var_0_31
}
