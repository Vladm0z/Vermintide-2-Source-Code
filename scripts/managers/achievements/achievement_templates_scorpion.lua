-- chunkname: @scripts/managers/achievements/achievement_templates_scorpion.lua

require("scripts/settings/weave_settings")

local var_0_0 = AchievementTemplateHelper.check_level_difficulty
local var_0_1 = AchievementTemplateHelper.check_level_list_difficulty
local var_0_2 = AchievementTemplateHelper.hero_level
local var_0_3 = AchievementTemplateHelper.add_weapon_kill_challenge
local var_0_4 = AchievementTemplateHelper.add_weapon_levels_challenge
local var_0_5 = AchievementTemplateHelper.PLACEHOLDER_ICON

local function var_0_6(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = false
	local var_1_1 = ScorpionSeasonalSettings.get_season_name(arg_1_2)

	for iter_1_0 = 1, 4 do
		local var_1_2 = ScorpionSeasonalSettings.get_weave_score_stat_for_season(arg_1_2, arg_1_3, iter_1_0)

		var_1_0 = arg_1_0:get_persistent_stat(arg_1_1, var_1_1, var_1_2) > 0

		if var_1_0 then
			break
		end
	end

	return var_1_0
end

local function var_0_7(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = false
	local var_2_1 = 0

	for iter_2_0 = arg_2_3, arg_2_4 do
		var_2_0 = var_0_6(arg_2_0, arg_2_1, arg_2_2, iter_2_0)

		if not var_2_0 then
			break
		end

		var_2_1 = var_2_1 + 1
	end

	return var_2_0, var_2_1
end

local var_0_8 = {
	tier_1 = {
		from = 1,
		to = 40
	},
	tier_2 = {
		from = 41,
		to = 80
	},
	tier_3 = {
		from = 81,
		to = 120
	},
	tier_4 = {
		to = 160,
		from = 121,
		disable_for_seasons = {
			2,
			3
		}
	}
}
local var_0_9 = ScorpionSeasonalSettings.current_season_id

for iter_0_0 = 2, var_0_9 do
	local var_0_10 = ScorpionSeasonalSettings.get_season_name(iter_0_0)

	for iter_0_1, iter_0_2 in pairs(var_0_8) do
		local var_0_11 = iter_0_2.disable_for_seasons

		if not var_0_11 or not table.contains(var_0_11, iter_0_0) then
			local var_0_12 = "scorpion_" .. iter_0_1 .. "_season_" .. iter_0_0
			local var_0_13 = iter_0_2.from
			local var_0_14 = iter_0_2.to

			AchievementTemplates.achievements[var_0_12] = {
				required_dlc = "scorpion",
				name = "achv_scorpion_" .. iter_0_1 .. "_seasonal_name",
				desc = "achv_scorpion_" .. iter_0_1 .. "_seasonal_desc",
				icon = "achievement_trophy_scorpion_" .. iter_0_1 .. "_season_" .. iter_0_0,
				disable_on_consoles = iter_0_0 ~= var_0_9,
				completed = function(arg_3_0, arg_3_1)
					local var_3_0, var_3_1 = var_0_7(arg_3_0, arg_3_1, iter_0_0, var_0_13, var_0_14)

					return var_3_0
				end,
				progress = function(arg_4_0, arg_4_1)
					local var_4_0 = var_0_14 - var_0_13 + 1
					local var_4_1, var_4_2 = var_0_7(arg_4_0, arg_4_1, iter_0_0, var_0_13, var_0_14)

					return {
						var_4_2,
						var_4_0
					}
				end
			}
		end
	end

	local var_0_15 = 40
	local var_0_16 = "scorpion_complete_unranked_weaves_season_" .. iter_0_0

	AchievementTemplates.achievements[var_0_16] = {
		ID_XB1 = 78,
		name = "achv_scorpion_complete_unranked_weaves_name",
		desc = "achv_scorpion_complete_unranked_weaves_desc",
		ID_PS4 = "077",
		icon = "achievement_trophy_scorpion_complete_unranked_weaves_season_2",
		required_dlc = "scorpion",
		disable_on_consoles = iter_0_0 ~= var_0_9,
		completed = function(arg_5_0, arg_5_1)
			return arg_5_0:get_persistent_stat(arg_5_1, var_0_10, "weave_quickplay_wins") >= var_0_15
		end,
		progress = function(arg_6_0, arg_6_1)
			local var_6_0 = arg_6_0:get_persistent_stat(arg_6_1, var_0_10, "weave_quickplay_wins")

			return {
				var_6_0,
				var_0_15
			}
		end
	}
end

AchievementTemplates.achievements.scorpion_bardin_reach_level_35 = {
	name = "achv_scorpion_bardin_reach_level_35_name",
	icon = "achievement_trophy_scorpion_bardin_reach_level_35",
	desc = "achv_scorpion_bardin_reach_level_35_desc",
	completed = function(arg_7_0, arg_7_1)
		return var_0_2("dwarf_ranger") >= 35
	end,
	progress = function(arg_8_0, arg_8_1)
		local var_8_0 = var_0_2("dwarf_ranger")
		local var_8_1 = math.min(var_8_0, 35)

		return {
			var_8_1,
			35
		}
	end
}
AchievementTemplates.achievements.scorpion_kerillian_reach_level_35 = {
	name = "achv_scorpion_kerillian_reach_level_35_name",
	icon = "achievement_trophy_scorpion_kerillian_reach_level_35",
	desc = "achv_scorpion_kerillian_reach_level_35_desc",
	completed = function(arg_9_0, arg_9_1)
		return var_0_2("wood_elf") >= 35
	end,
	progress = function(arg_10_0, arg_10_1)
		local var_10_0 = var_0_2("wood_elf")
		local var_10_1 = math.min(var_10_0, 35)

		return {
			var_10_1,
			35
		}
	end
}
AchievementTemplates.achievements.scorpion_markus_reach_level_35 = {
	name = "achv_scorpion_markus_reach_level_35_name",
	icon = "achievement_trophy_scorpion_markus_reach_level_35",
	desc = "achv_scorpion_markus_reach_level_35_desc",
	completed = function(arg_11_0, arg_11_1)
		return var_0_2("empire_soldier") >= 35
	end,
	progress = function(arg_12_0, arg_12_1)
		local var_12_0 = var_0_2("empire_soldier")
		local var_12_1 = math.min(var_12_0, 35)

		return {
			var_12_1,
			35
		}
	end
}
AchievementTemplates.achievements.scorpion_sienna_reach_level_35 = {
	name = "achv_scorpion_sienna_reach_level_35_name",
	icon = "achievement_trophy_scorpion_sienna_reach_level_35",
	desc = "achv_scorpion_sienna_reach_level_35_desc",
	completed = function(arg_13_0, arg_13_1)
		return var_0_2("bright_wizard") >= 35
	end,
	progress = function(arg_14_0, arg_14_1)
		local var_14_0 = var_0_2("bright_wizard")
		local var_14_1 = math.min(var_14_0, 35)

		return {
			var_14_1,
			35
		}
	end
}
AchievementTemplates.achievements.scorpion_victor_reach_level_35 = {
	name = "achv_scorpion_victor_reach_level_35_name",
	icon = "achievement_trophy_scorpion_victor_reach_level_35",
	desc = "achv_scorpion_victor_reach_level_35_desc",
	completed = function(arg_15_0, arg_15_1)
		return var_0_2("witch_hunter") >= 35
	end,
	progress = function(arg_16_0, arg_16_1)
		local var_16_0 = var_0_2("witch_hunter")
		local var_16_1 = math.min(var_16_0, 35)

		return {
			var_16_1,
			35
		}
	end
}
AchievementTemplates.achievements.scorpion_complete_helmgart_act_one_cataclysm = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_helmgart_act_one_cataclysm_name",
	icon = "achievement_trophy_scorpion_complete_act_one_cataclysm",
	desc = "achv_scorpion_complete_helmgart_act_one_cataclysm_desc",
	completed = function(arg_17_0, arg_17_1)
		local var_17_0 = 0
		local var_17_1 = DifficultySettings.cataclysm.rank

		if var_0_0(arg_17_0, arg_17_1, LevelSettings.military.level_id, var_17_1) then
			var_17_0 = var_17_0 + 1
		end

		if var_0_0(arg_17_0, arg_17_1, LevelSettings.catacombs.level_id, var_17_1) then
			var_17_0 = var_17_0 + 1
		end

		if var_0_0(arg_17_0, arg_17_1, LevelSettings.mines.level_id, var_17_1) then
			var_17_0 = var_17_0 + 1
		end

		if var_0_0(arg_17_0, arg_17_1, LevelSettings.ground_zero.level_id, var_17_1) then
			var_17_0 = var_17_0 + 1
		end

		return var_17_0 >= 4
	end,
	progress = function(arg_18_0, arg_18_1)
		local var_18_0 = 0
		local var_18_1 = DifficultySettings.cataclysm.rank

		if var_0_0(arg_18_0, arg_18_1, LevelSettings.military.level_id, var_18_1) then
			var_18_0 = var_18_0 + 1
		end

		if var_0_0(arg_18_0, arg_18_1, LevelSettings.catacombs.level_id, var_18_1) then
			var_18_0 = var_18_0 + 1
		end

		if var_0_0(arg_18_0, arg_18_1, LevelSettings.mines.level_id, var_18_1) then
			var_18_0 = var_18_0 + 1
		end

		if var_0_0(arg_18_0, arg_18_1, LevelSettings.ground_zero.level_id, var_18_1) then
			var_18_0 = var_18_0 + 1
		end

		return {
			var_18_0,
			4
		}
	end,
	requirements = function(arg_19_0, arg_19_1)
		local var_19_0 = DifficultySettings.cataclysm.rank
		local var_19_1 = var_0_0(arg_19_0, arg_19_1, LevelSettings.military.level_id, var_19_0)
		local var_19_2 = var_0_0(arg_19_0, arg_19_1, LevelSettings.catacombs.level_id, var_19_0)
		local var_19_3 = var_0_0(arg_19_0, arg_19_1, LevelSettings.mines.level_id, var_19_0)
		local var_19_4 = var_0_0(arg_19_0, arg_19_1, LevelSettings.ground_zero.level_id, var_19_0)

		return {
			{
				name = "level_name_military",
				completed = var_19_1
			},
			{
				name = "level_name_catacombs",
				completed = var_19_2
			},
			{
				name = "level_name_mines",
				completed = var_19_3
			},
			{
				name = "level_name_ground_zero",
				completed = var_19_4
			}
		}
	end
}
AchievementTemplates.achievements.scorpion_complete_helmgart_act_two_cataclysm = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_helmgart_act_two_cataclysm_name",
	icon = "achievement_trophy_scorpion_complete_act_two_cataclysm",
	desc = "achv_scorpion_complete_helmgart_act_two_cataclysm_desc",
	completed = function(arg_20_0, arg_20_1)
		local var_20_0 = 0
		local var_20_1 = DifficultySettings.cataclysm.rank

		if var_0_0(arg_20_0, arg_20_1, LevelSettings.elven_ruins.level_id, var_20_1) then
			var_20_0 = var_20_0 + 1
		end

		if var_0_0(arg_20_0, arg_20_1, LevelSettings.bell.level_id, var_20_1) then
			var_20_0 = var_20_0 + 1
		end

		if var_0_0(arg_20_0, arg_20_1, LevelSettings.fort.level_id, var_20_1) then
			var_20_0 = var_20_0 + 1
		end

		if var_0_0(arg_20_0, arg_20_1, LevelSettings.skaven_stronghold.level_id, var_20_1) then
			var_20_0 = var_20_0 + 1
		end

		return var_20_0 >= 4
	end,
	progress = function(arg_21_0, arg_21_1)
		local var_21_0 = 0
		local var_21_1 = DifficultySettings.cataclysm.rank

		if var_0_0(arg_21_0, arg_21_1, LevelSettings.elven_ruins.level_id, var_21_1) then
			var_21_0 = var_21_0 + 1
		end

		if var_0_0(arg_21_0, arg_21_1, LevelSettings.bell.level_id, var_21_1) then
			var_21_0 = var_21_0 + 1
		end

		if var_0_0(arg_21_0, arg_21_1, LevelSettings.fort.level_id, var_21_1) then
			var_21_0 = var_21_0 + 1
		end

		if var_0_0(arg_21_0, arg_21_1, LevelSettings.skaven_stronghold.level_id, var_21_1) then
			var_21_0 = var_21_0 + 1
		end

		return {
			var_21_0,
			4
		}
	end,
	requirements = function(arg_22_0, arg_22_1)
		local var_22_0 = DifficultySettings.cataclysm.rank
		local var_22_1 = var_0_0(arg_22_0, arg_22_1, LevelSettings.elven_ruins.level_id, var_22_0)
		local var_22_2 = var_0_0(arg_22_0, arg_22_1, LevelSettings.bell.level_id, var_22_0)
		local var_22_3 = var_0_0(arg_22_0, arg_22_1, LevelSettings.fort.level_id, var_22_0)
		local var_22_4 = var_0_0(arg_22_0, arg_22_1, LevelSettings.skaven_stronghold.level_id, var_22_0)

		return {
			{
				name = "level_name_elven_ruins",
				completed = var_22_1
			},
			{
				name = "level_name_bell",
				completed = var_22_2
			},
			{
				name = "level_name_forest_fort",
				completed = var_22_3
			},
			{
				name = "level_name_skaven_stronghold",
				completed = var_22_4
			}
		}
	end
}
AchievementTemplates.achievements.scorpion_complete_helmgart_act_three_cataclysm = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_helmgart_act_three_cataclysm_name",
	icon = "achievement_trophy_scorpion_complete_act_three_cataclysm",
	desc = "achv_scorpion_complete_helmgart_act_three_cataclysm_desc",
	completed = function(arg_23_0, arg_23_1)
		local var_23_0 = 0
		local var_23_1 = DifficultySettings.cataclysm.rank

		if var_0_0(arg_23_0, arg_23_1, LevelSettings.farmlands.level_id, var_23_1) then
			var_23_0 = var_23_0 + 1
		end

		if var_0_0(arg_23_0, arg_23_1, LevelSettings.ussingen.level_id, var_23_1) then
			var_23_0 = var_23_0 + 1
		end

		if var_0_0(arg_23_0, arg_23_1, LevelSettings.nurgle.level_id, var_23_1) then
			var_23_0 = var_23_0 + 1
		end

		if var_0_0(arg_23_0, arg_23_1, LevelSettings.warcamp.level_id, var_23_1) then
			var_23_0 = var_23_0 + 1
		end

		return var_23_0 >= 4
	end,
	progress = function(arg_24_0, arg_24_1)
		local var_24_0 = 0
		local var_24_1 = DifficultySettings.cataclysm.rank

		if var_0_0(arg_24_0, arg_24_1, LevelSettings.farmlands.level_id, var_24_1) then
			var_24_0 = var_24_0 + 1
		end

		if var_0_0(arg_24_0, arg_24_1, LevelSettings.ussingen.level_id, var_24_1) then
			var_24_0 = var_24_0 + 1
		end

		if var_0_0(arg_24_0, arg_24_1, LevelSettings.nurgle.level_id, var_24_1) then
			var_24_0 = var_24_0 + 1
		end

		if var_0_0(arg_24_0, arg_24_1, LevelSettings.warcamp.level_id, var_24_1) then
			var_24_0 = var_24_0 + 1
		end

		return {
			var_24_0,
			4
		}
	end,
	requirements = function(arg_25_0, arg_25_1)
		local var_25_0 = DifficultySettings.cataclysm.rank
		local var_25_1 = var_0_0(arg_25_0, arg_25_1, LevelSettings.farmlands.level_id, var_25_0)
		local var_25_2 = var_0_0(arg_25_0, arg_25_1, LevelSettings.ussingen.level_id, var_25_0)
		local var_25_3 = var_0_0(arg_25_0, arg_25_1, LevelSettings.nurgle.level_id, var_25_0)
		local var_25_4 = var_0_0(arg_25_0, arg_25_1, LevelSettings.warcamp.level_id, var_25_0)

		return {
			{
				name = "level_name_farmlands",
				completed = var_25_1
			},
			{
				name = "level_name_ussingen",
				completed = var_25_2
			},
			{
				name = "level_name_nurgle",
				completed = var_25_3
			},
			{
				name = "level_name_warcamp",
				completed = var_25_4
			}
		}
	end
}
AchievementTemplates.achievements.scorpion_complete_skittergate_cataclysm = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_skittergate_cataclysm_name",
	icon = "achievement_trophy_scorpion_complete_skittergate_cataclysm",
	desc = "achv_scorpion_complete_skittergate_cataclysm_desc",
	completed = function(arg_26_0, arg_26_1)
		local var_26_0 = DifficultySettings.cataclysm.rank

		return var_0_0(arg_26_0, arg_26_1, LevelSettings.skittergate.level_id, var_26_0)
	end
}

