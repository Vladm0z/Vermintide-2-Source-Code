-- chunkname: @scripts/managers/achievements/achievement_templates_belladonna.lua

AchievementTemplates.achievements.scorpion_bestigor_charge_chaos_warrior = {
	required_dlc = "scorpion",
	name = "achv_scorpion_bestigor_charge_chaos_warrior_name",
	display_completion_ui = true,
	icon = "achievement_trophy_scorpion_bestigor_charge_chaos_warrior",
	desc = "achv_scorpion_bestigor_charge_chaos_warrior_desc",
	completed = function (self, arg_1_1)
		-- function 1
		return self:get_persistent_stat(arg_1_1, "scorpion_bestigor_charge_chaos_warrior") > 0
	end
}
AchievementTemplates.achievements.scorpion_kill_minotaur_farmlands_oak = {
	required_dlc = "scorpion",
	name = "achv_scorpion_kill_minotaur_farmlands_oak_name",
	display_completion_ui = true,
	icon = "achievement_trophy_scorpion_kill_minotaur_farmlands_oak",
	desc = "achv_scorpion_kill_minotaur_farmlands_oak_desc",
	completed = function (self, arg_2_1)
		-- function 2
		return self:get_persistent_stat(arg_2_1, "scorpion_kill_minotaur_farmlands_oak") > 0
	end
}
AchievementTemplates.achievements.scorpion_kill_archers_kill_minotaur = {
	required_dlc = "scorpion",
	name = "achv_scorpion_kill_archers_kill_minotaur_name",
	display_completion_ui = true,
	icon = "achievement_trophy_scorpion_kill_archers_kill_minotaur",
	desc = "achv_scorpion_kill_archers_kill_minotaur_desc",
	completed = function (self, arg_3_1)
		-- function 3
		return self:get_persistent_stat(arg_3_1, "scorpion_kill_archers_kill_minotaur") > 0
	end
}
AchievementTemplates.achievements.scorpion_keep_standard_bearer_alive = {
	required_dlc = "scorpion",
	name = "achv_scorpion_keep_standard_bearer_alive_name",
	display_completion_ui = true,
	icon = "achievement_trophy_scorpion_keep_standard_bearer_alive",
	desc = function ()
		-- function 4
		return string.format(Localize("achv_scorpion_keep_standard_bearer_alive_desc"), QuestSettings.standard_bearer_alive_seconds)
	end,
	completed = function (self, arg_5_1)
		-- function 5
		return self:get_persistent_stat(arg_5_1, "scorpion_keep_standard_bearer_alive") > 0
	end
}
AchievementTemplates.achievements.scorpion_slay_gors_warpfire_damage = {
	required_dlc = "scorpion",
	name = "achv_scorpion_slay_gors_warpfire_damage_name",
	display_completion_ui = true,
	icon = "achievement_trophy_scorpion_slay_gors_warpfire_damage",
	desc = function ()
		-- function 6
		return string.format(Localize("achv_scorpion_slay_gors_warpfire_damage_desc"), QuestSettings.num_gors_killed_by_warpfire)
	end,
	completed = function (self, arg_7_1)
		-- function 7
		return self:get_persistent_stat(arg_7_1, "scorpion_slay_gors_warpfire_damage") > 0
	end
}
