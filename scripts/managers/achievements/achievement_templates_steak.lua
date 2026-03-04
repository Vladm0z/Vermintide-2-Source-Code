-- chunkname: @scripts/managers/achievements/achievement_templates_steak.lua

local var_0_0 = AchievementTemplateHelper.check_level_difficulty

AchievementTemplates.achievements.scorpion_bardin_weapon_unlock = {
	required_dlc = "scorpion",
	name = "achv_scorpion_bardin_weapon_unlock_name",
	icon = "achievement_trophy_scorpion_bardin_weapon_unlock",
	desc = "achv_scorpion_bardin_weapon_unlock_desc",
	completed = function (arg_1_0, arg_1_1)
		if arg_1_0:get_persistent_stat(arg_1_1, "completed_levels_dwarf_ranger", "crater") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_2_0, arg_2_1)
		local var_2_0 = 0

		if arg_2_0:get_persistent_stat(arg_2_1, "completed_levels_dwarf_ranger", "crater") > 0 then
			var_2_0 = var_2_0 + 1
		end

		return {
			var_2_0,
			1
		}
	end
}
AchievementTemplates.achievements.scorpion_kerillian_weapon_unlock = {
	required_dlc = "scorpion",
	name = "achv_scorpion_kerillian_weapon_unlock_name",
	icon = "achievement_trophy_scorpion_kerillian_weapon_unlock",
	desc = "achv_scorpion_kerillian_weapon_unlock_desc",
	completed = function (arg_3_0, arg_3_1)
		if arg_3_0:get_persistent_stat(arg_3_1, "completed_levels_wood_elf", "crater") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_4_0, arg_4_1)
		local var_4_0 = 0

		if arg_4_0:get_persistent_stat(arg_4_1, "completed_levels_wood_elf", "crater") > 0 then
			var_4_0 = var_4_0 + 1
		end

		return {
			var_4_0,
			1
		}
	end
}
AchievementTemplates.achievements.scorpion_markus_weapon_unlock = {
	required_dlc = "scorpion",
	name = "achv_scorpion_markus_weapon_unlock_name",
	icon = "achievement_trophy_scorpion_markus_weapon_unlock",
	desc = "achv_scorpion_markus_weapon_unlock_desc",
	completed = function (arg_5_0, arg_5_1)
		if arg_5_0:get_persistent_stat(arg_5_1, "completed_levels_empire_soldier", "crater") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_6_0, arg_6_1)
		local var_6_0 = 0

		if arg_6_0:get_persistent_stat(arg_6_1, "completed_levels_empire_soldier", "crater") > 0 then
			var_6_0 = var_6_0 + 1
		end

		return {
			var_6_0,
			1
		}
	end
}
AchievementTemplates.achievements.scorpion_sienna_weapon_unlock = {
	required_dlc = "scorpion",
	name = "achv_scorpion_sienna_weapon_unlock_name",
	icon = "achievement_trophy_scorpion_sienna_weapon_unlock",
	desc = "achv_scorpion_sienna_weapon_unlock_desc",
	completed = function (arg_7_0, arg_7_1)
		if arg_7_0:get_persistent_stat(arg_7_1, "completed_levels_bright_wizard", "crater") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_8_0, arg_8_1)
		local var_8_0 = 0

		if arg_8_0:get_persistent_stat(arg_8_1, "completed_levels_bright_wizard", "crater") > 0 then
			var_8_0 = var_8_0 + 1
		end

		return {
			var_8_0,
			1
		}
	end
}
AchievementTemplates.achievements.scorpion_victor_weapon_unlock = {
	required_dlc = "scorpion",
	name = "achv_scorpion_victor_weapon_unlock_name",
	icon = "achievement_trophy_scorpion_victor_weapon_unlock",
	desc = "achv_scorpion_victor_weapon_unlock_desc",
	completed = function (arg_9_0, arg_9_1)
		if arg_9_0:get_persistent_stat(arg_9_1, "completed_levels_witch_hunter", "crater") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_10_0, arg_10_1)
		local var_10_0 = 0

		if arg_10_0:get_persistent_stat(arg_10_1, "completed_levels_witch_hunter", "crater") > 0 then
			var_10_0 = var_10_0 + 1
		end

		return {
			var_10_0,
			1
		}
	end
}
AchievementTemplates.achievements.scorpion_complete_crater_recruit = {
	ID_XB1 = 72,
	name = "achv_scorpion_complete_crater_recruit_name",
	required_dlc = "scorpion",
	ID_PS4 = "071",
	icon = "achievement_trophy_scorpion_complete_crater_recruit",
	desc = "achv_scorpion_complete_crater_recruit_desc",
	completed = function (arg_11_0, arg_11_1)
		local var_11_0 = DifficultySettings.normal.rank
		local var_11_1 = false

		if var_0_0(arg_11_0, arg_11_1, LevelSettings.crater.level_id, var_11_0) then
			var_11_1 = true
		end

		return var_11_1
	end
}
AchievementTemplates.achievements.scorpion_complete_crater_veteran = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_crater_veteran_name",
	icon = "achievement_trophy_scorpion_complete_crater_veteran",
	desc = "achv_scorpion_complete_crater_veteran_desc",
	completed = function (arg_12_0, arg_12_1)
		local var_12_0 = DifficultySettings.hard.rank
		local var_12_1 = false

		if var_0_0(arg_12_0, arg_12_1, LevelSettings.crater.level_id, var_12_0) then
			var_12_1 = true
		end

		return var_12_1
	end
}
AchievementTemplates.achievements.scorpion_complete_crater_champion = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_crater_champion_name",
	icon = "achievement_trophy_scorpion_complete_crater_champion",
	desc = "achv_scorpion_complete_crater_champion_desc",
	completed = function (arg_13_0, arg_13_1)
		local var_13_0 = DifficultySettings.harder.rank
		local var_13_1 = false

		if var_0_0(arg_13_0, arg_13_1, LevelSettings.crater.level_id, var_13_0) then
			var_13_1 = true
		end

		return var_13_1
	end
}
AchievementTemplates.achievements.scorpion_complete_crater_legend = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_crater_legend_name",
	icon = "achievement_trophy_scorpion_complete_crater_legend",
	desc = "achv_scorpion_complete_crater_legend_desc",
	completed = function (arg_14_0, arg_14_1)
		local var_14_0 = DifficultySettings.hardest.rank
		local var_14_1 = false

		if var_0_0(arg_14_0, arg_14_1, LevelSettings.crater.level_id, var_14_0) then
			var_14_1 = true
		end

		return var_14_1
	end
}
AchievementTemplates.achievements.scorpion_complete_crater_cataclysm = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_crater_cataclysm_name",
	icon = "achievement_trophy_scorpion_complete_crater_cataclysm",
	desc = "achv_scorpion_complete_crater_cataclysm_desc",
	completed = function (arg_15_0, arg_15_1)
		local var_15_0 = DifficultySettings.cataclysm.rank
		local var_15_1 = false

		if var_0_0(arg_15_0, arg_15_1, LevelSettings.crater.level_id, var_15_0) then
			var_15_1 = true
		end

		return var_15_1
	end
}
AchievementTemplates.achievements.scorpion_crater_pendant = {
	ID_XB1 = 73,
	name = "achv_scorpion_crater_pendant_name",
	ID_PS4 = "072",
	required_dlc = "scorpion",
	icon = "achievement_trophy_scorpion_crater_pendant",
	display_completion_ui = true,
	desc = "achv_scorpion_crater_pendant_desc",
	completed = function (arg_16_0, arg_16_1)
		return arg_16_0:get_persistent_stat(arg_16_1, "scorpion_crater_pendant") > 0
	end
}

