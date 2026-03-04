-- chunkname: @scripts/ui/views/store_login_rewards_popup_definitions.lua

local var_0_0 = 1550
local var_0_1 = 700
local var_0_2 = 150
local var_0_3 = 350
local var_0_4 = 20
local var_0_5 = 8
local var_0_6 = true
local var_0_7 = {
	screen = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		scale = "fit",
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
	window = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			var_0_0,
			var_0_1
		},
		position = {
			0,
			0,
			1
		}
	},
	claim_overlay_divider = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			314,
			33
		},
		position = {
			0,
			20,
			40
		}
	},
	loading_icon = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			150,
			150
		},
		position = {
			0,
			0,
			5
		}
	},
	window_inner = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_0 - 84,
			var_0_1 - 84
		},
		position = {
			0,
			0,
			0
		}
	},
	background_edge_top = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_0 - 42,
			42
		},
		position = {
			0,
			0,
			4
		}
	},
	background_edge_bottom = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_0 - 42,
			42
		},
		position = {
			0,
			0,
			4
		}
	},
	background_edge_left = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			42,
			var_0_1 - 42
		},
		position = {
			0,
			0,
			4
		}
	},
	background_edge_right = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			42,
			var_0_1 - 42
		},
		position = {
			0,
			0,
			4
		}
	},
	corner_bottom_left = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			151,
			151
		},
		position = {
			-6,
			-6,
			5
		}
	},
	corner_bottom_right = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			151,
			151
		},
		position = {
			6,
			-6,
			5
		}
	},
	corner_top_left = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			151,
			151
		},
		position = {
			-6,
			6,
			5
		}
	},
	corner_top_right = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			151,
			151
		},
		position = {
			6,
			6,
			5
		}
	},
	timer = {
		vertical_alignment = "bottom",
		parent = "window_inner",
		horizontal_alignment = "left",
		size = {
			var_0_0 - 84 - 150,
			42
		},
		position = {
			75,
			5,
			5
		}
	},
	backdrop = {
		vertical_alignment = "top",
		parent = "window_inner",
		horizontal_alignment = "center",
		size = {
			380,
			40
		},
		position = {
			0,
			-20,
			5
		}
	},
	title = {
		vertical_alignment = "center",
		parent = "backdrop",
		horizontal_alignment = "center",
		size = {
			var_0_0,
			30
		},
		position = {
			0,
			0,
			3
		}
	},
	description = {
		vertical_alignment = "bottom",
		parent = "backdrop",
		horizontal_alignment = "center",
		size = {
			1050,
			100
		},
		position = {
			0,
			-110,
			3
		}
	},
	calendar = {
		vertical_alignment = "center",
		parent = "window_inner",
		horizontal_alignment = "center",
		size = {
			(var_0_2 + var_0_4) * var_0_5,
			var_0_3
		},
		position = {
			0,
			-40,
			1
		}
	},
	day_pivot = {
		vertical_alignment = "bottom",
		parent = "calendar",
		horizontal_alignment = "left",
		size = {
			var_0_2,
			var_0_3
		},
		position = {
			0,
			0,
			1
		}
	},
	claim_button = {
		vertical_alignment = "bottom",
		parent = "day_pivot",
		horizontal_alignment = "center",
		size = {
			var_0_2 - 8,
			42
		},
		position = {
			0,
			-15,
			10
		}
	},
	reward_pivot = {
		vertical_alignment = "bottom",
		parent = "day_pivot",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			130,
			10
		}
	},
	close_button = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			260,
			42
		},
		position = {
			0,
			-82,
			10
		}
	}
}
local var_0_8 = {
	word_wrap = true,
	font_size = 42,
	localize = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("exotic", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_9 = {
	word_wrap = true,
	font_size = 24,
	localize = true,
	vertical_alignment = "top",
	horizontal_alignment = "center",
	use_shadow = true,
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_10 = {
	word_wrap = true,
	font_size = 32,
	localize = false,
	vertical_alignment = "top",
	horizontal_alignment = "left",
	use_shadow = true,
	font_type = "hell_shark",
	text_color = {
		255,
		230,
		230,
		230
	},
	offset = {
		0,
		0,
		2
	}
}

local function var_0_11(arg_1_0, arg_1_1)
	local var_1_0 = UIFrameSettings.frame_outer_glow_04_big
	local var_1_1 = UIFrameSettings.frame_outer_glow_01
	local var_1_2 = var_1_1.texture_sizes.vertical[1]
	local var_1_3 = UIFrameSettings.frame_outer_glow_01_white.texture_sizes.vertical[1]

	return {
		scenegraph_id = "reward_pivot",
		offset = {
			(arg_1_0 - 1) * (var_0_2 + var_0_4) + 0.5 * var_0_4,
			(arg_1_1 - 1) * -85,
			0
		},
		element = {
			passes = {
				{
					texture_id = "shadow",
					style_id = "shadow",
					pass_type = "texture_frame"
				},
				{
					texture_id = "item_rarity",
					style_id = "item_rarity",
					pass_type = "texture"
				},
				{
					texture_id = "item_icon",
					style_id = "item_icon",
					pass_type = "texture"
				},
				{
					texture_id = "item_illusion",
					style_id = "item_illusion",
					pass_type = "texture",
					content_check_function = function(arg_2_0)
						return arg_2_0.is_illusion
					end
				},
				{
					texture_id = "item_frame",
					style_id = "item_frame",
					pass_type = "texture"
				},
				{
					pass_type = "hover",
					style_id = "item_tooltip"
				},
				{
					style_id = "item_tooltip",
					item_id = "item",
					pass_type = "item_tooltip",
					content_check_function = function(arg_3_0)
						local var_3_0 = Managers.input:is_device_active("gamepad")

						return arg_3_0.is_hover or var_3_0 and arg_3_0.is_selected and arg_3_0.show_tooltips
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "cursor",
					texture_id = "cursor",
					content_check_function = function(arg_4_0)
						if Managers.input:is_device_active("gamepad") then
							return arg_4_0.is_selected
						else
							return arg_4_0.is_hover
						end
					end
				}
			}
		},
		content = {
			is_hover = false,
			item_illusion = "item_frame_illusion",
			item_rarity = "icons_placeholder",
			no_equipped_item = true,
			is_illusion = false,
			show_tooltips = false,
			item_icon = "icons_placeholder",
			item_frame = "item_frame",
			shadow = var_1_1.texture,
			cursor = var_1_0.texture
		},
		style = {
			shadow = {
				offset = {
					0,
					0,
					0
				},
				frame_margins = {
					-var_1_2,
					-var_1_2
				},
				texture_size = var_1_1.texture_size,
				texture_sizes = var_1_1.texture_sizes,
				color = {
					255,
					50,
					50,
					50
				}
			},
			item_rarity = {
				offset = {
					0,
					0,
					1
				},
				texture_size = {
					80,
					80
				}
			},
			item_icon = {
				offset = {
					0,
					0,
					2
				},
				texture_size = {
					80,
					80
				}
			},
			item_illusion = {
				offset = {
					0,
					0,
					3
				},
				texture_size = {
					80,
					80
				}
			},
			item_frame = {
				offset = {
					0,
					0,
					4
				},
				texture_size = {
					80,
					80
				}
			},
			item_tooltip = {
				font_type = "hell_shark",
				localize = true,
				font_size = 18,
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
			},
			cursor = {
				size = {
					80,
					80
				},
				texture_size = var_1_0.texture_size,
				texture_sizes = var_1_0.texture_sizes,
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
		}
	}
end

local function var_0_12(arg_5_0)
	local var_5_0 = UIFrameSettings.button_frame_01_gold
	local var_5_1 = UIFrameSettings.frame_corner_detail_01_gold
	local var_5_2 = UIFrameSettings.frame_outer_glow_04_big
	local var_5_3 = var_5_2.texture_sizes.horizontal[2]
	local var_5_4 = UIFrameSettings.frame_outer_glow_01_white
	local var_5_5 = var_5_4.texture_sizes.vertical[1]

	return {
		scenegraph_id = "day_pivot",
		offset = {
			(arg_5_0 - 1) * (var_0_2 + var_0_4) + 0.5 * var_0_4,
			0,
			0
		},
		element = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					pass_type = "texture",
					style_id = "bg",
					texture_id = "bg"
				},
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					pass_type = "texture_frame",
					style_id = "corner",
					texture_id = "corner"
				},
				{
					pass_type = "texture_frame",
					style_id = "selection_frame",
					texture_id = "selection_frame",
					content_check_function = function(arg_6_0, arg_6_1)
						return Managers.input:is_device_active("gamepad") and arg_6_0.selection_index == arg_6_0.day_index
					end
				},
				{
					pass_type = "texture",
					style_id = "inset",
					texture_id = "inset"
				},
				{
					pass_type = "texture_frame",
					style_id = "glow",
					texture_id = "glow",
					content_check_function = function(arg_7_0)
						return arg_7_0.is_today
					end
				},
				{
					style_id = "bottom_glow",
					pass_type = "texture_uv",
					content_id = "bottom_glow",
					content_check_function = function(arg_8_0)
						return arg_8_0.parent.is_today
					end
				},
				{
					style_id = "day_text",
					pass_type = "text",
					text_id = "day_text",
					content_check_function = function(arg_9_0)
						return arg_9_0.calendar_type == "personal_time_strike"
					end
				},
				{
					style_id = "day_text_shadow",
					pass_type = "text",
					text_id = "day_text",
					content_check_function = function(arg_10_0)
						return arg_10_0.calendar_type == "personal_time_strike"
					end
				},
				{
					style_id = "day_number",
					pass_type = "text",
					text_id = "day_number",
					content_check_function = function(arg_11_0)
						return not arg_11_0.is_today
					end
				},
				{
					style_id = "day_number_shadow",
					pass_type = "text",
					text_id = "day_number",
					content_check_function = function(arg_12_0)
						return not arg_12_0.is_today
					end
				},
				{
					texture_id = "day_number_texture",
					style_id = "day_number_texture",
					pass_type = "texture",
					content_check_function = function(arg_13_0)
						return arg_13_0.is_today
					end
				},
				{
					texture_id = "claimed",
					style_id = "claimed",
					pass_type = "texture",
					content_check_function = function(arg_14_0)
						return arg_14_0.is_claimed
					end
				},
				{
					style_id = "unclaimed_tint",
					pass_type = "rect",
					content_check_function = function(arg_15_0)
						return arg_15_0.calendar_type == "calendar" and not arg_15_0.is_claimed and arg_15_0.day_index <= arg_15_0.current_day and not arg_15_0.is_loop
					end,
					content_change_function = function(arg_16_0, arg_16_1)
						if arg_16_0.calendar_type == "calendar" and not arg_16_0.is_claimed and arg_16_0.day_index <= arg_16_0.current_day and not arg_16_0.is_loop then
							arg_16_1.color[1] = 120
						end
					end
				}
			}
		},
		content = {
			is_claimed = false,
			is_today = false,
			current_day = 0,
			claimed = "store_owned_sigil",
			inset = "options_window_fade_01",
			calendar_type = "personal_time_strike",
			bg = "menu_frame_bg_09",
			hotspot = {},
			frame = var_5_0.texture,
			corner = var_5_1.texture,
			glow = var_5_2.texture,
			selection_frame = var_5_4.texture,
			bottom_glow = {
				texture_id = "login_rewards_embers",
				visible = false,
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
			},
			day_text = "imperial_day_" .. tostring(arg_5_0),
			day_number = tostring(arg_5_0),
			day_number_texture = "numeric_icon_orange_medium_" .. arg_5_0,
			day_index = arg_5_0
		},
		style = {
			hotspot = {},
			bg = {
				offset = {
					0,
					0,
					1
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			frame = {
				offset = {
					0,
					0,
					4
				},
				texture_size = var_5_0.texture_size,
				texture_sizes = var_5_0.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				}
			},
			corner = {
				offset = {
					0,
					0,
					5
				},
				texture_size = var_5_1.texture_size,
				texture_sizes = var_5_1.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				}
			},
			glow = {
				offset = {
					0,
					0,
					3
				},
				frame_margins = {
					-var_5_3,
					-var_5_3
				},
				texture_size = var_5_2.texture_size,
				texture_sizes = var_5_2.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				}
			},
			selection_frame = {
				offset = {
					0,
					0,
					6
				},
				frame_margins = {
					-var_5_5,
					-var_5_5
				},
				texture_size = var_5_4.texture_size,
				texture_sizes = var_5_4.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				}
			},
			inset = {
				offset = {
					0,
					0,
					2
				},
				color = {
					220,
					255,
					255,
					255
				}
			},
			bottom_glow = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				offset = {
					0,
					0,
					3
				},
				texture_size = {
					var_0_2,
					var_0_3
				},
				color = {
					255,
					255,
					115,
					10
				}
			},
			day_text = {
				font_type = "hell_shark_header",
				upper_case = true,
				localize = true,
				font_size = 22,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				text_color = {
					255,
					50,
					20,
					20
				},
				area_size = {
					100,
					-1
				},
				offset = {
					0,
					-40,
					10
				}
			},
			day_text_shadow = {
				font_type = "hell_shark_header",
				upper_case = true,
				localize = true,
				font_size = 22,
				horizontal_alignment = "center",
				vertical_alignment = "top",
				text_color = {
					255,
					164,
					130,
					82
				},
				area_size = {
					100,
					-1
				},
				offset = {
					1.5,
					-41.5,
					9
				}
			},
			day_number = {
				vertical_alignment = "top",
				localize = false,
				horizontal_alignment = "center",
				font_size = 52,
				font_type = "hell_shark",
				offset = {
					0,
					-75,
					4
				},
				text_color = {
					255,
					50,
					20,
					20
				}
			},
			day_number_shadow = {
				vertical_alignment = "top",
				localize = false,
				horizontal_alignment = "center",
				font_size = 52,
				font_type = "hell_shark",
				offset = {
					2,
					-77,
					3
				},
				text_color = {
					255,
					164,
					130,
					82
				}
			},
			day_number_texture = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				offset = {
					0,
					-70,
					4
				},
				texture_size = {
					64,
					64
				}
			},
			claimed = {
				vertical_alignment = "bottom",
				horizontal_alignment = "center",
				color = {
					255,
					255,
					255,
					255
				},
				texture_size = {
					75,
					75
				},
				offset = {
					0,
					-37.5,
					20
				}
			},
			unclaimed_tint = {
				color = {
					0,
					0,
					0,
					0
				},
				offset = {
					0,
					0,
					20
				}
			}
		}
	}
