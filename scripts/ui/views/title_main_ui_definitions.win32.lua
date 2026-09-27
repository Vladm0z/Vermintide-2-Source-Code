-- chunkname: @scripts/ui/views/title_main_ui_definitions.win32.lua

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
			0
		}
	},
	dead_space_filler = {
		scale = "fit",
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
	screen = {
		scale = "fit",
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
	info_icon = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		position = {
			100,
			-350,
			30
		},
		size = {
			87,
			87
		}
	},
	info_icon_text = {
		vertical_alignment = "top",
		parent = "info_icon",
		horizontal_alignment = "left",
		position = {
			95,
			-15,
			0
		},
		size = {
			400,
			100
		}
	},
	background = {
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
	engage_prompt = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			10
		}
	},
	sidebar = {
		parent = "background",
		horizontal_alignment = "left",
		size = {
			544,
			1080
		},
		position = {
			-800,
			0,
			2
		}
	},
	sidebar_fade_bg = {
		parent = "sidebar",
		horizontal_alignment = "right",
		size = {
			256,
			1080
		},
		position = {
			256,
			0,
			0
		}
	},
	sidebar_mask = {
		parent = "sidebar",
		horizontal_alignment = "left",
		size = {
			1920,
			1080
		},
		position = {
			0,
			1080,
			3
		}
	},
	info_slate = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			1920,
			50
		},
		position = {
			-620,
			200,
			100
		}
	},
	game_type_tag = {
		vertical_alignment = "bottom",
		parent = "info_slate",
		horizontal_alignment = "center",
		size = {
			1920,
			50
		},
		position = {
			0,
			-50,
			0
		}
	},
	game_type_description = {
		vertical_alignment = "top",
		parent = "game_type_tag",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			-40,
			0
		}
	},
	information_text = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			600,
			62
		},
		position = {
			0,
			-375,
			2
		}
	},
	splash_video = {
		parent = "background",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			700
		}
	},
	start_screen_video = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			1
		}
	},
	start_screen_video_fade = {
		parent = "background",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			2
		}
	},
	logo = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "left",
		size = {
			682,
			383.90000000000003
		},
		position = {
			0,
			20,
			5
		}
	},
	sub_logo = {
		vertical_alignment = "bottom",
		parent = "logo",
		horizontal_alignment = "center"
	},
	legal_text = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			1400,
			300
		},
		position = {
			0,
			10,
			2
		}
	},
	game_type_text = {
		vertical_alignment = "bottom",
		parent = "change_profile_input_icon",
		horizontal_alignment = "left",
		size = {
			1200,
			50
		},
		position = {
			0,
			60,
			2
		}
	},
	user_gamertag = {
		vertical_alignment = "bottom",
		parent = "change_profile_input_icon",
		horizontal_alignment = "left",
		size = {
			1200,
			50
		},
		position = {
			0,
			35,
			2
		}
	},
	change_profile_input_icon = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "left",
		size = {
			26,
			26
		},
		position = {
			35,
			15,
			30
		}
	},
	change_profile_input_text = {
		vertical_alignment = "center",
		parent = "change_profile_input_icon",
		horizontal_alignment = "left",
		size = {
			1200,
			1
		},
		position = {
			30,
			-5,
			2
		}
	},
	update_offline_data_input_icon = {
		vertical_alignment = "bottom",
		parent = "background",
		horizontal_alignment = "left",
		size = {
			26,
			26
		},
		position = {
			250,
			15,
			30
		}
	},
	update_offline_data_input_text = {
		vertical_alignment = "center",
		parent = "update_offline_data_input_icon",
		horizontal_alignment = "left",
		size = {
			1200,
			1
		},
		position = {
			30,
			-5,
			2
		}
	},
	playgo_status = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "left",
		size = {
			1200,
			50
		},
		position = {
			35,
			-5,
			30
		}
	},
	menu_anchor_point = {
		vertical_alignment = "center",
		parent = "background",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			340,
			-100,
			4
		}
	},
	frame_top = {
		vertical_alignment = "bottom",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		size = {
			960,
			96
		},
		position = {
			0,
			0,
			7
		}
	},
	frame_bottom = {
		vertical_alignment = "top",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		size = {
			960,
			85
		},
		position = {
			0,
			-3,
			6
		}
	},
	frame_background = {
		vertical_alignment = "bottom",
		parent = "frame_bottom",
		horizontal_alignment = "center",
		size = {
			660,
			0
		},
		position = {
			0,
			83,
			-1
		}
	},
	frame_circle_glow = {
		vertical_alignment = "bottom",
		parent = "frame_bottom",
		horizontal_alignment = "center",
		size = {
			205,
			184
		},
		position = {
			4,
			-7,
			15
		}
	},
	frame_line_glow = {
		vertical_alignment = "center",
		parent = "frame_circle_glow",
		horizontal_alignment = "center",
		size = {
			730,
			26
		},
		position = {
			-4,
			-2,
			1
		}
	},
	input_icon = {
		vertical_alignment = "center",
		parent = "frame_circle_glow",
		horizontal_alignment = "center",
		size = {
			50,
			50
		},
		position = {
			-4,
			-2,
			-10
		}
	},
	lock_center = {
		vertical_alignment = "center",
		parent = "input_icon",
		horizontal_alignment = "center",
		size = {
			50,
			50
		},
		position = {
			0,
			1,
			-1
		}
	},
	lock_middle_top = {
		vertical_alignment = "bottom",
		parent = "frame_top",
		horizontal_alignment = "center",
		size = {
			50,
			50
		},
		position = {
			0,
			-29,
			2
		}
	},
	lock_middle_bottom = {
		vertical_alignment = "center",
		parent = "input_icon",
		horizontal_alignment = "center",
		size = {
			50,
			50
		},
		position = {
			0,
			1,
			-2
		}
	},
	lock_outer_top = {
		vertical_alignment = "bottom",
		parent = "frame_top",
		horizontal_alignment = "center",
		size = {
			50,
			50
		},
		position = {
			0,
			-29,
			1
		}
	},
	lock_outer_bottom = {
		vertical_alignment = "center",
		parent = "input_icon",
		horizontal_alignment = "center",
		size = {
			50,
			50
		},
		position = {
			0,
			1,
			-3
		}
	},
	selection_anchor = {
		vertical_alignment = "center",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			10
		},
		size = {
			0,
			60
		}
	},
	selection_glow_left = {
		vertical_alignment = "center",
		parent = "selection_anchor",
		horizontal_alignment = "left",
		position = {
			-98,
			0,
			10
		},
		size = {
			98,
			60
		}
	},
	selection_glow_right = {
		vertical_alignment = "center",
		parent = "selection_anchor",
		horizontal_alignment = "right",
		position = {
			98,
			0,
			10
		},
		size = {
			98,
			60
		}
	},
	online_button = {
		vertical_alignment = "center",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		position = {
			0,
			-100,
			10
		},
		size = {
			300,
			60
		}
	},
	offline_button = {
		vertical_alignment = "center",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		position = {
			0,
			-150,
			10
		},
		size = {
			300,
			60
		}
	},
	menu_option_1 = {
		vertical_alignment = "center",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		position = {
			0,
			90,
			10
		},
		size = {
			300,
			50
		}
	},
	menu_option_2 = {
		vertical_alignment = "center",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		position = {
			0,
			40,
			10
		},
		size = {
			300,
			50
		}
	},
	menu_option_3 = {
		vertical_alignment = "center",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		position = {
			0,
			-10,
			10
		},
		size = {
			300,
			50
		}
	},
	menu_option_4 = {
		vertical_alignment = "center",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		position = {
			0,
			-60,
			10
		},
		size = {
			300,
			50
		}
	},
	menu_option_5 = {
		vertical_alignment = "center",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		position = {
			0,
			-110,
			10
		},
		size = {
			300,
			50
		}
	},
	menu_option_6 = {
		vertical_alignment = "center",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		position = {
			0,
			-160,
			10
		},
		size = {
			300,
			50
		}
	},
	menu_option_7 = {
		vertical_alignment = "center",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		position = {
			0,
			-210,
			10
		},
		size = {
			300,
			50
		}
	},
	ai_benchmark = {
		vertical_alignment = "center",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		position = {
			0,
			-240,
			10
		},
		size = {
			1000,
			60
		}
	},
	ai_benchmark_cycle = {
		vertical_alignment = "center",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		position = {
			0,
			-300,
			10
		},
		size = {
			1000,
			60
		}
	},
	whitebox_combat = {
		vertical_alignment = "center",
		parent = "menu_anchor_point",
		horizontal_alignment = "center",
		position = {
			0,
			-360,
			10
		},
		size = {
			1000,
			60
		}
	},
	support_info = {
		vertical_alignment = "top",
		parent = "background",
		horizontal_alignment = "center",
		size = {
			1200,
			50
		},
		position = {
			0,
			-20,
			30
		}
	}
}
local tbl_2 = {
	font_size = 22,
	upper_case = false,
	localize = true,
	word_wrap = false,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = {
		255,
		0,
		0,
		0
	},
	offset = {
		0,
		-1,
		2
	}
}
local tbl_3 = {
	font_size = 32,
	upper_case = false,
	localize = true,
	word_wrap = false,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = {
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
}
local tbl_4 = {
	font_size = 18,
	upper_case = false,
	localize = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = {
		255,
		128,
		128,
		128
	},
	offset = {
		0,
		0,
		2
	},
	area_size = {
		600,
		300
	}
}

local function fn(arg_1_0)
	-- function 1
	local str = "hell_shark"
	local num = 52
	local tbl = {
		50,
		50
	}
	local var_1_3 = Localize("interaction_prefix_press")
	local var_1_4 = Localize("to_start_game")
	local num_2 = 10
	local num_3 = 7.5
	local var_1_7, var_1_8 = UIFontByResolution({
		font_type = str,
		font_size = num
	})
	local text_size = UIRenderer.text_size(arg_1_0, var_1_3, var_1_7[1], var_1_8)
	local text_size_2 = UIRenderer.text_size(arg_1_0, var_1_4, var_1_7[1], var_1_8)
	local num_4 = text_size + num_2 + tbl[1] + num_2 + text_size_2 + num_3
	local num_5 = -num_4 * 0.5 + text_size * 0.5
	local num_6 = -num_4 * 0.5 + tbl[1] * 0.5 + text_size + num_2 + num_3
	local num_7 = num_6 + tbl[1] * 0.5 + num_2 + text_size_2 * 0.5
	local tbl_2 = {
		scenegraph_id = "engage_prompt",
		element = {
			passes = {
				{
					style_id = "press_to_start",
					pass_type = "text",
					text_id = "press_to_start",
					content_change_function = function (arg_2_0, arg_2_1)
						-- function 2
						local time = Managers.time:time("main")
						local num = 192 + math.sin(time * 5) * 63

						arg_2_1.text_color[2] = num
						arg_2_1.text_color[3] = num
						arg_2_1.text_color[4] = num
					end,
					content_check_function = function (arg_3_0, arg_3_1)
						-- function 3
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "press",
					pass_type = "text",
					text_id = "press_str",
					content_change_function = function (arg_4_0, arg_4_1)
						-- function 4
						local time = Managers.time:time("main")
						local num = 192 + math.sin(time * 5) * 63

						arg_4_1.text_color[2] = num
						arg_4_1.text_color[3] = num
						arg_4_1.text_color[4] = num
					end,
					content_check_function = function (arg_5_0, arg_5_1)
						-- function 5
						return Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "to_start",
					pass_type = "text",
					text_id = "to_start_str",
					content_change_function = function (arg_6_0, arg_6_1)
						-- function 6
						local time = Managers.time:time("main")
						local num = 192 + math.sin(time * 5) * 63

						arg_6_1.text_color[2] = num
						arg_6_1.text_color[3] = num
						arg_6_1.text_color[4] = num
					end,
					content_check_function = function (arg_7_0, arg_7_1)
						-- function 7
						return Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "button",
					pass_type = "texture",
					texture_id = "button_id",
					content_change_function = function (arg_8_0, arg_8_1)
						-- function 8
						local time = Managers.time:time("main")
						local num = 192 + math.sin(time * 5) * 63

						arg_8_1.color[2] = num
						arg_8_1.color[3] = num
						arg_8_1.color[4] = num
					end,
					content_check_function = function (arg_9_0, arg_9_1)
						-- function 9
						return Managers.input:is_device_active("gamepad")
					end
				}
			}
		}
	}
	local tbl_3 = {
		press_to_start = "press_any_button_to_continue",
		press_str = var_1_3
	}
	local flag

	flag = not IS_PS4 and "ps4_button_icon_cross_large" and "xbone_button_icon_a_large"
	tbl_3.button_id = flag
	tbl_3.to_start_str = var_1_4
	tbl_2.content = tbl_3
	tbl_2.style = {
		press_to_start = {
			vertical_alignment = "center",
			localize = true,
			horizontal_alignment = "center",
			word_wrap = false,
			font_size = num,
			font_type = str,
			text_color = {
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
		press = {
			vertical_alignment = "center",
			localize = false,
			horizontal_alignment = "center",
			word_wrap = false,
			font_size = num,
			font_type = str,
			text_color = {
				255,
				255,
				255,
				255
			},
			offset = {
				num_5,
				0,
				0
			}
		},
		to_start = {
			vertical_alignment = "center",
			localize = false,
			horizontal_alignment = "center",
			word_wrap = false,
			font_size = num,
			font_type = str,
			text_color = {
				255,
				255,
				255,
				255
			},
			offset = {
				num_7,
				0,
				0
			}
		},
		button = {
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
				num_6,
				0,
				0
			}
		},
		rect_press = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				text_size,
				30
			},
			color = {
				255,
				255,
				0,
				0
			},
			offset = {
				num_5,
				50,
				0
			}
		},
		rect_button = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				tbl[1],
				30
			},
			color = {
				255,
				0,
				255,
				0
			},
			offset = {
				num_6,
				50,
				0
			}
		},
		rect_to_start = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				text_size_2,
				30
			},
			color = {
				255,
				0,
				0,
				255
			},
			offset = {
				num_7,
				50,
				0
			}
		},
		rect_total = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				num_4,
				30
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				100,
				0
			}
		}
	}
	tbl_2.offset = {
		0,
		-375,
		0
	}

	return tbl_2
