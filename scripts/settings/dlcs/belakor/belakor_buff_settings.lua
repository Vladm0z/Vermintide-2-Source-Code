-- chunkname: @scripts/settings/dlcs/belakor/belakor_buff_settings.lua

require("scripts/settings/dlcs/belakor/belakor_balancing")

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local var_0_1 = DLCSettings.belakor

local function var_0_2()
	return Managers.state.network.is_server
end

local function var_0_3(arg_2_0, arg_2_1)
	local var_2_0 = arg_2_1.side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for iter_2_0 = 1, #var_2_0 do
		if Vector3.distance_squared(arg_2_0, var_2_0[iter_2_0]) < arg_2_1.min_dist_sqr then
			return false
		end
	end

	return true
end

local var_0_4 = {
	IDLE = 1,
	COOLDOWN = 5,
	FINDING_TELEPORT_POSITION = 2,
	TELEPORTING = 3,
	LANDING = 4
}

var_0_1.buff_function_templates = {
	update_belakor_grey_wings_teleport_trigger = function (arg_3_0, arg_3_1, arg_3_2)
		if not var_0_2() then
			return
		end

		local var_3_0 = BLACKBOARDS[arg_3_0]
		local var_3_1 = var_3_0.target_unit
		local var_3_2 = arg_3_1.parent_buff_shared_table

		if not var_3_1 then
			return
		end

		if var_3_0.move_state == "stagger" then
			var_3_2.teleport = true

			return
		end

		local var_3_3 = POSITION_LOOKUP[arg_3_0]
		local var_3_4 = POSITION_LOOKUP[var_3_1]

		if Vector3.length(var_3_4 - var_3_3) > arg_3_1.template.max_distance_to_trigger_teleport_from_combo_attack then
			return
		end

		local var_3_5 = var_3_0.combo_attack_data

		if var_3_0.move_state == "attacking" and var_3_5 and (var_3_5.current_attack_name == "attack_wild_flailing" or var_3_5.current_attack_name == "attack_heavy") and not var_3_5.aborted then
			var_3_2.teleport = true
		end
	end,
	apply_belakor_grey_wings = function (arg_4_0, arg_4_1, arg_4_2)
		if not var_0_2() then
			return
		end

		local var_4_0 = arg_4_1.parent_buff_shared_table

		var_4_0.teleport_state = var_0_4.IDLE

		local var_4_1 = arg_4_1.template.teleport_available_buff

		var_4_0.teleport_available_buff_id = ScriptUnit.has_extension(arg_4_0, "buff_system"):add_buff(var_4_1)
		var_4_0.blackboard = BLACKBOARDS[arg_4_0]
		var_4_0.side = Managers.state.side.side_by_unit[arg_4_0]
		var_4_0.health_extension = ScriptUnit.extension(arg_4_0, "health_system")
	end,
	update_belakor_grey_wings = function (arg_5_0, arg_5_1, arg_5_2)
		if not var_0_2() then
			return
		end

		local var_5_0 = Managers.time:time("game")
		local var_5_1 = ScriptUnit.has_extension(arg_5_0, "buff_system")
		local var_5_2 = arg_5_1.parent_buff_shared_table
		local var_5_3 = var_5_2.blackboard
		local var_5_4 = arg_5_1.template

		if var_5_2.teleport and var_5_2.teleport_state == var_0_4.IDLE then
			var_5_2.teleport_state = var_0_4.FINDING_TELEPORT_POSITION
			var_5_2.teleport = false
			var_5_3.umbral_leap = true
			var_5_3.in_vortex = true

			local var_5_5 = POSITION_LOOKUP[arg_5_0]
			local var_5_6 = var_5_4.teleport_effect

			if var_5_6 then
				local var_5_7 = NetworkLookup.effects[var_5_6]
				local var_5_8 = 0
				local var_5_9 = Quaternion.identity()

				Managers.state.network:rpc_play_particle_effect(nil, var_5_7, NetworkConstants.invalid_game_object_id, var_5_8, var_5_5, var_5_9, false)
			end
		end

		if var_5_2.teleport_state == var_0_4.COOLDOWN then
			if not var_5_2.teleport_cooldown_t then
				var_5_2.teleport_cooldown_t = var_5_0 + var_5_4.teleport_cooldown
			end

			if var_5_2.teleport_available_buff_id then
				var_5_1:remove_buff(var_5_2.teleport_available_buff_id)

				var_5_2.teleport_available_buff_id = nil
			end

			var_5_2.teleport = false

			if var_5_0 > var_5_2.teleport_cooldown_t then
				local var_5_10 = arg_5_1.template.teleport_available_buff

				var_5_2.teleport_available_buff_id = var_5_1:add_buff(var_5_10)
				var_5_2.teleport_state = var_0_4.IDLE
			end
		end

		if var_5_2.teleport_state == var_0_4.FINDING_TELEPORT_POSITION then
			local function var_5_11()
				if not ALIVE[arg_5_0] or var_5_2.teleport_state ~= var_0_4.FINDING_TELEPORT_POSITION then
					return
				end

				local var_6_0 = POSITION_LOOKUP[arg_5_0]
				local var_6_1 = true
				local var_6_2 = var_5_3.target_unit

				if var_6_2 then
					local var_6_3 = POSITION_LOOKUP[arg_5_0]
					local var_6_4 = POSITION_LOOKUP[var_6_2]

					if Vector3.length(var_6_4 - var_6_3) > var_5_4.min_distance_to_trigger_gap_closer_teleport then
						var_6_1 = false
					end
				end

				local var_6_5
				local var_6_6
				local var_6_7
				local var_6_8
				local var_6_9 = var_5_4.find_valid_pos_attempts
				local var_6_10 = var_5_2.side

				if var_6_1 then
					var_6_6 = var_5_4.min_teleport_distance
					var_6_7 = var_5_4.max_teleport_distance
					var_6_8 = var_5_4.min_dist_from_players
				else
					var_6_6 = var_5_4.min_teleport_distance_gap_closer
					var_6_7 = var_5_4.max_teleport_distance_gap_closer
					var_6_8 = var_5_4.min_dist_from_players_gap_closer
				end

				local var_6_11 = {
					side = var_6_10,
					min_dist_sqr = var_6_8 * var_6_8
				}
				local var_6_12 = ConflictUtils.get_spawn_pos_on_circle_with_func_range(var_5_3.nav_world, var_6_0, var_6_6, var_6_7, var_6_9, var_0_3, var_6_11, 8, 8)

				if var_6_12 then
					var_5_2.teleport_t = var_5_0 + var_5_4.teleport_delay
					var_5_2.teleport_position = Vector3Box(var_6_12)
					var_5_2.teleport_origin_position = Vector3Box(var_6_0)
					var_5_2.target_unit = var_5_3.target_unit
					var_5_2.teleport_state = var_0_4.TELEPORTING
				end
			end

			Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_5_11)
		end

		if var_5_2.teleport_state == var_0_4.TELEPORTING and ALIVE[arg_5_0] and var_5_0 > var_5_2.teleport_t then
			local function var_5_12()
				local var_7_0 = POSITION_LOOKUP[arg_5_0]
				local var_7_1 = var_5_2.teleport_position:unbox()
				local var_7_2 = var_5_4.teleport_effect

				if var_7_2 then
					local var_7_3 = NetworkLookup.effects[var_7_2]
					local var_7_4 = 0
					local var_7_5 = Quaternion.identity()

					Managers.state.network:rpc_play_particle_effect(nil, var_7_3, NetworkConstants.invalid_game_object_id, var_7_4, var_7_0, var_7_5, false)
				end

				local var_7_6 = var_5_4.teleport_effect_trail

				if var_7_6 then
					local var_7_7 = Managers.state.network
					local var_7_8 = 0
					local var_7_9 = Vector3.normalize(var_7_0 - var_7_1)
					local var_7_10 = Quaternion.look(var_7_9, Vector3.up())
					local var_7_11 = NetworkLookup.effects[var_7_6]

					var_7_7:rpc_play_particle_effect(nil, var_7_11, NetworkConstants.invalid_game_object_id, var_7_8, var_7_0, var_7_10, false)
				end

				var_5_3.umbral_leap_destination = Vector3Box(var_7_1)
				var_5_2.teleport_state = var_0_4.COOLDOWN
			end

			Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_5_12)
		end
	end,
	remove_belakor_grey_wings = function (arg_8_0, arg_8_1, arg_8_2)
		if not var_0_2() then
			return
		end
	end,
	apply_belakor_homing_skull_drain_stamina = function (arg_9_0, arg_9_1, arg_9_2)
		local var_9_0 = arg_9_1.template.fatigue_type
		local var_9_1 = ScriptUnit.has_extension(arg_9_0, "status_system")

		if var_9_1 then
			var_9_1:add_fatigue_points(var_9_0)
		end
	end,
	belakor_cultists_apply_eye_glow = function (arg_10_0, arg_10_1, arg_10_2)
		if ALIVE[arg_10_0] then
			arg_10_1.material_res_id = Unit.get_material_resource_id(arg_10_0, "mtr_eyes")

			Unit.set_material(arg_10_0, "mtr_eyes", "units/beings/enemies/mtr_eyes_belakor_cultist")
		end
	end,
	belakor_cultists_remove_eye_glow = function (arg_11_0, arg_11_1, arg_11_2)
		if ALIVE[arg_11_0] and arg_11_1.material_res_id then
			Unit.set_material_from_id(arg_11_0, "mtr_eyes", arg_11_1.material_res_id)
		end
	end,
	apply_one_from_list = function (arg_12_0, arg_12_1, arg_12_2)
		if var_0_2() then
			local var_12_0 = arg_12_1.template.buff_list
			local var_12_1 = var_12_0[math.random(1, #var_12_0)]

			Managers.state.entity:system("buff_system"):add_buff(arg_12_0, var_12_1, arg_12_1.attacker_unit or arg_12_0, false)
		end
	end,
	apply_homing_skull_achieve = function (arg_13_0, arg_13_1, arg_13_2)
		Managers.state.achievement:trigger_event("register_skull_hit", arg_13_0)
	end
}
var_0_1.proc_functions = {
	belakor_crystal_drop = function (arg_14_0, arg_14_1, arg_14_2)
		if var_0_2() then
			local var_14_0 = arg_14_2[1]
			local var_14_1 = Unit.world_position(var_14_0, 0) + Vector3(0, 0, 1.5)

			BelakorBalancing.spawn_crystal_func(var_14_1)
		end

		return true
	end,
	belakor_shadow_lieutenant_drop_crystal = function (arg_15_0, arg_15_1, arg_15_2)
		if var_0_2() then
			local var_15_0 = arg_15_2[1]
			local var_15_1 = Unit.node(var_15_0, "c_spine")
			local var_15_2 = Unit.world_position(var_15_0, var_15_1)
			local var_15_3 = Managers.state.entity:system("pickup_system")
			local var_15_4 = true
			local var_15_5 = Quaternion.identity()
			local var_15_6 = "dropped"
			local var_15_7 = Vector3(6 * math.random() - 3, 6 * math.random() - 3, 3)
			local var_15_8 = "belakor_crystal"
			local var_15_9 = "belakor_crystal_throw"

			var_15_3:spawn_pickup(var_15_8, var_15_2, var_15_5, var_15_4, var_15_6, var_15_7, var_15_9)

			local var_15_10 = Managers.world:world("level_world")
			local var_15_11 = LevelHelper:find_dialogue_unit(var_15_10, "ferry_lady")

			if var_15_11 and ScriptUnit.has_extension(var_15_11, "dialogue_system") then
				local var_15_12 = ScriptUnit.extension_input(var_15_11, "dialogue_system")
				local var_15_13 = FrameTable.alloc_table()
				local var_15_14 = Managers.level_transition_handler:get_current_level_keys()
				local var_15_15
				local var_15_16 = var_15_14 ~= "arena_belakor" and "shadow_curse_crystal_dropped" or "shadow_curse_vortex_crystal"

				var_15_12:trigger_dialogue_event(var_15_16, var_15_13)
			end
		end

		return true
	end,
	on_grey_wings_damage_taken = function (arg_16_0, arg_16_1, arg_16_2)
		if not var_0_2() then
			return
		end

		local var_16_0 = BLACKBOARDS[arg_16_0]
		local var_16_1 = arg_16_2[1]

		if var_16_0.target_unit ~= var_16_1 then
			return
		end

		local var_16_2 = arg_16_1.template.valid_damage_types
		local var_16_3 = arg_16_2[3]

		if var_16_2 and not var_16_2[var_16_3] then
			return
		end

		arg_16_1.parent_buff_shared_table.teleport = true
	end
}
var_0_1.explosion_templates = {
	homing_skull_explosion = {
		explosion = {
			alert_enemies = false,
			radius = 1,
			always_stagger_ai = true,
			allow_friendly_fire_override = true,
			buff_to_apply = "belakor_homing_skull_debuff",
			max_damage_radius_min = 0.5,
			attack_template = "drakegun",
			max_damage_radius_max = 1,
			sound_event_name = "Play_curse_shadow_dagger_projectile_impact",
			damage_profile = "homing_skull_explosion",
			power_level = 500,
			effect_name = "fx/belakor/blk_curse_skulls_explosion_fx",
			immune_breeds = {
				chaos_zombie = true,
				skaven_grey_seer = true,
				skaven_stormfiend = true
			}
		}
	},
	homing_skull_impact = {
		server_hit_func = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
			local var_17_0 = Unit.local_position(arg_17_0, 0)
			local var_17_1 = Managers.world:world("level_world")

			arg_17_5 = ExplosionUtils.get_template("homing_skull_explosion")

			DamageUtils.create_explosion(var_17_1, arg_17_0, var_17_0, Quaternion.identity(), arg_17_5, 1, arg_17_1, true, false, arg_17_2, false)

			local var_17_2 = Managers.state.network:game_object_or_level_id(arg_17_0)
			local var_17_3 = NetworkLookup.explosion_templates[arg_17_5.name]
			local var_17_4 = NetworkLookup.damage_sources[arg_17_1]

			Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_17_2, false, var_17_0, Quaternion.identity(), var_17_3, 1, var_17_4, 0, false, var_17_2)
			AiUtils.kill_unit(arg_17_0, nil, nil, "undefined", nil)
		end
	},
	tiny_explosive_barrel = {
		explosion = {
			radius = 6,
			dot_template_name = "burning_dot_1tick",
			max_damage_radius = 1.75,
			alert_enemies = true,
			alert_enemies_radius = 10,
			allow_friendly_fire_override = true,
			attack_template = "drakegun",
			sound_event_name = "boon_cluster_barrel_explosion",
			damage_profile = "explosive_barrel",
			effect_name = "fx/wpnfx_barrel_explosion",
			difficulty_power_level = {
				easy = {
					power_level_glance = 100,
					power_level = 200
				},
				normal = {
					power_level_glance = 200,
					power_level = 400
				},
				hard = {
					power_level_glance = 300,
					power_level = 600
				},
				harder = {
					power_level_glance = 400,
					power_level = 800
				},
				hardest = {
					power_level_glance = 500,
					power_level = 1000
				},
				cataclysm = {
					power_level_glance = 550,
					power_level = 1100
				},
				cataclysm_2 = {
					power_level_glance = 575,
					power_level = 1150
				},
				cataclysm_3 = {
					power_level_glance = 600,
					power_level = 1200
				},
				versus_base = {
					power_level_glance = 300,
					power_level = 600
				}
			}
		}
	},
	belakor_arena_finish = {
		explosion = {
			no_aggro = true,
			radius = 300,
			player_push_speed = 5,
			alert_enemies = false,
			damage_profile = "belakor_arena_finish",
			power_level = 1000,
			level_unit_damage = true,
			collision_filter = "filter_simple_explosion_overlap"
		}
	}
}

