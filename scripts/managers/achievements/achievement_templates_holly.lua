-- chunkname: @scripts/managers/achievements/achievement_templates_holly.lua

local var_0_0 = AchievementTemplateHelper.check_level_list
local var_0_1 = AchievementTemplateHelper.check_level_difficulty
local var_0_2 = AchievementTemplateHelper.hero_level
local var_0_3 = AchievementTemplateHelper.equipped_items_of_rarity

AchievementTemplates.achievements.holly_complete_recruit = {
	ID_XB1 = 62,
	name = "achv_holly_complete_all_recruit_name",
	desc = "achv_holly_complete_all_recruit_desc",
	ID_PS4 = "061",
	icon = "achievement_holly_complete_all_recruit_desc",
	required_dlc = "holly",
	completed = function(arg_1_0, arg_1_1)
		local var_1_0 = 0
		local var_1_1 = DifficultySettings.normal.rank

		if var_0_1(arg_1_0, arg_1_1, LevelSettings.magnus.level_id, var_1_1) then
			var_1_0 = var_1_0 + 1
		end

		if var_0_1(arg_1_0, arg_1_1, LevelSettings.cemetery.level_id, var_1_1) then
			var_1_0 = var_1_0 + 1
		end

		if var_0_1(arg_1_0, arg_1_1, LevelSettings.forest_ambush.level_id, var_1_1) then
			var_1_0 = var_1_0 + 1
		end

		return var_1_0 >= 3
	end,
	progress = function(arg_2_0, arg_2_1)
		local var_2_0 = 0
		local var_2_1 = DifficultySettings.normal.rank

		if var_0_1(arg_2_0, arg_2_1, LevelSettings.magnus.level_id, var_2_1) then
			var_2_0 = var_2_0 + 1
		end

		if var_0_1(arg_2_0, arg_2_1, LevelSettings.cemetery.level_id, var_2_1) then
			var_2_0 = var_2_0 + 1
		end

		if var_0_1(arg_2_0, arg_2_1, LevelSettings.forest_ambush.level_id, var_2_1) then
			var_2_0 = var_2_0 + 1
		end

		return {
			var_2_0,
			3
		}
	end,
	requirements = function(arg_3_0, arg_3_1)
		local var_3_0 = DifficultySettings.normal.rank
		local var_3_1 = var_0_1(arg_3_0, arg_3_1, LevelSettings.magnus.level_id, var_3_0)
		local var_3_2 = var_0_1(arg_3_0, arg_3_1, LevelSettings.cemetery.level_id, var_3_0)
		local var_3_3 = var_0_1(arg_3_0, arg_3_1, LevelSettings.forest_ambush.level_id, var_3_0)

		return {
			{
				name = "level_name_magnus",
				completed = var_3_1
			},
			{
				name = "level_name_cemetery",
				completed = var_3_2
			},
			{
				name = "level_name_forest_ambush",
				completed = var_3_3
			}
		}
	end
}
AchievementTemplates.achievements.holly_complete_veteran = {
	ID_XB1 = 63,
	name = "achv_holly_complete_all_veteran_name",
	desc = "achv_holly_complete_all_veteran_desc",
	ID_PS4 = "062",
	icon = "achievement_holly_complete_all_veteran_desc",
	required_dlc = "holly",
	completed = function(arg_4_0, arg_4_1)
		local var_4_0 = 0
		local var_4_1 = DifficultySettings.hard.rank

		if var_0_1(arg_4_0, arg_4_1, LevelSettings.magnus.level_id, var_4_1) then
			var_4_0 = var_4_0 + 1
		end

		if var_0_1(arg_4_0, arg_4_1, LevelSettings.cemetery.level_id, var_4_1) then
			var_4_0 = var_4_0 + 1
		end

		if var_0_1(arg_4_0, arg_4_1, LevelSettings.forest_ambush.level_id, var_4_1) then
			var_4_0 = var_4_0 + 1
		end

		return var_4_0 >= 3
	end,
	progress = function(arg_5_0, arg_5_1)
		local var_5_0 = 0
		local var_5_1 = DifficultySettings.hard.rank

		if var_0_1(arg_5_0, arg_5_1, LevelSettings.magnus.level_id, var_5_1) then
			var_5_0 = var_5_0 + 1
		end

		if var_0_1(arg_5_0, arg_5_1, LevelSettings.cemetery.level_id, var_5_1) then
			var_5_0 = var_5_0 + 1
		end

		if var_0_1(arg_5_0, arg_5_1, LevelSettings.forest_ambush.level_id, var_5_1) then
			var_5_0 = var_5_0 + 1
		end

		return {
			var_5_0,
			3
		}
	end,
	requirements = function(arg_6_0, arg_6_1)
		local var_6_0 = DifficultySettings.hard.rank
		local var_6_1 = var_0_1(arg_6_0, arg_6_1, LevelSettings.magnus.level_id, var_6_0)
		local var_6_2 = var_0_1(arg_6_0, arg_6_1, LevelSettings.cemetery.level_id, var_6_0)
		local var_6_3 = var_0_1(arg_6_0, arg_6_1, LevelSettings.forest_ambush.level_id, var_6_0)

		return {
			{
				name = "level_name_magnus",
				completed = var_6_1
			},
			{
				name = "level_name_cemetery",
				completed = var_6_2
			},
			{
				name = "level_name_forest_ambush",
				completed = var_6_3
			}
		}
	end
}
AchievementTemplates.achievements.holly_complete_champion = {
	ID_XB1 = 64,
	name = "achv_holly_complete_all_champion_name",
	desc = "achv_holly_complete_all_champion_desc",
	ID_PS4 = "063",
	icon = "achievement_holly_complete_all_champion_desc",
	required_dlc = "holly",
	completed = function(arg_7_0, arg_7_1)
		local var_7_0 = 0
		local var_7_1 = DifficultySettings.harder.rank

		if var_0_1(arg_7_0, arg_7_1, LevelSettings.magnus.level_id, var_7_1) then
			var_7_0 = var_7_0 + 1
		end

		if var_0_1(arg_7_0, arg_7_1, LevelSettings.cemetery.level_id, var_7_1) then
			var_7_0 = var_7_0 + 1
		end

		if var_0_1(arg_7_0, arg_7_1, LevelSettings.forest_ambush.level_id, var_7_1) then
			var_7_0 = var_7_0 + 1
		end

		return var_7_0 >= 3
	end,
	progress = function(arg_8_0, arg_8_1)
		local var_8_0 = 0
		local var_8_1 = DifficultySettings.harder.rank

		if var_0_1(arg_8_0, arg_8_1, LevelSettings.magnus.level_id, var_8_1) then
			var_8_0 = var_8_0 + 1
		end

		if var_0_1(arg_8_0, arg_8_1, LevelSettings.cemetery.level_id, var_8_1) then
			var_8_0 = var_8_0 + 1
		end

		if var_0_1(arg_8_0, arg_8_1, LevelSettings.forest_ambush.level_id, var_8_1) then
			var_8_0 = var_8_0 + 1
		end

		return {
			var_8_0,
			3
		}
	end,
	requirements = function(arg_9_0, arg_9_1)
		local var_9_0 = DifficultySettings.harder.rank
		local var_9_1 = var_0_1(arg_9_0, arg_9_1, LevelSettings.magnus.level_id, var_9_0)
		local var_9_2 = var_0_1(arg_9_0, arg_9_1, LevelSettings.cemetery.level_id, var_9_0)
		local var_9_3 = var_0_1(arg_9_0, arg_9_1, LevelSettings.forest_ambush.level_id, var_9_0)

		return {
			{
				name = "level_name_magnus",
				completed = var_9_1
			},
			{
				name = "level_name_cemetery",
				completed = var_9_2
			},
			{
				name = "level_name_forest_ambush",
				completed = var_9_3
			}
		}
	end
}
AchievementTemplates.achievements.holly_complete_legend = {
	ID_XB1 = 65,
	name = "achv_holly_complete_all_legend_name",
	desc = "achv_holly_complete_all_legend_desc",
	ID_PS4 = "064",
	icon = "achievement_holly_complete_all_legend_desc",
	required_dlc = "holly",
	completed = function(arg_10_0, arg_10_1)
		local var_10_0 = 0
		local var_10_1 = DifficultySettings.hardest.rank

		if var_0_1(arg_10_0, arg_10_1, LevelSettings.magnus.level_id, var_10_1) then
			var_10_0 = var_10_0 + 1
		end

		if var_0_1(arg_10_0, arg_10_1, LevelSettings.cemetery.level_id, var_10_1) then
			var_10_0 = var_10_0 + 1
		end

		if var_0_1(arg_10_0, arg_10_1, LevelSettings.forest_ambush.level_id, var_10_1) then
			var_10_0 = var_10_0 + 1
		end

		return var_10_0 >= 3
	end,
	progress = function(arg_11_0, arg_11_1)
		local var_11_0 = 0
		local var_11_1 = DifficultySettings.hardest.rank

		if var_0_1(arg_11_0, arg_11_1, LevelSettings.magnus.level_id, var_11_1) then
			var_11_0 = var_11_0 + 1
		end

		if var_0_1(arg_11_0, arg_11_1, LevelSettings.cemetery.level_id, var_11_1) then
			var_11_0 = var_11_0 + 1
		end

		if var_0_1(arg_11_0, arg_11_1, LevelSettings.forest_ambush.level_id, var_11_1) then
			var_11_0 = var_11_0 + 1
		end

		return {
			var_11_0,
			3
		}
	end,
	requirements = function(arg_12_0, arg_12_1)
		local var_12_0 = DifficultySettings.hardest.rank
		local var_12_1 = var_0_1(arg_12_0, arg_12_1, LevelSettings.magnus.level_id, var_12_0)
		local var_12_2 = var_0_1(arg_12_0, arg_12_1, LevelSettings.cemetery.level_id, var_12_0)
		local var_12_3 = var_0_1(arg_12_0, arg_12_1, LevelSettings.forest_ambush.level_id, var_12_0)

		return {
			{
				name = "level_name_magnus",
				completed = var_12_1
			},
			{
				name = "level_name_cemetery",
				completed = var_12_2
			},
			{
				name = "level_name_forest_ambush",
				completed = var_12_3
			}
		}
	end
}
AchievementTemplates.achievements.holly_complete_plaza_recruit = {
	required_dlc = "holly",
	name = "achv_holly_plaza_recruit_name",
	icon = "achievement_holly_plaza_recruit_desc",
	desc = "achv_holly_plaza_recruit_desc",
	completed = function(arg_13_0, arg_13_1)
		local var_13_0 = 0
		local var_13_1 = DifficultySettings.normal.rank

		if var_0_1(arg_13_0, arg_13_1, LevelSettings.plaza.level_id, var_13_1) then
			var_13_0 = var_13_0 + 1
		end

		return var_13_0 >= 1
	end
}
AchievementTemplates.achievements.holly_complete_plaza_veteran = {
	required_dlc = "holly",
	name = "achv_holly_plaza_veteran_name",
	icon = "achievement_holly_plaza_veteran_desc",
	desc = "achv_holly_plaza_veteran_desc",
	completed = function(arg_14_0, arg_14_1)
		local var_14_0 = 0
		local var_14_1 = DifficultySettings.hard.rank

		if var_0_1(arg_14_0, arg_14_1, LevelSettings.plaza.level_id, var_14_1) then
			var_14_0 = var_14_0 + 1
		end

		return var_14_0 >= 1
	end
}
AchievementTemplates.achievements.holly_complete_plaza_champion = {
	required_dlc = "holly",
	name = "achv_holly_plaza_champion_name",
	icon = "achievement_holly_plaza_champion_desc",
	desc = "achv_holly_plaza_champion_desc",
	completed = function(arg_15_0, arg_15_1)
		local var_15_0 = 0
		local var_15_1 = DifficultySettings.harder.rank

		if var_0_1(arg_15_0, arg_15_1, LevelSettings.plaza.level_id, var_15_1) then
			var_15_0 = var_15_0 + 1
		end

		return var_15_0 >= 1
	end
}
AchievementTemplates.achievements.holly_complete_plaza_legend = {
	required_dlc = "holly",
	name = "achv_holly_plaza_legend_name",
	icon = "achievement_holly_plaza_legend_desc",
	desc = "achv_holly_plaza_legend_desc",
	completed = function(arg_16_0, arg_16_1)
		local var_16_0 = 0
		local var_16_1 = DifficultySettings.hardest.rank

		if var_0_1(arg_16_0, arg_16_1, LevelSettings.plaza.level_id, var_16_1) then
			var_16_0 = var_16_0 + 1
		end

		return var_16_0 >= 1
	end
}
AchievementTemplates.achievements.holly_find_all_runes = {
	ID_XB1 = 66,
	name = "achv_holly_find_all_runes_name",
	ID_PS4 = "065",
	desc = "achv_holly_find_all_runes_desc",
	display_completion_ui = true,
	icon = "achievement_holly_find_all_runes_desc",
	required_dlc = "holly",
	completed = function(arg_17_0, arg_17_1)
		if arg_17_0:get_persistent_stat(arg_17_1, "holly_find_all_runes") == 0 then
			local var_17_0 = arg_17_0:get_persistent_stat(arg_17_1, "holly_cemetery_rune") > 0
			local var_17_1 = arg_17_0:get_persistent_stat(arg_17_1, "holly_forest_ambush_rune") > 0
			local var_17_2 = arg_17_0:get_persistent_stat(arg_17_1, "holly_magnus_rune") > 0

			if var_17_0 and var_17_1 and var_17_2 then
				arg_17_0:increment_stat(arg_17_1, "holly_find_all_runes")

				return true
			end

			return false
		end

		return arg_17_0:get_persistent_stat(arg_17_1, "holly_find_all_runes") > 0
	end,
	progress = function(arg_18_0, arg_18_1)
		local var_18_0 = 0

		if arg_18_0:get_persistent_stat(arg_18_1, "holly_cemetery_rune") > 0 then
			var_18_0 = var_18_0 + 1
		end

		if arg_18_0:get_persistent_stat(arg_18_1, "holly_forest_ambush_rune") > 0 then
			var_18_0 = var_18_0 + 1
		end

		if arg_18_0:get_persistent_stat(arg_18_1, "holly_magnus_rune") > 0 then
			var_18_0 = var_18_0 + 1
		end

		return {
			var_18_0,
			3
		}
	end,
	requirements = function(arg_19_0, arg_19_1)
		local var_19_0 = arg_19_0:get_persistent_stat(arg_19_1, "holly_cemetery_rune") > 0
		local var_19_1 = arg_19_0:get_persistent_stat(arg_19_1, "holly_forest_ambush_rune") > 0
		local var_19_2 = arg_19_0:get_persistent_stat(arg_19_1, "holly_magnus_rune") > 0

		return {
			{
				name = "holly_cemetery_rune",
				completed = var_19_0
			},
			{
				name = "holly_forest_ambush_rune",
				completed = var_19_1
			},
			{
				name = "holly_magnus_rune",
				completed = var_19_2
			}
		}
	end
}
AchievementTemplates.achievements.holly_magnus_barrel_relay_race = {
	ID_XB1 = 67,
	name = "achv_holly_magnus_barrel_relay_race_name",
	ID_PS4 = "066",
	required_dlc = "holly",
	icon = "achievement_holly_magnus_barrel_relay_race_desc",
	display_completion_ui = true,
	desc = "achv_holly_magnus_barrel_relay_race_desc",
	completed = function(arg_20_0, arg_20_1)
		return arg_20_0:get_persistent_stat(arg_20_1, "holly_magnus_barrel_relay_race") > 0
	end
}
AchievementTemplates.achievements.holly_magnus_barrel_relay_race_hardest = {
	required_dlc = "holly",
	name = "achv_holly_magnus_barrel_relay_race_hardest_name",
	display_completion_ui = true,
	icon = "achievement_holly_magnus_barrel_relay_race_hardest_desc",
	desc = "achv_holly_magnus_barrel_relay_race_hardest_desc",
	completed = function(arg_21_0, arg_21_1)
		return arg_21_0:get_persistent_stat(arg_21_1, "holly_magnus_barrel_relay_race_hardest") > 0
	end
}
AchievementTemplates.achievements.holly_magnus_secret_room = {
	required_dlc = "holly",
	name = "achv_holly_magnus_secret_room_name",
	display_completion_ui = true,
	icon = "achievement_holly_magnus_secret_room_desc",
	desc = "achv_holly_magnus_secret_room_desc",
	completed = function(arg_22_0, arg_22_1)
		return arg_22_0:get_persistent_stat(arg_22_1, "holly_magnus_secret_room") > 0
	end
}
AchievementTemplates.achievements.holly_magnus_gutter_runner_treasure = {
	ID_XB1 = 71,
	name = "achv_holly_magnus_gutter_runner_treasure_name",
	ID_PS4 = "070",
	required_dlc = "holly",
	icon = "achievement_holly_magnus_gutter_runner_treasure_desc",
	display_completion_ui = true,
	desc = "achv_holly_magnus_gutter_runner_treasure_desc",
	completed = function(arg_23_0, arg_23_1)
		return arg_23_0:get_persistent_stat(arg_23_1, "holly_magnus_gutter_runner_treasure") > 0
	end
}
AchievementTemplates.achievements.holly_magnus_gutter_runner_treasure_hardest = {
	required_dlc = "holly",
	name = "achv_holly_magnus_gutter_runner_treasure_hardest_name",
	display_completion_ui = true,
	icon = "achievement_holly_magnus_gutter_runner_treasure_hardest_desc",
	desc = "achv_holly_magnus_gutter_runner_treasure_hardest_desc",
	completed = function(arg_24_0, arg_24_1)
		return arg_24_0:get_persistent_stat(arg_24_1, "holly_magnus_gutter_runner_treasure_hardest") > 0
	end
}
AchievementTemplates.achievements.holly_forest_ambush_synchronized_explosives = {
	ID_XB1 = 69,
	name = "achv_holly_forest_ambush_synchronized_explosives_name",
	ID_PS4 = "068",
	required_dlc = "holly",
	icon = "achievement_holly_forest_ambush_synchronized_explosives_desc",
	display_completion_ui = true,
	desc = "achv_holly_forest_ambush_synchronized_explosives_desc",
	completed = function(arg_25_0, arg_25_1)
		return arg_25_0:get_persistent_stat(arg_25_1, "holly_forest_ambush_synchronized_explosives") > 0
	end
}
AchievementTemplates.achievements.holly_forest_ambush_synchronized_explosives_hardest = {
	required_dlc = "holly",
	name = "achv_holly_forest_ambush_synchronized_explosives_hardest_name",
	display_completion_ui = true,
	icon = "achievement_holly_forest_ambush_synchronized_explosives_hardest_desc",
	desc = "achv_holly_forest_ambush_synchronized_explosives_hardest_desc",
	completed = function(arg_26_0, arg_26_1)
		return arg_26_0:get_persistent_stat(arg_26_1, "holly_forest_ambush_synchronized_explosives_hardest") > 0
	end
}
AchievementTemplates.achievements.holly_forest_ambush_bretonnian_dance = {
	required_dlc = "holly",
	name = "achv_holly_forest_ambush_bretonnian_dance_name",
	display_completion_ui = true,
	icon = "achievement_holly_forest_ambush_bretonnian_dance_desc",
	desc = "achv_holly_forest_ambush_bretonnian_dance_desc",
	completed = function(arg_27_0, arg_27_1)
		return arg_27_0:get_persistent_stat(arg_27_1, "holly_forest_ambush_bretonnian_dance") > 0
	end
}
AchievementTemplates.achievements.holly_forest_ambush_dragonbane_gem = {
	required_dlc = "holly",
	name = "achv_holly_forest_ambush_dragonbane_gem_name",
	display_completion_ui = true,
	icon = "achievement_holly_forest_ambush_dragonbane_gem_desc",
	desc = "achv_holly_forest_ambush_dragonbane_gem_desc",
	completed = function(arg_28_0, arg_28_1)
		return arg_28_0:get_persistent_stat(arg_28_1, "holly_forest_ambush_dragonbane_gem") > 0
	end
}
AchievementTemplates.achievements.holly_cemetery_sleep = {
	required_dlc = "holly",
	name = "achv_holly_cemetery_sleep_name",
	display_completion_ui = true,
	icon = "achievement_holly_cemetery_sleep_desc",
	desc = "achv_holly_cemetery_sleep_desc",
	completed = function(arg_29_0, arg_29_1)
		return arg_29_0:get_persistent_stat(arg_29_1, "holly_cemetery_sleep") > 0
	end
}
AchievementTemplates.achievements.holly_cemetery_synchronized_chains = {
	ID_XB1 = 68,
	name = "achv_holly_cemetery_synchronized_chains_name",
	ID_PS4 = "067",
	required_dlc = "holly",
	icon = "achievement_holly_cemetery_synchronized_chains_desc",
	display_completion_ui = true,
	desc = "achv_holly_cemetery_synchronized_chains_desc",
	completed = function(arg_30_0, arg_30_1)
		return arg_30_0:get_persistent_stat(arg_30_1, "holly_cemetery_synchronized_chains") > 0
	end
}
AchievementTemplates.achievements.holly_cemetery_synchronized_chains_hardest = {
	required_dlc = "holly",
	name = "achv_holly_cemetery_synchronized_chains_hardest_name",
	display_completion_ui = true,
	icon = "achievement_holly_cemetery_synchronized_chains_hardest_desc",
	desc = "achv_holly_cemetery_synchronized_chains_hardest_desc",
	completed = function(arg_31_0, arg_31_1)
		return arg_31_0:get_persistent_stat(arg_31_1, "holly_cemetery_synchronized_chains_hardest") > 0
	end
}
AchievementTemplates.achievements.holly_cemetery_bones = {
	ID_XB1 = 70,
	name = "achv_holly_cemetery_bones",
	ID_PS4 = "069",
	required_dlc = "holly",
	icon = "achievement_holly_cemetery_bones_desc",
	display_completion_ui = true,
	desc = "achv_holly_cemetery_bones_desc",
	completed = function(arg_32_0, arg_32_1)
		return arg_32_0:get_persistent_stat(arg_32_1, "holly_cemetery_bones") > 0
	end
}
AchievementTemplates.achievements.holly_cemetery_rune = {
	name = "achv_holly_cemetery_rune_name",
	required_dlc = "holly",
	desc = "achv_holly_cemetery_rune_desc",
	completed = function(arg_33_0, arg_33_1)
		return arg_33_0:get_persistent_stat(arg_33_1, "holly_cemetery_rune") > 0
	end
}
AchievementTemplates.achievements.holly_forest_ambush_rune = {
	name = "achv_holly_forest_ambush_rune_name",
	required_dlc = "holly",
	desc = "achv_holly_forest_ambush_rune_desc",
	completed = function(arg_34_0, arg_34_1)
		return arg_34_0:get_persistent_stat(arg_34_1, "holly_forest_ambush_rune") > 0
	end
}
AchievementTemplates.achievements.holly_magnus_rune = {
	name = "achv_holly_magnus_rune_name",
	required_dlc = "holly",
	desc = "achv_holly_magnus_rune_desc",
	completed = function(arg_35_0, arg_35_1)
		return arg_35_0:get_persistent_stat(arg_35_1, "holly_magnus_rune") > 0
	end
}
