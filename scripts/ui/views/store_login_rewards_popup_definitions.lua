-- chunkname: @scripts/ui/views/store_login_rewards_popup_definitions.lua

local num = 1550
local num_2 = 700
local num_3 = 150
local num_4 = 350
local num_5 = 20
local num_6 = 8
local flag = true
local tbl = {
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
			num,
			num_2
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
			num - 84,
			num_2 - 84
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
			num - 42,
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
			num - 42,
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
			num_2 - 42
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
			num_2 - 42
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
			num - 84 - 150,
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
			num,
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
			(num_3 + num_5) * num_6,
			num_4
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
			num_3,
			num_4
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
			num_3 - 8,
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
local tbl_2 = {
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
local tbl_3 = {
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
local tbl_4 = {
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

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local frame_outer_glow_04_big = UIFrameSettings.frame_outer_glow_04_big
	local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
	local var_1_2 = frame_outer_glow_01.texture_sizes.vertical[1]
	local tbl = {
		80,
		80
	}
	local tbl_2 = {
		scenegraph_id = "reward_pivot",
		offset = {
			(arg_1_0 - 1) * (num_3 + num_5) + 0.5 * num_5,
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
					content_check_function = function (self)
						-- function 2
						return self.is_illusion
					end
				},
				{
					pass_type = "hover",
					style_id = "item_tooltip"
				},
				{
					style_id = "item_tooltip",
					item_id = "item",
					pass_type = "item_tooltip",
					content_check_function = function (self)
						-- function 3
						local is_device_active = Managers.input:is_device_active("gamepad")
						local is_hover = self.is_hover

						if is_hover or not is_device_active then
							-- Nothing
						end

						::label_3_0::

						is_hover = self.is_selected
						is_hover = not is_hover and self.show_tooltips

						::label_3_1::

						return is_hover
					end
				},
				{
					pass_type = "texture_frame",
					style_id = "cursor",
					texture_id = "cursor",
					content_check_function = function (self)
						-- function 4
						if not Managers.input:is_device_active("gamepad") then
							return self.is_selected
						else
							return self.is_hover
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
			shadow = frame_outer_glow_01.texture,
			cursor = frame_outer_glow_04_big.texture
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
				texture_size = frame_outer_glow_01.texture_size,
				texture_sizes = frame_outer_glow_01.texture_sizes,
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
				texture_size = tbl
			},
			item_icon = {
				offset = {
					0,
					0,
					2
				},
				texture_size = tbl
			},
			item_illusion = {
				offset = {
					0,
					0,
					3
				},
				texture_size = tbl
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
				size = tbl,
				text_color = Colors.get_color_table_with_alpha("white", 255),
				line_colors = {
					Colors.get_color_table_with_alpha("font_title", 255),
					Colors.get_color_table_with_alpha("white", 255)
				}
			},
			cursor = {
				size = tbl,
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
		}
	}

	UIWidgets.append_item_frame_pass("item_frame", tbl_2.element.passes, tbl_2.content, tbl_2.style, tbl, {
		0,
		0,
		4
	}, false, nil, nil, nil, nil)

	return tbl_2
end

local function fn_2(arg_5_0)
	-- function 5
	local button_frame_01_gold = UIFrameSettings.button_frame_01_gold
	local frame_corner_detail_01_gold = UIFrameSettings.frame_corner_detail_01_gold
	local frame_outer_glow_04_big = UIFrameSettings.frame_outer_glow_04_big
	local var_5_3 = frame_outer_glow_04_big.texture_sizes.horizontal[2]
	local frame_outer_glow_01_white = UIFrameSettings.frame_outer_glow_01_white
	local var_5_5 = frame_outer_glow_01_white.texture_sizes.vertical[1]

	return {
		scenegraph_id = "day_pivot",
		offset = {
			(arg_5_0 - 1) * (num_3 + num_5) + 0.5 * num_5,
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
					content_check_function = function (self, arg_6_1)
						-- function 6
						return not Managers.input:is_device_active("gamepad") and self.selection_index == self.day_index
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
					content_check_function = function (self)
						-- function 7
						return self.is_today
					end
				},
				{
					style_id = "bottom_glow",
					pass_type = "texture_uv",
					content_id = "bottom_glow",
					content_check_function = function (self)
						-- function 8
						return self.parent.is_today
					end
				},
				{
					style_id = "day_text",
					pass_type = "text",
					text_id = "day_text",
					content_check_function = function (self)
						-- function 9
						return self.calendar_type == "personal_time_strike"
					end
				},
				{
					style_id = "day_text_shadow",
					pass_type = "text",
					text_id = "day_text",
					content_check_function = function (self)
						-- function 10
						return self.calendar_type == "personal_time_strike"
					end
				},
				{
					style_id = "day_number",
					pass_type = "text",
					text_id = "day_number",
					content_check_function = function (self)
						-- function 11
						return not self.is_today
					end
				},
				{
					style_id = "day_number_shadow",
					pass_type = "text",
					text_id = "day_number",
					content_check_function = function (self)
						-- function 12
						return not self.is_today
					end
				},
				{
					texture_id = "day_number_texture",
					style_id = "day_number_texture",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 13
						return self.is_today
					end
				},
				{
					texture_id = "claimed",
					style_id = "claimed",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 14
						return self.is_claimed
					end
				},
				{
					style_id = "unclaimed_tint",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 15
						return self.calendar_type ~= "calendar" or not not self.is_claimed or not (self.day_index <= self.current_day) or not self.is_loop
					end,
					content_change_function = function (self, arg_16_1)
						-- function 16
						if not (self.calendar_type ~= "calendar" or self.is_claimed or not (self.day_index <= self.current_day) or self.is_loop) then
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
			frame = button_frame_01_gold.texture,
			corner = frame_corner_detail_01_gold.texture,
			glow = frame_outer_glow_04_big.texture,
			selection_frame = frame_outer_glow_01_white.texture,
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
				texture_size = button_frame_01_gold.texture_size,
				texture_sizes = button_frame_01_gold.texture_sizes,
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
				texture_size = frame_corner_detail_01_gold.texture_size,
				texture_sizes = frame_corner_detail_01_gold.texture_sizes,
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
				texture_size = frame_outer_glow_04_big.texture_size,
				texture_sizes = frame_outer_glow_04_big.texture_sizes,
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
				texture_size = frame_outer_glow_01_white.texture_size,
				texture_sizes = frame_outer_glow_01_white.texture_sizes,
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
					num_3,
					num_4
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

local tbl_5 = {
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
				num,
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
				num,
				100
			},
			color = Colors.get_color_table_with_alpha("exotic", 200)
		}
	}
}
local tbl_6 = {
	scenegraph_id = "loading_icon",
	element = {
		passes = {
			{
				style_id = "loading_icon",
				pass_type = "rotated_texture",
				texture_id = "loading_icon",
				content_change_function = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
					-- function 17
					local progress = arg_17_1.progress

					progress = progress or 0

					local num = (progress + arg_17_3) % 1

					arg_17_1.angle = math.pow(2, math.smoothstep(num, 0, 1)) * (math.pi * 2)
					arg_17_1.progress = num
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
local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
local var_0_16 = frame_outer_glow_01.texture_sizes.horizontal[2]
local tbl_7 = {
	scenegraph_id = "claim_button",
	element = {
		passes = {
			{
				style_id = "outer_glow",
				texture_id = "outer_glow",
				pass_type = "texture_frame",
				content_change_function = function (arg_18_0, arg_18_1)
					-- function 18
					arg_18_1.color[1] = 150 + 105 * math.sin(5 * Managers.time:time("ui"))
				end
			}
		}
	},
	content = {
		outer_glow = frame_outer_glow_01.texture,
		disable_with_gamepad = flag
	},
	style = {
		outer_glow = {
			frame_margins = {
				-var_0_16,
				-var_0_16
			},
			texture_size = frame_outer_glow_01.texture_size,
			texture_sizes = frame_outer_glow_01.texture_sizes,
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
local tbl_8 = {
	background_overlay = UIWidgets.create_simple_rect("screen", {
		220,
		12,
		12,
		12
	}),
	loading_icon = tbl_6
}
local tbl_9 = {
	overlay = UIWidgets.create_simple_rect("screen", {
		220,
		12,
		12,
		12
	}, 36),
	loading_glow = UIWidgets.create_simple_texture("loading_title_divider", "claim_overlay_divider", nil, nil, nil, 1),
	loading_frame = UIWidgets.create_simple_texture("loading_title_divider_background", "claim_overlay_divider")
}
local tbl_10 = {
	screen = UIWidgets.create_simple_rect("screen", {
		220,
		12,
		12,
		12
	}),
	background_glows = tbl_5,
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
	title = UIWidgets.create_simple_text("store_login_rewards_title", "title", nil, nil, tbl_2),
	description = UIWidgets.create_simple_text("store_login_rewards_desc", "description", nil, nil, tbl_3),
	timer = UIWidgets.create_simple_text(Localize("available_now"), "timer", nil, nil, tbl_4),
	claim_button = UIWidgets.create_default_button("claim_button", tbl.claim_button.size, "button_frame_01_gold", "menu_frame_bg_06", Localize("welcome_currency_popup_button_claim"), 28, nil, "button_detail_03_gold", nil),
	close_button = UIWidgets.create_default_button("close_button", tbl.close_button.size, "button_frame_01_gold", "menu_frame_bg_06", Localize("interaction_action_close"), 28, nil, "button_detail_03_gold", nil, flag),
	claim_button_glow = tbl_7
}
local new_array = Script.new_array(num_6)

for i = 1, num_6 do
	new_array[i] = fn_2(i)
end

local tbl_11 = {
	on_enter = {
		{
			name = "fade_in",
			duration = 0.3,
			init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
				-- function 19
				arg_19_3.alpha_multiplier = 0
			end,
			update = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
				-- function 20
				arg_20_4.alpha_multiplier = math.easeOutCubic(arg_20_3)
			end,
			on_complete = NOP
		},
		{
			name = "slide_in",
			duration = 0.8,
			init = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
				-- function 21
				arg_21_0.window.local_position[2] = 432
			end,
			update = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
				-- function 22
				arg_22_0.window.local_position[2] = math.round(432 * (1 - math.ease_out_elastic(arg_22_3)))
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_glows",
			delay = 0.5,
			duration = 0.8,
			init = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
				-- function 23
				arg_23_2.background_glows.content.alpha_multiplier = 0
			end,
			update = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
				-- function 24
				arg_24_2.background_glows.content.alpha_multiplier = math.easeOutCubic(arg_24_3)
			end,
			on_complete = NOP
		}
	},
	on_exit = {
		{
			name = "fade_out",
			duration = 0.3,
			init = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
				-- function 25
				arg_25_3.alpha_multiplier = 1
			end,
			update = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
				-- function 26
				arg_26_4.alpha_multiplier = 1 - math.easeOutCubic(arg_26_3)
			end,
			on_complete = NOP
		}
	},
	on_claim = {
		{
			name = "sigil",
			duration = 0.25,
			init = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
				-- function 27
				local claimed = arg_27_2.style.claimed

				arg_27_3.og_size_x = claimed.texture_size[1]
				arg_27_3.og_size_y = claimed.texture_size[2]
				claimed.color[1] = 0
			end,
			update = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
				-- function 28
				local easeInCubic = math.easeInCubic(arg_28_3)
				local claimed = arg_28_2.style.claimed

				claimed.texture_size[1] = (3 - 2 * easeInCubic) * arg_28_4.og_size_x
				claimed.texture_size[2] = (3 - 2 * easeInCubic) * arg_28_4.og_size_y
				claimed.color[1] = 255 * easeInCubic
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_glow",
			delay = 0.5,
			duration = 0.5,
			init = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
				-- function 29
				arg_29_2.style.glow.color[1] = 0
			end,
			update = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
				-- function 30
				arg_30_2.style.glow.color[1] = 255 * arg_30_3
			end,
			on_complete = NOP
		},
		{
			name = "fade_in_bottom_glow",
			delay = 0.5,
			duration = 0.5,
			init = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				arg_31_2.style.bottom_glow.color[1] = 0
			end,
			update = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				-- function 32
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
local tbl_12 = {
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
	scenegraph_definition = tbl,
	loading_widgets_definitions = tbl_8,
	overlay_widgets_definitions = tbl_9,
	widget_definitions = tbl_10,
	day_widget_definitions = new_array,
	animation_definitions = tbl_11,
	generic_input_actions = tbl_12,
	create_reward_item_widget = fn,
	day_count = num_6
}
