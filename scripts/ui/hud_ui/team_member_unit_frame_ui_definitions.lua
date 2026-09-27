-- chunkname: @scripts/ui/hud_ui/team_member_unit_frame_ui_definitions.lua

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
				},
				{
					pass_type = "texture",
					style_id = "ability_bar_bg",
					texture_id = "ability_bar_bg",
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
			hp_bar_fg = "hud_teammate_hp_bar_frame",
			ability_bar_bg = "hud_teammate_ability_bar_bg"
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
	tbl_2.ability_bar_bg = {
		size = {
			92,
			5
		},
		offset = {
			tbl_6[1] + tbl_5[1] / 2 - 46,
			tbl_6[2] - 9,
			tbl_6[3] + 15
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
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator",
					texture_id = "ammo_indicator",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 6
						local ammo_percent = self.ammo_percent

						return not ammo_percent and not (ammo_percent > 0) or ammo_percent <= 0.33
					end
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator",
					texture_id = "ammo_indicator_empty",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 7
						local ammo_percent = self.ammo_percent

						return not ammo_percent and ammo_percent <= 0
					end
				},
				{
					style_id = "respawn_countdown_text",
					pass_type = "text",
					text_id = "respawn_countdown_text",
					retained_mode = false,
					content_check_function = function (arg_8_0)
						-- function 8
						return true
					end
				},
				{
					pass_type = "texture",
					style_id = "ammo_indicator",
					texture_id = "numeric_ui_ammo_indicator",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 9
						local ammo_percent = self.ammo_percent
						local flag = not ammo_percent and not (ammo_percent > 0) and not (ammo_percent <= 0.33) and ammo_percent <= 0
						local user_setting = Application.user_setting("numeric_ui")

						if not user_setting then
							user_setting = self.has_ranged_weapon
							user_setting = not user_setting and not flag
						end

						return user_setting
					end
				},
				{
					pass_type = "texture",
					style_id = "ability_cooldown_indicator",
					texture_id = "ability_cooldown_indicator",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 10
						local user_setting = Application.user_setting("numeric_ui")

						user_setting = not user_setting and self.on_cooldown

						return user_setting
					end
				},
				{
					style_id = "ammo_count",
					pass_type = "text",
					text_id = "ammo_count",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 11
						local user_setting = Application.user_setting("numeric_ui")

						user_setting = not user_setting and self.has_ranged_weapon

						return user_setting
					end
				},
				{
					style_id = "ammo_count_shadow",
					pass_type = "text",
					text_id = "ammo_count",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 12
						local user_setting = Application.user_setting("numeric_ui")

						user_setting = not user_setting and self.has_ranged_weapon

						return user_setting
					end
				},
				{
					style_id = "ability_cooldown",
					pass_type = "text",
					text_id = "ability_cooldown",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 13
						local user_setting = Application.user_setting("numeric_ui")

						user_setting = not user_setting and self.on_cooldown

						return user_setting
					end
				},
				{
					style_id = "ability_cooldown_shadow",
					pass_type = "text",
					text_id = "ability_cooldown",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 14
						local user_setting = Application.user_setting("numeric_ui")

						user_setting = not user_setting and self.on_cooldown

						return user_setting
					end
				},
				{
					pass_type = "texture",
					style_id = "brush_stroke",
					texture_id = "brush_stroke",
					retained_mode = flag,
					content_check_function = function (arg_15_0)
						-- function 15
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
					tbl_6[2] + tbl_5[2] / 2 - 6 - 1 + 1 - 45,
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
					tbl_6[1] + tbl_5[1] + 50,
					tbl_6[2] + tbl_5[2] / 2 - 8.5 - 1 + 1,
					tbl_6[3] + 22
				},
				size = tbl_5
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
					tbl_6[1] + tbl_5[1] + 50 + 1,
					tbl_6[2] + tbl_5[2] / 2 - 8.5 - 1 + 1,
					tbl_6[3] + 21
				},
				size = tbl_5
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
					tbl_6[1] + tbl_5[1] + 50,
					tbl_6[2] + tbl_5[2] / 2 - 6 - 1 + 1 - 32,
					tbl_6[3] + 22
				},
				size = tbl_5
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
					tbl_6[1] + tbl_5[1] + 50 + 1,
					tbl_6[2] + tbl_5[2] / 2 - 6 - 1 + 1 - 32,
					tbl_6[3] + 21
				},
				size = tbl_5
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
			-55 * num_3,
			0
		}
	}