end

local var_0_13 = {
	scenegraph_id = "window",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "top"
			},
			{
				pass_type = "texture_uv",
				style_id = "bottom"
			}
		}
	},
	content = {
		texture_id = "morris_gaze_glow",
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
	},
	style = {
		top = {
			vertical_alignment = "top",
			horizontal_alignment = "center",
			offset = {
				0,
				100,
				0
			},
			texture_size = {
				var_0_0,
				100
			},
			color = Colors.get_color_table_with_alpha("exotic", 200)
		},
		bottom = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			offset = {
				0,
				-100,
				0
			},
			texture_size = {
				var_0_0,
				100
			},
			color = Colors.get_color_table_with_alpha("exotic", 200)
		}
	}
}
local var_0_14 = {
	scenegraph_id = "loading_icon",
	element = {
		passes = {
			{
				style_id = "loading_icon",
				pass_type = "rotated_texture",
				texture_id = "loading_icon",
				content_change_function = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
					local var_17_0 = ((arg_17_1.progress or 0) + arg_17_3) % 1

					arg_17_1.angle = math.pow(2, math.smoothstep(var_17_0, 0, 1)) * (math.pi * 2)
					arg_17_1.progress = var_17_0
				end
			}
		}
	},
	content = {
		loading_icon = "loot_loading"
	},
	style = {
		loading_icon = {
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
			texture_size = {
				150,
				150
			}
		}
	}
}
local var_0_15 = UIFrameSettings.frame_outer_glow_01
local var_0_16 = var_0_15.texture_sizes.horizontal[2]
local var_0_17 = {
	scenegraph_id = "claim_button",
	element = {
		passes = {
			{
				style_id = "outer_glow",
				texture_id = "outer_glow",
				pass_type = "texture_frame",
				content_change_function = function(arg_18_0, arg_18_1)
					arg_18_1.color[1] = 150 + 105 * math.sin(5 * Managers.time:time("ui"))
				end
			}
		}
	},
	content = {
		outer_glow = var_0_15.texture,
		disable_with_gamepad = var_0_6
	},
	style = {
		outer_glow = {
			frame_margins = {
				-var_0_16,
				-var_0_16
			},
			texture_size = var_0_15.texture_size,
			texture_sizes = var_0_15.texture_sizes,
			offset = {
				0,
				0,
				0
			},
			color = {
				255,
				255,
				255,
				255
			}
		}
	}
}
local var_0_18 = {
	background_overlay = UIWidgets.create_simple_rect("screen", {
		220,
		12,
		12,
		12
	}),
	loading_icon = var_0_14
}
local var_0_19 = {
	overlay = UIWidgets.create_simple_rect("screen", {
		220,
		12,
		12,
		12
	}, 36),
	loading_glow = UIWidgets.create_simple_texture("loading_title_divider", "claim_overlay_divider", nil, nil, nil, 1),
	loading_frame = UIWidgets.create_simple_texture("loading_title_divider_background", "claim_overlay_divider")
}
local var_0_20 = {
	screen = UIWidgets.create_simple_rect("screen", {
		220,
		12,
		12,
		12
	}),
	background_glows = var_0_13,
	window_background = UIWidgets.create_tiled_texture("window_inner", "menu_frame_bg_03", {
		256,
		256
	}, nil, nil, {
		255,
		150,
		150,
		150
	}),
	background_edge_top = UIWidgets.create_tiled_texture("background_edge_top", "store_frame_small_side_01", {
		128,
		42
	}),
	background_edge_bottom = UIWidgets.create_tiled_texture("background_edge_bottom", "store_frame_small_side_03", {
		128,
		42
	}),
	background_edge_left = UIWidgets.create_tiled_texture("background_edge_left", "store_frame_small_side_04", {
		42,
		128
	}),
	background_edge_right = UIWidgets.create_tiled_texture("background_edge_right", "store_frame_small_side_02", {
		42,
		128
	}),
	corner_bottom_left = UIWidgets.create_simple_rotated_texture("store_frame_small_corner", 0, {
		75.5,
		75.5
	}, "corner_bottom_left"),
	corner_bottom_right = UIWidgets.create_simple_rotated_texture("store_frame_small_corner", -math.pi / 2, {
		75.5,
		75.5
	}, "corner_bottom_right"),
	corner_top_left = UIWidgets.create_simple_rotated_texture("store_frame_small_corner", math.pi / 2, {
		75.5,
		75.5
	}, "corner_top_left"),
	corner_top_right = UIWidgets.create_simple_rotated_texture("store_frame_small_corner", math.pi, {
		75.5,
		75.5
	}, "corner_top_right"),
	backdrop = UIWidgets.create_simple_texture("store_preview_info_text_backdrop", "backdrop"),
	title = UIWidgets.create_simple_text("store_login_rewards_title", "title", nil, nil, var_0_8),
	description = UIWidgets.create_simple_text("store_login_rewards_desc", "description", nil, nil, var_0_9),
	timer = UIWidgets.create_simple_text(Localize("available_now"), "timer", nil, nil, var_0_10),
	claim_button = UIWidgets.create_default_button("claim_button", var_0_7.claim_button.size, "button_frame_01_gold", "menu_frame_bg_06", Localize("welcome_currency_popup_button_claim"), 28, nil, "button_detail_03_gold", nil),
	close_button = UIWidgets.create_default_button("close_button", var_0_7.close_button.size, "button_frame_01_gold", "menu_frame_bg_06", Localize("interaction_action_close"), 28, nil, "button_detail_03_gold", nil, var_0_6),
	claim_button_glow = var_0_17
}
local var_0_21 = Script.new_array(var_0_5)

