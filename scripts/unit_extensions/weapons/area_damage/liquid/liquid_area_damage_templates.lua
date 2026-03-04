-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/liquid_area_damage_templates.lua

LiquidAreaDamageTemplates = {}
LiquidAreaDamageTemplates.templates = {
	bile_troll_vomit_near = {
		do_direct_damage_ai = true,
		sfx_name_stop = "Stop_enemy_troll_puke_loop",
		cell_size = 1,
		liquid_spread_function = "pour_spread",
		starting_pressure = 20,
		apply_buff_to_player = true,
		do_direct_damage_player = false,
		buff_template_name = "bile_troll_vomit_ground_base",
		linearized_flow = false,
		damage_type = "vomit_ground",
		sfx_name_start = "Play_enemy_troll_puke_loop",
		init_function = "bile_troll_vomit_init",
		end_pressure = 3,
		fx_name_filled = "fx/wpnfx_troll_vomit_impact_01",
		apply_buff_to_ai = false,
		time_of_life = 7,
		max_liquid = 30,
		update_function = "bile_troll_vomit_update",
		use_nav_cost_map_volumes = true,
		buff_template_type = "troll_bile_ground",
		nav_cost_map_cost_type = "troll_bile",
		buff_condition_function = "bile_troll_vomit_ground_base_condition",
		immune_breeds = {
			chaos_troll = true,
			chaos_dummy_troll = true,
			chaos_spawn = true,
			skaven_rat_ogre = true,
			skaven_stormfiend = true
		},
		difficulty_direct_damage = {
			easy = {
				1,
				1,
				0,
				0,
				1
			},
			normal = {
				1,
				1,
				0,
				0,
				1
			},
			hard = {
				1,
				1,
				0,
				0,
				1
			},
			harder = {
				1,
				1,
				0,
				0,
				1
			},
			hardest = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm_2 = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm_3 = {
				1,
				1,
				0,
				0,
				1
			},
			versus_base = {
				1,
				1,
				0,
				0,
				1
			}
		}
	},
	bile_troll_vomit = {
		do_direct_damage_ai = true,
		sfx_name_stop = "Stop_enemy_troll_puke_loop",
		cell_size = 1,
		liquid_spread_function = "default_spread",
		starting_pressure = 20,
		apply_buff_to_player = true,
		do_direct_damage_player = false,
		buff_template_name = "bile_troll_vomit_ground_base",
		linearized_flow = false,
		damage_type = "vomit_ground",
		sfx_name_start = "Play_enemy_troll_puke_loop",
		init_function = "bile_troll_vomit_init",
		end_pressure = 3,
		fx_name_filled = "fx/wpnfx_troll_vomit_impact_01",
		apply_buff_to_ai = false,
		time_of_life = 7,
		max_liquid = 20,
		update_function = "bile_troll_vomit_update",
		use_nav_cost_map_volumes = true,
		buff_template_type = "troll_bile_ground",
		nav_cost_map_cost_type = "troll_bile",
		buff_condition_function = "bile_troll_vomit_ground_base_condition",
		immune_breeds = {
			chaos_troll = true,
			chaos_dummy_troll = true,
			chaos_spawn = true,
			skaven_rat_ogre = true,
			skaven_stormfiend = true
		},
		difficulty_direct_damage = {
			easy = {
				1,
				1,
				0,
				0,
				1
			},
			normal = {
				1,
				1,
				0,
				0,
				1
			},
			hard = {
				1,
				1,
				0,
				0,
				1
			},
			harder = {
				1,
				1,
				0,
				0,
				1
			},
			hardest = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm_2 = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm_3 = {
				1,
				1,
				0,
				0,
				1
			},
			versus_base = {
				1,
				1,
				0,
				0,
				1
			}
		},
		hit_player_function = function (arg_1_0, arg_1_1, arg_1_2)
			if Unit.alive(arg_1_2) then
				local var_1_0 = BLACKBOARDS[arg_1_2]

				if var_1_0 then
					var_1_0.has_done_bile_damage = true
				end
			end
		end
	},
	bile_troll_chief_downed_vomit = {
		do_direct_damage_ai = true,
		sfx_name_stop = "Stop_enemy_troll_puke_loop",
		cell_size = 1,
		liquid_spread_function = "pour_spread",
		starting_pressure = 30,
		apply_buff_to_player = true,
		do_direct_damage_player = false,
		buff_template_name = "bile_troll_vomit_ground_downed",
		linearized_flow = false,
		damage_type = "vomit_ground",
		sfx_name_start = "Play_enemy_troll_puke_loop",
		init_function = "bile_troll_vomit_init",
		end_pressure = 3,
		fx_name_filled = "fx/wpnfx_troll_vomit_impact_01",
		apply_buff_to_ai = false,
		time_of_life = 7,
		max_liquid = 160,
		update_function = "bile_troll_vomit_update",
		use_nav_cost_map_volumes = true,
		buff_template_type = "troll_bile_ground",
		nav_cost_map_cost_type = "troll_bile",
		buff_condition_function = "bile_troll_vomit_ground_base_condition",
		immune_breeds = {
			chaos_troll = true,
			chaos_dummy_troll = true,
			chaos_spawn = true,
			skaven_rat_ogre = true,
			skaven_stormfiend = true
		},
		difficulty_direct_damage = {
			easy = {
				1,
				1,
				0,
				0,
				1
			},
			normal = {
				1,
				1,
				0,
				0,
				1
			},
			hard = {
				1,
				1,
				0,
				0,
				1
			},
			harder = {
				1,
				1,
				0,
				0,
				1
			},
			hardest = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm_2 = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm_3 = {
				1,
				1,
				0,
				0,
				1
			},
			versus_base = {
				1,
				1,
				0,
				0,
				1
			}
		}
	},
	vs_bile_troll_vomit_near = {
		do_direct_damage_ai = true,
		sfx_name_stop = "Stop_enemy_troll_puke_loop",
		cell_size = 1,
		liquid_spread_function = "pour_spread",
		starting_pressure = 30,
		apply_buff_to_player = true,
		do_direct_damage_player = false,
		buff_template_name = "bile_troll_vomit_ground_base",
		linearized_flow = false,
		damage_type = "vomit_ground",
		sfx_name_start = "Play_enemy_troll_puke_loop",
		init_function = "vs_bile_troll_vomit_init",
		end_pressure = 3,
		fx_name_filled = "fx/wpnfx_troll_vomit_impact_01",
		apply_buff_to_ai = false,
		time_of_life = 7,
		max_liquid = 80,
		update_function = "vs_bile_troll_vomit_update",
		use_nav_cost_map_volumes = true,
		buff_template_type = "troll_bile_ground",
		nav_cost_map_cost_type = "troll_bile",
		buff_condition_function = "bile_troll_vomit_ground_base_condition",
		immune_breeds = {
			vs_warpfire_thrower = true,
			vs_chaos_troll = true,
			chaos_dummy_troll = true,
			vs_ratling_gunner = true,
			chaos_spawn = true,
			skaven_rat_ogre = true,
			chaos_troll = true,
			vs_gutter_runner = true,
			vs_poison_wind_globadier = true,
			vs_packmaster = true,
			skaven_stormfiend = true
		},
		difficulty_direct_damage = {
			easy = {
				2,
				2,
				0,
				0,
				2
			},
			normal = {
				2,
				2,
				0,
				0,
				2
			},
			hard = {
				2,
				2,
				0,
				0,
				2
			},
			harder = {
				2,
				2,
				0,
				0,
				2
			},
			hardest = {
				2,
				2,
				0,
				0,
				2
			},
			cataclysm = {
				2,
				2,
				0,
				0,
				2
			},
			cataclysm_2 = {
				2,
				2,
				0,
				0,
				2
			},
			cataclysm_3 = {
				2,
				2,
				0,
				0,
				2
			},
			versus_base = {
				2,
				2,
				0,
				0,
				2
			}
		}
	},
	vs_bile_troll_vomit = {
		do_direct_damage_ai = true,
		sfx_name_stop = "Stop_enemy_troll_puke_loop",
		cell_size = 1,
		liquid_spread_function = "pour_spread",
		starting_pressure = 30,
		apply_buff_to_player = true,
		do_direct_damage_player = false,
		buff_template_name = "bile_troll_vomit_ground_base",
		linearized_flow = false,
		damage_type = "vomit_ground",
		sfx_name_start = "Play_enemy_troll_puke_loop",
		init_function = "vs_bile_troll_vomit_init",
		end_pressure = 3,
		fx_name_filled = "fx/wpnfx_troll_vomit_impact_01",
		apply_buff_to_ai = false,
		time_of_life = 7,
		max_liquid = 80,
		update_function = "vs_bile_troll_vomit_update",
		use_nav_cost_map_volumes = true,
		buff_template_type = "troll_bile_ground",
		nav_cost_map_cost_type = "troll_bile",
		buff_condition_function = "bile_troll_vomit_ground_base_condition",
		immune_breeds = {
			vs_warpfire_thrower = true,
			vs_chaos_troll = true,
			chaos_dummy_troll = true,
			vs_ratling_gunner = true,
			chaos_spawn = true,
			skaven_rat_ogre = true,
			chaos_troll = true,
			vs_gutter_runner = true,
			vs_poison_wind_globadier = true,
			vs_packmaster = true,
			skaven_stormfiend = true
		},
		difficulty_direct_damage = {
			easy = {
				2.8,
				2.8,
				0,
				0,
				2.8
			},
			normal = {
				2.8,
				2.8,
				0,
				0,
				2.8
			},
			hard = {
				2.8,
				2.8,
				0,
				0,
				2.8
			},
			harder = {
				2.8,
				2.8,
				0,
				0,
				2.8
			},
			hardest = {
				2.8,
				2.8,
				0,
				0,
				2.8
			},
			cataclysm = {
				2.8,
				2.8,
				0,
				0,
				2.8
			},
			cataclysm_2 = {
				2.8,
				2.8,
				0,
				0,
				2.8
			},
			cataclysm_3 = {
				2.8,
				2.8,
				0,
				0,
				2.8
			},
			versus_base = {
				2.8,
				2.8,
				0,
				0,
				2.8
			}
		},
		hit_player_function = function (arg_2_0, arg_2_1, arg_2_2)
			if Unit.alive(arg_2_2) then
				local var_2_0 = BLACKBOARDS[arg_2_2]

				if var_2_0 then
					var_2_0.has_done_bile_damage = true
				end
			end
		end
	},
	nurgle_liquid = {
		do_direct_damage_ai = true,
		sfx_name_stop = "Stop_nurgle_infection_loop",
		cell_size = 0.6,
		liquid_spread_function = "pour_spread",
		starting_pressure = 10,
		apply_buff_to_player = true,
		do_direct_damage_player = false,
		buff_template_name = "bile_troll_vomit_ground_base",
		linearized_flow = false,
		damage_type = "vomit_ground",
		sfx_name_start = "Play_nurgle_infection_loop",
		init_function = "bile_troll_vomit_init",
		end_pressure = 3,
		fx_name_filled = "fx/nurgle_liquid_blob_ground_01",
		apply_buff_to_ai = false,
		time_of_life = 10,
		max_liquid = 12,
		update_function = "bile_troll_vomit_update",
		use_nav_cost_map_volumes = true,
		buff_template_type = "troll_bile_ground",
		nav_cost_map_cost_type = "troll_bile",
		buff_condition_function = "bile_troll_vomit_ground_base_condition",
		immune_breeds = {
			chaos_troll = true,
			chaos_dummy_troll = true,
			chaos_spawn = true,
			skaven_rat_ogre = true,
			skaven_stormfiend = true
		},
		difficulty_direct_damage = {
			easy = {
				1,
				1,
				0,
				0,
				1
			},
			normal = {
				1,
				1,
				0,
				0,
				1
			},
			hard = {
				1,
				1,
				0,
				0,
				1
			},
			harder = {
				1,
				1,
				0,
				0,
				1
			},
			hardest = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm_2 = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm_3 = {
				1,
				1,
				0,
				0,
				1
			},
			versus_base = {
				1,
				1,
				0,
				0,
				1
			}
		},
		hit_player_function = function (arg_3_0, arg_3_1)
			local var_3_0 = {
				"nurgle_bathed_all",
				"nurgle_bathed_all_cata"
			}

			for iter_3_0 = 1, #var_3_0 do
				local var_3_1 = Managers.state.difficulty:get_difficulty()
				local var_3_2 = var_3_0[iter_3_0]

				if QuestSettings.allowed_difficulties[var_3_2][var_3_1] then
					local var_3_3 = ScriptUnit.extension(arg_3_0, "status_system")

					var_3_3.num_times_bathed_in_nurgle_liquid = (var_3_3.num_times_bathed_in_nurgle_liquid or 0) + 1

					local var_3_4 = false

					for iter_3_1 = 0, #arg_3_1 do
						local var_3_5 = arg_3_1[iter_3_1]

						if Unit.alive(var_3_5) then
							local var_3_6 = ScriptUnit.extension(var_3_5, "status_system").num_times_bathed_in_nurgle_liquid

							if var_3_6 and var_3_6 >= QuestSettings.nurgle_bathed_all then
								Managers.player:statistics_db():increment_stat_and_sync_to_clients(var_3_0[iter_3_0])

								var_3_4 = true

								break
							end
						end
					end

					if var_3_4 then
						for iter_3_2 = 0, #arg_3_1 do
							local var_3_7 = arg_3_1[iter_3_2]

							if Unit.alive(var_3_7) then
								ScriptUnit.extension(var_3_7, "status_system").num_times_bathed_in_nurgle_liquid = nil
							end
						end
					end
				end
			end
		end
	},
	stormfiend_firewall = {
		do_direct_damage_ai = true,
		sfx_name_stop = "Stop_enemy_stormfiend_fire_ground_loop",
		cell_size = 1,
		liquid_spread_function = "forward_spread",
		starting_pressure = 30,
		apply_buff_to_player = true,
		do_direct_damage_player = false,
		buff_template_name = "stormfiend_warpfire_ground_base",
		linearized_flow = true,
		fx_name_rim = "fx/wpnfx_warp_fire_remains_rim",
		damage_type = "warpfire_ground",
		sfx_name_start = "Play_enemy_stormfiend_fire_ground_loop",
		end_pressure = 2,
		fx_name_filled = "fx/wpnfx_warp_fire_remains",
		apply_buff_to_ai = false,
		time_of_life = 8,
		max_liquid = 20,
		use_nav_cost_map_volumes = true,
		buff_template_type = "stormfiend_warpfire_ground",
		nav_cost_map_cost_type = "stormfiend_warpfire",
		buff_condition_function = "stormfiend_warpfire_ground_base_condition",
		immune_breeds = {
			chaos_troll = true,
			chaos_dummy_troll = true,
			skaven_grey_seer = true,
			chaos_spawn = true,
			skaven_warpfire_thrower = true,
			skaven_rat_ogre = true,
			skaven_stormfiend = true
		},
		difficulty_direct_damage = {
			easy = {
				1,
				1,
				0,
				0,
				1
			},
			normal = {
				2,
				2,
				0,
				0,
				1
			},
			hard = {
				4,
				4,
				0,
				0,
				3
			},
			harder = {
				6,
				6,
				0,
				0,
				6
			},
			hardest = {
				8,
				8,
				0,
				0,
				8
			},
			cataclysm = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm_2 = {
				1,
				1,
				0,
				0,
				1
			},
			cataclysm_3 = {
				1,
				1,
				0,
				0,
				1
			},
			versus_base = {
				1,
				1,
				0,
				0,
				1
			}
		},
		hit_player_function = function (arg_4_0, arg_4_1, arg_4_2)
			if Unit.alive(arg_4_2) then
				BLACKBOARDS[arg_4_2].has_dealt_burn_damage = true
			end
		end
	},
	lamp_oil_fire = {
		do_direct_damage_ai = true,
		sfx_name_stop = "Stop_props_lamp_oil_fire",
		cell_size = 1,
		liquid_spread_function = "pour_spread",
		starting_pressure = 15,
		do_direct_damage_player = true,
		linearized_flow = false,
		fx_name_rim = "fx/wpnfx_lamp_oil_remains_rim",
		damage_type = "burn",
		sfx_name_start = "Play_props_lamp_oil_fire",
		end_pressure = 2,
		fx_name_filled = "fx/wpnfx_lamp_oil_remains",
		time_of_life = 10,
		max_liquid = 50,
		use_nav_cost_map_volumes = true,
		nav_cost_map_cost_type = "lamp_oil_fire",
		immune_breeds = {},
		difficulty_direct_damage = {
			easy = {
				10,
				10,
				10,
				2,
				10
			},
			normal = {
				10,
				10,
				10,
				5,
				10
			},
			hard = {
				10,
				10,
				10,
				6,
				10
			},
			harder = {
				10,
				10,
				10,
				7,
				10
			},
			hardest = {
				10,
				10,
				10,
				8,
				10
			},
			cataclysm = {
				10,
				10,
				10,
				6,
				10
			},
			cataclysm_2 = {
				10,
				10,
				10,
				7,
				10
			},
			cataclysm_3 = {
				10,
				10,
				10,
				8,
				10
			},
			versus_base = {
				10,
				10,
				10,
				5,
				10
			}
		}
	},
	warpfire_death_fire = {
		do_direct_damage_ai = true,
		sfx_name_stop = "Stop_enemy_stormfiend_fire_ground_loop",
		cell_size = 0.75,
		liquid_spread_function = "pour_spread",
		starting_pressure = 15,
		do_direct_damage_player = true,
		linearized_flow = false,
		fx_name_rim = "fx/wpnfx_warp_fire_remains_rim",
		damage_type = "warpfire_ground",
		sfx_name_start = "Play_enemy_stormfiend_fire_ground_loop",
		end_pressure = 2,
		fx_name_filled = "fx/chr_warp_fire_flamethrower_remains_01",
		time_of_life = 5,
		max_liquid = 20,
		use_nav_cost_map_volumes = true,
		nav_cost_map_cost_type = "warpfire_thrower_warpfire",
		immune_breeds = {},
		difficulty_direct_damage = {
			easy = {
				10,
				10,
				10,
				2,
				10
			},
			normal = {
				10,
				10,
				10,
				5,
				10
			},
			hard = {
				10,
				10,
				10,
				6,
				10
			},
			harder = {
				10,
				10,
				10,
				7,
				10
			},
			hardest = {
				10,
				10,
				10,
				8,
				10
			},
			cataclysm = {
				10,
				10,
				10,
				6,
				10
			},
			cataclysm_2 = {
				10,
				10,
				10,
				7,
				10
			},
			cataclysm_3 = {
				10,
				10,
				10,
				8,
				10
			},
			versus_base = {
				10,
				10,
				10,
				5,
				10
			}
		}
	},
	sienna_unchained_ability_patch = {
		do_direct_damage_ai = false,
		cell_size = 1,
		max_liquid = 10,
		below = 30,
		starting_pressure = 15,
		do_direct_damage_player = false,
		damage_buff_template_name = "burning_dot_1tick",
		linearized_flow = false,
		fx_name_rim = "fx/chr_unchained_living_bomb_lingering",
		liquid_spread_function = "pour_spread",
		damage_type = "burninating",
		sfx_name_start = "Play_props_lamp_oil_fire",
		end_pressure = 2,
		fx_name_filled = "fx/chr_unchained_living_bomb_lingering_rim",
		time_of_life = 3,
		above = 2,
		sfx_name_stop = "Stop_props_lamp_oil_fire",
		immune_breeds = {},
		difficulty_direct_damage = {
			easy = {
				0,
				0,
				0,
				0,
				0
			},
			normal = {
				0,
				0,
				0,
				0,
				0
			},
			hard = {
				0,
				0,
				0,
				0,
				0
			},
			harder = {
				0,
				0,
				0,
				0,
				0
			},
			hardest = {
				0,
				0,
				0,
				0,
				0
			},
			cataclysm = {
				0,
				0,
				0,
				0,
				0
			},
			cataclysm_2 = {
				0,
				0,
				0,
				0,
				0
			},
			cataclysm_3 = {
				0,
				0,
				0,
				0,
				0
			},
			versus_base = {
				0,
				0,
				0,
				0,
				0
			}
		}
	},
	sienna_unchained_ability_patch_increased_damage = {
		do_direct_damage_ai = false,
		cell_size = 1,
		max_liquid = 10,
		below = 30,
		starting_pressure = 15,
		do_direct_damage_player = false,
		damage_buff_template_name = "burning_dot_1tick",
		linearized_flow = false,
		fx_name_rim = "fx/chr_unchained_living_bomb_lingering",
		liquid_spread_function = "pour_spread",
		damage_type = "burninating",
		sfx_name_start = "Play_props_lamp_oil_fire",
		end_pressure = 2,
		fx_name_filled = "fx/chr_unchained_living_bomb_lingering_rim",
		time_of_life = 3,
		above = 2,
		sfx_name_stop = "Stop_props_lamp_oil_fire",
		immune_breeds = {},
		difficulty_direct_damage = {
			easy = {
				10,
				10,
				10,
				0,
				10
			},
			normal = {
				10,
				10,
				10,
				0,
				10
			},
			hard = {
				10,
				10,
				10,
				0,
				10
			},
			harder = {
				10,
				10,
				10,
				0,
				10
			},
			hardest = {
				10,
				10,
				10,
				0,
				10
			},
			cataclysm = {
				10,
				10,
				10,
				0,
				10
			},
			cataclysm_2 = {
				10,
				10,
				10,
				0,
				10
			},
			cataclysm_3 = {
				10,
				10,
				10,
				0,
				10
			},
			versus_base = {
				10,
				10,
				10,
				0,
				10
			}
		}
	}
}
LiquidAreaDamageTemplates.templates.troll_chief_vomit = table.clone(LiquidAreaDamageTemplates.templates.bile_troll_vomit)
LiquidAreaDamageTemplates.templates.troll_chief_vomit.fx_name_filled = "fx/wpnfx_troll_chief_vomit_impact_01"
LiquidAreaDamageTemplates.templates.troll_chief_vomit_near = table.clone(LiquidAreaDamageTemplates.templates.bile_troll_vomit_near)
LiquidAreaDamageTemplates.templates.troll_chief_vomit_near.fx_name_filled = "fx/wpnfx_troll_chief_vomit_impact_01"

