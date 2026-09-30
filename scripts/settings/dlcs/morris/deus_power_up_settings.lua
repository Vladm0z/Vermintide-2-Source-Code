-- chunkname: @scripts/settings/dlcs/morris/deus_power_up_settings.lua

require("scripts/entity_system/systems/buff/buff_sync_type")
require("scripts/settings/dlcs/morris/deus_cost_settings")
require("scripts/settings/dlcs/morris/tweak_data/buff_tweak_data")

local buff_perks = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")

DeusPowerUpSettings = DeusPowerUpSettings

local skulls_buffs_to_refresh = {
	"boon_skulls_01_stack",
	"boon_skulls_01_surge",
	"boon_skulls_02_stack",
	"boon_skulls_02_surge",
	"boon_skulls_04_regen",
	"boon_skulls_05_stack",
	"boon_skulls_05_surge"
}
local next_support_bomb_rotation = 0

local function get_bomb_zone_rotation()
	-- function 1
	local rot_delta = 0.2
	local rot = next_support_bomb_rotation

	assert(rot < math.tau, "Bomb zone fx may overlap. Lower rot_delta")

	next_support_bomb_rotation = next_support_bomb_rotation + math.tau * rot_delta

	return Quaternion.axis_angle(Vector3.up(), rot)
end

local next_cursed_zone_rotation = 0

local function get_cursed_zone_rotation()
	-- function 2
	local rot_delta = 0.5
	local rot = next_cursed_zone_rotation

	assert(rot < math.tau, "Cursed zone fx may overlap. Lower rot_delta")

	next_support_bomb_rotation = next_support_bomb_rotation + math.tau * rot_delta

	return Quaternion.axis_angle(Vector3.up(), rot)
end

