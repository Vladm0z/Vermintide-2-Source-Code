-- chunkname: @scripts/settings/dlcs/morris/greed_pinata_settings.lua

local var_0_0 = {
	spawn_pickup_at_unit = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		return Managers.state.entity:system("pickup_system"):buff_spawn_pickup(arg_1_0, arg_1_1, true, "spawn_pickup")
	end,
	spawn_ignited_barrel_at_unit = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		local var_2_0 = Quaternion.identity()
		local var_2_1 = AiAnimUtils.position_network_scale(arg_2_1, true)
		local var_2_2 = AiAnimUtils.rotation_network_scale(var_2_0, true)
		local var_2_3 = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local var_2_4 = arg_2_2.explode_time or 3
		local var_2_5 = arg_2_2.fuse_time or 3
		local var_2_6 = Managers.time:time("game")
		local var_2_7 = {
			explode_time = var_2_6 + var_2_4,
			fuse_time = var_2_5,
			attacker_unit_id = arg_2_3
		}
		local var_2_8 = {
			projectile_locomotion_system = {
				network_position = var_2_1,
				network_rotation = var_2_2,
				network_velocity = var_2_3,
				network_angular_velocity = var_2_3
			},
			death_system = {
				in_hand = false,
				death_data = var_2_7,
				item_name = arg_2_0
			},
			health_system = {
				damage = 1,
				health_data = var_2_7,
				item_name = arg_2_0
			},
			pickup_system = {
				has_physics = true,
				spawn_type = "loot",
				pickup_name = arg_2_0
			}
		}
		local var_2_9 = AllPickups[arg_2_0]
		local var_2_10 = var_2_9.unit_name
		local var_2_11 = var_2_9.unit_template_name or "pickup_unit"

		return Managers.state.unit_spawner:spawn_network_unit(var_2_10, var_2_11, var_2_8, arg_2_1, var_2_0)
	end
}

GreedPinataSettings = {
	total_drops = 3,
	possible_drops = {
		first_aid_kit = {
			drop_weight = 6,
			spawn_function = var_0_0.spawn_pickup_at_unit
		},
		healing_draught = {
			drop_weight = 6,
			spawn_function = var_0_0.spawn_pickup_at_unit
		},
		frag_grenade_t2 = {
			drop_weight = 8,
			spawn_function = var_0_0.spawn_pickup_at_unit
		},
		fire_grenade_t2 = {
			drop_weight = 8,
			spawn_function = var_0_0.spawn_pickup_at_unit
		},
		friendly_murderer_potion = {
			drop_weight = 5,
			spawn_function = var_0_0.spawn_pickup_at_unit
		},
		killer_in_the_shadows_potion = {
			drop_weight = 5,
			spawn_function = var_0_0.spawn_pickup_at_unit
		},
		hold_my_beer_potion = {
			drop_weight = 5,
			spawn_function = var_0_0.spawn_pickup_at_unit
		},
		pockets_full_of_bombs_potion = {
			drop_weight = 1,
			spawn_function = var_0_0.spawn_pickup_at_unit
		},
		vampiric_draught_potion = {
			drop_weight = 5,
			spawn_function = var_0_0.spawn_pickup_at_unit
		},
		all_ammo_small = {
			drop_weight = 25,
			spawn_function = var_0_0.spawn_pickup_at_unit
		},
		deus_soft_currency = {
			drop_weight = 40,
			spawn_function = var_0_0.spawn_pickup_at_unit
		},
		lamp_oil = {
			drop_weight = 8,
			pickup_data = {
				fuse_time = 3,
				explode_time = 3
			},
			spawn_function = var_0_0.spawn_ignited_barrel_at_unit
		},
		explosive_barrel = {
			drop_weight = 8,
			pickup_data = {
				fuse_time = 3,
				explode_time = 3
			},
			spawn_function = var_0_0.spawn_ignited_barrel_at_unit
		}
	}
}

local var_0_1 = 0

for iter_0_0, iter_0_1 in pairs(GreedPinataSettings.possible_drops) do
	var_0_1 = var_0_1 + iter_0_1.drop_weight
end

for iter_0_2, iter_0_3 in pairs(GreedPinataSettings.possible_drops) do
	iter_0_3.drop_weight = iter_0_3.drop_weight / var_0_1
end
