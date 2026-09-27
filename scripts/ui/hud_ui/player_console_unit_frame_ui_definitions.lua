-- chunkname: @scripts/ui/hud_ui/player_console_unit_frame_ui_definitions.lua

local num = 1920
local num_2 = 1080
local flag = true
local num_3 = 1
local tbl = {
	hp_bar = {
		z = -8,
		x = -276.5,
		y = 35
	}
}
local tbl_2 = {
	86,
	108
}
local tbl_3 = {
	root = {
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
	player_status = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			0
		},
		size = {
			0,
			0
		}
	},
	pivot = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			5
		},
		size = {
			0,
			0
		}
	},
	portrait_pivot_parent = {
		parent = "root",
		position = {
			50,
			0,
			1
		},
		size = {
			0,
			0
		}
	},
	ability = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "right",
		position = {
			0,
			60,
			10
		}
	},
	portrait_pivot = {
		vertical_alignment = "bottom",
		parent = "portrait_pivot_parent",
		horizontal_alignment = "left",
		position = {
			80,
			80,
			10
		},
		size = {
			0,
			0
		}
	},
	insignia_pivot_parent = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "left",
		position = {
			40,
			83,
			1
		},
		size = {
			0,
			0
		}
	},
	insignia_pivot = {
		vertical_alignment = "top",
		parent = "insignia_pivot_parent",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			0
		},
		size = {
			0,
			0
		}
	}
}

if not IS_WINDOWS then
	tbl_3.root.scale = "hud_fit"
	tbl_3.root.is_root = nil
end

local tbl_4 = {
	"hud_inventory_icon_heal_01",
	"hud_inventory_icon_bomb",
	"hud_inventory_icon_potion",
	wpn_grimoire_01 = "hud_inventory_icon_grimoire",
	grenade_smoke_02 = "hud_inventory_icon_bomb",
	potion_healing_draught_01 = "hud_inventory_icon_heal_02",
	grenade_fire_02 = "hud_inventory_icon_bomb",
	potion_speed_boost_01 = "hud_inventory_icon_potion_speed",
	grenade_fire_01 = "hud_inventory_icon_bomb",
	grenade_engineer = "hud_inventory_icon_bomb",
	grenade_frag_02 = "hud_inventory_icon_bomb",
	grenade_frag_01 = "hud_inventory_icon_bomb",
	potion_cooldown_reduction_01 = "hud_inventory_icon_potion_cooldown_reduction",
	grenade_smoke_01 = "hud_inventory_icon_bomb",
	wpn_side_objective_tome_01 = "hud_inventory_icon_tome",
	potion_damage_boost_01 = "hud_inventory_icon_potion_strength",
	healthkit_first_aid_kit_01 = "hud_inventory_icon_heal_01"
}
local tbl_5 = {
	slot_potion = 3,
	slot_grenade = 2,
	slot_healthkit = 1
}
local tbl_6 = {
	ammo_fields = {
		slot_ranged = "ammo_text_weapon_slot_2",
		slot_melee = "ammo_text_weapon_slot_1"
	}
}