end

UIWidgets.create_game_type_text = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local flag = arg_10_3 or {
		255,
		255,
		255,
		255
	}

	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					style_id = "status_text",
					pass_type = "text",
					text_id = "status_text",
					content_check_function = function (self, arg_11_1)
						-- function 11
						return self.text ~= ""
					end
				}
			}
		},
		content = {
			text = arg_10_0,
			status_text = Localize("lb_status") .. ":",
			color = flag
		},
		style = {
			text = {
				localize = false,
				word_wrap = true,
				font_type = "hell_shark",
				font_size = arg_10_2,
				text_color = flag,
				offset = {
					0,
					0,
					2
				}
			},
			status_text = {
				localize = false,
				word_wrap = true,
				font_type = "hell_shark",
				font_size = arg_10_2 * 0.4,
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					arg_10_2,
					2
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_10_1
	}
end

local function fn_2(arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "texture_id",
					scenegraph_id = "info_icon"
				}
			}
		},
		content = {
			texture_id = "info",
			text = arg_12_0
		},
		style = {
			text = {
				localize = true,
				word_wrap = true,
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font = true,
				font_type = "hell_shark_header",
				font_size = arg_12_2,
				text_color = Colors.get_table("dark_gray"),
				offset = {
					0,
					0,
					1
				}
			},
			icon = {
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
		scenegraph_id = arg_12_1
	}
end

local function fn_3(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local var_13_0 = Localize(arg_13_1)
	local flag = not string.find(var_13_0, "{#")

	return {
		element = {
			passes = {
				{
					pass_type = "hotspot",
					content_id = "button_text"
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 14
						if not Managers.input:is_device_active("mouse") then
							return
						end

						return not not self.button_text.disable_button or not self.button_text.is_selected
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 15
						if not Managers.input:is_device_active("mouse") then
							return
						end

						return not self.button_text.disable_button
					end
				},
				{
					style_id = "text_disabled",
					pass_type = "text",
					text_id = "text_field",
					content_check_function = function (self)
						-- function 16
						return self.button_text.disable_button
					end
				},
				{
					texture_id = "icon_id",
					style_id = "icon",
					pass_type = "texture_uv",
					content_id = "icon_content",
					content_check_function = function (self)
						-- function 17
						local parent = self.parent

						if not parent.show_icon and not parent.disabled then
							return false
						end

						if not parent.selection_callback then
							local selection_callback = parent.selection_callback()

							return parent.index ~= selection_callback
						end

						return false
					end
				}
			}
		},
		content = {
			default_font_size = 24,
			show_icon = false,
			alpha_value = 255,
			callback = arg_13_2,
			menu_option_data = arg_13_3,
			button_text = {},
			text_field = var_13_0,
			icon_content = {
				icon_id = "info",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			}
		},
		style = {
			text = {
				word_wrap = false,
				localize = false,
				font_size = 24,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				upper_case = flag,
				text_color = Colors.get_color_table_with_alpha("font_title", 255),
				offset = {
					0,
					0,
					4
				}
			},
			text_hover = {
				word_wrap = false,
				localize = false,
				font_size = 24,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				upper_case = flag,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					4
				}
			},
			text_disabled = {
				word_wrap = false,
				localize = false,
				font_size = 24,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark",
				upper_case = flag,
				text_color = Colors.get_color_table_with_alpha("gray", 50),
				offset = {
					0,
					0,
					4
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					36,
					36
				},
				offset = {
					0,
					2,
					4
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		scenegraph_id = arg_13_0
	}
end

function create_sub_logo(arg_18_0)
	-- function 18
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_18_0).size
	local tbl = {
		size[1],
		size[2]
	}

	return {
		scenegraph_id = "sub_logo",
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
			texture_id = arg_18_0
		},
		style = {
			texture_id = {
				vertical_alignment = "top",
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
					0
				},
				texture_size = tbl
			}
		},
		offset = {
			0,
			-250,
			0
		}
	}
end

local function fn_4(arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self, arg_20_1)
						-- function 20
						if self.text == nil then
							return false
						end

						return self.text ~= ""
					end
				}
			}
		},
		content = {
			text = arg_19_0
		},
		style = {
			text = arg_19_2
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_19_1
	}
