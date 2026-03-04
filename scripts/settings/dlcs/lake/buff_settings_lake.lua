-- chunkname: @scripts/settings/dlcs/lake/buff_settings_lake.lua

local var_0_0 = DLCSettings.lake
local var_0_1 = {}

var_0_0.buff_templates = {
	markus_questing_knight_passive_cooldown_reduction = {
		buffs = {
			{
				name = "markus_questing_knight_passive_cooldown_reduction",
				multiplier = 0.1,
				stat_buff = "cooldown_regen",
				refresh_durations = true,
				max_stacks = 1,
				icon = "markus_questing_knight_buff_cdr",
				priority_buff = true
			}
		}
	},
	markus_questing_knight_passive_cooldown_reduction_improved = {
		buffs = {
			{
				name = "markus_questing_knight_passive_cooldown_reduction_improved",
				multiplier = 0.15,
				stat_buff = "cooldown_regen",
				refresh_durations = true,
				max_stacks = 1,
				icon = "markus_questing_knight_buff_cdr"
			}
		}
	},
	markus_questing_knight_passive_cooldown_reduction_vs = {
		buffs = {
			{
				name = "markus_questing_knight_passive_cooldown_reduction_vs",
				multiplier = 0.15,
				stat_buff = "cooldown_regen",
				refresh_durations = true,
				max_stacks = 1,
				icon = "markus_questing_knight_buff_cdr",
				priority_buff = true
			}
		}
	},
	markus_questing_knight_passive_attack_speed = {
		buffs = {
			{
				name = "markus_questing_knight_passive_attack_speed",
				multiplier = 0.05,
				stat_buff = "attack_speed",
				refresh_durations = true,
				max_stacks = 1,
				icon = "markus_questing_knight_buff_attackspeed"
			}
		}
	},
	markus_questing_knight_passive_attack_speed_improved = {
		buffs = {
			{
				name = "markus_questing_knight_passive_attack_speed_improved",
				multiplier = 0.075,
				stat_buff = "attack_speed",
				refresh_durations = true,
				max_stacks = 1,
				icon = "markus_questing_knight_buff_attackspeed",
				priority_buff = true
			}
		}
	},
	markus_questing_knight_passive_attack_speed_vs = {
		buffs = {
			{
				name = "markus_questing_knight_passive_attack_speed_vs",
				multiplier = 0.075,
				stat_buff = "attack_speed",
				refresh_durations = true,
				max_stacks = 1,
				icon = "markus_questing_knight_buff_attackspeed"
			}
		}
	},
	markus_questing_knight_passive_power_level = {
		buffs = {
			{
				name = "markus_questing_knight_passive_power_level",
				multiplier = 0.1,
				stat_buff = "power_level",
				refresh_durations = true,
				max_stacks = 1,
				icon = "markus_questing_knight_buff_powerlevel",
				priority_buff = true
			}
		}
	},
	markus_questing_knight_passive_power_level_improved = {
		buffs = {
			{
				name = "markus_questing_knight_passive_power_level_improved",
				multiplier = 0.15,
				stat_buff = "power_level",
				refresh_durations = true,
				max_stacks = 1,
				icon = "markus_questing_knight_buff_powerlevel"
			}
		}
	},
	markus_questing_knight_passive_power_level_vs = {
		buffs = {
			{
				name = "markus_questing_knight_passive_power_level_vs",
				multiplier = 0.15,
				stat_buff = "power_level",
				refresh_durations = true,
				max_stacks = 1,
				icon = "markus_questing_knight_buff_powerlevel",
				priority_buff = true
			}
		}
	},
	markus_questing_knight_passive_damage_taken = {
		buffs = {
			{
				name = "markus_questing_knight_passive_damage_taken",
				multiplier = -0.1,
				stat_buff = "damage_taken",
				refresh_durations = true,
				max_stacks = 1,
				icon = "markus_questing_knight_buff_damage_taken",
				priority_buff = true
			}
		}
	},
	markus_questing_knight_passive_damage_taken_improved = {
		buffs = {
			{
				name = "markus_questing_knight_passive_damage_taken_improved",
				multiplier = -0.15,
				stat_buff = "damage_taken",
				refresh_durations = true,
				max_stacks = 1,
				icon = "markus_questing_knight_buff_damage_taken"
			}
		}
	},
	markus_questing_knight_passive_damage_taken_vs = {
		buffs = {
			{
				name = "markus_questing_knight_passive_damage_taken_vs",
				multiplier = -0.15,
				stat_buff = "damage_taken",
				refresh_durations = true,
				max_stacks = 1,
				icon = "markus_questing_knight_buff_damage_taken",
				priority_buff = true
			}
		}
	},
	markus_questing_knight_passive_health_regen = {
		buffs = {
			{
				heal = 1,
				heal_type = "career_passive",
				name = "markus_questing_knight_passive_health_regen",
				icon = "markus_questing_knight_buff_health_regen",
				time_between_heal = 5,
				priority_buff = true,
				apply_buff_func = "health_regen_start",
				max_stacks = 1,
				update_func = "health_regen_update"
			}
		}
	},
	markus_questing_knight_passive_health_regen_improved = {
		buffs = {
			{
				icon = "markus_questing_knight_buff_health_regen",
				name = "markus_questing_knight_passive_health_regen_improved",
				heal = 1,
				max_stacks = 1,
				time_between_heal = 2.5,
				update_func = "health_regen_update",
				apply_buff_func = "health_regen_start",
				heal_type = "career_passive"
			}
		}
	},
	markus_questing_knight_passive_health_regen_vs = {
		buffs = {
			{
				heal = 1,
				heal_type = "career_passive",
				name = "markus_questing_knight_passive_health_regen_vs",
				icon = "markus_questing_knight_buff_health_regen",
				time_between_heal = 2.5,
				priority_buff = true,
				apply_buff_func = "health_regen_start",
				max_stacks = 1,
				update_func = "health_regen_update"
			}
		}
	}
}
var_0_0.proc_functions = {
	markus_questing_knight_spread_temp_health = function(arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = arg_1_2[1]
		local var_1_1 = arg_1_2[3]
		local var_1_2 = var_1_0 == arg_1_0
		local var_1_3 = var_1_1 == "heal_from_proc"

		if ALIVE[arg_1_0] and Managers.player.is_server and var_1_2 and var_1_3 then
			local var_1_4 = arg_1_1.template
			local var_1_5 = var_1_4.range
			local var_1_6 = var_1_5 * var_1_5
			local var_1_7 = POSITION_LOOKUP[var_1_0]
			local var_1_8 = Managers.state.side.side_by_unit[arg_1_0].PLAYER_AND_BOT_UNITS
			local var_1_9
			local var_1_10 = 500

			for iter_1_0 = 1, #var_1_8 do
				local var_1_11 = var_1_8[iter_1_0]

				if var_1_11 ~= var_1_0 and Unit.alive(var_1_11) then
					local var_1_12 = POSITION_LOOKUP[var_1_11]
					local var_1_13 = Vector3.distance_squared(var_1_7, var_1_12)

					if var_1_13 < var_1_6 and var_1_13 < var_1_10 then
						var_1_9 = var_1_11
						var_1_10 = var_1_13
					end
				end
			end

			if var_1_9 then
				local var_1_14 = var_1_9
				local var_1_15 = arg_1_2[2] * var_1_4.multiplier
				local var_1_16 = "heal_from_proc"

				DamageUtils.heal_network(var_1_14, arg_1_0, var_1_15, var_1_16)
			end
		end
	end,
	add_heal_percent_of_damage_taken_over_time_buff = function(arg_2_0, arg_2_1, arg_2_2)
		if Unit.alive(arg_2_0) then
			local var_2_0 = arg_2_2[1]
			local var_2_1 = arg_2_2[2]
			local var_2_2 = AiUtils.unit_breed(var_2_0)

			if var_2_2 and not var_2_2.is_hero then
				local var_2_3 = ScriptUnit.has_extension(arg_2_0, "health_system")

				if var_2_3 and var_2_1 < var_2_3:current_health() then
					local var_2_4 = ScriptUnit.has_extension(arg_2_0, "buff_system")
					local var_2_5 = arg_2_1.template
					local var_2_6 = var_2_5.heal_amount_fraction * var_2_1
					local var_2_7 = var_2_5.buff_to_add

					table.clear(var_0_1)

					var_0_1.external_optional_bonus = var_2_6

					var_2_4:add_buff(var_2_7, var_0_1)
				end
			end
		end
	end,
	check_for_instantly_killing_crit = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		if not Managers.player.is_server then
			return
		end

		local var_3_0 = arg_3_2[arg_3_4.attacked_unit]
		local var_3_1 = arg_3_2[arg_3_4.damage_amount]
		local var_3_2 = arg_3_2[arg_3_4.is_critical_strike]
		local var_3_3 = arg_3_2[arg_3_4.PROC_MODIFIABLE]

		if var_3_2 and ALIVE[arg_3_0] and ALIVE[var_3_0] then
			local var_3_4 = ScriptUnit.extension(var_3_0, "health_system")
			local var_3_5 = arg_3_1.template
			local var_3_6 = Unit.get_data(var_3_0, "breed")
			local var_3_7 = var_3_6 and var_3_6.boss
			local var_3_8 = var_3_5.damage_multiplier

			if var_3_7 then
				var_3_8 = var_3_5.boss_damage_multiplier
			end

			local var_3_9 = var_3_1 * var_3_8
			local var_3_10 = var_3_5.proc_chance
			local var_3_11 = var_3_4:current_health()

			if var_3_11 <= var_3_9 and var_3_10 > math.random() then
				var_3_3.damage_amount = var_3_11
			end
		end
	end,
	markus_questing_knight_boss_kill_func = function(arg_4_0, arg_4_1, arg_4_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_4_0] then
			local var_4_0 = ScriptUnit.extension(arg_4_0, "talent_system"):has_talent("markus_questing_knight_passive_longer_duration", "empire_soldier", true)
			local var_4_1
			local var_4_2 = var_4_0 and "markus_questing_knight_passive_boss_kill_buff_increased_duration" or "markus_questing_knight_passive_boss_kill_buff"
			local var_4_3 = ScriptUnit.extension(arg_4_0, "buff_system")

			var_4_3:add_buff(var_4_2)

			local var_4_4 = var_4_3:get_non_stacking_buff("markus_questing_knight_passive_boss_kill")

			if var_4_4 then
				var_4_3:remove_buff(var_4_4.id)
			end
		end
	end,
	markus_questing_knight_ability_kill_buff_func = function(arg_5_0, arg_5_1, arg_5_2)
		if ALIVE[arg_5_0] then
			local var_5_0 = arg_5_2[1]
			local var_5_1 = var_5_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

			if var_5_0 and var_5_1 == "markus_questingknight_career_skill_weapon" then
				local var_5_2 = ScriptUnit.extension(arg_5_0, "buff_system")
				local var_5_3 = arg_5_1.template.buff_to_add

				if var_5_2 then
					var_5_2:add_buff(var_5_3)
				end
			end
		end
	end
}
var_0_0.buff_function_templates = {
	update_markus_questing_knight_passive_aura = function(arg_6_0, arg_6_1, arg_6_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_6_0 = arg_6_1.range
		local var_6_1 = var_6_0 * var_6_0
		local var_6_2 = POSITION_LOOKUP[arg_6_0]
		local var_6_3 = Managers.state.entity:system("buff_system")
		local var_6_4 = Managers.state.side.side_by_unit[arg_6_0].PLAYER_AND_BOT_UNITS
		local var_6_5 = #var_6_4
		local var_6_6 = ScriptUnit.extension(arg_6_0, "talent_system")
		local var_6_7 = var_6_6:has_talent("markus_questing_knight_passive_longer_duration", "empire_soldier", true)
		local var_6_8 = var_6_6:has_talent("markus_questing_knight_passive_tanking_improved", "empire_soldier", true)
		local var_6_9 = ScriptUnit.extension(arg_6_0, "buff_system")
		local var_6_10 = {
			{
				buff_to_add = "markus_questing_knight_boss_aura_party",
				apply_to_party = true,
				apply_to_self = false,
				apply = var_6_9:has_buff_perk("boss_aura")
			},
			{
				buff_to_add = "markus_questing_knight_specials_aura_party",
				apply_to_party = true,
				apply_to_self = false,
				apply = var_6_9:has_buff_perk("specials_aura")
			},
			{
				buff_to_add = "markus_questing_knight_elites_aura_party",
				apply_to_party = true,
				apply_to_self = false,
				apply = var_6_9:has_buff_perk("elites_aura")
			},
			{
				buff_to_add = "markus_questing_knight_super_aura_party",
				apply_to_party = true,
				apply_to_self = true,
				apply = var_6_7 and var_6_9:has_buff_perk("boss_aura") and var_6_9:has_buff_perk("specials_aura") and var_6_9:has_buff_perk("elites_aura")
			},
			{
				buff_to_add = "markus_questing_knight_passive_tank_buff",
				apply_to_party = false,
				apply_to_self = true,
				apply = var_6_8 and (var_6_9:has_buff_perk("boss_aura") or var_6_9:has_buff_perk("specials_aura") or var_6_9:has_buff_perk("elites_aura"))
			}
		}
		local var_6_11 = #var_6_10

		for iter_6_0 = 1, var_6_5 do
			local var_6_12 = var_6_4[iter_6_0]

			if Unit.alive(var_6_12) then
				for iter_6_1 = 1, var_6_11 do
					local var_6_13 = var_6_10[iter_6_1]
					local var_6_14 = var_6_13.apply and (var_6_12 == arg_6_0 and var_6_13.apply_to_self or var_6_12 ~= arg_6_0 and var_6_13.apply_to_party)
					local var_6_15 = var_6_13.buff_to_add
					local var_6_16 = POSITION_LOOKUP[var_6_12]
					local var_6_17 = Vector3.distance_squared(var_6_2, var_6_16)
					local var_6_18 = ScriptUnit.extension(var_6_12, "buff_system")

					if var_6_1 < var_6_17 or not var_6_14 then
						local var_6_19 = var_6_18:get_non_stacking_buff(var_6_15)

						if var_6_19 then
							local var_6_20 = var_6_19.server_id

							if var_6_20 then
								var_6_3:remove_server_controlled_buff(var_6_12, var_6_20)
							end
						end
					end

					if var_6_17 < var_6_1 and var_6_14 and not var_6_18:has_buff_type(var_6_15) then
						local var_6_21 = var_6_3:add_buff(var_6_12, var_6_15, arg_6_0, true)
						local var_6_22 = var_6_18:get_non_stacking_buff(var_6_15)

						if var_6_22 then
							var_6_22.server_id = var_6_21
						end
					end
				end
			end
		end

		if Unit.alive(arg_6_0) then
			if not var_6_6:has_talent("markus_questing_knight_passive_convert_to_avatar_buff", "empire_soldier", true) then
				return
			end

			local var_6_23 = ScriptUnit.extension(arg_6_0, "buff_system")

			if var_6_23:has_buff_perk("boss_aura") and var_6_23:has_buff_perk("specials_aura") and var_6_23:has_buff_perk("elites_aura") then
				local var_6_24 = var_6_23:get_non_stacking_buff("markus_questing_knight_passive_boss_kill_buff")
				local var_6_25 = var_6_23:get_non_stacking_buff("markus_questing_knight_passive_special_kill_buff")
				local var_6_26 = var_6_23:get_non_stacking_buff("markus_questing_knight_passive_elite_kill_buff")

				var_6_23:remove_buff(var_6_24.id)
				var_6_23:remove_buff(var_6_25.id)
				var_6_23:remove_buff(var_6_26.id)
				var_6_23:add_buff("markus_questing_knight_passive_avatar_buff_crit")
				var_6_23:add_buff("markus_questing_knight_passive_avatar_buff_attack_speed")
			end
		end
	end,
	refund_damage_taken = function(arg_7_0, arg_7_1, arg_7_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_7_0] then
			local var_7_0 = arg_7_1.bonus

			DamageUtils.heal_network(arg_7_0, arg_7_0, var_7_0, "heal_from_proc")
		end
	end
}
