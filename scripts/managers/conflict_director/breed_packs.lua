-- chunkname: @scripts/managers/conflict_director/breed_packs.lua

InterestPointUnits = {
	{
		"units/hub_elements/interest_points/pack_spawning/ai_interest_point_1pack",
		spawn_weight = 1
	},
	{
		"units/hub_elements/interest_points/pack_spawning/ai_interest_point_2pack",
		spawn_weight = 2
	},
	{
		"units/hub_elements/interest_points/pack_spawning/ai_interest_point_3pack",
		spawn_weight = 4
	},
	{
		"units/hub_elements/interest_points/pack_spawning/ai_interest_point_4pack",
		"units/hub_elements/interest_points/pack_spawning/ai_interest_point_4pack_02",
		spawn_weight = 7
	},
	[7] = false,
	[5] = false,
	[6] = {
		"units/hub_elements/interest_points/pack_spawning/ai_interest_point_6pack_01",
		"units/hub_elements/interest_points/pack_spawning/ai_interest_point_6pack_02",
		spawn_weight = 5
	},
	[8] = {
		"units/hub_elements/interest_points/pack_spawning/ai_interest_point_8pack",
		spawn_weight = 2
	}
}

local var_0_0 = InterestPointUnits

InterestPointSettings = {
	max_rats_currently_moving_to_ip = 5,
	interest_point_spawn_chance = 0.5
}

local var_0_1 = 10
local var_0_2 = 5
local var_0_3 = 2
local var_0_4 = {
	Breeds.chaos_warrior,
	Breeds.chaos_warrior,
	Breeds.chaos_bulwark
}

