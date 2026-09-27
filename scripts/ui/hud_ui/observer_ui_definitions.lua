-- chunkname: @scripts/ui/hud_ui/observer_ui_definitions.lua

local flag = true
local tbl = {
	root = {
		is_root = true,
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
	observer_root = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			1,
			1
		},
		position = {
			0,
			115,
			0
		}
	},
	divider = {
		vertical_alignment = "center",
		parent = "observer_root",
		horizontal_alignment = "center",
		size = {
			386,
			22
		},
		position = {
			0,
			0,
			0
		}
	},
	player_name = {
		vertical_alignment = "top",
		parent = "divider",
		horizontal_alignment = "center",
		size = {
			800,
			40
		},
		position = {
			0,
			-18,
			0
		}
	},
	hero_name = {
		vertical_alignment = "bottom",
		parent = "divider",
		horizontal_alignment = "center",
		size = {
			800,
			40
		},
		position = {
			0,
			20,
			0
		}
	},
	hp_bar = {
		vertical_alignment = "top",
		parent = "divider",
		horizontal_alignment = "center",
		position = {
			0,
			-60,
			0
		},
		size = {
			198,
			24
		}
	},
	hp_bar_bg = {
		parent = "hp_bar",
		position = {
			0,
			0,
			2
		},
		size = {
			198,
			24
		}
	},
	hp_bar_fg = {
		parent = "hp_bar_bg",
		position = {
			0,
			0,
			2
		},
		size = {
			198,
			24
		}
	},
	hp_bar_fill = {
		parent = "hp_bar_bg",
		position = {
			10,
			0,
			1
		},
		size = {
			178,
			24
		}
	},
	hp_bar_grimoire_debuff_fill = {
		parent = "hp_bar_bg",
		position = {
			6,
			0,
			4
		},
		size = {
			188,
			24
		}
	},
	hp_bar_shield_fill = {
		parent = "hp_bar_bg",
		position = {
			10,
			0,
			1
		},
		size = {
			178,
			24
		}
	},
	hp_bar_divider = {
		vertical_alignment = "center",
		parent = "hp_bar_fg",
		position = {
			10,
			0,
			1
		},
		size = {
			178,
			14
		}
	},
	hp_bar_max_health_divider = {
		vertical_alignment = "center",
		parent = "hp_bar_grimoire_debuff_fill",
		position = {
			186,
			0,
			5
		},
		size = {
			2,
			24
		}
	},
	hp_bar_grimoire_icon = {
		vertical_alignment = "center",
		parent = "hp_bar_grimoire_debuff_fill",
		position = {
			174,
			0,
			1
		},
		size = {
			24,
			16
		}
	}
}
local tbl_2 = {
	0,
	0,
	0
}
local tbl_3 = {
	divider = UIWidgets.create_simple_texture("summary_screen_line_breaker", "divider", false, flag),
	player_name = UIWidgets.create_simple_text("n/a", "player_name", 28, Colors.get_table("white"), nil, nil, flag),
	hero_name = UIWidgets.create_simple_text("n/a", "hero_name", 24, Colors.get_table("cheeseburger"), nil, nil, flag),
	hp_bar = {
		scenegraph_id = "hp_bar",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "hp_bar_bg",
					texture_id = "hp_bar_bg",
					retained_mode = flag
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_fg",
					texture_id = "hp_bar_fg",
					retained_mode = flag
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_highlight",
					texture_id = "hp_bar_highlight",
					retained_mode = flag
				},
				{
					style_id = "hp_bar",
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					content_id = "hp_bar",
					content_check_function = function (self)
						-- function 1
						return self.draw_health_bar
					end,
					dynamic_function = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
						-- function 2
						local bar_value = self.bar_value
						local is_wounded = self.is_wounded
						local num = 1 - bar_value

						if not is_wounded then
							self.texture_id = self.wounded_texture_id
						else
							self.texture_id = self.normal_texture_id

							local gui = arg_2_4.gui
							local material = Gui.material(gui, self.texture_id)

							if not self.is_knocked_down then
								Material.set_vector2(material, "color_tint_uv", Vector2(1, 0.5))
							else
								Material.set_vector2(material, "color_tint_uv", Vector2(num, 0.5))
							end
						end

						local uv_start_pixels = arg_2_1.uv_start_pixels
						local uv_scale_pixels = arg_2_1.uv_scale_pixels
						local num_2 = uv_start_pixels + uv_scale_pixels * bar_value
						local uvs = arg_2_1.uvs
						local scale_axis = arg_2_1.scale_axis
						local offset_scale = arg_2_1.offset_scale

						uvs[2][scale_axis] = num_2 / (uv_start_pixels + uv_scale_pixels)
						arg_2_2[scale_axis] = num_2

						return arg_2_1.color, uvs, arg_2_2
					end
				},
				{
					style_id = "hp_bar_grimoire_debuff",
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					content_id = "hp_bar_grimoire_debuff",
					dynamic_function = function (self, arg_3_1, arg_3_2, arg_3_3)
						-- function 3
						local bar_value = self.bar_value
						local num = 0
						local color = arg_3_1.color

						color[2] = 255
						color[3] = 255
						color[4] = 255

						local uv_start_pixels = arg_3_1.uv_start_pixels
						local uv_scale_pixels = arg_3_1.uv_scale_pixels
						local num_2 = uv_start_pixels + uv_scale_pixels * bar_value
						local uvs = arg_3_1.uvs
						local scale_axis = arg_3_1.scale_axis
						local offset_scale = arg_3_1.offset_scale
						local var_3_9 = tbl_2

						var_3_9[1] = 0
						var_3_9[2] = 0
						var_3_9[3] = 0
						uvs[2][scale_axis] = num_2 / (uv_start_pixels + uv_scale_pixels)
						arg_3_2[scale_axis] = num_2
						var_3_9[scale_axis] = (uv_start_pixels + uv_scale_pixels - num_2) * offset_scale

						return color, uvs, arg_3_2, var_3_9
					end
				},
				{
					style_id = "hp_bar_shield",
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					content_id = "hp_bar_shield",
					dynamic_function = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
						-- function 4
						local bar_value_position = self.bar_value_position
						local bar_value_offset = self.bar_value_offset
						local bar_value_size = self.bar_value_size
						local uv_start_pixels = arg_4_1.uv_start_pixels
						local uv_scale_pixels = arg_4_1.uv_scale_pixels
						local num = uv_start_pixels + uv_scale_pixels * bar_value_position
						local uvs = arg_4_1.uvs
						local scale_axis = arg_4_1.scale_axis
						local offset_scale = arg_4_1.offset_scale
						local var_4_9 = tbl_2

						var_4_9[1] = 0
						var_4_9[2] = 0
						var_4_9[3] = 0
						uvs[2][scale_axis] = num / (uv_start_pixels + uv_scale_pixels)

						local num_2 = uv_start_pixels + uv_scale_pixels * bar_value_size

						arg_4_2[scale_axis] = num_2

						local num_3 = bar_value_offset * uv_scale_pixels
						local num_4 = uv_scale_pixels - num_2 - num_3

						if num_2 + num < uv_scale_pixels - num_3 then
							num_4 = num
						end

						var_4_9[scale_axis] = num_4

						return arg_4_1.color, uvs, arg_4_2, var_4_9
					end
				},
				{
					pass_type = "centered_texture_amount",
					style_id = "hp_bar_divider",
					texture_id = "hp_bar_divider",
					content_check_function = function (arg_5_0, arg_5_1)
						-- function 5
						return arg_5_1.texture_amount > 0
					end
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_grimoire_icon",
					texture_id = "hp_bar_grimoire_icon",
					content_id = "hp_bar_grimoire_icon",
					retained_mode = flag,
					content_check_function = function (self, arg_6_1)
						-- function 6
						return self.active
					end
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_max_health_divider",
					texture_id = "hp_bar_max_health_divider",
					content_id = "hp_bar_max_health_divider",
					retained_mode = flag,
					content_check_function = function (self, arg_7_1)
						-- function 7
						return self.active
					end
				}
			}
		},
		content = {
			hp_bar_bg = "player_hp_bar_bg",
			hp_bar_highlight = "player_hp_bar_highlight",
			hp_bar_divider = "player_hp_bar_divider",
			hp_bar_fg = "player_hp_bar_fg",
			hp_bar = {
				low_health = false,
				wounded_texture_id = "player_hp_bar",
				texture_id = "player_hp_bar",
				draw_health_bar = true,
				bar_value = 1,
				is_knocked_down = false,
				is_wounded = false,
				normal_texture_id = "player_hp_bar_color_tint"
			},
			hp_bar_grimoire_debuff = {
				texture_id = "player_hp_bar_overlay",
				bar_value = 0
			},
			hp_bar_shield = {
				texture_id = "player_hp_bar",
				bar_value_offset = 0,
				bar_value_position = 0,
				bar_value_size = 0
			},
			hp_bar_grimoire_icon = {
				hp_bar_grimoire_icon = "grimoire_icon",
				active = false
			},
			hp_bar_max_health_divider = {
				hp_bar_max_health_divider = "max_health_divider",
				active = false
			}
		},
		style = {
			hp_bar_fg = {
				scenegraph_id = "hp_bar_fg"
			},
			hp_bar_bg = {
				scenegraph_id = "hp_bar_bg"
			},
			hp_bar = {
				uv_start_pixels = 0,
				scenegraph_id = "hp_bar_fill",
				uv_scale_pixels = 178,
				offset_scale = 1,
				scale_axis = 1,
				color = {
					255,
					255,
					255,
					255
				},
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				},
				offset = {
					0,
					0,
					0
				}
			},
			hp_bar_grimoire_debuff = {
				uv_start_pixels = 0,
				scenegraph_id = "hp_bar_grimoire_debuff_fill",
				uv_scale_pixels = 188,
				offset_scale = 1,
				scale_axis = 1,
				color = {
					255,
					0,
					0,
					0
				},
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				},
				offset = {
					0,
					0,
					0
				}
			},
			hp_bar_shield = {
				uv_start_pixels = 0,
				scenegraph_id = "hp_bar_shield_fill",
				uv_scale_pixels = 178,
				offset_scale = 1,
				scale_axis = 1,
				color = {
					255,
					0,
					166,
					255
				},
				uvs = {
					{
						0,
						0
					},
					{
						1,
						1
					}
				},
				offset = {
					0,
					0,
					0
				}
			},
			hp_bar_divider = {
				texture_axis = 1,
				scenegraph_id = "hp_bar_divider",
				texture_amount = 9,
				texture_size = {
					4,
					14
				}
			},
			hp_bar_grimoire_icon = {
				scenegraph_id = "hp_bar_grimoire_icon",
				offset = {
					0,
					0,
					0
				}
			},
			hp_bar_max_health_divider = {
				scenegraph_id = "hp_bar_max_health_divider",
				offset = {
					0,
					0,
					0
				}
			},
			hp_bar_highlight = {
				scenegraph_id = "hp_bar_fg",
				color = {
					0,
					255,
					255,
					255
				}
			}
		}
	}
}

return {
	scenegraph_definition = tbl,
	widget_definitions = tbl_3
}
