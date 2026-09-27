-- chunkname: @scripts/settings/dlcs/shovel/buff_settings_shovel.lua

require("scripts/settings/profiles/career_constants")

local scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names = require("scripts/unit_extensions/default_player_unit/buffs/settings/buff_perk_names")
local scripts_utils_stagger_types = require("scripts/utils/stagger_types")
local shovel = DLCSettings.shovel
local num = 4
local num_2 = 2 * num
local tbl = {}

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	if not Managers.state.network.is_server then
		return
	end

	if not ScriptUnit.has_extension(arg_1_0, "buff_system") then
		return
	end

	local str = "necromancer_cursed_blood"
	local flag = not arg_1_2 and ScriptUnit.has_extension(arg_1_2, "talent_system")

	if not flag and not flag:has_talent("sienna_necromancer_4_2") then
		str = "necromancer_cursed_blood_dot"
	end

	Managers.state.entity:system("buff_system"):add_buff(arg_1_0, str, arg_1_1, true, nil, arg_1_2)
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local extension = ScriptUnit.extension(arg_2_0, "first_person_system")

	extension:play_hud_sound_event("Play_career_necro_ability_trapped_souls")

	local var_2_1 = Managers.state.side.side_by_unit[arg_2_0]
	local flag = not var_2_1 and var_2_1.enemy_broadphase_categories
	local alloc_table = FrameTable.alloc_table()

	AiUtils.broadphase_query(POSITION_LOOKUP[arg_2_0], arg_2_1, alloc_table, flag)

	local var_2_4 = alloc_table[1]
	local str = "necromancer_trapped_soul"
	local camera_position_rotation, var_2_7 = extension:camera_position_rotation()
	local yaw = Quaternion.yaw(var_2_7)
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(var_2_7)))
	local num = 1
	local necromancer_trapped_soul = Projectiles.necromancer_trapped_soul
	local str_2 = "necromancer_trapped_soul"
	local num_2 = 0
	local flag_2 = false
	local get_career_power_level = ScriptUnit.extension(arg_2_0, "career_system"):get_career_power_level()

	Managers.state.entity:system("projectile_system"):spawn_ai_true_flight_projectile(arg_2_0, var_2_4, str, camera_position_rotation, var_2_7, yaw, normalize, num, necromancer_trapped_soul, str_2, num_2, flag_2, get_career_power_level)
end

local function fn_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	World.create_particles(arg_3_3, "fx/necromancer_summon_decal", arg_3_1)

	local fx_spline_ids = arg_3_2.fx_spline_ids

	fx_spline_ids = fx_spline_ids or {
		World.find_particles_variable(arg_3_3, "fx/wpnfx_staff_death/curse_spirit", "spline_1"),
		World.find_particles_variable(arg_3_3, "fx/wpnfx_staff_death/curse_spirit", "spline_2"),
		World.find_particles_variable(arg_3_3, "fx/wpnfx_staff_death/curse_spirit", "spline_3")
	}
	arg_3_2.fx_spline_ids = fx_spline_ids

	local var_3_1 = NetworkLookup.effects["fx/wpnfx_staff_death/curse_spirit_first"]
	local num = POSITION_LOOKUP[arg_3_0] + Vector3.up() * 0.5
	local num_2 = arg_3_1 - num
	local var_3_4
	local has_extension = ScriptUnit.has_extension(arg_3_0, "first_person_system")

	if not has_extension then
		var_3_4 = has_extension:current_rotation()
	else
		var_3_4 = Quaternion.look(num_2, Vector3.up())
	end

	local right = Quaternion.right(var_3_4)
	local num_3 = num + right * math.random(-0.5, 0.5)
	local sign = math.sign(Vector3.dot(num_2, right))
	local num_4 = math.pi * math.random(0.1, 0.25)
	local axis_angle = Quaternion.axis_angle(Vector3.up(), num_4 * sign)
	local num_5 = num_3 + Quaternion.rotate(axis_angle, num_2) * 0.5 + Vector3.up() * 2
	local tbl = {
		num_3,
		num_5,
		arg_3_1
	}
end

