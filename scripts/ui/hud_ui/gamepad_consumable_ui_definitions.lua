-- chunkname: @scripts/ui/hud_ui/gamepad_consumable_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = true
local var_0_3 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
		}
	},
	pivot = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			-310,
			80,
			1
		},
		size = {
			0,
			0
		}
	},
	selection = {
		parent = "pivot",
		position = {
			-9,
			-8,
			1
		},
		size = {
			82,
			80
		}
	},
	selection_input_icon = {
		vertical_alignment = "top",
		parent = "selection_input_bg",
		horizontal_alignment = "center",
		position = {
			0,
			-1,
			5
		},
		size = {
			26,
			26
		}
	},
	selection_input_bg = {
		vertical_alignment = "top",
		parent = "selection",
		horizontal_alignment = "center",
		position = {
			0,
			18,
			-1
		},
		size = {
			45,
			39
		}
	},
	background = {
		parent = "pivot",
		position = {
			-4,
			-4,
			0
		},
		size = {
			198,
			72
		}
	}
}

local function var_0_4(arg_1_0, arg_1_1, arg_1_2)
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					texture_id = "texture_bg",
					style_id = "texture_bg",
					pass_type = "texture",
					retained_mode = true
				},
				{
					texture_id = "texture_icon",
					style_id = "texture_icon",
					pass_type = "texture",
					retained_mode = true
				},
				{
					texture_id = "texture_icon_lit",
					style_id = "texture_icon_lit",
					pass_type = "texture",
					retained_mode = true,
					content_check_function = function (arg_2_0)
						return arg_2_0.has_data and arg_2_0.wielded
					end
				},
				{
					style_id = "text_ammo",
					pass_type = "text",
					text_id = "text_ammo",
					retained_mode = true,
					content_check_function = function (arg_3_0)
						return arg_3_0.has_data and arg_3_0.show_ammo
					end
				}
			}
		},
		content = {
			text_ammo = "x2",
			total_ammo = 0,
			texture_highlight = "consumables_frame_lit",
			texture_icon = "default_heal_ally_icon",
			texture_icon_lit = "default_heal_ally_icon_lit",
			texture_bg = "consumables_frame_bg_lit",
			has_data = false
		},
		style = {
			text_ammo = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 20,
				horizontal_alignment = "center",
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = arg_1_2
			},
			texture_bg = {
				size = {
					64,
					64
				},
				offset = {
					0,
					0,
					0
				},
				color = {
					100,
					255,
					255,
					255
				}
			},
			texture_highlight = {
				size = {
					64,
					64
				},
				offset = {
					0,
					0,
					3
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			texture_icon = {
				size = {
					64,
					64
				},
				offset = {
					0,
					0,
					1
				},
				color = {
					50,
					255,
					255,
					255
				}
			},
			texture_icon_lit = {
				size = {
					64,
					64
				},
				offset = {
					0,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local var_0_5 = math.degrees_to_radians
local var_0_6 = {
	slot_potion = var_0_4(var_0_5(0), {
		-36,
		-30,
		2
	}, {
		20,
		-20,
		3
	}),
	slot_grenade = var_0_4(var_0_5(180), {
		-26,
		-30,
		2
	}, {
		20,
		-20,
		3
	}),
	slot_healthkit = var_0_4(var_0_5(90), {
		-32,
		-26,
		2
	}, {
		20,
		-20,
		3
	}),
	selection = UIWidgets.create_gamepad_selection("selection", true),
	background = UIWidgets.create_simple_texture("player_consumable_bg", "background")
}
local var_0_7 = {
	pickup = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 1,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				return
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				local var_5_0 = math.easeInCubic(arg_5_3)

				arg_5_2[1].style.texture_highlight.color[1] = 255 * var_5_0
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				return
			end
		}
	}
}

return {
	scenegraph_definition = var_0_3,
	widget_definitions = var_0_6,
	animations = var_0_7
}
