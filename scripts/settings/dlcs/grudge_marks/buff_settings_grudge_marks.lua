-- chunkname: @scripts/settings/dlcs/grudge_marks/buff_settings_grudge_marks.lua

local grudge_marks = DLCSettings.grudge_marks
local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

local function fn()
	-- function 1
	return Managers.state.network.is_server
end

local function fn_2(arg_2_0)
	-- function 2
	if not DEDICATED_SERVER then
		return false
	end

	local player = Managers.player
	local local_player = player:local_player()

	if player:unit_owner(arg_2_0) == local_player then
		return true
	end

	return false
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	local ENEMY_PLAYER_AND_BOT_POSITIONS = arg_3_1.side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for i = 1, #ENEMY_PLAYER_AND_BOT_POSITIONS do
		if Vector3.distance_squared(arg_3_0, ENEMY_PLAYER_AND_BOT_POSITIONS[i]) < arg_3_1.min_dist_sqr then
			return false
		end
	end

	return true
end

local num = 10

grudge_marks.buff_templates = {
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
				duration = num,
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
				duration = num
			},
			{
				remove_buff_func = "remove_stagger_immunity",
				name = "grudge_mark_termite_stagger_immune_buff",
				refresh_durations = true,
				max_stacks = 1,
				apply_buff_func = "make_stagger_immune",
				duration = num
			},
			{
				multiplier = 0.25,
				name = "grudge_mark_termite_damage_dealt_buff",
				stat_buff = "damage_dealt",
				refresh_durations = true,
				max_stacks = 1,
				duration = num
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.invulnerable_ranged
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.invulnerable
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.ai_unblockable
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.ignore_death
				}
			}
		}
	}
}
grudge_marks.buff_function_templates = {
	make_stagger_immune = function (arg_4_0, arg_4_1, arg_4_2)
		-- function 4
		if not ALIVE[arg_4_0] then
			local var_4_0 = BLACKBOARDS[arg_4_0]

			if not var_4_0 then
				var_4_0.stagger_immunity = {
					health_threshold = 0
				}
			end
		end
	end,
	remove_stagger_immunity = function (arg_5_0, arg_5_1, arg_5_2)
		-- function 5
		if not ALIVE[arg_5_0] then
			local var_5_0 = BLACKBOARDS[arg_5_0]

			if not var_5_0 then
				local tbl = {
					health_threshold = 0
				}

				var_5_0.stagger_immunity = nil
			end
		end
	end,
	apply_buff_to_all_players = function (arg_6_0, arg_6_1, arg_6_2)
		-- function 6
		if not fn() then
			return
		end

		if not ALIVE[arg_6_0] then
			local get_side_from_name = Managers.state.side:get_side_from_name("heroes")
			local buff_to_add = arg_6_1.template.buff_to_add
			local system = Managers.state.entity:system("buff_system")
			local PLAYER_AND_BOT_UNITS = get_side_from_name.PLAYER_AND_BOT_UNITS

			for i = 1, #PLAYER_AND_BOT_UNITS do
				local var_6_4 = PLAYER_AND_BOT_UNITS[i]

				system:add_buff(var_6_4, buff_to_add, arg_6_0, false)
			end

			local effect_name = arg_6_1.template.effect_name

			if not effect_name then
				local var_6_6 = POSITION_LOOKUP[arg_6_0]

				Managers.state.network:rpc_play_particle_effect(nil, NetworkLookup.effects[effect_name], NetworkConstants.invalid_game_object_id, 0, var_6_6, Quaternion.identity(), false)
			end
		end
	end,
	remove_intangible_mirror_damage = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		Managers.state.entity:system("audio_system"):play_audio_unit_event("enemy_grudge_intangible_destroy", arg_7_0)
	end,
	add_buff_based_on_health_chunks = function (arg_8_0, arg_8_1, arg_8_2)
		-- function 8
		if not fn() then
			return
		end

		if not ALIVE[arg_8_0] then
			local extension = ScriptUnit.extension(arg_8_0, "health_system")
			local extension_2 = ScriptUnit.extension(arg_8_0, "buff_system")
			local system = Managers.state.entity:system("buff_system")
			local template = arg_8_1.template
			local buff_to_add = template.buff_to_add
			local num = extension:get_max_health() / template.chunk_amount
			local get_damage_taken = extension:get_damage_taken()
			local next_chunk = arg_8_1.next_chunk

			next_chunk = next_chunk or num
			arg_8_1.next_chunk = next_chunk

			if get_damage_taken >= arg_8_1.next_chunk then
				system:add_buff_synced(arg_8_0, buff_to_add, BuffSyncType.All)

				arg_8_1.next_chunk = arg_8_1.next_chunk + num
			end

			if num > extension:current_health() then
				system:add_buff_synced(arg_8_0, buff_to_add, BuffSyncType.All)
			end
		end
	end,
	ai_spawn_mirror_images = function (arg_9_0, arg_9_1, arg_9_2)
		-- function 9
		if not fn() then
			return
		end

		local t = arg_9_2.t

		if not arg_9_1.update_frequency_time then
			arg_9_1.update_frequency_time = t + arg_9_1.template.update_frequency_time
		end

		if not (t < arg_9_1.update_frequency_time) or not arg_9_1.first_update_done then
			local update_dialogue_delay = arg_9_1.template.update_dialogue_delay

			if not (not update_dialogue_delay and arg_9_1.update_dialogue_done) then
				if not arg_9_1.update_dialogue_delay_time then
					arg_9_1.update_dialogue_delay_time = t + update_dialogue_delay
				end

				if t > arg_9_1.update_dialogue_delay_time then
					local str = "curse_very_negative_effect_happened"
					local get_random_player = Managers.state.entity:system("dialogue_system"):get_random_player()

					if get_random_player ~= nil then
						local extension_input = ScriptUnit.extension_input(get_random_player, "dialogue_system")
						local alloc_table = FrameTable.alloc_table()

						extension_input:trigger_dialogue_event(str, alloc_table)
					end

					arg_9_1.update_dialogue_done = true
				end
			end

			return
		end

		arg_9_1.update_frequency_time = t + arg_9_1.template.update_frequency_time
		arg_9_1.first_update_done = true

		local function fn_2()
			-- function 10
			if not ALIVE[arg_9_0] then
				local var_10_0 = BLACKBOARDS[arg_9_0]
				local breed = var_10_0.breed
				local var_10_2 = Managers.state.side.side_by_unit[arg_9_0]
				local var_10_3 = POSITION_LOOKUP[arg_9_0]
				local num = 4
				local num_2 = 10
				local num_3 = 5
				local str = "fx/grudge_marks_illusionist"
				local str_2 = "enemy_grudge_intangible"
				local get_spawn_pos_on_circle = ConflictUtils.get_spawn_pos_on_circle(var_10_0.nav_world, var_10_3, num_2, num, num_3, nil, nil, nil, 8, 8)

				if not get_spawn_pos_on_circle then
					ConflictUtils.teleport_ai_unit(arg_9_0, get_spawn_pos_on_circle, str_2, str)
				end

				local tbl = {
					{
						"grudge_mark_intangible_mirror",
						no_attribute = true,
						name = "mirror_base"
					}
				}
				local get_attributes = Managers.state.entity:system("ai_system"):get_attributes(arg_9_0)
				local breed_enhancements = get_attributes.breed_enhancements

				for k, v in pairs(breed_enhancements) do
					if not v and k == "intangible" then
						k = "intangible_mirror"
						tbl[#tbl + 1] = BreedEnhancements[k]
					end
				end

				local name_index = get_attributes.grudge_marked.name_index
				local _mirror_units = arg_9_1._mirror_units

				_mirror_units = _mirror_units or {}
				arg_9_1._mirror_units = _mirror_units

				for k_2 = 1, #_mirror_units do
					local var_10_15 = _mirror_units[k_2]

					if not ALIVE[var_10_15] then
						AiUtils.kill_unit(var_10_15, arg_9_0)
					end
				end

				table.clear(_mirror_units)

				local tbl_2 = {}
				local num_4 = 6.25

				local function fn(arg_11_0, arg_11_1)
					-- function 11
					for i = 1, #arg_11_1 do
						if Vector3.distance_squared(arg_11_0, arg_11_1[i]) < num_4 then
							return false
						end
					end

					local ENEMY_PLAYER_AND_BOT_POSITIONS = var_10_2.ENEMY_PLAYER_AND_BOT_POSITIONS

					for j = 1, #ENEMY_PLAYER_AND_BOT_POSITIONS do
						if Vector3.distance_squared(arg_11_0, ENEMY_PLAYER_AND_BOT_POSITIONS[j]) < num_4 then
							return false
						end
					end

					return true
				end

				local num_mirrors = arg_9_1.template.num_mirrors

				for l = 1, num_mirrors do
					local get_spawn_pos_on_circle_with_func = ConflictUtils.get_spawn_pos_on_circle_with_func(var_10_0.nav_world, var_10_3, num_2, num, num_3, fn, tbl_2, 8, 8)

					if not get_spawn_pos_on_circle_with_func then
						tbl_2[#tbl_2 + 1] = get_spawn_pos_on_circle_with_func

						local tbl_3 = {
							side_id = var_10_2.side_id,
							spawned_func = function (arg_12_0, arg_12_1, arg_12_2)
								-- function 12
								local var_12_0 = BLACKBOARDS[arg_12_0]

								var_12_0.deny_kill_loot = true
								var_12_0.is_illusion = true

								local _mirror_units = arg_9_1._mirror_units

								if not _mirror_units then
									_mirror_units[#_mirror_units + 1] = arg_12_0
								end

								local has_extension = ScriptUnit.has_extension(arg_12_0, "health_system")

								if not has_extension.force_set_wounded then
									has_extension:force_set_wounded()
								end

								ScriptUnit.extension(arg_12_0, "death_system"):override_death_behavior(0, "fx/mutator_death_03")
								Managers.state.entity:system("death_system"):set_death_reaction_template(arg_12_0, "despawn")
							end,
							enhancements = tbl,
							name_index = name_index
						}
						local get_closest_position = ConflictUtils.get_closest_position(get_spawn_pos_on_circle_with_func, var_10_2.ENEMY_PLAYER_AND_BOT_POSITIONS)

						get_closest_position = get_closest_position or get_spawn_pos_on_circle or Vector3.zero()

						local flag = not get_closest_position and ConflictUtils.look_at_position_flat(get_spawn_pos_on_circle_with_func, get_closest_position)

						Managers.state.conflict:spawn_queued_unit(breed, Vector3Box(get_spawn_pos_on_circle_with_func), QuaternionBox(flag), "mirror_spawn", nil, nil, tbl_3, nil)

						local var_10_24 = NetworkLookup.effects[str]
						local num_5 = 0
						local identity = Quaternion.identity()

						Managers.state.network:rpc_play_particle_effect(nil, var_10_24, NetworkConstants.invalid_game_object_id, num_5, get_spawn_pos_on_circle_with_func, identity, false)
					end
				end
			end
		end

		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn_2)
	end,
	ai_spawn_liquid_blob = function (arg_13_0, arg_13_1, arg_13_2)
		-- function 13
		if not fn() then
			return
		end

		local function fn_2()
			-- function 14
			if not ALIVE[arg_13_0] then
				local var_14_0 = BLACKBOARDS[arg_13_0]
				local var_14_1 = POSITION_LOOKUP[arg_13_0]
				local num = 1
				local num_2 = 3
				local num_3 = 5
				local get_spawn_pos_on_circle = ConflictUtils.get_spawn_pos_on_circle(var_14_0.nav_world, var_14_1, num_2, num, num_3)

				if not get_spawn_pos_on_circle then
					return
				end

				Managers.state.entity:system("audio_system"):play_audio_unit_event("enemy_grudge_bubonic_spawn", arg_13_0)

				local spawn_nurgle_liquid_blob_dynamic = AiUtils.spawn_nurgle_liquid_blob_dynamic(Managers.state.network, get_spawn_pos_on_circle, arg_13_0)
				local side = Managers.state.side
				local var_14_8 = side.side_by_unit[arg_13_0]

				var_14_8 = var_14_8 or side:get_side_from_name("dark_pact")

				local side_id = var_14_8.side_id

				side:add_unit_to_side(spawn_nurgle_liquid_blob_dynamic, side_id)
			end
		end

		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn_2)
	end,
	ai_health_regen_update = function (arg_15_0, arg_15_1, arg_15_2)
		-- function 15
		local time = Managers.time:time("game")
		local frequency = arg_15_1.template.frequency

		if not arg_15_1.timer then
			arg_15_1.timer = time + frequency
		end

		if time < arg_15_1.timer then
			return
		end

		arg_15_1.timer = time + frequency

		if not fn() and not HEALTH_ALIVE[arg_15_0] then
			local has_extension = ScriptUnit.has_extension(arg_15_0, "health_system")
			local num = has_extension:get_max_health() * arg_15_1.template.part_healed_of_max_heath

			has_extension:add_heal(arg_15_0, num, nil, "leech")
		end
	end,
	apply_curse_to_nearby_players = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
		-- function 16
		local template = arg_16_1.template
		local max_distance = template.max_distance
		local var_16_2 = POSITION_LOOKUP[arg_16_0]
		local cursed_players = arg_16_1.cursed_players

		cursed_players = cursed_players or {}
		arg_16_1.cursed_players = cursed_players

		local inside_last_frame = arg_16_1.inside_last_frame

		inside_last_frame = inside_last_frame or {}
		arg_16_1.inside_last_frame = inside_last_frame

		local inside_last_frame_2 = arg_16_1.inside_last_frame
		local cursed_players_2 = arg_16_1.cursed_players
		local player_unit = Managers.player:local_player().player_unit
		local player_units_broadphase = Managers.state.entity:system("proximity_system").player_units_broadphase
		local alloc_table = FrameTable.alloc_table()
		local query = Broadphase.query(player_units_broadphase, var_16_2, max_distance, alloc_table)
		local alloc_table_2 = FrameTable.alloc_table()

		for i = 1, query do
			local var_16_12 = alloc_table[i]

			alloc_table_2[var_16_12] = true

			if not inside_last_frame_2[var_16_12] then
				if var_16_12 ~= player_unit or not ALIVE[var_16_12] then
					local extension = ScriptUnit.extension(var_16_12, "buff_system")
					local buff_to_add = template.buff_to_add

					if extension:num_buff_stacks(buff_to_add) == 0 then
						local wwise_world = Managers.world:wwise_world(arg_16_3)

						WwiseWorld.trigger_event(wwise_world, template.sound_on_enter)
					end
				end

				cursed_players_2[var_16_12] = true
				inside_last_frame_2[var_16_12] = true
			end
		end

		if not fn() then
			local time = Managers.time:time("game")
			local last_curse_t = arg_16_1.last_curse_t

			last_curse_t = last_curse_t or time
			arg_16_1.last_curse_t = last_curse_t

			local time_between_curses = template.time_between_curses
			local num = arg_16_1.last_curse_t + time_between_curses
			local flag = num <= time

			for k, v in pairs(cursed_players_2) do
				if not flag then
					if not alloc_table_2[k] then
						local buff_to_add_2 = template.buff_to_add

						Managers.state.entity:system("buff_system"):add_buff(k, buff_to_add_2, arg_16_0)
					else
						cursed_players_2[k] = nil
					end
				end

				local flag_2

				flag_2 = not alloc_table_2[k] and true and nil
				inside_last_frame_2[k] = flag_2
			end

			arg_16_1.last_curse_t = not flag and num and arg_16_1.last_curse_t
		elseif not ALIVE[player_unit] then
			local flag_3

			flag_3 = not alloc_table_2[player_unit] and true and nil
			inside_last_frame_2[player_unit] = flag_3
		end
	end,
	ai_create_explosion = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
		-- function 17
		if not (not fn() and ALIVE[arg_17_0]) then
			return
		end

		local template = arg_17_1.template
		local explosion_template_name = template.explosion_template_name
		local damage_source_name = template.damage_source_name

		damage_source_name = damage_source_name or "buff"

		local var_17_3 = POSITION_LOOKUP[arg_17_0]

		var_17_3 = var_17_3 or Unit.world_position(arg_17_0, 0)

		local get_template = ExplosionUtils.get_template(explosion_template_name)

		DamageUtils.create_explosion(arg_17_3, arg_17_0, var_17_3, Quaternion.identity(), get_template, 1, damage_source_name, true, false, arg_17_0, 0, false)

		local go_id = Managers.state.unit_storage:go_id(arg_17_0)
		local var_17_6 = NetworkLookup.explosion_templates[explosion_template_name]
		local var_17_7 = NetworkLookup.damage_sources[damage_source_name]

		Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, var_17_3, Quaternion.identity(), var_17_6, 1, var_17_7, 0, false, go_id)
	end,
	ai_add_hit_sfx = function (arg_18_0, arg_18_1, arg_18_2)
		-- function 18
		local template = arg_18_1.template
		local flag = not template and template.hit_sfx_name

		if not flag then
			local has_extension = ScriptUnit.has_extension(arg_18_0, "ai_inventory_system")

			if not has_extension then
				arg_18_1._override_id = has_extension:add_additional_hit_sfx(flag)
			end
		end
	end,
	ai_remove_hit_sfx = function (arg_19_0, arg_19_1, arg_19_2)
		-- function 19
		local has_extension = ScriptUnit.has_extension(arg_19_0, "ai_inventory_system")

		if not has_extension then
			has_extension:remove_additioanl_hit_sfx(arg_19_1._override_id)

			arg_19_1._override_id = nil
		end
	end,
	first_person_flow_event = function (arg_20_0, arg_20_1, arg_20_2)
		-- function 20
		local flow_event = arg_20_1.template.flow_event

		if not fn_2(arg_20_0) then
			local has_extension = ScriptUnit.has_extension(arg_20_0, "first_person_system")
			local flag = not has_extension and has_extension:get_first_person_unit()

			if not flag then
				Unit.flow_event(flag, flow_event)
			end
		end
	end,
	remove_all_stamina = function (arg_21_0, arg_21_1, arg_21_2)
		-- function 21
		if not fn_2(arg_21_0) then
			local has_extension = ScriptUnit.has_extension(arg_21_0, "status_system")

			if not has_extension then
				has_extension:add_fatigue_points("complete", arg_21_2.attacker_unit)
			end
		end
	end,
	trigger_terror_event = function (arg_22_0, arg_22_1, arg_22_2)
		-- function 22
		if not (not fn() and ALIVE[arg_22_0]) then
			return
		end

		local faction_terror_events = arg_22_1.template.faction_terror_events
		local var_22_1 = BLACKBOARDS[arg_22_0]
		local flag = not var_22_1 and var_22_1.breed
		local var_22_3 = faction_terror_events[not flag and flag.race]

		var_22_3 = var_22_3 or faction_terror_events.default

		local seed = arg_22_1.seed

		seed = seed or Managers.mechanism:get_level_seed()

		Managers.state.conflict:start_terror_event(var_22_3, seed, arg_22_0)

		arg_22_1.seed = Math.next_random(seed)
	end,
	add_extra_frenzy_stack = function (arg_23_0, arg_23_1, arg_23_2)
		-- function 23
		if not ALIVE[arg_23_0] then
			local has_extension = ScriptUnit.has_extension(arg_23_0, "buff_system")

			if not has_extension then
				has_extension:add_buff(arg_23_1.template.buff_to_add)
			end
		end
	end,
	frenzy_damage_over_time = function (arg_24_0, arg_24_1, arg_24_2)
		-- function 24
		if not fn() then
			return
		end

		if not ALIVE[arg_24_0] then
			local has_extension = ScriptUnit.has_extension(arg_24_0, "health_system")

			if not has_extension then
				return
			end

			local current_health = has_extension:current_health()
			local damage_per_tick = arg_24_1.template.damage_per_tick

			if current_health <= damage_per_tick then
				damage_per_tick = current_health - 1
			end

			if damage_per_tick > 0 then
				DamageUtils.add_damage_network(arg_24_0, arg_24_0, damage_per_tick, "torso", "buff", nil, Vector3(0, 0, 0), "buff", nil, arg_24_0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1)
			end
		end
	end,
	apply_frenzy_func = function (arg_25_0, arg_25_1, arg_25_2)
		-- function 25
		if not ALIVE[arg_25_0] then
			local owner = Managers.player:owner(arg_25_0)

			if not (not owner and owner.remote) then
				Managers.state.camera:set_mood("skill_zealot", arg_25_1, true)
			end

			local has_extension = ScriptUnit.has_extension(arg_25_0, "first_person_system")

			if not has_extension then
				has_extension:play_hud_sound_event("enemy_grudge_frenzy_start")
			end
		end
	end,
	remove_frenzy_func = function (arg_26_0, arg_26_1, arg_26_2)
		-- function 26
		if not ALIVE[arg_26_0] then
			local owner = Managers.player:owner(arg_26_0)

			if not (not owner and owner.remote) then
				Managers.state.camera:set_mood("skill_zealot", arg_26_1, false)
			end
		end
	end,
	remove_frenzy_handlers = function (arg_27_0, arg_27_1, arg_27_2)
		-- function 27
		if not arg_27_1.buff_ids then
			local system = Managers.state.entity:system("buff_system")

			for k, v in pairs(arg_27_1.buff_ids) do
				if not ALIVE[k] then
					system:remove_server_controlled_buff(k, v)
				end
			end
		end
	end,
	grudge_mark_ignore_death_aura_update = function (arg_28_0, arg_28_1, arg_28_2)
		-- function 28
		local ally_broadphase_categories = Managers.state.side.side_by_unit[arg_28_0].ally_broadphase_categories
		local alloc_table = FrameTable.alloc_table()
		local var_28_2 = POSITION_LOOKUP[arg_28_0]
		local radius = arg_28_1.template.radius
		local broadphase_query = AiUtils.broadphase_query(var_28_2, radius, alloc_table, ally_broadphase_categories)
		local buff_to_add = arg_28_1.template.buff_to_add
		local alloc_table_2 = FrameTable.alloc_table()
		local inside_allies = arg_28_1.inside_allies

		inside_allies = inside_allies or {}
		arg_28_1.inside_allies = inside_allies

		for i = 1, broadphase_query do
			local var_28_8 = alloc_table[i]

			if var_28_8 ~= arg_28_0 then
				local has_extension = ScriptUnit.has_extension(var_28_8, "buff_system")

				if not has_extension then
					if not inside_allies[var_28_8] then
						inside_allies[var_28_8] = has_extension:add_buff(buff_to_add)
					end

					alloc_table_2[var_28_8] = true
				end
			end
		end

		for k, v in pairs(inside_allies) do
			if not alloc_table_2[k] then
				local has_extension_2 = ScriptUnit.has_extension(k, "buff_system")

				if not has_extension_2 then
					has_extension_2:remove_buff(v)
				end

				inside_allies[k] = nil
			end
		end
	end,
	grudge_mark_ignore_death_aura_cleanup = function (arg_29_0, arg_29_1, arg_29_2)
		-- function 29
		local inside_allies = arg_29_1.inside_allies

		if not inside_allies then
			return
		end

		for k, v in pairs(inside_allies) do
			local has_extension = ScriptUnit.has_extension(k, "buff_system")

			if not has_extension then
				has_extension:remove_buff(v)
			end
		end

		arg_29_1.inside_allies = nil
	end
}
grudge_marks.proc_functions = {
	add_frenzy_handler = function (arg_30_0, arg_30_1, arg_30_2)
		-- function 30
		if not fn() then
			return
		end

		local var_30_0 = arg_30_2[1]
		local var_30_1 = arg_30_2[4]

		if not ALIVE[arg_30_0] and not ALIVE[var_30_0] and not MeleeAttackTypes[var_30_1] then
			local buff_to_add = arg_30_1.template.buff_to_add
			local system = Managers.state.entity:system("buff_system")

			if not arg_30_1.buff_ids then
				arg_30_1.buff_ids = {}
			end

			if not arg_30_1.buff_ids[var_30_0] then
				arg_30_1.buff_ids[var_30_0] = system:add_buff(var_30_0, buff_to_add, arg_30_0, true)
			end
		end
	end,
	add_frenzy_stack = function (arg_31_0, arg_31_1, arg_31_2)
		-- function 31
		local var_31_0 = arg_31_2[1]

		if not ALIVE[arg_31_0] and not ALIVE[var_31_0] then
			if not (not arg_31_1.attacker_unit and var_31_0 == arg_31_1.attacker_unit) then
				return
			end

			local has_extension = ScriptUnit.has_extension(arg_31_0, "buff_system")

			if not (not has_extension and has_extension:has_buff_type(arg_31_1.template.blocker_buff)) then
				has_extension:add_buff(arg_31_1.template.buff_to_add)
			end
		end
	end,
	spawn_liquid_forward = function (arg_32_0, arg_32_1, arg_32_2)
		-- function 32
		if not fn() then
			return
		end

		BuffUtils.create_liquid_forward(arg_32_0, arg_32_1)
	end,
	ai_add_buff_on_damage_dealt = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
		-- function 33
		local var_33_0 = arg_33_2[arg_33_4.attacked_unit]
		local var_33_1 = arg_33_2[arg_33_4.damage_amount]

		if not (not ALIVE[var_33_0] and not (var_33_1 > 0)) then
			local buff_to_add = arg_33_1.template.buff_to_add
			local extension = ScriptUnit.extension(var_33_0, "buff_system")
			local network = Managers.state.network
			local network_transmit = network.network_transmit
			local unit_game_object_id = network:unit_game_object_id(var_33_0)
			local var_33_7 = NetworkLookup.buff_templates[buff_to_add]

			if not fn() then
				extension:add_buff(buff_to_add, {
					attacker_unit = var_33_0
				})
				network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id, var_33_7, unit_game_object_id, 0, false)
			else
				network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id, var_33_7, unit_game_object_id, 0, true)
			end
		end
	end,
	ai_delay_regen = function (arg_34_0, arg_34_1, arg_34_2)
		-- function 34
		local time = Managers.time:time("game")
		local on_hit_delay = arg_34_1.template.on_hit_delay

		if not arg_34_1.timer then
			arg_34_1.timer = time + on_hit_delay
		end

		arg_34_1.timer = time + on_hit_delay
	end,
	ai_heal_on_damage_dealt = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
		-- function 35
		if not fn() then
			return
		end

		local var_35_0 = arg_35_2[arg_35_4.attacked_unit]

		if not ALIVE[arg_35_0] and not ALIVE[var_35_0] and not DamageUtils.is_enemy(arg_35_0, var_35_0) then
			local has_extension = ScriptUnit.has_extension(arg_35_0, "health_system")

			if not has_extension and not has_extension:is_alive() then
				local var_35_2 = arg_35_2[arg_35_4.damage_amount]
				local template = arg_35_1.template
				local multiplier = template.multiplier

				multiplier = multiplier or 1

				local bonus = template.bonus

				bonus = bonus or 0

				local clamp = math.clamp(var_35_2 * multiplier + bonus, 0, 255)

				has_extension:add_heal(arg_35_0, clamp, nil, "leech")
			end
		end
	end,
	random_teleport_ai = function (arg_36_0, arg_36_1, arg_36_2)
		-- function 36
		if not fn() then
			return
		end

		local function fn_2()
			-- function 37
			if not ALIVE[arg_36_0] then
				local var_37_0 = BLACKBOARDS[arg_36_0]
				local var_37_1 = POSITION_LOOKUP[arg_36_0]
				local template = arg_36_1.template
				local min_teleport_distance = template.min_teleport_distance
				local max_teleport_distance = template.max_teleport_distance
				local find_valid_pos_attempts = template.find_valid_pos_attempts
				local min_dist_from_players = template.min_dist_from_players
				local var_37_7 = Managers.state.side.side_by_unit[arg_36_0]
				local tbl = {
					side = var_37_7,
					min_dist_sqr = min_dist_from_players * min_dist_from_players
				}
				local get_spawn_pos_on_circle_with_func_range = ConflictUtils.get_spawn_pos_on_circle_with_func_range(var_37_0.nav_world, var_37_1, min_teleport_distance, max_teleport_distance, find_valid_pos_attempts, fn_3, tbl, 8, 8)

				if not get_spawn_pos_on_circle_with_func_range then
					local str = "enemy_grudge_warping"
					local str_2 = "fx/grudge_marks_shadow_step"

					ConflictUtils.teleport_ai_unit(arg_36_0, get_spawn_pos_on_circle_with_func_range, str, str_2)
				end
			end
		end

		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn_2)
	end,
	ai_crushing_blow = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
		-- function 38
		if not (not fn() and ALIVE[arg_38_0]) then
			return
		end

		local var_38_0 = arg_38_2[arg_38_4.attacked_unit]
		local var_38_1 = BLACKBOARDS[arg_38_0]
		local has_extension = ScriptUnit.has_extension(var_38_0, "status_system")

		if not var_38_1 and not var_38_1.hit_through_block and not has_extension then
			local extension = ScriptUnit.extension(var_38_0, "buff_system")
			local buff_to_add = arg_38_1.template.buff_to_add
			local action = var_38_1.action

			if not action and not action.fatigue_type then
				local can_block, var_38_7, var_38_8, var_38_9 = has_extension:can_block(arg_38_0)
				local fatigue_type = action.fatigue_type

				if type(fatigue_type) == "table" then
					fatigue_type = Managers.state.difficulty:get_difficulty_value_from_table(fatigue_type)
				end

				has_extension:blocked_attack(fatigue_type, arg_38_0, var_38_7, var_38_8, var_38_9)

				if not fn() then
					local network = Managers.state.network
					local go_id = Managers.state.unit_storage:go_id(var_38_0)
					local var_38_13 = NetworkLookup.fatigue_types[fatigue_type]
					local game_object_or_level_id, var_38_15 = network:game_object_or_level_id(arg_38_0)

					network.network_transmit:send_rpc_clients("rpc_player_blocked_attack", go_id, var_38_13, game_object_or_level_id, var_38_7, var_38_8, var_38_9, var_38_15)
				end
			end

			local var_38_16 = arg_38_2[arg_38_4.PROC_MODIFIABLE]

			var_38_16.damage_amount = 0

			if not action and not action.blocked_damage then
				var_38_16.damage_amount = action.blocked_damage
			end

			local network_2 = Managers.state.network
			local network_transmit = network_2.network_transmit
			local unit_game_object_id = network_2:unit_game_object_id(var_38_0)
			local var_38_20 = NetworkLookup.buff_templates[buff_to_add]

			if not fn() then
				extension:add_buff(buff_to_add, {
					attacker_unit = arg_38_0
				})
				network_transmit:send_rpc_clients("rpc_add_buff", unit_game_object_id, var_38_20, unit_game_object_id, 0, false)
			else
				network_transmit:send_rpc_server("rpc_add_buff", unit_game_object_id, var_38_20, unit_game_object_id, 0, true)
			end
		end
	end,
	ai_create_explosion = grudge_marks.buff_function_templates.ai_create_explosion,
	grudge_mark_shockwave = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
		-- function 39
		local str = "grenade_frag_01"
		local get_template = ExplosionUtils.get_template("grudge_mark_shockwave")
		local var_39_2 = POSITION_LOOKUP[arg_39_0]

		DamageUtils.create_explosion(arg_39_3, arg_39_0, var_39_2, Quaternion.identity(), get_template, 1, str, true, false, arg_39_0, false)

		local go_id = Managers.state.unit_storage:go_id(arg_39_0)
		local var_39_4 = NetworkLookup.explosion_templates[get_template.name]
		local var_39_5 = NetworkLookup.damage_sources[str]

		Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, var_39_2, Quaternion.identity(), var_39_4, 1, var_39_5, 0, false, go_id)
	end,
	grudge_mark_termite_shockwave = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
		-- function 40
		local str = "grenade_frag_01"
		local get_template = ExplosionUtils.get_template("grudge_mark_termite_shockwave")
		local var_40_2 = POSITION_LOOKUP[arg_40_0]

		DamageUtils.create_explosion(arg_40_3, arg_40_0, var_40_2, Quaternion.identity(), get_template, 1, str, true, false, arg_40_0, false)

		local go_id = Managers.state.unit_storage:go_id(arg_40_0)
		local var_40_4 = NetworkLookup.explosion_templates[get_template.name]
		local var_40_5 = NetworkLookup.damage_sources[str]

		Managers.state.network.network_transmit:send_rpc_clients("rpc_create_explosion", go_id, false, var_40_2, Quaternion.identity(), var_40_4, 1, var_40_5, 0, false, go_id)
	end
}
grudge_marks.stacking_buff_functions = {}
