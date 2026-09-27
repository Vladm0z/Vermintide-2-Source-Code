-- chunkname: @scripts/utils/debug_hero_templates.lua

DebugHeroTemplates = {}

local tbl = {
	prestige_level = 2,
	level = 5,
	items = {
		"dr_1h_axe_1001",
		"dr_2h_axe_1001",
		"dr_2h_hammer_1001",
		"dr_1h_hammer_1001",
		"dr_shield_axe_1001",
		"dr_shield_hammer_1001",
		"dr_crossbow_1001",
		"dr_rakegun_1001",
		"dr_handgun_1001",
		"dr_drake_pistol_1001",
		"dr_2h_pick_1001"
	},
	talents = {}
}
local tbl_2 = {
	prestige_level = 5,
	level = 15,
	items = {
		"dr_1h_axe_1001",
		"dr_2h_axe_1001",
		"dr_2h_hammer_1001",
		"dr_1h_hammer_1001",
		"dr_shield_axe_1001",
		"dr_shield_hammer_1001",
		"dr_crossbow_1001",
		"dr_rakegun_1001",
		"dr_handgun_1001",
		"dr_drake_pistol_1001",
		"dr_2h_pick_1001"
	},
	talents = {}
}
local tbl_3 = {
	prestige_level = 8,
	level = 30,
	items = {
		"dr_1h_axe_2001",
		"dr_2h_axe_2001",
		"dr_2h_hammer_2001",
		"dr_1h_hammer_2001",
		"dr_shield_axe_2001",
		"dr_shield_hammer_2001",
		"dr_crossbow_2001",
		"dr_rakegun_2001",
		"dr_handgun_2001",
		"dr_drake_pistol_2001",
		"dr_2h_pick_2001"
	},
	talents = {}
}

DebugHeroTemplates.dr_ironbreaker = table.clone(tbl)
DebugHeroTemplates.dr_slayer = table.clone(tbl_2)
DebugHeroTemplates.dr_ranger = table.clone(tbl_3)

local tbl_4 = {
	prestige_level = 2,
	level = 5,
	items = {
		"wh_1h_axe_1001",
		"wh_2h_sword_1001",
		"wh_fencing_sword_1001",
		"wh_brace_of_pistols_1001",
		"wh_repeating_pistols_1001",
		"wh_crossbow_1001",
		"wh_crossbow_repeater_1001",
		"wh_1h_falchion_1001"
	},
	talents = {}
}
local tbl_5 = {
	prestige_level = 5,
	level = 15,
	items = {
		"wh_1h_axe_1001",
		"wh_2h_sword_1001",
		"wh_fencing_sword_1001",
		"wh_brace_of_pistols_1001",
		"wh_repeating_pistols_1001",
		"wh_crossbow_1001",
		"wh_crossbow_repeater_1001",
		"wh_1h_falchion_1001"
	},
	talents = {}
}
local tbl_6 = {
	prestige_level = 8,
	level = 30,
	items = {
		"wh_1h_axe_2001",
		"wh_2h_sword_2001",
		"wh_fencing_sword_2001",
		"wh_brace_of_pistols_2001",
		"wh_repeating_pistols_2001",
		"wh_crossbow_2001",
		"wh_crossbow_repeater_2001",
		"wh_1h_falchion_2001"
	},
	talents = {}
}

DebugHeroTemplates.wh_zealot = table.clone(tbl_4)
DebugHeroTemplates.wh_bountyhunter = table.clone(tbl_5)
DebugHeroTemplates.wh_captain = table.clone(tbl_6)

