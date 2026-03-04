-- chunkname: @scripts/settings/dlcs/grudge_marks/buff_settings_grudge_marks.lua

local var_0_0 = DLCSettings.grudge_marks
local var_0_1 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

local function var_0_2()
	return Managers.state.network.is_server
end

local function var_0_3(arg_2_0)
	if DEDICATED_SERVER then
		return false
	end

	local var_2_0 = Managers.player
	local var_2_1 = var_2_0:local_player()

	if var_2_0:unit_owner(arg_2_0) == var_2_1 then
		return true
	end

	return false
end

local function var_0_4(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for iter_3_0 = 1, #var_3_0 do
		if Vector3.distance_squared(arg_3_0, var_3_0[iter_3_0]) < arg_3_1.min_dist_sqr then
			return false
		end
	end

	return true
end

local var_0_5 = 10

var_0_0.buff_templates = {
	grudge_mark_health = {
		buffs = {
			{
				multiplier = 0.42,
				name = "grudge_mark_health",
				stat_buff = "max_health"
			},
			{
				remove_buff_func = "ai_update_max_health",
				name = "grudge_mark_health_update",
				apply_buff_func = "ai_update_max_health"
			}
		}
	},
	grudge_mark_elite_health = {
		buffs = {
			{
				multiplier = 2,
				name = "grudge_mark_health",
				stat_buff = "max_health"
			},
			{
				remove_buff_func = "ai_update_max_health",
				name = "grudge_mark_health_update",
				apply_buff_func = "ai_update_max_health"
			}
		}
	},
	grudge_mark_termite_health = {
		buffs = {
			{
				multiplier = 1,
				name = "grudge_mark_health",
				stat_buff = "max_health"
			},
			{
				remove_buff_func = "ai_update_max_health",
				name = "grudge_mark_health_update",
				apply_buff_func = "ai_update_max_health"
			}
		}
	},
	grudge_mark_termite_boss_raging = {
		buffs = {
			{
				buff_to_add = "grudge_mark_termite_boss_raging_buff",
				name = "grudge_mark_termite_boss_raging",
				update_func = "add_buff_based_on_health_chunks",
				chunk_amount = 4
			}
		}
	},
	grudge_mark_termite_boss_raging_buff = {
		activation_sound_3p = true,
		activation_sound = "enemy_grudge_raging",
		buffs = {
			{
				name = "grudge_mark_termite_particle_buff",
				max_stacks = 1,
				refresh_durations = true,
				duration = var_0_5,
				particles = {
					{
						orphaned_policy = "stop",
						first_person = false,
						third_person = true,
						effect = "fx/cw_khorne_boss",
						continuous = true,
						destroy_policy = "stop"
					}
				}
			},
			{
				multiplier = -0.5,
				name = "grudge_mark_termite_damage_taken_buff",
				stat_buff = "damage_taken",
				refresh_durations = true,
				max_stacks = 1,
				duration = var_0_5
			},
			{
				remove_buff_func = "remove_stagger_immunity",
				name = "grudge_mark_termite_stagger_immune_buff",
				refresh_durations = true,
				max_stacks = 1,
				apply_buff_func = "make_stagger_immune",
				duration = var_0_5
			},
			{
				multiplier = 0.25,
				name = "grudge_mark_termite_damage_dealt_buff",
				stat_buff = "damage_dealt",
				refresh_durations = true,
				max_stacks = 1,
				duration = var_0_5
			}
		}
	},
	grudge_mark_termite_health_small = {
		buffs = {
			{
				multiplier = -0.5,
				name = "grudge_mark_health",
				stat_buff = "max_health"
			}
		}
	},
	grudge_mark_dwarf_fest_troll_boss = {
		buffs = {
			{
				multiplier = 1.5,
				name = "grudge_mark_health",
				stat_buff = "max_health"
			},
			{
				remove_buff_func = "ai_update_max_health",
				name = "grudge_mark_health_update",
				apply_buff_func = "ai_update_max_health"
			}
		}
	},
	grudge_mark_damage = {
		buffs = {
			{
				multiplier = 0.2,
				name = "grudge_mark_damage",
				stat_buff = "damage_dealt"
			}
		}
	},
	grudge_mark_stagger_distance_resistance = {
		buffs = {
			{
				multiplier = -0.7,
				name = "grudge_mark_stagger_distance_resistance",
				stat_buff = "stagger_distance"
			}
		}
	},
	grudge_mark_warping = {
		buffs = {
			{
				proc_cooldown = 10,
				name = "grudge_mark_warping",
				buff_func = "random_teleport_ai",
				event = "on_damage_taken",
				proc_chance = 0.1,
				max_teleport_distance = 8,
				min_teleport_distance = 3,
				find_valid_pos_attempts = 5,
				min_dist_from_players = 3
			}
		}
	},
	grudge_mark_unstaggerable = {
		buffs = {
			{
				apply_buff_func = "make_stagger_immune",
				name = "grudge_mark_unstaggerable"
			}
		}
	},
	grudge_mark_raging = {
		buffs = {
			{
				buff_to_add = "grudge_mark_raging_buff",
				name = "grudge_mark_raging",
				update_frequency = 25,
				update_func = "add_buff",
				update_start_delay = 5
			}
		}
	},
	grudge_mark_raging_buff = {
		activation_sound_3p = true,
		activation_sound = "enemy_grudge_raging",
		buffs = {
			{
				multiplier = 1,
				name = "grudge_mark_raging_buff",
				stat_buff = "damage_dealt",
				duration = 10,
				particles = {
					{
						orphaned_policy = "stop",
						first_person = false,
						third_person = true,
						effect = "fx/cw_khorne_boss",
						continuous = true,
						destroy_policy = "stop"
					}
				}
			}
		}
	},
	grudge_mark_vampiric = {
		buffs = {
			{
				name = "grudge_mark_vampiric",
				multiplier = 2,
				buff_func = "ai_heal_on_damage_dealt",
				event = "on_damage_dealt",
				bonus = 0
			}
		}
	},
	grudge_mark_ranged_immune = {
		buffs = {
			{
				name = "grudge_mark_ranged_immune",
				perks = {
					var_0_1.invulnerable_ranged
				}
			}
		}
	},
	grudge_mark_periodic_shield = {
		buffs = {
			{
				buff_to_add = "grudge_mark_periodic_shield_buff",
				name = "grudge_mark_periodic_shield",
				update_frequency = 20,
				update_func = "add_buff",
				update_start_delay = 0
			}
		}
	},
	grudge_mark_periodic_shield_buff = {
		deactivation_sound = "enemy_grudge_shield_end",
		activation_sound_3p = true,
		activation_sound = "enemy_grudge_shield_start",
		buffs = {
			{
				duration = 5,
				name = "grudge_mark_periodic_shield_buff",
				perks = {
					var_0_1.invulnerable
				},
				particles = {
					{
						orphaned_policy = "stop",
						first_person = false,
						third_person = true,
						effect = "fx/cw_shield",
						continuous = true,
						destroy_policy = "stop"
					}
				}
			}
		}
	},
	grudge_mark_intangible = {
		buffs = {
			{
				num_mirrors = 3,
				name = "grudge_mark_intangible",
				update_func = "ai_spawn_mirror_images",
				update_dialogue_delay = 1,
				update_frequency_time = 45,
				update_start_delay = 5
			}
		}
	},
	grudge_mark_intangible_mirror = {
		buffs = {
			{
				multiplier = -1,
				name = "grudge_mark_intangible_mirror_damage",
				stat_buff = "damage_dealt",
				remove_buff_func = "remove_intangible_mirror_damage"
			},
			{
				multiplier = -10,
				name = "grudge_mark_intangible_mirror_health_stat",
				stat_buff = "max_health"
			},
			{
				remove_buff_func = "ai_update_max_health",
				name = "grudge_mark_intangible_mirror_health_update",
				apply_buff_func = "ai_update_max_health"
			}
		}
	},
	grudge_mark_crippling_blow = {
		buffs = {
			{
				event = "on_damage_dealt",
				name = "grudge_mark_crippling_blow",
				buff_to_add = "grudge_mark_crippling_blow_debuff",
				buff_func = "ai_add_buff_on_damage_dealt"
			}
		}
	},
	grudge_mark_crippling_blow_debuff = {
		buffs = {
			{
				name = "grudge_mark_crippling_blow_debuff_flow_event",
				flow_event = "sfx_vce_struggle",
				max_stacks = 1,
				duration = 5,
				apply_buff_func = "first_person_flow_event"
			},
			{
				update_func = "update_action_lerp_movement_buff",
				multiplier = 0.3,
				name = "grudge_mark_crippling_blow_slow_run",
				icon = "grudge_mark_crippling_debuff",
				priority_buff = true,
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_movement",
				lerp_time = 0.1,
				debuff = true,
				max_stacks = 1,
				duration = 5,
				path_to_movement_setting_to_modify = {
					"move_speed"
				},
				sfx = {
					activation_sound = "enemy_grudge_crippling_hit"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.3,
				name = "grudge_mark_crippling_blow_slow_crouch",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_crouch_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 5,
				path_to_movement_setting_to_modify = {
					"crouch_move_speed"
				}
			},
			{
				update_func = "update_charging_action_lerp_movement_buff",
				multiplier = 0.3,
				name = "grudge_mark_crippling_blow_slow_walk",
				remove_buff_func = "remove_action_lerp_movement_buff",
				apply_buff_func = "apply_action_lerp_movement_buff",
				remove_buff_name = "planted_return_to_normal_walk_movement",
				lerp_time = 0.1,
				max_stacks = 1,
				duration = 5,
				path_to_movement_setting_to_modify = {
					"walk_move_speed"
				}
			},
			{
				multiplier = 0.3,
				name = "grudge_mark_crippling_blow_jump_debuff",
				duration = 5,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"jump",
					"initial_vertical_speed"
				}
			},
			{
				multiplier = 0.5,
				name = "grudge_mark_crippling_blow_dodge_speed_debuff",
				duration = 5,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"speed_modifier"
				}
			},
			{
				multiplier = 0.5,
				name = "grudge_mark_crippling_blow_dodge_distance_debuff",
				duration = 5,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				path_to_movement_setting_to_modify = {
					"dodging",
					"distance_modifier"
				}
			}
		}
	},
	grudge_mark_crushing_blow = {
		buffs = {
			{
				buff_to_add = "grudge_mark_crushing_blow_debuff",
				name = "grudge_mark_crushing_blow",
				buff_func = "ai_crushing_blow",
				event = "on_damage_dealt",
				perks = {
					var_0_1.ai_unblockable
				}
			},
			{
				remove_buff_func = "ai_remove_hit_sfx",
				name = "grudge_mark_crushing_blow_sfx",
				apply_buff_func = "ai_add_hit_sfx",
				hit_sfx_name = "enemy_grudge_crushing_hit"
			}
		}
	},
	grudge_mark_crushing_blow_debuff = {
		buffs = {
			{
				duration = 8,
				name = "grudge_mark_crushing_blow_debuff",
				stat_buff = "max_fatigue",
				debuff = true,
				max_stacks = 20,
				refresh_durations = true,
				icon = "troll_vomit_debuff",
				bonus = -1
			}
		}
	},
	grudge_mark_regeneratig = {
		buffs = {
			{
				frequency = 1,
				name = "grudge_mark_regeneratig",
				part_healed_of_max_heath = 0.02,
				buff_func = "ai_delay_regen",
				event = "on_damage_taken",
				update_func = "ai_health_regen_update",
				on_hit_delay = 3
			}
		}
	},
	grudge_mark_periodic_curse_aura = {
		buffs = {
			{
				buff_to_add = "grudge_mark_curse",
				name = "grudge_mark_periodic_curse_aura",
				update_frequency = 0.5,
				time_between_curses = 2,
				update_start_delay = 0,
				max_distance = 4,
				update_func = "apply_curse_to_nearby_players",
				sound_on_enter = "enemy_grudge_cursed_enter",
				particles = {
					{
						orphaned_policy = "stop",
						first_person = false,
						third_person = true,
						effect = "fx/gm_cursed_aoe",
						continuous = true,
						destroy_policy = "stop",
						custom_variables = {
							{
								name = "radius",
								value = {
									4,
									4,
									1
								}
							},
							{
								name = "diameter",
								value = {
									8,
									8,
									1
								}
							}
						}
					}
				}
			}
		}
	},
	grudge_mark_curse = {
		deactivation_sound = "enemy_grudge_cursed_exit",
		activation_sound = "enemy_grudge_cursed_damage",
		buffs = {
			{
				icon = "grudge_mark_cursed_debuff",
				name = "grudge_mark_curse",
				stat_buff = "health_curse",
				debuff = true,
				max_stacks = 20,
				duration = 5,
				refresh_durations = true,
				bonus = -0.05
			}
		}
	},
	grudge_mark_commander = {
		buffs = {
			{
				update_frequency = 40,
				name = "grudge_mark_commander",
				update_func = "trigger_terror_event",
				update_start_delay = 8,
				faction_terror_events = {
					default = "grudge_mark_commander_terror_event_skaven",
					skaven = "grudge_mark_commander_terror_event_skaven",
					beastmen = "grudge_mark_commander_terror_event_beastmen",
					chaos = "grudge_mark_commander_terror_event_chaos"
				}
			}
		}
	},
	grudge_mark_frenzy = {
		buffs = {
			{
				buff_to_add = "grudge_mark_frenzy_handler",
				name = "grudge_mark_frenzy",
				stacking_buff = "grudge_mark_frenzy_stack",
				buff_func = "add_frenzy_handler",
				event = "on_damage_taken",
				remove_buff_func = "remove_frenzy_handlers"
			}
		}
	},
	grudge_mark_frenzy_handler = {
		buffs = {
			{
				buff_to_add = "grudge_mark_frenzy_stack",
				name = "grudge_mark_frenzy_handler",
				blocker_buff = "grudge_mark_frenzy_buff",
				buff_func = "add_frenzy_stack",
				event = "on_melee_hit",
				apply_buff_func = "add_extra_frenzy_stack"
			}
		}
	},
	grudge_mark_frenzy_stack = {
		buffs = {
			{
				reset_on_max_stacks = true,
				name = "grudge_mark_frenzy_stack",
				icon = "grudge_mark_frenzy_debuff",
				max_stacks = 10,
				refresh_durations = true,
				debuff = true,
				on_max_stacks_func = "add_remove_buffs",
				duration = 3,
				max_stack_data = {
					buffs_to_add = {
						"grudge_mark_frenzy_buff"
					}
				}
			}
		}
	},
	grudge_mark_frenzy_buff = {
		deactivation_sound = "enemy_grudge_frenzy_end",
		buffs = {
			{
				buff_to_add = "grudge_mark_frenzy_buff",
				name = "grudge_mark_frenzy_buff",
				icon = "grudge_mark_frenzy_debuff",
				buff_func = "add_buff",
				event = "on_melee_hit",
				refresh_durations = true,
				apply_buff_func = "apply_frenzy_func",
				remove_buff_func = "remove_frenzy_func",
				max_stacks = 1,
				duration = 5
			},
			{
				name = "grudge_mark_frenzy_buff_attack_speed",
				multiplier = 0.25,
				stat_buff = "attack_speed",
				duration = 5,
				max_stacks = 1,
				refresh_durations = true
			},
			{
				refresh_durations = true,
				name = "grudge_mark_frenzy_buff_move_speed",
				multiplier = 1.25,
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				duration = 5,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			},
			{
				refresh_durations = true,
				multiplier = 0.2,
				stat_buff = "power_level_melee",
				buff_func = "deus_reckless_swings_buff_on_hit",
				event = "on_melee_hit",
				damage_to_deal = 10,
				name = "grudge_mark_frenzy_buff_reckless_swings",
				is_non_lethal = true,
				max_stacks = 1,
				duration = 5
			}
		}
	},
	grudge_mark_shockwave_attacks = {
		buffs = {
			{
				event = "minion_attack_used",
				name = "grudge_mark_shockwave_attacks",
				buff_func = "grudge_mark_shockwave"
			}
		}
	},
	grudge_mark_ignore_death_aura = {
		buffs = {
			{
				buff_to_add = "grudge_mark_ignore_death_buff",
				name = "grudge_mark_ignore_death_aura",
				remove_buff_func = "grudge_mark_ignore_death_aura_cleanup",
				radius = 4,
				update_func = "grudge_mark_ignore_death_aura_update",
				update_frequency = 1
			}
		}
	},
	grudge_mark_ignore_death_buff = {
		buffs = {
			{
				name = "grudge_mark_ignore_death_buff",
				perks = {
					var_0_1.ignore_death
				}
			}
		}
	}
}
var_0_0.buff_function_templates = {
	make_stagger_immune = function (arg_4_0, arg_4_1, arg_4_2)
		if ALIVE[arg_4_0] then
			local var_4_0 = BLACKBOARDS[arg_4_0]

			if var_4_0 then
				var_4_0.stagger_immunity = {
					health_threshold = 0
				}
			end
		end
	end,
	remove_stagger_immunity = function (arg_5_0, arg_5_1, arg_5_2)
		if ALIVE[arg_5_0] then
			local var_5_0 = BLACKBOARDS[arg_5_0]

			if var_5_0 then
				local var_5_1 = {
					health_threshold = 0
				}

				var_5_0.stagger_immunity = nil
			end
		end
	end,
	apply_buff_to_all_players = function (arg_6_0, arg_6_1, arg_6_2)
		if not var_0_2() then
			return
		end

		if ALIVE[arg_6_0] then
			local var_6_0 = Managers.state.side:get_side_from_name("heroes")
			local var_6_1 = arg_6_1.template.buff_to_add
			local var_6_2 = Managers.state.entity:system("buff_system")
			local var_6_3 = var_6_0.PLAYER_AND_BOT_UNITS

			for iter_6_0 = 1, #var_6_3 do
				local var_6_4 = var_6_3[iter_6_0]

				var_6_2:add_buff(var_6_4, var_6_1, arg_6_0, false)
			end

			local var_6_5 = arg_6_1.template.effect_name

			if var_6_5 then
				local var_6_6 = POSITION_LOOKUP[arg_6_0]

				Managers.state.network:rpc_play_particle_effect(nil, NetworkLookup.effects[var_6_5], NetworkConstants.invalid_game_object_id, 0, var_6_6, Quaternion.identity(), false)
			end
		end
	end,
	remove_intangible_mirror_damage = function (arg_7_0, arg_7_1, arg_7_2)
		Managers.state.entity:system("audio_system"):play_audio_unit_event("enemy_grudge_intangible_destroy", arg_7_0)
	end,
	add_buff_based_on_health_chunks = function (arg_8_0, arg_8_1, arg_8_2)
		if not var_0_2() then
			return
		end

		if ALIVE[arg_8_0] then
			local var_8_0 = ScriptUnit.extension(arg_8_0, "health_system")
			local var_8_1 = ScriptUnit.extension(arg_8_0, "buff_system")
			local var_8_2 = Managers.state.entity:system("buff_system")
			local var_8_3 = arg_8_1.template
			local var_8_4 = var_8_3.buff_to_add
			local var_8_5 = var_8_0:get_max_health() / var_8_3.chunk_amount
			local var_8_6 = var_8_0:get_damage_taken()

			arg_8_1.next_chunk = arg_8_1.next_chunk or var_8_5

			if var_8_6 >= arg_8_1.next_chunk then
				var_8_2:add_buff_synced(arg_8_0, var_8_4, BuffSyncType.All)

				arg_8_1.next_chunk = arg_8_1.next_chunk + var_8_5
			end

			if var_8_5 > var_8_0:current_health() then
				var_8_2:add_buff_synced(arg_8_0, var_8_4, BuffSyncType.All)
			end
		end
	end,
	ai_spawn_mirror_images = function (arg_9_0, arg_9_1, arg_9_2)
		if not var_0_2() then
			return
		end

		local var_9_0 = arg_9_2.t

		if not arg_9_1.update_frequency_time then
			arg_9_1.update_frequency_time = var_9_0 + arg_9_1.template.update_frequency_time
		end

		if var_9_0 < arg_9_1.update_frequency_time and arg_9_1.first_update_done then
			local var_9_1 = arg_9_1.template.update_dialogue_delay

			if var_9_1 and not arg_9_1.update_dialogue_done then
				if not arg_9_1.update_dialogue_delay_time then
					arg_9_1.update_dialogue_delay_time = var_9_0 + var_9_1
				end

				if var_9_0 > arg_9_1.update_dialogue_delay_time then
					local var_9_2 = "curse_very_negative_effect_happened"
					local var_9_3 = Managers.state.entity:system("dialogue_system"):get_random_player()

					if var_9_3 ~= nil then
						local var_9_4 = ScriptUnit.extension_input(var_9_3, "dialogue_system")
						local var_9_5 = FrameTable.alloc_table()

						var_9_4:trigger_dialogue_event(var_9_2, var_9_5)
					end

					arg_9_1.update_dialogue_done = true
				end
			end

			return
		end

		arg_9_1.update_frequency_time = var_9_0 + arg_9_1.template.update_frequency_time
		arg_9_1.first_update_done = true

		local function var_9_6()
			if ALIVE[arg_9_0] then
				local var_10_0 = BLACKBOARDS[arg_9_0]
				local var_10_1 = var_10_0.breed
				local var_10_2 = Managers.state.side.side_by_unit[arg_9_0]
				local var_10_3 = POSITION_LOOKUP[arg_9_0]
				local var_10_4 = 4
				local var_10_5 = 10
				local var_10_6 = 5
				local var_10_7 = "fx/grudge_marks_illusionist"
				local var_10_8 = "enemy_grudge_intangible"
				local var_10_9 = ConflictUtils.get_spawn_pos_on_circle(var_10_0.nav_world, var_10_3, var_10_5, var_10_4, var_10_6, nil, nil, nil, 8, 8)

				if var_10_9 then
					ConflictUtils.teleport_ai_unit(arg_9_0, var_10_9, var_10_8, var_10_7)
				end

				local var_10_10 = {
					{
						"grudge_mark_intangible_mirror",
						no_attribute = true,
						name = "mirror_base"
					}
				}
				local var_10_11 = Managers.state.entity:system("ai_system"):get_attributes(arg_9_0)
				local var_10_12 = var_10_11.breed_enhancements

				for iter_10_0, iter_10_1 in pairs(var_10_12) do
					if iter_10_1 and (iter_10_0 == "intangible" or true) then
						iter_10_0 = "intangible_mirror"
						var_10_10[#var_10_10 + 1] = BreedEnhancements[iter_10_0]
					end
				end

				local var_10_13 = var_10_11.grudge_marked.name_index
				local var_10_14 = arg_9_1._mirror_units or {}

				arg_9_1._mirror_units = var_10_14

				for iter_10_2 = 1, #var_10_14 do
					local var_10_15 = var_10_14[iter_10_2]

					if ALIVE[var_10_15] then
						AiUtils.kill_unit(var_10_15, arg_9_0)
					end
				end

				table.clear(var_10_14)

				local var_10_16 = {}
				local var_10_17 = 6.25

				local function var_10_18(arg_11_0, arg_11_1)
					for iter_11_0 = 1, #arg_11_1 do
						if Vector3.distance_squared(arg_11_0, arg_11_1[iter_11_0]) < var_10_17 then
							return false
						end
					end

					local var_11_0 = var_10_2.ENEMY_PLAYER_AND_BOT_POSITIONS

					for iter_11_1 = 1, #var_11_0 do
						if Vector3.distance_squared(arg_11_0, var_11_0[iter_11_1]) < var_10_17 then
							return false
						end
					end

					return true
				end

				local var_10_19 = arg_9_1.template.num_mirrors

				for iter_10_3 = 1, var_10_19 do
					local var_10_20 = ConflictUtils.get_spawn_pos_on_circle_with_func(var_10_0.nav_world, var_10_3, var_10_5, var_10_4, var_10_6, var_10_18, var_10_16, 8, 8)

					if var_10_20 then
						var_10_16[#var_10_16 + 1] = var_10_20

						local var_10_21 = {
							side_id = var_10_2.side_id,
							spawned_func = function (arg_12_0, arg_12_1, arg_12_2)
								local var_12_0 = BLACKBOARDS[arg_12_0]

								var_12_0.deny_kill_loot = true
								var_12_0.is_illusion = true

								local var_12_1 = arg_9_1._mirror_units

								if var_12_1 then
									var_12_1[#var_12_1 + 1] = arg_12_0
								end

								local var_12_2 = ScriptUnit.has_extension(arg_12_0, "health_system")

								if var_12_2.force_set_wounded then
									var_12_2:force_set_wounded()
								end

								ScriptUnit.extension(arg_12_0, "death_system"):override_death_behavior(0, "fx/mutator_death_03")
								Managers.state.entity:system("death_system"):set_death_reaction_template(arg_12_0, "despawn")
							end,
							enhancements = var_10_10,
							name_index = var_10_13
						}
						local var_10_22 = ConflictUtils.get_closest_position(var_10_20, var_10_2.ENEMY_PLAYER_AND_BOT_POSITIONS)
						local var_10_23 = ConflictUtils.look_at_position_flat(var_10_20, var_10_22)

						Managers.state.conflict:spawn_queued_unit(var_10_1, Vector3Box(var_10_20), QuaternionBox(var_10_23), "mirror_spawn", nil, nil, var_10_21, nil)

						local var_10_24 = NetworkLookup.effects[var_10_7]
						local var_10_25 = 0
						local var_10_26 = Quaternion.identity()

						Managers.state.network:rpc_play_particle_effect(nil, var_10_24, NetworkConstants.invalid_game_object_id, var_10_25, var_10_20, var_10_26, false)
					end
				end
			end
		end

		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_9_6)
	end,
	ai_spawn_liquid_blob = function (arg_13_0, arg_13_1, arg_13_2)
		if not var_0_2() then
			return
		end

		local function var_13_0()
			if ALIVE[arg_13_0] then
				local var_14_0 = BLACKBOARDS[arg_13_0]
				local var_14_1 = POSITION_LOOKUP[arg_13_0]
				local var_14_2 = 1
				local var_14_3 = 3
				local var_14_4 = 5
				local var_14_5 = ConflictUtils.get_spawn_pos_on_circle(var_14_0.nav_world, var_14_1, var_14_3, var_14_2, var_14_4)

				if not var_14_5 then
					return
				end

				Managers.state.entity:system("audio_system"):play_audio_unit_event("enemy_grudge_bubonic_spawn", arg_13_0)

				local var_14_6 = AiUtils.spawn_nurgle_liquid_blob_dynamic(Managers.state.network, var_14_5, arg_13_0)
				local var_14_7 = Managers.state.side
				local var_14_8 = (var_14_7.side_by_unit[arg_13_0] or var_14_7:get_side_from_name("dark_pact")).side_id

				var_14_7:add_unit_to_side(var_14_6, var_14_8)
			end
		end

		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_13_0)
	end,
	ai_health_regen_update = function (arg_15_0, arg_15_1, arg_15_2)
		local var_15_0 = Managers.time:time("game")
		local var_15_1 = arg_15_1.template.frequency

		if not arg_15_1.timer then
			arg_15_1.timer = var_15_0 + var_15_1
		end

		if var_15_0 < arg_15_1.timer then
			return
		end

		arg_15_1.timer = var_15_0 + var_15_1

		if var_0_2() and HEALTH_ALIVE[arg_15_0] then
			local var_15_2 = ScriptUnit.has_extension(arg_15_0, "health_system")
			local var_15_3 = var_15_2:get_max_health() * arg_15_1.template.part_healed_of_max_heath

			var_15_2:add_heal(arg_15_0, var_15_3, nil, "leech")
		end
	end,
	apply_curse_to_nearby_players = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
		local var_16_0 = arg_16_1.template
		local var_16_1 = var_16_0.max_distance
		local var_16_2 = POSITION_LOOKUP[arg_16_0]

		arg_16_1.cursed_players = arg_16_1.cursed_players or {}
		arg_16_1.inside_last_frame = arg_16_1.inside_last_frame or {}

		local var_16_3 = arg_16_1.inside_last_frame
		local var_16_4 = arg_16_1.cursed_players
		local var_16_5 = Managers.player:local_player().player_unit
		local var_16_6 = Managers.state.entity:system("proximity_system").player_units_broadphase
		local var_16_7 = FrameTable.alloc_table()
		local var_16_8 = Broadphase.query(var_16_6, var_16_2, var_16_1, var_16_7)
		local var_16_9 = FrameTable.alloc_table()

		for iter_16_0 = 1, var_16_8 do
			local var_16_10 = var_16_7[iter_16_0]

			var_16_9[var_16_10] = true

			if not var_16_3[var_16_10] then
				if var_16_10 == var_16_5 and ALIVE[var_16_10] then
					local var_16_11 = ScriptUnit.extension(var_16_10, "buff_system")
					local var_16_12 = var_16_0.buff_to_add

					if var_16_11:num_buff_stacks(var_16_12) == 0 then
						local var_16_13 = Managers.world:wwise_world(arg_16_3)

						WwiseWorld.trigger_event(var_16_13, var_16_0.sound_on_enter)
					end
				end

				var_16_4[var_16_10] = true
				var_16_3[var_16_10] = true
			end
		end

		if var_0_2() then
			local var_16_14 = Managers.time:time("game")

			arg_16_1.last_curse_t = arg_16_1.last_curse_t or var_16_14

			local var_16_15 = var_16_0.time_between_curses
			local var_16_16 = arg_16_1.last_curse_t + var_16_15
			local var_16_17 = var_16_16 <= var_16_14

			for iter_16_1, iter_16_2 in pairs(var_16_4) do
				if var_16_17 then
					if var_16_9[iter_16_1] then
						local var_16_18 = var_16_0.buff_to_add

						Managers.state.entity:system("buff_system"):add_buff(iter_16_1, var_16_18, arg_16_0)
					else
						var_16_4[iter_16_1] = nil
					end
				end

				var_16_3[iter_16_1] = var_16_9[iter_16_1] and true or nil
			end

			arg_16_1.last_curse_t = var_16_17 and var_16_16 or arg_16_1.last_curse_t
		elseif ALIVE[var_16_5] then
			var_16_3[var_16_5] = var_16_9[var_16_5] and true or nil
		end
	end,
	ai_create_explosion = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
		if not var_0_2() or not ALIVE[arg_17_0] then
			return
		end

		local var_17_0 = arg_17_1.template
		local var_17_1 = var_17_0.explosion_template_name
		local var_17_2 = var_17_0.damage_source_name or "buff"
		local var_17_3 = POSITION_LOOKUP[arg_17_0] or Unit.world_position(arg_17_0, 0)
		local var_17_4 = ExplosionUtils.get_template(var_17_1)

		DamageUtils.create_explosion(arg_17_3, arg_17_0, var_17_3, Quaternion.identity(), var_17_4, 1, var_17_2, true, false, arg_17_0, 0, false)

		local var_17_5 = Managers.state.unit_storage:go_id(arg_17_0)
		local var_17_6 = NetworkLookup.explosion_templates[var_17_1]
		local var_17_7 = NetworkLookup.damage_sources[var_17_2]

		Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_17_5, false, var_17_3, Quaternion.identity(), var_17_6, 1, var_17_7, 0, false, var_17_5)
	end,
	ai_add_hit_sfx = function (arg_18_0, arg_18_1, arg_18_2)
		local var_18_0 = arg_18_1.template
		local var_18_1 = var_18_0 and var_18_0.hit_sfx_name

		if var_18_1 then
			local var_18_2 = ScriptUnit.has_extension(arg_18_0, "ai_inventory_system")

			if var_18_2 then
				arg_18_1._override_id = var_18_2:add_additional_hit_sfx(var_18_1)
			end
		end
	end,
	ai_remove_hit_sfx = function (arg_19_0, arg_19_1, arg_19_2)
		local var_19_0 = ScriptUnit.has_extension(arg_19_0, "ai_inventory_system")

		if var_19_0 then
			var_19_0:remove_additioanl_hit_sfx(arg_19_1._override_id)

			arg_19_1._override_id = nil
		end
	end,
	first_person_flow_event = function (arg_20_0, arg_20_1, arg_20_2)
		local var_20_0 = arg_20_1.template.flow_event

		if var_0_3(arg_20_0) then
			local var_20_1 = ScriptUnit.has_extension(arg_20_0, "first_person_system")
			local var_20_2 = var_20_1 and var_20_1:get_first_person_unit()

			if var_20_2 then
				Unit.flow_event(var_20_2, var_20_0)
			end
		end
	end,
	remove_all_stamina = function (arg_21_0, arg_21_1, arg_21_2)
		if var_0_3(arg_21_0) then
			local var_21_0 = ScriptUnit.has_extension(arg_21_0, "status_system")

			if var_21_0 then
				var_21_0:add_fatigue_points("complete", arg_21_2.attacker_unit)
			end
		end
	end,
	trigger_terror_event = function (arg_22_0, arg_22_1, arg_22_2)
		if not var_0_2() or not ALIVE[arg_22_0] then
			return
		end

		local var_22_0 = arg_22_1.template.faction_terror_events
		local var_22_1 = BLACKBOARDS[arg_22_0]
		local var_22_2 = var_22_1 and var_22_1.breed
		local var_22_3 = var_22_0[var_22_2 and var_22_2.race] or var_22_0.default
		local var_22_4 = arg_22_1.seed or Managers.mechanism:get_level_seed()

		Managers.state.conflict:start_terror_event(var_22_3, var_22_4, arg_22_0)

		arg_22_1.seed = Math.next_random(var_22_4)
	end,
	add_extra_frenzy_stack = function (arg_23_0, arg_23_1, arg_23_2)
		if ALIVE[arg_23_0] then
			local var_23_0 = ScriptUnit.has_extension(arg_23_0, "buff_system")

			if var_23_0 then
				var_23_0:add_buff(arg_23_1.template.buff_to_add)
			end
		end
	end,
	frenzy_damage_over_time = function (arg_24_0, arg_24_1, arg_24_2)
		if not var_0_2() then
			return
		end

		if ALIVE[arg_24_0] then
			local var_24_0 = ScriptUnit.has_extension(arg_24_0, "health_system")

			if not var_24_0 then
				return
			end

			local var_24_1 = var_24_0:current_health()
			local var_24_2 = arg_24_1.template.damage_per_tick

			if var_24_1 <= var_24_2 then
				var_24_2 = var_24_1 - 1
			end

			if var_24_2 > 0 then
				DamageUtils.add_damage_network(arg_24_0, arg_24_0, var_24_2, "torso", "buff", nil, Vector3(0, 0, 0), "buff", nil, arg_24_0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end
	end,
	apply_frenzy_func = function (arg_25_0, arg_25_1, arg_25_2)
		if ALIVE[arg_25_0] then
			local var_25_0 = Managers.player:owner(arg_25_0)

			if var_25_0 and not var_25_0.remote then
				Managers.state.camera:set_mood("skill_zealot", arg_25_1, true)
			end

			local var_25_1 = ScriptUnit.has_extension(arg_25_0, "first_person_system")

			if var_25_1 then
				var_25_1:play_hud_sound_event("enemy_grudge_frenzy_start")
			end
		end
	end,
	remove_frenzy_func = function (arg_26_0, arg_26_1, arg_26_2)
		if ALIVE[arg_26_0] then
			local var_26_0 = Managers.player:owner(arg_26_0)

			if var_26_0 and not var_26_0.remote then
				Managers.state.camera:set_mood("skill_zealot", arg_26_1, false)
			end
		end
	end,
	remove_frenzy_handlers = function (arg_27_0, arg_27_1, arg_27_2)
		if arg_27_1.buff_ids then
			local var_27_0 = Managers.state.entity:system("buff_system")

			for iter_27_0, iter_27_1 in pairs(arg_27_1.buff_ids) do
				if ALIVE[iter_27_0] then
					var_27_0:remove_server_controlled_buff(iter_27_0, iter_27_1)
				end
			end
		end
	end,
	grudge_mark_ignore_death_aura_update = function (arg_28_0, arg_28_1, arg_28_2)
		local var_28_0 = Managers.state.side.side_by_unit[arg_28_0].ally_broadphase_categories
		local var_28_1 = FrameTable.alloc_table()
		local var_28_2 = POSITION_LOOKUP[arg_28_0]
		local var_28_3 = arg_28_1.template.radius
		local var_28_4 = AiUtils.broadphase_query(var_28_2, var_28_3, var_28_1, var_28_0)
		local var_28_5 = arg_28_1.template.buff_to_add
		local var_28_6 = FrameTable.alloc_table()
		local var_28_7 = arg_28_1.inside_allies or {}

		arg_28_1.inside_allies = var_28_7

		for iter_28_0 = 1, var_28_4 do
			local var_28_8 = var_28_1[iter_28_0]

			if var_28_8 ~= arg_28_0 then
				local var_28_9 = ScriptUnit.has_extension(var_28_8, "buff_system")

				if var_28_9 then
					if not var_28_7[var_28_8] then
						var_28_7[var_28_8] = var_28_9:add_buff(var_28_5)
					end

					var_28_6[var_28_8] = true
				end
			end
		end

		for iter_28_1, iter_28_2 in pairs(var_28_7) do
			if not var_28_6[iter_28_1] then
				local var_28_10 = ScriptUnit.has_extension(iter_28_1, "buff_system")

				if var_28_10 then
					var_28_10:remove_buff(iter_28_2)
				end

				var_28_7[iter_28_1] = nil
			end
		end
	end,
	grudge_mark_ignore_death_aura_cleanup = function (arg_29_0, arg_29_1, arg_29_2)
		local var_29_0 = arg_29_1.inside_allies

		if not var_29_0 then
			return
		end

		for iter_29_0, iter_29_1 in pairs(var_29_0) do
			local var_29_1 = ScriptUnit.has_extension(iter_29_0, "buff_system")

			if var_29_1 then
				var_29_1:remove_buff(iter_29_1)
			end
		end

		arg_29_1.inside_allies = nil
	end
}
var_0_0.proc_functions = {
	add_frenzy_handler = function (arg_30_0, arg_30_1, arg_30_2)
		if not var_0_2() then
			return
		end

		local var_30_0 = arg_30_2[1]
		local var_30_1 = arg_30_2[4]

		if ALIVE[arg_30_0] and ALIVE[var_30_0] and MeleeAttackTypes[var_30_1] then
			local var_30_2 = arg_30_1.template.buff_to_add
			local var_30_3 = Managers.state.entity:system("buff_system")

			if not arg_30_1.buff_ids then
				arg_30_1.buff_ids = {}
			end

			if not arg_30_1.buff_ids[var_30_0] then
				arg_30_1.buff_ids[var_30_0] = var_30_3:add_buff(var_30_0, var_30_2, arg_30_0, true)
			end
		end
	end,
	add_frenzy_stack = function (arg_31_0, arg_31_1, arg_31_2)
		local var_31_0 = arg_31_2[1]

		if ALIVE[arg_31_0] and ALIVE[var_31_0] then
			if not arg_31_1.attacker_unit or var_31_0 ~= arg_31_1.attacker_unit then
				return
			end

			local var_31_1 = ScriptUnit.has_extension(arg_31_0, "buff_system")

			if var_31_1 and not var_31_1:has_buff_type(arg_31_1.template.blocker_buff) then
				var_31_1:add_buff(arg_31_1.template.buff_to_add)
			end
		end
	end,
	spawn_liquid_forward = function (arg_32_0, arg_32_1, arg_32_2)
		if not var_0_2() then
			return
		end

		BuffUtils.create_liquid_forward(arg_32_0, arg_32_1)
	end,
	ai_add_buff_on_damage_dealt = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
		local var_33_0 = arg_33_2[arg_33_4.attacked_unit]
		local var_33_1 = arg_33_2[arg_33_4.damage_amount]

		if ALIVE[var_33_0] and var_33_1 > 0 then
			local var_33_2 = arg_33_1.template.buff_to_add
			local var_33_3 = ScriptUnit.extension(var_33_0, "buff_system")
			local var_33_4 = Managers.state.network
			local var_33_5 = var_33_4.network_transmit
			local var_33_6 = var_33_4:unit_game_object_id(var_33_0)
			local var_33_7 = NetworkLookup.buff_templates[var_33_2]

			if var_0_2() then
				var_33_3:add_buff(var_33_2, {
					attacker_unit = var_33_0
				})
				var_33_5:send_rpc_clients("rpc_add_buff", var_33_6, var_33_7, var_33_6, 0, false)
			else
				var_33_5:send_rpc_server("rpc_add_buff", var_33_6, var_33_7, var_33_6, 0, true)
			end
		end
	end,
	ai_delay_regen = function (arg_34_0, arg_34_1, arg_34_2)
		local var_34_0 = Managers.time:time("game")
		local var_34_1 = arg_34_1.template.on_hit_delay

		if not arg_34_1.timer then
			arg_34_1.timer = var_34_0 + var_34_1
		end

		arg_34_1.timer = var_34_0 + var_34_1
	end,
	ai_heal_on_damage_dealt = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
		if not var_0_2() then
			return
		end

		local var_35_0 = arg_35_2[arg_35_4.attacked_unit]

		if ALIVE[arg_35_0] and ALIVE[var_35_0] and DamageUtils.is_enemy(arg_35_0, var_35_0) then
			local var_35_1 = ScriptUnit.has_extension(arg_35_0, "health_system")

			if var_35_1 and var_35_1:is_alive() then
				local var_35_2 = arg_35_2[arg_35_4.damage_amount]
				local var_35_3 = arg_35_1.template
				local var_35_4 = var_35_3.multiplier or 1
				local var_35_5 = var_35_3.bonus or 0
				local var_35_6 = math.clamp(var_35_2 * var_35_4 + var_35_5, 0, 255)

				var_35_1:add_heal(arg_35_0, var_35_6, nil, "leech")
			end
		end
	end,
	random_teleport_ai = function (arg_36_0, arg_36_1, arg_36_2)
		if not var_0_2() then
			return
		end

		local function var_36_0()
			if ALIVE[arg_36_0] then
				local var_37_0 = BLACKBOARDS[arg_36_0]
				local var_37_1 = POSITION_LOOKUP[arg_36_0]
				local var_37_2 = arg_36_1.template
				local var_37_3 = var_37_2.min_teleport_distance
				local var_37_4 = var_37_2.max_teleport_distance
				local var_37_5 = var_37_2.find_valid_pos_attempts
				local var_37_6 = var_37_2.min_dist_from_players
				local var_37_7 = Managers.state.side.side_by_unit[arg_36_0]
				local var_37_8 = {
					side = var_37_7,
					min_dist_sqr = var_37_6 * var_37_6
				}
				local var_37_9 = ConflictUtils.get_spawn_pos_on_circle_with_func_range(var_37_0.nav_world, var_37_1, var_37_3, var_37_4, var_37_5, var_0_4, var_37_8, 8, 8)

				if var_37_9 then
					local var_37_10 = "enemy_grudge_warping"
					local var_37_11 = "fx/grudge_marks_shadow_step"

					ConflictUtils.teleport_ai_unit(arg_36_0, var_37_9, var_37_10, var_37_11)
				end
			end
		end

		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_36_0)
	end,
	ai_crushing_blow = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
		if not var_0_2() or not ALIVE[arg_38_0] then
			return
		end

		local var_38_0 = arg_38_2[arg_38_4.attacked_unit]
		local var_38_1 = BLACKBOARDS[arg_38_0]
		local var_38_2 = ScriptUnit.has_extension(var_38_0, "status_system")

		if var_38_1 and var_38_1.hit_through_block and var_38_2 then
			local var_38_3 = ScriptUnit.extension(var_38_0, "buff_system")
			local var_38_4 = arg_38_1.template.buff_to_add
			local var_38_5 = var_38_1.action

			if var_38_5 and var_38_5.fatigue_type then
				local var_38_6, var_38_7, var_38_8, var_38_9 = var_38_2:can_block(arg_38_0)
				local var_38_10 = var_38_5.fatigue_type

				if type(var_38_10) == "table" then
					var_38_10 = Managers.state.difficulty:get_difficulty_value_from_table(var_38_10)
				end

				var_38_2:blocked_attack(var_38_10, arg_38_0, var_38_7, var_38_8, var_38_9)

				if var_0_2() then
					local var_38_11 = Managers.state.network
					local var_38_12 = Managers.state.unit_storage:go_id(var_38_0)
					local var_38_13 = NetworkLookup.fatigue_types[var_38_10]
					local var_38_14, var_38_15 = var_38_11:game_object_or_level_id(arg_38_0)

					var_38_11.network_transmit:send_rpc_clients("rpc_player_blocked_attack", var_38_12, var_38_13, var_38_14, var_38_7, var_38_8, var_38_9, var_38_15)
				end
			end

			local var_38_16 = arg_38_2[arg_38_4.PROC_MODIFIABLE]

			var_38_16.damage_amount = 0

			if var_38_5 and var_38_5.blocked_damage then
				var_38_16.damage_amount = var_38_5.blocked_damage
			end

			local var_38_17 = Managers.state.network
			local var_38_18 = var_38_17.network_transmit
			local var_38_19 = var_38_17:unit_game_object_id(var_38_0)
			local var_38_20 = NetworkLookup.buff_templates[var_38_4]

			if var_0_2() then
				var_38_3:add_buff(var_38_4, {
					attacker_unit = arg_38_0
				})
				var_38_18:send_rpc_clients("rpc_add_buff", var_38_19, var_38_20, var_38_19, 0, false)
			else
				var_38_18:send_rpc_server("rpc_add_buff", var_38_19, var_38_20, var_38_19, 0, true)
			end
		end
	end,
	ai_create_explosion = var_0_0.buff_function_templates.ai_create_explosion,
	grudge_mark_shockwave = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
		local var_39_0 = "grenade_frag_01"
		local var_39_1 = ExplosionUtils.get_template("grudge_mark_shockwave")
		local var_39_2 = POSITION_LOOKUP[arg_39_0]

		DamageUtils.create_explosion(arg_39_3, arg_39_0, var_39_2, Quaternion.identity(), var_39_1, 1, var_39_0, true, false, arg_39_0, false)

		local var_39_3 = Managers.state.unit_storage:go_id(arg_39_0)
		local var_39_4 = NetworkLookup.explosion_templates[var_39_1.name]
		local var_39_5 = NetworkLookup.damage_sources[var_39_0]

		Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_39_3, false, var_39_2, Quaternion.identity(), var_39_4, 1, var_39_5, 0, false, var_39_3)
	end,
	grudge_mark_termite_shockwave = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
		local var_40_0 = "grenade_frag_01"
		local var_40_1 = ExplosionUtils.get_template("grudge_mark_termite_shockwave")
		local var_40_2 = POSITION_LOOKUP[arg_40_0]

		DamageUtils.create_explosion(arg_40_3, arg_40_0, var_40_2, Quaternion.identity(), var_40_1, 1, var_40_0, true, false, arg_40_0, false)

		local var_40_3 = Managers.state.unit_storage:go_id(arg_40_0)
		local var_40_4 = NetworkLookup.explosion_templates[var_40_1.name]
		local var_40_5 = NetworkLookup.damage_sources[var_40_0]

		Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", var_40_3, false, var_40_2, Quaternion.identity(), var_40_4, 1, var_40_5, 0, false, var_40_3)
	end
}
var_0_0.stacking_buff_functions = {}
