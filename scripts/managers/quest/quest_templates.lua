-- chunkname: @scripts/managers/quest/quest_templates.lua

local quest_templates = {}

quest_templates.quests = {}

local daily_complete_quickplay_missions_mappings = {
	{
		played_levels_quickplay = {}
	}
}

for i = 1, #UnlockableLevels do
	local level_key = UnlockableLevels[i]
	local complete_quickplay_missions_mapping = daily_complete_quickplay_missions_mappings[1].played_levels_quickplay

	complete_quickplay_missions_mapping[level_key] = true
end

quest_templates.quests.daily_complete_quickplay_missions = {
	name = "quest_daily_complete_quickplay_missions_name",
	icon = "quest_book_skull",
	desc = function ()
		-- function 1
		return string.format(Localize("quest_daily_complete_quickplay_missions_desc"), QuestSettings.daily_complete_quickplay_missions)
	end,
	stat_mappings = daily_complete_quickplay_missions_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 2
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_complete_quickplay_missions
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 3
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_complete_quickplay_missions
		}
	end
}

local daily_collect_tomes_mappings = {
	{
		total_collected_tomes = true
	}
}

quest_templates.quests.daily_collect_tomes = {
	name = "quest_daily_collect_tomes_name",
	icon = "quest_book_tome",
	desc = function ()
		-- function 4
		return string.format(Localize("quest_daily_collect_tomes_desc"), QuestSettings.daily_collect_tomes)
	end,
	stat_mappings = daily_collect_tomes_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 5
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_collect_tomes
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 6
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_collect_tomes
		}
	end
}

local daily_collect_grimoires_mappings = {
	{
		total_collected_grimoires = true
	}
}

quest_templates.quests.daily_collect_grimoires = {
	name = "quest_daily_collect_grimoires_name",
	icon = "quest_book_grimoire",
	desc = function ()
		-- function 7
		return string.format(Localize("quest_daily_collect_grimoires_desc"), QuestSettings.daily_collect_grimoires)
	end,
	stat_mappings = daily_collect_grimoires_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 8
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_collect_grimoires
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 9
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_collect_grimoires
		}
	end
}

local daily_collect_loot_die_mappings = {
	{
		total_collected_dice = true
	}
}

quest_templates.quests.daily_collect_loot_die = {
	name = "quest_daily_collect_loot_die_name",
	icon = "quest_book_generic_pickup",
	desc = function ()
		-- function 10
		return string.format(Localize("quest_daily_collect_loot_die_desc"), QuestSettings.daily_collect_loot_die)
	end,
	stat_mappings = daily_collect_loot_die_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 11
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_collect_loot_die
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 12
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_collect_loot_die
		}
	end
}

local daily_collect_painting_scrap_mappings = {
	{
		collected_painting_scraps_unlimited = true
	}
}

quest_templates.quests.daily_collect_painting_scrap = {
	name = "quest_daily_collect_painting_scrap_name",
	icon = "quest_book_generic_pickup",
	desc = function ()
		-- function 13
		return string.format(Localize("quest_daily_collect_painting_scrap_desc"), QuestSettings.daily_collect_painting_scrap)
	end,
	stat_mappings = daily_collect_painting_scrap_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 14
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_collect_painting_scrap
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 15
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_collect_painting_scrap
		}
	end
}

local daily_kill_bosses_mappings = {
	{
		kills_per_breed = {
			chaos_troll = true,
			chaos_spawn = true,
			beastmen_minotaur = true,
			skaven_rat_ogre = true,
			skaven_stormfiend = true
		},
		kill_assists_per_breed = {
			chaos_troll = true,
			chaos_spawn = true,
			beastmen_minotaur = true,
			skaven_rat_ogre = true,
			skaven_stormfiend = true
		}
	}
}

quest_templates.quests.daily_kill_bosses = {
	name = "quest_daily_kill_bosses_name",
	icon = "quest_book_skull",
	desc = function ()
		-- function 16
		return string.format(Localize("quest_daily_kill_bosses_desc"), QuestSettings.daily_kill_bosses)
	end,
	stat_mappings = daily_kill_bosses_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 17
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_kill_bosses
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 18
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_kill_bosses
		}
	end
}

local daily_kill_elites_mappings = {
	{
		kills_per_breed = {},
		kill_assists_per_breed = {}
	}
}

for breed_name, _ in pairs(ELITES) do
	local kill_elites_mapping = daily_kill_elites_mappings[1].kills_per_breed
	local assist_kill_elites_mapping = daily_kill_elites_mappings[1].kill_assists_per_breed

	kill_elites_mapping[breed_name] = true
	assist_kill_elites_mapping[breed_name] = true
end

quest_templates.quests.daily_kill_elites = {
	name = "quest_daily_kill_elites_name",
	icon = "quest_book_skull",
	desc = function ()
		-- function 19
		return string.format(Localize("quest_daily_kill_elites_desc"), QuestSettings.daily_kill_elites)
	end,
	stat_mappings = daily_kill_elites_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 20
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_kill_elites
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 21
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_kill_elites
		}
	end
}

local daily_kill_critter_mappings = {
	{
		kills_critter_total = true
	}
}

quest_templates.quests.daily_kill_critters = {
	name = "quest_daily_kill_critters_name",
	icon = "quest_book_skull",
	desc = function ()
		-- function 22
		return string.format(Localize("quest_daily_kill_critters_desc"), QuestSettings.daily_kill_critters)
	end,
	stat_mappings = daily_kill_critter_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 23
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_kill_critters
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 24
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_kill_critters
		}
	end
}

local daily_complete_levels_hero_wood_elf_mappings = {
	{
		completed_levels_wood_elf = {}
	}
}

for i = 1, #UnlockableLevels do
	local level_key = UnlockableLevels[i]
	local complete_levels_hero_wood_elf_mapping = daily_complete_levels_hero_wood_elf_mappings[1].completed_levels_wood_elf

	complete_levels_hero_wood_elf_mapping[level_key] = true
