-- chunkname: @scripts/managers/quest/quest_templates.lua

local tbl = {
	quests = {}
}
local tbl_2 = {
	{
		played_levels_quickplay = {}
	}
}

for i = 1, #UnlockableLevels do
	local var_0_2 = UnlockableLevels[i]

	tbl_2[1].played_levels_quickplay[var_0_2] = true
end

tbl.quests.daily_complete_quickplay_missions = {
	name = "quest_daily_complete_quickplay_missions_name",
	icon = "quest_book_skull",
	desc = function ()
		-- function 1
		return string.format(Localize("quest_daily_complete_quickplay_missions_desc"), QuestSettings.daily_complete_quickplay_missions)
	end,
	stat_mappings = tbl_2,
	completed = function (self, arg_2_1, arg_2_2)
		-- function 2
		local var_2_0 = QuestSettings.stat_mappings[arg_2_2][1]

		return self:get_persistent_stat(arg_2_1, "quest_statistics", var_2_0) >= QuestSettings.daily_complete_quickplay_missions
	end,
	progress = function (self, arg_3_1, arg_3_2)
		-- function 3
		local var_3_0 = QuestSettings.stat_mappings[arg_3_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_3_1, "quest_statistics", var_3_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_complete_quickplay_missions
		}
	end
}

local tbl_3 = {
	{
		total_collected_tomes = true
	}
}

tbl.quests.daily_collect_tomes = {
	name = "quest_daily_collect_tomes_name",
	icon = "quest_book_tome",
	desc = function ()
		-- function 4
		return string.format(Localize("quest_daily_collect_tomes_desc"), QuestSettings.daily_collect_tomes)
	end,
	stat_mappings = tbl_3,
	completed = function (self, arg_5_1, arg_5_2)
		-- function 5
		local var_5_0 = QuestSettings.stat_mappings[arg_5_2][1]

		return self:get_persistent_stat(arg_5_1, "quest_statistics", var_5_0) >= QuestSettings.daily_collect_tomes
	end,
	progress = function (self, arg_6_1, arg_6_2)
		-- function 6
		local var_6_0 = QuestSettings.stat_mappings[arg_6_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_6_1, "quest_statistics", var_6_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_collect_tomes
		}
	end
}

local tbl_4 = {
	{
		total_collected_grimoires = true
	}
}

tbl.quests.daily_collect_grimoires = {
	name = "quest_daily_collect_grimoires_name",
	icon = "quest_book_grimoire",
	desc = function ()
		-- function 7
		return string.format(Localize("quest_daily_collect_grimoires_desc"), QuestSettings.daily_collect_grimoires)
	end,
	stat_mappings = tbl_4,
	completed = function (self, arg_8_1, arg_8_2)
		-- function 8
		local var_8_0 = QuestSettings.stat_mappings[arg_8_2][1]

		return self:get_persistent_stat(arg_8_1, "quest_statistics", var_8_0) >= QuestSettings.daily_collect_grimoires
	end,
	progress = function (self, arg_9_1, arg_9_2)
		-- function 9
		local var_9_0 = QuestSettings.stat_mappings[arg_9_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_9_1, "quest_statistics", var_9_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_collect_grimoires
		}
	end
}

local tbl_5 = {
	{
		total_collected_dice = true
	}
}

tbl.quests.daily_collect_loot_die = {
	name = "quest_daily_collect_loot_die_name",
	icon = "quest_book_generic_pickup",
	desc = function ()
		-- function 10
		return string.format(Localize("quest_daily_collect_loot_die_desc"), QuestSettings.daily_collect_loot_die)
	end,
	stat_mappings = tbl_5,
	completed = function (self, arg_11_1, arg_11_2)
		-- function 11
		local var_11_0 = QuestSettings.stat_mappings[arg_11_2][1]

		return self:get_persistent_stat(arg_11_1, "quest_statistics", var_11_0) >= QuestSettings.daily_collect_loot_die
	end,
	progress = function (self, arg_12_1, arg_12_2)
		-- function 12
		local var_12_0 = QuestSettings.stat_mappings[arg_12_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_12_1, "quest_statistics", var_12_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_collect_loot_die
		}
	end
}

local tbl_6 = {
	{
		collected_painting_scraps_unlimited = true
	}
}

tbl.quests.daily_collect_painting_scrap = {
	name = "quest_daily_collect_painting_scrap_name",
	icon = "quest_book_generic_pickup",
	desc = function ()
		-- function 13
		return string.format(Localize("quest_daily_collect_painting_scrap_desc"), QuestSettings.daily_collect_painting_scrap)
	end,
	stat_mappings = tbl_6,
	completed = function (self, arg_14_1, arg_14_2)
		-- function 14
		local var_14_0 = QuestSettings.stat_mappings[arg_14_2][1]

		return self:get_persistent_stat(arg_14_1, "quest_statistics", var_14_0) >= QuestSettings.daily_collect_painting_scrap
	end,
	progress = function (self, arg_15_1, arg_15_2)
		-- function 15
		local var_15_0 = QuestSettings.stat_mappings[arg_15_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_15_1, "quest_statistics", var_15_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_collect_painting_scrap
		}
	end
}

