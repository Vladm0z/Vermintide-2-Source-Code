-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_info_definitions.lua

local game_start_windows = UISettings.game_start_windows
local background = game_start_windows.background
local frame = game_start_windows.frame
local size = game_start_windows.size
local large_window_size = game_start_windows.large_window_size
local str = "menu_frame_11"
local var_0_6 = UIFrameSettings[str].texture_sizes.vertical[1]
local tbl = {
	large_window_size[1] - (600 + var_0_6 * 2),
	large_window_size[2] - var_0_6 * 2
}
local num = tbl[1] - var_0_6 * 2
local num_2 = tbl[1] - 20
local tbl_2 = {
	tbl[1],
	194
}
local num_3 = 1.5
local tbl_3 = {
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
		size = large_window_size,
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
		size = tbl,
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
			tbl[1],
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
			num,
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
			num - 10,
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
			num - 10,
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
			tbl_2[1],
			tbl_2[2]
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
local tbl_4 = {
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
local tbl_5 = {
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
local tbl_6 = {
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
local tbl_7 = {
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
local tbl_8 = {
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
local tbl_9 = {
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
local tbl_10 = {
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
local tbl_11 = {
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
local tbl_12 = {
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

local function fn(arg_1_0, arg_1_1)
	-- function 1
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

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local str = "button_hotspot"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "hotspot",
		content_id = str,
		style_id = str
	}
	tbl_4[str] = {
		size = arg_2_1,
		offset = {
			0,
			0,
			0
		}
	}
	tbl_3.disable_with_gamepad = arg_2_5
	tbl_3[str] = {}

	local var_2_5 = tbl_3[str]

	if not arg_2_4 then
		local str_2 = "additional_option_info"

		tbl_2[#tbl_2 + 1] = {
			pass_type = "additional_option_tooltip",
			content_id = str,
			style_id = str_2,
			additional_option_id = str_2,
			content_check_function = function (self)
				-- function 3
				return self.is_hover
			end
		}
		tbl_4[str_2] = {
			vertical_alignment = "top",
			max_width = 400,
			horizontal_alignment = "center",
			offset = {
				0,
				0,
				0
			}
		}
		var_2_5[str_2] = arg_2_4
	end

	local str_3 = "text"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str,
		text_id = str_3,
		style_id = str_3,
		content_check_function = function (self)
			-- function 4
			return not self.disable_button
		end
	}

	local num = 40

	tbl_4[str_3] = {
		word_wrap = true,
		font_size = 22,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
		select_text_color = Colors.get_color_table_with_alpha("white", 255),
		offset = {
			num,
			3,
			4
		},
		size = arg_2_1
	}
	var_2_5[str_3] = arg_2_2

	local str_4 = "text_disabled"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str,
		text_id = str_3,
		style_id = str_4,
		content_check_function = function (self)
			-- function 5
			return self.disable_button
		end
	}
	tbl_4[str_4] = {
		horizontal_alignment = "left",
		font_size = 22,
		word_wrap = true,
		vertical_alignment = "center",
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("gray", 255),
		default_text_color = Colors.get_color_table_with_alpha("gray", 255),
		offset = {
			num,
			3,
			4
		},
		size = arg_2_1
	}

	local str_5 = "text_shadow"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "text",
		content_id = str,
		text_id = str_3,
		style_id = str_5
	}
	tbl_4[str_5] = {
		vertical_alignment = "center",
		font_size = 22,
		horizontal_alignment = "left",
		word_wrap = true,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("black", 255),
		offset = {
			num + 2,
			1,
			3
		},
		size = arg_2_1
	}

	local str_6 = "checkbox_background"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "rect",
		style_id = str_6
	}

	local tbl_5 = {
		25,
		25
	}
	local tbl_6 = {
		0,
		arg_2_1[2] / 2 - tbl_5[2] / 2 + 2,
		3
	}

	tbl_4[str_6] = {
		size = {
			tbl_5[1],
			tbl_5[2]
		},
		offset = tbl_6,
		color = {
			255,
			0,
			0,
			0
		}
	}

	local str_7 = "checkbox_frame"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture_frame",
		content_id = str,
		texture_id = str_7,
		style_id = str_7,
		content_check_function = function (self)
			-- function 6
			return not self.is_disabled
		end
	}

	local menu_frame_06 = UIFrameSettings.menu_frame_06

	var_2_5[str_7] = menu_frame_06.texture
	tbl_4[str_7] = {
		size = {
			tbl_5[1],
			tbl_5[2]
		},
		texture_size = menu_frame_06.texture_size,
		texture_sizes = menu_frame_06.texture_sizes,
		offset = {
			tbl_6[1],
			tbl_6[2],
			tbl_6[3] + 1
		},
		color = {
			255,
			255,
			255,
			255
		}
	}

	local str_8 = "checkbox_frame_disabled"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture_frame",
		content_id = str,
		texture_id = str_7,
		style_id = str_8,
		content_check_function = function (self)
			-- function 7
			return not self.is_disabled
		end
	}
	tbl_4[str_8] = {
		size = {
			tbl_5[1],
			tbl_5[2]
		},
		texture_size = menu_frame_06.texture_size,
		texture_sizes = menu_frame_06.texture_sizes,
		offset = {
			tbl_6[1],
			tbl_6[2],
			tbl_6[3] + 1
		},
		color = {
			96,
			255,
			255,
			255
		}
	}

	local str_9 = "checkbox_marker"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str,
		texture_id = str_9,
		style_id = str_9,
		content_check_function = function (self)
			-- function 8
			local is_selected = self.is_selected

			is_selected = not is_selected and not self.disable_button

			return is_selected
		end
	}
	var_2_5[str_9] = "matchmaking_checkbox"

	local tbl_7 = {
		22,
		16
	}
	local tbl_8 = {
		tbl_6[1] + 4,
		tbl_6[2] + tbl_7[2] / 2 - 1,
		tbl_6[3] + 2
	}

	tbl_4[str_9] = {
		size = tbl_7,
		offset = tbl_8,
		color = Colors.get_color_table_with_alpha("white", 255)
	}

	local str_10 = "checkbox_marker_disabled"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		content_id = str,
		texture_id = str_9,
		style_id = str_10,
		content_check_function = function (self)
			-- function 9
			local is_selected = self.is_selected

			is_selected = not is_selected and self.disable_button

			return is_selected
		end
	}
	tbl_4[str_10] = {
		size = tbl_7,
		offset = tbl_8,
		color = Colors.get_color_table_with_alpha("gray", 255)
	}
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_2_0

	return tbl
end

local function fn_3(arg_10_0, arg_10_1)
	-- function 10
	return {
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 11
						return not self.occupied
					end
				},
				{
					texture_id = "player_icon",
					style_id = "player_icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 12
						return self.occupied
					end
				},
				{
					style_id = "search_icon",
					pass_type = "rotated_texture",
					texture_id = "search_icon",
					content_check_function = function (self)
						-- function 13
						return not not self.occupied or self.searching
					end,
					content_change_function = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
						-- function 14
						local progress = arg_14_1.progress

						progress = progress or 0

						local num = (progress + arg_14_3) % 1

						arg_14_1.angle = math.pow(2, math.smoothstep(num, 0, 1)) * (math.pi * 2)
						arg_14_1.progress = num
					end
				},
				{
					texture_id = "empty_icon",
					style_id = "empty_icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 15
						return not not self.occupied or not self.searching
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
	-- function 16
	arg_16_3 = arg_16_3 or "button_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_16_3)
	local var_16_1

	if not arg_16_2 then
		var_16_1 = UIFrameSettings[arg_16_2]

		if not var_16_1 then
			-- Nothing
		end
	end

	var_16_1 = UIFrameSettings.button_frame_01

	::label_16_0::

	local var_16_2 = var_16_1.texture_sizes.corner[1]
	local flag = arg_16_7 or "button_detail_01"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(flag).size
	local tbl = {
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
					content_check_function = function (self)
						-- function 17
						return self.button_hotspot.disable_button
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
					content_check_function = function (self)
						-- function 18
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 19
						return self.button_hotspot.disable_button
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
					content_check_function = function (self)
						-- function 20
						local button_hotspot = self.parent.button_hotspot
						local is_hover = self.is_hover

						is_hover = not is_hover and not not button_hotspot.disable_button or not Managers.matchmaking:is_game_matchmaking()

						return is_hover
					end
				},
				{
					additional_option_id = "find_party_disabled_tooltip",
					style_id = "find_party_disabled_tooltip",
					pass_type = "additional_option_tooltip",
					content_id = "hover_hotspot",
					content_check_function = function (self)
						-- function 21
						local button_hotspot = self.parent.button_hotspot
						local is_hover = self.is_hover

						is_hover = not is_hover and button_hotspot.disable_button

						return is_hover
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
				texture_id = flag
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
						1 - arg_16_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_16_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = arg_16_3
			},
			disable_with_gamepad = arg_16_9
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

	if not arg_16_8 then
		num = -arg_16_8

		if not num then
			-- Nothing
		end
	end

	num = -9

	::label_16_1::

	tbl_4[1] = num
	tbl_4[2] = arg_16_1[2] / 2 - size[2] / 2
	tbl_3.offset = tbl_4
	tbl_3.size = {
		size[1],
		size[2]
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
			arg_16_1[1] - size[1] + (arg_16_8 or 9),
			arg_16_1[2] / 2 - size[2] / 2,
			9
		},
		size = {
			size[1],
			size[2]
		}
	}
	tbl_2.find_party_tooltip = {
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
	tbl_2.find_party_disabled_tooltip = {
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
	tbl.style = tbl_2
	tbl.scenegraph_id = arg_16_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

function create_play_button(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	local var_22_0
	local str = "green"

	if not str then
		var_22_0 = "button_" .. str
	else
		var_22_0 = "button_normal"
	end

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(var_22_0, 255)
	local str_2 = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str_2)
	local menu_frame_08 = UIFrameSettings.menu_frame_08
	local str_3 = "button_detail_05_glow"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(str_3).size

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
					content_check_function = function (self)
						-- function 23
						local is_clicked = self.button_hotspot.is_clicked

						return not is_clicked and is_clicked == 0
					end
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 24
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_right",
					style_id = "side_detail_right",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 25
						return not self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_left",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 26
						return not self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_right",
					style_id = "side_detail_right_disabled",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 27
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "side_detail_left",
					style_id = "side_detail_left_disabled",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 28
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_glow_right",
					pass_type = "texture_uv",
					content_id = "side_detail_glow",
					content_check_function = function (self)
						-- function 29
						return not self.parent.button_hotspot.disable_button
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_glow_left",
					pass_type = "texture",
					content_id = "side_detail_glow",
					content_check_function = function (self)
						-- function 30
						return not self.parent.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 31
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 32
						return self.button_hotspot.disable_button
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
					content_check_function = function (self)
						-- function 33
						return not self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 34
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
					additional_option_id = "cancel_matchmaking_tooltip",
					style_id = "cancel_matchmaking_tooltip",
					pass_type = "additional_option_tooltip",
					content_id = "hover_hotspot",
					content_check_function = function (self)
						-- function 35
						local button_hotspot = self.parent.button_hotspot
						local is_hover = self.is_hover

						is_hover = not is_hover and button_hotspot.disable_button

						return is_hover
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
				texture_id = str_3
			},
			button_hotspot = {},
			hover_hotspot = {
				cancel_matchmaking_tooltip = arg_22_5
			},
			title_text = arg_22_2 or "n/a",
			frame = menu_frame_08.texture,
			disable_with_gamepad = arg_22_4,
			background = {
				uvs = {
					{
						0,
						1 - arg_22_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_22_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = str_2
			}
		},
		style = {
			background = {
				color = get_color_table_with_alpha,
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
				texture_size = menu_frame_08.texture_size,
				texture_sizes = menu_frame_08.texture_sizes,
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
					menu_frame_08.texture_sizes.horizontal[2],
					1
				},
				size = {
					arg_22_1[1],
					math.min(60, arg_22_1[2] - menu_frame_08.texture_sizes.horizontal[2] * 2)
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
					arg_22_1[2] - menu_frame_08.texture_sizes.horizontal[2] - 4,
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
					menu_frame_08.texture_sizes.horizontal[2] - 1,
					3
				},
				size = {
					arg_22_1[1],
					math.min(60, arg_22_1[2] - menu_frame_08.texture_sizes.horizontal[2] * 2)
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
					arg_22_1[2] / 2 - size[2] / 2,
					10
				},
				size = {
					size[1],
					size[2]
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
					arg_22_1[1] - size[1],
					arg_22_1[2] / 2 - size[2] / 2,
					10
				},
				size = {
					size[1],
					size[2]
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
	-- function 36
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local str = "text"
	local str_2 = str .. "_shadow"

	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str,
		style_id = str,
		content_change_function = function (self, arg_37_1)
			-- function 37
			if not self.locked then
				arg_37_1.text_color = arg_37_1.disabled_color
			else
				arg_37_1.text_color = arg_37_1.normal_color
			end
		end
	}
	tbl[#tbl + 1] = {
		pass_type = "text",
		text_id = str,
		style_id = str_2
	}
	tbl_2[str] = arg_36_1

	local tbl_4 = {
		0,
		6,
		1
	}
	local tbl_5 = {
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
			tbl_4[1],
			tbl_4[2],
			tbl_4[3]
		}
	}
	local clone = table.clone(tbl_5)

	clone.text_color = {
		255,
		0,
		0,
		0
	}
	clone.offset = {
		tbl_4[1] + 2,
		tbl_4[2] - 2,
		tbl_4[3] - 1
	}
	tbl_3[str] = tbl_5
	tbl_3[str_2] = clone

	local str_3 = "divider"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_3,
		style_id = str_3
	}
	tbl_2[str_3] = "divider_01_top"
	tbl_3[str_3] = {
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

	local str_4 = "input_texture"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_4,
		style_id = str_4,
		content_change_function = function (self, arg_38_1)
			-- function 38
			if not self.locked then
				arg_38_1.saturated = true
			else
				arg_38_1.saturated = false
			end
		end
	}
	tbl_2[str_4] = ""
	tbl_3[str_4] = {
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

	local str_5 = "glow"

	tbl[#tbl + 1] = {
		pass_type = "texture",
		texture_id = str_5,
		style_id = str_5,
		content_check_function = function (self)
			-- function 39
			return not self.locked
		end
	}
	tbl_2[str_5] = "play_glow_mask"
	tbl_3[str_5] = {
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
			passes = tbl
		},
		content = tbl_2,
		style = tbl_3,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_36_0
	}
end

local flag = true
local tbl_13 = {
	difficulty_title = UIWidgets.create_simple_text("n/a", "difficulty_title", nil, nil, difficulty_title_text_style),
	difficulty_description = UIWidgets.create_simple_text("n/a", "difficulty_description", nil, nil, difficulty_description_text_style),
	difficulty_selected = UIWidgets.create_simple_texture("icons_placeholder", "difficulty_selected"),
	difficulty_selected_effect = UIWidgets.create_simple_texture("weave_difficulty_highlight_effect", "difficulty_selected_effect", nil, nil, {
		255,
		138,
		0,
		187
	}),
	play_button = create_play_button("play_button", tbl_3.play_button.size, Localize("start_game_window_play"), 34, flag, {
		title = Localize("start_game_weave_disabled_tooltip_title"),
		description = Localize("start_game_weave_disabled_tooltip_description")
	}, flag),
	play_button_console = create_start_game_console_play_button("play_button_console", Localize("start_game_window_play"))
}
local tbl_14 = {
	wind_icon = UIWidgets.create_simple_texture("weave_menu_wind_icon", "wind_icon")
}
local tbl_15 = {}
local flag_2 = true
local tbl_16 = {
	play_button = create_play_button("play_button", tbl_3.play_button.size, Localize("start_game_window_play"), 34, flag_2, {
		title = Localize("start_game_weave_disabled_tooltip_title"),
		description = Localize("start_game_weave_disabled_tooltip_description")
	}),
	play_button_console = create_start_game_console_play_button("play_button_console", Localize("start_game_window_play")),
	title = UIWidgets.create_simple_text("n/a", "title", nil, nil, tbl_4),
	mutator_icon = UIWidgets.create_simple_texture("icons_placeholder", "mutator_icon"),
	mutator_title_text = UIWidgets.create_simple_text("n/a", "mutator_title_text", nil, nil, tbl_11),
	mutator_description_text = UIWidgets.create_simple_text("n/a", "mutator_description_text", nil, nil, tbl_12),
	wind_title = UIWidgets.create_simple_text("n/a", "wind_title", nil, nil, tbl_10),
	level_title = UIWidgets.create_simple_text("n/a", "level_title", nil, nil, tbl_9),
	private_checkbox = fn_2("private_checkbox", tbl_3.private_checkbox.size, Localize("start_game_window_disallow_join"), 24, {
		title = Localize("start_game_window_disallow_join"),
		description = Localize("start_game_window_disallow_join_description")
	}),
	objective_title_text = UIWidgets.create_simple_text(Localize("weave_objective_title"), "objective_title_text", nil, nil, tbl_6),
	objective_description_text = UIWidgets.create_simple_text(Localize("menu_weave_play_objective_sub_title"), "objective_description_text", nil, nil, tbl_7)
}
local tbl_17 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				arg_40_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				-- function 41
				local easeInCubic = math.easeInCubic(arg_41_3)

				arg_41_4.render_settings.alpha_multiplier = easeInCubic
			end,
			on_complete = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				-- function 42
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
				-- function 43
				arg_43_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				-- function 44
				local easeOutCubic = math.easeOutCubic(arg_44_3)

				arg_44_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				-- function 45
				return
			end
		}
	}
}

return {
	top_widgets = tbl_16,
	bottom_widgets = tbl_15,
	bottom_hdr_widgets = tbl_14,
	create_objective_widget = fn,
	scenegraph_definition = tbl_3,
	animation_definitions = tbl_17
}