end

quest_templates.quests.daily_complete_levels_hero_wood_elf = {
	name = "quest_daily_complete_levels_hero_wood_elf_name",
	icon = "quest_book_kerillian",
	desc = function ()
		-- function 25
		return string.format(Localize("quest_daily_complete_levels_hero_wood_elf_desc"), QuestSettings.daily_complete_levels_hero_wood_elf)
	end,
	stat_mappings = daily_complete_levels_hero_wood_elf_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 26
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_complete_levels_hero_wood_elf
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 27
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_complete_levels_hero_wood_elf
		}
	end
}

local daily_complete_levels_hero_witch_hunter_mappings = {
	{
		completed_levels_witch_hunter = {}
	}
}

for i = 1, #UnlockableLevels do
	local level_key = UnlockableLevels[i]
	local complete_levels_hero_witch_hunter_mapping = daily_complete_levels_hero_witch_hunter_mappings[1].completed_levels_witch_hunter

	complete_levels_hero_witch_hunter_mapping[level_key] = true
end

quest_templates.quests.daily_complete_levels_hero_witch_hunter = {
	name = "quest_daily_complete_levels_hero_witch_hunter_name",
	icon = "quest_book_saltzpyre",
	desc = function ()
		-- function 28
		return string.format(Localize("quest_daily_complete_levels_hero_witch_hunter_desc"), QuestSettings.daily_complete_levels_hero_witch_hunter)
	end,
	stat_mappings = daily_complete_levels_hero_witch_hunter_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 29
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_complete_levels_hero_witch_hunter
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 30
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_complete_levels_hero_witch_hunter
		}
	end
}

local daily_complete_levels_hero_dwarf_ranger_mappings = {
	{
		completed_levels_dwarf_ranger = {}
	}
}

for i = 1, #UnlockableLevels do
	local level_key = UnlockableLevels[i]
	local complete_levels_hero_dwarf_ranger_mapping = daily_complete_levels_hero_dwarf_ranger_mappings[1].completed_levels_dwarf_ranger

	complete_levels_hero_dwarf_ranger_mapping[level_key] = true
end

quest_templates.quests.daily_complete_levels_hero_dwarf_ranger = {
	name = "quest_daily_complete_levels_hero_dwarf_ranger_name",
	icon = "quest_book_bardin",
	desc = function ()
		-- function 31
		return string.format(Localize("quest_daily_complete_levels_hero_dwarf_ranger_desc"), QuestSettings.daily_complete_levels_hero_dwarf_ranger)
	end,
	stat_mappings = daily_complete_levels_hero_dwarf_ranger_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 32
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_complete_levels_hero_dwarf_ranger
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 33
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_complete_levels_hero_dwarf_ranger
		}
	end
}

local daily_complete_levels_hero_bright_wizard_mappings = {
	{
		completed_levels_bright_wizard = {}
	}
}

for i = 1, #UnlockableLevels do
	local level_key = UnlockableLevels[i]
	local complete_levels_hero_bright_wizard_mapping = daily_complete_levels_hero_bright_wizard_mappings[1].completed_levels_bright_wizard

	complete_levels_hero_bright_wizard_mapping[level_key] = true
end

quest_templates.quests.daily_complete_levels_hero_bright_wizard = {
	name = "quest_daily_complete_levels_hero_bright_wizard_name",
	icon = "quest_book_sienna",
	desc = function ()
		-- function 34
		return string.format(Localize("quest_daily_complete_levels_hero_bright_wizard_desc"), QuestSettings.daily_complete_levels_hero_bright_wizard)
	end,
	stat_mappings = daily_complete_levels_hero_bright_wizard_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 35
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_complete_levels_hero_bright_wizard
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 36
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_complete_levels_hero_bright_wizard
		}
	end
}

local daily_complete_levels_hero_empire_soldier_mappings = {
	{
		completed_levels_empire_soldier = {}
	}
}

for i = 1, #UnlockableLevels do
	local level_key = UnlockableLevels[i]
	local complete_levels_hero_empire_soldier_mapping = daily_complete_levels_hero_empire_soldier_mappings[1].completed_levels_empire_soldier

	complete_levels_hero_empire_soldier_mapping[level_key] = true
end

quest_templates.quests.daily_complete_levels_hero_empire_soldier = {
	name = "quest_daily_complete_levels_hero_empire_soldier_name",
	icon = "quest_book_kruber",
	desc = function ()
		-- function 37
		return string.format(Localize("quest_daily_complete_levels_hero_empire_soldier_desc"), QuestSettings.daily_complete_levels_hero_empire_soldier)
	end,
	stat_mappings = daily_complete_levels_hero_empire_soldier_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 38
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_complete_levels_hero_empire_soldier
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 39
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_complete_levels_hero_empire_soldier
		}
	end
}

local daily_score_headshots_mappings = {
	{
		headshots = true
	}
}

quest_templates.quests.daily_score_headshots = {
	name = "quest_daily_score_headshots_name",
	icon = "quest_book_skull",
	desc = function ()
		-- function 40
		return string.format(Localize("quest_daily_score_headshots_desc"), QuestSettings.daily_score_headshots)
	end,
	stat_mappings = daily_score_headshots_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 41
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.daily_score_headshots
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 42
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.daily_score_headshots
		}
	end
}

local event_quickplay_mappings = {
	{
		played_levels_quickplay = {}
	}
}
local event_weekly_mappings = {
	{
		played_levels_weekly_event = {}
	}
}

for i = 1, #UnlockableLevels do
	local level_key = UnlockableLevels[i]

	event_quickplay_mappings[1].played_levels_quickplay[level_key] = true
	event_weekly_mappings[1].played_levels_weekly_event[level_key] = true
end

