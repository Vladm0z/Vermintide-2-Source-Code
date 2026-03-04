-- chunkname: @scripts/managers/quest/quest_templates.lua

local var_0_0 = {
	quests = {}
}
local var_0_1 = {
	{
		played_levels_quickplay = {}
	}
}

for iter_0_0 = 1, #UnlockableLevels do
	local var_0_2 = UnlockableLevels[iter_0_0]

	var_0_1[1].played_levels_quickplay[var_0_2] = true
end

var_0_0.quests.daily_complete_quickplay_missions = {
	name = "quest_daily_complete_quickplay_missions_name",
	icon = "quest_book_skull",
	desc = function()
		return string.format(Localize("quest_daily_complete_quickplay_missions_desc"), QuestSettings.daily_complete_quickplay_missions)
	end,
	stat_mappings = var_0_1,
	completed = function(arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = QuestSettings.stat_mappings[arg_2_2][1]

		return arg_2_0:get_persistent_stat(arg_2_1, "quest_statistics", var_2_0) >= QuestSettings.daily_complete_quickplay_missions
	end,
	progress = function(arg_3_0, arg_3_1, arg_3_2)
		local var_3_0 = QuestSettings.stat_mappings[arg_3_2][1]
		local var_3_1 = arg_3_0:get_persistent_stat(arg_3_1, "quest_statistics", var_3_0)

		return {
			var_3_1,
			QuestSettings.daily_complete_quickplay_missions
		}
	end
}

local var_0_3 = {
	{
		total_collected_tomes = true
	}
}

var_0_0.quests.daily_collect_tomes = {
	name = "quest_daily_collect_tomes_name",
	icon = "quest_book_tome",
	desc = function()
		return string.format(Localize("quest_daily_collect_tomes_desc"), QuestSettings.daily_collect_tomes)
	end,
	stat_mappings = var_0_3,
	completed = function(arg_5_0, arg_5_1, arg_5_2)
		local var_5_0 = QuestSettings.stat_mappings[arg_5_2][1]

		return arg_5_0:get_persistent_stat(arg_5_1, "quest_statistics", var_5_0) >= QuestSettings.daily_collect_tomes
	end,
	progress = function(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = QuestSettings.stat_mappings[arg_6_2][1]
		local var_6_1 = arg_6_0:get_persistent_stat(arg_6_1, "quest_statistics", var_6_0)

		return {
			var_6_1,
			QuestSettings.daily_collect_tomes
		}
	end
}

local var_0_4 = {
	{
		total_collected_grimoires = true
	}
}

var_0_0.quests.daily_collect_grimoires = {
	name = "quest_daily_collect_grimoires_name",
	icon = "quest_book_grimoire",
	desc = function()
		return string.format(Localize("quest_daily_collect_grimoires_desc"), QuestSettings.daily_collect_grimoires)
	end,
	stat_mappings = var_0_4,
	completed = function(arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = QuestSettings.stat_mappings[arg_8_2][1]

		return arg_8_0:get_persistent_stat(arg_8_1, "quest_statistics", var_8_0) >= QuestSettings.daily_collect_grimoires
	end,
	progress = function(arg_9_0, arg_9_1, arg_9_2)
		local var_9_0 = QuestSettings.stat_mappings[arg_9_2][1]
		local var_9_1 = arg_9_0:get_persistent_stat(arg_9_1, "quest_statistics", var_9_0)

		return {
			var_9_1,
			QuestSettings.daily_collect_grimoires
		}
	end
}

local var_0_5 = {
	{
		total_collected_dice = true
	}
}

var_0_0.quests.daily_collect_loot_die = {
	name = "quest_daily_collect_loot_die_name",
	icon = "quest_book_generic_pickup",
	desc = function()
		return string.format(Localize("quest_daily_collect_loot_die_desc"), QuestSettings.daily_collect_loot_die)
	end,
	stat_mappings = var_0_5,
	completed = function(arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = QuestSettings.stat_mappings[arg_11_2][1]

		return arg_11_0:get_persistent_stat(arg_11_1, "quest_statistics", var_11_0) >= QuestSettings.daily_collect_loot_die
	end,
	progress = function(arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = QuestSettings.stat_mappings[arg_12_2][1]
		local var_12_1 = arg_12_0:get_persistent_stat(arg_12_1, "quest_statistics", var_12_0)

		return {
			var_12_1,
			QuestSettings.daily_collect_loot_die
		}
	end
}

local var_0_6 = {
	{
		collected_painting_scraps_unlimited = true
	}
}

var_0_0.quests.daily_collect_painting_scrap = {
	name = "quest_daily_collect_painting_scrap_name",
	icon = "quest_book_generic_pickup",
	desc = function()
		return string.format(Localize("quest_daily_collect_painting_scrap_desc"), QuestSettings.daily_collect_painting_scrap)
	end,
	stat_mappings = var_0_6,
	completed = function(arg_14_0, arg_14_1, arg_14_2)
		local var_14_0 = QuestSettings.stat_mappings[arg_14_2][1]

		return arg_14_0:get_persistent_stat(arg_14_1, "quest_statistics", var_14_0) >= QuestSettings.daily_collect_painting_scrap
	end,
	progress = function(arg_15_0, arg_15_1, arg_15_2)
		local var_15_0 = QuestSettings.stat_mappings[arg_15_2][1]
		local var_15_1 = arg_15_0:get_persistent_stat(arg_15_1, "quest_statistics", var_15_0)

		return {
			var_15_1,
			QuestSettings.daily_collect_painting_scrap
		}
	end
}

local var_0_7 = {
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

var_0_0.quests.daily_kill_bosses = {
	name = "quest_daily_kill_bosses_name",
	icon = "quest_book_skull",
	desc = function()
		return string.format(Localize("quest_daily_kill_bosses_desc"), QuestSettings.daily_kill_bosses)
	end,
	stat_mappings = var_0_7,
	completed = function(arg_17_0, arg_17_1, arg_17_2)
		local var_17_0 = QuestSettings.stat_mappings[arg_17_2][1]

		return arg_17_0:get_persistent_stat(arg_17_1, "quest_statistics", var_17_0) >= QuestSettings.daily_kill_bosses
	end,
	progress = function(arg_18_0, arg_18_1, arg_18_2)
		local var_18_0 = QuestSettings.stat_mappings[arg_18_2][1]
		local var_18_1 = arg_18_0:get_persistent_stat(arg_18_1, "quest_statistics", var_18_0)

		return {
			var_18_1,
			QuestSettings.daily_kill_bosses
		}
	end
}

local var_0_8 = {
	{
		kills_per_breed = {},
		kill_assists_per_breed = {}
	}
}

for iter_0_1, iter_0_2 in pairs(ELITES) do
	local var_0_9 = var_0_8[1].kills_per_breed
	local var_0_10 = var_0_8[1].kill_assists_per_breed

	var_0_9[iter_0_1] = true
	var_0_10[iter_0_1] = true
end

var_0_0.quests.daily_kill_elites = {
	name = "quest_daily_kill_elites_name",
	icon = "quest_book_skull",
	desc = function()
		return string.format(Localize("quest_daily_kill_elites_desc"), QuestSettings.daily_kill_elites)
	end,
	stat_mappings = var_0_8,
	completed = function(arg_20_0, arg_20_1, arg_20_2)
		local var_20_0 = QuestSettings.stat_mappings[arg_20_2][1]

		return arg_20_0:get_persistent_stat(arg_20_1, "quest_statistics", var_20_0) >= QuestSettings.daily_kill_elites
	end,
	progress = function(arg_21_0, arg_21_1, arg_21_2)
		local var_21_0 = QuestSettings.stat_mappings[arg_21_2][1]
		local var_21_1 = arg_21_0:get_persistent_stat(arg_21_1, "quest_statistics", var_21_0)

		return {
			var_21_1,
			QuestSettings.daily_kill_elites
		}
	end
}

local var_0_11 = {
	{
		kills_critter_total = true
	}
}

var_0_0.quests.daily_kill_critters = {
	name = "quest_daily_kill_critters_name",
	icon = "quest_book_skull",
	desc = function()
		return string.format(Localize("quest_daily_kill_critters_desc"), QuestSettings.daily_kill_critters)
	end,
	stat_mappings = var_0_11,
	completed = function(arg_23_0, arg_23_1, arg_23_2)
		local var_23_0 = QuestSettings.stat_mappings[arg_23_2][1]

		return arg_23_0:get_persistent_stat(arg_23_1, "quest_statistics", var_23_0) >= QuestSettings.daily_kill_critters
	end,
	progress = function(arg_24_0, arg_24_1, arg_24_2)
		local var_24_0 = QuestSettings.stat_mappings[arg_24_2][1]
		local var_24_1 = arg_24_0:get_persistent_stat(arg_24_1, "quest_statistics", var_24_0)

		return {
			var_24_1,
			QuestSettings.daily_kill_critters
		}
	end
}

local var_0_12 = {
	{
		completed_levels_wood_elf = {}
	}
}

for iter_0_3 = 1, #UnlockableLevels do
	local var_0_13 = UnlockableLevels[iter_0_3]

	var_0_12[1].completed_levels_wood_elf[var_0_13] = true
end

var_0_0.quests.daily_complete_levels_hero_wood_elf = {
	name = "quest_daily_complete_levels_hero_wood_elf_name",
	icon = "quest_book_kerillian",
	desc = function()
		return string.format(Localize("quest_daily_complete_levels_hero_wood_elf_desc"), QuestSettings.daily_complete_levels_hero_wood_elf)
	end,
	stat_mappings = var_0_12,
	completed = function(arg_26_0, arg_26_1, arg_26_2)
		local var_26_0 = QuestSettings.stat_mappings[arg_26_2][1]

		return arg_26_0:get_persistent_stat(arg_26_1, "quest_statistics", var_26_0) >= QuestSettings.daily_complete_levels_hero_wood_elf
	end,
	progress = function(arg_27_0, arg_27_1, arg_27_2)
		local var_27_0 = QuestSettings.stat_mappings[arg_27_2][1]
		local var_27_1 = arg_27_0:get_persistent_stat(arg_27_1, "quest_statistics", var_27_0)

		return {
			var_27_1,
			QuestSettings.daily_complete_levels_hero_wood_elf
		}
	end
}

local var_0_14 = {
	{
		completed_levels_witch_hunter = {}
	}
}

for iter_0_4 = 1, #UnlockableLevels do
	local var_0_15 = UnlockableLevels[iter_0_4]

	var_0_14[1].completed_levels_witch_hunter[var_0_15] = true
end

var_0_0.quests.daily_complete_levels_hero_witch_hunter = {
	name = "quest_daily_complete_levels_hero_witch_hunter_name",
	icon = "quest_book_saltzpyre",
	desc = function()
		return string.format(Localize("quest_daily_complete_levels_hero_witch_hunter_desc"), QuestSettings.daily_complete_levels_hero_witch_hunter)
	end,
	stat_mappings = var_0_14,
	completed = function(arg_29_0, arg_29_1, arg_29_2)
		local var_29_0 = QuestSettings.stat_mappings[arg_29_2][1]

		return arg_29_0:get_persistent_stat(arg_29_1, "quest_statistics", var_29_0) >= QuestSettings.daily_complete_levels_hero_witch_hunter
	end,
	progress = function(arg_30_0, arg_30_1, arg_30_2)
		local var_30_0 = QuestSettings.stat_mappings[arg_30_2][1]
		local var_30_1 = arg_30_0:get_persistent_stat(arg_30_1, "quest_statistics", var_30_0)

		return {
			var_30_1,
			QuestSettings.daily_complete_levels_hero_witch_hunter
		}
	end
}

local var_0_16 = {
	{
		completed_levels_dwarf_ranger = {}
	}
}

for iter_0_5 = 1, #UnlockableLevels do
	local var_0_17 = UnlockableLevels[iter_0_5]

	var_0_16[1].completed_levels_dwarf_ranger[var_0_17] = true
end

var_0_0.quests.daily_complete_levels_hero_dwarf_ranger = {
	name = "quest_daily_complete_levels_hero_dwarf_ranger_name",
	icon = "quest_book_bardin",
	desc = function()
		return string.format(Localize("quest_daily_complete_levels_hero_dwarf_ranger_desc"), QuestSettings.daily_complete_levels_hero_dwarf_ranger)
	end,
	stat_mappings = var_0_16,
	completed = function(arg_32_0, arg_32_1, arg_32_2)
		local var_32_0 = QuestSettings.stat_mappings[arg_32_2][1]

		return arg_32_0:get_persistent_stat(arg_32_1, "quest_statistics", var_32_0) >= QuestSettings.daily_complete_levels_hero_dwarf_ranger
	end,
	progress = function(arg_33_0, arg_33_1, arg_33_2)
		local var_33_0 = QuestSettings.stat_mappings[arg_33_2][1]
		local var_33_1 = arg_33_0:get_persistent_stat(arg_33_1, "quest_statistics", var_33_0)

		return {
			var_33_1,
			QuestSettings.daily_complete_levels_hero_dwarf_ranger
		}
	end
}

local var_0_18 = {
	{
		completed_levels_bright_wizard = {}
	}
}

for iter_0_6 = 1, #UnlockableLevels do
	local var_0_19 = UnlockableLevels[iter_0_6]

	var_0_18[1].completed_levels_bright_wizard[var_0_19] = true
end

var_0_0.quests.daily_complete_levels_hero_bright_wizard = {
	name = "quest_daily_complete_levels_hero_bright_wizard_name",
	icon = "quest_book_sienna",
	desc = function()
		return string.format(Localize("quest_daily_complete_levels_hero_bright_wizard_desc"), QuestSettings.daily_complete_levels_hero_bright_wizard)
	end,
	stat_mappings = var_0_18,
	completed = function(arg_35_0, arg_35_1, arg_35_2)
		local var_35_0 = QuestSettings.stat_mappings[arg_35_2][1]

		return arg_35_0:get_persistent_stat(arg_35_1, "quest_statistics", var_35_0) >= QuestSettings.daily_complete_levels_hero_bright_wizard
	end,
	progress = function(arg_36_0, arg_36_1, arg_36_2)
		local var_36_0 = QuestSettings.stat_mappings[arg_36_2][1]
		local var_36_1 = arg_36_0:get_persistent_stat(arg_36_1, "quest_statistics", var_36_0)

		return {
			var_36_1,
			QuestSettings.daily_complete_levels_hero_bright_wizard
		}
	end
}

local var_0_20 = {
	{
		completed_levels_empire_soldier = {}
	}
}

for iter_0_7 = 1, #UnlockableLevels do
	local var_0_21 = UnlockableLevels[iter_0_7]

	var_0_20[1].completed_levels_empire_soldier[var_0_21] = true
end

var_0_0.quests.daily_complete_levels_hero_empire_soldier = {
	name = "quest_daily_complete_levels_hero_empire_soldier_name",
	icon = "quest_book_kruber",
	desc = function()
		return string.format(Localize("quest_daily_complete_levels_hero_empire_soldier_desc"), QuestSettings.daily_complete_levels_hero_empire_soldier)
	end,
	stat_mappings = var_0_20,
	completed = function(arg_38_0, arg_38_1, arg_38_2)
		local var_38_0 = QuestSettings.stat_mappings[arg_38_2][1]

		return arg_38_0:get_persistent_stat(arg_38_1, "quest_statistics", var_38_0) >= QuestSettings.daily_complete_levels_hero_empire_soldier
	end,
	progress = function(arg_39_0, arg_39_1, arg_39_2)
		local var_39_0 = QuestSettings.stat_mappings[arg_39_2][1]
		local var_39_1 = arg_39_0:get_persistent_stat(arg_39_1, "quest_statistics", var_39_0)

		return {
			var_39_1,
			QuestSettings.daily_complete_levels_hero_empire_soldier
		}
	end
}

local var_0_22 = {
	{
		headshots = true
	}
}

var_0_0.quests.daily_score_headshots = {
	name = "quest_daily_score_headshots_name",
	icon = "quest_book_skull",
	desc = function()
		return string.format(Localize("quest_daily_score_headshots_desc"), QuestSettings.daily_score_headshots)
	end,
	stat_mappings = var_0_22,
	completed = function(arg_41_0, arg_41_1, arg_41_2)
		local var_41_0 = QuestSettings.stat_mappings[arg_41_2][1]

		return arg_41_0:get_persistent_stat(arg_41_1, "quest_statistics", var_41_0) >= QuestSettings.daily_score_headshots
	end,
	progress = function(arg_42_0, arg_42_1, arg_42_2)
		local var_42_0 = QuestSettings.stat_mappings[arg_42_2][1]
		local var_42_1 = arg_42_0:get_persistent_stat(arg_42_1, "quest_statistics", var_42_0)

		return {
			var_42_1,
			QuestSettings.daily_score_headshots
		}
	end
}

local var_0_23 = {
	{
		played_levels_quickplay = {}
	}
}
local var_0_24 = {
	{
		played_levels_weekly_event = {}
	}
}

for iter_0_8 = 1, #UnlockableLevels do
	local var_0_25 = UnlockableLevels[iter_0_8]

	var_0_23[1].played_levels_quickplay[var_0_25] = true
	var_0_24[1].played_levels_weekly_event[var_0_25] = true
end

var_0_0.quests.event_skulls_for_the_skull_throne = {
	name = "quest_event_skull_2018_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function()
		return string.format(Localize("quest_event_skull_2018_desc"), QuestSettings.event_skulls_quickplay)
	end,
	stat_mappings = var_0_23,
	completed = function(arg_44_0, arg_44_1, arg_44_2)
		local var_44_0 = QuestSettings.stat_mappings[arg_44_2][1]

		return arg_44_0:get_persistent_stat(arg_44_1, "quest_statistics", var_44_0) >= QuestSettings.event_skulls_quickplay
	end,
	progress = function(arg_45_0, arg_45_1, arg_45_2)
		local var_45_0 = QuestSettings.stat_mappings[arg_45_2][1]
		local var_45_1 = arg_45_0:get_persistent_stat(arg_45_1, "quest_statistics", var_45_0)

		return {
			var_45_1,
			QuestSettings.event_skulls_quickplay
		}
	end
}
var_0_0.quests.event_sonnstill_quickplay_2018 = {
	name = "quest_event_summer_2018_quickplay_name",
	icon = "quest_book_event_summer",
	desc = function()
		return string.format(Localize("quest_event_summer_2018_quickplay_desc"), QuestSettings.event_sonnstill_quickplay_levels)
	end,
	stat_mappings = var_0_23,
	completed = function(arg_47_0, arg_47_1, arg_47_2)
		local var_47_0 = QuestSettings.stat_mappings[arg_47_2][1]

		return arg_47_0:get_persistent_stat(arg_47_1, "quest_statistics", var_47_0) >= QuestSettings.event_sonnstill_quickplay_levels
	end,
	progress = function(arg_48_0, arg_48_1, arg_48_2)
		local var_48_0 = QuestSettings.stat_mappings[arg_48_2][1]
		local var_48_1 = arg_48_0:get_persistent_stat(arg_48_1, "quest_statistics", var_48_0)

		return {
			var_48_1,
			QuestSettings.event_sonnstill_quickplay_levels
		}
	end
}

local var_0_26 = {
	{
		played_difficulty = {
			harder = true,
			hardest = true
		}
	}
}

var_0_0.quests.event_sonnstill_played_champion_2018 = {
	name = "quest_event_summer_2018_champion_name",
	icon = "quest_book_event_summer",
	desc = function()
		return string.format(Localize("quest_event_summer_2018_champion_desc"), QuestSettings.event_sonnstill_difficulty_levels)
	end,
	stat_mappings = var_0_26,
	completed = function(arg_50_0, arg_50_1, arg_50_2)
		local var_50_0 = QuestSettings.stat_mappings[arg_50_2][1]

		return arg_50_0:get_persistent_stat(arg_50_1, "quest_statistics", var_50_0) >= QuestSettings.event_sonnstill_difficulty_levels
	end,
	progress = function(arg_51_0, arg_51_1, arg_51_2)
		local var_51_0 = QuestSettings.stat_mappings[arg_51_2][1]
		local var_51_1 = arg_51_0:get_persistent_stat(arg_51_1, "quest_statistics", var_51_0)

		return {
			var_51_1,
			QuestSettings.event_sonnstill_quickplay_levels
		}
	end
}

local var_0_27 = {
	{
		played_difficulty = {
			hardest = true
		}
	}
}

var_0_0.quests.event_sonnstill_played_legend_2018 = {
	name = "quest_event_summer_2018_legend_name",
	icon = "quest_book_event_summer",
	desc = function()
		return string.format(Localize("quest_event_summer_2018_legend_desc"), QuestSettings.event_sonnstill_difficulty_levels)
	end,
	stat_mappings = var_0_27,
	completed = function(arg_53_0, arg_53_1, arg_53_2)
		local var_53_0 = QuestSettings.stat_mappings[arg_53_2][1]

		return arg_53_0:get_persistent_stat(arg_53_1, "quest_statistics", var_53_0) >= QuestSettings.event_sonnstill_difficulty_levels
	end,
	progress = function(arg_54_0, arg_54_1, arg_54_2)
		local var_54_0 = QuestSettings.stat_mappings[arg_54_2][1]
		local var_54_1 = arg_54_0:get_persistent_stat(arg_54_1, "quest_statistics", var_54_0)

		return {
			var_54_1,
			QuestSettings.event_sonnstill_quickplay_levels
		}
	end
}
var_0_0.quests.event_geheimnisnacht_quickplay_2018 = {
	name = "quest_event_geheimnisnacht_2018_quickplay_name",
	icon = "quest_book_geheimnisnacht",
	desc = function()
		return string.format(Localize("quest_event_summer_2018_quickplay_desc"), QuestSettings.event_geheimnisnacht_quickplay_levels)
	end,
	stat_mappings = var_0_23,
	completed = function(arg_56_0, arg_56_1, arg_56_2)
		local var_56_0 = QuestSettings.stat_mappings[arg_56_2][1]

		return arg_56_0:get_persistent_stat(arg_56_1, "quest_statistics", var_56_0) >= QuestSettings.event_geheimnisnacht_quickplay_levels
	end,
	progress = function(arg_57_0, arg_57_1, arg_57_2)
		local var_57_0 = QuestSettings.stat_mappings[arg_57_2][1]
		local var_57_1 = arg_57_0:get_persistent_stat(arg_57_1, "quest_statistics", var_57_0)

		return {
			var_57_1,
			QuestSettings.event_geheimnisnacht_quickplay_levels
		}
	end
}
var_0_0.quests.event_geheimnisnacht_quickplay_2019 = {
	name = "quest_event_geheimnisnacht_2019_quickplay_name",
	icon = "quest_book_geheimnisnacht",
	desc = function()
		return string.format(Localize("quest_event_summer_2018_quickplay_desc"), QuestSettings.event_geheimnisnacht_quickplay_levels)
	end,
	stat_mappings = var_0_23,
	completed = function(arg_59_0, arg_59_1, arg_59_2)
		local var_59_0 = QuestSettings.stat_mappings[arg_59_2][1]

		return arg_59_0:get_persistent_stat(arg_59_1, "quest_statistics", var_59_0) >= QuestSettings.event_geheimnisnacht_quickplay_levels
	end,
	progress = function(arg_60_0, arg_60_1, arg_60_2)
		local var_60_0 = QuestSettings.stat_mappings[arg_60_2][1]
		local var_60_1 = arg_60_0:get_persistent_stat(arg_60_1, "quest_statistics", var_60_0)

		return {
			var_60_1,
			QuestSettings.event_geheimnisnacht_quickplay_levels
		}
	end
}
var_0_0.quests.event_geheimnisnacht_weekly_event_2019 = {
	name = "quest_event_geheimnisnacht_weekly_event_2019_name",
	icon = "quest_book_geheimnisnacht",
	desc = "complete_one_weekly_event",
	stat_mappings = var_0_24,
	completed = function(arg_61_0, arg_61_1, arg_61_2)
		local var_61_0 = QuestSettings.stat_mappings[arg_61_2][1]

		return arg_61_0:get_persistent_stat(arg_61_1, "quest_statistics", var_61_0) > 0
	end
}

local var_0_28 = {
	{
		played_difficulty = {
			harder = true,
			hardest = true
		}
	}
}

var_0_0.quests.event_geheimnisnacht_played_champion_2018 = {
	name = "quest_event_geheimnisnacht_2018_champion_name",
	icon = "quest_book_geheimnisnacht",
	desc = function()
		return string.format(Localize("quest_event_summer_2018_champion_desc"), QuestSettings.event_geheimnisnacht_difficulty_levels)
	end,
	stat_mappings = var_0_28,
	completed = function(arg_63_0, arg_63_1, arg_63_2)
		local var_63_0 = QuestSettings.stat_mappings[arg_63_2][1]

		return arg_63_0:get_persistent_stat(arg_63_1, "quest_statistics", var_63_0) >= QuestSettings.event_geheimnisnacht_difficulty_levels
	end,
	progress = function(arg_64_0, arg_64_1, arg_64_2)
		local var_64_0 = QuestSettings.stat_mappings[arg_64_2][1]
		local var_64_1 = arg_64_0:get_persistent_stat(arg_64_1, "quest_statistics", var_64_0)

		return {
			var_64_1,
			QuestSettings.event_geheimnisnacht_quickplay_levels
		}
	end
}

local var_0_29 = {
	{
		played_difficulty = {
			hardest = true
		}
	}
}

var_0_0.quests.event_geheimnisnacht_played_legend_2018 = {
	name = "quest_event_geheimnisnacht_2018_legend_name",
	icon = "quest_book_geheimnisnacht",
	desc = function()
		return string.format(Localize("quest_event_summer_2018_legend_desc"), QuestSettings.event_geheimnisnacht_difficulty_levels)
	end,
	stat_mappings = var_0_29,
	completed = function(arg_66_0, arg_66_1, arg_66_2)
		local var_66_0 = QuestSettings.stat_mappings[arg_66_2][1]

		return arg_66_0:get_persistent_stat(arg_66_1, "quest_statistics", var_66_0) >= QuestSettings.event_geheimnisnacht_difficulty_levels
	end,
	progress = function(arg_67_0, arg_67_1, arg_67_2)
		local var_67_0 = QuestSettings.stat_mappings[arg_67_2][1]
		local var_67_1 = arg_67_0:get_persistent_stat(arg_67_1, "quest_statistics", var_67_0)

		return {
			var_67_1,
			QuestSettings.event_geheimnisnacht_quickplay_levels
		}
	end
}
var_0_0.quests.event_mondstille_bonfires_2018 = {
	name = "quest_mondstille_01_name",
	icon = "quest_book_mondstille",
	desc = "quest_mondstille_01_desc",
	completed = function(arg_68_0, arg_68_1)
		if arg_68_0:get_persistent_stat(arg_68_1, "bonfire_lit_mines") > 0 and arg_68_0:get_persistent_stat(arg_68_1, "bonfire_lit_fort") > 0 and arg_68_0:get_persistent_stat(arg_68_1, "bonfire_lit_warcamp") > 0 and arg_68_0:get_persistent_stat(arg_68_1, "bonfire_lit_skittergate") > 0 then
			return true
		end

		return false
	end,
	progress = function(arg_69_0, arg_69_1)
		local var_69_0 = 0

		if arg_69_0:get_persistent_stat(arg_69_1, "bonfire_lit_mines") > 0 then
			var_69_0 = var_69_0 + 1
		end

		if arg_69_0:get_persistent_stat(arg_69_1, "bonfire_lit_fort") > 0 then
			var_69_0 = var_69_0 + 1
		end

		if arg_69_0:get_persistent_stat(arg_69_1, "bonfire_lit_warcamp") > 0 then
			var_69_0 = var_69_0 + 1
		end

		if arg_69_0:get_persistent_stat(arg_69_1, "bonfire_lit_skittergate") > 0 then
			var_69_0 = var_69_0 + 1
		end

		return {
			var_69_0,
			4
		}
	end,
	requirements = function(arg_70_0, arg_70_1)
		local var_70_0 = arg_70_0:get_persistent_stat(arg_70_1, "bonfire_lit_mines") > 0
		local var_70_1 = arg_70_0:get_persistent_stat(arg_70_1, "bonfire_lit_fort") > 0
		local var_70_2 = arg_70_0:get_persistent_stat(arg_70_1, "bonfire_lit_warcamp") > 0
		local var_70_3 = arg_70_0:get_persistent_stat(arg_70_1, "bonfire_lit_skittergate") > 0

		return {
			{
				name = "level_name_mines",
				completed = var_70_0
			},
			{
				name = "level_name_forest_fort",
				completed = var_70_1
			},
			{
				name = "level_name_warcamp",
				completed = var_70_2
			},
			{
				name = "level_name_skittergate",
				completed = var_70_3
			}
		}
	end
}

local var_0_30 = {
	{
		played_difficulty = {
			hardest = true
		}
	}
}

var_0_0.quests.event_mondstille_played_legend_2018 = {
	name = "quest_mondstille_03_name",
	icon = "quest_book_mondstille",
	desc = "quest_mondstille_03_desc",
	stat_mappings = var_0_30,
	completed = function(arg_71_0, arg_71_1, arg_71_2)
		local var_71_0 = QuestSettings.stat_mappings[arg_71_2][1]

		return arg_71_0:get_persistent_stat(arg_71_1, "quest_statistics", var_71_0) >= QuestSettings.event_mondstille_quickplay_legend_levels
	end,
	progress = function(arg_72_0, arg_72_1, arg_72_2)
		local var_72_0 = QuestSettings.stat_mappings[arg_72_2][1]
		local var_72_1 = arg_72_0:get_persistent_stat(arg_72_1, "quest_statistics", var_72_0)

		return {
			var_72_1,
			QuestSettings.event_mondstille_quickplay_legend_levels
		}
	end
}
var_0_0.quests.event_mondstille_quickplay_console = {
	name = "quest_mondstille_01_name",
	icon = "quest_book_mondstille",
	desc = function()
		return string.format(Localize("quest_event_summer_2018_quickplay_desc"), QuestSettings.event_sonnstill_quickplay_levels)
	end,
	stat_mappings = var_0_23,
	completed = function(arg_74_0, arg_74_1, arg_74_2)
		local var_74_0 = QuestSettings.stat_mappings[arg_74_2][1]

		return arg_74_0:get_persistent_stat(arg_74_1, "quest_statistics", var_74_0) >= QuestSettings.event_sonnstill_quickplay_levels
	end,
	progress = function(arg_75_0, arg_75_1, arg_75_2)
		local var_75_0 = QuestSettings.stat_mappings[arg_75_2][1]
		local var_75_1 = arg_75_0:get_persistent_stat(arg_75_1, "quest_statistics", var_75_0)

		return {
			var_75_1,
			QuestSettings.event_sonnstill_quickplay_levels
		}
	end
}
var_0_0.quests.event_celebration_complete_2020 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = var_0_24,
	completed = function(arg_76_0, arg_76_1, arg_76_2)
		local var_76_0 = QuestSettings.stat_mappings[arg_76_2][1]

		return arg_76_0:get_persistent_stat(arg_76_1, "quest_statistics", var_76_0) > 0
	end
}
var_0_0.quests.event_celebration_complete_2023 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = var_0_24,
	completed = function(arg_77_0, arg_77_1, arg_77_2)
		local var_77_0 = QuestSettings.stat_mappings[arg_77_2][1]

		return arg_77_0:get_persistent_stat(arg_77_1, "quest_statistics", var_77_0) > 0
	end
}
var_0_0.quests.event_celebration_complete_2024 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = var_0_24,
	completed = function(arg_78_0, arg_78_1, arg_78_2)
		local var_78_0 = QuestSettings.stat_mappings[arg_78_2][1]

		return arg_78_0:get_persistent_stat(arg_78_1, "quest_statistics", var_78_0) > 0
	end
}
var_0_0.quests.event_celebration_complete_2025 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = var_0_24,
	completed = function(arg_79_0, arg_79_1, arg_79_2)
		local var_79_0 = QuestSettings.stat_mappings[arg_79_2][1]

		return arg_79_0:get_persistent_stat(arg_79_1, "quest_statistics", var_79_0) > 0
	end
}
var_0_0.quests.event_celebration_complete_2026 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = var_0_24,
	completed = function(arg_80_0, arg_80_1, arg_80_2)
		local var_80_0 = QuestSettings.stat_mappings[arg_80_2][1]

		return arg_80_0:get_persistent_stat(arg_80_1, "quest_statistics", var_80_0) > 0
	end
}

local var_0_31 = {
	{
		collected_painting_scraps_unlimited = true
	}
}

var_0_0.quests.event_celebration_complete_2019 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	completed = function(arg_81_0, arg_81_1, arg_81_2)
		return arg_81_0:get_persistent_stat(arg_81_1, "completed_levels", "dlc_celebrate_crawl") > 0
	end
}
var_0_0.quests.event_celebration_drink_all_ale_2019 = {
	name = "quest_celebration_02_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_02_desc",
	completed = function(arg_82_0, arg_82_1, arg_82_2)
		return arg_82_0:get_persistent_stat(arg_82_1, "crawl_total_ales_drunk") >= QuestSettings.event_crawl_drink_all_ale_amount
	end,
	progress = function(arg_83_0, arg_83_1, arg_83_2)
		local var_83_0 = arg_83_0:get_persistent_stat(arg_83_1, "crawl_total_ales_drunk")

		return {
			var_83_0,
			QuestSettings.event_crawl_drink_all_ale_amount
		}
	end
}
var_0_0.quests.event_celebration_collect_painting_scraps_2019 = {
	name = "painting_manaan01_name",
	icon = "quest_book_event_celebration",
	desc = function()
		return string.format(Localize("achv_gecko_scraps_generic_1_desc"), QuestSettings.event_celebration_collect_painting_scraps)
	end,
	stat_mappings = var_0_31,
	completed = function(arg_85_0, arg_85_1, arg_85_2)
		local var_85_0 = QuestSettings.stat_mappings[arg_85_2][1]

		return arg_85_0:get_persistent_stat(arg_85_1, "quest_statistics", var_85_0) >= QuestSettings.event_celebration_collect_painting_scraps
	end,
	progress = function(arg_86_0, arg_86_1, arg_86_2)
		local var_86_0 = QuestSettings.stat_mappings[arg_86_2][1]
		local var_86_1 = arg_86_0:get_persistent_stat(arg_86_1, "quest_statistics", var_86_0)

		return {
			var_86_1,
			QuestSettings.event_celebration_collect_painting_scraps
		}
	end
}
var_0_0.quests.event_skulls_quickplay_2019 = {
	name = "quest_event_skulls_quickplay_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function()
		return string.format(Localize("quest_event_skulls_quickplay_2019_desc"), QuestSettings.event_skulls_quickplay)
	end,
	stat_mappings = var_0_23,
	completed = function(arg_88_0, arg_88_1, arg_88_2)
		local var_88_0 = QuestSettings.stat_mappings[arg_88_2][1]

		return arg_88_0:get_persistent_stat(arg_88_1, "quest_statistics", var_88_0) >= QuestSettings.event_skulls_quickplay
	end,
	progress = function(arg_89_0, arg_89_1, arg_89_2)
		local var_89_0 = QuestSettings.stat_mappings[arg_89_2][1]
		local var_89_1 = arg_89_0:get_persistent_stat(arg_89_1, "quest_statistics", var_89_0)

		return {
			var_89_1,
			QuestSettings.event_skulls_quickplay
		}
	end
}
var_0_0.quests.event_skulls_weekly_event_2019 = {
	name = "quest_event_skulls_weekly_event_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "complete_one_weekly_event",
	stat_mappings = var_0_24,
	completed = function(arg_90_0, arg_90_1, arg_90_2)
		local var_90_0 = QuestSettings.stat_mappings[arg_90_2][1]

		return arg_90_0:get_persistent_stat(arg_90_1, "quest_statistics", var_90_0) > 0
	end
}

