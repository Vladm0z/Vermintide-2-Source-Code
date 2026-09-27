-- chunkname: @scripts/ui/hud_ui/gamepad_ability_ui_definitions.lua

local num = 1920
local num_2 = 1080
local flag = true
local tbl = {}
local tbl_2 = {
	position = {
		0,
		0,
		UILayer.hud
	},
	size = {
		num,
		num_2
	}
}
local flag_2

flag_2 = not IS_WINDOWS and "hud_scale_fit" and "hud_fit"
tbl_2.scale = flag_2
tbl.root = tbl_2
tbl.ability_root = {
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
}
tbl.ability_charges = {
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

local function fn()
	-- function 1
	return {
		scenegraph_id = "ability_root",
		element = {
			passes = {
				{
					style_id = "ability_effect",
					texture_id = "ability_effect",
					pass_type = "texture",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 2
						self.gamepad_active = Managers.input:is_device_active("gamepad")

						local usable

						if not self.on_cooldown then
							usable = self.usable

							if not usable then
								-- Nothing
							end
						end

						usable = not self.hide_effect

						::label_2_0::

						return usable
					end,
					content_change_function = function (self, arg_3_1)
						-- function 3
						local local_player = Managers.player:local_player()
						local flag = not local_player and local_player.player_unit

						if not ALIVE[flag] then
							return
						end

						local career_name = ScriptUnit.extension(flag, "career_system"):career_name()
						local var_3_3 = UISettings.gamepad_ability_ui_data[career_name]

						var_3_3 = var_3_3 or UISettings.gamepad_ability_ui_data.default

						for k, v in pairs(var_3_3) do
							self[k] = v
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_effect_top",
					texture_id = "ability_top_texture_id",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 4
						local usable

						if not self.on_cooldown then
							usable = self.usable

							if not usable then
								-- Nothing
							end
						end

						usable = not self.hide_effect

						::label_4_0::

						return usable
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_effect_top",
					texture_id = "lit_frame_id",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 5
						local usable

						if not self.on_cooldown then
							usable = self.usable

							if not usable then
								-- Nothing
							end
						end

						usable = self.lit_frame_id

						::label_5_0::

						return usable
					end
				},
				{
					pass_type = "texture",
					style_id = "activate_ability",
					texture_id = "activate_ability_id",
					retained_mode = flag,
					content_check_function = function (self, arg_6_1)
						-- function 6
						local usable

						if not (not self.on_cooldown and self.always_show_activated_ability_input) then
							usable = self.usable

							if not usable then
								-- Nothing
							end
						end

						usable = self.activate_ability_id
						usable = not usable and self.gamepad_active

						::label_6_0::

						return usable
					end
				},
				{
					style_id = "input_text",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 7
						local usable

						if not (not self.on_cooldown and self.always_show_activated_ability_input or self.usable) then
							usable = self.usable

							if not usable then
								-- Nothing
							end
						end

						usable = not self.gamepad_active

						::label_7_0::

						return usable
					end
				},
				{
					style_id = "input_text_shadow",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 8
						local usable

						if not (not self.on_cooldown and self.always_show_activated_ability_input or self.usable) then
							usable = self.usable

							if not usable then
								-- Nothing
							end
						end

						usable = not self.gamepad_active

						::label_8_0::

						return usable
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

local tbl_3 = {
	scenegraph_id = "ability_root",
	element = {
		passes = {
			{
				pass_type = "texture",
				style_id = "ability_effect",
				texture_id = "ability_effect",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 11
					return self.is_active
				end
			},
			{
				pass_type = "texture",
				style_id = "ability_effect_top",
				texture_id = "ability_top_texture_id",
				retained_mode = flag,
				content_check_function = function (self)
					-- function 12
					local is_active = self.is_active

					is_active = not is_active and not self.hide_top_effect

					return is_active
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
local tbl_4 = {
	ability = fn(),
	thornsister_passive = tbl_3
}

return {
	scenegraph_definition = tbl,
	widget_definitions = tbl_4
}