quest_templates.quests.event_skulls_for_the_skull_throne = {
	name = "quest_event_skull_2018_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function ()
		-- function 43
		return string.format(Localize("quest_event_skull_2018_desc"), QuestSettings.event_skulls_quickplay)
	end,
	stat_mappings = event_quickplay_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 44
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_skulls_quickplay
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 45
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_skulls_quickplay
		}
	end
}
quest_templates.quests.event_sonnstill_quickplay_2018 = {
	name = "quest_event_summer_2018_quickplay_name",
	icon = "quest_book_event_summer",
	desc = function ()
		-- function 46
		return string.format(Localize("quest_event_summer_2018_quickplay_desc"), QuestSettings.event_sonnstill_quickplay_levels)
	end,
	stat_mappings = event_quickplay_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 47
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_sonnstill_quickplay_levels
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 48
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_sonnstill_quickplay_levels
		}
	end
}

local event_sonnstill_played_champion_mappings_2018 = {
	{
		played_difficulty = {
			harder = true,
			hardest = true
		}
	}
}

quest_templates.quests.event_sonnstill_played_champion_2018 = {
	name = "quest_event_summer_2018_champion_name",
	icon = "quest_book_event_summer",
	desc = function ()
		-- function 49
		return string.format(Localize("quest_event_summer_2018_champion_desc"), QuestSettings.event_sonnstill_difficulty_levels)
	end,
	stat_mappings = event_sonnstill_played_champion_mappings_2018,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 50
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_sonnstill_difficulty_levels
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 51
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_sonnstill_quickplay_levels
		}
	end
}

local event_sonnstill_played_legend_mappings_2018 = {
	{
		played_difficulty = {
			hardest = true
		}
	}
}

quest_templates.quests.event_sonnstill_played_legend_2018 = {
	name = "quest_event_summer_2018_legend_name",
	icon = "quest_book_event_summer",
	desc = function ()
		-- function 52
		return string.format(Localize("quest_event_summer_2018_legend_desc"), QuestSettings.event_sonnstill_difficulty_levels)
	end,
	stat_mappings = event_sonnstill_played_legend_mappings_2018,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 53
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_sonnstill_difficulty_levels
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 54
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_sonnstill_quickplay_levels
		}
	end
}
quest_templates.quests.event_geheimnisnacht_quickplay_2018 = {
	name = "quest_event_geheimnisnacht_2018_quickplay_name",
	icon = "quest_book_geheimnisnacht",
	desc = function ()
		-- function 55
		return string.format(Localize("quest_event_summer_2018_quickplay_desc"), QuestSettings.event_geheimnisnacht_quickplay_levels)
	end,
	stat_mappings = event_quickplay_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 56
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_geheimnisnacht_quickplay_levels
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 57
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_geheimnisnacht_quickplay_levels
		}
	end
}
quest_templates.quests.event_geheimnisnacht_quickplay_2019 = {
	name = "quest_event_geheimnisnacht_2019_quickplay_name",
	icon = "quest_book_geheimnisnacht",
	desc = function ()
		-- function 58
		return string.format(Localize("quest_event_summer_2018_quickplay_desc"), QuestSettings.event_geheimnisnacht_quickplay_levels)
	end,
	stat_mappings = event_quickplay_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 59
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_geheimnisnacht_quickplay_levels
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 60
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_geheimnisnacht_quickplay_levels
		}
	end
}
quest_templates.quests.event_geheimnisnacht_weekly_event_2019 = {
	name = "quest_event_geheimnisnacht_weekly_event_2019_name",
	icon = "quest_book_geheimnisnacht",
	desc = "complete_one_weekly_event",
	stat_mappings = event_weekly_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 61
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0
	end
}

local event_geheimnisnacht_played_champion_mappings_2018 = {
	{
		played_difficulty = {
			harder = true,
			hardest = true
		}
	}
}

quest_templates.quests.event_geheimnisnacht_played_champion_2018 = {
	name = "quest_event_geheimnisnacht_2018_champion_name",
	icon = "quest_book_geheimnisnacht",
	desc = function ()
		-- function 62
		return string.format(Localize("quest_event_summer_2018_champion_desc"), QuestSettings.event_geheimnisnacht_difficulty_levels)
	end,
	stat_mappings = event_geheimnisnacht_played_champion_mappings_2018,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 63
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_geheimnisnacht_difficulty_levels
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 64
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_geheimnisnacht_quickplay_levels
		}
	end
}

local event_geheimnisnacht_played_legend_mappings_2018 = {
	{
		played_difficulty = {
			hardest = true
		}
	}
}

quest_templates.quests.event_geheimnisnacht_played_legend_2018 = {
	name = "quest_event_geheimnisnacht_2018_legend_name",
	icon = "quest_book_geheimnisnacht",
	desc = function ()
		-- function 65
		return string.format(Localize("quest_event_summer_2018_legend_desc"), QuestSettings.event_geheimnisnacht_difficulty_levels)
	end,
	stat_mappings = event_geheimnisnacht_played_legend_mappings_2018,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 66
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_geheimnisnacht_difficulty_levels
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 67
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_geheimnisnacht_quickplay_levels
		}
	end
}
quest_templates.quests.event_mondstille_bonfires_2018 = {
	name = "quest_mondstille_01_name",
	icon = "quest_book_mondstille",
	desc = "quest_mondstille_01_desc",
	completed = function (statistics_db, stats_id)
		-- function 68
		if statistics_db:get_persistent_stat(stats_id, "bonfire_lit_mines") > 0 and statistics_db:get_persistent_stat(stats_id, "bonfire_lit_fort") > 0 and statistics_db:get_persistent_stat(stats_id, "bonfire_lit_warcamp") > 0 and statistics_db:get_persistent_stat(stats_id, "bonfire_lit_skittergate") > 0 then
			return true
		end

		return false
	end,
	progress = function (statistics_db, stats_id)
		-- function 69
		local count = 0

		if statistics_db:get_persistent_stat(stats_id, "bonfire_lit_mines") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "bonfire_lit_fort") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "bonfire_lit_warcamp") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "bonfire_lit_skittergate") > 0 then
			count = count + 1
		end

		return {
			count,
			4
		}
	end,
	requirements = function (statistics_db, stats_id)
		-- function 70
		local mines = statistics_db:get_persistent_stat(stats_id, "bonfire_lit_mines") > 0
		local fort = statistics_db:get_persistent_stat(stats_id, "bonfire_lit_fort") > 0
		local warcamp = statistics_db:get_persistent_stat(stats_id, "bonfire_lit_warcamp") > 0
		local skittergate = statistics_db:get_persistent_stat(stats_id, "bonfire_lit_skittergate") > 0

		return {
			{
				name = "level_name_mines",
				completed = mines
			},
			{
				name = "level_name_forest_fort",
				completed = fort
			},
			{
				name = "level_name_warcamp",
				completed = warcamp
			},
			{
				name = "level_name_skittergate",
				completed = skittergate
			}
		}
	end
}

