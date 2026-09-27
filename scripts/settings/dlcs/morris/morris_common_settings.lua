-- chunkname: @scripts/settings/dlcs/morris/morris_common_settings.lua

local morris = DLCSettings.morris

morris.unlock_settings = {
	morris = {
		class = "AlwaysUnlocked"
	},
	grass = {
		class = "UnlockDlc",
		id = "1592630"
	},
	grass_2 = {
		class = "UnlockDlc",
		id = "1592630"
	}
}
morris.unlock_settings_xb1 = {
	morris = {
		class = "AlwaysUnlocked"
	},
	grass = {
		id = "58375039-3534-3043-C036-354E4233F200",
		backend_reward_id = "grass",
		class = "UnlockDlc"
	},
	grass_2 = {
		id = "58375039-3534-3043-C036-354E4233F200",
		backend_reward_id = "grass_2",
		class = "UnlockDlc"
	},
	five_career_bundle = {
		id = "4C344E39-384E-3048-C037-4C4443513000",
		backend_reward_id = "five_career_bundle",
		class = "UnlockDlc"
	},
	scholar_bundle = {
		id = "37444E39-4D52-3035-C033-524E56515000",
		backend_reward_id = "scholar_bundle",
		class = "UnlockDlc"
	},
	ironbreaker_bundle = {
		id = "544A4E39-434E-3058-C030-384434372500",
		backend_reward_id = "ironbreaker_bundle",
		class = "UnlockDlc"
	},
	bountyhunter_bundle = {
		id = "56434E39-3757-304A-C056-524A53367300",
		backend_reward_id = "bountyhunter_bundle",
		class = "UnlockDlc"
	},
	mercenary_bundle = {
		id = "43564E39-5853-3037-C04A-505257438800",
		backend_reward_id = "mercenary_bundle",
		class = "UnlockDlc"
	},
	shade_bundle = {
		id = "50425039-424A-304A-C031-373454422300",
		backend_reward_id = "shade_bundle",
		class = "UnlockDlc"
	}
}
morris.unlock_settings_ps4 = {
	CUSA13595_00 = {
		morris = {
			class = "AlwaysUnlocked"
		},
		grass = {
			id = "d3a78a970d0d40ea8abdded9dd3e8bf3",
			product_label = "V2USFORGOTTENREL",
			class = "UnlockDlc",
			backend_reward_id = "grass"
		},
		grass_2 = {
			id = "d3a78a970d0d40ea8abdded9dd3e8bf3",
			product_label = "V2USFORGOTTENREL",
			class = "UnlockDlc",
			backend_reward_id = "grass_2"
		},
		five_career_bundle = {
			id = "614a9ea6b2ad44c6834218ee784c5535",
			product_label = "V2USLOHNERSCOLLE",
			class = "UnlockDlc",
			backend_reward_id = "five_career_bundle"
		},
		scholar_bundle = {
			id = "69a59b3b817948b28b4574f9255b68bd",
			product_label = "V2USLIGHTOFJUDGE",
			class = "UnlockDlc",
			backend_reward_id = "scholar_bundle"
		},
		ironbreaker_bundle = {
			id = "878a07aa09394108a0959ae864df5d3f",
			product_label = "V2USKARAKNORNHOL",
			class = "UnlockDlc",
			backend_reward_id = "ironbreaker_bundle"
		},
		bountyhunter_bundle = {
			id = "46725f0f69634f5b9cc49ab9d77f92d0",
			product_label = "V2USDASHINGROGUE",
			class = "UnlockDlc",
			backend_reward_id = "bountyhunter_bundle"
		},
		mercenary_bundle = {
			id = "7b90a25a8e914000847a078da21be54a",
			product_label = "V2USFLAMBOYANTSE",
			class = "UnlockDlc",
			backend_reward_id = "mercenary_bundle"
		},
		shade_bundle = {
			id = "3f020561f477420d812f3281b5e0826f",
			product_label = "V2USAGENTOFMALEK",
			class = "UnlockDlc",
			backend_reward_id = "shade_bundle"
		}
	},
	CUSA13645_00 = {
		morris = {
			class = "AlwaysUnlocked"
		},
		grass = {
			id = "78047b6b56134b6e86b44903e3bb9468",
			product_label = "V2EUFORGOTTENREL",
			class = "UnlockDlc",
			backend_reward_id = "grass"
		},
		grass_2 = {
			id = "78047b6b56134b6e86b44903e3bb9468",
			product_label = "V2EUFORGOTTENREL",
			class = "UnlockDlc",
			backend_reward_id = "grass_2"
		},
		five_career_bundle = {
			id = "aa1ff0f288944f27a73434f9ed93474d",
			product_label = "V2EULOHNERSCOLLE",
			class = "UnlockDlc",
			backend_reward_id = "five_career_bundle"
		},
		scholar_bundle = {
			id = "c8e5abd113d941f687157e3718c1a65c",
			product_label = "V2EULIGHTOFJUDGE",
			class = "UnlockDlc",
			backend_reward_id = "scholar_bundle"
		},
		ironbreaker_bundle = {
			id = "feb6dcf10e4948c893a03ba83a6ae401",
			product_label = "V2EUKARAKNORNHOL",
			class = "UnlockDlc",
			backend_reward_id = "ironbreaker_bundle"
		},
		bountyhunter_bundle = {
			id = "a61971e97ad34fd4b28f8c8b850356fe",
			product_label = "V2EUDASHINGROGUE",
			class = "UnlockDlc",
			backend_reward_id = "bountyhunter_bundle"
		},
		mercenary_bundle = {
			id = "874e8163f0524748b467ea1ac2a1c402",
			product_label = "V2EUFLAMBOYANTSE",
			class = "UnlockDlc",
			backend_reward_id = "mercenary_bundle"
		},
		shade_bundle = {
			id = "4f7781f15dae4dc7ad33953a62259dbc",
			product_label = "V2EUAGENTOFMALEK",
			class = "UnlockDlc",
			backend_reward_id = "shade_bundle"
		}
	}
}
morris.statistics_definitions = {
	"scripts/managers/backend/statistics_definitions_morris"
}
morris.statistics_util = {
	"scripts/managers/backend/statistics_util_morris"
}
morris.attachment_node_linking = {
	"scripts/settings/dlcs/morris/attachment_node_linking_morris"
}
morris.anim_lookup = {
	"to_dr_deus_01",
	"to_dr_deus_01_loaded",
	"to_dr_deus_01_noammo",
	"parry_stab_02"
}
morris.mutators = {
	"no_sorcerers",
	"curse_corrupted_flesh",
	"curse_skulls_of_fury",
	"curse_change_of_tzeentch",
	"curse_blood_storm",
	"curse_bolt_of_change",
	"curse_monophobia",
	"curse_empathy",
	"curse_rotten_miasma",
	"curse_khorne_champions",
	"curse_skulking_sorcerer",
	"curse_abundance_of_life",
	"curse_greed_pinata",
	"curse_egg_of_tzeentch",
	"blessing_of_shallya",
	"blessing_of_grimnir",
	"blessing_of_isha",
	"blessing_of_ranald",
	"blessing_of_abundance",
	"increased_grenades",
	"increased_deus_potions",
	"increased_deus_soft_currency",
	"increased_healing",
	"deus_more_hordes",
	"deus_less_hordes",
	"deus_more_monsters",
	"deus_less_monsters",
	"deus_more_roamers",
	"deus_less_roamers",
	"deus_more_specials",
	"deus_less_specials",
	"deus_more_elites",
	"deus_less_elites",
	"deus_pacing_tweak",
	"deus_difficulty_tweak",
	"no_roamers",
	"easier_packs",
	"easier_hordes",
	"pacing_frozen",
	"escape"
}
morris.mutator_common_settings = {
	deus = {
		initial_activation_delay = 10
	}
}
morris.interactions = {
	"deus_access",
	"deus_weapon_chest",
	"deus_cursed_chest",
	"deus_debug_changelog",
	"deus_cursed_chest",
	"deus_setup_rally_flag",
	"deus_arena_interactable"
}
morris.interactions_filenames = {
	"scripts/settings/dlcs/morris/morris_interactions"
}
morris.interaction_ui_components = {
	swap_melee = {
		class_name = "DeusSwapWeaponInteractionUI",
		filename = "scripts/settings/dlcs/morris/deus_swap_weapon_interaction_ui"
	},
	swap_ranged = {
		class_name = "DeusSwapRangedInteractionUI",
		filename = "scripts/settings/dlcs/morris/deus_swap_ranged_interaction_ui"
	},
	upgrade = {
		class_name = "DeusUpgradeWeaponInteractionUI",
		filename = "scripts/settings/dlcs/morris/deus_upgrade_weapon_interaction_ui"
	},
	power_up = {
		class_name = "DeusPowerUpInteractionUI",
		filename = "scripts/settings/dlcs/morris/deus_power_up_interaction_ui"
	}
}
morris.vote_template_filenames = {
	"scripts/settings/dlcs/morris/morris_vote_templates"
}
morris.mechanism_settings = {
	deus = {
		disable_difficulty_check = true,
		display_name = "area_selection_morris_name",
		start_game_play_sound_event = "hud_morris_start_menu_play",
		server_port = 27017,
		default_inventory = true,
		should_display_weapon_disclaimer = true,
		start_game_open_sound_event = "hud_morris_start_menu_open",
		use_alt_horde_spawning = true,
		file = "scripts/managers/game_mode/mechanisms/deus_mechanism",
		query_port = 27016,
		class_name = "DeusMechanism",
		start_game_close_sound_event = "hud_morris_start_menu_close",
		steam_port = 8766,
		vote_switch_mechanism_text = "vote_switch_mechanism_morris_description",
		server_universe = "deus",
		vote_switch_mechanism_background = "vote_switch_mechanism_morris_background",
		check_matchmaking_hero_availability = true,
		playfab_mirror = "PlayFabMirrorAdventure",
		use_gamepad_layout = true,
		default_difficulty = "hard",
		rcon_port = 27015,
		states = {
			"inn_deus",
			"ingame_deus",
			"map_deus",
			"tutorial"
		},
		venture_end_states_in = {
			"inn_deus"
		},
		venture_end_states_out = {
			"inn_deus"
		},
		party_data = {
			heroes = {
				party_id = 1,
				name = "heroes",
				num_slots = 4
			}
		},
		progress_loss_warning_message_data = {
			message = "exit_warning",
			is_allowed = function ()
				-- function 1
				return Managers.mechanism:get_state() ~= "inn_deus"
			end
		},
		gamemode_lookup = {}
	}
}
morris.game_mode_files = {
	"scripts/managers/game_mode/game_modes/game_mode_inn_deus",
	"scripts/managers/game_mode/game_modes/game_mode_map_deus",
	"scripts/managers/game_mode/game_modes/game_mode_deus"
}
morris.game_modes = {
	"inn_deus",
	"map_deus",
	"deus"
}
morris.mechanisms = {
	"deus"
}
morris.matchmaking_types = {
	"inn_deus",
	"map_deus",
	"deus",
	"deus_weekly"
}
morris.game_mode = "scripts/settings/dlcs/morris/game_mode_settings_morris"
morris.end_view = {
	"scripts/ui/views/level_end/level_end_view_deus"
}
morris.husk_lookup = {
	"units/props/inn/deus/deus_chest_01",
	"units/props/inn/deus/deus_cursed_chest",
	"units/props/deus_pickups/deus_loot_pyramide_01",
	"units/weapons/player/pup_deus_potion_01/pup_deus_potion_01",
	"units/weapons/player/wpn_dr_deus_projectile_01/wpn_dr_deus_projectile_01_3ps",
	"units/weapons/player/wpn_we_quiver_t1/wpn_we_deus_arrow_01_3ps",
	"units/props/skull_of_fury",
	"units/weapons/player/pup_deus_relic_01/pup_deus_relic_01",
	"units/weapons/player/pup_deus_folded_rally_flag_01/pup_deus_folded_rally_flag_01",
	"units/props/deus_rally_flag/deus_rally_flag",
	"units/gameplay/rotten_miasma_safe_area/rotten_miasma_safe_area_01",
	"units/decals/deus_decal_bloodstorm_inner",
	"units/decals/deus_decal_bloodstorm_outer",
	"units/weapons/player/pup_grenades/pup_holy_hand_grenade_01_t1",
	"units/weapons/player/wpn_emp_holy_hand_grenade_01_t1/wpn_emp_holy_hand_grenade_01_t1_3p",
	"units/props/egg_of_tzeentch",
	"units/decals/deus_decal_aoe_bluefire_02",
	"units/props/deus_pinata/deus_pinata_01",
	"units/weapons/player/pup_explosive_barrel/pup_tiny_explosive_barrel_01",
	"units/props/level_hero_assets/deus_portal_02",
	"units/decals/deus_decal_aoe_cursedchest_01"
}
morris.hit_effects = {
	"scripts/settings/hit_effects/hit_effects_chaos_greed_pinata"
}
morris.effects = {
	"fx/deus_prop_pinata_teleport",
	"fx/cw_chain_lightning"
}
morris.unit_extension_templates = {
	"scripts/settings/dlcs/morris/morris_unit_extension_templates"
}
morris.game_object_initializers = {
	deus_weapon_chest = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local extension = ScriptUnit.extension(arg_2_0, "pickup_system")
		local pickup_name = extension.pickup_name
		local has_physics = extension.has_physics
		local spawn_type = extension.spawn_type

		return {
			go_type = NetworkLookup.go_types.deus_weapon_chest,
			husk_unit = NetworkLookup.husks[arg_2_1],
			pickup_name = NetworkLookup.pickup_names[pickup_name],
			has_physics = has_physics,
			spawn_type = NetworkLookup.pickup_spawn_types[spawn_type],
			position = Unit.local_position(arg_2_0, 0),
			rotation = Unit.local_rotation(arg_2_0, 0)
		}
	end,
	deus_cursed_chest = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		local extension = ScriptUnit.extension(arg_3_0, "pickup_system")
		local pickup_name = extension.pickup_name
		local has_physics = extension.has_physics
		local spawn_type = extension.spawn_type

		return {
			go_type = NetworkLookup.go_types.deus_cursed_chest,
			husk_unit = NetworkLookup.husks[arg_3_1],
			pickup_name = NetworkLookup.pickup_names[pickup_name],
			has_physics = has_physics,
			spawn_type = NetworkLookup.pickup_spawn_types[spawn_type],
			position = Unit.local_position(arg_3_0, 0),
			rotation = Unit.local_rotation(arg_3_0, 0)
		}
	end,
	buff_objective_unit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		-- function 4
		local tbl = {}
		local initial_buff_names = ScriptUnit.extension(arg_4_0, "buff_system"):initial_buff_names()

		for k, v in pairs(initial_buff_names) do
			local var_4_2 = NetworkLookup.buff_templates[v]

			table.insert(tbl, var_4_2)
		end

		return {
			go_type = NetworkLookup.go_types.buff_objective_unit,
			husk_unit = NetworkLookup.husks[arg_4_1],
			position = Unit.local_position(arg_4_0, 0),
			rotation = Unit.local_rotation(arg_4_0, 0),
			network_buff_ids = tbl
		}
	end,
	egg_of_tzeentch_unit = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		local tbl = {}
		local initial_buff_names = ScriptUnit.extension(arg_5_0, "buff_system"):initial_buff_names()

		for k, v in pairs(initial_buff_names) do
			local var_5_2 = NetworkLookup.buff_templates[v]

			table.insert(tbl, var_5_2)
		end

		local has_extension = ScriptUnit.has_extension(arg_5_0, "health_system")
		local has_extension_2 = ScriptUnit.has_extension(arg_5_0, "timed_spawner_system")
		local get_spawn_rate = has_extension_2:get_spawn_rate()
		local tbl_2 = {}
		local get_spawnable_breeds = has_extension_2:get_spawnable_breeds()

		for k_2, v_2 in pairs(get_spawnable_breeds) do
			local var_5_8 = NetworkLookup.breeds[v_2]

			table.insert(tbl_2, var_5_8)
		end

		local get_max_spawn_amount = has_extension_2:get_max_spawn_amount()

		return {
			go_type = NetworkLookup.go_types.egg_of_tzeentch_unit,
			husk_unit = NetworkLookup.husks[arg_5_1],
			position = Unit.local_position(arg_5_0, 0),
			rotation = Unit.local_rotation(arg_5_0, 0),
			network_buff_ids = tbl,
			health = has_extension:get_max_health(),
			max_spawn_amount = get_max_spawn_amount,
			spawnable_breeds = tbl_2,
			spawn_rate = get_spawn_rate
		}
	end,
	deus_relic = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		local extension = ScriptUnit.extension(arg_6_0, "projectile_locomotion_system")
		local network_position = extension.network_position
		local network_rotation = extension.network_rotation
		local network_velocity = extension.network_velocity
		local network_angular_velocity = extension.network_angular_velocity
		local extension_2 = ScriptUnit.extension(arg_6_0, "pickup_system")
		local pickup_name = extension_2.pickup_name
		local has_physics = extension_2.has_physics
		local spawn_type = extension_2.spawn_type

		return {
			go_type = NetworkLookup.go_types.deus_relic,
			husk_unit = NetworkLookup.husks[arg_6_1],
			position = Unit.local_position(arg_6_0, 0),
			rotation = Unit.local_rotation(arg_6_0, 0),
			network_position = network_position,
			network_rotation = network_rotation,
			network_velocity = network_velocity,
			network_angular_velocity = network_angular_velocity,
			debug_pos = Unit.local_position(arg_6_0, 0),
			pickup_name = NetworkLookup.pickup_names[pickup_name],
			has_physics = has_physics,
			spawn_type = NetworkLookup.pickup_spawn_types[spawn_type]
		}
	end,
	buffed_timed_explosion_unit = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
		local extension = ScriptUnit.extension(arg_7_0, "area_damage_system")
		local follow_unit = extension.follow_unit
		local explosion_template_name = extension.explosion_template_name
		local network = Managers.state.network
		local tbl = {}
		local initial_buff_names = ScriptUnit.extension(arg_7_0, "buff_system"):initial_buff_names()

		for k, v in pairs(initial_buff_names) do
			local var_7_6 = NetworkLookup.buff_templates[v]

			table.insert(tbl, var_7_6)
		end

		return {
			go_type = NetworkLookup.go_types.buffed_timed_explosion_unit,
			husk_unit = NetworkLookup.husks[arg_7_1],
			follow_unit = network:unit_game_object_id(follow_unit),
			explosion_template_name = NetworkLookup.explosion_templates[explosion_template_name],
			position = Unit.local_position(arg_7_0, 0),
			rotation = Unit.local_rotation(arg_7_0, 0),
			network_buff_ids = tbl
		}
	end
}
morris.game_object_extractors = {
	deus_weapon_chest = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		-- function 8
		local game_object_field = GameSession.game_object_field(arg_8_0, arg_8_1, "pickup_name")
		local game_object_field_2 = GameSession.game_object_field(arg_8_0, arg_8_1, "has_physics")
		local game_object_field_3 = GameSession.game_object_field(arg_8_0, arg_8_1, "spawn_type")
		local tbl = {
			pickup_system = {
				pickup_name = NetworkLookup.pickup_names[game_object_field],
				has_physics = game_object_field_2,
				spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_3]
			}
		}

		return "deus_weapon_chest", tbl
	end,
	deus_cursed_chest = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		-- function 9
		local game_object_field = GameSession.game_object_field(arg_9_0, arg_9_1, "pickup_name")
		local game_object_field_2 = GameSession.game_object_field(arg_9_0, arg_9_1, "has_physics")
		local game_object_field_3 = GameSession.game_object_field(arg_9_0, arg_9_1, "spawn_type")
		local tbl = {
			pickup_system = {
				pickup_name = NetworkLookup.pickup_names[game_object_field],
				has_physics = game_object_field_2,
				spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_3]
			}
		}

		return "deus_cursed_chest", tbl
	end,
	buff_objective_unit = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		-- function 10
		local tbl = {}
		local game_object_field = GameSession.game_object_field(arg_10_0, arg_10_1, "network_buff_ids")

		if not game_object_field then
			for i, v in ipairs(game_object_field) do
				local var_10_2 = NetworkLookup.buff_templates[v]

				table.insert(tbl, var_10_2)
			end
		end

		local tbl_2 = {
			buff_system = {
				initial_buff_names = tbl
			}
		}

		return "buff_objective_unit", tbl_2
	end,
	deus_relic = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
		-- function 11
		local game_object_field = GameSession.game_object_field(arg_11_0, arg_11_1, "network_position")
		local game_object_field_2 = GameSession.game_object_field(arg_11_0, arg_11_1, "network_rotation")
		local game_object_field_3 = GameSession.game_object_field(arg_11_0, arg_11_1, "network_velocity")
		local game_object_field_4 = GameSession.game_object_field(arg_11_0, arg_11_1, "network_angular_velocity")
		local game_object_field_5 = GameSession.game_object_field(arg_11_0, arg_11_1, "pickup_name")
		local game_object_field_6 = GameSession.game_object_field(arg_11_0, arg_11_1, "has_physics")
		local game_object_field_7 = GameSession.game_object_field(arg_11_0, arg_11_1, "spawn_type")
		local tbl = {
			projectile_locomotion_system = {
				network_position = game_object_field,
				network_rotation = game_object_field_2,
				network_velocity = game_object_field_3,
				network_angular_velocity = game_object_field_4
			},
			pickup_system = {
				pickup_name = NetworkLookup.pickup_names[game_object_field_5],
				has_physics = game_object_field_6,
				spawn_type = NetworkLookup.pickup_spawn_types[game_object_field_7]
			}
		}

		return "deus_relic", tbl
	end,
	egg_of_tzeentch_unit = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		-- function 12
		local tbl = {}
		local game_object_field = GameSession.game_object_field(arg_12_0, arg_12_1, "network_buff_ids")

		if not game_object_field then
			for i, v in ipairs(game_object_field) do
				local var_12_2 = NetworkLookup.buff_templates[v]

				table.insert(tbl, var_12_2)
			end
		end

		local game_object_field_2 = GameSession.game_object_field(arg_12_0, arg_12_1, "health")
		local game_object_field_3 = GameSession.game_object_field(arg_12_0, arg_12_1, "spawn_rate")
		local game_object_field_4 = GameSession.game_object_field(arg_12_0, arg_12_1, "spawnable_breeds")
		local game_object_field_5 = GameSession.game_object_field(arg_12_0, arg_12_1, "max_spawn_amount")
		local tbl_2 = {
			health_system = {
				health = game_object_field_2
			},
			death_system = {
				death_reaction_template = "destructible_buff_objective_unit",
				is_husk = true
			},
			hit_reaction_system = {
				is_husk = true,
				hit_reaction_template = "level_object"
			},
			buff_system = {
				initial_buff_names = tbl
			},
			timed_spawner_system = {
				spawn_rate = game_object_field_3,
				spawnable_breeds = game_object_field_4,
				max_spawn_amount = game_object_field_5
			}
		}

		return "egg_of_tzeentch_unit", tbl_2
	end,
	buffed_timed_explosion_unit = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
		-- function 13
		local game_object_field = GameSession.game_object_field(arg_13_0, arg_13_1, "follow_unit")
		local game_object_field_2 = GameSession.game_object_field(arg_13_0, arg_13_1, "explosion_template_name")
		local tbl = {}
		local game_object_field_3 = GameSession.game_object_field(arg_13_0, arg_13_1, "network_buff_ids")

		if not game_object_field_3 then
			for i, v in ipairs(game_object_field_3) do
				local var_13_4 = NetworkLookup.buff_templates[v]

				table.insert(tbl, var_13_4)
			end
		end

		local tbl_2 = {
			area_damage_system = {
				follow_unit = Managers.state.unit_storage:unit(game_object_field),
				explosion_template_name = NetworkLookup.explosion_templates[game_object_field_2]
			},
			buff_system = {
				initial_buff_names = tbl
			}
		}

		return "buffed_timed_explosion_unit", tbl_2
	end
}
morris.game_object_templates = {
	deus_weapon_chest = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	deus_cursed_chest = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	buff_objective_unit = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	deus_relic = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	},
	egg_of_tzeentch_unit = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit"
	},
	buffed_timed_explosion_unit = {
		game_object_created_func_name = "game_object_created_network_unit",
		syncs_position = true,
		syncs_rotation = true,
		game_object_destroyed_func_name = "game_object_destroyed_network_unit",
		is_level_unit = false
	}
}
morris.network_go_types = {
	"deus_weapon_chest",
	"deus_cursed_chest",
	"buff_objective_unit",
	"deus_relic",
	"egg_of_tzeentch_unit",
	"buffed_timed_explosion_unit"
}
morris.conflict_settings_files = {
	"scripts/settings/dlcs/morris/deus_conflict_settings"
}
morris.generic_terror_event_files = {
	"scripts/settings/dlcs/morris/deus_generic_terror_events"
}
morris.weapon_skins_file_names = {
	"scripts/settings/equipment/weapon_skins_morris"
}
morris.weapon_traits_file_names = {
	"scripts/settings/equipment/weapon_traits_morris"
}
morris.weapon_properties_file_names = {
	"scripts/settings/equipment/weapon_properties_morris"
}
morris.hero_hud_components = {
	"DeusSoftCurrencyIndicatorUI",
	"DeusCurseUI",
	"EnergyBarUI"
}

