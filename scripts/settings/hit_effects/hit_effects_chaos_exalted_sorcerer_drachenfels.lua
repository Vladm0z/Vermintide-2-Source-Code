-- chunkname: @scripts/settings/hit_effects/hit_effects_chaos_exalted_sorcerer_drachenfels.lua

local var_0_0 = {
	"light_slashing_linesman",
	"slashing_linesman",
	"heavy_slashing_linesman",
	"light_slashing_tank",
	"slashing_tank",
	"heavy_slashing_tank",
	"light_blunt_linesman",
	"blunt_linesman",
	"heavy_blunt_linesman",
	"light_blunt_tank",
	"blunt_tank",
	"heavy_blunt_tank"
}
local var_0_1 = {
	"light_slashing_smiter",
	"slashing_smiter",
	"heavy_slashing_smiter",
	"light_blunt_smiter",
	"blunt_smiter",
	"heavy_blunt_smiter",
	"light_stab_smiter",
	"heavy_stab_smiter"
}
local var_0_2 = {
	"light_slashing_fencer",
	"slashing_fencer",
	"heavy_slashing_fencer",
	"light_stab_fencer",
	"stab_fencer",
	"heavy_stab_fencer",
	"light_blunt_fencer",
	"blunt_fencer",
	"heavy_blunt_fencer"
}
local var_0_3 = {
	"arrow_carbine",
	"elven_magic_arrow_carbine",
	"arrow_sniper",
	"arrow_machinegun",
	"shot_carbine",
	"shot_sniper",
	"shot_machinegun",
	"shot_shotgun"
}

HitEffectsChaosExaltedSorcererDrachenfels = {
	default = {
		husk_hit_effect_name = "fx/impact_blood_chaos",
		armour_type = "cloth",
		animations = {
			"hit_reaction"
		}
	},
	burn = {
		extra_conditions = {
			damage_type = "burn"
		}
	},
	default_death = {
		inherits = "default",
		extra_conditions = {
			death = true
		},
		animations = {
			"death_end_part_02"
		},
		push = {
			distal_force = 50,
			vertical_force = -20,
			lateral_force = 50
		}
	},
	linesman_tank_death = {
		inherits = "default",
		extra_conditions = {
			death = true,
			damage_type = var_0_0
		},
		animations = {
			"death_end_part_02"
		},
		push = {
			distal_force = 0,
			vertical_force = -5,
			lateral_force = 10
		}
	},
	smiter_death = {
		inherits = "default",
		extra_conditions = {
			death = true,
			damage_type = var_0_1
		},
		animations = {
			"death_end_part_02"
		},
		push = {
			distal_force = 0,
			vertical_force = -20,
			lateral_force = 0
		}
	},
	fencer_death = {
		inherits = "default",
		extra_conditions = {
			death = true,
			damage_type = var_0_2
		},
		animations = {
			"death_end_part_02"
		},
		push = {
			distal_force = 20,
			vertical_force = 10,
			lateral_force = 10
		}
	},
	ranged_death = {
		inherits = "default",
		extra_conditions = {
			death = true,
			damage_type = var_0_3
		},
		animations = {
			"death_end_part_02"
		},
		push = {
			distal_force = 25,
			vertical_force = 0,
			lateral_force = 0
		}
	},
	push = {
		extra_conditions = {
			damage_type = "push"
		}
	},
	forced_kill = {
		extra_conditions = {
			death = true,
			damage_type = "forced"
		},
		animations = {
			"death_end_part_02"
		}
	}
}
HitEffectsChaosExaltedSorcererDrachenfels = table.create_copy(HitEffectsChaosExaltedSorcererDrachenfels, HitEffectsChaosExaltedSorcererDrachenfels)
