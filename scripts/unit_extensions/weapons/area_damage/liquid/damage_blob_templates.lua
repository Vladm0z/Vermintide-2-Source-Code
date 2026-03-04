-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/damage_blob_templates.lua

DamageBlobTemplates = {}
DamageBlobTemplates.templates = {
	warpfire = {
		fx_separation_dist = 0.8,
		time_of_life = 5,
		fx_max_height = 5,
		sfx_name_start = "Play_enemy_warpfire_thrower_fire_hit_ground",
		sfx_name_stop_remains = "Stop_enemy_stormfiend_fire_ground_loop",
		nav_cost_map_cost_type = "warpfire_thrower_warpfire",
		blob_life_time = 4,
		buff_template_name = "warpfire_thrower_ground_base",
		blob_radius = 1,
		fx_name_rim = "fx/wpnfx_warp_fire_remains_rim",
		apply_buff_to_player = true,
		blob_separation_dist = 2,
		init_function = "warpfire_thrower_fire_init",
		fx_name_filled = "fx/chr_warp_fire_flamethrower_remains_01",
		apply_buff_to_ai = true,
		create_blobs = true,
		fx_size_variable = "warp_fire_flamethrower_remains_size",
		update_function = "warpfire_thrower_fire_update",
		use_nav_cost_map_volumes = true,
		buff_template_type = "stormfiend_warpfire_ground",
		sfx_name_stop = "Stop_enemy_warpfire_thrower_fire_hit_ground",
		fx_max_radius = 5,
		sfx_name_start_remains = "Play_enemy_stormfiend_fire_ground_loop",
		immune_breeds = {
			chaos_troll = true,
			chaos_spawn = true,
			skaven_warpfire_thrower = true,
			skaven_rat_ogre = true,
			chaos_plague_wave_spawner = true,
			skaven_stormfiend = true
		}
	},
	warpfire_vs = {
		fx_separation_dist = 0.8,
		time_of_life = 5,
		fx_max_height = 5,
		sfx_name_start = "Play_enemy_warpfire_thrower_fire_hit_ground",
		sfx_name_stop_remains = "Stop_enemy_stormfiend_fire_ground_loop",
		nav_cost_map_cost_type = "warpfire_thrower_warpfire",
		blob_life_time = 4,
		buff_template_name = "warpfire_thrower_ground_base",
		blob_radius = 1,
		fx_name_rim = "fx/wpnfx_warp_fire_remains_rim",
		apply_buff_to_player = true,
		blob_separation_dist = 2,
		fx_name_filled = "fx/chr_warp_fire_flamethrower_remains_01",
		apply_buff_to_ai = true,
		create_blobs = false,
		fx_size_variable = "warp_fire_flamethrower_remains_size",
		use_nav_cost_map_volumes = true,
		buff_template_type = "stormfiend_warpfire_ground",
		sfx_name_stop = "Stop_enemy_warpfire_thrower_fire_hit_ground",
		fx_max_radius = 5,
		sfx_name_start_remains = "Play_enemy_stormfiend_fire_ground_loop",
		immune_breeds = {
			chaos_troll = true,
			chaos_spawn = true,
			skaven_warpfire_thrower = true,
			skaven_rat_ogre = true,
			chaos_plague_wave_spawner = true,
			skaven_stormfiend = true
		}
	}
}