if BUILD ~= "release" or not script_data.debug_enabled then
	table.insert(morris.hero_hud_components, "DeusDebugUI")
	table.insert(morris.hero_hud_components, "DeusDebugMapUI")
end

morris.horde_composition_file = "scripts/settings/dlcs/morris/morris_horde_compositions"
morris.horde_compositions_pacing_file = "scripts/settings/dlcs/morris/morris_horde_compositions_pacing"
morris.material_effect_mappings_file_names = {
	"scripts/settings/material_effect_mappings_morris"
}
morris.systems = {
	"scripts/entity_system/systems/deus_chest/deus_chest_preload_system"
}
morris.entity_extensions = {
	"scripts/unit_extensions/deus/deus_chest_preload_extension",
	"scripts/unit_extensions/deus/deus_cursed_chest_extension",
	"scripts/unit_extensions/deus/deus_relic_extension",
	"scripts/unit_extensions/deus/deus_arena_idol_extension",
	"scripts/unit_extensions/deus/deus_arena_interactable_extension",
	"scripts/unit_extensions/generic/timed_spawner_extension",
	"scripts/unit_extensions/ai_supplementary/curse_corruptor_beam_extension"
}
morris.entity_system_params = {
	deus_chest_preload_system = {
		system_class_name = "DeusChestPreloadSystem",
		system_name = "deus_chest_preload_system",
		extension_list = {
			"DeusChestPreloadExtension"
		}
	},
	deus_cursed_chest_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "deus_cursed_chest_system",
		extension_list = {
			"DeusCursedChestExtension"
		}
	},
	deus_relic_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "deus_relic_system",
		extension_list = {
			"DeusRelicExtension"
		}
	},
	timed_spawner_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "timed_spawner_system",
		extension_list = {
			"TimedSpawnerExtension"
		}
	},
	deus_arena_idol_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "deus_arena_idol_system",
		extension_list = {
			"DeusArenaIdolExtension"
		}
	},
	deus_arena_interactable_system = {
		system_class_name = "ExtensionSystemBase",
		system_name = "deus_arena_interactable_system",
		extension_list = {
			"DeusArenaInteractableExtension"
		}
	}
}
morris.additional_system_extensions = {
	pickup_system = {
		{
			require = "scripts/unit_extensions/pickups/deus_chest_extension",
			class = "DeusChestExtension"
		}
	}
}
morris.network_damage_types = {
	"curse_empathy",
	"skulls_of_fury",
	"blood_storm",
	"bolt_of_change"
}
morris.network_damage_sources = {
	"poison_dot"
}
morris.network_lookups = {
	deus_blessings = "DeusBlessingSettings",
	deus_themes = "DeusThemeSettings",
	deus_power_up_templates = "DeusPowerUpTemplates",
	deus_journeys = "DeusJourneySettings",
	deus_chest_types = "DEUS_CHEST_TYPES"
}
morris.twitch_settings = {
	vote_templates_file = "scripts/settings/dlcs/morris/twitch_vote_templates_morris",
	supported_game_modes = {
		map_deus = true,
		deus = true
	},
	vote_whitelists = {
		map_deus = {},
		deus = {
			"twitch_vote_infinite_bombs",
			"twitch_add_damage_potion_buff",
			"twitch_add_cooldown_potion_buff",
			"twitch_spawn_minotaur",
			"twitch_spawn_poison_wind_globadier",
			"twitch_health_regen",
			"twitch_vote_activate_ticking_bomb",
			"twitch_spawn_stormfiend",
			"twitch_vote_activate_realism",
			"twitch_spawn_rat_ogre",
			"twitch_give_healing_draught",
			"twitch_spawn_death_squad_chaos_warrior",
			"twitch_spawn_horde_vector_blob",
			"twitch_spawn_berzerkers",
			"twitch_give_frag_grenade_t1",
			"twitch_vote_full_temp_hp",
			"twitch_give_first_aid_kit",
			"twitch_spawn_explosive_loot_rats",
			"twitch_spawn_death_squad_storm_vermin",
			"twitch_give_fire_grenade_t1",
			"twitch_spawn_gutter_runner",
			"twitch_spawn_plague_monks",
			"twitch_spawn_vortex_sorcerer",
			"twitch_spawn_pack_master",
			"twitch_vote_hemmoraghe",
			"twitch_vote_activate_root",
			"twitch_add_speed_potion_buff",
			"twitch_health_degen",
			"twitch_vote_critical_strikes",
			"twitch_spawn_warpfire_thrower",
			"twitch_spawn_chaos_troll",
			"twitch_spawn_ratling_gunner",
			"twitch_spawn_chaos_spawn"
		}
	}
}
morris.camera_shake_settings = {
	holy_hand_grenade_explosion = {
		persistance = 1.2,
		amplitude = 1.5,
		duration = 0.4,
		fade_out = 0.5,
		octaves = 7
	}
}
morris.death_reactions = {
	"scripts/settings/dlcs/morris/morris_death_reactions"
}
morris.dot_type_lookup = {
	we_deus_01_dot_fast = "burning_dot",
	burning_magma_dot = "burning_dot",
	boon_career_ability_poison_aoe = "poison_dot",
	boon_career_ability_burning_aoe = "burning_dot",
	we_deus_01_dot = "burning_dot",
	we_deus_01_dot_special_charged = "burning_dot",
	boon_career_ability_bleed_aoe = "poison_dot",
	we_deus_01_dot_charged = "burning_dot"
}
morris.end_view_state = {
	"scripts/ui/views/level_end/states/end_view_state_summary_deus"
}
morris.loading_tips_file = "scripts/settings/dlcs/morris/morris_loading_tips"
morris.drone_templates = {
	deus_damage_drone = {
		impact_vfx = "fx/skulls_2024/boons_drone_projectile_impact_fx",
		impact_sfx = "Play_boon_drone_impact",
		spawn_sfx = "Play_boon_drone_spawn",
		linked_vfx = {
			destroy_policy = "stop",
			name = "fx/skulls_2024/boons_drone_projectile_fx"
		}
	}
}