LiquidAreaDamageTemplates.pour_spread = function (arg_5_0)
	return 1
end

LiquidAreaDamageTemplates.default_spread = function (arg_6_0)
	return math.max((1 - arg_6_0 / math.pi)^2 - 0.45, 0)
end

LiquidAreaDamageTemplates.forward_spread = function (arg_7_0)
	return math.max(1 - arg_7_0 / (math.pi * 0.25), 0)
end

LiquidAreaDamageTemplates.flamethrower_spread = function (arg_8_0)
	return math.max((1 - arg_8_0 / math.pi)^2, 0)
end

LiquidAreaDamageTemplates.bile_troll_vomit_init = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._source_attacker_unit

	if HEALTH_ALIVE[var_9_0] then
		local var_9_1 = arg_9_0._world
		local var_9_2 = Unit.node(var_9_0, "j_tongue_01")
		local var_9_3 = Unit.world_position(var_9_0, var_9_2)
		local var_9_4 = "units/weapons/enemy/wpn_troll_vomit/wpn_troll_vomit"
		local var_9_5 = Managers.state.unit_spawner:spawn_local_unit(var_9_4, var_9_3, nil, nil)

		World.link_unit(var_9_1, var_9_5, var_9_0, var_9_2)
		Unit.flow_event(var_9_5, "fade_in")

		arg_9_0._vomit_unit = var_9_5
		arg_9_0._firing_time_deadline = arg_9_1 + BreedActions.chaos_troll.vomit.firing_time
	end