local event_mondstille_played_legend_mappings_2018 = {
	{
		played_difficulty = {
			hardest = true
		}
	}
}

quest_templates.quests.event_mondstille_played_legend_2018 = {
	name = "quest_mondstille_03_name",
	icon = "quest_book_mondstille",
	desc = "quest_mondstille_03_desc",
	stat_mappings = event_mondstille_played_legend_mappings_2018,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 71
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_mondstille_quickplay_legend_levels
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 72
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_mondstille_quickplay_legend_levels
		}
	end
}
quest_templates.quests.event_mondstille_quickplay_console = {
	name = "quest_mondstille_01_name",
	icon = "quest_book_mondstille",
	desc = function ()
		-- function 73
		return string.format(Localize("quest_event_summer_2018_quickplay_desc"), QuestSettings.event_sonnstill_quickplay_levels)
	end,
	stat_mappings = event_quickplay_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 74
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_sonnstill_quickplay_levels
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 75
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_sonnstill_quickplay_levels
		}
	end
}
quest_templates.quests.event_celebration_complete_2020 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = event_weekly_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 76
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0
	end
}
quest_templates.quests.event_celebration_complete_2023 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = event_weekly_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 77
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0
	end
}
quest_templates.quests.event_celebration_complete_2024 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = event_weekly_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 78
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0
	end
}
quest_templates.quests.event_celebration_complete_2025 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = event_weekly_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 79
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0
	end
}
quest_templates.quests.event_celebration_complete_2026 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = event_weekly_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 80
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0
	end
}

local event_celebration_collected_painting_scraps_2019_mappings = {
	{
		collected_painting_scraps_unlimited = true
	}
}

quest_templates.quests.event_celebration_complete_2019 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	completed = function (statistics_db, stats_id, quest_key)
		-- function 81
		return statistics_db:get_persistent_stat(stats_id, "completed_levels", "dlc_celebrate_crawl") > 0
	end
}
quest_templates.quests.event_celebration_drink_all_ale_2019 = {
	name = "quest_celebration_02_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_02_desc",
	completed = function (statistics_db, stats_id, quest_key)
		-- function 82
		return statistics_db:get_persistent_stat(stats_id, "crawl_total_ales_drunk") >= QuestSettings.event_crawl_drink_all_ale_amount
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 83
		local count = statistics_db:get_persistent_stat(stats_id, "crawl_total_ales_drunk")

		return {
			count,
			QuestSettings.event_crawl_drink_all_ale_amount
		}
	end
}
quest_templates.quests.event_celebration_collect_painting_scraps_2019 = {
	name = "painting_manaan01_name",
	icon = "quest_book_event_celebration",
	desc = function ()
		-- function 84
		return string.format(Localize("achv_gecko_scraps_generic_1_desc"), QuestSettings.event_celebration_collect_painting_scraps)
	end,
	stat_mappings = event_celebration_collected_painting_scraps_2019_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 85
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_celebration_collect_painting_scraps
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 86
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_celebration_collect_painting_scraps
		}
	end
}
quest_templates.quests.event_skulls_quickplay_2019 = {
	name = "quest_event_skulls_quickplay_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function ()
		-- function 87
		return string.format(Localize("quest_event_skulls_quickplay_2019_desc"), QuestSettings.event_skulls_quickplay)
	end,
	stat_mappings = event_quickplay_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 88
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_skulls_quickplay
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 89
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_skulls_quickplay
		}
	end
}
quest_templates.quests.event_skulls_weekly_event_2019 = {
	name = "quest_event_skulls_weekly_event_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "complete_one_weekly_event",
	stat_mappings = event_weekly_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 90
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0
	end
}

local event_skulls_collected_painting_scraps_2019_mappings = {
	{
		collected_painting_scraps_unlimited = true
	}
}

quest_templates.quests.event_skulls_painting_scraps_2019 = {
	name = "quest_event_skulls_painting_scraps_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function ()
		-- function 91
		return string.format(Localize("quest_event_skulls_painting_scraps_2019_desc"), QuestSettings.event_skulls_collect_painting_scraps)
	end,
	stat_mappings = event_skulls_collected_painting_scraps_2019_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 92
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_skulls_collect_painting_scraps
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 93
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_skulls_collect_painting_scraps
		}
	end
}

local event_skulls_warcamp_mapping = {
	{
		completed_levels = {
			warcamp = true
		}
	}
}