BreedPacks = {
	standard = {
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						2,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						2,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			}
		},
		patrol_overrides = {
			patrol_chance = 1
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		roof_spawning_allowed = true
	},
	skaven_beastmen = {
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						10,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hard = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						12,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				harder = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						2,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hardest = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						3,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				cataclysm = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_2 = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						20,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_3 = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						7,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						20,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				versus_base = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						12,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						10,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hard = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						10,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				harder = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						2,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						10,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hardest = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						3,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				cataclysm = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						4,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_2 = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_3 = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				versus_base = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						10,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				}
			}
		},
		patrol_overrides = {
			patrol_chance = 1
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_bestigor
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor
			}
		},
		roof_spawning_allowed = true
	},
	chaos_beastmen = {
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						1,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						1,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						1,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						10,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hard = {
					{
						2,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						1,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						1,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						1,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						12,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				harder = {
					{
						2,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						2,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						2,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						2,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hardest = {
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						3,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						3,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						3,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				cataclysm = {
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						4,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						4,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						4,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						20,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_2 = {
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						4,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						4,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						4,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						20,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_3 = {
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						5,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						5,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						5,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						20,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				versus_base = {
					{
						2,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						1,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						1,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						1,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						12,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						0,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						0,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						0,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						0,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						10,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hard = {
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						1,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						1,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						1,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						10,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				harder = {
					{
						2,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						2,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						2,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						2,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hardest = {
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						3,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						3,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						3,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				cataclysm = {
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						5,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						5,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						5,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_2 = {
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						5,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						5,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						5,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_3 = {
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						5,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						5,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						5,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						15,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				versus_base = {
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						1,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						1,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						1,
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						10,
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				}
			}
		},
		patrol_overrides = {
			patrol_chance = 1
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_bestigor
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				var_0_4,
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				var_0_4,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				var_0_4,
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer
			}
		},
		roof_spawning_allowed = true
	},
	weave_no_elites = {
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						2,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						2,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			}
		},
		patrol_overrides = {
			patrol_chance = 1
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = 3.5,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 2,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = 2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 4,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = 3.5,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 4,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = 2.5,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		roof_spawning_allowed = true
	},
	weave = {
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						2,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						7,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						7,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						2,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						5,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						5,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			}
		},
		patrol_overrides = {
			patrol_chance = 1
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		roof_spawning_allowed = true
	},
	standard_no_elites = {
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						2,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						{
							6,
							8
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						{
							6,
							8
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						{
							6,
							8
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						{
							6,
							8
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						{
							6,
							8
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						{
							6,
							8
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						{
							6,
							8
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						{
							6,
							8
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						2,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						{
							4,
							5
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						{
							4,
							5
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						{
							4,
							5
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						{
							4,
							5
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			}
		},
		patrol_overrides = {
			patrol_chance = 1
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = 3.5,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 2,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = 2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 4,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = 3.5,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 4,
			members = {
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = 2.5,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = 2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		roof_spawning_allowed = true
	},
	skaven = {
		patrol_overrides = {
			patrol_chance = 1
		},
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hard = {
					{
						{
							2,
							3
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				harder = {
					{
						{
							5,
							6
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hardest = {
					{
						{
							12,
							14
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm = {
					{
						{
							12,
							14
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm_2 = {
					{
						{
							12,
							14
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm_3 = {
					{
						{
							12,
							14
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				versus_base = {
					{
						{
							2,
							3
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hard = {
					{
						{
							0,
							1
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				harder = {
					{
						{
							1,
							2
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hardest = {
					{
						{
							4,
							6
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm = {
					{
						{
							4,
							6
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm_2 = {
					{
						{
							4,
							6
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm_3 = {
					{
						{
							4,
							6
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				versus_base = {
					{
						{
							0,
							1
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				}
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_storm_vermin_commander
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		roof_spawning_allowed = true
	},
	shield_rats_no_elites = {
		patrol_overrides = {
			patrol_chance = 1
		},
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						3,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hard = {
					{
						10,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				harder = {
					{
						12,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hardest = {
					{
						20,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm = {
					{
						20,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm_2 = {
					{
						20,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm_3 = {
					{
						20,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				versus_base = {
					{
						10,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						2,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hard = {
					{
						4,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				harder = {
					{
						6,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hardest = {
					{
						10,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm = {
					{
						10,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm_2 = {
					{
						10,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm_3 = {
					{
						10,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				versus_base = {
					{
						4,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				}
			}
		},
		{
			spawn_weight = 1,
			members = {
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = 5,
			members = {
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = 5,
			members = {
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = 5,
			members = {
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = 5,
			members = {
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		roof_spawning_allowed = true
	},
	shield_rats = {
		patrol_overrides = {
			patrol_chance = 1
		},
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						{
							2,
							3
						},
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							0,
							1
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hard = {
					{
						{
							6,
							8
						},
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							1,
							2
						},
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				harder = {
					{
						{
							10,
							15
						},
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							2,
							3
						},
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							3,
							4
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hardest = {
					{
						100,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							4,
							5
						},
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							5,
							7
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm = {
					{
						100,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							4,
							5
						},
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							5,
							7
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm_2 = {
					{
						100,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							4,
							5
						},
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							5,
							7
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm_3 = {
					{
						100,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							4,
							5
						},
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							5,
							7
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				versus_base = {
					{
						{
							6,
							8
						},
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							1,
							2
						},
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						{
							0,
							1
						},
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hard = {
					{
						{
							0,
							4
						},
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							0,
							1
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				harder = {
					{
						{
							0,
							6
						},
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							0,
							1
						},
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							0,
							1
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hardest = {
					{
						100,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							1,
							2
						},
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							1,
							2
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm = {
					{
						100,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							1,
							2
						},
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							1,
							2
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm_2 = {
					{
						100,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							1,
							2
						},
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							1,
							2
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				cataclysm_3 = {
					{
						100,
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							1,
							2
						},
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							1,
							2
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				versus_base = {
					{
						{
							0,
							4
						},
						"skaven_clan_rat_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_with_shield",
						Breeds.skaven_clan_rat
					},
					{
						{
							0,
							1
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				}
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_storm_vermin_with_shield
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_with_shield,
				Breeds.skaven_storm_vermin_commander
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_with_shield,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_with_shield,
				Breeds.skaven_storm_vermin_with_shield,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_with_shield,
				Breeds.skaven_storm_vermin_with_shield,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_storm_vermin_with_shield,
				Breeds.skaven_storm_vermin_with_shield,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield,
				Breeds.skaven_clan_rat_with_shield
			}
		},
		roof_spawning_allowed = true
	},
	plague_monks = {
		patrol_overrides = {
			patrol_chance = 1
		},
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						2,
						"skaven_plague_monk",
						Breeds.skaven_clan_rat
					},
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hard = {
					{
						{
							4,
							6
						},
						"skaven_plague_monk",
						Breeds.skaven_clan_rat
					},
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				harder = {
					{
						{
							5,
							8
						},
						"skaven_plague_monk",
						Breeds.skaven_clan_rat
					},
					{
						3,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				versus_base = {
					{
						{
							4,
							6
						},
						"skaven_plague_monk",
						Breeds.skaven_clan_rat
					},
					{
						2,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						{
							0,
							1
						},
						"skaven_plague_monk",
						Breeds.skaven_clan_rat
					},
					{
						0,
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				hard = {
					{
						{
							0,
							3
						},
						"skaven_plague_monk",
						Breeds.skaven_clan_rat
					},
					{
						{
							0,
							1
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				harder = {
					{
						{
							2,
							3
						},
						"skaven_plague_monk",
						Breeds.skaven_clan_rat
					},
					{
						{
							0,
							1
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				},
				versus_base = {
					{
						{
							0,
							3
						},
						"skaven_plague_monk",
						Breeds.skaven_clan_rat
					},
					{
						{
							0,
							1
						},
						"skaven_storm_vermin_commander",
						Breeds.skaven_clan_rat
					}
				}
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_plague_monk,
				Breeds.skaven_plague_monk
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_plague_monk,
				Breeds.skaven_plague_monk,
				Breeds.skaven_plague_monk
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_plague_monk,
				Breeds.skaven_plague_monk,
				Breeds.skaven_plague_monk,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_plague_monk,
				Breeds.skaven_plague_monk,
				Breeds.skaven_plague_monk,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.skaven_plague_monk,
				Breeds.skaven_plague_monk,
				Breeds.skaven_plague_monk,
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat,
				Breeds.skaven_clan_rat
			}
		},
		roof_spawning_allowed = true
	},
	marauders_and_warriors = {
		patrol_overrides = {
			patrol_chance = 1
		},
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						1,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						1,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						0,
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						{
							1,
							2
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							5
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						{
							1,
							2
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							5
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						{
							2,
							3
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							15,
							20
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						{
							2,
							3
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							15,
							20
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						{
							2,
							3
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							15,
							20
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						{
							2,
							3
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							15,
							20
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						{
							1,
							2
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							5
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						0,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						0,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							0,
							2
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						0,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						0,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							0,
							5
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						0,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						0,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							5
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						{
							1,
							2
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							8,
							10
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						{
							1,
							2
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							8,
							10
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						{
							1,
							2
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							8,
							10
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						{
							1,
							2
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							8,
							10
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						0,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						0,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							0,
							5
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					}
				}
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				var_0_4
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				var_0_4,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				var_0_4,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				var_0_4,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				var_0_4,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				var_0_4,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				var_0_4,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				var_0_4,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				var_0_4,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				var_0_4,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		roof_spawning_allowed = false
	},
	marauders = {
		patrol_overrides = {
			patrol_chance = 1
		},
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						{
							0,
							1
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							0,
							1
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						{
							0,
							1
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							0,
							1
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						{
							1,
							2
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							4
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						{
							2,
							3
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							6,
							8
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						{
							2,
							3
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							6,
							8
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						{
							2,
							3
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							6,
							8
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						{
							2,
							3
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							6,
							8
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						{
							0,
							1
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							0,
							1
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						0,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						0,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						0,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						0,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						0,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						{
							0,
							1
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							0,
							1
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							3
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						{
							1,
							2
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						{
							1,
							2
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						{
							1,
							2
						},
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						0,
						"chaos_warrior",
						Breeds.chaos_marauder
					},
					{
						0,
						"chaos_bulwark",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				var_0_4,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				var_0_4,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				var_0_4,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				var_0_4,
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				var_0_4,
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_marauder,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		roof_spawning_allowed = false
	},
	marauders_shields = {
		patrol_overrides = {
			patrol_chance = 1
		},
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						{
							4,
							6
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						1,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						{
							6,
							8
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						{
							8,
							12
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							4
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						{
							15,
							20
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							7,
							9
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						{
							15,
							20
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							7,
							9
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						{
							15,
							20
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							7,
							9
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						{
							15,
							20
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							7,
							9
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						{
							6,
							8
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						{
							2,
							3
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						0,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						{
							3,
							5
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							0,
							1
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						{
							4,
							6
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						{
							8,
							12
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							4
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						{
							8,
							12
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							4
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						{
							8,
							12
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							4
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						{
							8,
							12
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							4
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						{
							3,
							5
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_marauder
					},
					{
						{
							0,
							1
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		roof_spawning_allowed = false
	},
	marauders_berzerkers = {
		patrol_overrides = {
			patrol_chance = 1
		},
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						{
							1,
							2
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							0,
							1
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						{
							4,
							5
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						{
							5,
							7
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						3,
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						{
							10,
							12
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						{
							10,
							12
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						{
							10,
							12
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						{
							10,
							12
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						{
							4,
							5
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						{
							0,
							1
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							0,
							1
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hard = {
					{
						{
							3,
							4
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				harder = {
					{
						{
							5,
							6
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				hardest = {
					{
						{
							6,
							7
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							4
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm = {
					{
						{
							6,
							7
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							4
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_2 = {
					{
						{
							6,
							7
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							4
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				cataclysm_3 = {
					{
						{
							6,
							7
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							4
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				},
				versus_base = {
					{
						{
							3,
							4
						},
						"chaos_berzerker",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					}
				}
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_berzerker
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_fanatic,
				Breeds.chaos_berzerker
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_berzerker,
				Breeds.chaos_berzerker,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_berzerker,
				Breeds.chaos_berzerker,
				Breeds.chaos_berzerker,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_berzerker,
				Breeds.chaos_berzerker,
				Breeds.chaos_berzerker,
				Breeds.chaos_raider,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_berzerker,
				Breeds.chaos_berzerker,
				Breeds.chaos_berzerker,
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		roof_spawning_allowed = false
	},
	marauders_elites = {
		patrol_overrides = {
			patrol_chance = 1
		},
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						{
							1,
							2
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							0,
							1
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							1,
							2
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				hard = {
					{
						{
							3,
							4
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							0,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							5
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				harder = {
					{
						{
							5,
							6
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							1,
							3
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							4,
							6
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				hardest = {
					{
						{
							7,
							8
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							10,
							12
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				cataclysm = {
					{
						{
							7,
							8
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							10,
							12
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				cataclysm_2 = {
					{
						{
							7,
							8
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							10,
							12
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				cataclysm_3 = {
					{
						{
							7,
							8
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							4,
							5
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							10,
							12
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				versus_base = {
					{
						{
							3,
							4
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							0,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							5
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						{
							0,
							1
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							0,
							1
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							0,
							1
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				hard = {
					{
						{
							2,
							3
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							0,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				harder = {
					{
						{
							3,
							4
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							1,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							3,
							4
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				hardest = {
					{
						{
							4,
							5
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							2,
							3
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							6,
							8
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				cataclysm = {
					{
						{
							4,
							5
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							2,
							3
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							6,
							8
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				cataclysm_2 = {
					{
						{
							4,
							5
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							2,
							3
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							6,
							8
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				cataclysm_3 = {
					{
						{
							4,
							5
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							2,
							3
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							6,
							8
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				},
				versus_base = {
					{
						{
							2,
							3
						},
						"chaos_berzerker",
						Breeds.chaos_fanatic
					},
					{
						{
							0,
							2
						},
						"chaos_raider",
						Breeds.chaos_marauder
					},
					{
						{
							2,
							3
						},
						"chaos_marauder_with_shield",
						Breeds.chaos_fanatic
					}
				}
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_raider
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_berzerker,
				Breeds.chaos_raider
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_berzerker,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_3,
			members = {
				Breeds.chaos_berzerker,
				Breeds.chaos_berzerker
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_berzerker,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_raider
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_berzerker,
				Breeds.chaos_berzerker,
				Breeds.chaos_berzerker,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_berzerker,
				Breeds.chaos_berzerker,
				Breeds.chaos_raider,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_fanatic
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.chaos_berzerker,
				Breeds.chaos_berzerker,
				Breeds.chaos_raider,
				Breeds.chaos_raider,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_marauder_with_shield,
				Breeds.chaos_fanatic,
				Breeds.chaos_fanatic
			}
		},
		roof_spawning_allowed = false
	},
	beastmen = {
		patrol_overrides = {
			patrol_chance = 1
		},
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						{
							1,
							1
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hard = {
					{
						{
							1,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							8,
							10
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				harder = {
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							10,
							12
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hardest = {
					{
						{
							2,
							4
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					}
				},
				cataclysm = {
					{
						{
							4,
							5
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					}
				},
				cataclysm_2 = {
					{
						{
							4,
							5
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					}
				},
				cataclysm_3 = {
					{
						{
							4,
							5
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					}
				},
				versus_base = {
					{
						{
							1,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							8,
							10
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						{
							0,
							1
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							2,
							3
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							0,
							0
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hard = {
					{
						{
							0,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							2,
							3
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							3,
							5
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				harder = {
					{
						{
							1,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							3,
							4
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							3,
							5
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hardest = {
					{
						{
							1,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				cataclysm = {
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_2 = {
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_3 = {
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				versus_base = {
					{
						{
							0,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							2,
							3
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							3,
							5
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				}
			}
		},
		{
			spawn_weight = 1,
			members = {
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = var_0_2,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = var_0_1,
			members = {
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer
			}
		},
		roof_spawning_allowed = true
	},
	beastmen_elites = {
		patrol_overrides = {
			patrol_chance = 1
		},
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						{
							1,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hard = {
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							8,
							10
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				harder = {
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							10,
							12
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hardest = {
					{
						{
							2,
							4
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					}
				},
				cataclysm = {
					{
						{
							4,
							5
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					}
				},
				cataclysm_2 = {
					{
						{
							4,
							5
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					}
				},
				cataclysm_3 = {
					{
						{
							4,
							5
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					}
				},
				versus_base = {
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							8,
							10
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						{
							0,
							1
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							2,
							3
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							0,
							0
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hard = {
					{
						{
							0,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							2,
							3
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							3,
							5
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				harder = {
					{
						{
							1,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							3,
							4
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							3,
							5
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				},
				hardest = {
					{
						{
							1,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				cataclysm = {
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_2 = {
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_3 = {
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				versus_base = {
					{
						{
							0,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							2,
							3
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							3,
							5
						},
						"beastmen_ungor_archer",
						Breeds.beastmen_ungor
					}
				}
			}
		},
		{
			spawn_weight = 1,
			members = {
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor
			}
		},
		{
			spawn_weight = 5,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor
			}
		},
		{
			spawn_weight = 5,
			members = {
				Breeds.beastmen_ungor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor
			}
		},
		{
			spawn_weight = 5,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor
			}
		},
		{
			spawn_weight = 5,
			members = {
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor
			}
		},
		roof_spawning_allowed = true
	},
	beastmen_light = {
		patrol_overrides = {
			patrol_chance = 1
		},
		zone_checks = {
			clamp_breeds_hi = {
				normal = {
					{
						{
							2,
							3
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							0,
							1
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							2,
							3
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				hard = {
					{
						{
							3,
							4
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							0,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							2,
							5
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				harder = {
					{
						{
							5,
							6
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							1,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							4,
							6
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				hardest = {
					{
						{
							7,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							10,
							12
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				cataclysm = {
					{
						{
							7,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							4,
							5
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							10,
							12
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_2 = {
					{
						{
							7,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							4,
							5
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							10,
							12
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_3 = {
					{
						{
							7,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							4,
							5
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							10,
							12
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				versus_base = {
					{
						{
							3,
							4
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							0,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							2,
							5
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				}
			},
			clamp_breeds_low = {
				normal = {
					{
						{
							1,
							2
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							0,
							1
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							2,
							3
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				hard = {
					{
						{
							2,
							3
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							0,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							2,
							3
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				harder = {
					{
						{
							3,
							4
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							1,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							3,
							4
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				hardest = {
					{
						{
							4,
							5
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							1,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				cataclysm = {
					{
						{
							4,
							5
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_2 = {
					{
						{
							4,
							5
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				cataclysm_3 = {
					{
						{
							4,
							5
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							2,
							3
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							6,
							8
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				},
				versus_base = {
					{
						{
							2,
							3
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					},
					{
						{
							0,
							2
						},
						"beastmen_bestigor",
						Breeds.beastmen_gor
					},
					{
						{
							2,
							3
						},
						"beastmen_gor",
						Breeds.beastmen_ungor
					}
				}
			}
		},
		{
			spawn_weight = 1,
			members = {
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.beastmen_ungor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = 5,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = 5,
			members = {
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer
			}
		},
		{
			spawn_weight = 5,
			members = {
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor,
				Breeds.beastmen_bestigor
			}
		},
		{
			spawn_weight = 5,
			members = {
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_ungor,
				Breeds.beastmen_bestigor,
				Breeds.beastmen_gor,
				Breeds.beastmen_gor
			}
		},
		{
			spawn_weight = 10,
			members = {
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer,
				Breeds.beastmen_ungor_archer
			}
		},
		roof_spawning_allowed = true
	},
	code_test = {
		zone_checks = {
			clamp_breeds_hi = {
				hi = "HI ZONE",
				normal = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_poison_wind_globadier
					}
				},
				versus_base = {}
			},
			clamp_breeds_low = {
				hi = "LOW ZONE",
				normal = {
					{
						1,
						"skaven_storm_vermin_commander",
						Breeds.skaven_ratling_gunner
					}
				},
				versus_base = {}
			}
		},
		{
			spawn_weight = 1,
			members = {
				Breeds.skaven_storm_vermin_commander
			}
		},
		{
			spawn_weight = 100,
			members = {
				Breeds.skaven_storm_vermin_commander,
				Breeds.skaven_storm_vermin_commander
			}
		},
		{
			spawn_weight = 1,
			members = {
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat
			}
		},
		{
			spawn_weight = 1,
			members = {
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat
			}
		},
		{
			spawn_weight = 1,
			members = {
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat,
				Breeds.skaven_storm_vermin_commander
			}
		},
		{
			spawn_weight = 1,
			members = {
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat,
				Breeds.skaven_loot_rat
			}
		},
		roof_spawning_allowed = true
	}
}
BackupBreedPack = {
	pack_type = "backup",
	spawn_weight = 0,
	members = {
		{
			breed = Breeds.skaven_clan_ratskaven_clan_rat,
			animation = {
				"idle",
				"idle_passive_sit"
			}
		}
	}
}

local function var_0_5(arg_1_0, arg_1_1)
	local var_1_0 = #arg_1_0

	for iter_1_0 = 1, var_1_0 do
		local var_1_1 = arg_1_0[iter_1_0]
		local var_1_2 = #var_1_1.members

		fassert(var_0_0[var_1_2], "The %d pack in BreedPacks[%s] is of size %d. There are no InterestPointUnits matching this size.", iter_1_0, arg_1_1, var_1_2)

		var_1_1.members_n = var_1_2
	end

	return var_1_0
end

local function var_0_6(arg_2_0, arg_2_1)
	local var_2_0 = var_0_5(arg_2_0, arg_2_1)
	local var_2_1 = {}
	local var_2_2 = {}

	for iter_2_0 = 1, var_2_0 do
		local var_2_3 = arg_2_0[iter_2_0]
		local var_2_4 = var_2_3.members_n

		if not var_2_2[var_2_4] then
			var_2_2[var_2_4] = {
				packs = {},
				weights = {}
			}
		end

		local var_2_5 = var_2_2[var_2_4]
		local var_2_6 = var_2_5.packs

		var_2_6[#var_2_6 + 1] = var_2_3
		var_2_5.weights[#var_2_5.weights + 1] = var_2_3.spawn_weight
	end

	for iter_2_1, iter_2_2 in pairs(var_2_2) do
		local var_2_7, var_2_8 = LoadedDice.create(iter_2_2.weights, false)

		var_2_1[iter_2_1] = {
			packs = iter_2_2.packs,
			prob = var_2_7,
			alias = var_2_8
		}
	end

	return var_2_1
end

BreedPacksBySize = {}

for iter_0_0, iter_0_1 in pairs(BreedPacks) do
	BreedPacksBySize[iter_0_0] = var_0_6(iter_0_1, iter_0_0)
end

InterestPointUnitsLookup = InterestPointUnitsLookup or false
SizeOfInterestPoint = SizeOfInterestPoint or {}
InterestPointPickListIndexLookup = InterestPointPickListIndexLookup or {}
InterestPointPickList = InterestPointPickList or false

if #InterestPointPickListIndexLookup == 0 then
	local var_0_7 = InterestPointPickList or {}
	local var_0_8 = 0

	for iter_0_2, iter_0_3 in ipairs(var_0_0) do
		if iter_0_3 then
			for iter_0_4 = 1, iter_0_3.spawn_weight do
				var_0_8 = var_0_8 + 1
				var_0_7[var_0_8] = iter_0_2
			end

			for iter_0_5 = 1, #iter_0_3 do
				local var_0_9 = iter_0_3[iter_0_5]

				SizeOfInterestPoint[var_0_9] = iter_0_2
			end

			InterestPointPickListIndexLookup[iter_0_2] = var_0_8

			for iter_0_6, iter_0_7 in pairs(BreedPacks) do
				fassert(BreedPacksBySize[iter_0_6][iter_0_2], "BreedPacks[%s] is missing a pack of size %d. It must be defined, since InterestPointUnits expects there to be a pack like that.", iter_0_6, iter_0_2)
			end
		else
			InterestPointPickListIndexLookup[iter_0_2] = InterestPointPickListIndexLookup[#InterestPointPickListIndexLookup]
		end
	end

	InterestPointPickList = var_0_7
end

for iter_0_8, iter_0_9 in pairs(BreedPacks) do
	local var_0_10 = iter_0_9.zone_checks
	local var_0_11 = var_0_10.clamp_breeds_hi

	fassert(not var_0_11 or var_0_11.versus_base, "[BreedPacks] '%s' is missing a 'clamp_breeds_hi' setting for versus and won't be able to limit amount of breeds.", iter_0_8)

	local var_0_12 = var_0_10.clamp_breeds_low

	fassert(not var_0_12 or var_0_12.versus_base, "[BreedPacks] '%s' is missing a 'clamp_breeds_low' setting for versus and won't be able to limit amount of breeds.", iter_0_8)
end

BenchmarkSettings.demo_mode_overrides()
