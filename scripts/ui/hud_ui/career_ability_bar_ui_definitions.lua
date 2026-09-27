-- chunkname: @scripts/ui/hud_ui/career_ability_bar_ui_definitions.lua

local tbl = {
	250,
	16
}
local tbl_2 = {
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud_inventory
		},
		size = {
			1920,
			1080
		}
	},
	screen = {
		scale = "fit",
		position = {
			0,
			0,
			UILayer.hud_inventory
		},
		size = {
			1920,
			1080
		}
	},
	screen_bottom_pivot = {
		parent = "screen",
		position = {
			0,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	ability_bar = {
		vertical_alignment = "center",
		parent = "screen_bottom_pivot",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			0,
			-200,
			1
		}
	}
}
local frame_outer_glow_01 = UIFrameSettings.frame_outer_glow_01
local var_0_3 = frame_outer_glow_01.texture_sizes.corner[1]
local tbl_3 = {
	ability_bar = {
		scenegraph_id = "ability_bar",
		element = {
			passes = {
				{
					pass_type = "texture_frame",
					style_id = "frame",
					texture_id = "frame"
				},
				{
					pass_type = "texture",
					style_id = "icon",
					texture_id = "icon",
					content_check_function = function (self, arg_1_1)
						-- function 1
						self.gamepad_active = Managers.input:is_device_active("gamepad")

						return self.gamepad_active
					end
				},
				{
					pass_type = "texture",
					style_id = "icon_shadow",
					texture_id = "icon"
				},
				{
					pass_type = "texture",
					style_id = "bar_fg",
					texture_id = "bar_fg"
				},
				{
					pass_type = "rect",
					style_id = "bar_bg"
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "bar_1",
					texture_id = "bar_1"
				},
				{
					style_id = "ability_bar_highlight",
					pass_type = "texture_uv",
					content_id = "ability_bar_highlight"
				},
				{
					style_id = "input_text",
					pass_type = "text",
					text_id = "input_text",
					content_check_function = function (self)
						-- function 2
						return not self.gamepad_active
					end,
					content_change_function = function (self, arg_3_1)
						-- function 3
						local get_keymapping = Managers.input:get_service("Player"):get_keymapping("weapon_reload", "win32")

						if not get_keymapping then
							self.input_text = ""

							return
						end

						local var_3_1 = get_keymapping[1]
						local var_3_2 = get_keymapping[2]
						local str = ""

						if var_3_2 ~= UNASSIGNED_KEY then
							local Mouse

							if var_3_1 == "mouse" then
								Mouse = Mouse

								if not Mouse then
									-- Nothing
								end
							end

							Mouse = Keyboard

							::label_3_0::

							str = Mouse.button_locale_name(var_3_2) or Mouse.button_name(var_3_2) or Localize("lb_unknown")
							str = Utf8.upper(str)
						end

						self.input_text = str
					end
				},
				{
					style_id = "input_text_shadow",
					pass_type = "text",
					text_id = "input_text",
					retained_mode = RETAINED_MODE_ENABLED,
					content_check_function = function (self)
						-- function 4
						return not self.gamepad_active
					end
				}
			}
		},
		content = {
			input_text = "",
			bar_1 = "active_ability_bar",
			icon = "xbone_button_icon_x",
			bar_fg = "overcharge_frame",
			ability_bar_highlight = {
				texture_id = "hud_player_ability_skill_bar_glow",
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
			size = {
				tbl[1] - 6,
				tbl[2]
			},
			frame = frame_outer_glow_01.texture
		},
		style = {
			input_text = {
				word_wrap = false,
				font_size = 24,
				localize = false,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				size = {
					275,
					18
				},
				offset = {
					0,
					-3,
					105
				}
			},
			input_text_shadow = {
				word_wrap = false,
				font_size = 24,
				localize = false,
				horizontal_alignment = "right",
				vertical_alignment = "center",
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				size = {
					275,
					18
				},
				offset = {
					-2,
					-5,
					104
				}
			},
			frame = {
				frame_margins = {
					-(var_0_3 - 1),
					-(var_0_3 - 1)
				},
				texture_size = frame_outer_glow_01.texture_size,
				texture_sizes = frame_outer_glow_01.texture_sizes,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				},
				size = tbl
			},
			bar_1 = {
				gradient_threshold = 0,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					3,
					3,
					3
				},
				size = {
					tbl[1] - 6,
					tbl[2] - 6
				}
			},
			icon = {
				texture_size = {
					34,
					34
				},
				offset = {
					tbl[1] + 5,
					tbl[2] / 2 - 17,
					5
				},
				color = {
					100,
					0,
					0,
					1
				}
			},
			icon_shadow = {
				texture_size = {
					34,
					34
				},
				offset = {
					tbl[1] + 2,
					tbl[2] / 2 - 17 - 2,
					5
				},
				color = {
					0,
					0,
					0,
					0
				}
			},
			bar_fg = {
				offset = {
					0,
					0,
					5
				},
				color = {
					204,
					255,
					255,
					255
				}
			},
			bar_bg = {
				size = {
					tbl[1] - 6,
					tbl[2] - 6
				},
				offset = {
					3,
					3,
					0
				},
				color = {
					100,
					0,
					0,
					0
				}
			},
			ability_bar_highlight = {
				vertical_alignment = "bottom",
				horizontal_alignment = "left",
				texture_size = {
					265,
					50
				},
				color = {
					128,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					3
				}
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
}

return {
	scenegraph_definition = tbl_2,
	widget_definitions = tbl_3
}