end

local function fn_3()
	-- function 16
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
	-- function 17
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "item_slot_1",
					texture_id = "item_slot_1",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 18
						return self.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_bg_1",
					texture_id = "item_slot_bg_1",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 19
						return self.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_frame_1",
					texture_id = "slot_frame",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 20
						return self.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_highlight_1",
					texture_id = "item_slot_highlight",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 21
						return self.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_2",
					texture_id = "item_slot_2",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 22
						return self.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_bg_2",
					texture_id = "item_slot_bg_2",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 23
						return self.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_frame_2",
					texture_id = "slot_frame",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 24
						return self.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_highlight_2",
					texture_id = "item_slot_highlight",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 25
						return self.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_3",
					texture_id = "item_slot_3",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 26
						return self.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_bg_3",
					texture_id = "item_slot_bg_3",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 27
						return self.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_frame_3",
					texture_id = "slot_frame",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 28
						return self.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					style_id = "item_slot_highlight_3",
					texture_id = "item_slot_highlight",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 29
						return self.draw_health_bar
					end
				},
				{
					style_id = "item_count_1",
					pass_type = "text",
					text_id = "item_count_1",
					retained_mode = flag,
					content_check_function = function (self, arg_30_1)
						-- function 30
						local draw_health_bar = self.draw_health_bar

						draw_health_bar = not draw_health_bar and self.item_count_1

						return draw_health_bar
					end
				},
				{
					style_id = "item_count_shadow_1",
					pass_type = "text",
					text_id = "item_count_1",
					retained_mode = flag,
					content_check_function = function (self, arg_31_1)
						-- function 31
						local draw_health_bar = self.draw_health_bar

						draw_health_bar = not draw_health_bar and self.item_count_1

						return draw_health_bar
					end
				},
				{
					style_id = "item_count_2",
					pass_type = "text",
					text_id = "item_count_2",
					retained_mode = flag,
					content_check_function = function (self, arg_32_1)
						-- function 32
						local draw_health_bar = self.draw_health_bar

						draw_health_bar = not draw_health_bar and self.item_count_2

						return draw_health_bar
					end
				},
				{
					style_id = "item_count_shadow_2",
					pass_type = "text",
					text_id = "item_count_2",
					retained_mode = flag,
					content_check_function = function (self, arg_33_1)
						-- function 33
						local draw_health_bar = self.draw_health_bar

						draw_health_bar = not draw_health_bar and self.item_count_2

						return draw_health_bar
					end
				},
				{
					style_id = "item_count_3",
					pass_type = "text",
					text_id = "item_count_3",
					retained_mode = flag,
					content_check_function = function (self, arg_34_1)
						-- function 34
						local draw_health_bar = self.draw_health_bar

						draw_health_bar = not draw_health_bar and self.item_count_3

						return draw_health_bar
					end
				},
				{
					style_id = "item_count_shadow_3",
					pass_type = "text",
					text_id = "item_count_3",
					retained_mode = flag,
					content_check_function = function (self, arg_35_1)
						-- function 35
						local draw_health_bar = self.draw_health_bar

						draw_health_bar = not draw_health_bar and self.item_count_3

						return draw_health_bar
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
					29 * num_4,
					29 * num_4
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
					29 * num_4,
					29 * num_4
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
					29 * num_4,
					29 * num_4
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
					29 * num_4,
					29 * num_4
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
					29 * num_4,
					29 * num_4
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
					29 * num_4,
					29 * num_4
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
					29 * num_4,
					29 * num_4
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
					29 * num_4,
					29 * num_4
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
					29 * num_4,
					29 * num_4
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
			tbl_6[2] - 96,
			0
		}
	}
end