DamageBlobTemplates.warpfire_thrower_fire_init = function (arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0._source_unit

	if Unit.alive(var_1_0) then
		local var_1_1 = ScriptUnit.extension(var_1_0, "ai_inventory_system")
		local var_1_2 = Breeds.skaven_warpfire_thrower.default_inventory_template
		local var_1_3 = var_1_1:get_unit(var_1_2)

		arg_1_0._warpfire_gun_unit = var_1_3

		local var_1_4 = BreedActions.skaven_warpfire_thrower.shoot_warpfire_thrower
		local var_1_5 = var_1_4.muzzle_node
		local var_1_6 = Unit.node(var_1_3, var_1_5)

		arg_1_0._muzzle_node = var_1_6

		local var_1_7 = arg_1_0.world
		local var_1_8 = "fx/chr_warp_fire_flamethrower_01"
		local var_1_9 = World.create_particles(var_1_7, var_1_8, Vector3.zero(), Quaternion.identity())

		World.link_particles(var_1_7, var_1_9, var_1_3, var_1_6, Matrix4x4.identity(), "stop")

		arg_1_0._warpfire_particle_id = var_1_9
		arg_1_0._firing_time_deadline = arg_1_1 + var_1_4.firing_time
		arg_1_0._particle_life_time = Vector3Box(1, 0, 0)
	end
end

DamageBlobTemplates.warpfire_thrower_fire_update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._warpfire_gun_unit
	local var_2_1 = arg_2_0._warpfire_particle_id
	local var_2_2 = Unit.alive(var_2_0)
	local var_2_3 = arg_2_0._firing_time_deadline
	local var_2_4 = arg_2_0.aborted
	local var_2_5 = arg_2_0.world

	if var_2_2 and arg_2_1 < var_2_3 and not var_2_4 then
		local var_2_6 = arg_2_0._muzzle_node
		local var_2_7 = Unit.world_position(var_2_0, var_2_6)
		local var_2_8 = POSITION_LOOKUP[arg_2_3]
		local var_2_9 = var_2_8 - var_2_7
		local var_2_10 = Vector3.length(var_2_9)
		local var_2_11 = Vector3(var_2_7.x, var_2_7.y, var_2_7.z + 0.1)
		local var_2_12 = Vector3.normalize(var_2_9)
		local var_2_13 = "fx/chr_warp_fire_flamethrower_01"
		local var_2_14 = World.find_particles_variable(var_2_5, var_2_13, "firepoint_1")

		World.set_particles_variable(var_2_5, var_2_1, var_2_14, var_2_11 + var_2_12 * 0.1)

		local var_2_15 = World.find_particles_variable(var_2_5, var_2_13, "firepoint_2")

		World.set_particles_variable(var_2_5, var_2_1, var_2_15, var_2_8 - Vector3.up())

		local var_2_16 = World.find_particles_variable(var_2_5, var_2_13, "firelife_1")
		local var_2_17

		var_2_17.x, var_2_17 = var_2_10 / 4, arg_2_0._particle_life_time:unbox()

		World.set_particles_variable(var_2_5, var_2_1, var_2_16, var_2_17)

		return true
	else
		if var_2_1 then
			World.stop_spawning_particles(var_2_5, var_2_1)

			arg_2_0._warpfire_particle_id = nil
		end

		return false
	end
end

DamageBlobTemplates.warpfire_thrower_fire_init_vs = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0._source_unit

	if Unit.alive(var_3_0) then
		local var_3_1 = BLACKBOARDS[var_3_0].weapon_unit

		arg_3_0._warpfire_gun_unit = var_3_1

		local var_3_2 = Unit.alive(var_3_1)

		arg_3_0._attack_range = Unit.get_data(arg_3_0._source_unit, "breed").shoot_warpfire_attack_range

		if var_3_2 then
			local var_3_3 = "fx/chr_warp_fire_flamethrower_01"
			local var_3_4 = ScriptUnit.has_extension(var_3_0, "first_person_system")

			if var_3_4 and var_3_4:first_person_mode_active() then
				var_3_3 = "fx/chr_warp_fire_flamethrower_01_1p_versus"
			end

			local var_3_5 = "p_fx"
			local var_3_6 = Unit.node(var_3_1, var_3_5)

			arg_3_0._muzzle_node = var_3_6

			local var_3_7 = arg_3_0.world
			local var_3_8 = World.create_particles(var_3_7, var_3_3, Vector3.zero(), Quaternion.identity())

			World.link_particles(var_3_7, var_3_8, var_3_1, var_3_6, Matrix4x4.identity(), "stop")

			arg_3_0._warpfire_particle_id = var_3_8
			arg_3_0._particle_life_time = Vector3Box(1, 0, 0)
		end
	end
end

local var_0_0 = 2
local var_0_1 = 4

DamageBlobTemplates.warpfire_thrower_fire_update_vs = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_0._warpfire_gun_unit
	local var_4_1 = arg_4_0._warpfire_particle_id
	local var_4_2 = Unit.alive(var_4_0)
	local var_4_3 = arg_4_0.aborted
	local var_4_4 = arg_4_0.world

	if var_4_2 and not var_4_3 then
		local var_4_5 = arg_4_0._muzzle_node
		local var_4_6 = Unit.world_position(var_4_0, var_4_5)
		local var_4_7 = POSITION_LOOKUP[arg_4_3]
		local var_4_8 = Vector3(var_4_6.x, var_4_6.y, var_4_6.z + 0.1)
		local var_4_9 = Managers.state.unit_storage:go_id(arg_4_0._source_unit)
		local var_4_10 = Managers.state.network:game()
		local var_4_11 = GameSession.game_object_field(var_4_10, var_4_9, "aim_direction")
		local var_4_12 = "filter_bot_ranged_line_of_sight_no_allies"
		local var_4_13 = arg_4_0._attack_range * 2
		local var_4_14 = PhysicsWorld.raycast(arg_4_4, var_4_6, var_4_11, var_4_13, "all", "types", "both", "all", "collision_filter", var_4_12)
		local var_4_15 = arg_4_0._attack_range

		if var_4_14 then
			for iter_4_0 = 1, #var_4_14 do
				local var_4_16 = var_4_14[iter_4_0][var_0_1]
				local var_4_17 = Actor.unit(var_4_16)
				local var_4_18 = var_4_17 and Unit.get_data(var_4_17, "breed")

				if (not var_4_18 or var_4_18.boss) and var_4_15 > var_4_14[iter_4_0][var_0_0] then
					var_4_15 = var_4_14[iter_4_0][var_0_0]

					break
				end
			end
		end

		local var_4_19 = "fx/chr_warp_fire_flamethrower_01"
		local var_4_20 = arg_4_0._source_unit
		local var_4_21 = ScriptUnit.has_extension(var_4_20, "first_person_system")

		if var_4_21 and var_4_21:first_person_mode_active() then
			var_4_19 = "fx/chr_warp_fire_flamethrower_01_1p_versus"
		end

		local var_4_22 = World.find_particles_variable(var_4_4, var_4_19, "firepoint_1")

		World.set_particles_variable(var_4_4, var_4_1, var_4_22, var_4_8 + var_4_11 * 0.1)

		local var_4_23 = World.find_particles_variable(var_4_4, var_4_19, "firepoint_2")

		World.set_particles_variable(var_4_4, var_4_1, var_4_23, var_4_7 - Vector3.up())

		local var_4_24 = World.find_particles_variable(var_4_4, var_4_19, "firelife_1")
		local var_4_25

		var_4_25.x, var_4_25 = var_4_15 * 0.5, arg_4_0._particle_life_time:unbox()

		World.set_particles_variable(var_4_4, var_4_1, var_4_24, var_4_25)

		return true
	else
		if var_4_1 then
			World.stop_spawning_particles(var_4_4, var_4_1)

			arg_4_0._warpfire_particle_id = nil
		end

		return false
	end
end
