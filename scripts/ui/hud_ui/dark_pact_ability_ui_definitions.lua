-- chunkname: @scripts/ui/hud_ui/dark_pact_ability_ui_definitions.lua

local num = 1920
local num_2 = 1080
local flag = false
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
local tbl_2 = {
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

local function fn()
	-- function 1
	return {
		scenegraph_id = "crosshair_root",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background",
					content_check_function = function (self)
						-- function 2
						return self.progress > 0
					end
				},
				{
					style_id = "progress_1",
					pass_type = "texture_uv",
					content_id = "progress_1",
					content_check_function = function (self)
						-- function 3
						return self.parent.progress > 0
					end,
					content_change_function = function (self, arg_4_1)
						-- function 4
						self.uvs = {
							{
								0,
								1 - self.parent.progress
							},
							{
								1,
								1
							}
						}
						arg_4_1.texture_size[2] = 84 * self.parent.progress
					end
				},
				{
					style_id = "progress_2",
					pass_type = "texture_uv",
					content_id = "progress_2",
					content_check_function = function (self)
						-- function 5
						return self.parent.progress > 0
					end,
					content_change_function = function (self, arg_6_1)
						-- function 6
						self.uvs = {
							{
								0,
								1 - self.parent.progress
							},
							{
								1,
								1
							}
						}
						arg_6_1.texture_size[2] = 84 * self.parent.progress
					end
				},
				{
					style_id = "progress_3",
					pass_type = "texture_uv",
					content_id = "progress_3",
					content_check_function = function (self)
						-- function 7
						return self.parent.progress > 0
					end,
					content_change_function = function (self, arg_8_1)
						-- function 8
						self.uvs = {
							{
								0,
								1 - self.parent.progress
							},
							{
								1,
								1
							}
						}
						arg_8_1.texture_size[2] = 84 * self.parent.progress
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

local function fn_2()
	-- function 9
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
					retained_mode = flag,
					content_check_function = function (self)
						-- function 10
						return self.progress > 0
					end
				},
				{
					pass_type = "texture",
					style_id = "ring",
					texture_id = "ring",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 11
						return self.progress > 0
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

local function fn_3()
	-- function 12
	return {
		scenegraph_id = "crosshair_root",
		element = {
			passes = {
				{
					style_id = "cooldown",
					pass_type = "texture_uv",
					content_id = "cooldown",
					retained_mode = flag
				},
				{
					pass_type = "texture",
					style_id = "background",
					texture_id = "background",
					retained_mode = flag
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					retained_mode = flag
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					retained_mode = flag
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

local function fn_4()
	-- function 13
	return {
		scenegraph_id = "bottom_root",
		element = {
			passes = {
				{
					style_id = "background",
					pass_type = "rect",
					retained_mode = flag
				},
				{
					style_id = "progress",
					pass_type = "rect",
					retained_mode = flag
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

local function fn_5()
	-- function 14
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
					content_check_function = function (self)
						-- function 15
						return self.ready
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_effect_top",
					texture_id = "ability_effect_top",
					content_check_function = function (self)
						-- function 16
						return self.ready
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_effect_halo",
					texture_id = "ability_effect_halo",
					content_check_function = function (self)
						-- function 17
						return self.ready
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

local function fn_6()
	-- function 18
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

local tbl_3 = {
	packmaster_reload = {
		definition = fn_3(),
		update_function = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6)
			-- function 19
			local current_ability_cooldown, var_19_1 = arg_19_3:current_ability_cooldown(arg_19_4)
			local uses_cooldown = arg_19_3:uses_cooldown(arg_19_4)
			local ability_by_id = arg_19_3:ability_by_id(arg_19_4)
			local ability_available = ability_by_id:ability_available()
			local startup_delay_time = ability_by_id:startup_delay_time()
			local var_19_6
			local flag = false

			if not ability_available then
				var_19_6 = ability_by_id:startup_delay_fraction()
				flag = var_19_6 ~= nil
			end

			local content = arg_19_5.content
			local style = arg_19_5.style

			content.visible = flag

			if not var_19_6 then
				local default_size = style.cooldown.default_size
				local texture_size = style.cooldown.texture_size

				content.cooldown.uvs[2][1] = var_19_6
				texture_size[1] = default_size[1] * var_19_6
			end

			UIRenderer.draw_widget(arg_19_2, arg_19_5)
		end
	},
	ratling_gunner_reload = {
		definition = fn_3(),
		update_function = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7)
			-- function 20
			if not arg_20_6 then
				return
			end

			local content = arg_20_5.content
			local get_weapon_unit = ScriptUnit.extension(arg_20_7, "inventory_system"):get_weapon_unit()
			local get_custom_data = ScriptUnit.extension(get_weapon_unit, "weapon_system"):get_custom_data("reload_progress")

			content.visible = get_custom_data > 0

			if not content.visible then
				return
			end

			local style = arg_20_5.style
			local num = 1 - get_custom_data

			if not num then
				local default_size = style.cooldown.default_size
				local texture_size = style.cooldown.texture_size
				local remap = math.remap(0, 1, 0.05, 0.95, num)

				content.cooldown.uvs[2][1] = remap
				texture_size[1] = default_size[1] * remap
			end

			UIRenderer.draw_widget(arg_20_2, arg_20_5)
		end
	},
	reload = {
		definition = fn_3(),
		update_function = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6)
			-- function 21
			if not arg_21_6 then
				return
			end

			local current_ability_cooldown, var_21_1 = arg_21_3:current_ability_cooldown(arg_21_4)
			local uses_cooldown = arg_21_3:uses_cooldown(arg_21_4)
			local get_extra_ability_uses, var_21_4 = arg_21_3:get_extra_ability_uses()
			local num = 1 + var_21_4
			local var_21_6 = get_extra_ability_uses

			if current_ability_cooldown <= 0 then
				var_21_6 = var_21_6 + 1

				if var_21_4 > 0 then
					local var_21_7

					current_ability_cooldown, var_21_7 = arg_21_3:get_extra_ability_charge()
					current_ability_cooldown = var_21_7 - current_ability_cooldown
				end
			end

			local flag = false
			local content = arg_21_5.content
			local style = arg_21_5.style
			local ability_cooldown = content.ability_cooldown

			ability_cooldown = ability_cooldown or 0

			local num_2 = 0

			if not uses_cooldown then
				if current_ability_cooldown < ability_cooldown then
					flag = true
					num_2 = current_ability_cooldown / ability_cooldown
				else
					content.ability_cooldown = current_ability_cooldown
				end

				if not (not current_ability_cooldown and not (current_ability_cooldown <= 0)) then
					content.ability_cooldown = 0
				end
			end

			local default_size = style.cooldown.default_size
			local texture_size = style.cooldown.texture_size

			content.cooldown.uvs[2][1] = num_2
			texture_size[1] = default_size[1] * num_2
			content.visible = flag

			if num > 1 then
				local orig_text = content.orig_text

				if not orig_text then
					content.orig_text = content.text
				end

				content.text = string.format("%s (%d/%d)", orig_text, var_21_6, num)
			end

			UIRenderer.draw_widget(arg_21_2, arg_21_5)
		end
	},
	priming = {
		definition = fn(),
		update_function = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
			-- function 22
			if not arg_22_6 then
				return
			end

			local current_ability_cooldown, var_22_1 = arg_22_3:current_ability_cooldown(arg_22_4)
			local get_activated_ability_data = arg_22_3:get_activated_ability_data(arg_22_4)
			local uses_cooldown = arg_22_3:uses_cooldown(arg_22_4)
			local priming_progress = get_activated_ability_data.priming_progress

			priming_progress = priming_progress or 0

			local content = arg_22_5.content
			local style = arg_22_5.style
			local ability_cooldown = content.ability_cooldown

			ability_cooldown = ability_cooldown or 0
			content.progress = priming_progress

			if not (not uses_cooldown and not (ability_cooldown <= current_ability_cooldown)) then
				content.ability_cooldown = current_ability_cooldown
			end

			if not (not current_ability_cooldown and not (current_ability_cooldown <= 0)) then
				content.ability_cooldown = 0
			end

			UIRenderer.draw_widget(arg_22_2, arg_22_5)
		end
	},
	recharge = {
		definition = fn_2(),
		update_function = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
			-- function 23
			if not arg_23_6 then
				return
			end

			local current_ability_cooldown, var_23_1 = arg_23_3:current_ability_cooldown(arg_23_4)
			local can_use_activated_ability = arg_23_3:can_use_activated_ability(arg_23_4)
			local uses_cooldown = arg_23_3:uses_cooldown(arg_23_4)
			local num = 0

			if not uses_cooldown then
				num = current_ability_cooldown / var_23_1
			else
				num = not can_use_activated_ability and 0 and 1
			end

			local content = arg_23_5.content
			local flag

			flag = num ~= content.current_cooldown_fraction

			local flag_2 = num ~= 0

			arg_23_5.style.cooldown_mask.color[1] = 255 * num
			content.on_cooldown = flag_2
			content.progress = num

			UIRenderer.draw_widget(arg_23_2, arg_23_5)
		end
	},
	throw_charge = {
		definition = fn_2(),
		update_function = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
			-- function 24
			if not arg_24_6 then
				return
			end

			local current_ability_cooldown, var_24_1 = arg_24_3:current_ability_cooldown(arg_24_4)
			local get_activated_ability_data = arg_24_3:get_activated_ability_data(arg_24_4)
			local uses_cooldown = arg_24_3:uses_cooldown(arg_24_4)
			local priming_progress = get_activated_ability_data.priming_progress

			priming_progress = priming_progress or 0

			local content = arg_24_5.content
			local style = arg_24_5.style
			local progress = content.progress

			progress = progress or 0

			local flag = progress < priming_progress
			local color = style.cooldown_mask.color
			local num

			if not flag then
				num = 255 * priming_progress

				if not num then
					-- Nothing
				end
			end

			num = 0

			::label_24_0::

			color[1] = num

			local ability_cooldown = content.ability_cooldown

			ability_cooldown = ability_cooldown or 0
			content.visible = not (priming_progress > 0) or priming_progress < 1
			content.progress = priming_progress

			if not (not uses_cooldown and not (ability_cooldown <= current_ability_cooldown)) then
				content.ability_cooldown = current_ability_cooldown
			end

			if not (not current_ability_cooldown and not (current_ability_cooldown <= 0)) then
				content.ability_cooldown = 0
			end

			UIRenderer.draw_widget(arg_24_2, arg_24_5)
		end
	},
	ammo = {
		definition = fn_6(),
		update_function = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6)
			-- function 25
			UIRenderer.draw_widget(arg_25_2, arg_25_5)
		end
	},
	duration = {
		definition = fn_4(),
		update_function = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6)
			-- function 26
			if not arg_26_3:get_activated_ability_data(arg_26_4).duration_progress then
				local num = 0
			end

			local str = "vs_gutter_runner_smoke_bomb_invisible"
			local player_unit = Managers.player:local_player(1).player_unit

			if not Unit.alive(player_unit) then
				return
			end

			local get_non_stacking_buff = ScriptUnit.extension(player_unit, "buff_system"):get_non_stacking_buff(str)

			if not get_non_stacking_buff then
				return
			end

			local duration = get_non_stacking_buff.duration
			local start_time = get_non_stacking_buff.start_time
			local time = Managers.time:time("game")
			local num_2

			if not duration then
				num_2 = start_time + duration

				if not num_2 then
					-- Nothing
				end
			end

			num_2 = 0

			::label_26_0::

			local flag = not num_2 and math.max(num_2 - time, 0)
			local style = arg_26_5.style
			local default_size = style.progress.default_size
			local texture_size = style.progress.texture_size
			local num_3 = flag / duration

			texture_size[1] = default_size[1] * num_3

			UIRenderer.draw_widget(arg_26_2, arg_26_5)
		end
	},
	ability = {
		definition = fn_5(),
		update_function = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6, arg_27_7, arg_27_8)
			-- function 27
			if not arg_27_6 then
				return
			end

			local cooldown = arg_27_8:cooldown()
			local time = Managers.time:time("game")
			local get_ability_charge = arg_27_8:get_ability_charge(time)
			local clamp = math.clamp(cooldown - get_ability_charge, 0, cooldown)
			local content = arg_27_5.content
			local flag

			flag = clamp ~= 0 or not 0 or clamp / cooldown

			local num = 1 - flag
			local ability_progress = arg_27_5.content.ability_progress
			local material = Gui.material(arg_27_2.gui, ability_progress)

			Material.set_scalar(material, "gradient_threshold", num)

			content.ready = num == 1
			content.actual_cooldown = num

			local is_device_active = Managers.input:is_device_active("gamepad")
			local str = "versus_horde_ability"
			local get_service = Managers.input:get_service("Player")
			local get_gamepad_input_texture_data, var_27_13 = UISettings.get_gamepad_input_texture_data(get_service, str, is_device_active)

			if content.current_input_text ~= var_27_13 then
				content.current_input_text = var_27_13

				if not is_device_active then
					content.input_text = "$KEY;Player__" .. str .. ":"
				else
					content.input_text = "[" .. var_27_13 .. "]"
				end
			end

			UIRenderer.draw_widget(arg_27_2, arg_27_5)
		end
	}
}

local function fn_7()
	-- function 28
	return {
		scenegraph_id = "ability_pivot",
		element = {
			passes = {
				{
					style_id = "texture_icon_bg",
					texture_id = "texture_icon",
					pass_type = "texture",
					content_change_function = function (self, arg_29_1, arg_29_2, arg_29_3)
						-- function 29
						if self.texture_icon ~= "icons_placeholder" or not self.settings then
							self.texture_icon = self.settings.icon
						end
					end
				},
				{
					pass_type = "texture",
					style_id = "texture_icon",
					texture_id = "texture_icon",
					content_check_function = function (self)
						-- function 30
						return self.is_cooldown
					end
				},
				{
					style_id = "icon_mask",
					texture_id = "icon_mask",
					pass_type = "texture",
					content_change_function = function (self, arg_31_1, arg_31_2, arg_31_3)
						-- function 31
						arg_31_1.color[1] = 255 * (1 - self.progress)
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
					content_check_function = function (self)
						-- function 32
						return self.is_cooldown
					end,
					content_change_function = function (self, arg_33_1, arg_33_2, arg_33_3)
						-- function 33
						arg_33_1.color[1] = 255 * (1 - self.progress)
					end
				},
				{
					style_id = "input",
					pass_type = "text",
					text_id = "input",
					content_change_function = function (self, arg_34_1, arg_34_2, arg_34_3)
						-- function 34
						if not self.settings then
							return
						end

						local is_device_active = Managers.input:is_device_active("gamepad")
						local gamepad_input

						if not is_device_active then
							gamepad_input = self.settings.gamepad_input

							if not gamepad_input then
								-- Nothing
							end
						end

						gamepad_input = self.settings.input_action

						::label_34_0::

						local get_service = Managers.input:get_service("Player")
						local get_gamepad_input_texture_data, var_34_4, var_34_5 = UISettings.get_gamepad_input_texture_data(get_service, gamepad_input, is_device_active)

						if self.current_input_text ~= var_34_4 then
							self.current_input_text = var_34_4

							if not var_34_5 and var_34_5[1] == "mouse" and not is_device_active then
								self.input = string.format("$KEY;Player__%s:", gamepad_input)
								arg_34_1.offset[1] = 68
							else
								self.input = var_34_4
								arg_34_1.offset[1] = 40
							end
						end

						local get_hud_component = Managers.ui:get_hud_component("SubtitleGui")

						if not get_hud_component then
							local is_displaying_subtitle = get_hud_component:is_displaying_subtitle()

							self.has_subtitles = is_displaying_subtitle

							local fade_progress = self.fade_progress

							fade_progress = fade_progress or 0

							if not is_displaying_subtitle then
								fade_progress = math.max(fade_progress - arg_34_3 * 5, 0)
							else
								fade_progress = math.min(fade_progress + arg_34_3 * 5, 1)
							end

							arg_34_1.text_color[1] = 55 + 200 * fade_progress
							self.fade_progress = fade_progress
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

local function fn_8(arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6, arg_35_7, arg_35_8)
	-- function 35
	if not arg_35_6 then
		return
	end

	local content = arg_35_5.content
	local get_weapon_unit = ScriptUnit.extension(arg_35_7, "inventory_system"):get_weapon_unit()
	local get_custom_data = ScriptUnit.extension(get_weapon_unit, "weapon_system"):get_custom_data("reload_progress")

	content.is_cooldown = get_custom_data > 0
	content.progress = get_custom_data

	UIRenderer.draw_widget(arg_35_2, arg_35_5)
end

local function fn_9(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5, arg_36_6, arg_36_7, arg_36_8)
	-- function 36
	if not arg_36_6 then
		return
	end

	local current_ability_cooldown, var_36_1 = arg_36_3:current_ability_cooldown(arg_36_4)
	local get_activated_ability_data = arg_36_3:get_activated_ability_data(arg_36_4)
	local uses_cooldown = arg_36_3:uses_cooldown(arg_36_4)
	local content = arg_36_5.content
	local style = arg_36_5.style
	local flag = current_ability_cooldown ~= 0

	content.is_cooldown = flag

	if not flag then
		local clamp = math.clamp
		local num = current_ability_cooldown / var_36_1
		local num_2 = 0
		local current_progress = content.current_progress

		current_progress = current_progress or 1
		content.progress = 1 - clamp(num, num_2, current_progress)
	end

	UIRenderer.draw_widget(arg_36_2, arg_36_5)
end

local function fn_10(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5, arg_37_6, arg_37_7, arg_37_8)
	-- function 37
	if not arg_37_6 then
		return
	end

	local current_ability_cooldown, var_37_1 = arg_37_3:current_ability_cooldown(arg_37_4)
	local get_activated_ability_data = arg_37_3:get_activated_ability_data(arg_37_4)
	local uses_cooldown = arg_37_3:uses_cooldown(arg_37_4)
	local content = arg_37_5.content
	local style = arg_37_5.style
	local flag = current_ability_cooldown ~= 0

	content.is_cooldown = flag

	if not flag then
		local clamp = math.clamp
		local num = current_ability_cooldown / var_37_1
		local num_2 = 0
		local current_progress = content.current_progress

		current_progress = current_progress or 1
		content.progress = 1 - clamp(num, num_2, current_progress)
	end

	UIRenderer.draw_widget(arg_37_2, arg_37_5)
end

local function fn_11(arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5, arg_38_6, arg_38_7, arg_38_8)
	-- function 38
	if not arg_38_6 then
		return
	end

	if not arg_38_3:get_activated_ability_data(arg_38_4).duration_progress then
		local num = 0
	end

	local can_use_activated_ability = arg_38_3:can_use_activated_ability(arg_38_4)
	local content = arg_38_5.content
	local num_2 = 0
	local flag = false

	if not can_use_activated_ability then
		flag = true
		num_2 = 0
		arg_38_5.style.texture_icon.color = {
			255,
			100,
			100,
			100
		}
	end

	local str = "vs_gutter_runner_smoke_bomb_invisible"
	local player_unit = Managers.player:local_player(1).player_unit

	if not Unit.alive(player_unit) then
		return
	end

	local get_non_stacking_buff = ScriptUnit.extension(player_unit, "buff_system"):get_non_stacking_buff(str)

	if not get_non_stacking_buff then
		local duration = get_non_stacking_buff.duration
		local start_time = get_non_stacking_buff.start_time
		local time = Managers.time:time("game")
		local num_3

		if not duration then
			num_3 = start_time + duration

			if not num_3 then
				-- Nothing
			end
		end

		num_3 = 0

		::label_38_0::

		flag = (not num_3 and math.max(num_3 - time, 0)) / duration ~= 1
	end

	content.is_cooldown = flag
	content.progress = num_2

	UIRenderer.draw_widget(arg_38_2, arg_38_5)
end

local function fn_12(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8)
	-- function 39
	if not arg_39_6 then
		return
	end

	local current_ability_cooldown, var_39_1 = arg_39_3:current_ability_cooldown(arg_39_4)
	local uses_cooldown = arg_39_3:uses_cooldown(arg_39_4)
	local get_extra_ability_uses, var_39_4 = arg_39_3:get_extra_ability_uses()
	local num = 1 + var_39_4
	local var_39_6 = get_extra_ability_uses

	if current_ability_cooldown <= 0 then
		local num_2 = var_39_6 + 1

		if var_39_4 > 0 then
			local var_39_8

			current_ability_cooldown, var_39_8 = arg_39_3:get_extra_ability_charge()
			current_ability_cooldown = var_39_8 - current_ability_cooldown
		end
	end

	local flag = false
	local content = arg_39_5.content
	local style = arg_39_5.style
	local ability_cooldown = content.ability_cooldown

	ability_cooldown = ability_cooldown or 0

	local num_3 = 0

	if not uses_cooldown then
		if current_ability_cooldown < ability_cooldown then
			flag = true
			num_3 = current_ability_cooldown / ability_cooldown
		else
			content.ability_cooldown = current_ability_cooldown
		end

		if not (not current_ability_cooldown and not (current_ability_cooldown <= 0)) then
			content.ability_cooldown = 0
		end
	end

	content.is_cooldown = flag
	content.progress = 1 - num_3

	UIRenderer.draw_widget(arg_39_2, arg_39_5)
end

local tbl_4 = {
	vs_chaos_troll = {
		{
			widget_definitions = {
				ability_icon = fn_7()
			}
		},
		{
			ability_name = "vomit",
			widget_definitions = {
				ability_icon = fn_7()
			},
			update_functions = {
				ability_icon = fn_9
			}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability = tbl_3.ability.definition
			},
			update_functions = {
				ability = tbl_3.ability.update_function
			}
		}
	},
	vs_rat_ogre = {
		{
			widget_definitions = {
				ability_icon = fn_7()
			}
		},
		{
			ability_name = "ogre_jump",
			widget_definitions = {
				ability_icon = fn_7(),
				priming = tbl_3.priming.definition
			},
			update_functions = {
				priming = tbl_3.priming.update_function,
				ability_icon = fn_10
			}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability = tbl_3.ability.definition
			},
			update_functions = {
				ability = tbl_3.ability.update_function
			}
		}
	},
	vs_gutter_runner = {
		{
			ability_name = "pounce",
			widget_definitions = {
				ability_icon = fn_7(),
				priming = tbl_3.priming.definition
			},
			update_functions = {
				priming = tbl_3.priming.update_function
			}
		},
		{
			ability_name = "foff",
			widget_definitions = {
				ability_icon = fn_7()
			},
			update_functions = {
				ability_icon = fn_11
			}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability = tbl_3.ability.definition
			},
			update_functions = {
				ability = tbl_3.ability.update_function
			}
		}
	},
	vs_ratling_gunner = {
		{
			widget_definitions = {
				ability_icon = fn_7()
			}
		},
		{
			ability_name = "fire",
			widget_definitions = {
				ability_icon = fn_7(),
				reload = tbl_3.ratling_gunner_reload.definition,
				ammo = tbl_3.ammo.definition
			},
			update_functions = {
				ability_icon = fn_8,
				reload = tbl_3.ratling_gunner_reload.update_function,
				ammo = tbl_3.ammo.update_function
			},
			events = {
				on_dark_pact_ammo_changed = "event_on_dark_pact_ammo_changed"
			}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability = tbl_3.ability.definition
			},
			update_functions = {
				ability = tbl_3.ability.update_function
			}
		}
	},
	vs_warpfire_thrower = {
		{
			ability_name = "fire",
			widget_definitions = {
				ability_icon = fn_7()
			},
			update_functions = {}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability = tbl_3.ability.definition
			},
			update_functions = {
				ability = tbl_3.ability.update_function
			}
		}
	},
	vs_poison_wind_globadier = {
		{
			ability_name = "gas",
			widget_definitions = {
				ability_icon = fn_7(),
				throw_charge = tbl_3.throw_charge.definition
			},
			update_functions = {
				ability_icon = fn_12,
				throw_charge = tbl_3.throw_charge.update_function
			}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability = tbl_3.ability.definition
			},
			update_functions = {
				ability = tbl_3.ability.update_function
			}
		}
	},
	vs_packmaster = {
		{
			ability_name = "equip",
			widget_definitions = {
				ability_icon = fn_7(),
				reload = tbl_3.packmaster_reload.definition
			},
			update_functions = {
				reload = tbl_3.packmaster_reload.update_function
			}
		},
		{
			ability_name = "horde_ability",
			widget_definitions = {
				ability_charge = tbl_3.ability.definition
			},
			update_functions = {
				ability_charge = tbl_3.ability.update_function
			}
		}
	}
}

return {
	profile_ability_templates = tbl_4,
	scenegraph_definition = tbl,
	widget_definitions = tbl_2
}
