-- chunkname: @scripts/ui/views/deus_menu/deus_cursed_chest_view_definitions.lua

local game_start_windows = UISettings.game_start_windows
local tbl = {
	400,
	600
}
local spacing = game_start_windows.spacing
local large_window_frame = game_start_windows.large_window_frame
local var_0_4 = UIFrameSettings[large_window_frame].texture_sizes.vertical[1]
local tbl_2 = {
	tbl[1] * 3 + spacing * 2 + var_0_4 * 2,
	tbl[2] + 80
}
local tbl_3 = {
	tbl_2[1] + 50,
	tbl_2[2]
}
local str = "menu_frame_11"
local var_0_8 = UIFrameSettings[str].texture_sizes.vertical[1]
local tbl_4 = {
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
	screen_center = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
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
	window = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = tbl_3,
		position = {
			0,
			0,
			1
		}
	},
	window_overlay = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "center",
		size = tbl_3,
		position = {
			0,
			0,
			5
		}
	},
	window_frame = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = tbl_3,
		position = {
			0,
			0,
			30
		}
	},
	console_cursor = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			100
		}
	},
	bottom_glow = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_3[1] - var_0_8 * 2,
			1000
		},
		position = {
			0,
			var_0_8,
			3
		}
	},
	bottom_glow_short = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_3[1] - var_0_8 * 2,
			500
		},
		position = {
			0,
			var_0_8,
			4
		}
	},
	bottom_glow_shortest = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			tbl_3[1] - var_0_8 * 2,
			200
		},
		position = {
			0,
			var_0_8,
			5
		}
	},
	background_wheel_01 = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = {
			188,
			188
		},
		position = {
			-100,
			0,
			6
		}
	},
	background_wheel_02 = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = {
			461,
			461
		},
		position = {
			-100,
			0,
			6
		}
	},
	background_wheel_03 = {
		vertical_alignment = "center",
		parent = "screen_center",
		horizontal_alignment = "center",
		size = {
			1074,
			1074
		},
		position = {
			-100,
			0,
			6
		}
	},
	exit_button = {
		vertical_alignment = "bottom",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			380,
			42
		},
		position = {
			0,
			-16,
			10
		}
	},
	title = {
		vertical_alignment = "top",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			658,
			60
		},
		position = {
			0,
			34,
			20
		}
	},
	title_bg = {
		vertical_alignment = "top",
		parent = "title",
		horizontal_alignment = "center",
		size = {
			410,
			40
		},
		position = {
			0,
			-15,
			-1
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "title",
		horizontal_alignment = "center",
		size = {
			350,
			50
		},
		position = {
			0,
			-3,
			1
		}
	},
	top_corner_left = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			15
		}
	},
	bottom_corner_left = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			110,
			110
		},
		position = {
			0,
			0,
			15
		}
	},
	options_background_mask = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			1000,
			tbl_3[2]
		},
		position = {
			0,
			0,
			6
		}
	},
	options_background = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			1000,
			900
		},
		position = {
			0,
			0,
			6
		}
	},
	options_window_edge = {
		vertical_alignment = "center",
		parent = "options_background",
		horizontal_alignment = "right",
		size = {
			0,
			900
		},
		position = {
			0,
			0,
			6
		}
	},
	options_background_edge = {
		vertical_alignment = "center",
		parent = "options_window_edge",
		horizontal_alignment = "right",
		size = {
			126,
			tbl_3[2] - 20
		},
		position = {
			-493,
			0,
			1
		}
	},
	power_up_root = {
		vertical_alignment = "center",
		parent = "options_background",
		horizontal_alignment = "center",
		size = {
			484,
			194
		},
		position = {
			160,
			0,
			7
		}
	},
	chest_name_text = {
		vertical_alignment = "center",
		parent = "window_frame",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			-300,
			0,
			1
		}
	},
	chest_lore_text = {
		vertical_alignment = "center",
		parent = "chest_name_text",
		horizontal_alignment = "center",
		size = {
			500,
			70
		},
		position = {
			0,
			-50,
			1
		}
	}
}
local tbl_5 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 28,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_6 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 46,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_7 = {
	use_shadow = true,
	upper_case = true,
	localize = false,
	font_size = 20,
	horizontal_alignment = "center",
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

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local tbl = {
		255,
		255,
		255,
		255
	}
	local tbl_2 = {
		vertical_alignment = "center",
		horizontal_alignment = "left",
		masked = arg_1_2,
		color = {
			255,
			138,
			172,
			235
		},
		offset = {
			7,
			0,
			6
		},
		texture_size = {
			66,
			66
		}
	}
	local clone = table.clone(tbl_2)

	clone.color = {
		255,
		80,
		80,
		80
	}

	local tbl_3 = {
		font_size = 20,
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		}
	}
	local flag

	flag = not arg_1_2 and "hell_shark_masked" and "hell_shark"
	tbl_3.font_type = flag
	tbl_3.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_3.offset = {
		100,
		arg_1_1[2] - 70,
		3
	}
	tbl_3.size = {
		arg_1_1[1] - 270,
		30
	}

	local clone_2 = table.clone(tbl_3)

	clone_2.text_color = {
		255,
		100,
		100,
		100
	}

	local clone_3 = table.clone(tbl_3)

	clone_3.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_3.offset = {
		tbl_3.offset[1] + 2,
		tbl_3.offset[2] - 2,
		tbl_3.offset[3] - 1
	}

	local tbl_4 = {
		font_size = 20,
		word_wrap = true,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		}
	}
	local flag_2

	flag_2 = not arg_1_2 and "hell_shark_masked" and "hell_shark"
	tbl_4.font_type = flag_2
	tbl_4.text_color = Colors.get_color_table_with_alpha("font_title", 255)
	tbl_4.offset = {
		330,
		arg_1_1[2] - 70,
		3
	}
	tbl_4.size = {
		100,
		30
	}

	local clone_4 = table.clone(tbl_4)

	clone_4.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_4.offset = {
		tbl_4.offset[1] + 2,
		tbl_4.offset[2] - 2,
		tbl_4.offset[3] - 1
	}

	local tbl_5 = {
		font_size = 18,
		word_wrap = true,
		dynamic_font_size_word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "top",
		color = {
			150,
			0,
			255,
			0
		}
	}
	local flag_3

	flag_3 = not arg_1_2 and "hell_shark_masked" and "hell_shark"
	tbl_5.font_type = flag_3
	tbl_5.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_5.offset = {
		100,
		arg_1_1[2] - 167,
		3
	}
	tbl_5.size = {
		arg_1_1[1] - 155,
		100
	}

	local clone_5 = table.clone(tbl_5)

	clone_5.text_color = {
		255,
		80,
		80,
		80
	}

	local clone_6 = table.clone(tbl_5)

	clone_6.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_6.offset = {
		tbl_5.offset[1] + 2,
		tbl_5.offset[2] - 2,
		tbl_5.offset[3] - 1
	}

	local tbl_6 = {
		font_size = 22,
		word_wrap = true,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		}
	}
	local flag_4

	flag_4 = not arg_1_2 and "hell_shark_masked" and "hell_shark"
	tbl_6.font_type = flag_4
	tbl_6.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_6.offset = {
		-60,
		70,
		3
	}
	tbl_6.default_offset = {
		-60,
		70,
		3
	}
	tbl_6.size = {
		55,
		20
	}
	tbl_6.color_override = {}
	tbl_6.color_override_table = {
		start_index = 0,
		end_index = 0,
		color = {
			255,
			121,
			193,
			229
		}
	}

	local clone_7 = table.clone(tbl_6)

	clone_7.text_color = Colors.get_color_table_with_alpha("red", 255)

	local clone_8 = table.clone(tbl_6)

	clone_8.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_8.offset = {
		tbl_6.offset[1] + 2,
		tbl_6.offset[2] - 2,
		tbl_6.offset[3] - 1
	}

	local tbl_7 = {
		font_size = 18,
		word_wrap = true,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		}
	}
	local flag_5

	flag_5 = not arg_1_2 and "hell_shark_masked" and "hell_shark"
	tbl_7.font_type = flag_5
	tbl_7.text_color = {
		255,
		150,
		150,
		150
	}
	tbl_7.offset = {
		-155,
		40,
		3
	}
	tbl_7.size = {
		80,
		20
	}

	local clone_9 = table.clone(tbl_7)

	clone_9.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_9.offset = {
		tbl_7.offset[1] + 2,
		tbl_7.offset[2] - 2,
		tbl_7.offset[3] - 1
	}

	local tbl_8 = {
		font_size = 18,
		word_wrap = true,
		horizontal_alignment = "right",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		}
	}
	local flag_6

	flag_6 = not arg_1_2 and "hell_shark_masked" and "hell_shark"
	tbl_8.font_type = flag_6
	tbl_8.text_color = Colors.get_color_table_with_alpha("white", 255)
	tbl_8.offset = {
		-60,
		40,
		3
	}
	tbl_8.size = {
		30,
		20
	}

	local clone_10 = table.clone(tbl_8)

	clone_10.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_10.offset = {
		tbl_8.offset[1] + 2,
		tbl_8.offset[2] - 2,
		tbl_8.offset[3] - 1
	}

	local clone_11 = table.clone(tbl_7)

	clone_11.offset[2] = 15

	local clone_12 = table.clone(clone_11)

	clone_12.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_12.offset = {
		clone_11.offset[1] + 2,
		clone_11.offset[2] - 2,
		clone_11.offset[3] - 1
	}

	local clone_13 = table.clone(tbl_8)

	clone_13.offset[2] = 15
	clone_13.text_color = Colors.get_color_table_with_alpha("font_title", 255)

	local clone_14 = table.clone(clone_13)

	clone_14.text_color = Colors.get_color_table_with_alpha("black", 255)
	clone_14.offset = {
		clone_13.offset[1] + 2,
		clone_13.offset[2] - 2,
		clone_13.offset[3] - 1
	}

	local tbl_9 = {
		{
			pass_type = "hotspot",
			content_id = "button_hotspot"
		},
		{
			style_id = "background",
			pass_type = "texture_uv",
			content_id = "background"
		},
		{
			style_id = "frame",
			pass_type = "texture_uv",
			content_id = "frame"
		},
		{
			pass_type = "texture",
			style_id = "icon_bought_frame",
			texture_id = "icon_bought_frame"
		},
		{
			pass_type = "texture",
			style_id = "icon_discount_frame",
			texture_id = "icon_discount_frame",
			content_check_function = function (self)
				-- function 2
				return self.has_discount
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_hover_frame",
			texture_id = "icon_hover_frame"
		},
		{
			pass_type = "texture",
			style_id = "icon_background",
			texture_id = "icon_background"
		},
		{
			pass_type = "texture",
			style_id = "icon",
			texture_id = "icon",
			content_check_function = function (self)
				-- function 3
				local is_bought = self.is_bought

				is_bought = is_bought or not self.button_hotspot.disable_button

				return is_bought
			end
		},
		{
			pass_type = "texture",
			style_id = "icon_disabled",
			texture_id = "icon",
			content_check_function = function (self)
				-- function 4
				local disable_button = self.button_hotspot.disable_button

				disable_button = not disable_button and not self.is_bought

				return disable_button
			end
		},
		{
			style_id = "sub_text_disabled",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function (self)
				-- function 5
				local disable_button = self.button_hotspot.disable_button

				disable_button = not disable_button and not self.is_bought

				return disable_button
			end
		},
		{
			style_id = "sub_text",
			pass_type = "text",
			text_id = "sub_text",
			content_check_function = function (self)
				-- function 6
				local is_bought = self.is_bought

				is_bought = is_bought or not self.button_hotspot.disable_button

				return is_bought
			end
		},
		{
			style_id = "sub_text_shadow",
			pass_type = "text",
			text_id = "sub_text"
		},
		{
			style_id = "title_text_disabled",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (self)
				-- function 7
				local disable_button = self.button_hotspot.disable_button

				disable_button = not disable_button and not self.is_bought

				return disable_button
			end
		},
		{
			style_id = "title_text",
			pass_type = "text",
			text_id = "title_text",
			content_check_function = function (self)
				-- function 8
				local is_bought = self.is_bought

				is_bought = is_bought or not self.button_hotspot.disable_button

				return is_bought
			end
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
			style_id = "price_text",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (self)
				-- function 9
				return not not self.button_hotspot.disable_button or not self.is_bought
			end
		},
		{
			style_id = "price_text_disabled",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (self)
				-- function 10
				local disable_button = self.button_hotspot.disable_button

				disable_button = not disable_button and not self.is_bought

				return disable_button
			end
		},
		{
			style_id = "price_text_shadow",
			pass_type = "text",
			text_id = "price_text",
			content_check_function = function (self)
				-- function 11
				return not self.is_bought
			end
		},
		{
			pass_type = "texture",
			style_id = "price_icon",
			texture_id = "price_icon",
			content_check_function = function (self)
				-- function 12
				return not self.is_bought
			end
		},
		{
			style_id = "current_value_title_text",
			pass_type = "text",
			text_id = "current_value_title_text",
			content_check_function = function (self)
				-- function 13
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "current_value_title_text_shadow",
			pass_type = "text",
			text_id = "current_value_title_text",
			content_check_function = function (self)
				-- function 14
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "current_value_text",
			pass_type = "text",
			text_id = "current_value_text",
			content_check_function = function (self)
				-- function 15
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "current_value_text_shadow",
			pass_type = "text",
			text_id = "current_value_text",
			content_check_function = function (self)
				-- function 16
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "max_value_title_text",
			pass_type = "text",
			text_id = "max_value_title_text",
			content_check_function = function (self)
				-- function 17
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "max_value_title_text_shadow",
			pass_type = "text",
			text_id = "max_value_title_text",
			content_check_function = function (self)
				-- function 18
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "max_value_text",
			pass_type = "text",
			text_id = "max_value_text",
			content_check_function = function (self)
				-- function 19
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "max_value_text_shadow",
			pass_type = "text",
			text_id = "max_value_text",
			content_check_function = function (self)
				-- function 20
				local current_value_text

				if not self.is_bought then
					current_value_text = self.current_value_text

					if not current_value_text then
						current_value_text = self.max_value_text
					end
				else
					current_value_text = false
				end

				if false then
					current_value_text = true
				end

				return current_value_text
			end
		},
		{
			style_id = "unlocked_text",
			pass_type = "text",
			text_id = "unlocked_text",
			content_check_function = function (self)
				-- function 21
				return self.is_bought
			end
		},
		{
			style_id = "hover",
			pass_type = "texture_uv",
			content_id = "hover"
		},
		{
			style_id = "set_progression",
			pass_type = "text",
			text_id = "set_progression",
			content_check_function = function (self)
				-- function 22
				return self.is_part_of_set
			end
		}
	}
	local tbl_10 = {
		title_text = "",
		icon_background = "button_frame_01",
		is_bought = false,
		price_icon = "deus_icons_coin",
		price_text = "0",
		icon_bought_frame = "frame_outer_glow_04_big",
		is_part_of_set = false,
		icon = "icon_property_attack_speed",
		max_value_text = "20%",
		current_value_text = "10%",
		has_discount = false,
		sub_text = "",
		rarity_text = "",
		icon_discount_frame = "button_detail_discount_01",
		icon_hover_frame = "frame_outer_glow_04",
		button_hotspot = {},
		background = {
			texture_id = "shrine_blessing_bg",
			uvs = {
				{
					1,
					0
				},
				{
					0,
					1
				}
			}
		},
		hover = {
			texture_id = "shrine_blessing_bg_hover",
			uvs = {
				{
					1,
					0
				},
				{
					0,
					1
				}
			}
		},
		frame = {
			texture_id = "shrine_blessing_frame",
			uvs = {
				{
					1,
					0
				},
				{
					0,
					1
				}
			}
		},
		size = arg_1_1,
		current_value_title_text = Localize("deus_shrine_current_value"),
		max_value_title_text = Localize("deus_shrine_max_value"),
		unlocked_text = Localize("deus_shrine_unlocked"),
		bought_glow_style_ids = {
			"icon_bought_frame"
		}
	}
	local tbl_11 = {
		debug = {
			masked = arg_1_2,
			color = {
				255,
				255,
				0,
				0
			},
			offset = {
				-1,
				-1,
				8
			},
			size = {
				3,
				3
			}
		},
		icon_bought_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-39,
				0,
				2
			},
			texture_size = {
				158,
				158
			}
		},
		icon_discount_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_1_2,
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
			texture_size = {
				80,
				80
			}
		},
		icon_hover_frame = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-24,
				0,
				3
			},
			texture_size = {
				128,
				128
			}
		},
		icon_background = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			texture_size = {
				80,
				80
			},
			offset = {
				0,
				0,
				3
			}
		},
		icon = tbl_2,
		icon_disabled = clone,
		icon_bg = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			masked = arg_1_2,
			color = {
				255,
				0,
				0,
				0
			},
			offset = {
				7,
				0,
				5
			},
			texture_size = {
				66,
				66
			}
		},
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_1_2,
			color = tbl,
			offset = {
				0,
				0,
				0
			},
			texture_size = arg_1_1
		},
		hover = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_1_2,
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				0,
				1
			},
			texture_size = arg_1_1
		},
		frame = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			masked = arg_1_2,
			color = tbl,
			offset = {
				0,
				0,
				2
			},
			texture_size = arg_1_1
		},
		price_icon = {
			masked = arg_1_2,
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				-90,
				68
			},
			size = {
				20,
				20
			}
		},
		price_text = tbl_6,
		price_text_shadow = clone_8,
		price_text_disabled = clone_7,
		title_text_disabled = clone_2,
		title_text = tbl_3,
		title_text_shadow = clone_3,
		rarity_text = tbl_4,
		rarity_text_shadow = clone_4,
		sub_text_disabled = clone_5,
		sub_text = tbl_5,
		sub_text_shadow = clone_6,
		current_value_title_text = tbl_7,
		current_value_title_text_shadow = clone_9,
		current_value_text = tbl_8,
		current_value_text_shadow = clone_10,
		max_value_title_text = clone_11,
		max_value_title_text_shadow = clone_12,
		max_value_text = clone_13,
		max_value_text_shadow = clone_14
	}
	local tbl_12 = {
		font_size = 24,
		upper_case = true,
		word_wrap = true,
		horizontal_alignment = "center",
		vertical_alignment = "center",
		dynamic_font_size = true,
		color = {
			150,
			255,
			0,
			0
		}
	}
	local flag_7

	flag_7 = not arg_1_2 and "hell_shark_masked" and "hell_shark"
	tbl_12.font_type = flag_7
	tbl_12.text_color = Colors.get_color_table_with_alpha("font_default", 255)
	tbl_12.offset = {
		-130,
		40,
		3
	}
	tbl_12.size = {
		120,
		30
	}
	tbl_11.unlocked_text = tbl_12
	tbl_11.set_progression = {
		word_wrap = false,
		upper_case = false,
		font_size = 20,
		horizontal_alignment = "left",
		vertical_alignment = "center",
		font_type = "hell_shark",
		progression_colors = {
			incomplete = Colors.get_color_table_with_alpha("font_default", 255),
			complete = Colors.get_color_table_with_alpha("lime_green", 255)
		},
		text_color = Colors.get_color_table_with_alpha("font_default", 255),
		area_size = {
			250,
			22
		},
		size = {
			250,
			22
		},
		offset = {
			110,
			24,
			10
		}
	}

	return {
		element = {
			passes = tbl_9
		},
		content = tbl_10,
		style = tbl_11,
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_0
	}
