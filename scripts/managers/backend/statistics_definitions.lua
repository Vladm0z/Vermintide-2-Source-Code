-- chunkname: @scripts/managers/backend/statistics_definitions.lua

require("scripts/settings/breeds")
require("scripts/managers/achievements/achievement_templates")

StatisticsDefinitions = {}
StatisticsDefinitions.player = {}
StatisticsDefinitions.unit_test = {}

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = StatisticsDefinitions.unit_test

var_0_0.kills_melee = {
	value = 0,
	sync_on_hot_join = true
}
var_0_0.kills_ranged = {
	value = 0,
	sync_on_hot_join = true
}
var_0_0.headshots = {
	value = 0,
	sync_on_hot_join = true
}
var_0_0.revives = {
	value = 0,
	sync_on_hot_join = true
}
var_0_0.aidings = {
	value = 0,
	sync_on_hot_join = true
}
var_0_0.saves = {
	value = 0,
	sync_on_hot_join = true
}
var_0_0.times_revived = {
	value = 0,
	sync_on_hot_join = true
}
var_0_0.damage_dealt = {
	value = 0,
	sync_on_hot_join = true
}
var_0_0.quest_statistics = {}

local var_0_2 = QuestSettings.rules

for iter_0_0, iter_0_1 in pairs(var_0_2) do
	local var_0_3 = string.format("%s_quest", iter_0_0)

	for iter_0_2 = 1, iter_0_1.max_quests do
		local var_0_4 = string.format("%s_%d", var_0_3, iter_0_2)

		for iter_0_3 = 1, iter_0_1.num_criterias do
			local var_0_5 = string.format("%s_stat_%d", var_0_4, iter_0_3)

			var_0_0.quest_statistics[var_0_5] = {
				value = 0,
				source = "player_data",
				database_name = "quest_statistics_" .. var_0_5
			}
		end
	end
end

var_0_0.total_collected_grimoires = {
	value = 0,
	database_name = "total_collected_grimoires"
}
var_0_0.total_collected_tomes = {
	value = 0,
	database_name = "total_collected_tomes"
}
var_0_0.total_collected_dice = {
	value = 0,
	database_name = "total_collected_dice"
}
var_0_0.times_friend_healed = {
	value = 0,
	database_name = "times_friend_healed"
}
var_0_0.dynamic_objects_destroyed = {
	value = 0,
	database_name = "dynamic_objects_destroyed"
}
var_0_0.completed_levels_bright_wizard = {}
var_0_0.completed_levels_wood_elf = {}
var_0_0.completed_levels_empire_soldier = {}
var_0_0.completed_levels_witch_hunter = {}
var_0_0.completed_levels_dwarf_ranger = {}
var_0_0.collected_grimoires = {}
var_0_0.collected_tomes = {}
var_0_0.collected_dice = {}
var_0_0.collected_painting_scraps = {}
var_0_0.completed_heroic_deeds = {
	value = 0,
	database_name = "completed_heroic_deeds",
	source = "player_data"
}
var_0_0.perfect_rat_ogre = {
	value = 0,
	database_name = "perfect_rat_ogre",
	source = "player_data"
}
var_0_0.perfect_chaos_spawn = {
	value = 0,
	database_name = "perfect_chaos_spawn",
	source = "player_data"
}
var_0_0.perfect_bile_troll = {
	value = 0,
	database_name = "perfect_bile_troll",
	source = "player_data"
}
var_0_0.perfect_storm_fiend = {
	value = 0,
	database_name = "perfect_storm_fiend",
	source = "player_data"
}
var_0_0.kill_chaos_exalted_champion_difficulty_rank = {
	value = 0,
	database_name = "kill_chaos_exalted_champion_difficulty_rank",
	source = "player_data"
}
var_0_0.kill_chaos_exalted_sorcerer_difficulty_rank = {
	value = 0,
	database_name = "kill_chaos_exalted_sorcerer_difficulty_rank",
	source = "player_data"
}
var_0_0.kill_skaven_grey_seer_difficulty_rank = {
	value = 0,
	database_name = "kill_skaven_grey_seer_difficulty_rank",
	source = "player_data"
}
var_0_0.kill_skaven_storm_vermin_warlord_difficulty_rank = {
	value = 0,
	database_name = "kill_skaven_storm_vermin_warlord_difficulty_rank",
	source = "player_data"
}
var_0_0.highest_equipped_rarity = {}

