-- chunkname: @scripts/ui/hud_ui/pet_ui_definitions.lua

local var_0_0 = true
local var_0_1 = {
	"necromancer_hud_skull_01",
	"necromancer_hud_skull_02",
	"necromancer_hud_skull_03",
	"necromancer_hud_skull_04",
	"necromancer_hud_skull_05",
	"necromancer_hud_skull_06"
}
local var_0_2 = {
	"necromancer_hud_skull_01_eyes",
	"necromancer_hud_skull_02_eyes",
	"necromancer_hud_skull_03_eyes",
	"necromancer_hud_skull_04_eyes",
	"necromancer_hud_skull_05_eyes",
	"necromancer_hud_skull_06_eyes"
}
local var_0_3 = {
	[CommandStates.Following] = "necromancer_command_coin_follow",
	[CommandStates.Attacking] = "necromancer_command_coin_attack",
	[CommandStates.StandingGround] = "necromancer_command_coin_defend"
}
local var_0_4 = {
	[CommandStates.Following] = "shovel_skeleton_state_follow",
	[CommandStates.Attacking] = "shovel_skeleton_state_attack",
	[CommandStates.StandingGround] = "shovel_skeleton_state_defend"
}
local var_0_5 = {
	1920,
	1080
}
local var_0_6 = {
	root = {
		is_root = true,
		position = {
			0,
			0,
			UILayer.hud
		},
		size = var_0_5
	},
	screen = {
		position = {
			0,
			0,
			UILayer.hud_inventory
		},
		size = var_0_5,
		scale = IS_CONSOLE and "hud_fit" or "fit"
	},
	container = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			460,
			0,
			0
		},
		size = {
			300,
			80
		}
	},
	skull_pivot = {
		vertical_alignment = "top",
		parent = "container",
		horizontal_alignment = "left",
		position = {
			2,
			-11,
			5
		},
		size = {
			64,
			64
		}
	}
}
local var_0_7 = {
	scenegraph_id = "container",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "bg",
				texture_id = "bg",
				retained_mode = var_0_0
			},
			{
				pass_type = "texture",
				style_id = "enumerator_bg",
				texture_id = "enumerator_bg",
				retained_mode = var_0_0,
				content_check_function = function(arg_1_0)
					return Application.user_setting("numeric_ui")
				end
			},
			{
				style_id = "help_text",
				pass_type = "text",
				text_id = "help_text",
				retained_mode = var_0_0,
				content_check_function = function(arg_2_0)
					return arg_2_0.in_command_mode
				end
			},
			{
				pass_type = "texture",
				style_id = "state_glow",
				texture_id = "state_glow",
				retained_mode = var_0_0,
				content_check_function = function(arg_3_0)
					return arg_3_0.show_glow
				end
			},
			{
				pass_type = "texture",
				style_id = "state",
				texture_id = "state",
				retained_mode = var_0_0
			},
			{
				pass_type = "texture",
				style_id = "state_icon",
				texture_id = "state_icon",
				retained_mode = var_0_0
			},
			{
				style_id = "pet_amount_text",
				pass_type = "text",
				text_id = "pet_amount_text",
				retained_mode = var_0_0
			},
			{
				style_id = "pet_amount_text_shadow",
				pass_type = "text",
				text_id = "pet_amount_text_shadow",
				retained_mode = var_0_0
			}
		}
	},
	content = {
		pet_amount_text = "",
		enumerator_bg = "necromancer_hud_enumerator_piece",
		state_icon = "necromancer_command_coin_attack",
		state = "necromancer_command_coin",
		show_glow = false,
		bg = "necromancer_hud_base",
		pet_amount_text_shadow = "",
		state_glow = "necromancer_heavy_attack_fx"
	},
	style = {
		bg = {
			texture_size = {
				300,
				80
			},
			offset = {
				0,
				0,
				2
			}
		},
		state_glow = {
			horizontal_alignment = "right",
			texture_size = {
				76,
				84
			},
			offset = {
				15,
				0,
				1
			}
		},
		state = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = {
				48,
				48
			},
			offset = {
				244,
				-18,
				3
			}
		},
		state_icon = {
			vertical_alignment = "top",
			horizontal_alignment = "left",
			texture_size = {
				48,
				48
			},
			offset = {
				244,
				-18,
				4
			}
		},
		help_text = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			word_wrap = true,
			font_size = 24,
			font_type = "hell_shark_header",
			text_color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				var_0_6.container.size[2] + 50,
				4
			}
		},
		enumerator_bg = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			texture_size = {
				20,
				18
			},
			offset = {
				-22,
				-3,
				3
			}
		},
		pet_amount_text = {
			word_wrap = false,
			font_size = 14,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			text_color = {
				255,
				255,
				255,
				160
			},
			size = {
				40,
				18
			},
			offset = {
				248,
				-2,
				5
			}
		},
		pet_amount_text_shadow = {
			word_wrap = false,
			font_size = 14,
			localize = false,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				40,
				18
			},
			offset = {
				250,
				-3,
				4
			}
		}
	}
}
local var_0_8 = {
	scenegraph_id = "skull_pivot",
	offset = {
		0,
		0,
		0
	},
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "icon",
				texture_id = "icon",
				retained_mode = var_0_0
			},
			{
				pass_type = "texture",
				style_id = "icon_glow",
				texture_id = "icon_glow",
				retained_mode = var_0_0,
				content_check_function = function(arg_4_0, arg_4_1)
					return arg_4_1.color[1] > 0
				end
			}
		}
	},
	content = {
		icon_glow = "necromancer_hud_skull_01_eyes",
		icon = "necromancer_hud_skull_01"
	},
	style = {
		icon = {
			offset = {
				0,
				0,
				1
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		icon_glow = {
			offset = {
				0,
				0,
				2
			},
			color = {
				0,
				255,
				255,
				255
			}
		}
	}
}

local function var_0_9(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.offset[1] = 36 * (6 - arg_5_1)
end

local function var_0_10(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = var_0_0 and arg_6_1 or arg_6_0

	for iter_6_0 = 1, #var_6_0 do
		Material.set_scalar(var_6_0[iter_6_0], "progress", arg_6_2)
	end
end

local var_0_11 = {
	change_command_state = {
		{
			name = "spin_half_1",
			delay = 0,
			duration = 0.1,
			init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
				return
			end,
			update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
				var_0_10(arg_8_2.content.materials, arg_8_2.content.retained_materials, arg_8_3 * 0.5)
			end,
			on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
				arg_9_2.content.state_icon = var_0_3[arg_9_3] or "icons_placeholder"
			end
		},
		{
			name = "spin_half_2",
			delay = 0.1,
			duration = 0.1,
			init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
				return
			end,
			update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
				var_0_10(arg_11_2.content.materials, arg_11_2.content.retained_materials, arg_11_3 * 0.5 + 0.5)
			end,
			on_complete = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
				var_0_10(arg_12_2.content.materials, arg_12_2.content.retained_materials, 0)
			end
		}
	},
	spawn_skeleton = {
		{
			name = "dissolve_icon",
			delay = 0,
			duration = 0.2,
			init = function(arg_13_0, arg_13_1, arg_13_2)
				local var_13_0 = arg_13_2.style.icon.color

				var_13_0[1], var_13_0[2], var_13_0[3], var_13_0[4] = 0, 0, 0, 0
			end,
			update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
				local var_14_0 = 255 * arg_14_3
				local var_14_1 = arg_14_2.style.icon.color

				var_14_1[1], var_14_1[2], var_14_1[3], var_14_1[4] = var_14_0, var_14_0, var_14_0, var_14_0
			end,
			on_complete = function(arg_15_0, arg_15_1, arg_15_2)
				return
			end
		}
	},
	fade_in_skull_glow = {
		{
			name = "fade_in_skull_glow",
			delay = 0.2,
			duration = 0.2,
			init = function(arg_16_0, arg_16_1, arg_16_2)
				arg_16_2.style.icon_glow.color[1] = 0
			end,
			update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
				arg_17_2.style.icon_glow.color[1] = 255 * arg_17_3
			end,
			on_complete = function(arg_18_0, arg_18_1, arg_18_2)
				return
			end
		}
	},
	fade_out_skull_glow = {
		{
			name = "fade_out_skull_glow",
			delay = 0.2,
			duration = 0.2,
			init = function(arg_19_0, arg_19_1, arg_19_2)
				arg_19_2.style.icon_glow.color[1] = 255
			end,
			update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
				arg_20_2.style.icon_glow.color[1] = 255 - 255 * arg_20_3
			end,
			on_complete = function(arg_21_0, arg_21_1, arg_21_2)
				return
			end
		}
	}
}

return {
	scenegraph_definition = var_0_6,
	animation_definitions = var_0_11,
	container_widget_definition = var_0_7,
	pet_widget_definition = var_0_8,
	reposition_widget = var_0_9,
	SKULL_TEXTURES = var_0_1,
	SKULL_GLOW_TEXTURES = var_0_2,
	COMMAND_TO_ICON = var_0_3,
	COMMAND_TO_TEXT = var_0_4,
	RETAINED_MODE_ENABLED = var_0_0
}
