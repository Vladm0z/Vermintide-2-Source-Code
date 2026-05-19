-- chunkname: @scripts/managers/achievements/achievement_templates_woods.lua

local var_0_0 = AchievementTemplates.achievements
local var_0_1 = DLCSettings.woods
local var_0_2 = AchievementTemplateHelper.add_levels_complete_per_hero_challenge
local var_0_3 = AchievementTemplateHelper.add_weapon_kill_challenge
local var_0_4 = AchievementTemplateHelper.add_career_mission_count_challenge
local var_0_5 = AchievementTemplateHelper.add_meta_challenge
local var_0_6 = AchievementTemplateHelper.add_multi_stat_count_challenge
local var_0_7 = AchievementTemplateHelper.add_event_challenge
local var_0_8 = AchievementTemplateHelper.add_stat_count_challenge

local function var_0_9(arg_1_0, arg_1_1)
	local var_1_0 = Managers.player:unit_owner(arg_1_0)

	if var_1_0 and not var_1_0.bot_player then
		local var_1_1 = var_1_0:network_id()
		local var_1_2 = Managers.state.network
		local var_1_3 = NetworkLookup.statistics[arg_1_1]

		var_1_2.network_transmit:send_rpc("rpc_increment_stat", var_1_1, var_1_3)
	end
end

local var_0_10 = {}
local var_0_11 = {}
local var_0_12 = 1
local var_0_13 = 2
local var_0_14 = 3
local var_0_15 = 4
local var_0_16 = 1
local var_0_17 = 2
local var_0_18 = 3
local var_0_19 = 4
local var_0_20 = 5