local var_0_6 = {
	"melee",
	"ranged",
	"necklace",
	"ring",
	"trinket",
	"hat",
	"skin",
	"frame",
	"weapon_pose"
}

for iter_0_4, iter_0_5 in ipairs(var_0_6) do
	var_0_0.highest_equipped_rarity[iter_0_5] = {
		value = 0,
		source = "player_data",
		database_name = "highest_equipped_rarity_" .. iter_0_5
	}
end

var_0_0.military_statue_kill_chaos_warriors_session = {
	value = 0
}
var_0_0.military_statue_kill_chaos_warriors = {
	value = 0,
	database_name = "military_statue_kill_chaos_warriors",
	source = "player_data"
}
var_0_0.halescourge_tornado_enemies = {
	value = 0,
	database_name = "halescourge_tornado_enemies",
	source = "player_data"
}
var_0_0.forest_fort_kill_cannonball = {
	value = 0,
	database_name = "forest_fort_kill_cannonball",
	source = "player_data"
}
var_0_0.nurgle_bathed_all = {
	value = 0,
	database_name = "nurgle_bathed_all",
	source = "player_data"
}
var_0_0.catacombs_added_souls = {
	value = 0,
	database_name = "catacombs_added_souls",
	source = "player_data"
}
var_0_0.ussingen_used_no_barrels = {
	value = 0,
	database_name = "ussingen_used_no_barrels",
	source = "player_data"
}
var_0_0.elven_ruins_speed_event = {
	value = 0,
	database_name = "elven_ruins_speed_event",
	source = "player_data"
}
var_0_0.farmlands_speed_event = {
	value = 0,
	database_name = "farmlands_speed_event",
	source = "player_data"
}
var_0_0.bell_speed_event = {
	value = 0,
	database_name = "bell_speed_event",
	source = "player_data"
}
var_0_0.mines_speed_event = {
	value = 0,
	database_name = "mines_speed_event",
	source = "player_data"
}
var_0_0.skittergate_speed_event = {
	value = 0,
	database_name = "skittergate_speed_event",
	source = "player_data"
}
var_0_0.exalted_champion_charge_chaos_warrior = {
	value = 0,
	database_name = "exalted_champion_charge_chaos_warrior",
	source = "player_data"
}
var_0_0.storm_vermin_warlord_kills_enemies = {
	value = 0,
	database_name = "storm_vermin_warlord_kills_enemies",
	source = "player_data"
}
var_0_0.military_statue_kill_chaos_warriors_cata = {
	value = 0,
	database_name = "military_statue_kill_chaos_warriors_cata",
	source = "player_data"
}
var_0_0.halescourge_tornado_enemies_cata = {
	value = 0,
	database_name = "halescourge_tornado_enemies_cata",
	source = "player_data"
}
var_0_0.forest_fort_kill_cannonball_cata = {
	value = 0,
	database_name = "forest_fort_kill_cannonball_cata",
	source = "player_data"
}
var_0_0.nurgle_bathed_all_cata = {
	value = 0,
	database_name = "nurgle_bathed_all_cata",
	source = "player_data"
}
var_0_0.catacombs_added_souls_cata = {
	value = 0,
	database_name = "catacombs_added_souls_cata",
	source = "player_data"
}
var_0_0.ussingen_used_no_barrels_cata = {
	value = 0,
	database_name = "ussingen_used_no_barrels_cata",
	source = "player_data"
}
var_0_0.elven_ruins_speed_event_cata = {
	value = 0,
	database_name = "elven_ruins_speed_event_cata",
	source = "player_data"
}
var_0_0.farmlands_speed_event_cata = {
	value = 0,
	database_name = "farmlands_speed_event_cata",
	source = "player_data"
}
var_0_0.bell_speed_event_cata = {
	value = 0,
	database_name = "bell_speed_event_cata",
	source = "player_data"
}
var_0_0.mines_speed_event_cata = {
	value = 0,
	database_name = "mines_speed_event_cata",
	source = "player_data"
}
var_0_0.skittergate_speed_event_cata = {
	value = 0,
	database_name = "skittergate_speed_event_cata",
	source = "player_data"
}
var_0_0.exalted_champion_charge_chaos_warrior_cata = {
	value = 0,
	database_name = "exalted_champion_charge_chaos_warrior_cata",
	source = "player_data"
}
var_0_0.storm_vermin_warlord_kills_enemies_cata = {
	value = 0,
	database_name = "storm_vermin_warlord_kills_enemies_cata",
	source = "player_data"
}
var_0_0.bonfire_lit_mines = {
	value = 0,
	database_name = "bonfire_lit_mines",
	source = "player_data"
}
var_0_0.bonfire_lit_warcamp = {
	value = 0,
	database_name = "bonfire_lit_warcamp",
	source = "player_data"
}
var_0_0.bonfire_lit_fort = {
	value = 0,
	database_name = "bonfire_lit_fort",
	source = "player_data"
}
var_0_0.bonfire_lit_skittergate = {
	value = 0,
	database_name = "bonfire_lit_skittergate",
	source = "player_data"
}
var_0_0.globadier_kill_before_throwing = {
	value = 0,
	database_name = "globadier_kill_before_throwing",
	source = "player_data"
}
var_0_0.globadier_kill_during_suicide = {
	value = 0,
	database_name = "globadier_kill_during_suicide",
	source = "player_data"
}
var_0_0.globadier_enemies_killed_by_poison = {
	value = 0,
	database_name = "globadier_enemies_killed_by_poison",
	source = "player_data"
}
var_0_0.warpfire_kill_before_shooting = {
	value = 0,
	database_name = "warpfire_kill_before_shooting",
	source = "player_data"
}
var_0_0.warpfire_kill_on_power_cell = {
	value = 0,
	database_name = "warpfire_kill_on_power_cell",
	source = "player_data"
}
var_0_0.warpfire_enemies_killed_by_warpfire = {
	value = 0,
	database_name = "warpfire_enemies_killed_by_warpfire",
	source = "player_data"
}
var_0_0.pack_master_dodged_attack = {
	value = 0,
	database_name = "pack_master_dodged_attack",
	source = "player_data"
}
var_0_0.pack_master_kill_abducting_ally = {
	value = 0,
	database_name = "pack_master_kill_abducting_ally",
	source = "player_data"
}
var_0_0.pack_master_rescue_hoisted_ally = {
	value = 0,
	database_name = "pack_master_rescue_hoisted_ally",
	source = "player_data"
}
var_0_0.gutter_runner_killed_on_pounce = {
	value = 0,
	database_name = "gutter_runner_killed_on_pounce",
	source = "player_data"
}
var_0_0.gutter_runner_push_on_pounce = {
	value = 0,
	database_name = "gutter_runner_push_on_pounce",
	source = "player_data"
}
var_0_0.gutter_runner_push_on_target_pounced = {
	value = 0,
	database_name = "gutter_runner_push_on_target_pounced",
	source = "player_data"
}
var_0_0.corruptor_killed_at_teleport_time = {
	value = 0,
	database_name = "corruptor_killed_at_teleport_time",
	source = "player_data"
}
var_0_0.corruptor_dodged_attack = {
	value = 0,
	database_name = "corruptor_dodged_attack",
	source = "player_data"
}
var_0_0.corruptor_killed_while_grabbing = {
	value = 0,
	database_name = "corruptor_killed_while_grabbing",
	source = "player_data"
}
var_0_0.vortex_sorcerer_killed_while_summoning = {
	value = 0,
	database_name = "vortex_sorcerer_killed_while_summoning",
	source = "player_data"
}
var_0_0.vortex_sorcerer_killed_while_ally_in_vortex = {
	value = 0,
	database_name = "vortex_sorcerer_killed_while_ally_in_vortex",
	source = "player_data"
}
var_0_0.vortex_sorcerer_killed_by_melee = {
	value = 0,
	database_name = "vortex_sorcerer_killed_by_melee",
	source = "player_data"
}
var_0_0.ratling_gunner_killed_by_melee = {
	value = 0,
	database_name = "ratling_gunner_killed_by_melee",
	source = "player_data"
}
var_0_0.ratling_gunner_killed_while_shooting = {
	value = 0,
	database_name = "ratling_gunner_killed_while_shooting",
	source = "player_data"
}
var_0_0.ratling_gunner_blocked_shot = {
	value = 0,
	database_name = "ratling_gunner_blocked_shot",
	source = "player_data"
}
var_0_0.chaos_spawn_killed_while_grabbing = {
	value = 0,
	database_name = "chaos_spawn_killed_while_grabbing",
	source = "player_data"
}
var_0_0.chaos_spawn_killed_without_having_grabbed = {
	value = 0,
	database_name = "chaos_spawn_killed_without_having_grabbed",
	source = "player_data"
}
var_0_0.chaos_troll_killed_without_regen = {
	value = 0,
	database_name = "chaos_troll_killed_without_regen",
	source = "player_data"
}
var_0_0.chaos_troll_killed_without_bile_damage = {
	value = 0,
	database_name = "chaos_troll_killed_without_bile_damage",
	source = "player_data"
}
var_0_0.rat_ogre_killed_mid_leap = {
	value = 0,
	database_name = "rat_ogre_killed_mid_leap",
	source = "player_data"
}
var_0_0.rat_ogre_killed_without_dealing_damage = {
	value = 0,
	database_name = "rat_ogre_killed_without_dealing_damage",
	source = "player_data"
}
var_0_0.stormfiend_killed_without_burn_damage = {
	value = 0,
	database_name = "stormfiend_killed_without_burn_damage",
	source = "player_data"
}
var_0_0.stormfiend_killed_on_controller = {
	value = 0,
	database_name = "stormfiend_killed_on_controller",
	source = "player_data"
}
var_0_0.killed_lord_as_last_player_standing = {
	value = 0,
	database_name = "killed_lord_as_last_player_standing",
	source = "player_data"
}
var_0_0.collected_painting_scraps_generic = {
	value = 0,
	database_name = "collected_painting_scraps_generic",
	source = "player_data"
}
var_0_0.collected_painting_scraps_unlimited = {
	value = 0,
	database_name = "collected_painting_scraps_unlimited",
	source = "player_data"
}
var_0_0.collected_bogenhafen_cosmetics = {
	value = 0,
	database_name = "collected_bogenhafen_cosmetics"
}
var_0_0.played_levels_quickplay = {}
var_0_0.last_played_level_id = {
	value = 0,
	database_name = "last_played_level_id",
	sync_to_host = true
}
var_0_0.kills_total = {
	value = 0,
	sync_on_hot_join = true
}
var_0_0.kills_critter_total = {
	value = 0,
	sync_on_hot_join = true
}
var_0_0.kills_per_breed = {}
var_0_0.kills_per_breed_persistent = {}
var_0_0.kills_per_breed_difficulty = {}
var_0_0.kills_per_race = {}
var_0_0.kill_assists_per_breed = {}
var_0_0.kill_assists_per_breed_difficulty = {}
var_0_0.damage_taken = {
	value = 0,
	sync_on_hot_join = true
}
var_0_0.damage_dealt_per_breed = {}
var_0_0.damage_dealt_as_breed = {}
var_0_0.eliminations_as_breed = {}
var_0_0.completed_levels = {}
var_0_0.completed_levels_difficulty = {}
var_0_0.completed_career_levels = {}
var_0_0.played_difficulty = {}
var_0_0.weapon_kills_per_breed = {}
var_0_0.mission_streak = {}
var_0_0.dwarf_fest_secret_trolls_killed = {
	first = {
		value = 0
	},
	second = {
		value = 0
	},
	third = {
		value = 0
	}
}
var_0_0.completed_daily_quests = {
	value = 0,
	database_name = "completed_daily_quests",
	source = "player_data"
}
var_0_0.completed_weekly_quests = {
	value = 0,
	database_name = "completed_weekly_quests",
	source = "player_data"
}
var_0_0.played_levels_weekly_event = {}
var_0_0.completed_weekly_event_difficulty = {}
var_0_0.crafted_items = {
	value = 0,
	database_name = "crafted_items"
}
var_0_0.salvaged_items = {
	value = 0,
	database_name = "salvaged_items"
}
var_0_1.kills_total = {
	value = 0,
	database_name = "kills_total"
}
var_0_1.profiles = {
	witch_hunter = {
		kills_total = {
			value = 0
		}
	}
}

