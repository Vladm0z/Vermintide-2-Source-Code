-- chunkname: @scripts/settings/dlcs/carousel/carousel_buff_settings.lua

local var_0_0 = DLCSettings.carousel
local var_0_1 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

local function var_0_2(arg_1_0)
	local var_1_0 = Managers.player:owner(arg_1_0)

	return var_1_0 and not var_1_0.remote
end

local function var_0_3(arg_2_0)
	local var_2_0 = Managers.player:owner(arg_2_0)

	return var_2_0 and var_2_0.bot_player
end

var_0_0.buff_templates = {
	vs_core_attack_speed_melee = {
		buffs = {
			{
				multiplier = 0.1,
				name = "vs_core_attack_speed_melee",
				stat_buff = "attack_speed_melee"
			}
		}
	},
	vs_core_reduced_overcharge = {
		buffs = {
			{
				multiplier = 0.2,
				name = "vs_core_reduced_overcharge",
				stat_buff = "reduced_overcharge"
			}
		}
	},
	vs_core_critical_strike_chance = {
		buffs = {
			{
				name = "vs_core_critical_strike_chance",
				stat_buff = "critical_strike_chance",
				bonus = 0.1
			}
		}
	},
	vs_gutter_runner_allow_dismount = {
		buffs = {
			{
				name = "vs_gutter_runner_allow_dismount"
			}
		}
	},
	vs_gutter_runner_smoke_bomb_invisible = {
		deactivation_effect = "fx/screenspace_ranger_skill_02",
		buffs = {
			{
				remove_buff_func = "end_vs_gutter_runner_smoke_bomb_invisibility",
				name = "vs_gutter_runner_smoke_bomb_invisible",
				apply_buff_func = "start_vs_gutter_runner_smoke_bomb_invisibility",
				duration = 4,
				refresh_durations = true,
				priority_buff = true,
				continuous_effect = "fx/screenspace_ranger_skill_01",
				max_stacks = 1,
				icon = "bardin_ranger_activated_ability",
				perks = {
					var_0_1.invulnerable
				}
			}
		}
	},
	vs_ratling_gunner_slow = {
		buffs = {
			{
				update_func = "update_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "vs_ratling_gunner_slow",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				icon = "troll_vomit_debuff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				debuff = true,
				max_stacks = 1,
				duration = 0.8,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "decrease_crouch_speed_vs_ratling_gunner",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.8,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.5,
				name = "decrease_walk_speed_vs_ratling_gunner",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.8,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			},
			{
				name = "decrease_jump_speed_vs_ratling_gunner",
				multiplier = 0.6,
				duration = 0.8,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				name = "decrease_dodge_speed_vs_ratling_gunner",
				multiplier = 0.8,
				duration = 0.8,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				name = "decrease_dodge_distance_vs_ratling_gunner",
				multiplier = 0.8,
				duration = 0.8,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	vs_warpfire_thrower_long_distance_damage = {
		buffs = {
			{
				remove_buff_func = "remove_vs_warpfirethrower_long_distance_damage",
				name = "vs_warpfire_thrower_long_distance_damage",
				icon = "troll_vomit_debuff",
				duration = 0.3,
				refresh_durations = true,
				apply_buff_func = "apply_vs_warpfirethrower_long_distance_damage",
				update_start_delay = 0.1,
				time_between_dot_damages = 0.35,
				timed_status_effect_time = 2,
				update_func = "update_vs_warpfirethrower_long_distance_damage",
				perks = {
					var_0_1.burning_warpfire
				}
			}
		}
	},
	vs_warpfire_thrower_short_distance_damage = {
		buffs = {
			{
				slowdown_buff_name = "warpfire_thrower_fire_slowdown",
				name = "vs_warpfire_thrower_base",
				update_func = "update_warpfirethrower_in_face",
				dormant = true,
				damage_type = "warpfire_ground",
				remove_buff_func = "remove_warpfirethrower_in_face",
				apply_buff_func = "apply_warpfirethrower_in_face_versus",
				fatigue_type = "warpfire_ground",
				duration = 0.15,
				time_between_dot_damages = 0.15,
				timed_status_effect_time = 2,
				debuff = true,
				icon = "troll_vomit_debuff",
				push_speed = 9,
				perks = {
					var_0_1.burning_warpfire
				}
			}
		}
	},
	vs_pactsworn_melee_damage_taken = {
		buffs = {
			{
				multiplier = 1,
				name = "defence_debuff_enemies",
				stat_buff = "damage_taken_melee"
			}
		}
	},
	vs_boss_stagger_immune = {
		buffs = {
			{
				multiplier = -1,
				name = "vs_boss_stagger_immune",
				stat_buff = "impact_vulnerability",
				max_stacks = 1,
				duration = 3
			}
		}
	},
	vs_rat_ogre_start_leap_stagger_immune = {
		buffs = {
			{
				multiplier = -1,
				name = "vs_rat_ogre_start_leap_stagger_immune",
				stat_buff = "impact_vulnerability",
				max_stacks = 1,
				duration = 5
			}
		}
	},
	vs_rat_ogre_finish_leap_stagger_immune = {
		buffs = {
			{
				multiplier = -1,
				name = "vs_rat_ogre_finish_leap_stagger_immune",
				stat_buff = "impact_vulnerability",
				max_stacks = 1,
				duration = 8
			}
		}
	},
	vs_damage_taken = {
		buffs = {
			{
				multiplier = -1,
				name = "vs_damage_taken",
				stat_buff = "damage_taken",
				duration = 10
			}
		}
	},
	vs_stagger_immune = {
		buffs = {
			{
				multiplier = -1,
				name = "vs_stagger_immune",
				stat_buff = "impact_vulnerability",
				duration = 10
			}
		}
	},
	vs_boss_health_degeneration = {
		buffs = {
			{
				multiplier = 0.1,
				name = "vs_boss_health_degeneration",
				stat_buff = "healing_received"
			}
		}
	},
	vs_boss_mood = {
		buffs = {
			{
				update_func = "update_vs_boss_mood",
				name = "vs_boss_mood",
				mood = "playable_boss"
			}
		}
	},
	rat_ogre_planted_decrease_movement = {
		buffs = {
			{
				remove_buff_name = "planted_return_to_normal_movement",
				name = "decrease_speed",
				lerp_time = 0.5,
				multiplier = 1,
				update_func = "update_action_lerp_movement_buff",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			}
		}
	},
	vs_ability_buff_chaos_troll_regen = {
		buffs = {
			{
				multiplier = -1,
				name = "vs_stagger_immune",
				stat_buff = "impact_vulnerability",
				duration = 5
			},
			{
				multiplier = -0.5,
				name = "vs_damage_taken",
				stat_buff = "damage_taken",
				duration = 5
			},
			{
				duration = 5,
				name = "vs_chaos_troll_regen",
				particle_vfx = "fx/chr_chaos_troll_healing",
				remove_buff_func = "remove_vs_chaos_troll_regen",
				apply_buff_func = "apply_vs_chaos_troll_regen",
				screen_space_effect = "fx/screenspace_chaos_troll_healing",
				tick_rate = 0.05,
				heal_percentage = 0.5,
				update_func = "update_vs_chaos_troll_regen"
			}
		}
	},
	vs_warpfire_thrower_no_charge_explotion = {
		buffs = {
			{
				name = "vs_warpfire_thrower_no_charge_explotion",
				icon = "sienna_scholar_overcharge_no_slow",
				perks = {
					var_0_1.no_overcharge_explosion
				}
			}
		}
	},
	staff_life_player_target_cooldown = {
		buffs = {
			{
				icon = "icon_wpn_we_life_staff_01",
				name = "staff_life_player_target_cooldown",
				is_cooldown = true,
				duration = 40,
				priority_buff = true,
				perks = {
					var_0_1.sister_no_player_lift
				}
			}
		}
	},
	vs_bile_troll_vomit_face_base = {
		buffs = {
			{
				slowdown_buff_name = "vs_bile_troll_vomit_face_slowdown",
				name = "vs_troll_bile_face",
				debuff = true,
				update_func = "update_vomit_in_face",
				fatigue_type = "vomit_face",
				remove_buff_func = "remove_vomit_in_face",
				apply_buff_func = "apply_vomit_in_face",
				duration = 5,
				time_between_dot_damages = 0.65,
				refresh_durations = true,
				damage_type = "vomit_face",
				max_stacks = 1,
				icon = "troll_vomit_debuff",
				push_speed = 6,
				difficulty_damage = {
					easy = {
						1,
						1,
						0,
						0.5,
						1
					},
					normal = {
						1,
						1,
						0,
						1,
						1
					},
					hard = {
						1,
						1,
						0,
						1,
						1
					},
					harder = {
						1,
						1,
						0,
						2,
						1
					},
					hardest = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm_2 = {
						1,
						1,
						0,
						4,
						1
					},
					cataclysm_3 = {
						1,
						1,
						0,
						4,
						1
					},
					versus_base = {
						1,
						1,
						0,
						1,
						1
					}
				}
			},
			{
				name = "decrease_jump_speed",
				multiplier = 0.3,
				duration = 7,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				name = "decrease_dodge_speed",
				multiplier = 0.3,
				duration = 7,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				name = "decrease_dodge_distance",
				multiplier = 0.3,
				duration = 7,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	vs_bile_troll_vomit_face_slowdown = {
		buffs = {
			{
				update_func = "update_action_lerp_movement_buff",
				multiplier = 0.3,
				name = "decrease_speed",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.5,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.3,
				name = "decrease_crouch_speed",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.5,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.3,
				name = "decrease_walk_speed",
				refresh_durations = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 0.5,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			}
		}
	}
}

local function var_0_4(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = Managers.state.unit_storage:go_id(arg_3_0)
	local var_3_1 = Managers.state.network:game()
	local var_3_2 = GameSession.game_object_field(var_3_1, var_3_0, "aim_direction")
	local var_3_3 = POSITION_LOOKUP[arg_3_0]
	local var_3_4 = POSITION_LOOKUP[arg_3_1]
	local var_3_5 = Vector3.flat(var_3_4 - var_3_3)
	local var_3_6, var_3_7 = Vector3.direction_length(var_3_5)

	if var_3_7 < math.epsilon then
		return true, 1
	end

	return Vector3.dot(var_3_2, var_3_6) > math.cos(math.pi * 0.6666666666666666)
end

var_0_0.buff_function_templates = {
	apply_vs_chaos_troll_regen = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		local var_4_0 = arg_4_1.template
		local var_4_1 = ScriptUnit.extension(arg_4_0, "health_system")
		local var_4_2 = var_4_1:get_max_health() - var_4_1:current_permanent_health()
		local var_4_3 = var_4_2 * var_4_0.heal_percentage
		local var_4_4 = var_4_3 / arg_4_1.duration

		arg_4_2.health_to_heal = var_4_3
		arg_4_2.tick_rate = var_4_0.tick_rate
		arg_4_2.health_to_heal_per_tick = var_4_0.tick_rate and var_4_4 * var_4_0.tick_rate
		arg_4_2.missing_health = var_4_2
		arg_4_2.next_tick = arg_4_2.t + var_4_0.tick_rate

		local var_4_5 = var_4_0.particle_vfx

		if not DEDICATED_SERVER then
			local var_4_6 = Managers.player:unit_owner(arg_4_0)

			if var_4_6 and var_4_6.remote then
				local var_4_7 = CosmeticsUtils.get_third_person_mesh_unit(arg_4_0)
				local var_4_8 = 0

				arg_4_2.particle_id = ScriptWorld.create_particles_linked(arg_4_3, var_4_5, var_4_7, var_4_8, "destroy")

				World.set_particles_life_time(arg_4_3, arg_4_2.particle_id, arg_4_1.duration)
			elseif var_4_6 and var_4_6.local_player and not var_4_6.bot_player then
				local var_4_9 = var_4_0.screen_space_effect

				arg_4_2.screen_space_id = ScriptUnit.has_extension(arg_4_0, "first_person_system"):create_screen_particles(var_4_9)

				World.set_particles_life_time(arg_4_3, arg_4_2.screen_space_id, arg_4_1.duration)
			end
		end
	end,
	update_vs_chaos_troll_regen = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		if arg_5_2.t > arg_5_2.next_tick then
			arg_5_2.next_tick = arg_5_2.t + arg_5_2.tick_rate

			if Managers.state.network.is_server then
				DamageUtils.heal_network(arg_5_0, arg_5_0, arg_5_2.health_to_heal_per_tick, "health_regen")
			end
		end
	end,
	remove_vs_chaos_troll_regen = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		return
	end,
	update_vs_boss_mood = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		if var_0_2(arg_7_0) then
			local var_7_0 = arg_7_1.template
			local var_7_1 = Managers.player:unit_owner(arg_7_0)
			local var_7_2 = Managers.state.entity:system("camera_system")
			local var_7_3 = var_7_2 and var_7_1 and var_7_2.camera_units and var_7_2.camera_units[var_7_1]
			local var_7_4

			if var_7_3 then
				local var_7_5 = ScriptUnit.extension(var_7_3, "camera_state_machine_system")

				var_7_4 = var_7_5.state_machine.state_current and var_7_5.state_machine.state_current.name
			end

			if var_7_4 and var_7_4 ~= arg_7_2.previous_camera_state then
				Managers.state.camera:set_mood(var_7_0.mood, arg_7_1, var_7_4 == "follow")
			end

			arg_7_2.previous_camera_state = var_7_4
		end
	end,
	start_vs_gutter_runner_smoke_bomb_invisibility = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		if var_0_2(arg_8_0) then
			ScriptUnit.extension(arg_8_0, "status_system"):set_invisible(true, nil, arg_8_1)
			Managers.state.camera:set_mood("gutter_runner_f", arg_8_1, true)
		end
	end,
	end_vs_gutter_runner_smoke_bomb_invisibility = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		if var_0_2(arg_9_0) then
			ScriptUnit.extension(arg_9_0, "first_person_system"):play_unit_sound_event("Play_versus_gutterrunner_vanish_fps_end", arg_9_0, 0)

			local var_9_0 = ScriptUnit.extension(arg_9_0, "career_system")

			var_9_0:set_state("default")
			var_9_0:start_activated_ability_cooldown(1)
			ScriptUnit.extension(arg_9_0, "status_system"):set_invisible(false, nil, arg_9_1)

			if Managers.state.network:game() then
				ScriptUnit.extension(arg_9_0, "status_system"):set_is_dodging(false)

				local var_9_1 = Managers.state.network
				local var_9_2 = var_9_1.network_transmit
				local var_9_3 = var_9_1:unit_game_object_id(arg_9_0)

				var_9_2:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, var_9_3, 0)
			end

			Managers.state.camera:set_mood("gutter_runner_f", arg_9_1, false)
		end
	end,
	apply_vs_warpfirethrower_long_distance_damage = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		arg_10_1.armor_type = Unit.get_data(arg_10_0, "breed").armor_category or 1

		local var_10_0 = ScriptUnit.has_extension(arg_10_0, "first_person_system")

		if var_10_0 then
			arg_10_1.warpfire_particle_id = var_10_0:create_screen_particles("fx/screenspace_warpfire_hit_onfeet")
		end

		local var_10_1 = ALIVE[arg_10_2.attacker_unit] and arg_10_2.attacker_unit or arg_10_0

		if Unit.alive(var_10_1) then
			local var_10_2 = Unit.get_data(var_10_1, "breed")

			arg_10_1.damage = var_10_2.shoot_warpfire_long_attack_damage
			arg_10_1.damage_source = var_10_2 and var_10_2.name or "dot_debuff"
		end
	end,
	update_vs_warpfirethrower_long_distance_damage = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		local var_11_0 = arg_11_2.t
		local var_11_1 = arg_11_1.template

		if Managers.state.network.is_server then
			local var_11_2 = arg_11_2.attacker_unit
			local var_11_3 = ScriptUnit.has_extension(arg_11_0, "buff_system"):has_buff_perk("power_block")
			local var_11_4 = false

			if var_11_3 then
				var_11_4 = var_0_4(arg_11_0, var_11_2, arg_11_1, arg_11_2, arg_11_3)
			end

			if (not var_11_4 or not DamageUtils.check_ranged_block(var_11_2, arg_11_0, "blocked_berzerker")) and HEALTH_ALIVE[arg_11_0] then
				local var_11_5 = arg_11_1.armor_type
				local var_11_6 = var_11_1.damage_type
				local var_11_7 = arg_11_1.damage[var_11_5]
				local var_11_8 = arg_11_1.damage_source

				DamageUtils.add_damage_network(arg_11_0, var_11_2, var_11_7, "torso", var_11_6, nil, Vector3(1, 0, 0), var_11_8, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end

		local var_11_9 = ScriptUnit.has_extension(arg_11_0, "first_person_system")

		if var_11_9 then
			var_11_9:play_hud_sound_event("Play_player_damage_puke")
		end

		return var_11_0 + var_11_1.time_between_dot_damages
	end,
	remove_vs_warpfirethrower_long_distance_damage = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		local var_12_0 = ScriptUnit.has_extension(arg_12_0, "first_person_system")

		if var_12_0 then
			var_12_0:stop_spawning_screen_particles(arg_12_1.warpfire_particle_id)
		end
	end,
	apply_warpfirethrower_in_face_versus = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
		local var_13_0 = arg_13_1.template
		local var_13_1 = ScriptUnit.has_extension(arg_13_0, "first_person_system")

		if var_13_1 then
			arg_13_1.warpfire_particle_id = var_13_1:create_screen_particles("fx/screenspace_warpfire_flamethrower_01")
			arg_13_1.warpfire_particle_id_2 = var_13_1:create_screen_particles("fx/screenspace_warpfire_hit_inface")

			var_13_1:play_hud_sound_event("Play_player_hit_warpfire_thrower")
		end

		local var_13_2 = arg_13_2.attacker_unit

		if Unit.alive(var_13_2) then
			local var_13_3 = Unit.get_data(var_13_2, "breed")

			arg_13_1.damage = var_13_3.shoot_warpfire_long_attack_damage
			arg_13_1.damage_source = var_13_3 and var_13_3.name or "dot_debuff"
		end

		local var_13_4 = Unit.get_data(arg_13_0, "breed")

		arg_13_1.armor_type = var_13_4.armor_category or 1

		if var_13_4.is_hero and var_13_1 then
			local var_13_5 = ScriptUnit.has_extension(arg_13_0, "buff_system")
			local var_13_6 = ScriptUnit.has_extension(arg_13_0, "status_system")

			if not (var_13_5 and var_13_5:has_buff_perk("no_ranged_knockback")) and not var_13_6:is_disabled() and not var_13_6:has_noclip() then
				local var_13_7 = ScriptUnit.extension(arg_13_0, "locomotion_system")
				local var_13_8 = var_13_0.push_speed
				local var_13_9

				if ALIVE[var_13_2] then
					local var_13_10 = POSITION_LOOKUP[arg_13_0] - POSITION_LOOKUP[var_13_2]

					var_13_9 = Vector3.normalize(var_13_10)
				else
					var_13_9 = Vector3.backward()
				end

				local var_13_11 = var_13_9 * var_13_8

				var_13_7:add_external_velocity(var_13_11)
			end
		end
	end
}