local function fn()
	-- function 1
	return {
		scenegraph_id = "portrait_pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "character_portrait",
					texture_id = "character_portrait",
					retained_mode = flag
				},
				{
					style_id = "player_level",
					pass_type = "text",
					text_id = "player_level",
					retained_mode = flag
				},
				{
					pass_type = "texture",
					style_id = "host_icon",
					texture_id = "host_icon",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 2
						return self.is_host
					end
				}
			}
		},
		content = {
			is_host = false,
			character_portrait = "unit_frame_portrait_default",
			host_icon = "host_icon",
			player_level = ""
		},
		style = {
			character_portrait = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				texture_size = {
					86,
					108
				},
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
			host_icon = {
				size = {
					40,
					40
				},
				offset = {
					-57,
					-68,
					50
				},
				color = {
					150,
					255,
					255,
					255
				}
			},
			player_level = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 18,
				horizontal_alignment = "center",
				text_color = Colors.get_table("cheeseburger"),
				offset = {
					0,
					-65,
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

local function fn_2()
	-- function 3
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "portrait_icon",
					texture_id = "portrait_icon",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 4
						return self.display_portrait_icon
					end
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator",
					texture_id = "talk_indicator",
					retained_mode = flag
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_glow",
					texture_id = "talk_indicator_glow",
					retained_mode = flag
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_highlight",
					texture_id = "talk_indicator_highlight",
					retained_mode = flag
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_highlight_glow",
					texture_id = "talk_indicator_highlight_glow",
					retained_mode = flag
				},
				{
					pass_type = "rotated_texture",
					style_id = "connecting_icon",
					texture_id = "connecting_icon",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 5
						return self.connecting
					end
				}
			}
		},
		content = {
			talk_indicator_highlight = "voip_wave",
			connecting = false,
			display_portrait_icon = false,
			portrait_icon = "status_icon_needs_assist",
			display_portrait_overlay = false,
			connecting_icon = "matchmaking_connecting_icon",
			talk_indicator_highlight_glow = "voip_wave_glow",
			talk_indicator = "voip_speaker",
			talk_indicator_glow = "voip_speaker_glow"
		},
		style = {
			talk_indicator = {
				scenegraph_id = "portrait_pivot",
				size = {
					64,
					64
				},
				offset = {
					60,
					6,
					3
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			talk_indicator_glow = {
				scenegraph_id = "portrait_pivot",
				size = {
					64,
					64
				},
				offset = {
					60,
					6,
					2
				},
				color = {
					0,
					0,
					0,
					0
				}
			},
			talk_indicator_highlight = {
				scenegraph_id = "portrait_pivot",
				size = {
					64,
					64
				},
				offset = {
					60,
					6,
					3
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			talk_indicator_highlight_glow = {
				scenegraph_id = "portrait_pivot",
				size = {
					64,
					64
				},
				offset = {
					60,
					6,
					2
				},
				color = {
					0,
					0,
					0,
					0
				}
			},
			connecting_icon = {
				vertical_alignment = "center",
				scenegraph_id = "portrait_pivot",
				horizontal_alignment = "center",
				angle = 0,
				pivot = {
					26.5,
					26.5
				},
				texture_size = {
					53,
					53
				},
				offset = {
					0,
					0,
					12
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			portrait_icon = {
				vertical_alignment = "center",
				scenegraph_id = "portrait_pivot",
				horizontal_alignment = "center",
				texture_size = {
					86,
					108
				},
				offset = {
					0,
					0,
					7
				},
				color = {
					150,
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
end

local function fn_3()
	-- function 6
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "hp_bar_highlight",
					texture_id = "hp_bar_highlight",
					retained_mode = flag,
					content_check_function = function (self, arg_7_1)
						-- function 7
						return not self.has_shield
					end
				},
				{
					style_id = "grimoire_debuff_divider",
					texture_id = "grimoire_debuff_divider",
					pass_type = "texture",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 8
						local internal_bar_value = self.hp_bar.internal_bar_value
						local actual_active_percentage = self.actual_active_percentage

						actual_active_percentage = actual_active_percentage or 1

						return math.max(internal_bar_value, actual_active_percentage) < 1
					end,
					content_change_function = function (self, arg_9_1)
						-- function 9
						local internal_bar_value = self.hp_bar.internal_bar_value
						local actual_active_percentage = self.actual_active_percentage

						actual_active_percentage = actual_active_percentage or 1

						local max = math.max(internal_bar_value, actual_active_percentage)

						arg_9_1.offset[1] = tbl.hp_bar.x - 7 + 553 * max
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "hp_bar",
					texture_id = "texture_id",
					content_id = "hp_bar",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 10
						local draw_health_bar = self.draw_health_bar

						draw_health_bar = not draw_health_bar and not self.hide

						return draw_health_bar
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "total_health_bar",
					texture_id = "texture_id",
					content_id = "total_health_bar",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 11
						return self.draw_health_bar
					end
				},
				{
					style_id = "grimoire_bar",
					pass_type = "texture_uv",
					content_id = "grimoire_bar",
					retained_mode = flag,
					content_change_function = function (self, arg_12_1)
						-- function 12
						local parent = self.parent
						local internal_bar_value = parent.hp_bar.internal_bar_value
						local actual_active_percentage = parent.actual_active_percentage

						actual_active_percentage = actual_active_percentage or 1

						local max = math.max(internal_bar_value, actual_active_percentage)
						local size = arg_12_1.size
						local uvs = self.uvs
						local offset = arg_12_1.offset
						local num = 553

						uvs[1][1] = max
						size[1] = num * (1 - max)
						offset[1] = 2 + tbl.hp_bar.x + num * max
					end
				},
				{
					style_id = "numeric_health",
					pass_type = "text",
					text_id = "numeric_health",
					retained_mode = flag,
					content_check_function = function ()
						-- function 13
						local user_setting = Application.user_setting("numeric_ui")

						if not user_setting then
							if UISettings.use_gamepad_hud_layout ~= "always" then
								user_setting = Managers.input:is_device_active("gamepad")

								if not user_setting then
									-- Nothing
								end

								if UISettings.use_gamepad_hud_layout == "never" then
									user_setting = false

									goto label_13_0
								end
							end

							user_setting = true
						end

						::label_13_0::

						return user_setting
					end
				},
				{
					style_id = "numeric_health_shadow",
					pass_type = "text",
					text_id = "numeric_health",
					retained_mode = flag,
					content_check_function = function ()
						-- function 14
						local user_setting = Application.user_setting("numeric_ui")

						if not user_setting then
							if UISettings.use_gamepad_hud_layout ~= "always" then
								user_setting = Managers.input:is_device_active("gamepad")

								if not user_setting then
									-- Nothing
								end

								if UISettings.use_gamepad_hud_layout == "never" then
									user_setting = false

									goto label_14_0
								end
							end

							user_setting = true
						end

						::label_14_0::

						return user_setting
					end
				}
			}
		},
		content = {
			grimoire_debuff_divider = "hud_player_hp_bar_grim_divider",
			hp_bar_highlight = "hud_player_hp_bar_highlight",
			bar_start_side = "left",
			numeric_health = "-/-",
			hp_bar = {
				bar_value = 1,
				hide = false,
				texture_id = "player_hp_bar_color_tint",
				draw_health_bar = true,
				internal_bar_value = 0
			},
			total_health_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				texture_id = "player_hp_bar",
				draw_health_bar = true
			},
			grimoire_bar = {
				texture_id = "hud_panel_hp_bar_bg_grimoire",
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
			total_health_bar = {
				gradient_threshold = 1,
				size = {
					553,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl.hp_bar.x,
					tbl.hp_bar.y,
					tbl.hp_bar.z + 2
				}
			},
			hp_bar = {
				gradient_threshold = 1,
				size = {
					553,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl.hp_bar.x,
					tbl.hp_bar.y,
					tbl.hp_bar.z + 3
				}
			},
			grimoire_bar = {
				size = {
					553,
					18
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl.hp_bar.x,
					tbl.hp_bar.y,
					tbl.hp_bar.z + 4
				}
			},
			grimoire_debuff_divider = {
				size = {
					21,
					36
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl.hp_bar.x + 10,
					tbl.hp_bar.y - 8,
					tbl.hp_bar.z + 20
				}
			},
			hp_bar_highlight = {
				size = {
					553,
					30
				},
				offset = {
					tbl.hp_bar.x,
					tbl.hp_bar.y - 4,
					tbl.hp_bar.z + 5
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			numeric_health = {
				vertical_alignment = "center",
				font_type = "arial",
				font_size = 18,
				horizontal_alignment = "center",
				text_color = {
					255,
					250,
					250,
					250
				},
				offset = {
					-276.5,
					tbl.hp_bar.y - 3,
					tbl.hp_bar.z + 30
				},
				size = {
					553,
					18
				}
			},
			numeric_health_shadow = {
				vertical_alignment = "center",
				font_type = "arial",
				font_size = 18,
				horizontal_alignment = "center",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-275.5,
					tbl.hp_bar.y - 3 - 1,
					tbl.hp_bar.z + 29
				},
				size = {
					553,
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

local function fn_4()
	-- function 15
	return {
		scenegraph_id = "ability",
		element = {
			passes = {
				{
					style_id = "ability_bar",
					pass_type = "texture",
					texture_id = "texture_id",
					content_id = "ability_bar",
					retained_mode = flag,
					content_change_function = function (self, arg_16_1)
						-- function 16
						local bar_value = self.bar_value
						local texture_size = arg_16_1.texture_size

						arg_16_1.offset[2] = -texture_size[2] + texture_size[2] * bar_value
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_bar_mask",
					texture_id = "ability_bar_mask",
					retained_mode = flag
				}
			}
		},
		content = {
			ability_bar_mask = "gamepad_ability_outline_mask",
			bar_start_side = "left",
			ability_bar = {
				bar_value = 1,
				texture_id = "gamepad_ability_outline_fill"
			}
		},
		style = {
			ability_bar = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					101,
					125
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
					0
				}
			},
			ability_bar_mask = {
				vertical_alignment = "bottom",
				horizontal_alignment = "right",
				texture_size = {
					96,
					115
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
					0
				}
			}
		},
		offset = {
			-15,
			15,
			0
		}
	}
end

local tbl_7 = {
	portrait_static = UIWidgets.create_portrait_frame("portrait_pivot", "default", "-", num_3, flag),
	default_dynamic = fn_2(),
	default_static = fn(),
	health_dynamic = fn_3(),
	ability_dynamic = fn_4(),
	versus_insignia_static = UIWidgets.create_small_insignia("insignia_pivot", 1, nil, nil, nil, flag)
}
local tbl_8 = {
	equipment = false,
	weapons = false,
	damage = true,
	ability = true
}
local tbl_9 = {
	static = {
		default = "default_static",
		level = "default_static",
		versus_insignia = "versus_insignia_static",
		portrait_frame = "portrait_static"
	},
	dynamic = {
		default = "default_dynamic",
		ability = "ability_dynamic",
		status_icon = "default_dynamic",
		health = "health_dynamic"
	}
}
local create_damage_widget = UnitFramesUiUtils.create_damage_widget("player", 4)

return {
	weapon_slot_widget_settings = tbl_6,
	inventory_index_by_slot = tbl_5,
	inventory_consumable_icons = tbl_4,
	features_list = tbl_8,
	widget_name_by_feature = tbl_9,
	scenegraph_definition = tbl_3,
	widget_definitions = tbl_7,
	damage_widget_definitions = create_damage_widget
}