DeusPowerUpBuffTemplates = {
	deus_coin_pickup_regen_buff = {
		buffs = {
			{
				name = "deus_coin_pickup_regen_buff",
				heal_type = "health_regen",
				time_between_heal = 1,
				update_func = "health_regen_update",
				apply_buff_func = "health_regen_start",
				icon = "deus_healing",
				heal = MorrisBuffTweakData.deus_coin_pickup_regen_buff.heal,
				duration = MorrisBuffTweakData.deus_coin_pickup_regen_buff.duration
			}
		}
	},
	deus_large_ammo_pickup_infinite_ammo_buff = {
		buffs = {
			{
				name = "deus_large_ammo_pickup_infinite_ammo_buff",
				icon = "icons_placeholder",
				perks = {
					buff_perks.infinite_ammo
				},
				duration = MorrisBuffTweakData.deus_large_ammo_pickup_infinite_ammo_buff.duration
			}
		}
	},
	deus_revive_regen_buff = {
		buffs = {
			{
				heal_type = "health_regen",
				name = "deus_revive_regen_buff",
				max_stacks = 1,
				time_between_heal = 1,
				refresh_durations = true,
				apply_buff_func = "health_regen_start",
				icon = "deus_revive_regen",
				update_func = "health_regen_update",
				heal = MorrisBuffTweakData.deus_revive_regen_buff.heal,
				duration = MorrisBuffTweakData.deus_revive_regen_buff.duration
			}
		}
	},
	active_ability_movement_speed = {
		buffs = {
			{
				apply_buff_func = "apply_active_ability_movement_buff",
				name = "movement",
				icon = "movement_speed_on_active_ability_use",
				refresh_durations = true,
				remove_buff_func = "remove_active_ability_movement_buff",
				max_stacks = 1,
				multiplier = MorrisBuffTweakData.active_ability_movement_speed.multiplier,
				duration = MorrisBuffTweakData.active_ability_movement_speed.duration,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			}
		}
	},
	explosive_pushes = {
		buffs = {
			{
				explosion_template = "buff_explosion",
				name = "explosive_pushes",
				authority = "server",
				buff_func = "on_push_explosion",
				event = "on_push",
				icon = "potion_buff_02",
				power_scale = 1.5,
				duration = MorrisBuffTweakData.explosive_pushes.duration
			}
		}
	},
	deus_crit_on_damage_taken_buff = {
		buffs = {
			{
				icon = "deus_icon_crit_on_damage_taken",
				name = "deus_crit_on_damage_taken_buff",
				refresh_durations = true,
				max_stacks = 1,
				duration = MorrisBuffTweakData.deus_crit_on_damage_taken_buff.duration,
				perks = {
					buff_perks.guaranteed_crit
				}
			}
		}
	},
	deus_damage_reduction_on_incapacitated_buff = {
		buffs = {
			{
				name = "deus_damage_reduction_on_incapacitated_buff",
				stat_buff = "damage_taken",
				icon = "deus_icon_damage_reduction_on_incapacitated",
				max_stacks = 1,
				remove_buff_func = "remove_damage_reduction_on_incapacitated",
				apply_buff_func = "apply_damage_reduction_on_incapacitated",
				multiplier = MorrisBuffTweakData.deus_damage_reduction_on_incapacitated_buff.multiplier,
				duration = MorrisBuffTweakData.deus_damage_reduction_on_incapacitated_buff.duration
			}
		}
	},
	elites_on_kill_explosion_buff = {
		buffs = {
			{
				sound_event = "morris_power_ups_exploding_enemy",
				name = "elites_on_kill_explosion_buff",
				authority = "server",
				buff_func = "elites_on_kill_explosion",
				power_scale = 2,
				event = "on_kill",
				max_stacks = 1,
				explosion_template = "buff_explosion",
				icon = "explosive_kills_on_elite_kills",
				amount_of_explosions = MorrisBuffTweakData.explosive_kills_on_elite_kills.amount_of_explosions
			}
		}
	},
	deus_knockdown_damage_immunity_buff = {
		buffs = {
			{
				particle_fx = "fx/cw_allies_shield",
				name = "deus_knockdown_damage_immunity_buff",
				buff_func = "play_particle_effect",
				event = "on_damage_taken",
				icon = "deus_knockdown_damage_immunity_aura",
				max_stacks = 1,
				proc_weight = 15,
				perks = {
					buff_perks.invulnerable
				}
			}
		}
	},
	drop_item_on_ability_use_cooldown = {
		buffs = {
			{
				icon = "drop_item_on_ability_use",
				name = "drop_item_on_ability_use_cooldown",
				max_stacks = 1,
				refresh_durations = true,
				is_cooldown = true,
				duration = 5
			}
		}
	},
	deus_timed_block_free_shot_buff = {
		buffs = {
			{
				event = "on_ammo_used",
				name = "deus_timed_block_free_shot_buff",
				buff_func = "dummy_function",
				remove_on_proc = true,
				icon = "deus_utils",
				priority_buff = true,
				max_stacks = 1,
				perks = {
					buff_perks.infinite_ammo
				}
			}
		}
	},
	deus_special_farm_max_health = {
		buffs = {
			{
				buff_to_add = "deus_special_farm_max_health_buff",
				name = "deus_special_farm_max_health",
				authority = "server",
				buff_func = "deus_special_farm_max_health_on_special",
				specials_per_pop = 5,
				event = "on_special_killed"
			}
		}
	},
	deus_special_farm_max_health_buff = {
		buffs = {
			{
				multiplier = 0.1,
				name = "deus_special_farm_max_health_buff",
				stat_buff = "max_health",
				is_persistent = true,
				max_stacks = 10,
				icon = "markus_huntsman_damage_reduction_on_monster_kill",
				priority_buff = true
			}
		}
	},
	deus_reckless_swings_buff = {
		buffs = {
			{
				name = "deus_reckless_swings_buff",
				stat_buff = "power_level_melee",
				buff_func = "deus_reckless_swings_buff_on_hit",
				event = "on_hit",
				icon = "deus_reckless_swings",
				max_stacks = 1,
				multiplier = MorrisBuffTweakData.deus_reckless_swings_buff.multiplier,
				damage_to_deal = MorrisBuffTweakData.deus_reckless_swings_buff.damage_to_deal
			}
		}
	},
	deus_second_wind_attack_speed = {
		buffs = {
			{
				buff_to_add = "deus_second_wind_cooldown",
				name = "deus_second_wind_attack_speed",
				stat_buff = "attack_speed",
				duration_end_func = "add_buff_local",
				remove_buff_func = "remove_second_wind",
				apply_buff_func = "apply_second_wind",
				icon = "deus_second_wind",
				max_stacks = 1,
				perks = {
					buff_perks.invulnerable
				},
				duration = MorrisBuffTweakData.deus_second_wind_attack_speed.duration,
				multiplier = MorrisBuffTweakData.deus_second_wind_attack_speed.multiplier
			}
		}
	},
	deus_second_wind_movement_speed = {
		buffs = {
			{
				remove_buff_func = "remove_movement_buff",
				name = "deus_second_wind_movement_speed",
				max_stacks = 1,
				apply_buff_func = "apply_movement_buff",
				duration = MorrisBuffTweakData.deus_second_wind_movement_speed.duration,
				multiplier = MorrisBuffTweakData.deus_second_wind_movement_speed.multiplier,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			}
		}
	},
	deus_second_wind_cooldown = {
		buffs = {
			{
				name = "deus_second_wind_cooldown",
				max_stacks = 1,
				is_cooldown = true,
				icon = "deus_second_wind",
				duration = MorrisBuffTweakData.deus_second_wind_cooldown.duration
			}
		}
	},
	deus_guard_aura = {
		buffs = {
			{
				buff_to_add = "deus_guard_buff",
				name = "deus_guard_aura",
				disregard_self = true,
				remove_buff_func = "remove_aura_buff",
				range = 10,
				update_func = "activate_buff_on_distance",
				authority = "server",
				update_frequency = 0.5
			}
		}
	},
	deus_guard_buff = {
		buffs = {
			{
				name = "deus_guard_buff",
				stat_buff = "damage_taken",
				buff_func = "deus_guard_buff_on_damage",
				max_stacks = 1,
				icon = "deus_icon_guard_aura_check",
				event = "on_damage_taken",
				multiplier = MorrisBuffTweakData.deus_guard_buff.multiplier
			}
		}
	},
	deus_push_increased_cleave_buff = {
		buffs = {
			{
				icon = "deus_push_increased_cleave",
				name = "deus_push_increased_cleave_buff",
				stat_buff = "power_level_melee_cleave",
				max_stacks = 1,
				duration = MorrisBuffTweakData.deus_push_increased_cleave_buff.duration,
				multiplier = MorrisBuffTweakData.deus_push_increased_cleave_buff.multiplier
			}
		}
	},
	deus_parry_damage_immune_buff = {
		buffs = {
			{
				icon = "deus_parry_damage_immune",
				name = "deus_parry_damage_immune_buff",
				max_stacks = 1,
				apply_buff_func = "apply_parry_damage_immune",
				perks = {
					buff_perks.invulnerable
				},
				duration = MorrisBuffTweakData.deus_parry_damage_immune_buff.duration
			}
		}
	},
	deus_standing_still_damage_reduction_buff = {
		buffs = {
			{
				name = "deus_standing_still_damage_reduction_buff",
				stat_buff = "damage_taken",
				icon = "deus_standing_still_damage_reduction",
				multiplier = MorrisBuffTweakData.deus_standing_still_damage_reduction_buff.multiplier
			}
		}
	},
	triple_melee_headshot_power_boost = {
		buffs = {
			{
				name = "triple_melee_headshot_power_boost",
				stat_buff = "power_level_melee",
				max_stacks = 1,
				icon = "triple_melee_headshot_power",
				refresh_durations = true,
				multiplier = MorrisBuffTweakData.triple_melee_headshot_power_boost.multiplier,
				duration = MorrisBuffTweakData.triple_melee_headshot_power_boost.duration
			}
		}
	},
	melee_killing_spree_speed_boost = {
		buffs = {
			{
				remove_buff_func = "remove_screenspace_fx",
				name = "melee_killing_spree_speed_boost",
				stat_buff = "attack_speed",
				screenspace_fx = "fx/cw_speed_screenspace",
				refresh_durations = true,
				apply_buff_func = "apply_screenspace_fx",
				max_stacks = 1,
				icon = "melee_killing_spree_speed",
				multiplier = MorrisBuffTweakData.melee_killing_spree_speed_boost.multiplier,
				duration = MorrisBuffTweakData.melee_killing_spree_speed_boost.duration
			},
			{
				name = "melee_killing_spree_speed_boost",
				max_stacks = 1,
				remove_buff_func = "remove_movement_buff",
				apply_buff_func = "apply_movement_buff",
				refresh_durations = true,
				multiplier = MorrisBuffTweakData.melee_killing_spree_speed_boost.baked_multiplier,
				duration = MorrisBuffTweakData.melee_killing_spree_speed_boost.duration,
				path_to_movement_setting_to_modify = {
					"move_speed"
				}
			}
		}
	},
	last_player_standing_power_reg_boost = {
		buffs = {
			{
				name = "last_player_standing_power_boost",
				stat_buff = "power_level",
				icon = "last_player_standing_power_reg",
				multiplier = MorrisBuffTweakData.last_player_standing_power_reg_boost.multiplier,
				duration = MorrisBuffTweakData.last_player_standing_power_reg_boost.duration
			},
			{
				name = "last_player_standing_reg_boost",
				heal_type = "health_regen",
				time_between_heal = 0.5,
				update_func = "health_regen_update",
				apply_buff_func = "health_regen_start",
				heal = MorrisBuffTweakData.last_player_standing_power_reg_boost.heal,
				duration = MorrisBuffTweakData.last_player_standing_power_reg_boost.duration
			}
		}
	},
	cooldown_reg_not_hit_buff = {
		buffs = {
			{
				name = "cooldown_reg_not_hit_buff",
				stat_buff = "cooldown_regen",
				icon = "deus_icon_cooldown_reg_not_hit",
				multiplier = MorrisBuffTweakData.cooldown_reg_not_hit_buff.multiplier,
				max_stacks = MorrisBuffTweakData.cooldown_reg_not_hit_buff.max_stacks
			}
		}
	},
	skulls_boon_buffs_tracker = {
		buffs = {
			{
				name = "skulls_boon_buffs_tracker"
			}
		}
	},
	boon_skulls_01_stack = {
		buffs = {
			{
				ignore_if_not_local = true,
				stat_buff = "attack_speed",
				name = "boon_skulls_01_stack",
				refresh_durations = true,
				synced_buff_to_add = "boon_skulls_01_surge",
				on_max_stacks_func = "add_buff_synced",
				sync_type = "LocalAndServer",
				icon = "boon_skulls_01",
				reset_on_max_stacks = true,
				is_cooldown = true,
				duration = MorrisBuffTweakData.boon_skulls_01_data.duration,
				duration_modifier_func = MorrisBuffTweakData.boon_skulls_set_01_data.duration_modifier_func,
				multiplier = function (unit, buff_extension)
					-- function 3
					local multiplier = MorrisBuffTweakData.boon_skulls_01_data.attack_speed_per_stack
					local has_full_set = buff_extension:num_buff_stacks("power_up_boon_skulls_set_bonus_01_event") > 0

					if has_full_set then
						multiplier = multiplier * (1 + MorrisBuffTweakData.boon_skulls_set_bonus_01.effect_amplify_amount)
					end

					return multiplier
				end,
				max_stacks = MorrisBuffTweakData.boon_skulls_01_data.max_stacks
			}
		}
	},
	boon_skulls_01_surge = {
		buffs = {
			{
				stat_buff = "attack_speed",
				name = "boon_skulls_01_surge",
				remove_buff_func = "skulls_event_boon_surge_removed",
				apply_buff_func = "skulls_event_boon_surge_applied",
				icon = "boon_skulls_01",
				max_stacks = 1,
				duration = MorrisBuffTweakData.boon_skulls_01_data.duration,
				duration_modifier_func = MorrisBuffTweakData.boon_skulls_set_01_data.duration_modifier_func,
				multiplier = function (unit, buff_extension)
					-- function 4
					local multiplier = MorrisBuffTweakData.boon_skulls_01_data.attack_speed_on_proc
					local has_full_set = buff_extension:num_buff_stacks("power_up_boon_skulls_set_bonus_01_event") > 0

					if has_full_set then
						multiplier = multiplier * (1 + MorrisBuffTweakData.boon_skulls_set_bonus_01.effect_amplify_amount)
					end

					return multiplier
				end,
				refresh_duration_of_buffs_on_apply = skulls_buffs_to_refresh
			}
		}
	},
	boon_skulls_02_stack = {
		buffs = {
			{
				ignore_if_not_local = true,
				stat_buff = "power_level",
				name = "boon_skulls_02_stack",
				refresh_durations = true,
				synced_buff_to_add = "boon_skulls_02_surge",
				on_max_stacks_func = "add_buff_synced",
				sync_type = "LocalAndServer",
				icon = "boon_skulls_02",
				reset_on_max_stacks = true,
				is_cooldown = true,
				duration = MorrisBuffTweakData.boon_skulls_02_data.duration,
				duration_modifier_func = MorrisBuffTweakData.boon_skulls_set_01_data.duration_modifier_func,
				multiplier = function (unit, buff_extension)
					-- function 5
					local multiplier = MorrisBuffTweakData.boon_skulls_02_data.power_per_stack
					local has_full_set = buff_extension:num_buff_stacks("power_up_boon_skulls_set_bonus_01_event") > 0

					if has_full_set then
						multiplier = multiplier * (1 + MorrisBuffTweakData.boon_skulls_set_bonus_01.effect_amplify_amount)
					end

					return multiplier
				end,
				max_stacks = MorrisBuffTweakData.boon_skulls_02_data.max_stacks
			}
		}
	},
	boon_skulls_02_surge = {
		buffs = {
			{
				stat_buff = "power_level",
				name = "boon_skulls_02_surge",
				remove_buff_func = "skulls_event_boon_surge_removed",
				apply_buff_func = "skulls_event_boon_surge_applied",
				icon = "boon_skulls_02",
				max_stacks = 1,
				duration = MorrisBuffTweakData.boon_skulls_02_data.duration,
				duration_modifier_func = MorrisBuffTweakData.boon_skulls_set_01_data.duration_modifier_func,
				multiplier = MorrisBuffTweakData.boon_skulls_02_data.power_on_proc,
				refresh_duration_of_buffs_on_apply = skulls_buffs_to_refresh
			}
		}
	},
	boon_skulls_04_regen = {
		buffs = {
			{
				stat_buff = "cooldown_regen",
				name = "boon_skulls_04_regen",
				remove_buff_func = "boon_skulls_04_regen_remove",
				apply_buff_func = "skulls_event_boon_surge_applied",
				icon = "boon_skulls_04",
				update_func = "boon_skulls_04_regen_update",
				update_frequency = 1,
				duration = MorrisBuffTweakData.boon_skulls_04_data.proc_duration,
				duration_modifier_func = MorrisBuffTweakData.boon_skulls_set_01_data.duration_modifier_func,
				multiplier = function (unit, buff_extension)
					-- function 6
					local multiplier = MorrisBuffTweakData.boon_skulls_04_data.proc_cooldown_regen
					local has_full_set = buff_extension:num_buff_stacks("power_up_boon_skulls_set_bonus_01_event") > 0

					if has_full_set then
						multiplier = multiplier * (1 + MorrisBuffTweakData.boon_skulls_set_bonus_01.effect_amplify_amount)
					end

					return multiplier
				end,
				refresh_duration_of_buffs_on_apply = skulls_buffs_to_refresh
			}
		}
	},
	boon_skulls_04_stack = {
		buffs = {
			{
				is_cooldown = true,
				name = "boon_skulls_04_stack",
				icon = "boon_skulls_04",
				max_stacks = MorrisBuffTweakData.boon_skulls_04_data.total_thp_to_consume
			}
		}
	},
	boon_skulls_05_stack = {
		buffs = {
			{
				ignore_if_not_local = true,
				stat_buff = "power_level",
				name = "boon_skulls_05_stack",
				icon = "boon_skulls_05",
				refresh_durations = true,
				is_cooldown = true,
				synced_buff_to_add = "boon_skulls_05_surge",
				on_max_stacks_func = "add_buff_synced",
				sync_type = "LocalAndServer",
				reset_on_max_stacks = true,
				duration = MorrisBuffTweakData.boon_skulls_05_data.duration,
				duration_modifier_func = MorrisBuffTweakData.boon_skulls_set_01_data.duration_modifier_func,
				multiplier = function (unit, buff_extension)
					-- function 7
					local multiplier = MorrisBuffTweakData.boon_skulls_05_data.power_per_stack
					local has_full_set = buff_extension:num_buff_stacks("power_up_boon_skulls_set_bonus_01_event") > 0

					if has_full_set then
						multiplier = multiplier * (1 + MorrisBuffTweakData.boon_skulls_set_bonus_01.effect_amplify_amount)
					end

					return multiplier
				end,
				max_stacks = MorrisBuffTweakData.boon_skulls_05_data.max_stacks
			}
		}
	},
	boon_skulls_05_surge = {
		buffs = {
			{
				stat_buff = "power_level",
				name = "boon_skulls_05_surge",
				icon = "boon_skulls_05",
				refresh_durations = true,
				apply_buff_func = "skulls_event_boon_surge_applied",
				remove_buff_func = "skulls_event_boon_surge_removed",
				max_stacks = 1,
				duration = MorrisBuffTweakData.boon_skulls_05_data.duration,
				duration_modifier_func = MorrisBuffTweakData.boon_skulls_set_01_data.duration_modifier_func,
				multiplier = function (unit, buff_extension)
					-- function 8
					local multiplier = MorrisBuffTweakData.boon_skulls_05_data.power_on_proc
					local has_full_set = buff_extension:num_buff_stacks("power_up_boon_skulls_set_bonus_01_event") > 0

					if has_full_set then
						multiplier = multiplier * (1 + MorrisBuffTweakData.boon_skulls_set_bonus_01.effect_amplify_amount)
					end

					return multiplier
				end,
				refresh_duration_of_buffs_on_apply = skulls_buffs_to_refresh
			}
		}
	},
	boon_skulls_03_cooldown = {
		buffs = {
			{
				name = "boon_skulls_03_cooldown",
				max_stacks = 1,
				is_cooldown = true,
				icon = "boon_skulls_03",
				duration = MorrisBuffTweakData.boon_skulls_03_data.cooldown,
				duration_modifier_func = function (unit, sub_buff_template, duration, buff_extension, params)
					-- function 9
					local has_full_set = buff_extension:num_buff_stacks("power_up_boon_skulls_set_bonus_01_event") > 0

					if has_full_set then
						duration = duration / (1 + MorrisBuffTweakData.boon_skulls_set_bonus_01.duration_amplify_amount)
					end

					return duration
				end,
				refresh_duration_of_buffs_on_apply = skulls_buffs_to_refresh
			}
		}
	},
	boon_supportbomb_healing_01_zone = {
		buffs = {
			{
				name = "boon_supportbomb_healing_01_zone",
				buff_area_buff = "boon_supportbomb_healing_01_buff",
				area_start_sfx = "Play_boon_aoe_zone_explode_healing",
				area_end_sfx = "Play_boon_aoe_zone_stop",
				enter_area_sfx = "Play_boon_aoe_zone_enter",
				buff_self = true,
				leave_area_sfx = "Play_boon_aoe_zone_exit",
				buff_allies = true,
				buff_area = true,
				area_unit_name = "units/hub_elements/empty",
				area_radius = MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
				buff_sync_type = BuffSyncType.Server,
				duration = MorrisBuffTweakData.boon_supportbomb_shared_data.duration,
				buff_area_particles = {
					{
						orphaned_policy = "destroy",
						first_person = false,
						third_person = true,
						effect = "fx/skulls_2024/boons_zone_base_fx",
						continuous = true,
						destroy_policy = "destroy",
						custom_variables = {
							{
								name = "radius_min_max",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									1
								}
							},
							{
								name = "decal_size",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius * 2.25,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius * 2.25,
									1
								}
							},
							{
								name = "sphere_size",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									1
								}
							}
						},
						material_variables = {}
					}
				}
			}
		}
	},
	boon_supportbomb_healing_01_buff = {
		buffs = {
			{
				heal_type = "heal_from_proc",
				name = "boon_supportbomb_healing_01_buff",
				update_func = "heal_owner",
				update_frequency = 1,
				heal_amount = MorrisBuffTweakData.boon_supportbomb_healing_01_data.heal_amount
			}
		}
	},
	boon_supportbomb_concentration_01_zone = {
		buffs = {
			{
				name = "boon_supportbomb_concentration_01_zone",
				buff_area_buff = "boon_supportbomb_concentration_01_buff",
				area_start_sfx = "Play_boon_aoe_zone_explode_cooldown",
				area_end_sfx = "Play_boon_aoe_zone_stop",
				enter_area_sfx = "Play_boon_aoe_zone_enter",
				buff_self = true,
				leave_area_sfx = "Play_boon_aoe_zone_exit",
				buff_allies = true,
				buff_area = true,
				area_unit_name = "units/hub_elements/empty",
				area_radius = MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
				buff_sync_type = BuffSyncType.Client,
				duration = MorrisBuffTweakData.boon_supportbomb_shared_data.duration,
				buff_area_particles = {
					{
						orphaned_policy = "destroy",
						first_person = false,
						third_person = true,
						effect = "fx/skulls_2024/boons_zone_concentration_fx",
						continuous = true,
						destroy_policy = "destroy",
						custom_variables = {
							{
								name = "radius_min_max",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									1
								}
							},
							{
								name = "decal_size",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius * 2.25,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius * 2.25,
									1
								}
							},
							{
								name = "sphere_size",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									1
								}
							}
						},
						material_variables = {}
					}
				}
			}
		}
	},
	boon_supportbomb_concentration_01_buff = {
		buffs = {
			{
				name = "boon_supportbomb_concentration_01_buff",
				stat_buff = "cooldown_regen",
				multiplier = MorrisBuffTweakData.boon_supportbomb_concentration_01_data.multiplier
			}
		}
	},
	boon_supportbomb_crit_01_zone = {
		buffs = {
			{
				name = "boon_supportbomb_crit_01_zone",
				buff_area_buff = "boon_supportbomb_crit_01_buff",
				area_start_sfx = "Play_boon_aoe_zone_explode_crit",
				area_end_sfx = "Play_boon_aoe_zone_stop",
				enter_area_sfx = "Play_boon_aoe_zone_enter",
				buff_self = true,
				leave_area_sfx = "Play_boon_aoe_zone_exit",
				buff_allies = true,
				buff_area = true,
				area_unit_name = "units/hub_elements/empty",
				area_radius = MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
				buff_sync_type = BuffSyncType.Client,
				duration = MorrisBuffTweakData.boon_supportbomb_shared_data.duration,
				buff_area_particles = {
					{
						orphaned_policy = "destroy",
						first_person = false,
						third_person = true,
						effect = "fx/skulls_2024/boons_zone_crit_fx",
						continuous = true,
						destroy_policy = "destroy",
						custom_variables = {
							{
								name = "radius_min_max",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									1
								}
							},
							{
								name = "decal_size",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius * 2.25,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius * 2.25,
									1
								}
							},
							{
								name = "sphere_size",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									1
								}
							}
						},
						material_variables = {}
					}
				}
			}
		}
	},
	boon_supportbomb_crit_01_buff = {
		buffs = {
			{
				name = "boon_supportbomb_crit_01_buff",
				stat_buff = "critical_strike_chance",
				bonus = MorrisBuffTweakData.boon_supportbomb_crit_01_data.bonus
			}
		}
	},
	boon_supportbomb_speed_01_zone = {
		buffs = {
			{
				name = "boon_supportbomb_speed_01_zone",
				buff_area_buff = "boon_supportbomb_speed_01_buff",
				area_start_sfx = "Play_boon_aoe_zone_explode_attackspeed",
				area_end_sfx = "Play_boon_aoe_zone_stop",
				enter_area_sfx = "Play_boon_aoe_zone_enter",
				buff_self = true,
				leave_area_sfx = "Play_boon_aoe_zone_exit",
				buff_allies = true,
				buff_area = true,
				area_unit_name = "units/hub_elements/empty",
				area_radius = MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
				buff_sync_type = BuffSyncType.Client,
				duration = MorrisBuffTweakData.boon_supportbomb_shared_data.duration,
				buff_area_particles = {
					{
						orphaned_policy = "destroy",
						first_person = false,
						third_person = true,
						effect = "fx/skulls_2024/boons_zone_speed_fx",
						continuous = true,
						destroy_policy = "destroy",
						custom_variables = {
							{
								name = "radius_min_max",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									1
								}
							},
							{
								name = "decal_size",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius * 2.25,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius * 2.25,
									1
								}
							},
							{
								name = "sphere_size",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									1
								}
							}
						},
						material_variables = {}
					}
				}
			}
		}
	},
	boon_supportbomb_speed_01_buff = {
		buffs = {
			{
				name = "boon_supportbomb_speed_01_buff",
				stat_buff = "attack_speed",
				multiplier = MorrisBuffTweakData.boon_supportbomb_speed_01_data.multiplier
			}
		}
	},
	boon_supportbomb_strenght_01_zone = {
		buffs = {
			{
				name = "boon_supportbomb_strenght_01_zone",
				buff_area_buff = "boon_supportbomb_strenght_01_buff",
				area_start_sfx = "Play_boon_aoe_zone_explode_power",
				area_end_sfx = "Play_boon_aoe_zone_stop",
				enter_area_sfx = "Play_boon_aoe_zone_enter",
				buff_self = true,
				leave_area_sfx = "Play_boon_aoe_zone_exit",
				buff_allies = true,
				buff_area = true,
				area_unit_name = "units/hub_elements/empty",
				area_radius = MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
				buff_sync_type = BuffSyncType.ClientAndServer,
				duration = MorrisBuffTweakData.boon_supportbomb_shared_data.duration,
				buff_area_particles = {
					{
						orphaned_policy = "destroy",
						first_person = false,
						third_person = true,
						effect = "fx/skulls_2024/boons_zone_strenght_fx",
						continuous = true,
						destroy_policy = "destroy",
						custom_variables = {
							{
								name = "radius_min_max",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									1
								}
							},
							{
								name = "decal_size",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius * 2.25,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius * 2.25,
									1
								}
							},
							{
								name = "sphere_size",
								value = {
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									MorrisBuffTweakData.boon_supportbomb_shared_data.radius,
									1
								}
							}
						},
						material_variables = {}
					}
				}
			}
		}
	},
	boon_supportbomb_strenght_01_buff = {
		buffs = {
			{
				name = "boon_supportbomb_strenght_01_buff",
				stat_buff = "power_level",
				multiplier = MorrisBuffTweakData.boon_supportbomb_strenght_01_data.multiplier
			}
		}
	},
	boon_career_ability_burning_aoe = {
		buffs = {
			{
				name = "boon_career_ability_burning_aoe",
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				damage_type = "burninating",
				damage_profile = "burning_dot",
				update_func = "apply_dot_damage",
				reapply_buff_func = "reapply_dot_damage",
				buff_sync_type = BuffSyncType.ClientAndServer,
				perks = {
					buff_perks.burning
				},
				max_stacks = MorrisBuffTweakData.boon_career_ability_burning_aoe_data.max_stacks,
				time_between_dot_damages = MorrisBuffTweakData.boon_career_ability_burning_aoe_data.time_between_dot_damages,
				update_start_delay = MorrisBuffTweakData.boon_career_ability_burning_aoe_data.update_start_delay,
				duration = MorrisBuffTweakData.boon_career_ability_burning_aoe_data.duration
			}
		}
	},
	boon_career_ability_poison_aoe = {
		buffs = {
			{
				name = "boon_career_ability_poison_aoe",
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				damage_profile = "poison",
				update_func = "apply_dot_damage",
				reapply_buff_func = "reapply_dot_damage",
				buff_sync_type = BuffSyncType.ClientAndServer,
				perks = {
					buff_perks.poisoned
				},
				max_stacks = MorrisBuffTweakData.boon_career_ability_bleed_aoe_data.max_stacks,
				time_between_dot_damages = MorrisBuffTweakData.boon_career_ability_bleed_aoe_data.time_between_dot_damages,
				update_start_delay = MorrisBuffTweakData.boon_career_ability_bleed_aoe_data.update_start_delay,
				duration = MorrisBuffTweakData.boon_career_ability_bleed_aoe_data.duration
			}
		}
	},
	boon_career_ability_bleed_aoe = {
		buffs = {
			{
				name = "boon_career_ability_burning_aoe",
				refresh_durations = true,
				apply_buff_func = "start_dot_damage",
				damage_profile = "bleed",
				update_func = "apply_dot_damage",
				reapply_buff_func = "reapply_dot_damage",
				buff_sync_type = BuffSyncType.ClientAndServer,
				perks = {
					buff_perks.bleeding
				},
				max_stacks = MorrisBuffTweakData.boon_career_ability_bleed_aoe_data.max_stacks,
				time_between_dot_damages = MorrisBuffTweakData.boon_career_ability_bleed_aoe_data.time_between_dot_damages,
				update_start_delay = MorrisBuffTweakData.boon_career_ability_bleed_aoe_data.update_start_delay,
				duration = MorrisBuffTweakData.boon_career_ability_bleed_aoe_data.duration
			}
		}
	},
	boon_cursed_chest_damage_area_buff = {
		buffs = {
			{
				name = "boon_cursed_chest_damage_area_buff",
				buff_area_buff = "boon_cursed_chest_damage_buff",
				enter_area_func = "enter_buff_area",
				enter_area_sfx = "Play_boon_aoe_zone_enter",
				buff_self = true,
				leave_area_sfx = "Play_boon_aoe_zone_exit",
				buff_allies = true,
				buff_area = true,
				area_unit_name = "units/hub_elements/empty",
				exit_area_func = "exit_buff_area",
				area_radius = MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.radius,
				buff_sync_type = BuffSyncType.ClientAndServer,
				duration = MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.duration,
				buff_area_particles = {
					{
						orphaned_policy = "destroy",
						first_person = false,
						third_person = true,
						effect = "fx/skulls_2024/boons_zone_strenght_fx",
						continuous = true,
						destroy_policy = "destroy",
						custom_variables = {
							{
								name = "radius_min_max",
								value = {
									MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.radius,
									MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.radius,
									1
								}
							},
							{
								name = "decal_size",
								value = {
									MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.radius * 2.25,
									MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.radius * 2.25,
									1
								}
							},
							{
								name = "sphere_size",
								value = {
									MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.radius,
									MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.radius,
									1
								}
							}
						},
						material_variables = {}
					}
				}
			}
		}
	},
	boon_cursed_chest_damage_buff = {
		buffs = {
			{
				name = "boon_cursed_chest_damage_buff",
				stat_buff = "damage_dealt",
				multiplier = MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.damage_multiplier,
				duration = MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.duration,
				max_stacks = MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.max_stacks
			}
		}
	},
	boon_cursed_chest_cooldown_area_buff = {
		buffs = {
			{
				name = "boon_cursed_chest_cooldown_area_buff",
				buff_area_buff = "boon_cursed_chest_cooldown_buff",
				enter_area_func = "enter_buff_area",
				enter_area_sfx = "Play_boon_aoe_zone_enter",
				buff_self = true,
				leave_area_sfx = "Play_boon_aoe_zone_exit",
				buff_allies = true,
				buff_area = true,
				area_unit_name = "units/hub_elements/empty",
				exit_area_func = "exit_buff_area",
				area_radius = MorrisBuffTweakData.boon_cursed_chest_cooldown_area_buff_data.radius,
				buff_sync_type = BuffSyncType.ClientAndServer,
				duration = MorrisBuffTweakData.boon_cursed_chest_cooldown_area_buff_data.duration,
				buff_area_particles = {
					{
						orphaned_policy = "destroy",
						first_person = false,
						third_person = true,
						effect = "fx/skulls_2024/boons_zone_concentration_fx",
						continuous = true,
						destroy_policy = "destroy",
						custom_variables = {
							{
								name = "radius_min_max",
								value = {
									MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.radius,
									MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.radius,
									1
								}
							},
							{
								name = "decal_size",
								value = {
									MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.radius * 2.25,
									MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.radius * 2.25,
									1
								}
							},
							{
								name = "sphere_size",
								value = {
									MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.radius,
									MorrisBuffTweakData.boon_cursed_chest_damage_area_buff_data.radius,
									1
								}
							}
						},
						material_variables = {}
					}
				}
			}
		}
	},
	boon_cursed_chest_cooldown_buff = {
		buffs = {
			{
				name = "boon_cursed_chest_cooldown_buff",
				stat_buff = "cooldown_regen",
				duration = MorrisBuffTweakData.boon_cursed_chest_cooldown_area_buff_data.duration,
				multiplier = MorrisBuffTweakData.boon_cursed_chest_cooldown_area_buff_data.cooldown_multiplier,
				max_stacks = MorrisBuffTweakData.boon_cursed_chest_cooldown_area_buff_data.max_stacks
			}
		}
	}
}