local tbl_7 = {
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

tbl.quests.daily_kill_bosses = {
	name = "quest_daily_kill_bosses_name",
	icon = "quest_book_skull",
	desc = function ()
		-- function 16
		return string.format(Localize("quest_daily_kill_bosses_desc"), QuestSettings.daily_kill_bosses)
	end,
	stat_mappings = tbl_7,
	completed = function (self, arg_17_1, arg_17_2)
		-- function 17
		local var_17_0 = QuestSettings.stat_mappings[arg_17_2][1]

		return self:get_persistent_stat(arg_17_1, "quest_statistics", var_17_0) >= QuestSettings.daily_kill_bosses
	end,
	progress = function (self, arg_18_1, arg_18_2)
		-- function 18
		local var_18_0 = QuestSettings.stat_mappings[arg_18_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_18_1, "quest_statistics", var_18_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_kill_bosses
		}
	end
}

local tbl_8 = {
	{
		kills_per_breed = {},
		kill_assists_per_breed = {}
	}
}

for k, v in pairs(ELITES) do
	local kills_per_breed = tbl_8[1].kills_per_breed
	local kill_assists_per_breed = tbl_8[1].kill_assists_per_breed

	kills_per_breed[k] = true
	kill_assists_per_breed[k] = true
end

tbl.quests.daily_kill_elites = {
	name = "quest_daily_kill_elites_name",
	icon = "quest_book_skull",
	desc = function ()
		-- function 19
		return string.format(Localize("quest_daily_kill_elites_desc"), QuestSettings.daily_kill_elites)
	end,
	stat_mappings = tbl_8,
	completed = function (self, arg_20_1, arg_20_2)
		-- function 20
		local var_20_0 = QuestSettings.stat_mappings[arg_20_2][1]

		return self:get_persistent_stat(arg_20_1, "quest_statistics", var_20_0) >= QuestSettings.daily_kill_elites
	end,
	progress = function (self, arg_21_1, arg_21_2)
		-- function 21
		local var_21_0 = QuestSettings.stat_mappings[arg_21_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_21_1, "quest_statistics", var_21_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_kill_elites
		}
	end
}

local tbl_9 = {
	{
		kills_critter_total = true
	}
}

tbl.quests.daily_kill_critters = {
	name = "quest_daily_kill_critters_name",
	icon = "quest_book_skull",
	desc = function ()
		-- function 22
		return string.format(Localize("quest_daily_kill_critters_desc"), QuestSettings.daily_kill_critters)
	end,
	stat_mappings = tbl_9,
	completed = function (self, arg_23_1, arg_23_2)
		-- function 23
		local var_23_0 = QuestSettings.stat_mappings[arg_23_2][1]

		return self:get_persistent_stat(arg_23_1, "quest_statistics", var_23_0) >= QuestSettings.daily_kill_critters
	end,
	progress = function (self, arg_24_1, arg_24_2)
		-- function 24
		local var_24_0 = QuestSettings.stat_mappings[arg_24_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_24_1, "quest_statistics", var_24_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_kill_critters
		}
	end
}

local tbl_10 = {
	{
		completed_levels_wood_elf = {}
	}
}

for l = 1, #UnlockableLevels do
	local var_0_13 = UnlockableLevels[l]

	tbl_10[1].completed_levels_wood_elf[var_0_13] = true
end

tbl.quests.daily_complete_levels_hero_wood_elf = {
	name = "quest_daily_complete_levels_hero_wood_elf_name",
	icon = "quest_book_kerillian",
	desc = function ()
		-- function 25
		return string.format(Localize("quest_daily_complete_levels_hero_wood_elf_desc"), QuestSettings.daily_complete_levels_hero_wood_elf)
	end,
	stat_mappings = tbl_10,
	completed = function (self, arg_26_1, arg_26_2)
		-- function 26
		local var_26_0 = QuestSettings.stat_mappings[arg_26_2][1]

		return self:get_persistent_stat(arg_26_1, "quest_statistics", var_26_0) >= QuestSettings.daily_complete_levels_hero_wood_elf
	end,
	progress = function (self, arg_27_1, arg_27_2)
		-- function 27
		local var_27_0 = QuestSettings.stat_mappings[arg_27_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_27_1, "quest_statistics", var_27_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_complete_levels_hero_wood_elf
		}
	end
}

local tbl_11 = {
	{
		completed_levels_witch_hunter = {}
	}
}

for i4 = 1, #UnlockableLevels do
	local var_0_15 = UnlockableLevels[i4]

	tbl_11[1].completed_levels_witch_hunter[var_0_15] = true
end

tbl.quests.daily_complete_levels_hero_witch_hunter = {
	name = "quest_daily_complete_levels_hero_witch_hunter_name",
	icon = "quest_book_saltzpyre",
	desc = function ()
		-- function 28
		return string.format(Localize("quest_daily_complete_levels_hero_witch_hunter_desc"), QuestSettings.daily_complete_levels_hero_witch_hunter)
	end,
	stat_mappings = tbl_11,
	completed = function (self, arg_29_1, arg_29_2)
		-- function 29
		local var_29_0 = QuestSettings.stat_mappings[arg_29_2][1]

		return self:get_persistent_stat(arg_29_1, "quest_statistics", var_29_0) >= QuestSettings.daily_complete_levels_hero_witch_hunter
	end,
	progress = function (self, arg_30_1, arg_30_2)
		-- function 30
		local var_30_0 = QuestSettings.stat_mappings[arg_30_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_30_1, "quest_statistics", var_30_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_complete_levels_hero_witch_hunter
		}
	end
}

local tbl_12 = {
	{
		completed_levels_dwarf_ranger = {}
	}
}

for i5 = 1, #UnlockableLevels do
	local var_0_17 = UnlockableLevels[i5]

	tbl_12[1].completed_levels_dwarf_ranger[var_0_17] = true
end

tbl.quests.daily_complete_levels_hero_dwarf_ranger = {
	name = "quest_daily_complete_levels_hero_dwarf_ranger_name",
	icon = "quest_book_bardin",
	desc = function ()
		-- function 31
		return string.format(Localize("quest_daily_complete_levels_hero_dwarf_ranger_desc"), QuestSettings.daily_complete_levels_hero_dwarf_ranger)
	end,
	stat_mappings = tbl_12,
	completed = function (self, arg_32_1, arg_32_2)
		-- function 32
		local var_32_0 = QuestSettings.stat_mappings[arg_32_2][1]

		return self:get_persistent_stat(arg_32_1, "quest_statistics", var_32_0) >= QuestSettings.daily_complete_levels_hero_dwarf_ranger
	end,
	progress = function (self, arg_33_1, arg_33_2)
		-- function 33
		local var_33_0 = QuestSettings.stat_mappings[arg_33_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_33_1, "quest_statistics", var_33_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_complete_levels_hero_dwarf_ranger
		}
	end
}

local tbl_13 = {
	{
		completed_levels_bright_wizard = {}
	}
}

for i6 = 1, #UnlockableLevels do
	local var_0_19 = UnlockableLevels[i6]

	tbl_13[1].completed_levels_bright_wizard[var_0_19] = true
end

tbl.quests.daily_complete_levels_hero_bright_wizard = {
	name = "quest_daily_complete_levels_hero_bright_wizard_name",
	icon = "quest_book_sienna",
	desc = function ()
		-- function 34
		return string.format(Localize("quest_daily_complete_levels_hero_bright_wizard_desc"), QuestSettings.daily_complete_levels_hero_bright_wizard)
	end,
	stat_mappings = tbl_13,
	completed = function (self, arg_35_1, arg_35_2)
		-- function 35
		local var_35_0 = QuestSettings.stat_mappings[arg_35_2][1]

		return self:get_persistent_stat(arg_35_1, "quest_statistics", var_35_0) >= QuestSettings.daily_complete_levels_hero_bright_wizard
	end,
	progress = function (self, arg_36_1, arg_36_2)
		-- function 36
		local var_36_0 = QuestSettings.stat_mappings[arg_36_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_36_1, "quest_statistics", var_36_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_complete_levels_hero_bright_wizard
		}
	end
}

local tbl_14 = {
	{
		completed_levels_empire_soldier = {}
	}
}

for i7 = 1, #UnlockableLevels do
	local var_0_21 = UnlockableLevels[i7]

	tbl_14[1].completed_levels_empire_soldier[var_0_21] = true
end

tbl.quests.daily_complete_levels_hero_empire_soldier = {
	name = "quest_daily_complete_levels_hero_empire_soldier_name",
	icon = "quest_book_kruber",
	desc = function ()
		-- function 37
		return string.format(Localize("quest_daily_complete_levels_hero_empire_soldier_desc"), QuestSettings.daily_complete_levels_hero_empire_soldier)
	end,
	stat_mappings = tbl_14,
	completed = function (self, arg_38_1, arg_38_2)
		-- function 38
		local var_38_0 = QuestSettings.stat_mappings[arg_38_2][1]

		return self:get_persistent_stat(arg_38_1, "quest_statistics", var_38_0) >= QuestSettings.daily_complete_levels_hero_empire_soldier
	end,
	progress = function (self, arg_39_1, arg_39_2)
		-- function 39
		local var_39_0 = QuestSettings.stat_mappings[arg_39_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_39_1, "quest_statistics", var_39_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_complete_levels_hero_empire_soldier
		}
	end
}

local tbl_15 = {
	{
		headshots = true
	}
}

tbl.quests.daily_score_headshots = {
	name = "quest_daily_score_headshots_name",
	icon = "quest_book_skull",
	desc = function ()
		-- function 40
		return string.format(Localize("quest_daily_score_headshots_desc"), QuestSettings.daily_score_headshots)
	end,
	stat_mappings = tbl_15,
	completed = function (self, arg_41_1, arg_41_2)
		-- function 41
		local var_41_0 = QuestSettings.stat_mappings[arg_41_2][1]

		return self:get_persistent_stat(arg_41_1, "quest_statistics", var_41_0) >= QuestSettings.daily_score_headshots
	end,
	progress = function (self, arg_42_1, arg_42_2)
		-- function 42
		local var_42_0 = QuestSettings.stat_mappings[arg_42_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_42_1, "quest_statistics", var_42_0)

		return {
			get_persistent_stat,
			QuestSettings.daily_score_headshots
		}
	end
}

local tbl_16 = {
	{
		played_levels_quickplay = {}
	}
}
local tbl_17 = {
	{
		played_levels_weekly_event = {}
	}
}

for i8 = 1, #UnlockableLevels do
	local var_0_25 = UnlockableLevels[i8]

	tbl_16[1].played_levels_quickplay[var_0_25] = true
	tbl_17[1].played_levels_weekly_event[var_0_25] = true
end

tbl.quests.event_skulls_for_the_skull_throne = {
	name = "quest_event_skull_2018_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function ()
		-- function 43
		return string.format(Localize("quest_event_skull_2018_desc"), QuestSettings.event_skulls_quickplay)
	end,
	stat_mappings = tbl_16,
	completed = function (self, arg_44_1, arg_44_2)
		-- function 44
		local var_44_0 = QuestSettings.stat_mappings[arg_44_2][1]

		return self:get_persistent_stat(arg_44_1, "quest_statistics", var_44_0) >= QuestSettings.event_skulls_quickplay
	end,
	progress = function (self, arg_45_1, arg_45_2)
		-- function 45
		local var_45_0 = QuestSettings.stat_mappings[arg_45_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_45_1, "quest_statistics", var_45_0)

		return {
			get_persistent_stat,
			QuestSettings.event_skulls_quickplay
		}
	end
}
tbl.quests.event_sonnstill_quickplay_2018 = {
	name = "quest_event_summer_2018_quickplay_name",
	icon = "quest_book_event_summer",
	desc = function ()
		-- function 46
		return string.format(Localize("quest_event_summer_2018_quickplay_desc"), QuestSettings.event_sonnstill_quickplay_levels)
	end,
	stat_mappings = tbl_16,
	completed = function (self, arg_47_1, arg_47_2)
		-- function 47
		local var_47_0 = QuestSettings.stat_mappings[arg_47_2][1]

		return self:get_persistent_stat(arg_47_1, "quest_statistics", var_47_0) >= QuestSettings.event_sonnstill_quickplay_levels
	end,
	progress = function (self, arg_48_1, arg_48_2)
		-- function 48
		local var_48_0 = QuestSettings.stat_mappings[arg_48_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_48_1, "quest_statistics", var_48_0)

		return {
			get_persistent_stat,
			QuestSettings.event_sonnstill_quickplay_levels
		}
	end
}

local tbl_18 = {
	{
		played_difficulty = {
			harder = true,
			hardest = true
		}
	}
}

tbl.quests.event_sonnstill_played_champion_2018 = {
	name = "quest_event_summer_2018_champion_name",
	icon = "quest_book_event_summer",
	desc = function ()
		-- function 49
		return string.format(Localize("quest_event_summer_2018_champion_desc"), QuestSettings.event_sonnstill_difficulty_levels)
	end,
	stat_mappings = tbl_18,
	completed = function (self, arg_50_1, arg_50_2)
		-- function 50
		local var_50_0 = QuestSettings.stat_mappings[arg_50_2][1]

		return self:get_persistent_stat(arg_50_1, "quest_statistics", var_50_0) >= QuestSettings.event_sonnstill_difficulty_levels
	end,
	progress = function (self, arg_51_1, arg_51_2)
		-- function 51
		local var_51_0 = QuestSettings.stat_mappings[arg_51_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_51_1, "quest_statistics", var_51_0)

		return {
			get_persistent_stat,
			QuestSettings.event_sonnstill_quickplay_levels
		}
	end
}

local tbl_19 = {
	{
		played_difficulty = {
			hardest = true
		}
	}
}

tbl.quests.event_sonnstill_played_legend_2018 = {
	name = "quest_event_summer_2018_legend_name",
	icon = "quest_book_event_summer",
	desc = function ()
		-- function 52
		return string.format(Localize("quest_event_summer_2018_legend_desc"), QuestSettings.event_sonnstill_difficulty_levels)
	end,
	stat_mappings = tbl_19,
	completed = function (self, arg_53_1, arg_53_2)
		-- function 53
		local var_53_0 = QuestSettings.stat_mappings[arg_53_2][1]

		return self:get_persistent_stat(arg_53_1, "quest_statistics", var_53_0) >= QuestSettings.event_sonnstill_difficulty_levels
	end,
	progress = function (self, arg_54_1, arg_54_2)
		-- function 54
		local var_54_0 = QuestSettings.stat_mappings[arg_54_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_54_1, "quest_statistics", var_54_0)

		return {
			get_persistent_stat,
			QuestSettings.event_sonnstill_quickplay_levels
		}
	end
}
tbl.quests.event_geheimnisnacht_quickplay_2018 = {
	name = "quest_event_geheimnisnacht_2018_quickplay_name",
	icon = "quest_book_geheimnisnacht",
	desc = function ()
		-- function 55
		return string.format(Localize("quest_event_summer_2018_quickplay_desc"), QuestSettings.event_geheimnisnacht_quickplay_levels)
	end,
	stat_mappings = tbl_16,
	completed = function (self, arg_56_1, arg_56_2)
		-- function 56
		local var_56_0 = QuestSettings.stat_mappings[arg_56_2][1]

		return self:get_persistent_stat(arg_56_1, "quest_statistics", var_56_0) >= QuestSettings.event_geheimnisnacht_quickplay_levels
	end,
	progress = function (self, arg_57_1, arg_57_2)
		-- function 57
		local var_57_0 = QuestSettings.stat_mappings[arg_57_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_57_1, "quest_statistics", var_57_0)

		return {
			get_persistent_stat,
			QuestSettings.event_geheimnisnacht_quickplay_levels
		}
	end
}
tbl.quests.event_geheimnisnacht_quickplay_2019 = {
	name = "quest_event_geheimnisnacht_2019_quickplay_name",
	icon = "quest_book_geheimnisnacht",
	desc = function ()
		-- function 58
		return string.format(Localize("quest_event_summer_2018_quickplay_desc"), QuestSettings.event_geheimnisnacht_quickplay_levels)
	end,
	stat_mappings = tbl_16,
	completed = function (self, arg_59_1, arg_59_2)
		-- function 59
		local var_59_0 = QuestSettings.stat_mappings[arg_59_2][1]

		return self:get_persistent_stat(arg_59_1, "quest_statistics", var_59_0) >= QuestSettings.event_geheimnisnacht_quickplay_levels
	end,
	progress = function (self, arg_60_1, arg_60_2)
		-- function 60
		local var_60_0 = QuestSettings.stat_mappings[arg_60_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_60_1, "quest_statistics", var_60_0)

		return {
			get_persistent_stat,
			QuestSettings.event_geheimnisnacht_quickplay_levels
		}
	end
}
tbl.quests.event_geheimnisnacht_weekly_event_2019 = {
	name = "quest_event_geheimnisnacht_weekly_event_2019_name",
	icon = "quest_book_geheimnisnacht",
	desc = "complete_one_weekly_event",
	stat_mappings = tbl_17,
	completed = function (self, arg_61_1, arg_61_2)
		-- function 61
		local var_61_0 = QuestSettings.stat_mappings[arg_61_2][1]

		return self:get_persistent_stat(arg_61_1, "quest_statistics", var_61_0) > 0
	end
}

local tbl_20 = {
	{
		played_difficulty = {
			harder = true,
			hardest = true
		}
	}
}

tbl.quests.event_geheimnisnacht_played_champion_2018 = {
	name = "quest_event_geheimnisnacht_2018_champion_name",
	icon = "quest_book_geheimnisnacht",
	desc = function ()
		-- function 62
		return string.format(Localize("quest_event_summer_2018_champion_desc"), QuestSettings.event_geheimnisnacht_difficulty_levels)
	end,
	stat_mappings = tbl_20,
	completed = function (self, arg_63_1, arg_63_2)
		-- function 63
		local var_63_0 = QuestSettings.stat_mappings[arg_63_2][1]

		return self:get_persistent_stat(arg_63_1, "quest_statistics", var_63_0) >= QuestSettings.event_geheimnisnacht_difficulty_levels
	end,
	progress = function (self, arg_64_1, arg_64_2)
		-- function 64
		local var_64_0 = QuestSettings.stat_mappings[arg_64_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_64_1, "quest_statistics", var_64_0)

		return {
			get_persistent_stat,
			QuestSettings.event_geheimnisnacht_quickplay_levels
		}
	end
}

local tbl_21 = {
	{
		played_difficulty = {
			hardest = true
		}
	}
}

tbl.quests.event_geheimnisnacht_played_legend_2018 = {
	name = "quest_event_geheimnisnacht_2018_legend_name",
	icon = "quest_book_geheimnisnacht",
	desc = function ()
		-- function 65
		return string.format(Localize("quest_event_summer_2018_legend_desc"), QuestSettings.event_geheimnisnacht_difficulty_levels)
	end,
	stat_mappings = tbl_21,
	completed = function (self, arg_66_1, arg_66_2)
		-- function 66
		local var_66_0 = QuestSettings.stat_mappings[arg_66_2][1]

		return self:get_persistent_stat(arg_66_1, "quest_statistics", var_66_0) >= QuestSettings.event_geheimnisnacht_difficulty_levels
	end,
	progress = function (self, arg_67_1, arg_67_2)
		-- function 67
		local var_67_0 = QuestSettings.stat_mappings[arg_67_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_67_1, "quest_statistics", var_67_0)

		return {
			get_persistent_stat,
			QuestSettings.event_geheimnisnacht_quickplay_levels
		}
	end
}
tbl.quests.event_mondstille_bonfires_2018 = {
	name = "quest_mondstille_01_name",
	icon = "quest_book_mondstille",
	desc = "quest_mondstille_01_desc",
	completed = function (self, arg_68_1)
		-- function 68
		if not (not (self:get_persistent_stat(arg_68_1, "bonfire_lit_mines") > 0) or not (self:get_persistent_stat(arg_68_1, "bonfire_lit_fort") > 0) or not (self:get_persistent_stat(arg_68_1, "bonfire_lit_warcamp") > 0) or not (self:get_persistent_stat(arg_68_1, "bonfire_lit_skittergate") > 0)) then
			return true
		end

		return false
	end,
	progress = function (self, arg_69_1)
		-- function 69
		local num = 0

		if self:get_persistent_stat(arg_69_1, "bonfire_lit_mines") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_69_1, "bonfire_lit_fort") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_69_1, "bonfire_lit_warcamp") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_69_1, "bonfire_lit_skittergate") > 0 then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (self, arg_70_1)
		-- function 70
		local flag = self:get_persistent_stat(arg_70_1, "bonfire_lit_mines") > 0
		local flag_2 = self:get_persistent_stat(arg_70_1, "bonfire_lit_fort") > 0
		local flag_3 = self:get_persistent_stat(arg_70_1, "bonfire_lit_warcamp") > 0
		local flag_4 = self:get_persistent_stat(arg_70_1, "bonfire_lit_skittergate") > 0

		return {
			{
				name = "level_name_mines",
				completed = flag
			},
			{
				name = "level_name_forest_fort",
				completed = flag_2
			},
			{
				name = "level_name_warcamp",
				completed = flag_3
			},
			{
				name = "level_name_skittergate",
				completed = flag_4
			}
		}
	end
}

