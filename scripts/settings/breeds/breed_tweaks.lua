-- chunkname: @scripts/settings/breeds/breed_tweaks.lua

require("foundation/scripts/util/math")

BreedTweaks = {}

local tbl = {
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
local tbl_2 = {
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
local tbl_3 = {
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
local tbl_4 = {
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
local tbl_5 = {
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
local tbl_6 = {
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
local tbl_7 = {
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
local tbl_8 = {
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
local tbl_9 = {
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
local tbl_10 = {
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
local tbl_11 = {
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
local tbl_12 = {
	1,
	1,
	1.5,
	2,
	3.4,
	5.6,
	7.3,
	9,
	1
}

local function fn(arg_1_0)
	-- function 1
	arg_1_0 = math.clamp(arg_1_0, 0, 8191.5)

	local num = arg_1_0 % 1
	local num_2 = math.round(num * 4) * 0.25

	return math.floor(arg_1_0) + num_2
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local tbl = {}

	for i = 1, 9 do
		local num = arg_2_0 * arg_2_1[i]

		tbl[i] = fn(num)
	end

	return tbl
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local tbl = {}

	for i = 1, 9 do
		local num = arg_3_0 * arg_3_1[i]
		local num_2 = num % 1
		local num_3 = math.round(num_2 * 4) * 0.25

		tbl[i] = math.floor(num) + num_3
	end

	return tbl
end

BreedTweaks.max_health = {
	slave_rat = fn_2(4, tbl_8),
	fanatic = fn_2(8, tbl_8),
	ungor = fn_2(6, tbl_8),
	clan_rat = fn_2(8, tbl),
	clan_rat_with_shield = fn_2(8, tbl),
	marauder = fn_2(16, tbl),
	gor = fn_2(12, tbl),
	berzerker = fn_2(18, tbl_5),
	plague_monk = fn_2(18, tbl_5),
	stormvermin = fn_2(16, tbl_5),
	stormvermin_with_shield = fn_2(16, tbl_5),
	raider = fn_2(30, tbl_5),
	bestigor = fn_2(20, tbl_5),
	chaos_warrior = fn_2(46, tbl_5),
	chaos_bulwark = fn_2(56, tbl_5),
	chaos_spawn = fn_2(800, tbl_11),
	chaos_troll = fn_2(600, tbl_11),
	chaos_troll_chief = fn_2(600, tbl_12),
	rat_ogre = fn_2(800, tbl_11),
	stormfiend = fn_2(600, tbl_11),
	corruptor_sorcerer = fn_2(20, tbl),
	vortex_sorcerer = fn_2(20, tbl),
	warpfire_thrower = fn_2(12, tbl),
	globadier = fn_2(20, tbl),
	gutter_runner = fn_2(12, tbl),
	pack_master = fn_2(25, tbl),
	ratling_gunner = fn_2(12, tbl),
	standard_bearer = fn_2(20, tbl),
	stormvermin_warlord = fn_2(500, tbl_11),
	exalted_champion = fn_2(700, tbl_11),
	exalted_sorcerer = fn_2(1000, tbl_11),
	norsca_champion = fn_2(600, tbl_11),
	grey_seer = fn_2(500, tbl_11),
	stormfiend_boss = fn_2(600, tbl_11)
}
BreedTweaks.diff_stagger_resist = {
	slave_rat = fn_3(1, tbl_2),
	fanatic = fn_3(1.4, tbl_2),
	ungor = fn_3(1.3, tbl_2),
	clan_rat = fn_3(2.1, tbl_2),
	gor = fn_3(2.4, tbl_2),
	marauder = fn_3(2.65, tbl_2),
	stormvermin = fn_3(2.25, tbl_6),
	bestigor = fn_3(3.25, tbl_6),
	raider = fn_3(3, tbl_6),
	warrior = fn_3(4.8, tbl_6),
	berzerker = fn_3(2.7, tbl_6),
	plague_monk = fn_3(3, tbl_6),
	packmaster = fn_3(4, tbl_6),
	ratling_gunner = fn_3(2.5, tbl_6),
	sorcerer = fn_3(2.7, tbl_6)
}
BreedTweaks.stagger_reduction = {
	marauder = fn_3(0.2, tbl_2),
	gor = fn_3(0.1, tbl_2),
	stormvermin = fn_3(1, tbl_6),
	raider = fn_3(0.9, tbl_6),
	warrior = fn_3(1.8, tbl_6),
	bestigor = fn_3(1, tbl_6),
	berzerker = fn_3(0.75, tbl_6),
	plague_monk = fn_3(1.35, tbl_6),
	sorcerer = fn_3(2, tbl_6),
	packmaster = fn_3(2, tbl_6),
	ratling_gunner = fn_3(1, tbl_6),
	stormvermin_warlord = fn_3(1.35, tbl_6)
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
	slave_rat = fn_3(0.8, tbl_4),
	fanatic = fn_3(1.25, tbl_4),
	ungor = fn_3(1, tbl_4),
	clan_rat = fn_3(1.5, tbl_4),
	clan_rat_shield_block = fn_3(1.5, tbl_4),
	marauder = fn_3(3, tbl_4),
	gor = fn_3(2.75, tbl_4),
	stormvermin = fn_3(5, tbl_4),
	stormvermin_shield_block = fn_3(8, tbl_4),
	bestigor = fn_3(8, tbl_4),
	raider = fn_3(5, tbl_4),
	berzerker = fn_3(3, tbl_4),
	marauder_shield_block = fn_3(5, tbl_4),
	plague_monk = fn_3(2.5, tbl_4),
	sorcerer = fn_3(8, tbl_4)
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
