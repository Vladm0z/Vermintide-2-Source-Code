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

local tbl = {
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
local tbl_2 = {}

for k, v in pairs(QuestSettings.rules) do
	local format = string.format("%s_quest", k)

	for k_2 = 1, v.max_quests do
		local format_2 = string.format("%s_%d", format, k_2)
		local tbl_3 = {}

		for l = 1, v.num_criterias do
			tbl_3[#tbl_3 + 1] = string.format("%s_stat_%d", format_2, l)
		end

		tbl_2[format_2] = tbl_3
	end
end

QuestSettings.stat_mappings = tbl_2

QuestSettings.send_completed_message = function (arg_1_0)
	-- function 1
	local flag = false
	local human_players = Managers.player:human_players()
	local statistics_db = Managers.player:statistics_db()

	for k, v in pairs(human_players) do
		local get_persistent_stat = statistics_db:get_persistent_stat(v:stats_id(), arg_1_0)

		if not (not get_persistent_stat and get_persistent_stat ~= 0) then
			flag = true

			break
		end
	end

	if not flag then
		local var_1_4 = tbl[arg_1_0]

		if not var_1_4 then
			local var_1_5 = var_1_4
			local flag_2 = false

			Managers.chat:send_system_chat_message(1, var_1_5, 1, flag_2, true)
		end
	end
end

local function fn(arg_2_0, arg_2_1)
	-- function 2
	local unit_owner = Managers.player:unit_owner(arg_2_0)

	if not (not unit_owner and unit_owner.bot_player) then
		local network_id = unit_owner:network_id()
		local network = Managers.state.network
		local var_2_3 = NetworkLookup.statistics[arg_2_1]

		network.network_transmit:send_rpc("rpc_increment_stat", network_id, var_2_3)
	end
end

local function fn_2(arg_3_0)
	-- function 3
	Managers.player:statistics_db():increment_stat_and_sync_to_clients(arg_3_0)
end

QuestSettings.check_globadier_kill_before_throwing = function (self, arg_4_1)
	-- function 4
	if not self.has_thrown_first_globe then
		local str = "globadier_kill_before_throwing"

		fn(arg_4_1, str)

		self.has_thrown_first_globe = nil
	end
end

QuestSettings.check_globadier_kill_during_suicide = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not ((arg_5_1 == arg_5_2 or not self.action or not self.action.name) and self.action.name ~= "suicide_run") then
		local str = "globadier_kill_during_suicide"

		fn(arg_5_2, str)
	end
end

QuestSettings.check_num_enemies_killed_by_poison = function (arg_6_0, arg_6_1)
	-- function 6
	local get_actual_attacker_unit = AiUtils.get_actual_attacker_unit(arg_6_1)
	local var_6_1 = BLACKBOARDS[get_actual_attacker_unit]

	if not var_6_1 then
		local num_killed_by_poison = var_6_1.num_killed_by_poison

		num_killed_by_poison = num_killed_by_poison or 0
		var_6_1.num_killed_by_poison = num_killed_by_poison + 1

		if var_6_1.num_killed_by_poison >= QuestSettings.num_enemies_killed_by_poison then
			local str = "globadier_enemies_killed_by_poison"

			fn_2(str)

			var_6_1.num_killed_by_poison = 0
		end
	end
end

QuestSettings.check_warpfire_kill_before_shooting = function (self, arg_7_1)
	-- function 7
	if not self.has_fired then
		local str = "warpfire_kill_before_shooting"

		fn(arg_7_1, str)
	end
end

QuestSettings.check_warpfire_kill_on_power_cell = function (arg_8_0, arg_8_1)
	-- function 8
	if arg_8_0 == "aux" then
		local str = "warpfire_kill_on_power_cell"

		fn(arg_8_1, str)
	end
end

QuestSettings.check_num_enemies_killed_by_warpfire = function (arg_9_0, arg_9_1)
	-- function 9
	local var_9_0 = BLACKBOARDS[arg_9_1]
	local hit_units_warpfire_challenge = var_9_0.hit_units_warpfire_challenge

	hit_units_warpfire_challenge = hit_units_warpfire_challenge or {}
	var_9_0.hit_units_warpfire_challenge = hit_units_warpfire_challenge

	if not var_9_0.hit_units_warpfire_challenge[arg_9_0] then
		local num_ai_killed_by_warpfire = var_9_0.num_ai_killed_by_warpfire

		num_ai_killed_by_warpfire = num_ai_killed_by_warpfire or 0
		var_9_0.num_ai_killed_by_warpfire = num_ai_killed_by_warpfire + 1
		var_9_0.hit_units_warpfire_challenge[arg_9_0] = true

		if var_9_0.num_ai_killed_by_warpfire >= QuestSettings.num_enemies_killed_by_warpfire then
			var_9_0.num_ai_killed_by_warpfire = nil
			var_9_0.hit_units_warpfire_challenge = nil

			local str = "warpfire_enemies_killed_by_warpfire"

			fn_2(str)
		end
	end
end

QuestSettings.check_pack_master_dodge = function (arg_10_0)
	-- function 10
	local str = "pack_master_dodged_attack"

	fn(arg_10_0, str)
end

QuestSettings.check_pack_master_kill_abducting_ally = function (self, arg_11_1)
	-- function 11
	if not (not self.action and self.action.name == "drag" or self.action.name ~= "initial_pull") then
		local str = "pack_master_kill_abducting_ally"

		fn(arg_11_1, str)
	end
end

QuestSettings.check_pack_master_rescue_hoisted_ally = function (arg_12_0)
	-- function 12
	local str = "pack_master_rescue_hoisted_ally"

	fn(arg_12_0, str)
end

QuestSettings.check_gutter_killed_while_pouncing = function (self, arg_13_1, arg_13_2)
	-- function 13
	local var_13_0 = rawget(ItemMasterList, arg_13_2)

	if not var_13_0 and not self.action then
		local slot_type = var_13_0.slot_type

		if not (not slot_type and slot_type ~= "ranged" or self.action.name ~= "jump") then
			local str = "gutter_runner_killed_on_pounce"

			fn(arg_13_1, str)
		end
	end
end

QuestSettings.check_gutter_runner_push_on_pounce = function (self, arg_14_1)
	-- function 14
	local unit = self.unit

	if ScriptUnit.extension(unit, "ai_system"):current_action_name() ~= "jump" or not Unit.alive(arg_14_1) then
		local str = "gutter_runner_push_on_pounce"

		fn(arg_14_1, str)
	end
end

QuestSettings.check_gutter_runner_push_on_target_pounced = function (self, arg_15_1)
	-- function 15
	local unit = self.unit

	if ScriptUnit.extension(unit, "ai_system"):current_action_name() ~= "target_pounced" or not Unit.alive(arg_15_1) then
		local str = "gutter_runner_push_on_target_pounced"

		fn(arg_15_1, str)
	end
end

QuestSettings.check_corruptor_killed_at_teleport_time = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	if arg_16_2 - arg_16_1 <= QuestSettings.corruptor_killed_at_teleport_time then
		local str = "corruptor_killed_at_teleport_time"

		fn(arg_16_3, str)

		self.teleport_at_t = nil
	end
end

QuestSettings.check_corruptor_dodge = function (arg_17_0)
	-- function 17
	local str = "corruptor_dodged_attack"

	fn(arg_17_0, str)
end

QuestSettings.check_corruptor_killed_while_grabbing = function (self, arg_18_1)
	-- function 18
	if not self.grabbed_unit and self.has_dealed_damage or not Unit.alive(arg_18_1) then
		local str = "corruptor_killed_while_grabbing"

		fn(arg_18_1, str)
	end
end

QuestSettings.check_vortex_sorcerer_killed_while_summoning = function (self, arg_19_1)
	-- function 19
	local unit = self.unit

	if ScriptUnit.extension(unit, "ai_system"):current_action_name() ~= "spawn_vortex" or not Unit.alive(arg_19_1) then
		local str = "vortex_sorcerer_killed_while_summoning"

		fn(arg_19_1, str)
	end
end

QuestSettings.check_vortex_sorcerer_killed_while_ally_in_vortex = function (arg_20_0, arg_20_1)
	-- function 20
	local players = Managers.player:players()

	for k, v in pairs(players) do
		local player_unit = v.player_unit
		local flag = not player_unit and ScriptUnit.extension(player_unit, "status_system")

		if (player_unit == arg_20_1 or not flag) and not flag:is_in_vortex() then
			local str = "vortex_sorcerer_killed_while_ally_in_vortex"

			fn(arg_20_1, str)

			break
		end
	end
end

QuestSettings.check_vortex_sorcerer_killed_by_melee = function (arg_21_0, arg_21_1)
	-- function 21
	local var_21_0 = rawget(ItemMasterList, arg_21_1)

	if not (not var_21_0 and var_21_0.slot_type ~= "melee") then
		local str = "vortex_sorcerer_killed_by_melee"

		fn(arg_21_0, str)
	end
end

QuestSettings.check_ratling_gunner_killed_by_melee = function (arg_22_0, arg_22_1)
	-- function 22
	local var_22_0 = rawget(ItemMasterList, arg_22_1)

	if not (not var_22_0 and var_22_0.slot_type ~= "melee") then
		local str = "ratling_gunner_killed_by_melee"

		fn(arg_22_0, str)
	end
end

QuestSettings.check_ratling_gunner_killed_while_shooting = function (self, arg_23_1)
	-- function 23
	local unit = self.unit
	local current_action_name = ScriptUnit.extension(unit, "ai_system"):current_action_name()
	local attack_pattern_data = self.attack_pattern_data

	attack_pattern_data = not attack_pattern_data and self.attack_pattern_data.target_unit

	if not (attack_pattern_data == arg_23_1 or current_action_name ~= "shoot_ratling_gun") then
		local str = "ratling_gunner_killed_while_shooting"

		fn(arg_23_1, str)
	end
end

QuestSettings.check_chaos_spawn_killed_while_grabbing = function (self, arg_24_1)
	-- function 24
	local unit = self.unit
	local current_action_name = ScriptUnit.extension(unit, "ai_system"):current_action_name()

	if not (current_action_name == "attack_grabbed_chew" or current_action_name == "attack_grabbed_smash" or current_action_name ~= "attack_grabbed_throw") then
		local str = "chaos_spawn_killed_while_grabbing"

		fn(arg_24_1, str)
	end
end

QuestSettings.check_chaos_spawn_killed_without_having_grabbed = function (self, arg_25_1)
	-- function 25
	if not self.has_grabbed then
		local str = "chaos_spawn_killed_without_having_grabbed"

		fn_2(str)

		self.has_grabbed = nil
	end
end

QuestSettings.check_chaos_troll_killed_without_regen = function (self, arg_26_1)
	-- function 26
	if not (self.num_regen == 1) then
		local str = "chaos_troll_killed_without_regen"

		fn_2(str)
	end
end

QuestSettings.check_chaos_troll_killed_without_bile_damage = function (self, arg_27_1)
	-- function 27
	if not self.has_done_bile_damage then
		local str = "chaos_troll_killed_without_bile_damage"

		fn_2(str)
	end
end

QuestSettings.check_rat_ogre_killed_mid_leap = function (self, arg_28_1)
	-- function 28
	local unit = self.unit

	if ScriptUnit.extension(unit, "ai_system"):current_action_name() == "jump_slam" then
		local str = "rat_ogre_killed_mid_leap"

		fn(arg_28_1, str)
	end
end

QuestSettings.check_rat_ogre_killed_without_dealing_damage = function (self, arg_29_1)
	-- function 29
	if not self.has_dealt_damage then
		local str = "rat_ogre_killed_without_dealing_damage"

		fn_2(str)
	end
end

QuestSettings.check_stormfiend_killed_without_burn_damage = function (self, arg_30_1)
	-- function 30
	if not self.has_dealt_burn_damage then
		local str = "stormfiend_killed_without_burn_damage"

		fn_2(str)
	end
end

QuestSettings.check_stormfiend_killed_on_controller = function (arg_31_0, arg_31_1)
	-- function 31
	if arg_31_0 == "weakspot" then
		local str = "stormfiend_killed_on_controller"

		fn(arg_31_1, str)
	end
end

QuestSettings.check_killed_lord_as_last_player_standing = function (arg_32_0)
	-- function 32
	local unit_owner = Managers.player:unit_owner(arg_32_0)

	if not (Managers.player:num_alive_allies(unit_owner) == 0) then
		local str = "killed_lord_as_last_player_standing"

		fn(arg_32_0, str)
	end
end

QuestSettings.track_bastard_block_breeds = {}

QuestSettings.handle_bastard_block = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	local get_data = Unit.get_data(arg_33_0, "breed")

	if not (not get_data and QuestSettings.track_bastard_block_breeds[get_data.name]) then
		return false
	end

	local var_33_1 = BLACKBOARDS[arg_33_1]

	if not var_33_1 then
		return false
	end

	if not var_33_1.failed_boss then
		return false
	end

	if not arg_33_2 then
		var_33_1.bastard_block = 0
		var_33_1.failed_boss = true

		return false
	end

	if not ScriptUnit.has_extension(arg_33_0, "status_system").charge_blocking then
		local bastard_block = var_33_1.bastard_block

		bastard_block = bastard_block or 0
		var_33_1.bastard_block = bastard_block + 1
	end
end

QuestSettings.handle_bastard_block_on_death = function (self, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	if not self.boss then
		local var_34_0 = arg_34_2[3]
		local var_34_1 = BLACKBOARDS[arg_34_1]

		if not (not var_34_1 and var_34_1.bastard_block) then
			return false
		end

		if not var_34_0 then
			return false
		end

		local get_data = Unit.get_data(var_34_0, "breed")

		if not (not get_data and QuestSettings.track_bastard_block_breeds[get_data.name]) then
			return false
		end

		if var_34_1.bastard_block >= 3 then
			local str = "lake_bastard_block"

			fn(var_34_0, str)
		end

		var_34_1.failed_boss = nil
		var_34_1.bastard_block = nil
	end
end

QuestSettings.track_charge_stagger_breeds = {}

QuestSettings.handle_charge_stagger = function (arg_35_0, arg_35_1, arg_35_2)
	-- function 35
	local has_extension = ScriptUnit.has_extension(arg_35_2, "career_system")

	if not has_extension then
		return
	end

	local career_name = has_extension:career_name()

	if not QuestSettings.track_charge_stagger_breeds[career_name] then
		return
	end

	if ScriptUnit.has_extension(arg_35_0, "health_system"):recent_damage_source() == has_extension:career_skill_weapon_name(nil) then
		local action = arg_35_1.action

		if not (not action and action.name ~= "charge") then
			local time = Managers.time:time("game")
			local attack_started_at_t = arg_35_1.attack_started_at_t

			if not (not attack_started_at_t and not (time - attack_started_at_t > 2)) then
				local str = "lake_charge_stagger"

				fn(arg_35_2, str)
			end
		end
	end
end
