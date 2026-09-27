-- chunkname: @scripts/ui/views/hero_view/windows/definitions/hero_window_gotwf_overview_definitions.lua

local game_start_windows = UISettings.game_start_windows
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local large_window_frame = game_start_windows.large_window_frame
local var_0_4 = UIFrameSettings[large_window_frame].texture_sizes.vertical[1]
local tbl = {
	size[1] * 3 + spacing * 2 + var_0_4 * 2,
	size[2] + 80
}
local tbl_2 = {
	tbl[1] + 50,
	tbl[2]
}
local str = "menu_frame_11"
local var_0_8 = UIFrameSettings[str].texture_sizes.vertical[1]
local game_start_windows_2 = UISettings.game_start_windows
local num = 20
local num_2 = 0.845
local tbl_3 = {
	59,
	31
}
local tbl_4 = {
	260 * num_2,
	250 * num_2
}
local tbl_5 = {
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
		size = tbl_2,
		position = {
			(1920 - tbl_2[1]) * 0.5,
			(1080 - tbl_2[2]) * 0.5 * -1,
			1
		}
	},
	write_mask = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_2[1],
			tbl_2[2] + 100
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
			tbl_2[1],
			tbl_4[2] + 70
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
		size = tbl_4,
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
			tbl_4[1],
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
local tbl_6 = {
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

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}
	local str = "item_icon"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		texture_id = str,
		style_id = str,
		content_check_function = function (self)
			-- function 2
			return self[str]
		end
	}
	tbl_4[str] = {
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
	tbl_3[str] = arg_1_1

	UIWidgets.append_item_frame_pass("item_frame", tbl_2, tbl_3, tbl_4, arg_1_2, {
		0,
		0,
		4
	}, arg_1_4, nil, {
		horizontal_alignment = "center",
		vertical_alignment = "center"
	}, nil, function (self)
		-- function 3
		return self[str]
	end)

	local str_2 = "rarity_texture"

	tbl_2[#tbl_2 + 1] = {
		pass_type = "texture",
		texture_id = str_2,
		style_id = str_2,
		content_check_function = function (self)
			-- function 4
			return self[str]
		end
	}
	tbl_4[str_2] = {
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
	tbl_3[str_2] = "icon_bg_default"
	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_4
	tbl.offset = arg_1_3 or {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_1_0

	return tbl
end

local num_3 = 50

local function fn_2(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8, arg_5_9, arg_5_10)
	-- function 5
	local str = "menu_frame_16"
	local var_5_1 = UIFrameSettings[str]
	local str_2 = "frame_outer_glow_04"
	local var_5_3 = UIFrameSettings[str_2]
	local var_5_4 = var_5_3.texture_sizes.horizontal[2]
	local str_3 = "frame_outer_glow_04_big"
	local var_5_6 = UIFrameSettings[str_3]
	local var_5_7 = var_5_6.texture_sizes.horizontal[2]
	local str_4 = "menu_frame_08"
	local var_5_9 = UIFrameSettings[str_4]
	local var_5_10 = var_5_9.texture_sizes.horizontal[2]
	local flag

	flag = arg_5_4 or not arg_5_7 and arg_5_8 and not arg_5_6 or 255 or 60

	local num_2 = 75
	local num_4

	if not (not arg_5_10 and arg_5_10.bundle) then
		num_4 = 1
	elseif not arg_5_7 then
		num_4 = 1
	else
		if not arg_5_10 then
			num_4 = #arg_5_10

			if not num_4 then
				-- Nothing
			end
		end

		num_4 = 1
	end

	::label_5_0::

	local num_5 = 1 - (num_4 - 1) * 0.25
	local num_6 = 0
	local tbl = {
		element = {}
	}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_5 = {}
	local tbl_6 = {
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
			content_check_function = function (self)
				-- function 6
				return self.owned
			end
		},
		{
			pass_type = "texture",
			style_id = "owned_icon_bg",
			texture_id = "owned_icon_bg",
			content_check_function = function (self)
				-- function 7
				return self.owned
			end
		},
		{
			style_id = "loading_icon",
			pass_type = "rotated_texture",
			texture_id = "loading_icon",
			content_check_function = function (self)
				-- function 8
				local flag = true

				for i = 1, num_4 do
					if not self["icon_" .. i] then
						flag = false

						break
					end
				end

				return not not flag or not not self.hidden or not self.disable_loading_icon
			end,
			content_change_function = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				-- function 9
				local progress = arg_9_1.progress

				progress = progress or 0

				local num = (progress + arg_9_3) % 1

				arg_9_1.angle = math.pow(2, math.smoothstep(num, 0, 1)) * (math.pi * 2)
				arg_9_1.progress = num
			end
		},
		{
			pass_type = "texture",
			style_id = "package_icon",
			texture_id = "package_icon",
			content_check_function = function (self)
				-- function 10
				return self.hidden
			end
		}
	}
	local tbl_7 = {}

	for i = 1, num_4 do
		tbl_7[#tbl_7 + 1] = i
	end

	local tbl_8 = {
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
		num_rewards = num_4,
		rewards = arg_5_10,
		reward_order = tbl_7
	}
	local tbl_9 = {}
	local tbl_10 = {
		font_size = 32,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "bottom",
		dynamic_font_size = false
	}
	local flag_2

	flag_2 = not arg_5_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_10.font_type = flag_2

	local get_color_table_with_alpha

	if not arg_5_4 then
		get_color_table_with_alpha = Colors.get_color_table_with_alpha("font_title", 255)

		if not get_color_table_with_alpha then
			-- Nothing
		end
	end

	get_color_table_with_alpha = Colors.get_color_table_with_alpha("gray", 255)

	::label_5_1::

	tbl_10.text_color = get_color_table_with_alpha
	tbl_10.offset = {
		0,
		-20 - ((arg_5_4 or not arg_5_9 or not arg_5_6) and num_2 or 0),
		10
	}
	tbl_9.date_text = tbl_10

	local tbl_11 = {
		font_size = 32,
		upper_case = true,
		localize = false,
		horizontal_alignment = "center",
		vertical_alignment = "bottom",
		dynamic_font_size = false
	}
	local flag_3

	flag_3 = not arg_5_2 and "hell_shark_header_masked" and "hell_shark_header"
	tbl_11.font_type = flag_3
	tbl_11.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_11.offset = {
		2,
		-22 - ((arg_5_4 or not arg_5_9 or not arg_5_6) and num_2 or 0),
		9
	}
	tbl_9.date_text_shadow = tbl_11
	tbl_9.loading_icon = {
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
	}
	tbl_9.owned_icon = {
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
			12 + 16 * (num_4 - 1)
		},
		default_offset = {
			5,
			20,
			12 + 16 * (num_4 - 1)
		}
	}
	tbl_9.owned_icon_bg = {
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
			11 + 16 * (num_4 - 1)
		},
		default_offset = {
			2,
			-45,
			11 + 16 * (num_4 - 1)
		}
	}
	tbl_9.package_icon = {
		vertical_alignment = "top",
		horizontal_alignment = "left",
		masked = arg_5_2,
		texture_size = arg_5_1,
		color = {
			255,
			flag,
			flag,
			flag
		},
		offset = {
			0,
			0,
			7
		}
	}

	table.append(tbl_2, tbl_6)
	table.merge(tbl_3, tbl_8)
	table.merge(tbl_5, tbl_9)

	local var_5_29 = arg_5_1

	for j = 1, num_4 do
		local tbl_12 = {
			(j - 1) * num_3,
			(j - 1) * -num_3,
			(j - 1) * 15
		}
		local tbl_13 = {
			var_5_29[1] * num_5,
			var_5_29[2] * num_5
		}
		local tbl_14 = {
			{
				pass_type = "hotspot",
				content_id = "hotspot_" .. j,
				style_id = "hotspot_" .. j
			},
			{
				pass_type = "texture",
				texture_id = "rect",
				style_id = "overlay_" .. j
			},
			{
				pass_type = "texture",
				texture_id = "rect",
				style_id = "background_rect_" .. j
			},
			{
				pass_type = "texture",
				texture_id = "background_" .. j,
				style_id = "background_" .. j,
				content_check_function = function (self)
					-- function 11
					return self["background_" .. j]
				end
			},
			{
				pass_type = "texture_frame",
				texture_id = "frame",
				style_id = "frame_" .. j
			},
			{
				pass_type = "texture_frame",
				texture_id = "hover_frame",
				style_id = "hover_frame_" .. j
			},
			{
				pass_type = "texture_frame",
				texture_id = "pulse_frame",
				style_id = "pulse_frame_" .. j
			},
			{
				pass_type = "texture_uv",
				content_id = "painting_" .. j,
				style_id = "painting_" .. j,
				content_check_function = function (self)
					-- function 12
					return self.texture_id
				end
			},
			{
				pass_type = "texture_frame",
				texture_id = "painting_frame",
				style_id = "painting_frame_" .. j,
				content_check_function = function (self)
					-- function 13
					return self.painting
				end
			},
			{
				pass_type = "texture",
				texture_id = "icon_" .. j,
				style_id = "icon_" .. j,
				content_check_function = function (self)
					-- function 14
					local var_14_0 = self["icon_" .. j]

					var_14_0 = not var_14_0 and not self.rendering_loading_icon

					return var_14_0
				end
			},
			{
				pass_type = "texture",
				texture_id = "type_tag_icon_" .. j,
				style_id = "type_tag_icon_" .. j,
				content_check_function = function (self)
					-- function 15
					return self["type_tag_icon_" .. j] ~= nil
				end
			}
		}
		local tbl_15 = {
			["hotspot_" .. j] = {},
			["icon_" .. j] = nil,
			["painting_" .. j] = nil,
			["background_" .. j] = nil,
			["type_tag_icon_" .. j] = nil
		}
		local tbl_16 = {
			["hotspot_" .. j] = {
				size = {
					tbl_4[1] * num_5,
					tbl_4[2]
				},
				base_offset = {
					0,
					0,
					0
				},
				offset = {
					0 + tbl_12[1],
					0 + tbl_12[2],
					0 + tbl_12[3]
				}
			},
			["background_rect_" .. j] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				masked = arg_5_2,
				texture_size = tbl_13,
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
					0 + tbl_12[1],
					0 + tbl_12[2],
					0 + tbl_12[3]
				}
			},
			["background_" .. j] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				masked = arg_5_2,
				texture_size = tbl_13,
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
					0 + tbl_12[1],
					0 + tbl_12[2],
					1 + tbl_12[3]
				}
			},
			["overlay_" .. j] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				masked = arg_5_2,
				texture_size = tbl_13,
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
					0 + tbl_12[1],
					0 + tbl_12[2],
					8 + tbl_12[3]
				}
			},
			["type_tag_icon_" .. j] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				masked = arg_5_2,
				texture_size = {
					56,
					56
				},
				color = {
					255,
					flag,
					flag,
					flag
				},
				base_offset = {
					tbl_13[1] - 56,
					0,
					9
				},
				offset = {
					tbl_13[1] - 56 + tbl_12[1],
					0 + tbl_12[2],
					9 + tbl_12[3]
				}
			},
			["icon_" .. j] = {
				vertical_alignment = "top",
				horizontal_alignment = "left",
				masked = arg_5_2,
				texture_size = tbl_13,
				color = {
					255,
					flag,
					flag,
					flag
				},
				base_offset = {
					0,
					0,
					7
				},
				offset = {
					0 + tbl_12[1],
					0 + tbl_12[2],
					7 + tbl_12[3]
				}
			},
			["frame_" .. j] = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				masked = arg_5_2,
				area_size = tbl_13,
				texture_size = var_5_1.texture_size,
				texture_sizes = var_5_1.texture_sizes,
				frame_margins = {
					0,
					0
				},
				color = {
					255,
					flag,
					flag,
					flag
				},
				base_offset = {
					0,
					0,
					10
				},
				offset = {
					0 + tbl_12[1],
					0 + tbl_12[2],
					10 + tbl_12[3]
				}
			},
			["hover_frame_" .. j] = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				masked = arg_5_2,
				area_size = tbl_13,
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
					0 + tbl_12[1],
					0 + tbl_12[2],
					6 + tbl_12[3]
				}
			},
			["pulse_frame_" .. j] = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				masked = arg_5_2,
				area_size = tbl_13,
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
					0 + tbl_12[1],
					0 + tbl_12[2],
					12 + tbl_12[3]
				}
			},
			["painting_" .. j] = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				masked = arg_5_2,
				texture_size = tbl_13,
				color = {
					255,
					flag,
					flag,
					flag
				},
				base_offset = {
					0,
					0,
					7
				},
				offset = {
					0 + tbl_12[1],
					0 + tbl_12[2],
					7 + tbl_12[3]
				}
			},
			["painting_frame_" .. j] = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				masked = arg_5_2,
				area_size = tbl_13,
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
					0 + tbl_12[1],
					0 + tbl_12[2],
					12 + tbl_12[3]
				}
			}
		}

		table.append(tbl_2, tbl_14)
		table.merge(tbl_3, tbl_15)
		table.merge(tbl_5, tbl_16)
	end

	tbl.element.passes = tbl_2
	tbl.content = tbl_3
	tbl.style = tbl_5
	tbl.offset = {
		10 + (arg_5_3 - 1) * (arg_5_1[1] + num),
		(arg_5_4 or not arg_5_9 or not arg_5_6) and num_2 or 0,
		5
	}
	tbl.scenegraph_id = arg_5_0

	return tbl
