-- chunkname: @scripts/ui/hud_ui/observer_ui_definitions.lua

local var_0_0 = true
local var_0_1 = {
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
local var_0_2 = {
	0,
	0,
	0
}
local var_0_3 = {
	divider = UIWidgets.create_simple_texture("summary_screen_line_breaker", "divider", false, var_0_0),
	player_name = UIWidgets.create_simple_text("n/a", "player_name", 28, Colors.get_table("white"), nil, nil, var_0_0),
	hero_name = UIWidgets.create_simple_text("n/a", "hero_name", 24, Colors.get_table("cheeseburger"), nil, nil, var_0_0),
	hp_bar = {
		scenegraph_id = "hp_bar",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "hp_bar_bg",
					texture_id = "hp_bar_bg",
					retained_mode = var_0_0
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_fg",
					texture_id = "hp_bar_fg",
					retained_mode = var_0_0
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_highlight",
					texture_id = "hp_bar_highlight",
					retained_mode = var_0_0
				},
				{
					style_id = "hp_bar",
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					content_id = "hp_bar",
					content_check_function = function(arg_1_0)
						return arg_1_0.draw_health_bar
					end,
					dynamic_function = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
						local var_2_0 = arg_2_0.bar_value
						local var_2_1 = arg_2_0.is_wounded
						local var_2_2 = 1 - var_2_0

						if var_2_1 then
							arg_2_0.texture_id = arg_2_0.wounded_texture_id
						else
							arg_2_0.texture_id = arg_2_0.normal_texture_id

							local var_2_3 = arg_2_4.gui
							local var_2_4 = Gui.material(var_2_3, arg_2_0.texture_id)

							if arg_2_0.is_knocked_down then
								Material.set_vector2(var_2_4, "color_tint_uv", Vector2(1, 0.5))
							else
								Material.set_vector2(var_2_4, "color_tint_uv", Vector2(var_2_2, 0.5))
							end
						end

						local var_2_5 = arg_2_1.uv_start_pixels
						local var_2_6 = arg_2_1.uv_scale_pixels
						local var_2_7 = var_2_5 + var_2_6 * var_2_0
						local var_2_8 = arg_2_1.uvs
						local var_2_9 = arg_2_1.scale_axis
						local var_2_10 = arg_2_1.offset_scale

						var_2_8[2][var_2_9] = var_2_7 / (var_2_5 + var_2_6)
						arg_2_2[var_2_9] = var_2_7

						return arg_2_1.color, var_2_8, arg_2_2
					end
				},
				{
					style_id = "hp_bar_grimoire_debuff",
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					content_id = "hp_bar_grimoire_debuff",
					dynamic_function = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
						local var_3_0 = arg_3_0.bar_value
						local var_3_1 = 0
						local var_3_2 = arg_3_1.color

						var_3_2[2] = 255
						var_3_2[3] = 255
						var_3_2[4] = 255

						local var_3_3 = arg_3_1.uv_start_pixels
						local var_3_4 = arg_3_1.uv_scale_pixels
						local var_3_5 = var_3_3 + var_3_4 * var_3_0
						local var_3_6 = arg_3_1.uvs
						local var_3_7 = arg_3_1.scale_axis
						local var_3_8 = arg_3_1.offset_scale
						local var_3_9 = var_0_2

						var_3_9[1] = 0
						var_3_9[2] = 0
						var_3_9[3] = 0
						var_3_6[2][var_3_7] = var_3_5 / (var_3_3 + var_3_4)
						arg_3_2[var_3_7] = var_3_5
						var_3_9[var_3_7] = (var_3_3 + var_3_4 - var_3_5) * var_3_8

						return var_3_2, var_3_6, arg_3_2, var_3_9
					end
				},
				{
					style_id = "hp_bar_shield",
					pass_type = "texture_uv_dynamic_color_uvs_size_offset",
					content_id = "hp_bar_shield",
					dynamic_function = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
						local var_4_0 = arg_4_0.bar_value_position
						local var_4_1 = arg_4_0.bar_value_offset
						local var_4_2 = arg_4_0.bar_value_size
						local var_4_3 = arg_4_1.uv_start_pixels
						local var_4_4 = arg_4_1.uv_scale_pixels
						local var_4_5 = var_4_3 + var_4_4 * var_4_0
						local var_4_6 = arg_4_1.uvs
						local var_4_7 = arg_4_1.scale_axis
						local var_4_8 = arg_4_1.offset_scale
						local var_4_9 = var_0_2

						var_4_9[1] = 0
						var_4_9[2] = 0
						var_4_9[3] = 0
						var_4_6[2][var_4_7] = var_4_5 / (var_4_3 + var_4_4)

						local var_4_10 = var_4_3 + var_4_4 * var_4_2

						arg_4_2[var_4_7] = var_4_10

						local var_4_11 = var_4_1 * var_4_4
						local var_4_12 = var_4_4 - var_4_10 - var_4_11

						if var_4_10 + var_4_5 < var_4_4 - var_4_11 then
							var_4_12 = var_4_5
						end

						var_4_9[var_4_7] = var_4_12

						return arg_4_1.color, var_4_6, arg_4_2, var_4_9
					end
				},
				{
					pass_type = "centered_texture_amount",
					style_id = "hp_bar_divider",
					texture_id = "hp_bar_divider",
					content_check_function = function(arg_5_0, arg_5_1)
						return arg_5_1.texture_amount > 0
					end
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_grimoire_icon",
					texture_id = "hp_bar_grimoire_icon",
					content_id = "hp_bar_grimoire_icon",
					retained_mode = var_0_0,
					content_check_function = function(arg_6_0, arg_6_1)
						return arg_6_0.active
					end
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_max_health_divider",
					texture_id = "hp_bar_max_health_divider",
					content_id = "hp_bar_max_health_divider",
					retained_mode = var_0_0,
					content_check_function = function(arg_7_0, arg_7_1)
						return arg_7_0.active
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
	scenegraph_definition = var_0_1,
	widget_definitions = var_0_3
}
