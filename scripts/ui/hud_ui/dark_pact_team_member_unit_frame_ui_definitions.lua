-- chunkname: @scripts/ui/hud_ui/dark_pact_team_member_unit_frame_ui_definitions.lua

local num = 1920
local num_2 = 1080
local flag = true
local num_3 = 1
local num_4 = 1
local tbl = {
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
	tbl.root.scale = "hud_fit"
	tbl.root.is_root = nil
end

local tbl_2

if not IS_WINDOWS then
	tbl_2 = {
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
	}

	if not tbl_2 then
		-- Nothing
	end
end

tbl_2 = {
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

do
	local tbl_3
end

::label_0_0::

if not IS_WINDOWS then
	tbl_3 = {
		slot_healthkit = 1,
		slot_grenade = 3,
		slot_potion = 2
	}

	if not tbl_3 then
		-- Nothing
	end
end

tbl_3 = {
	slot_potion = 3,
	slot_grenade = 2,
	slot_healthkit = 1
}

::label_0_1::

local tbl_4 = {
	ammo_fields = {
		slot_ranged = "ammo_text_weapon_slot_2",
		slot_melee = "ammo_text_weapon_slot_1"
	}
}
local num_5 = 1
local tbl_5 = {
	num_5 * 92,
	num_5 * 9
}
local tbl_6 = {
	-(tbl_5[1] / 2),
	-25 * num_5,
	0
}

local function fn()
	-- function 1
	local tbl = {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					style_id = "character_portrait",
					texture_id = "character_portrait",
					pass_type = "texture",
					retained_mode = flag,
					content_change_function = function (self, arg_2_1)
						-- function 2
						local get_color_table_with_alpha

						if not self.dim_portraits then
							get_color_table_with_alpha = Colors.get_color_table_with_alpha("dim_gray", 255)

							if not get_color_table_with_alpha then
								-- Nothing
							end
						end

						get_color_table_with_alpha = Colors.get_color_table_with_alpha("white", 255)

						::label_2_0::

						arg_2_1.color = get_color_table_with_alpha
					end
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
						-- function 3
						return self.is_host
					end
				},
				{
					style_id = "player_name",
					pass_type = "text",
					text_id = "player_name",
					retained_mode = flag
				},
				{
					style_id = "player_name_shadow",
					pass_type = "text",
					text_id = "player_name",
					retained_mode = flag
				},
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
		}
	}
	local tbl_2 = {
		character_portrait = {
			size = {
				86 * num_3,
				108 * num_3
			},
			offset = {
				-43 * num_3,
				-54 * num_3 + 55 * num_3,
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
				tbl_6[1],
				tbl_6[2] - 130,
				tbl_6[3] + 15
			}
		}
	}
	local tbl_3 = {
		vertical_alignment = "bottom",
		font_type = "arial",
		font_size = 18,
		text_color = Colors.get_table("white")
	}
	local flag_2

	flag_2 = not IS_PS4 and "left" and "center"
	tbl_3.horizontal_alignment = flag_2

	local tbl_4 = {}
	local num

	if not IS_PS4 then
		num = -43 * num_3

		if not num then
			-- Nothing
		end
	end

	num = 0

	::label_1_0::

	tbl_4[1] = num
	tbl_4[2] = 110 * num_3
	tbl_4[3] = tbl_6[3] + 15
	tbl_3.offset = tbl_4
	tbl_2.player_name = tbl_3

	local tbl_7 = {
		vertical_alignment = "bottom",
		font_type = "arial",
		font_size = 18,
		text_color = Colors.get_table("black")
	}
	local flag_3

	flag_3 = not IS_PS4 and "left" and "center"
	tbl_7.horizontal_alignment = flag_3

	local tbl_8 = {}
	local num_2

	if not IS_PS4 then
		num_2 = -43 * num_3

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = 0

	::label_1_1::

	tbl_8[1] = num_2 + 2
	tbl_8[2] = 110 * num_3 - 2
	tbl_8[3] = tbl_6[3] + 14
	tbl_7.offset = tbl_8
	tbl_2.player_name_shadow = tbl_7
	tbl_2.hp_bar_bg = {
		size = {
			100,
			17
		},
		offset = {
			tbl_6[1] + tbl_5[1] / 2 - 50,
			tbl_6[2] + tbl_5[2] / 2 - 8.5,
			tbl_6[3] + 15
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl_2.hp_bar_fg = {
		size = {
			100,
			24
		},
		offset = {
			tbl_6[1] + tbl_5[1] / 2 - 50,
			tbl_6[2] + tbl_5[2] / 2 - 8.5 - 7,
			tbl_6[3] + 20
		},
		color = {
			255,
			255,
			255,
			255
		}
	}
	tbl.style = tbl_2
	tbl.offset = {
		0,
		-55 * num_3,
		0
	}

	return tbl
end

local function fn_2()
	-- function 4
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					style_id = "portrait_icon",
					texture_id = "portrait_icon",
					pass_type = "texture",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 5
						return self.display_portrait_icon
					end,
					content_change_function = function (self, arg_6_1)
						-- function 6
						arg_6_1.staturated = self.state == "countdown"
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
				},
				{
					style_id = "respawn_countdown_text",
					pass_type = "text",
					text_id = "respawn_countdown_text",
					retained_mode = false,
					content_check_function = function (self)
						-- function 8
						return self.state == "countdown" or self.state == "fadeout"
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
					86 * num_3,
					108 * num_3
				},
				offset = {
					-(86 * num_3) / 2,
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
					86 * num_3,
					108 * num_3
				},
				text_color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-(86 * num_3) / 2,
					-(108 * num_3) / 2,
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
			-55 * num_3,
			0
		}
	}
