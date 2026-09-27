-- chunkname: @scripts/settings/breeds/breed_training_dummy.lua

local num = 2
local tbl = {
	detection_radius = 12,
	bot_melee_aim_node = "j_neck",
	target_selection = "pick_closest_target",
	exchange_order = 1,
	run_speed = 3,
	death_reaction = "level_object",
	flesh_material = "stone",
	hit_effect = "fx/hit_metal",
	flingable = false,
	not_bot_target = true,
	animation_sync_rpc = "rpc_sync_anim_state_1",
	player_locomotion_constrain_radius = 0.7,
	smart_targeting_width = 0.2,
	smart_targeting_height_multiplier = 3.5,
	no_blood = true,
	target_head_node = "j_neck",
	armor_category = 1,
	hit_reaction = "dummy",
	poison_resistance = 70,
	race = "dummy",
	cannot_be_aggroed = true,
	disallow_additional_healthbar = true,
	threat_value = 0,
	smart_targeting_outer_width = 0.6,
	awards_positive_reinforcement_message = true,
	hit_effect_template = "HitEffectsTrainingDummy",
	ignore_breed_limits = true,
	show_health_bar = true,
	radius = 1,
	no_stagger_duration = true,
	unit_template = "ai_unit_training_dummy_bob",
	hit_mass_count = 40,
	healthbar_timeout = 10,
	display_name = "dummy_description",
	perception_previous_attacker_stickyness_value = 0,
	no_blood_splatter_on_damage = true,
	proximity_system_check = true,
	perception = "perception_regular",
	no_debug_spawn = true,
	height = 2,
	bone_lod_level = 0,
	smart_object_template = "special",
	weapon_reach = 1,
	far_off_despawn_immunity = true,
	target_selection_alerted = "pick_closest_target_infinte_range",
	override_bot_target_node = "j_neck",
	vortexable = false,
	bloodlust_health = 0,
	disable_local_hit_reactions = true,
	behavior = "training_dummy",
	base_unit = "units/gameplay/training_dummy/training_dummy_bob",
	aoe_height = 1.5,
	has_inventory = false,
	infighting = InfightingSettings.small,
	max_health = {
		25 * num,
		25 * num,
		37.5 * num,
		50 * num,
		75 * num,
		75 * num,
		75 * num,
		75 * num,
		25 * num
	},
	hit_mass_counts = BreedTweaks.hit_mass_counts.marauder,
	stagger_duration = {
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1
	},
	debug_color = {
		255,
		100,
		200,
		200
	},
	hitzone_multiplier_types = {
		head = "headshot"
	},
	hit_zones = {
		head = {
			prio = 1,
			actors = {
				"c_head"
			}
		},
		neck = {
			prio = 1,
			actors = {
				"c_head"
			}
		},
		torso = {
			prio = 2,
			actors = {
				"c_hips",
				"c_spine",
				"c_torso"
			},
			push_actors = {
				"c_spine"
			}
		},
		left_arm = {
			prio = 3,
			actors = {
				"c_leftarm"
			}
		},
		right_arm = {
			prio = 3,
			actors = {
				"c_rightarm"
			}
		},
		aux = {
			prio = 4,
			actors = {
				"c_base_simple"
			}
		},
		full = {
			prio = 4,
			actors = {}
		},
		afro = {
			prio = 5,
			actors = {
				"c_afro"
			}
		}
	},
	modify_extension_init_data = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
		-- function 1
		local projectile_locomotion_system = arg_1_1.projectile_locomotion_system

		projectile_locomotion_system = projectile_locomotion_system or {}

		local network_position = arg_1_1.network_position

		network_position = network_position or AiAnimUtils.position_network_scale(arg_1_3, true)
		projectile_locomotion_system.network_position = network_position

		local network_rotation = arg_1_1.network_rotation

		network_rotation = network_rotation or AiAnimUtils.rotation_network_scale(arg_1_4, true)
		projectile_locomotion_system.network_rotation = network_rotation

		local network_velocity = arg_1_1.network_velocity

		network_velocity = network_velocity or AiAnimUtils.velocity_network_scale(Vector3.zero(), true)
		projectile_locomotion_system.network_velocity = network_velocity

		local network_angular_velocity = arg_1_1.network_angular_velocity

		network_angular_velocity = network_angular_velocity or AiAnimUtils.velocity_network_scale(Vector3.zero(), true)
		projectile_locomotion_system.network_angular_velocity = network_angular_velocity
		arg_1_1.projectile_locomotion_system = projectile_locomotion_system

		local pickup_system = arg_1_1.pickup_system

		pickup_system = pickup_system or {}
		pickup_system.has_physics = false
		pickup_system.spawn_type = "debug"
		pickup_system.pickup_name = "training_dummy_bob"
		arg_1_1.pickup_system = pickup_system
	end,
	debug_spawn_optional_data = {
		prepare_func = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
			-- function 2
			self.modify_extension_init_data(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		end
	}
}

Breeds.training_dummy = table.create_copy(Breeds.training_dummy, tbl)

local tbl_2 = {
	dummy_idle = {},
	stagger = {
		stagger_anims = {
			{
				fwd = {
					"stagger_light_bwd"
				},
				bwd = {
					"stagger_light_fwd"
				},
				left = {
					"stagger_light_left"
				},
				right = {
					"stagger_light_right"
				}
			},
			{
				fwd = {
					"stagger_light_bwd"
				},
				bwd = {
					"stagger_light_fwd"
				},
				left = {
					"stagger_light_left"
				},
				right = {
					"stagger_light_right"
				}
			},
			{
				fwd = {
					"stagger_heavy_bwd"
				},
				bwd = {
					"stagger_heavy_fwd"
				},
				left = {
					"stagger_heavy_left"
				},
				right = {
					"stagger_heavy_right"
				}
			},
			{
				fwd = {
					"stagger_light_bwd"
				},
				bwd = {
					"stagger_light_fwd"
				},
				left = {
					"stagger_light_left"
				},
				right = {
					"stagger_light_right"
				}
			},
			{
				fwd = {
					"stagger_heavy_bwd"
				},
				bwd = {
					"stagger_heavy_fwd"
				},
				left = {
					"stagger_heavy_left"
				},
				right = {
					"stagger_heavy_right"
				}
			},
			{
				fwd = {
					"stagger_heavy_bwd"
				},
				bwd = {
					"stagger_heavy_fwd"
				},
				left = {
					"stagger_heavy_left"
				},
				right = {
					"stagger_heavy_right"
				}
			},
			{
				fwd = {
					"stagger_heavy_bwd"
				},
				bwd = {
					"stagger_heavy_fwd"
				},
				left = {
					"stagger_heavy_left"
				},
				right = {
					"stagger_heavy_right"
				}
			},
			{
				fwd = {},
				bwd = {},
				left = {},
				right = {}
			},
			{
				fwd = {
					"stagger_heavy_bwd"
				},
				bwd = {
					"stagger_heavy_fwd"
				},
				left = {
					"stagger_light_left"
				},
				right = {
					"stagger_heavy_right"
				}
			}
		}
	}
}

BreedActions.training_dummy = table.create_copy(BreedActions.training_dummy, tbl_2)
