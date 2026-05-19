-- chunkname: @scripts/ui/hud_ui/gamepad_ability_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = true
local var_0_3 = {
	root = {
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			var_0_0,
			var_0_1
		},
		scale = IS_WINDOWS and "hud_scale_fit" or "hud_fit"
	},
	ability_root = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			0,
			60,
			0
		},
		size = {
			0,
			0
		}
	},
	ability_charges = {
		vertical_alignment = "top",
		parent = "ability_root",
		horizontal_alignment = "left",
		position = {
			-134,
			92,
			11
		},
		size = {
			0,
			0
		}
	}
}

local function var_0_4()
	return {
		scenegraph_id = "ability_root",
		element = {
			passes = {
				{
					style_id = "ability_effect",
					texture_id = "ability_effect",
					pass_type = "texture",
					retained_mode = var_0_2,
					content_check_function = function(arg_2_0)
						arg_2_0.gamepad_active = Managers.input:is_device_active("gamepad")

						return (not arg_2_0.on_cooldown or arg_2_0.usable) and not arg_2_0.hide_effect
					end,
					content_change_function = function(arg_3_0, arg_3_1)
						local var_3_0 = Managers.player:local_player()
						local var_3_1 = var_3_0 and var_3_0.player_unit

						if not ALIVE[var_3_1] then
							return
						end

						local var_3_2 = ScriptUnit.extension(var_3_1, "career_system"):career_name()
						local var_3_3 = UISettings.gamepad_ability_ui_data[var_3_2] or UISettings.gamepad_ability_ui_data.default

						for iter_3_0, iter_3_1 in pairs(var_3_3) do
							arg_3_0[iter_3_0] = iter_3_1
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_effect_top",
					texture_id = "ability_top_texture_id",
					retained_mode = var_0_2,
					content_check_function = function(arg_4_0)
						return (not arg_4_0.on_cooldown or arg_4_0.usable) and not arg_4_0.hide_effect
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_effect_top",
					texture_id = "lit_frame_id",
					retained_mode = var_0_2,
					content_check_function = function(arg_5_0)
						return (not arg_5_0.on_cooldown or arg_5_0.usable) and arg_5_0.lit_frame_id
					end
				},
				{
					pass_type = "texture",
					style_id = "activate_ability",
					texture_id = "activate_ability_id",
					retained_mode = var_0_2,
					content_check_function = function(arg_6_0, arg_6_1)
						return (not arg_6_0.on_cooldown or arg_6_0.always_show_activated_ability_input or arg_6_0.usable) and arg_6_0.activate_ability_id and arg_6_0.gamepad_active
					end
				},
				{
					style_id = "input_text",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = var_0_2,
					content_check_function = function(arg_7_0)
						return (not arg_7_0.on_cooldown or arg_7_0.always_show_activated_ability_input or arg_7_0.usable or arg_7_0.usable) and not arg_7_0.gamepad_active
					end
				},
				{
					style_id = "input_text_shadow",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = var_0_2,
					content_check_function = function(arg_8_0)
						return (not arg_8_0.on_cooldown or arg_8_0.always_show_activated_ability_input or arg_8_0.usable or arg_8_0.usable) and not arg_8_0.gamepad_active
					end
				},
				{
					style_id = "ability_cooldown",
					pass_type = "text",
					text_id = "ability_cooldown",
					retained_mode = var_0_2,
					content_check_function = function(arg_9_0)
						return Application.user_setting("numeric_ui") and not arg_9_0.can_use_ability
					end
				},
				{
					style_id = "ability_cooldown_shadow",
					pass_type = "text",
					text_id = "ability_cooldown",
					retained_mode = var_0_2,
					content_check_function = function(arg_10_0)
						return Application.user_setting("numeric_ui") and not arg_10_0.can_use_ability
					end
				}
			}
		},
		content = {
			can_use_ability = false,
			ability_cooldown = "-:-",
			ability_effect = "gamepad_ability_effect_cog",
			input_text = "",
			on_cooldown = true,
			ability_top_texture_id = "icon_rotarygun"
		},
		style = {
			input_text = {
				word_wrap = false,
				font_size = 24,
				localize = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					22,
					18
				},
				offset = {
					-77,
					150,
					110
				}
			},
			input_text_shadow = {
				word_wrap = false,
				font_size = 24,
				localize = false,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					22,
					18
				},
				offset = {
					-75,
					148,
					109
				}
			},
			ability_effect = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					152,
					240
				},
				offset = {
					13,
					-10,
					100
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			ability_effect_top = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					118,
					136
				},
				offset = {
					-3,
					2,
					101
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			activate_ability = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-45,
					140,
					111
				}
			},
			ability_cooldown = {
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				font_size = 22,
				horizontal_alignment = "center",
				text_color = {
					255,
					250,
					250,
					250
				},
				offset = {
					-115,
					148,
					22
				},
				size = {
					100,
					18
				}
			},
			ability_cooldown_shadow = {
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				font_size = 22,
				horizontal_alignment = "center",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-114,
					147,
					21
				},
				size = {
					100,
					18
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

local var_0_5 = {
	scenegraph_id = "ability_root",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "ability_effect",
				texture_id = "ability_effect",
				retained_mode = var_0_2,
				content_check_function = function(arg_11_0)
					return arg_11_0.is_active
				end
			},
			{
				pass_type = "texture",
				style_id = "ability_effect_top",
				texture_id = "ability_top_texture_id",
				retained_mode = var_0_2,
				content_check_function = function(arg_12_0)
					return arg_12_0.is_active and not arg_12_0.hide_top_effect
				end
			}
		}
	},
	content = {
		ability_top_texture_id = "gamepad_ability_effect_top_thornsister",
		ability_effect = "gamepad_ability_effect_thornsister",
		is_active = true
	},
	style = {
		ability_effect = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			texture_size = {
				152,
				240
			},
			offset = {
				13,
				-10,
				103
			},
			color = {
				255,
				255,
				255,
				255
			}
		},
		ability_effect_top = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			texture_size = {
				118,
				136
			},
			offset = {
				-3,
				2,
				104
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
local var_0_6 = {
	ability = var_0_4(),
	thornsister_passive = var_0_5
}

return {
	scenegraph_definition = var_0_3,
	widget_definitions = var_0_6
}
