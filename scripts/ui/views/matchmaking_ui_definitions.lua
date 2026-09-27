-- chunkname: @scripts/ui/views/matchmaking_ui_definitions.lua

local tbl = {
	screen = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.matchmaking - 10
		}
	},
	window_root = {
		vertical_alignment = "top",
		parent = "screen",
		horizontal_alignment = "right",
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
	window = {
		vertical_alignment = "top",
		parent = "window_root",
		horizontal_alignment = "right",
		size = {
			506,
			136
		},
		position = {
			0,
			0,
			5
		}
	},
	loading_icon = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "right",
		size = {
			141,
			141
		},
		position = {
			15,
			15,
			1
		}
	},
	loading_status_frame = {
		vertical_alignment = "center",
		parent = "loading_icon",
		horizontal_alignment = "center",
		size = {
			141,
			141
		},
		position = {
			0,
			0,
			1
		}
	},
	status_text = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "left",
		size = {
			360,
			35
		},
		position = {
			43,
			-28,
			1
		}
	},
	window_party = {
		vertical_alignment = "bottom",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			0,
			-80,
			1
		}
	},
	detailed_info_box = {
		vertical_alignment = "top",
		parent = "window_root",
		horizontal_alignment = "right",
		size = {
			400,
			150
		},
		position = {
			0,
			-60,
			0
		}
	},
	level_key_info_box = {
		vertical_alignment = "top",
		parent = "detailed_info_box",
		horizontal_alignment = "left",
		size = {
			270,
			150
		},
		position = {
			0,
			0,
			0
		}
	},
	party_slot_root = {
		vertical_alignment = "top",
		parent = "detailed_info_box",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-50,
			1
		}
	},
	party_slot_1 = {
		vertical_alignment = "center",
		parent = "party_slot_root",
		horizontal_alignment = "center",
		size = {
			60,
			70
		},
		position = {
			-135,
			-52,
			1
		}
	},
	party_slot_2 = {
		vertical_alignment = "center",
		parent = "party_slot_root",
		horizontal_alignment = "center",
		size = {
			60,
			70
		},
		position = {
			-45,
			-52,
			1
		}
	},
	party_slot_3 = {
		vertical_alignment = "center",
		parent = "party_slot_root",
		horizontal_alignment = "center",
		size = {
			60,
			70
		},
		position = {
			45,
			-52,
			1
		}
	},
	party_slot_4 = {
		vertical_alignment = "center",
		parent = "party_slot_root",
		horizontal_alignment = "center",
		size = {
			60,
			70
		},
		position = {
			135,
			-52,
			1
		}
	},
	slot_reservations = {
		vertical_alignment = "center",
		parent = "detailed_info_box",
		horizontal_alignment = "center",
		size = {
			556,
			160
		},
		position = {
			0,
			-30,
			1
		}
	},
	timer_bg = {
		vertical_alignment = "top",
		parent = "detailed_info_box",
		horizontal_alignment = "center",
		size = {
			400,
			16
		},
		position = {
			0,
			-140,
			3
		}
	},
	timer_fg = {
		vertical_alignment = "center",
		parent = "timer_bg",
		horizontal_alignment = "left",
		size = {
			392,
			16
		},
		position = {
			4,
			0,
			3
		}
	},
	timer_glow = {
		vertical_alignment = "center",
		parent = "timer_fg",
		horizontal_alignment = "right",
		size = {
			45,
			80
		},
		position = {
			22,
			0,
			3
		}
	},
	cancel_text_field = {
		vertical_alignment = "bottom",
		parent = "detailed_info_box",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			0,
			-50,
			3
		}
	},
	cancel_input_backround = {
		vertical_alignment = "center",
		parent = "cancel_text_field",
		horizontal_alignment = "center",
		size = {
			411,
			61
		},
		position = {
			0,
			0,
			1
		}
	},
	cancel_text_input = {
		vertical_alignment = "center",
		parent = "cancel_text_field",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			200,
			0,
			2
		}
	},
	cancel_text_prefix = {
		vertical_alignment = "center",
		parent = "cancel_text_field",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			200,
			0,
			2
		}
	},
	cancel_text_suffix = {
		vertical_alignment = "center",
		parent = "cancel_text_field",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			200,
			0,
			2
		}
	},
	cancel_icon = {
		vertical_alignment = "center",
		parent = "cancel_text_field",
		horizontal_alignment = "center",
		size = {
			36,
			26
		},
		position = {
			0,
			0,
			2
		}
	},
	versus_cancel_text_input = {
		vertical_alignment = "center",
		parent = "cancel_text_field",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			100,
			0,
			2
		}
	},
	versus_cancel_text_prefix = {
		vertical_alignment = "center",
		parent = "cancel_text_field",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			100,
			0,
			2
		}
	},
	versus_cancel_text_suffix = {
		vertical_alignment = "center",
		parent = "cancel_text_field",
		horizontal_alignment = "center",
		size = {
			400,
			50
		},
		position = {
			100,
			0,
			2
		}
	},
	versus_cancel_icon = {
		vertical_alignment = "center",
		parent = "cancel_text_field",
		horizontal_alignment = "center",
		size = {
			36,
			26
		},
		position = {
			-100,
			0,
			2
		}
	}
}
local num = 5
local tbl_2 = {
	255,
	10,
	10,
	10
}
local tbl_3 = {
	font_size = 22,
	upper_case = true,
	word_wrap = true,
	use_shadow = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local clone = table.clone(tbl_3)

clone.vertical_alignment = "top"
clone.horizontal_alignment = "left"
clone.dynamic_font_size = true
clone.offset[2] = -10
clone.offset[1] = 15
clone.text_color = Colors.get_color_table_with_alpha("font_title", 255)

local clone_2 = table.clone(tbl_3)

clone_2.vertical_alignment = "top"
clone_2.horizontal_alignment = "left"
clone_2.font_size = 16
clone_2.offset[1] = 15
clone_2.offset[2] = -35

local clone_3 = table.clone(clone_2)

clone_3.default_color = {
	255,
	200,
	200,
	200
}

local clone_4 = table.clone(tbl_3)

clone_4.vertical_alignment = "center"
clone_4.horizontal_alignment = "center"
clone_4.font_size = 26
clone_4.dynamic_font_size = true
clone_4.word_wrap = false
clone_4.offset[2] = 2

local clone_5 = table.clone(clone_4)

clone_5.text_color = Colors.get_table("font_title")

local clone_6 = table.clone(tbl_3)

clone_6.vertical_alignment = "center"
clone_6.horizontal_alignment = "left"
clone_6.use_shadow = true
clone_6.font_size = 28
clone_6.dynamic_font_size = true
clone_6.offset[2] = 2
clone_6.text_color = Colors.get_color_table_with_alpha("font_title", 255)

local clone_7 = table.clone(clone_6)

clone_7.text_color = Colors.get_color_table_with_alpha("white", 255)

local clone_8 = table.clone(clone_2)

clone_8.default_color = {
	255,
	200,
	200,
	200
}

local clone_9 = table.clone(clone_4)

clone_9.text_color = Colors.get_table("font_title")

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local num = 0.6
	local num_2 = 0.7
	local num_3 = 4
	local tbl = {}

	for i = 1, num_3 do
		tbl[i] = {
			255,
			255,
			255,
			255
		}
	end

	local tbl_2 = {
		element = {}
	}
	local tbl_3 = {
		{
			style_id = "orb",
			pass_type = "texture_uv",
			content_id = "orb",
			content_change_function = function (self, arg_2_1, arg_2_2, arg_2_3)
				-- function 2
				local parent = self.parent
				local size = parent.size
				local progress = parent.progress
				local default_size = arg_2_1.default_size
				local texture_size = arg_2_1.texture_size
				local offset = arg_2_1.offset
				local speed = parent.speed
				local num = (size[1] + default_size[1]) / size[1]
				local var_2_8 = size[1]

				parent.progress = (progress + arg_2_3 * speed) % num

				local num_2 = default_size[1] / size[1]
				local min = math.min(progress / num_2, 1)
				local min_2 = math.min((num - progress) / num_2, 1)
				local num_3 = num - num_2
				local min_3 = math.min((num - progress) / num_2, 1)
				local uvs = self.uvs

				uvs[1][1] = 1 - min
				uvs[2][1] = min_2
				texture_size[1] = math.floor(default_size[1] * math.min(min, min_2))
				offset[1] = math.floor(-texture_size[1] + var_2_8 * progress - (1 - min_2) * default_size[1])
			end
		},
		{
			style_id = "timeline",
			pass_type = "rect",
			content_change_function = function (self, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				local size = self.size
				local progress = self.progress
				local offset = arg_3_1.offset
				local color = arg_3_1.color
				local speed = self.speed

				offset[1] = -40 + size[1] * progress
			end
		},
		{
			style_id = "trail",
			texture_id = "trail",
			pass_type = "texture",
			content_change_function = function (self, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				local size = self.size
				local progress = self.progress
				local texture_size = arg_4_1.texture_size
				local offset = arg_4_1.offset
				local default_size = arg_4_1.parent.orb.default_size
				local var_4_5 = size[1]

				offset[1] = -(default_size[1] + 20) + var_4_5 * progress
			end
		},
		{
			pass_type = "texture",
			style_id = "background",
			texture_id = "background"
		},
		{
			pass_type = "texture",
			style_id = "globe_bg",
			texture_id = "globe_bg"
		},
		{
			style_id = "globe",
			texture_id = "globe",
			pass_type = "texture",
			content_change_function = function (self, arg_5_1, arg_5_2, arg_5_3)
				-- function 5
				local progress = self.progress
				local min = math.min(progress, 1)

				if min < 0.5 then
					min = math.easeInCubic(2 * min)
				else
					min = math.easeOutCubic(2 - 2 * min)
				end

				local default_color = arg_5_1.default_color
				local color = arg_5_1.color
				local num = 5
				local num_2 = 0.5 + math.sin(Managers.time:time("ui") * num) * 0.5
				local max = math.max(min, num_2)
				local num_3 = 0.2

				color[2] = math.min(default_color[2] + default_color[2] * num_3 * num_2, 255)
				color[3] = math.min(default_color[3] + default_color[3] * num_3 * num_2, 255)
				color[4] = math.min(default_color[4] + default_color[4] * num_3 * num_2, 255)
			end
		},
		{
			pass_type = "tiled_texture",
			style_id = "pattern",
			texture_id = "pattern"
		},
		{
			pass_type = "tiled_texture",
			style_id = "spark_pattern",
			texture_id = "spark_pattern_1"
		},
		{
			pass_type = "tiled_texture",
			style_id = "spark_pattern",
			texture_id = "spark_pattern_2"
		}
	}
	local tbl_4 = {
		pattern = "versus_loading_trail_lines_bg_masked",
		globe_bg = "versus_loading_trail_bg_back",
		globe = "versus_loading_trail_center_effect",
		progress = 0,
		spark_pattern_2 = "versus_loading_trail_stars_bg_masked_2",
		spark_texture_1 = "versus_loading_trail_stars_write_mask_1",
		spark_pattern_1 = "versus_loading_trail_stars_bg_masked_1",
		background = "versus_loading_trail_bg_front_quickplay",
		timeline = "timer_detail",
		spark_texture_2 = "versus_loading_trail_stars_write_mask_2",
		trail = "versus_loading_trail_lines_write_mask",
		size = arg_1_1,
		orb = {
			texture_id = "versus_loading_trail_dot",
			uvs = {
				{
					0,
					0
				},
				{
					1,
					1
				}
			}
		},
		speed = num
	}
	local tbl_5 = {
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				556 * num_2,
				108 * num_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				15,
				2
			}
		},
		globe_bg = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				68 * num_2,
				68 * num_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				15,
				0
			}
		},
		globe = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				68 * num_2,
				68 * num_2
			},
			color = {
				255,
				230,
				80,
				26
			},
			default_color = {
				255,
				200,
				50,
				16
			},
			offset = {
				0,
				15,
				1
			}
		},
		orb = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			texture_size = {
				482 * num_2,
				62 * num_2
			},
			default_size = {
				482 * num_2,
				62 * num_2
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				9,
				3
			}
		},
		trail = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			texture_size = {
				416 * num_2,
				arg_1_1[2] * num_2
			},
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				9,
				4
			}
		},
		timeline = {
			vertical_alignment = "center",
			horizontal_alignment = "left",
			texture_size = {
				2 * num_2,
				arg_1_1[2] * num_2
			},
			color = {
				0,
				255,
				0,
				0
			},
			offset = {
				0,
				9,
				5
			}
		},
		pattern = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				556 * num_2,
				160 * num_2
			},
			offset = {
				0,
				9,
				4
			},
			texture_tiling_size = {
				arg_1_1[1] * num_2,
				arg_1_1[2] * num_2
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		spark_pattern = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				556 * num_2,
				160 * num_2
			},
			offset = {
				0,
				9,
				4
			},
			texture_tiling_size = {
				arg_1_1[1] * num_2,
				arg_1_1[2] * num_2
			},
			color = {
				255,
				255,
				255,
				255
			}
		}
	}

	tbl_2.element.passes = tbl_3
	tbl_2.content = tbl_4
	tbl_2.style = tbl_5
	tbl_2.offset = {
		0,
		0,
		0
	}
	tbl_2.scenegraph_id = arg_1_0

	return tbl_2
