-- chunkname: @scripts/ui/hud_ui/dark_pact_ability_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = false
local var_0_3 = {
	screen = {
		scale = "hud_scale_fit",
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
	ability_root = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			-90,
			300,
			10
		},
		size = {
			1,
			1
		}
	},
	horde_ability_root = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			-360,
			40,
			10
		},
		size = {
			1,
			1
		}
	},
	crosshair_root = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			10
		},
		size = {
			1,
			1
		}
	},
	bottom_root = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			10
		},
		size = {
			1,
			1
		}
	},
	ability_pivot = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "center",
		position = {
			0,
			40,
			10
		},
		size = {
			1,
			1
		}
	},
	ammo_parent = {
		vertical_alignment = "bottom",
		parent = "screen",
		horizontal_alignment = "right",
		position = {
			-50,
			140,
			10
		},
		size = {
			383,
			86
		}
	}
}
local var_0_4 = {
	abilities_detail_left = UIWidgets.create_simple_texture("health_bar_addon", "ability_pivot", nil, nil, {
		255,
		255,
		255,
		255
	}, nil, {
		88,
		68
	}),
	abilities_detail_right = UIWidgets.create_simple_uv_texture("health_bar_addon", {
		{
			1,
			0
		},
		{
			0,
			1
		}
	}, "ability_pivot", nil, nil, {
		255,
		255,
		255,
		255
	}, nil, false, {
		88,
		68
	})
}