quest_templates.quests.event_skulls_warcamp_2019 = {
	name = "quest_event_skulls_warcamp_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "quest_event_skulls_warcamp_2019_desc",
	stat_mappings = event_skulls_warcamp_mapping,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 94
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0
	end,
	requirements = function (statistics_db, stats_id, quest_key)
		-- function 95
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local defeated_bodvarr = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0

		return {
			{
				name = "mission_warcamp_kill_chieftain",
				completed = defeated_bodvarr
			}
		}
	end
}
quest_templates.quests.event_skulls_quickplay_2020 = {
	name = "quest_event_skulls_quickplay_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function ()
		-- function 96
		return string.format(Localize("quest_event_skulls_quickplay_2019_desc"), QuestSettings.event_skulls_quickplay)
	end,
	stat_mappings = event_quickplay_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 97
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_skulls_quickplay
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 98
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_skulls_quickplay
		}
	end
}
quest_templates.quests.event_skulls_weekly_event_2020 = {
	name = "quest_event_skulls_weekly_event_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "complete_one_weekly_event",
	stat_mappings = event_weekly_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 99
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0
	end
}
quest_templates.quests.event_skulls_painting_scraps_2020 = {
	name = "quest_event_skulls_painting_scraps_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function ()
		-- function 100
		return string.format(Localize("quest_event_skulls_painting_scraps_2019_desc"), QuestSettings.event_skulls_collect_painting_scraps)
	end,
	stat_mappings = event_skulls_collected_painting_scraps_2019_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 101
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.event_skulls_collect_painting_scraps
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 102
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.event_skulls_collect_painting_scraps
		}
	end
}
quest_templates.quests.event_skulls_warcamp_2020 = {
	name = "quest_event_skulls_warcamp_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "quest_event_skulls_warcamp_2019_desc",
	stat_mappings = event_skulls_warcamp_mapping,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 103
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0
	end,
	requirements = function (statistics_db, stats_id, quest_key)
		-- function 104
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local defeated_bodvarr = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0

		return {
			{
				name = "mission_warcamp_kill_chieftain",
				completed = defeated_bodvarr
			}
		}
	end
}
quest_templates.quests.quest_event_rat_weekly_event_2020 = {
	name = "quest_event_rat_weekly_event_2020_name",
	icon = "quest_book_year_of_the_rat",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "complete_one_weekly_event",
	stat_mappings = event_weekly_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 105
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0
	end
}

local quest_event_rat_kill_skaven_2020_mapping = {
	{
		kills_per_race = {
			skaven = true
		}
	}
}

quest_templates.quests.quest_event_rat_kill_skaven_2020 = {
	name = "quest_event_rat_kill_skaven_2020_name",
	icon = "quest_book_year_of_the_rat",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function ()
		-- function 106
		return string.format(Localize("quest_event_rat_kill_skaven_2020_desc"), QuestSettings.quest_event_rat_kill_skaven_2020)
	end,
	stat_mappings = quest_event_rat_kill_skaven_2020_mapping,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 107
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.quest_event_rat_kill_skaven_2020
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 108
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			QuestSettings.quest_event_rat_kill_skaven_2020
		}
	end
}

local quest_event_rat_kill_skaven_lords_2020_mapping = {
	{
		completed_levels = {
			[LevelSettings.skittergate.level_id] = true
		}
	},
	{
		completed_levels = {
			[LevelSettings.skaven_stronghold.level_id] = true
		}
	}
}

quest_templates.quests.quest_event_rat_kill_skaven_lords_2020 = {
	name = "quest_event_rat_kill_skaven_lords_2020_name",
	icon = "quest_book_year_of_the_rat",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "quest_event_rat_kill_skaven_lords_2020_desc",
	stat_mappings = quest_event_rat_kill_skaven_lords_2020_mapping,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 109
		local stat_name_1 = QuestSettings.stat_mappings[quest_key][1]
		local gray_seer_completed = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name_1) > 0
		local stat_name_2 = QuestSettings.stat_mappings[quest_key][2]
		local storm_vermin_completed = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name_2) > 0

		return gray_seer_completed and storm_vermin_completed
	end,
	requirements = function (statistics_db, stats_id, quest_key)
		-- function 110
		local stat_name_1 = QuestSettings.stat_mappings[quest_key][1]
		local gray_seer_completed = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name_1) > 0
		local stat_name_2 = QuestSettings.stat_mappings[quest_key][2]
		local storm_vermin_completed = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name_2) > 0

		return {
			{
				name = "skaven_storm_vermin_warlord",
				completed = storm_vermin_completed
			},
			{
				name = "skaven_grey_seer",
				completed = gray_seer_completed
			}
		}
	end
}

