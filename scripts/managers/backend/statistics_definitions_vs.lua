-- chunkname: @scripts/managers/backend/statistics_definitions_vs.lua

require("scripts/settings/breeds")

local var_0_0 = StatisticsDefinitions.player

var_0_0.vs_damage_dealt_to_pactsworn = {
	value = 0,
	sync_on_hot_join = true
}
var_0_0.vs_disables_per_breed = {}
var_0_0.vs_knockdowns_per_breed = {}
var_0_0.vs_badge_knocked_down_target_per_breed = {}
var_0_0.vs_badge_escaped_death_per_breed = {}
var_0_0.vs_badge_double_kill_per_breed = {}
var_0_0.vs_badge_triple_kill_per_breed = {}
var_0_0.vs_badge_quadra_kill_per_breed = {}
var_0_0.vs_badge_damage_invisible_per_breed = {}
var_0_0.vs_badge_interrupt_hero_per_breed = {}
var_0_0.vs_badge_flame_a_hoisted_hero_per_breed = {}
var_0_0.vs_badge_ratling_hit_all_heroes_per_breed = {}
var_0_0.vs_badge_warpfire_hit_all_heroes_per_breed = {}
var_0_0.vs_badge_globadier_hit_all_heroes_per_breed = {}
var_0_0.vs_badge_ratling_damage_in_one_clip_per_breed = {}
var_0_0.vs_badge_warpfire_damage_in_one_clip_per_breed = {}
var_0_0.vs_badge_survive_grenade_per_breed = {}
var_0_0.vs_badge_attack_healing_hero_per_breed = {}
var_0_0.vs_badge_grab_a_hero_per_breed = {}
var_0_0.vs_badge_grab_two_heroes_per_breed = {}
var_0_0.vs_badge_long_haul_per_breed = {}
var_0_0.vs_badge_hit_dodging_hero_per_breed = {}
var_0_0.vs_badge_hoist_hero_per_breed = {}
var_0_0.vs_badge_hit_while_reloading_per_breed = {}
var_0_0.vs_badge_first_hit_per_breed = {}
var_0_0.vs_badge_pounce_hero_per_breed = {}
var_0_0.vs_badge_long_pounce_per_breed = {}
var_0_0.vs_badge_multiple_pounces_per_breed = {}
var_0_0.vs_badge_globe_impact_per_breed = {}
var_0_0.vs_badge_globe_impact_2_per_breed = {}
var_0_0.vs_badge_globe_impact_3_per_breed = {}
var_0_0.vs_badge_globe_impact_4_per_breed = {}
var_0_0.vs_badge_knock_down_dragged_hero_per_breed = {}
var_0_0.vs_badge_push_off_per_breed = {}
var_0_0.vs_badge_stabbing_frenzy_per_breed = {}
var_0_0.vs_badge_impact_revive_per_breed = {}
var_0_0.vs_badge_two_downs_one_clip_per_breed = {}
var_0_0.vs_badge_moving_target_per_breed = {}
var_0_0.vs_badge_long_impact_per_breed = {}
var_0_0.vs_badge_stealth_pounce_per_breed = {}
var_0_0.vs_badge_mob_damage_per_breed = {}
var_0_0.vs_badge_warpfire_ambush_per_breed = {}
var_0_0.state_damage_dealt_as_pactsworn_breed = {}

