-- chunkname: @scripts/settings/dlcs/shovel/additional_career_info_ui.lua

local career_info_size = {
	440,
	250
}
local additional_info_size = 580
local scenegraph_definition_to_inject = {
	bw_necromancer_special_window = {
		vertical_alignment = "top",
		parent = "career_perk_3",
		horizontal_alignment = "left",
		size = career_info_size,
		position = {
			-20,
			-career_info_size[2],
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
			career_info_size[1] * 0.6,
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
			career_info_size[1] * 0.3,
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
			career_info_size[1] - 110,
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
			career_info_size[1] * 0.8,
			career_info_size[2]
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
			career_info_size[1] * 0.6,
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
			career_info_size[1] - 20,
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
			career_info_size[1] * 0.8,
			career_info_size[2]
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
			career_info_size[1] * 0.6,
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
			career_info_size[1] - 20,
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
			career_info_size[1] * 0.8,
			career_info_size[2]
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
			career_info_size[1] * 0.6,
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
			career_info_size[1] - 20,
			80
		},
		position = {
			0,
			-40,
			1
		}
	}
}
local description_text_style = {
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
local type_title_text_style = {
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
local sub_title_text_style = {
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
local attack_title_text_style = {
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
local attack_title_sub_text_style = {
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
local icon_text_style = {
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

local function create_gamepad_and_pc_text(text, gamepad_text, scenegraph_id, size, color, text_style)
	-- function 1
	local offset

	if text_style then
		offset = text_style.offset

		if not offset then
			-- Nothing
		end
	end

	offset = {
		0,
		0,
		2
	}

	local text_offset = offset

	do
		local text_color_2
	end

	::label_1_0::

	if text_style then
		text_color_2 = text_style.text_color

		if not text_color_2 then
			-- Nothing
		end
	end

	if not color then
		-- Nothing
	end

	::label_1_1::

	text_color_2 = {
		255,
		255,
		255,
		255
	}

	local text_color = text_color_2

	::label_1_2::

	text_style = not not text_style or not not {
		vertical_alignment = "center",
		localize = true,
		horizontal_alignment = "center",
		word_wrap = true,
		font_type = "hell_shark",
		font_size = size,
		text_color = text_color,
		offset = text_offset
	}

	local text_shadow_style = table.clone(text_style)
	local shadow_color = text_style.shadow_color

	if not shadow_color then
		-- Nothing
	end

	shadow_color = {
		255,
		0,
		0,
		0
	}

	local text_shadow_style_color = shadow_color

	::label_1_3::

	local shadow_offset = text_style.shadow_offset

	if not shadow_offset then
		-- Nothing
	end

	shadow_offset = {
		2,
		2,
		0
	}

	local text_shadow_offset = shadow_offset

	::label_1_4::

	text_shadow_style_color[1] = text_color[1]
	text_shadow_style.text_color = text_shadow_style_color
	text_shadow_style.offset = {
		text_offset[1] + text_shadow_offset[1],
		text_offset[2] - text_shadow_offset[2],
		text_offset[3] - 1
	}
	text_shadow_style.skip_button_rendering = true

	local tbl = {
		element = {
			passes = {
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (content)
						-- function 2
						local gamepad_active = Managers.input:is_device_active("gamepad")

						return not gamepad_active
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (content)
						-- function 3
						local gamepad_active = Managers.input:is_device_active("gamepad")
						local use_shadow = content.use_shadow

						use_shadow = not not use_shadow and not not not gamepad_active

						return use_shadow
					end
				},
				{
					style_id = "gamepad_text",
					pass_type = "text",
					text_id = "gamepad_text",
					content_check_function = function (content)
						-- function 4
						local gamepad_active = Managers.input:is_device_active("gamepad")

						return gamepad_active
					end
				},
				{
					style_id = "gamepad_text_shadow",
					pass_type = "text",
					text_id = "gamepad_text",
					content_check_function = function (content)
						-- function 5
						local gamepad_active = Managers.input:is_device_active("gamepad")
						local use_shadow = content.use_shadow

						use_shadow = not not use_shadow and not not gamepad_active

						return use_shadow
					end
				}
			}
		}
	}
	local tbl_2 = {
		text = text,
		gamepad_text = gamepad_text,
		original_text = text,
		color = text_color
	}
	local use_shadow

	if text_style then
		use_shadow = text_style.use_shadow

		if not use_shadow then
			-- Nothing
		end
	end

	use_shadow = false

	::label_1_5::

	tbl_2.use_shadow = use_shadow
	tbl.content = tbl_2
	tbl.style = {
		text = text_style,
		text_shadow = text_shadow_style,
		gamepad_text = table.clone(text_style),
		gamepad_text_shadow = table.clone(text_shadow_style)
	}
	tbl.offset = {
		0,
		0,
		0
	}
	tbl.scenegraph_id = scenegraph_id

	return tbl
end

local item_attack_multiplier = SHOVEL_BUFF_TWEAK_DATA.sienna_necromancer_command_item_attack.multiplier * 100
local item_attack_duration = SHOVEL_BUFF_TWEAK_DATA.sienna_necromancer_command_item_attack.duration
local item_attack_description = string.format(Localize("skeleton_command_attack_desc"), item_attack_multiplier, item_attack_duration)
local item_defend_multiplier = SHOVEL_BUFF_TWEAK_DATA.sienna_necromancer_command_item_defend.multiplier * 100
local item_defend_description = string.format(Localize("skeleton_command_defend_desc"), item_defend_multiplier)
local item_release_multiplier = SHOVEL_BUFF_TWEAK_DATA.sienna_necromancer_command_item_sacrifice.multiplier * 100
local item_release_description = string.format(Localize("skeleton_command_release_desc"), item_release_multiplier)
local widget_definitions = {
	special_title_text = UIWidgets.create_simple_text("skeleton_command_item_name", "bw_necromancer_special_title_text", nil, nil, sub_title_text_style),
	special_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "bw_necromancer_special_title_divider", true),
	special_description_text = UIWidgets.create_simple_text(Localize("skeleton_command_item_desc"), "bw_necromancer_special_description_text", nil, nil, description_text_style),
	special_icon = UIWidgets.create_simple_texture("hud_inventory_icon_necromancer_utility", "bw_necromancer_special_icon", true),
	special_icon_frame = UIWidgets.create_simple_texture("talent_frame", "bw_necromancer_special_icon_frame", true),
	special_icon_bg = UIWidgets.create_simple_texture("rect_masked", "bw_necromancer_special_icon_frame", true, false, {
		255,
		0,
		0,
		0
	}, -5),
	attack_icon_text = UIWidgets.create_simple_text("$KEY;Player__action_one:" .. " {#color(193,91,36)}" .. Localize("shovel_command_attack"), "bw_necromancer_attack_icon", nil, nil, icon_text_style),
	attack_description_text = UIWidgets.create_simple_text(item_attack_description, "bw_necromancer_attack_description_text", nil, nil, description_text_style),
	defend_icon_text = UIWidgets.create_simple_text("$KEY;Player__action_two:" .. " {#color(193,91,36)}" .. Localize("shovel_command_defend"), "bw_necromancer_defend_icon", nil, nil, icon_text_style),
	defend_description_text = UIWidgets.create_simple_text(item_defend_description, "bw_necromancer_defend_description_text", nil, nil, description_text_style),
	release_icon_text = create_gamepad_and_pc_text("$KEY;Player__weapon_reload:" .. "{#color(193,91,36)}" .. Localize("shovel_command_sacrifice"), "$KEY;Player__weapon_reload_input:" .. "{#color(193,91,36)}" .. Localize("shovel_command_sacrifice"), "bw_necromancer_release_icon", nil, nil, icon_text_style),
	release_description_text = UIWidgets.create_simple_text(item_release_description, "bw_necromancer_release_description_text", nil, nil, description_text_style)
}

local function setup(scenegraph_id)
	-- function 6
	local additional_widgets = {}
	local additional_widgets_by_name = {}
	local widgets_height = 500

	for name, widget_definition in pairs(widget_definitions) do
		local widget = UIWidget.init(widget_definition)

		additional_widgets[#additional_widgets + 1] = widget
		additional_widgets_by_name[name] = widget
	end

	return additional_widgets, additional_widgets_by_name, additional_info_size
end

return {
	setup = setup,
	scenegraph_definition_to_inject = scenegraph_definition_to_inject
}