local tbl_22 = {
	{
		played_difficulty = {
			hardest = true
		}
	}
}

tbl.quests.event_mondstille_played_legend_2018 = {
	name = "quest_mondstille_03_name",
	icon = "quest_book_mondstille",
	desc = "quest_mondstille_03_desc",
	stat_mappings = tbl_22,
	completed = function (self, arg_71_1, arg_71_2)
		-- function 71
		local var_71_0 = QuestSettings.stat_mappings[arg_71_2][1]

		return self:get_persistent_stat(arg_71_1, "quest_statistics", var_71_0) >= QuestSettings.event_mondstille_quickplay_legend_levels
	end,
	progress = function (self, arg_72_1, arg_72_2)
		-- function 72
		local var_72_0 = QuestSettings.stat_mappings[arg_72_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_72_1, "quest_statistics", var_72_0)

		return {
			get_persistent_stat,
			QuestSettings.event_mondstille_quickplay_legend_levels
		}
	end
}
tbl.quests.event_mondstille_quickplay_console = {
	name = "quest_mondstille_01_name",
	icon = "quest_book_mondstille",
	desc = function ()
		-- function 73
		return string.format(Localize("quest_event_summer_2018_quickplay_desc"), QuestSettings.event_sonnstill_quickplay_levels)
	end,
	stat_mappings = tbl_16,
	completed = function (self, arg_74_1, arg_74_2)
		-- function 74
		local var_74_0 = QuestSettings.stat_mappings[arg_74_2][1]

		return self:get_persistent_stat(arg_74_1, "quest_statistics", var_74_0) >= QuestSettings.event_sonnstill_quickplay_levels
	end,
	progress = function (self, arg_75_1, arg_75_2)
		-- function 75
		local var_75_0 = QuestSettings.stat_mappings[arg_75_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_75_1, "quest_statistics", var_75_0)

		return {
			get_persistent_stat,
			QuestSettings.event_sonnstill_quickplay_levels
		}
	end
}
tbl.quests.event_celebration_complete_2020 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = tbl_17,
	completed = function (self, arg_76_1, arg_76_2)
		-- function 76
		local var_76_0 = QuestSettings.stat_mappings[arg_76_2][1]

		return self:get_persistent_stat(arg_76_1, "quest_statistics", var_76_0) > 0
	end
}
tbl.quests.event_celebration_complete_2023 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = tbl_17,
	completed = function (self, arg_77_1, arg_77_2)
		-- function 77
		local var_77_0 = QuestSettings.stat_mappings[arg_77_2][1]

		return self:get_persistent_stat(arg_77_1, "quest_statistics", var_77_0) > 0
	end
}
tbl.quests.event_celebration_complete_2024 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = tbl_17,
	completed = function (self, arg_78_1, arg_78_2)
		-- function 78
		local var_78_0 = QuestSettings.stat_mappings[arg_78_2][1]

		return self:get_persistent_stat(arg_78_1, "quest_statistics", var_78_0) > 0
	end
}
tbl.quests.event_celebration_complete_2025 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = tbl_17,
	completed = function (self, arg_79_1, arg_79_2)
		-- function 79
		local var_79_0 = QuestSettings.stat_mappings[arg_79_2][1]

		return self:get_persistent_stat(arg_79_1, "quest_statistics", var_79_0) > 0
	end
}
tbl.quests.event_celebration_complete_2026 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	stat_mappings = tbl_17,
	completed = function (self, arg_80_1, arg_80_2)
		-- function 80
		local var_80_0 = QuestSettings.stat_mappings[arg_80_2][1]

		return self:get_persistent_stat(arg_80_1, "quest_statistics", var_80_0) > 0
	end
}

