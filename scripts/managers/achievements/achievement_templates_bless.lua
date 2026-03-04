-- chunkname: @scripts/managers/achievements/achievement_templates_bless.lua

local var_0_0 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_1 = AchievementTemplates.achievements
local var_0_2 = DLCSettings.bless
local var_0_3 = AchievementTemplateHelper.rpc_increment_stat
local var_0_4 = AchievementTemplateHelper.rpc_modify_stat
local var_0_5 = AchievementTemplateHelper.add_levels_complete_per_hero_challenge
local var_0_6 = AchievementTemplateHelper.add_career_mission_count_challenge
local var_0_7 = AchievementTemplateHelper.add_meta_challenge
local var_0_8 = {}
local var_0_9 = {}
local var_0_10 = 1
local var_0_11 = 2
local var_0_12 = 3
local var_0_13 = 4
local var_0_14 = 5
local var_0_15 = 1
local var_0_16 = 2
local var_0_17 = 3
local var_0_18 = 4
local var_0_19 = 1
local var_0_20 = 2
local var_0_21 = 3
local var_0_22 = 4
local var_0_23 = 5
local var_0_24 = 6
local var_0_25 = 7
local var_0_26 = 8
local var_0_27 = HelmgartLevels

var_0_5(var_0_1, "bless_complete_all_helmgart_levels", var_0_27, 2, "wh_priest", false, "achievement_trophy_bless_complete_all_helmgart_levels_wh_priest", "bless", nil, nil)

local var_0_28 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

var_0_6(var_0_1, "bless_complete_25_missions", "completed_career_levels", "wh_priest", var_0_28, 25, nil, "achievement_trophy_bless_complete_25_missions_wh_priest", "bless", nil, nil)

local var_0_29 = 1500

