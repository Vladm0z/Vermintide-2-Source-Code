-- chunkname: @scripts/settings/dlcs/shovel/additional_career_info_ui.lua

local var_0_0 = {
	440,
	250
}
local var_0_1 = 580
local var_0_2 = {
	bw_necromancer_special_window = {
		vertical_alignment = "top",
		parent = "career_perk_3",
		horizontal_alignment = "left",
		size = var_0_0,
		position = {
			-20,
			-var_0_0[2],
			1
		}
	},
	bw_necromancer_special_icon = {
		vertical_alignment = "top",
		parent = "bw_necromancer_special_window",
		horizontal_alignment = "left",
		size = {
			45,
			45
		},
		position = {
			27.5,
			-67.5,
			5
		}
	},
	bw_necromancer_special_icon_frame = {
		vertical_alignment = "center",
		parent = "bw_necromancer_special_icon",
		horizontal_alignment = "center",
		size = {
			80,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	bw_necromancer_special_title_text = {
		vertical_alignment = "top",
		parent = "bw_necromancer_special_window",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] * 0.6,
			50
		},
		position = {
			10,
			-5,
			1
		}
	},
	bw_necromancer_special_title_divider = {
		vertical_alignment = "bottom",
		parent = "bw_necromancer_special_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	bw_necromancer_special_type_title = {
		vertical_alignment = "top",
		parent = "bw_necromancer_special_window",
		horizontal_alignment = "right",
		size = {
			var_0_0[1] * 0.3,
			50
		},
		position = {
			-10,
			-5,
			1
		}
	},
	bw_necromancer_special_description_text = {
		vertical_alignment = "top",
		parent = "bw_necromancer_special_icon",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] - 110,
			100
		},
		position = {
			72.5,
			17.5,
			1
		}
	},
	bw_necromancer_attack_window = {
		vertical_alignment = "top",
		parent = "bw_necromancer_special_icon",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] * 0.8,
			var_0_0[2]
		},
		position = {
			10,
			-60,
			1
		}
	},
	bw_necromancer_attack_icon = {
		vertical_alignment = "top",
		parent = "bw_necromancer_attack_window",
		horizontal_alignment = "left",
		size = {
			40,
			40
		},
		position = {
			0,
			-50,
			5
		}
	},
	bw_necromancer_attack_icon_frame = {
		vertical_alignment = "center",
		parent = "bw_necromancer_attack_icon",
		horizontal_alignment = "center",
		size = {
			40,
			40
		},
		position = {
			0,
			0,
			1
		}
	},
	bw_necromancer_attack_title_text = {
		vertical_alignment = "top",
		parent = "bw_necromancer_attack_icon",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] * 0.6,
			50
		},
		position = {
			10,
			0,
			1
		}
	},
	bw_necromancer_attack_description_text = {
		vertical_alignment = "top",
		parent = "bw_necromancer_attack_icon",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] - 20,
			80
		},
		position = {
			0,
			-40,
			1
		}
	},
	bw_necromancer_defend_window = {
		vertical_alignment = "top",
		parent = "bw_necromancer_attack_icon",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] * 0.8,
			var_0_0[2]
		},
		position = {
			0,
			-80,
			1
		}
	},
	bw_necromancer_defend_icon = {
		vertical_alignment = "top",
		parent = "bw_necromancer_defend_window",
		horizontal_alignment = "left",
		size = {
			40,
			40
		},
		position = {
			0,
			-50,
			5
		}
	},
	bw_necromancer_defend_icon_frame = {
		vertical_alignment = "center",
		parent = "bw_necromancer_defend_icon",
		horizontal_alignment = "center",
		size = {
			40,
			40
		},
		position = {
			0,
			0,
			1
		}
	},
	bw_necromancer_defend_title_text = {
		vertical_alignment = "top",
		parent = "bw_necromancer_defend_icon",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] * 0.6,
			50
		},
		position = {
			10,
			0,
			1
		}
	},
	bw_necromancer_defend_description_text = {
		vertical_alignment = "top",
		parent = "bw_necromancer_defend_icon",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] - 20,
			80
		},
		position = {
			0,
			-40,
			1
		}
	},
	bw_necromancer_release_window = {
		vertical_alignment = "top",
		parent = "bw_necromancer_defend_icon",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] * 0.8,
			var_0_0[2]
		},
		position = {
			0,
			-80,
			1
		}
	},
	bw_necromancer_release_icon = {
		vertical_alignment = "top",
		parent = "bw_necromancer_release_window",
		horizontal_alignment = "left",
		size = {
			40,
			40
		},
		position = {
			0,
			-50,
			5
		}
	},
	bw_necromancer_release_icon_frame = {
		vertical_alignment = "center",
		parent = "bw_necromancer_release_icon",
		horizontal_alignment = "center",
		size = {
			40,
			40
		},
		position = {
			0,
			0,
			1
		}
	},
	bw_necromancer_release_title_text = {
		vertical_alignment = "top",
		parent = "bw_necromancer_release_icon",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] * 0.6,
			50
		},
		position = {
			10,
			0,
			1
		}
	},
	bw_necromancer_release_description_text = {
		vertical_alignment = "top",
		parent = "bw_necromancer_release_icon",
		horizontal_alignment = "left",
		size = {
			var_0_0[1] - 20,
			80
		},
		position = {
			0,
			-40,
			1
		}
	}
}
local var_0_3 = {
	word_wrap = true,
	use_shadow = true,
	localize = false,
	dynamic_font_size_word_wrap = true,
	font_size = 18,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_4 = {
	word_wrap = true,
	use_shadow = true,
	localize = true,
	font_size = 18,
	horizontal_alignment = "right",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("gray", 200),
	offset = {
		0,
		0,
		2
	}
}
local var_0_5 = {
	font_size = 32,
	upper_case = false,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header_masked",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local var_0_6 = {
	font_size = 28,
	upper_case = false,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	dynamic_font_size = true,
	font_type = "hell_shark_header_masked",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		20,
		5,
		2
	}
}
local var_0_7 = {
	font_size = 18,
	upper_case = false,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "bottom",
	font_type = "hell_shark_header_masked",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		5,
		2
	}
}
local var_0_8 = {
	font_size = 24,
	use_shadow = false,
	localize = false,
	word_wrap = false,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	masked = true,
	font_type = "hell_shark_masked",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}

