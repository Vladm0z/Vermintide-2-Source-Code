-- chunkname: @scripts/settings/dlcs/woods/buff_settings_woods.lua

local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local woods = DLCSettings.woods
local tbl = {}
local num = 0.2
local num_2 = 0.5

woods.buff_templates = {
	weapon_bleed_dot_javelin = {
		buffs = {
			{
				duration = 4,
				name = "weapon bleed dot javelin",
				max_stacks = 1,
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.5,
				time_between_dot_damages = 0.5,
				hit_zone = "neck",
				damage_profile = "bleed_maidenguard",
				update_func = "apply_dot_damage",
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.bleeding
				}
			}
		}
	},
	thorn_sister_big_bleed = {
		buffs = {
			{
				duration = 5,
				name = "thorn sister big bleed",
				max_stacks = 3,
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.75,
				time_between_dot_damages = 0.75,
				hit_zone = "neck",
				damage_profile = "bleed",
				update_func = "apply_dot_damage",
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.bleeding
				}
			}
		}
	},
	thorn_sister_passive_poison = {
		buffs = {
			{
				duration = 10,
				name = "thorn sister passive poison",
				stat_buff = "damage_taken",
				multiplier = 0.12,
				max_stacks = 1,
				remove_buff_func = "kerillian_thorn_sister_remove_buff_from_attacker",
				apply_buff_func = "start_dot_damage_kerillian",
				update_start_delay = 0.8,
				refresh_durations = true,
				time_between_dot_damages = 0.8,
				hit_zone = "neck",
				damage_profile = "thorn_sister_poison",
				update_func = "apply_dot_damage",
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.poisoned
				},
				mechanism_overrides = {
					versus = {
						damage_profile = "thorn_sister_poison_vs"
					}
				}
			}
		}
	},
	thorn_sister_passive_poison_improved = {
		buffs = {
			{
				duration = 10,
				name = "thorn sister passive poison improved",
				stat_buff = "damage_taken",
				multiplier = 0.12,
				max_stacks = 2,
				remove_buff_func = "kerillian_thorn_sister_remove_buff_from_attacker",
				apply_buff_func = "start_dot_damage_kerillian",
				update_start_delay = 0.8,
				refresh_durations = true,
				time_between_dot_damages = 0.8,
				hit_zone = "neck",
				damage_profile = "thorn_sister_poison",
				update_func = "apply_dot_damage",
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.poisoned
				}
			}
		}
	},
	thorn_sister_wall_bleed = {
		buffs = {
			{
				duration = 10,
				name = "thorn_sister_wall_bleed",
				max_stacks = 1,
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				update_start_delay = 0.25,
				time_between_dot_damages = 0.25,
				hit_zone = "neck",
				damage_profile = "bleed",
				update_func = "apply_dot_damage",
				perks = {
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.bleeding
				}
			}
		}
	},
	thorn_sister_wall_slow = {
		buffs = {
			{
				remove_buff_func = "remove_movement_buff",
				name = "decrease_speed_thorn_sister_wall",
				refresh_durations = true,
				apply_buff_func = "apply_movement_buff",
				lerp_time = 0.1,
				max_stacks = 1,
				multiplier = num_2,
				path_to_movement_setting_to_modify = {
					"move_speed"
				},
				duration = num
			},
			{
				apply_buff_func = "apply_action_lerp_movement_buff",
				name = "decrease_crouch_speed_thorn_sister_wall",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = num_2,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				},
				duration = num
			},
			{
				apply_buff_func = "apply_action_lerp_movement_buff",
				name = "decrease_walk_speed_thorn_sister_wall",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = num_2,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				},
				duration = num
			},
			{
				name = "decrease_jump_speed_thorn_sister_wall",
				refresh_durations = true,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				multiplier = num_2,
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				},
				duration = num
			}
		}
	},
	kerillian_thorn_passive_team_buff = {
		buffs = {
			{
				name = "kerillian_thorn_passive_team_buff",
				multiplier = 0.15,
				stat_buff = "power_level",
				max_stacks = 1,
				icon = "kerillian_thornsister_avatar"
			},
			{
				max_stacks = 1,
				name = "kerillian_thorn_passive_team_buff_2",
				stat_buff = "critical_strike_chance",
				bonus = 0.05
			}
		}
	},
	kerillian_thorn_sister_drain_poison_phasing_buff = {
		buffs = {
			{
				refresh_durations = true,
				name = "kerillian_thorn_sister_poison_phasing",
				duration = 5,
				remove_buff_func = "kerillian_thorn_sister_noclip_off",
				max_stacks = 1,
				icon = "kerillian_thornsister_big_push",
				apply_buff_func = "kerillian_thorn_sister_noclip_on"
			},
			{
				refresh_durations = true,
				name = "kerillian_thorn_sister_poison_movespeed",
				remove_buff_func = "remove_movement_buff",
				max_stacks = 1,
				duration = 5,
				apply_buff_func = "apply_movement_buff",
				multiplier = 1.2,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			}
		}
	}
}
woods.proc_functions = {
	kerillian_thorn_sister_health_conversion = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		-- function 1
		if not ALIVE[arg_1_0] then
			local has_extension = ScriptUnit.has_extension(arg_1_0, "health_system")

			if not has_extension then
				return
			end

			local current_temporary_health = has_extension:current_temporary_health()
			local amount_to_convert = arg_1_1.template.amount_to_convert
			local num = has_extension:get_max_health() * amount_to_convert

			if current_temporary_health < num then
				num = current_temporary_health
			end

			local var_1_4 = POSITION_LOOKUP[arg_1_0]

			if not Managers.state.network.is_server then
				DamageUtils.heal_network(arg_1_0, arg_1_0, num, "health_conversion")
			else
				local network = Managers.state.network
				local unit_game_object_id = network:unit_game_object_id(arg_1_0)
				local health_conversion = NetworkLookup.heal_types.health_conversion

				network.network_transmit:send_rpc_server("rpc_request_heal", unit_game_object_id, num, health_conversion)
			end

			if num > 0 then
				World.create_particles(arg_1_3, "fx/thornsister_buff", var_1_4, Quaternion.identity())
				World.create_particles(arg_1_3, "fx/thornsister_buff_screenspace", Vector3(0, 0, 0))
			end
		end
	end,
	kerillian_thorn_sister_set_back = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local var_2_0 = arg_2_2[1]

		if not ALIVE[arg_2_0] and not ALIVE[var_2_0] then
			if Managers.state.side.side_by_unit[arg_2_0] == Managers.state.side.side_by_unit[var_2_0] then
				return
			end

			local extension = ScriptUnit.extension(arg_2_0, "buff_system")

			if not extension:has_buff_type("kerillian_thorn_sister_passive_set_back_cooldown") then
				ScriptUnit.extension(arg_2_0, "career_system"):modify_extra_ability_charge(arg_2_1.template.amount)
				extension:add_buff("kerillian_thorn_sister_passive_set_back_cooldown")
			end
		end
	end,
	thorn_sister_transfer_temp_health_at_full = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		local var_3_0 = arg_3_2[3]
		local var_3_1 = arg_3_2[1]
		local attacker_unit = arg_3_1.attacker_unit

		if not (not ALIVE[attacker_unit] and attacker_unit ~= arg_3_0) then
			return
		end

		local flag = var_3_1 == arg_3_0
		local extension = ScriptUnit.extension(arg_3_0, "status_system")

		if not (not flag and extension:is_permanent_heal(var_3_0) or ScriptUnit.extension(arg_3_0, "health_system"):current_health_percent() ~= 1) then
			local num = arg_3_2[2] * arg_3_1.template.multiplier

			if not ScriptUnit.has_extension(attacker_unit, "status_system"):is_knocked_down() then
				local has_extension = ScriptUnit.has_extension(attacker_unit, "health_system")
				local flag_2 = not has_extension and has_extension:current_health_percent()

				if not (not flag_2 and not (flag_2 < 1)) then
					DamageUtils.heal_network(attacker_unit, arg_3_0, num, "heal_from_proc")
				end
			end
		end
	end,
	add_buff_reff_buff_stack = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		local var_4_0 = arg_4_2[1]

		if not (not ALIVE[arg_4_0] and var_4_0 ~= arg_4_0) then
			local template = arg_4_1.template
			local buff_to_add = template.buff_to_add
			local amount_to_add = template.amount_to_add
			local extension = ScriptUnit.extension(arg_4_0, "buff_system")

			for i = 1, amount_to_add do
				extension:add_buff(buff_to_add)
			end
		end
	end,
	remove_ref_buff_stack_woods = function (arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		if not ALIVE[arg_5_0] then
			local buff_to_remove = arg_5_1.template.buff_to_remove
			local extension = ScriptUnit.extension(arg_5_0, "buff_system")
			local get_stacking_buff = extension:get_stacking_buff(buff_to_remove)

			if not get_stacking_buff then
				local count = #get_stacking_buff

				if count > 0 then
					local id = get_stacking_buff[count].id

					extension:remove_buff(id)
				end
			end
		end
	end,
	thorn_sister_add_bleed_on_hit = function (arg_6_0, arg_6_1, arg_6_2)
		-- function 6
		local var_6_0 = arg_6_2[1]

		if not ALIVE[arg_6_0] and not ALIVE[var_6_0] then
			local bleed = arg_6_1.template.bleed
			local system = Managers.state.entity:system("buff_system")
			local get_career_power_level = ScriptUnit.extension(arg_6_0, "career_system"):get_career_power_level()
			local has_extension = ScriptUnit.has_extension(var_6_0, "buff_system")

			if not (not has_extension and has_extension:has_buff_perk(scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.poisoned)) then
				return false
			end

			table.clear(tbl)

			tbl.power_level = get_career_power_level
			tbl.attacker_unit = arg_6_0

			system:add_buff_synced(var_6_0, bleed, BuffSyncType.LocalAndServer, tbl)
		end
	end,
	kerillian_thorn_sister_crit_aoe_poison_func = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		if not Managers.state.network.is_server then
			return
		end

		local var_7_0 = arg_7_2[4]

		if not (not ALIVE[arg_7_0] and not (var_7_0 <= 1)) then
			local system = Managers.state.entity:system("area_damage_system")
			local get_career_power_level = ScriptUnit.extension(arg_7_0, "career_system"):get_career_power_level()
			local var_7_3 = arg_7_2[1]
			local var_7_4 = POSITION_LOOKUP[var_7_3]
			local str = "buff"
			local str_2 = "kerillian_thorn_sister_talent_poison_aoe"
			local has_extension = ScriptUnit.has_extension(arg_7_0, "talent_system")

			if not has_extension and not has_extension:has_talent("kerillian_thorn_sister_double_poison") then
				str_2 = "kerillian_thorn_sister_talent_poison_aoe_improved"
			end

			local identity = Quaternion.identity()
			local num = 1
			local flag = false

			system:create_explosion(arg_7_0, var_7_4, identity, str_2, num, str, get_career_power_level, flag)
		end
	end,
	thorn_sister_add_melee_poison = function (arg_8_0, arg_8_1, arg_8_2)
		-- function 8
		local var_8_0 = arg_8_2[1]

		if not ALIVE[arg_8_0] and not HEALTH_ALIVE[var_8_0] then
			local var_8_1 = arg_8_2[2]

			if not (not var_8_1 and var_8_1 == "light_attack" and var_8_1 == "heavy_attack") then
				return
			end

			local template = arg_8_1.template
			local poison = template.poison
			local has_extension = ScriptUnit.has_extension(arg_8_0, "talent_system")

			if not has_extension and not has_extension:has_talent("kerillian_thorn_sister_double_poison") then
				poison = template.improved_poison
			end

			local system = Managers.state.entity:system("buff_system")
			local get_career_power_level = ScriptUnit.extension(arg_8_0, "career_system"):get_career_power_level()

			if not ScriptUnit.has_extension(var_8_0, "buff_system") then
				return false
			end

			table.clear(tbl)

			tbl.power_level = get_career_power_level
			tbl.attacker_unit = arg_8_0

			system:add_buff_synced(var_8_0, poison, BuffSyncType.LocalAndServer, tbl)
		end
	end,
	thorn_sister_big_push = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		-- function 9
		if not (not ALIVE[arg_9_0] and arg_9_2[1].kind ~= "push_stagger" or ScriptUnit.has_extension(arg_9_0, "status_system"):current_fatigue_points() ~= 0) then
			local extension = ScriptUnit.extension(arg_9_0, "buff_system")
			local template = arg_9_1.template
			local buff_to_add = template.buff_to_add

			extension:add_buff(buff_to_add)

			local buff_to_add_2 = template.buff_to_add_2

			Managers.state.entity:system("buff_system"):add_buff(arg_9_0, buff_to_add_2, arg_9_0, false)

			local var_9_4 = POSITION_LOOKUP[arg_9_0]

			World.create_particles(arg_9_3, "fx/thornsister_push", var_9_4, Quaternion.identity())
		end
	end,
	kerillian_thorn_sister_add_buff_remove = function (arg_10_0, arg_10_1, arg_10_2)
		-- function 10
		if not ALIVE[arg_10_0] then
			local buff_to_add = arg_10_1.template.buff_to_add

			Managers.state.entity:system("buff_system"):add_buff(arg_10_0, buff_to_add, arg_10_0, false)
			ScriptUnit.extension(arg_10_0, "buff_system"):remove_buff(arg_10_1.id)
		end
	end,
	kerillian_thorn_sister_restore_health_on_ranged_hit = function (arg_11_0, arg_11_1, arg_11_2)
		-- function 11
		local var_11_0 = arg_11_2[7]

		if not (not ALIVE[arg_11_0] and not var_11_0 and var_11_0 == "projectile" or var_11_0 == "instant_projectile" or var_11_0 ~= "heavy_instant_projectile") then
			if not Managers.state.network.is_server then
				local amount_to_heal = arg_11_1.template.amount_to_heal

				DamageUtils.heal_network(arg_11_0, arg_11_0, amount_to_heal, "career_passive")
			end

			ScriptUnit.extension(arg_11_0, "buff_system"):remove_buff(arg_11_1.id)
		end
	end,
	kerillian_thorn_sister_wall_buff_enemies = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		-- function 12
		local attacker_unit = arg_12_1.attacker_unit
		local var_12_1 = arg_12_2[arg_12_4.target_number]

		if not (not ALIVE[arg_12_0] and not ALIVE[attacker_unit] and var_12_1 ~= 1) then
			local var_12_2 = POSITION_LOOKUP[attacker_unit]
			local template = arg_12_1.template
			local radius = template.radius
			local buff_to_add = template.buff_to_add
			local alloc_table = FrameTable.alloc_table()
			local enemy_broadphase = Managers.state.entity:system("proximity_system").enemy_broadphase

			Broadphase.query(enemy_broadphase, var_12_2, radius, alloc_table)

			local side = Managers.state.side
			local system = Managers.state.entity:system("buff_system")

			for k, v in pairs(alloc_table) do
				if not ALIVE[v] and not side:is_enemy(arg_12_0, v) then
					system:add_buff(v, buff_to_add, arg_12_0)
				end
			end
		end
	end,
	add_buff_on_proc_thorn = function (arg_13_0, arg_13_1, arg_13_2)
		-- function 13
		if not ALIVE[arg_13_0] then
			local system = Managers.state.entity:system("buff_system")
			local buff_to_add = arg_13_1.template.buff_to_add

			system:add_buff(arg_13_0, buff_to_add, arg_13_0, false)
		end
	end,
	kerillian_thorn_sister_reduce_passive_on_elite = function (arg_14_0, arg_14_1, arg_14_2)
		-- function 14
		if not ALIVE[arg_14_0] then
			local extension = ScriptUnit.extension(arg_14_0, "career_system")
			local time_removed_per_kill = arg_14_1.template.time_removed_per_kill

			time_removed_per_kill = time_removed_per_kill or 0

			extension:modify_extra_ability_charge(time_removed_per_kill)
		end
	end,
	kerillian_thorn_sister_team_buff_on_passive = function (arg_15_0, arg_15_1, arg_15_2)
		-- function 15
		if not ALIVE[arg_15_0] then
			local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_15_0].PLAYER_AND_BOT_UNITS
			local count = #PLAYER_AND_BOT_UNITS
			local num = 40
			local template = arg_15_1.template
			local var_15_4 = POSITION_LOOKUP[arg_15_0]
			local num_2 = num * num
			local system = Managers.state.entity:system("buff_system")

			for i = 1, count do
				local var_15_7 = PLAYER_AND_BOT_UNITS[i]
				local var_15_8 = POSITION_LOOKUP[var_15_7]

				if num_2 > Vector3.distance_squared(var_15_4, var_15_8) then
					local buff_to_add_1 = template.buff_to_add_1

					system:add_buff(var_15_7, buff_to_add_1, arg_15_0, false)
				end
			end
		end
	end
}
woods.buff_function_templates = {
	kerillian_thorn_sister_healing_wall_buff_counter_remove = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		if not ALIVE[arg_16_0] then
			local extension = ScriptUnit.extension(arg_16_0, "buff_system")

			if extension:num_buff_type(arg_16_1.buff_type) == 1 then
				local buffs_to_add = arg_16_1.template.add_buffs_data.buffs_to_add

				for i = 1, #buffs_to_add do
					local get_buff_type = extension:get_buff_type(buffs_to_add[i])

					if not get_buff_type then
						get_buff_type.duration = 0
						get_buff_type.aborted = 0
					end
				end
			end
		end
	end,
	start_dot_damage_kerillian = function (arg_17_0, arg_17_1, arg_17_2)
		-- function 17
		local attacker_unit = arg_17_1.attacker_unit

		if not ALIVE[attacker_unit] then
			local has_extension = ScriptUnit.has_extension(attacker_unit, "talent_system")

			if not has_extension and not has_extension:has_talent("kerillian_thorn_sister_phasing") then
				local has_extension_2 = ScriptUnit.has_extension(attacker_unit, "buff_system")

				if not has_extension_2 then
					return
				end

				arg_17_1.added_id = has_extension_2:add_buff("kerillian_thorn_sister_drain_poison_phasing_tracker")

				if has_extension_2:num_buff_type("kerillian_thorn_sister_drain_poison_phasing_tracker") >= 5 then
					has_extension_2:add_buff("kerillian_thorn_sister_drain_poison_phasing_buff")
				end
			end
		end
	end,
	activate_stacking_buff_on_distance = function (arg_18_0, arg_18_1, arg_18_2)
		-- function 18
		if not Managers.state.network.is_server then
			return
		end

		local template = arg_18_1.template
		local range = arg_18_1.range
		local num = range * range
		local var_18_3 = POSITION_LOOKUP[arg_18_0]
		local buff_to_add = template.buff_to_add
		local system = Managers.state.entity:system("buff_system")
		local PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_18_0].PLAYER_AND_BOT_UNITS
		local count = #PLAYER_AND_BOT_UNITS

		for i = 1, count do
			local var_18_8 = PLAYER_AND_BOT_UNITS[i]
			local buff_instances = arg_18_1.buff_instances

			buff_instances = not buff_instances and arg_18_1.buff_instances[var_18_8]

			if not ALIVE[var_18_8] then
				local var_18_10 = POSITION_LOOKUP[var_18_8]
				local distance_squared = Vector3.distance_squared(var_18_3, var_18_10)

				if not (buff_instances or not (distance_squared <= num)) then
					local add_buff = system:add_buff(var_18_8, buff_to_add, arg_18_0, true)

					if not arg_18_1.buff_instances then
						arg_18_1.buff_instances[var_18_8] = add_buff
					else
						arg_18_1.buff_instances = {
							[var_18_8] = add_buff
						}
					end
				elseif not (not buff_instances and not (num < distance_squared)) then
					system:remove_server_controlled_buff(var_18_8, buff_instances)

					arg_18_1.buff_instances[var_18_8] = nil
				end
			elseif not buff_instances then
				arg_18_1.buff_instances[var_18_8] = nil
			end
		end
	end,
	remove_aura_stacking_buff = function (arg_19_0, arg_19_1, arg_19_2)
		-- function 19
		if not Managers.state.network.is_server then
			return
		end

		local buff_instances = arg_19_1.buff_instances

		if not buff_instances then
			local system = Managers.state.entity:system("buff_system")

			for k, v in pairs(buff_instances) do
				if not ALIVE[k] then
					system:remove_server_controlled_buff(k, v)
				end
			end
		end
	end,
	kerillian_thorn_sister_passive_health_convert = function (arg_20_0, arg_20_1, arg_20_2)
		-- function 20
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_20_0] then
			local extension = ScriptUnit.extension(arg_20_0, "buff_system")
			local has_extension = ScriptUnit.has_extension(arg_20_0, "health_system")
			local template = arg_20_1.template
			local thp_to_lose = template.thp_to_lose
			local flag = not has_extension and thp_to_lose < has_extension:current_temporary_health()

			if not extension:has_buff_type("kerillian_thorn_sister_free_ability_stack") and not flag then
				local hp_to_gain = template.hp_to_gain

				DamageUtils.heal_network(arg_20_0, arg_20_0, hp_to_gain, "career_passive")

				if thp_to_lose - hp_to_gain > 0 then
					DamageUtils.add_damage_network(arg_20_0, arg_20_0, thp_to_lose - hp_to_gain, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_20_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
				end
			end
		end
	end,
	kerillian_thorn_sister_add_buff_to_attacker = function (arg_21_0, arg_21_1, arg_21_2)
		-- function 21
		if not ALIVE[arg_21_0] then
			local buff_to_add = arg_21_1.template.buff_to_add
			local attacker_unit = arg_21_1.attacker_unit
			local has_extension = ScriptUnit.has_extension(attacker_unit, "buff_system")

			if not has_extension then
				arg_21_1.added_id = has_extension:add_buff(buff_to_add)
			end
		end
	end,
	kerillian_thorn_sister_remove_buff_from_attacker = function (arg_22_0, arg_22_1, arg_22_2)
		-- function 22
		if not arg_22_1.added_id then
			local attacker_unit = arg_22_1.attacker_unit
			local has_extension = ScriptUnit.has_extension(attacker_unit, "buff_system")

			if not has_extension then
				has_extension:remove_buff(arg_22_1.added_id)
			end
		end
	end,
	buff_system_add_buff = function (arg_23_0, arg_23_1, arg_23_2)
		-- function 23
		if not ALIVE[arg_23_0] then
			local buff_to_add = arg_23_1.template.buff_to_add

			Managers.state.entity:system("buff_system"):add_buff(arg_23_0, buff_to_add, arg_23_0, false)
		end
	end,
	kerillian_thorn_sister_noclip_on = function (arg_24_0, arg_24_1, arg_24_2)
		-- function 24
		if not ALIVE[arg_24_0] then
			local has_extension = ScriptUnit.has_extension(arg_24_0, "status_system")

			if not has_extension then
				has_extension:set_noclip(true, "thorn_sister_phasing")
			end
		end
	end,
	kerillian_thorn_sister_noclip_off = function (arg_25_0, arg_25_1, arg_25_2)
		-- function 25
		if not ALIVE[arg_25_0] then
			local has_extension = ScriptUnit.has_extension(arg_25_0, "status_system")

			if not has_extension then
				has_extension:set_noclip(false, "thorn_sister_phasing")
			end
		end
	end
}
woods.stacking_buff_functions = {
	kerillian_thorn_sister_avatar = function (arg_26_0, arg_26_1)
		-- function 26
		if not ALIVE[arg_26_0] then
			local max_stack_data = arg_26_1.max_stack_data

			if not max_stack_data then
				local buffs_to_add = max_stack_data.buffs_to_add
				local system = Managers.state.entity:system("buff_system")

				for i = 1, #buffs_to_add do
					local var_26_3 = buffs_to_add[i]

					system:add_buff(arg_26_0, var_26_3, arg_26_0, false)
				end
			end
		end
	end
}
