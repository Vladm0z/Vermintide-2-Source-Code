-- chunkname: @scripts/managers/backend/statistics_definitions_vs.lua

require("scripts/settings/breeds")

local player = StatisticsDefinitions.player

player.vs_damage_dealt_to_pactsworn = {
	value = 0,
	sync_on_hot_join = true
}
player.vs_disables_per_breed = {}
player.vs_knockdowns_per_breed = {}
player.vs_badge_knocked_down_target_per_breed = {}
player.vs_badge_escaped_death_per_breed = {}
player.vs_badge_double_kill_per_breed = {}
player.vs_badge_triple_kill_per_breed = {}
player.vs_badge_quadra_kill_per_breed = {}
player.vs_badge_damage_invisible_per_breed = {}
player.vs_badge_interrupt_hero_per_breed = {}
player.vs_badge_flame_a_hoisted_hero_per_breed = {}
player.vs_badge_ratling_hit_all_heroes_per_breed = {}
player.vs_badge_warpfire_hit_all_heroes_per_breed = {}
player.vs_badge_globadier_hit_all_heroes_per_breed = {}
player.vs_badge_ratling_damage_in_one_clip_per_breed = {}
player.vs_badge_warpfire_damage_in_one_clip_per_breed = {}
player.vs_badge_survive_grenade_per_breed = {}
player.vs_badge_attack_healing_hero_per_breed = {}
player.vs_badge_grab_a_hero_per_breed = {}
player.vs_badge_grab_two_heroes_per_breed = {}
player.vs_badge_long_haul_per_breed = {}
player.vs_badge_hit_dodging_hero_per_breed = {}
player.vs_badge_hoist_hero_per_breed = {}
player.vs_badge_hit_while_reloading_per_breed = {}
player.vs_badge_first_hit_per_breed = {}
player.vs_badge_pounce_hero_per_breed = {}
player.vs_badge_long_pounce_per_breed = {}
player.vs_badge_multiple_pounces_per_breed = {}
player.vs_badge_globe_impact_per_breed = {}
player.vs_badge_globe_impact_2_per_breed = {}
player.vs_badge_globe_impact_3_per_breed = {}
player.vs_badge_globe_impact_4_per_breed = {}
player.vs_badge_knock_down_dragged_hero_per_breed = {}
player.vs_badge_push_off_per_breed = {}
player.vs_badge_stabbing_frenzy_per_breed = {}
player.vs_badge_impact_revive_per_breed = {}
player.vs_badge_two_downs_one_clip_per_breed = {}
player.vs_badge_moving_target_per_breed = {}
player.vs_badge_long_impact_per_breed = {}
player.vs_badge_stealth_pounce_per_breed = {}
player.vs_badge_mob_damage_per_breed = {}
player.vs_badge_warpfire_ambush_per_breed = {}
player.state_damage_dealt_as_pactsworn_breed = {}