for iter_0_6, iter_0_7 in pairs(CareerSettings) do
	if iter_0_6 ~= "empire_soldier_tutorial" then
		var_0_0.completed_career_levels[iter_0_6] = {}

		for iter_0_8, iter_0_9 in pairs(LevelSettings) do
			if table.contains(UnlockableLevels, iter_0_8) then
				var_0_0.completed_career_levels[iter_0_6][iter_0_8] = {}

				for iter_0_10, iter_0_11 in pairs(DifficultySettings) do
					local var_0_7 = "completed_career_levels_" .. iter_0_6 .. "_" .. iter_0_8 .. "_" .. iter_0_10

					var_0_0.completed_career_levels[iter_0_6][iter_0_8][iter_0_10] = {
						value = 0,
						source = "player_data",
						database_name = var_0_7
					}
				end
			end
		end
	end
end

var_0_0.min_health_percentage = {}
var_0_0.min_health_completed = {}

for iter_0_12, iter_0_13 in pairs(CareerSettings) do
	local var_0_8 = CareerSettings[iter_0_12].breed

	if var_0_8 and var_0_8.is_hero then
		var_0_0.min_health_percentage[iter_0_12] = {
			value = 1
		}

		local var_0_9 = "min_health_completed_" .. iter_0_12

		var_0_0.min_health_completed[iter_0_12] = {
			value = 0,
			source = "player_data",
			database_name = var_0_9
		}
	end