end

LiquidAreaDamageTemplates.vs_bile_troll_vomit_init = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._source_attacker_unit

	if HEALTH_ALIVE[var_10_0] then
		local var_10_1 = arg_10_0._world
		local var_10_2 = "units/weapons/enemy/wpn_troll_vomit/wpn_troll_vomit"
		local var_10_3 = Managers.state.unit_spawner
		local var_10_4
		local var_10_5 = Managers.player:unit_owner(var_10_0)

		if var_10_5 and var_10_5.remote then
			local var_10_6 = Unit.node(var_10_0, "j_tongue_01")
			local var_10_7 = Unit.world_position(var_10_0, var_10_6)

			var_10_4 = var_10_3:spawn_local_unit(var_10_2, var_10_7, nil, nil)

			World.link_unit(var_10_1, var_10_4, var_10_0, var_10_6)
			Unit.flow_event(var_10_4, "fade_in")

			arg_10_0._fade_out_vomit = true
		else
			local var_10_8 = ScriptUnit.has_extension(var_10_0, "first_person_system")
			local var_10_9 = Managers.player:local_player()

			if var_10_9 then
				local var_10_10 = var_10_9.viewport_name
				local var_10_11 = ScriptWorld.viewport(arg_10_0._world, var_10_10, true)
				local var_10_12 = ScriptViewport.camera(var_10_11)
				local var_10_13 = Camera.get_data(var_10_12, "unit")
				local var_10_14 = var_10_8:current_position()

				var_10_4 = var_10_3:spawn_local_unit(var_10_2, var_10_14, nil, nil)

				World.link_unit(var_10_1, var_10_4, var_10_13, 0)
				Unit.set_local_position(var_10_4, 0, Vector3(0, 0, -0.5))
				Unit.set_local_rotation(var_10_4, 0, Quaternion.axis_angle(Vector3.up(), math.pi / 2))
				Unit.flow_event(var_10_4, "spawn_1p_effect")
			end
		end

		arg_10_0._vomit_unit = var_10_4
		arg_10_0._firing_time_deadline = arg_10_1 + BreedActions.chaos_troll.vomit.firing_time
	end
