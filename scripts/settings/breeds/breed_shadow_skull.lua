-- chunkname: @scripts/settings/breeds/breed_shadow_skull.lua

local tbl = {
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

Breeds.shadow_skull = table.create_copy(Breeds.shadow_skull, tbl)
