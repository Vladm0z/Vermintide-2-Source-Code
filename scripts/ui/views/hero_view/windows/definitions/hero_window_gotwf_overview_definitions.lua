-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_overview_definitions.lua

local var_0_0 = UISettings.game_start_windows
local var_0_1 = var_0_0.size
local var_0_2 = var_0_0.spacing
local var_0_3 = var_0_0.large_window_frame
local var_0_4 = UIFrameSettings[var_0_3].texture_sizes.vertical[1]
local var_0_5 = {
	var_0_1[1] * 3 + var_0_2 * 2 + var_0_4 * 2,
	var_0_1[2] + 80
}
local var_0_6 = {
	var_0_5[1] + 50,
	var_0_5[2]
}
local var_0_7 = "menu_frame_11"
local var_0_8 = UIFrameSettings[var_0_7].texture_sizes.vertical[1]
local var_0_9 = UISettings.game_start_windows
local var_0_10 = 20
local var_0_11 = 0.845
local var_0_12 = {
	59,
	31
}
local var_0_13 = {
	260 * var_0_11,
	250 * var_0_11
}
local var_0_14 = {
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
	black_background = {
		vertical_alignment = "bottom",
		horizontal_alignment = "center",
		scale = "fit_width",
		size = {
			1920,
			200
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	black_background_fade = {
		vertical_alignment = "bottom",
		horizontal_alignment = "center",
		scale = "fit_width",
		size = {
			1920,
			200
		},
		position = {
			0,
			200,
			UILayer.default
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
			UILayer.default
		}
	},
	viewport = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			800,
			500
		},
		position = {
			0,
			-115,
			1
		}
	},
	screen_top = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.item_display_popup
		}
	},
	screen_left = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "left",
		size = {
			0,
			0
		},
		position = {
			0,
			0,
			1
		}
	},
	screen_center = {
		vertical_alignment = "top",
		parent = "screen",
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
	window = {
		vertical_alignment = "top",
		parent = "screen_center",
		horizontal_alignment = "left",
		size = var_0_6,
		position = {
			(1920 - var_0_6[1]) * 0.5,
			(1080 - var_0_6[2]) * 0.5 * -1,
			1
		}
	},
	write_mask = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			var_0_6[1],
			var_0_6[2] + 100
		},
		position = {
			0,
			0,
			1
		}
	},
	write_mask_left = {
		vertical_alignment = "bottom",
		parent = "write_mask",
		horizontal_alignment = "left",
		size = {
			50,
			440
		},
		position = {
			-25,
			0,
			1
		}
	},
	write_mask_right = {
		vertical_alignment = "bottom",
		parent = "write_mask",
		horizontal_alignment = "right",
		size = {
			50,
			440
		},
		position = {
			25,
			0,
			1
		}
	},
	scrollbar_area = {
		vertical_alignment = "bottom",
		parent = "write_mask",
		horizontal_alignment = "center",
		size = {
			var_0_6[1],
			var_0_13[2] + 70
		},
		position = {
			0,
			100,
			50
		}
	},
	window_anchor = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		position = {
			0,
			-350,
			2
		}
	},
	gotwf_logo_foreground = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			460.8,
			527.2
		},
		position = {
			-650,
			10,
			1
		}
	},
	gotwf_logo_flag = {
		vertical_alignment = "top",
		parent = "gotwf_logo_foreground",
		horizontal_alignment = "center",
		size = {
			407.20000000000005,
			572.8000000000001
		},
		position = {
			8,
			-40,
			0
		}
	},
	gotwf_logo_banner_left = {
		vertical_alignment = "center",
		parent = "gotwf_logo_foreground",
		horizontal_alignment = "left",
		size = {
			133.6,
			201.60000000000002
		},
		position = {
			-37,
			-65,
			-2
		}
	},
	gotwf_logo_banner_right = {
		vertical_alignment = "center",
		parent = "gotwf_logo_foreground",
		horizontal_alignment = "right",
		size = {
			133.6,
			201.60000000000002
		},
		position = {
			50,
			-65,
			-2
		}
	},
	gotwf_description = {
		vertical_alignment = "bottom",
		parent = "gotwf_logo_foreground",
		horizontal_alignment = "center",
		position = {
			0,
			-240,
			0
		}
	},
	gotwf_window = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			1600,
			250
		},
		position = {
			0,
			39,
			2
		}
	},
	gotwf_item_anchor = {
		parent = "gotwf_window",
		size = var_0_13,
		position = {
			0,
			15,
			0
		}
	},
	arrow_left = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			100,
			100
		},
		position = {
			-70,
			115,
			0
		}
	},
	arrow_right = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			100,
			100
		},
		position = {
			70,
			115,
			0
		}
	},
	claim_button = {
		vertical_alignment = "bottom",
		parent = "gotwf_item_anchor",
		horizontal_alignment = "center",
		position = {
			10,
			25,
			5
		},
		size = {
			var_0_13[1],
			60
		}
	},
	lock_root = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1,
			1
		},
		position = {
			0,
			-1600,
			10
		}
	},
	lock_bg_left = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			167,
			333
		},
		position = {
			0,
			0,
			3
		}
	},
	lock_bg_right = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "left",
		size = {
			167,
			333
		},
		position = {
			167,
			0,
			3
		}
	},
	lock_pillar_left = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			210,
			231
		},
		position = {
			1,
			0,
			1
		}
	},
	lock_pillar_right = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			210,
			231
		},
		position = {
			210,
			0,
			1
		}
	},
	lock_pillar_top = {
		vertical_alignment = "top",
		parent = "lock_root",
		horizontal_alignment = "center",
		size = {
			231,
			212
		},
		position = {
			1,
			212,
			1
		}
	},
	lock_pillar_bottom = {
		vertical_alignment = "top",
		parent = "lock_root",
		horizontal_alignment = "center",
		size = {
			231,
			212
		},
		position = {
			0,
			0,
			1
		}
	},
	lock_cogwheel_bg_left = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			170,
			342
		},
		position = {
			0,
			0,
			7
		}
	},
	lock_cogwheel_bg_right = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			172,
			342
		},
		position = {
			172,
			0,
			7
		}
	},
	lock_cogwheel_left = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			158,
			316
		},
		position = {
			0,
			0,
			6
		}
	},
	lock_cogwheel_right = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			158,
			316
		},
		position = {
			158,
			0,
			6
		}
	},
	lock_stick_top_left = {
		vertical_alignment = "top",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			125,
			127
		},
		position = {
			0,
			127,
			2
		}
	},
	lock_stick_top_right = {
		vertical_alignment = "top",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			125,
			127
		},
		position = {
			125,
			127,
			2
		}
	},
	lock_stick_bottom_left = {
		vertical_alignment = "top",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			125,
			127
		},
		position = {
			0,
			0,
			2
		}
	},
	lock_stick_bottom_right = {
		vertical_alignment = "top",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			125,
			127
		},
		position = {
			125,
			0,
			2
		}
	},
	lock_block_left = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			153,
			149
		},
		position = {
			0,
			0,
			5
		}
	},
	lock_block_right = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "left",
		size = {
			153,
			149
		},
		position = {
			-153,
			0,
			5
		}
	},
	lock_slot_holder_left = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			52,
			303
		},
		position = {
			-1,
			0,
			4
		}
	},
	lock_slot_holder_right = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "left",
		size = {
			52,
			303
		},
		position = {
			0,
			0,
			4
		}
	},
	lock_cover_top_left = {
		vertical_alignment = "top",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			142,
			151
		},
		position = {
			0,
			151,
			9
		}
	},
	lock_cover_top_right = {
		vertical_alignment = "top",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			146,
			152
		},
		position = {
			146,
			152,
			9
		}
	},
	lock_cover_bottom_left = {
		vertical_alignment = "top",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			141,
			150
		},
		position = {
			0,
			0,
			9
		}
	},
	lock_cover_bottom_right = {
		vertical_alignment = "top",
		parent = "lock_root",
		horizontal_alignment = "right",
		size = {
			146,
			149
		},
		position = {
			146,
			0,
			9
		}
	},
	frame_right = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "center",
		size = {
			116,
			290
		},
		position = {
			0,
			0,
			0
		}
	},
	frame_bottom = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "center",
		size = {
			116,
			290
		},
		position = {
			0,
			0,
			0
		}
	},
	frame_left = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "center",
		size = {
			116,
			290
		},
		position = {
			0,
			0,
			0
		}
	},
	frame_top = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "center",
		size = {
			116,
			290
		},
		position = {
			0,
			0,
			0
		}
	},
	mask_left = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "center",
		size = {
			120,
			270
		},
		position = {
			0,
			5,
			480
		}
	},
	mask_right = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "center",
		size = {
			120,
			270
		},
		position = {
			0,
			5,
			480
		}
	},
	mask_top = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "center",
		size = {
			260,
			120
		},
		position = {
			0,
			-5,
			480
		}
	},
	mask_bottom = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "center",
		size = {
			260,
			120
		},
		position = {
			0,
			-5,
			480
		}
	},
	mask_center = {
		vertical_alignment = "center",
		parent = "lock_root",
		horizontal_alignment = "center",
		size = {
			260,
			260
		},
		position = {
			0,
			0,
			480
		}
	}
}
local var_0_15 = {
	font_size = 32,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = {
		255,
		192,
		192,
		192
	},
	offset = {
		0,
		0,
		2
	}
}