DLCUtils.merge("deus_power_up_buff_templates", DeusPowerUpBuffTemplates)

DeusPowerUpTemplates = DeusPowerUpTemplates
DeusPowerUpIncompatibilityPairs = {
	wh_zealot = {},
	wh_bountyhunter = {
		{
			"talent_6_2",
			"talent_6_3"
		}
	},
	wh_captain = {},
	wh_priest = {},
	bw_scholar = {},
	bw_adept = {},
	bw_unchained = {},
	dr_ironbreaker = {},
	dr_slayer = {},
	dr_ranger = {
		{
			"talent_4_1",
			"talent_4_2"
		},
		{
			"talent_4_1",
			"talent_4_3"
		},
		{
			"talent_4_2",
			"talent_4_3"
		},
		{
			"talent_6_1",
			"talent_6_2"
		}
	},
	dr_engineer = {
		{
			"talent_4_1",
			"talent_4_3"
		},
		{
			"talent_6_1",
			"talent_6_2"
		},
		{
			"talent_6_1",
			"talent_6_3"
		}
	},
	we_shade = {
		{
			"talent_6_1",
			"talent_6_3"
		}
	},
	we_maidenguard = {},
	we_waywatcher = {
		{
			"talent_4_1",
			"talent_4_2"
		},
		{
			"talent_4_2",
			"talent_4_3"
		},
		{
			"talent_6_1",
			"talent_6_2"
		},
		{
			"talent_6_1",
			"talent_6_3"
		}
	},
	we_thornsister = {
		{
			"talent_6_1",
			"talent_6_2"
		},
		{
			"talent_6_2",
			"talent_6_3"
		}
	},
	es_huntsman = {
		{
			"talent_6_2",
			"talent_6_3"
		}
	},
	es_knight = {
		{
			"talent_4_1",
			"talent_4_2"
		},
		{
			"talent_4_1",
			"talent_4_3"
		},
		{
			"talent_4_2",
			"talent_4_3"
		}
	},
	es_mercenary = {
		{
			"talent_4_1",
			"talent_4_2"
		},
		{
			"talent_4_1",
			"talent_4_3"
		},
		{
			"talent_4_2",
			"talent_4_3"
		},
		{
			"talent_2_3",
			"lucky"
		}
	},
	es_questingknight = {
		{
			"talent_6_1",
			"talent_6_3"
		}
	}
}
DeusPowerUpExclusionList = DeusPowerUpExclusionList
DeusPowerUpAvailabilityTypes = DeusPowerUpAvailabilityTypes
DeusPowerUpRarityPool = DeusPowerUpRarityPool
DeusPowerUpSets = {
	{
		completed_sfx = "hud_morris_boon_set_completed",
		progress_sfx = "hud_morris_boon_set_crit_layer",
		pieces = {
			{
				rarity = "rare",
				name = "pent_up_anger"
			},
			{
				rarity = "exotic",
				name = "deus_crit_on_damage_taken"
			},
			{
				rarity = "exotic",
				name = "boon_supportbomb_crit_01"
			}
		},
		rewards = {
			{
				rarity = "unique",
				name = "boonset_crit_set_bonus"
			}
		}
	},
	{
		completed_sfx = "hud_morris_boon_set_completed",
		progress_sfx = "hud_morris_boon_set_crit_layer",
		pieces = {
			{
				rarity = "exotic",
				name = "boonset_drone_part1"
			},
			{
				rarity = "rare",
				name = "boonset_drone_part2"
			},
			{
				rarity = "exotic",
				name = "boonset_drone_part3"
			},
			{
				rarity = "rare",
				name = "boon_careerskill_07"
			}
		},
		rewards = {
			{
				rarity = "unique",
				name = "boonset_drone_part4"
			}
		}
	},
	{
		completed_sfx = "hud_morris_boon_set_completed",
		progress_sfx = "hud_morris_boon_set_skulls2025_01_layer",
		pieces = {
			{
				rarity = "event",
				name = "boon_skulls_01"
			},
			{
				rarity = "event",
				name = "boon_skulls_02"
			},
			{
				rarity = "event",
				name = "boon_skulls_03"
			},
			{
				rarity = "event",
				name = "boon_skulls_04"
			},
			{
				rarity = "event",
				name = "boon_skulls_05"
			}
		},
		rewards = {
			{
				rarity = "event",
				name = "boon_skulls_set_bonus_01"
			}
		}
	},
	{
		completed_sfx = "hud_morris_boon_set_completed",
		progress_sfx = "hud_morris_boon_set_skulls2025_02_layer",
		pieces = {
			{
				rarity = "event",
				name = "boon_skulls_06"
			},
			{
				rarity = "event",
				name = "boon_skulls_07"
			},
			{
				rarity = "event",
				name = "boon_skulls_08"
			}
		},
		rewards = {
			{
				rarity = "event",
				name = "boon_skulls_set_bonus_02"
			}
		}
	}
}
DeusPowerUpRarities = DeusPowerUpRarities
DeusPowerUpTalentLookup = {}

