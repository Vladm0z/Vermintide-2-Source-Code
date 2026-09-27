-- chunkname: @scripts/settings/dlcs/shovel/additional_career_info_ui.lua

local tbl = {
	440,
	250
}
local num = 580
local tbl_2 = {
	bw_necromancer_special_window = {
		vertical_alignment = "top",
		parent = "career_perk_3",
		horizontal_alignment = "left",
		size = tbl,
		position = {
			-20,
			-tbl[2],
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
			tbl[1] * 0.6,
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
			tbl[1] * 0.3,
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
			tbl[1] - 110,
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
			tbl[1] * 0.8,
			tbl[2]
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
			tbl[1] * 0.6,
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
			tbl[1] - 20,
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
			tbl[1] * 0.8,
			tbl[2]
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
			tbl[1] * 0.6,
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
			tbl[1] - 20,
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
			tbl[1] * 0.8,
			tbl[2]
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
			tbl[1] * 0.6,
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
			tbl[1] - 20,
			80
		},
		position = {
			0,
			-40,
			1
		}
	}
}
local tbl_3 = {
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
local tbl_4 = {
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
local tbl_5 = {
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
local tbl_6 = {
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
local tbl_7 = {
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
local tbl_8 = {
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

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	local offset

	if not arg_1_5 then
		offset = arg_1_5.offset

		if not offset then
			-- Nothing
		end
	end

	offset = {
		0,
		0,
		2
	}

	do
		local text_color
	end

	::label_1_0::

	if not arg_1_5 then
		text_color = arg_1_5.text_color

		if not text_color then
			-- Nothing
		end
	end

	text_color = arg_1_4 or {
		255,
		255,
		255,
		255
	}

	::label_1_1::

	arg_1_5 = arg_1_5 or {
		vertical_alignment = "center",
		localize = true,
		horizontal_alignment = "center",
		word_wrap = true,
		font_type = "hell_shark",
		font_size = arg_1_3,
		text_color = text_color,
		offset = offset
	}

	local clone = table.clone(arg_1_5)
	local shadow_color = arg_1_5.shadow_color

	shadow_color = shadow_color or {
		255,
		0,
		0,
		0
	}

	local shadow_offset = arg_1_5.shadow_offset

	shadow_offset = shadow_offset or {
		2,
		2,
		0
	}
	shadow_color[1] = text_color[1]
	clone.text_color = shadow_color
	clone.offset = {
		offset[1] + shadow_offset[1],
		offset[2] - shadow_offset[2],
		offset[3] - 1
	}
	clone.skip_button_rendering = true

	local tbl = {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (arg_2_0)
						-- function 2
						return not Managers.input:is_device_active("gamepad")
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 3
						local is_device_active = Managers.input:is_device_active("gamepad")
						local use_shadow = self.use_shadow

						use_shadow = not use_shadow and not is_device_active

						return use_shadow
					end
				},
				{
					style_id = "gamepad_text",
					pass_type = "text",
					text_id = "gamepad_text",
					content_check_function = function (arg_4_0)
						-- function 4
						return (Managers.input:is_device_active("gamepad"))
					end
				},
				{
					style_id = "gamepad_text_shadow",
					pass_type = "text",
					text_id = "gamepad_text",
					content_check_function = function (self)
						-- function 5
						local is_device_active = Managers.input:is_device_active("gamepad")
						local use_shadow = self.use_shadow

						use_shadow = not use_shadow and is_device_active

						return use_shadow
					end
				}
			}
		}
	}
	local tbl_2 = {
		text = arg_1_0,
		gamepad_text = arg_1_1,
		original_text = arg_1_0,
		color = text_color
	}
	local use_shadow

	if not arg_1_5 then
		use_shadow = arg_1_5.use_shadow

		if not use_shadow then
			-- Nothing
		end
	end

	use_shadow = false

	::label_1_2::

	tbl_2.use_shadow = use_shadow
	tbl.content = tbl_2
	tbl.style = {
		text = arg_1_5,
		text_shadow = clone,
		gamepad_text = table.clone(arg_1_5),
		gamepad_text_shadow = table.clone(clone)
	}
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = arg_1_2

	return tbl
end

local num_2 = SHOVEL_BUFF_TWEAK_DATA.sienna_necromancer_command_item_attack.multiplier * 100
local duration = SHOVEL_BUFF_TWEAK_DATA.sienna_necromancer_command_item_attack.duration
local format = string.format(Localize("skeleton_command_attack_desc"), num_2, duration)
local num_3 = SHOVEL_BUFF_TWEAK_DATA.sienna_necromancer_command_item_defend.multiplier * 100
local format_2 = string.format(Localize("skeleton_command_defend_desc"), num_3)
local num_4 = SHOVEL_BUFF_TWEAK_DATA.sienna_necromancer_command_item_sacrifice.multiplier * 100
local format_3 = string.format(Localize("skeleton_command_release_desc"), num_4)
local tbl_9 = {
	special_title_text = UIWidgets.create_simple_text("skeleton_command_item_name", "bw_necromancer_special_title_text", nil, nil, tbl_5),
	special_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "bw_necromancer_special_title_divider", true),
	special_description_text = UIWidgets.create_simple_text(Localize("skeleton_command_item_desc"), "bw_necromancer_special_description_text", nil, nil, tbl_3),
	special_icon = UIWidgets.create_simple_texture("hud_inventory_icon_necromancer_utility", "bw_necromancer_special_icon", true),
	special_icon_frame = UIWidgets.create_simple_texture("talent_frame", "bw_necromancer_special_icon_frame", true),
	special_icon_bg = UIWidgets.create_simple_texture("rect_masked", "bw_necromancer_special_icon_frame", true, false, {
		255,
		0,
		0,
		0
	}, -5),
	attack_icon_text = UIWidgets.create_simple_text("$KEY;Player__action_one:" .. " {#color(193,91,36)}" .. Localize("shovel_command_attack"), "bw_necromancer_attack_icon", nil, nil, tbl_8),
	attack_description_text = UIWidgets.create_simple_text(format, "bw_necromancer_attack_description_text", nil, nil, tbl_3),
	defend_icon_text = UIWidgets.create_simple_text("$KEY;Player__action_two:" .. " {#color(193,91,36)}" .. Localize("shovel_command_defend"), "bw_necromancer_defend_icon", nil, nil, tbl_8),
	defend_description_text = UIWidgets.create_simple_text(format_2, "bw_necromancer_defend_description_text", nil, nil, tbl_3),
	release_icon_text = fn("$KEY;Player__weapon_reload:" .. "{#color(193,91,36)}" .. Localize("shovel_command_sacrifice"), "$KEY;Player__weapon_reload_input:" .. "{#color(193,91,36)}" .. Localize("shovel_command_sacrifice"), "bw_necromancer_release_icon", nil, nil, tbl_8),
	release_description_text = UIWidgets.create_simple_text(format_3, "bw_necromancer_release_description_text", nil, nil, tbl_3)
}

local function fn_2(arg_6_0)
	-- function 6
	local tbl = {}
	local tbl_2 = {}
	local num_2 = 500

	for k, v in pairs(tbl_9) do
		local var_6_3 = UIWidget.init(v)

		tbl[#tbl + 1] = var_6_3
		tbl_2[k] = var_6_3
	end

	return tbl, tbl_2, num
end

return {
	setup = fn_2,
	scenegraph_definition_to_inject = tbl_2
}