local function var_0_16(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = {
		element = {}
	}
	local var_1_1 = {}
	local var_1_2 = {}
	local var_1_3 = {}
	local var_1_4 = "item_icon"

	var_1_1[#var_1_1 + 1] = {
		pass_type = "texture",
		texture_id = var_1_4,
		style_id = var_1_4,
		content_check_function = function(arg_2_0)
			return arg_2_0[var_1_4]
		end
	}
	var_1_3[var_1_4] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		masked = arg_1_4,
		texture_size = arg_1_2,
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
	var_1_2[var_1_4] = arg_1_1

	local var_1_5 = "item_frame"

	var_1_1[#var_1_1 + 1] = {
		pass_type = "texture",
		texture_id = var_1_5,
		style_id = var_1_5,
		content_check_function = function(arg_3_0)
			return arg_3_0[var_1_4]
		end
	}
	var_1_3[var_1_5] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		masked = arg_1_4,
		texture_size = arg_1_2,
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
	}
	var_1_2[var_1_5] = "item_frame"

	local var_1_6 = "rarity_texture"

	var_1_1[#var_1_1 + 1] = {
		pass_type = "texture",
		texture_id = var_1_6,
		style_id = var_1_6,
		content_check_function = function(arg_4_0)
			return arg_4_0[var_1_4]
		end
	}
	var_1_3[var_1_6] = {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		masked = arg_1_4,
		texture_size = arg_1_2,
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
	var_1_2[var_1_6] = "icon_bg_default"
	var_1_0.element.passes = var_1_1
	var_1_0.content = var_1_2
	var_1_0.style = var_1_3
	var_1_0.offset = arg_1_3 or {
		0,
		0,
		0
	}
	var_1_0.scenegraph_id = arg_1_0

	return var_1_0
end

local var_0_17 = 50

local function var_0_18(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10)
	local var_5_0 = "menu_frame_16"
	local var_5_1 = UIFrameSettings[var_5_0]
	local var_5_2 = "frame_outer_glow_04"
	local var_5_3 = UIFrameSettings[var_5_2]
	local var_5_4 = var_5_3.texture_sizes.horizontal[2]
	local var_5_5 = "frame_outer_glow_04_big"
	local var_5_6 = UIFrameSettings[var_5_5]
	local var_5_7 = var_5_6.texture_sizes.horizontal[2]
	local var_5_8 = "menu_frame_08"
	local var_5_9 = UIFrameSettings[var_5_8]
	local var_5_10 = var_5_9.texture_sizes.horizontal[2]
	local var_5_11 = (arg_5_4 or arg_5_7 and not arg_5_8 or arg_5_6) and 255 or 60
	local var_5_12 = 75
	local var_5_13 = arg_5_10 and arg_5_10.bundle and 1 or arg_5_7 and 1 or arg_5_10 and #arg_5_10 or 1
	local var_5_14 = 1 - (var_5_13 - 1) * 0.25
	local var_5_15 = 0
	local var_5_16 = {
		element = {}
	}
	local var_5_17 = {}
	local var_5_18 = {}
	local var_5_19 = {}
	local var_5_20 = {
		{
			style_id = "date_text",
			pass_type = "text",
			text_id = "date_text"
		},
		{
			style_id = "date_text_shadow",
			pass_type = "text",
			text_id = "date_text"
		},
		{
			pass_type = "texture",
			style_id = "owned_icon",
			texture_id = "owned_icon",
			content_check_function = function(arg_6_0)
				return arg_6_0.owned
			end
		},
		{
			pass_type = "texture",
			style_id = "owned_icon_bg",
			texture_id = "owned_icon_bg",
			content_check_function = function(arg_7_0)
				return arg_7_0.owned
			end
		},
		{
			style_id = "loading_icon",
			pass_type = "rotated_texture",
			texture_id = "loading_icon",
			content_check_function = function(arg_8_0)
				local var_8_0 = true

				for iter_8_0 = 1, var_5_13 do
					if not arg_8_0["icon_" .. iter_8_0] then
						var_8_0 = false

						break
					end
				end

				return not var_8_0 and not arg_8_0.hidden and not arg_8_0.disable_loading_icon
			end,
			content_change_function = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				local var_9_0 = ((arg_9_1.progress or 0) + arg_9_3) % 1

				arg_9_1.angle = math.pow(2, math.smoothstep(var_9_0, 0, 1)) * (math.pi * 2)
				arg_9_1.progress = var_9_0
			end
		},
		{
			pass_type = "texture",
			style_id = "package_icon",
			texture_id = "package_icon",
			content_check_function = function(arg_10_0)
				return arg_10_0.hidden
			end
		}
	}
	local var_5_21 = {}

	for iter_5_0 = 1, var_5_13 do
		var_5_21[#var_5_21 + 1] = iter_5_0
	end

	local var_5_22 = {
		loading_icon = "loot_loading",
		owned_icon_bg = "store_owned_ribbon",
		owned_icon = "store_owned_sigil",
		masked_rect = "rect_masked",
		rect = "store_thumbnail_bg_plentiful",
		package_icon = "store_package",
		hidden = arg_5_7,
		frame = var_5_1.texture,
		hover_frame = var_5_3.texture,
		pulse_frame = var_5_6.texture,
		size = arg_5_1,
		date_text = arg_5_5,
		current_reward = arg_5_4,
		owned = arg_5_6,
		painting_frame = var_5_9.texture,
		num_rewards = var_5_13,
		rewards = arg_5_10,
		reward_order = var_5_21
	}
	local var_5_23 = {
		date_text = {
			font_size = 32,
			upper_case = true,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			dynamic_font_size = false,
			font_type = arg_5_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = arg_5_4 and Colors.get_color_table_with_alpha("font_title", 255) or Colors.get_color_table_with_alpha("gray", 255),
			offset = {
				0,
				-20 - ((arg_5_4 or arg_5_9) and not arg_5_6 and var_5_12 or 0),
				10
			}
		},
		date_text_shadow = {
			font_size = 32,
			upper_case = true,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "bottom",
			dynamic_font_size = false,
			font_type = arg_5_2 and "hell_shark_header_masked" or "hell_shark_header",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				-22 - ((arg_5_4 or arg_5_9) and not arg_5_6 and var_5_12 or 0),
				9
			}
		},
		loading_icon = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = true,
			angle = 0,
			pivot = {
				50,
				50
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_5_1[1] * 0.5 - 50,
				-50,
				8
			},
			texture_size = {
				100,
				100
			}
		},
		owned_icon = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			masked = arg_5_2,
			texture_size = {
				53,
				53
			},
			default_texture_size = {
				53,
				53
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				2,
				20,
				12 + 16 * (var_5_13 - 1)
			},
			default_offset = {
				5,
				20,
				12 + 16 * (var_5_13 - 1)
			}
		},
		owned_icon_bg = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			masked = arg_5_2,
			texture_size = {
				34,
				50
			},
			default_texture_size = {
				34,
				50
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-10,
				-0,
				11 + 16 * (var_5_13 - 1)
			},
			default_offset = {
				2,
				-45,
				11 + 16 * (var_5_13 - 1)
			}
		},
		package_icon = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			masked = arg_5_2,
			texture_size = arg_5_1,
			color = {
				255,
				var_5_11,
				var_5_11,
				var_5_11
			},
			offset = {
				0,
				0,
				7
			}
		}
	}

	table.append(var_5_17, var_5_20)
	table.merge(var_5_18, var_5_22)
	table.merge(var_5_19, var_5_23)

	local var_5_24 = arg_5_1

	for iter_5_1 = 1, var_5_13 do
		local var_5_25 = {
			(iter_5_1 - 1) * var_0_17,
			(iter_5_1 - 1) * -var_0_17,
			(iter_5_1 - 1) * 15
		}
		local var_5_26 = {
			var_5_24[1] * var_5_14,
			var_5_24[2] * var_5_14
		}
		local var_5_27 = {
			{
				pass_type = "hotspot",
				content_id = "hotspot_" .. iter_5_1,
				style_id = "hotspot_" .. iter_5_1
			},
			{
				pass_type = "texture",
				texture_id = "rect",
				style_id = "overlay_" .. iter_5_1
			},
			{
				pass_type = "texture",
				texture_id = "rect",
				style_id = "background_rect_" .. iter_5_1
			},
			{
				pass_type = "texture",
				texture_id = "background_" .. iter_5_1,
				style_id = "background_" .. iter_5_1,
				content_check_function = function(arg_11_0)
					return arg_11_0["background_" .. iter_5_1]
				end
			},
			{
				pass_type = "texture_frame",
				texture_id = "frame",
				style_id = "frame_" .. iter_5_1
			},
			{
				pass_type = "texture_frame",
				texture_id = "hover_frame",
				style_id = "hover_frame_" .. iter_5_1
			},
			{
				pass_type = "texture_frame",
				texture_id = "pulse_frame",
				style_id = "pulse_frame_" .. iter_5_1
			},
			{
				pass_type = "texture_uv",
				content_id = "painting_" .. iter_5_1,
				style_id = "painting_" .. iter_5_1,
				content_check_function = function(arg_12_0)
					return arg_12_0.texture_id
				end
			},
			{
				pass_type = "texture_frame",
				texture_id = "painting_frame",
				style_id = "painting_frame_" .. iter_5_1,
				content_check_function = function(arg_13_0)
					return arg_13_0.painting
				end
			},
			{
				pass_type = "texture",
				texture_id = "icon_" .. iter_5_1,
				style_id = "icon_" .. iter_5_1,
				content_check_function = function(arg_14_0)
					return arg_14_0["icon_" .. iter_5_1] and not arg_14_0.rendering_loading_icon
				end
			},
			{
				pass_type = "texture",
				texture_id = "type_tag_icon_" .. iter_5_1,
				style_id = "type_tag_icon_" .. iter_5_1,
				content_check_function = function(arg_15_0)
					return arg_15_0["type_tag_icon_" .. iter_5_1] ~= nil
				end
			}
		}
		local var_5_28 = {
			["hotspot_" .. iter_5_1] = {},
			["icon_" .. iter_5_1] = nil,
			["painting_" .. iter_5_1] = nil,
			["background_" .. iter_5_1] = nil,
			["type_tag_icon_" .. iter_5_1] = nil
		}
		local var_5_29 = {
			["hotspot_" .. iter_5_1] = {
				size = {
					var_0_13[1] * var_5_14,
					var_0_13[2]
				},
				base_offset = {
					0,
					0,
					0
				},
				offset = {
					0 + var_5_25[1],
					0 + var_5_25[2],
					0 + var_5_25[3]
				}
			},
			["background_rect_" .. iter_5_1] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				masked = arg_5_2,
				texture_size = var_5_26,
				color = {
					255,
					255,
					255,
					255
				},
				base_offset = {
					0,
					0,
					0
				},
				offset = {
					0 + var_5_25[1],
					0 + var_5_25[2],
					0 + var_5_25[3]
				}
			},
			["background_" .. iter_5_1] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				masked = arg_5_2,
				texture_size = var_5_26,
				color = {
					255,
					255,
					255,
					255
				},
				base_offset = {
					0,
					0,
					1
				},
				offset = {
					0 + var_5_25[1],
					0 + var_5_25[2],
					1 + var_5_25[3]
				}
			},
			["overlay_" .. iter_5_1] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				masked = arg_5_2,
				texture_size = var_5_26,
				color = {
					0,
					5,
					5,
					5
				},
				base_offset = {
					0,
					0,
					8
				},
				offset = {
					0 + var_5_25[1],
					0 + var_5_25[2],
					8 + var_5_25[3]
				}
			},
			["type_tag_icon_" .. iter_5_1] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				masked = arg_5_2,
				texture_size = {
					56,
					56
				},
				color = {
					255,
					var_5_11,
					var_5_11,
					var_5_11
				},
				base_offset = {
					var_5_26[1] - 56,
					0,
					9
				},
				offset = {
					var_5_26[1] - 56 + var_5_25[1],
					0 + var_5_25[2],
					9 + var_5_25[3]
				}
			},
			["icon_" .. iter_5_1] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				masked = arg_5_2,
				texture_size = var_5_26,
				color = {
					255,
					var_5_11,
					var_5_11,
					var_5_11
				},
				base_offset = {
					0,
					0,
					7
				},
				offset = {
					0 + var_5_25[1],
					0 + var_5_25[2],
					7 + var_5_25[3]
				}
			},
			["frame_" .. iter_5_1] = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				masked = arg_5_2,
				area_size = var_5_26,
				texture_size = var_5_1.texture_size,
				texture_sizes = var_5_1.texture_sizes,
				frame_margins = {
					0,
					0
				},
				color = {
					255,
					var_5_11,
					var_5_11,
					var_5_11
				},
				base_offset = {
					0,
					0,
					10
				},
				offset = {
					0 + var_5_25[1],
					0 + var_5_25[2],
					10 + var_5_25[3]
				}
			},
			["hover_frame_" .. iter_5_1] = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				masked = arg_5_2,
				area_size = var_5_26,
				texture_size = var_5_3.texture_size,
				texture_sizes = var_5_3.texture_sizes,
				frame_margins = {
					-var_5_4,
					-var_5_4
				},
				color = {
					0,
					255,
					255,
					255
				},
				base_offset = {
					0,
					0,
					6
				},
				offset = {
					0 + var_5_25[1],
					0 + var_5_25[2],
					6 + var_5_25[3]
				}
			},
			["pulse_frame_" .. iter_5_1] = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				masked = arg_5_2,
				area_size = var_5_26,
				texture_size = var_5_6.texture_size,
				texture_sizes = var_5_6.texture_sizes,
				frame_margins = {
					-var_5_7,
					-var_5_7
				},
				color = {
					0,
					255,
					255,
					255
				},
				base_offset = {
					0,
					0,
					12
				},
				offset = {
					0 + var_5_25[1],
					0 + var_5_25[2],
					12 + var_5_25[3]
				}
			},
			["painting_" .. iter_5_1] = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				masked = arg_5_2,
				texture_size = var_5_26,
				color = {
					255,
					var_5_11,
					var_5_11,
					var_5_11
				},
				base_offset = {
					0,
					0,
					7
				},
				offset = {
					0 + var_5_25[1],
					0 + var_5_25[2],
					7 + var_5_25[3]
				}
			},
			["painting_frame_" .. iter_5_1] = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				masked = arg_5_2,
				area_size = var_5_26,
				texture_size = var_5_9.texture_size,
				texture_sizes = var_5_9.texture_sizes,
				frame_margins = {
					-var_5_10,
					-var_5_10
				},
				color = {
					255,
					255,
					255,
					255
				},
				base_offset = {
					0,
					0,
					12
				},
				offset = {
					0 + var_5_25[1],
					0 + var_5_25[2],
					12 + var_5_25[3]
				}
			}
		}

		table.append(var_5_17, var_5_27)
		table.merge(var_5_18, var_5_28)
		table.merge(var_5_19, var_5_29)
	end

	var_5_16.element.passes = var_5_17
	var_5_16.content = var_5_18
	var_5_16.style = var_5_19
	var_5_16.offset = {
		10 + (arg_5_3 - 1) * (arg_5_1[1] + var_0_10),
		(arg_5_4 or arg_5_9) and not arg_5_6 and var_5_12 or 0,
		5
	}
	var_5_16.scenegraph_id = arg_5_0

	return var_5_16
end

local function var_0_19(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9)
	return {
		element = {
			passes = {
				{
					style_id = "hotspot",
					pass_type = "hotspot",
					content_id = "hotspot"
				},
				{
					texture_id = "arrow",
					style_id = "arrow",
					pass_type = "rotated_texture"
				},
				{
					texture_id = "arrow_hover",
					style_id = "arrow_hover",
					pass_type = "rotated_texture",
					content_check_function = function(arg_17_0, arg_17_1)
						return arg_17_0.hotspot.is_hover
					end
				}
			}
		},
		content = {
			hotspot = {},
			arrow = arg_16_0,
			arrow_hover = arg_16_1,
			disable_with_gamepad = arg_16_9
		},
		style = {
			hotspot = {
				color = arg_16_6 or {
					255,
					255,
					255,
					255
				},
				offset = {
					-25,
					-25,
					arg_16_7 or 0
				}
			},
			arrow = {
				masked = arg_16_5,
				angle = arg_16_2,
				pivot = arg_16_3,
				texture_size = var_0_12,
				color = arg_16_6 or {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					arg_16_7 or 0
				}
			},
			arrow_hover = {
				masked = arg_16_5,
				angle = arg_16_2,
				pivot = arg_16_3,
				texture_size = var_0_12,
				color = arg_16_6 or {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					(arg_16_7 or 0) + 1
				}
			}
		},
		offset = arg_16_8 or {
			0,
			0,
			0
		},
		scenegraph_id = arg_16_4
	}
end