local var_0_17 = (function(arg_27_0)
	local var_27_0

	for iter_27_0, iter_27_1 in ipairs(arg_27_0) do
		if iter_27_1 == "prologue" then
			var_27_0 = iter_27_0
		end
	end

	local var_27_1 = arg_27_0

	if var_27_0 then
		table.remove(var_27_1, var_27_0)
	end

	return var_27_1
end)(MainGameLevels)

AchievementTemplates.achievements.scorpion_complete_all_helmgart_levels_cataclysm = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_all_helmgart_levels_cataclysm_name",
	icon = "achievement_trophy_scorpion_complete_all_helmgart_levels_cataclysm",
	desc = "achv_scorpion_complete_all_helmgart_levels_cataclysm_desc",
	completed = function(arg_28_0, arg_28_1)
		local var_28_0 = DifficultySettings.cataclysm.rank

		return var_0_1(arg_28_0, arg_28_1, var_0_17, var_28_0)
	end,
	progress = function(arg_29_0, arg_29_1)
		local var_29_0 = DifficultySettings.cataclysm.rank
		local var_29_1 = 0

		for iter_29_0, iter_29_1 in ipairs(var_0_17) do
			if var_0_0(arg_29_0, arg_29_1, iter_29_1, var_29_0) then
				var_29_1 = var_29_1 + 1
			end
		end

		return {
			var_29_1,
			#var_0_17
		}
	end,
	requirements = function(arg_30_0, arg_30_1)
		local var_30_0 = {}
		local var_30_1 = DifficultySettings.cataclysm.rank

		for iter_30_0, iter_30_1 in ipairs(var_0_17) do
			local var_30_2 = var_0_0(arg_30_0, arg_30_1, iter_30_1, var_30_1)

			table.insert(var_30_0, {
				name = LevelSettings[iter_30_1].display_name,
				completed = var_30_2
			})
		end

		return var_30_0
	end
}
AchievementTemplates.achievements.scorpion_complete_bogenhafen_cataclysm = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_bogenhafen_cataclysm_name",
	required_dlc_extra = "bogenhafen",
	icon = "achievement_trophy_scorpion_complete_bogenhafen_cataclysm",
	desc = "achv_scorpion_complete_bogenhafen_cataclysm_desc",
	completed = function(arg_31_0, arg_31_1)
		local var_31_0 = 0
		local var_31_1 = DifficultySettings.cataclysm.rank

		if var_0_0(arg_31_0, arg_31_1, LevelSettings.dlc_bogenhafen_slum.level_id, var_31_1) then
			var_31_0 = var_31_0 + 1
		end

		if var_0_0(arg_31_0, arg_31_1, LevelSettings.dlc_bogenhafen_city.level_id, var_31_1) then
			var_31_0 = var_31_0 + 1
		end

		return var_31_0 >= 2
	end,
	progress = function(arg_32_0, arg_32_1)
		local var_32_0 = 0
		local var_32_1 = DifficultySettings.cataclysm.rank

		if var_0_0(arg_32_0, arg_32_1, LevelSettings.dlc_bogenhafen_slum.level_id, var_32_1) then
			var_32_0 = var_32_0 + 1
		end

		if var_0_0(arg_32_0, arg_32_1, LevelSettings.dlc_bogenhafen_city.level_id, var_32_1) then
			var_32_0 = var_32_0 + 1
		end

		return {
			var_32_0,
			2
		}
	end,
	requirements = function(arg_33_0, arg_33_1)
		local var_33_0 = DifficultySettings.cataclysm.rank
		local var_33_1 = var_0_0(arg_33_0, arg_33_1, LevelSettings.dlc_bogenhafen_slum.level_id, var_33_0)
		local var_33_2 = var_0_0(arg_33_0, arg_33_1, LevelSettings.dlc_bogenhafen_city.level_id, var_33_0)

		return {
			{
				name = "level_name_bogenhafen_slum",
				completed = var_33_1
			},
			{
				name = "level_name_bogenhafen_city",
				completed = var_33_2
			}
		}
	end
}
AchievementTemplates.achievements.scorpion_complete_back_to_ubersreik_cataclysm = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_back_to_ubersreik_cataclysm_name",
	required_dlc_extra = "holly",
	icon = "achievement_trophy_scorpion_complete_back_to_ubersreik_cataclysm",
	desc = "achv_scorpion_complete_back_to_ubersreik_cataclysm_desc",
	completed = function(arg_34_0, arg_34_1)
		local var_34_0 = 0
		local var_34_1 = DifficultySettings.cataclysm.rank

		if var_0_0(arg_34_0, arg_34_1, LevelSettings.magnus.level_id, var_34_1) then
			var_34_0 = var_34_0 + 1
		end

		if var_0_0(arg_34_0, arg_34_1, LevelSettings.cemetery.level_id, var_34_1) then
			var_34_0 = var_34_0 + 1
		end

		if var_0_0(arg_34_0, arg_34_1, LevelSettings.forest_ambush.level_id, var_34_1) then
			var_34_0 = var_34_0 + 1
		end

		return var_34_0 >= 3
	end,
	progress = function(arg_35_0, arg_35_1)
		local var_35_0 = 0
		local var_35_1 = DifficultySettings.cataclysm.rank

		if var_0_0(arg_35_0, arg_35_1, LevelSettings.magnus.level_id, var_35_1) then
			var_35_0 = var_35_0 + 1
		end

		if var_0_0(arg_35_0, arg_35_1, LevelSettings.cemetery.level_id, var_35_1) then
			var_35_0 = var_35_0 + 1
		end

		if var_0_0(arg_35_0, arg_35_1, LevelSettings.forest_ambush.level_id, var_35_1) then
			var_35_0 = var_35_0 + 1
		end

		return {
			var_35_0,
			3
		}
	end,
	requirements = function(arg_36_0, arg_36_1)
		local var_36_0 = DifficultySettings.cataclysm.rank
		local var_36_1 = var_0_0(arg_36_0, arg_36_1, LevelSettings.magnus.level_id, var_36_0)
		local var_36_2 = var_0_0(arg_36_0, arg_36_1, LevelSettings.cemetery.level_id, var_36_0)
		local var_36_3 = var_0_0(arg_36_0, arg_36_1, LevelSettings.forest_ambush.level_id, var_36_0)

		return {
			{
				name = "level_name_magnus",
				completed = var_36_1
			},
			{
				name = "level_name_cemetery",
				completed = var_36_2
			},
			{
				name = "level_name_forest_ambush",
				completed = var_36_3
			}
		}
	end
}
AchievementTemplates.achievements.scorpion_complete_plaza_cataclysm = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_plaza_cataclysm_name",
	required_dlc_extra = "holly",
	icon = "achievement_trophy_scorpion_complete_plaza_cataclysm",
	desc = "achv_scorpion_complete_plaza_cataclysm_desc",
	completed = function(arg_37_0, arg_37_1)
		local var_37_0 = 0
		local var_37_1 = DifficultySettings.cataclysm.rank

		if var_0_0(arg_37_0, arg_37_1, LevelSettings.plaza.level_id, var_37_1) then
			var_37_0 = var_37_0 + 1
		end

		return var_37_0 >= 1
	end
}

