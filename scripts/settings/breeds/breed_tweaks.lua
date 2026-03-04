-- chunkname: @scripts/settings/breeds/breed_tweaks.lua

require("foundation/scripts/util/math")

BreedTweaks = {}

local var_0_0 = {
	1,
	1,
	1.5,
	2.2,
	3.3,
	4.5,
	6,
	7.5,
	1
}
local var_0_1 = {
	1,
	0.85,
	1.4,
	2.25,
	2.25,
	2.25,
	3.5,
	3.5,
	0.85
}
local var_0_2 = {
	1,
	1,
	1.7,
	2.75,
	2.75,
	2.75,
	3.5,
	3.5,
	1
}
local var_0_3 = {
	1,
	1,
	1.7,
	2.5,
	2.5,
	2.5,
	3.25,
	4.5,
	1
}
local var_0_4 = {
	1,
	1,
	1.5,
	2.2,
	3.3,
	5.4,
	6.4,
	7.4,
	1.5
}
local var_0_5 = {
	1,
	1,
	1.7,
	2.75,
	2.75,
	2.75,
	3.5,
	4,
	1
}
local var_0_6 = {
	1,
	1,
	1.7,
	2.5,
	2.5,
	2.5,
	3.25,
	4.5,
	1
}
local var_0_7 = {
	1,
	1,
	1.5,
	2.2,
	3.3,
	4.2,
	5.1,
	6,
	1
}
local var_0_8 = {
	1,
	1,
	1.5,
	2.25,
	2.25,
	2.25,
	3,
	3,
	1
}
local var_0_9 = {
	1,
	1,
	1.5,
	2,
	2,
	2,
	2.75,
	3,
	1
}
local var_0_10 = {
	1,
	1,
	1.5,
	2,
	3,
	5,
	6.5,
	8,
	1
}

local function var_0_11(arg_1_0)
	arg_1_0 = math.clamp(arg_1_0, 0, 8191.5)

	local var_1_0 = arg_1_0 % 1
	local var_1_1 = math.round(var_1_0 * 4) * 0.25

	return math.floor(arg_1_0) + var_1_1
end

local function var_0_12(arg_2_0, arg_2_1)
	local var_2_0 = {}

	for iter_2_0 = 1, 9 do
		local var_2_1 = arg_2_0 * arg_2_1[iter_2_0]

		var_2_0[iter_2_0] = var_0_11(var_2_1)
	end

	return var_2_0
end

local function var_0_13(arg_3_0, arg_3_1)
	local var_3_0 = {}

	for iter_3_0 = 1, 9 do
		local var_3_1 = arg_3_0 * arg_3_1[iter_3_0]
		local var_3_2 = var_3_1 % 1
		local var_3_3 = math.round(var_3_2 * 4) * 0.25

		var_3_0[iter_3_0] = math.floor(var_3_1) + var_3_3
	end

	return var_3_0
end

