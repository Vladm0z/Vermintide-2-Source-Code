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
			-- function 1
			if not Unit.alive(arg_1_2) then
				local var_1_0 = BLACKBOARDS[arg_1_2]

				if not var_1_0 then
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
			-- function 2
			if not Unit.alive(arg_2_2) then
				local var_2_0 = BLACKBOARDS[arg_2_2]

				if not var_2_0 then
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
			-- function 3
			local tbl = {
				"nurgle_bathed_all",
				"nurgle_bathed_all_cata"
			}

			for i = 1, #tbl do
				local get_difficulty = Managers.state.difficulty:get_difficulty()
				local var_3_2 = tbl[i]

				if not QuestSettings.allowed_difficulties[var_3_2][get_difficulty] then
					local extension = ScriptUnit.extension(arg_3_0, "status_system")
					local num_times_bathed_in_nurgle_liquid = extension.num_times_bathed_in_nurgle_liquid

					num_times_bathed_in_nurgle_liquid = num_times_bathed_in_nurgle_liquid or 0
					extension.num_times_bathed_in_nurgle_liquid = num_times_bathed_in_nurgle_liquid + 1

					local flag = false

					for j = 0, #arg_3_1 do
						local var_3_6 = arg_3_1[j]

						if not Unit.alive(var_3_6) then
							local num_times_bathed_in_nurgle_liquid_2 = ScriptUnit.extension(var_3_6, "status_system").num_times_bathed_in_nurgle_liquid

							if not (not num_times_bathed_in_nurgle_liquid_2 and not (num_times_bathed_in_nurgle_liquid_2 >= QuestSettings.nurgle_bathed_all)) then
								Managers.player:statistics_db():increment_stat_and_sync_to_clients(tbl[i])

								flag = true

								break
							end
						end
					end

					if not flag then
						for k = 0, #arg_3_1 do
							local var_3_8 = arg_3_1[k]

							if not Unit.alive(var_3_8) then
								ScriptUnit.extension(var_3_8, "status_system").num_times_bathed_in_nurgle_liquid = nil
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
			-- function 4
			if not Unit.alive(arg_4_2) then
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
	-- function 5
	return 1
end

LiquidAreaDamageTemplates.default_spread = function (arg_6_0)
	-- function 6
	return math.max((1 - arg_6_0 / math.pi)^2 - 0.45, 0)
end

LiquidAreaDamageTemplates.forward_spread = function (arg_7_0)
	-- function 7
	return math.max(1 - arg_7_0 / (math.pi * 0.25), 0)
end

LiquidAreaDamageTemplates.flamethrower_spread = function (arg_8_0)
	-- function 8
	return math.max((1 - arg_8_0 / math.pi)^2, 0)
end

LiquidAreaDamageTemplates.bile_troll_vomit_init = function (self, arg_9_1)
	-- function 9
	local _source_attacker_unit = self._source_attacker_unit

	if not HEALTH_ALIVE[_source_attacker_unit] then
		local _world = self._world
		local node = Unit.node(_source_attacker_unit, "j_tongue_01")
		local world_position = Unit.world_position(_source_attacker_unit, node)
		local str = "units/weapons/enemy/wpn_troll_vomit/wpn_troll_vomit"
		local spawn_local_unit = Managers.state.unit_spawner:spawn_local_unit(str, world_position, nil, nil)

		World.link_unit(_world, spawn_local_unit, _source_attacker_unit, node)
		Unit.flow_event(spawn_local_unit, "fade_in")

		self._vomit_unit = spawn_local_unit
		self._firing_time_deadline = arg_9_1 + BreedActions.chaos_troll.vomit.firing_time
	end
end

