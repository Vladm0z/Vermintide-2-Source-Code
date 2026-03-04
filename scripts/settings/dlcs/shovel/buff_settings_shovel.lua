-- chunkname: @scripts/settings/dlcs/shovel/buff_settings_shovel.lua

require("scripts/settings/profiles/career_constants")

local var_0_0 = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local var_0_1 = require("scripts/utils/stagger_types")
local var_0_2 = DLCSettings.shovel
local var_0_3 = 4
local var_0_4 = 2 * var_0_3
local var_0_5 = {}

local function var_0_6(arg_1_0, arg_1_1, arg_1_2)
	if not Managers.state.network.is_server then
		return
	end

	if not ScriptUnit.has_extension(arg_1_0, "buff_system") then
		return
	end

	local var_1_0 = "necromancer_cursed_blood"
	local var_1_1 = arg_1_2 and ScriptUnit.has_extension(arg_1_2, "talent_system")

	if var_1_1 and var_1_1:has_talent("sienna_necromancer_4_2") then
		var_1_0 = "necromancer_cursed_blood_dot"
	end

	Managers.state.entity:system("buff_system"):add_buff(arg_1_0, var_1_0, arg_1_1, true, nil, arg_1_2)
end

local function var_0_7(arg_2_0, arg_2_1)
	local var_2_0 = ScriptUnit.extension(arg_2_0, "first_person_system")

	var_2_0:play_hud_sound_event("Play_career_necro_ability_trapped_souls")

	local var_2_1 = Managers.state.side.side_by_unit[arg_2_0]
	local var_2_2 = var_2_1 and var_2_1.enemy_broadphase_categories
	local var_2_3 = FrameTable.alloc_table()

	AiUtils.broadphase_query(POSITION_LOOKUP[arg_2_0], arg_2_1, var_2_3, var_2_2)

	local var_2_4 = var_2_3[1]
	local var_2_5 = "necromancer_trapped_soul"
	local var_2_6, var_2_7 = var_2_0:camera_position_rotation()
	local var_2_8 = Quaternion.yaw(var_2_7)
	local var_2_9 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_2_7)))
	local var_2_10 = 1
	local var_2_11 = Projectiles.necromancer_trapped_soul
	local var_2_12 = "necromancer_trapped_soul"
	local var_2_13 = 0
	local var_2_14 = false
	local var_2_15 = ScriptUnit.extension(arg_2_0, "career_system"):get_career_power_level()

	Managers.state.entity:system("projectile_system"):spawn_ai_true_flight_projectile(arg_2_0, var_2_4, var_2_5, var_2_6, var_2_7, var_2_8, var_2_9, var_2_10, var_2_11, var_2_12, var_2_13, var_2_14, var_2_15)
end

