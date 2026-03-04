-- chunkname: @scripts/ui/views/hero_view/states/definitions/hero_view_state_keep_decorations_definitions.lua

local var_0_0 = {
	480,
	700
}
local var_0_1 = {
	16,
	var_0_0[2] - 20
}
local var_0_2 = {
	450,
	var_0_0[2] + 20
}
local var_0_3 = IS_WINDOWS
local var_0_4 = var_0_3 and 35 or 50
local var_0_5 = var_0_3 and 22 or 28
local var_0_6 = {
	400,
	var_0_4
}
local var_0_7 = {
	screen = {
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
	list_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = var_0_0,
		position = {
			120,
			-140,
			10
		}
	},
	list_scrollbar = {
		vertical_alignment = "top",
		parent = "list_window",
		horizontal_alignment = "left",
		size = var_0_1,
		position = {
			-30,
			-10,
			10
		}
	},
	list_scroll_root = {
		vertical_alignment = "top",
		parent = "list_window",
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
	list_entry = {
		vertical_alignment = "top",
		parent = "list_scroll_root",
		horizontal_alignment = "left",
		size = var_0_6,
		position = {
			25,
			0,
			0
		}
	},
	list_detail_top = {
		vertical_alignment = "top",
		parent = "list_scrollbar",
		horizontal_alignment = "left",
		size = {
			488,
			95
		},
		position = {
			-45,
			60,
			2
		}
	},
	list_detail_bottom = {
		vertical_alignment = "bottom",
		parent = "list_scrollbar",
		horizontal_alignment = "left",
		size = {
			488,
			95
		},
		position = {
			-45,
			-60,
			2
		}
	},
	confirm_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			380,
			70
		},
		position = {
			0,
			30,
			10
		}
	},
	close_button = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		size = {
			300,
			70
		},
		position = {
			-80,
			30,
			10
		}
	},
	info_window = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
		size = var_0_2,
		position = {
			-70,
			-130,
			10
		}
	},
	info_top_left = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "left",
		size = {
			244,
			95
		},
		position = {
			0,
			40,
			2
		}
	},
	info_top_right = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "right",
		size = {
			244,
			95
		},
		position = {
			0,
			40,
			2
		}
	},
	info_bottom_left = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "left",
		size = {
			244,
			95
		},
		position = {
			0,
			-40,
			2
		}
	},
	info_bottom_right = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "right",
		size = {
			244,
			95
		},
		position = {
			0,
			-40,
			2
		}
	},
	title_text = {
		vertical_alignment = "top",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] - 40,
			300
		},
		position = {
			0,
			-30,
			1
		}
	},
	title_divider = {
		vertical_alignment = "bottom",
		parent = "title_text",
		horizontal_alignment = "center",
		size = {
			78,
			28
		},
		position = {
			0,
			-45,
			1
		}
	},
	description_text = {
		vertical_alignment = "top",
		parent = "title_divider",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] - 40,
			300
		},
		position = {
			0,
			-50,
			1
		}
	},
	artist_text = {
		vertical_alignment = "bottom",
		parent = "info_window",
		horizontal_alignment = "center",
		size = {
			var_0_2[1] - 40,
			300
		},
		position = {
			0,
			10,
			1
		}
	}
}
local var_0_8 = {
	200,
	10,
	10,
	10
}
local var_0_9 = {
	dynamic_height = false,
	upper_case = true,
	localize = false,
	word_wrap = true,
	font_size = 32,
	vertical_alignment = "top",
	horizontal_alignment = "center",
	use_shadow = true,
	dynamic_font_size = false,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_10 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 26,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_11 = {
	word_wrap = true,
	upper_case = false,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 18,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}

local function var_0_12()
	local var_1_0 = true
	local var_1_1 = UIFrameSettings.frame_outer_glow_04
	local var_1_2 = var_1_1.texture_sizes.horizontal[2]
	local var_1_3 = UIFrameSettings.frame_outer_glow_01
	local var_1_4 = var_1_3.texture_sizes.horizontal[2]
	local var_1_5 = "frame_outer_glow_04_big"
	local var_1_6 = UIFrameSettings[var_1_5]
	local var_1_7 = var_1_6.texture_sizes.horizontal[2]
	local var_1_8 = "list_entry"
	local var_1_9 = var_0_7[var_1_8].size
	local var_1_10 = {
		{
			style_id = "background",
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			style_id = "title",
			pass_type = "text",
			text_id = "title",
			content_check_function = function(arg_2_0)
				return not arg_2_0.locked
			end
		},
		{
			style_id = "locked_title",
			pass_type = "text",
			text_id = "title",
			content_check_function = function(arg_3_0)
				return arg_3_0.locked
			end
		},
		{
			style_id = "title_shadow",
			pass_type = "text",
			text_id = "title"
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "edge_fade",
			texture_id = "edge_fade"
		},
		{
			pass_type = "texture_frame",
			style_id = "hover_frame",
			texture_id = "hover_frame"
		},
		{
			style_id = "new_frame",
			texture_id = "new_frame",
			pass_type = "texture_frame",
			content_check_function = function(arg_4_0)
				return arg_4_0.new and not arg_4_0.button_hotspot.is_hover
			end,
			content_change_function = function(arg_5_0, arg_5_1)
				local var_5_0 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

				arg_5_1.color[1] = 55 + var_5_0 * 200
			end
		},
		{
			pass_type = "texture",
			style_id = "dot_texture",
			texture_id = "dot_texture",
			content_check_function = function(arg_6_0)
				local var_6_0 = arg_6_0.locked
				local var_6_1 = arg_6_0.equipped
				local var_6_2 = arg_6_0.new
				local var_6_3 = arg_6_0.in_use

				return not var_6_0 and not var_6_1 and not var_6_2 and not var_6_3
			end
		},
		{
			pass_type = "texture",
			style_id = "lock_texture",
			texture_id = "lock_texture",
			content_check_function = function(arg_7_0)
				return arg_7_0.locked
			end
		},
		{
			pass_type = "texture",
			style_id = "equipped_texture",
			texture_id = "equipped_texture",
			content_check_function = function(arg_8_0)
				return arg_8_0.equipped
			end
		},
		{
			pass_type = "texture",
			style_id = "equipped_shadow_texture",
			texture_id = "equipped_texture",
			content_check_function = function(arg_9_0)
				return arg_9_0.equipped
			end
		},
		{
			pass_type = "texture",
			style_id = "in_use_texture",
			texture_id = "equipped_texture",
			content_check_function = function(arg_10_0)
				return arg_10_0.in_use and not arg_10_0.equipped
			end
		},
		{
			style_id = "new_texture",
			texture_id = "new_texture",
			pass_type = "texture",
			content_check_function = function(arg_11_0)
				return arg_11_0.new
			end,
			content_change_function = function(arg_12_0, arg_12_1)
				local var_12_0 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5

				arg_12_1.color[1] = 55 + var_12_0 * 200
			end
		},
		{
			pass_type = "texture_frame",
			style_id = "pulse_frame",
			texture_id = "pulse_frame"
		}
	}
	local var_1_11 = {
		background = "rect_masked",
		locked = false,
		title = "",
		lock_texture = "achievement_symbol_lock",
		equipped = false,
		equipped_texture = "matchmaking_checkbox",
		new_texture = "list_item_tag_new",
		edge_fade = "playername_bg_02",
		new = false,
		dot_texture = "tooltip_marker",
		button_hotspot = {},
		hover_frame = var_1_1.texture,
		new_frame = var_1_3.texture,
		pulse_frame = var_1_6.texture,
		size = var_1_9
	}
	local var_1_12 = {
		title = {
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_size = var_0_5,
			font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("font_default", 255),
			hover_text_color = Colors.get_color_table_with_alpha("white", 255),
			default_text_color = Colors.get_color_table_with_alpha("font_default", 255),
			offset = {
				40,
				0,
				2
			},
			size = {
				var_1_9[1] - 55,
				var_1_9[2]
			}
		},
		locked_title = {
			localize = false,
			horizontal_alignment = "left",
			vertical_alignment = "center",
			font_size = var_0_5,
			font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
			text_color = {
				255,
				80,
				80,
				80
			},
			hover_text_color = {
				255,
				80,
				80,
				80
			},
			default_text_color = {
				255,
				80,
				80,
				80
			},
			offset = {
				40,
				0,
				2
			},
			size = {
				var_1_9[1] - 55,
				var_1_9[2]
			}
		},
		title_shadow = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			localize = false,
			font_size = var_0_5,
			font_type = var_1_0 and "hell_shark_masked" or "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				41,
				-1,
				1
			},
			size = {
				var_1_9[1] - 55,
				var_1_9[2]
			}
		},
		background = {
			masked = var_1_0,
			size = {
				var_1_9[1] - 20,
				var_1_9[2]
			},
			color = {
				180,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		},
		edge_fade = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = var_1_0,
			texture_size = {
				20,
				var_1_9[2]
			},
			color = {
				180,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		},
		hover_frame = {
			masked = var_1_0,
			texture_size = var_1_1.texture_size,
			texture_sizes = var_1_1.texture_sizes,
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				6
			},
			size = {
				var_1_9[1],
				var_1_9[2]
			},
			frame_margins = {
				-var_1_2,
				-var_1_2
			}
		},
		pulse_frame = {
			horizontal_alignment = "left",
			vertical_alignment = "bottom",
			masked = var_1_0,
			area_size = var_1_9,
			texture_size = var_1_6.texture_size,
			texture_sizes = var_1_6.texture_sizes,
			frame_margins = {
				-var_1_7,
				-var_1_7
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				12
			}
		},
		new_frame = {
			masked = var_1_0,
			texture_size = var_1_3.texture_size,
			texture_sizes = var_1_3.texture_sizes,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				6
			},
			size = {
				var_1_9[1],
				var_1_9[2]
			},
			frame_margins = {
				-var_1_4,
				-var_1_4
			}
		},
		dot_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = var_1_0,
			texture_size = {
				13,
				13
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				11,
				-1,
				5
			}
		},
		lock_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = var_1_0,
			texture_size = {
				56,
				40
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-10,
				0,
				2
			}
		},
		equipped_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = var_1_0,
			texture_size = {
				37,
				31
			},
			color = Colors.get_color_table_with_alpha("green", 255),
			offset = {
				4,
				0,
				3
			}
		},
		equipped_shadow_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = var_1_0,
			texture_size = {
				37,
				31
			},
			color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				5,
				-1,
				2
			}
		},
		new_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = var_1_0,
			texture_size = {
				113.4,
				45.9
			},
			color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				-64,
				0,
				2
			}
		},
		in_use_texture = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = var_1_0,
			texture_size = {
				37,
				31
			},
			color = Colors.get_color_table_with_alpha("gray", 255),
			offset = {
				4,
				0,
				3
			}
		}
	}

	return {
		element = {
			passes = var_1_10
		},
		content = var_1_11,
		style = var_1_12,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = var_1_8
	}
