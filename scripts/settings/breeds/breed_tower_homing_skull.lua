-- chunkname: @scripts/settings/breeds/breed_tower_homing_skull.lua

local tbl = {
	detection_radius = 9999999,
	aoe_height = 0.2,
	walk_speed = 1.5,
	flesh_material = "stone",
	debug_spawn_func_name = "aim_spawning_air",
	race = "chaos",
	poison_resistance = 100,
	exchange_order = 1,
	not_bot_target = true,
	animation_sync_rpc = "rpc_sync_anim_state_1",
	run_speed = 1,
	impact_template_name = "no_owner_direct_impact",
	impact_collision_filter = "filter_ray_projectile_enemy",
	debug_spawn_category = "Misc",
	is_bot_threat = false,
	target_head_node = "c_skull",
	debug_despawn_immunity = false,
	hit_reaction = "ai_ethereal_skull_knock_back",
	target_selection = "pick_closest_target",
	death_reaction = "tower_homing_skull",
	only_one_impact = true,
	air_spawning_distance = 20,
	hit_effect_template = "HitEffectsShadowSkull",
	collision_detection_sphere_radius = 0.2,
	radius = 1,
	unit_template = "ethereal_skull_unit",
	no_blood_splatter_on_damage = true,
	bot_threat_start_time = 0,
	no_autoaim = true,
	perception = "perception_all_seeing",
	inside_wall_spawn_distance = -1,
	far_off_despawn_immunity = true,
	impact_explosion_name = "ethereal_skull_impact",
	behavior = "tower_homing_skull",
	base_unit = "units/beings/enemies/undead_ethereal_skeleton/chr_undead_ethereal_skeleton_skull",
	threat_value = 0,
	ignore_activate_unit = true,
	max_health = BreedTweaks.max_health.marauder,
	infighting = InfightingSettings.small,
	size_variation_range = {
		1,
		1
	},
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
				"c_hitbox"
			},
			push_actors = {
				"c_skull",
				"c_jaw"
			}
		},
		head = {
			prio = 2,
			actors = {
				"c_hitbox"
			},
			push_actors = {
				"c_skull",
				"c_jaw"
			}
		},
		neck = {
			prio = 3,
			actors = {
				"c_hitbox"
			},
			push_actors = {
				"c_skull",
				"c_jaw"
			}
		},
		torso = {
			prio = 4,
			actors = {
				"c_hitbox"
			},
			push_actors = {
				"c_skull",
				"c_jaw"
			}
		}
	},
	modify_extension_init_data = function (self, arg_1_1, arg_1_2)
		-- function 1
		local impact_explosion_name = self.impact_explosion_name
		local collision_detection_sphere_radius = self.collision_detection_sphere_radius
		local only_one_impact = self.only_one_impact
		local impact_collision_filter = self.impact_collision_filter
		local impact_template_name = self.impact_template_name
		local str = "n/a"
		local projectile_impact_system = arg_1_2.projectile_impact_system

		projectile_impact_system = projectile_impact_system or {}
		projectile_impact_system.sphere_radius = collision_detection_sphere_radius
		projectile_impact_system.only_one_impact = only_one_impact
		projectile_impact_system.collision_filter = impact_collision_filter
		arg_1_2.projectile_impact_system = projectile_impact_system

		local projectile_system = arg_1_2.projectile_system

		projectile_system = projectile_system or {}
		projectile_system.damage_source = str
		projectile_system.impact_template_name = impact_template_name
		projectile_system.explosion_template_name = impact_explosion_name
		arg_1_2.projectile_system = projectile_system
	end,
	debug_spawn_optional_data = {
		prepare_func = function (self, arg_2_1)
			-- function 2
			local flag = false

			self.modify_extension_init_data(self, flag, arg_2_1)
		end
	}
}

Breeds.tower_homing_skull = table.create_copy(Breeds.tower_homing_skull, tbl)