end

for iter_0_14, iter_0_15 in pairs(DifficultySettings) do
	local var_0_10 = "played_difficulty_" .. iter_0_14

	var_0_0.played_difficulty[iter_0_14] = {
		value = 0,
		source = "player_data",
		database_name = var_0_10
	}

	local var_0_11 = string.format("completed_weekly_event_difficulty_%s", iter_0_14)

	var_0_0.completed_weekly_event_difficulty[iter_0_14] = {
		value = 0,
		source = "player_data",
		database_name = var_0_11
	}
end

for iter_0_16, iter_0_17 in pairs(Breeds) do
	var_0_0.kills_per_breed[iter_0_16] = {
		value = 0,
		sync_on_hot_join = true,
		name = iter_0_16
	}
	var_0_0.kills_per_breed_persistent[iter_0_16] = {
		value = 0,
		source = "player_data",
		database_name = "kills_per_breed_persistent_" .. iter_0_16
	}
	var_0_0.kill_assists_per_breed[iter_0_16] = {
		value = 0,
		name = iter_0_16
	}
	var_0_0.damage_dealt_per_breed[iter_0_16] = {
		value = 0,
		name = iter_0_16
	}

	local var_0_12 = iter_0_17.race

	if var_0_12 and not var_0_0.kills_per_race[var_0_12] then
		var_0_0.kills_per_race[var_0_12] = {
			value = 0,
			name = var_0_12
		}
	end

	var_0_0.kills_per_breed_difficulty[iter_0_16] = {}
	var_0_0.kill_assists_per_breed_difficulty[iter_0_16] = {}

	local var_0_13 = DifficultySettings

	for iter_0_18 in pairs(var_0_13) do
		var_0_0.kills_per_breed_difficulty[iter_0_16][iter_0_18] = {
			value = 0
		}
		var_0_0.kill_assists_per_breed_difficulty[iter_0_16][iter_0_18] = {
			value = 0
		}
	end
