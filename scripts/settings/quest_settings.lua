-- chunkname: @scripts/settings/quest_settings.lua

QuestSettings = {}
QuestSettings.rules = {
	daily = {
		num_criterias = 3,
		max_quests = 3
	},
	weekly = {
		num_criterias = 3,
		max_quests = 7
	},
	event = {
		num_criterias = 12,
		max_quests = 10
	}
}
QuestSettings.elven_ruins_speed_event = 30
QuestSettings.farmlands_speed_event = 60
QuestSettings.bell_speed_event = 85
QuestSettings.mines_speed_event = 15
QuestSettings.skittergate_speed_event = 20
QuestSettings.elven_ruins_speed_event_cata = 30
QuestSettings.farmlands_speed_event_cata = 60
QuestSettings.bell_speed_event_cata = 85
QuestSettings.mines_speed_event_cata = 15
QuestSettings.skittergate_speed_event_cata = 20
QuestSettings.exalted_champion_charge_chaos_warrior = 5
QuestSettings.halescourge_tornado_enemies = 15
QuestSettings.storm_vermin_warlord_kills_enemies = 40
QuestSettings.nurgle_bathed_all = 27
QuestSettings.forest_fort_kill_cannonball = 25
QuestSettings.volume_corpse_pit_damage = 120
QuestSettings.exalted_champion_charge_chaos_warrior_cata = 5
QuestSettings.halescourge_tornado_enemies_cata = 15
QuestSettings.storm_vermin_warlord_kills_enemies_cata = 40
QuestSettings.nurgle_bathed_all_cata = 27
QuestSettings.forest_fort_kill_cannonball_cata = 25
QuestSettings.volume_corpse_pit_damage_cata = 120
QuestSettings.scrap_count_level = {
	3,
	30
}
QuestSettings.scrap_count_generic = {
	150,
	260,
	370,
	540
}
QuestSettings.num_enemies_killed_by_warpfire = 10
QuestSettings.num_enemies_killed_by_poison = 10
QuestSettings.corruptor_killed_at_teleport_time = 2
QuestSettings.standard_bearer_alive_seconds = 120
QuestSettings.num_gors_killed_by_warpfire = 3
QuestSettings.bladestorm_duration = 120
QuestSettings.daily_complete_quickplay_missions = 3
QuestSettings.daily_complete_weekly_event_missions = 3
QuestSettings.daily_collect_tomes = 4
QuestSettings.daily_collect_grimoires = 3
QuestSettings.daily_collect_loot_die = 5
QuestSettings.daily_collect_painting_scrap = 9
QuestSettings.daily_kill_bosses = 3
QuestSettings.daily_kill_elites = 25
QuestSettings.daily_kill_critters = 5
QuestSettings.daily_complete_levels_hero_wood_elf = 2
QuestSettings.daily_complete_levels_hero_witch_hunter = 2
QuestSettings.daily_complete_levels_hero_dwarf_ranger = 2
QuestSettings.daily_complete_levels_hero_empire_soldier = 2
QuestSettings.daily_complete_levels_hero_bright_wizard = 2
QuestSettings.daily_score_headshots = 50
QuestSettings.event_skulls_quickplay = 8
QuestSettings.event_skulls_collect_painting_scraps = 8
QuestSettings.event_skulls_kill_critters = 8
QuestSettings.event_sonnstill_quickplay_levels = 10
QuestSettings.event_sonnstill_difficulty_levels = 10
QuestSettings.event_geheimnisnacht_quickplay_levels = 10
QuestSettings.event_geheimnisnacht_difficulty_levels = 10
QuestSettings.event_mondstille_quickplay_legend_levels = 5
QuestSettings.event_crawl_drink_all_ale_amount = 99
QuestSettings.event_celebration_collect_painting_scraps = 9
QuestSettings.quest_event_rat_kill_skaven_2020 = 1000
QuestSettings.quest_event_dwarf_fest_trollkiller = 25
QuestSettings.weekly_complete_quickplay_missions = {
	10,
	10,
	10
}
QuestSettings.weekly_complete_weekly_event_missions = {
	1,
	1,
	1
}
QuestSettings.weekly_collect_tomes = {
	15,
	15,
	15
}
QuestSettings.weekly_collect_grimoires = {
	8,
	8,
	8
}
QuestSettings.weekly_collect_dice = {
	15,
	15,
	15
}
QuestSettings.weekly_collect_painting_scrap = {
	10,
	10,
	10
}
QuestSettings.weekly_kill_bosses = {
	6,
	6,
	6
}
QuestSettings.weekly_kill_elites = {
	55,
	55,
	55
}
QuestSettings.weekly_complete_levels_hero_wood_elf = {
	6,
	6,
	6
}
QuestSettings.weekly_complete_levels_hero_witch_hunter = {
	6,
	6,
	6
}
QuestSettings.weekly_complete_levels_hero_dwarf_ranger = {
	6,
	6,
	6
}
QuestSettings.weekly_complete_levels_hero_empire_soldier = {
	6,
	6,
	6
}
QuestSettings.weekly_complete_levels_hero_bright_wizard = {
	6,
	6,
	6
}
QuestSettings.weekly_kill_critters = {
	15,
	15,
	15
}
QuestSettings.weekly_score_headshots = {
	150,
	150,
	150
}
QuestSettings.weekly_daily_quests = {
	3,
	3,
	3
}
QuestSettings.allowed_difficulties = {
	elven_ruins_speed_event = {
		hardest = true
	},
	elven_ruins_speed_event_cata = {
		cataclysm = true
	},
	farmlands_speed_event = {
		hardest = true
	},
	farmlands_speed_event_cata = {
		cataclysm = true
	},
	bell_speed_event = {
		hardest = true
	},
	bell_speed_event_cata = {
		cataclysm = true
	},
	mines_speed_event = {
		hardest = true
	},
	mines_speed_event_cata = {
		cataclysm = true
	},
	skittergate_speed_event = {
		hardest = true
	},
	skittergate_speed_event_cata = {
		cataclysm = true
	},
	exalted_champion_charge_chaos_warrior = {
		hardest = true
	},
	exalted_champion_charge_chaos_warrior_cata = {
		cataclysm = true
	},
	halescourge_tornado_enemies = {
		hardest = true
	},
	halescourge_tornado_enemies_cata = {
		cataclysm = true
	},
	storm_vermin_warlord_kills_enemies = {
		hardest = true
	},
	storm_vermin_warlord_kills_enemies_cata = {
		cataclysm = true
	},
	forest_fort_kill_cannonball = {
		hardest = true
	},
	forest_fort_kill_cannonball_cata = {
		cataclysm = true
	},
	nurgle_bathed_all = {
		hardest = true
	},
	nurgle_bathed_all_cata = {
		cataclysm = true
	},
	volume_corpse_pit_damage = {
		hardest = true
	},
	volume_corpse_pit_damage_cata = {
		cataclysm = true
	},
	ussingen_used_no_barrels = {
		hardest = true
	},
	ussingen_used_no_barrels_cata = {
		cataclysm = true
	},
	military_statue_kill_chaos_warriors = {
		hardest = true
	},
	military_statue_kill_chaos_warriors_cata = {
		cataclysm = true
	}
}

