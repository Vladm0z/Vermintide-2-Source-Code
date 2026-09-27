-- chunkname: @scripts/settings/dlcs/woods/woods_common_settings.lua

local woods = DLCSettings.woods

woods.career_setting_files = {
	"scripts/settings/dlcs/woods/career_settings_woods"
}
woods.player_breeds = {
	"scripts/settings/dlcs/woods/player_breeds_woods"
}
woods.career_ability_settings = {
	"scripts/settings/dlcs/woods/career_ability_settings_woods"
}
woods.action_template_files = {
	"scripts/settings/dlcs/woods/action_templates_woods"
}
woods.talent_settings = {
	"scripts/settings/dlcs/woods/talent_settings_woods"
}
woods.profile_files = {
	"scripts/settings/dlcs/woods/woods_profiles"
}
woods.death_reactions = {
	"scripts/settings/dlcs/woods/woods_death_reactions"
}
woods.spawn_unit_templates = "scripts/settings/dlcs/woods/woods_spawn_unit_templates"
woods.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_woods"
}
woods.unit_extension_templates = {
	"scripts/settings/dlcs/woods/woods_unit_extension_templates"
}
woods.statistics_lookup = {
	"woods_javelin_melee_kills",
	"woods_lift_kills",
	"woods_javelin_combo",
	"woods_triple_lift",
	"woods_heal_grind",
	"woods_amount_healed",
	"woods_wall_kill_grind",
	"woods_wall_kill",
	"woods_bleed_grind",
	"woods_bleed_tics",
	"woods_chaos_pinata",
	"woods_bleed_boss",
	"woods_wall_kill_gutter",
	"woods_ability_combo",
	"woods_wall_tank",
	"woods_wall_hits_soaked",
	"woods_wall_block_ratling",
	"woods_ratling_shots_soaked",
	"woods_wall_dual_save",
	"woods_free_ability_grind",
	"woods_free_abilities_used"
}
woods.anim_lookup = {
	"thorn_ability_start",
	"thorn_ability_cancel",
	"thorn_ability_flip",
	"thorn_ability_cast",
	"thorn_ability_flip_back",
	"attack_chain_01",
	"attack_chain_02",
	"attack_chain_03",
	"attack_throw_last",
	"overcharge_end",
	"sot_landing",
	"to_javelin",
	"to_javelin_noammo"
}
woods.effects = {
	"fx/magic_thorn_sister_finger_trail",
	"fx/magic_thorn_sister_finger_trail_3p",
	"fx/magic_thorn_sister_finger_trail_long",
	"fx/magic_thorn_sister_finger_trail_medium",
	"fx/lifestaff_idle",
	"fx/lifestaff_trail",
	"fx/lifestaff_trail_3p",
	"fx/lifestaff_impact",
	"fx/thornsister_buff",
	"fx/thornsister_overcharge",
	"fx/thornsister_spirits",
	"fx/thorn_wall_aura",
	"fx/thorn_leaves",
	"fx/thorn_indicator",
	"fx/javelin_trail",
	"fx/thornsister_buff_screenspace",
	"fx/thornsister_overcharge_explosion",
	"fx/thornsister_vine_trail",
	"fx/thornsister_overcharge_explosion_3p"
}
woods.material_effect_mappings_file_names = {
	"scripts/settings/material_effect_mappings_woods"
}
woods._tracked_weapon_kill_stats = {}
woods.unlock_settings = {
	woods = {
		id = "1629000",
		class = "UnlockDlc",
		requires_restart = true
	},
	woods_upgrade = {
		id = "1629010",
		class = "UnlockDlc",
		requires_restart = true
	}
}
woods.unlock_settings_xb1 = {
	woods = {
		id = "47365039-5234-3046-C035-4B5831583300",
		backend_reward_id = "woods",
		class = "UnlockDlc",
		requires_restart = true
	},
	woods_upgrade = {
		id = "47365039-5234-3046-C035-4B5831583300",
		backend_reward_id = "woods_upgrade",
		class = "UnlockDlc"
	}
}
woods.unlock_settings_ps4 = {
	CUSA13595_00 = {
		woods = {
			product_label = "V2USSISTERTHORNK",
			backend_reward_id = "woods",
			class = "UnlockDlc",
			requires_restart = true,
			id = "6925f575a58740ef84ac8031ccaabfe8"
		},
		woods_upgrade = {
			id = "6925f575a58740ef84ac8031ccaabfe8",
			product_label = "V2USSISTERTHORNK",
			class = "UnlockDlc",
			backend_reward_id = "woods_upgrade"
		}
	},
	CUSA13645_00 = {
		woods = {
			product_label = "V2EUSISTERTHORNK",
			backend_reward_id = "woods",
			class = "UnlockDlc",
			requires_restart = true,
			id = "c8ae619a4d82456486e5bae83c206057"
		},
		woods_upgrade = {
			id = "c8ae619a4d82456486e5bae83c206057",
			product_label = "V2EUSISTERTHORNK",
			class = "UnlockDlc",
			backend_reward_id = "woods_upgrade"
		}
	}
}
woods.store_layout = {
	structure = {
		cosmetics = {
			kerillian = {
				thornsister = {
					weapon_skins = "item_details"
				}
			}
		}
	},
	pages = {
		thornsister = {
			sound_event_enter = "Play_hud_store_category_button",
			layout = "category",
			display_name = "we_thornsister",
			item_filter = "can_wield_we_thornsister",
			sort_order = 3,
			category_button_texture = "store_category_icon_kerillian_thornsister"
		}
	}
}
woods.prop_extension = {
	"ThornSisterWallExtension"
}
woods.area_damage_extension = {
	"SummonedVortexExtension",
	"SummonedVortexHuskExtension"
}
woods.entity_extensions = {
	"scripts/settings/dlcs/woods/thornsister_wall_extension",
	"scripts/settings/dlcs/woods/summoned_vortex_extension",
	"scripts/settings/dlcs/woods/summoned_vortex_husk_extension"
}
woods.health_extension_files = {
	"scripts/settings/dlcs/woods/thorn_wall_health_extension"
}
woods.health_extensions = {
	"ThornWallHealthExtension"
}
woods.network_damage_types = {
	"burst_thorn"
}
woods.dot_type_lookup = {
	thorn_sister_passive_poison_improved = "poison_dot",
	weapon_bleed_dot_javelin = "poison_dot",
	thorn_sister_wall_bleed = "poison_dot",
	thorn_sister_passive_poison = "poison_dot"
}
woods.progression_unlocks = {
	we_thornsister = {
		description = "end_screen_career_unlocked",
		profile = "wood_elf",
		value = "we_thornsister",
		title = "we_thornsister",
		level_requirement = 0,
		unlock_type = "career"
	}
}
woods.network_go_types = {
	"thornsister_thorn_wall_unit",
	"vortex_unit"
}
woods.game_object_templates = {
	thornsister_thorn_wall_unit = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	vortex_unit = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_yaw = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	}
}
woods.game_object_initializers = {
	thornsister_thorn_wall_unit = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		-- function 1
		local extension = ScriptUnit.extension(arg_1_0, "area_damage_system")
		local aoe_dot_damage = extension.aoe_dot_damage
		local aoe_init_damage = extension.aoe_init_damage
		local aoe_dot_damage_interval = extension.aoe_dot_damage_interval
		local radius = extension.radius
		local life_time = extension.life_time
		local player_screen_effect_name = extension.player_screen_effect_name
		local dot_effect_name = extension.dot_effect_name
		local area_damage_template = extension.area_damage_template
		local invisible_unit = extension.invisible_unit
		local extra_dot_effect_name = extension.extra_dot_effect_name
		local explosion_template_name = extension.explosion_template_name
		local owner_player = extension.owner_player

		if dot_effect_name == nil then
			dot_effect_name = "n/a"
		end

		if extra_dot_effect_name == nil then
			extra_dot_effect_name = "n/a"
		end

		if explosion_template_name == nil then
			explosion_template_name = "n/a"
		end

		if player_screen_effect_name == nil then
			player_screen_effect_name = "n/a"
		end

		local invalid_game_object_id = NetworkConstants.invalid_game_object_id

		if not owner_player then
			invalid_game_object_id = owner_player.game_object_id
		end

		local extension_2 = ScriptUnit.extension(arg_1_0, "props_system")
		local wall_index = extension_2.wall_index
		local group_spawn_index = extension_2.group_spawn_index
		local owner = extension_2:owner()
		local go_id

		if not owner then
			go_id = Managers.state.unit_storage:go_id(owner)

			if not go_id then
				-- Nothing
			end
		end

		go_id = NetworkConstants.invalid_game_object_id

		::label_1_0::

		return {
			go_type = NetworkLookup.go_types.thornsister_thorn_wall_unit,
			husk_unit = NetworkLookup.husks[arg_1_1],
			aoe_dot_damage = aoe_dot_damage,
			aoe_init_damage = aoe_init_damage,
			aoe_dot_damage_interval = aoe_dot_damage_interval,
			position = Unit.local_position(arg_1_0, 0),
			rotation = Unit.local_rotation(arg_1_0, 0),
			radius = radius,
			life_time = life_time,
			player_screen_effect_name = NetworkLookup.effects[player_screen_effect_name],
			dot_effect_name = NetworkLookup.effects[dot_effect_name],
			extra_dot_effect_name = NetworkLookup.effects[extra_dot_effect_name],
			invisible_unit = invisible_unit,
			area_damage_template = NetworkLookup.area_damage_templates[area_damage_template],
			explosion_template_name = NetworkLookup.explosion_templates[explosion_template_name],
			owner_player_id = invalid_game_object_id,
			health = ScriptUnit.extension(arg_1_0, "health_system"):get_max_health(),
			wall_index = wall_index,
			group_spawn_index = group_spawn_index,
			owner_unit_id = go_id
		}
	end,
	vortex_unit = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local mover = Unit.mover(arg_2_0)
		local has_extension = ScriptUnit.has_extension(arg_2_0, "area_damage_system")
		local _inner_decal_unit = has_extension._inner_decal_unit
		local invalid_game_object_id = NetworkConstants.invalid_game_object_id

		if not Unit.alive(_inner_decal_unit) then
			invalid_game_object_id = Managers.state.network:unit_game_object_id(_inner_decal_unit)
		end

		local _outer_decal_unit = has_extension._outer_decal_unit
		local invalid_game_object_id_2 = NetworkConstants.invalid_game_object_id

		if not Unit.alive(_outer_decal_unit) then
			invalid_game_object_id_2 = Managers.state.network:unit_game_object_id(_outer_decal_unit)
		end

		local _owner_unit = has_extension._owner_unit
		local invalid_game_object_id_3 = NetworkConstants.invalid_game_object_id

		if not Unit.alive(_owner_unit) then
			invalid_game_object_id_3 = Managers.state.network:unit_game_object_id(_owner_unit)
		end

		local target_unit = has_extension.target_unit
		local invalid_game_object_id_4 = NetworkConstants.invalid_game_object_id

		if not Unit.alive(target_unit) then
			invalid_game_object_id_4 = Managers.state.network:unit_game_object_id(target_unit)
		end

		local side_id = Managers.state.side.side_by_unit[_owner_unit].side_id
		local tbl = {
			height_percentage = 1,
			inner_radius_percentage = 1,
			fx_radius_percentage = 1,
			go_type = NetworkLookup.go_types.vortex_unit,
			husk_unit = NetworkLookup.husks[arg_2_1]
		}
		local position

		if not mover then
			position = Mover.position(mover)

			if not position then
				-- Nothing
			end
		end

		position = Unit.local_position(arg_2_0, 0)

		::label_2_0::

		tbl.position = position
		tbl.yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_2_0, 0))
		tbl.velocity = Vector3(0, 0, 0)
		tbl.vortex_template_id = NetworkLookup.vortex_templates[has_extension.vortex_template_name]
		tbl.inner_decal_unit_id = invalid_game_object_id
		tbl.outer_decal_unit_id = invalid_game_object_id_2
		tbl.owner_unit_id = invalid_game_object_id_3
		tbl.side_id = side_id
		tbl.target_unit_id = invalid_game_object_id_4

		return tbl
	end
}
woods.game_object_extractors = {
	thornsister_thorn_wall_unit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		local game_object_field = GameSession.game_object_field(arg_3_0, arg_3_1, "aoe_dot_damage")
		local game_object_field_2 = GameSession.game_object_field(arg_3_0, arg_3_1, "aoe_init_damage")
		local game_object_field_3 = GameSession.game_object_field(arg_3_0, arg_3_1, "aoe_dot_damage_interval")
		local game_object_field_4 = GameSession.game_object_field(arg_3_0, arg_3_1, "radius")
		local game_object_field_5 = GameSession.game_object_field(arg_3_0, arg_3_1, "life_time")
		local game_object_field_6 = GameSession.game_object_field(arg_3_0, arg_3_1, "player_screen_effect_name")
		local game_object_field_7 = GameSession.game_object_field(arg_3_0, arg_3_1, "dot_effect_name")
		local game_object_field_8 = GameSession.game_object_field(arg_3_0, arg_3_1, "area_damage_template")
		local game_object_field_9 = GameSession.game_object_field(arg_3_0, arg_3_1, "invisible_unit")
		local game_object_field_10 = GameSession.game_object_field(arg_3_0, arg_3_1, "extra_dot_effect_name")
		local game_object_field_11 = GameSession.game_object_field(arg_3_0, arg_3_1, "explosion_template_name")
		local game_object_field_12 = GameSession.game_object_field(arg_3_0, arg_3_1, "owner_player_id")
		local game_object_field_13 = GameSession.game_object_field(arg_3_0, arg_3_1, "health")
		local game_object_field_14 = GameSession.game_object_field(arg_3_0, arg_3_1, "wall_index")
		local game_object_field_15 = GameSession.game_object_field(arg_3_0, arg_3_1, "owner_unit_id")
		local var_3_15 = NetworkLookup.effects[game_object_field_10]

		if var_3_15 == "n/a" then
			var_3_15 = nil
		end

		local var_3_16 = NetworkLookup.explosion_templates[game_object_field_11]

		if var_3_16 == "n/a" then
			var_3_16 = nil
		end

		local var_3_17 = NetworkLookup.effects[game_object_field_6]

		if var_3_17 == "n/a" then
			var_3_17 = nil
		end

		local var_3_18 = NetworkLookup.effects[game_object_field_7]

		if var_3_18 == "n/a" then
			var_3_18 = nil
		end

		local var_3_19

		if not var_3_16 then
			local get_template = ExplosionUtils.get_template(var_3_16)

			if not get_template then
				var_3_19 = get_template.aoe.nav_mesh_effect
			end
		end

		local var_3_21

		if game_object_field_12 ~= NetworkConstants.invalid_game_object_id then
			local player_from_game_object_id = Managers.player:player_from_game_object_id(game_object_field_12)
		end

		local var_3_23

		if game_object_field_15 ~= NetworkConstants.invalid_game_object_id then
			var_3_23 = Managers.state.unit_storage:unit(game_object_field_15)
		end

		local tbl = {
			area_damage_system = {
				aoe_dot_damage = game_object_field,
				aoe_init_damage = game_object_field_2,
				aoe_dot_damage_interval = game_object_field_3,
				radius = game_object_field_4,
				life_time = game_object_field_5,
				invisible_unit = game_object_field_9,
				player_screen_effect_name = var_3_17,
				dot_effect_name = var_3_18,
				nav_mesh_effect = var_3_19,
				extra_dot_effect_name = var_3_15,
				area_damage_template = NetworkLookup.area_damage_templates[game_object_field_8],
				explosion_template_name = var_3_16,
				source_attacker_unit = var_3_23
			},
			props_system = {
				life_time = game_object_field_5,
				owner_unit = var_3_23,
				wall_index = game_object_field_14
			},
			health_system = {
				health = game_object_field_13
			},
			death_system = {
				death_reaction_template = "thorn_wall",
				is_husk = true
			},
			hit_reaction_system = {
				is_husk = true,
				hit_reaction_template = "level_object"
			}
		}

		return "thornsister_thorn_wall_unit", tbl
	end,
	vortex_unit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		local game_object_field = GameSession.game_object_field(arg_4_0, arg_4_1, "vortex_template_id")
		local var_4_1 = NetworkLookup.vortex_templates[game_object_field]
		local game_object_field_2 = GameSession.game_object_field(arg_4_0, arg_4_1, "inner_decal_unit_id")
		local unit = Managers.state.unit_storage:unit(game_object_field_2)
		local game_object_field_3 = GameSession.game_object_field(arg_4_0, arg_4_1, "outer_decal_unit_id")
		local unit_2 = Managers.state.unit_storage:unit(game_object_field_3)
		local game_object_field_4 = GameSession.game_object_field(arg_4_0, arg_4_1, "owner_unit_id")
		local unit_3 = Managers.state.unit_storage:unit(game_object_field_4)
		local game_object_field_5 = GameSession.game_object_field(arg_4_0, arg_4_1, "side_id")
		local game_object_field_6 = GameSession.game_object_field(arg_4_0, arg_4_1, "target_unit_id")
		local unit_4 = Managers.state.unit_storage:unit(game_object_field_6)
		local tbl = {
			area_damage_system = {
				vortex_template_name = var_4_1,
				inner_decal_unit = unit,
				outer_decal_unit = unit_2,
				owner_unit = unit_3,
				side_id = game_object_field_5,
				target_unit = unit_4
			}
		}

		return "vortex_unit", tbl
	end
}
