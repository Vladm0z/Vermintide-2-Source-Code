-- chunkname: @scripts/unit_extensions/weapons/area_damage/liquid/damage_blob_husk_extension.lua

DamageBlobHuskExtension = class(DamageBlobHuskExtension)

DamageBlobHuskExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world

	self.world = world
	self.game = Managers.state.network:game()
	self.unit = arg_1_2
	self.nav_world = Managers.state.entity:system("ai_system"):nav_world()
	self._source_unit = arg_1_3.source_unit
	self.physics_world = World.physics_world(world)
	self.go_id = Managers.state.unit_storage:go_id(arg_1_2)
	self.fx_list = {}
	self.sfx_list = {}

	local damage_blob_template_name = arg_1_3.damage_blob_template_name
	local var_1_2 = DamageBlobTemplates.templates[damage_blob_template_name]

	self.fx_name_filled = var_1_2.fx_name_filled
	self.fx_name_rim = var_1_2.fx_name_rim
	self.fx_size_variable = var_1_2.fx_size_variable
	self.fx_max_height = var_1_2.fx_max_height
	self.fx_max_radius = var_1_2.fx_max_radius
	self.blob_life_time = var_1_2.blob_life_time
	self._sfx_name_stop = var_1_2.sfx_name_stop
	self._sfx_name_start_remains = var_1_2.sfx_name_start_remains
	self._sfx_name_stop_remains = var_1_2.sfx_name_stop_remains

	local init_function = var_1_2.init_function

	if not init_function then
		local time = Managers.time:time("game")

		DamageBlobTemplates[init_function](self, time)
	end

	local update_function = var_1_2.update_function

	if not update_function then
		self._blob_update_function = DamageBlobTemplates[update_function]
	end

	local sfx_name_start = var_1_2.sfx_name_start

	if not sfx_name_start then
		WwiseUtils.trigger_unit_event(world, sfx_name_start, arg_1_2, 0)
	end
end

DamageBlobHuskExtension.destroy = function (self)
	-- function 2
	local world = self.world
	local fx_list = self.fx_list

	for i = 1, #fx_list do
		local id = fx_list[i].id

		World.stop_spawning_particles(world, id)

		fx_list[i] = nil
	end

	local unit = self.unit
	local _sfx_name_stop = self._sfx_name_stop

	if not _sfx_name_stop and not Unit.alive(unit) then
		WwiseUtils.trigger_unit_event(world, _sfx_name_stop, unit, 0)
	end

	local wwise_world = Managers.world:wwise_world(world)
	local sfx_list = self.sfx_list

	for j = 1, #sfx_list do
		local source = sfx_list[j].source

		if not WwiseWorld.has_source(wwise_world, source) then
			WwiseWorld.trigger_event(wwise_world, self._sfx_name_stop_remains, source)
		end

		sfx_list[j] = nil
	end

	self.aborted = true
end

DamageBlobHuskExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local game = self.game
	local go_id = self.go_id
	local game_object_field = GameSession.game_object_field(game, go_id, "position")

	Unit.set_local_position(arg_3_1, 0, game_object_field)

	local game_object_field_2 = GameSession.game_object_field(game, go_id, "rotation")

	Unit.set_local_rotation(arg_3_1, 0, game_object_field_2)
	self:update_blobs_fx_and_sfx(arg_3_5, arg_3_3)

	if not (not self._blob_update_function and self._blob_update_function(self, arg_3_5, arg_3_3, arg_3_1, self.physics_world)) then
		self._blob_update_function = nil
	end
end

DamageBlobHuskExtension.update_blobs_fx_and_sfx = function (self, arg_4_1, arg_4_2)
	-- function 4
	local world = self.world
	local fx_name_filled = self.fx_name_filled
	local fx_size_variable = self.fx_size_variable
	local fx_max_radius = self.fx_max_radius
	local fx_max_height = self.fx_max_height
	local fx_list = self.fx_list

	for i = 1, #fx_list do
		local var_4_6 = fx_list[i]
		local id = var_4_6.id
		local size = var_4_6.size

		if not size then
			local unbox = size:unbox()

			unbox[1] = math.min(unbox[1] + arg_4_2 * 1.5, fx_max_radius)
			unbox[2] = math.min(unbox[2] + arg_4_2 * 2, fx_max_height)

			local find_particles_variable = World.find_particles_variable(world, fx_name_filled, fx_size_variable)

			World.set_particles_variable(world, id, find_particles_variable, unbox)
			size:store(unbox)
		end

		if arg_4_1 > var_4_6.time then
			World.stop_spawning_particles(world, id)
		end
	end

	local sfx_list = self.sfx_list
	local _sfx_name_stop_remains = self._sfx_name_stop_remains
	local wwise_world = Managers.world:wwise_world(self.world)

	for j = 1, #sfx_list do
		local var_4_14 = sfx_list[j]
		local source = var_4_14.source
		local has_source = WwiseWorld.has_source(wwise_world, source)

		if not (arg_4_1 > var_4_14.time) or not has_source then
			WwiseWorld.trigger_event(wwise_world, _sfx_name_stop_remains, source)
		end
	end
end

DamageBlobHuskExtension.add_damage_blob_fx = function (self, arg_5_1, arg_5_2)
	-- function 5
	local unit = self.unit
	local world = self.world
	local local_rotation = Unit.local_rotation(unit, 0)
	local time = Managers.time:time("game")
	local blob_life_time = self.blob_life_time
	local num = arg_5_2 * blob_life_time
	local max = math.max(blob_life_time - num, 0)
	local num_2 = time + num
	local var_5_8 = Vector3Box(0.6, 1.2, 0)
	local fx_max_radius = self.fx_max_radius
	local fx_max_height = self.fx_max_height

	var_5_8[1] = math.min(var_5_8[1] + max * 1.5, fx_max_radius)
	var_5_8[2] = math.min(var_5_8[2] + max * 2, fx_max_height)

	print(arg_5_2, num)

	local fx_list = self.fx_list
	local create_particles = World.create_particles(world, self.fx_name_filled, arg_5_1, local_rotation)

	fx_list[#fx_list + 1] = {
		id = create_particles,
		time = num_2,
		size = var_5_8
	}

	local create_particles_2 = World.create_particles(world, self.fx_name_rim, arg_5_1, local_rotation)

	fx_list[#fx_list + 1] = {
		id = create_particles_2,
		time = num_2
	}

	if not DEDICATED_SERVER then
		local trigger_position_event, var_5_15 = WwiseUtils.trigger_position_event(world, self._sfx_name_start_remains, arg_5_1)
		local sfx_list = self.sfx_list

		sfx_list[#sfx_list + 1] = {
			source = var_5_15,
			time = num_2
		}
	end
end

DamageBlobHuskExtension.abort = function (self)
	-- function 6
	local unit = self.unit
	local _sfx_name_stop = self._sfx_name_stop

	if not _sfx_name_stop and not Unit.alive(unit) then
		WwiseUtils.trigger_unit_event(self.world, _sfx_name_stop, unit, 0)
	end

	self.aborted = true
end

DamageBlobHuskExtension.get_source_attacker_unit = function (self)
	-- function 7
	return self._source_unit
end
