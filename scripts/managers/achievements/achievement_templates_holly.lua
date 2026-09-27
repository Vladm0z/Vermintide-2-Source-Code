-- chunkname: @scripts/managers/achievements/achievement_templates_holly.lua

local check_level_list = AchievementTemplateHelper.check_level_list
local check_level_difficulty = AchievementTemplateHelper.check_level_difficulty
local hero_level = AchievementTemplateHelper.hero_level
local equipped_items_of_rarity = AchievementTemplateHelper.equipped_items_of_rarity

AchievementTemplates.achievements.holly_complete_recruit = {
	ID_XB1 = 62,
	name = "achv_holly_complete_all_recruit_name",
	desc = "achv_holly_complete_all_recruit_desc",
	ID_PS4 = "061",
	icon = "achievement_holly_complete_all_recruit_desc",
	required_dlc = "holly",
	completed = function (arg_1_0, arg_1_1)
		-- function 1
		local num = 0
		local rank = DifficultySettings.normal.rank

		if not check_level_difficulty(arg_1_0, arg_1_1, LevelSettings.magnus.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_1_0, arg_1_1, LevelSettings.cemetery.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_1_0, arg_1_1, LevelSettings.forest_ambush.level_id, rank) then
			num = num + 1
		end

		return num >= 3
	end,
	progress = function (arg_2_0, arg_2_1)
		-- function 2
		local num = 0
		local rank = DifficultySettings.normal.rank

		if not check_level_difficulty(arg_2_0, arg_2_1, LevelSettings.magnus.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_2_0, arg_2_1, LevelSettings.cemetery.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_2_0, arg_2_1, LevelSettings.forest_ambush.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			3
		}
	end,
	requirements = function (arg_3_0, arg_3_1)
		-- function 3
		local rank = DifficultySettings.normal.rank
		local var_3_1 = check_level_difficulty(arg_3_0, arg_3_1, LevelSettings.magnus.level_id, rank)
		local var_3_2 = check_level_difficulty(arg_3_0, arg_3_1, LevelSettings.cemetery.level_id, rank)
		local var_3_3 = check_level_difficulty(arg_3_0, arg_3_1, LevelSettings.forest_ambush.level_id, rank)

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
	completed = function (arg_4_0, arg_4_1)
		-- function 4
		local num = 0
		local rank = DifficultySettings.hard.rank

		if not check_level_difficulty(arg_4_0, arg_4_1, LevelSettings.magnus.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_4_0, arg_4_1, LevelSettings.cemetery.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_4_0, arg_4_1, LevelSettings.forest_ambush.level_id, rank) then
			num = num + 1
		end

		return num >= 3
	end,
	progress = function (arg_5_0, arg_5_1)
		-- function 5
		local num = 0
		local rank = DifficultySettings.hard.rank

		if not check_level_difficulty(arg_5_0, arg_5_1, LevelSettings.magnus.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_5_0, arg_5_1, LevelSettings.cemetery.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_5_0, arg_5_1, LevelSettings.forest_ambush.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			3
		}
	end,
	requirements = function (arg_6_0, arg_6_1)
		-- function 6
		local rank = DifficultySettings.hard.rank
		local var_6_1 = check_level_difficulty(arg_6_0, arg_6_1, LevelSettings.magnus.level_id, rank)
		local var_6_2 = check_level_difficulty(arg_6_0, arg_6_1, LevelSettings.cemetery.level_id, rank)
		local var_6_3 = check_level_difficulty(arg_6_0, arg_6_1, LevelSettings.forest_ambush.level_id, rank)

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
	completed = function (arg_7_0, arg_7_1)
		-- function 7
		local num = 0
		local rank = DifficultySettings.harder.rank

		if not check_level_difficulty(arg_7_0, arg_7_1, LevelSettings.magnus.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_7_0, arg_7_1, LevelSettings.cemetery.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_7_0, arg_7_1, LevelSettings.forest_ambush.level_id, rank) then
			num = num + 1
		end

		return num >= 3
	end,
	progress = function (arg_8_0, arg_8_1)
		-- function 8
		local num = 0
		local rank = DifficultySettings.harder.rank

		if not check_level_difficulty(arg_8_0, arg_8_1, LevelSettings.magnus.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_8_0, arg_8_1, LevelSettings.cemetery.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_8_0, arg_8_1, LevelSettings.forest_ambush.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			3
		}
	end,
	requirements = function (arg_9_0, arg_9_1)
		-- function 9
		local rank = DifficultySettings.harder.rank
		local var_9_1 = check_level_difficulty(arg_9_0, arg_9_1, LevelSettings.magnus.level_id, rank)
		local var_9_2 = check_level_difficulty(arg_9_0, arg_9_1, LevelSettings.cemetery.level_id, rank)
		local var_9_3 = check_level_difficulty(arg_9_0, arg_9_1, LevelSettings.forest_ambush.level_id, rank)

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
	completed = function (arg_10_0, arg_10_1)
		-- function 10
		local num = 0
		local rank = DifficultySettings.hardest.rank

		if not check_level_difficulty(arg_10_0, arg_10_1, LevelSettings.magnus.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_10_0, arg_10_1, LevelSettings.cemetery.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_10_0, arg_10_1, LevelSettings.forest_ambush.level_id, rank) then
			num = num + 1
		end

		return num >= 3
	end,
	progress = function (arg_11_0, arg_11_1)
		-- function 11
		local num = 0
		local rank = DifficultySettings.hardest.rank

		if not check_level_difficulty(arg_11_0, arg_11_1, LevelSettings.magnus.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_11_0, arg_11_1, LevelSettings.cemetery.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_11_0, arg_11_1, LevelSettings.forest_ambush.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			3
		}
	end,
	requirements = function (arg_12_0, arg_12_1)
		-- function 12
		local rank = DifficultySettings.hardest.rank
		local var_12_1 = check_level_difficulty(arg_12_0, arg_12_1, LevelSettings.magnus.level_id, rank)
		local var_12_2 = check_level_difficulty(arg_12_0, arg_12_1, LevelSettings.cemetery.level_id, rank)
		local var_12_3 = check_level_difficulty(arg_12_0, arg_12_1, LevelSettings.forest_ambush.level_id, rank)

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
	completed = function (arg_13_0, arg_13_1)
		-- function 13
		local num = 0
		local rank = DifficultySettings.normal.rank

		if not check_level_difficulty(arg_13_0, arg_13_1, LevelSettings.plaza.level_id, rank) then
			num = num + 1
		end

		return num >= 1
	end
}
AchievementTemplates.achievements.holly_complete_plaza_veteran = {
	required_dlc = "holly",
	name = "achv_holly_plaza_veteran_name",
	icon = "achievement_holly_plaza_veteran_desc",
	desc = "achv_holly_plaza_veteran_desc",
	completed = function (arg_14_0, arg_14_1)
		-- function 14
		local num = 0
		local rank = DifficultySettings.hard.rank

		if not check_level_difficulty(arg_14_0, arg_14_1, LevelSettings.plaza.level_id, rank) then
			num = num + 1
		end

		return num >= 1
	end
}
AchievementTemplates.achievements.holly_complete_plaza_champion = {
	required_dlc = "holly",
	name = "achv_holly_plaza_champion_name",
	icon = "achievement_holly_plaza_champion_desc",
	desc = "achv_holly_plaza_champion_desc",
	completed = function (arg_15_0, arg_15_1)
		-- function 15
		local num = 0
		local rank = DifficultySettings.harder.rank

		if not check_level_difficulty(arg_15_0, arg_15_1, LevelSettings.plaza.level_id, rank) then
			num = num + 1
		end

		return num >= 1
	end
}
AchievementTemplates.achievements.holly_complete_plaza_legend = {
	required_dlc = "holly",
	name = "achv_holly_plaza_legend_name",
	icon = "achievement_holly_plaza_legend_desc",
	desc = "achv_holly_plaza_legend_desc",
	completed = function (arg_16_0, arg_16_1)
		-- function 16
		local num = 0
		local rank = DifficultySettings.hardest.rank

		if not check_level_difficulty(arg_16_0, arg_16_1, LevelSettings.plaza.level_id, rank) then
			num = num + 1
		end

		return num >= 1
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
	completed = function (self, arg_17_1)
		-- function 17
		if self:get_persistent_stat(arg_17_1, "holly_find_all_runes") == 0 then
			local flag = self:get_persistent_stat(arg_17_1, "holly_cemetery_rune") > 0
			local flag_2 = self:get_persistent_stat(arg_17_1, "holly_forest_ambush_rune") > 0
			local flag_3 = self:get_persistent_stat(arg_17_1, "holly_magnus_rune") > 0

			if not (not flag and not flag_2 and flag_3) then
				self:increment_stat(arg_17_1, "holly_find_all_runes")

				return true
			end

			return false
		end

		return self:get_persistent_stat(arg_17_1, "holly_find_all_runes") > 0
	end,
	progress = function (self, arg_18_1)
		-- function 18
		local num = 0

		if self:get_persistent_stat(arg_18_1, "holly_cemetery_rune") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_18_1, "holly_forest_ambush_rune") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_18_1, "holly_magnus_rune") > 0 then
			num = num + 1
		end

		return {
			num,
			3
		}
	end,
	requirements = function (self, arg_19_1)
		-- function 19
		local flag = self:get_persistent_stat(arg_19_1, "holly_cemetery_rune") > 0
		local flag_2 = self:get_persistent_stat(arg_19_1, "holly_forest_ambush_rune") > 0
		local flag_3 = self:get_persistent_stat(arg_19_1, "holly_magnus_rune") > 0

		return {
			{
				name = "holly_cemetery_rune",
				completed = flag
			},
			{
				name = "holly_forest_ambush_rune",
				completed = flag_2
			},
			{
				name = "holly_magnus_rune",
				completed = flag_3
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
	completed = function (self, arg_20_1)
		-- function 20
		return self:get_persistent_stat(arg_20_1, "holly_magnus_barrel_relay_race") > 0
	end
}
AchievementTemplates.achievements.holly_magnus_barrel_relay_race_hardest = {
	required_dlc = "holly",
	name = "achv_holly_magnus_barrel_relay_race_hardest_name",
	display_completion_ui = true,
	icon = "achievement_holly_magnus_barrel_relay_race_hardest_desc",
	desc = "achv_holly_magnus_barrel_relay_race_hardest_desc",
	completed = function (self, arg_21_1)
		-- function 21
		return self:get_persistent_stat(arg_21_1, "holly_magnus_barrel_relay_race_hardest") > 0
	end
}
AchievementTemplates.achievements.holly_magnus_secret_room = {
	required_dlc = "holly",
	name = "achv_holly_magnus_secret_room_name",
	display_completion_ui = true,
	icon = "achievement_holly_magnus_secret_room_desc",
	desc = "achv_holly_magnus_secret_room_desc",
	completed = function (self, arg_22_1)
		-- function 22
		return self:get_persistent_stat(arg_22_1, "holly_magnus_secret_room") > 0
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
	completed = function (self, arg_23_1)
		-- function 23
		return self:get_persistent_stat(arg_23_1, "holly_magnus_gutter_runner_treasure") > 0
	end
}
AchievementTemplates.achievements.holly_magnus_gutter_runner_treasure_hardest = {
	required_dlc = "holly",
	name = "achv_holly_magnus_gutter_runner_treasure_hardest_name",
	display_completion_ui = true,
	icon = "achievement_holly_magnus_gutter_runner_treasure_hardest_desc",
	desc = "achv_holly_magnus_gutter_runner_treasure_hardest_desc",
	completed = function (self, arg_24_1)
		-- function 24
		return self:get_persistent_stat(arg_24_1, "holly_magnus_gutter_runner_treasure_hardest") > 0
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
	completed = function (self, arg_25_1)
		-- function 25
		return self:get_persistent_stat(arg_25_1, "holly_forest_ambush_synchronized_explosives") > 0
	end
}
AchievementTemplates.achievements.holly_forest_ambush_synchronized_explosives_hardest = {
	required_dlc = "holly",
	name = "achv_holly_forest_ambush_synchronized_explosives_hardest_name",
	display_completion_ui = true,
	icon = "achievement_holly_forest_ambush_synchronized_explosives_hardest_desc",
	desc = "achv_holly_forest_ambush_synchronized_explosives_hardest_desc",
	completed = function (self, arg_26_1)
		-- function 26
		return self:get_persistent_stat(arg_26_1, "holly_forest_ambush_synchronized_explosives_hardest") > 0
	end
}
AchievementTemplates.achievements.holly_forest_ambush_bretonnian_dance = {
	required_dlc = "holly",
	name = "achv_holly_forest_ambush_bretonnian_dance_name",
	display_completion_ui = true,
	icon = "achievement_holly_forest_ambush_bretonnian_dance_desc",
	desc = "achv_holly_forest_ambush_bretonnian_dance_desc",
	completed = function (self, arg_27_1)
		-- function 27
		return self:get_persistent_stat(arg_27_1, "holly_forest_ambush_bretonnian_dance") > 0
	end
}
AchievementTemplates.achievements.holly_forest_ambush_dragonbane_gem = {
	required_dlc = "holly",
	name = "achv_holly_forest_ambush_dragonbane_gem_name",
	display_completion_ui = true,
	icon = "achievement_holly_forest_ambush_dragonbane_gem_desc",
	desc = "achv_holly_forest_ambush_dragonbane_gem_desc",
	completed = function (self, arg_28_1)
		-- function 28
		return self:get_persistent_stat(arg_28_1, "holly_forest_ambush_dragonbane_gem") > 0
	end
}
AchievementTemplates.achievements.holly_cemetery_sleep = {
	required_dlc = "holly",
	name = "achv_holly_cemetery_sleep_name",
	display_completion_ui = true,
	icon = "achievement_holly_cemetery_sleep_desc",
	desc = "achv_holly_cemetery_sleep_desc",
	completed = function (self, arg_29_1)
		-- function 29
		return self:get_persistent_stat(arg_29_1, "holly_cemetery_sleep") > 0
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
	completed = function (self, arg_30_1)
		-- function 30
		return self:get_persistent_stat(arg_30_1, "holly_cemetery_synchronized_chains") > 0
	end
}
AchievementTemplates.achievements.holly_cemetery_synchronized_chains_hardest = {
	required_dlc = "holly",
	name = "achv_holly_cemetery_synchronized_chains_hardest_name",
	display_completion_ui = true,
	icon = "achievement_holly_cemetery_synchronized_chains_hardest_desc",
	desc = "achv_holly_cemetery_synchronized_chains_hardest_desc",
	completed = function (self, arg_31_1)
		-- function 31
		return self:get_persistent_stat(arg_31_1, "holly_cemetery_synchronized_chains_hardest") > 0
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
	completed = function (self, arg_32_1)
		-- function 32
		return self:get_persistent_stat(arg_32_1, "holly_cemetery_bones") > 0
	end
}
AchievementTemplates.achievements.holly_cemetery_rune = {
	name = "achv_holly_cemetery_rune_name",
	required_dlc = "holly",
	desc = "achv_holly_cemetery_rune_desc",
	completed = function (self, arg_33_1)
		-- function 33
		return self:get_persistent_stat(arg_33_1, "holly_cemetery_rune") > 0
	end
}
AchievementTemplates.achievements.holly_forest_ambush_rune = {
	name = "achv_holly_forest_ambush_rune_name",
	required_dlc = "holly",
	desc = "achv_holly_forest_ambush_rune_desc",
	completed = function (self, arg_34_1)
		-- function 34
		return self:get_persistent_stat(arg_34_1, "holly_forest_ambush_rune") > 0
	end
}
AchievementTemplates.achievements.holly_magnus_rune = {
	name = "achv_holly_magnus_rune_name",
	required_dlc = "holly",
	desc = "achv_holly_magnus_rune_desc",
	completed = function (self, arg_35_1)
		-- function 35
		return self:get_persistent_stat(arg_35_1, "holly_magnus_rune") > 0
	end
}