local var_0_5 = {
	light_blunt_linesman = true,
	light_slashing_tank = true,
	drakegun = true,
	heavy_blunt_smiter = true,
	slashing_smiter_uppercut = true,
	piercing = true,
	light_slashing_linesman = true,
	heavy_slashing_smiter_uppercut = true,
	blunt = true,
	light_blunt_fencer = true,
	heavy_blunt_linesman = true,
	blunt_tank_uppercut = true,
	heavy_blunt_tank = true,
	light_stab_fencer = true,
	arrow = true,
	heavy_stab_fencer = true,
	shot_sniper = true,
	shot_machinegun = true,
	bolt_sniper = true,
	blunt_linesman = true,
	blunt_tank = true,
	shot_repeating_handgun = true,
	light_slashing_fencer = true,
	projectile = true,
	slashing_fencer = true,
	heavy_slashing_fencer = true,
	drakegun_shot = true,
	heavy_stab_smiter = true,
	arrow_sniper = true,
	heavy_slashing_tank = true,
	arrow_carbine = true,
	heavy_slashing_smiter = true,
	light_slashing_linesman_hs = true,
	arrow_machinegun = true,
	shot_shotgun = true,
	slashing_smiter = true,
	bolt_carbine = true,
	bolt_machinegun = true,
	stab_smiter = true,
	throwing_axe = true,
	heavy_blunt_fencer = true,
	stab_fencer = true,
	light_blunt_tank = true,
	slashing_linesman = true,
	blunt_fencer = true,
	light_slashing_smiter = true,
	slashing = true,
	light_blunt_smiter = true,
	blunt_smiter = true,
	shot_carbine = true,
	slashing_tank = true,
	cutting = true,
	heavy_slashing_linesman = true,
	burning_stab_fencer = true,
	light_stab_smiter = true
}