local var_0_32 = {
	{
		collected_painting_scraps_unlimited = true
	}
}

var_0_0.quests.event_skulls_painting_scraps_2019 = {
	name = "quest_event_skulls_painting_scraps_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function()
		return string.format(Localize("quest_event_skulls_painting_scraps_2019_desc"), QuestSettings.event_skulls_collect_painting_scraps)
	end,
	stat_mappings = var_0_32,
	completed = function(arg_92_0, arg_92_1, arg_92_2)
		local var_92_0 = QuestSettings.stat_mappings[arg_92_2][1]

		return arg_92_0:get_persistent_stat(arg_92_1, "quest_statistics", var_92_0) >= QuestSettings.event_skulls_collect_painting_scraps
	end,
	progress = function(arg_93_0, arg_93_1, arg_93_2)
		local var_93_0 = QuestSettings.stat_mappings[arg_93_2][1]
		local var_93_1 = arg_93_0:get_persistent_stat(arg_93_1, "quest_statistics", var_93_0)

		return {
			var_93_1,
			QuestSettings.event_skulls_collect_painting_scraps
		}
	end
}

local var_0_33 = {
	{
		completed_levels = {
			warcamp = true
		}
	}
}

var_0_0.quests.event_skulls_warcamp_2019 = {
	name = "quest_event_skulls_warcamp_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "quest_event_skulls_warcamp_2019_desc",
	stat_mappings = var_0_33,
	completed = function(arg_94_0, arg_94_1, arg_94_2)
		local var_94_0 = QuestSettings.stat_mappings[arg_94_2][1]

		return arg_94_0:get_persistent_stat(arg_94_1, "quest_statistics", var_94_0) > 0
	end,
	requirements = function(arg_95_0, arg_95_1, arg_95_2)
		local var_95_0 = QuestSettings.stat_mappings[arg_95_2][1]
		local var_95_1 = arg_95_0:get_persistent_stat(arg_95_1, "quest_statistics", var_95_0) > 0

		return {
			{
				name = "mission_warcamp_kill_chieftain",
				completed = var_95_1
			}
		}
	end
}
var_0_0.quests.event_skulls_quickplay_2020 = {
	name = "quest_event_skulls_quickplay_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function()
		return string.format(Localize("quest_event_skulls_quickplay_2019_desc"), QuestSettings.event_skulls_quickplay)
	end,
	stat_mappings = var_0_23,
	completed = function(arg_97_0, arg_97_1, arg_97_2)
		local var_97_0 = QuestSettings.stat_mappings[arg_97_2][1]

		return arg_97_0:get_persistent_stat(arg_97_1, "quest_statistics", var_97_0) >= QuestSettings.event_skulls_quickplay
	end,
	progress = function(arg_98_0, arg_98_1, arg_98_2)
		local var_98_0 = QuestSettings.stat_mappings[arg_98_2][1]
		local var_98_1 = arg_98_0:get_persistent_stat(arg_98_1, "quest_statistics", var_98_0)

		return {
			var_98_1,
			QuestSettings.event_skulls_quickplay
		}
	end
}
var_0_0.quests.event_skulls_weekly_event_2020 = {
	name = "quest_event_skulls_weekly_event_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "complete_one_weekly_event",
	stat_mappings = var_0_24,
	completed = function(arg_99_0, arg_99_1, arg_99_2)
		local var_99_0 = QuestSettings.stat_mappings[arg_99_2][1]

		return arg_99_0:get_persistent_stat(arg_99_1, "quest_statistics", var_99_0) > 0
	end
}
var_0_0.quests.event_skulls_painting_scraps_2020 = {
	name = "quest_event_skulls_painting_scraps_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function()
		return string.format(Localize("quest_event_skulls_painting_scraps_2019_desc"), QuestSettings.event_skulls_collect_painting_scraps)
	end,
	stat_mappings = var_0_32,
	completed = function(arg_101_0, arg_101_1, arg_101_2)
		local var_101_0 = QuestSettings.stat_mappings[arg_101_2][1]

		return arg_101_0:get_persistent_stat(arg_101_1, "quest_statistics", var_101_0) >= QuestSettings.event_skulls_collect_painting_scraps
	end,
	progress = function(arg_102_0, arg_102_1, arg_102_2)
		local var_102_0 = QuestSettings.stat_mappings[arg_102_2][1]
		local var_102_1 = arg_102_0:get_persistent_stat(arg_102_1, "quest_statistics", var_102_0)

		return {
			var_102_1,
			QuestSettings.event_skulls_collect_painting_scraps
		}
	end
}
var_0_0.quests.event_skulls_warcamp_2020 = {
	name = "quest_event_skulls_warcamp_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "quest_event_skulls_warcamp_2019_desc",
	stat_mappings = var_0_33,
	completed = function(arg_103_0, arg_103_1, arg_103_2)
		local var_103_0 = QuestSettings.stat_mappings[arg_103_2][1]

		return arg_103_0:get_persistent_stat(arg_103_1, "quest_statistics", var_103_0) > 0
	end,
	requirements = function(arg_104_0, arg_104_1, arg_104_2)
		local var_104_0 = QuestSettings.stat_mappings[arg_104_2][1]
		local var_104_1 = arg_104_0:get_persistent_stat(arg_104_1, "quest_statistics", var_104_0) > 0

		return {
			{
				name = "mission_warcamp_kill_chieftain",
				completed = var_104_1
			}
		}
	end
}
var_0_0.quests.quest_event_rat_weekly_event_2020 = {
	name = "quest_event_rat_weekly_event_2020_name",
	icon = "quest_book_year_of_the_rat",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "complete_one_weekly_event",
	stat_mappings = var_0_24,
	completed = function(arg_105_0, arg_105_1, arg_105_2)
		local var_105_0 = QuestSettings.stat_mappings[arg_105_2][1]

		return arg_105_0:get_persistent_stat(arg_105_1, "quest_statistics", var_105_0) > 0
	end
}

