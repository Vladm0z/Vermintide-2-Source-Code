-- chunkname: @scripts/managers/achievements/achievement_templates_paperweight.lua

local var_0_0 = AchievementTemplateHelper.check_level_list
local var_0_1 = AchievementTemplateHelper.check_level_list_difficulty
local var_0_2 = AchievementTemplateHelper.hero_level

AchievementTemplates.achievements.holly_kruber_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_kruber_complete_all_levels",
	icon = "achievement_holly_kruber_complete_all_levels_desc",
	desc = "achv_holly_kruber_complete_all_levels_desc",
	completed = function (arg_1_0, arg_1_1)
		if arg_1_0:get_persistent_stat(arg_1_1, "completed_levels_empire_soldier", "magnus") > 0 and arg_1_0:get_persistent_stat(arg_1_1, "completed_levels_empire_soldier", "cemetery") > 0 and arg_1_0:get_persistent_stat(arg_1_1, "completed_levels_empire_soldier", "forest_ambush") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_2_0, arg_2_1)
		local var_2_0 = 0

		if arg_2_0:get_persistent_stat(arg_2_1, "completed_levels_empire_soldier", "magnus") > 0 then
			var_2_0 = var_2_0 + 1
		end

		if arg_2_0:get_persistent_stat(arg_2_1, "completed_levels_empire_soldier", "cemetery") > 0 then
			var_2_0 = var_2_0 + 1
		end

		if arg_2_0:get_persistent_stat(arg_2_1, "completed_levels_empire_soldier", "forest_ambush") > 0 then
			var_2_0 = var_2_0 + 1
		end

		return {
			var_2_0,
			3
		}
	end,
	requirements = function (arg_3_0, arg_3_1)
		local var_3_0 = arg_3_0:get_persistent_stat(arg_3_1, "completed_levels_empire_soldier", "magnus") > 0
		local var_3_1 = arg_3_0:get_persistent_stat(arg_3_1, "completed_levels_empire_soldier", "cemetery") > 0
		local var_3_2 = arg_3_0:get_persistent_stat(arg_3_1, "completed_levels_empire_soldier", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = var_3_0
			},
			{
				name = "level_name_cemetery",
				completed = var_3_1
			},
			{
				name = "level_name_forest_ambush",
				completed = var_3_2
			}
		}
	end
}
AchievementTemplates.achievements.holly_bardin_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_bardin_complete_all_levels",
	icon = "achievement_holly_bardin_complete_all_levels_desc",
	desc = "achv_holly_bardin_complete_all_levels_desc",
	completed = function (arg_4_0, arg_4_1)
		if arg_4_0:get_persistent_stat(arg_4_1, "completed_levels_dwarf_ranger", "magnus") > 0 and arg_4_0:get_persistent_stat(arg_4_1, "completed_levels_dwarf_ranger", "cemetery") > 0 and arg_4_0:get_persistent_stat(arg_4_1, "completed_levels_dwarf_ranger", "forest_ambush") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_5_0, arg_5_1)
		local var_5_0 = 0

		if arg_5_0:get_persistent_stat(arg_5_1, "completed_levels_dwarf_ranger", "magnus") > 0 then
			var_5_0 = var_5_0 + 1
		end

		if arg_5_0:get_persistent_stat(arg_5_1, "completed_levels_dwarf_ranger", "cemetery") > 0 then
			var_5_0 = var_5_0 + 1
		end

		if arg_5_0:get_persistent_stat(arg_5_1, "completed_levels_dwarf_ranger", "forest_ambush") > 0 then
			var_5_0 = var_5_0 + 1
		end

		return {
			var_5_0,
			3
		}
	end,
	requirements = function (arg_6_0, arg_6_1)
		local var_6_0 = arg_6_0:get_persistent_stat(arg_6_1, "completed_levels_dwarf_ranger", "magnus") > 0
		local var_6_1 = arg_6_0:get_persistent_stat(arg_6_1, "completed_levels_dwarf_ranger", "cemetery") > 0
		local var_6_2 = arg_6_0:get_persistent_stat(arg_6_1, "completed_levels_dwarf_ranger", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = var_6_0
			},
			{
				name = "level_name_cemetery",
				completed = var_6_1
			},
			{
				name = "level_name_forest_ambush",
				completed = var_6_2
			}
		}
	end
}
AchievementTemplates.achievements.holly_saltzpyre_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_saltzpyre_complete_all_levels",
	icon = "achievement_holly_saltzpyre_complete_all_levels_desc",
	desc = "achv_holly_saltzpyre_complete_all_levels_desc",
	completed = function (arg_7_0, arg_7_1)
		if arg_7_0:get_persistent_stat(arg_7_1, "completed_levels_witch_hunter", "magnus") > 0 and arg_7_0:get_persistent_stat(arg_7_1, "completed_levels_witch_hunter", "cemetery") > 0 and arg_7_0:get_persistent_stat(arg_7_1, "completed_levels_witch_hunter", "forest_ambush") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_8_0, arg_8_1)
		local var_8_0 = 0

		if arg_8_0:get_persistent_stat(arg_8_1, "completed_levels_witch_hunter", "magnus") > 0 then
			var_8_0 = var_8_0 + 1
		end

		if arg_8_0:get_persistent_stat(arg_8_1, "completed_levels_witch_hunter", "cemetery") > 0 then
			var_8_0 = var_8_0 + 1
		end

		if arg_8_0:get_persistent_stat(arg_8_1, "completed_levels_witch_hunter", "forest_ambush") > 0 then
			var_8_0 = var_8_0 + 1
		end

		return {
			var_8_0,
			3
		}
	end,
	requirements = function (arg_9_0, arg_9_1)
		local var_9_0 = arg_9_0:get_persistent_stat(arg_9_1, "completed_levels_witch_hunter", "magnus") > 0
		local var_9_1 = arg_9_0:get_persistent_stat(arg_9_1, "completed_levels_witch_hunter", "cemetery") > 0
		local var_9_2 = arg_9_0:get_persistent_stat(arg_9_1, "completed_levels_witch_hunter", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = var_9_0
			},
			{
				name = "level_name_cemetery",
				completed = var_9_1
			},
			{
				name = "level_name_forest_ambush",
				completed = var_9_2
			}
		}
	end
}
AchievementTemplates.achievements.holly_kerillian_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_kerillian_complete_all_levels",
	icon = "achievement_holly_kerillian_complete_all_levels_desc",
	desc = "achv_holly_kerillian_complete_all_levels_desc",
	completed = function (arg_10_0, arg_10_1)
		if arg_10_0:get_persistent_stat(arg_10_1, "completed_levels_wood_elf", "magnus") > 0 and arg_10_0:get_persistent_stat(arg_10_1, "completed_levels_wood_elf", "cemetery") > 0 and arg_10_0:get_persistent_stat(arg_10_1, "completed_levels_wood_elf", "forest_ambush") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_11_0, arg_11_1)
		local var_11_0 = 0

		if arg_11_0:get_persistent_stat(arg_11_1, "completed_levels_wood_elf", "magnus") > 0 then
			var_11_0 = var_11_0 + 1
		end

		if arg_11_0:get_persistent_stat(arg_11_1, "completed_levels_wood_elf", "cemetery") > 0 then
			var_11_0 = var_11_0 + 1
		end

		if arg_11_0:get_persistent_stat(arg_11_1, "completed_levels_wood_elf", "forest_ambush") > 0 then
			var_11_0 = var_11_0 + 1
		end

		return {
			var_11_0,
			3
		}
	end,
	requirements = function (arg_12_0, arg_12_1)
		local var_12_0 = arg_12_0:get_persistent_stat(arg_12_1, "completed_levels_wood_elf", "magnus") > 0
		local var_12_1 = arg_12_0:get_persistent_stat(arg_12_1, "completed_levels_wood_elf", "cemetery") > 0
		local var_12_2 = arg_12_0:get_persistent_stat(arg_12_1, "completed_levels_wood_elf", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = var_12_0
			},
			{
				name = "level_name_cemetery",
				completed = var_12_1
			},
			{
				name = "level_name_forest_ambush",
				completed = var_12_2
			}
		}
	end
}
AchievementTemplates.achievements.holly_sienna_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_sienna_complete_all_levels",
	icon = "achievement_holly_sienna_complete_all_levels_desc",
	desc = "achv_holly_sienna_complete_all_levels_desc",
	completed = function (arg_13_0, arg_13_1)
		if arg_13_0:get_persistent_stat(arg_13_1, "completed_levels_bright_wizard", "magnus") > 0 and arg_13_0:get_persistent_stat(arg_13_1, "completed_levels_bright_wizard", "cemetery") > 0 and arg_13_0:get_persistent_stat(arg_13_1, "completed_levels_bright_wizard", "forest_ambush") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_14_0, arg_14_1)
		local var_14_0 = 0

		if arg_14_0:get_persistent_stat(arg_14_1, "completed_levels_bright_wizard", "magnus") > 0 then
			var_14_0 = var_14_0 + 1
		end

		if arg_14_0:get_persistent_stat(arg_14_1, "completed_levels_bright_wizard", "cemetery") > 0 then
			var_14_0 = var_14_0 + 1
		end

		if arg_14_0:get_persistent_stat(arg_14_1, "completed_levels_bright_wizard", "forest_ambush") > 0 then
			var_14_0 = var_14_0 + 1
		end

		return {
			var_14_0,
			3
		}
	end,
	requirements = function (arg_15_0, arg_15_1)
		local var_15_0 = arg_15_0:get_persistent_stat(arg_15_1, "completed_levels_bright_wizard", "magnus") > 0
		local var_15_1 = arg_15_0:get_persistent_stat(arg_15_1, "completed_levels_bright_wizard", "cemetery") > 0
		local var_15_2 = arg_15_0:get_persistent_stat(arg_15_1, "completed_levels_bright_wizard", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = var_15_0
			},
			{
				name = "level_name_cemetery",
				completed = var_15_1
			},
			{
				name = "level_name_forest_ambush",
				completed = var_15_2
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
	completed = function (arg_16_0, arg_16_1)
		return arg_16_0:get_persistent_stat(arg_16_1, "holly_kills_es_dual_wield_hammer_sword") >= 1000
	end,
	progress = function (arg_17_0, arg_17_1)
		local var_17_0 = arg_17_0:get_persistent_stat(arg_17_1, "holly_kills_es_dual_wield_hammer_sword")

		return {
			var_17_0,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_kruber_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_kruber_weapon_skin_3",
	icon = "achievement_holly_kruber_weapon_skin_3_desc",
	desc = "achv_holly_kruber_weapon_skin_3_desc",
	completed = function (arg_18_0, arg_18_1)
		if arg_18_0:get_persistent_stat(arg_18_1, "holly_completed_level_warcamp_with_es_dual_wield_hammer_sword") > 0 and arg_18_0:get_persistent_stat(arg_18_1, "holly_completed_level_skaven_stronghold_with_es_dual_wield_hammer_sword") > 0 and arg_18_0:get_persistent_stat(arg_18_1, "holly_completed_level_ground_zero_with_es_dual_wield_hammer_sword") > 0 and arg_18_0:get_persistent_stat(arg_18_1, "holly_completed_level_skittergate_with_es_dual_wield_hammer_sword") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_19_0, arg_19_1)
		local var_19_0 = 0

		if arg_19_0:get_persistent_stat(arg_19_1, "holly_completed_level_warcamp_with_es_dual_wield_hammer_sword") > 0 then
			var_19_0 = var_19_0 + 1
		end

		if arg_19_0:get_persistent_stat(arg_19_1, "holly_completed_level_skaven_stronghold_with_es_dual_wield_hammer_sword") > 0 then
			var_19_0 = var_19_0 + 1
		end

		if arg_19_0:get_persistent_stat(arg_19_1, "holly_completed_level_ground_zero_with_es_dual_wield_hammer_sword") > 0 then
			var_19_0 = var_19_0 + 1
		end

		if arg_19_0:get_persistent_stat(arg_19_1, "holly_completed_level_skittergate_with_es_dual_wield_hammer_sword") > 0 then
			var_19_0 = var_19_0 + 1
		end

		return {
			var_19_0,
			4
		}
	end,
	requirements = function (arg_20_0, arg_20_1)
		local var_20_0 = arg_20_0:get_persistent_stat(arg_20_1, "holly_completed_level_warcamp_with_es_dual_wield_hammer_sword") > 0
		local var_20_1 = arg_20_0:get_persistent_stat(arg_20_1, "holly_completed_level_skaven_stronghold_with_es_dual_wield_hammer_sword") > 0
		local var_20_2 = arg_20_0:get_persistent_stat(arg_20_1, "holly_completed_level_ground_zero_with_es_dual_wield_hammer_sword") > 0
		local var_20_3 = arg_20_0:get_persistent_stat(arg_20_1, "holly_completed_level_skittergate_with_es_dual_wield_hammer_sword") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = var_20_0
			},
			{
				name = "level_name_skaven_stronghold",
				completed = var_20_1
			},
			{
				name = "level_name_ground_zero",
				completed = var_20_2
			},
			{
				name = "level_name_skittergate",
				completed = var_20_3
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
	completed = function (arg_21_0, arg_21_1)
		return arg_21_0:get_persistent_stat(arg_21_1, "holly_kills_dr_dual_wield_hammers") >= 1000
	end,
	progress = function (arg_22_0, arg_22_1)
		local var_22_0 = arg_22_0:get_persistent_stat(arg_22_1, "holly_kills_dr_dual_wield_hammers")

		return {
			var_22_0,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_bardin_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_bardin_weapon_skin_3",
	icon = "achievement_holly_bardin_weapon_skin_3_desc",
	desc = "achv_holly_bardin_weapon_skin_3_desc",
	completed = function (arg_23_0, arg_23_1)
		if arg_23_0:get_persistent_stat(arg_23_1, "holly_completed_level_warcamp_with_dr_dual_wield_hammers") > 0 and arg_23_0:get_persistent_stat(arg_23_1, "holly_completed_level_skaven_stronghold_with_dr_dual_wield_hammers") > 0 and arg_23_0:get_persistent_stat(arg_23_1, "holly_completed_level_ground_zero_with_dr_dual_wield_hammers") > 0 and arg_23_0:get_persistent_stat(arg_23_1, "holly_completed_level_skittergate_with_dr_dual_wield_hammers") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_24_0, arg_24_1)
		local var_24_0 = 0

		if arg_24_0:get_persistent_stat(arg_24_1, "holly_completed_level_warcamp_with_dr_dual_wield_hammers") > 0 then
			var_24_0 = var_24_0 + 1
		end

		if arg_24_0:get_persistent_stat(arg_24_1, "holly_completed_level_skaven_stronghold_with_dr_dual_wield_hammers") > 0 then
			var_24_0 = var_24_0 + 1
		end

		if arg_24_0:get_persistent_stat(arg_24_1, "holly_completed_level_ground_zero_with_dr_dual_wield_hammers") > 0 then
			var_24_0 = var_24_0 + 1
		end

		if arg_24_0:get_persistent_stat(arg_24_1, "holly_completed_level_skittergate_with_dr_dual_wield_hammers") > 0 then
			var_24_0 = var_24_0 + 1
		end

		return {
			var_24_0,
			4
		}
	end,
	requirements = function (arg_25_0, arg_25_1)
		local var_25_0 = arg_25_0:get_persistent_stat(arg_25_1, "holly_completed_level_warcamp_with_dr_dual_wield_hammers") > 0
		local var_25_1 = arg_25_0:get_persistent_stat(arg_25_1, "holly_completed_level_skaven_stronghold_with_dr_dual_wield_hammers") > 0
		local var_25_2 = arg_25_0:get_persistent_stat(arg_25_1, "holly_completed_level_ground_zero_with_dr_dual_wield_hammers") > 0
		local var_25_3 = arg_25_0:get_persistent_stat(arg_25_1, "holly_completed_level_skittergate_with_dr_dual_wield_hammers") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = var_25_0
			},
			{
				name = "level_name_skaven_stronghold",
				completed = var_25_1
			},
			{
				name = "level_name_ground_zero",
				completed = var_25_2
			},
			{
				name = "level_name_skittergate",
				completed = var_25_3
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
	completed = function (arg_26_0, arg_26_1)
		return arg_26_0:get_persistent_stat(arg_26_1, "holly_kills_we_1h_axe") >= 1000
	end,
	progress = function (arg_27_0, arg_27_1)
		local var_27_0 = arg_27_0:get_persistent_stat(arg_27_1, "holly_kills_we_1h_axe")

		return {
			var_27_0,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_kerillian_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_kerillian_weapon_skin_3",
	icon = "achievement_holly_kerillian_weapon_skin_3_desc",
	desc = "achv_holly_kerillian_weapon_skin_3_desc",
	completed = function (arg_28_0, arg_28_1)
		if arg_28_0:get_persistent_stat(arg_28_1, "holly_completed_level_warcamp_with_we_1h_axe") > 0 and arg_28_0:get_persistent_stat(arg_28_1, "holly_completed_level_skaven_stronghold_with_we_1h_axe") > 0 and arg_28_0:get_persistent_stat(arg_28_1, "holly_completed_level_ground_zero_with_we_1h_axe") > 0 and arg_28_0:get_persistent_stat(arg_28_1, "holly_completed_level_skittergate_with_we_1h_axe") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_29_0, arg_29_1)
		local var_29_0 = 0

		if arg_29_0:get_persistent_stat(arg_29_1, "holly_completed_level_warcamp_with_we_1h_axe") > 0 then
			var_29_0 = var_29_0 + 1
		end

		if arg_29_0:get_persistent_stat(arg_29_1, "holly_completed_level_skaven_stronghold_with_we_1h_axe") > 0 then
			var_29_0 = var_29_0 + 1
		end

		if arg_29_0:get_persistent_stat(arg_29_1, "holly_completed_level_ground_zero_with_we_1h_axe") > 0 then
			var_29_0 = var_29_0 + 1
		end

		if arg_29_0:get_persistent_stat(arg_29_1, "holly_completed_level_skittergate_with_we_1h_axe") > 0 then
			var_29_0 = var_29_0 + 1
		end

		return {
			var_29_0,
			4
		}
	end,
	requirements = function (arg_30_0, arg_30_1)
		local var_30_0 = arg_30_0:get_persistent_stat(arg_30_1, "holly_completed_level_warcamp_with_we_1h_axe") > 0
		local var_30_1 = arg_30_0:get_persistent_stat(arg_30_1, "holly_completed_level_skaven_stronghold_with_we_1h_axe") > 0
		local var_30_2 = arg_30_0:get_persistent_stat(arg_30_1, "holly_completed_level_ground_zero_with_we_1h_axe") > 0
		local var_30_3 = arg_30_0:get_persistent_stat(arg_30_1, "holly_completed_level_skittergate_with_we_1h_axe") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = var_30_0
			},
			{
				name = "level_name_skaven_stronghold",
				completed = var_30_1
			},
			{
				name = "level_name_ground_zero",
				completed = var_30_2
			},
			{
				name = "level_name_skittergate",
				completed = var_30_3
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
	completed = function (arg_31_0, arg_31_1)
		return arg_31_0:get_persistent_stat(arg_31_1, "holly_kills_wh_dual_wield_axe_falchion") >= 1000
	end,
	progress = function (arg_32_0, arg_32_1)
		local var_32_0 = arg_32_0:get_persistent_stat(arg_32_1, "holly_kills_wh_dual_wield_axe_falchion")

		return {
			var_32_0,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_saltzpyre_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_saltzpyre_weapon_skin_3",
	icon = "achievement_holly_saltzpyre_weapon_skin_3_desc",
	desc = "achv_holly_saltzpyre_weapon_skin_3_desc",
	completed = function (arg_33_0, arg_33_1)
		if arg_33_0:get_persistent_stat(arg_33_1, "holly_completed_level_warcamp_with_wh_dual_wield_axe_falchion") > 0 and arg_33_0:get_persistent_stat(arg_33_1, "holly_completed_level_skaven_stronghold_with_wh_dual_wield_axe_falchion") > 0 and arg_33_0:get_persistent_stat(arg_33_1, "holly_completed_level_ground_zero_with_wh_dual_wield_axe_falchion") > 0 and arg_33_0:get_persistent_stat(arg_33_1, "holly_completed_level_skittergate_with_wh_dual_wield_axe_falchion") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_34_0, arg_34_1)
		local var_34_0 = 0

		if arg_34_0:get_persistent_stat(arg_34_1, "holly_completed_level_warcamp_with_wh_dual_wield_axe_falchion") > 0 then
			var_34_0 = var_34_0 + 1
		end

		if arg_34_0:get_persistent_stat(arg_34_1, "holly_completed_level_skaven_stronghold_with_wh_dual_wield_axe_falchion") > 0 then
			var_34_0 = var_34_0 + 1
		end

		if arg_34_0:get_persistent_stat(arg_34_1, "holly_completed_level_ground_zero_with_wh_dual_wield_axe_falchion") > 0 then
			var_34_0 = var_34_0 + 1
		end

		if arg_34_0:get_persistent_stat(arg_34_1, "holly_completed_level_skittergate_with_wh_dual_wield_axe_falchion") > 0 then
			var_34_0 = var_34_0 + 1
		end

		return {
			var_34_0,
			4
		}
	end,
	requirements = function (arg_35_0, arg_35_1)
		local var_35_0 = arg_35_0:get_persistent_stat(arg_35_1, "holly_completed_level_warcamp_with_wh_dual_wield_axe_falchion") > 0
		local var_35_1 = arg_35_0:get_persistent_stat(arg_35_1, "holly_completed_level_skaven_stronghold_with_wh_dual_wield_axe_falchion") > 0
		local var_35_2 = arg_35_0:get_persistent_stat(arg_35_1, "holly_completed_level_ground_zero_with_wh_dual_wield_axe_falchion") > 0
		local var_35_3 = arg_35_0:get_persistent_stat(arg_35_1, "holly_completed_level_skittergate_with_wh_dual_wield_axe_falchion") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = var_35_0
			},
			{
				name = "level_name_skaven_stronghold",
				completed = var_35_1
			},
			{
				name = "level_name_ground_zero",
				completed = var_35_2
			},
			{
				name = "level_name_skittergate",
				completed = var_35_3
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
	completed = function (arg_36_0, arg_36_1)
		return arg_36_0:get_persistent_stat(arg_36_1, "holly_kills_bw_1h_crowbill") >= 1000
	end,
	progress = function (arg_37_0, arg_37_1)
		local var_37_0 = arg_37_0:get_persistent_stat(arg_37_1, "holly_kills_bw_1h_crowbill")

		return {
			var_37_0,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_sienna_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_sienna_weapon_skin_3",
	icon = "achievement_holly_sienna_weapon_skin_3_desc",
	desc = "achv_holly_sienna_weapon_skin_3_desc",
	completed = function (arg_38_0, arg_38_1)
		if arg_38_0:get_persistent_stat(arg_38_1, "holly_completed_level_warcamp_with_bw_1h_crowbill") > 0 and arg_38_0:get_persistent_stat(arg_38_1, "holly_completed_level_skaven_stronghold_with_bw_1h_crowbill") > 0 and arg_38_0:get_persistent_stat(arg_38_1, "holly_completed_level_ground_zero_with_bw_1h_crowbill") > 0 and arg_38_0:get_persistent_stat(arg_38_1, "holly_completed_level_skittergate_with_bw_1h_crowbill") > 0 then
			return true
		end

		return false
	end,
	progress = function (arg_39_0, arg_39_1)
		local var_39_0 = 0

		if arg_39_0:get_persistent_stat(arg_39_1, "holly_completed_level_warcamp_with_bw_1h_crowbill") > 0 then
			var_39_0 = var_39_0 + 1
		end

		if arg_39_0:get_persistent_stat(arg_39_1, "holly_completed_level_skaven_stronghold_with_bw_1h_crowbill") > 0 then
			var_39_0 = var_39_0 + 1
		end

		if arg_39_0:get_persistent_stat(arg_39_1, "holly_completed_level_ground_zero_with_bw_1h_crowbill") > 0 then
			var_39_0 = var_39_0 + 1
		end

		if arg_39_0:get_persistent_stat(arg_39_1, "holly_completed_level_skittergate_with_bw_1h_crowbill") > 0 then
			var_39_0 = var_39_0 + 1
		end

		return {
			var_39_0,
			4
		}
	end,
	requirements = function (arg_40_0, arg_40_1)
		local var_40_0 = arg_40_0:get_persistent_stat(arg_40_1, "holly_completed_level_warcamp_with_bw_1h_crowbill") > 0
		local var_40_1 = arg_40_0:get_persistent_stat(arg_40_1, "holly_completed_level_skaven_stronghold_with_bw_1h_crowbill") > 0
		local var_40_2 = arg_40_0:get_persistent_stat(arg_40_1, "holly_completed_level_ground_zero_with_bw_1h_crowbill") > 0
		local var_40_3 = arg_40_0:get_persistent_stat(arg_40_1, "holly_completed_level_skittergate_with_bw_1h_crowbill") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = var_40_0
			},
			{
				name = "level_name_skaven_stronghold",
				completed = var_40_1
			},
			{
				name = "level_name_ground_zero",
				completed = var_40_2
			},
			{
				name = "level_name_skittergate",
				completed = var_40_3
			}
		}
	end
}
