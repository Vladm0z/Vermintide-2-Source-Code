-- chunkname: @scripts/managers/achievements/achievements_outline.lua

local var_0_0 = {
	name = "achv_menu_heroes_category_title",
	present_progression = true,
	entries = {
		"unlock_first_talent_point",
		"unlock_all_talent_points",
		"complete_level_all",
		"level_thirty_all",
		"complete_all_helmgart_levels_all_careers_recruit",
		"complete_all_helmgart_levels_all_careers_veteran",
		"complete_all_helmgart_levels_all_careers_champion",
		"complete_all_helmgart_levels_all_careers_legend"
	},
	categories = {
		{
			sorting = 1,
			name = "inventory_name_empire_soldier",
			entries = {
				"achievement_markus_level_1",
				"achievement_markus_level_2",
				"achievement_markus_level_3",
				"level_thirty_empire_soldier",
				"scorpion_markus_reach_level_35",
				"complete_all_helmgart_levels_recruit_es_mercenary",
				"complete_all_helmgart_levels_veteran_es_mercenary",
				"complete_all_helmgart_levels_champion_es_mercenary",
				"complete_all_helmgart_levels_legend_es_mercenary",
				"complete_100_missions_champion_es_mercenary",
				"complete_all_helmgart_levels_recruit_es_huntsman",
				"complete_all_helmgart_levels_veteran_es_huntsman",
				"complete_all_helmgart_levels_champion_es_huntsman",
				"complete_all_helmgart_levels_legend_es_huntsman",
				"complete_100_missions_champion_es_huntsman",
				"complete_all_helmgart_levels_recruit_es_knight",
				"complete_all_helmgart_levels_veteran_es_knight",
				"complete_all_helmgart_levels_champion_es_knight",
				"complete_all_helmgart_levels_legend_es_knight",
				"complete_100_missions_champion_es_knight"
			}
		},
		{
			sorting = 2,
			name = "inventory_name_dwarf_ranger",
			entries = {
				"achievement_bardin_level_1",
				"achievement_bardin_level_2",
				"achievement_bardin_level_3",
				"level_thirty_dwarf_ranger",
				"scorpion_bardin_reach_level_35",
				"complete_all_helmgart_levels_recruit_dr_ranger",
				"complete_all_helmgart_levels_veteran_dr_ranger",
				"complete_all_helmgart_levels_champion_dr_ranger",
				"complete_all_helmgart_levels_legend_dr_ranger",
				"complete_100_missions_champion_dr_ranger",
				"complete_all_helmgart_levels_recruit_dr_ironbreaker",
				"complete_all_helmgart_levels_veteran_dr_ironbreaker",
				"complete_all_helmgart_levels_champion_dr_ironbreaker",
				"complete_all_helmgart_levels_legend_dr_ironbreaker",
				"complete_100_missions_champion_dr_ironbreaker",
				"complete_all_helmgart_levels_recruit_dr_slayer",
				"complete_all_helmgart_levels_veteran_dr_slayer",
				"complete_all_helmgart_levels_champion_dr_slayer",
				"complete_all_helmgart_levels_legend_dr_slayer",
				"complete_100_missions_champion_dr_slayer"
			}
		},
		{
			sorting = 3,
			name = "inventory_name_wood_elf",
			entries = {
				"achievement_kerillian_level_1",
				"achievement_kerillian_level_2",
				"achievement_kerillian_level_3",
				"level_thirty_wood_elf",
				"scorpion_kerillian_reach_level_35",
				"complete_all_helmgart_levels_recruit_we_waywatcher",
				"complete_all_helmgart_levels_veteran_we_waywatcher",
				"complete_all_helmgart_levels_champion_we_waywatcher",
				"complete_all_helmgart_levels_legend_we_waywatcher",
				"complete_100_missions_champion_we_waywatcher",
				"complete_all_helmgart_levels_recruit_we_maidenguard",
				"complete_all_helmgart_levels_veteran_we_maidenguard",
				"complete_all_helmgart_levels_champion_we_maidenguard",
				"complete_all_helmgart_levels_legend_we_maidenguard",
				"complete_100_missions_champion_we_maidenguard",
				"complete_all_helmgart_levels_recruit_we_shade",
				"complete_all_helmgart_levels_veteran_we_shade",
				"complete_all_helmgart_levels_champion_we_shade",
				"complete_all_helmgart_levels_legend_we_shade",
				"complete_100_missions_champion_we_shade"
			}
		},
		{
			sorting = 4,
			name = "inventory_name_witch_hunter",
			entries = {
				"achievement_victor_level_1",
				"achievement_victor_level_2",
				"achievement_victor_level_3",
				"level_thirty_witch_hunter",
				"scorpion_victor_reach_level_35",
				"complete_all_helmgart_levels_recruit_wh_captain",
				"complete_all_helmgart_levels_veteran_wh_captain",
				"complete_all_helmgart_levels_champion_wh_captain",
				"complete_all_helmgart_levels_legend_wh_captain",
				"complete_100_missions_champion_wh_captain",
				"complete_all_helmgart_levels_recruit_wh_bountyhunter",
				"complete_all_helmgart_levels_veteran_wh_bountyhunter",
				"complete_all_helmgart_levels_champion_wh_bountyhunter",
				"complete_all_helmgart_levels_legend_wh_bountyhunter",
				"complete_100_missions_champion_wh_bountyhunter",
				"complete_all_helmgart_levels_recruit_wh_zealot",
				"complete_all_helmgart_levels_veteran_wh_zealot",
				"complete_all_helmgart_levels_champion_wh_zealot",
				"complete_all_helmgart_levels_legend_wh_zealot",
				"complete_100_missions_champion_wh_zealot"
			}
		},
		{
			sorting = 5,
			name = "inventory_name_bright_wizard",
			entries = {
				"achievement_sienna_level_1",
				"achievement_sienna_level_2",
				"achievement_sienna_level_3",
				"level_thirty_bright_wizard",
				"scorpion_sienna_reach_level_35",
				"complete_all_helmgart_levels_recruit_bw_adept",
				"complete_all_helmgart_levels_veteran_bw_adept",
				"complete_all_helmgart_levels_champion_bw_adept",
				"complete_all_helmgart_levels_legend_bw_adept",
				"complete_100_missions_champion_bw_adept",
				"complete_all_helmgart_levels_recruit_bw_scholar",
				"complete_all_helmgart_levels_veteran_bw_scholar",
				"complete_all_helmgart_levels_champion_bw_scholar",
				"complete_all_helmgart_levels_legend_bw_scholar",
				"complete_100_missions_champion_bw_scholar",
				"complete_all_helmgart_levels_recruit_bw_unchained",
				"complete_all_helmgart_levels_veteran_bw_unchained",
				"complete_all_helmgart_levels_champion_bw_unchained",
				"complete_all_helmgart_levels_legend_bw_unchained",
				"complete_100_missions_champion_bw_unchained"
			}
		}
	}
}
local var_0_1 = {
	name = "achv_menu_levels_category_title",
	present_progression = true,
	entries = {
		"complete_all_helmgart_levels_recruit",
		"complete_all_helmgart_levels_veteran",
		"complete_all_helmgart_levels_champion",
		"complete_all_helmgart_levels_legend",
		"scorpion_complete_all_helmgart_levels_cataclysm",
		"complete_bogenhafen_recruit",
		"complete_bogenhafen_veteran",
		"complete_bogenhafen_champion",
		"complete_bogenhafen_legend",
		"scorpion_complete_bogenhafen_cataclysm"
	},
	categories = {
		{
			sorting = 1,
			name = "achv_menu_levels_helmgart_category_title",
			entries = {
				"complete_tutorial",
				"complete_act_one",
				"scorpion_complete_helmgart_act_one_cataclysm",
				"complete_act_two",
				"scorpion_complete_helmgart_act_two_cataclysm",
				"complete_act_three",
				"scorpion_complete_helmgart_act_three_cataclysm",
				"complete_skittergate_recruit",
				"complete_skittergate_veteran",
				"complete_skittergate_champion",
				"complete_skittergate_legend",
				"scorpion_complete_skittergate_cataclysm",
				"kill_bodvarr_burblespew_recruit",
				"kill_bodvarr_burblespew_veteran",
				"kill_bodvarr_burblespew_champion",
				"kill_bodvarr_burblespew_legend",
				"kill_skarrik_rasknitt_recruit",
				"kill_skarrik_rasknitt_veteran",
				"kill_skarrik_rasknitt_champion",
				"kill_skarrik_rasknitt_legend",
				"elven_ruins_align_leylines_timed",
				"farmlands_rescue_prisoners_timed",
				"military_kill_chaos_warriors_in_event",
				"ground_zero_burblespew_tornado_enemies",
				"fort_kill_enemies_cannonball",
				"nurgle_player_showered_in_pus",
				"bell_destroy_bell_flee_timed",
				"catacombs_stay_inside_ritual_pool",
				"mines_kill_final_troll_timed",
				"warcamp_bodvarr_charge_warriors",
				"skaven_stronghold_skarrik_kill_skaven",
				"ussingen_no_event_barrels",
				"skittergate_deathrattler_rasknitt_timed",
				"complete_all_helmgart_level_achievements",
				"elven_ruins_align_leylines_timed_cata",
				"farmlands_rescue_prisoners_timed_cata",
				"military_kill_chaos_warriors_in_event_cata",
				"ground_zero_burblespew_tornado_enemies_cata",
				"fort_kill_enemies_cannonball_cata",
				"nurgle_player_showered_in_pus_cata",
				"bell_destroy_bell_flee_timed_cata",
				"catacombs_stay_inside_ritual_pool_cata",
				"mines_kill_final_troll_timed_cata",
				"warcamp_bodvarr_charge_warriors_cata",
				"skaven_stronghold_skarrik_kill_skaven_cata",
				"ussingen_no_event_barrels_cata",
				"skittergate_deathrattler_rasknitt_timed_cata"
			}
		},
		{
			sorting = 2,
			name = "achv_menu_levels_bogenhafen_category_title",
			entries = {
				"complete_bogenhafen_slum_recruit",
				"complete_bogenhafen_slum_veteran",
				"complete_bogenhafen_slum_champion",
				"complete_bogenhafen_slum_legend",
				"complete_bogenhafen_city_recruit",
				"complete_bogenhafen_city_veteran",
				"complete_bogenhafen_city_champion",
				"complete_bogenhafen_city_legend",
				"bogenhafen_city_all_wine_collected",
				"bogenhafen_city_jumping_puzzle",
				"bogenhafen_slum_find_hidden_stash",
				"bogenhafen_slum_jumping_puzzle",
				"bogenhafen_city_no_braziers_lit",
				"bogenhafen_city_torch_not_picked_up",
				"bogenhafen_city_fast_switches",
				"bogenhafen_slum_no_ratling_damage",
				"bogenhafen_slum_no_windows_broken",
				"bogenhafen_slum_event_speedrun",
				"bogenhafen_collect_all_cosmetics"
			}
		}
	}
}
local var_0_2 = {
	name = "achv_menu_crafting_category_title",
	present_progression = true,
	entries = {
		"craft_item",
		"craft_fifty_items",
		"salvage_item",
		"salvage_hundred_items"
	}
}
local var_0_3 = {
	name = "achv_menu_items_category_title",
	present_progression = true,
	entries = {
		"equip_common_quality",
		"equip_rare_quality",
		"equip_exotic_quality",
		"equip_all_exotic_quality",
		"equip_veteran_quality",
		"equip_all_veteran_quality"
	}
}
local var_0_4 = {
	name = "achv_menu_deeds_category_title",
	present_progression = true,
	entries = {
		"complete_deeds_1",
		"complete_deeds_2",
		"complete_deeds_3",
		"complete_deeds_4",
		"complete_deeds_5",
		"complete_deeds_6",
		"complete_deeds_7",
		"complete_deeds_8"
	}
}
local var_0_5 = {
	name = "achv_menu_enemies_category_title",
	present_progression = true,
	entries = {
		"skaven_warpfire_thrower_1",
		"skaven_warpfire_thrower_2",
		"skaven_warpfire_thrower_3",
		"skaven_pack_master_1",
		"skaven_pack_master_2",
		"skaven_pack_master_3",
		"skaven_gutter_runner_1",
		"skaven_gutter_runner_2",
		"skaven_gutter_runner_3",
		"skaven_poison_wind_globardier_1",
		"skaven_poison_wind_globardier_2",
		"skaven_poison_wind_globardier_3",
		"skaven_ratling_gunner_1",
		"skaven_ratling_gunner_2",
		"skaven_ratling_gunner_3",
		"chaos_corruptor_sorcerer_1",
		"chaos_corruptor_sorcerer_2",
		"chaos_corruptor_sorcerer_3",
		"chaos_vortex_sorcerer_1",
		"chaos_vortex_sorcerer_2",
		"chaos_vortex_sorcerer_3",
		"chaos_spawn_1",
		"chaos_spawn_2",
		"chaos_troll_1",
		"chaos_troll_2",
		"skaven_rat_ogre_1",
		"skaven_rat_ogre_2",
		"skaven_stormfiend_1",
		"skaven_stormfiend_2",
		"helmgart_lord_1"
	}
}
local var_0_6 = {
	name = "achv_menu_weaves_category_title",
	present_progression = false,
	entries = {},
	categories = {}
}
local var_0_7 = {
	name = "achv_menu_achievements_category_title",
	categories = {
		var_0_1,
		var_0_0,
		var_0_5,
		var_0_3,
		var_0_2,
		var_0_4,
		var_0_6
	}
}

