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

DamageBlobTemplates.warpfire_thrower_fire_init = function (self, arg_1_1)
	-- function 1
	local _source_unit = self._source_unit

	if not Unit.alive(_source_unit) then
		local extension = ScriptUnit.extension(_source_unit, "ai_inventory_system")
		local default_inventory_template = Breeds.skaven_warpfire_thrower.default_inventory_template
		local get_unit = extension:get_unit(default_inventory_template)

		self._warpfire_gun_unit = get_unit

		local shoot_warpfire_thrower = BreedActions.skaven_warpfire_thrower.shoot_warpfire_thrower
		local muzzle_node = shoot_warpfire_thrower.muzzle_node
		local node = Unit.node(get_unit, muzzle_node)

		self._muzzle_node = node

		local world = self.world
		local str = "fx/chr_warp_fire_flamethrower_01"
		local create_particles = World.create_particles(world, str, Vector3.zero(), Quaternion.identity())

		World.link_particles(world, create_particles, get_unit, node, Matrix4x4.identity(), "stop")

		self._warpfire_particle_id = create_particles
		self._firing_time_deadline = arg_1_1 + shoot_warpfire_thrower.firing_time
		self._particle_life_time = Vector3Box(1, 0, 0)
	end
end

DamageBlobTemplates.warpfire_thrower_fire_update = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local _warpfire_gun_unit = self._warpfire_gun_unit
	local _warpfire_particle_id = self._warpfire_particle_id
	local alive = Unit.alive(_warpfire_gun_unit)
	local _firing_time_deadline = self._firing_time_deadline
	local aborted = self.aborted
	local world = self.world

	if not (not alive and not (arg_2_1 < _firing_time_deadline) or aborted) then
		local _muzzle_node = self._muzzle_node
		local world_position = Unit.world_position(_warpfire_gun_unit, _muzzle_node)
		local var_2_8 = POSITION_LOOKUP[arg_2_3]
		local num = var_2_8 - world_position
		local length = Vector3.length(num)
		local var_2_11 = Vector3(world_position.x, world_position.y, world_position.z + 0.1)
		local normalize = Vector3.normalize(num)
		local str = "fx/chr_warp_fire_flamethrower_01"
		local find_particles_variable = World.find_particles_variable(world, str, "firepoint_1")

		World.set_particles_variable(world, _warpfire_particle_id, find_particles_variable, var_2_11 + normalize * 0.1)

		local find_particles_variable_2 = World.find_particles_variable(world, str, "firepoint_2")

		World.set_particles_variable(world, _warpfire_particle_id, find_particles_variable_2, var_2_8 - Vector3.up())

		local find_particles_variable_3 = World.find_particles_variable(world, str, "firelife_1")
		local unbox

		unbox.x, unbox = length / 4, self._particle_life_time:unbox()

		World.set_particles_variable(world, _warpfire_particle_id, find_particles_variable_3, unbox)

		return true
	else
		if not _warpfire_particle_id then
			World.stop_spawning_particles(world, _warpfire_particle_id)

			self._warpfire_particle_id = nil
		end

		return false
	end
end

DamageBlobTemplates.warpfire_thrower_fire_init_vs = function (self, arg_3_1)
	-- function 3
	local _source_unit = self._source_unit

	if not Unit.alive(_source_unit) then
		local weapon_unit = BLACKBOARDS[_source_unit].weapon_unit

		self._warpfire_gun_unit = weapon_unit

		local alive = Unit.alive(weapon_unit)

		self._attack_range = Unit.get_data(self._source_unit, "breed").shoot_warpfire_attack_range

		if not alive then
			local str = "fx/chr_warp_fire_flamethrower_01"
			local has_extension = ScriptUnit.has_extension(_source_unit, "first_person_system")

			if not has_extension and not has_extension:first_person_mode_active() then
				str = "fx/chr_warp_fire_flamethrower_01_1p_versus"
			end

			local str_2 = "p_fx"
			local node = Unit.node(weapon_unit, str_2)

			self._muzzle_node = node

			local world = self.world
			local create_particles = World.create_particles(world, str, Vector3.zero(), Quaternion.identity())

			World.link_particles(world, create_particles, weapon_unit, node, Matrix4x4.identity(), "stop")

			self._warpfire_particle_id = create_particles
			self._particle_life_time = Vector3Box(1, 0, 0)
		end
	end
end

local num = 2
local num_2 = 4

DamageBlobTemplates.warpfire_thrower_fire_update_vs = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local _warpfire_gun_unit = self._warpfire_gun_unit
	local _warpfire_particle_id = self._warpfire_particle_id
	local alive = Unit.alive(_warpfire_gun_unit)
	local aborted = self.aborted
	local world = self.world

	if not (not alive and aborted) then
		local _muzzle_node = self._muzzle_node
		local world_position = Unit.world_position(_warpfire_gun_unit, _muzzle_node)
		local var_4_7 = POSITION_LOOKUP[arg_4_3]
		local var_4_8 = Vector3(world_position.x, world_position.y, world_position.z + 0.1)
		local go_id = Managers.state.unit_storage:go_id(self._source_unit)
		local game = Managers.state.network:game()
		local game_object_field = GameSession.game_object_field(game, go_id, "aim_direction")
		local str = "filter_bot_ranged_line_of_sight_no_allies"
		local num_3 = self._attack_range * 2
		local raycast = PhysicsWorld.raycast(arg_4_4, world_position, game_object_field, num_3, "all", "types", "both", "all", "collision_filter", str)
		local _attack_range = self._attack_range

		if not raycast then
			for i = 1, #raycast do
				local var_4_16 = raycast[i][num_2]
				local unit = Actor.unit(var_4_16)
				local flag = not unit and Unit.get_data(unit, "breed")

				if not (not (not flag and flag.boss) and not (_attack_range > raycast[i][num])) then
					_attack_range = raycast[i][num]

					break
				end
			end
		end

		local str_2 = "fx/chr_warp_fire_flamethrower_01"
		local _source_unit = self._source_unit
		local has_extension = ScriptUnit.has_extension(_source_unit, "first_person_system")

		if not has_extension and not has_extension:first_person_mode_active() then
			str_2 = "fx/chr_warp_fire_flamethrower_01_1p_versus"
		end

		local find_particles_variable = World.find_particles_variable(world, str_2, "firepoint_1")

		World.set_particles_variable(world, _warpfire_particle_id, find_particles_variable, var_4_8 + game_object_field * 0.1)

		local find_particles_variable_2 = World.find_particles_variable(world, str_2, "firepoint_2")

		World.set_particles_variable(world, _warpfire_particle_id, find_particles_variable_2, var_4_7 - Vector3.up())

		local find_particles_variable_3 = World.find_particles_variable(world, str_2, "firelife_1")
		local unbox

		unbox.x, unbox = _attack_range * 0.5, self._particle_life_time:unbox()

		World.set_particles_variable(world, _warpfire_particle_id, find_particles_variable_3, unbox)

		return true
	else
		if not _warpfire_particle_id then
			World.stop_spawning_particles(world, _warpfire_particle_id)

			self._warpfire_particle_id = nil
		end

		return false
	end
end