for iter_0_0, iter_0_1 in pairs(PlayerBreeds) do
	var_0_0.vs_disables_per_breed[iter_0_0] = {
		value = 0,
		sync_on_hot_join = true,
		name = iter_0_0
	}
	var_0_0.vs_knockdowns_per_breed[iter_0_0] = {
		value = 0,
		sync_on_hot_join = true,
		name = iter_0_0
	}

	local var_0_1 = "vs_kills_per_breed_" .. iter_0_0
	local var_0_2 = "vs_badge_knocked_down_target_per_breed" .. iter_0_0

	var_0_0.vs_badge_knocked_down_target_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_2
	}

	local var_0_3 = "vs_badge_double_kill_per_breed_" .. iter_0_0

	var_0_0.vs_badge_double_kill_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_3
	}

	local var_0_4 = "vs_badge_triple_kill_per_breed_" .. iter_0_0

	var_0_0.vs_badge_triple_kill_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_4
	}

	local var_0_5 = "vs_badge_quadra_kill_per_breed_" .. iter_0_0

	var_0_0.vs_badge_quadra_kill_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_5
	}

	local var_0_6 = "vs_badge_escaped_death_per_breed_" .. iter_0_0

	var_0_0.vs_badge_escaped_death_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_6
	}

	local var_0_7 = "vs_badge_damage_invisible_per_breed_" .. iter_0_0

	var_0_0.vs_badge_damage_invisible_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_7
	}

	local var_0_8 = "vs_badge_interrupt_hero_per_breed_" .. iter_0_0

	var_0_0.vs_badge_interrupt_hero_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_8
	}

	local var_0_9 = "vs_badge_flame_a_hoisted_hero_per_breed_" .. iter_0_0

	var_0_0.vs_badge_flame_a_hoisted_hero_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_9
	}

	local var_0_10 = "vs_badge_ratling_hit_all_heroes_per_breed_" .. iter_0_0

	var_0_0.vs_badge_ratling_hit_all_heroes_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_10
	}

	local var_0_11 = "vs_badge_warpfire_hit_all_heroes_per_breed_" .. iter_0_0

	var_0_0.vs_badge_warpfire_hit_all_heroes_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_11
	}

	local var_0_12 = "vs_badge_globadier_hit_all_heroes_per_breed_" .. iter_0_0

	var_0_0.vs_badge_globadier_hit_all_heroes_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = db_vs_badge_globadier_hit_all_heroes_name
	}

	local var_0_13 = "vs_badge_ratling_damage_in_one_clip_per_breed_" .. iter_0_0

	var_0_0.vs_badge_ratling_damage_in_one_clip_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_13
	}

	local var_0_14 = "vs_badge_warpfire_damage_in_one_clip_per_breed_" .. iter_0_0

	var_0_0.vs_badge_warpfire_damage_in_one_clip_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_14
	}

	local var_0_15 = "vs_badge_survive_grenade_per_breed_" .. iter_0_0

	var_0_0.vs_badge_survive_grenade_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_15
	}

	local var_0_16 = "vs_badge_attack_healing_hero_per_breed_" .. iter_0_0

	var_0_0.vs_badge_attack_healing_hero_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_16
	}

	local var_0_17 = "vs_badge_grab_a_hero_per_breed_" .. iter_0_0

	var_0_0.vs_badge_grab_a_hero_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_17
	}

	local var_0_18 = "vs_badge_grab_two_heroes_per_breed_" .. iter_0_0

	var_0_0.vs_badge_grab_two_heroes_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_18
	}

	local var_0_19 = "vs_badge_long_haul_per_breed_" .. iter_0_0

	var_0_0.vs_badge_long_haul_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_19
	}

	local var_0_20 = "vs_badge_hit_dodging_hero_per_breed_" .. iter_0_0

	var_0_0.vs_badge_hit_dodging_hero_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_20
	}

	local var_0_21 = "vs_badge_hoist_hero_per_breed_" .. iter_0_0

	var_0_0.vs_badge_hoist_hero_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_21
	}

	local var_0_22 = "vs_badge_hit_while_reloading_per_breed_" .. iter_0_0

	var_0_0.vs_badge_hit_while_reloading_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_22
	}

	local var_0_23 = "vs_badge_first_hit_per_breed_" .. iter_0_0

	var_0_0.vs_badge_first_hit_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_23
	}

	local var_0_24 = "vs_badge_pounce_hero_per_breed_" .. iter_0_0

	var_0_0.vs_badge_pounce_hero_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_24
	}

	local var_0_25 = "vs_badge_long_pounce_per_breed_" .. iter_0_0

	var_0_0.vs_badge_long_pounce_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_25
	}

	local var_0_26 = "vs_badge_multiple_pounces_per_breed_" .. iter_0_0

	var_0_0.vs_badge_multiple_pounces_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_26
	}

	local var_0_27 = "vs_badge_globe_impact_per_breed_" .. iter_0_0

	var_0_0.vs_badge_globe_impact_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_27
	}

	local var_0_28 = "vs_badge_globe_impact_2_per_breed_" .. iter_0_0

	var_0_0.vs_badge_globe_impact_2_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_28
	}

	local var_0_29 = "vs_badge_globe_impact_3_per_breed_" .. iter_0_0

	var_0_0.vs_badge_globe_impact_3_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_29
	}

	local var_0_30 = "vs_badge_globe_impact_4_per_breed_" .. iter_0_0

	var_0_0.vs_badge_globe_impact_4_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_30
	}

	local var_0_31 = "vs_badge_knock_down_dragged_hero_per_breed_" .. iter_0_0

	var_0_0.vs_badge_knock_down_dragged_hero_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_31
	}

	local var_0_32 = "vs_badge_push_off_per_breed_" .. iter_0_0

	var_0_0.vs_badge_push_off_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_32
	}

	local var_0_33 = "vs_badge_stabbing_frenzy_per_breed_" .. iter_0_0

	var_0_0.vs_badge_stabbing_frenzy_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_33
	}

	local var_0_34 = "vs_badge_impact_revive_per_breed_" .. iter_0_0

	var_0_0.vs_badge_impact_revive_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_34
	}

	local var_0_35 = "vs_badge_two_downs_one_clip_per_breed_" .. iter_0_0

	var_0_0.vs_badge_two_downs_one_clip_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_35
	}

	local var_0_36 = "vs_badge_moving_target_per_breed_" .. iter_0_0

	var_0_0.vs_badge_moving_target_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_36
	}

	local var_0_37 = "vs_badge_long_impact_per_breed_" .. iter_0_0

	var_0_0.vs_badge_long_impact_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_37
	}

	local var_0_38 = "vs_badge_stealth_pounce_per_breed_" .. iter_0_0

	var_0_0.vs_badge_stealth_pounce_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_38
	}

	local var_0_39 = "vs_badge_mob_damage_per_breed_" .. iter_0_0

	var_0_0.vs_badge_mob_damage_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_39
	}

	local var_0_40 = "vs_badge_warpfire_ambush_per_breed_" .. iter_0_0

	var_0_0.vs_badge_warpfire_ambush_per_breed[iter_0_0] = {
		value = 0,
		source = "player_data",
		name = iter_0_0,
		database_name = var_0_40
	}
