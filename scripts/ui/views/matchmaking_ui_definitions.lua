-- chunkname: @scripts/ui/views/matchmaking_ui_definitions.lua

local var_0_0 = {
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
local var_0_1 = 5
local var_0_2 = {
	255,
	10,
	10,
	10
}
local var_0_3 = {
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
local var_0_4 = table.clone(var_0_3)

var_0_4.vertical_alignment = "top"
var_0_4.horizontal_alignment = "left"
var_0_4.dynamic_font_size = true
var_0_4.offset[2] = -10
var_0_4.offset[1] = 15
var_0_4.text_color = Colors.get_color_table_with_alpha("font_title", 255)

local var_0_5 = table.clone(var_0_3)

var_0_5.vertical_alignment = "top"
var_0_5.horizontal_alignment = "left"
var_0_5.font_size = 16
var_0_5.offset[1] = 15
var_0_5.offset[2] = -35

local var_0_6 = table.clone(var_0_5)

var_0_6.default_color = {
	255,
	200,
	200,
	200
}

local var_0_7 = table.clone(var_0_3)

var_0_7.vertical_alignment = "center"
var_0_7.horizontal_alignment = "center"
var_0_7.font_size = 26
var_0_7.dynamic_font_size = true
var_0_7.word_wrap = false
var_0_7.offset[2] = 2

local var_0_8 = table.clone(var_0_7)

var_0_8.text_color = Colors.get_table("font_title")

local var_0_9 = table.clone(var_0_3)

var_0_9.vertical_alignment = "center"
var_0_9.horizontal_alignment = "left"
var_0_9.use_shadow = true
var_0_9.font_size = 28
var_0_9.dynamic_font_size = true
var_0_9.offset[2] = 2
var_0_9.text_color = Colors.get_color_table_with_alpha("font_title", 255)

local var_0_10 = table.clone(var_0_9)

var_0_10.text_color = Colors.get_color_table_with_alpha("white", 255)

local var_0_11 = table.clone(var_0_5)

var_0_11.default_color = {
	255,
	200,
	200,
	200
}

local var_0_12 = table.clone(var_0_7)

var_0_12.text_color = Colors.get_table("font_title")

local function var_0_13(arg_1_0, arg_1_1)
	local var_1_0 = 0.6
	local var_1_1 = 0.7
	local var_1_2 = 4
	local var_1_3 = {}

	for iter_1_0 = 1, var_1_2 do
		var_1_3[iter_1_0] = {
			255,
			255,
			255,
			255
		}
	end

	local var_1_4 = {
		element = {}
	}
	local var_1_5 = {
		{
			style_id = "orb",
			pass_type = "texture_uv",
			content_id = "orb",
			content_change_function = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				local var_2_0 = arg_2_0.parent
				local var_2_1 = var_2_0.size
				local var_2_2 = var_2_0.progress
				local var_2_3 = arg_2_1.default_size
				local var_2_4 = arg_2_1.texture_size
				local var_2_5 = arg_2_1.offset
				local var_2_6 = var_2_0.speed
				local var_2_7 = (var_2_1[1] + var_2_3[1]) / var_2_1[1]
				local var_2_8 = var_2_1[1]

				var_2_0.progress = (var_2_2 + arg_2_3 * var_2_6) % var_2_7

				local var_2_9 = var_2_3[1] / var_2_1[1]
				local var_2_10 = math.min(var_2_2 / var_2_9, 1)
				local var_2_11 = math.min((var_2_7 - var_2_2) / var_2_9, 1)
				local var_2_12 = var_2_7 - var_2_9
				local var_2_13 = math.min((var_2_7 - var_2_2) / var_2_9, 1)
				local var_2_14 = arg_2_0.uvs

				var_2_14[1][1] = 1 - var_2_10
				var_2_14[2][1] = var_2_11
				var_2_4[1] = math.floor(var_2_3[1] * math.min(var_2_10, var_2_11))
				var_2_5[1] = math.floor(-var_2_4[1] + var_2_8 * var_2_2 - (1 - var_2_11) * var_2_3[1])
			end
		},
		{
			style_id = "timeline",
			pass_type = "rect",
			content_change_function = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				local var_3_0 = arg_3_0.size
				local var_3_1 = arg_3_0.progress
				local var_3_2 = arg_3_1.offset
				local var_3_3 = arg_3_1.color
				local var_3_4 = arg_3_0.speed

				var_3_2[1] = -40 + var_3_0[1] * var_3_1
			end
		},
		{
			style_id = "trail",
			texture_id = "trail",
			pass_type = "texture",
			content_change_function = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				local var_4_0 = arg_4_0.size
				local var_4_1 = arg_4_0.progress
				local var_4_2 = arg_4_1.texture_size
				local var_4_3 = arg_4_1.offset
				local var_4_4 = arg_4_1.parent.orb.default_size
				local var_4_5 = var_4_0[1]

				var_4_3[1] = -(var_4_4[1] + 20) + var_4_5 * var_4_1
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
			content_change_function = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
				local var_5_0 = arg_5_0.progress
				local var_5_1 = math.min(var_5_0, 1)

				if var_5_1 < 0.5 then
					var_5_1 = math.easeInCubic(2 * var_5_1)
				else
					var_5_1 = math.easeOutCubic(2 - 2 * var_5_1)
				end

				local var_5_2 = arg_5_1.default_color
				local var_5_3 = arg_5_1.color
				local var_5_4 = 5
				local var_5_5 = 0.5 + math.sin(Managers.time:time("ui") * var_5_4) * 0.5
				local var_5_6 = math.max(var_5_1, var_5_5)
				local var_5_7 = 0.2

				var_5_3[2] = math.min(var_5_2[2] + var_5_2[2] * var_5_7 * var_5_5, 255)
				var_5_3[3] = math.min(var_5_2[3] + var_5_2[3] * var_5_7 * var_5_5, 255)
				var_5_3[4] = math.min(var_5_2[4] + var_5_2[4] * var_5_7 * var_5_5, 255)
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
	local var_1_6 = {
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
		speed = var_1_0
	}
	local var_1_7 = {
		background = {
			vertical_alignment = "center",
			horizontal_alignment = "center",
			texture_size = {
				556 * var_1_1,
				108 * var_1_1
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
				68 * var_1_1,
				68 * var_1_1
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
				68 * var_1_1,
				68 * var_1_1
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
				482 * var_1_1,
				62 * var_1_1
			},
			default_size = {
				482 * var_1_1,
				62 * var_1_1
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
				416 * var_1_1,
				arg_1_1[2] * var_1_1
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
				2 * var_1_1,
				arg_1_1[2] * var_1_1
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
				556 * var_1_1,
				160 * var_1_1
			},
			offset = {
				0,
				9,
				4
			},
			texture_tiling_size = {
				arg_1_1[1] * var_1_1,
				arg_1_1[2] * var_1_1
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
				556 * var_1_1,
				160 * var_1_1
			},
			offset = {
				0,
				9,
				4
			},
			texture_tiling_size = {
				arg_1_1[1] * var_1_1,
				arg_1_1[2] * var_1_1
			},
			color = {
				255,
				255,
				255,
				255
			}
		}
	}

	var_1_4.element.passes = var_1_5
	var_1_4.content = var_1_6
	var_1_4.style = var_1_7
	var_1_4.offset = {
		0,
		0,
		0
	}
	var_1_4.scenegraph_id = arg_1_0

	return var_1_4
end

local function var_0_14(arg_6_0, arg_6_1)
	return {
		scenegraph_id = "window",
		element = {
			passes = {
				{
					style_id = "texture_id",
					pass_type = "texture",
					texture_id = "texture_id",
					content_check_function = function(arg_7_0)
						return arg_7_0.is_connecting or arg_7_0.is_connected
					end,
					content_change_function = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
						local var_8_0 = arg_8_1.color

						if arg_8_0.is_connecting then
							local var_8_1 = ((arg_8_0.color_progress or 1) + arg_8_3) % 1

							arg_8_0.color_progress = var_8_1
							var_8_0[1] = 255 * math.ease_pulse(var_8_1)
						elseif arg_8_0.is_connected then
							var_8_0[1] = 255
						end
					end
				}
			}
		},
		content = {
			is_connected = false,
			is_connecting = false,
			texture_id = arg_6_0
		},
		style = {
			texture_id = {
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
				},
				offset = {
					arg_6_1[1] or 0,
					arg_6_1[2] or 0,
					arg_6_1[3] or 0
				}
			}
		}
	}
end

local var_0_15 = {
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
	status_text = UIWidgets.create_simple_text("n/a", "status_text", nil, nil, var_0_7),
	player_status_1 = var_0_14("matchmaking_light_02", {
		-89,
		43,
		1
	}),
	player_status_2 = var_0_14("matchmaking_light_02", {
		-71,
		22,
		1
	}),
	player_status_3 = var_0_14("matchmaking_light_02", {
		-45,
		12,
		1
	}),
	player_status_4 = var_0_14("matchmaking_light_02", {
		-18,
		15,
		1
	})
}
local var_0_16 = {
	detailed_info_box_frame = UIWidgets.create_frame("detailed_info_box", var_0_0.detailed_info_box.size, "menu_frame_09", 1),
	detailed_info_box = UIWidgets.create_background("detailed_info_box", var_0_0.detailed_info_box.size, "matchmaking_window_01"),
	title_text = UIWidgets.create_simple_text("n/a", "level_key_info_box", nil, nil, var_0_4),
	difficulty_text = UIWidgets.create_simple_text("n/a", "detailed_info_box", nil, nil, var_0_5),
	party_slot_1 = UIWidgets.create_matchmaking_portrait(var_0_0.party_slot_1.size, "party_slot_1"),
	party_slot_2 = UIWidgets.create_matchmaking_portrait(var_0_0.party_slot_2.size, "party_slot_2"),
	party_slot_3 = UIWidgets.create_matchmaking_portrait(var_0_0.party_slot_3.size, "party_slot_3"),
	party_slot_4 = UIWidgets.create_matchmaking_portrait(var_0_0.party_slot_4.size, "party_slot_4"),
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
local var_0_17 = {
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
	status_text = UIWidgets.create_simple_text("n/a", "status_text", nil, nil, var_0_8),
	player_status_1 = var_0_14("matchmaking_light_02", {
		-87,
		46
	}),
	player_status_2 = var_0_14("matchmaking_light_02", {
		-70,
		25
	}),
	player_status_3 = var_0_14("matchmaking_light_02", {
		-44,
		15
	}),
	player_status_4 = var_0_14("matchmaking_light_02", {
		-17,
		19
	})
}
local var_0_18 = {
	detailed_info_box = UIWidgets.create_simple_texture("matchmaking_animated_panel", "detailed_info_box", false, false, nil, {
		-5,
		-7,
		0
	}, "native"),
	title_text = UIWidgets.create_simple_text("n/a", "level_key_info_box", nil, nil, var_0_4),
	difficulty_text = UIWidgets.create_simple_text("n/a", "detailed_info_box", nil, nil, var_0_6),
	party_slot_1 = UIWidgets.create_matchmaking_portrait(var_0_0.party_slot_1.size, "party_slot_1"),
	party_slot_2 = UIWidgets.create_matchmaking_portrait(var_0_0.party_slot_2.size, "party_slot_2"),
	party_slot_3 = UIWidgets.create_matchmaking_portrait(var_0_0.party_slot_3.size, "party_slot_3"),
	party_slot_4 = UIWidgets.create_matchmaking_portrait(var_0_0.party_slot_4.size, "party_slot_4"),
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

var_0_18.detailed_info_box.content.no_background_changes = true

local var_0_19 = {
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
	status_text = UIWidgets.create_simple_text("n/a", "status_text", nil, nil, var_0_12)
}
local var_0_20 = {
	detailed_info_box = UIWidgets.create_simple_texture("matchmaking_animated_panel", "detailed_info_box", false, false, nil, {
		-5,
		-7,
		0
	}, "native"),
	title_text = UIWidgets.create_simple_text("n/a", "level_key_info_box", nil, nil, var_0_4),
	difficulty_text = UIWidgets.create_simple_text("n/a", "detailed_info_box", nil, nil, var_0_11),
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
	slot_reservations = var_0_13("slot_reservations", var_0_0.slot_reservations.size)
}

var_0_20.detailed_info_box.content.no_background_changes = true

local var_0_21 = {
	versus_cancel_text_input = UIWidgets.create_simple_text(Localize("matchmaking_suffix_cancel"), "versus_cancel_text_input", nil, nil, var_0_9),
	versus_cancel_text_suffix = UIWidgets.create_simple_text(Localize("matchmaking_suffix_cancel"), "versus_cancel_text_suffix", nil, nil, var_0_10),
	versus_cancel_text_prefix = UIWidgets.create_simple_text(Localize("matchmaking_suffix_cancel"), "versus_cancel_text_prefix", nil, nil, var_0_10),
	versus_cancel_icon = UIWidgets.create_simple_texture("xbone_button_icon_a", "versus_cancel_icon"),
	cancel_input_backround = UIWidgets.create_simple_texture("tab_menu_bg_02", "cancel_input_backround")
}
local var_0_22 = {
	cancel_text_input = UIWidgets.create_simple_text(Localize("matchmaking_suffix_cancel"), "cancel_text_input", nil, nil, var_0_9),
	cancel_text_suffix = UIWidgets.create_simple_text(Localize("matchmaking_suffix_cancel"), "cancel_text_suffix", nil, nil, var_0_10),
	cancel_text_prefix = UIWidgets.create_simple_text(Localize("matchmaking_suffix_cancel"), "cancel_text_prefix", nil, nil, var_0_10),
	cancel_icon = UIWidgets.create_simple_texture("xbone_button_icon_a", "cancel_icon"),
	cancel_input_backround = UIWidgets.create_simple_texture("tab_menu_bg_02", "cancel_input_backround")
}
local var_0_23 = {
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
	widget_definitions = var_0_15,
	widget_detail_definitions = var_0_16,
	deus_widget_definitions = var_0_17,
	deus_widget_detail_definitions = var_0_18,
	versus_widget_definitions = var_0_19,
	versus_widget_detail_definitions = var_0_20,
	cancel_input_widgets = var_0_22,
	versus_input_widgets = var_0_21,
	debug_widget_definitions = var_0_23,
	scenegraph_definition = var_0_0
}
