-- chunkname: @scripts/ui/hud_ui/dark_pact_player_unit_frame_ui_definitions.lua

local num = 1920
local num_2 = 1080
local flag = true
local num_3 = 1
local tbl = {
	412,
	18
}
local tbl_2 = {
	464,
	80
}
local tbl_3 = {
	z = 8,
	y = 18,
	x = -(tbl[1] * 0.5)
}
local tbl_4 = {
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
	portrait_pivot = {
		vertical_alignment = "bottom",
		parent = "root",
		horizontal_alignment = "left",
		position = {
			130,
			80,
			10
		},
		size = {
			0,
			0
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
			40,
			80,
			0
		},
		size = {
			0,
			0
		}
	}
}
local tbl_5 = {
	"hud_inventory_icon_heal_01",
	"hud_inventory_icon_bomb",
	"hud_inventory_icon_potion",
	wpn_grimoire_01 = "hud_inventory_icon_grimoire",
	grenade_engineer_01 = "hud_inventory_icon_bomb",
	potion_healing_draught_01 = "hud_inventory_icon_heal_02",
	grenade_fire_02 = "hud_inventory_icon_bomb",
	potion_speed_boost_01 = "hud_inventory_icon_potion_speed",
	grenade_fire_01 = "hud_inventory_icon_bomb",
	grenade_smoke_02 = "hud_inventory_icon_bomb",
	grenade_frag_02 = "hud_inventory_icon_bomb",
	grenade_frag_01 = "hud_inventory_icon_bomb",
	grenade_smoke_01 = "hud_inventory_icon_bomb",
	potion_cooldown_reduction_01 = "hud_inventory_icon_potion_cooldown_reduction",
	wpn_side_objective_tome_01 = "hud_inventory_icon_tome",
	potion_damage_boost_01 = "hud_inventory_icon_potion_strength",
	healthkit_first_aid_kit_01 = "hud_inventory_icon_heal_01"
}
local tbl_6 = {
	slot_potion = 3,
	slot_grenade = 2,
	slot_healthkit = 1
}
local tbl_7 = {
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
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_frame",
					texture_id = "hp_bar_frame",
					retained_mode = flag,
					content_check_function = function (self, arg_3_1)
						-- function 3
						return self.show_health_bar
					end
				}
			}
		},
		content = {
			hp_bar_frame = "health_bar_frame",
			character_portrait = "unit_frame_portrait_default",
			host_icon = "host_icon",
			show_health_bar = true,
			is_host = false,
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
			},
			hp_bar_frame = {
				scenegraph_id = "pivot",
				size = tbl_2,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-(tbl_2[1] * 0.5),
					-1,
					1
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
	-- function 4
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
			total_fadeout_time = 0,
			respawn_info_text = "",
			total_countdown_time = 0
		},
		style = {
			respawn_info_text = {
				vertical_alignment = "center",
				font_type = "hell_shark",
				font_size = 24,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("light_gray", 255),
				offset = {
					0,
					-48,
					3
				}
			},
			respawn_countdown_text = {
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				font_size = 120,
				horizontal_alignment = "center",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					0,
					-140,
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
	-- function 5
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
						-- function 6
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
						-- function 7
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
	-- function 8
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "hp_bar_highlight",
					texture_id = "hp_bar_highlight",
					retained_mode = flag,
					content_check_function = function (self, arg_9_1)
						-- function 9
						return not self.has_shield
					end
				},
				{
					style_id = "grimoire_debuff_divider",
					texture_id = "grimoire_debuff_divider",
					pass_type = "texture",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 10
						local internal_bar_value = self.hp_bar.internal_bar_value
						local actual_active_percentage = self.actual_active_percentage

						actual_active_percentage = actual_active_percentage or 1

						return math.max(internal_bar_value, actual_active_percentage) < 1
					end,
					content_change_function = function (self, arg_11_1)
						-- function 11
						local internal_bar_value = self.hp_bar.internal_bar_value
						local actual_active_percentage = self.actual_active_percentage

						actual_active_percentage = actual_active_percentage or 1

						local max = math.max(internal_bar_value, actual_active_percentage)

						arg_11_1.offset[1] = tbl_3.x - 7 + 553 * max
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "hp_bar",
					texture_id = "texture_id",
					content_id = "hp_bar",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 12
						return self.draw_health_bar
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "total_health_bar",
					texture_id = "texture_id",
					content_id = "total_health_bar",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 13
						return self.draw_health_bar
					end
				},
				{
					style_id = "grimoire_bar",
					pass_type = "texture_uv",
					content_id = "grimoire_bar",
					retained_mode = flag,
					content_change_function = function (self, arg_14_1)
						-- function 14
						local parent = self.parent
						local internal_bar_value = parent.hp_bar.internal_bar_value
						local actual_active_percentage = parent.actual_active_percentage

						actual_active_percentage = actual_active_percentage or 1

						local max = math.max(internal_bar_value, actual_active_percentage)
						local size = arg_14_1.size
						local uvs = self.uvs
						local offset = arg_14_1.offset
						local num = 553

						uvs[1][1] = max
						size[1] = num * (1 - max)
						offset[1] = 2 + tbl_3.x + num * max
					end
				}
			}
		},
		content = {
			grimoire_debuff_divider = "hud_player_hp_bar_grim_divider",
			hp_bar_highlight = "hud_player_hp_bar_highlight",
			visible = true,
			bar_start_side = "left",
			hp_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				texture_id = "dark_pact_boss_player_hp_bar_color_tint",
				draw_health_bar = true
			},
			total_health_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				texture_id = "dark_pact_boss_player_hp_bar",
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
				size = tbl,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_3.x + 1,
					tbl_3.y,
					tbl_3.z + 2
				}
			},
			hp_bar = {
				gradient_threshold = 1,
				size = tbl,
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_3.x + 1,
					tbl_3.y,
					tbl_3.z + 3
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
					tbl_3.x,
					tbl_3.y,
					tbl_3.z + 4
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
					tbl_3.x + 10,
					tbl_3.y - 8,
					tbl_3.z + 20
				}
			},
			hp_bar_highlight = {
				size = {
					156,
					16
				},
				offset = {
					tbl_3.x + 1,
					tbl_3.y + 27 - 2,
					tbl_3.z + 5
				},
				color = {
					0,
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

local tbl_8 = {
	portrait_static = UIWidgets.create_portrait_frame("portrait_pivot", "default", "-", num_3, flag),
	default_dynamic = fn_3(),
	default_static = fn(),
	health_dynamic = fn_4(),
	respawn_dynamic = fn_2(),
	versus_insignia_static = UIWidgets.create_small_insignia("insignia_pivot", 1, nil, nil, nil, flag)
}
local create_damage_widget = UnitFramesUiUtils.create_damage_widget("player", 4)
local tbl_9 = {
	ability = false,
	weapons = false,
	damage = true,
	equipment = false,
	respawn = true
}
local tbl_10 = {
	static = {
		default = "default_static",
		level = "default_static",
		versus_insignia = "versus_insignia_static",
		portrait_frame = "portrait_static"
	},
	dynamic = {
		default = "default_dynamic",
		damage = "damage_dynamic",
		status_icon = "default_dynamic",
		health = "health_dynamic",
		respawn = "respawn_dynamic"
	}
}

return {
	weapon_slot_widget_settings = tbl_7,
	inventory_index_by_slot = tbl_6,
	inventory_consumable_icons = tbl_5,
	features_list = tbl_9,
	widget_name_by_feature = tbl_10,
	scenegraph_definition = tbl_4,
	widget_definitions = tbl_8,
	damage_widget_definitions = create_damage_widget
}