BreedTweaks.max_health = {
	slave_rat = var_0_12(4, var_0_7),
	fanatic = var_0_12(8, var_0_7),
	ungor = var_0_12(6, var_0_7),
	clan_rat = var_0_12(8, var_0_0),
	clan_rat_with_shield = var_0_12(8, var_0_0),
	marauder = var_0_12(16, var_0_0),
	gor = var_0_12(12, var_0_0),
	berzerker = var_0_12(18, var_0_4),
	plague_monk = var_0_12(18, var_0_4),
	stormvermin = var_0_12(16, var_0_4),
	stormvermin_with_shield = var_0_12(16, var_0_4),
	raider = var_0_12(30, var_0_4),
	bestigor = var_0_12(20, var_0_4),
	chaos_warrior = var_0_12(46, var_0_4),
	chaos_bulwark = var_0_12(56, var_0_4),
	chaos_spawn = var_0_12(800, var_0_10),
	chaos_troll = var_0_12(600, var_0_10),
	chaos_troll_chief = var_0_12(1200, var_0_10),
	rat_ogre = var_0_12(800, var_0_10),
	stormfiend = var_0_12(600, var_0_10),
	corruptor_sorcerer = var_0_12(20, var_0_0),
	vortex_sorcerer = var_0_12(20, var_0_0),
	warpfire_thrower = var_0_12(12, var_0_0),
	globadier = var_0_12(20, var_0_0),
	gutter_runner = var_0_12(12, var_0_0),
	pack_master = var_0_12(25, var_0_0),
	ratling_gunner = var_0_12(12, var_0_0),
	standard_bearer = var_0_12(20, var_0_0),
	stormvermin_warlord = var_0_12(500, var_0_10),
	exalted_champion = var_0_12(700, var_0_10),
	exalted_sorcerer = var_0_12(1000, var_0_10),
	norsca_champion = var_0_12(600, var_0_10),
	grey_seer = var_0_12(500, var_0_10),
	stormfiend_boss = var_0_12(600, var_0_10)
}
BreedTweaks.diff_stagger_resist = {
	slave_rat = var_0_13(1, var_0_1),
	fanatic = var_0_13(1.4, var_0_1),
	ungor = var_0_13(1.3, var_0_1),
	clan_rat = var_0_13(2.1, var_0_1),
	gor = var_0_13(2.4, var_0_1),
	marauder = var_0_13(2.65, var_0_1),
	stormvermin = var_0_13(2.25, var_0_5),
	bestigor = var_0_13(3.25, var_0_5),
	raider = var_0_13(3, var_0_5),
	warrior = var_0_13(4.8, var_0_5),
	berzerker = var_0_13(2.7, var_0_5),
	plague_monk = var_0_13(3, var_0_5),
	packmaster = var_0_13(4, var_0_5),
	ratling_gunner = var_0_13(2.5, var_0_5),
	sorcerer = var_0_13(2.7, var_0_5)
}
BreedTweaks.stagger_reduction = {
	marauder = var_0_13(0.2, var_0_1),
	gor = var_0_13(0.1, var_0_1),
	stormvermin = var_0_13(1, var_0_5),
	raider = var_0_13(0.9, var_0_5),
	warrior = var_0_13(1.8, var_0_5),
	bestigor = var_0_13(1, var_0_5),
	berzerker = var_0_13(0.75, var_0_5),
	plague_monk = var_0_13(1.35, var_0_5),
	sorcerer = var_0_13(2, var_0_5),
	packmaster = var_0_13(2, var_0_5),
	ratling_gunner = var_0_13(1, var_0_5),
	stormvermin_warlord = var_0_13(1.35, var_0_5)
}
BreedTweaks.stagger_duration = {
	slave_rat = {
		1,
		1.5,
		2,
		1.5,
		2,
		5,
		1,
		1
	},
	fanatic = {
		1,
		1.75,
		2.5,
		0.75,
		1.5,
		4,
		1,
		1
	},
	ungor = {
		1,
		1.5,
		2,
		1,
		1.25,
		3,
		1,
		1
	},
	clan_rat = {
		1,
		1.5,
		2,
		1.5,
		2,
		5,
		1,
		1
	},
	marauder = {
		1,
		1.75,
		2.5,
		1,
		1.5,
		4,
		1,
		1
	},
	gor = {
		1,
		1.75,
		2.5,
		1,
		1.25,
		4,
		1,
		1
	},
	stormvermin = {
		1,
		1.25,
		1.75,
		1,
		1.25,
		3,
		1,
		1
	},
	raider = {
		0.75,
		1.25,
		1.75,
		1,
		1,
		1,
		1,
		1
	},
	bestigor = {
		0.75,
		1.25,
		1.75,
		1,
		1.25,
		3,
		1,
		1
	},
	berzerker = {
		0.25,
		1.75,
		3.5,
		0.5,
		0.5,
		4,
		0.25,
		0.25
	},
	plague_monk = {
		0.25,
		0.5,
		0.75,
		0.25,
		0.25,
		2,
		0.25,
		0.25
	},
	sorcerer = {
		0.5,
		1,
		1,
		1,
		1,
		1,
		1,
		1
	},
	warrior = {
		0.1,
		0.3,
		0.75,
		0.1,
		0.1,
		1,
		0.1,
		1
	}
}
BreedTweaks.stagger_duration_difficulty_mod = {
	default = {
		hardest = 1.15,
		normal = 1.5,
		hard = 1.35,
		harder = 1.25,
		cataclysm = 1,
		easy = 1,
		versus_base = 1.5,
		cataclysm_3 = 1,
		cataclysm_2 = 1
	},
	fast = {
		hardest = 1,
		normal = 1,
		hard = 1,
		harder = 1,
		cataclysm = 0.75,
		easy = 1,
		versus_base = 1,
		cataclysm_3 = 0.75,
		cataclysm_2 = 0.75
	}
}
BreedTweaks.hit_mass_counts = {
	slave_rat = var_0_13(0.8, var_0_3),
	fanatic = var_0_13(1.25, var_0_3),
	ungor = var_0_13(1, var_0_3),
	clan_rat = var_0_13(1.5, var_0_3),
	clan_rat_shield_block = var_0_13(1.5, var_0_3),
	marauder = var_0_13(3, var_0_3),
	gor = var_0_13(2.75, var_0_3),
	stormvermin = var_0_13(5, var_0_3),
	stormvermin_shield_block = var_0_13(8, var_0_3),
	bestigor = var_0_13(8, var_0_3),
	raider = var_0_13(5, var_0_3),
	berzerker = var_0_13(3, var_0_3),
	marauder_shield_block = var_0_13(5, var_0_3),
	plague_monk = var_0_13(2.5, var_0_3),
	sorcerer = var_0_13(8, var_0_3)
}
BreedTweaks.difficulty_damage = {
	beastmen_roamer_attack = {
		hardest = 22,
		normal = 7,
		hard = 10,
		harder = 16,
		cataclysm = 27,
		easy = 5,
		versus_base = 7,
		cataclysm_3 = 27,
		cataclysm_2 = 27
	},
	beastmen_headbutt_attack = {
		hardest = 16,
		normal = 4,
		hard = 8,
		harder = 12,
		cataclysm = 20,
		easy = 2.5,
		versus_base = 4,
		cataclysm_3 = 20,
		cataclysm_2 = 20
	},
	skirmish_roamer_attack = {
		hardest = 10,
		normal = 3,
		hard = 5,
		harder = 8,
		cataclysm = 15,
		easy = 2.5,
		versus_base = 3,
		cataclysm_3 = 15,
		cataclysm_2 = 15
	},
	chaos_roamer_attack = {
		hardest = 20,
		normal = 5,
		hard = 7,
		harder = 12,
		cataclysm = 25,
		easy = 4,
		versus_base = 5,
		cataclysm_3 = 25,
		cataclysm_2 = 25
	},
	chaos_horde_attack = {
		hardest = 16,
		normal = 4,
		hard = 8,
		harder = 12,
		cataclysm = 20,
		easy = 2.5,
		versus_base = 4,
		cataclysm_3 = 20,
		cataclysm_2 = 20
	},
	skaven_roamer_attack = {
		hardest = 15,
		normal = 3,
		hard = 6,
		harder = 10,
		cataclysm = 20,
		easy = 3,
		versus_base = 3,
		cataclysm_3 = 20,
		cataclysm_2 = 20
	},
	skaven_horde_attack = {
		hardest = 12,
		normal = 2.5,
		hard = 5,
		harder = 8,
		cataclysm = 16,
		easy = 2,
		versus_base = 2.5,
		cataclysm_3 = 16,
		cataclysm_2 = 16
	},
	elite_attack = {
		hardest = 50,
		normal = 15,
		hard = 20,
		harder = 30,
		cataclysm = 60,
		easy = 15,
		versus_base = 15,
		cataclysm_3 = 60,
		cataclysm_2 = 60
	},
	elite_attack_heavy = {
		hardest = 100,
		normal = 30,
		hard = 40,
		harder = 50,
		cataclysm = 150,
		easy = 20,
		versus_base = 30,
		cataclysm_3 = 150,
		cataclysm_2 = 150
	},
	elite_attack_shielded = {
		hardest = 40,
		normal = 15,
		hard = 20,
		harder = 25,
		cataclysm = 50,
		easy = 10,
		versus_base = 20,
		cataclysm_3 = 50,
		cataclysm_2 = 50
	},
	elite_attack_shielded_frenzy = {
		hardest = 14,
		normal = 4,
		hard = 8,
		harder = 10,
		cataclysm = 14,
		easy = 2,
		versus_base = 4,
		cataclysm_3 = 14,
		cataclysm_2 = 14
	},
	elite_attack_quick = {
		hardest = 20,
		normal = 12,
		hard = 14,
		harder = 16,
		cataclysm = 30,
		easy = 10,
		versus_base = 12,
		cataclysm_3 = 30,
		cataclysm_2 = 30
	},
	elite_shield_push = {
		hardest = 5,
		normal = 0,
		hard = 5,
		harder = 5,
		cataclysm = 10,
		easy = 0,
		versus_base = 0,
		cataclysm_3 = 10,
		cataclysm_2 = 10
	},
	berzerker_frenzy_attack = {
		hardest = 20,
		normal = 2,
		hard = 7,
		harder = 12,
		cataclysm = 25,
		easy = 2,
		versus_base = 2,
		cataclysm_3 = 25,
		cataclysm_2 = 25
	},
	boss_slam_attack = {
		hardest = 60,
		normal = 15,
		hard = 25,
		harder = 40,
		cataclysm = 60,
		easy = 15,
		versus_base = 15,
		cataclysm_3 = 60,
		cataclysm_2 = 60
	},
	boss_slam_attack_blocked = {
		hardest = 10,
		normal = 2,
		hard = 7,
		harder = 9,
		cataclysm = 10,
		easy = 2,
		versus_base = 2,
		cataclysm_3 = 10,
		cataclysm_2 = 10
	},
	boss_combo_attack = {
		hardest = 40,
		normal = 10,
		hard = 15,
		harder = 25,
		cataclysm = 50,
		easy = 10,
		versus_base = 10,
		cataclysm_3 = 50,
		cataclysm_2 = 50
	}
}
BreedTweaks.bloodlust_health = {
	beastmen_horde = 1.5,
	chaos_roamer = 3,
	chaos_horde = 1.5,
	chaos_warrior = 30,
	beastmen_elite = 15,
	chaos_elite = 15,
	skaven_elite = 8,
	skaven_roamer = 2,
	skaven_special = 8,
	skaven_horde = 1,
	chaos_special = 10,
	beastmen_roamer = 3,
	monster = 50,
	chaos_bulwark = 35
}
BreedTweaks.blocked_duration = {
	skaven_roamer = {
		harder = {
			1,
			1.2
		},
		hardest = {
			0.75,
			1
		},
		cataclysm = {
			0.5,
			0.75
		},
		cataclysm_2 = {
			0.5,
			0.75
		},
		cataclysm_3 = {
			0.5,
			0.75
		},
		versus_base = {
			1,
			1.2
		}
	},
	skaven_horde = {
		harder = {
			1,
			1.2
		},
		hardest = {
			0.75,
			1
		},
		cataclysm = {
			0.5,
			0.75
		},
		cataclysm_2 = {
			0.5,
			0.75
		},
		cataclysm_3 = {
			0.5,
			0.75
		},
		versus_base = {
			1,
			1.2
		}
	},
	skaven_elite = {
		harder = {
			1,
			1.2
		},
		hardest = {
			0.75,
			1
		},
		cataclysm = {
			0.5,
			0.75
		},
		cataclysm_2 = {
			0.5,
			0.75
		},
		cataclysm_3 = {
			0.5,
			0.75
		},
		versus_base = {
			1,
			1.2
		}
	},
	chaos_roamer = {
		harder = {
			1,
			1.2
		},
		hardest = {
			0.75,
			1
		},
		cataclysm = {
			0.5,
			0.75
		},
		cataclysm_2 = {
			0.5,
			0.75
		},
		cataclysm_3 = {
			0.5,
			0.75
		},
		versus_base = {
			1,
			1.2
		}
	},
	chaos_horde = {
		harder = {
			1,
			1.2
		},
		hardest = {
			0.75,
			1
		},
		cataclysm = {
			0.5,
			0.75
		},
		cataclysm_2 = {
			0.5,
			0.75
		},
		cataclysm_3 = {
			0.5,
			0.75
		},
		versus_base = {
			1,
			1.2
		}
	},
	chaos_elite = {
		harder = {
			1,
			1.2
		},
		hardest = {
			0.75,
			1
		},
		cataclysm = {
			0.5,
			0.75
		},
		cataclysm_2 = {
			0.5,
			0.75
		},
		cataclysm_3 = {
			0.5,
			0.75
		},
		versus_base = {
			1,
			1.2
		}
	},
	beastmen_roamer = {
		harder = {
			1,
			1.2
		},
		hardest = {
			0.75,
			1
		},
		cataclysm = {
			0.5,
			0.75
		},
		cataclysm_2 = {
			0.5,
			0.75
		},
		cataclysm_3 = {
			0.5,
			0.75
		},
		versus_base = {
			1,
			1.2
		}
	},
	beastmen_elite = {
		harder = {
			1,
			1.2
		},
		hardest = {
			0.75,
			1
		},
		cataclysm = {
			0.5,
			0.75
		},
		cataclysm_2 = {
			0.5,
			0.75
		},
		cataclysm_3 = {
			0.5,
			0.75
		},
		versus_base = {
			1,
			1.2
		}
	}
}
BreedTweaks.attack_finished_duration = {
	skaven_roamer = {
		harder = {
			1.6,
			1.8
		},
		hardest = {
			1.4,
			1.6
		},
		cataclysm = {
			1.2,
			1.4
		},
		cataclysm_2 = {
			1,
			1.2
		},
		cataclysm_3 = {
			1,
			1.2
		},
		versus_base = {
			1.6,
			1.8
		}
	},
	skaven_horde = {
		harder = {
			1.6,
			1.8
		},
		hardest = {
			1.4,
			1.6
		},
		cataclysm = {
			1.2,
			1.4
		},
		cataclysm_2 = {
			1,
			1.2
		},
		cataclysm_3 = {
			1,
			1.2
		},
		versus_base = {
			1.6,
			1.8
		}
	},
	skaven_elite = {
		harder = {
			1.6,
			1.8
		},
		hardest = {
			1.4,
			1.6
		},
		cataclysm = {
			1.2,
			1.4
		},
		cataclysm_2 = {
			1,
			1.2
		},
		cataclysm_3 = {
			1,
			1.2
		},
		versus_base = {
			1.6,
			1.8
		}
	},
	chaos_roamer = {
		harder = {
			1.7,
			2
		},
		hardest = {
			1.5,
			1.8
		},
		cataclysm = {
			1.1,
			1.3
		},
		cataclysm_2 = {
			1,
			1.2
		},
		cataclysm_3 = {
			1,
			1.2
		},
		versus_base = {
			1.7,
			2
		}
	},
	chaos_horde = {
		harder = {
			1.7,
			2
		},
		hardest = {
			1.5,
			1.8
		},
		cataclysm = {
			1.1,
			1.3
		},
		cataclysm_2 = {
			1,
			1.2
		},
		cataclysm_3 = {
			1,
			1.2
		},
		versus_base = {
			1.7,
			2
		}
	},
	beastmen_horde = {
		harder = {
			1.7,
			2
		},
		hardest = {
			1.5,
			1.8
		},
		cataclysm = {
			1.5,
			1.8
		},
		cataclysm_2 = {
			1.5,
			1.8
		},
		cataclysm_3 = {
			1.5,
			1.8
		},
		versus_base = {
			1.7,
			2
		}
	},
	beastmen_roamer = {
		harder = {
			1.4,
			1.6
		},
		hardest = {
			1.3,
			1.4
		},
		cataclysm = {
			1.2,
			1.3
		},
		cataclysm_2 = {
			1,
			1.2
		},
		cataclysm_3 = {
			1,
			1.2
		},
		versus_base = {
			1.4,
			1.6
		}
	},
	beastmen_elite = {
		harder = {
			1.7,
			2
		},
		hardest = {
			1.5,
			1.8
		},
		cataclysm = {
			1.5,
			1.8
		},
		cataclysm_2 = {
			1.5,
			1.8
		},
		cataclysm_3 = {
			1.5,
			1.8
		},
		versus_base = {
			1.7,
			2
		}
	}
}
BreedTweaks.dodge_windows = {
	normal_attack = {
		harder = 0.25,
		hardest = 0.25,
		versus_base = 0.25,
		cataclysm = 0.25,
		cataclysm_3 = 0.25,
		cataclysm_2 = 0.25
	},
	running_attack = {
		harder = 0.75,
		hardest = 0.75,
		versus_base = 0.75,
		cataclysm = 0.75,
		cataclysm_3 = 0.75,
		cataclysm_2 = 0.75
	},
	piercing_attack = {
		harder = 0.25,
		hardest = 0.25,
		versus_base = 0.25,
		cataclysm = 0.25,
		cataclysm_3 = 0.25,
		cataclysm_2 = 0.25
	},
	fast_attack = {
		harder = 0,
		hardest = 0,
		versus_base = 0,
		cataclysm = 0,
		cataclysm_3 = 0,
		cataclysm_2 = 0
	}
}
BreedTweaks.dodge_window_durations = {
	normal_attack = {
		harder = 0.5,
		hardest = 0.5,
		versus_base = 0.5,
		cataclysm = 0.5,
		cataclysm_3 = 0.5,
		cataclysm_2 = 0.5
	},
	running_attack = {
		harder = 0.75,
		hardest = 0.75,
		versus_base = 0.75,
		cataclysm = 0.75,
		cataclysm_3 = 0.75,
		cataclysm_2 = 0.75
	},
	piercing_attack = {
		harder = 1,
		hardest = 1,
		cataclysm = 1,
		cataclysm_3 = 1,
		cataclysm_2 = 1
	}
}
BreedTweaks.fatigue_types = {
	roamer = {
		normal_attack = {
			hardest = "blocked_attack_2",
			normal = "blocked_attack",
			hard = "blocked_attack",
			harder = "blocked_attack",
			cataclysm = "blocked_attack_2",
			easy = "blocked_attack",
			versus_base = "blocked_attack",
			cataclysm_3 = "blocked_attack_3",
			cataclysm_2 = "blocked_attack_2"
		},
		running_attack = {
			hardest = "blocked_attack",
			normal = "blocked_attack",
			hard = "blocked_attack",
			harder = "blocked_attack",
			cataclysm = "blocked_attack_2",
			easy = "blocked_attack",
			versus_base = "blocked_attack",
			cataclysm_3 = "blocked_attack_2",
			cataclysm_2 = "blocked_attack_2"
		}
	},
	horde = {
		normal_attack = {
			hardest = "blocked_attack",
			normal = "blocked_attack",
			hard = "blocked_attack",
			harder = "blocked_attack",
			cataclysm = "blocked_attack_2",
			easy = "blocked_attack",
			versus_base = "blocked_attack",
			cataclysm_3 = "blocked_attack_2",
			cataclysm_2 = "blocked_attack_2"
		},
		running_attack = {
			hardest = "blocked_attack",
			normal = "blocked_attack",
			hard = "blocked_attack",
			harder = "blocked_attack",
			cataclysm = "blocked_attack_2",
			easy = "blocked_attack",
			versus_base = "blocked_attack",
			cataclysm_3 = "blocked_attack_2",
			cataclysm_2 = "blocked_attack_2"
		}
	},
	elite_cleave = {
		normal_attack = {
			hardest = "blocked_sv_cleave",
			normal = "blocked_sv_cleave",
			hard = "blocked_sv_cleave",
			harder = "blocked_sv_cleave",
			cataclysm = "blocked_sv_cleave",
			easy = "blocked_sv_cleave",
			versus_base = "blocked_sv_cleave",
			cataclysm_3 = "blocked_sv_cleave",
			cataclysm_2 = "blocked_sv_cleave"
		},
		running_attack = {
			hardest = "blocked_sv_cleave",
			normal = "blocked_sv_cleave",
			hard = "blocked_sv_cleave",
			harder = "blocked_sv_cleave",
			cataclysm = "blocked_sv_cleave",
			easy = "blocked_sv_cleave",
			versus_base = "blocked_sv_cleave",
			cataclysm_3 = "blocked_sv_cleave",
			cataclysm_2 = "blocked_sv_cleave"
		}
	},
	elite_sweep = {
		normal_attack = {
			hardest = "blocked_sv_sweep_2",
			normal = "blocked_sv_sweep",
			hard = "blocked_sv_sweep",
			harder = "blocked_sv_sweep",
			cataclysm = "blocked_sv_sweep_2",
			easy = "blocked_sv_sweep",
			versus_base = "blocked_sv_sweep",
			cataclysm_3 = "blocked_sv_sweep_2",
			cataclysm_2 = "blocked_sv_sweep_2"
		},
		running_attack = {
			hardest = "blocked_sv_sweep_2",
			normal = "blocked_sv_sweep",
			hard = "blocked_sv_sweep",
			harder = "blocked_sv_sweep",
			cataclysm = "blocked_sv_sweep_2",
			easy = "blocked_sv_sweep",
			versus_base = "blocked_sv_sweep",
			cataclysm_3 = "blocked_sv_sweep_2",
			cataclysm_2 = "blocked_sv_sweep_2"
		}
	},
	boss_combo = {
		normal_attack = {
			hardest = "blocked_sv_sweep",
			normal = "blocked_sv_sweep",
			hard = "blocked_sv_sweep",
			harder = "blocked_sv_sweep",
			cataclysm = "blocked_sv_sweep",
			easy = "blocked_sv_sweep",
			versus_base = "blocked_sv_sweep",
			cataclysm_3 = "blocked_sv_sweep",
			cataclysm_2 = "blocked_sv_sweep"
		},
		running_attack = {
			hardest = "blocked_sv_sweep",
			normal = "blocked_sv_sweep",
			hard = "blocked_sv_sweep",
			harder = "blocked_sv_sweep",
			cataclysm = "blocked_sv_sweep",
			easy = "blocked_sv_sweep",
			versus_base = "blocked_sv_sweep",
			cataclysm_3 = "blocked_sv_sweep",
			cataclysm_2 = "blocked_sv_sweep"
		},
		light_combo = {
			hardest = "chaos_spawn_combo",
			normal = "chaos_spawn_combo",
			hard = "chaos_spawn_combo",
			harder = "chaos_spawn_combo",
			cataclysm = "chaos_spawn_combo",
			easy = "chaos_spawn_combo",
			versus_base = "chaos_spawn_combo",
			cataclysm_3 = "chaos_spawn_combo",
			cataclysm_2 = "chaos_spawn_combo"
		}
	},
	headbutt = {
		normal_attack = {
			hardest = "blocked_headbutt",
			normal = "blocked_headbutt",
			hard = "blocked_headbutt",
			harder = "blocked_headbutt",
			cataclysm = "blocked_headbutt",
			easy = "blocked_headbutt",
			versus_base = "blocked_headbutt",
			cataclysm_3 = "blocked_headbutt",
			cataclysm_2 = "blocked_headbutt"
		}
	}
}
BreedTweaks.diminishing_damage_and_cooldown = {
	roamer = {
		easy = {
			{
				damage = 2,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 2,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 1.5,
				cooldown = {
					1,
					2
				}
			},
			{
				damage = 1,
				cooldown = {
					1.25,
					2.25
				}
			},
			{
				damage = 1,
				cooldown = {
					1.5,
					2.5
				}
			},
			{
				damage = 1,
				cooldown = {
					1.75,
					2.75
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					3
				}
			},
			{
				damage = 1,
				cooldown = {
					2.25,
					3.25
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			}
		},
		normal = {
			{
				damage = 2,
				cooldown = {
					2.75,
					3
				}
			},
			{
				damage = 2,
				cooldown = {
					2.75,
					3
				}
			},
			{
				damage = 1.5,
				cooldown = {
					1,
					2
				}
			},
			{
				damage = 1,
				cooldown = {
					1.25,
					2.25
				}
			},
			{
				damage = 1,
				cooldown = {
					1.5,
					2.5
				}
			},
			{
				damage = 1,
				cooldown = {
					1.75,
					2.75
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					3
				}
			},
			{
				damage = 1,
				cooldown = {
					2.25,
					3.25
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			}
		},
		hard = {
			{
				damage = 2,
				cooldown = {
					1,
					2
				}
			},
			{
				damage = 2,
				cooldown = {
					1,
					2
				}
			},
			{
				damage = 1.5,
				cooldown = {
					1,
					2
				}
			},
			{
				damage = 1,
				cooldown = {
					1.25,
					2.25
				}
			},
			{
				damage = 1,
				cooldown = {
					1.25,
					2.5
				}
			},
			{
				damage = 1,
				cooldown = {
					1.5,
					2.75
				}
			},
			{
				damage = 1,
				cooldown = {
					1.75,
					3
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					3.25
				}
			},
			{
				damage = 1,
				cooldown = {
					2.25,
					3.5
				}
			}
		},
		harder = {
			{
				damage = 2.5,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 2,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 1.5,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 1,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 1,
				cooldown = {
					0.6,
					1.1
				}
			},
			{
				damage = 1,
				cooldown = {
					0.7,
					1.2
				}
			},
			{
				damage = 1,
				cooldown = {
					0.8,
					1.3
				}
			},
			{
				damage = 1,
				cooldown = {
					0.9,
					1.4
				}
			},
			{
				damage = 1,
				cooldown = {
					1,
					1.5
				}
			}
		},
		hardest = {
			{
				damage = 2.5,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 1.8,
				cooldown = {
					0,
					0.3
				}
			},
			{
				damage = 1.6,
				cooldown = {
					0,
					0.35
				}
			},
			{
				damage = 1.4,
				cooldown = {
					0,
					0.4
				}
			},
			{
				damage = 1.2,
				cooldown = {
					0,
					0.45
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			}
		},
		cataclysm = {
			{
				damage = 2.5,
				cooldown = {
					0,
					0.1
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.1
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.1
				}
			},
			{
				damage = 1.8,
				cooldown = {
					0,
					0.3
				}
			},
			{
				damage = 1.6,
				cooldown = {
					0,
					0.35
				}
			},
			{
				damage = 1.4,
				cooldown = {
					0,
					0.4
				}
			},
			{
				damage = 1.2,
				cooldown = {
					0,
					0.45
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			}
		},
		cataclysm_2 = {
			{
				damage = 2.5,
				cooldown = {
					0,
					0.1
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.1
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.1
				}
			},
			{
				damage = 1.8,
				cooldown = {
					0,
					0.3
				}
			},
			{
				damage = 1.6,
				cooldown = {
					0,
					0.35
				}
			},
			{
				damage = 1.4,
				cooldown = {
					0,
					0.4
				}
			},
			{
				damage = 1.2,
				cooldown = {
					0,
					0.45
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			}
		},
		cataclysm_3 = {
			{
				damage = 2.5,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1.8,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1.6,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1.4,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1.2,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0
				}
			}
		},
		versus_base = {
			{
				damage = 2,
				cooldown = {
					2.75,
					3
				}
			},
			{
				damage = 2,
				cooldown = {
					2.75,
					3
				}
			},
			{
				damage = 1.5,
				cooldown = {
					1,
					2
				}
			},
			{
				damage = 1,
				cooldown = {
					1.25,
					2.25
				}
			},
			{
				damage = 1,
				cooldown = {
					1.5,
					2.5
				}
			},
			{
				damage = 1,
				cooldown = {
					1.75,
					2.75
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					3
				}
			},
			{
				damage = 1,
				cooldown = {
					2.25,
					3.25
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			}
		}
	},
	horde = {
		easy = {
			{
				damage = 2,
				cooldown = {
					3,
					5
				}
			},
			{
				damage = 1.5,
				cooldown = {
					3,
					5
				}
			},
			{
				damage = 1,
				cooldown = {
					3,
					5
				}
			},
			{
				damage = 1,
				cooldown = {
					3,
					5
				}
			},
			{
				damage = 1,
				cooldown = {
					3.3,
					7
				}
			},
			{
				damage = 1,
				cooldown = {
					3.6,
					7
				}
			},
			{
				damage = 1,
				cooldown = {
					4,
					7
				}
			},
			{
				damage = 1,
				cooldown = {
					4.5,
					8
				}
			},
			{
				damage = 1,
				cooldown = {
					5,
					8
				}
			}
		},
		normal = {
			{
				damage = 2,
				cooldown = {
					1.75,
					2.25
				}
			},
			{
				damage = 2,
				cooldown = {
					1.75,
					2.25
				}
			},
			{
				damage = 1.5,
				cooldown = {
					2,
					2.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					2.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			}
		},
		hard = {
			{
				damage = 2,
				cooldown = {
					1.5,
					2
				}
			},
			{
				damage = 2,
				cooldown = {
					1.5,
					2
				}
			},
			{
				damage = 1.5,
				cooldown = {
					1.75,
					2.25
				}
			},
			{
				damage = 1,
				cooldown = {
					1.75,
					2.25
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					2.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					2.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					2.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					2.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					2.5
				}
			}
		},
		harder = {
			{
				damage = 2.5,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 2,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 1.5,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 1,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 1,
				cooldown = {
					0.6,
					1.1
				}
			},
			{
				damage = 1,
				cooldown = {
					0.7,
					1.2
				}
			},
			{
				damage = 1,
				cooldown = {
					0.8,
					1.3
				}
			},
			{
				damage = 1,
				cooldown = {
					0.9,
					1.4
				}
			},
			{
				damage = 1,
				cooldown = {
					1,
					1.5
				}
			}
		},
		hardest = {
			{
				damage = 2.5,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 1.8,
				cooldown = {
					0,
					0.3
				}
			},
			{
				damage = 1.6,
				cooldown = {
					0,
					0.35
				}
			},
			{
				damage = 1.4,
				cooldown = {
					0,
					0.4
				}
			},
			{
				damage = 1.2,
				cooldown = {
					0,
					0.45
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			}
		},
		cataclysm = {
			{
				damage = 2.5,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 1.8,
				cooldown = {
					0,
					0.3
				}
			},
			{
				damage = 1.6,
				cooldown = {
					0,
					0.35
				}
			},
			{
				damage = 1.4,
				cooldown = {
					0,
					0.4
				}
			},
			{
				damage = 1.2,
				cooldown = {
					0,
					0.45
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			}
		},
		cataclysm_2 = {
			{
				damage = 2.5,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 1.8,
				cooldown = {
					0,
					0.3
				}
			},
			{
				damage = 1.6,
				cooldown = {
					0,
					0.35
				}
			},
			{
				damage = 1.4,
				cooldown = {
					0,
					0.4
				}
			},
			{
				damage = 1.2,
				cooldown = {
					0,
					0.45
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			}
		},
		cataclysm_3 = {
			{
				damage = 2.5,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1.8,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1.6,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1.4,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1.2,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0
				}
			}
		},
		versus_base = {
			{
				damage = 2,
				cooldown = {
					1.75,
					2.25
				}
			},
			{
				damage = 2,
				cooldown = {
					1.75,
					2.25
				}
			},
			{
				damage = 1.5,
				cooldown = {
					2,
					2.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					2.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			}
		}
	},
	berzerker = {
		easy = {
			{
				damage = 2,
				cooldown = {
					2,
					5
				}
			},
			{
				damage = 1.5,
				cooldown = {
					2,
					5
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					5
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					5
				}
			},
			{
				damage = 1,
				cooldown = {
					3,
					7
				}
			},
			{
				damage = 1,
				cooldown = {
					3,
					7
				}
			},
			{
				damage = 1,
				cooldown = {
					3,
					7
				}
			},
			{
				damage = 1,
				cooldown = {
					4,
					8
				}
			},
			{
				damage = 1,
				cooldown = {
					4,
					8
				}
			}
		},
		normal = {
			{
				damage = 2,
				cooldown = {
					2,
					3
				}
			},
			{
				damage = 2,
				cooldown = {
					2,
					3
				}
			},
			{
				damage = 1.5,
				cooldown = {
					2,
					3
				}
			},
			{
				damage = 1,
				cooldown = {
					2.25,
					3.25
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2.75,
					3.75
				}
			},
			{
				damage = 1,
				cooldown = {
					3,
					4
				}
			},
			{
				damage = 1,
				cooldown = {
					3.25,
					4.25
				}
			},
			{
				damage = 1,
				cooldown = {
					3.5,
					4.5
				}
			}
		},
		hard = {
			{
				damage = 2,
				cooldown = {
					1,
					1.5
				}
			},
			{
				damage = 2,
				cooldown = {
					1,
					1.5
				}
			},
			{
				damage = 1.5,
				cooldown = {
					1,
					1.5
				}
			},
			{
				damage = 1,
				cooldown = {
					1.25,
					1.75
				}
			},
			{
				damage = 1,
				cooldown = {
					1.5,
					2
				}
			},
			{
				damage = 1,
				cooldown = {
					1.75,
					2.25
				}
			},
			{
				damage = 1,
				cooldown = {
					2,
					2.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2.25,
					3.25
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			}
		},
		harder = {
			{
				damage = 2.5,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 2,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 1.5,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 1,
				cooldown = {
					0.5,
					1
				}
			},
			{
				damage = 1,
				cooldown = {
					0.6,
					1.1
				}
			},
			{
				damage = 1,
				cooldown = {
					0.7,
					1.2
				}
			},
			{
				damage = 1,
				cooldown = {
					0.8,
					1.3
				}
			},
			{
				damage = 1,
				cooldown = {
					0.9,
					1.4
				}
			},
			{
				damage = 1,
				cooldown = {
					1,
					1.5
				}
			}
		},
		hardest = {
			{
				damage = 2.5,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 1.8,
				cooldown = {
					0,
					0.3
				}
			},
			{
				damage = 1.6,
				cooldown = {
					0,
					0.35
				}
			},
			{
				damage = 1.4,
				cooldown = {
					0,
					0.4
				}
			},
			{
				damage = 1.2,
				cooldown = {
					0,
					0.45
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			}
		},
		cataclysm = {
			{
				damage = 2.5,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 1.8,
				cooldown = {
					0,
					0.3
				}
			},
			{
				damage = 1.6,
				cooldown = {
					0,
					0.35
				}
			},
			{
				damage = 1.4,
				cooldown = {
					0,
					0.4
				}
			},
			{
				damage = 1.2,
				cooldown = {
					0,
					0.45
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			}
		},
		cataclysm_2 = {
			{
				damage = 2.5,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0.25
				}
			},
			{
				damage = 1.8,
				cooldown = {
					0,
					0.3
				}
			},
			{
				damage = 1.6,
				cooldown = {
					0,
					0.35
				}
			},
			{
				damage = 1.4,
				cooldown = {
					0,
					0.4
				}
			},
			{
				damage = 1.2,
				cooldown = {
					0,
					0.45
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0.5
				}
			}
		},
		cataclysm_3 = {
			{
				damage = 2.5,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 2,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1.8,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1.6,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1.4,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1.2,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0
				}
			},
			{
				damage = 1,
				cooldown = {
					0,
					0
				}
			}
		},
		versus_base = {
			{
				damage = 2,
				cooldown = {
					2,
					3
				}
			},
			{
				damage = 2,
				cooldown = {
					2,
					3
				}
			},
			{
				damage = 1.5,
				cooldown = {
					2,
					3
				}
			},
			{
				damage = 1,
				cooldown = {
					2.25,
					3.25
				}
			},
			{
				damage = 1,
				cooldown = {
					2.5,
					3.5
				}
			},
			{
				damage = 1,
				cooldown = {
					2.75,
					3.75
				}
			},
			{
				damage = 1,
				cooldown = {
					3,
					4
				}
			},
			{
				damage = 1,
				cooldown = {
					3.25,
					4.25
				}
			},
			{
				damage = 1,
				cooldown = {
					3.5,
					4.5
				}
			}
		}
	}
}
BreedTweaks.standard_bearer_spawn_list = {
	easy = {
		"beastmen_ungor",
		"beastmen_ungor"
	},
	normal = {
		"beastmen_ungor",
		"beastmen_ungor"
	},
	hard = {
		"beastmen_gor",
		"beastmen_ungor",
		"beastmen_ungor"
	},
	harder = {
		"beastmen_gor",
		"beastmen_gor",
		"beastmen_ungor",
		"beastmen_ungor"
	},
	hardest = {
		"beastmen_gor",
		"beastmen_gor",
		"beastmen_gor",
		"beastmen_ungor"
	},
	cataclysm = {
		"beastmen_gor",
		"beastmen_gor",
		"beastmen_gor",
		"beastmen_gor"
	},
	cataclysm_2 = {
		"beastmen_gor",
		"beastmen_gor",
		"beastmen_gor",
		"beastmen_gor"
	},
	cataclysm_3 = {
		"beastmen_gor",
		"beastmen_gor",
		"beastmen_gor",
		"beastmen_gor"
	},
	versus_base = {
		"beastmen_ungor",
		"beastmen_ungor"
	}
}
BreedTweaks.standard_bearer_spawn_list_replacements = {
	"beastmen_gor",
	"beastmen_ungor_archer",
	"beastmen_ungor"
}
BreedTweaks.perception_weights = {
	prioritize_players_limit = 100
}