LiquidAreaDamageTemplates.vs_bile_troll_vomit_init = function (self, arg_10_1)
	-- function 10
	local _source_attacker_unit = self._source_attacker_unit

	if not HEALTH_ALIVE[_source_attacker_unit] then
		local _world = self._world
		local str = "units/weapons/enemy/wpn_troll_vomit/wpn_troll_vomit"
		local unit_spawner = Managers.state.unit_spawner
		local var_10_4
		local unit_owner = Managers.player:unit_owner(_source_attacker_unit)

		if not unit_owner and not unit_owner.remote then
			local node = Unit.node(_source_attacker_unit, "j_tongue_01")
			local world_position = Unit.world_position(_source_attacker_unit, node)

			var_10_4 = unit_spawner:spawn_local_unit(str, world_position, nil, nil)

			World.link_unit(_world, var_10_4, _source_attacker_unit, node)
			Unit.flow_event(var_10_4, "fade_in")

			self._fade_out_vomit = true
		else
			local has_extension = ScriptUnit.has_extension(_source_attacker_unit, "first_person_system")
			local local_player = Managers.player:local_player()

			if not local_player then
				local viewport_name = local_player.viewport_name
				local viewport = ScriptWorld.viewport(self._world, viewport_name, true)
				local camera = ScriptViewport.camera(viewport)
				local get_data = Camera.get_data(camera, "unit")
				local current_position = has_extension:current_position()

				var_10_4 = unit_spawner:spawn_local_unit(str, current_position, nil, nil)

				World.link_unit(_world, var_10_4, get_data, 0)
				Unit.set_local_position(var_10_4, 0, Vector3(0, 0, -0.5))
				Unit.set_local_rotation(var_10_4, 0, Quaternion.axis_angle(Vector3.up(), math.pi / 2))
				Unit.flow_event(var_10_4, "spawn_1p_effect")
			end
		end

		self._vomit_unit = var_10_4
		self._firing_time_deadline = arg_10_1 + BreedActions.chaos_troll.vomit.firing_time
	end
end

LiquidAreaDamageTemplates.nurgle_noxious_init = function (self, arg_11_1)
	-- function 11
	local _source_attacker_unit = self._source_attacker_unit

	if not HEALTH_ALIVE[_source_attacker_unit] then
		local _world = self._world
		local node = Unit.node(_source_attacker_unit, "j_spine")
		local world_position = Unit.world_position(_source_attacker_unit, node)
		local var_11_4

		if not self._flow_dir then
			local unbox = self._flow_dir:unbox()
			local look = Quaternion.look(unbox, Vector3.up())
		else
			local identity = Quaternion.identity()
		end

		local str = "units/weapons/enemy/wpn_troll_vomit/wpn_troll_vomit"
		local spawn_local_unit = Managers.state.unit_spawner:spawn_local_unit(str, world_position, nil, nil)

		World.link_unit(_world, spawn_local_unit, _source_attacker_unit, node)
		Unit.set_local_scale(spawn_local_unit, 0, Vector3(0.6, 0.6, 0.6))
		Unit.flow_event(spawn_local_unit, "fade_in")

		self._vomit_unit = spawn_local_unit
		self._firing_time_deadline = arg_11_1 + 1
	end
end

LiquidAreaDamageTemplates.bile_troll_vomit_update = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _vomit_unit = self._vomit_unit
	local _source_attacker_unit = self._source_attacker_unit
	local var_12_2 = HEALTH_ALIVE[_source_attacker_unit]
	local _firing_time_deadline = self._firing_time_deadline

	if not (not var_12_2 and _vomit_unit == nil or not (arg_12_1 < _firing_time_deadline)) then
		return true
	else
		if _vomit_unit ~= nil then
			Unit.flow_event(_vomit_unit, "fade_out")

			self._vomit_unit = nil
		end

		return false
	end
end

LiquidAreaDamageTemplates.vs_bile_troll_vomit_update = function (self, arg_13_1, arg_13_2)
	-- function 13
	local _vomit_unit = self._vomit_unit
	local _source_attacker_unit = self._source_attacker_unit
	local var_13_2 = HEALTH_ALIVE[_source_attacker_unit]
	local _firing_time_deadline = self._firing_time_deadline

	if not (not var_13_2 and _vomit_unit == nil or not (arg_13_1 < _firing_time_deadline)) then
		return true
	else
		if _vomit_unit ~= nil then
			if not self._fade_out_vomit then
				Unit.flow_event(_vomit_unit, "fade_out")
			end

			self._vomit_unit = nil
		end

		return false
	end
end

LiquidAreaDamageTemplates.bile_troll_vomit_ground_base_condition = function (arg_14_0)
	-- function 14
	return not ScriptUnit.has_extension(arg_14_0, "buff_system"):has_buff_type("troll_bile_face")
end

LiquidAreaDamageTemplates.stormfiend_warpfire_ground_base_condition = function (arg_15_0)
	-- function 15
	return not ScriptUnit.has_extension(arg_15_0, "buff_system"):has_buff_type("stormfiend_warpfire_face")
end
