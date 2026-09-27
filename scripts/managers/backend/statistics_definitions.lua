-- chunkname: @scripts/managers/backend/statistics_definitions.lua

require("scripts/settings/breeds")
require("scripts/managers/achievements/achievement_templates")

StatisticsDefinitions = {}
StatisticsDefinitions.player = {}
StatisticsDefinitions.unit_test = {}

local player = StatisticsDefinitions.player
local unit_test = StatisticsDefinitions.unit_test

player.kills_melee = {
	value = 0,
	sync_on_hot_join = true
}
player.kills_ranged = {
	value = 0,
	sync_on_hot_join = true
}
player.headshots = {
	value = 0,
	sync_on_hot_join = true
}
player.revives = {
	value = 0,
	sync_on_hot_join = true
}
player.aidings = {
	value = 0,
	sync_on_hot_join = true
}
player.saves = {
	value = 0,
	sync_on_hot_join = true
}
player.times_revived = {
	value = 0,
	sync_on_hot_join = true
}
player.damage_dealt = {
	value = 0,
	sync_on_hot_join = true
}
player.quest_statistics = {}

local rules = QuestSettings.rules

for k, v in pairs(rules) do
	local format = string.format("%s_quest", k)

	for k_2 = 1, v.max_quests do
		local format_2 = string.format("%s_%d", format, k_2)

		for l = 1, v.num_criterias do
			local format_3 = string.format("%s_stat_%d", format_2, l)

			player.quest_statistics[format_3] = {
				value = 0,
				source = "player_data",
				database_name = "quest_statistics_" .. format_3
			}
		end
	end
end

player.total_collected_grimoires = {
	value = 0,
	database_name = "total_collected_grimoires"
}
player.total_collected_tomes = {
	value = 0,
	database_name = "total_collected_tomes"
}
player.total_collected_dice = {
	value = 0,
	database_name = "total_collected_dice"
}
player.times_friend_healed = {
	value = 0,
	database_name = "times_friend_healed"
}
player.dynamic_objects_destroyed = {
	value = 0,
	database_name = "dynamic_objects_destroyed"
}
player.completed_levels_bright_wizard = {}
player.completed_levels_wood_elf = {}
player.completed_levels_empire_soldier = {}
player.completed_levels_witch_hunter = {}
player.completed_levels_dwarf_ranger = {}
player.collected_grimoires = {}
player.collected_tomes = {}
player.collected_dice = {}
player.collected_painting_scraps = {}
player.completed_heroic_deeds = {
	value = 0,
	database_name = "completed_heroic_deeds",
	source = "player_data"
}
player.perfect_rat_ogre = {
	value = 0,
	database_name = "perfect_rat_ogre",
	source = "player_data"
}
player.perfect_chaos_spawn = {
	value = 0,
	database_name = "perfect_chaos_spawn",
	source = "player_data"
}
player.perfect_bile_troll = {
	value = 0,
	database_name = "perfect_bile_troll",
	source = "player_data"
}
player.perfect_storm_fiend = {
	value = 0,
	database_name = "perfect_storm_fiend",
	source = "player_data"
}
player.kill_chaos_exalted_champion_difficulty_rank = {
	value = 0,
	database_name = "kill_chaos_exalted_champion_difficulty_rank",
	source = "player_data"
}
player.kill_chaos_exalted_sorcerer_difficulty_rank = {
	value = 0,
	database_name = "kill_chaos_exalted_sorcerer_difficulty_rank",
	source = "player_data"
}
player.kill_skaven_grey_seer_difficulty_rank = {
	value = 0,
	database_name = "kill_skaven_grey_seer_difficulty_rank",
	source = "player_data"
}
player.kill_skaven_storm_vermin_warlord_difficulty_rank = {
	value = 0,
	database_name = "kill_skaven_storm_vermin_warlord_difficulty_rank",
	source = "player_data"
}
player.highest_equipped_rarity = {}

