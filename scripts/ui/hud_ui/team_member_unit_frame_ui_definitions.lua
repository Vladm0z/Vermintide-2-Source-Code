-- chunkname: @scripts/ui/hud_ui/team_member_unit_frame_ui_definitions.lua

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
	portrait_pivot_parent = {
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
		parent = "portrait_pivot_parent",
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
	pivot_dragger = {
		parent = "pivot",
		position = {
			0,
			0,
			0
		},
		size = {
			100,
			200
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
					pass_type = "texture",
					style_id = "character_portrait",
					texture_id = "character_portrait",
					retained_mode = var_0_2
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
					content_check_function = function(arg_2_0)
						return arg_2_0.is_host
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
				},
				{
					pass_type = "texture",
					style_id = "ability_bar_bg",
					texture_id = "ability_bar_bg",
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
			hp_bar_fg = "hud_teammate_hp_bar_frame",
			ability_bar_bg = "hud_teammate_ability_bar_bg"
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
			},
			ability_bar_bg = {
				size = {
					92,
					5
				},
				offset = {
					var_0_11[1] + var_0_10[1] / 2 - 46,
					var_0_11[2] - 9,
					var_0_11[3] + 15
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
					pass_type = "texture",
					style_id = "portrait_icon",
					texture_id = "portrait_icon",
					retained_mode = var_0_2,
					content_check_function = function(arg_4_0)
						return arg_4_0.display_portrait_icon
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
					content_check_function = function(arg_5_0)
						return arg_5_0.connecting
					end
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator",
					texture_id = "ammo_indicator",
					retained_mode = var_0_2,
					content_check_function = function(arg_6_0)
						local var_6_0 = arg_6_0.ammo_percent

						return var_6_0 and var_6_0 > 0 and var_6_0 <= 0.33
					end
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator",
					texture_id = "ammo_indicator_empty",
					retained_mode = var_0_2,
					content_check_function = function(arg_7_0)
						local var_7_0 = arg_7_0.ammo_percent

						return var_7_0 and var_7_0 <= 0
					end
				},
				{
					style_id = "respawn_countdown_text",
					pass_type = "text",
					text_id = "respawn_countdown_text",
					retained_mode = false,
					content_check_function = function(arg_8_0)
						return true
					end
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator",
					texture_id = "numeric_ui_ammo_indicator",
					retained_mode = var_0_2,
					content_check_function = function(arg_9_0)
						local var_9_0 = arg_9_0.ammo_percent
						local var_9_1 = var_9_0 and (var_9_0 > 0 and var_9_0 <= 0.33 or var_9_0 <= 0)

						return Application.user_setting("numeric_ui") and arg_9_0.has_ranged_weapon and not var_9_1
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_cooldown_indicator",
					texture_id = "ability_cooldown_indicator",
					retained_mode = var_0_2,
					content_check_function = function(arg_10_0)
						return Application.user_setting("numeric_ui") and arg_10_0.on_cooldown
					end
				},
				{
					style_id = "ammo_count",
					pass_type = "text",
					text_id = "ammo_count",
					retained_mode = var_0_2,
					content_check_function = function(arg_11_0)
						return Application.user_setting("numeric_ui") and arg_11_0.has_ranged_weapon
					end
				},
				{
					style_id = "ammo_count_shadow",
					pass_type = "text",
					text_id = "ammo_count",
					retained_mode = var_0_2,
					content_check_function = function(arg_12_0)
						return Application.user_setting("numeric_ui") and arg_12_0.has_ranged_weapon
					end
				},
				{
					style_id = "ability_cooldown",
					pass_type = "text",
					text_id = "ability_cooldown",
					retained_mode = var_0_2,
					content_check_function = function(arg_13_0)
						return Application.user_setting("numeric_ui") and arg_13_0.on_cooldown
					end
				},
				{
					style_id = "ability_cooldown_shadow",
					pass_type = "text",
					text_id = "ability_cooldown",
					retained_mode = var_0_2,
					content_check_function = function(arg_14_0)
						return Application.user_setting("numeric_ui") and arg_14_0.on_cooldown
					end
				},
				{
					pass_type = "texture",
					style_id = "brush_stroke",
					texture_id = "brush_stroke",
					retained_mode = var_0_2,
					content_check_function = function(arg_15_0)
						return Application.user_setting("numeric_ui")
					end
				}
			}
		},
		content = {
			talk_indicator_highlight = "voip_wave",
			ability_cooldown_indicator = "numeric_ui_ultimatecd_icon",
			display_portrait_icon = false,
			state = "hidden",
			brush_stroke = "numeric_ui_brush_stroke",
			portrait_icon = "status_icon_needs_assist",
			can_use_ability = false,
			total_countdown_time = 0,
			ammo_indicator_empty = "unit_frame_ammo_empty",
			respawn_countdown_text = "",
			connecting_icon = "matchmaking_connecting_icon",
			talk_indicator_highlight_glow = "voip_wave_glow",
			respawn_timer = 0,
			on_cooldown = false,
			last_counts = 4,
			talk_indicator_glow = "voip_speaker_glow",
			ability_cooldown = "",
			connecting = false,
			total_fadeout_time = 0.66,
			bar_start_side = "left",
			has_ranged_weapon = false,
			display_portrait_overlay = false,
			numeric_ui_ammo_indicator = "unit_frame_ammo",
			talk_indicator = "voip_speaker",
			ammo_count = "",
			ammo_indicator = "unit_frame_ammo_low",
			ammo_bar = {
				bar_value = 1,
				texture_id = "hud_teammate_ammo_bar_fill",
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
			ammo_indicator = {
				size = {
					32,
					32
				},
				offset = {
					60,
					-40,
					5
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
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
				vertical_alignment = "center",
				scenegraph_id = "portrait_pivot",
				horizontal_alignment = "center",
				font_type = "hell_shark",
				font_size = 64,
				text_color = {
					255,
					255,
					168,
					0
				},
				offset = {
					0,
					0,
					16
				}
			},
			ability_cooldown_indicator = {
				size = {
					32,
					32
				},
				offset = {
					60,
					var_0_11[2] + var_0_10[2] / 2 - 6 - 1 + 1 - 45,
					5
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			ammo_count = {
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				font_size = 18,
				horizontal_alignment = "left",
				text_color = {
					255,
					250,
					250,
					250
				},
				offset = {
					var_0_11[1] + var_0_10[1] + 50,
					var_0_11[2] + var_0_10[2] / 2 - 8.5 - 1 + 1,
					var_0_11[3] + 22
				},
				size = var_0_10
			},
			ammo_count_shadow = {
				vertical_alignment = "center",
				font_type = "hell_shark_header",
				font_size = 18,
				horizontal_alignment = "left",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					var_0_11[1] + var_0_10[1] + 50 + 1,
					var_0_11[2] + var_0_10[2] / 2 - 8.5 - 1 + 1,
					var_0_11[3] + 21
				},
				size = var_0_10
			},
			ability_cooldown = {
				vertical_alignment = "center",
				font_size = 18,
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = "hell_shark_header",
				text_color = {
					255,
					250,
					250,
					250
				},
				offset = {
					var_0_11[1] + var_0_10[1] + 50,
					var_0_11[2] + var_0_10[2] / 2 - 6 - 1 + 1 - 32,
					var_0_11[3] + 22
				},
				size = var_0_10
			},
			ability_cooldown_shadow = {
				vertical_alignment = "center",
				font_size = 18,
				horizontal_alignment = "left",
				word_wrap = true,
				font_type = "hell_shark_header",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					var_0_11[1] + var_0_10[1] + 50 + 1,
					var_0_11[2] + var_0_10[2] / 2 - 6 - 1 + 1 - 32,
					var_0_11[3] + 21
				},
				size = var_0_10
			},
			brush_stroke = {
				size = {
					210,
					74
				},
				offset = {
					-60,
					-76,
					0
				},
				color = {
					255,
					0,
					0,
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
					style_id = "item_slot_1",
					texture_id = "item_slot_1",
					retained_mode = var_0_2,
					content_check_function = function(arg_18_0)
						return arg_18_0.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_bg_1",
					texture_id = "item_slot_bg_1",
					retained_mode = var_0_2,
					content_check_function = function(arg_19_0)
						return arg_19_0.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_frame_1",
					texture_id = "slot_frame",
					retained_mode = var_0_2,
					content_check_function = function(arg_20_0)
						return arg_20_0.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_highlight_1",
					texture_id = "item_slot_highlight",
					retained_mode = var_0_2,
					content_check_function = function(arg_21_0)
						return arg_21_0.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_2",
					texture_id = "item_slot_2",
					retained_mode = var_0_2,
					content_check_function = function(arg_22_0)
						return arg_22_0.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_bg_2",
					texture_id = "item_slot_bg_2",
					retained_mode = var_0_2,
					content_check_function = function(arg_23_0)
						return arg_23_0.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_frame_2",
					texture_id = "slot_frame",
					retained_mode = var_0_2,
					content_check_function = function(arg_24_0)
						return arg_24_0.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_highlight_2",
					texture_id = "item_slot_highlight",
					retained_mode = var_0_2,
					content_check_function = function(arg_25_0)
						return arg_25_0.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_3",
					texture_id = "item_slot_3",
					retained_mode = var_0_2,
					content_check_function = function(arg_26_0)
						return arg_26_0.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_bg_3",
					texture_id = "item_slot_bg_3",
					retained_mode = var_0_2,
					content_check_function = function(arg_27_0)
						return arg_27_0.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_frame_3",
					texture_id = "slot_frame",
					retained_mode = var_0_2,
					content_check_function = function(arg_28_0)
						return arg_28_0.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_highlight_3",
					texture_id = "item_slot_highlight",
					retained_mode = var_0_2,
					content_check_function = function(arg_29_0)
						return arg_29_0.draw_health_bar
					end
				},
				{
					style_id = "item_count_1",
					pass_type = "text",
					text_id = "item_count_1",
					retained_mode = var_0_2,
					content_check_function = function(arg_30_0, arg_30_1)
						return arg_30_0.draw_health_bar and arg_30_0.item_count_1
					end
				},
				{
					style_id = "item_count_shadow_1",
					pass_type = "text",
					text_id = "item_count_1",
					retained_mode = var_0_2,
					content_check_function = function(arg_31_0, arg_31_1)
						return arg_31_0.draw_health_bar and arg_31_0.item_count_1
					end
				},
				{
					style_id = "item_count_2",
					pass_type = "text",
					text_id = "item_count_2",
					retained_mode = var_0_2,
					content_check_function = function(arg_32_0, arg_32_1)
						return arg_32_0.draw_health_bar and arg_32_0.item_count_2
					end
				},
				{
					style_id = "item_count_shadow_2",
					pass_type = "text",
					text_id = "item_count_2",
					retained_mode = var_0_2,
					content_check_function = function(arg_33_0, arg_33_1)
						return arg_33_0.draw_health_bar and arg_33_0.item_count_2
					end
				},
				{
					style_id = "item_count_3",
					pass_type = "text",
					text_id = "item_count_3",
					retained_mode = var_0_2,
					content_check_function = function(arg_34_0, arg_34_1)
						return arg_34_0.draw_health_bar and arg_34_0.item_count_3
					end
				},
				{
					style_id = "item_count_shadow_3",
					pass_type = "text",
					text_id = "item_count_3",
					retained_mode = var_0_2,
					content_check_function = function(arg_35_0, arg_35_1)
						return arg_35_0.draw_health_bar and arg_35_0.item_count_3
					end
				}
			}
		},
		content = {
			item_slot_2 = "icons_placeholder",
			item_slot_1 = "icons_placeholder",
			item_slot_bg_2 = "hud_inventory_slot_bg_small_01",
			draw_health_bar = true,
			item_slot_bg_3 = "hud_inventory_slot_bg_small_01",
			item_slot_highlight = "hud_inventory_slot_small_pickup",
			slot_frame = "hud_inventory_slot_small",
			item_slot_bg_1 = "hud_inventory_slot_bg_small_01",
			item_slot_3 = "icons_placeholder"
		},
		style = {
			item_slot_bg_1 = {
				size = {
					29 * var_0_4,
					29 * var_0_4
				},
				offset = {
					-35,
					0,
					7
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			item_slot_frame_1 = {
				size = {
					29 * var_0_4,
					29 * var_0_4
				},
				offset = {
					-35,
					0,
					15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			item_slot_1 = {
				size = {
					25,
					25
				},
				offset = {
					-32.5,
					2,
					8
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			item_slot_highlight_1 = {
				size = {
					29 * var_0_4,
					29 * var_0_4
				},
				offset = {
					-35,
					0,
					10
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			item_slot_bg_2 = {
				size = {
					29 * var_0_4,
					29 * var_0_4
				},
				offset = {
					0,
					0,
					7
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			item_slot_frame_2 = {
				size = {
					29 * var_0_4,
					29 * var_0_4
				},
				offset = {
					0,
					0,
					15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			item_slot_2 = {
				size = {
					25,
					25
				},
				offset = {
					2.5,
					2,
					8
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			item_slot_highlight_2 = {
				size = {
					29 * var_0_4,
					29 * var_0_4
				},
				offset = {
					0,
					0,
					10
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			item_slot_bg_3 = {
				size = {
					29 * var_0_4,
					29 * var_0_4
				},
				offset = {
					35,
					0,
					7
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			item_slot_frame_3 = {
				size = {
					29 * var_0_4,
					29 * var_0_4
				},
				offset = {
					35,
					0,
					15
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			item_slot_3 = {
				size = {
					25,
					25
				},
				offset = {
					37.5,
					2,
					8
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			item_slot_highlight_3 = {
				size = {
					29 * var_0_4,
					29 * var_0_4
				},
				offset = {
					35,
					0,
					10
				},
				color = {
					0,
					255,
					255,
					255
				}
			},
			item_count_1 = {
				vertical_alignment = "bottom",
				font_size = 14,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					-9,
					-1,
					12
				}
			},
			item_count_shadow_1 = {
				vertical_alignment = "bottom",
				font_size = 14,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					-8,
					0,
					11
				}
			},
			item_count_2 = {
				vertical_alignment = "bottom",
				font_size = 14,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					26,
					-1,
					12
				}
			},
			item_count_shadow_2 = {
				vertical_alignment = "bottom",
				font_size = 14,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					27,
					0,
					11
				}
			},
			item_count_3 = {
				vertical_alignment = "bottom",
				font_size = 14,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("white", 255),
				offset = {
					61,
					-1,
					12
				}
			},
			item_count_shadow_3 = {
				vertical_alignment = "bottom",
				font_size = 14,
				localize = false,
				horizontal_alignment = "right",
				word_wrap = false,
				font_type = "hell_shark",
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					62,
					0,
					11
				}
			}
		},
		offset = {
			-15,
			var_0_11[2] - 96,
			0
		}
	}
end

local function var_0_16()
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "hp_bar_highlight",
					texture_id = "hp_bar_highlight",
					retained_mode = var_0_2,
					content_check_function = function(arg_37_0, arg_37_1)
						return not arg_37_0.has_shield
					end
				},
				{
					style_id = "grimoire_debuff_divider",
					texture_id = "grimoire_debuff_divider",
					pass_type = "texture",
					retained_mode = var_0_2,
					content_check_function = function(arg_38_0)
						return arg_38_0.hp_bar.draw_health_bar
					end,
					content_change_function = function(arg_39_0, arg_39_1)
						local var_39_0 = arg_39_0.hp_bar.internal_bar_value
						local var_39_1 = arg_39_0.actual_active_percentage or 1
						local var_39_2 = math.max(var_39_0, var_39_1)

						arg_39_1.offset[1] = var_0_11[1] + var_0_10[1] * var_39_2
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "hp_bar",
					texture_id = "texture_id",
					content_id = "hp_bar",
					retained_mode = var_0_2,
					content_check_function = function(arg_40_0)
						return arg_40_0.draw_health_bar
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "total_health_bar",
					texture_id = "texture_id",
					content_id = "total_health_bar",
					retained_mode = var_0_2,
					content_check_function = function(arg_41_0)
						return arg_41_0.draw_health_bar
					end
				},
				{
					style_id = "grimoire_bar",
					pass_type = "texture_uv",
					content_id = "grimoire_bar",
					retained_mode = var_0_2,
					content_change_function = function(arg_42_0, arg_42_1)
						local var_42_0 = arg_42_0.parent
						local var_42_1 = var_42_0.hp_bar.internal_bar_value
						local var_42_2 = var_42_0.actual_active_percentage or 1
						local var_42_3 = math.max(var_42_1, var_42_2)
						local var_42_4 = arg_42_1.size
						local var_42_5 = arg_42_0.uvs
						local var_42_6 = arg_42_1.offset
						local var_42_7 = var_0_10[1]

						var_42_5[1][1] = var_42_3
						var_42_4[1] = var_42_7 * (1 - var_42_3)
						var_42_6[1] = 2 + var_0_11[1] + var_42_7 * var_42_3
					end
				},
				{
					pass_type = "texture",
					style_id = "hp_bar",
					texture_id = "hp_bar_mask",
					retained_mode = var_0_2,
					content_check_function = function(arg_43_0)
						return arg_43_0.hp_bar.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					texture_id = "portrait_icon",
					retained_mode = var_0_2,
					content_check_function = function(arg_44_0)
						return arg_44_0.display_portrait_icon
					end
				},
				{
					style_id = "numeric_health",
					pass_type = "text",
					text_id = "numeric_health",
					retained_mode = var_0_2,
					content_check_function = function(arg_45_0)
						return Application.user_setting("numeric_ui")
					end
				},
				{
					style_id = "numeric_health_shadow",
					pass_type = "text",
					text_id = "numeric_health",
					retained_mode = var_0_2,
					content_check_function = function(arg_46_0)
						return Application.user_setting("numeric_ui")
					end
				}
			}
		},
		content = {
			grimoire_debuff_divider = "hud_teammate_hp_bar_grim_divider",
			hp_bar_highlight = "hud_teammate_hp_bar_highlight",
			bar_start_side = "left",
			numeric_health = "-/-",
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
			},
			numeric_health = {
				vertical_alignment = "center",
				font_size = 12,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "arial",
				text_color = {
					255,
					250,
					250,
					250
				},
				offset = {
					var_0_11[1] - 4,
					var_0_11[2] - 10,
					var_0_11[3] + 22
				},
				size = {
					100,
					30
				}
			},
			numeric_health_shadow = {
				vertical_alignment = "center",
				font_size = 12,
				horizontal_alignment = "center",
				word_wrap = true,
				font_type = "arial",
				text_color = {
					255,
					0,
					0,
					0
				},
				offset = {
					var_0_11[1] - 4 + 1,
					var_0_11[2] - 10 + 1,
					var_0_11[3] + 21
				},
				size = {
					100,
					30
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

local function var_0_17()
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					style_id = "ability_bar",
					pass_type = "texture_uv",
					content_id = "ability_bar",
					retained_mode = var_0_2,
					content_change_function = function(arg_48_0, arg_48_1)
						local var_48_0 = arg_48_0.bar_value
						local var_48_1 = arg_48_1.size
						local var_48_2 = arg_48_0.uvs
						local var_48_3 = 92

						var_48_2[2][2] = var_48_0
						var_48_1[1] = var_48_3 * var_48_0
					end
				}
			}
		},
		content = {
			bar_start_side = "left",
			ability_bar = {
				bar_value = 1,
				texture_id = "hud_teammate_ability_bar_fill",
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
					92,
					5
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					var_0_11[1] + var_0_10[1] / 2 - 46,
					var_0_11[2] - 9,
					var_0_11[3] + 18
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

local var_0_18 = {
	loadout_dynamic = var_0_15(),
	portrait_static = UIWidgets.create_portrait_frame("portrait_pivot", "default", "-", var_0_3, var_0_2),
	default_dynamic = var_0_13(),
	default_static = var_0_12(),
	health_dynamic = var_0_16(),
	ability_dynamic = var_0_17(),
	versus_insignia_static = UIWidgets.create_small_insignia("insignia_pivot", 0, nil, nil, nil, var_0_2)
}
local var_0_19 = {
	equipment = true,
	ammo = true,
	damage = false,
	ability = true
}
local var_0_20 = {
	static = {
		default = "default_static",
		player_name = "default_static",
		versus_insignia = "versus_insignia_static",
		portrait_frame = "portrait_static",
		level = "default_static"
	},
	dynamic = {
		default = "default_dynamic",
		weapons = "loadout_dynamic",
		status_icon = "default_dynamic",
		health = "health_dynamic",
		equipment = "loadout_dynamic",
		ammo = "default_dynamic",
		ability = "ability_dynamic",
		damage = "damage_dynamic"
	}
}

return {
	weapon_slot_widget_settings = var_0_8,
	inventory_index_by_slot = var_0_7,
	inventory_consumable_icons = var_0_6,
	features_list = var_0_19,
	widget_name_by_feature = var_0_20,
	scenegraph_definition = var_0_5,
	widget_definitions = var_0_18
}