end

local function fn_3()
	-- function 9
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

local function fn_4()
	-- function 10
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "hp_bar_highlight",
					texture_id = "hp_bar_highlight",
					retained_mode = flag,
					content_check_function = function (self, arg_11_1)
						-- function 11
						return not self.has_shield
					end
				},
				{
					style_id = "grimoire_debuff_divider",
					texture_id = "grimoire_debuff_divider",
					pass_type = "texture",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 12
						return self.hp_bar.draw_health_bar
					end,
					content_change_function = function (self, arg_13_1)
						-- function 13
						local internal_bar_value = self.hp_bar.internal_bar_value
						local actual_active_percentage = self.actual_active_percentage

						actual_active_percentage = actual_active_percentage or 1

						local max = math.max(internal_bar_value, actual_active_percentage)

						arg_13_1.offset[1] = tbl_6[1] + tbl_5[1] * max
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "hp_bar",
					texture_id = "texture_id",
					content_id = "hp_bar",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 14
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
						-- function 15
						return self.draw_health_bar
					end
				},
				{
					style_id = "grimoire_bar",
					pass_type = "texture_uv",
					content_id = "grimoire_bar",
					retained_mode = flag,
					content_change_function = function (self, arg_16_1)
						-- function 16
						local parent = self.parent
						local internal_bar_value = parent.hp_bar.internal_bar_value
						local actual_active_percentage = parent.actual_active_percentage

						actual_active_percentage = actual_active_percentage or 1

						local max = math.max(internal_bar_value, actual_active_percentage)
						local size = arg_16_1.size
						local uvs = self.uvs
						local offset = arg_16_1.offset
						local var_16_7 = tbl_5[1]

						uvs[1][1] = max
						size[1] = var_16_7 * (1 - max)
						offset[1] = 2 + tbl_6[1] + var_16_7 * max
					end
				},
				{
					pass_type = "texture",
					style_id = "hp_bar",
					texture_id = "hp_bar_mask",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 17
						return self.hp_bar.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "portrait_icon",
					texture_id = "portrait_icon",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 18
						return self.display_portrait_icon
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
					tbl_5[1],
					tbl_5[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_6[1],
					tbl_6[2],
					tbl_6[3] + 17
				}
			},
			hp_bar = {
				gradient_threshold = 1,
				size = {
					tbl_5[1],
					tbl_5[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_6[1],
					tbl_6[2],
					tbl_6[3] + 18
				}
			},
			grimoire_bar = {
				size = {
					tbl_5[1],
					tbl_5[2]
				},
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					tbl_6[1],
					tbl_6[2],
					tbl_6[3] + 19
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
					tbl_6[1],
					tbl_6[2],
					23
				}
			},
			hp_bar_highlight = {
				size = {
					100,
					17
				},
				offset = {
					tbl_6[1] + tbl_5[1] / 2 - 50,
					tbl_6[2] - 7,
					tbl_6[3] + 20
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
			-55 * num_3,
			0
		}
	}
end

local tbl_7 = {
	portrait_static = UIWidgets.create_portrait_frame("portrait_pivot", "default", "-", num_3, flag),
	default_dynamic = fn_2(),
	default_static = fn(),
	health_dynamic = fn_4(),
	versus_insignia_static = UIWidgets.create_small_insignia("insignia_pivot", 1, nil, nil, nil, flag)
}
local tbl_8 = {
	equipment = false,
	ammo = false,
	damage = true,
	ability = false
}
local tbl_9 = {
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
local create_damage_widget = UnitFramesUiUtils.create_damage_widget("team", 4)

return {
	weapon_slot_widget_settings = tbl_4,
	inventory_index_by_slot = tbl_3,
	inventory_consumable_icons = tbl_2,
	features_list = tbl_8,
	widget_name_by_feature = tbl_9,
	scenegraph_definition = tbl,
	widget_definitions = tbl_7,
	damage_widget_definitions = create_damage_widget
}