local tbl = {
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

for i, v_2 in ipairs(tbl) do
	player.highest_equipped_rarity[v_2] = {
		value = 0,
		source = "player_data",
		database_name = "highest_equipped_rarity_" .. v_2
	}
end

player.military_statue_kill_chaos_warriors_session = {
	value = 0
}
player.military_statue_kill_chaos_warriors = {
	value = 0,
	database_name = "military_statue_kill_chaos_warriors",
	source = "player_data"
}
player.halescourge_tornado_enemies = {
	value = 0,
	database_name = "halescourge_tornado_enemies",
	source = "player_data"
}
player.forest_fort_kill_cannonball = {
	value = 0,
	database_name = "forest_fort_kill_cannonball",
	source = "player_data"
}
player.nurgle_bathed_all = {
	value = 0,
	database_name = "nurgle_bathed_all",
	source = "player_data"
}
player.catacombs_added_souls = {
	value = 0,
	database_name = "catacombs_added_souls",
	source = "player_data"
}
player.ussingen_used_no_barrels = {
	value = 0,
	database_name = "ussingen_used_no_barrels",
	source = "player_data"
}
player.elven_ruins_speed_event = {
	value = 0,
	database_name = "elven_ruins_speed_event",
	source = "player_data"
}
player.farmlands_speed_event = {
	value = 0,
	database_name = "farmlands_speed_event",
	source = "player_data"
}
player.bell_speed_event = {
	value = 0,
	database_name = "bell_speed_event",
	source = "player_data"
}
player.mines_speed_event = {
	value = 0,
	database_name = "mines_speed_event",
	source = "player_data"
}
player.skittergate_speed_event = {
	value = 0,
	database_name = "skittergate_speed_event",
	source = "player_data"
}
player.exalted_champion_charge_chaos_warrior = {
	value = 0,
	database_name = "exalted_champion_charge_chaos_warrior",
	source = "player_data"
}
player.storm_vermin_warlord_kills_enemies = {
	value = 0,
	database_name = "storm_vermin_warlord_kills_enemies",
	source = "player_data"
}
player.military_statue_kill_chaos_warriors_cata = {
	value = 0,
	database_name = "military_statue_kill_chaos_warriors_cata",
	source = "player_data"
}
player.halescourge_tornado_enemies_cata = {
	value = 0,
	database_name = "halescourge_tornado_enemies_cata",
	source = "player_data"
}
player.forest_fort_kill_cannonball_cata = {
	value = 0,
	database_name = "forest_fort_kill_cannonball_cata",
	source = "player_data"
}
player.nurgle_bathed_all_cata = {
	value = 0,
	database_name = "nurgle_bathed_all_cata",
	source = "player_data"
}
player.catacombs_added_souls_cata = {
	value = 0,
	database_name = "catacombs_added_souls_cata",
	source = "player_data"
}
player.ussingen_used_no_barrels_cata = {
	value = 0,
	database_name = "ussingen_used_no_barrels_cata",
	source = "player_data"
}
player.elven_ruins_speed_event_cata = {
	value = 0,
	database_name = "elven_ruins_speed_event_cata",
	source = "player_data"
}
player.farmlands_speed_event_cata = {
	value = 0,
	database_name = "farmlands_speed_event_cata",
	source = "player_data"
}
player.bell_speed_event_cata = {
	value = 0,
	database_name = "bell_speed_event_cata",
	source = "player_data"
}
player.mines_speed_event_cata = {
	value = 0,
	database_name = "mines_speed_event_cata",
	source = "player_data"
}
player.skittergate_speed_event_cata = {
	value = 0,
	database_name = "skittergate_speed_event_cata",
	source = "player_data"
}
player.exalted_champion_charge_chaos_warrior_cata = {
	value = 0,
	database_name = "exalted_champion_charge_chaos_warrior_cata",
	source = "player_data"
}
player.storm_vermin_warlord_kills_enemies_cata = {
	value = 0,
	database_name = "storm_vermin_warlord_kills_enemies_cata",
	source = "player_data"
}
player.bonfire_lit_mines = {
	value = 0,
	database_name = "bonfire_lit_mines",
	source = "player_data"
}
player.bonfire_lit_warcamp = {
	value = 0,
	database_name = "bonfire_lit_warcamp",
	source = "player_data"
}
player.bonfire_lit_fort = {
	value = 0,
	database_name = "bonfire_lit_fort",
	source = "player_data"
}
player.bonfire_lit_skittergate = {
	value = 0,
	database_name = "bonfire_lit_skittergate",
	source = "player_data"
}
player.globadier_kill_before_throwing = {
	value = 0,
	database_name = "globadier_kill_before_throwing",
	source = "player_data"
}
player.globadier_kill_during_suicide = {
	value = 0,
	database_name = "globadier_kill_during_suicide",
	source = "player_data"
}
player.globadier_enemies_killed_by_poison = {
	value = 0,
	database_name = "globadier_enemies_killed_by_poison",
	source = "player_data"
}
player.warpfire_kill_before_shooting = {
	value = 0,
	database_name = "warpfire_kill_before_shooting",
	source = "player_data"
}
player.warpfire_kill_on_power_cell = {
	value = 0,
	database_name = "warpfire_kill_on_power_cell",
	source = "player_data"
}
player.warpfire_enemies_killed_by_warpfire = {
	value = 0,
	database_name = "warpfire_enemies_killed_by_warpfire",
	source = "player_data"
}
player.pack_master_dodged_attack = {
	value = 0,
	database_name = "pack_master_dodged_attack",
	source = "player_data"
}
player.pack_master_kill_abducting_ally = {
	value = 0,
	database_name = "pack_master_kill_abducting_ally",
	source = "player_data"
}
player.pack_master_rescue_hoisted_ally = {
	value = 0,
	database_name = "pack_master_rescue_hoisted_ally",
	source = "player_data"
}
player.gutter_runner_killed_on_pounce = {
	value = 0,
	database_name = "gutter_runner_killed_on_pounce",
	source = "player_data"
}
player.gutter_runner_push_on_pounce = {
	value = 0,
	database_name = "gutter_runner_push_on_pounce",
	source = "player_data"
}
player.gutter_runner_push_on_target_pounced = {
	value = 0,
	database_name = "gutter_runner_push_on_target_pounced",
	source = "player_data"
}
player.corruptor_killed_at_teleport_time = {
	value = 0,
	database_name = "corruptor_killed_at_teleport_time",
	source = "player_data"
}
player.corruptor_dodged_attack = {
	value = 0,
	database_name = "corruptor_dodged_attack",
	source = "player_data"
}
player.corruptor_killed_while_grabbing = {
	value = 0,
	database_name = "corruptor_killed_while_grabbing",
	source = "player_data"
}
player.vortex_sorcerer_killed_while_summoning = {
	value = 0,
	database_name = "vortex_sorcerer_killed_while_summoning",
	source = "player_data"
}
player.vortex_sorcerer_killed_while_ally_in_vortex = {
	value = 0,
	database_name = "vortex_sorcerer_killed_while_ally_in_vortex",
	source = "player_data"
}
player.vortex_sorcerer_killed_by_melee = {
	value = 0,
	database_name = "vortex_sorcerer_killed_by_melee",
	source = "player_data"
}
player.ratling_gunner_killed_by_melee = {
	value = 0,
	database_name = "ratling_gunner_killed_by_melee",
	source = "player_data"
}
player.ratling_gunner_killed_while_shooting = {
	value = 0,
	database_name = "ratling_gunner_killed_while_shooting",
	source = "player_data"
}
player.ratling_gunner_blocked_shot = {
	value = 0,
	database_name = "ratling_gunner_blocked_shot",
	source = "player_data"
}
player.chaos_spawn_killed_while_grabbing = {
	value = 0,
	database_name = "chaos_spawn_killed_while_grabbing",
	source = "player_data"
}
player.chaos_spawn_killed_without_having_grabbed = {
	value = 0,
	database_name = "chaos_spawn_killed_without_having_grabbed",
	source = "player_data"
}
player.chaos_troll_killed_without_regen = {
	value = 0,
	database_name = "chaos_troll_killed_without_regen",
	source = "player_data"
}
player.chaos_troll_killed_without_bile_damage = {
	value = 0,
	database_name = "chaos_troll_killed_without_bile_damage",
	source = "player_data"
}
player.rat_ogre_killed_mid_leap = {
	value = 0,
	database_name = "rat_ogre_killed_mid_leap",
	source = "player_data"
}
player.rat_ogre_killed_without_dealing_damage = {
	value = 0,
	database_name = "rat_ogre_killed_without_dealing_damage",
	source = "player_data"
}
player.stormfiend_killed_without_burn_damage = {
	value = 0,
	database_name = "stormfiend_killed_without_burn_damage",
	source = "player_data"
}
player.stormfiend_killed_on_controller = {
	value = 0,
	database_name = "stormfiend_killed_on_controller",
	source = "player_data"
}
player.killed_lord_as_last_player_standing = {
	value = 0,
	database_name = "killed_lord_as_last_player_standing",
	source = "player_data"
}
player.collected_painting_scraps_generic = {
	value = 0,
	database_name = "collected_painting_scraps_generic",
	source = "player_data"
}
player.collected_painting_scraps_unlimited = {
	value = 0,
	database_name = "collected_painting_scraps_unlimited",
	source = "player_data"
}
player.collected_bogenhafen_cosmetics = {
	value = 0,
	database_name = "collected_bogenhafen_cosmetics"
}
player.played_levels_quickplay = {}
player.last_played_level_id = {
	value = 0,
	database_name = "last_played_level_id",
	sync_to_host = true
}
player.kills_total = {
	value = 0,
	sync_on_hot_join = true
}
player.kills_critter_total = {
	value = 0,
	sync_on_hot_join = true
}
player.kills_per_breed = {}
player.kills_per_breed_persistent = {}
player.kills_per_breed_difficulty = {}
player.kills_per_race = {}
player.kill_assists_per_breed = {}
player.kill_assists_per_breed_difficulty = {}
player.damage_taken = {
	value = 0,
	sync_on_hot_join = true
}
player.damage_dealt_per_breed = {}
player.damage_dealt_as_breed = {}
player.eliminations_as_breed = {}
player.completed_levels = {}
player.completed_levels_difficulty = {}
player.completed_career_levels = {}
player.played_difficulty = {}
player.weapon_kills_per_breed = {}
player.mission_streak = {}
player.dwarf_fest_secret_trolls_killed = {
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
player.completed_daily_quests = {
	value = 0,
	database_name = "completed_daily_quests",
	source = "player_data"
}
player.completed_weekly_quests = {
	value = 0,
	database_name = "completed_weekly_quests",
	source = "player_data"
}
player.played_levels_weekly_event = {}
player.completed_weekly_event_difficulty = {}
player.crafted_items = {
	value = 0,
	database_name = "crafted_items"
}
player.salvaged_items = {
	value = 0,
	database_name = "salvaged_items"
}
unit_test.kills_total = {
	value = 0,
	database_name = "kills_total"
}
unit_test.profiles = {
	witch_hunter = {
		kills_total = {
			value = 0
		}
	}
}

for k_3, v_3 in pairs(CareerSettings) do
	if k_3 ~= "empire_soldier_tutorial" then
		player.completed_career_levels[k_3] = {}

		for k_4, v_4 in pairs(LevelSettings) do
			if not table.contains(UnlockableLevels, k_4) then
				player.completed_career_levels[k_3][k_4] = {}

				for k_5, v_5 in pairs(DifficultySettings) do
					local str = "completed_career_levels_" .. k_3 .. "_" .. k_4 .. "_" .. k_5

					player.completed_career_levels[k_3][k_4][k_5] = {
						value = 0,
						source = "player_data",
						database_name = str
					}
				end
			end
		end
	end
end

player.min_health_percentage = {}
player.min_health_completed = {}

for k_6, v_6 in pairs(CareerSettings) do
	local breed = CareerSettings[k_6].breed

	if not breed and not breed.is_hero then
		player.min_health_percentage[k_6] = {
			value = 1
		}

		local str_2 = "min_health_completed_" .. k_6

		player.min_health_completed[k_6] = {
			value = 0,
			source = "player_data",
			database_name = str_2
		}
	end
end

for k_7, v_7 in pairs(DifficultySettings) do
	local str_3 = "played_difficulty_" .. k_7

	player.played_difficulty[k_7] = {
		value = 0,
		source = "player_data",
		database_name = str_3
	}

	local format_4 = string.format("completed_weekly_event_difficulty_%s", k_7)

	player.completed_weekly_event_difficulty[k_7] = {
		value = 0,
		source = "player_data",
		database_name = format_4
	}
end

for k_8, v_8 in pairs(Breeds) do
	player.kills_per_breed[k_8] = {
		value = 0,
		sync_on_hot_join = true,
		name = k_8
	}
	player.kills_per_breed_persistent[k_8] = {
		value = 0,
		source = "player_data",
		database_name = "kills_per_breed_persistent_" .. k_8
	}
	player.kill_assists_per_breed[k_8] = {
		value = 0,
		name = k_8
	}
	player.damage_dealt_per_breed[k_8] = {
		value = 0,
		name = k_8
	}

	local race = v_8.race

	if not (not race and player.kills_per_race[race]) then
		player.kills_per_race[race] = {
			value = 0,
			name = race
		}
	end

	player.kills_per_breed_difficulty[k_8] = {}
	player.kill_assists_per_breed_difficulty[k_8] = {}

	local DifficultySettings = DifficultySettings

	for k_9 in pairs(DifficultySettings) do
		player.kills_per_breed_difficulty[k_8][k_9] = {
			value = 0
		}
		player.kill_assists_per_breed_difficulty[k_8][k_9] = {
			value = 0
		}
	end
end

for k_10, v_9 in pairs(PlayerBreeds) do
	player.kills_per_breed[k_10] = {
		value = 0,
		sync_on_hot_join = true,
		name = k_10
	}
	player.kill_assists_per_breed[k_10] = {
		value = 0,
		name = k_10
	}
	player.damage_dealt_per_breed[k_10] = {
		value = 0,
		name = k_10
	}
	player.kills_per_breed_persistent[k_10] = {
		value = 0,
		source = "player_data",
		database_name = "kills_per_breed_persistent_" .. k_10
	}
	player.damage_dealt_as_breed[k_10] = {
		value = 0,
		source = "player_data",
		name = k_10,
		database_name = "damage_dealt_as_" .. k_10
	}
	player.eliminations_as_breed[k_10] = {
		value = 0,
		source = "player_data",
		name = k_10,
		database_name = "eliminations_as_" .. k_10
	}

	local race_2 = v_9.race

	if not (not race_2 and player.kills_per_race[race_2]) then
		player.kills_per_race[race_2] = {
			value = 0,
			name = race_2
		}
	end

	player.kills_per_breed_difficulty[k_10] = {}
	player.kill_assists_per_breed_difficulty[k_10] = {}

	local DifficultySettings_2 = DifficultySettings

	for k_11 in pairs(DifficultySettings_2) do
		player.kills_per_breed_difficulty[k_10][k_11] = {
			value = 0
		}
		player.kill_assists_per_breed_difficulty[k_10][k_11] = {
			value = 0
		}
	end
end

LevelDifficultyDBNames = {}

for k_12, v_10 in pairs(UnlockableLevels) do
	local flag = LevelSettings[v_10].dlc_name ~= nil
	local tbl_2 = {
		value = 0,
		sync_on_hot_join = true,
		sync_to_host = true,
		database_name = "completed_levels_" .. v_10
	}

	if not flag then
		tbl_2.source = "player_data"
	end

	player.completed_levels[v_10] = tbl_2

	local tbl_3 = {
		value = 0,
		sync_to_host = true,
		database_name = "played_levels_quickplay_" .. v_10
	}
	local tbl_4 = {
		value = 0,
		source = "player_data",
		sync_to_host = true,
		database_name = "played_levels_weekly_event_" .. v_10
	}

	if not flag then
		tbl_3.source = "player_data"
	end

	player.played_levels_quickplay[v_10] = tbl_3
	player.played_levels_weekly_event[v_10] = tbl_4

	local tbl_5 = {
		"bright_wizard",
		"wood_elf",
		"empire_soldier",
		"witch_hunter",
		"dwarf_ranger"
	}

	for i_2, v_11 in ipairs(tbl_5) do
		local str_4 = "completed_levels_" .. v_11
		local var_0_22 = player[str_4]
		local tbl_6 = {
			value = 0,
			database_name = str_4 .. "_" .. v_10
		}

		if not flag then
			tbl_6.source = "player_data"
		end

		var_0_22[v_10] = tbl_6
	end

	local str_5 = v_10 .. "_difficulty_completed"

	LevelDifficultyDBNames[v_10] = str_5

	local tbl_7 = {
		value = 0,
		sync_on_hot_join = true,
		database_name = str_5
	}

	if not flag then
		tbl_7.source = "player_data"
	end

	player.completed_levels_difficulty[str_5] = tbl_7

	local str_6 = "collected_grimoire_" .. v_10
	local tbl_8 = {
		value = 0,
		database_name = str_6
	}

	if not flag then
		tbl_8.source = "player_data"
	end

	player.collected_grimoires[v_10] = tbl_8

	local str_7 = "collected_tome_" .. v_10
	local tbl_9 = {
		value = 0,
		database_name = str_7
	}

	if not flag then
		tbl_9.source = "player_data"
	end

	player.collected_tomes[v_10] = tbl_9

	local str_8 = "collected_die_" .. v_10
	local tbl_10 = {
		value = 0,
		database_name = str_8
	}

	if not flag then
		tbl_10.source = "player_data"
	end

	player.collected_dice[v_10] = tbl_10

	local str_9 = "collected_painting_scraps_" .. v_10

	player.collected_painting_scraps[v_10] = {
		value = 0,
		source = "player_data",
		database_name = str_9
	}
end

DLCUtils.dofile_list("statistics_definitions")

local function fn(arg_1_0)
	-- function 1
	for k, v in pairs(arg_1_0) do
		if not v.value then
			fn(v)
		else
			v.name = k
		end
	end
end

fn(player)
fn(unit_test)