local function var_0_8(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	World.create_particles(arg_3_3, "fx/necromancer_summon_decal", arg_3_1)

	arg_3_2.fx_spline_ids = arg_3_2.fx_spline_ids or {
		World.find_particles_variable(arg_3_3, "fx/wpnfx_staff_death/curse_spirit", "spline_1"),
		World.find_particles_variable(arg_3_3, "fx/wpnfx_staff_death/curse_spirit", "spline_2"),
		World.find_particles_variable(arg_3_3, "fx/wpnfx_staff_death/curse_spirit", "spline_3")
	}

	local var_3_0 = NetworkLookup.effects["fx/wpnfx_staff_death/curse_spirit_first"]
	local var_3_1 = POSITION_LOOKUP[arg_3_0] + Vector3.up() * 0.5
	local var_3_2 = arg_3_1 - var_3_1
	local var_3_3
	local var_3_4 = ScriptUnit.has_extension(arg_3_0, "first_person_system")

	if var_3_4 then
		var_3_3 = var_3_4:current_rotation()
	else
		var_3_3 = Quaternion.look(var_3_2, Vector3.up())
	end

	local var_3_5 = Quaternion.right(var_3_3)
	local var_3_6 = var_3_1 + var_3_5 * math.random(-0.5, 0.5)
	local var_3_7 = math.sign(Vector3.dot(var_3_2, var_3_5))
	local var_3_8 = math.pi * math.random(0.1, 0.25)
	local var_3_9 = Quaternion.axis_angle(Vector3.up(), var_3_8 * var_3_7)
	local var_3_10 = var_3_6 + Quaternion.rotate(var_3_9, var_3_2) * 0.5 + Vector3.up() * 2
	local var_3_11 = {
		var_3_6,
		var_3_10,
		arg_3_1
	}
end

local function var_0_9(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = POSITION_LOOKUP[arg_4_0]
	local var_4_1 = Managers.state.side.side_by_unit
	local var_4_2 = arg_4_1.source_attacker_unit

	if not ALIVE[var_4_2] then
		return
	end

	local var_4_3 = var_4_1[var_4_2]
	local var_4_4 = FrameTable.alloc_table()
	local var_4_5 = arg_4_1.template.debuff_spread_radius
	local var_4_6 = AiUtils.broadphase_query(POSITION_LOOKUP[arg_4_0], var_4_5, var_4_4)
	local var_4_7
	local var_4_8 = math.huge

	for iter_4_0 = 1, var_4_6 do
		local var_4_9 = var_4_4[iter_4_0]
		local var_4_10 = var_4_1[var_4_9]

		if var_4_9 ~= arg_4_0 and var_4_3 ~= var_4_10 and HEALTH_ALIVE[var_4_9] then
			local var_4_11 = Vector3.distance_squared(POSITION_LOOKUP[var_4_9], var_4_0)

			if var_4_11 < var_4_8 then
				var_4_8 = var_4_11
				var_4_7 = var_4_9
			end
		end
	end

	if var_4_7 then
		local var_4_12 = ScriptUnit.has_extension(var_4_7, "buff_system")

		if var_4_12 then
			local var_4_13 = FrameTable.alloc_table()

			var_4_13.attacker_unit = arg_4_0
			var_4_13.source_attacker_unit = var_4_2

			local var_4_14 = Managers.state.difficulty:get_difficulty()
			local var_4_15 = Unit.get_data(arg_4_0, "breed")
			local var_4_16 = 1

			if var_4_15.elite then
				var_4_16 = 2
			end

			if var_4_15.special then
				var_4_16 = 3
			end

			if var_4_15.primary_armor_category and var_4_15.primary_armor_category == 6 or var_4_15.armor_category == 6 then
				var_4_16 = 4
			end

			if var_4_15.boss then
				var_4_16 = 5
			end

			var_4_13.external_optional_value = ({
				normal = {
					12,
					24,
					32,
					40,
					120
				},
				hard = {
					18,
					36,
					48,
					60,
					180
				},
				harder = {
					26.25,
					52.5,
					70,
					87.5,
					262.5
				},
				hardest = {
					39.75,
					79.5,
					106,
					132.5,
					397.5
				},
				cataclysm = {
					50.25,
					100.5,
					134,
					167.5,
					500
				}
			})[var_4_14][var_4_16] or 1

			var_4_12:add_buff("necromancer_on_death_delayed_health_damage", var_4_13)

			local var_4_17
			local var_4_18 = Unit.has_node(var_4_7, "j_spine") and Unit.node(var_4_7, "j_spine")

			if var_4_18 then
				var_4_17 = Unit.world_position(var_4_7, var_4_18)
			else
				var_4_17 = POSITION_LOOKUP[var_4_7] + 0.5 * Vector3.up()
			end

			if var_4_17 then
				var_0_8(arg_4_0, var_4_17, arg_4_1, arg_4_3)
			end
		end
	end
end

local function var_0_10(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_1.delayed_damage_procced then
		return
	end

	arg_5_1.delayed_damage_procced = true

	local var_5_0 = arg_5_1.source_attacker_unit
	local var_5_1 = arg_5_1.source_spread_position:unbox()
	local var_5_2 = POSITION_LOOKUP[arg_5_0]
	local var_5_3 = Vector3.normalize(var_5_2 - var_5_1)
	local var_5_4 = var_5_1 + (var_5_2 - var_5_1) * 0.5

	Managers.state.entity:system("audio_system"):play_audio_position_event("Play_career_necro_passive_shadow_blood", var_5_4)

	local var_5_5 = arg_5_1.value
	local var_5_6 = ScriptUnit.has_extension(var_5_0, "career_system"):get_career_power_level()
	local var_5_7 = DamageProfileTemplates.curse_on_hit

	DamageUtils.add_damage_network_player(var_5_7, nil, var_5_6, arg_5_0, var_5_0, "torso", var_5_2, Vector3.up(), "undefined")

	local var_5_8 = BLACKBOARDS[arg_5_0]
	local var_5_9 = 1
	local var_5_10 = var_0_1.medium
	local var_5_11 = 1
	local var_5_12
	local var_5_13 = Managers.time:time("game")
	local var_5_14 = 1
	local var_5_15 = true

	AiUtils.stagger(arg_5_0, var_5_8, var_5_0, var_5_3, var_5_9, var_5_10, var_5_11, var_5_12, var_5_13, var_5_14, var_5_15)
	ScriptUnit.extension(arg_5_0, "buff_system"):remove_buff(arg_5_1.id)
end

local function var_0_11(arg_6_0, arg_6_1, arg_6_2)
	if not ALIVE[arg_6_0] then
		return
	end

	local var_6_0 = var_0_3 * 0.8
	local var_6_1 = arg_6_1.target_center:unbox()
	local var_6_2 = arg_6_1.seed or math.random_seed()
	local var_6_3
	local var_6_4
	local var_6_5, var_6_6

	arg_6_1.seed, var_6_5, var_6_6 = math.get_uniformly_random_point_inside_sector_seeded(var_6_2, 0, var_6_0, 0, 2 * math.pi)

	local var_6_7 = var_6_1 + Vector3(var_6_5, var_6_6, 0)
	local var_6_8 = Managers.state.entity:system("ai_system"):nav_world()
	local var_6_9 = Managers.state.entity:system("ai_slot_system"):traverse_logic()
	local var_6_10, var_6_11 = GwNavQueries.raycast(var_6_8, var_6_1, var_6_7, var_6_9)
	local var_6_12 = ScriptUnit.extension(arg_6_0, "career_system"):get_passive_ability_by_name("bw_necromancer"):spawn_army_pet(arg_6_2, var_6_11, NecromancerPositionModes.Absolute)

	return var_6_11, var_6_12
end

local function var_0_12(arg_7_0)
	local var_7_0 = Managers.player:owner(arg_7_0)

	return var_7_0 and not var_7_0.remote
end

var_0_2.buff_templates = {
	sienna_necromancer_passive_cursed_blood = {
		buffs = {
			{
				event = "on_critical_hit",
				name = "sienna_necromancer_passive_cursed_blood",
				buff_func = "necromancer_apply_cursed_blood"
			}
		}
	},
	sienna_necromancer_career_skill_damage_proc_aura = {
		buffs = {
			{
				ai_buff_name = "sienna_necromancer_career_skill_damage_proc_aura_buff_ai",
				range = 15,
				name = "sienna_necromancer_career_skill_damage_proc_aura",
				remove_buff_func = "remove_side_buff_aura",
				owner_as_source = true,
				player_buff_name = "sienna_necromancer_career_skill_damage_proc_aura_buff",
				server_only = true,
				update_func = "side_buff_aura",
				update_frequency = 1
			}
		}
	},
	sienna_necromancer_career_skill_damage_proc_aura_buff = {
		buffs = {
			{
				max_stacks = 1,
				name = "sienna_necromancer_career_skill_damage_proc_aura_buff",
				damage = 10,
				buff_func = "sienna_necromancer_career_skill_damage_proc",
				event = "on_hit"
			}
		}
	},
	sienna_necromancer_career_skill_damage_proc_aura_buff_ai = {
		buffs = {
			{
				max_stacks = 1,
				name = "sienna_necromancer_career_skill_damage_proc_aura_buff_ai",
				damage = 10,
				buff_func = "sienna_necromancer_career_skill_damage_proc",
				event = "on_damage_dealt"
			}
		}
	},
	sienna_necromancer_career_skill_on_hit_damage = {
		buffs = {
			{
				remove_buff_func = "remove_attach_particle",
				name = "sienna_necromancer_career_skill_on_hit_damage",
				offset_rotation_y = 90,
				particle_fx = "fx/skull_trap",
				max_stacks = 1,
				duration = 10,
				apply_buff_func = "sienna_necromancer_on_hit_apply"
			}
		}
	},
	necromancer_cursed_blood = {
		buffs = {
			{
				explosion_template = "sienna_necromancer_passive_explosion",
				name = "necromancer_cursed_blood",
				max_stacks = 1,
				buff_func = "necromancer_cursed_blood_on_death",
				event = "on_death",
				debuff_spread_radius = 5
			}
		}
	},
	necromancer_skeleton_timer = {
		buffs = {
			{
				icon = "sienna_necromancer_6_1",
				name = "necromancer_cursed_blood",
				duration = 20
			}
		}
	},
	necromancer_harvest_curse = {
		buffs = {
			{
				max_stacks = 1,
				name = "necromancer_harvest_curse"
			}
		}
	},
	necromancer_on_death_delayed_health_damage = {
		buffs = {
			{
				debuff_spread_radius = 5,
				name = "necromancer_on_death_delayed_health_damage",
				remove_on_proc = true,
				buff_func = "delayed_health_damage",
				event = "on_death",
				apply_buff_func = "setup_delayed_damage",
				update_start_delay = 0.1,
				max_stacks = 1,
				update_func = "delayed_health_damage"
			}
		}
	},
	necromancer_cursed_blood_dot = {
		buffs = {
			{
				debuff_spread_radius = 5,
				name = "necromancer_cursed_blood",
				damage_profile = "bleed",
				buff_func = "necromancer_cursed_blood_on_death",
				event = "on_death",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 1.5,
				explosion_template = "sienna_necromancer_passive_explosion",
				time_between_dot_damages = 1.5,
				max_stacks = 1,
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.bleeding
				}
			}
		}
	},
	necromancer_cursed_blood_delayed_damage = {
		buffs = {
			{
				name = "necromancer_cursed_blood_delayed_damage",
				max_stacks = 1,
				update_func = "remove_and_apply_cursed_blood",
				apply_buff_func = "setup_delayed_damage",
				update_start_delay = 0.3
			}
		}
	},
	sienna_necromancer_pet_on_spawn_buff = {
		buffs = {
			{
				remove_buff_func = "sienna_necromancer_expire_spawned_pet",
				name = "lifetime"
			},
			{
				event = "on_damage_dealt",
				name = "hud_sound_trigger",
				buff_func = "on_pet_damage_dealt",
				sounds_to_play = {
					"career_necro_skeleton_damage"
				}
			}
		}
	},
	sienna_necromancer_pet_on_spawn_buff_charge = {
		buffs = {
			{
				event = "on_death",
				name = "pet_tracker",
				buff_func = "add_pet_charge"
			}
		}
	},
	sienna_necromancer_pet_attack_sfx = {
		buffs = {
			{
				event = "on_damage_dealt",
				name = "hud_sound_trigger",
				buff_func = "on_pet_damage_dealt",
				sounds_to_play = {
					"career_necro_skeleton_damage"
				}
			}
		}
	},
	sienna_necromancer_perk_1 = {
		buffs = {
			{
				update_func = "sienna_necromancer_perk_1_func",
				name = "sienna_necromancer_perk_1",
				radius = 5,
				devour_health_percent = 0.15
			}
		}
	},
	necromancer_invulnerability_aura = {
		buffs = {
			{
				max_stacks = 1,
				name = "necromancer_invulnerability_aura",
				icon = "sienna_necromancer_passive",
				perks = {
					var_0_0.invulnerable
				}
			}
		}
	},
	sienna_necromancer_perk_3 = {
		buffs = {
			{
				event = "on_kill",
				name = "sienna_necromancer_perk_3",
				buff_to_add = "sienna_necromancer_lifetaker_crit",
				buff_func = "add_buff"
			}
		}
	},
	sienna_necromancer_lifetaker_crit = {
		buffs = {
			{
				refresh_durations = true,
				name = "sienna_necromancer_lifetaker_crit",
				stat_buff = "critical_strike_chance",
				icon = "sienna_necromancer_passive",
				bonus = CareerConstants.bw_necromancer.lifetaker_bonus,
				max_stacks = CareerConstants.bw_necromancer.lifetaker_max_stacks,
				duration = CareerConstants.bw_necromancer.lifetaker_duration
			}
		}
	},
	sienna_pets_alive_cooldown = {
		buffs = {
			{
				multiplier = 5,
				name = "sienna_pets_alive_cooldown",
				stat_buff = "cooldown_regen"
			}
		}
	},
	sienna_pet_spawn_charge = {
		buffs = {
			{
				duration = 20,
				name = "sienna_pet_spawn_charge",
				refresh_other_stacks_on_remove = true,
				duration_end_func = "spawn_pet",
				max_stacks = 4,
				icon = "unit_frame_portrait_pet_skeleton",
				is_cooldown = true
			}
		}
	},
	necromancer_pet_ping_explosion = {
		buffs = {
			{
				remove_buff_func = "pet_ping_explosion",
				name = "sienna_pet_ping_explosion",
				particles = {
					{
						orphaned_policy = "destroy",
						effect = "fx/warp_lightning_bolt",
						third_person = true,
						first_person = false,
						link_node = "j_spine",
						continuous = true,
						destroy_policy = "destroy"
					}
				}
			}
		}
	},
	sienna_necromancer_empowered_overcharge = {
		buffs = {
			{
				stat_buff = "overcharge_damage_immunity",
				name = "sienna_necromancer_empowered_overcharge",
				buff_func = "sienna_necromancer_empowered_overcharge_kill",
				max_stacks = 1,
				icon = "sienna_necromancer_6_3",
				event = "on_kill",
				percent_overcharge = 0.1,
				perks = {
					var_0_0.overcharge_no_slow
				}
			}
		}
	},
	death_staff_dot = {
		buffs = {
			{
				duration = 6,
				name = "death_staff_dot",
				apply_buff_func = "start_dot_damage",
				update_start_delay = 1,
				time_between_dot_damages = 1,
				damage_type = "burninating",
				damage_profile = "death_staff_dot",
				update_func = "apply_dot_damage",
				perks = {
					var_0_0.burning
				}
			}
		}
	},
	dual_wield_skeleton_attack_speed = {
		buffs = {
			{
				value = 1,
				name = "dual_wield_skeleton_attack_speed",
				apply_buff_func = "apply_ai_attack_speed",
				remove_buff_func = "remove_ai_attack_speed"
			}
		}
	},
	update_anim_movespeed = {
		buffs = {
			{
				update_func = "update_anim_movespeed",
				name = "update_anim_movespeed"
			}
		}
	},
	raise_dead_ability = {
		buffs = {
			{
				update_frequency = 0.2,
				name = "raise_dead_ability",
				remove_buff_on_duration_end = true,
				update_func = "raise_dead_update",
				apply_buff_func = "on_raise_dead_start",
				update_start_delay = 0.2,
				apply_condition = function (arg_8_0, arg_8_1, arg_8_2)
					return var_0_12(arg_8_2.source_attacker_unit)
				end,
				area_radius = var_0_3
			},
			{
				name = "raise_dead_ability_curse_aura",
				buff_area_buff = "sienna_necromancer_career_skill_on_hit_damage",
				buff_area = true,
				area_unit_name = "units/hub_elements/empty",
				buff_enemies = true,
				apply_condition = function (arg_9_0, arg_9_1, arg_9_2)
					local var_9_0 = ScriptUnit.has_extension(arg_9_2.source_attacker_unit, "talent_system")

					return var_9_0 and var_9_0:has_talent("sienna_necromancer_6_2_2")
				end,
				area_radius = var_0_3
			},
			{
				num_small_decals = 0,
				name = "raise_dead_ability_visuals",
				delay = 0.02,
				remove_buff_func = "raise_dead_remove",
				apply_buff_func = "raise_dead_apply",
				skull_spawn_frequency = 0.15,
				update_func = "raise_dead_visual_update",
				unit_names = {
					"units/decals/necromancer_ability_decal_mark1",
					"units/decals/necromancer_ability_decal_mark2",
					"units/decals/necromancer_ability_decal_mark3",
					"units/decals/necromancer_ability_decal_mark4",
					"units/decals/necromancer_ability_decal_mark5",
					"units/decals/necromancer_ability_decal_mark6"
				},
				num_skulls = {
					max = 8,
					min = 4
				},
				area_radius = var_0_3
			}
		}
	},
	raise_dead_ability_stagger = {
		buffs = {
			{
				max_stacks = 1,
				name = "raise_dead_ability_stagger",
				update_func = "necromancer_ability_stagger_update",
				update_frequency = 0.75,
				apply_condition = function (arg_10_0, arg_10_1, arg_10_2)
					return Managers.state.network.is_server
				end
			},
			{
				max_stacks = 1,
				name = "raise_dead_ability_stagger_visuals",
				update_func = "necromancer_ability_stagger_hands"
			}
		}
	},
	command_elite_challenge_tracker = {
		buffs = {
			{
				max_stacks = 1,
				name = "command_elite_challenge_tracker"
			}
		}
	},
	skeleton_command_attack_boost = {
		buffs = {
			{
				multiplier = 1,
				name = "skeleton_command_attack_boost",
				stat_buff = "damage_dealt",
				duration = 8,
				max_stacks = 1,
				refresh_durations = true
			}
		}
	},
	skeleton_command_defend_boost = {
		buffs = {
			{
				multiplier = -0.12,
				name = "skeleton_command_defend_boost",
				stat_buff = "damage_taken"
			}
		}
	}
}
var_0_2.proc_functions = {
	sienna_necromancer_5_1_on_kill = function (arg_11_0, arg_11_1, arg_11_2)
		if not ALIVE[arg_11_0] then
			return
		end

		if not arg_11_2[1] then
			return
		end

		if arg_11_2[2].elite then
			local var_11_0 = arg_11_1.template.multiplier

			ScriptUnit.extension(arg_11_0, "career_system"):reduce_activated_ability_cooldown_percent(var_11_0)
		end
	end,
	sienna_necromancer_add_recast_ready = function (arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = arg_12_2[2]

		if ScriptUnit.extension(arg_12_0, "career_system"):current_ability_cooldown(var_12_0) == 0 then
			local var_12_1 = ScriptUnit.extension(arg_12_0, "buff_system")
			local var_12_2 = arg_12_1.template.buff_to_add
			local var_12_3 = var_12_1:add_buff(var_12_2)
			local var_12_4 = var_12_1:get_buff_by_id(var_12_3)

			var_12_4._source_buff = arg_12_1
			var_12_4._needs_target = arg_12_1.template.needs_target
		end
	end,
	necromancer_trigger_recast = function (arg_13_0, arg_13_1, arg_13_2)
		local var_13_0 = arg_13_2[2]
		local var_13_1 = ScriptUnit.extension(arg_13_0, "career_system")
		local var_13_2 = var_13_1:current_ability_cooldown(var_13_0)
		local var_13_3 = var_13_1:ability_by_id(var_13_0):num_alive_career_ability_pets()

		if var_13_2 == 0 and var_13_3 > 0 then
			return false
		end

		local var_13_4 = ScriptUnit.extension(arg_13_0, "buff_system")

		table.clear(var_0_5)
		var_13_4:add_buff(arg_13_1.template.cooldown_buff)

		return true
	end,
	necromancer_apply_cursed_blood = function (arg_14_0, arg_14_1, arg_14_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_14_0 = arg_14_1.necromancer_unit

		if not var_14_0 then
			local var_14_1 = FindProfileIndex("bright_wizard")
			local var_14_2 = career_index_from_name(var_14_1, "bw_necromancer")
			local var_14_3 = Managers.player:human_and_bot_players()

			for iter_14_0, iter_14_1 in pairs(var_14_3) do
				if var_14_2 == iter_14_1:career_index() then
					var_14_0 = iter_14_1.player_unit
					arg_14_1.necromancer_unit = var_14_0

					break
				end
			end
		end

		local var_14_4 = arg_14_2[1]

		var_0_6(var_14_4, arg_14_0, var_14_0)
	end,
	sienna_necromancer_career_skill_damage_proc = function (arg_15_0, arg_15_1, arg_15_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_15_0 = arg_15_2[1]
		local var_15_1 = arg_15_1.source_attacker_unit

		if not ALIVE[var_15_1] then
			return
		end

		if not arg_15_1.last_hit_t then
			arg_15_1.last_hit_t = 0
		end

		local var_15_2 = Managers.time:time("game")

		if var_15_2 < arg_15_1.last_hit_t then
			return
		else
			arg_15_1.last_hit_t = var_15_2 + 0.05
		end

		local var_15_3 = arg_15_1.template.damage
		local var_15_4 = ScriptUnit.has_extension(var_15_0, "buff_system")

		if var_15_4 and var_15_4:has_buff_type("sienna_necromancer_career_skill_on_hit_damage") then
			local var_15_5 = ScriptUnit.has_extension(var_15_1, "career_system"):get_career_power_level()
			local var_15_6 = DamageProfileTemplates.curse_on_hit

			DamageUtils.add_damage_network_player(var_15_6, nil, var_15_5, var_15_0, var_15_1, "torso", POSITION_LOOKUP[var_15_0], Vector3.up(), "undefined")
		end
	end,
	sienna_necromancer_add_buff_to_pet = function (arg_16_0, arg_16_1, arg_16_2)
		local var_16_0 = arg_16_2[1]
		local var_16_1 = arg_16_1.template.buff_to_add
		local var_16_2 = ScriptUnit.extension(var_16_0, "buff_system")

		table.clear(var_0_5)

		var_0_5.attacker_unit = arg_16_0

		var_16_2:add_buff(var_16_1, var_0_5)
	end,
	sienna_necromancer_low_hp_kill_on_hit = function (arg_17_0, arg_17_1, arg_17_2)
		local var_17_0 = arg_17_1.template

		if var_17_0.health_threshold < ScriptUnit.extension(arg_17_0, "health_system"):current_health_percent() then
			return false
		end

		local var_17_1 = var_17_0.cooldown_buff

		ScriptUnit.extension(arg_17_0, "buff_system"):add_buff(var_17_1, var_0_5)

		if not Managers.state.network.is_server then
			return true
		end

		local var_17_2 = Managers.state.side.side_by_unit
		local var_17_3 = var_17_2[arg_17_0]
		local var_17_4 = POSITION_LOOKUP[arg_17_0]
		local var_17_5 = var_17_0.num_enemies
		local var_17_6 = var_17_0.radius
		local var_17_7 = FrameTable.alloc_table()
		local var_17_8 = AiUtils.broadphase_query(var_17_4, var_17_6, var_17_7)

		local function var_17_9(arg_18_0, arg_18_1)
			local var_18_0 = var_17_2[arg_18_0]

			if var_18_0 ~= var_17_2[arg_18_1] then
				return var_18_0 ~= var_17_3
			end

			return Vector3.distance_squared(var_17_4, POSITION_LOOKUP[arg_18_0]) < Vector3.distance_squared(var_17_4, POSITION_LOOKUP[arg_18_1])
		end

		table.sort(var_17_7, var_17_9)

		local var_17_10 = math.min(var_17_8, var_17_5)

		for iter_17_0 = 1, var_17_10 do
			local var_17_11 = var_17_7[iter_17_0]
			local var_17_12 = BLACKBOARDS[var_17_11].breed
			local var_17_13 = var_17_12 and var_17_12.boss

			if var_17_2[var_17_11] == var_17_3 then
				break
			end

			if not var_17_13 then
				AiUtils.kill_unit(var_17_11, arg_17_0)
			end
		end

		return true
	end,
	on_pet_damage_dealt = function (arg_19_0, arg_19_1, arg_19_2)
		local var_19_0 = arg_19_2[1]

		if arg_19_0 == var_19_0 then
			return
		end

		if arg_19_2[10] == "bleed" then
			return
		end

		local var_19_1 = arg_19_1.source_attacker_unit

		if not Managers.player:unit_owner(var_19_1) then
			return
		end

		local var_19_2 = arg_19_1.template.sounds_to_play
		local var_19_3 = var_19_2[math.random(1, #var_19_2)]
		local var_19_4 = Unit.has_node(var_19_0, "j_spine") and "j_spine" or nil

		Managers.state.entity:system("audio_system"):play_audio_unit_event(var_19_3, var_19_0, var_19_4)
	end,
	add_pet_charge = function (arg_20_0, arg_20_1, arg_20_2)
		local var_20_0 = arg_20_1.source_attacker_unit

		if not ALIVE[arg_20_0] then
			return
		end

		if ScriptUnit.extension(var_20_0, "status_system"):is_dead() then
			return
		end

		ScriptUnit.extension(var_20_0, "career_system"):get_passive_ability_by_name("bw_necromancer"):add_pet_charge(arg_20_0)
	end,
	sienna_necromancer_5_3_free_charge = function (arg_21_0, arg_21_1, arg_21_2)
		local var_21_0 = arg_21_2[1]

		if HEALTH_ALIVE[var_21_0] then
			return
		end

		local var_21_1 = arg_21_1.template.buff_to_add

		ScriptUnit.extension(arg_21_0, "buff_system"):add_buff(var_21_1)
	end,
	sienna_necromancer_on_kill_harvest = function (arg_22_0, arg_22_1, arg_22_2)
		local var_22_0 = arg_22_2[3]
		local var_22_1 = ScriptUnit.has_extension(var_22_0, "buff_system")

		if var_22_1 and var_22_1:has_buff_type("sienna_necromancer_career_skill_on_hit_damage") then
			local var_22_2 = ScriptUnit.has_extension(arg_22_0, "buff_system")

			if var_22_2 then
				var_22_2:add_buff("sienna_necromancer_6_2_buff")
			end
		end
	end,
	thank_you_skeletal_add = function (arg_23_0, arg_23_1, arg_23_2)
		if ScriptUnit.extension(arg_23_0, "ai_commander_system"):get_controlled_units_count() >= arg_23_1.template.skeleton_count then
			local var_23_0 = ScriptUnit.extension(arg_23_0, "buff_system")
			local var_23_1 = arg_23_1.template.buff_to_add

			var_23_0:add_buff(var_23_1)
		end
	end,
	thank_you_skeletal_remove = function (arg_24_0, arg_24_1, arg_24_2)
		if ScriptUnit.extension(arg_24_0, "ai_commander_system"):get_controlled_units_count() <= arg_24_1.template.skeleton_count - 1 then
			local var_24_0 = ScriptUnit.extension(arg_24_0, "buff_system")
			local var_24_1 = arg_24_1.template.buff_to_remove
			local var_24_2 = var_24_0:get_stacking_buff(var_24_1)

			if var_24_2 and #var_24_2 > 0 then
				var_24_0:remove_buff(var_24_2[1].id)
			end
		end
	end,
	trapped_souls_overcharge_lost = function (arg_25_0, arg_25_1, arg_25_2)
		local var_25_0 = arg_25_2[1]
		local var_25_1 = arg_25_2[2]

		arg_25_1.total_overcharge_lost = arg_25_1.total_overcharge_lost + var_25_0

		local var_25_2 = arg_25_1.total_overcharge_lost / var_25_1
		local var_25_3 = arg_25_1.template.overcharge_threshold
		local var_25_4 = var_25_2 / var_25_3
		local var_25_5 = 7.5

		for iter_25_0 = 1, var_25_4 do
			arg_25_1.total_overcharge_lost = arg_25_1.total_overcharge_lost - var_25_3 * var_25_1

			var_0_7(arg_25_0, var_25_5)
		end
	end,
	sienna_necromancer_empowered_overcharge_kill = function (arg_26_0, arg_26_1, arg_26_2)
		local var_26_0 = arg_26_1.template.percent_overcharge
		local var_26_1 = ScriptUnit.extension(arg_26_0, "overcharge_system")
		local var_26_2 = var_26_1:get_max_value()

		var_26_1:remove_charge(var_26_2 * var_26_0)
	end,
	remove_necromancer_creeping_curse_always_blocking = function (arg_27_0, arg_27_1, arg_27_2)
		local var_27_0 = ScriptUnit.extension(arg_27_0, "status_system")
		local var_27_1 = not Managers.state.network.is_server

		var_27_0:set_override_blocking(nil, var_27_1)
		ScriptUnit.extension(arg_27_0, "buff_system"):remove_buff(arg_27_1.id)
	end,
	remove_buff_stack_on_proc = function (arg_28_0, arg_28_1, arg_28_2)
		local var_28_0 = ScriptUnit.extension(arg_28_0, "buff_system")
		local var_28_1 = arg_28_1.template.buff_to_add
		local var_28_2 = var_28_0:get_stacking_buff(var_28_1)

		if var_28_2 and #var_28_2 > 0 then
			var_28_0:remove_buff(var_28_2[1].id)
		end

		if not var_28_2 or #var_28_2 < 1 then
			var_28_0:remove_buff(arg_28_1.id)
		end
	end,
	necromancer_on_death_damage = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
		var_0_9(arg_29_0, arg_29_1, arg_29_2, arg_29_3)

		return true
	end,
	delayed_health_damage = function (arg_30_0, arg_30_1, arg_30_2)
		var_0_10(arg_30_0, arg_30_1, arg_30_2)

		return true
	end,
	necromancer_ability_register_stagger = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
		if not ALIVE[arg_31_0] then
			return
		end

		local var_31_0 = ScriptUnit.has_extension(arg_31_0, "buff_system")

		if var_31_0 then
			table.clear(var_0_5)

			var_0_5.source_attacker_unit = arg_31_4
			var_0_5.attacker_unit = arg_31_1

			var_31_0:add_buff("raise_dead_ability_stagger", var_0_5)
		end
	end,
	necromancer_ability_unregister_stagger = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
		if not ALIVE[arg_32_0] then
			return
		end

		local var_32_0 = ScriptUnit.has_extension(arg_32_0, "buff_system")

		if var_32_0 then
			local var_32_1 = var_32_0:get_stacking_buff("raise_dead_ability_stagger_visuals")

			var_32_1 = var_32_1 and var_32_1[1]

			if var_32_1 then
				var_32_0:remove_buff(var_32_1.id)
			end
		end
	end,
	necromancer_crit_burst = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
		if not arg_33_2[arg_33_4.is_critical_strike] then
			return
		end

		if not arg_33_2[arg_33_4.first_hit] then
			return
		end

		local var_33_0 = arg_33_2[arg_33_4.attacked_unit]
		local var_33_1, var_33_2 = Managers.state.status_effect:has_status(var_33_0, StatusEffectNames.burning_balefire)

		if not var_33_1 or var_33_2 then
			return
		end

		local var_33_3 = arg_33_2[arg_33_4.damage_amount]

		if var_33_3 <= 0 then
			return
		end

		local var_33_4 = arg_33_1.template
		local var_33_5 = Managers.state.side.side_by_unit[arg_33_0]
		local var_33_6 = POSITION_LOOKUP[var_33_0]

		if not var_33_6 then
			return
		end

		local var_33_7 = Managers.state.unit_storage:go_id(var_33_0)
		local var_33_8 = 0

		if Unit.has_node(var_33_0, "j_spine") then
			var_33_8 = Unit.node(var_33_0, "j_spine")
		end

		local var_33_9 = Managers.state.network

		var_33_9.network_transmit:send_rpc_server("rpc_play_particle_effect", NetworkLookup.effects["fx/necromancer_cursed_explosion_blood"], var_33_7, var_33_8, Vector3.zero(), Quaternion.identity(), false)
		var_33_9.network_transmit:send_rpc_server("rpc_play_particle_effect", NetworkLookup.effects["fx/necromancer_cursed_explosion_blue"], var_33_7, var_33_8, Vector3(0.5, 0, 0), Quaternion.identity(), false)
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_career_necro_ability_cursed_blood", var_33_0, "j_spine")

		local var_33_10 = var_33_5.enemy_broadphase_categories
		local var_33_11 = FrameTable.alloc_table()
		local var_33_12 = AiUtils.broadphase_query(var_33_6, var_33_4.radius, var_33_11, var_33_10)

		if var_33_12 == 0 then
			return
		end

		local var_33_13 = Managers.time:time("game")
		local var_33_14 = var_33_3 * var_33_4.propagation_multiplier
		local var_33_15 = ScriptUnit.extension(arg_33_0, "career_system"):get_career_power_level()

		for iter_33_0 = 1, var_33_12 do
			local var_33_16 = var_33_11[iter_33_0]

			if var_33_16 ~= var_33_0 then
				local var_33_17 = Vector3.normalize(POSITION_LOOKUP[var_33_16] - var_33_6)

				DamageUtils.add_damage_network(var_33_16, arg_33_0, var_33_14, "torso", "buff", nil, var_33_17, "buff", nil, arg_33_0, nil, nil, false, nil, nil, nil, nil, true, iter_33_0)
				DamageUtils.stagger_ai(var_33_13, DamageProfileTemplates.necromancer_crit_burst_stagger, iter_33_0 + 1, var_33_15, var_33_16, arg_33_0, "torso", var_33_17, nil, nil, false, "buff", arg_33_0)
			end
		end
	end,
	spawn_ripped_soul = function (arg_34_0, arg_34_1, arg_34_2)
		if arg_34_2[1][2] == "execute" then
			return
		end

		local var_34_0 = arg_34_2[3]

		if not Managers.state.status_effect:has_status(var_34_0, "burning_balefire") then
			return
		end

		local var_34_1 = POSITION_LOOKUP[var_34_0] + Vector3(0, 0, 1)
		local var_34_2 = arg_34_1.template.orb_settings.orb_name
		local var_34_3 = Managers.player:owner(arg_34_0).peer_id
		local var_34_4 = Vector3(0, 0, 1)
		local var_34_5 = 2 * math.pi

		Managers.state.entity:system("orb_system"):spawn_orb(var_34_2, var_34_3, var_34_1, var_34_4, var_34_5)
	end,
	execute_man_sized_enemy = function (arg_35_0, arg_35_1, arg_35_2)
		local var_35_0 = arg_35_2[1]
		local var_35_1 = ALIVE[var_35_0] and Unit.get_data(var_35_0, "breed")

		if not var_35_1 or var_35_1.boss then
			return false
		end

		if not HEALTH_ALIVE[var_35_0] then
			return false
		end

		AiUtils.kill_unit(var_35_0, arg_35_0, nil, "execute")

		return true
	end,
	cursed_vigor_proc = function (arg_36_0, arg_36_1, arg_36_2)
		if arg_36_0 == arg_36_2[1] then
			ProcFunctions.add_buff_local(arg_36_0, arg_36_1, arg_36_2)
		end
	end
}

local function var_0_13(arg_37_0)
	local var_37_0 = Managers.player:owner(arg_37_0)

	return var_37_0 and var_37_0.bot_player
end

var_0_2.buff_function_templates = {
	sienna_necromancer_perk_1_func = function (arg_38_0, arg_38_1, arg_38_2)
		local var_38_0 = arg_38_0

		if ALIVE[var_38_0] and Managers.player.is_server then
			local var_38_1 = arg_38_1.template
			local var_38_2 = var_38_1.radius
			local var_38_3 = var_38_1.devour_health_percent
			local var_38_4 = POSITION_LOOKUP[var_38_0]
			local var_38_5 = FrameTable.alloc_table()
			local var_38_6 = Managers.state.entity:system("proximity_system").enemy_broadphase
			local var_38_7 = Broadphase.query(var_38_6, var_38_4, var_38_2, var_38_5)
			local var_38_8 = Managers.state.side

			for iter_38_0 = 1, var_38_7 do
				local var_38_9 = var_38_5[iter_38_0]

				if ALIVE[var_38_9] and var_38_8:is_enemy(var_38_0, var_38_9) then
					local var_38_10 = ScriptUnit.has_extension(var_38_9, "health_system")

					if var_38_10 and var_38_3 > var_38_10:current_health_percent() then
						local var_38_11 = var_38_10:current_health()

						DamageUtils.add_damage_network(var_38_9, var_38_0, var_38_11, "full", "buff", nil, Vector3(1, 0, 0), "buff", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, iter_38_0)
					end
				end
			end
		end
	end,
	necromancer_update_knockdown_damage_immunity = function (arg_39_0, arg_39_1, arg_39_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_39_0 = arg_39_1.knocked_down_players or {}

		arg_39_1.knocked_down_players = var_39_0

		local var_39_1 = Managers.state.side.side_by_unit[arg_39_0]
		local var_39_2 = GameModeHelper.side_is_disabled(var_39_1:name())
		local var_39_3 = var_39_1.PLAYER_AND_BOT_UNITS
		local var_39_4 = Managers.state.entity:system("buff_system")
		local var_39_5 = arg_39_1.template.radius
		local var_39_6 = var_39_5 * var_39_5
		local var_39_7 = POSITION_LOOKUP[arg_39_0]

		for iter_39_0 = 1, #var_39_3 do
			repeat
				local var_39_8 = var_39_3[iter_39_0]

				if var_39_8 == arg_39_0 then
					break
				end

				local var_39_9 = var_39_0[var_39_8]

				if not ALIVE[var_39_8] then
					var_39_0[var_39_8] = nil

					break
				end

				local var_39_10 = ScriptUnit.extension(var_39_8, "status_system")

				if var_39_2 or not var_39_10:is_knocked_down() then
					if var_39_9 then
						var_39_4:remove_buff_synced(var_39_8, var_39_9)
					end

					var_39_0[var_39_8] = nil

					break
				end

				local var_39_11 = POSITION_LOOKUP[var_39_8]

				if var_39_6 < Vector3.length_squared(var_39_11 - var_39_7) then
					if var_39_9 then
						var_39_4:remove_buff_synced(var_39_8, var_39_9)
					end

					var_39_0[var_39_8] = nil

					break
				end

				if not var_39_9 then
					local var_39_12 = arg_39_1.template.buff_to_add
					local var_39_13 = Managers.player:owner(var_39_8)

					var_39_0[var_39_8] = var_39_4:add_buff_synced(var_39_8, var_39_12, BuffSyncType.ClientAndServer, nil, var_39_13.peer_id)
				end
			until true
		end
	end,
	necromancer_knockdown_damage_immunity_remove_all = function (arg_40_0, arg_40_1, arg_40_2)
		if not Managers.state.network.is_server then
			return
		end

		local var_40_0 = arg_40_1.knocked_down_players

		if not var_40_0 then
			return
		end

		local var_40_1 = Managers.state.entity:system("buff_system")

		for iter_40_0, iter_40_1 in pairs(var_40_0) do
			if ALIVE[iter_40_0] then
				var_40_1:remove_buff_synced(iter_40_0, iter_40_1)
			end
		end

		arg_40_1.knocked_down_players = nil
	end,
	necromancer_remove_orb_buffs = function (arg_41_0, arg_41_1, arg_41_2)
		local var_41_0 = ScriptUnit.has_extension(arg_41_0, "buff_system")

		if var_41_0 then
			local var_41_1 = var_41_0:get_stacking_buff("sienna_necromancer_4_2_soul_rip_stack")

			if var_41_1 and #var_41_1 > 0 then
				for iter_41_0 = 1, #var_41_1 do
					local var_41_2 = var_41_1[1].id

					var_41_0:remove_buff(var_41_2)
				end
			end

			local var_41_3 = var_41_0:get_stacking_buff("sienna_necromancer_4_2_execute")

			if var_41_3 and #var_41_3 > 0 then
				for iter_41_1 = 1, #var_41_3 do
					local var_41_4 = var_41_3[1].id

					var_41_0:remove_buff(var_41_4)
				end
			end
		end
	end,
	sienna_necromancer_expire_spawned_pet = function (arg_42_0, arg_42_1, arg_42_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_42_0] then
			AiUtils.kill_unit(arg_42_0)
		end
	end,
	sienna_necromancer_on_hit_apply = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
		if not arg_43_1.fx_id then
			local var_43_0 = World.create_particles(arg_43_3, arg_43_1.template.particle_fx, POSITION_LOOKUP[arg_43_0])

			arg_43_1.fx_id = var_43_0

			local var_43_1 = arg_43_1.template

			if Unit.has_node(arg_43_0, "j_spine") then
				local var_43_2 = Unit.local_rotation(arg_43_0, Unit.node(arg_43_0, "j_spine"))
				local var_43_3 = Quaternion.from_euler_angles_xyz(var_43_1.offset_rotation_x or 0, var_43_1.offset_rotation_y or 0, var_43_1.offset_rotation_z or 0)
				local var_43_4 = Matrix4x4.from_quaternion(Quaternion.multiply(var_43_2, var_43_3))

				World.link_particles(arg_43_3, var_43_0, arg_43_0, Unit.node(arg_43_0, "j_spine"), var_43_4, "stop")
			end
		end
	end,
	setup_delayed_damage = function (arg_44_0, arg_44_1, arg_44_2)
		local var_44_0 = arg_44_1.attacker_unit

		arg_44_1.source_spread_position = Vector3Box(POSITION_LOOKUP[var_44_0])
	end,
	career_skill_health_reduction = function (arg_45_0, arg_45_1, arg_45_2)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_45_0] then
			local var_45_0 = arg_45_1.source_attacker_unit
			local var_45_1 = ScriptUnit.has_extension(var_45_0, "talent_system")
			local var_45_2 = AiUtils.unit_breed(arg_45_0)

			if var_45_1 and var_45_1:has_talent("sienna_necromancer_6_1") and var_45_2.elite then
				Managers.state.entity:system("buff_system"):add_buff(arg_45_0, "necromancer_cursed_blood", var_45_0, true, nil, var_45_0)
			end

			if var_45_1 and var_45_1:has_talent("sienna_necromancer_6_2") then
				Managers.state.entity:system("buff_system"):add_buff(arg_45_0, "necromancer_harvest_curse", var_45_0, true, nil, var_45_0)
			end

			local var_45_3 = ScriptUnit.has_extension(arg_45_0, "health_system")
			local var_45_4 = 0

			if var_45_3 then
				var_45_4 = var_45_3:current_health() / 2
			end

			DamageUtils.add_damage_network(arg_45_0, var_45_0, var_45_4, "torso", "buff", nil, Vector3(0, 0, 0), "career_ability", nil, var_45_0, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	delayed_health_damage = function (arg_46_0, arg_46_1, arg_46_2)
		var_0_10(arg_46_0, arg_46_1, arg_46_2)
		ScriptUnit.extension(arg_46_0, "buff_system"):remove_buff(arg_46_1.id)
	end,
	remove_and_apply_cursed_blood = function (arg_47_0, arg_47_1, arg_47_2)
		local var_47_0 = arg_47_1.source_attacker_unit
		local var_47_1 = arg_47_1.source_spread_position:unbox()
		local var_47_2 = DamageProfileTemplates.sienna_necromancer_blood_explosion
		local var_47_3 = 1
		local var_47_4 = DefaultPowerLevel
		local var_47_5 = arg_47_0
		local var_47_6 = "full"
		local var_47_7 = POSITION_LOOKUP[arg_47_0]
		local var_47_8 = Vector3.normalize(var_47_7 - var_47_1)
		local var_47_9 = "buff"
		local var_47_10 = false
		local var_47_11
		local var_47_12 = false
		local var_47_13
		local var_47_14 = true
		local var_47_15 = 1
		local var_47_16
		local var_47_17 = var_47_0
		local var_47_18 = var_47_1 + (var_47_7 - var_47_1) * 0.5

		Managers.state.entity:system("audio_system"):play_audio_position_event("Play_career_necro_passive_shadow_blood", var_47_18)
		DamageUtils.add_damage_network_player(var_47_2, var_47_3, var_47_4, arg_47_0, var_47_5, var_47_6, var_47_7, var_47_8, var_47_9, var_47_10, var_47_11, var_47_12, var_47_13, var_47_14, var_47_15, var_47_16, var_47_17)

		local var_47_19 = BLACKBOARDS[arg_47_0]
		local var_47_20 = 1
		local var_47_21 = var_0_1.medium
		local var_47_22 = 1
		local var_47_23
		local var_47_24 = Managers.time:time("game")
		local var_47_25 = 1
		local var_47_26 = true

		AiUtils.stagger(arg_47_0, var_47_19, var_47_0, var_47_8, var_47_20, var_47_21, var_47_22, var_47_23, var_47_24, var_47_25, var_47_26)
		ScriptUnit.extension(arg_47_0, "buff_system"):remove_buff(arg_47_1.id)
	end,
	spawn_pet = function (arg_48_0, arg_48_1, arg_48_2)
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_48_0] then
			return
		end

		if ScriptUnit.extension(arg_48_0, "status_system"):is_dead() then
			return
		end

		ScriptUnit.extension(arg_48_0, "career_system"):get_passive_ability_by_name("bw_necromancer"):consume_pet_charge(arg_48_1.id)
	end,
	pet_ping_explosion = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
		if not Managers.state.network.is_server then
			return
		end

		if ALIVE[arg_49_0] then
			local var_49_0 = POSITION_LOOKUP[arg_49_0]
			local var_49_1 = arg_49_1.source_attacker_unit
			local var_49_2 = ScriptUnit.has_extension(var_49_1, "career_system")
			local var_49_3 = var_49_2 and var_49_2:get_career_power_level() or DefaultPowerLevel

			Managers.state.entity:system("area_damage_system"):create_explosion(var_49_1, var_49_0, Quaternion.identity(), "sienna_necromancer_passive_explosion", 1, "buff", var_49_3, false)
		end

		local var_49_4 = ScriptUnit.has_extension(arg_49_0, "health_system")

		if var_49_4 and not var_49_4:is_dead() then
			AiUtils.kill_unit(arg_49_0)
		end
	end,
	necromancer_5_3_setup = function (arg_50_0, arg_50_1, arg_50_2)
		arg_50_1.total_overcharge_lost = 0
	end,
	necromancer_cursed_area_buff = function (arg_51_0, arg_51_1, arg_51_2)
		if not ALIVE[arg_51_0] then
			return false
		end

		if var_0_12(arg_51_0) and not var_0_13(arg_51_0) then
			-- Nothing
		end
	end,
	necromancer_cursed_area_buff_remove = function (arg_52_0, arg_52_1, arg_52_2)
		local var_52_0 = arg_52_0

		if var_0_12(var_52_0) and not var_0_13(var_52_0) then
			-- Nothing
		end
	end,
	apply_necromancer_creeping_curse_always_blocking = function (arg_53_0, arg_53_1, arg_53_2)
		if arg_53_0 == arg_53_2.attacker_unit then
			local var_53_0 = ScriptUnit.extension(arg_53_0, "status_system")
			local var_53_1 = not Managers.state.network.is_server

			var_53_0:set_override_blocking(true, var_53_1)
			var_53_0:remove_all_fatigue()
		end
	end,
	necromancer_apply_num_buffs = function (arg_54_0, arg_54_1, arg_54_2)
		local var_54_0 = arg_54_1.template
		local var_54_1 = var_54_0.hit_soak_num
		local var_54_2 = var_54_0.buff_to_add
		local var_54_3 = ScriptUnit.extension(arg_54_0, "buff_system")

		for iter_54_0 = 1, var_54_1 do
			var_54_3:add_buff(var_54_2)
		end
	end,
	apply_ai_attack_speed = function (arg_55_0, arg_55_1, arg_55_2)
		local var_55_0 = arg_55_1.template.value
		local var_55_1 = Unit.animation_find_variable(arg_55_0, "attack_speed")
		local var_55_2 = Unit.animation_get_variable(arg_55_0, var_55_1)

		Unit.animation_set_variable(arg_55_0, var_55_1, var_55_2 + var_55_0)
	end,
	remove_ai_attack_speed = function (arg_56_0, arg_56_1, arg_56_2)
		local var_56_0 = arg_56_1.template.value
		local var_56_1 = Unit.animation_find_variable(arg_56_0, "attack_speed")
		local var_56_2 = Unit.animation_get_variable(arg_56_0, var_56_1)

		Unit.animation_set_variable(arg_56_0, var_56_1, var_56_2 - var_56_0)
	end,
	update_anim_movespeed = function (arg_57_0, arg_57_1, arg_57_2)
		local var_57_0 = POSITION_LOOKUP[arg_57_0]

		arg_57_1.last_pos = arg_57_1.last_pos or Vector3Box(var_57_0)

		local var_57_1 = arg_57_1.last_pos:unbox()

		arg_57_1.last_pos:store(var_57_0)

		local var_57_2 = 1
		local var_57_3 = Vector3.length(var_57_0 - var_57_1) / var_57_2

		if var_57_3 > 0 then
			local var_57_4 = arg_57_1.var_id or Unit.animation_find_variable(arg_57_0, "move_speed")

			arg_57_1.var_id = var_57_4

			Unit.animation_set_variable(arg_57_0, var_57_4, var_57_3)

			return arg_57_1._next_update_t + var_57_2
		end

		return arg_57_1._next_update_t + 0.25
	end,
	on_raise_dead_start = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
		local var_58_0 = arg_58_1.source_attacker_unit

		ScriptUnit.extension(var_58_0, "career_system"):get_passive_ability_by_name("bw_necromancer"):kill_pets()
	end,
	raise_dead_update = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3)
		if arg_59_1._spawning_done then
			arg_59_1._grace_timer = arg_59_1._grace_timer or arg_59_2.time_into_buff + 0.5

			if arg_59_2.time_into_buff > arg_59_1._grace_timer then
				ScriptUnit.extension(arg_59_0, "buff_system"):remove_buff(arg_59_1.id)
			end

			return
		end

		local var_59_0 = arg_59_1.spawn_data
		local var_59_1 = arg_59_1.source_attacker_unit
		local var_59_2 = (arg_59_1.spawn_index or 0) + 1

		arg_59_1.spawn_index = var_59_2

		local function var_59_3()
			if ALIVE[var_59_1] then
				local var_60_0, var_60_1 = var_0_11(var_59_1, var_59_0, var_59_2 - 1)

				if var_60_0 then
					var_0_8(var_59_1, var_60_0, arg_59_1, arg_59_3)
				end

				arg_59_1._spawning_done = var_60_1
			end
		end

		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(var_59_3)

		return Managers.time:time("game") + (arg_59_1.template.update_frequency + math.random() * 0.2 - 0.1)
	end,
	raise_dead_apply = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
		arg_61_1.skulls = {}
		arg_61_1.num_skulls = 0

		local var_61_0 = Managers.state.unit_storage:go_id(arg_61_0)
		local var_61_1 = var_61_0
		local var_61_2 = var_61_0
		local var_61_3 = arg_61_1.template
		local var_61_4 = var_61_3.unit_names
		local var_61_5 = #var_61_4
		local var_61_6 = 0
		local var_61_7 = Vector3(11, 11, 1)
		local var_61_8 = POSITION_LOOKUP[arg_61_0]

		arg_61_1.units = {}

		local var_61_9 = ScriptUnit.extension(arg_61_0, "buff_system"):get_buff_type("raise_dead_ability")
		local var_61_10 = var_61_9 and var_61_9.duration or math.huge
		local var_61_11
		local var_61_12
		local var_61_13
		local var_61_14
		local var_61_15 = var_61_3.num_small_decals

		for iter_61_0 = 1, var_61_15 do
			local var_61_16

			var_61_1, var_61_16 = Math.next_random(var_61_1, 1, var_61_5)

			local var_61_17 = var_61_4[var_61_16]
			local var_61_18, var_61_19

			var_61_2, var_61_18, var_61_19 = math.get_uniformly_random_point_inside_sector_seeded(var_61_2, 0, var_61_6 - 0.5, 0, math.pi * 2)

			local var_61_20 = var_61_8 + Vector3(var_61_18, var_61_19, 0)
			local var_61_21

			var_61_1, var_61_21 = math.next_random_range(var_61_1, 0, math.pi * 2)

			local var_61_22 = Quaternion.axis_angle(Vector3.up(), var_61_21)
			local var_61_23 = World.spawn_unit(arg_61_3, var_61_17, var_61_20, var_61_22)

			Unit.set_local_scale(var_61_23, 0, var_61_7)

			arg_61_1.units[iter_61_0] = var_61_23

			local var_61_24 = World.time(Application.main_world())
			local var_61_25 = var_61_24 + var_61_10
			local var_61_26 = 1.5

			Unit.set_vector2_for_material(var_61_23, "projector", "start_end_time", Vector2(var_61_24, var_61_25))
			Unit.set_scalar_for_material(var_61_23, "projector", "fade_time", var_61_26)
			Unit.set_scalar_for_material(var_61_23, "projector", "enable_fade", 1)
		end
	end,
	raise_dead_remove = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
		if var_0_12(arg_62_1.source_attacker_unit) and ALIVE[arg_62_0] then
			Managers.state.unit_spawner:mark_for_deletion(arg_62_0)
		end

		if ALIVE[arg_62_1.area_buff_unit] then
			Managers.state.unit_spawner:mark_for_deletion(arg_62_1.area_buff_unit)
		end

		local var_62_0 = arg_62_1.units

		if var_62_0 then
			for iter_62_0 = 1, #var_62_0 do
				local var_62_1 = var_62_0[iter_62_0]

				World.destroy_unit(arg_62_3, var_62_1)
			end
		end

		local var_62_2 = Managers.state.network.is_server

		for iter_62_1, iter_62_2 in pairs(arg_62_1.skulls) do
			if var_62_2 then
				Managers.level_transition_handler.transient_package_loader:remove_unit(iter_62_1)
			end

			World.destroy_unit(arg_62_3, iter_62_1)
		end
	end,
	raise_dead_visual_update = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
		local var_63_0 = arg_63_1.template
		local var_63_1 = var_63_0.delay
		local var_63_2 = arg_63_2.time_into_buff

		if var_63_2 - var_63_1 < 0 then
			return
		end

		local var_63_3 = var_63_2 - var_63_1
		local var_63_4 = math.min(var_63_0.num_skulls.min + math.floor(var_63_3 / var_63_0.skull_spawn_frequency), var_63_0.num_skulls.max)
		local var_63_5 = POSITION_LOOKUP[arg_63_0]

		arg_63_1.skulls = arg_63_1.skulls
		arg_63_1.num_skulls = arg_63_1.num_skulls

		local var_63_6 = POSITION_LOOKUP[arg_63_0]

		for iter_63_0 = arg_63_1.num_skulls, var_63_4 do
			local var_63_7 = math.random() * math.tau / var_63_0.num_skulls.min * iter_63_0 + Math.random_range(-0.05, 0.05)
			local var_63_8 = Vector3.rotate(Vector3(var_63_0.area_radius, 0, 0), var_63_7)
			local var_63_9 = iter_63_0 % 2 * 2 - 1
			local var_63_10 = Quaternion.look(Vector3.cross(Vector3.up(), var_63_8) * var_63_9)
			local var_63_11 = "units/beings/player/bright_wizard_necromancer/talents/trapped_soul_skull"
			local var_63_12 = World.spawn_unit(arg_63_3, var_63_11, var_63_6 + var_63_8, var_63_10)

			if Managers.state.network.is_server then
				Managers.level_transition_handler.transient_package_loader:add_unit(var_63_12, var_63_11)
			end

			arg_63_1.skulls[var_63_12] = {
				start_t = var_63_3,
				level_out_height = Math.random_range(1, 1),
				start_angle = var_63_7,
				rot_direction = var_63_9,
				angular_velocity = Math.random_range(0.5, 0.8) * math.pi,
				outward_offset = Math.random_range(-0.1, 0) * var_63_0.area_radius
			}
			arg_63_1.num_skulls = arg_63_1.num_skulls + 1
		end

		for iter_63_1, iter_63_2 in pairs(arg_63_1.skulls) do
			local var_63_13 = var_63_3 - iter_63_2.start_t

			if var_63_13 > 4 then
				if Managers.state.network.is_server then
					Managers.level_transition_handler.transient_package_loader:remove_unit(iter_63_1)
				end

				World.destroy_unit(arg_63_3, iter_63_1)

				arg_63_1.skulls[iter_63_1] = nil

				return
			end

			local var_63_14 = iter_63_2.start_angle + iter_63_2.angular_velocity * var_63_13 * iter_63_2.rot_direction
			local var_63_15 = Vector3.rotate(Vector3(var_63_0.area_radius + iter_63_2.outward_offset, 0, 0), var_63_14)

			var_63_15[3] = 0.5 + (1.3 * var_63_13)^2 * iter_63_2.level_out_height

			local var_63_16 = var_63_5 + var_63_15
			local var_63_17 = Unit.local_position(iter_63_1, 0)
			local var_63_18 = Quaternion.look(var_63_16 - var_63_17)

			Unit.set_local_position(iter_63_1, 0, var_63_16)
			Unit.set_local_rotation(iter_63_1, 0, var_63_18)
		end
	end,
	necromancer_ability_stagger_update = function (arg_64_0, arg_64_1, arg_64_2)
		local var_64_0 = arg_64_2.attacker_unit
		local var_64_1 = arg_64_2.source_attacker_unit

		if not ALIVE[var_64_0] or not ALIVE[var_64_1] then
			return
		end

		local var_64_2 = POSITION_LOOKUP[arg_64_0]
		local var_64_3 = POSITION_LOOKUP[var_64_0] - var_64_2
		local var_64_4 = Vector3.normalize(var_64_3)
		local var_64_5 = BLACKBOARDS[arg_64_0]
		local var_64_6 = math.min(math.max(Vector3.length(var_64_3) - 1, 0) * 0.25, 0.5)
		local var_64_7 = var_0_1.medium
		local var_64_8 = 1.5
		local var_64_9
		local var_64_10 = Managers.time:time("game")
		local var_64_11 = 2
		local var_64_12 = true

		AiUtils.stagger(arg_64_0, var_64_5, var_64_1, var_64_4, var_64_6, var_64_7, var_64_8, var_64_9, var_64_10, var_64_11, var_64_12)
	end,
	necromancer_ability_stagger_hands = function (arg_65_0, arg_65_1, arg_65_2)
		local var_65_0 = arg_65_2.attacker_unit
		local var_65_1 = POSITION_LOOKUP[arg_65_0]
		local var_65_2 = POSITION_LOOKUP[var_65_0] - var_65_1
		local var_65_3 = Vector3.normalize(var_65_2)
		local var_65_4 = Quaternion.look(Vector3.flat(var_65_3))
		local var_65_5 = Vector3.length(var_65_2)
		local var_65_6 = var_65_3 * math.clamp(var_65_5 - 1, 1, 2)
		local var_65_7 = 0.1
		local var_65_8 = Vector3(0, 0, -var_65_7 * math.random())
		local var_65_9 = "units/beings/enemies/undead_skeleton_hand/chr_undead_skeleton_hand"
		local var_65_10 = Managers.state.unit_spawner:spawn_local_unit(var_65_9, var_65_1 + var_65_8 + var_65_6, var_65_4)
		local var_65_11 = Unit.animation_find_constraint_target(var_65_10, "look_at")

		Unit.animation_set_constraint_target(var_65_10, var_65_11, var_65_1)

		local var_65_12 = 1.25
		local var_65_13 = 1.75
		local var_65_14 = math.lerp(var_65_12, var_65_13, math.random())

		Unit.set_local_scale(var_65_10, 0, Vector3(var_65_14, var_65_14, var_65_14))

		local var_65_15 = Managers.time:time("game")
		local var_65_16 = var_65_5 < 1.5 and 1.5 or 0.6
		local var_65_17 = var_65_5 < 1.5 and 3 or 0.8

		return var_65_15 + math.random(var_65_16, var_65_17)
	end
}