end

local function var_0_13()
	local var_13_0 = true
	local var_13_1 = "list_entry"
	local var_13_2 = var_0_7[var_13_1].size
	local var_13_3 = {
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "edge_fade",
			texture_id = "edge_fade"
		}
	}
	local var_13_4 = {
		title = "",
		locked = false,
		background = "rect_masked",
		edge_fade = "playername_bg_02",
		new = false,
		equipped = false,
		button_hotspot = {},
		size = var_13_2
	}
	local var_13_5 = {
		background = {
			masked = var_13_0,
			size = {
				var_13_2[1] - 20,
				var_13_2[2]
			},
			color = {
				180,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		},
		edge_fade = {
			vertical_alignment = "center",
			horizontal_alignment = "right",
			masked = var_13_0,
			texture_size = {
				20,
				var_13_2[2]
			},
			color = {
				180,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				0
			}
		}
	}

	return {
		element = {
			passes = var_13_3
		},
		content = var_13_4,
		style = var_13_5,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = var_13_1
	}
end

local function var_0_14(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = {
		element = {}
	}
	local var_14_1 = {
		{
			pass_type = "rect",
			style_id = "background"
		},
		{
			pass_type = "texture_frame",
			style_id = "frame",
			texture_id = "frame"
		}
	}
	local var_14_2 = {
		frame = "menu_frame_13"
	}
	local var_14_3 = {
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = arg_14_1,
			color = arg_14_2 or {
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
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			area_size = arg_14_1,
			texture_size = {
				84,
				84
			},
			texture_sizes = {
				corner = {
					32,
					32
				},
				vertical = {
					27,
					1
				},
				horizontal = {
					1,
					27
				}
			},
			frame_margins = {
				-27,
				-27
			},
			color = arg_14_2 or {
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

	var_14_0.element.passes = var_14_1
	var_14_0.content = var_14_2
	var_14_0.style = var_14_3
	var_14_0.offset = {
		0,
		0,
		0
	}
	var_14_0.scenegraph_id = arg_14_0

	return var_14_0
end

local function var_0_15(arg_15_0, arg_15_1, arg_15_2)
	arg_15_2 = arg_15_2 or 20

	local var_15_0 = {
		passes = {
			{
				pass_type = "hotspot",
				content_id = "hotspot"
			},
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
	local var_15_1 = {
		mask_texture = "mask_rect",
		mask_edge = "mask_rect_edge_fade",
		hotspot = {}
	}
	local var_15_2 = {
		mask = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				arg_15_1[1],
				arg_15_1[2]
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
				arg_15_1[1],
				arg_15_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				arg_15_2,
				0
			}
		},
		mask_bottom = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				arg_15_1[1],
				arg_15_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				-arg_15_2,
				0
			},
			angle = math.pi,
			pivot = {
				arg_15_1[1] / 2,
				arg_15_2 / 2
			}
		}
	}

	return {
		element = var_15_0,
		content = var_15_1,
		style = var_15_2,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_15_0
	}
end

local var_0_16 = true
local var_0_17 = {
	list_detail_top = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "list_detail_top"),
	list_detail_bottom = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "list_detail_bottom"),
	list_scrollbar = UIWidgets.create_chain_scrollbar("list_scrollbar", "list_window", var_0_7.list_scrollbar.size, "gold"),
	list_mask = var_0_15("list_window", var_0_7.list_window.size, 10),
	title_text = UIWidgets.create_simple_text("n/a", "title_text", nil, nil, var_0_9),
	title_divider = UIWidgets.create_simple_texture("keep_decorations_divider_02", "title_divider"),
	description_text = UIWidgets.create_simple_text("n/a", "description_text", nil, nil, var_0_10),
	artist_text = UIWidgets.create_simple_text("n/a", "artist_text", nil, nil, var_0_11),
	background = UIWidgets.create_simple_texture("options_window_fade_01", "screen"),
	info_window = var_0_14("info_window", {
		var_0_2[1] - 20,
		var_0_2[2]
	}, var_0_8),
	info_bottom_right = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			0.5,
			1
		},
		{
			1,
			0
		}
	}, "info_bottom_right"),
	info_bottom_left = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			1,
			1
		},
		{
			0.5,
			0
		}
	}, "info_bottom_left"),
	info_top_right = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			0.5,
			0
		},
		{
			1,
			1
		}
	}, "info_top_right"),
	info_top_left = UIWidgets.create_simple_uv_texture("keep_decorations_01", {
		{
			1,
			0
		},
		{
			0.5,
			1
		}
	}, "info_top_left"),
	confirm_button = UIWidgets.create_default_button("confirm_button", var_0_7.confirm_button.size, "button_frame_01_gold", nil, Localize("menu_settings_apply"), 32, nil, "button_detail_01_gold", nil, var_0_16),
	close_button = UIWidgets.create_default_button("close_button", var_0_7.close_button.size, "button_frame_01_gold", nil, Localize("interaction_action_close"), 32, nil, "button_detail_01_gold", nil, var_0_16)
}
local var_0_18 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
				arg_16_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
				local var_17_0 = math.easeOutCubic(arg_17_3)

				arg_17_4.render_settings.alpha_multiplier = var_17_0

				local var_17_1 = 200 * (1 - var_17_0)
				local var_17_2 = arg_17_1.info_window.position

				arg_17_0.info_window.position[1] = var_17_2[1] + var_17_1

				local var_17_3 = arg_17_1.close_button.position

				arg_17_0.close_button.position[1] = var_17_3[1] + var_17_1

				local var_17_4 = arg_17_1.list_window.position

				arg_17_0.list_window.position[1] = var_17_4[1] - var_17_1

				local var_17_5 = arg_17_1.confirm_button.position

				arg_17_0.confirm_button.position[2] = var_17_5[2] - var_17_1
			end,
			on_complete = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
				return
			end
		}
	}
}
local var_0_19 = {
	{
		input_action = "back",
		priority = 3,
		description_text = "input_description_close"
	}
}
local var_0_20 = {
	default = {
		actions = {
			{
				input_action = "confirm",
				priority = 2,
				description_text = "input_description_apply"
			}
		}
	},
	remove = {
		actions = {
			{
				input_action = "confirm",
				priority = 2,
				description_text = "input_description_remove"
			}
		}
	}
}

return {
	input_actions = var_0_20,
	entry_widget_definition = var_0_12(),
	dummy_entry_widget_definition = var_0_13(),
	animation_definitions = var_0_18,
	generic_input_actions = var_0_19,
	scenegraph_definition = var_0_7,
	widgets_definitions = var_0_17
}