local tbl_23 = {
	{
		collected_painting_scraps_unlimited = true
	}
}

tbl.quests.event_celebration_complete_2019 = {
	name = "quest_celebration_01_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_01_desc",
	completed = function (self, arg_81_1, arg_81_2)
		-- function 81
		return self:get_persistent_stat(arg_81_1, "completed_levels", "dlc_celebrate_crawl") > 0
	end
}
tbl.quests.event_celebration_drink_all_ale_2019 = {
	name = "quest_celebration_02_name",
	icon = "quest_book_event_celebration",
	desc = "quest_celebration_02_desc",
	completed = function (self, arg_82_1, arg_82_2)
		-- function 82
		return self:get_persistent_stat(arg_82_1, "crawl_total_ales_drunk") >= QuestSettings.event_crawl_drink_all_ale_amount
	end,
	progress = function (self, arg_83_1, arg_83_2)
		-- function 83
		local get_persistent_stat = self:get_persistent_stat(arg_83_1, "crawl_total_ales_drunk")

		return {
			get_persistent_stat,
			QuestSettings.event_crawl_drink_all_ale_amount
		}
	end
}
tbl.quests.event_celebration_collect_painting_scraps_2019 = {
	name = "painting_manaan01_name",
	icon = "quest_book_event_celebration",
	desc = function ()
		-- function 84
		return string.format(Localize("achv_gecko_scraps_generic_1_desc"), QuestSettings.event_celebration_collect_painting_scraps)
	end,
	stat_mappings = tbl_23,
	completed = function (self, arg_85_1, arg_85_2)
		-- function 85
		local var_85_0 = QuestSettings.stat_mappings[arg_85_2][1]

		return self:get_persistent_stat(arg_85_1, "quest_statistics", var_85_0) >= QuestSettings.event_celebration_collect_painting_scraps
	end,
	progress = function (self, arg_86_1, arg_86_2)
		-- function 86
		local var_86_0 = QuestSettings.stat_mappings[arg_86_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_86_1, "quest_statistics", var_86_0)

		return {
			get_persistent_stat,
			QuestSettings.event_celebration_collect_painting_scraps
		}
	end
}
tbl.quests.event_skulls_quickplay_2019 = {
	name = "quest_event_skulls_quickplay_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function ()
		-- function 87
		return string.format(Localize("quest_event_skulls_quickplay_2019_desc"), QuestSettings.event_skulls_quickplay)
	end,
	stat_mappings = tbl_16,
	completed = function (self, arg_88_1, arg_88_2)
		-- function 88
		local var_88_0 = QuestSettings.stat_mappings[arg_88_2][1]

		return self:get_persistent_stat(arg_88_1, "quest_statistics", var_88_0) >= QuestSettings.event_skulls_quickplay
	end,
	progress = function (self, arg_89_1, arg_89_2)
		-- function 89
		local var_89_0 = QuestSettings.stat_mappings[arg_89_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_89_1, "quest_statistics", var_89_0)

		return {
			get_persistent_stat,
			QuestSettings.event_skulls_quickplay
		}
	end
}
tbl.quests.event_skulls_weekly_event_2019 = {
	name = "quest_event_skulls_weekly_event_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "complete_one_weekly_event",
	stat_mappings = tbl_17,
	completed = function (self, arg_90_1, arg_90_2)
		-- function 90
		local var_90_0 = QuestSettings.stat_mappings[arg_90_2][1]

		return self:get_persistent_stat(arg_90_1, "quest_statistics", var_90_0) > 0
	end
}

local tbl_24 = {
	{
		collected_painting_scraps_unlimited = true
	}
}

tbl.quests.event_skulls_painting_scraps_2019 = {
	name = "quest_event_skulls_painting_scraps_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function ()
		-- function 91
		return string.format(Localize("quest_event_skulls_painting_scraps_2019_desc"), QuestSettings.event_skulls_collect_painting_scraps)
	end,
	stat_mappings = tbl_24,
	completed = function (self, arg_92_1, arg_92_2)
		-- function 92
		local var_92_0 = QuestSettings.stat_mappings[arg_92_2][1]

		return self:get_persistent_stat(arg_92_1, "quest_statistics", var_92_0) >= QuestSettings.event_skulls_collect_painting_scraps
	end,
	progress = function (self, arg_93_1, arg_93_2)
		-- function 93
		local var_93_0 = QuestSettings.stat_mappings[arg_93_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_93_1, "quest_statistics", var_93_0)

		return {
			get_persistent_stat,
			QuestSettings.event_skulls_collect_painting_scraps
		}
	end
}