for iter_0_0 = 1, 3 do
	local var_0_1 = "scorpion_crater_dark_tongue_" .. iter_0_0

	AchievementTemplates.achievements[var_0_1] = {
		required_dlc = "scorpion",
		display_completion_ui = true,
		ID_XB1 = 73 + iter_0_0,
		ID_PS4 = "0" .. tostring(72 + iter_0_0),
		name = "achv_scorpion_crater_dark_tongue_" .. iter_0_0 .. "_name",
		desc = "achv_scorpion_crater_dark_tongue_" .. iter_0_0 .. "_desc",
		icon = "achievement_trophy_scorpion_crater_dark_tongue_" .. iter_0_0,
		completed = function (arg_17_0, arg_17_1)
			return arg_17_0:get_persistent_stat(arg_17_1, "scorpion_crater_dark_tongue_" .. iter_0_0) >= 1
		end
	}
end

AchievementTemplates.achievements.scorpion_crater_detour = {
	ID_XB1 = 77,
	name = "achv_scorpion_crater_detour_name",
	ID_PS4 = "076",
	required_dlc = "scorpion",
	icon = "achievement_trophy_scorpion_crater_detour",
	display_completion_ui = true,
	desc = "achv_scorpion_crater_detour_desc",
	completed = function (arg_18_0, arg_18_1)
		return arg_18_0:get_persistent_stat(arg_18_1, "scorpion_crater_detour") > 0
	end
}
AchievementTemplates.achievements.scorpion_crater_ambush = {
	required_dlc = "scorpion",
	name = "achv_scorpion_crater_ambush_name",
	display_completion_ui = true,
	icon = "achievement_trophy_scorpion_crater_ambush",
	desc = function ()
		return string.format(Localize("achv_scorpion_crater_ambush_desc"), QuestSettings.nurgle_bathed_all_cata)
	end,
	completed = function (arg_20_0, arg_20_1)
		return arg_20_0:get_persistent_stat(arg_20_1, "scorpion_crater_ambush") > 0
	end
}
