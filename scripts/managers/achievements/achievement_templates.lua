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

local var_0_6 = AchievementTemplateHelper.check_level
local var_0_7 = AchievementTemplateHelper.check_level_difficulty
local var_0_8 = AchievementTemplateHelper.check_level_list
local var_0_9 = AchievementTemplateHelper.check_level_list_difficulty
local var_0_10 = AchievementTemplateHelper.hero_level
local var_0_11 = AchievementTemplateHelper.equipped_items_of_rarity
local var_0_12 = AchievementTemplateHelper.rarity_index
local var_0_13 = 84

AchievementTemplates.end_of_level_achievement_evaluations = {
	no_ratling_damage = {
		stat_to_increment = "bogenhafen_slum_no_ratling_damage",
		levels = {
			"dlc_bogenhafen_slum"
		},
		evaluation_func = function (arg_1_0, arg_1_1)
			return arg_1_0:get_stat(arg_1_1, "damage_taken_from_ratling_gunner") == 0
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
		return var_0_8(arg_2_0, arg_2_1, {
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
		return var_0_2.act_completed(arg_3_0, arg_3_1, "act_1")
	end,
	progress = function (arg_4_0, arg_4_1)
		local var_4_0 = 0

		if var_0_6(arg_4_0, arg_4_1, var_0_1.military.level_id) then
			var_4_0 = var_4_0 + 1
		end

		if var_0_6(arg_4_0, arg_4_1, var_0_1.catacombs.level_id) then
			var_4_0 = var_4_0 + 1
		end

		if var_0_6(arg_4_0, arg_4_1, var_0_1.mines.level_id) then
			var_4_0 = var_4_0 + 1
		end

		if var_0_6(arg_4_0, arg_4_1, var_0_1.ground_zero.level_id) then
			var_4_0 = var_4_0 + 1
		end

		return {
			var_4_0,
			4
		}
	end,
	requirements = function (arg_5_0, arg_5_1)
		local var_5_0 = var_0_6(arg_5_0, arg_5_1, var_0_1.military.level_id)
		local var_5_1 = var_0_6(arg_5_0, arg_5_1, var_0_1.catacombs.level_id)
		local var_5_2 = var_0_6(arg_5_0, arg_5_1, var_0_1.mines.level_id)
		local var_5_3 = var_0_6(arg_5_0, arg_5_1, var_0_1.ground_zero.level_id)

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
		local var_6_0 = 0
		local var_6_1 = var_0_5.hard.rank

		if var_0_7(arg_6_0, arg_6_1, var_0_1.military.level_id, var_6_1) then
			var_6_0 = var_6_0 + 1
		end

		if var_0_7(arg_6_0, arg_6_1, var_0_1.catacombs.level_id, var_6_1) then
			var_6_0 = var_6_0 + 1
		end

		if var_0_7(arg_6_0, arg_6_1, var_0_1.mines.level_id, var_6_1) then
			var_6_0 = var_6_0 + 1
		end

		if var_0_7(arg_6_0, arg_6_1, var_0_1.ground_zero.level_id, var_6_1) then
			var_6_0 = var_6_0 + 1
		end

		return var_6_0 >= 4
	end,
	progress = function (arg_7_0, arg_7_1)
		local var_7_0 = 0
		local var_7_1 = var_0_5.hard.rank

		if var_0_7(arg_7_0, arg_7_1, var_0_1.military.level_id, var_7_1) then
			var_7_0 = var_7_0 + 1
		end

		if var_0_7(arg_7_0, arg_7_1, var_0_1.catacombs.level_id, var_7_1) then
			var_7_0 = var_7_0 + 1
		end

		if var_0_7(arg_7_0, arg_7_1, var_0_1.mines.level_id, var_7_1) then
			var_7_0 = var_7_0 + 1
		end

		if var_0_7(arg_7_0, arg_7_1, var_0_1.ground_zero.level_id, var_7_1) then
			var_7_0 = var_7_0 + 1
		end

		return {
			var_7_0,
			4
		}
	end,
	requirements = function (arg_8_0, arg_8_1)
		local var_8_0 = var_0_5.hard.rank
		local var_8_1 = var_0_7(arg_8_0, arg_8_1, var_0_1.military.level_id, var_8_0)
		local var_8_2 = var_0_7(arg_8_0, arg_8_1, var_0_1.catacombs.level_id, var_8_0)
		local var_8_3 = var_0_7(arg_8_0, arg_8_1, var_0_1.mines.level_id, var_8_0)
		local var_8_4 = var_0_7(arg_8_0, arg_8_1, var_0_1.ground_zero.level_id, var_8_0)

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
		local var_9_0 = 0
		local var_9_1 = var_0_5.normal.rank

		if var_0_7(arg_9_0, arg_9_1, var_0_1.dlc_bogenhafen_slum.level_id, var_9_1) then
			var_9_0 = var_9_0 + 1
		end

		return var_9_0 >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_slum_veteran = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_slum_veteran_name",
	icon = "achievement_trophy_bogenhafen_slum_veteran",
	desc = "achv_bogenhafen_slum_veteran_desc",
	completed = function (arg_10_0, arg_10_1)
		local var_10_0 = 0
		local var_10_1 = var_0_5.hard.rank

		if var_0_7(arg_10_0, arg_10_1, var_0_1.dlc_bogenhafen_slum.level_id, var_10_1) then
			var_10_0 = var_10_0 + 1
		end

		return var_10_0 >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_slum_champion = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_slum_champion_name",
	icon = "achievement_trophy_bogenhafen_slum_champion",
	desc = "achv_bogenhafen_slum_champion_desc",
	completed = function (arg_11_0, arg_11_1)
		local var_11_0 = 0
		local var_11_1 = var_0_5.harder.rank

		if var_0_7(arg_11_0, arg_11_1, var_0_1.dlc_bogenhafen_slum.level_id, var_11_1) then
			var_11_0 = var_11_0 + 1
		end

		return var_11_0 >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_slum_legend = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_slum_legend_name",
	icon = "achievement_trophy_bogenhafen_slum_legend",
	desc = "achv_bogenhafen_slum_legend_desc",
	completed = function (arg_12_0, arg_12_1)
		local var_12_0 = 0
		local var_12_1 = var_0_5.hardest.rank

		if var_0_7(arg_12_0, arg_12_1, var_0_1.dlc_bogenhafen_slum.level_id, var_12_1) then
			var_12_0 = var_12_0 + 1
		end

		return var_12_0 >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_city_recruit = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_city_recruit_name",
	icon = "achievement_trophy_bogenhafen_city_recruit",
	desc = "achv_bogenhafen_city_recruit_desc",
	completed = function (arg_13_0, arg_13_1)
		local var_13_0 = 0
		local var_13_1 = var_0_5.normal.rank

		if var_0_7(arg_13_0, arg_13_1, var_0_1.dlc_bogenhafen_city.level_id, var_13_1) then
			var_13_0 = var_13_0 + 1
		end

		return var_13_0 >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_city_veteran = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_city_veteran_name",
	icon = "achievement_trophy_bogenhafen_city_veteran",
	desc = "achv_bogenhafen_city_veteran_desc",
	completed = function (arg_14_0, arg_14_1)
		local var_14_0 = 0
		local var_14_1 = var_0_5.hard.rank

		if var_0_7(arg_14_0, arg_14_1, var_0_1.dlc_bogenhafen_city.level_id, var_14_1) then
			var_14_0 = var_14_0 + 1
		end

		return var_14_0 >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_city_champion = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_city_champion_name",
	icon = "achievement_trophy_bogenhafen_city_champion",
	desc = "achv_bogenhafen_city_champion_desc",
	completed = function (arg_15_0, arg_15_1)
		local var_15_0 = 0
		local var_15_1 = var_0_5.harder.rank

		if var_0_7(arg_15_0, arg_15_1, var_0_1.dlc_bogenhafen_city.level_id, var_15_1) then
			var_15_0 = var_15_0 + 1
		end

		return var_15_0 >= 1
	end
}
AchievementTemplates.achievements.complete_bogenhafen_city_legend = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_city_legend_name",
	icon = "achievement_trophy_bogenhafen_city_legend",
	desc = "achv_bogenhafen_city_legend_desc",
	completed = function (arg_16_0, arg_16_1)
		local var_16_0 = 0
		local var_16_1 = var_0_5.hardest.rank

		if var_0_7(arg_16_0, arg_16_1, var_0_1.dlc_bogenhafen_city.level_id, var_16_1) then
			var_16_0 = var_16_0 + 1
		end

		return var_16_0 >= 1
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
		local var_17_0 = 0
		local var_17_1 = var_0_5.normal.rank

		if var_0_7(arg_17_0, arg_17_1, var_0_1.dlc_bogenhafen_slum.level_id, var_17_1) then
			var_17_0 = var_17_0 + 1
		end

		if var_0_7(arg_17_0, arg_17_1, var_0_1.dlc_bogenhafen_city.level_id, var_17_1) then
			var_17_0 = var_17_0 + 1
		end

		return var_17_0 >= 2
	end,
	progress = function (arg_18_0, arg_18_1)
		local var_18_0 = 0
		local var_18_1 = var_0_5.normal.rank

		if var_0_7(arg_18_0, arg_18_1, var_0_1.dlc_bogenhafen_slum.level_id, var_18_1) then
			var_18_0 = var_18_0 + 1
		end

		if var_0_7(arg_18_0, arg_18_1, var_0_1.dlc_bogenhafen_city.level_id, var_18_1) then
			var_18_0 = var_18_0 + 1
		end

		return {
			var_18_0,
			2
		}
	end,
	requirements = function (arg_19_0, arg_19_1)
		local var_19_0 = var_0_5.normal.rank
		local var_19_1 = var_0_7(arg_19_0, arg_19_1, var_0_1.dlc_bogenhafen_slum.level_id, var_19_0)
		local var_19_2 = var_0_7(arg_19_0, arg_19_1, var_0_1.dlc_bogenhafen_city.level_id, var_19_0)

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
		local var_20_0 = 0
		local var_20_1 = var_0_5.hard.rank

		if var_0_7(arg_20_0, arg_20_1, var_0_1.dlc_bogenhafen_slum.level_id, var_20_1) then
			var_20_0 = var_20_0 + 1
		end

		if var_0_7(arg_20_0, arg_20_1, var_0_1.dlc_bogenhafen_city.level_id, var_20_1) then
			var_20_0 = var_20_0 + 1
		end

		return var_20_0 >= 2
	end,
	progress = function (arg_21_0, arg_21_1)
		local var_21_0 = 0
		local var_21_1 = var_0_5.hard.rank

		if var_0_7(arg_21_0, arg_21_1, var_0_1.dlc_bogenhafen_slum.level_id, var_21_1) then
			var_21_0 = var_21_0 + 1
		end

		if var_0_7(arg_21_0, arg_21_1, var_0_1.dlc_bogenhafen_city.level_id, var_21_1) then
			var_21_0 = var_21_0 + 1
		end

		return {
			var_21_0,
			2
		}
	end,
	requirements = function (arg_22_0, arg_22_1)
		local var_22_0 = var_0_5.hard.rank
		local var_22_1 = var_0_7(arg_22_0, arg_22_1, var_0_1.dlc_bogenhafen_slum.level_id, var_22_0)
		local var_22_2 = var_0_7(arg_22_0, arg_22_1, var_0_1.dlc_bogenhafen_city.level_id, var_22_0)

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
		local var_23_0 = 0
		local var_23_1 = var_0_5.harder.rank

		if var_0_7(arg_23_0, arg_23_1, var_0_1.dlc_bogenhafen_slum.level_id, var_23_1) then
			var_23_0 = var_23_0 + 1
		end

		if var_0_7(arg_23_0, arg_23_1, var_0_1.dlc_bogenhafen_city.level_id, var_23_1) then
			var_23_0 = var_23_0 + 1
		end

		return var_23_0 >= 2
	end,
	progress = function (arg_24_0, arg_24_1)
		local var_24_0 = 0
		local var_24_1 = var_0_5.harder.rank

		if var_0_7(arg_24_0, arg_24_1, var_0_1.dlc_bogenhafen_slum.level_id, var_24_1) then
			var_24_0 = var_24_0 + 1
		end

		if var_0_7(arg_24_0, arg_24_1, var_0_1.dlc_bogenhafen_city.level_id, var_24_1) then
			var_24_0 = var_24_0 + 1
		end

		return {
			var_24_0,
			2
		}
	end,
	requirements = function (arg_25_0, arg_25_1)
		local var_25_0 = var_0_5.harder.rank
		local var_25_1 = var_0_7(arg_25_0, arg_25_1, var_0_1.dlc_bogenhafen_slum.level_id, var_25_0)
		local var_25_2 = var_0_7(arg_25_0, arg_25_1, var_0_1.dlc_bogenhafen_city.level_id, var_25_0)

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
		local var_26_0 = 0
		local var_26_1 = var_0_5.hardest.rank

		if var_0_7(arg_26_0, arg_26_1, var_0_1.dlc_bogenhafen_slum.level_id, var_26_1) then
			var_26_0 = var_26_0 + 1
		end

		if var_0_7(arg_26_0, arg_26_1, var_0_1.dlc_bogenhafen_city.level_id, var_26_1) then
			var_26_0 = var_26_0 + 1
		end

		return var_26_0 >= 2
	end,
	progress = function (arg_27_0, arg_27_1)
		local var_27_0 = 0
		local var_27_1 = var_0_5.hardest.rank

		if var_0_7(arg_27_0, arg_27_1, var_0_1.dlc_bogenhafen_slum.level_id, var_27_1) then
			var_27_0 = var_27_0 + 1
		end

		if var_0_7(arg_27_0, arg_27_1, var_0_1.dlc_bogenhafen_city.level_id, var_27_1) then
			var_27_0 = var_27_0 + 1
		end

		return {
			var_27_0,
			2
		}
	end,
	requirements = function (arg_28_0, arg_28_1)
		local var_28_0 = var_0_5.hardest.rank
		local var_28_1 = var_0_7(arg_28_0, arg_28_1, var_0_1.dlc_bogenhafen_slum.level_id, var_28_0)
		local var_28_2 = var_0_7(arg_28_0, arg_28_1, var_0_1.dlc_bogenhafen_city.level_id, var_28_0)

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
		local var_29_0 = 0
		local var_29_1 = var_0_5.harder.rank

		if var_0_7(arg_29_0, arg_29_1, var_0_1.military.level_id, var_29_1) then
			var_29_0 = var_29_0 + 1
		end

		if var_0_7(arg_29_0, arg_29_1, var_0_1.catacombs.level_id, var_29_1) then
			var_29_0 = var_29_0 + 1
		end

		if var_0_7(arg_29_0, arg_29_1, var_0_1.mines.level_id, var_29_1) then
			var_29_0 = var_29_0 + 1
		end

		if var_0_7(arg_29_0, arg_29_1, var_0_1.ground_zero.level_id, var_29_1) then
			var_29_0 = var_29_0 + 1
		end

		return var_29_0 >= 4
	end,
	progress = function (arg_30_0, arg_30_1)
		local var_30_0 = 0
		local var_30_1 = var_0_5.harder.rank

		if var_0_7(arg_30_0, arg_30_1, var_0_1.military.level_id, var_30_1) then
			var_30_0 = var_30_0 + 1
		end

		if var_0_7(arg_30_0, arg_30_1, var_0_1.catacombs.level_id, var_30_1) then
			var_30_0 = var_30_0 + 1
		end

		if var_0_7(arg_30_0, arg_30_1, var_0_1.mines.level_id, var_30_1) then
			var_30_0 = var_30_0 + 1
		end

		if var_0_7(arg_30_0, arg_30_1, var_0_1.ground_zero.level_id, var_30_1) then
			var_30_0 = var_30_0 + 1
		end

		return {
			var_30_0,
			4
		}
	end,
	requirements = function (arg_31_0, arg_31_1)
		local var_31_0 = var_0_5.harder.rank
		local var_31_1 = var_0_7(arg_31_0, arg_31_1, var_0_1.military.level_id, var_31_0)
		local var_31_2 = var_0_7(arg_31_0, arg_31_1, var_0_1.catacombs.level_id, var_31_0)
		local var_31_3 = var_0_7(arg_31_0, arg_31_1, var_0_1.mines.level_id, var_31_0)
		local var_31_4 = var_0_7(arg_31_0, arg_31_1, var_0_1.ground_zero.level_id, var_31_0)

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
		local var_32_0 = 0
		local var_32_1 = var_0_5.hardest.rank

		if var_0_7(arg_32_0, arg_32_1, var_0_1.military.level_id, var_32_1) then
			var_32_0 = var_32_0 + 1
		end

		if var_0_7(arg_32_0, arg_32_1, var_0_1.catacombs.level_id, var_32_1) then
			var_32_0 = var_32_0 + 1
		end

		if var_0_7(arg_32_0, arg_32_1, var_0_1.mines.level_id, var_32_1) then
			var_32_0 = var_32_0 + 1
		end

		if var_0_7(arg_32_0, arg_32_1, var_0_1.ground_zero.level_id, var_32_1) then
			var_32_0 = var_32_0 + 1
		end

		return var_32_0 >= 4
	end,
	progress = function (arg_33_0, arg_33_1)
		local var_33_0 = 0
		local var_33_1 = var_0_5.hardest.rank

		if var_0_7(arg_33_0, arg_33_1, var_0_1.military.level_id, var_33_1) then
			var_33_0 = var_33_0 + 1
		end

		if var_0_7(arg_33_0, arg_33_1, var_0_1.catacombs.level_id, var_33_1) then
			var_33_0 = var_33_0 + 1
		end

		if var_0_7(arg_33_0, arg_33_1, var_0_1.mines.level_id, var_33_1) then
			var_33_0 = var_33_0 + 1
		end

		if var_0_7(arg_33_0, arg_33_1, var_0_1.ground_zero.level_id, var_33_1) then
			var_33_0 = var_33_0 + 1
		end

		return {
			var_33_0,
			4
		}
	end,
	requirements = function (arg_34_0, arg_34_1)
		local var_34_0 = var_0_5.hardest.rank
		local var_34_1 = var_0_7(arg_34_0, arg_34_1, var_0_1.military.level_id, var_34_0)
		local var_34_2 = var_0_7(arg_34_0, arg_34_1, var_0_1.catacombs.level_id, var_34_0)
		local var_34_3 = var_0_7(arg_34_0, arg_34_1, var_0_1.mines.level_id, var_34_0)
		local var_34_4 = var_0_7(arg_34_0, arg_34_1, var_0_1.ground_zero.level_id, var_34_0)

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
		return var_0_2.act_completed(arg_35_0, arg_35_1, "act_2")
	end,
	progress = function (arg_36_0, arg_36_1)
		local var_36_0 = 0

		if var_0_8(arg_36_0, arg_36_1, {
			var_0_1.elven_ruins.level_id
		}) then
			var_36_0 = var_36_0 + 1
		end

		if var_0_8(arg_36_0, arg_36_1, {
			var_0_1.bell.level_id
		}) then
			var_36_0 = var_36_0 + 1
		end

		if var_0_8(arg_36_0, arg_36_1, {
			var_0_1.fort.level_id
		}) then
			var_36_0 = var_36_0 + 1
		end

		if var_0_8(arg_36_0, arg_36_1, {
			var_0_1.skaven_stronghold.level_id
		}) then
			var_36_0 = var_36_0 + 1
		end

		return {
			var_36_0,
			4
		}
	end,
	requirements = function (arg_37_0, arg_37_1)
		local var_37_0 = var_0_8(arg_37_0, arg_37_1, {
			var_0_1.elven_ruins.level_id
		})
		local var_37_1 = var_0_8(arg_37_0, arg_37_1, {
			var_0_1.bell.level_id
		})
		local var_37_2 = var_0_8(arg_37_0, arg_37_1, {
			var_0_1.fort.level_id
		})
		local var_37_3 = var_0_8(arg_37_0, arg_37_1, {
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
		local var_38_0 = 0
		local var_38_1 = var_0_5.hard.rank

		if var_0_7(arg_38_0, arg_38_1, var_0_1.elven_ruins.level_id, var_38_1) then
			var_38_0 = var_38_0 + 1
		end

		if var_0_7(arg_38_0, arg_38_1, var_0_1.bell.level_id, var_38_1) then
			var_38_0 = var_38_0 + 1
		end

		if var_0_7(arg_38_0, arg_38_1, var_0_1.fort.level_id, var_38_1) then
			var_38_0 = var_38_0 + 1
		end

		if var_0_7(arg_38_0, arg_38_1, var_0_1.skaven_stronghold.level_id, var_38_1) then
			var_38_0 = var_38_0 + 1
		end

		return var_38_0 >= 4
	end,
	progress = function (arg_39_0, arg_39_1)
		local var_39_0 = 0
		local var_39_1 = var_0_5.hard.rank

		if var_0_7(arg_39_0, arg_39_1, var_0_1.elven_ruins.level_id, var_39_1) then
			var_39_0 = var_39_0 + 1
		end

		if var_0_7(arg_39_0, arg_39_1, var_0_1.bell.level_id, var_39_1) then
			var_39_0 = var_39_0 + 1
		end

		if var_0_7(arg_39_0, arg_39_1, var_0_1.fort.level_id, var_39_1) then
			var_39_0 = var_39_0 + 1
		end

		if var_0_7(arg_39_0, arg_39_1, var_0_1.skaven_stronghold.level_id, var_39_1) then
			var_39_0 = var_39_0 + 1
		end

		return {
			var_39_0,
			4
		}
	end,
	requirements = function (arg_40_0, arg_40_1)
		local var_40_0 = var_0_5.hard.rank
		local var_40_1 = var_0_7(arg_40_0, arg_40_1, var_0_1.elven_ruins.level_id, var_40_0)
		local var_40_2 = var_0_7(arg_40_0, arg_40_1, var_0_1.bell.level_id, var_40_0)
		local var_40_3 = var_0_7(arg_40_0, arg_40_1, var_0_1.fort.level_id, var_40_0)
		local var_40_4 = var_0_7(arg_40_0, arg_40_1, var_0_1.skaven_stronghold.level_id, var_40_0)

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
		local var_41_0 = 0
		local var_41_1 = var_0_5.harder.rank

		if var_0_7(arg_41_0, arg_41_1, var_0_1.elven_ruins.level_id, var_41_1) then
			var_41_0 = var_41_0 + 1
		end

		if var_0_7(arg_41_0, arg_41_1, var_0_1.bell.level_id, var_41_1) then
			var_41_0 = var_41_0 + 1
		end

		if var_0_7(arg_41_0, arg_41_1, var_0_1.fort.level_id, var_41_1) then
			var_41_0 = var_41_0 + 1
		end

		if var_0_7(arg_41_0, arg_41_1, var_0_1.skaven_stronghold.level_id, var_41_1) then
			var_41_0 = var_41_0 + 1
		end

		return var_41_0 >= 4
	end,
	progress = function (arg_42_0, arg_42_1)
		local var_42_0 = 0
		local var_42_1 = var_0_5.harder.rank

		if var_0_7(arg_42_0, arg_42_1, var_0_1.elven_ruins.level_id, var_42_1) then
			var_42_0 = var_42_0 + 1
		end

		if var_0_7(arg_42_0, arg_42_1, var_0_1.bell.level_id, var_42_1) then
			var_42_0 = var_42_0 + 1
		end

		if var_0_7(arg_42_0, arg_42_1, var_0_1.fort.level_id, var_42_1) then
			var_42_0 = var_42_0 + 1
		end

		if var_0_7(arg_42_0, arg_42_1, var_0_1.skaven_stronghold.level_id, var_42_1) then
			var_42_0 = var_42_0 + 1
		end

		return {
			var_42_0,
			4
		}
	end,
	requirements = function (arg_43_0, arg_43_1)
		local var_43_0 = var_0_5.harder.rank
		local var_43_1 = var_0_7(arg_43_0, arg_43_1, var_0_1.elven_ruins.level_id, var_43_0)
		local var_43_2 = var_0_7(arg_43_0, arg_43_1, var_0_1.bell.level_id, var_43_0)
		local var_43_3 = var_0_7(arg_43_0, arg_43_1, var_0_1.fort.level_id, var_43_0)
		local var_43_4 = var_0_7(arg_43_0, arg_43_1, var_0_1.skaven_stronghold.level_id, var_43_0)

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
		local var_44_0 = 0
		local var_44_1 = var_0_5.hardest.rank

		if var_0_7(arg_44_0, arg_44_1, var_0_1.elven_ruins.level_id, var_44_1) then
			var_44_0 = var_44_0 + 1
		end

		if var_0_7(arg_44_0, arg_44_1, var_0_1.bell.level_id, var_44_1) then
			var_44_0 = var_44_0 + 1
		end

		if var_0_7(arg_44_0, arg_44_1, var_0_1.fort.level_id, var_44_1) then
			var_44_0 = var_44_0 + 1
		end

		if var_0_7(arg_44_0, arg_44_1, var_0_1.skaven_stronghold.level_id, var_44_1) then
			var_44_0 = var_44_0 + 1
		end

		return var_44_0 >= 4
	end,
	progress = function (arg_45_0, arg_45_1)
		local var_45_0 = 0
		local var_45_1 = var_0_5.hardest.rank

		if var_0_7(arg_45_0, arg_45_1, var_0_1.elven_ruins.level_id, var_45_1) then
			var_45_0 = var_45_0 + 1
		end

		if var_0_7(arg_45_0, arg_45_1, var_0_1.bell.level_id, var_45_1) then
			var_45_0 = var_45_0 + 1
		end

		if var_0_7(arg_45_0, arg_45_1, var_0_1.fort.level_id, var_45_1) then
			var_45_0 = var_45_0 + 1
		end

		if var_0_7(arg_45_0, arg_45_1, var_0_1.skaven_stronghold.level_id, var_45_1) then
			var_45_0 = var_45_0 + 1
		end

		return {
			var_45_0,
			4
		}
	end,
	requirements = function (arg_46_0, arg_46_1)
		local var_46_0 = var_0_5.hardest.rank
		local var_46_1 = var_0_7(arg_46_0, arg_46_1, var_0_1.elven_ruins.level_id, var_46_0)
		local var_46_2 = var_0_7(arg_46_0, arg_46_1, var_0_1.bell.level_id, var_46_0)
		local var_46_3 = var_0_7(arg_46_0, arg_46_1, var_0_1.fort.level_id, var_46_0)
		local var_46_4 = var_0_7(arg_46_0, arg_46_1, var_0_1.skaven_stronghold.level_id, var_46_0)

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
		return var_0_2.act_completed(arg_47_0, arg_47_1, "act_3")
	end,
	progress = function (arg_48_0, arg_48_1)
		local var_48_0 = 0

		if var_0_8(arg_48_0, arg_48_1, {
			var_0_1.farmlands.level_id
		}) then
			var_48_0 = var_48_0 + 1
		end

		if var_0_8(arg_48_0, arg_48_1, {
			var_0_1.ussingen.level_id
		}) then
			var_48_0 = var_48_0 + 1
		end

		if var_0_8(arg_48_0, arg_48_1, {
			var_0_1.nurgle.level_id
		}) then
			var_48_0 = var_48_0 + 1
		end

		if var_0_8(arg_48_0, arg_48_1, {
			var_0_1.warcamp.level_id
		}) then
			var_48_0 = var_48_0 + 1
		end

		return {
			var_48_0,
			4
		}
	end,
	requirements = function (arg_49_0, arg_49_1)
		local var_49_0 = var_0_8(arg_49_0, arg_49_1, {
			var_0_1.farmlands.level_id
		})
		local var_49_1 = var_0_8(arg_49_0, arg_49_1, {
			var_0_1.ussingen.level_id
		})
		local var_49_2 = var_0_8(arg_49_0, arg_49_1, {
			var_0_1.nurgle.level_id
		})
		local var_49_3 = var_0_8(arg_49_0, arg_49_1, {
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
		local var_50_0 = 0
		local var_50_1 = var_0_5.hard.rank

		if var_0_7(arg_50_0, arg_50_1, var_0_1.farmlands.level_id, var_50_1) then
			var_50_0 = var_50_0 + 1
		end

		if var_0_7(arg_50_0, arg_50_1, var_0_1.ussingen.level_id, var_50_1) then
			var_50_0 = var_50_0 + 1
		end

		if var_0_7(arg_50_0, arg_50_1, var_0_1.nurgle.level_id, var_50_1) then
			var_50_0 = var_50_0 + 1
		end

		if var_0_7(arg_50_0, arg_50_1, var_0_1.warcamp.level_id, var_50_1) then
			var_50_0 = var_50_0 + 1
		end

		return var_50_0 >= 4
	end,
	progress = function (arg_51_0, arg_51_1)
		local var_51_0 = 0
		local var_51_1 = var_0_5.hard.rank

		if var_0_7(arg_51_0, arg_51_1, var_0_1.farmlands.level_id, var_51_1) then
			var_51_0 = var_51_0 + 1
		end

		if var_0_7(arg_51_0, arg_51_1, var_0_1.ussingen.level_id, var_51_1) then
			var_51_0 = var_51_0 + 1
		end

		if var_0_7(arg_51_0, arg_51_1, var_0_1.nurgle.level_id, var_51_1) then
			var_51_0 = var_51_0 + 1
		end

		if var_0_7(arg_51_0, arg_51_1, var_0_1.warcamp.level_id, var_51_1) then
			var_51_0 = var_51_0 + 1
		end

		return {
			var_51_0,
			4
		}
	end,
	requirements = function (arg_52_0, arg_52_1)
		local var_52_0 = var_0_5.hard.rank
		local var_52_1 = var_0_7(arg_52_0, arg_52_1, var_0_1.farmlands.level_id, var_52_0)
		local var_52_2 = var_0_7(arg_52_0, arg_52_1, var_0_1.ussingen.level_id, var_52_0)
		local var_52_3 = var_0_7(arg_52_0, arg_52_1, var_0_1.nurgle.level_id, var_52_0)
		local var_52_4 = var_0_7(arg_52_0, arg_52_1, var_0_1.warcamp.level_id, var_52_0)

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
		local var_53_0 = 0
		local var_53_1 = var_0_5.harder.rank

		if var_0_7(arg_53_0, arg_53_1, var_0_1.farmlands.level_id, var_53_1) then
			var_53_0 = var_53_0 + 1
		end

		if var_0_7(arg_53_0, arg_53_1, var_0_1.ussingen.level_id, var_53_1) then
			var_53_0 = var_53_0 + 1
		end

		if var_0_7(arg_53_0, arg_53_1, var_0_1.nurgle.level_id, var_53_1) then
			var_53_0 = var_53_0 + 1
		end

		if var_0_7(arg_53_0, arg_53_1, var_0_1.warcamp.level_id, var_53_1) then
			var_53_0 = var_53_0 + 1
		end

		return var_53_0 >= 4
	end,
	progress = function (arg_54_0, arg_54_1)
		local var_54_0 = 0
		local var_54_1 = var_0_5.harder.rank

		if var_0_7(arg_54_0, arg_54_1, var_0_1.farmlands.level_id, var_54_1) then
			var_54_0 = var_54_0 + 1
		end

		if var_0_7(arg_54_0, arg_54_1, var_0_1.ussingen.level_id, var_54_1) then
			var_54_0 = var_54_0 + 1
		end

		if var_0_7(arg_54_0, arg_54_1, var_0_1.nurgle.level_id, var_54_1) then
			var_54_0 = var_54_0 + 1
		end

		if var_0_7(arg_54_0, arg_54_1, var_0_1.warcamp.level_id, var_54_1) then
			var_54_0 = var_54_0 + 1
		end

		return {
			var_54_0,
			4
		}
	end,
	requirements = function (arg_55_0, arg_55_1)
		local var_55_0 = var_0_5.harder.rank
		local var_55_1 = var_0_7(arg_55_0, arg_55_1, var_0_1.farmlands.level_id, var_55_0)
		local var_55_2 = var_0_7(arg_55_0, arg_55_1, var_0_1.ussingen.level_id, var_55_0)
		local var_55_3 = var_0_7(arg_55_0, arg_55_1, var_0_1.nurgle.level_id, var_55_0)
		local var_55_4 = var_0_7(arg_55_0, arg_55_1, var_0_1.warcamp.level_id, var_55_0)

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
		local var_56_0 = 0
		local var_56_1 = var_0_5.hardest.rank

		if var_0_7(arg_56_0, arg_56_1, var_0_1.farmlands.level_id, var_56_1) then
			var_56_0 = var_56_0 + 1
		end

		if var_0_7(arg_56_0, arg_56_1, var_0_1.ussingen.level_id, var_56_1) then
			var_56_0 = var_56_0 + 1
		end

		if var_0_7(arg_56_0, arg_56_1, var_0_1.nurgle.level_id, var_56_1) then
			var_56_0 = var_56_0 + 1
		end

		if var_0_7(arg_56_0, arg_56_1, var_0_1.warcamp.level_id, var_56_1) then
			var_56_0 = var_56_0 + 1
		end

		return var_56_0 >= 4
	end,
	progress = function (arg_57_0, arg_57_1)
		local var_57_0 = 0
		local var_57_1 = var_0_5.hardest.rank

		if var_0_7(arg_57_0, arg_57_1, var_0_1.farmlands.level_id, var_57_1) then
			var_57_0 = var_57_0 + 1
		end

		if var_0_7(arg_57_0, arg_57_1, var_0_1.ussingen.level_id, var_57_1) then
			var_57_0 = var_57_0 + 1
		end

		if var_0_7(arg_57_0, arg_57_1, var_0_1.nurgle.level_id, var_57_1) then
			var_57_0 = var_57_0 + 1
		end

		if var_0_7(arg_57_0, arg_57_1, var_0_1.warcamp.level_id, var_57_1) then
			var_57_0 = var_57_0 + 1
		end

		return {
			var_57_0,
			4
		}
	end,
	requirements = function (arg_58_0, arg_58_1)
		local var_58_0 = var_0_5.hardest.rank
		local var_58_1 = var_0_7(arg_58_0, arg_58_1, var_0_1.farmlands.level_id, var_58_0)
		local var_58_2 = var_0_7(arg_58_0, arg_58_1, var_0_1.ussingen.level_id, var_58_0)
		local var_58_3 = var_0_7(arg_58_0, arg_58_1, var_0_1.nurgle.level_id, var_58_0)
		local var_58_4 = var_0_7(arg_58_0, arg_58_1, var_0_1.warcamp.level_id, var_58_0)

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
		local var_59_0 = var_0_5.normal.rank

		return var_0_7(arg_59_0, arg_59_1, var_0_1.skittergate.level_id, var_59_0)
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
		local var_60_0 = var_0_5.hard.rank

		return var_0_7(arg_60_0, arg_60_1, var_0_1.skittergate.level_id, var_60_0)
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
		local var_61_0 = var_0_5.harder.rank

		return var_0_7(arg_61_0, arg_61_1, var_0_1.skittergate.level_id, var_61_0)
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
		local var_62_0 = var_0_5.hardest.rank

		return var_0_7(arg_62_0, arg_62_1, var_0_1.skittergate.level_id, var_62_0)
	end
}
AchievementTemplates.achievements.bogenhafen_complete_recruit = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_complete_recruit_name",
	icon = "icons_placeholder",
	desc = "achv_bogenhafen_complete_recruit_desc",
	completed = function (arg_63_0, arg_63_1)
		local var_63_0 = 0
		local var_63_1 = var_0_5.normal.rank

		if var_0_7(arg_63_0, arg_63_1, var_0_1.dlc_bogenhafen_slum.level_id, var_63_1) then
			var_63_0 = var_63_0 + 1
		end

		if var_0_7(arg_63_0, arg_63_1, var_0_1.dlc_bogenhafen_city.level_id, var_63_1) then
			var_63_0 = var_63_0 + 1
		end

		return var_63_0 >= 2
	end,
	progress = function (arg_64_0, arg_64_1)
		local var_64_0 = 0
		local var_64_1 = var_0_5.normal.rank

		if var_0_7(arg_64_0, arg_64_1, var_0_1.dlc_bogenhafen_slum.level_id, var_64_1) then
			var_64_0 = var_64_0 + 1
		end

		if var_0_7(arg_64_0, arg_64_1, var_0_1.dlc_bogenhafen_city.level_id, var_64_1) then
			var_64_0 = var_64_0 + 1
		end

		return {
			var_64_0,
			2
		}
	end,
	requirements = function (arg_65_0, arg_65_1)
		local var_65_0 = var_0_5.normal.rank
		local var_65_1 = var_0_7(arg_65_0, arg_65_1, var_0_1.dlc_bogenhafen_slum.level_id, var_65_0)
		local var_65_2 = var_0_7(arg_65_0, arg_65_1, var_0_1.dlc_bogenhafen_city.level_id, var_65_0)

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
		local var_66_0 = 0
		local var_66_1 = var_0_5.hard.rank

		if var_0_7(arg_66_0, arg_66_1, var_0_1.dlc_bogenhafen_slum.level_id, var_66_1) then
			var_66_0 = var_66_0 + 1
		end

		if var_0_7(arg_66_0, arg_66_1, var_0_1.dlc_bogenhafen_city.level_id, var_66_1) then
			var_66_0 = var_66_0 + 1
		end

		return var_66_0 >= 2
	end,
	progress = function (arg_67_0, arg_67_1)
		local var_67_0 = 0
		local var_67_1 = var_0_5.hard.rank

		if var_0_7(arg_67_0, arg_67_1, var_0_1.dlc_bogenhafen_slum.level_id, var_67_1) then
			var_67_0 = var_67_0 + 1
		end

		if var_0_7(arg_67_0, arg_67_1, var_0_1.dlc_bogenhafen_city.level_id, var_67_1) then
			var_67_0 = var_67_0 + 1
		end

		return {
			var_67_0,
			2
		}
	end,
	requirements = function (arg_68_0, arg_68_1)
		local var_68_0 = var_0_5.hard.rank
		local var_68_1 = var_0_7(arg_68_0, arg_68_1, var_0_1.dlc_bogenhafen_slum.level_id, var_68_0)
		local var_68_2 = var_0_7(arg_68_0, arg_68_1, var_0_1.dlc_bogenhafen_city.level_id, var_68_0)

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
		local var_69_0 = 0
		local var_69_1 = var_0_5.harder.rank

		if var_0_7(arg_69_0, arg_69_1, var_0_1.dlc_bogenhafen_slum.level_id, var_69_1) then
			var_69_0 = var_69_0 + 1
		end

		if var_0_7(arg_69_0, arg_69_1, var_0_1.dlc_bogenhafen_city.level_id, var_69_1) then
			var_69_0 = var_69_0 + 1
		end

		return var_69_0 >= 2
	end,
	progress = function (arg_70_0, arg_70_1)
		local var_70_0 = 0
		local var_70_1 = var_0_5.harder.rank

		if var_0_7(arg_70_0, arg_70_1, var_0_1.dlc_bogenhafen_slum.level_id, var_70_1) then
			var_70_0 = var_70_0 + 1
		end

		if var_0_7(arg_70_0, arg_70_1, var_0_1.dlc_bogenhafen_city.level_id, var_70_1) then
			var_70_0 = var_70_0 + 1
		end

		return {
			var_70_0,
			2
		}
	end,
	requirements = function (arg_71_0, arg_71_1)
		local var_71_0 = var_0_5.harder.rank
		local var_71_1 = var_0_7(arg_71_0, arg_71_1, var_0_1.dlc_bogenhafen_slum.level_id, var_71_0)
		local var_71_2 = var_0_7(arg_71_0, arg_71_1, var_0_1.dlc_bogenhafen_city.level_id, var_71_0)

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
		local var_72_0 = 0
		local var_72_1 = var_0_5.hardest.rank

		if var_0_7(arg_72_0, arg_72_1, var_0_1.dlc_bogenhafen_slum.level_id, var_72_1) then
			var_72_0 = var_72_0 + 1
		end

		if var_0_7(arg_72_0, arg_72_1, var_0_1.dlc_bogenhafen_city.level_id, var_72_1) then
			var_72_0 = var_72_0 + 1
		end

		return var_72_0 >= 2
	end,
	progress = function (arg_73_0, arg_73_1)
		local var_73_0 = 0
		local var_73_1 = var_0_5.hardest.rank

		if var_0_7(arg_73_0, arg_73_1, var_0_1.dlc_bogenhafen_slum.level_id, var_73_1) then
			var_73_0 = var_73_0 + 1
		end

		if var_0_7(arg_73_0, arg_73_1, var_0_1.dlc_bogenhafen_city.level_id, var_73_1) then
			var_73_0 = var_73_0 + 1
		end

		return {
			var_73_0,
			2
		}
	end,
	requirements = function (arg_74_0, arg_74_1)
		local var_74_0 = var_0_5.hardest.rank
		local var_74_1 = var_0_7(arg_74_0, arg_74_1, var_0_1.dlc_bogenhafen_slum.level_id, var_74_0)
		local var_74_2 = var_0_7(arg_74_0, arg_74_1, var_0_1.dlc_bogenhafen_city.level_id, var_74_0)

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
	completed = function (arg_75_0, arg_75_1, arg_75_2)
		return arg_75_0:get_persistent_stat(arg_75_1, "bogenhafen_city_no_braziers_lit") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_city_torch_not_picked_up = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_city_torch_not_picked_up_name",
	display_completion_ui = true,
	icon = "achievement_trophy_bogenhafen_city_torch_not_picked_up",
	desc = "achv_bogenhafen_city_torch_not_picked_up_desc",
	completed = function (arg_76_0, arg_76_1)
		return arg_76_0:get_persistent_stat(arg_76_1, "bogenhafen_city_torch_not_picked_up") > 0
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
	completed = function (arg_77_0, arg_77_1)
		return arg_77_0:get_persistent_stat(arg_77_1, "bogenhafen_city_fast_switches") > 0
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
	completed = function (arg_78_0, arg_78_1)
		return arg_78_0:get_persistent_stat(arg_78_1, "bogenhafen_city_all_wine_collected") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_city_jumping_puzzle = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_city_jumping_puzzle_name",
	display_completion_ui = true,
	icon = "achievement_trophy_bogenhafen_city_jumping_puzzle",
	desc = "achv_bogenhafen_city_jumping_puzzle_desc",
	completed = function (arg_79_0, arg_79_1)
		return arg_79_0:get_persistent_stat(arg_79_1, "bogenhafen_city_jumping_puzzle") > 0
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
	completed = function (arg_80_0, arg_80_1)
		return arg_80_0:get_persistent_stat(arg_80_1, "bogenhafen_slum_no_ratling_damage") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_slum_no_windows_broken = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_slum_no_windows_broken_name",
	display_completion_ui = true,
	icon = "achievement_trophy_bogenhafen_slum_no_windows_broken",
	desc = "achv_bogenhafen_slum_no_windows_broken_desc",
	completed = function (arg_81_0, arg_81_1)
		return arg_81_0:get_persistent_stat(arg_81_1, "bogenhafen_slum_no_windows_broken") > 0
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
	completed = function (arg_82_0, arg_82_1)
		return arg_82_0:get_persistent_stat(arg_82_1, "bogenhafen_slum_find_hidden_stash") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_slum_jumping_puzzle = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_slum_jumping_puzzle_name",
	display_completion_ui = true,
	icon = "achievement_trophy_bogenhafen_slum_jumping_puzzle",
	desc = "achv_bogenhafen_slum_jumping_puzzle_desc",
	completed = function (arg_83_0, arg_83_1)
		return arg_83_0:get_persistent_stat(arg_83_1, "bogenhafen_slum_jumping_puzzle") > 0
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
	completed = function (arg_84_0, arg_84_1)
		return arg_84_0:get_persistent_stat(arg_84_1, "bogenhafen_slum_event_speedrun") > 0
	end
}
AchievementTemplates.achievements.bogenhafen_collect_all_cosmetics = {
	required_dlc = "bogenhafen",
	name = "achv_bogenhafen_collect_all_cosmetics_name",
	icon = "achievement_trophy_bogenhafen_collect_all_cosmetics",
	desc = "achv_bogenhafen_collect_all_cosmetics_desc",
	completed = function (arg_85_0, arg_85_1)
		return arg_85_0:get_persistent_stat(arg_85_1, "collected_bogenhafen_cosmetics") >= var_0_13
	end,
	progress = function (arg_86_0, arg_86_1)
		local var_86_0 = arg_86_0:get_persistent_stat(arg_86_1, "collected_bogenhafen_cosmetics")

		return {
			var_86_0,
			var_0_13
		}
	end
}

local var_0_14 = (function (arg_87_0)
	local var_87_0

	for iter_87_0, iter_87_1 in ipairs(arg_87_0) do
		if iter_87_1 == "prologue" then
			var_87_0 = iter_87_0
		end
	end

	local var_87_1 = arg_87_0

	if var_87_0 then
		table.remove(var_87_1, var_87_0)
	end

	return var_87_1
end)(MainGameLevels)
local var_0_15 = {}

AchievementTemplates.achievements.completed_all_levels = {
	name = "achv_complete_all_levels_name",
	desc = "achv_complete_all_levels_desc",
	completed = function (arg_88_0, arg_88_1)
		return var_0_8(arg_88_0, arg_88_1, var_0_14)
	end,
	progress = function (arg_89_0, arg_89_1)
		local var_89_0 = 0

		for iter_89_0, iter_89_1 in ipairs(var_0_14) do
			if var_0_8(arg_89_0, arg_89_1, {
				iter_89_1
			}) then
				var_89_0 = var_89_0 + 1
			end
		end

		return {
			var_89_0,
			#var_0_14
		}
	end,
	requirements = function (arg_90_0, arg_90_1)
		table.clear(var_0_15)

		for iter_90_0, iter_90_1 in ipairs(var_0_14) do
			local var_90_0 = var_0_8(arg_90_0, arg_90_1, {
				iter_90_1
			})

			table.insert(var_0_15, {
				name = var_0_1[iter_90_1].display_name,
				completed = var_90_0
			})
		end

		return var_0_15
	end
}
AchievementTemplates.achievements.achievement_bardin_level_1 = {
	name = "achv_achievement_bardin_level_1_name",
	icon = "achievement_trophy_bardin_level_1",
	desc = "achv_achievement_bardin_level_1_desc",
	completed = function (arg_91_0, arg_91_1)
		return var_0_10("dwarf_ranger") >= 17
	end,
	progress = function (arg_92_0, arg_92_1)
		local var_92_0 = var_0_10("dwarf_ranger")

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
		return var_0_10("dwarf_ranger") >= 22
	end,
	progress = function (arg_94_0, arg_94_1)
		local var_94_0 = var_0_10("dwarf_ranger")

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
		return var_0_10("dwarf_ranger") >= 27
	end,
	progress = function (arg_96_0, arg_96_1)
		local var_96_0 = var_0_10("dwarf_ranger")

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
		return var_0_10("empire_soldier") >= 17
	end,
	progress = function (arg_98_0, arg_98_1)
		local var_98_0 = var_0_10("empire_soldier")

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
		return var_0_10("empire_soldier") >= 22
	end,
	progress = function (arg_100_0, arg_100_1)
		local var_100_0 = var_0_10("empire_soldier")

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
		return var_0_10("empire_soldier") >= 27
	end,
	progress = function (arg_102_0, arg_102_1)
		local var_102_0 = var_0_10("empire_soldier")

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
		return var_0_10("wood_elf") >= 17
	end,
	progress = function (arg_104_0, arg_104_1)
		local var_104_0 = var_0_10("wood_elf")

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
		return var_0_10("wood_elf") >= 22
	end,
	progress = function (arg_106_0, arg_106_1)
		local var_106_0 = var_0_10("wood_elf")

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
		return var_0_10("wood_elf") >= 27
	end,
	progress = function (arg_108_0, arg_108_1)
		local var_108_0 = var_0_10("wood_elf")

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
		return var_0_10("bright_wizard") >= 17
	end,
	progress = function (arg_110_0, arg_110_1)
		local var_110_0 = var_0_10("bright_wizard")

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
		return var_0_10("bright_wizard") >= 22
	end,
	progress = function (arg_112_0, arg_112_1)
		local var_112_0 = var_0_10("bright_wizard")

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
		return var_0_10("bright_wizard") >= 27
	end,
	progress = function (arg_114_0, arg_114_1)
		local var_114_0 = var_0_10("bright_wizard")

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
		return var_0_10("witch_hunter") >= 17
	end,
	progress = function (arg_116_0, arg_116_1)
		local var_116_0 = var_0_10("witch_hunter")

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
		return var_0_10("witch_hunter") >= 22
	end,
	progress = function (arg_118_0, arg_118_1)
		local var_118_0 = var_0_10("witch_hunter")

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
		return var_0_10("witch_hunter") >= 27
	end,
	progress = function (arg_120_0, arg_120_1)
		local var_120_0 = var_0_10("witch_hunter")

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
		return var_0_10("wood_elf") >= 30
	end,
	progress = function (arg_122_0, arg_122_1)
		local var_122_0 = var_0_10("wood_elf")

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
		return var_0_10("witch_hunter") >= 30
	end,
	progress = function (arg_124_0, arg_124_1)
		local var_124_0 = var_0_10("witch_hunter")

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
		return var_0_10("empire_soldier") >= 30
	end,
	progress = function (arg_126_0, arg_126_1)
		local var_126_0 = var_0_10("empire_soldier")

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
		return var_0_10("bright_wizard") >= 30
	end,
	progress = function (arg_128_0, arg_128_1)
		local var_128_0 = var_0_10("bright_wizard")

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
		return var_0_10("dwarf_ranger") >= 30
	end,
	progress = function (arg_130_0, arg_130_1)
		local var_130_0 = var_0_10("dwarf_ranger")

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
		return var_0_10("wood_elf") >= 30 and var_0_10("witch_hunter") >= 30 and var_0_10("empire_soldier") >= 30 and var_0_10("bright_wizard") >= 30 and var_0_10("dwarf_ranger") >= 30
	end,
	progress = function (arg_132_0, arg_132_1)
		local var_132_0 = 0

		if var_0_10("wood_elf") >= 30 then
			var_132_0 = var_132_0 + 1
		end

		if var_0_10("witch_hunter") >= 30 then
			var_132_0 = var_132_0 + 1
		end

		if var_0_10("empire_soldier") >= 30 then
			var_132_0 = var_132_0 + 1
		end

		if var_0_10("bright_wizard") >= 30 then
			var_132_0 = var_132_0 + 1
		end

		if var_0_10("dwarf_ranger") >= 30 then
			var_132_0 = var_132_0 + 1
		end

		return {
			var_132_0,
			5
		}
	end,
	requirements = function (arg_133_0, arg_133_1)
		local var_133_0 = var_0_10("wood_elf")
		local var_133_1 = var_0_10("witch_hunter")
		local var_133_2 = var_0_10("empire_soldier")
		local var_133_3 = var_0_10("bright_wizard")
		local var_133_4 = var_0_10("dwarf_ranger")

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
		if Managers.mechanism:current_mechanism_name() == "versus" then
			return false
		end

		local var_134_0 = {
			"wood_elf",
			"witch_hunter",
			"empire_soldier",
			"bright_wizard",
			"dwarf_ranger"
		}

		for iter_134_0, iter_134_1 in ipairs(var_134_0) do
			if var_0_3.get_num_talent_points(iter_134_1) >= 1 then
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
		if Managers.mechanism:current_mechanism_name() == "versus" then
			return false
		end

		local var_135_0 = {
			"wood_elf",
			"witch_hunter",
			"empire_soldier",
			"bright_wizard",
			"dwarf_ranger"
		}

		for iter_135_0, iter_135_1 in ipairs(var_135_0) do
			if var_0_3.get_num_talent_points(iter_135_1) == 6 then
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
	completed = function (arg_136_0, arg_136_1)
		return arg_136_0:get_persistent_stat(arg_136_1, "crafted_items") >= 1
	end
}
AchievementTemplates.achievements.craft_fifty_items = {
	ID_XB1 = 19,
	name = "achv_craft_fifty_items_name",
	ID_PS4 = "018",
	icon = "achievement_trophy_18",
	ID_STEAM = "craft_fifty_items",
	desc = "achv_craft_fifty_items_desc",
	completed = function (arg_137_0, arg_137_1)
		return arg_137_0:get_persistent_stat(arg_137_1, "crafted_items") >= 50
	end,
	progress = function (arg_138_0, arg_138_1)
		local var_138_0 = arg_138_0:get_persistent_stat(arg_138_1, "crafted_items")

		if var_138_0 > 50 then
			var_138_0 = 50
		end

		return {
			var_138_0,
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
	completed = function (arg_139_0, arg_139_1)
		return arg_139_0:get_persistent_stat(arg_139_1, "salvaged_items") >= 1
	end
}
AchievementTemplates.achievements.salvage_hundred_items = {
	ID_XB1 = 21,
	name = "achv_salvage_hundred_items_name",
	ID_PS4 = "020",
	icon = "achievement_trophy_20",
	ID_STEAM = "salvage_hundred_items",
	desc = "achv_salvage_hundred_items_desc",
	completed = function (arg_140_0, arg_140_1)
		return arg_140_0:get_persistent_stat(arg_140_1, "salvaged_items") >= 100
	end,
	progress = function (arg_141_0, arg_141_1)
		local var_141_0 = arg_141_0:get_persistent_stat(arg_141_1, "salvaged_items")

		if var_141_0 > 100 then
			var_141_0 = 100
		end

		return {
			var_141_0,
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
		return var_0_11(arg_142_0, arg_142_1, "common") >= 1
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
		return var_0_11(arg_143_0, arg_143_1, "rare") >= 1
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
		return var_0_11(arg_144_0, arg_144_1, "exotic") >= 1
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
		return var_0_11(arg_145_0, arg_145_1, "exotic") == 5
	end,
	progress = function (arg_146_0, arg_146_1)
		local var_146_0 = var_0_11(arg_146_0, arg_146_1, "exotic")

		return {
			var_146_0,
			5
		}
	end,
	requirements = function (arg_147_0, arg_147_1)
		local var_147_0 = arg_147_0:get_persistent_stat(arg_147_1, "highest_equipped_rarity", "melee")
		local var_147_1 = arg_147_0:get_persistent_stat(arg_147_1, "highest_equipped_rarity", "ranged")
		local var_147_2 = arg_147_0:get_persistent_stat(arg_147_1, "highest_equipped_rarity", "necklace")
		local var_147_3 = arg_147_0:get_persistent_stat(arg_147_1, "highest_equipped_rarity", "ring")
		local var_147_4 = arg_147_0:get_persistent_stat(arg_147_1, "highest_equipped_rarity", "trinket")
		local var_147_5 = var_0_12.exotic

		return {
			{
				name = "melee",
				completed = var_147_5 <= var_147_0
			},
			{
				name = "ranged",
				completed = var_147_5 <= var_147_1
			},
			{
				name = "necklace",
				completed = var_147_5 <= var_147_2
			},
			{
				name = "ring",
				completed = var_147_5 <= var_147_3
			},
			{
				name = "trinket",
				completed = var_147_5 <= var_147_4
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
		return var_0_11(arg_148_0, arg_148_1, "unique") >= 1
	end
}
AchievementTemplates.achievements.equip_all_veteran_quality = {
	name = "achv_equip_all_veteran_quality_name",
	icon = "achievement_trophy_equip_all_veteran_quality",
	desc = "achv_equip_all_veteran_quality_desc",
	completed = function (arg_149_0, arg_149_1)
		return var_0_11(arg_149_0, arg_149_1, "unique") == 5
	end,
	progress = function (arg_150_0, arg_150_1)
		local var_150_0 = var_0_11(arg_150_0, arg_150_1, "unique")

		return {
			var_150_0,
			5
		}
	end,
	requirements = function (arg_151_0, arg_151_1)
		local var_151_0 = arg_151_0:get_persistent_stat(arg_151_1, "highest_equipped_rarity", "melee")
		local var_151_1 = arg_151_0:get_persistent_stat(arg_151_1, "highest_equipped_rarity", "ranged")
		local var_151_2 = arg_151_0:get_persistent_stat(arg_151_1, "highest_equipped_rarity", "necklace")
		local var_151_3 = arg_151_0:get_persistent_stat(arg_151_1, "highest_equipped_rarity", "ring")
		local var_151_4 = arg_151_0:get_persistent_stat(arg_151_1, "highest_equipped_rarity", "trinket")
		local var_151_5 = var_0_12.unique

		return {
			{
				name = "melee",
				completed = var_151_5 <= var_151_0
			},
			{
				name = "ranged",
				completed = var_151_5 <= var_151_1
			},
			{
				name = "necklace",
				completed = var_151_5 <= var_151_2
			},
			{
				name = "ring",
				completed = var_151_5 <= var_151_3
			},
			{
				name = "trinket",
				completed = var_151_5 <= var_151_4
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
	completed = function (arg_152_0, arg_152_1)
		local var_152_0 = {
			"bright_wizard",
			"wood_elf",
			"empire_soldier",
			"dwarf_ranger",
			"witch_hunter"
		}

		for iter_152_0 = 1, #var_0_4 do
			local var_152_1 = var_0_4[iter_152_0]
			local var_152_2 = true

			for iter_152_1 = 1, #var_152_0 do
				local var_152_3 = var_152_0[iter_152_1]

				if arg_152_0:get_persistent_stat(arg_152_1, "completed_levels_" .. var_152_3, var_152_1) == 0 then
					var_152_2 = false

					break
				end
			end

			if var_152_2 then
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

for iter_0_0, iter_0_1 in ipairs(AchievementTemplates.completed_deed_limits) do
	local var_0_16 = "complete_deeds_" .. iter_0_0

	AchievementTemplates.achievements[var_0_16] = {
		name = "achv_complete_deeds_" .. iter_0_0 .. "_name",
		desc = function ()
			return string.format(Localize("achv_complete_deeds_desc"), iter_0_1)
		end,
		icon = "achievement_trophy_deeds_" .. iter_0_0,
		completed = function (arg_154_0, arg_154_1)
			return arg_154_0:get_persistent_stat(arg_154_1, "completed_heroic_deeds") >= iter_0_1
		end,
		progress = function (arg_155_0, arg_155_1)
			local var_155_0 = arg_155_0:get_persistent_stat(arg_155_1, "completed_heroic_deeds")
			local var_155_1 = math.min(var_155_0, iter_0_1)

			return {
				var_155_1,
				iter_0_1
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

for iter_0_2, iter_0_3 in ipairs(AchievementTemplates.difficulties) do
	local var_0_17 = DifficultyMapping[iter_0_3]
	local var_0_18 = "complete_all_helmgart_levels_" .. var_0_17

	AchievementTemplates.achievements[var_0_18] = {
		name = "achv_complete_all_helmgart_levels_" .. var_0_17 .. "_name",
		desc = "achv_complete_all_helmgart_levels_" .. var_0_17 .. "_desc",
		icon = "achievement_trophy_complete_all_helmgart_levels_" .. var_0_17,
		completed = function (arg_156_0, arg_156_1)
			return var_0_9(arg_156_0, arg_156_1, var_0_14, var_0_5[iter_0_3].rank)
		end,
		progress = function (arg_157_0, arg_157_1)
			local var_157_0 = 0

			for iter_157_0, iter_157_1 in ipairs(var_0_14) do
				if var_0_7(arg_157_0, arg_157_1, iter_157_1, var_0_5[iter_0_3].rank) then
					var_157_0 = var_157_0 + 1
				end
			end

			return {
				var_157_0,
				#var_0_14
			}
		end,
		requirements = function (arg_158_0, arg_158_1)
			local var_158_0 = {}

			for iter_158_0, iter_158_1 in ipairs(var_0_14) do
				local var_158_1 = var_0_7(arg_158_0, arg_158_1, iter_158_1, var_0_5[iter_0_3].rank)

				table.insert(var_158_0, {
					name = var_0_1[iter_158_1].display_name,
					completed = var_158_1
				})
			end

			return var_158_0
		end
	}
end

local var_0_19 = {}

for iter_0_4, iter_0_5 in ipairs(SPProfiles) do
	if iter_0_5.affiliation == "heroes" then
		for iter_0_6, iter_0_7 in ipairs(iter_0_5.careers) do
			var_0_19[#var_0_19 + 1] = iter_0_7.name
		end
	end
end

AchievementTemplates.hero_careers = var_0_19

for iter_0_8, iter_0_9 in ipairs(var_0_19) do
	fassert(CareerSettings[iter_0_9] ~= nil, "No career with such name (%s)", iter_0_9)

	for iter_0_10, iter_0_11 in ipairs(AchievementTemplates.difficulties) do
		local var_0_20 = DifficultyMapping[iter_0_11]
		local var_0_21 = "complete_all_helmgart_levels_" .. var_0_20 .. "_" .. iter_0_9

		AchievementTemplates.achievements[var_0_21] = {
			name = "achv_complete_all_helmgart_levels_" .. var_0_20 .. "_" .. iter_0_9 .. "_name",
			desc = "achv_complete_all_helmgart_levels_" .. var_0_20 .. "_" .. iter_0_9 .. "_desc",
			icon = "achievement_trophy_" .. var_0_20 .. "_" .. iter_0_9,
			completed = function (arg_159_0, arg_159_1)
				return var_0_9(arg_159_0, arg_159_1, var_0_14, var_0_5[iter_0_11].rank, iter_0_9)
			end,
			progress = function (arg_160_0, arg_160_1)
				local var_160_0 = 0

				for iter_160_0, iter_160_1 in ipairs(var_0_14) do
					if var_0_7(arg_160_0, arg_160_1, iter_160_1, var_0_5[iter_0_11].rank, iter_0_9) then
						var_160_0 = var_160_0 + 1
					end
				end

				return {
					var_160_0,
					#var_0_14
				}
			end,
			requirements = function (arg_161_0, arg_161_1)
				local var_161_0 = {}

				for iter_161_0, iter_161_1 in ipairs(var_0_14) do
					local var_161_1 = var_0_7(arg_161_0, arg_161_1, iter_161_1, var_0_5[iter_0_11].rank, iter_0_9)

					table.insert(var_161_0, {
						name = var_0_1[iter_161_1].display_name,
						completed = var_161_1
					})
				end

				return var_161_0
			end
		}
	end
end

for iter_0_12, iter_0_13 in ipairs(AchievementTemplates.difficulties) do
	local var_0_22 = DifficultyMapping[iter_0_13]
	local var_0_23 = "complete_all_helmgart_levels_all_careers_" .. var_0_22

	AchievementTemplates.achievements[var_0_23] = {
		name = "achv_complete_all_helmgart_levels_all_careers_" .. var_0_22 .. "_name",
		desc = "achv_complete_all_helmgart_levels_all_careers_" .. var_0_22 .. "_desc",
		icon = "achievement_trophy_all_careers_" .. var_0_22,
		completed = function (arg_162_0, arg_162_1)
			for iter_162_0, iter_162_1 in ipairs(var_0_19) do
				if not var_0_9(arg_162_0, arg_162_1, var_0_14, var_0_5[iter_0_13].rank, iter_162_1) then
					return false
				end
			end

			return true
		end,
		progress = function (arg_163_0, arg_163_1)
			local var_163_0 = 0
			local var_163_1 = 0

			for iter_163_0, iter_163_1 in ipairs(var_0_19) do
				var_163_1 = var_163_1 + 1

				if var_0_9(arg_163_0, arg_163_1, var_0_14, var_0_5[iter_0_13].rank, iter_163_1) then
					var_163_0 = var_163_0 + 1
				end
			end

			return {
				var_163_0,
				var_163_1
			}
		end,
		requirements = function (arg_164_0, arg_164_1)
			local var_164_0 = {}

			for iter_164_0, iter_164_1 in ipairs(var_0_19) do
				local var_164_1 = var_0_9(arg_164_0, arg_164_1, var_0_14, var_0_5[iter_0_13].rank, iter_164_1)

				table.insert(var_164_0, {
					name = iter_164_1,
					completed = var_164_1
				})
			end

			return var_164_0
		end
	}
end

for iter_0_14, iter_0_15 in ipairs(var_0_19) do
	fassert(CareerSettings[iter_0_15] ~= nil, "No such career (%s)", iter_0_15)

	local var_0_24 = "complete_100_missions_champion_" .. iter_0_15

	AchievementTemplates.achievements[var_0_24] = {
		name = "achv_complete_100_missions_champion_" .. iter_0_15 .. "_name",
		desc = "achv_complete_100_missions_champion_" .. iter_0_15 .. "_desc",
		icon = "achievement_trophy_100_missions_champion_" .. iter_0_15,
		completed = function (arg_165_0, arg_165_1)
			local var_165_0 = 0

			for iter_165_0, iter_165_1 in ipairs(var_0_4) do
				var_165_0 = var_165_0 + arg_165_0:get_persistent_stat(arg_165_1, "completed_career_levels", iter_0_15, iter_165_1, "harder")
				var_165_0 = var_165_0 + arg_165_0:get_persistent_stat(arg_165_1, "completed_career_levels", iter_0_15, iter_165_1, "hardest")
				var_165_0 = var_165_0 + arg_165_0:get_persistent_stat(arg_165_1, "completed_career_levels", iter_0_15, iter_165_1, "cataclysm")
			end

			return var_165_0 >= 100
		end,
		progress = function (arg_166_0, arg_166_1)
			local var_166_0 = 0

			for iter_166_0, iter_166_1 in ipairs(var_0_4) do
				var_166_0 = var_166_0 + arg_166_0:get_persistent_stat(arg_166_1, "completed_career_levels", iter_0_15, iter_166_1, "harder")
				var_166_0 = var_166_0 + arg_166_0:get_persistent_stat(arg_166_1, "completed_career_levels", iter_0_15, iter_166_1, "hardest")
				var_166_0 = var_166_0 + arg_166_0:get_persistent_stat(arg_166_1, "completed_career_levels", iter_0_15, iter_166_1, "cataclysm")
			end

			if var_166_0 > 100 then
				var_166_0 = 100
			end

			return {
				var_166_0,
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
		return string.format(Localize("achv_elven_ruins_align_leylines_timed_desc"), QuestSettings.elven_ruins_speed_event)
	end,
	completed = function (arg_168_0, arg_168_1)
		return arg_168_0:get_persistent_stat(arg_168_1, "elven_ruins_speed_event") > 0
	end
}
AchievementTemplates.achievements.farmlands_rescue_prisoners_timed = {
	ID_XB1 = 29,
	ID_PS4 = "028",
	name = "achv_farmlands_rescue_prisoners_timed_name",
	display_completion_ui = true,
	icon = "achievement_trophy_farmlands_rescue_prisoners_timed",
	desc = function ()
		return string.format(Localize("achv_farmlands_rescue_prisoners_timed_desc"), QuestSettings.farmlands_speed_event)
	end,
	completed = function (arg_170_0, arg_170_1)
		return arg_170_0:get_persistent_stat(arg_170_1, "farmlands_speed_event") > 0
	end
}
AchievementTemplates.achievements.military_kill_chaos_warriors_in_event = {
	ID_XB1 = 30,
	ID_PS4 = "029",
	name = "achv_military_kill_chaos_warriors_in_event_name",
	display_completion_ui = true,
	icon = "achievement_trophy_military_kill_chaos_warriors_in_event",
	desc = function ()
		return string.format(Localize("achv_military_kill_chaos_warriors_in_event_desc"), 3)
	end,
	completed = function (arg_172_0, arg_172_1)
		return arg_172_0:get_persistent_stat(arg_172_1, "military_statue_kill_chaos_warriors") > 0
	end
}
AchievementTemplates.achievements.ground_zero_burblespew_tornado_enemies = {
	ID_XB1 = 31,
	ID_PS4 = "030",
	name = "achv_ground_zero_burblespew_tornado_enemies_name",
	display_completion_ui = true,
	icon = "achievement_trophy_ground_zero_burblespew_tornado_enemies",
	desc = function ()
		return string.format(Localize("achv_ground_zero_burblespew_tornado_enemies_desc"), QuestSettings.halescourge_tornado_enemies_cata)
	end,
	completed = function (arg_174_0, arg_174_1)
		return arg_174_0:get_persistent_stat(arg_174_1, "halescourge_tornado_enemies") > 0
	end
}
AchievementTemplates.achievements.fort_kill_enemies_cannonball = {
	ID_XB1 = 32,
	ID_PS4 = "031",
	name = "achv_fort_kill_enemies_cannonball_name",
	display_completion_ui = true,
	icon = "achievement_trophy_fort_kill_enemies_cannonball",
	desc = function ()
		return string.format(Localize("achv_fort_kill_enemies_cannonball_desc"), QuestSettings.forest_fort_kill_cannonball)
	end,
	completed = function (arg_176_0, arg_176_1)
		return arg_176_0:get_persistent_stat(arg_176_1, "forest_fort_kill_cannonball") > 0
	end
}
AchievementTemplates.achievements.nurgle_player_showered_in_pus = {
	ID_XB1 = 33,
	ID_PS4 = "032",
	name = "achv_nurgle_player_showered_in_pus_name",
	display_completion_ui = true,
	icon = "achievement_trophy_nurgle_player_showered_in_pus",
	desc = function ()
		return string.format(Localize("achv_nurgle_player_showered_in_pus_desc"), QuestSettings.nurgle_bathed_all_cata)
	end,
	completed = function (arg_178_0, arg_178_1)
		return arg_178_0:get_persistent_stat(arg_178_1, "nurgle_bathed_all") > 0
	end
}
AchievementTemplates.achievements.bell_destroy_bell_flee_timed = {
	ID_XB1 = 34,
	ID_PS4 = "033",
	name = "achv_bell_destroy_bell_flee_timed_name",
	display_completion_ui = true,
	icon = "achievement_trophy_bell_destroy_bell_flee_timed",
	desc = function ()
		return string.format(Localize("achv_bell_destroy_bell_flee_timed_desc"), QuestSettings.bell_speed_event)
	end,
	completed = function (arg_180_0, arg_180_1)
		return arg_180_0:get_persistent_stat(arg_180_1, "bell_speed_event") > 0
	end
}
AchievementTemplates.achievements.catacombs_stay_inside_ritual_pool = {
	ID_XB1 = 35,
	ID_PS4 = "034",
	name = "achv_catacombs_stay_inside_ritual_pool_name",
	display_completion_ui = true,
	icon = "achievement_trophy_catacombs_stay_inside_ritual_pool",
	desc = function ()
		return string.format(Localize("achv_catacombs_stay_inside_ritual_pool_desc"), QuestSettings.volume_corpse_pit_damage)
	end,
	completed = function (arg_182_0, arg_182_1)
		return arg_182_0:get_persistent_stat(arg_182_1, "catacombs_added_souls") > 0
	end
}
AchievementTemplates.achievements.mines_kill_final_troll_timed = {
	ID_XB1 = 36,
	ID_PS4 = "035",
	name = "achv_mines_kill_final_troll_timed_name",
	display_completion_ui = true,
	icon = "achievement_trophy_mines_kill_final_troll_timed",
	desc = function ()
		return string.format(Localize("achv_mines_kill_final_troll_timed_desc"), QuestSettings.mines_speed_event)
	end,
	completed = function (arg_184_0, arg_184_1)
		return arg_184_0:get_persistent_stat(arg_184_1, "mines_speed_event") > 0
	end
}
AchievementTemplates.achievements.warcamp_bodvarr_charge_warriors = {
	ID_XB1 = 37,
	ID_PS4 = "036",
	name = "achv_warcamp_bodvarr_charge_warriors_name",
	display_completion_ui = true,
	icon = "achievement_trophy_warcamp_bodvarr_charge_warriors",
	desc = function ()
		return string.format(Localize("achv_warcamp_bodvarr_charge_warriors_desc"), QuestSettings.exalted_champion_charge_chaos_warrior)
	end,
	completed = function (arg_186_0, arg_186_1)
		return arg_186_0:get_persistent_stat(arg_186_1, "exalted_champion_charge_chaos_warrior") > 0
	end
}
AchievementTemplates.achievements.skaven_stronghold_skarrik_kill_skaven = {
	ID_XB1 = 38,
	ID_PS4 = "037",
	name = "achv_skaven_stronghold_skarrik_kill_skaven_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_stronghold_skarrik_kill_skaven",
	desc = function ()
		return string.format(Localize("achv_skaven_stronghold_skarrik_kill_skaven_desc"), QuestSettings.storm_vermin_warlord_kills_enemies)
	end,
	completed = function (arg_188_0, arg_188_1)
		return arg_188_0:get_persistent_stat(arg_188_1, "storm_vermin_warlord_kills_enemies") > 0
	end
}
AchievementTemplates.achievements.ussingen_no_event_barrels = {
	ID_XB1 = 39,
	ID_PS4 = "038",
	name = "achv_ussingen_no_event_barrels_name",
	display_completion_ui = true,
	icon = "achievement_trophy_ussingen_no_event_barrels",
	desc = "achv_ussingen_no_event_barrels_desc",
	completed = function (arg_189_0, arg_189_1)
		return arg_189_0:get_persistent_stat(arg_189_1, "ussingen_used_no_barrels") > 0
	end
}
AchievementTemplates.achievements.skittergate_deathrattler_rasknitt_timed = {
	ID_XB1 = 40,
	ID_PS4 = "039",
	name = "achv_skittergate_deathrattler_rasknitt_timed_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skittergate_deathrattler_rasknitt_timed",
	desc = function ()
		return string.format(Localize("achv_skittergate_deathrattler_rasknitt_timed_desc"), QuestSettings.skittergate_speed_event)
	end,
	completed = function (arg_191_0, arg_191_1)
		return arg_191_0:get_persistent_stat(arg_191_1, "skittergate_speed_event") > 0
	end
}

local var_0_25 = {
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
	completed = function (arg_192_0, arg_192_1)
		for iter_192_0, iter_192_1 in pairs(var_0_25) do
			if not (arg_192_0:get_persistent_stat(arg_192_1, iter_192_1) > 0) then
				return false
			end
		end

		return true
	end,
	progress = function (arg_193_0, arg_193_1)
		local var_193_0 = 0
		local var_193_1 = 0

		for iter_193_0, iter_193_1 in pairs(var_0_25) do
			var_193_1 = var_193_1 + 1

			if arg_193_0:get_persistent_stat(arg_193_1, iter_193_1) > 0 then
				var_193_0 = var_193_0 + 1
			end
		end

		return {
			var_193_0,
			var_193_1
		}
	end,
	requirements = function (arg_194_0, arg_194_1)
		local var_194_0 = {}

		for iter_194_0, iter_194_1 in pairs(var_0_25) do
			local var_194_1 = arg_194_0:get_persistent_stat(arg_194_1, iter_194_1) > 0

			table.insert(var_194_0, {
				name = iter_194_0,
				completed = var_194_1
			})
		end

		return var_194_0
	end
}
AchievementTemplates.achievements.skaven_warpfire_thrower_1 = {
	ID_XB1 = 42,
	name = "achv_skaven_warpfire_thrower_1_name",
	ID_PS4 = "041",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_warpfire_thrower_1",
	desc = "achv_skaven_warpfire_thrower_1_desc",
	completed = function (arg_195_0, arg_195_1)
		return arg_195_0:get_persistent_stat(arg_195_1, "warpfire_kill_before_shooting") > 0
	end
}
AchievementTemplates.achievements.skaven_warpfire_thrower_2 = {
	ID_XB1 = 43,
	name = "achv_skaven_warpfire_thrower_2_name",
	ID_PS4 = "042",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_warpfire_thrower_2",
	desc = "achv_skaven_warpfire_thrower_2_desc",
	completed = function (arg_196_0, arg_196_1)
		return arg_196_0:get_persistent_stat(arg_196_1, "warpfire_kill_on_power_cell") > 0
	end
}
AchievementTemplates.achievements.skaven_warpfire_thrower_3 = {
	name = "achv_skaven_warpfire_thrower_3_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_warpfire_thrower_3",
	desc = function ()
		return string.format(Localize("achv_skaven_warpfire_thrower_3_desc"), QuestSettings.num_enemies_killed_by_warpfire)
	end,
	completed = function (arg_198_0, arg_198_1)
		return arg_198_0:get_persistent_stat(arg_198_1, "warpfire_enemies_killed_by_warpfire") > 0
	end
}
AchievementTemplates.achievements.skaven_pack_master_1 = {
	ID_XB1 = 44,
	name = "achv_skaven_pack_master_1_name",
	ID_PS4 = "043",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_pack_master_1",
	desc = "achv_skaven_pack_master_1_desc",
	completed = function (arg_199_0, arg_199_1)
		return arg_199_0:get_persistent_stat(arg_199_1, "pack_master_kill_abducting_ally") > 0
	end
}
AchievementTemplates.achievements.skaven_pack_master_2 = {
	ID_XB1 = 45,
	name = "achv_skaven_pack_master_2_name",
	ID_PS4 = "044",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_pack_master_2",
	desc = "achv_skaven_pack_master_2_desc",
	completed = function (arg_200_0, arg_200_1)
		return arg_200_0:get_persistent_stat(arg_200_1, "pack_master_dodged_attack") > 0
	end
}
AchievementTemplates.achievements.skaven_pack_master_3 = {
	name = "achv_skaven_pack_master_3_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_pack_master_3",
	desc = "achv_skaven_pack_master_3_desc",
	completed = function (arg_201_0, arg_201_1)
		return arg_201_0:get_persistent_stat(arg_201_1, "pack_master_rescue_hoisted_ally") > 0
	end
}
AchievementTemplates.achievements.skaven_gutter_runner_1 = {
	ID_XB1 = 46,
	name = "achv_skaven_gutter_runner_1_name",
	ID_PS4 = "045",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_gutter_runner_1",
	desc = "achv_skaven_gutter_runner_1_desc",
	completed = function (arg_202_0, arg_202_1)
		return arg_202_0:get_persistent_stat(arg_202_1, "gutter_runner_killed_on_pounce") > 0
	end
}
AchievementTemplates.achievements.skaven_gutter_runner_2 = {
	name = "achv_skaven_gutter_runner_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_gutter_runner_2",
	desc = "achv_skaven_gutter_runner_2_desc",
	completed = function (arg_203_0, arg_203_1)
		return arg_203_0:get_persistent_stat(arg_203_1, "gutter_runner_push_on_target_pounced") > 0
	end
}
AchievementTemplates.achievements.skaven_gutter_runner_3 = {
	name = "achv_skaven_gutter_runner_3_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_gutter_runner_3",
	desc = "achv_skaven_gutter_runner_3_desc",
	completed = function (arg_204_0, arg_204_1)
		return arg_204_0:get_persistent_stat(arg_204_1, "gutter_runner_push_on_pounce") > 0
	end
}
AchievementTemplates.achievements.skaven_poison_wind_globardier_1 = {
	ID_XB1 = 47,
	name = "achv_skaven_poison_wind_globardier_1_name",
	ID_PS4 = "046",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_poison_wind_globardier_1",
	desc = "achv_skaven_poison_wind_globardier_1_desc",
	completed = function (arg_205_0, arg_205_1)
		return arg_205_0:get_persistent_stat(arg_205_1, "globadier_kill_during_suicide") > 0
	end
}
AchievementTemplates.achievements.skaven_poison_wind_globardier_2 = {
	name = "achv_skaven_poison_wind_globardier_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_poison_wind_globardier_2",
	desc = "achv_skaven_poison_wind_globardier_2_desc",
	completed = function (arg_206_0, arg_206_1)
		return arg_206_0:get_persistent_stat(arg_206_1, "globadier_kill_before_throwing") > 0
	end
}
AchievementTemplates.achievements.skaven_poison_wind_globardier_3 = {
	name = "achv_skaven_poison_wind_globardier_3_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_poison_wind_globardier_3",
	desc = function ()
		return string.format(Localize("achv_skaven_poison_wind_globardier_3_desc"), QuestSettings.num_enemies_killed_by_poison)
	end,
	completed = function (arg_208_0, arg_208_1)
		return arg_208_0:get_persistent_stat(arg_208_1, "globadier_enemies_killed_by_poison") > 0
	end
}
AchievementTemplates.achievements.skaven_ratling_gunner_1 = {
	ID_XB1 = 48,
	name = "achv_skaven_ratling_gunner_1_name",
	ID_PS4 = "047",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_ratling_gunner_1",
	desc = "achv_skaven_ratling_gunner_1_desc",
	completed = function (arg_209_0, arg_209_1)
		return arg_209_0:get_persistent_stat(arg_209_1, "ratling_gunner_killed_by_melee") > 0
	end
}
AchievementTemplates.achievements.skaven_ratling_gunner_2 = {
	name = "achv_skaven_ratling_gunner_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_ratling_gunner_2",
	desc = "achv_skaven_ratling_gunner_2_desc",
	completed = function (arg_210_0, arg_210_1)
		return arg_210_0:get_persistent_stat(arg_210_1, "ratling_gunner_killed_while_shooting") > 0
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
	completed = function (arg_211_0, arg_211_1)
		return arg_211_0:get_persistent_stat(arg_211_1, "ratling_gunner_blocked_shot") > 0
	end,
	on_event = function (arg_212_0, arg_212_1, arg_212_2, arg_212_3, arg_212_4)
		if not arg_212_4[1].local_player then
			return
		end

		local var_212_0 = arg_212_4[2]
		local var_212_1 = Unit.alive(var_212_0) and Unit.get_data(var_212_0, "breed")

		if var_212_1 and var_212_1.name == "skaven_ratling_gunner" then
			arg_212_0:increment_stat(arg_212_1, "ratling_gunner_blocked_shot")
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
	completed = function (arg_213_0, arg_213_1)
		return arg_213_0:get_persistent_stat(arg_213_1, "corruptor_dodged_attack") > 0
	end
}
AchievementTemplates.achievements.chaos_corruptor_sorcerer_2 = {
	name = "achv_chaos_corruptor_sorcerer_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_corruptor_sorcerer_2",
	desc = function ()
		return string.format(Localize("achv_chaos_corruptor_sorcerer_2_desc"), QuestSettings.corruptor_killed_at_teleport_time)
	end,
	completed = function (arg_215_0, arg_215_1)
		return arg_215_0:get_persistent_stat(arg_215_1, "corruptor_killed_at_teleport_time") > 0
	end
}
AchievementTemplates.achievements.chaos_corruptor_sorcerer_3 = {
	ID_XB1 = 50,
	name = "achv_chaos_corruptor_sorcerer_3_name",
	ID_PS4 = "049",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_corruptor_sorcerer_3",
	desc = "achv_chaos_corruptor_sorcerer_3_desc",
	completed = function (arg_216_0, arg_216_1)
		return arg_216_0:get_persistent_stat(arg_216_1, "corruptor_killed_while_grabbing") > 0
	end
}
AchievementTemplates.achievements.chaos_vortex_sorcerer_1 = {
	ID_XB1 = 51,
	name = "achv_chaos_vortex_sorcerer_1_name",
	ID_PS4 = "050",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_vortex_sorcerer_1",
	desc = "achv_chaos_vortex_sorcerer_1_desc",
	completed = function (arg_217_0, arg_217_1)
		return arg_217_0:get_persistent_stat(arg_217_1, "vortex_sorcerer_killed_while_summoning") > 0
	end
}
AchievementTemplates.achievements.chaos_vortex_sorcerer_2 = {
	name = "achv_chaos_vortex_sorcerer_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_vortex_sorcerer_2",
	desc = "achv_chaos_vortex_sorcerer_2_desc",
	completed = function (arg_218_0, arg_218_1)
		return arg_218_0:get_persistent_stat(arg_218_1, "vortex_sorcerer_killed_while_ally_in_vortex") > 0
	end
}
AchievementTemplates.achievements.chaos_vortex_sorcerer_3 = {
	name = "achv_chaos_vortex_sorcerer_3_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_vortex_sorcerer_3",
	desc = "achv_chaos_vortex_sorcerer_3_desc",
	completed = function (arg_219_0, arg_219_1)
		return arg_219_0:get_persistent_stat(arg_219_1, "vortex_sorcerer_killed_by_melee") > 0
	end
}
AchievementTemplates.achievements.chaos_spawn_1 = {
	name = "achv_chaos_spawn_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_spawn_1",
	desc = "achv_chaos_spawn_1_desc",
	completed = function (arg_220_0, arg_220_1)
		return arg_220_0:get_persistent_stat(arg_220_1, "chaos_spawn_killed_while_grabbing") > 0
	end
}
AchievementTemplates.achievements.chaos_spawn_2 = {
	name = "achv_chaos_spawn_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_spawn_2",
	desc = "achv_chaos_spawn_2_desc",
	completed = function (arg_221_0, arg_221_1)
		return arg_221_0:get_persistent_stat(arg_221_1, "chaos_spawn_killed_without_having_grabbed") > 0
	end
}
AchievementTemplates.achievements.chaos_troll_1 = {
	name = "achv_chaos_troll_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_troll_1",
	desc = "achv_chaos_troll_1_desc",
	completed = function (arg_222_0, arg_222_1)
		return arg_222_0:get_persistent_stat(arg_222_1, "chaos_troll_killed_without_regen") > 0
	end
}
AchievementTemplates.achievements.chaos_troll_2 = {
	name = "achv_chaos_troll_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_chaos_troll_2",
	desc = "achv_chaos_troll_2_desc",
	completed = function (arg_223_0, arg_223_1)
		return arg_223_0:get_persistent_stat(arg_223_1, "chaos_troll_killed_without_bile_damage") > 0
	end
}
AchievementTemplates.achievements.skaven_rat_ogre_1 = {
	name = "achv_skaven_rat_ogre_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_rat_ogre_1",
	desc = "achv_skaven_rat_ogre_1_desc",
	completed = function (arg_224_0, arg_224_1)
		return arg_224_0:get_persistent_stat(arg_224_1, "rat_ogre_killed_mid_leap") > 0
	end
}
AchievementTemplates.achievements.skaven_rat_ogre_2 = {
	name = "achv_skaven_rat_ogre_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_rat_ogre_2",
	desc = "achv_skaven_rat_ogre_2_desc",
	completed = function (arg_225_0, arg_225_1)
		return arg_225_0:get_persistent_stat(arg_225_1, "rat_ogre_killed_without_dealing_damage") > 0
	end
}
AchievementTemplates.achievements.skaven_stormfiend_1 = {
	name = "achv_skaven_stormfiend_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_stormfiend_1",
	desc = "achv_skaven_stormfiend_1_desc",
	completed = function (arg_226_0, arg_226_1)
		return arg_226_0:get_persistent_stat(arg_226_1, "stormfiend_killed_without_burn_damage") > 0
	end
}
AchievementTemplates.achievements.skaven_stormfiend_2 = {
	name = "achv_skaven_stormfiend_2_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_stormfiend_2",
	desc = "achv_skaven_stormfiend_2_desc",
	completed = function (arg_227_0, arg_227_1)
		return arg_227_0:get_persistent_stat(arg_227_1, "stormfiend_killed_on_controller") > 0
	end
}
AchievementTemplates.achievements.helmgart_lord_1 = {
	name = "achv_helmgart_lord_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_helmgart_lord_1",
	desc = "achv_helmgart_lord_1_desc",
	completed = function (arg_228_0, arg_228_1)
		return arg_228_0:get_persistent_stat(arg_228_1, "killed_lord_as_last_player_standing") > 0
	end
}

DLCUtils.map_list("achievement_template_file_names", local_require)

for iter_0_16, iter_0_17 in ipairs(AchievementTemplates.difficulties) do
	local var_0_26 = DifficultyMapping[iter_0_17]
	local var_0_27 = "kill_bodvarr_burblespew_" .. var_0_26
	local var_0_28 = var_0_5[iter_0_17].rank

	AchievementTemplates.achievements[var_0_27] = {
		name = "achv_kill_bodvarr_burblespew_" .. var_0_26 .. "_name",
		desc = "achv_kill_bodvarr_burblespew_" .. var_0_26 .. "_desc",
		icon = "achievement_trophy_kill_bodvarr_burblespew_" .. var_0_26,
		completed = function (arg_229_0, arg_229_1)
			local var_229_0 = arg_229_0:get_persistent_stat(arg_229_1, "kill_chaos_exalted_champion_difficulty_rank") >= var_0_28
			local var_229_1 = arg_229_0:get_persistent_stat(arg_229_1, "kill_chaos_exalted_sorcerer_difficulty_rank") >= var_0_28

			return var_229_0 and var_229_1
		end,
		requirements = function (arg_230_0, arg_230_1)
			local var_230_0 = arg_230_0:get_persistent_stat(arg_230_1, "kill_chaos_exalted_champion_difficulty_rank") >= var_0_28
			local var_230_1 = arg_230_0:get_persistent_stat(arg_230_1, "kill_chaos_exalted_sorcerer_difficulty_rank") >= var_0_28

			return {
				{
					name = "chaos_exalted_champion",
					completed = var_230_0
				},
				{
					name = "chaos_exalted_sorcerer",
					completed = var_230_1
				}
			}
		end
	}

	local var_0_29 = "kill_skarrik_rasknitt_" .. var_0_26

	AchievementTemplates.achievements[var_0_29] = {
		name = "achv_kill_skarrik_rasknitt_" .. var_0_26 .. "_name",
		desc = "achv_kill_skarrik_rasknitt_" .. var_0_26 .. "_desc",
		icon = "achievement_trophy_kill_skarrik_rasknitt_" .. var_0_26,
		completed = function (arg_231_0, arg_231_1)
			local var_231_0 = arg_231_0:get_persistent_stat(arg_231_1, "kill_skaven_grey_seer_difficulty_rank") >= var_0_28
			local var_231_1 = arg_231_0:get_persistent_stat(arg_231_1, "kill_skaven_storm_vermin_warlord_difficulty_rank") >= var_0_28

			return var_231_0 and var_231_1
		end,
		requirements = function (arg_232_0, arg_232_1)
			local var_232_0 = arg_232_0:get_persistent_stat(arg_232_1, "kill_skaven_grey_seer_difficulty_rank") >= var_0_28
			local var_232_1 = arg_232_0:get_persistent_stat(arg_232_1, "kill_skaven_storm_vermin_warlord_difficulty_rank") >= var_0_28

			return {
				{
					name = "skaven_storm_vermin_warlord",
					completed = var_232_1
				},
				{
					name = "skaven_grey_seer",
					completed = var_232_0
				}
			}
		end
	}
end

for iter_0_18, iter_0_19 in pairs(AchievementTemplates.achievements) do
	iter_0_19.id = iter_0_18
end

return AchievementTemplates
