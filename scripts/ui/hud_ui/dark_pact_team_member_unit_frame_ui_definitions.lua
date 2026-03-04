-- chunkname: @scripts/ui/hud_ui/dark_pact_team_member_unit_frame_ui_definitions.lua

local var_0_0 = 1920
local var_0_1 = 1080
local var_0_2 = true
local var_0_3 = 1
local var_0_4 = 1
local var_0_5 = {
	root = {
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
	pivot_parent = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "left",
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
	pivot = {
		vertical_alignment = "top",
		parent = "pivot_parent",
		horizontal_alignment = "left",
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
	portrait_pivot = {
		vertical_alignment = "center",
		parent = "pivot",
		horizontal_alignment = "center",
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
	insignia_pivot_parent = {
		vertical_alignment = "top",
		parent = "root",
		horizontal_alignment = "left",
		position = {
			-40,
			0,
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

if PLATFORM ~= "win32" then
	var_0_5.root.scale = "hud_fit"
	var_0_5.root.is_root = nil
end

local var_0_6 = IS_WINDOWS and {
	wpn_grimoire_01 = "teammate_consumable_icon_grimoire",
	potion_cooldown_reduction_01 = "teammate_consumable_icon_speed",
	potion_healing_draught_01 = "teammate_consumable_icon_potion_01",
	grenade_frag_02 = "teammate_consumable_icon_frag",
	[3] = "teammate_consumable_icon_grenade_empty",
	grenade_frag_01 = "teammate_consumable_icon_frag",
	grenade_smoke_02 = "teammate_consumable_icon_smoke",
	grenade_smoke_01 = "teammate_consumable_icon_smoke",
	grenade_fire_01 = "teammate_consumable_icon_fire",
	grenade_fire_02 = "teammate_consumable_icon_fire",
	[1] = "teammate_consumable_icon_medpack_empty",
	[2] = "teammate_consumable_icon_potion_empty",
	wpn_side_objective_tome_01 = "teammate_consumable_icon_book",
	potion_damage_boost_01 = "teammate_consumable_icon_strength",
	healthkit_first_aid_kit_01 = "teammate_consumable_icon_medpack",
	potion_speed_boost_01 = "teammate_consumable_icon_speed"
} or {
	wpn_grimoire_01 = "consumables_grimoire",
	potion_cooldown_reduction_01 = "consumables_speed",
	potion_healing_draught_01 = "consumables_potion_01",
	grenade_frag_02 = "consumables_frag",
	[3] = "default_potion_icon",
	grenade_frag_01 = "consumables_frag",
	grenade_smoke_02 = "consumables_smoke",
	grenade_smoke_01 = "consumables_smoke",
	grenade_fire_01 = "consumables_fire",
	grenade_fire_02 = "consumables_fire",
	[1] = "default_heal_icon",
	[2] = "default_grenade_icon",
	wpn_side_objective_tome_01 = "consumables_book",
	potion_damage_boost_01 = "consumables_strength",
	healthkit_first_aid_kit_01 = "consumables_medpack",
	potion_speed_boost_01 = "consumables_speed"
}
local var_0_7 = IS_WINDOWS and {
	slot_healthkit = 1,
	slot_grenade = 3,
	slot_potion = 2
} or {
	slot_potion = 3,
	slot_grenade = 2,
	slot_healthkit = 1
}
local var_0_8 = {
	ammo_fields = {
		slot_ranged = "ammo_text_weapon_slot_2",
		slot_melee = "ammo_text_weapon_slot_1"
	}
}
local var_0_9 = 1
local var_0_10 = {
	var_0_9 * 92,
	var_0_9 * 9
}
local var_0_11 = {
	-(var_0_10[1] / 2),
	-25 * var_0_9,
	0
}

local function var_0_12()
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					style_id = "character_portrait",
					texture_id = "character_portrait",
					pass_type = "texture",
					retained_mode = var_0_2,
					content_change_function = function (arg_2_0, arg_2_1)
						arg_2_1.color = arg_2_0.dim_portraits and Colors.get_color_table_with_alpha("dim_gray", 255) or Colors.get_color_table_with_alpha("white", 255)
					end
				},
				{
					style_id = "player_level",
					pass_type = "text",
					text_id = "player_level",
					retained_mode = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "host_icon",
					texture_id = "host_icon",
					retained_mode = var_0_2,
					content_check_function = function (arg_3_0)
						return arg_3_0.is_host
					end
				},
				{
					style_id = "player_name",
					pass_type = "text",
					text_id = "player_name",
					retained_mode = var_0_2
				},
				{
					style_id = "player_name_shadow",
					pass_type = "text",
					text_id = "player_name",
					retained_mode = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_bg",
					texture_id = "hp_bar_bg",
					retained_mode = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "hp_bar_fg",
					texture_id = "hp_bar_fg",
					retained_mode = var_0_2
				}
			}
		},
		content = {
			character_portrait = "unit_frame_portrait_default",
			player_name = "n/a",
			host_icon = "host_icon",
			hp_bar_bg = "hud_teammate_hp_bar_bg",
			is_host = false,
			player_level = "",
			hp_bar_fg = "hud_teammate_hp_bar_frame_dark_pact"
		},
		style = {
			character_portrait = {
				size = {
					86 * var_0_3,
					108 * var_0_3
				},
				offset = {
					-43 * var_0_3,
					-54 * var_0_3 + 55 * var_0_3,
					0
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
					-65,
					-2,
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
				vertical_alignment = "top",
				font_type = "hell_shark",
				font_size = 14,
				horizontal_alignment = "center",
				text_color = Colors.get_table("cheeseburger"),
				offset = {
					var_0_11[1],
					var_0_11[2] - 130,
					var_0_11[3] + 15
				}
			},
			player_name = {
				vertical_alignment = "bottom",
				font_type = "arial",
				font_size = 18,
				text_color = Colors.get_table("white"),
				horizontal_alignment = IS_PS4 and "left" or "center",
				offset = {
					IS_PS4 and -43 * var_0_3 or 0,
					110 * var_0_3,
					var_0_11[3] + 15
				}
			},
			player_name_shadow = {
				vertical_alignment = "bottom",
				font_type = "arial",
				font_size = 18,
				text_color = Colors.get_table("black"),
				horizontal_alignment = IS_PS4 and "left" or "center",
				offset = {
					(IS_PS4 and -43 * var_0_3 or 0) + 2,
					110 * var_0_3 - 2,
					var_0_11[3] + 14
				}
			},
			hp_bar_bg = {
				size = {
					100,
					17
				},
				offset = {
					var_0_11[1] + var_0_10[1] / 2 - 50,
					var_0_11[2] + var_0_10[2] / 2 - 8.5,
					var_0_11[3] + 15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			hp_bar_fg = {
				size = {
					100,
					24
				},
				offset = {
					var_0_11[1] + var_0_10[1] / 2 - 50,
					var_0_11[2] + var_0_10[2] / 2 - 8.5 - 7,
					var_0_11[3] + 20
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
			-55 * var_0_3,
			0
		}
	}
end

local function var_0_13()
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					style_id = "portrait_icon",
					texture_id = "portrait_icon",
					pass_type = "texture",
					retained_mode = var_0_2,
					content_check_function = function (arg_5_0)
						return arg_5_0.display_portrait_icon
					end,
					content_change_function = function (arg_6_0, arg_6_1)
						arg_6_1.staturated = arg_6_0.state == "countdown"
					end
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator",
					texture_id = "talk_indicator",
					retained_mode = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_glow",
					texture_id = "talk_indicator_glow",
					retained_mode = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_highlight",
					texture_id = "talk_indicator_highlight",
					retained_mode = var_0_2
				},
				{
					pass_type = "texture",
					style_id = "talk_indicator_highlight_glow",
					texture_id = "talk_indicator_highlight_glow",
					retained_mode = var_0_2
				},
				{
					pass_type = "rotated_texture",
					style_id = "connecting_icon",
					texture_id = "connecting_icon",
					retained_mode = var_0_2,
					content_check_function = function (arg_7_0)
						return arg_7_0.connecting
					end
				},
				{
					style_id = "respawn_countdown_text",
					pass_type = "text",
					text_id = "respawn_countdown_text",
					retained_mode = false,
					content_check_function = function (arg_8_0)
						return arg_8_0.state == "countdown" or arg_8_0.state == "fadeout"
					end
				}
			}
		},
		content = {
			talk_indicator_highlight = "voip_wave",
			connecting = false,
			display_portrait_icon = false,
			state = "hidden",
			bar_start_side = "left",
			portrait_icon = "status_icon_needs_assist",
			respawn_timer = 0,
			total_countdown_time = 0,
			display_portrait_overlay = false,
			last_counts = 4,
			connecting_icon = "matchmaking_connecting_icon",
			talk_indicator_highlight_glow = "voip_wave_glow",
			talk_indicator = "voip_speaker",
			respawn_countdown_text = "",
			total_fadeout_time = 0,
			talk_indicator_glow = "voip_speaker_glow"
		},
		style = {
			talk_indicator = {
				size = {
					64,
					64
				},
				offset = {
					60,
					30,
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
				size = {
					64,
					64
				},
				offset = {
					60,
					30,
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
				size = {
					64,
					64
				},
				offset = {
					60,
					30,
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
				size = {
					64,
					64
				},
				offset = {
					60,
					30,
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
				angle = 0,
				size = {
					53,
					53
				},
				offset = {
					-25,
					34,
					15
				},
				color = {
					255,
					255,
					255,
					255
				},
				pivot = {
					27,
					27
				}
			},
			portrait_icon = {
				size = {
					86 * var_0_3,
					108 * var_0_3
				},
				offset = {
					-(86 * var_0_3) / 2,
					0,
					1
				},
				color = {
					150,
					255,
					255,
					255
				}
			},
			respawn_countdown_text = {
				font_size = 72,
				scenegraph_id = "portrait_pivot",
				word_wrap = true,
				use_shadow = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				size = {
					86 * var_0_3,
					108 * var_0_3
				},
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-(86 * var_0_3) / 2,
					-(108 * var_0_3) / 2,
					50
				},
				shadow_offset = {
					2,
					2,
					0
				}
			}
		},
		offset = {
			0,
			-55 * var_0_3,
			0
		}
	}
end

local function var_0_14()
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {}
		},
		content = {},
		style = {},
		offset = {
			50,
			-55,
			0
		}
	}
end

local function var_0_15()
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "hp_bar_highlight",
					texture_id = "hp_bar_highlight",
					retained_mode = var_0_2,
					content_check_function = function (arg_11_0, arg_11_1)
						return not arg_11_0.has_shield
					end
				},
				{
					style_id = "grimoire_debuff_divider",
					texture_id = "grimoire_debuff_divider",
					pass_type = "texture",
					retained_mode = var_0_2,
					content_check_function = function (arg_12_0)
						return arg_12_0.hp_bar.draw_health_bar
					end,
					content_change_function = function (arg_13_0, arg_13_1)
						local var_13_0 = arg_13_0.hp_bar.internal_bar_value
						local var_13_1 = arg_13_0.actual_active_percentage or 1
						local var_13_2 = math.max(var_13_0, var_13_1)

						arg_13_1.offset[1] = var_0_11[1] + var_0_10[1] * var_13_2
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "hp_bar",
					texture_id = "texture_id",
					content_id = "hp_bar",
					retained_mode = var_0_2,
					content_check_function = function (arg_14_0)
						return arg_14_0.draw_health_bar
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "total_health_bar",
					texture_id = "texture_id",
					content_id = "total_health_bar",
					retained_mode = var_0_2,
					content_check_function = function (arg_15_0)
						return arg_15_0.draw_health_bar
					end
				},
				{
					style_id = "grimoire_bar",
					pass_type = "texture_uv",
					content_id = "grimoire_bar",
					retained_mode = var_0_2,
					content_change_function = function (arg_16_0, arg_16_1)
						local var_16_0 = arg_16_0.parent
						local var_16_1 = var_16_0.hp_bar.internal_bar_value
						local var_16_2 = var_16_0.actual_active_percentage or 1
						local var_16_3 = math.max(var_16_1, var_16_2)
						local var_16_4 = arg_16_1.size
						local var_16_5 = arg_16_0.uvs
						local var_16_6 = arg_16_1.offset
						local var_16_7 = var_0_10[1]

						var_16_5[1][1] = var_16_3
						var_16_4[1] = var_16_7 * (1 - var_16_3)
						var_16_6[1] = 2 + var_0_11[1] + var_16_7 * var_16_3
					end
				},
				{
					pass_type = "texture",
					style_id = "hp_bar",
					texture_id = "hp_bar_mask",
					retained_mode = var_0_2,
					content_check_function = function (arg_17_0)
						return arg_17_0.hp_bar.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "portrait_icon",
					texture_id = "portrait_icon",
					retained_mode = var_0_2,
					content_check_function = function (arg_18_0)
						return arg_18_0.display_portrait_icon
					end
				}
			}
		},
		content = {
			grimoire_debuff_divider = "hud_teammate_hp_bar_grim_divider",
			hp_bar_highlight = "hud_teammate_hp_bar_highlight",
			bar_start_side = "left",
			hp_bar_mask = "teammate_hp_bar_mask",
			hp_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				texture_id = "teammate_hp_bar_color_tint_1",
				draw_health_bar = true
			},
			total_health_bar = {
				bar_value = 1,
				internal_bar_value = 0,
				texture_id = "teammate_hp_bar_1",
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
					var_0_10[1],
					var_0_10[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_0_11[1],
					var_0_11[2],
					var_0_11[3] + 17
				}
			},
			hp_bar = {
				gradient_threshold = 1,
				size = {
					var_0_10[1],
					var_0_10[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_0_11[1],
					var_0_11[2],
					var_0_11[3] + 18
				}
			},
			grimoire_bar = {
				size = {
					var_0_10[1],
					var_0_10[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_0_11[1],
					var_0_11[2],
					var_0_11[3] + 19
				}
			},
			grimoire_debuff_divider = {
				masked = true,
				size = {
					3,
					28
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_0_11[1],
					var_0_11[2],
					23
				}
			},
			hp_bar_highlight = {
				size = {
					100,
					17
				},
				offset = {
					var_0_11[1] + var_0_10[1] / 2 - 50,
					var_0_11[2] - 7,
					var_0_11[3] + 20
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
			-55 * var_0_3,
			0
		}
	}
end

local var_0_16 = {
	portrait_static = UIWidgets.create_portrait_frame("portrait_pivot", "default", "-", var_0_3, var_0_2),
	default_dynamic = var_0_13(),
	default_static = var_0_12(),
	health_dynamic = var_0_15(),
	versus_insignia_static = UIWidgets.create_small_insignia("insignia_pivot", 1, nil, nil, nil, var_0_2)
}
local var_0_17 = {
	equipment = false,
	ammo = false,
	damage = true,
	ability = false
}
local var_0_18 = {
	static = {
		default = "default_static",
		player_name = "default_static",
		versus_insignia = "versus_insignia_static",
		portrait_frame = "portrait_static",
		level = "default_static"
	},
	dynamic = {
		default = "default_dynamic",
		damage = "damage_dynamic",
		status_icon = "default_dynamic",
		health = "health_dynamic"
	}
}
local var_0_19 = UnitFramesUiUtils.create_damage_widget("team", 4)

return {
	weapon_slot_widget_settings = var_0_8,
	inventory_index_by_slot = var_0_7,
	inventory_consumable_icons = var_0_6,
	features_list = var_0_17,
	widget_name_by_feature = var_0_18,
	scenegraph_definition = var_0_5,
	widget_definitions = var_0_16,
	damage_widget_definitions = var_0_19
}