local tbl_7 = {
	prestige_level = 2,
	level = 5,
	items = {
		"es_1h_sword_1001",
		"es_1h_mace_1001",
		"es_2h_sword_1001",
		"es_2h_hammer_1001",
		"es_sword_shield_1001",
		"es_mace_shield_1001",
		"es_1h_flail_1001",
		"es_halberd_1001",
		"es_blunderbuss_1001",
		"es_handgun_1001",
		"es_repeating_handgun_1001"
	},
	talents = {}
}
local tbl_8 = {
	prestige_level = 5,
	level = 15,
	items = {
		"es_1h_sword_1001",
		"es_1h_mace_1001",
		"es_2h_sword_1001",
		"es_2h_hammer_1001",
		"es_sword_shield_1001",
		"es_mace_shield_1001",
		"es_1h_flail_1001",
		"es_halberd_1001",
		"es_blunderbuss_1001",
		"es_handgun_1001",
		"es_repeating_handgun_1001",
		"es_1h_flail_0001"
	},
	talents = {}
}
local tbl_9 = {
	prestige_level = 8,
	level = 30,
	items = {
		"es_1h_sword_2001",
		"es_1h_mace_2001",
		"es_2h_sword_2001",
		"es_2h_hammer_2001",
		"es_sword_shield_2001",
		"es_mace_shield_2001",
		"es_1h_flail_2001",
		"es_halberd_2001",
		"es_blunderbuss_2001",
		"es_handgun_2001",
		"es_repeating_handgun_2001"
	},
	talents = {}
}

DebugHeroTemplates.es_poacher = table.clone(tbl_7)
DebugHeroTemplates.es_fullplate = table.clone(tbl_8)
DebugHeroTemplates.es_vanilla = table.clone(tbl_9)

local tbl_10 = {
	prestige_level = 2,
	level = 5,
	items = {
		"we_dual_wield_daggers_1001",
		"we_dual_wield_swords_1001",
		"we_1h_sword_1001",
		"we_dual_wield_sword_dagger_1001",
		"we_shortbow_1001",
		"we_shortbow_hagbane_1001",
		"we_longbow_1001",
		"we_longbow_trueflight_1001",
		"we_2h_axe_1001"
	},
	talents = {}
}
local tbl_11 = {
	prestige_level = 5,
	level = 15,
	items = {
		"we_dual_wield_daggers_1001",
		"we_dual_wield_swords_1001",
		"we_1h_sword_1001",
		"we_dual_wield_sword_dagger_1001",
		"we_shortbow_1001",
		"we_shortbow_hagbane_1001",
		"we_longbow_1001",
		"we_longbow_trueflight_1001",
		"we_2h_axe_1001"
	},
	talents = {}
}
local tbl_12 = {
	prestige_level = 8,
	level = 30,
	items = {
		"we_dual_wield_daggers_2001",
		"we_dual_wield_swords_2001",
		"we_1h_sword_2001",
		"we_dual_wield_sword_dagger_2001",
		"we_shortbow_2001",
		"we_shortbow_hagbane_2001",
		"we_longbow_2001",
		"we_longbow_trueflight_2001",
		"we_2h_axe_2001"
	},
	talents = {}
}

DebugHeroTemplates.we_shade = table.clone(tbl_10)
DebugHeroTemplates.we_maiden = table.clone(tbl_11)
DebugHeroTemplates.we_waywatcher = table.clone(tbl_12)

local tbl_13 = {
	prestige_level = 2,
	level = 5,
	items = {
		"bw_1h_mace_1001",
		"bw_flame_sword_1001",
		"bw_sword_1001",
		"bw_skullstaff_fireball_1001",
		"bw_skullstaff_beam_1001",
		"bw_skullstaff_geiser_1001",
		"bw_skullstaff_spear_1001"
	},
	talents = {}
}
local tbl_14 = {
	prestige_level = 5,
	level = 15,
	items = {
		"bw_1h_mace_1001",
		"bw_flame_sword_1001",
		"bw_sword_1001",
		"bw_skullstaff_fireball_1001",
		"bw_skullstaff_beam_1001",
		"bw_skullstaff_geiser_1001",
		"bw_skullstaff_spear_1001"
	},
	talents = {}
}
local tbl_15 = {
	prestige_level = 8,
	level = 30,
	items = {
		"bw_1h_mace_2001",
		"bw_flame_sword_2001",
		"bw_sword_2001",
		"bw_skullstaff_fireball_2001",
		"bw_skullstaff_beam_2001",
		"bw_skullstaff_geiser_2001",
		"bw_skullstaff_spear_2001"
	},
	talents = {}
}

DebugHeroTemplates.bw_sniper = table.clone(tbl_13)
DebugHeroTemplates.bw_boomer = table.clone(tbl_14)
DebugHeroTemplates.bw_melee = table.clone(tbl_15)

for k, v in pairs(DebugHeroTemplates) do
	v.name = k
end
