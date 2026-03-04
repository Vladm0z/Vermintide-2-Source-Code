-- chunkname: @scripts/settings/patrol_formation_settings.lua

require("scripts/settings/difficulty_settings")

local var_0_0 = ""

PatrolFormationSettings = PatrolFormationSettings or {}
PatrolFormationSettings.default_settings = {
	sounds = {},
	offsets = {
		ANCHOR_OFFSET = {
			x = 1.4,
			y = 0.6
		}
	},
	speeds = {
		FAST_WALK_SPEED = 2.6,
		MEDIUM_WALK_SPEED = 2.35,
		WALK_SPEED = 2.12,
		SPLINE_SPEED = 2.22,
		SLOW_SPLINE_SPEED = 0.1
	}
}
PatrolFormationSettings.default_marauder_settings = {
	sounds = {
		PLAYER_SPOTTED = "chaos_marauder_patrol_player_spotted",
		FORMING = "chaos_marauder_patrol_forming",
		FOLEY = "chaos_marauder_patrol_foley",
		FORMATED = "chaos_marauder_patrol_formated",
		FORMATE = "chaos_marauder_patrol_formate",
		CHARGE = "chaos_marauder_patrol_charge",
		VOICE = "chaos_marauder_patrol_voice"
	},
	offsets = PatrolFormationSettings.default_settings.offsets,
	speeds = {
		FAST_WALK_SPEED = 2.6,
		MEDIUM_WALK_SPEED = 2.35,
		WALK_SPEED = 2.12,
		SPLINE_SPEED = 2.22,
		SLOW_SPLINE_SPEED = 0.1
	}
}
PatrolFormationSettings.chaos_warrior_default = {
	settings = PatrolFormationSettings.default_marauder_settings,
	normal = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_raider"
		},
		{
			"chaos_raider"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	hard = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_raider",
			"chaos_raider"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	harder = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_raider",
			"chaos_raider"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	hardest = {
		{
			"chaos_raider"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_raider",
			"chaos_raider"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	cataclysm = {
		{
			"chaos_raider"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_raider",
			"chaos_raider"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_raider",
			"chaos_raider"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		}
	}
}
PatrolFormationSettings.chaos_bulwark_default = {
	settings = PatrolFormationSettings.default_marauder_settings,
	normal = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_raider"
		},
		{
			"chaos_raider"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_bulwark"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	hard = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_bulwark"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_raider",
			"chaos_raider"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_bulwark"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	harder = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_raider",
			"chaos_raider"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	hardest = {
		{
			"chaos_raider"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_raider",
			"chaos_raider"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	cataclysm = {
		{
			"chaos_raider"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_raider",
			"chaos_raider"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_raider",
			"chaos_raider"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		}
	}
}
PatrolFormationSettings.chaos_bulwark = {
	normal = {
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		}
	},
	hard = {
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		}
	},
	harder = {
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		}
	},
	hardest = {
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		},
		{
			"chaos_bulwark",
			"chaos_bulwark"
		}
	}
}
PatrolFormationSettings.storm_vermin_two_column = {
	settings = {
		extra_breed_name = "skaven_storm_vermin_with_shield",
		use_controlled_advance = true,
		sounds = {
			PLAYER_SPOTTED = "storm_vermin_patrol_player_spotted",
			FORMING = "Play_stormvermin_patrol_forming",
			FOLEY = "Play_stormvermin_patrol_foley",
			FORMATED = "Play_stormvemin_patrol_formated",
			FOLEY_EXTRA = "Play_stormvermin_patrol_shield_foley",
			FORMATE = "storm_vermin_patrol_formate",
			CHARGE = "storm_vermin_patrol_charge",
			VOICE = "Play_stormvermin_patrol_voice"
		},
		offsets = PatrolFormationSettings.default_settings.offsets,
		speeds = PatrolFormationSettings.default_settings.speeds
	},
	normal = {
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_clan_rat",
			"skaven_clan_rat"
		},
		{
			"skaven_clan_rat",
			"skaven_clan_rat"
		},
		{
			"skaven_clan_rat",
			"skaven_clan_rat"
		}
	},
	hard = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		}
	},
	harder = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		}
	},
	hardest = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		}
	},
	cataclysm = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		}
	}
}
PatrolFormationSettings.storm_vermin_shields_infront = {
	settings = {
		extra_breed_name = "skaven_storm_vermin_with_shield",
		use_controlled_advance = true,
		sounds = {
			PLAYER_SPOTTED = "storm_vermin_patrol_player_spotted",
			FORMING = "Play_stormvermin_patrol_forming",
			FOLEY = "Play_stormvermin_patrol_foley",
			FORMATED = "Play_stormvemin_patrol_formated",
			FOLEY_EXTRA = "Play_stormvermin_patrol_shield_foley",
			FORMATE = "storm_vermin_patrol_formate",
			CHARGE = "storm_vermin_patrol_charge",
			VOICE = "Play_stormvermin_patrol_voice"
		},
		offsets = PatrolFormationSettings.default_settings.offsets,
		speeds = PatrolFormationSettings.default_settings.speeds
	},
	normal = {
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_clan_rat",
			"skaven_clan_rat",
			"skaven_clan_rat",
			"skaven_clan_rat"
		}
	},
	hard = {
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		}
	},
	harder = {
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			var_0_0,
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			var_0_0
		}
	},
	hardest = {
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		}
	},
	cataclysm = {
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		}
	}
}
PatrolFormationSettings.offset = {
	settings = {
		extra_breed_name = "skaven_storm_vermin_with_shield",
		sounds = {
			PLAYER_SPOTTED = "storm_vermin_patrol_player_spotted",
			FORMING = "Play_stormvermin_patrol_forming",
			FOLEY = "Play_stormvermin_patrol_foley",
			FORMATED = "Play_stormvemin_patrol_formated",
			FOLEY_EXTRA = "Play_stormvermin_patrol_shield_foley",
			FORMATE = "storm_vermin_patrol_formate",
			CHARGE = "storm_vermin_patrol_charge",
			VOICE = "Play_stormvermin_patrol_voice"
		},
		offsets = PatrolFormationSettings.default_settings.offsets,
		speeds = PatrolFormationSettings.default_settings.speeds
	},
	normal = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin"
		}
	},
	hard = {
		{
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		}
	},
	harder = {
		{
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		}
	},
	hardest = {
		{
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		}
	}
}
PatrolFormationSettings.single = {
	settings = {
		extra_breed_name = "skaven_storm_vermin_with_shield",
		sounds = {
			PLAYER_SPOTTED = "storm_vermin_patrol_player_spotted",
			FORMING = "Play_stormvermin_patrol_forming",
			FOLEY = "Play_stormvermin_patrol_foley",
			FORMATED = "Play_stormvemin_patrol_formated",
			FOLEY_EXTRA = "Play_stormvermin_patrol_shield_foley",
			FORMATE = "storm_vermin_patrol_formate",
			CHARGE = "storm_vermin_patrol_charge",
			VOICE = "Play_stormvermin_patrol_voice"
		},
		offsets = PatrolFormationSettings.default_settings.offsets,
		speeds = PatrolFormationSettings.default_settings.speeds
	},
	normal = {
		{
			"skaven_storm_vermin"
		}
	},
	hard = {
		{
			"skaven_storm_vermin"
		}
	},
	harder = {
		{
			"skaven_storm_vermin"
		}
	},
	hardest = {
		{
			"skaven_storm_vermin"
		}
	}
}
PatrolFormationSettings.one_chaos_troll = {
	normal = {
		{
			"chaos_troll"
		}
	},
	hard = {
		{
			"chaos_troll"
		}
	},
	harder = {
		{
			"chaos_troll"
		}
	},
	hardest = {
		{
			"chaos_troll"
		}
	}
}
PatrolFormationSettings.escorted_troll = {
	settings = {
		sounds = {
			PLAYER_SPOTTED = "chaos_marauder_patrol_player_spotted",
			FORMING = "chaos_marauder_patrol_forming",
			FOLEY = "chaos_marauder_patrol_foley",
			FORMATED = "chaos_marauder_patrol_formated",
			FORMATE = "chaos_marauder_patrol_formate",
			CHARGE = "chaos_marauder_patrol_charge",
			VOICE = "chaos_marauder_patrol_voice"
		},
		offsets = PatrolFormationSettings.default_settings.offsets,
		speeds = PatrolFormationSettings.default_marauder_settings.speeds
	},
	normal = {
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			var_0_0,
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			"chaos_troll",
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			var_0_0,
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	hard = {
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			var_0_0,
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			"chaos_troll",
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			var_0_0,
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	harder = {
		{
			"chaos_marauder",
			"chaos_warrior",
			"chaos_marauder",
			"chaos_warrior",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			var_0_0,
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			"chaos_troll",
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			var_0_0,
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	hardest = {
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			var_0_0,
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			"chaos_troll",
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			var_0_0,
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			var_0_0,
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			"chaos_troll",
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			var_0_0,
			var_0_0,
			var_0_0,
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		}
	}
}
PatrolFormationSettings.escorted_rat_ogre = {
	settings = {
		sounds = {
			PLAYER_SPOTTED = "chaos_marauder_patrol_player_spotted",
			FORMING = "chaos_marauder_patrol_forming",
			FOLEY = "chaos_marauder_patrol_foley",
			FORMATED = "chaos_marauder_patrol_formated",
			FORMATE = "chaos_marauder_patrol_formate",
			CHARGE = "chaos_marauder_patrol_charge",
			VOICE = "chaos_marauder_patrol_voice"
		},
		offsets = PatrolFormationSettings.default_settings.offsets,
		speeds = PatrolFormationSettings.default_marauder_settings.speeds
	},
	normal = {
		{
			"skaven_pack_master",
			"skaven_pack_master"
		},
		{
			"skaven_rat_ogre"
		},
		{
			"skaven_pack_master",
			"skaven_pack_master"
		}
	},
	hard = {
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_pack_master",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			var_0_0,
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		},
		{
			"skaven_pack_master",
			var_0_0,
			"skaven_rat_ogre",
			var_0_0,
			"skaven_pack_master"
		},
		{
			"skaven_storm_vermin",
			var_0_0,
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_pack_master",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		}
	},
	harder = {
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_pack_master",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			var_0_0,
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		},
		{
			"skaven_pack_master",
			var_0_0,
			"skaven_rat_ogre",
			var_0_0,
			"skaven_pack_master"
		},
		{
			"skaven_storm_vermin",
			var_0_0,
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_pack_master",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		}
	},
	hardest = {
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_pack_master",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			var_0_0,
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			var_0_0,
			"skaven_rat_ogre",
			var_0_0,
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			var_0_0,
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		},
		{
			"skaven_pack_master",
			"skaven_storm_vermin",
			"skaven_pack_master",
			"skaven_storm_vermin",
			"skaven_pack_master"
		},
		{
			"skaven_storm_vermin",
			var_0_0,
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			var_0_0,
			"skaven_rat_ogre",
			var_0_0,
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			var_0_0,
			var_0_0,
			var_0_0,
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_pack_master",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		}
	}
}
PatrolFormationSettings.broad_line = {
	settings = {
		extra_breed_name = "skaven_storm_vermin_with_shield",
		use_controlled_advance = true,
		sounds = {
			PLAYER_SPOTTED = "storm_vermin_patrol_player_spotted",
			FORMING = "Play_stormvermin_patrol_forming",
			FOLEY = "Play_stormvermin_patrol_foley",
			FORMATED = "Play_stormvemin_patrol_formated",
			FOLEY_EXTRA = "Play_stormvermin_patrol_shield_foley",
			FORMATE = "storm_vermin_patrol_formate",
			CHARGE = "storm_vermin_patrol_charge",
			VOICE = "Play_stormvermin_patrol_voice"
		},
		offsets = PatrolFormationSettings.default_settings.offsets,
		speeds = PatrolFormationSettings.default_settings.speeds
	},
	normal = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	hard = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	harder = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	hardest = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	}
}
PatrolFormationSettings.chaos_warrior = {
	normal = {
		{
			"chaos_warrior",
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior"
		}
	},
	hard = {
		{
			"chaos_warrior"
		}
	},
	harder = {
		{
			"chaos_warrior"
		}
	},
	hardest = {
		{
			"chaos_warrior"
		}
	}
}
PatrolFormationSettings.chaos_marauders = {
	settings = PatrolFormationSettings.default_marauder_settings,
	normal = {
		{
			"chaos_raider"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	hard = {
		{
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	harder = {
		{
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	hardest = {
		{
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		}
	}
}
PatrolFormationSettings.one_marauder = {
	settings = PatrolFormationSettings.default_marauder_settings,
	normal = {
		{
			"chaos_marauder"
		}
	},
	hard = {
		{
			"chaos_marauder"
		}
	},
	harder = {
		{
			"chaos_marauder"
		}
	},
	hardest = {
		{
			"chaos_marauder"
		}
	}
}
PatrolFormationSettings.one_chaos_warrior = {
	normal = {
		{
			"chaos_warrior"
		}
	},
	hard = {
		{
			"chaos_warrior"
		}
	},
	harder = {
		{
			"chaos_warrior"
		}
	},
	hardest = {
		{
			"chaos_warrior"
		}
	}
}
PatrolFormationSettings.massive = {
	settings = {
		extra_breed_name = "skaven_storm_vermin_with_shield",
		use_controlled_advance = true,
		sounds = {
			PLAYER_SPOTTED = "storm_vermin_patrol_player_spotted",
			FORMING = "Play_stormvermin_patrol_forming",
			FOLEY = "Play_stormvermin_patrol_foley",
			FORMATED = "Play_stormvemin_patrol_formated",
			FOLEY_EXTRA = "Play_stormvermin_patrol_shield_foley",
			FORMATE = "storm_vermin_patrol_formate",
			CHARGE = "storm_vermin_patrol_charge",
			VOICE = "Play_stormvermin_patrol_voice"
		},
		offsets = PatrolFormationSettings.default_settings.offsets,
		speeds = PatrolFormationSettings.default_settings.speeds
	},
	normal = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		}
	},
	hard = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		}
	},
	harder = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		}
	},
	hardest = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		}
	}
}
PatrolFormationSettings.fatshark = {
	settings = {
		use_controlled_advance = true,
		sounds = {
			PLAYER_SPOTTED = "storm_vermin_patrol_player_spotted",
			FORMING = "Play_stormvermin_patrol_forming",
			FOLEY = "Play_stormvermin_patrol_foley",
			FORMATED = "Play_stormvemin_patrol_formated",
			FORMATE = "storm_vermin_patrol_formate",
			CHARGE = "storm_vermin_patrol_charge",
			VOICE = "Play_stormvermin_patrol_voice"
		},
		offsets = PatrolFormationSettings.default_settings.offsets,
		speeds = PatrolFormationSettings.default_settings.speeds
	},
	normal = {
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"                   ",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"                   ",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"                   ",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"                   ",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"                   ",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"                   ",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"                   ",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"                   ",
			"                   "
		},
		{
			"                   ",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"                   ",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   "
		},
		{
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   "
		},
		{
			"                   ",
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   ",
			"skaven_storm_vermin",
			"                   "
		},
		{
			"skaven_storm_vermin",
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"                   ",
			"skaven_storm_vermin"
		}
	}
}
PatrolFormationSettings.roaming_size_9 = {
	{
		""
	},
	{
		"",
		""
	},
	{
		"",
		"",
		""
	},
	{
		"",
		""
	},
	{
		""
	}
}
PatrolFormationSettings.roaming_size_16 = {
	{
		""
	},
	{
		"",
		""
	},
	{
		"",
		"",
		""
	},
	{
		"",
		"",
		"",
		""
	},
	{
		"",
		"",
		""
	},
	{
		"",
		""
	},
	{
		""
	}
}
PatrolFormationSettings.roaming_size_25 = {
	{
		""
	},
	{
		"",
		""
	},
	{
		"",
		"",
		""
	},
	{
		"",
		"",
		"",
		""
	},
	{
		"",
		"",
		"",
		"",
		""
	},
	{
		"",
		"",
		"",
		""
	},
	{
		"",
		"",
		""
	},
	{
		"",
		""
	},
	{
		""
	}
}
PatrolFormationSettings.small_stormvermins = {
	settings = {
		extra_breed_name = "skaven_storm_vermin_with_shield",
		use_controlled_advance = true,
		sounds = {
			PLAYER_SPOTTED = "storm_vermin_patrol_player_spotted",
			FORMING = "Play_stormvermin_patrol_forming",
			FOLEY = "Play_stormvermin_patrol_foley",
			FORMATED = "Play_stormvemin_patrol_formated",
			FOLEY_EXTRA = "Play_stormvermin_patrol_shield_foley",
			FORMATE = "storm_vermin_patrol_formate",
			CHARGE = "storm_vermin_patrol_charge",
			VOICE = "Play_stormvermin_patrol_voice"
		},
		offsets = PatrolFormationSettings.default_settings.offsets,
		speeds = PatrolFormationSettings.default_settings.speeds
	},
	normal = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	hard = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	harder = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	hardest = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	cataclysm = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	}
}
PatrolFormationSettings.small_stormvermins_long = {
	settings = {
		extra_breed_name = "skaven_storm_vermin_with_shield",
		use_controlled_advance = true,
		sounds = {
			PLAYER_SPOTTED = "storm_vermin_patrol_player_spotted",
			FORMING = "Play_stormvermin_patrol_forming",
			FOLEY = "Play_stormvermin_patrol_foley",
			FORMATED = "Play_stormvemin_patrol_formated",
			FOLEY_EXTRA = "Play_stormvermin_patrol_shield_foley",
			FORMATE = "storm_vermin_patrol_formate",
			CHARGE = "storm_vermin_patrol_charge",
			VOICE = "Play_stormvermin_patrol_voice"
		},
		offsets = PatrolFormationSettings.default_settings.offsets,
		speeds = PatrolFormationSettings.default_settings.speeds
	},
	normal = {
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield"
		}
	},
	hard = {
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield"
		}
	},
	harder = {
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield"
		}
	},
	hardest = {
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield"
		}
	},
	cataclysm = {
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield"
		}
	}
}
PatrolFormationSettings.medium_stormvermins = {
	settings = {
		extra_breed_name = "skaven_storm_vermin_with_shield",
		use_controlled_advance = true,
		sounds = {
			PLAYER_SPOTTED = "storm_vermin_patrol_player_spotted",
			FORMING = "Play_stormvermin_patrol_forming",
			FOLEY = "Play_stormvermin_patrol_foley",
			FORMATED = "Play_stormvemin_patrol_formated",
			FOLEY_EXTRA = "Play_stormvermin_patrol_shield_foley",
			FORMATE = "storm_vermin_patrol_formate",
			CHARGE = "storm_vermin_patrol_charge",
			VOICE = "Play_stormvermin_patrol_voice"
		},
		offsets = PatrolFormationSettings.default_settings.offsets,
		speeds = PatrolFormationSettings.default_settings.speeds
	},
	normal = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	hard = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	harder = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	hardest = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	cataclysm = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	}
}
PatrolFormationSettings.medium_stormvermins_wide = {
	settings = {
		extra_breed_name = "skaven_storm_vermin_with_shield",
		use_controlled_advance = true,
		sounds = {
			PLAYER_SPOTTED = "storm_vermin_patrol_player_spotted",
			FORMING = "Play_stormvermin_patrol_forming",
			FOLEY = "Play_stormvermin_patrol_foley",
			FORMATED = "Play_stormvemin_patrol_formated",
			FOLEY_EXTRA = "Play_stormvermin_patrol_shield_foley",
			FORMATE = "storm_vermin_patrol_formate",
			CHARGE = "storm_vermin_patrol_charge",
			VOICE = "Play_stormvermin_patrol_voice"
		},
		offsets = PatrolFormationSettings.default_settings.offsets,
		speeds = PatrolFormationSettings.default_settings.speeds
	},
	normal = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	hard = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	harder = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	hardest = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	},
	cataclysm = {
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin",
			"skaven_storm_vermin",
			"skaven_storm_vermin"
		},
		{
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield",
			"skaven_storm_vermin_with_shield"
		}
	}
}
PatrolFormationSettings.double_dragon = {
	normal = {
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		}
	},
	hard = {
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		}
	},
	harder = {
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		}
	},
	hardest = {
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		}
	}
}

