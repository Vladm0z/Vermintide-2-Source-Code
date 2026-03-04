-- chunkname: @scripts/settings/breeds/breed_shadow_skull.lua

local var_0_0 = {
	detection_radius = 9999999,
	debug_despawn_immunity = false,
	target_selection = "pick_closest_target",
	race = "chaos",
	flesh_material = "stone",
	poison_resistance = 100,
	debug_spawn_func_name = "aim_spawning_air",
	no_blood_splatter_on_damage = true,
	death_reaction = "shadow_skull",
	exchange_order = 1,
	animation_sync_rpc = "rpc_sync_anim_state_1",
	impact_template_name = "no_owner_direct_impact",
	impact_collision_filter = "filter_ray_projectile",
	debug_spawn_category = "Misc",
	target_head_node = "c_skull",
	hit_reaction = "ai_default",
	only_one_impact = true,
	hit_effect_template = "HitEffectsShadowSkull",
	collision_detection_sphere_radius = 0.2,
	immediate_threat = true,
	height = 0.3,
	unit_template = "shadow_skull_unit",
	air_spawning_distance = 20,
	perception = "perception_all_seeing",
	inside_wall_spawn_distance = -1,
	far_off_despawn_immunity = true,
	impact_explosion_name = "homing_skull_impact",
	behavior = "shadow_skull",
	base_unit = "units/props/blk/blk_curse_shadow_homing_skull_01",
	trueflight_lock_radius = 1.5,
	threat_value = 10,
	ignore_activate_unit = true,
	max_health = {
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3
	},
	infighting = InfightingSettings.small,
	debug_color = {
		255,
		255,
		255,
		255
	},
	hit_zones = {
		full = {
			prio = 1,
			actors = {
				"detailed"
			},
			push_actors = {
				"c_skull",
				"c_jaw"
			}
		},
		head = {
			prio = 2,
			actors = {
				"detailed"
			},
			push_actors = {
				"c_skull",
				"c_jaw"
			}
		},
		neck = {
			prio = 3,
			actors = {
				"detailed"
			},
			push_actors = {
				"c_skull",
				"c_jaw"
			}
		},
		torso = {
			prio = 4,
			actors = {
				"detailed"
			},
			push_actors = {
				"c_skull",
				"c_jaw"
			}
		}
	},
	modify_extension_init_data = function (arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = arg_1_0.impact_explosion_name
		local var_1_1 = arg_1_0.collision_detection_sphere_radius
		local var_1_2 = arg_1_0.only_one_impact
		local var_1_3 = arg_1_0.impact_collision_filter
		local var_1_4 = arg_1_0.impact_template_name
		local var_1_5 = "n/a"
		local var_1_6 = arg_1_2.projectile_impact_system or {}

		var_1_6.sphere_radius = var_1_1
		var_1_6.only_one_impact = var_1_2
		var_1_6.collision_filter = var_1_3
		arg_1_2.projectile_impact_system = var_1_6

		local var_1_7 = arg_1_2.projectile_system or {}

		var_1_7.damage_source = var_1_5
		var_1_7.impact_template_name = var_1_4
		var_1_7.explosion_template_name = var_1_0
		arg_1_2.projectile_system = var_1_7
	end,
	debug_spawn_optional_data = {
		prepare_func = function (arg_2_0, arg_2_1)
			local var_2_0 = false

			arg_2_0.modify_extension_init_data(arg_2_0, var_2_0, arg_2_1)
		end
	}
}

Breeds.shadow_skull = table.create_copy(Breeds.shadow_skull, var_0_0)
