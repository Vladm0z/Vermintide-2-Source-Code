-- chunkname: @scripts/settings/dlcs/morris/greed_pinata_settings.lua

local tbl = {
	spawn_pickup_at_unit = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		-- function 1
		return Managers.state.entity:system("pickup_system"):buff_spawn_pickup(arg_1_0, arg_1_1, true, "spawn_pickup")
	end,
	spawn_ignited_barrel_at_unit = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		local identity = Quaternion.identity()
		local position_network_scale = AiAnimUtils.position_network_scale(arg_2_1, true)
		local rotation_network_scale = AiAnimUtils.rotation_network_scale(identity, true)
		local velocity_network_scale = AiAnimUtils.velocity_network_scale(Vector3(0, 0, 0), true)
		local explode_time = arg_2_2.explode_time

		explode_time = explode_time or 3

		local fuse_time = arg_2_2.fuse_time

		fuse_time = fuse_time or 3

		local time = Managers.time:time("game")
		local tbl = {
			explode_time = time + explode_time,
			fuse_time = fuse_time,
			attacker_unit_id = arg_2_3
		}
		local tbl_2 = {
			projectile_locomotion_system = {
				network_position = position_network_scale,
				network_rotation = rotation_network_scale,
				network_velocity = velocity_network_scale,
				network_angular_velocity = velocity_network_scale
			},
			death_system = {
				in_hand = false,
				death_data = tbl,
				item_name = arg_2_0
			},
			health_system = {
				damage = 1,
				health_data = tbl,
				item_name = arg_2_0
			},
			pickup_system = {
				has_physics = true,
				spawn_type = "loot",
				pickup_name = arg_2_0
			}
		}
		local var_2_9 = AllPickups[arg_2_0]
		local unit_name = var_2_9.unit_name
		local unit_template_name = var_2_9.unit_template_name

		unit_template_name = unit_template_name or "pickup_unit"

		return Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, tbl_2, arg_2_1, identity)
	end
}

GreedPinataSettings = {
	total_drops = 3,
	possible_drops = {
		first_aid_kit = {
			drop_weight = 6,
			spawn_function = tbl.spawn_pickup_at_unit
		},
		healing_draught = {
			drop_weight = 6,
			spawn_function = tbl.spawn_pickup_at_unit
		},
		frag_grenade_t2 = {
			drop_weight = 8,
			spawn_function = tbl.spawn_pickup_at_unit
		},
		fire_grenade_t2 = {
			drop_weight = 8,
			spawn_function = tbl.spawn_pickup_at_unit
		},
		friendly_murderer_potion = {
			drop_weight = 5,
			spawn_function = tbl.spawn_pickup_at_unit
		},
		killer_in_the_shadows_potion = {
			drop_weight = 5,
			spawn_function = tbl.spawn_pickup_at_unit
		},
		hold_my_beer_potion = {
			drop_weight = 5,
			spawn_function = tbl.spawn_pickup_at_unit
		},
		pockets_full_of_bombs_potion = {
			drop_weight = 1,
			spawn_function = tbl.spawn_pickup_at_unit
		},
		vampiric_draught_potion = {
			drop_weight = 5,
			spawn_function = tbl.spawn_pickup_at_unit
		},
		all_ammo_small = {
			drop_weight = 25,
			spawn_function = tbl.spawn_pickup_at_unit
		},
		deus_soft_currency = {
			drop_weight = 40,
			spawn_function = tbl.spawn_pickup_at_unit
		},
		lamp_oil = {
			drop_weight = 8,
			pickup_data = {
				fuse_time = 3,
				explode_time = 3
			},
			spawn_function = tbl.spawn_ignited_barrel_at_unit
		},
		explosive_barrel = {
			drop_weight = 8,
			pickup_data = {
				fuse_time = 3,
				explode_time = 3
			},
			spawn_function = tbl.spawn_ignited_barrel_at_unit
		}
	}
}

local num = 0

for k, v in pairs(GreedPinataSettings.possible_drops) do
	num = num + v.drop_weight
end

for k_2, v_2 in pairs(GreedPinataSettings.possible_drops) do
	v_2.drop_weight = v_2.drop_weight / num
end
