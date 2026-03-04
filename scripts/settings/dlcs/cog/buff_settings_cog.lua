-- chunkname: @scripts/settings/dlcs/cog/buff_settings_cog.lua

require("scripts/settings/profiles/career_constants")

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local var_0_1 = DLCSettings.cog

var_0_1.buff_templates = {
	bardin_engineer_pump_max_overheat_check = {
		buffs = {
			{
				duration = 2,
				name = "bardin_engineer_pump_max_overheat_check",
				on_max_stacks_overflow_func = "add_remove_buffs",
				max_stacks = 1,
				refresh_durations = true,
				max_stack_data = {
					talent_buffs = {
						bardin_engineer_overclock = {
							buffs_to_add = {
								{
									name = "bardin_engineer_pump_overclock_buff"
								}
							},
							buffs_to_add_if_missing = {
								{
									name = "bardin_engineer_pump_max_exhaustion_buff"
								}
							}
						}
					}
				}
			}
		}
	},
	bardin_engineer_pump_max_exhaustion_buff = {
		buffs = {
			{
				duration = 5,
				name = "bardin_engineer_pump_max_exhaustion_buff",
				priority_buff = true,
				remove_buff_func = "bardin_engineer_animation_slow_down_remove",
				apply_buff_func = "bardin_engineer_animation_slow_down_add",
				debuff = true,
				max_stacks = 1,
				icon = "bardin_engineer_pump_max_exhaustion_buff_icon",
				perks = {
					var_0_0.exhausted
				}
			}
		}
	},
	bardin_engineer_pump_overclock_buff = {
		buffs = {
			{
				name = "bardin_engineer_pump_overclock_buff",
				stat_buff = "critical_strike_chance",
				apply_buff_func = "bardin_engineer_overclock_damage",
				on_max_stacks_overflow_func = "reapply_buff",
				refresh_durations = true,
				priority_buff = true,
				max_health_loss = 10,
				duration = 12,
				max_stacks = 3,
				icon = "bardin_engineer_4_2",
				health_to_lose_per_stack = 4,
				bonus = CareerConstants.dr_engineer.talent_4_2_crit,
				cooldown_amount = CareerConstants.dr_engineer.talent_4_2_cooldown
			}
		}
	}
}
var_0_1.proc_functions = {
	add_debuff_on_drakefire_hit = function(arg_1_0, arg_1_1, arg_1_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_1_0 = arg_1_2[1]

		if ALIVE[arg_1_0] and ALIVE[var_1_0] then
			local var_1_1 = ScriptUnit.extension(arg_1_0, "inventory_system"):get_wielded_slot_item_template()

			if var_1_1 and var_1_1.weapon_type == "DRAKEFIRE" then
				local var_1_2 = Managers.state.entity:system("buff_system")
				local var_1_3 = arg_1_1.template.buff_to_add

				var_1_2:add_buff(var_1_0, var_1_3, arg_1_0, false)
			end
		end
	end,
	bardin_engineer_piston_power_add = function(arg_2_0, arg_2_1, arg_2_2)
		if ALIVE[arg_2_0] then
			if arg_2_2[2] ~= "heavy_attack" then
				return
			end

			local var_2_0 = arg_2_1.template
			local var_2_1 = var_2_0.buff_to_add
			local var_2_2 = var_2_0.buff_to_remove
			local var_2_3 = var_2_0.buff_to_check
			local var_2_4 = ScriptUnit.extension(arg_2_0, "buff_system")

			if var_2_4:has_buff_type(var_2_2) then
				local var_2_5 = var_2_4:get_non_stacking_buff(var_2_2)

				if var_2_5 then
					var_2_4:remove_buff(var_2_5.id)
				end

				Managers.state.entity:system("buff_system"):add_buff(arg_2_0, var_2_1, arg_2_0, false)
				var_2_4:add_buff(var_2_3)
				ScriptUnit.extension(arg_2_0, "status_system"):remove_all_fatigue()
			end
		end
	end,
	bardin_engineer_piston_power_sound = function(arg_3_0, arg_3_1, arg_3_2)
		if ALIVE[arg_3_0] then
			local var_3_0 = arg_3_2[1].charge_value

			if var_3_0 and var_3_0 == "heavy_attack" then
				ScriptUnit.extension(arg_3_0, "first_person_system"):play_hud_sound_event("talent_power_swing")
			end
		end
	end,
	bardin_engineer_power_on_next_range = function(arg_4_0, arg_4_1, arg_4_2)
		if ALIVE[arg_4_0] then
			local var_4_0 = arg_4_2[1]

			if var_4_0 and var_4_0.ranged_attack then
				local var_4_1 = Managers.state.entity:system("buff_system")
				local var_4_2 = arg_4_1.template.buff_to_add

				var_4_1:add_buff(arg_4_0, var_4_2, arg_4_0, false)
				ScriptUnit.extension(arg_4_0, "buff_system"):remove_buff(arg_4_1.id)
			end
		end
	end
}
var_0_1.buff_function_templates = {
	bardin_engineer_animation_slow_down_add = function(arg_5_0, arg_5_1, arg_5_2)
		if ALIVE[arg_5_0] then
			local var_5_0 = ScriptUnit.has_extension(arg_5_0, "first_person_system")

			if var_5_0 then
				local var_5_1 = var_5_0:get_first_person_unit()

				Unit.animation_event(var_5_1, "cooldown_locked")

				local var_5_2 = ScriptUnit.extension(arg_5_0, "inventory_system"):get_wielded_slot_data()

				if var_5_2.id == "slot_career_skill_weapon" then
					local var_5_3 = var_5_2.right_unit_1p
					local var_5_4 = var_5_2.left_unit_1p
					local var_5_5 = ScriptUnit.has_extension(var_5_3, "weapon_system")
					local var_5_6 = ScriptUnit.has_extension(var_5_4, "weapon_system")

					;(var_5_5 or var_5_6):stop_action("action_complete")
				end
			end
		end
	end,
	bardin_engineer_animation_slow_down_remove = function(arg_6_0, arg_6_1, arg_6_2)
		if ALIVE[arg_6_0] then
			local var_6_0 = ScriptUnit.has_extension(arg_6_0, "first_person_system")

			if var_6_0 then
				var_6_0:animation_set_variable("crank_speed", 1)
			end
		end
	end,
	bardin_engineer_piston_power_add_apply = function(arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = arg_7_0

		if ALIVE[var_7_0] then
			local var_7_1 = arg_7_1.template.buff_to_remove

			ScriptUnit.extension(var_7_0, "buff_system"):add_buff(var_7_1)
		end
	end,
	bardin_engineer_bomb_grant = function(arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = Managers.state.network.network_transmit
		local var_8_1 = ScriptUnit.extension(arg_8_0, "inventory_system")
		local var_8_2 = Managers.time:time("game")
		local var_8_3 = "slot_grenade"
		local var_8_4 = var_8_1:get_slot_data(var_8_3)
		local var_8_5 = var_8_1:can_store_additional_item(var_8_3)

		if var_8_4 and not var_8_5 then
			arg_8_1.is_full = true

			return var_8_2
		elseif arg_8_1.is_full then
			arg_8_1.is_full = false

			local var_8_6 = ScriptUnit.has_extension(arg_8_0, "buff_system")

			if var_8_6 then
				var_8_6:add_buff(arg_8_1.template.cooldown_buff)
			end

			return var_8_2 + arg_8_1.template.update_frequency
		end

		local var_8_7 = ScriptUnit.has_extension(arg_8_0, "buff_system")

		if var_8_7 then
			var_8_7:add_buff(arg_8_1.template.cooldown_buff)
		end

		local var_8_8 = true
		local var_8_9 = AllPickups.engineer_grenade_t1
		local var_8_10 = AllPickups.fire_grenade_t1

		if var_8_10.slot_name ~= var_8_3 then
			var_8_10 = var_8_9
		end

		if var_8_9.slot_name ~= var_8_3 then
			if var_8_9 == var_8_10 then
				return
			end

			var_8_9 = var_8_10
		end

		local var_8_11 = (var_8_8 and var_8_9 or var_8_10).item_name
		local var_8_12 = ItemMasterList[var_8_11]
		local var_8_13 = Managers.player:owner(arg_8_0)

		if var_8_13 and not var_8_13.remote then
			if not var_8_4 then
				local var_8_14 = {}

				var_8_1:add_equipment(var_8_3, var_8_12, nil, var_8_14)

				local var_8_15 = Managers.state.unit_storage:go_id(arg_8_0)
				local var_8_16 = NetworkLookup.equipment_slots[var_8_3]
				local var_8_17 = NetworkLookup.item_names[var_8_11]
				local var_8_18 = NetworkLookup.weapon_skins["n/a"]

				if var_8_15 then
					if Managers.state.network.is_server then
						var_8_0:send_rpc_clients("rpc_add_equipment", var_8_15, var_8_16, var_8_17, var_8_18)
					else
						var_8_0:send_rpc_server("rpc_add_equipment", var_8_15, var_8_16, var_8_17, var_8_18)
					end
				end
			elseif var_8_5 then
				var_8_1:store_additional_item(var_8_3, var_8_12)
			end
		end
	end,
	bardin_engineer_overclock_damage = function(arg_9_0, arg_9_1, arg_9_2)
		local var_9_0 = ScriptUnit.has_extension(arg_9_0, "career_system")

		if var_9_0 then
			local var_9_1 = arg_9_1.template.cooldown_amount

			var_9_0:reduce_activated_ability_cooldown_percent(var_9_1)
		end

		local var_9_2 = ScriptUnit.extension(arg_9_0, "buff_system")
		local var_9_3 = arg_9_1.template.name
		local var_9_4 = var_9_2:num_buff_stacks(var_9_3)
		local var_9_5 = math.clamp(var_9_4 * arg_9_1.template.health_to_lose_per_stack, 0, arg_9_1.template.max_health_loss)

		DamageUtils.add_damage_network(arg_9_0, arg_9_0, var_9_5, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_9_0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
	end
}
