-- chunkname: @scripts/managers/achievements/achievement_templates_paperweight.lua

local check_level_list = AchievementTemplateHelper.check_level_list
local check_level_list_difficulty = AchievementTemplateHelper.check_level_list_difficulty
local hero_level = AchievementTemplateHelper.hero_level

AchievementTemplates.achievements.holly_kruber_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_kruber_complete_all_levels",
	icon = "achievement_holly_kruber_complete_all_levels_desc",
	desc = "achv_holly_kruber_complete_all_levels_desc",
	completed = function (statistics_db, stats_id)
		-- function 1
		if statistics_db:get_persistent_stat(stats_id, "completed_levels_empire_soldier", "magnus") > 0 and statistics_db:get_persistent_stat(stats_id, "completed_levels_empire_soldier", "cemetery") > 0 and statistics_db:get_persistent_stat(stats_id, "completed_levels_empire_soldier", "forest_ambush") > 0 then
			return true
		end

		return false
	end,
	progress = function (statistics_db, stats_id)
		-- function 2
		local count = 0

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_empire_soldier", "magnus") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_empire_soldier", "cemetery") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_empire_soldier", "forest_ambush") > 0 then
			count = count + 1
		end

		return {
			count,
			3
		}
	end,
	requirements = function (statistics_db, stats_id)
		-- function 3
		local magnus = statistics_db:get_persistent_stat(stats_id, "completed_levels_empire_soldier", "magnus") > 0
		local cemetery = statistics_db:get_persistent_stat(stats_id, "completed_levels_empire_soldier", "cemetery") > 0
		local forest_ambush = statistics_db:get_persistent_stat(stats_id, "completed_levels_empire_soldier", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = magnus
			},
			{
				name = "level_name_cemetery",
				completed = cemetery
			},
			{
				name = "level_name_forest_ambush",
				completed = forest_ambush
			}
		}
	end
}
AchievementTemplates.achievements.holly_bardin_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_bardin_complete_all_levels",
	icon = "achievement_holly_bardin_complete_all_levels_desc",
	desc = "achv_holly_bardin_complete_all_levels_desc",
	completed = function (statistics_db, stats_id)
		-- function 4
		if statistics_db:get_persistent_stat(stats_id, "completed_levels_dwarf_ranger", "magnus") > 0 and statistics_db:get_persistent_stat(stats_id, "completed_levels_dwarf_ranger", "cemetery") > 0 and statistics_db:get_persistent_stat(stats_id, "completed_levels_dwarf_ranger", "forest_ambush") > 0 then
			return true
		end

		return false
	end,
	progress = function (statistics_db, stats_id)
		-- function 5
		local count = 0

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_dwarf_ranger", "magnus") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_dwarf_ranger", "cemetery") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_dwarf_ranger", "forest_ambush") > 0 then
			count = count + 1
		end

		return {
			count,
			3
		}
	end,
	requirements = function (statistics_db, stats_id)
		-- function 6
		local magnus = statistics_db:get_persistent_stat(stats_id, "completed_levels_dwarf_ranger", "magnus") > 0
		local cemetery = statistics_db:get_persistent_stat(stats_id, "completed_levels_dwarf_ranger", "cemetery") > 0
		local forest_ambush = statistics_db:get_persistent_stat(stats_id, "completed_levels_dwarf_ranger", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = magnus
			},
			{
				name = "level_name_cemetery",
				completed = cemetery
			},
			{
				name = "level_name_forest_ambush",
				completed = forest_ambush
			}
		}
	end
}
AchievementTemplates.achievements.holly_saltzpyre_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_saltzpyre_complete_all_levels",
	icon = "achievement_holly_saltzpyre_complete_all_levels_desc",
	desc = "achv_holly_saltzpyre_complete_all_levels_desc",
	completed = function (statistics_db, stats_id)
		-- function 7
		if statistics_db:get_persistent_stat(stats_id, "completed_levels_witch_hunter", "magnus") > 0 and statistics_db:get_persistent_stat(stats_id, "completed_levels_witch_hunter", "cemetery") > 0 and statistics_db:get_persistent_stat(stats_id, "completed_levels_witch_hunter", "forest_ambush") > 0 then
			return true
		end

		return false
	end,
	progress = function (statistics_db, stats_id)
		-- function 8
		local count = 0

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_witch_hunter", "magnus") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_witch_hunter", "cemetery") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_witch_hunter", "forest_ambush") > 0 then
			count = count + 1
		end

		return {
			count,
			3
		}
	end,
	requirements = function (statistics_db, stats_id)
		-- function 9
		local magnus = statistics_db:get_persistent_stat(stats_id, "completed_levels_witch_hunter", "magnus") > 0
		local cemetery = statistics_db:get_persistent_stat(stats_id, "completed_levels_witch_hunter", "cemetery") > 0
		local forest_ambush = statistics_db:get_persistent_stat(stats_id, "completed_levels_witch_hunter", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = magnus
			},
			{
				name = "level_name_cemetery",
				completed = cemetery
			},
			{
				name = "level_name_forest_ambush",
				completed = forest_ambush
			}
		}
	end
}
AchievementTemplates.achievements.holly_kerillian_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_kerillian_complete_all_levels",
	icon = "achievement_holly_kerillian_complete_all_levels_desc",
	desc = "achv_holly_kerillian_complete_all_levels_desc",
	completed = function (statistics_db, stats_id)
		-- function 10
		if statistics_db:get_persistent_stat(stats_id, "completed_levels_wood_elf", "magnus") > 0 and statistics_db:get_persistent_stat(stats_id, "completed_levels_wood_elf", "cemetery") > 0 and statistics_db:get_persistent_stat(stats_id, "completed_levels_wood_elf", "forest_ambush") > 0 then
			return true
		end

		return false
	end,
	progress = function (statistics_db, stats_id)
		-- function 11
		local count = 0

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_wood_elf", "magnus") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_wood_elf", "cemetery") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_wood_elf", "forest_ambush") > 0 then
			count = count + 1
		end

		return {
			count,
			3
		}
	end,
	requirements = function (statistics_db, stats_id)
		-- function 12
		local magnus = statistics_db:get_persistent_stat(stats_id, "completed_levels_wood_elf", "magnus") > 0
		local cemetery = statistics_db:get_persistent_stat(stats_id, "completed_levels_wood_elf", "cemetery") > 0
		local forest_ambush = statistics_db:get_persistent_stat(stats_id, "completed_levels_wood_elf", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = magnus
			},
			{
				name = "level_name_cemetery",
				completed = cemetery
			},
			{
				name = "level_name_forest_ambush",
				completed = forest_ambush
			}
		}
	end
}
AchievementTemplates.achievements.holly_sienna_complete_all_levels = {
	required_dlc = "holly",
	name = "achv_holly_sienna_complete_all_levels",
	icon = "achievement_holly_sienna_complete_all_levels_desc",
	desc = "achv_holly_sienna_complete_all_levels_desc",
	completed = function (statistics_db, stats_id)
		-- function 13
		if statistics_db:get_persistent_stat(stats_id, "completed_levels_bright_wizard", "magnus") > 0 and statistics_db:get_persistent_stat(stats_id, "completed_levels_bright_wizard", "cemetery") > 0 and statistics_db:get_persistent_stat(stats_id, "completed_levels_bright_wizard", "forest_ambush") > 0 then
			return true
		end

		return false
	end,
	progress = function (statistics_db, stats_id)
		-- function 14
		local count = 0

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_bright_wizard", "magnus") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_bright_wizard", "cemetery") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "completed_levels_bright_wizard", "forest_ambush") > 0 then
			count = count + 1
		end

		return {
			count,
			3
		}
	end,
	requirements = function (statistics_db, stats_id)
		-- function 15
		local magnus = statistics_db:get_persistent_stat(stats_id, "completed_levels_bright_wizard", "magnus") > 0
		local cemetery = statistics_db:get_persistent_stat(stats_id, "completed_levels_bright_wizard", "cemetery") > 0
		local forest_ambush = statistics_db:get_persistent_stat(stats_id, "completed_levels_bright_wizard", "forest_ambush") > 0

		return {
			{
				name = "level_name_magnus",
				completed = magnus
			},
			{
				name = "level_name_cemetery",
				completed = cemetery
			},
			{
				name = "level_name_forest_ambush",
				completed = forest_ambush
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
	completed = function (statistics_db, stats_id)
		-- function 16
		return statistics_db:get_persistent_stat(stats_id, "holly_kills_es_dual_wield_hammer_sword") >= 1000
	end,
	progress = function (statistics_db, stats_id)
		-- function 17
		local count = statistics_db:get_persistent_stat(stats_id, "holly_kills_es_dual_wield_hammer_sword")

		return {
			count,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_kruber_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_kruber_weapon_skin_3",
	icon = "achievement_holly_kruber_weapon_skin_3_desc",
	desc = "achv_holly_kruber_weapon_skin_3_desc",
	completed = function (statistics_db, stats_id)
		-- function 18
		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_es_dual_wield_hammer_sword") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_es_dual_wield_hammer_sword") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_es_dual_wield_hammer_sword") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_es_dual_wield_hammer_sword") > 0 then
			return true
		end

		return false
	end,
	progress = function (statistics_db, stats_id)
		-- function 19
		local count = 0

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_es_dual_wield_hammer_sword") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_es_dual_wield_hammer_sword") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_es_dual_wield_hammer_sword") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_es_dual_wield_hammer_sword") > 0 then
			count = count + 1
		end

		return {
			count,
			4
		}
	end,
	requirements = function (statistics_db, stats_id)
		-- function 20
		local warcamp = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_es_dual_wield_hammer_sword") > 0
		local skaven_stronghold = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_es_dual_wield_hammer_sword") > 0
		local ground_zero = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_es_dual_wield_hammer_sword") > 0
		local skittergate = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_es_dual_wield_hammer_sword") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = warcamp
			},
			{
				name = "level_name_skaven_stronghold",
				completed = skaven_stronghold
			},
			{
				name = "level_name_ground_zero",
				completed = ground_zero
			},
			{
				name = "level_name_skittergate",
				completed = skittergate
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
	completed = function (statistics_db, stats_id)
		-- function 21
		return statistics_db:get_persistent_stat(stats_id, "holly_kills_dr_dual_wield_hammers") >= 1000
	end,
	progress = function (statistics_db, stats_id)
		-- function 22
		local count = statistics_db:get_persistent_stat(stats_id, "holly_kills_dr_dual_wield_hammers")

		return {
			count,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_bardin_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_bardin_weapon_skin_3",
	icon = "achievement_holly_bardin_weapon_skin_3_desc",
	desc = "achv_holly_bardin_weapon_skin_3_desc",
	completed = function (statistics_db, stats_id)
		-- function 23
		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_dr_dual_wield_hammers") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_dr_dual_wield_hammers") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_dr_dual_wield_hammers") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_dr_dual_wield_hammers") > 0 then
			return true
		end

		return false
	end,
	progress = function (statistics_db, stats_id)
		-- function 24
		local count = 0

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_dr_dual_wield_hammers") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_dr_dual_wield_hammers") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_dr_dual_wield_hammers") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_dr_dual_wield_hammers") > 0 then
			count = count + 1
		end

		return {
			count,
			4
		}
	end,
	requirements = function (statistics_db, stats_id)
		-- function 25
		local warcamp = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_dr_dual_wield_hammers") > 0
		local skaven_stronghold = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_dr_dual_wield_hammers") > 0
		local ground_zero = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_dr_dual_wield_hammers") > 0
		local skittergate = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_dr_dual_wield_hammers") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = warcamp
			},
			{
				name = "level_name_skaven_stronghold",
				completed = skaven_stronghold
			},
			{
				name = "level_name_ground_zero",
				completed = ground_zero
			},
			{
				name = "level_name_skittergate",
				completed = skittergate
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
	completed = function (statistics_db, stats_id)
		-- function 26
		return statistics_db:get_persistent_stat(stats_id, "holly_kills_we_1h_axe") >= 1000
	end,
	progress = function (statistics_db, stats_id)
		-- function 27
		local count = statistics_db:get_persistent_stat(stats_id, "holly_kills_we_1h_axe")

		return {
			count,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_kerillian_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_kerillian_weapon_skin_3",
	icon = "achievement_holly_kerillian_weapon_skin_3_desc",
	desc = "achv_holly_kerillian_weapon_skin_3_desc",
	completed = function (statistics_db, stats_id)
		-- function 28
		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_we_1h_axe") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_we_1h_axe") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_we_1h_axe") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_we_1h_axe") > 0 then
			return true
		end

		return false
	end,
	progress = function (statistics_db, stats_id)
		-- function 29
		local count = 0

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_we_1h_axe") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_we_1h_axe") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_we_1h_axe") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_we_1h_axe") > 0 then
			count = count + 1
		end

		return {
			count,
			4
		}
	end,
	requirements = function (statistics_db, stats_id)
		-- function 30
		local warcamp = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_we_1h_axe") > 0
		local skaven_stronghold = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_we_1h_axe") > 0
		local ground_zero = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_we_1h_axe") > 0
		local skittergate = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_we_1h_axe") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = warcamp
			},
			{
				name = "level_name_skaven_stronghold",
				completed = skaven_stronghold
			},
			{
				name = "level_name_ground_zero",
				completed = ground_zero
			},
			{
				name = "level_name_skittergate",
				completed = skittergate
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
	completed = function (statistics_db, stats_id)
		-- function 31
		return statistics_db:get_persistent_stat(stats_id, "holly_kills_wh_dual_wield_axe_falchion") >= 1000
	end,
	progress = function (statistics_db, stats_id)
		-- function 32
		local count = statistics_db:get_persistent_stat(stats_id, "holly_kills_wh_dual_wield_axe_falchion")

		return {
			count,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_saltzpyre_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_saltzpyre_weapon_skin_3",
	icon = "achievement_holly_saltzpyre_weapon_skin_3_desc",
	desc = "achv_holly_saltzpyre_weapon_skin_3_desc",
	completed = function (statistics_db, stats_id)
		-- function 33
		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_wh_dual_wield_axe_falchion") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_wh_dual_wield_axe_falchion") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_wh_dual_wield_axe_falchion") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_wh_dual_wield_axe_falchion") > 0 then
			return true
		end

		return false
	end,
	progress = function (statistics_db, stats_id)
		-- function 34
		local count = 0

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_wh_dual_wield_axe_falchion") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_wh_dual_wield_axe_falchion") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_wh_dual_wield_axe_falchion") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_wh_dual_wield_axe_falchion") > 0 then
			count = count + 1
		end

		return {
			count,
			4
		}
	end,
	requirements = function (statistics_db, stats_id)
		-- function 35
		local warcamp = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_wh_dual_wield_axe_falchion") > 0
		local skaven_stronghold = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_wh_dual_wield_axe_falchion") > 0
		local ground_zero = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_wh_dual_wield_axe_falchion") > 0
		local skittergate = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_wh_dual_wield_axe_falchion") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = warcamp
			},
			{
				name = "level_name_skaven_stronghold",
				completed = skaven_stronghold
			},
			{
				name = "level_name_ground_zero",
				completed = ground_zero
			},
			{
				name = "level_name_skittergate",
				completed = skittergate
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
	completed = function (statistics_db, stats_id)
		-- function 36
		return statistics_db:get_persistent_stat(stats_id, "holly_kills_bw_1h_crowbill") >= 1000
	end,
	progress = function (statistics_db, stats_id)
		-- function 37
		local count = statistics_db:get_persistent_stat(stats_id, "holly_kills_bw_1h_crowbill")

		return {
			count,
			1000
		}
	end
}
AchievementTemplates.achievements.holly_sienna_weapon_skin_3 = {
	required_dlc = "holly",
	name = "achv_holly_sienna_weapon_skin_3",
	icon = "achievement_holly_sienna_weapon_skin_3_desc",
	desc = "achv_holly_sienna_weapon_skin_3_desc",
	completed = function (statistics_db, stats_id)
		-- function 38
		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_bw_1h_crowbill") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_bw_1h_crowbill") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_bw_1h_crowbill") > 0 and statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_bw_1h_crowbill") > 0 then
			return true
		end

		return false
	end,
	progress = function (statistics_db, stats_id)
		-- function 39
		local count = 0

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_bw_1h_crowbill") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_bw_1h_crowbill") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_bw_1h_crowbill") > 0 then
			count = count + 1
		end

		if statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_bw_1h_crowbill") > 0 then
			count = count + 1
		end

		return {
			count,
			4
		}
	end,
	requirements = function (statistics_db, stats_id)
		-- function 40
		local warcamp = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_warcamp_with_bw_1h_crowbill") > 0
		local skaven_stronghold = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skaven_stronghold_with_bw_1h_crowbill") > 0
		local ground_zero = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_ground_zero_with_bw_1h_crowbill") > 0
		local skittergate = statistics_db:get_persistent_stat(stats_id, "holly_completed_level_skittergate_with_bw_1h_crowbill") > 0

		return {
			{
				name = "level_name_warcamp",
				completed = warcamp
			},
			{
				name = "level_name_skaven_stronghold",
				completed = skaven_stronghold
			},
			{
				name = "level_name_ground_zero",
				completed = ground_zero
			},
			{
				name = "level_name_skittergate",
				completed = skittergate
			}
		}
	end
}