function create_claim_button_definition(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5, arg_18_6, arg_18_7, arg_18_8, arg_18_9, arg_18_10, arg_18_11)
	arg_18_3 = arg_18_3 or "button_bg_01"

	local var_18_0 = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_18_3)
	local var_18_1 = arg_18_2 and UIFrameSettings[arg_18_2] or UIFrameSettings.button_frame_01
	local var_18_2 = var_18_1.texture_sizes.corner[1]
	local var_18_3 = arg_18_7 or "button_detail_01"
	local var_18_4 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_18_3).size
	local var_18_5
	local var_18_6
	local var_18_7 = "frame_outer_glow_04"
	local var_18_8 = UIFrameSettings[var_18_7]
	local var_18_9 = var_18_8.texture_sizes.horizontal[2]

	if arg_18_8 then
		if type(arg_18_8) == "table" then
			var_18_5 = arg_18_8[1]
			var_18_6 = arg_18_8[2]
		else
			var_18_5 = arg_18_8
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
					content_check_function = function(arg_19_0)
						return arg_19_0.draw_frame
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
					pass_type = "rect",
					style_id = "clicked_rect"
				},
				{
					style_id = "disabled_rect",
					pass_type = "rect",
					content_check_function = function(arg_20_0)
						return arg_20_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function(arg_21_0)
						return not arg_21_0.skip_side_detail
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function(arg_22_0)
						return not arg_22_0.skip_side_detail
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_23_0)
						return not arg_23_0.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function(arg_24_0)
						return arg_24_0.button_hotspot.disable_button
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
					style_id = "hover_frame",
					texture_id = "hover_frame",
					pass_type = "texture_frame",
					content_check_function = function(arg_25_0)
						return (Managers.input:is_device_active("gamepad"))
					end,
					content_change_function = function(arg_26_0, arg_26_1)
						local var_26_0 = 2
						local var_26_1, var_26_2 = Managers.time:time_and_delta("main")
						local var_26_3 = arg_26_0.gamepad_selected
						local var_26_4 = arg_26_0.gamepad_selection_progress
						local var_26_5 = 0

						if var_26_3 then
							var_26_4 = math.min(var_26_4 + var_26_2 * var_26_0, 1)
							var_26_5 = math.easeOutCubic(var_26_4)
						else
							var_26_4 = math.max(var_26_4 - var_26_2 * var_26_0, 0)
							var_26_5 = math.easeInCubic(var_26_4)
						end

						arg_26_1.color[1] = var_26_5 * 255
						arg_26_0.gamepad_selection_progress = var_26_4
					end
				}
			}
		},
		content = {
			draw_frame = true,
			hover_glow = "button_state_default",
			glass = "button_glass_02",
			background_fade = "button_bg_fade",
			gamepad_selection_progress = 0,
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
				texture_id = var_18_3,
				skip_side_detail = arg_18_10
			},
			button_hotspot = {},
			title_text = arg_18_4 or "n/a",
			frame = var_18_1.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_18_1[2] / var_18_0.size[2]
					},
					{
						arg_18_1[1] / var_18_0.size[1],
						1
					}
				},
				texture_id = arg_18_3
			},
			disable_with_gamepad = arg_18_9,
			hover_frame = var_18_8.texture
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
				},
				masked = arg_18_11
			},
			background_fade = {
				color = {
					200,
					255,
					255,
					255
				},
				offset = {
					var_18_2,
					var_18_2 - 2,
					2
				},
				size = {
					arg_18_1[1] - var_18_2 * 2,
					arg_18_1[2] - var_18_2 * 2
				},
				masked = arg_18_11
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
					var_18_2 - 2,
					3
				},
				size = {
					arg_18_1[1],
					math.min(arg_18_1[2] - 5, 80)
				},
				masked = arg_18_11
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
				font_size = arg_18_5 or 24,
				font_type = arg_18_11 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
				select_text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					arg_18_1[1] - 40,
					arg_18_1[2]
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
				font_size = arg_18_5 or 24,
				font_type = arg_18_11 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("gray", 255),
				default_text_color = Colors.get_color_table_with_alpha("gray", 255),
				size = {
					arg_18_1[1] - 40,
					arg_18_1[2]
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
				font_size = arg_18_5 or 24,
				font_type = arg_18_11 and "hell_shark_masked" or "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				default_text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					arg_18_1[1] - 40,
					arg_18_1[2]
				},
				offset = {
					22,
					-2,
					5
				}
			},
			frame = {
				texture_size = var_18_1.texture_size,
				texture_sizes = var_18_1.texture_sizes,
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
				masked = arg_18_11
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
					arg_18_1[2] - (var_18_2 + 11),
					4
				},
				size = {
					arg_18_1[1],
					11
				},
				masked = arg_18_11
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
					var_18_2 - 9,
					4
				},
				size = {
					arg_18_1[1],
					11
				},
				masked = arg_18_11
			},
			side_detail_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_18_5 and -var_18_5 or -9,
					arg_18_1[2] / 2 - var_18_4[2] / 2 + (var_18_6 or 0),
					9
				},
				size = {
					var_18_4[1],
					var_18_4[2]
				},
				masked = arg_18_11
			},
			side_detail_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_18_1[1] - var_18_4[1] + (var_18_5 or 9),
					arg_18_1[2] / 2 - var_18_4[2] / 2 + (var_18_6 or 0),
					9
				},
				size = {
					var_18_4[1],
					var_18_4[2]
				},
				masked = arg_18_11
			},
			hover_frame = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				masked = arg_18_11,
				area_size = arg_18_1,
				texture_size = var_18_8.texture_size,
				texture_sizes = var_18_8.texture_sizes,
				frame_margins = {
					-var_18_9,
					-var_18_9
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
					6
				}
			}
		},
		scenegraph_id = arg_18_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_20 = false
local var_0_21 = true
local var_0_22 = true

local function var_0_23()
	return create_claim_button_definition("claim_button", var_0_14.claim_button.size, nil, nil, Localize("welcome_currency_popup_button_claim"), 26, nil, nil, nil, var_0_20, var_0_21, var_0_22)
end