end

for iter_0_19, iter_0_20 in pairs(PlayerBreeds) do
	var_0_0.kills_per_breed[iter_0_19] = {
		value = 0,
		sync_on_hot_join = true,
		name = iter_0_19
	}
	var_0_0.kill_assists_per_breed[iter_0_19] = {
		value = 0,
		name = iter_0_19
	}
	var_0_0.damage_dealt_per_breed[iter_0_19] = {
		value = 0,
		name = iter_0_19
	}
	var_0_0.kills_per_breed_persistent[iter_0_19] = {
		value = 0,
		source = "player_data",
		database_name = "kills_per_breed_persistent_" .. iter_0_19
	}
	var_0_0.damage_dealt_as_breed[iter_0_19] = {
		value = 0,
		source = "player_data",
		name = iter_0_19,
		database_name = "damage_dealt_as_" .. iter_0_19
	}
	var_0_0.eliminations_as_breed[iter_0_19] = {
		value = 0,
		source = "player_data",
		name = iter_0_19,
		database_name = "eliminations_as_" .. iter_0_19
	}

	local var_0_14 = iter_0_20.race

	if var_0_14 and not var_0_0.kills_per_race[var_0_14] then
		var_0_0.kills_per_race[var_0_14] = {
			value = 0,
			name = var_0_14
		}
	end

	var_0_0.kills_per_breed_difficulty[iter_0_19] = {}
	var_0_0.kill_assists_per_breed_difficulty[iter_0_19] = {}

	local var_0_15 = DifficultySettings

	for iter_0_21 in pairs(var_0_15) do
		var_0_0.kills_per_breed_difficulty[iter_0_19][iter_0_21] = {
			value = 0
		}
		var_0_0.kill_assists_per_breed_difficulty[iter_0_19][iter_0_21] = {
			value = 0
		}
	end
