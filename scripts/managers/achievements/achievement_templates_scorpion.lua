-- chunkname: @scripts/managers/achievements/achievement_templates_scorpion.lua

require("scripts/settings/weave_settings")

local check_level_difficulty = AchievementTemplateHelper.check_level_difficulty
local check_level_list_difficulty = AchievementTemplateHelper.check_level_list_difficulty
local hero_level = AchievementTemplateHelper.hero_level
local add_weapon_kill_challenge = AchievementTemplateHelper.add_weapon_kill_challenge
local add_weapon_levels_challenge = AchievementTemplateHelper.add_weapon_levels_challenge
local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON

local function fn(self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local flag = false
	local get_season_name = ScorpionSeasonalSettings.get_season_name(arg_1_2)

	for i = 1, 4 do
		local get_weave_score_stat_for_season = ScorpionSeasonalSettings.get_weave_score_stat_for_season(arg_1_2, arg_1_3, i)

		flag = self:get_persistent_stat(arg_1_1, get_season_name, get_weave_score_stat_for_season) > 0

		if not flag then
			break
		end
	end

	return flag
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local flag = false
	local num = 0

	for i = arg_2_3, arg_2_4 do
		flag = fn(arg_2_0, arg_2_1, arg_2_2, i)

		if not flag then
			break
		end

		num = num + 1
	end

	return flag, num
end

local tbl = {
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
local current_season_id = ScorpionSeasonalSettings.current_season_id

for i = 2, current_season_id do
	local get_season_name = ScorpionSeasonalSettings.get_season_name(i)

	for k, v in pairs(tbl) do
		local disable_for_seasons = v.disable_for_seasons

		if not (not disable_for_seasons and table.contains(disable_for_seasons, i)) then
			local str = "scorpion_" .. k .. "_season_" .. i
			local from = v.from
			local to = v.to

			AchievementTemplates.achievements[str] = {
				required_dlc = "scorpion",
				name = "achv_scorpion_" .. k .. "_seasonal_name",
				desc = "achv_scorpion_" .. k .. "_seasonal_desc",
				icon = "achievement_trophy_scorpion_" .. k .. "_season_" .. i,
				disable_on_consoles = i ~= current_season_id,
				completed = function (arg_3_0, arg_3_1)
					-- function 3
					local var_3_0, var_3_1 = fn_2(arg_3_0, arg_3_1, i, from, to)

					return var_3_0
				end,
				progress = function (arg_4_0, arg_4_1)
					-- function 4
					local num = to - from + 1
					local var_4_1, var_4_2 = fn_2(arg_4_0, arg_4_1, i, from, to)

					return {
						var_4_2,
						num
					}
				end
			}
		end
	end

	local num = 40
	local str_2 = "scorpion_complete_unranked_weaves_season_" .. i

	AchievementTemplates.achievements[str_2] = {
		ID_XB1 = 78,
		name = "achv_scorpion_complete_unranked_weaves_name",
		desc = "achv_scorpion_complete_unranked_weaves_desc",
		ID_PS4 = "077",
		icon = "achievement_trophy_scorpion_complete_unranked_weaves_season_2",
		required_dlc = "scorpion",
		disable_on_consoles = i ~= current_season_id,
		completed = function (self, arg_5_1)
			-- function 5
			return self:get_persistent_stat(arg_5_1, get_season_name, "weave_quickplay_wins") >= num
		end,
		progress = function (self, arg_6_1)
			-- function 6
			local get_persistent_stat = self:get_persistent_stat(arg_6_1, get_season_name, "weave_quickplay_wins")

			return {
				get_persistent_stat,
				num
			}
		end
	}
end

AchievementTemplates.achievements.scorpion_bardin_reach_level_35 = {
	name = "achv_scorpion_bardin_reach_level_35_name",
	icon = "achievement_trophy_scorpion_bardin_reach_level_35",
	desc = "achv_scorpion_bardin_reach_level_35_desc",
	completed = function (arg_7_0, arg_7_1)
		-- function 7
		return hero_level("dwarf_ranger") >= 35
	end,
	progress = function (arg_8_0, arg_8_1)
		-- function 8
		local var_8_0 = hero_level("dwarf_ranger")
		local min = math.min(var_8_0, 35)

		return {
			min,
			35
		}
	end
}
AchievementTemplates.achievements.scorpion_kerillian_reach_level_35 = {
	name = "achv_scorpion_kerillian_reach_level_35_name",
	icon = "achievement_trophy_scorpion_kerillian_reach_level_35",
	desc = "achv_scorpion_kerillian_reach_level_35_desc",
	completed = function (arg_9_0, arg_9_1)
		-- function 9
		return hero_level("wood_elf") >= 35
	end,
	progress = function (arg_10_0, arg_10_1)
		-- function 10
		local var_10_0 = hero_level("wood_elf")
		local min = math.min(var_10_0, 35)

		return {
			min,
			35
		}
	end
}
AchievementTemplates.achievements.scorpion_markus_reach_level_35 = {
	name = "achv_scorpion_markus_reach_level_35_name",
	icon = "achievement_trophy_scorpion_markus_reach_level_35",
	desc = "achv_scorpion_markus_reach_level_35_desc",
	completed = function (arg_11_0, arg_11_1)
		-- function 11
		return hero_level("empire_soldier") >= 35
	end,
	progress = function (arg_12_0, arg_12_1)
		-- function 12
		local var_12_0 = hero_level("empire_soldier")
		local min = math.min(var_12_0, 35)

		return {
			min,
			35
		}
	end
}
AchievementTemplates.achievements.scorpion_sienna_reach_level_35 = {
	name = "achv_scorpion_sienna_reach_level_35_name",
	icon = "achievement_trophy_scorpion_sienna_reach_level_35",
	desc = "achv_scorpion_sienna_reach_level_35_desc",
	completed = function (arg_13_0, arg_13_1)
		-- function 13
		return hero_level("bright_wizard") >= 35
	end,
	progress = function (arg_14_0, arg_14_1)
		-- function 14
		local var_14_0 = hero_level("bright_wizard")
		local min = math.min(var_14_0, 35)

		return {
			min,
			35
		}
	end
}
AchievementTemplates.achievements.scorpion_victor_reach_level_35 = {
	name = "achv_scorpion_victor_reach_level_35_name",
	icon = "achievement_trophy_scorpion_victor_reach_level_35",
	desc = "achv_scorpion_victor_reach_level_35_desc",
	completed = function (arg_15_0, arg_15_1)
		-- function 15
		return hero_level("witch_hunter") >= 35
	end,
	progress = function (arg_16_0, arg_16_1)
		-- function 16
		local var_16_0 = hero_level("witch_hunter")
		local min = math.min(var_16_0, 35)

		return {
			min,
			35
		}
	end
}
AchievementTemplates.achievements.scorpion_complete_helmgart_act_one_cataclysm = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_helmgart_act_one_cataclysm_name",
	icon = "achievement_trophy_scorpion_complete_act_one_cataclysm",
	desc = "achv_scorpion_complete_helmgart_act_one_cataclysm_desc",
	completed = function (arg_17_0, arg_17_1)
		-- function 17
		local num = 0
		local rank = DifficultySettings.cataclysm.rank

		if not check_level_difficulty(arg_17_0, arg_17_1, LevelSettings.military.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_17_0, arg_17_1, LevelSettings.catacombs.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_17_0, arg_17_1, LevelSettings.mines.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_17_0, arg_17_1, LevelSettings.ground_zero.level_id, rank) then
			num = num + 1
		end

		return num >= 4
	end,
	progress = function (arg_18_0, arg_18_1)
		-- function 18
		local num = 0
		local rank = DifficultySettings.cataclysm.rank

		if not check_level_difficulty(arg_18_0, arg_18_1, LevelSettings.military.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_18_0, arg_18_1, LevelSettings.catacombs.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_18_0, arg_18_1, LevelSettings.mines.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_18_0, arg_18_1, LevelSettings.ground_zero.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_19_0, arg_19_1)
		-- function 19
		local rank = DifficultySettings.cataclysm.rank
		local var_19_1 = check_level_difficulty(arg_19_0, arg_19_1, LevelSettings.military.level_id, rank)
		local var_19_2 = check_level_difficulty(arg_19_0, arg_19_1, LevelSettings.catacombs.level_id, rank)
		local var_19_3 = check_level_difficulty(arg_19_0, arg_19_1, LevelSettings.mines.level_id, rank)
		local var_19_4 = check_level_difficulty(arg_19_0, arg_19_1, LevelSettings.ground_zero.level_id, rank)

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
	completed = function (arg_20_0, arg_20_1)
		-- function 20
		local num = 0
		local rank = DifficultySettings.cataclysm.rank

		if not check_level_difficulty(arg_20_0, arg_20_1, LevelSettings.elven_ruins.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_20_0, arg_20_1, LevelSettings.bell.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_20_0, arg_20_1, LevelSettings.fort.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_20_0, arg_20_1, LevelSettings.skaven_stronghold.level_id, rank) then
			num = num + 1
		end

		return num >= 4
	end,
	progress = function (arg_21_0, arg_21_1)
		-- function 21
		local num = 0
		local rank = DifficultySettings.cataclysm.rank

		if not check_level_difficulty(arg_21_0, arg_21_1, LevelSettings.elven_ruins.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_21_0, arg_21_1, LevelSettings.bell.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_21_0, arg_21_1, LevelSettings.fort.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_21_0, arg_21_1, LevelSettings.skaven_stronghold.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_22_0, arg_22_1)
		-- function 22
		local rank = DifficultySettings.cataclysm.rank
		local var_22_1 = check_level_difficulty(arg_22_0, arg_22_1, LevelSettings.elven_ruins.level_id, rank)
		local var_22_2 = check_level_difficulty(arg_22_0, arg_22_1, LevelSettings.bell.level_id, rank)
		local var_22_3 = check_level_difficulty(arg_22_0, arg_22_1, LevelSettings.fort.level_id, rank)
		local var_22_4 = check_level_difficulty(arg_22_0, arg_22_1, LevelSettings.skaven_stronghold.level_id, rank)

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
	completed = function (arg_23_0, arg_23_1)
		-- function 23
		local num = 0
		local rank = DifficultySettings.cataclysm.rank

		if not check_level_difficulty(arg_23_0, arg_23_1, LevelSettings.farmlands.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_23_0, arg_23_1, LevelSettings.ussingen.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_23_0, arg_23_1, LevelSettings.nurgle.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_23_0, arg_23_1, LevelSettings.warcamp.level_id, rank) then
			num = num + 1
		end

		return num >= 4
	end,
	progress = function (arg_24_0, arg_24_1)
		-- function 24
		local num = 0
		local rank = DifficultySettings.cataclysm.rank

		if not check_level_difficulty(arg_24_0, arg_24_1, LevelSettings.farmlands.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_24_0, arg_24_1, LevelSettings.ussingen.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_24_0, arg_24_1, LevelSettings.nurgle.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_24_0, arg_24_1, LevelSettings.warcamp.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (arg_25_0, arg_25_1)
		-- function 25
		local rank = DifficultySettings.cataclysm.rank
		local var_25_1 = check_level_difficulty(arg_25_0, arg_25_1, LevelSettings.farmlands.level_id, rank)
		local var_25_2 = check_level_difficulty(arg_25_0, arg_25_1, LevelSettings.ussingen.level_id, rank)
		local var_25_3 = check_level_difficulty(arg_25_0, arg_25_1, LevelSettings.nurgle.level_id, rank)
		local var_25_4 = check_level_difficulty(arg_25_0, arg_25_1, LevelSettings.warcamp.level_id, rank)

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
	completed = function (arg_26_0, arg_26_1)
		-- function 26
		local rank = DifficultySettings.cataclysm.rank

		return check_level_difficulty(arg_26_0, arg_26_1, LevelSettings.skittergate.level_id, rank)
	end
}

local var_0_17 = (function (arg_27_0)
	-- function 27
	local var_27_0

	for i, v in ipairs(arg_27_0) do
		if v == "prologue" then
			var_27_0 = i
		end
	end

	local var_27_1 = arg_27_0

	if not var_27_0 then
		table.remove(var_27_1, var_27_0)
	end

	return var_27_1
end)(MainGameLevels)

AchievementTemplates.achievements.scorpion_complete_all_helmgart_levels_cataclysm = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_all_helmgart_levels_cataclysm_name",
	icon = "achievement_trophy_scorpion_complete_all_helmgart_levels_cataclysm",
	desc = "achv_scorpion_complete_all_helmgart_levels_cataclysm_desc",
	completed = function (arg_28_0, arg_28_1)
		-- function 28
		local rank = DifficultySettings.cataclysm.rank

		return check_level_list_difficulty(arg_28_0, arg_28_1, var_0_17, rank)
	end,
	progress = function (arg_29_0, arg_29_1)
		-- function 29
		local rank = DifficultySettings.cataclysm.rank
		local num = 0

		for i, v in ipairs(var_0_17) do
			if not check_level_difficulty(arg_29_0, arg_29_1, v, rank) then
				num = num + 1
			end
		end

		return {
			num,
			#var_0_17
		}
	end,
	requirements = function (arg_30_0, arg_30_1)
		-- function 30
		local tbl = {}
		local rank = DifficultySettings.cataclysm.rank

		for i, v in ipairs(var_0_17) do
			local var_30_2 = check_level_difficulty(arg_30_0, arg_30_1, v, rank)

			table.insert(tbl, {
				name = LevelSettings[v].display_name,
				completed = var_30_2
			})
		end

		return tbl
	end
}
AchievementTemplates.achievements.scorpion_complete_bogenhafen_cataclysm = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_bogenhafen_cataclysm_name",
	required_dlc_extra = "bogenhafen",
	icon = "achievement_trophy_scorpion_complete_bogenhafen_cataclysm",
	desc = "achv_scorpion_complete_bogenhafen_cataclysm_desc",
	completed = function (arg_31_0, arg_31_1)
		-- function 31
		local num = 0
		local rank = DifficultySettings.cataclysm.rank

		if not check_level_difficulty(arg_31_0, arg_31_1, LevelSettings.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_31_0, arg_31_1, LevelSettings.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return num >= 2
	end,
	progress = function (arg_32_0, arg_32_1)
		-- function 32
		local num = 0
		local rank = DifficultySettings.cataclysm.rank

		if not check_level_difficulty(arg_32_0, arg_32_1, LevelSettings.dlc_bogenhafen_slum.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_32_0, arg_32_1, LevelSettings.dlc_bogenhafen_city.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			2
		}
	end,
	requirements = function (arg_33_0, arg_33_1)
		-- function 33
		local rank = DifficultySettings.cataclysm.rank
		local var_33_1 = check_level_difficulty(arg_33_0, arg_33_1, LevelSettings.dlc_bogenhafen_slum.level_id, rank)
		local var_33_2 = check_level_difficulty(arg_33_0, arg_33_1, LevelSettings.dlc_bogenhafen_city.level_id, rank)

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
	completed = function (arg_34_0, arg_34_1)
		-- function 34
		local num = 0
		local rank = DifficultySettings.cataclysm.rank

		if not check_level_difficulty(arg_34_0, arg_34_1, LevelSettings.magnus.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_34_0, arg_34_1, LevelSettings.cemetery.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_34_0, arg_34_1, LevelSettings.forest_ambush.level_id, rank) then
			num = num + 1
		end

		return num >= 3
	end,
	progress = function (arg_35_0, arg_35_1)
		-- function 35
		local num = 0
		local rank = DifficultySettings.cataclysm.rank

		if not check_level_difficulty(arg_35_0, arg_35_1, LevelSettings.magnus.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_35_0, arg_35_1, LevelSettings.cemetery.level_id, rank) then
			num = num + 1
		end

		if not check_level_difficulty(arg_35_0, arg_35_1, LevelSettings.forest_ambush.level_id, rank) then
			num = num + 1
		end

		return {
			num,
			3
		}
	end,
	requirements = function (arg_36_0, arg_36_1)
		-- function 36
		local rank = DifficultySettings.cataclysm.rank
		local var_36_1 = check_level_difficulty(arg_36_0, arg_36_1, LevelSettings.magnus.level_id, rank)
		local var_36_2 = check_level_difficulty(arg_36_0, arg_36_1, LevelSettings.cemetery.level_id, rank)
		local var_36_3 = check_level_difficulty(arg_36_0, arg_36_1, LevelSettings.forest_ambush.level_id, rank)

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
	completed = function (arg_37_0, arg_37_1)
		-- function 37
		local num = 0
		local rank = DifficultySettings.cataclysm.rank

		if not check_level_difficulty(arg_37_0, arg_37_1, LevelSettings.plaza.level_id, rank) then
			num = num + 1
		end

		return num >= 1
	end
}

local function fn_3(self, arg_38_1, arg_38_2, arg_38_3)
	-- function 38
	local flag = false
	local num = 0
	local current_season_id = ScorpionSeasonalSettings.current_season_id

	for i = arg_38_2, arg_38_3 do
		for j = 1, 4 do
			local str = "weave_score_weave_" .. i .. "_" .. j .. "_players"

			if not IS_WINDOWS then
				for k = 1, current_season_id do
					if k == 1 then
						str = "weave_score_weave_" .. i .. "_" .. j .. "_players"
					else
						str = i .. "_" .. j
					end

					local get_season_name = ScorpionSeasonalSettings.get_season_name(k)

					flag = self:get_persistent_stat(arg_38_1, get_season_name, str) > 0

					if not flag then
						break
					end
				end
			else
				flag = self:get_persistent_stat(arg_38_1, "season_1", str) > 0
			end

			if not flag then
				break
			end
		end

		if not flag then
			break
		end

		num = num + 1
	end

	return flag, num
end

local function fn_4(self, arg_39_1, arg_39_2, arg_39_3)
	-- function 39
	local flag = false
	local num = 0

	for k, v in pairs(WeaveSettings.templates_ordered) do
		if arg_39_2 == v.wind then
			for k_2 = 1, 4 do
				local str = "weave_score_weave_" .. v.tier .. "_" .. k_2 .. "_players"

				flag = self:get_persistent_stat(arg_39_1, "season_1", str) > 0

				if not flag then
					break
				end
			end

			if not flag then
				break
			end

			num = num + 1

			if num == arg_39_3 then
				break
			end
		end
	end

	return flag, num
end

local function fn_5(self, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	local num = 0

	for k, v in pairs(WeaveSettings.templates_ordered) do
		if arg_40_2 == v.wind then
			local str = "weave_score_weave_" .. v.tier .. "_" .. 1 .. "_players"

			self:set_stat(arg_40_1, "season_1", str, 10)

			num = num + 1

			if num == arg_40_3 then
				break
			end
		end
	end
end

local function fn_6(self, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	local num = 0

	for k, v in pairs(WeaveSettings.templates_ordered) do
		if arg_41_2 == v.wind then
			local str = "weave_score_weave_" .. v.tier .. "_" .. 1 .. "_players"

			self:set_stat(arg_41_1, "season_1", str, 0)

			num = num + 1

			if num == arg_41_3 then
				break
			end
		end
	end
end

local function fn_7(self, arg_42_1, arg_42_2)
	-- function 42
	local flag = false
	local num = 0
	local count = #WeaveSettings.winds

	for k, v in pairs(WeaveSettings.winds) do
		local str = "weave_rainbow_" .. v .. "_" .. arg_42_2 .. "_season_1"

		if not (self:get_persistent_stat(arg_42_1, "season_1", str) > 0) then
			num = num + 1
		end
	end

	return num == count, num
end

local tbl_2 = {
	"life",
	"metal",
	"heavens",
	"light",
	"death",
	"beasts",
	"shadow",
	"fire"
}
local num_2 = 5

for l = 1, #tbl_2 do
	local str_3 = "scorpion_weaves_" .. l .. "_season_1"
	local var_0_26 = tbl_2[l]
	local var_0_27 = WeaveSettings.weave_wind_ranges[var_0_26]

	AchievementTemplates.achievements[str_3] = {
		required_dlc = "scorpion",
		name = "achv_scorpion_weaves_" .. l .. "_season_1_name",
		desc = "achv_scorpion_weaves_" .. l .. "_season_1_desc",
		icon = "achievement_trophy_scorpion_weaves_" .. l .. "_season_1",
		completed = function (arg_43_0, arg_43_1)
			-- function 43
			local flag = true

			for i = 1, num_2 do
				local var_43_1 = var_0_27[i]

				flag = not flag and fn(arg_43_0, arg_43_1, ScorpionSeasonalSettings.current_season_id, var_43_1)
			end

			return flag
		end,
		progress = function (arg_44_0, arg_44_1)
			-- function 44
			local num = 0

			for i = 1, num_2 do
				local var_44_1 = var_0_27[i]

				if not fn(arg_44_0, arg_44_1, ScorpionSeasonalSettings.current_season_id, var_44_1) then
					num = num + 1
				end
			end

			return {
				num,
				num_2
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
	completed = function (self, arg_45_1)
		-- function 45
		return self:get_persistent_stat(arg_45_1, "season_1", "weave_quickplay_wins") >= 40
	end,
	progress = function (self, arg_46_1)
		-- function 46
		local get_persistent_stat = self:get_persistent_stat(arg_46_1, "season_1", "weave_quickplay_wins")

		return {
			get_persistent_stat,
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

for i_2, v_2 in ipairs(AchievementTemplates.complete_weaves_list) do
	local str_4 = "scorpion_complete_weaves_" .. i_2

	AchievementTemplates.achievements[str_4] = {
		required_dlc = "scorpion",
		name = "achv_scorpion_complete_weaves_" .. i_2 .. "_name",
		desc = function ()
			-- function 47
			return string.format(Localize("achv_scorpion_complete_weaves_" .. i_2 .. "_desc"), v_2)
		end,
		ID_XB1 = AchievementTemplates.xbox_achievement_ids[i_2],
		ID_PS4 = AchievementTemplates.ps4_achievement_ids[i_2],
		icon = "achievement_trophy_scorpion_complete_weaves_" .. i_2,
		completed = function (self, arg_48_1)
			-- function 48
			local num = 1
			local var_48_1 = v_2
			local var_48_2, var_48_3 = fn_3(self, arg_48_1, num, var_48_1)

			if not IS_WINDOWS then
				return var_48_2
			else
				local get_persistent_stat = self:get_persistent_stat(arg_48_1, "scorpion_weaves_won")

				return math.min(var_48_3 + get_persistent_stat, v_2) >= v_2
			end
		end,
		progress = function (self, arg_49_1)
			-- function 49
			local num = 1
			local var_49_1 = v_2
			local var_49_2, var_49_3 = fn_3(self, arg_49_1, num, var_49_1)

			if not IS_WINDOWS then
				return {
					var_49_3,
					v_2
				}
			else
				local get_persistent_stat = self:get_persistent_stat(arg_49_1, "scorpion_weaves_won")
				local min = math.min(var_49_3 + get_persistent_stat, v_2)

				return {
					min,
					v_2
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

for k_2, v_3 in pairs(AchievementTemplates._list_of_weaves_from_to) do
	local str_5 = "scorpion_" .. k_2 .. "_season_1"

	AchievementTemplates.achievements[str_5] = {
		required_dlc = "scorpion",
		name = "achv_scorpion_" .. k_2 .. "_season_1_name",
		desc = "achv_scorpion_" .. k_2 .. "_season_1_desc",
		icon = "achievement_trophy_scorpion_" .. k_2 .. "_season_1",
		completed = function (arg_50_0, arg_50_1)
			-- function 50
			local from = v_3.from
			local to = v_3.to
			local var_50_2, var_50_3 = fn_2(arg_50_0, arg_50_1, ScorpionSeasonalSettings.current_season_id, from, to)

			return var_50_2
		end,
		progress = function (arg_51_0, arg_51_1)
			-- function 51
			local from = v_3.from
			local to = v_3.to
			local num = to - from + 1
			local var_51_3, var_51_4 = fn_2(arg_51_0, arg_51_1, ScorpionSeasonalSettings.current_season_id, from, to)

			return {
				var_51_4,
				num
			}
		end
	}
end

local heroes = PROFILES_BY_AFFILIATION.heroes

for i8 = 1, #heroes do
	local var_0_31 = FindProfileIndex(heroes[i8])

	for k_3, v_4 in pairs(SPProfiles[var_0_31].careers) do
		local name = v_4.name
		local var_0_33 = CareerNameAchievementMapping[name]
		local str_6 = "scorpion_weaves_complete_" .. name .. "_season_1"

		AchievementTemplates.achievements[str_6] = {
			required_dlc = "scorpion",
			name = "achv_scorpion_weaves_complete_" .. var_0_33 .. "_season_1_name",
			desc = "achv_scorpion_weaves_complete_" .. var_0_33 .. "_season_1_desc",
			icon = "achievement_trophy_scorpion_weaves_complete_" .. var_0_33 .. "_season_1",
			completed = function (self, arg_52_1)
				-- function 52
				local str = "weaves_complete_" .. name .. "_season_1"

				return 40 <= self:get_persistent_stat(arg_52_1, "season_1", str)
			end,
			progress = function (self, arg_53_1)
				-- function 53
				local str = "weaves_complete_" .. name .. "_season_1"
				local num = 40
				local get_persistent_stat = self:get_persistent_stat(arg_53_1, "season_1", str)

				return {
					get_persistent_stat,
					num
				}
			end
		}

		local str_7 = "scorpion_weaves_rainbow_" .. name .. "_season_1"

		AchievementTemplates.achievements[str_7] = {
			required_dlc = "scorpion",
			name = "achv_scorpion_weaves_rainbow_" .. var_0_33 .. "_season_1_name",
			desc = "achv_scorpion_weaves_rainbow_" .. var_0_33 .. "_season_1_desc",
			icon = "achievement_trophy_scorpion_weaves_rainbow_" .. var_0_33 .. "_season_1",
			completed = function (arg_54_0, arg_54_1)
				-- function 54
				return fn_7(arg_54_0, arg_54_1, name)
			end,
			progress = function (arg_55_0, arg_55_1)
				-- function 55
				local count = #WeaveSettings.winds
				local var_55_1, var_55_2 = fn_7(arg_55_0, arg_55_1, name)

				return {
					var_55_2,
					count
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
	completed = function (self, arg_56_1)
		-- function 56
		local str = "scorpion_weaves_life_season_1"

		return self:get_persistent_stat(arg_56_1, "season_1", str) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_heavens_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_heavens_season_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_scorpion_weaves_heavens_season_1",
	desc = "achv_scorpion_weaves_heavens_season_1_desc",
	completed = function (self, arg_57_1)
		-- function 57
		local str = "scorpion_weaves_heavens_season_1"

		return self:get_persistent_stat(arg_57_1, "season_1", str) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_death_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_death_season_1_name",
	icon = "achievement_trophy_scorpion_weaves_death_season_1",
	desc = "achv_scorpion_weaves_death_season_1_desc",
	completed = function (self, arg_58_1)
		-- function 58
		local str = "scorpion_weaves_death_season_1"

		return self:get_persistent_stat(arg_58_1, "season_1", str) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_beasts_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_beasts_season_1_name",
	icon = "achievement_trophy_scorpion_weaves_beasts_season_1",
	desc = "achv_scorpion_weaves_beasts_season_1_desc",
	completed = function (self, arg_59_1)
		-- function 59
		local str = "scorpion_weaves_beasts_season_1"

		return self:get_persistent_stat(arg_59_1, "season_1", str) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_light_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_light_season_1_name",
	icon = "achievement_trophy_scorpion_weaves_light_season_1",
	desc = "achv_scorpion_weaves_light_season_1_desc",
	completed = function (self, arg_60_1)
		-- function 60
		local str = "scorpion_weaves_light_season_1"

		return self:get_persistent_stat(arg_60_1, "season_1", str) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_fire_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_fire_season_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_scorpion_weaves_fire_season_1",
	desc = "achv_scorpion_weaves_fire_season_1_desc",
	completed = function (self, arg_61_1)
		-- function 61
		local str = "scorpion_weaves_fire_season_1"

		return self:get_persistent_stat(arg_61_1, "season_1", str) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_shadow_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_shadow_season_1_name",
	icon = "achievement_trophy_scorpion_weaves_shadow_season_1",
	desc = "achv_scorpion_weaves_shadow_season_1_desc",
	completed = function (self, arg_62_1)
		-- function 62
		local str = "scorpion_weaves_shadow_season_1"

		return self:get_persistent_stat(arg_62_1, "season_1", str) > 0
	end
}
AchievementTemplates.achievements.scorpion_weaves_metal_season_1 = {
	required_dlc = "scorpion",
	name = "achv_scorpion_weaves_metal_season_1_name",
	display_completion_ui = true,
	icon = "achievement_trophy_scorpion_weaves_metal_season_1",
	desc = function ()
		-- function 63
		return string.format(Localize("achv_scorpion_weaves_metal_season_1_desc"), QuestSettings.bladestorm_duration)
	end,
	completed = function (self, arg_64_1)
		-- function 64
		local str = "scorpion_weaves_metal_season_1"

		return self:get_persistent_stat(arg_64_1, "season_1", str) > 0
	end
}
AchievementTemplates.achievements.elven_ruins_align_leylines_timed_cata = {
	required_dlc = "scorpion",
	name = "achv_elven_ruins_align_leylines_timed_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_elven_ruins_align_leylines_timed_cata",
	desc = function ()
		-- function 65
		return string.format(Localize("achv_elven_ruins_align_leylines_timed_cata_desc"), QuestSettings.elven_ruins_speed_event_cata)
	end,
	completed = function (self, arg_66_1)
		-- function 66
		return self:get_persistent_stat(arg_66_1, "elven_ruins_speed_event_cata") > 0
	end
}
AchievementTemplates.achievements.farmlands_rescue_prisoners_timed_cata = {
	required_dlc = "scorpion",
	name = "achv_farmlands_rescue_prisoners_timed_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_farmlands_rescue_prisoners_timed_cata",
	desc = function ()
		-- function 67
		return string.format(Localize("achv_farmlands_rescue_prisoners_timed_cata_desc"), QuestSettings.farmlands_speed_event)
	end,
	completed = function (self, arg_68_1)
		-- function 68
		return self:get_persistent_stat(arg_68_1, "farmlands_speed_event_cata") > 0
	end
}
AchievementTemplates.achievements.military_kill_chaos_warriors_in_event_cata = {
	required_dlc = "scorpion",
	name = "achv_military_kill_chaos_warriors_in_event_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_military_kill_chaos_warriors_in_event_cata",
	desc = function ()
		-- function 69
		return string.format(Localize("achv_military_kill_chaos_warriors_in_event_cata_desc"), 3)
	end,
	completed = function (self, arg_70_1)
		-- function 70
		return self:get_persistent_stat(arg_70_1, "military_statue_kill_chaos_warriors_cata") > 0
	end
}
AchievementTemplates.achievements.ground_zero_burblespew_tornado_enemies_cata = {
	required_dlc = "scorpion",
	name = "achv_ground_zero_burblespew_tornado_enemies_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_ground_zero_burblespew_tornado_enemies_cata",
	desc = function ()
		-- function 71
		return string.format(Localize("achv_ground_zero_burblespew_tornado_enemies_cata_desc"), QuestSettings.halescourge_tornado_enemies_cata)
	end,
	completed = function (self, arg_72_1)
		-- function 72
		return self:get_persistent_stat(arg_72_1, "halescourge_tornado_enemies_cata") > 0
	end
}
AchievementTemplates.achievements.fort_kill_enemies_cannonball_cata = {
	required_dlc = "scorpion",
	name = "achv_fort_kill_enemies_cannonball_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_fort_kill_enemies_cannonball_cata",
	desc = function ()
		-- function 73
		return string.format(Localize("achv_fort_kill_enemies_cannonball_cata_desc"), QuestSettings.forest_fort_kill_cannonball_cata)
	end,
	completed = function (self, arg_74_1)
		-- function 74
		return self:get_persistent_stat(arg_74_1, "forest_fort_kill_cannonball_cata") > 0
	end
}
AchievementTemplates.achievements.nurgle_player_showered_in_pus_cata = {
	required_dlc = "scorpion",
	name = "achv_nurgle_player_showered_in_pus_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_nurgle_player_showered_in_pus_cata",
	desc = function ()
		-- function 75
		return string.format(Localize("achv_nurgle_player_showered_in_pus_cata_desc"), QuestSettings.nurgle_bathed_all_cata)
	end,
	completed = function (self, arg_76_1)
		-- function 76
		return self:get_persistent_stat(arg_76_1, "nurgle_bathed_all_cata") > 0
	end
}
AchievementTemplates.achievements.bell_destroy_bell_flee_timed_cata = {
	required_dlc = "scorpion",
	name = "achv_bell_destroy_bell_flee_timed_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_bell_destroy_bell_flee_timed_cata",
	desc = function ()
		-- function 77
		return string.format(Localize("achv_bell_destroy_bell_flee_timed_cata_desc"), QuestSettings.bell_speed_event_cata)
	end,
	completed = function (self, arg_78_1)
		-- function 78
		return self:get_persistent_stat(arg_78_1, "bell_speed_event_cata") > 0
	end
}
AchievementTemplates.achievements.catacombs_stay_inside_ritual_pool_cata = {
	required_dlc = "scorpion",
	name = "achv_catacombs_stay_inside_ritual_pool_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_catacombs_stay_inside_ritual_pool_cata",
	desc = function ()
		-- function 79
		return string.format(Localize("achv_catacombs_stay_inside_ritual_pool_cata_desc"), QuestSettings.volume_corpse_pit_damage_cata)
	end,
	completed = function (self, arg_80_1)
		-- function 80
		return self:get_persistent_stat(arg_80_1, "catacombs_added_souls_cata") > 0
	end
}
AchievementTemplates.achievements.mines_kill_final_troll_timed_cata = {
	required_dlc = "scorpion",
	name = "achv_mines_kill_final_troll_timed_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_mines_kill_final_troll_timed_cata",
	desc = function ()
		-- function 81
		return string.format(Localize("achv_mines_kill_final_troll_timed_cata_desc"), QuestSettings.mines_speed_event_cata)
	end,
	completed = function (self, arg_82_1)
		-- function 82
		return self:get_persistent_stat(arg_82_1, "mines_speed_event_cata") > 0
	end
}
AchievementTemplates.achievements.warcamp_bodvarr_charge_warriors_cata = {
	required_dlc = "scorpion",
	name = "achv_warcamp_bodvarr_charge_warriors_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_warcamp_bodvarr_charge_warriors_cata",
	desc = function ()
		-- function 83
		return string.format(Localize("achv_warcamp_bodvarr_charge_warriors_cata_desc"), QuestSettings.exalted_champion_charge_chaos_warrior_cata)
	end,
	completed = function (self, arg_84_1)
		-- function 84
		return self:get_persistent_stat(arg_84_1, "exalted_champion_charge_chaos_warrior_cata") > 0
	end
}
AchievementTemplates.achievements.skaven_stronghold_skarrik_kill_skaven_cata = {
	required_dlc = "scorpion",
	name = "achv_skaven_stronghold_skarrik_kill_skaven_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skaven_stronghold_skarrik_kill_skaven_cata",
	desc = function ()
		-- function 85
		return string.format(Localize("achv_skaven_stronghold_skarrik_kill_skaven_cata_desc"), QuestSettings.storm_vermin_warlord_kills_enemies_cata)
	end,
	completed = function (self, arg_86_1)
		-- function 86
		return self:get_persistent_stat(arg_86_1, "storm_vermin_warlord_kills_enemies_cata") > 0
	end
}
AchievementTemplates.achievements.ussingen_no_event_barrels_cata = {
	required_dlc = "scorpion",
	name = "achv_ussingen_no_event_barrels_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_ussingen_no_event_barrels_cata",
	desc = "achv_ussingen_no_event_barrels_cata_desc",
	completed = function (self, arg_87_1)
		-- function 87
		return self:get_persistent_stat(arg_87_1, "ussingen_used_no_barrels_cata") > 0
	end
}
AchievementTemplates.achievements.skittergate_deathrattler_rasknitt_timed_cata = {
	required_dlc = "scorpion",
	name = "achv_skittergate_deathrattler_rasknitt_timed_cata_name",
	display_completion_ui = true,
	icon = "achievement_trophy_skittergate_deathrattler_rasknitt_timed_cata",
	desc = function ()
		-- function 88
		return string.format(Localize("achv_skittergate_deathrattler_rasknitt_timed_cata_desc"), QuestSettings.skittergate_speed_event_cata)
	end,
	completed = function (self, arg_89_1)
		-- function 89
		return self:get_persistent_stat(arg_89_1, "skittergate_speed_event_cata") > 0
	end
}

local tbl_3 = {
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
	completed = function (self, arg_90_1)
		-- function 90
		for k, v in pairs(tbl_3) do
			if not (self:get_persistent_stat(arg_90_1, v) > 0) then
				return false
			end
		end

		return true
	end,
	progress = function (self, arg_91_1)
		-- function 91
		local num = 0
		local num_2 = 0

		for k, v in pairs(tbl_3) do
			num_2 = num_2 + 1

			if not (self:get_persistent_stat(arg_91_1, v) > 0) then
				num = num + 1
			end
		end

		return {
			num,
			num_2
		}
	end,
	requirements = function (self, arg_92_1)
		-- function 92
		local tbl = {}

		for k, v in pairs(tbl_3) do
			local flag = self:get_persistent_stat(arg_92_1, v) > 0

			table.insert(tbl, {
				name = k,
				completed = flag
			})
		end

		return tbl
	end
}
AchievementTemplates.achievements.scorpion_cataclysm_unlock_kill_all_lords = {
	required_dlc = "scorpion",
	name = "achv_scorpion_cataclysm_unlock_kill_all_lords_name",
	icon = "achivement_trophy_scorpion_cataclysm_unlock_kill_all_lords",
	desc = "achv_scorpion_cataclysm_unlock_kill_all_lords_desc",
	completed = function (self, arg_93_1)
		-- function 93
		local flag = self:get_persistent_stat(arg_93_1, "kill_chaos_exalted_champion_scorpion_hardest") >= 5
		local flag_2 = self:get_persistent_stat(arg_93_1, "kill_chaos_exalted_sorcerer_scorpion_hardest") >= 5
		local flag_3 = self:get_persistent_stat(arg_93_1, "kill_skaven_grey_seer_scorpion_hardest") >= 5
		local flag_4 = self:get_persistent_stat(arg_93_1, "kill_skaven_storm_vermin_warlord_scorpion_hardest") >= 5

		return not flag and not flag_2 and not flag_3 and flag_4
	end,
	requirements = function (self, arg_94_1)
		-- function 94
		local flag = self:get_persistent_stat(arg_94_1, "kill_chaos_exalted_champion_scorpion_hardest") >= 5
		local flag_2 = self:get_persistent_stat(arg_94_1, "kill_chaos_exalted_sorcerer_scorpion_hardest") >= 5
		local flag_3 = self:get_persistent_stat(arg_94_1, "kill_skaven_grey_seer_scorpion_hardest") >= 5
		local flag_4 = self:get_persistent_stat(arg_94_1, "kill_skaven_storm_vermin_warlord_scorpion_hardest") >= 5

		return {
			{
				name = "chaos_exalted_champion",
				completed = flag
			},
			{
				name = "chaos_exalted_sorcerer",
				completed = flag_2
			},
			{
				name = "skaven_storm_vermin_warlord",
				completed = flag_4
			},
			{
				name = "skaven_grey_seer",
				completed = flag_3
			}
		}
	end
}

local achievements = AchievementTemplates.achievements
local var_0_38

add_weapon_kill_challenge(achievements, "scorpion_bardin_weapon_skin_1", "dr_1h_throwing_axes", 1000, var_0_38, "scorpion")
add_weapon_kill_challenge(achievements, "scorpion_kerillian_weapon_skin_1", "we_1h_spears_shield", 1000, var_0_38, "scorpion")
add_weapon_kill_challenge(achievements, "scorpion_markus_weapon_skin_1", "es_2h_heavy_spear", 1000, var_0_38, "scorpion")
add_weapon_kill_challenge(achievements, "scorpion_sienna_weapon_skin_1", "bw_1h_flail_flaming", 1000, var_0_38, "scorpion")
add_weapon_kill_challenge(achievements, "scorpion_victor_weapon_skin_1", "wh_2h_billhook", 1000, var_0_38, "scorpion")

local tbl_4 = {
	"warcamp",
	"skaven_stronghold",
	"ground_zero",
	"skittergate"
}
local str_8 = "hardest"

add_weapon_levels_challenge(achievements, "scorpion_bardin_weapon_skin_2", "dr_1h_throwing_axes", tbl_4, str_8, var_0_38, "scorpion")
add_weapon_levels_challenge(achievements, "scorpion_kerillian_weapon_skin_2", "we_1h_spears_shield", tbl_4, str_8, var_0_38, "scorpion")
add_weapon_levels_challenge(achievements, "scorpion_markus_weapon_skin_2", "es_2h_heavy_spear", tbl_4, str_8, var_0_38, "scorpion")
add_weapon_levels_challenge(achievements, "scorpion_sienna_weapon_skin_2", "bw_1h_flail_flaming", tbl_4, str_8, var_0_38, "scorpion")
add_weapon_levels_challenge(achievements, "scorpion_victor_weapon_skin_2", "wh_2h_billhook", tbl_4, str_8, var_0_38, "scorpion")