end

local function fn_3(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8, arg_16_9)
	-- function 16
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
					content_check_function = function (self, arg_17_1)
						-- function 17
						return self.hotspot.is_hover
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
				texture_size = tbl_3,
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
				texture_size = tbl_3,
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
	-- function 18
	arg_18_3 = arg_18_3 or "button_bg_01"

	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(arg_18_3)
	local var_18_1

	if not arg_18_2 then
		var_18_1 = UIFrameSettings[arg_18_2]

		if not var_18_1 then
			-- Nothing
		end
	end

	var_18_1 = UIFrameSettings.button_frame_01

	::label_18_0::

	local var_18_2 = var_18_1.texture_sizes.corner[1]
	local flag = arg_18_7 or "button_detail_01"
	local size = UIAtlasHelper.get_atlas_settings_by_texture_name(flag).size
	local var_18_5
	local var_18_6
	local str = "frame_outer_glow_04"
	local var_18_8 = UIFrameSettings[str]
	local var_18_9 = var_18_8.texture_sizes.horizontal[2]

	if not arg_18_8 then
		if type(arg_18_8) == "table" then
			var_18_5 = arg_18_8[1]
			var_18_6 = arg_18_8[2]
		else
			var_18_5 = arg_18_8
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
					content_check_function = function (self)
						-- function 19
						return self.draw_frame
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
					content_check_function = function (self)
						-- function 20
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "side_detail_right",
					pass_type = "texture_uv",
					content_id = "side_detail",
					content_check_function = function (self)
						-- function 21
						return not self.skip_side_detail
					end
				},
				{
					texture_id = "texture_id",
					style_id = "side_detail_left",
					pass_type = "texture",
					content_id = "side_detail",
					content_check_function = function (self)
						-- function 22
						return not self.skip_side_detail
					end
				},
				{
					style_id = "title_text",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 23
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "title_text_disabled",
					pass_type = "text",
					text_id = "title_text",
					content_check_function = function (self)
						-- function 24
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
					style_id = "hover_frame",
					texture_id = "hover_frame",
					pass_type = "texture_frame",
					content_check_function = function (arg_25_0)
						-- function 25
						return (Managers.input:is_device_active("gamepad"))
					end,
					content_change_function = function (self, arg_26_1)
						-- function 26
						local num = 2
						local time_and_delta, var_26_2 = Managers.time:time_and_delta("main")
						local gamepad_selected = self.gamepad_selected
						local gamepad_selection_progress = self.gamepad_selection_progress
						local num_2 = 0

						if not gamepad_selected then
							gamepad_selection_progress = math.min(gamepad_selection_progress + var_26_2 * num, 1)
							num_2 = math.easeOutCubic(gamepad_selection_progress)
						else
							gamepad_selection_progress = math.max(gamepad_selection_progress - var_26_2 * num, 0)
							num_2 = math.easeInCubic(gamepad_selection_progress)
						end

						arg_26_1.color[1] = num_2 * 255
						self.gamepad_selection_progress = gamepad_selection_progress
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
				texture_id = flag,
				skip_side_detail = arg_18_10
			},
			button_hotspot = {},
			title_text = arg_18_4 or "n/a",
			frame = var_18_1.texture,
			background = {
				uvs = {
					{
						0,
						1 - arg_18_1[2] / get_atlas_settings_by_texture_name.size[2]
					},
					{
						arg_18_1[1] / get_atlas_settings_by_texture_name.size[1],
						1
					}
				},
				texture_id = arg_18_3
			},
			disable_with_gamepad = arg_18_9,
			hover_frame = var_18_8.texture
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
		}
	}
	local tbl_3 = {
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_size = arg_18_5 or 24
	}
	local flag_2

	flag_2 = not arg_18_11 and "hell_shark_masked" and "hell_shark"
	tbl_3.font_type = flag_2
	tbl_3.text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_3.default_text_color = Colors.get_color_table_with_alpha("font_button_normal", 255)
	tbl_3.select_text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_3.size = {
		arg_18_1[1] - 40,
		arg_18_1[2]
	}
	tbl_3.offset = {
		20,
		0,
		6
	}
	tbl_2.title_text = tbl_3

	local tbl_4 = {
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_size = arg_18_5 or 24
	}
	local flag_3

	flag_3 = not arg_18_11 and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_3
	tbl_4.text_color = Colors.get_color_table_with_alpha("gray", 255)
	tbl_4.default_text_color = Colors.get_color_table_with_alpha("gray", 255)
	tbl_4.size = {
		arg_18_1[1] - 40,
		arg_18_1[2]
	}
	tbl_4.offset = {
		20,
		0,
		6
	}
	tbl_2.title_text_disabled = tbl_4

	local tbl_5 = {
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		font_size = arg_18_5 or 24
	}
	local flag_4

	flag_4 = not arg_18_11 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag_4
	tbl_5.text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_5.default_text_color = Colors.get_color_table_with_alpha("black", 255)
	tbl_5.size = {
		arg_18_1[1] - 40,
		arg_18_1[2]
	}
	tbl_5.offset = {
		22,
		-2,
		5
	}
	tbl_2.title_text_shadow = tbl_5
	tbl_2.frame = {
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
	}
	tbl_2.glass_top = {
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
	}
	tbl_2.glass_bottom = {
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
	}

	local tbl_6 = {
		color = {
			255,
			255,
			255,
			255
		}
	}
	local tbl_7 = {
		nil,
		nil,
		9
	}
	local num

	if not var_18_5 then
		num = -var_18_5

		if not num then
			-- Nothing
		end
	end

	num = -9

	::label_18_1::

	tbl_7[1] = num
	tbl_7[2] = arg_18_1[2] / 2 - size[2] / 2 + (var_18_6 or 0)
	tbl_6.offset = tbl_7
	tbl_6.size = {
		size[1],
		size[2]
	}
	tbl_6.masked = arg_18_11
	tbl_2.side_detail_left = tbl_6
	tbl_2.side_detail_right = {
		color = {
			255,
			255,
			255,
			255
		},
		offset = {
			arg_18_1[1] - size[1] + (var_18_5 or 9),
			arg_18_1[2] / 2 - size[2] / 2 + (var_18_6 or 0),
			9
		},
		size = {
			size[1],
			size[2]
		},
		masked = arg_18_11
	}
	tbl_2.hover_frame = {
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
	tbl.style = tbl_2
	tbl.scenegraph_id = arg_18_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

local flag = false
local flag_2 = true
local flag_3 = true

local function fn_4()
	-- function 27
	return create_claim_button_definition("claim_button", tbl_5.claim_button.size, nil, nil, Localize("welcome_currency_popup_button_claim"), 26, nil, nil, nil, flag, flag_2, flag_3)
end

local tbl_7 = {
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
local tbl_8 = {
	bg_black = UIWidgets.create_simple_rect("screen", {
		255,
		0,
		0,
		0
	})
}
local tbl_9 = {
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
local tbl_10 = {
	arrow_left = fn_3("achievement_arrow", "achievement_arrow_hover", math.pi * 0.5, {
		tbl_3[1] * 0.5,
		tbl_3[2] * 0.5
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
	arrow_right = fn_3("achievement_arrow", "achievement_arrow_hover", -math.pi * 0.5, {
		tbl_3[1] * 0.5,
		tbl_3[2] * 0.5
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
	gotwf_description = UIWidgets.create_simple_text("", "gotwf_description", nil, nil, tbl_6),
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
local tbl_11 = {
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
local num_4 = 0.5
local tbl_12 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.7,
			init = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
				-- function 28
				arg_28_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
				-- function 29
				local easeOutCubic = math.easeOutCubic(arg_29_3)

				arg_29_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3)
				-- function 30
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
				-- function 31
				arg_31_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
				-- function 32
				local easeOutCubic = math.easeOutCubic(arg_32_3)

				arg_32_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
				-- function 33
				return
			end
		}
	},
	item_rotation = {
		{
			name = "item_rotation",
			start_progress = 0,
			end_progress = 0.5,
			init = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3)
				-- function 34
				local item_widget = arg_34_3.item_widget
				local content = item_widget.content
				local style = item_widget.style
				local reward_index = arg_34_3.reward_index
				local reward_order = content.reward_order
				local find = table.find(reward_order, reward_index)

				arg_34_3.start_index = find

				table.remove(reward_order, find)

				reward_order[#reward_order + 1] = reward_index
				style["background_rect_" .. reward_index].color[1] = 0
				style["background_" .. reward_index].color[1] = 0
				style["type_tag_icon_" .. reward_index].color[1] = 0
				style["icon_" .. reward_index].color[1] = 0
				style["frame_" .. reward_index].color[1] = 0
				style["hover_frame_" .. reward_index].color[1] = 0
				style["pulse_frame_" .. reward_index].color[1] = 0
				style["painting_" .. reward_index].color[1] = 0
				style["painting_frame_" .. reward_index].color[1] = 0
			end,
			update = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
				-- function 35
				local easeOutCubic = math.easeOutCubic(arg_35_3)
				local item_widget = arg_35_4.item_widget
				local content = item_widget.content
				local style = item_widget.style
				local reward_order = content.reward_order
				local reward_index = arg_35_4.reward_index

				for i = arg_35_4.start_index, #reward_order do
					local var_35_6 = reward_order[i]
					local tbl = {
						i * num_3,
						i * -num_3,
						i * 15
					}
					local tbl_2 = {
						(i - 1) * num_3,
						(i - 1) * -num_3,
						(i - 1) * 15
					}

					style["hotspot_" .. var_35_6].offset[1] = math.lerp(style["hotspot_" .. var_35_6].base_offset[1] + tbl[1], style["hotspot_" .. var_35_6].base_offset[1] + tbl_2[1], easeOutCubic)
					style["hotspot_" .. var_35_6].offset[2] = math.lerp(style["hotspot_" .. var_35_6].base_offset[2] + tbl[2], style["hotspot_" .. var_35_6].base_offset[2] + tbl_2[2], easeOutCubic)
					style["hotspot_" .. var_35_6].offset[3] = math.lerp(style["hotspot_" .. var_35_6].base_offset[3] + tbl[3], style["hotspot_" .. var_35_6].base_offset[3] + tbl_2[3], easeOutCubic)
					style["background_rect_" .. var_35_6].offset[1] = math.lerp(style["background_rect_" .. var_35_6].base_offset[1] + tbl[1], style["background_rect_" .. var_35_6].base_offset[1] + tbl_2[1], easeOutCubic)
					style["background_rect_" .. var_35_6].offset[2] = math.lerp(style["background_rect_" .. var_35_6].base_offset[2] + tbl[2], style["background_rect_" .. var_35_6].base_offset[2] + tbl_2[2], easeOutCubic)
					style["background_rect_" .. var_35_6].offset[3] = math.lerp(style["background_rect_" .. var_35_6].base_offset[3] + tbl[3], style["background_rect_" .. var_35_6].base_offset[3] + tbl_2[3], easeOutCubic)
					style["background_" .. var_35_6].offset[1] = math.lerp(style["background_" .. var_35_6].base_offset[1] + tbl[1], style["background_" .. var_35_6].base_offset[1] + tbl_2[1], easeOutCubic)
					style["background_" .. var_35_6].offset[2] = math.lerp(style["background_" .. var_35_6].base_offset[2] + tbl[2], style["background_" .. var_35_6].base_offset[2] + tbl_2[2], easeOutCubic)
					style["background_" .. var_35_6].offset[3] = math.lerp(style["background_" .. var_35_6].base_offset[3] + tbl[3], style["background_" .. var_35_6].base_offset[3] + tbl_2[3], easeOutCubic)
					style["overlay_" .. var_35_6].offset[1] = math.lerp(style["overlay_" .. var_35_6].base_offset[1] + tbl[1], style["overlay_" .. var_35_6].base_offset[1] + tbl_2[1], easeOutCubic)
					style["overlay_" .. var_35_6].offset[2] = math.lerp(style["overlay_" .. var_35_6].base_offset[2] + tbl[2], style["overlay_" .. var_35_6].base_offset[2] + tbl_2[2], easeOutCubic)
					style["overlay_" .. var_35_6].offset[3] = math.lerp(style["overlay_" .. var_35_6].base_offset[3] + tbl[3], style["overlay_" .. var_35_6].base_offset[3] + tbl_2[3], easeOutCubic)
					style["type_tag_icon_" .. var_35_6].offset[1] = math.lerp(style["type_tag_icon_" .. var_35_6].base_offset[1] + tbl[1], style["type_tag_icon_" .. var_35_6].base_offset[1] + tbl_2[1], easeOutCubic)
					style["type_tag_icon_" .. var_35_6].offset[2] = math.lerp(style["type_tag_icon_" .. var_35_6].base_offset[2] + tbl[2], style["type_tag_icon_" .. var_35_6].base_offset[2] + tbl_2[2], easeOutCubic)
					style["type_tag_icon_" .. var_35_6].offset[3] = math.lerp(style["type_tag_icon_" .. var_35_6].base_offset[3] + tbl[3], style["type_tag_icon_" .. var_35_6].base_offset[3] + tbl_2[3], easeOutCubic)
					style["icon_" .. var_35_6].offset[1] = math.lerp(style["icon_" .. var_35_6].base_offset[1] + tbl[1], style["icon_" .. var_35_6].base_offset[1] + tbl_2[1], easeOutCubic)
					style["icon_" .. var_35_6].offset[2] = math.lerp(style["icon_" .. var_35_6].base_offset[2] + tbl[2], style["icon_" .. var_35_6].base_offset[2] + tbl_2[2], easeOutCubic)
					style["icon_" .. var_35_6].offset[3] = math.lerp(style["icon_" .. var_35_6].base_offset[3] + tbl[3], style["icon_" .. var_35_6].base_offset[3] + tbl_2[3], easeOutCubic)
					style["frame_" .. var_35_6].offset[1] = math.lerp(style["frame_" .. var_35_6].base_offset[1] + tbl[1], style["frame_" .. var_35_6].base_offset[1] + tbl_2[1], easeOutCubic)
					style["frame_" .. var_35_6].offset[2] = math.lerp(style["frame_" .. var_35_6].base_offset[2] + tbl[2], style["frame_" .. var_35_6].base_offset[2] + tbl_2[2], easeOutCubic)
					style["frame_" .. var_35_6].offset[3] = math.lerp(style["frame_" .. var_35_6].base_offset[3] + tbl[3], style["frame_" .. var_35_6].base_offset[3] + tbl_2[3], easeOutCubic)
					style["hover_frame_" .. var_35_6].offset[1] = math.lerp(style["hover_frame_" .. var_35_6].base_offset[1] + tbl[1], style["hover_frame_" .. var_35_6].base_offset[1] + tbl_2[1], easeOutCubic)
					style["hover_frame_" .. var_35_6].offset[2] = math.lerp(style["hover_frame_" .. var_35_6].base_offset[2] + tbl[2], style["hover_frame_" .. var_35_6].base_offset[2] + tbl_2[2], easeOutCubic)
					style["hover_frame_" .. var_35_6].offset[3] = math.lerp(style["hover_frame_" .. var_35_6].base_offset[3] + tbl[3], style["hover_frame_" .. var_35_6].base_offset[3] + tbl_2[3], easeOutCubic)
					style["pulse_frame_" .. var_35_6].offset[1] = math.lerp(style["pulse_frame_" .. var_35_6].base_offset[1] + tbl[1], style["pulse_frame_" .. var_35_6].base_offset[1] + tbl_2[1], easeOutCubic)
					style["pulse_frame_" .. var_35_6].offset[2] = math.lerp(style["pulse_frame_" .. var_35_6].base_offset[2] + tbl[2], style["pulse_frame_" .. var_35_6].base_offset[2] + tbl_2[2], easeOutCubic)
					style["pulse_frame_" .. var_35_6].offset[3] = math.lerp(style["pulse_frame_" .. var_35_6].base_offset[3] + tbl[3], style["pulse_frame_" .. var_35_6].base_offset[3] + tbl_2[3], easeOutCubic)
					style["painting_" .. var_35_6].offset[1] = math.lerp(style["painting_" .. var_35_6].base_offset[1] + tbl[1], style["painting_" .. var_35_6].base_offset[1] + tbl_2[1], easeOutCubic)
					style["painting_" .. var_35_6].offset[2] = math.lerp(style["painting_" .. var_35_6].base_offset[2] + tbl[2], style["painting_" .. var_35_6].base_offset[2] + tbl_2[2], easeOutCubic)
					style["painting_" .. var_35_6].offset[3] = math.lerp(style["painting_" .. var_35_6].base_offset[3] + tbl[3], style["painting_" .. var_35_6].base_offset[3] + tbl_2[3], easeOutCubic)
					style["painting_frame_" .. var_35_6].offset[1] = math.lerp(style["painting_frame_" .. var_35_6].base_offset[1] + tbl[1], style["painting_frame_" .. var_35_6].base_offset[1] + tbl_2[1], easeOutCubic)
					style["painting_frame_" .. var_35_6].offset[2] = math.lerp(style["painting_frame_" .. var_35_6].base_offset[2] + tbl[2], style["painting_frame_" .. var_35_6].base_offset[2] + tbl_2[2], easeOutCubic)
					style["painting_frame_" .. var_35_6].offset[3] = math.lerp(style["painting_frame_" .. var_35_6].base_offset[3] + tbl[3], style["painting_frame_" .. var_35_6].base_offset[3] + tbl_2[3], easeOutCubic)

					if var_35_6 == reward_index then
						style["background_rect_" .. var_35_6].color[1] = easeOutCubic * 255
						style["background_" .. var_35_6].color[1] = easeOutCubic * 255
						style["type_tag_icon_" .. var_35_6].color[1] = easeOutCubic * 255
						style["icon_" .. var_35_6].color[1] = easeOutCubic * 255
						style["frame_" .. var_35_6].color[1] = easeOutCubic * 255
						style["painting_" .. var_35_6].color[1] = easeOutCubic * 255
						style["painting_frame_" .. var_35_6].color[1] = easeOutCubic * 255
					end
				end
			end,
			on_complete = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
				-- function 36
				local style = arg_36_3.item_widget.style
				local reward_index = arg_36_3.reward_index

				style["background_rect_" .. reward_index].color[1] = 255
				style["background_" .. reward_index].color[1] = 255
				style["type_tag_icon_" .. reward_index].color[1] = 255
				style["icon_" .. reward_index].color[1] = 255
				style["frame_" .. reward_index].color[1] = 255
				style["painting_" .. reward_index].color[1] = 255
				style["painting_frame_" .. reward_index].color[1] = 255
			end
		}
	},
	hide_item_list = {
		{
			name = "hide_item_list",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
				-- function 37
				arg_37_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
				-- function 38
				local easeOutCubic = math.easeOutCubic(arg_38_3)

				arg_38_0.gotwf_window.local_position[2] = arg_38_1.gotwf_window.position[2] - 500 * easeOutCubic
				arg_38_0.scrollbar_area.local_position[2] = arg_38_1.scrollbar_area.position[2] - 500 * easeOutCubic
				arg_38_0.arrow_left.local_position[2] = arg_38_1.arrow_left.position[2] - 500 * easeOutCubic
				arg_38_0.arrow_right.local_position[2] = arg_38_1.arrow_right.position[2] - 500 * easeOutCubic
			end,
			on_complete = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
				-- function 39
				return
			end
		}
	},
	show_item_list = {
		{
			name = "show_item_list",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
				-- function 40
				arg_40_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
				-- function 41
				local easeOutCubic = math.easeOutCubic(arg_41_3)

				arg_41_0.gotwf_window.local_position[2] = arg_41_1.gotwf_window.position[2] - 500 * (1 - easeOutCubic)
				arg_41_0.scrollbar_area.local_position[2] = arg_41_1.scrollbar_area.position[2] - 500 * (1 - easeOutCubic)
				arg_41_0.arrow_left.local_position[2] = arg_41_1.arrow_left.position[2] - 500 * (1 - easeOutCubic)
				arg_41_0.arrow_right.local_position[2] = arg_41_1.arrow_right.position[2] - 500 * (1 - easeOutCubic)
			end,
			on_complete = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
				-- function 42
				return
			end
		}
	},
	lock_open = {
		{
			name = "animate_in",
			start_progress = 0 * num_4,
			end_progress = 1 * num_4,
			init = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
				-- function 43
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
			update = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
				-- function 44
				local easeOutCubic = math.easeOutCubic(arg_44_3)

				arg_44_0.lock_root.position[2] = math.lerp(arg_44_1.lock_root.position[2], -355, easeOutCubic)
			end,
			on_complete = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
				-- function 45
				return
			end
		},
		{
			name = "sticks_open",
			start_progress = 0.5 * num_4,
			end_progress = 1 * num_4,
			init = function (self, arg_46_1, arg_46_2, arg_46_3)
				-- function 46
				local local_position = self.lock_stick_top_left.local_position
				local position = arg_46_1.lock_stick_top_left.position
				local local_position_2 = self.lock_stick_top_right.local_position
				local position_2 = arg_46_1.lock_stick_top_right.position

				local_position_2[1] = position_2[1]
				local_position_2[2] = position_2[2]

				local local_position_3 = self.lock_stick_bottom_left.local_position
				local position_3 = arg_46_1.lock_stick_bottom_left.position

				local_position_3[1] = position_3[1]
				local_position_3[2] = position_3[2]

				local local_position_4 = self.lock_stick_bottom_right.local_position
				local position_4 = arg_46_1.lock_stick_bottom_right.position

				local_position_4[1] = position_4[1]
				local_position_4[2] = position_4[2]

				local local_position_5 = self.lock_cover_top_left.local_position
				local position_5 = arg_46_1.lock_cover_top_left.position

				local_position_5[1] = position_5[1]
				local_position_5[2] = position_5[2]

				local local_position_6 = self.lock_cover_top_right.local_position
				local position_6 = arg_46_1.lock_cover_top_right.position

				local_position_6[1] = position_6[1]
				local_position_6[2] = position_6[2]

				local local_position_7 = self.lock_cover_bottom_left.local_position
				local position_7 = arg_46_1.lock_cover_bottom_left.position

				local_position_7[1] = position_7[1]
				local_position_7[2] = position_7[2]

				local local_position_8 = self.lock_cover_bottom_right.local_position
				local position_8 = arg_46_1.lock_cover_bottom_right.position

				local_position_8[1] = position_8[1]
				local_position_8[2] = position_8[2]
				self.lock_pillar_left.local_position[1] = arg_46_1.lock_pillar_left.position[1]
				self.lock_pillar_right.local_position[1] = arg_46_1.lock_pillar_right.position[1]
				self.lock_pillar_top.local_position[2] = arg_46_1.lock_pillar_top.position[2]
				self.lock_pillar_bottom.local_position[2] = arg_46_1.lock_pillar_bottom.position[2]
				arg_46_2.lock_cogwheel_left.style.texture_id.angle = 0
				arg_46_2.lock_cogwheel_right.style.texture_id.angle = 0
				arg_46_2.lock_slot_holder_left.style.texture_id.angle = 0
				arg_46_2.lock_slot_holder_right.style.texture_id.angle = 0
				arg_46_2.lock_block_left.style.texture_id.angle = 0
				arg_46_2.lock_block_right.style.texture_id.angle = math.pi
				arg_46_2.lock_cogwheel_bg_left.style.texture_id.angle = 0
				arg_46_2.lock_cogwheel_bg_right.style.texture_id.angle = 0
			end,
			update = function (self, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
				-- function 47
				local easeCubic = math.easeCubic(arg_47_3)
				local num = 50
				local local_position = self.lock_stick_top_left.local_position
				local position = arg_47_1.lock_stick_top_left.position
				local local_position_2 = self.lock_stick_top_right.local_position
				local position_2 = arg_47_1.lock_stick_top_right.position
				local local_position_3 = self.lock_stick_bottom_left.local_position
				local position_3 = arg_47_1.lock_stick_bottom_left.position
				local local_position_4 = self.lock_stick_bottom_right.local_position
				local position_4 = arg_47_1.lock_stick_bottom_right.position

				local_position[1] = position[1] - num * easeCubic
				local_position[2] = position[2] + num * easeCubic
				local_position_2[1] = position_2[1] + num * easeCubic
				local_position_2[2] = position_2[2] + num * easeCubic
				local_position_3[1] = position_3[1] - num * easeCubic
				local_position_3[2] = position_3[2] - num * easeCubic
				local_position_4[1] = position_4[1] + num * easeCubic
				local_position_4[2] = position_4[2] - num * easeCubic
			end,
			on_complete = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
				-- function 48
				return
			end
		},
		{
			name = "cover_open",
			start_progress = 1.2 * num_4,
			end_progress = 1.8 * num_4,
			init = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
				-- function 49
				return
			end,
			update = function (self, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
				-- function 50
				local num = 90
				local easeOutCubic = math.easeOutCubic(arg_50_3)
				local local_position = self.lock_cover_top_left.local_position
				local position = arg_50_1.lock_cover_top_left.position
				local local_position_2 = self.lock_cover_top_right.local_position
				local position_2 = arg_50_1.lock_cover_top_right.position
				local local_position_3 = self.lock_cover_bottom_left.local_position
				local position_3 = arg_50_1.lock_cover_bottom_left.position
				local local_position_4 = self.lock_cover_bottom_right.local_position
				local position_4 = arg_50_1.lock_cover_bottom_right.position

				local_position[1] = position[1] - num * easeOutCubic
				local_position[2] = position[2] + num * easeOutCubic
				local_position_2[1] = position_2[1] + num * easeOutCubic
				local_position_2[2] = position_2[2] + num * easeOutCubic
				local_position_3[1] = position_3[1] - num * easeOutCubic
				local_position_3[2] = position_3[2] - num * easeOutCubic
				local_position_4[1] = position_4[1] + num * easeOutCubic
				local_position_4[2] = position_4[2] - num * easeOutCubic

				local num_2 = math.pi * 4 * easeOutCubic
				local lock_block_left = arg_50_2.lock_block_left
				local lock_block_right = arg_50_2.lock_block_right

				lock_block_left.style.texture_id.angle = num_2
				lock_block_right.style.texture_id.angle = num_2 + math.pi
			end,
			on_complete = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
				-- function 51
				return
			end
		},
		{
			name = "top_and_bottom_pillar_lock",
			start_progress = 1.8 * num_4,
			end_progress = 1.9 * num_4,
			init = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
				-- function 52
				return
			end,
			update = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
				-- function 53
				local num = 28
				local ease_in_exp = math.ease_in_exp(arg_53_3)
				local local_position = self.lock_pillar_top.local_position
				local position = arg_53_1.lock_pillar_top.position
				local local_position_2 = self.lock_pillar_bottom.local_position
				local position_2 = arg_53_1.lock_pillar_bottom.position

				local_position[2] = position[2] + num * ease_in_exp
				local_position_2[2] = position_2[2] - num * ease_in_exp
			end,
			on_complete = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3)
				-- function 54
				return
			end
		},
		{
			name = "cogwheel_bg_spin",
			start_progress = 2 * num_4,
			end_progress = 2.4 * num_4,
			init = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
				-- function 55
				return
			end,
			update = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
				-- function 56
				local easeCubic = math.easeCubic(arg_56_3)
				local lock_cogwheel_bg_left = arg_56_2.lock_cogwheel_bg_left
				local lock_cogwheel_bg_right = arg_56_2.lock_cogwheel_bg_right
				local num = math.pi * 0.5 * easeCubic

				lock_cogwheel_bg_left.style.texture_id.angle = num
				lock_cogwheel_bg_right.style.texture_id.angle = num
			end,
			on_complete = function (arg_57_0, arg_57_1, arg_57_2, arg_57_3)
				-- function 57
				return
			end
		},
		{
			name = "cogwheel_spin",
			start_progress = 2.5 * num_4,
			end_progress = 3.5 * num_4,
			init = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
				-- function 58
				return
			end,
			update = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
				-- function 59
				local ease_exp = math.ease_exp(arg_59_3)
				local easeInCubic = math.easeInCubic(arg_59_3)
				local lock_slot_holder_left = arg_59_2.lock_slot_holder_left
				local lock_slot_holder_right = arg_59_2.lock_slot_holder_right
				local lock_cogwheel_left = arg_59_2.lock_cogwheel_left
				local lock_cogwheel_right = arg_59_2.lock_cogwheel_right
				local num = math.pi / 2 * easeInCubic
				local num_2 = math.pi * 2 * ease_exp

				lock_slot_holder_left.style.texture_id.angle = -num
				lock_slot_holder_right.style.texture_id.angle = -num
				lock_cogwheel_left.style.texture_id.angle = num_2
				lock_cogwheel_right.style.texture_id.angle = num_2
			end,
			on_complete = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
				-- function 60
				return
			end
		},
		{
			name = "left_and_right_pillar_lock",
			start_progress = 3.5 * num_4,
			end_progress = 3.6 * num_4,
			init = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
				-- function 61
				return
			end,
			update = function (self, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
				-- function 62
				local num = 28
				local ease_in_exp = math.ease_in_exp(arg_62_3)
				local local_position = self.lock_pillar_left.local_position
				local position = arg_62_1.lock_pillar_left.position
				local local_position_2 = self.lock_pillar_right.local_position
				local position_2 = arg_62_1.lock_pillar_right.position

				local_position[1] = position[1] - num * ease_in_exp
				local_position_2[1] = position_2[1] + num * ease_in_exp
			end,
			on_complete = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
				-- function 63
				return
			end
		}
	},
	lock_close = {
		{
			name = "sticks_open",
			start_progress = 2.6,
			end_progress = 3.1,
			init = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
				-- function 64
				return
			end,
			update = function (self, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
				-- function 65
				local easeCubic = math.easeCubic(1 - arg_65_3)
				local num = 50
				local local_position = self.lock_stick_top_left.local_position
				local position = arg_65_1.lock_stick_top_left.position
				local local_position_2 = self.lock_stick_top_right.local_position
				local position_2 = arg_65_1.lock_stick_top_right.position
				local local_position_3 = self.lock_stick_bottom_left.local_position
				local position_3 = arg_65_1.lock_stick_bottom_left.position
				local local_position_4 = self.lock_stick_bottom_right.local_position
				local position_4 = arg_65_1.lock_stick_bottom_right.position

				local_position[1] = position[1] - num * easeCubic + 50 * (1 - easeCubic)
				local_position[2] = position[2] + num * easeCubic - 50 * (1 - easeCubic)
				local_position_2[1] = position_2[1] + num * easeCubic - 50 * (1 - easeCubic)
				local_position_2[2] = position_2[2] + num * easeCubic - 50 * (1 - easeCubic)
				local_position_3[1] = position_3[1] - num * easeCubic + 50 * (1 - easeCubic)
				local_position_3[2] = position_3[2] - num * easeCubic + 50 * (1 - easeCubic)
				local_position_4[1] = position_4[1] + num * easeCubic - 50 * (1 - easeCubic)
				local_position_4[2] = position_4[2] - num * easeCubic + 50 * (1 - easeCubic)
			end,
			on_complete = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
				-- function 66
				return
			end
		},
		{
			name = "cover_open",
			start_progress = 1.8,
			end_progress = 2.4,
			init = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
				-- function 67
				return
			end,
			update = function (self, arg_68_1, arg_68_2, arg_68_3, arg_68_4)
				-- function 68
				local num = 90
				local easeOutCubic = math.easeOutCubic(1 - arg_68_3)
				local local_position = self.lock_cover_top_left.local_position
				local position = arg_68_1.lock_cover_top_left.position
				local local_position_2 = self.lock_cover_top_right.local_position
				local position_2 = arg_68_1.lock_cover_top_right.position
				local local_position_3 = self.lock_cover_bottom_left.local_position
				local position_3 = arg_68_1.lock_cover_bottom_left.position
				local local_position_4 = self.lock_cover_bottom_right.local_position
				local position_4 = arg_68_1.lock_cover_bottom_right.position

				local_position[1] = position[1] - num * easeOutCubic
				local_position[2] = position[2] + num * easeOutCubic
				local_position_2[1] = position_2[1] + num * easeOutCubic
				local_position_2[2] = position_2[2] + num * easeOutCubic
				local_position_3[1] = position_3[1] - num * easeOutCubic
				local_position_3[2] = position_3[2] - num * easeOutCubic
				local_position_4[1] = position_4[1] + num * easeOutCubic
				local_position_4[2] = position_4[2] - num * easeOutCubic

				local num_2 = math.pi * 4 * easeOutCubic
				local lock_block_left = arg_68_2.lock_block_left
				local lock_block_right = arg_68_2.lock_block_right

				lock_block_left.style.texture_id.angle = num_2
				lock_block_right.style.texture_id.angle = num_2 + math.pi
			end,
			on_complete = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3)
				-- function 69
				return
			end
		},
		{
			name = "top_and_bottom_pillar_lock",
			start_progress = 1.7,
			end_progress = 1.8,
			init = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
				-- function 70
				return
			end,
			update = function (self, arg_71_1, arg_71_2, arg_71_3, arg_71_4)
				-- function 71
				local num = 28
				local ease_in_exp = math.ease_in_exp(1 - arg_71_3)
				local local_position = self.lock_pillar_top.local_position
				local position = arg_71_1.lock_pillar_top.position
				local local_position_2 = self.lock_pillar_bottom.local_position
				local position_2 = arg_71_1.lock_pillar_bottom.position

				local_position[2] = position[2] + num * ease_in_exp
				local_position_2[2] = position_2[2] - num * ease_in_exp
			end,
			on_complete = function (arg_72_0, arg_72_1, arg_72_2, arg_72_3)
				-- function 72
				return
			end
		},
		{
			name = "cogwheel_bg_spin",
			start_progress = 1.2,
			end_progress = 1.6,
			init = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
				-- function 73
				return
			end,
			update = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3, arg_74_4)
				-- function 74
				local easeCubic = math.easeCubic(1 - arg_74_3)
				local lock_cogwheel_bg_left = arg_74_2.lock_cogwheel_bg_left
				local lock_cogwheel_bg_right = arg_74_2.lock_cogwheel_bg_right
				local num = math.pi * 0.5 * easeCubic

				lock_cogwheel_bg_left.style.texture_id.angle = num
				lock_cogwheel_bg_right.style.texture_id.angle = num
			end,
			on_complete = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3)
				-- function 75
				return
			end
		},
		{
			name = "cogwheel_spin",
			start_progress = 0.1,
			end_progress = 1.1,
			init = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3)
				-- function 76
				return
			end,
			update = function (arg_77_0, arg_77_1, arg_77_2, arg_77_3, arg_77_4)
				-- function 77
				local ease_exp = math.ease_exp(1 - arg_77_3)
				local easeInCubic = math.easeInCubic(1 - arg_77_3)
				local lock_slot_holder_left = arg_77_2.lock_slot_holder_left
				local lock_slot_holder_right = arg_77_2.lock_slot_holder_right
				local lock_cogwheel_left = arg_77_2.lock_cogwheel_left
				local lock_cogwheel_right = arg_77_2.lock_cogwheel_right
				local num = math.pi / 2 * easeInCubic
				local num_2 = math.pi * 2 * ease_exp

				lock_slot_holder_left.style.texture_id.angle = -num
				lock_slot_holder_right.style.texture_id.angle = -num
				lock_cogwheel_left.style.texture_id.angle = num_2
				lock_cogwheel_right.style.texture_id.angle = num_2
			end,
			on_complete = function (arg_78_0, arg_78_1, arg_78_2, arg_78_3)
				-- function 78
				return
			end
		},
		{
			name = "left_and_right_pillar_lock",
			start_progress = 0,
			end_progress = 0.1,
			init = function (arg_79_0, arg_79_1, arg_79_2, arg_79_3)
				-- function 79
				return
			end,
			update = function (self, arg_80_1, arg_80_2, arg_80_3, arg_80_4)
				-- function 80
				local num = 28
				local ease_in_exp = math.ease_in_exp(1 - arg_80_3)
				local local_position = self.lock_pillar_left.local_position
				local position = arg_80_1.lock_pillar_left.position
				local local_position_2 = self.lock_pillar_right.local_position
				local position_2 = arg_80_1.lock_pillar_right.position

				local_position[1] = position[1] - num * ease_in_exp
				local_position_2[1] = position_2[1] + num * ease_in_exp
			end,
			on_complete = function (arg_81_0, arg_81_1, arg_81_2, arg_81_3)
				-- function 81
				return
			end
		},
		{
			name = "finalize",
			start_progress = 3,
			end_progress = 3.5,
			init = function (arg_82_0, arg_82_1, arg_82_2, arg_82_3)
				-- function 82
				return
			end,
			update = function (self, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
				-- function 83
				arg_83_2.lock_bg_left.content.visible = false
				arg_83_2.lock_bg_right.content.visible = false
				arg_83_2.lock_block_left.content.visible = false
				arg_83_2.lock_block_right.content.visible = false
				arg_83_2.lock_cogwheel_left.content.visible = false
				arg_83_2.lock_cogwheel_right.content.visible = false

				local num = 120
				local easeOutCubic = math.easeOutCubic(arg_83_3)

				self.lock_pillar_left.local_position[1] = arg_83_1.lock_pillar_left.position[1] + num * easeOutCubic
				self.lock_pillar_right.local_position[1] = arg_83_1.lock_pillar_right.position[1] - num * easeOutCubic
				self.lock_pillar_top.local_position[2] = arg_83_1.lock_pillar_top.position[2] - num * easeOutCubic
				self.lock_pillar_bottom.local_position[2] = arg_83_1.lock_pillar_bottom.position[2] + num * easeOutCubic

				local num_2 = 0.25
				local size = self.lock_cogwheel_bg_left.size
				local size_2 = arg_83_1.lock_cogwheel_bg_left.size

				size[1] = size_2[1] - size_2[1] * num_2 * easeOutCubic
				size[2] = size_2[2] - size_2[2] * num_2 * easeOutCubic

				local size_3 = self.lock_cogwheel_bg_right.size
				local local_position = self.lock_cogwheel_bg_right.local_position
				local size_4 = arg_83_1.lock_cogwheel_bg_right.size
				local position = arg_83_1.lock_cogwheel_bg_right.position

				size_3[1] = size_4[1] - size_4[1] * num_2 * easeOutCubic
				size_3[2] = size_4[2] - size_4[2] * num_2 * easeOutCubic
				local_position[1] = position[1] - position[1] * num_2 * easeOutCubic

				local size_5 = self.lock_slot_holder_left.size
				local size_6 = arg_83_1.lock_slot_holder_left.size

				size_5[2] = size_6[2] - size_6[2] * num_2 * easeOutCubic

				local size_7 = self.lock_slot_holder_right.size
				local size_8 = arg_83_1.lock_slot_holder_right.size

				size_7[2] = size_8[2] - size_8[2] * num_2 * easeOutCubic
			end,
			on_complete = function (arg_84_0, arg_84_1, arg_84_2, arg_84_3)
				-- function 84
				return
			end
		}
	},
	reveal = {
		{
			name = "reveal",
			start_progress = 0.5 * num_4,
			end_progress = 1 * num_4,
			init = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
				-- function 85
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
			update = function (self, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
				-- function 86
				arg_86_2.frame_right.content.visible = true
				arg_86_2.frame_bottom.content.visible = true
				arg_86_2.frame_left.content.visible = true
				arg_86_2.frame_top.content.visible = true

				local num = 130
				local easeOutCubic = math.easeOutCubic(arg_86_3)
				local local_position = self.lock_cover_top_left.local_position
				local position = arg_86_1.lock_cover_top_left.position
				local local_position_2 = self.lock_cover_top_right.local_position
				local position_2 = arg_86_1.lock_cover_top_right.position
				local local_position_3 = self.lock_cover_bottom_left.local_position
				local position_3 = arg_86_1.lock_cover_bottom_left.position
				local local_position_4 = self.lock_cover_bottom_right.local_position
				local position_4 = arg_86_1.lock_cover_bottom_right.position

				local_position[1] = position[1] - num * easeOutCubic
				local_position[2] = position[2] + num * easeOutCubic
				local_position_2[1] = position_2[1] + num * easeOutCubic
				local_position_2[2] = position_2[2] + num * easeOutCubic
				local_position_3[1] = position_3[1] - num * easeOutCubic
				local_position_3[2] = position_3[2] - num * easeOutCubic
				local_position_4[1] = position_4[1] + num * easeOutCubic
				local_position_4[2] = position_4[2] - num * easeOutCubic

				local local_position_5 = self.frame_left.local_position
				local position_5 = arg_86_1.frame_left.position
				local local_position_6 = self.frame_top.local_position
				local position_6 = arg_86_1.frame_top.position
				local local_position_7 = self.frame_right.local_position
				local position_7 = arg_86_1.frame_right.position
				local local_position_8 = self.frame_bottom.local_position
				local position_8 = arg_86_1.frame_bottom.position

				local_position_5[1] = position_5[1] - (num + 77) * easeOutCubic
				local_position_6[2] = position_6[2] + (num + 85) * easeOutCubic
				local_position_7[1] = position_7[1] + (num + 85) * easeOutCubic
				local_position_8[2] = position_8[2] - (num + 85) * easeOutCubic

				local local_position_9 = self.mask_left.local_position
				local position_9 = arg_86_1.mask_left.position
				local local_position_10 = self.mask_right.local_position
				local position_10 = arg_86_1.mask_right.position
				local local_position_11 = self.mask_bottom.local_position
				local position_11 = arg_86_1.mask_bottom.position
				local local_position_12 = self.mask_top.local_position
				local position_12 = arg_86_1.mask_top.position

				local_position_9[1] = position_9[1] - 185 * easeOutCubic
				local_position_9[2] = position_9[2]
				local_position_10[1] = position_10[1] + 185 * easeOutCubic
				local_position_10[2] = position_10[2]
				local_position_11[2] = position_11[1] - 185 * easeOutCubic
				local_position_12[2] = position_12[2] + 185 * easeOutCubic
				arg_86_2.left_mask.style.texture_id.color[1] = arg_86_3 * 255
				arg_86_2.right_mask.style.texture_id.color[1] = arg_86_3 * 255
				arg_86_2.top_mask.style.texture_id.color[1] = arg_86_3 * 255
				arg_86_2.bottom_mask.style.texture_id.color[1] = arg_86_3 * 255
				arg_86_2.center_mask.style.texture_id.color[1] = arg_86_3 * 255
			end,
			on_complete = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3)
				-- function 87
				return
			end
		}
	},
	reveal_instant = {
		{
			name = "reveal_instant",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3)
				-- function 88
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
			update = function (self, arg_89_1, arg_89_2, arg_89_3, arg_89_4)
				-- function 89
				arg_89_2.frame_right.content.visible = true
				arg_89_2.frame_bottom.content.visible = true
				arg_89_2.frame_left.content.visible = true
				arg_89_2.frame_top.content.visible = true

				local num = 130
				local easeOutCubic = math.easeOutCubic(arg_89_3)
				local local_position = self.lock_cover_top_left.local_position
				local position = arg_89_1.lock_cover_top_left.position
				local local_position_2 = self.lock_cover_top_right.local_position
				local position_2 = arg_89_1.lock_cover_top_right.position
				local local_position_3 = self.lock_cover_bottom_left.local_position
				local position_3 = arg_89_1.lock_cover_bottom_left.position
				local local_position_4 = self.lock_cover_bottom_right.local_position
				local position_4 = arg_89_1.lock_cover_bottom_right.position

				local_position[1] = position[1] - num * easeOutCubic
				local_position[2] = position[2] + num * easeOutCubic
				local_position_2[1] = position_2[1] + num * easeOutCubic
				local_position_2[2] = position_2[2] + num * easeOutCubic
				local_position_3[1] = position_3[1] - num * easeOutCubic
				local_position_3[2] = position_3[2] - num * easeOutCubic
				local_position_4[1] = position_4[1] + num * easeOutCubic
				local_position_4[2] = position_4[2] - num * easeOutCubic

				local local_position_5 = self.frame_left.local_position
				local position_5 = arg_89_1.frame_left.position
				local local_position_6 = self.frame_top.local_position
				local position_6 = arg_89_1.frame_top.position
				local local_position_7 = self.frame_right.local_position
				local position_7 = arg_89_1.frame_right.position
				local local_position_8 = self.frame_bottom.local_position
				local position_8 = arg_89_1.frame_bottom.position

				local_position_5[1] = position_5[1] - (num + 77) * easeOutCubic
				local_position_6[2] = position_6[2] + (num + 85) * easeOutCubic
				local_position_7[1] = position_7[1] + (num + 85) * easeOutCubic
				local_position_8[2] = position_8[2] - (num + 85) * easeOutCubic

				local local_position_9 = self.mask_left.local_position
				local position_9 = arg_89_1.mask_left.position
				local local_position_10 = self.mask_right.local_position
				local position_10 = arg_89_1.mask_right.position
				local local_position_11 = self.mask_bottom.local_position
				local position_11 = arg_89_1.mask_bottom.position
				local local_position_12 = self.mask_top.local_position
				local position_12 = arg_89_1.mask_top.position

				local_position_9[1] = position_9[1] - 185 * easeOutCubic
				local_position_9[2] = position_9[2]
				local_position_10[1] = position_10[1] + 185 * easeOutCubic
				local_position_10[2] = position_10[2]
				local_position_11[2] = position_11[1] - 185 * easeOutCubic
				local_position_12[2] = position_12[2] + 185 * easeOutCubic
				arg_89_2.left_mask.style.texture_id.color[1] = arg_89_3 * 255
				arg_89_2.right_mask.style.texture_id.color[1] = arg_89_3 * 255
				arg_89_2.top_mask.style.texture_id.color[1] = arg_89_3 * 255
				arg_89_2.bottom_mask.style.texture_id.color[1] = arg_89_3 * 255
				arg_89_2.center_mask.style.texture_id.color[1] = arg_89_3 * 255
			end,
			on_complete = function (arg_90_0, arg_90_1, arg_90_2, arg_90_3)
				-- function 90
				return
			end
		}
	},
	hide_instant = {
		{
			name = "hide_instant",
			start_progress = 0,
			end_progress = 0,
			init = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3)
				-- function 91
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
			update = function (arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4)
				-- function 92
				return
			end,
			on_complete = function (arg_93_0, arg_93_1, arg_93_2, arg_93_3)
				-- function 93
				return
			end
		}
	}
}
local tbl_13 = {
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
		tbl_4[1] + num,
		tbl_4[2]
	},
	icon_scale = num_2,
	create_item_definition_func = fn_2,
	widgets = tbl_10,
	lock_widgets = tbl_11,
	bottom_widgets = tbl_8,
	background_widgets = tbl_7,
	viewport_widgets = tbl_9,
	scenegraph_definition = tbl_5,
	animation_definitions = tbl_12,
	generic_input_actions = tbl_13,
	create_simple_item = fn,
	create_claim_button = fn_4
}