var_0_1.bless_heal_allies = {
	name = "achv_bless_heal_allies_name",
	desc = "achv_bless_heal_allies_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_bless_heal_allies",
	required_dlc = "bless",
	events = {
		"register_heal"
	},
	progress = function (arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = arg_1_0:get_persistent_stat(arg_1_1, "bless_heal_allies")

		return {
			var_1_0,
			var_0_29
		}
	end,
	completed = function (arg_2_0, arg_2_1, arg_2_2)
		return arg_2_0:get_persistent_stat(arg_2_1, "bless_heal_allies") >= var_0_29
	end,
	on_event = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		local var_3_0 = arg_3_4[1]
		local var_3_1 = arg_3_4[2]
		local var_3_2 = arg_3_4[3]
		local var_3_3 = arg_3_4[4]
		local var_3_4 = Managers.player:local_player().player_unit

		if not var_3_1 or var_3_4 ~= var_3_0 then
			return
		end

		if var_3_0 == var_3_1 then
			return
		end

		local var_3_5 = ScriptUnit.has_extension(var_3_0, "career_system")

		if not var_3_5 or var_3_5:career_name() ~= "wh_priest" then
			return
		end

		arg_3_0:modify_stat_by_amount(arg_3_1, "bless_heal_allies", var_3_2)
	end
}

local var_0_30 = 5

var_0_1.bless_saved_by_perk = {
	name = "achv_bless_saved_by_perk_name",
	desc = "achv_bless_saved_by_perk_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_bless_saved_by_perk",
	required_dlc = "bless",
	events = {
		"register_damage_taken",
		"player_dead",
		"player_knocked_down"
	},
	progress = function (arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = arg_4_0:get_persistent_stat(arg_4_1, "bless_saved_by_perk")

		return {
			var_4_0,
			var_0_30
		}
	end,
	completed = function (arg_5_0, arg_5_1, arg_5_2)
		return arg_5_0:get_persistent_stat(arg_5_1, "bless_saved_by_perk") >= var_0_30
	end,
	on_event = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		if arg_6_3 == "register_damage_taken" then
			local var_6_0 = arg_6_4[1]
			local var_6_1 = arg_6_4[2]

			if not var_6_1 then
				return
			end

			local var_6_2 = Managers.player:local_player().player_unit

			if not var_6_0 or var_6_2 ~= var_6_0 then
				return
			end

			local var_6_3 = ScriptUnit.has_extension(var_6_0, "career_system")

			if not var_6_3 or var_6_3:career_name() ~= "wh_priest" then
				return
			end

			local var_6_4 = ScriptUnit.extension(var_6_0, "health_system"):current_health()
			local var_6_5 = var_6_1[DamageDataIndex.DAMAGE_AMOUNT]
			local var_6_6 = var_6_1[DamageDataIndex.DAMAGE_TYPE]

			if var_6_4 - var_6_5 < 6 and var_6_6 == "life_tap" then
				local var_6_7 = arg_6_2.timer_handles or {}

				arg_6_2.timer_handles = var_6_7

				local var_6_8 = var_6_7[var_6_0]

				if not var_6_8 or not var_6_8.valid then
					var_6_7[var_6_0] = Managers.state.achievement:register_timed_event("bless_saved_by_perk", "on_timed_event", 5, var_6_0)
				end
			end
		elseif arg_6_2.timer_handles then
			local var_6_9 = arg_6_4[1]
			local var_6_10 = var_6_9 and var_6_9.player_unit
			local var_6_11 = arg_6_2.timer_handles
			local var_6_12 = var_6_11[var_6_10]

			if var_6_12 and var_6_12.valid then
				Managers.state.achievement:cancel_timed_event(var_6_12)

				var_6_11[var_6_10] = nil
			end
		end
	end,
	on_timed_event = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		local var_7_0 = arg_7_3

		if HEALTH_ALIVE[var_7_0] then
			arg_7_0:increment_stat(arg_7_1, "bless_saved_by_perk")

			arg_7_2.timer_handles[var_7_0] = nil
		end
	end
}
bless_book_run_amount = 5
var_0_1.bless_book_run = {
	name = "achv_bless_book_run_name",
	desc = "achv_bless_book_run_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_bless_book_run",
	required_dlc = "bless",
	events = {
		"register_completed_level"
	},
	progress = function (arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = arg_8_0:get_persistent_stat(arg_8_1, "bless_book_run")

		return {
			var_8_0,
			bless_book_run_amount
		}
	end,
	completed = function (arg_9_0, arg_9_1, arg_9_2)
		return arg_9_0:get_persistent_stat(arg_9_1, "bless_book_run") >= bless_book_run_amount
	end,
	on_event = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		if arg_10_4[3] == "wh_priest" then
			local var_10_0 = arg_10_4[4]

			if var_10_0 and not var_10_0.bot_player then
				local var_10_1 = var_10_0.player_unit
				local var_10_2 = ScriptUnit.has_extension(var_10_1, "inventory_system")

				if not var_10_2 then
					return
				end

				local var_10_3 = var_10_2:get_slot_data("slot_healthkit")
				local var_10_4 = var_10_2:get_slot_data("slot_potion")

				if not var_10_4 or not var_10_3 then
					return
				end

				local var_10_5 = var_10_2:get_item_template(var_10_3)
				local var_10_6 = var_10_2:get_item_template(var_10_4)

				if var_10_5.is_grimoire and var_10_6.is_grimoire then
					arg_10_0:increment_stat(arg_10_1, "bless_book_run")
				end
			end
		end
	end
}

local var_0_31 = 10
local var_0_32 = 1

var_0_1.bless_fast_shield = {
	name = "achv_bless_fast_shield_name",
	desc = "achv_bless_fast_shield_desc",
	display_completion_ui = true,
	icon = "achievement_trophy_bless_fast_shield",
	required_dlc = "bless",
	events = {
		"register_shield_applied",
		"register_player_disabled"
	},
	progress = function (arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = arg_11_0:get_persistent_stat(arg_11_1, "bless_fast_shield")

		return {
			var_11_0,
			var_0_31
		}
	end,
	completed = function (arg_12_0, arg_12_1, arg_12_2)
		return arg_12_0:get_persistent_stat(arg_12_1, "bless_fast_shield") >= var_0_31
	end,
	on_event = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
		if arg_13_3 == "register_shield_applied" then
			local var_13_0 = arg_13_4[1]
			local var_13_1 = arg_13_4[2]
			local var_13_2 = Managers.player:local_player().player_unit

			if not var_13_0 or var_13_2 ~= var_13_1 then
				return
			end

			local var_13_3 = ScriptUnit.has_extension(var_13_0, "status_system")

			if not var_13_3 then
				return
			end

			if not (var_13_3:is_pounced_down() or var_13_3:is_grabbed_by_pack_master() or var_13_3:is_grabbed_by_corruptor()) then
				return
			end

			local var_13_4 = arg_13_2.incapacitated_units[var_13_0]

			if not var_13_4 then
				return
			end

			local var_13_5 = Managers.time:time("game") - var_13_4

			if var_13_5 <= var_0_32 and var_13_5 >= 0 then
				arg_13_0:increment_stat(arg_13_1, "bless_fast_shield")
			end
		else
			local var_13_6 = arg_13_2.incapacitated_units or {}
			local var_13_7 = Managers.time:time("game")

			for iter_13_0, iter_13_1 in pairs(var_13_6) do
				if not ALIVE[iter_13_0] or var_13_7 - iter_13_1 > var_0_32 then
					var_13_6[iter_13_0] = nil
				end
			end

			var_13_6[arg_13_4[1]] = var_13_7
			arg_13_2.incapacitated_units = var_13_6
		end
	end
}

local var_0_33 = 500

var_0_1.bless_unbreakable_damage_block = {
	always_run = true,
	name = "achv_bless_unbreakable_damage_block_name",
	display_completion_ui = true,
	desc = "achv_bless_unbreakable_damage_block_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_unbreakable_damage_block",
	required_dlc = "bless",
	events = {
		"bless_delay_damage"
	},
	progress = function (arg_14_0, arg_14_1, arg_14_2)
		local var_14_0 = arg_14_0:get_persistent_stat(arg_14_1, "bless_unbreakable_damage_block")

		return {
			var_14_0,
			var_0_33
		}
	end,
	completed = function (arg_15_0, arg_15_1, arg_15_2)
		return arg_15_0:get_persistent_stat(arg_15_1, "bless_unbreakable_damage_block") >= var_0_33
	end,
	on_event = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		local var_16_0 = arg_16_4[1]
		local var_16_1 = arg_16_4[2]

		if not var_16_1 or not var_16_0 then
			return
		end

		local var_16_2 = ScriptUnit.has_extension(var_16_0, "buff_system")

		if not var_16_2 then
			return
		end

		if var_16_2:num_buff_stacks("victor_priest_activated_ability_invincibility") <= 0 then
			return
		end

		local var_16_3 = DamageUtils.networkify_damage(var_16_1)

		var_0_4(var_16_0, "bless_unbreakable_damage_block", var_16_3)
	end
}

local var_0_34 = 3

var_0_1.bless_punch_back = {
	always_run = true,
	name = "achv_bless_punch_back_name",
	display_completion_ui = true,
	desc = "achv_bless_punch_back_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_punch_back",
	required_dlc = "bless",
	events = {
		"register_damage_taken",
		"register_damage"
	},
	completed = function (arg_17_0, arg_17_1, arg_17_2)
		return arg_17_0:get_persistent_stat(arg_17_1, "bless_punch_back") >= 1
	end,
	on_event = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
		if not Managers.state.network.is_server then
			return
		end

		if arg_18_3 == "register_damage_taken" then
			local var_18_0 = arg_18_4[1]
			local var_18_1 = arg_18_4[2]
			local var_18_2 = var_18_1 and var_18_1[DamageDataIndex.ATTACKER]

			if not ALIVE[var_18_2] or not ALIVE[var_18_0] then
				return
			end

			local var_18_3 = ScriptUnit.has_extension(var_18_0, "career_system")

			if not var_18_3 or var_18_3:career_name() ~= "wh_priest" then
				return
			end

			local var_18_4 = BLACKBOARDS[var_18_2]
			local var_18_5 = var_18_4 and var_18_4.breed

			if var_18_5 and var_18_5.name ~= "chaos_warrior" then
				return
			end

			local var_18_6 = ScriptUnit.has_extension(var_18_2, "ai_system")

			if (var_18_6 and var_18_6:current_action_name()) == "special_attack_quick" then
				local var_18_7 = Managers.time:time("game")

				if not arg_18_2.last_hit then
					arg_18_2.last_hit = {
						[var_18_2] = var_18_7
					}
					arg_18_2.last_hit_n = 1
				else
					arg_18_2.last_hit[var_18_2] = var_18_7
					arg_18_2.last_hit_n = arg_18_2.last_hit_n + 1
				end

				if arg_18_2.last_hit_n >= 10 then
					local var_18_8 = arg_18_2.last_hit
					local var_18_9 = arg_18_2.last_hit_n

					for iter_18_0, iter_18_1 in var_18_8 do
						if not ALIVE[iter_18_0] or var_18_7 > iter_18_1 + var_0_34 then
							var_18_8[iter_18_0] = nil
							var_18_9 = var_18_9 - 1
						end
					end

					arg_18_2.last_hit_n = var_18_9
				end
			end
		elseif arg_18_2.last_hit then
			local var_18_10 = arg_18_4[var_0_11]
			local var_18_11 = arg_18_2.last_hit[var_18_10]

			if var_18_11 then
				local var_18_12 = arg_18_4[var_0_12]
				local var_18_13 = var_18_12[DamageDataIndex.DAMAGE_TYPE]
				local var_18_14 = var_18_12[DamageDataIndex.DAMAGE_SOURCE_NAME]
				local var_18_15 = rawget(ItemMasterList, var_18_14)
				local var_18_16 = var_18_15 and var_18_15.item_type == "wh_2h_hammer" and var_18_13 == "stab_smiter"
				local var_18_17 = Managers.time:time("game")

				if var_18_16 and var_18_17 - var_18_11 <= var_0_34 then
					local var_18_18 = arg_18_4[var_0_13]

					var_0_3(var_18_18, "bless_punch_back")
				else
					arg_18_2.last_hit[var_18_10] = nil
					arg_18_2.last_hit_n = arg_18_2.last_hit_n - 1
				end
			end
		end
	end
}
var_0_1.bless_cluch_revive = {
	display_completion_ui = true,
	name = "achv_bless_cluch_revive_name",
	desc = "achv_bless_cluch_revive_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_cluch_revive",
	required_dlc = "bless",
	events = {
		"register_revive"
	},
	completed = function (arg_19_0, arg_19_1, arg_19_2)
		return arg_19_0:get_persistent_stat(arg_19_1, "bless_cluch_revive") >= 1
	end,
	on_event = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
		local var_20_0 = arg_20_4[1]
		local var_20_1 = arg_20_4[2]
		local var_20_2 = Managers.player:local_player()
		local var_20_3 = var_20_2 and var_20_2.player_unit

		if not ALIVE[var_20_1] or not ALIVE[var_20_0] or var_20_3 ~= var_20_0 then
			return
		end

		local var_20_4 = ScriptUnit.has_extension(var_20_0, "career_system")

		if not var_20_4 or var_20_4:career_name() ~= "wh_priest" then
			return
		end

		local var_20_5 = ScriptUnit.has_extension(var_20_0, "buff_system")

		if not var_20_5 then
			return
		end

		if var_20_5:num_buff_stacks("victor_priest_activated_ability_invincibility") <= 0 then
			return
		end

		local var_20_6 = Managers.state.side.side_by_unit[var_20_0]

		if not var_20_6 then
			return
		end

		local var_20_7 = var_20_6.PLAYER_AND_BOT_UNITS

		if not var_20_7 then
			return
		end

		for iter_20_0 = 1, #var_20_7 do
			local var_20_8 = var_20_7[iter_20_0]

			if var_20_8 ~= var_20_0 then
				local var_20_9 = ScriptUnit.has_extension(var_20_8, "status_system")

				if var_20_9 and not var_20_9:is_knocked_down() and not var_20_9:is_dead() and not var_20_9:is_ready_for_assisted_respawn() then
					return
				end
			end
		end

		arg_20_0:increment_stat(arg_20_1, "bless_cluch_revive")
	end
}

local var_0_35 = 2
local var_0_36 = {
	skaven_ratling_gunner = true,
	skaven_warpfire_thrower = true
}

var_0_1.bless_ranged_raki = {
	display_completion_ui = true,
	name = "achv_bless_ranged_raki_name",
	desc = "achv_bless_ranged_raki_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_ranged_raki",
	required_dlc = "bless",
	events = {
		"register_kill"
	},
	completed = function (arg_21_0, arg_21_1, arg_21_2)
		return arg_21_0:get_persistent_stat(arg_21_1, "bless_ranged_raki") >= 1
	end,
	on_event = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4)
		local var_22_0 = Managers.player:local_player()
		local var_22_1 = var_22_0 and var_22_0.player_unit
		local var_22_2 = arg_22_4[var_0_17][DamageDataIndex.ATTACKER]

		if var_22_2 and var_22_1 ~= var_22_2 then
			return
		end

		local var_22_3 = arg_22_4[var_0_18]

		if not var_22_3 or not var_0_36[var_22_3.name] then
			return
		end

		local var_22_4 = ScriptUnit.has_extension(var_22_2, "career_system")

		if not var_22_4 or var_22_4:career_name() ~= "wh_priest" then
			return
		end

		local var_22_5 = ScriptUnit.has_extension(var_22_2, "buff_system")

		if not var_22_5 then
			return
		end

		local var_22_6 = var_22_5:get_buff_type("victor_priest_activated_ability_invincibility")

		if var_22_6 then
			if not arg_22_2.last_buff_id or not var_22_6 or arg_22_2.last_buff_id ~= var_22_6.id then
				arg_22_2.last_buff_id = var_22_6.id
				arg_22_2.kill_count = 0
			end

			arg_22_2.kill_count = arg_22_2.kill_count + 1

			if arg_22_2.kill_count >= var_0_35 then
				arg_22_0:increment_stat(arg_22_1, "bless_ranged_raki")
			end
		end
	end
}

local var_0_37 = 5

var_0_1.bless_chaos_warriors = {
	display_completion_ui = true,
	name = "achv_bless_chaos_warriors_name",
	desc = "achv_bless_chaos_warriors_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_chaos_warriors",
	required_dlc = "bless",
	events = {
		"register_kill",
		"righteous_fury_start",
		"righteous_fury_end",
		"player_dead"
	},
	completed = function (arg_23_0, arg_23_1, arg_23_2)
		return arg_23_0:get_persistent_stat(arg_23_1, "bless_chaos_warriors") >= 1
	end,
	on_event = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
		if arg_24_3 == "righteous_fury_start" and arg_24_4[2] then
			arg_24_2.righteous_fury_active = true
			arg_24_2.kill_count = 0
		elseif arg_24_3 == "righteous_fury_end" and arg_24_4[2] or arg_24_3 == "player_dead" and arg_24_4[1] and arg_24_4[1].local_player then
			arg_24_2.righteous_fury_active = false
		elseif arg_24_2.righteous_fury_active then
			local var_24_0 = arg_24_4[var_0_18]

			if var_24_0 and var_24_0.name == "chaos_warrior" then
				arg_24_2.kill_count = arg_24_2.kill_count + 1

				if arg_24_2.kill_count >= var_0_37 then
					arg_24_0:increment_stat(arg_24_1, "bless_chaos_warriors")
				end
			end
		end
	end
}

local var_0_38 = 50

var_0_1.bless_very_righteous = {
	display_completion_ui = true,
	name = "achv_bless_very_righteous_name",
	desc = "achv_bless_very_righteous_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_very_righteous",
	required_dlc = "bless",
	events = {
		"righteous_fury_start",
		"righteous_fury_end",
		"player_dead"
	},
	completed = function (arg_25_0, arg_25_1, arg_25_2)
		return arg_25_0:get_persistent_stat(arg_25_1, "bless_very_righteous") >= 1
	end,
	on_event = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4)
		local var_26_0 = Managers.time:time("game")

		if arg_26_3 == "righteous_fury_start" and arg_26_4[2] then
			arg_26_2.righteous_fury_active = var_26_0
		elseif arg_26_3 == "righteous_fury_end" and arg_26_4[2] or arg_26_3 == "player_dead" and arg_26_4[1] and arg_26_4[1].local_player then
			local var_26_1 = arg_26_2.righteous_fury_active

			if var_26_1 and var_26_0 - var_26_1 >= var_0_38 then
				arg_26_0:increment_stat(arg_26_1, "bless_very_righteous")
			end
		end
	end
}

local var_0_39 = 250

var_0_1.bless_smite_enemies = {
	display_completion_ui = true,
	name = "achv_bless_smite_enemies_name",
	desc = "achv_bless_smite_enemies_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_smite_enemies",
	required_dlc = "bless",
	events = {
		"register_kill"
	},
	progress = function (arg_27_0, arg_27_1, arg_27_2)
		local var_27_0 = arg_27_0:get_persistent_stat(arg_27_1, "bless_smite_enemies")

		return {
			var_27_0,
			var_0_39
		}
	end,
	completed = function (arg_28_0, arg_28_1, arg_28_2)
		return arg_28_0:get_persistent_stat(arg_28_1, "bless_smite_enemies") >= var_0_39
	end,
	on_event = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
		local var_29_0 = arg_29_4[var_0_17]
		local var_29_1 = var_29_0 and var_29_0[DamageDataIndex.ATTACKER]

		if not ALIVE[var_29_1] then
			return
		end

		local var_29_2 = Managers.player:local_player()
		local var_29_3 = var_29_2 and var_29_2.player_unit

		if not var_29_3 or var_29_3 ~= var_29_1 then
			return
		end

		local var_29_4 = var_29_0 and var_29_0[DamageDataIndex.DAMAGE_TYPE]
		local var_29_5 = var_29_0 and var_29_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if var_29_4 ~= "buff" or var_29_5 ~= "career_ability" then
			return
		end

		local var_29_6 = ScriptUnit.has_extension(var_29_1, "career_system")

		if not var_29_6 or var_29_6:career_name() ~= "wh_priest" then
			return
		end

		arg_29_0:increment_stat(arg_29_1, "bless_smite_enemies")
	end
}

local var_0_40 = 40

var_0_1.bless_great_hammer_headshots = {
	display_completion_ui = true,
	name = "achv_bless_great_hammer_headshots_name",
	desc = "achv_bless_great_hammer_headshots_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_great_hammer_headshots",
	required_dlc = "bless",
	events = {
		"on_hit"
	},
	progress = function (arg_30_0, arg_30_1, arg_30_2)
		local var_30_0 = arg_30_0:get_persistent_stat(arg_30_1, "bless_great_hammer_headshots")

		return {
			var_30_0,
			var_0_40
		}
	end,
	completed = function (arg_31_0, arg_31_1, arg_31_2)
		return arg_31_0:get_persistent_stat(arg_31_1, "bless_great_hammer_headshots") >= var_0_40
	end,
	on_event = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
		local var_32_0 = arg_32_4[var_0_26]
		local var_32_1 = Managers.player:local_player()
		local var_32_2 = var_32_1 and var_32_1.player_unit

		if not ALIVE[var_32_0] or not var_32_2 or var_32_2 ~= var_32_0 then
			return
		end

		if arg_32_4[var_0_21] ~= "head" then
			return
		end

		if arg_32_4[var_0_20] ~= "heavy_attack" then
			return
		end

		local var_32_3 = ScriptUnit.has_extension(var_32_0, "career_system")

		if not var_32_3 or var_32_3:career_name() ~= "wh_priest" then
			return
		end

		local var_32_4 = ScriptUnit.has_extension(var_32_0, "inventory_system")

		if var_32_4 then
			local var_32_5 = var_32_4:get_wielded_slot_data()
			local var_32_6 = var_32_5 and var_32_5.item_data

			if var_32_6 and var_32_6.name == "wh_2h_hammer" then
				arg_32_0:increment_stat(arg_32_1, "bless_great_hammer_headshots")
			end
		end
	end
}

local var_0_41 = {
	skaven_ratling_gunner = 8,
	skaven_poison_wind_globadier = 2,
	chaos_corruptor_sorcerer = 32,
	chaos_vortex_sorcerer = 64,
	skaven_pack_master = 4,
	skaven_warpfire_thrower = 16,
	beastmen_standard_bearer = 128,
	skaven_gutter_runner = 1
}
local var_0_42 = 8
local var_0_43 = 255

var_0_1.bless_kill_specials_hammer_book = {
	display_completion_ui = true,
	name = "achv_bless_kill_specials_hammer_book_name",
	desc = "achv_bless_kill_specials_hammer_book_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_kill_specials_hammer_book",
	required_dlc = "bless",
	events = {
		"register_kill"
	},
	progress = function (arg_33_0, arg_33_1, arg_33_2)
		local var_33_0 = 0
		local var_33_1 = arg_33_0:get_persistent_stat(arg_33_1, "bless_kill_specials_hammer_book")

		for iter_33_0, iter_33_1 in pairs(var_0_41) do
			if bit.band(var_33_1, iter_33_1) == iter_33_1 then
				var_33_0 = var_33_0 + 1
			end
		end

		return {
			var_33_0,
			var_0_42
		}
	end,
	completed = function (arg_34_0, arg_34_1, arg_34_2)
		return arg_34_0:get_persistent_stat(arg_34_1, "bless_kill_specials_hammer_book") >= var_0_43
	end,
	requirements = function (arg_35_0, arg_35_1)
		local var_35_0 = {}
		local var_35_1 = 0
		local var_35_2 = arg_35_0:get_persistent_stat(arg_35_1, "bless_kill_specials_hammer_book")

		for iter_35_0, iter_35_1 in pairs(var_0_41) do
			local var_35_3 = bit.band(var_35_2, iter_35_1) == iter_35_1

			var_35_1 = var_35_1 + 1
			var_35_0[var_35_1] = {
				name = iter_35_0,
				completed = var_35_3
			}
		end

		return var_35_0
	end,
	on_event = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4)
		local var_36_0 = Managers.player:local_player()
		local var_36_1 = var_36_0 and var_36_0.player_unit
		local var_36_2 = arg_36_4[var_0_17]
		local var_36_3 = var_36_2[DamageDataIndex.ATTACKER]

		if var_36_3 and var_36_1 ~= var_36_3 then
			return
		end

		local var_36_4 = arg_36_4[var_0_18]

		if not var_36_4 then
			return
		end

		local var_36_5 = var_0_41[var_36_4.name]

		if not var_36_5 then
			return
		end

		local var_36_6 = var_36_2[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_36_7 = rawget(ItemMasterList, var_36_6)

		if not var_36_7 or var_36_7.item_type ~= "wh_hammer_book" then
			return
		end

		local var_36_8 = ScriptUnit.has_extension(var_36_3, "career_system")

		if not var_36_8 or var_36_8:career_name() ~= "wh_priest" then
			return
		end

		local var_36_9 = ScriptUnit.has_extension(var_36_3, "inventory_system")

		if not var_36_9 then
			return
		end

		local var_36_10, var_36_11, var_36_12 = CharacterStateHelper.get_item_data_and_weapon_extensions(var_36_9)
		local var_36_13 = CharacterStateHelper.get_current_action_data(var_36_12, var_36_11)
		local var_36_14 = var_36_13 and var_36_13.lookup_data.sub_action_name

		if var_36_14 ~= "heavy_attack_stab_charged" and var_36_14 ~= "heavy_attack_left_charged" then
			return
		end

		local var_36_15 = arg_36_0:get_persistent_stat(arg_36_1, "bless_kill_specials_hammer_book")

		if bit.band(var_36_15, var_36_5) == 0 then
			local var_36_16 = bit.bor(var_36_15, var_36_5)

			arg_36_0:set_stat(arg_36_1, "bless_kill_specials_hammer_book", var_36_16)
		end
	end
}
var_0_1.bless_mighty_blow = {
	display_completion_ui = true,
	name = "achv_bless_mighty_blow_name",
	desc = "achv_bless_mighty_blow_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_mighty_blow",
	required_dlc = "bless",
	events = {
		"register_kill"
	},
	completed = function (arg_37_0, arg_37_1, arg_37_2)
		return arg_37_0:get_persistent_stat(arg_37_1, "bless_mighty_blow") >= 1
	end,
	on_event = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
		local var_38_0 = arg_38_4[var_0_18]

		if not var_38_0 or var_38_0.name ~= "chaos_exalted_champion_warcamp" then
			return
		end

		local var_38_1 = arg_38_4[var_0_17]
		local var_38_2 = var_38_1 and var_38_1[DamageDataIndex.ATTACKER]

		if not ALIVE[var_38_2] then
			return
		end

		local var_38_3 = Managers.player:local_player()
		local var_38_4 = var_38_3 and var_38_3.player_unit

		if not var_38_4 or var_38_4 ~= var_38_2 then
			return
		end

		local var_38_5 = var_38_1 and var_38_1[DamageDataIndex.DAMAGE_TYPE]
		local var_38_6 = var_38_1[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_38_7 = rawget(ItemMasterList, var_38_6)

		if not (var_38_7 and var_38_7.item_type == "wh_2h_hammer" and var_38_5 == "stab_smiter") then
			return
		end

		local var_38_8 = ScriptUnit.has_extension(var_38_2, "career_system")

		if not var_38_8 or var_38_8:career_name() ~= "wh_priest" then
			return
		end

		arg_38_0:increment_stat(arg_38_1, "bless_mighty_blow")
	end
}

local var_0_44 = 800

var_0_1.bless_block_attacks = {
	always_run = true,
	name = "achv_bless_block_attacks_name",
	display_completion_ui = true,
	desc = "achv_bless_block_attacks_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_block_attacks",
	required_dlc = "bless",
	events = {
		"register_damage_resisted_immune"
	},
	progress = function (arg_39_0, arg_39_1, arg_39_2)
		local var_39_0 = arg_39_0:get_persistent_stat(arg_39_1, "bless_block_attacks")

		return {
			var_39_0,
			var_0_44
		}
	end,
	completed = function (arg_40_0, arg_40_1, arg_40_2)
		return arg_40_0:get_persistent_stat(arg_40_1, "bless_block_attacks") >= var_0_44
	end,
	on_event = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
		local var_41_0 = arg_41_4[1]
		local var_41_1 = arg_41_4[2]
		local var_41_2 = arg_41_4[3]

		if not ALIVE[var_41_1] or not ALIVE[var_41_0] then
			return
		end

		if var_41_0 == var_41_1 then
			return
		end

		if var_41_2 == "buff" or var_41_2 == "push" then
			return
		end

		local var_41_3 = ScriptUnit.has_extension(var_41_0, "buff_system")

		if not var_41_3 then
			return
		end

		local var_41_4 = var_41_3:get_buff_type("victor_priest_activated_ability_invincibility")

		if not var_41_4 then
			return
		end

		local var_41_5 = var_41_4.attacker_unit

		if ALIVE[var_41_5] then
			var_0_3(var_41_5, "bless_block_attacks")
		end
	end
}

local var_0_45 = 800

var_0_1.bless_righteous_stagger = {
	always_run = true,
	name = "achv_bless_righteous_stagger_name",
	display_completion_ui = true,
	desc = "achv_bless_righteous_stagger_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_righteous_stagger",
	required_dlc = "bless",
	events = {
		"register_ai_stagger"
	},
	progress = function (arg_42_0, arg_42_1, arg_42_2)
		local var_42_0 = arg_42_0:get_persistent_stat(arg_42_1, "bless_righteous_stagger")

		return {
			var_42_0,
			var_0_45
		}
	end,
	completed = function (arg_43_0, arg_43_1, arg_43_2)
		return arg_43_0:get_persistent_stat(arg_43_1, "bless_righteous_stagger") >= var_0_45
	end,
	on_event = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
		if not Managers.state.network.is_server then
			return
		end

		local var_44_0 = arg_44_4[1]
		local var_44_1 = arg_44_4[2]

		if not ALIVE[var_44_1] or not ALIVE[var_44_0] then
			return
		end

		local var_44_2 = ScriptUnit.has_extension(var_44_1, "career_system")

		if not var_44_2 or var_44_2:career_name() ~= "wh_priest" then
			return
		end

		local var_44_3 = var_44_2:get_passive_ability(1)

		if var_44_3 and var_44_3:is_active() then
			var_0_3(var_44_1, "bless_righteous_stagger")
		end
	end
}

local var_0_46 = 60
local var_0_47 = 0.2

var_0_1.bless_charged_hammer = {
	display_completion_ui = true,
	name = "achv_bless_charged_hammer_name",
	desc = "achv_bless_charged_hammer_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_charged_hammer",
	required_dlc = "bless",
	events = {
		"register_damage"
	},
	completed = function (arg_45_0, arg_45_1, arg_45_2)
		return arg_45_0:get_persistent_stat(arg_45_1, "bless_charged_hammer") >= 1
	end,
	on_event = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
		local var_46_0 = Managers.player:local_player()
		local var_46_1 = var_46_0 and var_46_0.player_unit
		local var_46_2 = arg_46_4[var_0_12]
		local var_46_3 = var_46_2[DamageDataIndex.ATTACKER]

		if var_46_3 and var_46_1 ~= var_46_3 then
			return
		end

		local var_46_4 = var_46_2[DamageDataIndex.DAMAGE_SOURCE_NAME]
		local var_46_5 = rawget(ItemMasterList, var_46_4)

		if not var_46_5 or var_46_5.item_type ~= "wh_hammer_book" then
			return
		end

		local var_46_6 = ScriptUnit.has_extension(var_46_3, "career_system")

		if not var_46_6 or var_46_6:career_name() ~= "wh_priest" then
			return
		end

		local var_46_7 = ScriptUnit.has_extension(var_46_3, "inventory_system")

		if not var_46_7 then
			return
		end

		local var_46_8, var_46_9, var_46_10 = CharacterStateHelper.get_item_data_and_weapon_extensions(var_46_7)
		local var_46_11 = CharacterStateHelper.get_current_action_data(var_46_10, var_46_9)
		local var_46_12 = var_46_11 and var_46_11.lookup_data.sub_action_name

		if var_46_12 ~= "heavy_attack_stab_charged" and var_46_12 ~= "heavy_attack_left_charged" then
			return
		end

		local var_46_13 = Managers.time:time("game")

		if not arg_46_2.first_hit_t or var_46_13 > arg_46_2.first_hit_t + var_0_47 then
			arg_46_2.first_hit_t = var_46_13
			arg_46_2.hit_count = 0
			arg_46_2.victim_units = {}
		end

		local var_46_14 = arg_46_4[var_0_11]

		if var_46_13 <= arg_46_2.first_hit_t + var_0_47 and not arg_46_2.victim_units[var_46_14] then
			arg_46_2.hit_count = arg_46_2.hit_count + 1
			arg_46_2.victim_units[var_46_14] = true

			if arg_46_2.hit_count >= var_0_46 then
				arg_46_0:increment_stat(arg_46_1, "bless_charged_hammer")
			end
		end
	end
}

local var_0_48 = 50

var_0_1.bless_protected_killing = {
	display_completion_ui = true,
	name = "achv_bless_protected_killing_name",
	desc = "achv_bless_protected_killing_desc",
	required_career = "wh_priest",
	icon = "achievement_trophy_bless_protected_killing",
	required_dlc = "bless",
	events = {
		"register_kill"
	},
	completed = function (arg_47_0, arg_47_1, arg_47_2)
		return arg_47_0:get_persistent_stat(arg_47_1, "bless_protected_killing") >= 1
	end,
	on_event = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
		local var_48_0 = Managers.player:local_player()
		local var_48_1 = var_48_0 and var_48_0.player_unit
		local var_48_2 = ScriptUnit.has_extension(var_48_1, "career_system")

		if not var_48_2 or var_48_2:career_name() ~= "wh_priest" then
			return
		end

		local var_48_3 = arg_48_4[var_0_17]
		local var_48_4 = var_48_3[DamageDataIndex.ATTACKER]
		local var_48_5 = var_48_3[DamageDataIndex.ATTACK_TYPE]

		if var_48_5 ~= "light_attack" and var_48_5 ~= "heavy_attack" then
			return
		end

		local var_48_6 = ScriptUnit.has_extension(var_48_4, "buff_system")

		if var_48_6 then
			local var_48_7 = var_48_6:get_buff_type("victor_priest_activated_ability_invincibility")

			if var_48_7 then
				var_48_7._bless_protected_killing_count = (var_48_7._bless_protected_killing_count or 0) + 1

				if var_48_7._bless_protected_killing_count >= var_0_48 then
					arg_48_0:increment_stat(arg_48_1, "bless_protected_killing")
				end
			end
		end
	end
}

local var_0_49 = {
	"bless_complete_all_helmgart_levels_wh_priest",
	"bless_complete_25_missions_wh_priest",
	"bless_saved_by_perk",
	"bless_book_run",
	"bless_heal_allies",
	"bless_fast_shield",
	"bless_unbreakable_damage_block",
	"bless_punch_back",
	"bless_cluch_revive",
	"bless_ranged_raki",
	"bless_chaos_warriors",
	"bless_very_righteous",
	"bless_smite_enemies",
	"bless_great_hammer_headshots",
	"bless_kill_specials_hammer_book",
	"bless_mighty_blow",
	"bless_block_attacks",
	"bless_righteous_stagger",
	"bless_charged_hammer",
	"bless_protected_killing"
}

var_0_7(var_0_1, "complete_all_warrior_priest_challenges", var_0_49, "achievement_trophy_complete_all_warrior_priest_challenges", "bless", nil, nil)
