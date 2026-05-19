-- chunkname: @scripts/settings/dlcs/woods/buff_settings_woods.lua

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local var_0_1 = DLCSettings.woods
local var_0_2 = {}
local var_0_3 = 0.2
local var_0_4 = 0.5

var_0_1.buff_templates = {
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
					var_0_0.bleeding
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
					var_0_0.bleeding
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
					var_0_0.poisoned
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
					var_0_0.poisoned
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
					var_0_0.bleeding
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
				multiplier = var_0_4,
				path_to_movement_setting_to_modify = {
					"move_speed"
				},
				duration = var_0_3
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
				multiplier = var_0_4,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				},
				duration = var_0_3
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
				multiplier = var_0_4,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				},
				duration = var_0_3
			},
			{
				name = "decrease_jump_speed_thorn_sister_wall",
				refresh_durations = true,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				multiplier = var_0_4,
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				},
				duration = var_0_3
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
var_0_1.proc_functions = {
	kerillian_thorn_sister_health_conversion = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		if ALIVE[arg_1_0] then
			local var_1_0 = ScriptUnit.has_extension(arg_1_0, "health_system")

			if not var_1_0 then
				return
			end

			local var_1_1 = var_1_0:current_temporary_health()
			local var_1_2 = arg_1_1.template.amount_to_convert
			local var_1_3 = var_1_0:get_max_health() * var_1_2

			if var_1_1 < var_1_3 then
				var_1_3 = var_1_1
			end

			local var_1_4 = POSITION_LOOKUP[arg_1_0]

			if Managers.state.network.is_server then
				DamageUtils.heal_network(arg_1_0, arg_1_0, var_1_3, "health_conversion")
			else
				local var_1_5 = Managers.state.network
				local var_1_6 = var_1_5:unit_game_object_id(arg_1_0)
				local var_1_7 = NetworkLookup.heal_types.health_conversion

				var_1_5.network_transmit:send_rpc_server("rpc_request_heal", var_1_6, var_1_3, var_1_7)
			end

			if var_1_3 > 0 then
				World.create_particles(arg_1_3, "fx/thornsister_buff", var_1_4, Quaternion.identity())
				World.create_particles(arg_1_3, "fx/thornsister_buff_screenspace", Vector3(0, 0, 0))
			end
		end
	end,
	kerillian_thorn_sister_set_back = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = arg_2_2[1]

		if ALIVE[arg_2_0] and ALIVE[var_2_0] then
			if Managers.state.side.side_by_unit[arg_2_0] == Managers.state.side.side_by_unit[var_2_0] then
				return
			end

			local var_2_1 = ScriptUnit.extension(arg_2_0, "buff_system")

			if not var_2_1:has_buff_type("kerillian_thorn_sister_passive_set_back_cooldown") then
				ScriptUnit.extension(arg_2_0, "career_system"):modify_extra_ability_charge(arg_2_1.template.amount)
				var_2_1:add_buff("kerillian_thorn_sister_passive_set_back_cooldown")
			end
		end
	end,
	thorn_sister_transfer_temp_health_at_full = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		local var_3_0 = arg_3_2[3]
		local var_3_1 = arg_3_2[1]
		local var_3_2 = arg_3_1.attacker_unit

		if not ALIVE[var_3_2] or var_3_2 == arg_3_0 then
			return
		end

		local var_3_3 = var_3_1 == arg_3_0
		local var_3_4 = ScriptUnit.extension(arg_3_0, "status_system")

		if var_3_3 and not var_3_4:is_permanent_heal(var_3_0) and ScriptUnit.extension(arg_3_0, "health_system"):current_health_percent() == 1 then
			local var_3_5 = arg_3_2[2] * arg_3_1.template.multiplier

			if not ScriptUnit.has_extension(var_3_2, "status_system"):is_knocked_down() then
				local var_3_6 = ScriptUnit.has_extension(var_3_2, "health_system")
				local var_3_7 = var_3_6 and var_3_6:current_health_percent()

				if var_3_7 and var_3_7 < 1 then
					DamageUtils.heal_network(var_3_2, arg_3_0, var_3_5, "heal_from_proc")
				end
			end
		end
	end,
	add_buff_reff_buff_stack = function(arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = arg_4_2[1]

		if ALIVE[arg_4_0] and var_4_0 == arg_4_0 then
			local var_4_1 = arg_4_1.template
			local var_4_2 = var_4_1.buff_to_add
			local var_4_3 = var_4_1.amount_to_add
			local var_4_4 = ScriptUnit.extension(arg_4_0, "buff_system")

			for iter_4_0 = 1, var_4_3 do
				var_4_4:add_buff(var_4_2)
			end
		end
	end,
	remove_ref_buff_stack_woods = function(arg_5_0, arg_5_1, arg_5_2)
		if ALIVE[arg_5_0] then
			local var_5_0 = arg_5_1.template.buff_to_remove
			local var_5_1 = ScriptUnit.extension(arg_5_0, "buff_system")
			local var_5_2 = var_5_1:get_stacking_buff(var_5_0)

			if var_5_2 then
				local var_5_3 = #var_5_2

				if var_5_3 > 0 then
					local var_5_4 = var_5_2[var_5_3].id

					var_5_1:remove_buff(var_5_4)
				end
			end
		end
	end,
	thorn_sister_add_bleed_on_hit = function(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = arg_6_2[1]

		if ALIVE[arg_6_0] and ALIVE[var_6_0] then
			local var_6_1 = arg_6_1.template.bleed
			local var_6_2 = Managers.state.entity:system("buff_system")
			local var_6_3 = ScriptUnit.extension(arg_6_0, "career_system"):get_career_power_level()
			local var_6_4 = ScriptUnit.has_extension(var_6_0, "buff_system")

			if not var_6_4 or not var_6_4:has_buff_perk(var_0_0.poisoned) then
				return false
			end

			table.clear(var_0_2)

			var_0_2.power_level = var_6_3
			var_0_2.attacker_unit = arg_6_0

			var_6_2:add_buff_synced(var_6_0, var_6_1, BuffSyncType.LocalAndServer, var_0_2)
		end
	end,
	kerillian_thorn_sister_crit_aoe_poison_func = function(arg_7_0, arg_7_1, arg_7_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_7_0 = arg_7_2[4]

		if ALIVE[arg_7_0] and var_7_0 <= 1 then
			local var_7_1 = Managers.state.entity:system("area_damage_system")
			local var_7_2 = ScriptUnit.extension(arg_7_0, "career_system"):get_career_power_level()
			local var_7_3 = arg_7_2[1]
			local var_7_4 = POSITION_LOOKUP[var_7_3]
			local var_7_5 = "buff"
			local var_7_6 = "kerillian_thorn_sister_talent_poison_aoe"
			local var_7_7 = ScriptUnit.has_extension(arg_7_0, "talent_system")

			if var_7_7 and var_7_7:has_talent("kerillian_thorn_sister_double_poison") then
				var_7_6 = "kerillian_thorn_sister_talent_poison_aoe_improved"
			end

			local var_7_8 = Quaternion.identity()
			local var_7_9 = 1
			local var_7_10 = false

			var_7_1:create_explosion(arg_7_0, var_7_4, var_7_8, var_7_6, var_7_9, var_7_5, var_7_2, var_7_10)
		end
	end,
	thorn_sister_add_melee_poison = function(arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = arg_8_2[1]

		if ALIVE[arg_8_0] and HEALTH_ALIVE[var_8_0] then
			local var_8_1 = arg_8_2[2]

			if not var_8_1 or var_8_1 ~= "light_attack" and var_8_1 ~= "heavy_attack" then
				return
			end

			local var_8_2 = arg_8_1.template
			local var_8_3 = var_8_2.poison
			local var_8_4 = ScriptUnit.has_extension(arg_8_0, "talent_system")

			if var_8_4 and var_8_4:has_talent("kerillian_thorn_sister_double_poison") then
				var_8_3 = var_8_2.improved_poison
			end

			local var_8_5 = Managers.state.entity:system("buff_system")
			local var_8_6 = ScriptUnit.extension(arg_8_0, "career_system"):get_career_power_level()

			if not ScriptUnit.has_extension(var_8_0, "buff_system") then
				return false
			end

			table.clear(var_0_2)

			var_0_2.power_level = var_8_6
			var_0_2.attacker_unit = arg_8_0

			var_8_5:add_buff_synced(var_8_0, var_8_3, BuffSyncType.LocalAndServer, var_0_2)
		end
	end,
	thorn_sister_big_push = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		if ALIVE[arg_9_0] and arg_9_2[1].kind == "push_stagger" and ScriptUnit.has_extension(arg_9_0, "status_system"):current_fatigue_points() == 0 then
			local var_9_0 = ScriptUnit.extension(arg_9_0, "buff_system")
			local var_9_1 = arg_9_1.template
			local var_9_2 = var_9_1.buff_to_add

			var_9_0:add_buff(var_9_2)

			local var_9_3 = var_9_1.buff_to_add_2

			Managers.state.entity:system("buff_system"):add_buff(arg_9_0, var_9_3, arg_9_0, false)

			local var_9_4 = POSITION_LOOKUP[arg_9_0]

			World.create_particles(arg_9_3, "fx/thornsister_push", var_9_4, Quaternion.identity())
		end
	end,
	kerillian_thorn_sister_add_buff_remove = function(arg_10_0, arg_10_1, arg_10_2)
		if ALIVE[arg_10_0] then
			local var_10_0 = arg_10_1.template.buff_to_add

			Managers.state.entity:system("buff_system"):add_buff(arg_10_0, var_10_0, arg_10_0, false)
			ScriptUnit.extension(arg_10_0, "buff_system"):remove_buff(arg_10_1.id)
		end
	end,
	kerillian_thorn_sister_restore_health_on_ranged_hit = function(arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = arg_11_2[7]

		if ALIVE[arg_11_0] and var_11_0 and (var_11_0 == "projectile" or var_11_0 == "instant_projectile" or var_11_0 == "heavy_instant_projectile") then
			if Managers.state.network.is_server then
				local var_11_1 = arg_11_1.template.amount_to_heal

				DamageUtils.heal_network(arg_11_0, arg_11_0, var_11_1, "career_passive")
			end

			ScriptUnit.extension(arg_11_0, "buff_system"):remove_buff(arg_11_1.id)
		end
	end,
	kerillian_thorn_sister_wall_buff_enemies = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		local var_12_0 = arg_12_1.attacker_unit
		local var_12_1 = arg_12_2[arg_12_4.target_number]

		if ALIVE[arg_12_0] and ALIVE[var_12_0] and var_12_1 == 1 then
			local var_12_2 = POSITION_LOOKUP[var_12_0]
			local var_12_3 = arg_12_1.template
			local var_12_4 = var_12_3.radius
			local var_12_5 = var_12_3.buff_to_add
			local var_12_6 = FrameTable.alloc_table()
			local var_12_7 = Managers.state.entity:system("proximity_system").enemy_broadphase

			Broadphase.query(var_12_7, var_12_2, var_12_4, var_12_6)

			local var_12_8 = Managers.state.side
			local var_12_9 = Managers.state.entity:system("buff_system")

			for iter_12_0, iter_12_1 in pairs(var_12_6) do
				if ALIVE[iter_12_1] and var_12_8:is_enemy(arg_12_0, iter_12_1) then
					var_12_9:add_buff(iter_12_1, var_12_5, arg_12_0)
				end
			end
		end
	end,
	add_buff_on_proc_thorn = function(arg_13_0, arg_13_1, arg_13_2)
		if ALIVE[arg_13_0] then
			local var_13_0 = Managers.state.entity:system("buff_system")
			local var_13_1 = arg_13_1.template.buff_to_add

			var_13_0:add_buff(arg_13_0, var_13_1, arg_13_0, false)
		end
	end,
	kerillian_thorn_sister_reduce_passive_on_elite = function(arg_14_0, arg_14_1, arg_14_2)
		if ALIVE[arg_14_0] then
			local var_14_0 = ScriptUnit.extension(arg_14_0, "career_system")
			local var_14_1 = arg_14_1.template.time_removed_per_kill or 0

			var_14_0:modify_extra_ability_charge(var_14_1)
		end
	end,
	kerillian_thorn_sister_team_buff_on_passive = function(arg_15_0, arg_15_1, arg_15_2)
		if ALIVE[arg_15_0] then
			local var_15_0 = Managers.state.side.side_by_unit[arg_15_0].PLAYER_AND_BOT_UNITS
			local var_15_1 = #var_15_0
			local var_15_2 = 40
			local var_15_3 = arg_15_1.template
			local var_15_4 = POSITION_LOOKUP[arg_15_0]
			local var_15_5 = var_15_2 * var_15_2
			local var_15_6 = Managers.state.entity:system("buff_system")

			for iter_15_0 = 1, var_15_1 do
				local var_15_7 = var_15_0[iter_15_0]
				local var_15_8 = POSITION_LOOKUP[var_15_7]

				if var_15_5 > Vector3.distance_squared(var_15_4, var_15_8) then
					local var_15_9 = var_15_3.buff_to_add_1

					var_15_6:add_buff(var_15_7, var_15_9, arg_15_0, false)
				end
			end
		end
	end
}
var_0_1.buff_function_templates = {
	kerillian_thorn_sister_healing_wall_buff_counter_remove = function(arg_16_0, arg_16_1, arg_16_2)
		if ALIVE[arg_16_0] then
			local var_16_0 = ScriptUnit.extension(arg_16_0, "buff_system")

			if var_16_0:num_buff_type(arg_16_1.buff_type) == 1 then
				local var_16_1 = arg_16_1.template.add_buffs_data.buffs_to_add

				for iter_16_0 = 1, #var_16_1 do
					local var_16_2 = var_16_0:get_buff_type(var_16_1[iter_16_0])

					if var_16_2 then
						var_16_2.duration = 0
						var_16_2.aborted = 0
					end
				end
			end
		end
	end,
	start_dot_damage_kerillian = function(arg_17_0, arg_17_1, arg_17_2)
		local var_17_0 = arg_17_1.attacker_unit

		if ALIVE[var_17_0] then
			local var_17_1 = ScriptUnit.has_extension(var_17_0, "talent_system")

			if var_17_1 and var_17_1:has_talent("kerillian_thorn_sister_phasing") then
				local var_17_2 = ScriptUnit.has_extension(var_17_0, "buff_system")

				if not var_17_2 then
					return
				end

				arg_17_1.added_id = var_17_2:add_buff("kerillian_thorn_sister_drain_poison_phasing_tracker")

				if var_17_2:num_buff_type("kerillian_thorn_sister_drain_poison_phasing_tracker") >= 5 then
					var_17_2:add_buff("kerillian_thorn_sister_drain_poison_phasing_buff")
				end
			end
		end
	end,
	activate_stacking_buff_on_distance = function(arg_18_0, arg_18_1, arg_18_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_18_0 = arg_18_1.template
		local var_18_1 = arg_18_1.range
		local var_18_2 = var_18_1 * var_18_1
		local var_18_3 = POSITION_LOOKUP[arg_18_0]
		local var_18_4 = var_18_0.buff_to_add
		local var_18_5 = Managers.state.entity:system("buff_system")
		local var_18_6 = Managers.state.side.side_by_unit[arg_18_0].PLAYER_AND_BOT_UNITS
		local var_18_7 = #var_18_6

		for iter_18_0 = 1, var_18_7 do
			local var_18_8 = var_18_6[iter_18_0]
			local var_18_9 = arg_18_1.buff_instances and arg_18_1.buff_instances[var_18_8]

			if ALIVE[var_18_8] then
				local var_18_10 = POSITION_LOOKUP[var_18_8]
				local var_18_11 = Vector3.distance_squared(var_18_3, var_18_10)

				if not var_18_9 and var_18_11 <= var_18_2 then
					local var_18_12 = var_18_5:add_buff(var_18_8, var_18_4, arg_18_0, true)

					if arg_18_1.buff_instances then
						arg_18_1.buff_instances[var_18_8] = var_18_12
					else
						arg_18_1.buff_instances = {
							[var_18_8] = var_18_12
						}
					end
				elseif var_18_9 and var_18_2 < var_18_11 then
					var_18_5:remove_server_controlled_buff(var_18_8, var_18_9)

					arg_18_1.buff_instances[var_18_8] = nil
				end
			elseif var_18_9 then
				arg_18_1.buff_instances[var_18_8] = nil
			end
		end
	end,
	remove_aura_stacking_buff = function(arg_19_0, arg_19_1, arg_19_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_19_0 = arg_19_1.buff_instances

		if var_19_0 then
			local var_19_1 = Managers.state.entity:system("buff_system")

			for iter_19_0, iter_19_1 in pairs(var_19_0) do
				if ALIVE[iter_19_0] then
					var_19_1:remove_server_controlled_buff(iter_19_0, iter_19_1)
				end
			end
		end
	end,
	kerillian_thorn_sister_passive_health_convert = function(arg_20_0, arg_20_1, arg_20_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_20_0] then
			local var_20_0 = ScriptUnit.extension(arg_20_0, "buff_system")
			local var_20_1 = ScriptUnit.has_extension(arg_20_0, "health_system")
			local var_20_2 = arg_20_1.template
			local var_20_3 = var_20_2.thp_to_lose
			local var_20_4 = var_20_1 and var_20_3 < var_20_1:current_temporary_health()

			if var_20_0:has_buff_type("kerillian_thorn_sister_free_ability_stack") and var_20_4 then
				local var_20_5 = var_20_2.hp_to_gain

				DamageUtils.heal_network(arg_20_0, arg_20_0, var_20_5, "career_passive")

				if var_20_3 - var_20_5 > 0 then
					DamageUtils.add_damage_network(arg_20_0, arg_20_0, var_20_3 - var_20_5, "torso", "life_tap", nil, Vector3(0, 0, 0), "life_tap", nil, arg_20_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
				end
			end
		end
	end,
	kerillian_thorn_sister_add_buff_to_attacker = function(arg_21_0, arg_21_1, arg_21_2)
		if ALIVE[arg_21_0] then
			local var_21_0 = arg_21_1.template.buff_to_add
			local var_21_1 = arg_21_1.attacker_unit
			local var_21_2 = ScriptUnit.has_extension(var_21_1, "buff_system")

			if var_21_2 then
				arg_21_1.added_id = var_21_2:add_buff(var_21_0)
			end
		end
	end,
	kerillian_thorn_sister_remove_buff_from_attacker = function(arg_22_0, arg_22_1, arg_22_2)
		if arg_22_1.added_id then
			local var_22_0 = arg_22_1.attacker_unit
			local var_22_1 = ScriptUnit.has_extension(var_22_0, "buff_system")

			if var_22_1 then
				var_22_1:remove_buff(arg_22_1.added_id)
			end
		end
	end,
	buff_system_add_buff = function(arg_23_0, arg_23_1, arg_23_2)
		if ALIVE[arg_23_0] then
			local var_23_0 = arg_23_1.template.buff_to_add

			Managers.state.entity:system("buff_system"):add_buff(arg_23_0, var_23_0, arg_23_0, false)
		end
	end,
	kerillian_thorn_sister_noclip_on = function(arg_24_0, arg_24_1, arg_24_2)
		if ALIVE[arg_24_0] then
			local var_24_0 = ScriptUnit.has_extension(arg_24_0, "status_system")

			if var_24_0 then
				var_24_0:set_noclip(true, "thorn_sister_phasing")
			end
		end
	end,
	kerillian_thorn_sister_noclip_off = function(arg_25_0, arg_25_1, arg_25_2)
		if ALIVE[arg_25_0] then
			local var_25_0 = ScriptUnit.has_extension(arg_25_0, "status_system")

			if var_25_0 then
				var_25_0:set_noclip(false, "thorn_sister_phasing")
			end
		end
	end
}
var_0_1.stacking_buff_functions = {
	kerillian_thorn_sister_avatar = function(arg_26_0, arg_26_1)
		if ALIVE[arg_26_0] then
			local var_26_0 = arg_26_1.max_stack_data

			if var_26_0 then
				local var_26_1 = var_26_0.buffs_to_add
				local var_26_2 = Managers.state.entity:system("buff_system")

				for iter_26_0 = 1, #var_26_1 do
					local var_26_3 = var_26_1[iter_26_0]

					var_26_2:add_buff(arg_26_0, var_26_3, arg_26_0, false)
				end
			end
		end
	end
}
