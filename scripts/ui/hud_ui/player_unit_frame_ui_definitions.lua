-- chunkname: @scripts/ui/hud_ui/player_unit_frame_ui_definitions.lua

local num = 1920
local num_2 = 1080
local flag = true
local num_3 = 1
local tbl = {
	hp_bar = {
		z = -8,
		x = -232,
		y = 10
	},
	ability_bar = {
		z = -8,
		x = -224,
		y = 33
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
	pivot_parent = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			50,
			0,
			5
		},
		size = {
			0,
			0
		}
	},
	pivot = {
		vertical_alignment = "bottom",
		parent = "pivot_parent",
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
	player_status = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0 + UISettings.INSIGNIA_OFFSET,
			0,
			5
		},
		size = {
			86,
			108
		}
	},
	equipment_root = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0 + UISettings.INSIGNIA_OFFSET,
			0,
			5
		},
		size = {
			86,
			108
		}
	},
	insignia_pivot_parent = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "left",
		position = {
			0,
			0,
			10
		},
		size = tbl_2
	},
	insignia_pivot = {
		vertical_alignment = "top",
		parent = "insignia_pivot_parent",
		horizontal_alignment = "left",
		position = {
			40,
			-25,
			0
		},
		size = {
			0,
			0
		}
	},
	portrait_pivot_parent = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "left",
		position = {
			80 + UISettings.INSIGNIA_OFFSET,
			80,
			10
		},
		size = {
			0,
			0
		}
	},
	portrait_pivot = {
		vertical_alignment = "bottom",
		parent = "portrait_pivot_parent",
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
	portrait_pivot_dragger = {
		vertical_alignment = "center",
		parent = "portrait_pivot",
		horizontal_alignment = "center",
		position = {
			0,
			0,
			0
		},
		size = {
			86,
			108
		}
	},
	respawn_countdown_pivot = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		position = {
			0,
			30,
			10
		},
		size = {
			0,
			0
		}
	}
}
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
		scenegraph_id = "respawn_countdown_pivot",
		element = {
			passes = {
				{
					retained_mode = false,
					style_id = "respawn_info_text",
					pass_type = "text",
					text_id = "respawn_info_text"
				},
				{
					retained_mode = false,
					style_id = "respawn_countdown_text",
					pass_type = "text",
					text_id = "respawn_countdown_text"
				}
			}
		},
		content = {
			respawn_timer = 0,
			last_counts = 4,
			respawn_countdown_text = "",
			state = "hidden",
			total_fadeout_time = 0.66,
			respawn_info_text = "",
			total_countdown_time = 0
		},
		style = {
			respawn_info_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 32,
				horizontal_alignment = "center",
				text_color = {
					255,
					255,
					168,
					0
				},
				offset = {
					0,
					-10,
					3
				}
			},
			respawn_countdown_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 80,
				horizontal_alignment = "center",
				text_color = {
					255,
					255,
					168,
					0
				},
				offset = {
					0,
					-72,
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
	-- function 4
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
						-- function 5
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
						-- function 6
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

local function fn_4()
	-- function 7
	return {
		scenegraph_id = "equipment_root",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "hp_bar_highlight",
					texture_id = "hp_bar_highlight",
					retained_mode = flag,
					content_check_function = function (self, arg_8_1)
						-- function 8
						return not self.has_shield
					end
				},
				{
					style_id = "grimoire_debuff_divider",
					texture_id = "grimoire_debuff_divider",
					pass_type = "texture",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 9
						local internal_bar_value = self.hp_bar.internal_bar_value
						local actual_active_percentage = self.actual_active_percentage

						actual_active_percentage = actual_active_percentage or 1

						return math.max(internal_bar_value, actual_active_percentage) < 1
					end,
					content_change_function = function (self, arg_10_1)
						-- function 10
						local internal_bar_value = self.hp_bar.internal_bar_value
						local actual_active_percentage = self.actual_active_percentage

						actual_active_percentage = actual_active_percentage or 1

						local max = math.max(internal_bar_value, actual_active_percentage)

						arg_10_1.offset[1] = tbl.hp_bar.x - 7 + 464 * max
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "hp_bar",
					texture_id = "texture_id",
					content_id = "hp_bar",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 11
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
						-- function 12
						return self.draw_health_bar
					end
				},
				{
					style_id = "grimoire_bar",
					pass_type = "texture_uv",
					content_id = "grimoire_bar",
					retained_mode = flag,
					content_change_function = function (self, arg_13_1)
						-- function 13
						local parent = self.parent
						local internal_bar_value = parent.hp_bar.internal_bar_value
						local actual_active_percentage = parent.actual_active_percentage

						actual_active_percentage = actual_active_percentage or 1

						local max = math.max(internal_bar_value, actual_active_percentage)
						local size = arg_13_1.size
						local uvs = self.uvs
						local offset = arg_13_1.offset
						local num = 464

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
						-- function 14
						return Application.user_setting("numeric_ui")
					end
				},
				{
					style_id = "numeric_health_shadow",
					pass_type = "text",
					text_id = "numeric_health",
					retained_mode = flag,
					content_check_function = function ()
						-- function 15
						return Application.user_setting("numeric_ui")
					end
				}
			}
		},
		content = {
			grimoire_debuff_divider = "hud_player_hp_bar_grim_divider",
			hp_bar_highlight = "hud_player_hp_bar_highlight",
			bar_start_side = "left",
			numeric_health = "-",
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
					464,
					19
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
					464,
					19
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
					464,
					19
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
					464,
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
				font_size = 22,
				horizontal_alignment = "center",
				text_color = {
					255,
					250,
					250,
					250
				},
				offset = {
					-232,
					tbl.hp_bar.y - 3,
					tbl.hp_bar.z + 30
				},
				size = {
					464,
					21
				}
			},
			numeric_health_shadow = {
				vertical_alignment = "center",
				font_type = "arial",
				font_size = 22,
				horizontal_alignment = "center",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					-231,
					tbl.hp_bar.y - 3 - 1,
					tbl.hp_bar.z + 29
				},
				size = {
					464,
					21
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

local function fn_5()
	-- function 16
	return {
		scenegraph_id = "equipment_root",
		element = {
			passes = {
				{
					style_id = "ability_bar",
					pass_type = "texture_uv",
					content_id = "ability_bar",
					retained_mode = flag,
					content_change_function = function (self, arg_17_1)
						-- function 17
						local bar_value = self.bar_value
						local size = arg_17_1.size
						local uvs = self.uvs
						local offset = arg_17_1.offset
						local num = 448

						uvs[2][2] = bar_value
						size[1] = num * bar_value
					end
				}
			}
		},
		content = {
			bar_start_side = "left",
			ability_bar = {
				bar_value = 1,
				texture_id = "hud_player_ability_bar_fill",
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
			ability_bar = {
				size = {
					448,
					4
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl.ability_bar.x,
					tbl.ability_bar.y,
					tbl.ability_bar.z + 1
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

local tbl_7 = {
	portrait_static = UIWidgets.create_portrait_frame("portrait_pivot", "default", "-", num_3, flag),
	default_dynamic = fn_3(),
	default_static = fn(),
	health_dynamic = fn_4(),
	ability_dynamic = fn_5(),
	respawn_dynamic = fn_2(),
	versus_insignia_static = UIWidgets.create_small_insignia("insignia_pivot", 1, nil, nil, nil, flag)
}
local tbl_8 = {
	ability = true,
	weapons = false,
	damage = false,
	equipment = false,
	respawn = true
}
local tbl_9 = {
	static = {
		default = "default_static",
		level = "default_static",
		versus_insignia = "versus_insignia_static",
		portrait_frame = "portrait_static"
	},
	dynamic = {
		ability = "ability_dynamic",
		default = "default_dynamic",
		status_icon = "default_dynamic",
		health = "health_dynamic",
		respawn = "respawn_dynamic",
		damage = "damage_dynamic"
	}
}

return {
	weapon_slot_widget_settings = tbl_6,
	inventory_index_by_slot = tbl_5,
	inventory_consumable_icons = tbl_4,
	features_list = tbl_8,
	widget_name_by_feature = tbl_9,
	scenegraph_definition = tbl_3,
	widget_definitions = tbl_7
}