for power_up_name, power_up_settings in pairs(DeusPowerUpTemplates) do
	if power_up_settings.talent then
		local talent_tier = power_up_settings.talent_tier
		local talent_index = power_up_settings.talent_index
		local talent_tier_map = DeusPowerUpTalentLookup[talent_tier]

		DeusPowerUpTalentLookup[talent_tier] = talent_tier_map
		talent_tier_map[talent_index] = power_up_name
	end
end

local is_valid = true
local error_message = "[DeusPowerUpSettings] One or more errors in power_up settings."

for _, power_up_configs in pairs(DeusPowerUpRarityPool) do
	for _, power_config in ipairs(power_up_configs) do
		local power_up_name = power_config[1]

		if not DeusPowerUpTemplates[power_up_name] then
			is_valid = false
			error_message = error_message .. string.format("\n'%s' is in rarity pool but has no template.", power_up_name)
		end
	end
end

if #DeusPowerUpRarities ~= table.size(DeusPowerUpRarityPool) then
	is_valid = false
	error_message = error_message .. string.format("\nSizes of DeusPowerUpRarities (%d) and DeusPowerUpRarityPool (%d) are not the same! Make sure both tables have the same rarities!", #DeusPowerUpRarities, table.size(DeusPowerUpRarityPool))
end

for _, rarity in ipairs(DeusPowerUpRarities) do
	if not DeusPowerUpRarityPool[rarity] then
		is_valid = false
		error_message = error_message .. string.format("\nDeusPowerUpRarities contains the rarity '%s' which is missing in DeusPowerUpRarityPool.", rarity)
	end
end

for _, rarity in ipairs(DeusPowerUpRarities) do
	local power_up_costs = DeusCostSettings.shop.power_ups

	if not power_up_costs[rarity] then
		error_message = error_message .. string.format("\nPower up with the rarity '%s' can be generated but there is no cost settings for that.", rarity)
	end
end

assert(is_valid, error_message)

DeusPowerUps = DeusPowerUps
DeusPowerUpsArray = DeusPowerUpsArray
DeusPowerUpsArrayByRarity = table.select_map(table.set(DeusPowerUpRarities), function (_, rarity)
	-- function 11
	return {}
end)
DeusPowerUpSetLookup = table.select_map(table.set(DeusPowerUpRarities), function (_, rarity)
	-- function 12
	return {}
end)
DeusPowerUpsLookup = {}

for career_name, incompatibility_list in pairs(DeusPowerUpIncompatibilityPairs) do
	for _, pair in ipairs(incompatibility_list) do
		local power_up_1 = pair[1]
		local power_up_2 = pair[2]
		local power_up_1_template = DeusPowerUpTemplates[power_up_1]
		local power_up_2_template = DeusPowerUpTemplates[power_up_2]

		assert(power_up_1_template, tostring(power_up_1) .. "in DeusPowerUpIncompatibilityPairs, but not in DeusPowerUpTemplates")
		assert(power_up_2_template, tostring(power_up_2) .. "in DeusPowerUpIncompatibilityPairs, but not in DeusPowerUpTemplates")

		local incompatibility_1 = power_up_1_template.incompatibility
		local incompatibility_2 = power_up_2_template.incompatibility
		local career_incompatibility_1 = incompatibility_1[career_name]
		local career_incompatibility_2 = incompatibility_2[career_name]

		career_incompatibility_1[#career_incompatibility_1 + 1] = power_up_2
		career_incompatibility_2[#career_incompatibility_2 + 1] = power_up_1
		incompatibility_1[career_name] = career_incompatibility_1
		incompatibility_2[career_name] = career_incompatibility_2
		power_up_1_template.incompatibility = incompatibility_1
		power_up_2_template.incompatibility = incompatibility_2
	end
end

for rarity, power_up_configs in pairs(DeusPowerUpRarityPool) do
	DeusPowerUps[rarity] = {}

	for _, power_up_config in ipairs(power_up_configs) do
		local power_up_name = power_up_config[1]
		local availability = power_up_config[2]
		local mutators = power_up_config[3]
		local template = DeusPowerUpTemplates[power_up_name]
		local new_power_up = Script.new_map(13)

		new_power_up.name = power_up_name
		new_power_up.rarity = rarity
		new_power_up.mutators = mutators
		new_power_up.availability = availability
		new_power_up.max_amount = template.max_amount
		new_power_up.incompatibility = template.incompatibility
		new_power_up.weight = template.weight

		if template.talent then
			new_power_up.talent = true
			new_power_up.talent_tier = template.talent_tier
			new_power_up.talent_index = template.talent_index
		else
			new_power_up.display_name = template.display_name
			new_power_up.plain_display_name = template.plain_display_name
			new_power_up.buff_name = "power_up_" .. power_up_name .. "_" .. rarity
			new_power_up.advanced_description = template.advanced_description
			new_power_up.description_values = template.description_values
			new_power_up.icon = template.icon

			local buff_template = table.clone(template.buff_template)
			local tweak_data = MorrisBuffTweakData[power_up_name]

			if tweak_data then
				for key, value in pairs(tweak_data) do
					buff_template.buffs[1][key] = value
				end
			end

			buff_template.buffs[1].name = new_power_up.buff_name
			DeusPowerUpBuffTemplates[new_power_up.buff_name] = buff_template
		end

		DeusPowerUps[rarity][power_up_name] = new_power_up

		table.insert(DeusPowerUpsArray, new_power_up)

		DeusPowerUps[rarity][power_up_name].id = #DeusPowerUpsArray

		table.insert(DeusPowerUpsArrayByRarity[rarity], new_power_up)

		DeusPowerUps[rarity][power_up_name].lookup_id = #DeusPowerUpsLookup + 1
		DeusPowerUpsLookup[#DeusPowerUpsLookup + 1] = new_power_up
		DeusPowerUpsLookup[power_up_name] = new_power_up
	end
end

for _, power_up_set in pairs(DeusPowerUpSets) do
	for _, set_piece_settings in pairs(power_up_set.pieces) do
		local rarity = set_piece_settings.rarity
		local name = set_piece_settings.name

		DeusPowerUpSetLookup[rarity][name] = DeusPowerUpSetLookup[rarity][name]

		table.insert(DeusPowerUpSetLookup[rarity][name], power_up_set)
	end

	for _, set_reward_settings in pairs(power_up_set.rewards) do
		local rarity = set_reward_settings.rarity
		local name = set_reward_settings.name

		DeusPowerUpSetLookup[rarity][name] = DeusPowerUpSetLookup[rarity][name]

		table.insert(DeusPowerUpSetLookup[rarity][name], power_up_set)
	end
end