local function fn_5()
	-- function 36
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					pass_type = "texture",
					style_id = "hp_bar_highlight",
					texture_id = "hp_bar_highlight",
					retained_mode = flag,
					content_check_function = function (self, arg_37_1)
						-- function 37
						return not self.has_shield
					end
				},
				{
					style_id = "grimoire_debuff_divider",
					texture_id = "grimoire_debuff_divider",
					pass_type = "texture",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 38
						return self.hp_bar.draw_health_bar
					end,
					content_change_function = function (self, arg_39_1)
						-- function 39
						local internal_bar_value = self.hp_bar.internal_bar_value
						local actual_active_percentage = self.actual_active_percentage

						actual_active_percentage = actual_active_percentage or 1

						local max = math.max(internal_bar_value, actual_active_percentage)

						arg_39_1.offset[1] = tbl_6[1] + tbl_5[1] * max
					end
				},
				{
					pass_type = "gradient_mask_texture",
					style_id = "hp_bar",
					texture_id = "texture_id",
					content_id = "hp_bar",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 40
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
						-- function 41
						return self.draw_health_bar
					end
				},
				{
					style_id = "grimoire_bar",
					pass_type = "texture_uv",
					content_id = "grimoire_bar",
					retained_mode = flag,
					content_change_function = function (self, arg_42_1)
						-- function 42
						local parent = self.parent
						local internal_bar_value = parent.hp_bar.internal_bar_value
						local actual_active_percentage = parent.actual_active_percentage

						actual_active_percentage = actual_active_percentage or 1

						local max = math.max(internal_bar_value, actual_active_percentage)
						local size = arg_42_1.size
						local uvs = self.uvs
						local offset = arg_42_1.offset
						local var_42_7 = tbl_5[1]

						uvs[1][1] = max
						size[1] = var_42_7 * (1 - max)
						offset[1] = 2 + tbl_6[1] + var_42_7 * max
					end
				},
				{
					pass_type = "texture",
					style_id = "hp_bar",
					texture_id = "hp_bar_mask",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 43
						return self.hp_bar.draw_health_bar
					end
				},
				{
					pass_type = "texture",
					texture_id = "portrait_icon",
					retained_mode = flag,
					content_check_function = function (self)
						-- function 44
						return self.display_portrait_icon
					end
				},
				{
					style_id = "numeric_health",
					pass_type = "text",
					text_id = "numeric_health",
					retained_mode = flag,
					content_check_function = function (arg_45_0)
						-- function 45
						return Application.user_setting("numeric_ui")
					end
				},
				{
					style_id = "numeric_health_shadow",
					pass_type = "text",
					text_id = "numeric_health",
					retained_mode = flag,
					content_check_function = function (arg_46_0)
						-- function 46
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
					tbl_6[1] - 4,
					tbl_6[2] - 10,
					tbl_6[3] + 22
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
					tbl_6[1] - 4 + 1,
					tbl_6[2] - 10 + 1,
					tbl_6[3] + 21
				},
				size = {
					100,
					30
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

local function fn_6()
	-- function 47
	return {
		scenegraph_id = "pivot",
		element = {
			passes = {
				{
					style_id = "ability_bar",
					pass_type = "texture_uv",
					content_id = "ability_bar",
					retained_mode = flag,
					content_change_function = function (self, arg_48_1)
						-- function 48
						local bar_value = self.bar_value
						local size = arg_48_1.size
						local uvs = self.uvs
						local num = 92

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
					tbl_6[1] + tbl_5[1] / 2 - 46,
					tbl_6[2] - 9,
					tbl_6[3] + 18
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
	loadout_dynamic = fn_4(),
	portrait_static = UIWidgets.create_portrait_frame("portrait_pivot", "default", "-", num_3, flag),
	default_dynamic = fn_2(),
	default_static = fn(),
	health_dynamic = fn_5(),
	ability_dynamic = fn_6(),
	versus_insignia_static = UIWidgets.create_small_insignia("insignia_pivot", 0, nil, nil, nil, flag)
}
local tbl_8 = {
	equipment = true,
	ammo = true,
	damage = false,
	ability = true
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
	weapon_slot_widget_settings = tbl_4,
	inventory_index_by_slot = tbl_3,
	inventory_consumable_icons = tbl_2,
	features_list = tbl_8,
	widget_name_by_feature = tbl_9,
	scenegraph_definition = tbl,
	widget_definitions = tbl_7
}