local var_0_24 = {
	black_background = UIWidgets.create_simple_rect("black_background", {
		255,
		0,
		0,
		0
	}),
	black_background_fade = UIWidgets.create_simple_texture("vertical_gradient", "black_background_fade", nil, nil, {
		255,
		0,
		0,
		0
	})
}
local var_0_25 = {
	bg_black = UIWidgets.create_simple_rect("screen", {
		255,
		0,
		0,
		0
	})
}
local var_0_26 = {
	frame_bg = UIWidgets.create_simple_texture("store_thumbnail_bg_plentiful", "viewport", true, nil, nil, 1),
	left_mask = UIWidgets.create_simple_texture("mask_rect", "mask_left", nil, nil, {
		0,
		255,
		255,
		255
	}),
	right_mask = UIWidgets.create_simple_texture("mask_rect", "mask_right", nil, nil, {
		0,
		255,
		255,
		255
	}),
	top_mask = UIWidgets.create_simple_texture("mask_rect", "mask_top", nil, nil, {
		0,
		255,
		255,
		255
	}),
	bottom_mask = UIWidgets.create_simple_texture("mask_rect", "mask_bottom", nil, nil, {
		0,
		255,
		255,
		255
	}),
	center_mask = UIWidgets.create_simple_texture("mask_rect", "mask_center", nil, nil, {
		0,
		255,
		255,
		255
	})
}
local var_0_27 = {
	arrow_left = var_0_19("achievement_arrow", "achievement_arrow_hover", math.pi * 0.5, {
		var_0_12[1] * 0.5,
		var_0_12[2] * 0.5
	}, "arrow_left", false, {
		255,
		255,
		255,
		255
	}, 0, {
		0,
		0,
		0
	}),
	arrow_right = var_0_19("achievement_arrow", "achievement_arrow_hover", -math.pi * 0.5, {
		var_0_12[1] * 0.5,
		var_0_12[2] * 0.5
	}, "arrow_right", false, {
		255,
		255,
		255,
		255
	}, 0, {
		41,
		0,
		0
	}),
	gotwf_logo_foreground = UIWidgets.create_simple_texture("gotwf_foreground", "gotwf_logo_foreground"),
	gotwf_logo_flag = UIWidgets.create_simple_texture("gotwf_flag", "gotwf_logo_flag"),
	gotwf_logo_banner_left = UIWidgets.create_simple_texture("gotwf_banner_left", "gotwf_logo_banner_left"),
	gotwf_logo_banner_right = UIWidgets.create_simple_texture("gotwf_banner_right", "gotwf_logo_banner_right"),
	gotwf_description = UIWidgets.create_simple_text("", "gotwf_description", nil, nil, var_0_15),
	write_mask = UIWidgets.create_simple_texture("mask_rect", "write_mask", false, false, {
		255,
		255,
		255,
		255
	}, 0),
	left_fade_mask = UIWidgets.create_simple_texture("horizontal_gradient_mask", "write_mask_left", false, false, {
		255,
		255,
		255,
		255
	}, 0),
	right_fade_mask = UIWidgets.create_simple_uv_texture("horizontal_gradient_mask", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "write_mask_right", false, false, {
		255,
		255,
		255,
		255
	}, 0)
}
local var_0_28 = {
	lock_bg_left = UIWidgets.create_simple_rotated_texture("dice_game_lock_part_11", 0, {
		167,
		166.5
	}, "lock_bg_left"),
	lock_bg_right = UIWidgets.create_simple_rotated_texture("dice_game_lock_part_11", math.pi, {
		0,
		166.5
	}, "lock_bg_right"),
	lock_pillar_left = UIWidgets.create_simple_texture("dice_game_lock_part_13", "lock_pillar_left"),
	lock_pillar_right = UIWidgets.create_simple_uv_texture("dice_game_lock_part_13", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "lock_pillar_right"),
	lock_pillar_top = UIWidgets.create_simple_texture("dice_game_lock_part_12", "lock_pillar_top"),
	lock_pillar_bottom = UIWidgets.create_simple_uv_texture("dice_game_lock_part_12", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "lock_pillar_bottom"),
	lock_cogwheel_bg_left = UIWidgets.create_simple_rotated_texture("dice_game_lock_part_05", 0, {
		170,
		171
	}, "lock_cogwheel_bg_left"),
	lock_cogwheel_bg_right = UIWidgets.create_simple_rotated_texture("dice_game_lock_part_06", 0, {
		0,
		171
	}, "lock_cogwheel_bg_right"),
	lock_cogwheel_left = UIWidgets.create_simple_rotated_texture("dice_game_lock_part_07", 0, {
		158,
		158
	}, "lock_cogwheel_left"),
	lock_cogwheel_right = UIWidgets.create_simple_rotated_texture("dice_game_lock_part_08", 0, {
		0,
		158
	}, "lock_cogwheel_right"),
	lock_stick_top_left = UIWidgets.create_simple_texture("dice_game_lock_part_14", "lock_stick_top_left"),
	lock_stick_top_right = UIWidgets.create_simple_uv_texture("dice_game_lock_part_14", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "lock_stick_top_right"),
	lock_stick_bottom_left = UIWidgets.create_simple_texture("dice_game_lock_part_15", "lock_stick_bottom_left"),
	lock_stick_bottom_right = UIWidgets.create_simple_uv_texture("dice_game_lock_part_15", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "lock_stick_bottom_right"),
	lock_cover_top_left = UIWidgets.create_simple_texture("dice_game_lock_part_01", "lock_cover_top_left"),
	lock_cover_top_right = UIWidgets.create_simple_texture("dice_game_lock_part_03", "lock_cover_top_right"),
	lock_cover_bottom_left = UIWidgets.create_simple_texture("dice_game_lock_part_02", "lock_cover_bottom_left"),
	lock_cover_bottom_right = UIWidgets.create_simple_texture("dice_game_lock_part_04", "lock_cover_bottom_right"),
	lock_block_left = UIWidgets.create_simple_rotated_texture("dice_game_lock_part_09", 0, {
		153,
		74.5
	}, "lock_block_left"),
	lock_block_right = UIWidgets.create_simple_rotated_texture("dice_game_lock_part_09", math.pi, {
		153,
		74.5
	}, "lock_block_right"),
	lock_slot_holder_left = UIWidgets.create_simple_rotated_texture("dice_game_lock_part_10", 0, {
		52,
		151
	}, "lock_slot_holder_left"),
	lock_slot_holder_right = UIWidgets.create_simple_rotated_texture("dice_game_lock_part_10_02", 0, {
		0,
		151.5
	}, "lock_slot_holder_right"),
	frame_right = UIWidgets.create_simple_rotated_texture("dice_game_lock_left_side", math.pi, {
		58,
		145
	}, "frame_right"),
	frame_bottom = UIWidgets.create_simple_rotated_texture("dice_game_lock_left_side", -math.pi * 0.5, {
		58,
		145
	}, "frame_bottom"),
	frame_left = UIWidgets.create_simple_rotated_texture("dice_game_lock_left_side", 0, {
		58,
		145
	}, "frame_left"),
	frame_top = UIWidgets.create_simple_rotated_texture("dice_game_lock_left_side", -math.pi * 1.5, {
		58,
		145
	}, "frame_top")
}
local var_0_29 = 0.5
local var_0_30 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.7,
			init = function(arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				arg_28_3.render_settings.alpha_multiplier = 0
			end,
			update = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				local var_29_0 = math.easeOutCubic(arg_29_3)

				arg_29_4.render_settings.alpha_multiplier = var_29_0
			end,
			on_complete = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				arg_31_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				local var_32_0 = math.easeOutCubic(arg_32_3)

				arg_32_4.render_settings.alpha_multiplier = 1 - var_32_0
			end,
			on_complete = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				return
			end
		}
	},
	item_rotation = {
		{
			name = "item_rotation",
			start_progress = 0,
			end_progress = 0.5,
			init = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				local var_34_0 = arg_34_3.item_widget
				local var_34_1 = var_34_0.content
				local var_34_2 = var_34_0.style
				local var_34_3 = arg_34_3.reward_index
				local var_34_4 = var_34_1.reward_order
				local var_34_5 = table.find(var_34_4, var_34_3)

				arg_34_3.start_index = var_34_5

				table.remove(var_34_4, var_34_5)

				var_34_4[#var_34_4 + 1] = var_34_3
				var_34_2["background_rect_" .. var_34_3].color[1] = 0
				var_34_2["background_" .. var_34_3].color[1] = 0
				var_34_2["type_tag_icon_" .. var_34_3].color[1] = 0
				var_34_2["icon_" .. var_34_3].color[1] = 0
				var_34_2["frame_" .. var_34_3].color[1] = 0
				var_34_2["hover_frame_" .. var_34_3].color[1] = 0
				var_34_2["pulse_frame_" .. var_34_3].color[1] = 0
				var_34_2["painting_" .. var_34_3].color[1] = 0
				var_34_2["painting_frame_" .. var_34_3].color[1] = 0
			end,
			update = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				local var_35_0 = math.easeOutCubic(arg_35_3)
				local var_35_1 = arg_35_4.item_widget
				local var_35_2 = var_35_1.content
				local var_35_3 = var_35_1.style
				local var_35_4 = var_35_2.reward_order
				local var_35_5 = arg_35_4.reward_index

				for iter_35_0 = arg_35_4.start_index, #var_35_4 do
					local var_35_6 = var_35_4[iter_35_0]
					local var_35_7 = {
						iter_35_0 * var_0_17,
						iter_35_0 * -var_0_17,
						iter_35_0 * 15
					}
					local var_35_8 = {
						(iter_35_0 - 1) * var_0_17,
						(iter_35_0 - 1) * -var_0_17,
						(iter_35_0 - 1) * 15
					}

					var_35_3["hotspot_" .. var_35_6].offset[1] = math.lerp(var_35_3["hotspot_" .. var_35_6].base_offset[1] + var_35_7[1], var_35_3["hotspot_" .. var_35_6].base_offset[1] + var_35_8[1], var_35_0)
					var_35_3["hotspot_" .. var_35_6].offset[2] = math.lerp(var_35_3["hotspot_" .. var_35_6].base_offset[2] + var_35_7[2], var_35_3["hotspot_" .. var_35_6].base_offset[2] + var_35_8[2], var_35_0)
					var_35_3["hotspot_" .. var_35_6].offset[3] = math.lerp(var_35_3["hotspot_" .. var_35_6].base_offset[3] + var_35_7[3], var_35_3["hotspot_" .. var_35_6].base_offset[3] + var_35_8[3], var_35_0)
					var_35_3["background_rect_" .. var_35_6].offset[1] = math.lerp(var_35_3["background_rect_" .. var_35_6].base_offset[1] + var_35_7[1], var_35_3["background_rect_" .. var_35_6].base_offset[1] + var_35_8[1], var_35_0)
					var_35_3["background_rect_" .. var_35_6].offset[2] = math.lerp(var_35_3["background_rect_" .. var_35_6].base_offset[2] + var_35_7[2], var_35_3["background_rect_" .. var_35_6].base_offset[2] + var_35_8[2], var_35_0)
					var_35_3["background_rect_" .. var_35_6].offset[3] = math.lerp(var_35_3["background_rect_" .. var_35_6].base_offset[3] + var_35_7[3], var_35_3["background_rect_" .. var_35_6].base_offset[3] + var_35_8[3], var_35_0)
					var_35_3["background_" .. var_35_6].offset[1] = math.lerp(var_35_3["background_" .. var_35_6].base_offset[1] + var_35_7[1], var_35_3["background_" .. var_35_6].base_offset[1] + var_35_8[1], var_35_0)
					var_35_3["background_" .. var_35_6].offset[2] = math.lerp(var_35_3["background_" .. var_35_6].base_offset[2] + var_35_7[2], var_35_3["background_" .. var_35_6].base_offset[2] + var_35_8[2], var_35_0)
					var_35_3["background_" .. var_35_6].offset[3] = math.lerp(var_35_3["background_" .. var_35_6].base_offset[3] + var_35_7[3], var_35_3["background_" .. var_35_6].base_offset[3] + var_35_8[3], var_35_0)
					var_35_3["overlay_" .. var_35_6].offset[1] = math.lerp(var_35_3["overlay_" .. var_35_6].base_offset[1] + var_35_7[1], var_35_3["overlay_" .. var_35_6].base_offset[1] + var_35_8[1], var_35_0)
					var_35_3["overlay_" .. var_35_6].offset[2] = math.lerp(var_35_3["overlay_" .. var_35_6].base_offset[2] + var_35_7[2], var_35_3["overlay_" .. var_35_6].base_offset[2] + var_35_8[2], var_35_0)
					var_35_3["overlay_" .. var_35_6].offset[3] = math.lerp(var_35_3["overlay_" .. var_35_6].base_offset[3] + var_35_7[3], var_35_3["overlay_" .. var_35_6].base_offset[3] + var_35_8[3], var_35_0)
					var_35_3["type_tag_icon_" .. var_35_6].offset[1] = math.lerp(var_35_3["type_tag_icon_" .. var_35_6].base_offset[1] + var_35_7[1], var_35_3["type_tag_icon_" .. var_35_6].base_offset[1] + var_35_8[1], var_35_0)
					var_35_3["type_tag_icon_" .. var_35_6].offset[2] = math.lerp(var_35_3["type_tag_icon_" .. var_35_6].base_offset[2] + var_35_7[2], var_35_3["type_tag_icon_" .. var_35_6].base_offset[2] + var_35_8[2], var_35_0)
					var_35_3["type_tag_icon_" .. var_35_6].offset[3] = math.lerp(var_35_3["type_tag_icon_" .. var_35_6].base_offset[3] + var_35_7[3], var_35_3["type_tag_icon_" .. var_35_6].base_offset[3] + var_35_8[3], var_35_0)
					var_35_3["icon_" .. var_35_6].offset[1] = math.lerp(var_35_3["icon_" .. var_35_6].base_offset[1] + var_35_7[1], var_35_3["icon_" .. var_35_6].base_offset[1] + var_35_8[1], var_35_0)
					var_35_3["icon_" .. var_35_6].offset[2] = math.lerp(var_35_3["icon_" .. var_35_6].base_offset[2] + var_35_7[2], var_35_3["icon_" .. var_35_6].base_offset[2] + var_35_8[2], var_35_0)
					var_35_3["icon_" .. var_35_6].offset[3] = math.lerp(var_35_3["icon_" .. var_35_6].base_offset[3] + var_35_7[3], var_35_3["icon_" .. var_35_6].base_offset[3] + var_35_8[3], var_35_0)
					var_35_3["frame_" .. var_35_6].offset[1] = math.lerp(var_35_3["frame_" .. var_35_6].base_offset[1] + var_35_7[1], var_35_3["frame_" .. var_35_6].base_offset[1] + var_35_8[1], var_35_0)
					var_35_3["frame_" .. var_35_6].offset[2] = math.lerp(var_35_3["frame_" .. var_35_6].base_offset[2] + var_35_7[2], var_35_3["frame_" .. var_35_6].base_offset[2] + var_35_8[2], var_35_0)
					var_35_3["frame_" .. var_35_6].offset[3] = math.lerp(var_35_3["frame_" .. var_35_6].base_offset[3] + var_35_7[3], var_35_3["frame_" .. var_35_6].base_offset[3] + var_35_8[3], var_35_0)
					var_35_3["hover_frame_" .. var_35_6].offset[1] = math.lerp(var_35_3["hover_frame_" .. var_35_6].base_offset[1] + var_35_7[1], var_35_3["hover_frame_" .. var_35_6].base_offset[1] + var_35_8[1], var_35_0)
					var_35_3["hover_frame_" .. var_35_6].offset[2] = math.lerp(var_35_3["hover_frame_" .. var_35_6].base_offset[2] + var_35_7[2], var_35_3["hover_frame_" .. var_35_6].base_offset[2] + var_35_8[2], var_35_0)
					var_35_3["hover_frame_" .. var_35_6].offset[3] = math.lerp(var_35_3["hover_frame_" .. var_35_6].base_offset[3] + var_35_7[3], var_35_3["hover_frame_" .. var_35_6].base_offset[3] + var_35_8[3], var_35_0)
					var_35_3["pulse_frame_" .. var_35_6].offset[1] = math.lerp(var_35_3["pulse_frame_" .. var_35_6].base_offset[1] + var_35_7[1], var_35_3["pulse_frame_" .. var_35_6].base_offset[1] + var_35_8[1], var_35_0)
					var_35_3["pulse_frame_" .. var_35_6].offset[2] = math.lerp(var_35_3["pulse_frame_" .. var_35_6].base_offset[2] + var_35_7[2], var_35_3["pulse_frame_" .. var_35_6].base_offset[2] + var_35_8[2], var_35_0)
					var_35_3["pulse_frame_" .. var_35_6].offset[3] = math.lerp(var_35_3["pulse_frame_" .. var_35_6].base_offset[3] + var_35_7[3], var_35_3["pulse_frame_" .. var_35_6].base_offset[3] + var_35_8[3], var_35_0)
					var_35_3["painting_" .. var_35_6].offset[1] = math.lerp(var_35_3["painting_" .. var_35_6].base_offset[1] + var_35_7[1], var_35_3["painting_" .. var_35_6].base_offset[1] + var_35_8[1], var_35_0)
					var_35_3["painting_" .. var_35_6].offset[2] = math.lerp(var_35_3["painting_" .. var_35_6].base_offset[2] + var_35_7[2], var_35_3["painting_" .. var_35_6].base_offset[2] + var_35_8[2], var_35_0)
					var_35_3["painting_" .. var_35_6].offset[3] = math.lerp(var_35_3["painting_" .. var_35_6].base_offset[3] + var_35_7[3], var_35_3["painting_" .. var_35_6].base_offset[3] + var_35_8[3], var_35_0)
					var_35_3["painting_frame_" .. var_35_6].offset[1] = math.lerp(var_35_3["painting_frame_" .. var_35_6].base_offset[1] + var_35_7[1], var_35_3["painting_frame_" .. var_35_6].base_offset[1] + var_35_8[1], var_35_0)
					var_35_3["painting_frame_" .. var_35_6].offset[2] = math.lerp(var_35_3["painting_frame_" .. var_35_6].base_offset[2] + var_35_7[2], var_35_3["painting_frame_" .. var_35_6].base_offset[2] + var_35_8[2], var_35_0)
					var_35_3["painting_frame_" .. var_35_6].offset[3] = math.lerp(var_35_3["painting_frame_" .. var_35_6].base_offset[3] + var_35_7[3], var_35_3["painting_frame_" .. var_35_6].base_offset[3] + var_35_8[3], var_35_0)

					if var_35_6 == var_35_5 then
						var_35_3["background_rect_" .. var_35_6].color[1] = var_35_0 * 255
						var_35_3["background_" .. var_35_6].color[1] = var_35_0 * 255
						var_35_3["type_tag_icon_" .. var_35_6].color[1] = var_35_0 * 255
						var_35_3["icon_" .. var_35_6].color[1] = var_35_0 * 255
						var_35_3["frame_" .. var_35_6].color[1] = var_35_0 * 255
						var_35_3["painting_" .. var_35_6].color[1] = var_35_0 * 255
						var_35_3["painting_frame_" .. var_35_6].color[1] = var_35_0 * 255
					end
				end
			end,
			on_complete = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				local var_36_0 = arg_36_3.item_widget.style
				local var_36_1 = arg_36_3.reward_index

				var_36_0["background_rect_" .. var_36_1].color[1] = 255
				var_36_0["background_" .. var_36_1].color[1] = 255
				var_36_0["type_tag_icon_" .. var_36_1].color[1] = 255
				var_36_0["icon_" .. var_36_1].color[1] = 255
				var_36_0["frame_" .. var_36_1].color[1] = 255
				var_36_0["painting_" .. var_36_1].color[1] = 255
				var_36_0["painting_frame_" .. var_36_1].color[1] = 255
			end
		}
	},
	hide_item_list = {
		{
			name = "hide_item_list",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				arg_37_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				local var_38_0 = math.easeOutCubic(arg_38_3)

				arg_38_0.gotwf_window.local_position[2] = arg_38_1.gotwf_window.position[2] - 500 * var_38_0
				arg_38_0.scrollbar_area.local_position[2] = arg_38_1.scrollbar_area.position[2] - 500 * var_38_0
				arg_38_0.arrow_left.local_position[2] = arg_38_1.arrow_left.position[2] - 500 * var_38_0
				arg_38_0.arrow_right.local_position[2] = arg_38_1.arrow_right.position[2] - 500 * var_38_0
			end,
			on_complete = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				return
			end
		}
	},
	show_item_list = {
		{
			name = "show_item_list",
			start_progress = 0,
			end_progress = 0.3,
			init = function(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				arg_40_3.render_settings.alpha_multiplier = 1
			end,
			update = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				local var_41_0 = math.easeOutCubic(arg_41_3)

				arg_41_0.gotwf_window.local_position[2] = arg_41_1.gotwf_window.position[2] - 500 * (1 - var_41_0)
				arg_41_0.scrollbar_area.local_position[2] = arg_41_1.scrollbar_area.position[2] - 500 * (1 - var_41_0)
				arg_41_0.arrow_left.local_position[2] = arg_41_1.arrow_left.position[2] - 500 * (1 - var_41_0)
				arg_41_0.arrow_right.local_position[2] = arg_41_1.arrow_right.position[2] - 500 * (1 - var_41_0)
			end,
			on_complete = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				return
			end
		}
	},
	lock_open = {
		{
			name = "animate_in",
			start_progress = 0 * var_0_29,
			end_progress = 1 * var_0_29,
			init = function(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				arg_43_0.lock_root.position[2] = arg_43_1.lock_root.position[2]
				arg_43_2.lock_bg_left.content.visible = true
				arg_43_2.lock_bg_right.content.visible = true
				arg_43_2.lock_pillar_left.content.visible = true
				arg_43_2.lock_pillar_right.content.visible = true
				arg_43_2.lock_pillar_top.content.visible = true
				arg_43_2.lock_pillar_bottom.content.visible = true
				arg_43_2.lock_cogwheel_bg_left.content.visible = true
				arg_43_2.lock_cogwheel_bg_right.content.visible = true
				arg_43_2.lock_cogwheel_left.content.visible = true
				arg_43_2.lock_cogwheel_right.content.visible = true
				arg_43_2.lock_stick_top_left.content.visible = true
				arg_43_2.lock_stick_top_right.content.visible = true
				arg_43_2.lock_stick_bottom_left.content.visible = true
				arg_43_2.lock_stick_bottom_right.content.visible = true
				arg_43_2.lock_block_left.content.visible = true
				arg_43_2.lock_block_right.content.visible = true
				arg_43_2.lock_slot_holder_left.content.visible = true
				arg_43_2.lock_slot_holder_right.content.visible = true
				arg_43_2.lock_cover_top_left.content.visible = true
				arg_43_2.lock_cover_top_right.content.visible = true
				arg_43_2.lock_cover_bottom_left.content.visible = true
				arg_43_2.lock_cover_bottom_right.content.visible = true
				arg_43_0.lock_bg_left.position[1] = arg_43_1.lock_bg_left.position[1]
				arg_43_0.lock_bg_left.position[2] = arg_43_1.lock_bg_left.position[2]
				arg_43_0.lock_bg_left.position[3] = arg_43_1.lock_bg_left.position[3]
				arg_43_0.lock_bg_right.position[1] = arg_43_1.lock_bg_right.position[1]
				arg_43_0.lock_bg_right.position[2] = arg_43_1.lock_bg_right.position[2]
				arg_43_0.lock_bg_right.position[3] = arg_43_1.lock_bg_right.position[3]
				arg_43_0.lock_pillar_left.position[1] = arg_43_1.lock_pillar_left.position[1]
				arg_43_0.lock_pillar_left.position[2] = arg_43_1.lock_pillar_left.position[2]
				arg_43_0.lock_pillar_left.position[3] = arg_43_1.lock_pillar_left.position[3]
				arg_43_0.lock_pillar_right.position[1] = arg_43_1.lock_pillar_right.position[1]
				arg_43_0.lock_pillar_right.position[2] = arg_43_1.lock_pillar_right.position[2]
				arg_43_0.lock_pillar_right.position[3] = arg_43_1.lock_pillar_right.position[3]
				arg_43_0.lock_pillar_top.position[1] = arg_43_1.lock_pillar_top.position[1]
				arg_43_0.lock_pillar_top.position[2] = arg_43_1.lock_pillar_top.position[2]
				arg_43_0.lock_pillar_top.position[3] = arg_43_1.lock_pillar_top.position[3]
				arg_43_0.lock_pillar_bottom.position[1] = arg_43_1.lock_pillar_bottom.position[1]
				arg_43_0.lock_pillar_bottom.position[2] = arg_43_1.lock_pillar_bottom.position[2]
				arg_43_0.lock_pillar_bottom.position[3] = arg_43_1.lock_pillar_bottom.position[3]
				arg_43_0.lock_cogwheel_bg_left.position[1] = arg_43_1.lock_cogwheel_bg_left.position[1]
				arg_43_0.lock_cogwheel_bg_left.position[2] = arg_43_1.lock_cogwheel_bg_left.position[2]
				arg_43_0.lock_cogwheel_bg_left.position[3] = arg_43_1.lock_cogwheel_bg_left.position[3]
				arg_43_0.lock_cogwheel_bg_right.position[1] = arg_43_1.lock_cogwheel_bg_right.position[1]
				arg_43_0.lock_cogwheel_bg_right.position[2] = arg_43_1.lock_cogwheel_bg_right.position[2]
				arg_43_0.lock_cogwheel_bg_right.position[3] = arg_43_1.lock_cogwheel_bg_right.position[3]
				arg_43_0.lock_cogwheel_left.position[1] = arg_43_1.lock_cogwheel_left.position[1]
				arg_43_0.lock_cogwheel_left.position[2] = arg_43_1.lock_cogwheel_left.position[2]
				arg_43_0.lock_cogwheel_left.position[3] = arg_43_1.lock_cogwheel_left.position[3]
				arg_43_0.lock_cogwheel_right.position[1] = arg_43_1.lock_cogwheel_right.position[1]
				arg_43_0.lock_cogwheel_right.position[2] = arg_43_1.lock_cogwheel_right.position[2]
				arg_43_0.lock_cogwheel_right.position[3] = arg_43_1.lock_cogwheel_right.position[3]
				arg_43_0.lock_stick_top_left.position[1] = arg_43_1.lock_stick_top_left.position[1]
				arg_43_0.lock_stick_top_left.position[2] = arg_43_1.lock_stick_top_left.position[2]
				arg_43_0.lock_stick_top_left.position[3] = arg_43_1.lock_stick_top_left.position[3]
				arg_43_0.lock_stick_top_right.position[1] = arg_43_1.lock_stick_top_right.position[1]
				arg_43_0.lock_stick_top_right.position[2] = arg_43_1.lock_stick_top_right.position[2]
				arg_43_0.lock_stick_top_right.position[3] = arg_43_1.lock_stick_top_right.position[3]
				arg_43_0.lock_stick_bottom_left.position[1] = arg_43_1.lock_stick_bottom_left.position[1]
				arg_43_0.lock_stick_bottom_left.position[2] = arg_43_1.lock_stick_bottom_left.position[2]
				arg_43_0.lock_stick_bottom_left.position[3] = arg_43_1.lock_stick_bottom_left.position[3]
				arg_43_0.lock_stick_bottom_right.position[1] = arg_43_1.lock_stick_bottom_right.position[1]
				arg_43_0.lock_stick_bottom_right.position[2] = arg_43_1.lock_stick_bottom_right.position[2]
				arg_43_0.lock_stick_bottom_right.position[3] = arg_43_1.lock_stick_bottom_right.position[3]
				arg_43_0.lock_block_left.position[1] = arg_43_1.lock_block_left.position[1]
				arg_43_0.lock_block_left.position[2] = arg_43_1.lock_block_left.position[2]
				arg_43_0.lock_block_left.position[3] = arg_43_1.lock_block_left.position[3]
				arg_43_0.lock_block_right.position[1] = arg_43_1.lock_block_right.position[1]
				arg_43_0.lock_block_right.position[2] = arg_43_1.lock_block_right.position[2]
				arg_43_0.lock_block_right.position[3] = arg_43_1.lock_block_right.position[3]
				arg_43_0.lock_slot_holder_left.position[1] = arg_43_1.lock_slot_holder_left.position[1]
				arg_43_0.lock_slot_holder_left.position[2] = arg_43_1.lock_slot_holder_left.position[2]
				arg_43_0.lock_slot_holder_left.position[3] = arg_43_1.lock_slot_holder_left.position[3]
				arg_43_0.lock_slot_holder_right.position[1] = arg_43_1.lock_slot_holder_right.position[1]
				arg_43_0.lock_slot_holder_right.position[2] = arg_43_1.lock_slot_holder_right.position[2]
				arg_43_0.lock_slot_holder_right.position[3] = arg_43_1.lock_slot_holder_right.position[3]
				arg_43_0.lock_bg_left.size[1] = arg_43_1.lock_bg_left.size[1]
				arg_43_0.lock_bg_left.size[2] = arg_43_1.lock_bg_left.size[2]
				arg_43_0.lock_bg_right.size[1] = arg_43_1.lock_bg_right.size[1]
				arg_43_0.lock_bg_right.size[2] = arg_43_1.lock_bg_right.size[2]
				arg_43_0.lock_pillar_left.size[1] = arg_43_1.lock_pillar_left.size[1]
				arg_43_0.lock_pillar_left.size[2] = arg_43_1.lock_pillar_left.size[2]
				arg_43_0.lock_pillar_right.size[1] = arg_43_1.lock_pillar_right.size[1]
				arg_43_0.lock_pillar_right.size[2] = arg_43_1.lock_pillar_right.size[2]
				arg_43_0.lock_pillar_top.size[1] = arg_43_1.lock_pillar_top.size[1]
				arg_43_0.lock_pillar_top.size[2] = arg_43_1.lock_pillar_top.size[2]
				arg_43_0.lock_pillar_bottom.size[1] = arg_43_1.lock_pillar_bottom.size[1]
				arg_43_0.lock_pillar_bottom.size[2] = arg_43_1.lock_pillar_bottom.size[2]
				arg_43_0.lock_cogwheel_bg_left.size[1] = arg_43_1.lock_cogwheel_bg_left.size[1]
				arg_43_0.lock_cogwheel_bg_left.size[2] = arg_43_1.lock_cogwheel_bg_left.size[2]
				arg_43_0.lock_cogwheel_bg_right.size[1] = arg_43_1.lock_cogwheel_bg_right.size[1]
				arg_43_0.lock_cogwheel_bg_right.size[2] = arg_43_1.lock_cogwheel_bg_right.size[2]
				arg_43_0.lock_cogwheel_left.size[1] = arg_43_1.lock_cogwheel_left.size[1]
				arg_43_0.lock_cogwheel_left.size[2] = arg_43_1.lock_cogwheel_left.size[2]
				arg_43_0.lock_cogwheel_right.size[1] = arg_43_1.lock_cogwheel_right.size[1]
				arg_43_0.lock_cogwheel_right.size[2] = arg_43_1.lock_cogwheel_right.size[2]
				arg_43_0.lock_stick_top_left.size[1] = arg_43_1.lock_stick_top_left.size[1]
				arg_43_0.lock_stick_top_left.size[2] = arg_43_1.lock_stick_top_left.size[2]
				arg_43_0.lock_stick_top_right.size[1] = arg_43_1.lock_stick_top_right.size[1]
				arg_43_0.lock_stick_top_right.size[2] = arg_43_1.lock_stick_top_right.size[2]
				arg_43_0.lock_stick_bottom_left.size[1] = arg_43_1.lock_stick_bottom_left.size[1]
				arg_43_0.lock_stick_bottom_left.size[2] = arg_43_1.lock_stick_bottom_left.size[2]
				arg_43_0.lock_stick_bottom_right.size[1] = arg_43_1.lock_stick_bottom_right.size[1]
				arg_43_0.lock_stick_bottom_right.size[2] = arg_43_1.lock_stick_bottom_right.size[2]
				arg_43_0.lock_block_left.size[1] = arg_43_1.lock_block_left.size[1]
				arg_43_0.lock_block_left.size[2] = arg_43_1.lock_block_left.size[2]
				arg_43_0.lock_block_right.size[1] = arg_43_1.lock_block_right.size[1]
				arg_43_0.lock_block_right.size[2] = arg_43_1.lock_block_right.size[2]
				arg_43_0.lock_slot_holder_left.size[1] = arg_43_1.lock_slot_holder_left.size[1]
				arg_43_0.lock_slot_holder_left.size[2] = arg_43_1.lock_slot_holder_left.size[2]
				arg_43_0.lock_slot_holder_right.size[1] = arg_43_1.lock_slot_holder_right.size[1]
				arg_43_0.lock_slot_holder_right.size[2] = arg_43_1.lock_slot_holder_right.size[2]
				arg_43_2.frame_right.content.visible = false
				arg_43_2.frame_bottom.content.visible = false
				arg_43_2.frame_left.content.visible = false
				arg_43_2.frame_top.content.visible = false
				arg_43_2.left_mask.style.texture_id.color[1] = 0
				arg_43_2.right_mask.style.texture_id.color[1] = 0
				arg_43_2.top_mask.style.texture_id.color[1] = 0
				arg_43_2.bottom_mask.style.texture_id.color[1] = 0
				arg_43_2.center_mask.style.texture_id.color[1] = 0
			end,
			update = function(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				local var_44_0 = math.easeOutCubic(arg_44_3)

				arg_44_0.lock_root.position[2] = math.lerp(arg_44_1.lock_root.position[2], -355, var_44_0)
			end,
			on_complete = function(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				return
			end
		},
		{
			name = "sticks_open",
			start_progress = 0.5 * var_0_29,
			end_progress = 1 * var_0_29,
			init = function(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
				local var_46_0 = arg_46_0.lock_stick_top_left.local_position
				local var_46_1 = arg_46_1.lock_stick_top_left.position
				local var_46_2 = arg_46_0.lock_stick_top_right.local_position
				local var_46_3 = arg_46_1.lock_stick_top_right.position

				var_46_2[1] = var_46_3[1]
				var_46_2[2] = var_46_3[2]

				local var_46_4 = arg_46_0.lock_stick_bottom_left.local_position
				local var_46_5 = arg_46_1.lock_stick_bottom_left.position

				var_46_4[1] = var_46_5[1]
				var_46_4[2] = var_46_5[2]

				local var_46_6 = arg_46_0.lock_stick_bottom_right.local_position
				local var_46_7 = arg_46_1.lock_stick_bottom_right.position

				var_46_6[1] = var_46_7[1]
				var_46_6[2] = var_46_7[2]

				local var_46_8 = arg_46_0.lock_cover_top_left.local_position
				local var_46_9 = arg_46_1.lock_cover_top_left.position

				var_46_8[1] = var_46_9[1]
				var_46_8[2] = var_46_9[2]

				local var_46_10 = arg_46_0.lock_cover_top_right.local_position
				local var_46_11 = arg_46_1.lock_cover_top_right.position

				var_46_10[1] = var_46_11[1]
				var_46_10[2] = var_46_11[2]

				local var_46_12 = arg_46_0.lock_cover_bottom_left.local_position
				local var_46_13 = arg_46_1.lock_cover_bottom_left.position

				var_46_12[1] = var_46_13[1]
				var_46_12[2] = var_46_13[2]

				local var_46_14 = arg_46_0.lock_cover_bottom_right.local_position
				local var_46_15 = arg_46_1.lock_cover_bottom_right.position

				var_46_14[1] = var_46_15[1]
				var_46_14[2] = var_46_15[2]
				arg_46_0.lock_pillar_left.local_position[1] = arg_46_1.lock_pillar_left.position[1]
				arg_46_0.lock_pillar_right.local_position[1] = arg_46_1.lock_pillar_right.position[1]
				arg_46_0.lock_pillar_top.local_position[2] = arg_46_1.lock_pillar_top.position[2]
				arg_46_0.lock_pillar_bottom.local_position[2] = arg_46_1.lock_pillar_bottom.position[2]
				arg_46_2.lock_cogwheel_left.style.texture_id.angle = 0
				arg_46_2.lock_cogwheel_right.style.texture_id.angle = 0
				arg_46_2.lock_slot_holder_left.style.texture_id.angle = 0
				arg_46_2.lock_slot_holder_right.style.texture_id.angle = 0
				arg_46_2.lock_block_left.style.texture_id.angle = 0
				arg_46_2.lock_block_right.style.texture_id.angle = math.pi
				arg_46_2.lock_cogwheel_bg_left.style.texture_id.angle = 0
				arg_46_2.lock_cogwheel_bg_right.style.texture_id.angle = 0
			end,
			update = function(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
				local var_47_0 = math.easeCubic(arg_47_3)
				local var_47_1 = 50
				local var_47_2 = arg_47_0.lock_stick_top_left.local_position
				local var_47_3 = arg_47_1.lock_stick_top_left.position
				local var_47_4 = arg_47_0.lock_stick_top_right.local_position
				local var_47_5 = arg_47_1.lock_stick_top_right.position
				local var_47_6 = arg_47_0.lock_stick_bottom_left.local_position
				local var_47_7 = arg_47_1.lock_stick_bottom_left.position
				local var_47_8 = arg_47_0.lock_stick_bottom_right.local_position
				local var_47_9 = arg_47_1.lock_stick_bottom_right.position

				var_47_2[1] = var_47_3[1] - var_47_1 * var_47_0
				var_47_2[2] = var_47_3[2] + var_47_1 * var_47_0
				var_47_4[1] = var_47_5[1] + var_47_1 * var_47_0
				var_47_4[2] = var_47_5[2] + var_47_1 * var_47_0
				var_47_6[1] = var_47_7[1] - var_47_1 * var_47_0
				var_47_6[2] = var_47_7[2] - var_47_1 * var_47_0
				var_47_8[1] = var_47_9[1] + var_47_1 * var_47_0
				var_47_8[2] = var_47_9[2] - var_47_1 * var_47_0
			end,
			on_complete = function(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
				return
			end
		},
		{
			name = "cover_open",
			start_progress = 1.2 * var_0_29,
			end_progress = 1.8 * var_0_29,
			init = function(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
				return
			end,
			update = function(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
				local var_50_0 = 90
				local var_50_1 = math.easeOutCubic(arg_50_3)
				local var_50_2 = arg_50_0.lock_cover_top_left.local_position
				local var_50_3 = arg_50_1.lock_cover_top_left.position
				local var_50_4 = arg_50_0.lock_cover_top_right.local_position
				local var_50_5 = arg_50_1.lock_cover_top_right.position
				local var_50_6 = arg_50_0.lock_cover_bottom_left.local_position
				local var_50_7 = arg_50_1.lock_cover_bottom_left.position
				local var_50_8 = arg_50_0.lock_cover_bottom_right.local_position
				local var_50_9 = arg_50_1.lock_cover_bottom_right.position

				var_50_2[1] = var_50_3[1] - var_50_0 * var_50_1
				var_50_2[2] = var_50_3[2] + var_50_0 * var_50_1
				var_50_4[1] = var_50_5[1] + var_50_0 * var_50_1
				var_50_4[2] = var_50_5[2] + var_50_0 * var_50_1
				var_50_6[1] = var_50_7[1] - var_50_0 * var_50_1
				var_50_6[2] = var_50_7[2] - var_50_0 * var_50_1
				var_50_8[1] = var_50_9[1] + var_50_0 * var_50_1
				var_50_8[2] = var_50_9[2] - var_50_0 * var_50_1

				local var_50_10 = math.pi * 4 * var_50_1
				local var_50_11 = arg_50_2.lock_block_left
				local var_50_12 = arg_50_2.lock_block_right

				var_50_11.style.texture_id.angle = var_50_10
				var_50_12.style.texture_id.angle = var_50_10 + math.pi
			end,
			on_complete = function(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
				return
			end
		},
		{
			name = "top_and_bottom_pillar_lock",
			start_progress = 1.8 * var_0_29,
			end_progress = 1.9 * var_0_29,
			init = function(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
				return
			end,
			update = function(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
				local var_53_0 = 28
				local var_53_1 = math.ease_in_exp(arg_53_3)
				local var_53_2 = arg_53_0.lock_pillar_top.local_position
				local var_53_3 = arg_53_1.lock_pillar_top.position
				local var_53_4 = arg_53_0.lock_pillar_bottom.local_position
				local var_53_5 = arg_53_1.lock_pillar_bottom.position

				var_53_2[2] = var_53_3[2] + var_53_0 * var_53_1
				var_53_4[2] = var_53_5[2] - var_53_0 * var_53_1
			end,
			on_complete = function(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
				return
			end
		},
		{
			name = "cogwheel_bg_spin",
			start_progress = 2 * var_0_29,
			end_progress = 2.4 * var_0_29,
			init = function(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
				return
			end,
			update = function(arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
				local var_56_0 = math.easeCubic(arg_56_3)
				local var_56_1 = arg_56_2.lock_cogwheel_bg_left
				local var_56_2 = arg_56_2.lock_cogwheel_bg_right
				local var_56_3 = math.pi * 0.5 * var_56_0

				var_56_1.style.texture_id.angle = var_56_3
				var_56_2.style.texture_id.angle = var_56_3
			end,
			on_complete = function(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
				return
			end
		},
		{
			name = "cogwheel_spin",
			start_progress = 2.5 * var_0_29,
			end_progress = 3.5 * var_0_29,
			init = function(arg_58_0, arg_58_1, arg_58_2, arg_58_3)
				return
			end,
			update = function(arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
				local var_59_0 = math.ease_exp(arg_59_3)
				local var_59_1 = math.easeInCubic(arg_59_3)
				local var_59_2 = arg_59_2.lock_slot_holder_left
				local var_59_3 = arg_59_2.lock_slot_holder_right
				local var_59_4 = arg_59_2.lock_cogwheel_left
				local var_59_5 = arg_59_2.lock_cogwheel_right
				local var_59_6 = math.pi / 2 * var_59_1
				local var_59_7 = math.pi * 2 * var_59_0

				var_59_2.style.texture_id.angle = -var_59_6
				var_59_3.style.texture_id.angle = -var_59_6
				var_59_4.style.texture_id.angle = var_59_7
				var_59_5.style.texture_id.angle = var_59_7
			end,
			on_complete = function(arg_60_0, arg_60_1, arg_60_2, arg_60_3)
				return
			end
		},
		{
			name = "left_and_right_pillar_lock",
			start_progress = 3.5 * var_0_29,
			end_progress = 3.6 * var_0_29,
			init = function(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
				return
			end,
			update = function(arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
				local var_62_0 = 28
				local var_62_1 = math.ease_in_exp(arg_62_3)
				local var_62_2 = arg_62_0.lock_pillar_left.local_position
				local var_62_3 = arg_62_1.lock_pillar_left.position
				local var_62_4 = arg_62_0.lock_pillar_right.local_position
				local var_62_5 = arg_62_1.lock_pillar_right.position

				var_62_2[1] = var_62_3[1] - var_62_0 * var_62_1
				var_62_4[1] = var_62_5[1] + var_62_0 * var_62_1
			end,
			on_complete = function(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
				return
			end
		}
	},
	lock_close = {
		{
			name = "sticks_open",
			start_progress = 2.6,
			end_progress = 3.1,
			init = function(arg_64_0, arg_64_1, arg_64_2, arg_64_3)
				return
			end,
			update = function(arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
				local var_65_0 = math.easeCubic(1 - arg_65_3)
				local var_65_1 = 50
				local var_65_2 = arg_65_0.lock_stick_top_left.local_position
				local var_65_3 = arg_65_1.lock_stick_top_left.position
				local var_65_4 = arg_65_0.lock_stick_top_right.local_position
				local var_65_5 = arg_65_1.lock_stick_top_right.position
				local var_65_6 = arg_65_0.lock_stick_bottom_left.local_position
				local var_65_7 = arg_65_1.lock_stick_bottom_left.position
				local var_65_8 = arg_65_0.lock_stick_bottom_right.local_position
				local var_65_9 = arg_65_1.lock_stick_bottom_right.position

				var_65_2[1] = var_65_3[1] - var_65_1 * var_65_0 + 50 * (1 - var_65_0)
				var_65_2[2] = var_65_3[2] + var_65_1 * var_65_0 - 50 * (1 - var_65_0)
				var_65_4[1] = var_65_5[1] + var_65_1 * var_65_0 - 50 * (1 - var_65_0)
				var_65_4[2] = var_65_5[2] + var_65_1 * var_65_0 - 50 * (1 - var_65_0)
				var_65_6[1] = var_65_7[1] - var_65_1 * var_65_0 + 50 * (1 - var_65_0)
				var_65_6[2] = var_65_7[2] - var_65_1 * var_65_0 + 50 * (1 - var_65_0)
				var_65_8[1] = var_65_9[1] + var_65_1 * var_65_0 - 50 * (1 - var_65_0)
				var_65_8[2] = var_65_9[2] - var_65_1 * var_65_0 + 50 * (1 - var_65_0)
			end,
			on_complete = function(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
				return
			end
		},
		{
			name = "cover_open",
			start_progress = 1.8,
			end_progress = 2.4,
			init = function(arg_67_0, arg_67_1, arg_67_2, arg_67_3)
				return
			end,
			update = function(arg_68_0, arg_68_1, arg_68_2, arg_68_3, arg_68_4)
				local var_68_0 = 90
				local var_68_1 = math.easeOutCubic(1 - arg_68_3)
				local var_68_2 = arg_68_0.lock_cover_top_left.local_position
				local var_68_3 = arg_68_1.lock_cover_top_left.position
				local var_68_4 = arg_68_0.lock_cover_top_right.local_position
				local var_68_5 = arg_68_1.lock_cover_top_right.position
				local var_68_6 = arg_68_0.lock_cover_bottom_left.local_position
				local var_68_7 = arg_68_1.lock_cover_bottom_left.position
				local var_68_8 = arg_68_0.lock_cover_bottom_right.local_position
				local var_68_9 = arg_68_1.lock_cover_bottom_right.position

				var_68_2[1] = var_68_3[1] - var_68_0 * var_68_1
				var_68_2[2] = var_68_3[2] + var_68_0 * var_68_1
				var_68_4[1] = var_68_5[1] + var_68_0 * var_68_1
				var_68_4[2] = var_68_5[2] + var_68_0 * var_68_1
				var_68_6[1] = var_68_7[1] - var_68_0 * var_68_1
				var_68_6[2] = var_68_7[2] - var_68_0 * var_68_1
				var_68_8[1] = var_68_9[1] + var_68_0 * var_68_1
				var_68_8[2] = var_68_9[2] - var_68_0 * var_68_1

				local var_68_10 = math.pi * 4 * var_68_1
				local var_68_11 = arg_68_2.lock_block_left
				local var_68_12 = arg_68_2.lock_block_right

				var_68_11.style.texture_id.angle = var_68_10
				var_68_12.style.texture_id.angle = var_68_10 + math.pi
			end,
			on_complete = function(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
				return
			end
		},
		{
			name = "top_and_bottom_pillar_lock",
			start_progress = 1.7,
			end_progress = 1.8,
			init = function(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
				return
			end,
			update = function(arg_71_0, arg_71_1, arg_71_2, arg_71_3, arg_71_4)
				local var_71_0 = 28
				local var_71_1 = math.ease_in_exp(1 - arg_71_3)
				local var_71_2 = arg_71_0.lock_pillar_top.local_position
				local var_71_3 = arg_71_1.lock_pillar_top.position
				local var_71_4 = arg_71_0.lock_pillar_bottom.local_position
				local var_71_5 = arg_71_1.lock_pillar_bottom.position

				var_71_2[2] = var_71_3[2] + var_71_0 * var_71_1
				var_71_4[2] = var_71_5[2] - var_71_0 * var_71_1
			end,
			on_complete = function(arg_72_0, arg_72_1, arg_72_2, arg_72_3)
				return
			end
		},
		{
			name = "cogwheel_bg_spin",
			start_progress = 1.2,
			end_progress = 1.6,
			init = function(arg_73_0, arg_73_1, arg_73_2, arg_73_3)
				return
			end,
			update = function(arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4)
				local var_74_0 = math.easeCubic(1 - arg_74_3)
				local var_74_1 = arg_74_2.lock_cogwheel_bg_left
				local var_74_2 = arg_74_2.lock_cogwheel_bg_right
				local var_74_3 = math.pi * 0.5 * var_74_0

				var_74_1.style.texture_id.angle = var_74_3
				var_74_2.style.texture_id.angle = var_74_3
			end,
			on_complete = function(arg_75_0, arg_75_1, arg_75_2, arg_75_3)
				return
			end
		},
		{
			name = "cogwheel_spin",
			start_progress = 0.1,
			end_progress = 1.1,
			init = function(arg_76_0, arg_76_1, arg_76_2, arg_76_3)
				return
			end,
			update = function(arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
				local var_77_0 = math.ease_exp(1 - arg_77_3)
				local var_77_1 = math.easeInCubic(1 - arg_77_3)
				local var_77_2 = arg_77_2.lock_slot_holder_left
				local var_77_3 = arg_77_2.lock_slot_holder_right
				local var_77_4 = arg_77_2.lock_cogwheel_left
				local var_77_5 = arg_77_2.lock_cogwheel_right
				local var_77_6 = math.pi / 2 * var_77_1
				local var_77_7 = math.pi * 2 * var_77_0

				var_77_2.style.texture_id.angle = -var_77_6
				var_77_3.style.texture_id.angle = -var_77_6
				var_77_4.style.texture_id.angle = var_77_7
				var_77_5.style.texture_id.angle = var_77_7
			end,
			on_complete = function(arg_78_0, arg_78_1, arg_78_2, arg_78_3)
				return
			end
		},
		{
			name = "left_and_right_pillar_lock",
			start_progress = 0,
			end_progress = 0.1,
			init = function(arg_79_0, arg_79_1, arg_79_2, arg_79_3)
				return
			end,
			update = function(arg_80_0, arg_80_1, arg_80_2, arg_80_3, arg_80_4)
				local var_80_0 = 28
				local var_80_1 = math.ease_in_exp(1 - arg_80_3)
				local var_80_2 = arg_80_0.lock_pillar_left.local_position
				local var_80_3 = arg_80_1.lock_pillar_left.position
				local var_80_4 = arg_80_0.lock_pillar_right.local_position
				local var_80_5 = arg_80_1.lock_pillar_right.position

				var_80_2[1] = var_80_3[1] - var_80_0 * var_80_1
				var_80_4[1] = var_80_5[1] + var_80_0 * var_80_1
			end,
			on_complete = function(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
				return
			end
		},
		{
			name = "finalize",
			start_progress = 3,
			end_progress = 3.5,
			init = function(arg_82_0, arg_82_1, arg_82_2, arg_82_3)
				return
			end,
			update = function(arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
				arg_83_2.lock_bg_left.content.visible = false
				arg_83_2.lock_bg_right.content.visible = false
				arg_83_2.lock_block_left.content.visible = false
				arg_83_2.lock_block_right.content.visible = false
				arg_83_2.lock_cogwheel_left.content.visible = false
				arg_83_2.lock_cogwheel_right.content.visible = false

				local var_83_0 = 120
				local var_83_1 = math.easeOutCubic(arg_83_3)

				arg_83_0.lock_pillar_left.local_position[1] = arg_83_1.lock_pillar_left.position[1] + var_83_0 * var_83_1
				arg_83_0.lock_pillar_right.local_position[1] = arg_83_1.lock_pillar_right.position[1] - var_83_0 * var_83_1
				arg_83_0.lock_pillar_top.local_position[2] = arg_83_1.lock_pillar_top.position[2] - var_83_0 * var_83_1
				arg_83_0.lock_pillar_bottom.local_position[2] = arg_83_1.lock_pillar_bottom.position[2] + var_83_0 * var_83_1

				local var_83_2 = 0.25
				local var_83_3 = arg_83_0.lock_cogwheel_bg_left.size
				local var_83_4 = arg_83_1.lock_cogwheel_bg_left.size

				var_83_3[1] = var_83_4[1] - var_83_4[1] * var_83_2 * var_83_1
				var_83_3[2] = var_83_4[2] - var_83_4[2] * var_83_2 * var_83_1

				local var_83_5 = arg_83_0.lock_cogwheel_bg_right.size
				local var_83_6 = arg_83_0.lock_cogwheel_bg_right.local_position
				local var_83_7 = arg_83_1.lock_cogwheel_bg_right.size
				local var_83_8 = arg_83_1.lock_cogwheel_bg_right.position

				var_83_5[1] = var_83_7[1] - var_83_7[1] * var_83_2 * var_83_1
				var_83_5[2] = var_83_7[2] - var_83_7[2] * var_83_2 * var_83_1
				var_83_6[1] = var_83_8[1] - var_83_8[1] * var_83_2 * var_83_1

				local var_83_9 = arg_83_0.lock_slot_holder_left.size
				local var_83_10 = arg_83_1.lock_slot_holder_left.size

				var_83_9[2] = var_83_10[2] - var_83_10[2] * var_83_2 * var_83_1

				local var_83_11 = arg_83_0.lock_slot_holder_right.size
				local var_83_12 = arg_83_1.lock_slot_holder_right.size

				var_83_11[2] = var_83_12[2] - var_83_12[2] * var_83_2 * var_83_1
			end,
			on_complete = function(arg_84_0, arg_84_1, arg_84_2, arg_84_3)
				return
			end
		}
	},
	reveal = {
		{
			name = "reveal",
			start_progress = 0.5 * var_0_29,
			end_progress = 1 * var_0_29,
			init = function(arg_85_0, arg_85_1, arg_85_2, arg_85_3)
				arg_85_2.lock_bg_left.content.visible = false
				arg_85_2.lock_bg_right.content.visible = false
				arg_85_2.lock_pillar_left.content.visible = false
				arg_85_2.lock_pillar_right.content.visible = false
				arg_85_2.lock_pillar_top.content.visible = false
				arg_85_2.lock_pillar_bottom.content.visible = false
				arg_85_2.lock_cogwheel_bg_left.content.visible = false
				arg_85_2.lock_cogwheel_bg_right.content.visible = false
				arg_85_2.lock_cogwheel_left.content.visible = false
				arg_85_2.lock_cogwheel_right.content.visible = false
				arg_85_2.lock_stick_top_left.content.visible = false
				arg_85_2.lock_stick_top_right.content.visible = false
				arg_85_2.lock_stick_bottom_left.content.visible = false
				arg_85_2.lock_stick_bottom_right.content.visible = false
				arg_85_2.lock_block_left.content.visible = false
				arg_85_2.lock_block_right.content.visible = false
				arg_85_2.lock_slot_holder_left.content.visible = false
				arg_85_2.lock_slot_holder_right.content.visible = false
				arg_85_2.left_mask.style.texture_id.color[1] = 0
				arg_85_2.right_mask.style.texture_id.color[1] = 0
				arg_85_2.top_mask.style.texture_id.color[1] = 0
				arg_85_2.bottom_mask.style.texture_id.color[1] = 0
				arg_85_2.center_mask.style.texture_id.color[1] = 0
				arg_85_0.mask_left.local_position[1] = 0
				arg_85_0.mask_left.local_position[2] = 0
				arg_85_0.mask_left.local_position[3] = 0
				arg_85_0.mask_right.local_position[1] = 0
				arg_85_0.mask_right.local_position[2] = 0
				arg_85_0.mask_right.local_position[3] = 0
				arg_85_0.mask_top.local_position[1] = 0
				arg_85_0.mask_top.local_position[2] = 0
				arg_85_0.mask_top.local_position[3] = 0
				arg_85_0.mask_bottom.local_position[1] = 0
				arg_85_0.mask_bottom.local_position[2] = 0
				arg_85_0.mask_bottom.local_position[3] = 0
				arg_85_0.mask_left.local_position[1] = 0
				arg_85_0.mask_left.local_position[2] = 0
				arg_85_0.mask_left.local_position[3] = 0
				arg_85_0.mask_right.local_position[1] = 0
				arg_85_0.mask_right.local_position[2] = 0
				arg_85_0.mask_right.local_position[3] = 0
				arg_85_0.mask_top.local_position[1] = 0
				arg_85_0.mask_top.local_position[2] = 0
				arg_85_0.mask_top.local_position[3] = 0
				arg_85_0.mask_bottom.local_position[1] = 0
				arg_85_0.mask_bottom.local_position[2] = 0
				arg_85_0.mask_bottom.local_position[3] = 0
				arg_85_0.frame_left.local_position[1] = 0
				arg_85_0.frame_left.local_position[2] = 0
				arg_85_0.frame_left.local_position[3] = 0
				arg_85_0.frame_top.local_position[1] = 0
				arg_85_0.frame_top.local_position[2] = 0
				arg_85_0.frame_top.local_position[3] = 0
				arg_85_0.frame_right.local_position[1] = 0
				arg_85_0.frame_right.local_position[2] = 0
				arg_85_0.frame_right.local_position[3] = 0
				arg_85_0.frame_bottom.local_position[1] = 0
				arg_85_0.frame_bottom.local_position[2] = 0
				arg_85_0.frame_bottom.local_position[3] = 0
			end,
			update = function(arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
				arg_86_2.frame_right.content.visible = true
				arg_86_2.frame_bottom.content.visible = true
				arg_86_2.frame_left.content.visible = true
				arg_86_2.frame_top.content.visible = true

				local var_86_0 = 130
				local var_86_1 = math.easeOutCubic(arg_86_3)
				local var_86_2 = arg_86_0.lock_cover_top_left.local_position
				local var_86_3 = arg_86_1.lock_cover_top_left.position
				local var_86_4 = arg_86_0.lock_cover_top_right.local_position
				local var_86_5 = arg_86_1.lock_cover_top_right.position
				local var_86_6 = arg_86_0.lock_cover_bottom_left.local_position
				local var_86_7 = arg_86_1.lock_cover_bottom_left.position
				local var_86_8 = arg_86_0.lock_cover_bottom_right.local_position
				local var_86_9 = arg_86_1.lock_cover_bottom_right.position

				var_86_2[1] = var_86_3[1] - var_86_0 * var_86_1
				var_86_2[2] = var_86_3[2] + var_86_0 * var_86_1
				var_86_4[1] = var_86_5[1] + var_86_0 * var_86_1
				var_86_4[2] = var_86_5[2] + var_86_0 * var_86_1
				var_86_6[1] = var_86_7[1] - var_86_0 * var_86_1
				var_86_6[2] = var_86_7[2] - var_86_0 * var_86_1
				var_86_8[1] = var_86_9[1] + var_86_0 * var_86_1
				var_86_8[2] = var_86_9[2] - var_86_0 * var_86_1

				local var_86_10 = arg_86_0.frame_left.local_position
				local var_86_11 = arg_86_1.frame_left.position
				local var_86_12 = arg_86_0.frame_top.local_position
				local var_86_13 = arg_86_1.frame_top.position
				local var_86_14 = arg_86_0.frame_right.local_position
				local var_86_15 = arg_86_1.frame_right.position
				local var_86_16 = arg_86_0.frame_bottom.local_position
				local var_86_17 = arg_86_1.frame_bottom.position

				var_86_10[1] = var_86_11[1] - (var_86_0 + 77) * var_86_1
				var_86_12[2] = var_86_13[2] + (var_86_0 + 85) * var_86_1
				var_86_14[1] = var_86_15[1] + (var_86_0 + 85) * var_86_1
				var_86_16[2] = var_86_17[2] - (var_86_0 + 85) * var_86_1

				local var_86_18 = arg_86_0.mask_left.local_position
				local var_86_19 = arg_86_1.mask_left.position
				local var_86_20 = arg_86_0.mask_right.local_position
				local var_86_21 = arg_86_1.mask_right.position
				local var_86_22 = arg_86_0.mask_bottom.local_position
				local var_86_23 = arg_86_1.mask_bottom.position
				local var_86_24 = arg_86_0.mask_top.local_position
				local var_86_25 = arg_86_1.mask_top.position

				var_86_18[1] = var_86_19[1] - 185 * var_86_1
				var_86_18[2] = var_86_19[2]
				var_86_20[1] = var_86_21[1] + 185 * var_86_1
				var_86_20[2] = var_86_21[2]
				var_86_22[2] = var_86_23[1] - 185 * var_86_1
				var_86_24[2] = var_86_25[2] + 185 * var_86_1
				arg_86_2.left_mask.style.texture_id.color[1] = arg_86_3 * 255
				arg_86_2.right_mask.style.texture_id.color[1] = arg_86_3 * 255
				arg_86_2.top_mask.style.texture_id.color[1] = arg_86_3 * 255
				arg_86_2.bottom_mask.style.texture_id.color[1] = arg_86_3 * 255
				arg_86_2.center_mask.style.texture_id.color[1] = arg_86_3 * 255
			end,
			on_complete = function(arg_87_0, arg_87_1, arg_87_2, arg_87_3)
				return
			end
		}
	},
	reveal_instant = {
		{
			name = "reveal_instant",
			start_progress = 0,
			end_progress = 0,
			init = function(arg_88_0, arg_88_1, arg_88_2, arg_88_3)
				arg_88_0.lock_root.position[2] = -355
				arg_88_2.lock_bg_left.content.visible = false
				arg_88_2.lock_bg_right.content.visible = false
				arg_88_2.lock_pillar_left.content.visible = false
				arg_88_2.lock_pillar_right.content.visible = false
				arg_88_2.lock_pillar_top.content.visible = false
				arg_88_2.lock_pillar_bottom.content.visible = false
				arg_88_2.lock_cogwheel_bg_left.content.visible = false
				arg_88_2.lock_cogwheel_bg_right.content.visible = false
				arg_88_2.lock_cogwheel_left.content.visible = false
				arg_88_2.lock_cogwheel_right.content.visible = false
				arg_88_2.lock_stick_top_left.content.visible = false
				arg_88_2.lock_stick_top_right.content.visible = false
				arg_88_2.lock_stick_bottom_left.content.visible = false
				arg_88_2.lock_stick_bottom_right.content.visible = false
				arg_88_2.lock_block_left.content.visible = false
				arg_88_2.lock_block_right.content.visible = false
				arg_88_2.lock_slot_holder_left.content.visible = false
				arg_88_2.lock_slot_holder_right.content.visible = false
				arg_88_2.lock_cover_top_left.content.visible = true
				arg_88_2.lock_cover_top_right.content.visible = true
				arg_88_2.lock_cover_bottom_left.content.visible = true
				arg_88_2.lock_cover_bottom_right.content.visible = true
				arg_88_2.frame_right.content.visible = true
				arg_88_2.frame_bottom.content.visible = true
				arg_88_2.frame_left.content.visible = true
				arg_88_2.frame_top.content.visible = true
				arg_88_2.left_mask.style.texture_id.color[1] = 0
				arg_88_2.right_mask.style.texture_id.color[1] = 0
				arg_88_2.top_mask.style.texture_id.color[1] = 0
				arg_88_2.bottom_mask.style.texture_id.color[1] = 0
				arg_88_2.center_mask.style.texture_id.color[1] = 0
				arg_88_0.mask_left.local_position[1] = 0
				arg_88_0.mask_left.local_position[2] = 0
				arg_88_0.mask_left.local_position[3] = 0
				arg_88_0.mask_right.local_position[1] = 0
				arg_88_0.mask_right.local_position[2] = 0
				arg_88_0.mask_right.local_position[3] = 0
				arg_88_0.mask_top.local_position[1] = 0
				arg_88_0.mask_top.local_position[2] = 0
				arg_88_0.mask_top.local_position[3] = 0
				arg_88_0.mask_bottom.local_position[1] = 0
				arg_88_0.mask_bottom.local_position[2] = 0
				arg_88_0.mask_bottom.local_position[3] = 0
				arg_88_0.mask_left.local_position[1] = 0
				arg_88_0.mask_left.local_position[2] = 0
				arg_88_0.mask_left.local_position[3] = 0
				arg_88_0.mask_right.local_position[1] = 0
				arg_88_0.mask_right.local_position[2] = 0
				arg_88_0.mask_right.local_position[3] = 0
				arg_88_0.mask_top.local_position[1] = 0
				arg_88_0.mask_top.local_position[2] = 0
				arg_88_0.mask_top.local_position[3] = 0
				arg_88_0.mask_bottom.local_position[1] = 0
				arg_88_0.mask_bottom.local_position[2] = 0
				arg_88_0.mask_bottom.local_position[3] = 0
				arg_88_0.frame_left.local_position[1] = 0
				arg_88_0.frame_left.local_position[2] = 0
				arg_88_0.frame_left.local_position[3] = 0
				arg_88_0.frame_top.local_position[1] = 0
				arg_88_0.frame_top.local_position[2] = 0
				arg_88_0.frame_top.local_position[3] = 0
				arg_88_0.frame_right.local_position[1] = 0
				arg_88_0.frame_right.local_position[2] = 0
				arg_88_0.frame_right.local_position[3] = 0
				arg_88_0.frame_bottom.local_position[1] = 0
				arg_88_0.frame_bottom.local_position[2] = 0
				arg_88_0.frame_bottom.local_position[3] = 0
			end,
			update = function(arg_89_0, arg_89_1, arg_89_2, arg_89_3, arg_89_4)
				arg_89_2.frame_right.content.visible = true
				arg_89_2.frame_bottom.content.visible = true
				arg_89_2.frame_left.content.visible = true
				arg_89_2.frame_top.content.visible = true

				local var_89_0 = 130
				local var_89_1 = math.easeOutCubic(arg_89_3)
				local var_89_2 = arg_89_0.lock_cover_top_left.local_position
				local var_89_3 = arg_89_1.lock_cover_top_left.position
				local var_89_4 = arg_89_0.lock_cover_top_right.local_position
				local var_89_5 = arg_89_1.lock_cover_top_right.position
				local var_89_6 = arg_89_0.lock_cover_bottom_left.local_position
				local var_89_7 = arg_89_1.lock_cover_bottom_left.position
				local var_89_8 = arg_89_0.lock_cover_bottom_right.local_position
				local var_89_9 = arg_89_1.lock_cover_bottom_right.position

				var_89_2[1] = var_89_3[1] - var_89_0 * var_89_1
				var_89_2[2] = var_89_3[2] + var_89_0 * var_89_1
				var_89_4[1] = var_89_5[1] + var_89_0 * var_89_1
				var_89_4[2] = var_89_5[2] + var_89_0 * var_89_1
				var_89_6[1] = var_89_7[1] - var_89_0 * var_89_1
				var_89_6[2] = var_89_7[2] - var_89_0 * var_89_1
				var_89_8[1] = var_89_9[1] + var_89_0 * var_89_1
				var_89_8[2] = var_89_9[2] - var_89_0 * var_89_1

				local var_89_10 = arg_89_0.frame_left.local_position
				local var_89_11 = arg_89_1.frame_left.position
				local var_89_12 = arg_89_0.frame_top.local_position
				local var_89_13 = arg_89_1.frame_top.position
				local var_89_14 = arg_89_0.frame_right.local_position
				local var_89_15 = arg_89_1.frame_right.position
				local var_89_16 = arg_89_0.frame_bottom.local_position
				local var_89_17 = arg_89_1.frame_bottom.position

				var_89_10[1] = var_89_11[1] - (var_89_0 + 77) * var_89_1
				var_89_12[2] = var_89_13[2] + (var_89_0 + 85) * var_89_1
				var_89_14[1] = var_89_15[1] + (var_89_0 + 85) * var_89_1
				var_89_16[2] = var_89_17[2] - (var_89_0 + 85) * var_89_1

				local var_89_18 = arg_89_0.mask_left.local_position
				local var_89_19 = arg_89_1.mask_left.position
				local var_89_20 = arg_89_0.mask_right.local_position
				local var_89_21 = arg_89_1.mask_right.position
				local var_89_22 = arg_89_0.mask_bottom.local_position
				local var_89_23 = arg_89_1.mask_bottom.position
				local var_89_24 = arg_89_0.mask_top.local_position
				local var_89_25 = arg_89_1.mask_top.position

				var_89_18[1] = var_89_19[1] - 185 * var_89_1
				var_89_18[2] = var_89_19[2]
				var_89_20[1] = var_89_21[1] + 185 * var_89_1
				var_89_20[2] = var_89_21[2]
				var_89_22[2] = var_89_23[1] - 185 * var_89_1
				var_89_24[2] = var_89_25[2] + 185 * var_89_1
				arg_89_2.left_mask.style.texture_id.color[1] = arg_89_3 * 255
				arg_89_2.right_mask.style.texture_id.color[1] = arg_89_3 * 255
				arg_89_2.top_mask.style.texture_id.color[1] = arg_89_3 * 255
				arg_89_2.bottom_mask.style.texture_id.color[1] = arg_89_3 * 255
				arg_89_2.center_mask.style.texture_id.color[1] = arg_89_3 * 255
			end,
			on_complete = function(arg_90_0, arg_90_1, arg_90_2, arg_90_3)
				return
			end
		}
	},
	hide_instant = {
		{
			name = "hide_instant",
			start_progress = 0,
			end_progress = 0,
			init = function(arg_91_0, arg_91_1, arg_91_2, arg_91_3)
				arg_91_0.lock_root.position[2] = -355
				arg_91_2.lock_bg_left.content.visible = false
				arg_91_2.lock_bg_right.content.visible = false
				arg_91_2.lock_pillar_left.content.visible = false
				arg_91_2.lock_pillar_right.content.visible = false
				arg_91_2.lock_pillar_top.content.visible = false
				arg_91_2.lock_pillar_bottom.content.visible = false
				arg_91_2.lock_cogwheel_bg_left.content.visible = false
				arg_91_2.lock_cogwheel_bg_right.content.visible = false
				arg_91_2.lock_cogwheel_left.content.visible = false
				arg_91_2.lock_cogwheel_right.content.visible = false
				arg_91_2.lock_stick_top_left.content.visible = false
				arg_91_2.lock_stick_top_right.content.visible = false
				arg_91_2.lock_stick_bottom_left.content.visible = false
				arg_91_2.lock_stick_bottom_right.content.visible = false
				arg_91_2.lock_block_left.content.visible = false
				arg_91_2.lock_block_right.content.visible = false
				arg_91_2.lock_slot_holder_left.content.visible = false
				arg_91_2.lock_slot_holder_right.content.visible = false
				arg_91_2.lock_cover_top_left.content.visible = false
				arg_91_2.lock_cover_top_right.content.visible = false
				arg_91_2.lock_cover_bottom_left.content.visible = false
				arg_91_2.lock_cover_bottom_right.content.visible = false
				arg_91_2.frame_right.content.visible = false
				arg_91_2.frame_bottom.content.visible = false
				arg_91_2.frame_left.content.visible = false
				arg_91_2.frame_top.content.visible = false
				arg_91_2.left_mask.style.texture_id.color[1] = 0
				arg_91_2.right_mask.style.texture_id.color[1] = 0
				arg_91_2.top_mask.style.texture_id.color[1] = 0
				arg_91_2.bottom_mask.style.texture_id.color[1] = 0
				arg_91_2.center_mask.style.texture_id.color[1] = 0
				arg_91_0.mask_left.local_position[1] = 0
				arg_91_0.mask_left.local_position[2] = 0
				arg_91_0.mask_left.local_position[3] = 0
				arg_91_0.mask_right.local_position[1] = 0
				arg_91_0.mask_right.local_position[2] = 0
				arg_91_0.mask_right.local_position[3] = 0
				arg_91_0.mask_top.local_position[1] = 0
				arg_91_0.mask_top.local_position[2] = 0
				arg_91_0.mask_top.local_position[3] = 0
				arg_91_0.mask_bottom.local_position[1] = 0
				arg_91_0.mask_bottom.local_position[2] = 0
				arg_91_0.mask_bottom.local_position[3] = 0
				arg_91_0.mask_left.local_position[1] = 0
				arg_91_0.mask_left.local_position[2] = 0
				arg_91_0.mask_left.local_position[3] = 0
				arg_91_0.mask_right.local_position[1] = 0
				arg_91_0.mask_right.local_position[2] = 0
				arg_91_0.mask_right.local_position[3] = 0
				arg_91_0.mask_top.local_position[1] = 0
				arg_91_0.mask_top.local_position[2] = 0
				arg_91_0.mask_top.local_position[3] = 0
				arg_91_0.mask_bottom.local_position[1] = 0
				arg_91_0.mask_bottom.local_position[2] = 0
				arg_91_0.mask_bottom.local_position[3] = 0
				arg_91_0.frame_left.local_position[1] = 0
				arg_91_0.frame_left.local_position[2] = 0
				arg_91_0.frame_left.local_position[3] = 0
				arg_91_0.frame_top.local_position[1] = 0
				arg_91_0.frame_top.local_position[2] = 0
				arg_91_0.frame_top.local_position[3] = 0
				arg_91_0.frame_right.local_position[1] = 0
				arg_91_0.frame_right.local_position[2] = 0
				arg_91_0.frame_right.local_position[3] = 0
				arg_91_0.frame_bottom.local_position[1] = 0
				arg_91_0.frame_bottom.local_position[2] = 0
				arg_91_0.frame_bottom.local_position[3] = 0
			end,
			update = function(arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4)
				return
			end,
			on_complete = function(arg_93_0, arg_93_1, arg_93_2, arg_93_3)
				return
			end
		}
	}
}
local var_0_31 = {
	default = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	},
	multiple_rewards = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "special_1",
			priority = 2,
			description_text = "input_description_toggle"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	},
	claim_available = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "welcome_currency_popup_button_claim"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	}
}

return {
	gotwf_item_size = {
		var_0_13[1] + var_0_10,
		var_0_13[2]
	},
	icon_scale = var_0_11,
	create_item_definition_func = var_0_18,
	widgets = var_0_27,
	lock_widgets = var_0_28,
	bottom_widgets = var_0_25,
	background_widgets = var_0_24,
	viewport_widgets = var_0_26,
	scenegraph_definition = var_0_14,
	animation_definitions = var_0_30,
	generic_input_actions = var_0_31,
	create_simple_item = var_0_16,
	create_claim_button = var_0_23
}