var_0_0.woods_javelin_melee = {
	name = "achv_woods_javelin_melee_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_javelin_melee_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_catch_a_dying_breath",
	required_dlc = "woods",
	events = {
		"register_kill"
	},
	progress = function(arg_2_0, arg_2_1, arg_2_2)
		local var_2_0 = arg_2_0:get_persistent_stat(arg_2_1, "woods_javelin_melee_kills")

		return {
			var_2_0,
			500
		}
	end,
	completed = function(arg_3_0, arg_3_1, arg_3_2)
		return arg_3_0:get_persistent_stat(arg_3_1, "woods_javelin_melee_kills") >= 500
	end,
	on_event = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		local var_4_0 = arg_4_4[var_0_14]
		local var_4_1 = var_4_0[DamageDataIndex.SOURCE_ATTACKER_UNIT]
		local var_4_2 = Managers.player:local_player().player_unit

		if not var_4_1 or var_4_2 ~= var_4_1 then
			return
		end

		local var_4_3 = var_4_0[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_4_4 = rawget(ItemMasterList, var_4_3)

		if not (var_4_4 and var_4_4.item_type == "we_javelin") then
			return
		end

		local var_4_5 = var_4_0[DamageDataIndex.ATTACK_TYPE]

		if var_4_5 and (var_4_5 == "light_attack" or var_4_5 == "heavy_attack") then
			local var_4_6 = ScriptUnit.has_extension(var_4_1, "career_system")

			if not var_4_6 or var_4_6:career_name() ~= "we_thornsister" then
				return
			end

			arg_4_0:increment_stat(arg_4_1, "woods_javelin_melee_kills")
		end
	end
}
var_0_0.woods_javelin_combo = {
	name = "achv_woods_javelin_combo_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_javelin_combo_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_dance_of_the_willow",
	required_dlc = "woods",
	events = {
		"register_kill"
	},
	completed = function(arg_5_0, arg_5_1, arg_5_2)
		return arg_5_0:get_persistent_stat(arg_5_1, "woods_javelin_combo") > 0
	end,
	on_event = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		local var_6_0 = arg_6_4[var_0_14]
		local var_6_1 = var_6_0[DamageDataIndex.SOURCE_ATTACKER_UNIT]
		local var_6_2 = Managers.player:local_player().player_unit

		if not var_6_1 or var_6_2 ~= var_6_1 then
			return
		end

		local var_6_3 = var_6_0[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_6_4 = rawget(ItemMasterList, var_6_3)

		if not (var_6_4 and var_6_4.item_type == "we_javelin") then
			return
		end

		local var_6_5 = ScriptUnit.has_extension(var_6_1, "career_system")

		if not var_6_5 or var_6_5:career_name() ~= "we_thornsister" then
			return
		end

		local var_6_6 = arg_6_4[var_0_15]
		local var_6_7 = var_6_0[DamageDataIndex.ATTACK_TYPE]

		if var_6_7 and (var_6_7 == "light_attack" or var_6_7 == "heavy_attack") then
			if var_6_6 and var_6_6.elite then
				arg_6_2.timed_kill = Managers.time:time("game")
			end
		elseif var_6_7 and var_6_7 == "projectile" and arg_6_2.timed_kill and var_6_6 and var_6_6.special then
			local var_6_8 = Managers.time:time("game") - arg_6_2.timed_kill

			if var_6_8 > 0 and var_6_8 < 3 then
				arg_6_0:increment_stat(arg_6_1, "woods_javelin_combo")
			end
		end
	end
}
var_0_0.woods_wall_kill_grind = {
	name = "achv_woods_wall_kill_grind_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_wall_kill_grind_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_the_awakening_of_the_woods",
	required_dlc = "woods",
	events = {
		"register_kill"
	},
	progress = function(arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = arg_7_0:get_persistent_stat(arg_7_1, "woods_wall_kill")

		return {
			var_7_0,
			500
		}
	end,
	completed = function(arg_8_0, arg_8_1, arg_8_2)
		return arg_8_0:get_persistent_stat(arg_8_1, "woods_wall_kill") >= 500
	end,
	on_event = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
		local var_9_0 = arg_9_4[var_0_14]
		local var_9_1 = var_9_0[DamageDataIndex.ATTACKER]
		local var_9_2 = Managers.player:local_player().player_unit

		if not var_9_1 or var_9_2 ~= var_9_1 then
			return
		end

		if var_9_0[DamageDataIndex.DAMAGE_SOURCE_NAME] ~= "career_ability" then
			return
		end

		local var_9_3 = ScriptUnit.has_extension(var_9_1, "career_system")

		if not var_9_3 or var_9_3:career_name() ~= "we_thornsister" then
			return
		end

		arg_9_0:increment_stat(arg_9_1, "woods_wall_kill")
	end
}
var_0_0.woods_lifted_kill = {
	required_dlc = "woods",
	name = "achv_woods_lifted_kill_name",
	required_dlc_extra = "woods",
	display_completion_ui = true,
	desc = "achv_woods_lifted_kill_desc",
	required_career = "we_thornsister",
	icon = "achievement_trophy_thornsister_ancients_vengeful_embrace",
	always_run = true,
	events = {
		"register_kill"
	},
	progress = function(arg_10_0, arg_10_1, arg_10_2)
		local var_10_0 = arg_10_0:get_persistent_stat(arg_10_1, "woods_lift_kills")

		return {
			var_10_0,
			250
		}
	end,
	completed = function(arg_11_0, arg_11_1, arg_11_2)
		return arg_11_0:get_persistent_stat(arg_11_1, "woods_lift_kills") >= 250
	end,
	on_event = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		if not Managers.state.network.is_server then
			return
		end

		local var_12_0 = arg_12_4[var_0_14][DamageDataIndex.ATTACKER]

		if not var_12_0 then
			return false
		end

		local var_12_1 = ScriptUnit.has_extension(var_12_0, "career_system")

		if not var_12_1 or var_12_1:career_name() ~= "we_thornsister" then
			return
		end

		local var_12_2 = arg_12_4[var_0_13]
		local var_12_3 = BLACKBOARDS[var_12_2]

		if not var_12_3 then
			return
		end

		if var_12_3.in_vortex then
			var_0_9(var_12_0, "woods_lift_kills")
		end
	end
}
var_0_0.woods_triple_lift = {
	required_dlc = "woods",
	name = "achv_woods_triple_lift_name",
	required_dlc_extra = "woods",
	display_completion_ui = true,
	desc = "achv_woods_triple_lift_desc",
	required_career = "we_thornsister",
	icon = "achievement_trophy_thornsister_away_with_the_faeries",
	always_run = true,
	events = {
		"vortex_caught_unit"
	},
	completed = function(arg_13_0, arg_13_1, arg_13_2)
		return arg_13_0:get_persistent_stat(arg_13_1, "woods_triple_lift") > 0
	end,
	on_event = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
		if not Managers.state.network.is_server then
			return
		end

		local var_14_0 = arg_14_4[1]
		local var_14_1 = arg_14_4[2]
		local var_14_2 = ScriptUnit.has_extension(var_14_0, "career_system")

		if not var_14_2 or var_14_2:career_name() ~= "we_thornsister" then
			return
		end

		local var_14_3 = BLACKBOARDS[var_14_1].breed

		if not var_14_3 or not var_14_3.special then
			return
		end

		if not arg_14_2.lifted_units then
			arg_14_2.lifted_units = {}
		end

		arg_14_2.lifted_units[var_14_1] = true

		local var_14_4 = 0

		for iter_14_0, iter_14_1 in pairs(arg_14_2.lifted_units) do
			if HEALTH_ALIVE[iter_14_0] then
				local var_14_5 = BLACKBOARDS[iter_14_0]

				if var_14_5 and var_14_5.in_vortex_state and (var_14_5.in_vortex_state == "in_vortex_init" or var_14_5.in_vortex_state == "in_vortex") then
					var_14_4 = var_14_4 + 1
				else
					arg_14_2.lifted_units[iter_14_0] = nil
				end
			else
				arg_14_2.lifted_units[iter_14_0] = nil
			end
		end

		if var_14_4 >= 3 then
			var_0_9(var_14_0, "woods_triple_lift")
		end
	end
}
var_0_0.woods_heal_grind = {
	name = "achv_woods_heal_grind_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_heal_grind_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_handmaiden_of_isha",
	required_dlc = "woods",
	events = {
		"register_heal"
	},
	progress = function(arg_15_0, arg_15_1, arg_15_2)
		local var_15_0 = arg_15_0:get_persistent_stat(arg_15_1, "woods_amount_healed")

		return {
			var_15_0,
			2000
		}
	end,
	completed = function(arg_16_0, arg_16_1, arg_16_2)
		return arg_16_0:get_persistent_stat(arg_16_1, "woods_amount_healed") > 2000
	end,
	on_event = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
		local var_17_0 = arg_17_4[1]
		local var_17_1 = Managers.player:local_player().player_unit

		if not var_17_0 or var_17_1 ~= var_17_0 then
			return
		end

		local var_17_2 = arg_17_4[4]
		local var_17_3 = arg_17_4[3]

		if var_17_2 == "heal_from_proc" or var_17_2 == "career_skill" then
			return
		end

		local var_17_4 = Managers.level_transition_handler:get_current_level_keys()
		local var_17_5 = LevelSettings[var_17_4]

		if var_17_5 and var_17_5.hub_level then
			return
		end

		local var_17_6 = ScriptUnit.has_extension(var_17_0, "career_system")

		if not var_17_6 or var_17_6:career_name() ~= "we_thornsister" then
			return
		end

		local var_17_7 = arg_17_0:get_persistent_stat(arg_17_1, "woods_amount_healed") + var_17_3

		arg_17_0:set_stat(arg_17_1, "woods_amount_healed", var_17_7)
	end
}
var_0_0.woods_bleed_grind = {
	name = "achv_woods_bleed_grind_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_bleed_grind_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_well_earned_agony",
	required_dlc = "woods",
	events = {
		"register_damage"
	},
	progress = function(arg_18_0, arg_18_1, arg_18_2)
		local var_18_0 = arg_18_0:get_persistent_stat(arg_18_1, "woods_bleed_tics")

		return {
			var_18_0,
			2000
		}
	end,
	completed = function(arg_19_0, arg_19_1, arg_19_2)
		return arg_19_0:get_persistent_stat(arg_19_1, "woods_bleed_tics") > 2000
	end,
	on_event = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
		local var_20_0 = arg_20_4[var_0_18][DamageDataIndex.DAMAGE_TYPE]

		if not var_20_0 or var_20_0 ~= "bleed" then
			return
		end

		local var_20_1 = Managers.level_transition_handler:get_current_level_keys()
		local var_20_2 = LevelSettings[var_20_1]

		if var_20_2 and var_20_2.hub_level then
			return
		end

		local var_20_3 = arg_20_4[var_0_19]
		local var_20_4 = Managers.player:local_player().player_unit

		if not var_20_3 or var_20_4 ~= var_20_3 then
			return
		end

		local var_20_5 = ScriptUnit.has_extension(var_20_3, "career_system")

		if not var_20_5 or var_20_5:career_name() ~= "we_thornsister" then
			return
		end

		arg_20_0:increment_stat(arg_20_1, "woods_bleed_tics")
	end
}
var_0_0.woods_chaos_pinata = {
	required_dlc = "woods",
	name = "achv_woods_chaos_pinata_name",
	required_dlc_extra = "woods",
	display_completion_ui = true,
	desc = "achv_woods_chaos_pinata_desc",
	required_career = "we_thornsister",
	icon = "achievement_trophy_thornsister_together_we",
	always_run = true,
	events = {
		"vortex_caught_unit",
		"register_damage",
		"register_kill"
	},
	completed = function(arg_21_0, arg_21_1, arg_21_2)
		return arg_21_0:get_persistent_stat(arg_21_1, "woods_chaos_pinata") > 0
	end,
	on_event = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
		if not Managers.state.network.is_server then
			return
		end

		if arg_22_3 == "vortex_caught_unit" then
			local var_22_0 = arg_22_4[1]
			local var_22_1 = arg_22_4[2]
			local var_22_2 = ScriptUnit.has_extension(var_22_0, "career_system")

			if not var_22_2 or var_22_2:career_name() ~= "we_thornsister" then
				return
			end

			local var_22_3 = BLACKBOARDS[var_22_1].breed

			if not var_22_3 or not var_22_3.name or var_22_3.name ~= "chaos_warrior" then
				return
			end

			if not arg_22_2.lifted_units then
				arg_22_2.lifted_units = {}
			end

			arg_22_2.lifted_units[var_22_1] = {}

			for iter_22_0, iter_22_1 in pairs(arg_22_2.lifted_units) do
				if not HEALTH_ALIVE[iter_22_0] then
					arg_22_2.lifted_units[iter_22_0] = nil
				end
			end
		elseif arg_22_3 == "register_damage" then
			local var_22_4 = arg_22_4[var_0_17]

			if not arg_22_2.lifted_units or not arg_22_2.lifted_units[var_22_4] then
				return
			end

			local var_22_5 = arg_22_4[var_0_18][DamageDataIndex.ATTACK_TYPE]

			if not var_22_5 or var_22_5 ~= "light_attack" and var_22_5 ~= "heavy_attack" then
				return
			end

			local var_22_6 = arg_22_4[var_0_19]

			if not var_22_6 then
				return
			end

			local var_22_7 = arg_22_2.lifted_units[var_22_4]
			local var_22_8 = Unit.get_data(var_22_6, "breed")

			if var_22_8 and var_22_8.is_hero then
				var_22_7[var_22_6] = true
			end
		else
			local var_22_9 = arg_22_4[var_0_13]

			if not arg_22_2.lifted_units or not arg_22_2.lifted_units[var_22_9] then
				return
			end

			local var_22_10 = BLACKBOARDS[var_22_9]

			if var_22_10 and var_22_10.in_vortex_state and (var_22_10.in_vortex_state == "in_vortex_init" or var_22_10.in_vortex_state == "in_vortex") then
				local var_22_11 = 0
				local var_22_12

				for iter_22_2, iter_22_3 in pairs(arg_22_2.lifted_units[var_22_9]) do
					var_22_11 = var_22_11 + 1

					local var_22_13 = ScriptUnit.has_extension(iter_22_2, "career_system")

					if var_22_13 and var_22_13:career_name() == "we_thornsister" then
						var_22_12 = iter_22_2
					end
				end

				if var_22_11 >= 2 and var_22_12 then
					var_0_9(var_22_12, "woods_chaos_pinata")
				end
			end
		end
	end
}
var_0_0.woods_ability_combo = {
	name = "achv_woods_ability_combo_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_ability_combo_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_rippling_radiance",
	required_dlc = "woods",
	events = {
		"any_ability_used"
	},
	completed = function(arg_23_0, arg_23_1, arg_23_2)
		return arg_23_0:get_persistent_stat(arg_23_1, "woods_ability_combo") > 0
	end,
	on_event = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
		local var_24_0 = Managers.player:local_player().player_unit
		local var_24_1 = ScriptUnit.has_extension(var_24_0, "career_system")

		if not var_24_1 or var_24_1:career_name() ~= "we_thornsister" then
			return
		end

		local var_24_2 = arg_24_4[1]
		local var_24_3 = ScriptUnit.has_extension(var_24_2, "career_system")

		if not var_24_3 or var_24_3:career_name() ~= "we_thornsister" then
			return
		end

		local var_24_4 = Managers.level_transition_handler:get_current_level_keys()
		local var_24_5 = LevelSettings[var_24_4]

		if var_24_5 and var_24_5.hub_level then
			return
		end

		local var_24_6 = Managers.time:time("game")

		if not arg_24_2.use_times then
			arg_24_2.use_times = {}
		end

		local var_24_7 = arg_24_2.use_times

		if #var_24_7 >= 5 then
			table.remove(var_24_7, 1)
		end

		var_24_7[#var_24_7 + 1] = var_24_6

		if #var_24_7 >= 5 then
			local var_24_8 = true
			local var_24_9 = var_24_7[1]

			for iter_24_0 = 1, #var_24_7 do
				if var_24_7[iter_24_0] - var_24_9 > 10 then
					var_24_8 = false
				end
			end

			if var_24_8 then
				arg_24_0:increment_stat(arg_24_1, "woods_ability_combo")
			end
		end
	end
}
var_0_0.woods_wall_tank = {
	name = "achv_woods_wall_tank_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_wall_tank_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_roots_of_ages",
	required_dlc = "woods",
	events = {
		"register_thorn_wall_damage"
	},
	progress = function(arg_25_0, arg_25_1, arg_25_2)
		local var_25_0 = arg_25_0:get_persistent_stat(arg_25_1, "woods_wall_hits_soaked")

		return {
			var_25_0,
			1000
		}
	end,
	completed = function(arg_26_0, arg_26_1, arg_26_2)
		return arg_26_0:get_persistent_stat(arg_26_1, "woods_wall_hits_soaked") > 1000
	end,
	on_event = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4)
		local var_27_0 = Managers.player:local_player().player_unit
		local var_27_1 = ScriptUnit.has_extension(var_27_0, "career_system")

		if not var_27_1 or var_27_1:career_name() ~= "we_thornsister" then
			return
		end

		local var_27_2 = arg_27_4[1]
		local var_27_3 = arg_27_4[2]
		local var_27_4 = arg_27_4[4]
		local var_27_5 = Unit.get_data(var_27_3, "breed")

		if var_27_5 and not var_27_5.is_hero then
			if var_27_4 then
				if var_27_4 ~= "projectile" then
					arg_27_0:increment_stat(arg_27_1, "woods_wall_hits_soaked")
				end
			else
				arg_27_0:increment_stat(arg_27_1, "woods_wall_hits_soaked")
			end
		end
	end
}
var_0_0.woods_wall_block_ratling = {
	name = "achv_woods_wall_block_ratling_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_wall_block_ratling_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_sheltering_thicket",
	required_dlc = "woods",
	events = {
		"register_thorn_wall_damage"
	},
	progress = function(arg_28_0, arg_28_1, arg_28_2)
		local var_28_0 = arg_28_0:get_persistent_stat(arg_28_1, "woods_ratling_shots_soaked")

		return {
			var_28_0,
			500
		}
	end,
	completed = function(arg_29_0, arg_29_1, arg_29_2)
		return arg_29_0:get_persistent_stat(arg_29_1, "woods_ratling_shots_soaked") >= 500
	end,
	on_event = function(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
		local var_30_0 = Managers.player:local_player().player_unit
		local var_30_1 = ScriptUnit.has_extension(var_30_0, "career_system")

		if not var_30_1 or var_30_1:career_name() ~= "we_thornsister" then
			return
		end

		local var_30_2 = arg_30_4[1]
		local var_30_3 = arg_30_4[2]
		local var_30_4 = arg_30_4[4]
		local var_30_5 = Unit.get_data(var_30_3, "breed")

		if var_30_5 and var_30_5.name == "skaven_ratling_gunner" and var_30_4 and var_30_4 == "projectile" then
			arg_30_0:increment_stat(arg_30_1, "woods_ratling_shots_soaked")
		end
	end
}
var_0_0.woods_bleed_boss = {
	name = "achv_woods_bleed_boss_name",
	required_dlc_extra = "woods",
	desc = "achv_woods_bleed_boss_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_thornsister_an_offering_of_pain",
	required_dlc = "woods",
	events = {
		"register_damage",
		"register_kill"
	},
	completed = function(arg_31_0, arg_31_1, arg_31_2)
		return arg_31_0:get_persistent_stat(arg_31_1, "woods_bleed_boss") > 0
	end,
	on_event = function(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
		if arg_32_3 == "register_damage" then
			local var_32_0 = arg_32_4[var_0_20]

			if not var_32_0 or not var_32_0.boss then
				return
			end

			local var_32_1 = arg_32_4[var_0_18]
			local var_32_2 = var_32_1[DamageDataIndex.DAMAGE_TYPE]

			if not var_32_2 or var_32_2 ~= "bleed" then
				return
			end

			local var_32_3 = arg_32_4[var_0_19]
			local var_32_4 = Managers.player:local_player().player_unit

			if not var_32_3 or var_32_4 ~= var_32_3 then
				return
			end

			local var_32_5 = ScriptUnit.has_extension(var_32_3, "career_system")

			if not var_32_5 or var_32_5:career_name() ~= "we_thornsister" then
				return
			end

			local var_32_6 = arg_32_4[var_0_17]

			if not arg_32_2.target_bosses then
				arg_32_2.target_bosses = {}
			end

			if not arg_32_2.target_max_healths then
				arg_32_2.target_max_healths = {}
			end

			if not arg_32_2.target_bosses[var_32_6] then
				arg_32_2.target_bosses[var_32_6] = 0
			end

			arg_32_2.target_bosses[var_32_6] = arg_32_2.target_bosses[var_32_6] + var_32_1[DamageDataIndex.DAMAGE_AMOUNT]

			local var_32_7 = ScriptUnit.has_extension(var_32_6, "health_system")

			if not var_32_7 then
				return
			end

			local var_32_8 = arg_32_2.target_max_healths[var_32_6]

			if not var_32_8 then
				var_32_8 = var_32_7:get_max_health()
				arg_32_2.target_max_healths[var_32_6] = var_32_8
			end

			if arg_32_2.target_bosses[var_32_6] / var_32_8 > 0.2 then
				arg_32_0:increment_stat(arg_32_1, "woods_bleed_boss")
			end
		else
			if not arg_32_2.target_bosses then
				return
			end

			if arg_32_4[var_0_15].boss then
				for iter_32_0, iter_32_1 in pairs(arg_32_2.target_bosses) do
					if not HEALTH_ALIVE[iter_32_0] then
						arg_32_2.target_bosses[iter_32_0] = nil

						if arg_32_2.target_max_healths and arg_32_2.target_max_healths[iter_32_0] then
							arg_32_2.target_max_healths[iter_32_0] = nil
						end
					end
				end
			end
		end
	end
}
var_0_0.woods_wall_kill_gutter = {
	required_dlc = "woods",
	name = "achv_woods_wall_kill_gutter_name",
	required_dlc_extra = "woods",
	display_completion_ui = true,
	desc = "achv_woods_wall_kill_gutter_desc",
	required_career = "we_thornsister",
	icon = "achievement_trophy_thornsister_shall_not_pass",
	always_run = true,
	events = {
		"register_damage"
	},
	completed = function(arg_33_0, arg_33_1, arg_33_2)
		return arg_33_0:get_persistent_stat(arg_33_1, "woods_wall_kill_gutter") > 0
	end,
	on_event = function(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
		if not Managers.state.network.is_server then
			return
		end

		local var_34_0 = arg_34_4[5]
		local var_34_1 = var_34_0.name
		local var_34_2 = var_34_0 and var_34_1 == "skaven_gutter_runner"
		local var_34_3 = arg_34_4[3]
		local var_34_4 = var_34_3[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_34_5 = var_34_3 and var_34_4 == "career_ability"
		local var_34_6 = var_34_3[DamageDataIndex.ATTACKER]
		local var_34_7 = ScriptUnit.has_extension(var_34_6, "career_system")
		local var_34_8 = var_34_7 and var_34_7:career_name() == "we_thornsister"

		if var_34_2 and var_34_5 and var_34_8 then
			local var_34_9 = arg_34_4[2]
			local var_34_10 = BLACKBOARDS[var_34_9].jump_data

			if var_34_10 and (var_34_10.state == "in_air" or var_34_10.state == "in_air_no_target" or var_34_10.state == "snapping") then
				var_0_9(var_34_6, "woods_wall_kill_gutter")
			end
		end
	end
}
var_0_0.woods_wall_dual_save = {
	required_dlc = "woods",
	name = "achv_woods_wall_dual_save_name",
	required_dlc_extra = "woods",
	display_completion_ui = true,
	desc = "achv_woods_wall_dual_save_desc",
	required_career = "we_thornsister",
	icon = "achievement_trophy_thornsister_thorny_rescue",
	always_run = true,
	events = {
		"register_damage"
	},
	completed = function(arg_35_0, arg_35_1, arg_35_2)
		return arg_35_0:get_persistent_stat(arg_35_1, "woods_wall_dual_save") > 0
	end,
	on_event = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
		if not Managers.state.network.is_server then
			return
		end

		local var_36_0 = arg_36_4[var_0_18]

		if var_36_0[DamageDataIndex.DAMAGE_SOURCE_NAME] ~= "career_ability" then
			return
		end

		local var_36_1 = arg_36_4[var_0_20]

		if not var_36_1 or not var_36_1.special then
			return
		end

		local var_36_2 = var_36_0[DamageDataIndex.ATTACKER]
		local var_36_3 = ScriptUnit.has_extension(var_36_2, "career_system")

		if not var_36_3 or var_36_3:career_name() ~= "we_thornsister" then
			return
		end

		local var_36_4 = arg_36_4[var_0_13]
		local var_36_5 = BLACKBOARDS[var_36_4]

		if not var_36_1.name then
			return
		end

		local var_36_6 = false

		if var_36_1.name == "skaven_pack_master" then
			local var_36_7 = var_36_5.action
			local var_36_8 = var_36_7 and var_36_7.name

			if var_36_8 == "pull" or var_36_8 == "initial_pull" or var_36_8 == "drag" or var_36_8 == "hoist" then
				var_36_6 = true
			end
		elseif var_36_1.name == "skaven_gutter_runner" then
			if var_36_5.pouncing_target then
				var_36_6 = true
			end
		elseif var_36_1.name == "chaos_corruptor_sorcerer" and var_36_5.grabbed_unit then
			var_36_6 = true
		end

		if var_36_6 then
			local var_36_9 = Managers.time:time("game")
			local var_36_10 = arg_36_2.last_timed_interrupt

			if var_36_10 then
				local var_36_11 = var_36_9 - var_36_10

				if var_36_11 < 0.5 and var_36_11 > -0.1 then
					var_0_9(var_36_2, "woods_wall_dual_save")
				end
			end

			arg_36_2.last_timed_interrupt = var_36_9
		end
	end
}
var_0_0.woods_free_ability_grind = {
	required_dlc = "woods",
	name = "achv_woods_free_ability_grind_name",
	required_dlc_extra = "woods",
	display_completion_ui = true,
	desc = "achv_woods_free_ability_grind_desc",
	required_career = "we_thornsister",
	icon = "achievement_trophy_thornsister_weaves_bounty",
	always_run = true,
	events = {
		"free_cast_used"
	},
	progress = function(arg_37_0, arg_37_1, arg_37_2)
		local var_37_0 = arg_37_0:get_persistent_stat(arg_37_1, "woods_free_abilities_used")

		return {
			var_37_0,
			50
		}
	end,
	completed = function(arg_38_0, arg_38_1, arg_38_2)
		return arg_38_0:get_persistent_stat(arg_38_1, "woods_free_abilities_used") >= 50
	end,
	on_event = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
		local var_39_0 = arg_39_4[2]

		if var_39_0 ~= Managers.player:local_player().player_unit then
			return
		end

		local var_39_1 = Managers.level_transition_handler:get_current_level_keys()
		local var_39_2 = LevelSettings[var_39_1]

		if var_39_2 and var_39_2.hub_level then
			return
		end

		local var_39_3 = ScriptUnit.has_extension(var_39_0, "career_system")

		if not var_39_3 or var_39_3:career_name() ~= "we_thornsister" then
			return
		end

		arg_39_0:increment_stat(arg_39_1, "woods_free_abilities_used")
	end
}

local var_0_21 = GameActs.act_1
local var_0_22 = GameActs.act_2
local var_0_23 = GameActs.act_3
local var_0_24 = HelmgartLevels
local var_0_25 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

for iter_0_0 = 1, #var_0_25 do
	local var_0_26 = var_0_25[iter_0_0]
	local var_0_27 = DifficultyMapping[var_0_26]
	local var_0_28 = "woods_complete_all_helmgart_levels_" .. var_0_27
	local var_0_29 = "achievement_trophy_" .. var_0_27 .. "_thornsister"

	var_0_2(var_0_0, var_0_28, var_0_24, DifficultySettings[var_0_26].rank, "we_thornsister", false, var_0_29, "woods", nil, nil)
end

var_0_4(var_0_0, "woods_complete_25_missions", "completed_career_levels", "we_thornsister", var_0_25, 25, nil, "achievement_trophy_thornsister_bitter_rose_among_thorns", "woods", nil, nil)

local var_0_30 = {
	"woods_complete_all_helmgart_levels_recruit_we_thornsister",
	"woods_complete_all_helmgart_levels_veteran_we_thornsister",
	"woods_complete_all_helmgart_levels_champion_we_thornsister",
	"woods_complete_all_helmgart_levels_legend_we_thornsister",
	"woods_complete_25_missions_we_thornsister",
	"woods_javelin_melee",
	"woods_lifted_kill",
	"woods_javelin_combo",
	"woods_triple_lift",
	"woods_heal_grind",
	"woods_wall_kill_grind",
	"woods_bleed_grind",
	"woods_chaos_pinata",
	"woods_bleed_boss",
	"woods_wall_kill_gutter",
	"woods_wall_dual_save",
	"woods_ability_combo",
	"woods_wall_tank",
	"woods_wall_block_ratling",
	"woods_free_ability_grind"
}

var_0_5(var_0_0, "complete_all_thorn_sister_challenges", var_0_30, "achievement_trophy_thornsister_reborn_through_the_weave", "woods", nil, nil)