var_0_1.buff_templates = {
	orb_test_01 = {
		buffs = {
			{
				event = "on_kill",
				name = "orb_test_01",
				buff_func = "spawn_orb",
				orb_settings = {
					orb_name = "test_orb_01"
				}
			}
		}
	},
	orb_test_buff_01 = {
		activation_effect = "fx/screenspace_potion_02",
		buffs = {
			{
				name = "orb_test_buff_01",
				multiplier = 0.5,
				stat_buff = "attack_speed",
				duration = 2,
				max_stacks = 10,
				icon = "potion_buff_02",
				refresh_durations = true
			}
		}
	},
	belakor_shadow_lieutenant = {
		buffs = {
			{
				multiplier = 1.75,
				name = "belakor_shadow_lieutenant",
				stat_buff = "max_health",
				remove_buff_func = "remove_max_health_buff_for_ai",
				apply_buff_func = "apply_max_health_buff_for_ai",
				perks = {
					"anti_oneshot"
				}
			},
			{
				name = "belakor_shadow_lieutenant_material_objective_unit",
				buff_func = "remove_objective_unit",
				event = "on_death",
				remove_buff_func = "remove_objective_unit",
				apply_buff_func = "apply_objective_unit"
			},
			{
				event = "on_death",
				name = "belakor_shadow_lieutenant_drop_crystal",
				buff_func = "belakor_shadow_lieutenant_drop_crystal"
			}
		}
	},
	belakor_crystal_spawn_on_death = {
		buffs = {
			{
				event = "on_death",
				name = "belakor_crystal_spawn_on_death",
				buff_func = "belakor_crystal_drop",
				crystal_count = BelakorBalancing.totem_crystal_count
			}
		}
	},
	belakor_grey_wings = {
		create_parent_buff_shared_table = true,
		buffs = {
			{
				event = "on_damage_taken",
				name = "belakor_grey_wings",
				buff_func = "on_grey_wings_damage_taken",
				valid_damage_types = var_0_5
			},
			{
				min_dist_from_players_gap_closer = 3,
				name = "belakor_grey_wings_teleport_logic",
				min_distance_to_trigger_gap_closer_teleport = 10,
				teleport_effect = "fx/blk_grey_wings_teleport_01",
				remove_buff_func = "remove_belakor_grey_wings",
				teleport_effect_trail = "fx/blk_grey_wings_teleport_direction_01",
				min_teleport_distance_gap_closer = 3,
				teleport_delay = 0.5,
				teleport_cooldown = 1,
				teleport_available_buff = "belakor_grey_wings_teleport_available",
				max_teleport_distance_gap_closer = 6,
				apply_buff_func = "apply_belakor_grey_wings",
				max_teleport_distance = 13,
				min_teleport_distance = 7,
				find_valid_pos_attempts = 5,
				update_func = "update_belakor_grey_wings",
				min_dist_from_players = 5
			},
			{
				update_func = "update_belakor_grey_wings_teleport_trigger",
				name = "belakor_grey_wings_on_combo",
				max_distance_to_trigger_teleport_from_combo_attack = 5
			},
			{
				multiplier = 1,
				name = "belakor_grey_wings_health",
				stat_buff = "max_health",
				remove_buff_func = "remove_max_health_buff_for_ai",
				apply_buff_func = "apply_max_health_buff_for_ai"
			}
		}
	},
	belakor_grey_wings_teleport_available = {
		buffs = {
			{
				name = "belakor_grey_wings_teleport_available",
				perks = {
					var_0_0.invulnerable_ranged
				}
			},
			{
				remove_buff_func = "remove_attach_particle",
				name = "belakor_grey_wings_particle",
				apply_buff_func = "apply_attach_particle",
				particle_fx = "fx/blk_grey_wings_01"
			}
		}
	},
	belakor_homing_skull_debuff = {
		buffs = {
			{
				name = "belakor_homing_skull_debuff",
				apply_buff_func = "apply_one_from_list",
				buff_list = {
					"belakor_homing_skull_debuff_delayed_stun_effect"
				}
			}
		}
	},
	belakor_homing_skull_debuff_delayed_stun = {
		buffs = {
			{
				buff_to_add = "belakor_homing_skull_debuff_delayed_stun_effect",
				name = "belakor_homing_skull_debuff_delayed_stun",
				is_cooldown = true,
				icon = "deus_curse_slaanesh_01",
				continuous_effect = "fx/screenspace_darkness_flash",
				remove_buff_func = "add_buff",
				priority_buff = true,
				debuff = true,
				max_stacks = 1,
				duration = 3
			}
		}
	},
	belakor_homing_skull_debuff_delayed_stun_effect = {
		deactivation_sound = "stop_curse_belakor_shadow_skulls_player_disabled",
		activation_sound = "play_curse_belakor_shadow_skulls_player_disabled_start",
		buffs = {
			{
				priority_buff = true,
				name = "belakor_homing_skull_debuff_delayed_stun_effect",
				debuff = true,
				icon = "deus_curse_belakor_02",
				apply_buff_func = "apply_homing_skull_achieve",
				continuous_effect = "fx/screenspace_darkness_flash",
				max_stacks = 1,
				duration = 2.5,
				perks = {
					var_0_0.overpowered
				}
			},
			{
				particle_fx = "fx/skull_trap",
				name = "belakor_homing_skull_debuff_particle",
				offset_rotation_y = 90,
				duration = 2.5,
				remove_buff_func = "remove_attach_particle",
				apply_buff_func = "apply_attach_particle"
			}
		}
	},
	belakor_homing_skull_debuff_delayed_banish = {
		buffs = {
			{
				icon = "twitch_icon_vanishing_act",
				name = "belakor_homing_skull_debuff_delayed_banish",
				continuous_effect = "fx/screenspace_inside_plague_vortex",
				max_stacks = 1,
				duration = 5,
				priority_buff = true,
				debuff = true,
				perks = {
					var_0_0.invulnerable
				}
			},
			{
				max_stacks = 1,
				name = "belakor_homing_skull_debuff_delayed_banish_stun",
				duration = 5,
				perks = {
					var_0_0.overpowered
				}
			}
		}
	},
	belakor_cultists_buff = {
		buffs = {
			{
				multiplier = 0.25,
				name = "belakor_cultists_buff_damage",
				stat_buff = "damage_dealt"
			},
			{
				multiplier = 1.25,
				name = "belakor_cultists_buff_health",
				stat_buff = "max_health"
			},
			{
				remove_buff_func = "ai_update_max_health",
				name = "belakor_cultists_buff_health_update",
				apply_buff_func = "ai_update_max_health"
			},
			{
				remove_buff_func = "belakor_cultists_remove_eye_glow",
				name = "belakor_cultists_buff_eye_glow",
				apply_buff_func = "belakor_cultists_apply_eye_glow"
			},
			{
				multiplier = 1.1,
				name = "belakor_cultists_buff_stagger",
				stat_buff = "stagger_resistance"
			},
			{
				multiplier = 0.9,
				name = "belakor_cultists_buff_hit_mass",
				stat_buff = "hit_mass_amount"
			}
		}
	}
}