local tbl_25 = {
	{
		completed_levels = {
			warcamp = true
		}
	}
}

tbl.quests.event_skulls_warcamp_2019 = {
	name = "quest_event_skulls_warcamp_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "quest_event_skulls_warcamp_2019_desc",
	stat_mappings = tbl_25,
	completed = function (self, arg_94_1, arg_94_2)
		-- function 94
		local var_94_0 = QuestSettings.stat_mappings[arg_94_2][1]

		return self:get_persistent_stat(arg_94_1, "quest_statistics", var_94_0) > 0
	end,
	requirements = function (self, arg_95_1, arg_95_2)
		-- function 95
		local var_95_0 = QuestSettings.stat_mappings[arg_95_2][1]
		local flag = self:get_persistent_stat(arg_95_1, "quest_statistics", var_95_0) > 0

		return {
			{
				name = "mission_warcamp_kill_chieftain",
				completed = flag
			}
		}
	end
}
tbl.quests.event_skulls_quickplay_2020 = {
	name = "quest_event_skulls_quickplay_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function ()
		-- function 96
		return string.format(Localize("quest_event_skulls_quickplay_2019_desc"), QuestSettings.event_skulls_quickplay)
	end,
	stat_mappings = tbl_16,
	completed = function (self, arg_97_1, arg_97_2)
		-- function 97
		local var_97_0 = QuestSettings.stat_mappings[arg_97_2][1]

		return self:get_persistent_stat(arg_97_1, "quest_statistics", var_97_0) >= QuestSettings.event_skulls_quickplay
	end,
	progress = function (self, arg_98_1, arg_98_2)
		-- function 98
		local var_98_0 = QuestSettings.stat_mappings[arg_98_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_98_1, "quest_statistics", var_98_0)

		return {
			get_persistent_stat,
			QuestSettings.event_skulls_quickplay
		}
	end
}
tbl.quests.event_skulls_weekly_event_2020 = {
	name = "quest_event_skulls_weekly_event_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "complete_one_weekly_event",
	stat_mappings = tbl_17,
	completed = function (self, arg_99_1, arg_99_2)
		-- function 99
		local var_99_0 = QuestSettings.stat_mappings[arg_99_2][1]

		return self:get_persistent_stat(arg_99_1, "quest_statistics", var_99_0) > 0
	end
}
tbl.quests.event_skulls_painting_scraps_2020 = {
	name = "quest_event_skulls_painting_scraps_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function ()
		-- function 100
		return string.format(Localize("quest_event_skulls_painting_scraps_2019_desc"), QuestSettings.event_skulls_collect_painting_scraps)
	end,
	stat_mappings = tbl_24,
	completed = function (self, arg_101_1, arg_101_2)
		-- function 101
		local var_101_0 = QuestSettings.stat_mappings[arg_101_2][1]

		return self:get_persistent_stat(arg_101_1, "quest_statistics", var_101_0) >= QuestSettings.event_skulls_collect_painting_scraps
	end,
	progress = function (self, arg_102_1, arg_102_2)
		-- function 102
		local var_102_0 = QuestSettings.stat_mappings[arg_102_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_102_1, "quest_statistics", var_102_0)

		return {
			get_persistent_stat,
			QuestSettings.event_skulls_collect_painting_scraps
		}
	end
}
tbl.quests.event_skulls_warcamp_2020 = {
	name = "quest_event_skulls_warcamp_2019_name",
	icon = "quest_book_event_skull",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "quest_event_skulls_warcamp_2019_desc",
	stat_mappings = tbl_25,
	completed = function (self, arg_103_1, arg_103_2)
		-- function 103
		local var_103_0 = QuestSettings.stat_mappings[arg_103_2][1]

		return self:get_persistent_stat(arg_103_1, "quest_statistics", var_103_0) > 0
	end,
	requirements = function (self, arg_104_1, arg_104_2)
		-- function 104
		local var_104_0 = QuestSettings.stat_mappings[arg_104_2][1]
		local flag = self:get_persistent_stat(arg_104_1, "quest_statistics", var_104_0) > 0

		return {
			{
				name = "mission_warcamp_kill_chieftain",
				completed = flag
			}
		}
	end
}
tbl.quests.quest_event_rat_weekly_event_2020 = {
	name = "quest_event_rat_weekly_event_2020_name",
	icon = "quest_book_year_of_the_rat",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "complete_one_weekly_event",
	stat_mappings = tbl_17,
	completed = function (self, arg_105_1, arg_105_2)
		-- function 105
		local var_105_0 = QuestSettings.stat_mappings[arg_105_2][1]

		return self:get_persistent_stat(arg_105_1, "quest_statistics", var_105_0) > 0
	end
}

local tbl_26 = {
	{
		kills_per_race = {
			skaven = true
		}
	}
}

tbl.quests.quest_event_rat_kill_skaven_2020 = {
	name = "quest_event_rat_kill_skaven_2020_name",
	icon = "quest_book_year_of_the_rat",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = function ()
		-- function 106
		return string.format(Localize("quest_event_rat_kill_skaven_2020_desc"), QuestSettings.quest_event_rat_kill_skaven_2020)
	end,
	stat_mappings = tbl_26,
	completed = function (self, arg_107_1, arg_107_2)
		-- function 107
		local var_107_0 = QuestSettings.stat_mappings[arg_107_2][1]

		return self:get_persistent_stat(arg_107_1, "quest_statistics", var_107_0) >= QuestSettings.quest_event_rat_kill_skaven_2020
	end,
	progress = function (self, arg_108_1, arg_108_2)
		-- function 108
		local var_108_0 = QuestSettings.stat_mappings[arg_108_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_108_1, "quest_statistics", var_108_0)

		return {
			get_persistent_stat,
			QuestSettings.quest_event_rat_kill_skaven_2020
		}
	end
}