local var_0_0 = {
	catacombs_added_souls = "achv_catacombs_stay_inside_ritual_pool_name",
	elven_ruins_speed_event_cata = "achv_elven_ruins_align_leylines_timed_cata_name",
	elven_ruins_speed_event = "achv_elven_ruins_align_leylines_timed_name",
	forest_fort_kill_cannonball_cata = "achv_fort_kill_enemies_cannonball_cata_name",
	mines_speed_event_cata = "achv_mines_kill_final_troll_timed_cata_name",
	halescourge_tornado_enemies_cata = "achv_ground_zero_burblespew_tornado_enemies_cata_name",
	nurgle_bathed_all = "achv_nurgle_player_showered_in_pus_name",
	skittergate_speed_event = "achv_skittergate_deathrattler_rasknitt_timed_name",
	exalted_champion_charge_chaos_warrior_cata = "achv_warcamp_bodvarr_charge_warriors_cata_name",
	halescourge_tornado_enemies = "achv_ground_zero_burblespew_tornado_enemies_name",
	forest_fort_kill_cannonball = "achv_fort_kill_enemies_cannonball_name",
	storm_vermin_warlord_kills_enemies_cata = "achv_skaven_stronghold_skarrik_kill_skaven_cata_name",
	storm_vermin_warlord_kills_enemies = "achv_skaven_stronghold_skarrik_kill_skaven_name",
	ussingen_used_no_barrels_cata = "achv_ussingen_no_event_barrels_cata_name",
	skittergate_speed_event_cata = "achv_skittergate_deathrattler_rasknitt_timed_cata_name",
	mines_speed_event = "achv_mines_kill_final_troll_timed_name",
	military_statue_kill_chaos_warriors_cata = "achv_military_kill_chaos_warriors_in_event_cata_name",
	exalted_champion_charge_chaos_warrior = "achv_warcamp_bodvarr_charge_warriors_name",
	bell_speed_event = "achv_bell_destroy_bell_flee_timed_name",
	military_statue_kill_chaos_warriors = "achv_military_kill_chaos_warriors_in_event_name",
	farmlands_speed_event = "achv_farmlands_rescue_prisoners_timed_name",
	ussingen_used_no_barrels = "achv_ussingen_no_event_barrels_name",
	farmlands_speed_event_cata = "achv_farmlands_rescue_prisoners_timed_cata_name",
	nurgle_bathed_all_cata = "achv_nurgle_player_showered_in_pus_cata_name",
	catacombs_added_souls_cata = "achv_catacombs_stay_inside_ritual_pool_cata_name",
	bell_speed_event_cata = "achv_bell_destroy_bell_flee_timed_cata_name"
}
local var_0_1 = {}