local function _generate_troll_quests(repeatable, year)
	-- function 111
	local _next_troll_fest_order = 0

	local function get_next_troll_fest_order()
		-- function 112
		_next_troll_fest_order = _next_troll_fest_order + 1

		return _next_troll_fest_order
	end

	quest_templates.quests["quest_event_dwarf_fest_trollkiller" .. year .. (repeatable and "_repeatable" or not repeatable and "")] = {
		name = "quest_event_dwarf_fest_trollkiller_name",
		icon = "quest_book_event_dwarf_fest",
		desc = repeatable and function ()
			-- function 113
			return string.format("%s (%s)", string.format(Localize("quest_event_dwarf_fest_trollkiller_desc"), QuestSettings.quest_event_dwarf_fest_trollkiller), Localize("repeatable"))
		end or not repeatable and function ()
			-- function 114
			return string.format(Localize("quest_event_dwarf_fest_trollkiller_desc"), QuestSettings.quest_event_dwarf_fest_trollkiller)
		end,
		custom_order = get_next_troll_fest_order(),
		stat_mappings = {
			{
				kills_per_breed = {
					chaos_troll_chief = true,
					vs_chaos_troll = true,
					chaos_troll = true
				},
				kill_assists_per_breed = {
					chaos_troll_chief = true,
					vs_chaos_troll = true,
					chaos_troll = true
				}
			}
		},
		completed = function (statistics_db, stats_id, quest_key)
			-- function 115
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.quest_event_dwarf_fest_trollkiller
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 116
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.quest_event_dwarf_fest_trollkiller
			}
		end
	}

	local secret_trolls_stat_mappings = {
		{
			dwarf_fest_secret_trolls_killed = {
				first = true
			}
		},
		{
			dwarf_fest_secret_trolls_killed = {
				second = true
			}
		},
		{
			dwarf_fest_secret_trolls_killed = {
				third = true
			}
		}
	}

	if repeatable then
		get_next_troll_fest_order()
	else
		local secret_troll_names = {
			"name_dwarf_fest_troll_001",
			"name_dwarf_fest_troll_002",
			"name_dwarf_fest_troll_003"
		}
		local num_trolls = #secret_trolls_stat_mappings

		quest_templates.quests["quest_event_dwarf_fest_secret_trolls" .. year] = {
			name = "quest_event_dwarf_fest_secret_trolls_name",
			icon = "quest_book_event_dwarf_fest",
			desc = function ()
				-- function 117
				return string.format(Localize("quest_event_dwarf_fest_secret_trolls_desc"), Localize(secret_troll_names[1]), Localize(secret_troll_names[2]), Localize(secret_troll_names[3]), Localize("level_name_dlc_dwarf_fest"))
			end,
			custom_order = get_next_troll_fest_order(),
			stat_mappings = secret_trolls_stat_mappings,
			completed = function (statistics_db, stats_id, quest_key)
				-- function 118
				for i = 1, num_trolls do
					local stat_name = QuestSettings.stat_mappings[quest_key][i]

					if statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) <= 0 then
						return false
					end
				end

				return true
			end,
			progress = function (statistics_db, stats_id, quest_key)
				-- function 119
				local count = 0

				for i = 1, num_trolls do
					local stat_name = QuestSettings.stat_mappings[quest_key][i]

					count = count + math.min(statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name), 1)
				end

				return {
					count,
					num_trolls
				}
			end,
			requirements = function (statistics_db, stats_id, quest_key)
				-- function 120
				local reqs = {}

				for i = 1, num_trolls do
					local stat_name = QuestSettings.stat_mappings[quest_key][i]
					local completed = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) > 0

					table.insert(reqs, {
						name = secret_troll_names[i],
						completed = completed
					})
				end

				return reqs
			end
		}
	end

	local function add_troll_chief_challenge(id, difficulty_name)
		-- function 121
		local stat_mappings = {
			{
				kills_per_breed_difficulty = {
					chaos_troll_chief = {}
				},
				kill_assists_per_breed_difficulty = {
					chaos_troll_chief = {}
				}
			}
		}
		local rank = DifficultySettings[difficulty_name].rank

		for other_difficulty_name, difficulty_setting in pairs(DifficultySettings) do
			if rank <= difficulty_setting.rank then
				stat_mappings[1].kills_per_breed_difficulty.chaos_troll_chief[other_difficulty_name] = true
				stat_mappings[1].kill_assists_per_breed_difficulty.chaos_troll_chief[other_difficulty_name] = true
			end
		end

		quest_templates.quests["quest_event_" .. id .. year .. (repeatable and "_repeatable" or not repeatable and "")] = {
			icon = "quest_book_event_dwarf_fest",
			name = "quest_event_" .. id .. "_name",
			desc = repeatable and function ()
				-- function 122
				return string.format("%s (%s)", string.format(Localize("quest_event_dwarf_fest_troll_chief_desc"), Localize("chaos_troll_chief"), Localize(DifficultySettings[difficulty_name].display_name)), Localize("repeatable"))
			end or not repeatable and function ()
				-- function 123
				return string.format(Localize("quest_event_dwarf_fest_troll_chief_desc"), Localize("chaos_troll_chief"), Localize(DifficultySettings[difficulty_name].display_name))
			end,
			custom_order = get_next_troll_fest_order(),
			stat_mappings = stat_mappings,
			completed = function (statistics_db, stats_id, quest_key)
				-- function 124
				local stat_name = QuestSettings.stat_mappings[quest_key][1]

				return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 1
			end,
			progress = function (statistics_db, stats_id, quest_key)
				-- function 125
				local stat_name = QuestSettings.stat_mappings[quest_key][1]
				local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

				return {
					count,
					1
				}
			end
		}
	end

	for i = 1, #DefaultDifficulties do
		local difficulty_name = DefaultDifficulties[i]
		local player_facing_name = DifficultyMapping[difficulty_name]
		local name = "dwarf_fest_troll_chief_" .. player_facing_name

		add_troll_chief_challenge(name, difficulty_name)
	end
end

_generate_troll_quests(false, "")
_generate_troll_quests(true, "")
_generate_troll_quests(false, "_2026")
_generate_troll_quests(true, "_2026")

local weekly_complete_quickplay_missions_mappings = {
	{
		played_levels_quickplay = {}
	}
}
local weekly_complete_weekly_event_missions_mappings = {
	{
		played_levels_weekly_event = {}
	}
}

for i = 1, #UnlockableLevels do
	local level_key = UnlockableLevels[i]
	local complete_quickplay_missions_mapping = weekly_complete_quickplay_missions_mappings[1].played_levels_quickplay
	local complete_weekly_event_missions_mapping = weekly_complete_weekly_event_missions_mappings[1].played_levels_weekly_event

	complete_quickplay_missions_mapping[level_key] = true
	complete_weekly_event_missions_mapping[level_key] = true
end

quest_templates.quests.weekly_complete_quickplay_missions = {
	name = "quest_daily_complete_quickplay_missions_name",
	icon = "quest_book_skull",
	desc = function ()
		-- function 126
		return string.format(Localize("quest_daily_complete_quickplay_missions_desc"), 25)
	end,
	stat_mappings = weekly_complete_quickplay_missions_mappings,
	completed = function (statistics_db, stats_id, quest_key)
		-- function 127
		local stat_name = QuestSettings.stat_mappings[quest_key][1]

		return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= 25
	end,
	progress = function (statistics_db, stats_id, quest_key)
		-- function 128
		local stat_name = QuestSettings.stat_mappings[quest_key][1]
		local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

		return {
			count,
			25
		}
	end
}

for i = 1, 3 do
	local id = "weekly_complete_quickplay_missions" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_complete_quickplay_missions_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 129
			return string.format(Localize("quest_daily_complete_quickplay_missions_desc"), QuestSettings.weekly_complete_quickplay_missions[i])
		end,
		stat_mappings = weekly_complete_quickplay_missions_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 130
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_complete_quickplay_missions[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 131
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_complete_quickplay_missions[i]
			}
		end
	}