local function var_0_5()
	return {
		scenegraph_id = "crosshair_root",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background",
					content_check_function = function(arg_2_0)
						return arg_2_0.progress > 0
					end
				},
				{
					style_id = "progress_1",
					pass_type = "texture_uv",
					content_id = "progress_1",
					content_check_function = function(arg_3_0)
						return arg_3_0.parent.progress > 0
					end,
					content_change_function = function(arg_4_0, arg_4_1)
						arg_4_0.uvs = {
							{
								0,
								1 - arg_4_0.parent.progress
							},
							{
								1,
								1
							}
						}
						arg_4_1.texture_size[2] = 84 * arg_4_0.parent.progress
					end
				},
				{
					style_id = "progress_2",
					pass_type = "texture_uv",
					content_id = "progress_2",
					content_check_function = function(arg_5_0)
						return arg_5_0.parent.progress > 0
					end,
					content_change_function = function(arg_6_0, arg_6_1)
						arg_6_0.uvs = {
							{
								0,
								1 - arg_6_0.parent.progress
							},
							{
								1,
								1
							}
						}
						arg_6_1.texture_size[2] = 84 * arg_6_0.parent.progress
					end
				},
				{
					style_id = "progress_3",
					pass_type = "texture_uv",
					content_id = "progress_3",
					content_check_function = function(arg_7_0)
						return arg_7_0.parent.progress > 0
					end,
					content_change_function = function(arg_8_0, arg_8_1)
						arg_8_0.uvs = {
							{
								0,
								1 - arg_8_0.parent.progress
							},
							{
								1,
								1
							}
						}
						arg_8_1.texture_size[2] = 84 * arg_8_0.parent.progress
					end
				}
			}
		},
		content = {
			background = "pounce_background",
			progress = 0,
			progress_1 = {
				texture_id = "pounce_01",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			},
			progress_2 = {
				texture_id = "pounce_02",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			},
			progress_3 = {
				texture_id = "pounce_03",
				uvs = {
					{
						0,
						1
					},
					{
						1,
						0
					}
				}
			}
		},
		style = {
			background = {
				texture_size = {
					108,
					100
				},
				offset = {
					-54,
					-110,
					1
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			progress_1 = {
				texture_size = {
					108,
					84
				},
				offset = {
					-54,
					-110,
					2
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			progress_2 = {
				texture_size = {
					108,
					84
				},
				offset = {
					-54,
					-110,
					3
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			progress_3 = {
				texture_size = {
					108,
					84
				},
				offset = {
					-54,
					-110,
					4
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			}
		},
		offset = {
			0,
			0,
			0
		}
	}
end

local function var_0_6()
	return {
		scenegraph_id = "crosshair_root",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "cooldown_mask",
					texture_id = "cooldown_mask"
				},
				{
					style_id = "cooldown",
					pass_type = "texture_uv",
					content_id = "cooldown"
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background",
					retained_mode = var_0_2,
					content_check_function = function(arg_10_0)
						return arg_10_0.progress > 0
					end
				},
				{
					pass_type = "texture",
					style_id = "ring",
					texture_id = "ring",
					retained_mode = var_0_2,
					content_check_function = function(arg_11_0)
						return arg_11_0.progress > 0
					end
				}
			}
		},
		content = {
			ring = "versus_crosshair_crosshair_ring",
			background = "versus_crosshair_crosshair_bg",
			progress = 0,
			cooldown_mask = "hud_ability_cooldown_mask",
			cooldown = {
				texture_id = "versus_crosshair_crosshair_fill",
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
			ring = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					80,
					80
				},
				offset = {
					0,
					0,
					2
				},
				color = Colors.get_color_table_with_alpha("black", 0)
			},
			background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					80,
					80
				},
				offset = {
					0,
					0,
					0
				},
				color = Colors.get_color_table_with_alpha("white", 0)
			},
			cooldown = {
				vertical_alignment = "center",
				masked = true,
				horizontal_alignment = "center",
				default_size = {
					80,
					80
				},
				texture_size = {
					80,
					80
				},
				color = Colors.get_color_table_with_alpha("pactsworn_green", 0),
				offset = {
					0,
					0,
					1
				}
			},
			cooldown_mask = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				default_size = {
					80,
					80
				},
				texture_size = {
					80,
					80
				},
				color = Colors.get_color_table_with_alpha("black", 0),
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
end

local function var_0_7()
	return {
		scenegraph_id = "crosshair_root",
		element = {
			passes = {
				{
					style_id = "cooldown",
					pass_type = "texture_uv",
					content_id = "cooldown",
					retained_mode = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background",
					retained_mode = var_0_2
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					retained_mode = var_0_2
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					retained_mode = var_0_2
				}
			}
		},
		content = {
			text = "",
			background = "circular_bar_background",
			progress = 0,
			on_cooldown = false,
			cooldown = {
				texture_id = "circular_bar_fill",
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
			background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					250,
					70
				},
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			cooldown = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				default_size = {
					250,
					70
				},
				texture_size = {
					250,
					70
				},
				color = Colors.get_color_table_with_alpha("pactsworn_green", 255),
				offset = {
					-125,
					0,
					1
				}
			},
			text = {
				vertical_alignment = "center",
				font_size = 24,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = {
					255,
					255,
					255,
					255
				},
				size = {
					500,
					30
				},
				offset = {
					-250,
					16,
					1
				}
			},
			text_shadow = {
				vertical_alignment = "center",
				font_size = 24,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "hell_shark",
				text_color = {
					255,
					0,
					0,
					0
				},
				size = {
					500,
					30
				},
				offset = {
					-249,
					15,
					0
				}
			}
		},
		offset = {
			0,
			-140,
			0
		}
	}
end

local function var_0_8()
	return {
		scenegraph_id = "bottom_root",
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "rect",
					retained_mode = var_0_2
				},
				{
					style_id = "progress",
					pass_type = "rect",
					retained_mode = var_0_2
				}
			}
		},
		content = {
			progress = 0
		},
		style = {
			background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					501,
					20
				},
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					0,
					0,
					0
				}
			},
			progress = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				default_size = {
					496,
					16
				},
				texture_size = {
					496,
					16
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-248,
					0,
					1
				}
			}
		},
		offset = {
			0,
			80,
			0
		}
	}
end