for iter_0_0, iter_0_1 in pairs(QuestSettings.rules) do
	local var_0_2 = string.format("%s_quest", iter_0_0)

	for iter_0_2 = 1, iter_0_1.max_quests do
		local var_0_3 = string.format("%s_%d", var_0_2, iter_0_2)
		local var_0_4 = {}

		for iter_0_3 = 1, iter_0_1.num_criterias do
			var_0_4[#var_0_4 + 1] = string.format("%s_stat_%d", var_0_3, iter_0_3)
		end

		var_0_1[var_0_3] = var_0_4
	end
end

QuestSettings.stat_mappings = var_0_1

function QuestSettings.send_completed_message(arg_1_0)
	local var_1_0 = false
	local var_1_1 = Managers.player:human_players()
	local var_1_2 = Managers.player:statistics_db()

	for iter_1_0, iter_1_1 in pairs(var_1_1) do
		local var_1_3 = var_1_2:get_persistent_stat(iter_1_1:stats_id(), arg_1_0)

		if not var_1_3 or var_1_3 == 0 then
			var_1_0 = true

			break
		end
	end

	if var_1_0 then
		local var_1_4 = var_0_0[arg_1_0]

		if var_1_4 then
			local var_1_5 = var_1_4
			local var_1_6 = false

			Managers.chat:send_system_chat_message(1, var_1_5, 1, var_1_6, true)
		end
	end
end

local function var_0_5(arg_2_0, arg_2_1)
	local var_2_0 = Managers.player:unit_owner(arg_2_0)

	if var_2_0 and not var_2_0.bot_player then
		local var_2_1 = var_2_0:network_id()
		local var_2_2 = Managers.state.network
		local var_2_3 = NetworkLookup.statistics[arg_2_1]

		var_2_2.network_transmit:send_rpc("rpc_increment_stat", var_2_1, var_2_3)
	end
end

local function var_0_6(arg_3_0)
	Managers.player:statistics_db():increment_stat_and_sync_to_clients(arg_3_0)
end

function QuestSettings.check_globadier_kill_before_throwing(arg_4_0, arg_4_1)
	if not arg_4_0.has_thrown_first_globe then
		local var_4_0 = "globadier_kill_before_throwing"

		var_0_5(arg_4_1, var_4_0)

		arg_4_0.has_thrown_first_globe = nil
	end
end

function QuestSettings.check_globadier_kill_during_suicide(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_1 ~= arg_5_2 and arg_5_0.action and arg_5_0.action.name and arg_5_0.action.name == "suicide_run" then
		local var_5_0 = "globadier_kill_during_suicide"

		var_0_5(arg_5_2, var_5_0)
	end
end

function QuestSettings.check_num_enemies_killed_by_poison(arg_6_0, arg_6_1)
	local var_6_0 = AiUtils.get_actual_attacker_unit(arg_6_1)
	local var_6_1 = BLACKBOARDS[var_6_0]

	if var_6_1 then
		var_6_1.num_killed_by_poison = (var_6_1.num_killed_by_poison or 0) + 1

		if var_6_1.num_killed_by_poison >= QuestSettings.num_enemies_killed_by_poison then
			local var_6_2 = "globadier_enemies_killed_by_poison"

			var_0_6(var_6_2)

			var_6_1.num_killed_by_poison = 0
		end
	end
end

function QuestSettings.check_warpfire_kill_before_shooting(arg_7_0, arg_7_1)
	if not arg_7_0.has_fired then
		local var_7_0 = "warpfire_kill_before_shooting"

		var_0_5(arg_7_1, var_7_0)
	end
end

function QuestSettings.check_warpfire_kill_on_power_cell(arg_8_0, arg_8_1)
	if arg_8_0 == "aux" then
		local var_8_0 = "warpfire_kill_on_power_cell"

		var_0_5(arg_8_1, var_8_0)
	end
end

function QuestSettings.check_num_enemies_killed_by_warpfire(arg_9_0, arg_9_1)
	local var_9_0 = BLACKBOARDS[arg_9_1]

	var_9_0.hit_units_warpfire_challenge = var_9_0.hit_units_warpfire_challenge or {}

	if not var_9_0.hit_units_warpfire_challenge[arg_9_0] then
		var_9_0.num_ai_killed_by_warpfire = (var_9_0.num_ai_killed_by_warpfire or 0) + 1
		var_9_0.hit_units_warpfire_challenge[arg_9_0] = true

		if var_9_0.num_ai_killed_by_warpfire >= QuestSettings.num_enemies_killed_by_warpfire then
			var_9_0.num_ai_killed_by_warpfire = nil
			var_9_0.hit_units_warpfire_challenge = nil

			local var_9_1 = "warpfire_enemies_killed_by_warpfire"

			var_0_6(var_9_1)
		end
	end
end

function QuestSettings.check_pack_master_dodge(arg_10_0)
	local var_10_0 = "pack_master_dodged_attack"

	var_0_5(arg_10_0, var_10_0)
end

function QuestSettings.check_pack_master_kill_abducting_ally(arg_11_0, arg_11_1)
	if arg_11_0.action and (arg_11_0.action.name == "drag" or arg_11_0.action.name == "initial_pull") then
		local var_11_0 = "pack_master_kill_abducting_ally"

		var_0_5(arg_11_1, var_11_0)
	end
end

function QuestSettings.check_pack_master_rescue_hoisted_ally(arg_12_0)
	local var_12_0 = "pack_master_rescue_hoisted_ally"

	var_0_5(arg_12_0, var_12_0)
end

function QuestSettings.check_gutter_killed_while_pouncing(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = rawget(ItemMasterList, arg_13_2)

	if var_13_0 and arg_13_0.action then
		local var_13_1 = var_13_0.slot_type

		if var_13_1 and var_13_1 == "ranged" and arg_13_0.action.name == "jump" then
			local var_13_2 = "gutter_runner_killed_on_pounce"

			var_0_5(arg_13_1, var_13_2)
		end
	end
end

function QuestSettings.check_gutter_runner_push_on_pounce(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.unit

	if ScriptUnit.extension(var_14_0, "ai_system"):current_action_name() == "jump" and Unit.alive(arg_14_1) then
		local var_14_1 = "gutter_runner_push_on_pounce"

		var_0_5(arg_14_1, var_14_1)
	end
end

function QuestSettings.check_gutter_runner_push_on_target_pounced(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.unit

	if ScriptUnit.extension(var_15_0, "ai_system"):current_action_name() == "target_pounced" and Unit.alive(arg_15_1) then
		local var_15_1 = "gutter_runner_push_on_target_pounced"

		var_0_5(arg_15_1, var_15_1)
	end
end

function QuestSettings.check_corruptor_killed_at_teleport_time(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if arg_16_2 - arg_16_1 <= QuestSettings.corruptor_killed_at_teleport_time then
		local var_16_0 = "corruptor_killed_at_teleport_time"

		var_0_5(arg_16_3, var_16_0)

		arg_16_0.teleport_at_t = nil
	end
end

function QuestSettings.check_corruptor_dodge(arg_17_0)
	local var_17_0 = "corruptor_dodged_attack"

	var_0_5(arg_17_0, var_17_0)
end

function QuestSettings.check_corruptor_killed_while_grabbing(arg_18_0, arg_18_1)
	if arg_18_0.grabbed_unit and not arg_18_0.has_dealed_damage and Unit.alive(arg_18_1) then
		local var_18_0 = "corruptor_killed_while_grabbing"

		var_0_5(arg_18_1, var_18_0)
	end
end

function QuestSettings.check_vortex_sorcerer_killed_while_summoning(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0.unit

	if ScriptUnit.extension(var_19_0, "ai_system"):current_action_name() == "spawn_vortex" and Unit.alive(arg_19_1) then
		local var_19_1 = "vortex_sorcerer_killed_while_summoning"

		var_0_5(arg_19_1, var_19_1)
	end
end

function QuestSettings.check_vortex_sorcerer_killed_while_ally_in_vortex(arg_20_0, arg_20_1)
	local var_20_0 = Managers.player:players()

	for iter_20_0, iter_20_1 in pairs(var_20_0) do
		local var_20_1 = iter_20_1.player_unit
		local var_20_2 = var_20_1 and ScriptUnit.extension(var_20_1, "status_system")

		if var_20_1 ~= arg_20_1 and var_20_2 and var_20_2:is_in_vortex() then
			local var_20_3 = "vortex_sorcerer_killed_while_ally_in_vortex"

			var_0_5(arg_20_1, var_20_3)

			break
		end
	end
end

function QuestSettings.check_vortex_sorcerer_killed_by_melee(arg_21_0, arg_21_1)
	local var_21_0 = rawget(ItemMasterList, arg_21_1)

	if var_21_0 and var_21_0.slot_type == "melee" then
		local var_21_1 = "vortex_sorcerer_killed_by_melee"

		var_0_5(arg_21_0, var_21_1)
	end
end

function QuestSettings.check_ratling_gunner_killed_by_melee(arg_22_0, arg_22_1)
	local var_22_0 = rawget(ItemMasterList, arg_22_1)

	if var_22_0 and var_22_0.slot_type == "melee" then
		local var_22_1 = "ratling_gunner_killed_by_melee"

		var_0_5(arg_22_0, var_22_1)
	end
end

function QuestSettings.check_ratling_gunner_killed_while_shooting(arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0.unit
	local var_23_1 = ScriptUnit.extension(var_23_0, "ai_system"):current_action_name()

	if (arg_23_0.attack_pattern_data and arg_23_0.attack_pattern_data.target_unit) ~= arg_23_1 and var_23_1 == "shoot_ratling_gun" then
		local var_23_2 = "ratling_gunner_killed_while_shooting"

		var_0_5(arg_23_1, var_23_2)
	end
end

function QuestSettings.check_chaos_spawn_killed_while_grabbing(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0.unit
	local var_24_1 = ScriptUnit.extension(var_24_0, "ai_system"):current_action_name()

	if var_24_1 == "attack_grabbed_chew" or var_24_1 == "attack_grabbed_smash" or var_24_1 == "attack_grabbed_throw" then
		local var_24_2 = "chaos_spawn_killed_while_grabbing"

		var_0_5(arg_24_1, var_24_2)
	end
end

function QuestSettings.check_chaos_spawn_killed_without_having_grabbed(arg_25_0, arg_25_1)
	if not arg_25_0.has_grabbed then
		local var_25_0 = "chaos_spawn_killed_without_having_grabbed"

		var_0_6(var_25_0)

		arg_25_0.has_grabbed = nil
	end
end

function QuestSettings.check_chaos_troll_killed_without_regen(arg_26_0, arg_26_1)
	if arg_26_0.num_regen == 1 then
		local var_26_0 = "chaos_troll_killed_without_regen"

		var_0_6(var_26_0)
	end
end

function QuestSettings.check_chaos_troll_killed_without_bile_damage(arg_27_0, arg_27_1)
	if not arg_27_0.has_done_bile_damage then
		local var_27_0 = "chaos_troll_killed_without_bile_damage"

		var_0_6(var_27_0)
	end
end

function QuestSettings.check_rat_ogre_killed_mid_leap(arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0.unit

	if ScriptUnit.extension(var_28_0, "ai_system"):current_action_name() == "jump_slam" then
		local var_28_1 = "rat_ogre_killed_mid_leap"

		var_0_5(arg_28_1, var_28_1)
	end
end

function QuestSettings.check_rat_ogre_killed_without_dealing_damage(arg_29_0, arg_29_1)
	if not arg_29_0.has_dealt_damage then
		local var_29_0 = "rat_ogre_killed_without_dealing_damage"

		var_0_6(var_29_0)
	end
end

function QuestSettings.check_stormfiend_killed_without_burn_damage(arg_30_0, arg_30_1)
	if not arg_30_0.has_dealt_burn_damage then
		local var_30_0 = "stormfiend_killed_without_burn_damage"

		var_0_6(var_30_0)
	end
end

function QuestSettings.check_stormfiend_killed_on_controller(arg_31_0, arg_31_1)
	if arg_31_0 == "weakspot" then
		local var_31_0 = "stormfiend_killed_on_controller"

		var_0_5(arg_31_1, var_31_0)
	end
end

function QuestSettings.check_killed_lord_as_last_player_standing(arg_32_0)
	local var_32_0 = Managers.player:unit_owner(arg_32_0)

	if Managers.player:num_alive_allies(var_32_0) == 0 then
		local var_32_1 = "killed_lord_as_last_player_standing"

		var_0_5(arg_32_0, var_32_1)
	end
end

QuestSettings.track_bastard_block_breeds = {}

function QuestSettings.handle_bastard_block(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = Unit.get_data(arg_33_0, "breed")

	if not var_33_0 or not QuestSettings.track_bastard_block_breeds[var_33_0.name] then
		return false
	end

	local var_33_1 = BLACKBOARDS[arg_33_1]

	if not var_33_1 then
		return false
	end

	if var_33_1.failed_boss then
		return false
	end

	if not arg_33_2 then
		var_33_1.bastard_block = 0
		var_33_1.failed_boss = true

		return false
	end

	if ScriptUnit.has_extension(arg_33_0, "status_system").charge_blocking then
		var_33_1.bastard_block = (var_33_1.bastard_block or 0) + 1
	end
end

function QuestSettings.handle_bastard_block_on_death(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	if arg_34_0.boss then
		local var_34_0 = arg_34_2[3]
		local var_34_1 = BLACKBOARDS[arg_34_1]

		if not var_34_1 or not var_34_1.bastard_block then
			return false
		end

		if not var_34_0 then
			return false
		end

		local var_34_2 = Unit.get_data(var_34_0, "breed")

		if not var_34_2 or not QuestSettings.track_bastard_block_breeds[var_34_2.name] then
			return false
		end

		if var_34_1.bastard_block >= 3 then
			local var_34_3 = "lake_bastard_block"

			var_0_5(var_34_0, var_34_3)
		end

		var_34_1.failed_boss = nil
		var_34_1.bastard_block = nil
	end
end

QuestSettings.track_charge_stagger_breeds = {}

function QuestSettings.handle_charge_stagger(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = ScriptUnit.has_extension(arg_35_2, "career_system")

	if not var_35_0 then
		return
	end

	local var_35_1 = var_35_0:career_name()

	if not QuestSettings.track_charge_stagger_breeds[var_35_1] then
		return
	end

	if ScriptUnit.has_extension(arg_35_0, "health_system"):recent_damage_source() == var_35_0:career_skill_weapon_name(nil) then
		local var_35_2 = arg_35_1.action

		if var_35_2 and var_35_2.name == "charge" then
			local var_35_3 = Managers.time:time("game")
			local var_35_4 = arg_35_1.attack_started_at_t

			if var_35_4 and var_35_3 - var_35_4 > 2 then
				local var_35_5 = "lake_charge_stagger"

				var_0_5(arg_35_2, var_35_5)
			end
		end
	end
end
