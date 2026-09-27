-- chunkname: @scripts/managers/achievements/achievement_templates_steak.lua

local check_level_difficulty = AchievementTemplateHelper.check_level_difficulty

AchievementTemplates.achievements.scorpion_bardin_weapon_unlock = {
	required_dlc = "scorpion",
	name = "achv_scorpion_bardin_weapon_unlock_name",
	icon = "achievement_trophy_scorpion_bardin_weapon_unlock",
	desc = "achv_scorpion_bardin_weapon_unlock_desc",
	completed = function (self, arg_1_1)
		-- function 1
		if self:get_persistent_stat(arg_1_1, "completed_levels_dwarf_ranger", "crater") > 0 then
			return true
		end

		return false
	end,
	progress = function (self, arg_2_1)
		-- function 2
		local num = 0

		if self:get_persistent_stat(arg_2_1, "completed_levels_dwarf_ranger", "crater") > 0 then
			num = num + 1
		end

		return {
			num,
			1
		}
	end
}
AchievementTemplates.achievements.scorpion_kerillian_weapon_unlock = {
	required_dlc = "scorpion",
	name = "achv_scorpion_kerillian_weapon_unlock_name",
	icon = "achievement_trophy_scorpion_kerillian_weapon_unlock",
	desc = "achv_scorpion_kerillian_weapon_unlock_desc",
	completed = function (self, arg_3_1)
		-- function 3
		if self:get_persistent_stat(arg_3_1, "completed_levels_wood_elf", "crater") > 0 then
			return true
		end

		return false
	end,
	progress = function (self, arg_4_1)
		-- function 4
		local num = 0

		if self:get_persistent_stat(arg_4_1, "completed_levels_wood_elf", "crater") > 0 then
			num = num + 1
		end

		return {
			num,
			1
		}
	end
}
AchievementTemplates.achievements.scorpion_markus_weapon_unlock = {
	required_dlc = "scorpion",
	name = "achv_scorpion_markus_weapon_unlock_name",
	icon = "achievement_trophy_scorpion_markus_weapon_unlock",
	desc = "achv_scorpion_markus_weapon_unlock_desc",
	completed = function (self, arg_5_1)
		-- function 5
		if self:get_persistent_stat(arg_5_1, "completed_levels_empire_soldier", "crater") > 0 then
			return true
		end

		return false
	end,
	progress = function (self, arg_6_1)
		-- function 6
		local num = 0

		if self:get_persistent_stat(arg_6_1, "completed_levels_empire_soldier", "crater") > 0 then
			num = num + 1
		end

		return {
			num,
			1
		}
	end
}
AchievementTemplates.achievements.scorpion_sienna_weapon_unlock = {
	required_dlc = "scorpion",
	name = "achv_scorpion_sienna_weapon_unlock_name",
	icon = "achievement_trophy_scorpion_sienna_weapon_unlock",
	desc = "achv_scorpion_sienna_weapon_unlock_desc",
	completed = function (self, arg_7_1)
		-- function 7
		if self:get_persistent_stat(arg_7_1, "completed_levels_bright_wizard", "crater") > 0 then
			return true
		end

		return false
	end,
	progress = function (self, arg_8_1)
		-- function 8
		local num = 0

		if self:get_persistent_stat(arg_8_1, "completed_levels_bright_wizard", "crater") > 0 then
			num = num + 1
		end

		return {
			num,
			1
		}
	end
}
AchievementTemplates.achievements.scorpion_victor_weapon_unlock = {
	required_dlc = "scorpion",
	name = "achv_scorpion_victor_weapon_unlock_name",
	icon = "achievement_trophy_scorpion_victor_weapon_unlock",
	desc = "achv_scorpion_victor_weapon_unlock_desc",
	completed = function (self, arg_9_1)
		-- function 9
		if self:get_persistent_stat(arg_9_1, "completed_levels_witch_hunter", "crater") > 0 then
			return true
		end

		return false
	end,
	progress = function (self, arg_10_1)
		-- function 10
		local num = 0

		if self:get_persistent_stat(arg_10_1, "completed_levels_witch_hunter", "crater") > 0 then
			num = num + 1
		end

		return {
			num,
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
		-- function 11
		local rank = DifficultySettings.normal.rank
		local flag = false

		if not check_level_difficulty(arg_11_0, arg_11_1, LevelSettings.crater.level_id, rank) then
			flag = true
		end

		return flag
	end
}
AchievementTemplates.achievements.scorpion_complete_crater_veteran = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_crater_veteran_name",
	icon = "achievement_trophy_scorpion_complete_crater_veteran",
	desc = "achv_scorpion_complete_crater_veteran_desc",
	completed = function (arg_12_0, arg_12_1)
		-- function 12
		local rank = DifficultySettings.hard.rank
		local flag = false

		if not check_level_difficulty(arg_12_0, arg_12_1, LevelSettings.crater.level_id, rank) then
			flag = true
		end

		return flag
	end
}
AchievementTemplates.achievements.scorpion_complete_crater_champion = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_crater_champion_name",
	icon = "achievement_trophy_scorpion_complete_crater_champion",
	desc = "achv_scorpion_complete_crater_champion_desc",
	completed = function (arg_13_0, arg_13_1)
		-- function 13
		local rank = DifficultySettings.harder.rank
		local flag = false

		if not check_level_difficulty(arg_13_0, arg_13_1, LevelSettings.crater.level_id, rank) then
			flag = true
		end

		return flag
	end
}
AchievementTemplates.achievements.scorpion_complete_crater_legend = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_crater_legend_name",
	icon = "achievement_trophy_scorpion_complete_crater_legend",
	desc = "achv_scorpion_complete_crater_legend_desc",
	completed = function (arg_14_0, arg_14_1)
		-- function 14
		local rank = DifficultySettings.hardest.rank
		local flag = false

		if not check_level_difficulty(arg_14_0, arg_14_1, LevelSettings.crater.level_id, rank) then
			flag = true
		end

		return flag
	end
}
AchievementTemplates.achievements.scorpion_complete_crater_cataclysm = {
	required_dlc = "scorpion",
	name = "achv_scorpion_complete_crater_cataclysm_name",
	icon = "achievement_trophy_scorpion_complete_crater_cataclysm",
	desc = "achv_scorpion_complete_crater_cataclysm_desc",
	completed = function (arg_15_0, arg_15_1)
		-- function 15
		local rank = DifficultySettings.cataclysm.rank
		local flag = false

		if not check_level_difficulty(arg_15_0, arg_15_1, LevelSettings.crater.level_id, rank) then
			flag = true
		end

		return flag
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
	completed = function (self, arg_16_1)
		-- function 16
		return self:get_persistent_stat(arg_16_1, "scorpion_crater_pendant") > 0
	end
}