for iter_0_0 = 1, var_0_5 do
	var_0_21[iter_0_0] = var_0_12(iter_0_0)
end

local var_0_22 = {
	on_enter = {
		{
			name = "fade_in",
			duration = 0.3,
			init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				arg_19_3.alpha_multiplier = 0
			end,
			update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				arg_20_4.alpha_multiplier = math.easeOutCubic(arg_20_3)
			end,
			on_complete = NOP
		},
		{
			name = "slide_in",
			duration = 0.8,
			init = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				arg_21_0.window.local_position[2] = 432
			end,
			update = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				arg_22_0.window.local_position[2] = math.round(432 * (1 - math.ease_out_elastic(arg_22_3)))
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_glows",
			delay = 0.5,
			duration = 0.8,
			init = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				arg_23_2.background_glows.content.alpha_multiplier = 0
			end,
			update = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				arg_24_2.background_glows.content.alpha_multiplier = math.easeOutCubic(arg_24_3)
			end,
			on_complete = NOP
		}
	},
	on_exit = {
		{
			name = "fade_out",
			duration = 0.3,
			init = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				arg_25_3.alpha_multiplier = 1
			end,
			update = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				arg_26_4.alpha_multiplier = 1 - math.easeOutCubic(arg_26_3)
			end,
			on_complete = NOP
		}
	},
	on_claim = {
		{
			name = "sigil",
			duration = 0.25,
			init = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				local var_27_0 = arg_27_2.style.claimed

				arg_27_3.og_size_x = var_27_0.texture_size[1]
				arg_27_3.og_size_y = var_27_0.texture_size[2]
				var_27_0.color[1] = 0
			end,
			update = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				local var_28_0 = math.easeInCubic(arg_28_3)
				local var_28_1 = arg_28_2.style.claimed

				var_28_1.texture_size[1] = (3 - 2 * var_28_0) * arg_28_4.og_size_x
				var_28_1.texture_size[2] = (3 - 2 * var_28_0) * arg_28_4.og_size_y
				var_28_1.color[1] = 255 * var_28_0
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_glow",
			delay = 0.5,
			duration = 0.5,
			init = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				arg_29_2.style.glow.color[1] = 0
			end,
			update = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				arg_30_2.style.glow.color[1] = 255 * arg_30_3
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_bottom_glow",
			delay = 0.5,
			duration = 0.5,
			init = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				arg_31_2.style.bottom_glow.color[1] = 0
			end,
			update = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				arg_32_2.style.bottom_glow.color[1] = 255 * arg_32_3
			end,
			on_complete = NOP
		},
		{
			name = "delay",
			delay = 0,
			duration = 1.5,
			init = NOP,
			update = NOP,
			on_complete = NOP
		}
	}
}
local var_0_23 = {
	default = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "right_stick_press",
			priority = 2,
			description_text = "input_description_tooltip"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_back"
		}
	},
	claim_available = {
		{
			input_action = "confirm",
			priority = 1,
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
		},
		{
			input_action = "back",
			priority = 4,
			description_text = "input_description_back"
		}
	}
}

return {
	scenegraph_definition = var_0_7,
	loading_widgets_definitions = var_0_18,
	overlay_widgets_definitions = var_0_19,
	widget_definitions = var_0_20,
	day_widget_definitions = var_0_21,
	animation_definitions = var_0_22,
	generic_input_actions = var_0_23,
	create_reward_item_widget = var_0_11,
	day_count = var_0_5
}
