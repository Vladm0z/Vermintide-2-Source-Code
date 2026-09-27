-- chunkname: @scripts/managers/achievements/achievement_templates_paperweight.lua

local check_level_list = AchievementTemplateHelper.check_level_list
local check_level_list_difficulty = AchievementTemplateHelper.check_level_list_difficulty
local hero_level = AchievementTemplateHelper.hero_level

AchievementTemplates.achievements.holly_kruber_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_kruber_complete_all_levels",
	icon = "achievement_holly_kruber_complete_all_levels_desc",
	desc = "achv_holly_kruber_complete_all_levels_desc",
	completed = function (self, arg_1_1)
		-- function 1
		if not (not (self:get_persistent_stat(arg_1_1, "completed_levels_empire_soldier", "magnus") > 0) or not (self:get_persistent_stat(arg_1_1, "completed_levels_empire_soldier", "cemetery") > 0) or not (self:get_persistent_stat(arg_1_1, "completed_levels_empire_soldier", "forest_ambush") > 0)) then
			return true
		end

		return false
	end,
	progress = function (self, arg_2_1)
		-- function 2
		local num = 0

		if self:get_persistent_stat(arg_2_1, "completed_levels_empire_soldier", "magnus") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_2_1, "completed_levels_empire_soldier", "cemetery") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_2_1, "completed_levels_empire_soldier", "forest_ambush") > 0 then
			num = num + 1
		end

		return {
			num,
			3
		}
	end,
	requirements = function (self, arg_3_1)
		-- function 3
		local flag = self:get_persistent_stat(arg_3_1, "completed_levels_empire_soldier", "magnus") > 0
		local flag_2 = self:get_persistent_stat(arg_3_1, "completed_levels_empire_soldier", "cemetery") > 0
		local flag_3 = self:get_persistent_stat(arg_3_1, "completed_levels_empire_soldier", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = flag
			},
			{
				name = "level_name_cemetery",
				completed = flag_2
			},
			{
				name = "level_name_forest_ambush",
				completed = flag_3
			}
		}
	end
}
AchievementTemplates.achievements.holly_bardin_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_bardin_complete_all_levels",
	icon = "achievement_holly_bardin_complete_all_levels_desc",
	desc = "achv_holly_bardin_complete_all_levels_desc",
	completed = function (self, arg_4_1)
		-- function 4
		if not (not (self:get_persistent_stat(arg_4_1, "completed_levels_dwarf_ranger", "magnus") > 0) or not (self:get_persistent_stat(arg_4_1, "completed_levels_dwarf_ranger", "cemetery") > 0) or not (self:get_persistent_stat(arg_4_1, "completed_levels_dwarf_ranger", "forest_ambush") > 0)) then
			return true
		end

		return false
	end,
	progress = function (self, arg_5_1)
		-- function 5
		local num = 0

		if self:get_persistent_stat(arg_5_1, "completed_levels_dwarf_ranger", "magnus") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_5_1, "completed_levels_dwarf_ranger", "cemetery") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_5_1, "completed_levels_dwarf_ranger", "forest_ambush") > 0 then
			num = num + 1
		end

		return {
			num,
			3
		}
	end,
	requirements = function (self, arg_6_1)
		-- function 6
		local flag = self:get_persistent_stat(arg_6_1, "completed_levels_dwarf_ranger", "magnus") > 0
		local flag_2 = self:get_persistent_stat(arg_6_1, "completed_levels_dwarf_ranger", "cemetery") > 0
		local flag_3 = self:get_persistent_stat(arg_6_1, "completed_levels_dwarf_ranger", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = flag
			},
			{
				name = "level_name_cemetery",
				completed = flag_2
			},
			{
				name = "level_name_forest_ambush",
				completed = flag_3
			}
		}
	end
}
AchievementTemplates.achievements.holly_saltzpyre_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_saltzpyre_complete_all_levels",
	icon = "achievement_holly_saltzpyre_complete_all_levels_desc",
	desc = "achv_holly_saltzpyre_complete_all_levels_desc",
	completed = function (self, arg_7_1)
		-- function 7
		if not (not (self:get_persistent_stat(arg_7_1, "completed_levels_witch_hunter", "magnus") > 0) or not (self:get_persistent_stat(arg_7_1, "completed_levels_witch_hunter", "cemetery") > 0) or not (self:get_persistent_stat(arg_7_1, "completed_levels_witch_hunter", "forest_ambush") > 0)) then
			return true
		end

		return false
	end,
	progress = function (self, arg_8_1)
		-- function 8
		local num = 0

		if self:get_persistent_stat(arg_8_1, "completed_levels_witch_hunter", "magnus") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_8_1, "completed_levels_witch_hunter", "cemetery") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_8_1, "completed_levels_witch_hunter", "forest_ambush") > 0 then
			num = num + 1
		end

		return {
			num,
			3
		}
	end,
	requirements = function (self, arg_9_1)
		-- function 9
		local flag = self:get_persistent_stat(arg_9_1, "completed_levels_witch_hunter", "magnus") > 0
		local flag_2 = self:get_persistent_stat(arg_9_1, "completed_levels_witch_hunter", "cemetery") > 0
		local flag_3 = self:get_persistent_stat(arg_9_1, "completed_levels_witch_hunter", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = flag
			},
			{
				name = "level_name_cemetery",
				completed = flag_2
			},
			{
				name = "level_name_forest_ambush",
				completed = flag_3
			}
		}
	end
}
AchievementTemplates.achievements.holly_kerillian_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_kerillian_complete_all_levels",
	icon = "achievement_holly_kerillian_complete_all_levels_desc",
	desc = "achv_holly_kerillian_complete_all_levels_desc",
	completed = function (self, arg_10_1)
		-- function 10
		if not (not (self:get_persistent_stat(arg_10_1, "completed_levels_wood_elf", "magnus") > 0) or not (self:get_persistent_stat(arg_10_1, "completed_levels_wood_elf", "cemetery") > 0) or not (self:get_persistent_stat(arg_10_1, "completed_levels_wood_elf", "forest_ambush") > 0)) then
			return true
		end

		return false
	end,
	progress = function (self, arg_11_1)
		-- function 11
		local num = 0

		if self:get_persistent_stat(arg_11_1, "completed_levels_wood_elf", "magnus") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_11_1, "completed_levels_wood_elf", "cemetery") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_11_1, "completed_levels_wood_elf", "forest_ambush") > 0 then
			num = num + 1
		end

		return {
			num,
			3
		}
	end,
	requirements = function (self, arg_12_1)
		-- function 12
		local flag = self:get_persistent_stat(arg_12_1, "completed_levels_wood_elf", "magnus") > 0
		local flag_2 = self:get_persistent_stat(arg_12_1, "completed_levels_wood_elf", "cemetery") > 0
		local flag_3 = self:get_persistent_stat(arg_12_1, "completed_levels_wood_elf", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = flag
			},
			{
				name = "level_name_cemetery",
				completed = flag_2
			},
			{
				name = "level_name_forest_ambush",
				completed = flag_3
			}
		}
	end
}
AchievementTemplates.achievements.holly_sienna_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_sienna_complete_all_levels",
	icon = "achievement_holly_sienna_complete_all_levels_desc",
	desc = "achv_holly_sienna_complete_all_levels_desc",
	completed = function (self, arg_13_1)
		-- function 13
		if not (not (self:get_persistent_stat(arg_13_1, "completed_levels_bright_wizard", "magnus") > 0) or not (self:get_persistent_stat(arg_13_1, "completed_levels_bright_wizard", "cemetery") > 0) or not (self:get_persistent_stat(arg_13_1, "completed_levels_bright_wizard", "forest_ambush") > 0)) then
			return true
		end

		return false
	end,
	progress = function (self, arg_14_1)
		-- function 14
		local num = 0

		if self:get_persistent_stat(arg_14_1, "completed_levels_bright_wizard", "magnus") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_14_1, "completed_levels_bright_wizard", "cemetery") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_14_1, "completed_levels_bright_wizard", "forest_ambush") > 0 then
			num = num + 1
		end

		return {
			num,
			3
		}
	end,
	requirements = function (self, arg_15_1)
		-- function 15
		local flag = self:get_persistent_stat(arg_15_1, "completed_levels_bright_wizard", "magnus") > 0
		local flag_2 = self:get_persistent_stat(arg_15_1, "completed_levels_bright_wizard", "cemetery") > 0
		local flag_3 = self:get_persistent_stat(arg_15_1, "completed_levels_bright_wizard", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = flag
			},
			{
				name = "level_name_cemetery",
				completed = flag_2
			},
			{
				name = "level_name_forest_ambush",
				completed = flag_3
			}
		}
	end
}
AchievementTemplates.achievements.holly_kruber_weapon_skin_2 = {
	required_dlc = "holly",
	name = "achv_holly_kruber_weapon_skin_2",
	display_completion_ui = true,
	icon = "achievement_holly_kruber_weapon_skin_2_desc",
	desc = "achv_holly_kruber_weapon_skin_2_desc",
	completed = function (self, arg_16_1)
		-- function 16
		return self:get_persistent_stat(arg_16_1, "holly_kills_es_dual_wield_hammer_sword") >= 1000
	end,
	progress = function (self, arg_17_1)
		-- function 17
		local get_persistent_stat = self:get_persistent_stat(arg_17_1, "holly_kills_es_dual_wield_hammer_sword")

		return {
			get_persistent_stat,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_kruber_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_kruber_weapon_skin_3",
	icon = "achievement_holly_kruber_weapon_skin_3_desc",
	desc = "achv_holly_kruber_weapon_skin_3_desc",
	completed = function (self, arg_18_1)
		-- function 18
		if not (not (self:get_persistent_stat(arg_18_1, "holly_completed_level_warcamp_with_es_dual_wield_hammer_sword") > 0) or not (self:get_persistent_stat(arg_18_1, "holly_completed_level_skaven_stronghold_with_es_dual_wield_hammer_sword") > 0) or not (self:get_persistent_stat(arg_18_1, "holly_completed_level_ground_zero_with_es_dual_wield_hammer_sword") > 0) or not (self:get_persistent_stat(arg_18_1, "holly_completed_level_skittergate_with_es_dual_wield_hammer_sword") > 0)) then
			return true
		end

		return false
	end,
	progress = function (self, arg_19_1)
		-- function 19
		local num = 0

		if self:get_persistent_stat(arg_19_1, "holly_completed_level_warcamp_with_es_dual_wield_hammer_sword") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_19_1, "holly_completed_level_skaven_stronghold_with_es_dual_wield_hammer_sword") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_19_1, "holly_completed_level_ground_zero_with_es_dual_wield_hammer_sword") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_19_1, "holly_completed_level_skittergate_with_es_dual_wield_hammer_sword") > 0 then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (self, arg_20_1)
		-- function 20
		local flag = self:get_persistent_stat(arg_20_1, "holly_completed_level_warcamp_with_es_dual_wield_hammer_sword") > 0
		local flag_2 = self:get_persistent_stat(arg_20_1, "holly_completed_level_skaven_stronghold_with_es_dual_wield_hammer_sword") > 0
		local flag_3 = self:get_persistent_stat(arg_20_1, "holly_completed_level_ground_zero_with_es_dual_wield_hammer_sword") > 0
		local flag_4 = self:get_persistent_stat(arg_20_1, "holly_completed_level_skittergate_with_es_dual_wield_hammer_sword") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = flag
			},
			{
				name = "level_name_skaven_stronghold",
				completed = flag_2
			},
			{
				name = "level_name_ground_zero",
				completed = flag_3
			},
			{
				name = "level_name_skittergate",
				completed = flag_4
			}
		}
	end
}
AchievementTemplates.achievements.holly_bardin_weapon_skin_2 = {
	required_dlc = "holly",
	name = "achv_holly_bardin_weapon_skin_2",
	display_completion_ui = true,
	icon = "achievement_holly_bardin_weapon_skin_2_desc",
	desc = "achv_holly_bardin_weapon_skin_2_desc",
	completed = function (self, arg_21_1)
		-- function 21
		return self:get_persistent_stat(arg_21_1, "holly_kills_dr_dual_wield_hammers") >= 1000
	end,
	progress = function (self, arg_22_1)
		-- function 22
		local get_persistent_stat = self:get_persistent_stat(arg_22_1, "holly_kills_dr_dual_wield_hammers")

		return {
			get_persistent_stat,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_bardin_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_bardin_weapon_skin_3",
	icon = "achievement_holly_bardin_weapon_skin_3_desc",
	desc = "achv_holly_bardin_weapon_skin_3_desc",
	completed = function (self, arg_23_1)
		-- function 23
		if not (not (self:get_persistent_stat(arg_23_1, "holly_completed_level_warcamp_with_dr_dual_wield_hammers") > 0) or not (self:get_persistent_stat(arg_23_1, "holly_completed_level_skaven_stronghold_with_dr_dual_wield_hammers") > 0) or not (self:get_persistent_stat(arg_23_1, "holly_completed_level_ground_zero_with_dr_dual_wield_hammers") > 0) or not (self:get_persistent_stat(arg_23_1, "holly_completed_level_skittergate_with_dr_dual_wield_hammers") > 0)) then
			return true
		end

		return false
	end,
	progress = function (self, arg_24_1)
		-- function 24
		local num = 0

		if self:get_persistent_stat(arg_24_1, "holly_completed_level_warcamp_with_dr_dual_wield_hammers") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_24_1, "holly_completed_level_skaven_stronghold_with_dr_dual_wield_hammers") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_24_1, "holly_completed_level_ground_zero_with_dr_dual_wield_hammers") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_24_1, "holly_completed_level_skittergate_with_dr_dual_wield_hammers") > 0 then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (self, arg_25_1)
		-- function 25
		local flag = self:get_persistent_stat(arg_25_1, "holly_completed_level_warcamp_with_dr_dual_wield_hammers") > 0
		local flag_2 = self:get_persistent_stat(arg_25_1, "holly_completed_level_skaven_stronghold_with_dr_dual_wield_hammers") > 0
		local flag_3 = self:get_persistent_stat(arg_25_1, "holly_completed_level_ground_zero_with_dr_dual_wield_hammers") > 0
		local flag_4 = self:get_persistent_stat(arg_25_1, "holly_completed_level_skittergate_with_dr_dual_wield_hammers") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = flag
			},
			{
				name = "level_name_skaven_stronghold",
				completed = flag_2
			},
			{
				name = "level_name_ground_zero",
				completed = flag_3
			},
			{
				name = "level_name_skittergate",
				completed = flag_4
			}
		}
	end
}
AchievementTemplates.achievements.holly_kerillian_weapon_skin_2 = {
	required_dlc = "holly",
	name = "achv_holly_kerillian_weapon_skin_2",
	display_completion_ui = true,
	icon = "achievement_holly_kerillian_weapon_skin_2_desc",
	desc = "achv_holly_kerillian_weapon_skin_2_desc",
	completed = function (self, arg_26_1)
		-- function 26
		return self:get_persistent_stat(arg_26_1, "holly_kills_we_1h_axe") >= 1000
	end,
	progress = function (self, arg_27_1)
		-- function 27
		local get_persistent_stat = self:get_persistent_stat(arg_27_1, "holly_kills_we_1h_axe")

		return {
			get_persistent_stat,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_kerillian_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_kerillian_weapon_skin_3",
	icon = "achievement_holly_kerillian_weapon_skin_3_desc",
	desc = "achv_holly_kerillian_weapon_skin_3_desc",
	completed = function (self, arg_28_1)
		-- function 28
		if not (not (self:get_persistent_stat(arg_28_1, "holly_completed_level_warcamp_with_we_1h_axe") > 0) or not (self:get_persistent_stat(arg_28_1, "holly_completed_level_skaven_stronghold_with_we_1h_axe") > 0) or not (self:get_persistent_stat(arg_28_1, "holly_completed_level_ground_zero_with_we_1h_axe") > 0) or not (self:get_persistent_stat(arg_28_1, "holly_completed_level_skittergate_with_we_1h_axe") > 0)) then
			return true
		end

		return false
	end,
	progress = function (self, arg_29_1)
		-- function 29
		local num = 0

		if self:get_persistent_stat(arg_29_1, "holly_completed_level_warcamp_with_we_1h_axe") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_29_1, "holly_completed_level_skaven_stronghold_with_we_1h_axe") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_29_1, "holly_completed_level_ground_zero_with_we_1h_axe") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_29_1, "holly_completed_level_skittergate_with_we_1h_axe") > 0 then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (self, arg_30_1)
		-- function 30
		local flag = self:get_persistent_stat(arg_30_1, "holly_completed_level_warcamp_with_we_1h_axe") > 0
		local flag_2 = self:get_persistent_stat(arg_30_1, "holly_completed_level_skaven_stronghold_with_we_1h_axe") > 0
		local flag_3 = self:get_persistent_stat(arg_30_1, "holly_completed_level_ground_zero_with_we_1h_axe") > 0
		local flag_4 = self:get_persistent_stat(arg_30_1, "holly_completed_level_skittergate_with_we_1h_axe") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = flag
			},
			{
				name = "level_name_skaven_stronghold",
				completed = flag_2
			},
			{
				name = "level_name_ground_zero",
				completed = flag_3
			},
			{
				name = "level_name_skittergate",
				completed = flag_4
			}
		}
	end
}
AchievementTemplates.achievements.holly_saltzpyre_weapon_skin_2 = {
	required_dlc = "holly",
	name = "achv_holly_saltzpyre_weapon_skin_2",
	display_completion_ui = true,
	icon = "achievement_holly_saltzpyre_weapon_skin_2_desc",
	desc = "achv_holly_saltzpyre_weapon_skin_2_desc",
	completed = function (self, arg_31_1)
		-- function 31
		return self:get_persistent_stat(arg_31_1, "holly_kills_wh_dual_wield_axe_falchion") >= 1000
	end,
	progress = function (self, arg_32_1)
		-- function 32
		local get_persistent_stat = self:get_persistent_stat(arg_32_1, "holly_kills_wh_dual_wield_axe_falchion")

		return {
			get_persistent_stat,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_saltzpyre_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_saltzpyre_weapon_skin_3",
	icon = "achievement_holly_saltzpyre_weapon_skin_3_desc",
	desc = "achv_holly_saltzpyre_weapon_skin_3_desc",
	completed = function (self, arg_33_1)
		-- function 33
		if not (not (self:get_persistent_stat(arg_33_1, "holly_completed_level_warcamp_with_wh_dual_wield_axe_falchion") > 0) or not (self:get_persistent_stat(arg_33_1, "holly_completed_level_skaven_stronghold_with_wh_dual_wield_axe_falchion") > 0) or not (self:get_persistent_stat(arg_33_1, "holly_completed_level_ground_zero_with_wh_dual_wield_axe_falchion") > 0) or not (self:get_persistent_stat(arg_33_1, "holly_completed_level_skittergate_with_wh_dual_wield_axe_falchion") > 0)) then
			return true
		end

		return false
	end,
	progress = function (self, arg_34_1)
		-- function 34
		local num = 0

		if self:get_persistent_stat(arg_34_1, "holly_completed_level_warcamp_with_wh_dual_wield_axe_falchion") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_34_1, "holly_completed_level_skaven_stronghold_with_wh_dual_wield_axe_falchion") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_34_1, "holly_completed_level_ground_zero_with_wh_dual_wield_axe_falchion") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_34_1, "holly_completed_level_skittergate_with_wh_dual_wield_axe_falchion") > 0 then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (self, arg_35_1)
		-- function 35
		local flag = self:get_persistent_stat(arg_35_1, "holly_completed_level_warcamp_with_wh_dual_wield_axe_falchion") > 0
		local flag_2 = self:get_persistent_stat(arg_35_1, "holly_completed_level_skaven_stronghold_with_wh_dual_wield_axe_falchion") > 0
		local flag_3 = self:get_persistent_stat(arg_35_1, "holly_completed_level_ground_zero_with_wh_dual_wield_axe_falchion") > 0
		local flag_4 = self:get_persistent_stat(arg_35_1, "holly_completed_level_skittergate_with_wh_dual_wield_axe_falchion") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = flag
			},
			{
				name = "level_name_skaven_stronghold",
				completed = flag_2
			},
			{
				name = "level_name_ground_zero",
				completed = flag_3
			},
			{
				name = "level_name_skittergate",
				completed = flag_4
			}
		}
	end
}
AchievementTemplates.achievements.holly_sienna_weapon_skin_2 = {
	required_dlc = "holly",
	name = "achv_holly_sienna_weapon_skin_2",
	display_completion_ui = true,
	icon = "achievement_holly_sienna_weapon_skin_2_desc",
	desc = "achv_holly_sienna_weapon_skin_2_desc",
	completed = function (self, arg_36_1)
		-- function 36
		return self:get_persistent_stat(arg_36_1, "holly_kills_bw_1h_crowbill") >= 1000
	end,
	progress = function (self, arg_37_1)
		-- function 37
		local get_persistent_stat = self:get_persistent_stat(arg_37_1, "holly_kills_bw_1h_crowbill")

		return {
			get_persistent_stat,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_sienna_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_sienna_weapon_skin_3",
	icon = "achievement_holly_sienna_weapon_skin_3_desc",
	desc = "achv_holly_sienna_weapon_skin_3_desc",
	completed = function (self, arg_38_1)
		-- function 38
		if not (not (self:get_persistent_stat(arg_38_1, "holly_completed_level_warcamp_with_bw_1h_crowbill") > 0) or not (self:get_persistent_stat(arg_38_1, "holly_completed_level_skaven_stronghold_with_bw_1h_crowbill") > 0) or not (self:get_persistent_stat(arg_38_1, "holly_completed_level_ground_zero_with_bw_1h_crowbill") > 0) or not (self:get_persistent_stat(arg_38_1, "holly_completed_level_skittergate_with_bw_1h_crowbill") > 0)) then
			return true
		end

		return false
	end,
	progress = function (self, arg_39_1)
		-- function 39
		local num = 0

		if self:get_persistent_stat(arg_39_1, "holly_completed_level_warcamp_with_bw_1h_crowbill") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_39_1, "holly_completed_level_skaven_stronghold_with_bw_1h_crowbill") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_39_1, "holly_completed_level_ground_zero_with_bw_1h_crowbill") > 0 then
			num = num + 1
		end

		if self:get_persistent_stat(arg_39_1, "holly_completed_level_skittergate_with_bw_1h_crowbill") > 0 then
			num = num + 1
		end

		return {
			num,
			4
		}
	end,
	requirements = function (self, arg_40_1)
		-- function 40
		local flag = self:get_persistent_stat(arg_40_1, "holly_completed_level_warcamp_with_bw_1h_crowbill") > 0
		local flag_2 = self:get_persistent_stat(arg_40_1, "holly_completed_level_skaven_stronghold_with_bw_1h_crowbill") > 0
		local flag_3 = self:get_persistent_stat(arg_40_1, "holly_completed_level_ground_zero_with_bw_1h_crowbill") > 0
		local flag_4 = self:get_persistent_stat(arg_40_1, "holly_completed_level_skittergate_with_bw_1h_crowbill") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = flag
			},
			{
				name = "level_name_skaven_stronghold",
				completed = flag_2
			},
			{
				name = "level_name_ground_zero",
				completed = flag_3
			},
			{
				name = "level_name_skittergate",
				completed = flag_4
			}
		}
	end
}