for i = 1, 3 do
	local str = "scorpion_crater_dark_tongue_" .. i

	AchievementTemplates.achievements[str] = {
		required_dlc = "scorpion",
		display_completion_ui = true,
		ID_XB1 = 73 + i,
		ID_PS4 = "0" .. tostring(72 + i),
		name = "achv_scorpion_crater_dark_tongue_" .. i .. "_name",
		desc = "achv_scorpion_crater_dark_tongue_" .. i .. "_desc",
		icon = "achievement_trophy_scorpion_crater_dark_tongue_" .. i,
		completed = function (self, arg_17_1)
			-- function 17
			return self:get_persistent_stat(arg_17_1, "scorpion_crater_dark_tongue_" .. i) >= 1
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
	completed = function (self, arg_18_1)
		-- function 18
		return self:get_persistent_stat(arg_18_1, "scorpion_crater_detour") > 0
	end
}
AchievementTemplates.achievements.scorpion_crater_ambush = {
	required_dlc = "scorpion",
	name = "achv_scorpion_crater_ambush_name",
	display_completion_ui = true,
	icon = "achievement_trophy_scorpion_crater_ambush",
	desc = function ()
		-- function 19
		return string.format(Localize("achv_scorpion_crater_ambush_desc"), QuestSettings.nurgle_bathed_all_cata)
	end,
	completed = function (self, arg_20_1)
		-- function 20
		return self:get_persistent_stat(arg_20_1, "scorpion_crater_ambush") > 0
	end
}