DLCUtils.append("achievement_categories", var_0_7.categories)

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	local var_0_8 = iter_0_1.achievement_outline

	if var_0_8 then
		for iter_0_2, iter_0_3 in pairs(var_0_8) do
			local var_0_9

			if iter_0_2 == "levels" then
				var_0_9 = var_0_1
			elseif iter_0_2 == "heroes" then
				var_0_9 = var_0_0
			elseif iter_0_2 == "enemies" then
				var_0_9 = var_0_5
			elseif iter_0_2 == "items" then
				var_0_9 = var_0_3
			elseif iter_0_2 == "crafting" then
				var_0_9 = var_0_2
			elseif iter_0_2 == "deeds" then
				var_0_9 = var_0_4
			elseif iter_0_2 == "weaves" then
				var_0_9 = var_0_6
			else
				var_0_9 = {}
			end

			if iter_0_3.entries then
				if var_0_9.entries then
					table.append(var_0_9.entries, iter_0_3.entries)
				else
					var_0_9.entries = table.clone(iter_0_3.entries)
				end
			end

			local var_0_10 = iter_0_3.categories

			if var_0_10 then
				for iter_0_4 = 1, #var_0_10 do
					local var_0_11 = var_0_10[iter_0_4]
					local var_0_12 = var_0_11.name
					local var_0_13 = var_0_9.categories
					local var_0_14 = false

					for iter_0_5 = 1, #var_0_13 do
						local var_0_15 = var_0_13[iter_0_5]

						if var_0_12 == var_0_15.name and not var_0_14 then
							table.append(var_0_15.entries, var_0_11.entries)

							var_0_14 = true
						end
					end

					if not var_0_14 then
						var_0_13[#var_0_13 + 1] = table.clone(var_0_11)
					end
				end
			end
		end
	end
end

for iter_0_6, iter_0_7 in ipairs(var_0_7.categories) do
	local var_0_16 = iter_0_7.categories

	if var_0_16 then
		table.sort(var_0_16, function(arg_1_0, arg_1_1)
			return arg_1_0.sorting < arg_1_1.sorting
		end)
	end
end

local function var_0_17(arg_2_0, arg_2_1)
	arg_2_0.type = arg_2_1

	if arg_2_0.categories then
		for iter_2_0, iter_2_1 in ipairs(arg_2_0.categories) do
			var_0_17(iter_2_1, arg_2_1)
		end
	end
end

var_0_17(var_0_7, "achievements")

return var_0_7
