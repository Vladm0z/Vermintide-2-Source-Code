-- chunkname: @scripts/managers/achievements/achievement_templates.lua

require("scripts/settings/progression_unlocks")

AchievementTemplates = {}

local var_0_0 = rawget(_G, "ExperienceSettings")
local var_0_1 = rawget(_G, "LevelSettings")
local var_0_2 = rawget(_G, "LevelUnlockUtils")
local var_0_3 = rawget(_G, "ProgressionUnlocks")
local var_0_4 = rawget(_G, "UnlockableLevels")
local var_0_5 = rawget(_G, "DifficultySettings")

require("scripts/settings/quest_settings")
require("scripts/managers/achievements/achievement_template_helper")

local check_level = AchievementTemplateHelper.check_level
local check_level_difficulty = AchievementTemplateHelper.check_level_difficulty
local check_level_list = AchievementTemplateHelper.check_level_list
local check_level_list_difficulty = AchievementTemplateHelper.check_level_list_difficulty
local hero_level = AchievementTemplateHelper.hero_level
local equipped_items_of_rarity = AchievementTemplateHelper.equipped_items_of_rarity
local rarity_index = AchievementTemplateHelper.rarity_index
local num = 84

AchievementTemplates.end_of_level_achievement_evaluations = {
	no_ratling_damage = {
		stat_to_increment = "bogenhafen_slum_no_ratling_damage",
		levels = {
			"dlc_bogenhafen_slum"
		},
		evaluation_func = function (self, arg_1_1)
			-- function 1
			return self:get_stat(arg_1_1, "damage_taken_from_ratling_gunner") == 0
		end,
		allowed_difficulties = {
			hardest = true
		}
	}
}
AchievementTemplates.achievements = {}
AchievementTemplates.achievements.complete_tutorial = {
	ID_XB1 = 2,
	name = "achv_complete_tutorial_name",
	ID_PS4 = "001",
	ID_STEAM = "complete_tutorial",
	icon = "achievement_trophy_01",
	desc = "achv_complete_tutorial_desc",
	completed = function (arg_2_0, arg_2_1)
		-- function 2
		return check_level_list(arg_2_0, arg_2_1, {
			var_0_1.prologue.level_id
		})
	end
}
AchievementTemplates.achievements.complete_act_one = {
	ID_XB1 = 3,
	name = "achv_complete_act_one_name",
	desc = "achv_complete_act_one_desc",
	ID_STEAM = "complete_act_one",
	ID_PS4 = "002",
	icon = "achievement_trophy_02",
	completed = function (arg_3_0, arg_3_1)
		-- function 3
		return var_0_2.act_completed(arg_3_0, arg_3_1, "act_1")
	end,
	progress = function (arg_4_0, arg_4_1)
		-- function 4
		local num = 0

		if not check_level(arg_4_0, arg_4_1, var_0_1.military.level_id) then
			num = num + 1
		end

		if not check_level(arg_4_0, arg_4_1, var_0_1.catacombs.level_id) then
			num = num + 1
		end

		if not check_level(arg_4_0, arg_4_1, var_0_1.mines.level_id) then
			num = num + 1
		end

		if not check_level(arg_4_0, arg_4_1, var_0_1.ground_zero.level_id) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_5_0, arg_5_1)
		-- function 5
		local var_5_0 = check_level(arg_5_0, arg_5_1, var_0_1.military.level_id)
		local var_5_1 = check_level(arg_5_0, arg_5_1, var_0_1.catacombs.level_id)
		local var_5_2 = check_level(arg_5_0, arg_5_1, var_0_1.mines.level_id)
		local var_5_3 = check_level(arg_5_0, arg_5_1, var_0_1.ground_zero.level_id)

		return {
			{
				name = "level_name_military",
				completed = var_5_0
			},
			{
				name = "level_name_catacombs",
				completed = var_5_1
			},
			{
				name = "level_name_mines",
				completed = var_5_2
			},
			{
				name = "level_name_ground_zero",
				completed = var_5_3
			}
		}
	end
}
AchievementTemplates.achievements.complete_act_one_veteran = {
	name = "achv_complete_act_one_veteran_name",
	icon = "icons_placeholder",
	desc = "achv_complete_act_one_veteran_desc",
	completed = function (arg_6_0, arg_6_1)
		-- function 6
		local num = 0
		local rank = var_0_5.hard.rank

		if not check_level_difficulty(arg_6_0, arg_6_1, var_0_1.military.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_6_0, arg_6_1, var_0_1.catacombs.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_6_0, arg_6_1, var_0_1.mines.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_6_0, arg_6_1, var_0_1.ground_zero.level_id, rank) then
			num = num + 1
		end

		return num >= 4
	end,
	progress = function (arg_7_0, arg_7_1)
		-- function 7
		local num = 0
		local rank = var_0_5.hard.rank

		if not check_level_difficulty(arg_7_0, arg_7_1, var_0_1.military.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_7_0, arg_7_1, var_0_1.catacombs.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_7_0, arg_7_1, var_0_1.mines.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_7_0, arg_7_1, var_0_1.ground_zero.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_8_0, arg_8_1)
		-- function 8
		local rank = var_0_5.hard.rank
		local var_8_1 = check_level_difficulty(arg_8_0, arg_8_1, var_0_1.military.level_id, rank)
		local var_8_2 = check_level_difficulty(arg_8_0, arg_8_1, var_0_1.catacombs.level_id, rank)
		local var_8_3 = check_level_difficulty(arg_8_0, arg_8_1, var_0_1.mines.level_id, rank)
		local var_8_4 = check_level_difficulty(arg_8_0, arg_8_1, var_0_1.ground_zero.level_id, rank)

		return {
			{
				name = "level_name_military",
				completed = var_8_1
			},
			{
				name = "level_name_catacombs",
				completed = var_8_2
			},
			{
				name = "level_name_mines",
				completed = var_8_3
			},
			{
				name = "level_name_ground_zero",
				completed = var_8_4
			}
		}
	end
}
AchievementTemplates.achievements.complete_bogenhafen_slum_recruit = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_slum_recruit_name",
	icon = "achievement_trophy_bogenhafen_slum_recruit",
	desc = "achv_bogenhafen_slum_recruit_desc",
	completed = function (arg_9_0, arg_9_1)
		-- function 9
		local num = 0
		local rank = var_0_5.normal.rank

		if not check_level_difficulty(arg_9_0, arg_9_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		return num >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_slum_veteran = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_slum_veteran_name",
	icon = "achievement_trophy_bogenhafen_slum_veteran",
	desc = "achv_bogenhafen_slum_veteran_desc",
	completed = function (arg_10_0, arg_10_1)
		-- function 10
		local num = 0
		local rank = var_0_5.hard.rank

		if not check_level_difficulty(arg_10_0, arg_10_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		return num >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_slum_champion = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_slum_champion_name",
	icon = "achievement_trophy_bogenhafen_slum_champion",
	desc = "achv_bogenhafen_slum_champion_desc",
	completed = function (arg_11_0, arg_11_1)
		-- function 11
		local num = 0
		local rank = var_0_5.harder.rank

		if not check_level_difficulty(arg_11_0, arg_11_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		return num >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_slum_legend = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_slum_legend_name",
	icon = "achievement_trophy_bogenhafen_slum_legend",
	desc = "achv_bogenhafen_slum_legend_desc",
	completed = function (arg_12_0, arg_12_1)
		-- function 12
		local num = 0
		local rank = var_0_5.hardest.rank

		if not check_level_difficulty(arg_12_0, arg_12_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		return num >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_city_recruit = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_city_recruit_name",
	icon = "achievement_trophy_bogenhafen_city_recruit",
	desc = "achv_bogenhafen_city_recruit_desc",
	completed = function (arg_13_0, arg_13_1)
		-- function 13
		local num = 0
		local rank = var_0_5.normal.rank

		if not check_level_difficulty(arg_13_0, arg_13_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return num >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_city_veteran = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_city_veteran_name",
	icon = "achievement_trophy_bogenhafen_city_veteran",
	desc = "achv_bogenhafen_city_veteran_desc",
	completed = function (arg_14_0, arg_14_1)
		-- function 14
		local num = 0
		local rank = var_0_5.hard.rank

		if not check_level_difficulty(arg_14_0, arg_14_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return num >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_city_champion = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_city_champion_name",
	icon = "achievement_trophy_bogenhafen_city_champion",
	desc = "achv_bogenhafen_city_champion_desc",
	completed = function (arg_15_0, arg_15_1)
		-- function 15
		local num = 0
		local rank = var_0_5.harder.rank

		if not check_level_difficulty(arg_15_0, arg_15_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return num >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_city_legend = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_city_legend_name",
	icon = "achievement_trophy_bogenhafen_city_legend",
	desc = "achv_bogenhafen_city_legend_desc",
	completed = function (arg_16_0, arg_16_1)
		-- function 16
		local num = 0
		local rank = var_0_5.hardest.rank

		if not check_level_difficulty(arg_16_0, arg_16_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return num >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_recruit = {
	ID_XB1 = 52,
	name = "achv_bogenhafen_complete_recruit_name",
	desc = "achv_bogenhafen_complete_recruit_desc",
	ID_PS4 = "051",
	icon = "achievement_trophy_bogenhafen_complete_recruit",
	required_dlc = "bogenhafen",
	completed = function (arg_17_0, arg_17_1)
		-- function 17
		local num = 0
		local rank = var_0_5.normal.rank

		if not check_level_difficulty(arg_17_0, arg_17_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_17_0, arg_17_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return num >= 2
	end,
	progress = function (arg_18_0, arg_18_1)
		-- function 18
		local num = 0
		local rank = var_0_5.normal.rank

		if not check_level_difficulty(arg_18_0, arg_18_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_18_0, arg_18_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			2
		}
	end,
	requirements = function (arg_19_0, arg_19_1)
		-- function 19
		local rank = var_0_5.normal.rank
		local var_19_1 = check_level_difficulty(arg_19_0, arg_19_1, var_0_1.dlc_bogenhafen_slum.level_id, rank)
		local var_19_2 = check_level_difficulty(arg_19_0, arg_19_1, var_0_1.dlc_bogenhafen_city.level_id, rank)

		return {
			{
				name = "level_name_bogenhafen_slum",
				completed = var_19_1
			},
			{
				name = "level_name_bogenhafen_city",
				completed = var_19_2
			}
		}
	end
}
AchievementTemplates.achievements.complete_bogenhafen_veteran = {
	ID_XB1 = 53,
	name = "achv_bogenhafen_complete_veteran_name",
	desc = "achv_bogenhafen_complete_veteran_desc",
	ID_PS4 = "052",
	icon = "achievement_trophy_bogenhafen_complete_veteran",
	required_dlc = "bogenhafen",
	completed = function (arg_20_0, arg_20_1)
		-- function 20
		local num = 0
		local rank = var_0_5.hard.rank

		if not check_level_difficulty(arg_20_0, arg_20_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_20_0, arg_20_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return num >= 2
	end,
	progress = function (arg_21_0, arg_21_1)
		-- function 21
		local num = 0
		local rank = var_0_5.hard.rank

		if not check_level_difficulty(arg_21_0, arg_21_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_21_0, arg_21_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			2
		}
	end,
	requirements = function (arg_22_0, arg_22_1)
		-- function 22
		local rank = var_0_5.hard.rank
		local var_22_1 = check_level_difficulty(arg_22_0, arg_22_1, var_0_1.dlc_bogenhafen_slum.level_id, rank)
		local var_22_2 = check_level_difficulty(arg_22_0, arg_22_1, var_0_1.dlc_bogenhafen_city.level_id, rank)

		return {
			{
				name = "level_name_bogenhafen_slum",
				completed = var_22_1
			},
			{
				name = "level_name_bogenhafen_city",
				completed = var_22_2
			}
		}
	end
}
AchievementTemplates.achievements.complete_bogenhafen_champion = {
	ID_XB1 = 54,
	name = "achv_bogenhafen_complete_champion_name",
	desc = "achv_bogenhafen_complete_champion_desc",
	ID_PS4 = "053",
	icon = "achievement_trophy_bogenhafen_complete_champion",
	required_dlc = "bogenhafen",
	completed = function (arg_23_0, arg_23_1)
		-- function 23
		local num = 0
		local rank = var_0_5.harder.rank

		if not check_level_difficulty(arg_23_0, arg_23_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_23_0, arg_23_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return num >= 2
	end,
	progress = function (arg_24_0, arg_24_1)
		-- function 24
		local num = 0
		local rank = var_0_5.harder.rank

		if not check_level_difficulty(arg_24_0, arg_24_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_24_0, arg_24_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			2
		}
	end,
	requirements = function (arg_25_0, arg_25_1)
		-- function 25
		local rank = var_0_5.harder.rank
		local var_25_1 = check_level_difficulty(arg_25_0, arg_25_1, var_0_1.dlc_bogenhafen_slum.level_id, rank)
		local var_25_2 = check_level_difficulty(arg_25_0, arg_25_1, var_0_1.dlc_bogenhafen_city.level_id, rank)

		return {
			{
				name = "level_name_bogenhafen_slum",
				completed = var_25_1
			},
			{
				name = "level_name_bogenhafen_city",
				completed = var_25_2
			}
		}
	end
}
AchievementTemplates.achievements.complete_bogenhafen_legend = {
	ID_XB1 = 55,
	name = "achv_bogenhafen_complete_legend_name",
	desc = "achv_bogenhafen_complete_legend_desc",
	ID_PS4 = "054",
	icon = "achievement_trophy_bogenhafen_complete_legend",
	required_dlc = "bogenhafen",
	completed = function (arg_26_0, arg_26_1)
		-- function 26
		local num = 0
		local rank = var_0_5.hardest.rank

		if not check_level_difficulty(arg_26_0, arg_26_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_26_0, arg_26_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return num >= 2
	end,
	progress = function (arg_27_0, arg_27_1)
		-- function 27
		local num = 0
		local rank = var_0_5.hardest.rank

		if not check_level_difficulty(arg_27_0, arg_27_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_27_0, arg_27_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			2
		}
	end,
	requirements = function (arg_28_0, arg_28_1)
		-- function 28
		local rank = var_0_5.hardest.rank
		local var_28_1 = check_level_difficulty(arg_28_0, arg_28_1, var_0_1.dlc_bogenhafen_slum.level_id, rank)
		local var_28_2 = check_level_difficulty(arg_28_0, arg_28_1, var_0_1.dlc_bogenhafen_city.level_id, rank)

		return {
			{
				name = "level_name_bogenhafen_slum",
				completed = var_28_1
			},
			{
				name = "level_name_bogenhafen_city",
				completed = var_28_2
			}
		}
	end
}
AchievementTemplates.achievements.complete_act_one_champion = {
	name = "achv_complete_act_one_champion_name",
	icon = "icons_placeholder",
	desc = "achv_complete_act_one_champion_desc",
	completed = function (arg_29_0, arg_29_1)
		-- function 29
		local num = 0
		local rank = var_0_5.harder.rank

		if not check_level_difficulty(arg_29_0, arg_29_1, var_0_1.military.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_29_0, arg_29_1, var_0_1.catacombs.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_29_0, arg_29_1, var_0_1.mines.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_29_0, arg_29_1, var_0_1.ground_zero.level_id, rank) then
			num = num + 1
		end

		return num >= 4
	end,
	progress = function (arg_30_0, arg_30_1)
		-- function 30
		local num = 0
		local rank = var_0_5.harder.rank

		if not check_level_difficulty(arg_30_0, arg_30_1, var_0_1.military.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_30_0, arg_30_1, var_0_1.catacombs.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_30_0, arg_30_1, var_0_1.mines.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_30_0, arg_30_1, var_0_1.ground_zero.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_31_0, arg_31_1)
		-- function 31
		local rank = var_0_5.harder.rank
		local var_31_1 = check_level_difficulty(arg_31_0, arg_31_1, var_0_1.military.level_id, rank)
		local var_31_2 = check_level_difficulty(arg_31_0, arg_31_1, var_0_1.catacombs.level_id, rank)
		local var_31_3 = check_level_difficulty(arg_31_0, arg_31_1, var_0_1.mines.level_id, rank)
		local var_31_4 = check_level_difficulty(arg_31_0, arg_31_1, var_0_1.ground_zero.level_id, rank)

		return {
			{
				name = "level_name_military",
				completed = var_31_1
			},
			{
				name = "level_name_catacombs",
				completed = var_31_2
			},
			{
				name = "level_name_mines",
				completed = var_31_3
			},
			{
				name = "level_name_ground_zero",
				completed = var_31_4
			}
		}
	end
}
AchievementTemplates.achievements.complete_act_one_legend = {
	name = "achv_complete_act_one_legend_name",
	icon = "icons_placeholder",
	desc = "achv_complete_act_one_legend_desc",
	completed = function (arg_32_0, arg_32_1)
		-- function 32
		local num = 0
		local rank = var_0_5.hardest.rank

		if not check_level_difficulty(arg_32_0, arg_32_1, var_0_1.military.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_32_0, arg_32_1, var_0_1.catacombs.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_32_0, arg_32_1, var_0_1.mines.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_32_0, arg_32_1, var_0_1.ground_zero.level_id, rank) then
			num = num + 1
		end

		return num >= 4
	end,
	progress = function (arg_33_0, arg_33_1)
		-- function 33
		local num = 0
		local rank = var_0_5.hardest.rank

		if not check_level_difficulty(arg_33_0, arg_33_1, var_0_1.military.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_33_0, arg_33_1, var_0_1.catacombs.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_33_0, arg_33_1, var_0_1.mines.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_33_0, arg_33_1, var_0_1.ground_zero.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_34_0, arg_34_1)
		-- function 34
		local rank = var_0_5.hardest.rank
		local var_34_1 = check_level_difficulty(arg_34_0, arg_34_1, var_0_1.military.level_id, rank)
		local var_34_2 = check_level_difficulty(arg_34_0, arg_34_1, var_0_1.catacombs.level_id, rank)
		local var_34_3 = check_level_difficulty(arg_34_0, arg_34_1, var_0_1.mines.level_id, rank)
		local var_34_4 = check_level_difficulty(arg_34_0, arg_34_1, var_0_1.ground_zero.level_id, rank)

		return {
			{
				name = "level_name_military",
				completed = var_34_1
			},
			{
				name = "level_name_catacombs",
				completed = var_34_2
			},
			{
				name = "level_name_mines",
				completed = var_34_3
			},
			{
				name = "level_name_ground_zero",
				completed = var_34_4
			}
		}
	end
}
AchievementTemplates.achievements.complete_act_two = {
	ID_XB1 = 4,
	name = "achv_complete_act_two_name",
	desc = "achv_complete_act_two_desc",
	ID_STEAM = "complete_act_two",
	ID_PS4 = "003",
	icon = "achievement_trophy_03",
	completed = function (arg_35_0, arg_35_1)
		-- function 35
		return var_0_2.act_completed(arg_35_0, arg_35_1, "act_2")
	end,
	progress = function (arg_36_0, arg_36_1)
		-- function 36
		local num = 0

		if not check_level_list(arg_36_0, arg_36_1, {
			var_0_1.elven_ruins.level_id
		}) then
			num = num + 1
		end

		if not check_level_list(arg_36_0, arg_36_1, {
			var_0_1.bell.level_id
		}) then
			num = num + 1
		end

		if not check_level_list(arg_36_0, arg_36_1, {
			var_0_1.fort.level_id
		}) then
			num = num + 1
		end

		if not check_level_list(arg_36_0, arg_36_1, {
			var_0_1.skaven_stronghold.level_id
		}) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_37_0, arg_37_1)
		-- function 37
		local var_37_0 = check_level_list(arg_37_0, arg_37_1, {
			var_0_1.elven_ruins.level_id
		})
		local var_37_1 = check_level_list(arg_37_0, arg_37_1, {
			var_0_1.bell.level_id
		})
		local var_37_2 = check_level_list(arg_37_0, arg_37_1, {
			var_0_1.fort.level_id
		})
		local var_37_3 = check_level_list(arg_37_0, arg_37_1, {
			var_0_1.skaven_stronghold.level_id
		})

		return {
			{
				name = "level_name_elven_ruins",
				completed = var_37_0
			},
			{
				name = "level_name_bell",
				completed = var_37_1
			},
			{
				name = "level_name_forest_fort",
				completed = var_37_2
			},
			{
				name = "level_name_skaven_stronghold",
				completed = var_37_3
			}
		}
	end
}
AchievementTemplates.achievements.complete_act_two_veteran = {
	name = "achv_complete_act_two_veteran_name",
	icon = "icons_placeholder",
	desc = "achv_complete_act_two_veteran_desc",
	completed = function (arg_38_0, arg_38_1)
		-- function 38
		local num = 0
		local rank = var_0_5.hard.rank

		if not check_level_difficulty(arg_38_0, arg_38_1, var_0_1.elven_ruins.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_38_0, arg_38_1, var_0_1.bell.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_38_0, arg_38_1, var_0_1.fort.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_38_0, arg_38_1, var_0_1.skaven_stronghold.level_id, rank) then
			num = num + 1
		end

		return num >= 4
	end,
	progress = function (arg_39_0, arg_39_1)
		-- function 39
		local num = 0
		local rank = var_0_5.hard.rank

		if not check_level_difficulty(arg_39_0, arg_39_1, var_0_1.elven_ruins.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_39_0, arg_39_1, var_0_1.bell.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_39_0, arg_39_1, var_0_1.fort.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_39_0, arg_39_1, var_0_1.skaven_stronghold.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_40_0, arg_40_1)
		-- function 40
		local rank = var_0_5.hard.rank
		local var_40_1 = check_level_difficulty(arg_40_0, arg_40_1, var_0_1.elven_ruins.level_id, rank)
		local var_40_2 = check_level_difficulty(arg_40_0, arg_40_1, var_0_1.bell.level_id, rank)
		local var_40_3 = check_level_difficulty(arg_40_0, arg_40_1, var_0_1.fort.level_id, rank)
		local var_40_4 = check_level_difficulty(arg_40_0, arg_40_1, var_0_1.skaven_stronghold.level_id, rank)

		return {
			{
				name = "level_name_elven_ruins",
				completed = var_40_1
			},
			{
				name = "level_name_bell",
				completed = var_40_2
			},
			{
				name = "level_name_forest_fort",
				completed = var_40_3
			},
			{
				name = "level_name_skaven_stronghold",
				completed = var_40_4
			}
		}
	end
}
AchievementTemplates.achievements.complete_act_two_champion = {
	name = "achv_complete_act_two_champion_name",
	icon = "icons_placeholder",
	desc = "achv_complete_act_two_champion_desc",
	completed = function (arg_41_0, arg_41_1)
		-- function 41
		local num = 0
		local rank = var_0_5.harder.rank

		if not check_level_difficulty(arg_41_0, arg_41_1, var_0_1.elven_ruins.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_41_0, arg_41_1, var_0_1.bell.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_41_0, arg_41_1, var_0_1.fort.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_41_0, arg_41_1, var_0_1.skaven_stronghold.level_id, rank) then
			num = num + 1
		end

		return num >= 4
	end,
	progress = function (arg_42_0, arg_42_1)
		-- function 42
		local num = 0
		local rank = var_0_5.harder.rank

		if not check_level_difficulty(arg_42_0, arg_42_1, var_0_1.elven_ruins.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_42_0, arg_42_1, var_0_1.bell.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_42_0, arg_42_1, var_0_1.fort.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_42_0, arg_42_1, var_0_1.skaven_stronghold.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_43_0, arg_43_1)
		-- function 43
		local rank = var_0_5.harder.rank
		local var_43_1 = check_level_difficulty(arg_43_0, arg_43_1, var_0_1.elven_ruins.level_id, rank)
		local var_43_2 = check_level_difficulty(arg_43_0, arg_43_1, var_0_1.bell.level_id, rank)
		local var_43_3 = check_level_difficulty(arg_43_0, arg_43_1, var_0_1.fort.level_id, rank)
		local var_43_4 = check_level_difficulty(arg_43_0, arg_43_1, var_0_1.skaven_stronghold.level_id, rank)

		return {
			{
				name = "level_name_elven_ruins",
				completed = var_43_1
			},
			{
				name = "level_name_bell",
				completed = var_43_2
			},
			{
				name = "level_name_forest_fort",
				completed = var_43_3
			},
			{
				name = "level_name_skaven_stronghold",
				completed = var_43_4
			}
		}
	end
}
AchievementTemplates.achievements.complete_act_two_legend = {
	name = "achv_complete_act_two_legend_name",
	icon = "icons_placeholder",
	desc = "achv_complete_act_two_legend_desc",
	completed = function (arg_44_0, arg_44_1)
		-- function 44
		local num = 0
		local rank = var_0_5.hardest.rank

		if not check_level_difficulty(arg_44_0, arg_44_1, var_0_1.elven_ruins.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_44_0, arg_44_1, var_0_1.bell.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_44_0, arg_44_1, var_0_1.fort.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_44_0, arg_44_1, var_0_1.skaven_stronghold.level_id, rank) then
			num = num + 1
		end

		return num >= 4
	end,
	progress = function (arg_45_0, arg_45_1)
		-- function 45
		local num = 0
		local rank = var_0_5.hardest.rank

		if not check_level_difficulty(arg_45_0, arg_45_1, var_0_1.elven_ruins.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_45_0, arg_45_1, var_0_1.bell.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_45_0, arg_45_1, var_0_1.fort.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_45_0, arg_45_1, var_0_1.skaven_stronghold.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_46_0, arg_46_1)
		-- function 46
		local rank = var_0_5.hardest.rank
		local var_46_1 = check_level_difficulty(arg_46_0, arg_46_1, var_0_1.elven_ruins.level_id, rank)
		local var_46_2 = check_level_difficulty(arg_46_0, arg_46_1, var_0_1.bell.level_id, rank)
		local var_46_3 = check_level_difficulty(arg_46_0, arg_46_1, var_0_1.fort.level_id, rank)
		local var_46_4 = check_level_difficulty(arg_46_0, arg_46_1, var_0_1.skaven_stronghold.level_id, rank)

		return {
			{
				name = "level_name_elven_ruins",
				completed = var_46_1
			},
			{
				name = "level_name_bell",
				completed = var_46_2
			},
			{
				name = "level_name_forest_fort",
				completed = var_46_3
			},
			{
				name = "level_name_skaven_stronghold",
				completed = var_46_4
			}
		}
	end
}
AchievementTemplates.achievements.complete_act_three = {
	ID_XB1 = 5,
	name = "achv_complete_act_three_name",
	desc = "achv_complete_act_three_desc",
	ID_STEAM = "complete_act_three",
	ID_PS4 = "004",
	icon = "achievement_trophy_04",
	completed = function (arg_47_0, arg_47_1)
		-- function 47
		return var_0_2.act_completed(arg_47_0, arg_47_1, "act_3")
	end,
	progress = function (arg_48_0, arg_48_1)
		-- function 48
		local num = 0

		if not check_level_list(arg_48_0, arg_48_1, {
			var_0_1.farmlands.level_id
		}) then
			num = num + 1
		end

		if not check_level_list(arg_48_0, arg_48_1, {
			var_0_1.ussingen.level_id
		}) then
			num = num + 1
		end

		if not check_level_list(arg_48_0, arg_48_1, {
			var_0_1.nurgle.level_id
		}) then
			num = num + 1
		end

		if not check_level_list(arg_48_0, arg_48_1, {
			var_0_1.warcamp.level_id
		}) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_49_0, arg_49_1)
		-- function 49
		local var_49_0 = check_level_list(arg_49_0, arg_49_1, {
			var_0_1.farmlands.level_id
		})
		local var_49_1 = check_level_list(arg_49_0, arg_49_1, {
			var_0_1.ussingen.level_id
		})
		local var_49_2 = check_level_list(arg_49_0, arg_49_1, {
			var_0_1.nurgle.level_id
		})
		local var_49_3 = check_level_list(arg_49_0, arg_49_1, {
			var_0_1.warcamp.level_id
		})

		return {
			{
				name = "level_name_farmlands",
				completed = var_49_0
			},
			{
				name = "level_name_ussingen",
				completed = var_49_1
			},
			{
				name = "level_name_nurgle",
				completed = var_49_2
			},
			{
				name = "level_name_warcamp",
				completed = var_49_3
			}
		}
	end
}
AchievementTemplates.achievements.complete_act_three_veteran = {
	name = "achv_complete_act_three_veteran_name",
	icon = "icons_placeholder",
	desc = "achv_complete_act_three_veteran_desc",
	completed = function (arg_50_0, arg_50_1)
		-- function 50
		local num = 0
		local rank = var_0_5.hard.rank

		if not check_level_difficulty(arg_50_0, arg_50_1, var_0_1.farmlands.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_50_0, arg_50_1, var_0_1.ussingen.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_50_0, arg_50_1, var_0_1.nurgle.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_50_0, arg_50_1, var_0_1.warcamp.level_id, rank) then
			num = num + 1
		end

		return num >= 4
	end,
	progress = function (arg_51_0, arg_51_1)
		-- function 51
		local num = 0
		local rank = var_0_5.hard.rank

		if not check_level_difficulty(arg_51_0, arg_51_1, var_0_1.farmlands.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_51_0, arg_51_1, var_0_1.ussingen.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_51_0, arg_51_1, var_0_1.nurgle.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_51_0, arg_51_1, var_0_1.warcamp.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_52_0, arg_52_1)
		-- function 52
		local rank = var_0_5.hard.rank
		local var_52_1 = check_level_difficulty(arg_52_0, arg_52_1, var_0_1.farmlands.level_id, rank)
		local var_52_2 = check_level_difficulty(arg_52_0, arg_52_1, var_0_1.ussingen.level_id, rank)
		local var_52_3 = check_level_difficulty(arg_52_0, arg_52_1, var_0_1.nurgle.level_id, rank)
		local var_52_4 = check_level_difficulty(arg_52_0, arg_52_1, var_0_1.warcamp.level_id, rank)

		return {
			{
				name = "level_name_farmlands",
				completed = var_52_1
			},
			{
				name = "level_name_ussingen",
				completed = var_52_2
			},
			{
				name = "level_name_nurgle",
				completed = var_52_3
			},
			{
				name = "level_name_warcamp",
				completed = var_52_4
			}
		}
	end
}
AchievementTemplates.achievements.complete_act_three_champion = {
	name = "achv_complete_act_three_champion_name",
	icon = "icons_placeholder",
	desc = "achv_complete_act_three_champion_desc",
	completed = function (arg_53_0, arg_53_1)
		-- function 53
		local num = 0
		local rank = var_0_5.harder.rank

		if not check_level_difficulty(arg_53_0, arg_53_1, var_0_1.farmlands.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_53_0, arg_53_1, var_0_1.ussingen.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_53_0, arg_53_1, var_0_1.nurgle.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_53_0, arg_53_1, var_0_1.warcamp.level_id, rank) then
			num = num + 1
		end

		return num >= 4
	end,
	progress = function (arg_54_0, arg_54_1)
		-- function 54
		local num = 0
		local rank = var_0_5.harder.rank

		if not check_level_difficulty(arg_54_0, arg_54_1, var_0_1.farmlands.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_54_0, arg_54_1, var_0_1.ussingen.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_54_0, arg_54_1, var_0_1.nurgle.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_54_0, arg_54_1, var_0_1.warcamp.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_55_0, arg_55_1)
		-- function 55
		local rank = var_0_5.harder.rank
		local var_55_1 = check_level_difficulty(arg_55_0, arg_55_1, var_0_1.farmlands.level_id, rank)
		local var_55_2 = check_level_difficulty(arg_55_0, arg_55_1, var_0_1.ussingen.level_id, rank)
		local var_55_3 = check_level_difficulty(arg_55_0, arg_55_1, var_0_1.nurgle.level_id, rank)
		local var_55_4 = check_level_difficulty(arg_55_0, arg_55_1, var_0_1.warcamp.level_id, rank)

		return {
			{
				name = "level_name_farmlands",
				completed = var_55_1
			},
			{
				name = "level_name_ussingen",
				completed = var_55_2
			},
			{
				name = "level_name_nurgle",
				completed = var_55_3
			},
			{
				name = "level_name_warcamp",
				completed = var_55_4
			}
		}
	end
}
AchievementTemplates.achievements.complete_act_three_legend = {
	name = "achv_complete_act_three_legend_name",
	icon = "icons_placeholder",
	desc = "achv_complete_act_three_legend_desc",
	completed = function (arg_56_0, arg_56_1)
		-- function 56
		local num = 0
		local rank = var_0_5.hardest.rank

		if not check_level_difficulty(arg_56_0, arg_56_1, var_0_1.farmlands.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_56_0, arg_56_1, var_0_1.ussingen.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_56_0, arg_56_1, var_0_1.nurgle.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_56_0, arg_56_1, var_0_1.warcamp.level_id, rank) then
			num = num + 1
		end

		return num >= 4
	end,
	progress = function (arg_57_0, arg_57_1)
		-- function 57
		local num = 0
		local rank = var_0_5.hardest.rank

		if not check_level_difficulty(arg_57_0, arg_57_1, var_0_1.farmlands.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_57_0, arg_57_1, var_0_1.ussingen.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_57_0, arg_57_1, var_0_1.nurgle.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_57_0, arg_57_1, var_0_1.warcamp.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_58_0, arg_58_1)
		-- function 58
		local rank = var_0_5.hardest.rank
		local var_58_1 = check_level_difficulty(arg_58_0, arg_58_1, var_0_1.farmlands.level_id, rank)
		local var_58_2 = check_level_difficulty(arg_58_0, arg_58_1, var_0_1.ussingen.level_id, rank)
		local var_58_3 = check_level_difficulty(arg_58_0, arg_58_1, var_0_1.nurgle.level_id, rank)
		local var_58_4 = check_level_difficulty(arg_58_0, arg_58_1, var_0_1.warcamp.level_id, rank)

		return {
			{
				name = "level_name_farmlands",
				completed = var_58_1
			},
			{
				name = "level_name_ussingen",
				completed = var_58_2
			},
			{
				name = "level_name_nurgle",
				completed = var_58_3
			},
			{
				name = "level_name_warcamp",
				completed = var_58_4
			}
		}
	end
}
AchievementTemplates.achievements.complete_skittergate_recruit = {
	ID_XB1 = 6,
	name = "achv_complete_skittergate_normal_name",
	ID_PS4 = "005",
	ID_STEAM = "complete_skittergate_recruit",
	icon = "achievement_trophy_05",
	desc = "achv_complete_skittergate_normal_desc",
	completed = function (arg_59_0, arg_59_1)
		-- function 59
		local rank = var_0_5.normal.rank

		return check_level_difficulty(arg_59_0, arg_59_1, var_0_1.skittergate.level_id, rank)
	end
}
AchievementTemplates.achievements.complete_skittergate_veteran = {
	ID_XB1 = 7,
	name = "achv_complete_skittergate_hard_name",
	ID_PS4 = "006",
	ID_STEAM = "complete_skittergate_veteran",
	icon = "achievement_trophy_06",
	desc = "achv_complete_skittergate_hard_desc",
	completed = function (arg_60_0, arg_60_1)
		-- function 60
		local rank = var_0_5.hard.rank

		return check_level_difficulty(arg_60_0, arg_60_1, var_0_1.skittergate.level_id, rank)
	end
}
AchievementTemplates.achievements.complete_skittergate_champion = {
	ID_XB1 = 8,
	name = "achv_complete_skittergate_nightmare_name",
	ID_PS4 = "007",
	ID_STEAM = "complete_skittergate_champion",
	icon = "achievement_trophy_07",
	desc = "achv_complete_skittergate_nightmare_desc",
	completed = function (arg_61_0, arg_61_1)
		-- function 61
		local rank = var_0_5.harder.rank

		return check_level_difficulty(arg_61_0, arg_61_1, var_0_1.skittergate.level_id, rank)
	end
}
AchievementTemplates.achievements.complete_skittergate_legend = {
	ID_XB1 = 9,
	name = "achv_complete_skittergate_cataclysm_name",
	ID_PS4 = "008",
	ID_STEAM = "complete_skittergate_legend",
	icon = "achievement_trophy_08",
	desc = "achv_complete_skittergate_cataclysm_desc",
	completed = function (arg_62_0, arg_62_1)
		-- function 62
		local rank = var_0_5.hardest.rank

		return check_level_difficulty(arg_62_0, arg_62_1, var_0_1.skittergate.level_id, rank)
	end
}
AchievementTemplates.achievements.bogenhafen_complete_recruit = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_complete_recruit_name",
	icon = "icons_placeholder",
	desc = "achv_bogenhafen_complete_recruit_desc",
	completed = function (arg_63_0, arg_63_1)
		-- function 63
		local num = 0
		local rank = var_0_5.normal.rank

		if not check_level_difficulty(arg_63_0, arg_63_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_63_0, arg_63_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return num >= 2
	end,
	progress = function (arg_64_0, arg_64_1)
		-- function 64
		local num = 0
		local rank = var_0_5.normal.rank

		if not check_level_difficulty(arg_64_0, arg_64_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_64_0, arg_64_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			2
		}
	end,
	requirements = function (arg_65_0, arg_65_1)
		-- function 65
		local rank = var_0_5.normal.rank
		local var_65_1 = check_level_difficulty(arg_65_0, arg_65_1, var_0_1.dlc_bogenhafen_slum.level_id, rank)
		local var_65_2 = check_level_difficulty(arg_65_0, arg_65_1, var_0_1.dlc_bogenhafen_city.level_id, rank)

		return {
			{
				name = "level_name_slum",
				completed = var_65_1
			},
			{
				name = "level_name_city",
				completed = var_65_2
			}
		}
	end
}
AchievementTemplates.achievements.bogenhafen_complete_veteran = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_complete_veteran_name",
	icon = "icons_placeholder",
	desc = "achv_bogenhafen_complete_veteran_desc",
	completed = function (arg_66_0, arg_66_1)
		-- function 66
		local num = 0
		local rank = var_0_5.hard.rank

		if not check_level_difficulty(arg_66_0, arg_66_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_66_0, arg_66_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return num >= 2
	end,
	progress = function (arg_67_0, arg_67_1)
		-- function 67
		local num = 0
		local rank = var_0_5.hard.rank

		if not check_level_difficulty(arg_67_0, arg_67_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_67_0, arg_67_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			2
		}
	end,
	requirements = function (arg_68_0, arg_68_1)
		-- function 68
		local rank = var_0_5.hard.rank
		local var_68_1 = check_level_difficulty(arg_68_0, arg_68_1, var_0_1.dlc_bogenhafen_slum.level_id, rank)
		local var_68_2 = check_level_difficulty(arg_68_0, arg_68_1, var_0_1.dlc_bogenhafen_city.level_id, rank)

		return {
			{
				name = "level_name_slum",
				completed = var_68_1
			},
			{
				name = "level_name_city",
				completed = var_68_2
			}
		}
	end
}
AchievementTemplates.achievements.bogenhafen_complete_champion = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_complete_champion_name",
	icon = "icons_placeholder",
	desc = "achv_bogenhafen_complete_champion_desc",
	completed = function (arg_69_0, arg_69_1)
		-- function 69
		local num = 0
		local rank = var_0_5.harder.rank

		if not check_level_difficulty(arg_69_0, arg_69_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_69_0, arg_69_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return num >= 2
	end,
	progress = function (arg_70_0, arg_70_1)
		-- function 70
		local num = 0
		local rank = var_0_5.harder.rank

		if not check_level_difficulty(arg_70_0, arg_70_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_70_0, arg_70_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			2
		}
	end,
	requirements = function (arg_71_0, arg_71_1)
		-- function 71
		local rank = var_0_5.harder.rank
		local var_71_1 = check_level_difficulty(arg_71_0, arg_71_1, var_0_1.dlc_bogenhafen_slum.level_id, rank)
		local var_71_2 = check_level_difficulty(arg_71_0, arg_71_1, var_0_1.dlc_bogenhafen_city.level_id, rank)

		return {
			{
				name = "level_name_slum",
				completed = var_71_1
			},
			{
				name = "level_name_city",
				completed = var_71_2
			}
		}
	end
}
AchievementTemplates.achievements.bogenhafen_complete_legend = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_complete_legend_name",
	icon = "icons_placeholder",
	desc = "achv_bogenhafen_complete_legend_desc",
	completed = function (arg_72_0, arg_72_1)
		-- function 72
		local num = 0
		local rank = var_0_5.hardest.rank

		if not check_level_difficulty(arg_72_0, arg_72_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_72_0, arg_72_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return num >= 2
	end,
	progress = function (arg_73_0, arg_73_1)
		-- function 73
		local num = 0
		local rank = var_0_5.hardest.rank

		if not check_level_difficulty(arg_73_0, arg_73_1, var_0_1.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_73_0, arg_73_1, var_0_1.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			2
		}
	end,
	requirements = function (arg_74_0, arg_74_1)
		-- function 74
		local rank = var_0_5.hardest.rank
		local var_74_1 = check_level_difficulty(arg_74_0, arg_74_1, var_0_1.dlc_bogenhafen_slum.level_id, rank)
		local var_74_2 = check_level_difficulty(arg_74_0, arg_74_1, var_0_1.dlc_bogenhafen_city.level_id, rank)

		return {
			{
				name = "level_name_slum",
				completed = var_74_1
			},
			{
				name = "level_name_city",
				completed = var_74_2
			}
		}
	end
}
AchievementTemplates.achievements.bogenhafen_city_no_braziers_lit = {
	ID_XB1 = 56,
	name = "achv_bogenhafen_city_no_braziers_lit_name",
	required_dlc = "bogenhafen",
	ID_PS4 = "055",
	icon = "achievement_trophy_bogenhafen_city_no_braziers_lit",
	display_completion_ui = true,
	desc = "achv_bogenhafen_city_no_braziers_lit_desc",
	completed = function (self, arg_75_1, arg_75_2)
		-- function 75
		return self:get_persistent_stat(arg_75_1, "bogenhafen_city_no_braziers_lit") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_city_torch_not_picked_up = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_city_torch_not_picked_up_name",
	display_completion_ui = true,
	icon = "achievement_trophy_bogenhafen_city_torch_not_picked_up",
	desc = "achv_bogenhafen_city_torch_not_picked_up_desc",
	completed = function (self, arg_76_1)
		-- function 76
		return self:get_persistent_stat(arg_76_1, "bogenhafen_city_torch_not_picked_up") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_city_fast_switches = {
	ID_XB1 = 57,
	name = "achv_bogenhafen_city_fast_switches_name",
	required_dlc = "bogenhafen",
	ID_PS4 = "056",
	icon = "achievement_trophy_bogenhafen_city_fast_switches",
	display_completion_ui = true,
	desc = "achv_bogenhafen_city_fast_switches_desc",
	completed = function (self, arg_77_1)
		-- function 77
		return self:get_persistent_stat(arg_77_1, "bogenhafen_city_fast_switches") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_city_all_wine_collected = {
	ID_XB1 = 58,
	name = "achv_bogenhafen_city_all_wine_collected_name",
	required_dlc = "bogenhafen",
	ID_PS4 = "057",
	icon = "achievement_trophy_bogenhafen_city_all_wine_collected",
	display_completion_ui = true,
	desc = "achv_bogenhafen_city_all_wine_collected_desc",
	completed = function (self, arg_78_1)
		-- function 78
		return self:get_persistent_stat(arg_78_1, "bogenhafen_city_all_wine_collected") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_city_jumping_puzzle = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_city_jumping_puzzle_name",
	display_completion_ui = true,
	icon = "achievement_trophy_bogenhafen_city_jumping_puzzle",
	desc = "achv_bogenhafen_city_jumping_puzzle_desc",
	completed = function (self, arg_79_1)
		-- function 79
		return self:get_persistent_stat(arg_79_1, "bogenhafen_city_jumping_puzzle") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_slum_no_ratling_damage = {
	ID_XB1 = 59,
	name = "achv_bogenhafen_slum_no_ratling_damage_name",
	required_dlc = "bogenhafen",
	ID_PS4 = "058",
	icon = "achievement_trophy_bogenhafen_slum_no_ratling_damage",
	display_completion_ui = true,
	desc = "achv_bogenhafen_slum_no_ratling_damage_desc",
	completed = function (self, arg_80_1)
		-- function 80
		return self:get_persistent_stat(arg_80_1, "bogenhafen_slum_no_ratling_damage") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_slum_no_windows_broken = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_slum_no_windows_broken_name",
	display_completion_ui = true,
	icon = "achievement_trophy_bogenhafen_slum_no_windows_broken",
	desc = "achv_bogenhafen_slum_no_windows_broken_desc",
	completed = function (self, arg_81_1)
		-- function 81
		return self:get_persistent_stat(arg_81_1, "bogenhafen_slum_no_windows_broken") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_slum_find_hidden_stash = {
	ID_XB1 = 60,
	name = "achv_bogenhafen_slum_find_hidden_stash_name",
	required_dlc = "bogenhafen",
	ID_PS4 = "059",
	icon = "achievement_trophy_bogenhafen_slum_find_hidden_stash",
	display_completion_ui = true,
	desc = "achv_bogenhafen_slum_find_hidden_stash_desc",
	completed = function (self, arg_82_1)
		-- function 82
		return self:get_persistent_stat(arg_82_1, "bogenhafen_slum_find_hidden_stash") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_slum_jumping_puzzle = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_slum_jumping_puzzle_name",
	display_completion_ui = true,
	icon = "achievement_trophy_bogenhafen_slum_jumping_puzzle",
	desc = "achv_bogenhafen_slum_jumping_puzzle_desc",
	completed = function (self, arg_83_1)
		-- function 83
		return self:get_persistent_stat(arg_83_1, "bogenhafen_slum_jumping_puzzle") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_slum_event_speedrun = {
	ID_XB1 = 61,
	name = "achv_bogenhafen_slum_event_speedrun_name",
	required_dlc = "bogenhafen",
	ID_PS4 = "060",
	icon = "achievement_trophy_bogenhafen_slum_event_speedrun",
	display_completion_ui = true,
	desc = "achv_bogenhafen_slum_event_speedrun_desc",
	completed = function (self, arg_84_1)
		-- function 84
		return self:get_persistent_stat(arg_84_1, "bogenhafen_slum_event_speedrun") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_collect_all_cosmetics = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_collect_all_cosmetics_name",
	icon = "achievement_trophy_bogenhafen_collect_all_cosmetics",
	desc = "achv_bogenhafen_collect_all_cosmetics_desc",
	completed = function (self, arg_85_1)
		-- function 85
		return self:get_persistent_stat(arg_85_1, "collected_bogenhafen_cosmetics") >= num
	end,
	progress = function (self, arg_86_1)
		-- function 86
		local get_persistent_stat = self:get_persistent_stat(arg_86_1, "collected_bogenhafen_cosmetics")

		return {
			get_persistent_stat,
			num
		}
	end
}

local var_0_14 = (function (arg_87_0)
	-- function 87
	local var_87_0

	for i, v in ipairs(arg_87_0) do
		if v == "prologue" then
			var_87_0 = i
		end
	end

	local var_87_1 = arg_87_0

	if not var_87_0 then
		table.remove(var_87_1, var_87_0)
	end

	return var_87_1
end)(MainGameLevels)
local tbl = {}

AchievementTemplates.achievements.completed_all_levels = {
	name = "achv_complete_all_levels_name",
	desc = "achv_complete_all_levels_desc",
	completed = function (arg_88_0, arg_88_1)
		-- function 88
		return check_level_list(arg_88_0, arg_88_1, var_0_14)
	end,
	progress = function (arg_89_0, arg_89_1)
		-- function 89
		local num = 0

		for i, v in ipairs(var_0_14) do
			if not check_level_list(arg_89_0, arg_89_1, {
				v
			}) then
				num = num + 1
			end
		end

		return {
			num,
			#var_0_14
		}
	end,
	requirements = function (arg_90_0, arg_90_1)
		-- function 90
		table.clear(tbl)

		for i, v in ipairs(var_0_14) do
			local var_90_0 = check_level_list(arg_90_0, arg_90_1, {
				v
			})

			table.insert(tbl, {
				name = var_0_1[v].display_name,
				completed = var_90_0
			})
		end

		return tbl
	end
}
AchievementTemplates.achievements.achievement_bardin_level_1 = {
	name = "achv_achievement_bardin_level_1_name",
	icon = "achievement_trophy_bardin_level_1",
	desc = "achv_achievement_bardin_level_1_desc",
	completed = function (arg_91_0, arg_91_1)
		-- function 91
		return hero_level("dwarf_ranger") >= 17
	end,
	progress = function (arg_92_0, arg_92_1)
		-- function 92
		local var_92_0 = hero_level("dwarf_ranger")

		if var_92_0 > 17 then
			var_92_0 = 17
		end

		return {
			var_92_0,
			17
		}
	end
}
AchievementTemplates.achievements.achievement_bardin_level_2 = {
	name = "achv_achievement_bardin_level_2_name",
	icon = "achievement_trophy_bardin_level_2",
	desc = "achv_achievement_bardin_level_2_desc",
	completed = function (arg_93_0, arg_93_1)
		-- function 93
		return hero_level("dwarf_ranger") >= 22
	end,
	progress = function (arg_94_0, arg_94_1)
		-- function 94
		local var_94_0 = hero_level("dwarf_ranger")

		if var_94_0 > 22 then
			var_94_0 = 22
		end

		return {
			var_94_0,
			22
		}
	end
}
AchievementTemplates.achievements.achievement_bardin_level_3 = {
	name = "achv_achievement_bardin_level_3_name",
	icon = "achievement_trophy_bardin_level_3",
	desc = "achv_achievement_bardin_level_3_desc",
	completed = function (arg_95_0, arg_95_1)
		-- function 95
		return hero_level("dwarf_ranger") >= 27
	end,
	progress = function (arg_96_0, arg_96_1)
		-- function 96
		local var_96_0 = hero_level("dwarf_ranger")

		if var_96_0 > 27 then
			var_96_0 = 27
		end

		return {
			var_96_0,
			27
		}
	end
}
AchievementTemplates.achievements.achievement_markus_level_1 = {
	name = "achv_achievement_markus_level_1_name",
	icon = "achievement_trophy_markus_level_1",
	desc = "achv_achievement_markus_level_1_desc",
	completed = function (arg_97_0, arg_97_1)
		-- function 97
		return hero_level("empire_soldier") >= 17
	end,
	progress = function (arg_98_0, arg_98_1)
		-- function 98
		local var_98_0 = hero_level("empire_soldier")

		if var_98_0 > 17 then
			var_98_0 = 17
		end

		return {
			var_98_0,
			17
		}
	end
}
AchievementTemplates.achievements.achievement_markus_level_2 = {
	name = "achv_achievement_markus_level_2_name",
	icon = "achievement_trophy_markus_level_2",
	desc = "achv_achievement_markus_level_2_desc",
	completed = function (arg_99_0, arg_99_1)
		-- function 99
		return hero_level("empire_soldier") >= 22
	end,
	progress = function (arg_100_0, arg_100_1)
		-- function 100
		local var_100_0 = hero_level("empire_soldier")

		if var_100_0 > 22 then
			var_100_0 = 22
		end

		return {
			var_100_0,
			22
		}
	end
}
AchievementTemplates.achievements.achievement_markus_level_3 = {
	name = "achv_achievement_markus_level_3_name",
	icon = "achievement_trophy_markus_level_3",
	desc = "achv_achievement_markus_level_3_desc",
	completed = function (arg_101_0, arg_101_1)
		-- function 101
		return hero_level("empire_soldier") >= 27
	end,
	progress = function (arg_102_0, arg_102_1)
		-- function 102
		local var_102_0 = hero_level("empire_soldier")

		if var_102_0 > 27 then
			var_102_0 = 27
		end

		return {
			var_102_0,
			27
		}
	end
}
AchievementTemplates.achievements.achievement_kerillian_level_1 = {
	name = "achv_achievement_kerillian_level_1_name",
	icon = "achievement_trophy_kerillian_level_1",
	desc = "achv_achievement_kerillian_level_1_desc",
	completed = function (arg_103_0, arg_103_1)
		-- function 103
		return hero_level("wood_elf") >= 17
	end,
	progress = function (arg_104_0, arg_104_1)
		-- function 104
		local var_104_0 = hero_level("wood_elf")

		if var_104_0 > 17 then
			var_104_0 = 17
		end

		return {
			var_104_0,
			17
		}
	end
}
AchievementTemplates.achievements.achievement_kerillian_level_2 = {
	name = "achv_achievement_kerillian_level_2_name",
	icon = "achievement_trophy_kerillian_level_2",
	desc = "achv_achievement_kerillian_level_2_desc",
	completed = function (arg_105_0, arg_105_1)
		-- function 105
		return hero_level("wood_elf") >= 22
	end,
	progress = function (arg_106_0, arg_106_1)
		-- function 106
		local var_106_0 = hero_level("wood_elf")

		if var_106_0 > 22 then
			var_106_0 = 22
		end

		return {
			var_106_0,
			22
		}
	end
}
AchievementTemplates.achievements.achievement_kerillian_level_3 = {
	name = "achv_achievement_kerillian_level_3_name",
	icon = "achievement_trophy_kerillian_level_3",
	desc = "achv_achievement_kerillian_level_3_desc",
	completed = function (arg_107_0, arg_107_1)
		-- function 107
		return hero_level("wood_elf") >= 27
	end,
	progress = function (arg_108_0, arg_108_1)
		-- function 108
		local var_108_0 = hero_level("wood_elf")

		if var_108_0 > 27 then
			var_108_0 = 27
		end

		return {
			var_108_0,
			27
		}
	end
}
AchievementTemplates.achievements.achievement_sienna_level_1 = {
	name = "achv_achievement_sienna_level_1_name",
	icon = "achievement_trophy_sienna_level_1",
	desc = "achv_achievement_sienna_level_1_desc",
	completed = function (arg_109_0, arg_109_1)
		-- function 109
		return hero_level("bright_wizard") >= 17
	end,
	progress = function (arg_110_0, arg_110_1)
		-- function 110
		local var_110_0 = hero_level("bright_wizard")

		if var_110_0 > 17 then
			var_110_0 = 17
		end

		return {
			var_110_0,
			17
		}
	end
}
AchievementTemplates.achievements.achievement_sienna_level_2 = {
	name = "achv_achievement_sienna_level_2_name",
	icon = "achievement_trophy_sienna_level_2",
	desc = "achv_achievement_sienna_level_2_desc",
	completed = function (arg_111_0, arg_111_1)
		-- function 111
		return hero_level("bright_wizard") >= 22
	end,
	progress = function (arg_112_0, arg_112_1)
		-- function 112
		local var_112_0 = hero_level("bright_wizard")

		if var_112_0 > 22 then
			var_112_0 = 22
		end

		return {
			var_112_0,
			22
		}
	end
}
AchievementTemplates.achievements.achievement_sienna_level_3 = {
	name = "achv_achievement_sienna_level_3_name",
	icon = "achievement_trophy_sienna_level_3",
	desc = "achv_achievement_sienna_level_3_desc",
	completed = function (arg_113_0, arg_113_1)
		-- function 113
		return hero_level("bright_wizard") >= 27
	end,
	progress = function (arg_114_0, arg_114_1)
		-- function 114
		local var_114_0 = hero_level("bright_wizard")

		if var_114_0 > 27 then
			var_114_0 = 27
		end

		return {
			var_114_0,
			27
		}
	end
}
AchievementTemplates.achievements.achievement_victor_level_1 = {
	name = "achv_achievement_victor_level_1_name",
	icon = "achievement_trophy_victor_level_1",
	desc = "achv_achievement_victor_level_1_desc",
	completed = function (arg_115_0, arg_115_1)
		-- function 115
		return hero_level("witch_hunter") >= 17
	end,
	progress = function (arg_116_0, arg_116_1)
		-- function 116
		local var_116_0 = hero_level("witch_hunter")

		if var_116_0 > 17 then
			var_116_0 = 17
		end

		return {
			var_116_0,
			17
		}
	end
}
AchievementTemplates.achievements.achievement_victor_level_2 = {
	name = "achv_achievement_victor_level_2_name",
	icon = "achievement_trophy_victor_level_2",
	desc = "achv_achievement_victor_level_2_desc",
	completed = function (arg_117_0, arg_117_1)
		-- function 117
		return hero_level("witch_hunter") >= 22
	end,
	progress = function (arg_118_0, arg_118_1)
		-- function 118
		local var_118_0 = hero_level("witch_hunter")

		if var_118_0 > 22 then
			var_118_0 = 22
		end

		return {
			var_118_0,
			22
		}
	end
}
AchievementTemplates.achievements.achievement_victor_level_3 = {
	name = "achv_achievement_victor_level_3_name",
	icon = "achievement_trophy_victor_level_3",
	desc = "achv_achievement_victor_level_3_desc",
	completed = function (arg_119_0, arg_119_1)
		-- function 119
		return hero_level("witch_hunter") >= 27
	end,
	progress = function (arg_120_0, arg_120_1)
		-- function 120
		local var_120_0 = hero_level("witch_hunter")

		if var_120_0 > 27 then
			var_120_0 = 27
		end

		return {
			var_120_0,
			27
		}
	end
}
AchievementTemplates.achievements.level_thirty_wood_elf = {
	ID_XB1 = 10,
	name = "achv_level_thirty_wood_elf_name",
	ID_PS4 = "009",
	icon = "achievement_trophy_09",
	ID_STEAM = "level_thirty_wood_elf",
	desc = "achv_level_thirty_wood_elf_desc",
	completed = function (arg_121_0, arg_121_1)
		-- function 121
		return hero_level("wood_elf") >= 30
	end,
	progress = function (arg_122_0, arg_122_1)
		-- function 122
		local var_122_0 = hero_level("wood_elf")

		if var_122_0 > 30 then
			var_122_0 = 30
		end

		return {
			var_122_0,
			30
		}
	end
}
AchievementTemplates.achievements.level_thirty_witch_hunter = {
	ID_XB1 = 11,
	name = "achv_level_thirty_witch_hunter_name",
	ID_PS4 = "010",
	icon = "achievement_trophy_10",
	ID_STEAM = "level_thirty_witch_hunter",
	desc = "achv_level_thirty_witch_hunter_desc",
	completed = function (arg_123_0, arg_123_1)
		-- function 123
		return hero_level("witch_hunter") >= 30
	end,
	progress = function (arg_124_0, arg_124_1)
		-- function 124
		local var_124_0 = hero_level("witch_hunter")

		if var_124_0 > 30 then
			var_124_0 = 30
		end

		return {
			var_124_0,
			30
		}
	end
}
AchievementTemplates.achievements.level_thirty_empire_soldier = {
	ID_XB1 = 12,
	name = "achv_level_thirty_empire_soldier_name",
	ID_PS4 = "011",
	icon = "achievement_trophy_11",
	ID_STEAM = "level_thirty_empire_soldier",
	desc = "achv_level_thirty_empire_soldier_desc",
	completed = function (arg_125_0, arg_125_1)
		-- function 125
		return hero_level("empire_soldier") >= 30
	end,
	progress = function (arg_126_0, arg_126_1)
		-- function 126
		local var_126_0 = hero_level("empire_soldier")

		if var_126_0 > 30 then
			var_126_0 = 30
		end

		return {
			var_126_0,
			30
		}
	end
}
AchievementTemplates.achievements.level_thirty_bright_wizard = {
	ID_XB1 = 13,
	name = "achv_level_thirty_bright_wizard_name",
	ID_PS4 = "012",
	icon = "achievement_trophy_12",
	ID_STEAM = "level_thirty_bright_wizard",
	desc = "achv_level_thirty_bright_wizard_desc",
	completed = function (arg_127_0, arg_127_1)
		-- function 127
		return hero_level("bright_wizard") >= 30
	end,
	progress = function (arg_128_0, arg_128_1)
		-- function 128
		local var_128_0 = hero_level("bright_wizard")

		if var_128_0 > 30 then
			var_128_0 = 30
		end

		return {
			var_128_0,
			30
		}
	end
}
AchievementTemplates.achievements.level_thirty_dwarf_ranger = {
	ID_XB1 = 14,
	name = "achv_level_thirty_dwarf_ranger_name",
	ID_PS4 = "013",
	icon = "achievement_trophy_13",
	ID_STEAM = "level_thirty_dwarf_ranger",
	desc = "achv_level_thirty_dwarf_ranger_desc",
	completed = function (arg_129_0, arg_129_1)
		-- function 129
		return hero_level("dwarf_ranger") >= 30
	end,
	progress = function (arg_130_0, arg_130_1)
		-- function 130
		local var_130_0 = hero_level("dwarf_ranger")

		if var_130_0 > 30 then
			var_130_0 = 30
		end

		return {
			var_130_0,
			30
		}
	end
}
AchievementTemplates.achievements.level_thirty_all = {
	ID_XB1 = 15,
	name = "achv_level_thirty_all_name",
	desc = "achv_level_thirty_all_desc",
	ID_STEAM = "level_thirty_all",
	ID_PS4 = "014",
	icon = "achievement_trophy_14",
	completed = function (arg_131_0, arg_131_1)
		-- function 131
		return not (hero_level("wood_elf") >= 30) or not (hero_level("witch_hunter") >= 30) or not (hero_level("empire_soldier") >= 30) or not (hero_level("bright_wizard") >= 30) or hero_level("dwarf_ranger") >= 30
	end,
	progress = function (arg_132_0, arg_132_1)
		-- function 132
		local num = 0

		if hero_level("wood_elf") >= 30 then
			num = num + 1
		end

		if hero_level("witch_hunter") >= 30 then
			num = num + 1
		end

		if hero_level("empire_soldier") >= 30 then
			num = num + 1
		end

		if hero_level("bright_wizard") >= 30 then
			num = num + 1
		end

		if hero_level("dwarf_ranger") >= 30 then
			num = num + 1
		end

		return {
			num,
			5
		}
	end,
	requirements = function (arg_133_0, arg_133_1)
		-- function 133
		local var_133_0 = hero_level("wood_elf")
		local var_133_1 = hero_level("witch_hunter")
		local var_133_2 = hero_level("empire_soldier")
		local var_133_3 = hero_level("bright_wizard")
		local var_133_4 = hero_level("dwarf_ranger")

		return {
			{
				name = "wood_elf_short",
				completed = var_133_0 >= 30
			},
			{
				name = "witch_hunter_short",
				completed = var_133_1 >= 30
			},
			{
				name = "empire_soldier_short",
				completed = var_133_2 >= 30
			},
			{
				name = "bright_wizard_short",
				completed = var_133_3 >= 30
			},
			{
				name = "dwarf_ranger_short",
				completed = var_133_4 >= 30
			}
		}
	end
}
AchievementTemplates.achievements.unlock_first_talent_point = {
	ID_XB1 = 16,
	name = "achv_unlock_first_talent_point_name",
	ID_PS4 = "015",
	ID_STEAM = "unlock_first_talent_point",
	icon = "achievement_trophy_15",
	desc = "achv_unlock_first_talent_point_desc",
	completed = function (arg_134_0, arg_134_1)
		-- function 134
		if not (Managers.mechanism:current_mechanism_name() == "versus") then
			return false
		end

		local tbl = {
			"wood_elf",
			"witch_hunter",
			"empire_soldier",
			"bright_wizard",
			"dwarf_ranger"
		}

		for i, v in ipairs(tbl) do
			if var_0_3.get_num_talent_points(v) >= 1 then
				return true
			end
		end

		return false
	end
}
AchievementTemplates.achievements.unlock_all_talent_points = {
	ID_XB1 = 17,
	name = "achv_unlock_all_talent_points_name",
	ID_PS4 = "016",
	ID_STEAM = "unlock_all_talent_points",
	icon = "achievement_trophy_16",
	desc = "achv_unlock_all_talent_points_desc",
	completed = function (arg_135_0, arg_135_1)
		-- function 135
		if not (Managers.mechanism:current_mechanism_name() == "versus") then
			return false
		end

		local tbl = {
			"wood_elf",
			"witch_hunter",
			"empire_soldier",
			"bright_wizard",
			"dwarf_ranger"
		}

		for i, v in ipairs(tbl) do
			if var_0_3.get_num_talent_points(v) == 6 then
				return true
			end
		end

		return false
	end
}
AchievementTemplates.achievements.craft_item = {
	ID_XB1 = 18,
	name = "achv_craft_item_name",
	ID_PS4 = "017",
	ID_STEAM = "craft_item",
	icon = "achievement_trophy_17",
	desc = "achv_craft_item_desc",
	completed = function (self, arg_136_1)
		-- function 136
		return self:get_persistent_stat(arg_136_1, "crafted_items") >= 1
	end
}
AchievementTemplates.achievements.craft_fifty_items = {
	ID_XB1 = 19,
	name = "achv_craft_fifty_items_name",
	ID_PS4 = "018",
	icon = "achievement_trophy_18",
	ID_STEAM = "craft_fifty_items",
	desc = "achv_craft_fifty_items_desc",
	completed = function (self, arg_137_1)
		-- function 137
		return self:get_persistent_stat(arg_137_1, "crafted_items") >= 50
	end,
	progress = function (self, arg_138_1)
		-- function 138
		local get_persistent_stat = self:get_persistent_stat(arg_138_1, "crafted_items")

		if get_persistent_stat > 50 then
			get_persistent_stat = 50
		end

		return {
			get_persistent_stat,
			50
		}
	end
}
AchievementTemplates.achievements.salvage_item = {
	ID_XB1 = 20,
	name = "achv_salvage_item_name",
	ID_PS4 = "019",
	ID_STEAM = "salvage_item",
	icon = "achievement_trophy_19",
	desc = "achv_salvage_item_desc",
	completed = function (self, arg_139_1)
		-- function 139
		return self:get_persistent_stat(arg_139_1, "salvaged_items") >= 1
	end
}
AchievementTemplates.achievements.salvage_hundred_items = {
	ID_XB1 = 21,
	name = "achv_salvage_hundred_items_name",
	ID_PS4 = "020",
	icon = "achievement_trophy_20",
	ID_STEAM = "salvage_hundred_items",
	desc = "achv_salvage_hundred_items_desc",
	completed = function (self, arg_140_1)
		-- function 140
		return self:get_persistent_stat(arg_140_1, "salvaged_items") >= 100
	end,
	progress = function (self, arg_141_1)
		-- function 141
		local get_persistent_stat = self:get_persistent_stat(arg_141_1, "salvaged_items")

		if get_persistent_stat > 100 then
			get_persistent_stat = 100
		end

		return {
			get_persistent_stat,
			100
		}
	end
}
AchievementTemplates.achievements.equip_common_quality = {
	ID_XB1 = 22,
	name = "achv_equip_common_quality_name",
	ID_PS4 = "021",
	ID_STEAM = "equip_common_quality",
	icon = "achievement_trophy_21",
	desc = "achv_equip_common_quality_desc",
	completed = function (arg_142_0, arg_142_1)
		-- function 142
		return equipped_items_of_rarity(arg_142_0, arg_142_1, "common") >= 1
	end
}
AchievementTemplates.achievements.equip_rare_quality = {
	ID_XB1 = 23,
	name = "achv_equip_rare_quality_name",
	ID_PS4 = "022",
	ID_STEAM = "equip_rare_quality",
	icon = "achievement_trophy_22",
	desc = "achv_equip_rare_quality_desc",
	completed = function (arg_143_0, arg_143_1)
		-- function 143
		return equipped_items_of_rarity(arg_143_0, arg_143_1, "rare") >= 1
	end
}
AchievementTemplates.achievements.equip_exotic_quality = {
	ID_XB1 = 24,
	name = "achv_equip_exotic_quality_name",
	ID_PS4 = "023",
	ID_STEAM = "equip_exotic_quality",
	icon = "achievement_trophy_23",
	desc = "achv_equip_exotic_quality_desc",
	completed = function (arg_144_0, arg_144_1)
		-- function 144
		return equipped_items_of_rarity(arg_144_0, arg_144_1, "exotic") >= 1
	end
}
AchievementTemplates.achievements.equip_all_exotic_quality = {
	ID_XB1 = 25,
	name = "achv_equip_all_exotic_quality_name",
	desc = "achv_equip_all_exotic_quality_desc",
	ID_STEAM = "equip_all_exotic_quality",
	ID_PS4 = "024",
	icon = "achievement_trophy_24",
	completed = function (arg_145_0, arg_145_1)
		-- function 145
		return equipped_items_of_rarity(arg_145_0, arg_145_1, "exotic") == 5
	end,
	progress = function (arg_146_0, arg_146_1)
		-- function 146
		local var_146_0 = equipped_items_of_rarity(arg_146_0, arg_146_1, "exotic")

		return {
			var_146_0,
			5
		}
	end,
	requirements = function (self, arg_147_1)
		-- function 147
		local get_persistent_stat = self:get_persistent_stat(arg_147_1, "highest_equipped_rarity", "melee")
		local get_persistent_stat_2 = self:get_persistent_stat(arg_147_1, "highest_equipped_rarity", "ranged")
		local get_persistent_stat_3 = self:get_persistent_stat(arg_147_1, "highest_equipped_rarity", "necklace")
		local get_persistent_stat_4 = self:get_persistent_stat(arg_147_1, "highest_equipped_rarity", "ring")
		local get_persistent_stat_5 = self:get_persistent_stat(arg_147_1, "highest_equipped_rarity", "trinket")
		local exotic = rarity_index.exotic

		return {
			{
				name = "melee",
				completed = exotic <= get_persistent_stat
			},
			{
				name = "ranged",
				completed = exotic <= get_persistent_stat_2
			},
			{
				name = "necklace",
				completed = exotic <= get_persistent_stat_3
			},
			{
				name = "ring",
				completed = exotic <= get_persistent_stat_4
			},
			{
				name = "trinket",
				completed = exotic <= get_persistent_stat_5
			}
		}
	end
}
AchievementTemplates.achievements.equip_veteran_quality = {
	ID_XB1 = 26,
	name = "achv_equip_veteran_quality_name",
	ID_PS4 = "025",
	ID_STEAM = "equip_veteran_quality",
	icon = "achievement_trophy_25",
	desc = "achv_equip_veteran_quality_desc",
	completed = function (arg_148_0, arg_148_1)
		-- function 148
		return equipped_items_of_rarity(arg_148_0, arg_148_1, "unique") >= 1
	end
}
AchievementTemplates.achievements.equip_all_veteran_quality = {
	name = "achv_equip_all_veteran_quality_name",
	icon = "achievement_trophy_equip_all_veteran_quality",
	desc = "achv_equip_all_veteran_quality_desc",
	completed = function (arg_149_0, arg_149_1)
		-- function 149
		return equipped_items_of_rarity(arg_149_0, arg_149_1, "unique") == 5
	end,
	progress = function (arg_150_0, arg_150_1)
		-- function 150
		local var_150_0 = equipped_items_of_rarity(arg_150_0, arg_150_1, "unique")

		return {
			var_150_0,
			5
		}
	end,
	requirements = function (self, arg_151_1)
		-- function 151
		local get_persistent_stat = self:get_persistent_stat(arg_151_1, "highest_equipped_rarity", "melee")
		local get_persistent_stat_2 = self:get_persistent_stat(arg_151_1, "highest_equipped_rarity", "ranged")
		local get_persistent_stat_3 = self:get_persistent_stat(arg_151_1, "highest_equipped_rarity", "necklace")
		local get_persistent_stat_4 = self:get_persistent_stat(arg_151_1, "highest_equipped_rarity", "ring")
		local get_persistent_stat_5 = self:get_persistent_stat(arg_151_1, "highest_equipped_rarity", "trinket")
		local unique = rarity_index.unique

		return {
			{
				name = "melee",
				completed = unique <= get_persistent_stat
			},
			{
				name = "ranged",
				completed = unique <= get_persistent_stat_2
			},
			{
				name = "necklace",
				completed = unique <= get_persistent_stat_3
			},
			{
				name = "ring",
				completed = unique <= get_persistent_stat_4
			},
			{
				name = "trinket",
				completed = unique <= get_persistent_stat_5
			}
		}
	end
}
AchievementTemplates.achievements.complete_level_all = {
	ID_XB1 = 27,
	name = "achv_complete_level_all_name",
	ID_PS4 = "026",
	ID_STEAM = "complete_level_all",
	icon = "achievement_trophy_26",
	desc = "achv_complete_level_all_desc",
	completed = function (self, arg_152_1)
		-- function 152
		local tbl = {
			"bright_wizard",
			"wood_elf",
			"empire_soldier",
			"dwarf_ranger",
			"witch_hunter"
		}

		for i = 1, #var_0_4 do
			local var_152_1 = var_0_4[i]
			local flag = true

			for j = 1, #tbl do
				local var_152_3 = tbl[j]

				if self:get_persistent_stat(arg_152_1, "completed_levels_" .. var_152_3, var_152_1) == 0 then
					flag = false

					break
				end
			end

			if not flag then
				return true
			end
		end

		return false
	end
}
AchievementTemplates.completed_deed_limits = {
	10,
	25,
	50,
	100,
	200,
	300,
	400,
	500
}

for i, v in ipairs(AchievementTemplates.completed_deed_limits) do
	local str = "complete_deeds_" .. i

	AchievementTemplates.achievements[str] = {
		name = "achv_complete_deeds_" .. i .. "_name",
		desc = function ()
			-- function 153
			return string.format(Localize("achv_complete_deeds_desc"), v)
		end,
		icon = "achievement_trophy_deeds_" .. i,
		completed = function (self, arg_154_1)
			-- function 154
			return self:get_persistent_stat(arg_154_1, "completed_heroic_deeds") >= v
		end,
		progress = function (self, arg_155_1)
			-- function 155
			local get_persistent_stat = self:get_persistent_stat(arg_155_1, "completed_heroic_deeds")
			local min = math.min(get_persistent_stat, v)

			return {
				min,
				v
			}
		end
	}
end

AchievementTemplates.difficulties = {
	"normal",
	"hard",
	"harder",
	"hardest"
}

for i_2, v_2 in ipairs(AchievementTemplates.difficulties) do
	local var_0_17 = DifficultyMapping[v_2]
	local str_2 = "complete_all_helmgart_levels_" .. var_0_17

	AchievementTemplates.achievements[str_2] = {
		name = "achv_complete_all_helmgart_levels_" .. var_0_17 .. "_name",
		desc = "achv_complete_all_helmgart_levels_" .. var_0_17 .. "_desc",
		icon = "achievement_trophy_complete_all_helmgart_levels_" .. var_0_17,
		completed = function (arg_156_0, arg_156_1)
			-- function 156
			return check_level_list_difficulty(arg_156_0, arg_156_1, var_0_14, var_0_5[v_2].rank)
		end,
		progress = function (arg_157_0, arg_157_1)
			-- function 157
			local num = 0

			for i, v in ipairs(var_0_14) do
				if not check_level_difficulty(arg_157_0, arg_157_1, v, var_0_5[v_2].rank) then
					num = num + 1
				end
			end

			return {
				num,
				#var_0_14
			}
		end,
		requirements = function (arg_158_0, arg_158_1)
			-- function 158
			local tbl = {}

			for i, v in ipairs(var_0_14) do
				local var_158_1 = check_level_difficulty(arg_158_0, arg_158_1, v, var_0_5[v_2].rank)

				table.insert(tbl, {
					name = var_0_1[v].display_name,
					completed = var_158_1
				})
			end

			return tbl
		end
	}
end

local tbl_2 = {}

for i_3, v_3 in ipairs(SPProfiles) do
	if v_3.affiliation == "heroes" then
		for i_4, v_4 in ipairs(v_3.careers) do
			tbl_2[#tbl_2 + 1] = v_4.name
		end
	end
end

AchievementTemplates.hero_careers = tbl_2

for i_5, v_5 in ipairs(tbl_2) do
	fassert(CareerSettings[v_5] ~= nil, "No career with such name (%s)", v_5)

	for i_6, v_6 in ipairs(AchievementTemplates.difficulties) do
		local var_0_20 = DifficultyMapping[v_6]
		local str_3 = "complete_all_helmgart_levels_" .. var_0_20 .. "_" .. v_5

		AchievementTemplates.achievements[str_3] = {
			name = "achv_complete_all_helmgart_levels_" .. var_0_20 .. "_" .. v_5 .. "_name",
			desc = "achv_complete_all_helmgart_levels_" .. var_0_20 .. "_" .. v_5 .. "_desc",
			icon = "achievement_trophy_" .. var_0_20 .. "_" .. v_5,
			completed = function (arg_159_0, arg_159_1)
				-- function 159
				return check_level_list_difficulty(arg_159_0, arg_159_1, var_0_14, var_0_5[v_6].rank, v_5)
			end,
			progress = function (arg_160_0, arg_160_1)
				-- function 160
				local num = 0

				for i, v in ipairs(var_0_14) do
					if not check_level_difficulty(arg_160_0, arg_160_1, v, var_0_5[v_6].rank, v_5) then
						num = num + 1
					end
				end

				return {
					num,
					#var_0_14
				}
			end,
			requirements = function (arg_161_0, arg_161_1)
				-- function 161
				local tbl = {}

				for i, v in ipairs(var_0_14) do
					local var_161_1 = check_level_difficulty(arg_161_0, arg_161_1, v, var_0_5[v_6].rank, v_5)

					table.insert(tbl, {
						name = var_0_1[v].display_name,
						completed = var_161_1
					})
				end

				return tbl
			end
		}
	end
end

for i_7, v_7 in ipairs(AchievementTemplates.difficulties) do
	local var_0_22 = DifficultyMapping[v_7]
	local str_4 = "complete_all_helmgart_levels_all_careers_" .. var_0_22

	AchievementTemplates.achievements[str_4] = {
		name = "achv_complete_all_helmgart_levels_all_careers_" .. var_0_22 .. "_name",
		desc = "achv_complete_all_helmgart_levels_all_careers_" .. var_0_22 .. "_desc",
		icon = "achievement_trophy_all_careers_" .. var_0_22,
		completed = function (arg_162_0, arg_162_1)
			-- function 162
			for i, v in ipairs(tbl_2) do
				if not check_level_list_difficulty(arg_162_0, arg_162_1, var_0_14, var_0_5[v_7].rank, v) then
					return false
				end
			end

			return true
		end,
		progress = function (arg_163_0, arg_163_1)
			-- function 163
			local num = 0
			local num_2 = 0

			for i, v in ipairs(tbl_2) do
				num_2 = num_2 + 1

				if not check_level_list_difficulty(arg_163_0, arg_163_1, var_0_14, var_0_5[v_7].rank, v) then
					num = num + 1
				end
			end

			return {
				num,
				num_2
			}
		end,
		requirements = function (arg_164_0, arg_164_1)
			-- function 164
			local tbl = {}

			for i, v in ipairs(tbl_2) do
				local var_164_1 = check_level_list_difficulty(arg_164_0, arg_164_1, var_0_14, var_0_5[v_7].rank, v)

				table.insert(tbl, {
					name = v,
					completed = var_164_1
				})
			end

			return tbl
		end
	}
end

for i_8, v_8 in ipairs(tbl_2) do
	fassert(CareerSettings[v_8] ~= nil, "No such career (%s)", v_8)

	local str_5 = "complete_100_missions_champion_" .. v_8

	AchievementTemplates.achievements[str_5] = {
		name = "achv_complete_100_missions_champion_" .. v_8 .. "_name",
		desc = "achv_complete_100_missions_champion_" .. v_8 .. "_desc",
		icon = "achievement_trophy_100_missions_champion_" .. v_8,
		completed = function (self, arg_165_1)
			-- function 165
			local num = 0

			for i, v in ipairs(var_0_4) do
				num = num + self:get_persistent_stat(arg_165_1, "completed_career_levels", v_8, v, "harder")
				num = num + self:get_persistent_stat(arg_165_1, "completed_career_levels", v_8, v, "hardest")
				num = num + self:get_persistent_stat(arg_165_1, "completed_career_levels", v_8, v, "cataclysm")
			end

			return num >= 100
		end,
		progress = function (self, arg_166_1)
			-- function 166
			local num = 0

			for i, v in ipairs(var_0_4) do
				num = num + self:get_persistent_stat(arg_166_1, "completed_career_levels", v_8, v, "harder")
				num = num + self:get_persistent_stat(arg_166_1, "completed_career_levels", v_8, v, "hardest")
				num = num + self:get_persistent_stat(arg_166_1, "completed_career_levels", v_8, v, "cataclysm")
			end

			if num > 100 then
				num = 100
			end

			return {
				num,
				100
			}
		end
	}
end

AchievementTemplates.achievements.elven_ruins_align_leylines_timed = {
	ID_XB1 = 28,
	ID_PS4 = "027",
	name = "achv_elven_ruins_align_leylines_timed_name",
	display_completion_ui = true,
	icon = "achievement_trophy_elven_ruins_align_leylines_timed",
	desc = function ()
		-- function 167
		return string.format(Localize("achv_elven_ruins_align_leylines_timed_desc"), QuestSettings.elven_ruins_speed_event)
	end,
	completed = function (self, arg_168_1)
		-- function 168
		return self:get_persistent_stat(arg_168_1, "elven_ruins_speed_event") > 0
	end
}
AchievementTemplates.achievements.farmlands_rescue_prisoners_timed = {
	ID_XB1 = 29,
	ID_PS4 = "028",
	name = "achv_farmlands_rescue_prisoners_timed_name",
	display_completion_ui = true,
	icon = "achievement_trophy_farmlands_rescue_prisoners_timed",
	desc = function ()
		-- function 169
		return string.format(Localize("achv_farmlands_rescue_prisoners_timed_desc"), QuestSettings.farmlands_speed_event)
	end,
	completed = function (self, arg_170_1)
		-- function 170
		return self:get_persistent_stat(arg_170_1, "farmlands_speed_event") > 0
	end
}
AchievementTemplates.achievements.military_kill_chaos_warriors_in_event = {
	ID_XB1 = 30,
	ID_PS4 = "029",
	name = "achv_military_kill_chaos_warriors_in_event_name",
	display_completion_ui = true,
	icon = "achievement_trophy_military_kill_chaos_warriors_in_event",
	desc = function ()
		-- function 171
		return string.format(Localize("achv_military_kill_chaos_warriors_in_event_desc"), 3)
	end,
	completed = function (self, arg_172_1)
		-- function 172
		return self:get_persistent_stat(arg_172_1, "military_statue_kill_chaos_warriors") > 0
	end
}
AchievementTemplates.achievements.ground_zero_burblespew_tornado_enemies = {
	ID_XB1 = 31,
	ID_PS4 = "030",
	name = "achv_ground_zero_burblespew_tornado_enemies_name",
	display_completion_ui = true,
	icon = "achievement_trophy_ground_zero_burblespew_tornado_enemies",
	desc = function ()
		-- function 173
		return string.format(Localize("achv_ground_zero_burblespew_tornado_enemies_desc"), QuestSettings.halescourge_tornado_enemies_cata)
	end,
	completed = function (self, arg_174_1)
		-- function 174
		return self:get_persistent_stat(arg_174_1, "halescourge_tornado_enemies") > 0
	end
}
AchievementTemplates.achievements.fort_kill_enemies_cannonball = {
	ID_XB1 = 32,
	ID_PS4 = "031",
	name = "achv_fort_kill_enemies_cannonball_name",
	display_completion_ui = true,
	icon = "achievement_trophy_fort_kill_enemies_cannonball",
	desc = function ()
		-- function 175
		return string.format(Localize("achv_fort_kill_enemies_cannonball_desc"), QuestSettings.forest_fort_kill_cannonball)
	end,
	completed = function (self, arg_176_1)
		-- function 176
		return self:get_persistent_stat(arg_176_1, "forest_fort_kill_cannonball") > 0
	end
}
AchievementTemplates.achievements.nurgle_player_showered_in_pus = {
	ID_XB1 = 33,
	ID_PS4 = "032",
	name = "achv_nurgle_player_showered_in_pus_name",
	display_completion_ui = true,
	icon = "achievement_trophy_nurgle_player_showered_in_pus",
	desc = function ()
		-- function 177
		return string.format(Localize("achv_nurgle_player_showered_in_pus_desc"), QuestSettings.nurgle_bathed_all_cata)
	end,
	completed = function (self, arg_178_1)
		-- function 178
		return self:get_persistent_stat(arg_178_1, "nurgle_bathed_all") > 0
	end
}
AchievementTemplates.achievements.bell_destroy_bell_flee_timed = {
	ID_XB1 = 34,
	ID_PS4 = "033",
	name = "achv_bell_destroy_bell_flee_timed_name",
	display_completion_ui = true,
	icon = "achievement_trophy_bell_destroy_bell_flee_timed",
	desc = function ()
		-- function 179
		return string.format(Localize("achv_bell_destroy_bell_flee_timed_desc"), QuestSettings.bell_speed_event)
	end,
	completed = function (self, arg_180_1)
		-- function 180
		return self:get_persistent_stat(arg_180_1, "bell_speed_event") > 0
	end
}
AchievementTemplates.achievements.catacombs_stay_inside_ritual_pool = {
	ID_XB1 = 35,
	ID_PS4 = "034",
	name = "achv_catacombs_stay_inside_ritual_pool_name",
	display_completion_ui = true,
	icon = "achievement_trophy_catacombs_stay_inside_ritual_pool",
	desc = function ()
		-- function 181
		return string.format(Localize("achv_catacombs_stay_inside_ritual_pool_desc"), QuestSettings.volume_corpse_pit_damage)
	end,
	completed = function (self, arg_182_1)
		-- function 182
		return self:get_persistent_stat(arg_182_1, "catacombs_added_souls") > 0
	end
}
AchievementTemplates.achievements.mines_kill_final_troll_timed = {
	ID_XB1 = 36,
	ID_PS4 = "035",
	name = "achv_mines_kill_final_troll_timed_name",
	display_completion_ui = true,
	icon = "achievement_trophy_mines_kill_final_troll_timed",
	desc = function ()
		-- function 183
		return string.format(Localize("achv_mines_kill_final_troll_timed_desc"), QuestSettings.mines_speed_event)
	end,
	completed = function (self, arg_184_1)
		-- function 184
		return self:get_persistent_stat(arg_184_1, "mines_speed_event") > 0
	end
}
AchievementTemplates.achievements.warcamp_bodvarr_charge_warriors = {
	ID_XB1 = 37,
	ID_PS4 = "036",
	name = "achv_warcamp_bodvarr_charge_warriors_name",
	display_completion_ui = true,
	icon = "achievement_trophy_warcamp_bodvarr_charge_warriors",
	desc = function ()
		-- function 185
		return string.format(Localize("achv_warcamp_bodvarr_charge_warriors_desc"), QuestSettings.exalted_champion_charge_chaos_warrior)
	end,
	completed = function (self, arg_186_1)
		-- function 186
		return self:get_persistent_stat(arg_186_1, "exalted_champion_charge_chaos_warrior") > 0
	end
}
AchievementTemplates.achievements.skaven_stronghold_skarrik_kill_skaven = {
	ID_XB1 = 38,
	ID_PS4 = "037",
	name = "achv_skaven_stronghold_skarrik_kill_skaven_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_stronghold_skarrik_kill_skaven",
	desc = function ()
		-- function 187
		return string.format(Localize("achv_skaven_stronghold_skarrik_kill_skaven_desc"), QuestSettings.storm_vermin_warlord_kills_enemies)
	end,
	completed = function (self, arg_188_1)
		-- function 188
		return self:get_persistent_stat(arg_188_1, "storm_vermin_warlord_kills_enemies") > 0
	end
}
AchievementTemplates.achievements.ussingen_no_event_barrels = {
	ID_XB1 = 39,
	ID_PS4 = "038",
	name = "achv_ussingen_no_event_barrels_name",
	display_completion_ui = true,
	icon = "achievement_trophy_ussingen_no_event_barrels",
	desc = "achv_ussingen_no_event_barrels_desc",
	completed = function (self, arg_189_1)
		-- function 189
		return self:get_persistent_stat(arg_189_1, "ussingen_used_no_barrels") > 0
	end
}
AchievementTemplates.achievements.skittergate_deathrattler_rasknitt_timed = {
	ID_XB1 = 40,
	ID_PS4 = "039",
	name = "achv_skittergate_deathrattler_rasknitt_timed_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skittergate_deathrattler_rasknitt_timed",
	desc = function ()
		-- function 190
		return string.format(Localize("achv_skittergate_deathrattler_rasknitt_timed_desc"), QuestSettings.skittergate_speed_event)
	end,
	completed = function (self, arg_191_1)
		-- function 191
		return self:get_persistent_stat(arg_191_1, "skittergate_speed_event") > 0
	end
}

local tbl_3 = {
	achv_elven_ruins_align_leylines_timed_name = "elven_ruins_speed_event",
	achv_farmlands_rescue_prisoners_timed_name = "farmlands_speed_event",
	achv_nurgle_player_showered_in_pus_name = "nurgle_bathed_all",
	achv_catacombs_stay_inside_ritual_pool_name = "catacombs_added_souls",
	achv_mines_kill_final_troll_timed_name = "mines_speed_event",
	achv_fort_kill_enemies_cannonball_name = "forest_fort_kill_cannonball",
	achv_skaven_stronghold_skarrik_kill_skaven_name = "storm_vermin_warlord_kills_enemies",
	achv_skittergate_deathrattler_rasknitt_timed_name = "skittergate_speed_event",
	achv_military_kill_chaos_warriors_in_event_name = "military_statue_kill_chaos_warriors",
	achv_ground_zero_burblespew_tornado_enemies_name = "halescourge_tornado_enemies",
	achv_warcamp_bodvarr_charge_warriors_name = "exalted_champion_charge_chaos_warrior",
	achv_ussingen_no_event_barrels_name = "ussingen_used_no_barrels",
	achv_bell_destroy_bell_flee_timed_name = "bell_speed_event"
}

AchievementTemplates.achievements.complete_all_helmgart_level_achievements = {
	ID_XB1 = 41,
	ID_PS4 = "040",
	name = "achv_complete_all_helmgart_level_achievements_name",
	icon = "achievement_trophy_complete_all_helmgart_level_achievements",
	desc = "achv_complete_all_helmgart_level_achievements_desc",
	completed = function (self, arg_192_1)
		-- function 192
		for k, v in pairs(tbl_3) do
			if not (self:get_persistent_stat(arg_192_1, v) > 0) then
				return false
			end
		end

		return true
	end,
	progress = function (self, arg_193_1)
		-- function 193
		local num = 0
		local num_2 = 0

		for k, v in pairs(tbl_3) do
			num_2 = num_2 + 1

			if not (self:get_persistent_stat(arg_193_1, v) > 0) then
				num = num + 1
			end
		end

		return {
			num,
			num_2
		}
	end,
	requirements = function (self, arg_194_1)
		-- function 194
		local tbl = {}

		for k, v in pairs(tbl_3) do
			local flag = self:get_persistent_stat(arg_194_1, v) > 0

			table.insert(tbl, {
				name = k,
				completed = flag
			})
		end

		return tbl
	end
}
AchievementTemplates.achievements.skaven_warpfire_thrower_1 = {
	ID_XB1 = 42,
	name = "achv_skaven_warpfire_thrower_1_name",
	ID_PS4 = "041",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_warpfire_thrower_1",
	desc = "achv_skaven_warpfire_thrower_1_desc",
	completed = function (self, arg_195_1)
		-- function 195
		return self:get_persistent_stat(arg_195_1, "warpfire_kill_before_shooting") > 0
	end
}
AchievementTemplates.achievements.skaven_warpfire_thrower_2 = {
	ID_XB1 = 43,
	name = "achv_skaven_warpfire_thrower_2_name",
	ID_PS4 = "042",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_warpfire_thrower_2",
	desc = "achv_skaven_warpfire_thrower_2_desc",
	completed = function (self, arg_196_1)
		-- function 196
		return self:get_persistent_stat(arg_196_1, "warpfire_kill_on_power_cell") > 0
	end
}
AchievementTemplates.achievements.skaven_warpfire_thrower_3 = {
	name = "achv_skaven_warpfire_thrower_3_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_warpfire_thrower_3",
	desc = function ()
		-- function 197
		return string.format(Localize("achv_skaven_warpfire_thrower_3_desc"), QuestSettings.num_enemies_killed_by_warpfire)
	end,
	completed = function (self, arg_198_1)
		-- function 198
		return self:get_persistent_stat(arg_198_1, "warpfire_enemies_killed_by_warpfire") > 0
	end
}
AchievementTemplates.achievements.skaven_pack_master_1 = {
	ID_XB1 = 44,
	name = "achv_skaven_pack_master_1_name",
	ID_PS4 = "043",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_pack_master_1",
	desc = "achv_skaven_pack_master_1_desc",
	completed = function (self, arg_199_1)
		-- function 199
		return self:get_persistent_stat(arg_199_1, "pack_master_kill_abducting_ally") > 0
	end
}
AchievementTemplates.achievements.skaven_pack_master_2 = {
	ID_XB1 = 45,
	name = "achv_skaven_pack_master_2_name",
	ID_PS4 = "044",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_pack_master_2",
	desc = "achv_skaven_pack_master_2_desc",
	completed = function (self, arg_200_1)
		-- function 200
		return self:get_persistent_stat(arg_200_1, "pack_master_dodged_attack") > 0
	end
}
AchievementTemplates.achievements.skaven_pack_master_3 = {
	name = "achv_skaven_pack_master_3_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_pack_master_3",
	desc = "achv_skaven_pack_master_3_desc",
	completed = function (self, arg_201_1)
		-- function 201
		return self:get_persistent_stat(arg_201_1, "pack_master_rescue_hoisted_ally") > 0
	end
}
AchievementTemplates.achievements.skaven_gutter_runner_1 = {
	ID_XB1 = 46,
	name = "achv_skaven_gutter_runner_1_name",
	ID_PS4 = "045",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_gutter_runner_1",
	desc = "achv_skaven_gutter_runner_1_desc",
	completed = function (self, arg_202_1)
		-- function 202
		return self:get_persistent_stat(arg_202_1, "gutter_runner_killed_on_pounce") > 0
	end
}
AchievementTemplates.achievements.skaven_gutter_runner_2 = {
	name = "achv_skaven_gutter_runner_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_gutter_runner_2",
	desc = "achv_skaven_gutter_runner_2_desc",
	completed = function (self, arg_203_1)
		-- function 203
		return self:get_persistent_stat(arg_203_1, "gutter_runner_push_on_target_pounced") > 0
	end
}
AchievementTemplates.achievements.skaven_gutter_runner_3 = {
	name = "achv_skaven_gutter_runner_3_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_gutter_runner_3",
	desc = "achv_skaven_gutter_runner_3_desc",
	completed = function (self, arg_204_1)
		-- function 204
		return self:get_persistent_stat(arg_204_1, "gutter_runner_push_on_pounce") > 0
	end
}
AchievementTemplates.achievements.skaven_poison_wind_globardier_1 = {
	ID_XB1 = 47,
	name = "achv_skaven_poison_wind_globardier_1_name",
	ID_PS4 = "046",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_poison_wind_globardier_1",
	desc = "achv_skaven_poison_wind_globardier_1_desc",
	completed = function (self, arg_205_1)
		-- function 205
		return self:get_persistent_stat(arg_205_1, "globadier_kill_during_suicide") > 0
	end
}
AchievementTemplates.achievements.skaven_poison_wind_globardier_2 = {
	name = "achv_skaven_poison_wind_globardier_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_poison_wind_globardier_2",
	desc = "achv_skaven_poison_wind_globardier_2_desc",
	completed = function (self, arg_206_1)
		-- function 206
		return self:get_persistent_stat(arg_206_1, "globadier_kill_before_throwing") > 0
	end
}
AchievementTemplates.achievements.skaven_poison_wind_globardier_3 = {
	name = "achv_skaven_poison_wind_globardier_3_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_poison_wind_globardier_3",
	desc = function ()
		-- function 207
		return string.format(Localize("achv_skaven_poison_wind_globardier_3_desc"), QuestSettings.num_enemies_killed_by_poison)
	end,
	completed = function (self, arg_208_1)
		-- function 208
		return self:get_persistent_stat(arg_208_1, "globadier_enemies_killed_by_poison") > 0
	end
}
AchievementTemplates.achievements.skaven_ratling_gunner_1 = {
	ID_XB1 = 48,
	name = "achv_skaven_ratling_gunner_1_name",
	ID_PS4 = "047",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_ratling_gunner_1",
	desc = "achv_skaven_ratling_gunner_1_desc",
	completed = function (self, arg_209_1)
		-- function 209
		return self:get_persistent_stat(arg_209_1, "ratling_gunner_killed_by_melee") > 0
	end
}
AchievementTemplates.achievements.skaven_ratling_gunner_2 = {
	name = "achv_skaven_ratling_gunner_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_ratling_gunner_2",
	desc = "achv_skaven_ratling_gunner_2_desc",
	completed = function (self, arg_210_1)
		-- function 210
		return self:get_persistent_stat(arg_210_1, "ratling_gunner_killed_while_shooting") > 0
	end
}
AchievementTemplates.achievements.skaven_ratling_gunner_3 = {
	name = "achv_skaven_ratling_gunner_3_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_ratling_gunner_3",
	desc = "achv_skaven_ratling_gunner_3_desc",
	events = {
		"player_blocked_attack"
	},
	completed = function (self, arg_211_1)
		-- function 211
		return self:get_persistent_stat(arg_211_1, "ratling_gunner_blocked_shot") > 0
	end,
	on_event = function (self, arg_212_1, arg_212_2, arg_212_3, arg_212_4)
		-- function 212
		if not arg_212_4[1].local_player then
			return
		end

		local var_212_0 = arg_212_4[2]
		local alive = Unit.alive(var_212_0)

		alive = not alive and Unit.get_data(var_212_0, "breed")

		if not (not alive and alive.name ~= "skaven_ratling_gunner") then
			self:increment_stat(arg_212_1, "ratling_gunner_blocked_shot")
		end
	end
}
AchievementTemplates.achievements.chaos_corruptor_sorcerer_1 = {
	ID_XB1 = 49,
	name = "achv_chaos_corruptor_sorcerer_1_name",
	ID_PS4 = "048",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_corruptor_sorcerer_1",
	desc = "achv_chaos_corruptor_sorcerer_1_desc",
	completed = function (self, arg_213_1)
		-- function 213
		return self:get_persistent_stat(arg_213_1, "corruptor_dodged_attack") > 0
	end
}
AchievementTemplates.achievements.chaos_corruptor_sorcerer_2 = {
	name = "achv_chaos_corruptor_sorcerer_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_corruptor_sorcerer_2",
	desc = function ()
		-- function 214
		return string.format(Localize("achv_chaos_corruptor_sorcerer_2_desc"), QuestSettings.corruptor_killed_at_teleport_time)
	end,
	completed = function (self, arg_215_1)
		-- function 215
		return self:get_persistent_stat(arg_215_1, "corruptor_killed_at_teleport_time") > 0
	end
}
AchievementTemplates.achievements.chaos_corruptor_sorcerer_3 = {
	ID_XB1 = 50,
	name = "achv_chaos_corruptor_sorcerer_3_name",
	ID_PS4 = "049",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_corruptor_sorcerer_3",
	desc = "achv_chaos_corruptor_sorcerer_3_desc",
	completed = function (self, arg_216_1)
		-- function 216
		return self:get_persistent_stat(arg_216_1, "corruptor_killed_while_grabbing") > 0
	end
}
AchievementTemplates.achievements.chaos_vortex_sorcerer_1 = {
	ID_XB1 = 51,
	name = "achv_chaos_vortex_sorcerer_1_name",
	ID_PS4 = "050",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_vortex_sorcerer_1",
	desc = "achv_chaos_vortex_sorcerer_1_desc",
	completed = function (self, arg_217_1)
		-- function 217
		return self:get_persistent_stat(arg_217_1, "vortex_sorcerer_killed_while_summoning") > 0
	end
}
AchievementTemplates.achievements.chaos_vortex_sorcerer_2 = {
	name = "achv_chaos_vortex_sorcerer_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_vortex_sorcerer_2",
	desc = "achv_chaos_vortex_sorcerer_2_desc",
	completed = function (self, arg_218_1)
		-- function 218
		return self:get_persistent_stat(arg_218_1, "vortex_sorcerer_killed_while_ally_in_vortex") > 0
	end
}
AchievementTemplates.achievements.chaos_vortex_sorcerer_3 = {
	name = "achv_chaos_vortex_sorcerer_3_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_vortex_sorcerer_3",
	desc = "achv_chaos_vortex_sorcerer_3_desc",
	completed = function (self, arg_219_1)
		-- function 219
		return self:get_persistent_stat(arg_219_1, "vortex_sorcerer_killed_by_melee") > 0
	end
}
AchievementTemplates.achievements.chaos_spawn_1 = {
	name = "achv_chaos_spawn_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_spawn_1",
	desc = "achv_chaos_spawn_1_desc",
	completed = function (self, arg_220_1)
		-- function 220
		return self:get_persistent_stat(arg_220_1, "chaos_spawn_killed_while_grabbing") > 0
	end
}
AchievementTemplates.achievements.chaos_spawn_2 = {
	name = "achv_chaos_spawn_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_spawn_2",
	desc = "achv_chaos_spawn_2_desc",
	completed = function (self, arg_221_1)
		-- function 221
		return self:get_persistent_stat(arg_221_1, "chaos_spawn_killed_without_having_grabbed") > 0
	end
}
AchievementTemplates.achievements.chaos_troll_1 = {
	name = "achv_chaos_troll_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_troll_1",
	desc = "achv_chaos_troll_1_desc",
	completed = function (self, arg_222_1)
		-- function 222
		return self:get_persistent_stat(arg_222_1, "chaos_troll_killed_without_regen") > 0
	end
}
AchievementTemplates.achievements.chaos_troll_2 = {
	name = "achv_chaos_troll_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_troll_2",
	desc = "achv_chaos_troll_2_desc",
	completed = function (self, arg_223_1)
		-- function 223
		return self:get_persistent_stat(arg_223_1, "chaos_troll_killed_without_bile_damage") > 0
	end
}
AchievementTemplates.achievements.skaven_rat_ogre_1 = {
	name = "achv_skaven_rat_ogre_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_rat_ogre_1",
	desc = "achv_skaven_rat_ogre_1_desc",
	completed = function (self, arg_224_1)
		-- function 224
		return self:get_persistent_stat(arg_224_1, "rat_ogre_killed_mid_leap") > 0
	end
}
AchievementTemplates.achievements.skaven_rat_ogre_2 = {
	name = "achv_skaven_rat_ogre_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_rat_ogre_2",
	desc = "achv_skaven_rat_ogre_2_desc",
	completed = function (self, arg_225_1)
		-- function 225
		return self:get_persistent_stat(arg_225_1, "rat_ogre_killed_without_dealing_damage") > 0
	end
}
AchievementTemplates.achievements.skaven_stormfiend_1 = {
	name = "achv_skaven_stormfiend_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_stormfiend_1",
	desc = "achv_skaven_stormfiend_1_desc",
	completed = function (self, arg_226_1)
		-- function 226
		return self:get_persistent_stat(arg_226_1, "stormfiend_killed_without_burn_damage") > 0
	end
}
AchievementTemplates.achievements.skaven_stormfiend_2 = {
	name = "achv_skaven_stormfiend_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_stormfiend_2",
	desc = "achv_skaven_stormfiend_2_desc",
	completed = function (self, arg_227_1)
		-- function 227
		return self:get_persistent_stat(arg_227_1, "stormfiend_killed_on_controller") > 0
	end
}
AchievementTemplates.achievements.helmgart_lord_1 = {
	name = "achv_helmgart_lord_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_helmgart_lord_1",
	desc = "achv_helmgart_lord_1_desc",
	completed = function (self, arg_228_1)
		-- function 228
		return self:get_persistent_stat(arg_228_1, "killed_lord_as_last_player_standing") > 0
	end
}

DLCUtils.map_list("achievement_template_file_names", local_require)

for i_9, v_9 in ipairs(AchievementTemplates.difficulties) do
	local var_0_26 = DifficultyMapping[v_9]
	local str_6 = "kill_bodvarr_burblespew_" .. var_0_26
	local rank = var_0_5[v_9].rank

	AchievementTemplates.achievements[str_6] = {
		name = "achv_kill_bodvarr_burblespew_" .. var_0_26 .. "_name",
		desc = "achv_kill_bodvarr_burblespew_" .. var_0_26 .. "_desc",
		icon = "achievement_trophy_kill_bodvarr_burblespew_" .. var_0_26,
		completed = function (self, arg_229_1)
			-- function 229
			local flag = self:get_persistent_stat(arg_229_1, "kill_chaos_exalted_champion_difficulty_rank") >= rank
			local flag_2 = self:get_persistent_stat(arg_229_1, "kill_chaos_exalted_sorcerer_difficulty_rank") >= rank

			return not flag and flag_2
		end,
		requirements = function (self, arg_230_1)
			-- function 230
			local flag = self:get_persistent_stat(arg_230_1, "kill_chaos_exalted_champion_difficulty_rank") >= rank
			local flag_2 = self:get_persistent_stat(arg_230_1, "kill_chaos_exalted_sorcerer_difficulty_rank") >= rank

			return {
				{
					name = "chaos_exalted_champion",
					completed = flag
				},
				{
					name = "chaos_exalted_sorcerer",
					completed = flag_2
				}
			}
		end
	}

	local str_7 = "kill_skarrik_rasknitt_" .. var_0_26

	AchievementTemplates.achievements[str_7] = {
		name = "achv_kill_skarrik_rasknitt_" .. var_0_26 .. "_name",
		desc = "achv_kill_skarrik_rasknitt_" .. var_0_26 .. "_desc",
		icon = "achievement_trophy_kill_skarrik_rasknitt_" .. var_0_26,
		completed = function (self, arg_231_1)
			-- function 231
			local flag = self:get_persistent_stat(arg_231_1, "kill_skaven_grey_seer_difficulty_rank") >= rank
			local flag_2 = self:get_persistent_stat(arg_231_1, "kill_skaven_storm_vermin_warlord_difficulty_rank") >= rank

			return not flag and flag_2
		end,
		requirements = function (self, arg_232_1)
			-- function 232
			local flag = self:get_persistent_stat(arg_232_1, "kill_skaven_grey_seer_difficulty_rank") >= rank
			local flag_2 = self:get_persistent_stat(arg_232_1, "kill_skaven_storm_vermin_warlord_difficulty_rank") >= rank

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
end

for k, v_10 in pairs(AchievementTemplates.achievements) do
	v_10.id = k
end

return AchievementTemplates