local function var_0_9()
	return {
		scenegraph_id = "horde_ability_root",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background"
				},
				{
					pass_type = "texture",
					style_id = "ability_progress",
					texture_id = "ability_progress"
				},
				{
					pass_type = "texture",
					style_id = "ability_effect",
					texture_id = "ability_effect",
					content_check_function = function(arg_15_0)
						return arg_15_0.ready
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_effect_top",
					texture_id = "ability_effect_top",
					content_check_function = function(arg_16_0)
						return arg_16_0.ready
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_effect_halo",
					texture_id = "ability_effect_halo",
					content_check_function = function(arg_17_0)
						return arg_17_0.ready
					end
				},
				{
					style_id = "input_text",
					pass_type = "text",
					text_id = "input_text"
				},
				{
					pass_type = "texture",
					style_id = "input_background",
					texture_id = "input_background"
				}
			}
		},
		content = {
			ability_effect_top = "dark_pact_ability_effect_top",
			ability_progress = "dark_pact_ability_progress_bar",
			background = "horde_bar_background",
			ready = false,
			ability_effect = "dark_pact_ability_effect",
			input_background = "info_window_background",
			input_text = "-",
			ability_effect_halo = "dark_pact_ability_effect_halo"
		},
		style = {
			background = {
				size = {
					356,
					160
				},
				offset = {
					0,
					0,
					1
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			ability_progress = {
				gradient_threshold = 0,
				size = {
					262,
					16
				},
				offset = {
					10,
					72,
					2
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			ability_effect = {
				size = {
					152,
					180
				},
				offset = {
					223,
					-15,
					3
				},
				color = Colors.get_color_table_with_alpha("pactsworn_red", 255)
			},
			ability_effect_top = {
				size = {
					152,
					180
				},
				offset = {
					223,
					-15,
					4
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			ability_effect_halo = {
				size = {
					356,
					160
				},
				offset = {
					0,
					0,
					2
				},
				color = Colors.get_color_table_with_alpha("white", 255)
			},
			input_text = {
				word_wrap = false,
				use_shadow = false,
				localize = false,
				font_size = 30,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				font_type = "hell_shark",
				size = {
					30,
					30
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					284,
					162,
					2
				}
			},
			input_background = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					110,
					30
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					301,
					180,
					0
				}
			}
		},
		offset = {
			0,
			0,
			10
		}
	}
end

local function var_0_10()
	return {
		scenegraph_id = "ammo_parent",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "ammo_background",
					texture_id = "ammo_background"
				},
				{
					style_id = "current_ammo",
					pass_type = "text",
					text_id = "current_ammo"
				},
				{
					style_id = "ammo_divider",
					pass_type = "text",
					text_id = "ammo_divider"
				},
				{
					style_id = "remaining_ammo",
					pass_type = "text",
					text_id = "remaining_ammo"
				}
			}
		},
		content = {
			ammo_divider = "/",
			ammo_background = "loot_objective_bg",
			current_ammo = "-",
			remaining_ammo = "-"
		},
		style = {
			ammo_background = {
				color = {
					200,
					255,
					255,
					255
				}
			},
			current_ammo = {
				font_size = 72,
				use_shadow = true,
				localize = false,
				word_wrap = false,
				horizontal_alignment = "right",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				size = {
					20,
					20
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				default_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					161.5,
					-8,
					10
				}
			},
			ammo_divider = {
				word_wrap = false,
				font_size = 40,
				localize = false,
				use_shadow = true,
				horizontal_alignment = "center",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				default_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					0,
					10
				}
			},
			remaining_ammo = {
				font_size = 40,
				use_shadow = true,
				localize = false,
				word_wrap = false,
				horizontal_alignment = "left",
				vertical_alignment = "bottom",
				font_type = "hell_shark_header",
				size = {
					20,
					20
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				default_text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					204.5,
					0,
					10
				}
			}
		},
		offset = {
			0,
			0,
			1
		}
	}
end