end

local function fn_5(arg_21_0)
	-- function 21
	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self, arg_22_1)
						-- function 22
						if self.text == nil then
							return false
						end

						return self.text ~= ""
					end
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "texture_id",
					content_check_function = function (self, arg_23_1)
						-- function 23
						if self.text == nil then
							return false
						end

						return self.text ~= ""
					end
				}
			}
		},
		content = {
			text = "test",
			texture_id = "start_screen_info_tag"
		},
		style = {
			text = tbl_2,
			background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					481,
					20
				},
				color = Colors.get_color_table_with_alpha("font_title", 255)
			}
		},
		offset = {
			0,
			0,
			1
		},
		scenegraph_id = arg_21_0
	}
end

local tbl_5 = {
	dead_space_filler_widget = UIWidgets.create_simple_rect("dead_space_filler", {
		255,
		0,
		0,
		0
	}),
	sidebar_fill = UIWidgets.create_simple_rect("sidebar", {
		245,
		0,
		0,
		0
	}),
	sidebar_fade_bg = UIWidgets.create_shader_tiled_texture("sidebar_fade_bg", "fade_bg_unmasked", {
		256,
		256
	}, nil, nil, {
		245,
		255,
		255,
		255
	}),
	start_screen_video_fade = UIWidgets.create_simple_rect("start_screen_video_fade", {
		0,
		0,
		0,
		0
	})
}
local tbl_6 = {
	logo = UIWidgets.create_simple_texture("vermintide_logo_title", "logo"),
	legal_text = UIWidgets.create_simple_text("n/a", "legal_text", 12, {
		255,
		255,
		255,
		255
	}),
	information_text = UIWidgets.create_simple_text("n/a", "information_text", 18, {
		255,
		255,
		255,
		255
	}),
	start_screen_selection_left = UIWidgets.create_simple_texture("start_screen_selection_left", "selection_glow_left"),
	start_screen_selection_right = UIWidgets.create_simple_texture("start_screen_selection_right", "selection_glow_right"),
	create_engage_prompt = fn,
	info_icon_text = fn_2("", "info_icon_text", 23),
	info_slate = fn_5("info_slate"),
	game_type = fn_4("start_menu_adventure_tag", "game_type_tag", tbl_3),
	game_type_description = fn_4("start_menu_adventure_description", "game_type_description", tbl_4)
}
local tbl_7 = {
	main = {
		loop = true,
		scenegraph_id = "start_screen_video",
		video_name = "video/start_1",
		main_menu = true,
		material_name = "start_1"
	},
	main_menu = {
		loop = true,
		scenegraph_id = "start_screen_video",
		video_name = "video/start_2",
		main_menu = true,
		material_name = "start_2"
	},
	adventure = {
		loop = true,
		scenegraph_id = "start_screen_video",
		video_name = "video/start_2_drachenfels",
		main_menu = true,
		material_name = "start_2_drachenfels"
	},
	chaos_wastes = {
		loop = true,
		scenegraph_id = "start_screen_video",
		video_name = "video/start_2_chaos_wastes",
		main_menu = true,
		material_name = "start_2_chaos_wastes"
	},
	versus = {
		loop = true,
		scenegraph_id = "start_screen_video",
		video_name = "video/start_2_versus",
		main_menu = true,
		material_name = "start_2_versus"
	}
}
local tbl_8 = {
	"fatshark_legal_1",
	"gw_legal_1",
	"gw_legal_2",
	"gw_legal_3",
	"gw_legal_4"
}
local tbl_9 = {
	video_fade_in = {
		{
			name = "video_fade_in",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
				-- function 24
				arg_24_2.start_screen_video_fade.style.rect.color[1] = 255
			end,
			update = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4)
				-- function 25
				local easeInCubic = math.easeInCubic(arg_25_3)

				arg_25_2.start_screen_video_fade.style.rect.color[1] = math.clamp(255 * (1 - easeInCubic), 0, 255)
			end,
			on_complete = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
				-- function 26
				return
			end
		}
	}
}

return {
	background_widget_definitions = tbl_5,
	single_widget_definitions = tbl_6,
	scenegraph_definition = tbl,
	menu_videos = tbl_7,
	create_menu_button_func = fn_3,
	legal_texts = tbl_8,
	create_sub_logo_func = create_sub_logo,
	animation_definitions = tbl_9
}