local var_0_34 = {
	{
		kills_per_race = {
			skaven = true
		}
	}
}

var_0_0.quests.quest_event_rat_kill_skaven_2020 = {
	name = "quest_event_rat_kill_skaven_2020_name",
	icon = "quest_book_year_of_the_rat",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function()
		return string.format(Localize("quest_event_rat_kill_skaven_2020_desc"), QuestSettings.quest_event_rat_kill_skaven_2020)
	end,
	stat_mappings = var_0_34,
	completed = function(arg_107_0, arg_107_1, arg_107_2)
		local var_107_0 = QuestSettings.stat_mappings[arg_107_2][1]

		return arg_107_0:get_persistent_stat(arg_107_1, "quest_statistics", var_107_0) >= QuestSettings.quest_event_rat_kill_skaven_2020
	end,
	progress = function(arg_108_0, arg_108_1, arg_108_2)
		local var_108_0 = QuestSettings.stat_mappings[arg_108_2][1]
		local var_108_1 = arg_108_0:get_persistent_stat(arg_108_1, "quest_statistics", var_108_0)

		return {
			var_108_1,
			QuestSettings.quest_event_rat_kill_skaven_2020
		}
	end
}

local var_0_35 = {
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

var_0_0.quests.quest_event_rat_kill_skaven_lords_2020 = {
	name = "quest_event_rat_kill_skaven_lords_2020_name",
	icon = "quest_book_year_of_the_rat",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "quest_event_rat_kill_skaven_lords_2020_desc",
	stat_mappings = var_0_35,
	completed = function(arg_109_0, arg_109_1, arg_109_2)
		local var_109_0 = QuestSettings.stat_mappings[arg_109_2][1]
		local var_109_1 = arg_109_0:get_persistent_stat(arg_109_1, "quest_statistics", var_109_0) > 0
		local var_109_2 = QuestSettings.stat_mappings[arg_109_2][2]
		local var_109_3 = arg_109_0:get_persistent_stat(arg_109_1, "quest_statistics", var_109_2) > 0

		return var_109_1 and var_109_3
	end,
	requirements = function(arg_110_0, arg_110_1, arg_110_2)
		local var_110_0 = QuestSettings.stat_mappings[arg_110_2][1]
		local var_110_1 = arg_110_0:get_persistent_stat(arg_110_1, "quest_statistics", var_110_0) > 0
		local var_110_2 = QuestSettings.stat_mappings[arg_110_2][2]
		local var_110_3 = arg_110_0:get_persistent_stat(arg_110_1, "quest_statistics", var_110_2) > 0

		return {
			{
				name = "skaven_storm_vermin_warlord",
				completed = var_110_3
			},
			{
				name = "skaven_grey_seer",
				completed = var_110_1
			}
		}
	end
}

local function var_0_36(arg_111_0)
	local var_111_0 = 0

	local function var_111_1()
		var_111_0 = var_111_0 + 1

		return var_111_0
	end

	var_0_0.quests["quest_event_dwarf_fest_trollkiller" .. (arg_111_0 and "_repeatable" or "")] = {
		name = "quest_event_dwarf_fest_trollkiller_name",
		icon = "quest_book_event_dwarf_fest",
		desc = arg_111_0 and function()
			return string.format("%s (%s)", string.format(Localize("quest_event_dwarf_fest_trollkiller_desc"), QuestSettings.quest_event_dwarf_fest_trollkiller), Localize("repeatable"))
		end or function()
			return string.format(Localize("quest_event_dwarf_fest_trollkiller_desc"), QuestSettings.quest_event_dwarf_fest_trollkiller)
		end,
		custom_order = var_111_1(),
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
		completed = function(arg_115_0, arg_115_1, arg_115_2)
			local var_115_0 = QuestSettings.stat_mappings[arg_115_2][1]

			return arg_115_0:get_persistent_stat(arg_115_1, "quest_statistics", var_115_0) >= QuestSettings.quest_event_dwarf_fest_trollkiller
		end,
		progress = function(arg_116_0, arg_116_1, arg_116_2)
			local var_116_0 = QuestSettings.stat_mappings[arg_116_2][1]
			local var_116_1 = arg_116_0:get_persistent_stat(arg_116_1, "quest_statistics", var_116_0)

			return {
				var_116_1,
				QuestSettings.quest_event_dwarf_fest_trollkiller
			}
		end
	}

	local var_111_2 = {
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

	if arg_111_0 then
		var_111_1()
	else
		local var_111_3 = {
			"name_dwarf_fest_troll_001",
			"name_dwarf_fest_troll_002",
			"name_dwarf_fest_troll_003"
		}
		local var_111_4 = #var_111_2

		var_0_0.quests.quest_event_dwarf_fest_secret_trolls = {
			name = "quest_event_dwarf_fest_secret_trolls_name",
			icon = "quest_book_event_dwarf_fest",
			desc = function()
				return string.format(Localize("quest_event_dwarf_fest_secret_trolls_desc"), Localize(var_111_3[1]), Localize(var_111_3[2]), Localize(var_111_3[3]), Localize("level_name_dlc_dwarf_fest"))
			end,
			custom_order = var_111_1(),
			stat_mappings = var_111_2,
			completed = function(arg_118_0, arg_118_1, arg_118_2)
				for iter_118_0 = 1, var_111_4 do
					local var_118_0 = QuestSettings.stat_mappings[arg_118_2][iter_118_0]

					if arg_118_0:get_persistent_stat(arg_118_1, "quest_statistics", var_118_0) <= 0 then
						return false
					end
				end

				return true
			end,
			progress = function(arg_119_0, arg_119_1, arg_119_2)
				local var_119_0 = 0

				for iter_119_0 = 1, var_111_4 do
					local var_119_1 = QuestSettings.stat_mappings[arg_119_2][iter_119_0]

					var_119_0 = var_119_0 + math.min(arg_119_0:get_persistent_stat(arg_119_1, "quest_statistics", var_119_1), 1)
				end

				return {
					var_119_0,
					var_111_4
				}
			end,
			requirements = function(arg_120_0, arg_120_1, arg_120_2)
				local var_120_0 = {}

				for iter_120_0 = 1, var_111_4 do
					local var_120_1 = QuestSettings.stat_mappings[arg_120_2][iter_120_0]
					local var_120_2 = arg_120_0:get_persistent_stat(arg_120_1, "quest_statistics", var_120_1) > 0

					table.insert(var_120_0, {
						name = var_111_3[iter_120_0],
						completed = var_120_2
					})
				end

				return var_120_0
			end
		}
	end

	local function var_111_5(arg_121_0, arg_121_1)
		local var_121_0 = {
			{
				kills_per_breed_difficulty = {
					chaos_troll_chief = {}
				},
				kill_assists_per_breed_difficulty = {
					chaos_troll_chief = {}
				}
			}
		}
		local var_121_1 = DifficultySettings[arg_121_1].rank

		for iter_121_0, iter_121_1 in pairs(DifficultySettings) do
			if var_121_1 <= (iter_121_1.rank or math.huge) then
				var_121_0[1].kills_per_breed_difficulty.chaos_troll_chief[iter_121_0] = true
				var_121_0[1].kill_assists_per_breed_difficulty.chaos_troll_chief[iter_121_0] = true
			end
		end

		var_0_0.quests["quest_event_" .. arg_121_0 .. (arg_111_0 and "_repeatable" or "")] = {
			icon = "quest_book_event_dwarf_fest",
			name = "quest_event_" .. arg_121_0 .. "_name",
			desc = arg_111_0 and function()
				return string.format("%s (%s)", string.format(Localize("quest_event_dwarf_fest_troll_chief_desc"), Localize("chaos_troll_chief"), Localize(DifficultySettings[arg_121_1].display_name)), Localize("repeatable"))
			end or function()
				return string.format(Localize("quest_event_dwarf_fest_troll_chief_desc"), Localize("chaos_troll_chief"), Localize(DifficultySettings[arg_121_1].display_name))
			end,
			custom_order = var_111_1(),
			stat_mappings = var_121_0,
			completed = function(arg_124_0, arg_124_1, arg_124_2)
				local var_124_0 = QuestSettings.stat_mappings[arg_124_2][1]

				return arg_124_0:get_persistent_stat(arg_124_1, "quest_statistics", var_124_0) >= 1
			end,
			progress = function(arg_125_0, arg_125_1, arg_125_2)
				local var_125_0 = QuestSettings.stat_mappings[arg_125_2][1]
				local var_125_1 = arg_125_0:get_persistent_stat(arg_125_1, "quest_statistics", var_125_0)

				return {
					var_125_1,
					1
				}
			end
		}
	end

	for iter_111_0 = 1, #DefaultDifficulties do
		local var_111_6 = DefaultDifficulties[iter_111_0]
		local var_111_7 = DifficultyMapping[var_111_6]
		local var_111_8 = "dwarf_fest_troll_chief_" .. var_111_7

		var_111_5(var_111_8, var_111_6)
	end
end

var_0_36(false)
var_0_36(true)

local var_0_37 = {
	{
		played_levels_quickplay = {}
	}
}
local var_0_38 = {
	{
		played_levels_weekly_event = {}
	}
}

for iter_0_9 = 1, #UnlockableLevels do
	local var_0_39 = UnlockableLevels[iter_0_9]
	local var_0_40 = var_0_37[1].played_levels_quickplay
	local var_0_41 = var_0_38[1].played_levels_weekly_event

	var_0_40[var_0_39] = true
	var_0_41[var_0_39] = true
end

var_0_0.quests.weekly_complete_quickplay_missions = {
	name = "quest_daily_complete_quickplay_missions_name",
	icon = "quest_book_skull",
	desc = function()
		return string.format(Localize("quest_daily_complete_quickplay_missions_desc"), 25)
	end,
	stat_mappings = var_0_37,
	completed = function(arg_127_0, arg_127_1, arg_127_2)
		local var_127_0 = QuestSettings.stat_mappings[arg_127_2][1]

		return arg_127_0:get_persistent_stat(arg_127_1, "quest_statistics", var_127_0) >= 25
	end,
	progress = function(arg_128_0, arg_128_1, arg_128_2)
		local var_128_0 = QuestSettings.stat_mappings[arg_128_2][1]
		local var_128_1 = arg_128_0:get_persistent_stat(arg_128_1, "quest_statistics", var_128_0)

		return {
			var_128_1,
			25
		}
	end
}

for iter_0_10 = 1, 3 do
	local var_0_42 = "weekly_complete_quickplay_missions" .. "_" .. iter_0_10

	var_0_0.quests[var_0_42] = {
		name = "quest_daily_complete_quickplay_missions_name",
		icon = "quest_book_skull",
		desc = function()
			return string.format(Localize("quest_daily_complete_quickplay_missions_desc"), QuestSettings.weekly_complete_quickplay_missions[iter_0_10])
		end,
		stat_mappings = var_0_37,
		completed = function(arg_130_0, arg_130_1, arg_130_2)
			local var_130_0 = QuestSettings.stat_mappings[arg_130_2][1]

			return arg_130_0:get_persistent_stat(arg_130_1, "quest_statistics", var_130_0) >= QuestSettings.weekly_complete_quickplay_missions[iter_0_10]
		end,
		progress = function(arg_131_0, arg_131_1, arg_131_2)
			local var_131_0 = QuestSettings.stat_mappings[arg_131_2][1]
			local var_131_1 = arg_131_0:get_persistent_stat(arg_131_1, "quest_statistics", var_131_0)

			return {
				var_131_1,
				QuestSettings.weekly_complete_quickplay_missions[iter_0_10]
			}
		end
	}
end

for iter_0_11 = 1, 3 do
	local var_0_43 = "weekly_complete_weekly_event_missions" .. "_" .. iter_0_11

	var_0_0.quests[var_0_43] = {
		name = "quest_daily_complete_weekly_quest_missions_name",
		icon = "quest_book_skull",
		desc = function()
			return string.format(Localize("quest_daily_complete_weekly_event_missions_desc"), QuestSettings.weekly_complete_weekly_event_missions[iter_0_11])
		end,
		stat_mappings = var_0_38,
		completed = function(arg_133_0, arg_133_1, arg_133_2)
			local var_133_0 = QuestSettings.stat_mappings[arg_133_2][1]

			return arg_133_0:get_persistent_stat(arg_133_1, "quest_statistics", var_133_0) >= QuestSettings.weekly_complete_weekly_event_missions[iter_0_11]
		end,
		progress = function(arg_134_0, arg_134_1, arg_134_2)
			local var_134_0 = QuestSettings.stat_mappings[arg_134_2][1]
			local var_134_1 = arg_134_0:get_persistent_stat(arg_134_1, "quest_statistics", var_134_0)

			return {
				var_134_1,
				QuestSettings.weekly_complete_weekly_event_missions[iter_0_11]
			}
		end
	}
end

local var_0_44 = {
	{
		total_collected_tomes = true
	}
}

for iter_0_12 = 1, 3 do
	local var_0_45 = "weekly_collect_tomes" .. "_" .. iter_0_12

	var_0_0.quests[var_0_45] = {
		name = "quest_daily_collect_tomes_name",
		icon = "quest_book_tome",
		desc = function()
			return string.format(Localize("quest_daily_collect_tomes_desc"), QuestSettings.weekly_collect_tomes[iter_0_12])
		end,
		stat_mappings = var_0_44,
		completed = function(arg_136_0, arg_136_1, arg_136_2)
			local var_136_0 = QuestSettings.stat_mappings[arg_136_2][1]

			return arg_136_0:get_persistent_stat(arg_136_1, "quest_statistics", var_136_0) >= QuestSettings.weekly_collect_tomes[iter_0_12]
		end,
		progress = function(arg_137_0, arg_137_1, arg_137_2)
			local var_137_0 = QuestSettings.stat_mappings[arg_137_2][1]
			local var_137_1 = arg_137_0:get_persistent_stat(arg_137_1, "quest_statistics", var_137_0)

			return {
				var_137_1,
				QuestSettings.weekly_collect_tomes[iter_0_12]
			}
		end
	}
end

local var_0_46 = {
	{
		total_collected_grimoires = true
	}
}

for iter_0_13 = 1, 3 do
	local var_0_47 = "weekly_collect_grimoires" .. "_" .. iter_0_13

	var_0_0.quests[var_0_47] = {
		name = "quest_daily_collect_grimoires_name",
		icon = "quest_book_grimoire",
		desc = function()
			return string.format(Localize("quest_daily_collect_grimoires_desc"), QuestSettings.weekly_collect_grimoires[iter_0_13])
		end,
		stat_mappings = var_0_46,
		completed = function(arg_139_0, arg_139_1, arg_139_2)
			local var_139_0 = QuestSettings.stat_mappings[arg_139_2][1]

			return arg_139_0:get_persistent_stat(arg_139_1, "quest_statistics", var_139_0) >= QuestSettings.weekly_collect_grimoires[iter_0_13]
		end,
		progress = function(arg_140_0, arg_140_1, arg_140_2)
			local var_140_0 = QuestSettings.stat_mappings[arg_140_2][1]
			local var_140_1 = arg_140_0:get_persistent_stat(arg_140_1, "quest_statistics", var_140_0)

			return {
				var_140_1,
				QuestSettings.weekly_collect_grimoires[iter_0_13]
			}
		end
	}
end

local var_0_48 = {
	{
		total_collected_dice = true
	}
}

for iter_0_14 = 1, 3 do
	local var_0_49 = "weekly_collect_dice" .. "_" .. iter_0_14

	var_0_0.quests[var_0_49] = {
		name = "quest_daily_collect_loot_die_name",
		icon = "quest_book_generic_pickup",
		desc = function()
			return string.format(Localize("quest_daily_collect_loot_die_desc"), QuestSettings.weekly_collect_dice[iter_0_14])
		end,
		stat_mappings = var_0_48,
		completed = function(arg_142_0, arg_142_1, arg_142_2)
			local var_142_0 = QuestSettings.stat_mappings[arg_142_2][1]

			return arg_142_0:get_persistent_stat(arg_142_1, "quest_statistics", var_142_0) >= QuestSettings.weekly_collect_dice[iter_0_14]
		end,
		progress = function(arg_143_0, arg_143_1, arg_143_2)
			local var_143_0 = QuestSettings.stat_mappings[arg_143_2][1]
			local var_143_1 = arg_143_0:get_persistent_stat(arg_143_1, "quest_statistics", var_143_0)

			return {
				var_143_1,
				QuestSettings.weekly_collect_dice[iter_0_14]
			}
		end
	}
end

local var_0_50 = {
	{
		collected_painting_scraps_unlimited = true
	}
}

for iter_0_15 = 1, 3 do
	local var_0_51 = "weekly_collect_painting_scrap" .. "_" .. iter_0_15

	var_0_0.quests[var_0_51] = {
		name = "quest_daily_collect_painting_scrap_name",
		icon = "quest_book_generic_pickup",
		desc = function()
			return string.format(Localize("quest_daily_collect_painting_scrap_desc"), QuestSettings.weekly_collect_painting_scrap[iter_0_15])
		end,
		stat_mappings = var_0_50,
		completed = function(arg_145_0, arg_145_1, arg_145_2)
			local var_145_0 = QuestSettings.stat_mappings[arg_145_2][1]

			return arg_145_0:get_persistent_stat(arg_145_1, "quest_statistics", var_145_0) >= QuestSettings.weekly_collect_painting_scrap[iter_0_15]
		end,
		progress = function(arg_146_0, arg_146_1, arg_146_2)
			local var_146_0 = QuestSettings.stat_mappings[arg_146_2][1]
			local var_146_1 = arg_146_0:get_persistent_stat(arg_146_1, "quest_statistics", var_146_0)

			return {
				var_146_1,
				QuestSettings.weekly_collect_painting_scrap[iter_0_15]
			}
		end
	}
end

local var_0_52 = {
	{
		kills_critter_total = true
	}
}

for iter_0_16 = 1, 3 do
	local var_0_53 = "weekly_kill_critters_" .. iter_0_16

	var_0_0.quests[var_0_53] = {
		name = "quest_weekly_kill_critters_name",
		icon = "quest_book_skull",
		desc = function()
			return string.format(Localize("quest_weekly_kill_critters_desc"), QuestSettings.weekly_kill_critters[iter_0_16])
		end,
		stat_mappings = var_0_52,
		completed = function(arg_148_0, arg_148_1, arg_148_2)
			local var_148_0 = QuestSettings.stat_mappings[arg_148_2][1]

			return arg_148_0:get_persistent_stat(arg_148_1, "quest_statistics", var_148_0) >= QuestSettings.weekly_kill_critters[iter_0_16]
		end,
		progress = function(arg_149_0, arg_149_1, arg_149_2)
			local var_149_0 = QuestSettings.stat_mappings[arg_149_2][1]
			local var_149_1 = arg_149_0:get_persistent_stat(arg_149_1, "quest_statistics", var_149_0)

			return {
				var_149_1,
				QuestSettings.weekly_kill_critters[iter_0_16]
			}
		end
	}
end

local var_0_54 = {
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

for iter_0_17 = 1, 3 do
	local var_0_55 = "weekly_kill_bosses" .. "_" .. iter_0_17

	var_0_0.quests[var_0_55] = {
		name = "quest_daily_kill_bosses_name",
		icon = "quest_book_skull",
		desc = function()
			return string.format(Localize("quest_daily_kill_bosses_desc"), QuestSettings.weekly_kill_bosses[iter_0_17])
		end,
		stat_mappings = var_0_54,
		completed = function(arg_151_0, arg_151_1, arg_151_2)
			local var_151_0 = QuestSettings.stat_mappings[arg_151_2][1]

			return arg_151_0:get_persistent_stat(arg_151_1, "quest_statistics", var_151_0) >= QuestSettings.weekly_kill_bosses[iter_0_17]
		end,
		progress = function(arg_152_0, arg_152_1, arg_152_2)
			local var_152_0 = QuestSettings.stat_mappings[arg_152_2][1]
			local var_152_1 = arg_152_0:get_persistent_stat(arg_152_1, "quest_statistics", var_152_0)

			return {
				var_152_1,
				QuestSettings.weekly_kill_bosses[iter_0_17]
			}
		end
	}
end

local var_0_56 = {
	{
		kills_per_breed = {},
		kill_assists_per_breed = {}
	}
}

for iter_0_18, iter_0_19 in pairs(ELITES) do
	local var_0_57 = var_0_56[1].kills_per_breed
	local var_0_58 = var_0_56[1].kill_assists_per_breed

	var_0_57[iter_0_18] = true
	var_0_58[iter_0_18] = true
end

for iter_0_20 = 1, 3 do
	local var_0_59 = "weekly_kill_elites" .. "_" .. iter_0_20

	var_0_0.quests[var_0_59] = {
		name = "quest_daily_kill_elites_name",
		icon = "quest_book_skull",
		desc = function()
			return string.format(Localize("quest_daily_kill_elites_desc"), QuestSettings.weekly_kill_elites[iter_0_20])
		end,
		stat_mappings = var_0_56,
		completed = function(arg_154_0, arg_154_1, arg_154_2)
			local var_154_0 = QuestSettings.stat_mappings[arg_154_2][1]

			return arg_154_0:get_persistent_stat(arg_154_1, "quest_statistics", var_154_0) >= QuestSettings.weekly_kill_elites[iter_0_20]
		end,
		progress = function(arg_155_0, arg_155_1, arg_155_2)
			local var_155_0 = QuestSettings.stat_mappings[arg_155_2][1]
			local var_155_1 = arg_155_0:get_persistent_stat(arg_155_1, "quest_statistics", var_155_0)

			return {
				var_155_1,
				QuestSettings.weekly_kill_elites[iter_0_20]
			}
		end
	}
end

local var_0_60 = {
	{
		completed_levels_wood_elf = {}
	}
}

for iter_0_21 = 1, #UnlockableLevels do
	local var_0_61 = UnlockableLevels[iter_0_21]

	var_0_60[1].completed_levels_wood_elf[var_0_61] = true
end

for iter_0_22 = 1, 3 do
	local var_0_62 = "weekly_complete_levels_hero_wood_elf" .. "_" .. iter_0_22

	var_0_0.quests[var_0_62] = {
		name = "quest_daily_complete_levels_hero_wood_elf_name",
		icon = "quest_book_kerillian",
		desc = function()
			return string.format(Localize("quest_daily_complete_levels_hero_wood_elf_desc"), QuestSettings.weekly_complete_levels_hero_wood_elf[iter_0_22])
		end,
		stat_mappings = var_0_60,
		completed = function(arg_157_0, arg_157_1, arg_157_2)
			local var_157_0 = QuestSettings.stat_mappings[arg_157_2][1]

			return arg_157_0:get_persistent_stat(arg_157_1, "quest_statistics", var_157_0) >= QuestSettings.weekly_complete_levels_hero_wood_elf[iter_0_22]
		end,
		progress = function(arg_158_0, arg_158_1, arg_158_2)
			local var_158_0 = QuestSettings.stat_mappings[arg_158_2][1]
			local var_158_1 = arg_158_0:get_persistent_stat(arg_158_1, "quest_statistics", var_158_0)

			return {
				var_158_1,
				QuestSettings.weekly_complete_levels_hero_wood_elf[iter_0_22]
			}
		end
	}
end

local var_0_63 = {
	{
		completed_levels_witch_hunter = {}
	}
}

for iter_0_23 = 1, #UnlockableLevels do
	local var_0_64 = UnlockableLevels[iter_0_23]

	var_0_63[1].completed_levels_witch_hunter[var_0_64] = true
end

for iter_0_24 = 1, 3 do
	local var_0_65 = "weekly_complete_levels_hero_witch_hunter" .. "_" .. iter_0_24

	var_0_0.quests[var_0_65] = {
		name = "quest_daily_complete_levels_hero_witch_hunter_name",
		icon = "quest_book_saltzpyre",
		desc = function()
			return string.format(Localize("quest_daily_complete_levels_hero_witch_hunter_desc"), QuestSettings.weekly_complete_levels_hero_witch_hunter[iter_0_24])
		end,
		stat_mappings = var_0_63,
		completed = function(arg_160_0, arg_160_1, arg_160_2)
			local var_160_0 = QuestSettings.stat_mappings[arg_160_2][1]

			return arg_160_0:get_persistent_stat(arg_160_1, "quest_statistics", var_160_0) >= QuestSettings.weekly_complete_levels_hero_witch_hunter[iter_0_24]
		end,
		progress = function(arg_161_0, arg_161_1, arg_161_2)
			local var_161_0 = QuestSettings.stat_mappings[arg_161_2][1]
			local var_161_1 = arg_161_0:get_persistent_stat(arg_161_1, "quest_statistics", var_161_0)

			return {
				var_161_1,
				QuestSettings.weekly_complete_levels_hero_witch_hunter[iter_0_24]
			}
		end
	}
end

local var_0_66 = {
	{
		completed_levels_dwarf_ranger = {}
	}
}

for iter_0_25 = 1, #UnlockableLevels do
	local var_0_67 = UnlockableLevels[iter_0_25]

	var_0_66[1].completed_levels_dwarf_ranger[var_0_67] = true
end

for iter_0_26 = 1, 3 do
	local var_0_68 = "weekly_complete_levels_hero_dwarf_ranger" .. "_" .. iter_0_26

	var_0_0.quests[var_0_68] = {
		name = "quest_daily_complete_levels_hero_dwarf_ranger_name",
		icon = "quest_book_bardin",
		desc = function()
			return string.format(Localize("quest_daily_complete_levels_hero_dwarf_ranger_desc"), QuestSettings.weekly_complete_levels_hero_dwarf_ranger[iter_0_26])
		end,
		stat_mappings = var_0_66,
		completed = function(arg_163_0, arg_163_1, arg_163_2)
			local var_163_0 = QuestSettings.stat_mappings[arg_163_2][1]

			return arg_163_0:get_persistent_stat(arg_163_1, "quest_statistics", var_163_0) >= QuestSettings.weekly_complete_levels_hero_dwarf_ranger[iter_0_26]
		end,
		progress = function(arg_164_0, arg_164_1, arg_164_2)
			local var_164_0 = QuestSettings.stat_mappings[arg_164_2][1]
			local var_164_1 = arg_164_0:get_persistent_stat(arg_164_1, "quest_statistics", var_164_0)

			return {
				var_164_1,
				QuestSettings.weekly_complete_levels_hero_dwarf_ranger[iter_0_26]
			}
		end
	}
end

local var_0_69 = {
	{
		completed_levels_bright_wizard = {}
	}
}

for iter_0_27 = 1, #UnlockableLevels do
	local var_0_70 = UnlockableLevels[iter_0_27]

	var_0_69[1].completed_levels_bright_wizard[var_0_70] = true
end

for iter_0_28 = 1, 3 do
	local var_0_71 = "weekly_complete_levels_hero_bright_wizard" .. "_" .. iter_0_28

	var_0_0.quests[var_0_71] = {
		name = "quest_daily_complete_levels_hero_bright_wizard_name",
		icon = "quest_book_sienna",
		desc = function()
			return string.format(Localize("quest_daily_complete_levels_hero_bright_wizard_desc"), QuestSettings.weekly_complete_levels_hero_bright_wizard[iter_0_28])
		end,
		stat_mappings = var_0_69,
		completed = function(arg_166_0, arg_166_1, arg_166_2)
			local var_166_0 = QuestSettings.stat_mappings[arg_166_2][1]

			return arg_166_0:get_persistent_stat(arg_166_1, "quest_statistics", var_166_0) >= QuestSettings.weekly_complete_levels_hero_bright_wizard[iter_0_28]
		end,
		progress = function(arg_167_0, arg_167_1, arg_167_2)
			local var_167_0 = QuestSettings.stat_mappings[arg_167_2][1]
			local var_167_1 = arg_167_0:get_persistent_stat(arg_167_1, "quest_statistics", var_167_0)

			return {
				var_167_1,
				QuestSettings.weekly_complete_levels_hero_bright_wizard[iter_0_28]
			}
		end
	}
end

local var_0_72 = {
	{
		completed_levels_empire_soldier = {}
	}
}

for iter_0_29 = 1, #UnlockableLevels do
	local var_0_73 = UnlockableLevels[iter_0_29]

	var_0_72[1].completed_levels_empire_soldier[var_0_73] = true
end

for iter_0_30 = 1, 3 do
	local var_0_74 = "weekly_complete_levels_hero_empire_soldier" .. "_" .. iter_0_30

	var_0_0.quests[var_0_74] = {
		name = "quest_daily_complete_levels_hero_empire_soldier_name",
		icon = "quest_book_kruber",
		desc = function()
			return string.format(Localize("quest_daily_complete_levels_hero_empire_soldier_desc"), QuestSettings.weekly_complete_levels_hero_empire_soldier[iter_0_30])
		end,
		stat_mappings = var_0_72,
		completed = function(arg_169_0, arg_169_1, arg_169_2)
			local var_169_0 = QuestSettings.stat_mappings[arg_169_2][1]

			return arg_169_0:get_persistent_stat(arg_169_1, "quest_statistics", var_169_0) >= QuestSettings.weekly_complete_levels_hero_empire_soldier[iter_0_30]
		end,
		progress = function(arg_170_0, arg_170_1, arg_170_2)
			local var_170_0 = QuestSettings.stat_mappings[arg_170_2][1]
			local var_170_1 = arg_170_0:get_persistent_stat(arg_170_1, "quest_statistics", var_170_0)

			return {
				var_170_1,
				QuestSettings.weekly_complete_levels_hero_empire_soldier[iter_0_30]
			}
		end
	}
end

local var_0_75 = {
	{
		headshots = true
	}
}

for iter_0_31 = 1, 3 do
	local var_0_76 = "weekly_score_headshots" .. "_" .. iter_0_31

	var_0_0.quests[var_0_76] = {
		name = "quest_daily_score_headshots_name",
		icon = "quest_book_skull",
		desc = function()
			return string.format(Localize("quest_daily_score_headshots_desc"), QuestSettings.weekly_score_headshots[iter_0_31])
		end,
		stat_mappings = var_0_75,
		completed = function(arg_172_0, arg_172_1, arg_172_2)
			local var_172_0 = QuestSettings.stat_mappings[arg_172_2][1]

			return arg_172_0:get_persistent_stat(arg_172_1, "quest_statistics", var_172_0) >= QuestSettings.weekly_score_headshots[iter_0_31]
		end,
		progress = function(arg_173_0, arg_173_1, arg_173_2)
			local var_173_0 = QuestSettings.stat_mappings[arg_173_2][1]
			local var_173_1 = arg_173_0:get_persistent_stat(arg_173_1, "quest_statistics", var_173_0)

			return {
				var_173_1,
				QuestSettings.weekly_score_headshots[iter_0_31]
			}
		end
	}
end

local var_0_77 = {
	{
		completed_daily_quests = true
	}
}

for iter_0_32 = 1, 3 do
	local var_0_78 = "weekly_daily_quests" .. "_" .. iter_0_32

	var_0_0.quests[var_0_78] = {
		name = "quest_weekly_daily_quests_name",
		icon = "quest_book_skull",
		desc = function()
			return string.format(Localize("quest_weekly_daily_quests_desc"), QuestSettings.weekly_daily_quests[iter_0_32])
		end,
		stat_mappings = var_0_77,
		completed = function(arg_175_0, arg_175_1, arg_175_2)
			local var_175_0 = QuestSettings.stat_mappings[arg_175_2][1]

			return arg_175_0:get_persistent_stat(arg_175_1, "quest_statistics", var_175_0) >= QuestSettings.weekly_daily_quests[iter_0_32]
		end,
		progress = function(arg_176_0, arg_176_1, arg_176_2)
			local var_176_0 = QuestSettings.stat_mappings[arg_176_2][1]
			local var_176_1 = arg_176_0:get_persistent_stat(arg_176_1, "quest_statistics", var_176_0)

			return {
				var_176_1,
				QuestSettings.weekly_daily_quests[iter_0_32]
			}
		end
	}
end

DLCUtils.merge("quest_templates", var_0_0.quests)

return var_0_0