local var_0_11 = {
	packmaster_reload = {
		definition = var_0_7(),
		update_function = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
			local var_19_0, var_19_1 = arg_19_3:current_ability_cooldown(arg_19_4)
			local var_19_2 = arg_19_3:uses_cooldown(arg_19_4)
			local var_19_3 = arg_19_3:ability_by_id(arg_19_4)
			local var_19_4 = var_19_3:ability_available()
			local var_19_5 = var_19_3:startup_delay_time()
			local var_19_6
			local var_19_7 = false

			if var_19_4 then
				var_19_6 = var_19_3:startup_delay_fraction()
				var_19_7 = var_19_6 ~= nil
			end

			local var_19_8 = arg_19_5.content
			local var_19_9 = arg_19_5.style

			var_19_8.visible = var_19_7

			if var_19_6 then
				local var_19_10 = var_19_9.cooldown.default_size
				local var_19_11 = var_19_9.cooldown.texture_size

				var_19_8.cooldown.uvs[2][1] = var_19_6
				var_19_11[1] = var_19_10[1] * var_19_6
			end

			UIRenderer.draw_widget(arg_19_2, arg_19_5)
		end
	},
	ratling_gunner_reload = {
		definition = var_0_7(),
		update_function = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7)
			if arg_20_6 then
				return
			end

			local var_20_0 = arg_20_5.content
			local var_20_1 = ScriptUnit.extension(arg_20_7, "inventory_system"):get_weapon_unit()
			local var_20_2 = ScriptUnit.extension(var_20_1, "weapon_system"):get_custom_data("reload_progress")

			var_20_0.visible = var_20_2 > 0

			if not var_20_0.visible then
				return
			end

			local var_20_3 = arg_20_5.style
			local var_20_4 = 1 - var_20_2

			if var_20_4 then
				local var_20_5 = var_20_3.cooldown.default_size
				local var_20_6 = var_20_3.cooldown.texture_size
				local var_20_7 = math.remap(0, 1, 0.05, 0.95, var_20_4)

				var_20_0.cooldown.uvs[2][1] = var_20_7
				var_20_6[1] = var_20_5[1] * var_20_7
			end

			UIRenderer.draw_widget(arg_20_2, arg_20_5)
		end
	},
	reload = {
		definition = var_0_7(),
		update_function = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
			if arg_21_6 then
				return
			end

			local var_21_0, var_21_1 = arg_21_3:current_ability_cooldown(arg_21_4)
			local var_21_2 = arg_21_3:uses_cooldown(arg_21_4)
			local var_21_3, var_21_4 = arg_21_3:get_extra_ability_uses()
			local var_21_5 = 1 + var_21_4
			local var_21_6 = var_21_3

			if var_21_0 <= 0 then
				var_21_6 = var_21_6 + 1

				if var_21_4 > 0 then
					local var_21_7

					var_21_0, var_21_7 = arg_21_3:get_extra_ability_charge()
					var_21_0 = var_21_7 - var_21_0
				end
			end

			local var_21_8 = false
			local var_21_9 = arg_21_5.content
			local var_21_10 = arg_21_5.style
			local var_21_11 = var_21_9.ability_cooldown or 0
			local var_21_12 = 0

			if var_21_2 then
				if var_21_0 < var_21_11 then
					var_21_8 = true
					var_21_12 = var_21_0 / var_21_11
				else
					var_21_9.ability_cooldown = var_21_0
				end

				if not var_21_0 or var_21_0 <= 0 then
					var_21_9.ability_cooldown = 0
				end
			end

			local var_21_13 = var_21_10.cooldown.default_size
			local var_21_14 = var_21_10.cooldown.texture_size

			var_21_9.cooldown.uvs[2][1] = var_21_12
			var_21_14[1] = var_21_13[1] * var_21_12
			var_21_9.visible = var_21_8

			if var_21_5 > 1 then
				local var_21_15 = var_21_9.orig_text

				if not var_21_15 then
					var_21_9.orig_text = var_21_9.text
				end

				var_21_9.text = string.format("%s (%d/%d)", var_21_15, var_21_6, var_21_5)
			end

			UIRenderer.draw_widget(arg_21_2, arg_21_5)
		end
	},
	priming = {
		definition = var_0_5(),
		update_function = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
			if arg_22_6 then
				return
			end

			local var_22_0, var_22_1 = arg_22_3:current_ability_cooldown(arg_22_4)
			local var_22_2 = arg_22_3:get_activated_ability_data(arg_22_4)
			local var_22_3 = arg_22_3:uses_cooldown(arg_22_4)
			local var_22_4 = var_22_2.priming_progress or 0
			local var_22_5 = arg_22_5.content
			local var_22_6 = arg_22_5.style
			local var_22_7 = var_22_5.ability_cooldown or 0

			var_22_5.progress = var_22_4

			if var_22_3 and var_22_7 <= var_22_0 then
				var_22_5.ability_cooldown = var_22_0
			end

			if not var_22_0 or var_22_0 <= 0 then
				var_22_5.ability_cooldown = 0
			end

			UIRenderer.draw_widget(arg_22_2, arg_22_5)
		end
	},
	recharge = {
		definition = var_0_6(),
		update_function = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
			if arg_23_6 then
				return
			end

			local var_23_0, var_23_1 = arg_23_3:current_ability_cooldown(arg_23_4)
			local var_23_2 = arg_23_3:can_use_activated_ability(arg_23_4)
			local var_23_3 = arg_23_3:uses_cooldown(arg_23_4)
			local var_23_4 = 0

			if var_23_3 then
				var_23_4 = var_23_0 / var_23_1
			else
				var_23_4 = var_23_2 and 0 or 1
			end

			local var_23_5 = arg_23_5.content
			local var_23_6

			var_23_6 = var_23_4 ~= var_23_5.current_cooldown_fraction

			local var_23_7 = var_23_4 ~= 0

			arg_23_5.style.cooldown_mask.color[1] = 255 * var_23_4
			var_23_5.on_cooldown = var_23_7
			var_23_5.progress = var_23_4

			UIRenderer.draw_widget(arg_23_2, arg_23_5)
		end
	},
	throw_charge = {
		definition = var_0_6(),
		update_function = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
			if arg_24_6 then
				return
			end

			local var_24_0, var_24_1 = arg_24_3:current_ability_cooldown(arg_24_4)
			local var_24_2 = arg_24_3:get_activated_ability_data(arg_24_4)
			local var_24_3 = arg_24_3:uses_cooldown(arg_24_4)
			local var_24_4 = var_24_2.priming_progress or 0
			local var_24_5 = arg_24_5.content
			local var_24_6 = arg_24_5.style
			local var_24_7 = var_24_4 > (var_24_5.progress or 0)

			var_24_6.cooldown_mask.color[1] = var_24_7 and 255 * var_24_4 or 0

			local var_24_8 = var_24_5.ability_cooldown or 0

			var_24_5.visible = var_24_4 > 0 and var_24_4 < 1
			var_24_5.progress = var_24_4

			if var_24_3 and var_24_8 <= var_24_0 then
				var_24_5.ability_cooldown = var_24_0
			end

			if not var_24_0 or var_24_0 <= 0 then
				var_24_5.ability_cooldown = 0
			end

			UIRenderer.draw_widget(arg_24_2, arg_24_5)
		end
	},
	ammo = {
		definition = var_0_10(),
		update_function = function(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6)
			UIRenderer.draw_widget(arg_25_2, arg_25_5)
		end
	},
	duration = {
		definition = var_0_8(),
		update_function = function(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6)
			if not arg_26_3:get_activated_ability_data(arg_26_4).duration_progress then
				local var_26_0 = 0
			end

			local var_26_1 = "vs_gutter_runner_smoke_bomb_invisible"
			local var_26_2 = Managers.player:local_player(1).player_unit

			if not Unit.alive(var_26_2) then
				return
			end

			local var_26_3 = ScriptUnit.extension(var_26_2, "buff_system"):get_non_stacking_buff(var_26_1)

			if not var_26_3 then
				return
			end

			local var_26_4 = var_26_3.duration
			local var_26_5 = var_26_3.start_time
			local var_26_6 = Managers.time:time("game")
			local var_26_7 = var_26_4 and var_26_5 + var_26_4 or 0
			local var_26_8 = var_26_7 and math.max(var_26_7 - var_26_6, 0)
			local var_26_9 = arg_26_5.style
			local var_26_10 = var_26_9.progress.default_size
			local var_26_11 = var_26_9.progress.texture_size
			local var_26_12 = var_26_8 / var_26_4

			var_26_11[1] = var_26_10[1] * var_26_12

			UIRenderer.draw_widget(arg_26_2, arg_26_5)
		end
	},
	ability = {
		definition = var_0_9(),
		update_function = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7, arg_27_8)
			if arg_27_6 then
				return
			end

			local var_27_0 = arg_27_8:cooldown()
			local var_27_1 = Managers.time:time("game")
			local var_27_2 = arg_27_8:get_ability_charge(var_27_1)
			local var_27_3 = math.clamp(var_27_0 - var_27_2, 0, var_27_0)
			local var_27_4 = arg_27_5.content
			local var_27_5 = 1 - (var_27_3 == 0 and 0 or var_27_3 / var_27_0)
			local var_27_6 = arg_27_5.content.ability_progress
			local var_27_7 = Gui.material(arg_27_2.gui, var_27_6)

			Material.set_scalar(var_27_7, "gradient_threshold", var_27_5)

			var_27_4.ready = var_27_5 == 1
			var_27_4.actual_cooldown = var_27_5

			local var_27_8 = Managers.input:is_device_active("gamepad")
			local var_27_9 = "versus_horde_ability"
			local var_27_10 = Managers.input:get_service("Player")
			local var_27_11, var_27_12 = UISettings.get_gamepad_input_texture_data(var_27_10, var_27_9, var_27_8)

			if var_27_4.current_input_text ~= var_27_12 then
				var_27_4.current_input_text = var_27_12

				if var_27_8 then
					var_27_4.input_text = "$KEY;Player__" .. var_27_9 .. ":"
				else
					var_27_4.input_text = "[" .. var_27_12 .. "]"
				end
			end

			UIRenderer.draw_widget(arg_27_2, arg_27_5)
		end
	}
}