local function fn_4(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local var_4_0 = POSITION_LOOKUP[arg_4_0]
	local side_by_unit = Managers.state.side.side_by_unit
	local source_attacker_unit = arg_4_1.source_attacker_unit

	if not ALIVE[source_attacker_unit] then
		return
	end

	local var_4_3 = side_by_unit[source_attacker_unit]
	local alloc_table = FrameTable.alloc_table()
	local debuff_spread_radius = arg_4_1.template.debuff_spread_radius
	local broadphase_query = AiUtils.broadphase_query(POSITION_LOOKUP[arg_4_0], debuff_spread_radius, alloc_table)
	local var_4_7
	local huge = math.huge

	for i = 1, broadphase_query do
		local var_4_9 = alloc_table[i]
		local var_4_10 = side_by_unit[var_4_9]

		if var_4_9 == arg_4_0 or var_4_3 == var_4_10 or not HEALTH_ALIVE[var_4_9] then
			local distance_squared = Vector3.distance_squared(POSITION_LOOKUP[var_4_9], var_4_0)

			if distance_squared < huge then
				huge = distance_squared
				var_4_7 = var_4_9
			end
		end
	end

	if not var_4_7 then
		local has_extension = ScriptUnit.has_extension(var_4_7, "buff_system")

		if not has_extension then
			local alloc_table_2 = FrameTable.alloc_table()

			alloc_table_2.attacker_unit = arg_4_0
			alloc_table_2.source_attacker_unit = source_attacker_unit

			local get_difficulty = Managers.state.difficulty:get_difficulty()
			local get_data = Unit.get_data(arg_4_0, "breed")
			local num = 1

			if not get_data.elite then
				num = 2
			end

			if not get_data.special then
				num = 3
			end

			if not (not get_data.primary_armor_category and get_data.primary_armor_category == 6 or get_data.armor_category ~= 6) then
				num = 4
			end

			if not get_data.boss then
				num = 5
			end

			local var_4_17 = ({
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
			})[get_difficulty][num]

			var_4_17 = var_4_17 or 1
			alloc_table_2.external_optional_value = var_4_17

			has_extension:add_buff("necromancer_on_death_delayed_health_damage", alloc_table_2)

			local var_4_18
			local has_node = Unit.has_node(var_4_7, "j_spine")

			has_node = not has_node and Unit.node(var_4_7, "j_spine")

			if not has_node then
				var_4_18 = Unit.world_position(var_4_7, has_node)
			else
				var_4_18 = POSITION_LOOKUP[var_4_7] + 0.5 * Vector3.up()
			end

			if not var_4_18 then
				fn_3(arg_4_0, var_4_18, arg_4_1, arg_4_3)
			end
		end
	end
end

local function fn_5(arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	if not arg_5_1.delayed_damage_procced then
		return
	end

	arg_5_1.delayed_damage_procced = true

	local source_attacker_unit = arg_5_1.source_attacker_unit
	local unbox = arg_5_1.source_spread_position:unbox()
	local var_5_2 = POSITION_LOOKUP[arg_5_0]
	local normalize = Vector3.normalize(var_5_2 - unbox)
	local num = unbox + (var_5_2 - unbox) * 0.5

	Managers.state.entity:system("audio_system"):play_audio_position_event("Play_career_necro_passive_shadow_blood", num)

	local value = arg_5_1.value
	local get_career_power_level = ScriptUnit.has_extension(source_attacker_unit, "career_system"):get_career_power_level()
	local curse_on_hit = DamageProfileTemplates.curse_on_hit

	DamageUtils.add_damage_network_player(curse_on_hit, nil, get_career_power_level, arg_5_0, source_attacker_unit, "torso", var_5_2, Vector3.up(), "undefined")

	local var_5_8 = BLACKBOARDS[arg_5_0]
	local num_2 = 1
	local medium = scripts_utils_stagger_types.medium
	local num_3 = 1
	local var_5_12
	local time = Managers.time:time("game")
	local num_4 = 1
	local flag = true

	AiUtils.stagger(arg_5_0, var_5_8, source_attacker_unit, normalize, num_2, medium, num_3, var_5_12, time, num_4, flag)
	ScriptUnit.extension(arg_5_0, "buff_system"):remove_buff(arg_5_1.id)
end

local function fn_6(arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	if not ALIVE[arg_6_0] then
		return
	end

	local num_2 = num * 0.8
	local unbox = arg_6_1.target_center:unbox()
	local seed = arg_6_1.seed

	seed = seed or math.random_seed()

	local var_6_3
	local var_6_4
	local var_6_5, var_6_6

	arg_6_1.seed, var_6_5, var_6_6 = math.get_uniformly_random_point_inside_sector_seeded(seed, 0, num_2, 0, 2 * math.pi)

	local num_3 = unbox + Vector3(var_6_5, var_6_6, 0)
	local nav_world = Managers.state.entity:system("ai_system"):nav_world()
	local traverse_logic = Managers.state.entity:system("ai_slot_system"):traverse_logic()
	local raycast, var_6_11 = GwNavQueries.raycast(nav_world, unbox, num_3, traverse_logic)
	local spawn_army_pet = ScriptUnit.extension(arg_6_0, "career_system"):get_passive_ability_by_name("bw_necromancer"):spawn_army_pet(arg_6_2, var_6_11, NecromancerPositionModes.Absolute)

	return var_6_11, spawn_army_pet
end

local function fn_7(arg_7_0)
	-- function 7
	local owner = Managers.player:owner(arg_7_0)

	return not owner and not owner.remote
end

shovel.buff_templates = {
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.bleeding
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.invulnerable
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.overcharge_no_slow
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
					scripts_unit_extensions_default_player_unit_buffs_settings_buff_perk_names.burning
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
					-- function 8
					return fn_7(arg_8_2.source_attacker_unit)
				end,
				area_radius = num
			},
			{
				name = "raise_dead_ability_curse_aura",
				buff_area_buff = "sienna_necromancer_career_skill_on_hit_damage",
				buff_area = true,
				area_unit_name = "units/hub_elements/empty",
				buff_enemies = true,
				apply_condition = function (arg_9_0, arg_9_1, arg_9_2)
					-- function 9
					local has_extension = ScriptUnit.has_extension(arg_9_2.source_attacker_unit, "talent_system")

					return not has_extension and has_extension:has_talent("sienna_necromancer_6_2_2")
				end,
				area_radius = num
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
				area_radius = num
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
					-- function 10
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
shovel.proc_functions = {
	sienna_necromancer_5_1_on_kill = function (arg_11_0, arg_11_1, arg_11_2)
		-- function 11
		if not ALIVE[arg_11_0] then
			return
		end

		if not arg_11_2[1] then
			return
		end

		if not arg_11_2[2].elite then
			local multiplier = arg_11_1.template.multiplier

			ScriptUnit.extension(arg_11_0, "career_system"):reduce_activated_ability_cooldown_percent(multiplier)
		end
	end,
	sienna_necromancer_add_recast_ready = function (arg_12_0, arg_12_1, arg_12_2)
		-- function 12
		local var_12_0 = arg_12_2[2]

		if ScriptUnit.extension(arg_12_0, "career_system"):current_ability_cooldown(var_12_0) == 0 then
			local extension = ScriptUnit.extension(arg_12_0, "buff_system")
			local buff_to_add = arg_12_1.template.buff_to_add
			local add_buff = extension:add_buff(buff_to_add)
			local get_buff_by_id = extension:get_buff_by_id(add_buff)

			get_buff_by_id._source_buff = arg_12_1
			get_buff_by_id._needs_target = arg_12_1.template.needs_target
		end
	end,
	necromancer_trigger_recast = function (arg_13_0, arg_13_1, arg_13_2)
		-- function 13
		local var_13_0 = arg_13_2[2]
		local extension = ScriptUnit.extension(arg_13_0, "career_system")
		local current_ability_cooldown = extension:current_ability_cooldown(var_13_0)
		local num_alive_career_ability_pets = extension:ability_by_id(var_13_0):num_alive_career_ability_pets()

		if not (current_ability_cooldown ~= 0 or num_alive_career_ability_pets > 0) then
			return false
		end

		local extension_2 = ScriptUnit.extension(arg_13_0, "buff_system")

		table.clear(tbl)
		extension_2:add_buff(arg_13_1.template.cooldown_buff)

		return true
	end,
	necromancer_apply_cursed_blood = function (arg_14_0, arg_14_1, arg_14_2)
		-- function 14
		if not Managers.state.network.is_server then
			return
		end

		local necromancer_unit = arg_14_1.necromancer_unit

		if not necromancer_unit then
			local var_14_1 = FindProfileIndex("bright_wizard")
			local var_14_2 = career_index_from_name(var_14_1, "bw_necromancer")
			local human_and_bot_players = Managers.player:human_and_bot_players()

			for k, v in pairs(human_and_bot_players) do
				if var_14_2 == v:career_index() then
					necromancer_unit = v.player_unit
					arg_14_1.necromancer_unit = necromancer_unit

					break
				end
			end
		end

		local var_14_4 = arg_14_2[1]

		fn(var_14_4, arg_14_0, necromancer_unit)
	end,
	sienna_necromancer_career_skill_damage_proc = function (arg_15_0, arg_15_1, arg_15_2)
		-- function 15
		if not Managers.state.network.is_server then
			return
		end

		local var_15_0 = arg_15_2[1]
		local source_attacker_unit = arg_15_1.source_attacker_unit

		if not ALIVE[source_attacker_unit] then
			return
		end

		if not arg_15_1.last_hit_t then
			arg_15_1.last_hit_t = 0
		end

		local time = Managers.time:time("game")

		if time < arg_15_1.last_hit_t then
			return
		else
			arg_15_1.last_hit_t = time + 0.05
		end

		local damage = arg_15_1.template.damage
		local has_extension = ScriptUnit.has_extension(var_15_0, "buff_system")

		if not has_extension and not has_extension:has_buff_type("sienna_necromancer_career_skill_on_hit_damage") then
			local get_career_power_level = ScriptUnit.has_extension(source_attacker_unit, "career_system"):get_career_power_level()
			local curse_on_hit = DamageProfileTemplates.curse_on_hit

			DamageUtils.add_damage_network_player(curse_on_hit, nil, get_career_power_level, var_15_0, source_attacker_unit, "torso", POSITION_LOOKUP[var_15_0], Vector3.up(), "undefined")
		end
	end,
	sienna_necromancer_add_buff_to_pet = function (arg_16_0, arg_16_1, arg_16_2)
		-- function 16
		local var_16_0 = arg_16_2[1]
		local buff_to_add = arg_16_1.template.buff_to_add
		local extension = ScriptUnit.extension(var_16_0, "buff_system")

		table.clear(tbl)

		tbl.attacker_unit = arg_16_0

		extension:add_buff(buff_to_add, tbl)
	end,
	sienna_necromancer_low_hp_kill_on_hit = function (arg_17_0, arg_17_1, arg_17_2)
		-- function 17
		local template = arg_17_1.template

		if template.health_threshold < ScriptUnit.extension(arg_17_0, "health_system"):current_health_percent() then
			return false
		end

		local cooldown_buff = template.cooldown_buff

		ScriptUnit.extension(arg_17_0, "buff_system"):add_buff(cooldown_buff, tbl)

		if not Managers.state.network.is_server then
			return true
		end

		local side_by_unit = Managers.state.side.side_by_unit
		local var_17_3 = side_by_unit[arg_17_0]
		local var_17_4 = POSITION_LOOKUP[arg_17_0]
		local num_enemies = template.num_enemies
		local radius = template.radius
		local alloc_table = FrameTable.alloc_table()
		local broadphase_query = AiUtils.broadphase_query(var_17_4, radius, alloc_table)

		local function fn(arg_18_0, arg_18_1)
			-- function 18
			local var_18_0 = side_by_unit[arg_18_0]

			if var_18_0 ~= side_by_unit[arg_18_1] then
				return var_18_0 ~= var_17_3
			end

			return Vector3.distance_squared(var_17_4, POSITION_LOOKUP[arg_18_0]) < Vector3.distance_squared(var_17_4, POSITION_LOOKUP[arg_18_1])
		end

		table.sort(alloc_table, fn)

		local min = math.min(broadphase_query, num_enemies)

		for i = 1, min do
			local var_17_11 = alloc_table[i]
			local breed = BLACKBOARDS[var_17_11].breed
			local flag = not breed and breed.boss

			if side_by_unit[var_17_11] == var_17_3 then
				break
			end

			if not flag then
				AiUtils.kill_unit(var_17_11, arg_17_0)
			end
		end

		return true
	end,
	on_pet_damage_dealt = function (arg_19_0, arg_19_1, arg_19_2)
		-- function 19
		local var_19_0 = arg_19_2[1]

		if arg_19_0 == var_19_0 then
			return
		end

		if arg_19_2[10] == "bleed" then
			return
		end

		local source_attacker_unit = arg_19_1.source_attacker_unit

		if not Managers.player:unit_owner(source_attacker_unit) then
			return
		end

		local sounds_to_play = arg_19_1.template.sounds_to_play
		local var_19_3 = sounds_to_play[math.random(1, #sounds_to_play)]
		local flag

		flag = not Unit.has_node(var_19_0, "j_spine") and "j_spine" and nil

		Managers.state.entity:system("audio_system"):play_audio_unit_event(var_19_3, var_19_0, flag)
	end,
	add_pet_charge = function (arg_20_0, arg_20_1, arg_20_2)
		-- function 20
		local source_attacker_unit = arg_20_1.source_attacker_unit

		if not ALIVE[arg_20_0] then
			return
		end

		if not ScriptUnit.extension(source_attacker_unit, "status_system"):is_dead() then
			return
		end

		ScriptUnit.extension(source_attacker_unit, "career_system"):get_passive_ability_by_name("bw_necromancer"):add_pet_charge(arg_20_0)
	end,
	sienna_necromancer_5_3_free_charge = function (arg_21_0, arg_21_1, arg_21_2)
		-- function 21
		local var_21_0 = arg_21_2[1]

		if not HEALTH_ALIVE[var_21_0] then
			return
		end

		local buff_to_add = arg_21_1.template.buff_to_add

		ScriptUnit.extension(arg_21_0, "buff_system"):add_buff(buff_to_add)
	end,
	sienna_necromancer_on_kill_harvest = function (arg_22_0, arg_22_1, arg_22_2)
		-- function 22
		local var_22_0 = arg_22_2[3]
		local has_extension = ScriptUnit.has_extension(var_22_0, "buff_system")

		if not has_extension and not has_extension:has_buff_type("sienna_necromancer_career_skill_on_hit_damage") then
			local has_extension_2 = ScriptUnit.has_extension(arg_22_0, "buff_system")

			if not has_extension_2 then
				has_extension_2:add_buff("sienna_necromancer_6_2_buff")
			end
		end
	end,
	thank_you_skeletal_add = function (arg_23_0, arg_23_1, arg_23_2)
		-- function 23
		if ScriptUnit.extension(arg_23_0, "ai_commander_system"):get_controlled_units_count() >= arg_23_1.template.skeleton_count then
			local extension = ScriptUnit.extension(arg_23_0, "buff_system")
			local buff_to_add = arg_23_1.template.buff_to_add

			extension:add_buff(buff_to_add)
		end
	end,
	thank_you_skeletal_remove = function (arg_24_0, arg_24_1, arg_24_2)
		-- function 24
		if ScriptUnit.extension(arg_24_0, "ai_commander_system"):get_controlled_units_count() <= arg_24_1.template.skeleton_count - 1 then
			local extension = ScriptUnit.extension(arg_24_0, "buff_system")
			local buff_to_remove = arg_24_1.template.buff_to_remove
			local get_stacking_buff = extension:get_stacking_buff(buff_to_remove)

			if not (not get_stacking_buff and not (#get_stacking_buff > 0)) then
				extension:remove_buff(get_stacking_buff[1].id)
			end
		end
	end,
	trapped_souls_overcharge_lost = function (arg_25_0, arg_25_1, arg_25_2)
		-- function 25
		local var_25_0 = arg_25_2[1]
		local var_25_1 = arg_25_2[2]

		arg_25_1.total_overcharge_lost = arg_25_1.total_overcharge_lost + var_25_0

		local num = arg_25_1.total_overcharge_lost / var_25_1
		local overcharge_threshold = arg_25_1.template.overcharge_threshold
		local num_2 = num / overcharge_threshold
		local num_3 = 7.5

		for i = 1, num_2 do
			arg_25_1.total_overcharge_lost = arg_25_1.total_overcharge_lost - overcharge_threshold * var_25_1

			fn_2(arg_25_0, num_3)
		end
	end,
	sienna_necromancer_empowered_overcharge_kill = function (arg_26_0, arg_26_1, arg_26_2)
		-- function 26
		local percent_overcharge = arg_26_1.template.percent_overcharge
		local extension = ScriptUnit.extension(arg_26_0, "overcharge_system")
		local get_max_value = extension:get_max_value()

		extension:remove_charge(get_max_value * percent_overcharge)
	end,
	remove_necromancer_creeping_curse_always_blocking = function (arg_27_0, arg_27_1, arg_27_2)
		-- function 27
		local extension = ScriptUnit.extension(arg_27_0, "status_system")
		local flag = not Managers.state.network.is_server

		extension:set_override_blocking(nil, flag)
		ScriptUnit.extension(arg_27_0, "buff_system"):remove_buff(arg_27_1.id)
	end,
	remove_buff_stack_on_proc = function (arg_28_0, arg_28_1, arg_28_2)
		-- function 28
		local extension = ScriptUnit.extension(arg_28_0, "buff_system")
		local buff_to_add = arg_28_1.template.buff_to_add
		local get_stacking_buff = extension:get_stacking_buff(buff_to_add)

		if not (not get_stacking_buff and not (#get_stacking_buff > 0)) then
			extension:remove_buff(get_stacking_buff[1].id)
		end

		if not (not get_stacking_buff and not (#get_stacking_buff < 1)) then
			extension:remove_buff(arg_28_1.id)
		end
	end,
	necromancer_on_death_damage = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3)
		-- function 29
		fn_4(arg_29_0, arg_29_1, arg_29_2, arg_29_3)

		return true
	end,
	delayed_health_damage = function (arg_30_0, arg_30_1, arg_30_2)
		-- function 30
		fn_5(arg_30_0, arg_30_1, arg_30_2)

		return true
	end,
	necromancer_ability_register_stagger = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
		-- function 31
		if not ALIVE[arg_31_0] then
			return
		end

		local has_extension = ScriptUnit.has_extension(arg_31_0, "buff_system")

		if not has_extension then
			table.clear(tbl)

			tbl.source_attacker_unit = arg_31_4
			tbl.attacker_unit = arg_31_1

			has_extension:add_buff("raise_dead_ability_stagger", tbl)
		end
	end,
	necromancer_ability_unregister_stagger = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
		-- function 32
		if not ALIVE[arg_32_0] then
			return
		end

		local has_extension = ScriptUnit.has_extension(arg_32_0, "buff_system")

		if not has_extension then
			local get_stacking_buff = has_extension:get_stacking_buff("raise_dead_ability_stagger_visuals")

			get_stacking_buff = not get_stacking_buff and get_stacking_buff[1]

			if not get_stacking_buff then
				has_extension:remove_buff(get_stacking_buff.id)
			end
		end
	end,
	necromancer_crit_burst = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
		-- function 33
		if not arg_33_2[arg_33_4.is_critical_strike] then
			return
		end

		if not arg_33_2[arg_33_4.first_hit] then
			return
		end

		local var_33_0 = arg_33_2[arg_33_4.attacked_unit]
		local has_status, var_33_2 = Managers.state.status_effect:has_status(var_33_0, StatusEffectNames.burning_balefire)

		if not has_status and not var_33_2 then
			return
		end

		local var_33_3 = arg_33_2[arg_33_4.damage_amount]

		if var_33_3 <= 0 then
			return
		end

		local template = arg_33_1.template
		local var_33_5 = Managers.state.side.side_by_unit[arg_33_0]
		local var_33_6 = POSITION_LOOKUP[var_33_0]

		if not var_33_6 then
			return
		end

		local go_id = Managers.state.unit_storage:go_id(var_33_0)
		local num = 0

		if not Unit.has_node(var_33_0, "j_spine") then
			num = Unit.node(var_33_0, "j_spine")
		end

		local network = Managers.state.network

		network.network_transmit:send_rpc_server("rpc_play_particle_effect", NetworkLookup.effects["fx/necromancer_cursed_explosion_blood"], go_id, num, Vector3.zero(), Quaternion.identity(), false)
		network.network_transmit:send_rpc_server("rpc_play_particle_effect", NetworkLookup.effects["fx/necromancer_cursed_explosion_blue"], go_id, num, Vector3(0.5, 0, 0), Quaternion.identity(), false)
		Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_career_necro_ability_cursed_blood", var_33_0, "j_spine")

		local enemy_broadphase_categories = var_33_5.enemy_broadphase_categories
		local alloc_table = FrameTable.alloc_table()
		local broadphase_query = AiUtils.broadphase_query(var_33_6, template.radius, alloc_table, enemy_broadphase_categories)

		if broadphase_query == 0 then
			return
		end

		local time = Managers.time:time("game")
		local num_2 = var_33_3 * template.propagation_multiplier
		local get_career_power_level = ScriptUnit.extension(arg_33_0, "career_system"):get_career_power_level()

		for i = 1, broadphase_query do
			local var_33_16 = alloc_table[i]

			if var_33_16 ~= var_33_0 then
				local normalize = Vector3.normalize(POSITION_LOOKUP[var_33_16] - var_33_6)

				DamageUtils.add_damage_network(var_33_16, arg_33_0, num_2, "torso", "buff", nil, normalize, "buff", nil, arg_33_0, nil, nil, false, nil, nil, nil, nil, true, i)
				DamageUtils.stagger_ai(time, DamageProfileTemplates.necromancer_crit_burst_stagger, i + 1, get_career_power_level, var_33_16, arg_33_0, "torso", normalize, nil, nil, false, "buff", arg_33_0)
			end
		end
	end,
	spawn_ripped_soul = function (arg_34_0, arg_34_1, arg_34_2)
		-- function 34
		if arg_34_2[1][2] == "execute" then
			return
		end

		local var_34_0 = arg_34_2[3]

		if not Managers.state.status_effect:has_status(var_34_0, "burning_balefire") then
			return
		end

		local num = POSITION_LOOKUP[var_34_0] + Vector3(0, 0, 1)
		local orb_name = arg_34_1.template.orb_settings.orb_name
		local peer_id = Managers.player:owner(arg_34_0).peer_id
		local var_34_4 = Vector3(0, 0, 1)
		local num_2 = 2 * math.pi

		Managers.state.entity:system("orb_system"):spawn_orb(orb_name, peer_id, num, var_34_4, num_2)
	end,
	execute_man_sized_enemy = function (arg_35_0, arg_35_1, arg_35_2)
		-- function 35
		local var_35_0 = arg_35_2[1]
		local var_35_1 = ALIVE[var_35_0]

		var_35_1 = not var_35_1 and Unit.get_data(var_35_0, "breed")

		if not var_35_1 and not var_35_1.boss then
			return false
		end

		if not HEALTH_ALIVE[var_35_0] then
			return false
		end

		AiUtils.kill_unit(var_35_0, arg_35_0, nil, "execute")

		return true
	end,
	cursed_vigor_proc = function (arg_36_0, arg_36_1, arg_36_2)
		-- function 36
		if arg_36_0 == arg_36_2[1] then
			ProcFunctions.add_buff_local(arg_36_0, arg_36_1, arg_36_2)
		end
	end
}

local function fn_8(arg_37_0)
	-- function 37
	local owner = Managers.player:owner(arg_37_0)

	return not owner and owner.bot_player
end

shovel.buff_function_templates = {
	sienna_necromancer_perk_1_func = function (arg_38_0, arg_38_1, arg_38_2)
		-- function 38
		local var_38_0 = arg_38_0

		if not ALIVE[var_38_0] and not Managers.player.is_server then
			local template = arg_38_1.template
			local radius = template.radius
			local devour_health_percent = template.devour_health_percent
			local var_38_4 = POSITION_LOOKUP[var_38_0]
			local alloc_table = FrameTable.alloc_table()
			local enemy_broadphase = Managers.state.entity:system("proximity_system").enemy_broadphase
			local query = Broadphase.query(enemy_broadphase, var_38_4, radius, alloc_table)
			local side = Managers.state.side

			for i = 1, query do
				local var_38_9 = alloc_table[i]

				if not ALIVE[var_38_9] and not side:is_enemy(var_38_0, var_38_9) then
					local has_extension = ScriptUnit.has_extension(var_38_9, "health_system")

					if not (not has_extension and not (devour_health_percent > has_extension:current_health_percent())) then
						local current_health = has_extension:current_health()

						DamageUtils.add_damage_network(var_38_9, var_38_0, current_health, "full", "buff", nil, Vector3(1, 0, 0), "buff", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, i)
					end
				end
			end
		end
	end,
	necromancer_update_knockdown_damage_immunity = function (arg_39_0, arg_39_1, arg_39_2)
		-- function 39
		if not Managers.state.network.is_server then
			return
		end

		local knocked_down_players = arg_39_1.knocked_down_players

		knocked_down_players = knocked_down_players or {}
		arg_39_1.knocked_down_players = knocked_down_players

		local var_39_1 = Managers.state.side.side_by_unit[arg_39_0]
		local side_is_disabled = GameModeHelper.side_is_disabled(var_39_1:name())
		local PLAYER_AND_BOT_UNITS = var_39_1.PLAYER_AND_BOT_UNITS
		local system = Managers.state.entity:system("buff_system")
		local radius = arg_39_1.template.radius
		local num = radius * radius
		local var_39_7 = POSITION_LOOKUP[arg_39_0]

		for i = 1, #PLAYER_AND_BOT_UNITS do
			repeat
				local var_39_8 = PLAYER_AND_BOT_UNITS[i]

				if var_39_8 == arg_39_0 then
					break
				end

				local var_39_9 = knocked_down_players[var_39_8]

				if not ALIVE[var_39_8] then
					knocked_down_players[var_39_8] = nil

					break
				end

				local extension = ScriptUnit.extension(var_39_8, "status_system")

				if not (side_is_disabled or extension:is_knocked_down()) then
					if not var_39_9 then
						system:remove_buff_synced(var_39_8, var_39_9)
					end

					knocked_down_players[var_39_8] = nil

					break
				end

				local var_39_11 = POSITION_LOOKUP[var_39_8]

				if num < Vector3.length_squared(var_39_11 - var_39_7) then
					if not var_39_9 then
						system:remove_buff_synced(var_39_8, var_39_9)
					end

					knocked_down_players[var_39_8] = nil

					break
				end

				if not var_39_9 then
					local buff_to_add = arg_39_1.template.buff_to_add
					local owner = Managers.player:owner(var_39_8)

					knocked_down_players[var_39_8] = system:add_buff_synced(var_39_8, buff_to_add, BuffSyncType.ClientAndServer, nil, owner.peer_id)
				end
			until true
		end
	end,
	necromancer_knockdown_damage_immunity_remove_all = function (arg_40_0, arg_40_1, arg_40_2)
		-- function 40
		if not Managers.state.network.is_server then
			return
		end

		local knocked_down_players = arg_40_1.knocked_down_players

		if not knocked_down_players then
			return
		end

		local system = Managers.state.entity:system("buff_system")

		for k, v in pairs(knocked_down_players) do
			if not ALIVE[k] then
				system:remove_buff_synced(k, v)
			end
		end

		arg_40_1.knocked_down_players = nil
	end,
	necromancer_remove_orb_buffs = function (arg_41_0, arg_41_1, arg_41_2)
		-- function 41
		local has_extension = ScriptUnit.has_extension(arg_41_0, "buff_system")

		if not has_extension then
			local get_stacking_buff = has_extension:get_stacking_buff("sienna_necromancer_4_2_soul_rip_stack")

			if not (not get_stacking_buff and not (#get_stacking_buff > 0)) then
				for i = 1, #get_stacking_buff do
					local id = get_stacking_buff[1].id

					has_extension:remove_buff(id)
				end
			end

			local get_stacking_buff_2 = has_extension:get_stacking_buff("sienna_necromancer_4_2_execute")

			if not (not get_stacking_buff_2 and not (#get_stacking_buff_2 > 0)) then
				for j = 1, #get_stacking_buff_2 do
					local id_2 = get_stacking_buff_2[1].id

					has_extension:remove_buff(id_2)
				end
			end
		end
	end,
	sienna_necromancer_expire_spawned_pet = function (arg_42_0, arg_42_1, arg_42_2)
		-- function 42
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_42_0] then
			AiUtils.kill_unit(arg_42_0)
		end
	end,
	sienna_necromancer_on_hit_apply = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
		-- function 43
		if not arg_43_1.fx_id then
			local create_particles = World.create_particles(arg_43_3, arg_43_1.template.particle_fx, POSITION_LOOKUP[arg_43_0])

			arg_43_1.fx_id = create_particles

			local template = arg_43_1.template

			if not Unit.has_node(arg_43_0, "j_spine") then
				local local_rotation = Unit.local_rotation(arg_43_0, Unit.node(arg_43_0, "j_spine"))
				local from_euler_angles_xyz = Quaternion.from_euler_angles_xyz
				local offset_rotation_x = template.offset_rotation_x

				offset_rotation_x = offset_rotation_x or 0

				local offset_rotation_y = template.offset_rotation_y

				offset_rotation_y = offset_rotation_y or 0

				local offset_rotation_z = template.offset_rotation_z

				offset_rotation_z = offset_rotation_z or 0

				local var_43_7 = from_euler_angles_xyz(offset_rotation_x, offset_rotation_y, offset_rotation_z)
				local from_quaternion = Matrix4x4.from_quaternion(Quaternion.multiply(local_rotation, var_43_7))

				World.link_particles(arg_43_3, create_particles, arg_43_0, Unit.node(arg_43_0, "j_spine"), from_quaternion, "stop")
			end
		end
	end,
	setup_delayed_damage = function (arg_44_0, arg_44_1, arg_44_2)
		-- function 44
		local attacker_unit = arg_44_1.attacker_unit

		arg_44_1.source_spread_position = Vector3Box(POSITION_LOOKUP[attacker_unit])
	end,
	career_skill_health_reduction = function (arg_45_0, arg_45_1, arg_45_2)
		-- function 45
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_45_0] then
			local source_attacker_unit = arg_45_1.source_attacker_unit
			local has_extension = ScriptUnit.has_extension(source_attacker_unit, "talent_system")
			local unit_breed = AiUtils.unit_breed(arg_45_0)

			if not has_extension and not has_extension:has_talent("sienna_necromancer_6_1") and not unit_breed.elite then
				Managers.state.entity:system("buff_system"):add_buff(arg_45_0, "necromancer_cursed_blood", source_attacker_unit, true, nil, source_attacker_unit)
			end

			if not has_extension and not has_extension:has_talent("sienna_necromancer_6_2") then
				Managers.state.entity:system("buff_system"):add_buff(arg_45_0, "necromancer_harvest_curse", source_attacker_unit, true, nil, source_attacker_unit)
			end

			local has_extension_2 = ScriptUnit.has_extension(arg_45_0, "health_system")
			local num = 0

			if not has_extension_2 then
				num = has_extension_2:current_health() / 2
			end

			DamageUtils.add_damage_network(arg_45_0, source_attacker_unit, num, "torso", "buff", nil, Vector3(0, 0, 0), "career_ability", nil, source_attacker_unit, nil, nil, nil, nil, nil, nil, nil, nil, 1)
		end
	end,
	delayed_health_damage = function (arg_46_0, arg_46_1, arg_46_2)
		-- function 46
		fn_5(arg_46_0, arg_46_1, arg_46_2)
		ScriptUnit.extension(arg_46_0, "buff_system"):remove_buff(arg_46_1.id)
	end,
	remove_and_apply_cursed_blood = function (arg_47_0, arg_47_1, arg_47_2)
		-- function 47
		local source_attacker_unit = arg_47_1.source_attacker_unit
		local unbox = arg_47_1.source_spread_position:unbox()
		local sienna_necromancer_blood_explosion = DamageProfileTemplates.sienna_necromancer_blood_explosion
		local num = 1
		local DefaultPowerLevel = DefaultPowerLevel
		local var_47_5 = arg_47_0
		local str = "full"
		local var_47_7 = POSITION_LOOKUP[arg_47_0]
		local normalize = Vector3.normalize(var_47_7 - unbox)
		local str_2 = "buff"
		local flag = false
		local var_47_11
		local flag_2 = false
		local var_47_13
		local flag_3 = true
		local num_2 = 1
		local var_47_16
		local var_47_17 = source_attacker_unit
		local num_3 = unbox + (var_47_7 - unbox) * 0.5

		Managers.state.entity:system("audio_system"):play_audio_position_event("Play_career_necro_passive_shadow_blood", num_3)
		DamageUtils.add_damage_network_player(sienna_necromancer_blood_explosion, num, DefaultPowerLevel, arg_47_0, var_47_5, str, var_47_7, normalize, str_2, flag, var_47_11, flag_2, var_47_13, flag_3, num_2, var_47_16, var_47_17)

		local var_47_19 = BLACKBOARDS[arg_47_0]
		local num_4 = 1
		local medium = scripts_utils_stagger_types.medium
		local num_5 = 1
		local var_47_23
		local time = Managers.time:time("game")
		local num_6 = 1
		local flag_4 = true

		AiUtils.stagger(arg_47_0, var_47_19, source_attacker_unit, normalize, num_4, medium, num_5, var_47_23, time, num_6, flag_4)
		ScriptUnit.extension(arg_47_0, "buff_system"):remove_buff(arg_47_1.id)
	end,
	spawn_pet = function (arg_48_0, arg_48_1, arg_48_2)
		-- function 48
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_48_0] then
			return
		end

		if not ScriptUnit.extension(arg_48_0, "status_system"):is_dead() then
			return
		end

		ScriptUnit.extension(arg_48_0, "career_system"):get_passive_ability_by_name("bw_necromancer"):consume_pet_charge(arg_48_1.id)
	end,
	pet_ping_explosion = function (arg_49_0, arg_49_1, arg_49_2, arg_49_3)
		-- function 49
		if not Managers.state.network.is_server then
			return
		end

		if not ALIVE[arg_49_0] then
			local var_49_0 = POSITION_LOOKUP[arg_49_0]
			local source_attacker_unit = arg_49_1.source_attacker_unit
			local has_extension = ScriptUnit.has_extension(source_attacker_unit, "career_system")
			local get_career_power_level

			if not has_extension then
				get_career_power_level = has_extension:get_career_power_level()

				if not get_career_power_level then
					-- Nothing
				end
			end

			get_career_power_level = DefaultPowerLevel

			::label_49_0::

			Managers.state.entity:system("area_damage_system"):create_explosion(source_attacker_unit, var_49_0, Quaternion.identity(), "sienna_necromancer_passive_explosion", 1, "buff", get_career_power_level, false)
		end

		local has_extension_2 = ScriptUnit.has_extension(arg_49_0, "health_system")

		if not (not has_extension_2 and has_extension_2:is_dead()) then
			AiUtils.kill_unit(arg_49_0)
		end
	end,
	necromancer_5_3_setup = function (arg_50_0, arg_50_1, arg_50_2)
		-- function 50
		arg_50_1.total_overcharge_lost = 0
	end,
	necromancer_cursed_area_buff = function (arg_51_0, arg_51_1, arg_51_2)
		-- function 51
		if not ALIVE[arg_51_0] then
			return false
		end

		if not (not fn_7(arg_51_0) and fn_8(arg_51_0)) then
			-- Nothing
		end
	end,
	necromancer_cursed_area_buff_remove = function (arg_52_0, arg_52_1, arg_52_2)
		-- function 52
		local var_52_0 = arg_52_0

		if not (not fn_7(var_52_0) and fn_8(var_52_0)) then
			-- Nothing
		end
	end,
	apply_necromancer_creeping_curse_always_blocking = function (arg_53_0, arg_53_1, arg_53_2)
		-- function 53
		if arg_53_0 == arg_53_2.attacker_unit then
			local extension = ScriptUnit.extension(arg_53_0, "status_system")
			local flag = not Managers.state.network.is_server

			extension:set_override_blocking(true, flag)
			extension:remove_all_fatigue()
		end
	end,
	necromancer_apply_num_buffs = function (arg_54_0, arg_54_1, arg_54_2)
		-- function 54
		local template = arg_54_1.template
		local hit_soak_num = template.hit_soak_num
		local buff_to_add = template.buff_to_add
		local extension = ScriptUnit.extension(arg_54_0, "buff_system")

		for i = 1, hit_soak_num do
			extension:add_buff(buff_to_add)
		end
	end,
	apply_ai_attack_speed = function (arg_55_0, arg_55_1, arg_55_2)
		-- function 55
		local value = arg_55_1.template.value
		local animation_find_variable = Unit.animation_find_variable(arg_55_0, "attack_speed")
		local animation_get_variable = Unit.animation_get_variable(arg_55_0, animation_find_variable)

		Unit.animation_set_variable(arg_55_0, animation_find_variable, animation_get_variable + value)
	end,
	remove_ai_attack_speed = function (arg_56_0, arg_56_1, arg_56_2)
		-- function 56
		local value = arg_56_1.template.value
		local animation_find_variable = Unit.animation_find_variable(arg_56_0, "attack_speed")
		local animation_get_variable = Unit.animation_get_variable(arg_56_0, animation_find_variable)

		Unit.animation_set_variable(arg_56_0, animation_find_variable, animation_get_variable - value)
	end,
	update_anim_movespeed = function (arg_57_0, arg_57_1, arg_57_2)
		-- function 57
		local var_57_0 = POSITION_LOOKUP[arg_57_0]
		local last_pos = arg_57_1.last_pos

		last_pos = last_pos or Vector3Box(var_57_0)
		arg_57_1.last_pos = last_pos

		local unbox = arg_57_1.last_pos:unbox()

		arg_57_1.last_pos:store(var_57_0)

		local num = 1
		local num_2 = Vector3.length(var_57_0 - unbox) / num

		if num_2 > 0 then
			local var_id = arg_57_1.var_id

			var_id = var_id or Unit.animation_find_variable(arg_57_0, "move_speed")
			arg_57_1.var_id = var_id

			Unit.animation_set_variable(arg_57_0, var_id, num_2)

			return arg_57_1._next_update_t + num
		end

		return arg_57_1._next_update_t + 0.25
	end,
	on_raise_dead_start = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
		-- function 58
		local source_attacker_unit = arg_58_1.source_attacker_unit

		ScriptUnit.extension(source_attacker_unit, "career_system"):get_passive_ability_by_name("bw_necromancer"):kill_pets()
	end,
	raise_dead_update = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3)
		-- function 59
		if not arg_59_1._spawning_done then
			local _grace_timer = arg_59_1._grace_timer

			_grace_timer = _grace_timer or arg_59_2.time_into_buff + 0.5
			arg_59_1._grace_timer = _grace_timer

			if arg_59_2.time_into_buff > arg_59_1._grace_timer then
				ScriptUnit.extension(arg_59_0, "buff_system"):remove_buff(arg_59_1.id)
			end

			return
		end

		local spawn_data = arg_59_1.spawn_data
		local source_attacker_unit = arg_59_1.source_attacker_unit
		local spawn_index = arg_59_1.spawn_index

		spawn_index = spawn_index or 0

		local num = spawn_index + 1

		arg_59_1.spawn_index = num

		local function fn()
			-- function 60
			if not ALIVE[source_attacker_unit] then
				local var_60_0, var_60_1 = fn_6(source_attacker_unit, spawn_data, num - 1)

				if not var_60_0 then
					fn_3(source_attacker_unit, var_60_0, arg_59_1, arg_59_3)
				end

				arg_59_1._spawning_done = var_60_1
			end
		end

		Managers.state.entity:system("ai_navigation_system"):add_safe_navigation_callback(fn)

		return Managers.time:time("game") + (arg_59_1.template.update_frequency + math.random() * 0.2 - 0.1)
	end,
	raise_dead_apply = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
		-- function 61
		arg_61_1.skulls = {}
		arg_61_1.num_skulls = 0

		local go_id = Managers.state.unit_storage:go_id(arg_61_0)
		local var_61_1 = go_id
		local var_61_2 = go_id
		local template = arg_61_1.template
		local unit_names = template.unit_names
		local count = #unit_names
		local num = 0
		local var_61_7 = Vector3(11, 11, 1)
		local var_61_8 = POSITION_LOOKUP[arg_61_0]

		arg_61_1.units = {}

		local get_buff_type = ScriptUnit.extension(arg_61_0, "buff_system"):get_buff_type("raise_dead_ability")
		local duration

		if not get_buff_type then
			duration = get_buff_type.duration

			if not duration then
				-- Nothing
			end
		end

		duration = math.huge

		::label_61_0::

		local var_61_11
		local var_61_12
		local var_61_13
		local var_61_14
		local num_small_decals = template.num_small_decals

		for i = 1, num_small_decals do
			local var_61_16

			var_61_1, var_61_16 = Math.next_random(var_61_1, 1, count)

			local var_61_17 = unit_names[var_61_16]
			local var_61_18, var_61_19

			var_61_2, var_61_18, var_61_19 = math.get_uniformly_random_point_inside_sector_seeded(var_61_2, 0, num - 0.5, 0, math.pi * 2)

			local num_2 = var_61_8 + Vector3(var_61_18, var_61_19, 0)
			local var_61_21

			var_61_1, var_61_21 = math.next_random_range(var_61_1, 0, math.pi * 2)

			local axis_angle = Quaternion.axis_angle(Vector3.up(), var_61_21)
			local spawn_unit = World.spawn_unit(arg_61_3, var_61_17, num_2, axis_angle)

			Unit.set_local_scale(spawn_unit, 0, var_61_7)

			arg_61_1.units[i] = spawn_unit

			local time = World.time(Application.main_world())
			local num_3 = time + duration
			local num_4 = 1.5

			Unit.set_vector2_for_material(spawn_unit, "projector", "start_end_time", Vector2(time, num_3))
			Unit.set_scalar_for_material(spawn_unit, "projector", "fade_time", num_4)
			Unit.set_scalar_for_material(spawn_unit, "projector", "enable_fade", 1)
		end
	end,
	raise_dead_remove = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
		-- function 62
		if not fn_7(arg_62_1.source_attacker_unit) and not ALIVE[arg_62_0] then
			Managers.state.unit_spawner:mark_for_deletion(arg_62_0)
		end

		if not ALIVE[arg_62_1.area_buff_unit] then
			Managers.state.unit_spawner:mark_for_deletion(arg_62_1.area_buff_unit)
		end

		local units = arg_62_1.units

		if not units then
			for i = 1, #units do
				local var_62_1 = units[i]

				World.destroy_unit(arg_62_3, var_62_1)
			end
		end

		local is_server = Managers.state.network.is_server

		for k, v in pairs(arg_62_1.skulls) do
			if not is_server then
				Managers.level_transition_handler.transient_package_loader:remove_unit(k)
			end

			World.destroy_unit(arg_62_3, k)
		end
	end,
	raise_dead_visual_update = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
		-- function 63
		local template = arg_63_1.template
		local delay = template.delay
		local time_into_buff = arg_63_2.time_into_buff

		if time_into_buff - delay < 0 then
			return
		end

		local num = time_into_buff - delay
		local min = math.min(template.num_skulls.min + math.floor(num / template.skull_spawn_frequency), template.num_skulls.max)
		local var_63_5 = POSITION_LOOKUP[arg_63_0]

		arg_63_1.skulls = arg_63_1.skulls
		arg_63_1.num_skulls = arg_63_1.num_skulls

		local var_63_6 = POSITION_LOOKUP[arg_63_0]

		for i = arg_63_1.num_skulls, min do
			local num_2 = math.random() * math.tau / template.num_skulls.min * i + Math.random_range(-0.05, 0.05)
			local rotate = Vector3.rotate(Vector3(template.area_radius, 0, 0), num_2)
			local num_3 = i % 2 * 2 - 1
			local look = Quaternion.look(Vector3.cross(Vector3.up(), rotate) * num_3)
			local str = "units/beings/player/bright_wizard_necromancer/talents/trapped_soul_skull"
			local spawn_unit = World.spawn_unit(arg_63_3, str, var_63_6 + rotate, look)

			if not Managers.state.network.is_server then
				Managers.level_transition_handler.transient_package_loader:add_unit(spawn_unit, str)
			end

			arg_63_1.skulls[spawn_unit] = {
				start_t = num,
				level_out_height = Math.random_range(1, 1),
				start_angle = num_2,
				rot_direction = num_3,
				angular_velocity = Math.random_range(0.5, 0.8) * math.pi,
				outward_offset = Math.random_range(-0.1, 0) * template.area_radius
			}
			arg_63_1.num_skulls = arg_63_1.num_skulls + 1
		end

		for k, v in pairs(arg_63_1.skulls) do
			local num_4 = num - v.start_t

			if num_4 > 4 then
				if not Managers.state.network.is_server then
					Managers.level_transition_handler.transient_package_loader:remove_unit(k)
				end

				World.destroy_unit(arg_63_3, k)

				arg_63_1.skulls[k] = nil

				return
			end

			local num_5 = v.start_angle + v.angular_velocity * num_4 * v.rot_direction
			local rotate_2 = Vector3.rotate(Vector3(template.area_radius + v.outward_offset, 0, 0), num_5)

			rotate_2[3] = 0.5 + (1.3 * num_4)^2 * v.level_out_height

			local num_6 = var_63_5 + rotate_2
			local local_position = Unit.local_position(k, 0)
			local look_2 = Quaternion.look(num_6 - local_position)

			Unit.set_local_position(k, 0, num_6)
			Unit.set_local_rotation(k, 0, look_2)
		end
	end,
	necromancer_ability_stagger_update = function (arg_64_0, arg_64_1, arg_64_2)
		-- function 64
		local attacker_unit = arg_64_2.attacker_unit
		local source_attacker_unit = arg_64_2.source_attacker_unit

		if not (not ALIVE[attacker_unit] and ALIVE[source_attacker_unit]) then
			return
		end

		local var_64_2 = POSITION_LOOKUP[arg_64_0]
		local num = POSITION_LOOKUP[attacker_unit] - var_64_2
		local normalize = Vector3.normalize(num)
		local var_64_5 = BLACKBOARDS[arg_64_0]
		local min = math.min(math.max(Vector3.length(num) - 1, 0) * 0.25, 0.5)
		local medium = scripts_utils_stagger_types.medium
		local num_2 = 1.5
		local var_64_9
		local time = Managers.time:time("game")
		local num_3 = 2
		local flag = true

		AiUtils.stagger(arg_64_0, var_64_5, source_attacker_unit, normalize, min, medium, num_2, var_64_9, time, num_3, flag)
	end,
	necromancer_ability_stagger_hands = function (arg_65_0, arg_65_1, arg_65_2)
		-- function 65
		local attacker_unit = arg_65_2.attacker_unit
		local var_65_1 = POSITION_LOOKUP[arg_65_0]
		local num = POSITION_LOOKUP[attacker_unit] - var_65_1
		local normalize = Vector3.normalize(num)
		local look = Quaternion.look(Vector3.flat(normalize))
		local length = Vector3.length(num)
		local num_2 = normalize * math.clamp(length - 1, 1, 2)
		local num_3 = 0.1
		local var_65_8 = Vector3(0, 0, -num_3 * math.random())
		local str = "units/beings/enemies/undead_skeleton_hand/chr_undead_skeleton_hand"
		local spawn_local_unit = Managers.state.unit_spawner:spawn_local_unit(str, var_65_1 + var_65_8 + num_2, look)
		local animation_find_constraint_target = Unit.animation_find_constraint_target(spawn_local_unit, "look_at")

		Unit.animation_set_constraint_target(spawn_local_unit, animation_find_constraint_target, var_65_1)

		local num_4 = 1.25
		local num_5 = 1.75
		local lerp = math.lerp(num_4, num_5, math.random())

		Unit.set_local_scale(spawn_local_unit, 0, Vector3(lerp, lerp, lerp))

		local time = Managers.time:time("game")
		local flag

		flag = not (length < 1.5) or not 1.5 or 0.6

		local flag_2

		flag_2 = not (length < 1.5) or not 3 or 0.8

		return time + math.random(flag, flag_2)
	end
}