end

LiquidAreaDamageTemplates.nurgle_noxious_init = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._source_attacker_unit

	if HEALTH_ALIVE[var_11_0] then
		local var_11_1 = arg_11_0._world
		local var_11_2 = Unit.node(var_11_0, "j_spine")
		local var_11_3 = Unit.world_position(var_11_0, var_11_2)
		local var_11_4

		if arg_11_0._flow_dir then
			local var_11_5 = arg_11_0._flow_dir:unbox()
			local var_11_6 = Quaternion.look(var_11_5, Vector3.up())
		else
			local var_11_7 = Quaternion.identity()
		end

		local var_11_8 = "units/weapons/enemy/wpn_troll_vomit/wpn_troll_vomit"
		local var_11_9 = Managers.state.unit_spawner:spawn_local_unit(var_11_8, var_11_3, nil, nil)

		World.link_unit(var_11_1, var_11_9, var_11_0, var_11_2)
		Unit.set_local_scale(var_11_9, 0, Vector3(0.6, 0.6, 0.6))
		Unit.flow_event(var_11_9, "fade_in")

		arg_11_0._vomit_unit = var_11_9
		arg_11_0._firing_time_deadline = arg_11_1 + 1
	end
end

LiquidAreaDamageTemplates.bile_troll_vomit_update = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._vomit_unit
	local var_12_1 = arg_12_0._source_attacker_unit
	local var_12_2 = HEALTH_ALIVE[var_12_1]
	local var_12_3 = arg_12_0._firing_time_deadline

	if var_12_2 and var_12_0 ~= nil and arg_12_1 < var_12_3 then
		return true
	else
		if var_12_0 ~= nil then
			Unit.flow_event(var_12_0, "fade_out")

			arg_12_0._vomit_unit = nil
		end

		return false
	end
end

LiquidAreaDamageTemplates.vs_bile_troll_vomit_update = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._vomit_unit
	local var_13_1 = arg_13_0._source_attacker_unit
	local var_13_2 = HEALTH_ALIVE[var_13_1]
	local var_13_3 = arg_13_0._firing_time_deadline

	if var_13_2 and var_13_0 ~= nil and arg_13_1 < var_13_3 then
		return true
	else
		if var_13_0 ~= nil then
			if arg_13_0._fade_out_vomit then
				Unit.flow_event(var_13_0, "fade_out")
			end

			arg_13_0._vomit_unit = nil
		end

		return false
	end
end

LiquidAreaDamageTemplates.bile_troll_vomit_ground_base_condition = function (arg_14_0)
	return not ScriptUnit.has_extension(arg_14_0, "buff_system"):has_buff_type("troll_bile_face")
end

LiquidAreaDamageTemplates.stormfiend_warpfire_ground_base_condition = function (arg_15_0)
	return not ScriptUnit.has_extension(arg_15_0, "buff_system"):has_buff_type("stormfiend_warpfire_face")
end