end

var_0_0.vs_game_won = {
	value = 0,
	database_name = "vs_game_won",
	source = "player_data"
}
var_0_0.vs_game_lost = {
	value = 0,
	database_name = "vs_game_lost",
	source = "player_data"
}
var_0_0.vs_hero_monster_kill = {
	value = 0,
	database_name = "vs_hero_monster_kill",
	source = "player_data"
}
var_0_0.vs_hero_revive = {
	value = 0,
	database_name = "vs_hero_revive",
	source = "player_data"
}
var_0_0.vs_clutch_revive = {
	value = 0,
	database_name = "vs_clutch_revive",
	source = "player_data"
}
var_0_0.vs_air_gutter_runner = {
	value = 0,
	database_name = "vs_air_gutter_runner",
	source = "player_data"
}
var_0_0.vs_gas_combo = {
	value = 0,
	database_name = "vs_gas_combo",
	source = "player_data"
}
var_0_0.vs_globe_damage = {
	value = 0,
	database_name = "vs_globe_damage",
	source = "player_data"
}
var_0_0.vs_bile_troll_vomit = {
	value = 0,
	database_name = "vs_bile_troll_vomit",
	source = "player_data"
}
var_0_0.vs_kill_ko_hero = {
	value = 0,
	database_name = "vs_kill_ko_hero",
	source = "player_data"
}
var_0_0.vs_kill_hoisted_hero = {
	value = 0,
	database_name = "vs_kill_hoisted_hero",
	source = "player_data"
}
var_0_0.vs_pounce_heroes = {
	value = 0,
	database_name = "vs_pounce_heroes",
	source = "player_data"
}
var_0_0.vs_hoist_heroes = {
	value = 0,
	database_name = "vs_hoist_heroes",
	source = "player_data"
}
var_0_0.vs_gas_combo_pounce = {
	value = 0,
	database_name = "vs_gas_combo_pounce",
	source = "player_data"
}
var_0_0.vs_break_hero_shield = {
	value = 0,
	database_name = "vs_break_hero_shield",
	source = "player_data"
}
var_0_0.vs_hero_obj_reach = {
	value = 0,
	database_name = "vs_hero_obj_reach",
	source = "player_data"
}
var_0_0.vs_hero_obj_capture = {
	value = 0,
	database_name = "vs_hero_obj_capture",
	source = "player_data"
}
var_0_0.vs_hero_obj_safezone = {
	value = 0,
	database_name = "vs_hero_obj_safezone",
	source = "player_data"
}
var_0_0.vs_hero_obj_barrels = {
	value = 0,
	database_name = "vs_hero_obj_barrels",
	source = "player_data"
}
var_0_0.vs_hero_obj_chains = {
	value = 0,
	database_name = "vs_hero_obj_chains",
	source = "player_data"
}
var_0_0.vs_drag_heroes = {
	value = 0,
	database_name = "vs_drag_heroes",
	source = "player_data"
}
var_0_0.vs_disable_reviving_hero = {
	value = 0,
	database_name = "vs_disable_reviving_hero",
	source = "player_data"
}
var_0_0.vs_kill_invisible_hero = {
	value = 0,
	database_name = "vs_kill_invisible_hero",
	source = "player_data"
}
var_0_0.vs_hero_rescue = {
	value = 0,
	database_name = "vs_hero_rescue",
	source = "player_data"
}
var_0_0.vs_push_hero_off_map = {
	value = 0,
	database_name = "vs_push_hero_off_map",
	source = "player_data"
}
var_0_0.vs_rat_ogre_hit_heroes_heavy = {
	value = 0,
	database_name = "vs_rat_ogre_hit_heroes_heavy",
	source = "player_data"
}
var_0_0.vs_rat_ogre_hit_leap = {
	value = 0,
	database_name = "vs_rat_ogre_hit_leap",
	source = "player_data"
}