end

local function fn_2(arg_6_0, arg_6_1)
	-- function 6
	local tbl = {
		scenegraph_id = "window",
		element = {
			passes = {
				{
					style_id = "texture_id",
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function (self)
						-- function 7
						local is_connecting = self.is_connecting

						is_connecting = is_connecting or self.is_connected

						return is_connecting
					end,
					content_change_function = function (self, arg_8_1, arg_8_2, arg_8_3)
						-- function 8
						local color = arg_8_1.color

						if not self.is_connecting then
							local color_progress = self.color_progress

							color_progress = color_progress or 1

							local num = (color_progress + arg_8_3) % 1

							self.color_progress = num
							color[1] = 255 * math.ease_pulse(num)
						elseif not self.is_connected then
							color[1] = 255
						end
					end
				}
			}
		},
		content = {
			is_connected = false,
			is_connecting = false,
			texture_id = arg_6_0
		}
	}
	local tbl_2 = {}
	local tbl_3 = {
		vertical_alignment = "botom",
		horizontal_alignment = "right",
		texture_size = {
			30,
			30
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	local tbl_4 = {}
	local var_6_4 = arg_6_1[1]

	var_6_4 = var_6_4 or 0
	tbl_4[1] = var_6_4

	local var_6_5 = arg_6_1[2]

	var_6_5 = var_6_5 or 0
	tbl_4[2] = var_6_5

	local var_6_6 = arg_6_1[3]

	var_6_6 = var_6_6 or 0
	tbl_4[3] = var_6_6
	tbl_3.offset = tbl_4
	tbl_2.texture_id = tbl_3
	tbl.style = tbl_2

	return tbl
end

local tbl_4 = {
	window = UIWidgets.create_simple_uv_texture("matchmaking_window", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "window", nil, nil, nil, nil, nil, {
		506,
		136
	}),
	loading_icon = UIWidgets.create_simple_texture("matchmaking_icon", "loading_icon"),
	loading_status_frame = UIWidgets.create_simple_rotated_texture("matchmaking_icon_effect", 0, {
		71,
		71
	}, "loading_status_frame"),
	window_hotspot = UIWidgets.create_simple_hotspot("window"),
	status_text = UIWidgets.create_simple_text("n/a", "status_text", nil, nil, clone_4),
	player_status_1 = fn_2("matchmaking_light_02", {
		-89,
		43,
		1
	}),
	player_status_2 = fn_2("matchmaking_light_02", {
		-71,
		22,
		1
	}),
	player_status_3 = fn_2("matchmaking_light_02", {
		-45,
		12,
		1
	}),
	player_status_4 = fn_2("matchmaking_light_02", {
		-18,
		15,
		1
	})
}
local tbl_5 = {
	detailed_info_box_frame = UIWidgets.create_frame("detailed_info_box", tbl.detailed_info_box.size, "menu_frame_09", 1),
	detailed_info_box = UIWidgets.create_background("detailed_info_box", tbl.detailed_info_box.size, "matchmaking_window_01"),
	title_text = UIWidgets.create_simple_text("n/a", "level_key_info_box", nil, nil, clone),
	difficulty_text = UIWidgets.create_simple_text("n/a", "detailed_info_box", nil, nil, clone_2),
	party_slot_1 = UIWidgets.create_matchmaking_portrait(tbl.party_slot_1.size, "party_slot_1"),
	party_slot_2 = UIWidgets.create_matchmaking_portrait(tbl.party_slot_2.size, "party_slot_2"),
	party_slot_3 = UIWidgets.create_matchmaking_portrait(tbl.party_slot_3.size, "party_slot_3"),
	party_slot_4 = UIWidgets.create_matchmaking_portrait(tbl.party_slot_4.size, "party_slot_4"),
	timer_bg = UIWidgets.create_simple_texture("timer_bg", "timer_bg"),
	timer_fg = UIWidgets.create_simple_uv_texture("timer_fg", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "timer_fg"),
	timer_glow = UIWidgets.create_simple_texture("timer_detail", "timer_glow")
}
local tbl_6 = {
	window = UIWidgets.create_simple_uv_texture("matchmaking_top", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "window", nil, nil, nil, {
		-1,
		15,
		0
	}, nil, "native"),
	loading_icon = UIWidgets.create_simple_texture("matchmaking_icon_morris", "loading_icon", false, false, nil, {
		0,
		3,
		0
	}),
	loading_status_frame = UIWidgets.create_simple_rotated_texture("matchmaking_icon_effect_morris", 0, {
		71,
		71
	}, "loading_status_frame", false, false, nil, nil, {
		0,
		3,
		0
	}),
	window_hotspot = UIWidgets.create_simple_hotspot("window"),
	status_text = UIWidgets.create_simple_text("n/a", "status_text", nil, nil, clone_5),
	player_status_1 = fn_2("matchmaking_light_02", {
		-87,
		46
	}),
	player_status_2 = fn_2("matchmaking_light_02", {
		-70,
		25
	}),
	player_status_3 = fn_2("matchmaking_light_02", {
		-44,
		15
	}),
	player_status_4 = fn_2("matchmaking_light_02", {
		-17,
		19
	})
}
local tbl_7 = {
	detailed_info_box = UIWidgets.create_simple_texture("matchmaking_animated_panel", "detailed_info_box", false, false, nil, {
		-5,
		-7,
		0
	}, "native"),
	title_text = UIWidgets.create_simple_text("n/a", "level_key_info_box", nil, nil, clone),
	difficulty_text = UIWidgets.create_simple_text("n/a", "detailed_info_box", nil, nil, clone_3),
	party_slot_1 = UIWidgets.create_matchmaking_portrait(tbl.party_slot_1.size, "party_slot_1"),
	party_slot_2 = UIWidgets.create_matchmaking_portrait(tbl.party_slot_2.size, "party_slot_2"),
	party_slot_3 = UIWidgets.create_matchmaking_portrait(tbl.party_slot_3.size, "party_slot_3"),
	party_slot_4 = UIWidgets.create_matchmaking_portrait(tbl.party_slot_4.size, "party_slot_4"),
	timer_bg = UIWidgets.create_simple_texture("matchmaking_progressbar_border", "timer_bg", false, false, nil, {
		5,
		-15,
		0
	}, "native"),
	timer_fg = UIWidgets.create_simple_uv_texture("timer_fg", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "timer_fg", false, false, nil, {
		19,
		-1,
		2
	}),
	timer_glow = UIWidgets.create_simple_texture("timer_detail", "timer_glow", false, false, nil, {
		19,
		-1,
		2
	})
}

tbl_7.detailed_info_box.content.no_background_changes = true

local tbl_8 = {
	window = UIWidgets.create_simple_uv_texture("matchmaking_top_vs", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "window", nil, nil, nil, {
		-2,
		14,
		0
	}, nil, "native"),
	loading_icon = UIWidgets.create_simple_texture("matchmaking_icon_versus", "loading_icon", false, false, nil, {
		0,
		3,
		3
	}),
	loading_status_frame = UIWidgets.create_simple_rotated_texture("matchmaking_icon_effect_versus", 0, {
		71,
		71
	}, "loading_status_frame", false, false, nil, nil, {
		0,
		3,
		0
	}),
	window_hotspot = UIWidgets.create_simple_hotspot("window"),
	status_text = UIWidgets.create_simple_text("n/a", "status_text", nil, nil, clone_9)
}
local tbl_9 = {
	detailed_info_box = UIWidgets.create_simple_texture("matchmaking_animated_panel", "detailed_info_box", false, false, nil, {
		-5,
		-7,
		0
	}, "native"),
	title_text = UIWidgets.create_simple_text("n/a", "level_key_info_box", nil, nil, clone),
	difficulty_text = UIWidgets.create_simple_text("n/a", "detailed_info_box", nil, nil, clone_8),
	timer_bg = UIWidgets.create_simple_texture("matchmaking_progressbar_border", "timer_bg", false, false, nil, {
		5,
		-15,
		0
	}, "native"),
	timer_fg = UIWidgets.create_simple_uv_texture("timer_fg", {
		{
			0,
			0
		},
		{
			1,
			1
		}
	}, "timer_fg", false, false, nil, {
		19,
		-1,
		2
	}),
	timer_glow = UIWidgets.create_simple_texture("timer_detail", "timer_glow", false, false, nil, {
		19,
		-1,
		2
	}),
	slot_reservations = fn("slot_reservations", tbl.slot_reservations.size)
}

tbl_9.detailed_info_box.content.no_background_changes = true

local tbl_10 = {
	versus_cancel_text_input = UIWidgets.create_simple_text(Localize("matchmaking_suffix_cancel"), "versus_cancel_text_input", nil, nil, clone_6),
	versus_cancel_text_suffix = UIWidgets.create_simple_text(Localize("matchmaking_suffix_cancel"), "versus_cancel_text_suffix", nil, nil, clone_7),
	versus_cancel_text_prefix = UIWidgets.create_simple_text(Localize("matchmaking_suffix_cancel"), "versus_cancel_text_prefix", nil, nil, clone_7),
	versus_cancel_icon = UIWidgets.create_simple_texture("xbone_button_icon_a", "versus_cancel_icon"),
	cancel_input_backround = UIWidgets.create_simple_texture("tab_menu_bg_02", "cancel_input_backround")
}
local tbl_11 = {
	cancel_text_input = UIWidgets.create_simple_text(Localize("matchmaking_suffix_cancel"), "cancel_text_input", nil, nil, clone_6),
	cancel_text_suffix = UIWidgets.create_simple_text(Localize("matchmaking_suffix_cancel"), "cancel_text_suffix", nil, nil, clone_7),
	cancel_text_prefix = UIWidgets.create_simple_text(Localize("matchmaking_suffix_cancel"), "cancel_text_prefix", nil, nil, clone_7),
	cancel_icon = UIWidgets.create_simple_texture("xbone_button_icon_a", "cancel_icon"),
	cancel_input_backround = UIWidgets.create_simple_texture("tab_menu_bg_02", "cancel_input_backround")
}
local tbl_12 = {
	debug_box = {
		scenegraph_id = "debug_box",
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "background_rect"
				},
				{
					style_id = "debug_text",
					pass_type = "text",
					text_id = "debug_text"
				}
			}
		},
		content = {
			debug_text = ""
		},
		style = {
			debug_text = {
				scenegraph_id = "debug_box_text",
				font_size = 28,
				word_wrap = true,
				pixel_perfect = true,
				horizontal_alignment = "left",
				vertical_alignment = "top",
				dynamic_font = true,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255)
			},
			background_rect = {
				color = {
					180,
					0,
					0,
					0
				}
			}
		}
	},
	debug_lobbies = {
		scenegraph_id = "debug_lobbies_box",
		element = {
			passes = {
				{
					pass_type = "rect",
					style_id = "background_rect"
				},
				{
					pass_type = "rect",
					style_id = "debug_divider_0"
				},
				{
					pass_type = "rect",
					style_id = "debug_divider_1"
				},
				{
					style_id = "debug_text",
					pass_type = "text",
					text_id = "debug_text"
				},
				{
					style_id = "debug_match_text",
					pass_type = "text",
					text_id = "debug_match_text"
				},
				{
					style_id = "debug_broken_text",
					pass_type = "text",
					text_id = "debug_broken_text"
				},
				{
					style_id = "debug_valid_text",
					pass_type = "text",
					text_id = "debug_valid_text"
				},
				{
					style_id = "debug_server_text",
					pass_type = "text",
					text_id = "debug_server_text"
				},
				{
					style_id = "debug_level_key_text",
					pass_type = "text",
					text_id = "debug_level_key_text"
				},
				{
					style_id = "debug_selected_level_key_text",
					pass_type = "text",
					text_id = "debug_selected_level_key_text"
				},
				{
					style_id = "debug_matchmaking_text",
					pass_type = "text",
					text_id = "debug_matchmaking_text"
				},
				{
					style_id = "debug_difficulty_text",
					pass_type = "text",
					text_id = "debug_difficulty_text"
				},
				{
					style_id = "debug_num_players_text",
					pass_type = "text",
					text_id = "debug_num_players_text"
				},
				{
					style_id = "debug_rp_text",
					pass_type = "text",
					text_id = "debug_rp_text"
				},
				{
					style_id = "debug_host_text",
					pass_type = "text",
					text_id = "debug_host_text"
				},
				{
					style_id = "debug_lobby_id_text",
					pass_type = "text",
					text_id = "debug_lobby_id_text"
				},
				{
					style_id = "debug_hash_text",
					pass_type = "text",
					text_id = "debug_hash_text"
				}
			}
		},
		content = {
			debug_server_text = "",
			debug_num_players_text = "",
			debug_broken_text = "",
			debug_match_text = "",
			debug_valid_text = "",
			debug_lobby_id_text = "",
			debug_rp_text = "",
			debug_difficulty_text = "",
			debug_host_text = "",
			debug_level_key_text = "",
			debug_matchmaking_text = "",
			debug_hash_text = "",
			debug_text = "Lobbies",
			debug_selected_level_key_text = ""
		},
		style = {
			debug_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_lobbies_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			debug_server_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_server_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			debug_match_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_match_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			debug_broken_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_broken_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			debug_valid_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_valid_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			debug_level_key_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_level_key_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			debug_selected_level_key_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_selected_level_key_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			debug_matchmaking_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_matchmaking_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			debug_difficulty_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_difficulty_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			debug_num_players_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_num_players_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			debug_rp_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_rp_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			debug_host_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_host_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			debug_lobby_id_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_lobby_id_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			debug_hash_text = {
				vertical_alignment = "top",
				scenegraph_id = "debug_hash_text",
				horizontal_alignment = "left",
				word_wrap = true,
				font_size = 14,
				font_type = "hell_shark",
				text_color = Colors.get_table("white", 255)
			},
			background_rect = {
				color = {
					180,
					0,
					0,
					0
				}
			},
			debug_divider_0 = {
				scenegraph_id = "debug_divider_0",
				color = {
					150,
					255,
					255,
					255
				}
			},
			debug_divider_1 = {
				scenegraph_id = "debug_divider_1",
				color = {
					150,
					255,
					255,
					255
				}
			}
		}
	}
}

return {
	widget_definitions = tbl_4,
	widget_detail_definitions = tbl_5,
	deus_widget_definitions = tbl_6,
	deus_widget_detail_definitions = tbl_7,
	versus_widget_definitions = tbl_8,
	versus_widget_detail_definitions = tbl_9,
	cancel_input_widgets = tbl_11,
	versus_input_widgets = tbl_10,
	debug_widget_definitions = tbl_12,
	scenegraph_definition = tbl
}
