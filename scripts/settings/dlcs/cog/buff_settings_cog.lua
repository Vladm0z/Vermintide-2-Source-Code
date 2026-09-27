-- chunkname: @scripts/settings/dlcs/cog/buff_settings_cog.lua

require("scripts/settings/profiles/career_constants")

local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local cog = DLCSettings.cog

cog.buff_templates = {
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.exhausted
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
cog.proc_functions = {
	add_debuff_on_drakefire_hit = function (arg_1_0, arg_1_1, arg_1_2)
		-- function 1
		if not Managers.state.network.is_server then
			return
		end

		local var_1_0 = arg_1_2[1]

		if not ALIVE[arg_1_0] and not ALIVE[var_1_0] then
			local get_wielded_slot_item_template = ScriptUnit.extension(arg_1_0, "inventory_system"):get_wielded_slot_item_template()

			if not (not get_wielded_slot_item_template and get_wielded_slot_item_template.weapon_type ~= "DRAKEFIRE") then
				local system = Managers.state.entity:system("buff_system")
				local buff_to_add = arg_1_1.template.buff_to_add

				system:add_buff(var_1_0, buff_to_add, arg_1_0, false)
			end
		end
	end,
	bardin_engineer_piston_power_add = function (arg_2_0, arg_2_1, arg_2_2)
		-- function 2
		if not ALIVE[arg_2_0] then
			if arg_2_2[2] ~= "heavy_attack" then
				return
			end

			local template = arg_2_1.template
			local buff_to_add = template.buff_to_add
			local buff_to_remove = template.buff_to_remove
			local buff_to_check = template.buff_to_check
			local extension = ScriptUnit.extension(arg_2_0, "buff_system")

			if not extension:has_buff_type(buff_to_remove) then
				local get_non_stacking_buff = extension:get_non_stacking_buff(buff_to_remove)

				if not get_non_stacking_buff then
					extension:remove_buff(get_non_stacking_buff.id)
				end

				Managers.state.entity:system("buff_system"):add_buff(arg_2_0, buff_to_add, arg_2_0, false)
				extension:add_buff(buff_to_check)
				ScriptUnit.extension(arg_2_0, "status_system"):remove_all_fatigue()
			end
		end
	end,
	bardin_engineer_piston_power_sound = function (arg_3_0, arg_3_1, arg_3_2)
		-- function 3
		if not ALIVE[arg_3_0] then
			local charge_value = arg_3_2[1].charge_value

			if not (not charge_value and charge_value ~= "heavy_attack") then
				ScriptUnit.extension(arg_3_0, "first_person_system"):play_hud_sound_event("talent_power_swing")
			end
		end
	end,
	bardin_engineer_power_on_next_range = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		if not ALIVE[arg_4_0] then
			local var_4_0 = arg_4_2[1]

			if not var_4_0 and not var_4_0.ranged_attack then
				local system = Managers.state.entity:system("buff_system")
				local buff_to_add = arg_4_1.template.buff_to_add

				system:add_buff(arg_4_0, buff_to_add, arg_4_0, false)
				ScriptUnit.extension(arg_4_0, "buff_system"):remove_buff(arg_4_1.id)
			end
		end
	end
}
cog.buff_function_templates = {
	bardin_engineer_animation_slow_down_add = function (arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		if not ALIVE[arg_5_0] then
			local has_extension = ScriptUnit.has_extension(arg_5_0, "first_person_system")

			if not has_extension then
				local get_first_person_unit = has_extension:get_first_person_unit()

				Unit.animation_event(get_first_person_unit, "cooldown_locked")

				local get_wielded_slot_data = ScriptUnit.extension(arg_5_0, "inventory_system"):get_wielded_slot_data()

				if get_wielded_slot_data.id == "slot_career_skill_weapon" then
					local right_unit_1p = get_wielded_slot_data.right_unit_1p
					local left_unit_1p = get_wielded_slot_data.left_unit_1p
					local has_extension_2 = ScriptUnit.has_extension(right_unit_1p, "weapon_system")
					local has_extension_3 = ScriptUnit.has_extension(left_unit_1p, "weapon_system")

					;(has_extension_2 or has_extension_3):stop_action("action_complete")
				end
			end
		end
	end,
	bardin_engineer_animation_slow_down_remove = function (arg_6_0, arg_6_1, arg_6_2)
		-- function 6
		if not ALIVE[arg_6_0] then
			local has_extension = ScriptUnit.has_extension(arg_6_0, "first_person_system")

			if not has_extension then
				has_extension:animation_set_variable("crank_speed", 1)
			end
		end
	end,
	bardin_engineer_piston_power_add_apply = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		local var_7_0 = arg_7_0

		if not ALIVE[var_7_0] then
			local buff_to_remove = arg_7_1.template.buff_to_remove

			ScriptUnit.extension(var_7_0, "buff_system"):add_buff(buff_to_remove)
		end
	end,
	bardin_engineer_bomb_grant = function (arg_8_0, arg_8_1, arg_8_2)
		-- function 8
		local network_transmit = Managers.state.network.network_transmit
		local extension = ScriptUnit.extension(arg_8_0, "inventory_system")
		local time = Managers.time:time("game")
		local str = "slot_grenade"
		local get_slot_data = extension:get_slot_data(str)
		local can_store_additional_item = extension:can_store_additional_item(str)

		if not (not get_slot_data and can_store_additional_item) then
			arg_8_1.is_full = true

			return time
		elseif not arg_8_1.is_full then
			arg_8_1.is_full = false

			local has_extension = ScriptUnit.has_extension(arg_8_0, "buff_system")

			if not has_extension then
				has_extension:add_buff(arg_8_1.template.cooldown_buff)
			end

			return time + arg_8_1.template.update_frequency
		end

		local has_extension_2 = ScriptUnit.has_extension(arg_8_0, "buff_system")

		if not has_extension_2 then
			has_extension_2:add_buff(arg_8_1.template.cooldown_buff)
		end

		local flag = true
		local engineer_grenade_t1 = AllPickups.engineer_grenade_t1
		local fire_grenade_t1 = AllPickups.fire_grenade_t1

		if fire_grenade_t1.slot_name ~= str then
			fire_grenade_t1 = engineer_grenade_t1
		end

		if engineer_grenade_t1.slot_name ~= str then
			if engineer_grenade_t1 == fire_grenade_t1 then
				return
			end

			engineer_grenade_t1 = fire_grenade_t1
		end

		local item_name = (not flag and engineer_grenade_t1 and fire_grenade_t1).item_name
		local var_8_12 = ItemMasterList[item_name]
		local owner = Managers.player:owner(arg_8_0)

		if not (not owner and owner.remote) then
			if not get_slot_data then
				local tbl = {}

				extension:add_equipment(str, var_8_12, nil, tbl)

				local go_id = Managers.state.unit_storage:go_id(arg_8_0)
				local var_8_16 = NetworkLookup.equipment_slots[str]
				local var_8_17 = NetworkLookup.item_names[item_name]
				local var_8_18 = NetworkLookup.weapon_skins["n/a"]

				if not go_id then
					if not Managers.state.network.is_server then
						network_transmit:send_rpc_clients("rpc_add_equipment", go_id, var_8_16, var_8_17, var_8_18)
					else
						network_transmit:send_rpc_server("rpc_add_equipment", go_id, var_8_16, var_8_17, var_8_18)
					end
				end
			elseif not can_store_additional_item then
				extension:store_additional_item(str, var_8_12)
			end
		end
	end,
	bardin_engineer_overclock_damage = function (arg_9_0, arg_9_1, arg_9_2)
		-- function 9
		local has_extension = ScriptUnit.has_extension(arg_9_0, "career_system")

		if not has_extension then
			local cooldown_amount = arg_9_1.template.cooldown_amount

			has_extension:reduce_activated_ability_cooldown_percent(cooldown_amount)
		end

		local extension = ScriptUnit.extension(arg_9_0, "buff_system")
		local name = arg_9_1.template.name
		local num_buff_stacks = extension:num_buff_stacks(name)
		local clamp = math.clamp(num_buff_stacks * arg_9_1.template.health_to_lose_per_stack, 0, arg_9_1.template.max_health_loss)

		DamageUtils.add_damage_network(arg_9_0, arg_9_0, clamp, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_9_0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
	end
}