local var_0_41 = "vs_hero_eliminations"

var_0_0[var_0_41] = {
	value = 0,
	source = "player_data",
	database_name = var_0_41
}

for iter_0_2, iter_0_3 in pairs(PlayerBreeds) do
	var_0_0.state_damage_dealt_as_pactsworn_breed[iter_0_2] = {
		value = 0,
		name = iter_0_2
	}
end

var_0_0.vs_award_mvp = {
	value = 0,
	database_name = "vs_award_mvp",
	source = "player_data"
}
var_0_0.vs_award_hero_killer = {
	value = 0,
	database_name = "vs_award_hero_killer",
	source = "player_data"
}
var_0_0.vs_award_slayer = {
	value = 0,
	database_name = "vs_award_slayer",
	source = "player_data"
}
var_0_0.vs_award_smiter = {
	value = 0,
	database_name = "vs_award_smiter",
	source = "player_data"
}
var_0_0.vs_award_damage_dealer = {
	value = 0,
	database_name = "vs_award_damage_dealer",
	source = "player_data"
}
var_0_0.vs_award_saviour = {
	value = 0,
	database_name = "vs_award_saviour",
	source = "player_data"
}
var_0_0.vs_award_hero_napper = {
	value = 0,
	database_name = "vs_award_hero_napper",
	source = "player_data"
}
var_0_0.vs_award_assassin = {
	value = 0,
	database_name = "vs_award_assassin",
	source = "player_data"
}
var_0_0.vs_award_horde_killer = {
	value = 0,
	database_name = "vs_award_horde_killer",
	source = "player_data"
}
var_0_0.vs_award_monster = {
	value = 0,
	database_name = "vs_award_monster",
	source = "player_data"
}
var_0_0.vs_award_troll = {
	value = 0,
	database_name = "vs_award_troll",
	source = "player_data"
}
var_0_0.vs_award_rat_ogre = {
	value = 0,
	database_name = "vs_award_rat_ogre",
	source = "player_data"
}
var_0_0.vs_award_monster_killer = {
	value = 0,
	database_name = "vs_award_monster_killer",
	source = "player_data"
}
