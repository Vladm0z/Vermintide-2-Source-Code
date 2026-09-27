-- chunkname: @scripts/settings/dlcs/lake/buff_settings_lake.lua

local lake = DLCSettings.lake
local tbl = {}

lake.buff_templates = {
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
lake.proc_functions = {
	markus_questing_knight_spread_temp_health = function (arg_1_0, arg_1_1, arg_1_2)
		-- function 1
		local var_1_0 = arg_1_2[1]
		local var_1_1 = arg_1_2[3]
		local flag = var_1_0 == arg_1_0
		local flag_2 = var_1_1 == "heal_from_proc"

		if not ALIVE[arg_1_0] and not Managers.player.is_server and not flag and not flag_2 then
			local template = arg_1_1.template
			local range = template.range
			local num = range * range
			local var_1_7 = POSITION_LOOKUP[var_1_0]
			local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_1_0].PLAYER_AND_BOT_UNITS
			local var_1_9
			local num_2 = 500

			for i = 1, #PLAYER_AND_BOT_UNITS do
				local var_1_11 = PLAYER_AND_BOT_UNITS[i]

				if var_1_11 == var_1_0 or not Unit.alive(var_1_11) then
					local var_1_12 = POSITION_LOOKUP[var_1_11]
					local distance_squared = Vector3.distance_squared(var_1_7, var_1_12)

					if not (not (distance_squared < num) or not (distance_squared < num_2)) then
						var_1_9 = var_1_11
						num_2 = distance_squared
					end
				end
			end

			if not var_1_9 then
				local var_1_14 = var_1_9
				local num_3 = arg_1_2[2] * template.multiplier
				local str = "heal_from_proc"

				DamageUtils.heal_network(var_1_14, arg_1_0, num_3, str)
			end
		end
	end,
	add_heal_percent_of_damage_taken_over_time_buff = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		if not Unit.alive(arg_2_0) then
			local var_2_0 = arg_2_2[1]
			local var_2_1 = arg_2_2[2]
			local unit_breed = AiUtils.unit_breed(var_2_0)

			if not (not unit_breed and unit_breed.is_hero) then
				local has_extension = ScriptUnit.has_extension(arg_2_0, "health_system")

				if not (not has_extension and not (var_2_1 < has_extension:current_health())) then
					local has_extension_2 = ScriptUnit.has_extension(arg_2_0, "buff_system")
					local template = arg_2_1.template
					local num = template.heal_amount_fraction * var_2_1
					local buff_to_add = template.buff_to_add

					table.clear(tbl)

					tbl.external_optional_bonus = num

					has_extension_2:add_buff(buff_to_add, tbl)
				end
			end
		end
	end,
	check_for_instantly_killing_crit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
		-- function 3
		if not Managers.player.is_server then
			return
		end

		local var_3_0 = arg_3_2[arg_3_4.attacked_unit]
		local var_3_1 = arg_3_2[arg_3_4.damage_amount]
		local var_3_2 = arg_3_2[arg_3_4.is_critical_strike]
		local var_3_3 = arg_3_2[arg_3_4.PROC_MODIFIABLE]

		if not var_3_2 and not ALIVE[arg_3_0] and not ALIVE[var_3_0] then
			local extension = ScriptUnit.extension(var_3_0, "health_system")
			local template = arg_3_1.template
			local get_data = Unit.get_data(var_3_0, "breed")
			local flag = not get_data and get_data.boss
			local damage_multiplier = template.damage_multiplier

			if not flag then
				damage_multiplier = template.boss_damage_multiplier
			end

			local num = var_3_1 * damage_multiplier
			local proc_chance = template.proc_chance
			local current_health = extension:current_health()

			if not (current_health <= num) or not (proc_chance > math.random()) then
				var_3_3.damage_amount = current_health
			end
		end
	end,
	markus_questing_knight_boss_kill_func = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_4_0] then
			local has_talent = ScriptUnit.extension(arg_4_0, "talent_system"):has_talent("markus_questing_knight_passive_longer_duration", "empire_soldier", true)
			local var_4_1
			local flag

			flag = not has_talent and "markus_questing_knight_passive_boss_kill_buff_increased_duration" and "markus_questing_knight_passive_boss_kill_buff"

			local extension = ScriptUnit.extension(arg_4_0, "buff_system")

			extension:add_buff(flag)

			local get_non_stacking_buff = extension:get_non_stacking_buff("markus_questing_knight_passive_boss_kill")

			if not get_non_stacking_buff then
				extension:remove_buff(get_non_stacking_buff.id)
			end
		end
	end,
	markus_questing_knight_ability_kill_buff_func = function (arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		if not ALIVE[arg_5_0] then
			local var_5_0 = arg_5_2[1]
			local var_5_1 = var_5_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

			if not (not var_5_0 and var_5_1 ~= "markus_questingknight_career_skill_weapon") then
				local extension = ScriptUnit.extension(arg_5_0, "buff_system")
				local buff_to_add = arg_5_1.template.buff_to_add

				if not extension then
					extension:add_buff(buff_to_add)
				end
			end
		end
	end
}
lake.buff_function_templates = {
	update_markus_questing_knight_passive_aura = function (arg_6_0, arg_6_1, arg_6_2)
		-- function 6
		if not Managers.state.network.is_server then
			return
		end

		local range = arg_6_1.range
		local num = range * range
		local var_6_2 = POSITION_LOOKUP[arg_6_0]
		local system = Managers.state.entity:system("buff_system")
		local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_6_0].PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS
		local extension = ScriptUnit.extension(arg_6_0, "talent_system")
		local has_talent = extension:has_talent("markus_questing_knight_passive_longer_duration", "empire_soldier", true)
		local has_talent_2 = extension:has_talent("markus_questing_knight_passive_tanking_improved", "empire_soldier", true)
		local extension_2 = ScriptUnit.extension(arg_6_0, "buff_system")
		local tbl = {
			{
				buff_to_add = "markus_questing_knight_boss_aura_party",
				apply_to_party = true,
				apply_to_self = false,
				apply = extension_2:has_buff_perk("boss_aura")
			},
			{
				buff_to_add = "markus_questing_knight_specials_aura_party",
				apply_to_party = true,
				apply_to_self = false,
				apply = extension_2:has_buff_perk("specials_aura")
			},
			{
				buff_to_add = "markus_questing_knight_elites_aura_party",
				apply_to_party = true,
				apply_to_self = false,
				apply = extension_2:has_buff_perk("elites_aura")
			}
		}
		local tbl_2 = {
			buff_to_add = "markus_questing_knight_super_aura_party",
			apply_to_party = true,
			apply_to_self = true
		}

		if not has_talent then
			-- Nothing
		end

		::label_6_0::

		local has_buff_perk = extension_2:has_buff_perk("boss_aura")

		if not has_buff_perk then
			has_buff_perk = extension_2:has_buff_perk("specials_aura")
			has_buff_perk = not has_buff_perk and extension_2:has_buff_perk("elites_aura")
		end

		::label_6_1::

		tbl_2.apply = has_buff_perk
		tbl[4] = tbl_2

		local tbl_3 = {
			buff_to_add = "markus_questing_knight_passive_tank_buff",
			apply_to_party = false,
			apply_to_self = true
		}

		if not has_talent_2 then
			-- Nothing
		end

		::label_6_2::

		local has_buff_perk_2 = extension_2:has_buff_perk("boss_aura")

		if not has_buff_perk_2 then
			has_buff_perk_2 = extension_2:has_buff_perk("specials_aura")
			has_buff_perk_2 = has_buff_perk_2 or extension_2:has_buff_perk("elites_aura")
		end

		::label_6_3::

		tbl_3.apply = has_buff_perk_2
		tbl[5] = tbl_3

		local count_2 = #tbl

		for i = 1, count do
			local var_6_16 = PLAYER_AND_BOT_UNITS[i]

			if not Unit.alive(var_6_16) then
				for j = 1, count_2 do
					local var_6_17 = tbl[j]
					local apply = var_6_17.apply

					if not apply then
						if var_6_16 == arg_6_0 then
							apply = var_6_17.apply_to_self

							if not apply then
								-- Nothing
							end
						end

						apply = var_6_16 == arg_6_0 or var_6_17.apply_to_party
					end

					::label_6_4::

					local buff_to_add = var_6_17.buff_to_add
					local var_6_20 = POSITION_LOOKUP[var_6_16]
					local distance_squared = Vector3.distance_squared(var_6_2, var_6_20)
					local extension_3 = ScriptUnit.extension(var_6_16, "buff_system")

					if not (num < distance_squared or apply) then
						local get_non_stacking_buff = extension_3:get_non_stacking_buff(buff_to_add)

						if not get_non_stacking_buff then
							local server_id = get_non_stacking_buff.server_id

							if not server_id then
								system:remove_server_controlled_buff(var_6_16, server_id)
							end
						end
					end

					if not ((not (distance_squared < num) or not apply) and extension_3:has_buff_type(buff_to_add)) then
						local add_buff = system:add_buff(var_6_16, buff_to_add, arg_6_0, true)
						local get_non_stacking_buff_2 = extension_3:get_non_stacking_buff(buff_to_add)

						if not get_non_stacking_buff_2 then
							get_non_stacking_buff_2.server_id = add_buff
						end
					end
				end
			end
		end

		if not Unit.alive(arg_6_0) then
			if not extension:has_talent("markus_questing_knight_passive_convert_to_avatar_buff", "empire_soldier", true) then
				return
			end

			local extension_4 = ScriptUnit.extension(arg_6_0, "buff_system")
			local has_buff_perk_3 = extension_4:has_buff_perk("boss_aura")

			if not has_buff_perk_3 then
				has_buff_perk_3 = extension_4:has_buff_perk("specials_aura")
				has_buff_perk_3 = not has_buff_perk_3 and extension_4:has_buff_perk("elites_aura")
			end

			if not has_buff_perk_3 then
				local get_non_stacking_buff_3 = extension_4:get_non_stacking_buff("markus_questing_knight_passive_boss_kill_buff")
				local get_non_stacking_buff_4 = extension_4:get_non_stacking_buff("markus_questing_knight_passive_special_kill_buff")
				local get_non_stacking_buff_5 = extension_4:get_non_stacking_buff("markus_questing_knight_passive_elite_kill_buff")

				extension_4:remove_buff(get_non_stacking_buff_3.id)
				extension_4:remove_buff(get_non_stacking_buff_4.id)
				extension_4:remove_buff(get_non_stacking_buff_5.id)
				extension_4:add_buff("markus_questing_knight_passive_avatar_buff_crit")
				extension_4:add_buff("markus_questing_knight_passive_avatar_buff_attack_speed")
			end
		end
	end,
	refund_damage_taken = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_7_0] then
			local bonus = arg_7_1.bonus

			DamageUtils.heal_network(arg_7_0, arg_7_0, bonus, "heal_from_proc")
		end
	end
}