end

local tbl_8 = {
	255,
	25,
	21,
	36
}
local tbl_9 = {
	255,
	159,
	154,
	210
}
local tbl_10 = {
	200,
	208,
	149,
	177
}
local tbl_11 = {
	200,
	94,
	67,
	101
}
local tbl_12 = {
	200,
	172,
	101,
	159
}
local tbl_13 = {
	130,
	250,
	212,
	251
}
local flag = true
local tbl_14 = {
	console_cursor = UIWidgets.create_console_cursor("console_cursor"),
	window_frame = UIWidgets.create_frame("window_frame", tbl_4.window.size, "menu_frame_11", 10),
	background_write_mask = UIWidgets.create_simple_texture("shrine_background_write_mask", "window"),
	background_wheel_01 = UIWidgets.create_simple_rotated_texture("shrine_circle_background_01", 0, {
		94,
		94
	}, "background_wheel_01", nil, nil, tbl_9),
	background_wheel_02 = UIWidgets.create_simple_rotated_texture("shrine_circle_background_02", 0, {
		230.5,
		230.5
	}, "background_wheel_02", nil, nil, tbl_9),
	background_wheel_03 = UIWidgets.create_simple_rotated_texture("shrine_circle_background_03", 0, {
		537,
		537
	}, "background_wheel_03", nil, nil, tbl_9),
	bottom_glow_smoke_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, tbl_10),
	bottom_glow_smoke_2 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_smoke_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, tbl_11),
	bottom_glow_smoke_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_2", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_shortest", nil, nil, tbl_12),
	bottom_glow_embers_1 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_1", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow", nil, nil, tbl_13, 1),
	bottom_glow_embers_3 = UIWidgets.create_simple_uv_texture("forge_overview_bottom_glow_effect_embers_3", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_glow_short", nil, nil, tbl_13, 1),
	window_background = UIWidgets.create_simple_rect("window", tbl_8),
	top_corner_left = UIWidgets.create_simple_texture("athanor_decoration_corner", "top_corner_left"),
	bottom_corner_left = UIWidgets.create_simple_uv_texture("athanor_decoration_corner", {
		{
			0,
			1
		},
		{
			1,
			0
		}
	}, "bottom_corner_left"),
	options_background_edge = UIWidgets.create_simple_texture("shrine_sidebar_background", "options_background_edge"),
	options_background = UIWidgets.create_tiled_texture("options_background", "menu_frame_bg_01", {
		960,
		1080
	}, nil, true, {
		255,
		120,
		120,
		120
	}),
	options_background_mask = UIWidgets.create_simple_uv_texture("shrine_sidebar_write_mask", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "options_background_mask"),
	exit_button = UIWidgets.create_default_button("exit_button", tbl_4.exit_button.size, nil, nil, Localize("menu_close"), 24, nil, "button_detail_04", 34, flag),
	title = UIWidgets.create_simple_texture("frame_title_bg", "title"),
	title_bg = UIWidgets.create_background("title_bg", tbl_4.title_bg.size, "menu_frame_bg_02"),
	title_text = UIWidgets.create_simple_text(Localize("deus_cursed_chest_title"), "title_text", nil, nil, tbl_5),
	chest_name_text = UIWidgets.create_simple_text(Localize("deus_cursed_chest_title"), "chest_name_text", nil, nil, tbl_6),
	chest_lore_text = UIWidgets.create_simple_text(Localize("deus_cursed_chest_lore"), "chest_lore_text", nil, nil, tbl_7)
}

return {
	scenegraph_definition = tbl_4,
	background_widgets = tbl_14,
	create_power_up_shop_item = fn
}
