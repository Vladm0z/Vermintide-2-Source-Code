-- chunkname: @scripts/settings/dlcs/carousel/carousel_buff_settings.lua

local carousel = DLCSettings.carousel
local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

local function fn(arg_1_0)
	-- function 1
	local owner = Managers.player:owner(arg_1_0)

	return not owner and not owner.remote
end

local function fn_2(arg_2_0)
	-- function 2
	local owner = Managers.player:owner(arg_2_0)

	return not owner and owner.bot_player
end

carousel.buff_templates = {
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.invulnerable
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning_warpfire
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning_warpfire
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.no_overcharge_explosion
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.sister_no_player_lift
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

local function fn_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local go_id = Managers.state.unit_storage:go_id(arg_3_0)
	local game = Managers.state.network:game()
	local game_object_field = GameSession.game_object_field(game, go_id, "aim_direction")
	local var_3_3 = POSITION_LOOKUP[arg_3_0]
	local var_3_4 = POSITION_LOOKUP[arg_3_1]
	local flat = Vector3.flat(var_3_4 - var_3_3)
	local direction_length, var_3_7 = Vector3.direction_length(flat)

	if var_3_7 < math.epsilon then
		return true, 1
	end

	return Vector3.dot(game_object_field, direction_length) > math.cos(math.pi * 0.6666666666666666)
end

carousel.buff_function_templates = {
	apply_vs_chaos_troll_regen = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
		-- function 4
		local template = arg_4_1.template
		local extension = ScriptUnit.extension(arg_4_0, "health_system")
		local num = extension:get_max_health() - extension:current_permanent_health()
		local num_2 = num * template.heal_percentage
		local num_3 = num_2 / arg_4_1.duration

		arg_4_2.health_to_heal = num_2
		arg_4_2.tick_rate = template.tick_rate

		local tick_rate = template.tick_rate

		tick_rate = not tick_rate and num_3 * template.tick_rate
		arg_4_2.health_to_heal_per_tick = tick_rate
		arg_4_2.missing_health = num
		arg_4_2.next_tick = arg_4_2.t + template.tick_rate

		local particle_vfx = template.particle_vfx

		if not DEDICATED_SERVER then
			local unit_owner = Managers.player:unit_owner(arg_4_0)

			if not unit_owner and not unit_owner.remote then
				local get_third_person_mesh_unit = CosmeticsUtils.get_third_person_mesh_unit(arg_4_0)
				local num_4 = 0

				arg_4_2.particle_id = ScriptWorld.create_particles_linked(arg_4_3, particle_vfx, get_third_person_mesh_unit, num_4, "destroy")

				World.set_particles_life_time(arg_4_3, arg_4_2.particle_id, arg_4_1.duration)
			elseif not (not unit_owner and not unit_owner.local_player and unit_owner.bot_player) then
				local screen_space_effect = template.screen_space_effect

				arg_4_2.screen_space_id = ScriptUnit.has_extension(arg_4_0, "first_person_system"):create_screen_particles(screen_space_effect)

				World.set_particles_life_time(arg_4_3, arg_4_2.screen_space_id, arg_4_1.duration)
			end
		end
	end,
	update_vs_chaos_troll_regen = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		if arg_5_2.t > arg_5_2.next_tick then
			arg_5_2.next_tick = arg_5_2.t + arg_5_2.tick_rate

			if not Managers.state.network.is_server then
				DamageUtils.heal_network(arg_5_0, arg_5_0, arg_5_2.health_to_heal_per_tick, "health_regen")
			end
		end
	end,
	remove_vs_chaos_troll_regen = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		return
	end,
	update_vs_boss_mood = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
		if not fn(arg_7_0) then
			local template = arg_7_1.template
			local unit_owner = Managers.player:unit_owner(arg_7_0)
			local system = Managers.state.entity:system("camera_system")

			if not system and not unit_owner then
				-- Nothing
			end

			::label_7_1::

			local camera_units = system.camera_units

			camera_units = not camera_units and system.camera_units[unit_owner]

			::label_7_2::

			local var_7_4

			if not camera_units then
				local extension = ScriptUnit.extension(camera_units, "camera_state_machine_system")

				var_7_4 = not extension.state_machine.state_current and extension.state_machine.state_current.name
			end

			if not (not var_7_4 and var_7_4 == arg_7_2.previous_camera_state) then
				Managers.state.camera:set_mood(template.mood, arg_7_1, var_7_4 == "follow")
			end

			arg_7_2.previous_camera_state = var_7_4
		end
	end,
	start_vs_gutter_runner_smoke_bomb_invisibility = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
		-- function 8
		if not fn(arg_8_0) then
			ScriptUnit.extension(arg_8_0, "status_system"):set_invisible(true, nil, arg_8_1)
			Managers.state.camera:set_mood("gutter_runner_f", arg_8_1, true)
		end
	end,
	end_vs_gutter_runner_smoke_bomb_invisibility = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		-- function 9
		if not fn(arg_9_0) then
			ScriptUnit.extension(arg_9_0, "first_person_system"):play_unit_sound_event("Play_versus_gutterrunner_vanish_fps_end", arg_9_0, 0)

			local extension = ScriptUnit.extension(arg_9_0, "career_system")

			extension:set_state("default")
			extension:start_activated_ability_cooldown(1)
			ScriptUnit.extension(arg_9_0, "status_system"):set_invisible(false, nil, arg_9_1)

			if not Managers.state.network:game() then
				ScriptUnit.extension(arg_9_0, "status_system"):set_is_dodging(false)

				local network = Managers.state.network
				local network_transmit = network.network_transmit
				local unit_game_object_id = network:unit_game_object_id(arg_9_0)

				network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, false, unit_game_object_id, 0)
			end

			Managers.state.camera:set_mood("gutter_runner_f", arg_9_1, false)
		end
	end,
	apply_vs_warpfirethrower_long_distance_damage = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
		-- function 10
		local armor_category = Unit.get_data(arg_10_0, "breed").armor_category

		armor_category = armor_category or 1
		arg_10_1.armor_type = armor_category

		local has_extension = ScriptUnit.has_extension(arg_10_0, "first_person_system")

		if not has_extension then
			arg_10_1.warpfire_particle_id = has_extension:create_screen_particles("fx/screenspace_warpfire_hit_onfeet")
		end

		local attacker_unit

		if not ALIVE[arg_10_2.attacker_unit] then
			attacker_unit = arg_10_2.attacker_unit

			if not attacker_unit then
				-- Nothing
			end
		end

		attacker_unit = arg_10_0

		::label_10_0::

		if not Unit.alive(attacker_unit) then
			local get_data = Unit.get_data(attacker_unit, "breed")

			arg_10_1.damage = get_data.shoot_warpfire_long_attack_damage

			local name

			if not get_data then
				name = get_data.name

				if not name then
					-- Nothing
				end
			end

			name = "dot_debuff"

			::label_10_1::

			arg_10_1.damage_source = name
		end
	end,
	update_vs_warpfirethrower_long_distance_damage = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
		-- function 11
		local t = arg_11_2.t
		local template = arg_11_1.template

		if not Managers.state.network.is_server then
			local attacker_unit = arg_11_2.attacker_unit
			local has_buff_perk = ScriptUnit.has_extension(arg_11_0, "buff_system"):has_buff_perk("power_block")
			local flag = false

			if not has_buff_perk then
				flag = fn_3(arg_11_0, attacker_unit, arg_11_1, arg_11_2, arg_11_3)
			end

			if not flag and DamageUtils.check_ranged_block(attacker_unit, arg_11_0, "blocked_berzerker") or not HEALTH_ALIVE[arg_11_0] then
				local armor_type = arg_11_1.armor_type
				local damage_type = template.damage_type
				local var_11_7 = arg_11_1.damage[armor_type]
				local damage_source = arg_11_1.damage_source

				DamageUtils.add_damage_network(arg_11_0, attacker_unit, var_11_7, "torso", damage_type, nil, Vector3(1, 0, 0), damage_source, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end

		local has_extension = ScriptUnit.has_extension(arg_11_0, "first_person_system")

		if not has_extension then
			has_extension:play_hud_sound_event("Play_player_damage_puke")
		end

		return t + template.time_between_dot_damages
	end,
	remove_vs_warpfirethrower_long_distance_damage = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
		-- function 12
		local has_extension = ScriptUnit.has_extension(arg_12_0, "first_person_system")

		if not has_extension then
			has_extension:stop_spawning_screen_particles(arg_12_1.warpfire_particle_id)
		end
	end,
	apply_warpfirethrower_in_face_versus = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
		-- function 13
		local template = arg_13_1.template
		local has_extension = ScriptUnit.has_extension(arg_13_0, "first_person_system")

		if not has_extension then
			arg_13_1.warpfire_particle_id = has_extension:create_screen_particles("fx/screenspace_warpfire_flamethrower_01")
			arg_13_1.warpfire_particle_id_2 = has_extension:create_screen_particles("fx/screenspace_warpfire_hit_inface")

			has_extension:play_hud_sound_event("Play_player_hit_warpfire_thrower")
		end

		local attacker_unit = arg_13_2.attacker_unit

		if not Unit.alive(attacker_unit) then
			local get_data = Unit.get_data(attacker_unit, "breed")

			arg_13_1.damage = get_data.shoot_warpfire_long_attack_damage

			local name

			if not get_data then
				name = get_data.name

				if not name then
					-- Nothing
				end
			end

			name = "dot_debuff"

			::label_13_0::

			arg_13_1.damage_source = name
		end

		local get_data_2 = Unit.get_data(arg_13_0, "breed")
		local armor_category = get_data_2.armor_category

		armor_category = armor_category or 1
		arg_13_1.armor_type = armor_category

		if not get_data_2.is_hero and not has_extension then
			local has_extension_2 = ScriptUnit.has_extension(arg_13_0, "buff_system")
			local has_extension_3 = ScriptUnit.has_extension(arg_13_0, "status_system")

			if not (not not (not has_extension_2 and has_extension_2:has_buff_perk("no_ranged_knockback")) or not not has_extension_3:is_disabled() or not has_extension_3:has_noclip()) then
				local extension = ScriptUnit.extension(arg_13_0, "locomotion_system")
				local push_speed = template.push_speed
				local var_13_11

				if not ALIVE[attacker_unit] then
					local num = POSITION_LOOKUP[arg_13_0] - POSITION_LOOKUP[attacker_unit]

					var_13_11 = Vector3.normalize(num)
				else
					var_13_11 = Vector3.backward()
				end

				local num_2 = var_13_11 * push_speed

				extension:add_external_velocity(num_2)
			end
		end
	end
}
