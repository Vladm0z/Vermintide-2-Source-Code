-- chunkname: @scripts/settings/dlcs/morris/deus_weapons.lua

local tbl = {
	melee = "deus_melee",
	ranged = "deus_ranged"
}
local tbl_2 = {
	melee = "deus_melee",
	trollhammer_torpedo = "deus_trollhammer_torpedo",
	ranged_energy = "deus_ranged_energy",
	ranged_heat = "deus_ranged_heat",
	ranged_ammo = "deus_ranged_ammo"
}
local DeusWeapons = DeusWeapons

DeusWeapons = DeusWeapons or {
	deus_wh_fencing_sword = {
		base_item = "wh_fencing_sword"
	},
	deus_wh_brace_of_pistols = {
		base_item = "wh_brace_of_pistols",
		property_table_name = "deus_ranged_ammo"
	},
	deus_bw_sword = {
		base_item = "bw_sword"
	},
	deus_bw_skullstaff_fireball = {
		base_item = "bw_skullstaff_fireball"
	},
	deus_dr_shield_axe = {
		base_item = "dr_shield_axe",
		trait_table_name = "deus_shield_melee"
	},
	deus_dr_crossbow = {
		base_item = "dr_crossbow",
		property_table_name = "deus_ranged_ammo"
	},
	deus_we_2h_axe = {
		base_item = "we_2h_axe",
		trait_table_name = "deus_heavy_melee"
	},
	deus_we_shortbow = {
		base_item = "we_shortbow",
		property_table_name = "deus_ranged_ammo"
	},
	deus_es_2h_hammer = {
		base_item = "es_2h_hammer",
		trait_table_name = "deus_heavy_melee"
	},
	deus_es_blunderbuss = {
		base_item = "es_blunderbuss",
		property_table_name = "deus_ranged_ammo"
	},
	deus_wh_2h_sword = {
		base_item = "wh_2h_sword",
		trait_table_name = "deus_heavy_melee"
	},
	deus_bw_skullstaff_geiser = {
		base_item = "bw_skullstaff_geiser"
	},
	deus_dr_2h_axe = {
		base_item = "dr_2h_axe",
		trait_table_name = "deus_heavy_melee"
	},
	deus_we_1h_sword = {
		base_item = "we_1h_sword"
	},
	deus_es_sword_shield = {
		base_item = "es_sword_shield",
		trait_table_name = "deus_shield_melee"
	},
	deus_es_1h_flail = {
		base_item = "es_1h_flail"
	},
	deus_wh_1h_axe = {
		base_item = "wh_1h_axe"
	},
	deus_wh_repeating_pistols = {
		base_item = "wh_repeating_pistols",
		property_table_name = "deus_ranged_ammo"
	},
	deus_wh_crossbow = {
		base_item = "wh_crossbow",
		property_table_name = "deus_ranged_ammo"
	},
	deus_bw_flame_sword = {
		base_item = "bw_flame_sword"
	},
	deus_bw_1h_mace = {
		base_item = "bw_1h_mace"
	},
	deus_bw_skullstaff_spear = {
		base_item = "bw_skullstaff_spear"
	},
	deus_dr_shield_hammer = {
		base_item = "dr_shield_hammer",
		trait_table_name = "deus_shield_melee"
	},
	deus_dr_dual_wield_axes = {
		base_item = "dr_dual_wield_axes"
	},
	deus_dr_1h_axe = {
		base_item = "dr_1h_axe"
	},
	deus_dr_drake_pistol = {
		base_item = "dr_drake_pistol"
	},
	deus_we_dual_wield_daggers = {
		base_item = "we_dual_wield_daggers"
	},
	deus_we_dual_wield_sword_dagger = {
		base_item = "we_dual_wield_sword_dagger"
	},
	deus_we_spear = {
		base_item = "we_spear",
		trait_table_name = "deus_heavy_melee"
	},
	deus_we_longbow = {
		base_item = "we_longbow",
		property_table_name = "deus_ranged_ammo"
	},
	deus_we_shortbow_hagbane = {
		base_item = "we_shortbow_hagbane",
		property_table_name = "deus_ranged_ammo"
	},
	deus_es_1h_mace = {
		base_item = "es_1h_mace"
	},
	deus_es_halberd = {
		base_item = "es_halberd",
		trait_table_name = "deus_heavy_melee"
	},
	deus_es_handgun = {
		base_item = "es_handgun",
		property_table_name = "deus_ranged_ammo"
	},
	deus_wh_1h_falchion = {
		base_item = "wh_1h_falchion"
	},
	deus_wh_2h_billhook = {
		base_item = "wh_2h_billhook",
		trait_table_name = "deus_heavy_melee"
	},
	deus_wh_dual_wield_axe_falchion = {
		base_item = "wh_dual_wield_axe_falchion"
	},
	deus_wh_crossbow_repeater = {
		base_item = "wh_crossbow_repeater",
		property_table_name = "deus_ranged_ammo"
	},
	deus_dr_1h_hammer = {
		base_item = "dr_1h_hammer"
	},
	deus_dr_2h_hammer = {
		base_item = "dr_2h_hammer",
		trait_table_name = "deus_heavy_melee"
	},
	deus_dr_2h_pick = {
		base_item = "dr_2h_pick",
		trait_table_name = "deus_heavy_melee"
	},
	deus_dr_drakegun = {
		base_item = "dr_drakegun"
	},
	deus_dr_rakegun = {
		base_item = "dr_rakegun",
		property_table_name = "deus_ranged_ammo"
	},
	deus_dr_handgun = {
		base_item = "dr_handgun",
		property_table_name = "deus_ranged_ammo"
	},
	deus_dr_1h_throwing_axes = {
		base_item = "dr_1h_throwing_axes",
		property_table_name = "deus_ranged_ammo"
	},
	deus_dr_dual_wield_hammers = {
		base_item = "dr_dual_wield_hammers"
	},
	deus_we_dual_wield_swords = {
		base_item = "we_dual_wield_swords"
	},
	deus_we_2h_sword = {
		base_item = "we_2h_sword",
		trait_table_name = "deus_heavy_melee"
	},
	deus_we_1h_spears_shield = {
		base_item = "we_1h_spears_shield",
		trait_table_name = "deus_shield_melee"
	},
	deus_we_1h_axe = {
		base_item = "we_1h_axe"
	},
	deus_we_crossbow_repeater = {
		base_item = "we_crossbow_repeater",
		property_table_name = "deus_ranged_ammo"
	},
	deus_es_2h_sword_executioner = {
		base_item = "es_2h_sword_executioner",
		trait_table_name = "deus_heavy_melee"
	},
	deus_es_mace_shield = {
		base_item = "es_mace_shield",
		trait_table_name = "deus_shield_melee"
	},
	deus_es_1h_sword = {
		base_item = "es_1h_sword"
	},
	deus_es_2h_sword = {
		base_item = "es_2h_sword",
		trait_table_name = "deus_heavy_melee"
	},
	deus_es_dual_wield_hammer_sword = {
		base_item = "es_dual_wield_hammer_sword"
	},
	deus_es_2h_heavy_spear = {
		base_item = "es_2h_heavy_spear",
		trait_table_name = "deus_heavy_melee"
	},
	deus_es_deus_01 = {
		base_item = "es_deus_01",
		trait_table_name = "deus_shield_melee"
	},
	deus_es_bastard_sword = {
		base_item = "es_bastard_sword",
		trait_table_name = "deus_heavy_melee"
	},
	deus_es_sword_shield_breton = {
		base_item = "es_sword_shield_breton",
		trait_table_name = "deus_shield_melee"
	},
	deus_es_longbow = {
		base_item = "es_longbow",
		property_table_name = "deus_ranged_ammo"
	},
	deus_es_repeating_handgun = {
		base_item = "es_repeating_handgun",
		property_table_name = "deus_ranged_ammo"
	},
	deus_bw_dagger = {
		base_item = "bw_dagger"
	},
	deus_bw_1h_crowbill = {
		base_item = "bw_1h_crowbill"
	},
	deus_bw_1h_flail_flaming = {
		base_item = "bw_1h_flail_flaming"
	},
	deus_bw_skullstaff_beam = {
		base_item = "bw_skullstaff_beam"
	},
	deus_bw_skullstaff_flamethrower = {
		base_item = "bw_skullstaff_flamethrower"
	},
	deus_dr_deus_01 = {
		base_item = "dr_deus_01",
		property_table_name = "deus_trollhammer_torpedo"
	},
	deus_wh_deus_01 = {
		base_item = "wh_deus_01"
	},
	deus_bw_deus_01 = {
		base_item = "bw_deus_01"
	},
	deus_we_deus_01 = {
		base_item = "we_deus_01"
	},
	deus_dr_2h_cog_hammer = {
		base_item = "dr_2h_cog_hammer",
		trait_table_name = "deus_heavy_melee"
	},
	deus_dr_steam_pistol = {
		base_item = "dr_steam_pistol",
		property_table_name = "deus_ranged_ammo"
	},
	deus_we_javelin = {
		base_item = "we_javelin"
	},
	deus_we_life_staff = {
		base_item = "we_life_staff"
	},
	deus_wh_1h_hammer = {
		base_item = "wh_1h_hammer"
	},
	deus_wh_2h_hammer = {
		base_item = "wh_2h_hammer"
	},
	deus_wh_hammer_shield = {
		base_item = "wh_hammer_shield"
	},
	deus_wh_flail_shield = {
		base_item = "wh_flail_shield"
	},
	deus_wh_dual_hammer = {
		base_item = "wh_dual_hammer"
	},
	deus_wh_hammer_book = {
		base_item = "wh_hammer_book"
	},
	deus_bw_ghost_scythe = {
		base_item = "bw_ghost_scythe"
	},
	deus_bw_necromancy_staff = {
		base_item = "bw_necromancy_staff"
	},
	deus_wh_fencing_sword_unique1 = {
		base_item = "wh_fencing_sword",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_wh_1h_axe_unique1 = {
		base_item = "wh_1h_axe",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_wh_1h_falchion_unique1 = {
		base_item = "wh_1h_falchion",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_1h_flail_unique1 = {
		base_item = "es_1h_flail",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_wh_2h_sword_unique1 = {
		base_item = "wh_2h_sword",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_wh_dual_wield_axe_falchion_unique1 = {
		base_item = "wh_dual_wield_axe_falchion",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_wh_2h_billhook_unique1 = {
		base_item = "wh_2h_billhook",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_wh_brace_of_pistols_unique1 = {
		base_item = "wh_brace_of_pistols",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_wh_crossbow_unique1 = {
		base_item = "wh_crossbow",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_wh_repeating_pistols_unique1 = {
		base_item = "wh_repeating_pistols",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_wh_crossbow_repeater_unique1 = {
		base_item = "wh_crossbow_repeater",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_1h_axe_unique1 = {
		base_item = "dr_1h_axe",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_shield_axe_unique1 = {
		base_item = "dr_shield_axe",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_dual_wield_axes_unique1 = {
		base_item = "dr_dual_wield_axes",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_2h_axe_unique1 = {
		base_item = "dr_2h_axe",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_1h_hammer_unique1 = {
		base_item = "dr_1h_hammer",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_shield_hammer_unique1 = {
		base_item = "dr_shield_hammer",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_2h_hammer_unique1 = {
		base_item = "dr_2h_hammer",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_2h_pick_unique1 = {
		base_item = "dr_2h_pick",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_dual_wield_hammers_unique1 = {
		base_item = "dr_dual_wield_hammers",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_crossbow_unique1 = {
		base_item = "dr_crossbow",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_drake_pistol_unique1 = {
		base_item = "dr_drake_pistol",
		archetypes = {
			"ranged_hunter",
			"heat_dissipator",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"thermic_inertia",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_drakegun_unique1 = {
		base_item = "dr_drakegun",
		archetypes = {
			"ranged_hunter",
			"heat_dissipator",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"thermic_inertia",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_rakegun_unique1 = {
		base_item = "dr_rakegun",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_handgun_unique1 = {
		base_item = "dr_handgun",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_1h_throwing_axes_unique1 = {
		base_item = "dr_1h_throwing_axes",
		archetypes = {
			"ranged_hunter",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_dr_deus_01_unique1 = {
		base_item = "dr_deus_01",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_dual_wield_daggers_unique1 = {
		base_item = "we_dual_wield_daggers",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_dual_wield_swords_unique1 = {
		base_item = "we_dual_wield_swords",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_spear_unique1 = {
		base_item = "we_spear",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_1h_sword_unique1 = {
		base_item = "we_1h_sword",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_1h_axe_unique1 = {
		base_item = "we_1h_axe",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_dual_wield_sword_dagger_unique1 = {
		base_item = "we_dual_wield_sword_dagger",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_2h_sword_unique1 = {
		base_item = "we_2h_sword",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_2h_axe_unique1 = {
		base_item = "we_2h_axe",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_1h_spears_shield_unique1 = {
		base_item = "we_1h_spears_shield",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_shortbow_hagbane_unique1 = {
		base_item = "we_shortbow_hagbane",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_longbow_unique1 = {
		base_item = "we_longbow",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_shortbow_unique1 = {
		base_item = "we_shortbow",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_crossbow_repeater_unique1 = {
		base_item = "we_crossbow_repeater",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_2h_sword_executioner_unique1 = {
		base_item = "es_2h_sword_executioner",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_halberd_unique1 = {
		base_item = "es_halberd",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_1h_mace_unique1 = {
		base_item = "es_1h_mace",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_mace_shield_unique1 = {
		base_item = "es_mace_shield",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_1h_sword_unique1 = {
		base_item = "es_1h_sword",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_sword_shield_unique1 = {
		base_item = "es_sword_shield",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_2h_hammer_unique1 = {
		base_item = "es_2h_hammer",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_2h_sword_unique1 = {
		base_item = "es_2h_sword",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_bastard_sword_unique1 = {
		base_item = "es_bastard_sword",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_sword_shield_breton_unique1 = {
		base_item = "es_sword_shield_breton",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_dual_wield_hammer_sword_unique1 = {
		base_item = "es_dual_wield_hammer_sword",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_2h_heavy_spear_unique1 = {
		base_item = "es_2h_heavy_spear",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_deus_01_unique1 = {
		base_item = "es_deus_01",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_blunderbuss_unique1 = {
		base_item = "es_blunderbuss",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_handgun_unique1 = {
		base_item = "es_handgun",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_longbow_unique1 = {
		base_item = "es_longbow",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_es_repeating_handgun_unique1 = {
		base_item = "es_repeating_handgun",
		archetypes = {
			"ranged_hunter",
			"ranged_support",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"double_tap",
			"scrounger",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_bw_dagger_unique1 = {
		base_item = "bw_dagger",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_bw_flame_sword_unique1 = {
		base_item = "bw_flame_sword",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_bw_1h_mace_unique1 = {
		base_item = "bw_1h_mace",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_bw_sword_unique1 = {
		base_item = "bw_sword",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_bw_1h_crowbill_unique1 = {
		base_item = "bw_1h_crowbill",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_bw_1h_flail_flaming_unique1 = {
		base_item = "bw_1h_flail_flaming",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_bw_skullstaff_beam_unique1 = {
		base_item = "bw_skullstaff_beam",
		archetypes = {
			"ranged_hunter",
			"heat_dissipator",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"thermic_inertia",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_bw_skullstaff_spear_unique1 = {
		base_item = "bw_skullstaff_spear",
		archetypes = {
			"ranged_hunter",
			"heat_dissipator",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"thermic_inertia",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_bw_skullstaff_geiser_unique1 = {
		base_item = "bw_skullstaff_geiser",
		archetypes = {
			"ranged_hunter",
			"heat_dissipator",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"thermic_inertia",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_bw_skullstaff_fireball_unique1 = {
		base_item = "bw_skullstaff_fireball",
		archetypes = {
			"ranged_hunter",
			"heat_dissipator",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"thermic_inertia",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_bw_skullstaff_flamethrower_unique1 = {
		base_item = "bw_skullstaff_flamethrower",
		archetypes = {
			"ranged_hunter",
			"heat_dissipator",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"thermic_inertia",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_bw_deus_01_unique1 = {
		base_item = "bw_deus_01",
		archetypes = {
			"ranged_hunter",
			"heat_dissipator",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"thermic_inertia",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_wh_deus_01_unique1 = {
		base_item = "wh_deus_01",
		archetypes = {
			"attack_speed_on_crit",
			"booster_crit",
			"armor_eater",
			"heal_on_crit",
			"counter",
			"ultimate_spam",
			"savior",
			"tank",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	},
	deus_we_deus_01_unique1 = {
		base_item = "we_deus_01",
		archetypes = {
			"ranged_hunter",
			"ranged_ultimate_spam",
			"armor_eater",
			"anti_boss",
			"anti_horde",
			"shockwave",
			"anti_skaven",
			"anti_chaos"
		}
	}
}
DeusWeapons = DeusWeapons

local DeusDefaultLoadout = DeusDefaultLoadout

DeusDefaultLoadout = DeusDefaultLoadout or {
	wh_zealot = {
		slot_ranged = "deus_wh_deus_01",
		slot_melee = "deus_wh_1h_axe"
	},
	wh_bountyhunter = {
		slot_ranged = "deus_wh_deus_01",
		slot_melee = "deus_wh_1h_axe"
	},
	wh_captain = {
		slot_ranged = "deus_wh_deus_01",
		slot_melee = "deus_wh_1h_axe"
	},
	wh_priest = {
		slot_ranged = "deus_wh_2h_hammer",
		slot_melee = "deus_wh_1h_hammer"
	},
	bw_scholar = {
		slot_ranged = "deus_bw_deus_01",
		slot_melee = "deus_bw_sword"
	},
	bw_adept = {
		slot_ranged = "deus_bw_deus_01",
		slot_melee = "deus_bw_1h_mace"
	},
	bw_unchained = {
		slot_ranged = "deus_bw_deus_01",
		slot_melee = "deus_bw_flame_sword"
	},
	bw_necromancer = {
		slot_ranged = "deus_bw_necromancy_staff",
		slot_melee = "deus_bw_ghost_scythe"
	},
	dr_ironbreaker = {
		slot_ranged = "deus_dr_deus_01",
		slot_melee = "deus_dr_shield_hammer"
	},
	dr_slayer = {
		slot_ranged = "deus_dr_2h_axe",
		slot_melee = "deus_dr_dual_wield_axes"
	},
	dr_ranger = {
		slot_ranged = "deus_dr_crossbow",
		slot_melee = "deus_dr_1h_axe"
	},
	dr_engineer = {
		slot_ranged = "deus_dr_crossbow",
		slot_melee = "deus_dr_dual_wield_axes"
	},
	we_shade = {
		slot_ranged = "deus_we_deus_01",
		slot_melee = "deus_we_dual_wield_sword_dagger"
	},
	we_maidenguard = {
		slot_ranged = "deus_we_deus_01",
		slot_melee = "deus_we_spear"
	},
	we_waywatcher = {
		slot_ranged = "deus_we_deus_01",
		slot_melee = "deus_we_1h_sword"
	},
	we_thornsister = {
		slot_ranged = "deus_we_life_staff",
		slot_melee = "deus_we_1h_sword"
	},
	es_huntsman = {
		slot_ranged = "deus_es_handgun",
		slot_melee = "deus_es_2h_sword"
	},
	es_knight = {
		slot_ranged = "deus_es_blunderbuss",
		slot_melee = "deus_es_sword_shield"
	},
	es_mercenary = {
		slot_ranged = "deus_es_blunderbuss",
		slot_melee = "deus_es_2h_sword"
	},
	es_questingknight = {
		slot_ranged = "deus_es_sword_shield",
		slot_melee = "deus_es_bastard_sword"
	}
}
DeusDefaultLoadout = DeusDefaultLoadout

local DeusStartingWeaponTypeMapping = DeusStartingWeaponTypeMapping

DeusStartingWeaponTypeMapping = DeusStartingWeaponTypeMapping or {
	we_2h_sword = "deus_we_2h_sword",
	dr_1h_throwing_axes = "deus_dr_1h_throwing_axes",
	dr_2h_pick = "deus_dr_2h_pick",
	es_1h_flail = "deus_es_1h_flail",
	wh_fencing_sword = "deus_wh_fencing_sword",
	wh_dual_wield_axe_falchion = "deus_wh_dual_wield_axe_falchion",
	es_1h_mace = "deus_es_1h_mace",
	we_crossbow_repeater = "deus_we_crossbow_repeater",
	bw_1h_mace = "deus_bw_1h_mace",
	es_repeating_handgun = "deus_es_repeating_handgun",
	dr_handgun = "deus_dr_handgun",
	we_1h_sword = "deus_we_1h_sword",
	es_mace_shield = "deus_es_mace_shield",
	dr_rakegun = "deus_dr_rakegun",
	wh_2h_billhook = "deus_wh_2h_billhook",
	we_dual_wield_daggers = "deus_we_dual_wield_daggers",
	es_sword_shield_breton = "deus_es_sword_shield_breton",
	es_handgun = "deus_es_handgun",
	we_shortbow = "deus_we_shortbow",
	dr_dual_wield_hammers = "deus_dr_dual_wield_hammers",
	we_1h_spears_shield = "deus_we_1h_spears_shield",
	es_deus_01 = "deus_es_deus_01",
	bw_deus_01 = "deus_bw_deus_01",
	wh_2h_sword = "deus_wh_2h_sword",
	wh_deus_01 = "deus_wh_deus_01",
	we_deus_01 = "deus_we_deus_01",
	bw_skullstaff_geiser = "deus_bw_skullstaff_geiser",
	dr_2h_cog_hammer = "deus_dr_2h_cog_hammer",
	wh_2h_hammer = "deus_wh_2h_hammer",
	wh_hammer_shield = "deus_wh_hammer_shield",
	es_2h_hammer = "deus_es_2h_hammer",
	wh_flail_shield = "deus_wh_flail_shield",
	we_dual_wield_sword_dagger = "deus_we_dual_wield_sword_dagger",
	wh_hammer_book = "deus_wh_hammer_book",
	wh_repeating_pistols = "deus_wh_repeating_pistols",
	bw_ghost_scythe = "deus_bw_ghost_scythe",
	es_sword_shield = "deus_es_sword_shield",
	we_spear = "deus_we_spear",
	es_longbow = "deus_es_longbow",
	dr_shield_axe = "deus_dr_shield_axe",
	bw_necromancy_staff = "deus_bw_necromancy_staff",
	es_halberd = "deus_es_halberd",
	es_dual_wield_hammer_sword = "deus_es_dual_wield_hammer_sword",
	we_longbow = "deus_we_longbow",
	wh_brace_of_pistols = "deus_wh_brace_of_pistols",
	bw_1h_crowbill = "deus_bw_1h_crowbill",
	es_bastard_sword = "deus_es_bastard_sword",
	wh_1h_axe = "deus_wh_1h_axe",
	dr_crossbow = "deus_dr_crossbow",
	dr_deus_01 = "deus_dr_deus_01",
	bw_skullstaff_spear = "deus_bw_skullstaff_spear",
	dr_drake_pistol = "deus_dr_drake_pistol",
	dr_drakegun = "deus_dr_drakegun",
	bw_skullstaff_fireball = "deus_bw_skullstaff_fireball",
	we_1h_axe = "deus_we_1h_axe",
	es_blunderbuss = "deus_es_blunderbuss",
	wh_1h_falchion = "deus_wh_1h_falchion",
	we_shortbow_hagbane = "deus_we_shortbow_hagbane",
	dr_1h_axe = "deus_dr_1h_axe",
	bw_sword = "deus_bw_sword",
	we_2h_axe = "deus_we_2h_axe",
	bw_skullstaff_flamethrower = "deus_bw_skullstaff_flamethrower",
	es_2h_sword_executioner = "deus_es_2h_sword_executioner",
	we_life_staff = "deus_we_life_staff",
	we_dual_wield_swords = "deus_we_dual_wield_swords",
	bw_skullstaff_beam = "deus_bw_skullstaff_beam",
	dr_2h_axe = "deus_dr_2h_axe",
	es_2h_heavy_spear = "deus_es_2h_heavy_spear",
	wh_dual_hammer = "deus_wh_dual_hammer",
	bw_1h_flail_flaming = "deus_bw_1h_flail_flaming",
	dr_shield_hammer = "deus_dr_shield_hammer",
	es_2h_sword = "deus_es_2h_sword",
	we_javelin = "deus_we_javelin",
	wh_1h_hammer = "deus_wh_1h_hammer",
	wh_crossbow = "deus_wh_crossbow",
	dr_steam_pistol = "deus_dr_steam_pistol",
	wh_crossbow_repeater = "deus_wh_crossbow_repeater",
	es_1h_sword = "deus_es_1h_sword",
	bw_flame_sword = "deus_bw_flame_sword",
	dr_1h_hammer = "deus_dr_1h_hammer",
	dr_2h_hammer = "deus_dr_2h_hammer",
	bw_dagger = "deus_bw_dagger",
	dr_dual_wield_axes = "deus_dr_dual_wield_axes"
}
DeusStartingWeaponTypeMapping = DeusStartingWeaponTypeMapping

local DeusWeaponGroups = DeusWeaponGroups

DeusWeaponGroups = DeusWeaponGroups or {
	wh_fencing_sword = {
		default = "deus_wh_fencing_sword",
		slot_type = "melee",
		can_wield = ItemMasterList.wh_fencing_sword.can_wield,
		items_per_rarity = {}
	},
	wh_1h_axe = {
		default = "deus_wh_1h_axe",
		slot_type = "melee",
		can_wield = ItemMasterList.wh_1h_axe.can_wield,
		items_per_rarity = {}
	},
	wh_1h_falchion = {
		default = "deus_wh_1h_falchion",
		slot_type = "melee",
		can_wield = ItemMasterList.wh_1h_falchion.can_wield,
		items_per_rarity = {}
	},
	wh_2h_sword = {
		default = "deus_wh_2h_sword",
		slot_type = "melee",
		can_wield = ItemMasterList.wh_2h_sword.can_wield,
		items_per_rarity = {}
	},
	wh_dual_wield_axe_falchion = {
		default = "deus_wh_dual_wield_axe_falchion",
		slot_type = "melee",
		can_wield = ItemMasterList.wh_dual_wield_axe_falchion.can_wield,
		items_per_rarity = {}
	},
	wh_2h_billhook = {
		default = "deus_wh_2h_billhook",
		slot_type = "melee",
		can_wield = ItemMasterList.wh_2h_billhook.can_wield,
		items_per_rarity = {}
	},
	wh_brace_of_pistols = {
		default = "deus_wh_brace_of_pistols",
		slot_type = "ranged",
		can_wield = ItemMasterList.wh_brace_of_pistols.can_wield,
		items_per_rarity = {}
	},
	bw_sword = {
		default = "deus_bw_sword",
		slot_type = "melee",
		can_wield = ItemMasterList.bw_sword.can_wield,
		items_per_rarity = {}
	},
	bw_skullstaff_fireball = {
		default = "deus_bw_skullstaff_fireball",
		slot_type = "ranged",
		can_wield = ItemMasterList.bw_skullstaff_fireball.can_wield,
		items_per_rarity = {}
	},
	dr_shield_axe = {
		default = "deus_dr_shield_axe",
		slot_type = "melee",
		can_wield = ItemMasterList.dr_shield_axe.can_wield,
		items_per_rarity = {}
	},
	dr_crossbow = {
		default = "deus_dr_crossbow",
		slot_type = "ranged",
		can_wield = ItemMasterList.dr_crossbow.can_wield,
		items_per_rarity = {}
	},
	we_2h_axe = {
		default = "deus_we_2h_axe",
		slot_type = "melee",
		can_wield = ItemMasterList.we_2h_axe.can_wield,
		items_per_rarity = {}
	},
	we_shortbow = {
		default = "deus_we_shortbow",
		slot_type = "ranged",
		can_wield = ItemMasterList.we_shortbow.can_wield,
		items_per_rarity = {}
	},
	es_2h_hammer = {
		default = "deus_es_2h_hammer",
		slot_type = "melee",
		can_wield = ItemMasterList.es_2h_hammer.can_wield,
		items_per_rarity = {}
	},
	es_blunderbuss = {
		default = "deus_es_blunderbuss",
		slot_type = "ranged",
		can_wield = ItemMasterList.es_blunderbuss.can_wield,
		items_per_rarity = {}
	},
	bw_skullstaff_geiser = {
		default = "deus_bw_skullstaff_geiser",
		slot_type = "ranged",
		can_wield = ItemMasterList.bw_skullstaff_geiser.can_wield,
		items_per_rarity = {}
	},
	dr_2h_axe = {
		default = "deus_dr_2h_axe",
		slot_type = "melee",
		can_wield = ItemMasterList.dr_2h_axe.can_wield,
		items_per_rarity = {}
	},
	we_1h_sword = {
		default = "deus_we_1h_sword",
		slot_type = "melee",
		can_wield = ItemMasterList.we_1h_sword.can_wield,
		items_per_rarity = {}
	},
	we_1h_axe = {
		default = "deus_we_1h_axe",
		slot_type = "melee",
		can_wield = ItemMasterList.we_1h_axe.can_wield,
		items_per_rarity = {}
	},
	es_sword_shield = {
		default = "deus_es_sword_shield",
		slot_type = "melee",
		can_wield = ItemMasterList.es_sword_shield.can_wield,
		items_per_rarity = {}
	},
	es_1h_flail = {
		default = "deus_es_1h_flail",
		slot_type = "melee",
		can_wield = ItemMasterList.es_1h_flail.can_wield,
		items_per_rarity = {}
	},
	wh_repeating_pistols = {
		default = "deus_wh_repeating_pistols",
		slot_type = "ranged",
		can_wield = ItemMasterList.wh_repeating_pistols.can_wield,
		items_per_rarity = {}
	},
	wh_crossbow = {
		default = "deus_wh_crossbow",
		slot_type = "ranged",
		can_wield = ItemMasterList.wh_crossbow.can_wield,
		items_per_rarity = {}
	},
	bw_flame_sword = {
		default = "deus_bw_flame_sword",
		slot_type = "melee",
		can_wield = ItemMasterList.bw_flame_sword.can_wield,
		items_per_rarity = {}
	},
	bw_1h_mace = {
		default = "deus_bw_1h_mace",
		slot_type = "melee",
		can_wield = ItemMasterList.bw_1h_mace.can_wield,
		items_per_rarity = {}
	},
	bw_skullstaff_spear = {
		default = "deus_bw_skullstaff_spear",
		slot_type = "ranged",
		can_wield = ItemMasterList.bw_skullstaff_spear.can_wield,
		items_per_rarity = {}
	},
	dr_shield_hammer = {
		default = "deus_dr_shield_hammer",
		slot_type = "melee",
		can_wield = ItemMasterList.dr_shield_hammer.can_wield,
		items_per_rarity = {}
	},
	dr_dual_wield_axes = {
		default = "deus_dr_dual_wield_axes",
		slot_type = "melee",
		can_wield = ItemMasterList.dr_dual_wield_axes.can_wield,
		items_per_rarity = {}
	},
	dr_1h_axe = {
		default = "deus_dr_1h_axe",
		slot_type = "melee",
		can_wield = ItemMasterList.dr_1h_axe.can_wield,
		items_per_rarity = {}
	},
	dr_drake_pistol = {
		default = "deus_dr_drake_pistol",
		slot_type = "ranged",
		can_wield = ItemMasterList.dr_drake_pistol.can_wield,
		items_per_rarity = {}
	},
	we_dual_wield_daggers = {
		default = "deus_we_dual_wield_daggers",
		slot_type = "melee",
		can_wield = ItemMasterList.we_dual_wield_daggers.can_wield,
		items_per_rarity = {}
	},
	we_dual_wield_sword_dagger = {
		default = "deus_we_dual_wield_sword_dagger",
		slot_type = "melee",
		can_wield = ItemMasterList.we_dual_wield_sword_dagger.can_wield,
		items_per_rarity = {}
	},
	we_spear = {
		default = "deus_we_spear",
		slot_type = "melee",
		can_wield = ItemMasterList.we_spear.can_wield,
		items_per_rarity = {}
	},
	we_longbow = {
		default = "deus_we_longbow",
		slot_type = "ranged",
		can_wield = ItemMasterList.we_longbow.can_wield,
		items_per_rarity = {}
	},
	we_shortbow_hagbane = {
		default = "deus_we_shortbow_hagbane",
		slot_type = "ranged",
		can_wield = ItemMasterList.we_shortbow_hagbane.can_wield,
		items_per_rarity = {}
	},
	es_1h_mace = {
		default = "deus_es_1h_mace",
		slot_type = "melee",
		can_wield = ItemMasterList.es_1h_mace.can_wield,
		items_per_rarity = {}
	},
	es_halberd = {
		default = "deus_es_halberd",
		slot_type = "melee",
		can_wield = ItemMasterList.es_halberd.can_wield,
		items_per_rarity = {}
	},
	es_handgun = {
		default = "deus_es_handgun",
		slot_type = "ranged",
		can_wield = ItemMasterList.es_handgun.can_wield,
		items_per_rarity = {}
	},
	wh_crossbow_repeater = {
		default = "deus_wh_crossbow_repeater",
		slot_type = "ranged",
		can_wield = ItemMasterList.wh_crossbow_repeater.can_wield,
		items_per_rarity = {}
	},
	dr_1h_hammer = {
		default = "deus_dr_1h_hammer",
		slot_type = "melee",
		can_wield = ItemMasterList.dr_1h_hammer.can_wield,
		items_per_rarity = {}
	},
	dr_2h_hammer = {
		default = "deus_dr_2h_hammer",
		slot_type = "melee",
		can_wield = ItemMasterList.dr_2h_hammer.can_wield,
		items_per_rarity = {}
	},
	dr_2h_pick = {
		default = "deus_dr_2h_pick",
		slot_type = "melee",
		can_wield = ItemMasterList.dr_2h_pick.can_wield,
		items_per_rarity = {}
	},
	dr_drakegun = {
		default = "deus_dr_drakegun",
		slot_type = "ranged",
		can_wield = ItemMasterList.dr_drakegun.can_wield,
		items_per_rarity = {}
	},
	dr_rakegun = {
		default = "deus_dr_rakegun",
		slot_type = "ranged",
		can_wield = ItemMasterList.dr_rakegun.can_wield,
		items_per_rarity = {}
	},
	dr_handgun = {
		default = "deus_dr_handgun",
		slot_type = "ranged",
		can_wield = ItemMasterList.dr_handgun.can_wield,
		items_per_rarity = {}
	},
	dr_1h_throwing_axes = {
		default = "deus_dr_1h_throwing_axes",
		slot_type = "ranged",
		can_wield = ItemMasterList.dr_1h_throwing_axes.can_wield,
		items_per_rarity = {}
	},
	dr_dual_wield_hammers = {
		default = "deus_dr_dual_wield_hammers",
		slot_type = "melee",
		can_wield = ItemMasterList.dr_dual_wield_hammers.can_wield,
		items_per_rarity = {}
	},
	we_dual_wield_swords = {
		default = "deus_we_dual_wield_swords",
		slot_type = "melee",
		can_wield = ItemMasterList.we_dual_wield_swords.can_wield,
		items_per_rarity = {}
	},
	we_2h_sword = {
		default = "deus_we_2h_sword",
		slot_type = "melee",
		can_wield = ItemMasterList.we_2h_sword.can_wield,
		items_per_rarity = {}
	},
	we_1h_spears_shield = {
		default = "deus_we_1h_spears_shield",
		slot_type = "melee",
		can_wield = ItemMasterList.we_1h_spears_shield.can_wield,
		items_per_rarity = {}
	},
	we_crossbow_repeater = {
		default = "deus_we_crossbow_repeater",
		slot_type = "ranged",
		can_wield = ItemMasterList.we_crossbow_repeater.can_wield,
		items_per_rarity = {}
	},
	es_2h_sword_executioner = {
		default = "deus_es_2h_sword_executioner",
		slot_type = "melee",
		can_wield = ItemMasterList.es_2h_sword_executioner.can_wield,
		items_per_rarity = {}
	},
	es_mace_shield = {
		default = "deus_es_mace_shield",
		slot_type = "melee",
		can_wield = ItemMasterList.es_mace_shield.can_wield,
		items_per_rarity = {}
	},
	es_1h_sword = {
		default = "deus_es_1h_sword",
		slot_type = "melee",
		can_wield = ItemMasterList.es_1h_sword.can_wield,
		items_per_rarity = {}
	},
	es_2h_sword = {
		default = "deus_es_2h_sword",
		slot_type = "melee",
		can_wield = ItemMasterList.es_2h_sword.can_wield,
		items_per_rarity = {}
	},
	es_dual_wield_hammer_sword = {
		default = "deus_es_dual_wield_hammer_sword",
		slot_type = "melee",
		can_wield = ItemMasterList.es_dual_wield_hammer_sword.can_wield,
		items_per_rarity = {}
	},
	es_bastard_sword = {
		default = "deus_es_bastard_sword",
		slot_type = "melee",
		can_wield = ItemMasterList.es_bastard_sword.can_wield,
		items_per_rarity = {}
	},
	es_sword_shield_breton = {
		default = "deus_es_sword_shield_breton",
		slot_type = "melee",
		can_wield = ItemMasterList.es_sword_shield_breton.can_wield,
		items_per_rarity = {}
	},
	es_2h_heavy_spear = {
		default = "deus_es_2h_heavy_spear",
		slot_type = "melee",
		can_wield = ItemMasterList.es_2h_heavy_spear.can_wield,
		items_per_rarity = {}
	},
	es_deus_01 = {
		default = "deus_es_deus_01",
		slot_type = "melee",
		can_wield = ItemMasterList.es_deus_01.can_wield,
		items_per_rarity = {}
	},
	es_longbow = {
		default = "deus_es_longbow",
		slot_type = "ranged",
		can_wield = ItemMasterList.es_longbow.can_wield,
		items_per_rarity = {}
	},
	es_repeating_handgun = {
		default = "deus_es_repeating_handgun",
		slot_type = "ranged",
		can_wield = ItemMasterList.es_repeating_handgun.can_wield,
		items_per_rarity = {}
	},
	bw_dagger = {
		default = "deus_bw_dagger",
		slot_type = "melee",
		can_wield = ItemMasterList.bw_dagger.can_wield,
		items_per_rarity = {}
	},
	bw_1h_crowbill = {
		default = "deus_bw_1h_crowbill",
		slot_type = "melee",
		can_wield = ItemMasterList.bw_1h_crowbill.can_wield,
		items_per_rarity = {}
	},
	bw_1h_flail_flaming = {
		default = "deus_bw_1h_flail_flaming",
		slot_type = "melee",
		can_wield = ItemMasterList.bw_1h_flail_flaming.can_wield,
		items_per_rarity = {}
	},
	bw_skullstaff_beam = {
		default = "deus_bw_skullstaff_beam",
		slot_type = "ranged",
		can_wield = ItemMasterList.bw_skullstaff_beam.can_wield,
		items_per_rarity = {}
	},
	bw_skullstaff_flamethrower = {
		default = "deus_bw_skullstaff_flamethrower",
		slot_type = "ranged",
		can_wield = ItemMasterList.bw_skullstaff_flamethrower.can_wield,
		items_per_rarity = {}
	},
	dr_deus_01 = {
		default = "deus_dr_deus_01",
		slot_type = "ranged",
		can_wield = ItemMasterList.dr_deus_01.can_wield,
		items_per_rarity = {}
	},
	wh_deus_01 = {
		default = "deus_wh_deus_01",
		slot_type = "ranged",
		can_wield = ItemMasterList.wh_deus_01.can_wield,
		items_per_rarity = {}
	},
	bw_deus_01 = {
		default = "deus_bw_deus_01",
		slot_type = "ranged",
		can_wield = ItemMasterList.bw_deus_01.can_wield,
		items_per_rarity = {}
	},
	we_deus_01 = {
		default = "deus_we_deus_01",
		slot_type = "ranged",
		can_wield = ItemMasterList.we_deus_01.can_wield,
		items_per_rarity = {}
	},
	dr_2h_cog_hammer = {
		default = "deus_dr_2h_cog_hammer",
		slot_type = "melee",
		can_wield = ItemMasterList.dr_2h_cog_hammer.can_wield,
		items_per_rarity = {}
	},
	dr_steam_pistol = {
		default = "deus_dr_steam_pistol",
		slot_type = "ranged",
		can_wield = ItemMasterList.dr_steam_pistol.can_wield,
		items_per_rarity = {}
	},
	we_javelin = {
		default = "deus_we_javelin",
		slot_type = "ranged",
		can_wield = ItemMasterList.we_javelin.can_wield,
		items_per_rarity = {}
	},
	we_life_staff = {
		default = "deus_we_life_staff",
		slot_type = "ranged",
		can_wield = ItemMasterList.we_life_staff.can_wield,
		items_per_rarity = {}
	},
	wh_1h_hammer = {
		default = "deus_wh_1h_hammer",
		slot_type = "melee",
		can_wield = ItemMasterList.wh_1h_hammer.can_wield,
		items_per_rarity = {}
	},
	wh_2h_hammer = {
		default = "deus_wh_2h_hammer",
		slot_type = "melee",
		can_wield = ItemMasterList.wh_2h_hammer.can_wield,
		items_per_rarity = {}
	},
	wh_hammer_shield = {
		default = "deus_wh_hammer_shield",
		slot_type = "melee",
		can_wield = ItemMasterList.wh_hammer_shield.can_wield,
		items_per_rarity = {}
	},
	wh_flail_shield = {
		default = "deus_wh_flail_shield",
		slot_type = "melee",
		can_wield = ItemMasterList.wh_flail_shield.can_wield,
		items_per_rarity = {}
	},
	wh_dual_hammer = {
		default = "deus_wh_dual_hammer",
		slot_type = "melee",
		can_wield = ItemMasterList.wh_dual_hammer.can_wield,
		items_per_rarity = {}
	},
	wh_hammer_book = {
		default = "deus_wh_hammer_book",
		slot_type = "melee",
		can_wield = ItemMasterList.wh_hammer_book.can_wield,
		items_per_rarity = {}
	},
	bw_ghost_scythe = {
		default = "deus_bw_ghost_scythe",
		slot_type = "melee",
		can_wield = ItemMasterList.bw_ghost_scythe.can_wield,
		items_per_rarity = {}
	},
	bw_necromancy_staff = {
		default = "deus_bw_necromancy_staff",
		slot_type = "ranged",
		can_wield = ItemMasterList.bw_necromancy_staff.can_wield,
		items_per_rarity = {}
	}
}
DeusWeaponGroups = DeusWeaponGroups

local DeusWeaponArchetypes = DeusWeaponArchetypes

DeusWeaponArchetypes = DeusWeaponArchetypes or {
	attack_speed_on_crit = {
		traits = {
			"melee_attack_speed_on_crit"
		},
		properties = {
			crit_chance = 1,
			attack_speed = 1
		}
	},
	booster_crit = {
		traits = {
			"melee_attack_speed_on_crit",
			"melee_reduce_cooldown_on_crit"
		},
		properties = {
			crit_chance = 1
		}
	},
	armor_eater = {
		traits = {
			"armor_breaker"
		},
		properties = {
			power_vs_armoured = 1,
			power_vs_chaos = 1
		}
	},
	heal_on_crit = {
		traits = {
			"melee_heal_on_crit"
		},
		properties = {
			crit_chance = 1,
			attack_speed = 1
		}
	},
	counter = {
		traits = {
			"melee_increase_damage_on_block"
		},
		properties = {
			crit_chance = 1,
			power_vs_armoured = 1
		}
	},
	ultimate_spam = {
		traits = {
			"melee_reduce_cooldown_on_crit"
		},
		properties = {
			crit_chance = 1,
			attack_speed = 1
		}
	},
	savior = {
		traits = {
			"melee_shield_on_assist"
		},
		properties = {
			push_block_arc = 1,
			stamina = 1,
			block_cost = 1
		}
	},
	tank = {
		properties = {
			push_block_arc = 1,
			stamina = 1,
			block_cost = 1
		}
	},
	shockwave = {
		traits = {
			"stagger_aoe_on_crit"
		},
		properties = {
			crit_chance = 1,
			power_vs_unarmoured = 1
		}
	},
	anti_skaven = {
		properties = {
			power_vs_armoured = 1,
			power_vs_frenzy = 1,
			power_vs_skaven = 1
		}
	},
	anti_chaos = {
		properties = {
			power_vs_unarmoured = 1,
			power_vs_frenzy = 1,
			power_vs_chaos = 1
		}
	},
	stockpile = {
		properties = {
			stockpile = 1
		}
	},
	ranged_hunter = {
		traits = {
			"ranged_reduce_cooldown_on_crit",
			"ranged_increase_power_level_vs_armour_crit"
		},
		properties = {
			crit_chance = 1,
			power_vs_chaos = 1
		}
	},
	ranged_support = {
		traits = {
			"ranged_restore_stamina_headshot",
			"ranged_replenish_ammo_headshot"
		},
		properties = {
			crit_chance = 1
		}
	},
	ranged_ultimate_spam = {
		traits = {
			"ranged_reduce_cooldown_on_crit"
		},
		properties = {
			crit_chance = 1,
			power_vs_frenzy = 1
		}
	},
	anti_boss = {
		properties = {
			power_vs_large = 1,
			power_vs_skaven = 1,
			power_vs_chaos = 1
		}
	},
	anti_horde = {
		properties = {
			crit_boost = 1,
			crit_chance = 1,
			power_vs_unarmoured = 1
		}
	},
	double_tap = {
		traits = {
			"ranged_consecutive_hits_increase_power",
			"ranged_replenish_ammo_headshot"
		}
	},
	scrounger = {
		traits = {
			"ranged_replenish_ammo_on_crit",
			"ranged_replenish_ammo_headshot"
		},
		properties = {
			crit_chance = 1
		}
	},
	thermic_inertia = {
		traits = {
			"ranged_reduced_overcharge"
		},
		properties = {
			power_vs_frenzy = 1,
			power_vs_armoured = 1
		}
	},
	heat_dissipator = {
		traits = {
			"ranged_remove_overcharge_on_crit"
		},
		properties = {
			crit_chance = 1,
			power_vs_large = 1
		}
	}
}
DeusWeaponArchetypes = DeusWeaponArchetypes

local DeusSlotChance = DeusSlotChance

DeusSlotChance = DeusSlotChance or {
	ranged = 40,
	slot_chance_multiplier = 3,
	melee = 60
}
DeusSlotChance = DeusSlotChance

local DeusDropRarityWeights = DeusDropRarityWeights

DeusDropRarityWeights = DeusDropRarityWeights or {
	default = {
		plentiful = {
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0
		},
		common = {
			70,
			30,
			30,
			0,
			0,
			0,
			0,
			0
		},
		rare = {
			0,
			70,
			70,
			15,
			0,
			0,
			0,
			0
		},
		exotic = {
			0,
			0,
			0,
			70,
			30,
			30,
			0,
			0
		},
		unique = {
			0,
			0,
			0,
			15,
			70,
			70,
			100,
			100
		}
	}
}
DeusDropRarityWeights = DeusDropRarityWeights

local DeusStarterWeaponPowerLevels = DeusStarterWeaponPowerLevels

DeusStarterWeaponPowerLevels = DeusStarterWeaponPowerLevels or {
	harder = 450,
	hard = 250,
	default = 50,
	hardest = 450,
	cataclysm = 450,
	normal = 200
}
DeusStarterWeaponPowerLevels = DeusStarterWeaponPowerLevels

local DeusDropPowerlevelRanges = DeusDropPowerlevelRanges

DeusDropPowerlevelRanges = DeusDropPowerlevelRanges or {
	default = {
		plentiful = {
			50,
			50
		},
		common = {
			100,
			100
		},
		rare = {
			150,
			150
		},
		exotic = {
			200,
			200
		},
		unique = {
			300,
			300
		}
	},
	normal = {
		plentiful = {
			200,
			200
		},
		common = {
			250,
			250
		},
		rare = {
			300,
			300
		},
		exotic = {
			350,
			350
		},
		unique = {
			450,
			450
		}
	},
	hard = {
		plentiful = {
			250,
			250
		},
		common = {
			300,
			300
		},
		rare = {
			350,
			350
		},
		exotic = {
			400,
			400
		},
		unique = {
			500,
			500
		}
	},
	harder = {
		plentiful = {
			450,
			450
		},
		common = {
			500,
			500
		},
		rare = {
			550,
			550
		},
		exotic = {
			600,
			600
		},
		unique = {
			700,
			700
		}
	},
	hardest = {
		plentiful = {
			450,
			450
		},
		common = {
			500,
			500
		},
		rare = {
			550,
			550
		},
		exotic = {
			600,
			600
		},
		unique = {
			700,
			700
		}
	},
	cataclysm = {
		plentiful = {
			450,
			450
		},
		common = {
			500,
			500
		},
		rare = {
			550,
			550
		},
		exotic = {
			600,
			600
		},
		unique = {
			700,
			700
		}
	}
}
DeusDropPowerlevelRanges = DeusDropPowerlevelRanges

for k, v in pairs(DeusWeapons) do
	local var_0_11 = ItemMasterList[v.base_item]
	local str = "property_table_name"
	local property_table_name = v.property_table_name

	if not property_table_name then
		property_table_name = tbl[var_0_11.property_table_name]
		property_table_name = property_table_name or var_0_11.property_table_name
	end

	v[str] = property_table_name

	local str_2 = "trait_table_name"
	local trait_table_name = v.trait_table_name

	if not trait_table_name then
		trait_table_name = tbl_2[var_0_11.trait_table_name]
		trait_table_name = trait_table_name or var_0_11.trait_table_name
	end

	v[str_2] = trait_table_name

	local var_0_16 = WeaponTraits.combinations[v.trait_table_name]
	local tbl_3 = {}

	for i, v_2 in ipairs(var_0_16) do
		local flag = true

		for i_2, v_3 in ipairs(v_2) do
			local var_0_19 = WeaponTraits.traits[v_3]

			flag = not flag and not var_0_19.compatible_weapon_list and var_0_19.compatible_weapon_list[v.base_item]
		end

		if not flag then
			tbl_3[#tbl_3 + 1] = v_2
		end
	end

	v.baked_trait_combinations = tbl_3
end

fassert(DeusStarterWeaponPowerLevels.default, "DeusStarterWeaponPowerLevels must define a default config")

local tbl_4 = {
	"plentiful",
	"common",
	"rare",
	"exotic",
	"unique"
}

fassert(DeusDropRarityWeights.default, "DeusDropRarityWeights must define a default config")

for k_2, v_4 in pairs(DeusDropRarityWeights) do
	for i_3, v_5 in ipairs(tbl_4) do
		fassert(v_4[v_5], "DeusDropRarityWeights must contains config for '" .. v_5 .. "'")
	end

	local var_0_21

	for k_3, v_6 in pairs(v_4) do
		fassert(not var_0_21 and #v_6 == var_0_21, "DeusDropRarityWeights weights must all have the same ammount, '" .. k_3 .. "' has a different weight count")

		var_0_21 = #v_6
	end
end

fassert(DeusDropPowerlevelRanges.default, "DeusDropPowerlevelRanges must define a default config")

for k_4, v_7 in pairs(DeusDropPowerlevelRanges) do
	for i_4, v_8 in ipairs(tbl_4) do
		fassert(v_7[v_8], "DeusDropPowerlevelRanges must contains config for '" .. v_8 .. "'")
	end

	for k_5, v_9 in pairs(v_7) do
		fassert(#v_9 == 2, "DeusDropPowerlevelRanges weights must define only 2 values, a min and a max, '" .. k_5 .. "' has a different weight count")
	end
end

for k_6, v_10 in pairs(DeusWeapons) do
	fassert(v_10.base_item, "DeusWeapon " .. k_6 .. " must provide a base_item.")
	fassert(ItemMasterList[v_10.base_item], "DeusWeapon " .. k_6 .. " must provide a base_item that exists in the base game ItemMasterList.")

	if not v_10.archetypes then
		fassert(not v_10.fixed_traits, "DeusWeapons item " .. k_6 .. " provides fixed traits and archetypes. Provide only one or the other.")
		fassert(not v_10.fixed_properties, "DeusWeapons item " .. k_6 .. " provides fixed properties and archetypes. Provide only one or the other.")

		for i_5, v_11 in ipairs(v_10.archetypes) do
			fassert(DeusWeaponArchetypes[v_11], "DeusWeapons item " .. k_6 .. " deus_archetype " .. v_11 .. " is not defined in DeusWeaponArchetypes")
		end
	end
end

for k_7, v_12 in pairs(DeusWeaponGroups) do
	fassert(v_12.default, "DeusWeaponGroup " .. k_7 .. " needs to have a default item defined")
	fassert(DeusWeapons[v_12.default], "DeusWeaponGroup " .. k_7 .. " default item not found in DeusWeapons")
	fassert(v_12.can_wield, "DeusWeaponGroup " .. k_7 .. " needs to have can_wield defined")
	fassert(v_12.slot_type, "DeusWeaponGroup " .. k_7 .. " needs to have slot_type defined")

	if not v_12.items_per_rarity then
		for k_8, v_13 in pairs(v_12.items_per_rarity) do
			for i_6, v_14 in ipairs(v_13) do
				local var_0_22 = DeusWeapons[v_14]

				fassert(var_0_22, "DeusWeaponGroup " .. k_7 .. " item " .. v_14 .. " not found in DeusWeapons")

				local var_0_23 = ItemMasterList[var_0_22.base_item]

				table.sort(var_0_23.can_wield)
				table.sort(v_12.can_wield)
				fassert(table.compare(var_0_23.can_wield, v_12.can_wield), "DeusWeaponGroup " .. k_7 .. " " .. table.tostring(var_0_23.can_wield) .. " item " .. v_14 .. " " .. table.tostring(v_12.can_wield) .. " has mismatching can_wield")
			end
		end
	end
end

local function fn(arg_1_0)
	-- function 1
	return setmetatable(arg_1_0, {
		__newindex = function (arg_2_0, arg_2_1, arg_2_2)
			-- function 2
			error("Trying to modify read only table. (debug only assert)")
		end
	})
end

fn(DeusDefaultLoadout)
fn(DeusDropPowerlevelRanges)
fn(DeusDropRarityWeights)
fn(DeusSlotChance)
fn(DeusStarterWeaponPowerLevels)
fn(DeusStartingWeaponTypeMapping)
fn(DeusWeaponArchetypes)
fn(DeusWeaponGroups)
fn(DeusWeapons)