for k, v in pairs(PlayerBreeds) do
	player.vs_disables_per_breed[k] = {
		value = 0,
		sync_on_hot_join = true,
		name = k
	}
	player.vs_knockdowns_per_breed[k] = {
		value = 0,
		sync_on_hot_join = true,
		name = k
	}

	local str = "vs_kills_per_breed_" .. k
	local str_2 = "vs_badge_knocked_down_target_per_breed" .. k

	player.vs_badge_knocked_down_target_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_2
	}

	local str_3 = "vs_badge_double_kill_per_breed_" .. k

	player.vs_badge_double_kill_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_3
	}

	local str_4 = "vs_badge_triple_kill_per_breed_" .. k

	player.vs_badge_triple_kill_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_4
	}

	local str_5 = "vs_badge_quadra_kill_per_breed_" .. k

	player.vs_badge_quadra_kill_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_5
	}

	local str_6 = "vs_badge_escaped_death_per_breed_" .. k

	player.vs_badge_escaped_death_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_6
	}

	local str_7 = "vs_badge_damage_invisible_per_breed_" .. k

	player.vs_badge_damage_invisible_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_7
	}

	local str_8 = "vs_badge_interrupt_hero_per_breed_" .. k

	player.vs_badge_interrupt_hero_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_8
	}

	local str_9 = "vs_badge_flame_a_hoisted_hero_per_breed_" .. k

	player.vs_badge_flame_a_hoisted_hero_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_9
	}

	local str_10 = "vs_badge_ratling_hit_all_heroes_per_breed_" .. k

	player.vs_badge_ratling_hit_all_heroes_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_10
	}

	local str_11 = "vs_badge_warpfire_hit_all_heroes_per_breed_" .. k

	player.vs_badge_warpfire_hit_all_heroes_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_11
	}

	local str_12 = "vs_badge_globadier_hit_all_heroes_per_breed_" .. k

	player.vs_badge_globadier_hit_all_heroes_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = db_vs_badge_globadier_hit_all_heroes_name
	}

	local str_13 = "vs_badge_ratling_damage_in_one_clip_per_breed_" .. k

	player.vs_badge_ratling_damage_in_one_clip_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_13
	}

	local str_14 = "vs_badge_warpfire_damage_in_one_clip_per_breed_" .. k

	player.vs_badge_warpfire_damage_in_one_clip_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_14
	}

	local str_15 = "vs_badge_survive_grenade_per_breed_" .. k

	player.vs_badge_survive_grenade_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_15
	}

	local str_16 = "vs_badge_attack_healing_hero_per_breed_" .. k

	player.vs_badge_attack_healing_hero_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_16
	}

	local str_17 = "vs_badge_grab_a_hero_per_breed_" .. k

	player.vs_badge_grab_a_hero_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_17
	}

	local str_18 = "vs_badge_grab_two_heroes_per_breed_" .. k

	player.vs_badge_grab_two_heroes_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_18
	}

	local str_19 = "vs_badge_long_haul_per_breed_" .. k

	player.vs_badge_long_haul_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_19
	}

	local str_20 = "vs_badge_hit_dodging_hero_per_breed_" .. k

	player.vs_badge_hit_dodging_hero_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_20
	}

	local str_21 = "vs_badge_hoist_hero_per_breed_" .. k

	player.vs_badge_hoist_hero_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_21
	}

	local str_22 = "vs_badge_hit_while_reloading_per_breed_" .. k

	player.vs_badge_hit_while_reloading_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_22
	}

	local str_23 = "vs_badge_first_hit_per_breed_" .. k

	player.vs_badge_first_hit_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_23
	}

	local str_24 = "vs_badge_pounce_hero_per_breed_" .. k

	player.vs_badge_pounce_hero_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_24
	}

	local str_25 = "vs_badge_long_pounce_per_breed_" .. k

	player.vs_badge_long_pounce_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_25
	}

	local str_26 = "vs_badge_multiple_pounces_per_breed_" .. k

	player.vs_badge_multiple_pounces_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_26
	}

	local str_27 = "vs_badge_globe_impact_per_breed_" .. k

	player.vs_badge_globe_impact_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_27
	}

	local str_28 = "vs_badge_globe_impact_2_per_breed_" .. k

	player.vs_badge_globe_impact_2_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_28
	}

	local str_29 = "vs_badge_globe_impact_3_per_breed_" .. k

	player.vs_badge_globe_impact_3_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_29
	}

	local str_30 = "vs_badge_globe_impact_4_per_breed_" .. k

	player.vs_badge_globe_impact_4_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_30
	}

	local str_31 = "vs_badge_knock_down_dragged_hero_per_breed_" .. k

	player.vs_badge_knock_down_dragged_hero_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_31
	}

	local str_32 = "vs_badge_push_off_per_breed_" .. k

	player.vs_badge_push_off_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_32
	}

	local str_33 = "vs_badge_stabbing_frenzy_per_breed_" .. k

	player.vs_badge_stabbing_frenzy_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_33
	}

	local str_34 = "vs_badge_impact_revive_per_breed_" .. k

	player.vs_badge_impact_revive_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_34
	}

	local str_35 = "vs_badge_two_downs_one_clip_per_breed_" .. k

	player.vs_badge_two_downs_one_clip_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_35
	}

	local str_36 = "vs_badge_moving_target_per_breed_" .. k

	player.vs_badge_moving_target_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_36
	}

	local str_37 = "vs_badge_long_impact_per_breed_" .. k

	player.vs_badge_long_impact_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_37
	}

	local str_38 = "vs_badge_stealth_pounce_per_breed_" .. k

	player.vs_badge_stealth_pounce_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_38
	}

	local str_39 = "vs_badge_mob_damage_per_breed_" .. k

	player.vs_badge_mob_damage_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_39
	}

	local str_40 = "vs_badge_warpfire_ambush_per_breed_" .. k

	player.vs_badge_warpfire_ambush_per_breed[k] = {
		value = 0,
		source = "player_data",
		name = k,
		database_name = str_40
	}
end

