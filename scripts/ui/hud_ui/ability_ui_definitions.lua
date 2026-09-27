-- chunkname: @scripts/ui/hud_ui/ability_ui_definitions.lua

local num = 1920
local num_2 = 1080
local flag = true
local tbl = {
	screen = {
		scale = "hud_scale_fit",
		position = {
			0,
			0,
			UILayer.hud
		},
		size = {
			num,
			num_2
		}
	},
	ability_root = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			10
		},
		size = {
			624,
			66
		}
	},
	ability_charges = {
		vertical_alignment = "center",
		parent = "ability_root",
		horizontal_alignment = "right",
		position = {
			-10,
			-10,
			11
		},
		size = {
			0,
			0
		}
	}
}
local tbl_2 = {
	scenegraph_id = "ability_root",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "ability_effect_right",
				texture_id = "texture_id",
				content_id = "ability_effect",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 1
					return self.parent.can_use
				end
			},
			{
				pass_type = "texture",
				style_id = "ability_effect_top_right",
				texture_id = "texture_id",
				content_id = "ability_effect_top",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 2
					return self.parent.can_use
				end
			},
			{
				style_id = "ability_effect_left",
				pass_type = "texture_uv",
				content_id = "ability_effect",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 3
					return self.parent.can_use
				end
			},
			{
				style_id = "ability_effect_top_left",
				pass_type = "texture_uv",
				content_id = "ability_effect_top",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 4
					return self.parent.can_use
				end
			},
			{
				pass_type = "texture",
				style_id = "ability_bar_highlight",
				texture_id = "ability_bar_highlight",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 5
					return not self.on_cooldown
				end
			},
			{
				style_id = "input_text",
				pass_type = "text",
				text_id = "input_text",
				retained_mode = flag,
				content_check_function = function (arg_6_0, arg_6_1)
					-- function 6
					return not Managers.input:is_device_active("gamepad")
				end
			},
			{
				style_id = "input_text_shadow",
				pass_type = "text",
				text_id = "input_text",
				retained_mode = flag,
				content_check_function = function (arg_7_0, arg_7_1)
					-- function 7
					return not Managers.input:is_device_active("gamepad")
				end
			},
			{
				style_id = "input_text_gamepad",
				pass_type = "text",
				text_id = "input_text_gamepad",
				retained_mode = flag,
				content_check_function = function (arg_8_0, arg_8_1)
					-- function 8
					return Managers.input:is_device_active("gamepad")
				end
			},
			{
				style_id = "ability_cooldown",
				pass_type = "text",
				text_id = "ability_cooldown",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 9
					local user_setting = Application.user_setting("numeric_ui")

					user_setting = not user_setting and not self.can_use_ability

					return user_setting
				end
			},
			{
				style_id = "ability_cooldown_shadow",
				pass_type = "text",
				text_id = "ability_cooldown",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 10
					local user_setting = Application.user_setting("numeric_ui")

					user_setting = not user_setting and not self.can_use_ability

					return user_setting
				end
			}
		}
	},
	content = {
		input_text_gamepad = "$KEY;Player__ability:",
		ability_bar_highlight = "hud_player_ability_bar_glow",
		can_use_ability = false,
		input_text = "",
		on_cooldown = false,
		ability_cooldown = "-:-",
		can_use = false,
		ability_effect = {
			texture_id = "ability_effect",
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
		ability_effect_top = {
			texture_id = "ability_effect_top",
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
		}
	},
	style = {
		input_text = {
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = 16,
			horizontal_alignment = "center",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			size = {
				22,
				18
			},
			offset = {
				38,
				78,
				2
			}
		},
		input_text_shadow = {
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = 16,
			horizontal_alignment = "center",
			text_color = Colors.get_color_table_with_alpha("black", 255),
			size = {
				22,
				18
			},
			offset = {
				40,
				76,
				1
			}
		},
		input_text_gamepad = {
			vertical_alignment = "center",
			font_type = "hell_shark",
			font_size = 28,
			horizontal_alignment = "left",
			text_color = Colors.get_color_table_with_alpha("white", 255),
			offset = {
				38,
				78,
				2
			}
		},
		ability_effect_right = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			texture_size = {
				110,
				170
			},
			offset = {
				0,
				-2,
				0
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		ability_effect_top_right = {
			vertical_alignment = "bottom",
			horizontal_alignment = "right",
			texture_size = {
				110,
				170
			},
			offset = {
				0,
				-2,
				1
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		ability_effect_left = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				110,
				170
			},
			offset = {
				-9,
				-2,
				0
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		ability_effect_top_left = {
			vertical_alignment = "bottom",
			horizontal_alignment = "left",
			texture_size = {
				110,
				170
			},
			offset = {
				-9,
				-2,
				1
			},
			color = {
				0,
				255,
				255,
				255
			}
		},
		ability_bar_highlight = {
			vertical_alignment = "bottom",
			horizontal_alignment = "center",
			texture_size = {
				488,
				70
			},
			color = {
				0,
				255,
				255,
				255
			},
			offset = {
				0,
				22,
				2
			}
		},
		ability_cooldown = {
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			font_size = 18,
			horizontal_alignment = "center",
			text_color = {
				255,
				250,
				250,
				250
			},
			offset = {
				524,
				90,
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
			font_size = 18,
			horizontal_alignment = "center",
			text_color = {
				255,
				0,
				0,
				0
			},
			offset = {
				525,
				87,
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
local tbl_3 = {
	ability = tbl_2,
	thornsister_passive = thornsister_passive_widget_definition
}

return {
	scenegraph_definition = tbl,
	widget_definitions = tbl_3
}