end

for i = 1, 3 do
	local id = "weekly_complete_weekly_event_missions" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_complete_weekly_quest_missions_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 132
			return string.format(Localize("quest_daily_complete_weekly_event_missions_desc"), QuestSettings.weekly_complete_weekly_event_missions[i])
		end,
		stat_mappings = weekly_complete_weekly_event_missions_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 133
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_complete_weekly_event_missions[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 134
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_complete_weekly_event_missions[i]
			}
		end
	}
end

local weekly_collect_tomes_mappings = {
	{
		total_collected_tomes = true
	}
}

for i = 1, 3 do
	local id = "weekly_collect_tomes" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_collect_tomes_name",
		icon = "quest_book_tome",
		desc = function ()
			-- function 135
			return string.format(Localize("quest_daily_collect_tomes_desc"), QuestSettings.weekly_collect_tomes[i])
		end,
		stat_mappings = weekly_collect_tomes_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 136
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_collect_tomes[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 137
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_collect_tomes[i]
			}
		end
	}
end

local weekly_collect_grimoires_mappings = {
	{
		total_collected_grimoires = true
	}
}

for i = 1, 3 do
	local id = "weekly_collect_grimoires" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_collect_grimoires_name",
		icon = "quest_book_grimoire",
		desc = function ()
			-- function 138
			return string.format(Localize("quest_daily_collect_grimoires_desc"), QuestSettings.weekly_collect_grimoires[i])
		end,
		stat_mappings = weekly_collect_grimoires_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 139
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_collect_grimoires[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 140
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_collect_grimoires[i]
			}
		end
	}
end

local weekly_collect_dice_mappings = {
	{
		total_collected_dice = true
	}
}

for i = 1, 3 do
	local id = "weekly_collect_dice" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_collect_loot_die_name",
		icon = "quest_book_generic_pickup",
		desc = function ()
			-- function 141
			return string.format(Localize("quest_daily_collect_loot_die_desc"), QuestSettings.weekly_collect_dice[i])
		end,
		stat_mappings = weekly_collect_dice_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 142
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_collect_dice[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 143
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_collect_dice[i]
			}
		end
	}
end

local weekly_collect_painting_scrap_mappings = {
	{
		collected_painting_scraps_unlimited = true
	}
}

for i = 1, 3 do
	local id = "weekly_collect_painting_scrap" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_collect_painting_scrap_name",
		icon = "quest_book_generic_pickup",
		desc = function ()
			-- function 144
			return string.format(Localize("quest_daily_collect_painting_scrap_desc"), QuestSettings.weekly_collect_painting_scrap[i])
		end,
		stat_mappings = weekly_collect_painting_scrap_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 145
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_collect_painting_scrap[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 146
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_collect_painting_scrap[i]
			}
		end
	}
end

local weekly_kill_critter_mappings = {
	{
		kills_critter_total = true
	}
}

for i = 1, 3 do
	local id = "weekly_kill_critters_" .. i

	quest_templates.quests[id] = {
		name = "quest_weekly_kill_critters_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 147
			return string.format(Localize("quest_weekly_kill_critters_desc"), QuestSettings.weekly_kill_critters[i])
		end,
		stat_mappings = weekly_kill_critter_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 148
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_kill_critters[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 149
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_kill_critters[i]
			}
		end
	}
end

local weekly_kill_bosses_mappings = {
	{
		kills_per_breed = {
			chaos_troll = true,
			chaos_spawn = true,
			beastmen_minotaur = true,
			skaven_rat_ogre = true,
			skaven_stormfiend = true
		},
		kill_assists_per_breed = {
			chaos_troll = true,
			chaos_spawn = true,
			beastmen_minotaur = true,
			skaven_rat_ogre = true,
			skaven_stormfiend = true
		}
	}
}

for i = 1, 3 do
	local id = "weekly_kill_bosses" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_kill_bosses_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 150
			return string.format(Localize("quest_daily_kill_bosses_desc"), QuestSettings.weekly_kill_bosses[i])
		end,
		stat_mappings = weekly_kill_bosses_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 151
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_kill_bosses[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 152
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_kill_bosses[i]
			}
		end
	}
end

local weekly_kill_elites_mappings = {
	{
		kills_per_breed = {},
		kill_assists_per_breed = {}
	}
}

for breed_name, _ in pairs(ELITES) do
	local kill_elites_mapping = weekly_kill_elites_mappings[1].kills_per_breed
	local assist_kill_elites_mapping = weekly_kill_elites_mappings[1].kill_assists_per_breed

	kill_elites_mapping[breed_name] = true
	assist_kill_elites_mapping[breed_name] = true
end

for i = 1, 3 do
	local id = "weekly_kill_elites" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_kill_elites_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 153
			return string.format(Localize("quest_daily_kill_elites_desc"), QuestSettings.weekly_kill_elites[i])
		end,
		stat_mappings = weekly_kill_elites_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 154
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_kill_elites[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 155
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_kill_elites[i]
			}
		end
	}
end

local weekly_complete_levels_hero_wood_elf_mappings = {
	{
		completed_levels_wood_elf = {}
	}
}

for i = 1, #UnlockableLevels do
	local level_key = UnlockableLevels[i]
	local complete_levels_hero_wood_elf_mapping = weekly_complete_levels_hero_wood_elf_mappings[1].completed_levels_wood_elf

	complete_levels_hero_wood_elf_mapping[level_key] = true
end

for i = 1, 3 do
	local id = "weekly_complete_levels_hero_wood_elf" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_complete_levels_hero_wood_elf_name",
		icon = "quest_book_kerillian",
		desc = function ()
			-- function 156
			return string.format(Localize("quest_daily_complete_levels_hero_wood_elf_desc"), QuestSettings.weekly_complete_levels_hero_wood_elf[i])
		end,
		stat_mappings = weekly_complete_levels_hero_wood_elf_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 157
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_complete_levels_hero_wood_elf[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 158
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_complete_levels_hero_wood_elf[i]
			}
		end
	}