local function var_0_9(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = arg_1_5 and arg_1_5.offset or {
		0,
		0,
		2
	}
	local var_1_1 = arg_1_5 and arg_1_5.text_color or arg_1_4 or {
		255,
		255,
		255,
		255
	}

	arg_1_5 = arg_1_5 or {
		vertical_alignment = "center",
		localize = true,
		horizontal_alignment = "center",
		word_wrap = true,
		font_type = "hell_shark",
		font_size = arg_1_3,
		text_color = var_1_1,
		offset = var_1_0
	}

	local var_1_2 = table.clone(arg_1_5)
	local var_1_3 = arg_1_5.shadow_color or {
		255,
		0,
		0,
		0
	}
	local var_1_4 = arg_1_5.shadow_offset or {
		2,
		2,
		0
	}

	var_1_3[1] = var_1_1[1]
	var_1_2.text_color = var_1_3
	var_1_2.offset = {
		var_1_0[1] + var_1_4[1],
		var_1_0[2] - var_1_4[2],
		var_1_0[3] - 1
	}
	var_1_2.skip_button_rendering = true

	return {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_2_0)
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_3_0)
						local var_3_0 = Managers.input:is_device_active("gamepad")

						return arg_3_0.use_shadow and not var_3_0
					end
				},
				{
					style_id = "gamepad_text",
					pass_type = "text",
					text_id = "gamepad_text",
					content_check_function = function (arg_4_0)
						return (Managers.input:is_device_active("gamepad"))
					end
				},
				{
					style_id = "gamepad_text_shadow",
					pass_type = "text",
					text_id = "gamepad_text",
					content_check_function = function (arg_5_0)
						local var_5_0 = Managers.input:is_device_active("gamepad")

						return arg_5_0.use_shadow and var_5_0
					end
				}
			}
		},
		content = {
			text = arg_1_0,
			gamepad_text = arg_1_1,
			original_text = arg_1_0,
			color = var_1_1,
			use_shadow = arg_1_5 and arg_1_5.use_shadow or false
		},
		style = {
			text = arg_1_5,
			text_shadow = var_1_2,
			gamepad_text = table.clone(arg_1_5),
			gamepad_text_shadow = table.clone(var_1_2)
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_1_2
	}