end

LevelDifficultyDBNames = {}

for iter_0_22, iter_0_23 in pairs(UnlockableLevels) do
	local var_0_16 = LevelSettings[iter_0_23].dlc_name ~= nil
	local var_0_17 = {
		value = 0,
		sync_on_hot_join = true,
		sync_to_host = true,
		database_name = "completed_levels_" .. iter_0_23
	}

	if var_0_16 then
		var_0_17.source = "player_data"
	end

	var_0_0.completed_levels[iter_0_23] = var_0_17

	local var_0_18 = {
		value = 0,
		sync_to_host = true,
		database_name = "played_levels_quickplay_" .. iter_0_23
	}
	local var_0_19 = {
		value = 0,
		source = "player_data",
		sync_to_host = true,
		database_name = "played_levels_weekly_event_" .. iter_0_23
	}

	if var_0_16 then
		var_0_18.source = "player_data"
	end

	var_0_0.played_levels_quickplay[iter_0_23] = var_0_18
	var_0_0.played_levels_weekly_event[iter_0_23] = var_0_19

	local var_0_20 = {
		"bright_wizard",
		"wood_elf",
		"empire_soldier",
		"witch_hunter",
		"dwarf_ranger"
	}

	for iter_0_24, iter_0_25 in ipairs(var_0_20) do
		local var_0_21 = "completed_levels_" .. iter_0_25
		local var_0_22 = var_0_0[var_0_21]
		local var_0_23 = {
			value = 0,
			database_name = var_0_21 .. "_" .. iter_0_23
		}

		if var_0_16 then
			var_0_23.source = "player_data"
		end

		var_0_22[iter_0_23] = var_0_23
	end

	local var_0_24 = iter_0_23 .. "_difficulty_completed"

	LevelDifficultyDBNames[iter_0_23] = var_0_24

	local var_0_25 = {
		value = 0,
		sync_on_hot_join = true,
		database_name = var_0_24
	}

	if var_0_16 then
		var_0_25.source = "player_data"
	end

	var_0_0.completed_levels_difficulty[var_0_24] = var_0_25

	local var_0_26 = "collected_grimoire_" .. iter_0_23
	local var_0_27 = {
		value = 0,
		database_name = var_0_26
	}

	if var_0_16 then
		var_0_27.source = "player_data"
	end

	var_0_0.collected_grimoires[iter_0_23] = var_0_27

	local var_0_28 = "collected_tome_" .. iter_0_23
	local var_0_29 = {
		value = 0,
		database_name = var_0_28
	}

	if var_0_16 then
		var_0_29.source = "player_data"
	end

	var_0_0.collected_tomes[iter_0_23] = var_0_29

	local var_0_30 = "collected_die_" .. iter_0_23
	local var_0_31 = {
		value = 0,
		database_name = var_0_30
	}

	if var_0_16 then
		var_0_31.source = "player_data"
	end

	var_0_0.collected_dice[iter_0_23] = var_0_31

	local var_0_32 = "collected_painting_scraps_" .. iter_0_23

	var_0_0.collected_painting_scraps[iter_0_23] = {
		value = 0,
		source = "player_data",
		database_name = var_0_32
	}
end

DLCUtils.dofile_list("statistics_definitions")

local function var_0_33(arg_1_0)
	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		if not iter_1_1.value then
			var_0_33(iter_1_1)
		else
			iter_1_1.name = iter_1_0
		end
	end
end

var_0_33(var_0_0)
var_0_33(var_0_1)