end

local weekly_complete_levels_hero_witch_hunter_mappings = {
	{
		completed_levels_witch_hunter = {}
	}
}

for i = 1, #UnlockableLevels do
	local level_key = UnlockableLevels[i]
	local complete_levels_hero_witch_hunter_mapping = weekly_complete_levels_hero_witch_hunter_mappings[1].completed_levels_witch_hunter

	complete_levels_hero_witch_hunter_mapping[level_key] = true
end

for i = 1, 3 do
	local id = "weekly_complete_levels_hero_witch_hunter" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_complete_levels_hero_witch_hunter_name",
		icon = "quest_book_saltzpyre",
		desc = function ()
			-- function 159
			return string.format(Localize("quest_daily_complete_levels_hero_witch_hunter_desc"), QuestSettings.weekly_complete_levels_hero_witch_hunter[i])
		end,
		stat_mappings = weekly_complete_levels_hero_witch_hunter_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 160
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_complete_levels_hero_witch_hunter[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 161
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_complete_levels_hero_witch_hunter[i]
			}
		end
	}
end

local weekly_complete_levels_hero_dwarf_ranger_mappings = {
	{
		completed_levels_dwarf_ranger = {}
	}
}

for i = 1, #UnlockableLevels do
	local level_key = UnlockableLevels[i]
	local complete_levels_hero_dwarf_ranger_mapping = weekly_complete_levels_hero_dwarf_ranger_mappings[1].completed_levels_dwarf_ranger

	complete_levels_hero_dwarf_ranger_mapping[level_key] = true
end

for i = 1, 3 do
	local id = "weekly_complete_levels_hero_dwarf_ranger" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_complete_levels_hero_dwarf_ranger_name",
		icon = "quest_book_bardin",
		desc = function ()
			-- function 162
			return string.format(Localize("quest_daily_complete_levels_hero_dwarf_ranger_desc"), QuestSettings.weekly_complete_levels_hero_dwarf_ranger[i])
		end,
		stat_mappings = weekly_complete_levels_hero_dwarf_ranger_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 163
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_complete_levels_hero_dwarf_ranger[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 164
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_complete_levels_hero_dwarf_ranger[i]
			}
		end
	}
end

local weekly_complete_levels_hero_bright_wizard_mappings = {
	{
		completed_levels_bright_wizard = {}
	}
}

for i = 1, #UnlockableLevels do
	local level_key = UnlockableLevels[i]
	local complete_levels_hero_bright_wizard_mapping = weekly_complete_levels_hero_bright_wizard_mappings[1].completed_levels_bright_wizard

	complete_levels_hero_bright_wizard_mapping[level_key] = true
end

for i = 1, 3 do
	local id = "weekly_complete_levels_hero_bright_wizard" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_complete_levels_hero_bright_wizard_name",
		icon = "quest_book_sienna",
		desc = function ()
			-- function 165
			return string.format(Localize("quest_daily_complete_levels_hero_bright_wizard_desc"), QuestSettings.weekly_complete_levels_hero_bright_wizard[i])
		end,
		stat_mappings = weekly_complete_levels_hero_bright_wizard_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 166
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_complete_levels_hero_bright_wizard[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 167
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_complete_levels_hero_bright_wizard[i]
			}
		end
	}
end

local weekly_complete_levels_hero_empire_soldier_mappings = {
	{
		completed_levels_empire_soldier = {}
	}
}

for i = 1, #UnlockableLevels do
	local level_key = UnlockableLevels[i]
	local complete_levels_hero_empire_soldier_mapping = weekly_complete_levels_hero_empire_soldier_mappings[1].completed_levels_empire_soldier

	complete_levels_hero_empire_soldier_mapping[level_key] = true
end

for i = 1, 3 do
	local id = "weekly_complete_levels_hero_empire_soldier" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_complete_levels_hero_empire_soldier_name",
		icon = "quest_book_kruber",
		desc = function ()
			-- function 168
			return string.format(Localize("quest_daily_complete_levels_hero_empire_soldier_desc"), QuestSettings.weekly_complete_levels_hero_empire_soldier[i])
		end,
		stat_mappings = weekly_complete_levels_hero_empire_soldier_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 169
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_complete_levels_hero_empire_soldier[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 170
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_complete_levels_hero_empire_soldier[i]
			}
		end
	}
end

local weekly_score_headshots_mappings = {
	{
		headshots = true
	}
}

for i = 1, 3 do
	local id = "weekly_score_headshots" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_daily_score_headshots_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 171
			return string.format(Localize("quest_daily_score_headshots_desc"), QuestSettings.weekly_score_headshots[i])
		end,
		stat_mappings = weekly_score_headshots_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 172
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_score_headshots[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 173
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_score_headshots[i]
			}
		end
	}
end

local weekly_daily_quests_mappings = {
	{
		completed_daily_quests = true
	}
}

for i = 1, 3 do
	local id = "weekly_daily_quests" .. "_" .. i

	quest_templates.quests[id] = {
		name = "quest_weekly_daily_quests_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 174
			return string.format(Localize("quest_weekly_daily_quests_desc"), QuestSettings.weekly_daily_quests[i])
		end,
		stat_mappings = weekly_daily_quests_mappings,
		completed = function (statistics_db, stats_id, quest_key)
			-- function 175
			local stat_name = QuestSettings.stat_mappings[quest_key][1]

			return statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name) >= QuestSettings.weekly_daily_quests[i]
		end,
		progress = function (statistics_db, stats_id, quest_key)
			-- function 176
			local stat_name = QuestSettings.stat_mappings[quest_key][1]
			local count = statistics_db:get_persistent_stat(stats_id, "quest_statistics", stat_name)

			return {
				count,
				QuestSettings.weekly_daily_quests[i]
			}
		end
	}
end

DLCUtils.merge("quest_templates", quest_templates.quests)

return quest_templates
