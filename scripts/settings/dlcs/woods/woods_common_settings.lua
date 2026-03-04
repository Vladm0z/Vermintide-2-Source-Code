-- chunkname: @scripts/settings/dlcs/woods/woods_common_settings.lua

local var_0_0 = DLCSettings.woods

var_0_0.career_setting_files = {
	"scripts/settings/dlcs/woods/career_settings_woods"
}
var_0_0.player_breeds = {
	"scripts/settings/dlcs/woods/player_breeds_woods"
}
var_0_0.career_ability_settings = {
	"scripts/settings/dlcs/woods/career_ability_settings_woods"
}
var_0_0.action_template_files = {
	"scripts/settings/dlcs/woods/action_templates_woods"
}
var_0_0.talent_settings = {
	"scripts/settings/dlcs/woods/talent_settings_woods"
}
var_0_0.profile_files = {
	"scripts/settings/dlcs/woods/woods_profiles"
}
var_0_0.death_reactions = {
	"scripts/settings/dlcs/woods/woods_death_reactions"
}
var_0_0.spawn_unit_templates = "scripts/settings/dlcs/woods/woods_spawn_unit_templates"
var_0_0.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_woods"
}
var_0_0.unit_extension_templates = {
	"scripts/settings/dlcs/woods/woods_unit_extension_templates"
}
var_0_0.statistics_lookup = {
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
var_0_0.anim_lookup = {
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
var_0_0.effects = {
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
var_0_0.material_effect_mappings_file_names = {
	"scripts/settings/material_effect_mappings_woods"
}
var_0_0._tracked_weapon_kill_stats = {}
var_0_0.unlock_settings = {
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
var_0_0.unlock_settings_xb1 = {
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
var_0_0.unlock_settings_ps4 = {
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
var_0_0.store_layout = {
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
var_0_0.prop_extension = {
	"ThornSisterWallExtension"
}
var_0_0.area_damage_extension = {
	"SummonedVortexExtension",
	"SummonedVortexHuskExtension"
}
var_0_0.entity_extensions = {
	"scripts/settings/dlcs/woods/thornsister_wall_extension",
	"scripts/settings/dlcs/woods/summoned_vortex_extension",
	"scripts/settings/dlcs/woods/summoned_vortex_husk_extension"
}
var_0_0.health_extension_files = {
	"scripts/settings/dlcs/woods/thorn_wall_health_extension"
}
var_0_0.health_extensions = {
	"ThornWallHealthExtension"
}
var_0_0.network_damage_types = {
	"burst_thorn"
}
var_0_0.dot_type_lookup = {
	thorn_sister_passive_poison_improved = "poison_dot",
	weapon_bleed_dot_javelin = "poison_dot",
	thorn_sister_wall_bleed = "poison_dot",
	thorn_sister_passive_poison = "poison_dot"
}
var_0_0.progression_unlocks = {
	we_thornsister = {
		description = "end_screen_career_unlocked",
		profile = "wood_elf",
		value = "we_thornsister",
		title = "we_thornsister",
		level_requirement = 0,
		unlock_type = "career"
	}
}
var_0_0.network_go_types = {
	"thornsister_thorn_wall_unit",
	"vortex_unit"
}
var_0_0.game_object_templates = {
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
var_0_0.game_object_initializers = {
	thornsister_thorn_wall_unit = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		local var_1_0 = ScriptUnit.extension(arg_1_0, "area_damage_system")
		local var_1_1 = var_1_0.aoe_dot_damage
		local var_1_2 = var_1_0.aoe_init_damage
		local var_1_3 = var_1_0.aoe_dot_damage_interval
		local var_1_4 = var_1_0.radius
		local var_1_5 = var_1_0.life_time
		local var_1_6 = var_1_0.player_screen_effect_name
		local var_1_7 = var_1_0.dot_effect_name
		local var_1_8 = var_1_0.area_damage_template
		local var_1_9 = var_1_0.invisible_unit
		local var_1_10 = var_1_0.extra_dot_effect_name
		local var_1_11 = var_1_0.explosion_template_name
		local var_1_12 = var_1_0.owner_player

		if var_1_7 == nil then
			var_1_7 = "n/a"
		end

		if var_1_10 == nil then
			var_1_10 = "n/a"
		end

		if var_1_11 == nil then
			var_1_11 = "n/a"
		end

		if var_1_6 == nil then
			var_1_6 = "n/a"
		end

		local var_1_13 = NetworkConstants.invalid_game_object_id

		if var_1_12 then
			var_1_13 = var_1_12.game_object_id
		end

		local var_1_14 = ScriptUnit.extension(arg_1_0, "props_system")
		local var_1_15 = var_1_14.wall_index
		local var_1_16 = var_1_14.group_spawn_index
		local var_1_17 = var_1_14:owner()
		local var_1_18 = var_1_17 and Managers.state.unit_storage:go_id(var_1_17) or NetworkConstants.invalid_game_object_id

		return {
			go_type = NetworkLookup.go_types.thornsister_thorn_wall_unit,
			husk_unit = NetworkLookup.husks[arg_1_1],
			aoe_dot_damage = var_1_1,
			aoe_init_damage = var_1_2,
			aoe_dot_damage_interval = var_1_3,
			position = Unit.local_position(arg_1_0, 0),
			rotation = Unit.local_rotation(arg_1_0, 0),
			radius = var_1_4,
			life_time = var_1_5,
			player_screen_effect_name = NetworkLookup.effects[var_1_6],
			dot_effect_name = NetworkLookup.effects[var_1_7],
			extra_dot_effect_name = NetworkLookup.effects[var_1_10],
			invisible_unit = var_1_9,
			area_damage_template = NetworkLookup.area_damage_templates[var_1_8],
			explosion_template_name = NetworkLookup.explosion_templates[var_1_11],
			owner_player_id = var_1_13,
			health = ScriptUnit.extension(arg_1_0, "health_system"):get_max_health(),
			wall_index = var_1_15,
			group_spawn_index = var_1_16,
			owner_unit_id = var_1_18
		}
	end,
	vortex_unit = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = Unit.mover(arg_2_0)
		local var_2_1 = ScriptUnit.has_extension(arg_2_0, "area_damage_system")
		local var_2_2 = var_2_1._inner_decal_unit
		local var_2_3 = NetworkConstants.invalid_game_object_id

		if Unit.alive(var_2_2) then
			var_2_3 = Managers.state.network:unit_game_object_id(var_2_2)
		end

		local var_2_4 = var_2_1._outer_decal_unit
		local var_2_5 = NetworkConstants.invalid_game_object_id

		if Unit.alive(var_2_4) then
			var_2_5 = Managers.state.network:unit_game_object_id(var_2_4)
		end

		local var_2_6 = var_2_1._owner_unit
		local var_2_7 = NetworkConstants.invalid_game_object_id

		if Unit.alive(var_2_6) then
			var_2_7 = Managers.state.network:unit_game_object_id(var_2_6)
		end

		local var_2_8 = var_2_1.target_unit
		local var_2_9 = NetworkConstants.invalid_game_object_id

		if Unit.alive(var_2_8) then
			var_2_9 = Managers.state.network:unit_game_object_id(var_2_8)
		end

		local var_2_10 = Managers.state.side.side_by_unit[var_2_6].side_id

		return {
			height_percentage = 1,
			inner_radius_percentage = 1,
			fx_radius_percentage = 1,
			go_type = NetworkLookup.go_types.vortex_unit,
			husk_unit = NetworkLookup.husks[arg_2_1],
			position = var_2_0 and Mover.position(var_2_0) or Unit.local_position(arg_2_0, 0),
			yaw_rot = Quaternion.yaw(Unit.local_rotation(arg_2_0, 0)),
			velocity = Vector3(0, 0, 0),
			vortex_template_id = NetworkLookup.vortex_templates[var_2_1.vortex_template_name],
			inner_decal_unit_id = var_2_3,
			outer_decal_unit_id = var_2_5,
			owner_unit_id = var_2_7,
			side_id = var_2_10,
			target_unit_id = var_2_9
		}
	end
}
var_0_0.game_object_extractors = {
	thornsister_thorn_wall_unit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		local var_3_0 = GameSession.game_object_field(arg_3_0, arg_3_1, "aoe_dot_damage")
		local var_3_1 = GameSession.game_object_field(arg_3_0, arg_3_1, "aoe_init_damage")
		local var_3_2 = GameSession.game_object_field(arg_3_0, arg_3_1, "aoe_dot_damage_interval")
		local var_3_3 = GameSession.game_object_field(arg_3_0, arg_3_1, "radius")
		local var_3_4 = GameSession.game_object_field(arg_3_0, arg_3_1, "life_time")
		local var_3_5 = GameSession.game_object_field(arg_3_0, arg_3_1, "player_screen_effect_name")
		local var_3_6 = GameSession.game_object_field(arg_3_0, arg_3_1, "dot_effect_name")
		local var_3_7 = GameSession.game_object_field(arg_3_0, arg_3_1, "area_damage_template")
		local var_3_8 = GameSession.game_object_field(arg_3_0, arg_3_1, "invisible_unit")
		local var_3_9 = GameSession.game_object_field(arg_3_0, arg_3_1, "extra_dot_effect_name")
		local var_3_10 = GameSession.game_object_field(arg_3_0, arg_3_1, "explosion_template_name")
		local var_3_11 = GameSession.game_object_field(arg_3_0, arg_3_1, "owner_player_id")
		local var_3_12 = GameSession.game_object_field(arg_3_0, arg_3_1, "health")
		local var_3_13 = GameSession.game_object_field(arg_3_0, arg_3_1, "wall_index")
		local var_3_14 = GameSession.game_object_field(arg_3_0, arg_3_1, "owner_unit_id")
		local var_3_15 = NetworkLookup.effects[var_3_9]

		if var_3_15 == "n/a" then
			var_3_15 = nil
		end

		local var_3_16 = NetworkLookup.explosion_templates[var_3_10]

		if var_3_16 == "n/a" then
			var_3_16 = nil
		end

		local var_3_17 = NetworkLookup.effects[var_3_5]

		if var_3_17 == "n/a" then
			var_3_17 = nil
		end

		local var_3_18 = NetworkLookup.effects[var_3_6]

		if var_3_18 == "n/a" then
			var_3_18 = nil
		end

		local var_3_19

		if var_3_16 then
			local var_3_20 = ExplosionUtils.get_template(var_3_16)

			if var_3_20 then
				var_3_19 = var_3_20.aoe.nav_mesh_effect
			end
		end

		local var_3_21

		if var_3_11 ~= NetworkConstants.invalid_game_object_id then
			local var_3_22 = Managers.player:player_from_game_object_id(var_3_11)
		end

		local var_3_23

		if var_3_14 ~= NetworkConstants.invalid_game_object_id then
			var_3_23 = Managers.state.unit_storage:unit(var_3_14)
		end

		local var_3_24 = {
			area_damage_system = {
				aoe_dot_damage = var_3_0,
				aoe_init_damage = var_3_1,
				aoe_dot_damage_interval = var_3_2,
				radius = var_3_3,
				life_time = var_3_4,
				invisible_unit = var_3_8,
				player_screen_effect_name = var_3_17,
				dot_effect_name = var_3_18,
				nav_mesh_effect = var_3_19,
				extra_dot_effect_name = var_3_15,
				area_damage_template = NetworkLookup.area_damage_templates[var_3_7],
				explosion_template_name = var_3_16,
				source_attacker_unit = var_3_23
			},
			props_system = {
				life_time = var_3_4,
				owner_unit = var_3_23,
				wall_index = var_3_13
			},
			health_system = {
				health = var_3_12
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

		return "thornsister_thorn_wall_unit", var_3_24
	end,
	vortex_unit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		local var_4_0 = GameSession.game_object_field(arg_4_0, arg_4_1, "vortex_template_id")
		local var_4_1 = NetworkLookup.vortex_templates[var_4_0]
		local var_4_2 = GameSession.game_object_field(arg_4_0, arg_4_1, "inner_decal_unit_id")
		local var_4_3 = Managers.state.unit_storage:unit(var_4_2)
		local var_4_4 = GameSession.game_object_field(arg_4_0, arg_4_1, "outer_decal_unit_id")
		local var_4_5 = Managers.state.unit_storage:unit(var_4_4)
		local var_4_6 = GameSession.game_object_field(arg_4_0, arg_4_1, "owner_unit_id")
		local var_4_7 = Managers.state.unit_storage:unit(var_4_6)
		local var_4_8 = GameSession.game_object_field(arg_4_0, arg_4_1, "side_id")
		local var_4_9 = GameSession.game_object_field(arg_4_0, arg_4_1, "target_unit_id")
		local var_4_10 = Managers.state.unit_storage:unit(var_4_9)
		local var_4_11 = {
			area_damage_system = {
				vortex_template_name = var_4_1,
				inner_decal_unit = var_4_3,
				outer_decal_unit = var_4_5,
				owner_unit = var_4_7,
				side_id = var_4_8,
				target_unit = var_4_10
			}
		}

		return "vortex_unit", var_4_11
	end
}