player.vs_game_won = {
	value = 0,
	database_name = "vs_game_won",
	source = "player_data"
}
player.vs_game_lost = {
	value = 0,
	database_name = "vs_game_lost",
	source = "player_data"
}
player.vs_hero_monster_kill = {
	value = 0,
	database_name = "vs_hero_monster_kill",
	source = "player_data"
}
player.vs_hero_revive = {
	value = 0,
	database_name = "vs_hero_revive",
	source = "player_data"
}
player.vs_clutch_revive = {
	value = 0,
	database_name = "vs_clutch_revive",
	source = "player_data"
}
player.vs_air_gutter_runner = {
	value = 0,
	database_name = "vs_air_gutter_runner",
	source = "player_data"
}
player.vs_gas_combo = {
	value = 0,
	database_name = "vs_gas_combo",
	source = "player_data"
}
player.vs_globe_damage = {
	value = 0,
	database_name = "vs_globe_damage",
	source = "player_data"
}
player.vs_bile_troll_vomit = {
	value = 0,
	database_name = "vs_bile_troll_vomit",
	source = "player_data"
}
player.vs_kill_ko_hero = {
	value = 0,
	database_name = "vs_kill_ko_hero",
	source = "player_data"
}
player.vs_kill_hoisted_hero = {
	value = 0,
	database_name = "vs_kill_hoisted_hero",
	source = "player_data"
}
player.vs_pounce_heroes = {
	value = 0,
	database_name = "vs_pounce_heroes",
	source = "player_data"
}
player.vs_hoist_heroes = {
	value = 0,
	database_name = "vs_hoist_heroes",
	source = "player_data"
}
player.vs_gas_combo_pounce = {
	value = 0,
	database_name = "vs_gas_combo_pounce",
	source = "player_data"
}
player.vs_break_hero_shield = {
	value = 0,
	database_name = "vs_break_hero_shield",
	source = "player_data"
}
player.vs_hero_obj_reach = {
	value = 0,
	database_name = "vs_hero_obj_reach",
	source = "player_data"
}
player.vs_hero_obj_capture = {
	value = 0,
	database_name = "vs_hero_obj_capture",
	source = "player_data"
}
player.vs_hero_obj_safezone = {
	value = 0,
	database_name = "vs_hero_obj_safezone",
	source = "player_data"
}
player.vs_hero_obj_barrels = {
	value = 0,
	database_name = "vs_hero_obj_barrels",
	source = "player_data"
}
player.vs_hero_obj_chains = {
	value = 0,
	database_name = "vs_hero_obj_chains",
	source = "player_data"
}
player.vs_drag_heroes = {
	value = 0,
	database_name = "vs_drag_heroes",
	source = "player_data"
}
player.vs_disable_reviving_hero = {
	value = 0,
	database_name = "vs_disable_reviving_hero",
	source = "player_data"
}
player.vs_kill_invisible_hero = {
	value = 0,
	database_name = "vs_kill_invisible_hero",
	source = "player_data"
}
player.vs_hero_rescue = {
	value = 0,
	database_name = "vs_hero_rescue",
	source = "player_data"
}
player.vs_push_hero_off_map = {
	value = 0,
	database_name = "vs_push_hero_off_map",
	source = "player_data"
}
player.vs_rat_ogre_hit_heroes_heavy = {
	value = 0,
	database_name = "vs_rat_ogre_hit_heroes_heavy",
	source = "player_data"
}
player.vs_rat_ogre_hit_leap = {
	value = 0,
	database_name = "vs_rat_ogre_hit_leap",
	source = "player_data"
}

local str_41 = "vs_hero_eliminations"

player[str_41] = {
	value = 0,
	source = "player_data",
	database_name = str_41
}

for k_2, v_2 in pairs(PlayerBreeds) do
	player.state_damage_dealt_as_pactsworn_breed[k_2] = {
		value = 0,
		name = k_2
	}
end

player.vs_award_mvp = {
	value = 0,
	database_name = "vs_award_mvp",
	source = "player_data"
}
player.vs_award_hero_killer = {
	value = 0,
	database_name = "vs_award_hero_killer",
	source = "player_data"
}
player.vs_award_slayer = {
	value = 0,
	database_name = "vs_award_slayer",
	source = "player_data"
}
player.vs_award_smiter = {
	value = 0,
	database_name = "vs_award_smiter",
	source = "player_data"
}
player.vs_award_damage_dealer = {
	value = 0,
	database_name = "vs_award_damage_dealer",
	source = "player_data"
}
player.vs_award_saviour = {
	value = 0,
	database_name = "vs_award_saviour",
	source = "player_data"
}
player.vs_award_hero_napper = {
	value = 0,
	database_name = "vs_award_hero_napper",
	source = "player_data"
}
player.vs_award_assassin = {
	value = 0,
	database_name = "vs_award_assassin",
	source = "player_data"
}
player.vs_award_horde_killer = {
	value = 0,
	database_name = "vs_award_horde_killer",
	source = "player_data"
}
player.vs_award_monster = {
	value = 0,
	database_name = "vs_award_monster",
	source = "player_data"
}
player.vs_award_troll = {
	value = 0,
	database_name = "vs_award_troll",
	source = "player_data"
}
player.vs_award_rat_ogre = {
	value = 0,
	database_name = "vs_award_rat_ogre",
	source = "player_data"
}
player.vs_award_monster_killer = {
	value = 0,
	database_name = "vs_award_monster_killer",
	source = "player_data"
}