local function var_0_18(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	local var_38_0 = false
	local var_38_1 = 0
	local var_38_2 = ScorpionSeasonalSettings.current_season_id

	for iter_38_0 = arg_38_2, arg_38_3 do
		for iter_38_1 = 1, 4 do
			local var_38_3 = "weave_score_weave_" .. iter_38_0 .. "_" .. iter_38_1 .. "_players"

			if not IS_WINDOWS then
				for iter_38_2 = 1, var_38_2 do
					if iter_38_2 == 1 then
						var_38_3 = "weave_score_weave_" .. iter_38_0 .. "_" .. iter_38_1 .. "_players"
					else
						var_38_3 = iter_38_0 .. "_" .. iter_38_1
					end

					local var_38_4 = ScorpionSeasonalSettings.get_season_name(iter_38_2)

					var_38_0 = arg_38_0:get_persistent_stat(arg_38_1, var_38_4, var_38_3) > 0

					if var_38_0 then
						break
					end
				end
			else
				var_38_0 = arg_38_0:get_persistent_stat(arg_38_1, "season_1", var_38_3) > 0
			end

			if var_38_0 then
				break
			end
		end

		if not var_38_0 then
			break
		end

		var_38_1 = var_38_1 + 1
	end

	return var_38_0, var_38_1
end

local function var_0_19(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0 = false
	local var_39_1 = 0

	for iter_39_0, iter_39_1 in pairs(WeaveSettings.templates_ordered) do
		if arg_39_2 == iter_39_1.wind then
			for iter_39_2 = 1, 4 do
				local var_39_2 = "weave_score_weave_" .. iter_39_1.tier .. "_" .. iter_39_2 .. "_players"

				var_39_0 = arg_39_0:get_persistent_stat(arg_39_1, "season_1", var_39_2) > 0

				if var_39_0 then
					break
				end
			end

			if not var_39_0 then
				break
			end

			var_39_1 = var_39_1 + 1

			if var_39_1 == arg_39_3 then
				break
			end
		end
	end

	return var_39_0, var_39_1
end

local function var_0_20(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = 0

	for iter_40_0, iter_40_1 in pairs(WeaveSettings.templates_ordered) do
		if arg_40_2 == iter_40_1.wind then
			local var_40_1 = "weave_score_weave_" .. iter_40_1.tier .. "_" .. 1 .. "_players"

			arg_40_0:set_stat(arg_40_1, "season_1", var_40_1, 10)

			var_40_0 = var_40_0 + 1

			if var_40_0 == arg_40_3 then
				break
			end
		end
	end
end

local function var_0_21(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	local var_41_0 = 0

	for iter_41_0, iter_41_1 in pairs(WeaveSettings.templates_ordered) do
		if arg_41_2 == iter_41_1.wind then
			local var_41_1 = "weave_score_weave_" .. iter_41_1.tier .. "_" .. 1 .. "_players"

			arg_41_0:set_stat(arg_41_1, "season_1", var_41_1, 0)

			var_41_0 = var_41_0 + 1

			if var_41_0 == arg_41_3 then
				break
			end
		end
	end
end

local function var_0_22(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = false
	local var_42_1 = 0
	local var_42_2 = #WeaveSettings.winds

	for iter_42_0, iter_42_1 in pairs(WeaveSettings.winds) do
		local var_42_3 = "weave_rainbow_" .. iter_42_1 .. "_" .. arg_42_2 .. "_season_1"

		if arg_42_0:get_persistent_stat(arg_42_1, "season_1", var_42_3) > 0 then
			var_42_1 = var_42_1 + 1
		end
	end

	return var_42_1 == var_42_2, var_42_1
end

local var_0_23 = {
	"life",
	"metal",
	"heavens",
	"light",
	"death",
	"beasts",
	"shadow",
	"fire"
}
local var_0_24 = 5

for iter_0_3 = 1, #var_0_23 do
	local var_0_25 = "scorpion_weaves_" .. iter_0_3 .. "_season_1"
	local var_0_26 = var_0_23[iter_0_3]
	local var_0_27 = WeaveSettings.weave_wind_ranges[var_0_26]

	AchievementTemplates.achievements[var_0_25] = {
		required_dlc = "scorpion",
		name = "achv_scorpion_weaves_" .. iter_0_3 .. "_season_1_name",
		desc = "achv_scorpion_weaves_" .. iter_0_3 .. "_season_1_desc",
		icon = "achievement_trophy_scorpion_weaves_" .. iter_0_3 .. "_season_1",
		completed = function(arg_43_0, arg_43_1)
			local var_43_0 = true

			for iter_43_0 = 1, var_0_24 do
				local var_43_1 = var_0_27[iter_43_0]

				var_43_0 = var_43_0 and var_0_6(arg_43_0, arg_43_1, ScorpionSeasonalSettings.current_season_id, var_43_1)
			end

			return var_43_0
		end,
		progress = function(arg_44_0, arg_44_1)
			local var_44_0 = 0

			for iter_44_0 = 1, var_0_24 do
				local var_44_1 = var_0_27[iter_44_0]

				if var_0_6(arg_44_0, arg_44_1, ScorpionSeasonalSettings.current_season_id, var_44_1) then
					var_44_0 = var_44_0 + 1
				end
			end

			return {
				var_44_0,
				var_0_24
			}
		end
	}
end

AchievementTemplates.achievements.scorpion_complete_unranked_weaves = {
	ID_XB1 = 78,
	name = "achv_scorpion_complete_unranked_weaves_name",
	required_dlc = "scorpion",
	icon = "icons_placeholder",
	ID_PS4 = "077",
	desc = "achv_scorpion_complete_unranked_weaves_desc",
	completed = function(arg_45_0, arg_45_1)
		return arg_45_0:get_persistent_stat(arg_45_1, "season_1", "weave_quickplay_wins") >= 40
	end,
	progress = function(arg_46_0, arg_46_1)
		local var_46_0 = arg_46_0:get_persistent_stat(arg_46_1, "season_1", "weave_quickplay_wins")

		return {
			var_46_0,
			40
		}
	end
}
AchievementTemplates.complete_weaves_list = {
	5,
	10,
	15,
	20,
	25,
	30,
	35,
	40,
	80,
	120
}
AchievementTemplates.xbox_achievement_ids = {
	nil,
	nil,
	nil,
	79,
	nil,
	nil,
	nil,
	80,
	81
}
AchievementTemplates.ps4_achievement_ids = {
	nil,
	nil,
	nil,
	"078",
	nil,
	nil,
	nil,
	"079",
	"080"
}

for iter_0_4, iter_0_5 in ipairs(AchievementTemplates.complete_weaves_list) do
	local var_0_28 = "scorpion_complete_weaves_" .. iter_0_4

	AchievementTemplates.achievements[var_0_28] = {
		required_dlc = "scorpion",
		name = "achv_scorpion_complete_weaves_" .. iter_0_4 .. "_name",
		desc = function()
			return string.format(Localize("achv_scorpion_complete_weaves_" .. iter_0_4 .. "_desc"), iter_0_5)
		end,
		ID_XB1 = AchievementTemplates.xbox_achievement_ids[iter_0_4],
		ID_PS4 = AchievementTemplates.ps4_achievement_ids[iter_0_4],
		icon = "achievement_trophy_scorpion_complete_weaves_" .. iter_0_4,
		completed = function(arg_48_0, arg_48_1)
			local var_48_0 = 1
			local var_48_1 = iter_0_5
			local var_48_2, var_48_3 = var_0_18(arg_48_0, arg_48_1, var_48_0, var_48_1)

			if not IS_WINDOWS then
				return var_48_2
			else
				local var_48_4 = arg_48_0:get_persistent_stat(arg_48_1, "scorpion_weaves_won")

				return math.min(var_48_3 + var_48_4, iter_0_5) >= iter_0_5
			end
		end,
		progress = function(arg_49_0, arg_49_1)
			local var_49_0 = 1
			local var_49_1 = iter_0_5
			local var_49_2, var_49_3 = var_0_18(arg_49_0, arg_49_1, var_49_0, var_49_1)

			if not IS_WINDOWS then
				return {
					var_49_3,
					iter_0_5
				}
			else
				local var_49_4 = arg_49_0:get_persistent_stat(arg_49_1, "scorpion_weaves_won")
				local var_49_5 = math.min(var_49_3 + var_49_4, iter_0_5)

				return {
					var_49_5,
					iter_0_5
				}
			end
		end
	}
end

AchievementTemplates._list_of_weaves_from_to = {
	weaves_9 = {
		from = 41,
		to = 60
	},
	weaves_10 = {
		from = 61,
		to = 80
	},
	weaves_11 = {
		from = 81,
		to = 120
	}
}

for iter_0_6, iter_0_7 in pairs(AchievementTemplates._list_of_weaves_from_to) do
	local var_0_29 = "scorpion_" .. iter_0_6 .. "_season_1"

	AchievementTemplates.achievements[var_0_29] = {
		required_dlc = "scorpion",
		name = "achv_scorpion_" .. iter_0_6 .. "_season_1_name",
		desc = "achv_scorpion_" .. iter_0_6 .. "_season_1_desc",
		icon = "achievement_trophy_scorpion_" .. iter_0_6 .. "_season_1",
		completed = function(arg_50_0, arg_50_1)
			local var_50_0 = iter_0_7.from
			local var_50_1 = iter_0_7.to
			local var_50_2, var_50_3 = var_0_7(arg_50_0, arg_50_1, ScorpionSeasonalSettings.current_season_id, var_50_0, var_50_1)

			return var_50_2
		end,
		progress = function(arg_51_0, arg_51_1)
			local var_51_0 = iter_0_7.from
			local var_51_1 = iter_0_7.to
			local var_51_2 = var_51_1 - var_51_0 + 1
			local var_51_3, var_51_4 = var_0_7(arg_51_0, arg_51_1, ScorpionSeasonalSettings.current_season_id, var_51_0, var_51_1)

			return {
				var_51_4,
				var_51_2
			}
		end
	}
end

local var_0_30 = PROFILES_BY_AFFILIATION.heroes

for iter_0_8 = 1, #var_0_30 do
	local var_0_31 = FindProfileIndex(var_0_30[iter_0_8])

	for iter_0_9, iter_0_10 in pairs(SPProfiles[var_0_31].careers) do
		local var_0_32 = iter_0_10.name
		local var_0_33 = CareerNameAchievementMapping[var_0_32]
		local var_0_34 = "scorpion_weaves_complete_" .. var_0_32 .. "_season_1"

		AchievementTemplates.achievements[var_0_34] = {
			required_dlc = "scorpion",
			name = "achv_scorpion_weaves_complete_" .. var_0_33 .. "_season_1_name",
			desc = "achv_scorpion_weaves_complete_" .. var_0_33 .. "_season_1_desc",
			icon = "achievement_trophy_scorpion_weaves_complete_" .. var_0_33 .. "_season_1",
			completed = function(arg_52_0, arg_52_1)
				local var_52_0 = "weaves_complete_" .. var_0_32 .. "_season_1"

				return 40 <= arg_52_0:get_persistent_stat(arg_52_1, "season_1", var_52_0)
			end,
			progress = function(arg_53_0, arg_53_1)
				local var_53_0 = "weaves_complete_" .. var_0_32 .. "_season_1"
				local var_53_1 = 40
				local var_53_2 = arg_53_0:get_persistent_stat(arg_53_1, "season_1", var_53_0)

				return {
					var_53_2,
					var_53_1
				}
			end
		}

		local var_0_35 = "scorpion_weaves_rainbow_" .. var_0_32 .. "_season_1"

		AchievementTemplates.achievements[var_0_35] = {
			required_dlc = "scorpion",
			name = "achv_scorpion_weaves_rainbow_" .. var_0_33 .. "_season_1_name",
			desc = "achv_scorpion_weaves_rainbow_" .. var_0_33 .. "_season_1_desc",
			icon = "achievement_trophy_scorpion_weaves_rainbow_" .. var_0_33 .. "_season_1",
			completed = function(arg_54_0, arg_54_1)
				return var_0_22(arg_54_0, arg_54_1, var_0_32)
			end,
			progress = function(arg_55_0, arg_55_1)
				local var_55_0 = #WeaveSettings.winds
				local var_55_1, var_55_2 = var_0_22(arg_55_0, arg_55_1, var_0_32)

				return {
					var_55_2,
					var_55_0
				}
			end
		}
	end
end

AchievementTemplates.achievements.scorpion_weaves_life_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_life_season_1_name",
	icon = "achievement_trophy_scorpion_weaves_life_season_1",
	desc = "achv_scorpion_weaves_life_season_1_desc",
	completed = function(arg_56_0, arg_56_1)
		local var_56_0 = "scorpion_weaves_life_season_1"

		return arg_56_0:get_persistent_stat(arg_56_1, "season_1", var_56_0) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_heavens_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_heavens_season_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_scorpion_weaves_heavens_season_1",
	desc = "achv_scorpion_weaves_heavens_season_1_desc",
	completed = function(arg_57_0, arg_57_1)
		local var_57_0 = "scorpion_weaves_heavens_season_1"

		return arg_57_0:get_persistent_stat(arg_57_1, "season_1", var_57_0) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_death_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_death_season_1_name",
	icon = "achievement_trophy_scorpion_weaves_death_season_1",
	desc = "achv_scorpion_weaves_death_season_1_desc",
	completed = function(arg_58_0, arg_58_1)
		local var_58_0 = "scorpion_weaves_death_season_1"

		return arg_58_0:get_persistent_stat(arg_58_1, "season_1", var_58_0) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_beasts_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_beasts_season_1_name",
	icon = "achievement_trophy_scorpion_weaves_beasts_season_1",
	desc = "achv_scorpion_weaves_beasts_season_1_desc",
	completed = function(arg_59_0, arg_59_1)
		local var_59_0 = "scorpion_weaves_beasts_season_1"

		return arg_59_0:get_persistent_stat(arg_59_1, "season_1", var_59_0) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_light_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_light_season_1_name",
	icon = "achievement_trophy_scorpion_weaves_light_season_1",
	desc = "achv_scorpion_weaves_light_season_1_desc",
	completed = function(arg_60_0, arg_60_1)
		local var_60_0 = "scorpion_weaves_light_season_1"

		return arg_60_0:get_persistent_stat(arg_60_1, "season_1", var_60_0) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_fire_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_fire_season_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_scorpion_weaves_fire_season_1",
	desc = "achv_scorpion_weaves_fire_season_1_desc",
	completed = function(arg_61_0, arg_61_1)
		local var_61_0 = "scorpion_weaves_fire_season_1"

		return arg_61_0:get_persistent_stat(arg_61_1, "season_1", var_61_0) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_shadow_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_shadow_season_1_name",
	icon = "achievement_trophy_scorpion_weaves_shadow_season_1",
	desc = "achv_scorpion_weaves_shadow_season_1_desc",
	completed = function(arg_62_0, arg_62_1)
		local var_62_0 = "scorpion_weaves_shadow_season_1"

		return arg_62_0:get_persistent_stat(arg_62_1, "season_1", var_62_0) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_metal_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_metal_season_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_scorpion_weaves_metal_season_1",
	desc = function()
		return string.format(Localize("achv_scorpion_weaves_metal_season_1_desc"), QuestSettings.bladestorm_duration)
	end,
	completed = function(arg_64_0, arg_64_1)
		local var_64_0 = "scorpion_weaves_metal_season_1"

		return arg_64_0:get_persistent_stat(arg_64_1, "season_1", var_64_0) > 0
	end
}
AchievementTemplates.achievements.elven_ruins_align_leylines_timed_cata = {
	required_dlc = "scorpion",
	name = "achv_elven_ruins_align_leylines_timed_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_elven_ruins_align_leylines_timed_cata",
	desc = function()
		return string.format(Localize("achv_elven_ruins_align_leylines_timed_cata_desc"), QuestSettings.elven_ruins_speed_event_cata)
	end,
	completed = function(arg_66_0, arg_66_1)
		return arg_66_0:get_persistent_stat(arg_66_1, "elven_ruins_speed_event_cata") > 0
	end
}
AchievementTemplates.achievements.farmlands_rescue_prisoners_timed_cata = {
	required_dlc = "scorpion",
	name = "achv_farmlands_rescue_prisoners_timed_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_farmlands_rescue_prisoners_timed_cata",
	desc = function()
		return string.format(Localize("achv_farmlands_rescue_prisoners_timed_cata_desc"), QuestSettings.farmlands_speed_event)
	end,
	completed = function(arg_68_0, arg_68_1)
		return arg_68_0:get_persistent_stat(arg_68_1, "farmlands_speed_event_cata") > 0
	end
}
AchievementTemplates.achievements.military_kill_chaos_warriors_in_event_cata = {
	required_dlc = "scorpion",
	name = "achv_military_kill_chaos_warriors_in_event_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_military_kill_chaos_warriors_in_event_cata",
	desc = function()
		return string.format(Localize("achv_military_kill_chaos_warriors_in_event_cata_desc"), 3)
	end,
	completed = function(arg_70_0, arg_70_1)
		return arg_70_0:get_persistent_stat(arg_70_1, "military_statue_kill_chaos_warriors_cata") > 0
	end
}
AchievementTemplates.achievements.ground_zero_burblespew_tornado_enemies_cata = {
	required_dlc = "scorpion",
	name = "achv_ground_zero_burblespew_tornado_enemies_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_ground_zero_burblespew_tornado_enemies_cata",
	desc = function()
		return string.format(Localize("achv_ground_zero_burblespew_tornado_enemies_cata_desc"), QuestSettings.halescourge_tornado_enemies_cata)
	end,
	completed = function(arg_72_0, arg_72_1)
		return arg_72_0:get_persistent_stat(arg_72_1, "halescourge_tornado_enemies_cata") > 0
	end
}
AchievementTemplates.achievements.fort_kill_enemies_cannonball_cata = {
	required_dlc = "scorpion",
	name = "achv_fort_kill_enemies_cannonball_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_fort_kill_enemies_cannonball_cata",
	desc = function()
		return string.format(Localize("achv_fort_kill_enemies_cannonball_cata_desc"), QuestSettings.forest_fort_kill_cannonball_cata)
	end,
	completed = function(arg_74_0, arg_74_1)
		return arg_74_0:get_persistent_stat(arg_74_1, "forest_fort_kill_cannonball_cata") > 0
	end
}
AchievementTemplates.achievements.nurgle_player_showered_in_pus_cata = {
	required_dlc = "scorpion",
	name = "achv_nurgle_player_showered_in_pus_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_nurgle_player_showered_in_pus",
	desc = function()
		return string.format(Localize("achv_nurgle_player_showered_in_pus_cata_desc"), QuestSettings.nurgle_bathed_all_cata)
	end,
	completed = function(arg_76_0, arg_76_1)
		return arg_76_0:get_persistent_stat(arg_76_1, "nurgle_bathed_all_cata") > 0
	end
}
AchievementTemplates.achievements.bell_destroy_bell_flee_timed_cata = {
	required_dlc = "scorpion",
	name = "achv_bell_destroy_bell_flee_timed_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_bell_destroy_bell_flee_timed_cata",
	desc = function()
		return string.format(Localize("achv_bell_destroy_bell_flee_timed_cata_desc"), QuestSettings.bell_speed_event_cata)
	end,
	completed = function(arg_78_0, arg_78_1)
		return arg_78_0:get_persistent_stat(arg_78_1, "bell_speed_event_cata") > 0
	end
}
AchievementTemplates.achievements.catacombs_stay_inside_ritual_pool_cata = {
	required_dlc = "scorpion",
	name = "achv_catacombs_stay_inside_ritual_pool_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_catacombs_stay_inside_ritual_pool_cata",
	desc = function()
		return string.format(Localize("achv_catacombs_stay_inside_ritual_pool_cata_desc"), QuestSettings.volume_corpse_pit_damage_cata)
	end,
	completed = function(arg_80_0, arg_80_1)
		return arg_80_0:get_persistent_stat(arg_80_1, "catacombs_added_souls_cata") > 0
	end
}
AchievementTemplates.achievements.mines_kill_final_troll_timed_cata = {
	required_dlc = "scorpion",
	name = "achv_mines_kill_final_troll_timed_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_mines_kill_final_troll_timed_cata",
	desc = function()
		return string.format(Localize("achv_mines_kill_final_troll_timed_cata_desc"), QuestSettings.mines_speed_event_cata)
	end,
	completed = function(arg_82_0, arg_82_1)
		return arg_82_0:get_persistent_stat(arg_82_1, "mines_speed_event_cata") > 0
	end
}
AchievementTemplates.achievements.warcamp_bodvarr_charge_warriors_cata = {
	required_dlc = "scorpion",
	name = "achv_warcamp_bodvarr_charge_warriors_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_warcamp_bodvarr_charge_warriors_cata",
	desc = function()
		return string.format(Localize("achv_warcamp_bodvarr_charge_warriors_cata_desc"), QuestSettings.exalted_champion_charge_chaos_warrior_cata)
	end,
	completed = function(arg_84_0, arg_84_1)
		return arg_84_0:get_persistent_stat(arg_84_1, "exalted_champion_charge_chaos_warrior_cata") > 0
	end
}
AchievementTemplates.achievements.skaven_stronghold_skarrik_kill_skaven_cata = {
	required_dlc = "scorpion",
	name = "achv_skaven_stronghold_skarrik_kill_skaven_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_stronghold_skarrik_kill_skaven_cata",
	desc = function()
		return string.format(Localize("achv_skaven_stronghold_skarrik_kill_skaven_cata_desc"), QuestSettings.storm_vermin_warlord_kills_enemies_cata)
	end,
	completed = function(arg_86_0, arg_86_1)
		return arg_86_0:get_persistent_stat(arg_86_1, "storm_vermin_warlord_kills_enemies_cata") > 0
	end
}
AchievementTemplates.achievements.ussingen_no_event_barrels_cata = {
	required_dlc = "scorpion",
	name = "achv_ussingen_no_event_barrels_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_ussingen_no_event_barrels_cata",
	desc = "achv_ussingen_no_event_barrels_cata_desc",
	completed = function(arg_87_0, arg_87_1)
		return arg_87_0:get_persistent_stat(arg_87_1, "ussingen_used_no_barrels_cata") > 0
	end
}
AchievementTemplates.achievements.skittergate_deathrattler_rasknitt_timed_cata = {
	required_dlc = "scorpion",
	name = "achv_skittergate_deathrattler_rasknitt_timed_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skittergate_deathrattler_rasknitt_timed_cata",
	desc = function()
		return string.format(Localize("achv_skittergate_deathrattler_rasknitt_timed_cata_desc"), QuestSettings.skittergate_speed_event_cata)
	end,
	completed = function(arg_89_0, arg_89_1)
		return arg_89_0:get_persistent_stat(arg_89_1, "skittergate_speed_event_cata") > 0
	end
}

local var_0_36 = {
	achv_mines_kill_final_troll_timed_cata_name = "mines_speed_event_cata",
	achv_ussingen_no_event_barrels_cata_name = "ussingen_used_no_barrels_cata",
	achv_military_kill_chaos_warriors_in_event_cata_name = "military_statue_kill_chaos_warriors_cata",
	achv_bell_destroy_bell_flee_timed_cata_name = "bell_speed_event_cata",
	achv_ground_zero_burblespew_tornado_enemies_cata_name = "halescourge_tornado_enemies_cata",
	achv_catacombs_stay_inside_ritual_pool_cata_name = "catacombs_added_souls_cata",
	achv_elven_ruins_align_leylines_timed_cata_name = "elven_ruins_speed_event_cata",
	achv_fort_kill_enemies_cannonball_cata_name = "forest_fort_kill_cannonball_cata",
	achv_farmlands_rescue_prisoners_timed_cata_name = "farmlands_speed_event_cata",
	achv_skaven_stronghold_skarrik_kill_skaven_cata_name = "storm_vermin_warlord_kills_enemies_cata",
	achv_skittergate_deathrattler_rasknitt_timed_cata_name = "skittergate_speed_event_cata",
	achv_nurgle_player_showered_in_pus_cata_name = "nurgle_bathed_all_cata",
	achv_warcamp_bodvarr_charge_warriors_cata_name = "exalted_champion_charge_chaos_warrior_cata"
}

AchievementTemplates.achievements.complete_all_helmgart_level_achievements_cata = {
	name = "achv_complete_all_helmgart_level_achievements_cata_name",
	icon = "achievement_trophy_complete_all_helmgart_level_achievements_cata",
	desc = "achv_complete_all_helmgart_level_achievements_cata_desc",
	completed = function(arg_90_0, arg_90_1)
		for iter_90_0, iter_90_1 in pairs(var_0_36) do
			if not (arg_90_0:get_persistent_stat(arg_90_1, iter_90_1) > 0) then
				return false
			end
		end

		return true
	end,
	progress = function(arg_91_0, arg_91_1)
		local var_91_0 = 0
		local var_91_1 = 0

		for iter_91_0, iter_91_1 in pairs(var_0_36) do
			var_91_1 = var_91_1 + 1

			if arg_91_0:get_persistent_stat(arg_91_1, iter_91_1) > 0 then
				var_91_0 = var_91_0 + 1
			end
		end

		return {
			var_91_0,
			var_91_1
		}
	end,
	requirements = function(arg_92_0, arg_92_1)
		local var_92_0 = {}

		for iter_92_0, iter_92_1 in pairs(var_0_36) do
			local var_92_1 = arg_92_0:get_persistent_stat(arg_92_1, iter_92_1) > 0

			table.insert(var_92_0, {
				name = iter_92_0,
				completed = var_92_1
			})
		end

		return var_92_0
	end
}
AchievementTemplates.achievements.scorpion_cataclysm_unlock_kill_all_lords = {
	required_dlc = "scorpion",
	name = "achv_scorpion_cataclysm_unlock_kill_all_lords_name",
	icon = "achivement_trophy_scorpion_cataclysm_unlock_kill_all_lords",
	desc = "achv_scorpion_cataclysm_unlock_kill_all_lords_desc",
	completed = function(arg_93_0, arg_93_1)
		local var_93_0 = arg_93_0:get_persistent_stat(arg_93_1, "kill_chaos_exalted_champion_scorpion_hardest") >= 5
		local var_93_1 = arg_93_0:get_persistent_stat(arg_93_1, "kill_chaos_exalted_sorcerer_scorpion_hardest") >= 5
		local var_93_2 = arg_93_0:get_persistent_stat(arg_93_1, "kill_skaven_grey_seer_scorpion_hardest") >= 5
		local var_93_3 = arg_93_0:get_persistent_stat(arg_93_1, "kill_skaven_storm_vermin_warlord_scorpion_hardest") >= 5

		return var_93_0 and var_93_1 and var_93_2 and var_93_3
	end,
	requirements = function(arg_94_0, arg_94_1)
		local var_94_0 = arg_94_0:get_persistent_stat(arg_94_1, "kill_chaos_exalted_champion_scorpion_hardest") >= 5
		local var_94_1 = arg_94_0:get_persistent_stat(arg_94_1, "kill_chaos_exalted_sorcerer_scorpion_hardest") >= 5
		local var_94_2 = arg_94_0:get_persistent_stat(arg_94_1, "kill_skaven_grey_seer_scorpion_hardest") >= 5
		local var_94_3 = arg_94_0:get_persistent_stat(arg_94_1, "kill_skaven_storm_vermin_warlord_scorpion_hardest") >= 5

		return {
			{
				name = "chaos_exalted_champion",
				completed = var_94_0
			},
			{
				name = "chaos_exalted_sorcerer",
				completed = var_94_1
			},
			{
				name = "skaven_storm_vermin_warlord",
				completed = var_94_3
			},
			{
				name = "skaven_grey_seer",
				completed = var_94_2
			}
		}
	end
}

local var_0_37 = AchievementTemplates.achievements
local var_0_38

var_0_3(var_0_37, "scorpion_bardin_weapon_skin_1", "dr_1h_throwing_axes", 1000, var_0_38, "scorpion")
var_0_3(var_0_37, "scorpion_kerillian_weapon_skin_1", "we_1h_spears_shield", 1000, var_0_38, "scorpion")
var_0_3(var_0_37, "scorpion_markus_weapon_skin_1", "es_2h_heavy_spear", 1000, var_0_38, "scorpion")
var_0_3(var_0_37, "scorpion_sienna_weapon_skin_1", "bw_1h_flail_flaming", 1000, var_0_38, "scorpion")
var_0_3(var_0_37, "scorpion_victor_weapon_skin_1", "wh_2h_billhook", 1000, var_0_38, "scorpion")

local var_0_39 = {
	"warcamp",
	"skaven_stronghold",
	"ground_zero",
	"skittergate"
}
local var_0_40 = "hardest"

var_0_4(var_0_37, "scorpion_bardin_weapon_skin_2", "dr_1h_throwing_axes", var_0_39, var_0_40, var_0_38, "scorpion")
var_0_4(var_0_37, "scorpion_kerillian_weapon_skin_2", "we_1h_spears_shield", var_0_39, var_0_40, var_0_38, "scorpion")
var_0_4(var_0_37, "scorpion_markus_weapon_skin_2", "es_2h_heavy_spear", var_0_39, var_0_40, var_0_38, "scorpion")
var_0_4(var_0_37, "scorpion_sienna_weapon_skin_2", "bw_1h_flail_flaming", var_0_39, var_0_40, var_0_38, "scorpion")
var_0_4(var_0_37, "scorpion_victor_weapon_skin_2", "wh_2h_billhook", var_0_39, var_0_40, var_0_38, "scorpion")