end

local var_0_10 = SHOVEL_BUFF_TWEAK_DATA.sienna_necromancer_command_item_attack.multiplier * 100
local var_0_11 = SHOVEL_BUFF_TWEAK_DATA.sienna_necromancer_command_item_attack.duration
local var_0_12 = string.format(Localize("skeleton_command_attack_desc"), var_0_10, var_0_11)
local var_0_13 = SHOVEL_BUFF_TWEAK_DATA.sienna_necromancer_command_item_defend.multiplier * 100
local var_0_14 = string.format(Localize("skeleton_command_defend_desc"), var_0_13)
local var_0_15 = SHOVEL_BUFF_TWEAK_DATA.sienna_necromancer_command_item_sacrifice.multiplier * 100
local var_0_16 = string.format(Localize("skeleton_command_release_desc"), var_0_15)
local var_0_17 = {
	special_title_text = UIWidgets.create_simple_text("skeleton_command_item_name", "bw_necromancer_special_title_text", nil, nil, var_0_5),
	special_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "bw_necromancer_special_title_divider", true),
	special_description_text = UIWidgets.create_simple_text(Localize("skeleton_command_item_desc"), "bw_necromancer_special_description_text", nil, nil, var_0_3),
	special_icon = UIWidgets.create_simple_texture("hud_inventory_icon_necromancer_utility", "bw_necromancer_special_icon", true),
	special_icon_frame = UIWidgets.create_simple_texture("talent_frame", "bw_necromancer_special_icon_frame", true),
	special_icon_bg = UIWidgets.create_simple_texture("rect_masked", "bw_necromancer_special_icon_frame", true, false, {
		255,
		0,
		0,
		0
	}, -5),
	attack_icon_text = UIWidgets.create_simple_text("$KEY;Player__action_one:" .. " {#color(193,91,36)}" .. Localize("shovel_command_attack"), "bw_necromancer_attack_icon", nil, nil, var_0_8),
	attack_description_text = UIWidgets.create_simple_text(var_0_12, "bw_necromancer_attack_description_text", nil, nil, var_0_3),
	defend_icon_text = UIWidgets.create_simple_text("$KEY;Player__action_two:" .. " {#color(193,91,36)}" .. Localize("shovel_command_defend"), "bw_necromancer_defend_icon", nil, nil, var_0_8),
	defend_description_text = UIWidgets.create_simple_text(var_0_14, "bw_necromancer_defend_description_text", nil, nil, var_0_3),
	release_icon_text = var_0_9("$KEY;Player__weapon_reload:" .. "{#color(193,91,36)}" .. Localize("shovel_command_sacrifice"), "$KEY;Player__weapon_reload_input:" .. "{#color(193,91,36)}" .. Localize("shovel_command_sacrifice"), "bw_necromancer_release_icon", nil, nil, var_0_8),
	release_description_text = UIWidgets.create_simple_text(var_0_16, "bw_necromancer_release_description_text", nil, nil, var_0_3)
}

local function var_0_18(arg_6_0)
	local var_6_0 = {}
	local var_6_1 = {}
	local var_6_2 = 500

	for iter_6_0, iter_6_1 in pairs(var_0_17) do
		local var_6_3 = UIWidget.init(iter_6_1)

		var_6_0[#var_6_0 + 1] = var_6_3
		var_6_1[iter_6_0] = var_6_3
	end

	return var_6_0, var_6_1, var_0_1
end

return {
	setup = var_0_18,
	scenegraph_definition_to_inject = var_0_2
}