local tbl_27 = {
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

tbl.quests.quest_event_rat_kill_skaven_lords_2020 = {
	name = "quest_event_rat_kill_skaven_lords_2020_name",
	icon = "quest_book_year_of_the_rat",
	summary_icon = "achievement_symbol_book_event_skull",
	desc = "quest_event_rat_kill_skaven_lords_2020_desc",
	stat_mappings = tbl_27,
	completed = function (self, arg_109_1, arg_109_2)
		-- function 109
		local var_109_0 = QuestSettings.stat_mappings[arg_109_2][1]
		local flag = self:get_persistent_stat(arg_109_1, "quest_statistics", var_109_0) > 0
		local var_109_2 = QuestSettings.stat_mappings[arg_109_2][2]
		local flag_2 = self:get_persistent_stat(arg_109_1, "quest_statistics", var_109_2) > 0

		return not flag and flag_2
	end,
	requirements = function (self, arg_110_1, arg_110_2)
		-- function 110
		local var_110_0 = QuestSettings.stat_mappings[arg_110_2][1]
		local flag = self:get_persistent_stat(arg_110_1, "quest_statistics", var_110_0) > 0
		local var_110_2 = QuestSettings.stat_mappings[arg_110_2][2]
		local flag_2 = self:get_persistent_stat(arg_110_1, "quest_statistics", var_110_2) > 0

		return {
			{
				name = "skaven_storm_vermin_warlord",
				completed = flag_2
			},
			{
				name = "skaven_grey_seer",
				completed = flag
			}
		}
	end
}

local function fn(arg_111_0, arg_111_1)
	-- function 111
	local num = 0

	local function fn()
		-- function 112
		num = num + 1

		return num
	end

	local quests = tbl.quests
	local str = "quest_event_dwarf_fest_trollkiller"
	local var_111_4 = arg_111_1
	local flag

	flag = not arg_111_0 and "_repeatable" and ""

	local str_2 = str .. var_111_4 .. flag
	local tbl_2 = {
		name = "quest_event_dwarf_fest_trollkiller_name",
		icon = "quest_book_event_dwarf_fest"
	}
	local fn_2

	if not arg_111_0 then
		function fn_2()
			-- function 113
			return string.format("%s (%s)", string.format(Localize("quest_event_dwarf_fest_trollkiller_desc"), QuestSettings.quest_event_dwarf_fest_trollkiller), Localize("repeatable"))
		end

		if not fn_2 then
			-- Nothing
		end
	end

	function fn_2()
		-- function 114
		return string.format(Localize("quest_event_dwarf_fest_trollkiller_desc"), QuestSettings.quest_event_dwarf_fest_trollkiller)
	end

	::label_111_0::

	tbl_2.desc = fn_2
	tbl_2.custom_order = fn()
	tbl_2.stat_mappings = {
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
	}

	tbl_2.completed = function (self, arg_115_1, arg_115_2)
		-- function 115
		local var_115_0 = QuestSettings.stat_mappings[arg_115_2][1]

		return self:get_persistent_stat(arg_115_1, "quest_statistics", var_115_0) >= QuestSettings.quest_event_dwarf_fest_trollkiller
	end

	tbl_2.progress = function (self, arg_116_1, arg_116_2)
		-- function 116
		local var_116_0 = QuestSettings.stat_mappings[arg_116_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_116_1, "quest_statistics", var_116_0)

		return {
			get_persistent_stat,
			QuestSettings.quest_event_dwarf_fest_trollkiller
		}
	end

	quests[str_2] = tbl_2

	local tbl_3 = {
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

	if not arg_111_0 then
		fn()
	else
		local tbl_4 = {
			"name_dwarf_fest_troll_001",
			"name_dwarf_fest_troll_002",
			"name_dwarf_fest_troll_003"
		}
		local count = #tbl_3

		tbl.quests["quest_event_dwarf_fest_secret_trolls" .. arg_111_1] = {
			name = "quest_event_dwarf_fest_secret_trolls_name",
			icon = "quest_book_event_dwarf_fest",
			desc = function ()
				-- function 117
				return string.format(Localize("quest_event_dwarf_fest_secret_trolls_desc"), Localize(tbl_4[1]), Localize(tbl_4[2]), Localize(tbl_4[3]), Localize("level_name_dlc_dwarf_fest"))
			end,
			custom_order = fn(),
			stat_mappings = tbl_3,
			completed = function (self, arg_118_1, arg_118_2)
				-- function 118
				for i = 1, count do
					local var_118_0 = QuestSettings.stat_mappings[arg_118_2][i]

					if self:get_persistent_stat(arg_118_1, "quest_statistics", var_118_0) <= 0 then
						return false
					end
				end

				return true
			end,
			progress = function (self, arg_119_1, arg_119_2)
				-- function 119
				local num = 0

				for i = 1, count do
					local var_119_1 = QuestSettings.stat_mappings[arg_119_2][i]

					num = num + math.min(self:get_persistent_stat(arg_119_1, "quest_statistics", var_119_1), 1)
				end

				return {
					num,
					count
				}
			end,
			requirements = function (self, arg_120_1, arg_120_2)
				-- function 120
				local tbl = {}

				for i = 1, count do
					local var_120_1 = QuestSettings.stat_mappings[arg_120_2][i]
					local flag = self:get_persistent_stat(arg_120_1, "quest_statistics", var_120_1) > 0

					table.insert(tbl, {
						name = tbl_4[i],
						completed = flag
					})
				end

				return tbl
			end
		}
	end

	local function fn_3(arg_121_0, arg_121_1)
		-- function 121
		local tbl_2 = {
			{
				kills_per_breed_difficulty = {
					chaos_troll_chief = {}
				},
				kill_assists_per_breed_difficulty = {
					chaos_troll_chief = {}
				}
			}
		}
		local rank = DifficultySettings[arg_121_1].rank

		for k, v in pairs(DifficultySettings) do
			local rank_2 = v.rank

			rank_2 = rank_2 or math.huge

			if rank <= rank_2 then
				tbl_2[1].kills_per_breed_difficulty.chaos_troll_chief[k] = true
				tbl_2[1].kill_assists_per_breed_difficulty.chaos_troll_chief[k] = true
			end
		end

		local quests = tbl.quests
		local str = "quest_event_"
		local var_121_5 = arg_121_0
		local var_121_6 = arg_111_1
		local flag

		flag = not arg_111_0 and "_repeatable" and ""

		local str_2 = str .. var_121_5 .. var_121_6 .. flag
		local tbl_3 = {
			icon = "quest_book_event_dwarf_fest",
			name = "quest_event_" .. arg_121_0 .. "_name"
		}
		local fn_2

		if not arg_111_0 then
			function fn_2()
				-- function 122
				return string.format("%s (%s)", string.format(Localize("quest_event_dwarf_fest_troll_chief_desc"), Localize("chaos_troll_chief"), Localize(DifficultySettings[arg_121_1].display_name)), Localize("repeatable"))
			end

			if not fn_2 then
				-- Nothing
			end
		end

		function fn_2()
			-- function 123
			return string.format(Localize("quest_event_dwarf_fest_troll_chief_desc"), Localize("chaos_troll_chief"), Localize(DifficultySettings[arg_121_1].display_name))
		end

		::label_121_0::

		tbl_3.desc = fn_2
		tbl_3.custom_order = fn()
		tbl_3.stat_mappings = tbl_2

		tbl_3.completed = function (self, arg_124_1, arg_124_2)
			-- function 124
			local var_124_0 = QuestSettings.stat_mappings[arg_124_2][1]

			return self:get_persistent_stat(arg_124_1, "quest_statistics", var_124_0) >= 1
		end

		tbl_3.progress = function (self, arg_125_1, arg_125_2)
			-- function 125
			local var_125_0 = QuestSettings.stat_mappings[arg_125_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_125_1, "quest_statistics", var_125_0)

			return {
				get_persistent_stat,
				1
			}
		end

		quests[str_2] = tbl_3
	end

	for i = 1, #DefaultDifficulties do
		local var_111_13 = DefaultDifficulties[i]
		local var_111_14 = DifficultyMapping[var_111_13]
		local str_3 = "dwarf_fest_troll_chief_" .. var_111_14

		fn_3(str_3, var_111_13)
	end
end

fn(false, "")
fn(true, "")
fn(false, "_2026")
fn(true, "_2026")

local tbl_28 = {
	{
		played_levels_quickplay = {}
	}
}
local tbl_29 = {
	{
		played_levels_weekly_event = {}
	}
}

for i9 = 1, #UnlockableLevels do
	local var_0_39 = UnlockableLevels[i9]
	local played_levels_quickplay = tbl_28[1].played_levels_quickplay
	local played_levels_weekly_event = tbl_29[1].played_levels_weekly_event

	played_levels_quickplay[var_0_39] = true
	played_levels_weekly_event[var_0_39] = true
end

tbl.quests.weekly_complete_quickplay_missions = {
	name = "quest_daily_complete_quickplay_missions_name",
	icon = "quest_book_skull",
	desc = function ()
		-- function 126
		return string.format(Localize("quest_daily_complete_quickplay_missions_desc"), 25)
	end,
	stat_mappings = tbl_28,
	completed = function (self, arg_127_1, arg_127_2)
		-- function 127
		local var_127_0 = QuestSettings.stat_mappings[arg_127_2][1]

		return self:get_persistent_stat(arg_127_1, "quest_statistics", var_127_0) >= 25
	end,
	progress = function (self, arg_128_1, arg_128_2)
		-- function 128
		local var_128_0 = QuestSettings.stat_mappings[arg_128_2][1]
		local get_persistent_stat = self:get_persistent_stat(arg_128_1, "quest_statistics", var_128_0)

		return {
			get_persistent_stat,
			25
		}
	end
}

for i10 = 1, 3 do
	local str = "weekly_complete_quickplay_missions" .. "_" .. i10

	tbl.quests[str] = {
		name = "quest_daily_complete_quickplay_missions_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 129
			return string.format(Localize("quest_daily_complete_quickplay_missions_desc"), QuestSettings.weekly_complete_quickplay_missions[i10])
		end,
		stat_mappings = tbl_28,
		completed = function (self, arg_130_1, arg_130_2)
			-- function 130
			local var_130_0 = QuestSettings.stat_mappings[arg_130_2][1]

			return self:get_persistent_stat(arg_130_1, "quest_statistics", var_130_0) >= QuestSettings.weekly_complete_quickplay_missions[i10]
		end,
		progress = function (self, arg_131_1, arg_131_2)
			-- function 131
			local var_131_0 = QuestSettings.stat_mappings[arg_131_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_131_1, "quest_statistics", var_131_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_complete_quickplay_missions[i10]
			}
		end
	}
end

for i11 = 1, 3 do
	local str_2 = "weekly_complete_weekly_event_missions" .. "_" .. i11

	tbl.quests[str_2] = {
		name = "quest_daily_complete_weekly_quest_missions_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 132
			return string.format(Localize("quest_daily_complete_weekly_event_missions_desc"), QuestSettings.weekly_complete_weekly_event_missions[i11])
		end,
		stat_mappings = tbl_29,
		completed = function (self, arg_133_1, arg_133_2)
			-- function 133
			local var_133_0 = QuestSettings.stat_mappings[arg_133_2][1]

			return self:get_persistent_stat(arg_133_1, "quest_statistics", var_133_0) >= QuestSettings.weekly_complete_weekly_event_missions[i11]
		end,
		progress = function (self, arg_134_1, arg_134_2)
			-- function 134
			local var_134_0 = QuestSettings.stat_mappings[arg_134_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_134_1, "quest_statistics", var_134_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_complete_weekly_event_missions[i11]
			}
		end
	}
end

local tbl_30 = {
	{
		total_collected_tomes = true
	}
}

for i12 = 1, 3 do
	local str_3 = "weekly_collect_tomes" .. "_" .. i12

	tbl.quests[str_3] = {
		name = "quest_daily_collect_tomes_name",
		icon = "quest_book_tome",
		desc = function ()
			-- function 135
			return string.format(Localize("quest_daily_collect_tomes_desc"), QuestSettings.weekly_collect_tomes[i12])
		end,
		stat_mappings = tbl_30,
		completed = function (self, arg_136_1, arg_136_2)
			-- function 136
			local var_136_0 = QuestSettings.stat_mappings[arg_136_2][1]

			return self:get_persistent_stat(arg_136_1, "quest_statistics", var_136_0) >= QuestSettings.weekly_collect_tomes[i12]
		end,
		progress = function (self, arg_137_1, arg_137_2)
			-- function 137
			local var_137_0 = QuestSettings.stat_mappings[arg_137_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_137_1, "quest_statistics", var_137_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_collect_tomes[i12]
			}
		end
	}
end

local tbl_31 = {
	{
		total_collected_grimoires = true
	}
}

for i13 = 1, 3 do
	local str_4 = "weekly_collect_grimoires" .. "_" .. i13

	tbl.quests[str_4] = {
		name = "quest_daily_collect_grimoires_name",
		icon = "quest_book_grimoire",
		desc = function ()
			-- function 138
			return string.format(Localize("quest_daily_collect_grimoires_desc"), QuestSettings.weekly_collect_grimoires[i13])
		end,
		stat_mappings = tbl_31,
		completed = function (self, arg_139_1, arg_139_2)
			-- function 139
			local var_139_0 = QuestSettings.stat_mappings[arg_139_2][1]

			return self:get_persistent_stat(arg_139_1, "quest_statistics", var_139_0) >= QuestSettings.weekly_collect_grimoires[i13]
		end,
		progress = function (self, arg_140_1, arg_140_2)
			-- function 140
			local var_140_0 = QuestSettings.stat_mappings[arg_140_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_140_1, "quest_statistics", var_140_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_collect_grimoires[i13]
			}
		end
	}
end

local tbl_32 = {
	{
		total_collected_dice = true
	}
}

for i14 = 1, 3 do
	local str_5 = "weekly_collect_dice" .. "_" .. i14

	tbl.quests[str_5] = {
		name = "quest_daily_collect_loot_die_name",
		icon = "quest_book_generic_pickup",
		desc = function ()
			-- function 141
			return string.format(Localize("quest_daily_collect_loot_die_desc"), QuestSettings.weekly_collect_dice[i14])
		end,
		stat_mappings = tbl_32,
		completed = function (self, arg_142_1, arg_142_2)
			-- function 142
			local var_142_0 = QuestSettings.stat_mappings[arg_142_2][1]

			return self:get_persistent_stat(arg_142_1, "quest_statistics", var_142_0) >= QuestSettings.weekly_collect_dice[i14]
		end,
		progress = function (self, arg_143_1, arg_143_2)
			-- function 143
			local var_143_0 = QuestSettings.stat_mappings[arg_143_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_143_1, "quest_statistics", var_143_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_collect_dice[i14]
			}
		end
	}
end

local tbl_33 = {
	{
		collected_painting_scraps_unlimited = true
	}
}

for i15 = 1, 3 do
	local str_6 = "weekly_collect_painting_scrap" .. "_" .. i15

	tbl.quests[str_6] = {
		name = "quest_daily_collect_painting_scrap_name",
		icon = "quest_book_generic_pickup",
		desc = function ()
			-- function 144
			return string.format(Localize("quest_daily_collect_painting_scrap_desc"), QuestSettings.weekly_collect_painting_scrap[i15])
		end,
		stat_mappings = tbl_33,
		completed = function (self, arg_145_1, arg_145_2)
			-- function 145
			local var_145_0 = QuestSettings.stat_mappings[arg_145_2][1]

			return self:get_persistent_stat(arg_145_1, "quest_statistics", var_145_0) >= QuestSettings.weekly_collect_painting_scrap[i15]
		end,
		progress = function (self, arg_146_1, arg_146_2)
			-- function 146
			local var_146_0 = QuestSettings.stat_mappings[arg_146_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_146_1, "quest_statistics", var_146_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_collect_painting_scrap[i15]
			}
		end
	}
end

local tbl_34 = {
	{
		kills_critter_total = true
	}
}

for i16 = 1, 3 do
	local str_7 = "weekly_kill_critters_" .. i16

	tbl.quests[str_7] = {
		name = "quest_weekly_kill_critters_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 147
			return string.format(Localize("quest_weekly_kill_critters_desc"), QuestSettings.weekly_kill_critters[i16])
		end,
		stat_mappings = tbl_34,
		completed = function (self, arg_148_1, arg_148_2)
			-- function 148
			local var_148_0 = QuestSettings.stat_mappings[arg_148_2][1]

			return self:get_persistent_stat(arg_148_1, "quest_statistics", var_148_0) >= QuestSettings.weekly_kill_critters[i16]
		end,
		progress = function (self, arg_149_1, arg_149_2)
			-- function 149
			local var_149_0 = QuestSettings.stat_mappings[arg_149_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_149_1, "quest_statistics", var_149_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_kill_critters[i16]
			}
		end
	}
end

local tbl_35 = {
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

for i17 = 1, 3 do
	local str_8 = "weekly_kill_bosses" .. "_" .. i17

	tbl.quests[str_8] = {
		name = "quest_daily_kill_bosses_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 150
			return string.format(Localize("quest_daily_kill_bosses_desc"), QuestSettings.weekly_kill_bosses[i17])
		end,
		stat_mappings = tbl_35,
		completed = function (self, arg_151_1, arg_151_2)
			-- function 151
			local var_151_0 = QuestSettings.stat_mappings[arg_151_2][1]

			return self:get_persistent_stat(arg_151_1, "quest_statistics", var_151_0) >= QuestSettings.weekly_kill_bosses[i17]
		end,
		progress = function (self, arg_152_1, arg_152_2)
			-- function 152
			local var_152_0 = QuestSettings.stat_mappings[arg_152_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_152_1, "quest_statistics", var_152_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_kill_bosses[i17]
			}
		end
	}
end

local tbl_36 = {
	{
		kills_per_breed = {},
		kill_assists_per_breed = {}
	}
}

for k_2, v_2 in pairs(ELITES) do
	local kills_per_breed_2 = tbl_36[1].kills_per_breed
	local kill_assists_per_breed_2 = tbl_36[1].kill_assists_per_breed

	kills_per_breed_2[k_2] = true
	kill_assists_per_breed_2[k_2] = true
end

for i20 = 1, 3 do
	local str_9 = "weekly_kill_elites" .. "_" .. i20

	tbl.quests[str_9] = {
		name = "quest_daily_kill_elites_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 153
			return string.format(Localize("quest_daily_kill_elites_desc"), QuestSettings.weekly_kill_elites[i20])
		end,
		stat_mappings = tbl_36,
		completed = function (self, arg_154_1, arg_154_2)
			-- function 154
			local var_154_0 = QuestSettings.stat_mappings[arg_154_2][1]

			return self:get_persistent_stat(arg_154_1, "quest_statistics", var_154_0) >= QuestSettings.weekly_kill_elites[i20]
		end,
		progress = function (self, arg_155_1, arg_155_2)
			-- function 155
			local var_155_0 = QuestSettings.stat_mappings[arg_155_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_155_1, "quest_statistics", var_155_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_kill_elites[i20]
			}
		end
	}
end

local tbl_37 = {
	{
		completed_levels_wood_elf = {}
	}
}

for i21 = 1, #UnlockableLevels do
	local var_0_61 = UnlockableLevels[i21]

	tbl_37[1].completed_levels_wood_elf[var_0_61] = true
end

for i22 = 1, 3 do
	local str_10 = "weekly_complete_levels_hero_wood_elf" .. "_" .. i22

	tbl.quests[str_10] = {
		name = "quest_daily_complete_levels_hero_wood_elf_name",
		icon = "quest_book_kerillian",
		desc = function ()
			-- function 156
			return string.format(Localize("quest_daily_complete_levels_hero_wood_elf_desc"), QuestSettings.weekly_complete_levels_hero_wood_elf[i22])
		end,
		stat_mappings = tbl_37,
		completed = function (self, arg_157_1, arg_157_2)
			-- function 157
			local var_157_0 = QuestSettings.stat_mappings[arg_157_2][1]

			return self:get_persistent_stat(arg_157_1, "quest_statistics", var_157_0) >= QuestSettings.weekly_complete_levels_hero_wood_elf[i22]
		end,
		progress = function (self, arg_158_1, arg_158_2)
			-- function 158
			local var_158_0 = QuestSettings.stat_mappings[arg_158_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_158_1, "quest_statistics", var_158_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_complete_levels_hero_wood_elf[i22]
			}
		end
	}
end

local tbl_38 = {
	{
		completed_levels_witch_hunter = {}
	}
}

for i23 = 1, #UnlockableLevels do
	local var_0_64 = UnlockableLevels[i23]

	tbl_38[1].completed_levels_witch_hunter[var_0_64] = true
end

for i24 = 1, 3 do
	local str_11 = "weekly_complete_levels_hero_witch_hunter" .. "_" .. i24

	tbl.quests[str_11] = {
		name = "quest_daily_complete_levels_hero_witch_hunter_name",
		icon = "quest_book_saltzpyre",
		desc = function ()
			-- function 159
			return string.format(Localize("quest_daily_complete_levels_hero_witch_hunter_desc"), QuestSettings.weekly_complete_levels_hero_witch_hunter[i24])
		end,
		stat_mappings = tbl_38,
		completed = function (self, arg_160_1, arg_160_2)
			-- function 160
			local var_160_0 = QuestSettings.stat_mappings[arg_160_2][1]

			return self:get_persistent_stat(arg_160_1, "quest_statistics", var_160_0) >= QuestSettings.weekly_complete_levels_hero_witch_hunter[i24]
		end,
		progress = function (self, arg_161_1, arg_161_2)
			-- function 161
			local var_161_0 = QuestSettings.stat_mappings[arg_161_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_161_1, "quest_statistics", var_161_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_complete_levels_hero_witch_hunter[i24]
			}
		end
	}
end

local tbl_39 = {
	{
		completed_levels_dwarf_ranger = {}
	}
}

for i25 = 1, #UnlockableLevels do
	local var_0_67 = UnlockableLevels[i25]

	tbl_39[1].completed_levels_dwarf_ranger[var_0_67] = true
end

for i26 = 1, 3 do
	local str_12 = "weekly_complete_levels_hero_dwarf_ranger" .. "_" .. i26

	tbl.quests[str_12] = {
		name = "quest_daily_complete_levels_hero_dwarf_ranger_name",
		icon = "quest_book_bardin",
		desc = function ()
			-- function 162
			return string.format(Localize("quest_daily_complete_levels_hero_dwarf_ranger_desc"), QuestSettings.weekly_complete_levels_hero_dwarf_ranger[i26])
		end,
		stat_mappings = tbl_39,
		completed = function (self, arg_163_1, arg_163_2)
			-- function 163
			local var_163_0 = QuestSettings.stat_mappings[arg_163_2][1]

			return self:get_persistent_stat(arg_163_1, "quest_statistics", var_163_0) >= QuestSettings.weekly_complete_levels_hero_dwarf_ranger[i26]
		end,
		progress = function (self, arg_164_1, arg_164_2)
			-- function 164
			local var_164_0 = QuestSettings.stat_mappings[arg_164_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_164_1, "quest_statistics", var_164_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_complete_levels_hero_dwarf_ranger[i26]
			}
		end
	}
end

local tbl_40 = {
	{
		completed_levels_bright_wizard = {}
	}
}

for i27 = 1, #UnlockableLevels do
	local var_0_70 = UnlockableLevels[i27]

	tbl_40[1].completed_levels_bright_wizard[var_0_70] = true
end

for i28 = 1, 3 do
	local str_13 = "weekly_complete_levels_hero_bright_wizard" .. "_" .. i28

	tbl.quests[str_13] = {
		name = "quest_daily_complete_levels_hero_bright_wizard_name",
		icon = "quest_book_sienna",
		desc = function ()
			-- function 165
			return string.format(Localize("quest_daily_complete_levels_hero_bright_wizard_desc"), QuestSettings.weekly_complete_levels_hero_bright_wizard[i28])
		end,
		stat_mappings = tbl_40,
		completed = function (self, arg_166_1, arg_166_2)
			-- function 166
			local var_166_0 = QuestSettings.stat_mappings[arg_166_2][1]

			return self:get_persistent_stat(arg_166_1, "quest_statistics", var_166_0) >= QuestSettings.weekly_complete_levels_hero_bright_wizard[i28]
		end,
		progress = function (self, arg_167_1, arg_167_2)
			-- function 167
			local var_167_0 = QuestSettings.stat_mappings[arg_167_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_167_1, "quest_statistics", var_167_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_complete_levels_hero_bright_wizard[i28]
			}
		end
	}
end

local tbl_41 = {
	{
		completed_levels_empire_soldier = {}
	}
}

for i29 = 1, #UnlockableLevels do
	local var_0_73 = UnlockableLevels[i29]

	tbl_41[1].completed_levels_empire_soldier[var_0_73] = true
end

for i30 = 1, 3 do
	local str_14 = "weekly_complete_levels_hero_empire_soldier" .. "_" .. i30

	tbl.quests[str_14] = {
		name = "quest_daily_complete_levels_hero_empire_soldier_name",
		icon = "quest_book_kruber",
		desc = function ()
			-- function 168
			return string.format(Localize("quest_daily_complete_levels_hero_empire_soldier_desc"), QuestSettings.weekly_complete_levels_hero_empire_soldier[i30])
		end,
		stat_mappings = tbl_41,
		completed = function (self, arg_169_1, arg_169_2)
			-- function 169
			local var_169_0 = QuestSettings.stat_mappings[arg_169_2][1]

			return self:get_persistent_stat(arg_169_1, "quest_statistics", var_169_0) >= QuestSettings.weekly_complete_levels_hero_empire_soldier[i30]
		end,
		progress = function (self, arg_170_1, arg_170_2)
			-- function 170
			local var_170_0 = QuestSettings.stat_mappings[arg_170_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_170_1, "quest_statistics", var_170_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_complete_levels_hero_empire_soldier[i30]
			}
		end
	}
end

local tbl_42 = {
	{
		headshots = true
	}
}

for i31 = 1, 3 do
	local str_15 = "weekly_score_headshots" .. "_" .. i31

	tbl.quests[str_15] = {
		name = "quest_daily_score_headshots_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 171
			return string.format(Localize("quest_daily_score_headshots_desc"), QuestSettings.weekly_score_headshots[i31])
		end,
		stat_mappings = tbl_42,
		completed = function (self, arg_172_1, arg_172_2)
			-- function 172
			local var_172_0 = QuestSettings.stat_mappings[arg_172_2][1]

			return self:get_persistent_stat(arg_172_1, "quest_statistics", var_172_0) >= QuestSettings.weekly_score_headshots[i31]
		end,
		progress = function (self, arg_173_1, arg_173_2)
			-- function 173
			local var_173_0 = QuestSettings.stat_mappings[arg_173_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_173_1, "quest_statistics", var_173_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_score_headshots[i31]
			}
		end
	}
end

local tbl_43 = {
	{
		completed_daily_quests = true
	}
}

for i32 = 1, 3 do
	local str_16 = "weekly_daily_quests" .. "_" .. i32

	tbl.quests[str_16] = {
		name = "quest_weekly_daily_quests_name",
		icon = "quest_book_skull",
		desc = function ()
			-- function 174
			return string.format(Localize("quest_weekly_daily_quests_desc"), QuestSettings.weekly_daily_quests[i32])
		end,
		stat_mappings = tbl_43,
		completed = function (self, arg_175_1, arg_175_2)
			-- function 175
			local var_175_0 = QuestSettings.stat_mappings[arg_175_2][1]

			return self:get_persistent_stat(arg_175_1, "quest_statistics", var_175_0) >= QuestSettings.weekly_daily_quests[i32]
		end,
		progress = function (self, arg_176_1, arg_176_2)
			-- function 176
			local var_176_0 = QuestSettings.stat_mappings[arg_176_2][1]
			local get_persistent_stat = self:get_persistent_stat(arg_176_1, "quest_statistics", var_176_0)

			return {
				get_persistent_stat,
				QuestSettings.weekly_daily_quests[i32]
			}
		end
	}
end

DLCUtils.merge("quest_templates", tbl.quests)

return tbl
