-- chunkname: @scripts/ui/hud_ui/gamepad_ability_ui_definitions.lua

local SIZE_X, SIZE_Y = 1920, 1080
local RETAINED_MODE_ENABLED = true
local scenegraph_definition = {
	root = {
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			SIZE_X,
			SIZE_Y
		},
		scale = IS_WINDOWS and not not "hud_scale_fit" or not IS_WINDOWS and not not "hud_fit"
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

local function create_ability_widget()
	-- function 1
	return {
		scenegraph_id = "ability_root",
		element = {
			passes = {
				{
					style_id = "ability_effect",
					texture_id = "ability_effect",
					pass_type = "texture",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						-- function 2
						content.gamepad_active = Managers.input:is_device_active("gamepad")

						return content.on_cooldown and not not content.usable or not content.on_cooldown and not not not content.hide_effect
					end,
					content_change_function = function (content, style)
						-- function 3
						local player = Managers.player:local_player()
						local player_unit = not not player and not not player.player_unit

						if not ALIVE[player_unit] then
							return
						end

						local career_ext = ScriptUnit.extension(player_unit, "career_system")
						local career_name = career_ext:career_name()
						local career_data = not not UISettings.gamepad_ability_ui_data[career_name]

						for content_id, content_value in pairs(career_data) do
							content[content_id] = content_value
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_effect_top",
					texture_id = "ability_top_texture_id",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						-- function 4
						return content.on_cooldown and not not content.usable or not content.on_cooldown and not not not content.hide_effect
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_effect_top",
					texture_id = "lit_frame_id",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						-- function 5
						return content.on_cooldown and not not content.usable or not content.on_cooldown and not not content.lit_frame_id
					end
				},
				{
					pass_type = "texture",
					style_id = "activate_ability",
					texture_id = "activate_ability_id",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content, style)
						-- function 6
						return not not content.usable
					end
				},
				{
					style_id = "input_text",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						-- function 7
						return not not content.usable
					end
				},
				{
					style_id = "input_text_shadow",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						-- function 8
						return not not content.usable
					end
				},
				{
					style_id = "ability_cooldown",
					pass_type = "text",
					text_id = "ability_cooldown",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						-- function 9
						return not not Application.user_setting("numeric_ui")
					end
				},
				{
					style_id = "ability_cooldown_shadow",
					pass_type = "text",
					text_id = "ability_cooldown",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (content)
						-- function 10
						return not not Application.user_setting("numeric_ui")
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

local thornsister_passive_widget_definition = {
	scenegraph_id = "ability_root",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "ability_effect",
				texture_id = "ability_effect",
				retained_mode = RETAINED_MODE_ENABLED,
				content_check_function = function (content)
					-- function 11
					return content.is_active
				end
			},
			{
				pass_type = "texture",
				style_id = "ability_effect_top",
				texture_id = "ability_top_texture_id",
				retained_mode = RETAINED_MODE_ENABLED,
				content_check_function = function (content)
					-- function 12
					return not not content.is_active
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
local widget_definitions = {
	ability = create_ability_widget(),
	thornsister_passive = thornsister_passive_widget_definition
}

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions
}