local function var_0_12()
	return {
		scenegraph_id = "ability_pivot",
		element = {
			passes = {
				{
					style_id = "texture_icon_bg",
					texture_id = "texture_icon",
					pass_type = "texture",
					content_change_function = function(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
						if arg_29_0.texture_icon == "icons_placeholder" and arg_29_0.settings then
							arg_29_0.texture_icon = arg_29_0.settings.icon
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_icon",
					texture_id = "texture_icon",
					content_check_function = function(arg_30_0)
						return arg_30_0.is_cooldown
					end
				},
				{
					style_id = "icon_mask",
					texture_id = "icon_mask",
					pass_type = "texture",
					content_change_function = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
						arg_31_1.color[1] = 255 * (1 - arg_31_0.progress)
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_frame",
					texture_id = "texture_frame"
				},
				{
					style_id = "texture_cooldown",
					texture_id = "texture_cooldown",
					pass_type = "gradient_mask_texture",
					content_check_function = function(arg_32_0)
						return arg_32_0.is_cooldown
					end,
					content_change_function = function(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
						arg_33_1.color[1] = 255 * (1 - arg_33_0.progress)
					end
				},
				{
					style_id = "input",
					pass_type = "text",
					text_id = "input",
					content_change_function = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
						if not arg_34_0.settings then
							return
						end

						local var_34_0 = Managers.input:is_device_active("gamepad")
						local var_34_1 = var_34_0 and arg_34_0.settings.gamepad_input or arg_34_0.settings.input_action
						local var_34_2 = Managers.input:get_service("Player")
						local var_34_3, var_34_4, var_34_5 = UISettings.get_gamepad_input_texture_data(var_34_2, var_34_1, var_34_0)

						if arg_34_0.current_input_text ~= var_34_4 then
							arg_34_0.current_input_text = var_34_4

							if var_34_5 and var_34_5[1] == "mouse" or var_34_0 then
								arg_34_0.input = string.format("$KEY;Player__%s:", var_34_1)
								arg_34_1.offset[1] = 68
							else
								arg_34_0.input = var_34_4
								arg_34_1.offset[1] = 40
							end
						end

						local var_34_6 = Managers.ui:get_hud_component("SubtitleGui")

						if var_34_6 then
							local var_34_7 = var_34_6:is_displaying_subtitle()

							arg_34_0.has_subtitles = var_34_7

							local var_34_8 = arg_34_0.fade_progress or 0

							if var_34_7 then
								var_34_8 = math.max(var_34_8 - arg_34_3 * 5, 0)
							else
								var_34_8 = math.min(var_34_8 + arg_34_3 * 5, 1)
							end

							arg_34_1.text_color[1] = 55 + 200 * var_34_8
							arg_34_0.fade_progress = var_34_8
						end
					end
				}
			}
		},
		content = {
			set_unsaturated = false,
			is_cooldown = false,
			texture_cooldown = "dark_pact_ability_icon_cooldown_gradient",
			progress = 0,
			texture_frame = "health_bar_ability_icon_frame",
			texture_icon = "icons_placeholder",
			gris = "rect_masked",
			icon_mask = "dark_pact_ability_icon_gradient_mask",
			input = "n/a"
		},
		style = {
			texture_icon_bg = {
				saturated = false,
				size = {
					56,
					56
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					12,
					14,
					1
				}
			},
			texture_icon = {
				saturated = false,
				masked = true,
				size = {
					56,
					56
				},
				color = {
					255,
					30,
					30,
					30
				},
				offset = {
					12,
					14,
					2
				}
			},
			icon_mask = {
				size = {
					56,
					56
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					12,
					14,
					2
				}
			},
			texture_cooldown = {
				size = {
					56,
					56
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					12,
					14,
					3
				}
			},
			texture_frame = {
				size = {
					80,
					80
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					4
				}
			},
			input = {
				font_type = "hell_shark",
				upper_case = false,
				localize = false,
				use_shadow = true,
				font_size = 26,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					0,
					0
				},
				area_size = {
					20,
					20
				},
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					68,
					100,
					6
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

local function var_0_13(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7, arg_35_8)
	if arg_35_6 then
		return
	end

	local var_35_0 = arg_35_5.content
	local var_35_1 = ScriptUnit.extension(arg_35_7, "inventory_system"):get_weapon_unit()
	local var_35_2 = ScriptUnit.extension(var_35_1, "weapon_system"):get_custom_data("reload_progress")

	var_35_0.is_cooldown = var_35_2 > 0
	var_35_0.progress = var_35_2

	UIRenderer.draw_widget(arg_35_2, arg_35_5)
end

local function var_0_14(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8)
	if arg_36_6 then
		return
	end

	local var_36_0, var_36_1 = arg_36_3:current_ability_cooldown(arg_36_4)
	local var_36_2 = arg_36_3:get_activated_ability_data(arg_36_4)
	local var_36_3 = arg_36_3:uses_cooldown(arg_36_4)
	local var_36_4 = arg_36_5.content
	local var_36_5 = arg_36_5.style
	local var_36_6 = var_36_0 ~= 0

	var_36_4.is_cooldown = var_36_6

	if var_36_6 then
		var_36_4.progress = 1 - math.clamp(var_36_0 / var_36_1, 0, var_36_4.current_progress or 1)
	end

	UIRenderer.draw_widget(arg_36_2, arg_36_5)
end

local function var_0_15(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7, arg_37_8)
	if arg_37_6 then
		return
	end

	local var_37_0, var_37_1 = arg_37_3:current_ability_cooldown(arg_37_4)
	local var_37_2 = arg_37_3:get_activated_ability_data(arg_37_4)
	local var_37_3 = arg_37_3:uses_cooldown(arg_37_4)
	local var_37_4 = arg_37_5.content
	local var_37_5 = arg_37_5.style
	local var_37_6 = var_37_0 ~= 0

	var_37_4.is_cooldown = var_37_6

	if var_37_6 then
		var_37_4.progress = 1 - math.clamp(var_37_0 / var_37_1, 0, var_37_4.current_progress or 1)
	end

	UIRenderer.draw_widget(arg_37_2, arg_37_5)
end

local function var_0_16(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6, arg_38_7, arg_38_8)
	if arg_38_6 then
		return
	end

	if not arg_38_3:get_activated_ability_data(arg_38_4).duration_progress then
		local var_38_0 = 0
	end

	local var_38_1 = arg_38_3:can_use_activated_ability(arg_38_4)
	local var_38_2 = arg_38_5.content
	local var_38_3 = 0
	local var_38_4 = false

	if not var_38_1 then
		var_38_4 = true
		var_38_3 = 0
		arg_38_5.style.texture_icon.color = {
			255,
			100,
			100,
			100
		}
	end

	local var_38_5 = "vs_gutter_runner_smoke_bomb_invisible"
	local var_38_6 = Managers.player:local_player(1).player_unit

	if not Unit.alive(var_38_6) then
		return
	end

	local var_38_7 = ScriptUnit.extension(var_38_6, "buff_system"):get_non_stacking_buff(var_38_5)

	if var_38_7 then
		local var_38_8 = var_38_7.duration
		local var_38_9 = var_38_7.start_time
		local var_38_10 = Managers.time:time("game")
		local var_38_11 = var_38_8 and var_38_9 + var_38_8 or 0

		var_38_4 = (var_38_11 and math.max(var_38_11 - var_38_10, 0)) / var_38_8 ~= 1
	end

	var_38_2.is_cooldown = var_38_4
	var_38_2.progress = var_38_3

	UIRenderer.draw_widget(arg_38_2, arg_38_5)
end

local function var_0_17(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8)
	if arg_39_6 then
		return
	end

	local var_39_0, var_39_1 = arg_39_3:current_ability_cooldown(arg_39_4)
	local var_39_2 = arg_39_3:uses_cooldown(arg_39_4)
	local var_39_3, var_39_4 = arg_39_3:get_extra_ability_uses()
	local var_39_5 = 1 + var_39_4
	local var_39_6 = var_39_3

	if var_39_0 <= 0 then
		local var_39_7 = var_39_6 + 1

		if var_39_4 > 0 then
			local var_39_8

			var_39_0, var_39_8 = arg_39_3:get_extra_ability_charge()
			var_39_0 = var_39_8 - var_39_0
		end
	end

	local var_39_9 = false
	local var_39_10 = arg_39_5.content
	local var_39_11 = arg_39_5.style
	local var_39_12 = var_39_10.ability_cooldown or 0
	local var_39_13 = 0

	if var_39_2 then
		if var_39_0 < var_39_12 then
			var_39_9 = true
			var_39_13 = var_39_0 / var_39_12
		else
			var_39_10.ability_cooldown = var_39_0
		end

		if not var_39_0 or var_39_0 <= 0 then
			var_39_10.ability_cooldown = 0
		end
	end

	var_39_10.is_cooldown = var_39_9
	var_39_10.progress = 1 - var_39_13

	UIRenderer.draw_widget(arg_39_2, arg_39_5)
end

local var_0_18 = {
	vs_chaos_troll = {
		{
			widget_definitions = {
				ability_icon = var_0_12()
			}
		},
		{
			ability_name = "vomit",
			widget_definitions = {
				ability_icon = var_0_12()
			},
			update_functions = {
				ability_icon = var_0_14
			}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability = var_0_11.ability.definition
			},
			update_functions = {
				ability = var_0_11.ability.update_function
			}
		}
	},
	vs_rat_ogre = {
		{
			widget_definitions = {
				ability_icon = var_0_12()
			}
		},
		{
			ability_name = "ogre_jump",
			widget_definitions = {
				ability_icon = var_0_12(),
				priming = var_0_11.priming.definition
			},
			update_functions = {
				priming = var_0_11.priming.update_function,
				ability_icon = var_0_15
			}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability = var_0_11.ability.definition
			},
			update_functions = {
				ability = var_0_11.ability.update_function
			}
		}
	},
	vs_gutter_runner = {
		{
			ability_name = "pounce",
			widget_definitions = {
				ability_icon = var_0_12(),
				priming = var_0_11.priming.definition
			},
			update_functions = {
				priming = var_0_11.priming.update_function
			}
		},
		{
			ability_name = "foff",
			widget_definitions = {
				ability_icon = var_0_12()
			},
			update_functions = {
				ability_icon = var_0_16
			}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability = var_0_11.ability.definition
			},
			update_functions = {
				ability = var_0_11.ability.update_function
			}
		}
	},
	vs_ratling_gunner = {
		{
			widget_definitions = {
				ability_icon = var_0_12()
			}
		},
		{
			ability_name = "fire",
			widget_definitions = {
				ability_icon = var_0_12(),
				reload = var_0_11.ratling_gunner_reload.definition,
				ammo = var_0_11.ammo.definition
			},
			update_functions = {
				ability_icon = var_0_13,
				reload = var_0_11.ratling_gunner_reload.update_function,
				ammo = var_0_11.ammo.update_function
			},
			events = {
				on_dark_pact_ammo_changed = "event_on_dark_pact_ammo_changed"
			}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability = var_0_11.ability.definition
			},
			update_functions = {
				ability = var_0_11.ability.update_function
			}
		}
	},
	vs_warpfire_thrower = {
		{
			ability_name = "fire",
			widget_definitions = {
				ability_icon = var_0_12()
			},
			update_functions = {}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability = var_0_11.ability.definition
			},
			update_functions = {
				ability = var_0_11.ability.update_function
			}
		}
	},
	vs_poison_wind_globadier = {
		{
			ability_name = "gas",
			widget_definitions = {
				ability_icon = var_0_12(),
				throw_charge = var_0_11.throw_charge.definition
			},
			update_functions = {
				ability_icon = var_0_17,
				throw_charge = var_0_11.throw_charge.update_function
			}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability = var_0_11.ability.definition
			},
			update_functions = {
				ability = var_0_11.ability.update_function
			}
		}
	},
	vs_packmaster = {
		{
			ability_name = "equip",
			widget_definitions = {
				ability_icon = var_0_12(),
				reload = var_0_11.packmaster_reload.definition
			},
			update_functions = {
				reload = var_0_11.packmaster_reload.update_function
			}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability_charge = var_0_11.ability.definition
			},
			update_functions = {
				ability_charge = var_0_11.ability.update_function
			}
		}
	}
}

return {
	profile_ability_templates = var_0_18,
	scenegraph_definition = var_0_3,
	widget_definitions = var_0_4
}