local var_0_1 = {
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	},
	{
		"skaven_slave",
		"skaven_slave",
		"skaven_slave"
	}
}

PatrolFormationSettings.skaven_slave_patrol = {
	settings = PatrolFormationSettings.default_settings,
	normal = var_0_1,
	hard = var_0_1,
	harder = var_0_1,
	hardest = var_0_1
}
PatrolFormationSettings.chaos_warrior_small = {
	settings = PatrolFormationSettings.default_marauder_settings,
	normal = {
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	hard = {
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	harder = {
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	hardest = {
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	cataclysm = {
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		}
	}
}
PatrolFormationSettings.chaos_warrior_long = {
	settings = PatrolFormationSettings.default_marauder_settings,
	normal = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	hard = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	harder = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	hardest = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	cataclysm = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	}
}
PatrolFormationSettings.chaos_warrior_wide = {
	settings = PatrolFormationSettings.default_marauder_settings,
	normal = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	hard = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	harder = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	hardest = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	cataclysm = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	}
}
PatrolFormationSettings.prologue_skittergate_patrol = {
	settings = PatrolFormationSettings.default_marauder_settings,
	normal = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	hard = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	harder = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	hardest = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	},
	cataclysm = {
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_warrior",
			"chaos_warrior"
		},
		{
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield",
			"chaos_marauder_with_shield"
		}
	}
}
PatrolFormationSettings.prologue_marauder = {
	settings = PatrolFormationSettings.default_marauder_settings,
	normal = {
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	hard = {
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	harder = {
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	hardest = {
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		}
	},
	cataclysm = {
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		},
		{
			"chaos_marauder",
			"chaos_marauder"
		}
	}
}

DLCUtils.merge("patrol_formation_settings", PatrolFormationSettings)
DLCUtils.merge("patrol_formations", PatrolFormationSettings)

PatrolFormationSettings.random_roaming_formation = function (arg_1_0)
	local var_1_0 = arg_1_0.members
	local var_1_1 = #var_1_0
	local var_1_2
	local var_1_3 = var_1_1 > 9 and "roaming_size_25" or var_1_1 > 4 and "roaming_size_16" or "roaming_size_9"
	local var_1_4 = table.clone(PatrolFormationSettings[var_1_3])

	var_1_4.speeds = {
		FAST_WALK_SPEED = 2,
		MEDIUM_WALK_SPEED = 1.9,
		WALK_SPEED = 1.8,
		SPLINE_SPEED = 1.8,
		SLOW_SPLINE_SPEED = 0.1
	}

	local var_1_5 = 0

	for iter_1_0, iter_1_1 in ipairs(var_1_4) do
		for iter_1_2, iter_1_3 in ipairs(iter_1_1) do
			var_1_5 = var_1_5 + 1
		end
	end

	local var_1_6 = var_1_5

	for iter_1_4, iter_1_5 in ipairs(var_1_0) do
		local var_1_7 = math.random(var_1_6)
		local var_1_8 = iter_1_5.name
		local var_1_9 = 0

		for iter_1_6, iter_1_7 in ipairs(var_1_4) do
			for iter_1_8, iter_1_9 in ipairs(iter_1_7) do
				if iter_1_9 == "" then
					var_1_9 = var_1_9 + 1

					if var_1_9 == var_1_7 then
						iter_1_7[iter_1_8] = var_1_8
						var_1_6 = var_1_6 - 1

						break
					end
				end
			end
		end
	end

	return var_1_4
end
